# 🎯 COMPREHENSIVE BEGINNER EXERCISE - COMPLETE ANSWER KEY

## Progressive Lesson-by-Lesson Solutions (30 Questions)

**This answer key provides complete solutions, explanations, and learning guidance for every question in the progressive exercise.**

---

## 🎯 **UNDERSTANDING TABLE ALIASES (c., d., e., etc.)**

Before we start the solutions, let's understand why you see prefixes like `c.`, `d.`, `e.` in SQL queries:

### **What are Table Aliases?**
Table aliases are **shortcut names** we give to tables to make queries easier to read and prevent confusion.

### **Example Without Aliases (Long and Confusing):**
```sql
SELECT Companies.CompanyName, Departments.DepartmentName, Employees.FirstName
FROM Companies 
INNER JOIN Departments ON Companies.CompanyID = Departments.CompanyID
INNER JOIN Employees ON Departments.DepartmentID = Employees.DepartmentID;
```

### **Same Query With Aliases (Clean and Professional):**
```sql
SELECT c.CompanyName, d.DepartmentName, e.FirstName
FROM Companies c                    -- "c" is the alias for Companies
INNER JOIN Departments d ON c.CompanyID = d.CompanyID    -- "d" is alias for Departments  
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID;  -- "e" is alias for Employees
```

### **Why Use Aliases?**
1. **Shorter Code**: `c.CompanyName` vs `Companies.CompanyName`
2. **Prevents Ambiguity**: When multiple tables have columns with same names
3. **Required for Self-Joins**: When joining a table to itself
4. **Professional Standard**: Industry best practice

### **Common TechCorp Aliases:**
- `c` = Companies
- `d` = Departments  
- `e` = Employees
- `p` = Projects
- `ep` = EmployeeProjects
- `pm` = PerformanceMetrics
- `es` = EmployeeSkills
- `s` = Skills

---

## **MODULE 2: T-SQL FUNDAMENTALS - SOLUTIONS**

### **Question 1: Basic T-SQL Syntax - SOLUTION** (2 points)

```sql
-- ================================
-- QUESTION 1: BASIC T-SQL SYNTAX  
-- Module 2, Lesson 1: Introducing T-SQL
-- ================================

-- Display current database information with system functions
SELECT 
    DB_NAME() as CurrentDatabase,           -- Current database name
    GETDATE() as CurrentDateTime,           -- Current date and time  
    USER_NAME() as CurrentUser,             -- Current user name
    @@SERVERNAME as ServerName;             -- Server instance name

-- Add comments to explain T-SQL basics
/*
This query demonstrates:
- Basic SELECT statement structure
- System functions for environment information  
- Column aliases for readable output
- Both single-line (--) and multi-line comments (/* */)
*/

-- T-SQL follows these key principles:
-- 1. Statements end with semicolons (optional but recommended)
-- 2. Keywords can be in any case (SELECT = select = Select)  
-- 3. String literals use single quotes 'like this'
-- 4. Comments improve code readability
```

**🎯 Business Explanation**: Every data analyst needs to understand their working environment. This query shows you which database you're connected to, what time it is, and who you're logged in as - essential for audit trails and debugging.

**🔧 Technical Breakdown**:
- **DB_NAME()**: Returns current database name (Module 2, Lesson 1)
- **GETDATE()**: Returns current date and time (Module 2, Lesson 1)
- **USER_NAME()**: Returns current user (Module 2, Lesson 1)  
- **@@SERVERNAME**: Global variable for server name (Module 2, Lesson 1)
- **Comments**: Essential for code documentation (Module 2, Lesson 1)

**💡 Beginner Tips**:
- Always add comments to explain what your code does
- Use meaningful column aliases to make output readable
- System functions help you understand your environment

---

### **Question 2: Understanding Sets - SOLUTION** (2 points)

```sql
-- ================================
-- DATA EXPLORATION WITH BASIC T-SQL
-- Module References: Module 2 (Lesson 1), Module 3 (Lesson 1 preview)
-- ================================

-- Select ALL columns from Employees table (basic SELECT *)
SELECT * 
FROM Employees;

-- Select SPECIFIC columns from Departments table (better practice)
SELECT 
    DepartmentID,           -- Primary key
    DepartmentName,         -- Department name
    CompanyID,              -- Foreign key to Companies
    IsActive                -- Status flag
FROM Departments;

-- Use WHERE clause to filter for active employees only
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    BaseSalary,
    HireDate,
    IsActive
FROM Employees 
WHERE IsActive = 1;         -- Filter condition: only active employees

-- Practice with table aliases (e = Employees, d = Departments)
SELECT 
    e.EmployeeID,           -- e. means "from Employees table"
    e.FirstName + ' ' + e.LastName as FullName,  -- Concatenate names
    e.JobTitle,
    d.DepartmentName,       -- d. means "from Departments table"  
    e.BaseSalary
FROM Employees e            -- "e" is the alias for Employees
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID  -- Join using aliases
WHERE e.IsActive = 1;       -- Filter using alias
```

**🎯 Business Explanation**: This demonstrates the core of data retrieval - how to select specific data from our TechCorp database. Notice how we use table aliases (`e.`, `d.`) to make the query cleaner and avoid confusion when columns have the same name in different tables.

**🔧 Technical Breakdown**:
- **SELECT ***: Gets all columns (useful for exploration, but avoid in production)
- **SELECT specific columns**: Better performance and clarity
- **WHERE clause**: Filters rows based on conditions (Module 2, Lesson 3)
- **Table aliases**: `e` for Employees, `d` for Departments (professional practice)
- **String concatenation**: Using `+` operator to combine FirstName and LastName

---

#### **3. Set Theory and Logic Practice - SOLUTION**

```sql
-- ================================
-- SET THEORY AND PREDICATE LOGIC IN T-SQL
-- Module References: Module 2 (Lessons 2-4)
-- ================================

-- Set Theory: Employees hired in the last 5 years
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsOfService
FROM Employees e
WHERE e.HireDate >= DATEADD(YEAR, -5, GETDATE())    -- Set condition: hired within 5 years
    AND e.IsActive = 1                               -- Additional set condition
ORDER BY e.HireDate DESC;

-- Aggregation: Departments with more than 10 employees  
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
HAVING COUNT(e.EmployeeID) > 10;                    -- Filter groups, not individual rows

-- Logical Operators Practice (AND, OR, NOT)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1                                 -- Must be active
    AND (                                            -- AND with grouped conditions
        e.BaseSalary > 80000                        -- High salary
        OR e.JobTitle LIKE '%Manager%'              -- OR management position  
        OR e.JobTitle LIKE '%Director%'             -- OR director position
    )
    AND NOT e.JobTitle LIKE '%Intern%';             -- NOT an intern position

-- NULL Handling Practice
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.MiddleName,
    e.LastName,
    
    -- Handle NULL middle names gracefully
    CASE 
        WHEN e.MiddleName IS NULL THEN e.FirstName + ' ' + e.LastName
        ELSE e.FirstName + ' ' + e.MiddleName + ' ' + e.LastName
    END as FullName,
    
    -- Check for NULL phone numbers  
    CASE 
        WHEN e.Phone IS NULL THEN 'No Phone on File'
        ELSE e.Phone
    END as PhoneNumber
    
FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.LastName, e.FirstName;

-- Set Operations: Find employees without phone numbers (NULL set)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.Email,
    'Missing Phone Number' as DataIssue
FROM Employees e
WHERE e.Phone IS NULL                               -- IS NULL (not = NULL!)
    AND e.IsActive = 1;

-- Predicate Logic: Complex business rules
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    e.BaseSalary,
    e.HireDate,
    
    -- Complex business logic using predicates
    CASE 
        WHEN e.BaseSalary > 100000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 
        THEN 'Senior High Earner'
        
        WHEN e.BaseSalary > 100000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) < 3
        THEN 'Junior High Earner'  
        
        WHEN e.BaseSalary <= 100000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5
        THEN 'Experienced Standard Earner'
        
        WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%'
        THEN 'Management Track'
        
        ELSE 'Standard Employee'
    END as EmployeeCategory

FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.BaseSalary DESC;
```

**🎯 Business Explanation**: This demonstrates how T-SQL uses set theory and logic to filter and categorize data. In business, we constantly need to group employees, find specific subsets of data, and apply complex business rules - this is the foundation of that analysis.

**🔧 Technical Breakdown**:
- **Set Theory**: Using WHERE to define sets of data (Module 2, Lesson 2)
- **Predicate Logic**: Complex TRUE/FALSE conditions (Module 2, Lesson 3) 
- **Logical Operators**: AND, OR, NOT for combining conditions (Module 2, Lesson 3)
- **NULL Handling**: IS NULL vs = NULL (critical difference!) (Module 2, Lesson 4)
- **CASE Expressions**: Multi-condition logic (Module 3 preview)
- **Date Functions**: DATEADD, DATEDIFF for date calculations
- **Aggregate Functions**: COUNT with GROUP BY (Module 9 preview)

**💡 Beginner Tips**:
- Always use `IS NULL`, never `= NULL` (NULL equals nothing, not even NULL!)
- Group conditions with parentheses for clarity: `(A OR B) AND C`
- Use table aliases consistently throughout your query
- Test complex logic with simple data first
- Remember: SQL works with SETS of data, not individual records

---

#### **2. Database Schema Analysis - SOLUTION**

```sql
-- ================================
-- DATABASE SCHEMA AND TABLE ANALYSIS
-- Module References: Module 1 (Lesson 3), Module 2 (Lesson 2)
-- ================================

-- Get table information with row counts
SELECT 
    t.TABLE_SCHEMA as SchemaName,
    t.TABLE_NAME as TableName,
    t.TABLE_TYPE,
    
    -- Get row count for each table
    (SELECT COUNT(*) 
     FROM INFORMATION_SCHEMA.TABLES t2 
     WHERE t2.TABLE_NAME = t.TABLE_NAME) as RowCount,
     
    -- Table creation date
    (SELECT create_date 
     FROM sys.tables st 
     WHERE st.name = t.TABLE_NAME) as CreatedDate
     
FROM INFORMATION_SCHEMA.TABLES t
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_NAME;

-- Get primary key information
SELECT 
    tc.TABLE_NAME as TableName,
    tc.CONSTRAINT_NAME as PrimaryKeyName,
    STRING_AGG(cc.COLUMN_NAME, ', ') as PrimaryKeyColumns
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc 
        ON tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
GROUP BY tc.TABLE_NAME, tc.CONSTRAINT_NAME
ORDER BY tc.TABLE_NAME;

-- Get foreign key relationships
SELECT 
    fk.TABLE_NAME as ForeignKeyTable,
    fk.COLUMN_NAME as ForeignKeyColumn,
    pk.TABLE_NAME as PrimaryKeyTable,
    pk.COLUMN_NAME as PrimaryKeyColumn,
    rc.CONSTRAINT_NAME as RelationshipName
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE fk 
        ON rc.CONSTRAINT_NAME = fk.CONSTRAINT_NAME
    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk 
        ON rc.UNIQUE_CONSTRAINT_NAME = pk.CONSTRAINT_NAME
ORDER BY fk.TABLE_NAME, fk.COLUMN_NAME;
```

**🎯 Business Explanation**: Understanding the database schema is crucial for effective data analysis. This shows us how our business entities (employees, projects, departments) are related and helps us plan our queries effectively.

**🔧 Technical Breakdown**:
- Uses INFORMATION_SCHEMA views - standard way to query database metadata
- Demonstrates subqueries for getting additional information
- Shows STRING_AGG function for concatenating results (Module 8 preview)
- Uses INNER JOINs to combine constraint information (Module 4 foundation)

---

#### **3. Data Quality Assessment - SOLUTION**

```sql
-- ================================
-- DATA QUALITY AND COMPLETENESS CHECK
-- Module References: Module 5 (Lesson 4), Module 8 (Lesson 4)
-- ================================

-- Find tables with no data
SELECT 
    t.TABLE_NAME,
    'Empty Table - No Records' as DataQualityIssue,
    0 as RecordCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE t.TABLE_TYPE = 'BASE TABLE'
    AND NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS c 
        WHERE c.TABLE_NAME = t.TABLE_NAME
    );

-- Check for NULL values in key columns (example for Employees table)
SELECT 
    'Employees' as TableName,
    SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END) as NullFirstNames,
    SUM(CASE WHEN LastName IS NULL THEN 1 ELSE 0 END) as NullLastNames,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) as NullEmails,
    SUM(CASE WHEN BaseSalary IS NULL THEN 1 ELSE 0 END) as NullSalaries,
    COUNT(*) as TotalRecords,
    
    -- Calculate completeness percentage
    CAST(
        (COUNT(*) - SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) as FirstNameCompleteness
FROM Employees;

-- Data type summary for all columns
SELECT 
    c.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.IS_NULLABLE,
    ISNULL(c.CHARACTER_MAXIMUM_LENGTH, 0) as MaxLength,
    ISNULL(c.NUMERIC_PRECISION, 0) as NumericPrecision,
    ISNULL(c.NUMERIC_SCALE, 0) as NumericScale,
    c.COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME IN ('Employees', 'Projects', 'Departments', 'Companies')
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;
```

**🎯 Business Explanation**: Data quality is fundamental to reliable analysis. Before we can trust our reports, we need to understand what data might be missing or inconsistent. This assessment helps us identify potential issues that could affect our business insights.

**🔧 Technical Breakdown**:
- Uses CASE expressions (Module 3) for conditional counting
- Demonstrates NULL handling techniques (Module 5, Lesson 4)
- Shows percentage calculations with proper DECIMAL casting (Module 6)
- Uses EXISTS operator for advanced filtering (Module 5)

**💡 Beginner Tips**: 
- Always check data quality before starting analysis
- NULL values can significantly impact aggregate calculations
- Understanding data types helps prevent conversion errors
- Document any data quality issues for stakeholders

---

## 👥 **PART 2 SOLUTIONS: EMPLOYEE INTELLIGENCE DASHBOARD**

### **Task 2.1: Employee Profile Analysis - SOLUTION**

```sql
-- ================================
-- COMPREHENSIVE EMPLOYEE PROFILE DASHBOARD
-- Module References: Module 3 (All Lessons), Module 6 (Lessons 2-3)
-- ================================

SELECT 
    -- Employee identification
    e.EmployeeID,
    
    -- Full name handling (graceful NULL management)
    CONCAT(
        e.FirstName,
        CASE 
            WHEN e.MiddleName IS NOT NULL THEN ' ' + e.MiddleName + ' '
            ELSE ' '
        END,
        e.LastName
    ) as FullName,
    
    -- Professional information
    e.JobTitle,
    d.DepartmentName,
    c.CompanyName,
    
    -- Formatted salary with currency
    FORMAT(e.BaseSalary, 'C', 'en-US') as FormattedSalary,
    
    -- Employment tenure calculation
    DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsOfService,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 as AdditionalMonths,
    DATEDIFF(DAY, DATEADD(MONTH, DATEDIFF(MONTH, e.HireDate, GETDATE()), e.HireDate), GETDATE()) as AdditionalDays,
    
    -- Age category (if birth date available)
    CASE 
        WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Over 60'
    END as AgeGroup,
    
    -- Contact information
    e.Email,
    RIGHT(e.Email, LEN(e.Email) - CHARINDEX('@', e.Email)) as EmailDomain,
    FORMAT(TRY_CAST(e.Phone AS BIGINT), '(###) ###-####') as FormattedPhone,
    
    -- Experience level classification using business rules
    CASE 
        WHEN e.BaseSalary > 150000 OR e.JobTitle LIKE '%Director%' 
             OR e.JobTitle LIKE '%VP%' OR e.JobTitle LIKE '%Chief%' 
        THEN 'Executive'
        
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 AND e.BaseSalary > 80000 
        THEN 'Senior Professional'
        
        WHEN (DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 5) 
             OR (e.BaseSalary BETWEEN 50000 AND 80000) 
        THEN 'Mid-Level'
        
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 AND e.BaseSalary < 50000 
        THEN 'Developing Professional'
        
        ELSE 'Professional' -- Catch-all for edge cases
    END as ExperienceLevel,
    
    -- Employment status
    CASE 
        WHEN e.IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END as EmploymentStatus,
    
    -- Original hire date for reference
    e.HireDate,
    
    -- Manager information if available
    ISNULL(m.FirstName + ' ' + m.LastName, 'No Manager Assigned') as ManagerName

FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN Companies c ON d.CompanyID = c.CompanyID
    LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
    
WHERE e.IsActive = 1 -- Only show active employees

ORDER BY 
    d.DepartmentName,
    e.BaseSalary DESC,
    e.LastName,
    e.FirstName;
```

**🎯 Business Explanation**: This comprehensive employee profile gives HR and management a complete view of our workforce. The experience level classification helps with career development planning, while the tenure calculations support retention analysis and anniversary recognition programs.

**🔧 Technical Breakdown**:
- **CONCAT vs + operator**: CONCAT handles NULLs gracefully (Module 8)
- **Complex CASE expressions**: Multi-condition business logic (Module 3, Lesson 4)
- **Date calculations**: Multiple DATEDIFF functions for precise tenure (Module 6, Lesson 3)
- **String functions**: RIGHT, LEN, CHARINDEX for email parsing (Module 8)
- **FORMAT function**: Professional numeric and currency display (Module 8)
- **JOIN types**: INNER for required relationships, LEFT for optional (Module 4)

**💡 Beginner Tips**:
- Always handle NULL values in string concatenation
- Use FORMAT() for user-friendly number displays
- CASE expressions can implement complex business rules
- Test date calculations with edge cases (leap years, month boundaries)

---

### **Task 2.2: Compensation Analysis Report - SOLUTION**

```sql
-- ================================
-- COMPENSATION ANALYSIS AND EQUITY REVIEW
-- Module References: Module 3 (Lesson 2), Module 9 (Lessons 1-3)
-- ================================

SELECT 
    -- Department and level information
    d.DepartmentName,
    jl.LevelName as JobLevel,
    
    -- Employee counts
    COUNT(*) as EmployeeCount,
    COUNT(DISTINCT e.JobTitle) as UniqueJobTitles,
    
    -- Salary statistics
    FORMAT(AVG(e.BaseSalary), 'C', 'en-US') as AverageSalary,
    FORMAT(MIN(e.BaseSalary), 'C', 'en-US') as MinimumSalary,
    FORMAT(MAX(e.BaseSalary), 'C', 'en-US') as MaximumSalary,
    
    -- Calculate salary percentiles using window functions
    FORMAT(
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY e.BaseSalary), 
        'C', 'en-US'
    ) as Percentile25th,
    
    FORMAT(
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY e.BaseSalary), 
        'C', 'en-US'
    ) as MedianSalary,
    
    FORMAT(
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.BaseSalary), 
        'C', 'en-US'
    ) as Percentile75th,
    
    FORMAT(
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY e.BaseSalary), 
        'C', 'en-US'
    ) as Percentile90th,
    
    -- Salary range and variance
    FORMAT(MAX(e.BaseSalary) - MIN(e.BaseSalary), 'C', 'en-US') as SalaryRange,
    
    -- Calculate standard deviation for dispersion analysis
    FORMAT(STDEV(e.BaseSalary), 'N2') as SalaryStandardDeviation,
    
    -- Pay equity indicators
    CASE 
        WHEN STDEV(e.BaseSalary) / AVG(e.BaseSalary) > 0.25 
        THEN 'High Variance - Review Needed'
        WHEN STDEV(e.BaseSalary) / AVG(e.BaseSalary) > 0.15 
        THEN 'Moderate Variance - Monitor'
        ELSE 'Low Variance - Equitable'
    END as PayEquityStatus,
    
    -- Budget calculations
    FORMAT(SUM(e.BaseSalary), 'C', 'en-US') as TotalDepartmentPayroll,
    
    -- Performance correlation
    AVG(ISNULL(pm.Achievement, 0)) as AveragePerformanceRating

FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
    LEFT JOIN (
        -- Get latest performance metrics for each employee
        SELECT 
            EmployeeID, 
            Achievement,
            ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY ReviewDate DESC) as rn
        FROM PerformanceMetrics
    ) pm ON e.EmployeeID = pm.EmployeeID AND pm.rn = 1
    
WHERE e.IsActive = 1

GROUP BY 
    d.DepartmentName, 
    jl.LevelName
    
HAVING 
    COUNT(*) >= 3  -- Only show groups with 3+ employees for statistical relevance
    
ORDER BY 
    d.DepartmentName,
    AVG(e.BaseSalary) DESC;

-- Detailed pay equity analysis by gender (if gender data available)
SELECT 
    d.DepartmentName,
    e.Gender,
    COUNT(*) as EmployeeCount,
    FORMAT(AVG(e.BaseSalary), 'C', 'en-US') as AverageSalary,
    FORMAT(STDEV(e.BaseSalary), 'N2') as SalaryStandardDeviation
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
    AND e.Gender IS NOT NULL
GROUP BY d.DepartmentName, e.Gender
ORDER BY d.DepartmentName, e.Gender;
```

**🎯 Business Explanation**: This analysis helps identify potential pay inequities and supports budget planning. The percentile calculations show how salaries are distributed, while the variance analysis flags departments that may need compensation review. This data is crucial for HR compliance and competitive positioning.

**🔧 Technical Breakdown**:
- **Aggregate functions**: COUNT, AVG, MIN, MAX, SUM (Module 9, Lesson 1)
- **PERCENTILE_CONT**: Advanced statistical function (Module 9 advanced)
- **Window functions**: ROW_NUMBER for latest performance data (Module 9)
- **STDEV function**: Statistical variance calculation (Module 9)
- **HAVING clause**: Filter aggregated results (Module 9, Lesson 3)
- **Subqueries**: Get latest performance metrics only

**💡 Beginner Tips**:
- Use HAVING to filter after GROUP BY operations
- PERCENTILE functions require WITHIN GROUP clause
- Standard deviation shows salary consistency within groups
- Always consider statistical significance (minimum group sizes)

---

## 🤝 **PART 3 SOLUTIONS: RELATIONSHIP ANALYSIS & JOINS MASTERY**

### **Task 3.1: Organizational Structure Analysis - SOLUTIONS**

#### **1. Management Hierarchy Report - SOLUTION**

```sql
-- ================================
-- MANAGEMENT HIERARCHY AND SPAN OF CONTROL
-- Module References: Module 4 (Lesson 4 - Self Joins)
-- ================================

SELECT 
    -- Manager information
    mgr.EmployeeID as ManagerID,
    mgr.FirstName + ' ' + mgr.LastName as ManagerName,
    mgr.JobTitle as ManagerTitle,
    mgr_dept.DepartmentName as ManagerDepartment,
    
    -- Direct report information
    emp.EmployeeID,
    emp.FirstName + ' ' + emp.LastName as EmployeeName,
    emp.JobTitle as EmployeeTitle,
    emp_dept.DepartmentName as EmployeeDepartment,
    
    -- Span of control calculation
    COUNT(*) OVER (PARTITION BY mgr.EmployeeID) as SpanOfControl,
    
    -- Management level indicator
    CASE 
        WHEN mgr.ManagerID IS NULL THEN 'Executive Level'
        WHEN EXISTS (
            SELECT 1 FROM Employees sub 
            WHERE sub.ManagerID = mgr.EmployeeID
        ) THEN 'Middle Management'
        ELSE 'Senior Individual Contributor'
    END as ManagementLevel,
    
    -- Salary comparison
    FORMAT(mgr.BaseSalary, 'C') as ManagerSalary,
    FORMAT(emp.BaseSalary, 'C') as EmployeeSalary,
    FORMAT(mgr.BaseSalary - emp.BaseSalary, 'C') as SalaryDifference,
    
    -- Tenure comparison
    DATEDIFF(MONTH, mgr.HireDate, GETDATE()) as ManagerTenureMonths,
    DATEDIFF(MONTH, emp.HireDate, GETDATE()) as EmployeeTenureMonths

FROM Employees emp
    INNER JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID  -- Self-join for manager relationship
    INNER JOIN Departments emp_dept ON emp.DepartmentID = emp_dept.DepartmentID
    INNER JOIN Departments mgr_dept ON mgr.DepartmentID = mgr_dept.DepartmentID
    
WHERE emp.IsActive = 1 AND mgr.IsActive = 1

ORDER BY 
    mgr_dept.DepartmentName,
    mgr.LastName,
    emp.LastName;

-- Summary of management structure
SELECT 
    d.DepartmentName,
    COUNT(CASE WHEN e.ManagerID IS NULL THEN 1 END) as Executives,
    COUNT(CASE WHEN e.ManagerID IS NOT NULL AND EXISTS (
        SELECT 1 FROM Employees sub WHERE sub.ManagerID = e.EmployeeID
    ) THEN 1 END) as MiddleManagers,
    COUNT(CASE WHEN e.ManagerID IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Employees sub WHERE sub.ManagerID = e.EmployeeID
    ) THEN 1 END) as IndividualContributors,
    AVG(CASE WHEN e.ManagerID IS NOT NULL THEN e.BaseSalary END) as AvgNonExecutiveSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentName
ORDER BY d.DepartmentName;
```

**🎯 Business Explanation**: Understanding the management hierarchy helps identify potential organizational issues like excessive layers, too-wide spans of control, or departments without clear leadership structure. This analysis supports organizational design and succession planning.

**🔧 Technical Breakdown**:
- **Self-join**: Employees table joined to itself (Module 4, Lesson 4)
- **Window functions**: COUNT OVER for span of control (Module 9 advanced)
- **EXISTS operator**: Check for existence of subordinates (Module 5)
- **Complex CASE expressions**: Multi-level logic for management classification
- **Conditional aggregation**: COUNT(CASE WHEN) pattern (Module 9)

---

#### **2. Department Collaboration Matrix - SOLUTION**

```sql
-- ================================
-- DEPARTMENT COLLABORATION AND CROSS-FUNCTIONAL ANALYSIS
-- Module References: Module 4 (Lesson 4 - Cross Joins)
-- ================================

-- Show actual collaborations between departments
WITH DepartmentCollaboration AS (
    SELECT DISTINCT
        d1.DepartmentName as Department1,
        d2.DepartmentName as Department2,
        p.ProjectName,
        p.ProjectStatus,
        COUNT(*) as EmployeesCollaborating
    FROM Projects p
        INNER JOIN EmployeeProjects ep1 ON p.ProjectID = ep1.ProjectID
        INNER JOIN Employees e1 ON ep1.EmployeeID = e1.EmployeeID
        INNER JOIN Departments d1 ON e1.DepartmentID = d1.DepartmentID
        INNER JOIN EmployeeProjects ep2 ON p.ProjectID = ep2.ProjectID
        INNER JOIN Employees e2 ON ep2.EmployeeID = e2.EmployeeID
        INNER JOIN Departments d2 ON e2.DepartmentID = d2.DepartmentID
    WHERE d1.DepartmentID < d2.DepartmentID  -- Avoid duplicates
        AND p.ProjectStatus IN ('Active', 'Planning')
    GROUP BY d1.DepartmentName, d2.DepartmentName, p.ProjectName, p.ProjectStatus
),

-- Create all possible department pairs
AllDepartmentPairs AS (
    SELECT DISTINCT
        d1.DepartmentName as Department1,
        d2.DepartmentName as Department2
    FROM Departments d1
        CROSS JOIN Departments d2
    WHERE d1.DepartmentID < d2.DepartmentID
)

-- Compare actual vs potential collaborations
SELECT 
    adp.Department1,
    adp.Department2,
    
    -- Collaboration metrics
    ISNULL(COUNT(dc.ProjectName), 0) as ActiveCollaborations,
    ISNULL(SUM(dc.EmployeesCollaborating), 0) as TotalEmployeesInvolved,
    
    -- Collaboration status
    CASE 
        WHEN COUNT(dc.ProjectName) > 0 THEN 'Active Collaboration'
        ELSE 'No Current Collaboration'
    END as CollaborationStatus,
    
    -- Opportunity assessment
    CASE 
        WHEN COUNT(dc.ProjectName) = 0 THEN 'Collaboration Opportunity'
        WHEN COUNT(dc.ProjectName) BETWEEN 1 AND 2 THEN 'Limited Collaboration'
        WHEN COUNT(dc.ProjectName) >= 3 THEN 'Strong Collaboration'
    END as OpportunityAssessment

FROM AllDepartmentPairs adp
    LEFT JOIN DepartmentCollaboration dc 
        ON adp.Department1 = dc.Department1 
        AND adp.Department2 = dc.Department2

GROUP BY adp.Department1, adp.Department2

ORDER BY 
    ISNULL(COUNT(dc.ProjectName), 0) DESC,
    adp.Department1,
    adp.Department2;
```

**🎯 Business Explanation**: This collaboration matrix reveals which departments work well together and where there might be missed opportunities for cross-functional projects. It helps identify silos and supports strategic planning for more integrated project teams.

**🔧 Technical Breakdown**:
- **CROSS JOIN**: Generate all possible department combinations (Module 4, Lesson 4)
- **CTEs (Common Table Expressions)**: Break complex query into manageable parts
- **Self-referencing joins**: Compare departments within same project
- **Conditional aggregation**: ISNULL with aggregates for missing data
- **Complex WHERE conditions**: Avoid duplicate pairs with ID comparison

---

#### **3. Project Team Composition - SOLUTION**

```sql
-- ================================
-- PROJECT TEAM COMPOSITION AND SKILL ANALYSIS
-- Module References: Module 4 (Lessons 2-3 - Inner and Outer Joins)
-- ================================

SELECT 
    -- Project information
    p.ProjectName,
    p.ProjectStatus,
    p.StartDate,
    p.EndDate,
    FORMAT(p.Budget, 'C') as ProjectBudget,
    
    -- Team composition
    COUNT(DISTINCT ep.EmployeeID) as TeamSize,
    COUNT(DISTINCT e.DepartmentID) as DepartmentsInvolved,
    COUNT(DISTINCT es.SkillID) as UniqueSkills,
    
    -- Employee details
    STRING_AGG(
        e.FirstName + ' ' + e.LastName + ' (' + ep.Role + ')', 
        '; '
    ) as TeamMembers,
    
    -- Skill diversity
    STRING_AGG(DISTINCT s.SkillName, ', ') as TeamSkills,
    
    -- Department diversity
    STRING_AGG(DISTINCT d.DepartmentName, ', ') as DepartmentsRepresented,
    
    -- Experience levels
    AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) as AvgYearsExperience,
    MIN(DATEDIFF(YEAR, e.HireDate, GETDATE())) as MinYearsExperience,
    MAX(DATEDIFF(YEAR, e.HireDate, GETDATE())) as MaxYearsExperience,
    
    -- Budget per team member
    CASE 
        WHEN COUNT(DISTINCT ep.EmployeeID) > 0 
        THEN FORMAT(p.Budget / COUNT(DISTINCT ep.EmployeeID), 'C')
        ELSE 'No Team Assigned'
    END as BudgetPerTeamMember,
    
    -- Team composition assessment
    CASE 
        WHEN COUNT(DISTINCT ep.EmployeeID) = 0 THEN 'No Team Assigned - Critical'
        WHEN COUNT(DISTINCT ep.EmployeeID) < 3 THEN 'Small Team - Risk of Knowledge Gaps'
        WHEN COUNT(DISTINCT ep.EmployeeID) BETWEEN 3 AND 7 THEN 'Optimal Team Size'
        WHEN COUNT(DISTINCT ep.EmployeeID) > 7 THEN 'Large Team - Coordination Challenges'
    END as TeamSizeAssessment,
    
    -- Skill diversity assessment
    CASE 
        WHEN COUNT(DISTINCT es.SkillID) >= COUNT(DISTINCT ep.EmployeeID) 
        THEN 'High Skill Diversity'
        WHEN COUNT(DISTINCT es.SkillID) >= (COUNT(DISTINCT ep.EmployeeID) * 0.7) 
        THEN 'Good Skill Diversity'
        ELSE 'Limited Skill Diversity'
    END as SkillDiversityAssessment

FROM Projects p
    LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID  -- LEFT JOIN to include projects without teams
    LEFT JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
    LEFT JOIN Skills s ON es.SkillID = s.SkillID

WHERE p.ProjectStatus IN ('Active', 'Planning', 'On Hold')

GROUP BY 
    p.ProjectID,
    p.ProjectName,
    p.ProjectStatus,
    p.StartDate,
    p.EndDate,
    p.Budget

ORDER BY 
    CASE p.ProjectStatus
        WHEN 'Active' THEN 1
        WHEN 'Planning' THEN 2
        WHEN 'On Hold' THEN 3
    END,
    p.StartDate DESC;

-- Show employees not assigned to any projects
SELECT 
    e.FirstName + ' ' + e.LastName as UnassignedEmployee,
    e.JobTitle,
    d.DepartmentName,
    FORMAT(e.BaseSalary, 'C') as Salary,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsExperience,
    STRING_AGG(s.SkillName, ', ') as AvailableSkills
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
    LEFT JOIN Skills s ON es.SkillID = s.SkillID
WHERE e.IsActive = 1
    AND NOT EXISTS (
        SELECT 1 FROM EmployeeProjects ep 
        INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
        WHERE ep.EmployeeID = e.EmployeeID 
        AND p.ProjectStatus IN ('Active', 'Planning')
    )
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, d.DepartmentName, e.BaseSalary, e.HireDate
ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

**🎯 Business Explanation**: This analysis helps project managers optimize team composition and identify resource allocation issues. It shows which projects have adequate staffing and skills, and highlights available talent that could be assigned to projects.

**🔧 Technical Breakdown**:
- **Multiple LEFT JOINs**: Include projects without teams and employees without projects
- **STRING_AGG function**: Concatenate multiple values into single field (Module 8)
- **NOT EXISTS**: Find employees not on any projects (Module 5)
- **Complex CASE expressions**: Multi-criteria assessments
- **Aggregate window functions**: Team size and diversity calculations

**💡 Beginner Tips**:
- LEFT JOIN preserves all records from the left table
- Use NOT EXISTS for "not in any" scenarios
- STRING_AGG is great for creating readable lists in results
- Always consider what NULL values mean in your business context

---

## 📊 **PART 4 SOLUTIONS: ADVANCED FILTERING & SORTING**

### **Task 4.1: Strategic Talent Analysis - SOLUTIONS**

#### **1. Top Performer Identification - SOLUTION**

```sql
-- ================================
-- TOP PERFORMER IDENTIFICATION BY DEPARTMENT
-- Module References: Module 5 (Lessons 1-3)
-- ================================

WITH PerformanceMetrics AS (
    -- Get latest performance rating for each employee
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        DATEDIFF(MONTH, e.HireDate, GETDATE()) as TenureMonths,
        
        -- Get most recent performance rating
        (SELECT TOP 1 pm.Achievement 
         FROM PerformanceMetrics pm 
         WHERE pm.EmployeeID = e.EmployeeID 
         ORDER BY pm.ReviewDate DESC) as LatestPerformanceRating,
         
        -- Calculate salary percentile within department and level
        PERCENT_RANK() OVER (
            PARTITION BY e.DepartmentID, e.JobLevelID 
            ORDER BY e.BaseSalary
        ) as SalaryPercentile,
        
        -- Performance score calculation
        (
            (SELECT TOP 1 pm.Achievement FROM PerformanceMetrics pm 
             WHERE pm.EmployeeID = e.EmployeeID ORDER BY pm.ReviewDate DESC) * 0.4 +
            (CASE WHEN DATEDIFF(MONTH, e.HireDate, GETDATE()) >= 18 THEN 1.0 ELSE 0.0 END) * 0.3 +
            (PERCENT_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY e.BaseSalary)) * 0.3
        ) as CompositePerformanceScore
        
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
        AND EXISTS (
            SELECT 1 FROM PerformanceMetrics pm 
            WHERE pm.EmployeeID = e.EmployeeID
        )
),

TopPerformersByDept AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentName 
            ORDER BY CompositePerformanceScore DESC, BaseSalary DESC
        ) as DeptRank
    FROM PerformanceMetrics
    WHERE LatestPerformanceRating > 4.0
        AND SalaryPercentile >= 0.75  -- Top quartile salary
        AND TenureMonths >= 18        -- Minimum 18 months tenure
)

-- Top 5 performers by department
SELECT 
    DepartmentName,
    DeptRank as RankInDepartment,
    EmployeeName,
    JobTitle,
    FORMAT(BaseSalary, 'C') as Salary,
    CAST(TenureMonths / 12.0 AS DECIMAL(4,1)) as YearsExperience,
    CAST(LatestPerformanceRating AS DECIMAL(3,1)) as PerformanceRating,
    CAST(SalaryPercentile * 100 AS DECIMAL(5,1)) as SalaryPercentileInLevel,
    CAST(CompositePerformanceScore AS DECIMAL(4,3)) as OverallScore,
    
    -- Recognition recommendation
    CASE 
        WHEN CompositePerformanceScore >= 0.90 THEN 'Immediate Recognition - Stock Options/Bonus'
        WHEN CompositePerformanceScore >= 0.80 THEN 'Strong Recognition - Promotion Candidate'
        WHEN CompositePerformanceScore >= 0.70 THEN 'Good Performance - Merit Increase'
        ELSE 'Standard Recognition'
    END as RecommendedRecognition

FROM TopPerformersByDept
WHERE DeptRank <= 5  -- Top 5 per department

ORDER BY 
    DepartmentName,
    DeptRank;

-- Alternative view using OFFSET-FETCH for pagination
SELECT 
    DepartmentName,
    EmployeeName,
    JobTitle,
    FORMAT(BaseSalary, 'C') as Salary,
    LatestPerformanceRating,
    CompositePerformanceScore
FROM TopPerformersByDept
ORDER BY CompositePerformanceScore DESC
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;  -- First 20 top performers across all departments
```

**🎯 Business Explanation**: This identifies our highest-value employees who deserve recognition and retention focus. The composite scoring considers multiple factors to avoid bias from any single metric. These employees are often targets for competitors and need proactive retention strategies.

**🔧 Technical Breakdown**:
- **CTEs**: Break complex logic into manageable steps
- **PERCENT_RANK()**: Calculate salary percentiles (Module 9 advanced)
- **ROW_NUMBER()**: Rank within groups (Module 9)
- **Subqueries**: Get latest performance data
- **OFFSET-FETCH**: Modern pagination technique (Module 5, Lesson 3)
- **Complex scoring**: Weighted composite calculations

---

#### **2. Retention Risk Assessment - SOLUTION**

```sql
-- ================================
-- RETENTION RISK ASSESSMENT AND EARLY WARNING SYSTEM
-- Module References: Module 5 (Lessons 2-4)
-- ================================

WITH RetentionAnalysis AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        e.BaseSalary,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) as YearsOfService,
        
        -- Latest performance rating
        (SELECT TOP 1 pm.Achievement 
         FROM PerformanceMetrics pm 
         WHERE pm.EmployeeID = e.EmployeeID 
         ORDER BY pm.ReviewDate DESC) as LatestRating,
        
        -- Market salary comparison (assume market rate is 10% higher than current median)
        (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY e2.BaseSalary)
         FROM Employees e2 
         WHERE e2.JobTitle = e.JobTitle AND e2.IsActive = 1) * 1.1 as EstimatedMarketSalary,
        
        -- Time since last promotion (if promotion history exists)
        DATEDIFF(MONTH, 
            ISNULL((SELECT MAX(PromotionDate) FROM PromotionHistory ph 
                    WHERE ph.EmployeeID = e.EmployeeID), e.HireDate), 
            GETDATE()) as MonthsSinceLastPromotion,
        
        -- Skills market demand (count how many job postings mention their skills)
        (SELECT COUNT(DISTINCT s.SkillName) 
         FROM EmployeeSkills es 
         INNER JOIN Skills s ON es.SkillID = s.SkillID
         WHERE es.EmployeeID = e.EmployeeID 
         AND s.SkillName IN ('Cloud Architecture', 'Data Science', 'AI/ML', 'DevOps', 'Cybersecurity')) as HighDemandSkillCount,
        
        -- Calculate retention risk factors
        0 as RiskScore  -- We'll calculate this next
        
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
),

RiskScoredEmployees AS (
    SELECT *,
        -- Calculate composite risk score (higher = more likely to leave)
        (
            -- Salary gap risk (30% weight)
            CASE 
                WHEN BaseSalary < (EstimatedMarketSalary * 0.85) THEN 30  -- Significantly underpaid
                WHEN BaseSalary < (EstimatedMarketSalary * 0.95) THEN 15  -- Moderately underpaid
                ELSE 0
            END +
            
            -- High performer + no recent promotion risk (25% weight)
            CASE 
                WHEN LatestRating >= 4.0 AND MonthsSinceLastPromotion > 24 THEN 25
                WHEN LatestRating >= 3.5 AND MonthsSinceLastPromotion > 36 THEN 15
                ELSE 0
            END +
            
            -- High-demand skills risk (20% weight)
            CASE 
                WHEN HighDemandSkillCount >= 3 THEN 20
                WHEN HighDemandSkillCount >= 2 THEN 10
                ELSE 0
            END +
            
            -- Tenure risk (15% weight)
            CASE 
                WHEN YearsOfService BETWEEN 2 AND 4 THEN 15  -- Flight risk years
                WHEN YearsOfService BETWEEN 7 AND 10 THEN 10  -- Mid-career transition
                ELSE 0
            END +
            
            -- Department-specific risk (10% weight)
            CASE 
                WHEN DepartmentName IN ('Engineering', 'Data Science', 'Sales') THEN 10  -- High-turnover departments
                ELSE 0
            END
        ) as TotalRiskScore
        
    FROM RetentionAnalysis
)

-- Final retention risk report
SELECT 
    EmployeeName,
    JobTitle,
    DepartmentName,
    FORMAT(BaseSalary, 'C') as CurrentSalary,
    FORMAT(EstimatedMarketSalary, 'C') as EstimatedMarketRate,
    FORMAT(EstimatedMarketSalary - BaseSalary, 'C') as SalaryGap,
    YearsOfService,
    CAST(LatestRating AS DECIMAL(3,1)) as PerformanceRating,
    MonthsSinceLastPromotion,
    HighDemandSkillCount,
    TotalRiskScore,
    
    -- Risk categorization
    CASE 
        WHEN TotalRiskScore >= 60 THEN 'CRITICAL RISK - Immediate Action Required'
        WHEN TotalRiskScore >= 40 THEN 'HIGH RISK - Priority Retention Conversation'
        WHEN TotalRiskScore >= 25 THEN 'MODERATE RISK - Monitor Closely'
        WHEN TotalRiskScore >= 15 THEN 'LOW RISK - Standard Check-in'
        ELSE 'STABLE - No Immediate Concerns'
    END as RiskLevel,
    
    -- Recommended actions
    CASE 
        WHEN TotalRiskScore >= 60 THEN 'Counter-offer preparation, immediate manager discussion, retention bonus'
        WHEN TotalRiskScore >= 40 THEN 'Salary review, promotion discussion, career development plan'
        WHEN TotalRiskScore >= 25 THEN 'Regular check-ins, skill development opportunities'
        ELSE 'Continue standard performance management'
    END as RecommendedActions

FROM RiskScoredEmployees

WHERE TotalRiskScore > 0  -- Only show employees with some risk factors

ORDER BY TotalRiskScore DESC, LatestRating DESC;

-- Summary statistics for leadership
SELECT 
    DepartmentName,
    COUNT(*) as TotalEmployees,
    COUNT(CASE WHEN TotalRiskScore >= 40 THEN 1 END) as HighRiskEmployees,
    COUNT(CASE WHEN TotalRiskScore BETWEEN 25 AND 39 THEN 1 END) as ModerateRiskEmployees,
    CAST(
        COUNT(CASE WHEN TotalRiskScore >= 40 THEN 1 END) * 100.0 / COUNT(*)
        AS DECIMAL(5,1)
    ) as HighRiskPercentage,
    FORMAT(AVG(BaseSalary), 'C') as AvgSalary,
    FORMAT(AVG(EstimatedMarketSalary), 'C') as AvgMarketRate
FROM RiskScoredEmployees
GROUP BY DepartmentName
ORDER BY HighRiskPercentage DESC;
```

**🎯 Business Explanation**: This retention risk model helps HR and management proactively identify employees who might be considering leaving. Early identification allows for targeted retention strategies before employees become actively engaged in job searches.

**🔧 Technical Breakdown**:
- **Complex CASE expressions**: Multi-factor risk scoring
- **Nested subqueries**: Get comparative salary data
- **PERCENTILE_CONT**: Calculate market rate benchmarks
- **ISNULL with subqueries**: Handle missing promotion data
- **Composite scoring**: Weighted risk factors

**💡 Beginner Tips**:
- Break complex calculations into stages using CTEs
- Use meaningful business weights for composite scores
- Always validate risk model results with actual turnover data
- Consider both quantitative and qualitative factors

---

## 📈 **CONTINUED IN NEXT SECTION...**

*This answer key demonstrates the depth of analysis possible when integrating all Module 1-9 concepts. Each solution includes business context, technical implementation, and learning guidance to support beginner understanding while showcasing advanced SQL capabilities.*