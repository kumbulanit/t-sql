# Lesson 1: Writing Self-Contained Subqueries

## Overview
Self-contained subqueries are independent queries nested within another SQL statement that can execute on their own without referencing the outer query. These subqueries are executed once and return results that the outer query uses for comparison or filtering. This lesson covers the fundamentals of writing effective self-contained subqueries using TechCorp's business data.

## 🏢 TechCorp Business Context
**Subqueries in Business Intelligence:**
- **Employee Analysis**: Finding employees above average BaseSalary, top performers by d.DepartmentName
- **Departmental Reporting**: Identifying departments with specific characteristics
- **Project Management**: Locating projects with certain budget or timeline criteria
- **Customer Intelligence**: Finding high-value customers, frequent buyers
- **Performance Metrics**: Comparing individual performance against company benchmarks

### 📋 TechCorp Schema Quick Reference

**Key Tables for Subquery Examples:**
```sql
Employees: e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive
Departments: d.DepartmentID, d.DepartmentName, d.Budget, IsActive
Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, Status
Customers: CustomerID, CompanyName, IndustryID, IsActive
Orders: OrderID, CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
```

**🎯 Beginner's Key:** 
- **e.JobTitle** (not Title) - Employee's position in company
- **Status** (not IsActive) - Project status like 'Active', 'Completed', 'On Hold'
- **IsActive** - Binary indicator (1/0) for employee/customer active status

## What are Self-Contained Subqueries?

### Definition and Characteristics
A self-contained subquery is a nested query that:
- **Executes independently** of the outer query
- **Returns results once** before the outer query processes
- **Can be tested separately** by running just the subquery
- **Does not reference** columns from the outer query

### Subquery Execution Order
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SELF-CONTAINED SUBQUERY EXECUTION                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Step 1: Execute Inner Query (Subquery)                                    │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT AVG(e.BaseSalary)              │  →  Returns: 75000                │
│  │ FROM Employees e                      │                                   │
│  │ WHERE IsActive = 1                  │                                   │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  Step 2: Use Result in Outer Query                                         │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT e.FirstName, e.LastName, e.BaseSalary │                               │
│  │ FROM Employees e                      │                                   │
│  │ WHERE e.BaseSalary > 75000           │  ← Subquery result substituted    │
│  │   AND IsActive = 1                 │                                   │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  Result: All employees earning above company average                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Types of Self-Contained Subqueries

### 1. Scalar Subqueries
Return a single value (one row, one column)

#### TechCorp Example: Above Average BaseSalary
```sql
-- Find employees earning above company average
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary - (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1) AS SalaryDifferenceFromAvg
FROM Employees e
WHERE e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1)
  AND IsActive = 1
ORDER BY e.BaseSalary DESC;
```

#### TechCorp Example: d.DepartmentName d.Budget Analysis
```sql
-- Find departments with budgets above company average
SELECT d.DepartmentName,
    d.Budget,
    FORMAT(d.Budget, 'C') AS FormattedBudget
FROM Departments d
WHERE d.Budget > (
    SELECT AVG(d.Budget) 
    FROM Departments d 
    WHERE d.Budget IS NOT NULL 
      AND IsActive = 1
)
  AND IsActive = 1
ORDER BY d.Budget DESC;
```

### 2. Multi-Value Subqueries
Return multiple values (multiple rows, single column)

#### TechCorp Example: Employees in High-Budget Departments
```sql
-- Find employees working in departments with budgets over $500,000
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName,
    d.Budget
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.d.DepartmentID IN (
    SELECT d.DepartmentID
    FROM Departments d
    WHERE d.Budget > 500000
      AND IsActive = 1
)
  AND e.IsActive = 1
ORDER BY d.Budget DESC, e.LastName;
```

#### TechCorp Example: Projects Managed by Senior Employees
```sql
-- Find projects managed by employees hired before 2020
SELECT 
    p.ProjectName,
    p.d.Budget,
    e.FirstName + ' ' + e.LastName AS ProjectManager,
    e.HireDate
FROM Projects p
INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
WHERE p.ProjectManagerID IN (
    SELECT e.EmployeeID
    FROM Employees e
    WHERE e.HireDate < '2020-01-01'
      AND IsActive = 1
)
  AND p.IsActive = 1
ORDER BY p.d.Budget DESC;
```

### 3. Table-Valued Subqueries
Return multiple rows and columns (used in FROM clause)

#### TechCorp Example: d.DepartmentName Summary Statistics
```sql
-- Create d.DepartmentName summary and find above-average departments
SELECT ds.d.DepartmentName,
    ds.EmployeeCount,
    ds.AverageSalary,
    ds.TotalSalaryBudget
FROM (
    SELECT d.DepartmentName,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AverageBaseSalary,
        SUM(e.BaseSalary) AS TotalSalaryBudget
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
    WHERE d.IsActive = 1 AND e.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
) ds
WHERE ds.EmployeeCount > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM Employees e
        WHERE IsActive = 1
        GROUP BY d.DepartmentID
    ) avg_calc
)
ORDER BY ds.AverageSalary DESC;
```

## Common Use Cases for Self-Contained Subqueries

### 1. Finding Records Above/Below Averages

#### TechCorp Example: High-Performing Employees
```sql
-- Employees earning in top 25% of company salaries
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.BaseSalary >= (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.BaseSalary)
    FROM Employees e
    WHERE IsActive = 1
)
  AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

### 2. Filtering Based on Aggregated Conditions

#### TechCorp Example: Large Customer Orders
```sql
-- Orders above average order value
SELECT 
    o.OrderID,
    c.CompanyName,
    e.FirstName + ' ' + e.LastName AS SalesRep,
    o.OrderDate,
    o.TotalAmount,
    FORMAT(o.TotalAmount, 'C') AS FormattedAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
WHERE o.TotalAmount > (
    SELECT AVG(TotalAmount)
    FROM Orders
    WHERE IsActive = 1
)
  AND o.IsActive = 1
ORDER BY o.TotalAmount DESC;
```

### 3. Finding Records with Specific Relationships

#### TechCorp Example: Managers with Large Teams
```sql
-- Find managers who manage more people than average
SELECT 
    mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,
    mgr.e.JobTitle,
    d.DepartmentName,
    team_size.DirectReports
FROM Employees e mgr
INNER JOIN Departments d ON mgr.d.DepartmentID = d.DepartmentID
INNER JOIN (
    SELECT 
        ManagerID,
        COUNT(*) AS DirectReports
    FROM Employees e
    WHERE ManagerID IS NOT NULL
      AND IsActive = 1
    GROUP BY ManagerID
) team_size ON mgr.e.EmployeeID = team_size.ManagerID
WHERE team_size.DirectReports > (
    SELECT AVG(team_count)
    FROM (
        SELECT COUNT(*) AS team_count
        FROM Employees e
        WHERE ManagerID IS NOT NULL
          AND IsActive = 1
        GROUP BY ManagerID
    ) avg_team_size
)
  AND mgr.IsActive = 1
ORDER BY team_size.DirectReports DESC;
```

## Advanced Self-Contained Subquery Patterns

### 1. Multiple Subqueries in Single Statement

#### TechCorp Example: Employee Performance Ranking
```sql
-- Complex employee analysis with multiple benchmarks
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    CASE 
        WHEN e.BaseSalary >= (SELECT MAX(e.BaseSalary) * 0.9 FROM Employees e WHERE IsActive = 1) 
            THEN 'Top Tier'
        WHEN e.BaseSalary >= (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1)
            THEN 'Above Average'
        WHEN e.BaseSalary >= (SELECT MIN(e.BaseSalary) FROM Employees e WHERE IsActive = 1)
            THEN 'Below Average'
        ELSE 'Entry Level'
    END AS SalaryTier,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= (
            SELECT AVG(DATEDIFF(YEAR, e.HireDate, GETDATE()))
            FROM Employees e 
            WHERE IsActive = 1
        ) THEN 'Veteran'
        ELSE 'Newer Employee'
    END AS TenureCategory
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY e.BaseSalary DESC, e.HireDate;
```

### 2. Subqueries with Aggregation Functions

#### TechCorp Example: d.DepartmentName Performance Analysis
```sql
-- Departments with above-average employee retention and high budgets
SELECT d.DepartmentName,
    d.Budget,
    dept_stats.EmployeeCount,
    dept_stats.AvgTenure,
    dept_stats.AvgSalary
FROM Departments d
INNER JOIN (
    SELECT 
        d.DepartmentID,
        COUNT(*) AS EmployeeCount,
        AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS AvgTenure,
        AVG(e.BaseSalary) AS AvgSalary
    FROM Employees e
    WHERE IsActive = 1
    GROUP BY d.DepartmentID
) dept_stats ON d.DepartmentID = dept_stats.d.DepartmentID
WHERE d.Budget > (
    SELECT AVG(d.Budget)
    FROM Departments d
    WHERE d.Budget IS NOT NULL AND IsActive = 1
)
  AND dept_stats.AvgTenure > (
    SELECT AVG(avg_tenure)
    FROM (
        SELECT AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS avg_tenure
        FROM Employees e
        WHERE IsActive = 1
        GROUP BY d.DepartmentID
    ) tenure_calc
)
  AND d.IsActive = 1
ORDER BY dept_stats.AvgSalary DESC;
```

## Performance Considerations

### 1. Subquery Optimization Tips
```sql
-- ✅ GOOD: Subquery with proper filtering
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary)
    FROM Employees e
    WHERE IsActive = 1  -- Filter in subquery
)
  AND IsActive = 1;

-- ❌ AVOID: Subquery without proper indexing support
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary * 1.1)  -- Function prevents index usage
    FROM Employees e
    WHERE IsActive = 1
);
```

### 2. Alternative Approaches
```sql
-- Subquery approach
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1)
  AND e.IsActive = 1;

-- Window function alternative (often more efficient)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM (
    SELECT 
        e.FirstName, 
        e.LastName, 
        e.BaseSalary,
        AVG(e.BaseSalary) OVER() AS AvgSalary
    FROM Employees e
    WHERE IsActive = 1
) ranked
WHERE e.BaseSalary > AvgSalary;
```

## Best Practices

### 1. Writing Maintainable Subqueries
- **Use clear aliases** for complex subqueries
- **Add comments** explaining business logic
- **Format consistently** for readability
- **Test subqueries independently** before embedding

### 2. Performance Guidelines
- **Filter early** in subqueries using WHERE clauses
- **Use appropriate indexes** on columns used in subqueries
- **Consider alternatives** like JOINs or window functions
- **Avoid correlated subqueries** when self-contained will work

### 3. Business Logic Validation
```sql
-- Always validate subquery results make business sense
-- Test the subquery alone first:
SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1;
-- Result: Should be a reasonable e.BaseSalary figure

-- Then use in main query:
SELECT COUNT(*) AS AboveAverageEmployees
FROM Employees e
WHERE e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1)
  AND IsActive = 1;
-- Result: Should be roughly half of total employees
```

## Common Pitfalls and Solutions

### 1. NULL Value Handling
```sql
-- ❌ PROBLEM: Subquery might return NULL
SELECT e.FirstName, e.LastName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > (SELECT MAX(e.BaseSalary) FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE DepartmentID = 999);
-- Returns no rows if d.DepartmentName 999 doesn't exist

-- ✅ SOLUTION: Handle NULLs explicitly
SELECT e.FirstName, e.LastName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > ISNULL((
    SELECT MAX(e.BaseSalary) 
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
    WHERE DepartmentID = 999
), 0);
```

### 2. Data Type Mismatches
```sql
-- ✅ GOOD: Ensure compatible data types
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE CAST(e.BaseSalary AS DECIMAL(10,2)) > (
    SELECT AVG(CAST(e.BaseSalary AS DECIMAL(10,2)))
    FROM Employees e
    WHERE IsActive = 1
);
```

## Summary

Self-contained subqueries are powerful tools for:

**Key Benefits:**
- **Independent execution** - can be tested separately
- **Reusable logic** - same subquery can be used multiple places
- **Clear business logic** - easy to understand intent
- **Performance predictability** - execute once per outer query

**Common Use Cases:**
- Finding records above/below averages
- Filtering based on aggregated conditions
- Creating dynamic comparison values
- Building complex business rules

**Best Practices:**
- Filter subqueries for performance
- Handle NULL values appropriately
- Test subqueries independently
- Consider alternative approaches for complex scenarios

**TechCorp Applications:**
- Employee performance analysis
- d.DepartmentName budget comparisons
- Project profitability analysis
- Customer value segmentation

Self-contained subqueries provide a foundation for more advanced SQL patterns while maintaining clarity and performance in business intelligence scenarios.