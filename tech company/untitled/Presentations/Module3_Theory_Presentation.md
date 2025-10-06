# Module 3: Writing Basic SELECT Statements - Theory Presentation

## Slide 1: Module Overview
**Mastering Basic SELECT Statements: Foundation of SQL Querying**

### Learning Objectives
- **SELECT Statement Mastery**: Complete understanding of SELECT syntax, components, and execution order
- **Advanced Column Techniques**: Expert-level column selection, calculations, and expressions
- **DISTINCT Operations**: Comprehensive understanding of duplicate elimination and set operations
- **Aliasing Excellence**: Professional naming conventions for columns and tables
- **Conditional Logic**: Advanced CASE expressions and conditional processing
- **Performance Optimization**: Writing efficient queries with proper column selection and filtering
- **Best Practices**: Industry-standard coding conventions and query optimization techniques

### Module Structure
- **Fundamental Concepts**: Core SELECT statement components and syntax
- **Advanced Techniques**: Complex expressions, calculations, and transformations
- **Performance Considerations**: Query optimization and execution planning
- **Real-World Applications**: Practical examples and business scenarios

---

## Slide 2: SELECT Statement Architecture Deep Dive
**Understanding the Complete SELECT Statement Structure**

### Logical Query Processing Order
SQL Server processes SELECT statements in a specific logical order, different from the written order:

```sql
-- Written Order:
SELECT [DISTINCT] <column_list>
FROM <table_name>
WHERE <search_condition>
GROUP BY <group_by_list>
HAVING <having_condition>
ORDER BY <order_by_list>
OFFSET <offset_value> ROWS FETCH NEXT <fetch_value> ROWS ONLY;
```

### Logical Processing Sequence

#### **1. FROM Clause Processing**
- **Table Identification**: Resolves table names and aliases
- **Cartesian Product**: Creates initial working set from all specified tables
- **Join Operations**: Applies JOIN conditions to reduce Cartesian product
- **Virtual Table Creation**: Creates first virtual table (VT1)

#### **2. WHERE Clause Processing**
- **Row Filtering**: Applies row-level filtering conditions
- **Predicate Evaluation**: Evaluates each condition for each row
- **Boolean Logic**: Processes AND, OR, NOT operators
- **Index Utilization**: Optimizer uses indexes when beneficial

#### **3. GROUP BY Processing**
- **Grouping**: Organizes rows into groups based on specified columns
- **Aggregation Context**: Establishes context for aggregate functions
- **Group Elimination**: Removes groups not meeting criteria

#### **4. HAVING Clause Processing**
- **Group Filtering**: Filters groups (not individual rows)
- **Aggregate Conditions**: Evaluates conditions involving aggregate functions
- **Post-Grouping Filter**: Applied after GROUP BY processing

#### **5. SELECT Clause Processing**
- **Column Projection**: Determines which columns to include in result
- **Expression Evaluation**: Calculates computed columns and expressions
- **Alias Assignment**: Assigns column aliases for result set

#### **6. DISTINCT Processing**
- **Duplicate Elimination**: Removes duplicate rows from result set
- **Hash/Sort Operation**: Uses internal algorithms for duplicate detection
- **Performance Impact**: Can be expensive for large result sets

#### **7. ORDER BY Processing**
- **Result Sorting**: Sorts final result set according to specified criteria
- **Multiple Columns**: Supports primary and secondary sort orders
- **ASC/DESC**: Ascending or descending sort directions

#### **8. OFFSET/FETCH Processing**
- **Result Limiting**: Implements paging and result set limitation
- **Row Skipping**: OFFSET skips specified number of rows
- **Row Fetching**: FETCH returns specified number of rows

---

## Slide 3: Advanced Column Selection Techniques
**Professional Column Selection and Expression Building**

### Basic Column Selection Patterns

#### **Explicit Column Selection (Recommended)**
```sql
-- Best Practice: Specify only needed columns
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    BaseSalary
FROM Employees;
```

**Benefits**:
- **Performance**: Reduces I/O, memory usage, and network traffic
- **Maintainability**: Clear intent and explicit dependencies
- **Future-Proofing**: Unaffected by table structure changes
- **Security**: Prevents exposure of sensitive columns

#### **Wildcard Selection (Use Cautiously)**
```sql
-- Sometimes Appropriate: Exploratory queries, views with same structure
SELECT * FROM Employees;

-- More Controlled: Using table aliases
SELECT e.* FROM Employees e;
```

**When to Use**:
- **Development/Testing**: Initial data exploration
- **Temporary Views**: When all columns are genuinely needed
- **Dynamic SQL**: When column list varies programmatically

### Calculated Columns and Expressions

#### **Arithmetic Operations**
```sql
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BaseSalary,
    BaseSalary * 12 AS AnnualSalary,                    -- Basic calculation
    BaseSalary * 1.05 AS ProjectedSalary,               -- Percentage increase
    ROUND(BaseSalary * 0.2, 2) AS EstimatedTax,        -- Tax calculation
    BaseSalary + ISNULL(Bonus, 0) AS TotalCompensation -- Null handling
FROM Employees;
```

#### **String Operations**
```sql
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,              -- Concatenation
    UPPER(FirstName) AS FirstNameUpper,                   -- Case conversion
    LEFT(FirstName, 1) + '.' AS FirstInitial,            -- Substring extraction
    FirstName + ' (' + Department + ')' AS NameWithDept,  -- Complex concatenation
    CONCAT(FirstName, ' ', LastName) AS FullNameConcat   -- CONCAT function (handles nulls)
FROM Employees;
```

#### **Date/Time Calculations**
```sql
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,    -- Years of service
    DATEADD(YEAR, 1, HireDate) AS FirstAnniversary,          -- Date arithmetic
    YEAR(HireDate) AS HireYear,                              -- Date part extraction
    MONTH(HireDate) AS HireMonth,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 
        THEN 'Senior Employee'
        ELSE 'Junior Employee'
    END AS EmployeeLevel
FROM Employees;
```

#### **Conditional Expressions with CASE**
```sql
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BaseSalary,
    -- Simple CASE expression
    CASE 
        WHEN BaseSalary < 30000 THEN 'Entry Level'
        WHEN BaseSalary < 60000 THEN 'Mid Level'
        WHEN BaseSalary < 100000 THEN 'Senior Level'
        ELSE 'Executive Level'
    END AS SalaryGrade,
    
    -- Searched CASE with multiple conditions
    CASE 
        WHEN Department = 'Sales' AND BaseSalary > 50000 THEN 'Senior Sales'
        WHEN Department = 'Sales' THEN 'Sales Staff'
        WHEN Department = 'IT' AND BaseSalary > 70000 THEN 'Senior Developer'
        WHEN Department = 'IT' THEN 'Developer'
        ELSE 'Other'
    END AS RoleCategory,
    
    -- CASE in calculations
    BaseSalary * CASE 
        WHEN Department = 'Sales' THEN 1.1    -- 10% bonus for sales
        WHEN Department = 'IT' THEN 1.05      -- 5% bonus for IT
        ELSE 1.0                              -- No bonus for others
    END AS AdjustedSalary
FROM Employees;
```

---

## Slide 4: DISTINCT Operations - Advanced Duplicate Elimination
**Mastering Duplicate Elimination and Set Operations**

### Understanding DISTINCT Mechanics

#### **How DISTINCT Works Internally**
- **Hash Algorithm**: Creates hash table of unique values
- **Sort Algorithm**: Alternative method using sorting
- **Memory Usage**: Requires memory to store unique combinations
- **Performance Impact**: Can be expensive for large datasets

#### **Basic DISTINCT Usage**
```sql
-- Single column DISTINCT
SELECT DISTINCT Department 
FROM Employees;

-- Multiple column DISTINCT (unique combinations)
SELECT DISTINCT Department, JobTitle
FROM Employees;

-- DISTINCT with calculations
SELECT DISTINCT 
    Department,
    YEAR(HireDate) AS HireYear
FROM Employees;
```

### Advanced DISTINCT Patterns

#### **DISTINCT vs GROUP BY Performance**
```sql
-- DISTINCT approach
SELECT DISTINCT Department
FROM Employees;

-- GROUP BY approach (often faster)
SELECT Department
FROM Employees
GROUP BY Department;

-- GROUP BY with aggregates (more informative)
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    MIN(HireDate) AS EarliestHire,
    MAX(BaseSalary) AS HighestSalary
FROM Employees
GROUP BY Department;
```

#### **DISTINCT with Complex Expressions**
```sql
-- Complex DISTINCT scenarios
SELECT DISTINCT
    YEAR(HireDate) AS HireYear,
    CASE 
        WHEN BaseSalary < 50000 THEN 'Low'
        WHEN BaseSalary < 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryRange,
    Department
FROM Employees
WHERE HireDate >= '2020-01-01'
ORDER BY HireYear, SalaryRange, Department;
```

### Performance Considerations for DISTINCT

#### **Optimization Strategies**
```sql
-- Inefficient: DISTINCT on large result set
SELECT DISTINCT *
FROM LargeTable
WHERE SomeCondition = 'Value';

-- More Efficient: Filter first, then DISTINCT
SELECT DISTINCT Column1, Column2
FROM LargeTable
WHERE SomeCondition = 'Value'
    AND AnotherCondition IS NOT NULL;

-- Best: Use appropriate indexes
CREATE INDEX IX_LargeTable_Columns 
ON LargeTable (SomeCondition, Column1, Column2)
WHERE AnotherCondition IS NOT NULL;
```

---

## Slide 5: Column and Table Aliases - Professional Naming
**Creating Readable and Maintainable SQL Code**

### Column Aliases

#### **Alias Syntax Variations**
```sql
-- Multiple valid alias syntaxes
SELECT 
    FirstName AS EmployeeFirstName,        -- Standard AS syntax
    LastName EmployeeLastName,             -- Space syntax (less preferred)
    BaseSalary AS 'Monthly BaseSalary',            -- Quoted alias with spaces
    BaseSalary * 12 AS [Annual BaseSalary],        -- Bracketed alias
    HireDate AS "Hire Date"                -- Double-quoted alias
FROM Employees;
```

#### **Professional Alias Conventions**
```sql
-- Good aliasing practices
SELECT 
    e.EmployeeID AS EmpID,                 -- Meaningful abbreviation
    e.FirstName AS FirstName,              -- Clarity over brevity
    e.LastName AS LastName,
    d.DepartmentName AS Department,        -- Descriptive naming
    e.BaseSalary AS MonthlySalary,             -- Clear data meaning
    e.BaseSalary * 12 AS AnnualSalary,         -- Calculation description
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

### Table Aliases

#### **Benefits of Table Aliases**
- **Shorter Code**: Reduces typing and improves readability
- **Clarity**: Makes relationships clear in complex queries
- **Requirement**: Necessary when same table appears multiple times
- **Performance**: No performance impact (logical only)

#### **Table Alias Best Practices**
```sql
-- Professional table aliasing
SELECT 
    emp.EmployeeID,
    emp.FirstName,
    emp.LastName,
    dept.DepartmentName,
    mgr.FirstName AS ManagerFirstName,
    mgr.LastName AS ManagerLastName
FROM Employees emp                         -- Descriptive alias
INNER JOIN Departments dept ON emp.DepartmentID = dept.DepartmentID
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmployeeID;  -- Self-join clarity
```

#### **Alias Conventions**
```sql
-- Common aliasing patterns
SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    od.Quantity,
    p.ProductName
FROM Customers c                           -- First letter
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;

-- Alternative: Meaningful abbreviations
SELECT 
    cust.CustomerID,
    cust.CustomerName,
    ord.OrderID,
    ord.OrderDate
FROM Customers cust
INNER JOIN Orders ord ON cust.CustomerID = ord.CustomerID;
```

-- With DISTINCT (unique values only)
SELECT DISTINCT Department FROM Employees;

-- DISTINCT with multiple columns
SELECT DISTINCT Department, JobTitle FROM Employees;
```

**Important**: DISTINCT applies to the entire row, not individual columns

---

## Slide 5: DISTINCT Performance Considerations
**When to Use DISTINCT**

**✅ Good Uses:**
- Removing duplicates from lookup data
- Finding unique combinations of values
- Data exploration and analysis

**❌ Avoid When:**
- Working with primary key columns
- Performance is critical and duplicates are acceptable
- Better solved with proper table design

---

## Slide 6: Column Aliases
**Creating Readable Output**

```sql
-- Using AS keyword (recommended)
SELECT 
    FirstName AS First_Name,
    LastName AS Last_Name,
    BaseSalary AS Annual_Salary
FROM Employees;

-- Without AS keyword
SELECT 
    FirstName First_Name,
    LastName Last_Name
FROM Employees;
```

**Benefits**: Improved readability, custom column headers

---

## Slide 7: Table Aliases
**Simplifying Query Syntax**

```sql
-- Without alias (verbose)
SELECT Employees.FirstName, Employees.LastName
FROM Employees
WHERE Employees.Department = 'IT';

-- With alias (concise)
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.Department = 'IT';
```

**Best Practice**: Use meaningful, short aliases

---

## Slide 8: Calculated Columns
**Expression-Based Columns**

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    BaseSalary * 0.10 AS Tax_Amount,
    BaseSalary * 1.10 AS Gross_Pay,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS Years_Employed
FROM Employees;
```

**Common Calculations**: Mathematical operations, date differences, string concatenation

---

## Slide 9: String Concatenation
**Combining Text Values**

```sql
-- Using + operator
SELECT 
    FirstName + ' ' + LastName AS FullName,
    'Employee: ' + FirstName AS Greeting
FROM Employees;

-- Using CONCAT function (SQL Server 2012+)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT('Employee: ', FirstName) AS Greeting
FROM Employees;
```

---

## Slide 10: Introduction to CASE Expressions
**Conditional Logic in Queries**

**Two Forms:**
- **Simple CASE**: Compares expression to specific values
- **Searched CASE**: Uses conditional expressions

```sql
-- Simple CASE
CASE Department
    WHEN 'IT' THEN 'Technology'
    WHEN 'HR' THEN 'Human Resources'
    ELSE 'Other'
END

-- Searched CASE
CASE 
    WHEN BaseSalary > 100000 THEN 'High'
    WHEN BaseSalary > 50000 THEN 'Medium'
    ELSE 'Low'
END
```

---

## Slide 11: Simple CASE Expression
**Value-Based Conditions**

```sql
SELECT 
    FirstName,
    LastName,
    Department,
    CASE Department
        WHEN 'IT' THEN 'Information Technology'
        WHEN 'HR' THEN 'Human Resources'
        WHEN 'FIN' THEN 'Finance'
        WHEN 'MKT' THEN 'Marketing'
        ELSE 'Other Department'
    END AS DepartmentName
FROM Employees;
```

**Use When**: Comparing single column to multiple specific values

---

## Slide 12: Searched CASE Expression
**Condition-Based Logic**

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary >= 100000 THEN 'Executive'
        WHEN BaseSalary >= 75000 THEN 'Senior'
        WHEN BaseSalary >= 50000 THEN 'Mid-Level'
        WHEN BaseSalary >= 30000 THEN 'Junior'
        ELSE 'Entry Level'
    END AS SalaryBand
FROM Employees;
```

**Use When**: Complex conditions involving multiple columns or ranges

---

## Slide 13: Nested CASE Expressions
**Complex Conditional Logic**

```sql
SELECT 
    FirstName,
    LastName,
    Department,
    BaseSalary,
    CASE Department
        WHEN 'IT' THEN 
            CASE 
                WHEN BaseSalary > 90000 THEN 'IT Senior'
                ELSE 'IT Standard'
            END
        WHEN 'HR' THEN 'HR Professional'
        ELSE 'General Employee'
    END AS EmployeeCategory
FROM Employees;
```

**Use Carefully**: Can become complex and hard to maintain

---

## Slide 14: CASE with Aggregate Functions
**Conditional Aggregation**

```sql
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    COUNT(CASE WHEN BaseSalary > 75000 THEN 1 END) AS HighSalaryCount,
    AVG(CASE WHEN BaseSalary > 75000 THEN BaseSalary END) AS AvgHighSalary
FROM Employees
GROUP BY Department;
```

**Powerful Technique**: Allows selective aggregation based on conditions

---

## Slide 15: NULL Handling in CASE
**Dealing with NULL Values**

```sql
SELECT 
    FirstName,
    LastName,
    CASE 
        WHEN MiddleName IS NULL THEN FirstName + ' ' + LastName
        ELSE FirstName + ' ' + MiddleName + ' ' + LastName
    END AS FullName
FROM Employees;
```

**Remember**: CASE returns NULL if no conditions match and no ELSE clause exists

---

## Slide 16: Performance Considerations
**Optimizing SELECT Statements**

**Best Practices:**
- Select only needed columns
- Use WHERE clause to filter early
- Consider index usage
- Avoid complex calculations in WHERE clause
- Use appropriate data types

**Example:**
```sql
-- Good: Specific columns, early filtering
SELECT FirstName, LastName, BaseSalary
FROM Employees 
WHERE Department = 'IT' AND IsActive = 1;
```

---

## Slide 17: Common SELECT Patterns
**Frequently Used Techniques**

```sql
-- Top N records
SELECT TOP 10 * FROM Employees ORDER BY BaseSalary DESC;

-- Percentage of records
SELECT TOP 10 PERCENT * FROM Employees ORDER BY HireDate;

-- Conditional formatting
SELECT 
    FirstName,
    LastName,
    FORMAT(BaseSalary, 'C') AS FormattedSalary
FROM Employees;
```

---

## Slide 18: String Functions in SELECT
**Text Manipulation**

```sql
SELECT 
    UPPER(FirstName) AS UpperFirst,
    LOWER(LastName) AS LowerLast,
    LEN(FirstName) AS FirstNameLength,
    SUBSTRING(FirstName, 1, 1) AS FirstInitial,
    LTRIM(RTRIM(FirstName)) AS TrimmedName
FROM Employees;
```

**Common Functions**: UPPER, LOWER, LEN, SUBSTRING, TRIM, LEFT, RIGHT

---

## Slide 19: Date Functions in SELECT
**Date and Time Manipulation**

```sql
SELECT 
    FirstName,
    LastName,
    HireDate,
    YEAR(HireDate) AS HireYear,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,
    DATEADD(YEAR, 1, HireDate) AS FirstAnniversary
FROM Employees;
```

**Common Functions**: GETDATE, YEAR, MONTH, DAY, DATEDIFF, DATEADD

---

## Slide 20: Numeric Functions in SELECT
**Mathematical Operations**

```sql
SELECT 
    FirstName,
    LastName,
    BaseSalary,
    ROUND(BaseSalary * 1.05, 2) AS ProposedSalary,
    ABS(BaseSalary - 50000) AS SalaryDifference,
    POWER(2, 3) AS PowerExample
FROM Employees;
```

**Common Functions**: ROUND, ABS, CEILING, FLOOR, POWER, SQRT

---

## Slide 21: Data Type Conversion
**CAST and CONVERT Functions**

```sql
SELECT 
    FirstName,
    LastName,
    CAST(BaseSalary AS VARCHAR(20)) AS SalaryText,
    CONVERT(VARCHAR(10), HireDate, 101) AS USDateFormat,
    TRY_CAST(BadData AS INT) AS SafeConversion
FROM Employees;
```

**Use CAST**: ANSI standard, portable
**Use CONVERT**: SQL Server specific, more formatting options

---

## Slide 22: Query Formatting Best Practices
**Readable Query Structure**

```sql
SELECT 
    e.FirstName,
    e.LastName,
    e.Department,
    CASE 
        WHEN e.BaseSalary > 75000 THEN 'High'
        WHEN e.BaseSalary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryRange
FROM Employees e
WHERE e.IsActive = 1
    AND e.HireDate >= '2020-01-01'
ORDER BY e.LastName, e.FirstName;
```

---

## Slide 23: Common Mistakes to Avoid
**Potential Pitfalls**

- **SELECT ***: Avoid in production code
- **Missing DISTINCT**: Unexpected duplicates
- **Complex CASE**: Hard to maintain nested logic
- **NULL handling**: Forgetting NULL behavior
- **Data type issues**: Implicit conversions
- **Performance**: Not considering execution plans

---

## Slide 24: Learning Objectives Achieved
**Module 3 Outcomes**

✅ Write effective SELECT statements with multiple techniques
✅ Use DISTINCT appropriately to eliminate duplicates
✅ Create meaningful column and table aliases
✅ Implement conditional logic with CASE expressions
✅ Apply built-in functions for data manipulation
✅ Follow best practices for query performance and readability

---

## Slide 25: Next Steps
**Module 4 Preview: Querying Multiple Tables**

- Understanding relationships between tables
- INNER JOINs for related data
- OUTER JOINs for optional relationships
- CROSS JOINs and SELF JOINs
- Advanced join techniques and optimization

**Key Preparation**
- Practice SELECT statement variations
- Understand table relationships and foreign keys
- Review normalization concepts