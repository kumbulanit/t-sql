# Lesson 2: Creating Charts and Visual Data Representations

## Learning Objectives

- Learn to create pie charts from SQL Server data
- Master chart customization and formatting options
- Understand different visualization types available in SQL Server
- Create compelling visual stories with data

## 2.1 Introduction to SQL Server Data Visualization

SQL Server Management Studio provides basic charting capabilities, while SQL Server Reporting Services (SSRS) offers advanced visualization features. This lesson covers both approaches.

### Available Chart Types

- **Pie Charts**: Show proportional data
- **Bar/Column Charts**: Compare categories
- **Line Charts**: Display trends over time
- **Area Charts**: Show cumulative values
- **Scatter Plots**: Reveal correlations

## 2.2 Creating Basic Pie Charts

### Data Preparation for Pie Charts

Pie charts work best with categorical data that represents parts of a whole.

```sql
-- Employee distribution by department (Pie Chart Data)
SELECT 
    d.DepartmentName AS Category,
    COUNT(*) AS EmployeeCount,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees), 'N1') + '%' AS Percentage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName, d.DepartmentID
ORDER BY COUNT(*) DESC;

-- Project budget allocation by status
SELECT 
    ISNULL(p.Status, 'Unknown') AS ProjectStatus,
    SUM(p.Budget) AS TotalBudget,
    COUNT(*) AS ProjectCount,
    FORMAT(SUM(p.Budget) * 100.0 / (SELECT SUM(Budget) FROM Projects), 'N1') + '%' AS BudgetPercentage
FROM Projects p
GROUP BY p.Status
ORDER BY SUM(p.Budget) DESC;
```

### Advanced Pie Chart Queries

```sql
-- Salary distribution by ranges
WITH SalaryRanges AS (
    SELECT 
        CASE 
            WHEN BaseSalary < 50000 THEN 'Entry Level ($0-$49K)'
            WHEN BaseSalary < 75000 THEN 'Mid Level ($50K-$74K)'
            WHEN BaseSalary < 100000 THEN 'Senior Level ($75K-$99K)'
            WHEN BaseSalary < 150000 THEN 'Lead Level ($100K-$149K)'
            ELSE 'Executive ($150K+)'
        END AS SalaryRange,
        BaseSalary,
        EmployeeID
    FROM Employees
    WHERE BaseSalary IS NOT NULL
)
SELECT 
    SalaryRange,
    COUNT(*) AS EmployeeCount,
    FORMAT(AVG(BaseSalary), 'C0') AS AverageSalary,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM SalaryRanges), 'N1') + '%' AS Percentage
FROM SalaryRanges
GROUP BY SalaryRange
ORDER BY MIN(CASE 
    WHEN SalaryRange LIKE 'Entry%' THEN 1
    WHEN SalaryRange LIKE 'Mid%' THEN 2
    WHEN SalaryRange LIKE 'Senior%' THEN 3
    WHEN SalaryRange LIKE 'Lead%' THEN 4
    ELSE 5
END);
```

## 2.3 Using SSMS Chart Features

### Creating Charts in Results Grid

1. **Run your query** with appropriate data for charting
2. **Right-click on the result set**
3. **Select "Save Results As..."** and choose Excel format
4. **Open in Excel** and create charts using Excel's chart wizard

### Alternative: Using Result Grid Visualizer

```sql
-- Skills distribution with visual indicators
SELECT 
    sc.CategoryName,
    COUNT(es.EmployeeID) AS EmployeeCount,
    REPLICATE('█', COUNT(es.EmployeeID) / 5) AS VisualBar,
    FORMAT(COUNT(es.EmployeeID) * 100.0 / (SELECT COUNT(DISTINCT EmployeeID) FROM EmployeeSkills), 'N1') + '%' AS Percentage
FROM SkillCategories sc
LEFT JOIN Skills s ON sc.SkillCategoryID = s.SkillCategoryID
LEFT JOIN EmployeeSkills es ON s.SkillID = es.SkillID
GROUP BY sc.CategoryName, sc.SkillCategoryID
ORDER BY COUNT(es.EmployeeID) DESC;
```

## 2.4 Creating Text-Based Visual Charts

### ASCII Bar Charts

```sql
-- Department budget visualization
WITH DeptBudgets AS (
    SELECT 
        d.DepartmentName,
        SUM(ISNULL(p.Budget, 0)) AS TotalBudget
    FROM Departments d
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    GROUP BY d.DepartmentName
),
MaxBudget AS (
    SELECT MAX(TotalBudget) AS MaxVal FROM DeptBudgets
)
SELECT 
    db.DepartmentName,
    FORMAT(db.TotalBudget, 'C0') AS Budget,
    REPLICATE('█', CAST(db.TotalBudget * 50.0 / mb.MaxVal AS INT)) AS BudgetBar,
    FORMAT(db.TotalBudget * 100.0 / (SELECT SUM(TotalBudget) FROM DeptBudgets), 'N1') + '%' AS Percentage
FROM DeptBudgets db
CROSS JOIN MaxBudget mb
ORDER BY db.TotalBudget DESC;
```

### Progress Indicators

```sql
-- Project completion progress
SELECT 
    p.ProjectName,
    p.Status,
    FORMAT(p.ActualCost, 'C0') AS ActualCost,
    FORMAT(p.Budget, 'C0') AS Budget,
    CASE 
        WHEN p.Budget = 0 THEN 'N/A'
        ELSE FORMAT(p.ActualCost / p.Budget, 'P1')
    END AS BudgetUtilization,
    CASE 
        WHEN p.Budget = 0 THEN '│░░░░░░░░░░│'
        WHEN p.ActualCost / p.Budget <= 0.5 THEN '│██████░░░░│ Safe'
        WHEN p.ActualCost / p.Budget <= 0.8 THEN '│████████░░│ Warning'
        WHEN p.ActualCost / p.Budget <= 1.0 THEN '│██████████│ At Limit'
        ELSE '│██████████│ Over Budget!'
    END AS BudgetProgressBar
FROM Projects p
WHERE p.Budget > 0
ORDER BY p.ActualCost / p.Budget DESC;
```

## 2.5 Creating Data for External Chart Tools

### Export-Friendly Formats

```sql
-- Data formatted for Excel pivot charts
SELECT 
    'Department Distribution' AS ChartType,
    d.DepartmentName AS Category,
    COUNT(*) AS Value,
    'Employees' AS Metric
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName

UNION ALL

SELECT 
    'Skill Categories' AS ChartType,
    sc.CategoryName AS Category,
    COUNT(DISTINCT es.EmployeeID) AS Value,
    'Employees' AS Metric
FROM SkillCategories sc
LEFT JOIN Skills s ON sc.SkillCategoryID = s.SkillCategoryID  
LEFT JOIN EmployeeSkills es ON s.SkillID = es.SkillID
GROUP BY sc.CategoryName

ORDER BY ChartType, Value DESC;
```

### JSON Format for Web Charts

```sql
-- Generate JSON-like output for web charting libraries
SELECT 
    '{"name":"' + d.DepartmentName + '","value":' + CAST(COUNT(*) AS VARCHAR) + 
    ',"percentage":' + FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees), 'N2') + '}' AS JsonData
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(*) DESC;
```

## 2.6 Advanced Visualization Techniques

### Multi-Level Pie Chart Data

```sql
-- Hierarchical data for drill-down charts
WITH EmployeeHierarchy AS (
    SELECT 
        d.DepartmentName,
        e.JobTitle,
        COUNT(*) AS EmployeeCount,
        FORMAT(AVG(e.BaseSalary), 'C0') AS AverageSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentName, e.JobTitle
)
SELECT 
    DepartmentName + ' - ' + JobTitle AS DetailedCategory,
    EmployeeCount,
    AverageSalary,
    FORMAT(EmployeeCount * 100.0 / SUM(EmployeeCount) OVER(), 'N1') + '%' AS OverallPercentage,
    FORMAT(EmployeeCount * 100.0 / SUM(EmployeeCount) OVER(PARTITION BY DepartmentName), 'N1') + '%' AS DepartmentPercentage
FROM EmployeeHierarchy
ORDER BY DepartmentName, EmployeeCount DESC;
```

### Time Series Data for Line Charts

```sql
-- Monthly hiring trends
SELECT 
    YEAR(e.HireDate) AS HireYear,
    MONTH(e.HireDate) AS HireMonth,
    DATENAME(MONTH, e.HireDate) + ' ' + CAST(YEAR(e.HireDate) AS VARCHAR) AS MonthYear,
    COUNT(*) AS NewHires,
    SUM(COUNT(*)) OVER (ORDER BY YEAR(e.HireDate), MONTH(e.HireDate)) AS CumulativeHires
FROM Employees e
WHERE e.HireDate IS NOT NULL
GROUP BY YEAR(e.HireDate), MONTH(e.HireDate), DATENAME(MONTH, e.HireDate)
ORDER BY YEAR(e.HireDate), MONTH(e.HireDate);
```

## 2.7 Chart Color and Style Recommendations

### Color Coding Best Practices

```sql
-- Status-based color recommendations
SELECT 
    p.Status,
    COUNT(*) AS ProjectCount,
    SUM(p.Budget) AS TotalBudget,
    CASE p.Status
        WHEN 'Completed' THEN '#28A745'    -- Green
        WHEN 'In Progress' THEN '#007BFF'   -- Blue  
        WHEN 'On Hold' THEN '#FFC107'       -- Yellow
        WHEN 'Cancelled' THEN '#DC3545'     -- Red
        ELSE '#6C757D'                      -- Gray
    END AS RecommendedColor,
    CASE p.Status
        WHEN 'Completed' THEN 1
        WHEN 'In Progress' THEN 2
        WHEN 'On Hold' THEN 3
        WHEN 'Cancelled' THEN 4
        ELSE 5
    END AS DisplayOrder
FROM Projects p
GROUP BY p.Status
ORDER BY DisplayOrder;
```

## 2.8 Interactive Dashboard Queries

### Dashboard Summary Data

```sql
-- Executive dashboard data
SELECT 
    'Total Employees' AS Metric,
    CAST(COUNT(*) AS VARCHAR) AS Value,
    'people' AS Unit,
    '#007BFF' AS Color
FROM Employees

UNION ALL

SELECT 
    'Total Projects',
    CAST(COUNT(*) AS VARCHAR),
    'projects',
    '#28A745'
FROM Projects

UNION ALL

SELECT 
    'Active Projects',
    CAST(COUNT(*) AS VARCHAR),
    'active',
    '#FFC107'
FROM Projects
WHERE Status = 'In Progress'

UNION ALL

SELECT 
    'Total Budget',
    FORMAT(SUM(Budget), 'C0'),
    'USD',
    '#17A2B8'
FROM Projects;
```

## 2.9 Practical Exercises

### Exercise 1: Department Analysis Pie Chart

Create a comprehensive department analysis with:

- Employee count by department
- Budget allocation percentages  
- Average salary by department
- Visual progress bars

### Exercise 2: Project Status Dashboard

Build a project status visualization showing:

- Status distribution (pie chart data)
- Budget utilization by status
- Timeline analysis
- Risk indicators

### Exercise 3: Skills Matrix Visualization

Develop a skills analysis featuring:

- Skill category distribution
- Experience level breakdown
- Department vs skills cross-analysis
- Visual competency indicators

## Key Takeaways

- Prepare data specifically for chart types
- Use percentages and totals for pie charts
- Create visual indicators with ASCII characters
- Format data for external charting tools
- Consider color schemes for better readability
- Export data in chart-friendly formats

## Next Steps

In the next lesson, we'll explore report generation and advanced output formatting techniques using SQL Server Reporting Services concepts.