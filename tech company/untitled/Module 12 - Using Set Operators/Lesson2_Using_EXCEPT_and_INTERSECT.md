# Lesson 2: Using EXCEPT and INTERSECT

## Overview

The EXCEPT and INTERSECT operators are powerful set operators that enable sophisticated data comparison and analysis. EXCEPT finds rows that exist in the first query but not in the second, while INTERSECT finds rows that exist in both queries. These operators are essential for data auditing, comparison analysis, and identifying relationships between datasets. For TechCorp's business intelligence and data quality initiatives, these operators provide precise tools for identifying data discrepancies and commonalities.

## 🏢 TechCorp Business Context

**EXCEPT and INTERSECT in Business Analysis:**

- **Data Auditing**: Identifying discrepancies between expected and actual data
- **Employee Analysis**: Finding employees who meet specific criteria combinations
- **Project Management**: Comparing planned vs. actual project assignments
- **Customer Analysis**: Identifying customer behavior patterns and segments
- **Compliance Reporting**: Ensuring data consistency across different systems

### 📋 TechCorp Database Schema Reference

**Core Tables for EXCEPT/INTERSECT Examples:**

```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
```

---

## 2.1 Understanding EXCEPT Operator

### EXCEPT Operator Fundamentals

The EXCEPT operator returns rows from the first query that do not exist in the second query, effectively performing a "subtraction" operation on datasets.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            EXCEPT Operator Syntax                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SELECT column1, column2, ... FROM table1                                  │
│  WHERE condition1                                                           │
│  EXCEPT                                                                     │
│  SELECT column1, column2, ... FROM table2                                  │
│  WHERE condition2                                                           │
│                                                                             │
│  Key Characteristics:                                                      │
│  • Returns distinct rows from first query not in second query             │
│  • Automatically removes duplicates (like UNION, not UNION ALL)           │
│  • Column count and data types must match between queries                 │
│  • Result column names come from first query                              │
│  • ORDER BY can only appear at the end                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### TechCorp Example: Identifying Unassigned Employees

```sql
-- Example: Find employees who are not currently assigned to any active projects
-- This helps identify available resources for new project assignments

-- Find employees without current project assignments
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

EXCEPT

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1
AND ep.IsActive = 1
AND (ep.EndDate IS NULL OR ep.EndDate > GETDATE())

ORDER BY d.DepartmentName, EmployeeName;

-- Verification: Count available employees by d.DepartmentName
SELECT 
    'Available Resource Summary' AS ReportType,
    d.DepartmentName,
    COUNT(*) AS AvailableEmployees,
    AVG(e.BaseSalary) AS AverageBaseSalary
FROM (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1

    EXCEPT

    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    AND ep.IsActive = 1
    AND (ep.EndDate IS NULL OR ep.EndDate > GETDATE())
) AS AvailableEmployees e
INNER JOIN Departments d ON d.DepartmentName = d.DepartmentName
GROUP BY d.DepartmentName
ORDER BY AvailableEmployees DESC;
```

---

## 2.2 Understanding INTERSECT Operator

### INTERSECT Operator Fundamentals

The INTERSECT operator returns only the rows that exist in both queries, effectively finding the common elements between two datasets.

```sql
-- TechCorp Example: Find employees who are both project managers and team members
-- This identifies employees with dual roles in project management

-- Find employees who serve as both project managers and team members
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
WHERE e.IsActive = 1 AND p.IsActive = 1

INTERSECT

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE e.IsActive = 1 AND ep.IsActive = 1

ORDER BY d.DepartmentName, EmployeeName;

-- Extended analysis: Show their dual roles
SELECT 
    dual_role.EmployeeID,
    dual_role.EmployeeName,
    d.DepartmentName,
    'PROJECT_MANAGER' AS RoleType,
    p.ProjectName AS ProjectContext,
    d.Budget AS RelatedBudget
FROM (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE e.IsActive = 1 AND p.IsActive = 1

    INTERSECT

    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1 AND ep.IsActive = 1
) AS dual_role
INNER JOIN Projects p ON dual_role.EmployeeID = p.ProjectManagerID
WHERE p.IsActive = 1

UNION ALL

SELECT 
    dual_role.EmployeeID,
    dual_role.EmployeeName,
    d.DepartmentName,
    'TEAM_MEMBER' AS RoleType,
    p.ProjectName AS ProjectContext,
    NULL AS RelatedBudget
FROM (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE e.IsActive = 1 AND p.IsActive = 1

    INTERSECT

    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1 AND ep.IsActive = 1
) AS dual_role
INNER JOIN EmployeeProjects ep ON dual_role.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE ep.IsActive = 1 AND p.IsActive = 1

ORDER BY e.EmployeeID, RoleType, ProjectContext;
```

---

## 2.3 Advanced EXCEPT Operations

### Data Quality and Auditing with EXCEPT

```sql
-- TechCorp Example: Data Integrity Audit
-- Identify data inconsistencies between related tables

-- Find customers who have placed orders but don't have complete profile information
-- Step 1: Customers who have placed orders
WITH OrderingCustomers AS (
    SELECT DISTINCT
        c.CustomerID,
        c.CustomerName,
        CONCAT(c.ContactFirstName, ' ', c.ContactLastName),
        c.City,
        c.CountryID,
        c.WorkEmail
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1 AND o.IsActive = 1
),

-- Step 2: Customers with complete profiles
CompleteProfiles AS (
    SELECT 
        CustomerID,
        CompanyName,
        ContactName,
        City,
        Country,
        WorkEmail
    FROM Customers
    WHERE IsActive = 1
    AND CompanyName IS NOT NULL
    AND ContactName IS NOT NULL
    AND City IS NOT NULL
    AND Country IS NOT NULL
    AND WorkEmail IS NOT NULL
    AND LEN(TRIM(CompanyName)) > 0
    AND LEN(TRIM(ContactName)) > 0
    AND LEN(TRIM(City)) > 0
    AND LEN(TRIM(Country)) > 0
    AND WorkEmail LIKE '%@%'
)

-- Find ordering customers with incomplete profiles
SELECT 
    oc.CustomerID,
    oc.CompanyName,
    oc.ContactName,
    oc.City,
    oc.Country,
    oc.WorkEmail,
    CASE 
        WHEN oc.CompanyName IS NULL OR LEN(TRIM(oc.CompanyName)) = 0 THEN 'Missing Company Name; '
        ELSE ''
    END +
    CASE 
        WHEN oc.ContactName IS NULL OR LEN(TRIM(oc.ContactName)) = 0 THEN 'Missing Contact Name; '
        ELSE ''
    END +
    CASE 
        WHEN oc.City IS NULL OR LEN(TRIM(oc.City)) = 0 THEN 'Missing City; '
        ELSE ''
    END +
    CASE 
        WHEN oc.Country IS NULL OR LEN(TRIM(oc.Country)) = 0 THEN 'Missing Country; '
        ELSE ''
    END +
    CASE 
        WHEN oc.WorkEmail IS NULL OR oc.WorkEmail NOT LIKE '%@%' THEN 'Invalid Email; '
        ELSE ''
    END AS DataIssues
FROM OrderingCustomers oc

EXCEPT

SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    City,
    Country,
    WorkEmail,
    '' AS DataIssues
FROM CompleteProfiles

ORDER BY CustomerID;

-- Summary of data quality issues
SELECT 
    'Data Quality Summary' AS ReportType,
    COUNT(*) AS CustomersWithIssues,
    SUM(CASE WHEN DataIssues LIKE '%Company Name%' THEN 1 ELSE 0 END) AS MissingCompanyName,
    SUM(CASE WHEN DataIssues LIKE '%Contact Name%' THEN 1 ELSE 0 END) AS MissingContactName,
    SUM(CASE WHEN DataIssues LIKE '%City%' THEN 1 ELSE 0 END) AS MissingCity,
    SUM(CASE WHEN DataIssues LIKE '%Country%' THEN 1 ELSE 0 END) AS MissingCountry,
    SUM(CASE WHEN DataIssues LIKE '%Email%' THEN 1 ELSE 0 END) AS InvalidEmail
FROM (
    SELECT 
        oc.CustomerID,
        CASE 
            WHEN oc.CompanyName IS NULL OR LEN(TRIM(oc.CompanyName)) = 0 THEN 'Missing Company Name; '
            ELSE ''
        END +
        CASE 
            WHEN oc.ContactName IS NULL OR LEN(TRIM(oc.ContactName)) = 0 THEN 'Missing Contact Name; '
            ELSE ''
        END +
        CASE 
            WHEN oc.City IS NULL OR LEN(TRIM(oc.City)) = 0 THEN 'Missing City; '
            ELSE ''
        END +
        CASE 
            WHEN oc.Country IS NULL OR LEN(TRIM(oc.Country)) = 0 THEN 'Missing Country; '
            ELSE ''
        END +
        CASE 
            WHEN oc.WorkEmail IS NULL OR oc.WorkEmail NOT LIKE '%@%' THEN 'Invalid Email; '
            ELSE ''
        END AS DataIssues
    FROM OrderingCustomers oc

    EXCEPT

    SELECT 
        CustomerID,
        '' AS DataIssues
    FROM CompleteProfiles
) AS DataQualityIssues;
```

---

## 2.4 Advanced INTERSECT Operations

### Complex Business Logic with INTERSECT

```sql
-- TechCorp Example: High-Value Employee Identification
-- Find employees who meet multiple high-performance criteria

-- Criteria 1: High e.BaseSalary employees (top 25% in their department)
WITH HighSalaryEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentID,
        e.BaseSalary
    FROM Employees e
    WHERE e.IsActive = 1
    AND e.BaseSalary >= (
        SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.BaseSalary)
        FROM Employees e e2 
        WHERE d.DepartmentID = d.DepartmentID 
        AND e2.IsActive = 1
    )
),

-- Criteria 2: Highly engaged employees (involved in multiple projects)
HighlyEngagedEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentID,
        e.BaseSalary
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    AND ep.IsActive = 1
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentID, e.BaseSalary
    HAVING COUNT(DISTINCT ep.ProjectID) >= 2
),

-- Criteria 3: Long-tenure employees (with company 3+ years)
LongTenureEmployees AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentID,
        e.BaseSalary
    FROM Employees e
    WHERE e.IsActive = 1
    AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3
)

-- Find employees who meet all three criteria using INTERSECT
SELECT 
    hse.EmployeeID,
    hse.EmployeeName,
    d.DepartmentName,
    hse.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    COUNT(DISTINCT ep.ProjectID) AS RecentProjects,
    'HIGH_VALUE_EMPLOYEE' AS EmployeeCategory
FROM HighSalaryEmployees hse

INTERSECT

SELECT 
    hee.EmployeeID,
    hee.EmployeeName,
    d.DepartmentID,
    hee.BaseSalary,
    NULL,
    NULL,
    'HIGH_VALUE_EMPLOYEE'
FROM HighlyEngagedEmployees hee

INTERSECT

SELECT 
    lte.EmployeeID,
    lte.EmployeeName,
    d.DepartmentID,
    lte.BaseSalary,
    NULL,
    NULL,
    'HIGH_VALUE_EMPLOYEE'
FROM LongTenureEmployees lte

-- Join back to get complete information
SELECT 
    high_value.EmployeeID,
    high_value.EmployeeName,
    d.DepartmentName,
    high_value.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    (SELECT COUNT(DISTINCT ep.ProjectID) 
     FROM EmployeeProjects ep 
     WHERE ep.EmployeeID = high_value.EmployeeID 
     AND ep.IsActive = 1 
     AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())) AS RecentProjects,
    (SELECT AVG(e.BaseSalary) 
     FROM Employees e 
     WHERE d.DepartmentID = d.DepartmentID 
     AND IsActive = 1) AS DepartmentAvgSalary,
    FORMAT((high_value.BaseSalary / (SELECT AVG(e.BaseSalary) 
                                    FROM Employees e 
                                    WHERE d.DepartmentID = d.DepartmentID 
                                    AND IsActive = 1) - 1) * 100, 'N1') + '%' AS SalaryAboveAverage
FROM (
    SELECT e.EmployeeID, EmployeeName, d.DepartmentID, e.BaseSalary
    FROM HighSalaryEmployees
    
    INTERSECT
    
    SELECT e.EmployeeID, EmployeeName, d.DepartmentID, e.BaseSalary
    FROM HighlyEngagedEmployees
    
    INTERSECT
    
    SELECT e.EmployeeID, EmployeeName, d.DepartmentID, e.BaseSalary
    FROM LongTenureEmployees
) AS high_value
INNER JOIN Employees e ON high_value.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, high_value.BaseSalary DESC;
```

---

## 2.5 Combining EXCEPT and INTERSECT

### Complex Data Analysis Scenarios

```sql
-- TechCorp Example: Project Resource Optimization Analysis
-- Complex analysis combining multiple set operations

-- Step 1: Define different employee categories
WITH TechnicalEmployees AS (
    SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName
    FROM Employees e
    WHERE IsActive = 1
    AND (e.JobTitle LIKE '%Developer%' 
         OR e.JobTitle LIKE '%Engineer%' 
         OR e.JobTitle LIKE '%Architect%'
         OR e.JobTitle LIKE '%Analyst%')
),

ManagementEmployees AS (
    SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName
    FROM Employees e
    WHERE IsActive = 1
    AND (e.JobTitle LIKE '%Manager%' 
         OR e.JobTitle LIKE '%Director%' 
         OR e.JobTitle LIKE '%Lead%'
         OR e.JobTitle LIKE '%Supervisor%')
),

ProjectAssignedEmployees AS (
    SELECT DISTINCT e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1
    AND ep.IsActive = 1
    AND (ep.EndDate IS NULL OR ep.EndDate > GETDATE())
),

HighPerformanceProjects AS (
    SELECT DISTINCT ep.EmployeeID
    FROM EmployeeProjects ep
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE ep.IsActive = 1
    AND p.IsActive = 1
    AND d.Budget > 100000  -- High-value projects
    AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
)

-- Analysis 1: Technical employees not currently assigned to projects
SELECT 
    'AVAILABLE_TECHNICAL_RESOURCES' AS AnalysisType,
    te.EmployeeID,
    te.EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM TechnicalEmployees te

EXCEPT

SELECT 
    'AVAILABLE_TECHNICAL_RESOURCES' AS AnalysisType,
    pae.EmployeeID,
    pae.EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM ProjectAssignedEmployees pae
INNER JOIN Employees e ON pae.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID

UNION ALL

-- Analysis 2: Management employees who are also working on high-performance projects
SELECT 
    'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' AS AnalysisType,
    me.EmployeeID,
    me.EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM ManagementEmployees me

INTERSECT

SELECT 
    'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' AS AnalysisType,
    hpp.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM HighPerformanceProjects hpp
INNER JOIN Employees e ON hpp.EmployeeID = e.EmployeeID
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID

ORDER BY AnalysisType, d.DepartmentName, EmployeeName;

-- Summary statistics for resource planning
SELECT 
    'Resource Planning Summary' AS ReportType,
    COUNT(CASE WHEN AnalysisType = 'AVAILABLE_TECHNICAL_RESOURCES' THEN 1 END) AS AvailableTechnicalResources,
    COUNT(CASE WHEN AnalysisType = 'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' THEN 1 END) AS MgmtOnHighValueProjects,
    AVG(CASE WHEN AnalysisType = 'AVAILABLE_TECHNICAL_RESOURCES' THEN e.BaseSalary END) AS AvgAvailableTechSalary,
    AVG(CASE WHEN AnalysisType = 'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' THEN e.BaseSalary END) AS AvgMgmtHighValueSalary
FROM (
    -- Repeat the above UNION ALL query here for summary
    SELECT 
        'AVAILABLE_TECHNICAL_RESOURCES' AS AnalysisType,
        te.BaseSalary
    FROM TechnicalEmployees te
    EXCEPT
    SELECT 
        'AVAILABLE_TECHNICAL_RESOURCES' AS AnalysisType,
        e.BaseSalary
    FROM ProjectAssignedEmployees pae
    INNER JOIN Employees e ON pae.EmployeeID = e.EmployeeID
    
    UNION ALL
    
    SELECT 
        'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' AS AnalysisType,
        e.BaseSalary
    FROM ManagementEmployees me
    INNER JOIN Employees e ON me.EmployeeID = e.EmployeeID
    INTERSECT
    SELECT 
        'MANAGEMENT_ON_HIGH_VALUE_PROJECTS' AS AnalysisType,
        e.BaseSalary
    FROM HighPerformanceProjects hpp
    INNER JOIN Employees e ON hpp.EmployeeID = e.EmployeeID
) AS ResourceAnalysis;
```

---

## 2.6 Using APPLY Operator

### APPLY Operator Fundamentals

The APPLY operator enables you to invoke a table-valued function for each row of a table expression. There are two forms: CROSS APPLY and OUTER APPLY.

```sql
-- TechCorp Example: Using CROSS APPLY for correlated operations
-- Find top 3 highest-paid employees in each d.DepartmentName

-- Using CROSS APPLY to get top employees per d.DepartmentName
SELECT d.DepartmentName,
    top_employees.EmployeeRank,
    top_employees.EmployeeName,
    top_employees.JobTitle,
    top_employees.BaseSalary,
    top_employees.HireDate
FROM Departments d
CROSS APPLY (
    SELECT TOP 3
        ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS EmployeeRank,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
    ORDER BY e.BaseSalary DESC
) AS top_employees
WHERE d.IsActive = 1
ORDER BY d.DepartmentName, top_employees.EmployeeRank;

-- Using OUTER APPLY to include departments without employees
SELECT d.DepartmentName,
    d.Budget AS DepartmentBudget,
    ISNULL(emp_stats.EmployeeCount, 0) AS EmployeeCount,
    ISNULL(emp_stats.TotalSalaryExpense, 0) AS TotalSalaryExpense,
    ISNULL(emp_stats.AverageSalary, 0) AS AverageBaseSalary,
    CASE 
        WHEN emp_stats.EmployeeCount IS NULL THEN 'No Employees'
        WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.8 THEN 'High e.BaseSalary Utilization'
        WHEN emp_stats.TotalSalaryExpense > d.Budget * 0.6 THEN 'Moderate e.BaseSalary Utilization'
        ELSE 'Low e.BaseSalary Utilization'
    END AS BudgetUtilizationStatus
FROM Departments d
OUTER APPLY (
    SELECT 
        COUNT(*) AS EmployeeCount,
        SUM(e.BaseSalary) AS TotalSalaryExpense,
        AVG(e.BaseSalary) AS AverageBaseSalary
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE d.DepartmentID = d.DepartmentID
    AND e.IsActive = 1
) AS emp_stats
WHERE d.IsActive = 1
ORDER BY d.DepartmentName;
```

### Advanced APPLY Scenarios

```sql
-- TechCorp Example: Complex project analysis using APPLY
-- Analyze project performance with employee contribution details

-- Create a table-valued function for project analysis (run this separately)
/*
CREATE FUNCTION dbo.fn_GetProjectAnalysis(@ProjectID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ep.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        ep.Role,
        ep.HoursWorked,
        ep.HoursWorked * (e.BaseSalary / 2080) AS EstimatedCost, -- Assuming 2080 work hours per year
        RANK() OVER (ORDER BY ep.HoursWorked DESC) AS ContributionRank
    FROM EmployeeProjects ep
    INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE ep.ProjectID = @ProjectID
    AND ep.IsActive = 1
    AND e.IsActive = 1
);
*/

-- Use CROSS APPLY with the function for detailed project analysis
SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    pm.FirstName + ' ' + pm.LastName AS ProjectManager,
    p.StartDate,
    p.EndDate,
    project_analysis.EmployeeName,
    project_analysis.Role,
    project_analysis.HoursWorked,
    project_analysis.EstimatedCost,
    project_analysis.ContributionRank
FROM Projects p
INNER JOIN Employees pm ON p.ProjectManagerID = pm.EmployeeID
CROSS APPLY (
    SELECT 
        ep.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        ep.Role,
        ISNULL(ep.HoursWorked, 0) AS HoursWorked,
        ISNULL(ep.HoursWorked, 0) * (e.BaseSalary / 2080.0) AS EstimatedCost,
        RANK() OVER (ORDER BY ISNULL(ep.HoursWorked, 0) DESC) AS ContributionRank
    FROM EmployeeProjects ep
    INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE ep.ProjectID = p.ProjectID
    AND ep.IsActive = 1
    AND e.IsActive = 1
) AS project_analysis
WHERE p.IsActive = 1
AND project_analysis.HoursWorked > 0
ORDER BY p.ProjectID, project_analysis.ContributionRank;

-- Summary analysis using APPLY for project cost management
SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    project_costs.TotalEstimatedCost,
    project_costs.TeamSize,
    project_costs.AvgHoursPerEmployee,
    CASE 
        WHEN project_costs.TotalEstimatedCost > p.Budget THEN 'OVER_BUDGET'
        WHEN project_costs.TotalEstimatedCost > p.Budget * 0.9 THEN 'NEAR_BUDGET'
        ELSE 'UNDER_BUDGET'
    END AS BudgetStatus,
    FORMAT((project_costs.TotalEstimatedCost / NULLIF(p.Budget, 0) - 1) * 100, 'N1') + '%' AS BudgetVariance
FROM Projects p
OUTER APPLY (
    SELECT 
        COUNT(*) AS TeamSize,
        SUM(ISNULL(ep.HoursWorked, 0) * (e.BaseSalary / 2080.0)) AS TotalEstimatedCost,
        AVG(ISNULL(ep.HoursWorked, 0)) AS AvgHoursPerEmployee
    FROM EmployeeProjects ep
    INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE ep.ProjectID = p.ProjectID
    AND ep.IsActive = 1
    AND e.IsActive = 1
) AS project_costs
WHERE p.IsActive = 1
ORDER BY BudgetStatus DESC, project_costs.TotalEstimatedCost DESC;
```

---

## Summary

Using EXCEPT and INTERSECT operators, along with APPLY, provides TechCorp with powerful tools for sophisticated data analysis:

**Key Set Operator Concepts:**

- **EXCEPT**: Finds differences between datasets, essential for identifying missing or unique records
- **INTERSECT**: Finds commonalities between datasets, perfect for identifying overlapping criteria
- **APPLY**: Enables correlated operations and complex analytical scenarios

**TechCorp Applications:**

- **Data Quality Auditing**: Using EXCEPT to identify incomplete or inconsistent records
- **Resource Management**: Finding available employees and optimal resource allocation
- **Performance Analysis**: Identifying high-value employees meeting multiple criteria
- **Project Management**: Complex project analysis and cost management

**Advanced Techniques Demonstrated:**

- **Multi-criteria Analysis**: Using INTERSECT to find records meeting multiple complex conditions
- **Data Integrity Checking**: Using EXCEPT for comprehensive data quality validation
- **Correlated Operations**: Using APPLY for row-by-row analytical processing
- **Complex Business Logic**: Combining multiple set operations for sophisticated reporting

**Performance Considerations:**

- **Index Strategy**: Proper indexing for set operations on large datasets
- **Query Optimization**: Efficient use of CTEs and subqueries with set operations
- **Data Volume Management**: Techniques for handling large datasets in set operations

**Best Practices:**

- Ensure column compatibility and proper data types across all queries
- Use appropriate set operations based on duplicate handling requirements
- Implement proper filtering to minimize dataset sizes before set operations
- Consider performance implications when working with large datasets

Mastering these set operators enables TechCorp's development teams to perform sophisticated data analysis, maintain data quality, and generate comprehensive business intelligence reports that support critical decision-making processes.