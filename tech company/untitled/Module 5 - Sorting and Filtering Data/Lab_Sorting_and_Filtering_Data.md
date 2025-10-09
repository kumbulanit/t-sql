# Lab: Sorting and Filtering Data - TechCorp Solutions

## Lab Overview
This lab provides hands-on practice with sorting data, filtering with predicates, using TOP and OFFSET-FETCH, and working with NULL values. You'll work with the TechCorp Solutions database to complete various data retrieval scenarios that progress from simple to complex filtering operations.

## Prerequisites
- Access to SQL Server with TechCorpDB database (created in Module 1)
- Completion of Module 5 Lessons 1-4
- Understanding of basic SELECT statements and TechCorp business context

## Lab Setup
```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Verify TechCorp data is available and show data complexity progression
SELECT 'Companies' as TableName, COUNT(*) AS RecordCount FROM Companies
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees  
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'Skills', COUNT(*) FROM Skills
UNION ALL
SELECT 'EmployeeProjects', COUNT(*) FROM EmployeeProjects;

-- Show data type diversity for filtering exercises
SELECT 
    'Sample data types for filtering' as Info,
    MIN(e.BaseSalary) as MinSalary,
    MAX(e.BaseSalary) as MaxSalary,
    MIN(HireDate) as EarliestHire,
    MAX(HireDate) as LatestHire,
    COUNT(CASE WHEN TerminationDate IS NULL THEN 1 END) as ActiveEmployees,
    COUNT(CASE WHEN TerminationDate IS NOT NULL THEN 1 END) as FormerEmployees
FROM Employees e;
```

## Exercise 1: Basic Sorting Operations - TechCorp Employee Data

### Task 1.1: Simple Sorting (Basic Complexity)

Write queries to sort TechCorp employee data using ORDER BY clause.

```sql
-- TODO: Sort all employees by last name alphabetically
-- Expected: Employees listed A to Z by last name
SELECT EmployeeID, FirstName, LastName, JobTitle, BaseSalary
FROM Employees
WHERE IsActive = 1
ORDER BY LastName;

-- TODO: Sort all employees by BaseSalary from highest to lowest  
-- Expected: Highest paid employees first
SELECT EmployeeID, FirstName, LastName, JobTitle, BaseSalary
FROM Employees  
WHERE IsActive = 1
ORDER BY BaseSalary DESC;

-- TODO: Sort employees by hire date, newest first
-- Expected: Most recently hired employees at the top
SELECT EmployeeID, FirstName, LastName, HireDate, JobTitle
FROM Employees
WHERE IsActive = 1
ORDER BY HireDate DESC;
```

### Task 1.2: Multi-Level Sorting (Moderate Complexity)

Write queries using multiple columns in ORDER BY with TechCorp organizational data.

```sql
-- TODO: Sort employees by company, then by d.DepartmentName within each company
-- Expected: Companies in order, departments alphabetically within each company
SELECT 
    c.CompanyName,
    d.DepartmentName,
    e.FirstName,
    e.LastName,
    e.JobTitle
FROM Employees e
    INNER JOIN Companies c ON e.CompanyID = c.CompanyID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
ORDER BY c.CompanyName, d.DepartmentName;

-- TODO: Sort employees by job level, then by BaseSalary (highest first) within each level
-- Expected: Job levels in hierarchy order, high salaries first in each level
SELECT 
    jl.LevelName,
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    e.JobTitle
FROM Employees e
    INNER JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
WHERE e.IsActive = 1
ORDER BY jl.AuthorityLevel DESC, e.BaseSalary DESC;


-- TODO: Sort orders by customer, then by order date (newest first) for each customer
-- Expected: Customers alphabetically, recent orders first for each customer
```

### Task 1.3: Advanced Sorting
Practice sorting with expressions and conditional logic.

```sql
-- TODO: Sort products by total inventory value (BaseSalary * UnitsInStock) descending
-- Handle NULL values appropriately


-- TODO: Sort customers by the length of their company name, shortest first
-- Expected: Companies with shorter names appear first


-- TODO: Sort employees by age (calculate from birth date), oldest first
-- Expected: Senior employees listed first
```

## Exercise 2: Filtering with Predicates

### Task 2.1: Basic WHERE Clauses
Practice fundamental filtering operations.

```sql
-- TODO: Find all customers from Germany
-- Expected: Only German customers


-- TODO: Find all products with unit price greater than $20
-- Expected: Only expensive products


-- TODO: Find all orders placed in 1997
-- Expected: Only orders from 1997
```

### Task 2.2: Advanced Filtering
Use complex predicates and multiple conditions.

```sql
-- TODO: Find customers from USA or Canada with 'Sales' in their contact title
-- Expected: North American sales contacts only


-- TODO: Find products that are discontinued OR have less than 10 units in stock
-- Expected: Products that are either discontinued or low stock


-- TODO: Find orders with freight cost between $50 and $100, shipped via shipper 2
-- Expected: Moderate freight orders via specific shipper
```

### Task 2.3: Pattern Matching and Lists
Use LIKE, IN, and BETWEEN operators.

```sql
-- TODO: Find all customers whose company name starts with 'A' and ends with 's'
-- Expected: Company names like "Around the Horn", etc.


-- TODO: Find products from categories 1, 3, or 7 with names containing 'cheese'
-- Expected: Cheese products from specific categories


-- TODO: Find employees hired between January 1, 1993 and December 31, 1994
-- Expected: Employees hired during that 2-year period
```

## Exercise 3: TOP and OFFSET-FETCH

### Task 3.1: Using TOP Clause
Practice limiting result sets with TOP.

```sql
-- TODO: Get the top 5 most expensive products
-- Expected: 5 products with highest unit prices


-- TODO: Get the top 10% of customers by alphabetical order
-- Expected: First 10% of customers when sorted by name


-- TODO: Get the top 3 orders with highest freight costs
-- Expected: 3 orders with most expensive shipping
```

### Task 3.2: OFFSET-FETCH for Pagination
Implement pagination using OFFSET-FETCH.

```sql
-- TODO: Get products 11-20 when sorted by product name
-- Expected: Second page of products (10 per page)


-- TODO: Get customers 21-30 when sorted by customer ID
-- Expected: Third page of customers (10 per page)


-- TODO: Get orders 51-75 when sorted by order date (newest first)
-- Expected: Page 3 of orders (25 per page), most recent first
```

### Task 3.3: Advanced Pagination Scenarios
Handle complex pagination requirements.

```sql
-- TODO: Create a paging solution for products by category
-- Show page 2 (rows 6-10) of products in category 1, sorted by product name


-- TODO: Implement pagination for customer orders
-- Show orders 11-15 for customer 'ALFKI', sorted by order date


-- TODO: Create a "random sampling" query using TOP and NEWID()
-- Get 5 random products from the database
```

## Exercise 4: Working with NULL Values

### Task 4.1: Identifying NULL Values
Practice finding and handling NULL values.

```sql
-- TODO: Find all customers who don't have a region specified
-- Expected: Customers with NULL region


-- TODO: Find all products where units in stock is unknown (NULL)
-- Expected: Products with NULL UnitsInStock


-- TODO: Find employees who don't have a reports-to manager
-- Expected: Top-level employees (NULL ReportsTo)
```

### Task 4.2: Handling NULL in Calculations
Work with NULL values in expressions and functions.

```sql
-- TODO: Calculate total inventory value for all products
-- Treat NULL stock as 0, NULL price as 0
-- Expected: Sum of (BaseSalary * UnitsInStock) with NULL handling


-- TODO: Create a contact summary for customers
-- Show phone if available, otherwise fax, otherwise 'No Contact'
-- Expected: Best available contact method for each customer


-- TODO: Calculate employee tenure in years
-- Handle cases where hire date might be NULL
-- Expected: Years of service or 'Unknown' for NULL dates
```

### Task 4.3: Advanced NULL Scenarios
Complex NULL handling in real-world scenarios.

```sql
-- TODO: Create a product availability report
-- Show product name, current stock, on order, and availability status
-- IsActive: 'In Stock', 'Out of Stock', 'Stock Unknown', 'Discontinued'


-- TODO: Build a customer communication matrix
-- Show which customers have phone, fax, both, or neither
-- Expected: Communication availability analysis


-- TODO: Analyze order shipping performance
-- Compare required date vs shipped date, handling NULL shipped dates
-- Expected: On-time, late, not shipped, or unknown status
```

## Exercise 5: Integration Challenges

### Task 5.1: Complex Data Retrieval
Combine sorting, filtering, and NULL handling.

```sql
-- TODO: Top 10 customers by total order value
-- Calculate total value per customer, sort descending, handle NULLs
-- Show customer name and total order value


-- TODO: Product reorder analysis
-- Find products where (UnitsInStock + UnitsOnOrder) < ReorderLevel
-- Sort by urgency (lowest stock first), handle NULL values appropriately


-- TODO: Employee performance dashboard
-- Show employees with their territory, total orders handled, and performance tier
-- Performance tiers: 'High' (>100 orders), 'Medium' (50-100), 'Low' (<50), 'New' (NULL)
```

### Task 5.2: Pagination with Complex Queries
Implement pagination on complex result sets.

```sql
-- TODO: Paginated customer order history
-- Show page 2 (orders 11-20) of all customer orders with customer info
-- Sort by order date descending, 10 orders per page


-- TODO: Product catalog with pagination
-- Create a product catalog showing page 3 (products 21-30)
-- Include category name, supplier info, handle NULLs appropriately
-- Sort by category, then product name


-- TODO: Advanced sales report with pagination
-- Show top-selling products (by quantity) with pagination
-- Include running totals, handle ties appropriately
-- Show products 6-10 of the top sellers
```

## Exercise 6: Performance and Optimization

### Task 6.1: Efficient Sorting and Filtering
Write performance-optimized queries.

```sql
-- TODO: Optimize a customer search query
-- Find customers by partial company name match (case-insensitive)
-- Ensure the query can use indexes effectively


-- TODO: Efficient product lookup
-- Find products by category and price range
-- Write the query to optimize index usage


-- TODO: Optimized order history query
-- Get recent orders for a customer with pagination
-- Ensure efficient execution with proper indexing strategy
```

## Challenge Exercises

### Challenge 1: Dynamic Sorting Report
Create a flexible report that can sort by different criteria.

```sql
-- TODO: Create a parameterized query that can sort customers by:
-- 1. Company name (A-Z or Z-A)
-- 2. Country then city
-- 3. Number of orders (high to low)
-- Use variables to control sort behavior
```

### Challenge 2: Advanced Pagination System
Build a complete pagination system with metadata.

```sql
-- TODO: Create a stored procedure for product pagination that returns:
-- 1. The requested page of products
-- 2. Total number of products
-- 3. Total number of pages
-- 4. Current page number
-- 5. Has next/previous page indicators
```

### Challenge 3: Comprehensive NULL Analysis
Perform a complete NULL analysis across multiple tables.

```sql
-- TODO: Create a data quality report showing:
-- 1. Percentage of NULL values in each nullable column
-- 2. Tables with the most NULL values
-- 3. Impact of NULLs on business calculations
-- 4. Recommendations for data cleanup
```

## Verification and Testing

### Expected Results Validation
Use these queries to verify your solutions:

```sql
-- Verify sorting results
SELECT TOP 5 CustomerID, CompanyName 
FROM Customers 
ORDER BY CompanyName;

-- Verify filtering results
SELECT COUNT(*) as GermanCustomers 
FROM Customers 
WHERE Country = 'Germany';

-- Verify pagination
SELECT COUNT(*) as TotalProducts FROM Products;
-- Should help validate your OFFSET-FETCH calculations

-- Verify NULL handling
SELECT 
    COUNT(*) as TotalCustomers,
    COUNT(Region) as CustomersWithRegion,
    COUNT(*) - COUNT(Region) as CustomersWithoutRegion
FROM Customers;
```

## Lab Completion Checklist

### Basic Requirements (Must Complete)
- [ ] Exercise 1: All basic sorting tasks completed
- [ ] Exercise 2: All filtering tasks completed  
- [ ] Exercise 3: All TOP and OFFSET-FETCH tasks completed
- [ ] Exercise 4: All NULL handling tasks completed
- [ ] All queries execute without errors
- [ ] Results match expected outputs

### Advanced Requirements (Recommended)
- [ ] Exercise 5: Integration challenges completed
- [ ] Exercise 6: Performance optimization completed
- [ ] At least one challenge exercise completed
- [ ] Code is well-commented and follows best practices

### Expert Level (Optional)
- [ ] All challenge exercises completed
- [ ] Additional creative solutions developed
- [ ] Performance analysis conducted
- [ ] Documentation of lessons learned

## Troubleshooting Common Issues

### Sorting Issues
- Remember that NULL values sort differently in ascending vs descending order
- Text sorting is case-sensitive by default (depends on collation)
- Date/time sorting requires proper data types

### Filtering Issues
- Use single quotes for string literals
- Remember that = NULL doesn't work (use IS NULL)
- LIKE patterns are case-sensitive by default

### Pagination Issues
- OFFSET-FETCH requires ORDER BY clause
- Row counts start at 0 for OFFSET
- FETCH NEXT is required with OFFSET

### NULL Handling Issues
- Any arithmetic with NULL results in NULL
- Concatenation with NULL results in NULL (use CONCAT function)
- COUNT(*) includes NULLs, COUNT(column) excludes NULLs

## Additional Resources
- SQL Server Books Online: ORDER BY clause
- SQL Server Documentation: TOP clause
- MSDN: OFFSET-FETCH pagination
- Best practices for NULL handling in T-SQL

## Lab Assessment
This lab will be assessed on:
1. Correctness of query results (40%)
2. Proper use of T-SQL syntax (25%)
3. Efficient query design (20%)
4. Code documentation and readability (15%)

Remember to test all queries thoroughly and verify results match expectations!
