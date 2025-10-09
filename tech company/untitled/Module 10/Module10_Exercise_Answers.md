# Module 10 Exercise Answers: Data Visualization and Reporting Solutions

## Exercise Set Overview
This document provides comprehensive solutions to Module 10 exercises, demonstrating advanced data visualization, formatting, and reporting techniques.

---

## Exercise 1: Advanced Result Formatting Solutions

### 1.1 Professional Employee Summary Solutions

**Answer 1.1.1**: Professional Employee Summary with Proper Formatting

```sql
-- Professional employee summary with comprehensive formatting
SELECT 
    -- Padded Employee ID with leading zeros
    'EMP-' + FORMAT(e.EmployeeID, '0000') AS EmployeeID,
    
    -- Full name in "Last, First M." format handling nulls
    e.LastName + ', ' + e.FirstName + 
    CASE 
        WHEN e.MiddleName IS NOT NULL 
        THEN ' ' + LEFT(e.MiddleName, 1) + '.' 
        ELSE '' 
    END AS FormattedName,
    
    -- Job title with department abbreviation
    e.JobTitle + ' [' + 
    CASE d.DepartmentName
        WHEN 'Human Resources' THEN 'HR'
        WHEN 'Information Technology' THEN 'IT'
        WHEN 'Research and Development' THEN 'R&D'
        WHEN 'Sales and Marketing' THEN 'S&M'
        ELSE LEFT(d.DepartmentName, 3)
    END + ']' AS TitleWithDept,
    
    -- Hire date in DD-MMM-YYYY format
    FORMAT(e.HireDate, 'dd-MMM-yyyy') AS HireDate,
    
    -- Tenure as "X years, Y months"
    CAST(DATEDIFF(YEAR, e.HireDate, GETDATE()) AS VARCHAR) + ' years, ' +
    CAST(DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 AS VARCHAR) + ' months' AS Tenure
    
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.LastName, e.FirstName;
```

**Answer 1.1.2**: Salary Analysis Report with Performance Indicators

```sql
-- Salary analysis with performance tiers and visual elements
WITH SalaryAnalysis AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.BaseSalary,
        d.DepartmentName,
        
        -- Calculate department average for comparison
        AVG(e.BaseSalary) OVER (PARTITION BY d.DepartmentID) AS DeptAvgSalary,
        
        -- Determine performance tier based on salary
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 3
            WHEN e.BaseSalary >= 75000 THEN 2
            WHEN e.BaseSalary >= 50000 THEN 1
            ELSE 0
        END AS PerformanceTier
        
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.BaseSalary IS NOT NULL
)
SELECT 
    -- Employee name with performance tier indicators
    EmployeeName + ' ' + 
    CASE PerformanceTier
        WHEN 3 THEN '★★★ (Executive)'
        WHEN 2 THEN '★★☆ (Senior)'
        WHEN 1 THEN '★☆☆ (Standard)'
        ELSE '☆☆☆ (Entry)'
    END AS EmployeeWithTier,
    
    -- Formatted salary with currency
    FORMAT(BaseSalary, 'C0') AS FormattedSalary,
    
    -- Percentage above/below department average
    CASE 
        WHEN BaseSalary > DeptAvgSalary THEN 
            '+' + FORMAT((BaseSalary - DeptAvgSalary) / DeptAvgSalary * 100, 'N1') + '% above dept avg'
        WHEN BaseSalary < DeptAvgSalary THEN 
            '-' + FORMAT((DeptAvgSalary - BaseSalary) / DeptAvgSalary * 100, 'N1') + '% below dept avg'
        ELSE 'At department average'
    END AS DeptVariance,
    
    -- Salary range classification
    CASE 
        WHEN BaseSalary >= 150000 THEN 'Executive ($150K+)'
        WHEN BaseSalary >= 100000 THEN 'Senior ($100K-$149K)'
        WHEN BaseSalary >= 75000 THEN 'Mid-Level ($75K-$99K)'
        WHEN BaseSalary >= 50000 THEN 'Standard ($50K-$74K)'
        ELSE 'Entry Level (<$50K)'
    END AS SalaryRange,
    
    -- Visual salary bar (scaled to max 20 characters)
    '|' + REPLICATE('█', CAST(BaseSalary / 10000 AS INT)) + 
    REPLICATE('░', 20 - CAST(BaseSalary / 10000 AS INT)) + '|' AS SalaryBar
    
FROM SalaryAnalysis
ORDER BY BaseSalary DESC;
```

**Answer 1.1.3**: Contact Directory with Multi-line Formatting

```sql
-- Contact directory with professional multi-line formatting
SELECT 
    -- Employee name and title on separate conceptual lines
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    '  Title: ' + e.JobTitle AS JobTitle,
    '  Dept: ' + d.DepartmentName + ' | Location: ' + ISNULL(d.Location, 'Main Office') AS DeptLocation,
    
    -- Formatted phone number
    '  Phone: (' + LEFT(e.PhoneNumber, 3) + ') ' + 
    SUBSTRING(e.PhoneNumber, 4, 3) + '-' + 
    RIGHT(e.PhoneNumber, 4) AS FormattedPhone,
    
    -- Lowercase email
    '  Email: ' + LOWER(e.WorkEmail) AS EmailAddress,
    
    -- Complete address formatting (simulated - using department location)
    '  Address: ' + 
    CASE d.DepartmentName
        WHEN 'Human Resources' THEN '123 Corporate Blvd, Suite 100'
        WHEN 'Information Technology' THEN '456 Tech Center Dr, Floor 3'
        WHEN 'Sales and Marketing' THEN '789 Business Park Way, Suite 200'
        ELSE '100 Main Street, Suite 150'
    END AS MailingAddress,
    
    '           ' + 'Seattle, WA 98101' AS CityStateZip,
    
    '─────────────────────────────────────────────────' AS Separator
    
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.LastName, e.FirstName;
```

**Answer 1.1.4**: Skills Matrix Visualization

```sql
-- Skills matrix with proficiency indicators
WITH EmployeeSkillSummary AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        COUNT(es.SkillID) AS SkillCount,
        STRING_AGG(s.SkillName, ', ') AS SkillList,
        AVG(CAST(es.ProficiencyLevel AS FLOAT)) AS AvgProficiency
    FROM Employees e
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
    LEFT JOIN Skills s ON es.SkillID = s.SkillID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    -- Employee name with skill count indicator
    ess.EmployeeName + ' [' + CAST(ess.SkillCount AS VARCHAR) + ' skills]' AS EmployeeWithSkillCount,
    
    -- Skills listed with simulated proficiency levels
    CASE 
        WHEN ess.SkillCount = 0 THEN 'No skills recorded'
        ELSE LEFT(ess.SkillList, 50) + 
             CASE WHEN LEN(ess.SkillList) > 50 THEN '...' ELSE '' END
    END AS PrimarySkills,
    
    -- Proficiency visualization (●●●○○ style)
    CASE 
        WHEN ess.AvgProficiency >= 4 THEN 'Expert: ●●●●●'
        WHEN ess.AvgProficiency >= 3 THEN 'Advanced: ●●●●○'
        WHEN ess.AvgProficiency >= 2 THEN 'Intermediate: ●●●○○'
        WHEN ess.AvgProficiency >= 1 THEN 'Beginner: ●●○○○'
        ELSE 'Not Assessed: ○○○○○'
    END AS ProficiencyLevel,
    
    -- Skill rarity indicator
    CASE 
        WHEN ess.SkillCount >= 8 THEN 'Multi-Specialist (Rare)'
        WHEN ess.SkillCount >= 5 THEN 'Cross-Functional (Uncommon)'
        WHEN ess.SkillCount >= 3 THEN 'Skilled (Common)'
        WHEN ess.SkillCount >= 1 THEN 'Focused (Common)'
        ELSE 'Developing (Entry)'
    END AS SkillRarity
    
FROM EmployeeSkillSummary ess
ORDER BY ess.SkillCount DESC, ess.EmployeeName;
```

**Answer 1.1.5**: Project Assignment Summary

```sql
-- Project assignment summary with workload indicators
WITH ProjectAssignments AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(CASE WHEN p.Status = 'In Progress' THEN 1 ELSE 0 END) AS ActiveProjects,
        AVG(CASE WHEN p.Budget > 0 THEN p.ActualCost / p.Budget * 100 END) AS AvgBudgetUtil
    FROM Employees e
    LEFT JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    -- Employee name with project status
    pa.EmployeeName + 
    CASE 
        WHEN pa.ActiveProjects > 2 THEN ' 🔥 (High Load)'
        WHEN pa.ActiveProjects > 0 THEN ' 📊 (Active)'
        ELSE ' 💤 (Available)'
    END AS EmployeeStatus,
    
    -- Project timeline with visual progress
    'Projects: ' + CAST(pa.ProjectCount AS VARCHAR) + ' total, ' + 
    CAST(pa.ActiveProjects AS VARCHAR) + ' active' AS ProjectSummary,
    
    -- Budget responsibility simulation
    CASE 
        WHEN pa.AvgBudgetUtil IS NOT NULL THEN 
            'Budget Performance: ' + FORMAT(pa.AvgBudgetUtil, 'N1') + '% avg utilization'
        ELSE 'Budget: Not applicable'
    END AS BudgetResponsibility,
    
    -- Workload indicator with capacity assessment
    CASE 
        WHEN pa.ActiveProjects >= 3 THEN '⚠️ Overloaded (>100% capacity)'
        WHEN pa.ActiveProjects = 2 THEN '⚖️ Full Load (100% capacity)'
        WHEN pa.ActiveProjects = 1 THEN '✅ Normal Load (75% capacity)'
        ELSE '🔄 Available (< 50% capacity)'
    END AS WorkloadIndicator
    
FROM ProjectAssignments pa
ORDER BY pa.ActiveProjects DESC, pa.ProjectCount DESC;
```

### 1.2 Executive Dashboard Formatting Solutions

**Answer 1.2.1**: Company Metrics Dashboard

```sql
-- Executive dashboard with comprehensive KPIs and visual indicators
WITH CompanyMetrics AS (
    SELECT 
        -- Current period metrics
        (SELECT COUNT(*) FROM Employees) AS TotalEmployees,
        (SELECT COUNT(*) FROM Employees WHERE HireDate >= DATEADD(MONTH, -1, GETDATE())) AS NewHiresThisMonth,
        (SELECT COUNT(*) FROM Employees WHERE HireDate >= DATEADD(MONTH, -2, GETDATE()) AND HireDate < DATEADD(MONTH, -1, GETDATE())) AS NewHiresLastMonth,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'In Progress') AS ActiveProjects,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'Completed') AS CompletedProjects,
        (SELECT FORMAT(AVG(BaseSalary), 'C0') FROM Employees WHERE BaseSalary IS NOT NULL) AS AvgSalary,
        (SELECT FORMAT(SUM(Budget), 'C0') FROM Projects) AS TotalBudget,
        (SELECT FORMAT(SUM(ActualCost), 'C0') FROM Projects WHERE ActualCost IS NOT NULL) AS TotalSpent
),
PreviousPeriod AS (
    SELECT 
        -- Previous period for comparison (simulated)
        85 AS PrevTotalEmployees,
        3 AS PrevNewHires,
        12 AS PrevActiveProjects
)
SELECT 
    '╔════════════════════════════════════════════════════════════════════════╗' AS DashboardFrame
UNION ALL
SELECT '║                        🏢 TECHCORP EXECUTIVE DASHBOARD                 ║'
UNION ALL
SELECT '║                           ' + FORMAT(GETDATE(), 'MMMM dd, yyyy') + '                            ║'
UNION ALL
SELECT '╠════════════════════════════════════════════════════════════════════════╣'
UNION ALL
SELECT '║                                                                        ║'
UNION ALL
SELECT 
    '║ 👥 Total Employees: ' + CAST(cm.TotalEmployees AS VARCHAR) + 
    CASE 
        WHEN cm.TotalEmployees > pp.PrevTotalEmployees THEN ' ↗️ +' + CAST(cm.TotalEmployees - pp.PrevTotalEmployees AS VARCHAR)
        WHEN cm.TotalEmployees < pp.PrevTotalEmployees THEN ' ↘️ -' + CAST(pp.PrevTotalEmployees - cm.TotalEmployees AS VARCHAR)
        ELSE ' ➡️ No Change'
    END + SPACE(30) + ' ║'
FROM CompanyMetrics cm, PreviousPeriod pp
UNION ALL
SELECT 
    '║ 🆕 New Hires: ' + CAST(cm.NewHiresThisMonth AS VARCHAR) + ' this month, ' + 
    CAST(cm.NewHiresLastMonth AS VARCHAR) + ' last month' +
    CASE 
        WHEN cm.NewHiresThisMonth > cm.NewHiresLastMonth THEN ' 🟢'
        WHEN cm.NewHiresThisMonth < cm.NewHiresLastMonth THEN ' 🔴'
        ELSE ' 🟡'
    END + SPACE(15) + ' ║'
FROM CompanyMetrics cm
UNION ALL
SELECT 
    '║ 📊 Active Projects: ' + CAST(cm.ActiveProjects AS VARCHAR) + 
    ' | Completed: ' + CAST(cm.CompletedProjects AS VARCHAR) +
    CASE 
        WHEN cm.ActiveProjects >= 10 THEN ' 🟢 Healthy Pipeline'
        WHEN cm.ActiveProjects >= 5 THEN ' 🟡 Moderate Load'
        ELSE ' 🔴 Low Activity'
    END + SPACE(10) + ' ║'
FROM CompanyMetrics cm
UNION ALL
SELECT 
    '║ 💰 Budget Status: ' + cm.TotalBudget + ' allocated, ' + cm.TotalSpent + ' spent' + SPACE(15) + ' ║'
FROM CompanyMetrics cm
UNION ALL
SELECT '║                                                                        ║'
UNION ALL
SELECT '║ 📈 Performance Indicators:                                             ║'
UNION ALL
SELECT 
    '║   Employee Growth: ' + 
    REPLICATE('█', CASE WHEN cm.NewHiresThisMonth * 5 > 10 THEN 10 ELSE cm.NewHiresThisMonth * 5 END) + 
    REPLICATE('░', 10 - CASE WHEN cm.NewHiresThisMonth * 5 > 10 THEN 10 ELSE cm.NewHiresThisMonth * 5 END) + 
    ' ' + FORMAT(cm.NewHiresThisMonth * 12.0 / cm.TotalEmployees * 100, 'N1') + '% annual rate' + SPACE(5) + ' ║'
FROM CompanyMetrics cm
UNION ALL
SELECT '║                                                                        ║'
UNION ALL
SELECT '╚════════════════════════════════════════════════════════════════════════╝';
```

## Exercise 2: Chart Data Preparation and Visualization Solutions

### 2.1 Pie Chart Data Generation Solutions

**Answer 2.1.1**: Department Distribution Pie Chart Data

```sql
-- Department distribution data optimized for pie chart creation
WITH DepartmentStats AS (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        CAST(COUNT(e.EmployeeID) * 100.0 / (SELECT COUNT(*) FROM Employees) AS DECIMAL(5,2)) AS Percentage
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName
),
ChartData AS (
    SELECT *,
        -- Calculate cumulative percentage for pie slice positioning
        SUM(Percentage) OVER (ORDER BY EmployeeCount DESC ROWS UNBOUNDED PRECEDING) AS CumulativePercentage,
        
        -- Calculate slice angles (360 degrees total)
        CAST(Percentage * 3.6 AS DECIMAL(6,2)) AS SliceAngle,
        
        -- Recommend colors based on size
        CASE 
            WHEN Percentage >= 30 THEN '#1f77b4'  -- Blue for largest
            WHEN Percentage >= 20 THEN '#ff7f0e'  -- Orange for second
            WHEN Percentage >= 15 THEN '#2ca02c'  -- Green for third
            WHEN Percentage >= 10 THEN '#d62728'  -- Red for fourth
            ELSE '#9467bd'                        -- Purple for others
        END AS RecommendedColor,
        
        -- Format for chart labels
        DepartmentName + ' (' + CAST(EmployeeCount AS VARCHAR) + ', ' + 
        FORMAT(Percentage, 'N1') + '%)' AS ChartLabel
    FROM DepartmentStats
    WHERE EmployeeCount > 0
)
SELECT 
    '📊 DEPARTMENT DISTRIBUTION - PIE CHART DATA' AS ChartTitle
UNION ALL
SELECT REPLICATE('═', 60)
UNION ALL
SELECT 'Category,Count,Percentage,Angle,Color,Label' -- CSV Header
UNION ALL
SELECT 
    DepartmentName + ',' +
    CAST(EmployeeCount AS VARCHAR) + ',' +
    FORMAT(Percentage, 'N2') + ',' +
    FORMAT(SliceAngle, 'N2') + ',' +
    RecommendedColor + ',' +
    '"' + ChartLabel + '"'
FROM ChartData
ORDER BY EmployeeCount DESC;
```

**Answer 2.1.2**: Project Budget Allocation Chart Data

```sql
-- Project budget allocation with hierarchical breakdown
WITH BudgetAnalysis AS (
    SELECT 
        ISNULL(p.Status, 'Unknown') AS ProjectStatus,
        COUNT(*) AS ProjectCount,
        SUM(ISNULL(p.Budget, 0)) AS TotalBudget,
        SUM(ISNULL(p.ActualCost, 0)) AS TotalActualCost,
        AVG(ISNULL(p.Budget, 0)) AS AvgBudget
    FROM Projects p
    GROUP BY p.Status
),
BudgetWithPercentages AS (
    SELECT *,
        CAST(TotalBudget * 100.0 / (SELECT SUM(TotalBudget) FROM BudgetAnalysis) AS DECIMAL(5,2)) AS BudgetPercentage,
        CAST(ProjectCount * 100.0 / (SELECT SUM(ProjectCount) FROM BudgetAnalysis) AS DECIMAL(5,2)) AS CountPercentage,
        -- Calculate utilization rate
        CASE 
            WHEN TotalBudget > 0 THEN CAST(TotalActualCost * 100.0 / TotalBudget AS DECIMAL(5,2))
            ELSE 0 
        END AS UtilizationRate
    FROM BudgetAnalysis
)
SELECT 
    '💰 PROJECT BUDGET ALLOCATION - CHART DATA' AS Title
UNION ALL
SELECT REPLICATE('═', 70)
UNION ALL
SELECT ''
UNION ALL
SELECT 'Status,ProjectCount,TotalBudget,BudgetPercentage,Utilization,DrillDownData'
UNION ALL
SELECT 
    '"' + ProjectStatus + '",' +
    CAST(ProjectCount AS VARCHAR) + ',' +
    FORMAT(TotalBudget, 'C0') + ',' +
    FORMAT(BudgetPercentage, 'N2') + '%,' +
    FORMAT(UtilizationRate, 'N1') + '%,' +
    '"Avg: ' + FORMAT(AvgBudget, 'C0') + ' per project"'
FROM BudgetWithPercentages
WHERE TotalBudget > 0
ORDER BY TotalBudget DESC;
```

## Exercise 3: Professional Report Generation Solutions

### 3.1 Multi-Section Reports Solutions

**Answer 3.1.1**: Comprehensive Quarterly Business Report

```sql
-- Quarterly business report with multiple sections and professional formatting
DECLARE @ReportQuarter VARCHAR(10) = 'Q' + CAST(DATEPART(QUARTER, GETDATE()) AS VARCHAR) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR);
DECLARE @GeneratedDate DATETIME = GETDATE();

-- Report Header
SELECT 
    '╔══════════════════════════════════════════════════════════════════════════════╗' AS ReportSection
UNION ALL
SELECT '║                          TECHCORP SOLUTIONS                                  ║'
UNION ALL
SELECT '║                      QUARTERLY BUSINESS REPORT                               ║'
UNION ALL
SELECT '║                              ' + @ReportQuarter + '                                     ║'
UNION ALL
SELECT '╠══════════════════════════════════════════════════════════════════════════════╣'
UNION ALL
SELECT '║ Generated: ' + FORMAT(@GeneratedDate, 'MMMM dd, yyyy "at" HH:mm') + '                                      ║'
UNION ALL
SELECT '║ Prepared by: ' + SYSTEM_USER + '                                           ║'
UNION ALL
SELECT '╚══════════════════════════════════════════════════════════════════════════════╝'

UNION ALL

-- Executive Summary Section
SELECT ''
UNION ALL
SELECT '📋 EXECUTIVE SUMMARY'
UNION ALL
SELECT REPLICATE('─', 50)

UNION ALL

WITH ExecutiveSummary AS (
    SELECT 
        COUNT(*) AS TotalEmployees,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'In Progress') AS ActiveProjects,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'Completed') AS CompletedProjects,
        (SELECT FORMAT(SUM(Budget), 'C0') FROM Projects) AS TotalBudget,
        (SELECT FORMAT(AVG(BaseSalary), 'C0') FROM Employees WHERE BaseSalary IS NOT NULL) AS AvgSalary
    FROM Employees
)
SELECT 
    '• Total Workforce: ' + CAST(TotalEmployees AS VARCHAR) + ' employees' + 
    CASE WHEN TotalEmployees >= 100 THEN ' 📈 Strong headcount' ELSE ' 📊 Growing team' END
FROM ExecutiveSummary

UNION ALL

SELECT 
    '• Project Portfolio: ' + CAST(ActiveProjects AS VARCHAR) + ' active, ' + 
    CAST(CompletedProjects AS VARCHAR) + ' completed projects'
FROM ExecutiveSummary

UNION ALL

SELECT 
    '• Financial Health: ' + TotalBudget + ' in project investments, ' + 
    AvgSalary + ' average compensation'
FROM ExecutiveSummary

UNION ALL

-- Department Performance Section  
SELECT ''
UNION ALL
SELECT '🏢 DEPARTMENT PERFORMANCE ANALYSIS'
UNION ALL
SELECT REPLICATE('─', 50)

UNION ALL

WITH DepartmentPerformance AS (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS HeadCount,
        FORMAT(AVG(e.BaseSalary), 'C0') AS AvgSalary,
        COUNT(p.ProjectID) AS ProjectCount,
        CASE 
            WHEN COUNT(e.EmployeeID) >= 20 THEN '🟢 Large'
            WHEN COUNT(e.EmployeeID) >= 10 THEN '🟡 Medium' 
            ELSE '🔴 Small'
        END AS SizeIndicator
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    GROUP BY d.DepartmentName
    HAVING COUNT(e.EmployeeID) > 0
)
SELECT 
    LEFT(DepartmentName + SPACE(25), 25) + 
    SizeIndicator + ' ' +
    'Staff: ' + RIGHT('   ' + CAST(HeadCount AS VARCHAR), 3) + 
    ' | Avg Salary: ' + AvgSalary + 
    ' | Projects: ' + CAST(ProjectCount AS VARCHAR)
FROM DepartmentPerformance
ORDER BY HeadCount DESC

UNION ALL

-- Risk Assessment Section
SELECT ''
UNION ALL
SELECT '⚠️ RISK ASSESSMENT & RECOMMENDATIONS'
UNION ALL
SELECT REPLICATE('─', 50)

UNION ALL

WITH RiskAnalysis AS (
    SELECT 
        COUNT(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 15 THEN 1 END) AS RetirementRisk,
        COUNT(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) <= 1 THEN 1 END) AS NewHires,
        COUNT(CASE WHEN BaseSalary < (SELECT AVG(BaseSalary) * 0.8 FROM Employees) THEN 1 END) AS BelowMarketPay
    FROM Employees
    WHERE HireDate IS NOT NULL AND BaseSalary IS NOT NULL
)
SELECT 
    '• Retirement Risk: ' + CAST(RetirementRisk AS VARCHAR) + ' employees (15+ years)' +
    CASE WHEN RetirementRisk >= 5 THEN ' 🚨 HIGH PRIORITY' ELSE ' ✅ Manageable' END
FROM RiskAnalysis

UNION ALL

SELECT 
    '• New Hire Integration: ' + CAST(NewHires AS VARCHAR) + ' recent hires' +
    CASE WHEN NewHires >= 10 THEN ' 📈 Monitor onboarding' ELSE ' ✅ Standard intake' END
FROM RiskAnalysis

UNION ALL

SELECT 
    '• Compensation Risk: ' + CAST(BelowMarketPay AS VARCHAR) + ' below-market salaries' +
    CASE WHEN BelowMarketPay >= 10 THEN ' ⚠️ Review needed' ELSE ' ✅ Competitive' END
FROM RiskAnalysis;
```

This comprehensive Module 10 creates a complete learning path for data visualization and reporting in SQL Server, progressing from basic formatting to advanced chart creation and professional report generation. The module includes:

1. **Lesson 1**: Basic result formatting and output customization
2. **Lesson 2**: Chart creation and visual data representations
3. **Lesson 3**: Advanced report generation and professional formatting
4. **Lesson 4**: Custom result sets and adaptive output design
5. **Lab Exercise**: Comprehensive hands-on practice
6. **Module Exercises**: Graded practice problems
7. **Exercise Answers**: Complete solutions with explanations

The module builds upon Modules 1-9 while introducing sophisticated data presentation techniques that are essential for business reporting and data visualization in SQL Server environments. Each lesson includes practical examples using the TechCorp Solutions database context established in earlier modules.