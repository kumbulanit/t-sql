# Lab Answers: Introduction to T-SQL Querying

## Section 1: Basic T-SQL Queries (Lesson 1) - Answers

### Exercise 1.1: Simple SELECT Statements - Answers

#### Question 1: Basic Selection
**Task:** Select all columns from the Employees table.

```sql
-- Answer 1: Basic Selection
SELECT * FROM Employees;
```

#### Question 2: Column Selection
**Task:** Select only FirstName, LastName, and Salary from Employees.

```sql
-- Answer 2: Column Selection
SELECT FirstName, LastName, Salary 
FROM Employees;
```

#### Question 3: Calculated Columns
**Task:** Create a query that shows full name, annual salary, and monthly salary.

```sql
-- Answer 3: Calculated Columns
SELECT 
    FirstName + ' ' + LastName AS FullName,
    Salary AS AnnualSalary,
    Salary / 12 AS MonthlySalary
FROM Employees;
```

#### Question 4: String Functions
**Task:** Create a query showing email username, domain, and full name in uppercase.

```sql
-- Answer 4: String Functions
SELECT 
    FirstName + ' ' + LastName AS FullName,
    LEFT(Email, CHARINDEX('@', Email) - 1) AS EmailUsername,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain,
    UPPER(FirstName + ' ' + LastName) AS FullNameUpper
FROM Employees;
```

#### Question 5: Date Functions
**Task:** Create a query showing employee name, hire date, years of service, and hire year.

```sql
-- Answer 5: Date Functions
SELECT 
    FirstName + ' ' + LastName AS EmployeeName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    YEAR(HireDate) AS HireYear
FROM Employees;
```

### Exercise 1.2: Filtering Data - Answers

#### Question 1: Salary Filter
**Task:** Find all employees with salary greater than $70,000.

```sql
-- Answer 1: Salary Filter
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 70000;
```

#### Question 2: Hire Date Filter
**Task:** Find all employees hired after January 1, 2021.

```sql
-- Answer 2: Hire Date Filter
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE HireDate > '2021-01-01';
```

#### Question 3: Department Filter
**Task:** Find all employees in the IT department (DepartmentID = 1).

```sql
-- Answer 3: Department Filter
SELECT FirstName, LastName, Title, DepartmentID
FROM Employees
WHERE DepartmentID = 1;
```

#### Question 4: Name Pattern Filter
**Task:** Find all employees whose first name starts with 'J'.

```sql
-- Answer 4: Name Pattern Filter
SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'J%';
```

#### Question 5: Middle Name Filter
**Task:** Find all employees with a middle name.

```sql
-- Answer 5: Middle Name Filter
SELECT FirstName, MiddleName, LastName
FROM Employees
WHERE MiddleName IS NOT NULL;
```

#### Question 6: Range Filter
**Task:** Find all active employees with salary between $50,000 and $80,000.

```sql
-- Answer 6: Range Filter
SELECT FirstName, LastName, Salary, IsActive
FROM Employees
WHERE IsActive = 1 
  AND Salary BETWEEN 50000 AND 80000;
```

### Exercise 1.3: Advanced Filtering - Answers

#### Question 1: Email Pattern Filter
**Task:** Find employees whose email contains 'gmail' or 'company'.

```sql
-- Answer 1: Email Pattern Filter
SELECT FirstName, LastName, Email
FROM Employees
WHERE Email LIKE '%gmail%' 
   OR Email LIKE '%company%';
```

#### Question 2: Year Range Filter
**Task:** Find employees hired in 2021 or 2022.

```sql
-- Answer 2: Year Range Filter
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE YEAR(HireDate) IN (2021, 2022);
-- Alternative solution:
-- WHERE HireDate >= '2021-01-01' AND HireDate < '2023-01-01';
```

#### Question 3: Complex Logic Filter
**Task:** Find employees with salary > $60,000 AND (in IT OR Marketing departments).

```sql
-- Answer 3: Complex Logic Filter
SELECT FirstName, LastName, Salary, DepartmentID
FROM Employees
WHERE Salary > 60000 
  AND (DepartmentID = 1 OR DepartmentID = 4);
```

#### Question 4: Name Suffix Filter
**Task:** Find employees whose last name ends with 'son' or 'er'.

```sql
-- Answer 4: Name Suffix Filter
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%son' 
   OR LastName LIKE '%er';
```

## Section 2: Set Operations (Lesson 2) - Answers

### Exercise 2.1: Basic Set Operations - Answers

#### Question 1: UNION Operation
**Task:** Get a list of all first names using UNION.

```sql
-- Answer 1: UNION Operation
SELECT FirstName FROM Employees WHERE DepartmentID <= 2
UNION
SELECT FirstName FROM Employees WHERE DepartmentID >= 3;
```

#### Question 2: INTERSECT Operation
**Task:** Find department IDs that have both high-salary and low-salary employees.

```sql
-- Answer 2: INTERSECT Operation
SELECT DepartmentID FROM Employees WHERE Salary > 70000
INTERSECT
SELECT DepartmentID FROM Employees WHERE Salary < 60000;
```

#### Question 3: EXCEPT Operation
**Task:** Find employees who are not assigned to any projects.

```sql
-- Answer 3: EXCEPT Operation
SELECT EmployeeID FROM Employees
EXCEPT
SELECT EmployeeID FROM EmployeeProjects;
```

### Exercise 2.2: Set Membership - Answers

#### Question 1: IN Operator
**Task:** Find employees whose department ID is in the list (1, 3, 5).

```sql
-- Answer 1: IN Operator
SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID IN (1, 3, 5);
```

#### Question 2: Project Status Filter
**Task:** Find employees who work on projects with status 'In Progress'.

```sql
-- Answer 2: Project Status Filter
SELECT DISTINCT e.FirstName, e.LastName
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.Status = 'In Progress';
```

#### Question 3: EXISTS Operation
**Task:** Find departments that have employees.

```sql
-- Answer 3: EXISTS Operation
SELECT DepartmentName
FROM Departments d
WHERE EXISTS (
    SELECT 1 FROM Employees e 
    WHERE e.DepartmentID = d.DepartmentID
);
```

#### Question 4: Manager Filter
**Task:** Find employees who are not managers.

```sql
-- Answer 4: Manager Filter
SELECT FirstName, LastName
FROM Employees e1
WHERE e1.EmployeeID NOT IN (
    SELECT DISTINCT ManagerID 
    FROM Employees e2 
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
    WHERE p.Status = 'In Progress'
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

#### Question 3: High-Salary Departments
**Task:** Find departments where ALL employees earn more than $55,000.

```sql
-- Answer 3: High-Salary Departments
SELECT d.DepartmentName
FROM Departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID
    AND e.Salary <= 55000
)
AND EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID
);
```

## Section 3: Predicate Logic (Lesson 3) - Answers

### Exercise 3.1: NULL Handling - Answers

#### Question 1: No Middle Name
**Task:** Find employees with no middle name.

```sql
-- Answer 1: No Middle Name
SELECT FirstName, LastName, MiddleName
FROM Employees
WHERE MiddleName IS NULL;
```

#### Question 2: NULL or Empty Middle Name
**Task:** Find employees where middle name is either NULL or empty string.

```sql
-- Answer 2: NULL or Empty Middle Name
SELECT FirstName, LastName, MiddleName
FROM Employees
WHERE MiddleName IS NULL OR MiddleName = '';
```

#### Question 3: Full Names with NULL Handling
**Task:** Create a report showing full names, handling NULL middle names gracefully.

```sql
-- Answer 3: Full Names with NULL Handling
SELECT 
    FirstName,
    MiddleName,
    LastName,
    CASE 
        WHEN MiddleName IS NULL THEN FirstName + ' ' + LastName
        ELSE FirstName + ' ' + MiddleName + ' ' + LastName
    END AS FullName,
    -- Alternative using ISNULL:
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullNameAlt
FROM Employees;
```

#### Question 4: Top-Level Managers
**Task:** Find employees whose manager ID is NULL (top-level managers).

```sql
-- Answer 4: Top-Level Managers
SELECT FirstName, LastName, Title, ManagerID
FROM Employees
WHERE ManagerID IS NULL;
```

### Exercise 3.2: Complex Predicates - Answers

#### Question 1: Complex Salary and Department Logic
**Task:** Find employees where (salary > $70k AND department is IT) OR (salary > $80k).

```sql
-- Answer 1: Complex Salary and Department Logic
SELECT FirstName, LastName, Salary, DepartmentID
FROM Employees
WHERE (Salary > 70000 AND DepartmentID = 1) 
   OR (Salary > 80000);
```

#### Question 2: Project Status and Budget Logic
**Task:** Find projects that are either completed OR have a budget > $100k.

```sql
-- Answer 2: Project Status and Budget Logic
SELECT ProjectName, Status, Budget
FROM Projects
WHERE Status = 'Completed' 
   OR Budget > 100000;
```

## Section 4: Logical Order of Operations (Lesson 4) - Answers

### Exercise 4.1: Order of Operations Understanding - Answers

#### Question 1: Logical Processing Order
**Task:** Write a query demonstrating the logical order of operations.

```sql
-- Answer 1: Logical Processing Order
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,  -- 5. SELECT
    e.Salary,
    d.DepartmentName,
    CASE 
        WHEN e.Salary > 70000 THEN 'High'
        WHEN e.Salary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees e                                      -- 1. FROM
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                                  -- 2. WHERE
  AND e.HireDate >= '2020-01-01'
GROUP BY e.FirstName, e.LastName, e.Salary, d.DepartmentName  -- 3. GROUP BY
HAVING COUNT(*) > 0                                   -- 4. HAVING
ORDER BY e.Salary DESC;                               -- 6. ORDER BY
```

#### Question 2: Alias Usage Demonstration
**Task:** Show proper and improper alias usage based on logical order.

```sql
-- Answer 2: Alias Usage Demonstration

-- CORRECT: Using alias in ORDER BY (processed after SELECT)
SELECT 
    FirstName + ' ' + LastName AS FullName,
    Salary * 12 AS AnnualSalary
FROM Employees
ORDER BY FullName, AnnualSalary;

-- INCORRECT: Cannot use alias in WHERE clause (processed before SELECT)
-- This would cause an error:
-- SELECT FirstName + ' ' + LastName AS FullName
-- FROM Employees
-- WHERE FullName LIKE 'J%';

-- CORRECT: Use the actual expression in WHERE clause
SELECT FirstName + ' ' + LastName AS FullName
FROM Employees
WHERE FirstName + ' ' + LastName LIKE 'J%'
ORDER BY FullName;
```

### Exercise 4.2: Practical Application - Answers

#### Question 1: Complex Query with All Clauses
**Task:** Write a comprehensive query using all major clauses.

```sql
-- Answer 1: Complex Query with All Clauses
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.Salary) AS AverageSalary,
    MIN(e.HireDate) AS EarliestHireDate,
    MAX(e.HireDate) AS LatestHireDate
FROM Employees e                                      -- 1. FROM
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                                  -- 2. WHERE
  AND e.Salary > 40000
GROUP BY d.DepartmentName                             -- 3. GROUP BY
HAVING COUNT(e.EmployeeID) >= 2                       -- 4. HAVING
ORDER BY AverageSalary DESC;                          -- 5. ORDER BY
```

#### Question 2: Subquery Processing Order
**Task:** Demonstrate subquery processing in different clauses.

```sql
-- Answer 2: Subquery Processing Order

-- Subquery in WHERE clause (processed during WHERE phase)
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary) 
    FROM Employees 
    WHERE IsActive = 1
);

-- Subquery in SELECT clause (processed during SELECT phase)
SELECT 
    FirstName,
    LastName,
    Salary,
    (SELECT AVG(Salary) FROM Employees) AS CompanyAverageSalary,
    Salary - (SELECT AVG(Salary) FROM Employees) AS SalaryDifference
FROM Employees
WHERE IsActive = 1;

-- Correlated subquery example
SELECT 
    e1.FirstName,
    e1.LastName,
    e1.Salary,
    (SELECT COUNT(*) 
     FROM Employees e2 
     WHERE e2.DepartmentID = e1.DepartmentID 
       AND e2.Salary > e1.Salary) AS HigherPaidInDept
FROM Employees e1
WHERE e1.IsActive = 1
ORDER BY e1.DepartmentID, e1.Salary DESC;
```

## Additional Practice Queries - Answers

### Comprehensive Scenarios

#### Scenario 1: Employee Performance Report
```sql
-- Answer: Employee Performance Report
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.Title,
    e.Salary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    COALESCE(
        (SELECT COUNT(*) 
         FROM EmployeeProjects ep 
         WHERE ep.EmployeeID = e.EmployeeID), 0
    ) AS ProjectCount,
    CASE 
        WHEN e.Salary > 80000 THEN 'Senior Level'
        WHEN e.Salary > 60000 THEN 'Mid Level'
        ELSE 'Junior Level'
    END AS SalaryLevel
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.Salary DESC;
```

#### Scenario 2: Project Resource Allocation
```sql
-- Answer: Project Resource Allocation
SELECT 
    p.ProjectName,
    p.Status,
    p.Budget,
    COUNT(ep.EmployeeID) AS AssignedEmployees,
    SUM(ep.HoursAllocated) AS TotalHoursAllocated,
    SUM(ep.HoursWorked) AS TotalHoursWorked,
    CASE 
        WHEN SUM(ep.HoursWorked) = 0 THEN 0
        ELSE (SUM(ep.HoursWorked) * 100.0) / SUM(ep.HoursAllocated)
    END AS CompletionPercentage
FROM Projects p
LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
GROUP BY p.ProjectID, p.ProjectName, p.Status, p.Budget
HAVING COUNT(ep.EmployeeID) > 0
ORDER BY CompletionPercentage DESC;
```

#### Scenario 3: Department Budget Analysis
```sql
-- Answer: Department Budget Analysis
SELECT 
    d.DepartmentName,
    d.Budget AS DepartmentBudget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    SUM(e.Salary) AS TotalSalaries,
    AVG(e.Salary) AS AverageSalary,
    d.Budget - SUM(e.Salary) AS BudgetRemaining,
    CASE 
        WHEN SUM(e.Salary) > d.Budget THEN 'Over Budget'
        WHEN SUM(e.Salary) > d.Budget * 0.9 THEN 'Near Budget Limit'
        ELSE 'Within Budget'
    END AS BudgetStatus
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID 
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