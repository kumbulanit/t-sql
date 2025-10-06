# Module 5 Exercise Answers: Sorting and Filtering Data

## Exercise Set 1: Sorting Data (Lesson 1) - Answers

### Exercise 1.1: Basic Sorting Operations - Answers

**Tasks Solutions**:

1. **List all customers sorted by company name in ascending order**:

```sql
SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers
ORDER BY CompanyName ASC;
-- Note: ASC is optional as it's the default
```

2. **Show all products sorted by unit price in descending order**:

```sql
SELECT ProductName, UnitPrice, CategoryID
FROM Products
ORDER BY UnitPrice DESC;
```

3. **Display all employees sorted first by last name, then by first name**:

```sql
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
ORDER BY LastName, FirstName;
```

4. **Show orders sorted by order date (newest first), then by customer ID**:

```sql
SELECT OrderID, CustomerID, OrderDate, ShippedDate
FROM Orders
ORDER BY OrderDate DESC, CustomerID;
```

**Questions Answers**:

1. **Default sort order without ASC/DESC**: If you don't specify ASC or DESC, SQL Server uses ASC (ascending) as the default sort order.

2. **Sorting by columns not in SELECT**: Yes, you can sort by columns that are not included in the SELECT list, as long as the columns exist in the tables being queried.

3. **Performance impact of sorting large result sets**: 
   - Sorting requires additional memory and CPU resources
   - May require temporary storage (disk-based sorting) for very large sets
   - Can be optimized with appropriate indexes
   - ORDER BY operations are typically one of the most expensive parts of a query

### Exercise 1.2: Advanced Sorting Techniques - Answers

**Tasks Solutions**:

1. **Sort products by category name, show only product name and unit price**:

```sql
SELECT p.ProductName, p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName;
```

2. **Sort employees by hire date with NULL values last**:

```sql
SELECT EmployeeID, FirstName, LastName, HireDate
FROM Employees
ORDER BY 
    CASE WHEN HireDate IS NULL THEN 1 ELSE 0 END,
    HireDate;
```

3. **Sort products: discontinued first, then active by price (highest first)**:

```sql
SELECT ProductName, UnitPrice, Discontinued
FROM Products
ORDER BY 
    CASE WHEN Discontinued = 1 THEN 0 ELSE 1 END,
    CASE WHEN Discontinued = 0 THEN UnitPrice END DESC;
```

4. **Sort customers by country with 'USA' first, then alphabetically**:

```sql
SELECT CustomerID, CompanyName, Country
FROM Customers
ORDER BY 
    CASE WHEN Country = 'USA' THEN 0 ELSE 1 END,
    Country;
```

**Questions Answers**:

1. **Controlling NULL value sort order**: 
   - Use CASE expressions to explicitly control NULL positioning
   - NULLs typically sort first in ascending order, last in descending order
   - Can use NULLS FIRST or NULLS LAST (not available in SQL Server)

2. **Using computed columns in ORDER BY**: 
   - When you need conditional sorting logic
   - For derived values that don't exist as stored columns
   - To implement business-specific sorting rules
   - For performance optimization of frequently used sort expressions

3. **ORDER BY limitations in views**: 
   - Views cannot have ORDER BY unless used with TOP or OFFSET-FETCH
   - ORDER BY in views is only for TOP operations, not guaranteed result order
   - Must use ORDER BY in the query that selects from the view

### Exercise 1.3: Performance Considerations - Answers

**Tasks Solutions**:

1. **Demonstrate sorting with and without an index**:

```sql
-- Without index (table scan + sort)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate;

-- Check execution plan, then create index
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);

-- With index (index scan, already sorted)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate;
```

2. **Create index to optimize sorting by OrderDate and CustomerID**:

```sql
-- Composite index for multi-column sorting
CREATE INDEX IX_Orders_OrderDate_CustomerID 
ON Orders(OrderDate, CustomerID);

-- Optimized query
SELECT OrderID, CustomerID, OrderDate, RequiredDate
FROM Orders
ORDER BY OrderDate, CustomerID;
```

3. **Combine WHERE clause filtering with ORDER BY**:

```sql
-- Filter first, then sort (more efficient)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01'
ORDER BY OrderDate DESC;

-- Consider a filtered index for even better performance
CREATE INDEX IX_Orders_1997_OrderDate 
ON Orders(OrderDate DESC)
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';
```

**Questions Answers**:

1. **How indexes help with ORDER BY performance**:
   - Indexes store data in sorted order
   - Eliminates the need for separate sort operation
   - Reduces I/O and memory requirements
   - Covering indexes can eliminate key lookups

2. **Clustered vs non-clustered indexes for sorting**:
   - **Clustered index**: Data pages are physically sorted, best performance
   - **Non-clustered index**: Index pages are sorted, may require key lookups
   - Clustered index supports only one sort order per table

3. **Memory vs disk sorting**:
   - **Memory sorting**: Fast, limited by available memory
   - **Disk sorting**: Slower, uses tempdb for large sorts
   - Depends on data size, memory configuration, and query complexity

## Exercise Set 2: Filtering Data with Predicates (Lesson 2) - Answers

### Exercise 2.1: Basic WHERE Clause Operations - Answers

**Tasks Solutions**:

1. **Find all products with unit price greater than $20**:

```sql
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC;
```

2. **Find all customers from Germany or France**:

```sql
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE Country = 'Germany' OR Country = 'France'
ORDER BY Country, CompanyName;
```

3. **Find all orders placed in 1997**:

```sql
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01'
ORDER BY OrderDate;
```

4. **Find all employees whose first name starts with 'A'**:

```sql
SELECT EmployeeID, FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'A%'
ORDER BY FirstName;
```

5. **Find products with 'chocolate' anywhere in their name (case-insensitive)**:

```sql
SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%chocolate%'
ORDER BY ProductName;
```

**Questions Answers**:

1. **Difference between = and LIKE operators**:
   - **= operator**: Exact match comparison
   - **LIKE operator**: Pattern matching with wildcards (%, _)
   - LIKE is slower due to pattern matching overhead
   - = can use indexes more efficiently

2. **SQL Server case sensitivity handling**:
   - Depends on database/column collation settings
   - Default collations are usually case-insensitive
   - Can be controlled with COLLATE clause
   - Binary collations are case-sensitive

3. **Performance implications of leading wildcards**:
   - Leading wildcards (LIKE '%pattern') prevent index usage
   - Requires full table scan
   - Consider full-text search for better performance
   - Trailing wildcards (LIKE 'pattern%') can use indexes

### Exercise 2.2: Complex Predicate Logic - Answers

**Tasks Solutions**:

1. **Products that are discontinued OR have unit price less than $10**:

```sql
SELECT ProductID, ProductName, UnitPrice, Discontinued
FROM Products
WHERE Discontinued = 1 OR UnitPrice < 10
ORDER BY Discontinued DESC, UnitPrice;
```

2. **Customers with 'Restaurant' in company name AND from USA**:

```sql
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CompanyName LIKE '%Restaurant%' AND Country = 'USA'
ORDER BY CompanyName;
```

3. **Orders placed between January 1, 1997, and December 31, 1997**:

```sql
-- Method 1: Using BETWEEN
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
ORDER BY OrderDate;

-- Method 2: Using >= and <= (more explicit)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate <= '1997-12-31'
ORDER BY OrderDate;
```

4. **Products with prices between $10 and $50, excluding Beverages**:

```sql
SELECT p.ProductID, p.ProductName, p.UnitPrice, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice BETWEEN 10 AND 50 
  AND c.CategoryName != 'Beverages'
ORDER BY p.UnitPrice;
```

5. **Customers NOT from Germany, France, or UK**:

```sql
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE Country NOT IN ('Germany', 'France', 'UK')
ORDER BY Country, CompanyName;
```

**Questions Answers**:

1. **Operator precedence for AND, OR, NOT**:
   - **Precedence order**: NOT (highest), AND, OR (lowest)
   - NOT is evaluated first, then AND, then OR
   - Use parentheses to override default precedence
   - Example: `A OR B AND C` equals `A OR (B AND C)`

2. **How parentheses affect predicate evaluation**:
   - Parentheses override default operator precedence
   - Inner parentheses are evaluated first
   - Critical for complex logical expressions
   - Improves code readability and maintainability

3. **BETWEEN vs >= and <= operators**:
   - **BETWEEN**: More readable, inclusive of both endpoints
   - **>= and <=**: More explicit, better for complex ranges
   - BETWEEN can be problematic with datetime ranges
   - Performance is typically equivalent

### Exercise 2.3: Working with Sets and Ranges - Answers

**Tasks Solutions**:

1. **Products in specific categories using IN**:

```sql
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Dairy Products', 'Seafood', 'Beverages')
ORDER BY c.CategoryName, p.ProductName;
```

2. **Customers who have placed at least one order using EXISTS**:

```sql
SELECT c.CustomerID, c.CompanyName, c.Country
FROM Customers c
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.CustomerID = c.CustomerID
)
ORDER BY c.CompanyName;
```

3. **Products that have never been ordered using NOT EXISTS**:

```sql
SELECT p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 
    FROM [Order Details] od 
    WHERE od.ProductID = p.ProductID
)
ORDER BY p.ProductName;
```

4. **Top 3 most expensive products in each category**:

```sql
-- Using ROW_NUMBER() window function
SELECT CategoryID, ProductName, UnitPrice
FROM (
    SELECT p.CategoryID, p.ProductName, p.UnitPrice,
           ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) as rn
    FROM Products p
) ranked
WHERE rn <= 3
ORDER BY CategoryID, UnitPrice DESC;
```

**Questions Answers**:

1. **Difference between IN and EXISTS**:
   - **IN**: Compares values, can return NULL issues with NULLs
   - **EXISTS**: Tests for existence, returns TRUE/FALSE only
   - EXISTS is often more efficient for correlated queries
   - IN is simpler for literal value lists

2. **When to use EXISTS instead of JOIN**:
   - When you only need to test existence, not retrieve data
   - To avoid duplicate rows from one-to-many relationships
   - For better performance with large datasets
   - When the subquery is correlated

3. **SQL Server optimization of IN vs OR**:
   - Modern SQL Server optimizes both similarly
   - IN is generally more readable
   - OR can be faster for very few values (2-3)
   - IN is better for many values or dynamic lists

## Exercise Set 3: Using TOP and OFFSET-FETCH (Lesson 3) - Answers

### Exercise 3.1: TOP Clause Fundamentals - Answers

**Tasks Solutions**:

1. **Find the 5 most expensive products**:

```sql
SELECT TOP 5 ProductID, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC;
```

2. **Find the top 10% of customers by total order value**:

```sql
SELECT TOP 10 PERCENT c.CustomerID, c.CompanyName, 
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as TotalOrderValue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalOrderValue DESC;
```

3. **Find highest-priced products using TOP WITH TIES**:

```sql
SELECT TOP 1 WITH TIES ProductID, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC;
```

4. **Find the 3 most recent orders for each customer**:

```sql
SELECT CustomerID, OrderID, OrderDate
FROM (
    SELECT CustomerID, OrderID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) as rn
    FROM Orders
) ranked
WHERE rn <= 3
ORDER BY CustomerID, OrderDate DESC;
```

**Questions Answers**:

1. **TOP without ORDER BY behavior**:
   - Returns arbitrary rows from the result set
   - No guarantee of which rows will be returned
   - Results may vary between executions
   - Generally not recommended without ORDER BY

2. **TOP WITH TIES vs just TOP**:
   - **TOP WITH TIES**: Includes additional rows that have the same value as the last row
   - **Just TOP**: Returns exactly the specified number of rows
   - WITH TIES can return more rows than specified
   - Useful when you don't want to arbitrarily cut off tied values

3. **Performance characteristics of TOP**:
   - Very efficient for small numbers of rows
   - Can use TOP N sort optimization
   - Much more efficient than LIMIT in some other databases
   - Works well with indexes

### Exercise 3.2: OFFSET-FETCH for Pagination - Answers

**Tasks Solutions**:

1. **Implement pagination showing products 11-20 when ordered by product name**:

```sql
SELECT ProductID, ProductName, UnitPrice
FROM Products
ORDER BY ProductName
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
```

2. **Parameterized pagination solution for customers with page size of 15**:

```sql
DECLARE @PageNumber INT = 2;  -- Page 2
DECLARE @PageSize INT = 15;

SELECT CustomerID, CompanyName, Country
FROM Customers
ORDER BY CompanyName
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

3. **Combine filtering with pagination (second page of products with unit price > $10)**:

```sql
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 10;

SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 10
ORDER BY ProductName
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

4. **Demonstrate difference between TOP and OFFSET-FETCH**:

```sql
-- Using TOP (gets first 10)
SELECT TOP 10 ProductID, ProductName
FROM Products
ORDER BY ProductName;

-- Using OFFSET-FETCH (gets next 10 after skipping 10)
SELECT ProductID, ProductName
FROM Products
ORDER BY ProductName
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
```

**Questions Answers**:

1. **Why OFFSET-FETCH is preferred for pagination**:
   - More explicit and standardized (ANSI SQL)
   - Better for consistent pagination logic
   - Clearer intent for pagination scenarios
   - Works better with parameterized queries

2. **Requirements when using OFFSET-FETCH**:
   - **Must have ORDER BY clause** - this is mandatory
   - Cannot be used in views (unless with TOP)
   - OFFSET value must be 0 or greater
   - FETCH value must be 1 or greater

3. **Calculating OFFSET for page number and page size**:
   ```sql
   OFFSET = (PageNumber - 1) * PageSize
   -- Example: Page 3, Size 20 = (3-1) * 20 = 40
   ```

### Exercise 3.3: Performance and Best Practices - Answers

**Tasks Solutions**:

1. **Compare performance of TOP vs OFFSET-FETCH**:

```sql
-- TOP performance (efficient)
SELECT TOP 1000 OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate DESC;

-- OFFSET-FETCH with small offset (efficient)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate DESC
OFFSET 0 ROWS
FETCH NEXT 1000 ROWS ONLY;

-- OFFSET-FETCH with large offset (less efficient)
SELECT OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate DESC
OFFSET 50000 ROWS
FETCH NEXT 1000 ROWS ONLY;
```

2. **OFFSET-FETCH with complex sorting criteria**:

```sql
SELECT o.OrderID, c.CompanyName, o.OrderDate, 
       SUM(od.UnitPrice * od.Quantity) as OrderTotal
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName, o.OrderDate
ORDER BY OrderTotal DESC, o.OrderDate DESC
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
```

3. **Efficient pagination with consistent results**:

```sql
-- Use unique column in ORDER BY for consistency
SELECT OrderID, CustomerID, OrderDate
FROM Orders
ORDER BY OrderDate DESC, OrderID DESC  -- OrderID ensures uniqueness
OFFSET 100 ROWS
FETCH NEXT 25 ROWS ONLY;
```

**Questions Answers**:

1. **Performance implications of large OFFSET values**:
   - SQL Server must process and skip all OFFSET rows
   - Performance degrades linearly with OFFSET size
   - Consider cursor-based pagination for very large offsets
   - Use seek-based pagination when possible

2. **Ensuring consistent pagination results**:
   - Include unique columns in ORDER BY clause
   - Use deterministic sort orders
   - Consider using timestamps or IDs for cursor-based pagination
   - Be aware of data changes during pagination

3. **When to use PERCENT with TOP**:
   - When you need a proportional sample
   - For statistical sampling scenarios
   - When the result set size varies significantly
   - Be careful with small datasets (may return 0 rows)

## Exercise Set 4: Working with Unknown Values (Lesson 4) - Answers

### Exercise 4.1: Understanding NULL Values - Answers

**Tasks Solutions**:

1. **Find all customers where Region field is NULL**:

```sql
SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE Region IS NULL
ORDER BY CompanyName;
```

2. **Find employees where both City and Region are NOT NULL**:

```sql
SELECT EmployeeID, FirstName, LastName, City, Region
FROM Employees
WHERE City IS NOT NULL AND Region IS NOT NULL
ORDER BY LastName, FirstName;
```

3. **Count customers with NULL values in the Fax field**:

```sql
SELECT COUNT(*) as CustomersWithNullFax
FROM Customers
WHERE Fax IS NULL;
```

4. **Demonstrate difference between COUNT(*) and COUNT(column) with NULLs**:

```sql
SELECT 
    COUNT(*) as TotalRows,
    COUNT(Region) as NonNullRegions,
    COUNT(*) - COUNT(Region) as NullRegions
FROM Customers;
```

**Questions Answers**:

1. **Difference between NULL and empty string**:
   - **NULL**: Represents unknown or missing data
   - **Empty string ('')**: Represents known empty value
   - NULL requires IS NULL/IS NOT NULL operators
   - Empty string can use = '' comparison
   - They have different storage and behavior characteristics

2. **How NULL affects aggregate functions**:
   - Most aggregate functions ignore NULL values
   - COUNT(*) counts all rows, COUNT(column) ignores NULLs
   - SUM, AVG, MIN, MAX ignore NULLs
   - Can lead to unexpected results in calculations

3. **Why can't you use = or <> to compare with NULL**:
   - NULL represents "unknown"
   - Any comparison with unknown is unknown (NULL)
   - NULL = NULL returns NULL, not TRUE
   - Must use IS NULL or IS NOT NULL for NULL tests

### Exercise 4.2: Working with NULL Values - Answers

**Tasks Solutions**:

1. **Use ISNULL to replace NULL Region values with 'Not Specified'**:

```sql
SELECT CustomerID, CompanyName, City, 
       ISNULL(Region, 'Not Specified') as Region, 
       Country
FROM Customers
ORDER BY CompanyName;
```

2. **Use COALESCE to handle multiple potentially NULL columns**:

```sql
SELECT CustomerID, CompanyName,
       COALESCE(Region, City, Country, 'Unknown Location') as Location
FROM Customers
ORDER BY CompanyName;
```

3. **Use NULLIF to convert empty strings to NULL values**:

```sql
-- First, let's see the current data
SELECT CustomerID, CompanyName, 
       Region,
       NULLIF(Region, '') as CleanedRegion
FROM Customers
WHERE Region = '' OR Region IS NULL
ORDER BY CompanyName;
```

4. **Handle NULL values in calculations without getting NULL results**:

```sql
-- Calculate total order value handling potential NULLs
SELECT od.OrderID, od.ProductID,
       od.UnitPrice,
       od.Quantity,
       ISNULL(od.Discount, 0) as Discount,
       od.UnitPrice * od.Quantity * (1 - ISNULL(od.Discount, 0)) as LineTotal
FROM [Order Details] od
ORDER BY od.OrderID;
```

**Questions Answers**:

1. **Difference between ISNULL and COALESCE**:
   - **ISNULL**: SQL Server specific, takes exactly 2 parameters
   - **COALESCE**: ANSI standard, takes multiple parameters
   - COALESCE returns first non-NULL value
   - ISNULL has slightly better performance for 2-parameter scenarios

2. **When to use NULLIF**:
   - Converting empty strings to NULL for consistency
   - Preventing division by zero (NULLIF(denominator, 0))
   - Data cleansing operations
   - Normalizing inconsistent data representations

3. **How NULL values affect sorting**:
   - NULLs typically sort before other values in ascending order
   - NULLs typically sort after other values in descending order
   - Can be controlled with CASE expressions
   - Behavior is consistent but may not match business expectations

### Exercise 4.3: Advanced NULL Handling - Answers

**Tasks Solutions**:

1. **Join tables handling cases where foreign key values might be NULL**:

```sql
-- LEFT JOIN to include customers even if EmployeeID is NULL
SELECT c.CustomerID, c.CompanyName, 
       ISNULL(e.FirstName + ' ' + e.LastName, 'No Sales Rep') as SalesRep
FROM Customers c
LEFT JOIN Employees e ON c.EmployeeID = e.EmployeeID
ORDER BY c.CompanyName;
```

2. **Use CASE to provide different default values for NULL based on other columns**:

```sql
SELECT CustomerID, CompanyName, Country, Region,
       CASE 
           WHEN Region IS NULL AND Country = 'USA' THEN 'Unknown State'
           WHEN Region IS NULL AND Country != 'USA' THEN 'Not Applicable'
           ELSE Region
       END as ProcessedRegion
FROM Customers
ORDER BY Country, CompanyName;
```

3. **Aggregate data treating NULL values as zero for calculations**:

```sql
SELECT p.CategoryID, 
       COUNT(*) as TotalProducts,
       COUNT(p.UnitsInStock) as ProductsWithStockInfo,
       SUM(ISNULL(p.UnitsInStock, 0)) as TotalUnitsInStock,
       AVG(ISNULL(p.UnitsInStock, 0)) as AverageStock
FROM Products p
GROUP BY p.CategoryID
ORDER BY p.CategoryID;
```

4. **Find records where combination of columns has all NULL values**:

```sql
SELECT CustomerID, CompanyName, Region, PostalCode, Fax
FROM Customers
WHERE Region IS NULL AND PostalCode IS NULL AND Fax IS NULL
ORDER BY CompanyName;
```

**Questions Answers**:

1. **How NULL values affect JOIN operations**:
   - NULL values don't match other NULL values in joins
   - Can result in unexpected missing rows
   - Use LEFT/RIGHT JOINs to preserve rows with NULL foreign keys
   - Consider ISNULL or COALESCE in join conditions when appropriate

2. **GROUP BY behavior with NULL values**:
   - NULL values are grouped together into one group
   - All NULL values are treated as equal for grouping purposes
   - Can affect aggregate calculations and counts
   - May need special handling depending on business requirements

3. **Including NULL values in statistical calculations**:
   - Use ISNULL or COALESCE to convert NULLs to appropriate values
   - Consider whether NULLs should be treated as zero or excluded
   - Document the business rules for NULL handling
   - Be consistent across all related calculations

## Practical Scenarios - Answers

### Scenario 1: Customer Analysis Report - Answer

```sql
DECLARE @PageNumber INT = 1;
DECLARE @PageSize INT = 20;

WITH CustomerOrderTotals AS (
    SELECT c.CustomerID, c.CompanyName, 
           ISNULL(c.Region, 'Not Specified') as Region,
           c.Country,
           SUM(od.UnitPrice * od.Quantity * (1 - ISNULL(od.Discount, 0))) as TotalOrderValue
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Region, c.Country
    HAVING SUM(od.UnitPrice * od.Quantity * (1 - ISNULL(od.Discount, 0))) > 1000
)
SELECT CustomerID, CompanyName, Region, Country, TotalOrderValue
FROM CustomerOrderTotals
ORDER BY 
    CASE WHEN Country = 'USA' THEN 0 ELSE 1 END,
    Country,
    CompanyName
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

### Scenario 2: Product Inventory Management - Answer

```sql
SELECT TOP 15 
    p.ProductID, p.ProductName, c.CategoryName,
    p.UnitsInStock, 
    ISNULL(p.ReorderLevel, 0) as ReorderLevel,
    p.UnitsInStock - ISNULL(p.ReorderLevel, 0) as StockDeficit
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0 
  AND p.UnitsInStock < ISNULL(p.ReorderLevel, 1)
ORDER BY c.CategoryName, p.UnitsInStock;
```

### Scenario 3: Sales Performance Dashboard - Answer

```sql
WITH CustomerSalesLast6Months AS (
    SELECT c.CustomerID, 
           ISNULL(c.CompanyName, 'Unknown Customer') as CompanyName,
           COUNT(o.OrderID) as OrderCount,
           SUM(od.UnitPrice * od.Quantity * (1 - ISNULL(od.Discount, 0))) as TotalValue
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.OrderDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY c.CustomerID, c.CompanyName
    HAVING COUNT(o.OrderID) >= 3
)
SELECT TOP 10 CustomerID, CompanyName, OrderCount, TotalValue
FROM CustomerSalesLast6Months
ORDER BY TotalValue DESC, CompanyName
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;
```

## Review Questions - Answers

### Multiple Choice Answers

1. **c) ORDER BY UnitPrice DESC** - DESC specifies descending order (highest to lowest)

2. **c) The top 10% of records based on ORDER BY** - TOP 10 PERCENT returns a percentage of the result set

3. **c) IS NULL** - IS NULL is the correct operator for testing NULL values

4. **b) An ORDER BY clause** - OFFSET-FETCH requires ORDER BY to be specified

5. **a) They appear first** - NULL values typically sort first in ascending order

### Short Answer Answers

1. **Difference between TOP and OFFSET-FETCH for pagination**:
   - **TOP**: Gets first N rows, good for "top results" scenarios
   - **OFFSET-FETCH**: Skips rows and then fetches, perfect for pagination
   - OFFSET-FETCH is better for consistent pagination logic
   - TOP is more efficient for getting first few rows

2. **AND, OR, and NOT operators with NULL values**:
   - **AND**: TRUE AND NULL = NULL, FALSE AND NULL = FALSE
   - **OR**: TRUE OR NULL = TRUE, FALSE OR NULL = NULL
   - **NOT**: NOT NULL = NULL
   - Three-valued logic can produce unexpected results

3. **Performance implications of wildcards in LIKE patterns**:
   - Leading wildcards prevent index usage
   - Trailing wildcards can use index seeks
   - Middle wildcards require full scans
   - Consider full-text search for complex pattern matching

4. **When to use COALESCE instead of ISNULL**:
   - When handling more than 2 values
   - For ANSI SQL compatibility
   - When you need the first non-NULL from multiple columns
   - For more complex NULL handling logic

5. **NULLS FIRST/NULLS LAST in ORDER BY**:
   - Not directly supported in SQL Server
   - Can be achieved using CASE expressions
   - Controls where NULL values appear in sorted results
   - Important for consistent reporting requirements

### Practical Tasks - Sample Solutions

1. **Find second-highest priced product in each category**:

```sql
SELECT CategoryID, ProductName, UnitPrice
FROM (
    SELECT p.CategoryID, p.ProductName, p.UnitPrice,
           ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) as rn
    FROM Products p
) ranked
WHERE rn = 2
ORDER BY CategoryID;
```

2. **Pagination solution showing products 21-40**:

```sql
SELECT ProductID, ProductName, UnitPrice, Discontinued
FROM Products
WHERE Discontinued = 0
ORDER BY ProductName
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;
```

3. **Safe calculations with potentially NULL values**:

```sql
SELECT OrderID, ProductID,
       UnitPrice,
       Quantity,
       ISNULL(Discount, 0) as SafeDiscount,
       UnitPrice * Quantity * (1 - ISNULL(Discount, 0)) as LineTotal
FROM [Order Details]
WHERE UnitPrice IS NOT NULL AND Quantity IS NOT NULL;
```

4. **Search feature with multiple optional filter criteria**:

```sql
DECLARE @ProductName NVARCHAR(50) = NULL;
DECLARE @MinPrice MONEY = NULL;
DECLARE @MaxPrice MONEY = NULL;
DECLARE @CategoryID INT = NULL;

SELECT ProductID, ProductName, UnitPrice, CategoryID
FROM Products
WHERE (@ProductName IS NULL OR ProductName LIKE '%' + @ProductName + '%')
  AND (@MinPrice IS NULL OR UnitPrice >= @MinPrice)
  AND (@MaxPrice IS NULL OR UnitPrice <= @MaxPrice)
  AND (@CategoryID IS NULL OR CategoryID = @CategoryID)
ORDER BY ProductName;
```

5. **Handle missing data in customer addresses**:

```sql
SELECT CustomerID,
       CompanyName,
       ISNULL(Address, 'Address Not Available') as MailingAddress,
       ISNULL(City, 'City Not Available') as MailingCity,
       CASE 
           WHEN Region IS NULL AND Country = 'USA' THEN 'State Not Available'
           WHEN Region IS NULL THEN ''
           ELSE Region
       END as MailingRegion,
       ISNULL(PostalCode, 'ZIP Not Available') as MailingPostalCode,
       ISNULL(Country, 'Country Not Available') as MailingCountry
FROM Customers
WHERE Address IS NOT NULL OR City IS NOT NULL  -- At least some address info
ORDER BY CompanyName;
```