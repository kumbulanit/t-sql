# Lesson 4: Writing Simple CASE Expressions

## Overview
CASE expressions are powerful conditional logic tools in T-SQL that allow you to implement if-then-else logic directly in queries. They enable dynamic value assignment, data categorization, and complex business rule implementation. This lesson covers both simple and searched CASE expressions, from basic usage to advanced scenarios.

## Understanding CASE Expressions

### What are CASE Expressions?
CASE expressions evaluate conditions and return different values based on those conditions. They're similar to if-then-else statements in programming languages but work within SQL queries.

### Two Types of CASE Expressions:
1. **Simple CASE**: Compares an expression to a set of simple values
2. **Searched CASE**: Evaluates a set of Boolean expressions

### Basic Syntax
```sql
-- Simple CASE
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END

-- Searched CASE
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

## Simple Examples

### 1. Basic Simple CASE
```sql
-- Simple CASE based on department ID
SELECT 
    FirstName,
    LastName,
    DepartmentID,
    CASE DepartmentID
        WHEN 1 THEN 'Information Technology'
        WHEN 2 THEN 'Human Resources'
        WHEN 3 THEN 'Finance'
        WHEN 4 THEN 'Marketing'
        WHEN 5 THEN 'Operations'
        ELSE 'Unknown Department'
    END AS DepartmentName
FROM Employees;

-- Simple CASE for status indicators
SELECT 
    FirstName,
    LastName,
    IsActive,
    CASE IsActive
        WHEN 1 THEN 'Active'
        WHEN 0 THEN 'Inactive'
        ELSE 'Unknown'
    END AS EmployeeIsActive
FROM Employees;
```

### 2. Basic Searched CASE
```sql
-- Searched CASE for BaseSalary categorization
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary < 40000 THEN 'Entry Level'
        WHEN BaseSalary BETWEEN 40000 AND 70000 THEN 'Mid Level'
        WHEN BaseSalary BETWEEN 70001 AND 100000 THEN 'Senior Level'
        WHEN BaseSalary > 100000 THEN 'Executive Level'
        ELSE 'Unclassified'
    END AS SalaryCategory
FROM Employees;

-- CASE for tenure analysis
SELECT 
    FirstName,
    LastName,
    HireDate,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 1 AND 3 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 4 AND 7 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) > 7 THEN 'Veteran'
        ELSE 'Unknown'
    END AS ExperienceLevel
FROM Employees;
```

### 3. CASE in SELECT with Calculations
```sql
-- CASE for bonus calculations
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary >= 90000 THEN BaseSalary * 0.15
        WHEN BaseSalary >= 70000 THEN BaseSalary * 0.10
        WHEN BaseSalary >= 50000 THEN BaseSalary * 0.05
        ELSE 1000
    END AS BonusAmount,
    CASE 
        WHEN DepartmentID = 1 THEN 'Tech Bonus: $2000'
        WHEN DepartmentID = 4 THEN 'Sales Bonus: $1500'
        ELSE 'Standard Benefits'
    END AS AdditionalBenefits
FROM Employees;
```

## Intermediate Examples

### 1. CASE with String Operations
```sql
-- Complex string formatting with CASE
SELECT 
    FirstName,
    LastName,
    WorkEmail,
    CASE 
        WHEN WorkEmail LIKE '%@company.com' THEN 'Internal Employee'
        WHEN WorkEmail LIKE '%@contractor.%' THEN 'External Contractor'
        WHEN WorkEmail IS NULL THEN 'No WorkEmail on File'
        ELSE 'External WorkEmail'
    END AS EmailType,
    CASE 
        WHEN LEN(FirstName) + LEN(LastName) > 20 THEN 
            LEFT(FirstName, 1) + '. ' + LastName
        ELSE FirstName + ' ' + LastName
    END AS DisplayName,
    CASE 
        WHEN MiddleName IS NOT NULL THEN 
            FirstName + ' ' + LEFT(MiddleName, 1) + '. ' + LastName
        ELSE FirstName + ' ' + LastName
    END AS FormalName
FROM Employees;
```

### 2. CASE with Date Operations
```sql
-- Date-based business logic
SELECT 
    FirstName,
    LastName,
    HireDate,
    CASE 
        WHEN MONTH(HireDate) IN (12, 1, 2) THEN 'Winter Hire'
        WHEN MONTH(HireDate) IN (3, 4, 5) THEN 'Spring Hire'
        WHEN MONTH(HireDate) IN (6, 7, 8) THEN 'Summer Hire'
        ELSE 'Fall Hire'
    END AS HireSeason,
    CASE 
        WHEN DATEDIFF(DAY, HireDate, GETDATE()) < 90 THEN 'Probationary Period'
        WHEN DATEDIFF(MONTH, HireDate, GETDATE()) < 12 THEN 'First Year'
        ELSE 'Established Employee'
    END AS EmploymentPhase,
    CASE 
        WHEN DATEPART(WEEKDAY, HireDate) IN (2, 3, 4, 5, 6) THEN 'Weekday Start'
        ELSE 'Weekend Start'
    END AS StartDayType
FROM Employees;
```

### 3. CASE in WHERE Clauses
```sql
-- Using CASE in WHERE clause for conditional filtering
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID,
    Title
FROM Employees
WHERE 
    CASE 
        WHEN DepartmentID = 1 THEN BaseSalary >= 70000  -- IT requires higher BaseSalary
        WHEN DepartmentID = 2 THEN BaseSalary >= 50000  -- HR standard BaseSalary
        WHEN DepartmentID = 3 THEN BaseSalary >= 60000  -- Finance requires higher BaseSalary
        ELSE BaseSalary >= 45000                        -- Other departments
    END = 1;

-- Complex conditional WHERE logic
SELECT *
FROM Employees
WHERE 
    CASE 
        WHEN Title LIKE '%Manager%' THEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 3
        WHEN Title LIKE '%Director%' THEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5
        WHEN Title LIKE '%Senior%' THEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 2
        ELSE DATEDIFF(YEAR, HireDate, GETDATE()) >= 0
    END = 1;
```

### 4. CASE with Aggregation
```sql
-- CASE in aggregate functions
SELECT 
    DepartmentID,
    COUNT(*) AS TotalEmployees,
    COUNT(CASE WHEN BaseSalary >= 70000 THEN 1 END) AS HighSalaryEmployees,
    COUNT(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN 1 END) AS VeteranEmployees,
    SUM(CASE 
        WHEN DepartmentID = 1 THEN BaseSalary * 1.1  -- IT gets 10% bonus
        WHEN DepartmentID = 4 THEN BaseSalary * 1.05 -- Marketing gets 5% bonus
        ELSE BaseSalary
    END) AS AdjustedSalaryTotal,
    AVG(CASE 
        WHEN IsActive = 1 THEN BaseSalary 
        ELSE NULL 
    END) AS ActiveEmployeeAvgSalary
FROM Employees
GROUP BY DepartmentIDID;
```

## Advanced Examples

### 1. Nested CASE Expressions
```sql
-- Complex nested CASE logic
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID,
    HireDate,
    CASE 
        WHEN DepartmentID = 1 THEN  -- IT Department
            CASE 
                WHEN BaseSalary >= 90000 THEN 'IT Senior Architect'
                WHEN BaseSalary >= 70000 THEN 'IT Senior Developer'
                WHEN BaseSalary >= 50000 THEN 'IT Developer'
                ELSE 'IT Junior'
            END
        WHEN DepartmentID = 2 THEN  -- HR Department
            CASE 
                WHEN BaseSalary >= 80000 THEN 'HR Director'
                WHEN BaseSalary >= 60000 THEN 'HR Manager'
                ELSE 'HR Specialist'
            END
        WHEN DepartmentID = 3 THEN  -- Finance Department
            CASE 
                WHEN BaseSalary >= 85000 THEN 'Finance Director'
                WHEN BaseSalary >= 65000 THEN 'Senior Analyst'
                ELSE 'Financial Analyst'
            END
        ELSE 'Other Department Role'
    END AS DetailedRole,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN
            CASE 
                WHEN BaseSalary >= 100000 THEN 'Senior Executive Track'
                WHEN BaseSalary >= 80000 THEN 'Senior Management Track'
                ELSE 'Senior Individual Contributor'
            END
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN
            CASE 
                WHEN BaseSalary >= 80000 THEN 'Management Track'
                ELSE 'Senior Contributor'
            END
        ELSE 'Developing Professional'
    END AS CareerTrack
FROM Employees;
```

### 2. CASE with Complex Business Rules
```sql
-- Advanced business logic implementation
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.DepartmentID,
    e.HireDate,
    e.Title,
    -- Complex eligibility determination
    CASE 
        WHEN e.IsActive = 0 THEN 'Not Eligible - Inactive'
        WHEN DATEDIFF(MONTH, e.HireDate, GETDATE()) < 6 THEN 'Not Eligible - Tenure'
        WHEN e.DepartmentID = 1 AND e.BaseSalary < 60000 THEN 'Not Eligible - IT BaseSalary Threshold'
        WHEN e.DepartmentID = 3 AND e.Title NOT LIKE '%Analyst%' AND e.Title NOT LIKE '%Manager%' 
             THEN 'Not Eligible - Finance Role Requirement'
        WHEN EXISTS (
            SELECT 1 FROM EmployeeProjects ep 
            WHERE ep.EmployeeID = e.EmployeeID 
            AND ep.HoursWorked < ep.HoursAllocated * 0.8
        ) THEN 'Not Eligible - Performance Issue'
        ELSE 'Eligible for Promotion Review'
    END AS PromotionEligibility,
    -- Dynamic bonus calculation
    CASE 
        WHEN e.DepartmentID = 1 THEN  -- IT Department
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM EmployeeProjects ep 
                    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
                    WHERE ep.EmployeeID = e.EmployeeID 
                    AND p.IsActive = 'Completed'
                    AND ep.HoursWorked <= ep.HoursAllocated
                ) THEN e.BaseSalary * 0.15  -- Project completion bonus
                ELSE e.BaseSalary * 0.08    -- Standard IT bonus
            END
        WHEN e.DepartmentID = 4 THEN  -- Marketing Department
            CASE 
                WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 
                     AND e.BaseSalary >= 60000 THEN e.BaseSalary * 0.12
                ELSE e.BaseSalary * 0.06
            END
        ELSE e.BaseSalary * 0.05  -- Standard bonus for other departments
    END AS CalculatedBonus
FROM Employees e;
```

### 3. CASE with Window Functions
```sql
-- CASE expressions with analytical functions
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID,
    CASE 
        WHEN RANK() OVER (PARTITION BY DepartmentIDID ORDER BY BaseSalary DESC) = 1 
             THEN 'Department Top Earner'
        WHEN RANK() OVER (PARTITION BY DepartmentIDID ORDER BY BaseSalary DESC) <= 3 
             THEN 'Department Top 3'
        WHEN PERCENT_RANK() OVER (PARTITION BY DepartmentIDID ORDER BY BaseSalary) >= 0.75 
             THEN 'Department Top Quartile'
        WHEN PERCENT_RANK() OVER (PARTITION BY DepartmentIDID ORDER BY BaseSalary) >= 0.5 
             THEN 'Department Above Median'
        ELSE 'Department Below Median'
    END AS SalaryPosition,
    CASE 
        WHEN BaseSalary > AVG(BaseSalary) OVER (PARTITION BY DepartmentIDID) * 1.2 
             THEN 'Significantly Above Dept Average'
        WHEN BaseSalary > AVG(BaseSalary) OVER (PARTITION BY DepartmentIDID) 
             THEN 'Above Department Average'
        WHEN BaseSalary < AVG(BaseSalary) OVER (PARTITION BY DepartmentIDID) * 0.8 
             THEN 'Significantly Below Dept Average'
        ELSE 'Near Department Average'
    END AS SalaryComparison
FROM Employees;
```

### 4. CASE in Complex Joins
```sql
-- CASE expressions in join conditions and complex scenarios
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    p.ProjectName,
    CASE 
        WHEN ep.EmployeeID IS NULL THEN 'No Project Assignment'
        WHEN p.IsActive = 'Completed' THEN 'Completed Project'
        WHEN p.IsActive = 'In Progress' AND ep.HoursWorked > ep.HoursAllocated 
             THEN 'Over-allocated on Active Project'
        WHEN p.IsActive = 'In Progress' AND ep.HoursWorked < ep.HoursAllocated * 0.5 
             THEN 'Under-utilized on Active Project'
        WHEN p.IsActive = 'In Progress' THEN 'Actively Working'
        ELSE 'Unknown Project IsActive'
    END AS ProjectIsActive,
    CASE 
        WHEN ep.EmployeeID IS NOT NULL AND p.ProjectID IS NOT NULL THEN
            CASE 
                WHEN ep.HoursWorked = 0 THEN 'Project Not Started'
                WHEN ep.HoursWorked >= ep.HoursAllocated THEN 'Project Complete'
                ELSE CONCAT(
                    CAST(ROUND(ep.HoursWorked / ep.HoursAllocated * 100, 1) AS VARCHAR), 
                    '% Complete'
                )
            END
        ELSE 'N/A'
    END AS CompletionIsActive
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1;
```

## CASE Best Practices

### 1. Always Include ELSE Clause
```sql
-- Good: Always include ELSE for completeness
SELECT 
    FirstName,
    LastName,
    CASE DepartmentID
        WHEN 1 THEN 'IT'
        WHEN 2 THEN 'HR'
        WHEN 3 THEN 'Finance'
        ELSE 'Other'  -- Always include ELSE
    END AS Department
FROM Employees;

-- Risky: Missing ELSE can result in NULL values
-- CASE DepartmentID
--     WHEN 1 THEN 'IT'
--     WHEN 2 THEN 'HR'
-- END AS Department  -- What happens with DepartmentID = 3?
```

### 2. Order Conditions Appropriately
```sql
-- Good: Order from most specific to least specific
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary > 100000 THEN 'Executive'      -- Most specific first
        WHEN BaseSalary > 80000 THEN 'Senior'
        WHEN BaseSalary > 60000 THEN 'Mid-Level'
        WHEN BaseSalary > 40000 THEN 'Entry-Level'
        ELSE 'Intern'                              -- Catch-all last
    END AS Level
FROM Employees;

-- Problematic: Wrong order can cause incorrect results
-- CASE 
--     WHEN BaseSalary > 40000 THEN 'Entry-Level'  -- This catches everyone > 40k!
--     WHEN BaseSalary > 80000 THEN 'Senior'       -- This will never execute
--     ELSE 'Intern'
-- END
```

### 3. Use Consistent Data Types
```sql
-- Good: Consistent return types
SELECT 
    FirstName,
    LastName,
    CASE 
        WHEN BaseSalary > 80000 THEN 'High'
        WHEN BaseSalary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryLevel
FROM Employees;

-- Problematic: Mixed data types
-- CASE 
--     WHEN BaseSalary > 80000 THEN 'High'    -- String
--     WHEN BaseSalary > 50000 THEN 1         -- Integer
--     ELSE NULL                          -- NULL
-- END
```

### 4. Consider Performance with Complex CASE
```sql
-- For frequently used complex CASE logic, consider computed columns
-- or views instead of repeating the logic

-- Instead of repeating this complex CASE in multiple queries:
CASE 
    WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 AND BaseSalary >= 100000 
         AND DepartmentID IN (1, 3, 4) 
         AND Title LIKE '%Senior%' OR Title LIKE '%Manager%' 
         THEN 'Executive Track'
    WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 AND BaseSalary >= 70000 
         THEN 'Management Track'
    ELSE 'Individual Contributor'
END

-- Consider creating a computed column or view
```

## Common Mistakes and How to Avoid Them

### 1. Missing ELSE Clause
```sql
-- Problem: Unexpected NULLs
SELECT 
    FirstName,
    CASE DepartmentID
        WHEN 1 THEN 'IT'
        WHEN 2 THEN 'HR'
        -- Missing ELSE - what about DepartmentID 3, 4, 5?
    END AS Department
FROM Employees;

-- Solution: Always include ELSE
SELECT 
    FirstName,
    CASE DepartmentID
        WHEN 1 THEN 'IT'
        WHEN 2 THEN 'HR'
        ELSE 'Other Department'
    END AS Department
FROM Employees;
```

### 2. Incorrect Condition Order
```sql
-- Problem: Overlapping conditions
SELECT 
    BaseSalary,
    CASE 
        WHEN BaseSalary > 50000 THEN 'Above 50k'    -- This catches 80k salaries
        WHEN BaseSalary > 80000 THEN 'Above 80k'    -- This never executes!
        ELSE 'Below 50k'
    END AS Range
FROM Employees;

-- Solution: Order from highest to lowest
SELECT 
    BaseSalary,
    CASE 
        WHEN BaseSalary > 80000 THEN 'Above 80k'
        WHEN BaseSalary > 50000 THEN 'Above 50k'
        ELSE 'Below 50k'
    END AS Range
FROM Employees;
```

### 3. Data Type Inconsistency
```sql
-- Problem: Mixed return types cause conversion issues
SELECT 
    CASE 
        WHEN BaseSalary > 80000 THEN BaseSalary      -- Returns number
        WHEN BaseSalary > 50000 THEN 'Medium'    -- Returns string
        ELSE NULL                            -- Returns NULL
    END AS Result
FROM Employees;

-- Solution: Consistent return types
SELECT 
    CASE 
        WHEN BaseSalary > 80000 THEN CAST(BaseSalary AS VARCHAR)
        WHEN BaseSalary > 50000 THEN 'Medium BaseSalary'
        ELSE 'Low BaseSalary'
    END AS Result
FROM Employees;
```

## Performance Considerations

### 1. CASE vs. Multiple Queries
```sql
-- Single query with CASE (generally more efficient)
SELECT 
    DepartmentID,
    COUNT(CASE WHEN BaseSalary > 70000 THEN 1 END) AS HighSalary,
    COUNT(CASE WHEN BaseSalary BETWEEN 40000 AND 70000 THEN 1 END) AS MidSalary,
    COUNT(CASE WHEN BaseSalary < 40000 THEN 1 END) AS LowSalary
FROM Employees
GROUP BY DepartmentIDID;

-- vs. Multiple separate queries (less efficient)
-- SELECT DepartmentID, COUNT(*) FROM Employees WHERE BaseSalary > 70000 GROUP BY DepartmentIDID;
-- SELECT DepartmentID, COUNT(*) FROM Employees WHERE BaseSalary BETWEEN 40000 AND 70000 GROUP BY DepartmentIDID;
-- SELECT DepartmentID, COUNT(*) FROM Employees WHERE BaseSalary < 40000 GROUP BY DepartmentIDID;
```

### 2. Simple vs. Searched CASE Performance
```sql
-- Simple CASE (slightly more efficient for equality comparisons)
CASE DepartmentID
    WHEN 1 THEN 'IT'
    WHEN 2 THEN 'HR'
    WHEN 3 THEN 'Finance'
    ELSE 'Other'
END

-- Searched CASE (necessary for complex conditions)
CASE 
    WHEN DepartmentID = 1 THEN 'IT'
    WHEN DepartmentID = 2 THEN 'HR'
    WHEN DepartmentID = 3 THEN 'Finance'
    ELSE 'Other'
END
```

## Summary

Key principles for effective CASE expression usage:

1. **Always Include ELSE**: Prevents unexpected NULL values
2. **Order Conditions Correctly**: Most specific to least specific
3. **Consistent Data Types**: All branches should return compatible types
4. **Use Simple CASE for Equality**: More efficient than searched CASE
5. **Consider Performance**: Complex CASE logic might need optimization
6. **Readable Logic**: Break complex conditions into understandable parts
7. **Test Thoroughly**: Verify all condition branches work as expected

CASE expressions are fundamental for implementing business logic in SQL queries, enabling sophisticated data transformation and conditional processing directly within your queries.
