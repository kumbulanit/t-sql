# Lesson 2: Controlling Transactions

## Overview

Transaction control is essential for managing data consistency, handling errors, and optimizing database performance in enterprise applications. This lesson covers explicit transaction management, savepoints, nested transactions, and advanced transaction control techniques. Understanding how to properly control transactions enables developers to build robust applications that can handle complex business scenarios while maintaining data integrity. For TechCorp's development teams, mastering transaction control is crucial for implementing reliable business processes that span multiple database operations.

## 🏢 TechCorp Business Context

**Advanced Transaction Control Scenarios:**

- **Complex Business Workflows**: Multi-step processes requiring granular control and rollback capabilities
- **Batch Processing Operations**: Large-scale data operations with checkpoint and recovery mechanisms
- **Integration Processes**: Cross-system data synchronization with partial failure handling
- **Financial Operations**: Critical transactions requiring precise control and audit capabilities
- **Performance Optimization**: Strategic transaction design for high-volume concurrent operations

### 📋 TechCorp Database Schema Reference

**Core Tables for Transaction Control Examples:**

```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, HireDate, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
TransactionAudit: TransactionID, TransactionType, TableName, RecordID, OldValues, NewValues, Timestamp
```

---

## 2.1 Explicit Transaction Control

### BEGIN TRANSACTION, COMMIT, and ROLLBACK

Explicit transaction control provides precise management over when transactions start, commit, or rollback.

```sql
-- TechCorp Example: Employee Transfer with Explicit Transaction Control
-- Demonstrates complete control over transaction lifecycle

CREATE OR ALTER PROCEDURE sp_TransferEmployee
    @EmployeeID INT,
    @NewDepartmentID INT,
    @TransferDate DATE = NULL,
    @Reason NVARCHAR(200) = 'Department Transfer'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize variables
    DECLARE @CurrentDepartmentID INT;
    DECLARE @EmployeeName NVARCHAR(100);
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @NewDepartmentBudget DECIMAL(15,2);
    DECLARE @TransactionName NVARCHAR(50) = 'EmployeeTransfer_' + CAST(@EmployeeID AS NVARCHAR(10));
    
    SET @TransferDate = ISNULL(@TransferDate, GETDATE());
    
    -- Start explicit transaction
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        -- Step 1: Validate employee exists and get current details
        SELECT 
            @CurrentDepartmentID = DepartmentID,
            @EmployeeName = FirstName + ' ' + LastName,
            @CurrentSalary = BaseSalary
        FROM Employees 
        WHERE EmployeeID = @EmployeeID AND IsActive = 1;
        
        IF @CurrentDepartmentID IS NULL
        BEGIN
            RAISERROR('Employee not found or inactive: %d', 16, 1, @EmployeeID);
        END;
        
        IF @CurrentDepartmentID = @NewDepartmentID
        BEGIN
            RAISERROR('Employee is already in the target department', 16, 1);
        END;
        
        -- Step 2: Validate new d.DepartmentName and check budget capacity
        SELECT @NewDepartmentBudget = Budget
        FROM Departments 
        WHERE DepartmentID = @NewDepartmentID AND IsActive = 1;
        
        IF @NewDepartmentBudget IS NULL
        BEGIN
            RAISERROR('Target d.DepartmentName not found or inactive: %d', 16, 1, @NewDepartmentID);
        END;
        
        IF @NewDepartmentBudget < @CurrentSalary
        BEGIN
            RAISERROR('Insufficient budget in target d.DepartmentName for employee BaseSalary', 16, 1);
        END;
        
        -- Step 3: Record transfer in audit table (before making changes)
        INSERT INTO TransactionAudit 
        (TransactionType, TableName, RecordID, OldValues, NewValues, Timestamp, Description)
        VALUES 
        ('EMPLOYEE_TRANSFER', 'Employees', @EmployeeID, 
         'DepartmentID: ' + CAST(@CurrentDepartmentID AS NVARCHAR(10)),
         'DepartmentID: ' + CAST(@NewDepartmentID AS NVARCHAR(10)),
         GETDATE(),
         @Reason);
        
        -- Step 4: Update employee d.DepartmentName
        UPDATE Employees 
        SET DepartmentID = @NewDepartmentID,
            ModifiedDate = @TransferDate
        WHERE EmployeeID = @EmployeeID;
        
        -- Step 5: Update old d.DepartmentName budget (free up budget)
        UPDATE Departments 
        SET Budget = Budget + @CurrentSalary,
            ModifiedDate = @TransferDate
        WHERE DepartmentID = @CurrentDepartmentID;
        
        -- Step 6: Update new d.DepartmentName budget (allocate budget)
        UPDATE Departments 
        SET Budget = Budget - @CurrentSalary,
            ModifiedDate = @TransferDate
        WHERE DepartmentID = @NewDepartmentID;
        
        -- Step 7: End current project assignments if any
        UPDATE EmployeeProjects 
        SET EndDate = @TransferDate,
            IsActive = 0,
            ModifiedDate = @TransferDate
        WHERE EmployeeID = @EmployeeID 
        AND IsActive = 1
        AND EndDate IS NULL;
        
        -- All operations successful - commit transaction
        COMMIT TRANSACTION @TransactionName;
        
        -- Return success status
        SELECT 
            @EmployeeID AS EmployeeID,
            @EmployeeName AS EmployeeName,
            @CurrentDepartmentID AS FromDepartmentID,
            @NewDepartmentID AS ToDepartmentID,
            @TransferDate AS TransferDate,
            'SUCCESS' AS Status,
            'Employee transfer completed successfully' AS Message;
        
        PRINT 'Employee ' + @EmployeeName + ' transferred successfully';
        
    END TRY
    BEGIN CATCH
        -- Error occurred - rollback transaction
        ROLLBACK TRANSACTION @TransactionName;
        
        -- Log error for investigation
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES 
        ('sp_TransferEmployee', ERROR_MESSAGE(), GETDATE(),
         'EmployeeID: ' + CAST(@EmployeeID AS NVARCHAR(10)) + 
         ', NewDepartmentID: ' + CAST(@NewDepartmentID AS NVARCHAR(10)));
        
        -- Return error status
        SELECT 
            @EmployeeID AS EmployeeID,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            'ERROR' AS Status;
        
        -- Re-raise error for calling application
        THROW;
    END CATCH;
END;

-- Test the transfer procedure
EXEC sp_TransferEmployee 
    @EmployeeID = 3001,
    @NewDepartmentID = 2002,
    @Reason = 'Strategic reorganization';
```

---

## 2.2 Savepoints and Nested Transactions

### Using SAVE TRANSACTION for Granular Control

Savepoints allow partial rollbacks within a transaction, providing fine-grained control over complex operations.

```sql
-- TechCorp Example: Complex Project Setup with Savepoints
-- Demonstrates granular transaction control with multiple rollback points

CREATE OR ALTER PROCEDURE sp_SetupComplexProject
    @ProjectName NVARCHAR(200),
    @ProjectManagerID INT,
    @Budget DECIMAL(15,2),
    @TeamMembers TeamMemberTableType READONLY  -- User-defined table type
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF;  -- Allow manual error handling
    
    DECLARE @ProjectID INT;
    DECLARE @TransactionName NVARCHAR(50) = 'ComplexProjectSetup';
    DECLARE @ProjectSavePoint NVARCHAR(50) = 'ProjectCreated';
    DECLARE @TeamSavePoint NVARCHAR(50) = 'TeamAssigned';
    DECLARE @BudgetSavePoint NVARCHAR(50) = 'BudgetAllocated';
    
    -- Start main transaction
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        -- Phase 1: Create project record
        INSERT INTO Projects 
        (ProjectName, ProjectManagerID, Budget, StartDate, IsActive, CreatedDate)
        VALUES 
        (@ProjectName, @ProjectManagerID, @Budget, GETDATE(), 1, GETDATE());
        
        SET @ProjectID = SCOPE_IDENTITY();
        
        -- Create savepoint after project creation
        SAVE TRANSACTION @ProjectSavePoint;
        
        PRINT 'Phase 1 Complete: Project created with ID ' + CAST(@ProjectID AS NVARCHAR(10));
        
        -- Phase 2: Assign team members
        DECLARE @MemberCount INT = 0;
        DECLARE @CurrentMemberID INT;
        DECLARE @CurrentRole NVARCHAR(50);
        
        -- Cursor for team member assignment
        DECLARE team_cursor CURSOR FOR
        SELECT EmployeeID, Role FROM @TeamMembers;
        
        OPEN team_cursor;
        FETCH NEXT FROM team_cursor INTO @CurrentMemberID, @CurrentRole;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Validate each team member
            IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @CurrentMemberID AND IsActive = 1)
            BEGIN
                CLOSE team_cursor;
                DEALLOCATE team_cursor;
                RAISERROR('Invalid team member: %d', 16, 1, @CurrentMemberID);
            END;
            
            -- Check if employee is already assigned to too many projects
            DECLARE @CurrentProjectCount INT;
            SELECT @CurrentProjectCount = COUNT(*)
            FROM EmployeeProjects 
            WHERE EmployeeID = @CurrentMemberID AND IsActive = 1;
            
            IF @CurrentProjectCount >= 3
            BEGIN
                CLOSE team_cursor;
                DEALLOCATE team_cursor;
                RAISERROR('Employee %d is already assigned to maximum projects', 16, 1, @CurrentMemberID);
            END;
            
            -- Assign team member to project
            INSERT INTO EmployeeProjects 
            (EmployeeID, ProjectID, Role, StartDate, IsActive, CreatedDate)
            VALUES 
            (@CurrentMemberID, @ProjectID, @CurrentRole, GETDATE(), 1, GETDATE());
            
            SET @MemberCount = @MemberCount + 1;
            
            FETCH NEXT FROM team_cursor INTO @CurrentMemberID, @CurrentRole;
        END;
        
        CLOSE team_cursor;
        DEALLOCATE team_cursor;
        
        -- Create savepoint after team assignment
        SAVE TRANSACTION @TeamSavePoint;
        
        PRINT 'Phase 2 Complete: ' + CAST(@MemberCount AS NVARCHAR(10)) + ' team members assigned';
        
        -- Phase 3: Allocate d.DepartmentName budgets
        DECLARE @ManagerDepartmentID INT;
        SELECT @ManagerDepartmentID = DepartmentID 
        FROM Employees 
        WHERE EmployeeID = @ProjectManagerID;
        
        -- Check if d.DepartmentName has sufficient budget
        DECLARE @DepartmentBudget DECIMAL(15,2);
        SELECT @DepartmentBudget = Budget 
        FROM Departments 
        WHERE DepartmentID = @ManagerDepartmentID;
        
        IF @DepartmentBudget < @Budget
        BEGIN
            RAISERROR('Insufficient d.DepartmentName budget for project', 16, 1);
        END;
        
        -- Allocate budget from d.DepartmentName
        UPDATE Departments 
        SET Budget = Budget - @Budget,
            ModifiedDate = GETDATE()
        WHERE DepartmentID = @ManagerDepartmentID;
        
        -- Create savepoint after budget allocation
        SAVE TRANSACTION @BudgetSavePoint;
        
        PRINT 'Phase 3 Complete: Budget allocated FROM Departments';
        
        -- Phase 4: Final validations and setup
        -- Update project with final team count
        UPDATE Projects 
        SET TeamMemberCount = @MemberCount,
            ModifiedDate = GETDATE()
        WHERE ProjectID = @ProjectID;
        
        -- All phases successful - commit entire transaction
        COMMIT TRANSACTION @TransactionName;
        
        -- Return success status
        SELECT 
            @ProjectID AS ProjectID,
            @ProjectName AS ProjectName,
            @MemberCount AS TeamMemberCount,
            @Budget AS AllocatedBudget,
            'SUCCESS' AS Status,
            'Complex project setup completed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        
        -- Determine appropriate rollback strategy based on error
        IF @ErrorMessage LIKE '%budget%'
        BEGIN
            -- Budget-related error - rollback to team assignment savepoint
            PRINT 'Budget error detected - rolling back budget allocation only';
            ROLLBACK TRANSACTION @BudgetSavePoint;
            
            -- Try to continue with reduced scope
            -- (In real scenario, might prompt for budget approval)
            PRINT 'Project created with team but budget allocation pending approval';
            
            -- Still commit the transaction with partial setup
            COMMIT TRANSACTION @TransactionName;
            
            SELECT 
                @ProjectID AS ProjectID,
                'PARTIAL_SUCCESS' AS Status,
                'Project created but budget allocation requires approval' AS Message;
        END
        ELSE IF @ErrorMessage LIKE '%team member%' OR @ErrorMessage LIKE '%Employee%'
        BEGIN
            -- Team-related error - rollback to project creation savepoint
            PRINT 'Team assignment error - rolling back team assignments';
            ROLLBACK TRANSACTION @TeamSavePoint;
            
            -- Project exists but no team assigned
            COMMIT TRANSACTION @TransactionName;
            
            SELECT 
                @ProjectID AS ProjectID,
                'PARTIAL_SUCCESS' AS Status,
                'Project created but team assignment failed: ' + @ErrorMessage AS Message;
        END
        ELSE
        BEGIN
            -- Critical error - rollback entire transaction
            PRINT 'Critical error - rolling back entire transaction';
            ROLLBACK TRANSACTION @TransactionName;
            
            SELECT 
                0 AS ProjectID,
                'ERROR' AS Status,
                'Project setup failed: ' + @ErrorMessage AS Message;
        END;
        
        -- Log error details
        INSERT INTO ErrorLog (ErrorProcedure, ErrorNumber, ErrorMessage, ErrorTime)
        VALUES ('sp_SetupComplexProject', @ErrorNumber, @ErrorMessage, GETDATE());
        
    END CATCH;
END;

-- Example usage with team member table type
DECLARE @TeamMembers AS TeamMemberTableType;
INSERT INTO @TeamMembers (EmployeeID, Role) VALUES 
(3001, 'Senior Developer'),
(3002, 'Business Analyst'),
(3003, 'QA Engineer');

EXEC sp_SetupComplexProject 
    @ProjectName = 'TechCorp Digital Transformation',
    @ProjectManagerID = 3001,
    @Budget = 500000.00,
    @TeamMembers = @TeamMembers;
```

---

## 2.3 Transaction Isolation Levels

### Controlling Concurrent Access with Isolation Levels

Different isolation levels provide varying degrees of consistency and concurrency control.

```sql
-- TechCorp Example: Demonstrating Different Isolation Levels
-- Shows impact of isolation levels on concurrent operations

-- Create test procedure for isolation level demonstration
CREATE OR ALTER PROCEDURE sp_DemonstrateIsolationLevels
    @IsolationLevel NVARCHAR(20) = 'READ_COMMITTED'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set the specified isolation level
    IF @IsolationLevel = 'READ_UNCOMMITTED'
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    ELSE IF @IsolationLevel = 'READ_COMMITTED'
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    ELSE IF @IsolationLevel = 'REPEATABLE_READ'
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    ELSE IF @IsolationLevel = 'SERIALIZABLE'
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    ELSE IF @IsolationLevel = 'SNAPSHOT'
        SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
    
    DECLARE @EmployeeID INT = 3001;
    DECLARE @InitialSalary DECIMAL(10,2);
    DECLARE @FinalSalary DECIMAL(10,2);
    
    PRINT 'Starting transaction with isolation level: ' + @IsolationLevel;
    
    BEGIN TRANSACTION IsolationDemo;
    
    BEGIN TRY
        -- First read
        SELECT @InitialSalary = BaseSalary 
        FROM Employees 
        WHERE EmployeeID = @EmployeeID;
        
        PRINT 'Initial BaseSalary read: ' + CAST(@InitialSalary AS NVARCHAR(20));
        
        -- Simulate processing time to allow concurrent modifications
        PRINT 'Simulating processing time (5 seconds)...';
        WAITFOR DELAY '00:00:05';
        
        -- Second read (behavior depends on isolation level)
        SELECT @FinalSalary = BaseSalary 
        FROM Employees 
        WHERE EmployeeID = @EmployeeID;
        
        PRINT 'Final BaseSalary read: ' + CAST(@FinalSalary AS NVARCHAR(20));
        
        -- Check for phantom reads or non-repeatable reads
        IF @InitialSalary <> @FinalSalary
        BEGIN
            PRINT 'WARNING: Non-repeatable read detected!';
            PRINT 'BaseSalary changed from ' + CAST(@InitialSalary AS NVARCHAR(20)) + 
                  ' to ' + CAST(@FinalSalary AS NVARCHAR(20));
        END
        ELSE
        BEGIN
            PRINT 'Consistent read - no changes detected';
        END;
        
        COMMIT TRANSACTION IsolationDemo;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION IsolationDemo;
        PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Test script for isolation levels (run in separate sessions)
-- Session 1: Reader with different isolation levels
EXEC sp_DemonstrateIsolationLevels @IsolationLevel = 'READ_COMMITTED';

-- Session 2: Writer (run concurrently with Session 1)
-- This should be executed during the WAITFOR DELAY in Session 1
UPDATE Employees 
SET BaseSalary = BaseSalary + 1000 
WHERE EmployeeID = 3001;
```

### Snapshot Isolation for TechCorp Reporting

```sql
-- TechCorp Example: Using Snapshot Isolation for Consistent Reporting
-- Ensures consistent reporting data even during concurrent updates

-- Enable snapshot isolation for the database (run once)
-- ALTER DATABASE TechCorpDB SET ALLOW_SNAPSHOT_ISOLATION ON;
-- ALTER DATABASE TechCorpDB SET READ_COMMITTED_SNAPSHOT ON;

CREATE OR ALTER PROCEDURE sp_GenerateConsistentReport
    @ReportDate DATE = NULL,
    @DepartmentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
    
    SET @ReportDate = ISNULL(@ReportDate, GETDATE());
    
    BEGIN TRANSACTION SnapshotReport;
    
    BEGIN TRY
        PRINT 'Starting consistent report generation with snapshot isolation';
        
        -- Create temporary table for report data
        CREATE TABLE #ReportData (
            DepartmentID INT,
            d.DepartmentName NVARCHAR(100),
            EmployeeCount INT,
            TotalSalary DECIMAL(15,2),
            AverageSalary DECIMAL(10,2),
            ProjectCount INT,
            ReportTimestamp DATETIME
        );
        
        -- Collect d.DepartmentName statistics (consistent view)
        INSERT INTO #ReportData
        SELECT 
            d.DepartmentID,
            d.DepartmentName,
            COUNT(DISTINCT e.EmployeeID) AS EmployeeCount,
            SUM(e.BaseSalary) AS TotalSalary,
            AVG(e.BaseSalary) AS AverageBaseSalary,
            COUNT(DISTINCT p.ProjectID) AS ProjectCount,
            GETDATE() AS ReportTimestamp
        FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
        LEFT JOIN Projects p ON d.DepartmentID = (
            SELECT DepartmentID FROM Employees WHERE EmployeeID = p.ProjectManagerID
        ) AND p.IsActive = 1
        WHERE d.IsActive = 1
        AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
        GROUP BY d.DepartmentID, d.DepartmentName;
        
        -- Simulate long-running report generation
        PRINT 'Processing report data (may take several seconds)...';
        WAITFOR DELAY '00:00:03';
        
        -- Generate final report
        SELECT 'TechCorp d.DepartmentName Analysis Report' AS ReportTitle,
            @ReportDate AS ReportDate,
            DepartmentName,
            EmployeeCount,
            FORMAT(TotalSalary, 'C') AS TotalSalary,
            FORMAT(AverageSalary, 'C') AS AverageBaseSalary,
            ProjectCount,
            ReportTimestamp
        FROM #ReportData
        ORDER BY d.DepartmentName;
        
        -- Summary statistics
        SELECT 
            'Report Summary' AS SummaryType,
            COUNT(*) AS DepartmentsAnalyzed,
            SUM(EmployeeCount) AS TotalEmployees,
            FORMAT(SUM(TotalSalary), 'C') AS CompanyTotalSalary,
            FORMAT(AVG(AverageSalary), 'C') AS CompanyAverageSalary,
            SUM(ProjectCount) AS TotalActiveProjects
        FROM #ReportData;
        
        COMMIT TRANSACTION SnapshotReport;
        
        PRINT 'Report generation completed successfully with consistent data';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION SnapshotReport;
        
        PRINT 'Report generation failed: ' + ERROR_MESSAGE();
        
        -- Clean up
        IF OBJECT_ID('tempdb..#ReportData') IS NOT NULL
            DROP TABLE #ReportData;
            
        THROW;
    END CATCH;
END;

-- Execute consistent report
EXEC sp_GenerateConsistentReport @DepartmentID = NULL;
```

---

## 2.4 Advanced Transaction Control Techniques

### Distributed Transactions and Two-Phase Commit

```sql
-- TechCorp Example: Distributed Transaction for Cross-System Integration
-- Demonstrates coordination between multiple databases/systems

CREATE OR ALTER PROCEDURE sp_ProcessDistributedPayroll
    @PayrollPeriodID INT,
    @ProcessingDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @ProcessingDate = ISNULL(@ProcessingDate, GETDATE());
    
    -- Begin distributed transaction
    BEGIN DISTRIBUTED TRANSACTION PayrollDistribution;
    
    BEGIN TRY
        -- Phase 1: Update local TechCorp database
        PRINT 'Phase 1: Processing payroll in TechCorp database';
        
        -- Update employee payroll status
        UPDATE Employees 
        SET LastPayrollProcessed = @ProcessingDate,
            PayrollPeriodID = @PayrollPeriodID,
            ModifiedDate = @ProcessingDate
        WHERE IsActive = 1;
        
        DECLARE @ProcessedEmployees INT = @@ROWCOUNT;
        
        -- Insert payroll batch record
        INSERT INTO PayrollBatches 
        (PayrollPeriodID, ProcessingDate, EmployeeCount, Status, CreatedDate)
        VALUES 
        (@PayrollPeriodID, @ProcessingDate, @ProcessedEmployees, 'PROCESSING', @ProcessingDate);
        
        -- Phase 2: Update external HR system (simulated with linked server)
        PRINT 'Phase 2: Updating external HR system';
        
        -- This would typically involve a linked server or external service call
        -- For demonstration, we'll simulate with a local table
        UPDATE HRSystemSync 
        SET LastSyncDate = @ProcessingDate,
            SyncStatus = 'PAYROLL_PROCESSED',
            RecordCount = @ProcessedEmployees
        WHERE SystemName = 'TechCorp_Payroll';
        
        -- Phase 3: Update financial system integration
        PRINT 'Phase 3: Updating financial system';
        
        -- Calculate total payroll amount
        DECLARE @TotalPayrollAmount DECIMAL(15,2);
        SELECT @TotalPayrollAmount = SUM(e.BaseSalary)
        FROM Employees 
        WHERE IsActive = 1;
        
        -- Insert financial transaction record
        INSERT INTO FinancialTransactions 
        (TransactionType, Amount, ProcessingDate, Description, PayrollPeriodID)
        VALUES 
        ('PAYROLL_EXPENSE', @TotalPayrollAmount, @ProcessingDate, 
         'Payroll processing for period ' + CAST(@PayrollPeriodID AS NVARCHAR(10)),
         @PayrollPeriodID);
        
        -- All phases successful - commit distributed transaction
        COMMIT TRANSACTION PayrollDistribution;
        
        PRINT 'Distributed payroll transaction completed successfully';
        PRINT 'Employees processed: ' + CAST(@ProcessedEmployees AS NVARCHAR(10));
        PRINT 'Total amount: ' + FORMAT(@TotalPayrollAmount, 'C');
        
        -- Return success status
        SELECT 
            @PayrollPeriodID AS PayrollPeriodID,
            @ProcessedEmployees AS EmployeesProcessed,
            @TotalPayrollAmount AS TotalAmount,
            'SUCCESS' AS Status;
        
    END TRY
    BEGIN CATCH
        -- Error in any phase - rollback entire distributed transaction
        ROLLBACK TRANSACTION PayrollDistribution;
        
        PRINT 'Distributed transaction failed: ' + ERROR_MESSAGE();
        
        -- Log error for investigation
        INSERT INTO ErrorLog 
        (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES 
        ('sp_ProcessDistributedPayroll', ERROR_MESSAGE(), GETDATE(),
         'PayrollPeriodID: ' + CAST(@PayrollPeriodID AS NVARCHAR(10)));
        
        -- Return error status
        SELECT 
            @PayrollPeriodID AS PayrollPeriodID,
            0 AS EmployeesProcessed,
            0 AS TotalAmount,
            'ERROR: ' + ERROR_MESSAGE() AS Status;
        
        THROW;
    END CATCH;
END;
```

### Transaction Control with Dynamic SQL

```sql
-- TechCorp Example: Dynamic Transaction Control for Flexible Operations
-- Demonstrates transaction control with dynamically generated SQL

CREATE OR ALTER PROCEDURE sp_DynamicDataArchival
    @TableName NVARCHAR(128),
    @ArchiveCriteria NVARCHAR(500),
    @BatchSize INT = 1000,
    @MaxBatches INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate table name to prevent SQL injection
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = @TableName)
    BEGIN
        RAISERROR('Invalid table name: %s', 16, 1, @TableName);
        RETURN;
    END;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @CurrentBatch INT = 1;
    DECLARE @RecordsArchived INT = 0;
    DECLARE @TotalArchived INT = 0;
    DECLARE @TransactionName NVARCHAR(50) = 'DynamicArchival_' + @TableName;
    
    -- Start main archival transaction
    BEGIN TRANSACTION @TransactionName;
    
    BEGIN TRY
        WHILE @CurrentBatch <= @MaxBatches
        BEGIN
            PRINT 'Processing batch ' + CAST(@CurrentBatch AS NVARCHAR(10)) + ' of ' + CAST(@MaxBatches AS NVARCHAR(10));
            
            -- Create savepoint for each batch
            DECLARE @BatchSavepoint NVARCHAR(50) = 'Batch_' + CAST(@CurrentBatch AS NVARCHAR(10));
            SAVE TRANSACTION @BatchSavepoint;
            
            -- Build dynamic SQL for archival
            SET @SQL = N'
                WITH RecordsToArchive AS (
                    SELECT TOP (' + CAST(@BatchSize AS NVARCHAR(10)) + ') *
                    FROM ' + QUOTENAME(@TableName) + '
                    WHERE ' + @ArchiveCriteria + '
                    AND IsArchived = 0
                )
                INSERT INTO ' + QUOTENAME(@TableName + '_Archive') + '
                SELECT *, GETDATE() AS ArchivedDate
                FROM RecordsToArchive;
                
                UPDATE ' + QUOTENAME(@TableName) + '
                SET IsArchived = 1, ArchivedDate = GETDATE()
                WHERE EXISTS (
                    SELECT 1 FROM ' + QUOTENAME(@TableName + '_Archive') + ' a
                    WHERE a.RecordID = ' + QUOTENAME(@TableName) + '.RecordID
                    AND a.ArchivedDate = (SELECT MAX(ArchivedDate) FROM ' + QUOTENAME(@TableName + '_Archive') + ')
                );';
            
            -- Execute dynamic SQL within transaction
            EXEC sp_executesql @SQL;
            SET @RecordsArchived = @@ROWCOUNT;
            
            -- Check if any records were processed
            IF @RecordsArchived = 0
            BEGIN
                PRINT 'No more records to archive - stopping process';
                BREAK;
            END;
            
            SET @TotalArchived = @TotalArchived + @RecordsArchived;
            PRINT 'Batch ' + CAST(@CurrentBatch AS NVARCHAR(10)) + ' completed: ' + CAST(@RecordsArchived AS NVARCHAR(10)) + ' records archived';
            
            -- Introduce delay to prevent blocking
            IF @CurrentBatch < @MaxBatches
                WAITFOR DELAY '00:00:01';
            
            SET @CurrentBatch = @CurrentBatch + 1;
        END;
        
        -- Commit entire archival transaction
        COMMIT TRANSACTION @TransactionName;
        
        PRINT 'Dynamic archival completed successfully';
        PRINT 'Total records archived: ' + CAST(@TotalArchived AS NVARCHAR(10));
        
        -- Return summary
        SELECT 
            @TableName AS TableName,
            @TotalArchived AS TotalRecordsArchived,
            @CurrentBatch - 1 AS BatchesProcessed,
            'SUCCESS' AS Status;
        
    END TRY
    BEGIN CATCH
        -- Error occurred - rollback to last successful batch
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        
        IF XACT_STATE() = 1  -- Uncommittable transaction
        BEGIN
            -- Try to rollback to last batch savepoint
            ROLLBACK TRANSACTION @BatchSavepoint;
            PRINT 'Rolled back current batch due to error';
            
            -- Commit successful batches
            COMMIT TRANSACTION @TransactionName;
            
            SELECT 
                @TableName AS TableName,
                @TotalArchived AS TotalRecordsArchived,
                @CurrentBatch - 1 AS SuccessfulBatches,
                'PARTIAL_SUCCESS - Error in batch ' + CAST(@CurrentBatch AS NVARCHAR(10)) + ': ' + @ErrorMessage AS Status;
        END
        ELSE
        BEGIN
            -- Complete rollback required
            ROLLBACK TRANSACTION @TransactionName;
            
            SELECT 
                @TableName AS TableName,
                0 AS TotalRecordsArchived,
                0 AS SuccessfulBatches,
                'ERROR: ' + @ErrorMessage AS Status;
        END;
        
        -- Log error
        INSERT INTO ErrorLog (ErrorProcedure, ErrorMessage, ErrorTime, AdditionalInfo)
        VALUES ('sp_DynamicDataArchival', @ErrorMessage, GETDATE(), 
                'Table: ' + @TableName + ', Batch: ' + CAST(@CurrentBatch AS NVARCHAR(10)));
    END CATCH;
END;

-- Example usage
EXEC sp_DynamicDataArchival 
    @TableName = 'Orders',
    @ArchiveCriteria = 'OrderDate < DATEADD(YEAR, -2, GETDATE())',
    @BatchSize = 500,
    @MaxBatches = 5;
```

---

## 2.5 Performance Optimization and Monitoring

### Transaction Performance Analysis

```sql
-- TechCorp Example: Comprehensive Transaction Performance Monitoring
-- Tools for analyzing and optimizing transaction performance

CREATE OR ALTER PROCEDURE sp_AnalyzeTransactionPerformance
    @AnalysisTimeframeMinutes INT = 30,
    @ShowDetailedLocks BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME = DATEADD(MINUTE, -@AnalysisTimeframeMinutes, GETDATE());
    
    PRINT 'TechCorp Transaction Performance Analysis';
    PRINT 'Analysis Period: ' + CAST(@AnalysisTimeframeMinutes AS NVARCHAR(10)) + ' minutes';
    PRINT 'Start Time: ' + CONVERT(NVARCHAR(30), @StartTime, 120);
    PRINT '----------------------------------------';
    
    -- 1. Active Transaction Summary
    SELECT 
        'Active Transactions' AS MetricCategory,
        COUNT(*) AS ActiveTransactionCount,
        AVG(DATEDIFF(SECOND, transaction_begin_time, GETDATE())) AS AvgDurationSeconds,
        MAX(DATEDIFF(SECOND, transaction_begin_time, GETDATE())) AS MaxDurationSeconds,
        SUM(CASE WHEN transaction_type = 1 THEN 1 ELSE 0 END) AS ReadWriteTransactions,
        SUM(CASE WHEN transaction_type = 2 THEN 1 ELSE 0 END) AS ReadOnlyTransactions
    FROM sys.dm_tran_active_transactions
    WHERE transaction_begin_time >= @StartTime;
    
    -- 2. Lock Wait Analysis
    SELECT 
        'Lock Wait Statistics' AS MetricCategory,
        wait_type AS WaitType,
        waiting_tasks_count AS WaitingTasksCount,
        wait_time_ms AS TotalWaitTimeMS,
        max_wait_time_ms AS MaxWaitTimeMS,
        signal_wait_time_ms AS SignalWaitTimeMS,
        wait_time_ms / NULLIF(waiting_tasks_count, 0) AS AvgWaitTimeMS
    FROM sys.dm_os_wait_stats
    WHERE wait_type LIKE 'LCK%'
    AND waiting_tasks_count > 0
    ORDER BY wait_time_ms DESC;
    
    -- 3. Blocking Chain Analysis
    WITH BlockingHierarchy AS (
        SELECT 
            session_id,
            blocking_session_id,
            wait_type,
            wait_time,
            wait_resource,
            0 AS Level
        FROM sys.dm_exec_requests
        WHERE blocking_session_id = 0
        AND session_id IN (SELECT DISTINCT blocking_session_id FROM sys.dm_exec_requests)
        
        UNION ALL
        
        SELECT 
            r.session_id,
            r.blocking_session_id,
            r.wait_type,
            r.wait_time,
            r.wait_resource,
            bh.Level + 1
        FROM sys.dm_exec_requests r
        INNER JOIN BlockingHierarchy bh ON r.blocking_session_id = bh.session_id
        WHERE r.blocking_session_id <> 0
    )
    SELECT 
        'Blocking Chains' AS MetricCategory,
        Level AS BlockingLevel,
        session_id AS SessionID,
        blocking_session_id AS BlockingSessionID,
        wait_type AS WaitType,
        wait_time AS WaitTimeMS,
        wait_resource AS WaitResource
    FROM BlockingHierarchy
    ORDER BY Level, wait_time DESC;
    
    -- 4. Transaction Log Analysis
    SELECT 
        'Transaction Log Performance' AS MetricCategory,
        db_name() AS DatabaseName,
        (total_log_size_in_bytes / 1024.0 / 1024.0) AS LogSizeMB,
        (used_log_space_in_bytes / 1024.0 / 1024.0) AS UsedLogSpaceMB,
        (used_log_space_in_percent) AS UsedLogSpacePercent,
        log_space_in_bytes_since_last_backup / 1024.0 / 1024.0 AS LogSpaceSinceBackupMB
    FROM sys.dm_db_log_space_usage;
    
    -- 5. Top Resource-Consuming Queries
    SELECT TOP 10
        'Resource Intensive Queries' AS MetricCategory,
        qs.execution_count AS ExecutionCount,
        qs.total_worker_time / 1000 AS TotalCPUTimeMS,
        qs.total_elapsed_time / 1000 AS TotalElapsedTimeMS,
        qs.total_logical_reads AS TotalLogicalReads,
        qs.total_physical_reads AS TotalPhysicalReads,
        SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
            ((CASE qs.statement_end_offset
                WHEN -1 THEN DATALENGTH(st.text)
                ELSE qs.statement_end_offset
            END - qs.statement_start_offset)/2) + 1) AS QueryText
    FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    WHERE qs.creation_time >= @StartTime
    ORDER BY qs.total_worker_time DESC;
    
    -- 6. Detailed Lock Information (if requested)
    IF @ShowDetailedLocks = 1
    BEGIN
        SELECT 
            'Current Lock Details' AS MetricCategory,
            tl.request_session_id AS SessionID,
            tl.resource_type AS ResourceType,
            tl.resource_subtype AS ResourceSubtype,
            tl.request_mode AS LockMode,
            tl.request_status AS LockStatus,
            obj.name AS ObjectName,
            idx.name AS IndexName,
            es.login_name AS LoginName,
            es.program_name AS ProgramName
        FROM sys.dm_tran_locks tl
        LEFT JOIN sys.objects obj ON tl.resource_associated_entity_id = obj.object_id
        LEFT JOIN sys.indexes idx ON obj.object_id = idx.object_id 
            AND tl.resource_subtype = idx.index_id
        LEFT JOIN sys.dm_exec_sessions es ON tl.request_session_id = es.session_id
        WHERE tl.resource_database_id = DB_ID()
        AND obj.name IN ('Employees', 'Departments', 'Projects', 'Orders', 'Customers')
        ORDER BY tl.request_session_id, obj.name;
    END;
    
    PRINT '----------------------------------------';
    PRINT 'Analysis completed at: ' + CONVERT(NVARCHAR(30), GETDATE(), 120);
END;

-- Execute performance analysis
EXEC sp_AnalyzeTransactionPerformance 
    @AnalysisTimeframeMinutes = 15,
    @ShowDetailedLocks = 1;
```

---

## Summary

Controlling transactions effectively is essential for building robust, high-performance database applications:

**Transaction Control Mastery:**

- **Explicit Control**: BEGIN TRANSACTION, COMMIT, and ROLLBACK for precise transaction management
- **Savepoints**: Granular rollback capabilities for complex operations with multiple phases
- **Isolation Levels**: Balancing consistency requirements with concurrency performance
- **Error Handling**: Comprehensive error recovery strategies with appropriate rollback mechanisms

**Advanced Techniques:**

- **Distributed Transactions**: Coordinating operations across multiple databases and systems
- **Dynamic SQL Integration**: Transaction control with flexible, runtime-generated operations
- **Performance Optimization**: Monitoring and tuning transaction performance for scalability
- **Batch Processing**: Efficient handling of large-scale operations with checkpoint capabilities

**TechCorp Applications:**

- **Business Process Integrity**: Ensuring complex workflows maintain consistency across all steps
- **High-Volume Operations**: Optimizing transaction design for concurrent user scenarios
- **System Integration**: Managing data consistency across multiple enterprise systems
- **Performance Monitoring**: Proactive identification and resolution of transaction bottlenecks

**Best Practices Demonstrated:**

- Proper transaction scope and lifetime management
- Strategic use of savepoints for complex operations
- Appropriate isolation level selection for business requirements
- Comprehensive error handling and recovery procedures
- Performance monitoring and optimization techniques

Mastering these transaction control techniques enables TechCorp's development teams to build enterprise applications that handle complex business operations reliably while maintaining optimal performance in multi-user environments.