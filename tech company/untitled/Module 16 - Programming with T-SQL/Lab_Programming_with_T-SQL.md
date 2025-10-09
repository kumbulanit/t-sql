# Lab: Programming with T-SQL

## Lab Overview

This comprehensive lab provides hands-on practice with T-SQL programming elements and control flow structures in TechCorp's database environment. Students will work through progressive exercises that demonstrate real-world scenarios, from basic variable usage and conditional logic to advanced programming constructs and error handling. The lab emphasizes practical business applications, proper programming techniques, and performance optimization essential for enterprise database development.

## 🏢 TechCorp Business Context

**Lab Scenario: Advanced Database Programming Solutions**

You are part of TechCorp's database development team tasked with implementing sophisticated programming solutions for automated business processes, complex calculations, and intelligent data processing workflows. The lab exercises simulate real-world development scenarios where you'll create advanced T-SQL programs that support critical business operations including employee performance analysis, project management automation, and customer analytics.

### 📋 TechCorp Database Schema

**Available Tables for Lab Exercises:**

```sql
-- Employees table (Sample data: e.EmployeeID starts from 3001)
Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive

-- Departments table (Sample data: d.DepartmentID starts from 2001)
Departments: d.DepartmentID, d.DepartmentName, d.Budget, Location, IsActive

-- Projects table (Sample data: ProjectID starts from 4001)
Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

-- Orders table (Sample data: OrderID starts from 5001)
Orders: OrderID, CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive

-- Customers table (Sample data: CustomerID starts from 6001)
Customers: CustomerID, CompanyName, ContactName, City, Country, WorkEmail, IsActive

-- EmployeeProjects junction table
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive

-- JobLevels table (Supporting data)
JobLevels: JobLevelID, LevelName, MinSalary, MaxSalary, IsActive
```

## Lab Setup and Prerequisites

### Environment Preparation

```sql
-- Lab Setup: Verify database connection and table availability
-- Execute these queries to confirm your environment is ready

-- Check table existence and sample data
SELECT 'Employees' AS TableName, COUNT(*) AS RecordCount FROM Employees e
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments d
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects p
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers;

-- Verify key relationships and data integrity
SELECT d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY d.DepartmentName;
```

---

## 🏋️‍♂️ Exercise 1: T-SQL Variables and Basic Programming Elements

### 🎯 Exercise 1.1: Variable Declaration and Assignment (⭐ BEGINNER)

**Business Scenario:** Create a BaseSalary analysis script using variables to calculate d.DepartmentName statistics.

```sql
-- Challenge: Implement e.BaseSalary analysis using T-SQL variables
-- Declare and initialize variables for calculation parameters

DECLARE @d.DepartmentID INT = 2001;  -- IT d.DepartmentName
DECLARE @TargetYear INT = YEAR(GETDATE());
DECLARE @MinSalaryThreshold DECIMAL(10,2) = 50000.00;
DECLARE @BonusPercentage DECIMAL(5,4) = 0.10;

-- Variable to store calculated results
DECLARE @EmployeeCount INT;
DECLARE @AverageSalary DECIMAL(10,2);
DECLARE @TotalPayroll DECIMAL(15,2);
DECLARE @d.DepartmentName VARCHAR(100);

-- Your Implementation Here:
-- TODO: 1. Get d.DepartmentName name using the @d.DepartmentID variable
-- TODO: 2. Calculate employee count for the d.DepartmentName
-- TODO: 3. Calculate average e.BaseSalary for the d.DepartmentName
-- TODO: 4. Calculate total payroll (including bonus) for the d.DepartmentName
-- TODO: 5. Display results using the variables

-- Sample solution structure:
SELECT @d.DepartmentName = d.DepartmentName FROM Departments d WHERE d.DepartmentID = @d.DepartmentID;

SELECT 
    @EmployeeCount = COUNT(*),
    @AverageSalary = AVG(e.BaseSalary),
    @TotalPayroll = SUM(e.BaseSalary * (1 + @BonusPercentage))
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentID = @d.DepartmentID 
AND IsActive = 1
AND YEAR(e.HireDate) <= @TargetYear;

-- Display results
SELECT @d.DepartmentName AS d.DepartmentName,
    @EmployeeCount AS EmployeeCount,
    @AverageSalary AS AverageBaseSalary,
    @TotalPayroll AS TotalPayrollWithBonus,
    @MinSalaryThreshold AS MinSalaryThreshold,
    CASE 
        WHEN @AverageSalary >= @MinSalaryThreshold THEN 'Above Threshold'
        ELSE 'Below Threshold'
    END AS SalaryStatus;
```

### 🎯 Exercise 1.2: Advanced Data Types and Table Variables (⭐⭐ INTERMEDIATE)

**Business Scenario:** Create an employee performance tracking system using table variables.

```sql
-- Challenge: Use table variables for complex data processing

-- Declare table variable for employee performance metrics
DECLARE @PerformanceMetrics TABLE (
    e.EmployeeID INT,
    EmployeeName VARCHAR(100),
    CurrentSalary DECIMAL(10,2),
    ProjectCount INT,
    TotalHours DECIMAL(8,2),
    PerformanceScore DECIMAL(5,2),
    SalaryRecommendation VARCHAR(50)
);

-- Variables for calculations
DECLARE @CurrentDate DATE = GETDATE();
DECLARE @LastYearDate DATE = DATEADD(YEAR, -1, @CurrentDate);
DECLARE @HighPerformanceThreshold DECIMAL(5,2) = 85.00;
DECLARE @StandardPerformanceThreshold DECIMAL(5,2) = 70.00;

-- Your Implementation Here:
-- TODO: 1. Populate @PerformanceMetrics with employee data
-- TODO: 2. Calculate project count and total hours for each employee
-- TODO: 3. Generate performance scores based on project involvement
-- TODO: 4. Provide e.BaseSalary recommendations based on performance

-- Sample solution structure:
INSERT INTO @PerformanceMetrics (e.EmployeeID, EmployeeName, CurrentSalary, ProjectCount, TotalHours)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName,
    e.BaseSalary,
    COUNT(DISTINCT ep.ProjectID),
    ISNULL(SUM(ep.HoursWorked), 0)
FROM Employees e
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
    AND ep.StartDate >= @LastYearDate
    AND ep.IsActive = 1
WHERE e.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary;

-- Update performance scores and recommendations
UPDATE @PerformanceMetrics
SET PerformanceScore = CASE 
    WHEN ProjectCount >= 3 AND TotalHours >= 500 THEN 90.0
    WHEN ProjectCount >= 2 AND TotalHours >= 300 THEN 80.0
    WHEN ProjectCount >= 1 AND TotalHours >= 200 THEN 70.0
    ELSE 60.0
END;

UPDATE @PerformanceMetrics
SET SalaryRecommendation = CASE 
    WHEN PerformanceScore >= @HighPerformanceThreshold THEN 'Increase 15%'
    WHEN PerformanceScore >= @StandardPerformanceThreshold THEN 'Increase 8%'
    ELSE 'Maintain Current'
END;

-- Display results
SELECT * FROM @PerformanceMetrics
ORDER BY PerformanceScore DESC, EmployeeName;
```

---

## 🏋️‍♂️ Exercise 2: Control Flow Structures

### 🎯 Exercise 2.1: IF...ELSE Conditional Logic (⭐⭐ INTERMEDIATE)

**Business Scenario:** Implement an automated employee review and BaseSalary adjustment system.

```sql
-- Challenge: Create intelligent e.BaseSalary adjustment logic using IF...ELSE

DECLARE @e.EmployeeID INT = 3001;  -- Test with specific employee
DECLARE @CurrentSalary DECIMAL(10,2);
DECLARE @YearsOfService INT;
DECLARE @PerformanceRating VARCHAR(20);
DECLARE @DepartmentBudget DECIMAL(15,2);
DECLARE @NewSalary DECIMAL(10,2);
DECLARE @AdjustmentReason VARCHAR(200);
DECLARE @AdjustmentPercentage DECIMAL(5,4);

-- Your Implementation Here:
-- TODO: 1. Get employee details including e.BaseSalary and hire date
-- TODO: 2. Calculate years of service
-- TODO: 3. Determine performance rating based on project involvement
-- TODO: 4. Check d.DepartmentName budget availability
-- TODO: 5. Apply business rules using IF...ELSE logic
-- TODO: 6. Calculate new e.BaseSalary and adjustment reason

-- Sample solution structure:
SELECT 
    @CurrentSalary = e.BaseSalary,
    @YearsOfService = DATEDIFF(YEAR, e.HireDate, GETDATE())
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE e.EmployeeID = @e.EmployeeID;

-- Determine performance rating
IF EXISTS (SELECT 1 FROM EmployeeProjects WHERE e.EmployeeID = @e.EmployeeID AND HoursWorked > 400)
BEGIN
    SET @PerformanceRating = 'Excellent';
    SET @AdjustmentPercentage = 0.15;  -- 15% increase
END
ELSE IF EXISTS (SELECT 1 FROM EmployeeProjects WHERE e.EmployeeID = @e.EmployeeID AND HoursWorked > 200)
BEGIN
    SET @PerformanceRating = 'Good';
    SET @AdjustmentPercentage = 0.10;  -- 10% increase
END
ELSE IF @YearsOfService >= 3
BEGIN
    SET @PerformanceRating = 'Satisfactory';
    SET @AdjustmentPercentage = 0.05;  -- 5% increase
END
ELSE
BEGIN
    SET @PerformanceRating = 'Developing';
    SET @AdjustmentPercentage = 0.00;  -- No increase
END;

-- Apply additional business rules
IF @YearsOfService >= 5 AND @PerformanceRating IN ('Excellent', 'Good')
BEGIN
    SET @AdjustmentPercentage = @AdjustmentPercentage + 0.03;  -- Additional 3% for tenure
    SET @AdjustmentReason = 'Performance + Tenure Bonus';
END
ELSE IF @PerformanceRating = 'Excellent'
BEGIN
    SET @AdjustmentReason = 'Outstanding Performance';
END
ELSE IF @PerformanceRating = 'Good'
BEGIN
    SET @AdjustmentReason = 'Good Performance';
END
ELSE IF @YearsOfService >= 3
BEGIN
    SET @AdjustmentReason = 'Standard Annual Increase';
END
ELSE
BEGIN
    SET @AdjustmentReason = 'No Adjustment - Developing Employee';
END;

-- Calculate new e.BaseSalary
SET @NewSalary = @CurrentSalary * (1 + @AdjustmentPercentage);

-- Display results
SELECT 
    @e.EmployeeID AS e.EmployeeID,
    @CurrentSalary AS CurrentSalary,
    @YearsOfService AS YearsOfService,
    @PerformanceRating AS PerformanceRating,
    @AdjustmentPercentage AS AdjustmentPercentage,
    @NewSalary AS NewSalary,
    @NewSalary - @CurrentSalary AS SalaryIncrease,
    @AdjustmentReason AS AdjustmentReason;
```

### 🎯 Exercise 2.2: WHILE Loop Processing (⭐⭐⭐ ADVANCED)

**Business Scenario:** Create a batch processing system for employee bonus calculations.

```sql
-- Challenge: Use WHILE loops for iterative batch processing

-- Variables for batch processing
DECLARE @BatchSize INT = 10;
DECLARE @CurrentBatch INT = 1;
DECLARE @TotalEmployees INT;
DECLARE @ProcessedEmployees INT = 0;
DECLARE @MaxBatches INT;
DECLARE @StartEmployeeID INT;
DECLARE @EndEmployeeID INT;

-- Bonus calculation parameters
DECLARE @BonusYear INT = YEAR(GETDATE());
DECLARE @BaseBonusAmount DECIMAL(10,2) = 5000.00;
DECLARE @PerformanceMultiplier DECIMAL(5,2);

-- Create temporary table for results
CREATE TABLE #BonusCalculation (
    BatchNumber INT,
    e.EmployeeID INT,
    EmployeeName VARCHAR(100),
    e.BaseSalary DECIMAL(10,2),
    ProjectCount INT,
    BonusMultiplier DECIMAL(5,2),
    BonusAmount DECIMAL(10,2),
    ProcessingTime DATETIME
);

-- Your Implementation Here:
-- TODO: 1. Calculate total number of employees and batches
-- TODO: 2. Use WHILE loop to process employees in batches
-- TODO: 3. Calculate bonus amounts based on performance metrics
-- TODO: 4. Handle any processing errors within the loop
-- TODO: 5. Track processing progress and timing

-- Sample solution structure:
SELECT @TotalEmployees = COUNT(*) FROM Employees e WHERE IsActive = 1;
SET @MaxBatches = CEILING(CAST(@TotalEmployees AS FLOAT) / @BatchSize);

PRINT 'Starting batch processing...';
PRINT 'Total Employees: ' + CAST(@TotalEmployees AS VARCHAR(10));
PRINT 'Batch Size: ' + CAST(@BatchSize AS VARCHAR(10));
PRINT 'Total Batches: ' + CAST(@MaxBatches AS VARCHAR(10));

WHILE @CurrentBatch <= @MaxBatches
BEGIN
    -- Calculate batch boundaries
    SET @StartEmployeeID = (@CurrentBatch - 1) * @BatchSize + 1;
    SET @EndEmployeeID = @CurrentBatch * @BatchSize;
    
    PRINT 'Processing Batch ' + CAST(@CurrentBatch AS VARCHAR(10)) + ' of ' + CAST(@MaxBatches AS VARCHAR(10));
    
    -- Process current batch
    INSERT INTO #BonusCalculation (BatchNumber, e.EmployeeID, EmployeeName, e.BaseSalary, ProjectCount, BonusMultiplier, BonusAmount, ProcessingTime)
    SELECT 
        @CurrentBatch,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName,
        e.BaseSalary,
        COUNT(DISTINCT ep.ProjectID),
        CASE 
            WHEN COUNT(DISTINCT ep.ProjectID) >= 3 THEN 2.0
            WHEN COUNT(DISTINCT ep.ProjectID) >= 2 THEN 1.5
            WHEN COUNT(DISTINCT ep.ProjectID) >= 1 THEN 1.2
            ELSE 1.0
        END,
        @BaseBonusAmount * CASE 
            WHEN COUNT(DISTINCT ep.ProjectID) >= 3 THEN 2.0
            WHEN COUNT(DISTINCT ep.ProjectID) >= 2 THEN 1.5
            WHEN COUNT(DISTINCT ep.ProjectID) >= 1 THEN 1.2
            ELSE 1.0
        END,
        GETDATE()
    FROM (
        SELECT e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary,
               ROW_NUMBER() OVER (ORDER BY e.EmployeeID) as RowNum
        FROM Employees e 
        WHERE IsActive = 1
    ) e
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
        AND YEAR(ep.StartDate) = @BonusYear
        AND ep.IsActive = 1
    WHERE e.RowNum BETWEEN @StartEmployeeID AND @EndEmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary;
    
    SET @ProcessedEmployees = @ProcessedEmployees + @@ROWCOUNT;
    
    -- Simulate processing delay (remove in production)
    WAITFOR DELAY '00:00:01';
    
    SET @CurrentBatch = @CurrentBatch + 1;
END;

-- Display processing summary
PRINT 'Batch processing completed!';
PRINT 'Total Employees Processed: ' + CAST(@ProcessedEmployees AS VARCHAR(10));

-- Show results
SELECT 
    'Processing Summary' AS ReportType,
    COUNT(*) AS TotalProcessed,
    AVG(BonusAmount) AS AverageBonusAmount,
    SUM(BonusAmount) AS TotalBonusAmount,
    MIN(ProcessingTime) AS StartTime,
    MAX(ProcessingTime) AS EndTime
FROM #BonusCalculation;

-- Show detailed results by batch
SELECT 
    BatchNumber,
    COUNT(*) AS EmployeesInBatch,
    AVG(BonusAmount) AS AverageBonusAmount,
    SUM(BonusAmount) AS BatchTotalBonus
FROM #BonusCalculation
GROUP BY BatchNumber
ORDER BY BatchNumber;

-- Show top performers
SELECT TOP 10
    EmployeeName,
    e.BaseSalary,
    ProjectCount,
    BonusMultiplier,
    BonusAmount
FROM #BonusCalculation
ORDER BY BonusAmount DESC;

-- Cleanup
DROP TABLE #BonusCalculation;
```

---

## 🏋️‍♂️ Exercise 3: Advanced Programming Constructs

### 🎯 Exercise 3.1: User-Defined Functions (⭐⭐⭐ ADVANCED)

**Business Scenario:** Create reusable functions for business calculations.

```sql
-- Challenge: Create scalar and table-valued functions for TechCorp

-- TODO: Create a scalar function to calculate employee performance score
CREATE FUNCTION dbo.fn_CalculatePerformanceScore
(
    @e.EmployeeID INT,
    @EvaluationYear INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Score DECIMAL(5,2) = 0.00;
    DECLARE @ProjectCount INT = 0;
    DECLARE @TotalHours DECIMAL(8,2) = 0.00;
    DECLARE @YearsOfService INT = 0;
    
    -- Your Implementation Here:
    -- TODO: 1. Calculate project involvement for the year
    -- TODO: 2. Calculate total hours worked
    -- TODO: 3. Consider years of service
    -- TODO: 4. Apply scoring algorithm
    
    -- Sample implementation:
    SELECT 
        @ProjectCount = COUNT(DISTINCT ep.ProjectID),
        @TotalHours = ISNULL(SUM(ep.HoursWorked), 0)
    FROM EmployeeProjects ep
    WHERE ep.e.EmployeeID = @e.EmployeeID
        AND YEAR(ep.StartDate) = @EvaluationYear
        AND ep.IsActive = 1;
    
    SELECT @YearsOfService = DATEDIFF(YEAR, e.HireDate, GETDATE())
    FROM Employees e
    WHERE e.EmployeeID = @e.EmployeeID;
    
    -- Calculate base score FROM Projects p and hours
    SET @Score = (@ProjectCount * 20) + (@TotalHours / 10);
    
    -- Add tenure bonus
    IF @YearsOfService >= 5
        SET @Score = @Score + 10;
    ELSE IF @YearsOfService >= 3
        SET @Score = @Score + 5;
    
    -- Cap at 100
    IF @Score > 100
        SET @Score = 100;
    
    RETURN @Score;
END;

-- TODO: Create a table-valued function for d.DepartmentName analytics
CREATE FUNCTION dbo.fn_GetDepartmentAnalytics
(
    @d.DepartmentID INT,
    @AnalysisYear INT
)
RETURNS TABLE
AS
RETURN
(
    -- Your Implementation Here:
    -- TODO: Return comprehensive d.DepartmentName analytics
    
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.BaseSalary,
        e.JobTitle,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
        ISNULL(SUM(ep.HoursWorked), 0) AS TotalHours,
        dbo.fn_CalculatePerformanceScore(e.EmployeeID, @AnalysisYear) AS PerformanceScore,
        CASE 
            WHEN dbo.fn_CalculatePerformanceScore(e.EmployeeID, @AnalysisYear) >= 85 THEN 'Excellent'
            WHEN dbo.fn_CalculatePerformanceScore(e.EmployeeID, @AnalysisYear) >= 70 THEN 'Good'
            WHEN dbo.fn_CalculatePerformanceScore(e.EmployeeID, @AnalysisYear) >= 60 THEN 'Satisfactory'
            ELSE 'Needs Improvement'
        END AS PerformanceRating
    FROM Employees e
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
        AND YEAR(ep.StartDate) = @AnalysisYear
        AND ep.IsActive = 1
    WHERE e.d.DepartmentID = @d.DepartmentID
        AND e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, e.JobTitle, e.HireDate
);

-- Test the functions
SELECT * FROM dbo.fn_GetDepartmentAnalytics(2001, 2024);

-- Calculate average performance by d.DepartmentName
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(da.PerformanceScore) AS AveragePerformanceScore,
    AVG(da.e.BaseSalary) AS AverageBaseSalary
FROM Departments d
CROSS APPLY dbo.fn_GetDepartmentAnalytics(d.DepartmentID, 2024) da
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AveragePerformanceScore DESC;
```

### 🎯 Exercise 3.2: Comprehensive Error Handling (⭐⭐⭐ ADVANCED)

**Business Scenario:** Implement robust error handling for critical business processes.

```sql
-- Challenge: Create a comprehensive error handling system

-- Create error log table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog')
BEGIN
    CREATE TABLE ErrorLog (
        ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
        ErrorNumber INT,
        ErrorSeverity INT,
        ErrorState INT,
        ErrorProcedure NVARCHAR(128),
        ErrorLine INT,
        ErrorMessage NVARCHAR(4000),
        ErrorDateTime DATETIME DEFAULT GETDATE(),
        UserName NVARCHAR(128) DEFAULT SYSTEM_USER,
        AdditionalInfo NVARCHAR(MAX)
    );
END;

-- Create comprehensive stored procedure with error handling
CREATE OR ALTER PROCEDURE sp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID INT,
    @NewSalary DECIMAL(10,2),
    @UpdateReason NVARCHAR(200) = 'e.BaseSalary Adjustment',
    @EffectiveDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare variables
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @d.DepartmentID INT;
    DECLARE @JobLevelID INT;
    DECLARE @MaxSalaryForLevel DECIMAL(10,2);
    DECLARE @SalaryIncreasePercent DECIMAL(5,2);
    DECLARE @ReturnCode INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);
    
    -- Set default effective date
    SET @EffectiveDate = ISNULL(@EffectiveDate, GETDATE());
    
    BEGIN TRY
        -- Start transaction
        BEGIN TRANSACTION;
        
        -- Your Implementation Here:
        -- TODO: 1. Validate input parameters
        -- TODO: 2. Check employee exists and get current details
        -- TODO: 3. Validate e.BaseSalary against job level constraints
        -- TODO: 4. Check for reasonable e.BaseSalary increase limits
        -- TODO: 5. Update e.BaseSalary with proper audit trail
        -- TODO: 6. Log the transaction
        
        -- Input validation
        IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 3000
        BEGIN
            SET @ErrorMessage = 'Invalid Employee ID provided';
            RAISERROR(@ErrorMessage, 16, 1);
        END;
        
        IF @NewSalary IS NULL OR @NewSalary <= 0
        BEGIN
            SET @ErrorMessage = 'Invalid e.BaseSalary amount provided';
            RAISERROR(@ErrorMessage, 16, 1);
        END;
        
        -- Check if employee exists
        SELECT 
            @CurrentSalary = e.BaseSalary,
            @d.DepartmentID = d.DepartmentID,
            @JobLevelID = JobLevelID
        FROM Employees e 
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        IF @CurrentSalary IS NULL
        BEGIN
            SET @ErrorMessage = 'Employee not found or inactive: ' + CAST(@e.EmployeeID AS VARCHAR(10));
            RAISERROR(@ErrorMessage, 16, 1);
        END;
        
        -- Get job level constraints
        SELECT @MaxSalaryForLevel = MaxSalary
        FROM JobLevels
        WHERE JobLevelID = @JobLevelID AND IsActive = 1;
        
        -- Validate e.BaseSalary against job level
        IF @NewSalary > @MaxSalaryForLevel
        BEGIN
            SET @ErrorMessage = 'New e.BaseSalary exceeds maximum for job level. Max allowed: ' + 
                               CAST(@MaxSalaryForLevel AS VARCHAR(20));
            RAISERROR(@ErrorMessage, 16, 1);
        END;
        
        -- Calculate e.BaseSalary increase percentage
        SET @SalaryIncreasePercent = ((@NewSalary - @CurrentSalary) / @CurrentSalary) * 100;
        
        -- Check for excessive increases (more than 50%)
        IF @SalaryIncreasePercent > 50
        BEGIN
            SET @ErrorMessage = 'e.BaseSalary increase of ' + 
                               CAST(@SalaryIncreasePercent AS VARCHAR(10)) + 
                               '% exceeds maximum allowed increase of 50%';
            RAISERROR(@ErrorMessage, 16, 1);
        END;
        
        -- Update employee e.BaseSalary
        UPDATE Employees
        SET e.BaseSalary = @NewSalary,
            ModifiedDate = GETDATE()
        WHERE e.EmployeeID = @e.EmployeeID;
        
        -- Log the successful update
        INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, 
                             ErrorMessage, AdditionalInfo)
        VALUES (0, 0, 0, 'sp_ProcessEmployeeSalaryUpdate', 
                'e.BaseSalary update successful',
                'e.EmployeeID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) + 
                ', Old e.BaseSalary: ' + CAST(@CurrentSalary AS VARCHAR(20)) +
                ', New e.BaseSalary: ' + CAST(@NewSalary AS VARCHAR(20)) +
                ', Reason: ' + @UpdateReason);
        
        -- Commit transaction
        COMMIT TRANSACTION;
        
        -- Return success message
        SELECT 
            @e.EmployeeID AS e.EmployeeID,
            @CurrentSalary AS PreviousSalary,
            @NewSalary AS NewSalary,
            @SalaryIncreasePercent AS IncreasePercent,
            'SUCCESS' AS Status,
            'e.BaseSalary updated successfully' AS Message;
            
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Log error details
        INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, 
                             ErrorLine, ErrorMessage, AdditionalInfo)
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(),
                ERROR_LINE(), ERROR_MESSAGE(),
                'e.EmployeeID: ' + CAST(@e.EmployeeID AS VARCHAR(10)) + 
                ', New e.BaseSalary: ' + CAST(@NewSalary AS VARCHAR(20)) +
                ', Reason: ' + @UpdateReason);
        
        -- Return error information
        SELECT 
            @e.EmployeeID AS e.EmployeeID,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_MESSAGE() AS ErrorMessage,
            'ERROR' AS Status;
        
        -- Re-raise the error
        THROW;
    END CATCH;
END;

-- Test the error handling procedure
PRINT 'Testing error handling scenarios...';

-- Test 1: Valid e.BaseSalary update
EXEC sp_ProcessEmployeeSalaryUpdate 
    @e.EmployeeID = 3001,
    @NewSalary = 75000,
    @UpdateReason = 'Performance Review';

-- Test 2: Invalid employee ID
BEGIN TRY
    EXEC sp_ProcessEmployeeSalaryUpdate 
        @e.EmployeeID = 99999,
        @NewSalary = 75000;
END TRY
BEGIN CATCH
    PRINT 'Caught expected error for invalid employee ID';
    SELECT ERROR_MESSAGE() AS CaughtError;
END CATCH;

-- Test 3: Excessive e.BaseSalary increase
BEGIN TRY
    EXEC sp_ProcessEmployeeSalaryUpdate 
        @e.EmployeeID = 3002,
        @NewSalary = 200000;  -- Assuming this is excessive
END TRY
BEGIN CATCH
    PRINT 'Caught expected error for excessive e.BaseSalary increase';
    SELECT ERROR_MESSAGE() AS CaughtError;
END CATCH;

-- View error log
SELECT TOP 10 * FROM ErrorLog ORDER BY ErrorDateTime DESC;
```

---

## 🏋️‍♂️ Exercise 4: Master Integration Challenge

### 🎯 Exercise 4.1: Complete Programming Solution (🔴 EXPERT LEVEL)

**Business Scenario:** Create a comprehensive employee management system combining all programming elements.

```sql
-- Challenge: Build a complete automated employee management system

-- Create comprehensive management procedure
CREATE OR ALTER PROCEDURE sp_TechCorp_EmployeeManagementSystem
    @Action VARCHAR(20),  -- 'ANALYZE', 'UPDATE_SALARIES', 'GENERATE_REPORTS'
    @d.DepartmentID INT = NULL,
    @PerformanceYear INT = NULL,
    @ExecutionMode VARCHAR(20) = 'PREVIEW'  -- 'PREVIEW' or 'EXECUTE'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare comprehensive variable set
    DECLARE @TotalEmployees INT;
    DECLARE @ProcessedCount INT = 0;
    DECLARE @ErrorCount INT = 0;
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @CurrentEmployee INT;
    DECLARE @BatchResults TABLE (
        e.EmployeeID INT,
        ActionTaken VARCHAR(100),
        OldValue DECIMAL(10,2),
        NewValue DECIMAL(10,2),
        Status VARCHAR(20),
        Timestamp DATETIME
    );
    
    BEGIN TRY
        -- Set defaults
        SET @PerformanceYear = ISNULL(@PerformanceYear, YEAR(GETDATE()));
        
        -- Main processing logic based on action
        IF @Action = 'ANALYZE'
        BEGIN
            -- Comprehensive analysis using all programming elements
            PRINT 'Starting comprehensive employee analysis...';
            
            -- Use cursor for detailed employee processing
            DECLARE employee_cursor CURSOR FOR
            SELECT e.EmployeeID 
            FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
            WHERE (@d.DepartmentID IS NULL OR d.DepartmentID = @d.DepartmentID)
            AND IsActive = 1;
            
            OPEN employee_cursor;
            FETCH NEXT FROM employee_cursor INTO @CurrentEmployee;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Analyze each employee using functions and complex logic
                DECLARE @PerfScore DECIMAL(5,2);
                DECLARE @SalaryRecommendation DECIMAL(10,2);
                DECLARE @CurrentSalary DECIMAL(10,2);
                
                -- Get performance score using user-defined function
                SET @PerfScore = dbo.fn_CalculatePerformanceScore(@CurrentEmployee, @PerformanceYear);
                
                -- Get current e.BaseSalary
                SELECT @CurrentSalary = e.BaseSalary FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.EmployeeID = @CurrentEmployee;
                
                -- Calculate e.BaseSalary recommendation using complex business logic
                IF @PerfScore >= 90
                    SET @SalaryRecommendation = @CurrentSalary * 1.15;  -- 15% increase
                ELSE IF @PerfScore >= 80
                    SET @SalaryRecommendation = @CurrentSalary * 1.10;  -- 10% increase
                ELSE IF @PerfScore >= 70
                    SET @SalaryRecommendation = @CurrentSalary * 1.05;  -- 5% increase
                ELSE
                    SET @SalaryRecommendation = @CurrentSalary;  -- No increase
                
                -- Store results
                INSERT INTO @BatchResults 
                VALUES (@CurrentEmployee, 'SALARY_ANALYSIS', @CurrentSalary, @SalaryRecommendation, 'ANALYZED', GETDATE());
                
                SET @ProcessedCount = @ProcessedCount + 1;
                
                FETCH NEXT FROM employee_cursor INTO @CurrentEmployee;
            END;
            
            CLOSE employee_cursor;
            DEALLOCATE employee_cursor;
        END
        ELSE IF @Action = 'UPDATE_SALARIES'
        BEGIN
            -- Batch e.BaseSalary updates with comprehensive error handling
            PRINT 'Starting batch e.BaseSalary updates...';
            
            IF @ExecutionMode = 'EXECUTE'
            BEGIN
                -- Process e.BaseSalary updates
                DECLARE @UpdateEmployee INT;
                DECLARE @NewSalary DECIMAL(10,2);
                
                DECLARE salary_cursor CURSOR FOR
                SELECT e.EmployeeID, NewValue 
                FROM @BatchResults 
                WHERE ActionTaken = 'SALARY_ANALYSIS' 
                AND NewValue > OldValue;  -- Only process increases
                
                OPEN salary_cursor;
                FETCH NEXT FROM salary_cursor INTO @UpdateEmployee, @NewSalary;
                
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    BEGIN TRY
                        -- Use error handling procedure
                        EXEC sp_ProcessEmployeeSalaryUpdate 
                            @e.EmployeeID = @UpdateEmployee,
                            @NewSalary = @NewSalary,
                            @UpdateReason = 'Automated Performance Review';
                        
                        SET @ProcessedCount = @ProcessedCount + 1;
                    END TRY
                    BEGIN CATCH
                        SET @ErrorCount = @ErrorCount + 1;
                        PRINT 'Error updating Employee ' + CAST(@UpdateEmployee AS VARCHAR(10)) + ': ' + ERROR_MESSAGE();
                    END CATCH;
                    
                    FETCH NEXT FROM salary_cursor INTO @UpdateEmployee, @NewSalary;
                END;
                
                CLOSE salary_cursor;
                DEALLOCATE salary_cursor;
            END
            ELSE
            BEGIN
                PRINT 'PREVIEW MODE - No actual updates performed';
                SELECT * FROM @BatchResults WHERE NewValue > OldValue;
            END;
        END
        ELSE IF @Action = 'GENERATE_REPORTS'
        BEGIN
            -- Generate comprehensive reports using table-valued functions
            PRINT 'Generating comprehensive management reports...';
            
            -- d.DepartmentName summary report
            SELECT d.DepartmentName,
                COUNT(da.e.EmployeeID) AS EmployeeCount,
                AVG(da.PerformanceScore) AS AvgPerformanceScore,
                AVG(da.e.BaseSalary) AS AvgSalary,
                SUM(CASE WHEN da.PerformanceRating = 'Excellent' THEN 1 ELSE 0 END) AS ExcellentPerformers,
                SUM(CASE WHEN da.PerformanceRating = 'Needs Improvement' THEN 1 ELSE 0 END) AS NeedsImprovement
            FROM Departments d
            CROSS APPLY dbo.fn_GetDepartmentAnalytics(d.DepartmentID, @PerformanceYear) da
            WHERE d.IsActive = 1
            AND (@d.DepartmentID IS NULL OR d.DepartmentID = @d.DepartmentID)
            GROUP BY d.DepartmentID, d.DepartmentName
            ORDER BY AvgPerformanceScore DESC;
        END
        ELSE
        BEGIN
            RAISERROR('Invalid action specified. Valid actions are: ANALYZE, UPDATE_SALARIES, GENERATE_REPORTS', 16, 1);
        END;
        
        -- Final summary
        DECLARE @EndTime DATETIME = GETDATE();
        DECLARE @ExecutionTimeSeconds INT = DATEDIFF(SECOND, @StartTime, @EndTime);
        
        PRINT 'Execution Summary:';
        PRINT 'Action: ' + @Action;
        PRINT 'Processed: ' + CAST(@ProcessedCount AS VARCHAR(10)) + ' employees';
        PRINT 'Errors: ' + CAST(@ErrorCount AS VARCHAR(10));
        PRINT 'Execution Time: ' + CAST(@ExecutionTimeSeconds AS VARCHAR(10)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        -- Comprehensive error handling
        PRINT 'Critical error in employee management system:';
        PRINT 'Error: ' + ERROR_MESSAGE();
        PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
        
        -- Log error
        INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, 
                             ErrorLine, ErrorMessage, AdditionalInfo)
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'sp_TechCorp_EmployeeManagementSystem',
                ERROR_LINE(), ERROR_MESSAGE(),
                'Action: ' + @Action + ', d.DepartmentID: ' + CAST(ISNULL(@d.DepartmentID, 0) AS VARCHAR(10)));
        
        THROW;
    END CATCH;
END;

-- Test the complete system
PRINT '=== Testing Complete Employee Management System ===';

-- Test 1: Analyze all employees
EXEC sp_TechCorp_EmployeeManagementSystem 
    @Action = 'ANALYZE',
    @PerformanceYear = 2024;

-- Test 2: Generate reports for specific d.DepartmentName
EXEC sp_TechCorp_EmployeeManagementSystem 
    @Action = 'GENERATE_REPORTS',
    @d.DepartmentID = 2001,
    @PerformanceYear = 2024;

-- Test 3: Preview e.BaseSalary updates
EXEC sp_TechCorp_EmployeeManagementSystem 
    @Action = 'UPDATE_SALARIES',
    @ExecutionMode = 'PREVIEW',
    @PerformanceYear = 2024;
```

---

## 📊 Lab Summary and Validation

### Achievement Checklist

**T-SQL Programming Elements Mastery:**
- ✅ Variable declaration and assignment techniques
- ✅ Advanced data types and table variables
- ✅ Complex conditional logic with IF..ELSE
- ✅ Iterative processing with WHILE loops
- ✅ User-defined scalar and table-valued functions
- ✅ Comprehensive error handling with TRY..CATCH
- ✅ Advanced programming constructs integration

**Business Application Skills:**
- ✅ Employee performance analysis systems
- ✅ Batch processing and automation
- ✅ BaseSalary calculation and adjustment algorithms
- ✅ Error logging and audit trail implementation
- ✅ Comprehensive business logic implementation

### Performance Validation

```sql
-- Validate your implementations with these comprehensive tests

-- Test 1: Variable Usage Validation
DECLARE @TestResults TABLE (TestName VARCHAR(100), Status VARCHAR(20), Details VARCHAR(200));

-- Test variable declarations and assignments
BEGIN TRY
    DECLARE @TestVar1 INT = 100;
    DECLARE @TestVar2 DECIMAL(10,2);
    SET @TestVar2 = 250.75;
    
    INSERT INTO @TestResults VALUES ('Variable Declaration', 'PASSED', 'Basic variable operations successful');
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES ('Variable Declaration', 'FAILED', ERROR_MESSAGE());
END CATCH;

-- Test 2: Control Flow Validation
BEGIN TRY
    DECLARE @Counter INT = 1;
    DECLARE @Total INT = 0;
    
    WHILE @Counter <= 5
    BEGIN
        SET @Total = @Total + @Counter;
        SET @Counter = @Counter + 1;
    END;
    
    IF @Total = 15  -- 1+2+3+4+5 = 15
        INSERT INTO @TestResults VALUES ('Control Flow', 'PASSED', 'WHILE loop and IF logic working correctly');
    ELSE
        INSERT INTO @TestResults VALUES ('Control Flow', 'FAILED', 'Incorrect calculation result');
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES ('Control Flow', 'FAILED', ERROR_MESSAGE());
END CATCH;

-- Test 3: Function Validation
BEGIN TRY
    DECLARE @FunctionResult DECIMAL(5,2);
    SET @FunctionResult = dbo.fn_CalculatePerformanceScore(3001, 2024);
    
    IF @FunctionResult IS NOT NULL AND @FunctionResult >= 0 AND @FunctionResult <= 100
        INSERT INTO @TestResults VALUES ('User Functions', 'PASSED', 'Function returns valid performance score');
    ELSE
        INSERT INTO @TestResults VALUES ('User Functions', 'FAILED', 'Function returned invalid result');
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES ('User Functions', 'FAILED', ERROR_MESSAGE());
END CATCH;

-- Test 4: Error Handling Validation
BEGIN TRY
    -- Intentionally cause an error to test TRY..CATCH
    DECLARE @BadResult INT = 1/0;  -- Division by zero
    INSERT INTO @TestResults VALUES ('Error Handling', 'FAILED', 'Should have caught division by zero');
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES ('Error Handling', 'PASSED', 'Successfully caught error: ' + ERROR_MESSAGE());
END CATCH;

-- Display validation results
SELECT * FROM @TestResults;

-- Overall lab completion status
SELECT 
    COUNT(*) AS TotalTests,
    SUM(CASE WHEN IsActive = 'PASSED' THEN 1 ELSE 0 END) AS PassedTests,
    SUM(CASE WHEN IsActive = 'FAILED' THEN 1 ELSE 0 END) AS FailedTests,
    CASE 
        WHEN SUM(CASE WHEN IsActive = 'PASSED' THEN 1 ELSE 0 END) = COUNT(*) THEN 'LAB COMPLETED SUCCESSFULLY'
        ELSE 'SOME TESTS FAILED - REVIEW IMPLEMENTATION'
    END AS OverallStatus
FROM @TestResults;
```

---

## 🎯 Next Steps and Advanced Challenges

### Extended Learning Opportunities

1. **Dynamic SQL Programming**: Implement dynamic query generation
2. **Recursive Programming**: Create hierarchical data processing solutions
3. **Performance Optimization**: Optimize T-SQL programs for large datasets
4. **Advanced Error Recovery**: Implement retry logic and circuit breaker patterns
5. **Logging and Monitoring**: Create comprehensive audit and monitoring systems

### Integration with Real-World Scenarios

- **ETL Processing**: Batch data transformation workflows
- **Business Rule Engines**: Complex validation and decision systems
- **Automated Reporting**: Scheduled report generation systems
- **Data Quality Management**: Automated data cleansing and validation
- **Performance Monitoring**: Database health and performance tracking

**🎉 Congratulations!** You have successfully completed the comprehensive T-SQL Programming Lab, demonstrating mastery of advanced programming elements and control flow structures essential for enterprise database development.