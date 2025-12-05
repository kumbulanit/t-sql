# Lesson 2: Working with Grouping Sets - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! This lesson introduces **Grouping Sets** - a powerful way to create multiple levels of aggregation in a single query. Think of it as getting subtotals AND grand totals automatically!

---

## 📖 What are Grouping Sets? (The Simple Explanation)

### Real-World Analogy: The Sales Report

Imagine your boss asks for a sales report with:
1. Sales by **each salesperson**
2. Sales by **each region**
3. Sales by **salesperson AND region together**
4. **Grand total** of all sales

**Without Grouping Sets:** You'd write 4 separate queries and combine them.

**With Grouping Sets:** One query does it all!

```
┌─────────────────────────────────────────────────────────────────┐
│                GROUPING SETS - MULTIPLE TOTALS                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Regular GROUP BY gives you ONE level:                          │
│  ┌──────────────────────────────────────┐                       │
│  │ Department  │ Total Salary           │                       │
│  ├─────────────┼────────────────────────┤                       │
│  │ Engineering │ $500,000               │                       │
│  │ Marketing   │ $300,000               │                       │
│  │ Sales       │ $400,000               │                       │
│  └──────────────────────────────────────┘                       │
│           ❌ No grand total!                                    │
│                                                                 │
│  GROUPING SETS gives you MULTIPLE levels:                       │
│  ┌──────────────────────────────────────┐                       │
│  │ Department  │ Total Salary           │                       │
│  ├─────────────┼────────────────────────┤                       │
│  │ Engineering │ $500,000    ← Detail   │                       │
│  │ Marketing   │ $300,000    ← Detail   │                       │
│  │ Sales       │ $400,000    ← Detail   │                       │
│  │ NULL        │ $1,200,000  ← TOTAL!   │                       │
│  └──────────────────────────────────────┘                       │
│           ✅ Grand total included!                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Three Ways to Create Grouping Sets

| Method | What It Does | Use When |
|--------|--------------|----------|
| **ROLLUP** | Creates hierarchical subtotals (right to left) | Simple subtotal reports |
| **CUBE** | Creates ALL possible combinations | Cross-tab analysis |
| **GROUPING SETS** | You choose exactly which combinations | Custom reports |

---

## 🎓 Part 1: ROLLUP - Hierarchical Subtotals

### What is ROLLUP?

ROLLUP creates subtotals in a **hierarchical** way, from right to left.

```sql
GROUP BY ROLLUP(A, B, C)
-- Creates groupings for:
-- (A, B, C)  ← Detail level
-- (A, B)    ← Subtotal by A and B
-- (A)       ← Subtotal by A only
-- ()        ← Grand total
```

### Example 1.1: Department and Job Title ROLLUP

**Goal:** Show salary totals by department and job title, with subtotals.

```sql
SELECT 
    COALESCE(d.DepartmentName, '*** GRAND TOTAL ***') AS Department,
    COALESCE(e.JobTitle, '-- Dept Total --') AS JobTitle,
    COUNT(*) AS EmployeeCount,
    SUM(e.BaseSalary) AS TotalSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY ROLLUP(d.DepartmentName, e.JobTitle)
ORDER BY 
    GROUPING(d.DepartmentName),    -- Grand total last
    d.DepartmentName,
    GROUPING(e.JobTitle),          -- Subtotals after details
    e.JobTitle;
```

**Expected Result:**
| Department        | JobTitle          | EmployeeCount | TotalSalary |
|-------------------|-------------------|---------------|-------------|
| Engineering       | Developer         | 10            | 750,000     |
| Engineering       | Senior Developer  | 5             | 450,000     |
| Engineering       | Manager           | 2             | 200,000     |
| Engineering       | -- Dept Total --  | 17            | 1,400,000   |
| Marketing         | Analyst           | 4             | 280,000     |
| Marketing         | Manager           | 2             | 180,000     |
| Marketing         | -- Dept Total --  | 6             | 460,000     |
| *** GRAND TOTAL ***| -- Dept Total -- | 23            | 1,860,000   |

---

### Example 1.2: Year, Quarter, Month ROLLUP

**Goal:** Show order totals with hierarchical time rollup.

```sql
SELECT 
    COALESCE(CAST(OrderYear AS VARCHAR), '*** ALL YEARS ***') AS Year,
    COALESCE(Quarter, '-- Year Total --') AS Quarter,
    COALESCE(CAST(OrderMonth AS VARCHAR), '-- Qtr Total --') AS Month,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalSales
FROM (
    SELECT 
        YEAR(OrderDate) AS OrderYear,
        'Q' + CAST(DATEPART(QUARTER, OrderDate) AS VARCHAR) AS Quarter,
        MONTH(OrderDate) AS OrderMonth,
        TotalAmount
    FROM Orders
    WHERE OrderDate >= '2024-01-01'
) AS OrderData
GROUP BY ROLLUP(OrderYear, Quarter, OrderMonth)
ORDER BY 
    GROUPING(OrderYear), OrderYear,
    GROUPING(Quarter), Quarter,
    GROUPING(OrderMonth), OrderMonth;
```

---

## 🎓 Part 2: CUBE - All Combinations

### What is CUBE?

CUBE creates **every possible combination** of groupings.

```sql
GROUP BY CUBE(A, B)
-- Creates groupings for:
-- (A, B)  ← Both A and B
-- (A)     ← Only A
-- (B)     ← Only B
-- ()      ← Grand total
```

### Example 2.1: Department and Location CUBE

**Goal:** Analyze employee count by department AND by location, with all combinations.

```sql
SELECT 
    COALESCE(d.DepartmentName, '*** ALL DEPTS ***') AS Department,
    COALESCE(d.Location, '*** ALL LOCATIONS ***') AS Location,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY CUBE(d.DepartmentName, d.Location)
ORDER BY 
    GROUPING(d.DepartmentName),
    d.DepartmentName,
    GROUPING(d.Location),
    d.Location;
```

**Expected Result:**
| Department        | Location          | EmployeeCount | AvgSalary |
|-------------------|-------------------|---------------|-----------|
| Engineering       | Building A        | 10            | 85,000    |
| Engineering       | Building B        | 7             | 82,000    |
| Engineering       | *** ALL LOCATIONS *** | 17       | 84,000    |
| Marketing         | Building B        | 6             | 72,000    |
| Marketing         | *** ALL LOCATIONS *** | 6        | 72,000    |
| *** ALL DEPTS *** | Building A        | 10            | 85,000    |
| *** ALL DEPTS *** | Building B        | 13            | 78,000    |
| *** ALL DEPTS *** | *** ALL LOCATIONS *** | 23       | 80,000    |

**Notice:** CUBE gives us totals by department, by location, AND the grand total!

---

## 🎓 Part 3: GROUPING SETS - Custom Combinations

### What is GROUPING SETS?

With GROUPING SETS, **you decide exactly which combinations** to include.

```sql
GROUP BY GROUPING SETS (
    (A, B),   -- This combination
    (A),      -- This combination
    ()        -- Grand total
    -- Notice: we're NOT including (B) alone
)
```

### Example 3.1: Custom Summary Report

**Goal:** Create a report with only specific groupings we need.

```sql
SELECT 
    CASE 
        WHEN GROUPING(d.DepartmentName) = 1 AND GROUPING(e.JobTitle) = 1 
        THEN 'GRAND TOTAL'
        WHEN GROUPING(e.JobTitle) = 1 
        THEN d.DepartmentName + ' Total'
        ELSE d.DepartmentName
    END AS Department,
    COALESCE(e.JobTitle, '') AS JobTitle,
    COUNT(*) AS EmpCount,
    SUM(e.BaseSalary) AS TotalSalary,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY GROUPING SETS (
    (d.DepartmentName, e.JobTitle),  -- Detail
    (d.DepartmentName),               -- Department subtotal
    ()                                -- Grand total
)
ORDER BY 
    GROUPING(d.DepartmentName),
    d.DepartmentName,
    GROUPING(e.JobTitle),
    e.JobTitle;
```

---

### Example 3.2: Sales Report with Custom Groups

**Goal:** Show sales by region and by salesperson, but NOT their combination.

```sql
SELECT 
    CASE 
        WHEN GROUPING(Region) = 0 THEN 'Region: ' + Region
        ELSE NULL
    END AS ByRegion,
    CASE 
        WHEN GROUPING(SalespersonName) = 0 THEN 'Person: ' + SalespersonName
        ELSE NULL
    END AS BySalesperson,
    SUM(TotalAmount) AS Sales
FROM (
    SELECT 
        c.City AS Region,  -- Simplified example
        e.FirstName + ' ' + e.LastName AS SalespersonName,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    INNER JOIN Employees e ON o.CompanyID = e.CompanyID
) AS SalesData
GROUP BY GROUPING SETS (
    (Region),           -- Sales by region only
    (SalespersonName),  -- Sales by person only
    ()                  -- Grand total
)
ORDER BY 
    CASE WHEN GROUPING(Region) = 0 THEN 1 ELSE 2 END,
    Region,
    SalespersonName;
```

---

## 🎓 Part 4: The GROUPING() Function

### What is GROUPING()?

`GROUPING(column)` returns:
- **0** if the column is part of the current grouping (real value)
- **1** if the column is aggregated (NULL represents a subtotal/total)

### Using GROUPING() for Better Labels

```sql
SELECT 
    -- Use GROUPING to create meaningful labels
    CASE GROUPING(d.DepartmentName)
        WHEN 0 THEN d.DepartmentName
        WHEN 1 THEN '=== ALL DEPARTMENTS ==='
    END AS Department,
    
    CASE GROUPING(e.JobTitle)
        WHEN 0 THEN e.JobTitle
        WHEN 1 THEN '--- ALL JOB TITLES ---'
    END AS JobTitle,
    
    COUNT(*) AS EmployeeCount,
    SUM(e.BaseSalary) AS TotalSalary,
    
    -- Show what type of row this is
    CASE 
        WHEN GROUPING(d.DepartmentName) = 1 AND GROUPING(e.JobTitle) = 1 
        THEN 'Grand Total'
        WHEN GROUPING(e.JobTitle) = 1 
        THEN 'Department Subtotal'
        ELSE 'Detail'
    END AS RowType
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY ROLLUP(d.DepartmentName, e.JobTitle);
```

---

## 📊 Visual Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│         ROLLUP vs CUBE vs GROUPING SETS                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  For GROUP BY (Dept, Title):                                    │
│                                                                 │
│  ROLLUP(Dept, Title)         CUBE(Dept, Title)                  │
│  ├── (Dept, Title) ✓         ├── (Dept, Title) ✓                │
│  ├── (Dept)        ✓         ├── (Dept)        ✓                │
│  ├── ()            ✓         ├── (Title)       ✓   ← Extra!    │
│  └── (Title) alone ✗         └── ()            ✓                │
│                                                                 │
│  GROUPING SETS - You Choose!                                    │
│  ┌─────────────────────────────────────────┐                    │
│  │ GROUP BY GROUPING SETS (                │                    │
│  │   (Dept, Title),  -- Include this ✓     │                    │
│  │   (Dept),         -- Include this ✓     │                    │
│  │   (Title),        -- Include this ✓     │  ← Your choice    │
│  │   ()              -- Include this ✓     │                    │
│  │ )                                       │                    │
│  └─────────────────────────────────────────┘                    │
│                                                                 │
│  💡 ROLLUP = Hierarchical (reports with drill-down)             │
│  💡 CUBE = All combinations (cross-tab analysis)                │
│  💡 GROUPING SETS = Custom (exact control)                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Simple ROLLUP (Easy)

Create a salary report by department with grand total using ROLLUP.

```sql
-- Your answer:
SELECT 
    COALESCE(d.DepartmentName, '*** TOTAL ***') AS Department,
    COUNT(*) AS EmployeeCount,
    SUM(e.BaseSalary) AS TotalSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY ROLLUP(d.DepartmentName)
ORDER BY GROUPING(d.DepartmentName), d.DepartmentName;
```

### Exercise 2: CUBE Analysis (Medium)

Use CUBE to analyze order totals by year and customer city.

```sql
-- Your answer:
SELECT 
    COALESCE(CAST(YEAR(o.OrderDate) AS VARCHAR), '** All Years **') AS OrderYear,
    COALESCE(c.City, '** All Cities **') AS CustomerCity,
    COUNT(*) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSales
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY CUBE(YEAR(o.OrderDate), c.City)
ORDER BY 
    GROUPING(YEAR(o.OrderDate)), YEAR(o.OrderDate),
    GROUPING(c.City), c.City;
```

### Exercise 3: Custom GROUPING SETS (Hard)

Create a report showing only specific combinations you need.

```sql
-- Your answer:
SELECT 
    CASE WHEN GROUPING(d.DepartmentName) = 0 THEN d.DepartmentName ELSE 'ALL DEPTS' END AS Dept,
    CASE WHEN GROUPING(d.Location) = 0 THEN d.Location ELSE 'ALL LOCATIONS' END AS Location,
    COUNT(*) AS EmpCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY GROUPING SETS (
    (d.DepartmentName),   -- By department
    (d.Location),         -- By location
    ()                    -- Grand total
)
ORDER BY 
    GROUPING(d.DepartmentName) + GROUPING(d.Location),
    d.DepartmentName, d.Location;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ ROLLUP creates hierarchical subtotals (parent → child)      │
│     Good for: drill-down reports, time hierarchies              │
│                                                                 │
│  ✅ CUBE creates ALL possible combinations                      │
│     Good for: cross-tab analysis, multi-dimensional reports     │
│                                                                 │
│  ✅ GROUPING SETS lets you pick exact combinations              │
│     Good for: custom reports, specific analysis needs           │
│                                                                 │
│  ✅ GROUPING(column) tells you if it's a subtotal row           │
│     Returns 1 for subtotal/total, 0 for actual value            │
│                                                                 │
│  ✅ Use COALESCE or CASE to create readable subtotal labels     │
│                                                                 │
│  ✅ One query replaces multiple UNION queries!                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📈 Optional: Intermediate & Advanced Examples

Ready for more challenging scenarios? Try these:

### Intermediate Example: Sales Analysis with Multiple Dimensions

**Challenge:** Create a comprehensive sales report with multiple grouping levels.

```sql
-- Sales analysis by Year, Quarter, and Region with all levels of totals
WITH SalesData AS (
    SELECT 
        YEAR(o.OrderDate) AS SalesYear,
        'Q' + CAST(DATEPART(QUARTER, o.OrderDate) AS VARCHAR) AS Quarter,
        c.City AS Region,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate >= '2023-01-01'
)
SELECT 
    COALESCE(CAST(SalesYear AS VARCHAR), '*** ALL YEARS ***') AS Year,
    COALESCE(Quarter, '-- All Quarters --') AS Quarter,
    COALESCE(Region, '-- All Regions --') AS Region,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalSales,
    AVG(TotalAmount) AS AvgOrderValue
FROM SalesData
GROUP BY CUBE(SalesYear, Quarter, Region)
HAVING GROUPING(SalesYear) = 0  -- Exclude all-NULL row
    OR (GROUPING(SalesYear) = 1 AND GROUPING(Quarter) = 1 AND GROUPING(Region) = 1)  -- Include grand total only
ORDER BY 
    GROUPING(SalesYear), SalesYear,
    GROUPING(Quarter), Quarter,
    GROUPING(Region), Region;
```

### Advanced Example: Budget vs Actual Analysis

**Challenge:** Compare budgets with actual spending using ROLLUP.

```sql
-- Department budget analysis with hierarchical totals
WITH DepartmentAnalysis AS (
    SELECT 
        d.DepartmentName,
        p.ProjectName,
        p.Budget AS PlannedBudget,
        ISNULL(SUM(e.BaseSalary * 0.1), 0) AS ActualCost  -- Simplified cost calc
    FROM Departments d
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
    LEFT JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentName, p.ProjectName, p.Budget
)
SELECT 
    COALESCE(DepartmentName, '*** COMPANY TOTAL ***') AS Department,
    COALESCE(ProjectName, '-- Dept Total --') AS Project,
    SUM(PlannedBudget) AS TotalBudget,
    SUM(ActualCost) AS TotalActual,
    SUM(PlannedBudget) - SUM(ActualCost) AS Variance,
    CASE 
        WHEN SUM(PlannedBudget) > 0 
        THEN CAST(SUM(ActualCost) * 100.0 / SUM(PlannedBudget) AS DECIMAL(5,2))
        ELSE 0 
    END AS PercentUsed
FROM DepartmentAnalysis
GROUP BY ROLLUP(DepartmentName, ProjectName)
ORDER BY 
    GROUPING(DepartmentName), DepartmentName,
    GROUPING(ProjectName), ProjectName;
```

### 📚 For More Advanced Topics

See `Lesson2_Working_with_Grouping_Sets.md` for:
- Complex multi-level hierarchies
- Performance optimization with large datasets
- Combining GROUPING SETS with PIVOT
- Real-world enterprise reporting patterns

---

## 🏆 Module 14 Complete!

Congratulations! You've learned:

1. **PIVOT** - Transform row values into column headers
2. **UNPIVOT** - Transform columns back into rows  
3. **ROLLUP** - Hierarchical subtotals
4. **CUBE** - All aggregation combinations
5. **GROUPING SETS** - Custom aggregation combinations
6. **GROUPING()** - Identify subtotal rows

These are powerful tools for creating professional reports and dashboards!

**Next Module:** Module 15 - Executing Stored Procedures
