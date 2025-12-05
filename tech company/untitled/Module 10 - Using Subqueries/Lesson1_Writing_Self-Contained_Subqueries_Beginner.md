# Lesson 1: Writing Self-Contained Subqueries - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! This lesson will teach you about **subqueries** - one of the most powerful tools in SQL. Don't worry if you've never heard of them before. We'll start from the very basics and build up your understanding step by step.

---

## 📖 What is a Subquery? (The Simple Explanation)

### Real-World Analogy: The Nested Question

Think about this everyday scenario:

**Normal Question:** "What is the average salary at our company?"
**Answer:** "$75,000"

**Follow-up Question:** "Show me everyone who earns more than the average salary."

In SQL, a **subquery** is like asking a **question inside another question**. The inner question gets answered first, and then its answer is used to help answer the outer question.

```
┌─────────────────────────────────────────────────────────────────┐
│                   HOW SUBQUERIES WORK                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   OUTER QUESTION: "Who earns more than average?"                │
│         │                                                       │
│         │  needs to know...                                     │
│         ▼                                                       │
│   INNER QUESTION: "What is the average salary?"                 │
│         │                                                       │
│         │  answer: $75,000                                      │
│         ▼                                                       │
│   FINAL ANSWER: List of people earning more than $75,000        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### The SQL Version

```sql
-- The outer question (main query)
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE BaseSalary > (
    -- The inner question (subquery) - runs FIRST!
    SELECT AVG(BaseSalary) 
    FROM Employees
);
```

**Key Point:** The part in parentheses `(SELECT AVG(BaseSalary) FROM Employees)` is the **subquery**. SQL Server runs this first to get the average, then uses that number in the main query.

---

## 🏗️ Understanding Self-Contained Subqueries

### What Does "Self-Contained" Mean?

A **self-contained subquery** is one that can run **completely on its own** without needing any information from the outer query.

**Like this analogy:**

Imagine you're ordering pizza:
- **Self-Contained Question:** "What pizza is on special today?" (You can ask this without knowing anything else)
- **Dependent Question:** "Is this pizza spicier than what I usually order?" (This depends on knowing what YOU usually order)

### Test It Yourself

A self-contained subquery can be copied and run separately:

```sql
-- This is the subquery - try running it alone!
SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1;
-- Result: Let's say it returns 72500.00
```

Now see how it fits into the main query:

```sql
-- The complete query with subquery
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE BaseSalary > (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1)
  AND IsActive = 1;
```

---

## 📊 TechCorp Database - Quick Reference

Before we practice, here are the main tables we'll use:

```
┌─────────────────────────────────────────────────────────────────┐
│                    KEY TECHCORP TABLES                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📋 Employees                    📋 Departments                 │
│  ├── EmployeeID (unique ID)      ├── DepartmentID               │
│  ├── FirstName                   ├── DepartmentName             │
│  ├── LastName                    ├── Budget                     │
│  ├── JobTitle                    ├── Location                   │
│  ├── BaseSalary                  └── IsActive                   │
│  ├── DepartmentID                                               │
│  ├── HireDate                    📋 Projects                    │
│  └── IsActive                    ├── ProjectID                  │
│                                  ├── ProjectName                │
│                                  ├── Budget                     │
│                                  └── StartDate                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Part 1: Scalar Subqueries (Return ONE Value)

### What is a Scalar Subquery?

**Scalar** = Single value (one number, one date, one name, etc.)

A **scalar subquery** returns exactly ONE value - like asking "What is the highest salary?" The answer is a single number.

### Example 1.1: Finding Employees Above Average Salary

**The Question:** "Show me all employees who earn more than the average salary."

**Step-by-step thinking:**
1. First, we need to know: What IS the average salary?
2. Then, we can find: Who earns MORE than that?

```sql
-- Step 1: Let's first see what the average salary is
SELECT AVG(BaseSalary) AS AverageSalary
FROM Employees
WHERE IsActive = 1;
```

**Expected Result:**
| AverageSalary |
|---------------|
| 72500.00      |

```sql
-- Step 2: Now let's find everyone earning more than $72,500
-- But instead of typing 72500, we use a subquery!

SELECT 
    FirstName,
    LastName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE BaseSalary > (
    SELECT AVG(BaseSalary)     -- This calculates the average
    FROM Employees
    WHERE IsActive = 1
)
AND IsActive = 1
ORDER BY BaseSalary DESC;
```

**Expected Result:**
| FirstName | LastName | JobTitle           | BaseSalary |
|-----------|----------|--------------------|------------|
| Sarah     | Johnson  | Engineering Manager| 125000.00  |
| Michael   | Chen     | Senior Developer   | 98000.00   |
| Emily     | Davis    | Data Analyst       | 85000.00   |

**Why use a subquery instead of typing 72500?**
- The average changes as employees are added/removed
- The subquery always calculates the CURRENT average
- Your query stays accurate automatically!

---

### Example 1.2: Comparing to Maximum Value

**The Question:** "Show the employee with the highest salary and how much MORE they earn than the average."

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    -- Subquery to get the average
    (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1) AS CompanyAverage,
    -- Calculate the difference
    BaseSalary - (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1) AS AboveAverageBy
FROM Employees
WHERE BaseSalary = (
    -- Subquery to find the maximum salary
    SELECT MAX(BaseSalary) 
    FROM Employees 
    WHERE IsActive = 1
)
AND IsActive = 1;
```

**Expected Result:**
| FirstName | LastName | BaseSalary | CompanyAverage | AboveAverageBy |
|-----------|----------|------------|----------------|----------------|
| Sarah     | Johnson  | 125000.00  | 72500.00       | 52500.00       |

---

### Example 1.3: Finding the Newest Employee

**The Question:** "Who was hired most recently?"

```sql
SELECT 
    FirstName,
    LastName,
    JobTitle,
    HireDate
FROM Employees
WHERE HireDate = (
    SELECT MAX(HireDate)    -- MAX on a date gives the most recent
    FROM Employees
    WHERE IsActive = 1
)
AND IsActive = 1;
```

**Expected Result:**
| FirstName | LastName | JobTitle         | HireDate   |
|-----------|----------|------------------|------------|
| Alex      | Turner   | Junior Developer | 2024-11-15 |

---

## 🎓 Part 2: Multi-Value Subqueries (Return MULTIPLE Values)

### What is a Multi-Value Subquery?

Instead of returning ONE value, these subqueries return a **LIST** of values.

**Analogy:** 
- Scalar: "What is the capital of France?" → "Paris" (one answer)
- Multi-value: "What are the capitals of European countries?" → "Paris, London, Berlin, Rome..." (a list)

### The IN Operator - Checking Against a List

Use `IN` when you want to check if a value matches ANY item in a list.

### Example 2.1: Employees in Large Departments

**The Question:** "Show me employees who work in departments with budgets over $500,000."

**Step-by-step thinking:**
1. Which departments have budgets over $500,000?
2. Show employees who work in THOSE departments

```sql
-- Step 1: Let's first see which departments have big budgets
SELECT DepartmentID, DepartmentName, Budget
FROM Departments
WHERE Budget > 500000
AND IsActive = 1;
```

**Expected Result:**
| DepartmentID | DepartmentName | Budget     |
|--------------|----------------|------------|
| 1            | Engineering    | 1200000.00 |
| 3            | Sales          | 800000.00  |

```sql
-- Step 2: Now find employees in those departments using a subquery
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.DepartmentID IN (
    -- This returns a LIST of department IDs
    SELECT DepartmentID
    FROM Departments
    WHERE Budget > 500000
    AND IsActive = 1
)
AND e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;
```

**Expected Result:**
| FirstName | LastName | JobTitle           | DepartmentName |
|-----------|----------|--------------------|----------------|
| Michael   | Chen     | Senior Developer   | Engineering    |
| Sarah     | Johnson  | Engineering Manager| Engineering    |
| James     | Wilson   | Sales Representative| Sales         |

---

### Example 2.2: Finding Employees NOT in a Group

**The Question:** "Show employees who are NOT project managers."

Use `NOT IN` to exclude items from a list.

```sql
SELECT 
    FirstName,
    LastName,
    JobTitle
FROM Employees
WHERE EmployeeID NOT IN (
    -- Get the list of all project manager IDs
    SELECT DISTINCT ProjectManagerID
    FROM Projects
    WHERE ProjectManagerID IS NOT NULL
)
AND IsActive = 1
ORDER BY LastName;
```

---

### Example 2.3: Employees with Specific Skills

**The Question:** "Show employees who have the 'Python' skill."

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle
FROM Employees e
WHERE e.EmployeeID IN (
    -- Find employees who have the Python skill
    SELECT es.EmployeeID
    FROM EmployeeSkills es
    INNER JOIN Skills s ON es.SkillID = s.SkillID
    WHERE s.SkillName = 'Python'
    AND es.IsActive = 1
)
AND e.IsActive = 1;
```

---

## 🎓 Part 3: Subqueries in the SELECT Clause

You can also put subqueries in the SELECT part to add calculated columns.

### Example 3.1: Adding Company Statistics to Each Row

**The Question:** "Show each employee with the company average next to their salary."

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary AS MySalary,
    (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1) AS CompanyAverage,
    (SELECT COUNT(*) FROM Employees WHERE IsActive = 1) AS TotalEmployees
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;
```

**Expected Result:**
| FirstName | LastName | MySalary   | CompanyAverage | TotalEmployees |
|-----------|----------|------------|----------------|----------------|
| Sarah     | Johnson  | 125000.00  | 72500.00       | 150            |
| Michael   | Chen     | 98000.00   | 72500.00       | 150            |
| Emily     | Davis    | 85000.00   | 72500.00       | 150            |

**Notice:** Every row shows the same CompanyAverage and TotalEmployees because those are company-wide numbers.

---

## 🎓 Part 4: Subqueries in the FROM Clause (Derived Tables)

You can use a subquery as if it were a table!

### Example 4.1: Working with Summarized Data

**The Question:** "Show the average salary per department, but only departments with more than 5 employees."

```sql
-- The subquery creates a "temporary table" of department statistics
SELECT 
    DepartmentStats.DepartmentName,
    DepartmentStats.EmployeeCount,
    DepartmentStats.AvgSalary
FROM (
    -- This subquery calculates stats for each department
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) AS DepartmentStats    -- Give the subquery a name (alias)
WHERE DepartmentStats.EmployeeCount > 5
ORDER BY DepartmentStats.AvgSalary DESC;
```

**Expected Result:**
| DepartmentName | EmployeeCount | AvgSalary |
|----------------|---------------|-----------|
| Engineering    | 25            | 92000.00  |
| Sales          | 18            | 78000.00  |
| Marketing      | 12            | 68000.00  |

---

## 📝 Quick Reference: Subquery Locations

```
┌─────────────────────────────────────────────────────────────────┐
│              WHERE CAN YOU PUT A SUBQUERY?                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. In WHERE clause (filtering):                                │
│     WHERE salary > (SELECT AVG(salary) FROM table)              │
│     WHERE id IN (SELECT id FROM other_table)                    │
│                                                                 │
│  2. In SELECT clause (adding columns):                          │
│     SELECT name, (SELECT COUNT(*) FROM orders) AS total         │
│                                                                 │
│  3. In FROM clause (as a table):                                │
│     FROM (SELECT ... GROUP BY ...) AS summary                   │
│                                                                 │
│  4. In HAVING clause (filter groups):                           │
│     HAVING COUNT(*) > (SELECT AVG(count) FROM summary)          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Find High Earners (Easy)
Write a query to find all employees who earn more than the minimum salary.

```sql
-- Your answer:
SELECT FirstName, LastName, BaseSalary
FROM Employees
WHERE BaseSalary > (
    SELECT MIN(BaseSalary) 
    FROM Employees 
    WHERE IsActive = 1
)
AND IsActive = 1;
```

### Exercise 2: Department Budget Comparison (Medium)
Find departments with budgets above the average department budget.

```sql
-- Your answer:
SELECT DepartmentName, Budget
FROM Departments
WHERE Budget > (
    SELECT AVG(Budget) 
    FROM Departments 
    WHERE IsActive = 1
)
AND IsActive = 1;
```

### Exercise 3: Employees in Small Departments (Medium)
Find employees who work in departments with fewer than 10 employees.

```sql
-- Your answer:
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.DepartmentID IN (
    SELECT DepartmentID
    FROM Employees
    WHERE IsActive = 1
    GROUP BY DepartmentID
    HAVING COUNT(*) < 10
)
AND e.IsActive = 1;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ A subquery is a query inside another query                  │
│                                                                 │
│  ✅ Self-contained subqueries can run on their own              │
│                                                                 │
│  ✅ Scalar subqueries return ONE value → use with =, >, <       │
│                                                                 │
│  ✅ Multi-value subqueries return a LIST → use with IN, NOT IN  │
│                                                                 │
│  ✅ Subqueries always go in parentheses ( )                     │
│                                                                 │
│  ✅ The inner query runs FIRST, then the outer query uses       │
│     its result                                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Great job! You've learned the fundamentals of self-contained subqueries. In the next lesson, we'll learn about **correlated subqueries** - these are subqueries that DO depend on the outer query. They're more powerful but also more complex!

**Next Up:** Lesson 2 - Writing Correlated Subqueries
