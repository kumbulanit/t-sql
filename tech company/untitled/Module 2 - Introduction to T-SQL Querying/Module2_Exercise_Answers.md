# Module 2 Exercise Answers: T-SQL Fundamentals

## Answer Key Overview
This document provides complete solutions to all exercises in Module 2, with explanations of the logic and concepts applied.

---

## Exercise 1: T-SQL Basics (25 points)

### 1.1 Basic Queries Solutions

**Answer 1.1.1**: Employee Information with Formatting
```sql
SELECT 
    e.LastName + ', ' + e.FirstName + 
    CASE 
        WHEN MiddleName IS NOT NULL THEN ' ' + LEFT(MiddleName, 1) + '.'
        ELSE ''
    END AS FullName,
    FORMAT(e.BaseSalary, 'C', 'en-US') AS FormattedSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) AS EmailDomain
FROM Employees e
ORDER BY e.LastName, e.FirstName;
```

**Explanation**: Uses CASE for NULL handling, FORMAT for currency display, DATEDIFF for tenure calculation, and string functions for email parsing.

**Answer 1.1.2**: Employee BaseSalary Categorization
```sql
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary < 55000 THEN 'Entry Level'
        WHEN e.BaseSalary BETWEEN 55000 AND 75000 THEN 'Mid Level'
        WHEN e.BaseSalary BETWEEN 75001 AND 90000 THEN 'Senior Level'
        ELSE 'Executive'
    END AS SalaryCategory
FROM Employees e
ORDER BY e.BaseSalary DESC;
```

**Explanation**: Uses CASE statement with BETWEEN for range categorization, ordered by BaseSalary for easy verification.

**Answer 1.1.3**: Longest Tenure by d.DepartmentName
```sql
WITH EmployeeTenure AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        ROW_NUMBER() OVER (PARTITION BY e.d.DepartmentID ORDER BY e.HireDate ASC) AS TenureRank
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
)
SELECT d.DepartmentName,
    EmployeeName,
    YearsOfService
FROM EmployeeTenure
WHERE TenureRank = 1
ORDER BY YearsOfService DESC;
```

**Explanation**: Uses CTE with ROW_NUMBER() window function to rank employees by hire date within each d.DepartmentName, then filters for the most senior employee.

**Answer 1.1.4**: Employees Hired in Same Month
```sql
SELECT 
    DATENAME(MONTH, e.HireDate) AS HireMonth,
    YEAR(e.HireDate) AS HireYear,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate
FROM Employees e
WHERE MONTH(e.HireDate) IN (
    SELECT MONTH(e.HireDate)
    FROM Employees e
    GROUP BY MONTH(e.HireDate)
    HAVING COUNT(*) > 1
)
ORDER BY MONTH(e.HireDate), YEAR(e.HireDate);
```

**Explanation**: Subquery identifies months with multiple hires, main query shows all employees hired in those months.

**Answer 1.1.5**: Potential WorkEmail Conflicts
```sql
WITH EmailBase AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        LOWER(e.FirstName + '.' + e.LastName) AS PotentialEmail,
        WorkEmail
    FROM Employees e
)
SELECT 
    eb1.EmployeeName AS Employee1,
    eb2.EmployeeName AS Employee2,
    eb1.PotentialEmail AS ConflictingEmailPattern
FROM EmailBase eb1
INNER JOIN EmailBase eb2 ON eb1.PotentialEmail = eb2.PotentialEmail
    AND eb1.EmployeeID < eb2.EmployeeID
ORDER BY eb1.PotentialEmail;
```

**Explanation**: Self-join on potential email patterns to find conflicts, using inequality to avoid duplicate pairs.

---

## Exercise 2: Set Operations and Logic (30 points)

### 2.1 Set Operations Solutions

**Answer 2.1.1**: Departments by d.Budget or BaseSalary Criteria
```sql
SELECT d.DepartmentName, 'High d.Budget' AS Reason
FROM Departments d
WHERE d.Budget > 300000

UNION

SELECT d.DepartmentName, 'High Average e.BaseSalary' AS Reason
FROM Departments d
WHERE d.DepartmentID IN (
    SELECT e.d.DepartmentID
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
    GROUP BY e.d.DepartmentID
    HAVING AVG(e.BaseSalary) > 70000
)
ORDER BY DepartmentIDName;
```

**Explanation**: UNION combines departments meeting either criteria, with reason codes to explain inclusion.

**Answer 2.1.2**: Employee Project IsActive Alignment
```sql
-- Employees in IT working on "In Progress" projects
SELECT e.EmployeeID
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.d.DepartmentID = 1 AND p.IsActive = 'In Progress'

INTERSECT

-- Employees in Marketing working on "Completed" projects
SELECT e.EmployeeID
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.d.DepartmentID = 4 AND p.IsActive = 'Completed';
```

**Explanation**: INTERSECT finds employees whose project assignments align with d.DepartmentName expectations.

**Answer 2.1.3**: Well-Funded But Unassigned Employees
```sql
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    d.Budget,
    'Potential underutilization' AS ManagementConcern
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.d.DepartmentID IN (
    SELECT d.DepartmentID FROM Departments d WHERE d.Budget > 250000
)

EXCEPT

SELECT 
    e.FirstName + ' ' + e.LastName,
    d.DepartmentName,
    d.Budget,
    'Potential underutilization'
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID;
```

**Explanation**: EXCEPT identifies employees in well-funded departments who aren't assigned to projects.

**Answer 2.1.4**: Employee Project Participation Categories
```sql
-- Project Leaders (2+ projects)
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    'Project Leader' AS Category
FROM Employees e
WHERE e.EmployeeID IN (
    SELECT e.EmployeeID 
    FROM EmployeeProjects 
    GROUP BY e.EmployeeID 
    HAVING COUNT(*) >= 2
)

UNION

-- Contributors (exactly 1 project)
SELECT 
    e.FirstName + ' ' + e.LastName,
    'Contributor'
FROM Employees e
WHERE e.EmployeeID IN (
    SELECT e.EmployeeID 
    FROM EmployeeProjects 
    GROUP BY e.EmployeeID 
    HAVING COUNT(*) = 1
)

UNION

-- Available (no projects)
SELECT 
    e.FirstName + ' ' + e.LastName,
    'Available'
FROM Employees e
WHERE e.EmployeeID NOT IN (
    SELECT DISTINCT e.EmployeeID FROM EmployeeProjects
)
ORDER BY Category, EmployeeName;
```

**Explanation**: Multiple categories combined with UNION, using aggregation and NOT IN for different participation levels.

**Answer 2.1.5**: Skill Gap Analysis (Conceptual)
```sql
-- Assuming a Skills table exists, this would identify gaps
WITH ProjectRequiredSkills AS (
    -- Hypothetical: projects require certain skills
    SELECT ProjectID, 'Database Design' AS RequiredSkill FROM Projects p WHERE ProjectName LIKE '%ERP%'
    UNION
    SELECT ProjectID, 'Web Development' FROM Projects p WHERE ProjectName LIKE '%Website%'
),
EmployeeActualSkills AS (
    -- Hypothetical: employee actual skills
    SELECT e.EmployeeID, 'Database Design' AS Skill
    FROM Employees e WHERE e.d.DepartmentID = 1
    UNION
    SELECT e.EmployeeID, 'Web Development'
    FROM Employees e WHERE e.JobTitle LIKE '%Developer%'
)
-- Find employees on projects lacking required skills
SELECT DISTINCT e.FirstName + ' ' + e.LastName AS Employee, 
       p.ProjectName,
       prs.RequiredSkill
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
INNER JOIN ProjectRequiredSkills prs ON p.ProjectID = prs.ProjectID
WHERE NOT EXISTS (
    SELECT 1 FROM EmployeeActualSkills eas 
    WHERE eas.EmployeeID = e.EmployeeID 
    AND eas.Skill = prs.RequiredSkill
);
```

**Explanation**: Demonstrates set operations for identifying mismatches between required and actual skills.

### 2.2 Complex Predicates Solutions

**Answer 2.2.1**: Complex Multi-Criteria Employee Filter
```sql
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate,
    e.BaseSalary,
    d.DepartmentName,
    e.MiddleName,
    e.JobTitle
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND (e.HireDate > '2020-12-31' OR e.BaseSalary > 80000)
  AND d.Budget > 200000
  AND (e.MiddleName IS NULL OR e.JobTitle LIKE '%Director%')
ORDER BY e.BaseSalary DESC;
```

**Explanation**: Complex AND/OR logic with NULL handling and pattern matching, demonstrating predicate precedence.

**Answer 2.2.2**: Departments with Above-Average Employees and Projects
```sql
SELECT DISTINCT d.DepartmentName
FROM Departments d
WHERE EXISTS (
    -- At least one employee earns more than d.DepartmentName average
    SELECT 1
    FROM Employees e e1
    WHERE e1.d.DepartmentID = d.DepartmentID
      AND e1.BaseSalary > (
          SELECT AVG(e2.BaseSalary)
          FROM Employees e e2
          WHERE e2.d.DepartmentID = d.DepartmentID
      )
)
AND EXISTS (
    -- At least one project assigned to d.DepartmentName employees
    SELECT 1
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.d.DepartmentID = d.DepartmentID
)
AND d.Budget > (
    -- d.Budget justified by employee cost
    SELECT SUM(e.BaseSalary) * 1.5  -- 50% overhead assumption
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.d.DepartmentID = d.DepartmentID
);
```

**Explanation**: Multiple EXISTS clauses with correlated subqueries testing different business conditions.

**Answer 2.2.3**: Resource Allocation Issues Identification
```sql
-- Projects with no employee assignments
SELECT p.ProjectName, 'No employees assigned' AS Issue
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1 FROM EmployeeProjects ep 
    WHERE ep.ProjectID = p.ProjectID
)

UNION

-- Departments with no active projects
SELECT d.DepartmentName + ' Department', 'No active projects'
FROM Departments d
WHERE NOT EXISTS (
    SELECT 1 
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE e.d.DepartmentID = d.DepartmentID
      AND p.IsActive = 'In Progress'
)

UNION

-- High-budget departments with low utilization
SELECT d.DepartmentName + ' Department', 'High budget, low utilization'
FROM Departments d
WHERE d.Budget > 300000
  AND NOT EXISTS (
      SELECT 1
      FROM Employees e
      INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
      WHERE e.d.DepartmentID = d.DepartmentID
      GROUP BY e.d.DepartmentID
      HAVING COUNT(*) >= 2
  );
```

**Explanation**: NOT EXISTS pattern for identifying various resource allocation gaps.

---

## Exercise 3: Logical Order Understanding (25 points)

### 3.1 Processing Order Analysis Solutions

**Answer 3.1.1**: Query Analysis and Fix
```sql
-- PROBLEM: 'TeamSize' column doesn't exist and is used in WHERE before being defined

-- INCORRECT QUERY ISSUES:
-- 1. 'TeamSize' is not a column in any table
-- 2. Even if it were an alias, it can't be used in WHERE clause
-- 3. Logical order: FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

-- CORRECTED VERSION:
SELECT d.DepartmentName, 
    AVG(e.BaseSalary) as AvgSal,
    COUNT(*) as TeamSize
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
WHERE e.IsActive = 1  -- Use actual column in WHERE
GROUP BY d.DepartmentName
HAVING COUNT(*) > 2   -- Use HAVING for aggregate conditions
   AND AVG(e.BaseSalary) > 60000
ORDER BY AvgSal DESC;
```

**Explanation**: 
- **Processing Order**: FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
- **Error**: TeamSize used in WHERE but not yet calculated
- **Fix**: Move aggregate condition to HAVING, add WHERE for row-level filtering

**Answer 3.1.2**: Alias Scope Issue Analysis and Fix
```sql
-- PROBLEM: 'Category' alias used in WHERE clause before SELECT processing

-- INCORRECT QUERY ISSUES:
-- 1. Aliases created in SELECT are not available in WHERE clause
-- 2. 'ProjectCount' alias similarly not available in WHERE
-- 3. Logical processing order prevents this usage

-- CORRECTED VERSION - Option 1 (Subquery):
SELECT *
FROM (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        ISNULL(ProjectCount, 0) AS ProjectCount,
        CASE WHEN ISNULL(ProjectCount, 0) > 1 THEN 'Multi-Project' ELSE 'Single-Project' END AS Category
    FROM Employees e
    LEFT JOIN (
        SELECT e.EmployeeID, COUNT(*) AS ProjectCount
        FROM EmployeeProjects 
        GROUP BY e.EmployeeID
    ) p ON e.EmployeeID = p.EmployeeID
) emp_with_category
WHERE Category = 'Multi-Project'
ORDER BY ProjectCount DESC;

-- CORRECTED VERSION - Option 2 (CTE):
WITH EmployeeProjects AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        ISNULL(ProjectCount, 0) AS ProjectCount,
        CASE WHEN ISNULL(ProjectCount, 0) > 1 THEN 'Multi-Project' ELSE 'Single-Project' END AS Category
    FROM Employees e
    LEFT JOIN (
        SELECT e.EmployeeID, COUNT(*) AS ProjectCount
        FROM EmployeeProjects 
        GROUP BY e.EmployeeID
    ) p ON e.EmployeeID = p.EmployeeID
)
SELECT *
FROM EmployeeProjects
WHERE Category = 'Multi-Project'
ORDER BY ProjectCount DESC;
```

**Explanation**: 
- **Issue**: Aliases created in SELECT not available in WHERE
- **Solution**: Use subquery or CTE to make aliases available for filtering
- **Processing Order**: Inner query completes before outer query WHERE clause

**Answer 3.1.3**: WHERE vs HAVING Demonstration
```sql
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AvgSalary
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.HireDate > '2020-12-31'  -- WHERE: filters individual rows before grouping
  AND e.IsActive = 1             -- WHERE: row-level filter
GROUP BY d.DepartmentName
HAVING AVG(e.BaseSalary) > 65000;    -- HAVING: filters groups after aggregation

-- EXPLANATION OF FILTER PLACEMENT:
-- WHERE filters are applied to individual rows BEFORE grouping
-- - e.HireDate > '2020-12-31': filters employees hired after 2020
-- - e.IsActive = 1: filters only active employees
-- These filters reduce the dataset before expensive grouping operations

-- HAVING filters are applied to grouped results AFTER aggregation
-- - AVG(e.BaseSalary) > 65000: filters departments based on calculated average
-- This filter can only work after the GROUP BY creates d.DepartmentName groups
```

**Explanation**:
- **WHERE**: Filters individual rows before grouping (more efficient)
- **HAVING**: Filters groups after aggregation (necessary for aggregate conditions)
- **Performance**: WHERE reduces rows early, improving GROUP BY performance

---

## Exercise 4: Advanced Integration (20 points)

### 4.1 Comprehensive Scenarios Solutions

**Answer 4.1.1**: Management Dashboard Query
```sql
WITH DepartmentMetrics AS (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Budget,
        COUNT(e.EmployeeID) AS EmployeeCount,
        AVG(e.BaseSalary) AS AvgSalary,
        SUM(e.BaseSalary) AS TotalBaseSalaryCost,
        COUNT(DISTINCT ep.ProjectID) AS ProjectCount
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.d.DepartmentID AND e.IsActive = 1
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    GROUP BY d.DepartmentID, d.DepartmentName, d.Budget
),
ResourceUtilization AS (
    SELECT 
        e.d.DepartmentID,
        SUM(ep.HoursAllocated) AS TotalHoursAllocated,
        SUM(ep.HoursWorked) AS TotalHoursWorked,
        CASE 
            WHEN SUM(ep.HoursAllocated) > 0 
            THEN ROUND(SUM(ep.HoursWorked) * 100.0 / SUM(ep.HoursAllocated), 1)
            ELSE 0 
        END AS UtilizationPercent
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    GROUP BY e.d.DepartmentID
),
DepartmentRanking AS (
    SELECT 
        dm.*,
        ISNULL(ru.TotalHoursAllocated, 0) AS TotalHoursAllocated,
        ISNULL(ru.TotalHoursWorked, 0) AS TotalHoursWorked,
        ISNULL(ru.UtilizationPercent, 0) AS UtilizationPercent,
        ROW_NUMBER() OVER (ORDER BY 
            CASE WHEN dm.EmployeeCount > 0 THEN ru.UtilizationPercent ELSE 0 END DESC,
            dm.AvgSalary DESC
        ) AS ProductivityRank,
        CASE 
            WHEN dm.EmployeeCount = 0 THEN 'No Active Employees'
            WHEN dm.ProjectCount = 0 THEN 'No Project Assignments'
            WHEN ISNULL(ru.UtilizationPercent, 0) < 70 THEN 'Low Utilization'
            WHEN dm.TotalSalaryCost > dm.d.Budget * 0.8 THEN 'High e.BaseSalary Burden'
            ELSE 'Good Performance'
        END AS AttentionFlag
    FROM DepartmentMetrics dm
    LEFT JOIN ResourceUtilization ru ON dm.d.DepartmentID = ru.d.DepartmentID
)
SELECT d.DepartmentName,
    EmployeeCount,
    FORMAT(AvgSalary, 'C0') AS AvgSalary,
    ProjectCount,
    TotalHoursAllocated,
    TotalHoursWorked,
    UtilizationPercent,
    ProductivityRank,
    AttentionFlag
FROM DepartmentRanking
ORDER BY ProductivityRank;
```

**Explanation**: Multi-CTE approach calculating d.DepartmentName metrics, resource utilization, and providing management insights with ranking and attention flags.

**Answer 4.1.2**: Employee Career Path Analysis
```sql
WITH EmployeeMetrics AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        d.DepartmentName,
        DATEDIFF(MONTH, e.HireDate, GETDATE()) AS TenureMonths,
        COUNT(ep.ProjectID) AS ProjectCount,
        AVG(ep.HoursWorked) AS AvgProjectHours
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, 
             e.HireDate, d.DepartmentName
),
DepartmentBenchmarks AS (
    SELECT d.DepartmentName,
        AVG(e.BaseSalary) AS DeptAvgSalary,
        AVG(TenureMonths) AS DeptAvgTenure,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.BaseSalary) 
            OVER (PARTITION BY DepartmentIDName) AS Salary75thPercentile
    FROM EmployeeMetrics
    GROUP BY DepartmentIDName
),
CareerAnalysis AS (
    SELECT 
        em.*,
        db.DeptAvgSalary,
        db.DeptAvgTenure,
        db.Salary75thPercentile,
        CASE 
            WHEN em.BaseSalary >= db.Salary75thPercentile THEN 'High Performer'
            WHEN em.BaseSalary >= db.DeptAvgSalary THEN 'Above Average'
            ELSE 'Below Average'
        END AS SalaryPosition,
        CASE 
            WHEN em.TenureMonths >= 36 AND em.BaseSalary < db.DeptAvgSalary THEN 'Promotion Candidate'
            WHEN em.TenureMonths >= 24 AND em.ProjectCount >= 2 THEN 'Development Ready'
            WHEN em.TenureMonths < 12 THEN 'New Employee'
            ELSE 'Stable'
        END AS CareerStage,
        CASE 
            WHEN em.Title NOT LIKE '%Senior%' AND em.TenureMonths >= 36 
                 AND em.BaseSalary >= db.DeptAvgSalary THEN 'Senior Role Transition'
            WHEN em.Title NOT LIKE '%Manager%' AND em.Title NOT LIKE '%Director%' 
                 AND em.TenureMonths >= 60 AND em.ProjectCount >= 3 THEN 'Leadership Track'
            WHEN em.ProjectCount = 0 AND em.TenureMonths >= 6 THEN 'Project Assignment Needed'
            ELSE 'Current Role Appropriate'
        END AS DevelopmentOpportunity
    FROM EmployeeMetrics em
    INNER JOIN DepartmentBenchmarks db ON em.DepartmentName = db.d.DepartmentName
)
SELECT 
    EmployeeName,
    Title,
    DepartmentName,
    FORMAT(e.BaseSalary, 'C0') AS CurrentSalary,
    TenureMonths,
    ProjectCount,
    SalaryPosition,
    CareerStage,
    DevelopmentOpportunity
FROM CareerAnalysis
WHERE CareerStage IN ('Promotion Candidate', 'Development Ready') 
   OR DevelopmentOpportunity != 'Current Role Appropriate'
ORDER BY 
    CASE CareerStage 
        WHEN 'Promotion Candidate' THEN 1
        WHEN 'Development Ready' THEN 2
        ELSE 3
    END,
    TenureMonths DESC;
```

**Explanation**: Complex analysis using multiple CTEs, percentile functions, and business logic to identify career development opportunities.

---

## Bonus Challenge Solution (10 points)

**Bonus Answer**: Resource Optimization Problem
```sql
-- Comprehensive Resource Optimization Analysis
WITH EmployeeWorkload AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.DepartmentID,
        d.DepartmentName,
        e.JobTitle,
        ISNULL(SUM(ep.HoursAllocated), 0) AS TotalAllocated,
        ISNULL(SUM(ep.HoursWorked), 0) AS TotalWorked,
        ISNULL(SUM(ep.HoursAllocated) - SUM(ep.HoursWorked), 0) AS VarianceHours,
        COUNT(ep.ProjectID) AS ProjectCount
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.DepartmentID, 
             d.DepartmentName, e.JobTitle
),
WorkloadCategories AS (
    SELECT *,
        CASE 
            WHEN TotalAllocated = 0 THEN 'Unassigned'
            WHEN TotalWorked > TotalAllocated * 1.1 THEN 'Overallocated'
            WHEN TotalWorked < TotalAllocated * 0.8 THEN 'Underutilized'
            ELSE 'Balanced'
        END AS WorkloadIsActive,
        CASE 
            WHEN TotalAllocated > 0 
            THEN ROUND(TotalWorked * 100.0 / TotalAllocated, 1)
            ELSE 0 
        END AS UtilizationRate
    FROM EmployeeWorkload
),
ProjectAnalysis AS (
    SELECT 
        p.ProjectID,
        p.ProjectName,
        p.IsActive,
        p.Budget,
        COUNT(ep.EmployeeID) AS AssignedEmployees,
        SUM(ep.HoursAllocated) AS ProjectHoursAllocated,
        SUM(ep.HoursWorked) AS ProjectHoursWorked,
        CASE 
            WHEN SUM(ep.HoursAllocated) > 0 
            THEN ROUND(SUM(ep.HoursWorked) * 100.0 / SUM(ep.HoursAllocated), 1)
            ELSE 0 
        END AS ProjectCompletion
    FROM Projects p
    LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
    GROUP BY p.ProjectID, p.ProjectName, p.IsActive, p.Budget
),
OptimizationOpportunities AS (
    SELECT 
        'Employee Reallocation' AS OpportunityType,
        'Overallocated: ' + EmployeeName AS Description,
        DepartmentName,
        1 AS Priority,
        'Reduce workload by ' + CAST(ABS(VarianceHours) AS VARCHAR) + ' hours' AS Recommendation
    FROM WorkloadCategories
    WHERE WorkloadIsActive = 'Overallocated'
    
    UNION ALL
    
    SELECT 
        'Resource Assignment',
        'Underutilized: ' + EmployeeName,
        DepartmentName,
        2,
        'Can take on ' + CAST(ABS(VarianceHours) AS VARCHAR) + ' additional hours'
    FROM WorkloadCategories
    WHERE WorkloadIsActive = 'Underutilized'
    
    UNION ALL
    
    SELECT 
        'Project Staffing',
        'Unassigned: ' + EmployeeName,
        DepartmentName,
        3,
        'Available for project assignment'
    FROM WorkloadCategories
    WHERE WorkloadIsActive = 'Unassigned'
    
    UNION ALL
    
    SELECT 
        'Project Risk',
        'Behind Schedule: ' + pa.ProjectName,
        'All Departments',
        1,
        'Project at ' + CAST(pa.ProjectCompletion AS VARCHAR) + '% completion'
    FROM ProjectAnalysis pa
    WHERE pa.IsActive = 'In Progress' AND pa.ProjectCompletion < 75
),
ImpactAnalysis AS (
    SELECT wc.d.DepartmentName,
        COUNT(CASE WHEN wc.WorkloadIsActive = 'Overallocated' THEN 1 END) AS OverallocatedCount,
        COUNT(CASE WHEN wc.WorkloadIsActive = 'Underutilized' THEN 1 END) AS UnderutilizedCount,
        COUNT(CASE WHEN wc.WorkloadIsActive = 'Unassigned' THEN 1 END) AS UnassignedCount,
        AVG(wc.UtilizationRate) AS DeptUtilizationRate,
        SUM(ABS(wc.VarianceHours)) AS TotalVarianceHours
    FROM WorkloadCategories wc
    GROUP BY wc.d.DepartmentName
)
-- Final Results: Management Action Plan
SELECT 
    'RESOURCE OPTIMIZATION SUMMARY' AS ReportSection,
    '' AS DepartmentName,
    '' AS Employee_Project,
    '' AS IsActive_Priority,
    'Total Issues: ' + CAST(COUNT(*) AS VARCHAR) AS Recommendation
FROM OptimizationOpportunities

UNION ALL

SELECT 
    'IMMEDIATE ACTIONS (Priority 1)',
    LEFT(Description, 30),
    '',
    CAST(Priority AS VARCHAR),
    Recommendation
FROM OptimizationOpportunities
WHERE Priority = 1

UNION ALL

SELECT 
    'OPTIMIZATION OPPORTUNITIES (Priority 2-3)',
    LEFT(Description, 30),
    '',
    CAST(Priority AS VARCHAR),
    Recommendation
FROM OptimizationOpportunities
WHERE Priority > 1

UNION ALL

SELECT 
    'DEPARTMENT IMPACT ANALYSIS',
    ia.DepartmentName,
    'Util Rate: ' + CAST(ia.DeptUtilizationRate AS VARCHAR) + '%',
    'Variance: ' + CAST(ia.TotalVarianceHours AS VARCHAR) + 'h',
    'Over:' + CAST(ia.OverallocatedCount AS VARCHAR) + 
    ' Under:' + CAST(ia.UnderutilizedCount AS VARCHAR) +
    ' Unassigned:' + CAST(ia.UnassignedCount AS VARCHAR)
FROM ImpactAnalysis ia

ORDER BY 
    CASE ReportSection 
        WHEN 'RESOURCE OPTIMIZATION SUMMARY' THEN 1
        WHEN 'IMMEDIATE ACTIONS (Priority 1)' THEN 2
        WHEN 'OPTIMIZATION OPPORTUNITIES (Priority 2-3)' THEN 3
        WHEN 'DEPARTMENT IMPACT ANALYSIS' THEN 4
    END,
    IsActive_Priority;
```

**Business Logic Explanation**:

1. **Overallocation Detection**: Employees working >110% of allocated hours
2. **Underutilization**: Employees working <80% of allocated hours  
3. **Project Risk**: Projects <75% complete flagged as behind schedule
4. **Priority System**: 
   - Priority 1: Immediate risks (overallocation, behind projects)
   - Priority 2: Optimization opportunities (underutilization)
   - Priority 3: Available resources (unassigned employees)

**Performance Considerations**:
- Uses CTEs for modular, readable code
- Aggregations grouped efficiently
- Results structured for management action

**Actionable Insights**:
- Clear priority ranking for management decisions
- Quantified impact (hours variance) for resource planning
- Department-level analysis for strategic decisions
- Specific recommendations for each identified issue

This solution demonstrates mastery of T-SQL concepts while providing real business value through actionable resource optimization insights.

---

## Summary of Key Concepts Demonstrated

1. **T-SQL Fundamentals**: String functions, date calculations, data type handling
2. **Set Operations**: UNION, INTERSECT, EXCEPT for complex data combinations
3. **Predicate Logic**: Complex WHERE conditions, NULL handling, EXISTS patterns
4. **Logical Order**: Proper use of WHERE vs HAVING, alias scoping, processing sequence
5. **Advanced Integration**: CTEs, window functions, complex business logic
6. **Performance Awareness**: Efficient query structure, proper indexing considerations
7. **Business Application**: Real-world problem solving with actionable results

These solutions provide a comprehensive foundation for advanced T-SQL development and database programming.
