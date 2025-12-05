# Lab: Pivoting and Grouping Sets - Beginner Lab

## 🎯 Lab Overview

Welcome to the hands-on lab for Module 14! In this lab, you'll practice:
- **PIVOT** - Transforming rows into columns
- **UNPIVOT** - Transforming columns into rows
- **ROLLUP** - Creating hierarchical subtotals
- **CUBE** - Creating all aggregation combinations
- **GROUPING SETS** - Custom aggregation combinations

**Estimated Time:** 45-60 minutes

---

## 📋 Prerequisites

Before starting this lab, you should:
- Have access to the TechCorpDB database
- Understand basic SELECT, JOIN, and GROUP BY
- Have completed Lessons 1 and 2 of this module

---

## 🗃️ Sample Data Setup

Run these scripts to ensure you have the necessary data for this lab:

```sql
-- Verify you have the required tables
SELECT 'Employees' AS TableName, COUNT(*) AS RowCount FROM Employees
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;
```

If you need sample data, create this temporary table for practice:

```sql
-- Create a sample sales table for this lab
IF OBJECT_ID('TempDB..#SalesData') IS NOT NULL DROP TABLE #SalesData;

CREATE TABLE #SalesData (
    SaleID INT IDENTITY(1,1),
    SalesYear INT,
    Quarter VARCHAR(2),
    Region VARCHAR(20),
    Product VARCHAR(30),
    Amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO #SalesData (SalesYear, Quarter, Region, Product, Amount) VALUES
-- 2023 Data
(2023, 'Q1', 'North', 'Software', 15000),
(2023, 'Q1', 'North', 'Hardware', 12000),
(2023, 'Q1', 'South', 'Software', 18000),
(2023, 'Q1', 'South', 'Hardware', 9000),
(2023, 'Q2', 'North', 'Software', 17000),
(2023, 'Q2', 'North', 'Hardware', 14000),
(2023, 'Q2', 'South', 'Software', 20000),
(2023, 'Q2', 'South', 'Hardware', 11000),
(2023, 'Q3', 'North', 'Software', 16000),
(2023, 'Q3', 'North', 'Hardware', 13000),
(2023, 'Q3', 'South', 'Software', 19000),
(2023, 'Q3', 'South', 'Hardware', 10000),
(2023, 'Q4', 'North', 'Software', 22000),
(2023, 'Q4', 'North', 'Hardware', 16000),
(2023, 'Q4', 'South', 'Software', 25000),
(2023, 'Q4', 'South', 'Hardware', 14000),
-- 2024 Data
(2024, 'Q1', 'North', 'Software', 18000),
(2024, 'Q1', 'North', 'Hardware', 15000),
(2024, 'Q1', 'South', 'Software', 21000),
(2024, 'Q1', 'South', 'Hardware', 12000),
(2024, 'Q2', 'North', 'Software', 20000),
(2024, 'Q2', 'North', 'Hardware', 17000),
(2024, 'Q2', 'South', 'Software', 24000),
(2024, 'Q2', 'South', 'Hardware', 15000);

PRINT 'Sample data created successfully!';
```

---

## 📝 Part 1: PIVOT Exercises

### Exercise 1.1: Basic PIVOT (Easy)

**Goal:** Create a report showing sales by region with quarters as columns.

**Your Task:** Transform this data:
```
Region    Quarter    Amount
North     Q1         15000
North     Q2         17000
South     Q1         18000
South     Q2         20000
```

Into this:
```
Region    Q1        Q2
North     15000     17000
South     18000     20000
```

**Starter Code:**
```sql
SELECT 
    Region,
    _____ AS Q1,
    _____ AS Q2,
    _____ AS Q3,
    _____ AS Q4
FROM #SalesData
WHERE SalesYear = 2023 AND Product = 'Software'
PIVOT (
    _____(_____) 
    FOR _____ IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable;
```

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    Region,
    [Q1], [Q2], [Q3], [Q4]
FROM (
    SELECT Region, Quarter, Amount
    FROM #SalesData
    WHERE SalesYear = 2023 AND Product = 'Software'
) AS SourceData
PIVOT (
    SUM(Amount) 
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable;
```

**Expected Result:**
| Region | Q1    | Q2    | Q3    | Q4    |
|--------|-------|-------|-------|-------|
| North  | 15000 | 17000 | 16000 | 22000 |
| South  | 18000 | 20000 | 19000 | 25000 |

</details>

---

### Exercise 1.2: PIVOT with Employee Data (Medium)

**Goal:** Show employee count by department with job titles as columns.

**Your Task:** Create a report that shows how many employees each department has in each job title category.

**Expected Output Format:**
| Department  | Developer | Manager | Analyst | ... |
|-------------|-----------|---------|---------|-----|
| Engineering | 10        | 2       | 3       | ... |
| Marketing   | 0         | 2       | 4       | ... |

<details>
<summary>💡 Click to see solution</summary>

```sql
-- First, check what job titles exist
SELECT DISTINCT JobTitle FROM Employees;

-- Then create the pivot
SELECT *
FROM (
    SELECT 
        d.DepartmentName,
        e.JobTitle
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
) AS SourceData
PIVOT (
    COUNT(JobTitle) 
    FOR JobTitle IN ([Developer], [Senior Developer], [Manager], [Analyst], [Director])
) AS PivotTable
ORDER BY DepartmentName;
```

</details>

---

### Exercise 1.3: PIVOT Sales by Product (Medium)

**Goal:** Create a yearly comparison showing products as columns.

**Your Task:** Show total sales by region and year, with products as columns.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    SalesYear,
    Region,
    [Software],
    [Hardware],
    [Software] + [Hardware] AS TotalSales
FROM (
    SELECT SalesYear, Region, Product, Amount
    FROM #SalesData
) AS SourceData
PIVOT (
    SUM(Amount) 
    FOR Product IN ([Software], [Hardware])
) AS PivotTable
ORDER BY SalesYear, Region;
```

**Expected Result:**
| SalesYear | Region | Software | Hardware | TotalSales |
|-----------|--------|----------|----------|------------|
| 2023      | North  | 70000    | 55000    | 125000     |
| 2023      | South  | 82000    | 44000    | 126000     |
| 2024      | North  | 38000    | 32000    | 70000      |
| 2024      | South  | 45000    | 27000    | 72000      |

</details>

---

## 📝 Part 2: UNPIVOT Exercises

### Exercise 2.1: Basic UNPIVOT (Easy)

**Goal:** Transform column data back into rows.

**Setup:** Create a table with quarterly data in columns:
```sql
IF OBJECT_ID('TempDB..#QuarterlySales') IS NOT NULL DROP TABLE #QuarterlySales;

CREATE TABLE #QuarterlySales (
    Region VARCHAR(20),
    Q1_Sales DECIMAL(10,2),
    Q2_Sales DECIMAL(10,2),
    Q3_Sales DECIMAL(10,2),
    Q4_Sales DECIMAL(10,2)
);

INSERT INTO #QuarterlySales VALUES
('North', 15000, 17000, 16000, 22000),
('South', 18000, 20000, 19000, 25000);
```

**Your Task:** Transform this into rows:
| Region | Quarter  | Sales |
|--------|----------|-------|
| North  | Q1_Sales | 15000 |
| North  | Q2_Sales | 17000 |
| ...    | ...      | ...   |

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    Region,
    Quarter,
    Sales
FROM #QuarterlySales
UNPIVOT (
    Sales FOR Quarter IN (Q1_Sales, Q2_Sales, Q3_Sales, Q4_Sales)
) AS UnpivotedData
ORDER BY Region, Quarter;
```

**Expected Result:**
| Region | Quarter  | Sales  |
|--------|----------|--------|
| North  | Q1_Sales | 15000  |
| North  | Q2_Sales | 17000  |
| North  | Q3_Sales | 16000  |
| North  | Q4_Sales | 22000  |
| South  | Q1_Sales | 18000  |
| South  | Q2_Sales | 20000  |
| South  | Q3_Sales | 19000  |
| South  | Q4_Sales | 25000  |

</details>

---

### Exercise 2.2: UNPIVOT with Cleanup (Medium)

**Goal:** UNPIVOT the data and clean up the quarter names.

**Your Task:** Transform AND rename Q1_Sales to just Q1, etc.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    Region,
    REPLACE(Quarter, '_Sales', '') AS Quarter,
    Sales
FROM #QuarterlySales
UNPIVOT (
    Sales FOR Quarter IN (Q1_Sales, Q2_Sales, Q3_Sales, Q4_Sales)
) AS UnpivotedData
ORDER BY Region, Quarter;
```

**Expected Result:**
| Region | Quarter | Sales |
|--------|---------|-------|
| North  | Q1      | 15000 |
| North  | Q2      | 17000 |
| ...    | ...     | ...   |

</details>

---

## 📝 Part 3: ROLLUP Exercises

### Exercise 3.1: Simple ROLLUP (Easy)

**Goal:** Create a sales report with subtotals using ROLLUP.

**Your Task:** Show sales by region with a grand total.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    COALESCE(Region, '*** GRAND TOTAL ***') AS Region,
    COUNT(*) AS NumberOfSales,
    SUM(Amount) AS TotalSales
FROM #SalesData
GROUP BY ROLLUP(Region)
ORDER BY GROUPING(Region), Region;
```

**Expected Result:**
| Region          | NumberOfSales | TotalSales |
|-----------------|---------------|------------|
| North           | 12            | 195000     |
| South           | 12            | 206000     |
| *** GRAND TOTAL *** | 24        | 401000     |

</details>

---

### Exercise 3.2: Two-Level ROLLUP (Medium)

**Goal:** Create a hierarchical report with region and product subtotals.

**Your Task:** Show sales by region → product with subtotals at each level.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    COALESCE(Region, '*** ALL REGIONS ***') AS Region,
    COALESCE(Product, '-- Region Total --') AS Product,
    COUNT(*) AS NumberOfSales,
    SUM(Amount) AS TotalSales,
    CASE 
        WHEN GROUPING(Region) = 1 AND GROUPING(Product) = 1 THEN 'Grand Total'
        WHEN GROUPING(Product) = 1 THEN 'Region Subtotal'
        ELSE 'Detail'
    END AS RowType
FROM #SalesData
GROUP BY ROLLUP(Region, Product)
ORDER BY 
    GROUPING(Region), Region,
    GROUPING(Product), Product;
```

**Expected Result:**
| Region          | Product           | NumberOfSales | TotalSales | RowType        |
|-----------------|-------------------|---------------|------------|----------------|
| North           | Hardware          | 6             | 87000      | Detail         |
| North           | Software          | 6             | 108000     | Detail         |
| North           | -- Region Total --| 12            | 195000     | Region Subtotal|
| South           | Hardware          | 6             | 71000      | Detail         |
| South           | Software          | 6             | 135000     | Detail         |
| South           | -- Region Total --| 12            | 206000     | Region Subtotal|
| *** ALL REGIONS ***| -- Region Total --| 24         | 401000     | Grand Total    |

</details>

---

### Exercise 3.3: Three-Level ROLLUP with Employees (Hard)

**Goal:** Create a salary report with department → job title → employee detail.

**Your Task:** Show total salaries with multiple levels of subtotals.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    CASE 
        WHEN GROUPING(d.DepartmentName) = 1 THEN '=== COMPANY TOTAL ==='
        ELSE d.DepartmentName
    END AS Department,
    CASE 
        WHEN GROUPING(d.DepartmentName) = 1 THEN ''
        WHEN GROUPING(e.JobTitle) = 1 THEN '-- Dept Total --'
        ELSE e.JobTitle
    END AS JobTitle,
    COUNT(*) AS EmpCount,
    SUM(e.BaseSalary) AS TotalSalary,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY ROLLUP(d.DepartmentName, e.JobTitle)
ORDER BY 
    GROUPING(d.DepartmentName), d.DepartmentName,
    GROUPING(e.JobTitle), e.JobTitle;
```

</details>

---

## 📝 Part 4: CUBE Exercises

### Exercise 4.1: Simple CUBE (Medium)

**Goal:** Analyze sales with ALL possible combinations.

**Your Task:** Use CUBE to show sales by region, product, and all combinations.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    COALESCE(Region, '** All Regions **') AS Region,
    COALESCE(Product, '** All Products **') AS Product,
    COUNT(*) AS NumberOfSales,
    SUM(Amount) AS TotalSales
FROM #SalesData
WHERE SalesYear = 2023
GROUP BY CUBE(Region, Product)
ORDER BY 
    GROUPING(Region), Region,
    GROUPING(Product), Product;
```

**Expected Result:**
| Region          | Product           | NumberOfSales | TotalSales |
|-----------------|-------------------|---------------|------------|
| North           | Hardware          | 4             | 55000      |
| North           | Software          | 4             | 70000      |
| North           | ** All Products **| 8             | 125000     |
| South           | Hardware          | 4             | 44000      |
| South           | Software          | 4             | 82000      |
| South           | ** All Products **| 8             | 126000     |
| ** All Regions **| Hardware         | 8             | 99000      |
| ** All Regions **| Software         | 8             | 152000     |
| ** All Regions **| ** All Products **| 16           | 251000     |

**Notice:** CUBE gives us:
- Region + Product (detail)
- Region only (product totals)
- Product only (region totals) ← ROLLUP wouldn't give us this!
- Grand total

</details>

---

### Exercise 4.2: CUBE with Employee Data (Hard)

**Goal:** Analyze employee distribution with CUBE.

**Your Task:** Show employee count by department and location with all combinations.

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    COALESCE(d.DepartmentName, '** All Departments **') AS Department,
    COALESCE(d.Location, '** All Locations **') AS Location,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary,
    CASE 
        WHEN GROUPING(d.DepartmentName) = 1 AND GROUPING(d.Location) = 1 
            THEN 'Grand Total'
        WHEN GROUPING(d.DepartmentName) = 1 
            THEN 'Location Total'
        WHEN GROUPING(d.Location) = 1 
            THEN 'Department Total'
        ELSE 'Detail'
    END AS RowType
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY CUBE(d.DepartmentName, d.Location)
ORDER BY 
    GROUPING(d.DepartmentName) + GROUPING(d.Location),
    d.DepartmentName, d.Location;
```

</details>

---

## 📝 Part 5: GROUPING SETS Exercises

### Exercise 5.1: Custom GROUPING SETS (Medium)

**Goal:** Create a report with ONLY the groupings you need.

**Your Task:** Create a report that shows:
1. Sales by Region (not by product)
2. Sales by Product (not by region)
3. Grand total

**NOT wanted:** Sales by Region AND Product together

<details>
<summary>💡 Click to see solution</summary>

```sql
SELECT 
    CASE WHEN GROUPING(Region) = 0 THEN Region ELSE NULL END AS Region,
    CASE WHEN GROUPING(Product) = 0 THEN Product ELSE NULL END AS Product,
    SUM(Amount) AS TotalSales,
    CASE 
        WHEN GROUPING(Region) = 0 THEN 'By Region'
        WHEN GROUPING(Product) = 0 THEN 'By Product'
        ELSE 'Grand Total'
    END AS GroupingType
FROM #SalesData
GROUP BY GROUPING SETS (
    (Region),    -- By region only
    (Product),   -- By product only
    ()           -- Grand total
)
ORDER BY GroupingType;
```

**Expected Result:**
| Region | Product  | TotalSales | GroupingType |
|--------|----------|------------|--------------|
| North  | NULL     | 195000     | By Region    |
| South  | NULL     | 206000     | By Region    |
| NULL   | Hardware | 158000     | By Product   |
| NULL   | Software | 243000     | By Product   |
| NULL   | NULL     | 401000     | Grand Total  |

</details>

---

### Exercise 5.2: Matching ROLLUP with GROUPING SETS (Hard)

**Goal:** Prove that ROLLUP is equivalent to specific GROUPING SETS.

**Your Task:** Write two queries that produce the same result:
1. Using ROLLUP(Region, Product)
2. Using GROUPING SETS to match ROLLUP behavior

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Query 1: Using ROLLUP
SELECT 
    COALESCE(Region, 'ALL') AS Region,
    COALESCE(Product, 'ALL') AS Product,
    SUM(Amount) AS Sales,
    'ROLLUP' AS Method
FROM #SalesData
GROUP BY ROLLUP(Region, Product);

-- Query 2: Using GROUPING SETS (equivalent to ROLLUP)
SELECT 
    COALESCE(Region, 'ALL') AS Region,
    COALESCE(Product, 'ALL') AS Product,
    SUM(Amount) AS Sales,
    'GROUPING SETS' AS Method
FROM #SalesData
GROUP BY GROUPING SETS (
    (Region, Product),  -- Detail level
    (Region),           -- Subtotal by region
    ()                  -- Grand total
);

-- They produce the same result!
-- ROLLUP(A, B) = GROUPING SETS ((A, B), (A), ())
```

</details>

---

### Exercise 5.3: Matching CUBE with GROUPING SETS (Hard)

**Goal:** Prove that CUBE is equivalent to specific GROUPING SETS.

**Your Task:** Write GROUPING SETS that produces the same result as CUBE(Region, Product).

<details>
<summary>💡 Click to see solution</summary>

```sql
-- CUBE(A, B) = GROUPING SETS ((A, B), (A), (B), ())

SELECT 
    COALESCE(Region, 'ALL') AS Region,
    COALESCE(Product, 'ALL') AS Product,
    SUM(Amount) AS Sales
FROM #SalesData
GROUP BY GROUPING SETS (
    (Region, Product),  -- Both (detail)
    (Region),           -- Region only
    (Product),          -- Product only
    ()                  -- Grand total
)
ORDER BY GROUPING(Region), Region, GROUPING(Product), Product;
```

</details>

---

## 📝 Part 6: Comprehensive Challenge

### Challenge: Complete Sales Dashboard Report

**Goal:** Create a comprehensive sales dashboard using multiple techniques.

**Requirements:**
1. Use PIVOT to show quarterly sales by region
2. Include a ROLLUP for subtotals
3. Add meaningful labels for subtotal rows
4. Calculate percentage of grand total

<details>
<summary>💡 Click to see solution</summary>

```sql
-- Step 1: Create the pivoted data with rollup
WITH SalesSummary AS (
    SELECT 
        COALESCE(Region, '=== TOTAL ===') AS Region,
        COALESCE(SalesYear, 9999) AS SalesYear,
        SUM(Amount) AS TotalSales
    FROM #SalesData
    GROUP BY ROLLUP(Region, SalesYear)
)
SELECT 
    Region,
    [2023] AS Year2023,
    [2024] AS Year2024,
    COALESCE([2023], 0) + COALESCE([2024], 0) AS TotalAllYears,
    CAST(100.0 * (COALESCE([2023], 0) + COALESCE([2024], 0)) / 
        (SELECT SUM(Amount) FROM #SalesData) AS DECIMAL(5,1)) AS PercentOfTotal
FROM SalesSummary
PIVOT (
    SUM(TotalSales) FOR SalesYear IN ([2023], [2024])
) AS PivotTable
WHERE Region != '=== TOTAL ===' OR [2023] IS NOT NULL
ORDER BY 
    CASE WHEN Region = '=== TOTAL ===' THEN 2 ELSE 1 END,
    Region;
```

**Alternative: Combined approach with GROUPING SETS:**
```sql
SELECT 
    CASE 
        WHEN GROUPING(Region) = 1 THEN '=== GRAND TOTAL ==='
        ELSE Region
    END AS Region,
    CASE 
        WHEN GROUPING(SalesYear) = 1 THEN 'All Years'
        ELSE CAST(SalesYear AS VARCHAR)
    END AS Year,
    CASE 
        WHEN GROUPING(Quarter) = 1 THEN 'All Quarters'
        ELSE Quarter
    END AS Quarter,
    COUNT(*) AS TransactionCount,
    SUM(Amount) AS TotalSales,
    AVG(Amount) AS AvgSale
FROM #SalesData
GROUP BY GROUPING SETS (
    (Region, SalesYear, Quarter),   -- Full detail
    (Region, SalesYear),            -- Region-Year subtotal
    (Region),                       -- Region subtotal
    ()                              -- Grand total
)
ORDER BY 
    GROUPING(Region), Region,
    GROUPING(SalesYear), SalesYear,
    GROUPING(Quarter), Quarter;
```

</details>

---

## 🎯 Lab Summary

### What You Practiced:

| Technique | What It Does | When to Use |
|-----------|--------------|-------------|
| **PIVOT** | Rows → Columns | Cross-tab reports, dashboards |
| **UNPIVOT** | Columns → Rows | Normalizing wide data |
| **ROLLUP** | Hierarchical subtotals | Drill-down reports |
| **CUBE** | All combinations | Multi-dimensional analysis |
| **GROUPING SETS** | Custom combinations | Specific report needs |
| **GROUPING()** | Identify subtotal rows | Better labels, filtering |

### Key Syntax Patterns:

```sql
-- PIVOT
SELECT * FROM data PIVOT (AGG(val) FOR col IN ([v1],[v2])) AS p;

-- UNPIVOT  
SELECT * FROM data UNPIVOT (val FOR col IN (c1,c2,c3)) AS u;

-- ROLLUP (hierarchical)
GROUP BY ROLLUP(a, b, c)

-- CUBE (all combinations)
GROUP BY CUBE(a, b)

-- GROUPING SETS (custom)
GROUP BY GROUPING SETS ((a,b), (a), (b), ())
```

---

## 🧹 Cleanup

When you're done, clean up the temporary tables:

```sql
IF OBJECT_ID('TempDB..#SalesData') IS NOT NULL DROP TABLE #SalesData;
IF OBJECT_ID('TempDB..#QuarterlySales') IS NOT NULL DROP TABLE #QuarterlySales;
PRINT 'Cleanup complete!';
```

---

## 🏆 Congratulations!

You've completed the Pivoting and Grouping Sets Lab! You now know how to:
- ✅ Transform data between rows and columns
- ✅ Create professional reports with subtotals
- ✅ Analyze data from multiple dimensions
- ✅ Choose the right technique for each situation

**Next Lab:** Module 15 - Executing Stored Procedures
