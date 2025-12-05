# Lesson 3: Using Derived Tables - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! In this lesson, you'll learn about **Derived Tables** - a way to use a subquery as a temporary table within a single query. Think of it as creating a mini-table on the fly!

---

## 📖 What is a Derived Table? (The Simple Explanation)

### Real-World Analogy: The Scratch Paper

When solving a complex math problem, you might:
1. Calculate something on scratch paper first
2. Use that result in your final calculation

**Derived Tables work the same way:**
1. Write a subquery that creates intermediate results
2. Use those results as if they were a real table

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT IS A DERIVED TABLE?                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  A Derived Table is a subquery in the FROM clause.              │
│                                                                 │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT *                                   │                │
│  │  FROM (                                     │                │
│  │      SELECT DepartmentID,                   │  ◄── This is   │
│  │             COUNT(*) AS EmpCount            │      the       │
│  │      FROM Employees                         │      derived   │
│  │      GROUP BY DepartmentID                  │      table     │
│  │  ) AS DeptSummary                           │                │
│  │  WHERE EmpCount > 5;                        │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  The subquery creates a "temporary table" called DeptSummary    │
│  that only exists during this query.                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Characteristics of Derived Tables

| Feature | Description |
|---------|-------------|
| **Location** | Always in the FROM clause |
| **Alias Required** | MUST have an alias (name) |
| **Temporary** | Only exists during the query |
| **Not Stored** | Nothing saved to database |
| **Inline** | Defined right in the query |

---

## 🎓 Part 1: Creating Your First Derived Table

### The Basic Syntax

```sql
SELECT columns
FROM (
    -- This is the derived table (a subquery)
    SELECT columns
    FROM tables
    WHERE conditions
    GROUP BY columns
) AS alias_name    -- MUST give it a name!
WHERE conditions_on_derived_table;
```

### Example 1.1: Department Employee Counts

**Task:** Find departments with more than 5 employees.

**Why use a derived table?** We need to:
1. First: COUNT employees per department
2. Then: Filter to show only departments with count > 5

```sql
-- The derived table calculates counts
-- The outer query filters on those counts

SELECT 
    DeptStats.DepartmentID,
    DeptStats.EmployeeCount
FROM (
    -- This subquery becomes our derived table
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
) AS DeptStats    -- Name it "DeptStats"
WHERE DeptStats.EmployeeCount > 5
ORDER BY DeptStats.EmployeeCount DESC;
```

**Expected Result:**
| DepartmentID | EmployeeCount |
|--------------|---------------|
| 1            | 25            |
| 3            | 18            |
| 2            | 12            |

---

### Example 1.2: Adding Department Names

**Task:** Same as above, but include department names.

```sql
SELECT 
    d.DepartmentName,
    DeptStats.EmployeeCount,
    d.Budget
FROM (
    SELECT 
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
) AS DeptStats
-- Join the derived table with Departments table
INNER JOIN Departments d ON DeptStats.DepartmentID = d.DepartmentID
WHERE DeptStats.EmployeeCount > 5
ORDER BY DeptStats.EmployeeCount DESC;
```

**Expected Result:**
| DepartmentName | EmployeeCount | Budget      |
|----------------|---------------|-------------|
| Engineering    | 25            | 1200000.00  |
| Sales          | 18            | 800000.00   |
| Marketing      | 12            | 500000.00   |

---

## 🎓 Part 2: Calculating Summary Statistics

### Example 2.1: Salary Statistics by Department

**Task:** Show each department's salary statistics alongside company averages.

```sql
SELECT 
    DeptSalary.DepartmentName,
    DeptSalary.AvgSalary AS DepartmentAvgSalary,
    CompanyStats.CompanyAvgSalary,
    DeptSalary.AvgSalary - CompanyStats.CompanyAvgSalary AS DifferenceFromCompanyAvg
FROM (
    -- First derived table: Department averages
    SELECT 
        d.DepartmentName,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) AS DeptSalary
CROSS JOIN (
    -- Second derived table: Company-wide average
    SELECT AVG(BaseSalary) AS CompanyAvgSalary
    FROM Employees
    WHERE IsActive = 1
) AS CompanyStats
ORDER BY DeptSalary.AvgSalary DESC;
```

**Expected Result:**
| DepartmentName | DepartmentAvgSalary | CompanyAvgSalary | DifferenceFromCompanyAvg |
|----------------|---------------------|------------------|-------------------------|
| Engineering    | 92000.00            | 72500.00         | 19500.00                |
| Sales          | 78000.00            | 72500.00         | 5500.00                 |
| Marketing      | 68000.00            | 72500.00         | -4500.00                |

---

### Example 2.2: Order Analysis

**Task:** Find customers whose average order exceeds the company average order.

```sql
SELECT 
    CustomerAvgs.CustomerName,
    CustomerAvgs.OrderCount,
    CustomerAvgs.AvgOrderAmount,
    CompanyAvg.CompanyAvgOrder
FROM (
    -- Customer averages
    SELECT 
        c.CustomerName,
        COUNT(o.OrderID) AS OrderCount,
        AVG(o.TotalAmount) AS AvgOrderAmount
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
    GROUP BY c.CustomerID, c.CustomerName
) AS CustomerAvgs
CROSS JOIN (
    -- Company average
    SELECT AVG(TotalAmount) AS CompanyAvgOrder
    FROM Orders
) AS CompanyAvg
WHERE CustomerAvgs.AvgOrderAmount > CompanyAvg.CompanyAvgOrder
ORDER BY CustomerAvgs.AvgOrderAmount DESC;
```

---

## 🎓 Part 3: Filtering Aggregated Data

### Example 3.1: Top Performing Employees per Department

**Task:** Find the top 3 highest-paid employees in each department using derived tables.

```sql
SELECT 
    RankedEmployees.DepartmentName,
    RankedEmployees.FirstName,
    RankedEmployees.LastName,
    RankedEmployees.BaseSalary,
    RankedEmployees.SalaryRank
FROM (
    -- Derived table that adds ranking
    SELECT 
        d.DepartmentName,
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        ROW_NUMBER() OVER (
            PARTITION BY e.DepartmentID 
            ORDER BY e.BaseSalary DESC
        ) AS SalaryRank
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
) AS RankedEmployees
WHERE RankedEmployees.SalaryRank <= 3
ORDER BY RankedEmployees.DepartmentName, RankedEmployees.SalaryRank;
```

**Expected Result:**
| DepartmentName | FirstName | LastName | BaseSalary | SalaryRank |
|----------------|-----------|----------|------------|------------|
| Engineering    | Sarah     | Johnson  | 125000.00  | 1          |
| Engineering    | Michael   | Chen     | 98000.00   | 2          |
| Engineering    | Emily     | Davis    | 85000.00   | 3          |
| Marketing      | Lisa      | Brown    | 82000.00   | 1          |
| Marketing      | James     | Wilson   | 75000.00   | 2          |
| Marketing      | Amy       | Lee      | 68000.00   | 3          |

---

### Example 3.2: Projects Above Average Budget

**Task:** Find projects with budgets above the average for their manager's department.

```sql
SELECT 
    ProjectBudgets.ProjectName,
    ProjectBudgets.ProjectBudget,
    ProjectBudgets.DepartmentName,
    DeptAvg.AvgDeptProjectBudget,
    ProjectBudgets.ProjectBudget - DeptAvg.AvgDeptProjectBudget AS AboveAverage
FROM (
    -- Projects with department info
    SELECT 
        p.ProjectID,
        p.ProjectName,
        p.Budget AS ProjectBudget,
        pm.DepartmentID,
        d.DepartmentName
    FROM Projects p
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    INNER JOIN Departments d ON pm.DepartmentID = d.DepartmentID
) AS ProjectBudgets
INNER JOIN (
    -- Average project budget by department
    SELECT 
        pm.DepartmentID,
        AVG(p.Budget) AS AvgDeptProjectBudget
    FROM Projects p
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    GROUP BY pm.DepartmentID
) AS DeptAvg ON ProjectBudgets.DepartmentID = DeptAvg.DepartmentID
WHERE ProjectBudgets.ProjectBudget > DeptAvg.AvgDeptProjectBudget
ORDER BY AboveAverage DESC;
```

---

## 📊 Visual: Derived Table Execution

```
┌─────────────────────────────────────────────────────────────────┐
│             HOW DERIVED TABLES ARE PROCESSED                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Query:                                                         │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT DeptStats.DepartmentID,             │                │
│  │         DeptStats.EmployeeCount             │                │
│  │  FROM (                                     │                │
│  │      SELECT DepartmentID,                   │ ──┐            │
│  │             COUNT(*) AS EmployeeCount       │   │            │
│  │      FROM Employees                         │   │ Step 1:    │
│  │      GROUP BY DepartmentID                  │   │ Execute    │
│  │  ) AS DeptStats                             │ ──┘ inner      │
│  │  WHERE EmployeeCount > 5;                   │      query     │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  Execution:                                                     │
│                                                                 │
│  Step 1: Run inner query         Step 2: Use results           │
│  ┌───────────────────────┐       ┌───────────────────────┐      │
│  │ DeptID │ EmpCount     │       │ Query this result     │      │
│  ├────────┼──────────────┤   →   │ as if it were a       │      │
│  │ 1      │ 25           │       │ real table called     │      │
│  │ 2      │ 12           │       │ "DeptStats"           │      │
│  │ 3      │ 18           │       │                       │      │
│  │ 4      │ 3            │       │ Filter: EmpCount > 5  │      │
│  └───────────────────────┘       └───────────────────────┘      │
│                                                                 │
│  Final Result:                                                  │
│  ┌───────────────────────┐                                      │
│  │ DeptID │ EmpCount     │                                      │
│  ├────────┼──────────────┤                                      │
│  │ 1      │ 25           │  (Dept 4 filtered out!)              │
│  │ 2      │ 12           │                                      │
│  │ 3      │ 18           │                                      │
│  └───────────────────────┘                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Part 4: Multiple Derived Tables

You can use more than one derived table in a single query:

```sql
SELECT 
    DeptStats.DepartmentName,
    DeptStats.EmployeeCount,
    DeptStats.AvgSalary,
    ProjectStats.ProjectCount,
    ProjectStats.TotalProjectBudget
FROM (
    -- First derived table: Employee statistics
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) AS DeptStats
LEFT JOIN (
    -- Second derived table: Project statistics
    SELECT 
        pm.DepartmentID,
        COUNT(p.ProjectID) AS ProjectCount,
        SUM(p.Budget) AS TotalProjectBudget
    FROM Projects p
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    GROUP BY pm.DepartmentID
) AS ProjectStats ON DeptStats.DepartmentID = ProjectStats.DepartmentID
ORDER BY DeptStats.EmployeeCount DESC;
```

---

## ⚠️ Important Rules for Derived Tables

### Rule 1: MUST Have an Alias

```sql
-- ❌ ERROR: No alias
SELECT * FROM (SELECT DepartmentID, COUNT(*) FROM Employees GROUP BY DepartmentID);

-- ✅ CORRECT: Has alias
SELECT * FROM (SELECT DepartmentID, COUNT(*) AS Cnt FROM Employees GROUP BY DepartmentID) AS DeptCounts;
```

### Rule 2: Column Aliases for Expressions

```sql
-- ❌ ERROR: COUNT(*) has no name
SELECT x.DepartmentID, x.??? FROM (...) AS x;

-- ✅ CORRECT: Named columns
SELECT x.DepartmentID, x.EmpCount 
FROM (SELECT DepartmentID, COUNT(*) AS EmpCount FROM Employees GROUP BY DepartmentID) AS x;
```

### Rule 3: Scope is Limited

Derived tables only exist within the query where they're defined - you can't reference them elsewhere.

---

## ✅ Practice Exercises

### Exercise 1: Department with Most Employees (Easy)

Find the department that has the most employees.

```sql
-- Your answer:
SELECT TOP 1
    DeptCounts.DepartmentID,
    d.DepartmentName,
    DeptCounts.EmployeeCount
FROM (
    SELECT DepartmentID, COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
) AS DeptCounts
INNER JOIN Departments d ON DeptCounts.DepartmentID = d.DepartmentID
ORDER BY DeptCounts.EmployeeCount DESC;
```

### Exercise 2: Above Average Salaries (Medium)

List employees who earn more than their department's average salary.

```sql
-- Your answer:
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    DeptAvg.DepartmentName,
    DeptAvg.AvgSalary AS DeptAverageSalary
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
ORDER BY e.BaseSalary - DeptAvg.AvgSalary DESC;
```

### Exercise 3: Customer Order Summary (Medium)

Show each customer with their order count and average order value.

```sql
-- Your answer:
SELECT 
    c.CustomerName,
    ISNULL(OrderStats.OrderCount, 0) AS OrderCount,
    ISNULL(OrderStats.AvgOrderValue, 0) AS AvgOrderValue,
    ISNULL(OrderStats.TotalSpent, 0) AS TotalSpent
FROM Customers c
LEFT JOIN (
    SELECT 
        CustomerID,
        COUNT(*) AS OrderCount,
        AVG(TotalAmount) AS AvgOrderValue,
        SUM(TotalAmount) AS TotalSpent
    FROM Orders
    GROUP BY CustomerID
) AS OrderStats ON c.CustomerID = OrderStats.CustomerID
WHERE c.IsActive = 1
ORDER BY TotalSpent DESC;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Derived tables are subqueries in the FROM clause            │
│                                                                 │
│  ✅ They MUST have an alias: FROM (...) AS alias_name           │
│                                                                 │
│  ✅ They exist only during query execution (not saved)          │
│                                                                 │
│  ✅ Perfect for:                                                 │
│     - Filtering on aggregated values                            │
│     - Multi-step calculations                                   │
│     - Combining summary and detail data                         │
│                                                                 │
│  ✅ Can JOIN derived tables with regular tables                 │
│                                                                 │
│  ✅ Can use multiple derived tables in one query                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Excellent progress! You've learned about Derived Tables. In the next lesson, we'll learn about **CTEs (Common Table Expressions)** - a more readable way to write derived tables, especially when you need to reuse the same subquery multiple times!

**Next Up:** Lesson 4 - Using CTEs (Common Table Expressions)
