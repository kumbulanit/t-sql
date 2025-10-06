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
-- Retrieve all columns from Employees table
SELECT * FROM Employees;

-- More explicit version (better practice)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Email,
    DepartmentID,
    BaseSalary,
    HireDate
FROM Employees;
```

### 2. Select Specific Columns
```sql
-- Basic column selection
SELECT FirstName, LastName, BaseSalary
FROM Employees;

-- With consistent formatting
SELECT 
    FirstName,
    LastName,
    BaseSalary
FROM Employees;
```

### 3. Column Order and Arrangement
```sql
-- Columns appear in the order specified
SELECT 
    LastName,
    FirstName,
    Email,
    BaseSalary
FROM Employees;

-- Same data, different presentation
SELECT 
    BaseSalary,
    LastName,
    FirstName
FROM Employees;
```

### 4. Literal Values and Constants
```sql
-- Including literal values in results
SELECT 
    'Employee' AS RecordType,
    FirstName,
    LastName,
    'Active' AS Status,
    GETDATE() AS ReportDate
FROM Employees;

-- Numeric literals
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    100 AS BonusPercent,
    BaseSalary * 1.1 AS SalaryWithBonus
FROM Employees;
```

## Intermediate Examples

### 1. Basic Calculations
```sql
-- Mathematical operations
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    BaseSalary / 12 AS MonthlySalary,
    BaseSalary * 0.15 AS EstimatedTax,
    BaseSalary - (BaseSalary * 0.15) AS NetAnnualSalary
FROM Employees;

-- More complex calculations
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary > 80000 THEN BaseSalary * 0.08
        WHEN BaseSalary > 60000 THEN BaseSalary * 0.06
        ELSE BaseSalary * 0.04
    END AS BonusAmount
FROM Employees;
```

### 2. String Concatenation
```sql
-- Basic string concatenation
SELECT 
    FirstName + ' ' + LastName AS FullName,
    Email,
    BaseSalary
FROM Employees;

-- Handling NULL values in concatenation
SELECT 
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName,
    Email,
    BaseSalary
FROM Employees;

-- Using CONCAT function (SQL Server 2012+)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT('$', FORMAT(BaseSalary, 'N0')) AS FormattedSalary
FROM Employees;
```

### 3. Date Operations
```sql
-- Date calculations and formatting
SELECT 
    FirstName,
    LastName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed,
    DATEADD(YEAR, 1, HireDate) AS FirstAnniversary
FROM Employees;

-- Date formatting
SELECT 
    FirstName,
    LastName,
    HireDate,
    FORMAT(HireDate, 'MMMM dd, yyyy') AS FormattedHireDate,
    DATENAME(WEEKDAY, HireDate) AS HireDayOfWeek,
    YEAR(HireDate) AS HireYear
FROM Employees;
```

### 4. Basic WHERE Clauses
```sql
-- Simple filtering
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID
FROM Employees
WHERE BaseSalary > 70000;

-- Multiple conditions
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    HireDate
FROM Employees
WHERE BaseSalary > 60000 
  AND HireDate >= '2020-01-01';

-- String filtering
SELECT 
    FirstName,
    LastName,
    Email
FROM Employees
WHERE FirstName LIKE 'J%'
   OR LastName LIKE '%son';
```

## Advanced Examples

### 1. Complex Calculated Columns
```sql
-- Advanced business calculations
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    HireDate,
    -- Performance rating based on tenure and salary
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 AND BaseSalary >= 80000 
             THEN 'Senior High Performer'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 3 AND BaseSalary >= 65000 
             THEN 'Experienced Contributor'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 1 AND BaseSalary >= 50000 
             THEN 'Developing Professional'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 
             THEN 'New Hire'
        ELSE 'Needs Review'
    END AS PerformanceCategory,
    -- Projected salary growth
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 2 
             THEN BaseSalary * 1.05
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 
             THEN BaseSalary * 1.03
        ELSE BaseSalary * 1.02
    END AS ProjectedSalary
FROM Employees;
```

### 2. Advanced String Manipulation
```sql
-- Complex string operations
SELECT 
    FirstName,
    LastName,
    Email,
    -- Extract username from email
    LEFT(Email, CHARINDEX('@', Email) - 1) AS Username,
    -- Extract domain from email
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain,
    -- Create initials
    LEFT(FirstName, 1) + LEFT(LastName, 1) AS Initials,
    -- Create display name variations
    UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName))) + ' ' +
    UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, LEN(LastName))) AS ProperCaseName,
    -- Generate employee code
    UPPER(LEFT(FirstName, 2)) + UPPER(LEFT(LastName, 2)) + 
    RIGHT('000' + CAST(EmployeeID AS VARCHAR), 3) AS EmployeeCode
FROM Employees;
```

### 3. Advanced Date and Time Operations
```sql
-- Comprehensive date analysis
SELECT 
    FirstName,
    LastName,
    HireDate,
    -- Service time calculations
    DATEDIFF(YEAR, HireDate, GETDATE()) AS CompletedYears,
    DATEDIFF(MONTH, HireDate, GETDATE()) % 12 AS AdditionalMonths,
    DATEDIFF(DAY, 
        DATEADD(MONTH, DATEDIFF(MONTH, HireDate, GETDATE()), HireDate), 
        GETDATE()) AS AdditionalDays,
    -- Milestone dates
    DATEADD(YEAR, 5, HireDate) AS FiveYearAnniversary,
    DATEADD(YEAR, 10, HireDate) AS TenYearAnniversary,
    -- Eligibility calculations
    CASE 
        WHEN DATEDIFF(MONTH, HireDate, GETDATE()) >= 6 
             THEN 'Eligible for Benefits'
        ELSE 'Not Yet Eligible'
    END AS BenefitEligibility,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 2 
             THEN 'Eligible for Promotion Review'
        ELSE 'Too Early for Promotion'
    END AS PromotionEligibility,
    -- Seasonal hire analysis
    CASE 
        WHEN MONTH(HireDate) IN (12, 1, 2) THEN 'Winter Hire'
        WHEN MONTH(HireDate) IN (3, 4, 5) THEN 'Spring Hire'
        WHEN MONTH(HireDate) IN (6, 7, 8) THEN 'Summer Hire'
        ELSE 'Fall Hire'
    END AS HireSeason
FROM Employees;
```

### 4. Complex Business Logic
```sql
-- Advanced business rule implementation
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID,
    HireDate,
    -- Compensation analysis
    CASE 
        WHEN DepartmentID = 1 AND BaseSalary < 70000 THEN 'IT: Below Market'
        WHEN DepartmentID = 1 AND BaseSalary >= 70000 THEN 'IT: Competitive'
        WHEN DepartmentID = 2 AND BaseSalary < 60000 THEN 'HR: Below Market'
        WHEN DepartmentID = 2 AND BaseSalary >= 60000 THEN 'HR: Competitive'
        WHEN DepartmentID = 3 AND BaseSalary < 65000 THEN 'Finance: Below Market'
        WHEN DepartmentID = 3 AND BaseSalary >= 65000 THEN 'Finance: Competitive'
        ELSE 'Other Department'
    END AS CompensationAnalysis,
    -- Risk assessment
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) > 10 AND BaseSalary < 75000 
             THEN 'High Flight Risk - Long Tenure, Low Pay'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 AND BaseSalary > 90000 
             THEN 'New High Investment'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 5 AND BaseSalary BETWEEN 60000 AND 80000 
             THEN 'Stable Contributor'
        ELSE 'Standard Risk Profile'
    END AS RiskAssessment,
    -- Career stage
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 2 THEN 'Entry Level'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 7 THEN 'Mid Career'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 8 AND 15 THEN 'Senior Level'
        ELSE 'Veteran'
    END AS CareerStage
FROM Employees;
```

## Best Practices for SELECT Statements

### 1. Column Selection
```sql
-- Good: Specify only needed columns
SELECT FirstName, LastName, Email
FROM Employees;

-- Avoid: Using SELECT * in production code
-- SELECT * FROM Employees; -- Don't do this in production
```

### 2. Consistent Formatting
```sql
-- Good: Consistent, readable formatting
SELECT 
    e.FirstName,
    e.LastName,
    e.Email,
    e.BaseSalary
FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.LastName, e.FirstName;

-- Avoid: Inconsistent formatting
-- SELECT FirstName,LastName,Email,BaseSalary FROM Employees WHERE IsActive=1;
```

### 3. Use Meaningful Column Names
```sql
-- Good: Clear, descriptive names
SELECT 
    FirstName + ' ' + LastName AS EmployeeFullName,
    BaseSalary / 12 AS MonthlySalary,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService
FROM Employees;

-- Avoid: Unclear abbreviations
-- SELECT FirstName + ' ' + LastName AS Name,
--        BaseSalary / 12 AS Sal,
--        DATEDIFF(YEAR, HireDate, GETDATE()) AS Yrs
-- FROM Employees;
```

### 4. Handle NULL Values Appropriately
```sql
-- Good: Explicit NULL handling
SELECT 
    FirstName,
    ISNULL(MiddleName, 'N/A') AS MiddleName,
    LastName,
    ISNULL(ManagerID, 0) AS ManagerID
FROM Employees;

-- Consider: Using COALESCE for multiple possible NULLs
SELECT 
    FirstName,
    COALESCE(MiddleName, NickName, 'N/A') AS DisplayMiddleName
FROM Employees;
```

### 5. Use Comments for Complex Logic
```sql
-- Employee compensation analysis with business context
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    -- Calculate annual bonus based on performance tier
    CASE 
        WHEN BaseSalary >= 90000 THEN BaseSalary * 0.15  -- Executive level: 15%
        WHEN BaseSalary >= 70000 THEN BaseSalary * 0.10  -- Senior level: 10%
        WHEN BaseSalary >= 50000 THEN BaseSalary * 0.05  -- Mid level: 5%
        ELSE BaseSalary * 0.02                       -- Entry level: 2%
    END AS AnnualBonus,
    -- Determine eligibility for stock options (must be employed 2+ years)
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 2 THEN 'Eligible'
        ELSE 'Not Eligible'
    END AS StockOptionEligibility
FROM Employees;
```

## Common Mistakes and How to Avoid Them

### 1. Implicit Data Type Conversions
```sql
-- Problematic: Mixing data types
SELECT 
    FirstName,
    LastName,
    'Employee ID: ' + EmployeeID  -- Error if EmployeeID is INT
FROM Employees;

-- Correct: Explicit conversion
SELECT 
    FirstName,
    LastName,
    'Employee ID: ' + CAST(EmployeeID AS VARCHAR(10))
FROM Employees;
```

### 2. NULL Concatenation Issues
```sql
-- Problematic: NULL in concatenation makes entire result NULL
SELECT 
    FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
FROM Employees;

-- Correct: Handle NULLs explicitly
SELECT 
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName
FROM Employees;
```

### 3. Division by Zero
```sql
-- Problematic: Potential division by zero
SELECT 
    FirstName,
    LastName,
    BaseSalary / WorkHours AS HourlyRate  -- WorkHours might be 0
FROM Employees;

-- Correct: Check for zero before division
SELECT 
    FirstName,
    LastName,
    CASE 
        WHEN WorkHours > 0 THEN BaseSalary / WorkHours
        ELSE NULL
    END AS HourlyRate
FROM Employees;
```

## Performance Considerations

### 1. Column Selection Impact
```sql
-- More efficient: Select only needed columns
SELECT FirstName, LastName, Email
FROM Employees;

-- Less efficient: Selecting unnecessary large columns
-- SELECT * FROM Employees; -- Includes potentially large binary columns
```

### 2. Function Usage in SELECT
```sql
-- Consider performance impact of functions
SELECT 
    FirstName,
    LastName,
    UPPER(FirstName) AS UpperFirstName,  -- Function applied to each row
    BaseSalary
FROM Employees;

-- Sometimes better to handle formatting in application layer
-- for large result sets
```

### 3. Complex Calculations
```sql
-- For frequently used complex calculations, consider computed columns
-- or views rather than repeating logic in every query

-- Example: This complex calculation in every query
SELECT 
    FirstName,
    LastName,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 AND BaseSalary >= 80000 
             THEN 'Senior High Performer'
        -- ... more complex logic
    END AS PerformanceRating
FROM Employees;

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
