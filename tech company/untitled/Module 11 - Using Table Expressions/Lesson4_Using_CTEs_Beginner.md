# Lesson 4: Using CTEs (Common Table Expressions) - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome to the final lesson on Table Expressions! **CTEs (Common Table Expressions)** are one of the most useful features in modern SQL. They make complex queries readable, maintainable, and easy to understand.

---

## 📖 What is a CTE? (The Simple Explanation)

### Real-World Analogy: Named Steps

Imagine explaining a recipe:

**Hard to follow (all in one sentence):**
"Mix the result of combining flour, sugar, and butter with the result of beating eggs with vanilla, then bake at 350°F."

**Easy to follow (named steps):**
```
Step 1 - DryMix:      Combine flour, sugar, and butter
Step 2 - WetMix:      Beat eggs with vanilla  
Step 3 - Batter:      Mix DryMix and WetMix together
Step 4 - Final:       Bake at 350°F
```

**CTEs work the same way** - you name each step of your query!

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT IS A CTE?                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CTE = A named, temporary result set                            │
│                                                                 │
│  WITHOUT CTE (Hard to read):                                    │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT * FROM (                            │                │
│  │    SELECT * FROM (                          │                │
│  │      SELECT DeptID, COUNT(*) ...            │  Nested mess!  │
│  │    ) AS Inner1                              │                │
│  │  ) AS Inner2                                │                │
│  │  WHERE ...                                  │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  WITH CTE (Easy to read):                                       │
│  ┌─────────────────────────────────────────────┐                │
│  │  WITH DeptCounts AS (                       │ ← Name step 1  │
│  │    SELECT DeptID, COUNT(*) AS EmpCount      │                │
│  │    FROM Employees GROUP BY DeptID           │                │
│  │  )                                          │                │
│  │  SELECT * FROM DeptCounts                   │ ← Use step 1   │
│  │  WHERE EmpCount > 5;                        │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Benefits of CTEs

| Benefit | Description |
|---------|-------------|
| **Readability** | Break complex queries into named, understandable steps |
| **Reusability** | Reference the same CTE multiple times in one query |
| **Recursion** | Can reference itself for hierarchical data (advanced) |
| **Maintainability** | Easier to modify and debug |
| **No Side Effects** | Exists only for the duration of the query |

---

## 🎓 Part 1: Your First CTE

### The Basic Syntax

```sql
WITH cte_name AS (
    -- Your SELECT query here
    SELECT columns
    FROM tables
    WHERE conditions
)
SELECT columns
FROM cte_name
WHERE conditions;
```

### Example 1.1: Department Employee Counts

**Task:** Find departments with more than 5 employees.

```sql
-- Step 1: Define the CTE
WITH DepartmentCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
)
-- Step 2: Use the CTE
SELECT 
    d.DepartmentName,
    dc.EmployeeCount
FROM DepartmentCounts dc
INNER JOIN Departments d ON dc.DepartmentID = d.DepartmentID
WHERE dc.EmployeeCount > 5
ORDER BY dc.EmployeeCount DESC;
```

**Expected Result:**
| DepartmentName | EmployeeCount |
|----------------|---------------|
| Engineering    | 25            |
| Sales          | 18            |
| Marketing      | 12            |

---

### Example 1.2: Salary Analysis with CTE

**Task:** Show employees with their department's average salary.

```sql
-- Define what we need first
WITH DepartmentAverages AS (
    SELECT 
        DepartmentID,
        AVG(BaseSalary) AS AvgSalary
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
)
-- Now use it
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    da.AvgSalary AS DepartmentAverage,
    e.BaseSalary - da.AvgSalary AS DifferenceFromAvg
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN DepartmentAverages da ON e.DepartmentID = da.DepartmentID
WHERE e.IsActive = 1
ORDER BY DifferenceFromAvg DESC;
```

---

## 🎓 Part 2: Multiple CTEs

You can define multiple CTEs separated by commas!

### Example 2.1: Department and Company Statistics

**Task:** Compare each department's average to the company average.

```sql
WITH 
-- First CTE: Department averages
DepartmentStats AS (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
),
-- Second CTE: Company average
CompanyStats AS (
    SELECT 
        AVG(BaseSalary) AS CompanyAvgSalary,
        COUNT(*) AS TotalEmployees
    FROM Employees
    WHERE IsActive = 1
)
-- Use both CTEs
SELECT 
    ds.DepartmentName,
    ds.EmployeeCount,
    ds.AvgSalary AS DeptAvgSalary,
    cs.CompanyAvgSalary,
    ds.AvgSalary - cs.CompanyAvgSalary AS DifferenceFromCompanyAvg,
    CASE 
        WHEN ds.AvgSalary > cs.CompanyAvgSalary THEN 'Above Average'
        WHEN ds.AvgSalary < cs.CompanyAvgSalary THEN 'Below Average'
        ELSE 'At Average'
    END AS Status
FROM DepartmentStats ds
CROSS JOIN CompanyStats cs
ORDER BY DifferenceFromCompanyAvg DESC;
```

**Expected Result:**
| DepartmentName | EmployeeCount | DeptAvgSalary | CompanyAvgSalary | DifferenceFromCompanyAvg | Status        |
|----------------|---------------|---------------|------------------|-------------------------|---------------|
| Engineering    | 25            | 92000.00      | 72500.00         | 19500.00                | Above Average |
| Sales          | 18            | 78000.00      | 72500.00         | 5500.00                 | Above Average |
| Marketing      | 12            | 68000.00      | 72500.00         | -4500.00                | Below Average |

---

### Example 2.2: Order Analysis with Multiple CTEs

```sql
WITH 
-- Customer order summaries
CustomerOrders AS (
    SELECT 
        CustomerID,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS TotalSpent,
        AVG(TotalAmount) AS AvgOrderValue
    FROM Orders
    GROUP BY CustomerID
),
-- Company-wide order statistics
CompanyOrderStats AS (
    SELECT 
        AVG(TotalAmount) AS AvgOrderAmount,
        COUNT(*) AS TotalOrders
    FROM Orders
),
-- Identify VIP customers (above average)
VIPCustomers AS (
    SELECT CustomerID
    FROM CustomerOrders
    WHERE TotalSpent > (SELECT AVG(TotalSpent) FROM CustomerOrders)
)
-- Final query combining everything
SELECT 
    c.CustomerName,
    co.OrderCount,
    co.TotalSpent,
    co.AvgOrderValue,
    cos.AvgOrderAmount AS CompanyAvgOrder,
    CASE WHEN vc.CustomerID IS NOT NULL THEN 'VIP' ELSE 'Regular' END AS CustomerStatus
FROM CustomerOrders co
INNER JOIN Customers c ON co.CustomerID = c.CustomerID
CROSS JOIN CompanyOrderStats cos
LEFT JOIN VIPCustomers vc ON co.CustomerID = vc.CustomerID
ORDER BY co.TotalSpent DESC;
```

---

## 🎓 Part 3: CTEs Can Reference Each Other

Later CTEs can use earlier CTEs!

### Example 3.1: Progressive Filtering

```sql
WITH 
-- Step 1: Get all active employees with department info
ActiveEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        e.DepartmentID,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
),
-- Step 2: Calculate department averages (uses Step 1!)
DeptAverages AS (
    SELECT 
        DepartmentID,
        AVG(BaseSalary) AS AvgSalary
    FROM ActiveEmployees
    GROUP BY DepartmentID
),
-- Step 3: Find above-average employees (uses Steps 1 & 2!)
AboveAverageEmployees AS (
    SELECT 
        ae.*,
        da.AvgSalary AS DeptAvgSalary
    FROM ActiveEmployees ae
    INNER JOIN DeptAverages da ON ae.DepartmentID = da.DepartmentID
    WHERE ae.BaseSalary > da.AvgSalary
)
-- Final result from Step 3
SELECT 
    FirstName,
    LastName,
    DepartmentName,
    BaseSalary,
    DeptAvgSalary,
    BaseSalary - DeptAvgSalary AS AboveAvgBy
FROM AboveAverageEmployees
ORDER BY AboveAvgBy DESC;
```

---

## 🎓 Part 4: Reusing CTEs Multiple Times

A major advantage of CTEs is using them multiple times in one query!

### Example 4.1: Self-Comparison with CTE

**Task:** For each department, show the highest and lowest paid employee.

```sql
WITH RankedSalaries AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        d.DepartmentName,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.BaseSalary DESC) AS HighRank,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.BaseSalary ASC) AS LowRank
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
)
-- Use the CTE TWICE - once for highest, once for lowest
SELECT 
    high.DepartmentName,
    high.FirstName AS HighestPaid_FirstName,
    high.LastName AS HighestPaid_LastName,
    high.BaseSalary AS HighestSalary,
    low.FirstName AS LowestPaid_FirstName,
    low.LastName AS LowestPaid_LastName,
    low.BaseSalary AS LowestSalary,
    high.BaseSalary - low.BaseSalary AS SalaryRange
FROM RankedSalaries high
INNER JOIN RankedSalaries low ON high.DepartmentName = low.DepartmentName
WHERE high.HighRank = 1 AND low.LowRank = 1
ORDER BY SalaryRange DESC;
```

---

## 📊 Visual: CTE vs Derived Table

```
┌─────────────────────────────────────────────────────────────────┐
│              CTE vs DERIVED TABLE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  DERIVED TABLE:                                                 │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT *                                   │                │
│  │  FROM (                                     │  Definition    │
│  │      SELECT DeptID, COUNT(*) AS Cnt         │  is INSIDE     │
│  │      FROM Employees                         │  the query     │
│  │      GROUP BY DeptID                        │                │
│  │  ) AS DeptCounts        ← Must be inline    │                │
│  │  WHERE Cnt > 5;                             │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  CTE:                                                           │
│  ┌─────────────────────────────────────────────┐                │
│  │  WITH DeptCounts AS (   ← Definition first  │                │
│  │      SELECT DeptID, COUNT(*) AS Cnt         │                │
│  │      FROM Employees                         │                │
│  │      GROUP BY DeptID                        │                │
│  │  )                      ← Clearly separated │                │
│  │  SELECT *                                   │                │
│  │  FROM DeptCounts                            │                │
│  │  WHERE Cnt > 5;                             │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  💡 CTEs are more readable, especially for complex queries!     │
│                                                                 │
│  ┌─────────────────────────────────────────────┐                │
│  │ Use CTE when:                               │                │
│  │ • Query is complex                          │                │
│  │ • Need to reference same subquery twice     │                │
│  │ • Want self-documenting code                │                │
│  │                                             │                │
│  │ Derived tables OK when:                     │                │
│  │ • Simple, one-time subquery                 │                │
│  │ • Short query                               │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Part 5: Real-World Business Examples

### Example 5.1: Sales Performance Report

```sql
WITH 
-- Monthly sales by customer
MonthlySales AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(o.TotalAmount) AS MonthlyTotal
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName, YEAR(o.OrderDate), MONTH(o.OrderDate)
),
-- Customer rankings
CustomerRankings AS (
    SELECT 
        CustomerID,
        CustomerName,
        SUM(MonthlyTotal) AS TotalSales,
        RANK() OVER (ORDER BY SUM(MonthlyTotal) DESC) AS SalesRank
    FROM MonthlySales
    GROUP BY CustomerID, CustomerName
)
SELECT 
    SalesRank,
    CustomerName,
    TotalSales,
    CASE 
        WHEN SalesRank <= 3 THEN 'Gold'
        WHEN SalesRank <= 10 THEN 'Silver'
        ELSE 'Bronze'
    END AS CustomerTier
FROM CustomerRankings
WHERE SalesRank <= 20
ORDER BY SalesRank;
```

---

### Example 5.2: Employee Tenure Analysis

```sql
WITH 
-- Calculate tenure for each employee
EmployeeTenure AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.HireDate,
        d.DepartmentName,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
),
-- Categorize by tenure
TenureCategories AS (
    SELECT 
        *,
        CASE 
            WHEN YearsOfService < 2 THEN 'New (0-2 years)'
            WHEN YearsOfService < 5 THEN 'Developing (2-5 years)'
            WHEN YearsOfService < 10 THEN 'Experienced (5-10 years)'
            ELSE 'Veteran (10+ years)'
        END AS TenureCategory
    FROM EmployeeTenure
)
-- Summary by category
SELECT 
    TenureCategory,
    COUNT(*) AS EmployeeCount,
    AVG(BaseSalary) AS AvgSalary,
    MIN(BaseSalary) AS MinSalary,
    MAX(BaseSalary) AS MaxSalary
FROM TenureCategories
GROUP BY TenureCategory
ORDER BY 
    CASE TenureCategory
        WHEN 'New (0-2 years)' THEN 1
        WHEN 'Developing (2-5 years)' THEN 2
        WHEN 'Experienced (5-10 years)' THEN 3
        ELSE 4
    END;
```

---

## ✅ Practice Exercises

### Exercise 1: High-Value Customers (Easy)

Use a CTE to find customers who have spent more than $10,000 total.

```sql
-- Your answer:
WITH CustomerTotals AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT 
    CustomerName,
    TotalSpent
FROM CustomerTotals
WHERE TotalSpent > 10000
ORDER BY TotalSpent DESC;
```

### Exercise 2: Department Rankings (Medium)

Use CTEs to rank departments by average salary.

```sql
-- Your answer:
WITH DeptSalaries AS (
    SELECT 
        d.DepartmentName,
        AVG(e.BaseSalary) AS AvgSalary,
        COUNT(e.EmployeeID) AS EmployeeCount
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
)
SELECT 
    DepartmentName,
    AvgSalary,
    EmployeeCount,
    RANK() OVER (ORDER BY AvgSalary DESC) AS SalaryRank
FROM DeptSalaries
ORDER BY SalaryRank;
```

### Exercise 3: Year-Over-Year Comparison (Challenging)

Use multiple CTEs to compare this year's orders to last year's.

```sql
-- Your answer:
WITH 
ThisYearOrders AS (
    SELECT 
        c.CustomerName,
        SUM(o.TotalAmount) AS ThisYearTotal
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.OrderDate) = YEAR(GETDATE())
    GROUP BY c.CustomerID, c.CustomerName
),
LastYearOrders AS (
    SELECT 
        c.CustomerName,
        SUM(o.TotalAmount) AS LastYearTotal
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.OrderDate) = YEAR(GETDATE()) - 1
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT 
    COALESCE(t.CustomerName, l.CustomerName) AS CustomerName,
    ISNULL(l.LastYearTotal, 0) AS LastYearTotal,
    ISNULL(t.ThisYearTotal, 0) AS ThisYearTotal,
    ISNULL(t.ThisYearTotal, 0) - ISNULL(l.LastYearTotal, 0) AS YoYChange
FROM ThisYearOrders t
FULL OUTER JOIN LastYearOrders l ON t.CustomerName = l.CustomerName
ORDER BY YoYChange DESC;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ CTEs start with WITH keyword                                │
│     WITH cte_name AS (SELECT ...)                               │
│                                                                 │
│  ✅ Multiple CTEs separated by commas                           │
│     WITH CTE1 AS (...), CTE2 AS (...)                          │
│                                                                 │
│  ✅ CTEs can reference earlier CTEs                             │
│                                                                 │
│  ✅ Same CTE can be used multiple times in the main query       │
│                                                                 │
│  ✅ CTEs make complex queries readable and maintainable         │
│                                                                 │
│  ✅ CTEs only exist for the duration of the query               │
│                                                                 │
│  ✅ Prefer CTEs over nested derived tables for readability      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🏆 Module 11 Complete!

Congratulations! You've completed all four lessons on Table Expressions:

1. **Views** - Saved queries that act like virtual tables
2. **Inline TVFs** - Parameterized views (functions returning tables)
3. **Derived Tables** - Subqueries in the FROM clause
4. **CTEs** - Named, readable temporary result sets

**When to use each:**

| Situation | Best Choice |
|-----------|-------------|
| Reuse query across sessions | VIEW |
| Need parameters | Inline TVF |
| One-time subquery (simple) | Derived Table |
| Complex query, need readability | CTE |
| Reference same subquery twice | CTE |

**Next Module:** Module 14 - Pivoting and Grouping Sets
