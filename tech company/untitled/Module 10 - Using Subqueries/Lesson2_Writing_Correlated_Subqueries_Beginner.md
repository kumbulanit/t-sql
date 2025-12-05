# Lesson 2: Writing Correlated Subqueries - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome back! In Lesson 1, you learned about self-contained subqueries (queries inside queries that can run on their own). Now we'll learn about **correlated subqueries** - a more powerful but slightly trickier type. Don't worry - we'll break it down step by step!

---

## 📖 What is a Correlated Subquery? (The Simple Explanation)

### The Key Difference

| Self-Contained Subquery | Correlated Subquery |
|------------------------|---------------------|
| Runs **once**, gives one result | Runs **many times**, once for each row |
| Can run on its own | **Needs** information from the outer query |
| Like asking "What's the average salary?" | Like asking "Is THIS person above THEIR department's average?" |

### Real-World Analogy: The Class Test

**Self-Contained Question:** "What's the average test score for ALL students?"
- You calculate it once: 75%
- Then you know everyone above 75% did well

**Correlated Question:** "Did each student score above THEIR CLASS's average?"
- Student A is in Math class → compare to Math average
- Student B is in English class → compare to English average
- Student C is in Math class → compare to Math average again
- You have to check the right average for EACH student

```
┌─────────────────────────────────────────────────────────────────┐
│              CORRELATED SUBQUERY - HOW IT WORKS                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  For EACH employee in the outer query:                          │
│  ┌─────────────────────────────────────┐                        │
│  │ Employee: John (Engineering Dept)   │                        │
│  │ Salary: $80,000                     │                        │
│  │                                     │                        │
│  │ → Calculate Engineering avg: $75,000│ ◄─┐                    │
│  │ → Is $80,000 > $75,000? YES ✓       │   │                    │
│  └─────────────────────────────────────┘   │                    │
│                                            │                    │
│  ┌─────────────────────────────────────┐   │ Subquery runs      │
│  │ Employee: Sarah (Marketing Dept)    │   │ for EACH employee  │
│  │ Salary: $65,000                     │   │                    │
│  │                                     │   │                    │
│  │ → Calculate Marketing avg: $70,000  │ ◄─┤                    │
│  │ → Is $65,000 > $70,000? NO ✗        │   │                    │
│  └─────────────────────────────────────┘   │                    │
│                                            │                    │
│  ┌─────────────────────────────────────┐   │                    │
│  │ Employee: Mike (Engineering Dept)   │   │                    │
│  │ Salary: $90,000                     │   │                    │
│  │                                     │   │                    │
│  │ → Calculate Engineering avg: $75,000│ ◄─┘                    │
│  │ → Is $90,000 > $75,000? YES ✓       │                        │
│  └─────────────────────────────────────┘                        │
│                                                                 │
│  Result: John and Mike are above their department averages      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 The Magic Word: "Correlation"

A correlated subquery **references the outer query**. This is the link between them!

### How to Spot It

Look for a reference to the outer table inside the subquery:

```sql
-- Self-Contained (NO reference to outer table)
SELECT * FROM Employees
WHERE BaseSalary > (SELECT AVG(BaseSalary) FROM Employees);
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                    No mention of the outer Employees table!

-- Correlated (YES reference to outer table)
SELECT * FROM Employees e_outer
WHERE BaseSalary > (SELECT AVG(BaseSalary) 
                    FROM Employees e_inner 
                    WHERE e_inner.DepartmentID = e_outer.DepartmentID);
                                                ^^^^^^^^
                                                Reference to outer table!
```

**The Key:** `e_outer.DepartmentID` inside the subquery connects it to each row being processed in the outer query.

---

## 🎓 Part 1: Your First Correlated Subquery

### Example 1.1: Employees Above Their Department's Average

**The Question:** "Show employees who earn more than the average salary IN THEIR OWN DEPARTMENT."

**Why correlated?** Because "their own department" is different for each employee!

```sql
-- Step-by-step breakdown:

SELECT 
    e_outer.FirstName,
    e_outer.LastName,
    e_outer.DepartmentID,
    e_outer.BaseSalary
FROM Employees e_outer          -- e_outer = alias for outer query
WHERE e_outer.BaseSalary > (
    -- For EACH employee, calculate their department's average
    SELECT AVG(e_inner.BaseSalary)
    FROM Employees e_inner      -- e_inner = alias for inner query
    WHERE e_inner.DepartmentID = e_outer.DepartmentID   -- THE CORRELATION!
      AND e_inner.IsActive = 1
)
AND e_outer.IsActive = 1
ORDER BY e_outer.DepartmentID, e_outer.BaseSalary DESC;
```

**How it works step by step:**

| Step | Employee | Their DepartmentID | Subquery Calculates | Comparison |
|------|----------|-------------------|---------------------|------------|
| 1 | John | 1 (Engineering) | AVG for Dept 1 = $75,000 | $80,000 > $75,000 ✓ |
| 2 | Sarah | 2 (Marketing) | AVG for Dept 2 = $70,000 | $65,000 > $70,000 ✗ |
| 3 | Mike | 1 (Engineering) | AVG for Dept 1 = $75,000 | $90,000 > $75,000 ✓ |
| 4 | Lisa | 2 (Marketing) | AVG for Dept 2 = $70,000 | $75,000 > $70,000 ✓ |

**Expected Result:**
| FirstName | LastName | DepartmentID | BaseSalary |
|-----------|----------|--------------|------------|
| Mike      | Chen     | 1            | 90000.00   |
| John      | Smith    | 1            | 80000.00   |
| Lisa      | Davis    | 2            | 75000.00   |

---

### Example 1.2: Adding the Department Average as a Column

Let's show both the employee's salary AND their department's average:

```sql
SELECT 
    e_outer.FirstName,
    e_outer.LastName,
    d.DepartmentName,
    e_outer.BaseSalary AS MySalary,
    -- Correlated subquery in SELECT clause
    (SELECT AVG(e_inner.BaseSalary)
     FROM Employees e_inner
     WHERE e_inner.DepartmentID = e_outer.DepartmentID
       AND e_inner.IsActive = 1) AS DepartmentAverage,
    -- Calculate the difference
    e_outer.BaseSalary - (
        SELECT AVG(e_inner.BaseSalary)
        FROM Employees e_inner
        WHERE e_inner.DepartmentID = e_outer.DepartmentID
          AND e_inner.IsActive = 1
    ) AS DifferenceFromDeptAvg
FROM Employees e_outer
INNER JOIN Departments d ON e_outer.DepartmentID = d.DepartmentID
WHERE e_outer.IsActive = 1
ORDER BY d.DepartmentName, e_outer.BaseSalary DESC;
```

**Expected Result:**
| FirstName | LastName | DepartmentName | MySalary  | DepartmentAverage | DifferenceFromDeptAvg |
|-----------|----------|----------------|-----------|-------------------|----------------------|
| Mike      | Chen     | Engineering    | 90000.00  | 75000.00          | 15000.00             |
| John      | Smith    | Engineering    | 80000.00  | 75000.00          | 5000.00              |
| Amy       | Lee      | Engineering    | 55000.00  | 75000.00          | -20000.00            |
| Lisa      | Davis    | Marketing      | 75000.00  | 65000.00          | 10000.00             |

---

## 🎓 Part 2: Finding Related Records

### Example 2.1: Employees with Multiple Project Assignments

**The Question:** "Show employees who are assigned to more than 2 projects."

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    -- Count their projects
    (SELECT COUNT(*)
     FROM EmployeeProjects ep
     WHERE ep.EmployeeID = e.EmployeeID    -- Correlation!
       AND ep.IsActive = 1) AS ProjectCount
FROM Employees e
WHERE (
    SELECT COUNT(*)
    FROM EmployeeProjects ep
    WHERE ep.EmployeeID = e.EmployeeID     -- Same correlation
      AND ep.IsActive = 1
) > 2
AND e.IsActive = 1
ORDER BY ProjectCount DESC;
```

**Expected Result:**
| FirstName | LastName | JobTitle         | ProjectCount |
|-----------|----------|------------------|--------------|
| Sarah     | Johnson  | Senior Developer | 5            |
| Michael   | Chen     | Project Manager  | 4            |
| Emily     | Davis    | Data Analyst     | 3            |

---

### Example 2.2: Latest Order for Each Customer

**The Question:** "Show each customer with their most recent order date."

```sql
SELECT 
    c.CustomerName,
    c.City,
    -- Get the latest order date for THIS customer
    (SELECT MAX(o.OrderDate)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID    -- Correlation!
    ) AS LastOrderDate,
    -- Also get the total number of orders
    (SELECT COUNT(*)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID
    ) AS TotalOrders
FROM Customers c
WHERE c.IsActive = 1
ORDER BY LastOrderDate DESC;
```

**Expected Result:**
| CustomerName   | City      | LastOrderDate | TotalOrders |
|----------------|-----------|---------------|-------------|
| ABC Company    | New York  | 2024-12-01    | 15          |
| XYZ Industries | Chicago   | 2024-11-28    | 8           |
| Tech Solutions | Boston    | 2024-11-15    | 22          |

---

## 🎓 Part 3: Comparing Within Groups

### Example 3.1: Department's Highest Paid Employee

**The Question:** "Find the highest-paid employee in each department."

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary = (
    -- Find the MAX salary for THIS employee's department
    SELECT MAX(e_inner.BaseSalary)
    FROM Employees e_inner
    WHERE e_inner.DepartmentID = e.DepartmentID    -- Correlation!
      AND e_inner.IsActive = 1
)
AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

**Expected Result:**
| FirstName | LastName | DepartmentName | BaseSalary |
|-----------|----------|----------------|------------|
| Sarah     | Johnson  | Engineering    | 125000.00  |
| Michael   | Chen     | Sales          | 98000.00   |
| Emily     | Davis    | Marketing      | 85000.00   |

---

### Example 3.2: Second Highest Salary in Each Department

**More Advanced:** Find the second-highest earner in each department.

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary = (
    -- Find the MAX salary that is LESS than the top salary
    SELECT MAX(e_inner.BaseSalary)
    FROM Employees e_inner
    WHERE e_inner.DepartmentID = e.DepartmentID
      AND e_inner.IsActive = 1
      AND e_inner.BaseSalary < (
          -- This inner-inner subquery finds the top salary
          SELECT MAX(e_top.BaseSalary)
          FROM Employees e_top
          WHERE e_top.DepartmentID = e.DepartmentID
            AND e_top.IsActive = 1
      )
)
AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

---

## 📊 Visual: Self-Contained vs Correlated

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPARISON CHART                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SELF-CONTAINED SUBQUERY            CORRELATED SUBQUERY         │
│  ─────────────────────────          ─────────────────────────   │
│                                                                 │
│  "What's the company avg?"          "What's THIS dept's avg?"   │
│           ↓                                   ↓                 │
│     Runs ONCE                         Runs FOR EACH ROW         │
│           ↓                                   ↓                 │
│   Returns: $72,500                  Returns: Different for      │
│                                              each department    │
│           ↓                                   ↓                 │
│  Compare all salaries               Compare each person to      │
│  to the SAME number                 THEIR department's number   │
│                                                                 │
│  ┌─────────┐                        ┌─────────┐                 │
│  │ $72,500 │ ← ONE answer           │ $75,000 │ ← Engineering   │
│  └─────────┘                        │ $65,000 │ ← Marketing     │
│                                     │ $80,000 │ ← Sales         │
│                                     └─────────┘ ← MANY answers  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚠️ Important Tips for Correlated Subqueries

### Tip 1: Always Use Table Aliases

```sql
-- ❌ CONFUSING - which Employees table is which?
SELECT * FROM Employees
WHERE BaseSalary > (SELECT AVG(BaseSalary) FROM Employees WHERE DepartmentID = DepartmentID);

-- ✅ CLEAR - aliases make it obvious
SELECT * FROM Employees e_outer
WHERE BaseSalary > (SELECT AVG(BaseSalary) FROM Employees e_inner 
                    WHERE e_inner.DepartmentID = e_outer.DepartmentID);
```

### Tip 2: Performance Consideration

Correlated subqueries run once for EACH row. With 1000 employees, the subquery runs 1000 times!

```sql
-- For very large tables, consider using JOINs instead
-- But for learning and moderate data sizes, correlated subqueries are fine
```

### Tip 3: Test Your Subquery

Before writing the full query, test what the subquery returns for a specific case:

```sql
-- Test: What's the average salary for Department 1?
SELECT AVG(BaseSalary) 
FROM Employees 
WHERE DepartmentID = 1 AND IsActive = 1;
-- Result: 75000.00

-- Now you know what to expect when the correlated subquery processes Department 1
```

---

## ✅ Practice Exercises

### Exercise 1: Below Department Average (Easy)
Find employees who earn LESS than their department's average.

```sql
-- Your answer:
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary < (
    SELECT AVG(e_inner.BaseSalary)
    FROM Employees e_inner
    WHERE e_inner.DepartmentID = e.DepartmentID
      AND e_inner.IsActive = 1
)
AND e.IsActive = 1;
```

### Exercise 2: Projects Over Budget (Medium)
Find projects where the budget is higher than the average budget for that project's department.

```sql
-- Your answer:
SELECT 
    p.ProjectName,
    p.Budget,
    d.DepartmentName
FROM Projects p
INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
INNER JOIN Departments d ON pm.DepartmentID = d.DepartmentID
WHERE p.Budget > (
    SELECT AVG(p_inner.Budget)
    FROM Projects p_inner
    INNER JOIN Employees pm_inner ON p_inner.ProjectManagerID = pm_inner.EmployeeID
    WHERE pm_inner.DepartmentID = pm.DepartmentID
);
```

### Exercise 3: Employee's Rank in Department (Challenging)
Show each employee with a count of how many people in their department earn more than them.

```sql
-- Your answer:
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    (SELECT COUNT(*)
     FROM Employees e_higher
     WHERE e_higher.DepartmentID = e.DepartmentID
       AND e_higher.BaseSalary > e.BaseSalary
       AND e_higher.IsActive = 1) AS PeopleEarningMore
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Correlated subqueries reference the outer query             │
│                                                                 │
│  ✅ They run once for EACH ROW in the outer query               │
│                                                                 │
│  ✅ Use meaningful aliases (e_outer, e_inner) to stay clear     │
│                                                                 │
│  ✅ Perfect for "comparing to own group" questions              │
│     - Above department average?                                 │
│     - Highest in their category?                                │
│     - Most recent for this customer?                            │
│                                                                 │
│  ✅ The correlation is the link:                                │
│     WHERE inner.column = outer.column                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Excellent work! You now understand both self-contained AND correlated subqueries. In the next lesson, we'll learn about the **EXISTS** predicate - a special way to check if related records exist. This is incredibly useful for "Has this customer ever ordered?" type questions!

**Next Up:** Lesson 3 - Using the EXISTS Predicate with Subqueries
