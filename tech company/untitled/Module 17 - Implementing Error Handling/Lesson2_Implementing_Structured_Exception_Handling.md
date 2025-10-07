# Lesson 2: Implementing Structured Exception Handling

## Overview

Structured Exception Handling (SEH) in T-SQL goes beyond basic TRY...CATCH blocks to implement comprehensive error management strategies that handle complex business scenarios, provide sophisticated error recovery mechanisms, and maintain system resilience. At TechCorp, implementing structured exception handling ensures that our database applications can gracefully handle complex error conditions, provide detailed diagnostics, and maintain business continuity even when unexpected situations arise.

## 🏢 TechCorp Business Context

**Structured Exception Handling in Enterprise Systems:**

- **Multi-Tier Error Management**: Handling errors at different levels (data, business logic, presentation)
- **Error Recovery Strategies**: Implementing automatic recovery mechanisms where possible
- **Cascading Error Prevention**: Preventing single errors from causing system-wide failures
- **Intelligent Error Routing**: Directing different error types to appropriate handling mechanisms
- **Business Process Continuity**: Ensuring critical business processes can continue despite errors

### 📋 TechCorp Database Schema Reference

**Enhanced Tables for Advanced Error Handling:**

```sql
ErrorLog: ErrorLogID, ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine, ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
ErrorCategories: CategoryID, CategoryName, Description, HandlingStrategy, IsActive
ErrorHandlingRules: RuleID, ErrorNumber, CategoryID, RetryCount, RetryInterval, EscalationLevel, IsActive
SystemHealth: HealthID, ComponentName, Status, LastCheck, ErrorCount, WarningThreshold
NotificationQueue: NotificationID, ErrorLogID, NotificationType, Recipient, Status, CreatedDate, SentDate
BusinessProcessLog: ProcessLogID, ProcessName, StepName, Status, StartTime, EndTime, ErrorDetails
```

---

## 2.1 Advanced TRY...CATCH Patterns

### Nested Exception Handling

```sql
-- TechCorp Example: Multi-level error handling for complex business processes
CREATE OR ALTER PROCEDURE ProcessMonthlyPayroll
    @PayrollMonth DATE,
    @ProcessedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcessID UNIQUEIDENTIFIER = NEWID();
    DECLARE @TotalEmployees INT = 0;
    DECLARE @ProcessedEmployees INT = 0;
    DECLARE @ErrorCount INT = 0;
    DECLARE @ProcessStartTime DATETIME2 = GETDATE();
    
    BEGIN TRY
        -- Level 1: Main process validation
        IF @PayrollMonth IS NULL OR @PayrollMonth > GETDATE()
        BEGIN
            RAISERROR('Invalid payroll month specified', 16, 1);
        END
        
        -- Check if payroll already processed for this month
        IF EXISTS (
            SELECT 1 FROM PayrollHistory 
            WHERE PayrollMonth = @PayrollMonth 
            AND Status = 'COMPLETED'
        )
        BEGIN
            RAISERROR('Payroll for %s has already been processed', 16, 1, FORMAT(@PayrollMonth, 'MMMM yyyy'));
        END
        
        -- Log process start
        INSERT INTO BusinessProcessLog (
            ProcessLogID, ProcessName, StepName, Status, StartTime, AdditionalInfo
        )
        VALUES (
            @ProcessID, 'Monthly Payroll', 'Process Initialization', 'STARTED', @ProcessStartTime,
            'PayrollMonth: ' + CAST(@PayrollMonth AS VARCHAR(20)) + ', ProcessedBy: ' + @ProcessedBy
        );
        
        BEGIN TRANSACTION PayrollProcessing;
        
        -- Get total employee count
        SELECT @TotalEmployees = COUNT(*)
        FROM Employees 
        WHERE IsActive = 1 
        AND HireDate <= @PayrollMonth;
        
        PRINT 'Starting payroll processing for ' + CAST(@TotalEmployees AS VARCHAR(10)) + ' employees';
        
        -- Level 2: Individual employee processing with nested error handling
        DECLARE @EmployeeID INT, @EmployeeName NVARCHAR(100), @BaseSalary MONEY;
        
        DECLARE employee_cursor CURSOR FOR
        SELECT EmployeeID, FirstName + ' ' + LastName, BaseSalary
        FROM Employees 
        WHERE IsActive = 1 AND HireDate <= @PayrollMonth
        ORDER BY EmployeeID;
        
        OPEN employee_cursor;
        FETCH NEXT FROM employee_cursor INTO @EmployeeID, @EmployeeName, @BaseSalary;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRY
                -- Level 3: Individual payroll calculation with specific error handling
                DECLARE @GrossPay MONEY, @Deductions MONEY, @NetPay MONEY;
                DECLARE @PayrollEntryID INT;
                
                BEGIN TRY
                    -- Calculate gross pay (includes overtime, bonuses, etc.)
                    EXEC CalculateGrossPay 
                        @EmployeeID = @EmployeeID,
                        @PayrollMonth = @PayrollMonth,
                        @GrossPay = @GrossPay OUTPUT;
                    
                    -- Calculate deductions (taxes, benefits, etc.)
                    EXEC CalculateDeductions 
                        @EmployeeID = @EmployeeID,
                        @GrossPay = @GrossPay,
                        @PayrollMonth = @PayrollMonth,
                        @Deductions = @Deductions OUTPUT;
                    
                    SET @NetPay = @GrossPay - @Deductions;
                    
                    -- Validate payroll amounts
                    IF @GrossPay < 0 OR @Deductions < 0 OR @NetPay < 0
                    BEGIN
                        RAISERROR('Invalid payroll calculation for employee %s (ID: %d)', 16, 1, @EmployeeName, @EmployeeID);
                    END
                    
                    -- Insert payroll record
                    INSERT INTO PayrollDetails (
                        EmployeeID, PayrollMonth, GrossPay, Deductions, NetPay,
                        ProcessedDate, ProcessedBy, ProcessLogID
                    )
                    VALUES (
                        @EmployeeID, @PayrollMonth, @GrossPay, @Deductions, @NetPay,
                        GETDATE(), @ProcessedBy, @ProcessID
                    );
                    
                    SET @PayrollEntryID = SCOPE_IDENTITY();
                    SET @ProcessedEmployees = @ProcessedEmployees + 1;
                    
                    -- Log successful processing
                    INSERT INTO BusinessProcessLog (
                        ProcessLogID, ProcessName, StepName, Status, StartTime, EndTime, AdditionalInfo
                    )
                    VALUES (
                        @ProcessID, 'Monthly Payroll', 'Employee Processing', 'COMPLETED', GETDATE(), GETDATE(),
                        'EmployeeID: ' + CAST(@EmployeeID AS VARCHAR(10)) + 
                        ', GrossPay: $' + FORMAT(@GrossPay, 'N2') + 
                        ', NetPay: $' + FORMAT(@NetPay, 'N2')
                    );
                    
                END TRY
                BEGIN CATCH
                    -- Level 3 error handling: Individual employee calculation errors
                    SET @ErrorCount = @ErrorCount + 1;
                    
                    DECLARE @EmployeeErrorMsg NVARCHAR(MAX) = 
                        'Error processing payroll for ' + @EmployeeName + 
                        ' (ID: ' + CAST(@EmployeeID AS VARCHAR(10)) + '): ' + ERROR_MESSAGE();
                    
                    -- Log employee-specific error
                    INSERT INTO ErrorLog (
                        ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
                        ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
                    )
                    VALUES (
                        ERROR_NUMBER(), @EmployeeErrorMsg, ERROR_PROCEDURE(), ERROR_LINE(),
                        ERROR_SEVERITY(), ERROR_STATE(), @ProcessedBy, GETDATE(),
                        'ProcessID: ' + CAST(@ProcessID AS VARCHAR(50)) + ', PayrollMonth: ' + CAST(@PayrollMonth AS VARCHAR(20))
                    );
                    
                    -- Insert error record for manual review
                    INSERT INTO PayrollErrors (
                        EmployeeID, PayrollMonth, ErrorMessage, ProcessLogID, CreatedDate
                    )
                    VALUES (
                        @EmployeeID, @PayrollMonth, @EmployeeErrorMsg, @ProcessID, GETDATE()
                    );
                    
                    PRINT 'Error processing employee ' + @EmployeeName + ': ' + ERROR_MESSAGE();
                    
                    -- Continue processing other employees (don't fail entire payroll)
                END CATCH
                
            END TRY
            BEGIN CATCH
                -- Level 2 error handling: Unexpected errors during employee processing
                SET @ErrorCount = @ErrorCount + 1;
                
                INSERT INTO ErrorLog (
                    ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
                    ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
                )
                VALUES (
                    ERROR_NUMBER(), 'Unexpected error in employee processing: ' + ERROR_MESSAGE(), 
                    ERROR_PROCEDURE(), ERROR_LINE(), ERROR_SEVERITY(), ERROR_STATE(), 
                    @ProcessedBy, GETDATE(),
                    'EmployeeID: ' + CAST(@EmployeeID AS VARCHAR(10)) + ', ProcessID: ' + CAST(@ProcessID AS VARCHAR(50))
                );
                
                -- Log critical employee processing failure
                INSERT INTO BusinessProcessLog (
                    ProcessLogID, ProcessName, StepName, Status, StartTime, EndTime, ErrorDetails
                )
                VALUES (
                    @ProcessID, 'Monthly Payroll', 'Employee Processing', 'FAILED', GETDATE(), GETDATE(),
                    'Critical error processing EmployeeID: ' + CAST(@EmployeeID AS VARCHAR(10)) + ' - ' + ERROR_MESSAGE()
                );
            END CATCH
            
            FETCH NEXT FROM employee_cursor INTO @EmployeeID, @EmployeeName, @BaseSalary;
        END
        
        CLOSE employee_cursor;
        DEALLOCATE employee_cursor;
        
        -- Final validation and completion
        DECLARE @SuccessRate DECIMAL(5,2) = 
            CASE WHEN @TotalEmployees > 0 
                 THEN (@ProcessedEmployees * 100.0) / @TotalEmployees 
                 ELSE 0 END;
        
        -- Business rule: Payroll must process at least 95% of employees successfully
        IF @SuccessRate < 95.0
        BEGIN
            RAISERROR('Payroll processing failed: Success rate %.2f%% is below required 95%%. Processed: %d, Total: %d, Errors: %d', 
                     16, 1, @SuccessRate, @ProcessedEmployees, @TotalEmployees, @ErrorCount);
        END
        
        -- Update payroll summary
        INSERT INTO PayrollHistory (
            PayrollMonth, TotalEmployees, ProcessedEmployees, ErrorCount,
            SuccessRate, Status, ProcessedBy, ProcessedDate, ProcessLogID
        )
        VALUES (
            @PayrollMonth, @TotalEmployees, @ProcessedEmployees, @ErrorCount,
            @SuccessRate, 'COMPLETED', @ProcessedBy, GETDATE(), @ProcessID
        );
        
        COMMIT TRANSACTION PayrollProcessing;
        
        -- Log successful completion
        INSERT INTO BusinessProcessLog (
            ProcessLogID, ProcessName, StepName, Status, StartTime, EndTime, AdditionalInfo
        )
        VALUES (
            @ProcessID, 'Monthly Payroll', 'Process Completion', 'COMPLETED', @ProcessStartTime, GETDATE(),
            'Success Rate: ' + FORMAT(@SuccessRate, 'N2') + '%, Processed: ' + CAST(@ProcessedEmployees AS VARCHAR(10)) + 
            ', Errors: ' + CAST(@ErrorCount AS VARCHAR(10))
        );
        
        PRINT 'Payroll processing completed successfully';
        PRINT 'Total Employees: ' + CAST(@TotalEmployees AS VARCHAR(10));
        PRINT 'Processed Successfully: ' + CAST(@ProcessedEmployees AS VARCHAR(10));
        PRINT 'Errors: ' + CAST(@ErrorCount AS VARCHAR(10));
        PRINT 'Success Rate: ' + FORMAT(@SuccessRate, 'N2') + '%';
        
    END TRY
    BEGIN CATCH
        -- Level 1 error handling: Critical system errors
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION PayrollProcessing;
        
        -- Close cursor if still open
        IF CURSOR_STATUS('local', 'employee_cursor') >= 0
        BEGIN
            CLOSE employee_cursor;
            DEALLOCATE employee_cursor;
        END
        
        -- Log critical failure
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
            ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(), 'Critical payroll processing failure: ' + ERROR_MESSAGE(),
            ERROR_PROCEDURE(), ERROR_LINE(), ERROR_SEVERITY(), ERROR_STATE(),
            @ProcessedBy, GETDATE(),
            'ProcessID: ' + CAST(@ProcessID AS VARCHAR(50)) + ', PayrollMonth: ' + CAST(@PayrollMonth AS VARCHAR(20))
        );
        
        -- Update payroll history with failure status
        INSERT INTO PayrollHistory (
            PayrollMonth, TotalEmployees, ProcessedEmployees, ErrorCount,
            SuccessRate, Status, ProcessedBy, ProcessedDate, ProcessLogID, ErrorMessage
        )
        VALUES (
            @PayrollMonth, @TotalEmployees, @ProcessedEmployees, @ErrorCount,
            0.0, 'FAILED', @ProcessedBy, GETDATE(), @ProcessID, ERROR_MESSAGE()
        );
        
        -- Log process failure
        INSERT INTO BusinessProcessLog (
            ProcessLogID, ProcessName, StepName, Status, StartTime, EndTime, ErrorDetails
        )
        VALUES (
            @ProcessID, 'Monthly Payroll', 'Process Failure', 'FAILED', @ProcessStartTime, GETDATE(),
            'Critical failure: ' + ERROR_MESSAGE()
        );
        
        -- Notify administrators of critical failure
        INSERT INTO NotificationQueue (
            ErrorLogID, NotificationType, Recipient, Status, CreatedDate, Priority, Subject, Message
        )
        VALUES (
            (SELECT TOP 1 ErrorLogID FROM ErrorLog ORDER BY ErrorLogID DESC),
            'CRITICAL_ERROR', 'payroll-admin@techcorp.com', 'PENDING', GETDATE(), 'HIGH',
            'Critical Payroll Processing Failure',
            'Payroll processing for ' + FORMAT(@PayrollMonth, 'MMMM yyyy') + ' has failed critically. Immediate attention required.'
        );
        
        -- Re-raise error for calling application
        THROW;
    END CATCH
END;
```

---

## 2.2 Error Classification and Routing

### Intelligent Error Categorization System

```sql
-- TechCorp Error Classification Framework
CREATE OR ALTER PROCEDURE ClassifyAndRouteError
    @ErrorNumber INT,
    @ErrorMessage NVARCHAR(MAX),
    @ErrorProcedure NVARCHAR(128),
    @ErrorSeverity INT,
    @UserContext NVARCHAR(100),
    @AdditionalInfo NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CategoryID INT;
    DECLARE @HandlingStrategy NVARCHAR(50);
    DECLARE @EscalationLevel INT;
    DECLARE @RetryCount INT;
    DECLARE @NotificationRequired BIT = 0;
    
    BEGIN TRY
        -- Classify error based on number and context
        SELECT TOP 1
            @CategoryID = ec.CategoryID,
            @HandlingStrategy = ec.HandlingStrategy,
            @EscalationLevel = ehr.EscalationLevel,
            @RetryCount = ehr.RetryCount
        FROM ErrorCategories ec
        LEFT JOIN ErrorHandlingRules ehr ON ec.CategoryID = ehr.CategoryID
        WHERE (
            -- Exact error number match
            ehr.ErrorNumber = @ErrorNumber
            OR 
            -- Pattern-based classification
            (@ErrorNumber BETWEEN 2700 AND 2799 AND ec.CategoryName = 'CONSTRAINT_VIOLATION')
            OR
            (@ErrorNumber BETWEEN 8000 AND 8999 AND ec.CategoryName = 'SYSTEM_ERROR')
            OR
            (@ErrorNumber = 50000 AND ec.CategoryName = 'BUSINESS_RULE_VIOLATION')
            OR
            (@ErrorSeverity >= 20 AND ec.CategoryName = 'CRITICAL_ERROR')
        )
        AND ec.IsActive = 1
        AND ehr.IsActive = 1
        ORDER BY 
            CASE WHEN ehr.ErrorNumber = @ErrorNumber THEN 1 ELSE 2 END,
            ec.CategoryID;
        
        -- Default classification if no specific rule found
        IF @CategoryID IS NULL
        BEGIN
            SELECT 
                @CategoryID = CategoryID,
                @HandlingStrategy = HandlingStrategy
            FROM ErrorCategories
            WHERE CategoryName = 'UNCLASSIFIED'
            AND IsActive = 1;
            
            SET @EscalationLevel = 2; -- Medium escalation for unclassified errors
            SET @RetryCount = 0;
        END
        
        -- Determine notification requirements
        SET @NotificationRequired = CASE 
            WHEN @EscalationLevel >= 3 THEN 1  -- High/Critical escalation
            WHEN @ErrorSeverity >= 17 THEN 1   -- System errors
            WHEN @ErrorProcedure LIKE 'Process%' THEN 1  -- Business process errors
            ELSE 0
        END;
        
        -- Log classified error
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine,
            ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo,
            CategoryID, HandlingStrategy, EscalationLevel, RetryCount
        )
        VALUES (
            @ErrorNumber, @ErrorMessage, @ErrorProcedure, 0,
            @ErrorSeverity, 1, @UserContext, GETDATE(), @AdditionalInfo,
            @CategoryID, @HandlingStrategy, @EscalationLevel, @RetryCount
        );
        
        DECLARE @ErrorLogID INT = SCOPE_IDENTITY();
        
        -- Route based on handling strategy
        IF @HandlingStrategy = 'AUTOMATIC_RETRY'
        BEGIN
            -- Queue for automatic retry
            INSERT INTO RetryQueue (
                ErrorLogID, RetryCount, MaxRetries, NextRetryTime, Status
            )
            VALUES (
                @ErrorLogID, 0, @RetryCount, DATEADD(MINUTE, 5, GETDATE()), 'PENDING'
            );
        END
        ELSE IF @HandlingStrategy = 'MANUAL_INTERVENTION'
        BEGIN
            -- Queue for manual review
            INSERT INTO ManualReviewQueue (
                ErrorLogID, AssignedTo, Priority, Status, CreatedDate
            )
            VALUES (
                @ErrorLogID, 'tech-support@techcorp.com',
                CASE WHEN @EscalationLevel >= 3 THEN 'HIGH' ELSE 'MEDIUM' END,
                'PENDING', GETDATE()
            );
        END
        ELSE IF @HandlingStrategy = 'IMMEDIATE_ESCALATION'
        BEGIN
            -- Immediate notification to administrators
            INSERT INTO NotificationQueue (
                ErrorLogID, NotificationType, Recipient, Status, CreatedDate, Priority
            )
            VALUES (
                @ErrorLogID, 'IMMEDIATE_ALERT', 'admin@techcorp.com', 'PENDING', GETDATE(), 'CRITICAL'
            );
        END
        
        -- Send notifications if required
        IF @NotificationRequired = 1
        BEGIN
            DECLARE @Recipients NVARCHAR(MAX) = CASE 
                WHEN @EscalationLevel = 4 THEN 'cto@techcorp.com;admin@techcorp.com'
                WHEN @EscalationLevel = 3 THEN 'admin@techcorp.com;tech-lead@techcorp.com'
                ELSE 'tech-support@techcorp.com'
            END;
            
            INSERT INTO NotificationQueue (
                ErrorLogID, NotificationType, Recipient, Status, CreatedDate, Priority,
                Subject, Message
            )
            VALUES (
                @ErrorLogID, 'ERROR_NOTIFICATION', @Recipients, 'PENDING', GETDATE(),
                CASE WHEN @EscalationLevel >= 3 THEN 'HIGH' ELSE 'MEDIUM' END,
                'Error Classification Alert - Level ' + CAST(@EscalationLevel AS VARCHAR(1)),
                'Error Details: ' + @ErrorMessage + CHAR(13) + CHAR(10) +
                'Procedure: ' + ISNULL(@ErrorProcedure, 'N/A') + CHAR(13) + CHAR(10) +
                'User Context: ' + @UserContext + CHAR(13) + CHAR(10) +
                'Handling Strategy: ' + @HandlingStrategy
            );
        END
        
        -- Update system health metrics
        EXEC UpdateSystemHealthMetrics 
            @ComponentName = @ErrorProcedure,
            @ErrorOccurred = 1,
            @ErrorSeverity = @ErrorSeverity;
        
        PRINT 'Error classified and routed successfully';
        PRINT 'Category: ' + CAST(@CategoryID AS VARCHAR(10));
        PRINT 'Handling Strategy: ' + @HandlingStrategy;
        PRINT 'Escalation Level: ' + CAST(@EscalationLevel AS VARCHAR(1));
        
    END TRY
    BEGIN CATCH
        -- Meta-error: Error in error handling system
        INSERT INTO ErrorLog (
            ErrorNumber, ErrorMessage, ErrorProcedure, ErrorSeverity,
            UserName, ErrorTime, AdditionalInfo
        )
        VALUES (
            ERROR_NUMBER(), 
            'Critical: Error in error classification system - ' + ERROR_MESSAGE(),
            'ClassifyAndRouteError',
            ERROR_SEVERITY(),
            'SYSTEM',
            GETDATE(),
            'Original Error: ' + CAST(@ErrorNumber AS VARCHAR(10)) + ' - ' + @ErrorMessage
        );
        
        -- Emergency notification
        INSERT INTO NotificationQueue (
            NotificationType, Recipient, Status, CreatedDate, Priority,
            Subject, Message
        )
        VALUES (
            'SYSTEM_CRITICAL', 'cto@techcorp.com', 'PENDING', GETDATE(), 'CRITICAL',
            'Critical: Error Handling System Failure',
            'The error handling system itself has encountered a critical error. Immediate attention required.'
        );
    END CATCH
END;
```

---

## 2.3 Error Recovery and Retry Mechanisms

### Automatic Recovery Strategies

```sql
-- TechCorp Automatic Error Recovery System
CREATE OR ALTER PROCEDURE ExecuteWithRetry
    @ProcedureName NVARCHAR(128),
    @Parameters NVARCHAR(MAX) = NULL,
    @MaxRetries INT = 3,
    @RetryInterval INT = 5000, -- milliseconds
    @ExponentialBackoff BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @AttemptCount INT = 0;
    DECLARE @Success BIT = 0;
    DECLARE @LastError NVARCHAR(MAX);
    DECLARE @CurrentInterval INT = @RetryInterval;
    DECLARE @ExecutionLogID INT;
    
    -- Log execution start
    INSERT INTO ExecutionLog (
        ProcedureName, Parameters, MaxRetries, StartTime, Status
    )
    VALUES (
        @ProcedureName, @Parameters, @MaxRetries, GETDATE(), 'STARTED'
    );
    
    SET @ExecutionLogID = SCOPE_IDENTITY();
    
    WHILE @AttemptCount < @MaxRetries AND @Success = 0
    BEGIN
        SET @AttemptCount = @AttemptCount + 1;
        
        BEGIN TRY
            PRINT 'Attempt ' + CAST(@AttemptCount AS VARCHAR(2)) + ' of ' + CAST(@MaxRetries AS VARCHAR(2)) + 
                  ' for procedure: ' + @ProcedureName;
            
            -- Dynamic execution based on procedure name and parameters
            IF @ProcedureName = 'ProcessCustomerOrder'
            BEGIN
                -- Parse parameters and execute
                DECLARE @CustomerID INT, @EmployeeID INT, @OrderItems NVARCHAR(MAX);
                
                -- Simplified parameter parsing (in production, use proper JSON parsing)
                SELECT 
                    @CustomerID = JSON_VALUE(@Parameters, '$.CustomerID'),
                    @EmployeeID = JSON_VALUE(@Parameters, '$.EmployeeID'),
                    @OrderItems = JSON_VALUE(@Parameters, '$.OrderItems');
                
                EXEC ProcessCustomerOrder 
                    @CustomerID = @CustomerID,
                    @EmployeeID = @EmployeeID,
                    @OrderItems = @OrderItems;
            END
            ELSE IF @ProcedureName = 'UpdateEmployeeSalary'
            BEGIN
                DECLARE @EmpID INT, @NewSalary MONEY, @UpdatedBy NVARCHAR(100);
                
                SELECT 
                    @EmpID = JSON_VALUE(@Parameters, '$.EmployeeID'),
                    @NewSalary = JSON_VALUE(@Parameters, '$.NewSalary'),
                    @UpdatedBy = JSON_VALUE(@Parameters, '$.UpdatedBy');
                
                EXEC UpdateEmployeeSalary 
                    @EmployeeID = @EmpID,
                    @NewSalary = @NewSalary,
                    @UpdatedBy = @UpdatedBy;
            END
            ELSE
            BEGIN
                -- Generic execution using dynamic SQL (use with caution)
                DECLARE @SQL NVARCHAR(MAX) = 'EXEC ' + @ProcedureName;
                IF @Parameters IS NOT NULL
                    SET @SQL = @SQL + ' ' + @Parameters;
                
                EXEC sp_executesql @SQL;
            END
            
            -- If we reach here, execution was successful
            SET @Success = 1;
            
            UPDATE ExecutionLog 
            SET Status = 'COMPLETED',
                EndTime = GETDATE(),
                SuccessfulAttempt = @AttemptCount
            WHERE ExecutionLogID = @ExecutionLogID;
            
            PRINT 'Procedure executed successfully on attempt ' + CAST(@AttemptCount AS VARCHAR(2));
            
        END TRY
        BEGIN CATCH
            SET @LastError = ERROR_MESSAGE();
            DECLARE @ErrorNumber INT = ERROR_NUMBER();
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
            
            -- Log attempt failure
            INSERT INTO ExecutionAttemptLog (
                ExecutionLogID, AttemptNumber, ErrorNumber, ErrorMessage,
                ErrorSeverity, AttemptTime
            )
            VALUES (
                @ExecutionLogID, @AttemptCount, @ErrorNumber, @LastError,
                @ErrorSeverity, GETDATE()
            );
            
            -- Determine if error is retryable
            DECLARE @IsRetryable BIT = 0;
            
            -- Check if error is in retryable category
            IF EXISTS (
                SELECT 1 FROM ErrorCategories ec
                INNER JOIN ErrorHandlingRules ehr ON ec.CategoryID = ehr.CategoryID
                WHERE ehr.ErrorNumber = @ErrorNumber
                AND ec.HandlingStrategy = 'AUTOMATIC_RETRY'
                AND ec.IsActive = 1
            )
            BEGIN
                SET @IsRetryable = 1;
            END
            ELSE IF @ErrorNumber IN (
                1205,    -- Deadlock
                1222,    -- Lock timeout
                8645,    -- Memory/resource error
                8651,    -- Low memory condition
                -2,      -- Timeout
                2       -- File not found (temporary condition)
            )
            BEGIN
                SET @IsRetryable = 1;
            END
            ELSE IF @ErrorSeverity BETWEEN 13 AND 16  -- User correctable errors
            BEGIN
                SET @IsRetryable = 1;
            END
            
            IF @IsRetryable = 0
            BEGIN
                PRINT 'Error is not retryable. Aborting retry attempts.';
                PRINT 'Error: ' + @LastError;
                BREAK;
            END
            
            IF @AttemptCount < @MaxRetries
            BEGIN
                PRINT 'Attempt ' + CAST(@AttemptCount AS VARCHAR(2)) + ' failed: ' + @LastError;
                PRINT 'Waiting ' + CAST(@CurrentInterval AS VARCHAR(10)) + ' milliseconds before retry...';
                
                -- Wait before retry
                WAITFOR DELAY @CurrentInterval;
                
                -- Apply exponential backoff if enabled
                IF @ExponentialBackoff = 1
                BEGIN
                    SET @CurrentInterval = @CurrentInterval * 2;
                    -- Cap maximum interval at 60 seconds
                    IF @CurrentInterval > 60000
                        SET @CurrentInterval = 60000;
                END
            END
            ELSE
            BEGIN
                PRINT 'All retry attempts exhausted. Final error: ' + @LastError;
            END
        END CATCH
    END
    
    -- Final status update
    IF @Success = 0
    BEGIN
        UPDATE ExecutionLog 
        SET Status = 'FAILED',
            EndTime = GETDATE(),
            FinalError = @LastError,
            TotalAttempts = @AttemptCount
        WHERE ExecutionLogID = @ExecutionLogID;
        
        -- Classify and route the persistent error
        EXEC ClassifyAndRouteError 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorMessage = @LastError,
            @ErrorProcedure = @ProcedureName,
            @ErrorSeverity = ERROR_SEVERITY(),
            @UserContext = SYSTEM_USER,
            @AdditionalInfo = 'Failed after ' + CAST(@AttemptCount AS VARCHAR(2)) + ' retry attempts';
        
        -- Re-raise the error
        RAISERROR('Procedure execution failed after %d attempts. Last error: %s', 16, 1, @AttemptCount, @LastError);
    END
    
    RETURN @Success;
END;

-- Usage example
DECLARE @Parameters NVARCHAR(MAX) = JSON_OBJECT(
    'CustomerID', 6001,
    'EmployeeID', 3001,
    'OrderItems', '[{"ItemID":1,"Quantity":2,"Price":250}]'
);

EXEC ExecuteWithRetry 
    @ProcedureName = 'ProcessCustomerOrder',
    @Parameters = @Parameters,
    @MaxRetries = 3,
    @RetryInterval = 2000,
    @ExponentialBackoff = 1;
```

---

## 2.4 Error Aggregation and Reporting

### Comprehensive Error Analytics

```sql
-- TechCorp Error Analytics and Reporting System
CREATE OR ALTER PROCEDURE GenerateErrorReport
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @IncludeDetails BIT = 1,
    @GroupBy NVARCHAR(20) = 'PROCEDURE' -- OPTIONS: PROCEDURE, CATEGORY, SEVERITY, USER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range: Last 7 days
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));
    IF @EndDate IS NULL SET @EndDate = CAST(GETDATE() AS DATE);
    
    PRINT 'TechCorp Error Analysis Report';
    PRINT 'Period: ' + CAST(@StartDate AS VARCHAR(20)) + ' to ' + CAST(@EndDate AS VARCHAR(20));
    PRINT 'Generated: ' + CAST(GETDATE() AS VARCHAR(30));
    PRINT REPLICATE('=', 80);
    
    -- Summary Statistics
    DECLARE @TotalErrors INT, @CriticalErrors INT, @ResolvedErrors INT, @PendingErrors INT;
    
    SELECT 
        @TotalErrors = COUNT(*),
        @CriticalErrors = COUNT(CASE WHEN ErrorSeverity >= 17 THEN 1 END),
        @ResolvedErrors = COUNT(CASE WHEN ResolutionStatus = 'RESOLVED' THEN 1 END),
        @PendingErrors = COUNT(CASE WHEN ResolutionStatus IS NULL OR ResolutionStatus = 'PENDING' THEN 1 END)
    FROM ErrorLog 
    WHERE CAST(ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate;
    
    PRINT 'SUMMARY STATISTICS:';
    PRINT 'Total Errors: ' + CAST(@TotalErrors AS VARCHAR(10));
    PRINT 'Critical Errors (Severity >= 17): ' + CAST(@CriticalErrors AS VARCHAR(10));
    PRINT 'Resolved Errors: ' + CAST(@ResolvedErrors AS VARCHAR(10));
    PRINT 'Pending Errors: ' + CAST(@PendingErrors AS VARCHAR(10));
    PRINT 'Resolution Rate: ' + FORMAT(CASE WHEN @TotalErrors > 0 THEN (@ResolvedErrors * 100.0) / @TotalErrors ELSE 0 END, 'N1') + '%';
    PRINT '';
    
    -- Error Distribution by Group
    IF @GroupBy = 'PROCEDURE'
    BEGIN
        PRINT 'ERROR DISTRIBUTION BY PROCEDURE:';
        SELECT 
            ISNULL(el.ErrorProcedure, 'Ad-hoc Query') AS ProcedureName,
            COUNT(*) AS ErrorCount,
            COUNT(CASE WHEN el.ErrorSeverity >= 17 THEN 1 END) AS CriticalCount,
            AVG(el.ErrorSeverity) AS AvgSeverity,
            MIN(el.ErrorTime) AS FirstOccurrence,
            MAX(el.ErrorTime) AS LastOccurrence,
            COUNT(CASE WHEN el.ResolutionStatus = 'RESOLVED' THEN 1 END) AS ResolvedCount,
            FORMAT(COUNT(CASE WHEN el.ResolutionStatus = 'RESOLVED' THEN 1 END) * 100.0 / COUNT(*), 'N1') + '%' AS ResolutionRate
        FROM ErrorLog el
        WHERE CAST(el.ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        GROUP BY el.ErrorProcedure
        ORDER BY ErrorCount DESC, CriticalCount DESC;
    END
    ELSE IF @GroupBy = 'CATEGORY'
    BEGIN
        PRINT 'ERROR DISTRIBUTION BY CATEGORY:';
        SELECT 
            ISNULL(ec.CategoryName, 'UNCLASSIFIED') AS CategoryName,
            ec.Description,
            COUNT(*) AS ErrorCount,
            COUNT(CASE WHEN el.ErrorSeverity >= 17 THEN 1 END) AS CriticalCount,
            AVG(el.ErrorSeverity) AS AvgSeverity,
            ec.HandlingStrategy,
            COUNT(CASE WHEN el.ResolutionStatus = 'RESOLVED' THEN 1 END) AS ResolvedCount
        FROM ErrorLog el
        LEFT JOIN ErrorCategories ec ON el.CategoryID = ec.CategoryID
        WHERE CAST(el.ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        GROUP BY ec.CategoryName, ec.Description, ec.HandlingStrategy
        ORDER BY ErrorCount DESC;
    END
    ELSE IF @GroupBy = 'SEVERITY'
    BEGIN
        PRINT 'ERROR DISTRIBUTION BY SEVERITY:';
        SELECT 
            el.ErrorSeverity,
            CASE 
                WHEN el.ErrorSeverity BETWEEN 0 AND 10 THEN 'Informational'
                WHEN el.ErrorSeverity BETWEEN 11 AND 16 THEN 'User Correctable'
                WHEN el.ErrorSeverity BETWEEN 17 AND 19 THEN 'Software Error'
                WHEN el.ErrorSeverity BETWEEN 20 AND 25 THEN 'System Problem'
                ELSE 'Unknown'
            END AS SeverityCategory,
            COUNT(*) AS ErrorCount,
            FORMAT(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 'N1') + '%' AS Percentage,
            COUNT(CASE WHEN el.ResolutionStatus = 'RESOLVED' THEN 1 END) AS ResolvedCount
        FROM ErrorLog el
        WHERE CAST(el.ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        GROUP BY el.ErrorSeverity
        ORDER BY el.ErrorSeverity;
    END
    
    PRINT '';
    
    -- Top Error Messages
    PRINT 'TOP 10 MOST FREQUENT ERROR MESSAGES:';
    SELECT TOP 10
        el.ErrorNumber,
        LEFT(el.ErrorMessage, 100) + CASE WHEN LEN(el.ErrorMessage) > 100 THEN '...' ELSE '' END AS ErrorMessage,
        COUNT(*) AS Occurrences,
        COUNT(DISTINCT el.ErrorProcedure) AS AffectedProcedures,
        MIN(el.ErrorTime) AS FirstSeen,
        MAX(el.ErrorTime) AS LastSeen
    FROM ErrorLog el
    WHERE CAST(el.ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
    GROUP BY el.ErrorNumber, el.ErrorMessage
    ORDER BY Occurrences DESC;
    
    PRINT '';
    
    -- System Health Impact
    PRINT 'SYSTEM HEALTH IMPACT:';
    SELECT 
        sh.ComponentName,
        sh.Status,
        sh.ErrorCount,
        sh.WarningThreshold,
        sh.LastCheck,
        CASE 
            WHEN sh.ErrorCount > sh.WarningThreshold THEN 'NEEDS ATTENTION'
            WHEN sh.ErrorCount > (sh.WarningThreshold * 0.8) THEN 'MONITOR CLOSELY'
            ELSE 'HEALTHY'
        END AS HealthStatus
    FROM SystemHealth sh
    WHERE sh.LastCheck >= @StartDate
    ORDER BY sh.ErrorCount DESC;
    
    -- Detailed Error List (if requested)
    IF @IncludeDetails = 1
    BEGIN
        PRINT '';
        PRINT 'DETAILED ERROR LOG:';
        SELECT 
            el.ErrorLogID,
            el.ErrorTime,
            el.ErrorNumber,
            LEFT(el.ErrorMessage, 150) AS ErrorMessage,
            el.ErrorProcedure,
            el.ErrorSeverity,
            el.UserName,
            ISNULL(ec.CategoryName, 'UNCLASSIFIED') AS Category,
            el.ResolutionStatus,
            el.ResolutionTime
        FROM ErrorLog el
        LEFT JOIN ErrorCategories ec ON el.CategoryID = ec.CategoryID
        WHERE CAST(el.ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        ORDER BY el.ErrorTime DESC;
    END
    
    -- Recommendations
    PRINT '';
    PRINT 'RECOMMENDATIONS:';
    
    -- High error rate procedures
    IF EXISTS (
        SELECT 1 FROM ErrorLog 
        WHERE CAST(ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        GROUP BY ErrorProcedure 
        HAVING COUNT(*) > 10
    )
    BEGIN
        PRINT '• Review procedures with high error rates (>10 errors in period)';
    END
    
    -- Unresolved critical errors
    IF EXISTS (
        SELECT 1 FROM ErrorLog 
        WHERE CAST(ErrorTime AS DATE) BETWEEN @StartDate AND @EndDate
        AND ErrorSeverity >= 17 
        AND (ResolutionStatus IS NULL OR ResolutionStatus != 'RESOLVED')
    )
    BEGIN
        PRINT '• Address unresolved critical errors (severity >= 17)';
    END
    
    -- System health warnings
    IF EXISTS (
        SELECT 1 FROM SystemHealth 
        WHERE ErrorCount > WarningThreshold
    )
    BEGIN
        PRINT '• Investigate system components exceeding error thresholds';
    END
    
    PRINT REPLICATE('=', 80);
    PRINT 'End of Error Analysis Report';
END;

-- Generate comprehensive error report
EXEC GenerateErrorReport 
    @StartDate = '2024-01-01',
    @EndDate = '2024-01-31',
    @IncludeDetails = 1,
    @GroupBy = 'PROCEDURE';
```

---

## Summary

Structured Exception Handling at TechCorp provides comprehensive error management capabilities:

**Advanced Error Handling Patterns:**

- **Multi-Level Exception Handling**: Nested TRY...CATCH blocks for complex business processes
- **Error Classification**: Intelligent categorization and routing based on error types
- **Automatic Recovery**: Retry mechanisms with exponential backoff and recovery strategies
- **Error Aggregation**: Comprehensive analytics and reporting for error patterns

**Key Components:**

- **Nested Error Handling**: Managing errors at multiple levels (system, business, data)
- **Intelligent Error Routing**: Directing errors to appropriate handling mechanisms
- **Retry Strategies**: Automatic recovery with configurable retry policies
- **Error Analytics**: Comprehensive reporting and trend analysis

**Business Benefits:**

- **System Resilience**: Applications that gracefully handle unexpected conditions
- **Operational Efficiency**: Automated error recovery reduces manual intervention
- **Improved Diagnostics**: Detailed error classification aids in rapid troubleshooting
- **Proactive Monitoring**: Early detection of system health issues through error patterns

**TechCorp Implementation Standards:**

- **Consistent Error Handling**: Standardized patterns across all database procedures
- **Comprehensive Logging**: Detailed error information for audit and analysis
- **Intelligent Escalation**: Automated routing based on error severity and type
- **Performance Monitoring**: Tracking error rates and resolution effectiveness

**Advanced Techniques Demonstrated:**

- **Dynamic Error Recovery**: Adaptive retry strategies based on error characteristics
- **Error Pattern Recognition**: Machine learning-ready error classification
- **Business Process Continuity**: Ensuring critical operations continue despite errors
- **Health Monitoring Integration**: Connecting error handling to system health metrics

This structured approach to exception handling enables TechCorp to build highly reliable database applications that maintain business continuity, provide excellent user experience, and support proactive system maintenance through comprehensive error intelligence.