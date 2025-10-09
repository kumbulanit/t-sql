# Lesson 3: Advanced Report Generation and Output Formatting

## Learning Objectives

- Master advanced report generation techniques
- Learn to create professional-looking reports from SQL queries
- Understand output formatting for different audiences
- Explore automated report generation concepts

## 3.1 Introduction to SQL Server Reporting

Reports transform raw data into meaningful information for decision-makers. This lesson covers creating reports directly from SQL queries and formatting them for professional presentation.

### Types of Reports

- **Operational Reports**: Day-to-day business operations
- **Analytical Reports**: Trends and patterns analysis  
- **Executive Dashboards**: High-level summaries
- **Compliance Reports**: Regulatory requirements
- **Ad-hoc Reports**: Custom queries and analysis

## 3.2 Creating Professional Report Headers and Footers

### Standard Report Header Template

```sql
-- Report header information
DECLARE @ReportDate DATETIME = GETDATE();
DECLARE @ReportTitle VARCHAR(100) = 'TechCorp Solutions - Employee Analysis Report';

SELECT 
    '================================================================================================' AS ReportSeparator
UNION ALL
SELECT @ReportTitle
UNION ALL  
SELECT 'Generated on: ' + FORMAT(@ReportDate, 'MMMM dd, yyyy') + ' at ' + FORMAT(@ReportDate, 'hh:mm tt')
UNION ALL
SELECT 'Report Period: ' + FORMAT(DATEADD(MONTH, -1, @ReportDate), 'MMMM yyyy')
UNION ALL
SELECT '================================================================================================'
UNION ALL
SELECT ''; -- Empty line

-- Main report data follows
SELECT 
    '📊 DEPARTMENT SUMMARY' AS SectionTitle
UNION ALL
SELECT '';
```

### Dynamic Report Metadata

```sql
-- Create comprehensive report metadata
WITH ReportMetadata AS (
    SELECT 
        GETDATE() AS GeneratedOn,
        SYSTEM_USER AS GeneratedBy,
        @@SERVERNAME AS ServerName,
        DB_NAME() AS DatabaseName,
        (SELECT COUNT(*) FROM Employees) AS TotalEmployees,
        (SELECT COUNT(*) FROM Departments) AS TotalDepartments,
        (SELECT COUNT(*) FROM Projects) AS TotalProjects
)
SELECT 
    '╔════════════════════════════════════════════════════════════════════╗' AS ReportBorder
UNION ALL
SELECT '║                    TECHCORP SOLUTIONS ANALYTICS REPORT                    ║'
UNION ALL
SELECT '╠════════════════════════════════════════════════════════════════════╣'
UNION ALL
SELECT '║ Generated: ' + LEFT(FORMAT(GeneratedOn, 'yyyy-MM-dd HH:mm:ss') + SPACE(50), 50) + ' ║'
FROM ReportMetadata
UNION ALL
SELECT '║ By User: ' + LEFT(SYSTEM_USER + SPACE(50), 50) + ' ║'
UNION ALL
SELECT '║ Server: ' + LEFT(@@SERVERNAME + SPACE(50), 50) + ' ║'
FROM ReportMetadata
UNION ALL
SELECT '╚════════════════════════════════════════════════════════════════════╝'
UNION ALL
SELECT '';
```

## 3.3 Formatted Summary Reports

### Executive Summary Format

```sql
-- Executive summary with key metrics
WITH ExecutiveSummary AS (
    SELECT 
        (SELECT COUNT(*) FROM Employees WHERE HireDate >= DATEADD(YEAR, -1, GETDATE())) AS NewHiresLastYear,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'Completed') AS CompletedProjects,
        (SELECT COUNT(*) FROM Projects WHERE Status = 'In Progress') AS ActiveProjects,
        (SELECT FORMAT(AVG(BaseSalary), 'C0') FROM Employees WHERE BaseSalary IS NOT NULL) AS AverageSalary,
        (SELECT FORMAT(SUM(Budget), 'C0') FROM Projects) AS TotalProjectBudget,
        (SELECT COUNT(DISTINCT DepartmentID) FROM Employees) AS ActiveDepartments
)
SELECT 
    '🏢 EXECUTIVE SUMMARY' AS MetricCategory,
    '' AS Metric,
    '' AS Value,
    '' AS Notes
UNION ALL
SELECT 
    '─────────────────────────────────────────────────────────────────',
    '', '', ''
UNION ALL
SELECT 
    '👥 Human Resources',
    'Total Active Employees',
    CAST((SELECT COUNT(*) FROM Employees) AS VARCHAR),
    'Current workforce'
UNION ALL
SELECT 
    '',
    'New Hires (Last 12 Months)',
    CAST(NewHiresLastYear AS VARCHAR),
    'Growth indicator'
FROM ExecutiveSummary
UNION ALL
SELECT 
    '',
    'Average Employee Salary',
    AverageSalary,
    'Compensation benchmark'
FROM ExecutiveSummary
UNION ALL
SELECT 
    '💼 Project Portfolio',
    'Active Projects',
    CAST(ActiveProjects AS VARCHAR),
    'Currently in progress'
FROM ExecutiveSummary
UNION ALL
SELECT 
    '',
    'Completed Projects',
    CAST(CompletedProjects AS VARCHAR),
    'Successfully delivered'
FROM ExecutiveSummary
UNION ALL
SELECT 
    '',
    'Total Project Investment',
    TotalProjectBudget,
    'Combined budget allocation'
FROM ExecutiveSummary;
```

### Detailed Department Report

```sql
-- Comprehensive department analysis report
WITH DepartmentAnalysis AS (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        FORMAT(AVG(e.BaseSalary), 'C0') AS AverageSalary,
        FORMAT(SUM(e.BaseSalary), 'C0') AS TotalPayroll,
        COUNT(p.ProjectID) AS ProjectCount,
        FORMAT(SUM(p.Budget), 'C0') AS TotalProjectBudget,
        FORMAT(AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())), 'N1') AS AverageTenure
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    GROUP BY d.DepartmentName, d.DepartmentID
)
SELECT 
    '📈 DEPARTMENT PERFORMANCE ANALYSIS' AS ReportSection
UNION ALL
SELECT REPLICATE('═', 80)
UNION ALL
SELECT ''
UNION ALL
SELECT 
    LEFT(DepartmentName + SPACE(25), 25) +
    LEFT('Employees: ' + CAST(EmployeeCount AS VARCHAR) + SPACE(15), 15) +
    LEFT('Avg Salary: ' + AverageSalary + SPACE(20), 20) +
    'Projects: ' + CAST(ProjectCount AS VARCHAR)
FROM DepartmentAnalysis
WHERE EmployeeCount > 0
UNION ALL
SELECT ''
UNION ALL
SELECT '💰 FINANCIAL SUMMARY BY DEPARTMENT'
UNION ALL
SELECT REPLICATE('─', 80)
UNION ALL
SELECT 
    LEFT(DepartmentName + SPACE(25), 25) +
    LEFT('Payroll: ' + TotalPayroll + SPACE(20), 20) +
    'Project Budget: ' + ISNULL(TotalProjectBudget, '$0')
FROM DepartmentAnalysis
WHERE EmployeeCount > 0
ORDER BY CASE WHEN ReportSection LIKE '%DEPARTMENT%' THEN 1 ELSE 2 END;
```

## 3.4 Trend Analysis Reports

### Monthly Hiring Trends

```sql
-- Hiring trends with visual indicators
WITH MonthlyHiring AS (
    SELECT 
        YEAR(HireDate) AS HireYear,
        MONTH(HireDate) AS HireMonth,
        DATENAME(MONTH, HireDate) AS MonthName,
        COUNT(*) AS NewHires
    FROM Employees 
    WHERE HireDate >= DATEADD(YEAR, -2, GETDATE())
    GROUP BY YEAR(HireDate), MONTH(HireDate), DATENAME(MONTH, HireDate)
),
TrendData AS (
    SELECT *,
        LAG(NewHires) OVER (ORDER BY HireYear, HireMonth) AS PreviousMonth,
        AVG(NewHires) OVER () AS OverallAverage
    FROM MonthlyHiring
)
SELECT 
    '📅 HIRING TRENDS ANALYSIS (Last 24 Months)' AS ReportTitle
UNION ALL
SELECT REPLICATE('═', 70)
UNION ALL
SELECT ''
UNION ALL
SELECT 
    LEFT(MonthName + ' ' + CAST(HireYear AS VARCHAR) + SPACE(20), 20) +
    LEFT('New Hires: ' + CAST(NewHires AS VARCHAR) + SPACE(15), 15) +
    CASE 
        WHEN PreviousMonth IS NULL THEN 'Trend: N/A'
        WHEN NewHires > PreviousMonth THEN 'Trend: ↗️ +' + CAST(NewHires - PreviousMonth AS VARCHAR)
        WHEN NewHires < PreviousMonth THEN 'Trend: ↘️ -' + CAST(PreviousMonth - NewHires AS VARCHAR)
        ELSE 'Trend: ➡️ No Change'
    END AS TrendLine
FROM TrendData
ORDER BY HireYear DESC, HireMonth DESC;
```

### Project Performance Dashboard

```sql
-- Project performance metrics report
WITH ProjectMetrics AS (
    SELECT 
        p.Status,
        COUNT(*) AS ProjectCount,
        FORMAT(AVG(p.Budget), 'C0') AS AverageBudget,
        FORMAT(SUM(p.Budget), 'C0') AS TotalBudget,
        FORMAT(AVG(p.ActualCost), 'C0') AS AverageActualCost,
        FORMAT(SUM(p.ActualCost), 'C0') AS TotalActualCost,
        FORMAT(AVG(CASE WHEN p.Budget > 0 THEN p.ActualCost / p.Budget * 100 END), 'N1') AS AvgUtilizationPercent
    FROM Projects p
    WHERE p.Budget IS NOT NULL
    GROUP BY p.Status
)
SELECT 
    '🎯 PROJECT PORTFOLIO DASHBOARD' AS Header
UNION ALL
SELECT REPLICATE('═', 90)
UNION ALL
SELECT ''
UNION ALL
SELECT 
    LEFT('Status: ' + ISNULL(Status, 'Unknown') + SPACE(20), 20) +
    LEFT('Count: ' + CAST(ProjectCount AS VARCHAR) + SPACE(12), 12) +
    LEFT('Budget: ' + TotalBudget + SPACE(18), 18) +
    LEFT('Actual: ' + TotalActualCost + SPACE(18), 18) +
    'Utilization: ' + AvgUtilizationPercent + '%'
FROM ProjectMetrics
UNION ALL
SELECT ''
UNION ALL
SELECT '💡 KEY INSIGHTS:'
UNION ALL
SELECT '• Budget vs Actual performance by project status'
UNION ALL
SELECT '• Resource utilization efficiency metrics'
UNION ALL
SELECT '• Portfolio distribution analysis';
```

## 3.5 Automated Report Scheduling Concepts

### Report Parameter Templates

```sql
-- Parameterized report template
DECLARE @StartDate DATE = DATEADD(MONTH, -1, GETDATE());
DECLARE @EndDate DATE = GETDATE();
DECLARE @DepartmentFilter VARCHAR(50) = NULL; -- NULL = All Departments

WITH ParameterizedReport AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.JobTitle,
        e.HireDate,
        FORMAT(e.BaseSalary, 'C0') AS Salary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE 
        (@DepartmentFilter IS NULL OR d.DepartmentName = @DepartmentFilter)
        AND e.HireDate BETWEEN @StartDate AND @EndDate
)
SELECT 
    '📋 EMPLOYEE REPORT - ' + 
    CASE WHEN @DepartmentFilter IS NULL 
         THEN 'ALL DEPARTMENTS' 
         ELSE UPPER(@DepartmentFilter) 
    END AS ReportTitle
UNION ALL
SELECT 'Period: ' + FORMAT(@StartDate, 'MMM dd, yyyy') + ' to ' + FORMAT(@EndDate, 'MMM dd, yyyy')
UNION ALL
SELECT REPLICATE('─', 80)
UNION ALL
SELECT ''
UNION ALL
SELECT 
    LEFT(EmployeeName + SPACE(30), 30) +
    LEFT(DepartmentName + SPACE(20), 20) +
    LEFT(JobTitle + SPACE(25), 25) +
    Salary
FROM ParameterizedReport;
```

### Export-Ready Format

```sql
-- CSV-friendly report format
SELECT 
    '"Report_Type","Department","Metric","Value","Period"' AS CSVHeader
UNION ALL
SELECT 
    '"Employee Count","' + d.DepartmentName + '","Total Employees","' + 
    CAST(COUNT(e.EmployeeID) AS VARCHAR) + '","' + 
    FORMAT(GETDATE(), 'yyyy-MM') + '"'
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
UNION ALL
SELECT 
    '"Salary Analysis","' + d.DepartmentName + '","Average Salary","' + 
    FORMAT(AVG(e.BaseSalary), 'C0') + '","' + 
    FORMAT(GETDATE(), 'yyyy-MM') + '"'
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.BaseSalary IS NOT NULL
GROUP BY d.DepartmentName;
```

## 3.6 Report Quality and Validation

### Data Quality Checks

```sql
-- Report validation and quality checks
WITH DataQuality AS (
    SELECT 
        'Employee Data' AS DataCategory,
        COUNT(*) AS TotalRecords,
        SUM(CASE WHEN FirstName IS NULL OR LastName IS NULL THEN 1 ELSE 0 END) AS MissingNames,
        SUM(CASE WHEN WorkEmail IS NULL THEN 1 ELSE 0 END) AS MissingEmails,
        SUM(CASE WHEN BaseSalary IS NULL THEN 1 ELSE 0 END) AS MissingSalaries,
        SUM(CASE WHEN HireDate IS NULL THEN 1 ELSE 0 END) AS MissingHireDates
    FROM Employees
    
    UNION ALL
    
    SELECT 
        'Project Data',
        COUNT(*),
        SUM(CASE WHEN ProjectName IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN Status IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN Budget IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN StartDate IS NULL THEN 1 ELSE 0 END)
    FROM Projects
)
SELECT 
    '🔍 DATA QUALITY REPORT' AS QualityHeader
UNION ALL
SELECT REPLICATE('═', 60)
UNION ALL
SELECT ''
UNION ALL
SELECT 
    LEFT(DataCategory + SPACE(20), 20) +
    'Records: ' + CAST(TotalRecords AS VARCHAR) + 
    ' | Missing Names: ' + CAST(MissingNames AS VARCHAR) +
    ' | Missing Key Fields: ' + CAST(MissingEmails + MissingSalaries AS VARCHAR)
FROM DataQuality;
```

## 3.7 Interactive Report Features

### Drill-Down Report Structure

```sql
-- Hierarchical drill-down report
WITH HierarchicalData AS (
    -- Level 1: Company Overview
    SELECT 
        1 AS Level,
        'COMPANY' AS Category,
        'TechCorp Solutions' AS Name,
        CAST((SELECT COUNT(*) FROM Employees) AS VARCHAR) AS Value,
        'Total Employees' AS Metric
        
    UNION ALL
    
    -- Level 2: Department Summary
    SELECT 
        2,
        'DEPARTMENT',
        d.DepartmentName,
        CAST(COUNT(e.EmployeeID) AS VARCHAR),
        'Employees'
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName
    
    UNION ALL
    
    -- Level 3: Individual Employees
    SELECT 
        3,
        'EMPLOYEE',
        e.FirstName + ' ' + e.LastName,
        FORMAT(e.BaseSalary, 'C0'),
        'Salary'
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
)
SELECT 
    REPLICATE('  ', Level - 1) + 
    CASE Level 
        WHEN 1 THEN '🏢 '
        WHEN 2 THEN '📊 '
        WHEN 3 THEN '👤 '
    END +
    Name + ' (' + Value + ' ' + Metric + ')'
FROM HierarchicalData
ORDER BY Level, Name;
```

## 3.8 Practical Exercises

### Exercise 1: Monthly Business Report

Create a comprehensive monthly business report including:

- Executive summary with key metrics
- Department performance analysis
- Project status overview
- Financial summary
- Data quality indicators

### Exercise 2: Custom Dashboard Report

Build a customizable dashboard report with:

- Parameter-driven filtering
- Multiple output formats (screen, CSV, JSON)
- Visual progress indicators
- Trend analysis components

### Exercise 3: Automated Report Template

Design an automated report template featuring:

- Dynamic headers and footers
- Hierarchical data presentation
- Quality validation checks
- Export-ready formatting

## Key Takeaways

- Structure reports with clear headers and sections
- Include metadata and generation information
- Use visual indicators for better readability
- Implement data quality checks
- Design for multiple output formats
- Consider automation and parameterization
- Plan for drill-down and interactive features

## Next Steps

In the next lesson, we'll explore advanced result customization techniques and integration with external reporting tools.