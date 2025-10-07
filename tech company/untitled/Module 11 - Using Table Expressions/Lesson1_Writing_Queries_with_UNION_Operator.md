# Lesson 1: Writing Queries with the UNION Operator

## Overview

The UNION operator is a powerful set operation that combines the results of two or more SELECT statements into a single result set. UNION eliminates duplicate rows by default, while UNION ALL preserves all rows including duplicates. This lesson explores how to effectively use UNION operations in TechCorp's business scenarios for data consolidation, reporting, and analysis.

## 🏢 TechCorp Business Context

**UNION Operations in Business:**
- **Data Consolidation**: Combining data from multiple sources or time periods
- **Comprehensive Reporting**: Creating unified views of distributed information
- **Historical Analysis**: Merging current and archived data
- **Multi-Dimensional Views**: Combining different perspectives of the same business entity
- **Data Migration**: Consolidating data during system transitions

### 📋 TechCorp Schema Quick Reference

**Key Tables for UNION Examples:**
```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeArchive: EmployeeID, FirstName, LastName, BaseSalary, DepartmentID, TerminationDate, Reason
```

## Understanding UNION Operations

### UNION vs UNION ALL

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          UNION vs UNION ALL                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  UNION (Removes Duplicates):                                               │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT Name FROM ActiveEmployees    │                                   │
│  │ UNION                               │  →  Distinct Results Only         │
│  │ SELECT Name FROM TempEmployees      │      (Slower - requires sorting)  │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  UNION ALL (Preserves All Rows):                                          │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT Name FROM ActiveEmployees    │                                   │
│  │ UNION ALL                           │  →  All Results Including Dupes   │
│  │ SELECT Name FROM TempEmployees      │      (Faster - no duplicate check)│
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  Key Rules:                                                                │
│  • Same number and order of columns                                        │
│  • Compatible data types                                                   │
│  • Column names from first SELECT                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### UNION Requirements

1. **Same Number of Columns**: All SELECT statements must have identical column counts
2. **Compatible Data Types**: Corresponding columns must have compatible types
3. **Column Order**: Columns are matched by position, not name
4. **Column Names**: Result uses column names from the first SELECT statement

## Basic UNION Patterns

### 1. Simple Data Consolidation

#### TechCorp Example: All Contact Information
```sql
-- Consolidate all contact information from employees and customers
SELECT 
    'Employee' AS ContactType,
    e.FirstName + ' ' + e.LastName AS ContactName,
    e.WorkEmail AS Email,
    d.DepartmentName AS Organization,
    d.Location AS Location,
    'Internal' AS ContactCategory
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION ALL

SELECT 
    'Customer' AS ContactType,
    c.ContactName AS ContactName,
    c.Email AS Email,
    c.CompanyName AS Organization,
    c.City + ', ' + c.Country AS Location,
    'External' AS ContactCategory
FROM Customers c
WHERE c.IsActive = 1

ORDER BY ContactType, ContactName;
```

#### TechCorp Example: Revenue Sources Analysis
```sql
-- Combine different revenue sources for comprehensive analysis
SELECT 
    'Current Orders' AS RevenueSource,
    YEAR(o.OrderDate) AS RevenueYear,
    MONTH(o.OrderDate) AS RevenueMonth,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS TotalRevenue,
    AVG(o.TotalAmount) AS AverageAmount
FROM Orders o
WHERE o.IsActive = 1
  AND o.OrderDate >= '2024-01-01'
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)

UNION ALL

SELECT 
    'Project Revenue' AS RevenueSource,
    YEAR(p.StartDate) AS RevenueYear,
    MONTH(p.StartDate) AS RevenueMonth,
    COUNT(*) AS TransactionCount,
    SUM(p.Budget) AS TotalRevenue,
    AVG(p.Budget) AS AverageAmount
FROM Projects p
WHERE p.IsActive = 1
  AND p.StartDate >= '2024-01-01'
GROUP BY YEAR(p.StartDate), MONTH(p.StartDate)

ORDER BY RevenueYear DESC, RevenueMonth DESC, RevenueSource;
```

### 2. Historical Data Integration

#### TechCorp Example: Current and Former Employees
```sql
-- Create comprehensive employee directory including terminated employees
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName,
    e.HireDate,
    NULL AS TerminationDate,
    'Active' AS EmployeeStatus,
    FORMAT(e.BaseSalary, 'C') AS LastKnownSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsWithCompany
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION ALL

SELECT 
    ea.EmployeeID,
    ea.FirstName,
    ea.LastName,
    ea.JobTitle,
    d.DepartmentName,
    ea.HireDate,
    ea.TerminationDate,
    'Terminated' AS EmployeeStatus,
    FORMAT(ea.BaseSalary, 'C') AS LastKnownSalary,
    DATEDIFF(YEAR, ea.HireDate, ISNULL(ea.TerminationDate, GETDATE())) AS YearsWithCompany
FROM EmployeeArchive ea
INNER JOIN Departments d ON ea.DepartmentID = d.DepartmentID

ORDER BY EmployeeStatus, LastName, FirstName;
```

## Advanced UNION Patterns

### 1. Multi-Source Business Intelligence

#### TechCorp Example: Comprehensive Performance Dashboard
```sql
-- Create unified performance metrics from multiple business areas
SELECT 
    'Employee Performance' AS MetricCategory,
    d.DepartmentName AS BusinessUnit,
    'Salary Analysis' AS MetricType,
    COUNT(*) AS RecordCount,
    AVG(e.BaseSalary) AS AverageValue,
    MAX(e.BaseSalary) AS MaxValue,
    MIN(e.BaseSalary) AS MinValue,
    GETDATE() AS ReportDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName

UNION ALL

SELECT 
    'Project Management' AS MetricCategory,
    d.DepartmentName AS BusinessUnit,
    'Budget Analysis' AS MetricType,
    COUNT(p.ProjectID) AS RecordCount,
    AVG(p.Budget) AS AverageValue,
    MAX(p.Budget) AS MaxValue,
    MIN(p.Budget) AS MinValue,
    GETDATE() AS ReportDate
FROM Projects p
INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE p.IsActive = 1
  AND e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName

UNION ALL

SELECT 
    'Sales Performance' AS MetricCategory,
    d.DepartmentName AS BusinessUnit,
    'Order Analysis' AS MetricType,
    COUNT(o.OrderID) AS RecordCount,
    AVG(o.TotalAmount) AS AverageValue,
    MAX(o.TotalAmount) AS MaxValue,
    MIN(o.TotalAmount) AS MinValue,
    GETDATE() AS ReportDate
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE o.IsActive = 1
  AND e.IsActive = 1
  AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY d.DepartmentID, d.DepartmentName

ORDER BY MetricCategory, BusinessUnit, MetricType;
```

### 2. Time-Series Analysis with UNION

#### TechCorp Example: Quarterly Business Trends
```sql
-- Analyze business trends across multiple quarters
SELECT 
    'Q1 2024' AS Period,
    'Orders' AS DataSource,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS TotalValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ActiveEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-01-01' 
  AND o.OrderDate < '2024-04-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q2 2024' AS Period,
    'Orders' AS DataSource,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS TotalValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ActiveEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-04-01' 
  AND o.OrderDate < '2024-07-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q3 2024' AS Period,
    'Orders' AS DataSource,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS TotalValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ActiveEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-07-01' 
  AND o.OrderDate < '2024-10-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q4 2024' AS Period,
    'Orders' AS DataSource,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS TotalValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ActiveEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-10-01' 
  AND o.OrderDate < '2025-01-01'
  AND o.IsActive = 1

ORDER BY 
    CASE Period 
        WHEN 'Q1 2024' THEN 1 
        WHEN 'Q2 2024' THEN 2 
        WHEN 'Q3 2024' THEN 3 
        WHEN 'Q4 2024' THEN 4 
    END;
```

### 3. Complex Data Transformation

#### TechCorp Example: Employee Skill Matrix
```sql
-- Create comprehensive skill inventory from multiple sources
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    'Management' AS SkillCategory,
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees sub WHERE sub.ManagerID = e.EmployeeID AND sub.IsActive = 1)
        THEN 'Expert'
        ELSE 'None'
    END AS SkillLevel,
    (SELECT COUNT(*) FROM Employees sub WHERE sub.ManagerID = e.EmployeeID AND sub.IsActive = 1) AS SkillMetric,
    'Direct Reports Count' AS MetricDescription
FROM Employees e
WHERE e.IsActive = 1

UNION ALL

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    'Project Management' AS SkillCategory,
    CASE 
        WHEN (SELECT COUNT(*) FROM Projects p WHERE p.ProjectManagerID = e.EmployeeID AND p.IsActive = 1) >= 3
        THEN 'Expert'
        WHEN (SELECT COUNT(*) FROM Projects p WHERE p.ProjectManagerID = e.EmployeeID AND p.IsActive = 1) >= 1
        THEN 'Intermediate'
        ELSE 'None'
    END AS SkillLevel,
    (SELECT COUNT(*) FROM Projects p WHERE p.ProjectManagerID = e.EmployeeID AND p.IsActive = 1) AS SkillMetric,
    'Projects Managed' AS MetricDescription
FROM Employees e
WHERE e.IsActive = 1

UNION ALL

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    'Sales' AS SkillCategory,
    CASE 
        WHEN (SELECT COUNT(*) FROM Orders o WHERE o.EmployeeID = e.EmployeeID AND o.IsActive = 1) >= 10
        THEN 'Expert'
        WHEN (SELECT COUNT(*) FROM Orders o WHERE o.EmployeeID = e.EmployeeID AND o.IsActive = 1) >= 1
        THEN 'Intermediate'
        ELSE 'None'
    END AS SkillLevel,
    (SELECT COUNT(*) FROM Orders o WHERE o.EmployeeID = e.EmployeeID AND o.IsActive = 1) AS SkillMetric,
    'Orders Processed' AS MetricDescription
FROM Employees e
WHERE e.IsActive = 1

ORDER BY EmployeeName, SkillCategory;
```

## Performance Optimization with UNION

### 1. UNION vs UNION ALL Performance

#### Performance Comparison
```sql
-- ✅ GOOD: Use UNION ALL when duplicates are acceptable or known not to exist
SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'USA' AND IsActive = 1
UNION ALL  -- Faster - no duplicate checking
SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'Canada' AND IsActive = 1;

-- ⚠️ CONSIDER: Use UNION only when duplicates must be removed
SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'USA' AND IsActive = 1
UNION  -- Slower - checks and removes duplicates
SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'Canada' AND IsActive = 1;

-- ✅ ALTERNATIVE: Use UNION ALL with DISTINCT if needed
SELECT DISTINCT CustomerID, CompanyName
FROM (
    SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'USA' AND IsActive = 1
    UNION ALL
    SELECT CustomerID, CompanyName FROM Customers WHERE Country = 'Canada' AND IsActive = 1
) combined;
```

### 2. Indexing for UNION Operations

#### TechCorp Example: Optimized UNION Query
```sql
-- Ensure proper indexes for optimal UNION performance
-- Recommended indexes:
-- CREATE INDEX IX_Orders_OrderDate_IsActive ON Orders(OrderDate, IsActive);
-- CREATE INDEX IX_Projects_StartDate_IsActive ON Projects(StartDate, IsActive);

SELECT 
    'Order' AS TransactionType,
    o.OrderDate AS TransactionDate,
    o.TotalAmount AS Amount,
    c.CompanyName AS ClientName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= '2024-01-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Project' AS TransactionType,
    p.StartDate AS TransactionDate,
    p.Budget AS Amount,
    'Internal Project' AS ClientName
FROM Projects p
WHERE p.StartDate >= '2024-01-01'
  AND p.IsActive = 1

ORDER BY TransactionDate DESC;
```

## Common Use Cases and Business Applications

### 1. Reporting and Analytics

#### TechCorp Example: Executive Summary Report
```sql
-- Monthly executive summary combining key business metrics
SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Employee Metrics' AS Category,
    'Total Active Employees' AS Metric,
    CAST(COUNT(*) AS VARCHAR(50)) AS Value,
    'Headcount' AS Unit
FROM Employees 
WHERE IsActive = 1

UNION ALL

SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Employee Metrics' AS Category,
    'Average Salary' AS Metric,
    FORMAT(AVG(BaseSalary), 'C') AS Value,
    'Currency' AS Unit
FROM Employees 
WHERE IsActive = 1

UNION ALL

SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Project Metrics' AS Category,
    'Active Projects' AS Metric,
    CAST(COUNT(*) AS VARCHAR(50)) AS Value,
    'Count' AS Unit
FROM Projects 
WHERE IsActive = 1

UNION ALL

SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Project Metrics' AS Category,
    'Total Project Budget' AS Metric,
    FORMAT(SUM(Budget), 'C') AS Value,
    'Currency' AS Unit
FROM Projects 
WHERE IsActive = 1

UNION ALL

SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Sales Metrics' AS Category,
    'MTD Orders' AS Metric,
    CAST(COUNT(*) AS VARCHAR(50)) AS Value,
    'Count' AS Unit
FROM Orders 
WHERE YEAR(OrderDate) = YEAR(GETDATE())
  AND MONTH(OrderDate) = MONTH(GETDATE())
  AND IsActive = 1

UNION ALL

SELECT 
    FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,
    'Sales Metrics' AS Category,
    'MTD Revenue' AS Metric,
    FORMAT(SUM(TotalAmount), 'C') AS Value,
    'Currency' AS Unit
FROM Orders 
WHERE YEAR(OrderDate) = YEAR(GETDATE())
  AND MONTH(OrderDate) = MONTH(GETDATE())
  AND IsActive = 1

ORDER BY Category, Metric;
```

### 2. Data Validation and Quality

#### TechCorp Example: Data Consistency Check
```sql
-- Identify data inconsistencies across related tables
SELECT 
    'Missing Department References' AS IssueType,
    'Employees without valid departments' AS Description,
    CAST(COUNT(*) AS VARCHAR(50)) AS Count,
    'Critical' AS Severity
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IS NULL
  AND e.IsActive = 1

UNION ALL

SELECT 
    'Orphaned Projects' AS IssueType,
    'Projects without valid managers' AS Description,
    CAST(COUNT(*) AS VARCHAR(50)) AS Count,
    'High' AS Severity
FROM Projects p
LEFT JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
WHERE e.EmployeeID IS NULL
  AND p.IsActive = 1

UNION ALL

SELECT 
    'Invalid Orders' AS IssueType,
    'Orders without valid employees' AS Description,
    CAST(COUNT(*) AS VARCHAR(50)) AS Count,
    'High' AS Severity
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.EmployeeID IS NULL
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Invalid Customer Orders' AS IssueType,
    'Orders without valid customers' AS Description,
    CAST(COUNT(*) AS VARCHAR(50)) AS Count,
    'High' AS Severity
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
  AND o.IsActive = 1

ORDER BY 
    CASE Severity 
        WHEN 'Critical' THEN 1 
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3 
        ELSE 4 
    END,
    IssueType;
```

## Best Practices for UNION Operations

### 1. Query Structure and Readability

#### Best Practice Examples
```sql
-- ✅ GOOD: Clear formatting and consistent column naming
SELECT 
    e.EmployeeID AS ID,
    e.FirstName + ' ' + e.LastName AS FullName,
    'Employee' AS RecordType,
    e.HireDate AS StartDate
FROM Employees e
WHERE e.IsActive = 1

UNION ALL

SELECT 
    c.CustomerID AS ID,
    c.ContactName AS FullName,
    'Customer' AS RecordType,
    c.CreatedDate AS StartDate
FROM Customers c
WHERE c.IsActive = 1

ORDER BY RecordType, FullName;

-- ❌ AVOID: Inconsistent formatting and unclear column purposes
SELECT EmployeeID, FirstName + ' ' + LastName, 'Employee'
FROM Employees WHERE IsActive = 1
UNION ALL
SELECT CustomerID, ContactName, 'Customer' FROM Customers WHERE IsActive = 1;
```

### 2. Data Type Compatibility

#### Handling Data Type Mismatches
```sql
-- ✅ GOOD: Explicit data type conversion
SELECT 
    CAST(e.EmployeeID AS VARCHAR(50)) AS RecordID,
    e.FirstName + ' ' + e.LastName AS Name,
    CAST(e.BaseSalary AS DECIMAL(18,2)) AS Amount,
    e.HireDate AS RecordDate
FROM Employees e
WHERE e.IsActive = 1

UNION ALL

SELECT 
    CAST(o.OrderID AS VARCHAR(50)) AS RecordID,
    c.CompanyName AS Name,
    o.TotalAmount AS Amount,
    o.OrderDate AS RecordDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.IsActive = 1;
```

### 3. Performance Optimization

#### Optimization Strategies
```sql
-- ✅ GOOD: Filter before UNION, use appropriate indexes
SELECT EmployeeID, FirstName, LastName
FROM Employees 
WHERE IsActive = 1 
  AND DepartmentID = 2001  -- Filter early

UNION ALL

SELECT EmployeeID, FirstName, LastName
FROM EmployeeArchive 
WHERE TerminationDate >= '2024-01-01'  -- Filter early
  AND DepartmentID = 2001

ORDER BY LastName, FirstName;

-- ❌ AVOID: Filtering after UNION (less efficient)
SELECT EmployeeID, FirstName, LastName, DepartmentID
FROM (
    SELECT EmployeeID, FirstName, LastName, DepartmentID FROM Employees WHERE IsActive = 1
    UNION ALL
    SELECT EmployeeID, FirstName, LastName, DepartmentID FROM EmployeeArchive
) combined
WHERE DepartmentID = 2001  -- Late filtering is less efficient
ORDER BY LastName, FirstName;
```

## Common Pitfalls and Solutions

### 1. Column Count Mismatch

#### Problem and Solution
```sql
-- ❌ PROBLEM: Different number of columns
SELECT FirstName, LastName FROM Employees
UNION
SELECT CompanyName FROM Customers;  -- ERROR: Column count mismatch

-- ✅ SOLUTION: Ensure same column count
SELECT FirstName, LastName, 'Employee' AS Type FROM Employees
UNION
SELECT ContactName, CompanyName, 'Customer' AS Type FROM Customers;
```

### 2. Data Type Incompatibility

#### Problem and Solution
```sql
-- ❌ PROBLEM: Incompatible data types
SELECT EmployeeID, BaseSalary FROM Employees  -- INT, DECIMAL
UNION
SELECT CompanyName, ContactName FROM Customers;  -- VARCHAR, VARCHAR

-- ✅ SOLUTION: Convert to compatible types
SELECT CAST(EmployeeID AS VARCHAR(50)), CAST(BaseSalary AS VARCHAR(50)) FROM Employees
UNION
SELECT CompanyName, ContactName FROM Customers;
```

### 3. Unexpected ORDER BY Behavior

#### Problem and Solution
```sql
-- ❌ PROBLEM: ORDER BY in individual SELECT statements
SELECT FirstName, LastName FROM Employees ORDER BY LastName  -- This ORDER BY is ignored
UNION
SELECT ContactName, CompanyName FROM Customers ORDER BY CompanyName;  -- This ORDER BY is ignored

-- ✅ SOLUTION: ORDER BY only at the end
SELECT FirstName, LastName FROM Employees
UNION
SELECT ContactName, CompanyName FROM Customers
ORDER BY LastName;  -- This ORDER BY applies to the entire result
```

## Summary

UNION operations are essential for:

**Key Benefits:**
- **Data Consolidation** - Combine results from multiple sources
- **Flexible Reporting** - Create comprehensive business views
- **Historical Analysis** - Merge current and archived data
- **Performance Optimization** - UNION ALL avoids duplicate checking

**Common Use Cases:**
- Executive reporting and dashboards
- Data quality and validation checks
- Historical trend analysis
- Multi-source business intelligence
- Contact and inventory consolidation

**Performance Considerations:**
- Use UNION ALL when duplicates are acceptable
- Filter data before UNION operations
- Ensure proper indexing on filtered columns
- Consider alternative approaches for complex scenarios

**Best Practices:**
- Maintain consistent column structures
- Use explicit data type conversions
- Apply filtering early in each SELECT
- Use meaningful column aliases
- Order results only at the end

UNION operations provide TechCorp with powerful capabilities for creating comprehensive business reports and analysis by combining data from multiple sources while maintaining data integrity and performance.