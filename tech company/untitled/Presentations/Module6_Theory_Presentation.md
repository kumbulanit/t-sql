# Module 6: Working with SQL Server 2016 Data Types - Theory Presentation

## Slide 1: Module Overview
**Working with SQL Server 2016 Data Types**

- Understanding SQL Server's data type system
- Working with character and Unicode data efficiently
- Mastering date and time data types and functions
- Numeric precision, scale, and performance considerations
- Data type conversion, validation, and best practices

---

## Slide 2: Data Type System Overview
**SQL Server Data Type Categories**

- **Exact Numeric**: INT, BIGINT, DECIMAL, NUMERIC, MONEY
- **Approximate Numeric**: FLOAT, REAL
- **Character Strings**: CHAR, VARCHAR, TEXT
- **Unicode Strings**: NCHAR, NVARCHAR, NTEXT
- **Date and Time**: DATE, TIME, DATETIME, DATETIME2, DATETIMEOFFSET
- **Binary**: BINARY, VARBINARY, IMAGE
- **Other**: BIT, UNIQUEIDENTIFIER, XML, GEOMETRY, GEOGRAPHY

---

## Slide 3: Choosing the Right Data Type
**Selection Criteria**

- **Storage Requirements**: Space efficiency considerations
- **Performance**: Query and index performance impact
- **Precision**: Accuracy requirements for numeric data
- **Range**: Value range requirements
- **Functionality**: Available functions and operations
- **Standards Compliance**: ANSI SQL compatibility

---

## Slide 4: Integer Data Types
**Whole Number Storage**

```sql
-- Integer types by range and storage
TINYINT     -- 0 to 255 (1 byte)
SMALLINT    -- -32,768 to 32,767 (2 bytes)
INT         -- -2.1 billion to 2.1 billion (4 bytes)
BIGINT      -- -9.2 x 10^18 to 9.2 x 10^18 (8 bytes)

-- Usage examples
CREATE TABLE IntegerExamples (
    Age TINYINT,           -- 0-255 sufficient for age
    OrderID INT,           -- Standard integer for IDs
    LargeNumber BIGINT     -- For very large values
);
```

---

## Slide 5: Decimal and Numeric Types
**Exact Precision Numbers**

```sql
-- DECIMAL/NUMERIC (identical functionality)
DECIMAL(precision, scale)
NUMERIC(precision, scale)

-- Examples
BaseSalary DECIMAL(10,2)      -- Up to 99,999,999.99
Percentage DECIMAL(5,4)   -- Up to 9.9999
Price DECIMAL(8,2)        -- Up to 999,999.99

-- Money types (avoid for new development)
MONEY        -- 8 bytes, 4 decimal places
SMALLMONEY   -- 4 bytes, 4 decimal places
```

**Best Practice**: Use DECIMAL instead of MONEY for better precision control

---

## Slide 6: Floating Point Types
**Approximate Numeric Types**

```sql
-- Floating point types
FLOAT(n)     -- n = 1-53 (precision in bits)
REAL         -- Equivalent to FLOAT(24)

-- Usage considerations
Scientific FLOAT(53),     -- High precision scientific data
Measurement REAL,         -- Single precision sufficient
Calculated AS (Value1 * Value2)  -- May introduce rounding
```

**Warning**: Floating point can have precision issues in calculations

---

## Slide 7: Character String Data Types
**Non-Unicode Text Storage**

```sql
-- Fixed length
CHAR(n)      -- Always uses n bytes (space-padded)

-- Variable length  
VARCHAR(n)   -- Uses only needed bytes (up to n)
VARCHAR(MAX) -- Up to 2GB storage

-- Usage examples
StateCode CHAR(2),           -- Always 2 characters
LastName VARCHAR(50),        -- Variable up to 50
Description VARCHAR(MAX)     -- Large text content
```

**Performance**: CHAR for fixed-length data, VARCHAR for variable-length

---

## Slide 8: Unicode String Data Types
**International Character Support**

```sql
-- Unicode types (2 bytes per character)
NCHAR(n)      -- Fixed length Unicode
NVARCHAR(n)   -- Variable length Unicode  
NVARCHAR(MAX) -- Large Unicode text

-- Usage examples
FirstName NVARCHAR(50),      -- International names
Comments NVARCHAR(MAX),      -- Large multilingual text
CountryCode NCHAR(3)         -- Fixed ISO codes
```

**When to Use Unicode**: International applications, multilingual data

---

## Slide 9: String Length and Storage
**Character vs Byte Considerations**

```sql
-- Storage calculations
CHAR(10)        -- Always 10 bytes
VARCHAR(10)     -- 1-10 bytes + 2 bytes overhead
NCHAR(10)       -- Always 20 bytes (10 × 2)
NVARCHAR(10)    -- 2-20 bytes + 2 bytes overhead

-- Length functions
LEN(string)        -- Character count
DATALENGTH(string) -- Byte count

SELECT 
    LEN(N'Hello') AS CharCount,        -- 5
    DATALENGTH(N'Hello') AS ByteCount  -- 10
```

---

## Slide 10: Date and Time Data Types
**Temporal Data Storage**

```sql
-- Legacy types (avoid for new development)
DATETIME     -- 1753-9999, 3.33ms accuracy, 8 bytes
SMALLDATETIME -- 1900-2079, 1 minute accuracy, 4 bytes

-- Modern types (SQL Server 2008+)
DATE         -- Date only, 3 bytes
TIME(n)      -- Time only, 3-5 bytes
DATETIME2(n) -- High precision, 6-8 bytes  
DATETIMEOFFSET(n) -- With timezone, 8-10 bytes
```

**Best Practice**: Use DATETIME2 instead of DATETIME for new development

---

## Slide 11: Working with DATE Data Type
**Date-Only Operations**

```sql
-- DATE type advantages
CREATE TABLE Events (
    EventID INT IDENTITY,
    EventDate DATE,           -- No time component
    CreatedDate DATETIME2(3)  -- Full timestamp
);

-- Date operations
SELECT 
    EventDate,
    DATEADD(DAY, 30, EventDate) AS DueDate,
    DATEDIFF(DAY, EventDate, GETDATE()) AS DaysAgo
FROM Events
WHERE EventDate >= '2023-01-01'
    AND EventDate < '2024-01-01';  -- SARGable range
```

---

## Slide 12: Working with TIME Data Type
**Time-Only Operations**

```sql
-- TIME type usage
CREATE TABLE Schedule (
    ScheduleID INT IDENTITY,
    StartTime TIME(0),        -- No fractional seconds
    EndTime TIME(3),          -- Millisecond precision
    Duration AS (DATEDIFF(MINUTE, StartTime, EndTime))
);

-- Time calculations
SELECT 
    StartTime,
    EndTime,
    DATEDIFF(MINUTE, StartTime, EndTime) AS DurationMinutes
FROM Schedule
WHERE StartTime >= '09:00:00'
    AND EndTime <= '17:00:00';
```

---

## Slide 13: DATETIME2 Best Practices
**Modern DateTime Usage**

```sql
-- DATETIME2 advantages over DATETIME
CREATE TABLE Audit (
    AuditID INT IDENTITY,
    EventTime DATETIME2(3),   -- Millisecond precision
    ProcessTime DATETIME2(7), -- Nanosecond precision  
    EventDate AS CAST(EventTime AS DATE)  -- Computed column
);

-- Performance considerations
-- Index on DATETIME2 column
CREATE INDEX IX_Audit_EventTime ON Audit(EventTime);

-- Range queries (SARGable)
WHERE EventTime >= '2023-01-01T00:00:00.000'
    AND EventTime < '2024-01-01T00:00:00.000'
```

---

## Slide 14: DATETIMEOFFSET for Global Applications
**Timezone-Aware Data**

```sql
-- Global timestamp storage
CREATE TABLE GlobalEvents (
    EventID INT IDENTITY,
    LocalTime DATETIMEOFFSET(3),  -- With timezone
    UTCTime AS LocalTime AT TIME ZONE 'UTC'  -- Computed UTC
);

-- Timezone conversions
SELECT 
    LocalTime,
    LocalTime AT TIME ZONE 'Eastern Standard Time' AS EasternTime,
    LocalTime AT TIME ZONE 'UTC' AS UTCTime
FROM GlobalEvents;
```

---

## Slide 15: Binary Data Types
**Binary Data Storage**

```sql
-- Binary types
BINARY(n)       -- Fixed length binary
VARBINARY(n)    -- Variable length binary
VARBINARY(MAX)  -- Large binary objects

-- Usage examples
CREATE TABLE Files (
    FileID INT IDENTITY,
    FileName NVARCHAR(255),
    ContentType VARCHAR(100),
    FileData VARBINARY(MAX),         -- File content
    Checksum BINARY(16)              -- MD5 hash
);
```

**Considerations**: Storage size, backup impact, query performance

---

## Slide 16: Special Data Types
**Unique and XML Types**

```sql
-- UNIQUEIDENTIFIER (GUID)
CustomerID UNIQUEIDENTIFIER DEFAULT NEWID(),
RowGuid UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID()

-- BIT (Boolean-like)
IsActive BIT DEFAULT 1,
IsDeleted BIT DEFAULT 0

-- XML data type
ProductCatalog XML,
ConfigData XML(ConfigSchema)  -- With schema validation
```

---

## Slide 17: Data Type Conversion
**CAST and CONVERT Functions**

```sql
-- CAST (ANSI standard)
SELECT 
    CAST(BaseSalary AS VARCHAR(20)) AS SalaryText,
    CAST('2023-01-01' AS DATE) AS ConvertedDate,
    CAST(3.14159 AS DECIMAL(10,2)) AS RoundedValue

-- CONVERT (SQL Server specific)
SELECT 
    CONVERT(VARCHAR(10), GETDATE(), 101) AS USDate,    -- MM/DD/YYYY
    CONVERT(VARCHAR(10), GETDATE(), 103) AS UKDate,    -- DD/MM/YYYY
    CONVERT(VARCHAR(19), GETDATE(), 120) AS ISODate    -- YYYY-MM-DD HH:MM:SS
```

---

## Slide 18: Safe Conversion Functions
**Error Handling in Conversions**

```sql
-- TRY_ functions (SQL Server 2012+)
SELECT 
    TRY_CAST('ABC' AS INT) AS SafeCast,           -- Returns NULL
    TRY_CONVERT(DATE, '2023-02-30') AS SafeDate,  -- Returns NULL
    TRY_PARSE('€1.234,56' AS MONEY USING 'de-DE') AS SafeParse

-- Error handling
SELECT 
    CASE 
        WHEN TRY_CAST(InputValue AS INT) IS NOT NULL 
        THEN TRY_CAST(InputValue AS INT)
        ELSE 0 
    END AS SafeInteger
FROM DataImport;
```

---

## Slide 19: Implicit vs Explicit Conversion
**Understanding Conversion Precedence**

```sql
-- Implicit conversion (automatic)
SELECT EmployeeID + '1'  -- INT + VARCHAR → VARCHAR result

-- Data type precedence (highest to lowest):
-- user-defined data types, sql_variant, xml, datetimeoffset
-- datetime2, datetime, smalldatetime, date, time
-- float, real, decimal, money, smallmoney, bigint, int
-- smallint, tinyint, bit, ntext, text, image
-- timestamp, uniqueidentifier, nvarchar, nchar
-- varchar, char, varbinary, binary

-- Explicit conversion (recommended)
SELECT CAST(EmployeeID AS VARCHAR(10)) + '1' AS Result
```

---

## Slide 20: String Functions Deep Dive
**Advanced String Manipulation**

```sql
-- String functions with different data types
SELECT 
    LEN(FirstName) AS NameLength,
    UPPER(LastName) AS UpperName,
    SUBSTRING(WorkEmail, 1, CHARINDEX('@', WorkEmail) - 1) AS Username,
    REPLACE(PhoneNumber, '-', '') AS CleanPhone,
    STUFF(SSN, 4, 0, '-') AS FormattedSSN,
    REVERSE(LastName) AS ReversedName,
    REPLICATE('*', LEN(Password)) AS MaskedPassword
FROM Employees;
```

---

## Slide 21: Date Functions Mastery
**Comprehensive Date Manipulation**

```sql
-- Date arithmetic and formatting
SELECT 
    GETDATE() AS CurrentDateTime,
    GETUTCDATE() AS UTCDateTime,
    SYSDATETIME() AS HighPrecisionNow,
    
    -- Date parts
    YEAR(HireDate) AS HireYear,
    MONTH(HireDate) AS HireMonth,
    DAY(HireDate) AS HireDay,
    DATEPART(QUARTER, HireDate) AS HireQuarter,
    DATEPART(WEEKDAY, HireDate) AS HireDayOfWeek,
    
    -- Date calculations
    DATEADD(YEAR, 1, HireDate) AS Anniversary,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,
    EOMONTH(HireDate) AS EndOfHireMonth
FROM Employees;
```

---

## Slide 22: Numeric Functions and Precision
**Mathematical Operations**

```sql
-- Numeric functions
SELECT 
    ABS(-42) AS AbsoluteValue,
    CEILING(3.14) AS RoundUp,        -- 4
    FLOOR(3.14) AS RoundDown,        -- 3
    ROUND(3.14159, 2) AS Rounded,    -- 3.14
    POWER(2, 3) AS PowerResult,      -- 8
    SQRT(16) AS SquareRoot,          -- 4
    
    -- Precision considerations
    BaseSalary * 1.05 AS RaisedSalary,
    CAST(BaseSalary * 1.05 AS DECIMAL(10,2)) AS PreciseRaise
FROM Employees;
```

---

## Slide 23: Performance Considerations
**Data Type Impact on Performance**

```sql
-- Storage and performance comparison
-- Smaller data types = better performance

-- Index efficiency
CREATE INDEX IX_Employee_HireDate ON Employees(HireDate);  -- 3 bytes
-- vs
CREATE INDEX IX_Employee_HireDateTime ON Employees(HireDateTime);  -- 8 bytes

-- Query performance
WHERE HireDate >= '2020-01-01'  -- DATE comparison (fast)
-- vs  
WHERE YEAR(HireDate) = 2020     -- Function on column (slow)

-- Memory usage in sorts and joins
ORDER BY LastName  -- VARCHAR(50) = up to 50 bytes
-- vs
ORDER BY Description  -- VARCHAR(MAX) = potentially huge
```

---

## Slide 24: Common Data Type Mistakes
**Pitfalls to Avoid**

```sql
-- Mistake 1: Wrong precision
Price DECIMAL(5,2)  -- Only up to 999.99 - too small for products

-- Mistake 2: Using deprecated types
Description TEXT    -- Use VARCHAR(MAX) instead
Notes NTEXT        -- Use NVARCHAR(MAX) instead

-- Mistake 3: Unnecessary Unicode
StateName NVARCHAR(50)  -- VARCHAR(50) sufficient for English

-- Mistake 4: Fixed length for variable data
Comments CHAR(1000)     -- Wastes space, use VARCHAR(1000)

-- Mistake 5: Implicit conversions
WHERE EmployeeID = '123'  -- Should be: WHERE EmployeeID = 123
```

---

## Slide 25: Learning Objectives Achieved
**Module 6 Outcomes**

✅ Master SQL Server 2016 data type selection
✅ Efficiently work with character and Unicode strings
✅ Utilize modern date and time data types effectively
✅ Handle numeric precision and scale requirements
✅ Implement proper data type conversion strategies
✅ Optimize performance through appropriate type selection

---

## Slide 26: Next Steps
**Module 7 Preview: Using DML to Modify Data**

- INSERT statements for adding new data
- UPDATE statements for modifying existing records
- DELETE statements for removing data safely
- MERGE statements for complex data synchronization
- Transaction control and data integrity

**Key Preparation**
- Practice data type conversions and validations
- Understand constraint implications for different types
- Review indexing strategies for chosen data types