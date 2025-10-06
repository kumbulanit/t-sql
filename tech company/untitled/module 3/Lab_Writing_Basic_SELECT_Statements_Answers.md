# Lab Answers: Writing Basic SELECT Statements

## Exercise 1: Simple SELECT Statements - Answers

### Task 1.1: Basic SELECT Operations - Answers

#### Question 1: Select All Employees
**Task:** Write a query to select all columns from the Employees table.

```sql
-- Answer 1: Select All Employees
SELECT * FROM Employees;
```

#### Question 2: Select Specific Columns
**Task:** Select only FirstName, LastName, and BaseSalary from Employees.

```sql
-- Answer 2: Select Specific Columns
SELECT FirstName, LastName, BaseSalary
FROM Employees;
```

#### Question 3: Select with Calculated Columns
**Task:** Create calculated columns for full name and annual bonus (10% of salary).

```sql
-- Answer 3: Select with Calculated Columns
SELECT 
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName,
    BaseSalary,
    BaseSalary * 0.10 AS AnnualBonus,
    BaseSalary + (BaseSalary * 0.10) AS TotalCompensation
FROM Employees;
```

### Task 1.2: Working with Different Data Types - Answers

#### Question 1: String Manipulations
**Task:** Create queries showing various string operations.

```sql
-- Answer 1: String Manipulations
SELECT 
    FirstName,
    LastName,
    UPPER(FirstName) AS FirstNameUpper,
    LOWER(LastName) AS LastNameLower,
    LEN(FirstName + LastName) AS NameLength,
    LEFT(FirstName, 3) AS FirstThreeChars,
    RIGHT(LastName, 3) AS LastThreeChars,
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS EmailUsername
FROM Employees;
```

#### Question 2: Date Operations
**Task:** Show various date calculations and formatting.

```sql
-- Answer 2: Date Operations
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    HireDate,
    GETDATE() AS CurrentDate,
    DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,
    DATEADD(YEAR, 1, HireDate) AS FirstAnniversary,
    YEAR(HireDate) AS HireYear,
    MONTH(HireDate) AS HireMonth,
    FORMAT(HireDate, 'MMMM dd, yyyy') AS FormattedHireDate
FROM Employees;
```

#### Question 3: Numeric Operations
**Task:** Perform various numeric calculations.

```sql
-- Answer 3: Numeric Operations
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    BaseSalary,
    BaseSalary / 12 AS MonthlySalary,
    BaseSalary / 52 AS WeeklySalary,
    BaseSalary / 2080 AS HourlySalary,
    ROUND(BaseSalary / 12, 2) AS MonthlySalaryRounded,
    CEILING(BaseSalary / 1000) AS SalaryInThousandsCeiling,
    FLOOR(BaseSalary / 1000) AS SalaryInThousandsFloor
FROM Employees;
```

## Exercise 2: Using DISTINCT - Answers

### Task 2.1: Eliminating Duplicates - Answers

#### Question 1: Distinct Departments
**Task:** Get a list of unique department IDs from the Employees table.

```sql
-- Answer 1: Distinct Departments
SELECT DISTINCT DepartmentID
FROM Employees
ORDER BY DepartmentID;
```

#### Question 2: Distinct Cities
**Task:** Get a list of unique cities where employees live.

```sql
-- Answer 2: Distinct Cities
SELECT DISTINCT City
FROM Employees
WHERE City IS NOT NULL
ORDER BY City;
```

#### Question 3: Distinct Job Titles
**Task:** Get a list of unique job titles.

```sql
-- Answer 3: Distinct Job Titles
SELECT DISTINCT Title
FROM Employees
ORDER BY Title;
```

### Task 2.2: DISTINCT with Multiple Columns - Answers

#### Question 1: Distinct City-State Combinations
**Task:** Get unique combinations of city and state.

```sql
-- Answer 1: Distinct City-State Combinations
SELECT DISTINCT City, State
FROM Employees
WHERE City IS NOT NULL AND State IS NOT NULL
ORDER BY State, City;
```

#### Question 2: Distinct Department-Title Combinations
**Task:** Get unique combinations of department and job title.

```sql
-- Answer 2: Distinct Department-Title Combinations
SELECT DISTINCT 
    d.DepartmentName,
    e.Title
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.Title;
```

### Task 2.3: DISTINCT vs GROUP BY - Answers

#### Question 1: Count of Employees by Department
**Task:** Compare DISTINCT with GROUP BY for counting.

```sql
-- Answer 1: Count of Employees by Department

-- Using GROUP BY (preferred for aggregations)
SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID;

-- Using DISTINCT (just for unique values)
SELECT DISTINCT DepartmentID
FROM Employees
ORDER BY DepartmentID;
```

## Exercise 3: Column and Table Aliases - Answers

### Task 3.1: Column Aliases - Answers

#### Question 1: Meaningful Column Names
**Task:** Create meaningful aliases for calculated columns.

```sql
-- Answer 1: Meaningful Column Names
SELECT 
    FirstName AS [First Name],
    LastName AS [Last Name],
    FirstName + ' ' + LastName AS [Full Name],
    BaseSalary AS [Annual BaseSalary],
    BaseSalary / 12 AS [Monthly BaseSalary],
    BaseSalary / 52 AS [Weekly BaseSalary],
    DATEDIFF(YEAR, HireDate, GETDATE()) AS [Years of Service],
    HireDate AS [Date Hired]
FROM Employees;
```

#### Question 2: Aliases with Special Characters
**Task:** Use aliases with spaces and special characters.

```sql
-- Answer 2: Aliases with Special Characters
SELECT 
    FirstName + ' ' + LastName AS "Employee Name",
    BaseSalary AS "Annual BaseSalary ($)",
    CAST(BaseSalary / 12 AS DECIMAL(10,2)) AS "Monthly BaseSalary ($)",
    Title AS "Job Position",
    CASE 
        WHEN BaseSalary > 80000 THEN 'High'
        WHEN BaseSalary > 60000 THEN 'Medium'
        ELSE 'Low'
    END AS "BaseSalary Category"
FROM Employees;
```

### Task 3.2: Table Aliases - Answers

#### Question 1: Simple Table Aliases
**Task:** Use table aliases to simplify queries.

```sql
-- Answer 1: Simple Table Aliases
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    d.Budget
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

#### Question 2: Multiple Table Aliases
**Task:** Use aliases with multiple table joins.

```sql
-- Answer 2: Multiple Table Aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    p.ProjectName,
    ep.Role,
    ep.HoursAllocated,
    ep.HoursWorked
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
ORDER BY e.LastName, e.FirstName, p.ProjectName;
```

### Task 3.3: Self-Join with Aliases - Answers

#### Question 1: Employee-Manager Relationship
**Task:** Show employee and their manager information using self-join.

```sql
-- Answer 1: Employee-Manager Relationship
SELECT 
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    emp.Title AS EmployeeTitle,
    mgr.FirstName + ' ' + mgr.LastName AS ManagerName,
    mgr.Title AS ManagerTitle
FROM Employees emp
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID
ORDER BY mgr.LastName, emp.LastName;
```

## Exercise 4: CASE Expressions - Answers

### Task 4.1: Simple CASE Expressions - Answers

#### Question 1: BaseSalary Categories
**Task:** Categorize employees based on salary ranges.

```sql
-- Answer 1: BaseSalary Categories
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    BaseSalary,
    CASE 
        WHEN BaseSalary >= 90000 THEN 'Executive'
        WHEN BaseSalary >= 70000 THEN 'Senior'
        WHEN BaseSalary >= 50000 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END AS SalaryCategory
FROM Employees
ORDER BY BaseSalary DESC;
```

#### Question 2: Employment Status
**Task:** Show employment status based on termination date.

```sql
-- Answer 2: Employment Status
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    HireDate,
    TerminationDate,
    IsActive,
    CASE 
        WHEN IsActive = 1 AND TerminationDate IS NULL THEN 'Currently Employed'
        WHEN IsActive = 0 AND TerminationDate IS NOT NULL THEN 'Terminated'
        WHEN IsActive = 0 AND TerminationDate IS NULL THEN 'Inactive'
        ELSE 'Status Unknown'
    END AS EmploymentStatus
FROM Employees
ORDER BY EmploymentStatus, LastName;
```

### Task 4.2: CASE with Aggregations - Answers

#### Question 1: Department BaseSalary Analysis
**Task:** Analyze salary distribution by department using CASE.

```sql
-- Answer 1: Department BaseSalary Analysis
SELECT 
    d.DepartmentName,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.BaseSalary >= 80000 THEN 1 ELSE 0 END) AS HighSalaryCount,
    SUM(CASE WHEN e.BaseSalary BETWEEN 50000 AND 79999 THEN 1 ELSE 0 END) AS MidSalaryCount,
    SUM(CASE WHEN e.BaseSalary < 50000 THEN 1 ELSE 0 END) AS LowSalaryCount,
    AVG(e.BaseSalary) AS AverageSalary,
    SUM(CASE WHEN e.BaseSalary >= 80000 THEN e.BaseSalary ELSE 0 END) AS HighSalaryTotal,
    SUM(CASE WHEN e.BaseSalary < 50000 THEN e.BaseSalary ELSE 0 END) AS LowSalaryTotal
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AverageSalary DESC;
```

#### Question 2: Project Status Summary
**Task:** Summarize project statuses using CASE.

```sql
-- Answer 2: Project Status Summary
SELECT 
    COUNT(*) AS TotalProjects,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedProjects,
    SUM(CASE WHEN Status = 'In Progress' THEN 1 ELSE 0 END) AS InProgressProjects,
    SUM(CASE WHEN Status = 'On Hold' THEN 1 ELSE 0 END) AS OnHoldProjects,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledProjects,
    AVG(CASE WHEN Status = 'Completed' THEN Budget ELSE NULL END) AS AvgCompletedBudget,
    AVG(CASE WHEN Status = 'In Progress' THEN Budget ELSE NULL END) AS AvgInProgressBudget
FROM Projects;
```

### Task 4.3: Nested CASE Expressions - Answers

#### Question 1: Complex Employee Classification
**Task:** Create complex employee classifications using nested CASE.

```sql
-- Answer 1: Complex Employee Classification
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    Title,
    BaseSalary,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN
            CASE 
                WHEN BaseSalary >= 90000 THEN 'Senior Executive'
                WHEN BaseSalary >= 70000 THEN 'Senior Professional'
                ELSE 'Senior Staff'
            END
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN
            CASE 
                WHEN BaseSalary >= 80000 THEN 'Mid-Level Executive'
                WHEN BaseSalary >= 60000 THEN 'Mid-Level Professional'
                ELSE 'Mid-Level Staff'
            END
        ELSE
            CASE 
                WHEN BaseSalary >= 70000 THEN 'Junior Executive'
                WHEN BaseSalary >= 50000 THEN 'Junior Professional'
                ELSE 'Junior Staff'
            END
    END AS EmployeeClassification
FROM Employees
WHERE IsActive = 1
ORDER BY YearsOfService DESC, BaseSalary DESC;
```

#### Question 2: Performance Rating
**Task:** Create performance ratings based on multiple criteria.

```sql
-- Answer 2: Performance Rating
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    e.BaseSalary,
    COALESCE(ep.ProjectCount, 0) AS ProjectCount,
    COALESCE(ep.AvgHoursWorked, 0) AS AvgHoursWorked,
    CASE 
        WHEN COALESCE(ep.ProjectCount, 0) = 0 THEN 'No Projects Assigned'
        WHEN COALESCE(ep.ProjectCount, 0) >= 3 AND COALESCE(ep.AvgHoursWorked, 0) >= 40 THEN
            CASE 
                WHEN e.BaseSalary >= 80000 THEN 'Outstanding - High Performer'
                ELSE 'Outstanding - Rising Star'
            END
        WHEN COALESCE(ep.ProjectCount, 0) >= 2 AND COALESCE(ep.AvgHoursWorked, 0) >= 30 THEN 'Exceeds Expectations'
        WHEN COALESCE(ep.ProjectCount, 0) >= 1 AND COALESCE(ep.AvgHoursWorked, 0) >= 20 THEN 'Meets Expectations'
        ELSE 'Below Expectations'
    END AS PerformanceRating
FROM Employees e
LEFT JOIN (
    SELECT 
        EmployeeID,
        COUNT(*) AS ProjectCount,
        AVG(HoursWorked) AS AvgHoursWorked
    FROM EmployeeProjects
    GROUP BY EmployeeID
) ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1
ORDER BY PerformanceRating, e.LastName;
```

## Exercise 5: Advanced SELECT Scenarios - Answers

### Task 5.1: Complex Data Transformation - Answers

#### Question 1: Employee Contact Information Report
**Task:** Create a comprehensive employee report with formatted data.

```sql
-- Answer 1: Employee Contact Information Report
SELECT 
    e.EmployeeID,
    UPPER(e.LastName) + ', ' + e.FirstName + 
    CASE 
        WHEN e.MiddleName IS NOT NULL THEN ' ' + LEFT(e.MiddleName, 1) + '.'
        ELSE ''
    END AS FormattedName,
    e.Email,
    CASE 
        WHEN e.Phone IS NOT NULL THEN 
            '(' + LEFT(e.Phone, 3) + ') ' + SUBSTRING(e.Phone, 4, 3) + '-' + RIGHT(e.Phone, 4)
        ELSE 'No Phone Listed'
    END AS FormattedPhone,
    d.DepartmentName + ' (' + d.DepartmentCode + ')' AS Department,
    e.Title,
    FORMAT(e.BaseSalary, 'C', 'en-US') AS FormattedSalary,
    FORMAT(e.HireDate, 'MMMM dd, yyyy') AS FormattedHireDate,
    CASE 
        WHEN e.City IS NOT NULL AND e.State IS NOT NULL THEN e.City + ', ' + e.State
        WHEN e.City IS NOT NULL THEN e.City
        WHEN e.State IS NOT NULL THEN e.State
        ELSE 'Location Not Specified'
    END AS Location,
    CASE 
        WHEN e.EmergencyContact IS NOT NULL THEN e.EmergencyContact
        ELSE 'No Emergency Contact'
    END AS EmergencyContact
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName, e.FirstName;
```

### Task 5.2: Data Quality Report - Answers

#### Question 1: Employee Data Completeness Analysis
**Task:** Analyze completeness of employee data.

```sql
-- Answer 1: Employee Data Completeness Analysis
SELECT 
    'Total Employees' AS DataField,
    COUNT(*) AS TotalCount,
    COUNT(*) AS CompleteCount,
    0 AS IncompleteCount,
    100.0 AS CompletenessPercentage
FROM Employees
WHERE IsActive = 1

UNION ALL

SELECT 
    'Middle Name',
    COUNT(*),
    SUM(CASE WHEN MiddleName IS NOT NULL AND MiddleName != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN MiddleName IS NULL OR MiddleName = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN MiddleName IS NOT NULL AND MiddleName != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees
WHERE IsActive = 1

UNION ALL

SELECT 
    'Phone Number',
    COUNT(*),
    SUM(CASE WHEN Phone IS NOT NULL AND Phone != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN Phone IS NOT NULL AND Phone != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees
WHERE IsActive = 1

UNION ALL

SELECT 
    'City',
    COUNT(*),
    SUM(CASE WHEN City IS NOT NULL AND City != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN City IS NOT NULL AND City != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees
WHERE IsActive = 1

UNION ALL

SELECT 
    'Emergency Contact',
    COUNT(*),
    SUM(CASE WHEN EmergencyContact IS NOT NULL AND EmergencyContact != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN EmergencyContact IS NULL OR EmergencyContact = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN EmergencyContact IS NOT NULL AND EmergencyContact != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees
WHERE IsActive = 1

ORDER BY CompletenessPercentage DESC;
```

### Task 5.3: Executive Summary Report - Answers

#### Question 1: Department Summary Dashboard
**Task:** Create an executive summary of department performance.

```sql
-- Answer 1: Department Summary Dashboard
SELECT 
    d.DepartmentName AS Department,
    d.DepartmentCode AS [Dept Code],
    COUNT(e.EmployeeID) AS [Active Employees],
    FORMAT(AVG(e.BaseSalary), 'C0', 'en-US') AS [Avg BaseSalary],
    FORMAT(SUM(e.BaseSalary), 'C0', 'en-US') AS [Total Payroll],
    FORMAT(d.Budget, 'C0', 'en-US') AS [Dept Budget],
    FORMAT(d.Budget - SUM(e.BaseSalary), 'C0', 'en-US') AS [Budget Remaining],
    CAST(((d.Budget - SUM(e.BaseSalary)) * 100.0 / d.Budget) AS DECIMAL(5,1)) AS [Budget % Remaining],
    CASE 
        WHEN SUM(e.BaseSalary) > d.Budget THEN 'OVER BUDGET'
        WHEN SUM(e.BaseSalary) > d.Budget * 0.95 THEN 'CRITICAL'
        WHEN SUM(e.BaseSalary) > d.Budget * 0.85 THEN 'WARNING'
        ELSE 'GOOD'
    END AS [Budget Status],
    COALESCE(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS [Department Manager],
    d.Location AS [Office Location],
    CASE 
        WHEN COUNT(e.EmployeeID) > 10 THEN 'Large'
        WHEN COUNT(e.EmployeeID) > 5 THEN 'Medium'
        ELSE 'Small'
    END AS [Department Size]
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
LEFT JOIN Employees mgr ON d.ManagerID = mgr.EmployeeID
GROUP BY 
    d.DepartmentID, d.DepartmentName, d.DepartmentCode, d.Budget, 
    d.Location, mgr.FirstName, mgr.LastName
ORDER BY SUM(e.BaseSalary) DESC;
```

## Key Learning Points Summary

### SELECT Statement Components
1. **Basic Structure**: SELECT, FROM, WHERE, ORDER BY clauses
2. **Column Selection**: Specific columns vs. SELECT *
3. **Calculated Columns**: Arithmetic operations, string concatenation
4. **Data Type Handling**: Implicit and explicit conversions

### DISTINCT Usage
1. **Duplicate Elimination**: DISTINCT keyword removes duplicate rows
2. **Multiple Columns**: DISTINCT applies to the entire row combination
3. **Performance Considerations**: DISTINCT requires sorting/grouping operations
4. **Alternative Approaches**: GROUP BY for aggregated distinct values

### Aliases Best Practices
1. **Column Aliases**: Use AS keyword for clarity, brackets for spaces
2. **Table Aliases**: Simplify complex queries, required for self-joins
3. **Meaningful Names**: Choose descriptive aliases for better readability
4. **Consistency**: Use consistent naming conventions throughout queries

### CASE Expression Mastery
1. **Simple CASE**: Direct value comparisons
2. **Searched CASE**: Complex conditional logic with WHEN clauses
3. **Nested CASE**: Multiple levels of conditional logic
4. **Aggregation Integration**: CASE expressions within aggregate functions
5. **NULL Handling**: Explicit NULL checks in CASE conditions

### Advanced Techniques Applied
1. **Data Formatting**: FORMAT, CAST, CONVERT functions
2. **String Manipulation**: SUBSTRING, CHARINDEX, LEFT, RIGHT functions
3. **Date Calculations**: DATEDIFF, DATEADD, date formatting
4. **Conditional Aggregation**: SUM/COUNT with CASE expressions
5. **Data Quality Analysis**: Completeness and validation checks