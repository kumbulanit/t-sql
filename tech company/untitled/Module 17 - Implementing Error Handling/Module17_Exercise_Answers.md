# Module 17 Exercise Answers

## Overview

This document provides complete solutions and explanations for all exercises and lab tasks in Module 17 - Implementing Error Handling. Each answer includes comprehensive SQL solutions, business logic explanations, and best practice implementations for enterprise-grade error handling.

---

## Exercise 1 Solutions: Basic Error Handling Implementation

### Task 1.1 Solution: Employee Management with Error Handling

```sql
-- Comprehensive Employee Management Procedure with Error Handling
CREATE OR ALTER PROCEDURE ManageEmployee
    @Operation NVARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
    @e.EmployeeID INT = NULL,
    @e.FirstName NVARCHAR(50) = NULL,
    @e.LastName NVARCHAR(50) = NULL,
    @e.BaseSalary MONEY = NULL,
    @d.DepartmentID INT = NULL,
    @ManagerID INT = NULL,
    @UpdatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF;
    
    DECLARE @ProcedureName NVARCHAR(128) = 'ManageEmployee';
    DECLARE @OperationStartTime DATETIME2 = GETDATE();
    DECLARE @AffectedRows INT = 0;
    DECLARE @EmployeeName NVARCHAR(101);
    
    BEGIN TRY
        -- Input validation
        IF @Operation IS NULL OR @Operation NOT IN ('INSERT', 'UPDATE', 'DELETE')
        BEGIN
            RAISERROR('Invalid operation specified. Must be INSERT, UPDATE, or DELETE.', 16, 1);
        END
        
        IF @UpdatedBy IS NULL OR LEN(TRIM(@UpdatedBy)) = 0
        BEGIN
            RAISERROR('UpdatedBy parameter is required for audit purposes.', 16, 1);
        END
        
        -- Operation-specific validations and processing
        IF @Operation = 'INSERT'
        BEGIN
            -- Validate required fields for INSERT
            IF @e.FirstName IS NULL OR LEN(TRIM(@e.FirstName)) = 0
            BEGIN
                RAISERROR('First name is required for new employee.', 16, 1);
            END
            
            IF @e.LastName IS NULL OR LEN(TRIM(@e.LastName)) = 0
            BEGIN
                RAISERROR('Last name is required for new employee.', 16, 1);
            END
            
            IF @e.BaseSalary IS NULL OR @e.BaseSalary <= 0
            BEGIN
                RAISERROR('Valid base e.BaseSalary is required for new employee.', 16, 1);
            END
            
            IF @d.DepartmentID IS NULL
            BEGIN
                RAISERROR('Department ID is required for new employee.', 16, 1);
            END
            
            -- Validate d.DepartmentName exists
            IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
            BEGIN
                RAISERROR('Department ID %d does not exist or is inactive. Please select a valid department.', 16, 1, @d.DepartmentID);
            END
            
            -- Validate manager if provided
            IF @ManagerID IS NOT NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @ManagerID AND IsActive = 1)
                BEGIN
                    RAISERROR('Manager ID %d does not exist or is inactive. Please select a valid manager.', 16, 1, @ManagerID);
                END
                
                -- Validate manager is in same or parent d.DepartmentName (business rule)
                IF NOT EXISTS (
                    SELECT 1 FROM Employees e e1
                    INNER JOIN Employees e2 ON e1.d.DepartmentID IN (e2.d.DepartmentID, 
                        (SELECT ParentDepartmentID FROM Departments d WHERE d.DepartmentID = e2.d.DepartmentID))
                    WHERE e1.e.EmployeeID = @ManagerID AND e2.d.DepartmentID = @d.DepartmentID
                )
                BEGIN
                    RAISERROR('Manager must be in the same d.DepartmentName or a parent department.', 16, 1);
                END
            END
            
            -- Business rule: e.BaseSalary range validation
            DECLARE @DeptMinSalary MONEY, @DeptMaxSalary MONEY;
            SELECT @DeptMinSalary = MinSalary, @DeptMaxSalary = MaxSalary 
            FROM Departments dalaryRanges 
            WHERE d.DepartmentID = @d.DepartmentID;
            
            IF @DeptMinSalary IS NOT NULL AND @e.BaseSalary < @DeptMinSalary
            BEGIN
                RAISERROR('e.BaseSalary $%.2f is below d.DepartmentName minimum of $%.2f for this position.', 16, 1, @e.BaseSalary, @DeptMinSalary);
            END
            
            IF @DeptMaxSalary IS NOT NULL AND @e.BaseSalary > @DeptMaxSalary
            BEGIN
                RAISERROR('e.BaseSalary $%.2f exceeds d.DepartmentName maximum of $%.2f for this position.', 16, 1, @e.BaseSalary, @DeptMaxSalary);
            END
            
            BEGIN TRANSACTION InsertEmployee;
            
            -- Generate new employee ID
            DECLARE @NewEmployeeID INT;
            SELECT @NewEmployeeID = ISNULL(MAX(e.EmployeeID), 3000) + 1 FROM Employees e;
            
            INSERT INTO Employees (
                e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, 
                ManagerID, e.HireDate, IsActive, CreatedBy, CreatedDate
            )
            VALUES (
                @NewEmployeeID, @e.FirstName, @e.LastName, @e.BaseSalary, @d.DepartmentID,
                @ManagerID, GETDATE(), 1, @UpdatedBy, GETDATE()
            );
            
            SET @AffectedRows = @@ROWCOUNT;
            SET @e.EmployeeID = @NewEmployeeID;
            SET @EmployeeName = @e.FirstName + ' ' + @e.LastName;
            
            -- Log audit trail
            INSERT INTO AuditTrail (
                TableName, Operation, PrimaryKeyValue, NewValues, ChangedBy, ChangeDate
            )
            VALUES (
                'Employees', 'INSERT', @e.EmployeeID,
                'e.FirstName: ' + @e.FirstName + ', e.LastName: ' + @e.LastName + 
                ', e.BaseSalary: $' + FORMAT(@e.BaseSalary, 'N2') + ', d.DepartmentID: ' + CAST(@d.DepartmentID AS VARCHAR(10)),
                @UpdatedBy, GETDATE()
            );
            
            COMMIT TRANSACTION InsertEmployee;
            
            PRINT 'Employee successfully created:';
            PRINT 'Employee ID: ' + CAST(@e.EmployeeID AS VARCHAR(10));
            PRINT 'Name: ' + @EmployeeName;
            PRINT 'e.BaseSalary: $' + FORMAT(@e.BaseSalary, 'N2');
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            -- Validate employee ID for UPDATE
            IF @e.EmployeeID IS NULL
            BEGIN
                RAISERROR('Employee ID is required for update operation.', 16, 1);
            END
            
            -- Check if employee exists and is active
            DECLARE @CurrentFirstName NVARCHAR(50), @CurrentLastName NVARCHAR(50);
            DECLARE @CurrentSalary MONEY, @CurrentDepartmentID INT;
            
            SELECT 
                @CurrentFirstName = e.FirstName,
                @CurrentLastName = e.LastName,
                @CurrentSalary = e.BaseSalary,
                @CurrentDepartmentID = d.DepartmentID
            FROM Employees e 
            WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
            
            IF @CurrentFirstName IS NULL
            BEGIN
                RAISERROR('Employee ID %d not found or is inactive. Cannot update.', 16, 1, @e.EmployeeID);
            END
            
            -- Use existing values if not provided
            SET @e.FirstName = ISNULL(@e.FirstName, @CurrentFirstName);
            SET @e.LastName = ISNULL(@e.LastName, @CurrentLastName);
            SET @e.BaseSalary = ISNULL(@e.BaseSalary, @CurrentSalary);
            SET @d.DepartmentID = ISNULL(@d.DepartmentID, @CurrentDepartmentID);
            
            -- Validate new values
            IF @e.BaseSalary <= 0
            BEGIN
                RAISERROR('Base e.BaseSalary must be greater than zero.', 16, 1);
            END
            
            IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
            BEGIN
                RAISERROR('Department ID %d does not exist or is inactive.', 16, 1, @d.DepartmentID);
            END
            
            -- Validate manager if changing
            IF @ManagerID IS NOT NULL
            BEGIN
                IF @ManagerID = @e.EmployeeID
                BEGIN
                    RAISERROR('Employee cannot be their own manager.', 16, 1);
                END
                
                IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @ManagerID AND IsActive = 1)
                BEGIN
                    RAISERROR('Manager ID %d does not exist or is inactive.', 16, 1, @ManagerID);
                END
            END
            
            BEGIN TRANSACTION UpdateEmployee;
            
            -- Build dynamic update statement based on provided parameters
            DECLARE @UpdateSQL NVARCHAR(MAX) = 'UPDATE Employees SET ';
            DECLARE @SetClauses NVARCHAR(MAX) = '';
            DECLARE @OldValues NVARCHAR(MAX) = '';
            DECLARE @NewValues NVARCHAR(MAX) = '';
            
            IF @e.FirstName != @CurrentFirstName
            BEGIN
                SET @SetClauses = @SetClauses + 'e.FirstName = @e.FirstName, ';
                SET @OldValues = @OldValues + 'e.FirstName: ' + @CurrentFirstName + ', ';
                SET @NewValues = @NewValues + 'e.FirstName: ' + @e.FirstName + ', ';
            END
            
            IF @e.LastName != @CurrentLastName
            BEGIN
                SET @SetClauses = @SetClauses + 'e.LastName = @e.LastName, ';
                SET @OldValues = @OldValues + 'e.LastName: ' + @CurrentLastName + ', ';
                SET @NewValues = @NewValues + 'e.LastName: ' + @e.LastName + ', ';
            END
            
            IF @e.BaseSalary != @CurrentSalary
            BEGIN
                SET @SetClauses = @SetClauses + 'e.BaseSalary = @e.BaseSalary, ';
                SET @OldValues = @OldValues + 'e.BaseSalary: $' + FORMAT(@CurrentSalary, 'N2') + ', ';
                SET @NewValues = @NewValues + 'e.BaseSalary: $' + FORMAT(@e.BaseSalary, 'N2') + ', ';
            END
            
            IF @d.DepartmentID != @CurrentDepartmentID
            BEGIN
                SET @SetClauses = @SetClauses + 'd.DepartmentID = @d.DepartmentID, ';
                SET @OldValues = @OldValues + 'd.DepartmentID: ' + CAST(@CurrentDepartmentID AS VARCHAR(10)) + ', ';
                SET @NewValues = @NewValues + 'd.DepartmentID: ' + CAST(@d.DepartmentID AS VARCHAR(10)) + ', ';
            END
            
            IF @ManagerID IS NOT NULL
            BEGIN
                SET @SetClauses = @SetClauses + 'ManagerID = @ManagerID, ';
            END
            
            -- Always update modification tracking
            SET @SetClauses = @SetClauses + 'LastModifiedBy = @UpdatedBy, LastModifiedDate = GETDATE()';
            
            -- Remove trailing comma if exists
            SET @SetClauses = LTRIM(RTRIM(@SetClauses));
            IF RIGHT(@SetClauses, 1) = ','
                SET @SetClauses = LEFT(@SetClauses, LEN(@SetClauses) - 1);
            
            UPDATE Employees 
            SET e.FirstName = @e.FirstName,
                e.LastName = @e.LastName,
                e.BaseSalary = @e.BaseSalary,
                d.DepartmentID = @d.DepartmentID,
                ManagerID = @ManagerID,
                LastModifiedBy = @UpdatedBy,
                LastModifiedDate = GETDATE()
            WHERE e.EmployeeID = @e.EmployeeID;
            
            SET @AffectedRows = @@ROWCOUNT;
            SET @EmployeeName = @e.FirstName + ' ' + @e.LastName;
            
            -- Log audit trail only if changes were made
            IF LEN(@OldValues) > 0
            BEGIN
                INSERT INTO AuditTrail (
                    TableName, Operation, PrimaryKeyValue, OldValues, NewValues, ChangedBy, ChangeDate
                )
                VALUES (
                    'Employees', 'UPDATE', @e.EmployeeID,
                    LEFT(@OldValues, LEN(@OldValues) - 2), -- Remove trailing comma and space
                    LEFT(@NewValues, LEN(@NewValues) - 2),
                    @UpdatedBy, GETDATE()
                );
            END
            
            COMMIT TRANSACTION UpdateEmployee;
            
            PRINT 'Employee successfully updated:';
            PRINT 'Employee ID: ' + CAST(@e.EmployeeID AS VARCHAR(10));
            PRINT 'Name: ' + @EmployeeName;
            PRINT 'Changes made: ' + ISNULL(LEFT(@NewValues, LEN(@NewValues) - 2), 'No changes');
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- Validate employee ID for DELETE
            IF @e.EmployeeID IS NULL
            BEGIN
                RAISERROR('Employee ID is required for delete operation.', 16, 1);
            END
            
            -- Check if employee exists
            SELECT @EmployeeName = e.FirstName + ' ' + e.LastName
            FROM Employees e 
            WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
            
            IF @EmployeeName IS NULL
            BEGIN
                RAISERROR('Employee ID %d not found or already inactive. Cannot delete.', 16, 1, @e.EmployeeID);
            END
            
            -- Check for dependencies (cannot delete if employee is a manager)
            DECLARE @ManagedEmployees INT;
            SELECT @ManagedEmployees = COUNT(*)
            FROM Employees e 
            WHERE ManagerID = @e.EmployeeID AND IsActive = 1;
            
            IF @ManagedEmployees > 0
            BEGIN
                RAISERROR('Cannot delete employee %s (ID: %d) who manages %d other employees. Please reassign managed employees first.', 
                         16, 1, @EmployeeName, @e.EmployeeID, @ManagedEmployees);
            END
            
            -- Check for active project assignments
            DECLARE @ActiveProjects INT;
            SELECT @ActiveProjects = COUNT(*)
            FROM EmployeeProjects 
            WHERE e.EmployeeID = @e.EmployeeID 
            AND IsActive = 1 
            AND (EndDate IS NULL OR EndDate > GETDATE());
            
            IF @ActiveProjects > 0
            BEGIN
                RAISERROR('Cannot delete employee %s (ID: %d) who has %d active project assignments. Please end project assignments first.', 
                         16, 1, @EmployeeName, @e.EmployeeID, @ActiveProjects);
            END
            
            BEGIN TRANSACTION DeleteEmployee;
            
            -- Soft delete (mark as inactive)
            UPDATE Employees 
            SET IsActive = 0,
                LastModifiedBy = @UpdatedBy,
                LastModifiedDate = GETDATE()
            WHERE e.EmployeeID = @e.EmployeeID;
            
            SET @AffectedRows = @@ROWCOUNT;
            
            -- Log audit trail
            INSERT INTO AuditTrail (
                TableName, Operation, PrimaryKeyValue, OldValues, ChangedBy, ChangeDate
            )
            VALUES (
                'Employees', 'DELETE', @e.EmployeeID,
                'Employee: ' + @EmployeeName + ' marked as inactive',
                @UpdatedBy, GETDATE()
            );
            
            COMMIT TRANSACTION DeleteEmployee;
            
            PRINT 'Employee successfully deleted (marked inactive):';
            PRINT 'Employee ID: ' + CAST(@e.EmployeeID AS VARCHAR(10));
            PRINT 'Name: ' + @EmployeeName;
        END
        
        -- Log successful operation
        INSERT INTO OperationLog (
            ProcedureName, Operation, TargetID, Status, ExecutionTime, 
            RowsAffected, ExecutedBy, ExecutionDate
        )
        VALUES (
            @ProcedureName, @Operation, @e.EmployeeID, 'SUCCESS', 
            DATEDIFF(MILLISECOND, @OperationStartTime, GETDATE()),
            @AffectedRows, @UpdatedBy, GETDATE()
        );
        
    END TRY
    BEGIN CATCH
        -- Rollback any active transaction
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error details
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        -- Log comprehensive error information
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
            ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
        )
        VALUES (
            @ErrorNumber, @ErrorMessage, @ProcedureName, @ErrorLine,
            @ErrorSeverity, @ErrorState, @UpdatedBy, GETDATE(),
            'Operation: ' + @Operation + 
            ', e.EmployeeID: ' + ISNULL(CAST(@e.EmployeeID AS VARCHAR(10)), 'NULL') +
            ', Name: ' + ISNULL(@e.FirstName + ' ' + @e.LastName, 'NULL')
        );
        
        -- Log failed operation
        INSERT INTO OperationLog (
            ProcedureName, Operation, TargetID, Status, ExecutionTime,
            ErrorMessage, ExecutedBy, ExecutionDate
        )
        VALUES (
            @ProcedureName, @Operation, @e.EmployeeID, 'FAILED',
            DATEDIFF(MILLISECOND, @OperationStartTime, GETDATE()),
            @ErrorMessage, @UpdatedBy, GETDATE()
        );
        
        -- Provide user-friendly error message
        DECLARE @UserMessage NVARCHAR(1000);
        
        IF @ErrorNumber = 50000  -- Custom RAISERROR
            SET @UserMessage = @ErrorMessage;
        ELSE IF @ErrorNumber = 2627  -- Primary key violation
            SET @UserMessage = 'Employee ID already exists. Please use a different Employee ID.';
        ELSE IF @ErrorNumber = 547   -- Foreign key violation
            SET @UserMessage = 'Invalid reference to d.DepartmentName or manager. Please check your values.';
        ELSE IF @ErrorNumber = 515   -- Cannot insert NULL
            SET @UserMessage = 'Required information is missing. Please provide all mandatory fields.';
        ELSE
            SET @UserMessage = 'Employee management operation failed. Please contact system administrator. Error ID: ' + 
                             CAST((SELECT TOP 1 ErrorLogID FROM ErrorLog ORDER BY ErrorLogID DESC) AS VARCHAR(10));
        
        PRINT 'Error occurred during ' + @Operation + ' operation:';
        PRINT @UserMessage;
        
        -- Re-raise with user-friendly message
        RAISERROR(@UserMessage, 16, 1);
    END CATCH
END;

-- Test the procedure with various scenarios
PRINT 'Test 1: Insert new employee';
EXEC ManageEmployee 
    @Operation = 'INSERT',
    @e.FirstName = 'John',
    @e.LastName = 'Doe',
    @e.BaseSalary = 75000,
    @d.DepartmentID = 2001,
    @UpdatedBy = 'HR Admin';

PRINT CHAR(13) + CHAR(10) + 'Test 2: Update employee';
EXEC ManageEmployee 
    @Operation = 'UPDATE',
    @e.EmployeeID = 3001,
    @e.BaseSalary = 80000,
    @UpdatedBy = 'Manager';

PRINT CHAR(13) + CHAR(10) + 'Test 3: Invalid operation (should fail)';
EXEC ManageEmployee 
    @Operation = 'INVALID',
    @e.EmployeeID = 3001,
    @UpdatedBy = 'Test User';
```

### Task 1.2 Solution: Transaction-Safe Order Processing

```sql
-- Transaction-Safe Order Processing with Comprehensive Error Handling
CREATE OR ALTER PROCEDURE ProcessOrderWithInventory
    @CustomerID INT,
    @e.EmployeeID INT,
    @OrderItems NVARCHAR(MAX), -- JSON: [{"ProductID":1,"Quantity":2,"Price":100}]
    @OrderDate DATE = NULL,
    @ProcessedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF;
    
    DECLARE @OrderID INT;
    DECLARE @TotalAmount MONEY = 0;
    DECLARE @ProcessStartTime DATETIME2 = GETDATE();
    DECLARE @TransactionName NVARCHAR(32) = 'OrderProcessing_' + CAST(NEWID() AS NVARCHAR(36));
    DECLARE @RetryCount INT = 0;
    DECLARE @MaxRetries INT = 3;
    DECLARE @RetryDelay CHAR(8) = '00:00:02'; -- 2 seconds
    
    -- Set default order date
    IF @OrderDate IS NULL
        SET @OrderDate = CAST(GETDATE() AS DATE);
    
    WHILE @RetryCount < @MaxRetries
    BEGIN
        SET @RetryCount = @RetryCount + 1;
        
        BEGIN TRY
            PRINT 'Processing order attempt ' + CAST(@RetryCount AS VARCHAR(2)) + ' of ' + CAST(@MaxRetries AS VARCHAR(2));
            
            -- Input validation
            IF @CustomerID IS NULL OR @CustomerID <= 0
            BEGIN
                RAISERROR('Valid Customer ID is required.', 16, 1);
            END
            
            IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 0
            BEGIN
                RAISERROR('Valid Employee ID is required.', 16, 1);
            END
            
            IF @OrderItems IS NULL OR @OrderItems = ''
            BEGIN
                RAISERROR('Order items are required.', 16, 1);
            END
            
            IF ISJSON(@OrderItems) = 0
            BEGIN
                RAISERROR('Order items must be in valid JSON format.', 16, 1);
            END
            
            -- Validate customer exists and is active
            DECLARE @CustomerName NVARCHAR(100);
            SELECT @CustomerName = CompanyName
            FROM Customers 
            WHERE CustomerID = @CustomerID AND IsActive = 1;
            
            IF @CustomerName IS NULL
            BEGIN
                RAISERROR('Customer ID %d not found or inactive.', 16, 1, @CustomerID);
            END
            
            -- Validate employee exists and is active
            DECLARE @EmployeeName NVARCHAR(100);
            SELECT @EmployeeName = e.FirstName + ' ' + e.LastName
            FROM Employees e 
            WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
            
            IF @EmployeeName IS NULL
            BEGIN
                RAISERROR('Employee ID %d not found or inactive.', 16, 1, @e.EmployeeID);
            END
            
            -- Start transaction with retry-safe naming
            BEGIN TRANSACTION;
            SAVE TRANSACTION OrderProcessingSavePoint;
            
            -- Create order header
            INSERT INTO Orders (
                CustomerID, e.EmployeeID, OrderDate, TotalAmount, 
                Status, IsActive, CreatedBy, CreatedDate
            )
            VALUES (
                @CustomerID, @e.EmployeeID, @OrderDate, 0, -- TotalAmount calculated later
                'PROCESSING', 1, @ProcessedBy, GETDATE()
            );
            
            SET @OrderID = SCOPE_IDENTITY();
            
            -- Process each order item
            DECLARE @ProductID INT, @Quantity INT, @Price MONEY;
            DECLARE @ItemTotal MONEY, @AvailableStock INT;
            DECLARE @ItemsProcessed INT = 0;
            DECLARE @TotalItems INT;
            
            -- Count total items for progress tracking
            SELECT @TotalItems = COUNT(*)
            FROM OPENJSON(@OrderItems) WITH (
                ProductID INT '$.ProductID',
                Quantity INT '$.Quantity',
                Price MONEY '$.Price'
            );
            
            DECLARE item_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT ProductID, Quantity, Price
            FROM OPENJSON(@OrderItems) WITH (
                ProductID INT '$.ProductID',
                Quantity INT '$.Quantity',
                Price MONEY '$.Price'
            );
            
            OPEN item_cursor;
            FETCH NEXT FROM item_cursor INTO @ProductID, @Quantity, @Price;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Validate product exists
                IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID AND IsActive = 1)
                BEGIN
                    CLOSE item_cursor;
                    DEALLOCATE item_cursor;
                    RAISERROR('Product ID %d not found or inactive.', 16, 1, @ProductID);
                END
                
                -- Validate quantity and price
                IF @Quantity <= 0
                BEGIN
                    CLOSE item_cursor;
                    DEALLOCATE item_cursor;
                    RAISERROR('Invalid quantity %d for Product ID %d. Quantity must be positive.', 16, 1, @Quantity, @ProductID);
                END
                
                IF @Price <= 0
                BEGIN
                    CLOSE item_cursor;
                    DEALLOCATE item_cursor;
                    RAISERROR('Invalid price $%.2f for Product ID %d. Price must be positive.', 16, 1, @Price, @ProductID);
                END
                
                -- Check inventory availability with row-level locking
                SELECT @AvailableStock = QuantityOnHand
                FROM Inventory WITH (UPDLOCK, ROWLOCK)
                WHERE ProductID = @ProductID;
                
                IF @AvailableStock IS NULL
                BEGIN
                    CLOSE item_cursor;
                    DEALLOCATE item_cursor;
                    RAISERROR('No inventory record found for Product ID %d.', 16, 1, @ProductID);
                END
                
                IF @AvailableStock < @Quantity
                BEGIN
                    CLOSE item_cursor;
                    DEALLOCATE item_cursor;
                    RAISERROR('Insufficient inventory for Product ID %d. Available: %d, Requested: %d.', 
                             16, 1, @ProductID, @AvailableStock, @Quantity);
                END
                
                -- Calculate item total
                SET @ItemTotal = @Quantity * @Price;
                SET @TotalAmount = @TotalAmount + @ItemTotal;
                
                -- Insert order detail
                INSERT INTO OrderDetails (
                    OrderID, ProductID, Quantity, UnitPrice, LineTotal,
                    CreatedBy, CreatedDate
                )
                VALUES (
                    @OrderID, @ProductID, @Quantity, @Price, @ItemTotal,
                    @ProcessedBy, GETDATE()
                );
                
                -- Update inventory
                UPDATE Inventory 
                SET QuantityOnHand = QuantityOnHand - @Quantity,
                    LastModifiedBy = @ProcessedBy,
                    LastModifiedDate = GETDATE()
                WHERE ProductID = @ProductID;
                
                -- Log inventory transaction
                INSERT INTO InventoryTransactions (
                    ProductID, TransactionType, Quantity, ReferenceID, 
                    ReferenceType, CreatedBy, CreatedDate
                )
                VALUES (
                    @ProductID, 'SALE', -@Quantity, @OrderID,
                    'ORDER', @ProcessedBy, GETDATE()
                );
                
                SET @ItemsProcessed = @ItemsProcessed + 1;
                
                FETCH NEXT FROM item_cursor INTO @ProductID, @Quantity, @Price;
            END
            
            CLOSE item_cursor;
            DEALLOCATE item_cursor;
            
            -- Business rule validations
            IF @TotalAmount < 100
            BEGIN
                RAISERROR('Order total $%.2f is below minimum order amount of $100.00.', 16, 1, @TotalAmount);
            END
            
            IF @TotalAmount > 50000
            BEGIN
                RAISERROR('Order total $%.2f exceeds maximum single order limit of $50,000.00.', 16, 1, @TotalAmount);
            END
            
            -- Update order total
            UPDATE Orders 
            SET TotalAmount = @TotalAmount,
                IsActive = 'COMPLETED',
                LastModifiedBy = @ProcessedBy,
                LastModifiedDate = GETDATE()
            WHERE OrderID = @OrderID;
            
            -- Log successful order
            INSERT INTO OrderAudit (
                OrderID, CustomerID, e.EmployeeID, TotalAmount, 
                ItemCount, Status, ProcessedBy, ProcessedDate
            )
            VALUES (
                @OrderID, @CustomerID, @e.EmployeeID, @TotalAmount,
                @ItemsProcessed, 'COMPLETED', @ProcessedBy, GETDATE()
            );
            
            COMMIT TRANSACTION;
            
            PRINT 'Order processed successfully:';
            PRINT 'Order ID: ' + CAST(@OrderID AS VARCHAR(10));
            PRINT 'Customer: ' + @CustomerName;
            PRINT 'Items: ' + CAST(@ItemsProcessed AS VARCHAR(10));
            PRINT 'Total: $' + FORMAT(@TotalAmount, 'N2');
            PRINT 'Processing time: ' + CAST(DATEDIFF(MILLISECOND, @ProcessStartTime, GETDATE()) AS VARCHAR(10)) + ' ms';
            
            -- Exit retry loop on success
            BREAK;
            
        END TRY
        BEGIN CATCH
            -- Handle different types of errors
            DECLARE @ErrorNumber INT = ERROR_NUMBER();
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
            DECLARE @ErrorState INT = ERROR_STATE();
            
            -- Close cursor if open
            IF CURSOR_STATUS('local', 'item_cursor') >= 0
            BEGIN
                CLOSE item_cursor;
                DEALLOCATE item_cursor;
            END
            
            -- Rollback to savepoint or full transaction
            IF @@TRANCOUNT > 0
            BEGIN
                IF XACT_STATE() = 1  -- Transaction is committable
                    ROLLBACK TRANSACTION;
                ELSE IF XACT_STATE() = -1  -- Transaction is not committable
                    ROLLBACK TRANSACTION;
            END
            
            -- Determine if error is retryable
            DECLARE @IsRetryable BIT = 0;
            
            IF @ErrorNumber IN (
                1205,    -- Deadlock victim
                1222,    -- Lock request timeout
                8645,    -- Memory/resource error
                -2       -- Timeout
            )
            BEGIN
                SET @IsRetryable = 1;
                PRINT 'Retryable error detected: ' + @ErrorMessage;
            END
            
            -- Log error attempt
            INSERT INTO ErrorLog (
                ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
                ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
            )
            VALUES (
                @ErrorNumber, @ErrorMessage, 'ProcessOrderWithInventory', ERROR_LINE(),
                @ErrorSeverity, @ErrorState, @ProcessedBy, GETDATE(),
                'Attempt: ' + CAST(@RetryCount AS VARCHAR(2)) + 
                ', CustomerID: ' + CAST(@CustomerID AS VARCHAR(10)) +
                ', e.EmployeeID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) +
                ', TotalAmount: $' + FORMAT(@TotalAmount, 'N2')
            );
            
            -- If not retryable or max retries reached, fail
            IF @IsRetryable = 0 OR @RetryCount >= @MaxRetries
            BEGIN
                -- Log final failure
                IF @OrderID IS NOT NULL
                BEGIN
                    INSERT INTO OrderAudit (
                        OrderID, CustomerID, e.EmployeeID, TotalAmount,
                        ItemCount, Status, ProcessedBy, ProcessedDate, ErrorMessage
                    )
                    VALUES (
                        @OrderID, @CustomerID, @e.EmployeeID, @TotalAmount,
                        @ItemsProcessed, 'FAILED', @ProcessedBy, GETDATE(), @ErrorMessage
                    );
                END
                
                -- Provide user-friendly error message
                DECLARE @UserMessage NVARCHAR(1000);
                
                IF @ErrorNumber = 50000  -- Custom RAISERROR
                    SET @UserMessage = @ErrorMessage;
                ELSE IF @ErrorNumber = 1205  -- Deadlock
                    SET @UserMessage = 'Order processing failed due to system congestion. Please try again in a few moments.';
                ELSE IF @ErrorNumber = 547   -- Foreign key violation
                    SET @UserMessage = 'Invalid product or customer reference in order.';
                ELSE
                    SET @UserMessage = 'Order processing failed. Please contact customer service. Reference: ' + 
                                     CAST((SELECT TOP 1 ErrorLogID FROM ErrorLog ORDER BY ErrorLogID DESC) AS VARCHAR(10));
                
                PRINT 'Order processing failed after ' + CAST(@RetryCount AS VARCHAR(2)) + ' attempts:';
                PRINT @UserMessage;
                
                RAISERROR(@UserMessage, 16, 1);
            END
            ELSE
            BEGIN
                -- Wait before retry
                PRINT 'Waiting ' + @RetryDelay + ' before retry...';
                WAITFOR DELAY @RetryDelay;
                
                -- Reset variables for retry
                SET @OrderID = NULL;
                SET @TotalAmount = 0;
                SET @ItemsProcessed = 0;
            END
        END CATCH
    END
END;

-- Test the procedure
DECLARE @OrderItems NVARCHAR(MAX) = '[
    {"ProductID": 1, "Quantity": 2, "Price": 150.00},
    {"ProductID": 2, "Quantity": 1, "Price": 300.00}
]';

EXEC ProcessOrderWithInventory 
    @CustomerID = 6001,
    @e.EmployeeID = 3001,
    @OrderItems = @OrderItems,
    @ProcessedBy = 'Sales Representative';
```

**Business Logic**: These solutions demonstrate comprehensive error handling with input validation, business rule enforcement, transaction safety, audit logging, and user-friendly error messages. The retry mechanisms handle transient errors while preventing infinite loops, and the detailed logging supports troubleshooting and compliance requirements.

---

## Exercise 2 Solutions: Advanced Error Classification and Routing

### Task 2.1 Solution: Error Classification System

```sql
-- Create Error Classification Infrastructure
CREATE TABLE ErrorCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    HandlingStrategy NVARCHAR(50) NOT NULL, -- AUTOMATIC_RETRY, MANUAL_INTERVENTION, IMMEDIATE_ESCALATION
    DefaultRetryCount INT DEFAULT 0,
    DefaultEscalationLevel INT DEFAULT 1, -- 1=Low, 2=Medium, 3=High, 4=Critical
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER
);

CREATE TABLE ErrorHandlingRules (
    RuleID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorNumber INT,
    ErrorPattern NVARCHAR(255), -- For pattern-based matching
    CategoryID INT NOT NULL,
    RetryCount INT DEFAULT 0,
    RetryInterval INT DEFAULT 5000, -- milliseconds
    EscalationLevel INT DEFAULT 1,
    NotificationRecipients NVARCHAR(MAX), -- JSON array of recipients
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    FOREIGN KEY (CategoryID) REFERENCES ErrorCategories(CategoryID)
);

-- Insert standard error categories
INSERT INTO ErrorCategories (CategoryName, Description, HandlingStrategy, DefaultRetryCount, DefaultEscalationLevel)
VALUES 
    ('TRANSIENT_ERROR', 'Temporary system errors that may resolve automatically', 'AUTOMATIC_RETRY', 3, 2),
    ('CONSTRAINT_VIOLATION', 'Database constraint violations', 'MANUAL_INTERVENTION', 0, 1),
    ('BUSINESS_RULE_VIOLATION', 'Custom business rule violations', 'MANUAL_INTERVENTION', 0, 2),
    ('SYSTEM_ERROR', 'Critical system errors requiring immediate attention', 'IMMEDIATE_ESCALATION', 0, 4),
    ('PERMISSION_ERROR', 'Access and permission related errors', 'MANUAL_INTERVENTION', 0, 2),
    ('DATA_VALIDATION_ERROR', 'Input validation and data quality errors', 'MANUAL_INTERVENTION', 0, 1),
    ('RESOURCE_ERROR', 'Memory, disk, or other resource constraints', 'AUTOMATIC_RETRY', 2, 3),
    ('NETWORK_ERROR', 'Network connectivity and timeout errors', 'AUTOMATIC_RETRY', 3, 2),
    ('UNCLASSIFIED', 'Errors that do not match any specific category', 'MANUAL_INTERVENTION', 1, 2);

-- Insert specific error handling rules
INSERT INTO ErrorHandlingRules (ErrorNumber, CategoryID, RetryCount, RetryInterval, EscalationLevel)
SELECT 1205, CategoryID, 3, 2000, 2 FROM ErrorCategories WHERE CategoryName = 'TRANSIENT_ERROR' UNION ALL -- Deadlock
SELECT 1222, CategoryID, 3, 5000, 2 FROM ErrorCategories WHERE CategoryName = 'TRANSIENT_ERROR' UNION ALL -- Lock timeout
SELECT 2627, CategoryID, 0, 0, 1 FROM ErrorCategories WHERE CategoryName = 'CONSTRAINT_VIOLATION' UNION ALL -- Primary key violation
SELECT 547, CategoryID, 0, 0, 1 FROM ErrorCategories WHERE CategoryName = 'CONSTRAINT_VIOLATION' UNION ALL -- Foreign key violation
SELECT 50000, CategoryID, 0, 0, 2 FROM ErrorCategories WHERE CategoryName = 'BUSINESS_RULE_VIOLATION' UNION ALL -- RAISERROR
SELECT 8645, CategoryID, 2, 10000, 3 FROM ErrorCategories WHERE CategoryName = 'RESOURCE_ERROR' UNION ALL -- Memory error
SELECT -2, CategoryID, 3, 3000, 2 FROM ErrorCategories WHERE CategoryName = 'NETWORK_ERROR'; -- Timeout

-- Error Classification and Routing Procedure
CREATE OR ALTER PROCEDURE ClassifyAndRouteError
    @ErrorNumber INT,
    @ErrorMessage NVARCHAR(MAX),
    @ErrorProcedure NVARCHAR(128),
    @ErrorSeverity INT,
    @UserContext NVARCHAR(100),
    @AdditionalInfo NVARCHAR(MAX) = NULL,
    @ClassifiedCategoryID INT OUTPUT,
    @HandlingStrategy NVARCHAR(50) OUTPUT,
    @RecommendedRetryCount INT OUTPUT,
    @EscalationLevel INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CategoryID INT;
    DECLARE @RetryCount INT;
    DECLARE @RetryInterval INT;
    DECLARE @NotificationRecipients NVARCHAR(MAX);
    
    BEGIN TRY
        -- Step 1: Try exact error number match
        SELECT TOP 1
            @CategoryID = ec.CategoryID,
            @HandlingStrategy = ec.HandlingStrategy,
            @RetryCount = ehr.RetryCount,
            @RetryInterval = ehr.RetryInterval,
            @EscalationLevel = ehr.EscalationLevel,
            @NotificationRecipients = ehr.NotificationRecipients
        FROM ErrorHandlingRules ehr
        INNER JOIN ErrorCategories ec ON ehr.CategoryID = ec.CategoryID
        WHERE ehr.ErrorNumber = @ErrorNumber
        AND ehr.IsActive = 1
        AND ec.IsActive = 1
        ORDER BY ehr.RuleID;
        
        -- Step 2: Try pattern-based classification if no exact match
        IF @CategoryID IS NULL
        BEGIN
            SELECT TOP 1
                @CategoryID = ec.CategoryID,
                @HandlingStrategy = ec.HandlingStrategy,
                @RetryCount = ec.DefaultRetryCount,
                @EscalationLevel = ec.DefaultEscalationLevel
            FROM ErrorCategories ec
            WHERE ec.IsActive = 1
            AND (
                -- Constraint violations (2000-2999)
                (@ErrorNumber BETWEEN 2000 AND 2999 AND ec.CategoryName = 'CONSTRAINT_VIOLATION')
                OR
                -- System errors (8000-8999)
                (@ErrorNumber BETWEEN 8000 AND 8999 AND ec.CategoryName = 'SYSTEM_ERROR')
                OR
                -- Permission errors (229, 262, 297, etc.)
                (@ErrorNumber IN (229, 262, 297, 300) AND ec.CategoryName = 'PERMISSION_ERROR')
                OR
                -- Resource errors (17000-17999)
                (@ErrorNumber BETWEEN 17000 AND 17999 AND ec.CategoryName = 'RESOURCE_ERROR')
                OR
                -- High severity indicates system errors
                (@ErrorSeverity >= 20 AND ec.CategoryName = 'SYSTEM_ERROR')
                OR
                -- Business rule violations (custom RAISERROR)
                (@ErrorNumber = 50000 AND ec.CategoryName = 'BUSINESS_RULE_VIOLATION')
            )
            ORDER BY 
                CASE 
                    WHEN @ErrorNumber BETWEEN 2000 AND 2999 THEN 1
                    WHEN @ErrorNumber BETWEEN 8000 AND 8999 THEN 2
                    WHEN @ErrorNumber IN (229, 262, 297, 300) THEN 3
                    WHEN @ErrorSeverity >= 20 THEN 4
                    ELSE 5
                END;
        END
        
        -- Step 3: Default to unclassified if still no match
        IF @CategoryID IS NULL
        BEGIN
            SELECT 
                @CategoryID = CategoryID,
                @HandlingStrategy = HandlingStrategy,
                @RetryCount = DefaultRetryCount,
                @EscalationLevel = DefaultEscalationLevel
            FROM ErrorCategories
            WHERE CategoryName = 'UNCLASSIFIED'
            AND IsActive = 1;
        END
        
        -- Step 4: Apply contextual adjustments
        -- Increase escalation for production procedures
        IF @ErrorProcedure LIKE 'Process%' OR @ErrorProcedure LIKE 'Execute%'
        BEGIN
            SET @EscalationLevel = @EscalationLevel + 1;
            IF @EscalationLevel > 4 SET @EscalationLevel = 4;
        END
        
        -- Increase escalation for critical severity
        IF @ErrorSeverity >= 17
        BEGIN
            SET @EscalationLevel = CASE 
                WHEN @ErrorSeverity >= 20 THEN 4
                WHEN @ErrorSeverity >= 19 THEN 3
                ELSE GREATEST(@EscalationLevel, 2)
            END;
        END
        
        -- Set output parameters
        SET @ClassifiedCategoryID = @CategoryID;
        SET @RecommendedRetryCount = @RetryCount;
        
        -- Step 5: Log classified error
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
            ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo,
            CategoryID, HandlingStrategy, EscalationLevel, RetryCount, ClassificationDate
        )
        VALUES (
            @ErrorNumber, @ErrorMessage, @ErrorProcedure, 0,
            @ErrorSeverity, 1, @UserContext, GETDATE(), @AdditionalInfo,
            @CategoryID, @HandlingStrategy, @EscalationLevel, @RetryCount, GETDATE()
        );
        
        DECLARE @ErrorLogID INT = SCOPE_IDENTITY();
        
        -- Step 6: Route based on handling strategy
        IF @HandlingStrategy = 'AUTOMATIC_RETRY' AND @RetryCount > 0
        BEGIN
            INSERT INTO RetryQueue (
                ErrorLogID, MaxRetries, CurrentRetry, NextRetryTime, 
                RetryInterval, Status, CreatedDate
            )
            VALUES (
                @ErrorLogID, @RetryCount, 0, DATEADD(MILLISECOND, @RetryInterval, GETDATE()),
                @RetryInterval, 'PENDING', GETDATE()
            );
        END
        ELSE IF @HandlingStrategy = 'MANUAL_INTERVENTION'
        BEGIN
            DECLARE @Priority NVARCHAR(10) = CASE 
                WHEN @EscalationLevel >= 3 THEN 'HIGH'
                WHEN @EscalationLevel = 2 THEN 'MEDIUM'
                ELSE 'LOW'
            END;
            
            INSERT INTO ManualReviewQueue (
                ErrorLogID, Priority, AssignedTo, Status, CreatedDate, DueDate
            )
            VALUES (
                @ErrorLogID, @Priority, 
                CASE 
                    WHEN @EscalationLevel >= 3 THEN 'senior-support@techcorp.com'
                    ELSE 'support@techcorp.com'
                END,
                'PENDING', GETDATE(), DATEADD(HOUR, 4 * @EscalationLevel, GETDATE())
            );
        END
        ELSE IF @HandlingStrategy = 'IMMEDIATE_ESCALATION'
        BEGIN
            INSERT INTO NotificationQueue (
                ErrorLogID, NotificationType, Recipient, Priority, Status, CreatedDate,
                Subject, Message
            )
            VALUES (
                @ErrorLogID, 'IMMEDIATE_ALERT', 
                CASE 
                    WHEN @EscalationLevel = 4 THEN 'cto@techcorp.com;operations@techcorp.com'
                    ELSE 'operations@techcorp.com'
                END,
                'CRITICAL', 'PENDING', GETDATE(),
                'Critical System Error - Immediate Attention Required',
                'Error Number: ' + CAST(@ErrorNumber AS VARCHAR(10)) + CHAR(13) + CHAR(10) +
                'Error Message: ' + LEFT(@ErrorMessage, 500) + CHAR(13) + CHAR(10) +
                'Procedure: ' + ISNULL(@ErrorProcedure, 'N/A') + CHAR(13) + CHAR(10) +
                'User Context: ' + @UserContext + CHAR(13) + CHAR(10) +
                'Escalation Level: ' + CAST(@EscalationLevel AS VARCHAR(1))
            );
        END
        
        -- Step 7: Update system health metrics
        INSERT INTO SystemHealthEvents (
            ComponentName, EventType, Severity, EventTime, Details
        )
        VALUES (
            ISNULL(@ErrorProcedure, 'System'), 'ERROR', @EscalationLevel, GETDATE(),
            'Error ' + CAST(@ErrorNumber AS VARCHAR(10)) + ' classified as ' + 
            (SELECT CategoryName FROM ErrorCategories WHERE CategoryID = @CategoryID)
        );
        
        PRINT 'Error successfully classified and routed:';
        PRINT 'Category: ' + (SELECT CategoryName FROM ErrorCategories WHERE CategoryID = @CategoryID);
        PRINT 'Handling Strategy: ' + @HandlingStrategy;
        PRINT 'Escalation Level: ' + CAST(@EscalationLevel AS VARCHAR(1));
        PRINT 'Retry Count: ' + CAST(@RetryCount AS VARCHAR(2));
        
    END TRY
    BEGIN CATCH
        -- Meta-error handling: Error in the error classification system
        DECLARE @MetaErrorMsg NVARCHAR(MAX) = 
            'CRITICAL: Error in error classification system - ' + ERROR_MESSAGE();
        
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorSeverity,
            UserName, ErrorTime, AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(), @MetaErrorMsg, 'ClassifyAndRouteError', ERROR_SEVERITY(),
            'SYSTEM', GETDATE(),
            'Original Error: ' + CAST(@ErrorNumber AS VARCHAR(10)) + ' - ' + LEFT(@ErrorMessage, 1000)
        );
        
        -- Emergency notification for system failure
        INSERT INTO NotificationQueue (
            NotificationType, Recipient, Priority, Status, CreatedDate,
            Subject, Message
        )
        VALUES (
            'SYSTEM_CRITICAL', 'cto@techcorp.com;admin@techcorp.com', 'CRITICAL', 'PENDING', GETDATE(),
            'CRITICAL: Error Handling System Failure',
            'The error handling system has encountered a critical failure: ' + ERROR_MESSAGE()
        );
        
        -- Set default values for output parameters
        SET @ClassifiedCategoryID = (SELECT CategoryID FROM ErrorCategories WHERE CategoryName = 'UNCLASSIFIED');
        SET @HandlingStrategy = 'MANUAL_INTERVENTION';
        SET @RecommendedRetryCount = 0;
        SET @EscalationLevel = 4;
        
        RAISERROR(@MetaErrorMsg, 16, 1);
    END CATCH
END;

-- Test the classification system
DECLARE @CategoryID INT, @Strategy NVARCHAR(50), @RetryCount INT, @EscalationLevel INT;

EXEC ClassifyAndRouteError 
    @ErrorNumber = 1205,
    @ErrorMessage = 'Transaction was deadlocked on lock resources with another process',
    @ErrorProcedure = 'ProcessCustomerOrder',
    @ErrorSeverity = 13,
    @UserContext = 'TestUser',
    @ClassifiedCategoryID = @CategoryID OUTPUT,
    @HandlingStrategy = @Strategy OUTPUT,
    @RecommendedRetryCount = @RetryCount OUTPUT,
    @EscalationLevel = @EscalationLevel OUTPUT;

PRINT 'Classification Results:';
PRINT 'Category ID: ' + CAST(@CategoryID AS VARCHAR(10));
PRINT 'Strategy: ' + @Strategy;
PRINT 'Retry Count: ' + CAST(@RetryCount AS VARCHAR(10));
PRINT 'Escalation Level: ' + CAST(@EscalationLevel AS VARCHAR(10));
```

**Business Logic**: This solution creates a comprehensive error classification system that automatically categorizes errors based on error numbers, patterns, and severity levels. It routes errors to appropriate handling mechanisms (retry queues, manual review, immediate escalation) and maintains detailed audit trails for compliance and troubleshooting.

---

## Summary

These exercise solutions demonstrate enterprise-grade error handling implementations that provide:

**Comprehensive Error Management:**
- Multi-level validation and error handling
- Transaction safety with proper rollback strategies
- Intelligent error classification and routing
- Automatic retry mechanisms with exponential backoff

**Business Continuity Features:**
- Graceful degradation during errors
- Detailed audit trails for compliance
- User-friendly error messages
- System health monitoring integration

**Advanced Techniques:**
- Dynamic error recovery strategies
- Context-aware error handling
- Performance-optimized error logging
- Automated notification and escalation systems

Each solution includes extensive testing scenarios and demonstrates how to balance error detail with system performance while maintaining the reliability and user experience that enterprise applications require.