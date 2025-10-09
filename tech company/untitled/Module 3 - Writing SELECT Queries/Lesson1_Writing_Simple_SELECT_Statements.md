# Lesson 1: Writing Simple SELECT Statements

## Overview
The SELECT statement is the foundation of all data retrieval in T-SQL. It allows you to query data from one or more tables, apply filters, perform calculations, and format results. This lesson covers the fundamentals of writing simple SELECT statements, from basic syntax to more complex data retrieval scenarios.

## Basic SELECT Syntax

### Fundamental Structure
```sql
SELECT column_list
FROM table_name
[WHERE condition]
[ORDER BY column_list];
```

### Query Execution Flow
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          SELECT STATEMENT EXECUTION FLOW                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. FROM       ┌─────────────┐                                              │
│     ──────────►│   Table     │ ◄─── Identify source table(s)               │
│                │  Scanning   │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  2. WHERE      ┌──────▼──────┐                                              │
│     ──────────►│   Filter    │ ◄─── Apply row-level filters               │
│                │    Rows     │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  3. GROUP BY   ┌──────▼──────┐                                              │
│     ──────────►│    Group    │ ◄─── Group rows (if specified)             │
│                │    Rows     │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  4. HAVING     ┌──────▼──────┐                                              │
│     ──────────►│   Filter    │ ◄─── Apply group-level filters             │
│                │   Groups    │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  5. SELECT     ┌──────▼──────┐                                              │
│     ──────────►│   Select    │ ◄─── Choose columns & expressions           │
│                │  Columns    │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  6. ORDER BY   ┌──────▼──────┐                                              │
│     ──────────►│    Sort     │ ◄─── Sort final result set                 │
│                │   Results   │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│  7. TOP/OFFSET ┌──────▼──────┐                                              │
│     ──────────►│   Limit     │ ◄─── Limit number of rows returned         │
│                │   Rows      │                                              │
│                └──────┬──────┘                                              │
│                       │                                                     │
│                   ┌───▼───┐                                                 │
│                   │ FINAL │                                                 │
│                   │RESULT │                                                 │
│                   │  SET  │                                                 │
│                   └───────┘                                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Key Components:
- **SELECT**: Specifies which columns to retrieve
- **FROM**: Specifies the source table(s)
- **WHERE**: Optional filter condition
- **ORDER BY**: Optional sorting specification

## Simple Examples

### 1. Select All Columns
```sql
-- Retrieve all columns FROM Employees e table
SELECT * FROM Employees e;

-- More explicit version (better practice)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    WorkEmail,
    DepartmentID,
    e.BaseSalary,
    e.HireDate
FROM Employees e;
```

### 2. Select Specific Columns
```sql
-- Basic column selection
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e;

-- With consistent formatting
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM Employees e;
```

### 3. Column Order and Arrangement
```sql
-- Columns appear in the order specified
SELECT 
    e.LastName,
    e.FirstName,
    WorkEmail,
    e.BaseSalary
FROM Employees e;

-- Same data, different presentation
SELECT 
    e.BaseSalary,
    e.LastName,
    e.FirstName
FROM Employees e;
```

### 4. Literal Values and Constants
```sql
-- Including literal values in results
SELECT 
    'Employee' AS RecordType,
    e.FirstName,
    e.LastName,
    'Active' AS IsActive,
    GETDATE() AS ReportDate
FROM Employees e;

-- Numeric literals
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    100 AS BonusPercent,
    e.BaseSalary * 1.1 AS SalaryWithBonus
FROM Employees e;
```

## Intermediate Examples

### 1. Basic Calculations
```sql
-- Mathematical operations
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary / 12 AS MonthlySalary,
    e.BaseSalary * 0.15 AS EstimatedTax,
    e.BaseSalary - (e.BaseSalary * 0.15) AS NetAnnualSalary
FROM Employees e;

-- More complex calculations
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary > 80000 THEN e.BaseSalary * 0.08
        WHEN e.BaseSalary > 60000 THEN e.BaseSalary * 0.06
        ELSE e.BaseSalary * 0.04
    END AS BonusAmount
FROM Employees e;
```

### 2. String Concatenation
```sql
-- Basic string concatenation
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    WorkEmail,
    e.BaseSalary
FROM Employees e;

-- Handling NULL values in concatenation
SELECT 
    e.FirstName + ' ' + ISNULL(MiddleName + ' ', '') + e.LastName AS FullName,
    WorkEmail,
    e.BaseSalary
FROM Employees e;

-- Using CONCAT function (SQL Server 2012+)
SELECT 
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    CONCAT('$', FORMAT(e.BaseSalary, 'N0')) AS FormattedSalary
FROM Employees e;
```

### 3. Date Operations
```sql
-- Date calculations and formatting
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    DATEDIFF(DAY, e.HireDate, GETDATE()) AS DaysEmployed,
    DATEADD(YEAR, 1, e.HireDate) AS FirstAnniversary
FROM Employees e;

-- Date formatting
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    FORMAT(e.HireDate, 'MMMM dd, yyyy') AS FormattedHireDate,
    DATENAME(WEEKDAY, e.HireDate) AS HireDayOfWeek,
    YEAR(e.HireDate) AS HireYear
FROM Employees e;
```

### 4. Basic WHERE Clauses
```sql
-- Simple filtering
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    DepartmentID
FROM Employees e
WHERE e.BaseSalary > 70000;

-- Multiple conditions
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
WHERE e.BaseSalary > 60000 
  AND e.HireDate >= '2020-01-01';

-- String filtering
SELECT 
    e.FirstName,
    e.LastName,
    WorkEmail
FROM Employees e
WHERE e.FirstName LIKE 'J%'
   OR e.LastName LIKE '%son';
```

## Advanced Examples

### 1. Complex Calculated Columns
```sql
-- Advanced business calculations
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.HireDate,
    -- Performance rating based on tenure and e.BaseSalary
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 AND e.BaseSalary >= 80000 
             THEN 'Senior High Performer'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 AND e.BaseSalary >= 65000 
             THEN 'Experienced Contributor'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 AND e.BaseSalary >= 50000 
             THEN 'Developing Professional'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1 
             THEN 'New Hire'
        ELSE 'Needs Review'
    END AS PerformanceCategory,
    -- Projected e.BaseSalary growth
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 
             THEN e.BaseSalary * 1.05
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 5 
             THEN e.BaseSalary * 1.03
        ELSE e.BaseSalary * 1.02
    END AS ProjectedSalary
FROM Employees e;
```

### 2. Advanced String Manipulation
```sql
-- Complex string operations
SELECT 
    e.FirstName,
    e.LastName,
    WorkEmail,
    -- Extract username from email
    LEFT(WorkEmail, CHARINDEX('@', WorkEmail) - 1) AS Username,
    -- Extract domain from email
    SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) AS EmailDomain,
    -- Create initials
    LEFT(e.FirstName, 1) + LEFT(e.LastName, 1) AS Initials,
    -- Create display name variations
    UPPER(LEFT(e.FirstName, 1)) + LOWER(SUBSTRING(e.FirstName, 2, LEN(e.FirstName))) + ' ' +
    UPPER(LEFT(e.LastName, 1)) + LOWER(SUBSTRING(e.LastName, 2, LEN(e.LastName))) AS ProperCaseName,
    -- Generate employee code
    UPPER(LEFT(e.FirstName, 2)) + UPPER(LEFT(e.LastName, 2)) + 
    RIGHT('000' + CAST(e.EmployeeID AS VARCHAR), 3) AS EmployeeCode
FROM Employees e;
```

### 3. Advanced Date and Time Operations
```sql
-- Comprehensive date analysis
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    -- Service time calculations
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS CompletedYears,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 AS AdditionalMonths,
    DATEDIFF(DAY, 
        DATEADD(MONTH, DATEDIFF(MONTH, e.HireDate, GETDATE()), e.HireDate), 
        GETDATE()) AS AdditionalDays,
    -- Milestone dates
    DATEADD(YEAR, 5, e.HireDate) AS FiveYearAnniversary,
    DATEADD(YEAR, 10, e.HireDate) AS TenYearAnniversary,
    -- Eligibility calculations
    CASE 
        WHEN DATEDIFF(MONTH, e.HireDate, GETDATE()) >= 6 
             THEN 'Eligible for Benefits'
        ELSE 'Not Yet Eligible'
    END AS BenefitEligibility,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 
             THEN 'Eligible for Promotion Review'
        ELSE 'Too Early for Promotion'
    END AS PromotionEligibility,
    -- Seasonal hire analysis
    CASE 
        WHEN MONTH(e.HireDate) IN (12, 1, 2) THEN 'Winter Hire'
        WHEN MONTH(e.HireDate) IN (3, 4, 5) THEN 'Spring Hire'
        WHEN MONTH(e.HireDate) IN (6, 7, 8) THEN 'Summer Hire'
        ELSE 'Fall Hire'
    END AS HireSeason
FROM Employees e;
```

### 4. Complex Business Logic
```sql
-- Advanced business rule implementation
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    DepartmentID,
    e.HireDate,
    -- Compensation analysis
    CASE 
        WHEN DepartmentID = 1 AND e.BaseSalary < 70000 THEN 'IT: Below Market'
        WHEN DepartmentID = 1 AND e.BaseSalary >= 70000 THEN 'IT: Competitive'
        WHEN DepartmentID = 2 AND e.BaseSalary < 60000 THEN 'HR: Below Market'
        WHEN DepartmentID = 2 AND e.BaseSalary >= 60000 THEN 'HR: Competitive'
        WHEN DepartmentID = 3 AND e.BaseSalary < 65000 THEN 'Finance: Below Market'
        WHEN DepartmentID = 3 AND e.BaseSalary >= 65000 THEN 'Finance: Competitive'
        ELSE 'Other Department'
    END AS CompensationAnalysis,
    -- Risk assessment
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) > 10 AND e.BaseSalary < 75000 
             THEN 'High Flight Risk - Long Tenure, Low Pay'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1 AND e.BaseSalary > 90000 
             THEN 'New High Investment'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 5 AND e.BaseSalary BETWEEN 60000 AND 80000 
             THEN 'Stable Contributor'
        ELSE 'Standard Risk Profile'
    END AS RiskAssessment,
    -- Career stage
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 'Entry Level'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 7 THEN 'Mid Career'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 8 AND 15 THEN 'Senior Level'
        ELSE 'Veteran'
    END AS CareerStage
FROM Employees e;
```

## Best Practices for SELECT Statements

### 1. Column Selection
```sql
-- Good: Specify only needed columns
SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e;

-- Avoid: Using SELECT * in production code
-- SELECT * FROM Employees e; -- Don't do this in production
```

### 2. Consistent Formatting
```sql
-- Good: Consistent, readable formatting
SELECT 
    e.FirstName,
    e.LastName,
    e.WorkEmail,
    e.BaseSalary
FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.LastName, e.FirstName;

-- Avoid: Inconsistent formatting
-- SELECT e.FirstName,e.LastName,WorkEmail,e.BaseSalary FROM Employees e WHERE IsActive=1;
```

### 3. Use Meaningful Column Names
```sql
-- Good: Clear, descriptive names
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeFullName,
    e.BaseSalary / 12 AS MonthlySalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
FROM Employees e;

-- Avoid: Unclear abbreviations
-- SELECT e.FirstName + ' ' + e.LastName AS Name,
--        e.BaseSalary / 12 AS Sal,
--        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS Yrs
-- FROM Employees e;
```

### 4. Handle NULL Values Appropriately
```sql
-- Good: Explicit NULL handling
SELECT 
    e.FirstName,
    ISNULL(MiddleName, 'N/A') AS MiddleName,
    e.LastName,
    ISNULL(ManagerID, 0) AS ManagerID
FROM Employees e;

-- Consider: Using COALESCE for multiple possible NULLs
SELECT 
    e.FirstName,
    COALESCE(MiddleName, NickName, 'N/A') AS DisplayMiddleName
FROM Employees e;
```

### 5. Use Comments for Complex Logic
```sql
-- Employee compensation analysis with business context
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    -- Calculate annual bonus based on performance tier
    CASE 
        WHEN e.BaseSalary >= 90000 THEN e.BaseSalary * 0.15  -- Executive level: 15%
        WHEN e.BaseSalary >= 70000 THEN e.BaseSalary * 0.10  -- Senior level: 10%
        WHEN e.BaseSalary >= 50000 THEN e.BaseSalary * 0.05  -- Mid level: 5%
        ELSE e.BaseSalary * 0.02                       -- Entry level: 2%
    END AS AnnualBonus,
    -- Determine eligibility for stock options (must be employed 2+ years)
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Eligible'
        ELSE 'Not Eligible'
    END AS StockOptionEligibility
FROM Employees e;
```

## Common Mistakes and How to Avoid Them

### 1. Implicit Data Type Conversions
```sql
-- Problematic: Mixing data types
SELECT 
    e.FirstName,
    e.LastName,
    'Employee ID: ' + e.EmployeeID  -- Error if e.EmployeeID is INT
FROM Employees e;

-- Correct: Explicit conversion
SELECT 
    e.FirstName,
    e.LastName,
    'Employee ID: ' + CAST(e.EmployeeID AS VARCHAR(10))
FROM Employees e;
```

### 2. NULL Concatenation Issues
```sql
-- Problematic: NULL in concatenation makes entire result NULL
SELECT 
    e.FirstName + ' ' + MiddleName + ' ' + e.LastName AS FullName
FROM Employees e;

-- Correct: Handle NULLs explicitly
SELECT 
    e.FirstName + ' ' + ISNULL(MiddleName + ' ', '') + e.LastName AS FullName
FROM Employees e;
```

### 3. Division by Zero
```sql
-- Problematic: Potential division by zero
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary / WorkHours AS HourlyRate  -- WorkHours might be 0
FROM Employees e;

-- Correct: Check for zero before division
SELECT 
    e.FirstName,
    e.LastName,
    CASE 
        WHEN WorkHours > 0 THEN e.BaseSalary / WorkHours
        ELSE NULL
    END AS HourlyRate
FROM Employees e;
```

## Performance Considerations

### 1. Column Selection Impact
```sql
-- More efficient: Select only needed columns
SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e;

-- Less efficient: Selecting unnecessary large columns
-- SELECT * FROM Employees e; -- Includes potentially large binary columns
```

### 2. Function Usage in SELECT
```sql
-- Consider performance impact of functions
SELECT 
    e.FirstName,
    e.LastName,
    UPPER(e.FirstName) AS UpperFirstName,  -- Function applied to each row
    e.BaseSalary
FROM Employees e;

-- Sometimes better to handle formatting in application layer
-- for large result sets
```

### 3. Complex Calculations
```sql
-- For frequently used complex calculations, consider computed columns
-- or views rather than repeating logic in every query

-- Example: This complex calculation in every query
SELECT 
    e.FirstName,
    e.LastName,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 AND e.BaseSalary >= 80000 
             THEN 'Senior High Performer'
        -- ... more complex logic
    END AS PerformanceRating
FROM Employees e;

-- Better: Create a view or computed column for reusability
```

## Summary

Key principles for writing effective SELECT statements:

1. **Be Specific**: Select only the columns you need
2. **Be Consistent**: Use consistent formatting and naming conventions
3. **Handle NULLs**: Always consider NULL value behavior
4. **Use Comments**: Document complex business logic
5. **Consider Performance**: Be mindful of function usage and data types
6. **Test Thoroughly**: Verify results with different data scenarios
7. **Plan for Maintenance**: Write readable, maintainable code

The SELECT statement is your primary tool for data retrieval. Mastering its fundamentals and best practices will serve as the foundation for all your T-SQL development work.
