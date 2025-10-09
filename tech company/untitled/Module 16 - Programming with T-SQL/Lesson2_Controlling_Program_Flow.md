# Lesson 2: Controlling Program Flow

## Overview

Program flow control is essential for creating intelligent database applications that can make decisions, handle complex business logic, and process data efficiently. T-SQL provides comprehensive control flow structures including conditional statements, loops, error handling blocks, and branching mechanisms that enable developers to create sophisticated business logic within the database layer. For TechCorp's development teams, mastering program flow control is crucial for implementing complex business rules, data processing workflows, and automated decision-making systems that support enterprise operations.

## 🏢 TechCorp Business Context

**Program Flow Control in Enterprise Applications:**

- **Business Rule Implementation**: Complex decision trees and conditional processing
- **Data Processing Workflows**: Iterative data transformation and validation processes
- **Exception Handling**: Robust error management and recovery procedures
- **Automated Decision Making**: System-driven business process automation
- **Performance Optimization**: Efficient processing through controlled execution paths

### 📋 TechCorp Database Schema Reference

**Core Tables for Control Flow Examples:**

```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Conditional Logic: IF...ELSE Statements

### Basic Conditional Processing

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        T-SQL Conditional Control Flow                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  IF...ELSE Structure:                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ IF condition                                                        │   │
│  │ BEGIN                                                               │   │
│  │     -- Statements when condition is TRUE                           │   │
│  │ END                                                                 │   │
│  │ ELSE                                                                │   │
│  │ BEGIN                                                               │   │
│  │     -- Statements when condition is FALSE                          │   │
│  │ END                                                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Nested IF Statements:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ IF condition1                                                       │   │
│  │ BEGIN                                                               │   │
│  │     IF condition2                                                   │   │
│  │         statement1;                                                 │   │
│  │     ELSE                                                            │   │
│  │         statement2;                                                 │   │
│  │ END                                                                 │   │
│  │ ELSE IF condition3                                                  │   │
│  │     statement3;                                                     │   │
│  │ ELSE                                                                │   │
│  │     statement4;                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Best Practices:                                                           │
│  • Use BEGIN...END blocks for multiple statements                         │
│  • Handle NULL values appropriately in conditions                         │
│  • Order conditions from most specific to general                         │
│  • Consider performance implications of complex conditions                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### TechCorp Example: Employee Performance Review Decision System

```sql
-- Comprehensive employee performance review system using conditional logic
CREATE PROCEDURE sp_TechCorp_ProcessPerformanceReview
    @EmployeeID INT,
    @ReviewPeriodMonths INT = 12,
    @AutoApproveRaises BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare variables for employee information
    DECLARE @EmployeeName VARCHAR(101);
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @DepartmentID INT;
    DECLARE @d.DepartmentName VARCHAR(100);
    DECLARE @YearsOfService INT;
    DECLARE @JobTitle VARCHAR(100);
    DECLARE @ManagerID INT;
    DECLARE @HireDate DATE;
    
    -- Performance metrics variables
    DECLARE @ProjectCount INT = 0;
    DECLARE @TotalProjectHours DECIMAL(8,2) = 0;
    DECLARE @OrdersProcessed INT = 0;
    DECLARE @CustomerServiceRating DECIMAL(3,1) = 0;
    DECLARE @DirectReports INT = 0;
    DECLARE @PerformanceScore DECIMAL(5,2) = 0;
    
    -- Decision variables
    DECLARE @RecommendedRaise DECIMAL(5,2) = 0;
    DECLARE @RecommendedPromotion BIT = 0;
    DECLARE @RequiresImprovement BIT = 0;
    DECLARE @EligibleForBonus BIT = 0;
    DECLARE @ReviewStatus VARCHAR(50);
    DECLARE @ActionPlan VARCHAR(1000) = '';
    
    -- Get employee basic information
    SELECT 
        @EmployeeName = FirstName + ' ' + LastName,
        @CurrentSalary = BaseSalary,
        @DepartmentID = DepartmentID,
        @JobTitle = JobTitle,
        @ManagerID = ManagerID,
        @HireDate = HireDate,
        @YearsOfService = DATEDIFF(YEAR, HireDate, GETDATE())
    FROM Employees
    WHERE EmployeeID = @EmployeeID AND IsActive = 1;
    
    -- Check if employee exists
    IF @EmployeeName IS NULL
    BEGIN
        PRINT 'ERROR: Employee ID ' + CAST(@EmployeeID AS VARCHAR) + ' not found or inactive.';
        RETURN -1;
    END
    
    -- Get d.DepartmentName information
    SELECT @d.DepartmentName = d.DepartmentName
    FROM Departments
    WHERE DepartmentID = @DepartmentID AND IsActive = 1;
    
    -- Calculate performance metrics
    SELECT 
        @ProjectCount = COUNT(DISTINCT ep.ProjectID),
        @TotalProjectHours = ISNULL(SUM(ep.HoursWorked), 0)
    FROM EmployeeProjects ep
    WHERE ep.EmployeeID = @EmployeeID
      AND ep.IsActive = 1
      AND ep.StartDate >= DATEADD(MONTH, -@ReviewPeriodMonths, GETDATE());
    
    SELECT @OrdersProcessed = COUNT(*)
    FROM Orders o
    WHERE o.EmployeeID = @EmployeeID
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -@ReviewPeriodMonths, GETDATE());
    
    SELECT @DirectReports = COUNT(*)
    FROM Employees
    WHERE ManagerID = @EmployeeID AND IsActive = 1;
    
    -- Start performance evaluation logic
    PRINT '=== TechCorp Performance Review ===';
    PRINT 'Employee: ' + @EmployeeName + ' (' + CAST(@EmployeeID AS VARCHAR) + ')';
    PRINT 'Department: ' + @d.DepartmentName;
    PRINT 'Position: ' + @JobTitle;
    PRINT 'Review Period: ' + CAST(@ReviewPeriodMonths AS VARCHAR) + ' months';
    PRINT 'Years of Service: ' + CAST(@YearsOfService AS VARCHAR);
    PRINT '';
    
    -- Primary performance evaluation using nested conditional logic
    IF @YearsOfService < 1
    BEGIN
        -- New employee evaluation
        PRINT 'STATUS: New Employee Review';
        
        IF @ProjectCount >= 2 AND @TotalProjectHours >= 100
        BEGIN
            SET @PerformanceScore = 75;
            SET @ReviewStatus = 'Exceeds New Employee Expectations';
            SET @EligibleForBonus = 1;
            SET @RecommendedRaise = 3.0;
            SET @ActionPlan = 'Continue current development path. Consider additional training opportunities.';
        END
        ELSE IF @ProjectCount >= 1 OR @TotalProjectHours >= 50
        BEGIN
            SET @PerformanceScore = 65;
            SET @ReviewStatus = 'Meets New Employee Expectations';
            SET @RecommendedRaise = 2.0;
            SET @ActionPlan = 'Encourage more project participation. Provide mentoring support.';
        END
        ELSE
        BEGIN
            SET @PerformanceScore = 45;
            SET @ReviewStatus = 'Below New Employee Expectations';
            SET @RequiresImprovement = 1;
            SET @ActionPlan = 'Immediate improvement plan required. Increase supervision and training.';
        END
    END
    ELSE IF @YearsOfService >= 1 AND @YearsOfService < 5
    BEGIN
        -- Mid-level employee evaluation
        PRINT 'STATUS: Mid-Level Employee Review';
        
        IF @ProjectCount >= 4 AND @TotalProjectHours >= 300 AND @OrdersProcessed >= 20
        BEGIN
            SET @PerformanceScore = 90;
            SET @ReviewStatus = 'Outstanding Performance';
            SET @EligibleForBonus = 1;
            SET @RecommendedRaise = 8.0;
            
            IF @DirectReports >= 2
            BEGIN
                SET @RecommendedPromotion = 1;
                SET @ActionPlan = 'Promotion recommended. Consider senior role or team leadership position.';
            END
            ELSE
            BEGIN
                SET @ActionPlan = 'Excellent performance. Consider leadership development opportunities.';
            END
        END
        ELSE IF @ProjectCount >= 2 AND (@TotalProjectHours >= 150 OR @OrdersProcessed >= 10)
        BEGIN
            SET @PerformanceScore = 75;
            SET @ReviewStatus = 'Good Performance';
            SET @EligibleForBonus = 1;
            SET @RecommendedRaise = 5.0;
            SET @ActionPlan = 'Solid performance. Encourage increased project involvement.';
        END
        ELSE IF @ProjectCount >= 1 OR @TotalProjectHours >= 75 OR @OrdersProcessed >= 5
        BEGIN
            SET @PerformanceScore = 60;
            SET @ReviewStatus = 'Satisfactory Performance';
            SET @RecommendedRaise = 3.0;
            SET @ActionPlan = 'Meeting minimum expectations. Focus on skill development and engagement.';
        END
        ELSE
        BEGIN
            SET @PerformanceScore = 40;
            SET @ReviewStatus = 'Below Expectations';
            SET @RequiresImprovement = 1;
            SET @ActionPlan = 'Performance improvement plan required. Set specific goals and timeline.';
        END
    END
    ELSE
    BEGIN
        -- Senior employee evaluation (5+ years)
        PRINT 'STATUS: Senior Employee Review';
        
        IF @ProjectCount >= 5 AND @TotalProjectHours >= 400 AND (@OrdersProcessed >= 30 OR @DirectReports >= 3)
        BEGIN
            SET @PerformanceScore = 95;
            SET @ReviewStatus = 'Exceptional Senior Performance';
            SET @EligibleForBonus = 1;
            SET @RecommendedRaise = 10.0;
            
            IF @DirectReports >= 5 OR (@CurrentSalary < 100000 AND @YearsOfService >= 8)
            BEGIN
                SET @RecommendedPromotion = 1;
                SET @ActionPlan = 'Executive promotion consideration. Leadership role expansion recommended.';
            END
            ELSE
            BEGIN
                SET @ActionPlan = 'Outstanding senior contributor. Consider technical leadership or specialization path.';
            END
        END
        ELSE IF @ProjectCount >= 3 AND (@TotalProjectHours >= 200 OR @OrdersProcessed >= 15 OR @DirectReports >= 1)
        BEGIN
            SET @PerformanceScore = 80;
            SET @ReviewStatus = 'Strong Senior Performance';
            SET @EligibleForBonus = 1;
            SET @RecommendedRaise = 6.0;
            SET @ActionPlan = 'Good senior-level contribution. Explore advanced responsibilities.';
        END
        ELSE IF @ProjectCount >= 1 OR @TotalProjectHours >= 100 OR @OrdersProcessed >= 5
        BEGIN
            SET @PerformanceScore = 65;
            SET @ReviewStatus = 'Adequate Senior Performance';
            SET @RecommendedRaise = 4.0;
            SET @ActionPlan = 'Meeting basic senior expectations. Increase leadership and mentoring involvement.';
        END
        ELSE
        BEGIN
            SET @PerformanceScore = 45;
            SET @ReviewStatus = 'Below Senior Level Expectations';
            SET @RequiresImprovement = 1;
            SET @ActionPlan = 'Significant improvement required. Consider role reassessment or skill development plan.';
        END
    END
    
    -- Additional conditional logic for special circumstances
    IF @CurrentSalary >= 100000
    BEGIN
        -- High BaseSalary employees have different criteria
        IF @PerformanceScore < 70
        BEGIN
            SET @RequiresImprovement = 1;
            SET @ActionPlan = @ActionPlan + ' High compensation requires exceptional performance standards.';
        END
    END
    
    -- Department-specific adjustments
    IF @DepartmentName = 'Sales'
    BEGIN
        IF @OrdersProcessed < 10
        BEGIN
            SET @PerformanceScore = @PerformanceScore * 0.8; -- 20% reduction for low sales activity
            SET @ActionPlan = @ActionPlan + ' Sales d.DepartmentName requires minimum customer engagement levels.';
        END
    END
    ELSE IF @DepartmentName = 'Engineering'
    BEGIN
        IF @ProjectCount < 2
        BEGIN
            SET @PerformanceScore = @PerformanceScore * 0.9; -- 10% reduction for low project involvement
            SET @ActionPlan = @ActionPlan + ' Engineering role requires active project participation.';
        END
    END
    
    -- Final decision logic
    IF @RequiresImprovement = 1
    BEGIN
        SET @RecommendedRaise = 0;
        SET @EligibleForBonus = 0;
        SET @RecommendedPromotion = 0;
    END
    
    -- Auto-approval logic if enabled
    IF @AutoApproveRaises = 1 AND @RecommendedRaise > 0 AND @RecommendedRaise <= 5.0
    BEGIN
        DECLARE @NewSalary DECIMAL(10,2) = @CurrentSalary * (1 + @RecommendedRaise / 100.0);
        
        UPDATE Employees
        SET BaseSalary = @NewSalary
        WHERE EmployeeID = @EmployeeID;
        
        PRINT 'AUTO-APPROVED: BaseSalary increased from ' + FORMAT(@CurrentSalary, 'C') + 
              ' to ' + FORMAT(@NewSalary, 'C') + ' (' + FORMAT(@RecommendedRaise, 'N1') + '% increase)';
    END
    
    -- Display comprehensive review results
    PRINT '';
    PRINT '=== REVIEW RESULTS ===';
    PRINT 'Performance Score: ' + FORMAT(@PerformanceScore, 'N1') + '/100';
    PRINT 'Review Status: ' + @ReviewStatus;
    PRINT 'Projects Completed: ' + CAST(@ProjectCount AS VARCHAR);
    PRINT 'Total Project Hours: ' + FORMAT(@TotalProjectHours, 'N1');
    PRINT 'Orders Processed: ' + CAST(@OrdersProcessed AS VARCHAR);
    PRINT 'Direct Reports: ' + CAST(@DirectReports AS VARCHAR);
    PRINT '';
    PRINT '=== RECOMMENDATIONS ===';
    PRINT 'Eligible for Bonus: ' + CASE WHEN @EligibleForBonus = 1 THEN 'YES' ELSE 'NO' END;
    PRINT 'Recommended Raise: ' + FORMAT(@RecommendedRaise, 'N1') + '%';
    PRINT 'Promotion Recommended: ' + CASE WHEN @RecommendedPromotion = 1 THEN 'YES' ELSE 'NO' END;
    PRINT 'Requires Improvement: ' + CASE WHEN @RequiresImprovement = 1 THEN 'YES' ELSE 'NO' END;
    PRINT '';
    PRINT 'Action Plan: ' + @ActionPlan;
    PRINT '';
    PRINT 'Review completed on: ' + FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss');
    
    RETURN 0; -- Success
END;

-- Test the performance review system
EXEC sp_TechCorp_ProcessPerformanceReview 
    @EmployeeID = 3001, 
    @ReviewPeriodMonths = 12,
    @AutoApproveRaises = 0;

PRINT '';
PRINT '--- Next Employee ---';
PRINT '';

EXEC sp_TechCorp_ProcessPerformanceReview 
    @EmployeeID = 3002, 
    @ReviewPeriodMonths = 6,
    @AutoApproveRaises = 1;
```

## Loop Structures: WHILE Loops

### Iterative Processing with WHILE Loops

#### TechCorp Example: Batch Data Processing System

```sql
-- Demonstrate WHILE loop usage for batch processing
CREATE PROCEDURE sp_TechCorp_ProcessMonthlyBonusCalculation
    @ProcessingYear INT = NULL,
    @DepartmentID INT = NULL,
    @BatchSize INT = 10,
    @MaxProcessingTime INT = 300 -- Maximum seconds to run
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize variables
    SET @ProcessingYear = ISNULL(@ProcessingYear, YEAR(GETDATE()));
    
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @ProcessedCount INT = 0;
    DECLARE @TotalEmployees INT = 0;
    DECLARE @CurrentBatch INT = 1;
    DECLARE @ErrorCount INT = 0;
    DECLARE @SuccessCount INT = 0;
    
    -- Get total number of employees to process
    SELECT @TotalEmployees = COUNT(*)
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID);
    
    PRINT '=== TechCorp Monthly Bonus Processing ===';
    PRINT 'Processing Year: ' + CAST(@ProcessingYear AS VARCHAR);
    PRINT 'Department Filter: ' + ISNULL(CAST(@DepartmentID AS VARCHAR), 'All Departments');
    PRINT 'Batch Size: ' + CAST(@BatchSize AS VARCHAR);
    PRINT 'Total Employees: ' + CAST(@TotalEmployees AS VARCHAR);
    PRINT 'Started at: ' + FORMAT(@StartTime, 'yyyy-MM-dd HH:mm:ss');
    PRINT '';
    
    -- Create temporary table for batch processing
    CREATE TABLE #EmployeeBonusProcessing (
        EmployeeID INT,
        EmployeeName VARCHAR(101),
        BaseSalary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2),
        ProcessingStatus VARCHAR(50),
        ErrorMessage VARCHAR(500),
        ProcessedAt DATETIME
    );
    
    -- Main processing loop
    WHILE @ProcessedCount < @TotalEmployees
    BEGIN
        -- Check if we've exceeded maximum processing time
        IF DATEDIFF(SECOND, @StartTime, GETDATE()) > @MaxProcessingTime
        BEGIN
            PRINT 'WARNING: Maximum processing time exceeded. Stopping batch processing.';
            BREAK;
        END
        
        PRINT 'Processing Batch ' + CAST(@CurrentBatch AS VARCHAR) + '...';
        
        -- Clear temporary table for current batch
        DELETE FROM #EmployeeBonusProcessing;
        
        -- Get current batch of employees
        INSERT INTO #EmployeeBonusProcessing (EmployeeID, EmployeeName, BaseSalary)
        SELECT TOP (@BatchSize)
            e.EmployeeID,
            e.FirstName + ' ' + e.LastName,
            e.BaseSalary
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        WHERE e.IsActive = 1
          AND d.IsActive = 1
          AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
          AND e.EmployeeID NOT IN (
              -- Exclude already processed employees (in real system, would use a status table)
              SELECT TOP (@ProcessedCount) emp.EmployeeID 
              FROM Employees emp 
              INNER JOIN Departments dep ON emp.DepartmentID = dep.DepartmentID
              WHERE emp.IsActive = 1 
                AND dep.IsActive = 1
                AND (@DepartmentID IS NULL OR emp.DepartmentID = @DepartmentID)
              ORDER BY emp.EmployeeID
          )
        ORDER BY e.EmployeeID;
        
        -- Check if we have employees to process in this batch
        DECLARE @CurrentBatchSize INT;
        SELECT @CurrentBatchSize = COUNT(*) FROM #EmployeeBonusProcessing;
        
        IF @CurrentBatchSize = 0
        BEGIN
            PRINT 'No more employees to process. Completing batch processing.';
            BREAK;
        END
        
        -- Process each employee in the current batch
        DECLARE @CurrentEmployeeID INT;
        DECLARE @CurrentEmployeeName VARCHAR(101);
        DECLARE @CurrentBaseSalary DECIMAL(10,2);
        DECLARE @CalculatedBonus DECIMAL(10,2);
        DECLARE @ProcessingError VARCHAR(500);
        
        -- Inner loop to process individual employees
        DECLARE employee_cursor CURSOR FOR
        SELECT EmployeeID, EmployeeName, BaseSalary
        FROM #EmployeeBonusProcessing
        ORDER BY EmployeeID;
        
        OPEN employee_cursor;
        FETCH NEXT FROM employee_cursor INTO @CurrentEmployeeID, @CurrentEmployeeName, @CurrentBaseSalary;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @ProcessingError = NULL;
            SET @CalculatedBonus = 0;
            
            BEGIN TRY
                -- Complex bonus calculation logic
                DECLARE @PerformanceScore DECIMAL(5,2);
                DECLARE @YearsOfService INT;
                DECLARE @ProjectCount INT;
                DECLARE @OrderCount INT;
                DECLARE @BonusMultiplier DECIMAL(4,3) = 1.0;
                
                -- Get employee metrics
                SELECT @YearsOfService = DATEDIFF(YEAR, HireDate, GETDATE())
                FROM Employees
                WHERE EmployeeID = @CurrentEmployeeID;
                
                SELECT @ProjectCount = COUNT(DISTINCT ProjectID)
                FROM EmployeeProjects
                WHERE EmployeeID = @CurrentEmployeeID
                  AND IsActive = 1
                  AND YEAR(StartDate) = @ProcessingYear;
                
                SELECT @OrderCount = COUNT(*)
                FROM Orders
                WHERE EmployeeID = @CurrentEmployeeID
                  AND IsActive = 1
                  AND YEAR(OrderDate) = @ProcessingYear;
                
                -- Calculate performance score (simplified)
                SET @PerformanceScore = 
                    CASE 
                        WHEN @ProjectCount >= 5 THEN 90
                        WHEN @ProjectCount >= 3 THEN 80
                        WHEN @ProjectCount >= 2 THEN 70
                        WHEN @ProjectCount >= 1 THEN 60
                        ELSE 50
                    END +
                    CASE 
                        WHEN @OrderCount >= 20 THEN 10
                        WHEN @OrderCount >= 10 THEN 7
                        WHEN @OrderCount >= 5 THEN 5
                        ELSE 0
                    END;
                
                -- Apply years of service multiplier
                IF @YearsOfService >= 10
                    SET @BonusMultiplier = 1.5;
                ELSE IF @YearsOfService >= 5
                    SET @BonusMultiplier = 1.25;
                ELSE IF @YearsOfService >= 2
                    SET @BonusMultiplier = 1.1;
                
                -- Calculate final bonus
                SET @CalculatedBonus = (@CurrentBaseSalary * 0.1 * (@PerformanceScore / 100.0)) * @BonusMultiplier;
                
                -- Apply business rules
                IF @CalculatedBonus > (@CurrentBaseSalary * 0.3)
                    SET @CalculatedBonus = @CurrentBaseSalary * 0.3; -- Cap at 30% of BaseSalary
                
                IF @CalculatedBonus < 500
                    SET @CalculatedBonus = 500; -- Minimum bonus
                
                -- Update processing status
                UPDATE #EmployeeBonusProcessing
                SET BonusAmount = @CalculatedBonus,
                    ProcessingStatus = 'Success',
                    ProcessedAt = GETDATE()
                WHERE EmployeeID = @CurrentEmployeeID;
                
                SET @SuccessCount = @SuccessCount + 1;
                
            END TRY
            BEGIN CATCH
                SET @ProcessingError = ERROR_MESSAGE();
                
                UPDATE #EmployeeBonusProcessing
                SET ProcessingStatus = 'Error',
                    ErrorMessage = @ProcessingError,
                    ProcessedAt = GETDATE()
                WHERE EmployeeID = @CurrentEmployeeID;
                
                SET @ErrorCount = @ErrorCount + 1;
                
                PRINT 'ERROR processing Employee ID ' + CAST(@CurrentEmployeeID AS VARCHAR) + ': ' + @ProcessingError;
            END CATCH
            
            FETCH NEXT FROM employee_cursor INTO @CurrentEmployeeID, @CurrentEmployeeName, @CurrentBaseSalary;
        END
        
        CLOSE employee_cursor;
        DEALLOCATE employee_cursor;
        
        -- Display batch results
        SELECT 
            EmployeeID,
            EmployeeName,
            FORMAT(BaseSalary, 'C') AS BaseSalary,
            FORMAT(BonusAmount, 'C') AS BonusAmount,
            ProcessingStatus,
            ErrorMessage,
            ProcessedAt
        FROM #EmployeeBonusProcessing
        ORDER BY EmployeeID;
        
        SET @ProcessedCount = @ProcessedCount + @CurrentBatchSize;
        SET @CurrentBatch = @CurrentBatch + 1;
        
        PRINT 'Batch ' + CAST(@CurrentBatch - 1 AS VARCHAR) + ' completed. Processed: ' + 
              CAST(@CurrentBatchSize AS VARCHAR) + ' employees';
        PRINT 'Total Progress: ' + CAST(@ProcessedCount AS VARCHAR) + '/' + CAST(@TotalEmployees AS VARCHAR) + 
              ' (' + FORMAT(CAST(@ProcessedCount AS FLOAT) / @TotalEmployees * 100, 'N1') + '%)';
        PRINT '';
        
        -- Add small delay to prevent overwhelming the system
        WAITFOR DELAY '00:00:01'; -- 1 second delay
    END
    
    -- Final processing summary
    DECLARE @EndTime DATETIME = GETDATE();
    DECLARE @ProcessingDuration INT = DATEDIFF(SECOND, @StartTime, @EndTime);
    
    PRINT '=== PROCESSING SUMMARY ===';
    PRINT 'Total Employees Processed: ' + CAST(@ProcessedCount AS VARCHAR);
    PRINT 'Successful Calculations: ' + CAST(@SuccessCount AS VARCHAR);
    PRINT 'Errors Encountered: ' + CAST(@ErrorCount AS VARCHAR);
    PRINT 'Processing Duration: ' + CAST(@ProcessingDuration AS VARCHAR) + ' seconds';
    PRINT 'Average Time per Employee: ' + FORMAT(CAST(@ProcessingDuration AS FLOAT) / NULLIF(@ProcessedCount, 0), 'N2') + ' seconds';
    PRINT 'Completed at: ' + FORMAT(@EndTime, 'yyyy-MM-dd HH:mm:ss');
    
    -- Summary statistics
    SELECT 
        'BONUS CALCULATION SUMMARY' AS ReportType,
        @ProcessingYear AS ProcessingYear,
        @ProcessedCount AS TotalProcessed,
        @SuccessCount AS SuccessfulCalculations,
        @ErrorCount AS ErrorCount,
        FORMAT(SUM(BonusAmount), 'C') AS TotalBonusAmount,
        FORMAT(AVG(BonusAmount), 'C') AS AverageBonusAmount,
        FORMAT(MIN(BonusAmount), 'C') AS MinimumBonus,
        FORMAT(MAX(BonusAmount), 'C') AS MaximumBonus,
        @ProcessingDuration AS ProcessingTimeSeconds
    FROM #EmployeeBonusProcessing
    WHERE ProcessingStatus = 'Success';
    
    -- Clean up
    DROP TABLE #EmployeeBonusProcessing;
    
    RETURN 0; -- Success
END;

-- Test the batch processing system
EXEC sp_TechCorp_ProcessMonthlyBonusCalculation
    @ProcessingYear = 2024,
    @DepartmentID = 2001, -- Engineering d.DepartmentName only
    @BatchSize = 5,
    @MaxProcessingTime = 60; -- 1 minute max processing time

PRINT '';
PRINT '--- Processing All Departments ---';
PRINT '';

EXEC sp_TechCorp_ProcessMonthlyBonusCalculation
    @ProcessingYear = 2024,
    @BatchSize = 3,
    @MaxProcessingTime = 120; -- 2 minutes max processing time
```

## Branching and Control Transfer

### GOTO, BREAK, CONTINUE, and RETURN Statements

#### TechCorp Example: Complex Data Validation Workflow

```sql
-- Demonstrate branching and control transfer in data validation workflow
CREATE PROCEDURE sp_TechCorp_DataValidationWorkflow
    @ValidationMode VARCHAR(20) = 'FULL', -- 'FULL', 'QUICK', 'CRITICAL'
    @MaxErrors INT = 10,
    @StopOnCriticalError BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize validation variables
    DECLARE @ValidationStep VARCHAR(50);
    DECLARE @ErrorCount INT = 0;
    DECLARE @WarningCount INT = 0;
    DECLARE @RecordsChecked INT = 0;
    DECLARE @ValidationStatus VARCHAR(20) = 'IN_PROGRESS';
    DECLARE @CurrentError VARCHAR(500);
    DECLARE @StepStartTime DATETIME;
    
    PRINT '=== TechCorp Data Validation Workflow ===';
    PRINT 'Validation Mode: ' + @ValidationMode;
    PRINT 'Maximum Errors Allowed: ' + CAST(@MaxErrors AS VARCHAR);
    PRINT 'Stop on Critical Error: ' + CASE WHEN @StopOnCriticalError = 1 THEN 'YES' ELSE 'NO' END;
    PRINT 'Started at: ' + FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss');
    PRINT '';
    
    -- Start validation workflow
    SET @ValidationStep = 'EMPLOYEE_VALIDATION';
    GOTO EMPLOYEE_VALIDATION;
    
EMPLOYEE_VALIDATION:
    SET @StepStartTime = GETDATE();
    PRINT 'Step 1: Employee Data Validation';
    
    BEGIN TRY
        -- Check for duplicate employee emails
        DECLARE @DuplicateEmails INT;
        SELECT @DuplicateEmails = COUNT(*) - COUNT(DISTINCT WorkEmail)
        FROM Employees
        WHERE IsActive = 1 AND WorkEmail IS NOT NULL;
        
        IF @DuplicateEmails > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@DuplicateEmails AS VARCHAR) + ' duplicate email addresses';
            PRINT 'ERROR: ' + @CurrentError;
            SET @ErrorCount = @ErrorCount + 1;
            
            IF @StopOnCriticalError = 1
            BEGIN
                SET @ValidationStatus = 'CRITICAL_ERROR';
                GOTO VALIDATION_COMPLETE;
            END
        END
        
        -- Check for employees without departments
        DECLARE @OrphanEmployees INT;
        SELECT @OrphanEmployees = COUNT(*)
        FROM Employees e
        LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
        WHERE e.IsActive = 1 AND (d.DepartmentID IS NULL OR d.IsActive = 0);
        
        IF @OrphanEmployees > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@OrphanEmployees AS VARCHAR) + ' employees without valid departments';
            PRINT 'ERROR: ' + @CurrentError;
            SET @ErrorCount = @ErrorCount + 1;
        END
        
        -- Check for BaseSalary anomalies
        DECLARE @SalaryAnomalies INT;
        SELECT @SalaryAnomalies = COUNT(*)
        FROM Employees e
        WHERE e.IsActive = 1 
          AND (e.BaseSalary <= 0 
               OR e.BaseSalary > 500000 
               OR e.BaseSalary IS NULL);
        
        IF @SalaryAnomalies > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@SalaryAnomalies AS VARCHAR) + ' BaseSalary anomalies';
            PRINT 'WARNING: ' + @CurrentError;
            SET @WarningCount = @WarningCount + 1;
        END
        
        -- Count validated records
        SELECT @RecordsChecked = @RecordsChecked + COUNT(*)
        FROM Employees
        WHERE IsActive = 1;
        
        PRINT 'Employee validation completed in ' + 
              CAST(DATEDIFF(MILLISECOND, @StepStartTime, GETDATE()) AS VARCHAR) + 'ms';
        
    END TRY
    BEGIN CATCH
        SET @CurrentError = 'Employee validation failed: ' + ERROR_MESSAGE();
        PRINT 'CRITICAL ERROR: ' + @CurrentError;
        SET @ErrorCount = @ErrorCount + 1;
        
        IF @StopOnCriticalError = 1
        BEGIN
            SET @ValidationStatus = 'CRITICAL_ERROR';
            GOTO VALIDATION_COMPLETE;
        END
    END CATCH
    
    -- Check if we should continue based on validation mode
    IF @ValidationMode = 'QUICK'
        GOTO VALIDATION_SUMMARY;
    
    -- Check error threshold
    IF @ErrorCount >= @MaxErrors
    BEGIN
        PRINT 'Maximum error threshold reached. Stopping validation.';
        SET @ValidationStatus = 'ERROR_THRESHOLD_EXCEEDED';
        GOTO VALIDATION_COMPLETE;
    END
    
    -- Continue to next validation step
    SET @ValidationStep = 'DEPARTMENT_VALIDATION';
    GOTO DEPARTMENT_VALIDATION;

DEPARTMENT_VALIDATION:
    SET @StepStartTime = GETDATE();
    PRINT '';
    PRINT 'Step 2: d.DepartmentName Data Validation';
    
    BEGIN TRY
        -- Check for departments without employees
        DECLARE @EmptyDepartments INT;
        SELECT @EmptyDepartments = COUNT(*)
        FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
        WHERE d.IsActive = 1
        GROUP BY d.DepartmentID, d.DepartmentName
        HAVING COUNT(e.EmployeeID) = 0;
        
        IF @EmptyDepartments > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@EmptyDepartments AS VARCHAR) + ' departments without active employees';
            PRINT 'WARNING: ' + @CurrentError;
            SET @WarningCount = @WarningCount + 1;
        END
        
        -- Check budget constraints
        DECLARE @BudgetViolations INT;
        SELECT @BudgetViolations = COUNT(*)
        FROM (
            SELECT 
                d.DepartmentID,
                d.Budget,
                SUM(e.BaseSalary) AS TotalPayroll
            FROM Departments d
            INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
            WHERE d.IsActive = 1 AND e.IsActive = 1
            GROUP BY d.DepartmentID, d.Budget
            HAVING SUM(e.BaseSalary) > d.Budget
        ) budget_check;
        
        IF @BudgetViolations > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@BudgetViolations AS VARCHAR) + ' departments exceeding budget';
            PRINT 'ERROR: ' + @CurrentError;
            SET @ErrorCount = @ErrorCount + 1;
        END
        
        -- Count validated records
        SELECT @RecordsChecked = @RecordsChecked + COUNT(*)
        FROM Departments
        WHERE IsActive = 1;
        
        PRINT 'Department validation completed in ' + 
              CAST(DATEDIFF(MILLISECOND, @StepStartTime, GETDATE()) AS VARCHAR) + 'ms';
        
    END TRY
    BEGIN CATCH
        SET @CurrentError = 'Department validation failed: ' + ERROR_MESSAGE();
        PRINT 'CRITICAL ERROR: ' + @CurrentError;
        SET @ErrorCount = @ErrorCount + 1;
        
        IF @StopOnCriticalError = 1
        BEGIN
            SET @ValidationStatus = 'CRITICAL_ERROR';
            GOTO VALIDATION_COMPLETE;
        END
    END CATCH
    
    -- Check error threshold again
    IF @ErrorCount >= @MaxErrors
    BEGIN
        PRINT 'Maximum error threshold reached. Stopping validation.';
        SET @ValidationStatus = 'ERROR_THRESHOLD_EXCEEDED';
        GOTO VALIDATION_COMPLETE;
    END
    
    -- Continue to project validation only in FULL mode
    IF @ValidationMode != 'FULL'
        GOTO VALIDATION_SUMMARY;
    
    SET @ValidationStep = 'PROJECT_VALIDATION';
    GOTO PROJECT_VALIDATION;

PROJECT_VALIDATION:
    SET @StepStartTime = GETDATE();
    PRINT '';
    PRINT 'Step 3: Project Data Validation';
    
    BEGIN TRY
        -- Check for projects without managers
        DECLARE @UnmanagedProjects INT;
        SELECT @UnmanagedProjects = COUNT(*)
        FROM Projects p
        LEFT JOIN Employees e ON p.ProjectManagerID = e.EmployeeID AND e.IsActive = 1
        WHERE p.IsActive = 1 AND e.EmployeeID IS NULL;
        
        IF @UnmanagedProjects > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@UnmanagedProjects AS VARCHAR) + ' projects without valid managers';
            PRINT 'ERROR: ' + @CurrentError;
            SET @ErrorCount = @ErrorCount + 1;
        END
        
        -- Check for date inconsistencies
        DECLARE @DateInconsistencies INT;
        SELECT @DateInconsistencies = COUNT(*)
        FROM Projects
        WHERE IsActive = 1 
          AND (EndDate < StartDate 
               OR StartDate > GETDATE() + 365 -- Projects starting more than a year in future
               OR EndDate < DATEADD(DAY, -365, GETDATE())); -- Projects ended more than a year ago but still active
        
        IF @DateInconsistencies > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@DateInconsistencies AS VARCHAR) + ' projects with date inconsistencies';
            PRINT 'ERROR: ' + @CurrentError;
            SET @ErrorCount = @ErrorCount + 1;
        END
        
        -- Check for budget anomalies
        DECLARE @ProjectBudgetAnomalies INT;
        SELECT @ProjectBudgetAnomalies = COUNT(*)
        FROM Projects
        WHERE IsActive = 1 
          AND (Budget <= 0 OR Budget > 10000000 OR Budget IS NULL);
        
        IF @ProjectBudgetAnomalies > 0
        BEGIN
            SET @CurrentError = 'Found ' + CAST(@ProjectBudgetAnomalies AS VARCHAR) + ' projects with budget anomalies';
            PRINT 'WARNING: ' + @CurrentError;
            SET @WarningCount = @WarningCount + 1;
        END
        
        -- Count validated records
        SELECT @RecordsChecked = @RecordsChecked + COUNT(*)
        FROM Projects
        WHERE IsActive = 1;
        
        PRINT 'Project validation completed in ' + 
              CAST(DATEDIFF(MILLISECOND, @StepStartTime, GETDATE()) AS VARCHAR) + 'ms';
        
    END TRY
    BEGIN CATCH
        SET @CurrentError = 'Project validation failed: ' + ERROR_MESSAGE();
        PRINT 'CRITICAL ERROR: ' + @CurrentError;
        SET @ErrorCount = @ErrorCount + 1;
        
        IF @StopOnCriticalError = 1
        BEGIN
            SET @ValidationStatus = 'CRITICAL_ERROR';
            GOTO VALIDATION_COMPLETE;
        END
    END CATCH
    
    -- Continue to validation summary
    GOTO VALIDATION_SUMMARY;

VALIDATION_SUMMARY:
    PRINT '';
    PRINT '=== VALIDATION SUMMARY ===';
    
    -- Determine final validation status
    IF @ValidationStatus = 'IN_PROGRESS'
    BEGIN
        IF @ErrorCount = 0 AND @WarningCount = 0
            SET @ValidationStatus = 'PASSED';
        ELSE IF @ErrorCount = 0
            SET @ValidationStatus = 'PASSED_WITH_WARNINGS';
        ELSE IF @ErrorCount < @MaxErrors
            SET @ValidationStatus = 'FAILED_WITH_ERRORS';
        ELSE
            SET @ValidationStatus = 'FAILED_CRITICAL';
    END
    
    PRINT 'Final Status: ' + @ValidationStatus;
    PRINT 'Total Records Checked: ' + CAST(@RecordsChecked AS VARCHAR);
    PRINT 'Errors Found: ' + CAST(@ErrorCount AS VARCHAR);
    PRINT 'Warnings Found: ' + CAST(@WarningCount AS VARCHAR);
    PRINT 'Validation Mode: ' + @ValidationMode;
    
    -- Return appropriate code based on validation status
    IF @ValidationStatus = 'PASSED'
        RETURN 0;
    ELSE IF @ValidationStatus = 'PASSED_WITH_WARNINGS'
        RETURN 1;
    ELSE IF @ValidationStatus LIKE 'FAILED%'
        RETURN -1;
    ELSE
        RETURN -99;

VALIDATION_COMPLETE:
    PRINT '';
    PRINT '=== VALIDATION TERMINATED ===';
    PRINT 'Termination Reason: ' + @ValidationStatus;
    PRINT 'Last Completed Step: ' + @ValidationStep;
    PRINT 'Records Checked Before Termination: ' + CAST(@RecordsChecked AS VARCHAR);
    PRINT 'Errors at Termination: ' + CAST(@ErrorCount AS VARCHAR);
    PRINT 'Warnings at Termination: ' + CAST(@WarningCount AS VARCHAR);
    
    RETURN -99; -- Critical error termination
END;

-- Test the validation workflow with different modes
PRINT 'Testing QUICK validation mode:';
DECLARE @Result INT;
EXEC @Result = sp_TechCorp_DataValidationWorkflow 
    @ValidationMode = 'QUICK',
    @MaxErrors = 5,
    @StopOnCriticalError = 0;
PRINT 'Return Code: ' + CAST(@Result AS VARCHAR);

PRINT '';
PRINT '--- Testing FULL validation mode ---';
PRINT '';

EXEC @Result = sp_TechCorp_DataValidationWorkflow 
    @ValidationMode = 'FULL',
    @MaxErrors = 10,
    @StopOnCriticalError = 1;
PRINT 'Return Code: ' + CAST(@Result AS VARCHAR);

PRINT '';
PRINT '--- Testing CRITICAL validation mode ---';
PRINT '';

EXEC @Result = sp_TechCorp_DataValidationWorkflow 
    @ValidationMode = 'CRITICAL',
    @MaxErrors = 3,
    @StopOnCriticalError = 1;
PRINT 'Return Code: ' + CAST(@Result AS VARCHAR);
```

## Advanced Control Flow Techniques

### Exception Handling with TRY...CATCH

#### TechCorp Example: Comprehensive Error Recovery System

```sql
-- Advanced exception handling for critical business operations
CREATE PROCEDURE sp_TechCorp_CriticalOrderProcessing
    @CustomerID INT,
    @EmployeeID INT,
    @OrderItems NVARCHAR(MAX), -- JSON format: [{"ProductID":1,"Quantity":2,"Price":100.00}]
    @PaymentMethod VARCHAR(50) = 'Credit Card',
    @EnableRetry BIT = 1,
    @MaxRetryAttempts INT = 3
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT OFF; -- We'll handle transactions manually
    
    -- Initialize error handling and retry variables
    DECLARE @AttemptNumber INT = 1;
    DECLARE @ProcessingComplete BIT = 0;
    DECLARE @LastError VARCHAR(MAX) = '';
    DECLARE @OrderID INT = 0;
    DECLARE @TotalOrderAmount DECIMAL(10,2) = 0;
    DECLARE @ProcessingStartTime DATETIME = GETDATE();
    
    -- Validation variables
    DECLARE @CustomerValid BIT = 0;
    DECLARE @EmployeeValid BIT = 0;
    DECLARE @InventoryAvailable BIT = 1;
    
    PRINT '=== TechCorp Critical Order Processing ===';
    PRINT 'Customer ID: ' + CAST(@CustomerID AS VARCHAR);
    PRINT 'Employee ID: ' + CAST(@EmployeeID AS VARCHAR);
    PRINT 'Payment Method: ' + @PaymentMethod;
    PRINT 'Retry Enabled: ' + CASE WHEN @EnableRetry = 1 THEN 'YES' ELSE 'NO' END;
    PRINT 'Max Retry Attempts: ' + CAST(@MaxRetryAttempts AS VARCHAR);
    PRINT '';
    
    -- Main processing loop with retry logic
    WHILE @AttemptNumber <= @MaxRetryAttempts AND @ProcessingComplete = 0
    BEGIN
        PRINT 'Processing Attempt ' + CAST(@AttemptNumber AS VARCHAR) + ' of ' + CAST(@MaxRetryAttempts AS VARCHAR);
        
        BEGIN TRY
            -- Step 1: Validate customer
            PRINT 'Step 1: Customer Validation';
            
            IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID AND IsActive = 1)
            BEGIN
                RAISERROR('Invalid or inactive customer ID: %d', 16, 1, @CustomerID);
            END
            
            SET @CustomerValid = 1;
            PRINT 'Customer validation: PASSED';
            
            -- Step 2: Validate employee
            PRINT 'Step 2: Employee Validation';
            
            IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID AND IsActive = 1)
            BEGIN
                RAISERROR('Invalid or inactive employee ID: %d', 16, 2, @EmployeeID);
            END
            
            SET @EmployeeValid = 1;
            PRINT 'Employee validation: PASSED';
            
            -- Step 3: Parse and validate order items (simplified - in real system would use JSON functions)
            PRINT 'Step 3: Order Items Validation';
            
            -- For demonstration, we'll simulate order total calculation
            -- In real system, would parse JSON and validate inventory
            SET @TotalOrderAmount = 150.00 + (RAND() * 500); -- Simulated order total
            
            IF @TotalOrderAmount <= 0
            BEGIN
                RAISERROR('Invalid order total: %f', 16, 3, @TotalOrderAmount);
            END
            
            IF @TotalOrderAmount > 50000
            BEGIN
                RAISERROR('Order total exceeds maximum limit: %f', 16, 4, @TotalOrderAmount);
            END
            
            PRINT 'Order items validation: PASSED (Total: ' + FORMAT(@TotalOrderAmount, 'C') + ')';
            
            -- Step 4: Begin critical transaction processing
            PRINT 'Step 4: Transaction Processing';
            
            BEGIN TRANSACTION CriticalOrder;
            
            -- Insert main order record
            INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive)
            VALUES (@CustomerID, @EmployeeID, GETDATE(), @TotalOrderAmount, 1);
            
            SET @OrderID = SCOPE_IDENTITY();
            
            IF @OrderID <= 0
            BEGIN
                ROLLBACK TRANSACTION CriticalOrder;
                RAISERROR('Failed to create order record', 16, 5);
            END
            
            PRINT 'Order created with ID: ' + CAST(@OrderID AS VARCHAR);
            
            -- Step 5: Payment processing simulation
            PRINT 'Step 5: Payment Processing';
            
            -- Simulate potential payment failures
            DECLARE @PaymentSuccess BIT = 1;
            DECLARE @RandomFactor FLOAT = RAND();
            
            -- 10% chance of payment failure on first attempt, decreasing with retries
            IF @AttemptNumber = 1 AND @RandomFactor < 0.1
            BEGIN
                SET @PaymentSuccess = 0;
                ROLLBACK TRANSACTION CriticalOrder;
                RAISERROR('Payment processing failed: Insufficient funds or network timeout', 16, 6);
            END
            ELSE IF @AttemptNumber = 2 AND @RandomFactor < 0.05
            BEGIN
                SET @PaymentSuccess = 0;
                ROLLBACK TRANSACTION CriticalOrder;
                RAISERROR('Payment processing failed: Payment gateway error', 16, 7);
            END
            
            PRINT 'Payment processing: SUCCESS';
            
            -- Step 6: Inventory update simulation
            PRINT 'Step 6: Inventory Update';
            
            -- Simulate inventory shortage (rare occurrence)
            IF @AttemptNumber = 1 AND @TotalOrderAmount > 500 AND @RandomFactor > 0.95
            BEGIN
                SET @InventoryAvailable = 0;
                ROLLBACK TRANSACTION CriticalOrder;
                RAISERROR('Inventory shortage detected for order items', 16, 8);
            END
            
            PRINT 'Inventory update: SUCCESS';
            
            -- Step 7: Finalize transaction
            PRINT 'Step 7: Transaction Finalization';
            
            -- Update customer last order date (simulation)
            -- In real system, would update customer statistics, loyalty points, etc.
            
            COMMIT TRANSACTION CriticalOrder;
            
            SET @ProcessingComplete = 1;
            
            PRINT 'Transaction committed successfully';
            PRINT 'Order processing completed on attempt ' + CAST(@AttemptNumber AS VARCHAR);
            
        END TRY
        BEGIN CATCH
            -- Comprehensive error handling
            DECLARE @ErrorNumber INT = ERROR_NUMBER();
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
            DECLARE @ErrorState INT = ERROR_STATE();
            DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
            DECLARE @ErrorLine INT = ERROR_LINE();
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            
            -- Rollback transaction if active
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION CriticalOrder;
            
            -- Format comprehensive error message
            SET @LastError = 'Attempt ' + CAST(@AttemptNumber AS VARCHAR) + ' failed - ' +
                'Error ' + CAST(@ErrorNumber AS VARCHAR) + 
                ' (Severity: ' + CAST(@ErrorSeverity AS VARCHAR) + 
                ', State: ' + CAST(@ErrorState AS VARCHAR) + 
                ', Line: ' + CAST(@ErrorLine AS VARCHAR) + '): ' + @ErrorMessage;
            
            PRINT 'ERROR: ' + @LastError;
            
            -- Determine if error is retryable
            DECLARE @IsRetryableError BIT = 0;
            
            -- Define retryable error conditions
            IF @ErrorNumber IN (2, 53, 121, 1205, 1222) -- Connection, timeout, deadlock errors
                OR @ErrorMessage LIKE '%timeout%'
                OR @ErrorMessage LIKE '%network%'
                OR @ErrorMessage LIKE '%payment%gateway%'
                OR @ErrorMessage LIKE '%inventory%shortage%'
            BEGIN
                SET @IsRetryableError = 1;
            END
            
            -- Decide whether to retry
            IF @EnableRetry = 1 AND @IsRetryableError = 1 AND @AttemptNumber < @MaxRetryAttempts
            BEGIN
                PRINT 'Error is retryable. Preparing for next attempt...';
                
                -- Calculate exponential backoff delay (1, 2, 4 seconds)
                DECLARE @DelaySeconds INT = POWER(2, @AttemptNumber - 1);
                DECLARE @DelayString VARCHAR(8) = '00:00:' + 
                    RIGHT('0' + CAST(@DelaySeconds AS VARCHAR), 2);
                
                PRINT 'Waiting ' + CAST(@DelaySeconds AS VARCHAR) + ' seconds before retry...';
                WAITFOR DELAY @DelayString;
                
                SET @AttemptNumber = @AttemptNumber + 1;
            END
            ELSE
            BEGIN
                -- Non-retryable error or max attempts reached
                IF @AttemptNumber >= @MaxRetryAttempts
                    PRINT 'Maximum retry attempts reached. Order processing failed.';
                ELSE
                    PRINT 'Non-retryable error encountered. Order processing failed.';
                
                -- Break out of retry loop
                BREAK;
            END
        END CATCH
    END
    
    -- Final processing summary
    DECLARE @ProcessingEndTime DATETIME = GETDATE();
    DECLARE @TotalProcessingTime INT = DATEDIFF(MILLISECOND, @ProcessingStartTime, @ProcessingEndTime);
    
    PRINT '';
    PRINT '=== PROCESSING SUMMARY ===';
    PRINT 'Processing Status: ' + CASE WHEN @ProcessingComplete = 1 THEN 'SUCCESS' ELSE 'FAILED' END;
    PRINT 'Total Attempts: ' + CAST(@AttemptNumber AS VARCHAR);
    PRINT 'Processing Time: ' + CAST(@TotalProcessingTime AS VARCHAR) + 'ms';
    
    IF @ProcessingComplete = 1
    BEGIN
        PRINT 'Order ID: ' + CAST(@OrderID AS VARCHAR);
        PRINT 'Order Total: ' + FORMAT(@TotalOrderAmount, 'C');
        PRINT 'Customer ID: ' + CAST(@CustomerID AS VARCHAR);
        PRINT 'Employee ID: ' + CAST(@EmployeeID AS VARCHAR);
        PRINT 'Payment Method: ' + @PaymentMethod;
        
        -- Log successful order (in real system, would write to audit table)
        PRINT 'SUCCESS: Order processed successfully after ' + CAST(@AttemptNumber AS VARCHAR) + ' attempt(s)';
        
        RETURN 0; -- Success
    END
    ELSE
    BEGIN
        PRINT 'Last Error: ' + @LastError;
        
        -- Log failed order attempt (in real system, would write to error log table)
        PRINT 'FAILURE: Order processing failed after ' + CAST(@AttemptNumber AS VARCHAR) + ' attempt(s)';
        
        RETURN -1; -- Failure
    END
END;

-- Test the comprehensive error handling system
DECLARE @Result INT;

-- Test 1: Successful order processing
PRINT 'Test 1: Normal order processing';
EXEC @Result = sp_TechCorp_CriticalOrderProcessing
    @CustomerID = 6001,
    @EmployeeID = 3001,
    @OrderItems = '[{"ProductID":1,"Quantity":2,"Price":75.00}]',
    @PaymentMethod = 'Credit Card',
    @EnableRetry = 1,
    @MaxRetryAttempts = 3;
PRINT 'Result: ' + CAST(@Result AS VARCHAR);

PRINT '';
PRINT '--- Test 2: Invalid customer (should fail immediately) ---';
PRINT '';

EXEC @Result = sp_TechCorp_CriticalOrderProcessing
    @CustomerID = 99999, -- Invalid customer
    @EmployeeID = 3001,
    @OrderItems = '[{"ProductID":1,"Quantity":1,"Price":50.00}]',
    @EnableRetry = 1;
PRINT 'Result: ' + CAST(@Result AS VARCHAR);

PRINT '';
PRINT '--- Test 3: Retry disabled (should fail on first error) ---';
PRINT '';

EXEC @Result = sp_TechCorp_CriticalOrderProcessing
    @CustomerID = 6002,
    @EmployeeID = 3002,
    @OrderItems = '[{"ProductID":2,"Quantity":3,"Price":150.00}]',
    @EnableRetry = 0, -- No retries
    @MaxRetryAttempts = 1;
PRINT 'Result: ' + CAST(@Result AS VARCHAR);
```

## Summary

Controlling program flow in T-SQL enables TechCorp to implement sophisticated business logic and automated decision-making systems:

**Key Control Flow Elements:**

- **IF...ELSE Statements**: Decision making based on business conditions and data validation
- **WHILE Loops**: Iterative processing for batch operations and data transformation
- **Branching Statements**: GOTO, BREAK, CONTINUE, and RETURN for complex workflow control
- **Exception Handling**: TRY...CATCH blocks for robust error management and recovery

**Business Applications:**

- Complex business rule implementation and validation
- Automated performance review and evaluation systems
- Batch data processing and transformation workflows
- Critical transaction processing with retry logic
- Comprehensive error handling and recovery procedures

**Advanced Techniques Demonstrated:**

- Nested conditional logic for multi-criteria decision making
- Iterative batch processing with progress monitoring
- Retry mechanisms with exponential backoff
- Comprehensive error logging and recovery strategies
- Transaction management with rollback capabilities

**Best Practices:**

- Structured error handling with meaningful messages
- Appropriate use of transactions for data consistency
- Performance monitoring and timeout management
- Comprehensive logging for audit trails and debugging
- Graceful degradation and recovery mechanisms

Program flow control enables TechCorp's development teams to create intelligent, resilient database applications that can handle complex business scenarios while maintaining data integrity and providing excellent user experiences through automated decision-making and error recovery capabilities.