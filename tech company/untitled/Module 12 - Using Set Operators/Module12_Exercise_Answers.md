# Module 12 Exercise Answers

## Overview

This document provides complete solutions and explanations for all exercises and lab tasks in Module 12 - Using Set Operators. Each answer includes the SQL solution, business logic explanation, and alternative approaches where applicable.

---

## Exercise Answers

### Exercise 1: Basic UNION Operations

#### Task 1.1 Solution: Combine Employee Lists

```sql
-- Combine current and former employees for HR communication initiative
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    CASE 
        WHEN e.IsActive = 1 THEN 'Current'
        ELSE 'Former'
    END AS EmploymentStatus,
    e.BaseSalary,
    CASE 
        WHEN e.IsActive = 1 THEN e.HireDate
        ELSE DATEADD(DAY, RAND() * 180, DATEADD(MONTH, -6, GETDATE())) -- Estimated end date
    END AS LastWorkDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION

SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    'Former' AS EmploymentStatus,
    e.BaseSalary,
    DATEADD(DAY, RAND() * 180, DATEADD(MONTH, -6, GETDATE())) AS LastWorkDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 0
AND e.EmployeeID IN (
    -- Simulate former employees who left in last 6 months
    SELECT TOP 10 EmployeeID 
    FROM Employees 
    WHERE IsActive = 0 
    ORDER BY EmployeeID DESC
)

ORDER BY DepartmentName, EmployeeName;
```

**Business Logic**: This query combines current employees with recent former employees, providing HR with a comprehensive contact list for company-wide communications.

#### Task 1.2 Solution: Project and Order Revenue Analysis

```sql
-- Combined revenue analysis from projects and orders
WITH ProjectRevenue AS (
    SELECT 
        'Project' AS RevenueSource,
        p.ProjectName AS SourceName,
        p.Budget AS Amount,
        p.StartDate AS RevenueDate,
        'Project Budget' AS RevenueType
    FROM Projects p
    WHERE p.IsActive = 1
    AND p.Budget > 0
),
OrderRevenue AS (
    SELECT 
        'Order' AS RevenueSource,
        'Order #' + CAST(o.OrderID AS VARCHAR(10)) AS SourceName,
        o.TotalAmount AS Amount,
        o.OrderDate AS RevenueDate,
        'Direct Sale' AS RevenueType
    FROM Orders o
    WHERE o.IsActive = 1
    AND o.TotalAmount > 0
)

SELECT 
    combined_revenue.RevenueSource,
    combined_revenue.SourceName,
    combined_revenue.Amount,
    combined_revenue.RevenueDate,
    combined_revenue.RevenueType,
    SUM(combined_revenue.Amount) OVER (
        PARTITION BY combined_revenue.RevenueSource 
        ORDER BY combined_revenue.RevenueDate 
        ROWS UNBOUNDED PRECEDING
    ) AS RunningTotal,
    RANK() OVER (
        PARTITION BY combined_revenue.RevenueSource 
        ORDER BY combined_revenue.Amount DESC
    ) AS RevenueRank
FROM (
    SELECT * FROM ProjectRevenue
    UNION
    SELECT * FROM OrderRevenue
) AS combined_revenue
ORDER BY combined_revenue.RevenueSource, combined_revenue.RevenueDate;
```

**Business Logic**: This query provides management with a unified view of all revenue sources, including running totals and rankings to identify top contributors.

---

### Exercise 2: UNION ALL for Performance

#### Task 2.1 Solution: Comprehensive Activity Log

```sql
-- Comprehensive activity log using UNION ALL
SELECT 
    activity_log.ActivityType,
    activity_log.EmployeeName,
    activity_log.ActivityDate,
    activity_log.ActivityValue,
    activity_log.Description,
    COUNT(*) OVER (PARTITION BY activity_log.EmployeeID) AS TotalActivities,
    AVG(activity_log.ActivityValue) OVER (PARTITION BY activity_log.EmployeeID) AS AvgActivityValue,
    CASE 
        WHEN COUNT(*) OVER (PARTITION BY activity_log.EmployeeID) >= 10 THEN 'Highly Active'
        WHEN COUNT(*) OVER (PARTITION BY activity_log.EmployeeID) >= 5 THEN 'Active'
        ELSE 'Low Activity'
    END AS ActivityLevel
FROM (
    -- Project Activities
    SELECT 
        'Project Work' AS ActivityType,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        ep.StartDate AS ActivityDate,
        ep.HoursWorked AS ActivityValue,
        'Project: ' + p.ProjectName + ' (' + ep.Role + ')' AS Description
    FROM EmployeeProjects ep
    INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.IsActive = 1
    AND e.IsActive = 1
    AND p.IsActive = 1

    UNION ALL

    -- Order Activities
    SELECT 
        'Order Processing' AS ActivityType,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        o.OrderDate AS ActivityDate,
        o.TotalAmount AS ActivityValue,
        'Order #' + CAST(o.OrderID AS VARCHAR(10)) + ' for ' + c.CompanyName AS Description
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.IsActive = 1
    AND e.IsActive = 1
    AND c.IsActive = 1

    UNION ALL

    -- Training Activities (simulated)
    SELECT 
        'Training' AS ActivityType,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        DATEADD(DAY, (e.EmployeeID % 30), DATEADD(MONTH, -3, GETDATE())) AS ActivityDate,
        40.0 AS ActivityValue, -- Standard training hours
        'Professional Development Training' AS Description
    FROM Employees e
    WHERE e.IsActive = 1
    AND e.EmployeeID % 3 = 0 -- Every third employee has training
) AS activity_log
ORDER BY activity_log.EmployeeName, activity_log.ActivityDate;
```

**Business Logic**: This query creates a comprehensive activity log that captures all employee activities, preserving duplicates for accurate activity tracking and performance analysis.

#### Task 2.2 Solution: Department Budget Allocation Analysis

```sql
-- Department budget allocation analysis using UNION ALL
WITH BudgetAllocations AS (
    -- Salary Allocations
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        'Salary' AS AllocationType,
        SUM(e.BaseSalary) AS Amount,
        'Q1 2024' AS Period,
        COUNT(e.EmployeeID) AS AllocationCount
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE d.IsActive = 1 AND e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName

    UNION ALL

    -- Project Allocations
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        'Project' AS AllocationType,
        SUM(p.Budget) / 4 AS Amount, -- Quarterly allocation
        'Q1 2024' AS Period,
        COUNT(p.ProjectID) AS AllocationCount
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE d.IsActive = 1 AND e.IsActive = 1 AND p.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName

    UNION ALL

    -- Operational Costs (estimated)
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        'Operational' AS AllocationType,
        d.Budget * 0.15 AS Amount, -- 15% of department budget
        'Q1 2024' AS Period,
        1 AS AllocationCount
    FROM Departments d
    WHERE d.IsActive = 1
    AND d.Budget > 0

    UNION ALL

    -- Training Budget
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        'Training' AS AllocationType,
        COUNT(e.EmployeeID) * 2000 AS Amount, -- $2000 per employee
        'Q1 2024' AS Period,
        COUNT(e.EmployeeID) AS AllocationCount
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE d.IsActive = 1 AND e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
)

SELECT 
    ba.DepartmentName,
    ba.AllocationType,
    ba.Amount,
    ba.Period,
    ba.AllocationCount,
    SUM(ba.Amount) OVER (PARTITION BY ba.DepartmentID) AS TotalDepartmentAllocation,
    FORMAT(ba.Amount / SUM(ba.Amount) OVER (PARTITION BY ba.DepartmentID) * 100, 'N1') + '%' AS AllocationPercentage,
    CASE 
        WHEN ba.AllocationType = 'Salary' AND ba.Amount / SUM(ba.Amount) OVER (PARTITION BY ba.DepartmentID) > 0.7 
            THEN 'High Salary Dependency'
        WHEN ba.AllocationType = 'Project' AND ba.Amount / SUM(ba.Amount) OVER (PARTITION BY ba.DepartmentID) > 0.4 
            THEN 'Project Heavy'
        ELSE 'Balanced Allocation'
    END AS AllocationProfile
FROM BudgetAllocations ba
ORDER BY ba.DepartmentName, ba.Amount DESC;
```

**Business Logic**: This analysis provides finance with detailed budget allocation patterns, including percentage distributions and allocation profiles for strategic planning.

---

### Exercise 3: EXCEPT Operations

#### Task 3.1 Solution: Identify Underutilized Employees

```sql
-- Find employees not assigned to recent projects
WITH ActiveEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
),
RecentProjectEmployees AS (
    SELECT DISTINCT ep.EmployeeID
    FROM EmployeeProjects ep
    WHERE ep.IsActive = 1
    AND ep.StartDate >= DATEADD(MONTH, -6, GETDATE())
)

SELECT 
    ae.EmployeeID,
    ae.EmployeeName,
    ae.JobTitle,
    ae.DepartmentName,
    ae.BaseSalary,
    ae.YearsOfService,
    CASE 
        WHEN ae.YearsOfService < 1 THEN 'New Employee - Onboarding'
        WHEN ae.BaseSalary > 75000 THEN 'Senior Resource - Critical Underutilization'
        WHEN ae.YearsOfService > 5 THEN 'Experienced Resource - Potential Reassignment'
        ELSE 'Standard Resource - Training Opportunity'
    END AS UtilizationStatus,
    CASE 
        WHEN ae.YearsOfService < 1 THEN 'Assign to mentorship program and starter projects'
        WHEN ae.BaseSalary > 75000 THEN 'Immediate project assignment required'
        WHEN ae.YearsOfService > 5 THEN 'Consider cross-department opportunities'
        ELSE 'Provide additional training and skill development'
    END AS Recommendation
FROM ActiveEmployees ae
WHERE ae.EmployeeID NOT IN (SELECT EmployeeID FROM RecentProjectEmployees)
ORDER BY ae.BaseSalary DESC, ae.YearsOfService DESC;

-- Alternative using EXCEPT operator
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

EXCEPT

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1
AND ep.IsActive = 1
AND ep.StartDate >= DATEADD(MONTH, -6, GETDATE());
```

**Business Logic**: This query identifies employees not assigned to recent projects, providing HR with insights for resource optimization and career development planning.

#### Task 3.2 Solution: Customer Retention Analysis

```sql
-- Identify customers with declining activity using EXCEPT
WITH LastYearCustomers AS (
    SELECT DISTINCT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.City,
        c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.IsActive = 1
    AND o.OrderDate >= DATEADD(YEAR, -1, DATEADD(YEAR, -1, GETDATE()))
    AND o.OrderDate < DATEADD(YEAR, -1, GETDATE())
),
ThisYearCustomers AS (
    SELECT DISTINCT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.City,
        c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.IsActive = 1
    AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
)

SELECT 
    lyc.CustomerID,
    lyc.CompanyName,
    lyc.ContactName,
    lyc.City,
    lyc.Country,
    last_order_info.LastOrderDate,
    last_order_info.LastOrderAmount,
    last_order_info.TotalOrdersLastYear,
    last_order_info.TotalRevenueLastYear,
    CASE 
        WHEN last_order_info.TotalRevenueLastYear >= 50000 THEN 'High Risk - Premium Customer'
        WHEN last_order_info.TotalRevenueLastYear >= 25000 THEN 'Medium Risk - Valuable Customer'
        WHEN last_order_info.TotalOrdersLastYear >= 5 THEN 'Medium Risk - Frequent Customer'
        ELSE 'Low Risk - Occasional Customer'
    END AS RiskLevel,
    CASE 
        WHEN last_order_info.TotalRevenueLastYear >= 50000 THEN 'Immediate executive outreach required'
        WHEN last_order_info.TotalRevenueLastYear >= 25000 THEN 'Personal account manager contact'
        WHEN last_order_info.TotalOrdersLastYear >= 5 THEN 'Targeted retention campaign'
        ELSE 'Standard reactivation email campaign'
    END AS RetentionStrategy
FROM (
    -- Using EXCEPT to find customers active last year but not this year
    SELECT * FROM LastYearCustomers
    EXCEPT
    SELECT * FROM ThisYearCustomers
) AS lyc
CROSS APPLY (
    SELECT 
        MAX(o.OrderDate) AS LastOrderDate,
        MAX(CASE WHEN o.OrderDate = MAX(o.OrderDate) OVER() THEN o.TotalAmount END) AS LastOrderAmount,
        COUNT(o.OrderID) AS TotalOrdersLastYear,
        SUM(o.TotalAmount) AS TotalRevenueLastYear
    FROM Orders o
    WHERE o.CustomerID = lyc.CustomerID
    AND o.IsActive = 1
    AND o.OrderDate >= DATEADD(YEAR, -1, DATEADD(YEAR, -1, GETDATE()))
    AND o.OrderDate < DATEADD(YEAR, -1, GETDATE())
) AS last_order_info
ORDER BY last_order_info.TotalRevenueLastYear DESC;
```

**Business Logic**: This query identifies customers who were active last year but haven't placed orders this year, categorizing them by risk level for targeted retention campaigns.

---

### Exercise 4: INTERSECT Operations

#### Task 4.1 Solution: Cross-Department Collaboration Analysis

```sql
-- Find employees working across multiple departments using INTERSECT concept
WITH EmployeeDepartmentProjects AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.DepartmentID AS HomeDepartmentID,
        d_home.DepartmentName AS HomeDepartment,
        p.ProjectID,
        p.ProjectName,
        pm.DepartmentID AS ProjectDepartmentID,
        d_proj.DepartmentName AS ProjectDepartment,
        ep.HoursWorked,
        ep.Role
    FROM Employees e
    INNER JOIN Departments d_home ON e.DepartmentID = d_home.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    INNER JOIN Departments d_proj ON pm.DepartmentID = d_proj.DepartmentID
    WHERE e.IsActive = 1
    AND ep.IsActive = 1
    AND p.IsActive = 1
    AND e.DepartmentID != pm.DepartmentID -- Cross-department projects only
)

SELECT 
    collaboration_summary.EmployeeID,
    collaboration_summary.EmployeeName,
    collaboration_summary.HomeDepartment,
    collaboration_summary.CrossDeptProjectCount,
    collaboration_summary.TotalCrossDeptHours,
    collaboration_summary.DepartmentsWorkedWith,
    collaboration_summary.AverageHoursPerProject,
    CASE 
        WHEN collaboration_summary.CrossDeptProjectCount >= 5 THEN 'Exceptional Collaborator'
        WHEN collaboration_summary.CrossDeptProjectCount >= 3 THEN 'Strong Collaborator'
        WHEN collaboration_summary.CrossDeptProjectCount >= 2 THEN 'Good Collaborator'
        ELSE 'Emerging Collaborator'
    END AS CollaborationLevel,
    collaboration_summary.TotalCrossDeptHours * 50 AS EstimatedCollaborationValue -- $50/hour value
FROM (
    SELECT 
        edp.EmployeeID,
        edp.EmployeeName,
        edp.HomeDepartment,
        COUNT(DISTINCT edp.ProjectID) AS CrossDeptProjectCount,
        SUM(edp.HoursWorked) AS TotalCrossDeptHours,
        COUNT(DISTINCT edp.ProjectDepartmentID) AS DepartmentsWorkedWith,
        AVG(edp.HoursWorked) AS AverageHoursPerProject,
        STRING_AGG(DISTINCT edp.ProjectDepartment, ', ') AS CollaboratingDepartments
    FROM EmployeeDepartmentProjects edp
    GROUP BY edp.EmployeeID, edp.EmployeeName, edp.HomeDepartment
    HAVING COUNT(DISTINCT edp.ProjectDepartmentID) >= 2 -- Must work with at least 2 other departments
) AS collaboration_summary
ORDER BY collaboration_summary.CrossDeptProjectCount DESC, collaboration_summary.TotalCrossDeptHours DESC;

-- Top collaboration pairs using INTERSECT concept
SELECT 
    dept_pairs.Department1,
    dept_pairs.Department2,
    COUNT(DISTINCT dept_pairs.EmployeeID) AS SharedEmployees,
    COUNT(DISTINCT dept_pairs.ProjectID) AS SharedProjects,
    SUM(dept_pairs.HoursWorked) AS TotalCollaborationHours
FROM (
    SELECT DISTINCT
        d1.DepartmentName AS Department1,
        d2.DepartmentName AS Department2,
        edp.EmployeeID,
        edp.ProjectID,
        edp.HoursWorked
    FROM EmployeeDepartmentProjects edp
    INNER JOIN Departments d1 ON edp.HomeDepartmentID = d1.DepartmentID
    INNER JOIN Departments d2 ON edp.ProjectDepartmentID = d2.DepartmentID
    WHERE d1.DepartmentName < d2.DepartmentName -- Avoid duplicates
) AS dept_pairs
GROUP BY dept_pairs.Department1, dept_pairs.Department2
ORDER BY TotalCollaborationHours DESC;
```

**Business Logic**: This query identifies employees who work across departments, measuring their collaboration impact and identifying the most effective cross-department partnerships.

#### Task 4.2 Solution: High-Value Customer Identification

```sql
-- Find customers who are both high-volume AND high-value using INTERSECT
WITH HighVolumeCustomers AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.City,
        c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
    AND o.IsActive = 1
    GROUP BY c.CustomerID, c.CompanyName, c.ContactName, c.City, c.Country
    HAVING COUNT(o.OrderID) >= 10 -- High volume: 10+ orders
),
HighValueCustomers AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.City,
        c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
    AND o.IsActive = 1
    GROUP BY c.CustomerID, c.CompanyName, c.ContactName, c.City, c.Country
    HAVING SUM(o.TotalAmount) >= 100000 -- High value: $100K+ total
)

SELECT 
    vip_customers.CustomerID,
    vip_customers.CompanyName,
    vip_customers.ContactName,
    vip_customers.City,
    vip_customers.Country,
    customer_metrics.OrderCount,
    customer_metrics.TotalRevenue,
    customer_metrics.AverageOrderValue,
    customer_metrics.FirstOrderDate,
    customer_metrics.LastOrderDate,
    customer_metrics.CustomerLifetimeMonths,
    CASE 
        WHEN customer_metrics.TotalRevenue >= 500000 THEN 'Platinum VIP'
        WHEN customer_metrics.TotalRevenue >= 250000 THEN 'Gold VIP'
        WHEN customer_metrics.TotalRevenue >= 100000 THEN 'Silver VIP'
        ELSE 'Bronze VIP'
    END AS VIPTier,
    CASE 
        WHEN customer_metrics.TotalRevenue >= 500000 THEN 'Dedicated account team, quarterly business reviews'
        WHEN customer_metrics.TotalRevenue >= 250000 THEN 'Senior account manager, monthly check-ins'
        WHEN customer_metrics.TotalRevenue >= 100000 THEN 'Account manager assignment, quarterly reviews'
        ELSE 'Priority support, bi-annual reviews'
    END AS VIPProgram
FROM (
    -- Using INTERSECT to find customers in both high-volume and high-value categories
    SELECT * FROM HighVolumeCustomers
    INTERSECT
    SELECT * FROM HighValueCustomers
) AS vip_customers
CROSS APPLY (
    SELECT 
        COUNT(o.OrderID) AS OrderCount,
        SUM(o.TotalAmount) AS TotalRevenue,
        AVG(o.TotalAmount) AS AverageOrderValue,
        MIN(o.OrderDate) AS FirstOrderDate,
        MAX(o.OrderDate) AS LastOrderDate,
        DATEDIFF(MONTH, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifetimeMonths
    FROM Orders o
    WHERE o.CustomerID = vip_customers.CustomerID
    AND o.IsActive = 1
) AS customer_metrics
ORDER BY customer_metrics.TotalRevenue DESC;

-- VIP program impact analysis
SELECT 
    vip_analysis.VIPTier,
    COUNT(*) AS CustomerCount,
    SUM(vip_analysis.TotalRevenue) AS TierTotalRevenue,
    AVG(vip_analysis.TotalRevenue) AS AvgRevenuePerCustomer,
    SUM(vip_analysis.OrderCount) AS TotalOrders,
    AVG(vip_analysis.AverageOrderValue) AS TierAvgOrderValue
FROM (
    SELECT 
        customer_metrics.TotalRevenue,
        customer_metrics.OrderCount,
        customer_metrics.AverageOrderValue,
        CASE 
            WHEN customer_metrics.TotalRevenue >= 500000 THEN 'Platinum VIP'
            WHEN customer_metrics.TotalRevenue >= 250000 THEN 'Gold VIP'
            WHEN customer_metrics.TotalRevenue >= 100000 THEN 'Silver VIP'
            ELSE 'Bronze VIP'
        END AS VIPTier
    FROM (
        SELECT * FROM HighVolumeCustomers
        INTERSECT
        SELECT * FROM HighValueCustomers
    ) AS vip_customers
    CROSS APPLY (
        SELECT 
            COUNT(o.OrderID) AS OrderCount,
            SUM(o.TotalAmount) AS TotalRevenue,
            AVG(o.TotalAmount) AS AverageOrderValue
        FROM Orders o
        WHERE o.CustomerID = vip_customers.CustomerID
        AND o.IsActive = 1
    ) AS customer_metrics
) AS vip_analysis
GROUP BY vip_analysis.VIPTier
ORDER BY TierTotalRevenue DESC;
```

**Business Logic**: This query identifies customers who meet both high-volume and high-value criteria, creating a VIP customer program with tiered benefits based on customer value.

---

### Exercise 5: APPLY Operations

#### Task 5.1 Solution: Dynamic Employee Performance Analysis

```sql
-- Dynamic performance analysis using CROSS APPLY
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    
    -- Dynamic performance metrics based on role and tenure
    performance_metrics.ProjectCount,
    performance_metrics.TotalHours,
    performance_metrics.AvgHoursPerProject,
    performance_metrics.RevenueGenerated,
    performance_metrics.PerformanceScore,
    performance_metrics.PerformanceCategory,
    
    -- Personalized recommendations
    recommendations.ImprovementArea,
    recommendations.RecommendedAction,
    recommendations.NextReviewDate
    
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

-- Dynamic performance calculation based on employee characteristics
CROSS APPLY (
    SELECT 
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        SUM(ISNULL(ep.HoursWorked, 0)) AS TotalHours,
        AVG(ISNULL(ep.HoursWorked, 0)) AS AvgHoursPerProject,
        SUM(ISNULL(p.Budget, 0)) / 10 AS RevenueGenerated, -- Estimated contribution
        
        -- Performance score calculation varies by role and tenure
        CASE 
            WHEN e.JobTitle LIKE '%Senior%' OR e.JobTitle LIKE '%Lead%' THEN
                -- Senior roles: weighted heavily on project leadership and revenue
                (COUNT(DISTINCT ep.ProjectID) * 20) + 
                (SUM(ISNULL(ep.HoursWorked, 0)) / 100) + 
                (SUM(ISNULL(p.Budget, 0)) / 10000)
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN
                -- Experienced employees: balanced metrics
                (COUNT(DISTINCT ep.ProjectID) * 15) + 
                (SUM(ISNULL(ep.HoursWorked, 0)) / 80) + 
                (COUNT(DISTINCT ep.Role) * 10)
            ELSE
                -- Junior employees: focus on participation and learning
                (COUNT(DISTINCT ep.ProjectID) * 10) + 
                (SUM(ISNULL(ep.HoursWorked, 0)) / 60) + 
                (COUNT(DISTINCT ep.Role) * 15)
        END AS PerformanceScore,
        
        -- Performance categorization based on role expectations
        CASE 
            WHEN e.JobTitle LIKE '%Senior%' OR e.JobTitle LIKE '%Lead%' THEN
                CASE 
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 5 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 800 THEN 'Exceptional'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 3 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 500 THEN 'Exceeds Expectations'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 2 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 300 THEN 'Meets Expectations'
                    ELSE 'Below Expectations'
                END
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN
                CASE 
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 4 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 600 THEN 'Exceptional'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 3 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 400 THEN 'Exceeds Expectations'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 2 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 200 THEN 'Meets Expectations'
                    ELSE 'Below Expectations'
                END
            ELSE
                CASE 
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 3 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 300 THEN 'Exceptional'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 2 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 200 THEN 'Exceeds Expectations'
                    WHEN COUNT(DISTINCT ep.ProjectID) >= 1 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 100 THEN 'Meets Expectations'
                    ELSE 'Below Expectations'
                END
        END AS PerformanceCategory
        
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.EmployeeID = e.EmployeeID
    AND ep.IsActive = 1
    AND p.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
) AS performance_metrics

-- Dynamic recommendations based on performance and characteristics
CROSS APPLY (
    SELECT 
        -- Improvement area identification
        CASE 
            WHEN performance_metrics.PerformanceCategory = 'Below Expectations' THEN
                CASE 
                    WHEN performance_metrics.ProjectCount = 0 THEN 'Project Participation'
                    WHEN performance_metrics.AvgHoursPerProject < 50 THEN 'Project Engagement'
                    ELSE 'Skill Development'
                END
            WHEN performance_metrics.PerformanceCategory = 'Meets Expectations' THEN
                CASE 
                    WHEN e.JobTitle LIKE '%Senior%' AND performance_metrics.ProjectCount < 4 THEN 'Leadership Opportunities'
                    WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 THEN 'Advanced Projects'
                    ELSE 'Cross-Functional Experience'
                END
            ELSE 'Strategic Contributions'
        END AS ImprovementArea,
        
        -- Recommended actions
        CASE 
            WHEN performance_metrics.PerformanceCategory = 'Below Expectations' THEN
                CASE 
                    WHEN performance_metrics.ProjectCount = 0 THEN 'Immediate project assignment and mentoring'
                    WHEN performance_metrics.AvgHoursPerProject < 50 THEN 'Increase project involvement and set weekly goals'
                    ELSE 'Skills assessment and targeted training program'
                END
            WHEN performance_metrics.PerformanceCategory = 'Meets Expectations' THEN
                CASE 
                    WHEN e.JobTitle LIKE '%Senior%' THEN 'Assign project leadership role'
                    WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 THEN 'Consider for promotion track'
                    ELSE 'Cross-department project assignment'
                END
            WHEN performance_metrics.PerformanceCategory = 'Exceeds Expectations' THEN 'Recognition program and stretch assignments'
            ELSE 'Executive mentoring and succession planning'
        END AS RecommendedAction,
        
        -- Next review timing based on performance level
        CASE 
            WHEN performance_metrics.PerformanceCategory = 'Below Expectations' THEN DATEADD(MONTH, 1, GETDATE())
            WHEN performance_metrics.PerformanceCategory = 'Meets Expectations' THEN DATEADD(MONTH, 3, GETDATE())
            WHEN performance_metrics.PerformanceCategory = 'Exceeds Expectations' THEN DATEADD(MONTH, 6, GETDATE())
            ELSE DATEADD(YEAR, 1, GETDATE())
        END AS NextReviewDate
        
) AS recommendations

WHERE e.IsActive = 1
ORDER BY performance_metrics.PerformanceScore DESC, e.BaseSalary DESC;
```

**Business Logic**: This query provides dynamic performance analysis where evaluation criteria adapt based on employee role, tenure, and performance history, generating personalized improvement recommendations.

#### Task 5.2 Solution: Customer Segmentation with Dynamic Criteria

```sql
-- Dynamic customer segmentation using OUTER APPLY
SELECT 
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country,
    
    -- Customer metrics
    customer_metrics.OrderCount,
    customer_metrics.TotalRevenue,
    customer_metrics.AvgOrderValue,
    customer_metrics.DaysSinceLastOrder,
    customer_metrics.CustomerLifetimeMonths,
    
    -- Dynamic segmentation
    segmentation.PrimarySegment,
    segmentation.SecondarySegment,
    segmentation.RiskLevel,
    segmentation.GrowthPotential,
    
    -- Targeted strategies
    marketing_strategy.CampaignType,
    marketing_strategy.MessageFocus,
    marketing_strategy.ContactFrequency,
    marketing_strategy.ExpectedROI

FROM Customers c

-- Comprehensive customer metrics (using OUTER APPLY to include all customers)
OUTER APPLY (
    SELECT 
        ISNULL(COUNT(o.OrderID), 0) AS OrderCount,
        ISNULL(SUM(o.TotalAmount), 0) AS TotalRevenue,
        ISNULL(AVG(o.TotalAmount), 0) AS AvgOrderValue,
        ISNULL(DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()), 999) AS DaysSinceLastOrder,
        ISNULL(DATEDIFF(MONTH, MIN(o.OrderDate), GETDATE()), 0) AS CustomerLifetimeMonths,
        COUNT(DISTINCT YEAR(o.OrderDate)) AS ActiveYears
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
    AND o.IsActive = 1
) AS customer_metrics

-- Dynamic segmentation based on customer characteristics
CROSS APPLY (
    SELECT 
        -- Primary segmentation varies by country and order pattern
        CASE 
            WHEN c.Country IN ('USA', 'Canada') THEN
                CASE 
                    WHEN customer_metrics.TotalRevenue >= 100000 THEN 'North America Premium'
                    WHEN customer_metrics.OrderCount >= 10 THEN 'North America High Volume'
                    WHEN customer_metrics.OrderCount > 0 THEN 'North America Standard'
                    ELSE 'North America Prospect'
                END
            WHEN c.Country IN ('UK', 'Germany', 'France') THEN
                CASE 
                    WHEN customer_metrics.TotalRevenue >= 75000 THEN 'Europe Premium'
                    WHEN customer_metrics.OrderCount >= 8 THEN 'Europe High Volume'
                    WHEN customer_metrics.OrderCount > 0 THEN 'Europe Standard'
                    ELSE 'Europe Prospect'
                END
            ELSE
                CASE 
                    WHEN customer_metrics.TotalRevenue >= 50000 THEN 'International Premium'
                    WHEN customer_metrics.OrderCount >= 5 THEN 'International High Volume'
                    WHEN customer_metrics.OrderCount > 0 THEN 'International Standard'
                    ELSE 'International Prospect'
                END
        END AS PrimarySegment,
        
        -- Secondary segmentation based on behavior patterns
        CASE 
            WHEN customer_metrics.OrderCount = 0 THEN 'New Prospect'
            WHEN customer_metrics.DaysSinceLastOrder <= 30 THEN 'Active Buyer'
            WHEN customer_metrics.DaysSinceLastOrder <= 90 THEN 'Recent Buyer'
            WHEN customer_metrics.DaysSinceLastOrder <= 180 THEN 'Occasional Buyer'
            WHEN customer_metrics.DaysSinceLastOrder <= 365 THEN 'Dormant Customer'
            ELSE 'Lost Customer'
        END AS SecondarySegment,
        
        -- Risk assessment varies by segment
        CASE 
            WHEN customer_metrics.OrderCount = 0 THEN 'Low Risk'
            WHEN customer_metrics.DaysSinceLastOrder > 365 AND customer_metrics.TotalRevenue >= 50000 THEN 'Critical Risk'
            WHEN customer_metrics.DaysSinceLastOrder > 180 AND customer_metrics.TotalRevenue >= 25000 THEN 'High Risk'
            WHEN customer_metrics.DaysSinceLastOrder > 90 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS RiskLevel,
        
        -- Growth potential assessment
        CASE 
            WHEN customer_metrics.OrderCount = 0 THEN 'New Opportunity'
            WHEN customer_metrics.AvgOrderValue < 1000 AND customer_metrics.OrderCount >= 5 THEN 'Upsell Potential'
            WHEN customer_metrics.OrderCount < 5 AND customer_metrics.AvgOrderValue >= 2000 THEN 'Volume Growth Potential'
            WHEN customer_metrics.CustomerLifetimeMonths >= 12 AND customer_metrics.OrderCount >= 10 THEN 'Partnership Potential'
            ELSE 'Stable Customer'
        END AS GrowthPotential
        
) AS segmentation

-- Dynamic marketing strategy based on segmentation
CROSS APPLY (
    SELECT 
        -- Campaign type varies by segment and risk
        CASE 
            WHEN segmentation.PrimarySegment LIKE '%Premium%' AND segmentation.RiskLevel = 'Critical Risk' THEN 'Executive Retention'
            WHEN segmentation.PrimarySegment LIKE '%Premium%' AND segmentation.SecondarySegment = 'Active Buyer' THEN 'Premium Upsell'
            WHEN segmentation.SecondarySegment = 'New Prospect' THEN 'Welcome Series'
            WHEN segmentation.RiskLevel IN ('High Risk', 'Critical Risk') THEN 'Win-Back Campaign'
            WHEN segmentation.GrowthPotential = 'Upsell Potential' THEN 'Product Expansion'
            WHEN segmentation.GrowthPotential = 'Volume Growth Potential' THEN 'Frequency Campaign'
            ELSE 'Maintenance Campaign'
        END AS CampaignType,
        
        -- Message focus adapts to customer profile
        CASE 
            WHEN segmentation.PrimarySegment LIKE '%Premium%' THEN 'Exclusive benefits and premium service'
            WHEN segmentation.GrowthPotential = 'Partnership Potential' THEN 'Strategic partnership opportunities'
            WHEN segmentation.SecondarySegment = 'New Prospect' THEN 'Product education and value proposition'
            WHEN segmentation.RiskLevel IN ('High Risk', 'Critical Risk') THEN 'Relationship recovery and special offers'
            WHEN customer_metrics.AvgOrderValue >= 2000 THEN 'High-value solutions and consultation'
            ELSE 'Product benefits and competitive pricing'
        END AS MessageFocus,
        
        -- Contact frequency based on segment and risk
        CASE 
            WHEN segmentation.RiskLevel = 'Critical Risk' THEN 'Weekly - Personal Outreach'
            WHEN segmentation.PrimarySegment LIKE '%Premium%' THEN 'Bi-weekly - Account Management'
            WHEN segmentation.SecondarySegment = 'Active Buyer' THEN 'Monthly - Regular Touchpoint'
            WHEN segmentation.RiskLevel = 'High Risk' THEN 'Bi-weekly - Retention Focus'
            WHEN segmentation.SecondarySegment = 'New Prospect' THEN 'Weekly - Nurture Sequence'
            ELSE 'Quarterly - Maintenance Contact'
        END AS ContactFrequency,
        
        -- Expected ROI estimation
        CASE 
            WHEN segmentation.PrimarySegment LIKE '%Premium%' AND segmentation.RiskLevel = 'Low Risk' THEN '300-500%'
            WHEN segmentation.GrowthPotential = 'Partnership Potential' THEN '400-600%'
            WHEN segmentation.GrowthPotential LIKE '%Potential%' THEN '200-400%'
            WHEN segmentation.RiskLevel IN ('High Risk', 'Critical Risk') THEN '150-300%'
            WHEN segmentation.SecondarySegment = 'New Prospect' THEN '100-200%'
            ELSE '100-250%'
        END AS ExpectedROI
        
) AS marketing_strategy

WHERE c.IsActive = 1
ORDER BY customer_metrics.TotalRevenue DESC, segmentation.RiskLevel DESC;

-- Segmentation summary for strategic planning
SELECT 
    segmentation_summary.PrimarySegment,
    segmentation_summary.SecondarySegment,
    COUNT(*) AS CustomerCount,
    SUM(segmentation_summary.TotalRevenue) AS SegmentRevenue,
    AVG(segmentation_summary.TotalRevenue) AS AvgRevenuePerCustomer,
    COUNT(CASE WHEN segmentation_summary.RiskLevel IN ('High Risk', 'Critical Risk') THEN 1 END) AS AtRiskCustomers,
    COUNT(CASE WHEN segmentation_summary.GrowthPotential LIKE '%Potential%' THEN 1 END) AS GrowthOpportunities
FROM (
    -- Subquery with segmentation logic for summary
    SELECT 
        customer_metrics.TotalRevenue,
        CASE 
            WHEN c.Country IN ('USA', 'Canada') THEN
                CASE 
                    WHEN customer_metrics.TotalRevenue >= 100000 THEN 'North America Premium'
                    WHEN customer_metrics.OrderCount >= 10 THEN 'North America High Volume'
                    WHEN customer_metrics.OrderCount > 0 THEN 'North America Standard'
                    ELSE 'North America Prospect'
                END
            WHEN c.Country IN ('UK', 'Germany', 'France') THEN
                CASE 
                    WHEN customer_metrics.TotalRevenue >= 75000 THEN 'Europe Premium'
                    WHEN customer_metrics.OrderCount >= 8 THEN 'Europe High Volume'
                    WHEN customer_metrics.OrderCount > 0 THEN 'Europe Standard'
                    ELSE 'Europe Prospect'
                END
            ELSE 'International'
        END AS PrimarySegment,
        CASE 
            WHEN customer_metrics.OrderCount = 0 THEN 'New Prospect'
            WHEN customer_metrics.DaysSinceLastOrder <= 90 THEN 'Active'
            WHEN customer_metrics.DaysSinceLastOrder <= 365 THEN 'Dormant'
            ELSE 'Lost'
        END AS SecondarySegment,
        CASE 
            WHEN customer_metrics.DaysSinceLastOrder > 365 AND customer_metrics.TotalRevenue >= 50000 THEN 'Critical Risk'
            WHEN customer_metrics.DaysSinceLastOrder > 180 THEN 'High Risk'
            ELSE 'Low Risk'
        END AS RiskLevel,
        CASE 
            WHEN customer_metrics.AvgOrderValue < 1000 AND customer_metrics.OrderCount >= 5 THEN 'Upsell Potential'
            WHEN customer_metrics.OrderCount < 5 AND customer_metrics.AvgOrderValue >= 2000 THEN 'Volume Potential'
            ELSE 'Stable'
        END AS GrowthPotential
    FROM Customers c
    OUTER APPLY (
        SELECT 
            ISNULL(COUNT(o.OrderID), 0) AS OrderCount,
            ISNULL(SUM(o.TotalAmount), 0) AS TotalRevenue,
            ISNULL(AVG(o.TotalAmount), 0) AS AvgOrderValue,
            ISNULL(DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()), 999) AS DaysSinceLastOrder
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
        AND o.IsActive = 1
    ) AS customer_metrics
    WHERE c.IsActive = 1
) AS segmentation_summary
GROUP BY segmentation_summary.PrimarySegment, segmentation_summary.SecondarySegment
ORDER BY SegmentRevenue DESC;
```

**Business Logic**: This query creates dynamic customer segmentation where criteria adapt based on geographic location, order patterns, and customer behavior, generating targeted marketing strategies for each segment.

---

## Summary

These exercise answers demonstrate practical applications of all set operators in real business scenarios:

**UNION/UNION ALL**: Combining datasets for comprehensive reporting and analysis
**EXCEPT**: Identifying gaps, missing data, and declining trends  
**INTERSECT**: Finding common elements and high-value intersections
**APPLY**: Creating dynamic, row-by-row analysis with adaptive criteria

Each solution includes business context, performance considerations, and practical implementation techniques that TechCorp's development teams can use in production environments.