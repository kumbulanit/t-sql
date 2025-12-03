# Module 5: Sorting and Filtering Data - Theory Presentation

## Slide 1: Module Overview
**Sorting and Filtering Data**

- Advanced data sorting with ORDER BY clause
- Complex filtering techniques with WHERE predicates
- Limiting result sets with TOP and OFFSET-FETCH
- Working with NULL values and unknown data
- Performance optimization for filtering and sorting

---

## Slide 2: ORDER BY Fundamentals
**Data Sorting Concepts**

- **Sorting**: Arranging data in specific sequence
- **ASC**: Ascending order (default)
- **DESC**: Descending order
- **Multiple Columns**: Secondary sort criteria
- **NULL Handling**: NULLs first or last depending on sort direction

```sql
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC, e.LastName ASC;
```

---

## Slide 3: ORDER BY Syntax and Options
**Sorting Techniques**

```sql
-- Basic sorting
ORDER BY e.LastName

-- Multiple columns with different directions
ORDER BY d.DepartmentID ASC, e.BaseSalary DESC, e.HireDate ASC

-- Sort by column position (not recommended)
ORDER BY 2, 3

-- Sort by expression
ORDER BY LEN(e.FirstName) DESC

-- Sort by alias
SELECT e.FirstName + ' ' + e.LastName AS FullName
FROM Employees e
ORDER BY FullName
```

---

## Slide 4: NULL Values in Sorting
**NULL Behavior**

```sql
-- Default NULL behavior
SELECT e.FirstName, MiddleName, e.LastName
FROM Employees e
ORDER BY MiddleName;  -- NULLs appear first in ASC

-- Explicit NULL handling
SELECT e.FirstName, MiddleName, e.LastName
FROM Employees e
ORDER BY 
    CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END,
    MiddleName;
```

**Key Point**: NULL sorting behavior is implementation-specific

---

## Slide 5: WHERE Clause Fundamentals
**Data Filtering Concepts**

- **Predicate**: Expression evaluating to TRUE, FALSE, or UNKNOWN
- **Three-Valued Logic**: TRUE, FALSE, NULL (UNKNOWN)
- **Filter Early**: WHERE applied before GROUP BY
- **Performance**: Indexed columns filter faster

```sql
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Engineering' 
    AND e.BaseSalary > 50000 
    AND IsActive = 1;
```

---

## Slide 6: Comparison Operators
**Basic Filtering Operators**

```sql
-- Equality and inequality
WHERE e.BaseSalary = 50000
WHERE d.DepartmentName <> 'Engineering'
WHERE e.HireDate != '2020-01-01'

-- Relational operators
WHERE e.BaseSalary > 50000
WHERE e.BaseSalary >= 50000
WHERE e.HireDate < '2020-01-01'
WHERE e.HireDate <= GETDATE()

-- Combining conditions
WHERE e.BaseSalary BETWEEN 40000 AND 80000
WHERE d.DepartmentName IN ('IT', 'HR', 'Finance')
```

---

## Slide 7: Pattern Matching with LIKE
**String Pattern Filtering**

```sql
-- Wildcard patterns
WHERE e.LastName LIKE 'Sm%'        -- Starts with 'Sm'
WHERE e.LastName LIKE '%son'       -- Ends with 'son'
WHERE e.LastName LIKE '%mit%'      -- Contains 'mit'
WHERE e.FirstName LIKE 'J_n'       -- 'J', any char, 'n'

-- Escape characters
WHERE ProductName LIKE '50\% Off' ESCAPE '\'

-- Case sensitivity (depends on collation)
WHERE e.LastName LIKE 'smith'      -- May match 'Smith'
```

**Wildcards**: % (zero or more), _ (exactly one character)

---

## Slide 8: Range and Set Operations
**Advanced Filtering**

```sql
-- BETWEEN (inclusive range)
WHERE e.BaseSalary BETWEEN 40000 AND 60000
WHERE e.HireDate BETWEEN '2020-01-01' AND '2020-12-31'

-- IN (set membership)
WHERE d.DepartmentName IN ('IT', 'HR', 'Finance')
WHERE e.EmployeeID IN (SELECT ManagerID FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID)

-- NOT versions
WHERE e.BaseSalary NOT BETWEEN 40000 AND 60000
WHERE d.DepartmentName NOT IN ('IT', 'HR')
```

---

## Slide 9: NULL Value Handling
**Working with Unknown Data**

```sql
-- Testing for NULL
WHERE MiddleName IS NULL
WHERE MiddleName IS NOT NULL

-- Common mistake (always returns no rows)
WHERE MiddleName = NULL     -- WRONG
WHERE MiddleName <> NULL    -- WRONG

-- NULL in calculations
WHERE e.BaseSalary + Bonus > 50000  -- NULL if Bonus is NULL

-- Handling NULLs
WHERE ISNULL(Bonus, 0) + e.BaseSalary > 50000
WHERE COALESCE(Bonus, 0) + e.BaseSalary > 50000
```

---

## Slide 10: Logical Operators
**Combining Conditions**

```sql
-- AND (both conditions must be TRUE)
WHERE d.DepartmentName = 'Engineering' AND e.BaseSalary > 50000

-- OR (either condition can be TRUE)
WHERE d.DepartmentName = 'Engineering' OR d.DepartmentName = 'HR'

-- NOT (negates condition)
WHERE NOT (d.DepartmentName = 'Engineering')
WHERE NOT d.DepartmentName IN ('IT', 'HR')

-- Precedence (use parentheses for clarity)
WHERE (Department = 'IT' OR d.DepartmentName = 'HR') 
    AND e.BaseSalary > 50000
```

---

## Slide 11: TOP Clause
**Limiting Result Sets**

```sql
-- Fixed number of rows
SELECT TOP 10 e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Percentage of rows
SELECT TOP 25 PERCENT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.HireDate DESC;

-- WITH TIES (include ties)
SELECT TOP 5 WITH TIES e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;
```

**Important**: TOP without ORDER BY returns arbitrary rows

---

## Slide 12: OFFSET-FETCH (SQL Server 2012+)
**Standard Row Limiting**

```sql
-- Skip first 10 rows, get next 5
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY;

-- Pagination example (page 3, 10 rows per page)
DECLARE @PageSize INT = 10;
DECLARE @PageNumber INT = 3;

SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
ORDER BY e.EmployeeID
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

---

## Slide 13: Complex Filtering Scenarios
**Advanced WHERE Techniques**

```sql
-- Date range filtering
WHERE e.HireDate >= DATEADD(YEAR, -2, GETDATE())
WHERE YEAR(e.HireDate) = 2020
WHERE e.HireDate >= '2020-01-01' AND e.HireDate < '2021-01-01'

-- String manipulation
WHERE LEN(e.FirstName) > 5
WHERE UPPER(e.LastName) = 'SMITH'
WHERE CHARINDEX('@company.com', WorkEmail) > 0

-- Mathematical conditions
WHERE e.BaseSalary % 1000 = 0  -- e.BaseSalary is multiple of 1000
WHERE ABS(e.BaseSalary - 50000) < 5000  -- Within $5K of $50K
```

---

## Slide 14: Subqueries in WHERE
**Dynamic Filtering**

```sql
-- Scalar subquery
WHERE e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e)

-- EXISTS subquery
WHERE EXISTS (
    SELECT 1 FROM EmployeeProjects ep 
    WHERE ep.EmployeeID = Employees.EmployeeID
)

-- IN subquery
WHERE d.DepartmentID IN (
    SELECT d.DepartmentID FROM Departments d 
    WHERE Location = 'New York'
)

-- Correlated subquery
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary) FROM Employees e e2 
    WHERE e2.d.DepartmentID = Employees.d.DepartmentID
)
```

---

## Slide 15: CASE Expressions in WHERE
**Conditional Filtering**

```sql
-- Dynamic filtering based on parameter
DECLARE @FilterType NVARCHAR(20) = 'HighSalary';

SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE 
    CASE @FilterType
        WHEN 'HighSalary' THEN 
            CASE WHEN e.BaseSalary > 75000 THEN 1 ELSE 0 END
        WHEN 'RecentHire' THEN 
            CASE WHEN e.HireDate > DATEADD(YEAR, -1, GETDATE()) THEN 1 ELSE 0 END
        ELSE 1
    END = 1;
```

---

## Slide 16: Performance Considerations
**Optimizing Filters and Sorts**

**Indexing Strategy**:
- Index WHERE clause columns
- Composite indexes for multiple WHERE columns
- Include ORDER BY columns in indexes

**Best Practices**:
- Filter early with WHERE clause
- Use SARGable predicates (Search ARGument able)
- Avoid functions on indexed columns in WHERE
- Consider covering indexes for SELECT columns

```sql
-- SARGable (good)
WHERE e.HireDate >= '2020-01-01'

-- Non-SARGable (poor performance)
WHERE YEAR(e.HireDate) = 2020
```

---

## Slide 17: Common Performance Pitfalls
**What to Avoid**

```sql
-- Function on indexed column (non-SARGable)
WHERE UPPER(e.LastName) = 'SMITH'
-- Better: WHERE e.LastName = 'smith' (with appropriate collation)

-- Leading wildcards prevent index usage
WHERE e.LastName LIKE '%smith'
-- Better: WHERE e.LastName LIKE 'smith%'

-- OR conditions may prevent index usage
WHERE e.FirstName = 'John' OR e.LastName = 'Smith'
-- Consider: UNION of separate queries

-- Unnecessary data type conversions
WHERE e.EmployeeID = '123'  -- e.EmployeeID is INT
-- Better: WHERE e.EmployeeID = 123
```

---

## Slide 18: Filtering with JOINs
**Combined Operations**

```sql
-- Filtering before JOIN (usually better)
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM (
    SELECT * FROM Employees e 
    WHERE IsActive = 1 AND e.BaseSalary > 50000
) e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Filtering after JOIN
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND e.BaseSalary > 50000;
```

---

## Slide 19: Window Functions with ORDER BY
**Advanced Sorting Applications**

```sql
-- Row numbering with custom sort
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS SalaryRank,
    RANK() OVER (ORDER BY e.BaseSalary DESC) AS SalaryRankWithTies
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

-- Partition and sort
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary,
    ROW_NUMBER() OVER (
        PARTITION BY DepartmentID 
        ORDER BY e.BaseSalary DESC
    ) AS DeptSalaryRank
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
```

---

## Slide 20: Handling Large Result Sets
**Scalability Considerations**

```sql
-- Efficient pagination
WITH EmployeePage AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        ROW_NUMBER() OVER (ORDER BY e.EmployeeID) AS RowNum
    FROM Employees e
    WHERE IsActive = 1
)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM EmployeePage
WHERE RowNum BETWEEN 21 AND 30;  -- Page 3, 10 rows per page
```

---

## Slide 21: Date and Time Filtering
**Temporal Data Handling**

```sql
-- Today's records
WHERE CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)
-- Better: WHERE CreatedDate >= CAST(GETDATE() AS DATE) 
--         AND CreatedDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))

-- This month's records
WHERE YEAR(e.HireDate) = YEAR(GETDATE()) 
    AND MONTH(e.HireDate) = MONTH(GETDATE())

-- Last 30 days
WHERE e.HireDate >= DATEADD(DAY, -30, GETDATE())

-- Business hours
WHERE DATEPART(HOUR, LoginTime) BETWEEN 9 AND 17
```

---

## Slide 22: Text Search Optimization
**Efficient String Filtering**

```sql
-- Full-text search (if available)
WHERE CONTAINS(Description, 'database OR query')
WHERE FREETEXT(Description, 'database management system')

-- Regular LIKE optimization
WHERE e.LastName >= 'S' AND e.LastName < 'T'  -- Range scan
-- Instead of: WHERE e.LastName LIKE 'S%'

-- Case-insensitive search with collation
WHERE e.LastName COLLATE SQL_Latin1_General_CP1_CI_AS = 'smith'
```

---

## Slide 23: Dynamic Filtering
**Flexible Query Conditions**

```sql
-- Optional parameters
DECLARE @Department NVARCHAR(50) = NULL;
DECLARE @MinSalary MONEY = NULL;

SELECT e.FirstName, e.LastName, d.DepartmentName, e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (@Department IS NULL OR d.DepartmentName = @Department)
    AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary)
    AND IsActive = 1;

-- Note: This pattern may not optimize well
-- Consider dynamic SQL for complex scenarios
```

---

## Slide 24: Learning Objectives Achieved
**Module 5 Outcomes**

✅ Master ORDER BY for effective data sorting
✅ Apply complex WHERE clause filtering techniques
✅ Use TOP and OFFSET-FETCH for result set control
✅ Handle NULL values correctly in filters and sorts
✅ Optimize filtering and sorting for performance
✅ Implement advanced filtering patterns and scenarios

---

## Slide 25: Next Steps
**Module 6 Preview: Working with SQL Server 2016 Data Types**

- Understanding SQL Server data type system
- Working with character and Unicode data
- Date and time data types and functions
- Numeric precision and scale considerations
- Data type conversion and best practices

**Key Preparation**
- Practice complex WHERE clause scenarios
- Understand indexing impact on performance
- Review execution plan basics for optimization