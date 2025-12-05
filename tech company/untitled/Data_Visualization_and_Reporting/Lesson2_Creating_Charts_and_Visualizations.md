
# Lesson 2: Making Simple Charts from Your Data (Beginner Friendly)

## What You’ll Learn (In Plain English)

- How to turn boring tables into colorful charts (like pie charts!)
- Why pictures (charts) help people understand numbers faster
- The easiest way to make a pie chart from your data
- What kinds of charts you can make with SQL (and when to use them)

## 2.1 Why Use Charts? (Let’s Make Data Fun!)

Imagine you have a list of how many people are in each department. If you just look at numbers, it’s hard to see which is biggest. But if you make a pie chart, it’s like slicing a pizza—everyone can see which slice (department) is the biggest!

### Types of Charts (Like Different Slices of Pizza)
- **Pie Chart**: Shows how much each part (like a department) takes up of the whole (the company)
- **Bar Chart**: Good for comparing things side by side
- **Line Chart**: Shows how things change over time

## 2.2 How to Make a Pie Chart (Step by Step)

Pie charts are great for showing “who gets the biggest piece.” For example, which department has the most employees? Let’s see how to get that info in a way that’s easy to turn into a chart.

### 🎯 BEGINNER Example 1: Count People by Department (Perfect for Pie Charts!)

```sql
-- Step 1: Let's count how many people work in each department
SELECT 
    d.DepartmentName AS Category,           -- The department name (like "Sales")
    COUNT(*) AS EmployeeCount,              -- How many people (like 15)
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees), 'N1') + '%' AS Percentage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName, d.DepartmentID
ORDER BY COUNT(*) DESC;
```

**What this gives you:**
- Category: "Sales", EmployeeCount: 15, Percentage: "30.0%"
- Category: "IT", EmployeeCount: 12, Percentage: "24.0%"
- Perfect for making a pie chart showing which departments are biggest!

### 🎯 BEGINNER Example 2: Money by Project Status (Great for Charts!)

```sql
-- Step 2: Let's see how money is divided between project types
SELECT 
    ISNULL(p.Status, 'Unknown') AS ProjectStatus,     -- Project status (like "Completed")
    SUM(p.Budget) AS TotalBudget,                      -- Total money (like $500,000)
    COUNT(*) AS ProjectCount,                          -- Number of projects (like 8)
    FORMAT(SUM(p.Budget) * 100.0 / (SELECT SUM(Budget) FROM Projects), 'N1') + '%' AS BudgetPercentage
FROM Projects p
GROUP BY p.Status
ORDER BY SUM(p.Budget) DESC;
```

**What this gives you:**
- ProjectStatus: "Completed", TotalBudget: 500000, ProjectCount: 8, BudgetPercentage: "45.2%"
- Perfect for showing where most of the money went!

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

---

## 🟢 BEGINNER SECTION: Making Bar Charts with Text (Like ASCII Art!)

### What are Text Bar Charts? (Like Drawing with Letters and Symbols)

Sometimes you can't make fancy charts, but you can make simple ones using text characters. It's like drawing bar charts with blocks (█) instead of using fancy software!

### 🎯 BEGINNER Example: Simple Department Budget Bars

```sql
-- Let's make a text-based bar chart showing department budgets
WITH DeptBudgets AS (
    -- Step 1: Add up all the budget money for each department
    SELECT 
        d.DepartmentName,
        SUM(ISNULL(p.Budget, 0)) AS TotalBudget    -- Total budget per department
    FROM Departments d
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    GROUP BY d.DepartmentName
),
MaxBudget AS (
    -- Step 2: Find the biggest budget (so we know how long to make the longest bar)
    SELECT MAX(TotalBudget) AS MaxVal FROM DeptBudgets
)
SELECT 
    db.DepartmentName,
    FORMAT(db.TotalBudget, 'C0') AS Budget,        -- Pretty money: $150,000
    REPLICATE('█', CAST(db.TotalBudget * 20.0 / mb.MaxVal AS INT)) AS BudgetBar,  -- Text bar: ████████
    FORMAT(db.TotalBudget * 100.0 / (SELECT SUM(TotalBudget) FROM DeptBudgets), 'N1') + '%' AS Percentage
FROM DeptBudgets db
CROSS JOIN MaxBudget mb
ORDER BY db.TotalBudget DESC;
```

**What you'll see:**
- Sales: $200,000 ████████████████████ 40.0%
- IT: $150,000 ███████████████ 30.0%
- HR: $100,000 ██████████ 20.0%

**How the bars work:** More money = more blocks (█). It's like a visual way to see which department got the most budget!

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