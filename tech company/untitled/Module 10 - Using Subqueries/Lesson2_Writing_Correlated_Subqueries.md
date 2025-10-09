# Lesson 2: Writing Correlated Subqueries

## Overview
Correlated subqueries are dependent queries that reference columns from the outer query, executing once for each row processed by the outer query. Unlike self-contained subqueries, correlated subqueries cannot run independently and are executed repeatedly. This lesson explores how to write effective correlated subqueries using TechCorp's business scenarios.

## 🏢 TechCorp Business Context
**Correlated Subqueries in Business Analysis:**
- **Employee Comparisons**: Comparing each employee to their d.DepartmentName average
- **Hierarchical Analysis**: Finding managers and their direct reports
- **Time-Series Analysis**: Comparing current performance to historical data
- **Competitive Analysis**: Comparing departments or projects against peers
- **Dynamic Filtering**: Creating row-by-row conditional logic

### 📋 TechCorp Schema Quick Reference

**Key Tables for Correlated Subquery Examples:**
```sql
Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive
Departments: d.DepartmentID, d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID, CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
```

## What are Correlated Subqueries?

### Definition and Characteristics
A correlated subquery is a nested query that:
- **References columns** from the outer query
- **Executes repeatedly** - once for each row in the outer query
- **Cannot run independently** - depends on outer query context
- **Creates row-by-row comparisons** and analysis

### Correlated vs Self-Contained Execution
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CORRELATED SUBQUERY EXECUTION                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  For EACH row in outer query:                                              │
│                                                                             │
│  Row 1: Employee John (d.DepartmentID = 2001)                               │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT AVG(e.BaseSalary)              │                                   │
│  │ FROM Employees e                      │  →  Returns: 75000 (Eng Avg)     │
│  │ WHERE d.DepartmentID = 2001          │      ↑                           │
│  │   AND IsActive = 1                 │      │ References outer row       │
│  └─────────────────────────────────────┘      │                           │
│                                              │                           │
│  Row 2: Employee Jane (d.DepartmentID = 2002)                               │
│  ┌─────────────────────────────────────┐      │                           │
│  │ SELECT AVG(e.BaseSalary)              │      │                           │
│  │ FROM Employees e                      │  →  Returns: 68000 (Sales Avg)   │
│  │ WHERE d.DepartmentID = 2002          │      │                           │
│  │   AND IsActive = 1                 │      │ Different result per row   │
│  └─────────────────────────────────────┘      │                           │
│                                              │                           │
│  Result: Each employee compared to their own d.DepartmentName average            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Basic Correlated Subquery Patterns

### 1. Departmental Comparisons

#### TechCorp Example: Employees Above d.DepartmentName Average
```sql
-- Find employees earning above their d.DepartmentName average
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    (SELECT AVG(e2.e.BaseSalary) 
     FROM Employees e e2 
     WHERE e2.d.DepartmentID = e.d.DepartmentID 
       AND e2.IsActive = 1) AS DeptAvgSalary,
    e.BaseSalary - (SELECT AVG(e2.e.BaseSalary) 
                    FROM Employees e e2 
                    WHERE e2.d.DepartmentID = e.d.DepartmentID 
                      AND e2.IsActive = 1) AS SalaryDifferenceFromDeptAvg
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID  -- Correlation with outer query
      AND e2.IsActive = 1
)
  AND e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

#### TechCorp Example: d.DepartmentName Performance Ranking
```sql
-- Rank each d.DepartmentName by its position relative to other departments
SELECT d.DepartmentName,
    d.Budget,
    (SELECT COUNT(*)
     FROM Departments d d2
     WHERE d2.d.Budget > d.Budget
       AND d2.IsActive = 1) + 1 AS BudgetRank,
    (SELECT COUNT(*)
     FROM Departments d d2
     WHERE d2.IsActive = 1) AS TotalDepartments
FROM Departments d
WHERE d.IsActive = 1
ORDER BY d.Budget DESC;
```

### 2. Hierarchical Relationships

#### TechCorp Example: Managers and Direct Reports
```sql
-- Find managers with their direct report count and average team e.BaseSalary
SELECT 
    mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,
    mgr.e.JobTitle,
    d.DepartmentName,
    (SELECT COUNT(*)
     FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
     WHERE e.ManagerID = mgr.e.EmployeeID
       AND e.IsActive = 1) AS DirectReports,
    (SELECT AVG(e.BaseSalary)
     FROM Employees e
     WHERE e.ManagerID = mgr.e.EmployeeID
       AND e.IsActive = 1) AS AvgTeamSalary,
    mgr.e.BaseSalary AS ManagerSalary
FROM Employees e mgr
INNER JOIN Departments d ON mgr.d.DepartmentID = d.DepartmentID
WHERE EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.ManagerID = mgr.e.EmployeeID
      AND e.IsActive = 1
)
  AND mgr.IsActive = 1
ORDER BY DirectReports DESC;
```

### 3. Time-Based Analysis

#### TechCorp Example: Employee Tenure Comparison
```sql
-- Compare each employee's tenure to others in their d.DepartmentName
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    (SELECT AVG(DATEDIFF(YEAR, e2.e.HireDate, GETDATE()))
     FROM Employees e e2
     WHERE e2.d.DepartmentID = e.d.DepartmentID
       AND e2.IsActive = 1) AS DeptAvgTenure,
    (SELECT COUNT(*)
     FROM Employees e e2
     WHERE e2.d.DepartmentID = e.d.DepartmentID
       AND e2.e.HireDate < e.HireDate
       AND e2.IsActive = 1) AS EmployeesHiredBefore
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.HireDate;
```

## Advanced Correlated Subquery Patterns

### 1. Running Totals and Cumulative Analysis

#### TechCorp Example: Project d.Budget Analysis
```sql
-- Calculate running total of project budgets by start date
SELECT 
    p.ProjectName,
    p.StartDate,
    p.d.Budget,
    FORMAT(p.d.Budget, 'C') AS FormattedBudget,
    (SELECT SUM(p2.d.Budget)
     FROM Projects p p2
     WHERE p2.StartDate <= p.StartDate
       AND p2.IsActive = 1) AS RunningTotal,
    (SELECT COUNT(*)
     FROM Projects p p2
     WHERE p2.StartDate <= p.StartDate
       AND p2.IsActive = 1) AS ProjectsStartedByThisDate
FROM Projects p
WHERE p.IsActive = 1
ORDER BY p.StartDate;
```

### 2. Complex Business Logic

#### TechCorp Example: Employee Performance Analysis
```sql
-- Identify high performers: above dept average e.BaseSalary + above avg project hours
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    d.DepartmentName,
    (SELECT AVG(ep.HoursWorked)
     FROM EmployeeProjects ep
     WHERE ep.e.EmployeeID = e.EmployeeID
       AND ep.IsActive = 1) AS AvgProjectHours,
    CASE 
        WHEN e.BaseSalary > (
            SELECT AVG(e2.e.BaseSalary)
            FROM Employees e e2
            WHERE e2.d.DepartmentID = e.d.DepartmentID
              AND e2.IsActive = 1
        ) AND (
            SELECT AVG(ISNULL(ep.HoursWorked, 0))
            FROM EmployeeProjects ep
            WHERE ep.e.EmployeeID = e.EmployeeID
              AND ep.IsActive = 1
        ) > (
            SELECT AVG(ISNULL(ep2.HoursWorked, 0))
            FROM EmployeeProjects ep2
            INNER JOIN Employees e3 ON ep2.e.EmployeeID = e3.e.EmployeeID
            WHERE e3.d.DepartmentID = e.d.DepartmentID
              AND ep2.IsActive = 1
              AND e3.IsActive = 1
        ) THEN 'High Performer'
        ELSE 'Standard Performer'
    END AS PerformanceCategory
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

### 3. Competitive Analysis

#### TechCorp Example: Sales Performance Rankings
```sql
-- Rank employees by their order performance within d.DepartmentName
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    (SELECT COUNT(*)
     FROM Orders o
     WHERE o.e.EmployeeID = e.EmployeeID
       AND o.IsActive = 1) AS TotalOrders,
    (SELECT ISNULL(SUM(o.TotalAmount), 0)
     FROM Orders o
     WHERE o.e.EmployeeID = e.EmployeeID
       AND o.IsActive = 1) AS TotalSalesAmount,
    (SELECT COUNT(*)
     FROM Employees e e2
     WHERE e2.d.DepartmentID = e.d.DepartmentID
       AND (SELECT ISNULL(SUM(o2.TotalAmount), 0)
            FROM Orders o2
            WHERE o2.e.EmployeeID = e2.e.EmployeeID
              AND o2.IsActive = 1) > 
           (SELECT ISNULL(SUM(o3.TotalAmount), 0)
            FROM Orders o3
            WHERE o3.e.EmployeeID = e.EmployeeID
              AND o3.IsActive = 1)
       AND e2.IsActive = 1) + 1 AS SalesRankInDepartment
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.e.EmployeeID = e.EmployeeID
      AND o.IsActive = 1
)
  AND e.IsActive = 1
ORDER BY d.DepartmentName, TotalSalesAmount DESC;
```

## Performance Considerations

### 1. Optimization Strategies

#### Index Usage for Correlated Subqueries
```sql
-- ✅ GOOD: Correlated subquery with proper indexing
-- Assumes indexes on: Employees(d.DepartmentID, IsActive, e.BaseSalary)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID  -- Can use index on d.DepartmentID
      AND e2.IsActive = 1                  -- Can use index on IsActive
)
  AND e.IsActive = 1;

-- ❌ AVOID: Functions in correlated subquery
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary * 1.1)  -- Function prevents index usage
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID
      AND e2.IsActive = 1
);
```

### 2. Alternative Approaches for Better Performance

#### Window Functions Alternative
```sql
-- Correlated subquery approach (slower)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID
      AND e2.IsActive = 1
)
  AND e.IsActive = 1;

-- Window function alternative (often faster)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM (
    SELECT 
        e.FirstName, 
        e.LastName, 
        e.BaseSalary,
        AVG(e.BaseSalary) OVER (PARTITION BY d.DepartmentID) AS DeptAvgSalary
    FROM Employees e
    WHERE IsActive = 1
) ranked
WHERE e.BaseSalary > DeptAvgSalary;
```

#### JOIN Alternative
```sql
-- Correlated subquery for counting
SELECT d.DepartmentName,
    (SELECT COUNT(*) FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID WHERE e.d.DepartmentID = d.DepartmentID AND e.IsActive = 1) AS EmpCount
FROM Departments d
WHERE d.IsActive = 1;

-- JOIN alternative (usually faster)
SELECT d.DepartmentName,
    COUNT(e.EmployeeID) AS EmpCount
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID AND e.IsActive = 1
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName;
```

## Common Use Cases and Business Applications

### 1. Employee Performance Evaluation

#### TechCorp Example: Comprehensive Performance Review
```sql
-- Multi-dimensional employee performance analysis
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    d.DepartmentName,
    -- e.BaseSalary percentile within d.DepartmentName
    (SELECT COUNT(*)
     FROM Employees e e2
     WHERE e2.d.DepartmentID = e.d.DepartmentID
       AND e2.e.BaseSalary <= e.BaseSalary
       AND e2.IsActive = 1) * 100.0 / 
    (SELECT COUNT(*)
     FROM Employees e e3
     WHERE e3.d.DepartmentID = e.d.DepartmentID
       AND e3.IsActive = 1) AS SalaryPercentileInDept,
    -- Project involvement comparison
    (SELECT COUNT(*)
     FROM EmployeeProjects ep
     WHERE ep.e.EmployeeID = e.EmployeeID
       AND ep.IsActive = 1) AS ProjectCount,
    (SELECT AVG(project_count)
     FROM (SELECT COUNT(*) AS project_count
           FROM EmployeeProjects ep2
           INNER JOIN Employees e4 ON ep2.e.EmployeeID = e4.e.EmployeeID
           WHERE e4.d.DepartmentID = e.d.DepartmentID
             AND ep2.IsActive = 1
             AND e4.IsActive = 1
           GROUP BY ep2.e.EmployeeID) avg_calc) AS DeptAvgProjects
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, SalaryPercentileInDept DESC;
```

### 2. Resource Allocation Analysis

#### TechCorp Example: d.DepartmentName Resource Utilization
```sql
-- Analyze d.DepartmentName efficiency relative to peers
SELECT d.DepartmentName,
    d.Budget,
    -- Employee efficiency: budget per employee vs company average
    d.Budget / NULLIF((SELECT COUNT(*) 
                       FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
                       WHERE e.d.DepartmentID = d.DepartmentID 
                         AND e.IsActive = 1), 0) AS BudgetPerEmployee,
    (SELECT AVG(dept_budget_per_emp)
     FROM (SELECT dept.Budget / NULLIF(COUNT(emp.EmployeeID), 0) AS dept_budget_per_emp
           FROM Departments d dept
           LEFT JOIN Employees emp ON dept.DepartmentID = emp.d.DepartmentID 
                                   AND emp.IsActive = 1
           WHERE dept.IsActive = 1
           GROUP BY dept.DepartmentID, dept.Budget) calc) AS CompanyAvgBudgetPerEmployee,
    -- Project activity level
    (SELECT COUNT(*)
     FROM Projects p
     WHERE p.ProjectManagerID IN (
         SELECT e.EmployeeID
         FROM Employees e
         WHERE e.d.DepartmentID = d.DepartmentID
           AND e.IsActive = 1
     )
       AND p.IsActive = 1) AS ProjectsManaged
FROM Departments d
WHERE d.IsActive = 1
ORDER BY BudgetPerEmployee DESC;
```

## Best Practices for Correlated Subqueries

### 1. Writing Efficient Correlated Subqueries

#### Clear Correlation References
```sql
-- ✅ GOOD: Clear table aliases and correlation
SELECT 
    outer_emp.FirstName,
    outer_emp.LastName,
    (SELECT AVG(inner_emp.BaseSalary)
     FROM Employees e inner_emp
     WHERE inner_emp.DepartmentID = outer_emp.DepartmentID
       AND inner_emp.IsActive = 1) AS DeptAverage
FROM Employees e outer_emp
WHERE outer_emp.IsActive = 1;

-- ❌ CONFUSING: Unclear aliases
SELECT 
    e.FirstName,
    e.LastName,
    (SELECT AVG(e.BaseSalary)  -- Which 'e' is this?
     FROM Employees e
     WHERE e.DepartmentID = e.DepartmentID) AS DeptAverage
FROM Employees e;
```

### 2. Performance Testing

#### Execution Plan Analysis
```sql
-- Test query performance with actual data volumes
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Your correlated subquery here
SELECT COUNT(*)
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.DepartmentID = e.DepartmentID
      AND e2.IsActive = 1
);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

### 3. Error Handling

#### NULL Value Management
```sql
-- ✅ GOOD: Handle potential NULL results
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    ISNULL((SELECT AVG(e2.e.BaseSalary)
            FROM Employees e e2
            WHERE e2.DepartmentID = e.DepartmentID
              AND e2.IsActive = 1), 0) AS DeptAvgSalary
FROM Employees e
WHERE e.IsActive = 1;
```

## Common Pitfalls and Solutions

### 1. Performance Issues
```sql
-- ❌ PROBLEM: Correlated subquery in SELECT list causes N+1 query problem
SELECT 
    e.FirstName,
    (SELECT COUNT(*) FROM Orders o WHERE o.e.EmployeeID = e.EmployeeID) AS OrderCount,
    (SELECT SUM(o.TotalAmount) FROM Orders o WHERE o.e.EmployeeID = e.EmployeeID) AS TotalSales
FROM Employees e;

-- ✅ SOLUTION: Use JOINs or single subquery with multiple aggregates
SELECT 
    e.FirstName,
    ISNULL(order_stats.OrderCount, 0) AS OrderCount,
    ISNULL(order_stats.TotalSales, 0) AS TotalSales
FROM Employees e
LEFT JOIN (
    SELECT 
        e.EmployeeID,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS TotalSales
    FROM Orders
    WHERE IsActive = 1
    GROUP BY e.EmployeeID
) order_stats ON e.EmployeeID = order_stats.e.EmployeeID;
```

### 2. Logic Errors
```sql
-- ❌ PROBLEM: Incorrect correlation can cause unexpected results
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary)
    FROM Employees e
    -- Missing correlation - compares to company average, not d.DepartmentName
);

-- ✅ SOLUTION: Ensure proper correlation
SELECT e.FirstName, e.LastName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.DepartmentID = e.DepartmentID  -- Proper correlation
      AND e2.IsActive = 1
);
```

## Summary

Correlated subqueries are powerful for:

**Key Benefits:**
- **Row-by-row analysis** - compare each record to relevant subset
- **Dynamic filtering** - conditions change per outer row
- **Complex business logic** - multi-layered conditional analysis
- **Hierarchical queries** - parent-child relationships

**Common Use Cases:**
- Departmental comparisons and rankings
- Employee performance relative to peers
- Running totals and cumulative analysis
- Complex filtering based on row context

**Performance Considerations:**
- Execute once per outer row (can be expensive)
- Ensure proper indexing on correlated columns
- Consider window functions or JOINs as alternatives
- Test with realistic data volumes

**Best Practices:**
- Use clear table aliases
- Handle NULL values appropriately
- Index correlated columns
- Consider performance alternatives
- Test execution plans

Correlated subqueries excel at creating sophisticated business intelligence queries that require row-by-row contextual analysis, making them essential for advanced TechCorp reporting and analytics.