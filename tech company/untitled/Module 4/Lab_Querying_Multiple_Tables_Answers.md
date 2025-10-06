# Lab Answers: Querying Multiple Tables

## Exercise 1: Inner Joins - Answers

### Task 1.1: Basic Inner Joins - Answers

#### Question 1: Employee and Department Information
**Task:** Join Employees and Departments to show employee names with their department names.

```sql
-- Answer 1: Employee and Department Information
SELECT 
    e.FirstName,
    e.LastName,
    e.Title,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.LastName;
```

#### Question 2: Employee Project Assignments
**Task:** Show employees and their assigned projects.

```sql
-- Answer 2: Employee Project Assignments
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    p.ProjectName,
    ep.Role,
    ep.HoursAllocated,
    ep.HoursWorked,
    p.Status AS ProjectStatus
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
ORDER BY e.LastName, p.ProjectName;
```

#### Question 3: Three-Table Join
**Task:** Show employee name, department, and project information in one query.

```sql
-- Answer 3: Three-Table Join
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    p.ProjectName,
    ep.Role,
    ep.HoursAllocated,
    ep.HoursWorked,
    p.Budget AS ProjectBudget,
    p.Status AS ProjectStatus
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName, p.ProjectName;
```

### Task 1.2: Inner Join with Filtering - Answers

#### Question 1: High-BaseSalary Employees with Projects
**Task:** Find employees earning more than $70,000 who are assigned to projects.

```sql
-- Answer 1: High-BaseSalary Employees with Projects
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    d.DepartmentName,
    p.ProjectName,
    ep.Role,
    p.Status AS ProjectStatus
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.BaseSalary > 70000
  AND e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

#### Question 2: Active Projects with Team Members
**Task:** Show all active projects with their team members.

```sql
-- Answer 2: Active Projects with Team Members
SELECT 
    p.ProjectName,
    p.Status,
    p.Budget,
    e.FirstName + ' ' + e.LastName AS TeamMember,
    ep.Role,
    ep.HoursAllocated,
    ep.HoursWorked,
    d.DepartmentName AS MemberDepartment
FROM Projects p
INNER JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE p.Status = 'In Progress'
  AND e.IsActive = 1
ORDER BY p.ProjectName, ep.Role, e.LastName;
```

## Exercise 2: Outer Joins - Answers

### Task 2.1: Left Outer Joins - Answers

#### Question 1: All Employees with Department Information
**Task:** Show all employees including those without assigned departments.

```sql
-- Answer 1: All Employees with Department Information
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    e.BaseSalary,
    COALESCE(d.DepartmentName, 'No Department Assigned') AS DepartmentName,
    COALESCE(d.DepartmentCode, 'N/A') AS DepartmentCode
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;
```

#### Question 2: All Employees with Project Assignments
**Task:** Show all employees and their project assignments (if any).

```sql
-- Answer 2: All Employees with Project Assignments
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    COALESCE(p.ProjectName, 'No Project Assigned') AS ProjectName,
    COALESCE(ep.Role, 'N/A') AS ProjectRole,
    COALESCE(ep.HoursAllocated, 0) AS HoursAllocated,
    COALESCE(ep.HoursWorked, 0) AS HoursWorked
FROM Employees e
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1
ORDER BY e.LastName, p.ProjectName;
```

### Task 2.2: Right Outer Joins - Answers

#### Question 1: All Departments with Employee Count
**Task:** Show all departments and their employee counts.

```sql
-- Answer 1: All Departments with Employee Count
SELECT 
    d.DepartmentName,
    d.DepartmentCode,
    d.Budget,
    COALESCE(COUNT(e.EmployeeID), 0) AS EmployeeCount,
    COALESCE(AVG(e.BaseSalary), 0) AS AverageSalary,
    COALESCE(SUM(e.BaseSalary), 0) AS TotalPayroll
FROM Employees e
RIGHT JOIN Departments d ON e.DepartmentID = d.DepartmentID AND e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName, d.DepartmentCode, d.Budget
ORDER BY d.DepartmentName;
```

#### Question 2: All Projects with Employee Assignments
**Task:** Show all projects with their assigned employees.

```sql
-- Answer 2: All Projects with Employee Assignments
SELECT 
    p.ProjectName,
    p.Status,
    p.Budget,
    COALESCE(COUNT(ep.EmployeeID), 0) AS AssignedEmployees,
    COALESCE(SUM(ep.HoursAllocated), 0) AS TotalHoursAllocated,
    COALESCE(SUM(ep.HoursWorked), 0) AS TotalHoursWorked,
    CASE 
        WHEN COALESCE(SUM(ep.HoursAllocated), 0) = 0 THEN 0
        ELSE (COALESCE(SUM(ep.HoursWorked), 0) * 100.0) / SUM(ep.HoursAllocated)
    END AS CompletionPercentage
FROM EmployeeProjects ep
RIGHT JOIN Projects p ON ep.ProjectID = p.ProjectID
GROUP BY p.ProjectID, p.ProjectName, p.Status, p.Budget
ORDER BY p.Status, p.ProjectName;
```

### Task 2.3: Full Outer Joins - Answers

#### Question 1: Complete Employee-Department Relationship
**Task:** Show the complete relationship between employees and departments.

```sql
-- Answer 1: Complete Employee-Department Relationship
SELECT 
    COALESCE(e.FirstName + ' ' + e.LastName, 'No Employee') AS EmployeeName,
    COALESCE(d.DepartmentName, 'No Department') AS DepartmentName,
    e.BaseSalary,
    d.Budget,
    CASE 
        WHEN e.EmployeeID IS NULL THEN 'Department with no employees'
        WHEN d.DepartmentID IS NULL THEN 'Employee without department'
        ELSE 'Normal assignment'
    END AS RelationshipStatus
FROM Employees e
FULL OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID IS NULL OR d.DepartmentID IS NULL OR e.IsActive = 1
ORDER BY RelationshipStatus, DepartmentName, EmployeeName;
```

## Exercise 3: Cross Joins and Self Joins - Answers

### Task 3.1: Cross Joins - Answers

#### Question 1: Employee-Project Combinations
**Task:** Show all possible combinations of employees and projects.

```sql
-- Answer 1: Employee-Project Combinations
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    p.ProjectName,
    p.Status AS ProjectStatus,
    CASE 
        WHEN ep.EmployeeID IS NOT NULL THEN 'Currently Assigned'
        ELSE 'Not Assigned'
    END AS AssignmentStatus
FROM Employees e
CROSS JOIN Projects p
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND p.ProjectID = ep.ProjectID
WHERE e.IsActive = 1
ORDER BY e.LastName, p.ProjectName;
```

#### Question 2: Department-Project Matrix
**Task:** Create a matrix showing all department-project combinations.

```sql
-- Answer 2: Department-Project Matrix
SELECT 
    d.DepartmentName,
    p.ProjectName,
    p.Status AS ProjectStatus,
    COALESCE(COUNT(ep.EmployeeID), 0) AS EmployeesAssigned,
    COALESCE(SUM(ep.HoursAllocated), 0) AS TotalHoursAllocated
FROM Departments d
CROSS JOIN Projects p
LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
LEFT JOIN Employees e ON ep.EmployeeID = e.EmployeeID AND e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName, p.ProjectID, p.ProjectName, p.Status
ORDER BY d.DepartmentName, p.ProjectName;
```

### Task 3.2: Self Joins - Answers

#### Question 1: Employee-Manager Relationships
**Task:** Show employee and manager information using self-join.

```sql
-- Answer 1: Employee-Manager Relationships
SELECT 
    emp.FirstName + ' ' + emp.LastName AS EmployeeName,
    emp.Title AS EmployeeTitle,
    emp.BaseSalary AS EmployeeSalary,
    COALESCE(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
    COALESCE(mgr.Title, 'N/A') AS ManagerTitle,
    COALESCE(mgr.BaseSalary, 0) AS ManagerSalary,
    CASE 
        WHEN mgr.EmployeeID IS NULL THEN 'Top Level'
        WHEN emp.BaseSalary > mgr.BaseSalary THEN 'Earns more than manager'
        WHEN emp.BaseSalary = mgr.BaseSalary THEN 'Same salary as manager'
        ELSE 'Earns less than manager'
    END AS SalaryComparison
FROM Employees emp
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID
WHERE emp.IsActive = 1
ORDER BY mgr.LastName, emp.LastName;
```

#### Question 2: Employee Colleagues
**Task:** Find employees who work in the same department.

```sql
-- Answer 2: Employee Colleagues
SELECT 
    e1.FirstName + ' ' + e1.LastName AS Employee1,
    e2.FirstName + ' ' + e2.LastName AS Employee2,
    d.DepartmentName,
    ABS(e1.BaseSalary - e2.BaseSalary) AS SalaryDifference,
    CASE 
        WHEN e1.ManagerID = e2.ManagerID THEN 'Same Manager'
        ELSE 'Different Manager'
    END AS ManagerStatus
FROM Employees e1
INNER JOIN Employees e2 ON e1.DepartmentID = e2.DepartmentID AND e1.EmployeeID < e2.EmployeeID
INNER JOIN Departments d ON e1.DepartmentID = d.DepartmentID
WHERE e1.IsActive = 1 AND e2.IsActive = 1
ORDER BY d.DepartmentName, e1.LastName, e2.LastName;
```

#### Question 3: Hierarchical Structure
**Task:** Show the organizational hierarchy using recursive-style query.

```sql
-- Answer 3: Hierarchical Structure
WITH EmployeeHierarchy AS (
    -- Anchor: Top-level managers
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS EmployeeName,
        Title,
        ManagerID,
        CAST(FirstName + ' ' + LastName AS NVARCHAR(500)) AS HierarchyPath,
        0 AS Level
    FROM Employees 
    WHERE ManagerID IS NULL AND IsActive = 1
    
    UNION ALL
    
    -- Recursive: Employees with managers
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.Title,
        e.ManagerID,
        CAST(eh.HierarchyPath + ' -> ' + e.FirstName + ' ' + e.LastName AS NVARCHAR(500)),
        eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
    WHERE e.IsActive = 1
)
SELECT 
    Level,
    REPLICATE('  ', Level) + EmployeeName AS IndentedName,
    Title,
    HierarchyPath
FROM EmployeeHierarchy
ORDER BY HierarchyPath;
```

## Exercise 4: Advanced Join Scenarios - Answers

### Task 4.1: Multiple Join Types in One Query - Answers

#### Question 1: Comprehensive Employee Report
**Task:** Create a comprehensive employee report using multiple join types.

```sql
-- Answer 1: Comprehensive Employee Report
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    e.BaseSalary,
    d.DepartmentName,
    COALESCE(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
    COALESCE(COUNT(DISTINCT ep.ProjectID), 0) AS ProjectsAssigned,
    COALESCE(SUM(ep.HoursWorked), 0) AS TotalHoursWorked,
    COALESCE(AVG(CAST(ep.HoursWorked AS FLOAT)), 0) AS AvgHoursPerProject,
    COUNT(sub.EmployeeID) AS DirectReports
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Employees sub ON e.EmployeeID = sub.ManagerID AND sub.IsActive = 1
WHERE e.IsActive = 1
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName, e.Title, e.BaseSalary,
    d.DepartmentName, mgr.FirstName, mgr.LastName
ORDER BY d.DepartmentName, e.LastName;
```

### Task 4.2: Join with Subqueries - Answers

#### Question 1: Employees Working on High-Budget Projects
**Task:** Find employees working on projects with above-average budgets.

```sql
-- Answer 1: Employees Working on High-Budget Projects
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    d.DepartmentName,
    p.ProjectName,
    p.Budget AS ProjectBudget,
    avgbudget.AverageProjectBudget,
    p.Budget - avgbudget.AverageProjectBudget AS BudgetDifference,
    ep.Role AS ProjectRole,
    ep.HoursAllocated
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
CROSS JOIN (
    SELECT AVG(Budget) AS AverageProjectBudget
    FROM Projects
) avgbudget
WHERE p.Budget > avgbudget.AverageProjectBudget
  AND e.IsActive = 1
ORDER BY p.Budget DESC, e.LastName;
```

#### Question 2: Department Performance Comparison
**Task:** Compare department performance against company averages.

```sql
-- Answer 2: Department Performance Comparison
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.BaseSalary) AS DeptAvgSalary,
    comp.CompanyAvgSalary,
    AVG(e.BaseSalary) - comp.CompanyAvgSalary AS SalaryVariance,
    SUM(e.BaseSalary) AS DeptTotalPayroll,
    d.Budget AS DeptBudget,
    d.Budget - SUM(e.BaseSalary) AS BudgetRemaining,
    CASE 
        WHEN AVG(e.BaseSalary) > comp.CompanyAvgSalary THEN 'Above Average'
        WHEN AVG(e.BaseSalary) = comp.CompanyAvgSalary THEN 'At Average'
        ELSE 'Below Average'
    END AS PerformanceCategory
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
CROSS JOIN (
    SELECT AVG(BaseSalary) AS CompanyAvgSalary
    FROM Employees
    WHERE IsActive = 1
) comp
GROUP BY 
    d.DepartmentID, d.DepartmentName, d.Budget, comp.CompanyAvgSalary
ORDER BY DeptAvgSalary DESC;
```

### Task 4.3: Complex Join Conditions - Answers

#### Question 1: Skills Gap Analysis
**Task:** Find employees and skills they don't have but are common in their department.

```sql
-- Answer 1: Skills Gap Analysis
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    d.DepartmentName,
    s.SkillName,
    s.SkillCategory,
    deptskills.EmployeesWithSkill,
    deptskills.TotalDeptEmployees,
    CAST((deptskills.EmployeesWithSkill * 100.0) / deptskills.TotalDeptEmployees AS DECIMAL(5,1)) AS SkillPrevalence
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
CROSS JOIN Skills s
INNER JOIN (
    SELECT 
        e2.DepartmentID,
        es.SkillID,
        COUNT(DISTINCT es.EmployeeID) AS EmployeesWithSkill,
        COUNT(DISTINCT e2.EmployeeID) AS TotalDeptEmployees
    FROM Employees e2
    LEFT JOIN EmployeeSkills es ON e2.EmployeeID = es.EmployeeID
    WHERE e2.IsActive = 1
    GROUP BY e2.DepartmentID, es.SkillID
    HAVING COUNT(DISTINCT es.EmployeeID) >= 2  -- Skill present in at least 2 employees
) deptskills ON e.DepartmentID = deptskills.DepartmentID AND s.SkillID = deptskills.SkillID
LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID AND s.SkillID = es.SkillID
WHERE e.IsActive = 1
  AND es.EmployeeID IS NULL  -- Employee doesn't have this skill
ORDER BY d.DepartmentName, SkillPrevalence DESC, e.LastName;
```

## Exercise 5: Join Performance and Optimization - Answers

### Task 5.1: Join Optimization Strategies - Answers

#### Question 1: Optimized Employee Project Report
**Task:** Create an optimized query for employee project reporting.

```sql
-- Answer 1: Optimized Employee Project Report
-- Using specific columns and appropriate indexes
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName AS Department,
    p.ProjectName,
    ep.Role,
    ep.HoursWorked,
    p.Status AS ProjectStatus
FROM Employees e WITH (INDEX(IX_Employees_DepartmentID))  -- Hint for index usage
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1
  AND p.Status IN ('In Progress', 'Completed')  -- More selective filtering
ORDER BY e.EmployeeID, p.ProjectID;  -- Order by indexed columns
```

### Task 5.2: Alternative Join Approaches - Answers

#### Question 1: EXISTS vs JOIN Comparison
**Task:** Show different approaches to find employees with projects.

```sql
-- Answer 1: EXISTS vs JOIN Comparison

-- Method 1: Using EXISTS (good for checking existence)
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND EXISTS (
      SELECT 1 
      FROM EmployeeProjects ep 
      WHERE ep.EmployeeID = e.EmployeeID
  )
ORDER BY e.LastName;

-- Method 2: Using INNER JOIN with DISTINCT (when you need related data)
SELECT DISTINCT
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1
ORDER BY e.LastName;

-- Method 3: Using IN with subquery (less efficient for large datasets)
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Title,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.EmployeeID IN (
      SELECT DISTINCT EmployeeID 
      FROM EmployeeProjects
  )
ORDER BY e.LastName;
```

## Key Learning Points Summary

### Join Types Mastery
1. **INNER JOIN**: Returns only matching records from both tables
2. **LEFT OUTER JOIN**: Returns all records from left table, matching from right
3. **RIGHT OUTER JOIN**: Returns all records from right table, matching from left
4. **FULL OUTER JOIN**: Returns all records from both tables
5. **CROSS JOIN**: Returns Cartesian product of both tables
6. **SELF JOIN**: Joins table to itself using aliases

### Join Syntax and Best Practices
1. **ANSI-92 Syntax**: Use explicit JOIN keywords instead of comma-separated tables
2. **Table Aliases**: Use meaningful short aliases for readability
3. **Join Conditions**: Always specify clear join conditions in ON clause
4. **Column Qualification**: Prefix columns with table aliases to avoid ambiguity

### Performance Optimization
1. **Index Usage**: Ensure join columns are properly indexed
2. **Filtering Early**: Apply WHERE conditions to reduce result set size
3. **Specific Columns**: Select only needed columns instead of SELECT *
4. **Join Order**: SQL Server optimizer handles join order, but be aware of implications

### Common Join Patterns
1. **One-to-Many**: Employee to Department relationship
2. **Many-to-Many**: Employee to Project through EmployeeProjects
3. **Hierarchical**: Employee to Manager self-join
4. **Lookup Tables**: Employee to Skills through EmployeeSkills

### Advanced Techniques Applied
1. **Multiple Join Types**: Combining different join types in single query
2. **Subquery Integration**: Using subqueries within join conditions
3. **Aggregation with Joins**: GROUP BY and aggregate functions with joins
4. **Conditional Logic**: CASE expressions in joined queries
5. **NULL Handling**: COALESCE and ISNULL in outer joins

### Troubleshooting Common Issues
1. **Cartesian Products**: Ensure proper join conditions to avoid unintended cross joins
2. **Duplicate Rows**: Use DISTINCT or proper GROUP BY to eliminate duplicates
3. **NULL Values**: Handle NULL values appropriately in outer joins
4. **Performance Issues**: Monitor execution plans and optimize join conditions