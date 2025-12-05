# Lesson 2: Using Inline Table-Valued Functions (TVFs) - Beginner Guide

## 🎯 What You'll Learn (Complete Beginner Level)

Welcome! In Lesson 1, you learned about Views - saved queries you can use like tables. Now we'll learn about **Inline Table-Valued Functions (TVFs)** - these are like views that can accept **parameters**!

---

## 📖 What is an Inline TVF? (The Simple Explanation)

### Real-World Analogy: The Customizable Report

Think about the difference:

**View (Fixed Report):**
"Show me ALL employees in the company."

**Inline TVF (Customizable Report):**
"Show me employees in **[whatever department I specify]**."

```
┌─────────────────────────────────────────────────────────────────┐
│              VIEW vs INLINE TVF                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  VIEW (No Parameters):                                          │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT * FROM vw_AllEmployees;             │                │
│  │                                             │                │
│  │  Always returns the same structure          │                │
│  │  Can only filter AFTER with WHERE           │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  INLINE TVF (With Parameters):                                  │
│  ┌─────────────────────────────────────────────┐                │
│  │  SELECT * FROM fn_GetDepartmentEmployees(1) │                │
│  │  SELECT * FROM fn_GetDepartmentEmployees(2) │                │
│  │  SELECT * FROM fn_GetDepartmentEmployees(3) │                │
│  │                                             │                │
│  │  Accepts input → Returns customized results │                │
│  └─────────────────────────────────────────────┘                │
│                                                                 │
│  💡 TVFs are like VIEWS with PARAMETERS!                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Characteristics of Inline TVFs

| Feature | Description |
|---------|-------------|
| **Parameters** | Can accept input values to customize results |
| **Returns Table** | Returns a table (multiple rows and columns) |
| **Single SELECT** | Contains exactly ONE SELECT statement |
| **No BEGIN/END** | No block structure needed |
| **Called in FROM** | Use in FROM clause like a table |
| **Reusable** | Create once, call with different parameters |

---

## 🎓 Part 1: Creating Your First Inline TVF

### The Basic Syntax

```sql
CREATE FUNCTION function_name (@parameter1 datatype, @parameter2 datatype)
RETURNS TABLE
AS
RETURN (
    SELECT columns
    FROM tables
    WHERE conditions using @parameter1, @parameter2
);
```

### Example 1.1: Get Employees by Department

**Task:** Create a function that returns employees for a specific department.

```sql
-- Create the function
CREATE FUNCTION fn_GetEmployeesByDepartment (@DepartmentID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    WHERE e.DepartmentID = @DepartmentID    -- Use the parameter!
      AND e.IsActive = 1
);
GO
```

### Using the Function

```sql
-- Get employees from Department 1 (Engineering)
SELECT * FROM fn_GetEmployeesByDepartment(1);

-- Get employees from Department 2 (Marketing)
SELECT * FROM fn_GetEmployeesByDepartment(2);

-- You can still add WHERE, ORDER BY, etc.
SELECT FirstName, LastName, BaseSalary 
FROM fn_GetEmployeesByDepartment(1)
WHERE BaseSalary > 70000
ORDER BY BaseSalary DESC;
```

**Expected Result (for Department 1):**
| EmployeeID | FirstName | LastName | JobTitle        | BaseSalary | HireDate   |
|------------|-----------|----------|-----------------|------------|------------|
| 3001       | Sarah     | Johnson  | Lead Developer  | 95000.00   | 2019-03-15 |
| 3005       | Michael   | Chen     | Senior Developer| 85000.00   | 2020-06-01 |
| 3012       | Emily     | Davis    | Developer       | 72000.00   | 2022-01-10 |

---

### Example 1.2: Get Employees by Salary Range

**Task:** Create a function that accepts minimum and maximum salary values.

```sql
CREATE FUNCTION fn_GetEmployeesBySalaryRange 
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
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.BaseSalary BETWEEN @MinSalary AND @MaxSalary
      AND e.IsActive = 1
);
GO
```

**Using it:**
```sql
-- Find employees earning between $60,000 and $80,000
SELECT * FROM fn_GetEmployeesBySalaryRange(60000, 80000);

-- Find high earners ($100,000+)
SELECT * FROM fn_GetEmployeesBySalaryRange(100000, 999999);

-- Count employees in each salary range
SELECT COUNT(*) AS MidRangeCount
FROM fn_GetEmployeesBySalaryRange(50000, 75000);
```

---

## 🎓 Part 2: More Practical Examples

### Example 2.1: Get Orders by Date Range

**Task:** Create a function to retrieve orders within a specific date range.

```sql
CREATE FUNCTION fn_GetOrdersByDateRange
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        o.OrderID,
        o.OrderNumber,
        c.CustomerName,
        o.OrderDate,
        o.TotalAmount,
        o.OrderStatus
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
);
GO
```

**Using it:**
```sql
-- Orders from last month
SELECT * 
FROM fn_GetOrdersByDateRange('2024-11-01', '2024-11-30')
ORDER BY OrderDate;

-- Orders from this year
SELECT CustomerName, SUM(TotalAmount) AS TotalSpent
FROM fn_GetOrdersByDateRange('2024-01-01', '2024-12-31')
GROUP BY CustomerName
ORDER BY TotalSpent DESC;
```

---

### Example 2.2: Get Projects by Status

**Task:** Create a function that returns projects filtered by status.

```sql
CREATE FUNCTION fn_GetProjectsByStatus (@Status VARCHAR(20))
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.ProjectID,
        p.ProjectName,
        p.Budget,
        p.StartDate,
        p.EndDate,
        pm.FirstName + ' ' + pm.LastName AS ProjectManager,
        (SELECT COUNT(*) 
         FROM EmployeeProjects ep 
         WHERE ep.ProjectID = p.ProjectID AND ep.IsActive = 1) AS TeamSize
    FROM Projects p
    LEFT JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
    WHERE p.Status = @Status
       OR @Status = 'All'  -- Special: 'All' returns everything
);
GO
```

**Using it:**
```sql
-- Get only active projects
SELECT * FROM fn_GetProjectsByStatus('Active');

-- Get completed projects
SELECT * FROM fn_GetProjectsByStatus('Completed');

-- Get ALL projects (special value)
SELECT * FROM fn_GetProjectsByStatus('All');
```

---

### Example 2.3: Get Top N Earners

**Task:** Create a function that returns the top N highest-paid employees.

```sql
CREATE FUNCTION fn_GetTopEarners (@TopN INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (@TopN)
        e.FirstName,
        e.LastName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        RANK() OVER (ORDER BY e.BaseSalary DESC) AS SalaryRank
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    ORDER BY e.BaseSalary DESC
);
GO
```

**Using it:**
```sql
-- Top 5 earners
SELECT * FROM fn_GetTopEarners(5);

-- Top 10 earners
SELECT * FROM fn_GetTopEarners(10);

-- Top 3 earners for a bonus list
SELECT FirstName, LastName, BaseSalary 
FROM fn_GetTopEarners(3);
```

---

## 🎓 Part 3: Using TVFs with JOINs

### Joining TVF Results with Other Tables

```sql
-- Get Engineering employees and join with their skills
SELECT 
    emp.FirstName,
    emp.LastName,
    emp.JobTitle,
    s.SkillName,
    es.ProficiencyLevel
FROM fn_GetEmployeesByDepartment(1) emp  -- Department 1 = Engineering
INNER JOIN EmployeeSkills es ON emp.EmployeeID = es.EmployeeID
INNER JOIN Skills s ON es.SkillID = s.SkillID
WHERE es.IsActive = 1
ORDER BY emp.LastName, s.SkillName;
```

### Using CROSS APPLY with TVFs

`CROSS APPLY` lets you call a TVF for each row:

```sql
-- For each department, show their employees using our TVF
SELECT 
    d.DepartmentName,
    emp.FirstName,
    emp.LastName,
    emp.BaseSalary
FROM Departments d
CROSS APPLY fn_GetEmployeesByDepartment(d.DepartmentID) emp
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, emp.BaseSalary DESC;
```

---

## 🎓 Part 4: Managing TVFs

### Viewing Existing Functions

```sql
-- List all table-valued functions
SELECT 
    name AS FunctionName,
    create_date,
    modify_date
FROM sys.objects
WHERE type = 'IF'  -- IF = Inline Table-Valued Function
ORDER BY name;

-- See the definition of a function
EXEC sp_helptext 'fn_GetEmployeesByDepartment';
```

### Modifying a Function

```sql
-- Use ALTER to change an existing function
ALTER FUNCTION fn_GetEmployeesByDepartment (@DepartmentID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        e.WorkEmail          -- Added this column
    FROM Employees e
    WHERE e.DepartmentID = @DepartmentID
      AND e.IsActive = 1
);
GO
```

### Deleting a Function

```sql
-- Remove a function
DROP FUNCTION fn_GetEmployeesByDepartment;

-- Safer version
IF OBJECT_ID('fn_GetEmployeesByDepartment', 'IF') IS NOT NULL
    DROP FUNCTION fn_GetEmployeesByDepartment;
```

---

## 📊 Visual: TVF vs View vs Stored Procedure

```
┌─────────────────────────────────────────────────────────────────┐
│              COMPARISON: WHEN TO USE WHAT?                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  VIEW:                                                          │
│  ├── No parameters                                              │
│  ├── Used like a table: SELECT * FROM view_name                 │
│  ├── Best for: Fixed, reusable queries                          │
│  └── Example: vw_ActiveEmployees                                │
│                                                                 │
│  INLINE TVF:                                                    │
│  ├── Has parameters                                             │
│  ├── Used like a table: SELECT * FROM fn_Name(params)           │
│  ├── Best for: Parameterized queries returning tables           │
│  └── Example: fn_GetEmployeesByDepartment(1)                    │
│                                                                 │
│  STORED PROCEDURE:                                              │
│  ├── Has parameters                                             │
│  ├── Called with: EXEC sp_Name params                           │
│  ├── Can do INSERT, UPDATE, DELETE                              │
│  ├── Can have multiple SELECT statements                        │
│  └── Best for: Complex operations, data modifications           │
│                                                                 │
│  ┌──────────────────────────────────────────────────┐           │
│  │  Quick Decision Guide:                           │           │
│  │                                                  │           │
│  │  Need parameters?                                │           │
│  │  ├── NO → Use a VIEW                            │           │
│  │  └── YES → Need to modify data?                 │           │
│  │            ├── NO → Use INLINE TVF              │           │
│  │            └── YES → Use STORED PROCEDURE       │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Practice Exercises

### Exercise 1: Employees by Hire Year (Easy)

Create a function that returns employees hired in a specific year.

```sql
-- Your answer:
CREATE FUNCTION fn_GetEmployeesByHireYear (@Year INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.HireDate,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE YEAR(e.HireDate) = @Year
      AND e.IsActive = 1
);
GO

-- Test it:
-- SELECT * FROM fn_GetEmployeesByHireYear(2023);
```

### Exercise 2: Customers by City (Easy)

Create a function that returns customers in a specific city.

```sql
-- Your answer:
CREATE FUNCTION fn_GetCustomersByCity (@City VARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT 
        CustomerName,
        ContactFirstName,
        ContactLastName,
        PrimaryEmail,
        PrimaryPhone
    FROM Customers
    WHERE City = @City
      AND IsActive = 1
);
GO

-- Test it:
-- SELECT * FROM fn_GetCustomersByCity('New York');
```

### Exercise 3: High-Value Orders (Medium)

Create a function that returns orders above a specified amount.

```sql
-- Your answer:
CREATE FUNCTION fn_GetHighValueOrders (@MinAmount MONEY)
RETURNS TABLE
AS
RETURN (
    SELECT 
        o.OrderID,
        o.OrderNumber,
        c.CustomerName,
        o.OrderDate,
        o.TotalAmount,
        o.OrderStatus
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.TotalAmount >= @MinAmount
);
GO

-- Test it:
-- SELECT * FROM fn_GetHighValueOrders(5000);
```

---

## 🎯 Key Takeaways

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMEMBER THESE POINTS!                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Inline TVFs are like Views WITH parameters                  │
│                                                                 │
│  ✅ Syntax: CREATE FUNCTION name (@param TYPE) RETURNS TABLE    │
│                                                                 │
│  ✅ Contains a single SELECT statement in RETURN ( ... )        │
│                                                                 │
│  ✅ Use them in FROM clause: SELECT * FROM fn_Name(value)       │
│                                                                 │
│  ✅ Can JOIN with other tables or use in subqueries             │
│                                                                 │
│  ✅ Great for reusable parameterized queries                    │
│                                                                 │
│  ✅ Naming convention: fn_ prefix (e.g., fn_GetEmployees)       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 What's Next?

Great work! You've learned how to create and use Inline TVFs. In the next lesson, we'll learn about **Derived Tables** - subqueries used in the FROM clause that don't need to be saved to the database.

**Next Up:** Lesson 3 - Using Derived Tables
