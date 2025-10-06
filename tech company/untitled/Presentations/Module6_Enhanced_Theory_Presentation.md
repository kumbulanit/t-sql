# Module 6: Working with Data Types - Enhanced Theory Presentation

## Slide 1: Module Overview
**Mastering SQL Server Data Types: Precision, Performance, and Best Practices**

### Learning Objectives
- **Data Type Mastery**: Complete understanding of all SQL Server data types and their appropriate usage
- **Storage Optimization**: Efficient data type selection for optimal storage and performance
- **Type Conversion Expertise**: Mastery of implicit and explicit conversions, precision, and scale handling
- **Advanced Types**: Working with specialized data types (XML, JSON, spatial, hierarchical)
- **Performance Impact**: Understanding how data type choices affect query performance and indexing
- **Business Applications**: Matching data types to real-world business requirements

### Module Structure
- **Fundamental Types**: Numeric, character, date/time, and binary data types
- **Advanced Types**: XML, JSON, spatial, and specialized business types
- **Conversion Strategies**: Safe and efficient data type conversions
- **Performance Engineering**: Data type optimization for queries and storage

---

## Slide 2: Numeric Data Types Deep Dive
**Precision, Scale, and Performance Considerations**

### Integer Types

#### **Exact Numeric Types**
```sql
-- Integer type comparison with storage and range
CREATE TABLE NumericComparison (
    TinyIntCol    TINYINT,      -- 1 byte: 0 to 255
    SmallIntCol   SMALLINT,     -- 2 bytes: -32,768 to 32,767
    IntCol        INT,          -- 4 bytes: -2,147,483,648 to 2,147,483,647
    BigIntCol     BIGINT        -- 8 bytes: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
);

-- Performance implications
SELECT 
    COUNT(*) AS RecordCount,
    SUM(CAST(TinyIntCol AS BIGINT)) AS TinyIntSum,     -- Implicit conversion
    SUM(IntCol) AS IntSum,                             -- No conversion needed
    AVG(CAST(SmallIntCol AS DECIMAL(10,2))) AS SmallIntAvg -- Explicit conversion
FROM NumericComparison;
```

#### **Decimal and Numeric Types**
```sql
-- Precise decimal arithmetic
DECLARE @Price DECIMAL(10,2) = 19.99;
DECLARE @TaxRate DECIMAL(5,4) = 0.0875;
DECLARE @Quantity INT = 3;

SELECT 
    @Price AS BaseSalary,
    @Quantity AS Quantity,
    @Price * @Quantity AS Subtotal,
    (@Price * @Quantity) * @TaxRate AS TaxAmount,
    (@Price * @Quantity) * (1 + @TaxRate) AS TotalAmount,
    -- Precision and scale matter for financial calculations
    ROUND((@Price * @Quantity) * (1 + @TaxRate), 2) AS RoundedTotal;
```

### Floating Point Types

#### **Approximate Numeric Types**
```sql
-- Float and Real precision issues
DECLARE @Float FLOAT = 0.1;
DECLARE @Real REAL = 0.1;
DECLARE @Decimal DECIMAL(10,1) = 0.1;

SELECT 
    @Float AS FloatValue,
    @Real AS RealValue, 
    @Decimal AS DecimalValue,
    -- Precision loss in calculations
    @Float + @Float + @Float AS FloatSum,
    @Decimal + @Decimal + @Decimal AS DecimalSum,
    -- Never use floating point for exact comparisons
    CASE WHEN @Float = 0.3 THEN 'Equal' ELSE 'Not Equal' END AS FloatComparison,
    CASE WHEN @Decimal * 3 = 0.3 THEN 'Equal' ELSE 'Not Equal' END AS DecimalComparison;
```

---

## Slide 3: Character Data Types Mastery
**Unicode, Collation, and Storage Optimization**

### Character Type Selection

#### **CHAR vs VARCHAR Performance**
```sql
-- Storage and performance implications
CREATE TABLE CharacterComparison (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FixedChar CHAR(10),        -- Always 10 bytes, padded with spaces
    VariableChar VARCHAR(10),  -- 1-10 bytes + 2 bytes overhead
    NationalChar NCHAR(10),    -- Always 20 bytes (Unicode)
    NationalVarChar NVARCHAR(10) -- 2-20 bytes + 2 bytes overhead
);

-- Insertion examples showing padding behavior
INSERT INTO CharacterComparison (FixedChar, VariableChar, NationalChar, NationalVarChar)
VALUES 
    ('ABC', 'ABC', N'ABC', N'ABC'),
    ('ABCDEFGHIJ', 'ABCDEFGHIJ', N'ABCDEFGHIJ', N'ABCDEFGHIJ');

-- Query showing actual storage
SELECT 
    FixedChar,
    LEN(FixedChar) AS FixedCharLength,
    DATALENGTH(FixedChar) AS FixedCharBytes,
    VariableChar,
    LEN(VariableChar) AS VarCharLength,
    DATALENGTH(VariableChar) AS VarCharBytes
FROM CharacterComparison;
```

#### **Unicode Considerations**
```sql
-- Unicode string handling
DECLARE @EnglishText NVARCHAR(50) = N'Hello World';
DECLARE @ChineseText NVARCHAR(50) = N'你好世界';
DECLARE @ArabicText NVARCHAR(50) = N'مرحبا بالعالم';
DECLARE @EmojiText NVARCHAR(50) = N'Hello 😊 World 🌍';

SELECT 
    @EnglishText AS English,
    LEN(@EnglishText) AS EnglishLength,
    DATALENGTH(@EnglishText) AS EnglishBytes,
    @ChineseText AS Chinese,
    LEN(@ChineseText) AS ChineseLength,
    DATALENGTH(@ChineseText) AS ChineseBytes;
```

### Advanced String Operations

#### **Collation and Sorting**
```sql
-- Collation-sensitive operations
CREATE TABLE CompanyNames (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS -- Case-insensitive
);

INSERT INTO CompanyNames (Name) VALUES 
    (N'Smith'), (N'SMITH'), (N'smith'), 
    (N'Müller'), (N'Mueller'), (N'MÜLLER'),
    (N'José'), (N'Jose'), (N'JOSÉ');

-- Different collation behaviors
SELECT Name FROM CompanyNames 
ORDER BY Name COLLATE SQL_Latin1_General_CP1_CS_AS; -- Case-sensitive

SELECT Name FROM CompanyNames 
ORDER BY Name COLLATE SQL_Latin1_General_CP1_CI_AI; -- Case and accent insensitive
```

---

## Slide 4: Date and Time Data Types
**Temporal Data Precision and Business Applications**

### Date/Time Type Selection

#### **Comprehensive Date/Time Types**
```sql
-- Modern date/time types (SQL Server 2008+)
CREATE TABLE DateTimeComparison (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Legacy types
    OldDateTime DATETIME,          -- 8 bytes, 3.33ms precision, 1753-9999
    OldSmallDateTime SMALLDATETIME, -- 4 bytes, 1 minute precision, 1900-2079
    
    -- Modern types  
    NewDate DATE,                  -- 3 bytes, day precision, 0001-9999
    NewTime TIME(7),               -- 5 bytes, 100ns precision
    NewDateTime2 DATETIME2(7),     -- 8 bytes, 100ns precision, 0001-9999
    
    -- Time zone aware
    DateTimeOffset DATETIMEOFFSET(7) -- 10 bytes, includes time zone offset
);

-- Sample data insertion
INSERT INTO DateTimeComparison (OldDateTime, NewDate, NewTime, NewDateTime2, DateTimeOffset)
VALUES 
    (GETDATE(), CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME), GETDATE(), SYSDATETIMEOFFSET());

-- Precision comparison
SELECT 
    OldDateTime,
    NewDateTime2,
    DATEDIFF(MICROSECOND, OldDateTime, NewDateTime2) AS PrecisionDifference,
    DateTimeOffset,
    SWITCHOFFSET(DateTimeOffset, '-05:00') AS EasternTime,
    SWITCHOFFSET(DateTimeOffset, '+00:00') AS UTCTime
FROM DateTimeComparison;
```

#### **Business Date Calculations**
```sql
-- Advanced date arithmetic for business scenarios
DECLARE @OrderDate DATE = '2023-06-15';
DECLARE @PaymentTerms INT = 30; -- Net 30 days

SELECT 
    @OrderDate AS OrderDate,
    
    -- Business day calculations
    DATEADD(DAY, @PaymentTerms, @OrderDate) AS DueDate,
    
    -- Quarter calculations
    DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @OrderDate), 0) AS QuarterStart,
    DATEADD(DAY, -1, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @OrderDate) + 1, 0)) AS QuarterEnd,
    
    -- Age calculations
    DATEDIFF(YEAR, '1990-03-15', @OrderDate) - 
    CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, '1990-03-15', @OrderDate), '1990-03-15') > @OrderDate 
         THEN 1 ELSE 0 END AS AccurateAge,
    
    -- Business scenarios
    CASE 
        WHEN DATEPART(WEEKDAY, DATEADD(DAY, @PaymentTerms, @OrderDate)) = 1 THEN -- Sunday
            DATEADD(DAY, @PaymentTerms + 1, @OrderDate) 
        WHEN DATEPART(WEEKDAY, DATEADD(DAY, @PaymentTerms, @OrderDate)) = 7 THEN -- Saturday
            DATEADD(DAY, @PaymentTerms + 2, @OrderDate)
        ELSE 
            DATEADD(DAY, @PaymentTerms, @OrderDate)
    END AS BusinessDueDate;
```

---

## Slide 5: Advanced Data Types
**XML, JSON, Spatial, and Specialized Types**

### XML Data Type

#### **XML Storage and Querying**
```sql
-- XML data type usage
CREATE TABLE ProductCatalog (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    ProductDetails XML,
    ProductDetailsTyped XML(CONTENT dbo.ProductSchemaCollection) -- Typed XML
);

-- Insert XML data
INSERT INTO ProductCatalog (ProductID, ProductName, ProductDetails)
VALUES 
    (1, 'Laptop Computer', 
     '<Product>
        <Specifications>
          <CPU>Intel i7</CPU>
          <RAM>16GB</RAM>
          <Storage>512GB SSD</Storage>
          <Screen>15.6 inch</Screen>
        </Specifications>
        <Features>
          <Feature>Bluetooth</Feature>
          <Feature>WiFi 6</Feature>
          <Feature>USB-C</Feature>
        </Features>
      </Product>');

-- XML querying with XQuery
SELECT 
    ProductID,
    ProductName,
    ProductDetails.value('(/Product/Specifications/CPU)[1]', 'NVARCHAR(50)') AS CPU,
    ProductDetails.value('(/Product/Specifications/RAM)[1]', 'NVARCHAR(20)') AS RAM,
    ProductDetails.query('/Product/Features/Feature') AS Features
FROM ProductCatalog
WHERE ProductDetails.exist('/Product/Specifications[CPU[contains(., "i7")]]') = 1;
```

### JSON Support (SQL Server 2016+)

#### **JSON Functions and Operations**
```sql
-- JSON data handling
CREATE TABLE CustomerProfiles (
    CustomerID INT PRIMARY KEY,
    CompanyName NVARCHAR(100),
    ProfileData NVARCHAR(MAX) -- Store JSON as string
);

-- Insert JSON data
INSERT INTO CustomerProfiles (CustomerID, CompanyName, ProfileData)
VALUES 
    (1, 'John Smith', 
     '{"age": 35, "interests": ["technology", "sports"], "address": {"city": "New York", "state": "NY"}}'),
    (2, 'Jane Doe',
     '{"age": 28, "interests": ["travel", "photography"], "address": {"city": "Los Angeles", "state": "CA"}}');

-- JSON querying
SELECT 
    CustomerID,
    CompanyName,
    JSON_VALUE(ProfileData, '$.age') AS Age,
    JSON_VALUE(ProfileData, '$.address.city') AS City,
    JSON_QUERY(ProfileData, '$.interests') AS Interests
FROM CustomerProfiles
WHERE JSON_VALUE(ProfileData, '$.age') > 30;

-- JSON modification
UPDATE CustomerProfiles 
SET ProfileData = JSON_MODIFY(ProfileData, '$.age', 36)
WHERE CustomerID = 1;
```

### Spatial Data Types

#### **Geography and Geometry Types**
```sql
-- Spatial data for location-based applications
CREATE TABLE StoreLocations (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(100),
    Location GEOGRAPHY,
    DeliveryArea GEOGRAPHY
);

-- Insert spatial data
INSERT INTO StoreLocations (StoreID, StoreName, Location, DeliveryArea)
VALUES 
    (1, 'Downtown Store', 
     GEOGRAPHY::Point(40.7128, -74.0060, 4326), -- New York coordinates
     GEOGRAPHY::Point(40.7128, -74.0060, 4326).STBuffer(5000)); -- 5km delivery radius

-- Spatial queries
DECLARE @CustomerLocation GEOGRAPHY = GEOGRAPHY::Point(40.7589, -73.9851, 4326); -- Times Square

SELECT 
    StoreID,
    StoreName,
    Location.STDistance(@CustomerLocation) AS DistanceInMeters,
    CASE WHEN DeliveryArea.STContains(@CustomerLocation) = 1 
         THEN 'Available' 
         ELSE 'Not Available' 
    END AS DeliveryIsActive
FROM StoreLocations
ORDER BY Location.STDistance(@CustomerLocation);
```

---

## Slide 6: Data Type Conversions and Best Practices
**Safe Conversions and Performance Optimization**

### Implicit vs Explicit Conversions

#### **Conversion Hierarchy and Performance**
```sql
-- Data type precedence hierarchy demonstration
SELECT 
    -- Implicit conversions (automatic)
    1 + 2.5 AS IntPlusDecimal,        -- INT -> DECIMAL
    'Value: ' + CAST(123 AS VARCHAR) AS StringConcatenation, -- Must be explicit
    
    -- Explicit conversions (controlled)
    CAST('123.45' AS DECIMAL(10,2)) AS StringToDecimal,
    CONVERT(VARCHAR(20), GETDATE(), 101) AS DateToString, -- US format
    
    -- Safe conversions with error handling
    TRY_CAST('invalid' AS INT) AS SafeConversion, -- Returns NULL instead of error
    TRY_CONVERT(DATE, '2023-13-45') AS SafeDateConversion; -- Invalid date returns NULL
```

#### **Performance Impact of Conversions**
```sql
-- Performance comparison: implicit vs explicit conversions
CREATE TABLE ConversionTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    StringID VARCHAR(10),
    NumericValue DECIMAL(10,2)
);

-- Index on StringID
CREATE INDEX IX_ConversionTest_StringID ON ConversionTest (StringID);

-- Insert test data
INSERT INTO ConversionTest (StringID, NumericValue)
SELECT 
    RIGHT('000' + CAST(number AS VARCHAR), 4),
    RAND() * 1000
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 1 AND 10000;

-- Bad: Implicit conversion prevents index usage
SELECT * FROM ConversionTest 
WHERE StringID = 123; -- StringID gets converted to INT for comparison

-- Good: Explicit conversion maintains index usage  
SELECT * FROM ConversionTest 
WHERE StringID = '123'; -- Direct string comparison uses index
```

### Best Practices for Data Type Selection

#### **Storage Optimization Guidelines**
```sql
-- Efficient data type selection examples
CREATE TABLE OptimizedEmployees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,  -- 4 bytes, sufficient range
    
    -- Character data optimization
    FirstName NVARCHAR(50),                    -- Variable length for names
    LastName NVARCHAR(50),
    MiddleInitial NCHAR(1),                    -- Fixed single character
    SSN CHAR(11),                              -- Fixed format: 000-00-0000
    
    -- Numeric optimization
    Age TINYINT,                               -- 1 byte, 0-255 range sufficient
    DepartmentID SMALLINT,                     -- 2 bytes, assuming < 32K departments
    BaseSalary DECIMAL(10,2),                      -- Exact precision for money
    
    -- Date optimization
    BirthDate DATE,                            -- 3 bytes, no time needed
    HireDateTime DATETIME2(0),                 -- Second precision sufficient
    
    -- Boolean values
    IsActive BIT,                              -- 1 bit per value
    IsManager BIT,
    
    -- IsActive codes
    EmployeeIsActive TINYINT,                    -- Numeric codes: 1=Active, 2=Inactive, etc.
    
    -- Constraints for data integrity
    CONSTRAINT CK_Employees_Age CHECK (Age BETWEEN 18 AND 100),
    CONSTRAINT CK_Employees_Salary CHECK (BaseSalary >= 0),
    CONSTRAINT CK_Employees_IsActive CHECK (EmployeeIsActive BETWEEN 1 AND 5)
);
```

#### **Query Performance Optimization**
```sql
-- Data type matching for optimal join performance
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,                            -- Match with Customers.CustomerID type
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,                -- Consistent data type
    CompanyName NVARCHAR(100)
);

-- Efficient join (matching data types)
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID -- No conversion needed
WHERE o.OrderDate >= '2023-01-01';

-- Index optimization for data types
CREATE INDEX IX_Orders_CustomerDate 
ON Orders (CustomerID, OrderDate)             -- Compound index with matching types
INCLUDE (OrderID, TotalAmount);               -- Covering index
```

This comprehensive Module 6 presentation covers all aspects of SQL Server data types with detailed explanations, practical examples, and performance considerations that will give students expert-level understanding of data type selection and usage.