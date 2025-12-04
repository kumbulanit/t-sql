# Lab Answers: Introduction to T-SQL Querying

## Section 1: Basic T-SQL Queries (Lesson 1) - Answers

### Exercise 1.1: Simple SELECT Statements - Answers

#### Question 1: Basic Selection
**Task:** Select all columns from the Employees table.

```sql
-- Answer 1: Basic Selection
SELECT * FROM Employees e;
```

#### Question 2: Column Selection
**Task:** Select only FirstName, LastName, and BaseSalary FROM Employees e.

```sql
-- Answer 2: Column Selection
SELECT e.FirstName, e.LastName, e.BaseSalary 
FROM Employees e;
```

#### Question 3: Calculated Columns
**Task:** Create a query that shows full name, annual BaseSalary, and monthly BaseSalary.

```sql
-- Answer 3: Calculated Columns
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    e.BaseSalary AS AnnualSalary,
    e.BaseSalary / 12 AS MonthlySalary
FROM Employees e;
```

#### Question 4: String Functions
**Task:** Create a query showing email username, domain, and full name in uppercase.

```sql
-- Answer 4: String Functions
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    LEFT(WorkEmail, CHARINDEX('@', WorkEmail) - 1) AS EmailUsername,
    SUBSTRING(WorkEmail, CHARINDEX('@', WorkEmail) + 1, LEN(WorkEmail)) AS EmailDomain,
    UPPER(e.FirstName + ' ' + e.LastName) AS FullNameUpper
FROM Employees e;
```

#### Question 5: Date Functions
**Task:** Create a query showing employee name, hire date, years of service, and hire year.

```sql
-- Answer 5: Date Functions
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    YEAR(e.HireDate) AS HireYear
FROM Employees e;
```

### Exercise 1.2: Filtering Data - Answers

#### Question 1: BaseSalary Filter
**Task:** Find all employees with BaseSalary greater than $70,000.

```sql
-- Answer 1: e.BaseSalary Filter
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > 70000;
```

#### Question 2: Hire Date Filter
**Task:** Find all employees hired after January 1, 2021.

```sql
-- Answer 2: Hire Date Filter
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
WHERE e.HireDate > '2021-01-01';
```

#### Question 3: d.DepartmentName Filter
**Task:** Find all employees in the IT d.DepartmentName (d.DepartmentID = 1).

```sql
-- Answer 3: d.DepartmentName Filter
SELECT e.FirstName, e.LastName, Title, d.DepartmentID
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID = 1;
```

#### Question 4: Name Pattern Filter
**Task:** Find all employees whose first name starts with 'J'.

```sql
-- Answer 4: Name Pattern Filter
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.FirstName LIKE 'J%';
```

#### Question 5: Middle Name Filter
**Task:** Find all employees with a middle name.

```sql
-- Answer 5: Middle Name Filter
SELECT e.FirstName, MiddleName, e.LastName
FROM Employees e
WHERE MiddleName IS NOT NULL;
```

#### Question 6: Range Filter
**Task:** Find all active employees with BaseSalary between $50,000 and $80,000.

```sql
-- Answer 6: Range Filter
SELECT e.FirstName, e.LastName, e.BaseSalary, IsActive
FROM Employees e
WHERE IsActive = 1 
  AND e.BaseSalary BETWEEN 50000 AND 80000;
```

### Exercise 1.3: Advanced Filtering - Answers

#### Question 1: WorkEmail Pattern Filter
**Task:** Find employees whose email contains 'gmail' or 'company'.

```sql
-- Answer 1: WorkEmail Pattern Filter
SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
WHERE WorkEmail LIKE '%gmail%' 
   OR WorkEmail LIKE '%company%';
```

#### Question 2: Year Range Filter
**Task:** Find employees hired in 2021 or 2022.

```sql
-- Answer 2: Year Range Filter
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
WHERE YEAR(e.HireDate) IN (2021, 2022);
-- Alternative solution:
-- WHERE e.HireDate >= '2021-01-01' AND e.HireDate < '2023-01-01';
```

#### Question 3: Complex Logic Filter
**Task:** Find employees with BaseSalary > $60,000 AND (in IT OR Marketing departments).

```sql
-- Answer 3: Complex Logic Filter
SELECT e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID
FROM Employees e
WHERE e.BaseSalary > 60000 
  AND (d.DepartmentID = 1 OR d.DepartmentID = 4);
```

#### Question 4: Name Suffix Filter
**Task:** Find employees whose last name ends with 'son' or 'er'.

```sql
-- Answer 4: Name Suffix Filter
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.LastName LIKE '%son' 
   OR e.LastName LIKE '%er';
```

## Section 2: Set Operations (Lesson 2) - Answers

### Exercise 2.1: Basic Set Operations - Answers

#### Question 1: UNION Operation
**Task:** Get a list of all first names using UNION.

```sql
-- Answer 1: UNION Operation
SELECT e.FirstName FROM Employees e WHERE d.DepartmentID <= 2
UNION
SELECT e.FirstName FROM Employees e WHERE d.DepartmentID >= 3;
```

#### Question 2: INTERSECT Operation
**Task:** Find d.DepartmentName IDs that have both high-BaseSalary and low-BaseSalary employees.

```sql
-- Answer 2: INTERSECT Operation
SELECT d.DepartmentID FROM Employees e WHERE e.BaseSalary > 70000
INTERSECT
SELECT d.DepartmentID FROM Employees e WHERE e.BaseSalary < 60000;
```

#### Question 3: EXCEPT Operation
**Task:** Find employees who are not assigned to any projects.

```sql
-- Answer 3: EXCEPT Operation
SELECT e.EmployeeID FROM Employees e
EXCEPT
SELECT e.EmployeeID FROM EmployeeProjects;
```

### Exercise 2.2: Set Membership - Answers

#### Question 1: IN Operator
**Task:** Find employees whose d.DepartmentName ID is in the list (1, 3, 5).

```sql
-- Answer 1: IN Operator
SELECT e.FirstName, e.LastName, d.DepartmentID
FROM Employees e
WHERE d.DepartmentID IN (1, 3, 5);
```

#### Question 2: Project IsActive Filter
**Task:** Find employees who work on projects with status 'In Progress'.

```sql
-- Answer 2: Project IsActive Filter
SELECT DISTINCT e.FirstName, e.LastName
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.IsActive = 'In Progress';
```

#### Question 3: EXISTS Operation
**Task:** Find departments that have employees.

```sql
-- Answer 3: EXISTS Operation
SELECT d.DepartmentName
FROM Departments d
WHERE EXISTS (
    SELECT 1 FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE d.DepartmentID = d.DepartmentID
);
```

#### Question 4: Manager Filter
**Task:** Find employees who are not managers.

```sql
-- Answer 4: Manager Filter
SELECT e.FirstName, e.LastName
FROM Employees e e1
WHERE e1.EmployeeID NOT IN (
    SELECT DISTINCT ManagerID 
    FROM Employees e e2 
    WHERE ManagerID IS NOT NULL
);
```

### Exercise 2.3: Advanced Set Operations - Answers

#### Question 1: ALL Projects
**Task:** Find employees who work on ALL active projects.

```sql
-- Answer 1: ALL Projects
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE NOT EXISTS (
    SELECT p.ProjectID
    FROM Projects p
    WHERE p.IsActive = 'In Progress'
    AND p.ProjectID NOT IN (
        SELECT ep.ProjectID
        FROM EmployeeProjects ep
        WHERE ep.EmployeeID = e.EmployeeID
    )
);
```

#### Question 2: Same Projects as Employee 2
**Task:** Find employees who work on the same projects as employee with ID 2.

```sql
-- Answer 2: Same Projects as Employee 2
SELECT DISTINCT e.FirstName, e.LastName
FROM Employees e
INNER JOIN EmployeeProjects ep1 ON e.EmployeeID = ep1.EmployeeID
WHERE ep1.ProjectID IN (
    SELECT ep2.ProjectID
    FROM EmployeeProjects ep2
    WHERE ep2.EmployeeID = 2
)
AND e.EmployeeID != 2;
```

#### Question 3: High-BaseSalary Departments
**Task:** Find departments where ALL employees earn more than $55,000.

```sql
-- Answer 3: High-e.BaseSalary Departments
SELECT d.DepartmentName
FROM Departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
    WHERE d.DepartmentID = d.DepartmentID
    AND e.BaseSalary <= 55000
)
AND EXISTS (
    SELECT 1
    FROM Employees e
    WHERE d.DepartmentID = d.DepartmentID
);
```

## Section 3: Predicate Logic (Lesson 3) - Answers

### Exercise 3.1: NULL Handling - Answers

#### Question 1: No Middle Name
**Task:** Find employees with no middle name.

```sql
-- Answer 1: No Middle Name
SELECT e.FirstName, e.LastName, MiddleName
FROM Employees e
WHERE MiddleName IS NULL;
```

#### Question 2: NULL or Empty Middle Name
**Task:** Find employees where middle name is either NULL or empty string.

```sql
-- Answer 2: NULL or Empty Middle Name
SELECT e.FirstName, e.LastName, MiddleName
FROM Employees e
WHERE MiddleName IS NULL OR MiddleName = '';
```

#### Question 3: Full Names with NULL Handling
**Task:** Create a report showing full names, handling NULL middle names gracefully.

```sql
-- Answer 3: Full Names with NULL Handling
SELECT 
    e.FirstName,
    MiddleName,
    e.LastName,
    CASE 
        WHEN MiddleName IS NULL THEN e.FirstName + ' ' + e.LastName
        ELSE e.FirstName + ' ' + MiddleName + ' ' + e.LastName
    END AS FullName,
    -- Alternative using ISNULL:
    e.FirstName + ' ' + ISNULL(MiddleName + ' ', '') + e.LastName AS FullNameAlt
FROM Employees e;
```

#### Question 4: Top-Level Managers
**Task:** Find employees whose manager ID is NULL (top-level managers).

```sql
-- Answer 4: Top-Level Managers
SELECT e.FirstName, e.LastName, Title, ManagerID
FROM Employees e
WHERE ManagerID IS NULL;
```

### Exercise 3.2: Complex Predicates - Answers

#### Question 1: Complex BaseSalary and d.DepartmentName Logic
**Task:** Find employees where (BaseSalary > $70k AND d.DepartmentName is IT) OR (BaseSalary > $80k).

```sql
-- Answer 1: Complex e.BaseSalary and d.DepartmentName Logic
SELECT e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (e.BaseSalary > 70000 AND d.DepartmentID = 1) 
   OR (e.BaseSalary > 80000);
```

#### Question 2: Project IsActive and d.Budget Logic
**Task:** Find projects that are either completed OR have a budget > $100k.

```sql
-- Answer 2: Project IsActive and d.Budget Logic
SELECT ProjectName, IsActive, d.Budget
FROM Projects p
WHERE IsActive = 'Completed' 
   OR d.Budget > 100000;
```

## Section 4: Logical Order of Operations (Lesson 4) - Answers

### Exercise 4.1: Order of Operations Understanding - Answers

#### Question 1: Logical Processing Order
**Task:** Write a query demonstrating the logical order of operations.

```sql
-- Answer 1: Logical Processing Order
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,  -- 5. SELECT
    e.BaseSalary,
    d.DepartmentName,
    CASE 
        WHEN e.BaseSalary > 70000 THEN 'High'
        WHEN e.BaseSalary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees e                                      -- 1. FROM
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                                  -- 2. WHERE
  AND e.HireDate >= '2020-01-01'
GROUP BY e.FirstName, e.LastName, e.BaseSalary, d.DepartmentName  -- 3. GROUP BY
HAVING COUNT(*) > 0                                   -- 4. HAVING
ORDER BY e.BaseSalary DESC;                               -- 6. ORDER BY
```

#### Question 2: Alias Usage Demonstration
**Task:** Show proper and improper alias usage based on logical order.

```sql
-- Answer 2: Alias Usage Demonstration

-- CORRECT: Using alias in ORDER BY (processed after SELECT)
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    e.BaseSalary * 12 AS AnnualSalary
FROM Employees e
ORDER BY FullName, AnnualSalary;

-- INCORRECT: Cannot use alias in WHERE clause (processed before SELECT)
-- This would cause an error:
-- SELECT e.FirstName + ' ' + e.LastName AS FullName
-- FROM Employees e
-- WHERE FullName LIKE 'J%';

-- CORRECT: Use the actual expression in WHERE clause
SELECT e.FirstName + ' ' + e.LastName AS FullName
FROM Employees e
WHERE e.FirstName + ' ' + e.LastName LIKE 'J%'
ORDER BY FullName;
```

### Exercise 4.2: Practical Application - Answers

#### Question 1: Complex Query with All Clauses
**Task:** Write a comprehensive query using all major clauses.

```sql
-- Answer 1: Complex Query with All Clauses
SELECT d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MIN(e.HireDate) AS EarliestHireDate,
    MAX(e.HireDate) AS LatestHireDate
FROM Employees e                                      -- 1. FROM
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                                  -- 2. WHERE
  AND e.BaseSalary > 40000
GROUP BY d.DepartmentName                             -- 3. GROUP BY
HAVING COUNT(e.EmployeeID) >= 2                       -- 4. HAVING
ORDER BY AverageSalary DESC;                          -- 5. ORDER BY
```

#### Question 2: Subquery Processing Order
**Task:** Demonstrate subquery processing in different clauses.

```sql
-- Answer 2: Subquery Processing Order

-- Subquery in WHERE clause (processed during WHERE phase)
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
WHERE e.BaseSalary > (
    SELECT AVG(e.BaseSalary) 
    FROM Employees e 
    WHERE IsActive = 1
);

-- Subquery in SELECT clause (processed during SELECT phase)
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    (SELECT AVG(e.BaseSalary) FROM Employees e) AS CompanyAverageSalary,
    e.BaseSalary - (SELECT AVG(e.BaseSalary) FROM Employees e) AS SalaryDifference
FROM Employees e
WHERE IsActive = 1;

-- Correlated subquery example
SELECT 
    e1.FirstName,
    e1.LastName,
    e1.BaseSalary,
    (SELECT COUNT(*) 
     FROM Employees e e2 
     WHERE e2.d.DepartmentID = e1.d.DepartmentID 
       AND e2.BaseSalary > e1.BaseSalary) AS HigherPaidInDept
FROM Employees e e1
WHERE e1.IsActive = 1
ORDER BY e1.d.DepartmentID, e1.BaseSalary DESC;
```

## Additional Practice Queries - Answers

### Comprehensive Scenarios

#### Scenario 1: Employee Performance Report
```sql
-- Answer: Employee Performance Report
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.JobTitle,
    e.BaseSalary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    COALESCE(
        (SELECT COUNT(*) 
         FROM EmployeeProjects ep 
         WHERE ep.EmployeeID = e.EmployeeID), 0
    ) AS ProjectCount,
    CASE 
        WHEN e.BaseSalary > 80000 THEN 'Senior Level'
        WHEN e.BaseSalary > 60000 THEN 'Mid Level'
        ELSE 'Junior Level'
    END AS SalaryLevel
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

#### Scenario 2: Project Resource Allocation
```sql
-- Answer: Project Resource Allocation
SELECT 
    p.ProjectName,
    p.IsActive,
    p.d.Budget,
    COUNT(ep.EmployeeID) AS AssignedEmployees,
    SUM(ep.HoursAllocated) AS TotalHoursAllocated,
    SUM(ep.HoursWorked) AS TotalHoursWorked,
    CASE 
        WHEN SUM(ep.HoursWorked) = 0 THEN 0
        ELSE (SUM(ep.HoursWorked) * 100.0) / SUM(ep.HoursAllocated)
    END AS CompletionPercentage
FROM Projects p
LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
GROUP BY p.ProjectID, p.ProjectName, p.IsActive, p.d.Budget
HAVING COUNT(ep.EmployeeID) > 0
ORDER BY CompletionPercentage DESC;
```

#### Scenario 3: d.DepartmentName d.Budget Analysis
```sql
-- Answer: d.DepartmentName d.Budget Analysis
SELECT d.DepartmentName,
    d.Budget AS DepartmentBudget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    SUM(e.BaseSalary) AS TotalBaseSalaries,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    d.Budget - SUM(e.BaseSalary) AS BudgetRemaining,
    CASE 
        WHEN SUM(e.BaseSalary) > d.Budget THEN 'Over d.Budget'
        WHEN SUM(e.BaseSalary) > d.Budget * 0.9 THEN 'Near d.Budget Limit'
        ELSE 'Within d.Budget'
    END AS BudgetIsActive
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = d.DepartmentID 
    AND e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName, d.Budget
ORDER BY BudgetRemaining ASC;
```

## Key Learning Points Summary

### T-SQL Fundamentals
1. **Basic SELECT Structure**: SELECT, FROM, WHERE, ORDER BY
2. **Data Types**: Understanding implicit conversions and explicit casting
3. **String Functions**: SUBSTRING, CHARINDEX, LEFT, RIGHT, LEN, UPPER, LOWER
4. **Date Functions**: GETDATE, DATEDIFF, YEAR, MONTH, DAY

### Set Theory in SQL
1. **Set Operations**: UNION, INTERSECT, EXCEPT
2. **Set Membership**: IN, EXISTS, NOT IN, NOT EXISTS
3. **Quantified Comparisons**: ALL, ANY, SOME

### Predicate Logic
1. **Three-Valued Logic**: TRUE, FALSE, UNKNOWN (NULL)
2. **NULL Handling**: IS NULL, IS NOT NULL, ISNULL, COALESCE
3. **Complex Conditions**: AND, OR, NOT with proper parentheses

### Logical Order of Operations
1. **Processing Order**: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
2. **Alias Usage**: Can use aliases in ORDER BY, cannot use in WHERE/GROUP BY/HAVING
3. **Subquery Processing**: Understanding when and how subqueries are evaluated

### Best Practices Applied
1. **Readable Code**: Proper formatting, meaningful aliases
2. **Performance Considerations**: Avoiding functions in WHERE clauses when possible
3. **NULL Safety**: Always consider NULL values in comparisons
4. **Logical Consistency**: Use parentheses to clarify complex conditions