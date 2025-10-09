# Lesson 1: Data Formatting Foundations for Visualization

## 🎯 Learning Objectives
Master the fundamental techniques for formatting SQL Server query results to create visualization-ready data that can be easily consumed by charting tools and reporting systems.

## 📊 Introduction
Before creating stunning visualizations, you need properly formatted data. This lesson teaches you how to transform raw database results into chart-ready formats using advanced T-SQL techniques.

## Part 1: Professional Data Formatting 📈

### 1.1 Currency and Number Formatting
Transform raw numbers into presentation-ready formats:

```sql
-- Format currency values for charts and reports
SELECT 
    d.DepartmentName AS Department,
    FORMAT(d.Budget, 'C', 'en-US') AS FormattedBudget,
    FORMAT(d.Budget, 'N0') AS BudgetNoDecimals,
    CONCAT('$', FORMAT(d.Budget/1000, 'N1'), 'K') AS BudgetInThousands
FROM Departments d
ORDER BY d.Budget DESC;
```

### 1.2 Date Formatting for Time-Series Charts
Create consistent date formats for timeline visualizations:

```sql
-- Format dates for different chart requirements
SELECT 
    e.HireDate,
    FORMAT(e.HireDate, 'yyyy-MM') AS MonthYear,        -- For monthly charts
    FORMAT(e.HireDate, 'yyyy') AS Year,                -- For yearly charts  
    FORMAT(e.HireDate, 'MMMM yyyy') AS FullMonthYear, -- For display labels
    DATENAME(QUARTER, e.HireDate) AS Quarter,          -- For quarterly charts
    CONCAT('Q', DATEPART(QUARTER, e.HireDate), ' ', YEAR(e.HireDate)) AS QuarterLabel
FROM Employees e
WHERE e.HireDate >= '2020-01-01'
ORDER BY e.HireDate;
```

### 1.3 Percentage Calculations for Pie Charts
Calculate percentages with proper formatting:

```sql
-- Calculate department budget percentages for pie charts
WITH DepartmentTotals AS (
    SELECT 
        d.DepartmentName,
        d.Budget,
        SUM(d.Budget) OVER() AS TotalBudget
    FROM Departments d
)
SELECT 
    DepartmentName AS Label,
    Budget AS Value,
    ROUND((Budget * 100.0 / TotalBudget), 2) AS Percentage,
    FORMAT((Budget * 100.0 / TotalBudget), 'N2') + '%' AS PercentageFormatted,
    CONCAT(DepartmentName, ' (', FORMAT((Budget * 100.0 / TotalBudget), 'N1'), '%)') AS ChartLabel
FROM DepartmentTotals
ORDER BY Percentage DESC;
```

## Part 2: Color Coding and Categorization 🎨

### 2.1 Performance Color Indicators
Add color coding logic for dashboard visualizations:

```sql
-- Employee performance indicators with color codes
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN 'High'
        WHEN e.BaseSalary >= 70000 THEN 'Medium' 
        ELSE 'Low'
    END AS SalaryCategory,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN '#28a745'  -- Green
        WHEN e.BaseSalary >= 70000 THEN '#ffc107'   -- Yellow
        ELSE '#dc3545'                              -- Red
    END AS ColorCode,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN 1
        WHEN e.BaseSalary >= 70000 THEN 2
        ELSE 3
    END AS SortOrder
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY SortOrder, e.BaseSalary DESC;
```

### 2.2 Status Indicators for Project Charts
Create visual status indicators:

```sql
-- Project status with visual indicators
SELECT 
    p.ProjectName,
    p.Status,
    p.Budget,
    DATEDIFF(DAY, GETDATE(), p.EndDate) AS DaysRemaining,
    CASE p.Status
        WHEN 'Active' THEN '🟢 Active'
        WHEN 'On Hold' THEN '🟡 On Hold' 
        WHEN 'Completed' THEN '🔵 Completed'
        WHEN 'Cancelled' THEN '🔴 Cancelled'
        ELSE '⚪ Unknown'
    END AS StatusIcon,
    CASE 
        WHEN p.Status = 'Active' AND DATEDIFF(DAY, GETDATE(), p.EndDate) < 30 THEN 'Urgent'
        WHEN p.Status = 'Active' THEN 'Normal'
        ELSE p.Status
    END AS PriorityLevel
FROM Projects p
ORDER BY 
    CASE p.Status 
        WHEN 'Active' THEN 1 
        WHEN 'On Hold' THEN 2 
        ELSE 3 
    END;
```

## Part 3: Chart Data Structure Preparation 📋

### 3.1 Pivot Data for Stacked Charts
Prepare data for multi-series charts:

```sql
-- Employee count by department and job level (for stacked bar charts)
SELECT 
    d.DepartmentName AS Category,
    SUM(CASE WHEN e.JobTitle LIKE '%Manager%' THEN 1 ELSE 0 END) AS Managers,
    SUM(CASE WHEN e.JobTitle LIKE '%Senior%' THEN 1 ELSE 0 END) AS SeniorLevel,
    SUM(CASE WHEN e.JobTitle NOT LIKE '%Manager%' AND e.JobTitle NOT LIKE '%Senior%' THEN 1 ELSE 0 END) AS JuniorLevel,
    COUNT(e.EmployeeID) AS Total
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.DepartmentID
ORDER BY Total DESC;
```

### 3.2 Time Series Data for Line Charts
Structure temporal data for trend analysis:

```sql
-- Monthly hiring trends (for line charts)
WITH MonthlyHires AS (
    SELECT 
        YEAR(e.HireDate) AS HireYear,
        MONTH(e.HireDate) AS HireMonth,
        FORMAT(e.HireDate, 'yyyy-MM') AS YearMonth,
        FORMAT(e.HireDate, 'MMM yyyy') AS MonthLabel,
        COUNT(e.EmployeeID) AS NewHires,
        AVG(e.BaseSalary) AS AvgStartingSalary
    FROM Employees e
    WHERE e.HireDate >= DATEADD(YEAR, -2, GETDATE())
    GROUP BY YEAR(e.HireDate), MONTH(e.HireDate), FORMAT(e.HireDate, 'yyyy-MM'), FORMAT(e.HireDate, 'MMM yyyy')
)
SELECT 
    YearMonth AS XAxis,
    MonthLabel AS Label,
    NewHires AS Value,
    FORMAT(AvgStartingSalary, 'C0') AS AvgSalaryFormatted,
    CASE 
        WHEN NewHires >= 5 THEN 'High Activity'
        WHEN NewHires >= 2 THEN 'Moderate Activity'
        ELSE 'Low Activity'
    END AS ActivityLevel
FROM MonthlyHires
ORDER BY YearMonth;
```

## Part 4: Advanced Formatting Techniques 🔧

### 4.1 KPI Formatting for Dashboards
Create key performance indicators with visual formatting:

```sql
-- Department KPIs formatted for dashboard display
WITH DepartmentMetrics AS (
    SELECT 
        d.DepartmentName,
        d.Budget,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary,
        SUM(e.BaseSalary) AS TotalPayroll,
        d.Budget - SUM(e.BaseSalary) AS BudgetVariance
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName, d.Budget
)
SELECT 
    DepartmentName AS Department,
    FORMAT(Budget, 'C0') AS Budget,
    CAST(EmployeeCount AS VARCHAR) + ' employees' AS Headcount,
    FORMAT(AvgSalary, 'C0') AS AvgSalary,
    FORMAT(TotalPayroll, 'C0') AS TotalPayroll,
    FORMAT(BudgetVariance, 'C0') AS Remaining,
    CASE 
        WHEN BudgetVariance > 0 THEN '✅ Under Budget'
        WHEN BudgetVariance < 0 THEN '⚠️ Over Budget'
        ELSE '➖ At Budget'
    END AS BudgetStatus,
    ROUND((TotalPayroll * 100.0 / Budget), 1) AS BudgetUtilization
FROM DepartmentMetrics
ORDER BY BudgetUtilization DESC;
```

### 4.2 Ranking and Top N Formatting
Format data for ranking visualizations:

```sql
-- Top performing employees with ranking
SELECT 
    ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS Rank,
    '#' + CAST(ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS VARCHAR) AS RankFormatted,
    e.FirstName + ' ' + e.LastName AS Employee,
    d.DepartmentName AS Department,
    e.JobTitle AS Position,
    FORMAT(e.BaseSalary, 'C0') AS Salary,
    REPLICATE('⭐', 
        CASE 
            WHEN e.BaseSalary >= 120000 THEN 5
            WHEN e.BaseSalary >= 100000 THEN 4  
            WHEN e.BaseSalary >= 80000 THEN 3
            WHEN e.BaseSalary >= 60000 THEN 2
            ELSE 1
        END
    ) AS PerformanceStars
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.BaseSalary DESC;
```

## Part 5: Export-Ready Formatting 📤

### 5.1 CSV-Ready Output
Format data for easy CSV export:

```sql
-- Clean CSV export format (no special characters that break CSV)
SELECT 
    REPLACE(REPLACE(d.DepartmentName, ',', '-'), '"', '''') AS Department,
    CAST(d.Budget AS DECIMAL(15,2)) AS Budget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    CAST(AVG(e.BaseSalary) AS DECIMAL(10,2)) AS AvgSalary,
    CONVERT(VARCHAR, GETDATE(), 23) AS ReportDate  -- ISO date format
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.Budget
ORDER BY d.DepartmentName;
```

### 5.2 JSON-Style Output for Web Charts
Structure data for web-based charting libraries:

```sql
-- JSON-friendly format for web charts
SELECT 
    '{"name":"' + d.DepartmentName + 
    '","value":' + CAST(COUNT(e.EmployeeID) AS VARCHAR) + 
    ',"color":"' + 
    CASE d.DepartmentName
        WHEN 'Engineering' THEN '#FF6384'
        WHEN 'Sales' THEN '#36A2EB' 
        WHEN 'Marketing' THEN '#FFCE56'
        WHEN 'HR' THEN '#4BC0C0'
        ELSE '#9966FF'
    END + '"}' AS ChartDataJSON
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(e.EmployeeID) DESC;
```

## 🎯 Practice Exercises

### Exercise 1: Sales Performance Formatting
Create a formatted query showing monthly sales performance with:
- Percentage growth calculations
- Color coding for performance levels  
- Formatted currency values
- Trend indicators (↗️ ↘️ ➡️)

### Exercise 2: Employee Demographics Chart Data
Format employee data for demographic pie charts showing:
- Age group distributions
- Department breakdowns
- Tenure categories
- Salary band percentages

### Exercise 3: Project Timeline Visualization
Prepare project data for Gantt chart visualization:
- Date range calculations
- Progress percentages
- Status color coding
- Resource allocation formatting

## 📋 Key Takeaways

✅ **Professional Formatting**: Use FORMAT(), CONCAT(), and CASE for presentation-ready data  
✅ **Color Coding**: Implement consistent visual indicators for different data categories  
✅ **Chart Structure**: Organize data in formats that visualization tools can easily consume  
✅ **Export Readiness**: Clean data for CSV, JSON, and other export formats  
✅ **KPI Presentation**: Create dashboard-ready metrics with visual enhancements  

## 🚀 Next Steps

Ready to move on? **Lesson 2** will teach you how to create aggregated data specifically for different chart types, including advanced pie chart calculations and multi-dimensional data summaries.

---
*Building on: Modules 1-3 (SQL Foundations), Module 6 (Data Types), Module 8 (Built-in Functions)*