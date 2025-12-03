# Lesson 1: Writing Queries with the UNION Operator

## Overview

The UNION operator is a powerful set operator that combines result sets from two or more SELECT statements into a single result set. Understanding UNION operations is essential for creating comprehensive reports, consolidating data from multiple sources, and performing complex data analysis. For TechCorp's reporting and analytics needs, UNION operators enable the creation of unified views across different business entities while maintaining data integrity and performance.

## 🏢 TechCorp Business Context

**UNION Operations in Enterprise Reporting:**

- **Consolidated Employee Reports**: Combining current and historical employee data
- **Multi-Department Analytics**: Merging data from different departments for executive reporting
- **Cross-System Integration**: Unifying data from various business systems
- **Comprehensive Customer Views**: Combining customer data from different interaction points
- **Financial Consolidation**: Merging financial data from multiple cost centers and projects

### 📋 TechCorp Database Schema Reference

**Core Tables for UNION Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.HireDate, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
```

---

## 1.1 Understanding UNION Operator

### UNION vs UNION ALL

The UNION operator combines results from multiple queries while removing duplicates, whereas UNION ALL includes all rows including duplicates.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            UNION Operator Syntax                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SELECT column1, column2, ... FROM table1                                  │
│  WHERE condition1                                                           │
│  UNION [ALL]                                                               │
│  SELECT column1, column2, ... FROM table2                                  │
│  WHERE condition2                                                           │
│                                                                             │
│  Key Requirements:                                                         │
│  • Same number of columns in all SELECT statements                        │
│  • Compatible data types in corresponding columns                         │
│  • Column names determined by first SELECT statement                      │
│  • ORDER BY can only appear at the end of entire UNION query             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### TechCorp Example: Employee Contact Directory

```sql
-- Example: Create comprehensive employee contact directory
-- Combines active employees with recent departures for transition management

-- Create a unified employee contact list
SELECT 
    'ACTIVE' AS EmployeeStatus,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.JobTitle,
    WorkEmail,
    d.DepartmentName,
    e.HireDate AS RelevantDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION

SELECT 
    'RECENT_DEPARTURE' AS EmployeeStatus,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.JobTitle,
    WorkEmail,
    d.DepartmentName,
    TerminationDate AS RelevantDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 0
AND e.TerminationDate >= DATEADD(MONTH, -3, GETDATE())

ORDER BY EmployeeStatus, DepartmentName, FullName;
```

---

## 1.2 UNION ALL for Performance

### When to Use UNION ALL

UNION ALL is more efficient when you know there are no duplicates or when duplicates are acceptable.

```sql
-- TechCorp Example: Comprehensive Project Timeline Report
-- Combines project milestones with employee assignments

-- Project activity timeline using UNION ALL for better performance
SELECT 
    'PROJECT_START' AS ActivityType,
    p.ProjectID,
    p.ProjectName,
    p.StartDate AS ActivityDate,
    'Project initiated by ' + e.FirstName + ' ' + e.LastName AS ActivityDescription,
    p.Budget AS RelatedAmount
FROM Projects p
INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
WHERE p.IsActive = 1

UNION ALL

SELECT 
    'TEAM_ASSIGNMENT' AS ActivityType,
    ep.ProjectID,
    p.ProjectName,
    ep.StartDate AS ActivityDate,
    'Team member assigned: ' + e.FirstName + ' ' + e.LastName + ' (' + ep.Role + ')' AS ActivityDescription,
    NULL AS RelatedAmount
FROM EmployeeProjects ep
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
WHERE ep.IsActive = 1
AND ep.StartDate IS NOT NULL

UNION ALL

SELECT 
    'PROJECT_COMPLETION' AS ActivityType,
    p.ProjectID,
    p.ProjectName,
    p.EndDate AS ActivityDate,
    'Project completed' AS ActivityDescription,
    p.Budget AS RelatedAmount
FROM Projects p
WHERE p.IsActive = 1
AND p.EndDate IS NOT NULL

ORDER BY ProjectID, ActivityDate, ActivityType;
```

---

## 1.3 Advanced UNION Techniques

### Handling Different Data Types

```sql
-- TechCorp Example: Financial Transaction Summary
-- Combines different types of financial data with proper type handling

-- Comprehensive financial summary using UNION with type conversion
SELECT 
    'SALARY_EXPENSE' AS TransactionType,
    YEAR(GETDATE()) AS FiscalYear,
    MONTH(GETDATE()) AS FiscalMonth,
    d.DepartmentName AS Category,
    SUM(e.BaseSalary) AS Amount,
    COUNT(e.EmployeeID) AS TransactionCount,
    'Monthly e.BaseSalary expenses' AS Description
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName

UNION ALL

SELECT 
    'PROJECT_BUDGET' AS TransactionType,
    YEAR(p.StartDate) AS FiscalYear,
    MONTH(p.StartDate) AS FiscalMonth,
    'PROJECT_' + CAST(p.ProjectID AS NVARCHAR(10)) AS Category,
    p.Budget AS Amount,
    1 AS TransactionCount,
    'Project budget allocation: ' + p.ProjectName AS Description
FROM Projects p
WHERE p.IsActive = 1
AND p.StartDate >= DATEADD(YEAR, -1, GETDATE())

UNION ALL

SELECT 
    'ORDER_REVENUE' AS TransactionType,
    YEAR(o.OrderDate) AS FiscalYear,
    MONTH(o.OrderDate) AS FiscalMonth,
    'CUSTOMER_ORDERS' AS Category,
    SUM(o.TotalAmount) AS Amount,
    COUNT(o.OrderID) AS TransactionCount,
    'Customer order revenue' AS Description
FROM Orders o
WHERE o.IsActive = 1
AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)

ORDER BY FiscalYear DESC, FiscalMonth DESC, TransactionType;
```

### Using UNION with CTEs

```sql
-- TechCorp Example: Employee Performance Analysis with UNION and CTEs
-- Creates comprehensive performance metrics from multiple data sources

WITH HighPerformers AS (
    -- Identify high performers based on project involvement
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.BaseSalary,
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        SUM(ep.HoursWorked) AS TotalHours
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    AND ep.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary
    HAVING COUNT(DISTINCT ep.ProjectID) >= 2
),
SalaryBenchmarks AS (
    -- Calculate e.BaseSalary benchmarks by d.DepartmentName
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        AVG(e.BaseSalary) AS AvgSalary,
        MIN(e.BaseSalary) AS MinSalary,
        MAX(e.BaseSalary) AS MaxSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
)

-- Combine performance data with e.BaseSalary analysis
SELECT 
    'HIGH_PERFORMER' AS AnalysisType,
    hp.EmployeeName,
    hp.BaseSalary,
    hp.ProjectCount AS MetricValue,
    'Projects completed in last year' AS MetricDescription,
    CASE 
        WHEN hp.BaseSalary >= sb.AvgSalary * 1.2 THEN 'Above Average Compensation'
        WHEN hp.BaseSalary >= sb.AvgSalary THEN 'Average Compensation'
        ELSE 'Below Average Compensation'
    END AS CompensationStatus
FROM HighPerformers hp
INNER JOIN Employees e ON hp.EmployeeID = e.EmployeeID
INNER JOIN SalaryBenchmarks sb ON e.DepartmentID = sb.DepartmentID

UNION ALL

SELECT 
    'DEPARTMENT_BENCHMARK' AS AnalysisType,
    sb.DepartmentName AS EmployeeName,
    sb.AvgSalary AS e.BaseSalary,
    (sb.MaxSalary - sb.MinSalary) AS MetricValue,
    'e.BaseSalary range within department' AS MetricDescription,
    CASE 
        WHEN (sb.MaxSalary - sb.MinSalary) > 50000 THEN 'High e.BaseSalary Variance'
        WHEN (sb.MaxSalary - sb.MinSalary) > 25000 THEN 'Moderate e.BaseSalary Variance'
        ELSE 'Low e.BaseSalary Variance'
    END AS CompensationStatus
FROM SalaryBenchmarks sb

ORDER BY AnalysisType, e.BaseSalary DESC;
```

---

## 1.4 UNION with Aggregations

### Complex Reporting with UNION

```sql
-- TechCorp Example: Executive Dashboard Summary
-- Combines multiple business metrics into a single executive report

-- Executive summary combining multiple KPIs
SELECT 
    'HUMAN_RESOURCES' AS BusinessArea,
    'Employee Count' AS MetricName,
    COUNT(*) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Active employees across all departments' AS Description
FROM Employees e 
WHERE IsActive = 1

UNION ALL

SELECT 
    'HUMAN_RESOURCES' AS BusinessArea,
    'Average e.BaseSalary' AS MetricName,
    CAST(AVG(e.BaseSalary) AS INT) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Average e.BaseSalary across all active employees' AS Description
FROM Employees e 
WHERE IsActive = 1

UNION ALL

SELECT 
    'PROJECT_MANAGEMENT' AS BusinessArea,
    'Active Projects' AS MetricName,
    COUNT(*) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Currently active projects' AS Description
FROM Projects p 
WHERE IsActive = 1

UNION ALL

SELECT 
    'PROJECT_MANAGEMENT' AS BusinessArea,
    'Total Project Budget' AS MetricName,
    CAST(SUM(Budget) AS INT) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Combined budget of all active projects' AS Description
FROM Projects p 
WHERE IsActive = 1

UNION ALL

SELECT 
    'SALES_REVENUE' AS BusinessArea,
    'Monthly Orders' AS MetricName,
    COUNT(*) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Orders placed in current month' AS Description
FROM Orders 
WHERE IsActive = 1
AND YEAR(OrderDate) = YEAR(GETDATE())
AND MONTH(OrderDate) = MONTH(GETDATE())

UNION ALL

SELECT 
    'SALES_REVENUE' AS BusinessArea,
    'Monthly Revenue' AS MetricName,
    CAST(SUM(TotalAmount) AS INT) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Total revenue from current month orders' AS Description
FROM Orders 
WHERE IsActive = 1
AND YEAR(OrderDate) = YEAR(GETDATE())
AND MONTH(OrderDate) = MONTH(GETDATE())

UNION ALL

SELECT 
    'CUSTOMER_MANAGEMENT' AS BusinessArea,
    'Active Customers' AS MetricName,
    COUNT(*) AS CurrentValue,
    NULL AS PreviousValue,
    NULL AS PercentChange,
    'Active customers in the system' AS Description
FROM Customers 
WHERE IsActive = 1

ORDER BY BusinessArea, MetricName;
```

---

## 1.5 Performance Optimization with UNION

### Best Practices for UNION Performance

```sql
-- TechCorp Example: Optimized UNION Query for Large Datasets
-- Demonstrates performance optimization techniques

-- Optimized employee and customer contact consolidation
-- Using indexes and proper filtering for performance

-- Step 1: Create indexes for better performance (run separately)
/*
CREATE INDEX IX_Employees_Active_Department ON Employees (IsActive, DepartmentID) INCLUDE (e.FirstName, e.LastName, WorkEmail);
CREATE INDEX IX_Customers_Active_Country ON Customers (IsActive, Country) INCLUDE (CompanyName, ContactName, WorkEmail);
*/

-- Step 2: Optimized UNION query with proper indexing strategy
WITH EmployeeContacts AS (
    SELECT 
        'EMPLOYEE' AS ContactType,
        CAST(e.EmployeeID AS NVARCHAR(20)) AS ContactID,
        e.FirstName + ' ' + e.LastName AS ContactName,
        WorkEmail,
        d.DepartmentName AS Organization,
        d.Location AS ContactLocation,
        'Internal' AS ContactCategory
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    AND e.WorkEmail IS NOT NULL
),
CustomerContacts AS (
    SELECT 
        'CUSTOMER' AS ContactType,
        'CUST_' + CAST(CustomerID AS NVARCHAR(20)) AS ContactID,
        ISNULL(ContactName, CompanyName) AS ContactName,
        WorkEmail,
        CompanyName AS Organization,
        City + ', ' + Country AS ContactLocation,
        'External' AS ContactCategory
    FROM Customers
    WHERE IsActive = 1
    AND WorkEmail IS NOT NULL
)

-- Combine with optimized performance
SELECT 
    ContactType,
    ContactID,
    ContactName,
    WorkEmail,
    Organization,
    ContactLocation,
    ContactCategory,
    GETDATE() AS ReportGeneratedDate
FROM EmployeeContacts

UNION ALL

SELECT 
    ContactType,
    ContactID,
    ContactName,
    WorkEmail,
    Organization,
    ContactLocation,
    ContactCategory,
    GETDATE() AS ReportGeneratedDate
FROM CustomerContacts

ORDER BY ContactCategory, ContactType, ContactName;

-- Performance monitoring query
SELECT 
    'Performance Metrics' AS ReportSection,
    COUNT(*) AS TotalContacts,
    SUM(CASE WHEN ContactType = 'EMPLOYEE' THEN 1 ELSE 0 END) AS EmployeeContacts,
    SUM(CASE WHEN ContactType = 'CUSTOMER' THEN 1 ELSE 0 END) AS CustomerContacts,
    CAST(AVG(LEN(ContactName)) AS INT) AS AvgNameLength
FROM (
    SELECT ContactType, ContactName FROM EmployeeContacts
    UNION ALL
    SELECT ContactType, ContactName FROM CustomerContacts
) CombinedContacts;
```

---

## 1.6 UNION with Conditional Logic

### Dynamic UNION Queries

```sql
-- TechCorp Example: Conditional Reporting with UNION
-- Creates dynamic reports based on business conditions

DECLARE @ReportType NVARCHAR(20) = 'COMPREHENSIVE'; -- 'SUMMARY', 'DETAILED', 'COMPREHENSIVE'
DECLARE @DateRange INT = 90; -- Days to look back

-- Dynamic union query based on report requirements
IF @ReportType = 'COMPREHENSIVE'
BEGIN
    -- Comprehensive report with all data sources
    SELECT 
        'EMPLOYEE_METRICS' AS DataSource,
        d.DepartmentName AS Category,
        COUNT(e.EmployeeID) AS RecordCount,
        AVG(e.BaseSalary) AS AverageValue,
        MIN(e.HireDate) AS EarliestDate,
        MAX(e.HireDate) AS LatestDate,
        'Active employees by department' AS Description
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName

    UNION ALL

    SELECT 
        'PROJECT_METRICS' AS DataSource,
        'PROJECT_BUDGET' AS Category,
        COUNT(p.ProjectID) AS RecordCount,
        AVG(p.Budget) AS AverageValue,
        MIN(p.StartDate) AS EarliestDate,
        MAX(ISNULL(p.EndDate, GETDATE())) AS LatestDate,
        'Active projects and budgets' AS Description
    FROM Projects p
    WHERE p.IsActive = 1

    UNION ALL

    SELECT 
        'ORDER_METRICS' AS DataSource,
        'MONTHLY_ORDERS' AS Category,
        COUNT(o.OrderID) AS RecordCount,
        AVG(o.TotalAmount) AS AverageValue,
        MIN(o.OrderDate) AS EarliestDate,
        MAX(o.OrderDate) AS LatestDate,
        'Recent order activity' AS Description
    FROM Orders o
    WHERE o.IsActive = 1
    AND o.OrderDate >= DATEADD(DAY, -@DateRange, GETDATE())

    ORDER BY DataSource, Category;
END
ELSE IF @ReportType = 'SUMMARY'
BEGIN
    -- Summary report with key metrics only
    SELECT 
        'SUMMARY_METRICS' AS DataSource,
        'TOTAL_EMPLOYEES' AS Category,
        COUNT(*) AS RecordCount,
        0 AS AverageValue,
        MIN(e.HireDate) AS EarliestDate,
        MAX(e.HireDate) AS LatestDate,
        'Total active employees' AS Description
    FROM Employees e 
    WHERE IsActive = 1

    UNION ALL

    SELECT 
        'SUMMARY_METRICS' AS DataSource,
        'TOTAL_PROJECTS' AS Category,
        COUNT(*) AS RecordCount,
        0 AS AverageValue,
        MIN(StartDate) AS EarliestDate,
        MAX(ISNULL(EndDate, GETDATE())) AS LatestDate,
        'Total active projects' AS Description
    FROM Projects p 
    WHERE IsActive = 1

    ORDER BY Category;
END;
```

---

## Summary

Writing queries with the UNION operator enables TechCorp to create comprehensive, unified reports from multiple data sources:

**Key UNION Concepts:**

- **UNION vs UNION ALL**: Choose based on duplicate handling requirements and performance needs
- **Column Compatibility**: Ensure matching column count and compatible data types across all SELECT statements
- **Performance Optimization**: Use proper indexing and filtering strategies for large datasets
- **Data Type Handling**: Apply appropriate conversions when combining different data types

**TechCorp Applications:**

- **Executive Reporting**: Combining multiple business metrics into unified dashboards
- **Contact Management**: Consolidating employee and customer contact information
- **Financial Analysis**: Merging different types of financial transactions and budgets
- **Performance Analytics**: Combining various performance indicators from different sources

**Best Practices Demonstrated:**

- Proper column ordering and naming conventions
- Efficient use of UNION ALL when duplicates are not a concern
- Strategic use of CTEs with UNION for complex reporting
- Performance optimization through appropriate indexing
- Dynamic reporting with conditional UNION logic

**Advanced Techniques:**

- Combining aggregated and detailed data in single reports
- Using UNION with window functions for advanced analytics
- Implementing conditional logic for flexible reporting
- Performance monitoring and optimization strategies

Mastering UNION operations enables TechCorp's development teams to create sophisticated reporting solutions that provide comprehensive business insights while maintaining optimal query performance.