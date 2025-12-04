# Lesson 1: T-SQL Programming Elements

## Overview

T-SQL programming elements form the foundation of advanced database programming, enabling developers to create sophisticated applications that go beyond simple queries. These elements include variables, control flow structures, functions, and advanced programming constructs that allow for complex business logic implementation within the database layer. For TechCorp's development teams, mastering T-SQL programming elements is essential for building robust, scalable database applications that can handle complex business requirements while maintaining performance and reliability standards.

## 🏢 TechCorp Business Context

**T-SQL Programming in Enterprise Development:**

- **Business Logic Implementation**: Complex calculations and decision-making processes
- **Data Processing Automation**: Batch processing and data transformation workflows  
- **Application Integration**: Database-driven application logic and validation
- **Performance Optimization**: Efficient data processing using set-based operations
- **Error Handling and Logging**: Comprehensive error management and audit trails

### 📋 TechCorp Database Schema Reference

**Core Tables for Programming Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## T-SQL Variables and Data Types

### Variable Declaration and Assignment

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        T-SQL Variable Management                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Variable Declaration Patterns:                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ DECLARE @VariableName DataType [= InitialValue];                   │   │
│  │ DECLARE @Counter INT = 0;                                          │   │
│  │ DECLARE @EmployeeName VARCHAR(100);                                │   │
│  │ DECLARE @SalaryTotal DECIMAL(12,2) = 0.00;                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Variable Assignment Methods:                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ SET @Variable = Value;              -- Single value assignment     │   │
│  │ SELECT @Variable = Column FROM Table; -- Query-based assignment    │   │
│  │ SELECT @Var1 = Col1, @Var2 = Col2;   -- Multiple assignments      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Variable Scope:                                                           │
│  • Local variables: Valid within current batch/procedure                  │
│  • Global variables: System-defined (@@ROWCOUNT, @@ERROR, etc.)          │
│  • Table variables: Temporary result sets with limited scope             │
│                                                                             │
│  Best Practices:                                                           │
│  • Initialize variables to avoid NULL issues                              │
│  • Use appropriate data types for performance                             │
│  • Meaningful naming conventions with prefixes                            │
│  • Consider scope and lifetime requirements                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Basic Variable Operations

#### TechCorp Example: Employee e.BaseSalary Analysis Variables

```sql
-- Demonstrate variable declaration and usage for TechCorp e.BaseSalary analysis
DECLARE @CurrentDate DATE = GETDATE();
DECLARE @AnalysisYear INT = YEAR(@CurrentDate);
DECLARE @d.DepartmentID INT = 2001; -- Engineering d.DepartmentName
DECLARE @MinSalary DECIMAL(10,2) = 0;
DECLARE @MaxSalary DECIMAL(10,2) = 0;
DECLARE @AverageSalary DECIMAL(10,2) = 0;
DECLARE @EmployeeCount INT = 0;
DECLARE @TotalPayroll DECIMAL(12,2) = 0;
DECLARE @d.DepartmentName VARCHAR(100);
DECLARE @ReportTitle VARCHAR(200);

-- Single variable assignment using SET
SET @ReportTitle = 'TechCorp e.BaseSalary Analysis Report - ' + CAST(@AnalysisYear AS VARCHAR(4));

-- Multiple variable assignment using SELECT
SELECT @d.DepartmentName = d.DepartmentName,
    @EmployeeCount = COUNT(e.EmployeeID),
    @MinSalary = MIN(e.BaseSalary),
    @MaxSalary = MAX(e.BaseSalary),
    @AverageSalary = AVG(e.BaseSalary),
    @TotalPayroll = SUM(e.BaseSalary)
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = d.DepartmentID
WHERE d.DepartmentID = @d.DepartmentID
  AND d.IsActive = 1
  AND e.IsActive = 1
GROUP BY d.DepartmentName;

-- Display results using variables
SELECT 
    @ReportTitle AS ReportTitle,
    @CurrentDate AS ReportDate,
    @d.DepartmentName AS d.DepartmentName,
    @EmployeeCount AS TotalEmployees,
    FORMAT(@MinSalary, 'C') AS MinimumSalary,
    FORMAT(@MaxSalary, 'C') AS MaximumSalary,
    FORMAT(@AverageSalary, 'C') AS AverageBaseSalary,
    FORMAT(@TotalPayroll, 'C') AS TotalPayroll,
    -- Calculated fields using variables
    FORMAT(@TotalPayroll / @EmployeeCount, 'C') AS CalculatedAverage,
    FORMAT((@MaxSalary - @MinSalary), 'C') AS SalaryRange,
    CASE 
        WHEN @AverageSalary >= 80000 THEN 'High Compensation Department'
        WHEN @AverageSalary >= 60000 THEN 'Competitive Compensation Department'
        WHEN @AverageSalary >= 40000 THEN 'Standard Compensation Department'
        ELSE 'Entry Level Department'
    END AS DepartmentClassification;

-- Variable-driven conditional logic
IF @AverageSalary > 75000
BEGIN
    PRINT 'Department ' + @d.DepartmentName + ' has above-average compensation levels.';
    PRINT 'Average e.BaseSalary: ' + FORMAT(@AverageSalary, 'C');
END
ELSE
BEGIN
    PRINT 'Department ' + @d.DepartmentName + ' has standard compensation levels.';
    PRINT 'Consider market analysis for competitive positioning.';
END;

-- Demonstrate variable scope in nested operations
DECLARE @HighPerformerCount INT = 0;
DECLARE @HighPerformerThreshold DECIMAL(10,2) = @AverageSalary * 1.2;

SELECT @HighPerformerCount = COUNT(*)
FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE d.DepartmentID = @d.DepartmentID
  AND e.BaseSalary >= @HighPerformerThreshold
  AND e.IsActive = 1;

PRINT 'High performers (e.BaseSalary >= ' + FORMAT(@HighPerformerThreshold, 'C') + '): ' + CAST(@HighPerformerCount AS VARCHAR);
```

### Advanced Data Types and Table Variables

#### TechCorp Example: Table Variables for Complex Processing

```sql
-- Demonstrate table variables for employee project analysis
DECLARE @EmployeeProjectSummary TABLE (
    e.EmployeeID INT,
    EmployeeName VARCHAR(101),
    d.DepartmentName VARCHAR(100),
    e.BaseSalary DECIMAL(10,2),
    ProjectCount INT,
    TotalHours DECIMAL(8,2),
    AverageHoursPerProject DECIMAL(8,2),
    PerformanceRating VARCHAR(20)
);

-- Populate table variable with complex business logic
INSERT INTO @EmployeeProjectSummary (
    e.EmployeeID, EmployeeName, d.DepartmentName, e.BaseSalary, 
    ProjectCount, TotalHours, AverageHoursPerProject, PerformanceRating
)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.BaseSalary,
    COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
    SUM(ep.HoursWorked) AS TotalHours,
    AVG(ep.HoursWorked) AS AverageHoursPerProject,
    CASE 
        WHEN COUNT(DISTINCT ep.ProjectID) >= 5 AND SUM(ep.HoursWorked) >= 500 THEN 'Exceptional'
        WHEN COUNT(DISTINCT ep.ProjectID) >= 3 AND SUM(ep.HoursWorked) >= 300 THEN 'Outstanding'
        WHEN COUNT(DISTINCT ep.ProjectID) >= 2 AND SUM(ep.HoursWorked) >= 150 THEN 'Good'
        WHEN COUNT(DISTINCT ep.ProjectID) >= 1 THEN 'Satisfactory'
        ELSE 'Needs Improvement'
    END AS PerformanceRating
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID 
                                AND ep.IsActive = 1
                                AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
WHERE e.IsActive = 1
  AND d.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, e.BaseSalary;

-- Use table variable for analysis
DECLARE @TotalEmployeesAnalyzed INT;
DECLARE @ExceptionalPerformers INT;
DECLARE @AverageProjectsPerEmployee DECIMAL(5,2);

SELECT 
    @TotalEmployeesAnalyzed = COUNT(*),
    @ExceptionalPerformers = SUM(CASE WHEN PerformanceRating = 'Exceptional' THEN 1 ELSE 0 END),
    @AverageProjectsPerEmployee = AVG(CAST(ProjectCount AS DECIMAL(5,2)))
FROM @EmployeeProjectSummary;

-- Display comprehensive results
SELECT 
    'TechCorp Employee Performance Analysis' AS ReportTitle,
    GETDATE() AS AnalysisDate,
    @TotalEmployeesAnalyzed AS TotalEmployeesAnalyzed,
    @ExceptionalPerformers AS ExceptionalPerformers,
    FORMAT(CAST(@ExceptionalPerformers AS FLOAT) / @TotalEmployeesAnalyzed * 100, 'N2') + '%' AS ExceptionalPerformerPercentage,
    @AverageProjectsPerEmployee AS AverageProjectsPerEmployee;

-- Display detailed employee analysis
SELECT 
    e.EmployeeID,
    EmployeeName,
    d.DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS e.BaseSalary,
    ProjectCount,
    TotalHours,
    FORMAT(AverageHoursPerProject, 'N1') AS AvgHoursPerProject,
    PerformanceRating,
    -- Additional calculated columns
    CASE 
        WHEN ProjectCount > @AverageProjectsPerEmployee THEN 'Above Average'
        WHEN ProjectCount = @AverageProjectsPerEmployee THEN 'Average'
        ELSE 'Below Average'
    END AS ProjectLoadComparison,
    FORMAT(e.BaseSalary / NULLIF(TotalHours, 0), 'C') AS EffectiveHourlyRate
FROM @EmployeeProjectSummary
ORDER BY 
    CASE PerformanceRating
        WHEN 'Exceptional' THEN 1
        WHEN 'Outstanding' THEN 2
        WHEN 'Good' THEN 3
        WHEN 'Satisfactory' THEN 4
        ELSE 5
    END,
    TotalHours DESC;
```

## T-SQL Functions and Expressions

### Built-in Functions for Business Logic

#### TechCorp Example: Comprehensive Function Usage

```sql
-- Demonstrate various T-SQL functions in TechCorp business context
DECLARE @AnalysisDate DATE = GETDATE();
DECLARE @FiscalYearStart DATE = DATEFROMPARTS(YEAR(@AnalysisDate), 4, 1); -- April 1st fiscal year
DECLARE @QuarterStart DATE;
DECLARE @ReportingPeriod VARCHAR(50);

-- Date/Time function usage
SET @QuarterStart = DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @AnalysisDate), 0);
SET @ReportingPeriod = 'Q' + CAST(DATEPART(QUARTER, @AnalysisDate) AS VARCHAR(1)) + ' ' + CAST(YEAR(@AnalysisDate) AS VARCHAR(4));

-- Advanced employee analysis using multiple function categories
SELECT 
    e.EmployeeID,
    -- String functions
    UPPER(e.LastName) + ', ' + e.FirstName AS FormattedName,
    LEFT(e.FirstName, 1) + LEFT(e.LastName, 1) AS Initials,
    REPLACE(e.WorkEmail, '@techcorp.com', '') AS EmailPrefix,
    LEN(e.FirstName + e.LastName) AS NameLength,
    
    -- Date functions
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, @AnalysisDate) AS YearsOfService,
    DATEDIFF(MONTH, e.HireDate, @AnalysisDate) AS MonthsOfService,
    DATEPART(YEAR, e.HireDate) AS HireYear,
    DATENAME(MONTH, e.HireDate) AS HireMonth,
    EOMONTH(e.HireDate) AS HireMonthEnd,
    
    -- Numeric functions
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    ROUND(e.BaseSalary / 12, 2) AS MonthlySalary,
    CEILING(e.BaseSalary / 2000) AS SalaryBands,
    FLOOR(e.BaseSalary / 10000) * 10000 AS SalaryFloor,
    ABS(e.BaseSalary - 75000) AS DeviationFromBase,
    
    -- Conditional functions
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, @AnalysisDate) >= 10 THEN 'Veteran'
        WHEN DATEDIFF(YEAR, e.HireDate, @AnalysisDate) >= 5 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, e.HireDate, @AnalysisDate) >= 2 THEN 'Established'
        ELSE 'New'
    END AS ServiceCategory,
    
    -- Null handling functions
    ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
    COALESCE(e.JobTitle, 'Position TBD') AS JobTitleOrDefault,
    NULLIF(e.BaseSalary, 0) AS SalaryNullIfZero,
    
    -- System functions
    @@SERVERNAME AS ServerName,
    USER_NAME() AS CurrentUser,
    GETDATE() AS ReportGeneratedAt,
    
    -- Advanced calculations
    CASE 
        WHEN e.HireDate >= @FiscalYearStart THEN 'Current Fiscal Year Hire'
        ELSE 'Previous Fiscal Year Hire'
    END AS FiscalYearHireStatus,
    
    -- d.DepartmentName information
    d.DepartmentName,
    d.Location,
    
    -- Performance metrics using mathematical functions
    CASE 
        WHEN e.BaseSalary > (
            SELECT AVG(e.BaseSalary) * 1.2 
            FROM Employees e 
            WHERE d.DepartmentID = d.DepartmentID AND IsActive = 1
        ) THEN 'High Performer'
        WHEN e.BaseSalary > (
            SELECT AVG(e.BaseSalary) 
            FROM Employees e 
            WHERE d.DepartmentID = d.DepartmentID AND IsActive = 1
        ) THEN 'Above Average'
        ELSE 'Standard'
    END AS SalaryPerformanceIndicator

FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID
WHERE e.IsActive = 1
  AND d.IsActive = 1
ORDER BY d.DepartmentName, e.LastName, e.FirstName;

-- Demonstrate aggregate functions with business logic
SELECT 
    @ReportingPeriod AS ReportingPeriod,
    d.DepartmentName,
    -- Count functions
    COUNT(*) AS TotalEmployees,
    COUNT(e.ManagerID) AS EmployeesWithManagers,
    COUNT(DISTINCT e.JobTitle) AS UniqueJobTitles,
    
    -- Sum functions
    FORMAT(SUM(e.BaseSalary), 'C') AS TotalDepartmentPayroll,
    FORMAT(SUM(CASE WHEN DATEDIFF(YEAR, e.HireDate, @AnalysisDate) >= 5 
                   THEN e.BaseSalary ELSE 0 END), 'C') AS VeteranPayroll,
    
    -- Average functions
    FORMAT(AVG(e.BaseSalary), 'C') AS AverageBaseSalary,
    AVG(DATEDIFF(YEAR, e.HireDate, @AnalysisDate)) AS AverageYearsOfService,
    
    -- Min/Max functions
    FORMAT(MIN(e.BaseSalary), 'C') AS LowestBaseSalary,
    FORMAT(MAX(e.BaseSalary), 'C') AS HighestBaseSalary,
    MIN(e.HireDate) AS EarliestHireDate,
    MAX(e.HireDate) AS LatestHireDate,
    
    -- Statistical functions
    STDEV(e.BaseSalary) AS SalaryStandardDeviation,
    VAR(e.BaseSalary) AS SalaryVariance,
    
    -- Advanced aggregations
    FORMAT(SUM(e.BaseSalary) / NULLIF(SUM(DATEDIFF(YEAR, e.HireDate, @AnalysisDate)), 0), 'C') AS PayrollPerServiceYear,
    
    -- Conditional aggregations
    SUM(CASE WHEN e.BaseSalary >= 80000 THEN 1 ELSE 0 END) AS HighEarners,
    SUM(CASE WHEN DATEDIFF(YEAR, e.HireDate, @AnalysisDate) < 2 THEN 1 ELSE 0 END) AS RecentHires,
    
    -- Percentage calculations
    FORMAT(
        CAST(SUM(CASE WHEN e.BaseSalary >= 80000 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 
        'N2'
    ) + '%' AS HighEarnerPercentage

FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
HAVING COUNT(*) >= 2  -- Only departments with 2+ employees
ORDER BY SUM(e.BaseSalary) DESC;
```

### User-Defined Functions

#### TechCorp Example: Custom Business Functions

```sql
-- Create scalar function for employee performance calculation
CREATE FUNCTION dbo.fn_CalculateEmployeePerformanceScore
(
    @e.EmployeeID INT,
    @EvaluationMonths INT = 12
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @PerformanceScore DECIMAL(5,2) = 0;
    DECLARE @ProjectScore DECIMAL(5,2) = 0;
    DECLARE @CustomerScore DECIMAL(5,2) = 0;
    DECLARE @LeadershipScore DECIMAL(5,2) = 0;
    DECLARE @TenureScore DECIMAL(5,2) = 0;
    
    -- Validate employee exists
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1)
        RETURN 0;
    
    -- Calculate project involvement score (0-40 points)
    SELECT @ProjectScore = 
        CASE 
            WHEN project_stats.ProjectCount >= 5 THEN 40.0
            WHEN project_stats.ProjectCount >= 3 THEN 30.0
            WHEN project_stats.ProjectCount >= 2 THEN 20.0
            WHEN project_stats.ProjectCount >= 1 THEN 10.0
            ELSE 0.0
        END +
        CASE 
            WHEN project_stats.TotalHours >= 1000 THEN 15.0
            WHEN project_stats.TotalHours >= 500 THEN 10.0
            WHEN project_stats.TotalHours >= 200 THEN 5.0
            ELSE 0.0
        END
    FROM (
        SELECT 
            COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
            SUM(ep.HoursWorked) AS TotalHours
        FROM EmployeeProjects ep
        WHERE ep.EmployeeID = @e.EmployeeID
          AND ep.IsActive = 1
          AND ep.StartDate >= DATEADD(MONTH, -@EvaluationMonths, GETDATE())
    ) project_stats;
    
    SET @ProjectScore = ISNULL(@ProjectScore, 0);
    IF @ProjectScore > 40 SET @ProjectScore = 40;
    
    -- Calculate customer service score (0-30 points)
    SELECT @CustomerScore = 
        CASE 
            WHEN COUNT(o.OrderID) >= 50 THEN 30.0
            WHEN COUNT(o.OrderID) >= 25 THEN 25.0
            WHEN COUNT(o.OrderID) >= 10 THEN 20.0
            WHEN COUNT(o.OrderID) >= 5 THEN 15.0
            WHEN COUNT(o.OrderID) >= 1 THEN 10.0
            ELSE 0.0
        END
    FROM Orders o
    WHERE o.EmployeeID = @e.EmployeeID
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -@EvaluationMonths, GETDATE());
    
    SET @CustomerScore = ISNULL(@CustomerScore, 0);
    
    -- Calculate leadership score (0-20 points)
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
            WHEN @ManagedProjects >= 3 THEN 5.0
            WHEN @ManagedProjects >= 1 THEN 3.0
            ELSE 0.0
        END;
    
    -- Calculate tenure score (0-10 points)
    DECLARE @YearsOfService INT;
    SELECT @YearsOfService = DATEDIFF(YEAR, e.HireDate, GETDATE())
    FROM Employees e
    WHERE e.EmployeeID = @e.EmployeeID;
    
    SET @TenureScore = 
        CASE 
            WHEN @YearsOfService >= 10 THEN 10.0
            WHEN @YearsOfService >= 5 THEN 8.0
            WHEN @YearsOfService >= 3 THEN 6.0
            WHEN @YearsOfService >= 1 THEN 4.0
            ELSE 2.0
        END;
    
    -- Calculate total performance score
    SET @PerformanceScore = @ProjectScore + @CustomerScore + @LeadershipScore + @TenureScore;
    
    RETURN @PerformanceScore;
END;

-- Create table-valued function for d.DepartmentName analysis
CREATE FUNCTION dbo.fn_GetDepartmentEmployeeAnalysis
(
    @d.DepartmentID INT,
    @IncludeInactive BIT = 0
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
        e.BaseSalary,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        CASE WHEN e.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS EmployeeStatus,
        
        -- Manager information
        ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
        
        -- Performance score using custom scalar function
        dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) AS PerformanceScore,
        
        -- Performance classification
        CASE 
            WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 90 THEN 'Exceptional'
            WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 75 THEN 'Outstanding'
            WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 60 THEN 'Good'
            WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 40 THEN 'Satisfactory'
            ELSE 'Needs Improvement'
        END AS PerformanceRating,
        
        -- e.BaseSalary analysis
        CASE 
            WHEN e.BaseSalary > (
                SELECT AVG(e.BaseSalary) * 1.2 
                FROM Employees e 
                WHERE d.DepartmentID = @d.DepartmentID AND (IsActive = 1 OR @IncludeInactive = 1)
            ) THEN 'Above Market'
            WHEN e.BaseSalary > (
                SELECT AVG(e.BaseSalary) 
                FROM Employees e 
                WHERE d.DepartmentID = @d.DepartmentID AND (IsActive = 1 OR @IncludeInactive = 1)
            ) THEN 'Competitive'
            ELSE 'Below Market'
        END AS SalaryPositioning,
        
        -- Project involvement
        project_stats.ActiveProjects,
        project_stats.TotalProjectHours,
        
        -- Customer service
        customer_stats.OrdersProcessed,
        customer_stats.TotalOrderValue
        
    FROM Employees e
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID
    LEFT JOIN (
        SELECT 
            ep.EmployeeID,
            COUNT(DISTINCT ep.ProjectID) AS ActiveProjects,
            SUM(ep.HoursWorked) AS TotalProjectHours
        FROM EmployeeProjects ep
        WHERE ep.IsActive = 1
          AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY ep.EmployeeID
    ) project_stats ON e.EmployeeID = project_stats.EmployeeID
    LEFT JOIN (
        SELECT 
            o.EmployeeID,
            COUNT(o.OrderID) AS OrdersProcessed,
            SUM(o.TotalAmount) AS TotalOrderValue
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY o.EmployeeID
    ) customer_stats ON e.EmployeeID = customer_stats.EmployeeID
    
    WHERE d.DepartmentID = @d.DepartmentID
      AND (e.IsActive = 1 OR @IncludeInactive = 1)
);

-- Test the custom functions
-- Test scalar function
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) AS PerformanceScore,
    CASE 
        WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 90 THEN 'Exceptional Employee'
        WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 75 THEN 'Outstanding Employee'
        WHEN dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) >= 60 THEN 'Good Employee'
        ELSE 'Needs Development'
    END AS PerformanceCategory
FROM Employees e
WHERE IsActive = 1
  AND e.EmployeeID IN (3001, 3002, 3003, 3004, 3005)
ORDER BY dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) DESC;

-- Test table-valued function
SELECT 
    EmployeeName,
    e.JobTitle,
    FormattedSalary,
    YearsOfService,
    PerformanceScore,
    PerformanceRating,
    SalaryPositioning,
    ISNULL(ActiveProjects, 0) AS ProjectCount,
    ISNULL(OrdersProcessed, 0) AS CustomerOrders
FROM dbo.fn_GetDepartmentEmployeeAnalysis(2001, 0)  -- Engineering d.DepartmentName
ORDER BY PerformanceScore DESC, YearsOfService DESC;

-- Comprehensive d.DepartmentName comparison using custom functions
SELECT d.DepartmentName,
    COUNT(f.EmployeeID) AS TotalEmployees,
    FORMAT(AVG(f.BaseSalary), 'C') AS AverageBaseSalary,
    FORMAT(AVG(f.PerformanceScore), 'N1') AS AveragePerformanceScore,
    SUM(CASE WHEN f.PerformanceRating = 'Exceptional' THEN 1 ELSE 0 END) AS ExceptionalPerformers,
    SUM(CASE WHEN f.SalaryPositioning = 'Above Market' THEN 1 ELSE 0 END) AS AboveMarketSalaries,
    FORMAT(
        CAST(SUM(CASE WHEN f.PerformanceRating IN ('Exceptional', 'Outstanding') THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(f.EmployeeID) * 100, 'N1'
    ) + '%' AS HighPerformerPercentage
FROM Departments d
CROSS APPLY dbo.fn_GetDepartmentEmployeeAnalysis(d.DepartmentID, 0) f
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AVG(f.PerformanceScore) DESC;
```

## T-SQL Operators and Expressions

### Arithmetic and Comparison Operators

#### TechCorp Example: Complex Business Calculations

```sql
-- Demonstrate comprehensive operator usage in business calculations
DECLARE @BonusPoolTotal DECIMAL(12,2) = 500000.00;
DECLARE @CompanyRevenue DECIMAL(15,2) = 50000000.00;
DECLARE @PerformanceMultiplier DECIMAL(3,2) = 1.25;
DECLARE @AnalysisYear INT = YEAR(GETDATE());

-- Complex e.BaseSalary and bonus calculations using various operators
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.JobTitle,
    
    -- Basic arithmetic operators
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
    FORMAT(e.BaseSalary * 1.05, 'C') AS ProposedSalary_5Percent,
    FORMAT(e.BaseSalary + 5000, 'C') AS SalaryPlus5K,
    FORMAT(e.BaseSalary - (e.BaseSalary * 0.02), 'C') AS SalaryMinus2Percent,
    FORMAT(e.BaseSalary / 12, 'C') AS MonthlySalaryGross,
    FORMAT((e.BaseSalary / 12) % 1000, 'C') AS SalaryModulo1000,
    
    -- Complex calculations with parentheses
    FORMAT(
        (e.BaseSalary * @PerformanceMultiplier + 2000) * 
        (1 + (DATEDIFF(YEAR, e.HireDate, GETDATE()) * 0.01)), 
        'C'
    ) AS ComplexBonusCalculation,
    
    -- Performance-based calculations
    FORMAT(
        e.BaseSalary * 
        (dbo.fn_CalculateEmployeePerformanceScore(e.EmployeeID, 12) / 100.0) * 
        0.15, 
        'C'
    ) AS PerformanceBonus,
    
    -- Comparison operators in CASE expressions
    CASE 
        WHEN e.BaseSalary > 100000 THEN 'Executive Level'
        WHEN e.BaseSalary >= 80000 THEN 'Senior Level'
        WHEN e.BaseSalary >= 60000 THEN 'Mid Level'
        WHEN e.BaseSalary >= 40000 THEN 'Junior Level'
        ELSE 'Entry Level'
    END AS SalaryBracket,
    
    -- Logical operators
    CASE 
        WHEN e.BaseSalary > 75000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Senior High Earner'
        WHEN e.BaseSalary > 75000 OR DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Experienced Professional'
        WHEN NOT (e.BaseSalary < 50000) AND e.ManagerID IS NOT NULL THEN 'Managed Professional'
        ELSE 'Standard Employee'
    END AS EmployeeClassification,
    
    -- Date arithmetic
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) AS MonthsOfService,
    DATEADD(YEAR, 1, e.HireDate) AS FirstAnniversary,
    DATEADD(MONTH, 3, GETDATE()) AS QuarterlyReviewDate,
    
    -- Bitwise operations (less common in business logic)
    e.EmployeeID & 1 AS EmployeeIDOddEven, -- 0 = even, 1 = odd
    
    -- String concatenation operator
    e.FirstName + ' ' + e.LastName + ' (' + e.JobTitle + ')' AS FullEmployeeDescription,
    
    -- Null handling with operators
    ISNULL(e.BaseSalary, 0) + ISNULL(calculated_bonus.BonusAmount, 0) AS TotalCompensation,
    
    -- Advanced mathematical operations
    POWER(e.BaseSalary / 10000, 2) AS SalarySquared,
    SQRT(e.BaseSalary) AS SalarySqrt,
    LOG(e.BaseSalary) AS SalaryNaturalLog,
    
    -- Percentage calculations
    FORMAT(
        (e.BaseSalary / @CompanyRevenue) * 100, 
        'N6'
    ) + '%' AS SalaryAsPercentOfRevenue,
    
    -- Conditional arithmetic
    CASE 
        WHEN MONTH(e.HireDate) <= 6 THEN e.BaseSalary * 1.1  -- First half year hires get 10% bonus
        ELSE e.BaseSalary * 1.05  -- Second half year hires get 5% bonus
    END AS SeasonalAdjustedSalary

FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
LEFT JOIN (
    -- Subquery to calculate bonus amounts
    SELECT 
        emp.EmployeeID,
        (emp.BaseSalary * 0.1 * (DATEDIFF(YEAR, emp.HireDate, GETDATE()) + 1) / 5.0) AS BonusAmount
    FROM Employees e emp
    WHERE emp.IsActive = 1
) calculated_bonus ON e.EmployeeID = calculated_bonus.EmployeeID
WHERE e.IsActive = 1
  AND d.IsActive = 1
ORDER BY e.BaseSalary DESC, e.HireDate;

-- Advanced comparison and logical operator examples
SELECT 
    'e.BaseSalary Analysis Report' AS ReportType,
    GETDATE() AS ReportDate,
    
    -- Complex WHERE clause equivalents in SELECT
    COUNT(CASE WHEN e.BaseSalary BETWEEN 50000 AND 75000 THEN 1 END) AS MidRangeSalaries,
    COUNT(CASE WHEN e.BaseSalary IN (60000, 65000, 70000, 75000, 80000) THEN 1 END) AS StandardSalaryLevels,
    COUNT(CASE WHEN e.WorkEmail LIKE '%engineer%' OR e.JobTitle LIKE '%Developer%' THEN 1 END) AS TechnicalRoles,
    COUNT(CASE WHEN e.WorkEmail NOT LIKE '%temp%' AND e.IsActive = 1 THEN 1 END) AS PermanentActiveEmployees,
    
    -- Set membership operations
    COUNT(CASE WHEN d.DepartmentID IN (2001, 2002, 2003) THEN 1 END) AS CoreDepartmentEmployees,
    COUNT(CASE WHEN e.EmployeeID NOT IN (
        SELECT ManagerID FROM Employees e WHERE ManagerID IS NOT NULL
    ) THEN 1 END) AS NonManagerEmployees,
    
    -- Existence checks
    COUNT(CASE WHEN EXISTS (
        SELECT 1 FROM Orders o WHERE o.EmployeeID = e.EmployeeID AND o.IsActive = 1
    ) THEN 1 END) AS EmployeesWithOrders,
    
    -- Range and pattern matching
    COUNT(CASE WHEN e.HireDate >= '2020-01-01' AND e.HireDate < '2025-01-01' THEN 1 END) AS Recent5YearHires,
    COUNT(CASE WHEN e.FirstName LIKE '[A-M]%' THEN 1 END) AS FirstNamesAtoM,
    COUNT(CASE WHEN e.LastName LIKE '%son' OR e.LastName LIKE '%sen' THEN 1 END) AS SonSenLastNames,
    
    -- Null comparison operations
    COUNT(CASE WHEN e.ManagerID IS NULL THEN 1 END) AS EmployeesWithoutManagers,
    COUNT(CASE WHEN e.ManagerID IS NOT NULL THEN 1 END) AS EmployeesWithManagers,
    
    -- Mathematical comparisons
    COUNT(CASE WHEN e.BaseSalary > (
        SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1
    ) THEN 1 END) AS AboveAverageSalaryEmployees,
    
    -- Date comparisons
    COUNT(CASE WHEN DATEDIFF(MONTH, e.HireDate, GETDATE()) <= 6 THEN 1 END) AS NewHires6Months,
    COUNT(CASE WHEN YEAR(e.HireDate) = YEAR(GETDATE()) THEN 1 END) AS CurrentYearHires

FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;
```

## Advanced Programming Constructs

### Error Handling and Exception Management

#### TechCorp Example: Comprehensive Error Handling

```sql
-- Demonstrate advanced error handling in T-SQL programming
CREATE PROCEDURE sp_TechCorp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID INT,
    @NewSalary DECIMAL(10,2),
    @EffectiveDate DATE = NULL,
    @UpdateReason VARCHAR(500) = 'Standard e.BaseSalary adjustment',
    @ApprovedBy VARCHAR(100) = 'System'
AS
BEGIN
    -- Set up error handling environment
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    -- Declare error handling variables
    DECLARE @ErrorNumber INT;
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorProcedure NVARCHAR(128);
    DECLARE @ErrorLine INT;
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CustomErrorMessage NVARCHAR(4000);
    
    -- Declare business logic variables
    DECLARE @CurrentSalary DECIMAL(10,2);
    DECLARE @d.DepartmentID INT;
    DECLARE @EmployeeName VARCHAR(101);
    DECLARE @DepartmentBudget DECIMAL(12,2);
    DECLARE @DepartmentCurrentPayroll DECIMAL(12,2);
    DECLARE @SalaryChangePercent DECIMAL(5,2);
    
    -- Initialize variables
    SET @EffectiveDate = ISNULL(@EffectiveDate, GETDATE());
    
    BEGIN TRY
        -- Validation block with custom error raising
        IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 0
        BEGIN
            RAISERROR('Employee ID must be a positive integer.', 16, 1);
            RETURN -1;
        END
        
        IF @NewSalary IS NULL OR @NewSalary <= 0
        BEGIN
            RAISERROR('New e.BaseSalary must be a positive amount.', 16, 2);
            RETURN -2;
        END
        
        IF @NewSalary > 500000
        BEGIN
            RAISERROR('e.BaseSalary exceeds company maximum of $500,000.', 16, 3);
            RETURN -3;
        END
        
        IF @EffectiveDate < GETDATE()
        BEGIN
            RAISERROR('Effective date cannot be in the past.', 16, 4);
            RETURN -4;
        END
        
        -- Get current employee information
        SELECT 
            @CurrentSalary = e.BaseSalary,
            @d.DepartmentID = d.DepartmentID,
            @EmployeeName = e.FirstName + ' ' + e.LastName
        FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1;
        
        -- Check if employee exists
        IF @CurrentSalary IS NULL
        BEGIN
            SET @CustomErrorMessage = 'Employee ID ' + CAST(@e.EmployeeID AS VARCHAR) + ' not found or inactive.';
            RAISERROR(@CustomErrorMessage, 16, 5);
            RETURN -5;
        END
        
        -- Calculate e.BaseSalary change percentage
        SET @SalaryChangePercent = ((@NewSalary - @CurrentSalary) / @CurrentSalary) * 100;
        
        -- Business rule validation
        IF ABS(@SalaryChangePercent) > 50
        BEGIN
            SET @CustomErrorMessage = 'e.BaseSalary change of ' + 
                FORMAT(@SalaryChangePercent, 'N2') + 
                '% exceeds 50% limit and requires special approval.';
            RAISERROR(@CustomErrorMessage, 16, 6);
            RETURN -6;
        END
        
        -- Get d.DepartmentName budget information
        SELECT 
            @DepartmentBudget = d.Budget,
            @DepartmentCurrentPayroll = (
                SELECT SUM(e.BaseSalary) 
                FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
                WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1
            )
        FROM Departments d
        WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1;
        
        -- Check d.DepartmentName budget constraints
        DECLARE @NewDepartmentPayroll DECIMAL(12,2) = @DepartmentCurrentPayroll - @CurrentSalary + @NewSalary;
        
        IF @NewDepartmentPayroll > (@DepartmentBudget * 0.85)  -- 85% of budget limit
        BEGIN
            SET @CustomErrorMessage = 'e.BaseSalary update would exceed d.DepartmentName budget limits. ' +
                'Current payroll: ' + FORMAT(@DepartmentCurrentPayroll, 'C') + 
                ', Proposed payroll: ' + FORMAT(@NewDepartmentPayroll, 'C') + 
                ', d.Budget limit (85%): ' + FORMAT(@DepartmentBudget * 0.85, 'C');
            RAISERROR(@CustomErrorMessage, 16, 7);
            RETURN -7;
        END
        
        -- Begin transaction for atomic update
        BEGIN TRANSACTION SalaryUpdate;
        
        -- Update employee e.BaseSalary
        UPDATE Employees
        SET e.BaseSalary = @NewSalary
        WHERE e.EmployeeID = @e.EmployeeID;
        
        -- Check if update was successful
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Failed to update employee e.BaseSalary - no rows affected.', 16, 8);
            ROLLBACK TRANSACTION SalaryUpdate;
            RETURN -8;
        END
        
        -- Insert audit record (simulated - in real system would be separate audit table)
        DECLARE @AuditMessage VARCHAR(1000);
        SET @AuditMessage = 'e.BaseSalary updated for ' + @EmployeeName + 
            ' (ID: ' + CAST(@e.EmployeeID AS VARCHAR) + ')' +
            ' from ' + FORMAT(@CurrentSalary, 'C') + 
            ' to ' + FORMAT(@NewSalary, 'C') + 
            ' (' + FORMAT(@SalaryChangePercent, 'N2') + '% change)' +
            ' effective ' + FORMAT(@EffectiveDate, 'yyyy-MM-dd') + 
            '. Reason: ' + @UpdateReason + 
            '. Approved by: ' + @ApprovedBy;
        
        PRINT 'AUDIT: ' + @AuditMessage;
        
        -- Commit transaction
        COMMIT TRANSACTION SalaryUpdate;
        
        -- Success message
        PRINT 'SUCCESS: e.BaseSalary update completed successfully.';
        PRINT 'Employee: ' + @EmployeeName;
        PRINT 'Previous e.BaseSalary: ' + FORMAT(@CurrentSalary, 'C');
        PRINT 'New e.BaseSalary: ' + FORMAT(@NewSalary, 'C');
        PRINT 'Change: ' + FORMAT(@SalaryChangePercent, 'N2') + '%';
        PRINT 'Effective date: ' + FORMAT(@EffectiveDate, 'yyyy-MM-dd');
        
        RETURN 0; -- Success
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction if active
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION SalaryUpdate;
        
        -- Capture error information
        SELECT 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE();
        
        -- Create comprehensive error message
        SET @CustomErrorMessage = 'e.BaseSalary update failed for Employee ID ' + CAST(@e.EmployeeID AS VARCHAR) + '. ' +
            'Error ' + CAST(@ErrorNumber AS VARCHAR) + ' at line ' + CAST(@ErrorLine AS VARCHAR) + 
            ' in procedure ' + ISNULL(@ErrorProcedure, 'N/A') + ': ' + @ErrorMessage;
        
        -- Log error details
        PRINT 'ERROR DETAILS:';
        PRINT 'Number: ' + CAST(@ErrorNumber AS VARCHAR);
        PRINT 'Severity: ' + CAST(@ErrorSeverity AS VARCHAR);
        PRINT 'State: ' + CAST(@ErrorState AS VARCHAR);
        PRINT 'Procedure: ' + ISNULL(@ErrorProcedure, 'N/A');
        PRINT 'Line: ' + CAST(@ErrorLine AS VARCHAR);
        PRINT 'Message: ' + @ErrorMessage;
        
        -- Re-raise error with additional context
        RAISERROR(@CustomErrorMessage, @ErrorSeverity, @ErrorState);
        
        RETURN -99; -- General error code
    END CATCH
END;

-- Test the comprehensive error handling procedure
DECLARE @Result INT;

-- Test 1: Successful e.BaseSalary update
EXEC @Result = sp_TechCorp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID = 3001,
    @NewSalary = 82000,
    @UpdateReason = 'Annual performance increase',
    @ApprovedBy = 'HR Manager';

SELECT @Result AS SuccessTestResult;

-- Test 2: Invalid employee ID
EXEC @Result = sp_TechCorp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID = 99999,
    @NewSalary = 75000;

SELECT @Result AS InvalidEmployeeTestResult;

-- Test 3: Excessive e.BaseSalary increase
EXEC @Result = sp_TechCorp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID = 3002,
    @NewSalary = 200000,  -- Assuming current e.BaseSalary is much lower
    @UpdateReason = 'Excessive increase test';

SELECT @Result AS ExcessiveIncreaseTestResult;

-- Test 4: Null e.BaseSalary value
EXEC @Result = sp_TechCorp_ProcessEmployeeSalaryUpdate
    @e.EmployeeID = 3003,
    @NewSalary = NULL;

SELECT @Result AS NullSalaryTestResult;
```

## Summary

T-SQL programming elements provide TechCorp with powerful tools for implementing sophisticated database applications:

**Key Programming Elements:**

- **Variables and Data Types**: Foundation for storing and manipulating data within procedures
- **Functions and Expressions**: Built-in and user-defined functions for complex calculations
- **Operators**: Arithmetic, comparison, logical, and string manipulation capabilities
- **Error Handling**: Comprehensive exception management and recovery mechanisms

**Business Applications:**

- Complex business logic implementation
- Performance calculations and analytics
- Data validation and processing workflows
- Automated reporting and analysis systems
- Error management and audit trail generation

**Best Practices Demonstrated:**

- Proper variable initialization and scope management
- Comprehensive input validation and error handling
- Meaningful error messages and return codes
- Transaction management for data consistency
- Performance-optimized calculations and operations

**Advanced Techniques:**

- User-defined scalar and table-valued functions
- Complex mathematical and statistical calculations
- Date/time manipulation for business scenarios
- String processing and pattern matching
- Comprehensive error logging and recovery

T-SQL programming elements enable TechCorp's development teams to create robust, maintainable database applications that can handle complex business requirements while ensuring data integrity, performance, and reliability in enterprise environments.