# Lab: Using Subqueries - Beginner Lab

## 🎯 Lab Overview

Welcome to your hands-on practice lab for subqueries! This lab will reinforce everything you learned in the three subquery lessons. You'll work through exercises from easy to challenging, building your confidence with real TechCorp data.

**Time Required:** 45-60 minutes  
**Difficulty:** Beginner to Intermediate

---

## 📋 Before You Start

### Step 1: Connect to the Database
```sql
USE TechCorpDB;
GO
```

### Step 2: Verify Your Data (Optional)
Run these queries to see what data you're working with:

```sql
-- Count of records in key tables
SELECT 'Employees' AS TableName, COUNT(*) AS RecordCount FROM Employees WHERE IsActive = 1
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments WHERE IsActive = 1
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers WHERE IsActive = 1
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;
```

---

## 📊 Part 1: Self-Contained Subqueries (Warm-Up)

These exercises use subqueries that can run independently.

### Exercise 1.1: Above Average Salary ⭐ (Easy)

**Task:** Find all employees whose salary is above the company average.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, BaseSalary

<details>
<summary>💡 Click for Hint</summary>

Use a subquery with `AVG(BaseSalary)` in the WHERE clause.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary
FROM Employees
WHERE BaseSalary > (
    SELECT AVG(BaseSalary) 
    FROM Employees 
    WHERE IsActive = 1
)
AND IsActive = 1
ORDER BY BaseSalary DESC;
```

</details>

---

### Exercise 1.2: Newest Hire ⭐ (Easy)

**Task:** Find the most recently hired employee.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, JobTitle, HireDate

<details>
<summary>💡 Click for Hint</summary>

Use `MAX(HireDate)` in a subquery to find the most recent date.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    FirstName,
    LastName,
    JobTitle,
    HireDate
FROM Employees
WHERE HireDate = (
    SELECT MAX(HireDate) 
    FROM Employees 
    WHERE IsActive = 1
)
AND IsActive = 1;
```

</details>

---

### Exercise 1.3: High-Budget Departments ⭐⭐ (Medium)

**Task:** Find departments with budgets higher than the average department budget.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** DepartmentName, Budget

<details>
<summary>💡 Click for Hint</summary>

Calculate `AVG(Budget)` from the Departments table and compare.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    DepartmentName,
    Budget
FROM Departments
WHERE Budget > (
    SELECT AVG(Budget) 
    FROM Departments 
    WHERE IsActive = 1
)
AND IsActive = 1
ORDER BY Budget DESC;
```

</details>

---

### Exercise 1.4: Employees in Large Departments ⭐⭐ (Medium)

**Task:** Find employees who work in departments with budgets over $500,000.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, DepartmentName, Budget

<details>
<summary>💡 Click for Hint</summary>

Use `IN` with a subquery that returns DepartmentIDs of high-budget departments.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    d.Budget
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.DepartmentID IN (
    SELECT DepartmentID
    FROM Departments
    WHERE Budget > 500000
    AND IsActive = 1
)
AND e.IsActive = 1
ORDER BY d.Budget DESC, e.LastName;
```

</details>

---

## 📊 Part 2: Correlated Subqueries

These subqueries reference the outer query and run for each row.

### Exercise 2.1: Above Department Average ⭐⭐ (Medium)

**Task:** Find employees who earn more than the average salary IN THEIR OWN DEPARTMENT.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, DepartmentName, BaseSalary, DepartmentAverage

<details>
<summary>💡 Click for Hint</summary>

Use a correlated subquery where `e_inner.DepartmentID = e_outer.DepartmentID`.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary,
    (SELECT AVG(e_inner.BaseSalary)
     FROM Employees e_inner
     WHERE e_inner.DepartmentID = e.DepartmentID
       AND e_inner.IsActive = 1) AS DepartmentAverage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > (
    SELECT AVG(e_inner.BaseSalary)
    FROM Employees e_inner
    WHERE e_inner.DepartmentID = e.DepartmentID
      AND e_inner.IsActive = 1
)
AND e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

</details>

---

### Exercise 2.2: Highest Paid in Each Department ⭐⭐ (Medium)

**Task:** Find the highest-paid employee in each department.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, DepartmentName, BaseSalary

<details>
<summary>💡 Click for Hint</summary>

Use `MAX(BaseSalary)` in a correlated subquery to find the max salary for each department.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary = (
    SELECT MAX(e_inner.BaseSalary)
    FROM Employees e_inner
    WHERE e_inner.DepartmentID = e.DepartmentID
      AND e_inner.IsActive = 1
)
AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

</details>

---

### Exercise 2.3: Employee Project Count ⭐⭐⭐ (Medium-Hard)

**Task:** Show each employee with the number of projects they're assigned to, only including employees with more than 1 project.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, JobTitle, ProjectCount

<details>
<summary>💡 Click for Hint</summary>

Use a correlated subquery with COUNT(*) and filter with HAVING or in WHERE clause.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    (SELECT COUNT(*)
     FROM EmployeeProjects ep
     WHERE ep.EmployeeID = e.EmployeeID
       AND ep.IsActive = 1) AS ProjectCount
FROM Employees e
WHERE (
    SELECT COUNT(*)
    FROM EmployeeProjects ep
    WHERE ep.EmployeeID = e.EmployeeID
      AND ep.IsActive = 1
) > 1
AND e.IsActive = 1
ORDER BY ProjectCount DESC, e.LastName;
```

</details>

---

## 📊 Part 3: EXISTS and NOT EXISTS

These exercises use EXISTS to check for the presence/absence of related records.

### Exercise 3.1: Customers with Orders ⭐⭐ (Medium)

**Task:** Find all customers who have placed at least one order.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** CustomerName, City

<details>
<summary>💡 Click for Hint</summary>

Use EXISTS with a subquery checking the Orders table.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    c.CustomerName,
    c.City
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
)
AND c.IsActive = 1
ORDER BY c.CustomerName;
```

</details>

---

### Exercise 3.2: Customers WITHOUT Orders ⭐⭐ (Medium)

**Task:** Find customers who have NEVER placed an order (potential leads!).

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** CustomerName, City, CreatedDate

<details>
<summary>💡 Click for Hint</summary>

Use NOT EXISTS instead of EXISTS.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    c.CustomerName,
    c.City,
    c.CreatedDate
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
)
AND c.IsActive = 1
ORDER BY c.CreatedDate DESC;
```

</details>

---

### Exercise 3.3: Employees Without Projects ⭐⭐ (Medium)

**Task:** Find active employees who are not assigned to any active project.

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** FirstName, LastName, JobTitle, DepartmentName

<details>
<summary>💡 Click for Hint</summary>

Use NOT EXISTS to find employees with no matching EmployeeProjects records.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE NOT EXISTS (
    SELECT 1
    FROM EmployeeProjects ep
    WHERE ep.EmployeeID = e.EmployeeID
      AND ep.IsActive = 1
)
AND e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;
```

</details>

---

### Exercise 3.4: Managers with Direct Reports ⭐⭐⭐ (Medium-Hard)

**Task:** Find employees who are managers (have at least one person reporting to them).

**Your Query:**
```sql
-- Write your query here:



```

**Expected columns:** ManagerID (as EmployeeID), FirstName, LastName, JobTitle

<details>
<summary>💡 Click for Hint</summary>

Check if EXISTS any employee where ManagerID equals this employee's EmployeeID.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    m.EmployeeID,
    m.FirstName,
    m.LastName,
    m.JobTitle
FROM Employees m
WHERE EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.ManagerID = m.EmployeeID
      AND e.IsActive = 1
)
AND m.IsActive = 1
ORDER BY m.LastName;
```

</details>

---

## 📊 Part 4: Challenge Exercises

### Challenge 4.1: Comprehensive Employee Report ⭐⭐⭐ (Hard)

**Task:** Create a report showing each employee with:
- Their salary
- Their department's average salary
- How much they differ from department average
- How many projects they have

**Your Query:**
```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary,
    (SELECT AVG(e_inner.BaseSalary)
     FROM Employees e_inner
     WHERE e_inner.DepartmentID = e.DepartmentID
       AND e_inner.IsActive = 1) AS DeptAvgSalary,
    e.BaseSalary - (
        SELECT AVG(e_inner.BaseSalary)
        FROM Employees e_inner
        WHERE e_inner.DepartmentID = e.DepartmentID
          AND e_inner.IsActive = 1
    ) AS DifferenceFromAvg,
    (SELECT COUNT(*)
     FROM EmployeeProjects ep
     WHERE ep.EmployeeID = e.EmployeeID
       AND ep.IsActive = 1) AS ProjectCount
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

</details>

---

### Challenge 4.2: Department Analysis ⭐⭐⭐ (Hard)

**Task:** Find departments where:
1. The department has at least one employee
2. The department has at least one employee earning above the company average
3. Show the department name and count of above-average earners

**Your Query:**
```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    d.DepartmentName,
    (SELECT COUNT(*)
     FROM Employees e
     WHERE e.DepartmentID = d.DepartmentID
       AND e.BaseSalary > (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1)
       AND e.IsActive = 1) AS AboveAverageCount
FROM Departments d
WHERE EXISTS (
    -- Department has employees
    SELECT 1 FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID AND e.IsActive = 1
)
AND EXISTS (
    -- Has above-average earners
    SELECT 1 FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID
      AND e.BaseSalary > (SELECT AVG(BaseSalary) FROM Employees WHERE IsActive = 1)
      AND e.IsActive = 1
)
AND d.IsActive = 1
ORDER BY AboveAverageCount DESC;
```

</details>

---

### Challenge 4.3: Customer Order Analysis ⭐⭐⭐⭐ (Very Hard)

**Task:** Find customers who:
1. Have placed orders
2. Their most recent order was more than 60 days ago
3. Show the customer name and their last order date

**Your Query:**
```sql
-- Write your query here:



```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    c.CustomerName,
    (SELECT MAX(o.OrderDate)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID) AS LastOrderDate,
    DATEDIFF(DAY, 
        (SELECT MAX(o.OrderDate) FROM Orders o WHERE o.CustomerID = c.CustomerID),
        GETDATE()
    ) AS DaysSinceLastOrder
FROM Customers c
WHERE EXISTS (
    -- Has placed orders
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
)
AND NOT EXISTS (
    -- No orders in last 60 days
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID
      AND o.OrderDate >= DATEADD(DAY, -60, GETDATE())
)
AND c.IsActive = 1
ORDER BY LastOrderDate DESC;
```

</details>

---

## 📋 Lab Summary Checklist

Check off what you've practiced:

- [ ] ⭐ Scalar subqueries (returning one value)
- [ ] ⭐ Using AVG, MAX, MIN in subqueries
- [ ] ⭐⭐ Multi-value subqueries with IN
- [ ] ⭐⭐ Correlated subqueries with department comparisons
- [ ] ⭐⭐ EXISTS for checking record existence
- [ ] ⭐⭐ NOT EXISTS for finding missing records
- [ ] ⭐⭐⭐ Subqueries in SELECT clause
- [ ] ⭐⭐⭐ Combining multiple subquery types

---

## 🎯 Self-Assessment

**Rate your confidence (1-5):**

| Skill | Rating |
|-------|--------|
| Self-contained subqueries | ___ |
| Correlated subqueries | ___ |
| EXISTS predicate | ___ |
| NOT EXISTS predicate | ___ |
| Choosing the right subquery type | ___ |

**If you scored below 3 on any skill, review that lesson before moving on!**

---

## 🚀 What's Next?

Congratulations on completing the Subqueries Lab! You've built strong foundations in:
- Writing nested queries
- Comparing values to aggregates
- Finding related and unrelated records

**Next Up:** Module 11 - Using Table Expressions (Views, CTEs, Derived Tables)

These build on what you've learned and give you even more powerful ways to organize and reuse complex queries!
