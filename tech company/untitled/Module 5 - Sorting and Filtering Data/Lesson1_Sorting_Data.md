# Lesson 1: Sorting Data

## Overview
Sorting data is fundamental to presenting query results in a meaningful order. The ORDER BY clause allows you to sort result sets by one or more columns in ascending or descending order. This lesson covers all aspects of data sorting, from basic single-column sorts to complex multi-column ordering with custom sort logic.

## ORDER BY Fundamentals

### Basic Syntax
```sql
SELECT columns
FROM table
WHERE conditions
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...
```

### Key Components
- **ORDER BY**: Clause that specifies sorting criteria
- **Column References**: Can use column names, aliases, or ordinal positions
- **Sort Direction**: ASC (ascending, default) or DESC (descending)
- **Multiple Columns**: Sort by multiple criteria with priority order

### Sort Order Visualization
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SORT ORDER CONCEPTS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ASCENDING (ASC) - Default                   DESCENDING (DESC)             │
│  ┌─────────────────────┐                    ┌─────────────────────┐         │
│  │ Numbers: 1,2,3,4,5  │                    │ Numbers: 5,4,3,2,1  │         │
│  │ Letters: A,B,C,D,E  │                    │ Letters: E,D,C,B,A  │         │
│  │ Dates: Old→New      │                    │ Dates: New→Old      │         │
│  │ NULL: First         │                    │ NULL: First         │         │
│  └─────────────────────┘                    └─────────────────────┘         │
│                                                                             │
│  Multi-Column Sorting Priority:                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ORDER BY e.LastName, e.FirstName, e.HireDate                                 │
│  │           ▲          ▲          ▲                                      │
│  │        1st Priority 2nd Priority 3rd Priority                         │
│  │                                                                        │
│  │ Result Order:                                                          │
│  │ 1. Sort by e.LastName first                                              │
│  │ 2. Within same e.LastName, sort by e.FirstName                            │
│  │ 3. Within same e.LastName+e.FirstName, sort by e.HireDate                   │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Simple Examples

### Basic Single Column Sorting
```sql
-- Sort employees by last name (ascending - default)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.LastName;

-- Sort employees by e.BaseSalary (descending - highest first)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Sort by hire date (oldest first)
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
ORDER BY e.HireDate ASC;  -- ASC is optional (default)
```

### Multi-Column Sorting
```sql
-- Sort by d.DepartmentName first, then by e.BaseSalary within d.DepartmentName
SELECT 
    e.FirstName,
    e.LastName,
    DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY DepartmentIDName, e.BaseSalary DESC;

-- Sort by multiple criteria with different directions
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    e.BaseSalary
FROM Employees e
ORDER BY 
    e.HireDate ASC,     -- Oldest employees first
    e.BaseSalary DESC;      -- Within same hire date, highest e.BaseSalary first
```

### Sorting by Column Aliases
```sql
-- Sort by calculated columns using aliases
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary * 12 AS AnnualSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
FROM Employees e
ORDER BY 
    YearsOfService DESC,    -- Sort by alias
    AnnualSalary DESC;      -- Then by another alias
```

## Intermediate Examples

### Sorting by Expressions
```sql
-- Sort by calculated expressions
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY 
    LEN(e.FirstName + e.LastName),  -- Sort by total name length
    e.BaseSalary / DATEDIFF(YEAR, e.HireDate, GETDATE()) DESC;  -- e.BaseSalary per year of service
```

### Conditional Sorting with CASE
```sql
-- Custom sort order using CASE expressions
SELECT 
    e.FirstName,
    e.LastName,
    Title,
    e.BaseSalary
FROM Employees e
ORDER BY 
    CASE Title
        WHEN 'CEO' THEN 1
        WHEN 'VP' THEN 2
        WHEN 'Director' THEN 3
        WHEN 'Manager' THEN 4
        ELSE 5
    END,
    e.BaseSalary DESC;

-- Sort with business logic
SELECT 
    e.FirstName,
    e.LastName,
    DepartmentName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY 
    CASE d.DepartmentName
        WHEN 'Executive' THEN 1
        WHEN 'Finance' THEN 2
        WHEN 'IT' THEN 3
        ELSE 4
    END,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN 1  -- High earners first
        WHEN e.BaseSalary >= 70000 THEN 2   -- Medium earners
        ELSE 3                        -- Others
    END,
    e.HireDate;  -- Within same category, by seniority
```

### Sorting with String Functions
```sql
-- Sort by string manipulations
SELECT 
    e.FirstName,
    e.LastName,
    WorkEmail,
    Phone
FROM Employees e
ORDER BY 
    RIGHT(WorkEmail, LEN(WorkEmail) - CHARINDEX('@', WorkEmail)),  -- Sort by email domain
    LEFT(Phone, 3),                                    -- Sort by area code
    e.LastName;

-- Sort by name variations
SELECT 
    e.FirstName,
    e.LastName,
    e.FirstName + ' ' + e.LastName AS FullName
FROM Employees e
ORDER BY 
    CASE 
        WHEN LEN(e.FirstName) <= 4 THEN e.FirstName  -- Short names first
        ELSE e.LastName                            -- Then by last name
    END;
```

## Advanced Examples

### Complex Business Sorting Logic
```sql
-- Advanced employee ranking with multiple business criteria
WITH EmployeeMetrics AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        d.DepartmentName,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        COUNT(ep.ProjectID) AS ActiveProjects,
        AVG(ep.HoursWorked / NULLIF(ep.HoursAllocated, 0)) AS AvgEfficiency,
        COUNT(es.SkillID) AS SkillCount
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
    LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID AND p.IsActive = 'Active'
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.e.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, 
             e.HireDate, d.DepartmentName
)
SELECT 
    e.FirstName,
    e.LastName,
    Title,
    DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    YearsOfService,
    ActiveProjects,
    CAST(ISNULL(AvgEfficiency * 100, 0) AS DECIMAL(5,1)) AS EfficiencyPercent,
    SkillCount
FROM EmployeeMetrics
ORDER BY 
    -- Primary: d.DepartmentName priority
    CASE d.DepartmentName
        WHEN 'Executive' THEN 1
        WHEN 'Finance' THEN 2
        WHEN 'IT' THEN 3
        WHEN 'Sales' THEN 4
        ELSE 5
    END,
    -- Secondary: Role hierarchy
    CASE 
        WHEN Title LIKE '%CEO%' THEN 1
        WHEN Title LIKE '%President%' OR Title LIKE '%VP%' THEN 2
        WHEN Title LIKE '%Director%' THEN 3
        WHEN Title LIKE '%Manager%' THEN 4
        WHEN Title LIKE '%Senior%' THEN 5
        ELSE 6
    END,
    -- Tertiary: Performance score (composite)
    (
        (CASE WHEN AvgEfficiency >= 1.2 THEN 3 WHEN AvgEfficiency >= 1.0 THEN 2 ELSE 1 END) +
        (CASE WHEN ActiveProjects >= 3 THEN 3 WHEN ActiveProjects >= 1 THEN 2 ELSE 1 END) +
        (CASE WHEN SkillCount >= 5 THEN 3 WHEN SkillCount >= 3 THEN 2 ELSE 1 END)
    ) DESC,
    -- Final: Tenure and e.BaseSalary
    YearsOfService DESC,
    e.BaseSalary DESC;
```

### Dynamic Sorting with Parameters
```sql
-- Parameterized sorting for flexible reporting
DECLARE @SortColumn NVARCHAR(50) = 'e.BaseSalary';
DECLARE @SortDirection NVARCHAR(4) = 'DESC';

SELECT 
    e.FirstName,
    e.LastName,
    Title,
    e.BaseSalary,
    e.HireDate,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY 
    CASE 
        WHEN @SortColumn = 'Name' AND @SortDirection = 'ASC' 
             THEN e.LastName
        WHEN @SortColumn = 'Name' AND @SortDirection = 'DESC' 
             THEN e.LastName
    END ASC,
    CASE 
        WHEN @SortColumn = 'Name' AND @SortDirection = 'DESC' 
             THEN e.LastName
    END DESC,
    CASE 
        WHEN @SortColumn = 'e.BaseSalary' AND @SortDirection = 'ASC' 
             THEN e.BaseSalary
    END ASC,
    CASE 
        WHEN @SortColumn = 'e.BaseSalary' AND @SortDirection = 'DESC' 
             THEN e.BaseSalary
    END DESC,
    CASE 
        WHEN @SortColumn = 'e.HireDate' AND @SortDirection = 'ASC' 
             THEN e.HireDate
    END ASC,
    CASE 
        WHEN @SortColumn = 'e.HireDate' AND @SortDirection = 'DESC' 
             THEN e.HireDate
    END DESC;
```

### Sorting with Window Functions
```sql
-- Sort using ranking and analytical functions
SELECT 
    e.FirstName,
    e.LastName,
    DepartmentName,
    e.BaseSalary,
    -- Ranking within d.DepartmentName
    RANK() OVER (PARTITION BY DepartmentIDName ORDER BY e.BaseSalary DESC) AS DeptSalaryRank,
    -- Overall ranking
    DENSE_RANK() OVER (ORDER BY e.BaseSalary DESC) AS OverallSalaryRank,
    -- Percentile ranking
    PERCENT_RANK() OVER (ORDER BY e.BaseSalary) AS SalaryPercentile
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY 
    DeptSalaryRank,           -- d.DepartmentName rank first
    OverallSalaryRank,        -- Then overall rank
    SalaryPercentile DESC;    -- Then percentile
```

## Sorting Performance Optimization

### Index-Optimized Sorting
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SORTING PERFORMANCE GUIDE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  WITHOUT INDEX (Table Scan + Sort)                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  1. Scan entire table                                                  │
│  │     ┌─────────────────┐                                                │
│  │     │ All Rows Read   │ ──┐                                            │
│  │     │ 1,000,000 rows  │   │                                            │
│  │     └─────────────────┘   │                                            │
│  │                           ▼                                            │
│  │  2. Sort in memory/tempdb                                              │
│  │     ┌─────────────────┐                                                │
│  │     │ Sort Operation │                                                 │
│  │     │ High CPU/Memory │                                                │
│  │     │ Possible spill  │                                                │
│  │     └─────────────────┘                                                │
│  │                                                                         │
│  │  Performance: Slow ❌ (O(n log n) + I/O)                               │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  WITH INDEX (Index Scan - Pre-sorted)                                      │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  1. Read from sorted index                                             │
│  │     ┌─────────────────┐                                                │
│  │     │ Index Scan      │ ──┐                                            │
│  │     │ Already Sorted  │   │                                            │
│  │     │ Sequential I/O  │   │                                            │
│  │     └─────────────────┘   │                                            │
│  │                           ▼                                            │
│  │  2. No additional sorting needed                                       │
│  │     ┌─────────────────┐                                                │
│  │     │ Direct Output   │                                                │
│  │     │ No Sort Cost    │                                                │
│  │     │ Minimal CPU     │                                                │
│  │     └─────────────────┘                                                │
│  │                                                                         │
│  │  Performance: Fast ✅ (O(n) I/O only)                                  │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Recommended Indexes for Common Sorts:                                     │
│  • ORDER BY LastName, FirstName: IX_Employees_Name(LastName, FirstName)    │
│  • ORDER BY DepartmentIDID, BaseSalary: IX_Employees_Dept_Sal(DeptID, BaseSalary)    │
│  • ORDER BY HireDate DESC: IX_Employees_HireDate(HireDate DESC)            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Optimizing Sort Operations
```sql
-- Create indexes to support common sorting patterns
CREATE INDEX IX_Employees_LastName_FirstName 
ON Employees (e.LastName, e.FirstName);

CREATE INDEX IX_Employees_Salary_DESC 
ON Employees (e.BaseSalary DESC);

CREATE INDEX IX_Employees_Dept_Salary 
ON Employees (DepartmentID, e.BaseSalary DESC);

-- This query will use the index efficiently
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.LastName, e.FirstName;  -- Uses IX_Employees_LastName_FirstName

-- This query will also be efficient
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE DepartmentID = 1
ORDER BY e.BaseSalary DESC;  -- Uses IX_Employees_Dept_Salary
```

## NULL Handling in Sorting

### NULL Sort Behavior
```sql
-- Understanding NULL sorting behavior
SELECT 
    e.FirstName,
    MiddleName,  -- Some may be NULL
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY MiddleName;  -- NULLs appear first in ascending order

-- Explicit NULL handling
SELECT 
    e.FirstName,
    ISNULL(MiddleName, 'ZZZ_NO_MIDDLE') AS MiddleName,  -- Force NULLs to end
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY ISNULL(MiddleName, 'ZZZ_NO_MIDDLE');

-- NULL handling with CASE
SELECT 
    e.FirstName,
    MiddleName,
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY 
    CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END,  -- NULLs last
    MiddleName;
```

### Custom NULL Ordering
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           NULL SORTING BEHAVIOR                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Default SQL Server Behavior:                                              │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ORDER BY column ASC:   NULL, NULL, 'Alice', 'Bob', 'Charlie'           │
│  │ ORDER BY column DESC:  NULL, NULL, 'Charlie', 'Bob', 'Alice'           │
│  │                        ▲                                               │
│  │                   NULLs always first                                   │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Custom NULL Handling Options:                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │ 1. NULLs Last (Ascending):                                             │
│  │    ORDER BY CASE WHEN column IS NULL THEN 1 ELSE 0 END, column         │
│  │    Result: 'Alice', 'Bob', 'Charlie', NULL, NULL                       │
│  │                                                                         │
│  │ 2. NULLs Last (Descending):                                            │
│  │    ORDER BY CASE WHEN column IS NULL THEN 1 ELSE 0 END, column DESC    │
│  │    Result: 'Charlie', 'Bob', 'Alice', NULL, NULL                       │
│  │                                                                         │
│  │ 3. Replace NULLs for Sorting:                                          │
│  │    ORDER BY ISNULL(column, 'ZZZZZ')                                    │
│  │    Result: 'Alice', 'Bob', 'Charlie', NULL→'ZZZZZ'                     │
│  │                                                                         │
│  │ 4. COALESCE for Multiple Options:                                      │
│  │    ORDER BY COALESCE(PrimaryName, SecondaryName, 'Unknown')            │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Common Sorting Patterns

### Business Reporting Sorts
```sql
-- Executive summary sorting
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary,
    MAX(e.BaseSalary) AS MaxSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY DepartmentIDName
ORDER BY 
    EmployeeCount DESC,  -- Largest departments first
    AvgSalary DESC;      -- Highest paying departments first

-- Alphabetical with special handling
SELECT 
    CASE 
        WHEN LEFT(e.LastName, 2) IN ('Mc', 'Mac') 
        THEN 'Mac' + SUBSTRING(e.LastName, 3, LEN(e.LastName))
        WHEN LEFT(e.LastName, 2) = 'O''' 
        THEN 'O' + SUBSTRING(e.LastName, 3, LEN(e.LastName))
        ELSE e.LastName
    END AS SortableName,
    e.FirstName,
    e.LastName,
    WorkEmail
FROM Employees e
ORDER BY SortableName, e.FirstName;
```

### Date and Time Sorting
```sql
-- Complex date sorting
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    DATENAME(MONTH, e.HireDate) AS HireMonth,
    YEAR(e.HireDate) AS HireYear
FROM Employees e
ORDER BY 
    YEAR(e.HireDate) DESC,           -- Recent years first
    MONTH(e.HireDate),               -- Then by month order
    DAY(e.HireDate),                 -- Then by day
    e.LastName;                      -- Finally by name

-- Business calendar sorting
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    CASE DATEPART(QUARTER, e.HireDate)
        WHEN 1 THEN 'Q1'
        WHEN 2 THEN 'Q2' 
        WHEN 3 THEN 'Q3'
        WHEN 4 THEN 'Q4'
    END AS HireQuarter
FROM Employees e
ORDER BY 
    YEAR(e.HireDate) DESC,
    DATEPART(QUARTER, e.HireDate),
    MONTH(e.HireDate),
    e.LastName;
```

## Best Practices for Sorting

### Performance Best Practices
```sql
-- Good: Use indexed columns for sorting
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.LastName, e.FirstName;  -- If index exists on (e.LastName, e.FirstName)

-- Good: Limit result set before sorting
SELECT TOP 100 e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE DepartmentID = 1
ORDER BY e.BaseSalary DESC;

-- Avoid: Sorting by functions without corresponding index
-- SELECT e.FirstName, e.LastName, e.BaseSalary
-- FROM Employees e  
-- ORDER BY UPPER(e.LastName);  -- Forces table scan + sort

-- Better: Use computed column with index or handle in application
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.LastName COLLATE SQL_Latin1_General_CP1_CI_AS;
```

### Maintainability Best Practices
```sql
-- Good: Use meaningful column aliases
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary * 12 AS AnnualSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
FROM Employees e
ORDER BY AnnualSalary DESC, YearsOfService DESC;

-- Good: Comment complex sorting logic
SELECT 
    e.FirstName,
    e.LastName,
    Title,
    e.BaseSalary
FROM Employees e
ORDER BY 
    -- Executive hierarchy first
    CASE 
        WHEN Title LIKE '%CEO%' THEN 1
        WHEN Title LIKE '%President%' THEN 2
        WHEN Title LIKE '%VP%' THEN 3
        ELSE 4
    END,
    -- Within same level, by tenure
    e.HireDate,
    -- Finally by compensation
    e.BaseSalary DESC;
```

## Common Mistakes and Solutions

### Mistake 1: Sorting Without WHERE
```sql
-- Problem: Sorting entire table unnecessarily
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;  -- Sorts all employees

-- Solution: Filter first, then sort
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE IsActive = 1 AND DepartmentID IN (1, 2, 3)
ORDER BY e.BaseSalary DESC;  -- Sorts smaller result set
```

### Mistake 2: Over-Sorting
```sql
-- Problem: Unnecessary complex sorting
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY 
    e.FirstName,
    e.LastName,
    MiddleName,
    e.BaseSalary,
    e.HireDate,
    e.EmployeeID;  -- Too many sort criteria

-- Solution: Sort by business-relevant criteria only
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.LastName, e.FirstName;  -- Sufficient for most cases
```

### Mistake 3: Inconsistent Sorting
```sql
-- Problem: Mixing data types in sort expressions
SELECT e.FirstName, e.LastName, 
       CAST(e.EmployeeID AS VARCHAR) AS EmpID
FROM Employees e
ORDER BY EmpID;  -- String sort: '10' comes before '2'

-- Solution: Use appropriate data types
SELECT e.FirstName, e.LastName, e.EmployeeID
FROM Employees e
ORDER BY e.EmployeeID;  -- Numeric sort: 2 comes before 10
```

## Summary

Effective data sorting requires understanding:

1. **ORDER BY Syntax**: Column names, aliases, expressions, and directions
2. **Multi-Column Sorting**: Priority order and mixed directions
3. **Performance Impact**: Index usage and sort operations
4. **NULL Handling**: Default behavior and custom ordering
5. **Business Logic**: CASE expressions for custom sort orders
6. **Best Practices**: Filtering before sorting, appropriate indexing

**Key Takeaways:**
- Always consider performance impact of sorting operations
- Use indexes to support common sorting patterns
- Handle NULL values explicitly when needed
- Filter data before sorting to reduce operation cost
- Use meaningful sort criteria that serve business purposes
- Test sorting with realistic data volumes

Mastering data sorting enables you to present query results in meaningful, user-friendly formats while maintaining optimal performance.
