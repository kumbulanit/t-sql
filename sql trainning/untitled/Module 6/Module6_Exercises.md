# Module 6 Exercises: Working with SQL Server 2016 Data Types

## Exercise Set 1: Introducing SQL Server 2016 Data Types (Lesson 1)

### Exercise 1.1: Data Type Fundamentals

**Scenario**: You're designing a new database for a company and need to choose appropriate data types for various columns.

**Tasks**:

1. Create a table for storing employee information with appropriate data types for:
   - Employee ID (auto-incrementing)
   - First Name and Last Name
   - Salary (with 2 decimal places)
   - Hire Date
   - Is Active (yes/no)
   - Profile Photo

2. Write queries to demonstrate the storage size differences between VARCHAR(50) and NVARCHAR(50).

3. Create examples showing the precision and scale for DECIMAL data types.

4. Demonstrate the range limitations of different integer types (TINYINT, SMALLINT, INT, BIGINT).

**Questions**:

1. What is the difference between exact numeric and approximate numeric data types?
2. When would you choose VARCHAR over CHAR?
3. How does Unicode support affect storage requirements?
4. What are the implications of choosing the wrong data type?

### Exercise 1.2: Data Type Categories

**Tasks**:

1. Create a comprehensive table showing examples of each major data type category:
   - Exact numeric types
   - Approximate numeric types
   - Date and time types
   - Character string types
   - Unicode character string types
   - Binary string types

2. Write queries to demonstrate implicit conversions between compatible data types.

3. Create examples showing when explicit conversion is required using CAST and CONVERT.

4. Demonstrate the behavior of data type precedence in expressions.

**Questions**:

1. What is data type precedence and why is it important?
2. How does SQL Server handle mixed data types in expressions?
3. What are the risks of implicit conversions?
4. When should you use CAST vs. CONVERT?

### Exercise 1.3: Choosing Appropriate Data Types

**Scenario**: You're reviewing an existing database design and need to optimize data type choices.

**Tasks**:

1. Analyze a poorly designed table and recommend better data type choices:
   ```sql
   CREATE TABLE BadExample (
       ID NVARCHAR(100),
       Age NVARCHAR(10),
       Salary NVARCHAR(20),
       HireDate NVARCHAR(30),
       IsActive NVARCHAR(5)
   );
   ```

2. Create a script to safely migrate data from the bad design to a better design.

3. Calculate the storage space savings from the improved design.

4. Write queries showing performance differences between the two designs.

**Questions**:

1. What are the performance implications of using inappropriate data types?
2. How do you plan for future data growth when choosing data types?
3. What considerations are important for international applications?
4. How do data types affect indexing strategies?

## Exercise Set 2: Working with Character Data (Lesson 2)

### Exercise 2.1: String Data Types and Storage

**Tasks**:

1. Create examples comparing CHAR, VARCHAR, NCHAR, and NVARCHAR:
   - Storage behavior with different string lengths
   - Performance characteristics
   - Use case scenarios

2. Write queries demonstrating the behavior of trailing spaces with CHAR vs VARCHAR.

3. Create a table to test and compare storage requirements for different character data types.

4. Demonstrate the differences between VARCHAR(MAX) and VARCHAR(8000).

**Questions**:

1. When should you use fixed-length vs. variable-length character types?
2. How do trailing spaces affect comparisons and indexing?
3. What are the limitations of MAX data types?
4. How does page compression affect character data storage?

### Exercise 2.2: String Functions and Manipulation

**Tasks**:

1. Write queries using various string functions:
   - LEN() vs. DATALENGTH()
   - LEFT(), RIGHT(), SUBSTRING()
   - LTRIM(), RTRIM(), TRIM()
   - UPPER(), LOWER()
   - REPLACE(), STUFF()

2. Create a query to clean and standardize customer names:
   - Remove extra spaces
   - Proper case formatting
   - Handle special characters

3. Write functions to validate and format data:
   - Phone number formatting
   - Email address validation
   - Postal code formatting

4. Demonstrate string concatenation methods:
   - + operator
   - CONCAT() function
   - STRING_AGG() function (SQL Server 2017+)

**Questions**:

1. What's the difference between LEN() and DATALENGTH()?
2. How do string functions handle NULL values?
3. What are the performance considerations for string manipulation?
4. When would you use LIKE vs. string functions for pattern matching?

### Exercise 2.3: Collation and Cultural Considerations

**Tasks**:

1. Demonstrate the effects of different collations on sorting and comparison:
   - Case sensitivity
   - Accent sensitivity
   - Culture-specific sorting rules

2. Create queries showing collation conflicts and how to resolve them.

3. Write examples of using COLLATE clause in queries.

4. Demonstrate Unicode handling for international character sets.

**Questions**:

1. What is collation and why is it important?
2. How do you handle collation conflicts in JOINs?
3. What are the performance implications of changing collation in queries?
4. How does collation affect indexing?

## Exercise Set 3: Working with Date and Time Data (Lesson 3)

### Exercise 3.1: Date and Time Data Types

**Tasks**:

1. Create examples of all date and time data types:
   - DATE
   - TIME
   - DATETIME
   - DATETIME2
   - SMALLDATETIME
   - DATETIMEOFFSET

2. Compare storage requirements and precision for each type.

3. Demonstrate the valid ranges for each date and time data type.

4. Show examples of time zone handling with DATETIMEOFFSET.

**Questions**:

1. When would you choose DATETIME vs. DATETIME2?
2. What are the benefits of using separate DATE and TIME types?
3. How does DATETIMEOFFSET help with global applications?
4. What are the performance implications of higher precision date types?

### Exercise 3.2: Date and Time Functions

**Tasks**:

1. Write queries using date/time functions:
   - GETDATE(), GETUTCDATE(), SYSDATETIME()
   - YEAR(), MONTH(), DAY()
   - DATEPART(), DATENAME()
   - DATEADD(), DATEDIFF()
   - ISDATE()

2. Create queries for common date calculations:
   - Age calculation
   - Business days between dates
   - End of month/quarter/year
   - Date ranges and intervals

3. Demonstrate working with different date formats:
   - Converting between string and date formats
   - Handling international date formats
   - Using SET DATEFORMAT

4. Write queries for date-based reporting:
   - Year-over-year comparisons
   - Monthly summaries
   - Quarterly reports

**Questions**:

1. What's the difference between GETDATE() and SYSDATETIME()?
2. How do you ensure date calculations are accurate across time zones?
3. What are the performance implications of date functions in WHERE clauses?
4. How do you handle leap years in date calculations?

### Exercise 3.3: Advanced Date and Time Scenarios

**Tasks**:

1. Create a calendar table with the following features:
   - All dates for a 10-year period
   - Day of week, month, quarter, year
   - Business day indicators
   - Holiday flags

2. Write queries for complex date scenarios:
   - Finding the last business day of each month
   - Calculating elapsed time excluding weekends
   - Working with fiscal years vs. calendar years
   - Time zone conversions

3. Demonstrate date validation and error handling:
   - Validating date ranges
   - Handling invalid dates
   - Managing date format inconsistencies

4. Create efficient date-based queries:
   - Using date ranges in WHERE clauses
   - Optimizing date comparisons
   - Indexing strategies for date columns

**Questions**:

1. Why are calendar tables useful for reporting?
2. How do you optimize queries with date ranges?
3. What are the best practices for storing historical time zone data?
4. How do you handle date arithmetic across different time zones?

## Exercise Set 4: Advanced Data Type Features

### Exercise 4.1: Working with Large Data Types

**Tasks**:

1. Create examples using MAX data types:
   - VARCHAR(MAX)
   - NVARCHAR(MAX)
   - VARBINARY(MAX)

2. Demonstrate storage and performance characteristics of MAX types.

3. Write queries working with large text documents:
   - Searching within large text fields
   - Extracting portions of large text
   - Performance considerations

4. Show examples of streaming large data types.

**Questions**:

1. When should you use MAX data types vs. fixed-size types?
2. What are the limitations of MAX data types?
3. How do MAX types affect backup and recovery?
4. What are the indexing limitations with MAX types?

### Exercise 4.2: Working with Binary Data

**Tasks**:

1. Create examples storing and retrieving binary data:
   - Images
   - Documents
   - Encrypted data

2. Demonstrate the differences between BINARY, VARBINARY, and VARBINARY(MAX).

3. Write queries for binary data manipulation:
   - Converting between binary and other types
   - Checksums and hashing
   - Binary comparisons

4. Show examples of FILESTREAM data (if available).

**Questions**:

1. When should you store binary data in the database vs. file system?
2. What are the performance implications of large binary data?
3. How does binary data affect database size and backups?
4. What are the security considerations for binary data storage?

### Exercise 4.3: JSON Support (SQL Server 2016+)

**Tasks**:

1. Create examples of storing JSON data in VARCHAR or NVARCHAR columns.

2. Write queries using JSON functions:
   - JSON_VALUE()
   - JSON_QUERY()
   - ISJSON()
   - JSON_MODIFY()

3. Demonstrate parsing complex JSON structures.

4. Create indexes on JSON data for better performance.

**Questions**:

1. What are the benefits and limitations of storing JSON in SQL Server?
2. How do you optimize queries against JSON data?
3. When would you choose JSON over normalized tables?
4. What are the validation options for JSON data?

## Practical Scenarios

### Scenario 1: E-commerce Database Design

Design the data types for an e-commerce database with the following entities:

**Products Table**:
- Product ID
- Product Name (up to 200 characters)
- Description (potentially very long)
- Price (currency with 4 decimal places)
- Weight (to 3 decimal places)
- Dimensions (length, width, height)
- Created Date
- Modified Date
- Is Active

**Customers Table**:
- Customer ID
- First Name, Last Name
- Email Address
- Phone Number (international support)
- Date of Birth
- Registration Date
- Last Login
- Profile Picture
- Preferred Language

Justify your data type choices and show sample CREATE TABLE statements.

### Scenario 2: Financial Application Data Types

You're working on a financial application that needs to handle:

1. **Currency values** with exact precision
2. **International transactions** with different currencies
3. **Historical exchange rates** with timestamps
4. **Account numbers** that may contain letters and numbers
5. **Transaction descriptions** in multiple languages
6. **Audit trails** with very precise timestamps

Design appropriate data types and demonstrate calculations that maintain precision.

### Scenario 3: Multi-tenant SaaS Application

Design data types for a multi-tenant application where:

1. **Tenant isolation** is critical
2. **Different tenants** may have different cultural requirements
3. **Data volumes** vary significantly between tenants
4. **Compliance requirements** vary by geography
5. **Performance** must be consistent across tenants

Show how data type choices support these requirements.

## Review Questions

### Multiple Choice

1. Which data type provides the highest precision for storing currency values?
   a) FLOAT
   b) REAL
   c) DECIMAL(19,4)
   d) MONEY

2. What is the storage size of NVARCHAR(50)?
   a) 50 bytes
   b) 100 bytes
   c) Up to 100 bytes plus 2 bytes overhead
   d) 102 bytes

3. Which date type has the highest precision?
   a) DATETIME
   b) DATETIME2(7)  
   c) SMALLDATETIME
   d) DATETIMEOFFSET

4. What happens when you insert a string longer than the column's defined length?
   a) The data is truncated
   b) An error occurs
   c) The column automatically resizes
   d) Depends on the ANSI settings

5. Which function returns the number of characters in a string?
   a) DATALENGTH()
   b) LEN()
   c) LENGTH()
   d) SIZE()

### Short Answer

1. Explain the difference between CHAR and VARCHAR data types and when to use each.

2. What are the advantages and disadvantages of using Unicode data types?

3. How do you choose between DATETIME and DATETIME2 for new applications?

4. What factors should influence your choice of precision for DECIMAL data types?

5. Explain the concept of data type precedence and provide an example.

### Practical Tasks

1. Write a script to analyze the data type usage in an existing database and identify potential optimizations.

2. Create a function to safely convert strings to dates with proper error handling.

3. Design a table structure for storing product reviews that supports multiple languages.

4. Write queries to demonstrate the performance difference between appropriate and inappropriate data type choices.

5. Create a comprehensive data validation routine for a user registration form.

## Case Studies

### Case Study 1: Legacy System Migration

You're migrating from an old system where everything was stored as VARCHAR. The new system needs:

- Proper data types for performance and storage efficiency
- Data validation and conversion routines
- Handling of invalid data from the legacy system
- Maintaining data integrity during migration
- Performance optimization through better data types

Develop a complete migration strategy with specific data type recommendations.

### Case Study 2: International Application

Your application needs to support:

- Multiple languages and character sets
- Different date formats and calendars
- Various currency formats and precision requirements
- Cultural sorting and comparison rules
- Time zone handling across global operations

Design a data type strategy that supports these international requirements.

### Case Study 3: High-Performance Analytics

You're building a high-performance analytics system that processes:

- Billions of rows of transaction data
- Real-time data feeds requiring fast inserts
- Complex aggregations and calculations
- Historical data with changing schemas over time
- Mixed workloads (OLTP and analytics)

Optimize data type choices for performance while maintaining data integrity and accuracy.