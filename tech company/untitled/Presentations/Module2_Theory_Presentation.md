# Module 2: Introduction to T-SQL Querying - Theory Presentation

## Slide 1: Module Overview
**Comprehensive Introduction to T-SQL Querying Excellence**

### Learning Objectives
- **Deep T-SQL Understanding**: Master T-SQL as Microsoft's powerful SQL implementation with advanced features
- **Relational Theory Mastery**: Comprehensive understanding of relational database theory and set-based operations
- **Mathematical Foundations**: Solid grasp of set theory, predicate logic, and relational algebra principles
- **Query Architecture**: Understanding logical order of operations and query processing fundamentals
- **Data Type Expertise**: Complete knowledge of SQL Server data types, operators, and type conversions
- **Professional Development**: Industry best practices for T-SQL development and code quality

### Course Structure
- **Theoretical Foundation**: Mathematical and logical principles underlying SQL
- **Practical Application**: Hands-on examples and real-world scenarios
- **Performance Considerations**: Writing efficient, optimized T-SQL code
- **Industry Standards**: Professional development practices and conventions

---

## Slide 2: What is T-SQL? - Comprehensive Overview
**Transact-SQL: Microsoft's Enhanced SQL Implementation**

### Historical Context and Evolution
- **ANSI SQL Foundation**: Built upon industry-standard SQL specifications
- **Microsoft Extensions**: Enhanced with proprietary features and optimizations
- **Version Evolution**: Continuous improvement from SQL Server 6.0 to current versions
- **Industry Position**: Leading enterprise database query language

### Core Characteristics

#### **Declarative Programming Paradigm**
- **What, Not How**: Specify desired results rather than step-by-step procedures
- **Query Optimizer**: SQL Server determines optimal execution strategy
- **Set-Based Operations**: Process entire datasets rather than individual records
- **Abstraction Layer**: Hides physical storage and access method complexity

#### **Advanced Language Features**
- **Procedural Elements**: Variables, control flow, error handling
- **User-Defined Functions**: Custom reusable logic components
- **Stored Procedures**: Compiled, parameterized code blocks
- **Triggers**: Event-driven automatic code execution
- **Common Table Expressions**: Temporary result sets for complex queries
- **Window Functions**: Advanced analytics and ranking operations

#### **Integration Capabilities**
- **CLR Integration**: Execute .NET code within SQL Server
- **XML Support**: Native XML data type and manipulation functions
- **JSON Functionality**: Modern semi-structured data handling
- **Full-Text Search**: Advanced text search and indexing
- **Spatial Data**: Geographic and geometric data processing

---

## Slide 3: T-SQL vs Other Programming Languages
**Understanding T-SQL's Unique Characteristics**

### Declarative vs Imperative Programming

#### **Declarative Nature of T-SQL**
```sql
-- T-SQL: What you want (declarative)
SELECT CompanyName, TotalOrders
FROM Customers c
JOIN (SELECT CustomerID, COUNT(*) as TotalOrders 
      FROM Orders GROUP BY CustomerID) o
  ON c.CustomerID = o.CustomerID
WHERE TotalOrders > 10;
```

#### **Equivalent Imperative Approach (Pseudocode)**
```
// Imperative: How to get it (step-by-step)
CustomerList = []
For each customer in Customers:
    orderCount = 0
    For each order in Orders:
        if order.CustomerID == customer.CustomerID:
            orderCount++
    if orderCount > 10:
        CustomerList.add(customer.Name, orderCount)
return CustomerList
```

### Set-Based vs Row-by-Row Processing

#### **Set-Based Thinking (Efficient)**
- **Operates on entire result sets**: Single operations on multiple rows
- **Leverages query optimizer**: Automatic optimization of execution plans
- **Parallel processing capable**: Can utilize multiple CPU cores
- **Minimizes network traffic**: Fewer round trips between client and server

#### **Row-by-Row Processing (Inefficient - Avoid)**
```sql
-- AVOID: Cursor-based row-by-row processing
DECLARE customer_cursor CURSOR FOR
    SELECT CustomerID FROM Customers;
DECLARE @CustomerID int;
OPEN customer_cursor;
FETCH NEXT FROM customer_cursor INTO @CustomerID;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Process each customer individually
    -- Much slower than set-based operations
    FETCH NEXT FROM customer_cursor INTO @CustomerID;
END
CLOSE customer_cursor;
DEALLOCATE customer_cursor;
```

### T-SQL Advantages
- **Query Optimization**: Automatic optimization by SQL Server
- **Standardization**: Industry-standard SQL compliance
- **Integration**: Deep integration with SQL Server ecosystem
- **Performance**: Optimized for data-intensive operations
- **Scalability**: Handles large datasets efficiently

---

## Slide 4: Set Theory Mathematical Foundation
**Understanding SQL Through Mathematical Set Operations**

### Fundamental Set Concepts

#### **Set Definition and Properties**
- **Mathematical Set**: Well-defined collection of distinct objects
- **Element Membership**: Objects either belong to set or don't (binary)
- **Cardinality**: Number of elements in a set
- **Empty Set**: Set containing no elements (∅)
- **Universal Set**: Set containing all possible elements in context

#### **Set Operations in SQL Context**

##### **Union (∪) - UNION Operator**
```sql
-- Mathematical: A ∪ B = {x | x ∈ A or x ∈ B}
-- SQL Implementation:
SELECT CustomerID, CompanyName FROM Customers_USA
UNION
SELECT CustomerID, CompanyName FROM Customers_Canada;

-- Result: All customers from both USA and Canada (no duplicates)
```

**Properties**:
- **Commutativity**: A ∪ B = B ∪ A
- **Associativity**: (A ∪ B) ∪ C = A ∪ (B ∪ C)
- **Idempotency**: A ∪ A = A
- **Duplicate Elimination**: Automatically removes duplicates

##### **Intersection (∩) - INTERSECT Operator**
```sql
-- Mathematical: A ∩ B = {x | x ∈ A and x ∈ B}
-- SQL Implementation:
SELECT ProductID FROM Orders_Q1
INTERSECT
SELECT ProductID FROM Orders_Q2;

-- Result: Products ordered in both Q1 and Q2
```

##### **Difference (−) - EXCEPT Operator**
```sql
-- Mathematical: A − B = {x | x ∈ A and x ∉ B}
-- SQL Implementation:
SELECT CustomerID FROM All_Customers
EXCEPT
SELECT CustomerID FROM Active_Customers;

-- Result: Inactive customers (all customers minus active ones)
```

##### **Cartesian Product (×) - CROSS JOIN**
```sql
-- Mathematical: A × B = {(a,b) | a ∈ A and b ∈ B}
-- SQL Implementation:
SELECT Colors.ColorName, Sizes.SizeName
FROM Colors CROSS JOIN Sizes;

-- Result Size: |A × B| = |A| × |B|
-- If Colors has 5 rows and Sizes has 3 rows, result has 15 rows
```

### Relational Algebra Operations

#### **Selection (σ) - WHERE Clause**
```sql
-- Mathematical: σ(condition)(R)
-- Selects tuples that satisfy the condition
SELECT * FROM Employees
WHERE d.DepartmentName = 'Sales' AND BaseSalary > 50000;

-- Result: Subset of employees meeting the criteria
```

#### **Projection (π) - SELECT Clause**
```sql
-- Mathematical: π(attribute_list)(R)
-- Projects specified attributes from relation
SELECT EmployeeID, FirstName, LastName
FROM Employees e;

-- Result: New relation with only specified columns
```

---

## Slide 5: Relational Model Deep Dive
**Dr. E.F. Codd's Revolutionary Database Model**

### Historical Foundation
- **Dr. Edgar F. Codd (1970)**: "A Relational Model of Data for Large Shared Data Banks"
- **Mathematical Basis**: Founded on set theory and predicate logic
- **Industry Impact**: Became foundation for modern database systems
- **Normalization Theory**: Systematic approach to database design

### Fundamental Principles

#### **Information Principle**
- **All Information as Relations**: Every piece of data stored in table format
- **No Pointers**: No physical pointers or links between data
- **Logical Relationships**: Relationships expressed through data values
- **Value-Based Access**: Data accessed by content, not physical location

#### **Guaranteed Access Rule**
- **Systematic Access**: Every data value accessible by table name, primary key, and column name
- **No Exceptions**: No data hidden in special formats or structures
- **Consistent Interface**: Uniform access method for all data
- **Location Independence**: Physical storage location irrelevant

### Relational Structure Components

#### **Relations (Tables)**
```sql
-- Example relation structure
CREATE TABLE Employees (
    EmployeeID int PRIMARY KEY,      -- Unique identifier
    FirstName nvarchar(50) NOT NULL, -- Required attribute
    LastName nvarchar(50) NOT NULL,  -- Required attribute
    DepartmentID int,                -- Foreign key reference
    BaseSalary decimal(10,2),            -- Optional attribute
    HireDate date DEFAULT GETDATE()  -- Default value
);
```

**Characteristics**:
- **Degree**: Number of attributes (columns) = 5
- **Cardinality**: Number of tuples (rows) = variable
- **Domain**: Each attribute has defined data type and constraints
- **No Duplicate Rows**: Primary key ensures uniqueness

#### **Attributes (Columns)**
- **Atomic Values**: Each cell contains single, indivisible value
- **Data Type Domains**: Specific set of allowable values
- **Null Handling**: Three-valued logic (True, False, Unknown)
- **Ordering Independence**: No inherent column order significance

#### **Tuples (Rows)**
- **Uniqueness Requirement**: No identical rows permitted
- **Ordering Independence**: No inherent row order
- **Complete Information**: Each row represents complete entity instance
- **Referential Integrity**: Foreign key values must reference existing data

### Keys and Integrity Constraints

#### **Primary Keys**
```sql
-- Single column primary key
CREATE TABLE Customers (
    CustomerID int IDENTITY(1,1) PRIMARY KEY,
    CompanyName nvarchar(100) NOT NULL
);

-- Composite primary key
CREATE TABLE OrderDetails (
    OrderID int,
    ProductID int,
    Quantity int,
    PRIMARY KEY (OrderID, ProductID)
);
```

#### **Foreign Keys**
```sql
-- Foreign key with referential integrity
CREATE TABLE Orders (
    OrderID int PRIMARY KEY,
    CustomerID int,
    OrderDate date,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

#### **Candidate Keys and Unique Constraints**
```sql
-- Multiple candidate keys
CREATE TABLE Employees (
    EmployeeID int PRIMARY KEY,         -- Primary key
    SSN char(11) UNIQUE NOT NULL,       -- Candidate key
    WorkEmail nvarchar(100) UNIQUE NOT NULL, -- Candidate key
    EmployeeNumber char(10) UNIQUE NOT NULL -- Candidate key
);
```

- **Relation**: Table with rows and columns
- **Tuple**: Single row in a table
- **Attribute**: Column in a table
- **Domain**: Set of valid values for an attribute
- **Primary Key**: Unique identifier for each row
- **Foreign Key**: Reference to primary key in another table

---

## Slide 6: Understanding Predicates
**Predicate Logic**

- **Predicate**: Expression that evaluates to TRUE, FALSE, or UNKNOWN
- **Three-Valued Logic**: TRUE, FALSE, NULL (UNKNOWN)
- **Logical Operators**: AND, OR, NOT
- **Comparison Operators**: =, <>, <, >, <=, >=
- **Pattern Matching**: LIKE, CONTAINS, FREETEXT

---

## Slide 7: NULL Values and Three-Valued Logic
**Handling NULLs**

- **NULL**: Represents missing or unknown data
- **NOT**: Value is not NULL
- **Comparisons with NULL**: Always return UNKNOWN
- **AND Logic**: TRUE AND UNKNOWN = UNKNOWN
- **OR Logic**: TRUE OR UNKNOWN = TRUE
- **WHERE Clause**: Only TRUE predicates return rows

---

## Slide 8: Basic T-SQL Syntax
**SELECT Statement Structure**

```sql
SELECT column_list
FROM table_name
WHERE condition
GROUP BY grouping_columns
HAVING group_condition
ORDER BY sort_columns;
```

- Each clause serves a specific purpose
- Clauses must appear in specific order
- Not all clauses are required

---

## Slide 9: Logical Order of Operations
**Processing Order (Conceptual)**

1. **FROM**: Identify source tables
2. **WHERE**: Filter rows
3. **GROUP BY**: Group rows
4. **HAVING**: Filter groups
5. **SELECT**: Choose columns
6. **ORDER BY**: Sort results

Note: Physical execution may differ from logical order

---

## Slide 10: FROM Clause
**Table Sources**

- **Tables**: Base tables storing data
- **Views**: Virtual tables based on queries
- **Table-Valued Functions**: Functions returning table results
- **Derived Tables**: Subqueries in FROM clause
- **Common Table Expressions (CTEs)**: Named temporary result sets

---

## Slide 11: WHERE Clause
**Row Filtering**

- Applied to individual rows before grouping
- Uses predicate logic (TRUE/FALSE/UNKNOWN)
- Supports multiple conditions with AND/OR
- Can reference any column from FROM clause
- Cannot reference column aliases from SELECT

Example:
```sql
WHERE e.BaseSalary > 50000 AND d.DepartmentName = 'Engineering'
```

---

## Slide 12: SELECT Clause
**Column Selection**

- Determines which columns appear in results
- Can include calculated expressions
- Supports column aliases
- DISTINCT eliminates duplicate rows
- TOP limits number of rows returned

Example:
```sql
SELECT FirstName + ' ' + LastName AS full_name,
       e.BaseSalary * 1.1 AS projected_salary
```

---

## Slide 13: GROUP BY Clause
**Data Grouping**

- Groups rows sharing common values
- Required when using aggregate functions with non-aggregated columns
- Creates one result row per group
- All non-aggregate SELECT columns must be in GROUP BY
- Enables summary reporting

Example:
```sql
GROUP BY d.DepartmentName, job_title
```

---

## Slide 14: HAVING Clause
**Group Filtering**

- Filters groups after GROUP BY is applied
- Uses aggregate functions in conditions
- Applied after grouping, before SELECT
- Cannot reference individual row data
- Similar to WHERE but for groups

Example:
```sql
HAVING COUNT(*) > 5 AND AVG(e.BaseSalary) > 60000
```

---

## Slide 15: ORDER BY Clause
**Result Sorting**

- Controls order of result rows
- Can reference SELECT list columns or aliases
- Supports multiple sort columns
- ASC (ascending) is default, DESC for descending
- Applied last in logical processing order

Example:
```sql
ORDER BY e.BaseSalary DESC, e.LastName ASC
```

---

## Slide 16: Data Types Overview
**Common T-SQL Data Types**

- **Numeric**: INT, BIGINT, DECIMAL, FLOAT
- **Character**: CHAR, VARCHAR, NCHAR, NVARCHAR
- **Date/Time**: DATE, TIME, DATETIME, DATETIME2
- **Binary**: BINARY, VARBINARY, IMAGE
- **Other**: BIT, UNIQUEIDENTIFIER, XML, JSON

---

## Slide 17: Operators and Expressions
**Arithmetic Operators**
- +, -, *, /, % (modulo)

**Comparison Operators**
- =, <>, !=, <, >, <=, >=

**Logical Operators**
- AND, OR, NOT, IN, BETWEEN, LIKE, IS NULL

**String Operators**
- + (concatenation), LIKE (pattern matching)

---

## Slide 18: Common Functions
**Built-in Functions**

**String Functions**: LEN, SUBSTRING, UPPER, LOWER, TRIM
**Date Functions**: GETDATE, DATEADD, DATEDIFF, YEAR, MONTH
**Math Functions**: ABS, ROUND, CEILING, FLOOR, POWER
**Conversion**: CAST, CONVERT, TRY_CAST, TRY_CONVERT
**Aggregate**: COUNT, SUM, AVG, MIN, MAX

---

## Slide 19: Query Development Best Practices
**Writing Effective Queries**

- Use meaningful table and column aliases
- Format queries for readability
- Comment complex logic
- Test with small datasets first
- Consider performance implications
- Handle NULL values explicitly
- Use appropriate data types

---

## Slide 20: Common Query Patterns
**Typical Query Scenarios**

- **Basic Selection**: SELECT * FROM table
- **Filtered Results**: WHERE conditions
- **Calculated Columns**: Expressions in SELECT
- **Grouped Data**: GROUP BY with aggregates
- **Sorted Results**: ORDER BY columns
- **Top N Queries**: TOP or OFFSET/FETCH

---

## Slide 21: Error Handling
**Common T-SQL Errors**

- **Syntax Errors**: Invalid T-SQL syntax
- **Runtime Errors**: Division by zero, type conversion
- **Logic Errors**: Incorrect results due to flawed logic
- **Performance Issues**: Slow query execution
- **Data Quality Issues**: Unexpected NULL values

---

## Slide 22: Query Optimization Basics
**Performance Considerations**

- Use indexes effectively
- Limit result sets appropriately
- Avoid unnecessary columns in SELECT
- Use WHERE instead of HAVING when possible
- Consider query execution plans
- Test with realistic data volumes

---

## Slide 23: T-SQL Standards and Conventions
**Coding Standards**

- Use consistent naming conventions
- Capitalize T-SQL keywords
- Indent nested statements
- Use descriptive aliases
- Comment business logic
- Follow team coding guidelines

---

## Slide 24: Learning Objectives Achieved
**Module 2 Outcomes**

✅ Understand T-SQL language fundamentals
✅ Apply set theory concepts to database queries
✅ Use predicate logic effectively
✅ Write basic SELECT statements
✅ Understand logical order of operations
✅ Handle NULL values appropriately

---

## Slide 25: Next Steps
**Module 3 Preview: Writing Basic SELECT Statements**

- Advanced SELECT statement techniques
- Using DISTINCT to eliminate duplicates
- Creating column and table aliases
- Writing CASE expressions
- Practical query development exercises

**Key Preparation**
- Practice basic SELECT syntax
- Review set theory concepts
- Understand predicate logic principles