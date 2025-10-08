# Lab: Using Set Operators

## Overview

In this hands-on lab, you will practice using various set operators (UNION, UNION ALL, EXCEPT, INTERSECT, and APPLY) to solve real-world business scenarios at TechCorp. The lab provides progressive exercises that build from basic set operations to complex analytical queries, demonstrating how these operators can be used to solve business problems and generate meaningful insights.

## 🏢 TechCorp Business Context

You are working as a Database Analyst at TechCorp, a technology consulting company. Your role involves creating reports, analyzing data patterns, and providing insights to support business decisions. Today's lab focuses on using set operators to combine and analyze data from multiple sources, identify relationships between datasets, and generate comprehensive business intelligence reports.

### 📋 TechCorp Database Schema

**Primary Tables:**

```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, HireDate, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
```

---

## Exercise 1: Basic UNION Operations

### Task 1.1: Combine Employee Lists

**Business Scenario**: The HR department needs a comprehensive list combining current employees and recent former employees for a company-wide communication initiative.

**Instructions**:
1. Create a query that combines current employees with former employees who left within the last 6 months
2. Include employee name, department, and employment status
3. Sort the results by department and then by employee name

**Expected Output Columns**:
- EmployeeName
- DepartmentName
- EmploymentStatus ('Current' or 'Former')
- BaseSalary
- LastWorkDate (HireDate for current, estimated end date for former)

**Your Solution**:

```sql
-- Write your UNION query here
-- Combine current and former employees

```

### Task 1.2: Project and Order Revenue Analysis

**Business Scenario**: Management wants to see a combined view of revenue sources from both projects and direct orders to understand total company revenue streams.

**Instructions**:
1. Combine project budgets and order amounts into a single revenue analysis
2. Include revenue source type, amount, and date
3. Calculate running totals for each revenue type

**Your Solution**:

```sql
-- Write your UNION query for revenue analysis

```

---

## Exercise 2: UNION ALL for Performance

### Task 2.1: Comprehensive Activity Log

**Business Scenario**: Create a comprehensive activity log that includes all employee activities across projects and orders without removing duplicates, as each activity occurrence is significant for analysis.

**Instructions**:
1. Use UNION ALL to combine employee project activities and order activities
2. Include activity type, employee name, date, and value
3. Add performance analysis columns

**Your Solution**:

```sql
-- Write your UNION ALL query for activity log

```

### Task 2.2: Department Budget Allocation Analysis

**Business Scenario**: Finance needs to analyze budget allocations across different categories (salaries, projects, operational costs) using historical data that may have duplicate entries for audit purposes.

**Instructions**:
1. Combine different budget allocation sources using UNION ALL
2. Include allocation type, department, amount, and period
3. Calculate percentage distributions

**Your Solution**:

```sql
-- Write your UNION ALL query for budget analysis

```

---

## Exercise 3: EXCEPT Operations

### Task 3.1: Identify Underutilized Employees

**Business Scenario**: HR wants to identify employees who haven't been assigned to any projects in the last 6 months to ensure optimal resource utilization.

**Instructions**:
1. Use EXCEPT to find employees not assigned to recent projects
2. Include employee details and potential reasons for underutilization
3. Provide recommendations for each employee

**Your Solution**:

```sql
-- Write your EXCEPT query to find underutilized employees

```

### Task 3.2: Customer Retention Analysis

**Business Scenario**: The sales team needs to identify customers who were active last year but haven't placed orders this year for targeted retention campaigns.

**Instructions**:
1. Use EXCEPT to identify customers with declining activity
2. Include customer details and last order information
3. Categorize customers by risk level

**Your Solution**:

```sql
-- Write your EXCEPT query for customer retention analysis

```

---

## Exercise 4: INTERSECT Operations

### Task 4.1: Cross-Department Collaboration Analysis

**Business Scenario**: Management wants to identify employees who have worked on projects spanning multiple departments to recognize cross-functional contributors.

**Instructions**:
1. Use INTERSECT to find employees working across departments
2. Include collaboration metrics and impact analysis
3. Identify top cross-department contributors

**Your Solution**:

```sql
-- Write your INTERSECT query for collaboration analysis

```

### Task 4.2: High-Value Customer Identification

**Business Scenario**: Marketing needs to identify customers who are both high-volume order customers AND high-value project clients for VIP treatment programs.

**Instructions**:
1. Use INTERSECT to find customers meeting both criteria
2. Include customer value metrics and engagement history
3. Provide VIP program recommendations

**Your Solution**:

```sql
-- Write your INTERSECT query for high-value customer identification

```

---

## Exercise 5: APPLY Operations

### Task 5.1: Dynamic Employee Performance Analysis

**Business Scenario**: HR needs a dynamic performance report where analysis criteria change based on each employee's role, department, and tenure.

**Instructions**:
1. Use CROSS APPLY to create dynamic performance metrics
2. Apply different evaluation criteria per employee
3. Include personalized improvement recommendations

**Your Solution**:

```sql
-- Write your CROSS APPLY query for dynamic performance analysis

```

### Task 5.2: Customer Segmentation with Dynamic Criteria

**Business Scenario**: The marketing team wants customer segmentation where the segmentation criteria adapt based on each customer's industry, location, and order history.

**Instructions**:
1. Use OUTER APPLY to ensure all customers are included in analysis
2. Apply dynamic segmentation logic per customer
3. Generate targeted marketing strategies

**Your Solution**:

```sql
-- Write your OUTER APPLY query for customer segmentation

```

---

## Exercise 6: Complex Scenario - Comprehensive Business Intelligence

### Task 6.1: Executive Dashboard Query

**Business Scenario**: Create a comprehensive executive dashboard query that combines multiple set operations to provide a complete business overview.

**Requirements**:
1. Combine revenue data from multiple sources (UNION)
2. Identify performance gaps (EXCEPT)
3. Find cross-functional success patterns (INTERSECT)
4. Generate dynamic insights per department (APPLY)

**Instructions**:
1. Create a complex query using at least 3 different set operators
2. Include executive-level metrics and KPIs
3. Provide actionable business insights

**Your Solution**:

```sql
-- Write your comprehensive executive dashboard query

```

### Task 6.2: Advanced Analytics for Resource Optimization

**Business Scenario**: Operations management needs an advanced analytics query to optimize resource allocation across projects, departments, and time periods.

**Instructions**:
1. Use multiple set operators in a single solution
2. Include predictive elements based on historical patterns
3. Generate optimization recommendations

**Your Solution**:

```sql
-- Write your advanced analytics query for resource optimization

```

---

## Exercise 7: Performance Optimization Challenge

### Task 7.1: Optimize Set Operation Queries

**Business Scenario**: The queries you've created need to be optimized for production use with large datasets.

**Instructions**:
1. Review your previous queries and identify performance bottlenecks
2. Rewrite at least 2 queries with optimization techniques
3. Include execution plan analysis comments

**Your Optimized Solutions**:

```sql
-- Optimized Query 1: (Choose one of your previous queries to optimize)

-- Optimization techniques used:
-- 1. 
-- 2. 
-- 3. 

```

```sql
-- Optimized Query 2: (Choose another query to optimize)

-- Optimization techniques used:
-- 1. 
-- 2. 
-- 3. 

```

---

## Validation Queries

### Test Your Understanding

Run these validation queries to check your understanding:

```sql
-- Validation 1: Check UNION vs UNION ALL understanding
SELECT 'UNION removes duplicates' AS Concept, COUNT(*) AS ResultCount
FROM (
    SELECT DepartmentID FROM Employees e WHERE e.IsActive = 1
    UNION
    SELECT DepartmentID FROM Employees e WHERE e.IsActive = 1
) AS union_result

UNION ALL

SELECT 'UNION ALL keeps duplicates' AS Concept, COUNT(*) AS ResultCount
FROM (
    SELECT DepartmentID FROM Employees e WHERE e.IsActive = 1
    UNION ALL
    SELECT DepartmentID FROM Employees WHERE IsActive = 1
) AS union_all_result;

-- Validation 2: EXCEPT operation verification
SELECT 'Total Employees' AS Metric, COUNT(*) AS Count
FROM Employees
WHERE IsActive = 1

UNION ALL

SELECT 'Employees Without Recent Projects' AS Metric, COUNT(*) AS Count
FROM (
    SELECT EmployeeID FROM Employees e WHERE e.IsActive = 1
    EXCEPT
    SELECT DISTINCT EmployeeID 
    FROM EmployeeProjects ep
    WHERE ep.IsActive = 1 
    AND ep.StartDate >= DATEADD(MONTH, -6, GETDATE())
) AS without_projects;

-- Validation 3: INTERSECT operation verification
SELECT 'Employees in Both Projects and Orders' AS Metric, COUNT(*) AS Count
FROM (
    SELECT DISTINCT EmployeeID FROM EmployeeProjects WHERE IsActive = 1
    INTERSECT
    SELECT DISTINCT EmployeeID FROM Orders WHERE IsActive = 1
) AS cross_functional;
```

## Expected Results Summary

After completing all exercises, you should have:

**Exercise 1**: 2 UNION queries combining different employee and revenue datasets
**Exercise 2**: 2 UNION ALL queries for comprehensive activity and budget analysis
**Exercise 3**: 2 EXCEPT queries identifying gaps in employee utilization and customer retention
**Exercise 4**: 2 INTERSECT queries finding cross-department collaboration and high-value customers
**Exercise 5**: 2 APPLY queries with dynamic analysis criteria
**Exercise 6**: 2 comprehensive business intelligence queries using multiple set operators
**Exercise 7**: 2 optimized versions of previous queries with performance improvements

## Self-Assessment Checklist

**Understanding UNION Operations**:
- [ ] Can combine similar datasets with UNION
- [ ] Understand when to use UNION vs UNION ALL
- [ ] Can sort and filter combined results effectively

**Mastering Set Difference and Intersection**:
- [ ] Can identify missing data using EXCEPT
- [ ] Can find common data using INTERSECT
- [ ] Understand the requirements for compatible datasets

**Advanced APPLY Operations**:
- [ ] Can use CROSS APPLY for dynamic row-by-row operations
- [ ] Can use OUTER APPLY to preserve all left-side rows
- [ ] Can create complex analytical queries with APPLY

**Performance Optimization**:
- [ ] Can identify performance issues in set operations
- [ ] Can apply indexing strategies for set operators
- [ ] Can rewrite queries for better performance

**Business Application**:
- [ ] Can translate business requirements into set operation queries
- [ ] Can combine multiple set operators for complex analysis
- [ ] Can generate actionable insights from query results

## Additional Practice Scenarios

**Scenario A**: Create a quarterly business review query using all set operators
**Scenario B**: Design a customer lifecycle analysis using appropriate set operations
**Scenario C**: Build a resource utilization dashboard with dynamic metrics
**Scenario D**: Develop a predictive analysis query for business planning

---

## Lab Completion

**Time Estimate**: 3-4 hours
**Difficulty Level**: Intermediate to Advanced
**Prerequisites**: Understanding of basic SQL JOIN operations and aggregate functions

**Submission Guidelines**:
1. Complete all exercises with working SQL queries
2. Include comments explaining your business logic
3. Test all queries against the TechCorp database schema
4. Document any assumptions made during the exercises

**Learning Outcomes**:
Upon completion, you will be able to:
- Use all SQL set operators effectively in business scenarios
- Combine multiple set operations for complex analytical queries
- Optimize set operation queries for production environments
- Apply set operators to solve real-world business problems

**Next Steps**:
- Practice with larger datasets to understand performance implications
- Explore advanced analytical functions that complement set operators
- Study query execution plans for set operations
- Learn about parallel processing with set operators

This lab provides comprehensive hands-on experience with set operators in a business context, preparing you for real-world database analysis and reporting scenarios at TechCorp and similar organizations.