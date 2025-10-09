# 🎯 PROGRESSIVE T-SQL EXERCISE - ANSWER KEY
## 30 Individual Questions: Simple to Complex

---

## **MODULE 2: T-SQL FUNDAMENTALS**

### **Question 1: Basic T-SQL Syntax - SOLUTION** (2 points)
*Module 2, Lesson 1: Introducing T-SQL*

```sql
-- ================================
-- BASIC T-SQL SYNTAX PRACTICE
-- Learning: System functions and proper formatting
-- ================================

-- Display current environment information
SELECT 
    DB_NAME() as CurrentDatabase,        -- Which database am I using?
    GETDATE() as CurrentDateTime,        -- What time is it now?
    USER_NAME() as CurrentUser,          -- Who am I logged in as?
    @@SERVERNAME as ServerName;          -- Which server am I on?

-- Practice proper T-SQL formatting and comments
SELECT 
    'TechCorp Solutions' as CompanyName,     -- Single-line comment
    'SQL Learning Exercise' as Purpose,      -- Another comment
    
    /* This is a multi-line comment
       Used for longer explanations
       Very helpful for documentation */
       
    'Lesson 1 Complete!' as Status;
```

**🎯 Business Value**: Understanding your database environment is crucial for any data analyst. You need to know which database you're working in and document your work properly.

**🔧 Key Learning**:
- `DB_NAME()` - shows current database
- `GETDATE()` - current date/time  
- `USER_NAME()` - current user
- `@@SERVERNAME` - server name
- Comments make code readable

---

### **Question 2: Understanding Sets - SOLUTION** (2 points)
*Module 2, Lesson 2: Understanding Sets*

```sql
-- ================================
-- SET-BASED THINKING WITH EMPLOYEE DATA
-- Learning: SQL works with sets of data, not individual records
-- ================================

-- Set #1: ALL employees (complete set)
SELECT * FROM Employees e;
-- This returns the COMPLETE SET of all employee records

-- Set #2: Only Engineering employees (filtered subset)  
SELECT * FROM Employees 
WHERE d.DepartmentName = 'Engineering';
-- This returns a SUBSET - only engineering employees

-- Set #3: Active employees (another subset)
SELECT * FROM Employees
WHERE IsActive = 1;

/* SET THEORY EXPLANATION:
   - SQL works with SETS of data (groups of records)
   - WHERE clause creates smaller sets (subsets) from larger sets
   - Each query defines a different set based on conditions
   - Sets can be combined, compared, and manipulated
*/
```

**🎯 Business Value**: Understanding that SQL works with sets helps you think about filtering, grouping, and combining data logically.

**🔧 Key Learning**:
- SQL operates on **sets** of data
- WHERE creates **subsets** from larger sets
- Each condition defines a different set
- Set thinking is fundamental to SQL

---

### **Question 3: Predicate Logic - SOLUTION** (2 points)  
*Module 2, Lesson 3: Understanding Predicate Logic*

```sql
-- ================================
-- PREDICATE LOGIC WITH LOGICAL OPERATORS
-- Learning: Combining conditions with AND, OR, NOT
-- ================================

-- Find employees matching complex logical conditions
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as FullName,
    BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    (BaseSalary > 75000 AND d.DepartmentName = 'Sales')     -- Condition 1
    OR                                                       -- OR operator
    (d.DepartmentName = 'Engineering');                     -- Condition 2

/* PREDICATE LOGIC EXPLANATION:
   A PREDICATE is a condition that evaluates to TRUE or FALSE
   
   - AND: Both conditions must be TRUE
   - OR: At least one condition must be TRUE  
   - NOT: Reverses TRUE/FALSE
   - Parentheses () group conditions for clarity
   
   This query finds employees who are EITHER:
   1. In Sales AND make more than $75,000, OR
   2. In Engineering (regardless of BaseSalary)
*/
```

**🎯 Business Value**: Complex business rules require combining multiple conditions. This is how you filter for "high-paid sales people OR any engineer."

**🔧 Key Learning**:
- **Predicates** are TRUE/FALSE conditions
- **AND** requires both conditions true
- **OR** requires at least one condition true
- Use parentheses to group conditions clearly

---

### **Question 4: Logical Order of Operations - SOLUTION** (2 points)
*Module 2, Lesson 4: Understanding Logical Order of Operations*

```sql
-- ================================
-- LOGICAL ORDER OF OPERATIONS
-- Learning: How SQL processes query clauses
-- ================================

SELECT                                   -- Step 5: Choose columns to display
    EmployeeID,
    FirstName + ' ' + LastName as FullName,
    BaseSalary
FROM Employees e                         -- Step 1: Get source table (FROM first!)
WHERE e.IsActive = 1                     -- Step 2: Filter rows (WHERE)
    AND e.BaseSalary > 50000             -- Still step 2: Additional filters
ORDER BY e.BaseSalary DESC;              -- Step 3: Sort results (ORDER BY last!)

/* SQL LOGICAL ORDER OF EXECUTION:
   
   1. FROM    - Identify source tables
   2. WHERE   - Filter individual rows  
   3. GROUP BY - Group rows (if used)
   4. HAVING  - Filter groups (if used)
   5. SELECT  - Choose columns and calculate expressions
   6. ORDER BY - Sort the final results
   
   Even though we WRITE SELECT first, SQL PROCESSES FROM first!
   This is why aliases created in SELECT can't be used in WHERE.
*/

-- Example showing why order matters:
SELECT 
    EmployeeID,
    BaseSalary * 1.1 as ProjectedSalary    -- Create alias in SELECT
FROM Employees
WHERE BaseSalary > 60000                   -- Can use original column in WHERE
-- WHERE ProjectedSalary > 66000          -- ❌ This would ERROR! 
                                           -- Can't use SELECT alias in WHERE
ORDER BY ProjectedSalary;                  -- ✅ Can use SELECT alias in ORDER BY
```

**🎯 Business Value**: Understanding execution order prevents errors and helps you write more efficient queries.

**🔧 Key Learning**:
- SQL processes **FROM** before **SELECT**
- **WHERE** filters before **SELECT** calculations
- **ORDER BY** happens after **SELECT**
- Aliases created in SELECT can be used in ORDER BY but not WHERE

---

## **MODULE 3: BASIC SELECT STATEMENTS**

### **Question 5: Simple SELECT Statements - SOLUTION** (3 points)
*Module 3, Lesson 1: Writing Simple SELECT Statements*

```sql
-- ================================
-- SIMPLE SELECT WITH PROPER FORMATTING
-- Learning: Foundation of data retrieval
-- ================================

-- Select specific columns with professional formatting
SELECT 
    EmployeeID,                          -- Primary key
    FirstName,                           -- Given name
    LastName,                            -- Family name  
    BaseSalary                           -- Annual compensation
FROM Employees e                           -- Source table
WHERE IsActive = 1                       -- Only current employees
ORDER BY LastName ASC,                   -- Sort by last name alphabetically
         FirstName ASC;                  -- Then by first name if last names match

-- Alternative formatting (also correct):
SELECT EmployeeID, FirstName, LastName, BaseSalary
FROM Employees  
WHERE IsActive = 1
ORDER BY LastName, FirstName;

/* FORMATTING BEST PRACTICES:
   - Align keywords (SELECT, FROM, WHERE, ORDER BY)
   - Put each column on its own line for complex queries
   - Use consistent indentation
   - Add comments to explain business logic
   - Use meaningful column names
*/
```

**🎯 Business Value**: Clean, readable queries are essential for maintenance and collaboration. Other analysts need to understand your work.

**🔧 Key Learning**:
- **SELECT** specifies which columns to retrieve
- **FROM** specifies the source table  
- **WHERE** filters which rows to include
- **ORDER BY** sorts the results
- Good formatting makes code professional and maintainable

---

### **Question 6: DISTINCT Values - SOLUTION** (3 points)
*Module 3, Lesson 2: Eliminating Duplicates with DISTINCT*

```sql
-- ================================
-- ELIMINATING DUPLICATES WITH DISTINCT
-- Learning: Remove duplicate values from results
-- ================================

-- Find all unique job titles in the company
SELECT DISTINCT JobTitle
FROM Employees
WHERE IsActive = 1
ORDER BY JobTitle;

-- Find all unique d.d.DepartmentName names  
SELECT DISTINCT d.d.DepartmentName
FROM Departments
WHERE IsActive = 1
ORDER BY d.d.DepartmentName;

-- Show the difference: WITH and WITHOUT DISTINCT
-- WITHOUT DISTINCT (shows duplicates)
SELECT JobTitle
FROM Employees
WHERE IsActive = 1
ORDER BY JobTitle;
-- This might show "Software Engineer" multiple times

-- WITH DISTINCT (removes duplicates)  
SELECT DISTINCT JobTitle  
FROM Employees
WHERE IsActive = 1
ORDER BY JobTitle;
-- This shows "Software Engineer" only once

-- DISTINCT with multiple columns (combination must be unique)
SELECT DISTINCT 
    DepartmentName,
    JobTitle
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, JobTitle;

/* DISTINCT RULES:
   - Removes duplicate rows from the result set
   - With multiple columns, the COMBINATION must be unique
   - DISTINCT applies to ALL columns in the SELECT list
   - Can impact performance on large datasets
   - Use when you need unique values for analysis
*/
```

**🎯 Business Value**: Finding unique values is essential for creating dropdown lists, understanding data variety, and avoiding duplicate counts in reports.

**🔧 Key Learning**:
- **DISTINCT** removes duplicate rows
- With multiple columns, the entire row must be unique
- Use for finding unique values in data
- Can slow performance on large tables

---

### **Question 7: Column and Table Aliases - SOLUTION** (3 points)
*Module 3, Lesson 3: Using Column and Table Aliases*

```sql
-- ================================
-- COLUMN AND TABLE ALIASES
-- Learning: Making queries readable and professional
-- ================================

-- Using table alias 'e' for Employees table
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as [Full Name],      -- Column alias with spaces
    e.JobTitle as [Job Position],                       -- Descriptive alias
    FORMAT(e.BaseSalary, 'C') as [Annual BaseSalary],      -- Formatted currency alias
    d.DepartmentName AS d.DepartmentName                      -- Simple alias
FROM Employees e                                        -- Table alias 'e'
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID  -- Table alias 'd'
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.BaseSalary DESC;

-- Alternative alias syntax (all equivalent):
SELECT 
    e.EmployeeID as EmpID,              -- Using 'as' keyword
    e.FirstName FullFirst,              -- Without 'as' keyword  
    e.LastName [Last Name],             -- Brackets for spaces
    e.BaseSalary "Annual Pay"           -- Double quotes (less common)
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Why use table aliases? Compare these two queries:

-- WITHOUT aliases (hard to read):
SELECT 
    Employees.FirstName,
    Employees.LastName,
    Departments.d.DepartmentName
FROM Employees 
INNER JOIN Departments d ON Employees.DepartmentID = Departments.DepartmentID;

-- WITH aliases (clean and professional):
SELECT 
    e.FirstName,
    e.LastName, 
    d.d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

/* ALIAS BEST PRACTICES:
   - Use short, meaningful table aliases (e, d, p, etc.)
   - Use descriptive column aliases for output
   - Brackets [] for aliases with spaces or special characters
   - Consistent alias usage throughout the query
   - Aliases make joins much more readable
*/
```

**🎯 Business Value**: Professional reports need user-friendly column names. Table aliases make complex queries manageable and reduce typing.

**🔧 Key Learning**:
- **Table aliases** (e, d) make queries shorter and cleaner
- **Column aliases** create user-friendly output headers
- Use brackets `[]` for aliases with spaces
- Aliases are essential for professional reports

---

### **Question 8: CASE Expressions - SOLUTION** (3 points)
*Module 3, Lesson 4: Writing Simple CASE Expressions*

```sql
-- ================================
-- CASE EXPRESSIONS FOR CONDITIONAL LOGIC
-- Learning: Creating calculated columns based on conditions
-- ================================

-- Categorize employees by BaseSalary ranges
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary,
    
    -- Simple CASE expression for BaseSalary categories
    CASE 
        WHEN BaseSalary < 50000 THEN 'Entry Level'
        WHEN BaseSalary BETWEEN 50000 AND 80000 THEN 'Mid Level'  
        WHEN BaseSalary > 80000 THEN 'Senior Level'
        ELSE 'Unspecified'                          -- Always include ELSE for safety
    END as SalaryCategory,
    
    -- Another CASE for performance bonus eligibility  
    CASE
        WHEN BaseSalary >= 100000 THEN 'Eligible for Stock Options'
        WHEN BaseSalary >= 75000 THEN 'Eligible for Performance Bonus'
        WHEN BaseSalary >= 50000 THEN 'Eligible for Merit Increase'
        ELSE 'Standard Review Process'
    END as BonusEligibility,
    
    -- CASE with complex conditions
    CASE 
        WHEN BaseSalary > 90000 AND DATEDIFF(YEAR, HireDate, GETDATE()) >= 3 
        THEN 'Senior High Performer'
        
        WHEN BaseSalary > 90000 AND DATEDIFF(YEAR, HireDate, GETDATE()) < 3
        THEN 'High Potential'
        
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 
        THEN 'Experienced Employee'
        
        ELSE 'Standard Employee'
    END as EmployeeType

FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;

-- CASE can also be used in WHERE clauses and ORDER BY
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary
FROM Employees
WHERE 
    CASE 
        WHEN DATEPART(MONTH, GETDATE()) <= 6 THEN BaseSalary > 70000  -- First half of year
        ELSE BaseSalary > 60000                                        -- Second half of year
    END = 1                                                           -- CASE result must be TRUE
ORDER BY 
    CASE 
        WHEN BaseSalary > 100000 THEN 1                               -- High earners first
        WHEN BaseSalary > 75000 THEN 2                                -- Mid earners second  
        ELSE 3                                                         -- Others last
    END,
    BaseSalary DESC;

/* CASE EXPRESSION RULES:
   - Always include ELSE clause (even if it's ELSE NULL)
   - Conditions evaluated in order (first match wins)
   - Can use complex conditions with AND/OR
   - Can be used in SELECT, WHERE, ORDER BY, and other clauses
   - Return type must be consistent (all strings, all numbers, etc.)
*/
```

**🎯 Business Value**: CASE expressions allow you to implement business logic directly in your queries, creating categories and classifications that match how your business thinks about data.

**🔧 Key Learning**:
- **CASE** creates conditional calculated columns
- Conditions evaluated in order (first match wins)
- Always include **ELSE** for completeness
- Can use complex conditions and multiple operators
- Essential for business categorization and reporting

---

## **MODULE 4: QUERYING MULTIPLE TABLES**

### **Question 9: Understanding Joins - SOLUTION** (3 points)
*Module 4, Lesson 1: Understanding Joins*

```sql
-- ================================
-- UNDERSTANDING TABLE RELATIONSHIPS AND JOINS  
-- Learning: How tables connect through foreign keys
-- ================================

-- First, let's understand the relationship between tables
/* 
FOREIGN KEY RELATIONSHIPS EXPLAINED:

Employees table has DepartmentID (foreign key)
Departments table has DepartmentID (primary key)

This creates a relationship: Each employee belongs to ONE d.DepartmentName,
but each d.d.DepartmentName can have MANY employees.

This is called a "One-to-Many" relationship.
*/

-- Show the relationship structure
SELECT 
    'Employees' as TableName,
    'DepartmentID' as ForeignKeyColumn,
    'References Departments.DepartmentID' as RelationshipDescription
UNION ALL
SELECT 
    'Departments' as TableName, 
    'DepartmentID' as PrimaryKeyColumn,
    'Referenced by Employees.DepartmentID' as RelationshipDescription;

-- Simple query demonstrating the relationship
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.DepartmentID,                     -- Foreign key value
    d.d.DepartmentName                    -- Related d.d.DepartmentName name
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;

-- Show what happens without the JOIN (missing information)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    DepartmentID                        -- Just a number - not very useful!
FROM Employees 
WHERE IsActive = 1;

/* RELATIONSHIP CONCEPTS:
   
   PRIMARY KEY: Unique identifier for each row (like EmployeeID)
   FOREIGN KEY: Reference to primary key in another table (like DepartmentID)
   
   JOINS allow us to combine related data from multiple tables
   Without JOINS, we'd only see foreign key numbers, not meaningful data
   
   Types of relationships:
   - One-to-Many: One d.DepartmentName, many employees  
   - Many-to-Many: Many employees, many projects (through junction table)
   - One-to-One: One employee, one employee detail record
*/
```

**🎯 Business Value**: Understanding relationships is crucial for data integrity and meaningful reporting. You need to know how business entities connect to each other.

**🔧 Key Learning**:
- **Foreign keys** create relationships between tables
- **JOINs** combine related data from multiple tables
- **One-to-Many** is the most common relationship type
- Without JOINs, you only see ID numbers, not meaningful data

---

### **Question 10: Inner Joins - SOLUTION** (4 points)
*Module 4, Lesson 2: Querying with Inner Joins*

```sql
-- ================================
-- INNER JOINS - MATCHING RECORDS ONLY
-- Learning: Combine tables where relationships exist
-- ================================

-- Basic INNER JOIN: Employees with their departments
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e                                    -- Left table (driving table)
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID  -- Right table
WHERE e.IsActive = 1                               -- Filter for active employees only
ORDER BY d.DepartmentName, e.LastName;

-- Multiple INNER JOINs: Add company information
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    d.DepartmentName,
    c.CompanyName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID      -- First join
INNER JOIN Companies c ON d.CompanyID = c.CompanyID              -- Second join  
WHERE e.IsActive = 1
ORDER BY c.CompanyName, d.DepartmentName, e.LastName;

-- INNER JOIN with aggregation: Count employees per d.d.DepartmentName
SELECT d.d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount,
    AVG(e.BaseSalary) as AverageSalary,
    MIN(e.BaseSalary) as MinSalary,
    MAX(e.BaseSalary) as MaxSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.d.DepartmentName           -- GROUP BY d.d.DepartmentName
HAVING COUNT(e.EmployeeID) > 0                      -- Only departments with employees
ORDER BY EmployeeCount DESC;

-- What INNER JOIN does and doesn't include:
/*
INNER JOIN includes ONLY records that have matches in BOTH tables

INCLUDES: 
- Employees who have a valid DepartmentID
- Departments that have employees

EXCLUDES:
- Employees with NULL or invalid DepartmentID  
- Departments with no employees
- Any record that doesn't have a match on the other side

This is the most restrictive type of join - only matching records survive.
*/

-- Example showing the difference:
-- Count total employees
SELECT COUNT(*) as TotalEmployees FROM Employees WHERE IsActive = 1;

-- Count employees with departments (using INNER JOIN)
SELECT COUNT(*) as EmployeesWithDepartments 
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;

-- If these numbers are different, some employees don't have valid departments!
```

**🎯 Business Value**: INNER JOINs are perfect when you only want complete records. For employee reports, you typically only want employees who have assigned departments.

**🔧 Key Learning**:
- **INNER JOIN** returns only matching records from both tables
- Use when you need complete information
- Most restrictive join type - excludes unmatched records
- Can chain multiple INNER JOINs together
- Perfect for standard business reporting

---

I have created the first 10 questions with detailed, progressive solutions. Each question focuses on a single lesson concept, building from basic T-SQL syntax to more complex INNER JOINs. 

---

### **Question 11: Outer Joins - SOLUTION** (4 points)
*Module 4, Lesson 3: Querying with Outer Joins*

```sql
-- ================================
-- OUTER JOINS - INCLUDING UNMATCHED RECORDS
-- Learning: Show all records from one table, even without matches
-- ================================

-- LEFT JOIN: Show ALL departments, even those without employees
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount,
    ISNULL(AVG(e.BaseSalary), 0) as AverageSalary
FROM Departments d                              -- Left table (all records kept)
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID    -- Right table (matched records only)
    AND e.IsActive = 1                          -- Additional condition in JOIN
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.d.DepartmentName
ORDER BY EmployeeCount DESC;

-- RIGHT JOIN: Show ALL employees, even those without valid departments
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    ISNULL(d.DepartmentName, 'No d.DepartmentName Assigned') as DepartmentName,
    e.BaseSalary
FROM Departments d                              -- Left table (matched records only)
RIGHT JOIN Employees e ON d.DepartmentID = e.DepartmentID   -- Right table (all records kept)
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;

-- FULL OUTER JOIN: Show ALL departments AND ALL employees
SELECT ISNULL(d.d.DepartmentName, 'Unknown Department') AS DepartmentName,
    ISNULL(e.FirstName + ' ' + e.LastName, 'No Employees') as Employee,
    e.BaseSalary
FROM Departments d
FULL OUTER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    AND e.IsActive = 1
WHERE d.IsActive = 1 OR d.DepartmentID IS NULL
ORDER BY d.DepartmentName, e.LastName;

-- Practical business use: Find departments that need staffing
SELECT d.d.DepartmentName,
    COUNT(e.EmployeeID) as CurrentEmployees,
    CASE 
        WHEN COUNT(e.EmployeeID) = 0 THEN 'URGENT: No employees assigned'
        WHEN COUNT(e.EmployeeID) < 3 THEN 'LOW: Needs more staff'  
        ELSE 'ADEQUATE: Properly staffed'
    END as StaffingStatus
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
WHERE d.IsActive = 1
GROUP BY d.DepartmentID, d.d.DepartmentName
ORDER BY CurrentEmployees ASC;

/* OUTER JOIN TYPES:
   
   LEFT JOIN:  All records from LEFT table + matching records from RIGHT table
   RIGHT JOIN: All records from RIGHT table + matching records from LEFT table  
   FULL OUTER JOIN: All records from BOTH tables
   
   Use ISNULL() to handle NULL values from unmatched records
   Perfect for finding gaps in data (departments without employees, etc.)
*/
```

**🎯 Business Value**: Outer joins help identify gaps in your data - departments without employees, employees without departments, customers without orders, etc. Critical for completeness analysis.

**🔧 Key Learning**:
- **LEFT JOIN** keeps all records from left table
- **RIGHT JOIN** keeps all records from right table  
- **FULL OUTER JOIN** keeps all records from both tables
- Use **ISNULL()** to handle NULL values from unmatched records
- Essential for finding data gaps and ensuring completeness

---

### **Question 12: Cross Joins and Self Joins - SOLUTION** (4 points)
*Module 4, Lesson 4: Querying with Cross Joins and Self Joins*

```sql
-- ================================
-- SELF JOINS - TABLE JOINED TO ITSELF
-- Learning: Find relationships within the same table
-- ================================

-- Self-join to show employee-manager relationships
SELECT 
    emp.EmployeeID,
    emp.FirstName + ' ' + emp.LastName as EmployeeName,
    emp.JobTitle as EmployeeTitle,
    ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'No Manager (Executive)') as ManagerName,
    ISNULL(mgr.JobTitle, 'N/A') as ManagerTitle,
    ISNULL(mgr.Email, 'N/A') as ManagerEmail
FROM Employees emp                          -- Employee alias
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID  -- Manager alias (same table!)
WHERE emp.IsActive = 1
ORDER BY mgr.LastName, emp.LastName;

-- Find employees and their direct reports (reverse perspective)
SELECT 
    mgr.FirstName + ' ' + mgr.LastName as ManagerName,
    mgr.JobTitle as ManagerTitle,
    COUNT(emp.EmployeeID) as DirectReports,
    STRING_AGG(emp.FirstName + ' ' + emp.LastName, ', ') as ReportNames
FROM Employees mgr
LEFT JOIN Employees emp ON mgr.EmployeeID = emp.ManagerID
    AND emp.IsActive = 1
WHERE mgr.IsActive = 1
GROUP BY mgr.EmployeeID, mgr.FirstName, mgr.LastName, mgr.JobTitle
HAVING COUNT(emp.EmployeeID) > 0    -- Only show managers with direct reports
ORDER BY DirectReports DESC;

-- ================================
-- CROSS JOINS - CARTESIAN PRODUCT
-- Learning: Every record with every other record (use carefully!)
-- ================================

-- Cross join example: All possible employee-project combinations
-- (Useful for creating assignment templates)
SELECT 
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    p.ProjectName,
    p.Status,
    CASE 
        WHEN e.JobTitle LIKE '%Engineer%' AND p.ProjectName LIKE '%Software%' 
        THEN 'Good Match'
        WHEN e.JobTitle LIKE '%Manager%' AND p.ProjectName LIKE '%Management%'
        THEN 'Good Match'
        ELSE 'Consider Skills Match'
    END as AssignmentRecommendation
FROM Employees e
CROSS JOIN Projects p
WHERE e.IsActive = 1 
    AND p.Status IN ('Planning', 'Active')
    AND e.DepartmentID IN (1, 2)    -- Limit to specific departments to reduce results
ORDER BY e.LastName, p.ProjectName;

-- More practical cross join: Create time slots for all employees
SELECT 
    e.FirstName + ' ' + e.LastName as EmployeeName,
    ts.TimeSlot,
    ts.TimeSlotDescription
FROM Employees e
CROSS JOIN (
    VALUES 
        ('09:00-10:00', 'Morning Block 1'),
        ('10:00-11:00', 'Morning Block 2'), 
        ('11:00-12:00', 'Morning Block 3'),
        ('14:00-15:00', 'Afternoon Block 1'),
        ('15:00-16:00', 'Afternoon Block 2')
) ts(TimeSlot, TimeSlotDescription)
WHERE e.IsActive = 1 
    AND e.DepartmentID = 1    -- Limit to one d.d.DepartmentName
ORDER BY e.LastName, ts.TimeSlot;

/* SELF JOIN vs CROSS JOIN:
   
   SELF JOIN:
   - Same table referenced twice with different aliases
   - Used for hierarchical relationships (employee-manager)
   - Requires a relationship column (like ManagerID)
   
   CROSS JOIN:
   - Creates all possible combinations (Cartesian product)
   - No ON condition needed
   - Use carefully - can create massive result sets!
   - Good for templates, schedules, and combination analysis
*/
```

**🎯 Business Value**: Self-joins reveal organizational hierarchies and reporting structures. Cross-joins help create templates and analyze all possible combinations for scheduling or assignment scenarios.

**🔧 Key Learning**:
- **Self-join** uses same table twice with different aliases
- Perfect for hierarchical data (employee-manager, category-subcategory)
- **Cross-join** creates all possible combinations
- Use CROSS JOIN carefully - results multiply quickly!
- Both are powerful for specific business scenarios

---

## **MODULE 5: SORTING AND FILTERING DATA**

### **Question 13: Sorting Data - SOLUTION** (3 points)
*Module 5, Lesson 1: Sorting Data*

```sql
-- ================================
-- SORTING DATA WITH ORDER BY
-- Learning: Control how results are presented
-- ================================

-- Multi-level sorting: d.DepartmentName, then BaseSalary, then name
SELECT 
    e.EmployeeID,
    d.DepartmentName,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    e.BaseSalary,
    e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY 
    d.DepartmentName ASC,          -- Primary sort: d.d.DepartmentName A-Z
    e.BaseSalary DESC,             -- Secondary sort: Highest BaseSalary first
    e.LastName ASC,                -- Tertiary sort: Last name A-Z
    e.FirstName ASC;               -- Quaternary sort: First name A-Z (for ties)

-- Demonstrate ASC vs DESC sorting
-- ASC (Ascending) - Default
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary ASC;           -- Lowest to highest BaseSalary

-- DESC (Descending)
SELECT 
    EmployeeID, 
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;          -- Highest to lowest BaseSalary

-- Sorting by calculated columns
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary,
    BaseSalary * 0.15 as BonusAmount,
    DATEDIFF(YEAR, HireDate, GETDATE()) as YearsOfService
FROM Employees
WHERE IsActive = 1
ORDER BY 
    BonusAmount DESC,              -- Sort by calculated bonus
    YearsOfService DESC;           -- Then by tenure

-- Sorting with CASE expressions (custom sort order)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY 
    CASE JobTitle
        WHEN 'CEO' THEN 1
        WHEN 'CTO' THEN 2  
        WHEN 'VP Engineering' THEN 3
        WHEN 'Director' THEN 4
        WHEN 'Senior Manager' THEN 5
        ELSE 6
    END,                           -- Custom hierarchy order
    BaseSalary DESC;               -- Then by BaseSalary within each level

/* SORTING RULES:
   
   - ORDER BY comes LAST in query execution
   - Can sort by multiple columns (comma-separated)
   - ASC = Ascending (A-Z, 0-9, oldest to newest) - DEFAULT
   - DESC = Descending (Z-A, 9-0, newest to oldest)  
   - Can sort by column names, aliases, or expressions
   - NULL values typically sort first (ASC) or last (DESC)
   - Use CASE for custom sort orders
*/
```

**🎯 Business Value**: Proper sorting makes reports professional and user-friendly. Executive reports need data sorted by importance, not just alphabetically.

**🔧 Key Learning**:
- **ORDER BY** controls result presentation
- Multiple sort levels with comma separation
- **ASC** = ascending (default), **DESC** = descending
- Can sort by calculated columns and CASE expressions
- Sort order affects user perception and usability

---

### **Question 14: Filtering with Predicates - SOLUTION** (3 points)
*Module 5, Lesson 2: Filtering Data with Predicates*

```sql
-- ================================
-- ADVANCED FILTERING WITH PREDICATES
-- Learning: Complex conditions to find specific data
-- ================================

-- Multiple condition types in one query
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary,
    e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                           -- Basic equality
    AND e.HireDate > '2020-01-01'              -- Date comparison
    AND e.BaseSalary BETWEEN 60000 AND 100000  -- Range operator
    AND d.d.DepartmentName IN ('Engineering', 'Sales', 'Marketing')  -- List operator
    AND e.JobTitle LIKE '%Engineer%'           -- Pattern matching
ORDER BY d.DepartmentName, e.BaseSalary DESC;

-- BETWEEN operator examples
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary,
    HireDate
FROM Employees
WHERE BaseSalary BETWEEN 70000 AND 90000       -- Inclusive range
    AND HireDate BETWEEN '2019-01-01' AND '2023-12-31'  -- Date range
    AND IsActive = 1
ORDER BY BaseSalary;

-- IN operator for multiple specific values
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID  
WHERE d.d.DepartmentName IN (                    -- Multiple departments
    'Engineering', 
    'Sales', 
    'Marketing',
    'Product Management'
)
    AND e.JobTitle IN (                        -- Multiple job titles
        'Software Engineer',
        'Senior Software Engineer', 
        'Sales Manager',
        'Marketing Specialist'
    )
    AND e.IsActive = 1
ORDER BY d.DepartmentName, e.JobTitle;

-- LIKE operator for pattern matching
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    Email,
    JobTitle
FROM Employees
WHERE JobTitle LIKE '%Manager%'                -- Contains 'Manager'
    OR JobTitle LIKE 'Senior%'                 -- Starts with 'Senior'  
    OR Email LIKE '%@techcorp.com'             -- Ends with company domain
    AND IsActive = 1
ORDER BY JobTitle;

-- Advanced pattern matching with LIKE
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Phone
FROM Employees  
WHERE FirstName LIKE 'J%'                      -- Starts with 'J'
    AND LastName LIKE '%son'                   -- Ends with 'son'
    AND Phone LIKE '___-___-____'              -- Specific phone format (underscores = any character)
    AND IsActive = 1;

-- Combining operators with complex logic
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    e.BaseSalary,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsOfService
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (
    -- High-value employees criteria
    (e.BaseSalary > 90000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3)
    OR 
    -- Rising stars criteria  
    (e.BaseSalary BETWEEN 70000 AND 90000 AND e.JobTitle LIKE 'Senior%')
    OR
    -- Management track criteria
    (e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%')
)
    AND e.IsActive = 1
    AND d.d.DepartmentName NOT IN ('HR', 'Finance')  -- Exclude certain departments
ORDER BY e.BaseSalary DESC;

/* PREDICATE OPERATORS:
   
   = , >, <, >=, <=, <> (not equal)
   BETWEEN...AND (inclusive range)
   IN (list of values)
   LIKE (pattern matching with % and _)
   IS NULL / IS NOT NULL
   EXISTS / NOT EXISTS (subqueries)
   
   LIKE wildcards:
   % = zero or more characters
   _ = exactly one character
   [] = any character in brackets [abc] 
   [^] = any character NOT in brackets [^abc]
*/
```

**🎯 Business Value**: Sophisticated filtering lets you answer specific business questions: "Find high-performing engineers hired in the last 3 years with salaries between X and Y."

**🔧 Key Learning**:
- **BETWEEN** for ranges (inclusive)
- **IN** for multiple specific values
- **LIKE** for pattern matching (% = any characters, _ = one character)
- Combine operators with **AND/OR** for complex logic
- Use parentheses to group conditions clearly

---

### **Question 15: TOP and OFFSET-FETCH - SOLUTION** (3 points)
*Module 5, Lesson 3: Filtering Data with TOP and OFFSET-FETCH*

```sql
-- ================================
-- TOP AND OFFSET-FETCH FOR RESULT LIMITING
-- Learning: Get specific numbers of records and implement pagination
-- ================================

-- Basic TOP - Get the highest paid employees
SELECT TOP 10
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;

-- TOP with PERCENT - Get top 15% of earners
SELECT TOP 15 PERCENT
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,  
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;

-- TOP WITH TIES - Include tied values
SELECT TOP 5 WITH TIES
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;
-- If multiple employees have the same 5th-highest BaseSalary, all are included

-- OFFSET-FETCH for pagination (SQL Server 2012+)
-- Page 1: First 10 records
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Page 2: Records 11-20  
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- Page 3: Records 21-30
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;

-- Dynamic pagination example (parameterized)
DECLARE @PageNumber INT = 3;        -- Which page to show
DECLARE @PageSize INT = 15;         -- Records per page

SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    BaseSalary,
    -- Show page info
    @PageNumber as CurrentPage,
    @PageSize as RecordsPerPage,
    (@PageNumber - 1) * @PageSize + 1 as FirstRecordNumber,
    @PageNumber * @PageSize as LastRecordNumber
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC
OFFSET (@PageNumber - 1) * @PageSize ROWS 
FETCH NEXT @PageSize ROWS ONLY;

-- Practical business example: Top performers by d.d.DepartmentName
SELECT d.d.DepartmentName,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.BaseSalary,
    ROW_NUMBER() OVER (PARTITION BY d.d.DepartmentName ORDER BY e.BaseSalary DESC) as RankInDepartment
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
    AND ROW_NUMBER() OVER (PARTITION BY d.d.DepartmentName ORDER BY e.BaseSalary DESC) <= 3
ORDER BY d.DepartmentName, e.BaseSalary DESC;

-- Alternative using subquery for top 3 per d.d.DepartmentName
SELECT * FROM (
    SELECT d.d.DepartmentName,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        e.BaseSalary,
        ROW_NUMBER() OVER (PARTITION BY d.d.DepartmentName ORDER BY e.BaseSalary DESC) as RowNum
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
) ranked
WHERE RowNum <= 3
ORDER BY d.DepartmentName, BaseSalary DESC;

/* TOP vs OFFSET-FETCH:
   
   TOP:
   - Older syntax, simple to use
   - Works with PERCENT and WITH TIES
   - Not standard SQL (SQL Server specific)
   
   OFFSET-FETCH:
   - Standard SQL (ANSI compliant)
   - Better for pagination
   - Requires ORDER BY clause
   - More flexible for dynamic queries
   
   Use OFFSET-FETCH for new development, TOP for quick queries
*/
```

**🎯 Business Value**: Pagination is essential for web applications and reports. TOP helps identify best performers, worst performers, or samples of data for analysis.

**🔧 Key Learning**:
- **TOP** gets first N records (with optional PERCENT, WITH TIES)
- **OFFSET-FETCH** provides standard SQL pagination
- OFFSET skips records, FETCH takes the next N
- Essential for performance with large datasets
- Use ROW_NUMBER() for "top N per group" scenarios

---

### **Question 16: Working with Unknown Values - SOLUTION** (3 points)
*Module 5, Lesson 4: Working with Unknown Values*

```sql
-- ================================
-- HANDLING NULL VALUES PROPERLY
-- Learning: Find, test, and handle missing data
-- ================================

-- Finding NULL values - employees with missing information
SELECT 
    EmployeeID,
    FirstName,
    MiddleName,                    -- May be NULL
    LastName,
    Phone,                         -- May be NULL
    Email,
    CASE 
        WHEN MiddleName IS NULL THEN 'Missing Middle Name'
        ELSE 'Has Middle Name'
    END as MiddleNameStatus,
    CASE 
        WHEN Phone IS NULL THEN 'Missing Phone' 
        ELSE 'Has Phone'
    END as PhoneStatus
FROM Employees
WHERE MiddleName IS NULL           -- Find employees without middle names
    OR Phone IS NULL               -- OR without phone numbers
ORDER BY LastName;

-- Using ISNULL to provide default values
SELECT 
    EmployeeID,
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName as FullName,
    ISNULL(Phone, 'Phone Not Available') as Phone,
    ISNULL(Email, 'Email Not Available') as Email,
    ISNULL(ManagerID, 0) as ManagerID,             -- Default to 0 for no manager
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY LastName;

-- Using COALESCE (returns first non-NULL value)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    COALESCE(Phone, Email, 'No Contact Info') as PrimaryContact,
    COALESCE(MiddleName, 'N/A') as MiddleName,
    BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY LastName;

-- NULL in calculations (NULL + anything = NULL!)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    BaseSalary,
    -- This will be NULL if bonus is NULL
    BaseSalary + BonusAmount as TotalCompWrong,
    -- This handles NULL properly  
    BaseSalary + ISNULL(BonusAmount, 0) as TotalCompCorrect,
    -- Alternative using COALESCE
    BaseSalary + COALESCE(BonusAmount, 0) as TotalCompAlt
FROM Employees
WHERE IsActive = 1
ORDER BY BaseSalary DESC;

-- NULL in WHERE clauses - be very careful!
-- Find employees without managers (ManagerID IS NULL)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    ManagerID,
    'Executive Level' as EmployeeLevel
FROM Employees  
WHERE ManagerID IS NULL            -- ✅ Correct way to test for NULL
    AND IsActive = 1;

-- This would be WRONG and return no results:
-- WHERE ManagerID = NULL         -- ❌ Wrong! Never use = NULL

-- NULL in aggregations (NULL values are ignored)
SELECT 
    COUNT(*) as TotalEmployees,                    -- Counts all rows
    COUNT(Phone) as EmployeesWithPhone,            -- Counts non-NULL phones only
    COUNT(MiddleName) as EmployeesWithMiddleName,  -- Counts non-NULL middle names
    AVG(e.BaseSalary) as AvgSalary,                 -- NULLs ignored in average
    SUM(e.BaseSalary) as TotalSalary                -- NULLs ignored in sum
FROM Employees
WHERE IsActive = 1;

-- Advanced NULL handling: NULLIF and complex scenarios
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as EmployeeName,
    
    -- NULLIF - converts empty strings to NULL
    NULLIF(LTRIM(RTRIM(Phone)), '') as CleanPhone,
    
    -- Complex NULL handling with CASE
    CASE 
        WHEN Phone IS NOT NULL AND LEN(LTRIM(RTRIM(Phone))) > 0 
        THEN Phone
        WHEN Email IS NOT NULL 
        THEN 'Contact via email: ' + Email
        ELSE 'No contact information available'
    END as ContactMethod,
    
    -- Handle division by zero with NULLIF
    CASE 
        WHEN NULLIF(DATEDIFF(YEAR, HireDate, GETDATE()), 0) IS NOT NULL
        THEN BaseSalary / NULLIF(DATEDIFF(YEAR, HireDate, GETDATE()), 0)
        ELSE BaseSalary
    END as SalaryPerYear

FROM Employees
WHERE IsActive = 1
ORDER BY EmployeeID;

/* NULL HANDLING FUNCTIONS:
   
   IS NULL / IS NOT NULL - Test for NULL values (NEVER use = NULL)
   ISNULL(value, replacement) - Replace NULL with specified value
   COALESCE(val1, val2, val3...) - Return first non-NULL value
   NULLIF(val1, val2) - Return NULL if values are equal
   
   NULL RULES:
   - NULL = NULL evaluates to UNKNOWN (not TRUE!)
   - Any arithmetic with NULL results in NULL  
   - COUNT(*) includes NULLs, COUNT(column) excludes NULLs
   - ORDER BY puts NULLs first (ASC) or last (DESC) depending on system
*/
```

**🎯 Business Value**: Missing data is a reality in business systems. Proper NULL handling ensures accurate calculations, prevents errors, and provides meaningful default values for reports.

**🔧 Key Learning**:
- Use **IS NULL** or **IS NOT NULL** (never = NULL)
- **ISNULL()** provides default values for NULL
- **COALESCE()** returns first non-NULL from multiple options
- NULLs are ignored in aggregations (COUNT, SUM, AVG)
- NULL + anything = NULL (handle in calculations)

---

I'll continue with Module 6 (Data Types), Module 7 (DML), Module 8 (Functions), Module 9 (Aggregation), and the Capstone questions in the next response to complete all 30 questions.
