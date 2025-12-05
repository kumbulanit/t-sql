# Lesson 2: Passing Parameters to Stored Procedures - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

In this lesson, you'll learn how to make stored procedures **flexible** by passing **parameters** - values that change what the procedure does. This is where stored procedures become really powerful!

---

## 📖 What are Parameters? (The Simple Explanation)

### Real-World Analogy: The Coffee Order ☕

When you order coffee, you don't just say "coffee" - you give details:
- **Size:** Small, Medium, Large
- **Type:** Latte, Cappuccino, Americano
- **Milk:** Regular, Oat, Almond

These details are like **parameters** - they customize your order!

```
┌─────────────────────────────────────────────────────────────────┐
│                 PARAMETERS = CUSTOMIZATION                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Coffee Shop                        Database                    │
│  ───────────                        ────────                    │
│                                                                 │
│  "I'd like a LARGE LATTE           "Give me employees from      │
│   with OAT milk"                    DEPARTMENT 2001"            │
│                                                                 │
│  Parameters:                        Parameters:                 │
│  └── @Size = 'Large'                └── @DepartmentID = 2001    │
│  └── @Type = 'Latte'                                            │
│  └── @Milk = 'Oat'                                              │
│                                                                 │
│  Same procedure, different result!                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 In Simple Terms

**Without Parameters:**
- One procedure does ONE thing
- Need separate procedures for each variation

**With Parameters:**
- One procedure can do MANY things
- Just pass different values!

```sql
-- WITHOUT parameters - need multiple procedures!
EXEC GetEngineeringEmployees;
EXEC GetMarketingEmployees;
EXEC GetSalesEmployees;

-- WITH parameters - ONE procedure does it all!
EXEC GetEmployeesByDepartment @DepartmentName = 'Engineering';
EXEC GetEmployeesByDepartment @DepartmentName = 'Marketing';
EXEC GetEmployeesByDepartment @DepartmentName = 'Sales';
```

---

## 🎓 Part 1: Understanding Parameter Syntax

### The @ Symbol

In SQL Server, parameters always start with `@`:

```sql
@DepartmentID          -- A parameter for department ID
@EmployeeName          -- A parameter for employee name
@MinSalary             -- A parameter for minimum salary
```

### Calling Procedures with Parameters

There are **two ways** to pass parameters:

**Method 1: Named Parameters (Recommended)**
```sql
EXEC GetEmployees @DepartmentID = 2001;

-- With multiple parameters
EXEC GetEmployees @DepartmentID = 2001, @IsActive = 1;
```

**Method 2: Positional Parameters**
```sql
EXEC GetEmployees 2001;

-- With multiple parameters (order matters!)
EXEC GetEmployees 2001, 1;
```

**💡 Best Practice:** Always use named parameters - they're clearer!

---

## 🎓 Part 2: Executing Procedures with Parameters

### Example 2.1: Single Parameter

Let's say we have this stored procedure:

```sql
-- This procedure was created to get employees by department
-- Parameter: @DeptID (the department ID to filter by)
```

**Calling it:**
```sql
-- Get Engineering employees (Department 2001)
EXEC GetEmployeesByDept @DeptID = 2001;

-- Get Marketing employees (Department 2002)
EXEC GetEmployeesByDept @DeptID = 2002;

-- Get HR employees (Department 2003)
EXEC GetEmployeesByDept @DeptID = 2003;
```

**Same procedure, different results!**

---

### Example 2.2: Multiple Parameters

```sql
-- Procedure accepts department AND salary filter
-- Parameters: @DeptID, @MinSalary

-- Get Engineering employees earning over $60,000
EXEC GetEmployeesByDeptAndSalary 
    @DeptID = 2001, 
    @MinSalary = 60000;

-- Get Marketing employees earning over $50,000
EXEC GetEmployeesByDeptAndSalary 
    @DeptID = 2002, 
    @MinSalary = 50000;
```

---

### Example 2.3: Using Variables as Parameters

You can pass variables instead of literal values:

```sql
-- Declare variables
DECLARE @MyDept INT = 2001;
DECLARE @MySalary DECIMAL(10,2) = 55000;

-- Use variables as parameters
EXEC GetEmployeesByDeptAndSalary 
    @DeptID = @MyDept, 
    @MinSalary = @MySalary;
```

This is useful when values come from calculations or other queries!

---

## 🎓 Part 3: Parameter Data Types

Parameters have data types, just like columns:

| Data Type | Example Values | Use For |
|-----------|----------------|---------|
| INT | 1, 2001, -5 | IDs, counts |
| VARCHAR(50) | 'Engineering', 'John' | Text, names |
| DECIMAL(10,2) | 50000.00, 99.99 | Money, precise numbers |
| DATE | '2024-01-15' | Dates |
| BIT | 0, 1 | True/False (Yes/No) |

### Example 3.1: Different Data Types

```sql
-- String parameter
EXEC SearchEmployeesByName @SearchName = 'John';

-- Date parameter
EXEC GetEmployeesHiredAfter @HireDate = '2023-01-01';

-- Boolean (BIT) parameter
EXEC GetEmployees @ActiveOnly = 1;  -- 1 = Yes/True
EXEC GetEmployees @ActiveOnly = 0;  -- 0 = No/False

-- Decimal parameter
EXEC GetEmployeesAboveSalary @MinSalary = 75000.00;
```

---

## 🎓 Part 4: Default Parameters

Some parameters have **default values** - if you don't provide them, the procedure uses the default.

### Example 4.1: Parameters with Defaults

```sql
-- This procedure has a default: @TopCount = 10
-- If you don't specify, it returns 10 rows

-- Returns top 10 (uses default)
EXEC GetTopEarners;

-- Returns top 5 (overrides default)
EXEC GetTopEarners @TopCount = 5;

-- Returns top 20 (overrides default)
EXEC GetTopEarners @TopCount = 20;
```

### Example 4.2: Mix of Required and Optional

```sql
-- Required: @DepartmentID
-- Optional: @IncludeInactive (default = 0, meaning No)

-- Get active Engineering employees only
EXEC GetDepartmentEmployees @DepartmentID = 2001;

-- Get ALL Engineering employees (including inactive)
EXEC GetDepartmentEmployees 
    @DepartmentID = 2001, 
    @IncludeInactive = 1;
```

---

## 🎓 Part 5: OUTPUT Parameters

Some parameters can **return values back to you**. These are called OUTPUT parameters.

### Example 5.1: Getting a Count Back

```sql
-- Declare a variable to receive the output
DECLARE @TotalCount INT;

-- Call procedure - it fills @TotalCount for us!
EXEC GetEmployeeCount 
    @DepartmentID = 2001, 
    @EmployeeCount = @TotalCount OUTPUT;

-- Now we can use the value
PRINT 'Total employees: ' + CAST(@TotalCount AS VARCHAR);
SELECT @TotalCount AS EmployeeCount;
```

**The OUTPUT keyword tells SQL Server to send a value back.**

---

### Example 5.2: Multiple OUTPUT Parameters

```sql
DECLARE @EmpCount INT;
DECLARE @TotalSalary DECIMAL(15,2);
DECLARE @AvgSalary DECIMAL(15,2);

EXEC GetDepartmentStats 
    @DepartmentID = 2001,
    @EmployeeCount = @EmpCount OUTPUT,
    @TotalSalaries = @TotalSalary OUTPUT,
    @AverageSalary = @AvgSalary OUTPUT;

-- Display the results
SELECT 
    @EmpCount AS EmployeeCount,
    @TotalSalary AS TotalSalaries,
    @AvgSalary AS AverageSalary;
```

---

## 📊 Visual Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    PARAMETER TYPES                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUT Parameters (Most Common)                                 │
│  ────────────────────────────────                               │
│  You give values TO the procedure                               │
│                                                                 │
│  EXEC GetEmployees @DepartmentID = 2001;                        │
│                     ↑                                           │
│                     You provide this value                      │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  OUTPUT Parameters                                              │
│  ─────────────────                                              │
│  The procedure gives values BACK to you                         │
│                                                                 │
│  DECLARE @Count INT;                                            │
│  EXEC CountEmployees @DeptID = 2001, @Total = @Count OUTPUT;    │
│                                               ↑                 │
│                                               Procedure fills   │
│                                               this for you      │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  DEFAULT Parameters                                             │
│  ─────────────────                                              │
│  Optional - uses default if you don't provide                   │
│                                                                 │
│  EXEC GetTopEmployees;               -- Uses default @Top = 10  │
│  EXEC GetTopEmployees @Top = 5;      -- Uses your value = 5     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Basic Parameter Usage (Easy)

Practice calling procedures with different parameters:

```sql
-- Assuming GetEmployeesByDepartment exists, try different values
-- First, let's create a simple example:

DECLARE @SearchDept INT;

-- Try different department IDs
SET @SearchDept = 2001;
PRINT 'Looking for Department: ' + CAST(@SearchDept AS VARCHAR);

SET @SearchDept = 2002;
PRINT 'Looking for Department: ' + CAST(@SearchDept AS VARCHAR);
```

### Exercise 2: Named vs Positional (Easy)

Understand the difference:

```sql
-- These are equivalent (assuming procedure accepts @Name, @Salary)
-- Named parameters (recommended):
EXEC FindEmployee @Name = 'John', @MinSalary = 50000;

-- Positional parameters (must match order):
EXEC FindEmployee 'John', 50000;

-- Named parameters can be in any order:
EXEC FindEmployee @MinSalary = 50000, @Name = 'John';
```

### Exercise 3: Working with OUTPUT (Medium)

Practice receiving values back:

```sql
-- Declare output variable
DECLARE @Result VARCHAR(100);

-- If procedure exists that returns a status
-- EXEC CheckEmployeeStatus @EmployeeID = 3001, @Status = @Result OUTPUT;

-- For now, simulate with a simple example:
DECLARE @Message VARCHAR(100);
SET @Message = 'Parameter practice complete!';
SELECT @Message AS PracticeResult;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Parameters make procedures flexible (same procedure,        │
│     different results)                                          │
│                                                                 │
│  ✅ Parameters start with @ symbol (@DepartmentID)              │
│                                                                 │
│  ✅ Use NAMED parameters: @Param = Value (clearer!)             │
│                                                                 │
│  ✅ Parameters have data types (INT, VARCHAR, DECIMAL, etc.)    │
│                                                                 │
│  ✅ Some parameters have DEFAULT values (optional)              │
│                                                                 │
│  ✅ OUTPUT parameters return values back to you                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📖 Quick Reference

```sql
-- Call with named parameter
EXEC ProcedureName @Param1 = value1;

-- Call with multiple parameters
EXEC ProcedureName @Param1 = value1, @Param2 = value2;

-- Call with variable
DECLARE @MyValue INT = 100;
EXEC ProcedureName @Param1 = @MyValue;

-- Call with OUTPUT parameter
DECLARE @ResultVar INT;
EXEC ProcedureName @Param1 = 1, @OutputParam = @ResultVar OUTPUT;
SELECT @ResultVar;

-- Using defaults (just don't specify the parameter)
EXEC ProcedureName @RequiredParam = 1;  -- Optional params use defaults
```

---

## 🚀 What's Next?

In the next lesson, you'll learn how to **CREATE your own stored procedures** - write your own recipes that others can use!

**Example Preview:**
```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT FirstName, LastName, JobTitle
    FROM Employees
    WHERE DepartmentID = @DeptID;
END;
```

You'll build your own procedures from scratch!
