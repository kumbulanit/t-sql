# Lab: Using Built-in Functions - TechCorp Master Integration Challenge

## 🎯 Master Integration Lab: All Functions Working Together (🔴 EXPERT LEVEL)

Welcome to the ultimate built-in functions challenge! This comprehensive lab combines all the advanced SQL Server functions you've mastered across Module 8. You'll create sophisticated business intelligence systems that demonstrate the full power of integrated function usage in real-world scenarios.

## 📖 TechCorp's Ultimate Business Challenge

As TechCorp Solutions has evolved into a premier consulting firm, management needs a comprehensive business intelligence system that:

- **Integrates All Data Sources**: Employee, project, client, and financial data
- **Handles All Data Quality Issues**: Missing data, placeholder values, inconsistent formats
- **Provides Executive Intelligence**: Sophisticated analysis and automated decision-making
- **Delivers Professional Reports**: Polished, formatted output suitable for board presentations
- **Enables Predictive Analytics**: Historical analysis to guide future business decisions

## 🎓 Integration Challenge Overview

This lab challenges you to combine:

✅ **String Functions** - Data standardization and professional formatting  
✅ **Date/Time Functions** - Temporal analysis and business timing  
✅ **Mathematical Functions** - Financial calculations and statistical analysis  
✅ **Conversion Functions** - Data type management and formatting  
✅ **Logical Functions** - Complex business rules and decision trees  
✅ **NULL Functions** - Bulletproof data quality and error handling  

## Part 1: Executive Dashboard Integration Challenge 📊

### Exercise 1.1: Complete Business Intelligence Dashboard (🔴 EXPERT LEVEL)

**Scenario**: Create TechCorp's ultimate executive dashboard combining all function types for comprehensive business intelligence.

```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Lab 8.5.1: Master Integration - Executive Business Intelligence Dashboard
-- Business scenario: Complete executive overview using all advanced SQL functions

WITH ExecutiveMetrics AS (
    -- Comprehensive employee analytics
    SELECT 
        e.EmployeeID,
        
        -- STRING FUNCTIONS: Professional name formatting and data cleaning
        UPPER(LEFT(ISNULL(e.FirstName, 'UNKNOWN'), 1)) + 
        LOWER(SUBSTRING(ISNULL(e.FirstName, 'Unknown'), 2, LEN(e.FirstName))) + ' ' +
        UPPER(LEFT(ISNULL(e.LastName, 'UNKNOWN'), 1)) + 
        LOWER(SUBSTRING(ISNULL(e.LastName, 'Unknown'), 2, LEN(e.LastName))) AS FormattedName,
        
        -- Clean and standardize email addresses
        LOWER(TRIM(COALESCE(
            NULLIF(e.WorkEmail, ''), 
            NULLIF(e.PersonalEmail, ''), 
            'no-email@techcorp.com'
        ))) AS StandardizedEmail,
        
        -- Format phone numbers consistently
        CASE 
            WHEN LEN(REPLACE(REPLACE(REPLACE(COALESCE(e.Phone, ''), '-', ''), '(', ''), ')', '')) = 10
            THEN FORMAT(CAST(REPLACE(REPLACE(REPLACE(e.Phone, '-', ''), '(', ''), ')', '') AS BIGINT), '(000) 000-0000')
            ELSE COALESCE(e.Phone, 'Phone Not Available')
        END AS FormattedPhone,
        
        -- CONVERSION FUNCTIONS: Professional e.BaseSalary and data formatting
        FORMAT(ISNULL(e.BaseSalary, 0), 'C') AS FormattedSalary,
        CAST(ISNULL(e.Commission, 0) AS DECIMAL(5,2)) AS CommissionDecimal,
        
        -- DATE/TIME FUNCTIONS: Advanced temporal analysis
        DATEDIFF(YEAR, ISNULL(e.HireDate, '1900-01-01'), GETDATE()) AS YearsOfService,
        DATEDIFF(MONTH, ISNULL(e.HireDate, '1900-01-01'), GETDATE()) % 12 AS AdditionalMonths,
        
        -- Calculate next anniversary date
        DATEADD(YEAR, 
            DATEDIFF(YEAR, ISNULL(e.HireDate, '1900-01-01'), GETDATE()) + 1, 
            ISNULL(e.HireDate, '1900-01-01')
        ) AS NextAnniversary,
        
        -- Days until next anniversary
        DATEDIFF(DAY, GETDATE(), 
            DATEADD(YEAR, 
                DATEDIFF(YEAR, ISNULL(e.HireDate, '1900-01-01'), GETDATE()) + 1, 
                ISNULL(e.HireDate, '1900-01-01')
            )
        ) AS DaysToNextAnniversary,
        
        -- MATHEMATICAL FUNCTIONS: Advanced compensation analysis
        ISNULL(e.BaseSalary, 0) * (1 + ISNULL(e.Commission, 0) / 100.0) AS EstimatedTotalComp,
        
        -- Calculate compound annual e.BaseSalary growth (assuming 3% average)
        ISNULL(e.BaseSalary, 0) * POWER(1.03, DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE())) AS ProjectedCurrentValue,
        
        -- Statistical ranking within d.DepartmentName
        PERCENT_RANK() OVER (
            PARTITION BY e.DepartmentID 
            ORDER BY ISNULL(e.BaseSalary, 0)
        ) AS SalaryPercentileInDept,
        
        -- NULL FUNCTIONS: Comprehensive data quality protection
        COALESCE(
            d.DepartmentName,
            'Department Not Assigned'
        ) AS EffectiveDepartment,
        
        COALESCE(
            jl.LevelName,
            CASE 
                WHEN ISNULL(e.BaseSalary, 0) >= 150000 THEN 'Executive Level (Estimated)'
                WHEN ISNULL(e.BaseSalary, 0) >= 100000 THEN 'Senior Level (Estimated)'
                WHEN ISNULL(e.BaseSalary, 0) >= 75000 THEN 'Professional Level (Estimated)'
                ELSE 'Associate Level (Estimated)'
            END
        ) AS EffectiveJobLevel,
        
        -- LOGICAL FUNCTIONS: Complex business rules integration
        CASE 
            -- High performers
            WHEN ISNULL(e.BaseSalary, 0) >= 120000 
                 AND DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) >= 3
                 AND PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) >= 0.8
            THEN 'Elite Performer - Retention Critical'
            
            -- Rising stars
            WHEN DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) <= 3
                 AND PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) >= 0.6
            THEN 'Rising Star - High Potential'
            
            -- Solid contributors
            WHEN ISNULL(e.BaseSalary, 0) >= 75000 
                 AND DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) >= 2
            THEN 'Solid Contributor - Stable Performance'
            
            -- Development opportunities
            WHEN DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) >= 5
                 AND PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) < 0.3
            THEN 'Development Opportunity - Career Planning Needed'
            
            -- New employees
            WHEN DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) < 1
            THEN 'New Employee - Onboarding Phase'
            
            ELSE 'Standard Employee - Regular Review'
        END AS PerformanceCategory,
        
        -- Multi-function bonus calculation
        CASE 
            WHEN ISNULL(e.BaseSalary, 0) > 0
            THEN ROUND(
                ISNULL(e.BaseSalary, 0) * 
                (ISNULL(e.Commission, 0) / 100.0) *
                (1 + (DATEDIFF(YEAR, ISNULL(e.HireDate, GETDATE()), GETDATE()) * 0.02)) *
                CASE 
                    WHEN PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) >= 0.9 THEN 1.5
                    WHEN PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) >= 0.7 THEN 1.25
                    WHEN PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY ISNULL(e.BaseSalary, 0)) >= 0.5 THEN 1.0
                    ELSE 0.75
                END,
                2
            )
            ELSE 0
        END AS CalculatedBonusAmount
        
    FROM Employees e
        LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
    WHERE e.IsActive = 1
),

ProjectAnalytics AS (
    -- Comprehensive project performance metrics
    SELECT 
        p.ProjectID,
        
        -- STRING FUNCTIONS: Professional project identification
        UPPER(LEFT(COALESCE(p.ProjectName, 'UNNAMED PROJECT'), 1)) + 
        LOWER(SUBSTRING(COALESCE(p.ProjectName, 'Unnamed Project'), 2, LEN(p.ProjectName))) AS FormattedProjectName,
        
        -- Project code generation
        LEFT(UPPER(COALESCE(c.CompanyName, 'UNK')), 3) + '-' +
        FORMAT(p.ProjectID, '0000') + '-' +
        YEAR(COALESCE(p.StartDate, GETDATE())) AS ProjectCode,
        
        -- CONVERSION AND NULL FUNCTIONS: Bulletproof financial data
        COALESCE(
            CAST(NULLIF(p.Budget, 0) AS DECIMAL(15,2)),
            CAST(NULLIF(p.EstimatedRevenue, 0) AS DECIMAL(15,2)),
            0.00
        ) AS EffectiveBudget,
        
        COALESCE(
            CAST(NULLIF(p.ActualCost, 0) AS DECIMAL(15,2)),
            CAST(NULLIF(p.EstimatedCost, 0) AS DECIMAL(15,2)),
            0.00
        ) AS EffectiveCost,
        
        -- DATE/TIME FUNCTIONS: Comprehensive timeline analysis
        COALESCE(p.StartDate, p.PlannedStartDate, p.CreatedDate) AS EffectiveStartDate,
        COALESCE(p.ActualEndDate, p.PlannedEndDate) AS EffectiveEndDate,
        
        -- Calculate project age and duration
        DATEDIFF(DAY, COALESCE(p.StartDate, p.PlannedStartDate, p.CreatedDate), GETDATE()) AS ProjectAge,
        
        CASE 
            WHEN p.ActualEndDate IS NOT NULL 
            THEN DATEDIFF(DAY, COALESCE(p.StartDate, p.PlannedStartDate), p.ActualEndDate)
            WHEN p.PlannedEndDate IS NOT NULL
            THEN DATEDIFF(DAY, COALESCE(p.StartDate, p.PlannedStartDate), p.PlannedEndDate)
            ELSE NULL
        END AS ProjectDuration,
        
        -- MATHEMATICAL FUNCTIONS: Advanced financial metrics
        -- Profit calculation with NULL protection
        COALESCE(CAST(NULLIF(p.Budget, 0) AS DECIMAL(15,2)), 0) - 
        COALESCE(CAST(NULLIF(p.ActualCost, 0) AS DECIMAL(15,2)), 0) AS ProjectProfit,
        
        -- ROI calculation with safe division
        CASE 
            WHEN COALESCE(NULLIF(p.ActualCost, 0), NULLIF(p.EstimatedCost, 0)) > 0
            THEN ROUND(
                ((COALESCE(NULLIF(p.Budget, 0), NULLIF(p.EstimatedRevenue, 0), 0) - 
                  COALESCE(NULLIF(p.ActualCost, 0), NULLIF(p.EstimatedCost, 0), 0)) * 100.0) /
                COALESCE(NULLIF(p.ActualCost, 0), NULLIF(p.EstimatedCost, 0), 1),
                2
            )
            ELSE NULL
        END AS ProjectROI,
        
        -- LOGICAL FUNCTIONS: Multi-criteria project assessment
        CASE 
            -- High-value successful projects
            WHEN COALESCE(NULLIF(p.Budget, 0), 0) >= 500000
                 AND p.ActualEndDate IS NOT NULL
                 AND p.ActualEndDate <= p.PlannedEndDate
                 AND COALESCE(NULLIF(p.ActualCost, 0), 0) <= COALESCE(NULLIF(p.Budget, 0), 1)
            THEN '🌟 Strategic Success'
            
            -- Large profitable projects
            WHEN COALESCE(NULLIF(p.Budget, 0), 0) >= 250000
                 AND (COALESCE(NULLIF(p.Budget, 0), 0) > COALESCE(NULLIF(p.ActualCost, 0), 0))
            THEN '💰 High-Value Project'
            
            -- On-time delivery
            WHEN p.ActualEndDate IS NOT NULL 
                 AND p.ActualEndDate <= COALESCE(p.PlannedEndDate, p.ActualEndDate)
            THEN '⏰ On-Time Delivery'
            
            -- Active projects
            WHEN p.IsActive = 'Active' 
                 AND COALESCE(p.StartDate, p.PlannedStartDate) <= GETDATE()
            THEN '🚀 Active Project'
            
            -- At-risk projects
            WHEN p.IsActive = 'Active'
                 AND (COALESCE(NULLIF(p.ActualCost, 0), 0) > COALESCE(NULLIF(p.Budget, 0), 1) * 0.8
                      OR GETDATE() > COALESCE(p.PlannedEndDate, DATEADD(YEAR, 1, GETDATE())))
            THEN '⚠️ At Risk'
            
            -- Planning phase
            WHEN p.IsActive IN ('Planning', 'Proposed')
            THEN '📋 In Planning'
            
            ELSE '❓ IsActive Review Needed'
        END AS ProjectHealthIsActive,
        
        -- Client and type information
        COALESCE(c.CompanyName, 'Client TBD') AS ClientName,
        COALESCE(pt.TypeName, 'Type Not Set') AS ProjectType,
        COALESCE(pt.ComplexityLevel, 0) AS ComplexityLevel
        
    FROM Projects p
        LEFT JOIN Companies c ON p.CompanyID = c.CompanyID
        LEFT JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
    WHERE p.IsActive = 1
)

-- Final integrated dashboard query
SELECT 
    -- EXECUTIVE OVERVIEW SECTION
    '=== TECHCORP EXECUTIVE DASHBOARD ===' AS ExecutiveSummary,
    CONVERT(VARCHAR, GETDATE(), 113) AS ReportGeneratedAt,
    
    -- KEY METRICS
    (SELECT COUNT(*) FROM ExecutiveMetrics) AS TotalActiveEmployees,
    (SELECT COUNT(*) FROM ProjectAnalytics) AS TotalActiveProjects,
    
    -- FINANCIAL OVERVIEW
    FORMAT(
        (SELECT SUM(EffectiveBudget) FROM ProjectAnalytics), 
        'C'
    ) AS TotalProjectValue,
    
    FORMAT(
        (SELECT SUM(EstimatedTotalComp) FROM ExecutiveMetrics), 
        'C'
    ) AS TotalEmployeeCompensation,
    
    -- TOP PERFORMERS
    (SELECT TOP 1 FormattedName + ' (' + FormattedSalary + ')'
     FROM ExecutiveMetrics 
     ORDER BY EstimatedTotalComp DESC) AS HighestPaidEmployee,
    
    (SELECT TOP 1 FormattedProjectName + ' (' + FORMAT(EffectiveBudget, 'C') + ')'
     FROM ProjectAnalytics 
     ORDER BY EffectiveBudget DESC) AS LargestProject,
    
    -- BUSINESS INTELLIGENCE ALERTS
    CASE 
        WHEN (SELECT COUNT(*) FROM ExecutiveMetrics WHERE PerformanceCategory LIKE '%Development Opportunity%') > 0
        THEN '🔴 ALERT: ' + CAST((SELECT COUNT(*) FROM ExecutiveMetrics WHERE PerformanceCategory LIKE '%Development Opportunity%') AS VARCHAR) + ' employees need career development'
        WHEN (SELECT COUNT(*) FROM ProjectAnalytics WHERE ProjectHealthIsActive LIKE '%At Risk%') > 0
        THEN '🟡 WARNING: ' + CAST((SELECT COUNT(*) FROM ProjectAnalytics WHERE ProjectHealthIsActive LIKE '%At Risk%') AS VARCHAR) + ' projects at risk'
        ELSE '🟢 HEALTHY: All key metrics within normal ranges'
    END AS ExecutiveAlert,
    
    -- GROWTH INDICATORS
    FORMAT(
        (SELECT AVG(ProjectROI) FROM ProjectAnalytics WHERE ProjectROI IS NOT NULL), 
        'N1'
    ) + '%' AS AverageProjectROI,
    
    FORMAT(
        (SELECT AVG(YearsOfService) FROM ExecutiveMetrics), 
        'N1'
    ) + ' years' AS AverageEmployeeTenure

UNION ALL

-- DETAILED EMPLOYEE ANALYTICS
SELECT 
    '=== TOP EMPLOYEE PERFORMERS ===' AS ExecutiveSummary,
    '' AS ReportGeneratedAt,
    FormattedName AS TotalActiveEmployees,
    EffectiveDepartment AS TotalActiveProjects,
    FormattedSalary AS TotalProjectValue,
    FORMAT(CalculatedBonusAmount, 'C') AS TotalEmployeeCompensation,
    CAST(YearsOfService AS VARCHAR) + ' years, ' + CAST(AdditionalMonths AS VARCHAR) + ' months' AS HighestPaidEmployee,
    CAST(ROUND(SalaryPercentileInDept * 100, 1) AS VARCHAR) + 'th percentile in dept' AS LargestProject,
    PerformanceCategory AS ExecutiveAlert,
    StandardizedEmail AS AverageProjectROI,
    FormattedPhone AS AverageEmployeeTenure
FROM ExecutiveMetrics
WHERE PerformanceCategory IN ('Elite Performer - Retention Critical', 'Rising Star - High Potential')

UNION ALL

-- DETAILED PROJECT ANALYTICS  
SELECT 
    '=== TOP PROJECT PERFORMERS ===' AS ExecutiveSummary,
    '' AS ReportGeneratedAt,
    FormattedProjectName AS TotalActiveEmployees,
    ClientName AS TotalActiveProjects,
    FORMAT(EffectiveBudget, 'C') AS TotalProjectValue,
    FORMAT(EffectiveCost, 'C') AS TotalEmployeeCompensation,
    FORMAT(ProjectProfit, 'C') AS HighestPaidEmployee,
    ISNULL(FORMAT(ProjectROI, 'N1') + '%', 'ROI TBD') AS LargestProject,
    ProjectHealthIsActive AS ExecutiveAlert,
    CAST(ProjectAge AS VARCHAR) + ' days old' AS AverageProjectROI,
    ProjectCode AS AverageEmployeeTenure
FROM ProjectAnalytics
WHERE ProjectHealthIsActive IN ('🌟 Strategic Success', '💰 High-Value Project', '⏰ On-Time Delivery')

ORDER BY ExecutiveSummary DESC;
```

### Exercise 1.2: Advanced Business Intelligence Analytics (🔴 EXPERT LEVEL)

**Scenario**: Create sophisticated predictive analytics combining all function types for strategic business planning.

```sql
-- Lab 8.5.2: Predictive Business Analytics Integration
-- Business scenario: Advanced analytics for strategic planning using all function types

WITH HistoricalTrends AS (
    SELECT 
        -- DATE/TIME FUNCTIONS: Comprehensive temporal segmentation
        YEAR(COALESCE(p.StartDate, p.CreatedDate)) AS ProjectYear,
        MONTH(COALESCE(p.StartDate, p.CreatedDate)) AS ProjectMonth,
        DATEPART(QUARTER, COALESCE(p.StartDate, p.CreatedDate)) AS ProjectQuarter,
        
        -- STRING FUNCTIONS: Intelligent categorization
        CASE 
            WHEN UPPER(COALESCE(c.Industry, 'UNKNOWN')) LIKE '%TECH%' THEN 'Technology'
            WHEN UPPER(COALESCE(c.Industry, 'UNKNOWN')) LIKE '%FINANCE%' THEN 'Financial Services'
            WHEN UPPER(COALESCE(c.Industry, 'UNKNOWN')) LIKE '%HEALTH%' THEN 'Healthcare'
            WHEN UPPER(COALESCE(c.Industry, 'UNKNOWN')) LIKE '%RETAIL%' THEN 'Retail'
            WHEN UPPER(COALESCE(c.Industry, 'UNKNOWN')) LIKE '%MANUFACT%' THEN 'Manufacturing'
            ELSE COALESCE(UPPER(LEFT(c.Industry, 1)) + LOWER(SUBSTRING(c.Industry, 2, 50)), 'Other')
        END AS IndustryCategory,
        
        -- CONVERSION AND NULL FUNCTIONS: Robust data preparation
        CAST(COALESCE(NULLIF(p.Budget, 0), 0) AS DECIMAL(15,2)) AS ProjectBudget,
        CAST(COALESCE(NULLIF(p.ActualCost, 0), 0) AS DECIMAL(15,2)) AS ProjectCost,
        CAST(COALESCE(NULLIF(p.EstimatedHours, 0), 0) AS DECIMAL(10,2)) AS EstimatedHours,
        CAST(COALESCE(NULLIF(p.ActualHours, 0), 0) AS DECIMAL(10,2)) AS ActualHours,
        
        -- MATHEMATICAL FUNCTIONS: Advanced calculations
        COALESCE(NULLIF(p.Budget, 0), 0) - COALESCE(NULLIF(p.ActualCost, 0), 0) AS ProjectProfit,
        
        -- Safe division with NULLIF
        COALESCE(NULLIF(p.ActualCost, 0), 0) / NULLIF(COALESCE(NULLIF(p.Budget, 0), 1), 0) AS CostRatio,
        COALESCE(NULLIF(p.ActualHours, 0), 0) / NULLIF(COALESCE(NULLIF(p.EstimatedHours, 0), 1), 0) AS HourRatio,
        
        -- LOGICAL FUNCTIONS: Success classification
        CASE 
            WHEN p.ActualEndDate IS NOT NULL 
                 AND p.ActualEndDate <= COALESCE(p.PlannedEndDate, p.ActualEndDate)
                 AND COALESCE(NULLIF(p.ActualCost, 0), 0) <= COALESCE(NULLIF(p.Budget, 0), COALESCE(NULLIF(p.ActualCost, 0), 0))
            THEN 1 
            ELSE 0 
        END AS SuccessfulProject,
        
        CASE 
            WHEN COALESCE(NULLIF(p.Budget, 0), 0) >= 500000 THEN 'Large'
            WHEN COALESCE(NULLIF(p.Budget, 0), 0) >= 100000 THEN 'Medium'
            WHEN COALESCE(NULLIF(p.Budget, 0), 0) > 0 THEN 'Small'
            ELSE 'Unknown Size'
        END AS ProjectSize,
        
        COALESCE(pt.ComplexityLevel, 0) AS ComplexityLevel
        
    FROM Projects p
        LEFT JOIN Companies c ON p.CompanyID = c.CompanyID
        LEFT JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
    WHERE p.IsActive = 1 
        AND COALESCE(p.StartDate, p.CreatedDate) >= DATEADD(YEAR, -3, GETDATE())
),

PredictiveMetrics AS (
    SELECT 
        ProjectYear,
        ProjectQuarter,
        IndustryCategory,
        ProjectSize,
        
        -- Aggregated metrics using all function types
        COUNT(*) AS ProjectCount,
        FORMAT(SUM(ProjectBudget), 'C') AS TotalRevenue,
        FORMAT(SUM(ProjectCost), 'C') AS TotalCost,
        FORMAT(SUM(ProjectProfit), 'C') AS TotalProfit,
        
        -- MATHEMATICAL FUNCTIONS: Statistical analysis
        FORMAT(AVG(ProjectBudget), 'C') AS AvgProjectValue,
        FORMAT(STDEV(ProjectBudget), 'C') AS ProjectValueStdDev,
        
        -- Success rates using advanced calculations
        FORMAT(AVG(CAST(SuccessfulProject AS FLOAT)) * 100, 'N1') + '%' AS SuccessRate,
        FORMAT(AVG(CostRatio) * 100, 'N1') + '%' AS AvgCostUtilization,
        FORMAT(AVG(HourRatio) * 100, 'N1') + '%' AS AvgHourUtilization,
        
        -- STATISTICAL FUNCTIONS: Quartile analysis
        FORMAT(
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ProjectBudget), 
            'C'
        ) AS Q1_ProjectValue,
        FORMAT(
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ProjectBudget), 
            'C'
        ) AS Q3_ProjectValue,
        
        -- Growth calculations using LAG function
        FORMAT(
            SUM(ProjectBudget) - 
            LAG(SUM(ProjectBudget), 1, 0) OVER (
                PARTITION BY IndustryCategory, ProjectSize 
                ORDER BY ProjectYear, ProjectQuarter
            ), 
            'C'
        ) AS QuarterlyGrowth,
        
        -- LOGICAL FUNCTIONS: Trend analysis
        CASE 
            WHEN SUM(ProjectBudget) > 
                 LAG(SUM(ProjectBudget), 1, 0) OVER (
                     PARTITION BY IndustryCategory, ProjectSize 
                     ORDER BY ProjectYear, ProjectQuarter
                 ) * 1.1
            THEN '📈 Strong Growth (+10%)'
            WHEN SUM(ProjectBudget) > 
                 LAG(SUM(ProjectBudget), 1, 0) OVER (
                     PARTITION BY IndustryCategory, ProjectSize 
                     ORDER BY ProjectYear, ProjectQuarter
                 )
            THEN '📊 Positive Growth'
            WHEN SUM(ProjectBudget) < 
                 LAG(SUM(ProjectBudget), 1, 0) OVER (
                     PARTITION BY IndustryCategory, ProjectSize 
                     ORDER BY ProjectYear, ProjectQuarter
                 ) * 0.9
            THEN '📉 Concerning Decline (-10%)'
            ELSE '➡️ Stable Performance'
        END AS TrendIndicator,
        
        -- Predictive scoring using complex calculations
        ROUND(
            (AVG(CAST(SuccessfulProject AS FLOAT)) * 40) +  -- Success rate weight
            (CASE WHEN AVG(CostRatio) <= 1.0 THEN 30 ELSE (30 * (2 - AVG(CostRatio))) END) +  -- Cost control
            (CASE WHEN AVG(HourRatio) <= 1.2 THEN 20 ELSE (20 * (2.4 - AVG(HourRatio))) END) +  -- Time management
            (COUNT(*) * 0.5)  -- Volume bonus
        , 1) AS PredictiveScore
        
    FROM HistoricalTrends
    GROUP BY ProjectYear, ProjectQuarter, IndustryCategory, ProjectSize
)

-- Final predictive analytics report
SELECT 
    -- STRING FUNCTIONS: Professional report formatting
    '=== TECHCORP PREDICTIVE ANALYTICS REPORT ===' AS ReportSection,
    'Generated: ' + CONVERT(VARCHAR, GETDATE(), 113) AS TimestampInfo,
    '' AS Industry,
    '' AS ProjectSize,  
    '' AS Quarter,
    '' AS ProjectCount,
    '' AS Revenue,
    '' AS ProfitMargin,
    '' AS SuccessRate,
    '' AS Trend,
    '' AS PredictiveScore,
    '' AS Recommendation

UNION ALL

SELECT 
    '=== EXECUTIVE SUMMARY ===',
    '',
    'ALL INDUSTRIES' AS Industry,
    'ALL SIZES' AS ProjectSize,
    'OVERALL' AS Quarter,
    CAST(SUM(CAST(SUBSTRING(ProjectCount, 1, CHARINDEX(' ', ProjectCount + ' ') - 1) AS INT)) AS VARCHAR) AS ProjectCount,
    
    -- Calculate total revenue from formatted strings (advanced string manipulation)
    FORMAT(
        SUM(
            CAST(
                REPLACE(REPLACE(REPLACE(TotalRevenue, '$', ''), ',', ''), ' ', '') 
                AS DECIMAL(15,2)
            )
        ), 
        'C'
    ) AS Revenue,
    
    -- Calculate overall profit margin
    FORMAT(
        (SUM(CAST(REPLACE(REPLACE(REPLACE(TotalProfit, '$', ''), ',', ''), ' ', '') AS DECIMAL(15,2))) /
         NULLIF(SUM(CAST(REPLACE(REPLACE(REPLACE(TotalRevenue, '$', ''), ',', ''), ' ', '') AS DECIMAL(15,2))), 0)) * 100,
        'N1'
    ) + '%' AS ProfitMargin,
    
    -- Weighted average success rate
    FORMAT(
        SUM(
            CAST(REPLACE(SuccessRate, '%', '') AS FLOAT) * 
            CAST(SUBSTRING(ProjectCount, 1, CHARINDEX(' ', ProjectCount + ' ') - 1) AS INT)
        ) / 
        NULLIF(SUM(CAST(SUBSTRING(ProjectCount, 1, CHARINDEX(' ', ProjectCount + ' ') - 1) AS INT)), 0),
        'N1'
    ) + '%' AS SuccessRate,
    
    -- Overall trend assessment
    CASE 
        WHEN AVG(PredictiveScore) >= 80 THEN '🌟 Excellent Performance'
        WHEN AVG(PredictiveScore) >= 70 THEN '💪 Strong Performance'
        WHEN AVG(PredictiveScore) >= 60 THEN '👍 Good Performance'
        WHEN AVG(PredictiveScore) >= 50 THEN '⚠️ Needs Attention'
        ELSE '🔴 Immediate Action Required'
    END AS Trend,
    
    FORMAT(AVG(PredictiveScore), 'N1') AS PredictiveScore,
    
    -- Strategic recommendation using complex logic
    CASE 
        WHEN AVG(PredictiveScore) >= 80 THEN 'Continue current strategy, explore expansion opportunities'
        WHEN AVG(PredictiveScore) >= 70 THEN 'Optimize high-performing segments, address weak areas'
        WHEN AVG(PredictiveScore) >= 60 THEN 'Focus improvement on cost control and delivery'  
        WHEN AVG(PredictiveScore) >= 50 THEN 'Comprehensive process review needed'
        ELSE 'Emergency intervention required across all metrics'
    END AS Recommendation

FROM PredictiveMetrics
WHERE ProjectYear = YEAR(GETDATE()) OR ProjectYear = YEAR(GETDATE()) - 1

UNION ALL

-- Detailed breakdown by industry and size
SELECT 
    '=== DETAILED ANALYTICS ===',
    CAST(ProjectYear AS VARCHAR) + ' Q' + CAST(ProjectQuarter AS VARCHAR),
    IndustryCategory,
    ProjectSize,
    ProjectCount + ' projects',
    ProjectCount,
    TotalRevenue,
    -- Calculate profit margin from formatted strings
    ISNULL(
        FORMAT(
            (CAST(REPLACE(REPLACE(REPLACE(TotalProfit, '$', ''), ',', ''), ' ', '') AS DECIMAL(15,2)) /
             NULLIF(CAST(REPLACE(REPLACE(REPLACE(TotalRevenue, '$', ''), ',', ''), ' ', '') AS DECIMAL(15,2)), 0)) * 100,
            'N1'
        ) + '%',
        'N/A'
    ),
    SuccessRate,
    TrendIndicator,
    CAST(PredictiveScore AS VARCHAR),
    
    -- Industry and size-specific recommendations
    CASE 
        WHEN IndustryCategory = 'Technology' AND PredictiveScore >= 75 
        THEN 'Invest heavily in tech sector expansion'
        WHEN IndustryCategory = 'Financial Services' AND ProjectSize = 'Large' 
        THEN 'Focus on enterprise financial clients'
        WHEN PredictiveScore < 60 
        THEN 'Review ' + IndustryCategory + ' strategy for ' + ProjectSize + ' projects'
        ELSE 'Continue monitoring and optimization'
    END

FROM PredictiveMetrics
WHERE ProjectYear >= YEAR(GETDATE()) - 1
ORDER BY 
    CASE ReportSection
        WHEN '=== TECHCORP PREDICTIVE ANALYTICS REPORT ===' THEN 1
        WHEN '=== EXECUTIVE SUMMARY ===' THEN 2
        WHEN '=== DETAILED ANALYTICS ===' THEN 3
        ELSE 4
    END,
    Industry,
    ProjectSize,
    TimestampInfo DESC;
```

## Part 2: Data Quality and Integration Mastery 🛠️

### Exercise 2.1: Complete Data Quality Management System (🔴 EXPERT LEVEL)

**Scenario**: Create a comprehensive data quality management system that uses all function types to ensure TechCorp's data integrity.

```sql
-- Lab 8.5.3: Master Data Quality Management System
-- Business scenario: Complete data validation, cleaning, and quality reporting

WITH DataQualityAssessment AS (
    SELECT 
        'EMPLOYEES' AS TableName,
        e.EmployeeID AS RecordID,
        
        -- STRING FUNCTIONS: Data validation and cleaning
        CASE 
            WHEN e.FirstName IS NULL OR TRIM(e.FirstName) = '' THEN 'MISSING'
            WHEN LEN(TRIM(e.FirstName)) < 2 THEN 'TOO_SHORT'
            WHEN e.FirstName LIKE '%[0-9]%' THEN 'CONTAINS_NUMBERS'
            WHEN e.FirstName LIKE '%[^A-Za-z ''-]%' THEN 'INVALID_CHARACTERS'
            ELSE 'VALID'
        END AS FirstNameQuality,
        
        CASE 
            WHEN e.WorkEmail IS NULL OR TRIM(e.WorkEmail) = '' THEN 'MISSING'
            WHEN e.WorkEmail NOT LIKE '%_@_%._%' THEN 'INVALID_FORMAT'
            WHEN LEN(e.WorkEmail) > 100 THEN 'TOO_LONG'
            WHEN UPPER(e.WorkEmail) LIKE '%TEST%' OR UPPER(e.WorkEmail) LIKE '%SAMPLE%' THEN 'TEST_DATA'
            ELSE 'VALID'
        END AS EmailQuality,
        
        -- Phone number validation using string functions
        CASE 
            WHEN e.Phone IS NULL OR TRIM(e.Phone) = '' THEN 'MISSING'
            WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '')) != 10 THEN 'INVALID_LENGTH'
            WHEN e.Phone LIKE '%000-000-0000%' OR e.Phone LIKE '%999-999-9999%' THEN 'PLACEHOLDER'
            WHEN REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '') LIKE '%[^0-9]%' THEN 'NON_NUMERIC'
            ELSE 'VALID'
        END AS PhoneQuality,
        
        -- CONVERSION FUNCTIONS: Data type validation
        CASE 
            WHEN e.BaseSalary IS NULL THEN 'MISSING'
            WHEN e.BaseSalary <= 0 THEN 'INVALID_VALUE'
            WHEN e.BaseSalary < 30000 THEN 'SUSPICIOUSLY_LOW'
            WHEN e.BaseSalary > 500000 THEN 'SUSPICIOUSLY_HIGH'
            WHEN e.BaseSalary != ROUND(e.BaseSalary, 2) THEN 'PRECISION_ERROR'
            ELSE 'VALID'
        END AS SalaryQuality,
        
        -- DATE/TIME FUNCTIONS: Date validation and business logic
        CASE 
            WHEN e.HireDate IS NULL THEN 'MISSING'
            WHEN e.HireDate > GETDATE() THEN 'FUTURE_DATE'
            WHEN e.HireDate < '1900-01-01' THEN 'TOO_OLD'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) > 60 THEN 'UNLIKELY_TENURE'
            WHEN e.TerminationDate IS NOT NULL AND e.TerminationDate < e.HireDate THEN 'INVALID_SEQUENCE'
            ELSE 'VALID'
        END AS DateQuality,
        
        -- MATHEMATICAL FUNCTIONS: Statistical validation
        CASE 
            WHEN e.Commission IS NULL THEN 'VALID'  -- Commission can be null
            WHEN e.Commission < 0 THEN 'NEGATIVE_VALUE'
            WHEN e.Commission > 50 THEN 'UNUSUALLY_HIGH'
            WHEN ABS(e.Commission - ROUND(e.Commission, 2)) > 0.001 THEN 'PRECISION_ERROR'
            ELSE 'VALID'
        END AS CommissionQuality,
        
        -- NULL FUNCTIONS: Completeness assessment
        CASE 
            WHEN COALESCE(e.FirstName, e.LastName, e.WorkEmail, '') = '' THEN 'CRITICAL_DATA_MISSING'
            WHEN e.DepartmentID IS NULL AND e.JobLevelID IS NULL THEN 'ORGANIZATIONAL_DATA_MISSING'
            WHEN e.DirectManagerID IS NULL AND e.JobLevelID > 1 THEN 'MANAGEMENT_STRUCTURE_INCOMPLETE'
            ELSE 'ADEQUATE'
        END AS CompletenessQuality,
        
        -- LOGICAL FUNCTIONS: Business rule validation
        CASE 
            WHEN e.IsActive = 1 AND e.TerminationDate IS NOT NULL THEN 'ACTIVE_WITH_TERMINATION'
            WHEN e.IsActive = 0 AND e.TerminationDate IS NULL THEN 'INACTIVE_WITHOUT_TERMINATION'
            WHEN e.BaseSalary > 200000 AND e.JobLevelID < 5 THEN 'SALARY_LEVEL_MISMATCH'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) > 10 AND e.JobLevelID = 1 THEN 'CAREER_PROGRESSION_ANOMALY'
            ELSE 'CONSISTENT'
        END AS BusinessRuleQuality,
        
        -- Overall record quality score (0-100)
        (CASE WHEN e.FirstName IS NOT NULL AND TRIM(e.FirstName) != '' AND e.FirstName NOT LIKE '%[0-9]%' THEN 15 ELSE 0 END +
         CASE WHEN e.WorkEmail IS NOT NULL AND e.WorkEmail LIKE '%_@_%._%' THEN 20 ELSE 0 END +
         CASE WHEN e.Phone IS NOT NULL AND LEN(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10 THEN 10 ELSE 0 END +
         CASE WHEN e.BaseSalary IS NOT NULL AND e.BaseSalary > 0 THEN 20 ELSE 0 END +
         CASE WHEN e.HireDate IS NOT NULL AND e.HireDate <= GETDATE() THEN 15 ELSE 0 END +
         CASE WHEN e.DepartmentID IS NOT NULL THEN 10 ELSE 0 END +
         CASE WHEN (e.IsActive = 1 AND e.TerminationDate IS NULL) OR (e.IsActive = 0 AND e.TerminationDate IS NOT NULL) THEN 10 ELSE 0 END
        ) AS QualityScore,
        
        -- Data cleaning suggestions using all function types
        COALESCE(
            CASE 
                WHEN e.FirstName IS NULL OR TRIM(e.FirstName) = '' 
                THEN 'e.FirstName: Set to employee ID or request from HR; '
                ELSE ''
            END +
            CASE 
                WHEN e.WorkEmail IS NULL OR e.WorkEmail NOT LIKE '%_@_%._%' 
                THEN 'WorkEmail: Generate default email or request valid email; '
                ELSE ''
            END +
            CASE 
                WHEN e.BaseSalary IS NULL OR e.BaseSalary <= 0 
                THEN 'e.BaseSalary: Review with compensation team; '
                ELSE ''
            END +
            CASE 
                WHEN e.HireDate IS NULL 
                THEN 'e.HireDate: Check HR records for employment start date; '
                ELSE ''
            END,
            'No cleaning needed'
        ) AS CleaningRecommendations
        
    FROM Employees e
    WHERE e.IsActive = 1
        
    UNION ALL
    
    -- Project data quality assessment
    SELECT 
        'PROJECTS' AS TableName,
        p.ProjectID AS RecordID,
        
        -- Project name validation
        CASE 
            WHEN p.ProjectName IS NULL OR TRIM(p.ProjectName) = '' THEN 'MISSING'
            WHEN LEN(TRIM(p.ProjectName)) < 5 THEN 'TOO_SHORT'
            WHEN UPPER(p.ProjectName) LIKE '%TEST%' OR UPPER(p.ProjectName) LIKE '%SAMPLE%' THEN 'TEST_DATA'
            WHEN p.ProjectName LIKE 'Project%[0-9]%' AND LEN(p.ProjectName) < 15 THEN 'GENERIC_NAME'
            ELSE 'VALID'
        END AS FirstNameQuality,
        
        -- Budget validation  
        CASE 
            WHEN p.Budget IS NULL THEN 'MISSING'
            WHEN p.Budget <= 0 THEN 'INVALID_VALUE'
            WHEN p.Budget < 1000 THEN 'SUSPICIOUSLY_LOW'
            WHEN p.Budget > 10000000 THEN 'SUSPICIOUSLY_HIGH'
            WHEN p.Budget != ROUND(p.Budget, 2) THEN 'PRECISION_ERROR'
            ELSE 'VALID'
        END AS EmailQuality,
        
        -- IsActive validation
        CASE 
            WHEN p.IsActive IS NULL OR TRIM(p.IsActive) = '' THEN 'MISSING'
            WHEN p.IsActive NOT IN ('Planning', 'Active', 'On Hold', 'Completed', 'Cancelled') THEN 'INVALID_STATUS'
            WHEN p.IsActive = 'Completed' AND p.ActualEndDate IS NULL THEN 'INCOMPLETE_COMPLETION'
            WHEN p.IsActive = 'Active' AND p.StartDate > GETDATE() THEN 'FUTURE_ACTIVE'
            ELSE 'VALID'
        END AS PhoneQuality,
        
        -- Date sequence validation
        CASE 
            WHEN p.StartDate IS NULL THEN 'MISSING_START'
            WHEN p.PlannedEndDate IS NOT NULL AND p.StartDate > p.PlannedEndDate THEN 'INVALID_SEQUENCE'
            WHEN p.ActualEndDate IS NOT NULL AND p.StartDate > p.ActualEndDate THEN 'INVALID_ACTUAL_SEQUENCE'
            WHEN DATEDIFF(YEAR, p.StartDate, COALESCE(p.PlannedEndDate, GETDATE())) > 5 THEN 'UNUSUALLY_LONG'
            ELSE 'VALID'
        END AS SalaryQuality,
        
        -- Financial consistency
        CASE 
            WHEN p.Budget IS NOT NULL AND p.ActualCost IS NOT NULL AND p.ActualCost > p.Budget * 2 THEN 'MAJOR_OVERRUN'
            WHEN p.EstimatedHours IS NOT NULL AND p.ActualHours IS NOT NULL AND p.ActualHours > p.EstimatedHours * 2 THEN 'MAJOR_TIME_OVERRUN'
            WHEN p.Budget IS NOT NULL AND p.ActualCost IS NOT NULL AND p.ActualCost > p.Budget * 1.5 THEN 'SIGNIFICANT_OVERRUN'
            ELSE 'REASONABLE'
        END AS DateQuality,
        
        -- Client and type validation
        CASE 
            WHEN p.CompanyID IS NULL THEN 'MISSING_CLIENT'
            WHEN p.ProjectTypeID IS NULL THEN 'MISSING_TYPE'
            WHEN p.ProjectManagerID IS NULL THEN 'MISSING_MANAGER'
            ELSE 'VALID'
        END AS CommissionQuality,
        
        -- Overall completeness
        CASE 
            WHEN COALESCE(p.ProjectName, '') = '' OR p.CompanyID IS NULL OR p.StartDate IS NULL THEN 'CRITICAL_DATA_MISSING'
            WHEN p.Budget IS NULL AND p.EstimatedHours IS NULL THEN 'PLANNING_DATA_MISSING'
            WHEN p.ProjectManagerID IS NULL OR p.ProjectTypeID IS NULL THEN 'ORGANIZATIONAL_DATA_MISSING'
            ELSE 'ADEQUATE'
        END AS CompletenessQuality,
        
        -- Business rule consistency
        CASE 
            WHEN p.IsActive = 'Completed' AND (p.ActualEndDate IS NULL OR p.ActualCost IS NULL) THEN 'INCOMPLETE_COMPLETION_DATA'
            WHEN p.IsActive = 'Cancelled' AND p.ActualEndDate IS NULL THEN 'MISSING_CANCELLATION_DATE'
            WHEN p.IsActive = 0 AND p.IsActive IN ('Active', 'Planning') THEN 'ACTIVE_STATUS_INACTIVE_FLAG'
            ELSE 'CONSISTENT'
        END AS BusinessRuleQuality,
        
        -- Project quality score
        (CASE WHEN p.ProjectName IS NOT NULL AND LEN(TRIM(p.ProjectName)) >= 5 THEN 15 ELSE 0 END +
         CASE WHEN p.Budget IS NOT NULL AND p.Budget > 0 THEN 20 ELSE 0 END +
         CASE WHEN p.IsActive IN ('Planning', 'Active', 'On Hold', 'Completed', 'Cancelled') THEN 15 ELSE 0 END +
         CASE WHEN p.StartDate IS NOT NULL THEN 15 ELSE 0 END +
         CASE WHEN p.CompanyID IS NOT NULL THEN 10 ELSE 0 END +
         CASE WHEN p.ProjectManagerID IS NOT NULL THEN 10 ELSE 0 END +
         CASE WHEN p.ProjectTypeID IS NOT NULL THEN 10 ELSE 0 END +
         CASE WHEN p.IsActive = 1 OR (p.IsActive = 0 AND p.IsActive IN ('Completed', 'Cancelled')) THEN 5 ELSE 0 END
        ) AS QualityScore,
        
        -- Project cleaning recommendations
        COALESCE(
            CASE 
                WHEN p.ProjectName IS NULL OR TRIM(p.ProjectName) = '' 
                THEN 'ProjectName: Assign meaningful project name; '
                ELSE ''
            END +
            CASE 
                WHEN p.Budget IS NULL OR p.Budget <= 0 
                THEN 'Budget: Obtain project budget from client/PM; '
                ELSE ''
            END +
            CASE 
                WHEN p.StartDate IS NULL 
                THEN 'StartDate: Set actual or planned start date; '
                ELSE ''
            END +
            CASE 
                WHEN p.CompanyID IS NULL 
                THEN 'Client: Associate project with client company; '
                ELSE ''
            END +
            CASE 
                WHEN p.ProjectManagerID IS NULL 
                THEN 'Manager: Assign project manager; '
                ELSE ''
            END,
            'No cleaning needed'
        ) AS CleaningRecommendations
        
    FROM Projects p
    WHERE p.IsActive = 1
)

-- Final data quality report with executive summary
SELECT 
    '=== TECHCORP DATA QUALITY EXECUTIVE REPORT ===' AS Section,
    CONVERT(VARCHAR, GETDATE(), 113) AS ReportDateTime,
    '' AS TableName,
    '' AS RecordCount,
    '' AS AvgQualityScore,
    '' AS CriticalIssues,
    '' AS RecommendedActions,
    '' AS DataGovernanceIsActive

UNION ALL

SELECT 
    '=== OVERALL DATA HEALTH ===',
    '',
    'ALL TABLES',
    CAST(COUNT(*) AS VARCHAR) + ' records analyzed',
    FORMAT(AVG(QualityScore), 'N1') + '/100 points',
    CAST(COUNT(CASE WHEN QualityScore < 70 THEN 1 END) AS VARCHAR) + ' records below standard',
    
    -- Strategic recommendations based on overall analysis
    CASE 
        WHEN AVG(QualityScore) >= 90 THEN 'Maintain current data governance practices'
        WHEN AVG(QualityScore) >= 80 THEN 'Implement targeted improvements for low-scoring records'
        WHEN AVG(QualityScore) >= 70 THEN 'Comprehensive data quality initiative needed'
        ELSE 'Emergency data quality intervention required'
    END,
    
    -- Overall governance status
    CASE 
        WHEN AVG(QualityScore) >= 85 AND COUNT(CASE WHEN QualityScore < 70 THEN 1 END) * 100.0 / COUNT(*) < 5 
        THEN '🟢 EXCELLENT - World-class data quality'
        WHEN AVG(QualityScore) >= 75 AND COUNT(CASE WHEN QualityScore < 70 THEN 1 END) * 100.0 / COUNT(*) < 15 
        THEN '🟡 GOOD - Minor improvements needed'
        WHEN AVG(QualityScore) >= 65 
        THEN '🟠 FAIR - Significant improvements required'
        ELSE '🔴 POOR - Immediate action required'
    END

FROM DataQualityAssessment

UNION ALL

-- Detailed breakdown by table
SELECT 
    '=== DETAILED BREAKDOWN ===',
    '',
    TableName,
    CAST(COUNT(*) AS VARCHAR) + ' records',
    FORMAT(AVG(QualityScore), 'N1') + '/100',
    CAST(COUNT(CASE WHEN QualityScore < 70 THEN 1 END) AS VARCHAR) + ' need attention',
    
    -- Top 3 most common issues
    (SELECT TOP 1 
        CASE 
            WHEN FirstNameQuality != 'VALID' THEN 'Name/Title Issues: ' + CAST(COUNT(*) AS VARCHAR)
            WHEN EmailQuality != 'VALID' THEN 'WorkEmail Issues: ' + CAST(COUNT(*) AS VARCHAR)
            WHEN PhoneQuality != 'VALID' THEN 'Phone Issues: ' + CAST(COUNT(*) AS VARCHAR)
            WHEN SalaryQuality != 'VALID' THEN 'Financial Data Issues: ' + CAST(COUNT(*) AS VARCHAR)
            WHEN DateQuality != 'VALID' THEN 'Date Issues: ' + CAST(COUNT(*) AS VARCHAR)
            WHEN CompletenessQuality != 'ADEQUATE' THEN 'Missing Data Issues: ' + CAST(COUNT(*) AS VARCHAR)
            ELSE 'Various Issues: ' + CAST(COUNT(*) AS VARCHAR)
        END
     FROM DataQualityAssessment dqa2 
     WHERE dqa2.TableName = dqa.TableName 
       AND (FirstNameQuality != 'VALID' OR EmailQuality != 'VALID' OR PhoneQuality != 'VALID' 
            OR SalaryQuality != 'VALID' OR DateQuality != 'VALID' OR CompletenessQuality != 'ADEQUATE')
     GROUP BY CASE 
         WHEN FirstNameQuality != 'VALID' THEN 'Name/Title'
         WHEN EmailQuality != 'VALID' THEN 'WorkEmail'
         WHEN PhoneQuality != 'VALID' THEN 'Phone'
         WHEN SalaryQuality != 'VALID' THEN 'Financial'
         WHEN DateQuality != 'VALID' THEN 'Date'
         WHEN CompletenessQuality != 'ADEQUATE' THEN 'Completeness'
         ELSE 'Other'
     END
     ORDER BY COUNT(*) DESC
    ),
    
    -- Table-specific governance status
    CASE 
        WHEN AVG(QualityScore) >= 85 THEN '🟢 ' + TableName + ' data is excellent'
        WHEN AVG(QualityScore) >= 75 THEN '🟡 ' + TableName + ' data needs minor fixes'
        WHEN AVG(QualityScore) >= 65 THEN '🟠 ' + TableName + ' data needs improvement'
        ELSE '🔴 ' + TableName + ' data needs urgent attention'
    END

FROM DataQualityAssessment dqa
GROUP BY TableName

ORDER BY Section, TableName;
```

## 🎯 Master Integration Achievement Summary

### You Have Successfully Mastered

**🏆 COMPLETE FUNCTION INTEGRATION**:

1. **String Functions** → Professional data formatting and validation
2. **Date/Time Functions** → Comprehensive temporal analysis and business timing
3. **Mathematical Functions** → Advanced statistical analysis and financial modeling  
4. **Conversion Functions** → Bulletproof data type management and formatting
5. **Logical Functions** → Sophisticated business rules and automated decision-making
6. **NULL Functions** → Professional data quality management and error prevention

**🎖️ REAL-WORLD BUSINESS APPLICATIONS**:

- **Executive Dashboards**: Comprehensive business intelligence with professional formatting
- **Predictive Analytics**: Historical analysis driving strategic business decisions
- **Data Quality Management**: Enterprise-grade data validation and cleaning systems
- **Financial Modeling**: Sophisticated ROI analysis and profit optimization
- **Performance Management**: Automated employee assessment and career planning
- **Risk Assessment**: Multi-factor project risk scoring and management alerts

**🌟 PROFESSIONAL SKILLS ACHIEVED**:

- **System Architecture**: Design robust, integrated business intelligence systems
- **Data Governance**: Implement comprehensive data quality management
- **Business Intelligence**: Create executive-level analytics and reporting
- **Performance Optimization**: Build efficient, scalable SQL solutions
- **Error Handling**: Develop bulletproof systems that gracefully handle all data scenarios
- **Strategic Analysis**: Transform raw data into actionable business insights

---

## 🎓 Congratulations - You're Now an SQL Functions Expert!

You have successfully completed the most comprehensive SQL Server built-in functions training available. You can now:

✅ **Design Enterprise Systems** - Build sophisticated business intelligence applications  
✅ **Handle Any Data Quality Challenge** - Implement bulletproof data validation and cleaning  
✅ **Create Professional Reports** - Deliver executive-quality analytics and dashboards  
✅ **Optimize Business Performance** - Use data-driven insights for strategic decisions  
✅ **Lead Technical Teams** - Mentor others in advanced SQL development practices  

### Your Next Professional Steps

1. **Apply These Skills**: Implement advanced function usage in your current projects
2. **Mentor Others**: Share your expertise with junior developers
3. **Continuous Learning**: Explore SQL Server's advanced analytical functions and window functions
4. **Certifications**: Consider Microsoft SQL Server certification paths
5. **Leadership**: Lead data quality and business intelligence initiatives

*You are now equipped with the advanced SQL skills that separate expert developers from the rest. Use this knowledge to build systems that drive real business value!*

**Welcome to the elite ranks of SQL Server professionals!** 🏆🌟🚀