# Lesson 3: Pie Charts and Percentage Calculations

## 🎯 Learning Objectives
Master the creation of pie chart data using advanced aggregation techniques, percentage calculations, and professional formatting for visual dashboards and reports.

## 🥧 Introduction to Pie Chart Data
Pie charts excel at showing proportional relationships and part-to-whole comparisons. This lesson teaches you to create compelling pie chart datasets using TechCorp's business data.

## Part 1: Basic Pie Chart Data Creation 📊

### 1.1 Simple Category Distributions
Create basic pie chart data showing department employee distribution:

```sql
-- Employee distribution by department (Basic Pie Chart)
SELECT 
    d.DepartmentName AS Category,
    COUNT(e.EmployeeID) AS Value,
    COUNT(e.EmployeeID) * 100.0 / SUM(COUNT(e.EmployeeID)) OVER() AS Percentage
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID  
GROUP BY d.DepartmentName
ORDER BY Value DESC;
```

### 1.2 Budget Allocation Pie Chart
Visualize how company budget is allocated across departments:

```sql
-- Department budget distribution for pie chart
WITH BudgetData AS (
    SELECT 
        d.DepartmentName,
        d.Budget,
        SUM(d.Budget) OVER() AS TotalBudget
    FROM Departments d
    WHERE d.Budget > 0
)
SELECT 
    DepartmentName AS Label,
    Budget AS Value,
    ROUND(Budget * 100.0 / TotalBudget, 2) AS Percentage,
    FORMAT(Budget * 100.0 / TotalBudget, 'N1') + '%' AS PercentageFormatted,
    FORMAT(Budget, 'C0') AS ValueFormatted,
    -- Chart-ready label with percentage
    DepartmentName + ' (' + FORMAT(Budget * 100.0 / TotalBudget, 'N1') + '%)' AS ChartLabel
FROM BudgetData
ORDER BY Percentage DESC;
```

## Part 2: Advanced Pie Chart Calculations 📈

### 2.1 Multi-Level Pie Charts (Donut Charts)
Create nested pie chart data showing department and sub-category breakdowns:

```sql
-- Employee distribution with job level breakdown
WITH EmployeeLevels AS (
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%' OR e.JobTitle LIKE '%VP%' THEN 'Management'
            WHEN e.JobTitle LIKE '%Senior%' OR e.JobTitle LIKE '%Lead%' THEN 'Senior Level'  
            WHEN e.JobTitle LIKE '%Junior%' OR e.JobTitle LIKE '%Intern%' THEN 'Junior Level'
            ELSE 'Mid Level'
        END AS JobLevel,
        COUNT(e.EmployeeID) AS EmployeeCount
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE e.EmployeeID IS NOT NULL
    GROUP BY d.DepartmentName, 
        CASE 
            WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%' OR e.JobTitle LIKE '%VP%' THEN 'Management'
            WHEN e.JobTitle LIKE '%Senior%' OR e.JobTitle LIKE '%Lead%' THEN 'Senior Level'
            WHEN e.JobTitle LIKE '%Junior%' OR e.JobTitle LIKE '%Intern%' THEN 'Junior Level'
            ELSE 'Mid Level'
        END
),
TotalCounts AS (
    SELECT 
        DepartmentName,
        JobLevel,
        EmployeeCount,
        SUM(EmployeeCount) OVER() AS GrandTotal,
        SUM(EmployeeCount) OVER(PARTITION BY DepartmentName) AS DepartmentTotal
    FROM EmployeeLevels
)
SELECT 
    DepartmentName AS OuterCategory,
    JobLevel AS InnerCategory,  
    EmployeeCount AS Value,
    ROUND(EmployeeCount * 100.0 / GrandTotal, 2) AS OverallPercentage,
    ROUND(EmployeeCount * 100.0 / DepartmentTotal, 2) AS DepartmentPercentage,
    DepartmentName + ' - ' + JobLevel AS CombinedLabel,
    -- Color coding by job level
    CASE JobLevel
        WHEN 'Management' THEN '#1f77b4'      -- Blue
        WHEN 'Senior Level' THEN '#ff7f0e'    -- Orange  
        WHEN 'Mid Level' THEN '#2ca02c'       -- Green
        WHEN 'Junior Level' THEN '#d62728'    -- Red
    END AS ColorCode
FROM TotalCounts
ORDER BY DepartmentName, EmployeeCount DESC;
```

### 2.2 Performance-Based Pie Charts
Create pie charts based on performance metrics:

```sql
-- Project status distribution with budget weighting
WITH ProjectMetrics AS (
    SELECT 
        p.Status,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(p.Budget) AS TotalBudget,
        AVG(p.Budget) AS AvgBudget
    FROM Projects p
    GROUP BY p.Status
),
Totals AS (
    SELECT 
        Status,
        ProjectCount,
        TotalBudget,
        AvgBudget,
        SUM(TotalBudget) OVER() AS GrandTotalBudget,
        SUM(ProjectCount) OVER() AS GrandTotalProjects
    FROM ProjectMetrics
)
SELECT 
    Status AS Category,
    ProjectCount AS CountValue,
    TotalBudget AS BudgetValue,
    -- Percentage by count
    ROUND(ProjectCount * 100.0 / GrandTotalProjects, 2) AS CountPercentage,
    -- Percentage by budget (more meaningful for business)
    ROUND(TotalBudget * 100.0 / GrandTotalBudget, 2) AS BudgetPercentage,
    -- Formatted labels
    Status + ' (' + CAST(ProjectCount AS VARCHAR) + ' projects)' AS CountLabel,
    Status + ' (' + FORMAT(TotalBudget, 'C0') + ')' AS BudgetLabel,
    -- Visual indicators
    CASE Status
        WHEN 'Active' THEN '🟢'
        WHEN 'On Hold' THEN '🟡'  
        WHEN 'Completed' THEN '🔵'
        WHEN 'Cancelled' THEN '🔴'
        ELSE '⚪'
    END + ' ' + Status AS StatusWithIcon
FROM Totals
ORDER BY BudgetPercentage DESC;
```

## Part 3: Interactive Pie Chart Data 🎮

### 3.1 Drill-Down Pie Chart Data
Create hierarchical data for interactive drill-down pie charts:

```sql
-- Drill-down from departments to job titles
WITH HierarchicalData AS (
    SELECT 
        d.DepartmentName,
        e.JobTitle,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary,
        SUM(e.BaseSalary) AS TotalSalary
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName, e.JobTitle
)
SELECT 
    -- Level 1: Department level (for initial pie chart)
    DepartmentName AS Level1_Category,
    SUM(EmployeeCount) AS Level1_Value,
    SUM(TotalSalary) AS Level1_Budget,
    
    -- Level 2: Job title level (for drill-down)  
    JobTitle AS Level2_Category,
    EmployeeCount AS Level2_Value,
    TotalSalary AS Level2_Budget,
    
    -- Formatted display
    DepartmentName + ' → ' + JobTitle AS DrillPath,
    FORMAT(AvgSalary, 'C0') AS AvgSalaryFormatted,
    
    -- Percentage within department
    ROUND(EmployeeCount * 100.0 / SUM(EmployeeCount) OVER(PARTITION BY DepartmentName), 2) AS DeptPercentage
FROM HierarchicalData
GROUP BY GROUPING SETS (
    (DepartmentName),  -- For department-level pie
    (DepartmentName, JobTitle, EmployeeCount, TotalSalary, AvgSalary)  -- For drill-down
)
ORDER BY DepartmentName, EmployeeCount DESC;
```

### 3.2 Time-Filtered Pie Charts
Create pie charts that change based on time periods:

```sql
-- Employee hiring trends by quarter (for animated pie charts)
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = GETDATE();

WITH QuarterlyHires AS (
    SELECT 
        YEAR(e.HireDate) AS HireYear,
        DATEPART(QUARTER, e.HireDate) AS HireQuarter,
        CONCAT('Q', DATEPART(QUARTER, e.HireDate), ' ', YEAR(e.HireDate)) AS QuarterLabel,
        d.DepartmentName,
        COUNT(e.EmployeeID) AS NewHires
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.HireDate BETWEEN @StartDate AND @EndDate
    GROUP BY YEAR(e.HireDate), DATEPART(QUARTER, e.HireDate), d.DepartmentName
),
QuarterTotals AS (
    SELECT 
        HireYear,
        HireQuarter, 
        QuarterLabel,
        DepartmentName,
        NewHires,
        SUM(NewHires) OVER(PARTITION BY HireYear, HireQuarter) AS QuarterTotal
    FROM QuarterlyHires
)
SELECT 
    QuarterLabel AS TimePeriod,
    DepartmentName AS Category,
    NewHires AS Value,
    ROUND(NewHires * 100.0 / QuarterTotal, 2) AS Percentage,
    DepartmentName + ' (' + CAST(NewHires) AS VARCHAR) + ' hires)' AS Label,
    HireYear,
    HireQuarter,
    -- For animation sequencing
    ROW_NUMBER() OVER(ORDER BY HireYear, HireQuarter) AS SequenceNumber
FROM QuarterTotals
WHERE QuarterTotal > 0  -- Only quarters with hires
ORDER BY HireYear, HireQuarter, NewHires DESC;
```

## Part 4: Specialized Pie Chart Variants 🎨

### 4.1 Exploded Pie Chart Data
Highlight important segments by marking them for explosion:

```sql
-- Department salary distribution with explosion flags
WITH SalaryDistribution AS (
    SELECT 
        d.DepartmentName,
        SUM(e.BaseSalary) AS TotalSalary,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName
),
WithPercentages AS (
    SELECT 
        DepartmentName,
        TotalSalary,
        EmployeeCount,
        AvgSalary,
        TotalSalary * 100.0 / SUM(TotalSalary) OVER() AS Percentage
    FROM SalaryDistribution
)
SELECT 
    DepartmentName AS Category,
    TotalSalary AS Value,
    Percentage,
    FORMAT(Percentage, 'N1') + '%' AS PercentageFormatted,
    -- Explode segments above 25% or highest paying departments
    CASE 
        WHEN Percentage > 25 OR AvgSalary > 90000 THEN 'true'
        ELSE 'false'
    END AS ExplodeSegment,
    -- Enhanced labels for exploded segments
    CASE 
        WHEN Percentage > 25 OR AvgSalary > 90000 THEN 
            DepartmentName + CHAR(10) + FORMAT(TotalSalary, 'C0') + CHAR(10) + '(' + FORMAT(Percentage, 'N1') + '%)'
        ELSE DepartmentName
    END AS EnhancedLabel,
    -- Color intensity based on salary level
    CASE 
        WHEN AvgSalary >= 100000 THEN '#8B0000'  -- Dark red
        WHEN AvgSalary >= 80000 THEN '#FF4500'   -- Orange red  
        WHEN AvgSalary >= 60000 THEN '#FFD700'   -- Gold
        ELSE '#90EE90'                           -- Light green
    END AS ColorCode
FROM WithPercentages
ORDER BY Percentage DESC;
```

### 4.2 3D Pie Chart Depth Data
Add depth and visual hierarchy to pie charts:

```sql
-- Project complexity analysis for 3D visualization
WITH ProjectComplexity AS (
    SELECT 
        CASE 
            WHEN p.Budget >= 1000000 AND DATEDIFF(MONTH, p.StartDate, p.EndDate) >= 12 THEN 'Large & Complex'
            WHEN p.Budget >= 500000 OR DATEDIFF(MONTH, p.StartDate, p.EndDate) >= 6 THEN 'Medium Complexity'  
            ELSE 'Small & Simple'
        END AS ComplexityLevel,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(p.Budget) AS TotalBudget,
        AVG(DATEDIFF(DAY, p.StartDate, p.EndDate)) AS AvgDuration
    FROM Projects p
    WHERE p.Status IN ('Active', 'Completed')
    GROUP BY 
        CASE 
            WHEN p.Budget >= 1000000 AND DATEDIFF(MONTH, p.StartDate, p.EndDate) >= 12 THEN 'Large & Complex'
            WHEN p.Budget >= 500000 OR DATEDIFF(MONTH, p.StartDate, p.EndDate) >= 6 THEN 'Medium Complexity'
            ELSE 'Small & Simple'
        END
)
SELECT 
    ComplexityLevel AS Category,
    ProjectCount AS Value,
    TotalBudget AS BudgetValue,
    ProjectCount * 100.0 / SUM(ProjectCount) OVER() AS Percentage,
    -- 3D depth based on complexity
    CASE ComplexityLevel
        WHEN 'Large & Complex' THEN 30     -- Deepest
        WHEN 'Medium Complexity' THEN 20   -- Medium depth
        ELSE 10                            -- Shallowest
    END AS Depth3D,
    -- Shadow intensity
    CASE ComplexityLevel 
        WHEN 'Large & Complex' THEN 0.8
        WHEN 'Medium Complexity' THEN 0.5
        ELSE 0.3
    END AS ShadowIntensity,
    -- Display metrics
    ComplexityLevel + CHAR(10) + 
    CAST(ProjectCount AS VARCHAR) + ' projects' + CHAR(10) +
    FORMAT(TotalBudget, 'C0') AS MultiLineLabel
FROM ProjectComplexity
ORDER BY 
    CASE ComplexityLevel
        WHEN 'Large & Complex' THEN 1
        WHEN 'Medium Complexity' THEN 2  
        ELSE 3
    END;
```

## Part 5: Advanced Formatting for Chart Libraries 📊

### 5.1 Chart.js Ready Data
Format data specifically for Chart.js library:

```sql
-- Chart.js pie chart data format
WITH ChartData AS (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        SUM(e.BaseSalary) AS TotalSalary
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName
)
SELECT 
    -- Chart.js labels array format
    STRING_AGG('"' + DepartmentName + '"', ', ') AS Labels,
    -- Chart.js data array format  
    STRING_AGG(CAST(EmployeeCount AS VARCHAR), ', ') AS DataValues,
    -- Chart.js backgroundColor array
    STRING_AGG(
        CASE DepartmentName
            WHEN 'Engineering' THEN '"rgba(255, 99, 132, 0.8)"'
            WHEN 'Sales' THEN '"rgba(54, 162, 235, 0.8)"'
            WHEN 'Marketing' THEN '"rgba(255, 205, 86, 0.8)"'
            WHEN 'HR' THEN '"rgba(75, 192, 192, 0.8)"'
            ELSE '"rgba(153, 102, 255, 0.8)"'
        END, ', '
    ) AS BackgroundColors,
    -- Chart.js borderColor array
    STRING_AGG(
        CASE DepartmentName
            WHEN 'Engineering' THEN '"rgba(255, 99, 132, 1)"'
            WHEN 'Sales' THEN '"rgba(54, 162, 235, 1)"' 
            WHEN 'Marketing' THEN '"rgba(255, 205, 86, 1)"'
            WHEN 'HR' THEN '"rgba(75, 192, 192, 1)"'
            ELSE '"rgba(153, 102, 255, 1)"'
        END, ', '
    ) AS BorderColors
FROM ChartData
WHERE EmployeeCount > 0;
```

### 5.2 Power BI Ready Format
Structure data for Microsoft Power BI consumption:

```sql
-- Power BI optimized pie chart dataset
SELECT 
    d.DepartmentName AS Department,
    d.Location AS Office,
    COUNT(e.EmployeeID) AS EmployeeCount,
    SUM(e.BaseSalary) AS TotalSalary,
    AVG(e.BaseSalary) AS AvgSalary,
    -- Power BI measure-friendly columns
    CAST(COUNT(e.EmployeeID) AS FLOAT) AS EmployeeCountMeasure,
    CAST(SUM(e.BaseSalary) AS FLOAT) AS TotalSalaryMeasure,
    -- Category grouping for drill-through
    CASE 
        WHEN COUNT(e.EmployeeID) >= 10 THEN 'Large Department'
        WHEN COUNT(e.EmployeeID) >= 5 THEN 'Medium Department'
        ELSE 'Small Department'  
    END AS DepartmentSize,
    -- Color theme column
    CASE d.DepartmentName
        WHEN 'Engineering' THEN 'Technology'
        WHEN 'Sales' THEN 'Revenue'
        WHEN 'Marketing' THEN 'Growth'
        WHEN 'HR' THEN 'People'
        ELSE 'Operations'
    END AS ColorTheme,
    -- Tooltip information
    d.DepartmentName + ': ' + CAST(COUNT(e.EmployeeID) AS VARCHAR) + ' employees, ' +
    'Avg Salary: ' + FORMAT(AVG(e.BaseSalary), 'C0') AS TooltipText
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.Location
HAVING COUNT(e.EmployeeID) > 0  -- Only departments with employees
ORDER BY COUNT(e.EmployeeID) DESC;
```

## 🎯 Practice Exercises

### Exercise 1: Customer Demographics Pie Chart
Create pie chart data showing:
- Customer distribution by geographic region
- Revenue contribution percentages  
- Interactive drill-down from region to city
- Color coding by revenue performance

### Exercise 2: Product Performance Analysis
Build pie chart datasets for:
- Product category sales distribution
- Profit margin analysis by category
- Seasonal performance variations
- Top/bottom performer highlighting

### Exercise 3: Employee Satisfaction Dashboard
Generate pie chart data showing:
- Satisfaction scores by department
- Tenure-based satisfaction analysis
- Performance vs satisfaction correlation
- Action item prioritization

## 📋 Key Takeaways

✅ **Percentage Precision**: Always use proper decimal handling for accurate percentages  
✅ **Label Formatting**: Create meaningful, readable labels with context  
✅ **Color Strategy**: Implement consistent, accessible color schemes  
✅ **Interactivity**: Structure data to support drill-down and filtering  
✅ **Tool Compatibility**: Format output for specific charting libraries and tools  

## 🚀 Next Steps

Mastered pie charts? **Lesson 4** covers building comprehensive professional reports that combine multiple chart types, interactive dashboards, and executive-level data presentations.

---
*Building on: Module 9 (Grouping & Aggregation), Module 8 (Built-in Functions), Module 5 (Filtering), Module 3 (SELECT Mastery)*