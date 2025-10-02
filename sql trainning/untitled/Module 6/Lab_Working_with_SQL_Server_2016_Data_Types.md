# Lab: Working with SQL Server 2016 Data Types

## Lab Overview
This comprehensive lab provides hands-on practice with SQL Server 2016 data types, including numeric types, character data, and date/time data. You'll work through real-world scenarios that demonstrate proper data type selection, manipulation, and optimization techniques.

## Prerequisites
- Access to SQL Server 2016 or later
- Completion of Module 6 Lessons 1-3
- Basic understanding of T-SQL syntax
- Familiarity with database design concepts

## Lab Setup

### Database and Table Creation
```sql
-- Create a sample database for the lab
USE master;
GO

-- Drop database if it exists
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'DataTypesLab')
    DROP DATABASE DataTypesLab;
GO

-- Create the lab database
CREATE DATABASE DataTypesLab;
GO

USE DataTypesLab;
GO

-- Verify database creation
SELECT 
    name AS DatabaseName,
    database_id,
    create_date,
    collation_name
FROM sys.databases 
WHERE name = 'DataTypesLab';
```

## Exercise 1: Numeric Data Types

### Task 1.1: Design an Employee Table with Appropriate Numeric Types
Create a table that demonstrates proper numeric data type selection.

```sql
-- TODO: Create an Employees table with the following requirements:
-- 1. EmployeeID: Auto-incrementing integer, primary key
-- 2. Age: Supports ages 0-150
-- 3. DepartmentCode: Supports codes 1-9999
-- 4. Salary: Supports salaries up to $999,999.99 with exact precision
-- 5. BonusPercentage: Supports percentages like 12.5% (stored as 0.125)
-- 6. CommissionRate: Supports rates up to 99.9999% with high precision
-- 7. YearsOfService: Supports 0-50 years
-- 8. PerformanceScore: Supports decimal scores 0.00-100.00

CREATE TABLE Employees (
    -- Your solution here
    
    
    
    
    
    
    
    
);
```

### Task 1.2: Insert and Validate Numeric Data
```sql
-- TODO: Insert the following employee records:
-- 1. John Smith, Age 35, Dept 1001, Salary $75,000, Bonus 15%, Commission 5.25%, 8 years service, Score 87.5
-- 2. Jane Doe, Age 29, Dept 2050, Salary $92,500.50, Bonus 12.5%, Commission 7.1234%, 5 years service, Score 94.25
-- 3. Bob Johnson, Age 42, Dept 1500, Salary $65,750.75, Bonus 10%, Commission 3.8956%, 12 years service, Score 78.9

-- Your solution here




-- TODO: Write a query to display all employees with formatted output
-- Show salary with currency formatting, percentages with % symbol, and scores with 1 decimal place

-- Your solution here


```

### Task 1.3: Numeric Calculations and Conversions
```sql
-- TODO: Create a query that calculates:
-- 1. Annual bonus amount (Salary * BonusPercentage)
-- 2. Monthly commission potential (Salary * CommissionRate / 12)
-- 3. Total annual compensation (Salary + Bonus)
-- 4. Average performance score per department
-- 5. Salary range (min and max) per department

-- Your solution here





```

## Exercise 2: Character Data Types

### Task 2.1: Design a Product Catalog with Character Data
```sql
-- TODO: Create a Products table with these requirements:
-- 1. ProductID: Auto-incrementing primary key
-- 2. ProductCode: Fixed 8-character code (format: AB123456)
-- 3. ProductName: Variable-length name up to 100 characters (international support)
-- 4. ShortDescription: Variable-length up to 255 characters
-- 5. LongDescription: Large text field for detailed descriptions
-- 6. Category: Fixed 3-character category code
-- 7. Manufacturer: Variable-length up to 50 characters
-- 8. CountryOfOrigin: Fixed 2-character country code
-- 9. Keywords: Variable-length search keywords

CREATE TABLE Products (
    -- Your solution here
    
    
    
    
    
    
    
    
);
```

### Task 2.2: Character Data Validation and Constraints
```sql
-- TODO: Add constraints to the Products table:
-- 1. ProductCode must follow pattern: 2 letters + 6 digits
-- 2. ProductName cannot be empty and must be at least 3 characters
-- 3. Category must be exactly 3 uppercase letters
-- 4. CountryOfOrigin must be exactly 2 uppercase letters
-- 5. LongDescription must be at least 20 characters when provided

-- Your solution here






-- TODO: Insert sample product data to test your constraints:
-- Valid products:
-- 1. Code: AB123456, Name: "Wireless Bluetooth Headphones", Category: ELE, Country: US
-- 2. Code: XY789012, Name: "Ergonomic Office Chair", Category: FUR, Country: DE
-- Invalid attempts (should fail):
-- 3. Code: 123ABCD (wrong format), Name: "Test", Category: ele (lowercase), Country: usa (3 chars)

-- Your solution here




```

### Task 2.3: String Manipulation and Analysis
```sql
-- TODO: Write queries to demonstrate string functions:
-- 1. Extract the letter prefix and numeric suffix from ProductCode
-- 2. Create a display name combining first 3 chars of category with product name
-- 3. Count the number of words in ProductName
-- 4. Find products with names containing specific keywords
-- 5. Generate a product summary with formatted text

-- Your solution here




```

## Exercise 3: Date and Time Data Types

### Task 3.1: Design an Events Management System
```sql
-- TODO: Create an Events table with comprehensive date/time handling:
-- 1. EventID: Auto-incrementing primary key
-- 2. EventName: Event title (up to 200 characters)
-- 3. EventDate: Date of the event (date only)
-- 4. StartTime: Event start time (time only, second precision)
-- 5. EndTime: Event end time (time only, second precision)
-- 6. CreatedDateTime: When record was created (high precision)
-- 7. ModifiedDateTime: When record was last modified (millisecond precision)
-- 8. EventDateTime: Full date/time of event (computed from EventDate + StartTime)
-- 9. TimeZone: Timezone offset information
-- 10. RegistrationDeadline: Date/time with timezone for registration cutoff

CREATE TABLE Events (
    -- Your solution here
    
    
    
    
    
    
    
    
    
);
```

### Task 3.2: Date/Time Business Logic
```sql
-- TODO: Insert sample events and implement business logic:
-- 1. Create events in different time zones
-- 2. Calculate event duration in hours and minutes
-- 3. Determine if registration is still open
-- 4. Find events happening this week/month
-- 5. Calculate business days until event

-- Sample events to insert:
-- 1. "Annual Conference", Date: 2024-06-15, Start: 09:00, End: 17:00, Timezone: -08:00
-- 2. "Product Launch", Date: 2024-05-22, Start: 14:30, End: 16:00, Timezone: +01:00  
-- 3. "Training Workshop", Date: 2024-04-10, Start: 10:00, End: 15:30, Timezone: -05:00

-- Your solution here




-- TODO: Write queries for business logic:
-- 1. Events duration calculation
-- 2. Registration status check
-- 3. Upcoming events in next 30 days
-- 4. Events grouped by month and timezone

-- Your solution here




```

### Task 3.3: Advanced Date/Time Scenarios
```sql
-- TODO: Implement complex date/time scenarios:
-- 1. Calculate working days between registration deadline and event
-- 2. Find events that conflict with each other (same day, overlapping times)
-- 3. Generate a calendar view showing events by week
-- 4. Handle timezone conversions for global attendees
-- 5. Create recurring event logic

-- Your solution here




```

## Exercise 4: Integration Challenge

### Task 4.1: Build a Complete Order Management System
```sql
-- TODO: Create a comprehensive system that uses all data types appropriately
-- Design tables for: Customers, Orders, OrderItems, Products (extend existing)
-- Include proper relationships, constraints, and business logic

-- Customer table requirements:
-- - CustomerID, FirstName, LastName (proper character types)
-- - BirthDate (date only), RegistrationDate (full datetime)
-- - CreditLimit (precise decimal), DiscountRate (percentage)
-- - CustomerSince (computed: years from registration)

-- Orders table requirements:
-- - OrderID, CustomerID, OrderDate, RequiredDate, ShippedDate
-- - OrderTotal (precise currency), TaxRate, ShippingCost
-- - OrderStatus, Priority (appropriate numeric types)

-- OrderItems table requirements:  
-- - OrderID, ProductID, Quantity, UnitPrice, Discount
-- - LineTotal (computed), ItemWeight

-- Your solution here




```

### Task 4.2: Advanced Data Type Operations
```sql
-- TODO: Implement advanced operations that combine multiple data types:
-- 1. Customer lifetime value calculation
-- 2. Seasonal sales analysis using date functions
-- 3. Product name standardization and search
-- 4. Order fulfillment time analysis
-- 5. Customer segmentation based on purchase patterns

-- Your solution here




```

## Exercise 5: Performance and Optimization

### Task 5.1: Data Type Performance Analysis
```sql
-- TODO: Compare performance of different data type choices:
-- 1. Create identical tables with different numeric precisions
-- 2. Compare storage size of CHAR vs VARCHAR vs NVARCHAR
-- 3. Analyze index efficiency with different date/time types
-- 4. Measure query performance with proper vs improper data types

-- Create test tables for comparison
CREATE TABLE PerformanceTest_Optimized (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SmallNumber TINYINT,           -- vs INT
    MediumNumber SMALLINT,         -- vs INT  
    ShortText VARCHAR(20),         -- vs VARCHAR(MAX)
    OptimalDate DATE,              -- vs DATETIME
    PreciseDecimal DECIMAL(10,2)   -- vs FLOAT
);

CREATE TABLE PerformanceTest_Suboptimal (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SmallNumber INT,               -- Oversized
    MediumNumber INT,              -- Oversized
    ShortText VARCHAR(MAX),        -- Oversized
    OptimalDate DATETIME,          -- Overprecision
    PreciseDecimal FLOAT           -- Imprecise
);

-- TODO: Write performance comparison queries and analyze results

-- Your solution here




```

### Task 5.2: Storage Optimization
```sql
-- TODO: Optimize storage for a large-scale scenario:
-- 1. Design a logging table that stores 1 million records per day
-- 2. Choose optimal data types for minimal storage overhead
-- 3. Implement appropriate indexing strategy
-- 4. Consider partitioning by date for performance

-- Requirements for logging table:
-- - LogID (sequential), Timestamp (to the second), 
-- - LogLevel (Error=1, Warning=2, Info=3), 
-- - Message (up to 500 chars), UserID (1-100000),
-- - SessionID (UUID), ApplicationModule (max 20 chars)

-- Your solution here




```

## Exercise 6: Real-World Scenarios

### Task 6.1: E-commerce Platform Data Design
```sql
-- TODO: Design a complete e-commerce platform with proper data types:
-- Tables needed: Users, Categories, Products, Reviews, Carts, Orders, Payments
-- Consider: International support, currency handling, timestamps, ratings, etc.

-- Your solution here




```

### Task 6.2: Financial Application
```sql
-- TODO: Design tables for a financial application requiring:
-- 1. Exact monetary calculations (no rounding errors)
-- 2. High-precision interest rate storage
-- 3. International currency support
-- 4. Audit trail with precise timestamps
-- 5. Account numbers and routing numbers (fixed formats)

-- Your solution here




```

### Task 6.3: IoT Data Collection System
```sql
-- TODO: Design a system for collecting IoT sensor data:
-- 1. Device readings every second (timestamp precision)
-- 2. Temperature (-40°C to 85°C, 0.1 degree precision)
-- 3. Humidity (0-100%, 0.01% precision)
-- 4. Device IDs (alphanumeric, 12 characters)
-- 5. Location coordinates (high precision GPS)
-- 6. Battery level (0-100, integer percentage)

-- Consider storage optimization for millions of readings per day

-- Your solution here




```

## Exercise 7: Error Handling and Validation

### Task 7.1: Implement Comprehensive Data Validation
```sql
-- TODO: Create a robust validation system:
-- 1. Email format validation using CHECK constraints
-- 2. Phone number format validation (multiple international formats)
-- 3. Date range validation (no future birth dates, reasonable event dates)
-- 4. Numeric range validation (salary ranges, percentage limits)
-- 5. String format validation (product codes, postal codes)

-- Your solution here




```

### Task 7.2: Safe Data Conversion Procedures
```sql
-- TODO: Create stored procedures for safe data type conversions:
-- 1. Convert string to numeric with error handling
-- 2. Parse dates from various string formats
-- 3. Handle NULL values in conversions
-- 4. Validate and standardize phone numbers
-- 5. Clean and validate email addresses

-- Your solution here




```

## Challenge Exercises

### Challenge 1: Data Type Migration
```sql
-- CHALLENGE: You've inherited a poorly designed database with wrong data types
-- TODO: Create migration scripts to fix these issues:
-- 1. Ages stored as VARCHAR(50) - convert to appropriate numeric type
-- 2. Prices stored as FLOAT - convert to precise decimal
-- 3. Dates stored as VARCHAR in various formats - standardize to DATE
-- 4. Phone numbers with inconsistent formatting - standardize format
-- 5. Names with mixed case and extra spaces - clean and standardize

-- Create the "bad" table first
CREATE TABLE BadDataTypes (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Age VARCHAR(50),                    -- Should be TINYINT
    Price FLOAT,                        -- Should be DECIMAL
    EventDate VARCHAR(20),              -- Should be DATE
    PhoneNumber VARCHAR(50),            -- Inconsistent format
    CustomerName VARCHAR(100)           -- Mixed case, extra spaces
);

-- Insert sample bad data
INSERT INTO BadDataTypes VALUES
    ('35', 29.99, '2024-01-15', '(555) 123-4567', '  john SMITH  '),
    ('invalid', 1234.5678, '01/22/2024', '555.987.6543', 'JANE doe'),
    ('42', 0.1, '2024/03/30', '5551234567', 'Bob   Johnson '),
    ('', 999999.123456, 'March 15, 2024', '+1-555-456-7890', '  ');

-- TODO: Write migration script to create properly typed table and transfer data safely

-- Your solution here




```

### Challenge 2: Performance Optimization Challenge
```sql
-- CHALLENGE: Optimize a slow-performing query by fixing data type issues
-- TODO: Given this poorly performing query, identify and fix data type problems:

-- Slow query (don't run this as-is, it's intentionally slow):
/*
SELECT 
    CONVERT(VARCHAR(10), CAST(OrderDate AS FLOAT)) AS FormattedDate,
    CAST(CustomerID AS VARCHAR(20)) + '-' + CAST(OrderID AS VARCHAR(20)) AS OrderKey,
    CONVERT(DECIMAL(10,2), CAST(OrderTotal AS VARCHAR(50))) AS CleanTotal
FROM SlowOrders 
WHERE YEAR(OrderDate) = 2024 
  AND MONTH(OrderDate) = 3
  AND CAST(OrderTotal AS DECIMAL(10,2)) > 100.00;
*/

-- TODO: Rewrite with proper data types and efficient queries

-- Your solution here




```

### Challenge 3: Global Application Design
```sql
-- CHALLENGE: Design a globally distributed application
-- TODO: Create a system that handles:
-- 1. Multiple currencies with proper precision
-- 2. Multiple time zones with daylight saving time
-- 3. International address formats
-- 4. Multi-language product descriptions
-- 5. Regional number formats (dates, numbers, phones)

-- Your solution here




```

## Verification and Testing

### Data Type Validation Queries
```sql
-- Verify your solutions with these validation queries

-- 1. Check data type choices
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 2. Verify constraints
SELECT 
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    cc.CHECK_CLAUSE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
LEFT JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc 
    ON tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE tc.TABLE_SCHEMA = 'dbo'
ORDER BY tc.TABLE_NAME;

-- 3. Check storage usage
SELECT 
    t.name AS TableName,
    SUM(a.total_pages) * 8 AS TotalSpaceKB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name NOT LIKE 'sys%'
GROUP BY t.name
ORDER BY TotalSpaceKB DESC;
```

## Lab Completion Checklist

### Basic Requirements (Must Complete)
- [ ] Exercise 1: Numeric data types implemented correctly
- [ ] Exercise 2: Character data types with proper constraints
- [ ] Exercise 3: Date/time data types with business logic
- [ ] Exercise 4: Integration challenge completed
- [ ] All tables created with appropriate data types
- [ ] Sample data inserted and validated
- [ ] Basic queries demonstrating data type usage

### Advanced Requirements (Recommended)
- [ ] Exercise 5: Performance optimization completed
- [ ] Exercise 6: Real-world scenarios implemented
- [ ] Exercise 7: Error handling and validation
- [ ] At least one challenge exercise completed
- [ ] Proper indexing strategy implemented
- [ ] Documentation of design decisions

### Expert Level (Optional)
- [ ] All challenge exercises completed
- [ ] Performance benchmarking conducted
- [ ] Custom functions and procedures created
- [ ] Complete migration scripts developed
- [ ] Comprehensive testing scenarios

## Troubleshooting Guide

### Common Issues and Solutions

#### Data Type Conversion Errors
```sql
-- Problem: "Conversion failed when converting..."
-- Solution: Use TRY_CAST or TRY_CONVERT
SELECT 
    TRY_CAST('invalid_number' AS INT) AS SafeConversion,
    CASE 
        WHEN ISNUMERIC('123.45') = 1 THEN CAST('123.45' AS DECIMAL(10,2))
        ELSE NULL
    END AS ConditionalConversion;
```

#### Constraint Violations
```sql
-- Problem: CHECK constraint violations
-- Solution: Test constraints incrementally
-- First, check if data would pass constraint
SELECT *
FROM YourTable
WHERE NOT (YourColumn LIKE 'expected_pattern');

-- Then apply constraint
ALTER TABLE YourTable
ADD CONSTRAINT CK_YourConstraint CHECK (YourColumn LIKE 'expected_pattern');
```

#### Storage and Performance Issues
```sql
-- Problem: Excessive storage usage
-- Solution: Analyze column usage and optimize
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    CASE 
        WHEN DATA_TYPE IN ('varchar', 'nvarchar') AND CHARACTER_MAXIMUM_LENGTH = -1 
        THEN 'Consider specific length instead of MAX'
        WHEN DATA_TYPE = 'int' AND COLUMN_NAME LIKE '%age%'
        THEN 'Consider TINYINT for age columns'
        ELSE 'OK'
    END AS Recommendation
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'YourTable';
```

## Additional Resources

### Useful Data Type Reference Queries
```sql
-- Quick reference for data type limits
SELECT 
    'TINYINT' AS DataType, 0 AS MinValue, 255 AS MaxValue, 1 AS StorageBytes
UNION SELECT 'SMALLINT', -32768, 32767, 2
UNION SELECT 'INT', -2147483648, 2147483647, 4
UNION SELECT 'BIGINT', -9223372036854775808, 9223372036854775807, 8;

-- Character data type comparison
SELECT 
    'CHAR(n)' AS DataType, 'Fixed length, padded' AS Behavior, '1-8000 bytes' AS MaxSize
UNION SELECT 'VARCHAR(n)', 'Variable length', '1-8000 bytes'
UNION SELECT 'VARCHAR(MAX)', 'Variable length', '2GB'
UNION SELECT 'NCHAR(n)', 'Fixed length, Unicode', '1-4000 chars'
UNION SELECT 'NVARCHAR(n)', 'Variable length, Unicode', '1-4000 chars'
UNION SELECT 'NVARCHAR(MAX)', 'Variable length, Unicode', '1GB';
```

## Lab Assessment Criteria

### Evaluation Points (100 total)
1. **Correct Data Type Selection (25 points)**
   - Appropriate numeric types for ranges
   - Proper character types for content
   - Correct date/time types for scenarios

2. **Constraint Implementation (20 points)**
   - Proper CHECK constraints
   - Appropriate NOT NULL constraints
   - Valid format validations

3. **Query Efficiency (20 points)**
   - SARGable query patterns
   - Appropriate indexing
   - Efficient data type conversions

4. **Business Logic Implementation (20 points)**
   - Realistic scenarios
   - Proper calculations
   - Edge case handling

5. **Code Quality and Documentation (15 points)**
   - Clear, readable SQL
   - Proper commenting
   - Consistent formatting

### Bonus Points (up to 10 additional)
- Creative solutions to challenges
- Performance optimization demonstrations
- Comprehensive error handling
- Additional real-world scenarios

Remember to test all your solutions thoroughly and verify that your data type choices are appropriate for the specific requirements of each scenario!
