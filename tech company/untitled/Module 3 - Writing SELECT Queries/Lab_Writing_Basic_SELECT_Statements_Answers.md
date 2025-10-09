# Lab Answers: Writing Basic SELECT Statements

## Exercise 1: Simple SELECT Statements - Answers

### Task 1.1: Basic SELECT Operations - Answers

#### Question 1: Select All Employees
**Task:** Write a query to select all columns from the Employees table.

```sql
-- Answer 1: Select All Employees
SELECT * FROM Employees e;
```

**Beginner Explanation:**
- `SELECT *` means "select ALL columns" (the asterisk * is a wildcard)
- `FROM Employees e` specifies which table to get data from
- This returns every row and every column in the Employees table
- **Tip:** Use SELECT * carefully - it can return a lot of data!

**Expected Result:** All employee records with columns like EmployeeID, FirstName, LastName, JobTitle, BaseSalary, HireDate, etc.

#### Question 2: Select Specific Columns
**Task:** Select only FirstName, LastName, and BaseSalary FROM Employees e.

```sql
-- Answer 2: Select Specific Columns
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e;
```

**Beginner Explanation:**
- Instead of *, we list specific column names separated by commas
- This gives us only the columns we need, making results cleaner and faster
- Column order in SELECT determines display order
- **Best Practice:** Only select columns you actually need

**Expected Result:** A focused list showing just employee names and their salaries

#### Question 3: Select with Calculated Columns
**Task:** Create calculated columns for full name and annual bonus (10% of BaseSalary).

```sql
-- Answer 3: Select with Calculated Columns
SELECT 
    e.FirstName,
    e.LastName,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.BaseSalary,
    e.BaseSalary * 0.10 AS AnnualBonus,
    e.BaseSalary + (e.BaseSalary * 0.10) AS TotalCompensation
FROM Employees e;
```

**Beginner Explanation:**

- **String Concatenation:** `FirstName + ' ' + LastName` combines two text columns with a space
- **Mathematical Operations:** `BaseSalary * 0.10` multiplies BaseSalary by 10% (0.10 = 10%)
- **Column Aliases:** `AS FullName` gives our calculated column a friendly name
- **Parentheses:** Use `()` to control order of operations, just like in math
- **Multiple Calculations:** You can create several calculated columns in one query

**Step-by-Step Breakdown:**
1. Show original FirstName and LastName
2. Combine them into FullName
3. Show the original BaseSalary
4. Calculate 10% bonus
5. Calculate total compensation (BaseSalary + bonus)

**Expected Result:** Each employee with their name, BaseSalary, bonus amount, and total compensation

### Task 1.2: Working with Different Data Types - Answers

#### Question 1: String Manipulations
**Task:** Create queries showing various string operations.

```sql
-- Answer 1: String Manipulations
SELECT 
    e.FirstName,
    e.LastName,
    UPPER(e.FirstName) AS FirstNameUpper,
    LOWER(e.LastName) AS LastNameLower,
    LEN(e.FirstName + e.LastName) AS NameLength,
    LEFT(e.FirstName, 3) AS FirstThreeChars,
    RIGHT(e.LastName, 3) AS LastThreeChars,
    SUBSTRING(WorkEmail, 1, CHARINDEX('@', WorkEmail) - 1) AS EmailUsername
FROM Employees e;
```

#### Question 2: Date Operations
**Task:** Show various date calculations and formatting.

```sql
-- Answer 2: Date Operations
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate,
    GETDATE() AS CurrentDate,
    DATEDIFF(DAY, e.HireDate, GETDATE()) AS DaysEmployed,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed,
    DATEADD(YEAR, 1, e.HireDate) AS FirstAnniversary,
    YEAR(e.HireDate) AS HireYear,
    MONTH(e.HireDate) AS HireMonth,
    FORMAT(e.HireDate, 'MMMM dd, yyyy') AS FormattedHireDate
FROM Employees e;
```

#### Question 3: Numeric Operations
**Task:** Perform various numeric calculations.

```sql
-- Answer 3: Numeric Operations
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    e.BaseSalary / 12 AS MonthlySalary,
    e.BaseSalary / 52 AS WeeklySalary,
    e.BaseSalary / 2080 AS HourlySalary,
    ROUND(e.BaseSalary / 12, 2) AS MonthlySalaryRounded,
    CEILING(e.BaseSalary / 1000) AS SalaryInThousandsCeiling,
    FLOOR(e.BaseSalary / 1000) AS SalaryInThousandsFloor
FROM Employees e;
```

## Exercise 2: Using DISTINCT - Answers

### Task 2.1: Eliminating Duplicates - Answers

#### Question 1: Distinct Departments
**Task:** Get a list of unique d.DepartmentName IDs from the Employees table.

```sql
-- Answer 1: Distinct Departments
SELECT DISTINCT d.DepartmentID
FROM Employees e
ORDER BY DepartmentIDID;
```

#### Question 2: Distinct Cities
**Task:** Get a list of unique cities where employees live.

```sql
-- Answer 2: Distinct Cities
SELECT DISTINCT City
FROM Employees e
WHERE City IS NOT NULL
ORDER BY City;
```

#### Question 3: Distinct Job Titles
**Task:** Get a list of unique job titles.

```sql
-- Answer 3: Distinct Job Titles
SELECT DISTINCT Title
FROM Employees e
ORDER BY Title;
```

### Task 2.2: DISTINCT with Multiple Columns - Answers

#### Question 1: Distinct City-State Combinations
**Task:** Get unique combinations of city and state.

```sql
-- Answer 1: Distinct City-State Combinations
SELECT DISTINCT City, State
FROM Employees e
WHERE City IS NOT NULL AND State IS NOT NULL
ORDER BY State, City;
```

#### Question 2: Distinct Department-Title Combinations
**Task:** Get unique combinations of d.DepartmentName and job title.

```sql
-- Answer 2: Distinct Department-Title Combinations
SELECT DISTINCT 
    d.DepartmentName,
    e.JobTitle
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.JobTitle;
```

### Task 2.3: DISTINCT vs GROUP BY - Answers

#### Question 1: Count of Employees by d.DepartmentName
**Task:** Compare DISTINCT with GROUP BY for counting.

```sql
-- Answer 1: Count of Employees by d.DepartmentName

-- Using GROUP BY (preferred for aggregations)
SELECT 
    d.DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY DepartmentIDID
ORDER BY DepartmentIDID;

-- Using DISTINCT (just for unique values)
SELECT DISTINCT d.DepartmentID
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY DepartmentIDID;
```

## Exercise 3: Column and Table Aliases - Answers

### Task 3.1: Column Aliases - Answers

#### Question 1: Meaningful Column Names
**Task:** Create meaningful aliases for calculated columns.

```sql
-- Answer 1: Meaningful Column Names
SELECT 
    e.FirstName AS [First Name],
    e.LastName AS [Last Name],
    e.FirstName + ' ' + e.LastName AS [Full Name],
    e.BaseSalary AS [Annual e.BaseSalary],
    e.BaseSalary / 12 AS [Monthly e.BaseSalary],
    e.BaseSalary / 52 AS [Weekly e.BaseSalary],
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS [Years of Service],
    e.HireDate AS [Date Hired]
FROM Employees e;
```

#### Question 2: Aliases with Special Characters
**Task:** Use aliases with spaces and special characters.

```sql
-- Answer 2: Aliases with Special Characters
SELECT 
    e.FirstName + ' ' + e.LastName AS "Employee Name",
    e.BaseSalary AS "Annual e.BaseSalary ($)",
    CAST(e.BaseSalary / 12 AS DECIMAL(10,2)) AS "Monthly e.BaseSalary ($)",
    Title AS "Job Position",
    CASE 
        WHEN e.BaseSalary > 80000 THEN 'High'
        WHEN e.BaseSalary > 60000 THEN 'Medium'
        ELSE 'Low'
    END AS "e.BaseSalary Category"
FROM Employees e;
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
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID;
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
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
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
    mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,
    mgr.Title AS ManagerTitle
FROM Employees e emp
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.e.EmployeeID
ORDER BY mgr.e.LastName, emp.LastName;
```

## Exercise 4: CASE Expressions - Answers

### Task 4.1: Simple CASE Expressions - Answers

#### Question 1: BaseSalary Categories
**Task:** Categorize employees based on BaseSalary ranges.

```sql
-- Answer 1: e.BaseSalary Categories
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary >= 90000 THEN 'Executive'
        WHEN e.BaseSalary >= 70000 THEN 'Senior'
        WHEN e.BaseSalary >= 50000 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END AS SalaryCategory
FROM Employees e
ORDER BY e.BaseSalary DESC;
```

#### Question 2: Employment IsActive
**Task:** Show employment status based on termination date.

```sql
-- Answer 2: Employment IsActive
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate,
    TerminationDate,
    IsActive,
    CASE 
        WHEN IsActive = 1 AND TerminationDate IS NULL THEN 'Currently Employed'
        WHEN IsActive = 0 AND TerminationDate IS NOT NULL THEN 'Terminated'
        WHEN IsActive = 0 AND TerminationDate IS NULL THEN 'Inactive'
        ELSE 'IsActive Unknown'
    END AS EmploymentIsActive
FROM Employees e
ORDER BY EmploymentIsActive, e.LastName;
```

### Task 4.2: CASE with Aggregations - Answers

#### Question 1: d.DepartmentName BaseSalary Analysis
**Task:** Analyze BaseSalary distribution by d.DepartmentName using CASE.

```sql
-- Answer 1: d.DepartmentName e.BaseSalary Analysis
SELECT d.DepartmentName,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.BaseSalary >= 80000 THEN 1 ELSE 0 END) AS HighSalaryCount,
    SUM(CASE WHEN e.BaseSalary BETWEEN 50000 AND 79999 THEN 1 ELSE 0 END) AS MidSalaryCount,
    SUM(CASE WHEN e.BaseSalary < 50000 THEN 1 ELSE 0 END) AS LowSalaryCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    SUM(CASE WHEN e.BaseSalary >= 80000 THEN e.BaseSalary ELSE 0 END) AS HighSalaryTotal,
    SUM(CASE WHEN e.BaseSalary < 50000 THEN e.BaseSalary ELSE 0 END) AS LowSalaryTotal
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AverageSalary DESC;
```

#### Question 2: Project IsActive Summary
**Task:** Summarize project statuses using CASE.

```sql
-- Answer 2: Project Status Summary
SELECT 
    COUNT(*) AS TotalProjects,
    SUM(CASE WHEN IsActive = 'Completed' THEN 1 ELSE 0 END) AS CompletedProjects,
    SUM(CASE WHEN IsActive = 'In Progress' THEN 1 ELSE 0 END) AS InProgressProjects,
    SUM(CASE WHEN IsActive = 'On Hold' THEN 1 ELSE 0 END) AS OnHoldProjects,
    SUM(CASE WHEN IsActive = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledProjects,
    AVG(CASE WHEN IsActive = 'Completed' THEN d.Budget ELSE NULL END) AS AvgCompletedBudget,
    AVG(CASE WHEN IsActive = 'In Progress' THEN d.Budget ELSE NULL END) AS AvgInProgressBudget
FROM Projects p;
```

### Task 4.3: Nested CASE Expressions - Answers

#### Question 1: Complex Employee Classification
**Task:** Create complex employee classifications using nested CASE.

```sql
-- Answer 1: Complex Employee Classification
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    Title,
    e.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN
            CASE 
                WHEN e.BaseSalary >= 90000 THEN 'Senior Executive'
                WHEN e.BaseSalary >= 70000 THEN 'Senior Professional'
                ELSE 'Senior Staff'
            END
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN
            CASE 
                WHEN e.BaseSalary >= 80000 THEN 'Mid-Level Executive'
                WHEN e.BaseSalary >= 60000 THEN 'Mid-Level Professional'
                ELSE 'Mid-Level Staff'
            END
        ELSE
            CASE 
                WHEN e.BaseSalary >= 70000 THEN 'Junior Executive'
                WHEN e.BaseSalary >= 50000 THEN 'Junior Professional'
                ELSE 'Junior Staff'
            END
    END AS EmployeeClassification
FROM Employees e
WHERE IsActive = 1
ORDER BY YearsOfService DESC, e.BaseSalary DESC;
```

#### Question 2: Performance Rating
**Task:** Create performance ratings based on multiple criteria.

```sql
-- Answer 2: Performance Rating
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
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
        e.EmployeeID,
        COUNT(*) AS ProjectCount,
        AVG(HoursWorked) AS AvgHoursWorked
    FROM EmployeeProjects
    GROUP BY e.EmployeeID
) ep ON e.EmployeeID = ep.e.EmployeeID
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
    e.WorkEmail,
    CASE 
        WHEN e.Phone IS NOT NULL THEN 
            '(' + LEFT(e.Phone, 3) + ') ' + SUBSTRING(e.Phone, 4, 3) + '-' + RIGHT(e.Phone, 4)
        ELSE 'No Phone Listed'
    END AS FormattedPhone,
    d.DepartmentName + ' (' + d.DepartmentCode + ')' AS d.DepartmentName,
    e.JobTitle,
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
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
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
FROM Employees e
WHERE IsActive = 1

UNION ALL

SELECT 
    'Middle Name',
    COUNT(*),
    SUM(CASE WHEN MiddleName IS NOT NULL AND MiddleName != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN MiddleName IS NULL OR MiddleName = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN MiddleName IS NOT NULL AND MiddleName != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees e
WHERE IsActive = 1

UNION ALL

SELECT 
    'Phone Number',
    COUNT(*),
    SUM(CASE WHEN Phone IS NOT NULL AND Phone != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN Phone IS NOT NULL AND Phone != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees e
WHERE IsActive = 1

UNION ALL

SELECT 
    'City',
    COUNT(*),
    SUM(CASE WHEN City IS NOT NULL AND City != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN City IS NOT NULL AND City != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees e
WHERE IsActive = 1

UNION ALL

SELECT 
    'Emergency Contact',
    COUNT(*),
    SUM(CASE WHEN EmergencyContact IS NOT NULL AND EmergencyContact != '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN EmergencyContact IS NULL OR EmergencyContact = '' THEN 1 ELSE 0 END),
    (SUM(CASE WHEN EmergencyContact IS NOT NULL AND EmergencyContact != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
FROM Employees e
WHERE IsActive = 1

ORDER BY CompletenessPercentage DESC;
```

### Task 5.3: Executive Summary Report - Answers

#### Question 1: d.DepartmentName Summary Dashboard
**Task:** Create an executive summary of d.DepartmentName performance.

```sql
-- Answer 1: d.DepartmentName Summary Dashboard
SELECT d.DepartmentName AS d.DepartmentName,
    d.DepartmentCode AS [Dept Code],
    COUNT(e.EmployeeID) AS [Active Employees],
    FORMAT(AVG(e.BaseSalary), 'C0', 'en-US') AS [Avg BaseSalary],
    FORMAT(SUM(e.BaseSalary), 'C0', 'en-US') AS [Total Payroll],
    FORMAT(d.Budget, 'C0', 'en-US') AS [Dept d.Budget],
    FORMAT(d.Budget - SUM(e.BaseSalary), 'C0', 'en-US') AS [d.Budget Remaining],
    CAST(((d.Budget - SUM(e.BaseSalary)) * 100.0 / d.Budget) AS DECIMAL(5,1)) AS [d.Budget % Remaining],
    CASE 
        WHEN SUM(e.BaseSalary) > d.Budget THEN 'OVER BUDGET'
        WHEN SUM(e.BaseSalary) > d.Budget * 0.95 THEN 'CRITICAL'
        WHEN SUM(e.BaseSalary) > d.Budget * 0.85 THEN 'WARNING'
        ELSE 'GOOD'
    END AS [d.Budget IsActive],
    COALESCE(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS [Department Manager],
    d.Location AS [Office Location],
    CASE 
        WHEN COUNT(e.EmployeeID) > 10 THEN 'Large'
        WHEN COUNT(e.EmployeeID) > 5 THEN 'Medium'
        ELSE 'Small'
    END AS [Department Size]
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID AND e.IsActive = 1
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