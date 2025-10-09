# Lesson 2: Passing Parameters to Stored Procedures

## Overview

Parameters are the cornerstone of stored procedure flexibility and reusability, enabling dynamic behavior based on runtime values. T-SQL stored procedures support input parameters, output parameters, and return values, providing comprehensive mechanisms for data exchange between calling applications and database procedures. For TechCorp's enterprise applications, effective parameter usage ensures secure, flexible, and maintainable database interactions that support complex business logic and varied reporting requirements.

## 🏢 TechCorp Business Context

**Parameter Usage in Enterprise Systems:**
- **Dynamic Reporting**: Flexible report generation based on user-selected criteria and date ranges
- **Business Rule Enforcement**: Parameterized validation and processing based on business policies
- **Application Integration**: Standardized interfaces between applications and database procedures
- **Security Implementation**: Controlled data access through parameterized queries preventing SQL injection
- **Performance Optimization**: Cached execution plans with parameter sniffing for optimized performance

### 📋 TechCorp Database Schema Reference

**Core Tables for Parameter-Based Operations:**
```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Understanding Parameter Types

### Input, Output, and Return Parameters

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Parameter Types Overview                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  INPUT PARAMETERS:                                                          │
│  ┌─────────────────────────────────────┐                                   │
│  │ CREATE PROCEDURE sp_Example         │  →  Used to pass data TO the      │
│  │   @InputParam INT,                  │     procedure for processing      │
│  │   @InputParam2 VARCHAR(50) = 'DEF' │     • Required or optional        │
│  │ AS BEGIN                            │     • Default values supported    │
│  │   SELECT * FROM Table               │     • Most common parameter type  │
│  │   WHERE ID = @InputParam            │                                   │
│  │ END                                 │                                   │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  OUTPUT PARAMETERS:                                                         │
│  ┌─────────────────────────────────────┐                                   │
│  │ CREATE PROCEDURE sp_Example         │  →  Used to return data FROM      │
│  │   @InputParam INT,                  │     the procedure to caller       │
│  │   @OutputParam INT OUTPUT           │     • Must specify OUTPUT keyword │
│  │ AS BEGIN                            │     • Modified within procedure   │
│  │   SET @OutputParam = (SELECT        │     • Returned to calling code    │
│  │     COUNT(*) FROM Table             │                                   │
│  │     WHERE ID = @InputParam)         │                                   │
│  │ END                                 │                                   │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  RETURN VALUES:                                                             │
│  ┌─────────────────────────────────────┐                                   │
│  │ CREATE PROCEDURE sp_Example         │  →  Integer return codes for      │
│  │ AS BEGIN                            │     status/error indication       │
│  │   IF (condition)                    │     • Always INTEGER type         │
│  │     RETURN 1  -- Success           │     • Conventional status codes   │
│  │   ELSE                              │     • 0 = Success, non-zero = Error│
│  │     RETURN -1  -- Error            │                                   │
│  │ END                                 │                                   │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Parameter Declaration Syntax

```sql
-- Complete parameter syntax
CREATE PROCEDURE procedure_name
    -- Input parameters
    @input_param1 datatype = default_value,
    @input_param2 datatype,
    
    -- Output parameters
    @output_param1 datatype OUTPUT,
    @output_param2 datatype = default_value OUTPUT,
    
    -- Input/Output parameters (can be both)
    @inout_param datatype = default_value OUTPUT
AS
BEGIN
    -- Procedure logic
    SET @output_param1 = calculated_value;
    RETURN status_code;  -- Optional return value
END;
```

## Input Parameters - Advanced Usage

### 1. Complex Employee Search with Multiple Parameters

#### TechCorp Example: Advanced Employee Search
```sql
-- Create comprehensive employee search with multiple input parameters
CREATE PROCEDURE sp_SearchEmployeesAdvanced
    @DepartmentID INT = NULL,
    @LocationFilter VARCHAR(50) = NULL,
    @MinSalary DECIMAL(10,2) = NULL,
    @MaxSalary DECIMAL(10,2) = NULL,
    @JobTitlePattern VARCHAR(100) = NULL,
    @HireStartDate DATE = NULL,
    @HireEndDate DATE = NULL,
    @IncludeInactive BIT = 0,
    @SortColumn VARCHAR(20) = 'LastName',
    @SortDirection VARCHAR(4) = 'ASC',
    @MaxResults INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Parameter validation
    IF @MinSalary IS NOT NULL AND @MaxSalary IS NOT NULL AND @MinSalary > @MaxSalary
    BEGIN
        RAISERROR('Minimum BaseSalary cannot be greater than maximum BaseSalary.', 16, 1);
        RETURN -1;
    END
    
    IF @HireStartDate IS NOT NULL AND @HireEndDate IS NOT NULL AND @HireStartDate > @HireEndDate
    BEGIN
        RAISERROR('Hire start date cannot be greater than hire end date.', 16, 1);
        RETURN -2;
    END
    
    IF @MaxResults <= 0 OR @MaxResults > 1000
    BEGIN
        RAISERROR('MaxResults must be between 1 and 1000.', 16, 1);
        RETURN -3;
    END
    
    IF @SortDirection NOT IN ('ASC', 'DESC')
    BEGIN
        SET @SortDirection = 'ASC';
    END
    
    -- Dynamic employee search query
    WITH EmployeeSearchResults AS (
        SELECT 
            e.EmployeeID,
            e.FirstName,
            e.LastName,
            e.FirstName + ' ' + e.LastName AS FullName,
            e.JobTitle,
            FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
            e.BaseSalary,
            d.DepartmentName,
            d.Location,
            e.HireDate,
            DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
            e.WorkEmail,
            CASE WHEN e.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
            -- Manager information
            ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
            -- Additional metrics
            CASE 
                WHEN e.BaseSalary >= 80000 THEN 'Senior Level'
                WHEN e.BaseSalary >= 60000 THEN 'Mid Level'
                WHEN e.BaseSalary >= 40000 THEN 'Junior Level'
                ELSE 'Entry Level'
            END AS SalaryBand,
            -- Search relevance scoring
            (CASE WHEN @DepartmentID IS NOT NULL AND e.DepartmentID = @DepartmentID THEN 10 ELSE 0 END +
             CASE WHEN @LocationFilter IS NOT NULL AND d.Location LIKE '%' + @LocationFilter + '%' THEN 5 ELSE 0 END +
             CASE WHEN @JobTitlePattern IS NOT NULL AND e.JobTitle LIKE '%' + @JobTitlePattern + '%' THEN 8 ELSE 0 END +
             CASE WHEN @MinSalary IS NOT NULL AND e.BaseSalary >= @MinSalary THEN 3 ELSE 0 END +
             CASE WHEN @MaxSalary IS NOT NULL AND e.BaseSalary <= @MaxSalary THEN 3 ELSE 0 END) AS RelevanceScore
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID
        WHERE d.IsActive = 1
          -- Apply all filter parameters
          AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
          AND (@LocationFilter IS NULL OR d.Location LIKE '%' + @LocationFilter + '%')
          AND (@MinSalary IS NULL OR e.BaseSalary >= @MinSalary)
          AND (@MaxSalary IS NULL OR e.BaseSalary <= @MaxSalary)
          AND (@JobTitlePattern IS NULL OR e.JobTitle LIKE '%' + @JobTitlePattern + '%')
          AND (@HireStartDate IS NULL OR e.HireDate >= @HireStartDate)
          AND (@HireEndDate IS NULL OR e.HireDate <= @HireEndDate)
          AND (e.IsActive = 1 OR @IncludeInactive = 1)
    )
    SELECT TOP (@MaxResults)
        EmployeeID,
        FirstName,
        LastName,
        FullName,
        JobTitle,
        FormattedSalary,
        BaseSalary,
        DepartmentName,
        Location,
        HireDate,
        YearsOfService,
        WorkEmail,
        Status,
        ManagerName,
        SalaryBand,
        RelevanceScore
    FROM Employees eearchResults
    ORDER BY 
        CASE 
            WHEN @SortColumn = 'LastName' AND @SortDirection = 'ASC' THEN LastName
            WHEN @SortColumn = 'FirstName' AND @SortDirection = 'ASC' THEN FirstName
            WHEN @SortColumn = 'HireDate' AND @SortDirection = 'ASC' THEN CAST(HireDate AS VARCHAR)
            WHEN @SortColumn = 'BaseSalary' AND @SortDirection = 'ASC' THEN CAST(BaseSalary AS VARCHAR)
            WHEN @SortColumn = 'Department' AND @SortDirection = 'ASC' THEN d.DepartmentName
        END ASC,
        CASE 
            WHEN @SortColumn = 'LastName' AND @SortDirection = 'DESC' THEN LastName
            WHEN @SortColumn = 'FirstName' AND @SortDirection = 'DESC' THEN FirstName
            WHEN @SortColumn = 'HireDate' AND @SortDirection = 'DESC' THEN CAST(HireDate AS VARCHAR)
            WHEN @SortColumn = 'BaseSalary' AND @SortDirection = 'DESC' THEN CAST(BaseSalary AS VARCHAR)
            WHEN @SortColumn = 'Department' AND @SortDirection = 'DESC' THEN d.DepartmentName
        END DESC,
        RelevanceScore DESC,
        LastName, FirstName;
    
    RETURN 0;  -- Success
END;

-- Example executions with various parameter combinations
-- Basic d.DepartmentName search
EXEC sp_SearchEmployeesAdvanced @DepartmentID = 2001;

-- BaseSalary range search with location filter
EXEC sp_SearchEmployeesAdvanced 
    @MinSalary = 60000, 
    @MaxSalary = 100000, 
    @LocationFilter = 'New York',
    @SortColumn = 'BaseSalary',
    @SortDirection = 'DESC';

-- Job title pattern search with date range
EXEC sp_SearchEmployeesAdvanced 
    @JobTitlePattern = 'Manager',
    @HireStartDate = '2020-01-01',
    @HireEndDate = '2023-12-31',
    @MaxResults = 50;

-- Comprehensive search with all parameters
EXEC sp_SearchEmployeesAdvanced 
    @DepartmentID = 2002,
    @LocationFilter = 'Chicago',
    @MinSalary = 50000,
    @JobTitlePattern = 'Analyst',
    @IncludeInactive = 1,
    @SortColumn = 'HireDate',
    @SortDirection = 'ASC',
    @MaxResults = 25;
```

### 2. Financial Analysis with Date Parameters

#### TechCorp Example: Parameterized Financial Analysis
```sql
-- Create comprehensive financial analysis with date and filtering parameters
CREATE PROCEDURE sp_AnalyzeDepartmentFinancials
    @DepartmentID INT = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @IncludeProjectData BIT = 1,
    @IncludeOrderData BIT = 1,
    @MinimumOrderValue DECIMAL(10,2) = 0,
    @GroupingLevel VARCHAR(20) = 'Department'  -- 'Department', 'Location', 'Both'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range if not provided (last 12 months)
    SET @StartDate = ISNULL(@StartDate, DATEADD(YEAR, -1, GETDATE()));
    SET @EndDate = ISNULL(@EndDate, GETDATE());
    
    -- Parameter validation
    IF @StartDate > @EndDate
    BEGIN
        RAISERROR('Start date cannot be greater than end date.', 16, 1);
        RETURN -1;
    END
    
    IF DATEDIFF(MONTH, @StartDate, @EndDate) > 60
    BEGIN
        RAISERROR('Date range cannot exceed 60 months.', 16, 1);
        RETURN -2;
    END
    
    IF @GroupingLevel NOT IN ('Department', 'Location', 'Both')
    BEGIN
        SET @GroupingLevel = 'Department';
    END
    
    -- Main financial analysis query
    WITH DepartmentFinancials AS (
        SELECT 
            d.DepartmentID,
            d.DepartmentName,
            d.Location,
            FORMAT(d.Budget, 'C') AS AllocatedBudget,
            d.Budget AS BudgetAmount,
            -- Employee costs
            employee_data.EmployeeCount,
            employee_data.TotalSalaryCost,
            employee_data.AverageSalary,
            -- Project data (conditional based on parameter)
            CASE WHEN @IncludeProjectData = 1 THEN project_data.ProjectCount ELSE NULL END AS ProjectCount,
            CASE WHEN @IncludeProjectData = 1 THEN project_data.ProjectBudget ELSE NULL END AS ProjectBudget,
            -- Order data (conditional based on parameter)
            CASE WHEN @IncludeOrderData = 1 THEN order_data.OrderCount ELSE NULL END AS OrderCount,
            CASE WHEN @IncludeOrderData = 1 THEN order_data.OrderRevenue ELSE NULL END AS OrderRevenue,
            CASE WHEN @IncludeOrderData = 1 THEN order_data.UniqueCustomers ELSE NULL END AS UniqueCustomers,
            -- Calculated metrics
            CASE 
                WHEN d.Budget > 0 
                THEN employee_data.TotalSalaryCost * 100.0 / d.Budget
                ELSE NULL
            END AS BudgetUtilizationPercent,
            CASE 
                WHEN @IncludeOrderData = 1 AND employee_data.TotalSalaryCost > 0
                THEN order_data.OrderRevenue / employee_data.TotalSalaryCost
                ELSE NULL
            END AS RevenueToSalaryRatio,
            -- Date range information
            @StartDate AS AnalysisStartDate,
            @EndDate AS AnalysisEndDate,
            DATEDIFF(MONTH, @StartDate, @EndDate) AS AnalysisPeriodMonths
        FROM Departments d
        INNER JOIN (
            -- Employee cost aggregation
            SELECT 
                e.DepartmentID,
                COUNT(*) AS EmployeeCount,
                SUM(e.BaseSalary) AS TotalBaseSalaryCost,
                AVG(e.BaseSalary) AS AverageBaseSalary
            FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
            WHERE e.IsActive = 1
            GROUP BY e.DepartmentID
        ) employee_data ON d.DepartmentID = employee_data.DepartmentID
        LEFT JOIN (
            -- Project data aggregation (only if parameter enabled)
            SELECT 
                e.DepartmentID,
                COUNT(DISTINCT p.ProjectID) AS ProjectCount,
                SUM(p.Budget) AS ProjectBudget
            FROM Projects p
            INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
            WHERE p.IsActive = 1
              AND e.IsActive = 1
              AND (@IncludeProjectData = 1)
              AND p.StartDate >= @StartDate
              AND p.StartDate <= @EndDate
            GROUP BY e.DepartmentID
        ) project_data ON d.DepartmentID = project_data.DepartmentID
        LEFT JOIN (
            -- Order data aggregation (only if parameter enabled)
            SELECT 
                e.DepartmentID,
                COUNT(o.OrderID) AS OrderCount,
                SUM(o.TotalAmount) AS OrderRevenue,
                COUNT(DISTINCT o.CustomerID) AS UniqueCustomers
            FROM Orders o
            INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
            WHERE o.IsActive = 1
              AND e.IsActive = 1
              AND (@IncludeOrderData = 1)
              AND o.OrderDate >= @StartDate
              AND o.OrderDate <= @EndDate
              AND o.TotalAmount >= @MinimumOrderValue
            GROUP BY e.DepartmentID
        ) order_data ON d.DepartmentID = order_data.DepartmentID
        WHERE d.IsActive = 1
          AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    )
    -- Final result set based on grouping level parameter
    SELECT 
        CASE @GroupingLevel
            WHEN 'Department' THEN d.DepartmentName
            WHEN 'Location' THEN Location
            WHEN 'Both' THEN Location + ' - ' + d.DepartmentName
        END AS GroupingCategory,
        CASE @GroupingLevel
            WHEN 'Department' THEN d.DepartmentName
            WHEN 'Location' THEN 'Multiple Departments'
            WHEN 'Both' THEN d.DepartmentName
        END AS DetailLevel,
        CASE @GroupingLevel
            WHEN 'Location' THEN NULL
            ELSE d.DepartmentName
        END AS DepartmentName,
        CASE @GroupingLevel
            WHEN 'Department' THEN NULL
            ELSE Location
        END AS Location,
        -- Aggregated metrics based on grouping
        SUM(EmployeeCount) AS TotalEmployees,
        FORMAT(SUM(TotalSalaryCost), 'C') AS TotalBaseSalaryCost,
        FORMAT(AVG(AverageSalary), 'C') AS AverageSalaryAcrossGroup,
        FORMAT(SUM(BudgetAmount), 'C') AS TotalBudget,
        -- Conditional metrics based on parameters
        CASE WHEN @IncludeProjectData = 1 THEN SUM(ProjectCount) ELSE NULL END AS TotalProjects,
        CASE WHEN @IncludeProjectData = 1 THEN FORMAT(SUM(ProjectBudget), 'C') ELSE NULL END AS TotalProjectBudget,
        CASE WHEN @IncludeOrderData = 1 THEN SUM(OrderCount) ELSE NULL END AS TotalOrders,
        CASE WHEN @IncludeOrderData = 1 THEN FORMAT(SUM(OrderRevenue), 'C') ELSE NULL END AS TotalRevenue,
        CASE WHEN @IncludeOrderData = 1 THEN SUM(UniqueCustomers) ELSE NULL END AS TotalUniqueCustomers,
        -- Performance metrics
        CAST(AVG(BudgetUtilizationPercent) AS DECIMAL(5,2)) AS AvgBudgetUtilization,
        CASE 
            WHEN @IncludeOrderData = 1 
            THEN CAST(AVG(RevenueToSalaryRatio) AS DECIMAL(5,2))
            ELSE NULL
        END AS AvgRevenueToSalaryRatio,
        -- Analysis metadata
        MIN(AnalysisStartDate) AS AnalysisStartDate,
        MAX(AnalysisEndDate) AS AnalysisEndDate,
        MAX(AnalysisPeriodMonths) AS AnalysisPeriodMonths,
        @GroupingLevel AS GroupingLevel,
        @IncludeProjectData AS ProjectDataIncluded,
        @IncludeOrderData AS OrderDataIncluded
    FROM DepartmentFinancials
    GROUP BY 
        CASE @GroupingLevel
            WHEN 'Department' THEN d.DepartmentName
            WHEN 'Location' THEN Location
            WHEN 'Both' THEN Location + ' - ' + d.DepartmentName
        END,
        CASE @GroupingLevel
            WHEN 'Location' THEN NULL
            ELSE d.DepartmentName
        END,
        CASE @GroupingLevel
            WHEN 'Department' THEN NULL
            ELSE Location
        END
    ORDER BY 
        TotalSalaryCost DESC,
        GroupingCategory;
    
    RETURN 0;  -- Success
END;

-- Example executions with different parameter combinations
-- Basic d.DepartmentName analysis
EXEC sp_AnalyzeDepartmentFinancials @DepartmentID = 2001;

-- Date range analysis with project data only
EXEC sp_AnalyzeDepartmentFinancials 
    @StartDate = '2024-01-01',
    @EndDate = '2024-12-31',
    @IncludeProjectData = 1,
    @IncludeOrderData = 0;

-- Location-based grouping with order filtering
EXEC sp_AnalyzeDepartmentFinancials 
    @GroupingLevel = 'Location',
    @IncludeOrderData = 1,
    @MinimumOrderValue = 5000;

-- Comprehensive analysis with all parameters
EXEC sp_AnalyzeDepartmentFinancials 
    @StartDate = '2023-01-01',
    @EndDate = '2025-12-31',
    @IncludeProjectData = 1,
    @IncludeOrderData = 1,
    @MinimumOrderValue = 1000,
    @GroupingLevel = 'Both';
```

## Output Parameters - Data Return Mechanisms

### 1. Comprehensive Employee Statistics with Output Parameters

#### TechCorp Example: Employee Statistics Calculator
```sql
-- Create procedure with multiple output parameters for comprehensive statistics
CREATE PROCEDURE sp_CalculateEmployeeStatistics
    @DepartmentID INT = NULL,
    @AnalysisPeriodMonths INT = 12,
    -- Output parameters for statistics
    @TotalEmployees INT OUTPUT,
    @ActiveEmployees INT OUTPUT,
    @AverageSalary DECIMAL(10,2) OUTPUT,
    @MedianSalary DECIMAL(10,2) OUTPUT,
    @MinSalary DECIMAL(10,2) OUTPUT,
    @MaxSalary DECIMAL(10,2) OUTPUT,
    @TotalPayroll DECIMAL(12,2) OUTPUT,
    @ProjectEngagementRate DECIMAL(5,2) OUTPUT,
    @CustomerServiceRate DECIMAL(5,2) OUTPUT,
    @AverageYearsOfService DECIMAL(5,2) OUTPUT,
    @StatusMessage VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize output parameters
    SET @TotalEmployees = 0;
    SET @ActiveEmployees = 0;
    SET @AverageSalary = 0;
    SET @MedianSalary = 0;
    SET @MinSalary = 0;
    SET @MaxSalary = 0;
    SET @TotalPayroll = 0;
    SET @ProjectEngagementRate = 0;
    SET @CustomerServiceRate = 0;
    SET @AverageYearsOfService = 0;
    SET @StatusMessage = '';
    
    -- Input validation
    IF @AnalysisPeriodMonths <= 0 OR @AnalysisPeriodMonths > 120
    BEGIN
        SET @StatusMessage = 'Error: Analysis period must be between 1 and 120 months.';
        RETURN -1;
    END
    
    -- Validate d.DepartmentName exists if specified
    IF @DepartmentID IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Departments WHERE DepartmentID = @DepartmentID AND IsActive = 1
    )
    BEGIN
        SET @StatusMessage = 'Error: d.DepartmentName ID ' + CAST(@DepartmentID AS VARCHAR) + ' does not exist or is inactive.';
        RETURN -2;
    END
    
    -- Calculate basic employee statistics
    SELECT 
        @TotalEmployees = COUNT(*),
        @ActiveEmployees = SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
        @AverageSalary = AVG(CASE WHEN IsActive = 1 THEN BaseSalary ELSE NULL END),
        @MinSalary = MIN(CASE WHEN IsActive = 1 THEN BaseSalary ELSE NULL END),
        @MaxSalary = MAX(CASE WHEN IsActive = 1 THEN BaseSalary ELSE NULL END),
        @TotalPayroll = SUM(CASE WHEN IsActive = 1 THEN BaseSalary ELSE 0 END),
        @AverageYearsOfService = AVG(CASE WHEN IsActive = 1 THEN DATEDIFF(YEAR, HireDate, GETDATE()) ELSE NULL END)
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.IsActive = 1
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID);
    
    -- Calculate median BaseSalary using a more complex query
    WITH SalaryRanked AS (
        SELECT 
            BaseSalary,
            ROW_NUMBER() OVER (ORDER BY BaseSalary) AS RowAsc,
            ROW_NUMBER() OVER (ORDER BY BaseSalary DESC) AS RowDesc
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        WHERE e.IsActive = 1
          AND d.IsActive = 1
          AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
    )
    SELECT @MedianSalary = AVG(e.BaseSalary)
    FROM SalaryRanked
    WHERE RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1);
    
    -- Calculate project engagement rate
    SELECT @ProjectEngagementRate = 
        CASE 
            WHEN @ActiveEmployees > 0 
            THEN CAST(COUNT(DISTINCT ep.EmployeeID) * 100.0 / @ActiveEmployees AS DECIMAL(5,2))
            ELSE 0
        END
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND ep.IsActive = 1
      AND ep.StartDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID);
    
    -- Calculate customer service rate
    SELECT @CustomerServiceRate = 
        CASE 
            WHEN @ActiveEmployees > 0 
            THEN CAST(COUNT(DISTINCT o.EmployeeID) * 100.0 / @ActiveEmployees AS DECIMAL(5,2))
            ELSE 0
        END
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID);
    
    -- Set success status message with summary
    SET @StatusMessage = 'Success: Analyzed ' + CAST(@TotalEmployees AS VARCHAR) + ' total employees';
    IF @DepartmentID IS NOT NULL
    BEGIN
        DECLARE @DeptName VARCHAR(100);
        SELECT @DeptName = d.DepartmentName FROM Departments WHERE DepartmentID = @DepartmentID;
        SET @StatusMessage = @StatusMessage + ' in ' + @DeptName + ' department';
    END
    SET @StatusMessage = @StatusMessage + ' over ' + CAST(@AnalysisPeriodMonths AS VARCHAR) + ' month period.';
    
    RETURN 0;  -- Success
END;

-- Example usage with output parameters
DECLARE 
    @TotalEmps INT,
    @ActiveEmps INT,
    @AvgSalary DECIMAL(10,2),
    @MedianSalary DECIMAL(10,2),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @TotalPayroll DECIMAL(12,2),
    @ProjectRate DECIMAL(5,2),
    @CustomerRate DECIMAL(5,2),
    @AvgYears DECIMAL(5,2),
    @Status VARCHAR(500),
    @ReturnCode INT;

-- Execute procedure for IT d.DepartmentName
EXEC @ReturnCode = sp_CalculateEmployeeStatistics 
    @DepartmentID = 2001,
    @AnalysisPeriodMonths = 12,
    @TotalEmployees = @TotalEmps OUTPUT,
    @ActiveEmployees = @ActiveEmps OUTPUT,
    @AverageSalary = @AvgSalary OUTPUT,
    @MedianSalary = @MedianSalary OUTPUT,
    @MinSalary = @MinSalary OUTPUT,
    @MaxSalary = @MaxSalary OUTPUT,
    @TotalPayroll = @TotalPayroll OUTPUT,
    @ProjectEngagementRate = @ProjectRate OUTPUT,
    @CustomerServiceRate = @CustomerRate OUTPUT,
    @AverageYearsOfService = @AvgYears OUTPUT,
    @StatusMessage = @Status OUTPUT;

-- Display results
SELECT 
    @ReturnCode AS ReturnCode,
    @Status AS StatusMessage,
    @TotalEmps AS TotalEmployees,
    @ActiveEmps AS ActiveEmployees,
    FORMAT(@AvgSalary, 'C') AS AverageBaseSalary,
    FORMAT(@MedianSalary, 'C') AS MedianSalary,
    FORMAT(@MinSalary, 'C') AS MinimumSalary,
    FORMAT(@MaxSalary, 'C') AS MaximumSalary,
    FORMAT(@TotalPayroll, 'C') AS TotalPayroll,
    CAST(@ProjectRate AS VARCHAR) + '%' AS ProjectEngagementRate,
    CAST(@CustomerRate AS VARCHAR) + '%' AS CustomerServiceRate,
    CAST(@AvgYears AS VARCHAR) + ' years' AS AverageYearsOfService;
```

### 2. Customer Order Processing with Output Parameters

#### TechCorp Example: Order Processing with Statistics
```sql
-- Create order processing procedure with comprehensive output parameters
CREATE PROCEDURE sp_ProcessCustomerOrderBatch
    @CustomerID INT,
    @ProcessingEmployeeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @MinOrderValue DECIMAL(10,2) = 0,
    -- Output parameters for processing results
    @OrdersProcessed INT OUTPUT,
    @TotalOrderValue DECIMAL(12,2) OUTPUT,
    @AverageOrderValue DECIMAL(10,2) OUTPUT,
    @ProcessingErrors INT OUTPUT,
    @CustomerTotalLifetimeValue DECIMAL(12,2) OUTPUT,
    @ProcessingDurationMinutes INT OUTPUT,
    @StatusSummary VARCHAR(1000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @ProcessingStartTime DATETIME = GETDATE();
    
    -- Initialize output parameters
    SET @OrdersProcessed = 0;
    SET @TotalOrderValue = 0;
    SET @AverageOrderValue = 0;
    SET @ProcessingErrors = 0;
    SET @CustomerTotalLifetimeValue = 0;
    SET @ProcessingDurationMinutes = 0;
    SET @StatusSummary = '';
    
    -- Input validation
    IF @CustomerID IS NULL OR NOT EXISTS (
        SELECT 1 FROM Customers WHERE CustomerID = @CustomerID AND IsActive = 1
    )
    BEGIN
        SET @StatusSummary = 'Error: Invalid or inactive customer ID.';
        SET @ProcessingErrors = 1;
        RETURN -1;
    END
    
    IF @ProcessingEmployeeID IS NULL OR NOT EXISTS (
        SELECT 1 FROM Employees WHERE EmployeeID = @ProcessingEmployeeID AND IsActive = 1
    )
    BEGIN
        SET @StatusSummary = 'Error: Invalid or inactive processing employee ID.';
        SET @ProcessingErrors = 1;
        RETURN -2;
    END
    
    IF @StartDate > @EndDate
    BEGIN
        SET @StatusSummary = 'Error: Start date cannot be greater than end date.';
        SET @ProcessingErrors = 1;
        RETURN -3;
    END
    
    -- Get customer information for status message
    DECLARE @CustomerName VARCHAR(200), @EmployeeName VARCHAR(200);
    
    SELECT @CustomerName = CompanyName
    FROM Customers 
    WHERE CustomerID = @CustomerID;
    
    SELECT @EmployeeName = FirstName + ' ' + LastName
    FROM Employees 
    WHERE EmployeeID = @ProcessingEmployeeID;
    
    -- Process orders in the specified date range
    SELECT 
        @OrdersProcessed = COUNT(*),
        @TotalOrderValue = SUM(TotalAmount),
        @AverageOrderValue = AVG(TotalAmount)
    FROM Orders
    WHERE CustomerID = @CustomerID
      AND IsActive = 1
      AND OrderDate BETWEEN @StartDate AND @EndDate
      AND TotalAmount >= @MinOrderValue
      AND EmployeeID = @ProcessingEmployeeID;
    
    -- Calculate customer's total lifetime value
    SELECT @CustomerTotalLifetimeValue = ISNULL(SUM(TotalAmount), 0)
    FROM Orders
    WHERE CustomerID = @CustomerID AND IsActive = 1;
    
    -- Calculate processing duration
    SET @ProcessingDurationMinutes = DATEDIFF(MINUTE, @ProcessingStartTime, GETDATE());
    
    -- Build comprehensive status summary
    SET @StatusSummary = 'Processing completed successfully. ';
    SET @StatusSummary = @StatusSummary + 'Customer: ' + @CustomerName + '. ';
    SET @StatusSummary = @StatusSummary + 'Processed by: ' + @EmployeeName + '. ';
    SET @StatusSummary = @StatusSummary + 'Date range: ' + CAST(@StartDate AS VARCHAR) + ' to ' + CAST(@EndDate AS VARCHAR) + '. ';
    SET @StatusSummary = @StatusSummary + 'Orders processed: ' + CAST(@OrdersProcessed AS VARCHAR) + '. ';
    SET @StatusSummary = @StatusSummary + 'Total value: ' + FORMAT(@TotalOrderValue, 'C') + '. ';
    
    IF @OrdersProcessed > 0
    BEGIN
        SET @StatusSummary = @StatusSummary + 'Average order value: ' + FORMAT(@AverageOrderValue, 'C') + '. ';
    END
    
    SET @StatusSummary = @StatusSummary + 'Customer lifetime value: ' + FORMAT(@CustomerTotalLifetimeValue, 'C') + '. ';
    SET @StatusSummary = @StatusSummary + 'Processing duration: ' + CAST(@ProcessingDurationMinutes AS VARCHAR) + ' minutes.';
    
    -- Performance classification
    IF @OrdersProcessed = 0
    BEGIN
        SET @StatusSummary = @StatusSummary + ' Note: No orders found matching criteria.';
    END
    ELSE IF @OrdersProcessed >= 10
    BEGIN
        SET @StatusSummary = @StatusSummary + ' High-volume processing completed.';
    END
    ELSE IF @TotalOrderValue >= 50000
    BEGIN
        SET @StatusSummary = @StatusSummary + ' High-value processing completed.';
    END
    
    RETURN 0;  -- Success
END;

-- Example usage of order processing procedure
DECLARE 
    @OrdersProc INT,
    @TotalValue DECIMAL(12,2),
    @AvgValue DECIMAL(10,2),
    @Errors INT,
    @LifetimeValue DECIMAL(12,2),
    @Duration INT,
    @Summary VARCHAR(1000),
    @Result INT;

-- Execute order processing
EXEC @Result = sp_ProcessCustomerOrderBatch
    @CustomerID = 6001,
    @ProcessingEmployeeID = 3001,
    @StartDate = '2025-01-01',
    @EndDate = '2025-12-31',
    @MinOrderValue = 1000,
    @OrdersProcessed = @OrdersProc OUTPUT,
    @TotalOrderValue = @TotalValue OUTPUT,
    @AverageOrderValue = @AvgValue OUTPUT,
    @ProcessingErrors = @Errors OUTPUT,
    @CustomerTotalLifetimeValue = @LifetimeValue OUTPUT,
    @ProcessingDurationMinutes = @Duration OUTPUT,
    @StatusSummary = @Summary OUTPUT;

-- Display comprehensive results
SELECT 
    @Result AS ReturnCode,
    @OrdersProc AS OrdersProcessed,
    FORMAT(@TotalValue, 'C') AS TotalOrderValue,
    FORMAT(@AvgValue, 'C') AS AverageOrderValue,
    @Errors AS ProcessingErrors,
    FORMAT(@LifetimeValue, 'C') AS CustomerLifetimeValue,
    @Duration AS ProcessingDurationMinutes,
    @Summary AS StatusSummary;
```

## Input/Output Parameters - Bidirectional Data Flow

### 1. Employee Performance Calculator with Bidirectional Parameters

#### TechCorp Example: Performance Rating Calculator
```sql
-- Create procedure with input/output parameters for performance calculations
CREATE PROCEDURE sp_CalculateEmployeePerformanceRating
    @EmployeeID INT,
    @PerformancePeriodMonths INT = 12,
    -- Bidirectional parameters (can be input with defaults, always output)
    @ProjectScore DECIMAL(5,2) = NULL OUTPUT,
    @CustomerScore DECIMAL(5,2) = NULL OUTPUT,
    @TeamLeadershipScore DECIMAL(5,2) = NULL OUTPUT,
    @OverallRating DECIMAL(5,2) = NULL OUTPUT,
    -- Pure output parameters
    @PerformanceCategory VARCHAR(50) OUTPUT,
    @RecommendedActions VARCHAR(1000) OUTPUT,
    @ComparisonToPeers VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @EmployeeID IS NULL OR NOT EXISTS (
        SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID AND IsActive = 1
    )
    BEGIN
        SET @PerformanceCategory = 'Error: Invalid Employee';
        SET @RecommendedActions = 'Employee ID does not exist or is inactive.';
        RETURN -1;
    END
    
    -- Get employee information
    DECLARE @EmployeeName VARCHAR(200), @DepartmentID INT, @JobTitle VARCHAR(100);
    SELECT 
        @EmployeeName = FirstName + ' ' + LastName,
        @DepartmentID = DepartmentID,
        @JobTitle = JobTitle
    FROM Employees 
    WHERE EmployeeID = @EmployeeID;
    
    -- Calculate or use provided project score
    IF @ProjectScore IS NULL
    BEGIN
        SELECT @ProjectScore = 
            CASE 
                WHEN project_data.ProjectCount >= 5 THEN 95.0
                WHEN project_data.ProjectCount >= 3 THEN 80.0
                WHEN project_data.ProjectCount >= 1 THEN 65.0
                ELSE 30.0
            END +
            CASE 
                WHEN project_data.TotalHours >= 500 THEN 15.0
                WHEN project_data.TotalHours >= 200 THEN 10.0
                WHEN project_data.TotalHours >= 50 THEN 5.0
                ELSE 0.0
            END
        FROM (
            SELECT 
                COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
                SUM(ep.HoursWorked) AS TotalHours
            FROM EmployeeProjects ep
            WHERE ep.EmployeeID = @EmployeeID
              AND ep.IsActive = 1
              AND ep.StartDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE())
        ) project_data;
        
        SET @ProjectScore = ISNULL(@ProjectScore, 30.0);
    END
    
    -- Calculate or use provided customer score
    IF @CustomerScore IS NULL
    BEGIN
        SELECT @CustomerScore = 
            CASE 
                WHEN customer_data.OrderCount >= 50 THEN 95.0
                WHEN customer_data.OrderCount >= 20 THEN 80.0
                WHEN customer_data.OrderCount >= 5 THEN 65.0
                WHEN customer_data.OrderCount >= 1 THEN 50.0
                ELSE 20.0
            END +
            CASE 
                WHEN customer_data.TotalRevenue >= 200000 THEN 15.0
                WHEN customer_data.TotalRevenue >= 100000 THEN 10.0
                WHEN customer_data.TotalRevenue >= 50000 THEN 5.0
                ELSE 0.0
            END
        FROM (
            SELECT 
                COUNT(o.OrderID) AS OrderCount,
                SUM(o.TotalAmount) AS TotalRevenue
            FROM Orders o
            WHERE o.EmployeeID = @EmployeeID
              AND o.IsActive = 1
              AND o.OrderDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE())
        ) customer_data;
        
        SET @CustomerScore = ISNULL(@CustomerScore, 20.0);
    END
    
    -- Calculate or use provided team leadership score
    IF @TeamLeadershipScore IS NULL
    BEGIN
        SELECT @TeamLeadershipScore = 
            CASE 
                WHEN leadership_data.DirectReports >= 10 THEN 95.0
                WHEN leadership_data.DirectReports >= 5 THEN 80.0
                WHEN leadership_data.DirectReports >= 1 THEN 60.0
                ELSE 40.0
            END +
            CASE 
                WHEN leadership_data.ManagedProjects >= 3 THEN 15.0
                WHEN leadership_data.ManagedProjects >= 1 THEN 10.0
                ELSE 0.0
            END
        FROM (
            SELECT 
                (SELECT COUNT(*) FROM Employees WHERE ManagerID = @EmployeeID AND IsActive = 1) AS DirectReports,
                (SELECT COUNT(*) FROM Projects WHERE ProjectManagerID = @EmployeeID AND IsActive = 1) AS ManagedProjects
        ) leadership_data;
        
        SET @TeamLeadershipScore = ISNULL(@TeamLeadershipScore, 40.0);
    END
    
    -- Calculate overall rating if not provided
    IF @OverallRating IS NULL
    BEGIN
        SET @OverallRating = (@ProjectScore * 0.4) + (@CustomerScore * 0.3) + (@TeamLeadershipScore * 0.3);
    END
    
    -- Determine performance category
    SET @PerformanceCategory = 
        CASE 
            WHEN @OverallRating >= 90 THEN 'Exceptional Performer'
            WHEN @OverallRating >= 80 THEN 'High Performer'
            WHEN @OverallRating >= 70 THEN 'Strong Performer'
            WHEN @OverallRating >= 60 THEN 'Solid Performer'
            WHEN @OverallRating >= 50 THEN 'Meets Expectations'
            WHEN @OverallRating >= 40 THEN 'Needs Improvement'
            ELSE 'Below Expectations'
        END;
    
    -- Generate recommended actions
    SET @RecommendedActions = 'Performance Analysis for ' + @EmployeeName + ': ';
    
    IF @ProjectScore < 60
        SET @RecommendedActions = @RecommendedActions + 'Increase project involvement and responsibility. ';
    ELSE IF @ProjectScore >= 90
        SET @RecommendedActions = @RecommendedActions + 'Excellent project leadership - consider mentoring others. ';
    
    IF @CustomerScore < 60
        SET @RecommendedActions = @RecommendedActions + 'Enhance customer interaction and service skills. ';
    ELSE IF @CustomerScore >= 90
        SET @RecommendedActions = @RecommendedActions + 'Outstanding customer relations - lead service initiatives. ';
    
    IF @TeamLeadershipScore < 60
        SET @RecommendedActions = @RecommendedActions + 'Develop leadership and team management skills. ';
    ELSE IF @TeamLeadershipScore >= 90
        SET @RecommendedActions = @RecommendedActions + 'Strong leadership - consider senior management roles. ';
    
    -- Compare to d.DepartmentName peers
    DECLARE @DeptAvgRating DECIMAL(5,2);
    
    -- This would typically call the same procedure recursively for all dept employees
    -- For simplicity, we'll use a direct calculation
    SELECT @DeptAvgRating = AVG(calculated_rating.rating)
    FROM (
        SELECT 
            e.EmployeeID,
            -- Simplified rating calculation for comparison
            (ISNULL(proj.score, 30) * 0.4) + (ISNULL(cust.score, 20) * 0.3) + (ISNULL(lead.score, 40) * 0.3) AS rating
        FROM Employees e
        LEFT JOIN (
            SELECT 
                ep.EmployeeID,
                CASE WHEN COUNT(DISTINCT ep.ProjectID) >= 3 THEN 80 ELSE 40 END AS score
            FROM EmployeeProjects ep
            WHERE ep.IsActive = 1
            GROUP BY ep.EmployeeID
        ) proj ON e.EmployeeID = proj.EmployeeID
        LEFT JOIN (
            SELECT 
                o.EmployeeID,
                CASE WHEN COUNT(o.OrderID) >= 10 THEN 75 ELSE 35 END AS score
            FROM Orders o
            WHERE o.IsActive = 1
            GROUP BY o.EmployeeID
        ) cust ON e.EmployeeID = cust.EmployeeID
        LEFT JOIN (
            SELECT 
                mgr.EmployeeID,
                CASE WHEN COUNT(sub.EmployeeID) >= 2 THEN 70 ELSE 45 END AS score
            FROM Employees mgr
            LEFT JOIN Employees sub ON mgr.EmployeeID = sub.ManagerID
            GROUP BY mgr.EmployeeID
        ) lead ON e.EmployeeID = lead.EmployeeID
        WHERE e.DepartmentID = @DepartmentID 
          AND e.IsActive = 1
          AND e.EmployeeID != @EmployeeID
    ) calculated_rating;
    
    SET @ComparisonToPeers = 
        CASE 
            WHEN @OverallRating > @DeptAvgRating + 10 THEN 'Significantly above d.DepartmentName average'
            WHEN @OverallRating > @DeptAvgRating + 5 THEN 'Above d.DepartmentName average'
            WHEN @OverallRating > @DeptAvgRating - 5 THEN 'At d.DepartmentName average'
            WHEN @OverallRating > @DeptAvgRating - 10 THEN 'Below d.DepartmentName average'
            ELSE 'Significantly below d.DepartmentName average'
        END + ' (Dept Avg: ' + CAST(ROUND(@DeptAvgRating, 1) AS VARCHAR) + ')';
    
    RETURN 0;  -- Success
END;

-- Example usage with input/output parameters
DECLARE 
    @ProjScore DECIMAL(5,2) = 75.0,  -- Provide initial project score
    @CustScore DECIMAL(5,2),         -- Let procedure calculate
    @LeadScore DECIMAL(5,2),         -- Let procedure calculate
    @OverallRat DECIMAL(5,2),        -- Let procedure calculate
    @Category VARCHAR(50),
    @Actions VARCHAR(1000),
    @Comparison VARCHAR(200),
    @Result INT;

-- Execute performance calculation
EXEC @Result = sp_CalculateEmployeePerformanceRating
    @EmployeeID = 3001,
    @PerformancePeriodMonths = 12,
    @ProjectScore = @ProjScore OUTPUT,          -- Input/Output
    @CustomerScore = @CustScore OUTPUT,         -- Output only
    @TeamLeadershipScore = @LeadScore OUTPUT,   -- Output only
    @OverallRating = @OverallRat OUTPUT,        -- Output only
    @PerformanceCategory = @Category OUTPUT,
    @RecommendedActions = @Actions OUTPUT,
    @ComparisonToPeers = @Comparison OUTPUT;

-- Display comprehensive performance results
SELECT 
    @Result AS ReturnCode,
    @ProjScore AS ProjectScore,
    @CustScore AS CustomerScore,
    @LeadScore AS TeamLeadershipScore,
    @OverallRat AS OverallRating,
    @Category AS PerformanceCategory,
    @Actions AS RecommendedActions,
    @Comparison AS ComparisonToPeers;
```

## Best Practices for Parameter Usage

### 1. Parameter Validation and Error Handling

```sql
-- ✅ GOOD: Comprehensive parameter validation
CREATE PROCEDURE sp_ValidateParametersExample
    @EmployeeID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @MaxResults INT = 100,
    @SortOrder VARCHAR(10) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Required parameter validation
    IF @EmployeeID IS NULL OR @EmployeeID <= 0
    BEGIN
        RAISERROR('EmployeeID is required and must be positive.', 16, 1);
        RETURN -1;
    END
    
    -- Business rule validation
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        RAISERROR('Employee ID %d does not exist.', 16, 1, @EmployeeID);
        RETURN -2;
    END
    
    -- Date range validation
    IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate > @EndDate
    BEGIN
        RAISERROR('Start date cannot be greater than end date.', 16, 1);
        RETURN -3;
    END
    
    -- Range validation
    IF @MaxResults <= 0 OR @MaxResults > 1000
    BEGIN
        SET @MaxResults = 100;  -- Use default instead of error
    END
    
    -- Enumeration validation
    IF @SortOrder NOT IN ('ASC', 'DESC')
    BEGIN
        SET @SortOrder = 'ASC';  -- Default to valid value
    END
    
    -- Set defaults for optional parameters
    SET @StartDate = ISNULL(@StartDate, DATEADD(YEAR, -1, GETDATE()));
    SET @EndDate = ISNULL(@EndDate, GETDATE());
    
    -- Procedure logic continues...
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle
    FROM Employees e
    WHERE e.EmployeeID = @EmployeeID;
    
    RETURN 0;  -- Success
END;
```

### 2. Optimal Parameter Design Patterns

```sql
-- ✅ GOOD: Well-designed parameter structure
CREATE PROCEDURE sp_ParameterDesignExample
    -- Group related parameters
    -- Employee filtering
    @EmployeeID INT = NULL,
    @DepartmentID INT = NULL,
    @ManagerID INT = NULL,
    
    -- Date range filtering
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @DateRangeType VARCHAR(20) = 'Custom',  -- 'LastMonth', 'LastQuarter', 'LastYear', 'Custom'
    
    -- Output options
    @IncludeInactive BIT = 0,
    @IncludeDetails BIT = 1,
    @MaxResults INT = 100,
    
    -- Sorting and formatting
    @SortBy VARCHAR(20) = 'LastName',
    @SortDirection VARCHAR(4) = 'ASC',
    @OutputFormat VARCHAR(10) = 'Standard'  -- 'Standard', 'Summary', 'Detailed'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set date range based on type parameter
    IF @DateRangeType != 'Custom'
    BEGIN
        SET @EndDate = GETDATE();
        SET @StartDate = 
            CASE @DateRangeType
                WHEN 'LastMonth' THEN DATEADD(MONTH, -1, @EndDate)
                WHEN 'LastQuarter' THEN DATEADD(QUARTER, -1, @EndDate)
                WHEN 'LastYear' THEN DATEADD(YEAR, -1, @EndDate)
                ELSE DATEADD(YEAR, -1, @EndDate)
            END;
    END
    
    -- Use parameters to control query behavior
    -- Implementation continues...
    
    RETURN 0;
END;
```

## Summary

Parameter usage in stored procedures provides TechCorp with powerful capabilities for flexible and secure database operations:

**Key Benefits:**
- **Flexibility**: Dynamic procedure behavior based on runtime parameters
- **Security**: Prevention of SQL injection through parameterized queries
- **Reusability**: Single procedures serving multiple business scenarios
- **Maintainability**: Centralized parameter validation and business logic
- **Performance**: Optimized execution plans with parameter sniffing

**Parameter Types:**
- **Input Parameters**: Pass data to procedures for processing and filtering
- **Output Parameters**: Return calculated values and processing results
- **Input/Output Parameters**: Bidirectional data flow for complex scenarios
- **Return Values**: Status codes and error handling mechanisms

**Business Applications:**
- Dynamic reporting with user-selected criteria
- Comprehensive business analytics with flexible parameters
- Data processing workflows with status reporting
- Performance calculations with customizable metrics
- Batch processing operations with progress tracking

**Best Practices:**
- Implement comprehensive parameter validation
- Use appropriate default values for optional parameters
- Group related parameters logically
- Provide meaningful error messages and return codes
- Document parameter usage and valid ranges

Parameter-driven stored procedures enable TechCorp to create robust, flexible, and secure database solutions that adapt to varying business requirements while maintaining high performance and data integrity standards.