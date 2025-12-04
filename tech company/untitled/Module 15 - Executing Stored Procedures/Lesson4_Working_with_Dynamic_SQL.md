# Lesson 4: Working with Dynamic SQL

## Overview

Dynamic SQL is a powerful technique that allows developers to construct and execute SQL statements at runtime, providing flexibility for complex queries, conditional logic, and parameterized reporting solutions. While dynamic SQL offers significant capabilities for creating adaptable database applications, it requires careful attention to security, performance, and maintainability considerations. For TechCorp's development teams, mastering dynamic SQL enables the creation of flexible reporting systems, configurable search interfaces, and adaptive business intelligence solutions that can respond to changing requirements and user preferences.

## 🏢 TechCorp Business Context

**Dynamic SQL Applications in Enterprise Development:**

- **Flexible Reporting Systems**: Generate reports with variable columns, filters, and sorting options
- **Advanced Search Interfaces**: Build complex search functionality with multiple optional criteria
- **Data Analysis Tools**: Create adaptable analytical queries for business intelligence
- **Configuration-Driven Applications**: Build systems that adapt behavior based on configuration settings
- **Cross-Database Compatibility**: Write procedures that work across different database schemas

### 📋 TechCorp Database Schema Reference

**Core Tables for Dynamic SQL Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Dynamic SQL Fundamentals

### Understanding Dynamic SQL Construction

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Dynamic SQL Architecture                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. SQL String Construction Phase                                           │
│     ┌─────────────────────────────────────────────┐                        │
│     │ DECLARE @SQL NVARCHAR(MAX) = 'SELECT ';    │                        │
│     │ SET @SQL = @SQL + 'columns FROM tables ';  │                        │
│     │ SET @SQL = @SQL + 'WHERE conditions';      │                        │
│     └─────────────────────────────────────────────┘                        │
│                            │                                                │
│                            ▼                                                │
│  2. Parameter Binding Phase                                                 │
│     ┌─────────────────────────────────────────────┐                        │
│     │ DECLARE @Params NVARCHAR(4000);             │                        │
│     │ SET @Params = '@Param1 INT, @Param2 VARCHAR';│                        │
│     └─────────────────────────────────────────────┘                        │
│                            │                                                │
│                            ▼                                                │
│  3. Execution Phase                                                         │
│     ┌─────────────────────────────────────────────┐                        │
│     │ EXEC sp_executesql @SQL, @Params,          │                        │
│     │      @Param1 = @Value1, @Param2 = @Value2; │                        │
│     └─────────────────────────────────────────────┘                        │
│                                                                             │
│  Security Considerations:                                                   │
│  • Always use sp_executesql with parameters                               │
│  • Validate and sanitize all inputs                                       │
│  • Avoid string concatenation for user inputs                             │
│  • Use whitelist validation for dynamic identifiers                       │
│                                                                             │
│  Performance Considerations:                                               │
│  • Plan reuse through sp_executesql                                       │
│  • Careful use of string concatenation                                    │
│  • Consider query plan caching implications                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Basic Dynamic SQL Syntax Patterns

```sql
-- Pattern 1: Simple dynamic query construction
DECLARE @SQL NVARCHAR(MAX);
DECLARE @TableName SYSNAME = 'Employees';

SET @SQL = 'SELECT * FROM ' + QUOTENAME(@TableName);
EXEC sp_executesql @SQL;

-- Pattern 2: Parameterized dynamic SQL (RECOMMENDED)
DECLARE @SQL NVARCHAR(MAX);
DECLARE @Params NVARCHAR(4000);

SET @SQL = 'SELECT * FROM Employees e WHERE d.DepartmentID = @DeptID AND e.BaseSalary >= @MinSalary';
SET @Params = '@DeptID INT, @MinSalary DECIMAL(10,2)';

EXEC sp_executesql @SQL, @Params, @DeptID = 2001, @MinSalary = 50000;

-- Pattern 3: Dynamic SQL with output parameters
DECLARE @SQL NVARCHAR(MAX);
DECLARE @Params NVARCHAR(4000);
DECLARE @Count INT;

SET @SQL = 'SELECT @CountOut = COUNT(*) FROM Employees e WHERE IsActive = @Active';
SET @Params = '@Active BIT, @CountOut INT OUTPUT';

EXEC sp_executesql @SQL, @Params, @Active = 1, @CountOut = @Count OUTPUT;
SELECT @Count AS ActiveEmployeeCount;
```

## Building Flexible Search Procedures

### 1. Advanced Employee Search with Dynamic Criteria

#### TechCorp Example: Comprehensive Employee Search System

```sql
-- Create flexible employee search procedure with dynamic criteria
CREATE PROCEDURE sp_SearchEmployeesDynamic
    @e.FirstName VARCHAR(50) = NULL,
    @e.LastName VARCHAR(50) = NULL,
    @d.DepartmentID INT = NULL,
    @d.DepartmentName VARCHAR(100) = NULL,
    @JobTitleSearch VARCHAR(100) = NULL,
    @MinSalary DECIMAL(10,2) = NULL,
    @MaxSalary DECIMAL(10,2) = NULL,
    @HireDateFrom DATE = NULL,
    @HireDateTo DATE = NULL,
    @ManagerID INT = NULL,
    @IsActive BIT = 1,
    @SortBy VARCHAR(50) = 'e.LastName',
    @SortOrder VARCHAR(4) = 'ASC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input parameters
    IF @PageNumber <= 0 SET @PageNumber = 1;
    IF @PageSize <= 0 OR @PageSize > 1000 SET @PageSize = 50;
    
    -- Validate sort column (whitelist approach for security)
    IF @SortBy NOT IN ('e.FirstName', 'e.LastName', 'e.JobTitle', 'e.BaseSalary', 'e.HireDate', 'd.DepartmentName')
        SET @SortBy = 'e.LastName';
    
    -- Validate sort order
    IF @SortOrder NOT IN ('ASC', 'DESC')
        SET @SortOrder = 'ASC';
    
    -- Declare variables for dynamic SQL construction
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @WhereClause NVARCHAR(MAX) = '';
    DECLARE @Params NVARCHAR(MAX) = '';
    DECLARE @ParamValues NVARCHAR(MAX) = '';
    
    -- Build base query
    SET @SQL = '
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.FirstName + '' '' + e.LastName AS FullName,
        e.JobTitle,
        FORMAT(e.BaseSalary, ''C'') AS FormattedSalary,
        e.BaseSalary,
        d.DepartmentName,
        d.Location AS DepartmentLocation,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        CASE WHEN e.IsActive = 1 THEN ''Active'' ELSE ''Inactive'' END AS Status,
        CASE 
            WHEN mgr.EmployeeID IS NOT NULL 
            THEN mgr.FirstName + '' '' + mgr.LastName
            ELSE ''No Manager''
        END AS ManagerName,
        -- Row number for pagination
        ROW_NUMBER() OVER (ORDER BY ';
    
    -- Add dynamic sorting
    SET @SQL = @SQL + 
        CASE @SortBy
            WHEN 'e.FirstName' THEN 'e.FirstName'
            WHEN 'e.LastName' THEN 'e.LastName'
            WHEN 'e.JobTitle' THEN 'e.JobTitle'
            WHEN 'e.BaseSalary' THEN 'e.BaseSalary'
            WHEN 'e.HireDate' THEN 'e.HireDate'
            WHEN 'd.DepartmentName' THEN 'd.DepartmentName'
            ELSE 'e.LastName'
        END + ' ' + @SortOrder + ') AS RowNum
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID';
    
    -- Build WHERE clause dynamically
    SET @WhereClause = ' WHERE 1=1';
    
    -- Add conditions based on provided parameters
    IF @e.FirstName IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.FirstName LIKE @FirstNameParam';
        SET @Params = @Params + '@FirstNameParam VARCHAR(52), ';
    END
    
    IF @e.LastName IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.LastName LIKE @LastNameParam';
        SET @Params = @Params + '@LastNameParam VARCHAR(52), ';
    END
    
    IF @d.DepartmentID IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND d.DepartmentID = @DepartmentIDParam';
        SET @Params = @Params + '@DepartmentIDParam INT, ';
    END
    
    IF @d.DepartmentName IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND d.DepartmentName LIKE @DepartmentNameParam';
        SET @Params = @Params + '@DepartmentNameParam VARCHAR(102), ';
    END
    
    IF @JobTitleSearch IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.JobTitle LIKE @JobTitleParam';
        SET @Params = @Params + '@JobTitleParam VARCHAR(102), ';
    END
    
    IF @MinSalary IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.BaseSalary >= @MinSalaryParam';
        SET @Params = @Params + '@MinSalaryParam DECIMAL(10,2), ';
    END
    
    IF @MaxSalary IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.BaseSalary <= @MaxSalaryParam';
        SET @Params = @Params + '@MaxSalaryParam DECIMAL(10,2), ';
    END
    
    IF @HireDateFrom IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.HireDate >= @HireDateFromParam';
        SET @Params = @Params + '@HireDateFromParam DATE, ';
    END
    
    IF @HireDateTo IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.HireDate <= @HireDateToParam';
        SET @Params = @Params + '@HireDateToParam DATE, ';
    END
    
    IF @ManagerID IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.ManagerID = @ManagerIDParam';
        SET @Params = @Params + '@ManagerIDParam INT, ';
    END
    
    -- Always filter by active status
    SET @WhereClause = @WhereClause + ' AND e.IsActive = @IsActiveParam AND d.IsActive = 1';
    SET @Params = @Params + '@IsActiveParam BIT, ';
    
    -- Add pagination parameters
    SET @Params = @Params + '@PageNumberParam INT, @PageSizeParam INT';
    
    -- Complete the query with pagination
    SET @SQL = @SQL + @WhereClause + '
    ) AS PagedResults
    WHERE RowNum BETWEEN ((@PageNumberParam - 1) * @PageSizeParam + 1) 
                     AND (@PageNumberParam * @PageSizeParam)
    ORDER BY RowNum';
    
    -- Execute the dynamic query
    BEGIN TRY
        EXEC sp_executesql @SQL, @Params,
            @FirstNameParam = @e.FirstName,
            @LastNameParam = @e.LastName,
            @DepartmentIDParam = @d.DepartmentID,
            @DepartmentNameParam = @d.DepartmentName,
            @JobTitleParam = @JobTitleSearch,
            @MinSalaryParam = @MinSalary,
            @MaxSalaryParam = @MaxSalary,
            @HireDateFromParam = @HireDateFrom,
            @HireDateToParam = @HireDateTo,
            @ManagerIDParam = @ManagerID,
            @IsActiveParam = @IsActive,
            @PageNumberParam = @PageNumber,
            @PageSizeParam = @PageSize;
            
        -- Return search metadata
        DECLARE @TotalCountSQL NVARCHAR(MAX);
        DECLARE @TotalCountParams NVARCHAR(MAX);
        DECLARE @TotalRecords INT;
        
        -- Build count query (reuse WHERE clause)
        SET @TotalCountSQL = 'SELECT @TotalOut = COUNT(*) FROM Employees e
                              INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID' + @WhereClause;
        SET @TotalCountParams = REPLACE(@Params, '@PageNumberParam INT, @PageSizeParam INT', '') + '@TotalOut INT OUTPUT';
        
        EXEC sp_executesql @TotalCountSQL, @TotalCountParams,
            @FirstNameParam = @e.FirstName,
            @LastNameParam = @e.LastName,
            @DepartmentIDParam = @d.DepartmentID,
            @DepartmentNameParam = @d.DepartmentName,
            @JobTitleParam = @JobTitleSearch,
            @MinSalaryParam = @MinSalary,
            @MaxSalaryParam = @MaxSalary,
            @HireDateFromParam = @HireDateFrom,
            @HireDateToParam = @HireDateTo,
            @ManagerIDParam = @ManagerID,
            @IsActiveParam = @IsActive,
            @TotalOut = @TotalRecords OUTPUT;
        
        -- Return pagination information
        SELECT 
            @TotalRecords AS TotalRecords,
            @PageNumber AS CurrentPage,
            @PageSize AS PageSize,
            CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize) AS TotalPages,
            GETDATE() AS SearchExecutedAt,
            @SortBy AS SortColumn,
            @SortOrder AS SortDirection;
            
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Search execution failed: %s', 16, 1, @ErrorMessage);
        RETURN -1;
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Test the dynamic search procedure
-- Basic search
EXEC sp_SearchEmployeesDynamic 
    @d.DepartmentName = 'Engineering',
    @MinSalary = 60000,
    @SortBy = 'e.BaseSalary',
    @SortOrder = 'DESC';

-- Complex search with multiple criteria
EXEC sp_SearchEmployeesDynamic
    @e.LastName = 'Smith',
    @JobTitleSearch = 'Developer',
    @HireDateFrom = '2020-01-01',
    @PageNumber = 1,
    @PageSize = 10;
```

### 2. Dynamic Reporting with Variable Columns

#### TechCorp Example: Configurable d.DepartmentName Report Generator

```sql
-- Create dynamic reporting procedure with configurable columns
CREATE PROCEDURE sp_GenerateDepartmentReportDynamic
    @DepartmentIDs VARCHAR(500) = NULL,  -- Comma-separated list: '2001,2002,2003'
    @IncludeEmployeeCount BIT = 1,
    @IncludeBudgetInfo BIT = 1,
    @IncludeProjectInfo BIT = 1,
    @IncludeSalaryStats BIT = 1,
    @IncludeManagerInfo BIT = 1,
    @DateRangeFrom DATE = NULL,
    @DateRangeTo DATE = NULL,
    @OutputFormat VARCHAR(20) = 'Standard'  -- 'Standard', 'Summary', 'Detailed'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate and set defaults
    IF @DateRangeFrom IS NULL SET @DateRangeFrom = DATEADD(YEAR, -1, GETDATE());
    IF @DateRangeTo IS NULL SET @DateRangeTo = GETDATE();
    IF @OutputFormat NOT IN ('Standard', 'Summary', 'Detailed') SET @OutputFormat = 'Standard';
    
    -- Declare variables for dynamic SQL
    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @SelectClause NVARCHAR(MAX) = '';
    DECLARE @FromClause NVARCHAR(MAX) = '';
    DECLARE @WhereClause NVARCHAR(MAX) = '';
    DECLARE @GroupByClause NVARCHAR(MAX) = '';
    DECLARE @OrderByClause NVARCHAR(MAX) = '';
    DECLARE @Params NVARCHAR(1000) = '';
    
    -- Build base SELECT clause
    SET @SelectClause = '
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Location';
    
    -- Add budget information if requested
    IF @IncludeBudgetInfo = 1
    BEGIN
        SET @SelectClause = @SelectClause + ',
        FORMAT(d.Budget, ''C'') AS DepartmentBudget,
        d.Budget AS BudgetAmount';
    END
    
    -- Add employee count if requested
    IF @IncludeEmployeeCount = 1
    BEGIN
        SET @SelectClause = @SelectClause + ',
        COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
        SUM(CASE WHEN e.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveEmployees,
        SUM(CASE WHEN e.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveEmployees';
    END
    
    -- Add e.BaseSalary statistics if requested
    IF @IncludeSalaryStats = 1
    BEGIN
        SET @SelectClause = @SelectClause + ',
        FORMAT(AVG(CASE WHEN e.IsActive = 1 THEN e.BaseSalary END), ''C'') AS AverageBaseSalary,
        FORMAT(SUM(CASE WHEN e.IsActive = 1 THEN e.BaseSalary ELSE 0 END), ''C'') AS TotalPayroll,
        FORMAT(MIN(CASE WHEN e.IsActive = 1 THEN e.BaseSalary END), ''C'') AS MinSalary,
        FORMAT(MAX(CASE WHEN e.IsActive = 1 THEN e.BaseSalary END), ''C'') AS MaxSalary';
    END
    
    -- Add project information if requested
    IF @IncludeProjectInfo = 1
    BEGIN
        SET @SelectClause = @SelectClause + ',
        COUNT(DISTINCT p.ProjectID) AS TotalProjects,
        SUM(CASE WHEN p.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProjects,
        FORMAT(SUM(CASE WHEN p.IsActive = 1 THEN d.Budget ELSE 0 END), ''C'') AS TotalProjectBudget';
    END
    
    -- Add manager information if requested
    IF @IncludeManagerInfo = 1
    BEGIN
        SET @SelectClause = @SelectClause + ',
        COUNT(DISTINCT CASE WHEN mgr_count.ManagerCount > 0 THEN e.EmployeeID END) AS EmployeesWithManagers,
        AVG(CAST(mgr_count.ManagerCount AS FLOAT)) AS AverageManagersPerEmployee';
    END
    
    -- Build FROM clause with necessary joins
    SET @FromClause = '
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = d.DepartmentID';
    
    -- Add project join if needed
    IF @IncludeProjectInfo = 1
    BEGIN
        SET @FromClause = @FromClause + '
        LEFT JOIN Projects p ON d.DepartmentID = (
            SELECT TOP 1 d.DepartmentID 
            FROM Employees e emp 
            WHERE emp.EmployeeID = p.ProjectManagerID
        )';
    END
    
    -- Add manager information join if needed
    IF @IncludeManagerInfo = 1
    BEGIN
        SET @FromClause = @FromClause + '
        LEFT JOIN (
            SELECT 
                e1.EmployeeID,
                COUNT(e1.ManagerID) AS ManagerCount
            FROM Employees e e1
            WHERE e1.IsActive = 1
            GROUP BY e1.EmployeeID
        ) mgr_count ON e.EmployeeID = mgr_count.EmployeeID';
    END
    
    -- Build WHERE clause
    SET @WhereClause = ' WHERE d.IsActive = 1';
    
    -- Add d.DepartmentName filter if specified
    IF @DepartmentIDs IS NOT NULL AND LTRIM(RTRIM(@DepartmentIDs)) != ''
    BEGIN
        SET @WhereClause = @WhereClause + ' AND d.DepartmentID IN (SELECT value FROM STRING_SPLIT(@DeptIDs, '',''))';
        SET @Params = '@DeptIDs VARCHAR(500), ';
    END
    
    -- Add date range filter for employees
    SET @WhereClause = @WhereClause + '
        AND (e.HireDate IS NULL OR (e.HireDate >= @DateFrom AND e.HireDate <= @DateTo))';
    SET @Params = @Params + '@DateFrom DATE, @DateTo DATE';
    
    -- Build GROUP BY clause (needed for aggregations)
    IF @IncludeEmployeeCount = 1 OR @IncludeSalaryStats = 1 OR @IncludeProjectInfo = 1 OR @IncludeManagerInfo = 1
    BEGIN
        SET @GroupByClause = '
        GROUP BY d.DepartmentID, d.DepartmentName, d.Location';
        
        IF @IncludeBudgetInfo = 1
        BEGIN
            SET @GroupByClause = @GroupByClause + ', d.Budget';
        END
    END
    
    -- Build ORDER BY clause based on output format
    SET @OrderByClause = 
        CASE @OutputFormat
            WHEN 'Summary' THEN ' ORDER BY d.DepartmentName'
            WHEN 'Detailed' THEN ' ORDER BY d.Budget DESC, d.DepartmentName'
            ELSE ' ORDER BY d.DepartmentID'
        END;
    
    -- Combine all parts
    SET @SQL = @SelectClause + @FromClause + @WhereClause + @GroupByClause + @OrderByClause;
    
    -- Execute the dynamic query
    BEGIN TRY
        -- Print the SQL for debugging (remove in production)
        PRINT 'Executing Dynamic SQL:';
        PRINT @SQL;
        PRINT 'Parameters: ' + @Params;
        
        IF @DepartmentIDs IS NOT NULL
        BEGIN
            EXEC sp_executesql @SQL, @Params, 
                @DeptIDs = @DepartmentIDs,
                @DateFrom = @DateRangeFrom,
                @DateTo = @DateRangeTo;
        END
        ELSE
        BEGIN
            EXEC sp_executesql @SQL, '@DateFrom DATE, @DateTo DATE',
                @DateFrom = @DateRangeFrom,
                @DateTo = @DateRangeTo;
        END
        
        -- Return report metadata
        SELECT 
            @OutputFormat AS ReportFormat,
            @DateRangeFrom AS DateRangeFrom,
            @DateRangeTo AS DateRangeTo,
            @DepartmentIDs AS DepartmentFilter,
            GETDATE() AS ReportGeneratedAt,
            -- Report configuration
            @IncludeEmployeeCount AS IncludesEmployeeCount,
            @IncludeBudgetInfo AS IncludesBudgetInfo,
            @IncludeProjectInfo AS IncludesProjectInfo,
            @IncludeSalaryStats AS IncludesSalaryStats,
            @IncludeManagerInfo AS IncludesManagerInfo;
            
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Dynamic report generation failed: %s', 16, 1, @ErrorMessage);
        RETURN -1;
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Test the dynamic reporting procedure
-- Basic report with all features
EXEC sp_GenerateDepartmentReportDynamic 
    @IncludeEmployeeCount = 1,
    @IncludeBudgetInfo = 1,
    @IncludeProjectInfo = 1,
    @IncludeSalaryStats = 1,
    @OutputFormat = 'Detailed';

-- Filtered report for specific departments
EXEC sp_GenerateDepartmentReportDynamic
    @DepartmentIDs = '2001,2002',
    @IncludeEmployeeCount = 1,
    @IncludeSalaryStats = 1,
    @IncludeProjectInfo = 0,
    @OutputFormat = 'Summary';

-- Minimal report with just basic information
EXEC sp_GenerateDepartmentReportDynamic
    @IncludeEmployeeCount = 0,
    @IncludeBudgetInfo = 1,
    @IncludeProjectInfo = 0,
    @IncludeSalaryStats = 0,
    @IncludeManagerInfo = 0,
    @OutputFormat = 'Standard';
```

## Advanced Dynamic SQL Techniques

### 1. Dynamic Query Building with Complex Conditions

#### TechCorp Example: Advanced Order Analysis System

```sql
-- Create advanced order analysis with complex dynamic conditions
CREATE PROCEDURE sp_AnalyzeOrdersAdvancedDynamic
    @AnalysisType VARCHAR(50) = 'Summary',  -- 'Summary', 'Trends', 'Performance', 'Detailed'
    @CustomerIDs VARCHAR(1000) = NULL,
    @EmployeeIDs VARCHAR(1000) = NULL,
    @DepartmentIDs VARCHAR(500) = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @MinOrderAmount DECIMAL(10,2) = NULL,
    @MaxOrderAmount DECIMAL(10,2) = NULL,
    @GroupByPeriod VARCHAR(20) = 'Month',  -- 'Day', 'Week', 'Month', 'Quarter', 'Year'
    @IncludeInactive BIT = 0,
    @TopN INT = NULL,
    @SortMetric VARCHAR(50) = 'TotalAmount'  -- 'TotalAmount', 'OrderCount', 'AverageAmount'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate and set defaults
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -6, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    IF @AnalysisType NOT IN ('Summary', 'Trends', 'Performance', 'Detailed') SET @AnalysisType = 'Summary';
    IF @GroupByPeriod NOT IN ('Day', 'Week', 'Month', 'Quarter', 'Year') SET @GroupByPeriod = 'Month';
    IF @SortMetric NOT IN ('TotalAmount', 'OrderCount', 'AverageAmount') SET @SortMetric = 'TotalAmount';
    IF @TopN IS NOT NULL AND (@TopN <= 0 OR @TopN > 1000) SET @TopN = NULL;
    
    -- Declare dynamic SQL variables
    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @SelectClause NVARCHAR(MAX) = '';
    DECLARE @FromClause NVARCHAR(MAX) = '';
    DECLARE @WhereClause NVARCHAR(MAX) = '';
    DECLARE @GroupByClause NVARCHAR(MAX) = '';
    DECLARE @OrderByClause NVARCHAR(MAX) = '';
    DECLARE @Params NVARCHAR(2000) = '';
    DECLARE @TopClause NVARCHAR(50) = '';
    
    -- Add TOP clause if specified
    IF @TopN IS NOT NULL
    BEGIN
        SET @TopClause = 'TOP (' + CAST(@TopN AS VARCHAR) + ') ';
    END
    
    -- Build SELECT clause based on analysis type
    IF @AnalysisType = 'Summary'
    BEGIN
        SET @SelectClause = '
        SELECT ' + @TopClause + '
            c.CustomerID,
            c.CustomerName,
            c.City,
            c.CountryID,
            COUNT(o.OrderID) AS TotalOrders,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalAmount,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderAmount,
            MIN(o.OrderDate) AS FirstOrderDate,
            MAX(o.OrderDate) AS LastOrderDate,
            DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifespanDays';
    END
    ELSE IF @AnalysisType = 'Trends'
    BEGIN
        -- Dynamic date grouping based on period
        DECLARE @DateGrouping NVARCHAR(200);
        SET @DateGrouping = 
            CASE @GroupByPeriod
                WHEN 'Day' THEN 'CAST(o.OrderDate AS DATE)'
                WHEN 'Week' THEN 'DATEADD(WEEK, DATEDIFF(WEEK, 0, o.OrderDate), 0)'
                WHEN 'Month' THEN 'DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)'
                WHEN 'Quarter' THEN 'DATEFROMPARTS(YEAR(o.OrderDate), ((MONTH(o.OrderDate) - 1) / 3) * 3 + 1, 1)'
                WHEN 'Year' THEN 'DATEFROMPARTS(YEAR(o.OrderDate), 1, 1)'
            END;
            
        SET @SelectClause = '
        SELECT ' + @TopClause + '
            ' + @DateGrouping + ' AS PeriodStart,
            ''' + @GroupByPeriod + ''' AS PeriodType,
            COUNT(o.OrderID) AS OrderCount,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalRevenue,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderValue,
            COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
            COUNT(DISTINCT e.EmployeeID) AS UniqueEmployees';
            
        SET @GroupByClause = ' GROUP BY ' + @DateGrouping;
    END
    ELSE IF @AnalysisType = 'Performance'
    BEGIN
        SET @SelectClause = '
        SELECT ' + @TopClause + '
            e.EmployeeID,
            e.FirstName + '' '' + e.LastName AS EmployeeName,
            e.JobTitle,
            d.DepartmentName,
            COUNT(o.OrderID) AS ProcessedOrders,
            FORMAT(SUM(o.TotalAmount), ''C'') AS TotalProcessedValue,
            FORMAT(AVG(o.TotalAmount), ''C'') AS AverageOrderValue,
            COUNT(DISTINCT o.CustomerID) AS UniqueCustomersServed,
            -- Performance metrics
            CASE 
                WHEN COUNT(o.OrderID) >= 50 THEN ''High Performer''
                WHEN COUNT(o.OrderID) >= 25 THEN ''Good Performer''
                WHEN COUNT(o.OrderID) >= 10 THEN ''Average Performer''
                ELSE ''Below Average''
            END AS PerformanceRating';
            
        SET @GroupByClause = ' GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, d.DepartmentName';
    END
    ELSE -- Detailed
    BEGIN
        SET @SelectClause = '
        SELECT ' + @TopClause + '
            o.OrderID,
            o.OrderDate,
            c.CustomerName AS CustomerName,
            c.City AS CustomerCity,
            e.FirstName + '' '' + e.LastName AS ProcessedBy,
            d.DepartmentName,
            FORMAT(o.TotalAmount, ''C'') AS OrderAmount,
            DATEDIFF(DAY, o.OrderDate, GETDATE()) AS DaysAgo,
            -- Order classification
            CASE 
                WHEN o.TotalAmount >= 50000 THEN ''Premium''
                WHEN o.TotalAmount >= 20000 THEN ''High Value''
                WHEN o.TotalAmount >= 5000 THEN ''Standard''
                ELSE ''Regular''
            END AS OrderCategory';
    END
    
    -- Build FROM clause
    SET @FromClause = '
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID';
    
    -- Build WHERE clause
    SET @WhereClause = ' WHERE o.OrderDate >= @DateFromParam AND o.OrderDate <= @DateToParam';
    SET @Params = '@DateFromParam DATE, @DateToParam DATE';
    
    -- Add active status filter
    IF @IncludeInactive = 0
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.IsActive = 1 AND c.IsActive = 1 AND e.IsActive = 1 AND d.IsActive = 1';
    END
    
    -- Add customer filter
    IF @CustomerIDs IS NOT NULL AND LTRIM(RTRIM(@CustomerIDs)) != ''
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.CustomerID IN (SELECT value FROM STRING_SPLIT(@CustomerIDsParam, '',''))';
        SET @Params = @Params + ', @CustomerIDsParam VARCHAR(1000)';
    END
    
    -- Add employee filter
    IF @EmployeeIDs IS NOT NULL AND LTRIM(RTRIM(@EmployeeIDs)) != ''
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.EmployeeID IN (SELECT value FROM STRING_SPLIT(@EmployeeIDsParam, '',''))';
        SET @Params = @Params + ', @EmployeeIDsParam VARCHAR(1000)';
    END
    
    -- Add d.DepartmentName filter
    IF @DepartmentIDs IS NOT NULL AND LTRIM(RTRIM(@DepartmentIDs)) != ''
    BEGIN
        SET @WhereClause = @WhereClause + ' AND e.DepartmentID IN (SELECT value FROM STRING_SPLIT(@DepartmentIDsParam, '',''))';
        SET @Params = @Params + ', @DepartmentIDsParam VARCHAR(500)';
    END
    
    -- Add amount filters
    IF @MinOrderAmount IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.TotalAmount >= @MinAmountParam';
        SET @Params = @Params + ', @MinAmountParam DECIMAL(10,2)';
    END
    
    IF @MaxOrderAmount IS NOT NULL
    BEGIN
        SET @WhereClause = @WhereClause + ' AND o.TotalAmount <= @MaxAmountParam';
        SET @Params = @Params + ', @MaxAmountParam DECIMAL(10,2)';
    END
    
    -- Build ORDER BY clause
    IF @AnalysisType = 'Summary'
    BEGIN
        SET @OrderByClause = 
            CASE @SortMetric
                WHEN 'TotalAmount' THEN ' ORDER BY SUM(o.TotalAmount) DESC'
                WHEN 'OrderCount' THEN ' ORDER BY COUNT(o.OrderID) DESC'
                WHEN 'AverageAmount' THEN ' ORDER BY AVG(o.TotalAmount) DESC'
            END;
        SET @GroupByClause = ' GROUP BY c.CustomerID, c.CustomerName, c.City, c.CountryID';
    END
    ELSE IF @AnalysisType = 'Trends'
    BEGIN
        SET @OrderByClause = ' ORDER BY PeriodStart';
    END
    ELSE IF @AnalysisType = 'Performance'
    BEGIN
        SET @OrderByClause = 
            CASE @SortMetric
                WHEN 'TotalAmount' THEN ' ORDER BY SUM(o.TotalAmount) DESC'
                WHEN 'OrderCount' THEN ' ORDER BY COUNT(o.OrderID) DESC'
                WHEN 'AverageAmount' THEN ' ORDER BY AVG(o.TotalAmount) DESC'
            END;
    END
    ELSE -- Detailed
    BEGIN
        SET @OrderByClause = ' ORDER BY o.OrderDate DESC';
    END
    
    -- Construct final query
    SET @SQL = @SelectClause + @FromClause + @WhereClause + @GroupByClause + @OrderByClause;
    
    -- Execute the dynamic query
    BEGIN TRY
        -- Execute with appropriate parameters
        EXEC sp_executesql @SQL, @Params,
            @DateFromParam = @DateFrom,
            @DateToParam = @DateTo,
            @CustomerIDsParam = @CustomerIDs,
            @EmployeeIDsParam = @EmployeeIDs,
            @DepartmentIDsParam = @DepartmentIDs,
            @MinAmountParam = @MinOrderAmount,
            @MaxAmountParam = @MaxOrderAmount;
        
        -- Return analysis metadata
        SELECT 
            @AnalysisType AS AnalysisType,
            @GroupByPeriod AS GroupingPeriod,
            @DateFrom AS AnalysisDateFrom,
            @DateTo AS AnalysisDateTo,
            @SortMetric AS SortedBy,
            @TopN AS TopNResults,
            @IncludeInactive AS IncludesInactiveRecords,
            GETDATE() AS AnalysisGeneratedAt;
            
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Advanced order analysis failed: %s', 16, 1, @ErrorMessage);
        RETURN -1;
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Test the advanced dynamic analysis procedure
-- Customer summary analysis
EXEC sp_AnalyzeOrdersAdvancedDynamic
    @AnalysisType = 'Summary',
    @DateFrom = '2024-01-01',
    @DateTo = '2024-12-31',
    @TopN = 10,
    @SortMetric = 'TotalAmount';

-- Monthly trends analysis
EXEC sp_AnalyzeOrdersAdvancedDynamic
    @AnalysisType = 'Trends',
    @GroupByPeriod = 'Month',
    @DateFrom = '2024-01-01';

-- Employee performance analysis
EXEC sp_AnalyzeOrdersAdvancedDynamic
    @AnalysisType = 'Performance',
    @DepartmentIDs = '2001,2002',
    @TopN = 5,
    @SortMetric = 'OrderCount';
```

## Security Considerations and Best Practices

### 1. SQL Injection Prevention

#### TechCorp Example: Secure Dynamic SQL Patterns

```sql
-- ❌ DANGEROUS: Vulnerable to SQL injection
CREATE PROCEDURE sp_UnsafeSearch
    @SearchTerm VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    -- NEVER DO THIS - Direct string concatenation
    SET @SQL = 'SELECT * FROM Employees e WHERE e.LastName = ''' + @SearchTerm + '''';
    EXEC(@SQL);  -- Vulnerable to injection
END;

-- ✅ SECURE: Parameterized approach
CREATE PROCEDURE sp_SecureSearch
    @SearchTerm VARCHAR(100)
AS
BEGIN
    -- Input validation
    IF @SearchTerm IS NULL OR LTRIM(RTRIM(@SearchTerm)) = ''
    BEGIN
        RAISERROR('Search term is required.', 16, 1);
        RETURN -1;
    END
    
    -- Length validation
    IF LEN(@SearchTerm) > 50
    BEGIN
        RAISERROR('Search term too long.', 16, 1);
        RETURN -2;
    END
    
    -- Character validation (whitelist approach)
    IF @SearchTerm LIKE '%[^a-zA-Z0-9 ''-]%'
    BEGIN
        RAISERROR('Search term contains invalid characters.', 16, 1);
        RETURN -3;
    END
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Params NVARCHAR(500);
    
    -- Safe parameterized query
    SET @SQL = 'SELECT e.EmployeeID, e.FirstName, e.LastName, e.JobTitle 
                FROM Employees e 
                WHERE e.LastName LIKE @SearchPattern AND IsActive = 1';
    SET @Params = '@SearchPattern VARCHAR(102)';
    
    -- Execute with parameter binding
    EXEC sp_executesql @SQL, @Params, @SearchPattern = @SearchTerm + '%';
END;

-- ✅ SECURE: Dynamic identifier validation
CREATE PROCEDURE sp_SecureDynamicColumns
    @ColumnName SYSNAME,
    @TableName SYSNAME
AS
BEGIN
    -- Validate column exists in allowed columns (whitelist)
    IF @ColumnName NOT IN ('e.EmployeeID', 'e.FirstName', 'e.LastName', 'e.JobTitle', 'e.BaseSalary', 'e.HireDate')
    BEGIN
        RAISERROR('Invalid column name specified.', 16, 1);
        RETURN -1;
    END
    
    -- Validate table exists in allowed tables (whitelist)
    IF @TableName NOT IN ('Employees', 'Departments', 'Projects')
    BEGIN
        RAISERROR('Invalid table name specified.', 16, 1);
        RETURN -2;
    END
    
    -- Use QUOTENAME for identifier safety
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'SELECT ' + QUOTENAME(@ColumnName) + ' FROM ' + QUOTENAME(@TableName) + ' WHERE IsActive = 1';
    
    EXEC sp_executesql @SQL;
END;
```

### 2. Performance Optimization Strategies

#### TechCorp Example: Optimized Dynamic SQL

```sql
-- Performance-optimized dynamic search with plan reuse
CREATE PROCEDURE sp_OptimizedDynamicSearch
    @SearchFirstName VARCHAR(50) = NULL,
    @SearchLastName VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @ForceRecompile BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Use consistent parameter types for plan reuse
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Params NVARCHAR(1000);
    
    -- Build consistent query structure
    SET @SQL = '
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE 1=1';
    
    -- Add conditions with consistent parameter usage
    SET @SQL = @SQL + '
        AND (@FirstNameParam IS NULL OR e.FirstName LIKE @FirstNameParam + ''%'')
        AND (@LastNameParam IS NULL OR e.LastName LIKE @LastNameParam + ''%'')
        AND (@DeptIDParam IS NULL OR e.DepartmentID = @DeptIDParam)
        AND e.IsActive = 1
        AND d.IsActive = 1';
    
    -- Consistent parameter declaration for plan reuse
    SET @Params = '
        @FirstNameParam VARCHAR(50),
        @LastNameParam VARCHAR(50),
        @DeptIDParam INT';
    
    -- Add query hints if needed
    SET @SQL = @SQL + ' ORDER BY e.LastName, e.FirstName';
    
    IF @ForceRecompile = 1
    BEGIN
        SET @SQL = @SQL + ' OPTION (RECOMPILE)';
    END
    
    -- Execute with all parameters (including NULLs for consistency)
    EXEC sp_executesql @SQL, @Params,
        @FirstNameParam = @SearchFirstName,
        @LastNameParam = @SearchLastName,
        @DeptIDParam = @DepartmentID;
END;
```

## Summary

Working with dynamic SQL in TechCorp's enterprise environment provides powerful capabilities for creating flexible, adaptable database solutions:

**Key Benefits:**

- **Flexibility**: Build queries that adapt to runtime conditions and user requirements
- **Reusability**: Create configurable procedures that serve multiple business scenarios
- **Performance**: Optimize query plans for specific parameter combinations
- **Maintainability**: Centralize complex query logic in well-structured procedures

**Essential Security Practices:**

- **Parameterization**: Always use sp_executesql with parameter binding
- **Input Validation**: Implement comprehensive validation for all inputs
- **Whitelist Validation**: Use whitelists for dynamic identifiers and options
- **Character Filtering**: Validate input characters to prevent injection attacks

**Performance Considerations:**

- **Plan Reuse**: Structure queries for optimal plan caching and reuse
- **Parameter Consistency**: Use consistent parameter types across executions
- **Query Complexity**: Balance flexibility with query performance
- **Execution Monitoring**: Monitor dynamic query performance and optimization

**Business Applications:**

- Advanced search interfaces with multiple optional criteria
- Configurable reporting systems with variable columns and filters
- Data analysis tools with flexible grouping and aggregation
- Cross-system integration with adaptable query structures

**Best Practices:**

- Implement robust error handling and transaction management
- Use meaningful variable and parameter names for maintainability
- Document dynamic query construction logic thoroughly
- Test with various parameter combinations and edge cases
- Monitor query performance and plan cache utilization

Dynamic SQL enables TechCorp to build sophisticated database applications that can adapt to changing business requirements while maintaining security, performance, and maintainability standards essential for enterprise-level database systems.