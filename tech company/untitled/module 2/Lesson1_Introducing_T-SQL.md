# Lesson 1: Introducing T-SQL - TechCorp Solutions Database Queries

## Overview
Transact-SQL (T-SQL) is Microsoft's extension to SQL (Structured Query Language) that we'll use to query TechCorp Solutions' business data. As a technology consulting company, TechCorp relies on SQL Server to manage employee information, project data, client relationships, and business operations. T-SQL expands on the SQL standard to include procedural programming, local variables, and various support functions that help TechCorp analyze their business performance.

## 🏢 TechCorp Business Context
**TechCorp Solutions** uses SQL Server to manage:
- **Employee Management**: 145 employees across Engineering, Sales, Marketing, HR, and Finance departments
- **Project Tracking**: Custom software development, cloud migration, and cybersecurity projects
- **Client Relationships**: From small startups to large enterprise clients
- **Financial Operations**: Project budgets, employee salaries, and revenue tracking
- **Performance Analytics**: Employee performance metrics and project profitability

## What is T-SQL?

T-SQL stands for Transact-SQL and is Microsoft's proprietary extension of the SQL standard. It includes all the functionality of standard SQL plus additional features that make it a powerful tool for database management and development.

### Key Features of T-SQL:
- **Data Definition Language (DDL)**: CREATE, ALTER, DROP statements
- **Data Manipulation Language (DML)**: SELECT, INSERT, UPDATE, DELETE statements
- **Data Control Language (DCL)**: GRANT, REVOKE statements
- **Procedural Programming**: Variables, control flow, functions, procedures
- **Built-in Functions**: String, date, mathematical, and conversion functions

## Basic T-SQL Syntax

### Simple Examples

#### 1. Basic SELECT Statement - TechCorp Employee Data
```sql
-- Select all TechCorp employee information
SELECT * FROM Employees;

-- Select specific information about TechCorp team members
SELECT FirstName, LastName, JobTitle, BaseSalary 
FROM Employees;

-- View TechCorp department structure
SELECT DepartmentName, Budget, Location 
FROM Departments;
```

#### 2. Using WHERE Clause - TechCorp Business Filtering
```sql
-- Find TechCorp senior-level employees
SELECT FirstName, LastName, JobTitle
FROM Employees 
WHERE BaseSalary > 80000;

-- Find TechCorp projects with high budgets
SELECT ProjectName, Budget, Status
FROM Projects
WHERE Budget > 500000;

-- Find TechCorp employees in Engineering department
SELECT FirstName, LastName, JobTitle
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Engineering';
```

#### 3. TechCorp Business Data Types
```sql
-- Common T-SQL data types used in TechCorp's database
DECLARE @EmployeeName NVARCHAR(100) = 'Sarah Chen';
DECLARE @EmployeeID INT = 4051;
DECLARE @BaseSalary DECIMAL(10,2) = 95000.00;
DECLARE @HireDate DATE = '2021-03-15';
DECLARE @IsActive BIT = 1;
DECLARE @ProjectBudget MONEY = 750000;
DECLARE @LastReviewDate DATETIME2(3) = '2024-12-01 09:30:00.000';

-- TechCorp business examples
DECLARE @ClientCompany NVARCHAR(200) = 'GlobalTech Industries';
DECLARE @ProjectStatus NVARCHAR(50) = 'In Progress';
DECLARE @CompletionPercentage DECIMAL(5,2) = 67.50;
```

### Intermediate Examples

#### 1. Using Functions
```sql
-- String functions
SELECT 
    UPPER(FirstName) AS UpperFirstName,
    LEN(LastName) AS LastNameLength,
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS Username
FROM Employees;

-- Date functions
SELECT 
    GETDATE() AS CurrentDateTime,
    DATEADD(YEAR, 1, HireDate) AS OneYearLater,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed
FROM Employees;
```

#### 2. Conditional Logic
```sql
-- Using CASE statement
SELECT 
    FirstName,
    LastName,
    Salary,
    CASE 
        WHEN Salary < 40000 THEN 'Entry Level'
        WHEN Salary BETWEEN 40000 AND 80000 THEN 'Mid Level'
        ELSE 'Senior Level'
    END AS SalaryCategory
FROM Employees;
```

#### 3. Grouping and Aggregation
```sql
-- GROUP BY with aggregate functions
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AverageSalary,
    MAX(Salary) AS MaxSalary,
    MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 5;
```

### Advanced Examples

#### 1. Common Table Expressions (CTEs)
```sql
-- CTE for complex queries
WITH EmployeeSalaryRanking AS (
    SELECT 
        FirstName,
        LastName,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank
    FROM Employees
)
SELECT *
FROM EmployeeSalaryRanking
WHERE SalaryRank <= 10;
```

#### 2. Window Functions
```sql
-- Advanced window functions
SELECT 
    FirstName,
    LastName,
    Salary,
    LAG(Salary) OVER (ORDER BY HireDate) AS PreviousEmployeeSalary,
    LEAD(Salary) OVER (ORDER BY HireDate) AS NextEmployeeSalary,
    SUM(Salary) OVER (PARTITION BY Department) AS DepartmentTotalSalary,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RowNum
FROM Employees;
```

#### 3. Recursive CTE
```sql
-- Recursive CTE for hierarchical data
WITH EmployeeHierarchy AS (
    -- Anchor member (top-level managers)
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        ManagerID,
        0 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive member
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT 
    REPLICATE('  ', Level) + FirstName + ' ' + LastName AS HierarchyDisplay,
    Level
FROM EmployeeHierarchy
ORDER BY Level, LastName;
```

## T-SQL vs Standard SQL

### Differences and Extensions:

1. **Variable Declaration**
   ```sql
   -- T-SQL specific
   DECLARE @Variable INT = 10;
   
   -- Standard SQL (not supported in all databases)
   DECLARE Variable INTEGER DEFAULT 10;
   ```

2. **Control Flow Statements**
   ```sql
   -- T-SQL IF...ELSE
   IF @Salary > 50000
   BEGIN
       PRINT 'High salary employee';
   END
   ELSE
   BEGIN
       PRINT 'Standard salary employee';
   END
   ```

3. **Built-in Functions**
   ```sql
   -- T-SQL specific functions
   SELECT 
       ISNULL(MiddleName, 'No Middle Name') AS MiddleName,
       DATEPART(YEAR, HireDate) AS HireYear,
       PATINDEX('%@gmail.com', Email) AS GmailPosition;
   ```

## Best Practices

1. **Use Meaningful Names**
   ```sql
   -- Good
   SELECT emp.FirstName, emp.LastName
   FROM Employees emp;
   
   -- Avoid
   SELECT e.fn, e.ln
   FROM Employees e;
   ```

2. **Always Use Schema Names**
   ```sql
   -- Good
   SELECT * FROM dbo.Employees;
   
   -- Avoid
   SELECT * FROM Employees;
   ```

3. **Use Proper Formatting**
   ```sql
   -- Well formatted
   SELECT 
       emp.FirstName,
       emp.LastName,
       dept.DepartmentName
   FROM dbo.Employees emp
   INNER JOIN dbo.Departments dept 
       ON emp.DepartmentID = dept.DepartmentID
   WHERE emp.IsActive = 1
   ORDER BY emp.LastName;
   ```

4. **Handle NULL Values**
   ```sql
   -- Use ISNULL or COALESCE
   SELECT 
       FirstName,
       ISNULL(MiddleName, '') AS MiddleName,
       LastName
   FROM Employees;
   ```

## Common T-SQL Statements Overview

| Category | Statements | Purpose |
|----------|------------|---------|
| **DQL** | SELECT | Query data |
| **DML** | INSERT, UPDATE, DELETE | Modify data |
| **DDL** | CREATE, ALTER, DROP | Define structure |
| **DCL** | GRANT, REVOKE | Control access |
| **TCL** | COMMIT, ROLLBACK | Control transactions |

## Summary

T-SQL is a powerful extension of SQL that provides:
- Enhanced querying capabilities
- Procedural programming features
- Rich built-in function library
- Advanced analytics functions
- Strong integration with SQL Server ecosystem

Understanding T-SQL fundamentals is essential for working effectively with SQL Server databases and building robust data solutions.
