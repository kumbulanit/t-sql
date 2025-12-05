# Lab: Implementing Error Handling - Beginner Lab

## 🎯 Lab Overview

Welcome to the hands-on lab for Module 17! In this lab, you'll practice:
- Using @@ERROR for basic error checking
- Creating custom errors with RAISERROR
- Implementing TRY...CATCH blocks
- Combining transactions with error handling
- Logging errors to a table
- Using THROW for error management

**Estimated Time:** 45-60 minutes

---

## 📋 Prerequisites

Before starting this lab, you should:
- Have access to the TechCorpDB database
- Understand basic SQL operations (SELECT, INSERT, UPDATE)
- Have completed the lessons in this module

---

## 🗃️ Lab Setup

Run this setup script to create the necessary tables and sample data:

```sql
-- ============================================
-- LAB SETUP: Creating Error Handling Practice Environment
-- ============================================

USE TechCorpDB;
GO

-- Create Error Log table
IF OBJECT_ID('ErrorLog', 'U') IS NOT NULL
    DROP TABLE ErrorLog;
GO

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
GO

-- Create a test table for exercises
IF OBJECT_ID('TestProducts', 'U') IS NOT NULL
    DROP TABLE TestProducts;
GO

CREATE TABLE TestProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    UnitsInStock INT NOT NULL CHECK (UnitsInStock >= 0)
);
GO

-- Insert sample data
INSERT INTO TestProducts VALUES (1, 'Widget A', 25.99, 100);
INSERT INTO TestProducts VALUES (2, 'Widget B', 35.50, 50);
INSERT INTO TestProducts VALUES (3, 'Gadget X', 99.99, 25);
GO

-- Create test account table
IF OBJECT_ID('BankAccounts', 'U') IS NOT NULL
    DROP TABLE BankAccounts;
GO

CREATE TABLE BankAccounts (
    AccountID INT PRIMARY KEY,
    AccountName VARCHAR(100),
    Balance DECIMAL(15,2) NOT NULL CHECK (Balance >= 0)
);
GO

INSERT INTO BankAccounts VALUES (1001, 'Savings Account', 5000.00);
INSERT INTO BankAccounts VALUES (1002, 'Checking Account', 2500.00);
GO

PRINT 'Lab setup complete!';
GO
```

---

## 📝 Part 1: Basic @@ERROR Exercises

### Exercise 1.1: Check for Errors After INSERT (Easy)

**Goal:** Use @@ERROR to detect when an INSERT fails.

**Task:** Try to insert a duplicate product and check for errors.

```sql
-- Try to insert a duplicate ProductID (will fail)
INSERT INTO TestProducts (ProductID, ProductName, UnitPrice, UnitsInStock)
VALUES (1, 'Duplicate Widget', 10.00, 50);

-- Check for error - fill in the blank
IF @@ERROR _____ 0
    PRINT 'Insert failed - product ID already exists!';
ELSE
    PRINT 'Insert succeeded!';
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Try to insert a duplicate ProductID (will fail)
INSERT INTO TestProducts (ProductID, ProductName, UnitPrice, UnitsInStock)
VALUES (1, 'Duplicate Widget', 10.00, 50);

-- Check for error
IF @@ERROR <> 0
    PRINT 'Insert failed - product ID already exists!';
ELSE
    PRINT 'Insert succeeded!';
```

</details>

---

### Exercise 1.2: Save @@ERROR Before It Resets (Easy)

**Goal:** Learn to save @@ERROR immediately.

**Task:** Save the error number and use it in a later condition.

```sql
DECLARE @ErrorCode INT;

-- Try invalid update (negative price violates constraint)
UPDATE TestProducts SET UnitPrice = -10 WHERE ProductID = 1;

-- Save error immediately
SET @ErrorCode = ___________;

-- Now we can use it safely
IF @ErrorCode <> 0
BEGIN
    PRINT 'Update failed with error code: ' + CAST(@ErrorCode AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Update successful!';
END
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @ErrorCode INT;

-- Try invalid update (negative price violates constraint)
UPDATE TestProducts SET UnitPrice = -10 WHERE ProductID = 1;

-- Save error immediately
SET @ErrorCode = @@ERROR;

-- Now we can use it safely
IF @ErrorCode <> 0
BEGIN
    PRINT 'Update failed with error code: ' + CAST(@ErrorCode AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Update successful!';
END
```

</details>

---

## 📝 Part 2: RAISERROR Exercises

### Exercise 2.1: Simple Custom Error (Easy)

**Goal:** Create a simple custom error message.

**Task:** Raise an error if a quantity is less than 1.

```sql
DECLARE @OrderQty INT = 0;

IF @OrderQty < 1
BEGIN
    RAISERROR ('___________________________________', 16, 1);
END
ELSE
BEGIN
    PRINT 'Order quantity is valid: ' + CAST(@OrderQty AS VARCHAR);
END
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @OrderQty INT = 0;

IF @OrderQty < 1
BEGIN
    RAISERROR ('Order quantity must be at least 1!', 16, 1);
END
ELSE
BEGIN
    PRINT 'Order quantity is valid: ' + CAST(@OrderQty AS VARCHAR);
END
```

</details>

---

### Exercise 2.2: RAISERROR with Parameters (Medium)

**Goal:** Include variable values in error messages.

**Task:** Create an error message that includes the product ID and requested quantity.

```sql
DECLARE @ProductID INT = 3;
DECLARE @RequestedQty INT = 100;
DECLARE @AvailableQty INT;

-- Get available quantity
SELECT @AvailableQty = UnitsInStock FROM TestProducts WHERE ProductID = @ProductID;

-- Check if enough stock
IF @RequestedQty > @AvailableQty
BEGIN
    RAISERROR ('Cannot order %d units of Product %d. Only %d available.', 
               16, 1, __________, __________, __________);
END
ELSE
BEGIN
    PRINT 'Order can be fulfilled!';
END
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @ProductID INT = 3;
DECLARE @RequestedQty INT = 100;
DECLARE @AvailableQty INT;

-- Get available quantity
SELECT @AvailableQty = UnitsInStock FROM TestProducts WHERE ProductID = @ProductID;

-- Check if enough stock
IF @RequestedQty > @AvailableQty
BEGIN
    RAISERROR ('Cannot order %d units of Product %d. Only %d available.', 
               16, 1, @RequestedQty, @ProductID, @AvailableQty);
END
ELSE
BEGIN
    PRINT 'Order can be fulfilled!';
END
```

</details>

---

### Exercise 2.3: Validation with Multiple Checks (Medium)

**Goal:** Perform multiple validations before proceeding.

**Task:** Validate a new product before inserting it.

```sql
DECLARE @NewID INT = 5;
DECLARE @NewName VARCHAR(100) = '';  -- Empty name (invalid)
DECLARE @NewPrice DECIMAL(10,2) = -5.00;  -- Negative (invalid)

-- Validation 1: Product ID doesn't already exist
IF EXISTS (SELECT 1 FROM TestProducts WHERE ProductID = @NewID)
BEGIN
    RAISERROR ('Product ID %d already exists!', 16, 1, @NewID);
    RETURN;
END

-- Validation 2: Name is not empty
IF LEN(LTRIM(@NewName)) = 0
BEGIN
    RAISERROR ('__________________________________', 16, 1);
    RETURN;
END

-- Validation 3: Price is positive
IF @NewPrice <= 0
BEGIN
    RAISERROR ('__________________________________', 16, 1);
    RETURN;
END

-- All validations passed
INSERT INTO TestProducts VALUES (@NewID, @NewName, @NewPrice, 0);
PRINT 'Product inserted successfully!';
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @NewID INT = 5;
DECLARE @NewName VARCHAR(100) = '';  -- Empty name (invalid)
DECLARE @NewPrice DECIMAL(10,2) = -5.00;  -- Negative (invalid)

-- Validation 1: Product ID doesn't already exist
IF EXISTS (SELECT 1 FROM TestProducts WHERE ProductID = @NewID)
BEGIN
    RAISERROR ('Product ID %d already exists!', 16, 1, @NewID);
    RETURN;
END

-- Validation 2: Name is not empty
IF LEN(LTRIM(@NewName)) = 0
BEGIN
    RAISERROR ('Product name cannot be empty!', 16, 1);
    RETURN;
END

-- Validation 3: Price is positive
IF @NewPrice <= 0
BEGIN
    RAISERROR ('Product price must be positive!', 16, 1);
    RETURN;
END

-- All validations passed
INSERT INTO TestProducts VALUES (@NewID, @NewName, @NewPrice, 0);
PRINT 'Product inserted successfully!';
```

</details>

---

## 📝 Part 3: TRY...CATCH Exercises

### Exercise 3.1: Basic TRY...CATCH (Easy)

**Goal:** Catch a divide by zero error.

**Task:** Complete the TRY...CATCH block.

```sql
BEGIN _____
    DECLARE @Total INT = 100;
    DECLARE @Count INT = 0;
    DECLARE @Average INT;
    
    SET @Average = @Total / @Count;  -- Will cause divide by zero!
    PRINT 'Average: ' + CAST(@Average AS VARCHAR);
END _____
BEGIN _____
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END _____
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    DECLARE @Total INT = 100;
    DECLARE @Count INT = 0;
    DECLARE @Average INT;
    
    SET @Average = @Total / @Count;  -- Will cause divide by zero!
    PRINT 'Average: ' + CAST(@Average AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH
```

</details>

---

### Exercise 3.2: Get All Error Information (Easy)

**Goal:** Retrieve all error details in a CATCH block.

**Task:** Display comprehensive error information.

```sql
BEGIN TRY
    -- Force a constraint violation
    UPDATE TestProducts SET UnitsInStock = -50 WHERE ProductID = 1;
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS _________,
        ERROR_MESSAGE() AS _________,
        ERROR_SEVERITY() AS _________,
        ERROR_STATE() AS _________,
        ERROR_LINE() AS _________;
END CATCH
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    -- Force a constraint violation
    UPDATE TestProducts SET UnitsInStock = -50 WHERE ProductID = 1;
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS Severity,
        ERROR_STATE() AS State,
        ERROR_LINE() AS LineNumber;
END CATCH
```

</details>

---

### Exercise 3.3: TRY...CATCH with Conditional Handling (Medium)

**Goal:** Handle different types of errors differently.

**Task:** Check the error number and provide appropriate messages.

```sql
BEGIN TRY
    -- Try to insert duplicate (will fail)
    INSERT INTO TestProducts VALUES (1, 'Test', 10.00, 5);
END TRY
BEGIN CATCH
    DECLARE @ErrNum INT = ERROR_NUMBER();
    
    IF @ErrNum = 2627  -- Duplicate key violation
        PRINT 'Error: A product with that ID already exists!';
    ELSE IF @ErrNum = 547  -- Constraint violation
        PRINT 'Error: Data violates a constraint!';
    ELSE
        PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
```

Now try triggering a different error:

```sql
BEGIN TRY
    -- Try to violate check constraint
    UPDATE TestProducts SET UnitPrice = -100 WHERE ProductID = 1;
END TRY
BEGIN CATCH
    DECLARE @ErrNum INT = ____________;
    
    IF @ErrNum = 2627
        PRINT 'Error: A product with that ID already exists!';
    ELSE IF @ErrNum = 547
        PRINT 'Error: Data violates a constraint!';
    ELSE
        PRINT 'Error: ' + ____________;
END CATCH
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    -- Try to violate check constraint
    UPDATE TestProducts SET UnitPrice = -100 WHERE ProductID = 1;
END TRY
BEGIN CATCH
    DECLARE @ErrNum INT = ERROR_NUMBER();
    
    IF @ErrNum = 2627
        PRINT 'Error: A product with that ID already exists!';
    ELSE IF @ErrNum = 547
        PRINT 'Error: Data violates a constraint!';
    ELSE
        PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
```

</details>

---

## 📝 Part 4: Transactions with TRY...CATCH

### Exercise 4.1: Safe Transaction Pattern (Medium)

**Goal:** Implement a transaction that rolls back on error.

**Task:** Complete the transaction handling.

```sql
BEGIN TRY
    BEGIN ___________;
    
    -- Update product price
    UPDATE TestProducts SET UnitPrice = UnitPrice * 1.10 WHERE ProductID = 1;
    
    -- Force an error (invalid stock value)
    UPDATE TestProducts SET UnitsInStock = -10 WHERE ProductID = 2;
    
    -- If we get here, commit
    ___________ TRANSACTION;
    PRINT 'All updates completed successfully!';
    
END TRY
BEGIN CATCH
    -- Check if transaction is still active
    IF @@TRANCOUNT > 0
        ___________ TRANSACTION;
    
    PRINT 'Error occurred - all changes rolled back!';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

-- Verify: prices should be unchanged
SELECT * FROM TestProducts;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Update product price
    UPDATE TestProducts SET UnitPrice = UnitPrice * 1.10 WHERE ProductID = 1;
    
    -- Force an error (invalid stock value)
    UPDATE TestProducts SET UnitsInStock = -10 WHERE ProductID = 2;
    
    -- If we get here, commit
    COMMIT TRANSACTION;
    PRINT 'All updates completed successfully!';
    
END TRY
BEGIN CATCH
    -- Check if transaction is still active
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Error occurred - all changes rolled back!';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

-- Verify: prices should be unchanged
SELECT * FROM TestProducts;
```

</details>

---

### Exercise 4.2: Bank Transfer with Error Handling (Hard)

**Goal:** Implement a money transfer that is completely safe.

**Task:** Create a transfer that either completes fully or not at all.

```sql
DECLARE @FromAccount INT = 1001;
DECLARE @ToAccount INT = 1002;
DECLARE @TransferAmount DECIMAL(15,2) = 1000.00;

-- Show starting balances
SELECT 'BEFORE' AS Status, * FROM BankAccounts;

BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Check if from account has enough balance
    DECLARE @CurrentBalance DECIMAL(15,2);
    SELECT @CurrentBalance = Balance FROM BankAccounts WHERE AccountID = @FromAccount;
    
    IF @CurrentBalance < @TransferAmount
    BEGIN
        RAISERROR ('Insufficient funds! Available: $%d, Requested: $%d', 
                   16, 1, @CurrentBalance, @TransferAmount);
    END
    
    -- Withdraw from source account
    UPDATE BankAccounts 
    SET Balance = Balance - @TransferAmount 
    WHERE AccountID = @___________;
    
    -- Deposit to destination account
    UPDATE BankAccounts 
    SET Balance = Balance + @TransferAmount 
    WHERE AccountID = @___________;
    
    -- Success!
    ___________ TRANSACTION;
    PRINT 'Transfer completed successfully!';
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ___________ TRANSACTION;
    
    PRINT 'Transfer failed: ' + ERROR_MESSAGE();
END CATCH

-- Show ending balances
SELECT 'AFTER' AS Status, * FROM BankAccounts;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
DECLARE @FromAccount INT = 1001;
DECLARE @ToAccount INT = 1002;
DECLARE @TransferAmount DECIMAL(15,2) = 1000.00;

-- Show starting balances
SELECT 'BEFORE' AS Status, * FROM BankAccounts;

BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Check if from account has enough balance
    DECLARE @CurrentBalance DECIMAL(15,2);
    SELECT @CurrentBalance = Balance FROM BankAccounts WHERE AccountID = @FromAccount;
    
    IF @CurrentBalance < @TransferAmount
    BEGIN
        RAISERROR ('Insufficient funds! Available: $%d, Requested: $%d', 
                   16, 1, @CurrentBalance, @TransferAmount);
    END
    
    -- Withdraw from source account
    UPDATE BankAccounts 
    SET Balance = Balance - @TransferAmount 
    WHERE AccountID = @FromAccount;
    
    -- Deposit to destination account
    UPDATE BankAccounts 
    SET Balance = Balance + @TransferAmount 
    WHERE AccountID = @ToAccount;
    
    -- Success!
    COMMIT TRANSACTION;
    PRINT 'Transfer completed successfully!';
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Transfer failed: ' + ERROR_MESSAGE();
END CATCH

-- Show ending balances
SELECT 'AFTER' AS Status, * FROM BankAccounts;
```

</details>

---

## 📝 Part 5: Error Logging

### Exercise 5.1: Create an Error Logging Procedure (Medium)

**Goal:** Create a reusable procedure to log errors.

**Task:** Complete the logging procedure.

```sql
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
        _____________(),
        _____________(),
        _____________(),
        _____________(),
        _____________(),
        _____________(),
        SYSTEM_USER
    );
END;
GO
```

<details>
<summary>💡 Click to see solution</summary>

```sql
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

</details>

---

### Exercise 5.2: Use the Error Logger (Medium)

**Goal:** Integrate error logging into TRY...CATCH.

**Task:** Log errors and then review the log.

```sql
-- Clear previous log entries
DELETE FROM ErrorLog;

-- Create some errors to log
BEGIN TRY
    SELECT 1/0;  -- Divide by zero
END TRY
BEGIN CATCH
    EXEC ______________;
    PRINT 'Error logged!';
END CATCH

BEGIN TRY
    INSERT INTO TestProducts VALUES (1, 'Duplicate', 10, 5);  -- Duplicate key
END TRY
BEGIN CATCH
    EXEC ______________;
    PRINT 'Error logged!';
END CATCH

-- View the error log
SELECT 
    ErrorLogID,
    ErrorNumber,
    ErrorMessage,
    ErrorDate
FROM ErrorLog
ORDER BY ErrorDate DESC;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Clear previous log entries
DELETE FROM ErrorLog;

-- Create some errors to log
BEGIN TRY
    SELECT 1/0;  -- Divide by zero
END TRY
BEGIN CATCH
    EXEC usp_LogError;
    PRINT 'Error logged!';
END CATCH

BEGIN TRY
    INSERT INTO TestProducts VALUES (1, 'Duplicate', 10, 5);  -- Duplicate key
END TRY
BEGIN CATCH
    EXEC usp_LogError;
    PRINT 'Error logged!';
END CATCH

-- View the error log
SELECT 
    ErrorLogID,
    ErrorNumber,
    ErrorMessage,
    ErrorDate
FROM ErrorLog
ORDER BY ErrorDate DESC;
```

</details>

---

## 📝 Part 6: THROW Exercises

### Exercise 6.1: Using THROW (Medium)

**Goal:** Use THROW to create custom errors.

**Task:** Create validation that uses THROW.

```sql
BEGIN TRY
    DECLARE @Age INT = -5;
    
    IF @Age < 0
        THROW _________, '________________', 1;
    
    IF @Age > 150
        THROW _________, '________________', 1;
    
    PRINT 'Age is valid: ' + CAST(@Age AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Validation error: ' + ERROR_MESSAGE();
    PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
END CATCH
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    DECLARE @Age INT = -5;
    
    IF @Age < 0
        THROW 50001, 'Age cannot be negative', 1;
    
    IF @Age > 150
        THROW 50002, 'Age cannot exceed 150', 1;
    
    PRINT 'Age is valid: ' + CAST(@Age AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Validation error: ' + ERROR_MESSAGE();
    PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
END CATCH
```

</details>

---

### Exercise 6.2: Re-throwing Errors (Hard)

**Goal:** Catch an error, log it, then re-throw it.

**Task:** Create a pattern that logs AND propagates errors.

```sql
BEGIN TRY
    BEGIN TRY
        -- Inner operation that fails
        INSERT INTO TestProducts VALUES (1, 'Duplicate', 10, 5);
    END TRY
    BEGIN CATCH
        -- Log the error
        EXEC usp_LogError;
        
        -- Re-throw to outer handler
        ________;
    END CATCH
END TRY
BEGIN CATCH
    -- Outer handler receives the re-thrown error
    PRINT 'Outer catch received: ' + ERROR_MESSAGE();
END CATCH

-- Verify error was logged
SELECT TOP 1 * FROM ErrorLog ORDER BY ErrorDate DESC;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
BEGIN TRY
    BEGIN TRY
        -- Inner operation that fails
        INSERT INTO TestProducts VALUES (1, 'Duplicate', 10, 5);
    END TRY
    BEGIN CATCH
        -- Log the error
        EXEC usp_LogError;
        
        -- Re-throw to outer handler
        THROW;
    END CATCH
END TRY
BEGIN CATCH
    -- Outer handler receives the re-thrown error
    PRINT 'Outer catch received: ' + ERROR_MESSAGE();
END CATCH

-- Verify error was logged
SELECT TOP 1 * FROM ErrorLog ORDER BY ErrorDate DESC;
```

</details>

---

## 📝 Part 7: Comprehensive Challenge

### Challenge: Create a Complete Order Processing Procedure

**Goal:** Build a procedure that processes an order with full error handling.

**Requirements:**
- Validate product exists
- Validate sufficient stock
- Update inventory
- Log any errors
- Use transactions

```sql
CREATE OR ALTER PROCEDURE usp_ProcessOrder
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validation 1: Quantity must be positive
        IF @Quantity <= 0
            THROW 50001, 'Quantity must be greater than zero', 1;
        
        -- Validation 2: Product must exist
        IF NOT EXISTS (SELECT 1 FROM TestProducts WHERE ProductID = @ProductID)
            THROW 50002, 'Product not found', 1;
        
        -- Validation 3: Sufficient stock
        DECLARE @Available INT;
        SELECT @Available = UnitsInStock FROM TestProducts WHERE ProductID = @ProductID;
        
        IF @Available < @Quantity
        BEGIN
            DECLARE @Msg VARCHAR(200) = 'Insufficient stock. Available: ' + CAST(@Available AS VARCHAR) + 
                                        ', Requested: ' + CAST(@Quantity AS VARCHAR);
            THROW 50003, @Msg, 1;
        END
        
        -- Process the order - reduce stock
        UPDATE TestProducts 
        SET UnitsInStock = UnitsInStock - @Quantity 
        WHERE ProductID = @ProductID;
        
        -- Success!
        COMMIT TRANSACTION;
        PRINT 'Order processed successfully!';
        PRINT 'Remaining stock: ' + CAST((@Available - @Quantity) AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Log the error
        EXEC usp_LogError;
        
        -- Report to caller
        PRINT 'Order failed: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test cases
PRINT '=== Test 1: Valid order ===';
EXEC usp_ProcessOrder @ProductID = 1, @Quantity = 5;

PRINT '';
PRINT '=== Test 2: Invalid quantity ===';
EXEC usp_ProcessOrder @ProductID = 1, @Quantity = 0;

PRINT '';
PRINT '=== Test 3: Product not found ===';
EXEC usp_ProcessOrder @ProductID = 999, @Quantity = 1;

PRINT '';
PRINT '=== Test 4: Insufficient stock ===';
EXEC usp_ProcessOrder @ProductID = 3, @Quantity = 1000;

-- Check error log
SELECT * FROM ErrorLog ORDER BY ErrorDate DESC;
```

---

## 🎯 Lab Summary

### What You Practiced:

| Topic | Exercises |
|-------|-----------|
| @@ERROR | 1.1, 1.2 |
| RAISERROR | 2.1, 2.2, 2.3 |
| Basic TRY...CATCH | 3.1, 3.2, 3.3 |
| Transactions | 4.1, 4.2 |
| Error Logging | 5.1, 5.2 |
| THROW | 6.1, 6.2 |

### Key Patterns Learned:

```sql
-- Check @@ERROR
IF @@ERROR <> 0 PRINT 'Error!';

-- RAISERROR
RAISERROR ('Message', 16, 1);

-- TRY...CATCH
BEGIN TRY
    -- risky code
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

-- With Transaction
BEGIN TRY
    BEGIN TRANSACTION;
    -- operations
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH

-- THROW
THROW 50001, 'Custom error', 1;
```

---

## 🧹 Cleanup

When you're done, clean up the lab tables:

```sql
DROP TABLE IF EXISTS TestProducts;
DROP TABLE IF EXISTS BankAccounts;
DROP TABLE IF EXISTS ErrorLog;
DROP PROCEDURE IF EXISTS usp_LogError;
DROP PROCEDURE IF EXISTS usp_ProcessOrder;

PRINT 'Cleanup complete!';
```

---

## 🏆 Congratulations!

You've completed the Error Handling Lab! You now know how to:
- ✅ Detect errors with @@ERROR
- ✅ Create custom errors with RAISERROR
- ✅ Use TRY...CATCH for structured error handling
- ✅ Combine transactions with error handling
- ✅ Log errors for troubleshooting
- ✅ Use THROW for modern error management

Your SQL code is now production-ready with proper error handling!
