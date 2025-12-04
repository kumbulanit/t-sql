# Lesson 3: Filtering Data with TOP and OFFSET-FETCH

## Overview
TOP and OFFSET-FETCH are T-SQL features that allow you to limit the number of rows returned by a query and implement pagination. These features are essential for performance optimization, user interface design, and managing large result sets. This lesson covers both traditional TOP clause usage and the newer OFFSET-FETCH standard.

## TOP Clause Fundamentals

### Basic TOP Syntax
```sql
-- Basic TOP syntax
SELECT TOP (n) columns
FROM table
WHERE conditions
ORDER BY columns;

-- TOP with percentage
SELECT TOP (n) PERCENT columns
FROM table
WHERE conditions
ORDER BY columns;
```

### TOP Behavior Visualization
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            TOP CLAUSE BEHAVIOR                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Original Result Set (1000 rows):                                          │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Row 1    │ Smith, John     │ $95,000  │                                │
│  │ Row 2    │ Johnson, Sarah  │ $92,000  │                                │
│  │ Row 3    │ Brown, Mike     │ $88,000  │                                │
│  │ Row 4    │ Davis, Lisa     │ $85,000  │                                │
│  │ Row 5    │ Wilson, Tom     │ $82,000  │                                │
│  │ ...      │ ...             │ ...      │                                │
│  │ Row 1000 │ Anderson, Pat   │ $35,000  │                                │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  TOP 3 Result:                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Row 1    │ Smith, John     │ $95,000  │ ←── First 3 rows only          │
│  │ Row 2    │ Johnson, Sarah  │ $92,000  │                                │
│  │ Row 3    │ Brown, Mike     │ $88,000  │                                │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  TOP 5 PERCENT Result (5% of 1000 = 50 rows):                             │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Row 1    │ Smith, John     │ $95,000  │ ←── Top 50 rows (5%)           │
│  │ Row 2    │ Johnson, Sarah  │ $92,000  │                                │
│  │ ...      │ ...             │ ...      │                                │
│  │ Row 50   │ Miller, Alex    │ $68,000  │                                │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Important: TOP requires ORDER BY for consistent results!                  │
│  Without ORDER BY, results are unpredictable and may vary between runs.    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Simple TOP Examples

### TOP with Numbers
```sql
-- Get top 5 highest paid employees
SELECT TOP (5) 
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Get top 10 most recent orders
SELECT TOP (10)
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount
FROM Orders
ORDER BY OrderDate DESC;
```

### TOP with Percentage
```sql
-- Get top 10% of employees by e.BaseSalary
SELECT TOP (10) PERCENT
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Get top 5% of orders by value
SELECT TOP (5) PERCENT
    OrderID,
    CustomerID,
    TotalAmount
FROM Orders
ORDER BY TotalAmount DESC;
```

### TOP with Variables
```sql
-- Dynamic TOP using variables
DECLARE @TopCount INT = 10;
DECLARE @TopPercent FLOAT = 15.5;

-- Using variable for count
SELECT TOP (@TopCount)
    ProductName,
    e.BaseSalary
FROM Products
ORDER BY e.BaseSalary DESC;

-- Using variable for percentage
SELECT TOP (@TopPercent) PERCENT
    CompanyName,
    TotalOrders
FROM CustomerSummary
ORDER BY TotalOrders DESC;
```

## OFFSET-FETCH Clause

### OFFSET-FETCH Syntax
```sql
-- Standard OFFSET-FETCH syntax (SQL Server 2012+)
SELECT columns
FROM table
WHERE conditions
ORDER BY columns
OFFSET n ROWS
FETCH NEXT m ROWS ONLY;

-- Alternative FETCH syntax
SELECT columns
FROM table
WHERE conditions
ORDER BY columns
OFFSET n ROWS
FETCH FIRST m ROWS ONLY;
```

### OFFSET-FETCH vs TOP Comparison
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        OFFSET-FETCH vs TOP Comparison                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Original Data (Ordered by e.BaseSalary DESC):                                   │
│  ┌─────┬─────────────────┬─────────┐                                        │
│  │ Row │      Name       │ e.BaseSalary  │                                        │
│  ├─────┼─────────────────┼─────────┤                                        │
│  │  1  │ Smith, John     │ $95,000 │                                        │
│  │  2  │ Johnson, Sarah  │ $92,000 │                                        │
│  │  3  │ Brown, Mike     │ $88,000 │                                        │
│  │  4  │ Davis, Lisa     │ $85,000 │                                        │
│  │  5  │ Wilson, Tom     │ $82,000 │                                        │
│  │  6  │ Miller, Alex    │ $78,000 │                                        │
│  │  7  │ Garcia, Maria   │ $75,000 │                                        │
│  │  8  │ Taylor, James   │ $72,000 │                                        │
│  │  9  │ Anderson, Pat   │ $68,000 │                                        │
│  │ 10  │ Thomas, Chris   │ $65,000 │                                        │
│  └─────┴─────────────────┴─────────┘                                        │
│                                                                             │
│  TOP 3:                              OFFSET 3 FETCH NEXT 3:                │
│  ┌─────┬─────────────────┬─────────┐ ┌─────┬─────────────────┬─────────┐    │
│  │ Row │      Name       │ e.BaseSalary  │ │ Row │      Name       │ e.BaseSalary  │    │
│  ├─────┼─────────────────┼─────────┤ ├─────┼─────────────────┼─────────┤    │
│  │  1  │ Smith, John     │ $95,000 │ │  4  │ Davis, Lisa     │ $85,000 │    │
│  │  2  │ Johnson, Sarah  │ $92,000 │ │  5  │ Wilson, Tom     │ $82,000 │    │
│  │  3  │ Brown, Mike     │ $88,000 │ │  6  │ Miller, Alex    │ $78,000 │    │
│  └─────┴─────────────────┴─────────┘ └─────┴─────────────────┴─────────┘    │
│                                                                             │
│  • TOP: Gets first N rows            • OFFSET-FETCH: Skips N, gets next M  │
│  • Cannot skip rows                  • Perfect for pagination              │
│  • Simple for "top N" scenarios      • More flexible for navigation        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Pagination Visualization
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PAGINATION WITH OFFSET-FETCH                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Total Records: 100    Page Size: 10                                       │
│                                                                             │
│  Page 1 (Records 1-10):     OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY         │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 10 │                             │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Page 2 (Records 11-20):    OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY        │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 11│ 12│ 13│ 14│ 15│ 16│ 17│ 18│ 19│ 20 │                             │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Page 3 (Records 21-30):    OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY        │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 21│ 22│ 23│ 24│ 25│ 26│ 27│ 28│ 29│ 30 │                             │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Formula for Page N:                                                       │
│  OFFSET ((PageNumber - 1) * PageSize) ROWS                                 │
│  FETCH NEXT PageSize ROWS ONLY                                             │
│                                                                             │
│  Example for Page 5 with 10 records per page:                             │
│  OFFSET ((5 - 1) * 10) ROWS = OFFSET 40 ROWS                              │
│  FETCH NEXT 10 ROWS ONLY                                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Intermediate OFFSET-FETCH Examples

### Basic Pagination Implementation
```sql
-- Page 1 (first 10 records)
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
ORDER BY e.LastName, e.FirstName
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

-- Page 2 (records 11-20)
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
ORDER BY e.LastName, e.FirstName
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- Page 3 (records 21-30)
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
ORDER BY e.LastName, e.FirstName
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
```

### Dynamic Pagination with Parameters
```sql
-- Parameterized pagination function
DECLARE @PageNumber INT = 3;        -- Page to retrieve (1-based)
DECLARE @PageSize INT = 15;         -- Records per page
DECLARE @SortColumn NVARCHAR(50) = 'e.BaseSalary';
DECLARE @SortDirection NVARCHAR(4) = 'DESC';

-- Calculate offset
DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

-- Dynamic pagination query
SELECT 
    e.FirstName,
    e.LastName,
    Title,
    e.BaseSalary,
    e.HireDate,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY 
    CASE WHEN @SortColumn = 'e.BaseSalary' AND @SortDirection = 'ASC' THEN e.BaseSalary END ASC,
    CASE WHEN @SortColumn = 'e.BaseSalary' AND @SortDirection = 'DESC' THEN e.BaseSalary END DESC,
    CASE WHEN @SortColumn = 'Name' AND @SortDirection = 'ASC' THEN e.LastName END ASC,
    CASE WHEN @SortColumn = 'Name' AND @SortDirection = 'DESC' THEN e.LastName END DESC,
    CASE WHEN @SortColumn = 'e.HireDate' AND @SortDirection = 'ASC' THEN e.HireDate END ASC,
    CASE WHEN @SortColumn = 'e.HireDate' AND @SortDirection = 'DESC' THEN e.HireDate END DESC
OFFSET @Offset ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

### OFFSET-FETCH with Complex Sorting
```sql
-- Complex multi-column sorting with pagination
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary,
    d.DepartmentName,
    COUNT(ep.ProjectID) AS ActiveProjects
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID AND p.IsActive = 'Active'
WHERE e.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, d.DepartmentName
ORDER BY 
    ActiveProjects DESC,      -- Most active employees first
    e.BaseSalary DESC,              -- Then by e.BaseSalary
    e.LastName,                 -- Then alphabetically
    e.FirstName
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
```

## Advanced Examples

### Pagination with Total Count
```sql
-- Get page data with total count for pagination controls
WITH EmployeeData AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        d.DepartmentName,
        COUNT(*) OVER() AS TotalRecords
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
),
PagedResults AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNum
    FROM EmployeeData
)
SELECT 
    e.FirstName,
    e.LastName,
    Title,
    e.BaseSalary,
    d.DepartmentName,
    TotalRecords,
    CEILING(CAST(TotalRecords AS FLOAT) / 10) AS TotalPages,
    CEILING(CAST(RowNum AS FLOAT) / 10) AS CurrentPage
FROM PagedResults
WHERE RowNum BETWEEN 21 AND 30  -- Page 3 with page size 10
ORDER BY RowNum;
```

### Performance-Optimized Pagination
```sql
-- Cursor-based pagination for better performance on large datasets
-- Instead of OFFSET which scans all previous rows

-- Method 1: Using ROW_NUMBER with filtering
WITH RankedEmployees AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        e.HireDate,
        ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC, e.EmployeeID) AS RowNum
    FROM Employees e
    WHERE IsActive = 1
)
SELECT e.FirstName, e.LastName, e.BaseSalary, e.HireDate
FROM RankedEmployees
WHERE RowNum BETWEEN 101 AND 110;  -- Much faster than OFFSET 100

-- Method 2: Cursor-based with last seen values
-- For next page after seeing e.EmployeeID = 1234
SELECT TOP (10)
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.EmployeeID
FROM Employees e
WHERE IsActive = 1
  AND (e.BaseSalary < @LastSalary 
       OR (e.BaseSalary = @LastSalary AND e.EmployeeID > @LastEmployeeID))
ORDER BY e.BaseSalary DESC, e.EmployeeID;
```

### TOP with Complex Business Logic
```sql
-- Top performers analysis with business rules
WITH EmployeePerformance AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        d.DepartmentName,
        COUNT(ep.ProjectID) AS ProjectCount,
        AVG(ep.HoursWorked / NULLIF(ep.HoursAllocated, 0)) AS AvgEfficiency,
        COUNT(es.SkillID) AS SkillCount,
        -- Performance score calculation
        (
            (CASE WHEN COUNT(ep.ProjectID) >= 3 THEN 30 ELSE COUNT(ep.ProjectID) * 10 END) +
            (CASE WHEN AVG(ep.HoursWorked / NULLIF(ep.HoursAllocated, 0)) >= 1.2 THEN 25
                  WHEN AVG(ep.HoursWorked / NULLIF(ep.HoursAllocated, 0)) >= 1.0 THEN 15
                  ELSE 5 END) +
            (CASE WHEN COUNT(es.SkillID) >= 5 THEN 20 ELSE COUNT(es.SkillID) * 4 END) +
            (CASE WHEN e.BaseSalary >= 80000 THEN 15 
                  WHEN e.BaseSalary >= 60000 THEN 10 
                  ELSE 5 END)
        ) AS PerformanceScore
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, d.DepartmentName
)
-- Top 10 performers overall
SELECT TOP (10)
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    Title,
    d.DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    ProjectCount,
    CAST(AvgEfficiency * 100 AS DECIMAL(5,1)) AS EfficiencyPercent,
    SkillCount,
    PerformanceScore
FROM EmployeePerformance
ORDER BY PerformanceScore DESC, e.BaseSalary DESC;
```

## Pagination Patterns and Best Practices

### Efficient Pagination Strategies
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PAGINATION PERFORMANCE GUIDE                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  OFFSET Performance Problem:                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  Page 1:    OFFSET 0 ROWS       → Scans 0 + 10 = 10 rows              │
│  │  Page 10:   OFFSET 90 ROWS      → Scans 90 + 10 = 100 rows             │
│  │  Page 100:  OFFSET 990 ROWS     → Scans 990 + 10 = 1,000 rows          │
│  │  Page 1000: OFFSET 9990 ROWS    → Scans 9,990 + 10 = 10,000 rows       │
│  │                                                                         │
│  │  Problem: Later pages require scanning all previous rows!              │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Alternative Solutions:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  1. ROW_NUMBER() with BETWEEN (better for jumping to specific pages):  │
│  │     WHERE RowNum BETWEEN 9991 AND 10000                                │
│  │                                                                         │
│  │  2. Cursor-based pagination (best for sequential browsing):            │
│  │     WHERE ID > @LastSeenID ORDER BY ID LIMIT 10                        │
│  │                                                                         │
│  │  3. Seek-based pagination (best performance):                          │
│  │     WHERE (SortColumn, ID) > (@LastSortValue, @LastID)                 │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Index Requirements:                                                        │
│  • ORDER BY columns should be indexed                                      │
│  • Consider covering indexes for better performance                        │
│  • Unique columns in ORDER BY for consistent pagination                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Pagination with Search and Filtering
```sql
-- Complete pagination solution with search
DECLARE @SearchTerm NVARCHAR(100) = 'Manager';
DECLARE @DepartmentFilter INT = NULL;
DECLARE @MinSalary DECIMAL(10,2) = 50000;
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 15;

WITH FilteredEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND (@SearchTerm IS NULL 
           OR e.FirstName LIKE '%' + @SearchTerm + '%'
           OR e.LastName LIKE '%' + @SearchTerm + '%'
           OR e.JobTitle LIKE '%' + @SearchTerm + '%')
      AND (@DepartmentFilter IS NULL OR d.DepartmentID = @DepartmentFilter)
      AND e.BaseSalary >= @MinSalary
),
PaginatedResults AS (
    SELECT *,
           COUNT(*) OVER() AS TotalRecords,
           ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNum
    FROM FilteredEmployees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    Title,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    e.HireDate,
    d.DepartmentName,
    TotalRecords,
    CEILING(CAST(TotalRecords AS FLOAT) / @PageSize) AS TotalPages,
    @PageNumber AS CurrentPage
FROM PaginatedResults
WHERE RowNum BETWEEN ((@PageNumber - 1) * @PageSize + 1) 
                 AND (@PageNumber * @PageSize)
ORDER BY RowNum;
```

## Common Use Cases

### Top N Analysis
```sql
-- Top 5 departments by average e.BaseSalary
SELECT TOP (5)
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    FORMAT(AVG(e.BaseSalary), 'C0') AS AvgSalary,
    FORMAT(MAX(e.BaseSalary), 'C0') AS MaxSalary
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentName
ORDER BY AVG(e.BaseSalary) DESC;

-- Bottom 10% performers need development
SELECT TOP (10) PERCENT
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    Title,
    e.BaseSalary,
    'Requires development plan' AS ActionRequired
FROM Employees e
WHERE IsActive = 1
ORDER BY e.BaseSalary ASC, e.HireDate DESC;
```

### Data Sampling
```sql
-- Random sampling using TOP with NEWID()
SELECT TOP (100)
    e.FirstName,
    e.LastName,
    DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY NEWID();  -- Random order for sampling

-- Systematic sampling every nth record
WITH RankedEmployees AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY e.EmployeeID) AS RowNum
    FROM Employees e
    WHERE IsActive = 1
)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM RankedEmployees
WHERE RowNum % 10 = 1;  -- Every 10th record
```

## Best Practices

### Performance Optimization
```sql
-- Good: Use specific ORDER BY for consistent results
SELECT TOP (10) e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC, e.EmployeeID;  -- Include unique column for ties

-- Good: Index supporting ORDER BY
CREATE INDEX IX_Employees_Salary_ID ON Employees (e.BaseSalary DESC, e.EmployeeID);

-- Good: Filter before TOP/OFFSET-FETCH
SELECT TOP (50) e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE IsActive = 1 AND DepartmentID IN (1, 2, 3)
ORDER BY e.BaseSalary DESC;
```

### Consistent Pagination
```sql
-- Always include a unique column in ORDER BY for deterministic results
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC, e.EmployeeID  -- e.EmployeeID ensures deterministic ordering
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;

-- Handle ties appropriately
SELECT TOP (10) WITH TIES
    e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;  -- Includes all employees tied at 10th place e.BaseSalary
```

## Summary

TOP and OFFSET-FETCH are essential for:

1. **Result Limiting**: Control query result size for performance
2. **Pagination**: Implement user-friendly data browsing
3. **Sampling**: Extract representative data subsets
4. **Top-N Analysis**: Identify highest/lowest performers
5. **Performance**: Reduce network traffic and memory usage

**Key Takeaways:**
- Always use ORDER BY with TOP/OFFSET-FETCH for predictable results
- OFFSET-FETCH is standard SQL and more flexible than TOP
- Consider performance implications for large offsets
- Include unique columns in ORDER BY for consistent pagination
- Use appropriate indexing to support sorting requirements
- Consider alternative pagination strategies for very large datasets

Mastering these techniques enables efficient data presentation and optimal user experience in data-driven applications.
