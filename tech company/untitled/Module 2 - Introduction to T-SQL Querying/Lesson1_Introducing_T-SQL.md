# Lesson 1: Introducing T-SQL

## Overview
Transact-SQL (T-SQL) is Microsoft's extension to SQL (Structured Query Language) for use with Microsoft SQL Server and Azure SQL Database. T-SQL expands on the SQL standard to include procedural programming, local variables, various support functions for string processing, date processing, mathematics, etc.

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

#### 1. Basic SELECT Statement
```sql
-- Select all columns from a table
SELECT * FROM Employees e;

-- Select specific columns
SELECT e.FirstName, e.LastName, e.BaseSalary 
FROM Employees e;
```

#### 2. Using WHERE Clause
```sql
-- Filter records with conditions
SELECT e.FirstName, e.LastName 
FROM Employees e 
WHERE e.BaseSalary > 50000;
```

#### 3. Basic Data Types
```sql
-- Common T-SQL data types
DECLARE @Name NVARCHAR(50) = 'John Doe';
DECLARE @Age INT = 30;
DECLARE @e.BaseSalary DECIMAL(10,2) = 75000.00;
DECLARE @e.HireDate DATE = '2020-01-15';
```

### Intermediate Examples

#### 1. Using Functions
```sql
-- String functions
SELECT 
    UPPER(e.FirstName) AS UpperFirstName,
    LEN(e.LastName) AS LastNameLength,
    SUBSTRING(WorkEmail, 1, CHARINDEX('@', WorkEmail) - 1) AS Username
FROM Employees e;

-- Date functions
SELECT 
    GETDATE() AS CurrentDateTime,
    DATEADD(YEAR, 1, e.HireDate) AS OneYearLater,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed
FROM Employees e;
```

#### 2. Conditional Logic
```sql
-- Using CASE statement
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary < 40000 THEN 'Entry Level'
        WHEN e.BaseSalary BETWEEN 40000 AND 80000 THEN 'Mid Level'
        ELSE 'Senior Level'
    END AS SalaryCategory
FROM Employees e;
```

#### 3. Grouping and Aggregation
```sql
-- GROUP BY with aggregate functions
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MAX(e.BaseSalary) AS MaxSalary,
    MIN(e.BaseSalary) AS MinSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY DepartmentID
HAVING COUNT(*) > 5;
```

### Advanced Examples

#### 1. Common Table Expressions (CTEs)
```sql
-- CTE for complex queries
WITH EmployeeSalaryRanking AS (
    SELECT 
        e.FirstName,
        e.LastName,
        e.BaseSalary,
        RANK() OVER (ORDER BY e.BaseSalary DESC) AS SalaryRank,
        DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY e.BaseSalary DESC) AS DeptSalaryRank
    FROM Employees e
)
SELECT *
FROM Employees e ealaryRanking
WHERE SalaryRank <= 10;
```

#### 2. Window Functions
```sql
-- Advanced window functions
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    LAG(e.BaseSalary) OVER (ORDER BY e.HireDate) AS PreviousEmployeeSalary,
    LEAD(e.BaseSalary) OVER (ORDER BY e.HireDate) AS NextEmployeeSalary,
    SUM(e.BaseSalary) OVER (PARTITION BY DepartmentID) AS DepartmentTotalSalary,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY e.BaseSalary DESC) AS RowNum
FROM Employees e;
```

#### 3. Recursive CTE
```sql
-- Recursive CTE for hierarchical data
WITH EmployeeHierarchy AS (
    -- Anchor member (top-level managers)
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        ManagerID,
        0 AS Level
    FROM Employees e
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
    REPLICATE('  ', Level) + e.FirstName + ' ' + e.LastName AS HierarchyDisplay,
    Level
FROM EmployeeHierarchy
ORDER BY Level, e.LastName;
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
   IF @BaseSalary > 50000
   BEGIN
       PRINT 'High BaseSalary employee';
   END
   ELSE
   BEGIN
       PRINT 'Standard BaseSalary employee';
   END
   ```

3. **Built-in Functions**
   ```sql
   -- T-SQL specific functions
   SELECT 
       ISNULL(MiddleName, 'No Middle Name') AS MiddleName,
       DATEPART(YEAR, HireDate) AS HireYear,
       PATINDEX('%@gmail.com', WorkEmail) AS GmailPosition;
   ```

## Best Practices

1. **Use Meaningful Names**
   ```sql
   -- Good
   SELECT emp.FirstName, emp.LastName
   FROM Employees e emp;
   
   -- Avoid
   SELECT e.fn, e.ln
   FROM Employees e;
   ```

2. **Always Use Schema Names**
   ```sql
   -- Good
   SELECT * FROM dbo.Employees;
   
   -- Avoid
   SELECT * FROM Employees e;
   ```

3. **Use Proper Formatting**
   ```sql
   -- Well formatted
   SELECT 
       emp.FirstName,
       emp.LastName,
       dept.d.DepartmentName
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
   FROM Employees e;
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
