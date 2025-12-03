# Lesson 3: Using Column and Table Aliases

## Overview
Aliases are alternative names for columns and tables that make queries more readable, provide meaningful column headers, and simplify complex queries. This lesson covers both column and table aliases, from basic usage to advanced scenarios involving complex joins and subqueries.

## Understanding Aliases

### What Are Aliases?
- **Column Aliases**: Alternative names for columns in the result set
- **Table Aliases**: Shortened names for tables used in queries
- **Benefits**: Improved readability, shorter code, meaningful output headers

### Basic Syntax
```sql
-- Column aliases
SELECT column_name AS alias_name
SELECT column_name alias_name  -- AS keyword is optional

-- Table aliases
FROM table_name AS alias_name
FROM table_name alias_name     -- AS keyword is optional
```

## Simple Examples

### 1. Basic Column Aliases
```sql
-- Using AS keyword (recommended)
SELECT 
    e.FirstName AS First,
    e.LastName AS Last,
    e.BaseSalary AS AnnualSalary
FROM Employees e;

-- Without AS keyword (also valid)
SELECT 
    e.FirstName First,
    e.LastName Last,
    e.BaseSalary AnnualSalary
FROM Employees e;

-- Aliases with spaces (requires brackets or quotes)
SELECT 
    e.FirstName AS [First Name],
    e.LastName AS [Last Name],
    e.BaseSalary AS [Annual e.BaseSalary]
FROM Employees e;
```

### 2. Column Aliases for Calculated Fields
```sql
-- Mathematical calculations with descriptive aliases
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary / 12 AS MonthlySalary,
    e.BaseSalary * 0.15 AS EstimatedTax,
    e.BaseSalary * 0.85 AS NetSalary
FROM Employees e;

-- String operations with aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    UPPER(e.FirstName) AS UpperFirstName,
    LEN(e.FirstName) AS FirstNameLength,
    LEFT(WorkEmail, CHARINDEX('@', WorkEmail) - 1) AS Username
FROM Employees e;
```

### 3. Basic Table Aliases
```sql
-- Simple table alias
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM Employees e;

-- Table alias makes column references shorter and clearer
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.d.DepartmentID
FROM Employees e
WHERE e.BaseSalary > 60000;
```

## Intermediate Examples

### 1. Aliases in JOINs
```sql
-- Table aliases essential for joins
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID;

-- Multiple table aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName AS d.DepartmentName,
    m.FirstName + ' ' + m.LastName AS ManagerName,
    e.BaseSalary AS [Employee e.BaseSalary]
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;
```

### 2. Aliases in Self-Joins
```sql
-- Self-join requires different aliases for the same table
SELECT 
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    mgr.FirstName + ' ' + mgr.LastName AS ManagerName,
    emp.Title AS EmployeeTitle,
    mgr.Title AS ManagerTitle
FROM Employees e emp
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID
ORDER BY mgr.LastName, emp.LastName;

-- Find employees with the same e.BaseSalary
SELECT 
    e1.FirstName + ' ' + e1.LastName AS Employee1,
    e2.FirstName + ' ' + e2.LastName AS Employee2,
    e1.BaseSalary AS SharedSalary
FROM Employees e e1
INNER JOIN Employees e2 ON e1.BaseSalary = e2.BaseSalary
    AND e1.EmployeeID < e2.EmployeeID;
```

### 3. Complex Column Aliases
```sql
-- Business logic with descriptive aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary AS e.BaseSalary,
    CASE 
        WHEN e.BaseSalary > 80000 THEN e.BaseSalary * 0.15
        WHEN e.BaseSalary > 60000 THEN e.BaseSalary * 0.10
        ELSE e.BaseSalary * 0.05
    END AS BonusAmount,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Senior'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Experienced'
        ELSE 'Junior'
    END AS ExperienceLevel,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    DATEADD(YEAR, 1, e.HireDate) AS FirstAnniversary
FROM Employees e;
```

### 4. Aliases in Subqueries
```sql
-- Subquery with table alias
SELECT dept_stats.d.DepartmentName,
    dept_stats.EmployeeCount,
    dept_stats.AverageSalary
FROM (
    SELECT d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AverageBaseSalary
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
    GROUP BY d.DepartmentName
) dept_stats
WHERE dept_stats.EmployeeCount > 2;
```

## Advanced Examples

### 1. Complex Multi-Table Scenarios
```sql
-- Advanced scenario with multiple aliases and calculations
SELECT 
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    dept.DepartmentName AS DepartmentName,
    proj.ProjectName AS CurrentProject,
    emp.BaseSalary AS e.BaseSalary,
    ep.HoursWorked AS ProjectHours,
    CASE 
        WHEN ep.HoursWorked > ep.HoursAllocated THEN 'Over Allocated'
        WHEN ep.HoursWorked = ep.HoursAllocated THEN 'On Track'
        ELSE 'Under Allocated'
    END AS ProjectIsActive,
    ROUND(ep.HoursWorked / ep.HoursAllocated * 100, 2) AS CompletionPercentage,
    mgr.FirstName + ' ' + mgr.LastName AS DirectManager
FROM Employees e emp
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
LEFT JOIN EmployeeProjects ep ON emp.EmployeeID = ep.EmployeeID
LEFT JOIN Projects proj ON ep.ProjectID = proj.ProjectID
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID
WHERE emp.IsActive = 1;
```

### 2. Aliases with Window Functions
```sql
-- Window functions with meaningful aliases
SELECT 
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    dept.DepartmentName AS DepartmentName,
    emp.BaseSalary AS CurrentSalary,
    RANK() OVER (ORDER BY emp.BaseSalary DESC) AS CompanywideSalaryRank,
    RANK() OVER (PARTITION BY emp.DepartmentID ORDER BY emp.BaseSalary DESC) AS DepartmentSalaryRank,
    LAG(emp.BaseSalary) OVER (ORDER BY emp.HireDate) AS PreviousHireSalary,
    LEAD(emp.BaseSalary) OVER (ORDER BY emp.HireDate) AS NextHireSalary,
    AVG(emp.BaseSalary) OVER (PARTITION BY emp.DepartmentID) AS DepartmentAverageSalary,
    emp.BaseSalary - AVG(emp.BaseSalary) OVER (PARTITION BY emp.DepartmentID) AS SalaryVarianceFromDeptAvg
FROM Employees e emp
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
WHERE emp.IsActive = 1;
```

### 3. CTE with Aliases
```sql
-- Common Table Expression with comprehensive aliases
WITH EmployeePerformanceMetrics AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.BaseSalary AS e.BaseSalary,
        e.HireDate AS StartDate,
        d.DepartmentName AS DepartmentName,
        DATEDIFF(MONTH, e.HireDate, GETDATE()) AS TenureInMonths,
        COUNT(ep.ProjectID) AS ActiveProjects,
        ISNULL(SUM(ep.HoursWorked), 0) AS TotalHoursWorked,
        ISNULL(AVG(ep.HoursWorked), 0) AS AverageProjectHours
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, 
             e.HireDate, d.DepartmentName
),
DepartmentBenchmarks AS (
    SELECT d.DepartmentName,
        AVG(e.BaseSalary) AS DepartmentAverageSalary,
        AVG(TenureInMonths) AS DepartmentAverageTenure,
        AVG(TotalHoursWorked) AS DepartmentAverageHours
    FROM EmployeePerformanceMetrics
    GROUP BY DepartmentID
)
SELECT 
    epm.FullName AS EmployeeName,
    epm.DepartmentName AS DepartmentName,
    epm.BaseSalary AS CurrentSalary,
    FORMAT(epm.BaseSalary, 'C') AS FormattedSalary,
    epm.TenureInMonths AS MonthsEmployed,
    epm.ActiveProjects AS ProjectCount,
    epm.TotalHoursWorked AS HoursWorked,
    db.DepartmentAverageSalary AS DeptAvgSalary,
    epm.BaseSalary - db.DepartmentAverageSalary AS SalaryDifferenceFromAvg,
    CASE 
        WHEN epm.BaseSalary > db.DepartmentAverageSalary * 1.2 THEN 'Above Market'
        WHEN epm.BaseSalary < db.DepartmentAverageSalary * 0.8 THEN 'Below Market'
        ELSE 'Market Rate'
    END AS SalaryPosition
FROM EmployeePerformanceMetrics epm
INNER JOIN DepartmentBenchmarks db ON epm.DepartmentName = db.d.DepartmentName
ORDER BY epm.DepartmentName, epm.BaseSalary DESC;
```

### 4. Dynamic Aliases with Pivot Operations
```sql
-- Using aliases in pivot scenarios
WITH MonthlySales AS (
    SELECT 
        emp.FirstName + ' ' + emp.LastName AS SalesPersonName,
        DATENAME(MONTH, ord.OrderDate) AS SalesMonth,
        SUM(ord.OrderTotal) AS MonthlyTotal
    FROM Employees e emp
    INNER JOIN Orders ord ON emp.EmployeeID = ord.EmployeeID
    WHERE YEAR(ord.OrderDate) = 2023
    GROUP BY emp.FirstName, emp.LastName, DATENAME(MONTH, ord.OrderDate)
)
SELECT 
    SalesPersonName AS [Sales Person],
    ISNULL([January], 0) AS [Jan Sales],
    ISNULL([February], 0) AS [Feb Sales],
    ISNULL([March], 0) AS [Mar Sales],
    ISNULL([April], 0) AS [Apr Sales],
    ISNULL([May], 0) AS [May Sales],
    ISNULL([June], 0) AS [Jun Sales],
    ISNULL([January], 0) + ISNULL([February], 0) + ISNULL([March], 0) + 
    ISNULL([April], 0) + ISNULL([May], 0) + ISNULL([June], 0) AS [YTD Total]
FROM MonthlySales
PIVOT (
    SUM(MonthlyTotal)
    FOR SalesMonth IN ([January], [February], [March], [April], [May], [June])
) pivoted_sales
ORDER BY [YTD Total] DESC;
```

## Best Practices for Aliases

### 1. Meaningful and Descriptive Names
```sql
-- Good: Clear, descriptive aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeFullName,
    e.BaseSalary AS AnnualSalary,
    e.BaseSalary / 12 AS MonthlySalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
FROM Employees e;

-- Avoid: Cryptic or meaningless aliases
-- SELECT 
--     e.FirstName + ' ' + e.LastName AS Name,
--     e.BaseSalary AS Sal,
--     e.BaseSalary / 12 AS MoSal,
--     DATEDIFF(YEAR, e.HireDate, GETDATE()) AS Yrs
-- FROM Employees e;
```

### 2. Consistent Naming Conventions
```sql
-- Good: Consistent naming pattern
SELECT 
    emp.EmployeeID AS e.EmployeeID,
    emp.FirstName AS EmployeeFirstName,
    emp.LastName AS EmployeeLastName,
    dept.DepartmentName AS DepartmentName,
    mgr.FirstName AS ManagerFirstName,
    mgr.LastName AS ManagerLastName
FROM Employees e emp
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID;
```

### 3. Use Table Aliases in Multi-Table Queries
```sql
-- Good: Always use table aliases in joins
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    p.ProjectName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID;

-- Avoid: Ambiguous column references without aliases
-- SELECT 
--     e.FirstName,        -- Which table's e.FirstName?
--     e.LastName,         -- Which table's e.LastName?
--     DepartmentName,
--     ProjectName
-- FROM Employees e
-- INNER JOIN Departments d ON Employees.DepartmentID = Departments.DepartmentID;
```

### 4. Short but Meaningful Table Aliases
```sql
-- Good: Short, intuitive aliases
SELECT 
    emp.FirstName,
    dept.DepartmentName,
    proj.ProjectName
FROM Employees e emp
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
LEFT JOIN EmployeeProjects ep ON emp.EmployeeID = ep.EmployeeID
LEFT JOIN Projects proj ON ep.ProjectID = proj.ProjectID;

-- Avoid: Too long or unintuitive aliases
-- FROM Employees e employee_table
-- INNER JOIN Departments department_table ON employee_table.DepartmentID = department_table.DepartmentID;
```

## Common Mistakes and Pitfalls

### 1. Reserved Words as Aliases
```sql
-- Problematic: Using reserved words
SELECT 
    e.FirstName AS [Order],    -- 'Order' is reserved
    e.LastName AS [Group],     -- 'Group' is reserved
    e.BaseSalary AS [Select]       -- 'Select' is reserved
FROM Employees e;

-- Better: Use descriptive, non-reserved words
SELECT 
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    e.BaseSalary AS EmployeeSalary
FROM Employees e;
```

### 2. Alias Scope Confusion
```sql
-- Wrong: Trying to use column alias in WHERE clause
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    e.BaseSalary
FROM Employees e
WHERE FullName LIKE 'John%';  -- Error: FullName not available in WHERE

-- Correct: Use original columns in WHERE
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    e.BaseSalary
FROM Employees e
WHERE e.FirstName + ' ' + e.LastName LIKE 'John%';

-- Or use subquery/CTE
WITH NamedEmployees AS (
    SELECT 
        e.FirstName + ' ' + e.LastName AS FullName,
        e.BaseSalary
    FROM Employees e
)
SELECT *
FROM NamedEmployees
WHERE FullName LIKE 'John%';
```

### 3. Inconsistent Alias Usage
```sql
-- Inconsistent: Sometimes using alias, sometimes not
SELECT 
    e.FirstName,
    e.LastName,           -- Should be e.LastName
    e.BaseSalary,
    d.DepartmentName      -- Should be d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Consistent: Always use aliases when defined
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

## Performance Considerations

### 1. Aliases Don't Impact Performance
```sql
-- Aliases are cosmetic and don't affect query performance
SELECT 
    e.EmployeeID AS ID,
    e.FirstName AS First,
    e.LastName AS Last
FROM Employees e;

-- Performs the same as:
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e;
```

### 2. But Readability Improves Maintenance
```sql
-- Readable queries are easier to maintain and optimize
SELECT 
    emp.EmployeeID AS e.EmployeeID,
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    dept.DepartmentName AS DepartmentName,
    emp.BaseSalary AS CurrentSalary,
    AVG(emp.BaseSalary) OVER (PARTITION BY emp.DepartmentID) AS DepartmentAverage
FROM Employees e emp
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
WHERE emp.IsActive = 1;
```

## Practical Applications

### 1. Report Generation
```sql
-- Clean, professional report output
SELECT 
    ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS [Row #],
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    d.DepartmentName AS [Department],
    e.JobTitle AS [Job Title],
    FORMAT(e.BaseSalary, 'C') AS [Annual e.BaseSalary],
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS [Years of Service],
    CASE 
        WHEN e.ManagerID IS NULL THEN 'N/A'
        ELSE m.FirstName + ' ' + m.LastName
    END AS [Direct Manager]
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;
```

### 2. Data Export Preparation
```sql
-- Prepare data for export with clean column names
SELECT 
    e.EmployeeID AS employee_id,
    e.FirstName AS e.FirstName,
    e.LastName AS e.LastName,
    e.WorkEmail AS email_address,
    d.DepartmentName AS DepartmentName,
    e.JobTitle AS job_title,
    e.BaseSalary AS annual_salary,
    FORMAT(e.HireDate, 'yyyy-MM-dd') AS hire_date,
    CASE WHEN e.IsActive = 1 THEN 'Y' ELSE 'N' END AS is_active
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

## Summary

Key principles for using aliases effectively:

1. **Readability**: Use aliases to make queries more readable and professional
2. **Consistency**: Establish and follow naming conventions
3. **Meaningful Names**: Choose descriptive, business-friendly aliases
4. **Table Aliases**: Always use in multi-table queries to avoid ambiguity
5. **Column Aliases**: Essential for calculated fields and professional output
6. **Scope Awareness**: Remember that column aliases aren't available in WHERE clauses
7. **Avoid Reserved Words**: Don't use SQL keywords as aliases
8. **Professional Output**: Use aliases to create clean, exportable result sets

Aliases are fundamental to writing clean, maintainable SQL code and producing professional-quality reports and data exports.
