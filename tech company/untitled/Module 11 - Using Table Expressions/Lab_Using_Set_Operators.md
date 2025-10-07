# Lab: Using Set Operators

## Lab Overview

This comprehensive lab provides hands-on practice with T-SQL set operators: UNION/UNION ALL, EXCEPT, INTERSECT, and APPLY. You'll work through real TechCorp business scenarios that demonstrate the practical application of these operators for data consolidation, comparison, and advanced analysis. Each exercise builds upon previous knowledge while introducing increasingly complex business requirements.

## 🎯 Lab Objectives

By completing this lab, you will be able to:

- Use UNION and UNION ALL operators effectively for data consolidation
- Apply EXCEPT and INTERSECT for data comparison and analysis
- Implement CROSS APPLY and OUTER APPLY for complex per-row processing
- Combine multiple set operators to solve complex business problems
- Optimize set operator queries for performance
- Create comprehensive business intelligence reports using set operations

## 📋 TechCorp Database Schema Reference

**Primary Tables Used in This Lab:**

```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
EmployeeArchive: EmployeeID, FirstName, LastName, BaseSalary, DepartmentID, TerminationDate, Reason, IsActive
```

---

## Exercise 1: UNION Operations (Basic Level)

### 1.1 Data Consolidation Challenge

**Business Problem:** The HR department needs a comprehensive contact directory that includes both active employees and key customer contacts for emergency communication purposes.

**Your Task:** Create a unified contact list that combines employee and customer contact information with proper categorization.

**Expected Output Columns:**
- Contact Type (Employee/Customer)
- Full Name
- Email Address
- Organization
- Location
- Contact Category (Internal/External)

**Requirements:**
- Include only active records
- Use consistent formatting for names and locations
- Remove any duplicate email addresses
- Sort by contact type, then by name

```sql
-- Write your solution here:

-- Expected approach: UNION with proper column alignment and formatting
```

### 1.2 Historical Data Integration Challenge

**Business Problem:** Management wants to analyze total compensation costs including both current employees and recently terminated employees for budget planning.

**Your Task:** Create a comprehensive salary analysis that includes current employees and employees terminated within the last 12 months.

**Expected Output Columns:**
- Employee Status (Active/Terminated)
- Full Name
- Department Name
- Job Title
- Last Known Salary
- Employment Duration (in years)
- Status Date (Hire Date for active, Termination Date for terminated)

**Hint:** Use UNION ALL to preserve all records and calculate employment duration appropriately.

```sql
-- Write your solution here:

-- Expected approach: UNION ALL with date calculations and proper status handling
```

---

## Exercise 2: EXCEPT Operations (Intermediate Level)

### 2.1 Data Quality Analysis Challenge

**Business Problem:** The IT department suspects there are employees in the system who have never been assigned to any projects, which may indicate data quality issues or underutilized resources.

**Your Task:** Identify employees who exist in the employee database but have no project assignments.

**Expected Output Columns:**
- Employee Name
- Job Title
- Department Name
- Hire Date
- Years with Company
- Current Salary

**Requirements:**
- Include only active employees
- Show employees with zero project assignments
- Calculate years with company based on hire date
- Order by department, then by hire date

```sql
-- Write your solution here:

-- Expected approach: EXCEPT to find employees without project assignments
```

### 2.2 Business Rule Validation Challenge

**Business Problem:** TechCorp has a policy that all employees earning over $75,000 should have management responsibilities (direct reports). Find employees who violate this policy.

**Your Task:** Identify high-earning employees who should be managers based on salary but currently have no direct reports.

**Expected Output Columns:**
- Employee Name
- Current Salary
- Department Name
- Job Title
- Years with Company

**Hint:** Use EXCEPT to find high earners who are not in the manager list.

```sql
-- Write your solution here:

-- Expected approach: EXCEPT comparing high earners with current managers
```

---

## Exercise 3: INTERSECT Operations (Intermediate Level)

### 3.1 Multi-Skilled Employee Analysis Challenge

**Business Problem:** The project management office wants to identify versatile employees who have both project management experience AND customer-facing experience (order processing).

**Your Task:** Find employees who both manage projects and process customer orders.

**Expected Output Columns:**
- Employee Name
- Department Name
- Job Title
- Projects Managed
- Orders Processed
- Total Project Budget Managed
- Total Order Value Processed

**Requirements:**
- Include only active employees
- Show actual counts and totals for verification
- Order by total combined value (project budget + order value)

```sql
-- Write your solution here:

-- Expected approach: INTERSECT to find employees in both categories
```

### 3.2 Customer Behavior Analysis Challenge

**Business Problem:** The sales team wants to identify premium customers who have both high-value orders (>$5,000) AND high-frequency orders (>10 orders).

**Your Task:** Find customers who meet both premium criteria: high value AND high frequency.

**Expected Output Columns:**
- Company Name
- Contact Name
- Country
- Total Orders
- Highest Order Value
- Total Revenue Generated
- Customer Segment

**Hint:** Use INTERSECT to find customers who appear in both high-value and high-frequency lists.

```sql
-- Write your solution here:

-- Expected approach: INTERSECT with aggregated customer metrics
```

---

## Exercise 4: APPLY Operations (Advanced Level)

### 4.1 Top Performers Analysis Challenge

**Business Problem:** Senior management wants a department-by-department analysis showing the top 3 employees in each department based on a comprehensive performance score.

**Your Task:** Create a performance dashboard that shows the top 3 performers in each department using a weighted scoring system.

**Performance Scoring Criteria:**
- Salary percentile within department (30% weight)
- Number of projects managed (25% weight)
- Total orders processed (25% weight)
- Years of experience (20% weight)

**Expected Output Columns:**
- Department Name
- Employee Name
- Job Title
- Performance Score
- Performance Rank within Department
- Salary
- Projects Managed
- Orders Processed

**Requirements:**
- Use CROSS APPLY for top 3 per department
- Calculate composite performance scores
- Handle employees with no projects or orders appropriately

```sql
-- Write your solution here:

-- Expected approach: CROSS APPLY with complex scoring calculation
```

### 4.2 Customer Relationship Analysis Challenge

**Business Problem:** The customer success team needs detailed insights into customer relationships, including their order patterns, assigned employees, and trend analysis.

**Your Task:** Create a comprehensive customer analysis using APPLY operations to show detailed relationship metrics.

**Required Analysis per Customer:**
- Basic customer information
- Total lifetime value and order count
- Most recent order information
- Primary contact employee
- Year-over-year order trend
- Risk assessment

**Expected Output Columns:**
- Company Name
- Contact Name
- Country
- Total Orders
- Lifetime Value
- Last Order Date
- Days Since Last Order
- Primary Employee Contact
- YoY Order Growth %
- Risk Level

**Requirements:**
- Use OUTER APPLY to include all customers
- Calculate trend analysis comparing this year vs last year
- Assign risk levels based on ordering patterns
- Handle customers with no orders appropriately

```sql
-- Write your solution here:

-- Expected approach: OUTER APPLY with multiple metrics and trend analysis
```

---

## Exercise 5: Complex Set Operations (Advanced Level)

### 5.1 Multi-Dimensional Business Intelligence Challenge

**Business Problem:** Create an executive dashboard that combines multiple set operations to provide comprehensive business insights across all major business dimensions.

**Your Task:** Build a unified business metrics report that combines data from multiple sources using various set operators.

**Required Metrics Categories:**
- Employee metrics (count, average salary, top performers)
- Project metrics (active projects, budget utilization, completion rates)
- Sales metrics (order volume, revenue trends, customer metrics)
- Department metrics (performance comparisons, resource allocation)

**Expected Output Structure:**
- Metric Category
- Metric Name
- Current Value
- Comparison Value (previous period or benchmark)
- Variance
- Status (Excellent/Good/Needs Attention)

**Requirements:**
- Use UNION ALL to combine different metric categories
- Include comparison periods where applicable
- Apply consistent formatting and status classifications
- Order results by priority (critical metrics first)

```sql
-- Write your solution here:

-- Expected approach: Multiple UNION ALL with complex business logic
```

### 5.2 Comprehensive Data Validation Challenge

**Business Problem:** Implement a comprehensive data quality report that identifies various data integrity issues across the TechCorp database using set operations.

**Your Task:** Create a data quality dashboard that identifies multiple types of issues and inconsistencies.

**Data Quality Checks Required:**
- Orphaned records (employees without departments, projects without managers, etc.)
- Business rule violations (high earners without management, etc.)
- Missing relationships (employees without projects, customers without orders)
- Inconsistent data (email format issues, missing contact information)

**Expected Output Columns:**
- Issue Category
- Issue Description
- Affected Records Count
- Severity Level
- Sample Record (one example)
- Recommended Action

**Requirements:**
- Use appropriate set operators for each type of validation
- Prioritize issues by severity
- Provide actionable recommendations
- Include specific examples for each issue type

```sql
-- Write your solution here:

-- Expected approach: Complex combination of set operators for validation
```

---

## Exercise Solutions

### Solution 1.1: Data Consolidation Challenge

```sql
-- HR Department: Unified Contact Directory
SELECT 
    'Employee' AS ContactType,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.WorkEmail AS EmailAddress,
    d.DepartmentName AS Organization,
    d.Location AS Location,
    'Internal' AS ContactCategory
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.WorkEmail IS NOT NULL
  AND d.IsActive = 1

UNION

SELECT 
    'Customer' AS ContactType,
    c.ContactName AS FullName,
    c.WorkEmail AS EmailAddress,
    c.CompanyName AS Organization,
    c.City + CASE WHEN c.Country IS NOT NULL THEN ', ' + c.Country ELSE '' END AS Location,
    'External' AS ContactCategory
FROM Customers c
WHERE c.IsActive = 1
  AND c.WorkEmail IS NOT NULL

ORDER BY ContactType, FullName;
```

**Key Learning Points:**
- UNION automatically removes duplicate email addresses
- Consistent column naming and data types required
- Proper JOIN operations within each SELECT
- NULL handling for optional fields

### Solution 1.2: Historical Data Integration Challenge

```sql
-- Management: Comprehensive Salary Analysis
SELECT 
    'Active' AS EmployeeStatus,
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    e.JobTitle,
    FORMAT(e.BaseSalary, 'C') AS LastKnownSalary,
    CAST(DATEDIFF(DAY, e.HireDate, GETDATE()) / 365.25 AS DECIMAL(4,1)) AS EmploymentDurationYears,
    e.HireDate AS StatusDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1

UNION ALL

SELECT 
    'Terminated' AS EmployeeStatus,
    ea.FirstName + ' ' + ea.LastName AS FullName,
    d.DepartmentName,
    ea.JobTitle,
    FORMAT(ea.BaseSalary, 'C') AS LastKnownSalary,
    CAST(DATEDIFF(DAY, ea.HireDate, ea.TerminationDate) / 365.25 AS DECIMAL(4,1)) AS EmploymentDurationYears,
    ea.TerminationDate AS StatusDate
FROM EmployeeArchive ea
INNER JOIN Departments d ON ea.DepartmentID = d.DepartmentID
WHERE ea.TerminationDate >= DATEADD(MONTH, -12, GETDATE())
  AND d.IsActive = 1

ORDER BY EmployeeStatus, DepartmentName, FullName;
```

**Key Learning Points:**
- UNION ALL preserves all records including potential duplicates
- Different date calculations based on employee status
- Accurate employment duration calculations using DATEDIFF
- Consistent formatting across different data sources

### Solution 2.1: Data Quality Analysis Challenge

```sql
-- IT Department: Employees Without Project Assignments
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    FORMAT(e.HireDate, 'yyyy-MM-dd') AS HireDate,
    CAST(DATEDIFF(DAY, e.HireDate, GETDATE()) / 365.25 AS DECIMAL(4,1)) AS YearsWithCompany,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1

EXCEPT

SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    FORMAT(e.HireDate, 'yyyy-MM-dd') AS HireDate,
    CAST(DATEDIFF(DAY, e.HireDate, GETDATE()) / 365.25 AS DECIMAL(4,1)) AS YearsWithCompany,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1
  AND d.IsActive = 1
  AND ep.IsActive = 1

ORDER BY DepartmentName, HireDate;
```

**Key Learning Points:**
- EXCEPT finds records in first set but not in second set
- Exact column matching required including data types and formats
- Proper JOINs ensure data integrity
- Date formatting for consistent comparison

### Solution 2.2: Business Rule Validation Challenge

```sql
-- Policy Compliance: High Earners Without Management Responsibilities
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
    d.DepartmentName,
    e.JobTitle,
    CAST(DATEDIFF(DAY, e.HireDate, GETDATE()) / 365.25 AS DECIMAL(4,1)) AS YearsWithCompany
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > 75000
  AND e.IsActive = 1
  AND d.IsActive = 1

EXCEPT

SELECT 
    mgr.FirstName + ' ' + mgr.LastName AS EmployeeName,
    FORMAT(mgr.BaseSalary, 'C') AS CurrentSalary,
    d.DepartmentName,
    mgr.JobTitle,
    CAST(DATEDIFF(DAY, mgr.HireDate, GETDATE()) / 365.25 AS DECIMAL(4,1)) AS YearsWithCompany
FROM Employees mgr
INNER JOIN Departments d ON mgr.DepartmentID = d.DepartmentID
WHERE mgr.IsActive = 1
  AND d.IsActive = 1
  AND EXISTS (
      SELECT 1
      FROM Employees subordinate
      WHERE subordinate.ManagerID = mgr.EmployeeID
        AND subordinate.IsActive = 1
  )
  AND mgr.BaseSalary > 75000

ORDER BY CurrentSalary DESC, YearsWithCompany DESC;
```

**Key Learning Points:**
- EXCEPT helps identify policy violations
- EXISTS subquery for identifying managers
- Business rule implementation in SQL
- Consistent data formatting for accurate comparisons

### Solution 3.1: Multi-Skilled Employee Analysis Challenge

```sql
-- Project Management Office: Versatile Employees Analysis
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.JobTitle,
    (SELECT COUNT(DISTINCT p.ProjectID)
     FROM Projects p
     WHERE p.ProjectManagerID = e.EmployeeID
       AND p.IsActive = 1) AS ProjectsManaged,
    (SELECT COUNT(o.OrderID)
     FROM Orders o
     WHERE o.EmployeeID = e.EmployeeID
       AND o.IsActive = 1) AS OrdersProcessed,
    FORMAT((SELECT ISNULL(SUM(p.Budget), 0)
            FROM Projects p
            WHERE p.ProjectManagerID = e.EmployeeID
              AND p.IsActive = 1), 'C') AS TotalProjectBudgetManaged,
    FORMAT((SELECT ISNULL(SUM(o.TotalAmount), 0)
            FROM Orders o
            WHERE o.EmployeeID = e.EmployeeID
              AND o.IsActive = 1), 'C') AS TotalOrderValueProcessed
FROM (
    -- Employees who manage projects
    SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.DepartmentID
    FROM Employees e
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE e.IsActive = 1
      AND p.IsActive = 1

    INTERSECT

    -- Employees who process orders
    SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.DepartmentID
    FROM Employees e
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE e.IsActive = 1
      AND o.IsActive = 1
) e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.IsActive = 1
ORDER BY 
    ((SELECT ISNULL(SUM(p.Budget), 0) FROM Projects p WHERE p.ProjectManagerID = e.EmployeeID AND p.IsActive = 1) +
     (SELECT ISNULL(SUM(o.TotalAmount), 0) FROM Orders o WHERE o.EmployeeID = e.EmployeeID AND o.IsActive = 1)) DESC;
```

**Key Learning Points:**
- INTERSECT finds employees who appear in both categories
- Subqueries provide additional metrics for verification
- Complex ordering based on combined business value
- DISTINCT ensures proper set operation behavior

### Solution 3.2: Customer Behavior Analysis Challenge

```sql
-- Sales Team: Premium Customer Analysis
SELECT 
    c.CompanyName,
    c.ContactName,
    c.Country,
    (SELECT COUNT(o.OrderID)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID
       AND o.IsActive = 1) AS TotalOrders,
    FORMAT((SELECT MAX(o.TotalAmount)
            FROM Orders o
            WHERE o.CustomerID = c.CustomerID
              AND o.IsActive = 1), 'C') AS HighestOrderValue,
    FORMAT((SELECT SUM(o.TotalAmount)
            FROM Orders o
            WHERE o.CustomerID = c.CustomerID
              AND o.IsActive = 1), 'C') AS TotalRevenueGenerated,
    'Premium & Frequent' AS CustomerSegment
FROM (
    -- High-value customers (orders > $5,000)
    SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName, c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.TotalAmount > 5000
      AND c.IsActive = 1
      AND o.IsActive = 1

    INTERSECT

    -- High-frequency customers (>10 orders)
    SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName, c.Country
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
      AND o.IsActive = 1
    GROUP BY c.CustomerID, c.CompanyName, c.ContactName, c.Country
    HAVING COUNT(o.OrderID) > 10
) c
WHERE c.CompanyName IS NOT NULL
ORDER BY 
    (SELECT SUM(o.TotalAmount) FROM Orders o WHERE o.CustomerID = c.CustomerID AND o.IsActive = 1) DESC;
```

**Key Learning Points:**
- INTERSECT with GROUP BY requires careful column selection
- Aggregation functions used for customer segmentation
- Multiple criteria validation for business classification
- Performance considerations with correlated subqueries

### Solution 4.1: Top Performers Analysis Challenge

```sql
-- Senior Management: Department Performance Dashboard
SELECT 
    d.DepartmentName,
    top_performers.EmployeeName,
    top_performers.JobTitle,
    CAST(top_performers.PerformanceScore AS DECIMAL(8,2)) AS PerformanceScore,
    top_performers.PerformanceRank,
    FORMAT(top_performers.BaseSalary, 'C') AS Salary,
    top_performers.ProjectsManaged,
    top_performers.OrdersProcessed
FROM Departments d
CROSS APPLY (
    SELECT TOP 3
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        e.BaseSalary,
        -- Calculate comprehensive performance score
        (
            -- Salary percentile (30% weight)
            (CAST((SELECT COUNT(*) FROM Employees e2 
                   WHERE e2.DepartmentID = e.DepartmentID 
                     AND e2.BaseSalary <= e.BaseSalary 
                     AND e2.IsActive = 1) AS FLOAT) * 100.0 / 
             NULLIF((SELECT COUNT(*) FROM Employees e3 
                     WHERE e3.DepartmentID = e.DepartmentID 
                       AND e3.IsActive = 1), 0)) * 0.30 +
            
            -- Projects managed (25% weight)
            (LEAST(ISNULL((SELECT COUNT(DISTINCT p.ProjectID) 
                          FROM Projects p 
                          WHERE p.ProjectManagerID = e.EmployeeID 
                            AND p.IsActive = 1), 0) * 20, 100)) * 0.25 +
            
            -- Orders processed (25% weight)
            (LEAST(ISNULL((SELECT COUNT(o.OrderID) 
                          FROM Orders o 
                          WHERE o.EmployeeID = e.EmployeeID 
                            AND o.IsActive = 1), 0) * 2, 100)) * 0.25 +
            
            -- Years of experience (20% weight)
            (LEAST(DATEDIFF(YEAR, e.HireDate, GETDATE()) * 5, 100)) * 0.20
        ) AS PerformanceScore,
        
        ROW_NUMBER() OVER (ORDER BY 
            (
                -- Same calculation for ordering
                (CAST((SELECT COUNT(*) FROM Employees e2 
                       WHERE e2.DepartmentID = e.DepartmentID 
                         AND e2.BaseSalary <= e.BaseSalary 
                         AND e2.IsActive = 1) AS FLOAT) * 100.0 / 
                 NULLIF((SELECT COUNT(*) FROM Employees e3 
                         WHERE e3.DepartmentID = e.DepartmentID 
                           AND e3.IsActive = 1), 0)) * 0.30 +
                (LEAST(ISNULL((SELECT COUNT(DISTINCT p.ProjectID) 
                              FROM Projects p 
                              WHERE p.ProjectManagerID = e.EmployeeID 
                                AND p.IsActive = 1), 0) * 20, 100)) * 0.25 +
                (LEAST(ISNULL((SELECT COUNT(o.OrderID) 
                              FROM Orders o 
                              WHERE o.EmployeeID = e.EmployeeID 
                                AND o.IsActive = 1), 0) * 2, 100)) * 0.25 +
                (LEAST(DATEDIFF(YEAR, e.HireDate, GETDATE()) * 5, 100)) * 0.20
            ) DESC
        ) AS PerformanceRank,
        
        ISNULL((SELECT COUNT(DISTINCT p.ProjectID) 
                FROM Projects p 
                WHERE p.ProjectManagerID = e.EmployeeID 
                  AND p.IsActive = 1), 0) AS ProjectsManaged,
        
        ISNULL((SELECT COUNT(o.OrderID) 
                FROM Orders o 
                WHERE o.EmployeeID = e.EmployeeID 
                  AND o.IsActive = 1), 0) AS OrdersProcessed
    
    FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID
      AND e.IsActive = 1
    ORDER BY PerformanceScore DESC
) top_performers
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, top_performers.PerformanceRank;
```

**Key Learning Points:**
- CROSS APPLY enables per-department Top-N analysis
- Complex scoring algorithms using weighted metrics
- Correlated subqueries for dynamic calculations
- ROW_NUMBER() for ranking within each department

### Solution 4.2: Customer Relationship Analysis Challenge

```sql
-- Customer Success: Comprehensive Customer Analysis
SELECT 
    c.CompanyName,
    c.ContactName,
    c.Country,
    ISNULL(customer_metrics.TotalOrders, 0) AS TotalOrders,
    FORMAT(ISNULL(customer_metrics.LifetimeValue, 0), 'C') AS LifetimeValue,
    ISNULL(FORMAT(customer_metrics.LastOrderDate, 'yyyy-MM-dd'), 'Never') AS LastOrderDate,
    ISNULL(customer_metrics.DaysSinceLastOrder, 9999) AS DaysSinceLastOrder,
    ISNULL(customer_metrics.PrimaryEmployeeContact, 'None Assigned') AS PrimaryEmployeeContact,
    CASE 
        WHEN customer_metrics.YoYGrowthPercent IS NULL THEN 'No Historical Data'
        ELSE CAST(customer_metrics.YoYGrowthPercent AS VARCHAR(10)) + '%'
    END AS YoYOrderGrowthPercent,
    CASE 
        WHEN customer_metrics.DaysSinceLastOrder IS NULL THEN 'Prospect'
        WHEN customer_metrics.DaysSinceLastOrder > 365 THEN 'High Risk'
        WHEN customer_metrics.DaysSinceLastOrder > 180 THEN 'Medium Risk'
        WHEN customer_metrics.DaysSinceLastOrder > 90 THEN 'Low Risk'
        ELSE 'Active'
    END AS RiskLevel
FROM Customers c
OUTER APPLY (
    SELECT 
        order_summary.TotalOrders,
        order_summary.LifetimeValue,
        order_summary.LastOrderDate,
        DATEDIFF(DAY, order_summary.LastOrderDate, GETDATE()) AS DaysSinceLastOrder,
        primary_contact.EmployeeName AS PrimaryEmployeeContact,
        -- Year-over-year growth calculation
        CASE 
            WHEN year_comparison.LastYearOrders > 0 
            THEN CAST((year_comparison.ThisYearOrders - year_comparison.LastYearOrders) * 100.0 / 
                      year_comparison.LastYearOrders AS DECIMAL(5,1))
            ELSE NULL
        END AS YoYGrowthPercent
    FROM (
        -- Basic order summary
        SELECT 
            COUNT(o.OrderID) AS TotalOrders,
            SUM(o.TotalAmount) AS LifetimeValue,
            MAX(o.OrderDate) AS LastOrderDate
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
          AND o.IsActive = 1
    ) order_summary
    CROSS APPLY (
        -- Year-over-year comparison
        SELECT 
            SUM(CASE WHEN YEAR(o.OrderDate) = YEAR(GETDATE()) THEN 1 ELSE 0 END) AS ThisYearOrders,
            SUM(CASE WHEN YEAR(o.OrderDate) = YEAR(GETDATE()) - 1 THEN 1 ELSE 0 END) AS LastYearOrders
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
          AND o.IsActive = 1
          AND YEAR(o.OrderDate) IN (YEAR(GETDATE()), YEAR(GETDATE()) - 1)
    ) year_comparison
    OUTER APPLY (
        -- Primary employee contact (most frequent)
        SELECT TOP 1
            e.FirstName + ' ' + e.LastName AS EmployeeName
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        WHERE o.CustomerID = c.CustomerID
          AND o.IsActive = 1
          AND e.IsActive = 1
        GROUP BY e.EmployeeID, e.FirstName, e.LastName
        ORDER BY COUNT(o.OrderID) DESC
    ) primary_contact
) customer_metrics
WHERE c.IsActive = 1
ORDER BY 
    CASE RiskLevel 
        WHEN 'High Risk' THEN 1 
        WHEN 'Medium Risk' THEN 2 
        WHEN 'Low Risk' THEN 3 
        WHEN 'Active' THEN 4 
        ELSE 5 
    END,
    LifetimeValue DESC;
```

**Key Learning Points:**
- OUTER APPLY includes all customers even those without orders
- Nested APPLY operations for complex analysis
- Year-over-year trend calculations using conditional aggregation
- Risk assessment based on business rules
- Multiple levels of analysis within single query

---

## Lab Summary and Key Takeaways

### Set Operator Performance Best Practices

1. **UNION Operations:**
   - Use UNION ALL when duplicates are acceptable for better performance
   - Ensure consistent data types and column order
   - Apply filtering early in each SELECT statement
   - Consider indexing on columns used in ORDER BY clauses

2. **EXCEPT and INTERSECT:**
   - Both operators automatically remove duplicates
   - Ensure exact column matching including data types
   - Consider EXISTS/NOT EXISTS alternatives for better performance
   - Use appropriate indexes on join and filter columns

3. **APPLY Operations:**
   - Choose CROSS APPLY vs OUTER APPLY based on business requirements
   - Use TOP clause to limit results in APPLY expressions
   - Consider indexing on correlated columns
   - Break complex nested APPLY into simpler CTEs when needed

### Business Intelligence Applications

- **Data Consolidation**: UNION operations for comprehensive reporting
- **Data Quality**: EXCEPT operations for validation and auditing
- **Market Analysis**: INTERSECT operations for customer segmentation
- **Performance Analysis**: APPLY operations for per-group analytics

### Common Patterns Learned

- **Unified Reporting**: Combining data from multiple sources with consistent formatting
- **Compliance Checking**: Using set operations to identify policy violations
- **Customer Segmentation**: Finding customers who meet multiple criteria
- **Top-N Analysis**: Per-group performance analysis using APPLY
- **Trend Analysis**: Year-over-year comparisons and growth calculations

### Next Steps

- Practice these patterns with your own business scenarios
- Experiment with query optimization techniques
- Explore combination approaches (mixing different set operators)
- Study execution plans to understand performance characteristics
- Consider implementing these patterns in business intelligence solutions

Congratulations on completing the TechCorp Set Operators Lab! You now have practical experience with all major set operations and their real-world applications in business intelligence and data analysis.