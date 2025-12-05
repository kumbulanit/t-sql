# Lesson 2: Implementing Structured Exception Handling (TRY...CATCH) - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome to the **modern way** of handling errors in T-SQL! TRY...CATCH is cleaner, more powerful, and easier to understand than the old @@ERROR method. Let's master it!

---

## 📖 What is TRY...CATCH? (The Simple Explanation)

### Real-World Analogy: The Safety Parachute 🪂

When skydivers jump:
1. They **TRY** to land with their main parachute
2. If something goes wrong, they **CATCH** the problem with a backup parachute

TRY...CATCH works the same way:
1. Put your code in **TRY** (the main parachute)
2. If it fails, **CATCH** handles the problem (the backup)

```
┌─────────────────────────────────────────────────────────────────┐
│                    TRY...CATCH EXPLAINED                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BEGIN TRY                                                      │
│      ┌─────────────────────────────────────────┐                │
│      │ Your normal code goes here              │                │
│      │ • SELECT, INSERT, UPDATE, DELETE        │                │
│      │ • If it works = great, skip CATCH       │                │
│      │ • If it fails = jump to CATCH block     │                │
│      └─────────────────────────────────────────┘                │
│  END TRY                                                        │
│                                                                 │
│  BEGIN CATCH                                                    │
│      ┌─────────────────────────────────────────┐                │
│      │ Error handling goes here                │                │
│      │ • Print error message                   │                │
│      │ • Log the error                         │                │
│      │ • Roll back transaction                 │                │
│      │ • Take corrective action                │                │
│      └─────────────────────────────────────────┘                │
│  END CATCH                                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 The Basic Structure

```sql
BEGIN TRY
    -- Code that might cause an error
    -- If successful, CATCH is skipped
END TRY
BEGIN CATCH
    -- Code to handle the error
    -- Only runs if TRY block fails
END CATCH
```

**That's it!** Simple and clean.

---

## 🎓 Part 1: Your First TRY...CATCH

### Example 1.1: Catching a Divide by Zero

```sql
BEGIN TRY
    -- This will cause an error!
    PRINT 'Trying to divide...';
    SELECT 100 / 0 AS Result;
    PRINT 'Division successful!';  -- Never runs
END TRY
BEGIN CATCH
    -- This runs when the error occurs
    PRINT 'Oops! An error occurred:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT 'Code continues after TRY...CATCH!';
```

**Output:**
```
Trying to divide...
Oops! An error occurred:
Divide by zero error encountered.
Code continues after TRY...CATCH!
```

**Notice:** The code keeps running after the CATCH block!

---

### Example 1.2: Successful TRY (No Error)

```sql
BEGIN TRY
    -- This will work fine
    PRINT 'Starting calculation...';
    SELECT 100 / 5 AS Result;  -- = 20
    PRINT 'Calculation successful!';
END TRY
BEGIN CATCH
    -- This NEVER runs because there was no error
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

PRINT 'Done!';
```

**Output:**
```
Starting calculation...
Result: 20
Calculation successful!
Done!
```

---

## 🎓 Part 2: Getting Error Information

### Error Functions Review

Inside a CATCH block, you can use these functions:

| Function | What It Returns |
|----------|-----------------|
| `ERROR_NUMBER()` | The error code (like 8134) |
| `ERROR_MESSAGE()` | Human-readable description |
| `ERROR_SEVERITY()` | How serious (1-25) |
| `ERROR_STATE()` | Additional info code |
| `ERROR_LINE()` | Line number where error occurred |
| `ERROR_PROCEDURE()` | Procedure name (if applicable) |

### Example 2.1: Full Error Details

```sql
BEGIN TRY
    -- Force an error
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
    VALUES (3001, 'Test', 'User', 9999);  -- Invalid department!
END TRY
BEGIN CATCH
    -- Get ALL error details
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS Severity,
        ERROR_STATE() AS State,
        ERROR_LINE() AS LineNumber,
        COALESCE(ERROR_PROCEDURE(), 'N/A') AS ProcedureName;
END CATCH
```

### Example 2.2: Formatted Error Message

```sql
BEGIN TRY
    -- Try something that might fail
    DELETE FROM Departments WHERE DepartmentID = 9999;
    
    -- Check if anything was deleted
    IF @@ROWCOUNT = 0
        RAISERROR('No department found with that ID', 16, 1);
END TRY
BEGIN CATCH
    PRINT '========================================';
    PRINT 'ERROR REPORT';
    PRINT '========================================';
    PRINT 'Error #: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Message: ' + ERROR_MESSAGE();
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT '========================================';
END CATCH
```

---

## 🎓 Part 3: TRY...CATCH with Transactions

### Why Combine Them?

When you do multiple operations that should succeed or fail **together**, use transactions:

```
┌─────────────────────────────────────────────────────────────────┐
│               TRY...CATCH + TRANSACTIONS                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Scenario: Transfer $1000 between accounts                      │
│                                                                 │
│  Step 1: Subtract $1000 from Account A                          │
│  Step 2: Add $1000 to Account B                                 │
│                                                                 │
│  What if Step 1 works but Step 2 fails?                         │
│  ❌ $1000 disappears! (Bad!)                                    │
│                                                                 │
│  Solution: Transaction with TRY...CATCH                         │
│  ✅ If anything fails, undo everything (ROLLBACK)               │
│  ✅ Only commit if ALL steps succeed                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Example 3.1: Safe Transaction Pattern

```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Operation 1: Update department budget
    UPDATE Departments 
    SET Budget = Budget - 50000 
    WHERE DepartmentID = 2001;
    
    -- Operation 2: Insert audit record
    INSERT INTO AuditLog (Action, Details, ActionDate)
    VALUES ('Budget Change', 'Reduced Engineering budget by $50,000', GETDATE());
    
    -- If we get here, both worked!
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully!';
    
END TRY
BEGIN CATCH
    -- Something failed - undo everything!
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    -- Report the error
    PRINT 'Transaction failed and rolled back!';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
```

### Example 3.2: Employee Transfer with Full Error Handling

```sql
-- Transfer an employee to a new department
CREATE OR ALTER PROCEDURE usp_TransferEmployee
    @EmployeeID INT,
    @NewDepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate employee exists
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            RAISERROR('Employee %d not found', 16, 1, @EmployeeID);
        END
        
        -- Validate department exists
        IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @NewDepartmentID)
        BEGIN
            RAISERROR('Department %d not found', 16, 1, @NewDepartmentID);
        END
        
        -- Do the transfer
        UPDATE Employees 
        SET DepartmentID = @NewDepartmentID 
        WHERE EmployeeID = @EmployeeID;
        
        -- Success!
        COMMIT TRANSACTION;
        PRINT 'Employee transferred successfully!';
        
    END TRY
    BEGIN CATCH
        -- Undo if needed
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Report error
        PRINT 'Transfer failed: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test it
EXEC usp_TransferEmployee @EmployeeID = 3001, @NewDepartmentID = 2002;
```

---

## 🎓 Part 4: Re-Throwing Errors

### Using THROW (SQL Server 2012+)

Sometimes you want to catch an error, do something (like logging), and then **pass the error along** to the caller.

### Example 4.1: Simple THROW

```sql
BEGIN TRY
    SELECT 1/0;  -- Error!
END TRY
BEGIN CATCH
    PRINT 'Logging the error...';
    -- Re-throw the same error
    THROW;
END CATCH
```

### Example 4.2: Custom THROW

```sql
-- Create your own error
BEGIN TRY
    DECLARE @Age INT = -5;
    
    IF @Age < 0
    BEGIN
        THROW 50001, 'Age cannot be negative!', 1;
    END
END TRY
BEGIN CATCH
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH
```

---

## 🎓 Part 5: Logging Errors

### Create an Error Log Table

```sql
-- Create a table to store errors
CREATE TABLE ErrorLog (
    ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorNumber INT,
    ErrorMessage NVARCHAR(4000),
    ErrorSeverity INT,
    ErrorState INT,
    ErrorLine INT,
    ErrorProcedure NVARCHAR(128),
    UserName NVARCHAR(128),
    ErrorDate DATETIME DEFAULT GETDATE()
);
```

### Example 5.1: Logging Procedure

```sql
-- Procedure to log errors
CREATE OR ALTER PROCEDURE usp_LogError
AS
BEGIN
    INSERT INTO ErrorLog (
        ErrorNumber,
        ErrorMessage,
        ErrorSeverity,
        ErrorState,
        ErrorLine,
        ErrorProcedure,
        UserName
    )
    VALUES (
        ERROR_NUMBER(),
        ERROR_MESSAGE(),
        ERROR_SEVERITY(),
        ERROR_STATE(),
        ERROR_LINE(),
        ERROR_PROCEDURE(),
        SYSTEM_USER
    );
END;
GO
```

### Example 5.2: Using the Logger

```sql
BEGIN TRY
    -- Some risky operation
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
    VALUES (3001, 'Test', 'User', 9999);  -- Will fail!
END TRY
BEGIN CATCH
    -- Log the error first
    EXEC usp_LogError;
    
    -- Then report it
    PRINT 'An error occurred and was logged.';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

-- Check the log
SELECT TOP 5 * FROM ErrorLog ORDER BY ErrorDate DESC;
```

---

## 📊 Complete Pattern Template

```sql
-- ============================================
-- PROFESSIONAL ERROR HANDLING TEMPLATE
-- ============================================
CREATE OR ALTER PROCEDURE usp_YourProcedureName
    @Parameter1 INT,
    @Parameter2 VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Start transaction if needed
        BEGIN TRANSACTION;
        
        -- =============================
        -- INPUT VALIDATION
        -- =============================
        IF @Parameter1 IS NULL
        BEGIN
            RAISERROR('Parameter1 is required', 16, 1);
        END
        
        -- =============================
        -- MAIN BUSINESS LOGIC
        -- =============================
        -- Your SQL operations here...
        
        -- =============================
        -- SUCCESS - COMMIT
        -- =============================
        COMMIT TRANSACTION;
        
        PRINT 'Operation completed successfully!';
        
    END TRY
    BEGIN CATCH
        -- =============================
        -- ERROR - ROLLBACK
        -- =============================
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Log the error (optional)
        -- EXEC usp_LogError;
        
        -- Report error details
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSev INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Re-raise the error
        RAISERROR(@ErrorMsg, @ErrorSev, @ErrorState);
        
    END CATCH
END;
```

---

## 📊 Visual Flow

```
┌─────────────────────────────────────────────────────────────────┐
│               TRY...CATCH EXECUTION FLOW                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  START                                                          │
│    │                                                            │
│    ▼                                                            │
│  ┌─────────────┐                                                │
│  │ BEGIN TRY   │                                                │
│  └─────────────┘                                                │
│    │                                                            │
│    ▼                                                            │
│  ┌─────────────────────────┐                                    │
│  │ Execute SQL statements  │                                    │
│  └─────────────────────────┘                                    │
│    │                                                            │
│    │  Error?                                                    │
│    ├─── NO ──► Skip CATCH ─► Continue after END CATCH           │
│    │                                                            │
│    └─── YES ──► Jump to CATCH block                             │
│                    │                                            │
│                    ▼                                            │
│                ┌─────────────┐                                  │
│                │ BEGIN CATCH │                                  │
│                └─────────────┘                                  │
│                    │                                            │
│                    ▼                                            │
│                ┌─────────────────────────┐                      │
│                │ Handle error:           │                      │
│                │ • ROLLBACK transaction  │                      │
│                │ • Log error             │                      │
│                │ • Report to user        │                      │
│                └─────────────────────────┘                      │
│                    │                                            │
│                    ▼                                            │
│                Continue after END CATCH                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Basic TRY...CATCH (Easy)

Write a TRY...CATCH that handles a divide by zero:

```sql
-- Your solution:
BEGIN TRY
    DECLARE @Result INT;
    SET @Result = 100 / 0;
    PRINT 'Result: ' + CAST(@Result AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Error caught: ' + ERROR_MESSAGE();
END CATCH
```

### Exercise 2: Display Error Details (Easy)

Catch an error and display all error information:

```sql
-- Your solution:
BEGIN TRY
    -- Force a constraint error
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
    VALUES (NULL, 'Test', 'User', 2001);  -- NULL in required field
END TRY
BEGIN CATCH
    SELECT 
        'Error Details' AS Info,
        ERROR_NUMBER() AS Number,
        ERROR_MESSAGE() AS Message,
        ERROR_SEVERITY() AS Severity,
        ERROR_LINE() AS Line;
END CATCH
```

### Exercise 3: Transaction with TRY...CATCH (Medium)

Wrap a multi-step operation in a transaction:

```sql
-- Your solution:
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Step 1
    UPDATE Departments SET Budget = Budget + 10000 WHERE DepartmentID = 2001;
    
    -- Step 2 (force an error for testing)
    -- UPDATE Departments SET Budget = Budget / 0 WHERE DepartmentID = 2002;
    
    COMMIT TRANSACTION;
    PRINT 'Both updates succeeded!';
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Updates rolled back due to error:';
    PRINT ERROR_MESSAGE();
END CATCH
```

### Exercise 4: Custom Validation with THROW (Hard)

Create a procedure that validates input and throws custom errors:

```sql
-- Your solution:
CREATE OR ALTER PROCEDURE usp_ValidateSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        -- Validation 1: Employee exists?
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
            THROW 50001, 'Employee not found', 1;
        
        -- Validation 2: Salary positive?
        IF @NewSalary <= 0
            THROW 50002, 'Salary must be positive', 1;
        
        -- Validation 3: Salary not too high?
        IF @NewSalary > 500000
            THROW 50003, 'Salary exceeds maximum allowed', 1;
        
        -- All validations passed
        UPDATE Employees SET BaseSalary = @NewSalary WHERE EmployeeID = @EmployeeID;
        PRINT 'Salary updated successfully!';
        
    END TRY
    BEGIN CATCH
        PRINT 'Validation failed: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test
EXEC usp_ValidateSalary @EmployeeID = 9999, @NewSalary = 50000;  -- Employee not found
EXEC usp_ValidateSalary @EmployeeID = 3001, @NewSalary = -1000;  -- Negative salary
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ TRY block = Code that might fail                            │
│                                                                 │
│  ✅ CATCH block = Code to handle failures                       │
│                                                                 │
│  ✅ If TRY succeeds, CATCH is skipped                           │
│                                                                 │
│  ✅ If TRY fails, immediately jump to CATCH                     │
│                                                                 │
│  ✅ Use ERROR_MESSAGE(), ERROR_NUMBER(), etc. in CATCH          │
│                                                                 │
│  ✅ Always ROLLBACK transactions in CATCH block                 │
│                                                                 │
│  ✅ Use THROW to re-raise or create custom errors               │
│                                                                 │
│  ✅ Log errors for later troubleshooting                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📖 Quick Reference

```sql
-- Basic TRY...CATCH
BEGIN TRY
    -- Risky code
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

-- With Transaction
BEGIN TRY
    BEGIN TRANSACTION;
    -- Operations
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    -- Handle error
END CATCH

-- Error Functions
ERROR_NUMBER()     -- Error code
ERROR_MESSAGE()    -- Description
ERROR_SEVERITY()   -- Severity level
ERROR_LINE()       -- Line number
ERROR_PROCEDURE()  -- Procedure name

-- THROW (custom error)
THROW 50001, 'My error message', 1;

-- Re-throw current error
THROW;
```

---

## 🏆 Module 17 Complete!

Congratulations! You've mastered error handling:

1. **@@ERROR** - The old way to check for errors
2. **RAISERROR** - Create custom error messages
3. **TRY...CATCH** - Modern structured error handling
4. **Transactions** - Combine with TRY...CATCH for safety
5. **Error Logging** - Track problems for troubleshooting
6. **THROW** - Re-raise or create errors

Your SQL code is now much more robust and professional!
