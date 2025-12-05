# Lesson 1: Implementing T-SQL Error Handling - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! This lesson introduces **Error Handling** - how to deal with things that go wrong in your SQL code. Don't worry if this sounds scary - by the end, you'll know how to make your code "bulletproof"!

---

## 📖 What is Error Handling? (The Simple Explanation)

### Real-World Analogy: The Safety Net 🎪

Imagine a trapeze artist in a circus:
- They practice their moves perfectly
- But what if they slip? **They have a safety net!**
- The net catches them, so they don't get hurt

Error handling is like a **safety net for your code**:
- Your SQL code does its job
- But what if something goes wrong? **Error handling catches the problem!**
- Your database stays safe, and you get helpful information

```
┌─────────────────────────────────────────────────────────────────┐
│                  ERROR HANDLING = SAFETY NET                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  WITHOUT Error Handling:                                        │
│  ─────────────────────────                                      │
│  Code runs → Error happens → 💥 CRASH!                          │
│  • Data might be corrupted                                      │
│  • User sees scary technical message                            │
│  • No record of what went wrong                                 │
│                                                                 │
│  WITH Error Handling:                                           │
│  ────────────────────                                           │
│  Code runs → Error happens → 🛡️ CAUGHT!                         │
│  • Data stays safe (rollback changes)                           │
│  • User sees friendly message                                   │
│  • Error is logged for later review                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Why Do We Need Error Handling?

### Things That Can Go Wrong:

| Error Type | Example | What Happens |
|------------|---------|--------------|
| **Divide by Zero** | `SELECT 100/0` | Math error! |
| **Duplicate Data** | Insert employee that already exists | Constraint violation! |
| **Missing Data** | Foreign key to non-existent department | Reference error! |
| **Wrong Data Type** | Put text in a number field | Conversion error! |
| **Permission Denied** | Access table you can't see | Security error! |

### Without Error Handling:

```sql
-- This will CRASH if @Quantity is 0
DECLARE @Price DECIMAL = 100;
DECLARE @Quantity INT = 0;
DECLARE @UnitPrice DECIMAL;

SET @UnitPrice = @Price / @Quantity;  -- 💥 DIVIDE BY ZERO ERROR!
SELECT @UnitPrice;
```

---

## 🎓 Part 1: The @@ERROR Variable (Old Method)

### What is @@ERROR?

`@@ERROR` is a special variable that holds the **error number** after each SQL statement.

- If `@@ERROR = 0` → **No error** (success!)
- If `@@ERROR > 0` → **Error occurred** (problem!)

### Example 1.1: Basic @@ERROR Check

```sql
-- Try to divide by zero
DECLARE @Result DECIMAL;
SET @Result = 100 / 0;  -- This causes an error!

-- Check if there was an error
IF @@ERROR <> 0
    PRINT 'An error occurred!';
ELSE
    PRINT 'Success!';
```

**⚠️ Important:** `@@ERROR` resets after EVERY statement, so check it immediately!

### Example 1.2: @@ERROR with INSERT

```sql
-- Try to insert a duplicate (assuming EmployeeID is unique)
INSERT INTO Employees (EmployeeID, FirstName, LastName)
VALUES (3001, 'John', 'Doe');

-- Check right away!
IF @@ERROR <> 0
BEGIN
    PRINT 'Could not insert employee - maybe already exists?';
END
ELSE
BEGIN
    PRINT 'Employee inserted successfully!';
END
```

### Why @@ERROR is Limited:

```
┌─────────────────────────────────────────────────────────────────┐
│                 @@ERROR LIMITATIONS                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem 1: Resets after EVERY statement                        │
│  ─────────────────────────────────────────                      │
│  INSERT INTO Table...                                           │
│  PRINT 'Checking...'    ← @@ERROR already reset to 0!           │
│  IF @@ERROR <> 0...     ← Too late, always sees 0               │
│                                                                 │
│  Problem 2: Code still crashes on severe errors                 │
│  ─────────────────────────────────────────────                  │
│  Some errors stop execution immediately                         │
│  @@ERROR check never runs                                       │
│                                                                 │
│  Better Solution: TRY...CATCH (next lesson!)                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Part 2: The RAISERROR Statement

### What is RAISERROR?

`RAISERROR` lets you **create your own error messages**. It's like raising a flag to say "Something's wrong!"

### Basic Syntax:

```sql
RAISERROR ('Your error message', severity, state);
```

- **Message**: What you want to say
- **Severity**: How serious (1-25, use 16 for regular errors)
- **State**: A number you choose (use 1 for now)

### Example 2.1: Simple RAISERROR

```sql
-- Check a business rule
DECLARE @Salary DECIMAL = -5000;

IF @Salary < 0
BEGIN
    RAISERROR ('Salary cannot be negative!', 16, 1);
END
ELSE
BEGIN
    PRINT 'Salary is valid';
END
```

**Output:**
```
Msg 50000, Level 16, State 1, Line 6
Salary cannot be negative!
```

### Example 2.2: RAISERROR with Variables

```sql
-- Include details in the message
DECLARE @EmployeeID INT = 9999;
DECLARE @Message VARCHAR(200);

-- Check if employee exists
IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
BEGIN
    SET @Message = 'Employee ID ' + CAST(@EmployeeID AS VARCHAR) + ' was not found!';
    RAISERROR (@Message, 16, 1);
END
```

### Example 2.3: RAISERROR with Parameters

```sql
-- Use format placeholders: %s for strings, %d for integers
DECLARE @EmpName VARCHAR(50) = 'John';
DECLARE @DeptID INT = 999;

RAISERROR ('Employee %s cannot be assigned to department %d - department not found!', 
           16, 1, @EmpName, @DeptID);
```

**Output:**
```
Msg 50000, Level 16, State 1, Line 5
Employee John cannot be assigned to department 999 - department not found!
```

---

## 🎓 Part 3: Severity Levels Explained

### What Do the Numbers Mean?

```
┌─────────────────────────────────────────────────────────────────┐
│                    ERROR SEVERITY LEVELS                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Severity 1-10: Information / Warnings                          │
│  ─────────────────────────────────────                          │
│  • Just messages, not real errors                               │
│  • Code continues running                                       │
│  • Example: "Row count: 50 rows affected"                       │
│                                                                 │
│  Severity 11-16: User-Correctable Errors  ⭐ MOST COMMON        │
│  ─────────────────────────────────────────                      │
│  • Something the user did wrong                                 │
│  • Invalid data, missing info, etc.                             │
│  • Example: "Employee ID not found"                             │
│                                                                 │
│  Severity 17-19: Resource Errors                                │
│  ───────────────────────────────                                │
│  • Database problems (disk full, etc.)                          │
│  • Requires admin attention                                     │
│                                                                 │
│  Severity 20-25: Fatal Errors                                   │
│  ────────────────────────────                                   │
│  • Serious problems                                             │
│  • Connection may be terminated                                 │
│  • Requires immediate attention                                 │
│                                                                 │
│  💡 For normal business errors, use severity 16                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Example 3.1: Different Severity Levels

```sql
-- Informational (doesn't stop code)
RAISERROR ('Just so you know: this is informational', 10, 1);
PRINT 'Code continues after severity 10';

-- Real error (typically caught by TRY...CATCH)
RAISERROR ('This is a real error!', 16, 1);
PRINT 'Code may or may not continue after severity 16';
```

---

## 🎓 Part 4: Error Information Functions

### Built-in Functions for Error Details

When an error occurs, SQL Server provides these functions:

| Function | Returns | Example |
|----------|---------|---------|
| `ERROR_NUMBER()` | Error number | 515 |
| `ERROR_MESSAGE()` | Error description | "Cannot insert NULL..." |
| `ERROR_SEVERITY()` | Severity level | 16 |
| `ERROR_STATE()` | Error state | 1 |
| `ERROR_LINE()` | Line number where error occurred | 25 |
| `ERROR_PROCEDURE()` | Procedure name (if in one) | "usp_InsertEmployee" |

### Example 4.1: Using Error Functions

```sql
-- These are most useful inside TRY...CATCH blocks (next lesson)
-- For now, let's see what they return after an error:

BEGIN TRY
    -- Force an error
    SELECT 1/0;
END TRY
BEGIN CATCH
    -- Get all error details
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS Severity,
        ERROR_STATE() AS State,
        ERROR_LINE() AS LineNumber;
END CATCH
```

**Result:**
| ErrorNumber | ErrorMessage | Severity | State | LineNumber |
|-------------|--------------|----------|-------|------------|
| 8134 | Divide by zero error encountered | 16 | 1 | 4 |

---

## 🎓 Part 5: Basic Error Handling Patterns

### Pattern 1: Validate Before You Act

```sql
-- GOOD: Check first, act second
DECLARE @DeptID INT = 2001;
DECLARE @NewBudget DECIMAL = 1000000;

-- Check if department exists
IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @DeptID)
BEGIN
    RAISERROR ('Department %d does not exist', 16, 1, @DeptID);
    RETURN;  -- Stop here
END

-- Safe to update
UPDATE Departments 
SET Budget = @NewBudget 
WHERE DepartmentID = @DeptID;

PRINT 'Budget updated successfully!';
```

### Pattern 2: Save @@ERROR Immediately

```sql
-- Save the error before it resets
DECLARE @ErrorSave INT;

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES (9999, 'Test', 'User', 2001);

SET @ErrorSave = @@ERROR;  -- Save it right away!

IF @ErrorSave <> 0
BEGIN
    PRINT 'Insert failed with error: ' + CAST(@ErrorSave AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Insert successful!';
END
```

### Pattern 3: Check Multiple Conditions

```sql
-- Comprehensive validation
DECLARE @EmployeeID INT = 3001;
DECLARE @NewSalary DECIMAL = 150000;
DECLARE @MaxAllowed DECIMAL = 200000;

-- Check 1: Employee exists?
IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
BEGIN
    RAISERROR ('Employee %d not found', 16, 1, @EmployeeID);
    RETURN;
END

-- Check 2: Salary within limits?
IF @NewSalary > @MaxAllowed
BEGIN
    RAISERROR ('Salary $%d exceeds maximum allowed ($%d)', 16, 1, 
               @NewSalary, @MaxAllowed);
    RETURN;
END

-- Check 3: Salary positive?
IF @NewSalary < 0
BEGIN
    RAISERROR ('Salary cannot be negative', 16, 1);
    RETURN;
END

-- All checks passed - safe to update
UPDATE Employees SET BaseSalary = @NewSalary WHERE EmployeeID = @EmployeeID;
PRINT 'Salary updated successfully!';
```

---

## 📊 Visual Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                 ERROR HANDLING BASICS                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Method 1: @@ERROR (Old Way)                                    │
│  ──────────────────────────                                     │
│  INSERT INTO...                                                 │
│  IF @@ERROR <> 0    ← Check immediately!                        │
│      PRINT 'Error!'                                             │
│                                                                 │
│  Method 2: RAISERROR (Create Your Own Errors)                   │
│  ────────────────────────────────────────────                   │
│  IF @Value < 0                                                  │
│      RAISERROR('Value cannot be negative', 16, 1);              │
│                                                                 │
│  Method 3: Validate First (Best Practice)                       │
│  ─────────────────────────────────────────                      │
│  IF NOT EXISTS (...)                                            │
│  BEGIN                                                          │
│      RAISERROR('Record not found', 16, 1);                      │
│      RETURN;                                                    │
│  END                                                            │
│  -- Now safe to proceed                                         │
│                                                                 │
│  💡 Next Lesson: TRY...CATCH (Modern Way!)                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Basic @@ERROR Check (Easy)

Write code that checks for an error after an INSERT:

```sql
-- Your solution:
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (2001, 'Test');  -- Might fail if duplicate

IF @@ERROR <> 0
    PRINT 'Insert failed - department may already exist';
ELSE
    PRINT 'Insert succeeded';
```

### Exercise 2: Simple RAISERROR (Easy)

Create a validation that raises an error if salary is too low:

```sql
-- Your solution:
DECLARE @Salary DECIMAL = 15000;
DECLARE @MinWage DECIMAL = 30000;

IF @Salary < @MinWage
    RAISERROR ('Salary $%d is below minimum wage of $%d', 16, 1, 
               @Salary, @MinWage);
ELSE
    PRINT 'Salary is acceptable';
```

### Exercise 3: Validate Before Insert (Medium)

Check if a department exists before inserting an employee:

```sql
-- Your solution:
DECLARE @EmpID INT = 9999;
DECLARE @DeptID INT = 9999;  -- Non-existent department

IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @DeptID)
BEGIN
    RAISERROR ('Cannot add employee - department %d does not exist', 16, 1, @DeptID);
END
ELSE
BEGIN
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
    VALUES (@EmpID, 'Test', 'User', @DeptID);
    PRINT 'Employee added';
END
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ @@ERROR holds the error number (0 = success)                │
│                                                                 │
│  ✅ @@ERROR resets after each statement - check immediately!    │
│                                                                 │
│  ✅ RAISERROR creates custom error messages                     │
│                                                                 │
│  ✅ Use severity 16 for regular business errors                 │
│                                                                 │
│  ✅ Error functions (ERROR_NUMBER, etc.) give details           │
│                                                                 │
│  ✅ Validate data BEFORE doing operations                       │
│                                                                 │
│  💡 TRY...CATCH is the modern, better way (next lesson!)        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📖 Quick Reference

```sql
-- Check @@ERROR
IF @@ERROR <> 0
    PRINT 'Error occurred';

-- Raise your own error
RAISERROR ('Your message here', 16, 1);

-- With variables
RAISERROR ('ID %d not found', 16, 1, @ID);

-- Error information functions
ERROR_NUMBER()     -- Error code
ERROR_MESSAGE()    -- Description
ERROR_SEVERITY()   -- Severity level
ERROR_LINE()       -- Line number
```

---

## 🚀 What's Next?

In the next lesson, you'll learn **TRY...CATCH** - the modern way to handle errors:

```sql
BEGIN TRY
    -- Code that might fail
    INSERT INTO...
END TRY
BEGIN CATCH
    -- What to do if it fails
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
```

This is much cleaner and more powerful than @@ERROR!
