# Module 5: Sorting and Filtering Data - Enhanced Theory Presentation

## Slide 1: Module Overview
**Advanced Sorting and Filtering: Mastering Data Retrieval and Presentation**

### Learning Objectives
- **Advanced Sorting Mastery**: Complete understanding of ORDER BY clause, collation sequences, and performance implications
- **Complex Filtering Expertise**: Advanced WHERE clause techniques, predicate logic, and optimization strategies
- **Result Set Management**: Professional techniques for limiting, paging, and controlling query results
- **NULL Value Handling**: Comprehensive understanding of three-valued logic and NULL processing
- **Performance Optimization**: Index strategies and query tuning for efficient sorting and filtering
- **Search Patterns**: Advanced pattern matching with LIKE, regular expressions, and full-text search

### Module Structure
- **Sorting Theory**: Mathematical foundations of ordering and collation
- **Filtering Logic**: Boolean algebra and predicate evaluation
- **Performance Engineering**: Index design and query optimization
- **Practical Applications**: Real-world scenarios and business use cases

---

## Slide 2: ORDER BY Deep Architecture
**Understanding Sort Operations and Collation Sequences**

### Sort Operation Internals

#### **SQL Server Sort Algorithms**

##### **In-Memory Sorting**
- **Quick Sort**: Used for small to medium datasets that fit in memory
- **Heap Sort**: Alternative algorithm for memory-constrained scenarios
- **Memory Requirements**: Based on estimated row count and row size
- **Sort Memory Configuration**: Controlled by memory grants and server memory settings

##### **External Sorting (Disk-Based)**
- **Merge Sort**: Used when dataset exceeds available memory
- **Temporary Storage**: Uses tempdb for intermediate sort runs
- **I/O Intensive**: Significant disk I/O overhead
- **Performance Impact**: Much slower than in-memory sorting

#### **Collation and Sort Order**

##### **Collation Concepts**
```sql
-- View current database collation
SELECT DATABASEPROPERTYEX('YourDatabase', 'Collation') AS DatabaseCollation;

-- Different collation behaviors
SELECT 'Apple' AS Value UNION SELECT 'apple'
ORDER BY Value COLLATE SQL_Latin1_General_CP1_CS_AS; -- Case-sensitive

SELECT 'Apple' AS Value UNION SELECT 'apple'  
ORDER BY Value COLLATE SQL_Latin1_General_CP1_CI_AS; -- Case-insensitive
```

##### **Collation Elements**
- **Case Sensitivity**: CS (case-sensitive) vs CI (case-insensitive)
- **Accent Sensitivity**: AS (accent-sensitive) vs AI (accent-insensitive)
- **Kana Sensitivity**: KS vs KI (Japanese character types)
- **Width Sensitivity**: WS vs WI (single-byte vs double-byte characters)

### Advanced ORDER BY Techniques

#### **Multi-Level Sorting**
```sql
-- Complex multi-level sorting with business logic
SELECT 
    e.EmployeeID,
    e.LastName + ', ' + e.FirstName AS FullName,
    e.DepartmentName,
    e.JobTitle,
    e.BaseSalary,
    e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY 
    -- Primary: d.DepartmentName (alphabetical)
    e.DepartmentName,
    -- Secondary: Job level (custom order using CASE)
    CASE e.JobTitle
        WHEN 'CEO' THEN 1
        WHEN 'Vice President' THEN 2
        WHEN 'Director' THEN 3
        WHEN 'Manager' THEN 4
        WHEN 'Senior Analyst' THEN 5
        WHEN 'Analyst' THEN 6
        ELSE 7
    END,
    -- Tertiary: e.BaseSalary (highest first within same job level)
    e.BaseSalary DESC,
    -- Quaternary: Hire date (seniority within same e.BaseSalary)
    e.HireDate ASC,
    -- Final: Last name for consistent ordering
    e.LastName;
```

#### **Expression-Based Sorting**
```sql
-- Sort by calculated expressions
SELECT 
    ProductID,
    ProductName,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    -- Sort by inventory status priority
    CASE 
        WHEN UnitsInStock = 0 THEN 'Out of Stock'
        WHEN UnitsInStock <= ReorderLevel THEN 'Low Stock'
        WHEN UnitsInStock > ReorderLevel * 2 THEN 'Overstocked'
        ELSE 'Normal Stock'
    END AS StockIsActive
FROM Products
ORDER BY 
    -- Critical items first
    CASE 
        WHEN UnitsInStock = 0 THEN 1  -- Out of stock (highest priority)
        WHEN UnitsInStock <= ReorderLevel THEN 2  -- Low stock
        WHEN UnitsInStock > ReorderLevel * 2 THEN 4  -- Overstocked
        ELSE 3  -- Normal stock
    END,
    -- Within same status, sort by product name
    ProductName;
```

#### **NULL Handling in Sorting**
```sql
-- Explicit NULL handling
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    MiddleName,
    e.BaseSalary
FROM Employees e
ORDER BY 
    -- NULLs last for ascending, first for descending
    CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END,
    MiddleName,
    e.LastName;

-- Using ISNULL for custom NULL ordering
SELECT 
    CustomerID,
    CompanyName,
    LastOrderDate
FROM Customers
ORDER BY 
    ISNULL(LastOrderDate, '1900-01-01') DESC; -- Treat NULL as very old date
```

---

## Slide 3: WHERE Clause Mastery
**Advanced Filtering and Predicate Logic**

### Boolean Logic and Predicate Evaluation

#### **Three-Valued Logic (TRUE, FALSE, UNKNOWN)**
```sql
-- Understanding NULL behavior in WHERE clauses
SELECT 'Result when NULL = NULL: ' AS Description,
CASE WHEN NULL = NULL THEN 'TRUE' 
     WHEN NOT (NULL = NULL) THEN 'FALSE' 
     ELSE 'UNKNOWN' END AS Result;

-- NULL comparisons always return UNKNOWN
SELECT 'NULL Comparison Results:' AS Test;
SELECT 'NULL = NULL' AS Comparison, NULL = NULL AS Result;
SELECT 'NULL <> NULL' AS Comparison, NULL <> NULL AS Result;
SELECT 'NULL > 5' AS Comparison, NULL > 5 AS Result;
```

#### **Complex Boolean Expressions**
```sql
-- Complex predicate with proper precedence
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentName,
    e.JobTitle,
    e.BaseSalary,
    e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    -- Parentheses for explicit precedence
    (e.d.DepartmentName IN ('Sales', 'Marketing', 'Customer Service')
     AND e.BaseSalary BETWEEN 40000 AND 80000)
    OR 
    (d.DepartmentName = 'Engineering' 
     AND e.JobTitle LIKE '%Senior%'
     AND e.HireDate >= '2020-01-01')
    OR
    (e.JobTitle IN ('Manager', 'Director', 'Vice President')
     AND e.BaseSalary > 75000);
```

### Advanced Filtering Techniques

#### **Range Filtering with BETWEEN**
```sql
-- BETWEEN is inclusive on both ends
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount
FROM Orders
WHERE 
    -- Date range filtering
    OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    AND
    -- Numeric range filtering
    TotalAmount BETWEEN 1000.00 AND 5000.00
ORDER BY OrderDate, TotalAmount;

-- Equivalent to:
-- OrderDate >= '2023-01-01' AND OrderDate <= '2023-12-31'
-- TotalAmount >= 1000.00 AND TotalAmount <= 5000.00
```

#### **List Filtering with IN**
```sql
-- IN clause for multiple discrete values
SELECT 
    ProductID,
    ProductName,
    CategoryName,
    SupplierName,
    e.BaseSalary
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE 
    c.CategoryName IN ('Beverages', 'Dairy Products', 'Seafood')
    AND
    s.CountryID IN ('USA', 'Canada', 'Mexico')
    AND
    p.Discontinued = 0;

-- Subquery with IN for dynamic lists
SELECT 
    CustomerID,
    CompanyName,
    Country
FROM Customers
WHERE Country IN (
    SELECT DISTINCT Country 
    FROM Suppliers 
    WHERE Country IS NOT NULL
);
```

#### **Pattern Matching with LIKE**
```sql
-- Advanced LIKE patterns
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    WorkEmail
FROM Employees e
WHERE 
    -- Starts with pattern
    e.LastName LIKE 'Sm%'
    OR
    -- Contains pattern
    e.JobTitle LIKE '%Manager%'
    OR
    -- Single character wildcard
    e.FirstName LIKE 'J_n'  -- Jon, Jan, Jin, etc.
    OR
    -- Character range
    e.LastName LIKE '[A-F]%'  -- Starts with A through F
    OR
    -- Character exclusion
    WorkEmail LIKE '%[^0-9]@company.com'  -- No digits before @
ORDER BY e.LastName, e.FirstName;
```

#### **NULL Handling in WHERE Clauses**
```sql
-- Proper NULL checking
SELECT 
    CustomerID,
    CompanyName,
    Phone,
    Fax,
    WorkEmail
FROM Customers
WHERE 
    -- Explicit NULL checks
    Phone IS NOT NULL
    AND Fax IS NULL  -- Customers without fax
    AND WorkEmail IS NOT NULL
    AND WorkEmail <> ''  -- Not empty string either
    
    -- ISNULL for default values in comparisons
    AND ISNULL(Region, 'Unknown') <> 'Unknown';
```

---

## Slide 4: Result Set Limiting and Paging
**Professional Data Pagination and Result Management**

### TOP Clause Variations

#### **Basic TOP Usage**
```sql
-- Fixed number of rows
SELECT TOP 10
    ProductID,
    ProductName,
    e.BaseSalary,
    UnitsInStock
FROM Products
ORDER BY e.BaseSalary DESC;

-- Percentage of rows
SELECT TOP 25 PERCENT
    CustomerID,
    CompanyName,
    TotalOrders
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS TotalOrders
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
) AS CustomerStats
ORDER BY TotalOrders DESC;
```

#### **TOP with TIES**
```sql
-- Include tied values
SELECT TOP 5 WITH TIES
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- This might return more than 5 rows if multiple employees
-- have the same e.BaseSalary as the 5th highest e.BaseSalary
```

### OFFSET-FETCH: Modern Paging Solution

#### **Basic Paging Implementation**
```sql
-- Page 1 (first 20 records)
SELECT 
    CustomerID,
    CompanyName,
    Country,
    TotalOrders
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        c.CountryID,
        COUNT(o.OrderID) AS TotalOrders,
        ROW_NUMBER() OVER (ORDER BY COUNT(o.OrderID) DESC, c.CustomerName) AS RowNum
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName, c.CountryID
) AS CustomerStats
ORDER BY RowNum
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;

-- Page 2 (records 21-40)
-- Change OFFSET to 20

-- Page 3 (records 41-60)  
-- Change OFFSET to 40
```

#### **Dynamic Paging Function**
```sql
-- Parameterized paging approach
DECLARE @PageNumber int = 3;
DECLARE @PageSize int = 20;
DECLARE @SkipRows int = (@PageNumber - 1) * @PageSize;

SELECT 
    ProductID,
    ProductName,
    CategoryName,
    e.BaseSalary,
    UnitsInStock
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0
ORDER BY p.ProductName
OFFSET @SkipRows ROWS 
FETCH NEXT @PageSize ROWS ONLY;

-- Also calculate total pages for UI
SELECT 
    COUNT(*) AS TotalRecords,
    CEILING(CAST(COUNT(*) AS FLOAT) / @PageSize) AS TotalPages
FROM Products
WHERE Discontinued = 0;
```

### Performance Considerations for Paging

#### **Index Strategy for Efficient Paging**
```sql
-- Create covering index for paging queries
CREATE NONCLUSTERED INDEX IX_Products_Paging
ON Products (Discontinued, ProductName)
INCLUDE (ProductID, CategoryID, e.BaseSalary, UnitsInStock);

-- This index supports:
-- 1. WHERE clause filtering on Discontinued
-- 2. ORDER BY on ProductName
-- 3. All SELECT columns in INCLUDE clause
```

#### **Cursor-Based Paging (Alternative)**
```sql
-- More efficient for deep paging using cursor/key-based approach
DECLARE @LastProductName nvarchar(40) = 'Previous Page Last Product';

SELECT TOP 20
    ProductID,
    ProductName,
    CategoryName,
    e.BaseSalary
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.Discontinued = 0
    AND p.ProductName > @LastProductName  -- Cursor condition
ORDER BY p.ProductName;
```

---

## Slide 5: Advanced Search and Pattern Matching
**Professional Search Implementation Techniques**

### Full-Text Search Capabilities

#### **Basic Full-Text Search Setup**
```sql
-- Enable full-text indexing (requires appropriate setup)
-- CREATE FULLTEXT CATALOG ProductCatalog AS DEFAULT;

-- CREATE FULLTEXT INDEX ON Products(ProductName, Description)
-- KEY INDEX PK_Products;

-- Full-text search queries
SELECT 
    ProductID,
    ProductName,
    Description,
    CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE CONTAINS(p.ProductName, '"chocolate" OR "vanilla"')
   OR CONTAINS(p.Description, 'FORMSOF(INFLECTIONAL, "sweet")')
ORDER BY KEY_TBL.RANK DESC;
```

#### **Advanced Pattern Matching**
```sql
-- Complex pattern matching scenarios
SELECT 
    CustomerID,
    CompanyName,
    Phone,
    WorkEmail
FROM Customers
WHERE 
    -- Phone number patterns (various formats)
    (Phone LIKE '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
     OR Phone LIKE '[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9][0-9]'
     OR Phone LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
    AND
    -- WorkEmail validation pattern
    WorkEmail LIKE '%_@_%.__%'
    AND WorkEmail NOT LIKE '%..%'  -- No consecutive dots
    AND WorkEmail NOT LIKE '.%'    -- Doesn't start with dot
    AND WorkEmail NOT LIKE '%.'    -- Doesn't end with dot
ORDER BY CompanyName;
```

### Case-Insensitive and Accent-Insensitive Searches

#### **Collation-Based Searching**
```sql
-- Case-insensitive search regardless of column collation
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle
FROM Employees e
WHERE 
    e.FirstName COLLATE SQL_Latin1_General_CP1_CI_AS = 'john'
    OR e.LastName COLLATE SQL_Latin1_General_CP1_CI_AS LIKE 'SMITH%';

-- Accent-insensitive search
SELECT 
    CustomerID,
    CompanyName,
    City
FROM Customers
WHERE 
    City COLLATE SQL_Latin1_General_CP1_CI_AI = 'montreal'  -- Matches Montréal
ORDER BY CompanyName;
```

#### **UPPER/LOWER Function Approach**
```sql
-- Alternative approach using UPPER function
SELECT 
    ProductID,
    ProductName,
    CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE 
    UPPER(p.ProductName) LIKE UPPER('%ChOcOlAtE%')
    OR UPPER(c.CategoryName) = UPPER('Dairy Products');
```

### Performance Optimization for Search Operations

#### **Search Index Strategies**
```sql
-- Computed column for normalized search
ALTER TABLE Customers 
ADD CompanyNameUpper AS UPPER(CompanyName) PERSISTED;

CREATE INDEX IX_Customers_UpperName 
ON Customers (CompanyNameUpper);

-- Use the computed column for fast case-insensitive searches
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CompanyNameUpper LIKE UPPER('%SMITH%');
```

#### **Search Query Optimization**
```sql
-- Optimized search query with proper indexing
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.DepartmentName,
    e.HireDate
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    -- Most selective filter first
    e.d.DepartmentName = 'Sales'
    AND e.HireDate >= '2020-01-01'
    AND (
        e.LastName LIKE 'S%'  -- SARGable (Search ARGument able)
        OR e.FirstName LIKE 'J%'
    )
ORDER BY e.LastName, e.FirstName;

-- Supporting index
CREATE INDEX IX_Employees_Search 
ON Employees (Department, e.HireDate, e.LastName, e.FirstName)
INCLUDE (e.EmployeeID, e.JobTitle);
```

---

## Slide 6: Performance Optimization for Sorting and Filtering
**Advanced Query Tuning and Index Strategies**

### Index Design for WHERE Clauses

#### **Covering Index Strategy**
```sql
-- Query pattern analysis
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    AND o.TotalAmount > 1000
    AND c.CountryID = 'USA'
ORDER BY o.OrderDate DESC;

-- Optimal covering indexes
CREATE INDEX IX_Orders_DateAmount_Covering
ON Orders (OrderDate, TotalAmount)
INCLUDE (OrderID, CustomerID);

CREATE INDEX IX_Customers_Country_Covering  
ON Customers (Country)
INCLUDE (CustomerID, CompanyName);
```

#### **Composite Index Column Ordering**
```sql
-- Index column order matters for query performance
-- Rule: Most selective columns first, then ORDER BY columns

-- Good index design (supports WHERE and ORDER BY)
CREATE INDEX IX_Products_CategoryDiscontinued_Name
ON Products (CategoryID, Discontinued, ProductName);

-- This index efficiently supports:
SELECT ProductID, ProductName, e.BaseSalary
FROM Products 
WHERE CategoryID = 1 AND Discontinued = 0
ORDER BY ProductName;
```

### Sort Performance Optimization

#### **Avoiding Sorts with Proper Indexing**
```sql
-- Query that requires sorting
SELECT 
    CustomerID,
    CompanyName,
    TotalOrders
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS TotalOrders
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
) AS CustomerStats
ORDER BY TotalOrders DESC, CompanyName;

-- Index to eliminate sort operation
CREATE INDEX IX_Orders_CustomerID 
ON Orders (CustomerID);

-- The GROUP BY can use a hash aggregate, and if we create an index on the result:
CREATE INDEX IX_CustomerStats_TotalOrders 
ON CustomerStats (TotalOrders DESC, CompanyName);
-- (This would be on a materialized view or temp table)
```

#### **Memory Configuration for Sort Operations**
```sql
-- Monitor sort operations in query plans
SELECT 
    query_plan,
    execution_count,
    total_worker_time,
    total_elapsed_time
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE CAST(query_plan AS VARCHAR(MAX)) LIKE '%Sort%'
ORDER BY total_worker_time DESC;

-- Check for sort warnings (spills to tempdb)
-- Look for Sort Warnings in execution plans
-- Consider increasing memory grants or adding better indexes
```

---

## Slide 7: Best Practices and Common Pitfalls
**Professional Query Development Guidelines**

### WHERE Clause Best Practices

#### **SARGable Predicates (Search ARGument able)**
```sql
-- SARGable (Good - can use indexes efficiently)
WHERE e.LastName LIKE 'Smith%'        -- Index seek possible
WHERE OrderDate >= '2023-01-01'     -- Index seek possible
WHERE CategoryID = 1                 -- Index seek possible
WHERE Price BETWEEN 10 AND 50       -- Index seek possible

-- Non-SARGable (Bad - forces index scan or table scan)
WHERE UPPER(e.LastName) = 'SMITH'      -- Function on column
WHERE OrderDate + 30 > GETDATE()    -- Arithmetic on column
WHERE e.LastName LIKE '%Smith%'       -- Leading wildcard
WHERE ISNULL(Price, 0) > 10         -- Function on column
```

#### **Avoiding Common Performance Killers**
```sql
-- BAD: OR conditions with different columns (forces index scan)
SELECT * FROM Employees e 
WHERE e.FirstName = 'John' OR e.LastName = 'Smith';

-- BETTER: Use UNION for OR conditions on different columns
SELECT * FROM Employees e WHERE e.FirstName = 'John'
UNION
SELECT * FROM Employees e WHERE e.LastName = 'Smith';

-- BAD: Functions in WHERE clause
SELECT * FROM Orders 
WHERE YEAR(OrderDate) = 2023;

-- GOOD: Range comparison
SELECT * FROM Orders 
WHERE OrderDate >= '2023-01-01' AND OrderDate < '2024-01-01';
```

### ORDER BY Optimization Guidelines

#### **Index Design for Sorting**
```sql
-- Query requiring specific sort order
SELECT ProductID, ProductName, BaseSalary
FROM Products 
WHERE CategoryID = 1
ORDER BY BaseSalary DESC, ProductName;

-- Optimal index (matches WHERE and ORDER BY)
CREATE INDEX IX_Products_Category_Price_Name
ON Products (CategoryID, BaseSalary DESC, ProductName);

-- This index provides:
-- 1. Efficient filtering on CategoryID
-- 2. Pre-sorted data for ORDER BY (no sort operation needed)
```

#### **Avoiding Unnecessary Sorts**
```sql
-- BAD: Sorting large result set unnecessarily
SELECT * FROM Orders 
ORDER BY OrderDate
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- GOOD: Filter first, then sort smaller result set
SELECT * FROM Orders 
WHERE OrderDate >= '2023-01-01'
ORDER BY OrderDate
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

### Professional Query Writing Standards

#### **Code Formatting and Readability**
```sql
-- Professional query formatting
SELECT 
    -- Customer information
    c.CustomerID,
    c.CustomerName,
    c.CountryID,
    c.City,
    
    -- Order summary
    COUNT(o.OrderID) AS TotalOrders,
    ISNULL(SUM(o.TotalAmount), 0) AS TotalRevenue,
    MAX(o.OrderDate) AS LastOrderDate,
    
    -- Customer classification
    CASE 
        WHEN COUNT(o.OrderID) >= 20 THEN 'VIP Customer'
        WHEN COUNT(o.OrderID) >= 10 THEN 'Regular Customer'
        WHEN COUNT(o.OrderID) >= 1 THEN 'Occasional Customer'
        ELSE 'No Orders'
    END AS CustomerCategory
    
FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    
WHERE 
    c.CountryID IN ('USA', 'Canada', 'Mexico')
    AND (o.OrderDate IS NULL OR o.OrderDate >= '2022-01-01')
    
GROUP BY 
    c.CustomerID,
    c.CustomerName, 
    c.CountryID,
    c.City
    
HAVING 
    COUNT(o.OrderID) >= 5
    OR SUM(o.TotalAmount) >= 10000
    
ORDER BY 
    TotalRevenue DESC,
    TotalOrders DESC,
    c.CustomerName;
```

This enhanced Module 5 presentation provides comprehensive coverage of sorting and filtering with detailed explanations, advanced techniques, performance considerations, and professional best practices that will give students a deep understanding of these fundamental SQL concepts.