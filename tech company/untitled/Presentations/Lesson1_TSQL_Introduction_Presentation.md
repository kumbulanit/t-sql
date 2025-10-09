# Lesson 1: Introducing T-SQL - Individual Presentation

## Slide 1: T-SQL Introduction Overview
**Mastering Transact-SQL Fundamentals**

- Understanding T-SQL as Microsoft's SQL implementation
- Language components and structure overview
- Relationship to ANSI SQL standards
- T-SQL extensions and enhancements
- Development environment and tools
- TechCorp Solutions database context

---

## Slide 2: Learning Objectives
**What You Will Master**

**Primary Goals**:
- Understand T-SQL language architecture
- Learn fundamental syntax and conventions
- Master basic statement types and structure
- Develop T-SQL coding best practices
- Apply T-SQL in business scenarios
- Prepare for advanced query development

**Skills Development**:
- Database query language proficiency
- Logical thinking for data manipulation
- Code readability and maintainability
- Problem-solving with SQL

---

## Slide 3: What is T-SQL?
**Transact-SQL Language Definition**

**T-SQL Characteristics**:
- Microsoft's extension of SQL (Structured Query Language)
- Procedural language capabilities
- Built-in functions and data types
- Control flow statements
- Error handling mechanisms
- System stored procedures

**ANSI SQL Compliance**:
- Core SQL standard adherence
- Microsoft-specific enhancements
- Backward compatibility considerations
- Industry standard alignment

**TechCorp Context**:
- Primary language for database operations
- Business logic implementation
- Data analysis and reporting
- System integration requirements

---

## Slide 4: T-SQL Language Components
**Core Language Elements**

**Data Definition Language (DDL)**:
```sql
-- Create database objects
CREATE TABLE Employees (
    e.EmployeeID INT PRIMARY KEY,
    e.FirstName NVARCHAR(50),
    e.LastName NVARCHAR(50)
);

-- Modify structure
ALTER TABLE Employees ADD WorkEmail NVARCHAR(100);

-- Remove objects
DROP TABLE TempTable;
```

**Data Manipulation Language (DML)**:
```sql
-- Insert data
INSERT INTO Employees VALUES (1, 'John', 'Smith');

-- Update records
UPDATE Employees SET WorkEmail = 'john@techcorp.com' WHERE ID = 1;

-- Delete records
DELETE FROM Employees e WHERE e.EmployeeID = 1;
```

---

## Slide 5: T-SQL Statement Types
**Comprehensive Statement Categories**

**Query Statements**:
- SELECT: Data retrieval
- FROM: Source specification
- WHERE: Condition filtering
- GROUP BY: Data aggregation
- ORDER BY: Result sorting

**Control Flow Statements**:
```sql
-- Conditional logic
IF @Department = 'IT'
    SELECT * FROM ITEmployees;
ELSE
    SELECT * FROM AllEmployees;

-- Looping constructs
WHILE @Counter <= 10
BEGIN
    PRINT 'Processing record ' + CAST(@Counter AS VARCHAR);
    SET @Counter = @Counter + 1;
END;
```

**Transaction Control**:
- BEGIN TRANSACTION
- COMMIT TRANSACTION
- ROLLBACK TRANSACTION

---

## Slide 6: T-SQL Syntax Fundamentals
**Language Rules and Conventions**

**Syntax Rules**:
- Case insensitive (keywords and identifiers)
- Statements terminated with semicolons (recommended)
- Single and double quotes for strings
- Square brackets for identifiers with spaces
- Comments using -- or /* */

**Naming Conventions**:
```sql
-- Valid identifier examples
SELECT 
    e.EmployeeID,
    e.FirstName,
    [Last Name],           -- Brackets for spaces
    Department_Name,       -- Underscore allowed
    "Quoted Identifier"    -- Double quotes allowed
FROM Employees e;
```

**Best Practices**:
- Consistent capitalization (keywords uppercase)
- Meaningful table and column names
- Proper indentation and formatting
- Comprehensive commenting

---

## Slide 7: T-SQL Data Types Overview
**Core Data Type Categories**

**Numeric Types**:
```sql
DECLARE @e.EmployeeID INT = 100;
DECLARE @e.BaseSalary DECIMAL(10,2) = 75000.50;
DECLARE @BonusRate FLOAT = 0.15;
DECLARE @IsActive BIT = 1;
```

**String Types**:
```sql
DECLARE @e.FirstName NVARCHAR(50) = 'John';
DECLARE @Description VARCHAR(MAX) = 'Long text content';
DECLARE @Code CHAR(5) = 'EMP01';
```

**Date/Time Types**:
```sql
DECLARE @e.HireDate DATE = '2023-01-15';
DECLARE @LastLogin DATETIME = GETDATE();
DECLARE @ProcessTime TIME = '14:30:00';
```

**Other Types**:
- UNIQUEIDENTIFIER (GUID)
- XML (structured data)
- VARBINARY (binary data)

---

## Slide 8: Basic SELECT Statement Structure
**Foundation Query Components**

**Simple SELECT Syntax**:
```sql
SELECT column1, column2, column3
FROM table_name
WHERE condition
ORDER BY column1;
```

**TechCorp Example**:
```sql
-- Retrieve employee information
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Information Technology'
ORDER BY e.LastName;
```

**Result Set Concepts**:
- Columns (fields)
- Rows (records)
- NULL values
- Data type consistency

---

## Slide 9: T-SQL Variables and Parameters
**Data Storage and Manipulation**

**Variable Declaration and Usage**:
```sql
-- Variable declaration
DECLARE @EmployeeCount INT;
DECLARE @d.DepartmentName NVARCHAR(50) = 'IT';
DECLARE @AverageSalary MONEY;

-- Variable assignment
SET @EmployeeCount = (SELECT COUNT(*) FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID);
SELECT @AverageSalary = AVG(e.BaseSalary) FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Variable usage
SELECT *
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = @d.DepartmentName
  AND e.BaseSalary > @AverageSalary;
```

**Parameter Usage in Procedures**:
```sql
CREATE PROCEDURE GetEmployeesByDept
    @DeptName NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Employees e WHERE DepartmentID = @DeptID;
END;
```

---

## Slide 10: T-SQL Operators
**Comprehensive Operator Categories**

**Arithmetic Operators**:
```sql
SELECT 
    e.BaseSalary,
    e.BaseSalary * 1.10 AS SalaryWithRaise,      -- Multiplication
    e.BaseSalary + 5000 AS SalaryPlusBonus,      -- Addition
    e.BaseSalary / 12 AS MonthlySalary,          -- Division
    e.BaseSalary % 1000 AS SalaryRemainder       -- Modulo
FROM Employees e;
```

**Comparison Operators**:
```sql
WHERE e.BaseSalary > 50000              -- Greater than
  AND e.HireDate <= '2023-01-01'    -- Less than or equal
  AND d.DepartmentName <> 'HR'          -- Not equal
  AND e.EmployeeID BETWEEN 100 AND 200  -- Range
  AND e.LastName LIKE 'Sm%'         -- Pattern matching
```

**Logical Operators**:
- AND, OR, NOT
- IN, EXISTS
- IS NULL, IS NOT NULL

---

## Slide 11: T-SQL Functions Overview
**Built-in Function Categories**

**String Functions**:
```sql
SELECT 
    UPPER(e.FirstName) AS UpperFirst,
    LEN(e.LastName) AS LastNameLength,
    SUBSTRING(WorkEmail, 1, CHARINDEX('@', WorkEmail) - 1) AS Username,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName
FROM Employees e;
```

**Date Functions**:
```sql
SELECT 
    GETDATE() AS CurrentDateTime,
    YEAR(e.HireDate) AS HireYear,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed,
    DATEADD(YEAR, 1, e.HireDate) AS OneYearAnniversary
FROM Employees e;
```

**Aggregate Functions**:
```sql
SELECT 
    COUNT(*) AS TotalEmployees,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MIN(e.HireDate) AS EarliestHire,
    MAX(e.BaseSalary) AS HighestBaseSalary
FROM Employees e;
```

---

## Slide 12: T-SQL Comments and Documentation
**Code Documentation Best Practices**

**Comment Types**:
```sql
-- Single line comment
/* Multi-line comment
   for detailed explanations
   and documentation */
   
-- TechCorp Employee Query
-- Purpose: Retrieve IT d.DepartmentName employees with high salaries
-- Author: Database Team
-- Date: 2024-01-15
SELECT 
    e.EmployeeID,          -- Unique employee identifier
    e.FirstName,           -- Employee first name
    e.LastName,            -- Employee last name
    e.BaseSalary               -- Annual e.BaseSalary in USD
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Engineering'  -- Filter for IT d.DepartmentName only
  AND e.BaseSalary > 70000;    -- High e.BaseSalary threshold
```

**Documentation Standards**:
- Header comments for complex queries
- Inline comments for business logic
- Version control information
- Change history tracking

---

## Slide 13: T-SQL Error Handling Introduction
**Basic Error Management Concepts**

**TRY-CATCH Structure**:
```sql
BEGIN TRY
    -- Potentially error-prone code
    UPDATE Employees 
    SET e.BaseSalary = e.BaseSalary * 1.10
    WHERE d.DepartmentName = 'Engineering';
    
    PRINT 'e.BaseSalary update completed successfully';
END TRY
BEGIN CATCH
    -- Error handling code
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
END CATCH;
```

**Error Information Functions**:
- ERROR_MESSAGE(): Error description
- ERROR_NUMBER(): Error code
- ERROR_SEVERITY(): Error severity level
- ERROR_STATE(): Error state
- ERROR_PROCEDURE(): Procedure name where error occurred

---

## Slide 14: T-SQL Development Environment
**Tools and Development Practices**

**Primary Development Tools**:
- SQL Server Management Studio (SSMS)
- Azure Data Studio
- Visual Studio Code with SQL extensions
- SQL Server Data Tools (SSDT)

**Development Workflow**:
1. **Planning**: Understand requirements
2. **Design**: Plan query structure
3. **Development**: Write T-SQL code
4. **Testing**: Validate with sample data
5. **Optimization**: Improve performance
6. **Documentation**: Add comments and notes
7. **Deployment**: Move to production

**Code Organization**:
- Consistent formatting
- Modular approach
- Reusable components
- Version control integration

---

## Slide 15: T-SQL Performance Considerations
**Writing Efficient T-SQL Code**

**Performance Best Practices**:
```sql
-- Efficient query structure
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
WHERE e.EmployeeID = 100;  -- Use indexed columns in WHERE

-- Avoid SELECT *
-- Specify only needed columns
SELECT e.FirstName, e.LastName  -- Not SELECT *
FROM Employees e;

-- Use appropriate JOINs instead of subqueries when possible
SELECT e.FirstName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

**Common Performance Issues**:
- Unnecessary columns in SELECT
- Missing WHERE clauses
- Inefficient JOIN conditions
- Lack of proper indexing

---

## Slide 16: T-SQL Standards and Conventions
**Industry Best Practices**

**Coding Standards**:
```sql
-- Use consistent formatting
SELECT 
    emp.EmployeeID,
    emp.FirstName,
    emp.LastName,
    dept.d.DepartmentName
FROM Employees e emp
    INNER JOIN Departments dept 
        ON emp.DepartmentID = dept.DepartmentID
WHERE emp.IsActive = 1
ORDER BY emp.LastName, emp.FirstName;
```

**Naming Conventions**:
- Tables: PascalCase (Employees, Departments)
- Columns: PascalCase (FirstName, LastName)
- Variables: @PascalCase (@EmployeeID)
- Procedures: Verb + Noun (GetEmployeesByDept)

**Code Organization**:
- Logical grouping of statements
- Consistent indentation
- Meaningful aliases
- Clear column ordering

---

## Slide 17: T-SQL in Business Context
**Real-World Application Scenarios**

**TechCorp Use Cases**:

**HR Operations**:
```sql
-- Employee performance reporting
SELECT 
    emp.EmployeeID,
    emp.FirstName + ' ' + emp.LastName AS FullName,
    emp.DepartmentName,
    emp.BaseSalary,
    CASE 
        WHEN emp.BaseSalary > 80000 THEN 'High'
        WHEN emp.BaseSalary > 60000 THEN 'Medium'
        ELSE 'Entry Level'
    END AS SalaryGrade
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID emp
WHERE emp.IsActive = 1;
```

**Financial Analysis**:
```sql
-- d.DepartmentName e.BaseSalary analysis
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    SUM(e.BaseSalary) AS TotalPayroll
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY DepartmentID
ORDER BY TotalPayroll DESC;
```

---

## Slide 18: Common T-SQL Mistakes
**Avoiding Typical Pitfalls**

**Syntax Errors**:
```sql
-- Incorrect (missing FROM)
SELECT e.FirstName, e.LastName;

-- Correct
SELECT e.FirstName, e.LastName FROM Employees e;

-- Incorrect (mixing aggregate and non-aggregate)
SELECT DepartmentID, e.FirstName, COUNT(*)
FROM Employees e GROUP BY DepartmentID;

-- Correct
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees e GROUP BY DepartmentID;
```

**Logic Errors**:
- NULL value handling
- Date comparison issues
- Case sensitivity assumptions
- Division by zero
- Incorrect JOIN conditions

**Prevention Strategies**:
- Code reviews
- Testing with sample data
- Using development databases
- Following coding standards

---

## Slide 19: T-SQL Learning Resources
**Continuing Education and Development**

**Official Microsoft Documentation**:
- T-SQL Reference
- SQL Server Books Online
- Microsoft Learn courses
- SQL Server samples and tutorials

**Practice Platforms**:
- TechCorp development database
- SQL Server sample databases (AdventureWorks, Northwind)
- Online SQL practice sites
- Community forums and blogs

**Advanced Learning Path**:
1. Basic T-SQL mastery
2. Advanced querying techniques
3. Stored procedures and functions
4. Performance tuning
5. Database design principles
6. Business intelligence integration

---

## Slide 20: Learning Objectives Review
**Module 2 Lesson 1 Completion**

✅ **T-SQL Understanding**: Comprehensive language overview
✅ **Syntax Mastery**: Fundamental rules and conventions
✅ **Component Knowledge**: DDL, DML, and control flow statements
✅ **Data Type Proficiency**: Core data types and usage
✅ **Function Awareness**: Built-in function categories
✅ **Best Practices**: Coding standards and performance considerations

**Key Takeaways**:
- T-SQL is a powerful database programming language
- Proper syntax and conventions ensure code quality
- Built-in functions enhance query capabilities
- Performance considerations are critical
- Documentation and standards improve maintainability

---

## Slide 21: Next Steps - Module 2 Progression
**Lesson 2 Preview: Understanding Sets**

**Upcoming Topics**:
- Set theory fundamentals
- Relational model concepts
- Table relationships
- Data integrity principles
- Set operations in T-SQL

**Preparation Activities**:
- Review mathematical set concepts
- Practice basic SELECT statements
- Understand table structures
- Explore TechCorp database schema

**Module 2 Journey**:
- Lesson 1: ✅ T-SQL Introduction
- Lesson 2: Understanding Sets
- Lesson 3: Understanding Predicate Logic
- Lesson 4: Understanding Logical Order of Operations