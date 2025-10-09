# Lesson 1: Implementing T-SQL Error Handling

## Overview

Error handling is a critical aspect of robust T-SQL programming that ensures applications can gracefully manage unexpected situations, provide meaningful feedback to users, and maintain data integrity. At TechCorp, implementing comprehensive error handling strategies is essential for maintaining reliable database operations, protecting critical business data, and providing excellent user experience across all applications. This lesson covers the fundamental concepts and techniques for implementing effective error handling in T-SQL.

## 🏢 TechCorp Business Context

**Error Handling in Enterprise Applications:**

- **Data Integrity**: Protecting critical business data during complex operations
- **User Experience**: Providing meaningful error messages instead of system-generated errors
- **Audit Trail**: Logging errors for troubleshooting and compliance purposes
- **Business Continuity**: Ensuring operations can continue despite unexpected issues
- **Regulatory Compliance**: Meeting audit requirements for error tracking and resolution

### 📋 TechCorp Database Schema Reference

**Core Tables for Error Handling Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
ErrorLog: ErrorLogID, ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine, ErrorSeverity, ErrorState, UserName, ErrorTime
```

---

## 1.1 Understanding T-SQL Error Fundamentals

### Error Types and Categories

T-SQL errors can be categorized into several types, each requiring different handling approaches:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            T-SQL Error Categories                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  System Errors (SQL Server Generated):                                     │
│  • Syntax errors (compilation time)                                        │
│  • Runtime errors (execution time)                                         │
│  • Constraint violations                                                   │
│  • Permission errors                                                       │
│                                                                             │
│  Custom Errors (User-Defined):                                            │
│  • Business rule violations                                               │
│  • Data validation failures                                               │
│  • Application-specific conditions                                        │
│                                                                             │
│  Error Severity Levels:                                                    │
│  • 0-10: Informational messages                                           │
│  • 11-16: Errors that can be corrected by user                           │
│  • 17-19: Software errors (cannot be corrected by user)                  │
│  • 20-25: System problems (fatal errors)                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Error Information Functions

SQL Server provides several system functions to retrieve error information:

```sql
-- TechCorp Example: Understanding Error Information Functions
-- These functions are available within error handling blocks

SELECT 
    'Error Information Functions' AS Topic,
    'ERROR_NUMBER()' AS Function_Name,
    'Returns the error number of the error' AS Description

UNION ALL

SELECT 
    'Error Information Functions',
    'ERROR_MESSAGE()',
    'Returns the complete text of the error message'

UNION ALL

SELECT 
    'Error Information Functions',
    'ERROR_SEVERITY()',
    'Returns the severity level of the error'

UNION ALL

SELECT 
    'Error Information Functions',
    'ERROR_STATE()',
    'Returns the error state number'

UNION ALL

SELECT 
    'Error Information Functions',
    'ERROR_PROCEDURE()',
    'Returns the name of the stored procedure or trigger where error occurred'

UNION ALL

SELECT 
    'Error Information Functions',
    'ERROR_LINE()',
    'Returns the line number where the error occurred';

-- Example of error information in action (this will generate an error)
BEGIN TRY
    -- Attempt to insert duplicate primary key
    INSERT INTO Employees (e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, e.HireDate, IsActive)
    VALUES (3001, 'Test', 'Employee', 50000, 2001, GETDATE(), 1);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        GETDATE() AS ErrorTime;
END CATCH;
```

---

## 1.2 Basic TRY...CATCH Structure

### Fundamental TRY...CATCH Syntax

The TRY...CATCH construct is the foundation of T-SQL error handling:

```sql
-- Basic TRY...CATCH structure for TechCorp operations
BEGIN TRY
    -- Code that might cause an error
    DECLARE @NewEmployeeID INT = 3050;
    DECLARE @d.DepartmentID INT = 2001;
    DECLARE @e.BaseSalary MONEY = 75000;
    
    -- Attempt to insert new employee
    INSERT INTO Employees (
        e.EmployeeID, 
        e.FirstName, 
        e.LastName, 
        e.BaseSalary, 
        d.DepartmentID, 
        e.HireDate, 
        IsActive
    )
    VALUES (
        @NewEmployeeID,
        'Sarah',
        'Johnson',
        @e.BaseSalary,
        @d.DepartmentID,
        GETDATE(),
        1
    );
    
    PRINT 'Employee successfully added with ID: ' + CAST(@NewEmployeeID AS VARCHAR(10));
    
END TRY
BEGIN CATCH
    -- Error handling code
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    
    PRINT 'Error occurred while adding employee:';
    PRINT 'Error Number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Error Message: ' + @ErrorMessage;
    PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS VARCHAR(10));
    
    -- Log the error for audit purposes
    INSERT INTO ErrorLog (
        ErrorNumber,
        ErrorMessage,
        ErrorProcedure,
        ErrorLine,
        ErrorSeverity,
        ErrorState,
        UserName,
        ErrorTime
    )
    VALUES (
        @ErrorNumber,
        @ErrorMessage,
        ISNULL(ERROR_PROCEDURE(), 'Ad-hoc Query'),
        ERROR_LINE(),
        @ErrorSeverity,
        @ErrorState,
        SYSTEM_USER,
        GETDATE()
    );
END CATCH;
```

### TechCorp Business Scenario: Employee e.BaseSalary Update

```sql
-- Comprehensive employee e.BaseSalary update with error handling
CREATE OR ALTER PROCEDURE UpdateEmployeeSalary
    @e.EmployeeID INT,
    @NewSalary MONEY,
    @UpdatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentSalary MONEY;
    DECLARE @DepartmentBudget MONEY;
    DECLARE @d.DepartmentID INT;
    DECLARE @EmployeeName NVARCHAR(100);
    
    BEGIN TRY
        -- Validate employee exists and is active
        SELECT 
            @CurrentSalary = e.BaseSalary,
            @d.DepartmentID = d.DepartmentID,
            @EmployeeName = e.FirstName + ' ' + e.LastName
        FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        IF @CurrentSalary IS NULL
        BEGIN
            RAISERROR('Employee ID %d not found or is inactive', 16, 1, @e.EmployeeID);
            RETURN;
        END
        
        -- Validate e.BaseSalary amount
        IF @NewSalary <= 0
        BEGIN
            RAISERROR('e.BaseSalary amount must be greater than zero', 16, 1);
            RETURN;
        END
        
        -- Check d.DepartmentName budget constraints
        SELECT @DepartmentBudget = d.Budget
        FROM Departments d 
        WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1;
        
        IF @NewSalary > @DepartmentBudget * 0.3  -- No single e.BaseSalary > 30% of dept budget
        BEGIN
            RAISERROR('Proposed e.BaseSalary exceeds d.DepartmentName budget constraints (max 30%% of budget)', 16, 1);
            RETURN;
        END
        
        -- Begin transaction for atomic update
        BEGIN TRANSACTION UpdateSalary;
        
        -- Update employee e.BaseSalary
        UPDATE Employees 
        SET e.BaseSalary = @NewSalary,
            LastModified = GETDATE(),
            LastModifiedBy = @UpdatedBy
        WHERE e.EmployeeID = @e.EmployeeID;
        
        -- Log the e.BaseSalary change for audit
        INSERT INTO SalaryHistory (
            e.EmployeeID,
            PreviousSalary,
            NewSalary,
            ChangeReason,
            ChangedBy,
            ChangeDate
        )
        VALUES (
            @e.EmployeeID,
            @CurrentSalary,
            @NewSalary,
            'Manual Update',
            @UpdatedBy,
            GETDATE()
        );
        
        COMMIT TRANSACTION UpdateSalary;
        
        PRINT 'e.BaseSalary successfully updated for ' + @EmployeeName;
        PRINT 'Previous e.BaseSalary: $' + FORMAT(@CurrentSalary, 'N2');
        PRINT 'New e.BaseSalary: $' + FORMAT(@NewSalary, 'N2');
        PRINT 'Change Amount: $' + FORMAT(@NewSalary - @CurrentSalary, 'N2');
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction if it exists
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION UpdateSalary;
        
        -- Capture error information
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        -- Log error for troubleshooting
        INSERT INTO ErrorLog (
            ErrorNumber,
            ErrorMessage,
            ErrorProcedure,
            ErrorLine,
            ErrorSeverity,
            ErrorState,
            UserName,
            ErrorTime,
            AdditionalInfo
        )
        VALUES (
            @ErrorNumber,
            @ErrorMessage,
            @ErrorProcedure,
            @ErrorLine,
            @ErrorSeverity,
            @ErrorState,
            @UpdatedBy,
            GETDATE(),
            'Employee ID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) + ', Proposed e.BaseSalary: $' + FORMAT(@NewSalary, 'N2')
        );
        
        -- Return user-friendly error message
        DECLARE @UserMessage NVARCHAR(1000);
        
        IF @ErrorNumber = 50000  -- Custom RAISERROR
            SET @UserMessage = @ErrorMessage;
        ELSE IF @ErrorNumber = 2  -- Constraint violation
            SET @UserMessage = 'Data validation error: Please check your input values';
        ELSE IF @ErrorNumber BETWEEN 2700 AND 2799  -- Index/constraint errors
            SET @UserMessage = 'Database constraint violation: The operation conflicts with existing data';
        ELSE
            SET @UserMessage = 'An unexpected error occurred. Please contact system administrator.';
        
        -- Re-raise with user-friendly message
        RAISERROR(@UserMessage, 16, 1);
    END CATCH
END;

-- Test the procedure with various scenarios
EXEC UpdateEmployeeSalary @e.EmployeeID = 3001, @NewSalary = 85000, @UpdatedBy = 'HR Manager';
EXEC UpdateEmployeeSalary @e.EmployeeID = 9999, @NewSalary = 75000, @UpdatedBy = 'HR Manager'; -- Non-existent employee
EXEC UpdateEmployeeSalary @e.EmployeeID = 3001, @NewSalary = -1000, @UpdatedBy = 'HR Manager'; -- Invalid e.BaseSalary
```

---

## 1.3 Transaction Management with Error Handling

### Atomic Operations with TRY...CATCH

```sql
-- TechCorp Example: Complex project assignment with full error handling
CREATE OR ALTER PROCEDURE AssignEmployeeToProject
    @e.EmployeeID INT,
    @ProjectID INT,
    @Role NVARCHAR(50),
    @StartDate DATE,
    @EstimatedHours INT = NULL,
    @AssignedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EmployeeName NVARCHAR(100);
    DECLARE @ProjectName NVARCHAR(100);
    DECLARE @ProjectManagerID INT;
    DECLARE @DepartmentID INT;
    
    BEGIN TRY
        -- Start transaction
        BEGIN TRANSACTION AssignToProject;
        
        -- Validate employee
        SELECT 
            @EmployeeName = e.FirstName + ' ' + e.LastName,
            @DepartmentID = DepartmentID
        FROM Employees e 
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        IF @EmployeeName IS NULL
        BEGIN
            RAISERROR('Employee ID %d not found or inactive', 16, 1, @e.EmployeeID);
        END
        
        -- Validate project
        SELECT 
            @ProjectName = ProjectName,
            @ProjectManagerID = ProjectManagerID
        FROM Projects p 
        WHERE ProjectID = @ProjectID AND IsActive = 1;
        
        IF @ProjectName IS NULL
        BEGIN
            RAISERROR('Project ID %d not found or inactive', 16, 1, @ProjectID);
        END
        
        -- Check for existing assignment
        IF EXISTS (
            SELECT 1 FROM EmployeeProjects 
            WHERE e.EmployeeID = @e.EmployeeID 
            AND ProjectID = @ProjectID 
            AND IsActive = 1
        )
        BEGIN
            RAISERROR('Employee %s is already assigned to project %s', 16, 1, @EmployeeName, @ProjectName);
        END
        
        -- Validate start date
        IF @StartDate < CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Project start date cannot be in the past', 16, 1);
        END
        
        -- Check employee availability (no more than 3 active projects)
        DECLARE @ActiveProjectCount INT;
        SELECT @ActiveProjectCount = COUNT(*)
        FROM EmployeeProjects 
        WHERE e.EmployeeID = @e.EmployeeID 
        AND IsActive = 1
        AND (EndDate IS NULL OR EndDate > GETDATE());
        
        IF @ActiveProjectCount >= 3
        BEGIN
            RAISERROR('Employee %s already assigned to maximum number of active projects (3)', 16, 1, @EmployeeName);
        END
        
        -- Insert the assignment
        INSERT INTO EmployeeProjects (
            e.EmployeeID,
            ProjectID,
            Role,
            StartDate,
            EndDate,
            HoursWorked,
            IsActive,
            CreatedBy,
            CreatedDate
        )
        VALUES (
            @e.EmployeeID,
            @ProjectID,
            @Role,
            @StartDate,
            NULL,  -- EndDate will be set when assignment ends
            @EstimatedHours,
            1,
            @AssignedBy,
            GETDATE()
        );
        
        -- Update project team count
        UPDATE Projects 
        SET TeamSize = (
            SELECT COUNT(*) 
            FROM EmployeeProjects 
            WHERE ProjectID = @ProjectID AND IsActive = 1
        ),
        LastModified = GETDATE(),
        LastModifiedBy = @AssignedBy
        WHERE ProjectID = @ProjectID;
        
        -- Log the assignment for audit
        INSERT INTO ProjectAssignmentLog (
            e.EmployeeID,
            ProjectID,
            Action,
            ActionBy,
            ActionDate,
            Details
        )
        VALUES (
            @e.EmployeeID,
            @ProjectID,
            'ASSIGNED',
            @AssignedBy,
            GETDATE(),
            'Role: ' + @Role + ', Start Date: ' + CAST(@StartDate AS VARCHAR(20))
        );
        
        COMMIT TRANSACTION AssignToProject;
        
        PRINT 'Successfully assigned ' + @EmployeeName + ' to project ' + @ProjectName;
        PRINT 'Role: ' + @Role;
        PRINT 'Start Date: ' + CAST(@StartDate AS VARCHAR(20));
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION AssignToProject;
        
        -- Log detailed error information
        INSERT INTO ErrorLog (
            ErrorNumber,
            ErrorMessage,
            ErrorProcedure,
            ErrorLine,
            ErrorSeverity,
            ErrorState,
            UserName,
            ErrorTime,
            AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            @AssignedBy,
            GETDATE(),
            'e.EmployeeID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) + 
            ', ProjectID: ' + CAST(@ProjectID AS VARCHAR(10)) + 
            ', Role: ' + ISNULL(@Role, 'NULL')
        );
        
        -- Provide user-friendly error message
        DECLARE @FriendlyMessage NVARCHAR(1000);
        
        IF ERROR_NUMBER() = 50000
            SET @FriendlyMessage = ERROR_MESSAGE();
        ELSE IF ERROR_NUMBER() = 2627  -- Primary key violation
            SET @FriendlyMessage = 'This assignment already exists in the system';
        ELSE IF ERROR_NUMBER() = 547   -- Foreign key violation
            SET @FriendlyMessage = 'Invalid employee or project reference';
        ELSE
            SET @FriendlyMessage = 'Project assignment failed due to system error. Please contact IT support.';
        
        RAISERROR(@FriendlyMessage, 16, 1);
    END CATCH
END;

-- Test the procedure
EXEC AssignEmployeeToProject 
    @e.EmployeeID = 3001, 
    @ProjectID = 4001, 
    @Role = 'Senior Developer', 
    @StartDate = '2024-02-01',
    @EstimatedHours = 160,
    @AssignedBy = 'Project Manager';
```

---

## 1.4 Custom Error Messages and RAISERROR

### Creating Custom Business Rule Errors

```sql
-- TechCorp Example: Custom error messages for business rules
CREATE OR ALTER PROCEDURE ProcessCustomerOrder
    @CustomerID INT,
    @e.EmployeeID INT,
    @OrderItems NVARCHAR(MAX), -- JSON format: [{"ItemID":1,"Quantity":2,"Price":100}]
    @OrderDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @OrderID INT;
    DECLARE @TotalAmount MONEY = 0;
    DECLARE @CustomerName NVARCHAR(100);
    DECLARE @EmployeeName NVARCHAR(100);
    
    -- Set default order date
    IF @OrderDate IS NULL
        SET @OrderDate = CAST(GETDATE() AS DATE);
    
    BEGIN TRY
        BEGIN TRANSACTION ProcessOrder;
        
        -- Validate customer
        SELECT @CustomerName = CompanyName
        FROM Customers 
        WHERE CustomerID = @CustomerID AND IsActive = 1;
        
        IF @CustomerName IS NULL
        BEGIN
            RAISERROR('Customer ID %d is not found or inactive. Please verify customer information.', 16, 1, @CustomerID);
        END
        
        -- Validate employee
        SELECT @EmployeeName = e.FirstName + ' ' + e.LastName
        FROM Employees e 
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        IF @EmployeeName IS NULL
        BEGIN
            RAISERROR('Employee ID %d is not found or inactive. Please assign a valid sales representative.', 16, 1, @e.EmployeeID);
        END
        
        -- Validate order date
        IF @OrderDate > DATEADD(DAY, 7, GETDATE())
        BEGIN
            RAISERROR('Order date cannot be more than 7 days in the future. Current date: %s, Order date: %s', 
                     16, 1, 
                     CAST(GETDATE() AS VARCHAR(20)), 
                     CAST(@OrderDate AS VARCHAR(20)));
        END
        
        IF @OrderDate < CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)
        BEGIN
            RAISERROR('Order date cannot be more than 1 year in the past. Please contact finance for historical order processing.', 16, 1);
        END
        
        -- Validate order items JSON
        IF @OrderItems IS NULL OR @OrderItems = ''
        BEGIN
            RAISERROR('Order must contain at least one item. Please add items to the order.', 16, 1);
        END
        
        -- Validate JSON format
        IF ISJSON(@OrderItems) = 0
        BEGIN
            RAISERROR('Order items format is invalid. Please provide items in valid JSON format.', 16, 1);
        END
        
        -- Calculate total amount from JSON
        SELECT @TotalAmount = SUM(CAST(JSON_VALUE(value, '$.Quantity') AS INT) * CAST(JSON_VALUE(value, '$.Price') AS MONEY))
        FROM OPENJSON(@OrderItems);
        
        -- Business rule: Minimum order amount
        IF @TotalAmount < 100
        BEGIN
            RAISERROR('Order total ($%.2f) is below minimum order amount of $100.00. Please add more items or contact sales for exceptions.', 
                     16, 1, @TotalAmount);
        END
        
        -- Business rule: Maximum single order amount
        IF @TotalAmount > 50000
        BEGIN
            RAISERROR('Order total ($%.2f) exceeds maximum single order limit of $50,000.00. Please contact management for approval.', 
                     16, 1, @TotalAmount);
        END
        
        -- Check customer credit limit (simulated)
        DECLARE @CustomerCreditLimit MONEY = 25000;  -- Would come from customer table
        DECLARE @CustomerCurrentBalance MONEY;
        
        SELECT @CustomerCurrentBalance = ISNULL(SUM(TotalAmount), 0)
        FROM Orders 
        WHERE CustomerID = @CustomerID 
        AND IsActive = 1 
        AND OrderDate >= DATEADD(MONTH, -3, GETDATE());  -- Last 3 months
        
        IF (@CustomerCurrentBalance + @TotalAmount) > @CustomerCreditLimit
        BEGIN
            RAISERROR('Order would exceed customer credit limit. Current balance: $%.2f, Credit limit: $%.2f, Order amount: $%.2f. Please contact credit department.', 
                     16, 1, @CustomerCurrentBalance, @CustomerCreditLimit, @TotalAmount);
        END
        
        -- Generate new order ID
        INSERT INTO Orders (
            CustomerID,
            e.EmployeeID,
            OrderDate,
            TotalAmount,
            IsActive,
            CreatedDate,
            CreatedBy
        )
        VALUES (
            @CustomerID,
            @e.EmployeeID,
            @OrderDate,
            @TotalAmount,
            1,
            GETDATE(),
            SYSTEM_USER
        );
        
        SET @OrderID = SCOPE_IDENTITY();
        
        -- Insert order items (simplified - would normally parse JSON and insert individual items)
        INSERT INTO OrderAudit (
            OrderID,
            CustomerID,
            e.EmployeeID,
            TotalAmount,
            OrderItems,
            CreatedDate
        )
        VALUES (
            @OrderID,
            @CustomerID,
            @e.EmployeeID,
            @TotalAmount,
            @OrderItems,
            GETDATE()
        );
        
        COMMIT TRANSACTION ProcessOrder;
        
        -- Success message
        PRINT 'Order successfully processed:';
        PRINT 'Order ID: ' + CAST(@OrderID AS VARCHAR(10));
        PRINT 'Customer: ' + @CustomerName;
        PRINT 'Sales Rep: ' + @EmployeeName;
        PRINT 'Order Date: ' + CAST(@OrderDate AS VARCHAR(20));
        PRINT 'Total Amount: $' + FORMAT(@TotalAmount, 'N2');
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION ProcessOrder;
        
        -- Enhanced error logging
        DECLARE @ErrorContext NVARCHAR(MAX) = 
            'CustomerID: ' + CAST(@CustomerID AS VARCHAR(10)) + 
            ', e.EmployeeID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) + 
            ', OrderDate: ' + CAST(@OrderDate AS VARCHAR(20)) + 
            ', TotalAmount: $' + FORMAT(@TotalAmount, 'N2') +
            ', OrderItems: ' + ISNULL(@OrderItems, 'NULL');
        
        INSERT INTO ErrorLog (
            ErrorNumber,
            ErrorMessage,
            ErrorProcedure,
            ErrorLine,
            ErrorSeverity,
            ErrorState,
            UserName,
            ErrorTime,
            AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            SYSTEM_USER,
            GETDATE(),
            @ErrorContext
        );
        
        -- Re-raise the error to calling application
        THROW;
    END CATCH
END;

-- Test various error scenarios
EXEC ProcessCustomerOrder 
    @CustomerID = 6001, 
    @e.EmployeeID = 3001, 
    @OrderItems = '[{"ItemID":1,"Quantity":2,"Price":150}]',
    @OrderDate = '2024-01-15';

-- Test with invalid customer
EXEC ProcessCustomerOrder 
    @CustomerID = 9999, 
    @e.EmployeeID = 3001, 
    @OrderItems = '[{"ItemID":1,"Quantity":1,"Price":50}]';

-- Test with amount below minimum
EXEC ProcessCustomerOrder 
    @CustomerID = 6001, 
    @e.EmployeeID = 3001, 
    @OrderItems = '[{"ItemID":1,"Quantity":1,"Price":50}]';
```

---

## 1.5 Error Handling Best Practices

### TechCorp Error Handling Standards

```sql
-- TechCorp Standard Error Handling Template
CREATE OR ALTER PROCEDURE TechCorpProcedureTemplate
    @Parameter1 INT,
    @Parameter2 NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF;  -- Handle transactions manually
    
    -- Variable declarations
    DECLARE @ProcedureName NVARCHAR(128) = OBJECT_NAME(@@PROCID);
    DECLARE @StartTime DATETIME2 = GETDATE();
    DECLARE @RowsAffected INT = 0;
    
    BEGIN TRY
        -- Input validation
        IF @Parameter1 IS NULL OR @Parameter1 <= 0
        BEGIN
            RAISERROR('Parameter1 must be a positive integer', 16, 1);
        END
        
        IF @Parameter2 IS NULL OR LEN(@Parameter2) = 0
        BEGIN
            RAISERROR('Parameter2 cannot be null or empty', 16, 1);
        END
        
        -- Business logic here
        BEGIN TRANSACTION;
        
        -- Your actual procedure logic
        -- Example: UPDATE/INSERT/DELETE operations
        
        SET @RowsAffected = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        -- Success logging
        INSERT INTO ProcedureExecutionLog (
            ProcedureName,
            ExecutionTime,
            RowsAffected,
            Parameters,
            Status,
            Duration
        )
        VALUES (
            @ProcedureName,
            @StartTime,
            @RowsAffected,
            'Param1: ' + CAST(@Parameter1 AS VARCHAR(10)) + ', Param2: ' + @Parameter2,
            'SUCCESS',
            DATEDIFF(MILLISECOND, @StartTime, GETDATE())
        );
        
    END TRY
    BEGIN CATCH
        -- Rollback if transaction is active
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Comprehensive error logging
        INSERT INTO ErrorLog (
            ErrorNumber,
            ErrorMessage,
            ErrorProcedure,
            ErrorLine,
            ErrorSeverity,
            ErrorState,
            UserName,
            ErrorTime,
            AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            @ProcedureName,
            ERROR_LINE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            SYSTEM_USER,
            GETDATE(),
            'Param1: ' + CAST(@Parameter1 AS VARCHAR(10)) + ', Param2: ' + ISNULL(@Parameter2, 'NULL')
        );
        
        -- Execution failure logging
        INSERT INTO ProcedureExecutionLog (
            ProcedureName,
            ExecutionTime,
            RowsAffected,
            Parameters,
            Status,
            Duration,
            ErrorMessage
        )
        VALUES (
            @ProcedureName,
            @StartTime,
            0,
            'Param1: ' + CAST(@Parameter1 AS VARCHAR(10)) + ', Param2: ' + ISNULL(@Parameter2, 'NULL'),
            'FAILED',
            DATEDIFF(MILLISECOND, @StartTime, GETDATE()),
            ERROR_MESSAGE()
        );
        
        -- Re-raise error with context
        DECLARE @CustomMessage NVARCHAR(MAX) = 
            'Error in ' + @ProcedureName + ': ' + ERROR_MESSAGE();
        
        RAISERROR(@CustomMessage, ERROR_SEVERITY(), ERROR_STATE());
    END CATCH
END;
```

---

## Summary

Implementing effective T-SQL error handling is crucial for TechCorp's database operations:

**Key Error Handling Concepts:**

- **TRY...CATCH Blocks**: Foundation for structured error handling in T-SQL
- **Error Information Functions**: Retrieving detailed error information for logging and debugging
- **Transaction Management**: Ensuring data consistency during error conditions
- **Custom Error Messages**: Providing meaningful business-context error messages
- **Error Logging**: Maintaining audit trails for troubleshooting and compliance

**TechCorp Best Practices:**

- **Comprehensive Validation**: Validate all inputs and business rules before processing
- **Atomic Operations**: Use transactions to ensure data consistency
- **Meaningful Messages**: Provide user-friendly error messages while logging technical details
- **Proper Logging**: Maintain detailed error logs for troubleshooting and audit purposes
- **Graceful Degradation**: Handle errors in a way that maintains system stability

**Business Benefits:**

- **Data Integrity**: Protecting critical business data through proper error handling
- **User Experience**: Providing clear, actionable error messages to users
- **Operational Efficiency**: Reducing troubleshooting time through comprehensive error logging
- **Compliance**: Meeting audit requirements for error tracking and resolution
- **System Reliability**: Building robust applications that handle unexpected conditions gracefully

**Advanced Techniques Demonstrated:**

- **Nested Transaction Handling**: Managing complex transaction scenarios
- **Context-Aware Error Messages**: Providing relevant information based on business context
- **Error Categorization**: Handling different types of errors with appropriate responses
- **Performance Monitoring**: Tracking procedure execution success/failure rates

Understanding and implementing these error handling techniques enables TechCorp's development teams to build robust, reliable database applications that provide excellent user experience while maintaining data integrity and operational efficiency.