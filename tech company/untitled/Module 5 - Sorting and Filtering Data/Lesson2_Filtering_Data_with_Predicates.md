# Lesson 2: Filtering Data with Predicates

## Overview
Filtering data with predicates is essential for retrieving specific subsets of data from tables. Predicates are logical expressions that evaluate to TRUE, FALSE, or UNKNOWN, and they form the foundation of WHERE clauses, HAVING clauses, and conditional logic. This lesson covers all types of predicates and filtering techniques in T-SQL.

## Understanding Predicates

### What are Predicates?
A predicate is a logical expression that returns TRUE, FALSE, or UNKNOWN (due to NULL values). Predicates are used in WHERE clauses to filter rows, in HAVING clauses to filter groups, and in conditional expressions.

### Three-Valued Logic in Predicates
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         THREE-VALUED LOGIC SYSTEM                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SQL uses three-valued logic, not binary (true/false):                     │
│                                                                             │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐                               │
│  │  TRUE   │     │  FALSE  │     │ UNKNOWN │                               │
│  │         │     │         │     │ (NULL)  │                               │
│  │ Include │     │ Exclude │     │ Exclude │                               │
│  │ in      │     │ from    │     │ from    │                               │
│  │ result  │     │ result  │     │ result  │                               │
│  └─────────┘     └─────────┘     └─────────┘                               │
│                                                                             │
│  Truth Table Examples:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Expression           │ Value │ NULL  │ Result                           │
│  ├─────────────────────────────────────────────────────────────────────────┤
│  │ 5 > 3               │ TRUE  │   -   │ Include row                      │
│  │ 5 < 3               │ FALSE │   -   │ Exclude row                      │
│  │ NULL > 3            │   -   │ NULL  │ Exclude row (UNKNOWN)            │
│  │ 5 > NULL            │   -   │ NULL  │ Exclude row (UNKNOWN)            │
│  │ NULL = NULL         │   -   │ NULL  │ Exclude row (UNKNOWN)            │
│  │ Column IS NULL      │ TRUE  │   -   │ Include row (when column is NULL)│
│  │ Column IS NOT NULL  │ TRUE  │   -   │ Include row (when column not NULL)│
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Key Insight: Only TRUE predicates include rows in results                 │
│              FALSE and UNKNOWN both exclude rows                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Basic Filtering Predicates

### Comparison Operators
```sql
-- Equal to
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary = 75000;

-- Not equal to (two forms)
SELECT e.FirstName, e.LastName, d.DepartmentID
FROM Employees e
WHERE d.DepartmentID != 3;  -- or <> 3

-- Greater than / Less than
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
WHERE e.HireDate > '2020-01-01'
  AND e.BaseSalary < 100000;

-- Greater/Less than or equal to
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary >= 50000
  AND e.BaseSalary <= 80000;
```

### BETWEEN Predicate
```sql
-- Range filtering with BETWEEN (inclusive)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary BETWEEN 50000 AND 80000;
-- Equivalent to: e.BaseSalary >= 50000 AND e.BaseSalary <= 80000

-- Date ranges
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
WHERE e.HireDate BETWEEN '2020-01-01' AND '2022-12-31';

-- NOT BETWEEN
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary NOT BETWEEN 40000 AND 60000;
-- Equivalent to: e.BaseSalary < 40000 OR e.BaseSalary > 60000
```

### IN Predicate
```sql
-- List membership
SELECT e.FirstName, e.LastName, d.DepartmentID
FROM Employees e
WHERE d.DepartmentID IN (1, 3, 5);
-- Equivalent to: d.DepartmentID = 1 OR d.DepartmentID = 3 OR d.DepartmentID = 5

-- String lists
SELECT e.FirstName, e.LastName, e.JobTitle
FROM Employees e
WHERE e.JobTitle IN ('Manager', 'Director', 'VP');

-- NOT IN
SELECT e.FirstName, e.LastName, d.DepartmentID
FROM Employees e
WHERE d.DepartmentID NOT IN (2, 4);

-- Subquery with IN
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE d.DepartmentID IN (
    SELECT d.DepartmentID 
    FROM Departments d 
    WHERE d.Budget > 500000
);
```

### LIKE Predicate (Pattern Matching)
```sql
-- Wildcard patterns
SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE e.FirstName LIKE 'J%';        -- Starts with 'J'

SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE e.LastName LIKE '%son';       -- Ends with 'son'

SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE e.FirstName LIKE '%an%';      -- Contains 'an'

SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE e.FirstName LIKE 'J_hn';      -- J + any char + hn

-- Character sets
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.FirstName LIKE '[ABC]%';    -- Starts with A, B, or C

SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.FirstName LIKE '[A-M]%';    -- Starts with A through M

SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.FirstName LIKE '[^A-M]%';   -- Does NOT start with A through M
```

## Intermediate Filtering Techniques

### Combining Predicates with Logical Operators
```sql
-- AND operator (all conditions must be true)
SELECT e.FirstName, e.LastName, e.BaseSalary, DepartmentID
FROM Employees e
WHERE e.BaseSalary > 70000
  AND DepartmentID = 1
  AND e.HireDate >= '2020-01-01';

-- OR operator (any condition can be true)
SELECT e.FirstName, e.LastName, e.JobTitle
FROM Employees e
WHERE e.JobTitle LIKE '%Manager%'
   OR e.JobTitle LIKE '%Director%'
   OR e.BaseSalary > 90000;

-- Complex combinations with parentheses
SELECT e.FirstName, e.LastName, e.BaseSalary, DepartmentID
FROM Employees e
WHERE (e.BaseSalary > 80000 OR Title LIKE '%Senior%')
  AND DepartmentID IN (1, 2, 3)
  AND e.HireDate >= '2019-01-01';
```

### NULL Handling Predicates
```sql
-- IS NULL / IS NOT NULL
SELECT e.FirstName, e.LastName, MiddleName
FROM Employees e
WHERE MiddleName IS NULL;

SELECT e.FirstName, e.LastName, ManagerID
FROM Employees e
WHERE ManagerID IS NOT NULL;

-- Combining NULL checks with other conditions
SELECT e.FirstName, e.LastName, e.BaseSalary, MiddleName
FROM Employees e
WHERE e.BaseSalary > 60000
  AND (MiddleName IS NOT NULL OR e.FirstName LIKE 'J%');
```

### EXISTS Predicate
```sql
-- EXISTS with correlated subquery
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE EXISTS (
    SELECT 1 
    FROM EmployeeProjects ep 
    WHERE ep.EmployeeID = e.EmployeeID
);

-- NOT EXISTS
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 
    FROM EmployeeProjects ep 
    WHERE ep.EmployeeID = e.EmployeeID
);

-- Complex EXISTS with multiple conditions
SELECT e.FirstName, e.LastName, e.JobTitle
FROM Employees e
WHERE EXISTS (
    SELECT 1 
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.EmployeeID = e.EmployeeID
      AND p.IsActive = 'Active'
      AND ep.HoursAllocated > 100
);
```

## Advanced Filtering Patterns

### Predicate Logic Visualization
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PREDICATE COMBINATIONS                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  AND Logic (All conditions must be TRUE):                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  Condition A    Condition B    Result                                  │
│  │  ┌─────────┐   ┌─────────┐   ┌─────────┐                              │
│  │  │  TRUE   │ ∩ │  TRUE   │ = │  TRUE   │ ✅ Include                   │
│  │  │  TRUE   │ ∩ │  FALSE  │ = │  FALSE  │ ❌ Exclude                   │
│  │  │  FALSE  │ ∩ │  TRUE   │ = │  FALSE  │ ❌ Exclude                   │
│  │  │  FALSE  │ ∩ │  FALSE  │ = │  FALSE  │ ❌ Exclude                   │
│  │  │  TRUE   │ ∩ │ UNKNOWN │ = │ UNKNOWN │ ❌ Exclude                   │
│  │  └─────────┘   └─────────┘   └─────────┘                              │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  OR Logic (Any condition can be TRUE):                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  Condition A    Condition B    Result                                  │
│  │  ┌─────────┐   ┌─────────┐   ┌─────────┐                              │
│  │  │  TRUE   │ ∪ │  TRUE   │ = │  TRUE   │ ✅ Include                   │
│  │  │  TRUE   │ ∪ │  FALSE  │ = │  TRUE   │ ✅ Include                   │
│  │  │  FALSE  │ ∪ │  TRUE   │ = │  TRUE   │ ✅ Include                   │
│  │  │  FALSE  │ ∪ │  FALSE  │ = │  FALSE  │ ❌ Exclude                   │
│  │  │  FALSE  │ ∪ │ UNKNOWN │ = │ UNKNOWN │ ❌ Exclude                   │
│  │  └─────────┘   └─────────┘   └─────────┘                              │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Practical Example:                                                        │
│  WHERE (BaseSalary > 80000 OR Title LIKE '%Senior%') AND DepartmentID = 1     │
│         └─────────── OR ──────────┘           └── AND ──┘                 │
│                                                                             │
│  Evaluation Order: Parentheses → AND → OR (left to right)                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Complex Predicate Scenarios
```sql
-- Multi-level filtering with business logic
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    -- Primary criteria: Active employees only
    e.IsActive = 1
    
    -- Department-specific criteria
    AND (
        (d.DepartmentName = 'IT' AND e.BaseSalary >= 70000)
        OR (d.DepartmentName = 'Finance' AND e.BaseSalary >= 65000)
        OR (d.DepartmentName = 'Sales' AND (e.JobTitle LIKE '%Manager%' OR e.BaseSalary >= 60000))
        OR (d.DepartmentName NOT IN ('IT', 'Finance', 'Sales') AND e.BaseSalary >= 50000)
    )
    
    -- Experience criteria
    AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2
    
    -- Exclude specific conditions
    AND NOT (e.JobTitle LIKE '%Intern%' OR e.JobTitle LIKE '%Temp%')
    
    -- Handle edge cases
    AND e.WorkEmail IS NOT NULL
    AND e.WorkEmail LIKE '%@company.com';
```

### Filtering with Calculations
```sql
-- Filter by calculated values
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    e.BaseSalary / DATEDIFF(YEAR, e.HireDate, GETDATE()) AS SalaryPerYear
FROM Employees e
WHERE 
    -- Filter by calculated tenure
    DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 3 AND 10
    
    -- Filter by calculated e.BaseSalary efficiency
    AND e.BaseSalary / DATEDIFF(YEAR, e.HireDate, GETDATE()) > 15000
    
    -- Filter by name length
    AND LEN(e.FirstName + e.LastName) <= 20
    
    -- Filter by email domain
    AND RIGHT(WorkEmail, LEN(WorkEmail) - CHARINDEX('@', WorkEmail)) = 'company.com';
```

### Subquery Filtering Patterns
```sql
-- Filter using correlated subqueries
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    -- Above average e.BaseSalary in their d.DepartmentName
    e.BaseSalary > (
        SELECT AVG(e2.BaseSalary)
        FROM Employees e e2
        WHERE e2.DepartmentID = e.DepartmentID
          AND e2.IsActive = 1
    )
    
    -- Has skills in high-demand categories
    AND EXISTS (
        SELECT 1
        FROM Employees e ekills es
        INNER JOIN Skills s ON es.SkillID = s.SkillID
        WHERE es.EmployeeID = e.EmployeeID
          AND s.MarketDemand = 'High'
          AND es.ProficiencyLevel IN ('Advanced', 'Expert')
    )
    
    -- Not the highest paid in d.DepartmentName (leave room for growth)
    AND e.BaseSalary < (
        SELECT MAX(e3.BaseSalary)
        FROM Employees e e3
        WHERE e3.DepartmentID = e.DepartmentID
          AND e3.IsActive = 1
    );
```

## Performance Optimization for Filtering

### Sargable vs Non-Sargable Predicates
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SARGABLE PREDICATE GUIDE                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SARGABLE (Search ARGument ABLE) - Can use indexes efficiently:            │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ✅ WHERE LastName = 'Smith'                                             │
│  │ ✅ WHERE BaseSalary > 50000                                                 │
│  │ ✅ WHERE HireDate BETWEEN '2020-01-01' AND '2022-12-31'                │
│  │ ✅ WHERE DepartmentID IN (1, 2, 3)                                      │
│  │ ✅ WHERE LastName LIKE 'Smith%'  (leading chars specified)             │
│  │ ✅ WHERE IsActive = 1                                                   │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  NON-SARGABLE - Cannot use indexes efficiently:                            │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ❌ WHERE UPPER(LastName) = 'SMITH'       (function on column)           │
│  │ ❌ WHERE BaseSalary * 1.1 > 55000            (expression on column)         │
│  │ ❌ WHERE YEAR(HireDate) = 2021           (function on column)           │
│  │ ❌ WHERE LastName LIKE '%Smith'          (leading wildcard)             │
│  │ ❌ WHERE SUBSTRING(WorkEmail, 1, 5) = 'admin' (function on column)          │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Optimization Strategies:                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │ Instead of: WHERE YEAR(HireDate) = 2021                                │
│  │ Use:        WHERE HireDate >= '2021-01-01'                             │
│  │             AND HireDate < '2022-01-01'                                │
│  │                                                                         │
│  │ Instead of: WHERE UPPER(LastName) = 'SMITH'                            │
│  │ Use:        WHERE LastName = 'Smith'                                   │
│  │             (or create computed column with index)                      │
│  │                                                                         │
│  │ Instead of: WHERE BaseSalary * 1.1 > 55000                                 │
│  │ Use:        WHERE BaseSalary > 55000 / 1.1                                 │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Index-Friendly Filtering
```sql
-- Create indexes to support common filtering patterns
CREATE INDEX IX_Employees_Active_Salary 
ON Employees (IsActive, e.BaseSalary) 
WHERE IsActive = 1;

CREATE INDEX IX_Employees_Department_HireDate 
ON Employees (DepartmentID, e.HireDate);

CREATE INDEX IX_Employees_LastName_FirstName 
ON Employees (e.LastName, e.FirstName);

-- These queries will use indexes efficiently
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE IsActive = 1 AND e.BaseSalary > 70000;  -- Uses IX_Employees_Active_Salary

SELECT e.FirstName, e.LastName
FROM Employees e
WHERE DepartmentID = 1 
  AND e.HireDate >= '2020-01-01';  -- Uses IX_Employees_Department_HireDate

SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE e.LastName LIKE 'Smith%';  -- Uses IX_Employees_LastName_FirstName
```

## Filtering Best Practices

### Predicate Ordering for Performance
```sql
-- Good: Most selective predicates first
SELECT e.FirstName, e.LastName, Title
FROM Employees e
WHERE e.EmployeeID = 12345        -- Most selective (unique)
  AND IsActive = 1              -- Less selective
  AND DepartmentID IN (1, 2, 3) -- Least selective
  AND e.FirstName LIKE 'J%';

-- Good: Use EXISTS instead of IN for correlated conditions
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE EXISTS (
    SELECT 1 FROM EmployeeProjects ep
    WHERE ep.EmployeeID = e.EmployeeID
    AND ep.ProjectID IN (SELECT ProjectID FROM Projects p WHERE IsActive = 'Active')
);
```

### NULL-Safe Filtering
```sql
-- Handle NULLs explicitly
SELECT e.FirstName, e.LastName, MiddleName
FROM Employees e
WHERE 
    -- Include employees with middle names starting with 'A'
    (MiddleName IS NOT NULL AND MiddleName LIKE 'A%')
    
    -- OR employees without middle names
    OR MiddleName IS NULL;

-- Use ISNULL/COALESCE for default values
SELECT e.FirstName, e.LastName, Phone
FROM Employees e
WHERE ISNULL(Phone, '') LIKE '206%';  -- Treat NULL as empty string
```

### Complex Business Rule Implementation
```sql
-- Implement complex business rules with clear logic
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    -- Must be active
    e.IsActive = 1
    
    -- Department-specific qualification rules
    AND (
        -- IT: Senior level with high skills
        (d.DepartmentName = 'IT' 
         AND e.JobTitle LIKE '%Senior%' 
         AND EXISTS (
             SELECT 1 FROM Employees e ekills es 
             WHERE es.EmployeeID = e.EmployeeID 
             AND es.ProficiencyLevel = 'Expert'
         ))
         
        -- Sales: High performers or managers
        OR (d.DepartmentName = 'Sales' 
            AND (e.BaseSalary >= 75000 OR e.JobTitle LIKE '%Manager%'))
            
        -- Finance: Certified professionals
        OR (d.DepartmentName = 'Finance' 
            AND EXISTS (
                SELECT 1 FROM Employees e ekills es
                INNER JOIN Skills s ON es.SkillID = s.SkillID
                WHERE es.EmployeeID = e.EmployeeID 
                AND s.SkillCategoryID = 'Finance'
                AND es.CertificationDate IS NOT NULL
            ))
            
        -- Other departments: standard criteria
        OR (d.DepartmentName NOT IN ('IT', 'Sales', 'Finance') 
            AND e.BaseSalary >= 50000 
            AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1)
    );
```

## Common Filtering Mistakes

### Mistake 1: NULL Comparison Errors
```sql
-- WRONG: NULL comparisons always return UNKNOWN
SELECT * FROM Employees e WHERE MiddleName = NULL;     -- Returns no rows
SELECT * FROM Employees e WHERE MiddleName != NULL;    -- Returns no rows

-- CORRECT: Use IS NULL / IS NOT NULL
SELECT * FROM Employees e WHERE MiddleName IS NULL;
SELECT * FROM Employees e WHERE MiddleName IS NOT NULL;
```

### Mistake 2: Inefficient NOT IN with NULLs
```sql
-- PROBLEMATIC: NOT IN with potential NULLs
SELECT * FROM Employees e 
WHERE DepartmentID NOT IN (
    SELECT DepartmentID FROM SomeTable WHERE Condition = 'X'
);
-- If subquery contains NULL, entire result is empty

-- SOLUTION: Use NOT EXISTS or handle NULLs explicitly
SELECT * FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 FROM SomeTable s 
    WHERE s.DepartmentID = e.DepartmentID 
    AND s.Condition = 'X'
);
```

### Mistake 3: Function Usage Preventing Index Use
```sql
-- INEFFICIENT: Function on filtered column
SELECT * FROM Employees e 
WHERE UPPER(e.LastName) = 'SMITH';

-- EFFICIENT: Use proper case or computed column
SELECT * FROM Employees e 
WHERE e.LastName = 'Smith';

-- Or create computed column with index
ALTER TABLE Employees ADD LastNameUpper AS UPPER(e.LastName);
CREATE INDEX IX_Employees_LastNameUpper ON Employees(LastNameUpper);
```

## Summary

Effective data filtering requires mastering:

1. **Predicate Types**: Comparison, BETWEEN, IN, LIKE, NULL tests, EXISTS
2. **Logical Operators**: AND, OR, NOT with proper precedence
3. **Three-Valued Logic**: TRUE, FALSE, UNKNOWN behavior
4. **Performance**: Sargable predicates and index usage
5. **NULL Handling**: Explicit NULL tests and safe comparisons
6. **Complex Logic**: Nested conditions and business rules

**Key Takeaways:**
- Only TRUE predicates include rows; FALSE and UNKNOWN exclude them
- Use sargable predicates to enable efficient index usage
- Handle NULL values explicitly with IS NULL/IS NOT NULL
- Order predicates by selectivity for better performance
- Test complex filtering logic thoroughly with edge cases
- Document business rules clearly in code comments

Mastering predicate-based filtering enables precise data retrieval while maintaining optimal query performance.
