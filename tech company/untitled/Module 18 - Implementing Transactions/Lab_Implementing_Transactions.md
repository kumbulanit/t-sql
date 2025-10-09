# Lab: Implementing Transactions

## Lab Overview

This comprehensive lab provides hands-on experience with transaction implementation, control, and optimization in TechCorp's database environment. Students will work through progressive exercises that demonstrate real-world transaction scenarios, from basic transaction control to advanced distributed operations and performance optimization. The lab emphasizes practical business applications, proper error handling, and performance considerations essential for enterprise database development.

## 🏢 TechCorp Business Context

**Lab Scenario: Enterprise Transaction Management System**

You are part of TechCorp's database development team responsible for implementing a comprehensive transaction management system that ensures data integrity across complex business operations. The lab exercises simulate real-world scenarios including employee management, order processing, financial operations, and system integrations that require sophisticated transaction control and error handling.

### 📋 TechCorp Database Schema

**Available Tables for Lab Exercises:**

```sql
-- Core Business Tables
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, HireDate, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive

-- Supporting Tables
TransactionAudit: TransactionID, TransactionType, TableName, RecordID, OldValues, NewValues, Timestamp
ErrorLog: ErrorLogID, ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo
PayrollBatches: BatchID, PayrollPeriodID, ProcessingDate, EmployeeCount, Status, CreatedDate
```

## Lab Setup and Prerequisites

### Environment Preparation

```sql
-- Lab Setup: Create supporting tables and verify environment

-- Create Transaction Audit table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TransactionAudit')
BEGIN
    CREATE TABLE TransactionAudit (
        TransactionID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionType NVARCHAR(50) NOT NULL,
        TableName NVARCHAR(128) NOT NULL,
        RecordID INT NOT NULL,
        OldValues NVARCHAR(MAX) NULL,
        NewValues NVARCHAR(MAX) NULL,
        Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
        Description NVARCHAR(500) NULL,
        UserName NVARCHAR(128) NOT NULL DEFAULT SYSTEM_USER
    );
END;

-- Create Error Log table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog')
BEGIN
    CREATE TABLE ErrorLog (
        ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
        ErrorProcedure NVARCHAR(128) NULL,
        ErrorNumber INT NULL,
        ErrorMessage NVARCHAR(4000) NOT NULL,
        ErrorTime DATETIME NOT NULL DEFAULT GETDATE(),
        AdditionalInfo NVARCHAR(MAX) NULL,
        UserName NVARCHAR(128) NOT NULL DEFAULT SYSTEM_USER
    );
END;

-- Verify core table data
SELECT 'Table Verification' AS CheckType,
       'Employees' AS TableName, COUNT(*) AS RecordCount 
FROM Employees WHERE IsActive = 1
UNION ALL
SELECT 'Table Verification', 'Departments', COUNT(*) FROM Departments WHERE IsActive = 1
UNION ALL
SELECT 'Table Verification', 'Projects', COUNT(*) FROM Projects WHERE IsActive = 1
UNION ALL
SELECT 'Table Verification', 'Orders', COUNT(*) FROM Orders WHERE IsActive = 1
UNION ALL
SELECT 'Table Verification', 'Customers', COUNT(*) FROM Customers WHERE IsActive = 1;

-- Check current transaction isolation level
SELECT 
    'Environment Check' AS CheckType,
    'Current Isolation Level' AS Property,
    CASE transaction_isolation_level
        WHEN 1 THEN 'READ UNCOMMITTED'
        WHEN 2 THEN 'READ COMMITTED'
        WHEN 3 THEN 'REPEATABLE READ'
        WHEN 4 THEN 'SERIALIZABLE'
        WHEN 5 THEN 'SNAPSHOT'
        ELSE 'UNKNOWN'
    END AS Value
FROM sys.dm_exec_sessions 
WHERE session_id = @@SPID;
```

---

## 🏋️‍♂️ Exercise 1: Basic Transaction Control

### 🎯 Exercise 1.1: Employee BaseSalary Update Transaction (⭐ BEGINNER)

**Business Scenario:** Implement a BaseSalary update process that maintains data consistency between employee records and d.DepartmentName budgets.

```sql
-- Challenge: Create a transaction-controlled BaseSalary update procedure
-- Requirements: Update employee BaseSalary and adjust d.DepartmentName budget accordingly

CREATE OR ALTER PROCEDURE sp_UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2),
    @EffectiveDate DATE = NULL,
    @Reason NVARCHAR(200) = 'BaseSalary Adjustment'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- TODO: Implement your solution here
    -- Your implementation should include:
    -- 1. Input validation
    -- 2. Transaction control with proper error handling
    -- 3. BaseSalary update with d.DepartmentName budget adjustment
    -- 4. Audit trail creation
    -- 5. Return appropriate status messages
    
    -- Variables declaration
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @DepartmentID INT;
    DECLARE @SalaryDifference DECIMAL(10,2);
    DECLARE @DepartmentBudget DECIMAL(15,2);
    DECLARE @TransactionName NVARCHAR(50) = 'SalaryUpdate_' + CAST(@EmployeeID AS NVARCHAR(10));
    
    SET @EffectiveDate = ISNULL(@EffectiveDate, GETDATE());
    
    -- Start your transaction here
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        -- Step 1: Validate and get current employee details
        -- YOUR CODE HERE
        
        -- Step 2: Validate new BaseSalary amount
        -- YOUR CODE HERE
        
        -- Step 3: Check d.DepartmentName budget availability
        -- YOUR CODE HERE
        
        -- Step 4: Update employee BaseSalary
        -- YOUR CODE HERE
        
        -- Step 5: Adjust d.DepartmentName budget
        -- YOUR CODE HERE
        
        -- Step 6: Create audit record
        -- YOUR CODE HERE
        
        -- Commit transaction
        COMMIT TRANSACTION @TransactionName;
        
        -- Return success status
        SELECT 
            @EmployeeID AS EmployeeID,
            @CurrentSalary AS PreviousSalary,
            @NewSalary AS NewSalary,
            @SalaryDifference AS SalaryIncrease,
            'SUCCESS' AS Status,
            'BaseSalary updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        -- Handle errors and rollback
        ROLLBACK TRANSACTION @TransactionName;
        
        -- Log error
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_UpdateEmployeeSalary', ERROR_MESSAGE(), GETDATE(),
                'EmployeeID: ' + CAST(@EmployeeID AS NVARCHAR(10)) + 
                ', NewSalary: ' + CAST(@NewSalary AS NVARCHAR(20)));
        
        -- Return error status
        SELECT 
            @EmployeeID AS EmployeeID,
            ERROR_MESSAGE() AS ErrorMessage,
            'ERROR' AS Status;
        
        THROW;
    END CATCH;
END;

-- Sample Solution (uncomment to see reference implementation):
/*
CREATE OR ALTER PROCEDURE sp_UpdateEmployeeSalary_Solution
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2),
    @EffectiveDate DATE = NULL,
    @Reason NVARCHAR(200) = 'BaseSalary Adjustment'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @DepartmentID INT;
    DECLARE @SalaryDifference DECIMAL(10,2);
    DECLARE @DepartmentBudget DECIMAL(15,2);
    DECLARE @TransactionName NVARCHAR(50) = 'SalaryUpdate_' + CAST(@EmployeeID AS NVARCHAR(10));
    
    SET @EffectiveDate = ISNULL(@EffectiveDate, GETDATE());
    
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        -- Get current employee details
        SELECT @CurrentSalary = BaseSalary, @DepartmentID = DepartmentID
        FROM Employees WHERE EmployeeID = @EmployeeID AND IsActive = 1;
        
        IF @CurrentSalary IS NULL
            RAISERROR('Employee not found or inactive', 16, 1);
        
        IF @NewSalary <= 0
            RAISERROR('Invalid BaseSalary amount', 16, 1);
        
        SET @SalaryDifference = @NewSalary - @CurrentSalary;
        
        -- Check d.DepartmentName budget
        SELECT @DepartmentBudget = Budget 
        FROM Departments WHERE DepartmentID = @DepartmentID;
        
        IF @DepartmentBudget < @SalaryDifference
            RAISERROR('Insufficient d.DepartmentName budget', 16, 1);
        
        -- Update employee BaseSalary
        UPDATE Employees 
        SET BaseSalary = @NewSalary, ModifiedDate = @EffectiveDate
        WHERE EmployeeID = @EmployeeID;
        
        -- Adjust d.DepartmentName budget
        UPDATE Departments 
        SET Budget = Budget - @SalaryDifference, ModifiedDate = @EffectiveDate
        WHERE DepartmentID = @DepartmentID;
        
        -- Create audit record
        INSERT INTO TransactionAudit (TransactionType, TableName, RecordID, OldValues, NewValues, Description)
        VALUES ('SALARY_UPDATE', 'Employees', @EmployeeID, 
                'BaseSalary: ' + CAST(@CurrentSalary AS NVARCHAR(20)),
                'BaseSalary: ' + CAST(@NewSalary AS NVARCHAR(20)),
                @Reason);
        
        COMMIT TRANSACTION @TransactionName;
        
        SELECT @EmployeeID AS EmployeeID, @CurrentSalary AS PreviousSalary, 
               @NewSalary AS NewSalary, 'SUCCESS' AS Status;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime)
        VALUES ('sp_UpdateEmployeeSalary', ERROR_MESSAGE(), GETDATE());
        THROW;
    END CATCH;
END;
*/

-- Test your implementation
EXEC sp_UpdateEmployeeSalary 
    @EmployeeID = 3001,
    @NewSalary = 85000.00,
    @Reason = 'Performance Review Increase';
```

### 🎯 Exercise 1.2: Order Processing Transaction (⭐⭐ INTERMEDIATE)

**Business Scenario:** Create an order processing system that handles customer orders with inventory validation and financial calculations.

```sql
-- Challenge: Implement comprehensive order processing with transaction control

-- First, create Order Items table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')
BEGIN
    CREATE TABLE OrderItems (
        OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,
        LineTotal AS (Quantity * UnitPrice),
        IsActive BIT NOT NULL DEFAULT 1
    );
END;

-- Create Product inventory table for the exercise
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductInventory')
BEGIN
    CREATE TABLE ProductInventory (
        ProductID INT IDENTITY(1001,1) PRIMARY KEY,
        ProductName NVARCHAR(100) NOT NULL,
        StockQuantity INT NOT NULL DEFAULT 0,
        UnitPrice DECIMAL(10,2) NOT NULL,
        MinimumStock INT NOT NULL DEFAULT 10,
        IsActive BIT NOT NULL DEFAULT 1
    );
    
    -- Insert sample products
    INSERT INTO ProductInventory (ProductName, StockQuantity, UnitPrice, MinimumStock)
    VALUES 
    ('Software License', 100, 299.99, 10),
    ('Hardware Component', 50, 149.99, 5),
    ('Support Package', 25, 499.99, 3),
    ('Training Course', 15, 799.99, 2);
END;

CREATE OR ALTER PROCEDURE sp_ProcessCustomerOrder
    @CustomerID INT,
    @EmployeeID INT,
    @OrderItems NVARCHAR(MAX)  -- JSON format: [{"ProductID":1001,"Quantity":2}...]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- TODO: Implement your order processing solution
    -- Requirements:
    -- 1. Validate customer and employee
    -- 2. Parse order items from JSON
    -- 3. Check inventory availability for all items
    -- 4. Create order header and items
    -- 5. Update inventory quantities
    -- 6. Calculate and update order total
    -- 7. Handle all operations within a single transaction
    
    DECLARE @OrderID INT;
    DECLARE @TotalAmount DECIMAL(12,2) = 0;
    DECLARE @TransactionName NVARCHAR(50) = 'OrderProcessing';
    
    -- Start your transaction
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        -- Step 1: Validate customer and employee
        -- YOUR CODE HERE
        
        -- Step 2: Create order header
        -- YOUR CODE HERE
        
        -- Step 3: Process order items (parse JSON and validate inventory)
        -- YOUR CODE HERE
        -- Hint: Use OPENJSON to parse the JSON parameter
        
        -- Step 4: Update inventory and create order items
        -- YOUR CODE HERE
        
        -- Step 5: Update order total
        -- YOUR CODE HERE
        
        -- Step 6: Create audit trail
        -- YOUR CODE HERE
        
        COMMIT TRANSACTION @TransactionName;
        
        -- Return success status with order details
        SELECT 
            @OrderID AS OrderID,
            @CustomerID AS CustomerID,
            @TotalAmount AS TotalAmount,
            'SUCCESS' AS Status,
            'Order processed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_ProcessCustomerOrder', ERROR_MESSAGE(), GETDATE(),
                'CustomerID: ' + CAST(@CustomerID AS NVARCHAR(10)) + 
                ', EmployeeID: ' + CAST(@EmployeeID AS NVARCHAR(10)));
        
        SELECT 
            0 AS OrderID,
            'ERROR: ' + ERROR_MESSAGE() AS Status;
        
        THROW;
    END CATCH;
END;

-- Test your implementation
EXEC sp_ProcessCustomerOrder
    @CustomerID = 6001,
    @EmployeeID = 3001,
    @OrderItems = '[{"ProductID":1001,"Quantity":2},{"ProductID":1002,"Quantity":1}]';
```

---

## 🏋️‍♂️ Exercise 2: Advanced Transaction Control with Savepoints

### 🎯 Exercise 2.1: Project Setup with Savepoints (⭐⭐⭐ ADVANCED)

**Business Scenario:** Create a complex project setup process that uses savepoints for granular transaction control.

```sql
-- Challenge: Implement project setup with multiple phases and savepoint-based rollback

-- Create necessary supporting tables
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProjectBudgetAllocations')
BEGIN
    CREATE TABLE ProjectBudgetAllocations (
        AllocationID INT IDENTITY(1,1) PRIMARY KEY,
        ProjectID INT NOT NULL,
        DepartmentID INT NOT NULL,
        AllocatedAmount DECIMAL(15,2) NOT NULL,
        AllocationDate DATE NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
END;

CREATE OR ALTER PROCEDURE sp_SetupComplexProject
    @ProjectName NVARCHAR(200),
    @ProjectManagerID INT,
    @TotalBudget DECIMAL(15,2),
    @TeamMemberIDs NVARCHAR(MAX),  -- Comma-separated list: "3001,3002,3003"
    @DepartmentBudgetAllocations NVARCHAR(MAX)  -- JSON: [{"DepartmentID":2001,"Amount":50000}...]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF;  -- Allow manual error handling
    
    -- TODO: Implement multi-phase project setup with savepoints
    -- Phases:
    -- 1. Create project record
    -- 2. Assign project manager and validate
    -- 3. Assign team members with validation
    -- 4. Allocate budgets from departments
    -- 5. Final validations and setup completion
    
    DECLARE @ProjectID INT;
    DECLARE @TransactionName NVARCHAR(50) = 'ComplexProjectSetup';
    DECLARE @Phase1SavePoint NVARCHAR(50) = 'ProjectCreated';
    DECLARE @Phase2SavePoint NVARCHAR(50) = 'ManagerAssigned';
    DECLARE @Phase3SavePoint NVARCHAR(50) = 'TeamAssigned';
    DECLARE @Phase4SavePoint NVARCHAR(50) = 'BudgetAllocated';
    
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        PRINT 'Starting complex project setup transaction...';
        
        -- Phase 1: Create project record
        -- YOUR CODE HERE
        -- Create savepoint after this phase
        
        PRINT 'Phase 1 Complete: Project created';
        
        -- Phase 2: Validate and assign project manager
        -- YOUR CODE HERE
        -- Create savepoint after this phase
        
        PRINT 'Phase 2 Complete: Project manager assigned';
        
        -- Phase 3: Process team member assignments
        -- YOUR CODE HERE
        -- Parse comma-separated team member IDs
        -- Validate each member and assign to project
        -- Create savepoint after this phase
        
        PRINT 'Phase 3 Complete: Team members assigned';
        
        -- Phase 4: Process budget allocations
        -- YOUR CODE HERE
        -- Parse JSON budget allocations
        -- Validate d.DepartmentName budgets and allocate
        -- Create savepoint after this phase
        
        PRINT 'Phase 4 Complete: Budget allocated';
        
        -- Phase 5: Final validations and completion
        -- YOUR CODE HERE
        -- Update project status and final calculations
        
        COMMIT TRANSACTION @TransactionName;
        
        SELECT 
            @ProjectID AS ProjectID,
            @ProjectName AS ProjectName,
            'SUCCESS' AS Status,
            'Project setup completed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @RollbackLevel NVARCHAR(50) = 'FULL';
        
        -- Determine appropriate rollback level based on error type
        -- YOUR CODE HERE
        -- Implement intelligent rollback strategy:
        -- - Budget errors: rollback to Phase 3
        -- - Team assignment errors: rollback to Phase 2
        -- - Manager errors: rollback to Phase 1
        -- - Project creation errors: full rollback
        
        PRINT 'Error handling and rollback logic executed';
        
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_SetupComplexProject', @ErrorMessage, GETDATE(),
                'ProjectName: ' + @ProjectName + ', RollbackLevel: ' + @RollbackLevel);
        
    END CATCH;
END;

-- Test your implementation
EXEC sp_SetupComplexProject
    @ProjectName = 'TechCorp Digital Innovation Platform',
    @ProjectManagerID = 3001,
    @TotalBudget = 750000.00,
    @TeamMemberIDs = '3002,3003,3004,3005',
    @DepartmentBudgetAllocations = '[{"DepartmentID":2001,"Amount":400000},{"DepartmentID":2002,"Amount":350000}]';
```

---

## 🏋️‍♂️ Exercise 3: Isolation Levels and Concurrency Control

### 🎯 Exercise 3.1: Concurrent BaseSalary Processing (⭐⭐⭐ ADVANCED)

**Business Scenario:** Implement a payroll processing system that handles concurrent operations with appropriate isolation levels.

```sql
-- Challenge: Create payroll processing with different isolation level strategies

-- Create payroll processing tables
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PayrollProcessing')
BEGIN
    CREATE TABLE PayrollProcessing (
        ProcessingID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        ProcessingDate DATE NOT NULL,
        BaseSalary DECIMAL(10,2) NOT NULL,
        Bonus DECIMAL(10,2) NOT NULL DEFAULT 0,
        Deductions DECIMAL(10,2) NOT NULL DEFAULT 0,
        NetPay AS (BaseSalary + Bonus - Deductions),
        ProcessingStatus NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
        ProcessedBy NVARCHAR(128) NOT NULL DEFAULT SYSTEM_USER,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;

-- Procedure 1: High-concurrency payroll reader (for reporting)
CREATE OR ALTER PROCEDURE sp_GeneratePayrollReport
    @ReportDate DATE = NULL,
    @IsolationLevel NVARCHAR(20) = 'SNAPSHOT'
AS
BEGIN
    SET NOCOUNT ON;
    
    SET @ReportDate = ISNULL(@ReportDate, GETDATE());
    
    -- TODO: Implement payroll reporting with specified isolation level
    -- Requirements:
    -- 1. Set appropriate isolation level
    -- 2. Generate consistent payroll report
    -- 3. Handle concurrent modifications gracefully
    -- 4. Provide summary statistics
    
    -- Set isolation level based on parameter
    -- YOUR CODE HERE
    
    BEGIN TRANSACTION PayrollReport;
    
    BEGIN TRY
        PRINT 'Generating payroll report with isolation level: ' + @IsolationLevel;
        
        -- Create consistent snapshot of payroll data
        -- YOUR CODE HERE
        
        -- Generate department-wise payroll summary
        -- YOUR CODE HERE
        
        -- Generate individual employee payroll details
        -- YOUR CODE HERE
        
        COMMIT TRANSACTION PayrollReport;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION PayrollReport;
        PRINT 'Payroll report failed: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;

-- Procedure 2: Payroll processor (concurrent writer)
CREATE OR ALTER PROCEDURE sp_ProcessEmployeePayroll
    @ProcessingBatchID INT,
    @EmployeeIDs NVARCHAR(MAX),  -- Comma-separated list
    @BonusPercentage DECIMAL(5,4) = 0.05,  -- 5% default bonus
    @StandardDeductions DECIMAL(10,2) = 500.00
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- Standard level for updates
    
    -- TODO: Implement batch payroll processing
    -- Requirements:
    -- 1. Process multiple employees in a single transaction
    -- 2. Calculate bonuses and deductions
    -- 3. Handle locking conflicts gracefully
    -- 4. Provide progress tracking
    
    DECLARE @ProcessedCount INT = 0;
    DECLARE @ErrorCount INT = 0;
    DECLARE @TransactionName NVARCHAR(50) = 'PayrollProcessing_' + CAST(@ProcessingBatchID AS NVARCHAR(10));
    
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        PRINT 'Starting payroll processing for batch: ' + CAST(@ProcessingBatchID AS NVARCHAR(10));
        
        -- Parse employee IDs and process each one
        -- YOUR CODE HERE
        -- Hint: Use STRING_SPLIT function to parse comma-separated values
        
        -- Update processing statistics
        -- YOUR CODE HERE
        
        COMMIT TRANSACTION @TransactionName;
        
        SELECT 
            @ProcessingBatchID AS BatchID,
            @ProcessedCount AS ProcessedEmployees,
            @ErrorCount AS ErrorCount,
            'SUCCESS' AS Status;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime)
        VALUES ('sp_ProcessEmployeePayroll', ERROR_MESSAGE(), GETDATE());
        
        SELECT 
            @ProcessingBatchID AS BatchID,
            0 AS ProcessedEmployees,
            'ERROR: ' + ERROR_MESSAGE() AS Status;
        
        THROW;
    END CATCH;
END;

-- Test concurrent operations (run these in separate query windows)

-- Window 1: Start payroll processing
EXEC sp_ProcessEmployeePayroll
    @ProcessingBatchID = 1,
    @EmployeeIDs = '3001,3002,3003,3004,3005',
    @BonusPercentage = 0.08,
    @StandardDeductions = 750.00;

-- Window 2: Generate report while processing is running
EXEC sp_GeneratePayrollReport
    @ReportDate = '2024-01-01',
    @IsolationLevel = 'SNAPSHOT';

-- Window 3: Generate report with different isolation level
EXEC sp_GeneratePayrollReport
    @ReportDate = '2024-01-01',
    @IsolationLevel = 'READ_COMMITTED';
```

---

## 🏋️‍♂️ Exercise 4: Distributed Transactions and Advanced Control

### 🎯 Exercise 4.1: Cross-System Financial Transaction (🔴 EXPERT LEVEL)

**Business Scenario:** Implement a distributed transaction system for cross-system financial operations.

```sql
-- Challenge: Create distributed transaction for complex financial operations

-- Create financial system integration tables
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FinancialTransactions')
BEGIN
    CREATE TABLE FinancialTransactions (
        TransactionID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionType NVARCHAR(50) NOT NULL,
        SourceSystem NVARCHAR(50) NOT NULL,
        TargetSystem NVARCHAR(50) NOT NULL,
        Amount DECIMAL(15,2) NOT NULL,
        CurrencyCode CHAR(3) NOT NULL DEFAULT 'USD',
        TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
        Status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
        BatchID INT NULL,
        Description NVARCHAR(500) NULL,
        CreatedBy NVARCHAR(128) NOT NULL DEFAULT SYSTEM_USER
    );
END;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SystemIntegrationLog')
BEGIN
    CREATE TABLE SystemIntegrationLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        SystemName NVARCHAR(50) NOT NULL,
        Operation NVARCHAR(100) NOT NULL,
        Status NVARCHAR(20) NOT NULL,
        RequestData NVARCHAR(MAX) NULL,
        ResponseData NVARCHAR(MAX) NULL,
        ProcessingTime DATETIME NOT NULL DEFAULT GETDATE(),
        DurationMS INT NULL
    );
END;

CREATE OR ALTER PROCEDURE sp_ProcessDistributedFinancialTransaction
    @TransactionType NVARCHAR(50),
    @SourceSystemID NVARCHAR(50),
    @TargetSystemID NVARCHAR(50),
    @Amount DECIMAL(15,2),
    @Description NVARCHAR(500),
    @BatchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- TODO: Implement distributed transaction processing
    -- Requirements:
    -- 1. Use distributed transaction control
    -- 2. Coordinate operations across multiple systems
    -- 3. Implement comprehensive error handling
    -- 4. Provide rollback capabilities for partial failures
    -- 5. Log all system interactions
    
    DECLARE @TransactionID INT;
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @DistributedTranName NVARCHAR(50) = 'FinancialDistribution';
    
    -- Start distributed transaction
    -- YOUR CODE HERE
    -- Hint: Use BEGIN DISTRIBUTED TRANSACTION
    
    BEGIN TRY
        PRINT 'Starting distributed financial transaction...';
        
        -- Phase 1: Validate transaction parameters
        -- YOUR CODE HERE
        
        -- Phase 2: Create financial transaction record
        -- YOUR CODE HERE
        
        -- Phase 3: Process source system operations
        -- YOUR CODE HERE
        -- Simulate external system calls with delay and logging
        
        -- Phase 4: Process target system operations
        -- YOUR CODE HERE
        -- Simulate external system calls with delay and logging
        
        -- Phase 5: Update transaction status and commit
        -- YOUR CODE HERE
        
        -- Commit distributed transaction
        COMMIT TRANSACTION @DistributedTranName;
        
        DECLARE @EndTime DATETIME = GETDATE();
        DECLARE @Duration INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
        
        SELECT 
            @TransactionID AS TransactionID,
            @Amount AS Amount,
            @Duration AS ProcessingTimeMS,
            'SUCCESS' AS Status,
            'Distributed transaction completed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        -- Handle distributed transaction rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @DistributedTranName;
        
        -- Log comprehensive error information
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_ProcessDistributedFinancialTransaction', ERROR_MESSAGE(), GETDATE(),
                'TransactionType: ' + @TransactionType + 
                ', Amount: ' + CAST(@Amount AS NVARCHAR(20)) +
                ', SourceSystem: ' + @SourceSystemID + 
                ', TargetSystem: ' + @TargetSystemID);
        
        -- Log system integration failure
        INSERT INTO SystemIntegrationLog (SystemName, Operation, Status, RequestData, DurationMS)
        VALUES ('DistributedTransaction', @TransactionType, 'FAILED', 
                'Amount: ' + CAST(@Amount AS NVARCHAR(20)), 
                DATEDIFF(MILLISECOND, @StartTime, GETDATE()));
        
        SELECT 
            0 AS TransactionID,
            'ERROR: ' + ERROR_MESSAGE() AS Status;
        
        THROW;
    END CATCH;
END;

-- Test distributed transaction
EXEC sp_ProcessDistributedFinancialTransaction
    @TransactionType = 'PAYROLL_TRANSFER',
    @SourceSystemID = 'TECHCORP_PAYROLL',
    @TargetSystemID = 'BANK_SYSTEM',
    @Amount = 125000.00,
    @Description = 'Monthly payroll transfer to bank',
    @BatchID = 1;
```

---

## 🏋️‍♂️ Exercise 5: Master Integration Challenge

### 🎯 Exercise 5.1: Complete Transaction Management System (🔴 EXPERT LEVEL)

**Business Scenario:** Build a comprehensive transaction management system that integrates all learned concepts.

```sql
-- Challenge: Create enterprise-grade transaction management system

CREATE OR ALTER PROCEDURE sp_TechCorp_TransactionManagementSystem
    @Operation NVARCHAR(50),  -- 'PROCESS_PAYROLL', 'SETUP_PROJECT', 'PROCESS_ORDERS', 'FINANCIAL_TRANSFER'
    @Parameters NVARCHAR(MAX), -- JSON parameters specific to each operation
    @ExecutionMode NVARCHAR(20) = 'EXECUTE', -- 'PREVIEW', 'EXECUTE', 'VALIDATE'
    @IsolationLevel NVARCHAR(20) = 'READ_COMMITTED'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- TODO: Implement comprehensive transaction management system
    -- Requirements:
    -- 1. Support multiple business operations
    -- 2. Dynamic isolation level configuration
    -- 3. Comprehensive error handling and recovery
    -- 4. Performance monitoring and logging
    -- 5. Rollback strategies based on error types
    -- 6. Integration with all previous exercises
    
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @TransactionName NVARCHAR(50) = 'TechCorp_' + @Operation;
    DECLARE @ProcessedRecords INT = 0;
    DECLARE @ErrorCount INT = 0;
    
    -- Set dynamic isolation level
    -- YOUR CODE HERE
    
    -- Parse operation parameters
    DECLARE @ParsedParams NVARCHAR(MAX) = @Parameters;
    
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        PRINT 'TechCorp Transaction Management System';
        PRINT 'Operation: ' + @Operation;
        PRINT 'Mode: ' + @ExecutionMode;
        PRINT 'Isolation Level: ' + @IsolationLevel;
        PRINT '----------------------------------------';
        
        -- Route to appropriate business operation
        IF @Operation = 'PROCESS_PAYROLL'
        BEGIN
            -- YOUR CODE HERE
            -- Implement comprehensive payroll processing
            -- Use concepts from Exercise 3
        END
        ELSE IF @Operation = 'SETUP_PROJECT'
        BEGIN
            -- YOUR CODE HERE
            -- Implement project setup with savepoints
            -- Use concepts from Exercise 2
        END
        ELSE IF @Operation = 'PROCESS_ORDERS'
        BEGIN
            -- YOUR CODE HERE
            -- Implement order processing system
            -- Use concepts from Exercise 1
        END
        ELSE IF @Operation = 'FINANCIAL_TRANSFER'
        BEGIN
            -- YOUR CODE HERE
            -- Implement distributed financial transactions
            -- Use concepts from Exercise 4
        END
        ELSE
        BEGIN
            RAISERROR('Unsupported operation: %s', 16, 1, @Operation);
        END;
        
        -- Performance and completion logging
        DECLARE @EndTime DATETIME = GETDATE();
        DECLARE @DurationMS INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
        
        -- Commit based on execution mode
        IF @ExecutionMode = 'EXECUTE'
        BEGIN
            COMMIT TRANSACTION @TransactionName;
            PRINT 'Transaction committed successfully';
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION @TransactionName;
            PRINT 'Preview mode - transaction rolled back';
        END;
        
        -- Return comprehensive status
        SELECT 
            @Operation AS Operation,
            @ExecutionMode AS ExecutionMode,
            @ProcessedRecords AS RecordsProcessed,
            @ErrorCount AS ErrorCount,
            @DurationMS AS ProcessingTimeMS,
            CASE 
                WHEN @ExecutionMode = 'EXECUTE' THEN 'COMMITTED'
                WHEN @ExecutionMode = 'PREVIEW' THEN 'PREVIEWED'
                ELSE 'VALIDATED'
            END AS TransactionStatus,
            'SUCCESS' AS OverallStatus;
        
    END TRY
    BEGIN CATCH
        -- Comprehensive error handling
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        
        -- Intelligent rollback strategy
        IF XACT_STATE() = -1  -- Uncommittable transaction
        BEGIN
            ROLLBACK TRANSACTION @TransactionName;
            PRINT 'Full transaction rollback due to uncommittable state';
        END
        ELSE IF XACT_STATE() = 1  -- Committable transaction
        BEGIN
            -- Determine if partial commit is appropriate
            IF @Operation IN ('SETUP_PROJECT', 'PROCESS_PAYROLL') AND @ErrorSeverity <= 16
            BEGIN
                -- Attempt graceful degradation
                PRINT 'Attempting graceful degradation...';
                -- YOUR CODE HERE - implement partial commit logic
                COMMIT TRANSACTION @TransactionName;
            END
            ELSE
            BEGIN
                ROLLBACK TRANSACTION @TransactionName;
                PRINT 'Full transaction rollback due to critical error';
            END;
        END;
        
        -- Comprehensive error logging
        INSERT INTO ErrorLog (ErrorProcedure, ErrorNumber, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_TechCorp_TransactionManagementSystem', @ErrorNumber, @ErrorMessage, GETDATE(),
                'Operation: ' + @Operation + ', Mode: ' + @ExecutionMode + 
                ', IsolationLevel: ' + @IsolationLevel + ', Parameters: ' + @Parameters);
        
        -- Return error status
        SELECT 
            @Operation AS Operation,
            @ErrorNumber AS ErrorNumber,
            @ErrorMessage AS ErrorMessage,
            DATEDIFF(MILLISECOND, @StartTime, GETDATE()) AS ProcessingTimeMS,
            'ERROR' AS OverallStatus;
        
        THROW;
    END CATCH;
END;

-- Test the complete system
PRINT '=== Testing Complete Transaction Management System ===';

-- Test 1: Payroll processing
EXEC sp_TechCorp_TransactionManagementSystem
    @Operation = 'PROCESS_PAYROLL',
    @Parameters = '{"EmployeeIDs":"3001,3002,3003","BonusRate":0.08,"BatchID":1}',
    @ExecutionMode = 'PREVIEW',
    @IsolationLevel = 'SNAPSHOT';

-- Test 2: Project setup
EXEC sp_TechCorp_TransactionManagementSystem
    @Operation = 'SETUP_PROJECT',
    @Parameters = '{"ProjectName":"AI Innovation Hub","ManagerID":3001,"Budget":500000,"TeamIDs":"3002,3003,3004"}',
    @ExecutionMode = 'EXECUTE',
    @IsolationLevel = 'READ_COMMITTED';

-- Test 3: Order processing
EXEC sp_TechCorp_TransactionManagementSystem
    @Operation = 'PROCESS_ORDERS',
    @Parameters = '{"CustomerID":6001,"EmployeeID":3001,"Items":[{"ProductID":1001,"Quantity":5}]}',
    @ExecutionMode = 'EXECUTE',
    @IsolationLevel = 'READ_COMMITTED';
```

---

## 📊 Lab Summary and Performance Analysis

### Achievement Validation

```sql
-- Comprehensive lab validation and performance analysis
CREATE OR ALTER PROCEDURE sp_ValidateTransactionLabCompletion
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT '=== TechCorp Transaction Lab Validation Report ===';
    PRINT 'Generated: ' + CONVERT(NVARCHAR(30), GETDATE(), 120);
    PRINT '====================================================';
    
    -- 1. Basic Transaction Control Validation
    SELECT 
        'Basic Transaction Control' AS TestCategory,
        CASE WHEN EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%UpdateEmployeeSalary%') 
             THEN 'IMPLEMENTED' ELSE 'MISSING' END AS SalaryUpdateProcedure,
        CASE WHEN EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%ProcessCustomerOrder%') 
             THEN 'IMPLEMENTED' ELSE 'MISSING' END AS OrderProcessingProcedure,
        (SELECT COUNT(*) FROM TransactionAudit WHERE TransactionType = 'SALARY_UPDATE') AS SalaryUpdateTransactions,
        (SELECT COUNT(*) FROM ErrorLog WHERE ErrorProcedure LIKE '%Order%') AS OrderProcessingErrors;
    
    -- 2. Advanced Transaction Features Validation
    SELECT 
        'Advanced Features' AS TestCategory,
        CASE WHEN EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%ComplexProject%') 
             THEN 'IMPLEMENTED' ELSE 'MISSING' END AS SavepointImplementation,
        CASE WHEN EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%PayrollReport%') 
             THEN 'IMPLEMENTED' ELSE 'MISSING' END AS IsolationLevelControl,
        CASE WHEN EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%Distributed%') 
             THEN 'IMPLEMENTED' ELSE 'MISSING' END AS DistributedTransactions;
    
    -- 3. Performance Metrics
    SELECT 
        'Performance Metrics' AS TestCategory,
        AVG(DATEDIFF(MILLISECOND, CreatedDate, GETDATE())) AS AvgTransactionAgeMS,
        COUNT(*) AS TotalTransactionsLogged,
        SUM(CASE WHEN Status = 'SUCCESS' THEN 1 ELSE 0 END) AS SuccessfulTransactions,
        SUM(CASE WHEN Status LIKE 'ERROR%' THEN 1 ELSE 0 END) AS FailedTransactions
    FROM (
        SELECT 'SUCCESS' AS Status, CreatedDate FROM TransactionAudit
        UNION ALL
        SELECT 'ERROR', ErrorTime FROM ErrorLog
    ) combined;
    
    -- 4. Data Integrity Validation
    SELECT 
        'Data Integrity' AS TestCategory,
        (SELECT COUNT(*) FROM Employees WHERE IsActive = 1) AS ActiveEmployees,
        (SELECT SUM(Budget) FROM Departments WHERE IsActive = 1) AS TotalDepartmentBudget,
        (SELECT COUNT(*) FROM Projects WHERE IsActive = 1) AS ActiveProjects,
        (SELECT COUNT(*) FROM Orders WHERE IsActive = 1) AS TotalOrders,
        (SELECT COUNT(*) FROM TransactionAudit) AS AuditTrailRecords;
    
    -- 5. Error Analysis
    SELECT TOP 5
        'Recent Errors' AS TestCategory,
        ErrorProcedure,
        LEFT(ErrorMessage, 100) AS ErrorMessagePreview,
        ErrorTime,
        AdditionalInfo
    FROM ErrorLog
    ORDER BY ErrorTime DESC;
    
    -- 6. Overall Lab Completion Score
    DECLARE @CompletionScore INT = 0;
    
    -- Check for implemented procedures
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%UpdateEmployeeSalary%')
        SET @CompletionScore = @CompletionScore + 20;
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%ProcessCustomerOrder%')
        SET @CompletionScore = @CompletionScore + 20;
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%ComplexProject%')
        SET @CompletionScore = @CompletionScore + 20;
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%PayrollReport%')
        SET @CompletionScore = @CompletionScore + 20;
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name LIKE '%TransactionManagementSystem%')
        SET @CompletionScore = @CompletionScore + 20;
    
    SELECT 
        'Lab Completion Assessment' AS TestCategory,
        @CompletionScore AS CompletionPercentage,
        CASE 
            WHEN @CompletionScore >= 90 THEN 'EXCELLENT - All exercises completed'
            WHEN @CompletionScore >= 70 THEN 'GOOD - Most exercises completed'
            WHEN @CompletionScore >= 50 THEN 'SATISFACTORY - Basic exercises completed'
            ELSE 'NEEDS IMPROVEMENT - Complete remaining exercises'
        END AS OverallAssessment;
    
    PRINT '====================================================';
    PRINT 'Lab Validation Complete';
END;

-- Execute validation
EXEC sp_ValidateTransactionLabCompletion;
```

### Performance Benchmarking

```sql
-- Transaction performance benchmarking
CREATE OR ALTER PROCEDURE sp_BenchmarkTransactionPerformance
    @TestDurationSeconds INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @EndTime DATETIME = DATEADD(SECOND, @TestDurationSeconds, @StartTime);
    DECLARE @TransactionCount INT = 0;
    DECLARE @ErrorCount INT = 0;
    
    PRINT 'Starting transaction performance benchmark...';
    PRINT 'Test Duration: ' + CAST(@TestDurationSeconds AS NVARCHAR(10)) + ' seconds';
    
    WHILE GETDATE() < @EndTime
    BEGIN
        BEGIN TRY
            -- Simulate rapid transaction processing
            BEGIN TRANSACTION BenchmarkTest;
            
            -- Simulate business logic
            DECLARE @TestEmployeeID INT = 3001 + (ABS(CHECKSUM(NEWID())) % 5);
            DECLARE @TestAmount DECIMAL(10,2) = 1000 + (ABS(CHECKSUM(NEWID())) % 50000);
            
            -- Quick update operation
            UPDATE Employees 
            SET ModifiedDate = GETDATE() 
            WHERE EmployeeID = @TestEmployeeID;
            
            COMMIT TRANSACTION BenchmarkTest;
            SET @TransactionCount = @TransactionCount + 1;
            
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION BenchmarkTest;
            SET @ErrorCount = @ErrorCount + 1;
        END CATCH;
    END;
    
    DECLARE @ActualDurationSeconds INT = DATEDIFF(SECOND, @StartTime, GETDATE());
    DECLARE @TransactionsPerSecond DECIMAL(10,2) = CAST(@TransactionCount AS DECIMAL(10,2)) / @ActualDurationSeconds;
    
    SELECT 
        'Transaction Performance Benchmark' AS BenchmarkType,
        @ActualDurationSeconds AS TestDurationSeconds,
        @TransactionCount AS TotalTransactions,
        @ErrorCount AS TotalErrors,
        @TransactionsPerSecond AS TransactionsPerSecond,
        CASE 
            WHEN @TransactionsPerSecond >= 100 THEN 'EXCELLENT'
            WHEN @TransactionsPerSecond >= 50 THEN 'GOOD'
            WHEN @TransactionsPerSecond >= 20 THEN 'SATISFACTORY'
            ELSE 'NEEDS OPTIMIZATION'
        END AS PerformanceRating;
END;

-- Execute benchmark
EXEC sp_BenchmarkTransactionPerformance @TestDurationSeconds = 15;
```

---

## 🎯 Next Steps and Advanced Challenges

### Extended Learning Opportunities

1. **Distributed Transaction Coordination**: Implement two-phase commit protocols
2. **Transaction Log Management**: Custom log backup and recovery strategies
3. **Advanced Isolation Patterns**: Implementation of custom isolation mechanisms
4. **Performance Optimization**: Query plan analysis for transaction-heavy workloads
5. **Cross-Platform Transactions**: Integration with non-SQL Server systems

### Real-World Integration Scenarios

- **Banking Systems**: Multi-account transfer operations with ACID guarantees
- **E-commerce Platforms**: Order processing with inventory management
- **ERP Systems**: Complex business process automation with rollback capabilities
- **Data Warehousing**: ETL operations with transaction consistency
- **Microservices Architecture**: Distributed transaction management across services

**🎉 Congratulations!** You have successfully completed the comprehensive Transaction Implementation Lab, demonstrating mastery of transaction control, isolation levels, error handling, and performance optimization essential for enterprise database development.