# Module 5 Exercises: Sorting and Filtering Data

## Exercise Set 1: Sorting Data (Lesson 1)

### Exercise 1.1: Basic Sorting Operations

**Scenario**: You need to create various sorted reports from the Northwind database.

**Tasks**:

1. Write a query to list all customers sorted by company name in ascending order.

2. Create a query showing all products sorted by unit price in descending order.

3. Write a query to display all employees sorted first by last name, then by first name.

4. Create a query showing orders sorted by order date (newest first), and for orders on the same date, sort by customer ID.

**Questions**:

1. What happens if you don't specify ASC or DESC in an ORDER BY clause?
2. Can you sort by columns that are not included in the SELECT list?
3. What is the performance impact of sorting large result sets?

### Exercise 1.2: Advanced Sorting Techniques

**Tasks**:

1. Write a query to sort products by category name, but show only product name and unit price in the results.

2. Create a query that sorts employees by hire date, but handles NULL values by showing them last.

3. Write a query using a CASE expression in ORDER BY to sort products as follows: First show discontinued products, then active products by price (highest first).

4. Create a query that sorts customers by country, but with 'USA' always appearing first, followed by other countries alphabetically.

**Questions**:

1. How can you control the sort order of NULL values?
2. When would you use a computed column in ORDER BY?
3. What are the limitations of ORDER BY in views?

### Exercise 1.3: Performance Considerations

**Scenario**: You're working with large datasets and need to optimize sorting performance.

**Tasks**:

1. Write a query that demonstrates the difference between sorting with and without an index.

2. Create an index on the Orders table to optimize sorting by OrderDate and CustomerID.

3. Write a query that combines WHERE clause filtering with ORDER BY to minimize sorting overhead.

**Questions**:

1. How do indexes help with ORDER BY performance?
2. What is the difference between clustered and non-clustered indexes for sorting?
3. When might sorting be performed in memory vs. on disk?

## Exercise Set 2: Filtering Data with Predicates (Lesson 2)

### Exercise 2.1: Basic WHERE Clause Operations

**Tasks**:

1. Write a query to find all products with a unit price greater than $20.

2. Create a query to find all customers from Germany or France.

3. Write a query to find all orders placed in 1997.

4. Create a query to find all employees whose first name starts with 'A'.

5. Write a query to find all products that have 'chocolate' anywhere in their name (case-insensitive).

**Questions**:

1. What is the difference between = and LIKE operators?
2. How does SQL Server handle case sensitivity in string comparisons?
3. What are the performance implications of using wildcards at the beginning of a LIKE pattern?

### Exercise 2.2: Complex Predicate Logic

**Tasks**:

1. Write a query to find products that are either discontinued OR have a unit price less than $10.

2. Create a query to find customers whose company name contains 'Restaurant' AND are from the USA.

3. Write a query to find orders placed between January 1, 1997, and December 31, 1997.

4. Create a query to find products with unit prices between $10 and $50, excluding those in the 'Beverages' category.

5. Write a query using NOT to find all customers who are NOT from Germany, France, or UK.

**Questions**:

1. What is the order of precedence for AND, OR, and NOT operators?
2. How do parentheses affect predicate evaluation?
3. When would you use BETWEEN vs. >= and <= operators?

### Exercise 2.3: Working with Sets and Ranges

**Tasks**:

1. Write a query using IN to find products in the 'Dairy Products', 'Seafood', and 'Beverages' categories.

2. Create a query using EXISTS to find customers who have placed at least one order.

3. Write a query using NOT EXISTS to find products that have never been ordered.

4. Create a query to find the top 3 most expensive products in each category.

**Questions**:

1. What is the difference between IN and EXISTS?
2. When would you use EXISTS instead of JOIN?
3. How does SQL Server optimize IN vs. OR comparisons?

## Exercise Set 3: Using TOP and OFFSET-FETCH (Lesson 3)

### Exercise 3.1: TOP Clause Fundamentals

**Tasks**:

1. Write a query to find the 5 most expensive products.

2. Create a query to find the top 10% of customers by total order value.

3. Write a query using TOP WITH TIES to find the highest-priced products, including ties.

4. Create a query to find the 3 most recent orders for each customer.

**Questions**:

1. What happens when you use TOP without ORDER BY?
2. How does TOP WITH TIES differ from just TOP?
3. What are the performance characteristics of TOP vs. LIMIT in other databases?

### Exercise 3.2: OFFSET-FETCH for Pagination

**Tasks**:

1. Write a query to implement pagination showing products 11-20 when ordered by product name.

2. Create a parameterized pagination solution for customer records with page size of 15.

3. Write a query that combines filtering with pagination to show the second page of products with unit price > $10.

4. Create a query that demonstrates the difference between TOP and OFFSET-FETCH for getting the "next 10" records.

**Questions**:

1. Why is OFFSET-FETCH preferred over TOP for pagination?
2. What is required when using OFFSET-FETCH?
3. How do you calculate OFFSET value for a given page number and page size?

### Exercise 3.3: Performance and Best Practices

**Tasks**:

1. Create queries comparing performance of TOP vs. OFFSET-FETCH for large result sets.

2. Write a query showing how to use OFFSET-FETCH with complex sorting criteria.

3. Create an efficient query for pagination that maintains consistent results even when data changes.

**Questions**:

1. What are the performance implications of large OFFSET values?
2. How can you ensure consistent pagination results when data is changing?
3. When would you use PERCENT with TOP?

## Exercise Set 4: Working with Unknown Values (Lesson 4)

### Exercise 4.1: Understanding NULL Values

**Tasks**:

1. Write a query to find all customers where the Region field is NULL.

2. Create a query to find employees where both City and Region are NOT NULL.

3. Write a query to count how many customers have NULL values in the Fax field.

4. Create a query showing the difference between COUNT(*) and COUNT(column) with NULL values.

**Questions**:

1. What is the difference between NULL and an empty string?
2. How does NULL affect aggregate functions?
3. Why can't you use = or <> to compare with NULL?

### Exercise 4.2: Working with NULL Values

**Tasks**:

1. Write a query using ISNULL to replace NULL Region values with 'Not Specified'.

2. Create a query using COALESCE to handle multiple potentially NULL columns.

3. Write a query using NULLIF to convert empty strings to NULL values.

4. Create a query that handles NULL values in calculations without getting NULL results.

**Questions**:

1. What is the difference between ISNULL and COALESCE?
2. When would you use NULLIF?
3. How do NULL values affect sorting operations?

### Exercise 4.3: Advanced NULL Handling

**Tasks**:

1. Write a query that joins tables and handles cases where foreign key values might be NULL.

2. Create a query using CASE to provide different default values for NULL based on other column values.

3. Write a query that aggregates data while treating NULL values as zero for calculations.

4. Create a query that finds records where a combination of columns has all NULL values.

**Questions**:

1. How do NULL values affect JOIN operations?
2. What is the behavior of GROUP BY with NULL values?
3. How can you include NULL values in statistical calculations?

## Practical Scenarios

### Scenario 1: Customer Analysis Report

You need to create a comprehensive customer analysis report with the following requirements:

1. Show customers sorted by country (USA first, then alphabetically)
2. Include only customers who have placed orders
3. Filter for customers with total order value > $1000
4. Handle missing region information appropriately
5. Implement pagination with 20 customers per page

Write the complete query solution.

### Scenario 2: Product Inventory Management

Create queries for an inventory management system:

1. Find products that are running low (UnitsInStock < ReorderLevel)
2. Sort by category and stock level (lowest first)
3. Exclude discontinued products
4. Show only the top 15 products that need reordering
5. Handle cases where ReorderLevel might be NULL

### Scenario 3: Sales Performance Dashboard

Design queries for a sales dashboard:

1. Find the top 10 customers by total order value in the last 6 months
2. Show results with proper pagination
3. Handle cases where customer information might be incomplete
4. Sort by total value (highest first), then by customer name
5. Include customers with at least 3 orders

## Review Questions

### Multiple Choice

1. Which ORDER BY clause will sort products by price from highest to lowest?
   a) ORDER BY UnitPrice
   b) ORDER BY UnitPrice ASC
   c) ORDER BY UnitPrice DESC
   d) ORDER BY UnitPrice HIGH

2. What does the TOP 10 PERCENT clause return?
   a) Exactly 10 records
   b) 10% of all records in the table
   c) The top 10% of records based on ORDER BY
   d) An error if there are less than 10 records

3. Which operator should you use to find NULL values?
   a) = NULL
   b) == NULL
   c) IS NULL
   d) EQUALS NULL

4. What is required when using OFFSET-FETCH?
   a) A WHERE clause
   b) An ORDER BY clause
   c) A GROUP BY clause
   d) A HAVING clause

5. How do NULL values sort by default?
   a) They appear first
   b) They appear last
   c) They cause an error
   d) They are ignored

### Short Answer

1. Explain the difference between TOP and OFFSET-FETCH for pagination scenarios.

2. How do AND, OR, and NOT operators work with NULL values?

3. What are the performance implications of using wildcards in LIKE patterns?

4. When would you use COALESCE instead of ISNULL?

5. How does the NULLS FIRST/NULLS LAST option work in ORDER BY?

### Practical Tasks

1. Write a query that finds the second-highest priced product in each category.

2. Create a pagination solution that shows products 21-40 when sorted by product name, excluding discontinued products.

3. Write a query that safely performs calculations with potentially NULL values.

4. Create a query that implements a search feature with multiple optional filter criteria.

5. Design a solution for handling missing data in customer addresses when generating mailing labels.

## Case Studies

### Case Study 1: E-commerce Search Implementation

You're implementing search functionality for an e-commerce site. The search needs to:

- Allow filtering by price range, category, and availability
- Support text search in product names and descriptions
- Handle missing product information gracefully
- Provide proper sorting options (price, name, rating)
- Implement pagination for large result sets

Design the complete query structure with proper NULL handling and performance considerations.

### Case Study 2: Reporting System Optimization

Your reporting system is running slowly due to large datasets. You need to:

- Optimize sorting operations on million-row tables
- Implement efficient pagination
- Handle complex filtering requirements
- Deal with incomplete data in legacy systems
- Provide consistent results even when data changes

Develop a strategy for optimizing these queries while maintaining data integrity.

### Case Study 3: Data Quality Assessment

You're tasked with assessing data quality in a customer database:

- Identify records with missing critical information
- Find inconsistencies in data formats
- Locate duplicate or near-duplicate records
- Generate reports on data completeness
- Provide recommendations for data cleanup

Create queries that help identify and quantify data quality issues.