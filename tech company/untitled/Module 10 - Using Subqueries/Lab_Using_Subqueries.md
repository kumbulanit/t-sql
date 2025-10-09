# Lab: Using Subqueries

## Lab Overview

This hands-on lab provides practical exercises for working with different types of subqueries using TechCorp's database. You'll practice writing self-contained subqueries, correlated subqueries, and EXISTS predicates to solve real business problems. Each exercise includes expected results and detailed solutions to help reinforce your learning.

## 🎯 Lab Objectives

By completing this lab, you will be able to:

- Write effective self-contained subqueries for data analysis
- Create correlated subqueries for row-by-row comparisons
- Use EXISTS predicates for efficient existence testing
- Combine multiple subquery techniques in complex business scenarios
- Optimize subquery performance for real-world applications

## 📋 TechCorp Database Schema Reference

**Primary Tables Used in This Lab:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
```

---

## Exercise 1: Self-Contained Subqueries (Basic Level)

### 1.1 Scalar Subquery Challenge

**Business Problem:** The HR d.DepartmentName needs to identify all employees earning above the company average e.BaseSalary for budget planning purposes.

**Your Task:** Write a query that shows employee details for those earning above the company average e.BaseSalary. Include employee name, job title, e.BaseSalary, and how much above average they earn.

**Expected Output Columns:**
- Employee Name (First + Last)
- Job Title
- Current e.BaseSalary
- Company Average e.BaseSalary
- Difference from Average

**Hint:** Use a scalar subquery to calculate the company average e.BaseSalary.

```sql
-- Write your solution here:

-- Expected approach: Use scalar subquery in SELECT and WHERE clauses
```

### 1.2 Multi-Value Subquery Challenge

**Business Problem:** The sales team wants to focus on customers who have placed orders with amounts that match the top 5 order values in the system.

**Your Task:** Find all customers who have placed orders with amounts that match any of the top 5 highest order values in the database.

**Expected Output Columns:**
- Customer Company Name
- Contact Name
- Order Amount
- Order Date

**Hint:** Use IN with a subquery that finds the top 5 order amounts.

```sql
-- Write your solution here:

-- Expected approach: Use IN subquery with TOP clause
```

---

## Exercise 2: Correlated Subqueries (Intermediate Level)

### 2.1 d.DepartmentName Comparison Challenge

**Business Problem:** Management wants to identify high-performing employees by comparing each employee's e.BaseSalary to their d.DepartmentName average.

**Your Task:** Create a report showing employees who earn more than their d.DepartmentName average. Include d.DepartmentName comparison metrics.

**Expected Output Columns:**
- Employee Name
- d.DepartmentName Name
- Employee e.BaseSalary
- d.DepartmentName Average e.BaseSalary
- Percentage Above d.DepartmentName Average
- Employee Rank in d.DepartmentName

**Hint:** Use correlated subqueries to calculate department-specific averages and rankings.

```sql
-- Write your solution here:

-- Expected approach: Multiple correlated subqueries for different calculations
```

### 2.2 Time-Based Analysis Challenge

**Business Problem:** The project management office needs to analyze project workload distribution by finding employees who have worked more hours than the average for their department.

**Your Task:** Find employees whose total project hours exceed their department's average project hours. Include workload analysis.

**Expected Output Columns:**
- Employee Name
- d.DepartmentName Name
- Total Hours Worked
- d.DepartmentName Average Hours
- Number of Projects
- Average Hours per Project

**Hint:** Use correlated subqueries with aggregate functions and proper GROUP BY logic.

```sql
-- Write your solution here:

-- Expected approach: Correlated subqueries with SUM and AVG calculations
```

---

## Exercise 3: EXISTS Predicate (Intermediate Level)

### 3.1 Relationship Validation Challenge

**Business Problem:** The data quality team needs to identify employees who are managers (have subordinates) but have never been assigned to any projects.

**Your Task:** Find all employees who manage other employees but have no project assignments.

**Expected Output Columns:**
- Manager Name
- Job Title
- d.DepartmentName Name
- Number of Direct Reports
- Hire Date

**Hint:** Use EXISTS to check for subordinates and NOT EXISTS to check for no projects.

```sql
-- Write your solution here:

-- Expected approach: EXISTS for managers, NOT EXISTS for projects
```

### 3.2 Customer Activity Analysis Challenge

**Business Problem:** The customer success team wants to identify "at-risk" customers who have placed orders before but haven't ordered anything in the last 6 months.

**Your Task:** Find customers who have historical orders but no recent activity.

**Expected Output Columns:**
- Company Name
- Contact Name
- Last Order Date
- Days Since Last Order
- Total Historical Orders
- Total Historical Revenue

**Hint:** Use EXISTS for historical orders and NOT EXISTS for recent orders.

```sql
-- Write your solution here:

-- Expected approach: EXISTS for any orders, NOT EXISTS for recent orders
```

---

## Exercise 4: Complex Subquery Combinations (Advanced Level)

### 4.1 Multi-Dimensional Analysis Challenge

**Business Problem:** Senior management needs a comprehensive analysis of d.DepartmentName performance combining multiple metrics.

**Your Task:** Create a d.DepartmentName performance dashboard that combines e.BaseSalary analysis, project activity, and order processing metrics.

**Required Analysis:**
- Departments with above-average budgets
- Employee e.BaseSalary distribution within each d.DepartmentName
- Project management activity
- Order processing performance

**Expected Output Columns:**
- d.DepartmentName Name
- d.Budget vs Company Average
- High e.BaseSalary Employee Count (above dept avg)
- Projects Managed by d.DepartmentName
- Total Orders Processed
- Performance Rating

**Hint:** Combine multiple subquery types and use CASE statements for complex logic.

```sql
-- Write your solution here:

-- Expected approach: Multiple subquery types working together
```

### 4.2 Business Intelligence Challenge

**Business Problem:** Create a comprehensive employee performance scorecard using multiple subquery techniques.

**Your Task:** Develop a scoring system that evaluates employees across multiple dimensions.

**Scoring Criteria:**
- e.BaseSalary percentile within d.DepartmentName (25% of score)
- Project involvement vs d.DepartmentName average (25% of score)
- Order processing activity (25% of score)
- Management responsibilities (25% of score)

**Expected Output Columns:**
- Employee Name
- d.DepartmentName Name
- e.BaseSalary Percentile Score
- Project Activity Score
- Order Processing Score
- Management Score
- Total Performance Score
- Performance Category

**Hint:** Use multiple correlated subqueries and complex CASE logic.

```sql
-- Write your solution here:

-- Expected approach: Comprehensive scoring with multiple subquery patterns
```

---

## Exercise Solutions

### Solution 1.1: Scalar Subquery Challenge

```sql
-- HR Department: Employees Above Company Average
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
    FORMAT((SELECT AVG(e.BaseSalary) 
            FROM Employees e 
            WHERE IsActive = 1), 'C') AS CompanyAverageSalary,
    FORMAT(e.BaseSalary - (SELECT AVG(e.BaseSalary) 
                           FROM Employees e 
                           WHERE IsActive = 1), 'C') AS DifferenceFromAverage,
    CAST((e.BaseSalary - (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1)) * 100.0 / 
         (SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1) AS DECIMAL(5,1)) AS PercentAboveAverage
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary)
    FROM Employees e
    WHERE IsActive = 1
)
  AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

**Key Learning Points:**
- Scalar subqueries return single values
- Can be used in SELECT, WHERE, and HAVING clauses
- Same subquery can be reused multiple times
- Consider performance implications of repeated subqueries

### Solution 1.2: Multi-Value Subquery Challenge

```sql
-- Sales Team: Customers with Top-Tier Order Values
SELECT 
    c.CompanyName,
    c.ContactName,
    FORMAT(o.TotalAmount, 'C') AS OrderAmount,
    FORMAT(o.OrderDate, 'yyyy-MM-dd') AS OrderDate,
    e.FirstName + ' ' + e.LastName AS ProcessedBy
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
WHERE o.TotalAmount IN (
    SELECT TOP 5 TotalAmount
    FROM Orders
    WHERE IsActive = 1
    ORDER BY TotalAmount DESC
)
  AND c.IsActive = 1
  AND o.IsActive = 1
  AND e.IsActive = 1
ORDER BY o.TotalAmount DESC, o.OrderDate DESC;
```

**Key Learning Points:**
- IN subqueries work with multiple return values
- TOP clause limits results in subquery
- Multiple table JOINs can be combined with subqueries
- Proper filtering ensures data quality

### Solution 2.1: d.DepartmentName Comparison Challenge

```sql
-- Management: High-Performing Employees by d.DepartmentName
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS EmployeeSalary,
    FORMAT((SELECT AVG(e2.e.BaseSalary)
            FROM Employees e e2
            WHERE e2.d.DepartmentID = e.d.DepartmentID
              AND e2.IsActive = 1), 'C') AS DepartmentAverageSalary,
    CAST((e.BaseSalary - (SELECT AVG(e2.e.BaseSalary)
                          FROM Employees e e2
                          WHERE e2.d.DepartmentID = e.d.DepartmentID
                            AND e2.IsActive = 1)) * 100.0 /
         (SELECT AVG(e2.e.BaseSalary)
          FROM Employees e e2
          WHERE e2.d.DepartmentID = e.d.DepartmentID
            AND e2.IsActive = 1) AS DECIMAL(5,1)) AS PercentAboveDeptAverage,
    (SELECT COUNT(*)
     FROM Employees e e3
     WHERE e3.d.DepartmentID = e.d.DepartmentID
       AND e3.e.BaseSalary > e.BaseSalary
       AND e3.IsActive = 1) + 1 AS RankInDepartment
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.BaseSalary > (
    SELECT AVG(e2.e.BaseSalary)
    FROM Employees e e2
    WHERE e2.d.DepartmentID = e.d.DepartmentID
      AND e2.IsActive = 1
)
  AND e.IsActive = 1
  AND d.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

**Key Learning Points:**
- Correlated subqueries reference outer query columns
- Same correlation pattern can be used multiple times
- Ranking logic using COUNT with comparison
- Performance considerations with multiple correlated subqueries

### Solution 2.2: Time-Based Analysis Challenge

```sql
-- Project Management: Employee Workload Analysis
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    ISNULL((SELECT SUM(ep.HoursWorked)
            FROM EmployeeProjects ep
            WHERE ep.e.EmployeeID = e.EmployeeID
              AND ep.IsActive = 1), 0) AS TotalHoursWorked,
    (SELECT AVG(total_hours.hours)
     FROM (SELECT ISNULL(SUM(ep2.HoursWorked), 0) AS hours
           FROM EmployeeProjects ep2
           INNER JOIN Employees e2 ON ep2.e.EmployeeID = e2.e.EmployeeID
           WHERE e2.d.DepartmentID = e.d.DepartmentID
             AND ep2.IsActive = 1
             AND e2.IsActive = 1
           GROUP BY ep2.e.EmployeeID) total_hours) AS DepartmentAverageHours,
    (SELECT COUNT(DISTINCT ep.ProjectID)
     FROM EmployeeProjects ep
     WHERE ep.e.EmployeeID = e.EmployeeID
       AND ep.IsActive = 1) AS NumberOfProjects,
    CASE 
        WHEN (SELECT COUNT(DISTINCT ep.ProjectID)
              FROM EmployeeProjects ep
              WHERE ep.e.EmployeeID = e.EmployeeID
                AND ep.IsActive = 1) > 0
        THEN CAST(ISNULL((SELECT SUM(ep.HoursWorked)
                          FROM EmployeeProjects ep
                          WHERE ep.e.EmployeeID = e.EmployeeID
                            AND ep.IsActive = 1), 0) * 1.0 /
                  (SELECT COUNT(DISTINCT ep.ProjectID)
                   FROM EmployeeProjects ep
                   WHERE ep.e.EmployeeID = e.EmployeeID
                     AND ep.IsActive = 1) AS DECIMAL(8,1))
        ELSE 0
    END AS AverageHoursPerProject
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE ISNULL((SELECT SUM(ep.HoursWorked)
              FROM EmployeeProjects ep
              WHERE ep.e.EmployeeID = e.EmployeeID
                AND ep.IsActive = 1), 0) > 
      (SELECT AVG(total_hours.hours)
       FROM (SELECT ISNULL(SUM(ep2.HoursWorked), 0) AS hours
             FROM EmployeeProjects ep2
             INNER JOIN Employees e2 ON ep2.e.EmployeeID = e2.e.EmployeeID
             WHERE e2.d.DepartmentID = e.d.DepartmentID
               AND ep2.IsActive = 1
               AND e2.IsActive = 1
             GROUP BY ep2.e.EmployeeID) total_hours)
  AND e.IsActive = 1
  AND d.IsActive = 1
ORDER BY TotalHoursWorked DESC;
```

**Key Learning Points:**
- Complex correlated subqueries with nested GROUP BY
- NULL handling with ISNULL function
- Division by zero protection with CASE statements
- Multiple correlation levels for complex analysis

### Solution 3.1: Relationship Validation Challenge

```sql
-- Data Quality: Managers Without Project Assignments
SELECT 
    e.FirstName + ' ' + e.LastName AS ManagerName,
    e.JobTitle,
    d.DepartmentName,
    (SELECT COUNT(*)
     FROM Employees e subordinate
     WHERE subordinate.ManagerID = e.EmployeeID
       AND subordinate.IsActive = 1) AS NumberOfDirectReports,
    FORMAT(e.HireDate, 'yyyy-MM-dd') AS e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsWithCompany
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE EXISTS (
    -- Has subordinates (is a manager)
    SELECT 1
    FROM Employees e subordinate
    WHERE subordinate.ManagerID = e.EmployeeID
      AND subordinate.IsActive = 1
)
  AND NOT EXISTS (
    -- Has no project assignments
    SELECT 1
    FROM EmployeeProjects ep
    WHERE ep.e.EmployeeID = e.EmployeeID
      AND ep.IsActive = 1
)
  AND e.IsActive = 1
  AND d.IsActive = 1
ORDER BY NumberOfDirectReports DESC, e.HireDate;
```

**Key Learning Points:**
- EXISTS for positive existence checks
- NOT EXISTS for negative existence checks
- Combining multiple EXISTS conditions
- EXISTS is efficient for existence testing

### Solution 3.2: Customer Activity Analysis Challenge

```sql
-- Customer Success: At-Risk Customer Analysis
SELECT 
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country,
    (SELECT MAX(o.OrderDate)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID
       AND o.IsActive = 1) AS LastOrderDate,
    DATEDIFF(DAY, 
             (SELECT MAX(o.OrderDate)
              FROM Orders o
              WHERE o.CustomerID = c.CustomerID
                AND o.IsActive = 1), 
             GETDATE()) AS DaysSinceLastOrder,
    (SELECT COUNT(*)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID
       AND o.IsActive = 1) AS TotalHistoricalOrders,
    FORMAT((SELECT SUM(o.TotalAmount)
            FROM Orders o
            WHERE o.CustomerID = c.CustomerID
              AND o.IsActive = 1), 'C') AS TotalHistoricalRevenue,
    CASE 
        WHEN DATEDIFF(DAY, 
                      (SELECT MAX(o.OrderDate)
                       FROM Orders o
                       WHERE o.CustomerID = c.CustomerID
                         AND o.IsActive = 1), 
                      GETDATE()) > 365 THEN 'High Risk'
        WHEN DATEDIFF(DAY, 
                      (SELECT MAX(o.OrderDate)
                       FROM Orders o
                       WHERE o.CustomerID = c.CustomerID
                         AND o.IsActive = 1), 
                      GETDATE()) > 180 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS RiskCategory
FROM Customers c
WHERE EXISTS (
    -- Has historical orders
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
      AND o.IsActive = 1
)
  AND NOT EXISTS (
    -- No orders in last 6 months
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
      AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())
      AND o.IsActive = 1
)
  AND c.IsActive = 1
ORDER BY DaysSinceLastOrder DESC, TotalHistoricalRevenue DESC;
```

**Key Learning Points:**
- EXISTS and NOT EXISTS with date conditions
- Risk categorization with CASE statements
- Multiple scalar subqueries in SELECT clause
- Date arithmetic for business analysis

### Solution 4.1: Multi-Dimensional Analysis Challenge

```sql
-- Senior Management: d.DepartmentName Performance Dashboard
SELECT d.DepartmentName,
    FORMAT(d.Budget, 'C') AS DepartmentBudget,
    CASE 
        WHEN d.Budget > (SELECT AVG(d.Budget) FROM Departments d WHERE IsActive = 1)
        THEN 'Above Average (' + 
             FORMAT((d.Budget - (SELECT AVG(d.Budget) FROM Departments d WHERE IsActive = 1)) * 100.0 / 
                    (SELECT AVG(d.Budget) FROM Departments d WHERE IsActive = 1), '0.0') + '%)'
        ELSE 'Below Average (' + 
             FORMAT((d.Budget - (SELECT AVG(d.Budget) FROM Departments d WHERE IsActive = 1)) * 100.0 / 
                    (SELECT AVG(d.Budget) FROM Departments d WHERE IsActive = 1), '0.0') + '%)'
    END AS BudgetVsCompanyAverage,
    (SELECT COUNT(*)
     FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
     WHERE e.d.DepartmentID = d.DepartmentID
       AND e.BaseSalary > (SELECT AVG(e2.e.BaseSalary)
                           FROM Employees e e2
                           WHERE e2.d.DepartmentID = e.d.DepartmentID
                             AND e2.IsActive = 1)
       AND e.IsActive = 1) AS HighSalaryEmployeeCount,
    (SELECT COUNT(*)
     FROM Projects p
     INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
     WHERE e.d.DepartmentID = d.DepartmentID
       AND p.IsActive = 1
       AND e.IsActive = 1) AS ProjectsManaged,
    (SELECT COUNT(*)
     FROM Orders o
     INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
     WHERE e.d.DepartmentID = d.DepartmentID
       AND o.IsActive = 1
       AND e.IsActive = 1) AS TotalOrdersProcessed,
    FORMAT((SELECT ISNULL(SUM(o.TotalAmount), 0)
            FROM Orders o
            INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
            WHERE e.d.DepartmentID = d.DepartmentID
              AND o.IsActive = 1
              AND e.IsActive = 1), 'C') AS TotalRevenueGenerated,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM Orders o
            INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
            WHERE e.d.DepartmentID = d.DepartmentID
              AND o.OrderDate >= DATEADD(MONTH, -1, GETDATE())
              AND o.IsActive = 1
              AND e.IsActive = 1
        ) AND EXISTS (
            SELECT 1
            FROM Projects p
            INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
            WHERE e.d.DepartmentID = d.DepartmentID
              AND p.IsActive = 1
              AND e.IsActive = 1
        ) THEN 'Excellent'
        WHEN EXISTS (
            SELECT 1
            FROM Orders o
            INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
            WHERE e.d.DepartmentID = d.DepartmentID
              AND o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
              AND o.IsActive = 1
              AND e.IsActive = 1
        ) OR EXISTS (
            SELECT 1
            FROM Projects p
            INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
            WHERE e.d.DepartmentID = d.DepartmentID
              AND p.IsActive = 1
              AND e.IsActive = 1
        ) THEN 'Good'
        ELSE 'Needs Attention'
    END AS PerformanceRating
FROM Departments d
WHERE d.IsActive = 1
ORDER BY 
    CASE PerformanceRating 
        WHEN 'Excellent' THEN 1 
        WHEN 'Good' THEN 2 
        ELSE 3 
    END,
    TotalRevenueGenerated DESC;
```

**Key Learning Points:**
- Complex CASE statements with multiple subqueries
- Combining scalar and EXISTS subqueries
- Multi-table correlations
- Business logic implementation with SQL

### Solution 4.2: Business Intelligence Challenge

```sql
-- Comprehensive Employee Performance Scorecard
WITH PerformanceScores AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.BaseSalary,
        
        -- e.BaseSalary Percentile Score (25% of total)
        CAST((SELECT COUNT(*)
              FROM Employees e e2
              WHERE e2.DepartmentID = e.DepartmentID
                AND e2.e.BaseSalary <= e.BaseSalary
                AND e2.IsActive = 1) * 100.0 / 
             NULLIF((SELECT COUNT(*)
                     FROM Employees e e3
                     WHERE e3.DepartmentID = e.DepartmentID
                       AND e3.IsActive = 1), 0) AS DECIMAL(5,1)) AS SalaryPercentile,
        
        -- Project Activity Score (25% of total)
        CASE 
            WHEN (SELECT COUNT(*) FROM EmployeeProjects ep WHERE ep.e.EmployeeID = e.EmployeeID AND ep.IsActive = 1) >
                 (SELECT AVG(project_count * 1.0)
                  FROM (SELECT COUNT(*) AS project_count
                        FROM EmployeeProjects ep2
                        INNER JOIN Employees e4 ON ep2.e.EmployeeID = e4.e.EmployeeID
                        WHERE e4.DepartmentID = e.DepartmentID
                          AND ep2.IsActive = 1
                          AND e4.IsActive = 1
                        GROUP BY ep2.e.EmployeeID) avg_calc)
            THEN 100.0
            WHEN (SELECT COUNT(*) FROM EmployeeProjects ep WHERE ep.e.EmployeeID = e.EmployeeID AND ep.IsActive = 1) > 0
            THEN CAST((SELECT COUNT(*) FROM EmployeeProjects ep WHERE ep.e.EmployeeID = e.EmployeeID AND ep.IsActive = 1) * 100.0 /
                      NULLIF((SELECT MAX(project_count)
                              FROM (SELECT COUNT(*) AS project_count
                                    FROM EmployeeProjects ep2
                                    INNER JOIN Employees e4 ON ep2.e.EmployeeID = e4.e.EmployeeID
                                    WHERE e4.DepartmentID = e.DepartmentID
                                      AND ep2.IsActive = 1
                                      AND e4.IsActive = 1
                                    GROUP BY ep2.e.EmployeeID) max_calc), 0) AS DECIMAL(5,1))
            ELSE 0.0
        END AS ProjectActivityScore,
        
        -- Order Processing Score (25% of total)
        CASE 
            WHEN (SELECT COUNT(*) FROM Orders o WHERE o.e.EmployeeID = e.EmployeeID AND o.IsActive = 1) > 0
            THEN CAST((SELECT COUNT(*) FROM Orders o WHERE o.e.EmployeeID = e.EmployeeID AND o.IsActive = 1) * 100.0 /
                      NULLIF((SELECT MAX(order_count)
                              FROM (SELECT COUNT(*) AS order_count
                                    FROM Orders o2
                                    INNER JOIN Employees e5 ON o2.e.EmployeeID = e5.e.EmployeeID
                                    WHERE e5.DepartmentID = e.DepartmentID
                                      AND o2.IsActive = 1
                                      AND e5.IsActive = 1
                                    GROUP BY o2.e.EmployeeID) max_calc), 0) AS DECIMAL(5,1))
            ELSE 0.0
        END AS OrderProcessingScore,
        
        -- Management Score (25% of total)
        CASE 
            WHEN EXISTS (SELECT 1 FROM Employees e sub WHERE sub.ManagerID = e.EmployeeID AND sub.IsActive = 1)
            THEN CAST((SELECT COUNT(*) FROM Employees e sub WHERE sub.ManagerID = e.EmployeeID AND sub.IsActive = 1) * 20.0 AS DECIMAL(5,1))
            ELSE 0.0
        END AS ManagementScore
        
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1 AND d.IsActive = 1
)
SELECT 
    EmployeeName,
    DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
    SalaryPercentile AS SalaryPercentileScore,
    ProjectActivityScore,
    OrderProcessingScore,
    ManagementScore,
    CAST((SalaryPercentile * 0.25 + 
          ProjectActivityScore * 0.25 + 
          OrderProcessingScore * 0.25 + 
          ManagementScore * 0.25) AS DECIMAL(5,1)) AS TotalPerformanceScore,
    CASE 
        WHEN (SalaryPercentile * 0.25 + ProjectActivityScore * 0.25 + OrderProcessingScore * 0.25 + ManagementScore * 0.25) >= 90
        THEN 'Exceptional'
        WHEN (SalaryPercentile * 0.25 + ProjectActivityScore * 0.25 + OrderProcessingScore * 0.25 + ManagementScore * 0.25) >= 75
        THEN 'High Performer'
        WHEN (SalaryPercentile * 0.25 + ProjectActivityScore * 0.25 + OrderProcessingScore * 0.25 + ManagementScore * 0.25) >= 50
        THEN 'Good Performer'
        WHEN (SalaryPercentile * 0.25 + ProjectActivityScore * 0.25 + OrderProcessingScore * 0.25 + ManagementScore * 0.25) >= 25
        THEN 'Average Performer'
        ELSE 'Needs Development'
    END AS PerformanceCategory
FROM PerformanceScores
ORDER BY TotalPerformanceScore DESC, EmployeeName;
```

**Key Learning Points:**
- Common Table Expressions (CTEs) for complex calculations
- Multiple correlated subqueries with different aggregation patterns
- Weighted scoring systems
- Complex CASE logic for categorization
- Performance considerations with multiple subquery evaluations

---

## Lab Summary and Key Takeaways

### Subquery Performance Best Practices

1. **Indexing Strategy:**
   - Ensure indexes on columns used in WHERE clauses of subqueries
   - Consider composite indexes for correlated subqueries
   - Monitor execution plans for subquery optimization

2. **Query Optimization:**
   - Use EXISTS instead of IN when checking for existence
   - Consider JOINs or window functions as alternatives to correlated subqueries
   - Avoid functions in WHERE clauses of subqueries

3. **Business Logic Implementation:**
   - Break complex requirements into smaller, testable subqueries
   - Use meaningful aliases for clarity
   - Document complex business rules in comments

### Common Patterns Learned

- **Scalar subqueries** for single-value comparisons and calculations
- **Correlated subqueries** for row-by-row analysis and ranking
- **EXISTS predicates** for efficient existence testing
- **Complex combinations** for comprehensive business intelligence

### Next Steps

- Practice these patterns with your own business scenarios
- Experiment with query optimization techniques
- Explore window functions as alternatives to subqueries
- Study execution plans to understand performance characteristics

Congratulations on completing the TechCorp Subqueries Lab! You now have practical experience with all major subquery patterns and their real-world applications.