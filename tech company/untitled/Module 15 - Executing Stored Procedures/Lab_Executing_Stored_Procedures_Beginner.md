# Lab: Executing Stored Procedures - Beginner Lab

## 🎯 Lab Overview

Welcome to the hands-on lab for Module 15! In this lab, you'll practice:
- Running (executing) stored procedures
- Passing parameters to procedures
- Creating your own stored procedures
- Working with OUTPUT parameters
- Basic dynamic SQL

**Estimated Time:** 60-75 minutes

---

## 📋 Prerequisites

Before starting this lab, you should:
- Have access to the TechCorpDB database
- Understand basic SELECT, JOIN, and WHERE clauses
- Have completed the lessons in this module

---

## 🗃️ Lab Setup

Run this setup script to create sample stored procedures for practice:

```sql
-- ============================================
-- LAB SETUP: Creating Sample Stored Procedures
-- ============================================

USE TechCorpDB;
GO

-- Procedure 1: Get all active employees (no parameters)
CREATE OR ALTER PROCEDURE usp_GetActiveEmployees
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    ORDER BY e.LastName, e.FirstName;
END;
GO

-- Procedure 2: Get employees by department (one parameter)
CREATE OR ALTER PROCEDURE usp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary
    FROM Employees e
    WHERE e.DepartmentID = @DepartmentID
      AND e.IsActive = 1
    ORDER BY e.BaseSalary DESC;
END;
GO

-- Procedure 3: Get top earners (parameter with default)
CREATE OR ALTER PROCEDURE usp_GetTopEarners
    @TopCount INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    ORDER BY e.BaseSalary DESC;
END;
GO

-- Procedure 4: Get department count (OUTPUT parameter)
CREATE OR ALTER PROCEDURE usp_GetDepartmentEmployeeCount
    @DepartmentID INT,
    @EmployeeCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT @EmployeeCount = COUNT(*)
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Procedure 5: Search employees (multiple parameters)
CREATE OR ALTER PROCEDURE usp_SearchEmployees
    @SearchTerm VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL,
    @MaxSalary DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND (@SearchTerm IS NULL 
           OR e.FirstName LIKE '%' + @SearchTerm + '%'
           OR e.LastName LIKE '%' + @SearchTerm + '%')
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
      AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary)
      AND (@MaxSalary IS NULL OR e.BaseSalary <= @MaxSalary)
    ORDER BY e.LastName, e.FirstName;
END;
GO

PRINT 'Lab setup complete! Sample procedures created.';
GO
```

---

## 📝 Part 1: Running Stored Procedures

### Exercise 1.1: Run a Simple Procedure (Easy)

**Goal:** Execute a stored procedure with no parameters.

**Task:** Run the `usp_GetActiveEmployees` procedure.

**Your Code:**
```sql
-- Run the procedure
_________;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
EXEC usp_GetActiveEmployees;
```

</details>

---

### Exercise 1.2: Using System Procedures (Easy)

**Goal:** Use built-in system procedures to explore the database.

**Tasks:**
1. View information about the Employees table
2. List all columns in the Departments table
3. View the code of `usp_GetActiveEmployees`

**Your Code:**
```sql
-- Task 1: Information about Employees table
EXEC sp_help '_________';

-- Task 2: Columns in Departments table
EXEC sp_columns '_________';

-- Task 3: View procedure code
EXEC sp_helptext '_________';
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Task 1: Information about Employees table
EXEC sp_help 'Employees';

-- Task 2: Columns in Departments table
EXEC sp_columns 'Departments';

-- Task 3: View procedure code
EXEC sp_helptext 'usp_GetActiveEmployees';
```

</details>

---

### Exercise 1.3: List All Stored Procedures (Easy)

**Goal:** Find all user-created stored procedures in the database.

**Your Code:**
```sql
SELECT 
    name AS ProcedureName,
    create_date AS Created,
    modify_date AS LastModified
FROM sys._________
WHERE type = 'P'
ORDER BY name;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    name AS ProcedureName,
    create_date AS Created,
    modify_date AS LastModified
FROM sys.procedures
WHERE type = 'P'
ORDER BY name;
```

</details>

---

## 📝 Part 2: Passing Parameters

### Exercise 2.1: Single Parameter (Easy)

**Goal:** Call a procedure with one parameter.

**Tasks:** Get employees from different departments:
1. Department 2001 (Engineering)
2. Department 2002 (Marketing)
3. Department 2003 (HR)

**Your Code:**
```sql
-- Engineering employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = _____;

-- Marketing employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = _____;

-- HR employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = _____;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Engineering employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = 2001;

-- Marketing employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = 2002;

-- HR employees
EXEC usp_GetEmployeesByDepartment @DepartmentID = 2003;
```

</details>

---

### Exercise 2.2: Default Parameters (Medium)

**Goal:** Understand how default parameters work.

**Tasks:**
1. Call `usp_GetTopEarners` without any parameter (uses default)
2. Call it with @TopCount = 5
3. Call it with @TopCount = 20

**Your Code:**
```sql
-- Use default (top 10)
EXEC usp_GetTopEarners;

-- Top 5
EXEC usp_GetTopEarners @TopCount = _____;

-- Top 20
EXEC usp_GetTopEarners @TopCount = _____;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Use default (top 10)
EXEC usp_GetTopEarners;

-- Top 5
EXEC usp_GetTopEarners @TopCount = 5;

-- Top 20
EXEC usp_GetTopEarners @TopCount = 20;
```

</details>

---

### Exercise 2.3: Multiple Parameters (Medium)

**Goal:** Use a procedure with multiple optional parameters.

**Tasks:** Use `usp_SearchEmployees` with different combinations:
1. Search for employees with "John" in their name
2. Get employees from department 2001 with salary > $70,000
3. Get employees with salary between $50,000 and $80,000

**Your Code:**
```sql
-- Task 1: Search by name
EXEC usp_SearchEmployees @SearchTerm = '_____';

-- Task 2: Department and minimum salary
EXEC usp_SearchEmployees 
    @DepartmentID = _____, 
    @MinSalary = _____;

-- Task 3: Salary range
EXEC usp_SearchEmployees 
    @MinSalary = _____, 
    @MaxSalary = _____;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Task 1: Search by name
EXEC usp_SearchEmployees @SearchTerm = 'John';

-- Task 2: Department and minimum salary
EXEC usp_SearchEmployees 
    @DepartmentID = 2001, 
    @MinSalary = 70000;

-- Task 3: Salary range
EXEC usp_SearchEmployees 
    @MinSalary = 50000, 
    @MaxSalary = 80000;
```

</details>

---

### Exercise 2.4: Using Variables as Parameters (Medium)

**Goal:** Pass variable values to a procedure.

**Task:** Use variables to call `usp_GetEmployeesByDepartment`.

**Your Code:**
```sql
-- Declare and set a variable
DECLARE @MyDept INT;
SET @MyDept = 2001;

-- Use the variable as a parameter
EXEC usp_GetEmployeesByDepartment @DepartmentID = _____;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Declare and set a variable
DECLARE @MyDept INT;
SET @MyDept = 2001;

-- Use the variable as a parameter
EXEC usp_GetEmployeesByDepartment @DepartmentID = @MyDept;
```

</details>

---

### Exercise 2.5: OUTPUT Parameters (Hard)

**Goal:** Capture output from a procedure.

**Task:** Use `usp_GetDepartmentEmployeeCount` to get employee counts for departments.

**Your Code:**
```sql
-- Declare output variable
DECLARE @Count INT;

-- Get count for Engineering (2001)
EXEC usp_GetDepartmentEmployeeCount 
    @DepartmentID = 2001, 
    @EmployeeCount = @Count ________;

-- Display result
SELECT 'Engineering' AS Department, @Count AS EmployeeCount;

-- Get count for Marketing (2002)
EXEC usp_GetDepartmentEmployeeCount 
    @DepartmentID = 2002, 
    @EmployeeCount = @Count ________;

SELECT 'Marketing' AS Department, @Count AS EmployeeCount;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Declare output variable
DECLARE @Count INT;

-- Get count for Engineering (2001)
EXEC usp_GetDepartmentEmployeeCount 
    @DepartmentID = 2001, 
    @EmployeeCount = @Count OUTPUT;

-- Display result
SELECT 'Engineering' AS Department, @Count AS EmployeeCount;

-- Get count for Marketing (2002)
EXEC usp_GetDepartmentEmployeeCount 
    @DepartmentID = 2002, 
    @EmployeeCount = @Count OUTPUT;

SELECT 'Marketing' AS Department, @Count AS EmployeeCount;
```

</details>

---

## 📝 Part 3: Creating Stored Procedures

### Exercise 3.1: Create a Simple Procedure (Easy)

**Goal:** Create your first stored procedure.

**Task:** Create a procedure called `usp_GetAllDepartments` that returns all active departments.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetAllDepartments
AS
BEGIN
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget
    FROM _________
    WHERE _________ = 1
    ORDER BY DepartmentName;
END;
GO

-- Test it
EXEC usp_GetAllDepartments;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetAllDepartments
AS
BEGIN
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget
    FROM Departments
    WHERE IsActive = 1
    ORDER BY DepartmentName;
END;
GO

-- Test it
EXEC usp_GetAllDepartments;
```

</details>

---

### Exercise 3.2: Procedure with One Parameter (Medium)

**Goal:** Create a procedure with an input parameter.

**Task:** Create `usp_GetEmployeesHiredAfter` that accepts a date and returns employees hired after that date.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetEmployeesHiredAfter
    @HireDate ________
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        HireDate
    FROM Employees
    WHERE HireDate >= @_________
      AND IsActive = 1
    ORDER BY HireDate;
END;
GO

-- Test: Employees hired after January 1, 2023
EXEC usp_GetEmployeesHiredAfter @HireDate = '2023-01-01';
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetEmployeesHiredAfter
    @HireDate DATE
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        HireDate
    FROM Employees
    WHERE HireDate >= @HireDate
      AND IsActive = 1
    ORDER BY HireDate;
END;
GO

-- Test: Employees hired after January 1, 2023
EXEC usp_GetEmployeesHiredAfter @HireDate = '2023-01-01';
```

</details>

---

### Exercise 3.3: Procedure with Default Parameter (Medium)

**Goal:** Create a procedure with a default parameter value.

**Task:** Create `usp_GetRecentHires` that defaults to showing hires from the last 365 days.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetRecentHires
    @DaysBack INT = _____
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        HireDate,
        DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed
    FROM Employees
    WHERE HireDate >= DATEADD(DAY, -@DaysBack, GETDATE())
      AND IsActive = 1
    ORDER BY HireDate DESC;
END;
GO

-- Test with default (last 365 days)
EXEC usp_GetRecentHires;

-- Test with custom value (last 90 days)
EXEC usp_GetRecentHires @DaysBack = 90;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetRecentHires
    @DaysBack INT = 365
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        HireDate,
        DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed
    FROM Employees
    WHERE HireDate >= DATEADD(DAY, -@DaysBack, GETDATE())
      AND IsActive = 1
    ORDER BY HireDate DESC;
END;
GO

-- Test with default (last 365 days)
EXEC usp_GetRecentHires;

-- Test with custom value (last 90 days)
EXEC usp_GetRecentHires @DaysBack = 90;
```

</details>

---

### Exercise 3.4: Procedure with OUTPUT Parameter (Hard)

**Goal:** Create a procedure that returns values through OUTPUT parameters.

**Task:** Create `usp_GetDepartmentStats` that returns employee count, total salary, and average salary.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetDepartmentStats
    @DepartmentID INT,
    @EmpCount INT _________,
    @TotalSalary DECIMAL(15,2) _________,
    @AvgSalary DECIMAL(10,2) _________
AS
BEGIN
    SELECT 
        @EmpCount = COUNT(*),
        @TotalSalary = SUM(BaseSalary),
        @AvgSalary = AVG(BaseSalary)
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Test it
DECLARE @Count INT, @Total DECIMAL(15,2), @Avg DECIMAL(10,2);

EXEC usp_GetDepartmentStats 
    @DepartmentID = 2001,
    @EmpCount = @Count OUTPUT,
    @TotalSalary = @Total OUTPUT,
    @AvgSalary = @Avg OUTPUT;

SELECT 
    'Engineering' AS Department,
    @Count AS EmployeeCount,
    @Total AS TotalSalaries,
    @Avg AS AverageSalary;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetDepartmentStats
    @DepartmentID INT,
    @EmpCount INT OUTPUT,
    @TotalSalary DECIMAL(15,2) OUTPUT,
    @AvgSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT 
        @EmpCount = COUNT(*),
        @TotalSalary = SUM(BaseSalary),
        @AvgSalary = AVG(BaseSalary)
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Test it
DECLARE @Count INT, @Total DECIMAL(15,2), @Avg DECIMAL(10,2);

EXEC usp_GetDepartmentStats 
    @DepartmentID = 2001,
    @EmpCount = @Count OUTPUT,
    @TotalSalary = @Total OUTPUT,
    @AvgSalary = @Avg OUTPUT;

SELECT 
    'Engineering' AS Department,
    @Count AS EmployeeCount,
    @Total AS TotalSalaries,
    @Avg AS AverageSalary;
```

</details>

---

### Exercise 3.5: Procedure with Multiple Result Sets (Hard)

**Goal:** Create a procedure that returns multiple result sets.

**Task:** Create `usp_GetDepartmentReport` that returns department info AND employee list.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetDepartmentReport
    @DepartmentID INT
AS
BEGIN
    -- First result set: Department info
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget
    FROM Departments
    WHERE DepartmentID = @DepartmentID;
    
    -- Second result set: Employee list
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        BaseSalary
    FROM _________
    WHERE DepartmentID = @_________
      AND IsActive = 1
    ORDER BY LastName;
    
    -- Third result set: Summary
    SELECT 
        COUNT(*) AS TotalEmployees,
        SUM(BaseSalary) AS TotalSalaries,
        AVG(BaseSalary) AS AverageSalary
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Test it
EXEC usp_GetDepartmentReport @DepartmentID = 2001;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetDepartmentReport
    @DepartmentID INT
AS
BEGIN
    -- First result set: Department info
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget
    FROM Departments
    WHERE DepartmentID = @DepartmentID;
    
    -- Second result set: Employee list
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        BaseSalary
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1
    ORDER BY LastName;
    
    -- Third result set: Summary
    SELECT 
        COUNT(*) AS TotalEmployees,
        SUM(BaseSalary) AS TotalSalaries,
        AVG(BaseSalary) AS AverageSalary
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Test it
EXEC usp_GetDepartmentReport @DepartmentID = 2001;
```

</details>

---

## 📝 Part 4: Dynamic SQL (Advanced)

### Exercise 4.1: Basic Dynamic SQL (Medium)

**Goal:** Execute a simple dynamic query.

**Task:** Build and execute a dynamic SELECT statement.

**Your Code:**
```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @TableName NVARCHAR(128) = 'Employees';

SET @SQL = N'SELECT TOP 5 * FROM ' + QUOTENAME(@_________);

-- Debug - see the query
PRINT @SQL;

-- Execute
EXEC sp_executesql @SQL;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @TableName NVARCHAR(128) = 'Employees';

SET @SQL = N'SELECT TOP 5 * FROM ' + QUOTENAME(@TableName);

-- Debug - see the query
PRINT @SQL;

-- Execute
EXEC sp_executesql @SQL;
```

</details>

---

### Exercise 4.2: Parameterized Dynamic SQL (Hard)

**Goal:** Use parameters safely in dynamic SQL.

**Task:** Create a dynamic query with a parameterized WHERE clause.

**Your Code:**
```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DeptID INT = 2001;

SET @SQL = N'
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE DepartmentID = @pDept
  AND IsActive = 1';

EXEC sp_executesql 
    @SQL,
    N'@pDept _____',
    @pDept = @________;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DeptID INT = 2001;

SET @SQL = N'
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE DepartmentID = @pDept
  AND IsActive = 1';

EXEC sp_executesql 
    @SQL,
    N'@pDept INT',
    @pDept = @DeptID;
```

</details>

---

### Exercise 4.3: Dynamic Sort Order (Hard)

**Goal:** Create a procedure with dynamic sorting.

**Task:** Create `usp_GetEmployeesSorted` with dynamic ORDER BY.

**Your Code:**
```sql
CREATE OR ALTER PROCEDURE usp_GetEmployeesSorted
    @SortColumn VARCHAR(50) = 'LastName',
    @SortDirection VARCHAR(4) = 'ASC'
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Validate sort column (whitelist!)
    IF @SortColumn NOT IN ('FirstName', 'LastName', 'JobTitle', 'BaseSalary', 'HireDate')
        SET @SortColumn = 'LastName';
    
    -- Validate direction
    IF @SortDirection NOT IN ('ASC', 'DESC')
        SET @SortDirection = 'ASC';
    
    SET @SQL = N'
        SELECT TOP 20
            FirstName,
            LastName,
            JobTitle,
            BaseSalary,
            HireDate
        FROM Employees
        WHERE IsActive = 1
        ORDER BY ' + ________(@SortColumn) + ' ' + @SortDirection;
    
    EXEC sp_executesql @SQL;
END;
GO

-- Test
EXEC usp_GetEmployeesSorted @SortColumn = 'BaseSalary', @SortDirection = 'DESC';
```

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_GetEmployeesSorted
    @SortColumn VARCHAR(50) = 'LastName',
    @SortDirection VARCHAR(4) = 'ASC'
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Validate sort column (whitelist!)
    IF @SortColumn NOT IN ('FirstName', 'LastName', 'JobTitle', 'BaseSalary', 'HireDate')
        SET @SortColumn = 'LastName';
    
    -- Validate direction
    IF @SortDirection NOT IN ('ASC', 'DESC')
        SET @SortDirection = 'ASC';
    
    SET @SQL = N'
        SELECT TOP 20
            FirstName,
            LastName,
            JobTitle,
            BaseSalary,
            HireDate
        FROM Employees
        WHERE IsActive = 1
        ORDER BY ' + QUOTENAME(@SortColumn) + ' ' + @SortDirection;
    
    EXEC sp_executesql @SQL;
END;
GO

-- Test
EXEC usp_GetEmployeesSorted @SortColumn = 'BaseSalary', @SortDirection = 'DESC';
```

</details>

---

## 📝 Part 5: Challenge Exercises

### Challenge 1: Create a Complete Search Procedure

Create a comprehensive employee search procedure that:
- Searches by name (partial match)
- Filters by department
- Filters by salary range
- Filters by hire date range
- Has sensible defaults

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_AdvancedEmployeeSearch
    @NameSearch VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL,
    @MaxSalary DECIMAL(10,2) = NULL,
    @HiredAfter DATE = NULL,
    @HiredBefore DATE = NULL,
    @MaxResults INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@MaxResults)
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND (@NameSearch IS NULL 
           OR e.FirstName LIKE '%' + @NameSearch + '%'
           OR e.LastName LIKE '%' + @NameSearch + '%')
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
      AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary)
      AND (@MaxSalary IS NULL OR e.BaseSalary <= @MaxSalary)
      AND (@HiredAfter IS NULL OR e.HireDate >= @HiredAfter)
      AND (@HiredBefore IS NULL OR e.HireDate <= @HiredBefore)
    ORDER BY e.LastName, e.FirstName;
END;
GO

-- Test various combinations
EXEC usp_AdvancedEmployeeSearch @NameSearch = 'John';
EXEC usp_AdvancedEmployeeSearch @DepartmentID = 2001, @MinSalary = 60000;
EXEC usp_AdvancedEmployeeSearch @HiredAfter = '2023-01-01', @MaxResults = 20;
```

</details>

---

### Challenge 2: Department Summary with Multiple Outputs

Create a procedure that returns comprehensive department statistics.

<details>
<summary>💡 Click to see solution</summary>

```sql
CREATE OR ALTER PROCEDURE usp_CompleteDepartmentSummary
    @DepartmentID INT,
    @DepartmentName VARCHAR(100) OUTPUT,
    @EmployeeCount INT OUTPUT,
    @TotalSalary DECIMAL(15,2) OUTPUT,
    @AvgSalary DECIMAL(10,2) OUTPUT,
    @MinSalary DECIMAL(10,2) OUTPUT,
    @MaxSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get department name
    SELECT @DepartmentName = DepartmentName
    FROM Departments
    WHERE DepartmentID = @DepartmentID;
    
    -- Get statistics
    SELECT 
        @EmployeeCount = COUNT(*),
        @TotalSalary = ISNULL(SUM(BaseSalary), 0),
        @AvgSalary = ISNULL(AVG(BaseSalary), 0),
        @MinSalary = ISNULL(MIN(BaseSalary), 0),
        @MaxSalary = ISNULL(MAX(BaseSalary), 0)
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1;
END;
GO

-- Test it
DECLARE 
    @Name VARCHAR(100),
    @Count INT,
    @Total DECIMAL(15,2),
    @Avg DECIMAL(10,2),
    @Min DECIMAL(10,2),
    @Max DECIMAL(10,2);

EXEC usp_CompleteDepartmentSummary
    @DepartmentID = 2001,
    @DepartmentName = @Name OUTPUT,
    @EmployeeCount = @Count OUTPUT,
    @TotalSalary = @Total OUTPUT,
    @AvgSalary = @Avg OUTPUT,
    @MinSalary = @Min OUTPUT,
    @MaxSalary = @Max OUTPUT;

SELECT 
    @Name AS Department,
    @Count AS Employees,
    @Total AS TotalSalaries,
    @Avg AS AvgSalary,
    @Min AS MinSalary,
    @Max AS MaxSalary;
```

</details>

---

## 🎯 Lab Summary

### What You Practiced:

| Skill | Exercises |
|-------|-----------|
| Running procedures | 1.1, 1.2, 1.3 |
| Passing parameters | 2.1, 2.2, 2.3, 2.4 |
| OUTPUT parameters | 2.5, 3.4 |
| Creating procedures | 3.1, 3.2, 3.3, 3.4, 3.5 |
| Dynamic SQL | 4.1, 4.2, 4.3 |

### Key Patterns Learned:

```sql
-- Run a procedure
EXEC ProcedureName;
EXEC ProcedureName @Param = Value;

-- OUTPUT parameters
DECLARE @Result INT;
EXEC MyProc @Output = @Result OUTPUT;

-- Create a procedure
CREATE OR ALTER PROCEDURE MyProc
    @InputParam INT,
    @DefaultParam INT = 10,
    @OutputParam INT OUTPUT
AS
BEGIN
    -- Your code here
END;

-- Dynamic SQL (safe way)
EXEC sp_executesql @SQL, N'@Param INT', @Param = @Value;
```

---

## 🧹 Cleanup

To remove the lab procedures when done:

```sql
DROP PROCEDURE IF EXISTS usp_GetActiveEmployees;
DROP PROCEDURE IF EXISTS usp_GetEmployeesByDepartment;
DROP PROCEDURE IF EXISTS usp_GetTopEarners;
DROP PROCEDURE IF EXISTS usp_GetDepartmentEmployeeCount;
DROP PROCEDURE IF EXISTS usp_SearchEmployees;
DROP PROCEDURE IF EXISTS usp_GetAllDepartments;
DROP PROCEDURE IF EXISTS usp_GetEmployeesHiredAfter;
DROP PROCEDURE IF EXISTS usp_GetRecentHires;
DROP PROCEDURE IF EXISTS usp_GetDepartmentStats;
DROP PROCEDURE IF EXISTS usp_GetDepartmentReport;
DROP PROCEDURE IF EXISTS usp_GetEmployeesSorted;
DROP PROCEDURE IF EXISTS usp_AdvancedEmployeeSearch;
DROP PROCEDURE IF EXISTS usp_CompleteDepartmentSummary;

PRINT 'Cleanup complete!';
```

---

## 🏆 Congratulations!

You've completed the Stored Procedures Lab! You now know how to:
- ✅ Execute stored procedures
- ✅ Pass parameters (input and output)
- ✅ Create your own procedures
- ✅ Use default parameter values
- ✅ Work with basic dynamic SQL

**Next Lab:** Module 17 - Implementing Error Handling
