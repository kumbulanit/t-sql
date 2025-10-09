# Module 9 - Comprehensive Practice Exercises for Beginners

## 🎯 Practice Combining Everything You've Learned (🟢 COMPLETE BEGINNER LEVEL)

Welcome to your comprehensive practice session! This exercise combines concepts from Modules 3-8 with your new Module 9 skills. Each exercise is clearly labeled with the topics it combines, making it perfect for beginners who want to see how everything connects.

## 📖 What You'll Practice

You'll combine these skills in real business scenarios:

**From Previous Modules:**
- **Module 3**: Basic SELECT statements, aliases, CASE expressions
- **Module 4**: Joining tables to get related data
- **Module 5**: Filtering and sorting data  
- **Module 6**: Working with different data types (dates, text, numbers)
- **Module 7**: Understanding data modification concepts
- **Module 8**: Using built-in functions for calculations

**With Module 9 (Current):**
- **Aggregate Functions**: COUNT, SUM, AVG, MIN, MAX
- **GROUP BY**: Organizing data into categories
- **HAVING**: Filtering grouped results

## 🎓 Exercise Categories

Each exercise is clearly labeled with the modules it combines, so you know exactly what skills you're practicing!

---

## Section 1: Basic SELECT + Aggregates 📊
**Combining: Module 3 (SELECT) + Module 9 (Aggregates)**

### Exercise 1.1: Simple Employee Reports (🟢 SUPER EASY)
**Skills Combined: Basic SELECT + COUNT/SUM/AVG**

```sql
-- Connect to database
USE TechCorpDB;

-- Exercise 1.1a: Employee overview with aliases (Module 3 + 9)
SELECT 
    COUNT(*) AS 'Total Employees',
    AVG(e.BaseSalary) AS 'Average BaseSalary',
    MIN(e.BaseSalary) AS 'Lowest BaseSalary',
    MAX(e.BaseSalary) AS 'Highest BaseSalary'
FROM Employees e;

-- Exercise 1.1b: Project overview with formatted results (Module 3 + 9)
SELECT 
    COUNT(*) AS 'Total Projects',
    FORMAT(SUM(Budget), 'C0') AS 'Total Budget',
    FORMAT(AVG(Budget), 'C0') AS 'Average Project Size'
FROM Projects;
```

### Exercise 1.2: Using CASE with Aggregates (🟢 BASIC)
**Skills Combined: Module 3 (CASE expressions) + Module 9 (Aggregates)**

```sql
-- Exercise 1.2a: Categorize employees by BaseSalary level
SELECT 
    COUNT(*) AS 'Total Employees',
    COUNT(CASE WHEN BaseSalary < 40000 THEN 1 END) AS 'Entry Level',
    COUNT(CASE WHEN BaseSalary BETWEEN 40000 AND 60000 THEN 1 END) AS 'Mid Level',
    COUNT(CASE WHEN BaseSalary > 60000 THEN 1 END) AS 'Senior Level'
FROM Employees e;

-- Exercise 1.2b: Categorize projects by budget size
SELECT 
    COUNT(*) AS 'Total Projects',
    COUNT(CASE WHEN Budget < 25000 THEN 1 END) AS 'Small Projects',
    COUNT(CASE WHEN Budget BETWEEN 25000 AND 50000 THEN 1 END) AS 'Medium Projects', 
    COUNT(CASE WHEN Budget > 50000 THEN 1 END) AS 'Large Projects'
FROM Projects;
```

---

## Section 2: Joins + Grouping 📊
**Combining: Module 4 (Joins) + Module 9 (GROUP BY)**

### Exercise 2.1: d.DepartmentName Analysis with Joins (🟢 BASIC)
**Skills Combined: Module 4 (INNER JOIN) + Module 9 (GROUP BY, aggregates)**

```sql
-- Exercise 2.1a: Employee count and BaseSalary by d.DepartmentName name
SELECT d.DepartmentName,
    COUNT(e.EmployeeID) AS 'Number of Employees',
    FORMAT(SUM(e.BaseSalary), 'C0') AS 'Total d.DepartmentName Cost',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average BaseSalary'
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(e.EmployeeID) DESC;

-- Exercise 2.1b: Project count and budget by client
SELECT 
    c.ClientName,
    COUNT(p.ProjectID) AS 'Number of Projects',
    FORMAT(SUM(p.Budget), 'C0') AS 'Total Project Value',
    FORMAT(AVG(p.Budget), 'C0') AS 'Average Project Size'
FROM Clients c
INNER JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.ClientName
ORDER BY SUM(p.Budget) DESC;
```

### Exercise 2.2: Multi-Table Analysis (🟢 INTERMEDIATE)
**Skills Combined: Module 4 (Multiple JOINs) + Module 9 (GROUP BY, HAVING)**

```sql
-- Exercise 2.2a: d.DepartmentName project management analysis
SELECT d.DepartmentName,
    COUNT(p.ProjectID) AS 'Projects Managed',
    FORMAT(SUM(p.Budget), 'C0') AS 'Total Budget Managed',
    FORMAT(AVG(p.Budget), 'C0') AS 'Average Project Size'
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
GROUP BY d.DepartmentName
HAVING COUNT(p.ProjectID) >= 2  -- Only departments managing multiple projects
ORDER BY SUM(p.Budget) DESC;

-- Exercise 2.2b: Client industry analysis
SELECT 
    c.Industry,
    COUNT(DISTINCT c.ClientID) AS 'Number of Clients',
    COUNT(p.ProjectID) AS 'Total Projects', 
    FORMAT(SUM(p.Budget), 'C0') AS 'Industry Revenue'
FROM Clients c
INNER JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.Industry
HAVING COUNT(p.ProjectID) >= 3  -- Industries with significant business
ORDER BY SUM(p.Budget) DESC;
```

---

## Section 3: Filtering + Grouping 📊
**Combining: Module 5 (WHERE, ORDER BY) + Module 9 (GROUP BY, HAVING)**

### Exercise 3.1: Filtered Aggregation (🟢 BASIC)
**Skills Combined: Module 5 (WHERE filtering) + Module 9 (Aggregates, GROUP BY)**

```sql
-- Exercise 3.1a: High-paid employees by d.DepartmentName
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE BaseSalary > 45000  -- Filter for high earners first
GROUP BY d.DepartmentName
HAVING COUNT(*) >= 2  -- Only departments with multiple high earners
ORDER BY AVG(e.BaseSalary) DESC;

-- Exercise 3.1b: Recent large projects by status
SELECT 
    Status,
    COUNT(*) AS 'Number of Large Recent Projects',
    FORMAT(AVG(Budget), 'C0') AS 'Average Budget',
    FORMAT(SUM(Budget), 'C0') AS 'Total Budget'
FROM Projects
WHERE Budget > 30000 AND StartDate >= '2023-01-01'  -- Large recent projects
GROUP BY Status
ORDER BY SUM(Budget) DESC;
```

### Exercise 3.2: Complex Filtering with Sorting (🟢 INTERMEDIATE)
**Skills Combined: Module 5 (Complex WHERE, TOP, ORDER BY) + Module 9 (GROUP BY, HAVING)**

```sql
-- Exercise 3.2a: Top performing departments (recent hires, good salaries)
SELECT TOP 3
    d.DepartmentName,
    COUNT(*) AS 'Recent Good Hires',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average BaseSalary',
    MIN(HireDate) AS 'First Recent Hire',
    MAX(HireDate) AS 'Last Recent Hire'
FROM Employees
WHERE HireDate >= '2022-01-01' AND BaseSalary > 40000
GROUP BY d.DepartmentName
HAVING COUNT(*) >= 2
ORDER BY AVG(e.BaseSalary) DESC;

-- Exercise 3.2b: Most active clients in technology projects
SELECT 
    c.ClientName,
    c.Industry,
    COUNT(p.ProjectID) AS 'Tech Projects',
    FORMAT(AVG(p.Budget), 'C0') AS 'Average Project Value'
FROM Clients c
INNER JOIN Projects p ON c.ClientID = p.ClientID
WHERE c.Industry IN ('Technology', 'Software', 'IT Services')
  AND p.Budget > 20000
GROUP BY c.ClientName, c.Industry
HAVING COUNT(p.ProjectID) >= 2
ORDER BY COUNT(p.ProjectID) DESC, AVG(p.Budget) DESC;
```

---

## Section 4: Date/Time Functions + Grouping 📊
**Combining: Module 6 (Data Types) + Module 8 (Functions) + Module 9 (GROUP BY)**

### Exercise 4.1: Time-Based Analysis (🟢 BASIC)
**Skills Combined: Module 6 (Date functions) + Module 8 (YEAR, MONTH) + Module 9 (GROUP BY)**

```sql
-- Exercise 4.1a: Hiring trends by year
SELECT 
    YEAR(HireDate) AS 'Hire Year',
    COUNT(*) AS 'Employees Hired',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average Starting BaseSalary'
FROM Employees
WHERE HireDate IS NOT NULL
GROUP BY YEAR(HireDate)
ORDER BY YEAR(HireDate);

-- Exercise 4.1b: Project activity by quarter
SELECT 
    YEAR(StartDate) AS 'Project Year',
    DATEPART(QUARTER, StartDate) AS 'Quarter',
    COUNT(*) AS 'Projects Started',
    FORMAT(SUM(Budget), 'C0') AS 'Total Quarterly Budget'
FROM Projects
WHERE StartDate IS NOT NULL
GROUP BY YEAR(StartDate), DATEPART(QUARTER, StartDate)
HAVING COUNT(*) >= 2  -- Quarters with significant activity
ORDER BY YEAR(StartDate), DATEPART(QUARTER, StartDate);
```

### Exercise 4.2: Advanced Date Analysis (🟢 INTERMEDIATE)
**Skills Combined: Module 6 (Date calculations) + Module 8 (DATEDIFF) + Module 9 (Complex GROUP BY)**

```sql
-- Exercise 4.2a: Employee tenure analysis
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New (< 1 year)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 3 THEN 'Junior (1-2 years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN 'Experienced (3-4 years)'
        ELSE 'Veteran (5+ years)'
    END AS 'Tenure Group',
    COUNT(*) AS 'Number of Employees',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average BaseSalary',
    FORMAT(MAX(e.BaseSalary) - MIN(e.BaseSalary), 'C0') AS 'BaseSalary Range'
FROM Employees
WHERE HireDate IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New (< 1 year)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 3 THEN 'Junior (1-2 years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN 'Experienced (3-4 years)'
        ELSE 'Veteran (5+ years)'
    END
ORDER BY AVG(e.BaseSalary);

-- Exercise 4.2b: Project duration analysis by status
SELECT 
    Status,
    COUNT(*) AS 'Number of Projects',
    AVG(DATEDIFF(DAY, StartDate, ISNULL(EndDate, GETDATE()))) AS 'Average Duration (Days)',
    MIN(DATEDIFF(DAY, StartDate, ISNULL(EndDate, GETDATE()))) AS 'Shortest Project',
    MAX(DATEDIFF(DAY, StartDate, ISNULL(EndDate, GETDATE()))) AS 'Longest Project'
FROM Projects
WHERE StartDate IS NOT NULL
GROUP BY Status
HAVING COUNT(*) >= 2
ORDER BY AVG(DATEDIFF(DAY, StartDate, ISNULL(EndDate, GETDATE())));
```

---

## Section 5: String Functions + Grouping 📊
**Combining: Module 6 (Character Data) + Module 8 (String Functions) + Module 9 (GROUP BY)**

### Exercise 5.1: Text Analysis (🟢 BASIC)
**Skills Combined: Module 6 (String handling) + Module 8 (LEN, UPPER, SUBSTRING) + Module 9 (GROUP BY)**

```sql
-- Exercise 5.1a: Employee name length analysis by d.DepartmentName
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(*) >= 3  -- Departments with enough employees for meaningful stats
ORDER BY AVG(e.BaseSalary) DESC;

-- Exercise 6.1b: Project profitability analysis
SELECT 
    Status,
    COUNT(*) AS 'Number of Projects',
    FORMAT(SUM(Budget), 'C0') AS 'Total Budget',
    FORMAT(SUM(ISNULL(ActualCost, Budget * 0.8)), 'C0') AS 'Total Estimated Cost',
    FORMAT(SUM(Budget) - SUM(ISNULL(ActualCost, Budget * 0.8)), 'C0') AS 'Estimated Profit',
    ROUND(
        (SUM(Budget) - SUM(ISNULL(ActualCost, Budget * 0.8))) / SUM(Budget) * 100, 1
    ) AS 'Profit Margin %'
FROM Projects
GROUP BY Status
HAVING COUNT(*) >= 2
ORDER BY (SUM(Budget) - SUM(ISNULL(ActualCost, Budget * 0.8))) DESC;
```

---

## Section 7: NULL Handling + Grouping 📊
**Combining: Module 8 (NULL functions) + Module 9 (Aggregates with NULL handling)**

### Exercise 7.1: Missing Data Analysis (🟢 INTERMEDIATE)
**Skills Combined: Module 8 (ISNULL, COALESCE, NULLIF) + Module 9 (COUNT with conditions)**

```sql
-- Exercise 7.1a: Employee contact information completeness by d.DepartmentName
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(*) DESC;

-- Exercise 7.1b: Project completion tracking
SELECT 
    Status,
    COUNT(*) AS 'Total Projects',
    COUNT(StartDate) AS 'Has Start Date',
    COUNT(EndDate) AS 'Has End Date',
    COUNT(ActualCost) AS 'Has Actual Cost',
    ROUND(COUNT(EndDate) * 100.0 / COUNT(*), 1) AS 'Completion %'
FROM Projects
GROUP BY Status
ORDER BY ROUND(COUNT(EndDate) * 100.0 / COUNT(*), 1) DESC;
```

---

## Section 8: Comprehensive Business Scenarios 📊
**Combining: All Previous Modules (3-8) + Module 9 (Complete Analysis)**

### Exercise 8.1: Executive Dashboard Query (🟢 CHALLENGING)
**Skills Combined: All modules - Complex business intelligence report**

```sql
-- Exercise 8.1: Complete business overview combining all concepts
WITH DepartmentStats AS (
    SELECT d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary,
        COUNT(p.ProjectID) AS ProjectsManaged,
        SUM(p.Budget) AS TotalBudgetManaged
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    GROUP BY d.DepartmentName
),
ClientStats AS (
    SELECT 
        c.Industry,
        COUNT(DISTINCT c.ClientID) AS ClientCount,
        COUNT(p.ProjectID) AS ProjectCount,
        AVG(p.Budget) AS AvgProjectSize,
        SUM(p.Budget) AS TotalRevenue
    FROM Clients c
    LEFT JOIN Projects p ON c.ClientID = p.ClientID
    GROUP BY c.Industry
)
SELECT 
    'Department Performance' AS ReportSection,
    ds.DepartmentName AS Category,
    ds.EmployeeCount AS Count1,
    FORMAT(ds.AvgSalary, 'C0') AS Value1,
    ds.ProjectsManaged AS Count2,
    FORMAT(ds.TotalBudgetManaged, 'C0') AS Value2
FROM DepartmentStats ds
WHERE ds.EmployeeCount > 0

UNION ALL

SELECT 
    'Industry Performance' AS ReportSection,
    cs.Industry AS Category,
    cs.ClientCount AS Count1,
    FORMAT(cs.AvgProjectSize, 'C0') AS Value1,
    cs.ProjectCount AS Count2,
    FORMAT(cs.TotalRevenue, 'C0') AS Value2
FROM ClientStats cs
WHERE cs.ProjectCount > 0

ORDER BY ReportSection, Count1 DESC;
```

### Exercise 8.2: Trend Analysis Report (🟢 CHALLENGING)
**Skills Combined: Date functions, string manipulation, mathematical calculations, grouping**

```sql
-- Exercise 8.2: Comprehensive trend analysis
SELECT 
    YEAR(e.HireDate) AS AnalysisYear,
    COUNT(*) AS 'Employees Hired',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average Starting BaseSalary',
    
    -- Project activity in the same year
    (SELECT COUNT(*) 
     FROM Projects p 
     WHERE YEAR(p.StartDate) = YEAR(e.HireDate)) AS 'Projects Started Same Year',
    
    -- Calculate growth rate
    CASE 
        WHEN LAG(COUNT(*)) OVER (ORDER BY YEAR(e.HireDate)) IS NOT NULL THEN
            ROUND(
                (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(e.HireDate))) * 100.0 / 
                LAG(COUNT(*)) OVER (ORDER BY YEAR(e.HireDate)), 1
            )
        ELSE NULL
    END AS 'Hiring Growth %',
    
    -- d.DepartmentName diversity
    COUNT(DISTINCT e.d.DepartmentName) AS 'Departments Involved',
    
    -- BaseSalary progression
    CASE 
        WHEN LAG(AVG(e.BaseSalary)) OVER (ORDER BY YEAR(e.HireDate)) IS NOT NULL THEN
            ROUND(
                (AVG(e.BaseSalary) - LAG(AVG(e.BaseSalary)) OVER (ORDER BY YEAR(e.HireDate))) * 100.0 / 
                LAG(AVG(e.BaseSalary)) OVER (ORDER BY YEAR(e.HireDate)), 1
            )
        ELSE NULL
    END AS 'BaseSalary Growth %'

FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate IS NOT NULL 
  AND YEAR(e.HireDate) >= 2020  -- Recent years only
GROUP BY YEAR(e.HireDate)
HAVING COUNT(*) >= 2  -- Years with significant hiring
ORDER BY YEAR(e.HireDate);
```

---

## 📝 Exercise Summary

### **Skills Successfully Combined:**

✅ **Module 3 + Module 9**: SELECT statements with aggregates, aliases, CASE expressions  
✅ **Module 4 + Module 9**: JOIN operations with GROUP BY and aggregates  
✅ **Module 5 + Module 9**: WHERE filtering combined with GROUP BY and HAVING  
✅ **Module 6 + Module 9**: Date/time and string data types with grouping  
✅ **Module 7 + Module 9**: Data modification understanding with aggregation  
✅ **Module 8 + Module 9**: Built-in functions (math, string, date, NULL) with grouping  

### **Business Skills Developed:**

🎯 **Data Analysis**: Combining multiple data sources for insights  
🎯 **Trend Analysis**: Using dates and calculations to spot patterns  
🎯 **Performance Metrics**: Creating KPIs with mathematical functions  
🎯 **Report Building**: Constructing executive-level summaries  
🎯 **Data Quality**: Handling missing data and completeness analysis  

### **Progression Notes:**

- **Exercises start simple** and build complexity gradually
- **Each section clearly labels** which modules are being combined  
- **Real business scenarios** make the learning practical and relevant
- **Comments explain** the business purpose of each calculation
- **Results are formatted** for professional presentation

**Key Takeaway**: These exercises show how SQL skills build on each other to create powerful business intelligence and reporting capabilities!