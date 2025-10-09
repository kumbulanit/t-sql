# Lesson 1: Writing Queries with the UNION Operator

## Overview

The UNION operator is a fundamental set operation in T-SQL that combines the results of multiple SELECT statements into a single unified result set. Understanding UNION and UNION ALL operations is essential for data consolidation, comprehensive reporting, and creating unified views of distributed information in TechCorp's business environment.

## 🏢 TechCorp Business Context

**UNION Operations in Modern Business:**
- **Multi-Source Reporting**: Combining data from current and historical systems
- **Departmental Consolidation**: Merging similar data from different departments
- **Compliance Reporting**: Unified views for regulatory requirements
- **Data Migration**: Consolidating data during system transitions
- **Executive Dashboards**: Creating comprehensive business overview reports

### 📋 TechCorp Database Schema Reference

**Core Tables for UNION Operations:**
```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
EmployeeArchive: EmployeeID, FirstName, LastName, BaseSalary, DepartmentID, TerminationDate, Reason, IsActive
```

## Understanding UNION vs UNION ALL

### Core Differences and Performance Impact

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    UNION vs UNION ALL - Performance Analysis               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  UNION (Removes Duplicates):                                               │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT Name, d.DepartmentName FROM Active │                                   │
│  │ UNION                               │  →  • Sorts data to find dupes    │
│  │ SELECT Name, d.DepartmentName FROM Temp   │      • Higher memory usage        │
│  │                                     │      • Slower execution           │
│  └─────────────────────────────────────┘      • Guaranteed unique results  │
│                                                                             │
│  UNION ALL (Preserves All Rows):                                          │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT Name, d.DepartmentName FROM Active │                                   │
│  │ UNION ALL                           │  →  • No duplicate checking       │
│  │ SELECT Name, d.DepartmentName FROM Temp   │      • Lower memory usage         │
│  │                                     │      • Faster execution           │
│  └─────────────────────────────────────┘      • May contain duplicates     │
│                                                                             │
│  Best Practice: Use UNION ALL when possible, add DISTINCT if needed        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### UNION Operation Requirements

1. **Column Count Match**: All SELECT statements must have the same number of columns
2. **Data Type Compatibility**: Corresponding columns must have compatible data types
3. **Column Order**: Columns are matched by position, not by name
4. **Result Column Names**: Final result uses column names from the first SELECT
5. **ORDER BY Placement**: Only allowed at the end, applies to entire result set

## Fundamental UNION Patterns

### 1. Basic Data Consolidation

#### TechCorp Example: Comprehensive Contact Directory
```sql
-- Create unified contact list for emergency communications
SELECT 
    'Internal' AS ContactCategory,
    'Employee' AS ContactType,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.WorkEmail AS ContactEmail,
    d.DepartmentName AS Organization,
    d.Location AS PrimaryLocation,
    e.JobTitle AS Position,
    'Active' AS Status
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.WorkEmail IS NOT NULL
  AND d.IsActive = 1

UNION ALL

SELECT 
    'External' AS ContactCategory,
    'Customer' AS ContactType,
    c.ContactName AS FullName,
    c.WorkEmail AS ContactEmail,
    c.CompanyName AS Organization,
    c.City + ', ' + c.Country AS PrimaryLocation,
    'Customer Contact' AS Position,
    'Active' AS Status
FROM Customers c
WHERE c.IsActive = 1
  AND c.WorkEmail IS NOT NULL

ORDER BY ContactCategory, Organization, FullName;
```

#### TechCorp Example: Financial Summary Consolidation
```sql
-- Combine revenue streams for executive financial reporting
SELECT 
    'Current Period' AS ReportingPeriod,
    'Order Revenue' AS RevenueStream,
    YEAR(o.OrderDate) AS FiscalYear,
    MONTH(o.OrderDate) AS FiscalMonth,
    COUNT(*) AS TransactionCount,
    SUM(o.TotalAmount) AS RevenueAmount,
    AVG(o.TotalAmount) AS AverageTransactionValue,
    'Operations' AS BusinessUnit
FROM Orders o
WHERE o.IsActive = 1
  AND o.OrderDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)

UNION ALL

SELECT 
    'Current Period' AS ReportingPeriod,
    'Project Revenue' AS RevenueStream,
    YEAR(p.StartDate) AS FiscalYear,
    MONTH(p.StartDate) AS FiscalMonth,
    COUNT(*) AS TransactionCount,
    SUM(p.Budget) AS RevenueAmount,
    AVG(p.Budget) AS AverageTransactionValue,
    'Project Management' AS BusinessUnit
FROM Projects p
WHERE p.IsActive = 1
  AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY YEAR(p.StartDate), MONTH(p.StartDate)

ORDER BY FiscalYear DESC, FiscalMonth DESC, RevenueStream;
```

### 2. Historical Data Integration

#### TechCorp Example: Complete Employee Lifecycle Analysis
```sql
-- Comprehensive employee analysis including current and former employees
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.HireDate,
    NULL AS TerminationDate,
    'Active' AS EmploymentStatus,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS TenureYears,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Senior'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Intermediate'
        ELSE 'Junior'
    END AS ExperienceLevel
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1

UNION ALL

SELECT 
    ea.EmployeeID,
    ea.FirstName + ' ' + ea.LastName AS EmployeeName,
    ea.JobTitle,
    d.DepartmentName,
    ea.HireDate,
    ea.TerminationDate,
    'Terminated' AS EmploymentStatus,
    DATEDIFF(YEAR, ea.HireDate, ISNULL(ea.TerminationDate, GETDATE())) AS TenureYears,
    FORMAT(ea.BaseSalary, 'C') AS CurrentSalary,
    CASE 
        WHEN DATEDIFF(YEAR, ea.HireDate, ISNULL(ea.TerminationDate, GETDATE())) >= 10 THEN 'Senior'
        WHEN DATEDIFF(YEAR, ea.HireDate, ISNULL(ea.TerminationDate, GETDATE())) >= 5 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, ea.HireDate, ISNULL(ea.TerminationDate, GETDATE())) >= 2 THEN 'Intermediate'
        ELSE 'Junior'
    END AS ExperienceLevel
FROM EmployeeArchive ea
INNER JOIN Departments d ON ea.DepartmentID = d.DepartmentID
WHERE ea.TerminationDate >= DATEADD(YEAR, -3, GETDATE())  -- Last 3 years only
  AND d.IsActive = 1

ORDER BY EmploymentStatus, DepartmentName, TenureYears DESC;
```

## Advanced UNION Applications

### 1. Multi-Dimensional Business Intelligence

#### TechCorp Example: Executive Performance Dashboard
```sql
-- Comprehensive business metrics dashboard using UNION operations
SELECT 
    'Human Resources' AS BusinessDimension,
    'Employee Metrics' AS MetricCategory,
    'Total Active Employees' AS MetricName,
    CAST(COUNT(*) AS VARCHAR(20)) AS MetricValue,
    'Headcount' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current' AS TimePeriod
FROM Employees 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Human Resources' AS BusinessDimension,
    'Compensation' AS MetricCategory,
    'Average Base BaseSalary' AS MetricName,
    FORMAT(AVG(e.BaseSalary), 'C') AS MetricValue,
    'Currency' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current' AS TimePeriod
FROM Employees 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Project Management' AS BusinessDimension,
    'Project Portfolio' AS MetricCategory,
    'Active Projects' AS MetricName,
    CAST(COUNT(*) AS VARCHAR(20)) AS MetricValue,
    'Count' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current' AS TimePeriod
FROM Projects 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Project Management' AS BusinessDimension,
    'Financial' AS MetricCategory,
    'Total Project Investment' AS MetricName,
    FORMAT(SUM(Budget), 'C') AS MetricValue,
    'Currency' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current' AS TimePeriod
FROM Projects 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Sales Operations' AS BusinessDimension,
    'Revenue' AS MetricCategory,
    'Monthly Orders (Current)' AS MetricName,
    CAST(COUNT(*) AS VARCHAR(20)) AS MetricValue,
    'Count' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current Month' AS TimePeriod
FROM Orders 
WHERE IsActive = 1
  AND YEAR(OrderDate) = YEAR(GETDATE())
  AND MONTH(OrderDate) = MONTH(GETDATE())

UNION ALL

SELECT 
    'Sales Operations' AS BusinessDimension,
    'Revenue' AS MetricCategory,
    'Monthly Revenue (Current)' AS MetricName,
    FORMAT(SUM(TotalAmount), 'C') AS MetricValue,
    'Currency' AS UnitOfMeasure,
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS ReportDate,
    'Current Month' AS TimePeriod
FROM Orders 
WHERE IsActive = 1
  AND YEAR(OrderDate) = YEAR(GETDATE())
  AND MONTH(OrderDate) = MONTH(GETDATE())

ORDER BY BusinessDimension, MetricCategory, MetricName;
```

### 2. Comparative Analysis with UNION

#### TechCorp Example: Quarter-over-Quarter Business Analysis
```sql
-- Comprehensive quarterly business comparison
SELECT 
    'Q1 2024' AS Quarter,
    'Orders' AS BusinessMetric,
    COUNT(*) AS TransactionVolume,
    SUM(o.TotalAmount) AS TotalValue,
    AVG(o.TotalAmount) AS AverageValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ProcessingEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-01-01' 
  AND o.OrderDate < '2024-04-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q2 2024' AS Quarter,
    'Orders' AS BusinessMetric,
    COUNT(*) AS TransactionVolume,
    SUM(o.TotalAmount) AS TotalValue,
    AVG(o.TotalAmount) AS AverageValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ProcessingEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-04-01' 
  AND o.OrderDate < '2024-07-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q3 2024' AS Quarter,
    'Orders' AS BusinessMetric,
    COUNT(*) AS TransactionVolume,
    SUM(o.TotalAmount) AS TotalValue,
    AVG(o.TotalAmount) AS AverageValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ProcessingEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-07-01' 
  AND o.OrderDate < '2024-10-01'
  AND o.IsActive = 1

UNION ALL

SELECT 
    'Q4 2024' AS Quarter,
    'Orders' AS BusinessMetric,
    COUNT(*) AS TransactionVolume,
    SUM(o.TotalAmount) AS TotalValue,
    AVG(o.TotalAmount) AS AverageValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT o.EmployeeID) AS ProcessingEmployees
FROM Orders o
WHERE o.OrderDate >= '2024-10-01' 
  AND o.OrderDate < '2025-01-01'
  AND o.IsActive = 1

ORDER BY 
    CASE Quarter 
        WHEN 'Q1 2024' THEN 1 
        WHEN 'Q2 2024' THEN 2 
        WHEN 'Q3 2024' THEN 3 
        WHEN 'Q4 2024' THEN 4 
    END;
```

### 3. Complex Data Transformation

#### TechCorp Example: Multi-Role Employee Skills Matrix
```sql
-- Create comprehensive employee skills and capabilities matrix
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    'Leadership' AS SkillDomain,
    CASE 
        WHEN mgmt_metrics.DirectReports >= 10 THEN 'Expert'
        WHEN mgmt_metrics.DirectReports >= 5 THEN 'Advanced'
        WHEN mgmt_metrics.DirectReports >= 1 THEN 'Intermediate'
        ELSE 'None'
    END AS SkillLevel,
    mgmt_metrics.DirectReports AS SkillMetric,
    'Direct Reports Managed' AS MetricDescription,
    mgmt_metrics.DirectReports * 25 AS SkillScore
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
CROSS APPLY (
    SELECT COUNT(*) AS DirectReports
    FROM Employees subordinate
    WHERE subordinate.ManagerID = e.EmployeeID
      AND subordinate.IsActive = 1
) mgmt_metrics
WHERE e.IsActive = 1
  AND d.IsActive = 1

UNION ALL

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    'Project Management' AS SkillDomain,
    CASE 
        WHEN proj_metrics.ProjectsManaged >= 5 THEN 'Expert'
        WHEN proj_metrics.ProjectsManaged >= 3 THEN 'Advanced'
        WHEN proj_metrics.ProjectsManaged >= 1 THEN 'Intermediate'
        ELSE 'None'
    END AS SkillLevel,
    proj_metrics.ProjectsManaged AS SkillMetric,
    'Projects Successfully Managed' AS MetricDescription,
    proj_metrics.ProjectsManaged * 20 AS SkillScore
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
CROSS APPLY (
    SELECT COUNT(*) AS ProjectsManaged
    FROM Projects p
    WHERE p.ProjectManagerID = e.EmployeeID
      AND p.IsActive = 1
) proj_metrics
WHERE e.IsActive = 1
  AND d.IsActive = 1

UNION ALL

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    'Customer Relations' AS SkillDomain,
    CASE 
        WHEN order_metrics.OrdersProcessed >= 50 THEN 'Expert'
        WHEN order_metrics.OrdersProcessed >= 20 THEN 'Advanced'
        WHEN order_metrics.OrdersProcessed >= 1 THEN 'Intermediate'
        ELSE 'None'
    END AS SkillLevel,
    order_metrics.OrdersProcessed AS SkillMetric,
    'Customer Orders Processed' AS MetricDescription,
    order_metrics.OrdersProcessed * 2 AS SkillScore
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
CROSS APPLY (
    SELECT COUNT(*) AS OrdersProcessed
    FROM Orders o
    WHERE o.EmployeeID = e.EmployeeID
      AND o.IsActive = 1
) order_metrics
WHERE e.IsActive = 1
  AND d.IsActive = 1

ORDER BY EmployeeName, SkillDomain;
```

## Performance Optimization Strategies

### 1. UNION vs UNION ALL Performance Analysis

#### Performance Testing Framework
```sql
-- Performance comparison: UNION vs UNION ALL
-- Set up performance monitoring
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- UNION ALL approach (faster)
SELECT 'UNION ALL Test' AS TestType, COUNT(*) AS ResultCount
FROM (
    SELECT EmployeeID, FirstName, LastName FROM Employees WHERE IsActive = 1
    UNION ALL
    SELECT CustomerID, ContactName, CompanyName FROM Customers WHERE IsActive = 1
) combined_data;

-- UNION approach (slower due to duplicate removal)
SELECT 'UNION Test' AS TestType, COUNT(*) AS ResultCount
FROM (
    SELECT EmployeeID, FirstName, LastName FROM Employees WHERE IsActive = 1
    UNION
    SELECT CustomerID, ContactName, CompanyName FROM Customers WHERE IsActive = 1
) combined_data;

-- Optimal approach: UNION ALL with explicit DISTINCT when needed
SELECT DISTINCT 'Optimized Test' AS TestType, EmployeeID, FirstName, LastName
FROM (
    SELECT EmployeeID, FirstName, LastName FROM Employees WHERE IsActive = 1
    UNION ALL
    SELECT CustomerID, ContactName, CompanyName FROM Customers WHERE IsActive = 1
) combined_data;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

### 2. Index Optimization for UNION Operations

#### TechCorp Example: Index-Optimized UNION Query
```sql
-- Optimized UNION query with proper indexing strategy
-- Recommended indexes:
-- CREATE INDEX IX_Orders_OrderDate_IsActive ON Orders(OrderDate, IsActive) INCLUDE (CustomerID, TotalAmount);
-- CREATE INDEX IX_Projects_StartDate_IsActive ON Projects(StartDate, IsActive) INCLUDE (ProjectManagerID, Budget);

SELECT 
    'Revenue Transaction' AS TransactionType,
    FORMAT(o.OrderDate, 'yyyy-MM-dd') AS TransactionDate,
    o.TotalAmount AS Amount,
    'Customer Order' AS Source,
    c.CompanyName AS ClientName,
    e.FirstName + ' ' + e.LastName AS ProcessedBy
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
  AND o.IsActive = 1
  AND c.IsActive = 1
  AND e.IsActive = 1

UNION ALL

SELECT 
    'Project Investment' AS TransactionType,
    FORMAT(p.StartDate, 'yyyy-MM-dd') AS TransactionDate,
    p.Budget AS Amount,
    'Internal Project' AS Source,
    'TechCorp Internal' AS ClientName,
    mgr.FirstName + ' ' + mgr.LastName AS ProcessedBy
FROM Projects p
INNER JOIN Employees mgr ON p.ProjectManagerID = mgr.EmployeeID
WHERE p.StartDate >= DATEADD(YEAR, -1, GETDATE())
  AND p.IsActive = 1
  AND mgr.IsActive = 1

ORDER BY TransactionDate DESC, Amount DESC;
```

## Business Intelligence Applications

### 1. Regulatory Compliance Reporting

#### TechCorp Example: Comprehensive Audit Trail
```sql
-- Complete audit trail for compliance reporting
SELECT 
    'Employee Transaction' AS AuditCategory,
    'BaseSalary Change' AS TransactionType,
    e.EmployeeID AS EntityID,
    e.FirstName + ' ' + e.LastName AS EntityName,
    FORMAT(e.BaseSalary, 'C') AS TransactionAmount,
    'Current' AS TransactionStatus,
    FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS TransactionTimestamp,
    d.DepartmentName AS BusinessUnit,
    'System Generated' AS TransactionSource
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1

UNION ALL

SELECT 
    'Customer Transaction' AS AuditCategory,
    'Order Placement' AS TransactionType,
    CAST(o.OrderID AS VARCHAR(20)) AS EntityID,
    c.CompanyName AS EntityName,
    FORMAT(o.TotalAmount, 'C') AS TransactionAmount,
    'Completed' AS TransactionStatus,
    FORMAT(o.OrderDate, 'yyyy-MM-dd HH:mm:ss') AS TransactionTimestamp,
    'Sales' AS BusinessUnit,
    'Customer Portal' AS TransactionSource
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
  AND o.IsActive = 1
  AND c.IsActive = 1

UNION ALL

SELECT 
    'Project Transaction' AS AuditCategory,
    'Budget Allocation' AS TransactionType,
    CAST(p.ProjectID AS VARCHAR(20)) AS EntityID,
    p.ProjectName AS EntityName,
    FORMAT(p.Budget, 'C') AS TransactionAmount,
    'Active' AS TransactionStatus,
    FORMAT(p.StartDate, 'yyyy-MM-dd HH:mm:ss') AS TransactionTimestamp,
    'Project Management' AS BusinessUnit,
    'Project System' AS TransactionSource
FROM Projects p
WHERE p.StartDate >= DATEADD(MONTH, -3, GETDATE())
  AND p.IsActive = 1

ORDER BY TransactionTimestamp DESC, AuditCategory;
```

### 2. Data Quality and Validation

#### TechCorp Example: Comprehensive Data Health Check
```sql
-- Data quality assessment across all major entities
SELECT 
    'Employee Data Quality' AS DataCategory,
    'Missing Email Addresses' AS QualityIssue,
    COUNT(*) AS IssueCount,
    'High' AS SeverityLevel,
    'Employee productivity and communication may be impacted' AS BusinessImpact
FROM Employees e
WHERE (e.WorkEmail IS NULL OR e.WorkEmail = '')
  AND e.IsActive = 1

UNION ALL

SELECT 
    'Customer Data Quality' AS DataCategory,
    'Missing Contact Information' AS QualityIssue,
    COUNT(*) AS IssueCount,
    'High' AS SeverityLevel,
    'Customer service and follow-up communications compromised' AS BusinessImpact
FROM Customers c
WHERE (c.WorkEmail IS NULL OR c.WorkEmail = '' OR c.ContactName IS NULL)
  AND c.IsActive = 1

UNION ALL

SELECT 
    'Project Data Quality' AS DataCategory,
    'Projects Without Valid Managers' AS QualityIssue,
    COUNT(*) AS IssueCount,
    'Critical' AS SeverityLevel,
    'Project governance and accountability issues' AS BusinessImpact
FROM Projects p
LEFT JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
WHERE (e.EmployeeID IS NULL OR e.IsActive = 0)
  AND p.IsActive = 1

UNION ALL

SELECT 
    'Order Data Quality' AS DataCategory,
    'Orders Without Valid Customer Data' AS QualityIssue,
    COUNT(*) AS IssueCount,
    'Critical' AS SeverityLevel,
    'Revenue tracking and customer service problems' AS BusinessImpact
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE (c.CustomerID IS NULL OR c.IsActive = 0)
  AND o.IsActive = 1

ORDER BY 
    CASE SeverityLevel 
        WHEN 'Critical' THEN 1 
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3 
        ELSE 4 
    END,
    IssueCount DESC;
```

## Best Practices and Common Patterns

### 1. Data Type Consistency

#### Proper Data Type Handling
```sql
-- ✅ GOOD: Explicit data type conversions for compatibility
SELECT 
    CAST(e.EmployeeID AS VARCHAR(20)) AS RecordID,
    e.FirstName + ' ' + e.LastName AS RecordName,
    'Employee' AS RecordType,
    CAST(e.BaseSalary AS DECIMAL(18,2)) AS RecordValue,
    e.HireDate AS RecordDate
FROM Employees e
WHERE e.IsActive = 1

UNION ALL

SELECT 
    CAST(o.OrderID AS VARCHAR(20)) AS RecordID,
    c.CompanyName AS RecordName,
    'Order' AS RecordType,
    o.TotalAmount AS RecordValue,
    o.OrderDate AS RecordDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.IsActive = 1
  AND c.IsActive = 1

ORDER BY RecordDate DESC;
```

### 2. Efficient Filtering Strategies

#### Early Filtering for Performance
```sql
-- ✅ GOOD: Filter early in each SELECT statement
SELECT d.DepartmentName,
    'Current' AS Period,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE d.IsActive = 1
  AND e.IsActive = 1
  AND e.HireDate <= GETDATE()
GROUP BY d.DepartmentID, d.DepartmentName

UNION ALL

SELECT d.DepartmentName,
    'Historical' AS Period,
    COUNT(*) AS EmployeeCount,
    AVG(ea.BaseSalary) AS AvgSalary
FROM Departments d
INNER JOIN EmployeeArchive ea ON d.DepartmentID = ea.DepartmentID
WHERE d.IsActive = 1
  AND ea.TerminationDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY d.DepartmentID, d.DepartmentName

ORDER BY d.DepartmentName, Period;
```

### 3. Meaningful Column Aliasing

#### Clear and Consistent Naming
```sql
-- ✅ GOOD: Descriptive and consistent column aliases
SELECT 
    'Employee Contact' AS ContactSource,
    e.FirstName + ' ' + e.LastName AS ContactPersonName,
    e.WorkEmail AS PrimaryEmailAddress,
    d.DepartmentName AS OrganizationalUnit,
    d.Location AS PhysicalLocation,
    'Internal' AS ContactClassification
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.WorkEmail IS NOT NULL

UNION ALL

SELECT 
    'Customer Contact' AS ContactSource,
    c.ContactName AS ContactPersonName,
    c.WorkEmail AS PrimaryEmailAddress,
    c.CompanyName AS OrganizationalUnit,
    c.City + ', ' + c.Country AS PhysicalLocation,
    'External' AS ContactClassification
FROM Customers c
WHERE c.IsActive = 1
  AND c.WorkEmail IS NOT NULL

ORDER BY ContactClassification, OrganizationalUnit;
```

## Common Pitfalls and Solutions

### 1. Column Count Mismatch

#### Problem and Solution
```sql
-- ❌ PROBLEM: Different number of columns
SELECT FirstName, LastName FROM Employees WHERE IsActive = 1
UNION
SELECT CompanyName FROM Customers WHERE IsActive = 1;  -- Error: Column count mismatch

-- ✅ SOLUTION: Ensure consistent column count
SELECT FirstName, LastName, 'Employee' AS RecordType FROM Employees WHERE IsActive = 1
UNION
SELECT ContactName, CompanyName, 'Customer' AS RecordType FROM Customers WHERE IsActive = 1;
```

### 2. Data Type Incompatibility

#### Problem and Solution
```sql
-- ❌ PROBLEM: Incompatible data types
SELECT EmployeeID, BaseSalary FROM Employees e  -- INT, DECIMAL
UNION
SELECT CompanyName, ContactName FROM Customers;  -- VARCHAR, VARCHAR

-- ✅ SOLUTION: Convert to compatible types
SELECT 
    CAST(EmployeeID AS VARCHAR(50)) AS RecordID, 
    CAST(BaseSalary AS VARCHAR(50)) AS RecordValue 
FROM Employees WHERE IsActive = 1
UNION
SELECT CompanyName, ContactName FROM Customers WHERE IsActive = 1;
```

### 3. Inefficient ORDER BY Usage

#### Problem and Solution
```sql
-- ❌ PROBLEM: ORDER BY in individual SELECT statements (ignored)
SELECT FirstName, LastName FROM Employees WHERE IsActive = 1 ORDER BY LastName
UNION
SELECT ContactName, CompanyName FROM Customers WHERE IsActive = 1 ORDER BY CompanyName;

-- ✅ SOLUTION: Single ORDER BY at the end
SELECT FirstName, LastName FROM Employees WHERE IsActive = 1
UNION
SELECT ContactName, CompanyName FROM Customers WHERE IsActive = 1
ORDER BY LastName;  -- Applies to entire result set
```

## Summary

UNION operations are fundamental for:

**Key Benefits:**
- **Data Consolidation**: Combine results from multiple sources seamlessly
- **Flexible Reporting**: Create comprehensive business views
- **Historical Analysis**: Merge current and archived data effectively
- **Performance Options**: Choose between UNION (unique) and UNION ALL (fast)

**Business Applications:**
- Executive dashboards and KPI reporting
- Compliance and audit trail generation
- Data quality assessment and validation
- Multi-source business intelligence
- Customer and employee directory consolidation

**Performance Best Practices:**
- Use UNION ALL when duplicates are acceptable or expected
- Apply filtering early in each SELECT statement
- Ensure proper indexing on filtered columns
- Consider data type conversions for optimal performance

**Quality Assurance:**
- Maintain consistent column structures
- Use explicit data type conversions
- Apply meaningful column aliases
- Validate business logic across all SELECT statements

UNION operations provide TechCorp with essential capabilities for creating unified, comprehensive business reports that combine data from multiple sources while maintaining performance and data integrity standards.