# Lab: Executing Stored Procedures

## Lab Overview

This comprehensive lab provides hands-on practice with executing, creating, and managing stored procedures in TechCorp's database environment. Students will work through progressive exercises that demonstrate real-world scenarios, from basic procedure execution to advanced dynamic SQL implementation. The lab emphasizes practical business applications, proper parameter handling, error management, and performance optimization techniques essential for enterprise database development.

## 🏢 TechCorp Business Context

**Lab Scenario: Database Application Development**

You are part of TechCorp's database development team tasked with implementing a comprehensive stored procedure system for employee management, customer relationship management, and business analytics. The lab exercises simulate real-world development scenarios where you'll create, test, and optimize stored procedures that support critical business operations.

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
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'EmployeeProjects', COUNT(*) FROM EmployeeProjects;

-- Verify sample data ranges
SELECT 
    MIN(e.EmployeeID) AS MinEmployeeID,
    MAX(e.EmployeeID) AS MaxEmployeeID,
    COUNT(DISTINCT d.DepartmentID) AS DepartmentCount,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) AS ActiveEmployees
FROM Employees e;

-- Check for any existing stored procedures (optional cleanup)
SELECT 
    ROUTINE_NAME AS ProcedureName,
    CREATED AS CreatedDate,
    LAST_ALTERED AS LastModified
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_NAME LIKE 'sp_Lab%'
ORDER BY ROUTINE_NAME;
```

## Exercise 1: Basic Stored Procedure Execution

### Objective

Master the fundamentals of executing stored procedures with various parameter combinations and understand return codes and output parameters.

### Exercise 1.1: Execute Simple Information Retrieval Procedures

**Task:** Create and execute basic employee information retrieval procedures.

```sql
-- Step 1: Create a simple employee lookup procedure
CREATE PROCEDURE sp_Lab_GetEmployeeInfo
    @e.EmployeeID INT,
    @IncludeManager BIT = 1,
    @RecordCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize output parameter
    SET @RecordCount = 0;
    
    -- Validate input
    IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 0
    BEGIN
        RAISERROR('Employee ID must be a positive integer.', 16, 1);
        RETURN -1;
    END
    
    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1)
    BEGIN
        RAISERROR('Employee ID %d not found or inactive.', 16, 1, @e.EmployeeID);
        RETURN -2;
    END
    
    -- Main query
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C') AS e.BaseSalary,
        d.DepartmentName,
        d.Location,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        -- Manager information (conditional)
        CASE 
            WHEN @IncludeManager = 1 AND e.ManagerID IS NOT NULL
            THEN mgr.e.FirstName + ' ' + mgr.e.LastName
            WHEN @IncludeManager = 1 
            THEN 'No Manager Assigned'
            ELSE 'Manager Info Not Requested'
        END AS ManagerName
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.e.EmployeeID AND @IncludeManager = 1
    WHERE e.EmployeeID = @e.EmployeeID;
    
    -- Set output parameter
    SET @RecordCount = 1;
    
    RETURN 0; -- Success
END;

-- Step 2: Execute the procedure with different parameter combinations
-- Test 1: Basic execution with valid employee ID
DECLARE @ReturnValue INT, @Count INT;
EXEC @ReturnValue = sp_Lab_GetEmployeeInfo 
    @e.EmployeeID = 3001, 
    @RecordCount = @Count OUTPUT;

SELECT @ReturnValue AS ReturnCode, @Count AS RecordsReturned;

-- Test 2: Execute without manager information
EXEC sp_Lab_GetEmployeeInfo 
    @e.EmployeeID = 3002, 
    @IncludeManager = 0,
    @RecordCount = @Count OUTPUT;

-- Test 3: Test error handling with invalid employee ID
EXEC @ReturnValue = sp_Lab_GetEmployeeInfo 
    @e.EmployeeID = 99999, 
    @RecordCount = @Count OUTPUT;

SELECT @ReturnValue AS ErrorReturnCode;
```

### Exercise 1.2: d.DepartmentName Summary Procedure

**Task:** Create and execute a procedure that returns d.DepartmentName statistics with configurable options.

```sql
-- Step 1: Create d.DepartmentName summary procedure
CREATE PROCEDURE sp_Lab_GetDepartmentSummary
    @d.DepartmentID INT = NULL,
    @IncludeInactiveEmployees BIT = 0,
    @SalaryThreshold DECIMAL(10,2) = 0,
    @EmployeeCount INT OUTPUT,
    @TotalPayroll DECIMAL(12,2) OUTPUT,
    @AverageSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize output parameters
    SET @EmployeeCount = 0;
    SET @TotalPayroll = 0;
    SET @AverageSalary = 0;
    
    -- Validate d.DepartmentName if specified
    IF @d.DepartmentID IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1
    )
    BEGIN
        RAISERROR('Department ID %d not found or inactive.', 16, 1, @d.DepartmentID);
        RETURN -1;
    END
    
    -- Main summary query
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Location,
        FORMAT(d.Budget, 'C') AS DepartmentBudget,
        COUNT(e.EmployeeID) AS TotalEmployees,
        SUM(CASE WHEN e.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveEmployees,
        SUM(CASE WHEN e.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveEmployees,
        FORMAT(SUM(CASE WHEN e.IsActive = 1 OR @IncludeInactiveEmployees = 1 
                        THEN e.BaseSalary ELSE 0 END), 'C') AS TotalPayroll,
        FORMAT(AVG(CASE WHEN (e.IsActive = 1 OR @IncludeInactiveEmployees = 1) 
                             AND e.BaseSalary >= @SalaryThreshold
                        THEN e.BaseSalary ELSE NULL END), 'C') AS AverageQualifyingSalary,
        COUNT(CASE WHEN e.BaseSalary >= @SalaryThreshold AND 
                         (e.IsActive = 1 OR @IncludeInactiveEmployees = 1)
                   THEN 1 END) AS EmployeesAboveThreshold
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
    WHERE (@d.DepartmentID IS NULL OR d.DepartmentID = @d.DepartmentID)
      AND d.IsActive = 1
      AND (e.EmployeeID IS NULL OR e.IsActive = 1 OR @IncludeInactiveEmployees = 1)
    GROUP BY d.DepartmentID, d.DepartmentName, d.Location, d.Budget
    ORDER BY d.DepartmentName;
    
    -- Calculate output parameters for first/specified d.DepartmentName
    SELECT 
        @EmployeeCount = COUNT(e.EmployeeID),
        @TotalPayroll = SUM(CASE WHEN e.IsActive = 1 OR @IncludeInactiveEmployees = 1 
                                THEN e.BaseSalary ELSE 0 END),
        @AverageSalary = AVG(CASE WHEN (e.IsActive = 1 OR @IncludeInactiveEmployees = 1) 
                                      AND e.BaseSalary >= @SalaryThreshold
                                  THEN e.BaseSalary ELSE NULL END)
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE (@d.DepartmentID IS NULL OR e.d.DepartmentID = @d.DepartmentID)
      AND d.IsActive = 1
      AND (e.IsActive = 1 OR @IncludeInactiveEmployees = 1);
    
    RETURN 0; -- Success
END;

-- Step 2: Execute with different parameter combinations
-- Test 1: Get all departments summary
DECLARE @EmpCount INT, @Payroll DECIMAL(12,2), @AvgSalary DECIMAL(10,2);

EXEC sp_Lab_GetDepartmentSummary 
    @EmployeeCount = @EmpCount OUTPUT,
    @TotalPayroll = @Payroll OUTPUT,
    @AverageSalary = @AvgSalary OUTPUT;

SELECT @EmpCount AS TotalEmployees, @Payroll AS TotalPayroll, @AvgSalary AS AverageBaseSalary;

-- Test 2: Specific d.DepartmentName with e.BaseSalary threshold
EXEC sp_Lab_GetDepartmentSummary 
    @d.DepartmentID = 2001,
    @SalaryThreshold = 60000,
    @EmployeeCount = @EmpCount OUTPUT,
    @TotalPayroll = @Payroll OUTPUT,
    @AverageSalary = @AvgSalary OUTPUT;

SELECT 'Department 2001 Analysis' AS Analysis, @EmpCount AS Count, @AvgSalary AS AvgSalary;

-- Test 3: Include inactive employees
EXEC sp_Lab_GetDepartmentSummary 
    @d.DepartmentID = 2002,
    @IncludeInactiveEmployees = 1,
    @EmployeeCount = @EmpCount OUTPUT,
    @TotalPayroll = @Payroll OUTPUT,
    @AverageSalary = @AvgSalary OUTPUT;
```

## Exercise 2: Creating and Managing Stored Procedures

### Objective

Develop skills in creating robust stored procedures with comprehensive error handling, input validation, and business logic implementation.

### Exercise 2.1: Employee Management Procedures

**Task:** Create procedures for adding, updating, and managing employee records with full validation.

```sql
-- Step 1: Create employee addition procedure
CREATE PROCEDURE sp_Lab_AddEmployee
    @e.FirstName VARCHAR(50),
    @e.LastName VARCHAR(50),
    @e.JobTitle VARCHAR(100),
    @e.BaseSalary DECIMAL(10,2),
    @d.DepartmentID INT,
    @ManagerID INT = NULL,
    @WorkEmail VARCHAR(100),
    @e.HireDate DATE = NULL,
    @NewEmployeeID INT OUTPUT,
    @ValidationMessage VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    -- Initialize output parameters
    SET @NewEmployeeID = 0;
    SET @ValidationMessage = '';
    
    -- Comprehensive input validation
    -- Name validation
    IF LTRIM(RTRIM(@e.FirstName)) = '' OR @e.FirstName IS NULL
    BEGIN
        SET @ValidationMessage = 'First name is required.';
        RETURN -1;
    END
    
    IF LTRIM(RTRIM(@e.LastName)) = '' OR @e.LastName IS NULL
    BEGIN
        SET @ValidationMessage = 'Last name is required.';
        RETURN -2;
    END
    
    -- Job title validation
    IF LTRIM(RTRIM(@e.JobTitle)) = '' OR @e.JobTitle IS NULL
    BEGIN
        SET @ValidationMessage = 'Job title is required.';
        RETURN -3;
    END
    
    -- e.BaseSalary validation
    IF @e.BaseSalary IS NULL OR @e.BaseSalary <= 0
    BEGIN
        SET @ValidationMessage = 'Base e.BaseSalary must be a positive amount.';
        RETURN -4;
    END
    
    IF @e.BaseSalary > 500000 -- Business rule
    BEGIN
        SET @ValidationMessage = 'Base e.BaseSalary cannot exceed $500,000 per company policy.';
        RETURN -5;
    END
    
    -- d.DepartmentName validation
    IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
    BEGIN
        SET @ValidationMessage = 'Invalid or inactive d.DepartmentName ID: ' + CAST(@d.DepartmentID AS VARCHAR);
        RETURN -6;
    END
    
    -- Manager validation
    IF @ManagerID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @ManagerID AND IsActive = 1)
        BEGIN
            SET @ValidationMessage = 'Invalid or inactive manager ID: ' + CAST(@ManagerID AS VARCHAR);
            RETURN -7;
        END
        
        -- Business rule: Manager should be in same d.DepartmentName or senior level
        IF NOT EXISTS (
            SELECT 1 FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
            WHERE e.EmployeeID = @ManagerID 
              AND (e.d.DepartmentID = @d.DepartmentID OR e.BaseSalary >= 80000)
        )
        BEGIN
            SET @ValidationMessage = 'Manager must be in same d.DepartmentName or be a senior manager.';
            RETURN -8;
        END
    END
    
    -- Email validation
    IF @WorkEmail NOT LIKE '%_@_%._%'
    BEGIN
        SET @ValidationMessage = 'Invalid email format.';
        RETURN -9;
    END
    
    IF EXISTS (SELECT 1 FROM Employees e WHERE WorkEmail = @WorkEmail AND IsActive = 1)
    BEGIN
        SET @ValidationMessage = 'Email address already exists: ' + @WorkEmail;
        RETURN -10;
    END
    
    -- Date validation
    SET @e.HireDate = ISNULL(@e.HireDate, GETDATE());
    IF @e.HireDate > GETDATE()
    BEGIN
        SET @ValidationMessage = 'Hire date cannot be in the future.';
        RETURN -11;
    END
    
    -- Business validation: e.BaseSalary should be appropriate for d.DepartmentName
    DECLARE @DeptAvgSalary DECIMAL(10,2);
    SELECT @DeptAvgSalary = AVG(e.BaseSalary)
    FROM Employees e 
    WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1;
    
    IF @DeptAvgSalary IS NOT NULL AND @e.BaseSalary > (@DeptAvgSalary * 2)
    BEGIN
        SET @ValidationMessage = 'Proposed e.BaseSalary is significantly higher than d.DepartmentName average. Please review.';
        -- This is a warning, not an error - continue with insertion
    END
    
    -- Insert new employee
    BEGIN TRANSACTION;
    
    BEGIN TRY
        INSERT INTO Employees (
            e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, d.DepartmentID, 
            ManagerID, WorkEmail, e.HireDate, IsActive
        )
        VALUES (
            LTRIM(RTRIM(@e.FirstName)), LTRIM(RTRIM(@e.LastName)), LTRIM(RTRIM(@e.JobTitle)),
            @e.BaseSalary, @d.DepartmentID, @ManagerID, LOWER(LTRIM(RTRIM(@WorkEmail))), 
            @e.HireDate, 1
        );
        
        SET @NewEmployeeID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        -- Success message
        IF @ValidationMessage = ''
        BEGIN
            SET @ValidationMessage = 'Employee successfully added with ID: ' + CAST(@NewEmployeeID AS VARCHAR);
        END
        ELSE
        BEGIN
            SET @ValidationMessage = 'Employee added with warning: ' + @ValidationMessage;
        END
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @ValidationMessage = 'Failed to add employee: ' + ERROR_MESSAGE();
        RETURN -99;
    END CATCH
    
    RETURN 0; -- Success
END;

-- Step 2: Test the employee addition procedure
DECLARE @NewID INT, @Message VARCHAR(500), @Result INT;

-- Test 1: Valid employee addition
EXEC @Result = sp_Lab_AddEmployee
    @e.FirstName = 'Sarah',
    @e.LastName = 'Johnson',
    @e.JobTitle = 'Software Engineer',
    @e.BaseSalary = 75000,
    @d.DepartmentID = 2001,
    @ManagerID = 3001,
    @WorkEmail = 'sarah.johnson@techcorp.com',
    @NewEmployeeID = @NewID OUTPUT,
    @ValidationMessage = @Message OUTPUT;

SELECT @Result AS ReturnCode, @NewID AS NewEmployeeID, @Message AS Message;

-- Test 2: Test validation errors
EXEC @Result = sp_Lab_AddEmployee
    @e.FirstName = '',  -- Invalid: empty name
    @e.LastName = 'Test',
    @e.JobTitle = 'Tester',
    @e.BaseSalary = 50000,
    @d.DepartmentID = 2001,
    @WorkEmail = 'test@techcorp.com',
    @NewEmployeeID = @NewID OUTPUT,
    @ValidationMessage = @Message OUTPUT;

SELECT @Result AS ErrorReturnCode, @Message AS ErrorMessage;

-- Test 3: Duplicate email test
EXEC @Result = sp_Lab_AddEmployee
    @e.FirstName = 'John',
    @e.LastName = 'Duplicate',
    @e.JobTitle = 'Developer',
    @e.BaseSalary = 70000,
    @d.DepartmentID = 2001,
    @WorkEmail = 'sarah.johnson@techcorp.com',  -- Duplicate from Test 1
    @NewEmployeeID = @NewID OUTPUT,
    @ValidationMessage = @Message OUTPUT;

SELECT @Result AS DuplicateTestResult, @Message AS DuplicateMessage;
```

### Exercise 2.2: Complex Business Logic Procedures

**Task:** Create procedures that implement complex business calculations and multi-step processes.

```sql
-- Step 1: Create employee performance evaluation procedure
CREATE PROCEDURE sp_Lab_EvaluateEmployeePerformance
    @e.EmployeeID INT,
    @EvaluationPeriodMonths INT = 12,
    @PerformanceScore DECIMAL(5,2) OUTPUT,
    @PerformanceGrade VARCHAR(20) OUTPUT,
    @RecommendedAction VARCHAR(100) OUTPUT,
    @SalaryAdjustmentPercent DECIMAL(5,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize output parameters
    SET @PerformanceScore = 0;
    SET @PerformanceGrade = 'Not Evaluated';
    SET @RecommendedAction = 'No Action';
    SET @SalaryAdjustmentPercent = 0;
    
    -- Validate employee
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1)
    BEGIN
        RAISERROR('Employee ID %d not found or inactive.', 16, 1, @e.EmployeeID);
        RETURN -1;
    END
    
    -- Get employee information
    DECLARE @CurrentSalary DECIMAL(10,2), @e.HireDate DATE, @d.DepartmentID INT;
    DECLARE @YearsOfService INT, @e.JobTitle VARCHAR(100);
    
    SELECT 
        @CurrentSalary = e.BaseSalary,
        @e.HireDate = e.HireDate,
        @d.DepartmentID = d.DepartmentID,
        @e.JobTitle = e.JobTitle,
        @YearsOfService = DATEDIFF(YEAR, e.HireDate, GETDATE())
    FROM Employees e
    WHERE e.EmployeeID = @e.EmployeeID;
    
    -- Calculate performance components
    DECLARE @ProjectScore DECIMAL(5,2) = 0;
    DECLARE @CustomerScore DECIMAL(5,2) = 0;
    DECLARE @LeadershipScore DECIMAL(5,2) = 0;
    DECLARE @TenureScore DECIMAL(5,2) = 0;
    
    -- Project involvement score (0-30 points)
    SELECT @ProjectScore = 
        CASE 
            WHEN project_stats.ProjectCount >= 5 THEN 30.0
            WHEN project_stats.ProjectCount >= 3 THEN 25.0
            WHEN project_stats.ProjectCount >= 2 THEN 20.0
            WHEN project_stats.ProjectCount >= 1 THEN 15.0
            ELSE 5.0
        END +
        CASE 
            WHEN project_stats.TotalHours >= 1000 THEN 10.0
            WHEN project_stats.TotalHours >= 500 THEN 7.0
            WHEN project_stats.TotalHours >= 200 THEN 5.0
            ELSE 0.0
        END
    FROM (
        SELECT 
            COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
            SUM(ep.HoursWorked) AS TotalHours
        FROM EmployeeProjects ep
        WHERE ep.e.EmployeeID = @e.EmployeeID
          AND ep.IsActive = 1
          AND ep.StartDate >= DATEADD(MONTH, -@EvaluationPeriodMonths, GETDATE())
    ) project_stats;
    
    SET @ProjectScore = ISNULL(@ProjectScore, 5.0);
    IF @ProjectScore > 30 SET @ProjectScore = 30;
    
    -- Customer service score (0-25 points)
    SELECT @CustomerScore = 
        CASE 
            WHEN COUNT(o.OrderID) >= 50 THEN 25.0
            WHEN COUNT(o.OrderID) >= 25 THEN 20.0
            WHEN COUNT(o.OrderID) >= 10 THEN 15.0
            WHEN COUNT(o.OrderID) >= 5 THEN 10.0
            WHEN COUNT(o.OrderID) >= 1 THEN 5.0
            ELSE 0.0
        END
    FROM Orders o
    WHERE o.e.EmployeeID = @e.EmployeeID
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -@EvaluationPeriodMonths, GETDATE());
    
    SET @CustomerScore = ISNULL(@CustomerScore, 0);
    
    -- Leadership score (0-25 points)
    DECLARE @DirectReports INT, @ManagedProjects INT;
    
    SELECT @DirectReports = COUNT(*)
    FROM Employees e 
    WHERE ManagerID = @e.EmployeeID AND IsActive = 1;
    
    SELECT @ManagedProjects = COUNT(*)
    FROM Projects p 
    WHERE ProjectManagerID = @e.EmployeeID AND IsActive = 1;
    
    SET @LeadershipScore = 
        CASE 
            WHEN @DirectReports >= 10 THEN 15.0
            WHEN @DirectReports >= 5 THEN 12.0
            WHEN @DirectReports >= 2 THEN 8.0
            WHEN @DirectReports >= 1 THEN 5.0
            ELSE 0.0
        END +
        CASE 
            WHEN @ManagedProjects >= 3 THEN 10.0
            WHEN @ManagedProjects >= 1 THEN 7.0
            ELSE 0.0
        END;
    
    -- Tenure and reliability score (0-20 points)
    SET @TenureScore = 
        CASE 
            WHEN @YearsOfService >= 10 THEN 20.0
            WHEN @YearsOfService >= 5 THEN 17.0
            WHEN @YearsOfService >= 3 THEN 15.0
            WHEN @YearsOfService >= 1 THEN 12.0
            ELSE 8.0
        END;
    
    -- Calculate total performance score
    SET @PerformanceScore = @ProjectScore + @CustomerScore + @LeadershipScore + @TenureScore;
    
    -- Determine performance grade and recommendations
    IF @PerformanceScore >= 90
    BEGIN
        SET @PerformanceGrade = 'Exceptional (A+)';
        SET @RecommendedAction = 'Promotion/Significant Raise';
        SET @SalaryAdjustmentPercent = 15.0;
    END
    ELSE IF @PerformanceScore >= 80
    BEGIN
        SET @PerformanceGrade = 'Outstanding (A)';
        SET @RecommendedAction = 'Raise/Additional Responsibilities';
        SET @SalaryAdjustmentPercent = 10.0;
    END
    ELSE IF @PerformanceScore >= 70
    BEGIN
        SET @PerformanceGrade = 'Exceeds Expectations (B+)';
        SET @RecommendedAction = 'Merit Increase';
        SET @SalaryAdjustmentPercent = 5.0;
    END
    ELSE IF @PerformanceScore >= 60
    BEGIN
        SET @PerformanceGrade = 'Meets Expectations (B)';
        SET @RecommendedAction = 'Standard Increase';
        SET @SalaryAdjustmentPercent = 3.0;
    END
    ELSE IF @PerformanceScore >= 50
    BEGIN
        SET @PerformanceGrade = 'Below Expectations (C)';
        SET @RecommendedAction = 'Performance Improvement Plan';
        SET @SalaryAdjustmentPercent = 0.0;
    END
    ELSE
    BEGIN
        SET @PerformanceGrade = 'Needs Improvement (D)';
        SET @RecommendedAction = 'Disciplinary Action Required';
        SET @SalaryAdjustmentPercent = 0.0;
    END
    
    -- Return detailed evaluation results
    SELECT 
        @e.EmployeeID AS e.EmployeeID,
        (SELECT e.FirstName + ' ' + e.LastName FROM Employees e WHERE e.EmployeeID = @e.EmployeeID) AS EmployeeName,
        @e.JobTitle AS e.JobTitle,
        @YearsOfService AS YearsOfService,
        FORMAT(@CurrentSalary, 'C') AS CurrentSalary,
        @EvaluationPeriodMonths AS EvaluationPeriodMonths,
        -- Score breakdown
        @ProjectScore AS ProjectScore,
        @CustomerScore AS CustomerScore,
        @LeadershipScore AS LeadershipScore,
        @TenureScore AS TenureScore,
        @PerformanceScore AS TotalScore,
        @PerformanceGrade AS Grade,
        @RecommendedAction AS RecommendedAction,
        @SalaryAdjustmentPercent AS SuggestedRaisePercent,
        FORMAT(@CurrentSalary * (1 + @SalaryAdjustmentPercent / 100), 'C') AS ProposedSalary,
        -- Supporting metrics
        @DirectReports AS DirectReports,
        @ManagedProjects AS ManagedProjects,
        GETDATE() AS EvaluationDate;
    
    RETURN 0; -- Success
END;

-- Step 2: Test the performance evaluation procedure
DECLARE @Score DECIMAL(5,2), @Grade VARCHAR(20), @Action VARCHAR(100), @Raise DECIMAL(5,2);
DECLARE @Result INT;

-- Test with different employees
EXEC @Result = sp_Lab_EvaluateEmployeePerformance
    @e.EmployeeID = 3001,
    @EvaluationPeriodMonths = 12,
    @PerformanceScore = @Score OUTPUT,
    @PerformanceGrade = @Grade OUTPUT,
    @RecommendedAction = @Action OUTPUT,
    @SalaryAdjustmentPercent = @Raise OUTPUT;

SELECT 
    @Result AS ReturnCode,
    @Score AS PerformanceScore,
    @Grade AS Grade,
    @Action AS RecommendedAction,
    @Raise AS SuggestedRaise;

-- Test with 6-month evaluation period
EXEC sp_Lab_EvaluateEmployeePerformance
    @e.EmployeeID = 3002,
    @EvaluationPeriodMonths = 6,
    @PerformanceScore = @Score OUTPUT,
    @PerformanceGrade = @Grade OUTPUT,
    @RecommendedAction = @Action OUTPUT,
    @SalaryAdjustmentPercent = @Raise OUTPUT;

SELECT '6-Month Evaluation' AS EvaluationType, @Score AS Score, @Grade AS Grade;
```

## Exercise 3: Dynamic SQL and Advanced Procedures

### Objective

Implement dynamic SQL procedures that adapt to varying business requirements and demonstrate advanced stored procedure techniques.

### Exercise 3.1: Dynamic Reporting System

**Task:** Create a flexible reporting system that generates different types of reports based on parameters.

```sql
-- Step 1: Create dynamic business intelligence reporting procedure
CREATE PROCEDURE sp_Lab_GenerateBusinessReport
    @ReportType VARCHAR(50),  -- 'SalesAnalysis', 'EmployeeProductivity', 'DepartmentPerformance', 'CustomerInsights'
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @GroupBy VARCHAR(20) = 'Month',  -- 'Day', 'Week', 'Month', 'Quarter'
    @FilterIDs VARCHAR(1000) = NULL,  -- Comma-separated list of relevant IDs
    @TopN INT = NULL,
    @IncludeDetails BIT = 0,
    @OutputFormat VARCHAR(20) = 'Standard'  -- 'Standard', 'Summary', 'Detailed'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate and set defaults
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -6, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    IF @ReportType NOT IN ('SalesAnalysis', 'EmployeeProductivity', 'DepartmentPerformance', 'CustomerInsights')
        SET @ReportType = 'SalesAnalysis';
    IF @GroupBy NOT IN ('Day', 'Week', 'Month', 'Quarter') SET @GroupBy = 'Month';
    IF @OutputFormat NOT IN ('Standard', 'Summary', 'Detailed') SET @OutputFormat = 'Standard';
    
    -- Dynamic SQL variables
    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @Params NVARCHAR(1000) = '';
    DECLARE @SelectClause NVARCHAR(MAX) = '';
    DECLARE @FromClause NVARCHAR(MAX) = '';
    DECLARE @WhereClause NVARCHAR(MAX) = '';
    DECLARE @GroupByClause NVARCHAR(MAX) = '';
    DECLARE @OrderByClause NVARCHAR(MAX) = '';
    
    -- Build date grouping expression
    DECLARE @DateGrouping NVARCHAR(200);
    SET @DateGrouping = 
        CASE @GroupBy
            WHEN 'Day' THEN 'CAST(o.OrderDate AS DATE)'
            WHEN 'Week' THEN 'DATEADD(WEEK, DATEDIFF(WEEK, 0, o.OrderDate), 0)'
            WHEN 'Month' THEN 'DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)'
            WHEN 'Quarter' THEN 'DATEFROMPARTS(YEAR(o.OrderDate), ((MONTH(o.OrderDate) - 1) / 3) * 3 + 1, 1)'
        END;
    
    -- Report-specific query construction
    IF @ReportType = 'SalesAnalysis'
    BEGIN
        SET @SelectClause = '
        SELECT ' + CASE WHEN @TopN IS NOT NULL THEN 'TOP (' + CAST(@TopN AS VARCHAR) + ') ' ELSE '' END + '
            ' + @DateGrouping + ' AS ReportPeriod,
            COUNT(o.OrderID) AS TotalOrders,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalRevenue,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderValue,
            COUNT(DISTINCT o.CustomerID) AS UniqueCustomers';
            
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @SelectClause = @SelectClause + ',
            MIN(o.TotalAmount) AS MinOrderAmount,
            MAX(o.TotalAmount) AS MaxOrderAmount,
            COUNT(CASE WHEN o.TotalAmount >= 10000 THEN 1 END) AS LargeOrders,
            COUNT(CASE WHEN o.TotalAmount < 1000 THEN 1 END) AS SmallOrders';
        END
        
        SET @FromClause = ' FROM Orders o';
        SET @GroupByClause = ' GROUP BY ' + @DateGrouping;
        SET @OrderByClause = ' ORDER BY ReportPeriod DESC';
    END
    ELSE IF @ReportType = 'EmployeeProductivity'
    BEGIN
        SET @SelectClause = '
        SELECT ' + CASE WHEN @TopN IS NOT NULL THEN 'TOP (' + CAST(@TopN AS VARCHAR) + ') ' ELSE '' END + '
            e.EmployeeID,
            e.FirstName + '' '' + e.LastName AS EmployeeName,
            d.DepartmentName,
            COUNT(o.OrderID) AS OrdersProcessed,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalProcessedValue,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderValue,
            COUNT(DISTINCT o.CustomerID) AS CustomersServed';
            
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @SelectClause = @SelectClause + ',
            -- Project involvement
            ISNULL(proj_stats.ProjectCount, 0) AS ActiveProjects,
            ISNULL(proj_stats.TotalHours, 0) AS ProjectHours,
            -- Performance rating
            CASE 
                WHEN COUNT(o.OrderID) >= 50 THEN ''Excellent''
                WHEN COUNT(o.OrderID) >= 25 THEN ''Good''
                WHEN COUNT(o.OrderID) >= 10 THEN ''Average''
                ELSE ''Below Average''
            END AS ProductivityRating';
        END
        
        SET @FromClause = '
        FROM Employees e
        INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
        LEFT JOIN Orders o ON e.EmployeeID = o.e.EmployeeID 
                              AND o.OrderDate >= @DateFromParam 
                              AND o.OrderDate <= @DateToParam
                              AND o.IsActive = 1';
                              
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @FromClause = @FromClause + '
            LEFT JOIN (
                SELECT 
                    ep.e.EmployeeID,
                    COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
                    SUM(ep.HoursWorked) AS TotalHours
                FROM EmployeeProjects ep
                WHERE ep.IsActive = 1
                  AND ep.StartDate >= @DateFromParam
                GROUP BY ep.e.EmployeeID
            ) proj_stats ON e.EmployeeID = proj_stats.e.EmployeeID';
        END
        
        SET @GroupByClause = ' GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName';
        
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @GroupByClause = @GroupByClause + ', proj_stats.ProjectCount, proj_stats.TotalHours';
        END
        
        SET @OrderByClause = ' ORDER BY COUNT(o.OrderID) DESC';
    END
    ELSE IF @ReportType = 'DepartmentPerformance'
    BEGIN
        SET @SelectClause = '
        SELECT ' + CASE WHEN @TopN IS NOT NULL THEN 'TOP (' + CAST(@TopN AS VARCHAR) + ') ' ELSE '' END + '
            d.DepartmentID,
            d.DepartmentName,
            d.Location,
            COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
            COUNT(DISTINCT o.OrderID) AS TotalOrders,
            FORMAT(SUM(o.TotalAmount), ''C'') AS DepartmentRevenue,
            FORMAT(AVG(e.BaseSalary), ''C'') AS AverageBaseSalary,
            FORMAT(SUM(e.BaseSalary), ''C'') AS TotalPayroll';
            
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @SelectClause = @SelectClause + ',
            COUNT(DISTINCT p.ProjectID) AS ActiveProjects,
            FORMAT(d.Budget, ''C'') AS DepartmentBudget,
            CASE 
                WHEN SUM(o.TotalAmount) > d.Budget THEN ''Exceeds d.Budget''
                WHEN SUM(o.TotalAmount) > d.Budget * 0.8 THEN ''Near d.Budget''
                ELSE ''Under d.Budget''
            END AS BudgetStatus';
        END
        
        SET @FromClause = '
        FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID AND e.IsActive = 1
        LEFT JOIN Orders o ON e.EmployeeID = o.e.EmployeeID 
                              AND o.OrderDate >= @DateFromParam 
                              AND o.OrderDate <= @DateToParam
                              AND o.IsActive = 1';
                              
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @FromClause = @FromClause + '
            LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID AND p.IsActive = 1';
        END
        
        SET @GroupByClause = ' GROUP BY d.DepartmentID, d.DepartmentName, d.Location';
        
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @GroupByClause = @GroupByClause + ', d.Budget';
        END
        
        SET @OrderByClause = ' ORDER BY SUM(o.TotalAmount) DESC';
    END
    ELSE -- CustomerInsights
    BEGIN
        SET @SelectClause = '
        SELECT ' + CASE WHEN @TopN IS NOT NULL THEN 'TOP (' + CAST(@TopN AS VARCHAR) + ') ' ELSE '' END + '
            c.CustomerID,
            c.CompanyName,
            c.City,
            c.Country,
            COUNT(o.OrderID) AS TotalOrders,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalSpent,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderValue,
            MIN(o.OrderDate) AS FirstOrder,
            MAX(o.OrderDate) AS LastOrder,
            DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifespan';
            
        IF @OutputFormat = 'Detailed'
        BEGIN
            SET @SelectClause = @SelectClause + ',
            COUNT(DISTINCT o.e.EmployeeID) AS DifferentReps,
            CASE 
                WHEN MAX(o.OrderDate) >= DATEADD(MONTH, -3, GETDATE()) THEN ''Active''
                WHEN MAX(o.OrderDate) >= DATEADD(MONTH, -6, GETDATE()) THEN ''Recent''
                WHEN MAX(o.OrderDate) >= DATEADD(YEAR, -1, GETDATE()) THEN ''Dormant''
                ELSE ''Inactive''
            END AS CustomerStatus';
        END
        
        SET @FromClause = '
        FROM Customers c
        INNER JOIN Orders o ON c.CustomerID = o.CustomerID';
        
        SET @GroupByClause = ' GROUP BY c.CustomerID, c.CompanyName, c.City, c.Country';
        SET @OrderByClause = ' ORDER BY SUM(o.TotalAmount) DESC';
    END
    
    -- Build WHERE clause
    SET @WhereClause = ' WHERE 1=1';
    SET @Params = '@DateFromParam DATE, @DateToParam DATE';
    
    IF @ReportType IN ('SalesAnalysis', 'EmployeeProductivity')
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.OrderDate >= @DateFromParam AND o.OrderDate <= @DateToParam';
    END
    
    -- Add filter for specific IDs if provided
    IF @FilterIDs IS NOT NULL AND LTRIM(RTRIM(@FilterIDs)) != ''
    BEGIN
        IF @ReportType = 'EmployeeProductivity'
        BEGIN
            SET @WhereClause = @WhereClause + ' AND e.EmployeeID IN (SELECT value FROM STRING_SPLIT(@FilterIDsParam, '',''))';
        END
        ELSE IF @ReportType = 'DepartmentPerformance'
        BEGIN
            SET @WhereClause = @WhereClause + ' AND d.DepartmentID IN (SELECT value FROM STRING_SPLIT(@FilterIDsParam, '',''))';
        END
        ELSE IF @ReportType = 'CustomerInsights'
        BEGIN
            SET @WhereClause = @WhereClause + ' AND c.CustomerID IN (SELECT value FROM STRING_SPLIT(@FilterIDsParam, '',''))';
        END
        
        SET @Params = @Params + ', @FilterIDsParam VARCHAR(1000)';
    END
    
    -- Add active status filters
    SET @WhereClause = @WhereClause + ' AND d.IsActive = 1';
    
    -- Construct final query
    SET @SQL = @SelectClause + @FromClause + @WhereClause + @GroupByClause + @OrderByClause;
    
    -- Execute the dynamic query
    BEGIN TRY
        PRINT 'Executing Report: ' + @ReportType;
        PRINT 'SQL: ' + LEFT(@SQL, 500) + '...';  -- Show first 500 chars for debugging
        
        IF @FilterIDs IS NOT NULL
        BEGIN
            EXEC sp_executesql @SQL, @Params,
                @DateFromParam = @DateFrom,
                @DateToParam = @DateTo,
                @FilterIDsParam = @FilterIDs;
        END
        ELSE
        BEGIN
            EXEC sp_executesql @SQL, '@DateFromParam DATE, @DateToParam DATE',
                @DateFromParam = @DateFrom,
                @DateToParam = @DateTo;
        END
        
        -- Return report metadata
        SELECT 
            @ReportType AS ReportType,
            @OutputFormat AS OutputFormat,
            @GroupBy AS GroupingBy,
            @DateFrom AS ReportDateFrom,
            @DateTo AS ReportDateTo,
            @TopN AS TopNResults,
            @FilterIDs AS AppliedFilters,
            GETDATE() AS ReportGeneratedAt;
            
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Dynamic report generation failed: %s', 16, 1, @ErrorMessage);
        RETURN -1;
    END CATCH
    
    RETURN 0; -- Success
END;

-- Step 2: Test the dynamic reporting system
-- Test 1: Sales Analysis Report
EXEC sp_Lab_GenerateBusinessReport
    @ReportType = 'SalesAnalysis',
    @DateFrom = '2024-01-01',
    @DateTo = '2024-12-31',
    @GroupBy = 'Month',
    @OutputFormat = 'Detailed';

-- Test 2: Employee Productivity Report
EXEC sp_Lab_GenerateBusinessReport
    @ReportType = 'EmployeeProductivity',
    @TopN = 10,
    @OutputFormat = 'Detailed',
    @FilterIDs = '3001,3002,3003';

-- Test 3: d.DepartmentName Performance Report
EXEC sp_Lab_GenerateBusinessReport
    @ReportType = 'DepartmentPerformance',
    @OutputFormat = 'Standard';

-- Test 4: Customer Insights Report
EXEC sp_Lab_GenerateBusinessReport
    @ReportType = 'CustomerInsights',
    @TopN = 5,
    @OutputFormat = 'Summary';
```

## Exercise 4: Error Handling and Transaction Management

### Objective

Implement comprehensive error handling, transaction management, and audit trail functionality in stored procedures.

### Exercise 4.1: Transaction-Safe Data Operations

**Task:** Create procedures that demonstrate proper transaction handling and error recovery.

```sql
-- Step 1: Create transaction-safe order processing procedure
CREATE PROCEDURE sp_Lab_ProcessOrderWithValidation
    @CustomerID INT,
    @e.EmployeeID INT,
    @OrderAmount DECIMAL(10,2),
    @OrderDate DATE = NULL,
    @ValidateCustomerCredit BIT = 1,
    @CreateAuditLog BIT = 1,
    @NewOrderID INT OUTPUT,
    @ProcessingMessage VARCHAR(1000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  -- Ensure transaction rollback on any error
    
    -- Initialize output parameters
    SET @NewOrderID = 0;
    SET @ProcessingMessage = '';
    
    -- Validate inputs
    IF @CustomerID IS NULL OR @CustomerID <= 0
    BEGIN
        SET @ProcessingMessage = 'Invalid customer ID provided.';
        RETURN -1;
    END
    
    IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 0
    BEGIN
        SET @ProcessingMessage = 'Invalid employee ID provided.';
        RETURN -2;
    END
    
    IF @OrderAmount IS NULL OR @OrderAmount <= 0
    BEGIN
        SET @ProcessingMessage = 'Order amount must be greater than zero.';
        RETURN -3;
    END
    
    IF @OrderAmount > 100000  -- Business rule: orders over $100k need special approval
    BEGIN
        SET @ProcessingMessage = 'Orders over $100,000 require special approval.';
        RETURN -4;
    END
    
    SET @OrderDate = ISNULL(@OrderDate, GETDATE());
    
    -- Declare variables for validation
    DECLARE @CustomerExists BIT = 0;
    DECLARE @EmployeeExists BIT = 0;
    DECLARE @CustomerCreditLimit DECIMAL(12,2) = 0;
    DECLARE @CustomerCurrentDebt DECIMAL(12,2) = 0;
    DECLARE @EmployeeDepartment INT;
    
    -- Begin transaction
    BEGIN TRANSACTION ProcessOrder;
    
    BEGIN TRY
        -- Validate customer exists and is active
        SELECT 
            @CustomerExists = 1,
            @CustomerCreditLimit = 50000  -- Assume default credit limit
        FROM Customers 
        WHERE CustomerID = @CustomerID AND IsActive = 1;
        
        IF @CustomerExists = 0
        BEGIN
            SET @ProcessingMessage = 'Customer ID ' + CAST(@CustomerID AS VARCHAR) + ' not found or inactive.';
            ROLLBACK TRANSACTION ProcessOrder;
            RETURN -5;
        END
        
        -- Validate employee exists and is active
        SELECT 
            @EmployeeExists = 1,
            @EmployeeDepartment = DepartmentID
        FROM Employees e 
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        IF @EmployeeExists = 0
        BEGIN
            SET @ProcessingMessage = 'Employee ID ' + CAST(@e.EmployeeID AS VARCHAR) + ' not found or inactive.';
            ROLLBACK TRANSACTION ProcessOrder;
            RETURN -6;
        END
        
        -- Check customer credit if validation is enabled
        IF @ValidateCustomerCredit = 1
        BEGIN
            -- Calculate current debt (sum of active orders)
            SELECT @CustomerCurrentDebt = ISNULL(SUM(TotalAmount), 0)
            FROM Orders 
            WHERE CustomerID = @CustomerID AND IsActive = 1;
            
            -- Check if new order would exceed credit limit
            IF (@CustomerCurrentDebt + @OrderAmount) > @CustomerCreditLimit
            BEGIN
                SET @ProcessingMessage = 'Order would exceed customer credit limit. Current debt: ' + 
                                       FORMAT(@CustomerCurrentDebt, 'C') + 
                                       ', Credit limit: ' + FORMAT(@CustomerCreditLimit, 'C') + 
                                       ', Requested: ' + FORMAT(@OrderAmount, 'C');
                ROLLBACK TRANSACTION ProcessOrder;
                RETURN -7;
            END
        END
        
        -- Insert the order
        INSERT INTO Orders (CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive)
        VALUES (@CustomerID, @e.EmployeeID, @OrderDate, @OrderAmount, 1);
        
        SET @NewOrderID = SCOPE_IDENTITY();
        
        -- Create audit log entry if requested
        IF @CreateAuditLog = 1
        BEGIN
            -- In a real system, this would go to an audit table
            -- For this lab, we'll simulate with a log message
            DECLARE @AuditMessage VARCHAR(500);
            SET @AuditMessage = 'Order ' + CAST(@NewOrderID AS VARCHAR) + 
                               ' created for Customer ' + CAST(@CustomerID AS VARCHAR) + 
                               ' by Employee ' + CAST(@e.EmployeeID AS VARCHAR) + 
                               ' for amount ' + FORMAT(@OrderAmount, 'C') + 
                               ' on ' + FORMAT(@OrderDate, 'yyyy-MM-dd');
            
            PRINT 'AUDIT LOG: ' + @AuditMessage;
        END
        
        -- Update customer statistics (simulate)
        -- In a real system, you might update customer order counts, last order date, etc.
        
        -- Commit the transaction
        COMMIT TRANSACTION ProcessOrder;
        
        -- Success message
        SET @ProcessingMessage = 'Order successfully processed. Order ID: ' + CAST(@NewOrderID AS VARCHAR) + 
                               '. Amount: ' + FORMAT(@OrderAmount, 'C') + 
                               '. Remaining credit: ' + FORMAT(@CustomerCreditLimit - @CustomerCurrentDebt - @OrderAmount, 'C');
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on any error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION ProcessOrder;
        
        -- Capture error details
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        -- Format error message
        SET @ProcessingMessage = 'Order processing failed at line ' + CAST(@ErrorLine AS VARCHAR) + 
                               ': Error ' + CAST(@ErrorNumber AS VARCHAR) + 
                               ' - ' + @ErrorMessage;
        
        -- Log error (in production, this would go to an error log table)
        PRINT 'ERROR LOG: ' + @ProcessingMessage;
        
        RETURN -99;  -- General error code
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Step 2: Test the transaction-safe order processing
DECLARE @OrderID INT, @Message VARCHAR(1000), @Result INT;

-- Test 1: Successful order processing
EXEC @Result = sp_Lab_ProcessOrderWithValidation
    @CustomerID = 6001,
    @e.EmployeeID = 3001,
    @OrderAmount = 5000.00,
    @ValidateCustomerCredit = 1,
    @CreateAuditLog = 1,
    @NewOrderID = @OrderID OUTPUT,
    @ProcessingMessage = @Message OUTPUT;

SELECT @Result AS ReturnCode, @OrderID AS NewOrderID, @Message AS ProcessingMessage;

-- Test 2: Test credit limit validation
EXEC @Result = sp_Lab_ProcessOrderWithValidation
    @CustomerID = 6001,
    @e.EmployeeID = 3001,
    @OrderAmount = 75000.00,  -- Exceeds credit limit
    @ValidateCustomerCredit = 1,
    @NewOrderID = @OrderID OUTPUT,
    @ProcessingMessage = @Message OUTPUT;

SELECT @Result AS CreditTestResult, @Message AS CreditTestMessage;

-- Test 3: Test with invalid customer
EXEC @Result = sp_Lab_ProcessOrderWithValidation
    @CustomerID = 99999,  -- Invalid customer
    @e.EmployeeID = 3001,
    @OrderAmount = 1000.00,
    @NewOrderID = @OrderID OUTPUT,
    @ProcessingMessage = @Message OUTPUT;

SELECT @Result AS InvalidCustomerResult, @Message AS InvalidCustomerMessage;

-- Test 4: Bypass credit validation
EXEC @Result = sp_Lab_ProcessOrderWithValidation
    @CustomerID = 6002,
    @e.EmployeeID = 3002,
    @OrderAmount = 15000.00,
    @ValidateCustomerCredit = 0,  -- Skip credit check
    @CreateAuditLog = 1,
    @NewOrderID = @OrderID OUTPUT,
    @ProcessingMessage = @Message OUTPUT;

SELECT @Result AS BypassCreditResult, @OrderID AS BypassOrderID, @Message AS BypassMessage;
```

## Lab Summary and Assessment

### Lab Completion Checklist

**Exercise 1 - Basic Execution:**
- [ ] Successfully created and executed sp_Lab_GetEmployeeInfo
- [ ] Tested parameter combinations and error handling
- [ ] Created and executed sp_Lab_GetDepartmentSummary
- [ ] Demonstrated use of output parameters

**Exercise 2 - Creation and Management:**
- [ ] Successfully created sp_Lab_AddEmployee with comprehensive validation
- [ ] Tested input validation and error scenarios
- [ ] Created sp_Lab_EvaluateEmployeePerformance with complex calculations
- [ ] Demonstrated business logic implementation

**Exercise 3 - Dynamic SQL:**
- [ ] Created sp_Lab_GenerateBusinessReport with dynamic query construction
- [ ] Tested different report types and parameters
- [ ] Demonstrated security best practices with parameterized queries
- [ ] Showed flexible reporting capabilities

**Exercise 4 - Error Handling:**
- [ ] Created sp_Lab_ProcessOrderWithValidation with transaction management
- [ ] Demonstrated proper error handling and rollback procedures
- [ ] Tested various error scenarios and recovery
- [ ] Implemented audit logging and validation logic

### Performance Analysis

```sql
-- Execute this query to analyze the procedures created during the lab
SELECT 
    p.name AS ProcedureName,
    p.create_date AS CreatedDate,
    p.modify_date AS LastModified,
    s.execution_count AS ExecutionCount,
    s.total_elapsed_time / 1000 AS TotalElapsedTimeMS,
    s.avg_elapsed_time / 1000 AS AvgElapsedTimeMS,
    s.total_logical_reads AS TotalLogicalReads,
    s.avg_logical_reads AS AvgLogicalReads
FROM sys.procedures p
LEFT JOIN sys.dm_exec_procedure_stats s ON p.object_id = s.object_id
WHERE p.name LIKE 'sp_Lab_%'
ORDER BY p.name;
```

### Key Learning Outcomes

**Stored Procedure Fundamentals:**
- Parameter handling (input, output, default values)
- Return codes and error signaling
- Basic CRUD operations with validation
- Business logic implementation

**Advanced Techniques:**
- Dynamic SQL construction and security
- Complex business calculations
- Transaction management and ACID compliance
- Comprehensive error handling

**Best Practices Demonstrated:**
- Input validation and sanitization
- Parameterized queries for security
- Proper transaction boundaries
- Meaningful error messages and return codes
- Performance optimization techniques

**Real-World Applications:**
- Employee management systems
- Customer relationship management
- Business intelligence and reporting
- Order processing and validation
- Performance evaluation systems

### Next Steps

1. **Optimization**: Analyze execution plans and optimize procedure performance
2. **Security**: Review procedures for potential security vulnerabilities
3. **Testing**: Develop comprehensive test suites for edge cases
4. **Documentation**: Create detailed documentation for each procedure
5. **Integration**: Integrate procedures into application frameworks
6. **Monitoring**: Implement performance monitoring and alerting

This lab has provided comprehensive hands-on experience with stored procedure development, from basic execution to advanced dynamic SQL techniques, preparing students for real-world database application development in enterprise environments like TechCorp.