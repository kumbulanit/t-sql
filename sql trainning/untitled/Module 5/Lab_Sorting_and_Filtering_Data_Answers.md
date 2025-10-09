# Lab Answers: Sorting and Filtering Data

## Exercise 1: Basic Sorting Operations - Answers

### Task 1.1: Simple Sorting - Answers

#### Question 1: Sort customers by company name alphabetically
**Task:** Sort all customers by company name alphabetically.

```sql
-- Answer 1: Sort customers by company name alphabetically
USE Northwind;
GO

SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    Country,
    City
FROM Customers
ORDER BY CompanyName ASC;
```

#### Question 2: Sort products by unit price from highest to lowest
**Task:** Sort all products by unit price from highest to lowest.

```sql
-- Answer 2: Sort products by unit price from highest to lowest
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    UnitsInStock,
    CategoryID
FROM Products
ORDER BY BaseSalary DESC;
```

#### Question 3: Sort employees by hire date, newest first
**Task:** Sort employees by hire date, newest first.

```sql
-- Answer 3: Sort employees by hire date, newest first
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Title,
    HireDate
FROM Employees
ORDER BY HireDate DESC;
```

### Task 1.2: Multi-Level Sorting - Answers

#### Question 1: Sort customers by country, then by city
**Task:** Sort customers by country, then by city within each country.

```sql
-- Answer 1: Sort customers by country, then by city
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    Country,
    City
FROM Customers
ORDER BY Country ASC, City ASC;
```

#### Question 2: Sort products by category, then by unit price
**Task:** Sort products by category, then by unit price (highest first) within category.

```sql
-- Answer 2: Sort products by category, then by unit price
SELECT 
    p.ProductName,
    c.CategoryName,
    p.BaseSalary,
    p.UnitsInStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName ASC, p.BaseSalary DESC;
```

#### Question 3: Sort orders by customer, then by order date
**Task:** Sort orders by customer, then by order date (newest first) for each customer.

```sql
-- Answer 3: Sort orders by customer, then by order date
SELECT 
    o.OrderID,
    c.CompanyName,
    o.OrderDate,
    o.RequiredDate,
    o.ShippedDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY c.CompanyName ASC, o.OrderDate DESC;
```

### Task 1.3: Advanced Sorting - Answers

#### Question 1: Sort products by total inventory value
**Task:** Sort products by total inventory value (BaseSalary * UnitsInStock) descending.

```sql
-- Answer 1: Sort products by total inventory value
SELECT 
    ProductName,
    BaseSalary,
    UnitsInStock,
    COALESCE(BaseSalary * UnitsInStock, 0) AS InventoryValue
FROM Products
ORDER BY InventoryValue DESC;
```

#### Question 2: Sort customers by company name length
**Task:** Sort customers by the length of their company name, shortest first.

```sql
-- Answer 2: Sort customers by company name length
SELECT 
    CustomerID,
    CompanyName,
    LEN(CompanyName) AS NameLength,
    Country
FROM Customers
ORDER BY LEN(CompanyName) ASC, CompanyName ASC;
```

#### Question 3: Sort employees by age, oldest first
**Task:** Sort employees by age (calculate from birth date), oldest first.

```sql
-- Answer 3: Sort employees by age, oldest first
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BirthDate,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Employees
WHERE BirthDate IS NOT NULL
ORDER BY Age DESC;
```

## Exercise 2: Filtering with Predicates - Answers

### Task 2.1: Basic WHERE Clauses - Answers

#### Question 1: Find all customers from Germany
**Task:** Find all customers from Germany.

```sql
-- Answer 1: Find all customers from Germany
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    City,
    Country
FROM Customers
WHERE Country = 'Germany'
ORDER BY CompanyName;
```

#### Question 2: Find products with unit price greater than $20
**Task:** Find all products with unit price greater than $20.

```sql
-- Answer 2: Find products with unit price greater than $20
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    UnitsInStock,
    Discontinued
FROM Products
WHERE BaseSalary > 20
ORDER BY BaseSalary DESC;
```

#### Question 3: Find orders placed in 1997
**Task:** Find all orders placed in 1997.

```sql
-- Answer 3: Find orders placed in 1997
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate
FROM Orders
WHERE YEAR(OrderDate) = 1997
ORDER BY OrderDate;
```

### Task 2.2: Advanced Filtering - Answers

#### Question 1: Find customers from USA or Canada with 'Sales' in contact title
**Task:** Find customers from USA or Canada with 'Sales' in their contact title.

```sql
-- Answer 1: Find customers from USA or Canada with 'Sales' in contact title
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    ContactTitle,
    Country
FROM Customers
WHERE (Country = 'USA' OR Country = 'Canada')
  AND ContactTitle LIKE '%Sales%'
ORDER BY Country, CompanyName;
```

#### Question 2: Find discontinued products or products with low stock
**Task:** Find products that are discontinued OR have less than 10 units in stock.

```sql
-- Answer 2: Find discontinued products or products with low stock
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    UnitsInStock,
    Discontinued,
    CASE 
        WHEN Discontinued = 1 THEN 'Discontinued'
        WHEN UnitsInStock < 10 THEN 'Low Stock'
        ELSE 'Available'
    END AS ProductIsActive
FROM Products
WHERE Discontinued = 1 OR UnitsInStock < 10
ORDER BY Discontinued DESC, UnitsInStock ASC;
```

#### Question 3: Find orders with specific shipping conditions
**Task:** Find orders shipped to France with freight cost between $50 and $100.

```sql
-- Answer 3: Find orders with specific shipping conditions
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    ShipCountry,
    Freight,
    ShippedDate
FROM Orders
WHERE ShipCountry = 'France'
  AND Freight BETWEEN 50 AND 100
ORDER BY Freight DESC;
```

## Exercise 3: Using TOP and OFFSET-FETCH - Answers

### Task 3.1: TOP Clause - Answers

#### Question 1: Top 5 most expensive products
**Task:** Find the top 5 most expensive products.

```sql
-- Answer 1: Top 5 most expensive products
SELECT TOP 5
    ProductName,
    BaseSalary,
    CategoryID,
    UnitsInStock
FROM Products
ORDER BY BaseSalary DESC;
```

#### Question 2: Top 10 customers by number of orders
**Task:** Find the top 10 customers by number of orders placed.

```sql
-- Answer 2: Top 10 customers by number of orders
SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY OrderCount DESC;
```

#### Question 3: Top 3 categories by average product price
**Task:** Find the top 3 categories by average product price.

```sql
-- Answer 3: Top 3 categories by average product price
SELECT TOP 3
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.BaseSalary) AS AveragePrice,
    MAX(p.BaseSalary) AS HighestPrice,
    MIN(p.BaseSalary) AS LowestPrice
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY AveragePrice DESC;
```

### Task 3.2: TOP with PERCENT - Answers

#### Question 1: Top 25% of products by price
**Task:** Find the top 25% of products by unit price.

```sql
-- Answer 1: Top 25% of products by price
SELECT TOP 25 PERCENT
    ProductName,
    BaseSalary,
    CategoryID
FROM Products
ORDER BY BaseSalary DESC;
```

#### Question 2: Top 10% of orders by freight cost
**Task:** Find the top 10% of orders by freight cost.

```sql
-- Answer 2: Top 10% of orders by freight cost
SELECT TOP 10 PERCENT
    OrderID,
    CustomerID,
    OrderDate,
    Freight,
    ShipCountry
FROM Orders
ORDER BY Freight DESC;
```

### Task 3.3: OFFSET-FETCH (Pagination) - Answers

#### Question 1: Products pagination - Page 2
**Task:** Show products 11-20 when sorted by ProductName (page 2, 10 per page).

```sql
-- Answer 1: Products pagination - Page 2
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    CategoryID
FROM Products
ORDER BY ProductName
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
```

#### Question 2: Customers pagination with filtering
**Task:** Show customers from USA, page 3, 5 customers per page.

```sql
-- Answer 2: Customers pagination with filtering
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    City
FROM Customers
WHERE Country = 'USA'
ORDER BY CompanyName
OFFSET 10 ROWS  -- (Page 3 - 1) * 5 = 10
FETCH NEXT 5 ROWS ONLY;
```

#### Question 3: Orders pagination with complex sorting
**Task:** Show orders sorted by OrderDate DESC, then OrderID ASC, page 4, 15 per page.

```sql
-- Answer 3: Orders pagination with complex sorting
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    Freight
FROM Orders
ORDER BY OrderDate DESC, OrderID ASC
OFFSET 45 ROWS  -- (Page 4 - 1) * 15 = 45
FETCH NEXT 15 ROWS ONLY;
```

## Exercise 4: Working with Unknown Values (NULL) - Answers

### Task 4.1: Identifying NULL Values - Answers

#### Question 1: Customers without region information
**Task:** Find customers where Region is NULL.

```sql
-- Answer 1: Customers without region information
SELECT 
    CustomerID,
    CompanyName,
    Country,
    City,
    Region,
    PostalCode
FROM Customers
WHERE Region IS NULL
ORDER BY Country, City;
```

#### Question 2: Products without category assignment
**Task:** Find products where CategoryID is NULL.

```sql
-- Answer 2: Products without category assignment
SELECT 
    ProductID,
    ProductName,
    CategoryID,
    BaseSalary,
    UnitsInStock
FROM Products
WHERE CategoryID IS NULL
ORDER BY ProductName;
```

#### Question 3: Orders with missing shipped dates
**Task:** Find orders that haven't been shipped yet (ShippedDate is NULL).

```sql
-- Answer 3: Orders with missing shipped dates
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysUnshipped
FROM Orders
WHERE ShippedDate IS NULL
ORDER BY OrderDate;
```

### Task 4.2: Handling NULL in Calculations - Answers

#### Question 1: Safe inventory value calculation
**Task:** Calculate inventory value handling NULL values safely.

```sql
-- Answer 1: Safe inventory value calculation
SELECT 
    ProductName,
    BaseSalary,
    UnitsInStock,
    COALESCE(BaseSalary, 0) AS SafePrice,
    COALESCE(UnitsInStock, 0) AS SafeStock,
    COALESCE(BaseSalary, 0) * COALESCE(UnitsInStock, 0) AS InventoryValue,
    CASE 
        WHEN BaseSalary IS NULL OR UnitsInStock IS NULL THEN 'Incomplete Data'
        ELSE 'Complete'
    END AS DataIsActive
FROM Products
ORDER BY InventoryValue DESC;
```

#### Question 2: Order processing time with NULL handling
**Task:** Calculate order processing time, handling NULL shipped dates.

```sql
-- Answer 2: Order processing time with NULL handling
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    ShippedDate,
    CASE 
        WHEN ShippedDate IS NULL THEN 'Not Yet Shipped'
        ELSE CAST(DATEDIFF(DAY, OrderDate, ShippedDate) AS VARCHAR(10)) + ' days'
    END AS ProcessingTime,
    COALESCE(DATEDIFF(DAY, OrderDate, ShippedDate), 
             DATEDIFF(DAY, OrderDate, GETDATE())) AS DaysInProcess
FROM Orders
ORDER BY OrderDate DESC;
```

### Task 4.3: NULL in Aggregations and Comparisons - Answers

#### Question 1: Aggregation with NULL values
**Task:** Analyze how NULL values affect aggregations.

```sql
-- Answer 1: Aggregation with NULL values
SELECT 
    'All Products' AS Category,
    COUNT(*) AS TotalProducts,
    COUNT(BaseSalary) AS ProductsWithPrice,
    COUNT(UnitsInStock) AS ProductsWithStock,
    AVG(e.BaseSalary) AS AvgPrice,
    AVG(UnitsInStock) AS AvgStock,
    SUM(e.BaseSalary) AS TotalPrice,
    SUM(UnitsInStock) AS TotalStock
FROM Products

UNION ALL

SELECT 
    'Non-NULL Only' AS Category,
    COUNT(*),
    COUNT(BaseSalary),
    COUNT(UnitsInStock),
    AVG(e.BaseSalary),
    AVG(UnitsInStock),
    SUM(e.BaseSalary),
    SUM(UnitsInStock)
FROM Products
WHERE BaseSalary IS NOT NULL AND UnitsInStock IS NOT NULL;
```

#### Question 2: Three-valued logic demonstration
**Task:** Demonstrate three-valued logic with NULL comparisons.

```sql
-- Answer 2: Three-valued logic demonstration
SELECT 
    'Equal to NULL' AS ComparisonType,
    COUNT(CASE WHEN Region = NULL THEN 1 END) AS IncorrectCount,
    COUNT(CASE WHEN Region IS NULL THEN 1 END) AS CorrectCount
FROM Customers

UNION ALL

SELECT 
    'Not Equal to NULL',
    COUNT(CASE WHEN Region <> NULL THEN 1 END),
    COUNT(CASE WHEN Region IS NOT NULL THEN 1 END)
FROM Customers

UNION ALL

SELECT 
    'Total Records',
    COUNT(*),
    COUNT(*)
FROM Customers;
```

## Exercise 5: Complex Filtering Scenarios - Answers

### Task 5.1: Multiple Criteria Filtering - Answers

#### Question 1: Complex product search
**Task:** Find products that are either seafood OR beverages, priced between $10-$50, with stock > 20.

```sql
-- Answer 1: Complex product search
SELECT 
    p.ProductName,
    c.CategoryName,
    p.BaseSalary,
    p.UnitsInStock,
    p.Discontinued
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE (c.CategoryName = 'Seafood' OR c.CategoryName = 'Beverages')
  AND p.BaseSalary BETWEEN 10 AND 50
  AND p.UnitsInStock > 20
  AND p.Discontinued = 0
ORDER BY c.CategoryName, p.BaseSalary;
```

#### Question 2: Customer order analysis
**Task:** Find customers from specific countries who placed orders in 1997 with freight > $100.

```sql
-- Answer 2: Customer order analysis
SELECT DISTINCT
    c.CustomerID,
    c.CompanyName,
    c.Country,
    COUNT(o.OrderID) AS OrdersIn1997,
    AVG(o.Freight) AS AverageFreight,
    MAX(o.Freight) AS MaxFreight
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country IN ('USA', 'Germany', 'France', 'UK')
  AND YEAR(o.OrderDate) = 1997
  AND o.Freight > 100
GROUP BY c.CustomerID, c.CompanyName, c.Country
HAVING COUNT(o.OrderID) >= 2
ORDER BY c.Country, AverageFreight DESC;
```

### Task 5.2: Date Range Filtering - Answers

#### Question 1: Quarterly sales analysis
**Task:** Find orders placed in Q4 1997 (October-December).

```sql
-- Answer 1: Quarterly sales analysis
SELECT 
    MONTH(OrderDate) AS OrderMonth,
    COUNT(OrderID) AS OrderCount,
    SUM(Freight) AS TotalFreight,
    AVG(Freight) AS AverageFreight,
    MIN(OrderDate) AS EarliestOrder,
    MAX(OrderDate) AS LatestOrder
FROM Orders
WHERE OrderDate >= '1997-10-01' 
  AND OrderDate < '1998-01-01'
GROUP BY MONTH(OrderDate)
ORDER BY OrderMonth;
```

#### Question 2: Shipping performance analysis
**Task:** Analyze orders with shipping delays (shipped after required date).

```sql
-- Answer 2: Shipping performance analysis
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    DATEDIFF(DAY, RequiredDate, ShippedDate) AS DaysLate,
    Freight,
    ShipCountry
FROM Orders
WHERE ShippedDate > RequiredDate
ORDER BY DATEDIFF(DAY, RequiredDate, ShippedDate) DESC;
```

### Task 5.3: Pattern Matching and String Filtering - Answers

#### Question 1: Company name pattern analysis
**Task:** Find customers with specific patterns in company names.

```sql
-- Answer 1: Company name pattern analysis
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    Country,
    CASE 
        WHEN CompanyName LIKE '%Restaurant%' THEN 'Restaurant'
        WHEN CompanyName LIKE '%Market%' THEN 'Market'
        WHEN CompanyName LIKE '%Store%' THEN 'Store'
        WHEN CompanyName LIKE '%Shop%' THEN 'Shop'
        WHEN CompanyName LIKE '%Trading%' THEN 'Trading Company'
        WHEN CompanyName LIKE '%Ltd%' OR CompanyName LIKE '%Inc%' THEN 'Corporation'
        ELSE 'Other'
    END AS BusinessType
FROM Customers
WHERE CompanyName LIKE '%Restaurant%'
   OR CompanyName LIKE '%Market%'
   OR CompanyName LIKE '%Store%'
   OR CompanyName LIKE '%Shop%'
   OR CompanyName LIKE '%Trading%'
   OR CompanyName LIKE '%Ltd%'
   OR CompanyName LIKE '%Inc%'
ORDER BY BusinessType, CompanyName;
```

#### Question 2: Product name search
**Task:** Find products with names containing specific keywords.

```sql
-- Answer 2: Product name search
SELECT 
    ProductName,
    CategoryID,
    BaseSalary,
    UnitsInStock,
    CASE 
        WHEN ProductName LIKE '%Cheese%' THEN 'Cheese Product'
        WHEN ProductName LIKE '%Sauce%' THEN 'Sauce Product'
        WHEN ProductName LIKE '%Beer%' OR ProductName LIKE '%Wine%' THEN 'Alcoholic Beverage'
        WHEN ProductName LIKE '%Coffee%' OR ProductName LIKE '%Tea%' THEN 'Hot Beverage'
        ELSE 'Other Product'
    END AS d.DepartmentName
FROM Products
WHERE ProductName LIKE '%Cheese%'
   OR ProductName LIKE '%Sauce%'
   OR ProductName LIKE '%Beer%'
   OR ProductName LIKE '%Wine%'
   OR ProductName LIKE '%Coffee%'
   OR ProductName LIKE '%Tea%'
ORDER BY d.DepartmentName, ProductName;
```

## Exercise 6: Advanced Sorting and Filtering Combinations - Answers

### Task 6.1: Dynamic Sorting with CASE - Answers

#### Question 1: Conditional sorting based on product category
**Task:** Sort products with custom logic based on category.

```sql
-- Answer 1: Conditional sorting based on product category
SELECT 
    p.ProductName,
    c.CategoryName,
    p.BaseSalary,
    p.UnitsInStock,
    CASE c.CategoryName
        WHEN 'Beverages' THEN 1
        WHEN 'Dairy Products' THEN 2
        WHEN 'Seafood' THEN 3
        ELSE 4
    END AS SortPriority
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    CASE c.CategoryName
        WHEN 'Beverages' THEN 1
        WHEN 'Dairy Products' THEN 2
        WHEN 'Seafood' THEN 3
        ELSE 4
    END,
    p.BaseSalary DESC;
```

#### Question 2: Custom order status sorting
**Task:** Sort orders with custom logic for shipping status.

```sql
-- Answer 2: Custom order status sorting
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    CASE 
        WHEN ShippedDate IS NULL THEN 'Not Shipped'
        WHEN ShippedDate > RequiredDate THEN 'Late'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
    END AS ShippingIsActive,
    CASE 
        WHEN ShippedDate IS NULL THEN 1  -- Not shipped (highest priority)
        WHEN ShippedDate > RequiredDate THEN 2  -- Late shipments
        ELSE 3  -- On time shipments
    END AS IsActivePriority
FROM Orders
ORDER BY IsActivePriority, OrderDate DESC;
```

### Task 6.2: Performance Optimization with Indexes - Answers

#### Question 1: Optimized customer search
**Task:** Create an optimized query for customer searching with proper indexing hints.

```sql
-- Answer 1: Optimized customer search
-- First, let's see what indexes exist
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Customers')
ORDER BY i.name, ic.key_ordinal;

-- Optimized query using covered indexes where possible
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    Country,
    City
FROM Customers
WHERE Country = 'Germany'  -- This should use an index on Country if it exists
  AND City LIKE 'B%'       -- This can use index on City if it exists
ORDER BY CompanyName;      -- This benefits from an index on CompanyName
```

## Key Learning Points Summary

### Sorting Mastery
1. **ORDER BY Fundamentals**: ASC (default) and DESC keywords
2. **Multi-Level Sorting**: Multiple columns with different sort directions
3. **Expression Sorting**: Sorting by calculated columns and functions
4. **NULL Handling**: NULLs sort first in ASC, last in DESC by default
5. **Performance Impact**: ORDER BY requires sorting operation, consider indexes

### Filtering Techniques
1. **Basic Predicates**: =, <>, <, >, <=, >=, BETWEEN, IN, LIKE
2. **Logical Operators**: AND, OR, NOT with proper precedence
3. **Pattern Matching**: LIKE with % (any characters) and _ (single character)
4. **NULL Comparisons**: IS NULL, IS NOT NULL (never use = NULL)
5. **Case Sensitivity**: Depends on collation settings

### TOP and OFFSET-FETCH
1. **TOP Clause**: Limits result set size, with or without PERCENT
2. **OFFSET-FETCH**: SQL Server 2012+ pagination syntax
3. **Performance**: TOP is generally faster than OFFSET-FETCH for small offsets
4. **Ordering Requirement**: Both require ORDER BY for deterministic results

### NULL Value Handling
1. **Three-Valued Logic**: TRUE, FALSE, UNKNOWN (NULL)
2. **Aggregation Behavior**: Aggregate functions ignore NULL values
3. **COALESCE/ISNULL**: Functions to handle NULL values in expressions
4. **Comparison Behavior**: Any comparison with NULL returns UNKNOWN

### Advanced Techniques Applied
1. **Complex WHERE Clauses**: Combining multiple conditions with proper grouping
2. **Subquery Filtering**: Using subqueries in WHERE clauses
3. **Dynamic Sorting**: CASE expressions in ORDER BY
4. **Date Range Filtering**: Proper techniques for date/time comparisons
5. **Pattern Analysis**: Advanced LIKE patterns and string functions

### Performance Considerations
1. **Index Usage**: How sorting and filtering can leverage indexes
2. **Sargable Predicates**: Conditions that can use index seeks
3. **Function Usage**: Avoid functions on filtered columns when possible
4. **Query Plan Analysis**: Understanding execution plans for optimization

### Best Practices Demonstrated
1. **Explicit Sorting**: Always use ORDER BY for consistent results
2. **Safe NULL Handling**: Use IS NULL/IS NOT NULL, not = NULL
3. **Efficient Pagination**: Use OFFSET-FETCH for modern applications
4. **Index-Friendly Filtering**: Write WHERE clauses that can use indexes
5. **Readable Code**: Use proper formatting and meaningful aliases