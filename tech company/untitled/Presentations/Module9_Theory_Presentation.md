# Module 9: Grouping and Aggregating Data - Theory Presentation (🔴 EXPERT LEVEL)

## Slide 1: Module Overview
**Grouping and Aggregating Data - Expert Level**

- Advanced aggregate functions for comprehensive business intelligence
- Complex GROUP BY strategies for multi-dimensional analysis
- HAVING clauses for sophisticated group filtering
- Statistical functions for executive-level data analysis
- Window functions integration for analytical reporting
- Performance optimization for enterprise-scale aggregations

---

## Slide 2: Business Intelligence Foundation
**From Data to Strategic Insights**

- **Aggregate Functions**: Transform detailed data into summary metrics
- **GROUP BY**: Create meaningful business dimensions for analysis
- **HAVING**: Apply business rules and thresholds to grouped data
- **Statistical Analysis**: Standard deviation, variance, percentiles
- **Executive Reporting**: Board-level dashboards and KPIs
- **Predictive Analytics**: Trend analysis and forecasting foundations

---

## Slide 3: Aggregate Functions Mastery
**Core Statistical Operations**

```sql
-- Comprehensive aggregate analysis
SELECT 
    d.DepartmentID,
    
    -- Count metrics
    COUNT(*) AS TotalEmployees,
    COUNT(ManagerID) AS EmployeesWithManagers,
    COUNT(DISTINCT JobLevelID) AS UniqueLevels,
    
    -- Financial aggregates
    SUM(e.BaseSalary) AS TotalPayroll,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MIN(e.BaseSalary) AS MinimumSalary,
    MAX(e.BaseSalary) AS MaximumSalary,
    
    -- Statistical measures
    STDEV(e.BaseSalary) AS SalaryStandardDeviation,
    VAR(e.BaseSalary) AS SalaryVariance
FROM Employees e
WHERE IsActive = 1
GROUP BY DepartmentIDID;
```

---

## Slide 4: Advanced Statistical Functions
**Business Intelligence Analytics**

```sql
-- Percentile and distribution analysis
SELECT 
    Industry,
    COUNT(*) AS CompanyCount,
    
    -- Revenue percentiles
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY AnnualRevenue) AS Q1Revenue,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY AnnualRevenue) AS MedianRevenue,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY AnnualRevenue) AS Q3Revenue,
    PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY AnnualRevenue) AS Top10PercentRevenue,
    
    -- Range and distribution
    MAX(AnnualRevenue) - MIN(AnnualRevenue) AS RevenueRange,
    STDEV(AnnualRevenue) / AVG(AnnualRevenue) AS CoefficientOfVariation
FROM Companies
WHERE IsActive = 1
GROUP BY Industry
HAVING COUNT(*) >= 5;  -- Minimum sample size for statistical significance
```

---

## Slide 5: GROUP BY Fundamentals
**Data Dimensionality**

```sql
-- Single dimension grouping
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID;

-- Multi-dimensional grouping
SELECT d.DepartmentName,
    JobLevel,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary,
    AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS AvgTenure
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, JobLevel
ORDER BY d.DepartmentID, JobLevel;
```

**Key Concept**: Every non-aggregate column in SELECT must be in GROUP BY

---

## Slide 6: Complex GROUP BY Scenarios
**Multi-Level Business Analysis**

```sql
-- Hierarchical grouping with ROLLUP
SELECT 
    ISNULL(Industry, 'ALL INDUSTRIES') AS Industry,
    ISNULL(CompanySize, 'ALL SIZES') AS CompanySize,
    COUNT(*) AS CompanyCount,
    AVG(AnnualRevenue) AS AvgRevenue,
    SUM(AnnualRevenue) AS TotalRevenue
FROM Companies
WHERE IsActive = 1
GROUP BY ROLLUP(Industry, CompanySize)
ORDER BY Industry, CompanySize;

-- CUBE for all possible combinations
SELECT ISNULL(Department, 'ALL DEPARTMENTS') AS d.DepartmentName,
    ISNULL(JobLevel, 'ALL LEVELS') AS JobLevel,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY CUBE(Department, JobLevel);
```

---

## Slide 7: HAVING Clause Mastery
**Group-Level Filtering**

```sql
-- Strategic filtering on aggregated data
SELECT 
    d.DepartmentID,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary,
    SUM(e.BaseSalary) AS TotalPayroll,
    MAX(e.HireDate) AS MostRecentHire
FROM Employees e
WHERE IsActive = 1
GROUP BY DepartmentIDID
HAVING COUNT(*) >= 10                    -- Departments with at least 10 employees
    AND AVG(e.BaseSalary) > 60000              -- Above-average compensation
    AND MAX(e.HireDate) >= DATEADD(YEAR, -2, GETDATE())  -- Recent hiring activity
ORDER BY AvgSalary DESC;
```

**Key Distinction**: WHERE filters rows, HAVING filters groups

---

## Slide 8: Complex HAVING Conditions
**Advanced Group Filtering Logic**

```sql
-- Multi-criteria strategic analysis
SELECT 
    c.IndustryID,
    COUNT(DISTINCT c.CompanyID) AS CompanyCount,
    COUNT(p.ProjectID) AS TotalProjects,
    AVG(p.d.Budget) AS AvgProjectBudget,
    SUM(p.d.Budget) AS TotalIndustryRevenue,
    AVG(DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, p.PlannedEndDate))) AS AvgProjectDuration
FROM Companies c
    INNER JOIN Projects p ON c.CompanyID = p.CompanyID
WHERE c.IsActive = 1 AND p.IsActive = 1
GROUP BY c.IndustryID
HAVING COUNT(DISTINCT c.CompanyID) >= 5           -- Significant industry presence
    AND COUNT(p.ProjectID) >= 20                  -- Substantial project volume
    AND AVG(p.d.Budget) > 500000                    -- High-value project focus
    AND SUM(p.d.Budget) > 10000000                  -- Major industry revenue
    AND AVG(DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, p.PlannedEndDate))) <= 180  -- Efficient delivery
ORDER BY TotalIndustryRevenue DESC;
```

---

## Slide 9: Aggregate Functions with Window Functions
**Advanced Analytical Reporting**

```sql
-- Combining aggregates with window functions
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentID,
    e.BaseSalary,
    
    -- Department-level aggregates
    AVG(e.BaseSalary) OVER (PARTITION BY DepartmentIDID) AS DeptAvgSalary,
    COUNT(*) OVER (PARTITION BY DepartmentIDID) AS DeptEmployeeCount,
    SUM(e.BaseSalary) OVER (PARTITION BY DepartmentIDID) AS DeptTotalPayroll,
    
    -- Running totals and rankings
    SUM(e.BaseSalary) OVER (ORDER BY e.EmployeeID ROWS UNBOUNDED PRECEDING) AS RunningPayrollTotal,
    ROW_NUMBER() OVER (PARTITION BY DepartmentIDID ORDER BY e.BaseSalary DESC) AS DeptSalaryRank,
    
    -- Comparative analysis
    e.BaseSalary - AVG(e.BaseSalary) OVER (PARTITION BY DepartmentIDID) AS SalaryDifference,
    (e.BaseSalary * 100.0) / SUM(e.BaseSalary) OVER (PARTITION BY DepartmentIDID) AS PayrollPercentage
FROM Employees e
WHERE IsActive = 1
ORDER BY DepartmentIDID, e.BaseSalary DESC;
```

---

## Slide 10: Time-Based Aggregations
**Temporal Business Intelligence**

```sql
-- Monthly performance trending
SELECT 
    YEAR(p.StartDate) AS ProjectYear,
    MONTH(p.StartDate) AS ProjectMonth,
    DATENAME(MONTH, p.StartDate) AS MonthName,
    
    -- Volume metrics
    COUNT(p.ProjectID) AS MonthlyProjects,
    COUNT(DISTINCT p.CompanyID) AS UniqueClients,
    COUNT(DISTINCT p.ProjectManagerID) AS ActiveManagers,
    
    -- Financial metrics
    SUM(p.d.Budget) AS MonthlyRevenue,
    AVG(p.d.Budget) AS AvgProjectValue,
    MIN(p.d.Budget) AS SmallestProject,
    MAX(p.d.Budget) AS LargestProject,
    
    -- Performance metrics
    AVG(DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, p.PlannedEndDate))) AS AvgDuration,
    COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
    NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0) AS OnTimePercentage
FROM Projects p
WHERE p.IsActive = 1 
    AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY YEAR(p.StartDate), MONTH(p.StartDate), DATENAME(MONTH, p.StartDate)
HAVING COUNT(p.ProjectID) >= 3  -- Months with significant activity
ORDER BY ProjectYear DESC, ProjectMonth DESC;
```

---

## Slide 11: Conditional Aggregation
**Business Rule Implementation**

```sql
-- Conditional aggregation for complex business metrics
SELECT 
    d.DepartmentID,
    
    -- Conditional counts
    COUNT(CASE WHEN e.BaseSalary > 75000 THEN 1 END) AS HighEarners,
    COUNT(CASE WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 1 END) AS Veterans,
    COUNT(CASE WHEN PerformanceRating >= 4 THEN 1 END) AS HighPerformers,
    
    -- Conditional sums
    SUM(CASE WHEN JobLevel = 'Manager' THEN e.BaseSalary ELSE 0 END) AS ManagerPayroll,
    SUM(CASE WHEN JobLevel = 'Individual Contributor' THEN e.BaseSalary ELSE 0 END) AS ICPayroll,
    
    -- Conditional averages
    AVG(CASE WHEN PerformanceRating >= 4 THEN e.BaseSalary END) AS HighPerformerAvgSalary,
    AVG(CASE WHEN PerformanceRating < 3 THEN e.BaseSalary END) AS LowPerformerAvgSalary,
    
    -- Complex business calculations
    (COUNT(CASE WHEN PerformanceRating >= 4 THEN 1 END) * 100.0) / COUNT(*) AS HighPerformerPercent,
    (SUM(CASE WHEN JobLevel = 'Manager' THEN e.BaseSalary ELSE 0 END) * 100.0) / SUM(e.BaseSalary) AS ManagerPayrollPercent
FROM Employees e
WHERE IsActive = 1
GROUP BY DepartmentIDID
HAVING COUNT(*) >= 5  -- Departments with sufficient sample size
ORDER BY HighPerformerPercent DESC;
```

---

## Slide 12: String Aggregation for Reporting
**Consolidating Textual Data**

```sql
-- STRING_AGG for comprehensive reporting (SQL Server 2017+)
SELECT 
    c.CompanyName,
    c.IndustryID,
    COUNT(p.ProjectID) AS ProjectCount,
    SUM(p.d.Budget) AS TotalRevenue,
    
    -- Aggregate project information
    STRING_AGG(p.ProjectName, '; ') WITHIN GROUP (ORDER BY p.d.Budget DESC) AS ProjectList,
    STRING_AGG(CONCAT(p.ProjectName, ' ($', FORMAT(p.d.Budget, 'N0'), ')'), '; ') 
        WITHIN GROUP (ORDER BY p.d.Budget DESC) AS ProjectsWithBudgets,
    
    -- Manager aggregation
    STRING_AGG(DISTINCT CONCAT(e.FirstName, ' ', e.LastName), ', ') AS ProjectManagers
FROM Companies c
    INNER JOIN Projects p ON c.CompanyID = p.CompanyID
    INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
WHERE c.IsActive = 1 AND p.IsActive = 1
GROUP BY c.CompanyID, c.CompanyName, c.IndustryID
HAVING COUNT(p.ProjectID) >= 3
ORDER BY TotalRevenue DESC;
```

---

## Slide 13: Performance Optimization for Aggregations
**Enterprise-Scale Efficiency**

```sql
-- Optimized aggregation strategies
-- 1. Use covering indexes
CREATE INDEX IX_Employees_Covering ON Employees (d.DepartmentID, IsActive) 
INCLUDE (e.BaseSalary, e.HireDate, PerformanceRating);

-- 2. Filter early with WHERE
SELECT 
    d.DepartmentID,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
WHERE IsActive = 1  -- Filter applied before grouping
    AND e.HireDate >= '2020-01-01'
GROUP BY DepartmentIDID;

-- 3. Use indexed computed columns for complex calculations
ALTER TABLE Employees ADD TenureYears AS DATEDIFF(YEAR, e.HireDate, GETDATE()) PERSISTED;
CREATE INDEX IX_Employees_TenureYears ON Employees (TenureYears);

-- 4. Consider partitioned views for very large datasets
-- 5. Use appropriate data types to minimize memory usage
```

---

## Slide 14: Common Aggregation Mistakes
**Pitfalls to Avoid**

```sql
-- Mistake 1: Non-aggregate columns not in GROUP BY
SELECT d.DepartmentID, e.FirstName, COUNT(*)  -- ERROR: e.FirstName not in GROUP BY
FROM Employees e GROUP BY DepartmentIDID;

-- Mistake 2: Using WHERE instead of HAVING for group conditions
SELECT d.DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees e
WHERE COUNT(*) > 5  -- ERROR: Can't use aggregate in WHERE
GROUP BY DepartmentIDID;
-- CORRECT: Use HAVING COUNT(*) > 5

-- Mistake 3: Forgetting NULL handling in aggregates
SELECT AVG(Bonus) FROM Employees e;  -- Ignores NULL values, might not be expected behavior

-- Mistake 4: Incorrect COUNT usage
SELECT COUNT(MiddleName) FROM Employees e;  -- Counts only non-NULL values
-- vs
SELECT COUNT(*) FROM Employees e;  -- Counts all rows
```

---

## Slide 15: Advanced Business Scenarios
**Real-World Analytical Challenges**

```sql
-- Customer segmentation analysis
WITH CustomerMetrics AS (
    SELECT 
        c.CompanyID,
        c.CompanyName,
        c.IndustryID,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(p.d.Budget) AS TotalRevenue,
        AVG(p.d.Budget) AS AvgProjectValue,
        MIN(p.StartDate) AS FirstProject,
        MAX(p.StartDate) AS LastProject,
        DATEDIFF(MONTH, MIN(p.StartDate), MAX(p.StartDate)) AS RelationshipMonths
    FROM Companies c
        INNER JOIN Projects p ON c.CompanyID = p.CompanyID
    WHERE c.IsActive = 1 AND p.IsActive = 1
    GROUP BY c.CompanyID, c.CompanyName, c.IndustryID
)
SELECT 
    Industry,
    COUNT(*) AS ClientCount,
    
    -- Customer value segmentation
    COUNT(CASE WHEN TotalRevenue >= 5000000 THEN 1 END) AS PremiumClients,
    COUNT(CASE WHEN TotalRevenue BETWEEN 1000000 AND 4999999 THEN 1 END) AS StandardClients,
    COUNT(CASE WHEN TotalRevenue < 1000000 THEN 1 END) AS BasicClients,
    
    -- Relationship analysis
    AVG(RelationshipMonths) AS AvgRelationshipDuration,
    AVG(ProjectCount) AS AvgProjectsPerClient,
    SUM(TotalRevenue) AS IndustryTotalRevenue
FROM CustomerMetrics
GROUP BY Industry
HAVING COUNT(*) >= 5
ORDER BY IndustryTotalRevenue DESC;
```

---

## Slide 16: Predictive Analytics Foundation
**Trend Analysis and Forecasting**

```sql
-- Growth trend analysis using aggregations
WITH MonthlyMetrics AS (
    SELECT 
        YEAR(StartDate) * 100 + MONTH(StartDate) AS YearMonth,
        YEAR(StartDate) AS Year,
        MONTH(StartDate) AS Month,
        COUNT(*) AS ProjectCount,
        SUM(d.Budget) AS MonthlyRevenue,
        AVG(d.Budget) AS AvgProjectValue
    FROM Projects p
    WHERE IsActive = 1 AND StartDate >= DATEADD(YEAR, -3, GETDATE())
    GROUP BY YEAR(StartDate), MONTH(StartDate)
),
TrendAnalysis AS (
    SELECT 
        YearMonth,
        Year,
        Month,
        ProjectCount,
        MonthlyRevenue,
        AvgProjectValue,
        
        -- Growth calculations
        LAG(MonthlyRevenue, 12) OVER (ORDER BY YearMonth) AS SameMonthLastYear,
        LAG(MonthlyRevenue, 1) OVER (ORDER BY YearMonth) AS PreviousMonth,
        AVG(MonthlyRevenue) OVER (ORDER BY YearMonth ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS TwelveMonthAvg
    FROM MonthlyMetrics
)
SELECT 
    Year,
    Month,
    MonthlyRevenue,
    
    -- Year-over-year growth
    CASE 
        WHEN SameMonthLastYear IS NOT NULL 
        THEN ((MonthlyRevenue - SameMonthLastYear) * 100.0) / SameMonthLastYear
        ELSE NULL 
    END AS YoYGrowthPercent,
    
    -- Month-over-month growth
    CASE 
        WHEN PreviousMonth IS NOT NULL 
        THEN ((MonthlyRevenue - PreviousMonth) * 100.0) / PreviousMonth
        ELSE NULL 
    END AS MoMGrowthPercent,
    
    -- Trend indicator
    CASE 
        WHEN MonthlyRevenue > TwelveMonthAvg * 1.1 THEN 'Above Trend'
        WHEN MonthlyRevenue < TwelveMonthAvg * 0.9 THEN 'Below Trend'
        ELSE 'On Trend'
    END AS TrendIsActive
FROM TrendAnalysis
ORDER BY YearMonth DESC;
```

---

## Slide 17: Executive Dashboard Aggregations
**Board-Level Reporting**

```sql
-- Comprehensive executive summary
WITH ExecutiveSummary AS (
    -- d.DepartmentName performance
    SELECT 
        'Department Performance' AS MetricCategory,
        d.DepartmentName AS Dimension,
        COUNT(e.EmployeeID) AS Volume,
        AVG(e.BaseSalary) AS AvgValue,
        SUM(e.BaseSalary) AS TotalValue,
        NULL AS CompletionRate
    FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = d.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
    
    UNION ALL
    
    -- Project performance
    SELECT 
        'Project Performance' AS MetricCategory,
        pt.TypeName AS Dimension,
        COUNT(p.ProjectID) AS Volume,
        AVG(d.Budget) AS AvgValue,
        SUM(d.Budget) AS TotalValue,
        (COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0) / 
        NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0) AS CompletionRate
    FROM ProjectTypes pt
        LEFT JOIN Projects p ON pt.ProjectTypeID = p.ProjectTypeID AND p.IsActive = 1
    WHERE pt.IsActive = 1
    GROUP BY pt.ProjectTypeID, pt.TypeName
    
    UNION ALL
    
    -- Client performance
    SELECT 
        'Client Performance' AS MetricCategory,
        c.IndustryID AS Dimension,
        COUNT(DISTINCT c.CompanyID) AS Volume,
        AVG(c.AnnualRevenue) AS AvgValue,
        SUM(d.Budget) AS TotalValue,
        NULL AS CompletionRate
    FROM Companies c
        LEFT JOIN Projects p ON c.CompanyID = p.CompanyID AND p.IsActive = 1
    WHERE c.IsActive = 1
    GROUP BY c.IndustryID
)
SELECT 
    MetricCategory,
    Dimension,
    Volume,
    FORMAT(AvgValue, 'C0') AS FormattedAvgValue,
    FORMAT(TotalValue, 'C0') AS FormattedTotalValue,
    FORMAT(CompletionRate, 'N1') + '%' AS FormattedCompletionRate
FROM ExecutiveSummary
WHERE Volume > 0
ORDER BY MetricCategory, TotalValue DESC;
```

---

## Slide 18: Data Quality and Validation
**Ensuring Aggregation Accuracy**

```sql
-- Data quality checks using aggregations
SELECT 
    'Data Quality Report' AS ReportType,
    
    -- Completeness checks
    COUNT(*) AS TotalRecords,
    COUNT(e.FirstName) AS RecordsWithFirstName,
    COUNT(WorkEmail) AS RecordsWithEmail,
    COUNT(e.BaseSalary) AS RecordsWithSalary,
    
    -- Quality percentages
    (COUNT(e.FirstName) * 100.0) / COUNT(*) AS FirstNameCompleteness,
    (COUNT(WorkEmail) * 100.0) / COUNT(*) AS EmailCompleteness,
    (COUNT(e.BaseSalary) * 100.0) / COUNT(*) AS SalaryCompleteness,
    
    -- Value validation
    COUNT(CASE WHEN WorkEmail LIKE '%@%.%' THEN 1 END) AS ValidEmails,
    COUNT(CASE WHEN e.BaseSalary > 0 AND e.BaseSalary <= 1000000 THEN 1 END) AS ReasonableSalaries,
    COUNT(CASE WHEN LEN(e.FirstName) >= 2 THEN 1 END) AS ValidFirstNames,
    
    -- Outlier detection
    COUNT(CASE WHEN e.BaseSalary > (SELECT AVG(e.BaseSalary) + 3 * STDEV(e.BaseSalary) FROM Employees e WHERE IsActive = 1) THEN 1 END) AS SalaryOutliers
FROM Employees e
WHERE IsActive = 1;
```

---

## Slide 19: Integration with Stored Procedures
**Encapsulating Complex Aggregations**

```sql
-- Stored procedure for comprehensive business reporting
CREATE PROCEDURE sp_ExecutiveReport
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @d.DepartmentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range to current year
    IF @StartDate IS NULL SET @StartDate = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Main aggregation query
    SELECT ISNULL(d.DepartmentName, 'ALL DEPARTMENTS') AS d.DepartmentName,
        COUNT(DISTINCT e.EmployeeID) AS ActiveEmployees,
        COUNT(DISTINCT p.ProjectID) AS ActiveProjects,
        
        -- Financial metrics
        SUM(e.BaseSalary) AS TotalPayroll,
        AVG(e.BaseSalary) AS AvgSalary,
        SUM(d.Budget) AS TotalProjectRevenue,
        AVG(d.Budget) AS AvgProjectBudget,
        
        -- Performance metrics
        COUNT(CASE WHEN e.PerformanceRating >= 4 THEN 1 END) * 100.0 / COUNT(e.EmployeeID) AS HighPerformerPercent,
        COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0) AS OnTimeDeliveryPercent
    FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = d.DepartmentID 
                               AND e.IsActive = 1
                               AND e.HireDate <= @EndDate
        LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
                              AND p.StartDate BETWEEN @StartDate AND @EndDate
                              AND p.IsActive = 1
    WHERE d.IsActive = 1
        AND (@d.DepartmentID IS NULL OR d.DepartmentID = @d.DepartmentID)
    GROUP BY ROLLUP(d.DepartmentID, d.DepartmentName)
    ORDER BY TotalProjectRevenue DESC;
END
```

---

## Slide 20: Learning Objectives Achieved
**Module 9 Expert Mastery**

✅ **Advanced Aggregate Functions**: Master SUM, COUNT, AVG, STDEV, PERCENTILE for comprehensive business metrics

✅ **Complex GROUP BY Strategies**: Implement single and multi-dimensional analysis with ROLLUP and CUBE

✅ **Strategic HAVING Clauses**: Apply sophisticated group filtering for business intelligence

✅ **Statistical Analysis**: Use statistical functions for executive-level data analysis and insights

✅ **Performance Optimization**: Optimize aggregations for enterprise-scale data processing

✅ **Business Intelligence Integration**: Create executive dashboards and predictive analytics foundations

---

## Slide 21: Professional Applications
**Real-World Impact**

**Executive Reporting**: Board-level dashboards with strategic KPIs and performance metrics

**Financial Analysis**: Budget forecasting, variance analysis, and profitability assessments

**Performance Management**: d.DepartmentName productivity, employee performance analysis, and benchmarking

**Customer Analytics**: Segmentation analysis, lifetime value calculations, and retention metrics

**Operational Intelligence**: Process optimization, resource allocation, and efficiency measurements

**Predictive Analytics**: Trend analysis, forecasting foundations, and strategic planning support

---

## Slide 22: Advanced Career Applications
**Strategic Business Intelligence Skills**

**Data Analyst Role**: Transform raw data into actionable business insights

**Business Intelligence Developer**: Create sophisticated reporting systems and dashboards

**Data Scientist**: Foundation for advanced analytics and machine learning models

**Database Administrator**: Performance tuning and optimization of analytical queries

**Management Consultant**: Data-driven recommendations and strategic analysis

**Finance Analyst**: Comprehensive financial modeling and variance analysis

---

## Slide 23: Integration with Modern Analytics
**Enterprise Data Ecosystem**

```sql
-- Integration patterns for modern BI tools
-- Power BI, Tableau, QlikView connectivity
CREATE VIEW vw_ExecutiveDashboard AS
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary,
    SUM(e.BaseSalary) AS TotalPayroll,
    STDEV(e.BaseSalary) AS SalaryStdDev
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE IsActive = 1
GROUP BY DepartmentIDID, Department;

-- Data warehouse preparation
-- Star schema fact table aggregations
-- ETL process integration
-- Real-time dashboard support
```

---

## Slide 24: Next Career Steps
**Continuing Your Analytics Journey**

**Advanced SQL**: Window functions, CTEs, recursive queries, and advanced optimization

**Business Intelligence Tools**: Power BI, Tableau, QlikView, and SSRS mastery

**Data Science**: Python/R integration, machine learning, and statistical modeling  

**Cloud Analytics**: Azure Synapse, AWS Redshift, Google BigQuery platforms

**Data Architecture**: Data warehousing, data lakes, and modern data architecture

**Leadership Roles**: Data team management, analytics strategy, and organizational transformation

---

## Slide 25: Congratulations - Expert Level Achieved!
**You Are Now a Strategic Business Intelligence Professional**

🏆 **Technical Mastery**: Advanced SQL aggregation and grouping techniques

📊 **Business Acumen**: Transform data into strategic business insights

💼 **Professional Impact**: Drive executive decision-making with data intelligence

🚀 **Career Advancement**: Qualified for senior analytics and leadership roles

🌟 **Industry Recognition**: Expert-level skills in business intelligence and data analysis

**Welcome to the Elite Ranks of Data Professionals!**

*You now possess the advanced SQL skills that power modern business intelligence systems and drive organizational success through data-driven decision making.*