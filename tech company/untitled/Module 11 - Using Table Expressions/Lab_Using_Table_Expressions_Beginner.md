# Lab: Using Table Expressions - Beginner Lab

## 🎯 Lab Overview

Welcome to your hands-on practice lab for Table Expressions! This lab covers all four types of table expressions you learned: Views, Inline TVFs, Derived Tables, and CTEs.

**Time Required:** 60-75 minutes  
**Difficulty:** Beginner to Intermediate

---

## 📋 Before You Start

### Step 1: Connect to the Database
```sql
USE TechCorpDB;
GO
```

### Step 2: Verify Tables Exist
```sql
SELECT 'Employees' AS TableName, COUNT(*) AS RecordCount FROM Employees
UNION ALL SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL SELECT 'Orders', COUNT(*) FROM Orders;
```

---

## 📊 Part 1: Views

### Exercise 1.1: Create an Employee Directory View ⭐ (Easy)

**Task:** Create a view called `vw_EmployeeDirectory` that shows:
- EmployeeID, FirstName, LastName
- Full name (FirstName + LastName)
- JobTitle, DepartmentName
- WorkEmail

Only include active employees.

```sql
-- Write your CREATE VIEW statement here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
CREATE VIEW vw_EmployeeDirectory
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        d.DepartmentName,
        e.WorkEmail
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
GO
```

</details>

**Test your view:**
```sql
SELECT * FROM vw_EmployeeDirectory WHERE DepartmentName = 'Engineering';
```

---

### Exercise 1.2: Create a Department Summary View ⭐⭐ (Medium)

**Task:** Create a view called `vw_DepartmentSummary` that shows for each department:
- DepartmentName, Location, Budget
- EmployeeCount
- AverageSalary
- TotalSalaryExpense

```sql
-- Write your CREATE VIEW statement here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
CREATE VIEW vw_DepartmentSummary
AS
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Location,
        d.Budget,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AverageSalary,
        SUM(e.BaseSalary) AS TotalSalaryExpense
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName, d.Location, d.Budget;
GO
```

</details>

---

### Exercise 1.3: Use Views Together ⭐⭐ (Medium)

**Task:** Using your `vw_DepartmentSummary` view, find departments where salary expense exceeds 80% of budget.

```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    DepartmentName,
    Budget,
    TotalSalaryExpense,
    CAST(TotalSalaryExpense * 100.0 / Budget AS DECIMAL(5,2)) AS PercentOfBudget
FROM vw_DepartmentSummary
WHERE TotalSalaryExpense > Budget * 0.8
ORDER BY PercentOfBudget DESC;
```

</details>

---

## 📊 Part 2: Inline Table-Valued Functions

### Exercise 2.1: Create Employee Filter Function ⭐ (Easy)

**Task:** Create a function called `fn_GetEmployeesByJobTitle` that accepts a job title pattern and returns matching employees.

```sql
-- Write your CREATE FUNCTION statement here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
CREATE FUNCTION fn_GetEmployeesByJobTitle (@JobTitlePattern VARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.JobTitle LIKE '%' + @JobTitlePattern + '%'
      AND e.IsActive = 1
);
GO
```

</details>

**Test your function:**
```sql
SELECT * FROM fn_GetEmployeesByJobTitle('Manager');
SELECT * FROM fn_GetEmployeesByJobTitle('Developer');
```

---

### Exercise 2.2: Create Salary Range Function ⭐⭐ (Medium)

**Task:** Create a function called `fn_GetEmployeesInSalaryRange` that accepts min and max salary.

```sql
-- Write your CREATE FUNCTION statement here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
CREATE FUNCTION fn_GetEmployeesInSalaryRange 
(
    @MinSalary MONEY,
    @MaxSalary MONEY
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        CASE 
            WHEN e.BaseSalary < (@MaxSalary - @MinSalary) / 3 + @MinSalary THEN 'Lower Range'
            WHEN e.BaseSalary < (@MaxSalary - @MinSalary) * 2 / 3 + @MinSalary THEN 'Mid Range'
            ELSE 'Upper Range'
        END AS SalaryPosition
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.BaseSalary BETWEEN @MinSalary AND @MaxSalary
      AND e.IsActive = 1
);
GO
```

</details>

**Test your function:**
```sql
SELECT * FROM fn_GetEmployeesInSalaryRange(60000, 90000) ORDER BY BaseSalary;
```

---

### Exercise 2.3: Use Function with CROSS APPLY ⭐⭐⭐ (Hard)

**Task:** For each department, get the top 2 highest-paid employees using a function.

First, create this function:
```sql
CREATE FUNCTION fn_GetTopEmployeesByDepartment 
(
    @DepartmentID INT,
    @TopN INT
)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (@TopN)
        EmployeeID,
        FirstName,
        LastName,
        JobTitle,
        BaseSalary
    FROM Employees
    WHERE DepartmentID = @DepartmentID
      AND IsActive = 1
    ORDER BY BaseSalary DESC
);
GO
```

Now use CROSS APPLY to get top 2 per department:

```sql
-- Write your query using CROSS APPLY here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    d.DepartmentName,
    emp.FirstName,
    emp.LastName,
    emp.JobTitle,
    emp.BaseSalary
FROM Departments d
CROSS APPLY fn_GetTopEmployeesByDepartment(d.DepartmentID, 2) emp
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, emp.BaseSalary DESC;
```

</details>

---

## 📊 Part 3: Derived Tables

### Exercise 3.1: Simple Derived Table ⭐ (Easy)

**Task:** Find departments with more than 10 employees using a derived table.

```sql
-- Write your query with derived table here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    d.DepartmentName,
    DeptCounts.EmployeeCount
FROM (
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
) AS DeptCounts
INNER JOIN Departments d ON DeptCounts.DepartmentID = d.DepartmentID
WHERE DeptCounts.EmployeeCount > 10
ORDER BY DeptCounts.EmployeeCount DESC;
```

</details>

---

### Exercise 3.2: Derived Table for Comparison ⭐⭐ (Medium)

**Task:** Show employees earning above their department's average using a derived table.

```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    DeptAvg.DepartmentName,
    DeptAvg.AvgSalary AS DeptAverage,
    e.BaseSalary - DeptAvg.AvgSalary AS AboveAverageBy
FROM Employees e
INNER JOIN (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        AVG(emp.BaseSalary) AS AvgSalary
    FROM Departments d
    INNER JOIN Employees emp ON d.DepartmentID = emp.DepartmentID
    WHERE emp.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) AS DeptAvg ON e.DepartmentID = DeptAvg.DepartmentID
WHERE e.BaseSalary > DeptAvg.AvgSalary
  AND e.IsActive = 1
ORDER BY AboveAverageBy DESC;
```

</details>

---

### Exercise 3.3: Multiple Derived Tables ⭐⭐⭐ (Hard)

**Task:** Create a comparison report showing:
- Each department's average salary
- Company-wide average salary
- Difference between them

Use two derived tables.

```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    DeptStats.DepartmentName,
    DeptStats.EmployeeCount,
    DeptStats.AvgSalary AS DeptAvgSalary,
    CompanyStats.CompanyAvgSalary,
    DeptStats.AvgSalary - CompanyStats.CompanyAvgSalary AS DifferenceFromCompanyAvg
FROM (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) AS DeptStats
CROSS JOIN (
    SELECT AVG(BaseSalary) AS CompanyAvgSalary
    FROM Employees
    WHERE IsActive = 1
) AS CompanyStats
ORDER BY DifferenceFromCompanyAvg DESC;
```

</details>

---

## 📊 Part 4: CTEs (Common Table Expressions)

### Exercise 4.1: Simple CTE ⭐ (Easy)

**Task:** Rewrite Exercise 3.1 using a CTE instead of a derived table.

```sql
-- Write your query with CTE here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
WITH DeptCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
)
SELECT 
    d.DepartmentName,
    dc.EmployeeCount
FROM DeptCounts dc
INNER JOIN Departments d ON dc.DepartmentID = d.DepartmentID
WHERE dc.EmployeeCount > 10
ORDER BY dc.EmployeeCount DESC;
```

</details>

---

### Exercise 4.2: Multiple CTEs ⭐⭐ (Medium)

**Task:** Create a report with multiple CTEs showing:
1. Department employee counts
2. Department salary totals
3. Combined summary

```sql
-- Write your query with multiple CTEs here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
WITH 
DeptEmployeeCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
),
DeptSalaryTotals AS (
    SELECT 
        DepartmentID,
        SUM(BaseSalary) AS TotalSalary,
        AVG(BaseSalary) AS AvgSalary
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
)
SELECT 
    d.DepartmentName,
    dec.EmployeeCount,
    dst.TotalSalary,
    dst.AvgSalary,
    d.Budget,
    d.Budget - dst.TotalSalary AS RemainingBudget
FROM DeptEmployeeCounts dec
INNER JOIN DeptSalaryTotals dst ON dec.DepartmentID = dst.DepartmentID
INNER JOIN Departments d ON dec.DepartmentID = d.DepartmentID
ORDER BY dec.EmployeeCount DESC;
```

</details>

---

### Exercise 4.3: CTEs with Ranking ⭐⭐⭐ (Hard)

**Task:** Find the top 3 highest-paid employees in each department using a CTE with window functions.

```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
WITH RankedEmployees AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        d.DepartmentName,
        ROW_NUMBER() OVER (
            PARTITION BY e.DepartmentID 
            ORDER BY e.BaseSalary DESC
        ) AS SalaryRank
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
)
SELECT 
    DepartmentName,
    SalaryRank,
    FirstName,
    LastName,
    JobTitle,
    BaseSalary
FROM RankedEmployees
WHERE SalaryRank <= 3
ORDER BY DepartmentName, SalaryRank;
```

</details>

---

### Exercise 4.4: CTE Self-Reference ⭐⭐⭐ (Hard)

**Task:** Use a CTE twice in the same query to compare highest and lowest salaries per department.

```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
WITH SalaryRanks AS (
    SELECT 
        e.DepartmentID,
        d.DepartmentName,
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.BaseSalary DESC) AS HighRank,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.BaseSalary ASC) AS LowRank
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
)
SELECT 
    high.DepartmentName,
    high.FirstName + ' ' + high.LastName AS HighestPaid,
    high.BaseSalary AS HighestSalary,
    low.FirstName + ' ' + low.LastName AS LowestPaid,
    low.BaseSalary AS LowestSalary,
    high.BaseSalary - low.BaseSalary AS SalaryGap
FROM SalaryRanks high
INNER JOIN SalaryRanks low 
    ON high.DepartmentID = low.DepartmentID
    AND high.HighRank = 1 
    AND low.LowRank = 1
ORDER BY SalaryGap DESC;
```

</details>

---

## 📊 Part 5: Comprehensive Challenge

### Challenge: Complete Analysis Report ⭐⭐⭐⭐ (Very Hard)

**Task:** Create a comprehensive department analysis using:
- A CTE for employee statistics
- A CTE for project statistics
- Join them together for a full report

Include:
- Department name
- Employee count, average salary, salary range
- Number of projects, total project budget
- Budget utilization (salary as % of department budget)

```sql
-- Write your comprehensive query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
WITH 
EmployeeStats AS (
    SELECT 
        e.DepartmentID,
        COUNT(*) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary,
        MIN(e.BaseSalary) AS MinSalary,
        MAX(e.BaseSalary) AS MaxSalary,
        SUM(e.BaseSalary) AS TotalSalary
    FROM Employees e
    WHERE e.IsActive = 1
    GROUP BY e.DepartmentID
),
ProjectStats AS (
    SELECT 
        pm.DepartmentID,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(p.Budget) AS TotalProjectBudget
    FROM Projects p
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    GROUP BY pm.DepartmentID
)
SELECT 
    d.DepartmentName,
    d.Budget AS DepartmentBudget,
    ISNULL(es.EmployeeCount, 0) AS EmployeeCount,
    ISNULL(es.AvgSalary, 0) AS AvgSalary,
    ISNULL(es.MaxSalary, 0) - ISNULL(es.MinSalary, 0) AS SalaryRange,
    ISNULL(ps.ProjectCount, 0) AS ProjectCount,
    ISNULL(ps.TotalProjectBudget, 0) AS TotalProjectBudget,
    ISNULL(es.TotalSalary, 0) AS TotalSalaryExpense,
    CASE 
        WHEN d.Budget > 0 
        THEN CAST(ISNULL(es.TotalSalary, 0) * 100.0 / d.Budget AS DECIMAL(5,2))
        ELSE 0 
    END AS BudgetUtilizationPct
FROM Departments d
LEFT JOIN EmployeeStats es ON d.DepartmentID = es.DepartmentID
LEFT JOIN ProjectStats ps ON d.DepartmentID = ps.DepartmentID
WHERE d.IsActive = 1
ORDER BY es.EmployeeCount DESC;
```

</details>

---

## 📋 Lab Summary Checklist

Check off what you've practiced:

**Views:**
- [ ] ⭐ Create a basic view
- [ ] ⭐⭐ Create a view with aggregations
- [ ] ⭐⭐ Query views with filtering

**Inline TVFs:**
- [ ] ⭐ Create a simple TVF with one parameter
- [ ] ⭐⭐ Create a TVF with multiple parameters
- [ ] ⭐⭐⭐ Use CROSS APPLY with TVFs

**Derived Tables:**
- [ ] ⭐ Simple derived table with GROUP BY
- [ ] ⭐⭐ Derived table with JOINs
- [ ] ⭐⭐⭐ Multiple derived tables

**CTEs:**
- [ ] ⭐ Simple CTE
- [ ] ⭐⭐ Multiple CTEs
- [ ] ⭐⭐⭐ CTEs with window functions
- [ ] ⭐⭐⭐ CTE used multiple times

---

## 🎯 Self-Assessment

**Rate your confidence (1-5):**

| Skill | Rating |
|-------|--------|
| Creating and using Views | ___ |
| Creating Inline TVFs | ___ |
| Using Derived Tables | ___ |
| Writing CTEs | ___ |
| Choosing the right table expression | ___ |

---

## 🧹 Cleanup (Optional)

If you want to remove the objects you created:

```sql
-- Drop views
IF OBJECT_ID('vw_EmployeeDirectory', 'V') IS NOT NULL DROP VIEW vw_EmployeeDirectory;
IF OBJECT_ID('vw_DepartmentSummary', 'V') IS NOT NULL DROP VIEW vw_DepartmentSummary;

-- Drop functions
IF OBJECT_ID('fn_GetEmployeesByJobTitle', 'IF') IS NOT NULL DROP FUNCTION fn_GetEmployeesByJobTitle;
IF OBJECT_ID('fn_GetEmployeesInSalaryRange', 'IF') IS NOT NULL DROP FUNCTION fn_GetEmployeesInSalaryRange;
IF OBJECT_ID('fn_GetTopEmployeesByDepartment', 'IF') IS NOT NULL DROP FUNCTION fn_GetTopEmployeesByDepartment;
```

---

## 🚀 What's Next?

Congratulations on completing the Table Expressions Lab! 

**Next Module:** Module 14 - Pivoting and Grouping Sets
