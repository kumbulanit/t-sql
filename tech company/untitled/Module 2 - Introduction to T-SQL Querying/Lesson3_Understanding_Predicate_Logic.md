# Lesson 3: Understanding Predicate Logic

## Overview
Predicate logic is fundamental to T-SQL and relational databases. A predicate is an expression that evaluates to TRUE, FALSE, or UNKNOWN (NULL). Understanding predicate logic is essential for writing effective WHERE clauses, JOIN conditions, and CASE expressions in T-SQL.

## What is Predicate Logic?

Predicate logic in T-SQL deals with expressions that can be evaluated as true or false (or unknown due to NULLs). These logical expressions form the foundation of data filtering, joining, and conditional operations.

### Three-Valued Logic
Unlike binary logic (TRUE/FALSE), SQL uses three-valued logic:
- **TRUE**: Condition is satisfied
- **FALSE**: Condition is not satisfied  
- **UNKNOWN**: Condition involves NULL values

### Truth Tables for Three-Valued Logic

#### AND Truth Table
```
    AND   │ TRUE  │ FALSE │ UNKNOWN
    ──────┼───────┼───────┼─────────
    TRUE  │ TRUE  │ FALSE │ UNKNOWN
    FALSE │ FALSE │ FALSE │ FALSE
    UNKNOWN│UNKNOWN│ FALSE │ UNKNOWN
```

#### OR Truth Table
```
    OR    │ TRUE  │ FALSE │ UNKNOWN
    ──────┼───────┼───────┼─────────
    TRUE  │ TRUE  │ TRUE  │ TRUE
    FALSE │ TRUE  │ FALSE │ UNKNOWN
    UNKNOWN│ TRUE  │UNKNOWN│ UNKNOWN
```

#### NOT Truth Table
```
    Expression │ NOT Expression
    ───────────┼───────────────
    TRUE       │ FALSE
    FALSE      │ TRUE
    UNKNOWN    │ UNKNOWN
```

### Predicate Evaluation Flow
```
┌─────────────────┐
│   Input Data    │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│ Apply Predicate │ ──► Contains NULL? ──Yes──► Result: UNKNOWN
│   Expression    │                    │
└─────────┬───────┘                    │
          │                            No
          ▼                            │
┌─────────────────┐                    ▼
│ Evaluate Logic  │ ──────────────► TRUE or FALSE
│ (TRUE/FALSE)    │
└─────────────────┘
```

## Basic Predicates

### Simple Examples

#### 1. Comparison Predicates
```sql
-- Basic comparison operators
SELECT * FROM Employees e WHERE e.BaseSalary > 50000;        -- Greater than
SELECT * FROM Employees e WHERE Age <= 30;             -- Less than or equal
SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';     -- Equal
SELECT * FROM Employees e WHERE DepartmentID != 2004;    -- Not equal
SELECT * FROM Employees e WHERE DepartmentID <> 2004;    -- Not equal (alternative)
```

#### 2. BETWEEN Predicate
```sql
-- Range checking
SELECT * FROM Employees e 
WHERE e.BaseSalary BETWEEN 40000 AND 80000;

-- Equivalent to:
SELECT * FROM Employees e 
WHERE e.BaseSalary >= 40000 AND e.BaseSalary <= 80000;

-- Date ranges
SELECT * FROM Orders 
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';
```

#### 3. IN Predicate
```sql
-- List membership
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName IN ('IT', 'Finance', 'Marketing');

-- Equivalent to:
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName = 'Engineering' OR d.DepartmentName = 'Finance' OR d.DepartmentName = 'Marketing';

-- With subquery
SELECT CustomerID, CompanyName FROM Customers 
WHERE CategoryID IN (
    SELECT CategoryID FROM Categories 
    WHERE CategoryName LIKE '%Food%'
);
```

#### 4. LIKE Predicate (Pattern Matching)
```sql
-- Basic pattern matching
SELECT * FROM Employees e WHERE e.FirstName LIKE 'J%';     -- Starts with 'J'
SELECT * FROM Employees e WHERE e.FirstName LIKE '%son';   -- Ends with 'son'
SELECT * FROM Employees e WHERE e.FirstName LIKE '%an%';   -- Contains 'an'
SELECT * FROM Employees e WHERE e.FirstName LIKE 'J_hn';   -- J followed by any char, then 'hn'

-- Escape characters
SELECT CustomerID, CompanyName FROM Customers WHERE ProductName LIKE '%50[%]%';  -- Contains '50%'
```

### Intermediate Examples

#### 1. NULL Predicates
```sql
-- Testing for NULL values
SELECT * FROM Employees e WHERE MiddleName IS NULL;
SELECT * FROM Employees e WHERE MiddleName IS NOT NULL;

-- Common mistake - this returns no rows even if MiddleName contains NULLs
SELECT * FROM Employees e WHERE MiddleName = NULL;  -- WRONG!
SELECT * FROM Employees e WHERE MiddleName != NULL; -- WRONG!
```

#### 2. EXISTS Predicate
```sql
-- Correlated subquery existence test
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.e.EmployeeID = e.EmployeeID 
    AND o.OrderDate >= '2023-01-01'
);

-- NOT EXISTS for anti-join pattern
SELECT c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.CustomerID = c.CustomerID
);
```

#### 3. Complex Logical Combinations
```sql
-- AND, OR, NOT operators with proper grouping
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE (Department = 'IT' OR d.DepartmentName = 'Engineering')
  AND e.BaseSalary > 60000
  AND e.HireDate >= '2020-01-01';

-- De Morgan's Laws application
-- NOT (A AND B) is equivalent to (NOT A) OR (NOT B)
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE NOT (Department = 'HR' AND e.BaseSalary < 40000);

-- Equivalent to:
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE DepartmentID != 2004 OR e.BaseSalary >= 40000;
```

### Advanced Examples

#### 1. Complex Predicate Logic with CASE
```sql
-- Multi-condition evaluation
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary IS NULL THEN 'No e.BaseSalary Data'
        WHEN e.BaseSalary < 30000 THEN 'Entry Level'
        WHEN e.BaseSalary BETWEEN 30000 AND 60000 THEN 'Mid Level'
        WHEN e.BaseSalary BETWEEN 60001 AND 100000 THEN 'Senior Level'
        ELSE 'Executive Level'
    END AS SalaryCategory,
    CASE 
        WHEN d.DepartmentName = 'Sales' AND e.BaseSalary > 80000 THEN 'Top Sales Performer'
        WHEN d.DepartmentName = 'Engineering' AND DATEDIFF(YEAR, e.HireDate, GETDATE()) > 5 THEN 'Senior IT Professional'
        WHEN Age < 25 AND d.DepartmentName = 'Marketing' THEN 'Young Marketing Talent'
        ELSE 'Standard Employee'
    END AS EmployeeType
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

#### 2. Advanced Pattern Matching
```sql
-- Complex LIKE patterns with character classes
SELECT CustomerID, CompanyName FROM Customers 
WHERE ProductCode LIKE '[A-Z][A-Z][0-9][0-9][0-9]';  -- Two letters followed by three digits

-- Using wildcards with ESCAPE
DECLARE @SearchTerm NVARCHAR(50) = '50% Off';
SELECT CustomerID, CompanyName FROM Customers 
WHERE Description LIKE '%' + REPLACE(@SearchTerm, '%', '\%') + '%' ESCAPE '\';

-- Regular expression-like patterns (SQL Server 2022+)
SELECT * FROM Employees e 
WHERE e.FirstName LIKE '%[aeiou]%[aeiou]%';  -- Contains at least two vowels
```

#### 3. Advanced EXISTS Patterns
```sql
-- Double negation (find customers who have ordered ALL products from a category)
SELECT c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT p.ProductID
    FROM Products p
    WHERE p.CategoryID = 1  -- Specific category
    AND NOT EXISTS (
        SELECT 1
        FROM Orders o
        INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
        WHERE o.CustomerID = c.CustomerID
        AND od.ProductID = p.ProductID
    )
);

-- Correlated EXISTS with aggregation
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.e.EmployeeID = e.EmployeeID
    GROUP BY o.e.EmployeeID
    HAVING COUNT(*) > 10 AND AVG(o.OrderTotal) > 1000
);
```

## Truth Tables and NULL Handling

### AND Truth Table
```sql
-- Understanding AND with NULLs
/*
TRUE  AND TRUE  = TRUE
TRUE  AND FALSE = FALSE
TRUE  AND NULL  = NULL
FALSE AND TRUE  = FALSE
FALSE AND FALSE = FALSE
FALSE AND NULL  = FALSE
NULL  AND TRUE  = NULL
NULL  AND FALSE = FALSE
NULL  AND NULL  = NULL
*/

-- Example demonstrating NULL behavior
SELECT *
FROM Employees e
WHERE (e.BaseSalary > 50000) AND (MiddleName IS NOT NULL);
```

### OR Truth Table
```sql
-- Understanding OR with NULLs
/*
TRUE  OR TRUE  = TRUE
TRUE  OR FALSE = TRUE
TRUE  OR NULL  = TRUE
FALSE OR TRUE  = TRUE
FALSE OR FALSE = FALSE
FALSE OR NULL  = NULL
NULL  OR TRUE  = TRUE
NULL  OR FALSE = NULL
NULL  OR NULL  = NULL
*/

-- Example demonstrating NULL behavior
SELECT *
FROM Employees e
WHERE (Department = 'IT') OR (MiddleName IS NULL);
```

### NOT Truth Table
```sql
-- Understanding NOT with NULLs
/*
NOT TRUE  = FALSE
NOT FALSE = TRUE
NOT NULL  = NULL
*/

-- Be careful with NOT and NULLs
SELECT * FROM Employees e WHERE NOT (MiddleName = 'John');
-- This excludes rows where MiddleName IS NULL!

-- To include NULLs:
SELECT * FROM Employees e 
WHERE MiddleName != 'John' OR MiddleName IS NULL;
```

## Common Predicate Patterns

### 1. Handling Optional Parameters
```sql
-- Flexible search with optional parameters
DECLARE @SearchName NVARCHAR(50) = NULL;
DECLARE @SearchDept NVARCHAR(50) = 'IT';
DECLARE @MinSalary DECIMAL(10,2) = NULL;

SELECT *
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (@SearchName IS NULL OR e.FirstName LIKE '%' + @SearchName + '%')
  AND (@SearchDept IS NULL OR d.DepartmentName = @SearchDept)
  AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary);
```

### 2. Date Range Predicates
```sql
-- Flexible date filtering
SELECT *
FROM Orders
WHERE OrderDate >= COALESCE(@StartDate, '1900-01-01')
  AND OrderDate < COALESCE(@EndDate, '9999-12-31');

-- Same month/year comparisons
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2023
  AND MONTH(OrderDate) = 12;

-- More efficient with computed columns or proper indexing:
SELECT *
FROM Orders
WHERE OrderDate >= '2023-12-01'
  AND OrderDate < '2024-01-01';
```

### 3. Set-Based Predicates
```sql
-- ANY/ALL predicates (SQL Standard - limited support in T-SQL)
SELECT *
FROM Products
WHERE Price > ALL (
    SELECT Price 
    FROM Products 
    WHERE CategoryID = 1
);

-- T-SQL equivalent using aggregates
SELECT *
FROM Products
WHERE Price > (
    SELECT MAX(Price) 
    FROM Products 
    WHERE CategoryID = 1
);
```

## Performance Considerations

### 1. Sargable Predicates
```sql
-- Sargable (Search ARGument ABLE) - can use indexes efficiently
SELECT * FROM Employees e WHERE e.BaseSalary > 50000;
SELECT * FROM Employees e WHERE e.LastName = 'Smith';
SELECT * FROM Employees e WHERE e.HireDate >= '2023-01-01';

-- Non-sargable - cannot use indexes efficiently
SELECT * FROM Employees e WHERE YEAR(e.HireDate) = 2023;  -- Function on column
SELECT * FROM Employees e WHERE e.BaseSalary * 1.1 > 55000;   -- Expression on column
SELECT * FROM Employees e WHERE e.LastName LIKE '%smith'; -- Leading wildcard
```

### 2. Optimizing Complex Predicates
```sql
-- Instead of complex OR conditions that can't use indexes well
SELECT * FROM Employees e 
WHERE e.FirstName = 'John' OR e.LastName = 'Smith' OR d.DepartmentName = 'Engineering';

-- Consider UNION for better performance:
SELECT * FROM Employees e WHERE e.FirstName = 'John'
UNION
SELECT * FROM Employees e WHERE e.LastName = 'Smith'
UNION
SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';
```

### 3. EXISTS vs IN Performance
```sql
-- EXISTS often performs better with correlated subqueries
SELECT c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.CustomerID = c.CustomerID 
    AND o.OrderDate >= '2023-01-01'
);

-- IN performs well with small, static lists
SELECT * FROM Employees e 
WHERE DepartmentID IN (1, 2, 3, 4, 5);
```

## Best Practices for Predicate Logic

### 1. Explicit NULL Handling
```sql
-- Always be explicit about NULL handling
SELECT *
FROM Employees e
WHERE (MiddleName = @SearchMiddleName OR (MiddleName IS NULL AND @SearchMiddleName IS NULL));

-- Use ISNULL/COALESCE for default values
SELECT *
FROM Employees e
WHERE ISNULL(MiddleName, '') LIKE '%' + ISNULL(@SearchMiddleName, '') + '%';
```

### 2. Use Parentheses for Clarity
```sql
-- Clear precedence with parentheses
SELECT *
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (Department = 'IT' OR d.DepartmentName = 'Engineering')
  AND (e.BaseSalary > 60000)
  AND (e.HireDate >= '2020-01-01' OR Title LIKE '%Senior%');
```

### 3. Consistent Data Types
```sql
-- Ensure consistent data types to avoid implicit conversions
SELECT *
FROM Orders
WHERE CustomerID = 12345  -- If CustomerID is INT
  AND OrderDate = '2023-12-01';  -- Will be converted to DATE/DATETIME
```

## Summary

Key principles of predicate logic in T-SQL:

1. **Three-Valued Logic**: Remember TRUE, FALSE, and UNKNOWN (NULL)
2. **NULL Handling**: Use IS NULL/IS NOT NULL, never = NULL
3. **Logical Operators**: Understand AND, OR, NOT behavior with NULLs
4. **Performance**: Write sargable predicates when possible
5. **Clarity**: Use parentheses to make complex logic clear
6. **EXISTS vs IN**: Choose the right predicate for the situation
7. **Pattern Matching**: Master LIKE patterns and escape sequences

Understanding predicate logic is essential for writing correct and efficient T-SQL queries.
