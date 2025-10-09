# Lesson 2: Eliminating Duplicates with DISTINCT

## Overview
The DISTINCT keyword is essential for removing duplicate rows from query results. Understanding when and how to use DISTINCT effectively is crucial for accurate data analysis and reporting. This lesson covers various applications of DISTINCT, from simple duplicate removal to complex scenarios involving multiple columns and subqueries.

## Understanding DISTINCT

### What DISTINCT Does
DISTINCT eliminates duplicate rows from the result set by comparing all selected columns. Two rows are considered duplicates only if ALL selected columns have identical values.

### Basic Syntax
```sql
SELECT DISTINCT column_list
FROM table_name
[WHERE condition]
[ORDER BY column_list];
```

## Simple Examples

### 1. Basic DISTINCT Usage
```sql
-- Without DISTINCT - shows all d.DepartmentName IDs (with duplicates)
SELECT d.DepartmentID 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- With DISTINCT - shows unique d.DepartmentName IDs only
SELECT DISTINCT d.DepartmentID 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Practical example: Get all cities where employees live
SELECT DISTINCT City
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE City IS NOT NULL
ORDER BY City;
```

### 2. DISTINCT with Single Column
```sql
-- Find all unique job titles in the company
SELECT DISTINCT Title
FROM Employees e
ORDER BY Title;

-- Find all unique e.BaseSalary amounts
SELECT DISTINCT e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Find all hire years
SELECT DISTINCT YEAR(e.HireDate) AS HireYear
FROM Employees e
ORDER BY HireYear;
```

### 3. DISTINCT vs. Non-DISTINCT Comparison
```sql
-- Count total employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees e;

-- Count employees with distinct first names
SELECT COUNT(DISTINCT e.FirstName) AS UniqueFirstNames
FROM Employees e;

-- Show the difference
SELECT 
    COUNT(*) AS TotalEmployees,
    COUNT(DISTINCT e.FirstName) AS UniqueFirstNames,
    COUNT(*) - COUNT(DISTINCT e.FirstName) AS DuplicateFirstNames
FROM Employees e;
```

## Intermediate Examples

### 1. DISTINCT with Multiple Columns
```sql
-- DISTINCT applies to the combination of ALL columns
SELECT DISTINCT e.FirstName, e.LastName
FROM Employees e
ORDER BY e.LastName, e.FirstName;

-- Different combinations that illustrate the concept
SELECT DISTINCT d.DepartmentID, Title
FROM Employees e
ORDER BY DepartmentIDID, Title;

-- Compare single vs. multiple column DISTINCT
SELECT DISTINCT d.DepartmentID FROM Employees e;  -- Unique departments
SELECT DISTINCT d.DepartmentID, Title FROM Employees e;  -- Unique dept/title combinations
```

### 2. DISTINCT with Calculated Columns
```sql
-- Unique e.BaseSalary ranges
SELECT DISTINCT 
    CASE 
        WHEN e.BaseSalary < 50000 THEN 'Low'
        WHEN e.BaseSalary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryRange
FROM Employees e;

-- Unique hire date components
SELECT DISTINCT 
    YEAR(e.HireDate) AS HireYear,
    MONTH(e.HireDate) AS HireMonth
FROM Employees e
ORDER BY HireYear, HireMonth;

-- Unique email domains
SELECT DISTINCT 
    SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) AS EmailDomain
FROM Employees e
ORDER BY EmailDomain;
```

### 3. DISTINCT in Subqueries
```sql
-- Find employees who work in departments that have more than one unique title
SELECT e.FirstName, e.LastName, d.DepartmentID, Title
FROM Employees e
WHERE d.DepartmentID IN (
    SELECT DISTINCT d.DepartmentID
    FROM Employees e
    GROUP BY DepartmentIDID
    HAVING COUNT(DISTINCT Title) > 1
);

-- Find the most recent hire date for each d.DepartmentName
SELECT 
    e.d.DepartmentID,
    e.FirstName,
    e.LastName,
    e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.HireDate IN (
    SELECT MAX(e.HireDate)
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID
);
```

### 4. DISTINCT with JOINs
```sql
-- Assuming we have a Departments table
-- Find unique d.DepartmentName names that have employees
SELECT DISTINCT d.DepartmentName
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
ORDER BY d.DepartmentName;

-- Find unique combinations of d.DepartmentName and manager information
SELECT DISTINCT 
    d.DepartmentName,
    m.e.FirstName + ' ' + m.e.LastName AS ManagerName
FROM Departments d
LEFT JOIN Employees m ON d.ManagerID = m.e.EmployeeID
ORDER BY d.DepartmentName;
```

## Advanced Examples

### 1. Complex DISTINCT Scenarios
```sql
-- Find employees with unique skill combinations (assuming EmployeeSkills table)
WITH EmployeeSkillSets AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        STRING_AGG(s.SkillName, ', ') WITHIN GROUP (ORDER BY s.SkillName) AS SkillSet
    FROM Employees e
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.e.EmployeeID
    LEFT JOIN Skills s ON es.SkillID = s.SkillID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT DISTINCT SkillSet
FROM Employees e ekillSets
WHERE SkillSet IS NOT NULL
ORDER BY SkillSet;
```

### 2. DISTINCT with Window Functions
```sql
-- Find distinct e.BaseSalary ranks within each d.DepartmentName
SELECT DISTINCT
    DepartmentID,
    DENSE_RANK() OVER (PARTITION BY DepartmentIDID ORDER BY e.BaseSalary DESC) AS SalaryRank,
    e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY DepartmentIDID, SalaryRank;

-- Unique tenure patterns
SELECT DISTINCT
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    COUNT(*) OVER (PARTITION BY DATEDIFF(YEAR, e.HireDate, GETDATE())) AS EmployeesWithSameTenure
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY YearsOfService;
```

### 3. DISTINCT for Data Quality Analysis
```sql
-- Find potential duplicate employees (same name, different IDs)
WITH PotentialDuplicates AS (
    SELECT 
        e.FirstName,
        e.LastName,
        COUNT(*) AS OccurrenceCount,
        COUNT(DISTINCT e.EmployeeID) AS UniqueIDs
    FROM Employees e
    GROUP BY e.FirstName, e.LastName
    HAVING COUNT(*) > 1
)
SELECT DISTINCT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.WorkEmail,
    'Potential Duplicate Name' AS DataQualityIssue
FROM Employees e
INNER JOIN PotentialDuplicates pd 
    ON e.FirstName = pd.e.FirstName 
    AND e.LastName = pd.e.LastName
ORDER BY e.LastName, e.FirstName, e.EmployeeID;

-- Find distinct email domain patterns for validation
SELECT DISTINCT
    SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) AS EmailDomain,
    COUNT(*) OVER (PARTITION BY SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail))) AS UsageCount,
    CASE 
        WHEN SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) NOT LIKE '%.%' 
             THEN 'Invalid Domain Format'
        WHEN SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) LIKE '%company.com' 
             THEN 'Company Domain'
        ELSE 'External Domain'
    END AS DomainType
FROM Employees e
WHERE WorkEmail IS NOT NULL
ORDER BY UsageCount DESC;
```

### 4. DISTINCT in Complex Reporting
```sql
-- Comprehensive distinct analysis for management reporting
WITH DistinctAnalysis AS (
    SELECT DISTINCT
        DepartmentID,
        YEAR(e.HireDate) AS HireYear,
        CASE 
            WHEN e.BaseSalary < 50000 THEN 'Entry'
            WHEN e.BaseSalary BETWEEN 50000 AND 75000 THEN 'Mid'
            WHEN e.BaseSalary BETWEEN 75001 AND 100000 THEN 'Senior'
            ELSE 'Executive'
        END AS SalaryTier,
        CASE 
            WHEN Title LIKE '%Manager%' OR Title LIKE '%Director%' THEN 'Management'
            WHEN Title LIKE '%Senior%' THEN 'Senior Individual Contributor'
            ELSE 'Individual Contributor'
        END AS RoleType
    FROM Employees e
    WHERE IsActive = 1
),
SummaryStats AS (
    SELECT 
        DepartmentID,
        COUNT(DISTINCT HireYear) AS DistinctHireYears,
        COUNT(DISTINCT SalaryTier) AS DistinctSalaryTiers,
        COUNT(DISTINCT RoleType) AS DistinctRoleTypes,
        STRING_AGG(DISTINCT CAST(HireYear AS VARCHAR), ', ') AS HireYearsList,
        STRING_AGG(DISTINCT SalaryTier, ', ') AS SalaryTiersList,
        STRING_AGG(DISTINCT RoleType, ', ') AS RoleTypesList
    FROM DistinctAnalysis
    GROUP BY DepartmentIDID
)
SELECT 
    ss.DepartmentID,
    d.DepartmentName,
    ss.DistinctHireYears,
    ss.DistinctSalaryTiers,
    ss.DistinctRoleTypes,
    ss.HireYearsList,
    ss.SalaryTiersList,
    ss.RoleTypesList,
    CASE 
        WHEN ss.DistinctSalaryTiers >= 3 AND ss.DistinctRoleTypes >= 2 
             THEN 'Diverse Department'
        WHEN ss.DistinctSalaryTiers = 1 
             THEN 'Homogeneous e.BaseSalary Structure'
        ELSE 'Moderate Diversity'
    END AS DiversityProfile
FROM SummaryStats ss
LEFT JOIN Departments d ON ss.DepartmentID = d.DepartmentID
ORDER BY ss.DistinctSalaryTiers DESC, ss.DistinctRoleTypes DESC;
```

## DISTINCT vs. GROUP BY

### Understanding the Difference
```sql
-- DISTINCT - simply removes duplicates
SELECT DISTINCT DepartmentID
FROM Employees e;

-- GROUP BY - groups rows and allows aggregation
SELECT DepartmentID
FROM Employees e
GROUP BY DepartmentIDID;

-- GROUP BY with aggregation (more powerful)
SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
GROUP BY DepartmentIDID;
```

### When to Use Each
```sql
-- Use DISTINCT when you only need to eliminate duplicates
SELECT DISTINCT City
FROM Employees e
ORDER BY City;

-- Use GROUP BY when you need aggregation or more complex logic
SELECT 
    City,
    COUNT(*) AS EmployeeCount,
    MIN(e.HireDate) AS FirstHireDate,
    MAX(e.HireDate) AS LastHireDate
FROM Employees e
WHERE City IS NOT NULL
GROUP BY City
ORDER BY EmployeeCount DESC;
```

## Performance Considerations

### 1. DISTINCT Performance Impact
```sql
-- DISTINCT requires sorting/hashing - can be expensive on large datasets
-- Consider if you really need DISTINCT or if duplicates are acceptable

-- More efficient: Use EXISTS instead of DISTINCT with subqueries
-- Less efficient
SELECT DISTINCT e1.DepartmentID
FROM Employees e e1
WHERE EXISTS (
    SELECT DISTINCT e2.Title
    FROM Employees e e2
    WHERE e2.DepartmentID = e1.DepartmentID
    AND e2.Title LIKE '%Manager%'
);

-- More efficient
SELECT DISTINCT e1.DepartmentID
FROM Employees e e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e e2
    WHERE e2.DepartmentID = e1.DepartmentID
    AND e2.Title LIKE '%Manager%'
);
```

### 2. Index Considerations
```sql
-- DISTINCT can benefit from appropriate indexes
-- For this query:
SELECT DISTINCT DepartmentID, Title
FROM Employees e;

-- Consider creating an index:
-- CREATE INDEX IX_Employees_Dept_Title ON Employees(DepartmentID, Title);
```

### 3. Alternative Approaches
```sql
-- Instead of DISTINCT in large datasets, consider GROUP BY
-- DISTINCT approach
SELECT DISTINCT DepartmentID
FROM Employees e;

-- GROUP BY approach (sometimes more efficient)
SELECT DepartmentID
FROM Employees e
GROUP BY DepartmentIDID;

-- Using window functions to avoid DISTINCT
SELECT DepartmentID
FROM (
    SELECT 
        DepartmentID,
        ROW_NUMBER() OVER (PARTITION BY DepartmentIDID ORDER BY e.EmployeeID) AS rn
    FROM Employees e
) ranked
WHERE rn = 1;
```

## Common Mistakes and Best Practices

### 1. Misunderstanding DISTINCT Scope
```sql
-- WRONG: Thinking DISTINCT applies to individual columns
-- This gets distinct combinations of DepartmentID and e.FirstName
SELECT DISTINCT DepartmentID, e.FirstName
FROM Employees e;

-- If you want distinct DepartmentIDs, do this:
SELECT DISTINCT DepartmentID
FROM Employees e;

-- If you want both, use separate queries or subqueries
SELECT DISTINCT DepartmentID FROM Employees e
UNION
SELECT DISTINCT e.FirstName FROM Employees e;
```

### 2. Unnecessary DISTINCT Usage
```sql
-- WRONG: Using DISTINCT when not needed
SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e;
-- e.EmployeeID is unique, so DISTINCT is unnecessary

-- CORRECT: Only use DISTINCT when duplicates are possible
SELECT DISTINCT DepartmentID
FROM Employees e;
```

### 3. DISTINCT with Functions
```sql
-- Be careful with functions in DISTINCT
SELECT DISTINCT UPPER(e.FirstName)
FROM Employees e;
-- This is fine

-- But consider performance implications
SELECT DISTINCT 
    UPPER(e.FirstName),
    LOWER(e.LastName),
    FORMAT(e.BaseSalary, 'C')
FROM Employees e;
-- Multiple functions can impact performance
```

### 4. NULL Handling with DISTINCT
```sql
-- DISTINCT treats NULL as a distinct value
SELECT DISTINCT MiddleName
FROM Employees e;
-- Will show NULL as one of the distinct values

-- To exclude NULLs:
SELECT DISTINCT MiddleName
FROM Employees e
WHERE MiddleName IS NOT NULL;

-- To replace NULLs:
SELECT DISTINCT ISNULL(MiddleName, 'No Middle Name') AS MiddleName
FROM Employees e;
```

## Practical Applications

### 1. Data Exploration
```sql
-- Quick data profiling with DISTINCT
SELECT 'DepartmentID' AS ColumnName, COUNT(DISTINCT DepartmentID) AS UniqueValues FROM Employees e
UNION ALL
SELECT 'Title', COUNT(DISTINCT Title) FROM Employees e
UNION ALL
SELECT 'City', COUNT(DISTINCT City) FROM Employees e
UNION ALL
SELECT 'HireYear', COUNT(DISTINCT YEAR(e.HireDate)) FROM Employees e;
```

### 2. Data Validation
```sql
-- Find inconsistent data entry
SELECT DISTINCT UPPER(City) AS City, COUNT(*) AS Variations
FROM (
    SELECT DISTINCT City FROM Employees e WHERE City IS NOT NULL
) cities
GROUP BY UPPER(City)
HAVING COUNT(*) > 1;
```

### 3. Business Intelligence
```sql
-- Market analysis: distinct customer segments
SELECT DISTINCT
    CASE 
        WHEN e.BaseSalary < 40000 THEN 'Budget Conscious'
        WHEN e.BaseSalary BETWEEN 40000 AND 80000 THEN 'Middle Market'
        ELSE 'Premium'
    END AS MarketSegment,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 5 THEN 'New Generation'
        ELSE 'Experienced'
    END AS ExperienceLevel
FROM Employees e
ORDER BY MarketSegment, ExperienceLevel;
```

## Summary

Key concepts for using DISTINCT effectively:

1. **Purpose**: Eliminates duplicate rows based on ALL selected columns
2. **Performance**: Can be expensive on large datasets - use judiciously
3. **Scope**: Applies to the entire row, not individual columns
4. **Alternatives**: Consider GROUP BY when aggregation is needed
5. **NULL Handling**: NULL is treated as a distinct value
6. **Best Practice**: Only use when duplicates are actually possible
7. **Indexing**: Appropriate indexes can improve DISTINCT performance

DISTINCT is a powerful tool for data analysis and reporting, but understanding its behavior and performance implications is crucial for effective use in production systems.
