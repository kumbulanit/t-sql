# Lesson 4: Working with Unknown Values

## Overview
In SQL Server, unknown values are represented by NULL, which indicates the absence of data or an unknown value. Understanding how to work with NULL values is crucial for writing robust T-SQL queries. This lesson covers NULL behavior, testing for NULL values, and handling NULL in various scenarios.

## Understanding NULL Values

### What is NULL?
- NULL represents the absence of a value
- NULL is not the same as zero, empty string, or space
- NULL comparisons require special handling
- NULL can appear in any column that allows it

### NULL Behavior Examples
```sql
-- These all evaluate to UNKNOWN (not TRUE or FALSE)
SELECT 1 = NULL;        -- UNKNOWN
SELECT NULL = NULL;     -- UNKNOWN
SELECT NULL <> NULL;    -- UNKNOWN
SELECT 'A' > NULL;      -- UNKNOWN
```

## Testing for NULL Values

### IS NULL and IS NOT NULL
```sql
-- Correct way to test for NULL
SELECT CustomerID, CompanyName, Region
FROM Customers
WHERE Region IS NULL;

-- Test for non-NULL values
SELECT CustomerID, CompanyName, Region
FROM Customers
WHERE Region IS NOT NULL;

-- Multiple NULL checks
SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder
FROM Products
WHERE UnitsInStock IS NULL 
   OR UnitsOnOrder IS NULL;
```

### Common NULL Testing Mistakes
```sql
-- WRONG - This will not work as expected
SELECT CustomerID, CompanyName
FROM Customers
WHERE Region = NULL;     -- Always returns no rows

-- WRONG - This will not work as expected
SELECT CustomerID, CompanyName
FROM Customers
WHERE Region <> NULL;    -- Always returns no rows
```

## NULL in Calculations and Functions

### Arithmetic with NULL
```sql
-- Any arithmetic operation with NULL returns NULL
SELECT 
    ProductID,
    ProductName,
    e.BaseSalary,
    UnitsInStock,
    e.BaseSalary * UnitsInStock AS TotalValue,  -- NULL if either is NULL
    e.BaseSalary + 10 AS AdjustedPrice          -- NULL if e.BaseSalary is NULL
FROM Products;
```

### String Concatenation with NULL
```sql
-- NULL in concatenation makes entire result NULL
SELECT 
    CustomerID,
    CustomerName,
    City + ', ' + Region AS Location  -- NULL if Region is NULL
FROM Customers;

-- Better approach using CONCAT
SELECT 
    CustomerID,
    CustomerName,
    CONCAT(City, ', ', Region) AS Location  -- Treats NULL as empty string
FROM Customers;
```

## Handling NULL Values

### ISNULL Function
```sql
-- ISNULL replaces NULL with specified value
SELECT 
    CustomerID,
    CustomerName,
    ISNULL(Region, 'Not Specified') AS Region,
    ISNULL(Fax, 'No Fax') AS FaxNumber
FROM Customers;

-- ISNULL in calculations
SELECT 
    ProductID,
    ProductName,
    e.BaseSalary,
    ISNULL(UnitsInStock, 0) AS Stock,
    e.BaseSalary * ISNULL(UnitsInStock, 0) AS TotalValue
FROM Products;
```

### COALESCE Function
```sql
-- COALESCE returns first non-NULL value
SELECT 
    CustomerID,
    CustomerName,
    COALESCE(Region, City, CountryID, 'Unknown') AS Location
FROM Customers;

-- COALESCE with multiple columns
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COALESCE(HomePhone, Extension, 'No Phone') AS ContactNumber
FROM Employees e;
```

### NULLIF Function
```sql
-- NULLIF returns NULL if two expressions are equal
SELECT 
    ProductID,
    ProductName,
    NULLIF(UnitsInStock, 0) AS StockLevel,  -- NULL if stock is 0
    NULLIF(ReorderLevel, UnitsInStock) AS ReorderDifference
FROM Products;
```

## NULL in Conditional Logic

### CASE Expression with NULL
```sql
SELECT 
    CustomerID,
    CustomerName,
    Region,
    CASE 
        WHEN Region IS NULL THEN 'No Region Specified'
        WHEN Region = 'WA' THEN 'Washington State'
        WHEN Region = 'CA' THEN 'California'
        ELSE Region
    END AS RegionDescription
FROM Customers;
```

### IIF Function with NULL
```sql
-- IIF function for simple conditional logic
SELECT 
    ProductID,
    ProductName,
    UnitsInStock,
    IIF(UnitsInStock IS NULL, 'Unknown', 
        IIF(UnitsInStock = 0, 'Out of Stock', 'In Stock')) AS StockIsActive
FROM Products;
```

## NULL in Aggregations

### How Aggregates Handle NULL
```sql
-- Aggregate functions ignore NULL values
SELECT 
    COUNT(*) AS TotalProducts,           -- Counts all rows
    COUNT(UnitsInStock) AS ProductsWithStock,  -- Counts non-NULL values
    AVG(UnitsInStock) AS AverageStock,   -- Calculates average of non-NULL values
    SUM(UnitsInStock) AS TotalStock      -- Sums non-NULL values
FROM Products;

-- GROUP BY with NULL values
SELECT 
    Region,
    COUNT(*) AS CustomerCount
FROM Customers
GROUP BY Region;  -- NULL values form their own group
```

## Practical Examples

### Customer Contact Information
```sql
-- Build complete contact information handling NULLs
SELECT 
    CustomerID,
    CompanyName,
    CONCAT(ContactTitle, ' ', ContactName) AS FullContact,
    COALESCE(Phone, Fax, 'No Contact Available') AS PrimaryContact,
    CASE 
        WHEN Phone IS NOT NULL AND Fax IS NOT NULL 
            THEN 'Phone and Fax Available'
        WHEN Phone IS NOT NULL 
            THEN 'Phone Only'
        WHEN Fax IS NOT NULL 
            THEN 'Fax Only'
        ELSE 'No Contact Methods'
    END AS ContactAvailability
FROM Customers
ORDER BY CompanyName;
```

### Product Inventory Analysis
```sql
-- Analyze product inventory with NULL handling
SELECT 
    CategoryID,
    ProductName,
    e.BaseSalary,
    ISNULL(UnitsInStock, 0) AS CurrentStock,
    ISNULL(UnitsOnOrder, 0) AS OnOrder,
    ISNULL(UnitsInStock, 0) + ISNULL(UnitsOnOrder, 0) AS TotalAvailable,
    CASE 
        WHEN UnitsInStock IS NULL THEN 'Stock Unknown'
        WHEN UnitsInStock = 0 THEN 'Out of Stock'
        WHEN UnitsInStock < ReorderLevel THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockIsActive
FROM Products
WHERE Discontinued = 0
ORDER BY CategoryID, ProductName;
```

## Best Practices for NULL Handling

### 1. Always Use IS NULL/IS NOT NULL
```sql
-- Correct
WHERE Region IS NULL

-- Incorrect
WHERE Region = NULL
```

### 2. Consider NULL in Joins
```sql
-- Outer joins may introduce NULLs
SELECT 
    c.CustomerID,
    c.CustomerName,
    ISNULL(o.OrderDate, 'No Orders') AS LastOrderDate
FROM Customers c
LEFT JOIN (
    SELECT CustomerID, MAX(OrderDate) AS OrderDate
    FROM Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID;
```

### 3. Handle NULL in Calculated Columns
```sql
-- Always consider NULL in calculations
SELECT 
    ProductID,
    ProductName,
    e.BaseSalary,
    UnitsInStock,
    CASE 
        WHEN e.BaseSalary IS NULL OR UnitsInStock IS NULL 
            THEN NULL
        ELSE e.BaseSalary * UnitsInStock
    END AS InventoryValue
FROM Products;
```

### 4. Document NULL Policies
```sql
-- Be explicit about NULL handling in complex queries
SELECT 
    CustomerID,
    CustomerName,
    -- Region: NULL indicates no regional assignment
    ISNULL(Region, 'Unassigned') AS Region,
    -- PrimaryPhone: NULL indicates no PrimaryPhone number available
    ISNULL(PrimaryPhone, 'Not Available') AS PrimaryPhone
FROM Customers;
```

## Performance Considerations

### NULL and Indexes
- NULL values are not included in most index types
- Consider filtered indexes for columns with many NULLs
- NULL handling can affect query performance

### Efficient NULL Checks
```sql
-- Efficient NULL handling in WHERE clauses
SELECT CustomerID, CustomerName
FROM Customers
WHERE Region IS NOT NULL
  AND LEN(Region) > 0;  -- Also check for empty strings

-- Use ISNULL in SELECT rather than complex CASE
SELECT 
    CustomerID,
    ISNULL(Region, 'Unknown') AS Region  -- Faster than CASE
FROM Customers;
```

## Common Pitfalls and Solutions

### 1. String Concatenation Issues
```sql
-- Problem: NULL makes entire result NULL
SELECT e.FirstName + ' ' + e.LastName AS FullName
FROM Employees e;

-- Solution: Use CONCAT or handle NULLs
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName
FROM Employees e;

-- Alternative solution
SELECT ISNULL(e.FirstName, '') + ' ' + ISNULL(e.LastName, '') AS FullName
FROM Employees e;
```

### 2. Unexpected Results in Conditions
```sql
-- Problem: This might not return expected results
SELECT CustomerID, CompanyName FROM Customers
WHERE NOT (UnitsInStock > 10);

-- Solution: Handle NULL explicitly
SELECT CustomerID, CompanyName FROM Customers
WHERE UnitsInStock IS NULL OR UnitsInStock <= 10;
```

### 3. Aggregation Confusion
```sql
-- Understanding what these return
SELECT 
    COUNT(*) AS AllRows,           -- Includes rows with NULL
    COUNT(Region) AS NonNullRegions, -- Excludes NULL values
    AVG(UnitsInStock) AS AvgStock    -- Average of non-NULL values only
FROM Products;
```

## Summary
- NULL represents unknown or missing values
- Use IS NULL and IS NOT NULL for testing
- Aggregate functions ignore NULL values
- ISNULL, COALESCE, and NULLIF help handle NULL values
- Always consider NULL behavior in calculations and joins
- Document your NULL handling strategy for complex applications

## Practice Exercises
1. Find all customers who have no region specified
2. Calculate total inventory value, treating NULL stock as 0
3. Create a contact summary showing available contact methods
4. Identify products that need reordering (considering NULL values)
5. Build a comprehensive customer profile handling all NULL fields appropriately
