# Lesson 1: Using Views - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! This lesson introduces **Views** - one of the most useful features in SQL databases. Views help you simplify complex queries and reuse them easily. Let's learn step by step!

---

## 📖 What is a View? (The Simple Explanation)

### Real-World Analogy: The Report Template

Imagine you're a manager who needs the same report every week:
- Employee names
- Their departments
- Their salaries
- How long they've been with the company

**Without a View:** You'd have to write the same complex query every single week.

**With a View:** You save the query once with a name, then just say "show me the report" anytime!

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT IS A VIEW?                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   A VIEW is like a SAVED QUERY with a name.                     │
│                                                                 │
│   ┌─────────────────────────────────────────────┐               │
│   │           Complex Query                      │               │
│   │  SELECT e.FirstName, e.LastName,            │               │
│   │         d.DepartmentName, e.BaseSalary,     │               │
│   │         DATEDIFF(YEAR, e.HireDate, GETDATE())│               │
│   │  FROM Employees e                           │               │
│   │  JOIN Departments d ON ...                  │               │
│   │  WHERE e.IsActive = 1                       │               │
│   └─────────────────────────────────────────────┘               │
│                           │                                     │
│                           ▼ Save as View                        │
│                                                                 │
│   ┌─────────────────────────────────────────────┐               │
│   │   vw_EmployeeReport                         │               │
│   │   (Stored in database - use anytime!)       │               │
│   └─────────────────────────────────────────────┘               │
│                           │                                     │
│                           ▼ Use simply as:                      │
│                                                                 │
│   SELECT * FROM vw_EmployeeReport;                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Key Points About Views

| Feature | Description |
|---------|-------------|
| **Virtual Table** | A view looks and acts like a table, but doesn't store data |
| **Always Fresh** | Views show current data from the underlying tables |
| **Reusable** | Create once, use many times |
| **Security** | Can hide sensitive columns from users |
| **Simplification** | Turns complex queries into simple table names |

---

## 🎓 Part 1: Creating Your First View

### The Basic Syntax

```sql
CREATE VIEW view_name
AS
    SELECT columns
    FROM tables
    WHERE conditions;
```

### Example 1.1: A Simple Employee List View

**Task:** Create a view that shows active employees with their department names.

```sql
-- Step 1: First, let's write the query we want to save
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;

-- Step 2: Now wrap it in CREATE VIEW
CREATE VIEW vw_ActiveEmployees
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
GO
```

### Using the View

Once created, use it just like a table:

```sql
-- See all employees
SELECT * FROM vw_ActiveEmployees;

-- Filter just like a regular table
SELECT * FROM vw_ActiveEmployees
WHERE DepartmentName = 'Engineering';

-- Only certain columns
SELECT FirstName, LastName, BaseSalary 
FROM vw_ActiveEmployees
ORDER BY BaseSalary DESC;
```

---

### Example 1.2: Employee Summary View

**Task:** Create a view that shows employee information with calculated fields.

```sql
CREATE VIEW vw_EmployeeSummary
AS
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate,
        -- Calculate years of service
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        -- Salary level category
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 'Executive'
            WHEN e.BaseSalary >= 70000 THEN 'Senior'
            WHEN e.BaseSalary >= 50000 THEN 'Mid-Level'
            ELSE 'Entry Level'
        END AS SalaryLevel
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
GO
```

**Using it:**
```sql
-- Who are our senior-level employees?
SELECT FullName, DepartmentName, BaseSalary
FROM vw_EmployeeSummary
WHERE SalaryLevel = 'Senior'
ORDER BY YearsOfService DESC;
```

**Expected Result:**
| FullName       | DepartmentName | BaseSalary |
|----------------|----------------|------------|
| Michael Chen   | Engineering    | 98000.00   |
| Emily Davis    | Sales          | 85000.00   |
| James Wilson   | Marketing      | 78000.00   |

---

## 🎓 Part 2: Views for Department Reports

### Example 2.1: Department Statistics View

**Task:** Create a view that summarizes each department's statistics.

```sql
CREATE VIEW vw_DepartmentStats
AS
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Budget,
        d.Location,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AverageSalary,
        MIN(e.BaseSalary) AS MinSalary,
        MAX(e.BaseSalary) AS MaxSalary,
        SUM(e.BaseSalary) AS TotalSalaryExpense
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName, d.Budget, d.Location;
GO
```

**Using it:**
```sql
-- Which departments have more than 10 employees?
SELECT DepartmentName, EmployeeCount, AverageSalary
FROM vw_DepartmentStats
WHERE EmployeeCount > 10
ORDER BY EmployeeCount DESC;

-- Compare salary expense to budget
SELECT 
    DepartmentName,
    Budget,
    TotalSalaryExpense,
    Budget - TotalSalaryExpense AS RemainingBudget
FROM vw_DepartmentStats;
```

---

### Example 2.2: Project Overview View

```sql
CREATE VIEW vw_ProjectOverview
AS
    SELECT 
        p.ProjectID,
        p.ProjectName,
        p.Budget AS ProjectBudget,
        p.StartDate,
        p.EndDate,
        -- Calculate project duration
        DATEDIFF(DAY, p.StartDate, ISNULL(p.EndDate, GETDATE())) AS DurationDays,
        -- Project manager info
        pm.FirstName + ' ' + pm.LastName AS ProjectManager,
        d.DepartmentName AS ManagerDepartment,
        -- Count team members
        (SELECT COUNT(*) 
         FROM EmployeeProjects ep 
         WHERE ep.ProjectID = p.ProjectID AND ep.IsActive = 1) AS TeamSize
    FROM Projects p
    LEFT JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    LEFT JOIN Departments d ON pm.DepartmentID = d.DepartmentID;
GO
```

---

## 🎓 Part 3: Managing Views

### Viewing Existing Views

```sql
-- List all views in the database
SELECT name, create_date, modify_date
FROM sys.views
ORDER BY name;

-- See the definition of a specific view
EXEC sp_helptext 'vw_ActiveEmployees';
```

### Modifying a View

Use `ALTER VIEW` to change an existing view:

```sql
-- Add the HireDate column to our view
ALTER VIEW vw_ActiveEmployees
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate          -- Added this column
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
GO
```

### Deleting a View

```sql
-- Remove a view when you no longer need it
DROP VIEW vw_ActiveEmployees;

-- Safer version - check if exists first
IF OBJECT_ID('vw_ActiveEmployees', 'V') IS NOT NULL
    DROP VIEW vw_ActiveEmployees;
```

---

## 🎓 Part 4: Views for Security

### Hiding Sensitive Columns

Views can show only non-sensitive data:

```sql
-- Full employee table has sensitive data (salary, personal email, etc.)
-- Create a view that hides sensitive columns

CREATE VIEW vw_EmployeeDirectory
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.WorkEmail,        -- OK to share
        e.WorkPhone         -- OK to share
        -- NOT including: BaseSalary, PersonalEmail, BirthDate, etc.
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
GO

-- Now regular users can query vw_EmployeeDirectory without seeing salaries
```

### Row-Level Security

Views can filter rows based on criteria:

```sql
-- View for Engineering department only
CREATE VIEW vw_EngineeringEmployees
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = 'Engineering'
      AND e.IsActive = 1;
GO
```

---

## 📊 Visual: View Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    HOW VIEWS WORK                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Physical Tables (Store actual data):                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Employees  │  │ Departments │  │   Projects  │              │
│  │  (150 rows) │  │  (10 rows)  │  │  (25 rows)  │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│         │               │               │                       │
│         └───────────────┼───────────────┘                       │
│                         │                                       │
│                         ▼                                       │
│  Views (Virtual tables - NO data stored):                       │
│  ┌─────────────────────────────────────────┐                    │
│  │  vw_EmployeeSummary                     │                    │
│  │  - Combines Employee + Department       │                    │
│  │  - Adds calculated columns              │                    │
│  │  - Filters active employees only        │                    │
│  │                                         │                    │
│  │  When you query this view, SQL Server:  │                    │
│  │  1. Runs the underlying SELECT          │                    │
│  │  2. Returns fresh data from tables      │                    │
│  │  3. No stored data = always current!    │                    │
│  └─────────────────────────────────────────┘                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚠️ Important Tips

### Tip 1: Naming Convention

Use a prefix to identify views:
- `vw_` prefix: `vw_ActiveEmployees`
- `View_` prefix: `View_DepartmentStats`

### Tip 2: Views Don't Store Data

```sql
-- If you update the Employees table:
UPDATE Employees SET BaseSalary = 80000 WHERE EmployeeID = 3001;

-- The view immediately reflects this change!
-- No need to "refresh" the view
SELECT * FROM vw_ActiveEmployees WHERE EmployeeID = 3001;
```

### Tip 3: Views Can Use Other Views

```sql
-- Base view
CREATE VIEW vw_Employees AS ...;

-- View using another view
CREATE VIEW vw_HighPaidEmployees
AS
    SELECT * FROM vw_Employees
    WHERE BaseSalary > 80000;
GO
```

### Tip 4: Performance Consideration

Views are re-executed each time you query them. For very complex views with millions of rows, consider **indexed views** (advanced topic).

---

## ✅ Practice Exercises

### Exercise 1: Customer Contact View (Easy)

Create a view named `vw_CustomerContacts` that shows:
- CustomerName
- ContactFirstName
- ContactLastName
- PrimaryEmail
- PrimaryPhone
- City

```sql
-- Your answer:
CREATE VIEW vw_CustomerContacts
AS
    SELECT 
        CustomerName,
        ContactFirstName,
        ContactLastName,
        PrimaryEmail,
        PrimaryPhone,
        City
    FROM Customers
    WHERE IsActive = 1;
GO
```

### Exercise 2: High Salary View (Easy)

Create a view named `vw_HighEarners` showing employees earning over $75,000.

```sql
-- Your answer:
CREATE VIEW vw_HighEarners
AS
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.BaseSalary > 75000
      AND e.IsActive = 1;
GO
```

### Exercise 3: Order Summary View (Medium)

Create a view that shows orders with customer names and total amounts.

```sql
-- Your answer:
CREATE VIEW vw_OrderSummary
AS
    SELECT 
        o.OrderID,
        o.OrderNumber,
        c.CustomerName,
        o.OrderDate,
        o.TotalAmount,
        o.OrderStatus
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
GO
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Views are saved queries that act like virtual tables        │
│                                                                 │
│  ✅ Views don't store data - they always show current data      │
│                                                                 │
│  ✅ Create views with CREATE VIEW, modify with ALTER VIEW       │
│                                                                 │
│  ✅ Views simplify complex queries - write once, use many times │
│                                                                 │
│  ✅ Views enhance security by hiding sensitive columns          │
│                                                                 │
│  ✅ Use a naming convention like vw_ prefix                     │
│                                                                 │
│  ✅ You can query views just like regular tables                │
│     (SELECT, WHERE, ORDER BY, JOIN, etc.)                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Excellent! You've learned how to create and use Views. In the next lesson, we'll learn about **Inline Table-Valued Functions (TVFs)** - these are like views, but they can accept parameters!

**Next Up:** Lesson 2 - Using Inline TVFs
