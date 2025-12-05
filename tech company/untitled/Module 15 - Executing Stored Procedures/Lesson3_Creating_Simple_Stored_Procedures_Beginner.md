# Lesson 3: Creating Simple Stored Procedures - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Now it's time to **CREATE your own stored procedures**! This is where you become the chef writing your own recipes. By the end of this lesson, you'll be able to build procedures from scratch.

---

## 📖 Creating Procedures (The Simple Explanation)

### Real-World Analogy: Writing a Recipe 📝

When you write a recipe, you need:
1. **A name** for the recipe
2. **Ingredients** (optional - what inputs it needs)
3. **Instructions** (what steps to follow)

Creating a stored procedure is the same!

```
┌─────────────────────────────────────────────────────────────────┐
│              CREATING A STORED PROCEDURE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Recipe Card                        Stored Procedure            │
│  ───────────                        ────────────────            │
│                                                                 │
│  Recipe Name: Chocolate Cake        CREATE PROCEDURE GetEmps    │
│                                                                 │
│  Ingredients:                       Parameters (optional):      │
│  - 2 cups flour                     @DepartmentID INT           │
│  - 3 eggs                           @MinSalary DECIMAL          │
│                                                                 │
│  Instructions:                      AS BEGIN                    │
│  1. Mix ingredients                   SELECT * FROM Employees   │
│  2. Pour into pan                     WHERE DeptID = @DeptID    │
│  3. Bake at 350°F                   END                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 The Basic Structure

Here's the simplest stored procedure structure:

```sql
CREATE PROCEDURE ProcedureName
AS
BEGIN
    -- Your SQL code goes here
    SELECT * FROM SomeTable;
END;
```

**That's it!** Let's break it down:

| Part | What It Does |
|------|--------------|
| `CREATE PROCEDURE` | Tells SQL Server you're making a new procedure |
| `ProcedureName` | The name you give your procedure |
| `AS` | Separates the name from the code |
| `BEGIN...END` | Contains your SQL statements |

---

## 🎓 Part 1: Your First Stored Procedure

### Example 1.1: The Simplest Procedure

Let's create a procedure that shows all departments:

```sql
-- CREATE the procedure
CREATE PROCEDURE GetAllDepartments
AS
BEGIN
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget
    FROM Departments
    ORDER BY DepartmentName;
END;
```

**Now RUN it:**
```sql
EXEC GetAllDepartments;
```

**Result:**
| DepartmentID | DepartmentName | Location    | Budget    |
|--------------|----------------|-------------|-----------|
| 2001         | Engineering    | Building A  | 1500000   |
| 2003         | HR             | Building B  | 500000    |
| 2002         | Marketing      | Building A  | 800000    |

---

### Example 1.2: Procedure with Active Filter

```sql
CREATE PROCEDURE GetActiveEmployees
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        HireDate
    FROM Employees
    WHERE IsActive = 1
    ORDER BY LastName, FirstName;
END;
```

**Run it:**
```sql
EXEC GetActiveEmployees;
```

---

## 🎓 Part 2: Procedures with Parameters

### Adding Input Parameters

Parameters go between the procedure name and `AS`:

```sql
CREATE PROCEDURE ProcedureName
    @Parameter1 DataType,
    @Parameter2 DataType
AS
BEGIN
    -- Use @Parameter1 and @Parameter2 in your query
END;
```

### Example 2.1: Single Parameter

```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary
    FROM Employees e
    WHERE e.DepartmentID = @DeptID
      AND e.IsActive = 1
    ORDER BY e.LastName;
END;
```

**Run it with different values:**
```sql
-- Get Engineering employees
EXEC GetEmployeesByDepartment @DeptID = 2001;

-- Get Marketing employees
EXEC GetEmployeesByDepartment @DeptID = 2002;
```

---

### Example 2.2: Multiple Parameters

```sql
CREATE PROCEDURE GetEmployeesFiltered
    @DeptID INT,
    @MinSalary DECIMAL(10,2)
AS
BEGIN
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.DepartmentID = @DeptID
      AND e.BaseSalary >= @MinSalary
      AND e.IsActive = 1
    ORDER BY e.BaseSalary DESC;
END;
```

**Run it:**
```sql
-- Engineering employees earning over $70,000
EXEC GetEmployeesFiltered @DeptID = 2001, @MinSalary = 70000;

-- Marketing employees earning over $50,000
EXEC GetEmployeesFiltered @DeptID = 2002, @MinSalary = 50000;
```

---

### Example 2.3: Parameters with Default Values

```sql
CREATE PROCEDURE GetTopEmployees
    @TopCount INT = 10,              -- Default is 10
    @SortBy VARCHAR(20) = 'Salary'   -- Default is 'Salary'
AS
BEGIN
    IF @SortBy = 'Salary'
        SELECT TOP (@TopCount)
            FirstName,
            LastName,
            JobTitle,
            BaseSalary
        FROM Employees
        WHERE IsActive = 1
        ORDER BY BaseSalary DESC;
    ELSE
        SELECT TOP (@TopCount)
            FirstName,
            LastName,
            JobTitle,
            HireDate
        FROM Employees
        WHERE IsActive = 1
        ORDER BY HireDate;
END;
```

**Run it:**
```sql
-- Uses defaults: Top 10 by Salary
EXEC GetTopEmployees;

-- Override one default: Top 5 by Salary
EXEC GetTopEmployees @TopCount = 5;

-- Override both: Top 20 by HireDate
EXEC GetTopEmployees @TopCount = 20, @SortBy = 'HireDate';
```

---

## 🎓 Part 3: Procedures with OUTPUT Parameters

### Returning Values Back

```sql
CREATE PROCEDURE GetDepartmentStats
    @DeptID INT,
    @EmpCount INT OUTPUT,
    @TotalSalary DECIMAL(15,2) OUTPUT
AS
BEGIN
    SELECT 
        @EmpCount = COUNT(*),
        @TotalSalary = SUM(BaseSalary)
    FROM Employees
    WHERE DepartmentID = @DeptID
      AND IsActive = 1;
END;
```

**Run it and capture the outputs:**
```sql
DECLARE @Count INT;
DECLARE @Total DECIMAL(15,2);

EXEC GetDepartmentStats 
    @DeptID = 2001, 
    @EmpCount = @Count OUTPUT, 
    @TotalSalary = @Total OUTPUT;

SELECT 
    @Count AS EmployeeCount,
    @Total AS TotalSalaries;
```

**Result:**
| EmployeeCount | TotalSalaries |
|---------------|---------------|
| 15            | 1125000.00    |

---

## 🎓 Part 4: Modifying Procedures

### Using ALTER PROCEDURE

If your procedure already exists and you need to change it:

```sql
-- Can't use CREATE if it already exists!
-- Use ALTER instead:

ALTER PROCEDURE GetAllDepartments
AS
BEGIN
    -- New version with more columns
    SELECT 
        DepartmentID,
        DepartmentName,
        Location,
        Budget,
        IsActive,
        'Updated!' AS Version
    FROM Departments
    ORDER BY DepartmentName;
END;
```

### Using CREATE OR ALTER (SQL Server 2016+)

This is the easiest - it creates if new, updates if exists:

```sql
CREATE OR ALTER PROCEDURE GetAllDepartments
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
```

---

## 🎓 Part 5: Deleting Procedures

### Using DROP PROCEDURE

```sql
-- Remove a procedure completely
DROP PROCEDURE GetAllDepartments;

-- Safe way - only drop if exists
DROP PROCEDURE IF EXISTS GetAllDepartments;
```

---

## 📊 Complete Examples

### Example A: Employee Search Procedure

```sql
CREATE OR ALTER PROCEDURE SearchEmployees
    @SearchTerm VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL
AS
BEGIN
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
      AND (@SearchTerm IS NULL 
           OR e.FirstName LIKE '%' + @SearchTerm + '%'
           OR e.LastName LIKE '%' + @SearchTerm + '%')
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
      AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary)
    ORDER BY e.LastName, e.FirstName;
END;
```

**Flexible usage:**
```sql
-- Search by name
EXEC SearchEmployees @SearchTerm = 'John';

-- Search by department
EXEC SearchEmployees @DepartmentID = 2001;

-- Search with salary filter
EXEC SearchEmployees @MinSalary = 70000;

-- Combine filters
EXEC SearchEmployees @DepartmentID = 2001, @MinSalary = 60000;
```

---

### Example B: Summary Report Procedure

```sql
CREATE OR ALTER PROCEDURE GenerateDepartmentReport
    @DeptID INT
AS
BEGIN
    -- Header information
    PRINT '========================================';
    PRINT 'Department Report';
    PRINT '========================================';
    
    -- Department details
    SELECT 
        DepartmentName,
        Location,
        Budget
    FROM Departments
    WHERE DepartmentID = @DeptID;
    
    -- Employee list
    SELECT 
        FirstName + ' ' + LastName AS EmployeeName,
        JobTitle,
        BaseSalary
    FROM Employees
    WHERE DepartmentID = @DeptID
      AND IsActive = 1
    ORDER BY BaseSalary DESC;
    
    -- Summary stats
    SELECT 
        COUNT(*) AS TotalEmployees,
        SUM(BaseSalary) AS TotalSalaries,
        AVG(BaseSalary) AS AverageSalary,
        MIN(BaseSalary) AS MinSalary,
        MAX(BaseSalary) AS MaxSalary
    FROM Employees
    WHERE DepartmentID = @DeptID
      AND IsActive = 1;
END;
```

**Run it:**
```sql
EXEC GenerateDepartmentReport @DeptID = 2001;
```

---

## 📊 Visual Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                PROCEDURE CREATION CHECKLIST                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Choose a clear, descriptive name                       │
│          ✓ GetEmployeesByDepartment                             │
│          ✗ Proc1                                                │
│                                                                 │
│  Step 2: Decide on parameters                                   │
│          - What inputs do you need?                             │
│          - What are their data types?                           │
│          - Should any have default values?                      │
│                                                                 │
│  Step 3: Write the SQL between BEGIN...END                      │
│          - SELECT, INSERT, UPDATE, DELETE                       │
│          - Can have multiple statements                         │
│                                                                 │
│  Step 4: Test with different parameter values                   │
│          EXEC YourProcedure @Param = Value1;                    │
│          EXEC YourProcedure @Param = Value2;                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Create a Simple Procedure (Easy)

Create a procedure that shows all active projects:

```sql
-- Your solution:
CREATE OR ALTER PROCEDURE GetActiveProjects
AS
BEGIN
    SELECT 
        ProjectID,
        ProjectName,
        Budget,
        StartDate,
        EndDate
    FROM Projects
    WHERE IsActive = 1
    ORDER BY StartDate;
END;

-- Test it:
EXEC GetActiveProjects;
```

### Exercise 2: Procedure with Parameter (Medium)

Create a procedure to get employees hired after a certain date:

```sql
-- Your solution:
CREATE OR ALTER PROCEDURE GetEmployeesHiredAfter
    @HireDate DATE
AS
BEGIN
    SELECT 
        FirstName,
        LastName,
        JobTitle,
        HireDate
    FROM Employees
    WHERE HireDate >= @HireDate
      AND IsActive = 1
    ORDER BY HireDate;
END;

-- Test it:
EXEC GetEmployeesHiredAfter @HireDate = '2023-01-01';
```

### Exercise 3: Procedure with Default (Medium)

Create a procedure with an optional limit:

```sql
-- Your solution:
CREATE OR ALTER PROCEDURE GetHighEarners
    @MinSalary DECIMAL(10,2) = 75000,  -- Default $75K
    @TopCount INT = 10                  -- Default top 10
AS
BEGIN
    SELECT TOP (@TopCount)
        FirstName,
        LastName,
        JobTitle,
        BaseSalary
    FROM Employees
    WHERE BaseSalary >= @MinSalary
      AND IsActive = 1
    ORDER BY BaseSalary DESC;
END;

-- Test with defaults:
EXEC GetHighEarners;

-- Test with custom values:
EXEC GetHighEarners @MinSalary = 100000, @TopCount = 5;
```

### Exercise 4: Procedure with OUTPUT (Hard)

Create a procedure that returns count and average salary:

```sql
-- Your solution:
CREATE OR ALTER PROCEDURE GetSalaryStats
    @DeptID INT,
    @AvgSalary DECIMAL(10,2) OUTPUT,
    @EmpCount INT OUTPUT
AS
BEGIN
    SELECT 
        @AvgSalary = AVG(BaseSalary),
        @EmpCount = COUNT(*)
    FROM Employees
    WHERE DepartmentID = @DeptID
      AND IsActive = 1;
END;

-- Test it:
DECLARE @Avg DECIMAL(10,2);
DECLARE @Count INT;

EXEC GetSalaryStats 
    @DeptID = 2001, 
    @AvgSalary = @Avg OUTPUT, 
    @EmpCount = @Count OUTPUT;

SELECT @Count AS EmployeeCount, @Avg AS AverageSalary;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Basic structure: CREATE PROCEDURE Name AS BEGIN...END       │
│                                                                 │
│  ✅ Parameters go between name and AS keyword                   │
│                                                                 │
│  ✅ Give parameters default values with @Param Type = Default   │
│                                                                 │
│  ✅ Use OUTPUT keyword for parameters that return values        │
│                                                                 │
│  ✅ ALTER PROCEDURE updates existing procedures                 │
│                                                                 │
│  ✅ CREATE OR ALTER works for both new and existing             │
│                                                                 │
│  ✅ DROP PROCEDURE removes a procedure                          │
│                                                                 │
│  ✅ Use clear, descriptive names for your procedures            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📖 Quick Reference

```sql
-- Create simple procedure
CREATE PROCEDURE ProcName
AS
BEGIN
    SELECT * FROM Table;
END;

-- Create with parameters
CREATE PROCEDURE ProcName
    @Param1 INT,
    @Param2 VARCHAR(50) = 'Default'  -- Has default
AS
BEGIN
    SELECT * FROM Table WHERE Col = @Param1;
END;

-- Create with OUTPUT
CREATE PROCEDURE ProcName
    @Input INT,
    @Output INT OUTPUT
AS
BEGIN
    SELECT @Output = COUNT(*) FROM Table WHERE Col = @Input;
END;

-- Modify existing
ALTER PROCEDURE ProcName AS BEGIN ... END;

-- Create or modify
CREATE OR ALTER PROCEDURE ProcName AS BEGIN ... END;

-- Delete
DROP PROCEDURE IF EXISTS ProcName;
```

---

## 🚀 What's Next?

In the next lesson, you'll learn about **Dynamic SQL** - building queries on the fly! This is an advanced topic that lets you create very flexible procedures.

**Example Preview:**
```sql
-- Dynamic SQL builds queries as strings
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = 'SELECT * FROM ' + @TableName;
EXEC sp_executesql @SQL;
```

This is powerful but needs to be used carefully!
