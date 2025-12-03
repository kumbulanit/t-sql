# Lesson 3: Using APPLY

## Overview

The APPLY operator is a unique SQL Server feature that enables row-by-row operations between tables and table-valued expressions or functions. Unlike traditional JOINs that work with static result sets, APPLY allows for dynamic, correlated operations where each row from the left table can influence the query executed on the right side. This powerful capability is essential for complex analytical scenarios, data transformations, and advanced reporting requirements in TechCorp's business intelligence operations.

## 🏢 TechCorp Business Context

**APPLY Operations in Advanced Analytics:**

- **Dynamic Reporting**: Creating reports where each row determines subsequent query logic
- **Top-N Analysis**: Finding top performers per d.DepartmentName, project, or other groupings
- **Complex Aggregations**: Performing calculations that depend on individual row values
- **Data Transformation**: Applying complex transformations based on row-specific criteria
- **Hierarchical Analysis**: Processing organizational structures and reporting chains

### 📋 TechCorp Database Schema Reference

**Core Tables for APPLY Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
```

---

## 3.1 Understanding CROSS APPLY

### CROSS APPLY Fundamentals

CROSS APPLY returns only rows from the left table where the right table expression returns results, similar to an INNER JOIN but with dynamic query capability.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           CROSS APPLY Syntax                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SELECT columns                                                            │
│  FROM left_table                                                           │
│  CROSS APPLY (                                                             │
│      SELECT columns                                                        │
│      FROM right_table                                                      │
│      WHERE condition_referencing_left_table                               │
│  ) AS applied_table                                                        │
│                                                                             │
│  Key Characteristics:                                                      │
│  • Right side can reference columns from left side                        │
│  • Only returns rows where right side produces results                    │
│  • Enables dynamic, correlated operations                                 │
│  • More flexible than traditional JOINs for complex scenarios             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### TechCorp Example: Top Performers by d.DepartmentName

```sql
-- Example: Find top 3 highest-paid employees in each d.DepartmentName
-- This demonstrates how CROSS APPLY enables dynamic top-N analysis

SELECT d.DepartmentName,
    d.Budget AS DepartmentBudget,
    top_performers.EmployeeRank,
    top_performers.EmployeeName,
    top_performers.JobTitle,
    top_performers.BaseSalary,
    top_performers.SalaryPercentileInDept,
    FORMAT(top_performers.BaseSalary / d.Budget * 100, 'N2') + '%' AS SalaryAsBudgetPercent
FROM Departments d
CROSS APPLY (
    SELECT TOP 3
        ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS EmployeeRank,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        NTILE(4) OVER (ORDER BY e.BaseSalary) AS SalaryPercentileInDept
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
    ORDER BY e.BaseSalary DESC
) AS top_performers
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, top_performers.EmployeeRank;

-- Enhanced analysis: Include d.DepartmentName statistics
SELECT d.DepartmentName,
    top_performers.EmployeeRank,
    top_performers.EmployeeName,
    top_performers.BaseSalary,
    dept_stats.DepartmentAvgSalary,
    dept_stats.TotalEmployees,
    FORMAT((top_performers.BaseSalary / dept_stats.DepartmentAvgSalary - 1) * 100, 'N1') + '%' AS AboveAvgPercent,
    CASE 
        WHEN top_performers.EmployeeRank = 1 THEN 'Top Performer'
        WHEN top_performers.BaseSalary > dept_stats.DepartmentAvgSalary * 1.2 THEN 'High Performer'
        ELSE 'Standard Performer'
    END AS PerformanceCategory
FROM Departments d
CROSS APPLY (
    SELECT TOP 3
        ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS EmployeeRank,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
    ORDER BY e.BaseSalary DESC
) AS top_performers
CROSS APPLY (
    SELECT 
        AVG(e.BaseSalary) AS DepartmentAvgSalary,
        COUNT(*) AS TotalEmployees
    FROM Employees e
    WHERE e.d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
) AS dept_stats
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, top_performers.EmployeeRank;
```

---

## 3.2 Understanding OUTER APPLY

### OUTER APPLY Fundamentals

OUTER APPLY returns all rows from the left table, regardless of whether the right table expression returns results, similar to a LEFT OUTER JOIN.

```sql
-- TechCorp Example: d.DepartmentName Analysis with Employee Statistics
-- Shows all departments, even those without employees

SELECT 
    d.DepartmentID,
    d.DepartmentName,
    d.Budget,
    d.Location,
    ISNULL(emp_stats.EmployeeCount, 0) AS EmployeeCount,
    ISNULL(emp_stats.TotalSalaryExpense, 0) AS TotalSalaryExpense,
    ISNULL(emp_stats.AverageSalary, 0) AS AverageBaseSalary,
    ISNULL(emp_stats.MinSalary, 0) AS MinSalary,
    ISNULL(emp_stats.MaxSalary, 0) AS MaxSalary,
    CASE 
        WHEN emp_stats.EmployeeCount IS NULL THEN 'No Employees'
        WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.8 THEN 'High e.BaseSalary Utilization'
        WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.6 THEN 'Moderate e.BaseSalary Utilization'
        WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.4 THEN 'Low e.BaseSalary Utilization'
        ELSE 'Very Low e.BaseSalary Utilization'
    END AS BudgetUtilizationStatus,
    CASE 
        WHEN emp_stats.EmployeeCount IS NULL THEN NULL
        ELSE FORMAT(emp_stats.TotalSalaryExpense / NULLIF(d.Budget, 0) * 100, 'N1') + '%'
    END AS BudgetUtilizationPercent
FROM Departments d
OUTER APPLY (
    SELECT 
        COUNT(*) AS EmployeeCount,
        SUM(e.BaseSalary) AS TotalSalaryExpense,
        AVG(e.BaseSalary) AS AverageBaseSalary,
        MIN(e.BaseSalary) AS MinSalary,
        MAX(e.BaseSalary) AS MaxSalary,
        COUNT(CASE WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 1 END) AS LongTenureEmployees
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
) AS emp_stats
WHERE d.IsActive = 1
ORDER BY emp_stats.EmployeeCount DESC NULLS LAST, d.DepartmentName;

-- d.DepartmentName planning recommendations based on analysis
SELECT main_analysis.d.DepartmentName,
    main_analysis.EmployeeCount,
    main_analysis.BudgetUtilizationStatus,
    main_analysis.BudgetUtilizationPercent,
    recommendations.RecommendationCategory,
    recommendations.Recommendation
FROM (
    -- Previous query results as subquery
    SELECT d.DepartmentName,
        ISNULL(emp_stats.EmployeeCount, 0) AS EmployeeCount,
        CASE 
            WHEN emp_stats.EmployeeCount IS NULL THEN 'No Employees'
            WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.8 THEN 'High e.BaseSalary Utilization'
            WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.6 THEN 'Moderate e.BaseSalary Utilization'
            WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.4 THEN 'Low e.BaseSalary Utilization'
            ELSE 'Very Low e.BaseSalary Utilization'
        END AS BudgetUtilizationStatus,
        CASE 
            WHEN emp_stats.EmployeeCount IS NULL THEN NULL
            ELSE FORMAT(emp_stats.TotalSalaryExpense / NULLIF(d.Budget, 0) * 100, 'N1') + '%'
        END AS BudgetUtilizationPercent,
        d.Budget,
        emp_stats.TotalSalaryExpense
    FROM Departments d
    OUTER APPLY (
        SELECT 
            COUNT(*) AS EmployeeCount,
            SUM(e.BaseSalary) AS TotalSalaryExpense
        FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
        WHERE e.d.DepartmentID = d.DepartmentID
        AND e.IsActive = 1
    ) AS emp_stats
    WHERE d.IsActive = 1
) AS main_analysis
CROSS APPLY (
    SELECT 
        CASE 
            WHEN main_analysis.EmployeeCount = 0 THEN 'HIRING'
            WHEN main_analysis.BudgetUtilizationStatus = 'High e.BaseSalary Utilization' THEN 'BUDGET_REVIEW'
            WHEN main_analysis.BudgetUtilizationStatus = 'Very Low e.BaseSalary Utilization' THEN 'EXPANSION'
            ELSE 'OPTIMIZATION'
        END AS RecommendationCategory,
        CASE 
            WHEN main_analysis.EmployeeCount = 0 THEN 'Consider hiring employees for this department'
            WHEN main_analysis.BudgetUtilizationStatus = 'High e.BaseSalary Utilization' THEN 'Review budget allocation or e.BaseSalary structure'
            WHEN main_analysis.BudgetUtilizationStatus = 'Very Low e.BaseSalary Utilization' THEN 'Opportunity for team expansion or e.BaseSalary increases'
            ELSE 'Continue monitoring and optimize as needed'
        END AS Recommendation
) AS recommendations
ORDER BY main_analysis.EmployeeCount DESC;
```

---

## 3.3 APPLY with User-Defined Functions

### Table-Valued Functions with APPLY

```sql
-- First, create a table-valued function for employee project analysis
-- (Run this separately as a DDL statement)
/*
CREATE FUNCTION dbo.fn_GetEmployeeProjectSummary(@e.EmployeeID INT, @LookbackMonths INT = 12)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        SUM(ISNULL(ep.HoursWorked, 0)) AS TotalHours,
        AVG(ISNULL(ep.HoursWorked, 0)) AS AverageHoursPerProject,
        COUNT(DISTINCT CASE WHEN p.d.Budget > 100000 THEN ep.ProjectID END) AS HighValueProjectCount,
        SUM(CASE WHEN p.d.Budget > 100000 THEN ISNULL(ep.HoursWorked, 0) ELSE 0 END) AS HighValueProjectHours,
        MIN(ep.StartDate) AS FirstProjectStart,
        MAX(ISNULL(ep.EndDate, GETDATE())) AS LastProjectActivity
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.EmployeeID = @e.EmployeeID
    AND ep.IsActive = 1
    AND p.IsActive = 1
    AND ep.StartDate >= DATEADD(MONTH, -@LookbackMonths, GETDATE())
);
*/

-- Use CROSS APPLY with the function for comprehensive employee analysis
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    project_summary.ProjectCount,
    project_summary.TotalHours,
    project_summary.AverageHoursPerProject,
    project_summary.HighValueProjectCount,
    project_summary.HighValueProjectHours,
    CASE 
        WHEN project_summary.ProjectCount >= 5 THEN 'Highly Active'
        WHEN project_summary.ProjectCount >= 3 THEN 'Active'
        WHEN project_summary.ProjectCount >= 1 THEN 'Moderately Active'
        ELSE 'Inactive'
    END AS ActivityLevel,
    CASE 
        WHEN project_summary.TotalHours >= 1000 THEN 'High Contributor'
        WHEN project_summary.TotalHours >= 500 THEN 'Regular Contributor'
        WHEN project_summary.TotalHours >= 100 THEN 'Light Contributor'
        ELSE 'Minimal Contributor'
    END AS ContributionLevel,
    project_summary.TotalHours * (e.BaseSalary / 2080.0) AS EstimatedProjectCostContribution
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
CROSS APPLY (
    -- Inline table expression simulating the function
    SELECT 
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        SUM(ISNULL(ep.HoursWorked, 0)) AS TotalHours,
        AVG(ISNULL(ep.HoursWorked, 0)) AS AverageHoursPerProject,
        COUNT(DISTINCT CASE WHEN p.d.Budget > 100000 THEN ep.ProjectID END) AS HighValueProjectCount,
        SUM(CASE WHEN p.d.Budget > 100000 THEN ISNULL(ep.HoursWorked, 0) ELSE 0 END) AS HighValueProjectHours,
        MIN(ep.StartDate) AS FirstProjectStart,
        MAX(ISNULL(ep.EndDate, GETDATE())) AS LastProjectActivity
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.EmployeeID = e.EmployeeID
    AND ep.IsActive = 1
    AND p.IsActive = 1
    AND ep.StartDate >= DATEADD(MONTH, -12, GETDATE())
) AS project_summary
WHERE e.IsActive = 1
AND project_summary.ProjectCount > 0  -- Only employees with project activity
ORDER BY project_summary.TotalHours DESC, e.BaseSalary DESC;
```

---

## 3.4 Advanced APPLY Scenarios

### Dynamic Reporting with APPLY

```sql
-- TechCorp Example: Dynamic Customer Analysis with Varying Criteria
-- Shows how APPLY can handle different analysis requirements per customer

SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.CountryID,
    customer_analysis.OrderCount,
    customer_analysis.TotalRevenue,
    customer_analysis.AverageOrderValue,
    customer_analysis.FirstOrderDate,
    customer_analysis.LastOrderDate,
    customer_analysis.DaysSinceLastOrder,
    customer_analysis.CustomerCategory,
    recommendations.RecommendationType,
    recommendations.RecommendationText
FROM Customers c
CROSS APPLY (
    -- Customer order analysis
    SELECT 
        COUNT(o.OrderID) AS OrderCount,
        SUM(o.TotalAmount) AS TotalRevenue,
        AVG(o.TotalAmount) AS AverageOrderValue,
        MIN(o.OrderDate) AS FirstOrderDate,
        MAX(o.OrderDate) AS LastOrderDate,
        DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        CASE 
            WHEN SUM(o.TotalAmount) >= 50000 THEN 'Premium'
            WHEN SUM(o.TotalAmount) >= 25000 THEN 'High Value'
            WHEN SUM(o.TotalAmount) >= 10000 THEN 'Standard'
            WHEN COUNT(o.OrderID) > 0 THEN 'Low Value'
            ELSE 'No Orders'
        END AS CustomerCategory
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
    AND o.IsActive = 1
) AS customer_analysis
CROSS APPLY (
    -- Dynamic recommendations based on customer analysis
    SELECT 
        CASE 
            WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder > 90 
                THEN 'RETENTION'
            WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder <= 30 
                THEN 'UPSELL'
            WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder > 180 
                THEN 'REACTIVATION'
            WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder <= 60 
                THEN 'CROSS_SELL'
            WHEN customer_analysis.CustomerCategory = 'Low Value' 
                THEN 'NURTURE'
            ELSE 'ACQUISITION'
        END AS RecommendationType,
        CASE 
            WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder > 90 
                THEN 'High-value customer at risk - immediate retention efforts needed'
            WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder <= 30 
                THEN 'Active premium customer - focus on upselling premium services'
            WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder > 180 
                THEN 'Customer reactivation campaign with special offers'
            WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder <= 60 
                THEN 'Cross-sell complementary products and services'
            WHEN customer_analysis.CustomerCategory = 'Low Value' 
                THEN 'Nurture relationship with targeted content and small offers'
            ELSE 'New customer acquisition - no previous order history'
        END AS RecommendationText
) AS recommendations
WHERE c.IsActive = 1
ORDER BY customer_analysis.TotalRevenue DESC, customer_analysis.OrderCount DESC;

-- Summary analysis of customer recommendations
SELECT 
    recommendations_summary.RecommendationType,
    COUNT(*) AS CustomerCount,
    SUM(recommendations_summary.TotalRevenue) AS CombinedRevenue,
    AVG(recommendations_summary.TotalRevenue) AS AverageRevenue,
    AVG(recommendations_summary.DaysSinceLastOrder) AS AvgDaysSinceLastOrder
FROM (
    SELECT 
        c.CustomerID,
        customer_analysis.TotalRevenue,
        customer_analysis.DaysSinceLastOrder,
        recommendations.RecommendationType
    FROM Customers c
    CROSS APPLY (
        SELECT 
            ISNULL(SUM(o.TotalAmount), 0) AS TotalRevenue,
            ISNULL(DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()), 999) AS DaysSinceLastOrder,
            CASE 
                WHEN SUM(o.TotalAmount) >= 50000 THEN 'Premium'
                WHEN SUM(o.TotalAmount) >= 25000 THEN 'High Value'
                WHEN SUM(o.TotalAmount) >= 10000 THEN 'Standard'
                WHEN COUNT(o.OrderID) > 0 THEN 'Low Value'
                ELSE 'No Orders'
            END AS CustomerCategory
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
        AND o.IsActive = 1
    ) AS customer_analysis
    CROSS APPLY (
        SELECT 
            CASE 
                WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder > 90 
                    THEN 'RETENTION'
                WHEN customer_analysis.CustomerCategory = 'Premium' AND customer_analysis.DaysSinceLastOrder <= 30 
                    THEN 'UPSELL'
                WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder > 180 
                    THEN 'REACTIVATION'
                WHEN customer_analysis.CustomerCategory IN ('High Value', 'Standard') AND customer_analysis.DaysSinceLastOrder <= 60 
                    THEN 'CROSS_SELL'
                WHEN customer_analysis.CustomerCategory = 'Low Value' 
                    THEN 'NURTURE'
                ELSE 'ACQUISITION'
            END AS RecommendationType
    ) AS recommendations
    WHERE c.IsActive = 1
) AS recommendations_summary
GROUP BY recommendations_summary.RecommendationType
ORDER BY CombinedRevenue DESC;
```

---

## 3.5 Performance Optimization with APPLY

### Best Practices for APPLY Performance

```sql
-- TechCorp Example: Optimized APPLY operations for large datasets
-- Demonstrates performance optimization techniques

-- Step 1: Create appropriate indexes (run separately)
/*
CREATE INDEX IX_EmployeeProjects_Employee_Active 
ON EmployeeProjects (e.EmployeeID, IsActive) 
INCLUDE (ProjectID, HoursWorked, StartDate, EndDate);

CREATE INDEX IX_Projects_Active_Budget 
ON Projects (IsActive, d.Budget) 
INCLUDE (ProjectID, ProjectName, StartDate, EndDate);

CREATE INDEX IX_Employees_Active_Department 
ON Employees (IsActive, d.DepartmentID) 
INCLUDE (e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, e.HireDate);
*/

-- Step 2: Optimized query using proper filtering and indexing
WITH DepartmentPerformanceMetrics AS (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Budget,
        COUNT(e.EmployeeID) AS TotalEmployees,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
    WHERE d.IsActive = 1 AND e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName, d.Budget
)

SELECT dpm.d.DepartmentName,
    dpm.TotalEmployees,
    dpm.AvgSalary,
    top_contributors.EmployeeName,
    top_contributors.TotalProjectHours,
    top_contributors.ProjectCount,
    top_contributors.ContributionRank,
    performance_metrics.DepartmentTotalHours,
    FORMAT(top_contributors.TotalProjectHours / NULLIF(performance_metrics.DepartmentTotalHours, 0) * 100, 'N1') + '%' AS IndividualContributionPercent
FROM DepartmentPerformanceMetrics dpm

-- Optimized CROSS APPLY with filtering
CROSS APPLY (
    SELECT TOP 5
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        SUM(ISNULL(ep.HoursWorked, 0)) AS TotalProjectHours,
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        ROW_NUMBER() OVER (ORDER BY SUM(ISNULL(ep.HoursWorked, 0)) DESC) AS ContributionRank
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.d.DepartmentID = dpm.d.DepartmentID
    AND e.IsActive = 1
    AND ep.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())  -- Filter for recent activity
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
    HAVING SUM(ISNULL(ep.HoursWorked, 0)) > 0  -- Only include employees with hours
    ORDER BY SUM(ISNULL(ep.HoursWorked, 0)) DESC
) AS top_contributors

-- Additional metrics for percentage calculation
CROSS APPLY (
    SELECT 
        SUM(ISNULL(ep.HoursWorked, 0)) AS DepartmentTotalHours
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.d.DepartmentID = dpm.d.DepartmentID
    AND e.IsActive = 1
    AND ep.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
) AS performance_metrics

ORDER BY dpm.d.DepartmentName, top_contributors.ContributionRank;

-- Performance monitoring query
SELECT 
    'Query Performance Metrics' AS MetricType,
    COUNT(DISTINCT dpm.d.DepartmentID) AS DepartmentsAnalyzed,
    COUNT(*) AS TopContributorsFound,
    AVG(top_contributors.TotalProjectHours) AS AvgContributionHours,
    MAX(top_contributors.TotalProjectHours) AS MaxContributionHours,
    MIN(top_contributors.TotalProjectHours) AS MinContributionHours
FROM DepartmentPerformanceMetrics dpm
CROSS APPLY (
    SELECT TOP 5
        SUM(ISNULL(ep.HoursWorked, 0)) AS TotalProjectHours
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.d.DepartmentID = dpm.d.DepartmentID
    AND e.IsActive = 1
    AND ep.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY e.EmployeeID
    HAVING SUM(ISNULL(ep.HoursWorked, 0)) > 0
    ORDER BY SUM(ISNULL(ep.HoursWorked, 0)) DESC
) AS top_contributors;
```

---

## 3.6 APPLY vs Traditional JOINs

### When to Use APPLY vs JOIN

```sql
-- TechCorp Example: Comparing APPLY vs JOIN approaches
-- Shows scenarios where APPLY provides advantages over traditional JOINs

-- Scenario 1: Traditional JOIN approach (limited flexibility)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    recent_projects.ProjectCount,
    recent_projects.TotalHours
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN (
    SELECT 
        ep.EmployeeID,
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        SUM(ep.HoursWorked) AS TotalHours
    FROM EmployeeProjects ep
    WHERE ep.IsActive = 1
    AND ep.StartDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY ep.EmployeeID
) AS recent_projects ON e.EmployeeID = recent_projects.EmployeeID
WHERE e.IsActive = 1
ORDER BY recent_projects.TotalHours DESC;

-- Scenario 2: CROSS APPLY approach (more flexible and dynamic)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.BaseSalary,
    project_analysis.RecentProjectCount,
    project_analysis.RecentTotalHours,
    project_analysis.HighValueProjectCount,
    project_analysis.PerformanceCategory,
    salary_comparison.DeptAvgSalary,
    salary_comparison.SalaryRank
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

-- Dynamic project analysis per employee
CROSS APPLY (
    SELECT 
        COUNT(DISTINCT ep.ProjectID) AS RecentProjectCount,
        SUM(ISNULL(ep.HoursWorked, 0)) AS RecentTotalHours,
        COUNT(DISTINCT CASE WHEN p.Budget > 100000 THEN ep.ProjectID END) AS HighValueProjectCount,
        CASE 
            WHEN COUNT(DISTINCT ep.ProjectID) >= 3 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 300 THEN 'High Performer'
            WHEN COUNT(DISTINCT ep.ProjectID) >= 2 AND SUM(ISNULL(ep.HoursWorked, 0)) >= 150 THEN 'Good Performer'
            WHEN COUNT(DISTINCT ep.ProjectID) >= 1 THEN 'Standard Performer'
            ELSE 'Underperformer'
        END AS PerformanceCategory
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.EmployeeID = e.EmployeeID
    AND ep.IsActive = 1
    AND p.IsActive = 1
    AND ep.StartDate >= DATEADD(MONTH, -6, GETDATE())
) AS project_analysis

-- Dynamic e.BaseSalary comparison within d.DepartmentName
CROSS APPLY (
    SELECT 
        AVG(dept_emp.BaseSalary) AS DeptAvgSalary,
        RANK() OVER (ORDER BY dept_emp.BaseSalary DESC) AS SalaryRank
    FROM Employees e dept_emp
    WHERE dept_emp.DepartmentID = e.DepartmentID
    AND dept_emp.IsActive = 1
    AND dept_emp.EmployeeID = e.EmployeeID  -- This ensures we get the rank for current employee
    
    UNION ALL
    
    SELECT 
        AVG(all_dept_emp.BaseSalary) AS DeptAvgSalary,
        (SELECT COUNT(*) + 1 
         FROM Employees e rank_emp 
         WHERE rank_emp.DepartmentID = e.DepartmentID 
         AND rank_emp.IsActive = 1 
         AND rank_emp.BaseSalary > e.BaseSalary) AS SalaryRank
    FROM Employees e all_dept_emp
    WHERE all_dept_emp.DepartmentID = e.DepartmentID
    AND all_dept_emp.IsActive = 1
) AS salary_comparison

WHERE e.IsActive = 1
AND project_analysis.RecentProjectCount > 0  -- Only employees with recent project activity
ORDER BY project_analysis.RecentTotalHours DESC, e.BaseSalary DESC;

-- Comparison summary: Show the advantages of APPLY
SELECT 
    'APPLY Advantages Summary' AS AnalysisType,
    'Flexibility: Dynamic queries per row' AS Advantage1,
    'Performance: Can use TOP N efficiently' AS Advantage2,
    'Functionality: Can reference outer query columns' AS Advantage3,
    'Complexity: Handles complex correlated logic' AS Advantage4;
```

---

## Summary

The APPLY operator provides TechCorp with advanced capabilities for complex data analysis and dynamic reporting:

**Key APPLY Concepts:**

- **CROSS APPLY**: Returns only rows where the applied expression produces results (similar to INNER JOIN)
- **OUTER APPLY**: Returns all rows from the left side, with NULL values where applied expression produces no results (similar to LEFT OUTER JOIN)
- **Dynamic Operations**: Enables row-by-row processing with different logic per row
- **Correlated Functionality**: Right side can reference columns from left side for complex scenarios

**TechCorp Applications:**

- **Top-N Analysis**: Finding top performers, customers, or projects per category
- **Dynamic Reporting**: Creating reports where each row influences subsequent calculations
- **Complex Aggregations**: Performing calculations that depend on individual row values
- **Advanced Analytics**: Multi-dimensional analysis with varying criteria per entity

**Advanced Techniques Demonstrated:**

- **Performance Optimization**: Proper indexing strategies for APPLY operations
- **Function Integration**: Using table-valued functions with APPLY for reusable logic
- **Dynamic Recommendations**: Creating business logic that adapts to individual row characteristics
- **Comparative Analysis**: Showing advantages of APPLY over traditional JOIN approaches

**Performance Considerations:**

- **Index Strategy**: Creating appropriate indexes to support APPLY operations efficiently
- **Filtering**: Using WHERE clauses to minimize dataset sizes before APPLY operations
- **Function Optimization**: Ensuring table-valued functions used with APPLY are optimized
- **Query Design**: Structuring APPLY operations to minimize computational overhead

**Best Practices:**

- Use CROSS APPLY when you need all rows from the applied expression
- Use OUTER APPLY when you want to preserve all left-side rows regardless of right-side results
- Consider performance implications when using APPLY with large datasets
- Leverage APPLY for scenarios requiring row-by-row dynamic processing
- Combine APPLY with CTEs for complex analytical scenarios

**Business Value:**

- **Enhanced Analytics**: Enables sophisticated business intelligence scenarios not possible with standard JOINs
- **Dynamic Reporting**: Creates flexible reports that adapt to varying business requirements
- **Performance**: Provides efficient solutions for complex analytical problems
- **Scalability**: Handles growing data volumes with proper optimization techniques

Mastering APPLY operations enables TechCorp's development teams to implement advanced analytical solutions that provide deep business insights and support complex decision-making processes across the organization.