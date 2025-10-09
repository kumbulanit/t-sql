# Lesson 1: Using Aggregate Functions - TechCorp Business Intelligence Engine

## 🎯 Master Data Aggregation for Executive Decision-Making (🔴 EXPERT LEVEL)

Welcome to Module 9 - the pinnacle of SQL Server data analysis! As TechCorp Solutions has grown into an enterprise-scale consulting firm, you now need to master the art of data aggregation. These skills will enable you to create board-level reports, executive dashboards, and strategic business intelligence that drives million-dollar decisions.

## 📖 TechCorp's Strategic Intelligence Needs

TechCorp Solutions has evolved into a premier enterprise consulting firm with complex reporting requirements:

- **Board Reporting**: Monthly executive summaries with key performance indicators
- **Financial Analysis**: Revenue, profit, and cost analysis across multiple dimensions
- **Performance Metrics**: Employee productivity, project success rates, client satisfaction
- **Strategic Planning**: Historical trends analysis for future business planning
- **Competitive Intelligence**: Market positioning and performance benchmarking
- **Risk Management**: Portfolio analysis and early warning indicators

## 🎓 Learning Progression: From Expert to Master

### Where You've Mastered (Previous Modules)

✅ **Module 1-2**: Database architecture and T-SQL fundamentals  
✅ **Module 3-4**: Complex SELECT statements and multi-table joins  
✅ **Module 5-6**: Advanced filtering, sorting, and data type manipulation  
✅ **Module 7**: Data modification and transaction management  
✅ **Module 8**: Built-in functions for data transformation and business logic  

### What You'll Master Now (Aggregate Functions)

🔄 **Strategic Aggregation** - SUM, AVG, COUNT for business metrics  
🔄 **Statistical Analysis** - MIN, MAX, STDEV, VAR for performance analysis  
🔄 **Business Intelligence** - Complex calculations for executive reporting  
🔄 **Performance Optimization** - Efficient aggregation techniques  
🔄 **Data Quality** - Aggregate-based data validation and cleansing  

## Part 1: Core Aggregate Functions - Building Business Intelligence 📊

### 🎓 TUTORIAL: Why Aggregate Functions Are Critical for Business

Aggregate functions transform detailed transactional data into strategic business insights:

- **Executive Summary**: Convert thousands of records into key metrics
- **Trend Analysis**: Calculate averages, totals, and growth rates over time
- **Performance Measurement**: Create KPIs that drive business decisions
- **Financial Reporting**: Generate P&L statements and budget analysis
- **Risk Assessment**: Statistical analysis for identifying business risks

**Business Impact**: Data aggregation = strategic insights = informed decisions = competitive advantage

### Exercise 1.1: Financial Performance Aggregation (🔴 ADVANCED)

**Scenario**: Create comprehensive financial analysis for TechCorp's board meeting, showing revenue, profitability, and growth metrics.

```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Lab 9.1.1: Core Financial Performance Metrics
-- Business scenario: Board-level financial analysis for strategic planning

SELECT 
    'TECHCORP FINANCIAL PERFORMANCE SUMMARY' AS ReportTitle,
    FORMAT(GETDATE(), 'MMMM dd, yyyy') AS ReportDate,
    
    -- REVENUE METRICS using SUM
    FORMAT(SUM(p.Budget), 'C0') AS TotalContractValue,
    FORMAT(SUM(CASE WHEN p.IsActive = 'Completed' THEN p.Budget ELSE 0 END), 'C0') AS CompletedRevenue,
    FORMAT(SUM(CASE WHEN p.IsActive = 'Active' THEN p.Budget ELSE 0 END), 'C0') AS ActivePipelineValue,
    
    -- PROJECT VOLUME using COUNT
    COUNT(p.ProjectID) AS TotalProjects,
    COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END) AS CompletedProjects,
    COUNT(CASE WHEN p.IsActive = 'Active' THEN 1 END) AS ActiveProjects,
    COUNT(CASE WHEN p.IsActive = 'Planning' THEN 1 END) AS ProjectsInPlanning,
    
    -- AVERAGE METRICS for business intelligence
    FORMAT(AVG(p.Budget), 'C0') AS AverageProjectValue,
    FORMAT(AVG(CASE WHEN p.IsActive = 'Completed' THEN p.Budget END), 'C0') AS AvgCompletedProjectValue,
    
    -- STATISTICAL ANALYSIS using MIN/MAX
    FORMAT(MIN(p.Budget), 'C0') AS SmallestProject,
    FORMAT(MAX(p.Budget), 'C0') AS LargestProject,
    
    -- COST ANALYSIS
    FORMAT(SUM(ISNULL(p.ActualCost, 0)), 'C0') AS TotalProjectCosts,
    FORMAT(AVG(ISNULL(p.ActualCost, 0)), 'C0') AS AverageProjectCost,
    
    -- PROFITABILITY METRICS
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS TotalProfit,
    
    -- PROFIT MARGIN calculation
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS OverallProfitMargin,
    
    -- SUCCESS RATE analysis
    FORMAT(
        COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS OnTimeCompletionRate,
    
    -- BUDGET PERFORMANCE
    FORMAT(
        COUNT(CASE WHEN ISNULL(p.ActualCost, 0) <= ISNULL(p.Budget, 0) THEN 1 END) * 100.0 / COUNT(p.ProjectID),
        'N1'
    ) + '%' AS ProjectsWithinBudget

FROM Projects p
WHERE p.IsActive = 1 
    AND p.StartDate >= DATEADD(YEAR, -2, GETDATE()); -- Last 2 years of data

-- Lab 9.1.2: d.DepartmentName Performance Analysis
-- Business scenario: Departmental comparison for resource allocation decisions

SELECT d.DepartmentName,
    
    -- EMPLOYEE METRICS
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
    COUNT(DISTINCT CASE WHEN e.IsActive = 1 THEN e.EmployeeID END) AS ActiveEmployees,
    
    -- COMPENSATION ANALYSIS
    FORMAT(SUM(e.BaseSalary), 'C0') AS TotalPayrollCost,
    FORMAT(AVG(e.BaseSalary), 'C0') AS AverageBaseSalary,
    FORMAT(MIN(e.BaseSalary), 'C0') AS LowestBaseSalary,
    FORMAT(MAX(e.BaseSalary), 'C0') AS HighestBaseSalary,
    
    -- EXPERIENCE METRICS
    AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS AvgYearsOfService,
    MIN(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS MinYearsOfService,
    MAX(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS MaxYearsOfService,
    
    -- PROJECT ENGAGEMENT
    COUNT(DISTINCT p.ProjectID) AS ProjectsManaged,
    FORMAT(SUM(p.Budget), 'C0') AS TotalProjectValue,
    FORMAT(AVG(p.Budget), 'C0') AS AvgProjectValue,
    
    -- PERFORMANCE INDICATORS
    COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) AS OnTimeProjects,
    COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END) AS CompletedProjects,
    
    -- SUCCESS RATE by d.DepartmentName
    FORMAT(
        COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS DepartmentSuccessRate,
    
    -- REVENUE PER EMPLOYEE
    FORMAT(
        SUM(p.Budget) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0), 
        'C0'
    ) AS RevenuePerEmployee,
    
    -- PROFIT ANALYSIS
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS DepartmentProfit,
    
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS DepartmentProfitMargin

FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY SUM(p.Budget) DESC;
```

### Exercise 1.2: Advanced Statistical Analysis (🔴 EXPERT LEVEL)

**Scenario**: Create sophisticated statistical analysis for TechCorp's strategic planning, including variance analysis and performance distributions.

```sql
-- Lab 9.1.3: Advanced Statistical Analysis for Strategic Planning
-- Business scenario: Statistical insights for executive decision making

WITH ProjectStatistics AS (
    SELECT 
        p.ProjectID,
        p.ProjectName,
        p.Budget,
        p.ActualCost,
        p.EstimatedHours,
        p.ActualHours,
        DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, GETDATE())) AS ProjectDuration,
        d.DepartmentName,
        c.CompanyName,
        c.CompanySize,
        c.Industry,
        
        -- Calculate efficiency metrics
        CASE 
            WHEN p.Budget > 0 THEN ISNULL(p.ActualCost, 0) / p.Budget 
            ELSE 0 
        END AS CostEfficiencyRatio,
        
        CASE 
            WHEN p.EstimatedHours > 0 THEN ISNULL(p.ActualHours, 0) / p.EstimatedHours 
            ELSE 0 
        END AS TimeEfficiencyRatio
        
    FROM Projects p
        INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        INNER JOIN Companies c ON p.CompanyID = c.CompanyID
    WHERE p.IsActive = 1 
        AND p.StartDate >= DATEADD(YEAR, -3, GETDATE())
        AND p.Budget > 0
)

SELECT 
    'TECHCORP STATISTICAL PERFORMANCE ANALYSIS' AS AnalysisTitle,
    
    -- BASIC AGGREGATES
    COUNT(*) AS TotalProjectsAnalyzed,
    FORMAT(SUM(Budget), 'C0') AS TotalRevenueAnalyzed,
    FORMAT(AVG(Budget), 'C0') AS MeanProjectValue,
    
    -- STATISTICAL MEASURES using advanced aggregate functions
    FORMAT(STDEV(Budget), 'C0') AS RevenueStandardDeviation,
    FORMAT(VAR(Budget), 'C0') AS RevenueVariance,
    
    -- PERCENTILE ANALYSIS using window functions with aggregates
    FORMAT(
        (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Budget) FROM ProjectStatistics), 
        'C0'
    ) AS Revenue25thPercentile,
    
    FORMAT(
        (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Budget) FROM ProjectStatistics), 
        'C0'
    ) AS RevenueMedian,
    
    FORMAT(
        (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Budget) FROM ProjectStatistics), 
        'C0'
    ) AS Revenue75thPercentile,
    
    FORMAT(
        (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY Budget) FROM ProjectStatistics), 
        'C0'
    ) AS Revenue90thPercentile,
    
    -- EFFICIENCY ANALYSIS
    FORMAT(AVG(CostEfficiencyRatio) * 100, 'N1') + '%' AS AvgCostEfficiency,
    FORMAT(STDEV(CostEfficiencyRatio) * 100, 'N1') + '%' AS CostEfficiencyStdDev,
    
    FORMAT(AVG(TimeEfficiencyRatio) * 100, 'N1') + '%' AS AvgTimeEfficiency,
    FORMAT(STDEV(TimeEfficiencyRatio) * 100, 'N1') + '%' AS TimeEfficiencyStdDev,
    
    -- DURATION ANALYSIS
    AVG(ProjectDuration) AS AvgProjectDurationDays,
    MIN(ProjectDuration) AS ShortestProjectDays,
    MAX(ProjectDuration) AS LongestProjectDays,
    STDEV(ProjectDuration) AS DurationStandardDeviation,
    
    -- RISK INDICATORS
    COUNT(CASE WHEN CostEfficiencyRatio > 1.2 THEN 1 END) AS ProjectsOverBudget20Percent,
    COUNT(CASE WHEN TimeEfficiencyRatio > 1.3 THEN 1 END) AS ProjectsOverTime30Percent,
    
    -- PERFORMANCE DISTRIBUTION
    FORMAT(
        COUNT(CASE WHEN CostEfficiencyRatio <= 0.9 THEN 1 END) * 100.0 / COUNT(*), 
        'N1'
    ) + '%' AS ProjectsUnder90PercentBudget,
    
    FORMAT(
        COUNT(CASE WHEN CostEfficiencyRatio BETWEEN 0.9 AND 1.1 THEN 1 END) * 100.0 / COUNT(*), 
        'N1'
    ) + '%' AS ProjectsWithin10PercentBudget,
    
    FORMAT(
        COUNT(CASE WHEN CostEfficiencyRatio > 1.1 THEN 1 END) * 100.0 / COUNT(*), 
        'N1'
    ) + '%' AS ProjectsOver110PercentBudget

FROM ProjectStatistics;

-- Lab 9.1.4: Client Analysis and Segmentation
-- Business scenario: Client portfolio analysis for account management strategy

SELECT 
    c.CompanyName,
    c.Industry,
    c.CompanySize,
    c.AnnualRevenue,
    c.CreditRating,
    
    -- PROJECT VOLUME METRICS
    COUNT(p.ProjectID) AS TotalProjects,
    COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END) AS CompletedProjects,
    COUNT(CASE WHEN p.IsActive = 'Active' THEN 1 END) AS ActiveProjects,
    
    -- FINANCIAL METRICS
    FORMAT(SUM(p.Budget), 'C0') AS TotalClientValue,
    FORMAT(AVG(p.Budget), 'C0') AS AvgProjectValue,
    FORMAT(MIN(p.Budget), 'C0') AS SmallestProject,
    FORMAT(MAX(p.Budget), 'C0') AS LargestProject,
    
    -- CLIENT RELATIONSHIP DURATION
    DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE()))) AS RelationshipMonths,
    
    -- PROJECT FREQUENCY ANALYSIS
    FORMAT(
        COUNT(p.ProjectID) * 12.0 / 
        NULLIF(DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE()))), 0), 
        'N1'
    ) AS ProjectsPerYear,
    
    -- PROFITABILITY ANALYSIS
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS ClientProfitability,
    
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS ClientProfitMargin,
    
    -- SUCCESS METRICS
    FORMAT(
        COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS OnTimeDeliveryRate,
    
    -- CLIENT SEGMENTATION based on value and relationship
    CASE 
        WHEN SUM(p.Budget) >= 5000000 AND COUNT(p.ProjectID) >= 10 
        THEN '🌟 Strategic Enterprise Client'
        WHEN SUM(p.Budget) >= 2000000 AND COUNT(p.ProjectID) >= 5 
        THEN '💎 Premium Client'
        WHEN SUM(p.Budget) >= 1000000 
        THEN '🏆 Major Client'
        WHEN SUM(p.Budget) >= 250000 
        THEN '📈 Growth Client'
        ELSE '🔍 Developing Client'
    END AS ClientSegment,
    
    -- ACCOUNT MANAGEMENT RECOMMENDATIONS
    CASE 
        WHEN SUM(p.Budget) >= 5000000 THEN 'Dedicated Account Executive + Support Team'
        WHEN SUM(p.Budget) >= 2000000 THEN 'Senior Account Manager'
        WHEN SUM(p.Budget) >= 500000 THEN 'Account Manager'
        ELSE 'Standard Account Support'
    END AS RecommendedAccountManagement,
    
    -- RISK ASSESSMENT
    CASE 
        WHEN c.CreditRating IN ('AAA', 'AA', 'A') AND 
             COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
             NULLIF(COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END), 0) >= 80
        THEN '🟢 Low Risk - Excellent Client'
        WHEN c.CreditRating IN ('BBB', 'BB') AND SUM(p.Budget) >= 1000000
        THEN '🟡 Moderate Risk - Monitor Closely'
        WHEN c.CreditRating IN ('B', 'C', 'D') OR 
             COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) > 0
        THEN '🔴 High Risk - Review Terms'
        ELSE '⚪ Standard Risk - Regular Monitoring'
    END AS RiskAssessment

FROM Companies c
    INNER JOIN Projects p ON c.CompanyID = p.CompanyID
WHERE c.IsActive = 1 
    AND p.IsActive = 1
    AND p.StartDate >= DATEADD(YEAR, -3, GETDATE())
GROUP BY 
    c.CompanyID, c.CompanyName, c.Industry, c.CompanySize, 
    c.AnnualRevenue, c.CreditRating
HAVING COUNT(p.ProjectID) > 0  -- Only clients with projects
ORDER BY SUM(p.Budget) DESC;
```

## Part 2: Advanced Aggregate Functions and Business Intelligence 🧮

### 🎓 TUTORIAL: Statistical Functions for Executive Analysis

Advanced aggregate functions provide sophisticated statistical analysis:

- **Standard Deviation (STDEV)**: Measure variability in performance metrics
- **Variance (VAR)**: Understand data distribution and risk assessment
- **Percentiles**: Identify performance quartiles and outliers
- **Correlation Analysis**: Understand relationships between business variables

### Exercise 2.1: Executive KPI Dashboard (🔴 EXPERT LEVEL)

**Scenario**: Create a comprehensive executive KPI dashboard that combines multiple aggregate functions for strategic decision-making.

```sql
-- Lab 9.1.5: Executive KPI Dashboard - Board-Level Metrics
-- Business scenario: Comprehensive executive dashboard for strategic oversight

WITH ExecutiveMetrics AS (
    -- Employee Performance Metrics
    SELECT 
        'HUMAN_CAPITAL' AS MetricCategory,
        COUNT(DISTINCT e.EmployeeID) AS TotalCount,
        FORMAT(SUM(e.BaseSalary), 'C0') AS TotalValue,
        FORMAT(AVG(e.BaseSalary), 'C0') AS AverageValue,
        FORMAT(STDEV(e.BaseSalary), 'C0') AS StandardDeviation,
        AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS AvgTenure,
        COUNT(CASE WHEN DATEDIFF(MONTH, e.HireDate, GETDATE()) <= 12 THEN 1 END) AS NewHires,
        COUNT(CASE WHEN e.TerminationDate IS NOT NULL AND e.TerminationDate >= DATEADD(YEAR, -1, GETDATE()) THEN 1 END) AS RecentDepartures
    FROM Employees e
    WHERE e.IsActive = 1
    
    UNION ALL
    
    -- Project Portfolio Metrics
    SELECT 
        'PROJECT_PORTFOLIO' AS MetricCategory,
        COUNT(p.ProjectID) AS TotalCount,
        FORMAT(SUM(p.Budget), 'C0') AS TotalValue,
        FORMAT(AVG(p.Budget), 'C0') AS AverageValue,
        FORMAT(STDEV(p.Budget), 'C0') AS StandardDeviation,
        AVG(DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, GETDATE()))) AS AvgDuration,
        COUNT(CASE WHEN p.IsActive = 'Active' THEN 1 END) AS ActiveCount,
        COUNT(CASE WHEN p.IsActive = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) AS OnTimeCompletions
    FROM Projects p
    WHERE p.IsActive = 1 
        AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
    
    UNION ALL
    
    -- Client Relationship Metrics
    SELECT 
        'CLIENT_RELATIONSHIPS' AS MetricCategory,
        COUNT(DISTINCT c.CompanyID) AS TotalCount,
        FORMAT(AVG(c.AnnualRevenue), 'C0') AS TotalValue,
        FORMAT(AVG(CASE WHEN p.ProjectID IS NOT NULL THEN c.AnnualRevenue END), 'C0') AS AverageValue,
        FORMAT(STDEV(c.AnnualRevenue), 'C0') AS StandardDeviation,
        AVG(DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE())))) AS AvgRelationshipMonths,
        COUNT(DISTINCT CASE WHEN p.StartDate >= DATEADD(YEAR, -1, GETDATE()) THEN c.CompanyID END) AS NewClients,
        COUNT(DISTINCT CASE WHEN p.IsActive = 'Active' THEN c.CompanyID END) AS ActiveClients
    FROM Companies c
        LEFT JOIN Projects p ON c.CompanyID = p.CompanyID
    WHERE c.IsActive = 1
    GROUP BY c.CompanyID, c.AnnualRevenue
),

FinancialPerformance AS (
    SELECT 
        YEAR(p.StartDate) AS PerformanceYear,
        MONTH(p.StartDate) AS PerformanceMonth,
        
        -- Revenue Metrics
        SUM(p.Budget) AS MonthlyRevenue,
        SUM(ISNULL(p.ActualCost, 0)) AS MonthlyCost,
        SUM(p.Budget) - SUM(ISNULL(p.ActualCost, 0)) AS MonthlyProfit,
        
        -- Volume Metrics
        COUNT(p.ProjectID) AS MonthlyProjects,
        COUNT(CASE WHEN p.IsActive = 'Completed' THEN 1 END) AS CompletedProjects,
        
        -- Efficiency Metrics
        AVG(CASE WHEN p.Budget > 0 THEN ISNULL(p.ActualCost, 0) / p.Budget END) AS AvgCostRatio,
        AVG(CASE WHEN p.EstimatedHours > 0 THEN ISNULL(p.ActualHours, 0) / p.EstimatedHours END) AS AvgTimeRatio
        
    FROM Projects p
    WHERE p.IsActive = 1 
        AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
        AND p.StartDate IS NOT NULL
    GROUP BY YEAR(p.StartDate), MONTH(p.StartDate)
)

-- Executive Summary Report
SELECT 
    '=== TECHCORP EXECUTIVE DASHBOARD ===' AS ExecutiveReport,
    'Generated: ' + FORMAT(GETDATE(), 'dddd, MMMM dd, yyyy "at" hh:mm tt') AS ReportTimestamp,
    '' AS BlankLine1,
    
    -- KEY PERFORMANCE INDICATORS
    '📊 KEY PERFORMANCE INDICATORS' AS KPISection,
    
    -- Financial Performance
    'Revenue (YTD): ' + FORMAT(
        (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())), 
        'C0'
    ) AS YTDRevenue,
    
    'Profit (YTD): ' + FORMAT(
        (SELECT SUM(MonthlyProfit) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())), 
        'C0'
    ) AS YTDProfit,
    
    'Profit Margin (YTD): ' + FORMAT(
        (SELECT SUM(MonthlyProfit) * 100.0 / NULLIF(SUM(MonthlyRevenue), 0) 
         FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())), 
        'N1'
    ) + '%' AS YTDProfitMargin,
    
    -- Growth Metrics
    'Revenue Growth: ' + FORMAT(
        ((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) -
         (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1)) * 100.0 /
        NULLIF((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1), 0),
        'N1'
    ) + '%' AS RevenueGrowth,
    
    -- Human Capital Metrics
    (SELECT 'Total Employees: ' + CAST(TotalCount AS VARCHAR) FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') AS TotalEmployees,
    (SELECT 'Avg Employee Tenure: ' + FORMAT(AvgTenure, 'N1') + ' years' FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') AS AvgTenure,
    (SELECT 'Annual Turnover Rate: ' + FORMAT(RecentDepartures * 100.0 / TotalCount, 'N1') + '%' FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') AS TurnoverRate,
    
    -- Client Portfolio Metrics
    (SELECT 'Active Clients: ' + CAST(ActiveClients AS VARCHAR) FROM ExecutiveMetrics WHERE MetricCategory = 'CLIENT_RELATIONSHIPS') AS ActiveClients,
    (SELECT 'New Clients (YTD): ' + CAST(NewClients AS VARCHAR) FROM ExecutiveMetrics WHERE MetricCategory = 'CLIENT_RELATIONSHIPS') AS NewClients,
    
    -- Project Performance
    (SELECT 'Active Projects: ' + CAST(ActiveCount AS VARCHAR) FROM ExecutiveMetrics WHERE MetricCategory = 'PROJECT_PORTFOLIO') AS ActiveProjects,
    
    '' AS BlankLine2,
    
    -- STRATEGIC INSIGHTS
    '🎯 STRATEGIC INSIGHTS' AS StrategicSection,
    
    -- Performance Analysis
    CASE 
        WHEN (SELECT SUM(MonthlyProfit) * 100.0 / NULLIF(SUM(MonthlyRevenue), 0) 
              FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) >= 25
        THEN '🟢 EXCELLENT: Profit margins exceed industry benchmarks'
        WHEN (SELECT SUM(MonthlyProfit) * 100.0 / NULLIF(SUM(MonthlyRevenue), 0) 
              FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) >= 15
        THEN '🟡 GOOD: Solid profitability, room for optimization'
        WHEN (SELECT SUM(MonthlyProfit) * 100.0 / NULLIF(SUM(MonthlyRevenue), 0) 
              FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) >= 5
        THEN '🟠 FAIR: Margins below target, review cost structure'
        ELSE '🔴 CONCERN: Immediate action required on profitability'
    END AS ProfitabilityAssessment,
    
    -- Growth Analysis
    CASE 
        WHEN ((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) -
              (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1)) * 100.0 /
             NULLIF((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1), 0) >= 20
        THEN '🚀 EXCEPTIONAL: High growth trajectory maintained'
        WHEN ((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) -
              (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1)) * 100.0 /
             NULLIF((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1), 0) >= 10
        THEN '📈 STRONG: Solid growth above market average'
        WHEN ((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) -
              (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1)) * 100.0 /
             NULLIF((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1), 0) >= 0
        THEN '➡️ STABLE: Positive growth, monitor trends'
        ELSE '⚠️ DECLINING: Strategic intervention needed'
    END AS GrowthAssessment,
    
    -- Workforce Analysis
    CASE 
        WHEN (SELECT RecentDepartures * 100.0 / TotalCount FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') <= 10
        THEN '👥 STABLE: Low turnover indicates strong culture'
        WHEN (SELECT RecentDepartures * 100.0 / TotalCount FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') <= 20
        THEN '📊 NORMAL: Turnover within industry standards'
        ELSE '🔄 HIGH: Review retention strategies and compensation'
    END AS WorkforceAssessment,
    
    '' AS BlankLine3,
    
    -- EXECUTIVE RECOMMENDATIONS
    '💡 EXECUTIVE RECOMMENDATIONS' AS RecommendationsSection,
    
    -- Top recommendation based on data analysis
    CASE 
        WHEN (SELECT SUM(MonthlyProfit) * 100.0 / NULLIF(SUM(MonthlyRevenue), 0) 
              FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) < 15
        THEN '1. PRIORITY: Implement cost optimization initiative'
        WHEN (SELECT RecentDepartures * 100.0 / TotalCount FROM ExecutiveMetrics WHERE MetricCategory = 'HUMAN_CAPITAL') > 20
        THEN '1. PRIORITY: Launch employee retention program'
        WHEN ((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE())) -
              (SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1)) * 100.0 /
             NULLIF((SELECT SUM(MonthlyRevenue) FROM FinancialPerformance WHERE PerformanceYear = YEAR(GETDATE()) - 1), 0) < 5
        THEN '1. PRIORITY: Accelerate business development efforts'
        ELSE '1. OPPORTUNITY: Explore market expansion opportunities'
    END AS TopRecommendation,
    
    '2. Consider strategic partnerships for capability expansion' AS Recommendation2,
    '3. Invest in automation tools for operational efficiency' AS Recommendation3,
    '4. Develop succession planning for key leadership roles' AS Recommendation4,
    
    '' AS BlankLine4,
    
    '📈 TREND ANALYSIS: Review quarterly board packet for detailed trends' AS TrendNote,
    '🎯 NEXT REVIEW: ' + FORMAT(DATEADD(MONTH, 1, GETDATE()), 'MMMM dd, yyyy') AS NextReview

UNION ALL

-- Detailed Metrics Table
SELECT 
    '=== DETAILED METRICS BREAKDOWN ===' AS ExecutiveReport,
    MetricCategory AS ReportTimestamp,
    'Total Count: ' + CAST(TotalCount AS VARCHAR) AS BlankLine1,
    'Total Value: ' + TotalValue AS KPISection,
    'Average Value: ' + AverageValue AS YTDRevenue,
    'Std Deviation: ' + StandardDeviation AS YTDProfit,
    '' AS YTDProfitMargin,
    '' AS RevenueGrowth,
    '' AS TotalEmployees,
    '' AS AvgTenure,
    '' AS TurnoverRate,
    '' AS ActiveClients,
    '' AS NewClients,
    '' AS ActiveProjects,
    '' AS BlankLine2,
    '' AS StrategicSection,
    '' AS ProfitabilityAssessment,
    '' AS GrowthAssessment,
    '' AS WorkforceAssessment,
    '' AS BlankLine3,
    '' AS RecommendationsSection,
    '' AS TopRecommendation,
    '' AS Recommendation2,
    '' AS Recommendation3,
    '' AS Recommendation4,
    '' AS BlankLine4,
    '' AS TrendNote,
    '' AS NextReview
FROM ExecutiveMetrics

ORDER BY ExecutiveReport DESC, ReportTimestamp;
```

## 🎯 Aggregate Functions Mastery Summary

### Core Aggregate Functions You've Mastered

1. **SUM**: Financial totals, revenue calculations, cost aggregations
2. **COUNT**: Volume metrics, record counting, conditional counting
3. **AVG**: Performance averages, mean calculations, benchmarking
4. **MIN/MAX**: Range analysis, extremes identification, boundary detection
5. **STDEV/VAR**: Statistical analysis, risk assessment, variation measurement

### Real-World Business Applications

- **Executive Dashboards**: Board-level KPIs and strategic metrics
- **Financial Analysis**: P&L statements, budget analysis, profitability metrics
- **Performance Management**: Employee assessments, departmental comparisons
- **Client Intelligence**: Portfolio analysis, segmentation, relationship metrics
- **Risk Assessment**: Statistical analysis, variance detection, outlier identification

### Professional Skills Achieved

- **Strategic Reporting**: Create executive-level business intelligence
- **Statistical Analysis**: Apply advanced statistical measures to business data
- **Performance Measurement**: Build comprehensive KPI systems
- **Data-Driven Decisions**: Transform raw data into actionable insights
- **Business Intelligence**: Develop sophisticated analytical capabilities

---

*You've now mastered the fundamental aggregate functions that power enterprise business intelligence systems. These skills enable you to create the kind of strategic reporting that drives million-dollar business decisions!*

## Next Steps

Continue to Lesson 2 where you'll learn GROUP BY clauses - the essential skill for dimensional analysis that allows you to break down these powerful aggregations by business categories, time periods, and organizational hierarchies.

*Welcome to the world of strategic business intelligence!* 📊🎯