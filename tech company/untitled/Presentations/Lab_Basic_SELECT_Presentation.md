# Lab: Writing Basic SELECT Statements - Individual Presentation

## Slide 1: Lab Overview
**Hands-On SELECT Statement Mastery**

- Practical T-SQL SELECT statement development
- TechCorp Solutions database exploration
- Query construction from basic to advanced
- Data retrieval techniques and best practices
- Result set formatting and presentation
- Foundation for complex query development

---

## Slide 2: Lab Objectives
**What You Will Accomplish**

**Primary Goals**:
- Write effective SELECT statements for data retrieval
- Master column selection and table referencing
- Apply filtering with WHERE clauses
- Implement sorting with ORDER BY
- Use aliases for improved readability
- Handle different data types in queries

**Skills Development**:
- Query development workflow
- SQL syntax proficiency
- Data analysis capabilities
- Result interpretation skills
- Code organization and formatting

---

## Slide 3: Lab Environment Setup
**TechCorp Database Preparation**

**Database Structure Review**:
```sql
-- Verify TechCorp database connection
USE TechCorpDB;

-- Review available tables
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Check table structures
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Employees', 'Departments', 'Projects')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
```

**Sample Data Verification**:
- Employee records (50+ employees)
- d.DepartmentName information (5 departments)
- Project assignments and history
- e.BaseSalary and performance data

---

## Slide 4: Exercise 1 - Basic SELECT Syntax
**Fundamental Query Structure**

**Exercise Tasks**:
1. Write simplest SELECT statement
2. Select specific columns
3. Select all columns
4. Use basic table references
5. Execute and interpret results

**Basic SELECT Examples**:
```sql
-- Select all columns FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID table
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Select specific columns
SELECT e.FirstName, e.LastName, d.DepartmentName FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Select with calculated columns
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary * 12 AS AnnualSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Select literal values
SELECT 
    'TechCorp Solutions' AS CompanyName,
    GETDATE() AS ReportDate,
    'Employee Report' AS ReportType;
```

**Key Learning Points**:
- Asterisk (*) selects all columns
- Column names separated by commas
- FROM clause specifies source table
- Semicolon terminates statements

---

## Slide 5: Exercise 2 - Column Selection Techniques
**Strategic Column Choosing**

**Column Selection Best Practices**:
```sql
-- Avoid SELECT * in production queries
-- Instead, specify needed columns explicitly
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    WorkEmail,
    e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Column ordering affects result presentation
SELECT 
    e.LastName,          -- Last name first
    e.FirstName,         -- Then first name
    d.DepartmentName,        -- d.DepartmentName context
    e.BaseSalary            -- Financial information last
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Include only necessary columns for performance
SELECT e.EmployeeID, e.FirstName, e.LastName  -- Minimal set
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

**Performance Considerations**:
- Only select columns you need
- Avoid SELECT * for better performance
- Consider network traffic and memory usage
- Index coverage benefits with specific columns

---

## Slide 6: Exercise 3 - Using Table Aliases
**Simplifying Table References**

**Table Alias Techniques**:
```sql
-- Basic table alias
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Multiple table aliases (preparation for JOINs)
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    d.Location
FROM Employees e, Departments d
WHERE e.DepartmentID = d.DepartmentID;

-- Meaningful alias names
SELECT 
    emp.FirstName AS EmployeeFirstName,
    mgr.FirstName AS ManagerFirstName
FROM Employees e emp, Employees mgr
WHERE emp.ManagerID = mgr.EmployeeID;
```

**Alias Benefits**:
- Shorter references in complex queries
- Required for self-joins
- Improved code readability
- Disambiguation of column names

---

## Slide 7: Exercise 4 - Column Aliases and Formatting
**Result Set Presentation**

**Column Alias Examples**:
```sql
-- Descriptive column aliases
SELECT 
    e.EmployeeID AS [Employee ID],
    e.FirstName AS [First Name],
    e.LastName AS [Last Name],
    e.BaseSalary AS [Annual e.BaseSalary],
    d.DepartmentName AS [Department Name]
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Calculated columns with aliases
SELECT 
    e.FirstName + ' ' + e.LastName AS [Full Name],
    e.BaseSalary / 12 AS [Monthly e.BaseSalary],
    YEAR(e.HireDate) AS [Hire Year],
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS [Years of Service]
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Business-friendly column names
SELECT 
    e.EmployeeID AS ID,
    e.FirstName + ' ' + e.LastName AS Name,
    d.DepartmentName AS Dept,
    FORMAT(e.BaseSalary, 'C') AS Compensation
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

**Formatting Techniques**:
- Use square brackets for spaces in aliases
- AS keyword is optional but recommended
- Format functions for better presentation
- Consider report requirements

---

## Slide 8: Exercise 5 - WHERE Clause Fundamentals
**Data Filtering Basics**

**Basic WHERE Conditions**:
```sql
-- Simple equality condition
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName = 'Information Technology';

-- Numeric comparisons
SELECT e.FirstName, e.LastName, e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE e.BaseSalary > 70000;

-- Date comparisons
SELECT e.FirstName, e.LastName, e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE e.HireDate >= '2020-01-01';

-- String pattern matching
SELECT e.FirstName, e.LastName, WorkEmail
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE e.LastName LIKE 'Smith%';
```

**Multiple Conditions**:
```sql
-- AND operator
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName = 'Engineering' AND e.BaseSalary > 75000;

-- OR operator
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName = 'Engineering' OR d.DepartmentName = 'Finance';

-- Complex conditions with parentheses
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE (Department = 'IT' OR d.DepartmentName = 'Finance') 
  AND e.BaseSalary > 60000;
```

---

## Slide 9: Exercise 6 - Comparison Operators
**Comprehensive Filtering Options**

**Comparison Operator Examples**:
```sql
-- Equality and inequality
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary = 75000;      -- Equal
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary <> 75000;     -- Not equal
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary != 75000;     -- Not equal (alternative)

-- Range comparisons
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary > 60000;      -- Greater than
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary >= 60000;     -- Greater than or equal
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary < 80000;      -- Less than
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary <= 80000;     -- Less than or equal

-- Range operations
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE e.BaseSalary BETWEEN 60000 AND 80000;              -- Inclusive range

-- Set membership
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName IN ('IT', 'Finance', 'HR');       -- List membership
```

**NULL Handling**:
```sql
-- NULL comparisons (special operators required)
SELECT * FROM Employees e WHERE MiddleName IS NULL;
SELECT * FROM Employees e WHERE MiddleName IS NOT NULL;
```

---

## Slide 10: Exercise 7 - Pattern Matching with LIKE
**Text Search Capabilities**

**LIKE Operator Patterns**:
```sql
-- Wildcard patterns
SELECT * FROM Employees e WHERE e.LastName LIKE 'Sm%';     -- Starts with 'Sm'
SELECT * FROM Employees e WHERE e.FirstName LIKE '%ohn';   -- Ends with 'ohn'
SELECT * FROM Employees e WHERE WorkEmail LIKE '%@techcorp%'; -- Contains '@techcorp'

-- Single character wildcard
SELECT * FROM Employees e WHERE e.FirstName LIKE 'J_n';    -- 3 letters: J_n (Jon, Jan, etc.)

-- Character ranges and sets
SELECT * FROM Employees e WHERE e.LastName LIKE '[A-D]%';  -- Starts with A, B, C, or D
SELECT * FROM Employees e WHERE e.EmployeeID LIKE '[0-9][0-9][0-9]'; -- 3 digits

-- Negation in character sets
SELECT * FROM Employees e WHERE e.LastName LIKE '[^S]%';   -- Doesn't start with S
```

**LIKE Performance Considerations**:
- Leading wildcards (%) prevent index usage
- Use full-text search for complex text queries
- Consider alternative approaches for better performance

---

## Slide 11: Exercise 8 - Sorting with ORDER BY
**Result Set Organization**

**Basic Sorting**:
```sql
-- Single column sorting
SELECT e.FirstName, e.LastName, e.BaseSalary 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
ORDER BY e.LastName;                    -- Ascending (default)

SELECT e.FirstName, e.LastName, e.BaseSalary 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
ORDER BY e.BaseSalary DESC;                 -- Descending

-- Multiple column sorting
SELECT e.FirstName, e.LastName, d.DepartmentName, e.BaseSalary 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
ORDER BY DepartmentID, e.LastName, e.FirstName;  -- Multiple levels

-- Mixed sorting directions
SELECT e.FirstName, e.LastName, d.DepartmentName, e.BaseSalary 
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
ORDER BY DepartmentID ASC, e.BaseSalary DESC;      -- d.DepartmentName A-Z, e.BaseSalary high-low
```

**Advanced Sorting**:
```sql
-- Sort by calculated columns
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary * 12 AS AnnualSalary
FROM Employees e 
ORDER BY AnnualSalary DESC;

-- Sort by column position (not recommended)
SELECT e.FirstName, e.LastName, e.BaseSalary 
FROM Employees e 
ORDER BY 3 DESC;                      -- Sort by 3rd column (e.BaseSalary)
```

---

## Slide 12: Exercise 9 - Working with Calculated Columns
**Dynamic Data Manipulation**

**Arithmetic Calculations**:
```sql
-- Basic arithmetic
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.BaseSalary * 1.10 AS SalaryWithRaise,      -- 10% increase
    e.BaseSalary / 12 AS MonthlySalary,          -- Monthly amount
    e.BaseSalary * 0.15 AS EstimatedTax          -- 15% tax estimate
FROM Employees e;

-- Date calculations
SELECT 
    e.FirstName,
    e.LastName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed,
    DATEDIFF(DAY, e.HireDate, GETDATE()) AS DaysEmployed,
    DATEADD(YEAR, 1, e.HireDate) AS FirstAnniversary
FROM Employees e;
```

**String Manipulations**:
```sql
-- String concatenation and functions
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    UPPER(e.FirstName) AS UpperFirstName,
    LEN(e.LastName) AS LastNameLength,
    LEFT(WorkEmail, CHARINDEX('@', WorkEmail) - 1) AS Username
FROM Employees e;
```

---

## Slide 13: Exercise 10 - Data Type Handling
**Working with Different Data Types**

**Numeric Data Types**:
```sql
-- Integer operations
SELECT 
    e.EmployeeID,
    e.EmployeeID * 100 AS ExpandedID,
    e.EmployeeID % 10 AS LastDigit
FROM Employees e;

-- Decimal operations
SELECT 
    e.BaseSalary,
    CAST(e.BaseSalary AS INT) AS SalaryRounded,
    ROUND(e.BaseSalary / 12, 2) AS MonthlySalary
FROM Employees e;
```

**Date and Time Operations**:
```sql
-- Date formatting and extraction
SELECT 
    e.HireDate,
    YEAR(e.HireDate) AS HireYear,
    MONTH(e.HireDate) AS HireMonth,
    DAY(e.HireDate) AS HireDay,
    DATENAME(WEEKDAY, e.HireDate) AS HireDayOfWeek,
    FORMAT(e.HireDate, 'MMMM dd, yyyy') AS FormattedHireDate
FROM Employees e;
```

**String Data Handling**:
```sql
-- String functions
SELECT 
    e.FirstName,
    UPPER(e.FirstName) AS UpperCase,
    LOWER(e.FirstName) AS LowerCase,
    REVERSE(e.FirstName) AS Reversed,
    REPLICATE(e.FirstName, 2) AS Doubled
FROM Employees e;
```

---

## Slide 14: Exercise 11 - Combining Conditions
**Complex Logical Expressions**

**Complex WHERE Clauses**:
```sql
-- Multiple AND conditions
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName = 'Engineering' 
  AND e.BaseSalary > 70000 
  AND YEAR(e.HireDate) >= 2020;

-- OR conditions with precedence
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE (Department = 'IT' OR d.DepartmentName = 'Finance') 
  AND e.BaseSalary > 65000;

-- NOT operator usage
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE NOT (Department = 'HR' OR e.BaseSalary < 50000);

-- Complex business logic
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE (Department = 'IT' AND e.BaseSalary > 75000)
   OR (Department = 'Finance' AND e.BaseSalary > 70000)
   OR (Department = 'HR' AND YEAR(e.HireDate) < 2020);
```

**Readability Best Practices**:
- Use parentheses for clarity
- Format complex conditions with proper indentation
- Break complex logic into understandable parts
- Comment business rules

---

## Slide 15: Exercise 12 - CASE Expressions Preview
**Conditional Logic in SELECT**

**Simple CASE Expressions**:
```sql
-- Basic CASE for categorization
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary > 80000 THEN 'High'
        WHEN e.BaseSalary > 60000 THEN 'Medium'
        ELSE 'Entry Level'
    END AS SalaryCategory
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- CASE for data transformation
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    CASE d.DepartmentName
        WHEN 'IT' THEN 'Information Technology'
        WHEN 'HR' THEN 'Human Resources'
        WHEN 'FIN' THEN 'Finance'
        ELSE d.DepartmentName
    END AS FullDepartmentName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

**Advanced CASE Usage**:
```sql
-- Multiple conditions in CASE
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    CASE 
        WHEN d.DepartmentName = 'Engineering' AND e.BaseSalary > 75000 THEN 'Senior IT Professional'
        WHEN d.DepartmentName = 'Engineering' THEN 'IT Professional'
        WHEN e.BaseSalary > 80000 THEN 'Senior Professional'
        ELSE 'Professional'
    END AS JobLevel
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

---

## Slide 16: Exercise 13 - Query Optimization Basics
**Writing Efficient SELECT Statements**

**Performance Best Practices**:
```sql
-- Efficient column selection
-- Good: Select only needed columns
SELECT e.EmployeeID, e.FirstName, e.LastName 
FROM Employees e 
WHERE d.DepartmentName = 'Engineering';

-- Avoid: SELECT * unless needed
-- SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';

-- Efficient WHERE conditions
-- Good: Use indexed columns in WHERE
SELECT * FROM Employees e WHERE e.EmployeeID = 101;

-- Less efficient: Functions in WHERE prevent index usage
-- SELECT * FROM Employees e WHERE UPPER(e.FirstName) = 'JOHN';
```

**Indexing Considerations**:
```sql
-- Check existing indexes
SELECT 
    i.name AS IndexName,
    c.name AS ColumnName,
    i.type_desc AS IndexType
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Employees');
```

---

## Slide 17: Exercise 14 - Result Set Analysis
**Interpreting Query Results**

**Result Validation**:
```sql
-- Count records to verify results
SELECT COUNT(*) AS TotalEmployees FROM Employees e;
SELECT COUNT(*) AS ITEmployees FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';

-- Statistical analysis
SELECT 
    COUNT(*) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MIN(e.BaseSalary) AS MinimumSalary,
    MAX(e.BaseSalary) AS MaximumSalary,
    SUM(e.BaseSalary) AS TotalPayroll
FROM Employees e
WHERE d.DepartmentName = 'Engineering';

-- Data quality checks
SELECT 
    COUNT(*) AS TotalRecords,
    COUNT(e.FirstName) AS NonNullFirstNames,
    COUNT(DISTINCT Department) AS UniqueDepartments
FROM Employees e;
```

**Common Analysis Patterns**:
- Record counts for validation
- Statistical summaries for insights
- Data quality assessments
- Business metric calculations

---

## Slide 18: Exercise 15 - Common Query Mistakes
**Troubleshooting and Debugging**

**Syntax Errors**:
```sql
-- Common mistakes and corrections

-- Mistake: Missing FROM clause
-- SELECT e.FirstName, e.LastName;
-- Correct:
SELECT e.FirstName, e.LastName FROM Employees e;

-- Mistake: Missing quotes around strings
-- SELECT * FROM Employees e WHERE d.DepartmentName = IT;
-- Correct:
SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';

-- Mistake: Using = with NULL
-- SELECT * FROM Employees e WHERE MiddleName = NULL;
-- Correct:
SELECT * FROM Employees e WHERE MiddleName IS NULL;
```

**Logic Errors**:
```sql
-- Mistake: Incorrect operator precedence
-- SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering' OR 'Finance' AND e.BaseSalary > 70000;
-- Correct:
SELECT * FROM Employees e WHERE (Department = 'IT' OR d.DepartmentName = 'Finance') AND e.BaseSalary > 70000;
```

**Debugging Techniques**:
- Test queries with small datasets
- Use SELECT COUNT(*) to verify filtering
- Check data types and formats
- Validate assumptions about data

---

## Slide 19: Exercise 16 - Real-World Business Scenarios
**Practical TechCorp Applications**

**HR Management Queries**:
```sql
-- New hire report
SELECT 
    e.FirstName + ' ' + e.LastName AS NewHire,
    d.DepartmentName,
    e.HireDate,
    e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE YEAR(e.HireDate) = YEAR(GETDATE())
ORDER BY e.HireDate DESC;

-- High performer identification
SELECT 
    e.FirstName + ' ' + e.LastName AS Employee,
    d.DepartmentName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary > 80000 THEN 'Retention Priority'
        ELSE 'Standard'
    END AS RetentionCategory
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
WHERE d.DepartmentName IN ('IT', 'Finance')
ORDER BY e.BaseSalary DESC;
```

**Financial Analysis**:
```sql
-- d.DepartmentName cost analysis
SELECT d.DepartmentName,
    COUNT(*) AS HeadCount,
    AVG(e.BaseSalary) AS AvgSalary,
    SUM(e.BaseSalary) AS TotalCost,
    FORMAT(SUM(e.BaseSalary), 'C') AS FormattedCost
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID 
GROUP BY DepartmentID
ORDER BY SUM(e.BaseSalary) DESC;
```

---

## Slide 20: Lab Validation and Testing
**Verifying Lab Completion**

**Validation Checklist**:
✅ Basic SELECT statements executed successfully
✅ Column selection and aliases implemented
✅ WHERE clauses with various conditions tested
✅ ORDER BY sorting applied correctly
✅ Calculated columns created and formatted
✅ Complex conditions with logical operators working
✅ Pattern matching with LIKE operator functional
✅ Data type handling demonstrated

**Testing Scenarios**:
```sql
-- Comprehensive test query
SELECT 
    e.EmployeeID AS ID,
    e.FirstName + ' ' + e.LastName AS [Full Name],
    e.DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS [Formatted e.BaseSalary],
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS [Years of Service],
    CASE 
        WHEN e.BaseSalary > 80000 THEN 'Senior Level'
        WHEN e.BaseSalary > 60000 THEN 'Mid Level'
        ELSE 'Entry Level'
    END AS [Career Level]
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('IT', 'Finance') 
  AND e.BaseSalary > 50000
ORDER BY e.DepartmentName, e.BaseSalary DESC;
```

---

## Slide 21: Next Steps and Module Transition
**Lab Completion and Module 3 Progress**

**Lab Achievement Summary**:
✅ **SELECT Mastery**: Comprehensive SELECT statement proficiency
✅ **Filtering Skills**: Advanced WHERE clause techniques
✅ **Sorting Capabilities**: ORDER BY implementation expertise
✅ **Data Presentation**: Alias and formatting skills
✅ **Complex Logic**: Multi-condition query development
✅ **Business Application**: Real-world scenario implementation

**Module 3 Remaining Topics**:
- Lesson 2: Eliminating Duplicates with DISTINCT
- Lesson 3: Using Column and Table Aliases (Advanced)
- Lesson 4: Writing Simple CASE Expressions (Advanced)

**Module 4 Preview: Querying Multiple Tables**:
- Understanding table relationships
- JOIN operations and syntax
- Multi-table query strategies
- Performance considerations for complex queries

**Continued Learning Path**:
- Practice with increasingly complex scenarios
- Explore advanced T-SQL features
- Apply skills to real business problems
- Prepare for multi-table operations