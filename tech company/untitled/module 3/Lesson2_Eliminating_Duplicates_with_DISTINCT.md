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
-- Without DISTINCT - shows all department IDs (with duplicates)
SELECT DepartmentID 
FROM Employees;

-- With DISTINCT - shows unique department IDs only
SELECT DISTINCT DepartmentID 
FROM Employees;

-- Practical example: Get all cities where employees live
SELECT DISTINCT City
FROM Employees
WHERE City IS NOT NULL
ORDER BY City;
```

### 2. DISTINCT with Single Column
```sql
-- Find all unique job titles in the company
SELECT DISTINCT Title
FROM Employees
ORDER BY Title;

-- Find all unique salary amounts
SELECT DISTINCT BaseSalary
FROM Employees
ORDER BY BaseSalary DESC;

-- Find all hire years
SELECT DISTINCT YEAR(HireDate) AS HireYear
FROM Employees
ORDER BY HireYear;
```

### 3. DISTINCT vs. Non-DISTINCT Comparison
```sql
-- Count total employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees;

-- Count employees with distinct first names
SELECT COUNT(DISTINCT FirstName) AS UniqueFirstNames
FROM Employees;

-- Show the difference
SELECT 
    COUNT(*) AS TotalEmployees,
    COUNT(DISTINCT FirstName) AS UniqueFirstNames,
    COUNT(*) - COUNT(DISTINCT FirstName) AS DuplicateFirstNames
FROM Employees;
```

## Intermediate Examples

### 1. DISTINCT with Multiple Columns
```sql
-- DISTINCT applies to the combination of ALL columns
SELECT DISTINCT FirstName, LastName
FROM Employees
ORDER BY LastName, FirstName;

-- Different combinations that illustrate the concept
SELECT DISTINCT DepartmentID, Title
FROM Employees
ORDER BY DepartmentID, Title;

-- Compare single vs. multiple column DISTINCT
SELECT DISTINCT DepartmentID FROM Employees;  -- Unique departments
SELECT DISTINCT DepartmentID, Title FROM Employees;  -- Unique dept/title combinations
```

### 2. DISTINCT with Calculated Columns
```sql
-- Unique salary ranges
SELECT DISTINCT 
    CASE 
        WHEN BaseSalary < 50000 THEN 'Low'
        WHEN BaseSalary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryRange
FROM Employees;

-- Unique hire date components
SELECT DISTINCT 
    YEAR(HireDate) AS HireYear,
    MONTH(HireDate) AS HireMonth
FROM Employees
ORDER BY HireYear, HireMonth;

-- Unique email domains
SELECT DISTINCT 
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain
FROM Employees
ORDER BY EmailDomain;
```

### 3. DISTINCT in Subqueries
```sql
-- Find employees who work in departments that have more than one unique title
SELECT FirstName, LastName, DepartmentID, Title
FROM Employees
WHERE DepartmentID IN (
    SELECT DISTINCT DepartmentID
    FROM Employees
    GROUP BY DepartmentID
    HAVING COUNT(DISTINCT Title) > 1
);

-- Find the most recent hire date for each department
SELECT 
    e.DepartmentID,
    e.FirstName,
    e.LastName,
    e.HireDate
FROM Employees e
WHERE e.HireDate IN (
    SELECT MAX(HireDate)
    FROM Employees e2
    WHERE e2.DepartmentID = e.DepartmentID
);
```

### 4. DISTINCT with JOINs
```sql
-- Assuming we have a Departments table
-- Find unique department names that have employees
SELECT DISTINCT d.DepartmentName
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
ORDER BY d.DepartmentName;

-- Find unique combinations of department and manager information
SELECT DISTINCT 
    d.DepartmentName,
    m.FirstName + ' ' + m.LastName AS ManagerName
FROM Departments d
LEFT JOIN Employees m ON d.ManagerID = m.EmployeeID
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
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
    LEFT JOIN Skills s ON es.SkillID = s.SkillID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT DISTINCT SkillSet
FROM EmployeeSkillSets
WHERE SkillSet IS NOT NULL
ORDER BY SkillSet;
```

### 2. DISTINCT with Window Functions
```sql
-- Find distinct salary ranks within each department
SELECT DISTINCT
    DepartmentID,
    DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY BaseSalary DESC) AS SalaryRank,
    BaseSalary
FROM Employees
ORDER BY DepartmentID, SalaryRank;

-- Unique tenure patterns
SELECT DISTINCT
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    COUNT(*) OVER (PARTITION BY DATEDIFF(YEAR, HireDate, GETDATE())) AS EmployeesWithSameTenure
FROM Employees
ORDER BY YearsOfService;
```

### 3. DISTINCT for Data Quality Analysis
```sql
-- Find potential duplicate employees (same name, different IDs)
WITH PotentialDuplicates AS (
    SELECT 
        FirstName,
        LastName,
        COUNT(*) AS OccurrenceCount,
        COUNT(DISTINCT EmployeeID) AS UniqueIDs
    FROM Employees
    GROUP BY FirstName, LastName
    HAVING COUNT(*) > 1
)
SELECT DISTINCT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Email,
    'Potential Duplicate Name' AS DataQualityIssue
FROM Employees e
INNER JOIN PotentialDuplicates pd 
    ON e.FirstName = pd.FirstName 
    AND e.LastName = pd.LastName
ORDER BY e.LastName, e.FirstName, e.EmployeeID;

-- Find distinct email domain patterns for validation
SELECT DISTINCT
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain,
    COUNT(*) OVER (PARTITION BY SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))) AS UsageCount,
    CASE 
        WHEN SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) NOT LIKE '%.%' 
             THEN 'Invalid Domain Format'
        WHEN SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) LIKE '%company.com' 
             THEN 'Company Domain'
        ELSE 'External Domain'
    END AS DomainType
FROM Employees
WHERE Email IS NOT NULL
ORDER BY UsageCount DESC;
```

### 4. DISTINCT in Complex Reporting
```sql
-- Comprehensive distinct analysis for management reporting
WITH DistinctAnalysis AS (
    SELECT DISTINCT
        DepartmentID,
        YEAR(HireDate) AS HireYear,
        CASE 
            WHEN BaseSalary < 50000 THEN 'Entry'
            WHEN BaseSalary BETWEEN 50000 AND 75000 THEN 'Mid'
            WHEN BaseSalary BETWEEN 75001 AND 100000 THEN 'Senior'
            ELSE 'Executive'
        END AS SalaryTier,
        CASE 
            WHEN Title LIKE '%Manager%' OR Title LIKE '%Director%' THEN 'Management'
            WHEN Title LIKE '%Senior%' THEN 'Senior Individual Contributor'
            ELSE 'Individual Contributor'
        END AS RoleType
    FROM Employees
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
    GROUP BY DepartmentID
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
             THEN 'Homogeneous BaseSalary Structure'
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
FROM Employees;

-- GROUP BY - groups rows and allows aggregation
SELECT DepartmentID
FROM Employees
GROUP BY DepartmentID;

-- GROUP BY with aggregation (more powerful)
SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount,
    AVG(BaseSalary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID;
```

### When to Use Each
```sql
-- Use DISTINCT when you only need to eliminate duplicates
SELECT DISTINCT City
FROM Employees
ORDER BY City;

-- Use GROUP BY when you need aggregation or more complex logic
SELECT 
    City,
    COUNT(*) AS EmployeeCount,
    MIN(HireDate) AS FirstHireDate,
    MAX(HireDate) AS LastHireDate
FROM Employees
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
FROM Employees e1
WHERE EXISTS (
    SELECT DISTINCT e2.Title
    FROM Employees e2
    WHERE e2.DepartmentID = e1.DepartmentID
    AND e2.Title LIKE '%Manager%'
);

-- More efficient
SELECT DISTINCT e1.DepartmentID
FROM Employees e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.DepartmentID = e1.DepartmentID
    AND e2.Title LIKE '%Manager%'
);
```

### 2. Index Considerations
```sql
-- DISTINCT can benefit from appropriate indexes
-- For this query:
SELECT DISTINCT DepartmentID, Title
FROM Employees;

-- Consider creating an index:
-- CREATE INDEX IX_Employees_Dept_Title ON Employees(DepartmentID, Title);
```

### 3. Alternative Approaches
```sql
-- Instead of DISTINCT in large datasets, consider GROUP BY
-- DISTINCT approach
SELECT DISTINCT DepartmentID
FROM Employees;

-- GROUP BY approach (sometimes more efficient)
SELECT DepartmentID
FROM Employees
GROUP BY DepartmentID;

-- Using window functions to avoid DISTINCT
SELECT DepartmentID
FROM (
    SELECT 
        DepartmentID,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY EmployeeID) AS rn
    FROM Employees
) ranked
WHERE rn = 1;
```

## Common Mistakes and Best Practices

### 1. Misunderstanding DISTINCT Scope
```sql
-- WRONG: Thinking DISTINCT applies to individual columns
-- This gets distinct combinations of DepartmentID and FirstName
SELECT DISTINCT DepartmentID, FirstName
FROM Employees;

-- If you want distinct DepartmentIDs, do this:
SELECT DISTINCT DepartmentID
FROM Employees;

-- If you want both, use separate queries or subqueries
SELECT DISTINCT DepartmentID FROM Employees
UNION
SELECT DISTINCT FirstName FROM Employees;
```

### 2. Unnecessary DISTINCT Usage
```sql
-- WRONG: Using DISTINCT when not needed
SELECT DISTINCT EmployeeID, FirstName, LastName
FROM Employees;
-- EmployeeID is unique, so DISTINCT is unnecessary

-- CORRECT: Only use DISTINCT when duplicates are possible
SELECT DISTINCT DepartmentID
FROM Employees;
```

### 3. DISTINCT with Functions
```sql
-- Be careful with functions in DISTINCT
SELECT DISTINCT UPPER(FirstName)
FROM Employees;
-- This is fine

-- But consider performance implications
SELECT DISTINCT 
    UPPER(FirstName),
    LOWER(LastName),
    FORMAT(BaseSalary, 'C')
FROM Employees;
-- Multiple functions can impact performance
```

### 4. NULL Handling with DISTINCT
```sql
-- DISTINCT treats NULL as a distinct value
SELECT DISTINCT MiddleName
FROM Employees;
-- Will show NULL as one of the distinct values

-- To exclude NULLs:
SELECT DISTINCT MiddleName
FROM Employees
WHERE MiddleName IS NOT NULL;

-- To replace NULLs:
SELECT DISTINCT ISNULL(MiddleName, 'No Middle Name') AS MiddleName
FROM Employees;
```

## Practical Applications

### 1. Data Exploration
```sql
-- Quick data profiling with DISTINCT
SELECT 'DepartmentID' AS ColumnName, COUNT(DISTINCT DepartmentID) AS UniqueValues FROM Employees
UNION ALL
SELECT 'Title', COUNT(DISTINCT Title) FROM Employees
UNION ALL
SELECT 'City', COUNT(DISTINCT City) FROM Employees
UNION ALL
SELECT 'HireYear', COUNT(DISTINCT YEAR(HireDate)) FROM Employees;
```

### 2. Data Validation
```sql
-- Find inconsistent data entry
SELECT DISTINCT UPPER(City) AS City, COUNT(*) AS Variations
FROM (
    SELECT DISTINCT City FROM Employees WHERE City IS NOT NULL
) cities
GROUP BY UPPER(City)
HAVING COUNT(*) > 1;
```

### 3. Business Intelligence
```sql
-- Market analysis: distinct customer segments
SELECT DISTINCT
    CASE 
        WHEN BaseSalary < 40000 THEN 'Budget Conscious'
        WHEN BaseSalary BETWEEN 40000 AND 80000 THEN 'Middle Market'
        ELSE 'Premium'
    END AS MarketSegment,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN 'New Generation'
        ELSE 'Experienced'
    END AS ExperienceLevel
FROM Employees
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
