# Lesson 1: Writing Queries with PIVOT and UNPIVOT - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! This lesson introduces **PIVOT** and **UNPIVOT** - powerful tools for transforming how your data looks. Think of them as ways to "rotate" your data from rows to columns (or columns to rows).

---

## 📖 What is PIVOT? (The Simple Explanation)

### Real-World Analogy: Spreadsheet Transformation

Imagine you have sales data in a list:

**Before PIVOT (vertical list):**
```
Salesperson | Month    | Sales
------------|----------|-------
John        | January  | $5000
John        | February | $6000
John        | March    | $4500
Sarah       | January  | $7000
Sarah       | February | $8000
Sarah       | March    | $7500
```

**After PIVOT (horizontal spread):**
```
Salesperson | January | February | March
------------|---------|----------|-------
John        | $5000   | $6000    | $4500
Sarah       | $7000   | $8000    | $7500
```

**PIVOT transforms unique row values into column headers!**

```
┌─────────────────────────────────────────────────────────────────┐
│                    PIVOT TRANSFORMATION                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   BEFORE: Data in rows (long format)                            │
│   ┌──────────────────────────────────┐                          │
│   │ Dept   │ Quarter │ Budget        │                          │
│   ├────────┼─────────┼───────────────┤                          │
│   │ Eng    │ Q1      │ 100,000       │                          │
│   │ Eng    │ Q2      │ 120,000       │                          │
│   │ Sales  │ Q1      │ 80,000        │                          │
│   │ Sales  │ Q2      │ 90,000        │                          │
│   └──────────────────────────────────┘                          │
│                      │                                          │
│                      ▼  PIVOT                                   │
│                                                                 │
│   AFTER: Data in columns (wide format)                          │
│   ┌──────────────────────────────────┐                          │
│   │ Dept   │ Q1      │ Q2            │                          │
│   ├────────┼─────────┼───────────────┤                          │
│   │ Eng    │ 100,000 │ 120,000       │                          │
│   │ Sales  │ 80,000  │ 90,000        │                          │
│   └──────────────────────────────────┘                          │
│                                                                 │
│   💡 The values (Q1, Q2) became column headers!                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Part 1: Understanding PIVOT Syntax

### The Basic Structure

```sql
SELECT pivot_columns, [value1], [value2], [value3]
FROM (
    -- Source query with the data you want to transform
    SELECT row_identifier, column_to_pivot, values_to_aggregate
    FROM your_table
) AS SourceData
PIVOT (
    AGG_FUNCTION(values_to_aggregate)          -- What calculation?
    FOR column_to_pivot IN ([value1], [value2], [value3])  -- Which values become columns?
) AS PivotTable;
```

**Three key pieces:**
1. **AGG_FUNCTION**: How to summarize (SUM, COUNT, AVG, etc.)
2. **FOR column**: Which column's values become headers
3. **IN ([...])**:  The specific values to use as columns

---

### Example 1.1: Employee Count by Department and Job Level

**Goal:** Show how many employees are at each job level per department.

**Step 1: Look at the raw data:**
```sql
-- First, see what data we have
SELECT 
    d.DepartmentName,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN 'Senior'
        WHEN e.BaseSalary >= 70000 THEN 'Mid'
        ELSE 'Junior'
    END AS JobLevel,
    COUNT(*) AS EmpCount
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentName, 
         CASE WHEN e.BaseSalary >= 100000 THEN 'Senior'
              WHEN e.BaseSalary >= 70000 THEN 'Mid'
              ELSE 'Junior' END;
```

**Result (before PIVOT):**
| DepartmentName | JobLevel | EmpCount |
|----------------|----------|----------|
| Engineering    | Senior   | 5        |
| Engineering    | Mid      | 10       |
| Engineering    | Junior   | 8        |
| Marketing      | Senior   | 2        |
| Marketing      | Mid      | 6        |
| Marketing      | Junior   | 4        |

**Step 2: Apply PIVOT:**
```sql
SELECT 
    DepartmentName,
    ISNULL([Junior], 0) AS Junior,
    ISNULL([Mid], 0) AS Mid,
    ISNULL([Senior], 0) AS Senior
FROM (
    -- Source data
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 'Senior'
            WHEN e.BaseSalary >= 70000 THEN 'Mid'
            ELSE 'Junior'
        END AS JobLevel
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
) AS SourceData
PIVOT (
    COUNT(JobLevel)                    -- Aggregation
    FOR JobLevel IN ([Junior], [Mid], [Senior])  -- Values → Columns
) AS PivotTable
ORDER BY DepartmentName;
```

**Result (after PIVOT):**
| DepartmentName | Junior | Mid | Senior |
|----------------|--------|-----|--------|
| Engineering    | 8      | 10  | 5      |
| Marketing      | 4      | 6   | 2      |
| Sales          | 5      | 8   | 3      |

---

### Example 1.2: Quarterly Sales Report

**Goal:** Show sales totals by customer, with quarters as columns.

```sql
SELECT 
    CustomerName,
    ISNULL([Q1], 0) AS Q1_Sales,
    ISNULL([Q2], 0) AS Q2_Sales,
    ISNULL([Q3], 0) AS Q3_Sales,
    ISNULL([Q4], 0) AS Q4_Sales,
    ISNULL([Q1], 0) + ISNULL([Q2], 0) + ISNULL([Q3], 0) + ISNULL([Q4], 0) AS Total
FROM (
    SELECT 
        c.CustomerName,
        'Q' + CAST(DATEPART(QUARTER, o.OrderDate) AS VARCHAR(1)) AS Quarter,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE YEAR(o.OrderDate) = 2024
) AS SourceData
PIVOT (
    SUM(TotalAmount)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable
ORDER BY Total DESC;
```

**Expected Result:**
| CustomerName   | Q1_Sales  | Q2_Sales  | Q3_Sales  | Q4_Sales  | Total      |
|----------------|-----------|-----------|-----------|-----------|------------|
| ABC Corp       | 45000.00  | 52000.00  | 48000.00  | 61000.00  | 206000.00  |
| XYZ Industries | 32000.00  | 38000.00  | 35000.00  | 42000.00  | 147000.00  |
| Tech Solutions | 28000.00  | 31000.00  | 29000.00  | 35000.00  | 123000.00  |

---

## 🎓 Part 2: More PIVOT Examples

### Example 2.1: Department Salary Distribution

**Goal:** Show average salary by department and experience level.

```sql
SELECT 
    DepartmentName,
    FORMAT(ISNULL([Entry], 0), 'C') AS Entry_Level,
    FORMAT(ISNULL([Mid], 0), 'C') AS Mid_Level,
    FORMAT(ISNULL([Senior], 0), 'C') AS Senior_Level,
    FORMAT(ISNULL([Executive], 0), 'C') AS Executive
FROM (
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 'Entry'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 5 THEN 'Mid'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 10 THEN 'Senior'
            ELSE 'Executive'
        END AS ExperienceLevel,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
) AS SourceData
PIVOT (
    AVG(BaseSalary)
    FOR ExperienceLevel IN ([Entry], [Mid], [Senior], [Executive])
) AS PivotTable
ORDER BY DepartmentName;
```

---

### Example 2.2: Project Status by Department

**Goal:** Count projects by status for each department.

```sql
SELECT 
    DepartmentName,
    ISNULL([Planning], 0) AS Planning,
    ISNULL([Active], 0) AS Active,
    ISNULL([On Hold], 0) AS OnHold,
    ISNULL([Completed], 0) AS Completed
FROM (
    SELECT 
        d.DepartmentName,
        p.Status
    FROM Projects p
    INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    INNER JOIN Departments d ON pm.DepartmentID = d.DepartmentID
) AS SourceData
PIVOT (
    COUNT(Status)
    FOR Status IN ([Planning], [Active], [On Hold], [Completed])
) AS PivotTable
ORDER BY DepartmentName;
```

**Expected Result:**
| DepartmentName | Planning | Active | OnHold | Completed |
|----------------|----------|--------|--------|-----------|
| Engineering    | 3        | 8      | 2      | 12        |
| Marketing      | 2        | 4      | 1      | 6         |
| Sales          | 1        | 3      | 0      | 5         |

---

## 🎓 Part 3: UNPIVOT - The Reverse Operation

### What is UNPIVOT?

UNPIVOT does the **opposite** of PIVOT - it transforms columns back into rows.

```
┌─────────────────────────────────────────────────────────────────┐
│                    UNPIVOT TRANSFORMATION                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   BEFORE: Data in columns (wide format)                         │
│   ┌──────────────────────────────────┐                          │
│   │ Dept   │ Q1      │ Q2      │ Q3  │                          │
│   ├────────┼─────────┼─────────┼─────┤                          │
│   │ Eng    │ 100K    │ 120K    │ 90K │                          │
│   │ Sales  │ 80K     │ 90K     │ 85K │                          │
│   └──────────────────────────────────┘                          │
│                      │                                          │
│                      ▼  UNPIVOT                                 │
│                                                                 │
│   AFTER: Data in rows (long format)                             │
│   ┌──────────────────────────────────┐                          │
│   │ Dept   │ Quarter │ Budget        │                          │
│   ├────────┼─────────┼───────────────┤                          │
│   │ Eng    │ Q1      │ 100K          │                          │
│   │ Eng    │ Q2      │ 120K          │                          │
│   │ Eng    │ Q3      │ 90K           │                          │
│   │ Sales  │ Q1      │ 80K           │                          │
│   │ Sales  │ Q2      │ 90K           │                          │
│   │ Sales  │ Q3      │ 85K           │                          │
│   └──────────────────────────────────┘                          │
│                                                                 │
│   💡 The columns (Q1, Q2, Q3) became row values!                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### Example 3.1: UNPIVOT a Pivoted Report

```sql
-- First, let's create a table with quarterly data (wide format)
-- Imagine this comes from a spreadsheet import

-- Create sample wide-format data using a CTE
WITH QuarterlyBudgets AS (
    SELECT 'Engineering' AS DepartmentName, 300000 AS Q1, 320000 AS Q2, 310000 AS Q3, 350000 AS Q4
    UNION ALL
    SELECT 'Marketing', 150000, 160000, 155000, 180000
    UNION ALL
    SELECT 'Sales', 200000, 220000, 210000, 250000
)
-- Now UNPIVOT it
SELECT 
    DepartmentName,
    Quarter,
    Budget
FROM QuarterlyBudgets
UNPIVOT (
    Budget                                  -- New column for the values
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4]) -- Columns to transform
) AS UnpivotTable
ORDER BY DepartmentName, Quarter;
```

**Result:**
| DepartmentName | Quarter | Budget  |
|----------------|---------|---------|
| Engineering    | Q1      | 300000  |
| Engineering    | Q2      | 320000  |
| Engineering    | Q3      | 310000  |
| Engineering    | Q4      | 350000  |
| Marketing      | Q1      | 150000  |
| Marketing      | Q2      | 160000  |
...

---

### Example 3.2: Analyzing Contact Methods

**Scenario:** You have a table with multiple contact columns and want to find all contacts for each customer.

```sql
-- Sample data with multiple contact columns
WITH CustomerContacts AS (
    SELECT 
        CustomerName,
        PrimaryEmail,
        PrimaryPhone,
        SecondaryPhone
    FROM Customers
    WHERE IsActive = 1
)
-- UNPIVOT to list all contact methods
SELECT 
    CustomerName,
    ContactType,
    ContactValue
FROM CustomerContacts
UNPIVOT (
    ContactValue 
    FOR ContactType IN ([PrimaryEmail], [PrimaryPhone], [SecondaryPhone])
) AS ContactList
WHERE ContactValue IS NOT NULL
ORDER BY CustomerName, ContactType;
```

---

## 📊 Visual: When to Use PIVOT vs UNPIVOT

```
┌─────────────────────────────────────────────────────────────────┐
│              WHEN TO USE PIVOT vs UNPIVOT                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  USE PIVOT WHEN:                                                │
│  ────────────────                                               │
│  ✅ Creating cross-tab reports                                  │
│  ✅ Making data easier to read in spreadsheet format            │
│  ✅ Comparing values across categories side-by-side             │
│  ✅ Creating summary matrices                                   │
│                                                                 │
│  Example: Monthly sales by salesperson →                        │
│           Jan, Feb, Mar as column headers                       │
│                                                                 │
│  ───────────────────────────────────────────────────────────    │
│                                                                 │
│  USE UNPIVOT WHEN:                                              │
│  ──────────────────                                             │
│  ✅ Normalizing data from spreadsheet imports                   │
│  ✅ Converting wide tables to long format                       │
│  ✅ Preparing data for charts/analysis tools                    │
│  ✅ When columns contain similar data (Q1, Q2, Q3...)           │
│                                                                 │
│  Example: Spreadsheet with columns for each month →             │
│           One Month column with date values                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Employee Count by Gender and Department (Easy)

Create a PIVOT that shows employee count by department with gender as columns.

```sql
-- Your answer:
SELECT 
    DepartmentName,
    ISNULL([M], 0) AS Male,
    ISNULL([F], 0) AS Female
FROM (
    SELECT d.DepartmentName, e.Gender
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1 AND e.Gender IN ('M', 'F')
) AS SourceData
PIVOT (
    COUNT(Gender)
    FOR Gender IN ([M], [F])
) AS PivotTable
ORDER BY DepartmentName;
```

### Exercise 2: Order Totals by Status (Medium)

Create a PIVOT showing order totals by customer with OrderStatus as columns.

```sql
-- Your answer:
SELECT 
    CustomerName,
    ISNULL([Pending], 0) AS Pending,
    ISNULL([Shipped], 0) AS Shipped,
    ISNULL([Delivered], 0) AS Delivered
FROM (
    SELECT c.CustomerName, o.OrderStatus, o.TotalAmount
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
) AS SourceData
PIVOT (
    SUM(TotalAmount)
    FOR OrderStatus IN ([Pending], [Shipped], [Delivered])
) AS PivotTable
ORDER BY CustomerName;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ PIVOT transforms row values into column headers             │
│                                                                 │
│  ✅ UNPIVOT transforms column headers into row values           │
│                                                                 │
│  ✅ PIVOT syntax requires:                                      │
│     - An aggregate function (SUM, COUNT, AVG, etc.)             │
│     - FOR column IN ([value1], [value2], ...)                   │
│                                                                 │
│  ✅ Column names in IN clause must be known in advance          │
│                                                                 │
│  ✅ Use ISNULL() to handle NULL values in pivoted columns       │
│                                                                 │
│  ✅ The source query determines available row identifiers       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Great job! You've learned how to use PIVOT and UNPIVOT. In the next lesson, we'll learn about **Grouping Sets** - a powerful way to create multiple levels of aggregation (subtotals and grand totals) in a single query!

**Next Up:** Lesson 2 - Working with Grouping Sets
