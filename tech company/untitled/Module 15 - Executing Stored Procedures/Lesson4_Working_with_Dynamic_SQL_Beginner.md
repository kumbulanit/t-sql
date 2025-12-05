# Lesson 4: Working with Dynamic SQL - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

**Warning: This is an advanced topic!** Dynamic SQL is powerful but can be dangerous if misused. This lesson will teach you the basics safely.

---

## 📖 What is Dynamic SQL? (The Simple Explanation)

### Real-World Analogy: Mad Libs 📝

Remember Mad Libs? You fill in blanks to create different stories:

```
"The __[adjective]__ __[noun]__ went to __[place]__"

Fill in: "funny", "dog", "park"
Result: "The funny dog went to park"
```

Dynamic SQL is similar - you build a SQL query by filling in parts!

```
┌─────────────────────────────────────────────────────────────────┐
│                    DYNAMIC SQL = MAD LIBS                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Template Query:                                                │
│  "SELECT * FROM __[TableName]__ WHERE __[Column]__ = __[Value]__"│
│                                                                 │
│  Fill in: "Employees", "DepartmentID", "2001"                   │
│                                                                 │
│  Result:                                                        │
│  "SELECT * FROM Employees WHERE DepartmentID = 2001"            │
│                                                                 │
│  The query is BUILT as a string, then EXECUTED                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Regular SQL vs Dynamic SQL

| Regular SQL | Dynamic SQL |
|-------------|-------------|
| Query is fixed | Query is built as a string |
| Easy to read | Harder to debug |
| Limited flexibility | Very flexible |
| Safe by default | Needs careful handling |

### Example Comparison:

**Regular SQL:**
```sql
-- This is "static" - the table name is fixed
SELECT * FROM Employees WHERE DepartmentID = 2001;
```

**Dynamic SQL:**
```sql
-- This builds the query as text, then runs it
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = 'SELECT * FROM Employees WHERE DepartmentID = 2001';
EXEC sp_executesql @SQL;
```

---

## 🎓 Part 1: Basic Dynamic SQL

### The Two Main Ways

**Method 1: EXEC (simple but less safe)**
```sql
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = 'SELECT * FROM Employees';
EXEC(@SQL);
```

**Method 2: sp_executesql (recommended - safer)**
```sql
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = N'SELECT * FROM Employees';
EXEC sp_executesql @SQL;
```

**Always use sp_executesql when possible!**

---

### Example 1.1: Dynamic Table Selection

```sql
DECLARE @TableName NVARCHAR(128) = 'Employees';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT TOP 10 * FROM ' + QUOTENAME(@TableName);
EXEC sp_executesql @SQL;
```

**What is QUOTENAME?**
- It safely wraps the table name in brackets [TableName]
- Prevents errors with special characters in names
- **Always use it for object names!**

---

### Example 1.2: Dynamic Column Selection

```sql
DECLARE @ColumnList NVARCHAR(500) = 'FirstName, LastName, JobTitle';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT ' + @ColumnList + ' FROM Employees WHERE IsActive = 1';
EXEC sp_executesql @SQL;
```

**Result:**
| FirstName | LastName | JobTitle         |
|-----------|----------|------------------|
| John      | Smith    | Developer        |
| Sarah     | Johnson  | Senior Developer |
| ...       | ...      | ...              |

---

## 🎓 Part 2: Parameters with sp_executesql

### Why Use Parameters?

**BAD (SQL Injection Risk!):**
```sql
-- DANGEROUS - Never do this with user input!
DECLARE @UserInput VARCHAR(50) = 'Engineering';
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = 'SELECT * FROM Employees WHERE DepartmentName = ''' + @UserInput + '''';
EXEC(@SQL);
```

**GOOD (Safe with Parameters):**
```sql
DECLARE @UserInput VARCHAR(50) = 'Engineering';
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = N'SELECT * FROM Employees WHERE DepartmentName = @DeptName';
EXEC sp_executesql @SQL, N'@DeptName VARCHAR(50)', @DeptName = @UserInput;
```

### Example 2.1: Parameterized Dynamic Query

```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DeptID INT = 2001;
DECLARE @MinSalary DECIMAL(10,2) = 50000;

SET @SQL = N'
SELECT FirstName, LastName, JobTitle, BaseSalary
FROM Employees
WHERE DepartmentID = @pDeptID
  AND BaseSalary >= @pMinSalary
  AND IsActive = 1';

EXEC sp_executesql 
    @SQL,
    N'@pDeptID INT, @pMinSalary DECIMAL(10,2)',
    @pDeptID = @DeptID,
    @pMinSalary = @MinSalary;
```

**Breakdown:**
1. `@SQL` - The query with parameter placeholders
2. `N'@pDeptID INT, @pMinSalary DECIMAL(10,2)'` - Parameter definitions
3. `@pDeptID = @DeptID` - Passing actual values

---

## 🎓 Part 3: Building Flexible Queries

### Example 3.1: Optional WHERE Conditions

```sql
CREATE OR ALTER PROCEDURE SearchEmployeesDynamic
    @FirstName VARCHAR(50) = NULL,
    @LastName VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Where NVARCHAR(MAX) = ' WHERE IsActive = 1';
    DECLARE @Params NVARCHAR(500);
    
    -- Build WHERE clause dynamically
    IF @FirstName IS NOT NULL
        SET @Where = @Where + ' AND FirstName LIKE ''%'' + @pFirstName + ''%''';
    
    IF @LastName IS NOT NULL
        SET @Where = @Where + ' AND LastName LIKE ''%'' + @pLastName + ''%''';
    
    IF @DepartmentID IS NOT NULL
        SET @Where = @Where + ' AND DepartmentID = @pDeptID';
    
    IF @MinSalary IS NOT NULL
        SET @Where = @Where + ' AND BaseSalary >= @pMinSalary';
    
    -- Build complete query
    SET @SQL = N'
        SELECT 
            EmployeeID,
            FirstName,
            LastName,
            JobTitle,
            BaseSalary
        FROM Employees' 
        + @Where + 
        ' ORDER BY LastName, FirstName';
    
    -- Define parameters
    SET @Params = N'@pFirstName VARCHAR(50), @pLastName VARCHAR(50), 
                   @pDeptID INT, @pMinSalary DECIMAL(10,2)';
    
    -- Execute
    EXEC sp_executesql @SQL, @Params, 
        @pFirstName = @FirstName,
        @pLastName = @LastName,
        @pDeptID = @DepartmentID,
        @pMinSalary = @MinSalary;
END;
```

**Usage:**
```sql
-- Search by first name only
EXEC SearchEmployeesDynamic @FirstName = 'John';

-- Search by department and salary
EXEC SearchEmployeesDynamic @DepartmentID = 2001, @MinSalary = 60000;

-- Search by last name
EXEC SearchEmployeesDynamic @LastName = 'Smith';
```

---

### Example 3.2: Dynamic Sorting

```sql
CREATE OR ALTER PROCEDURE GetEmployeesSorted
    @SortColumn VARCHAR(50) = 'LastName',
    @SortDirection VARCHAR(4) = 'ASC'
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Validate sort column (security!)
    IF @SortColumn NOT IN ('FirstName', 'LastName', 'JobTitle', 'BaseSalary', 'HireDate')
        SET @SortColumn = 'LastName';
    
    -- Validate sort direction
    IF @SortDirection NOT IN ('ASC', 'DESC')
        SET @SortDirection = 'ASC';
    
    SET @SQL = N'
        SELECT 
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
```

**Usage:**
```sql
-- Sort by salary descending
EXEC GetEmployeesSorted @SortColumn = 'BaseSalary', @SortDirection = 'DESC';

-- Sort by hire date ascending
EXEC GetEmployeesSorted @SortColumn = 'HireDate', @SortDirection = 'ASC';
```

---

## ⚠️ Part 4: Security - SQL Injection

### What is SQL Injection?

When user input is directly put into a query, attackers can manipulate it:

```
┌─────────────────────────────────────────────────────────────────┐
│                ⚠️ SQL INJECTION DANGER ⚠️                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BAD CODE (vulnerable):                                         │
│  ─────────────────────                                          │
│  SET @SQL = 'SELECT * FROM Users WHERE Name = ''' + @Input + '''│
│                                                                 │
│  Normal Input: "John"                                           │
│  Result: SELECT * FROM Users WHERE Name = 'John'                │
│  ✓ Works fine                                                   │
│                                                                 │
│  ATTACK Input: "'; DROP TABLE Users; --"                        │
│  Result: SELECT * FROM Users WHERE Name = '';                   │
│          DROP TABLE Users; --'                                  │
│  ❌ TABLE DELETED!                                              │
│                                                                 │
│  PROTECTION:                                                    │
│  ✅ Always use sp_executesql with parameters                    │
│  ✅ Validate input values (whitelist allowed values)            │
│  ✅ Use QUOTENAME() for object names                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Safe Pattern:

```sql
-- SAFE: Using parameters
DECLARE @UserName VARCHAR(50) = 'John';  -- Could be from user input
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT * FROM Users WHERE Name = @pName';
EXEC sp_executesql @SQL, N'@pName VARCHAR(50)', @pName = @UserName;
```

---

## 🎓 Part 5: Debugging Dynamic SQL

### Print Before Execute

```sql
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = N'SELECT * FROM Employees WHERE DepartmentID = @DeptID';

-- Debug: See what the query looks like
PRINT @SQL;

-- Then execute
EXEC sp_executesql @SQL, N'@DeptID INT', @DeptID = 2001;
```

### Common Mistakes

```sql
-- MISTAKE 1: Missing spaces
SET @SQL = 'SELECT * FROM' + @TableName;  -- Missing space before table!
-- Fix:
SET @SQL = 'SELECT * FROM ' + @TableName;

-- MISTAKE 2: Missing quotes around strings
SET @SQL = 'SELECT * FROM Employees WHERE Name = ' + @Name;  -- Wrong!
-- Fix (but better to use parameters):
SET @SQL = 'SELECT * FROM Employees WHERE Name = ''' + @Name + '''';

-- MISTAKE 3: Not using QUOTENAME for objects
SET @SQL = 'SELECT * FROM ' + @TableName;  -- Risky!
-- Fix:
SET @SQL = 'SELECT * FROM ' + QUOTENAME(@TableName);
```

---

## 📊 Visual Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                 DYNAMIC SQL DECISION GUIDE                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Do you need Dynamic SQL?                                       │
│  ────────────────────────                                       │
│                                                                 │
│  ❓ Can regular SQL do the job?                                 │
│     YES → Use regular SQL (simpler, safer)                      │
│     NO  → Continue...                                           │
│                                                                 │
│  ❓ What needs to be dynamic?                                   │
│     • Table name      → Use QUOTENAME()                         │
│     • Column name     → Use QUOTENAME() + whitelist             │
│     • WHERE values    → Use sp_executesql with parameters       │
│     • Sort order      → Validate against whitelist              │
│                                                                 │
│  ❓ Is user input involved?                                     │
│     YES → MUST use parameters + validation                      │
│     NO  → Still good practice to use parameters                 │
│                                                                 │
│  CHECKLIST:                                                     │
│  ☐ Using sp_executesql (not just EXEC)?                        │
│  ☐ Using parameters for values?                                 │
│  ☐ Using QUOTENAME for object names?                            │
│  ☐ Validating dynamic parts against whitelists?                 │
│  ☐ Tested with PRINT before EXEC?                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Basic Dynamic SQL (Easy)

Run a simple dynamic query:

```sql
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = N'SELECT TOP 5 FirstName, LastName FROM Employees';
EXEC sp_executesql @SQL;
```

### Exercise 2: Parameterized Query (Medium)

Create a parameterized dynamic query:

```sql
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DeptID INT = 2001;

SET @SQL = N'
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE DepartmentID = @pDept AND IsActive = 1';

EXEC sp_executesql @SQL, N'@pDept INT', @pDept = @DeptID;
```

### Exercise 3: Dynamic Table Name (Hard)

Safely query different tables:

```sql
CREATE OR ALTER PROCEDURE GetTablePreview
    @TableName NVARCHAR(128),
    @RowCount INT = 10
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Validate table exists (security!)
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = @TableName)
    BEGIN
        RAISERROR('Invalid table name', 16, 1);
        RETURN;
    END
    
    SET @SQL = N'SELECT TOP (@pRows) * FROM ' + QUOTENAME(@TableName);
    EXEC sp_executesql @SQL, N'@pRows INT', @pRows = @RowCount;
END;

-- Test it:
EXEC GetTablePreview @TableName = 'Employees', @RowCount = 5;
EXEC GetTablePreview @TableName = 'Departments';
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Dynamic SQL builds queries as strings then executes them    │
│                                                                 │
│  ✅ Use sp_executesql (not plain EXEC) for safety               │
│                                                                 │
│  ✅ ALWAYS use parameters for WHERE clause values               │
│                                                                 │
│  ✅ Use QUOTENAME() for table and column names                  │
│                                                                 │
│  ✅ Validate dynamic parts against whitelists                   │
│                                                                 │
│  ✅ Use PRINT to debug before executing                         │
│                                                                 │
│  ⚠️ Be VERY careful with user input - SQL injection is real!   │
│                                                                 │
│  💡 Only use dynamic SQL when regular SQL can't do the job      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📖 Quick Reference

```sql
-- Basic execution
DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM Employees';
EXEC sp_executesql @SQL;

-- With parameters (SAFE)
DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM Employees WHERE ID = @pID';
EXEC sp_executesql @SQL, N'@pID INT', @pID = 3001;

-- Dynamic table name (use QUOTENAME!)
DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM ' + QUOTENAME(@TableName);
EXEC sp_executesql @SQL;

-- Debug - see the query
PRINT @SQL;
```

---

## 🏆 Module 15 Complete!

Congratulations! You've learned about Stored Procedures:

1. **What they are** - Saved queries with names
2. **How to run them** - EXEC ProcedureName
3. **Parameters** - Making procedures flexible
4. **Creating procedures** - Building your own
5. **Dynamic SQL** - Advanced query building

**Next Module:** Module 17 - Implementing Error Handling
