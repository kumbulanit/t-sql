# Lesson 1: Introducing SQL Server 2016 Data Types

## 🎯 **Overview for Beginners**

**Why Learn Data Types?**
Imagine you're organizing TechCorp's filing cabinets:
- **Numbers** go in number folders (Employee IDs, salaries)
- **Names** go in text folders (Employee names, departments)  
- **Dates** go in date folders (Hire dates, project deadlines)

**Data types are like folder labels** - they tell SQL Server what kind of information to expect!

## 🔍 **What are Data Types? (Simple Explanation)**

**Data Types = Rules for Data Storage**

Think of data types as **containers** with specific rules:

**📊 Real TechCorp Examples:**
- **Employee ID (Number):** Must be a whole number like 1001, 1002, 1003
- **Employee Name (Text):** Can contain letters like "John Smith", "Sarah Johnson"  
- **Hire Date (Date):** Must be a valid date like "2023-01-15"
- **Salary (Money):** Can have decimals like $75,000.00

**Why This Matters for Beginners:**
- **Prevents errors:** Can't accidentally put "ABC" in a salary field
- **Saves space:** Numbers take less room than text
- **Speeds up queries:** SQL Server knows exactly what to expect
- **Data quality:** Ensures consistent, reliable information

## 🏢 **TechCorp Database Examples**

**In the TechCorp Employees table:**
- `EmployeeID` ➜ **INT** (whole numbers: 1001, 1002, 1003...)
- `FirstName` ➜ **NVARCHAR(50)** (text up to 50 characters)
- `JobTitle` ➜ **NVARCHAR(100)** (job positions like "Software Engineer")  
- `BaseSalary` ➜ **DECIMAL(10,2)** (money with 2 decimal places: 75000.00)
- `HireDate` ➜ **DATE** (dates like 2023-01-15)
- `IsActive` ➜ **BIT** (true/false: 1 for active, 0 for inactive)

### Data Type Categories Hierarchy
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SQL SERVER 2016 DATA TYPE CATEGORIES                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│  │   NUMERIC       │  │   CHARACTER     │  │   DATE/TIME     │              │
│  │                 │  │                 │  │                 │              │
│  │ • TINYINT       │  │ • CHAR          │  │ • DATE          │              │
│  │ • SMALLINT      │  │ • VARCHAR       │  │ • TIME          │              │
│  │ • INT           │  │ • NCHAR         │  │ • DATETIME      │              │
│  │ • BIGINT        │  │ • NVARCHAR      │  │ • DATETIME2     │              │
│  │ • DECIMAL       │  │ • TEXT          │  │ • SMALLDATETIME │              │
│  │ • NUMERIC       │  │ • NTEXT         │  │ • DATETIMEOFFSET│              │
│  │ • FLOAT         │  │                 │  └─────────────────┘              │
│  │ • REAL          │  └─────────────────┘                                   │
│  │ • SMALLMONEY    │                                                        │
│  │ • MONEY         │  ┌─────────────────┐  ┌─────────────────┐              │
│  └─────────────────┘  │   BINARY        │  │   SPECIAL       │              │
│                       │                 │  │                 │              │
│  ┌─────────────────┐  │ • BINARY        │  │ • BIT           │              │
│  │   APPROXIMATE   │  │ • VARBINARY     │  │ • UNIQUEIDENTIFIER              │
│  │                 │  │ • IMAGE         │  │ • XML           │              │
│  │ • FLOAT         │  └─────────────────┘  │ • GEOGRAPHY     │              │
│  │ • REAL          │                       │ • GEOMETRY      │              │
│  └─────────────────┘  ┌─────────────────┐  │ • HIERARCHYID   │              │
│                       │   JSON (2016+)  │  │ • SQL_VARIANT   │              │
│                       │                 │  │ • TABLE         │              │
│                       │ • JSON support  │  │ • CURSOR        │              │
│                       │   in NVARCHAR   │  └─────────────────┘              │
│                       └─────────────────┘                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Exact Numeric Data Types

### Integer Types
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INTEGER DATA TYPES                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Data Type │ Storage │        Range                    │ Usage             │
│  ──────────┼─────────┼─────────────────────────────────┼───────────────────┤
│  TINYINT   │ 1 byte  │ 0 to 255                       │ Small counters,   │
│            │         │                                 │ flags, ages       │
│  ──────────┼─────────┼─────────────────────────────────┼───────────────────┤
│  SMALLINT  │ 2 bytes │ -32,768 to 32,767              │ Small numbers,    │
│            │         │                                 │ quantities        │
│  ──────────┼─────────┼─────────────────────────────────┼───────────────────┤
│  INT       │ 4 bytes │ -2,147,483,648 to              │ Primary keys,     │
│            │         │  2,147,483,647                  │ general integers  │
│  ──────────┼─────────┼─────────────────────────────────┼───────────────────┤
│  BIGINT    │ 8 bytes │ -9,223,372,036,854,775,808 to  │ Large numbers,    │
│            │         │  9,223,372,036,854,775,807     │ timestamps        │
│  ──────────┴─────────┴─────────────────────────────────┴───────────────────┤
│                                                                             │
│  Memory Efficiency Visualization:                                          │
│  TINYINT:  [1 byte ]                                                       │
│  SMALLINT: [2 bytes]                                                       │
│  INT:      [4 bytes]                                                       │
│  BIGINT:   [8 bytes]                                                       │
│                                                                             │
│  Choose the smallest type that accommodates your range requirements!       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Examples and Best Practices
```sql
-- Integer type examples
CREATE TABLE IntegerExamples (
    -- TINYINT: Perfect for small counts, ages, etc.
    Age TINYINT,                    -- 0-255, perfect for human age
    IsActiveCode TINYINT,             -- 0-255, enough for status codes
    
    -- SMALLINT: Good for moderate-sized numbers
    YearFounded SMALLINT,           -- Years typically fit in SMALLINT
    DepartmentCode SMALLINT,        -- Department codes
    
    -- INT: Most common choice for IDs and general integers
    EmployeeID INT IDENTITY(1,1),   -- Auto-incrementing primary key
    OrderQuantity INT,              -- Order quantities
    
    -- BIGINT: For very large numbers
    TransactionID BIGINT,           -- Large transaction systems
    TimestampTicks BIGINT           -- High-precision timestamps
);

-- Choosing the right integer type
DECLARE @SmallCount TINYINT = 150;      -- Efficient for small values
DECLARE @MediumCount SMALLINT = 25000;  -- Good for medium values
DECLARE @LargeCount INT = 1500000;      -- Standard for most cases
DECLARE @VeryLargeCount BIGINT = 999999999999; -- For very large values

-- Performance consideration: Smaller types = less memory = better performance
SELECT 
    COUNT(*) as RecordCount,
    AVG(CAST(Age AS FLOAT)) AS AverageAge    -- Cast for calculation
FROM IntegerExamples
WHERE Age BETWEEN 25 AND 65;
```

### Decimal and Numeric Types
```sql
-- DECIMAL and NUMERIC (synonymous)
-- DECIMAL(precision, scale) or NUMERIC(precision, scale)
-- precision: total number of digits (1-38)
-- scale: number of digits after decimal point (0-precision)

CREATE TABLE DecimalExamples (
    -- Financial data - always use DECIMAL for money
    ProductPrice DECIMAL(10,2),     -- Up to 99,999,999.99
    TaxRate DECIMAL(5,4),           -- Up to 9.9999 (99.99%)
    ExchangeRate DECIMAL(12,6),     -- High precision rates
    
    -- Scientific data
    Measurement DECIMAL(15,8),      -- High precision measurements
    Percentage DECIMAL(5,2),        -- 0.00 to 999.99%
    
    -- Avoid FLOAT/REAL for financial data!
    -- BadPrice FLOAT,              -- DON'T USE for money!
    GoodPrice DECIMAL(18,2)         -- USE this for money!
);

-- Examples of precision and scale
DECLARE @Price1 DECIMAL(5,2) = 123.45;    -- 5 total digits, 2 after decimal
DECLARE @Price2 DECIMAL(5,2) = 999.99;    -- Maximum value
-- DECLARE @Price3 DECIMAL(5,2) = 1000.00; -- ERROR: Too many digits

-- Best practices for financial calculations
SELECT 
    ProductPrice,
    TaxRate,
    ProductPrice * TaxRate AS TaxAmount,
    ProductPrice + (ProductPrice * TaxRate) AS TotalPrice
FROM DecimalExamples;
```

### Money Types
```sql
-- MONEY and SMALLMONEY types
CREATE TABLE MoneyExamples (
    -- MONEY: 8 bytes, 4 decimal places, range ±922,337,203,685,477.5808
    LargeAmount MONEY,
    
    -- SMALLMONEY: 4 bytes, 4 decimal places, range ±214,748.3648
    SmallAmount SMALLMONEY,
    
    -- For comparison: DECIMAL equivalent
    DecimalAmount DECIMAL(19,4)     -- Similar to MONEY but more flexible
);

-- Money type examples
INSERT INTO MoneyExamples VALUES 
    ($1234567.89, $1234.56, 1234567.8900),
    ($999999.99, $9999.99, 999999.9900);

-- Money calculations
SELECT 
    LargeAmount,
    SmallAmount,
    LargeAmount + SmallAmount AS Total,
    LargeAmount * 1.08 AS WithTax,  -- 8% tax
    CAST(LargeAmount AS DECIMAL(19,4)) AS AsDecimal
FROM MoneyExamples;
```

## Approximate Numeric Data Types

### Floating Point Types
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       FLOATING POINT DATA TYPES                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Data Type │ Storage │ Precision      │ Range                   │ Usage     │
│  ──────────┼─────────┼────────────────┼─────────────────────────┼───────────┤
│  REAL      │ 4 bytes │ 7 digits       │ ±3.40E±38              │ Scientific│
│  (FLOAT(24))│        │                │                         │ data      │
│  ──────────┼─────────┼────────────────┼─────────────────────────┼───────────┤
│  FLOAT     │ 8 bytes │ 15 digits      │ ±1.79E±308              │ Scientific│
│  (FLOAT(53))│        │                │                         │ data      │
│  ──────────┴─────────┴────────────────┴─────────────────────────┴───────────┤
│                                                                             │
│  Floating Point Precision Issues:                                          │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  0.1 + 0.2 = 0.30000000000000004  ← Not exactly 0.3!                  │
│  │                                                                         │
│  │  This is why you should NEVER use FLOAT/REAL for:                      │
│  │  • Financial calculations                                               │
│  │  • Exact comparisons                                                    │
│  │  • Primary keys                                                         │
│  │                                                                         │
│  │  Use FLOAT/REAL for:                                                    │
│  │  • Scientific calculations                                              │
│  │  • Approximate values                                                   │
│  │  • Statistical analysis                                                 │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

```sql
-- Floating point examples and pitfalls
CREATE TABLE FloatingPointExamples (
    ScientificValue FLOAT,
    ApproximateValue REAL,
    ExactValue DECIMAL(15,10)
);

-- Demonstrating floating point precision issues
DECLARE @Float1 FLOAT = 0.1;
DECLARE @Float2 FLOAT = 0.2;
DECLARE @FloatSum FLOAT = @Float1 + @Float2;

DECLARE @Decimal1 DECIMAL(10,5) = 0.1;
DECLARE @Decimal2 DECIMAL(10,5) = 0.2;
DECLARE @DecimalSum DECIMAL(10,5) = @Decimal1 + @Decimal2;

SELECT 
    @FloatSum AS FloatSum,          -- May show 0.30000000000000004
    @DecimalSum AS DecimalSum,      -- Shows exactly 0.30000
    CASE 
        WHEN @FloatSum = 0.3 THEN 'Equal'
        ELSE 'Not Equal'
    END AS FloatComparison,
    CASE 
        WHEN @DecimalSum = 0.3 THEN 'Equal'
        ELSE 'Not Equal'
    END AS DecimalComparison;

-- Safe floating point comparisons
DECLARE @Tolerance FLOAT = 0.0001;
SELECT 
    CASE 
        WHEN ABS(@FloatSum - 0.3) < @Tolerance THEN 'Approximately Equal'
        ELSE 'Not Equal'
    END AS SafeFloatComparison;

-- Good uses for floating point
SELECT 
    SQRT(16.0) AS SquareRoot,       -- Mathematical functions
    PI() AS PiValue,                -- Constants
    EXP(1.0) AS EulerNumber,        -- Exponential functions
    LOG(10.0) AS NaturalLog         -- Logarithmic functions
```

## Character Data Types

### Character Type Comparison
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CHARACTER DATA TYPES                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Type      │ Storage    │ Max Length │ Character Set │ Usage               │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  CHAR(n)   │ n bytes    │ 8000       │ Non-Unicode   │ Fixed-length text   │
│            │ (fixed)    │            │               │ codes, IDs          │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  VARCHAR(n)│ actual +   │ 8000       │ Non-Unicode   │ Variable text,      │
│            │ 2 bytes    │            │               │ names, descriptions │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  VARCHAR   │ actual +   │ 2GB        │ Non-Unicode   │ Large text content  │
│  (MAX)     │ 2 bytes    │            │               │                     │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  NCHAR(n)  │ n * 2 bytes│ 4000       │ Unicode       │ Fixed international │
│            │ (fixed)    │            │               │ text                │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  NVARCHAR  │ actual * 2 │ 4000       │ Unicode       │ Variable intl text, │
│  (n)       │ + 2 bytes  │            │               │ multilingual        │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  NVARCHAR  │ actual * 2 │ 1GB        │ Unicode       │ Large multilingual  │
│  (MAX)     │ + 2 bytes  │            │               │ content             │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  TEXT      │ variable   │ 2GB        │ Non-Unicode   │ DEPRECATED - use    │
│            │            │            │               │ VARCHAR(MAX)        │
│  ──────────┼────────────┼────────────┼───────────────┼─────────────────────┤
│  NTEXT     │ variable   │ 1GB        │ Unicode       │ DEPRECATED - use    │
│            │            │            │               │ NVARCHAR(MAX)       │
│  ──────────┴────────────┴────────────┴───────────────┴─────────────────────┤
│                                                                             │
│  Storage Visualization:                                                     │
│  CHAR(10):    [T][e][x][t][ ][ ][ ][ ][ ][ ]  ← Always 10 bytes            │
│  VARCHAR(10): [T][e][x][t][#][#]              ← 4 bytes + 2 overhead       │
│  NVARCHAR(5): [T][e][x][t][#][#]              ← 4 chars * 2 + 2 overhead   │
│                                                                             │
│  Rule of Thumb:                                                             │
│  • Use NVARCHAR for international applications                              │
│  • Use VARCHAR for English-only applications                               │
│  • Use VARCHAR(MAX)/NVARCHAR(MAX) instead of TEXT/NTEXT                    │
│  • Use CHAR only for fixed-length codes                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Date and Time Data Types

### Date/Time Type Comparison
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DATE AND TIME DATA TYPES                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Type          │Storage│ Range               │ Precision    │ Usage         │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  DATE          │3 bytes│ 0001-01-01 to       │ 1 day        │ Dates only    │
│                │       │ 9999-12-31          │              │               │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  TIME          │3-5 by │ 00:00:00.0000000 to │ 100 nanosec  │ Times only    │
│                │       │ 23:59:59.9999999    │              │               │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  SMALLDATETIME │4 bytes│ 1900-01-01 to       │ 1 minute     │ Low precision │
│                │       │ 2079-06-06          │              │ datetime      │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  DATETIME      │8 bytes│ 1753-01-01 to       │ 3.33 millisec│ General       │
│                │       │ 9999-12-31          │              │ datetime      │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  DATETIME2     │6-8 by │ 0001-01-01 to       │ 100 nanosec  │ High precision│
│                │       │ 9999-12-31          │              │ datetime      │
│  ──────────────┼───────┼─────────────────────┼──────────────┼───────────────┤
│  DATETIMEOFFSET│8-10by │ 0001-01-01 to       │ 100 nanosec  │ Timezone-aware│
│                │       │ 9999-12-31          │              │ datetime      │
│  ──────────────┴───────┴─────────────────────┴──────────────┴───────────────┤
│                                                                             │
│  New in SQL Server 2008+ (including 2016):                                 │
│  • DATE, TIME, DATETIME2, DATETIMEOFFSET                                   │
│  • Better precision and range than legacy DATETIME                         │
│  • Timezone support with DATETIMEOFFSET                                    │
│                                                                             │
│  Migration Recommendation:                                                  │
│  DATETIME → DATETIME2  (better precision, same functionality)               │
│  SMALLDATETIME → DATETIME2(0)  (better range)                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Other Important Data Types

### Binary Data Types
```sql
-- Binary data types
CREATE TABLE BinaryExamples (
    -- Fixed-length binary data
    HashValue BINARY(16),           -- MD5 hash (128 bits)
    Checksum BINARY(4),             -- 32-bit checksum
    
    -- Variable-length binary data
    DocumentContent VARBINARY(MAX), -- Store files, images
    Thumbnail VARBINARY(8000),      -- Small binary data
    
    -- Legacy (avoid in new development)
    -- LegacyImage IMAGE             -- Use VARBINARY(MAX) instead
);

-- Working with binary data
DECLARE @BinaryData VARBINARY(MAX);
SET @BinaryData = CAST('Hello World' AS VARBINARY(MAX));

SELECT 
    @BinaryData AS BinaryValue,
    CAST(@BinaryData AS VARCHAR(MAX)) AS StringValue,
    LEN(@BinaryData) AS BinaryLength,
    DATALENGTH(@BinaryData) AS DataLength;
```

### Special Data Types
```sql
-- Special data types examples
CREATE TABLE SpecialTypesExamples (
    -- BIT: Boolean values
    IsActive BIT,                   -- TRUE/FALSE values
    Flags BIT,                      -- Can store multiple in bit columns
    
    -- UNIQUEIDENTIFIER: GUIDs
    RecordGuid UNIQUEIDENTIFIER DEFAULT NEWID(),
    
    -- XML: Structured XML data
    ConfigData XML,
    
    -- Spatial data types (requires spatial features)
    LocationPoint GEOGRAPHY,
    ShapeData GEOMETRY,
    
    -- Hierarchical data
    NodePath HIERARCHYID,
    
    -- Variant type (avoid if possible)
    MixedData SQL_VARIANT
);

-- Examples of special types
INSERT INTO SpecialTypesExamples (IsActive, ConfigData) VALUES 
(1, '<config><setting name="theme">dark</setting></config>'),
(0, '<config><setting name="theme">light</setting></config>');

-- Working with XML data
SELECT 
    IsActive,
    ConfigData,
    ConfigData.value('(/config/setting[@name="theme"])[1]', 'VARCHAR(50)') AS Theme
FROM SpecialTypesExamples
WHERE ConfigData IS NOT NULL;

-- Working with GUIDs
SELECT 
    RecordGuid,
    CAST(RecordGuid AS VARCHAR(36)) AS GuidString,
    NEWID() AS NewGuid
FROM SpecialTypesExamples;
```

## Data Type Conversion and Casting

### Implicit vs Explicit Conversion
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        DATA TYPE CONVERSION HIERARCHY                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Higher Precedence ↑                                                        │
│  ────────────────────                                                       │
│  sql_variant                                                                │
│  xml                                                                        │
│  datetimeoffset                                                             │
│  datetime2                                                                  │
│  datetime                                                                   │
│  smalldatetime                                                              │
│  date                                                                       │
│  time                                                                       │
│  float                                                                      │
│  real                                                                       │
│  decimal                                                                    │
│  money                                                                      │
│  smallmoney                                                                 │
│  bigint                                                                     │
│  int                                                                        │
│  smallint                                                                   │
│  tinyint                                                                    │
│  bit                                                                        │
│  ntext                                                                      │
│  text                                                                       │
│  image                                                                      │
│  timestamp                                                                  │
│  uniqueidentifier                                                           │
│  nvarchar (including MAX)                                                   │
│  nchar                                                                      │
│  varchar (including MAX)                                                    │
│  char                                                                       │
│  varbinary (including MAX)                                                  │
│  binary                                                                     │
│  Lower Precedence ↓                                                         │
│                                                                             │
│  Rules:                                                                     │
│  • Higher precedence type wins in mixed operations                         │
│  • Implicit conversion happens automatically when safe                     │
│  • Explicit conversion required for potentially lossy operations           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

```sql
-- Conversion examples
-- Implicit conversions (automatic)
DECLARE @Int INT = 42;
DECLARE @Float FLOAT;
SET @Float = @Int;                  -- INT → FLOAT (safe, automatic)

DECLARE @String VARCHAR(10);
SET @String = CAST(@Int AS VARCHAR(10)); -- Explicit conversion required

-- Explicit conversions with CAST and CONVERT
SELECT 
    CAST(123.456 AS INT) AS CastToInt,                    -- 123
    CONVERT(VARCHAR(10), 123.456) AS ConvertToString,     -- '123.456'
    CAST('2023-12-25' AS DATE) AS CastToDate,            -- 2023-12-25
    CONVERT(VARCHAR(10), GETDATE(), 101) AS USDateFormat, -- MM/DD/YYYY
    TRY_CAST('invalid' AS INT) AS SafeCast,               -- NULL if fails
    TRY_CONVERT(DATE, 'bad date') AS SafeConvert;         -- NULL if fails

-- Data type precedence in operations
SELECT 
    5 + 2.5 AS MixedMath,           -- Result is DECIMAL(2,1): 7.5
    '5' + 2 AS StringPlusInt,       -- Result is INT: 7 (string converted)
    5 + '2.5' AS IntPlusString,     -- Result is DECIMAL: 7.5
    CONCAT(5, 2.5) AS Concatenation; -- Result is STRING: '52.5'

-- Avoiding conversion issues
DECLARE @StringNumber VARCHAR(10) = '123abc';
SELECT 
    -- TRY_CAST returns NULL instead of error
    TRY_CAST(@StringNumber AS INT) AS SafeConversion,
    -- ISNUMERIC checks if string can be converted
    ISNUMERIC(@StringNumber) AS IsNumeric,
    -- ISDATE checks if string is valid date
    ISDATE('2023-13-45') AS IsValidDate;
```

## Choosing the Right Data Type

### Decision Tree for Data Type Selection
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        DATA TYPE SELECTION GUIDE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                            What kind of data?                              │
│                                    │                                        │
│        ┌───────────────┬────────────┼────────────┬───────────────┐          │
│        │               │            │            │               │          │
│     Numbers         Text        Dates       True/False      Binary         │
│        │               │            │            │               │          │
│        ▼               ▼            ▼            ▼               ▼          │
│                                                                             │
│   Money/Finance?   International?  Need Time?   Simple Flag?   File Data?   │
│   ├─Yes→DECIMAL     ├─Yes→NVARCHAR  ├─Yes→      └─Yes→BIT       ├─Yes→      │
│   └─No              └─No→VARCHAR      DATETIME2                └─No        │
│      │                   │            └─No→DATE                  │          │
│      ▼                   ▼                                       ▼          │
│   Whole Numbers?      Fixed Length?                          VARBINARY      │
│   ├─Yes              ├─Yes→CHAR                                             │
│   │  │               └─No→VARCHAR                                           │
│   │  ▼                                                                      │
│   │ Range?                                                                  │
│   │ ├─0-255→TINYINT                                                         │
│   │ ├─±32K→SMALLINT                                                         │
│   │ ├─±2B→INT                                                               │
│   │ └─Larger→BIGINT                                                         │
│   │                                                                         │
│   └─No→DECIMAL(p,s)                                                         │
│                                                                             │
│  Special Considerations:                                                    │
│  • Use smallest type that fits your range                                  │
│  • Avoid deprecated types (TEXT, NTEXT, IMAGE)                             │
│  • Consider NULL requirements                                               │
│  • Plan for future growth                                                  │
│  • Consider indexing and query performance                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Best Practices Summary

```sql
-- Best practices for data type selection

-- 1. Use appropriate integer sizes
CREATE TABLE BestPracticesExample (
    -- Good: Right-sized integers
    Age TINYINT,                    -- 0-255 is perfect for age
    ProductCode SMALLINT,           -- Enough for product codes
    OrderID INT IDENTITY(1,1),      -- Standard for auto-incrementing IDs
    TransactionNumber BIGINT,       -- For very large transaction systems
    
    -- 2. Use DECIMAL for financial data
    Price DECIMAL(18,2),            -- Never FLOAT for money!
    TaxRate DECIMAL(5,4),           -- High precision for rates
    
    -- 3. Choose appropriate string types
    CountryCode CHAR(2),            -- Fixed length: US, CA, UK
    ProductName NVARCHAR(100),      -- Variable, international
    Description NVARCHAR(MAX),      -- Large text content
    
    -- 4. Use modern date/time types
    OrderDate DATE,                 -- Date only
    OrderTime TIME(3),              -- Time with millisecond precision
    CreatedDateTime DATETIME2(7),   -- High precision datetime
    LastModifiedUTC DATETIMEOFFSET, -- Timezone-aware
    
    -- 5. Use appropriate types for flags
    IsActive BIT,                   -- Simple boolean
    IsActiveFlags TINYINT,            -- Multiple flags (bit operations)
    
    -- 6. Modern binary storage
    DocumentContent VARBINARY(MAX), -- Instead of IMAGE
    Thumbnail VARBINARY(8000),      -- For smaller binary data
    
    -- 7. Use constraints to enforce data integrity
    CONSTRAINT CK_Age CHECK (Age >= 0 AND Age <= 150),
    CONSTRAINT CK_TaxRate CHECK (TaxRate >= 0 AND TaxRate <= 1),
    CONSTRAINT CK_CountryCode CHECK (LEN(CountryCode) = 2)
);

-- 8. Provide meaningful defaults
ALTER TABLE BestPracticesExample 
ADD CONSTRAINT DF_IsActive DEFAULT (1) FOR IsActive;

ALTER TABLE BestPracticesExample 
ADD CONSTRAINT DF_CreatedDateTime DEFAULT (SYSDATETIME()) FOR CreatedDateTime;
```

## SQL Server 2016 Enhancements

### JSON Support
```sql
-- SQL Server 2016 introduced JSON support
CREATE TABLE JSONExample (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ProductData NVARCHAR(MAX),
    -- Add constraint to ensure valid JSON
    CONSTRAINT CK_ValidJSON CHECK (ISJSON(ProductData) = 1)
);

-- Working with JSON data
INSERT INTO JSONExample (ProductData) VALUES 
(N'{"name": "Laptop", "price": 999.99, "specs": {"ram": "16GB", "storage": "512GB SSD"}}'),
(N'{"name": "Mouse", "price": 29.99, "specs": {"type": "wireless", "dpi": 1600}}');

-- Querying JSON data
SELECT 
    ID,
    JSON_VALUE(ProductData, '$.name') AS ProductName,
    JSON_VALUE(ProductData, '$.price') AS Price,
    JSON_VALUE(ProductData, '$.specs.ram') AS RAM,
    JSON_QUERY(ProductData, '$.specs') AS Specifications
FROM JSONExample;

-- JSON aggregation
SELECT 
    JSON_QUERY('[' + STRING_AGG(ProductData, ',') + ']') AS AllProducts
FROM JSONExample;
```

### Always Encrypted Support
```sql
-- Always Encrypted (SQL Server 2016+)
-- Note: This requires client-side configuration

-- Create column master key and column encryption key first
-- (This would be done through SSMS or PowerShell)

-- Example table with encrypted columns
CREATE TABLE EncryptedData (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PublicData NVARCHAR(100),
    -- These columns would be encrypted with Always Encrypted
    SSN CHAR(11), -- ENCRYPTED WITH (...)
    BaseSalary DECIMAL(10,2) -- ENCRYPTED WITH (...)
    -- Actual encryption syntax requires pre-configured keys
);
```

### Temporal Tables (System-Versioned)
```sql
-- Temporal tables track data changes over time
CREATE TABLE EmployeeHistory (
    EmployeeID INT NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BaseSalary DECIMAL(10,2),
    Department NVARCHAR(50),
    
    -- Required for temporal tables
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START,
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory_Archive));

-- Querying temporal data
-- Current data
SELECT * FROM EmployeeHistory;

-- All historical data
SELECT * FROM EmployeeHistory FOR SYSTEM_TIME ALL
WHERE EmployeeID = 1;

-- Data as of specific time
SELECT * FROM EmployeeHistory FOR SYSTEM_TIME AS OF '2023-01-01'
WHERE EmployeeID = 1;
```

## Performance Considerations

### Storage and Performance Impact
```sql
-- Storage size comparison
CREATE TABLE StorageComparison (
    ID INT,
    
    -- Different string storage approaches
    FixedChar CHAR(50),         -- Always 50 bytes
    VariableChar VARCHAR(50),   -- 1-52 bytes (data + 2 byte overhead)
    UnicodeFixed NCHAR(50),     -- Always 100 bytes (50 * 2)
    UnicodeVariable NVARCHAR(50), -- 2-102 bytes (data * 2 + 2 overhead)
    
    -- Numeric type efficiency
    TinyValue TINYINT,          -- 1 byte
    SmallValue SMALLINT,        -- 2 bytes  
    RegularValue INT,           -- 4 bytes
    BigValue BIGINT,            -- 8 bytes
    
    -- Date type efficiency
    DateOnly DATE,              -- 3 bytes
    DateTimeOld DATETIME,       -- 8 bytes
    DateTimeNew DATETIME2(3),   -- 7 bytes with millisecond precision
    DateTimeFull DATETIME2(7)   -- 8 bytes with nanosecond precision
);

-- Calculate storage impact
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StorageComparison'
ORDER BY ORDINAL_POSITION;

-- Performance tips
-- 1. Use appropriate data types for better index performance
CREATE INDEX IX_Efficient ON StorageComparison (TinyValue, DateOnly);

-- 2. Avoid unnecessary data type conversions in queries
-- Good: Types match
SELECT * FROM StorageComparison WHERE TinyValue = 1;

-- Less efficient: Requires conversion
-- SELECT * FROM StorageComparison WHERE TinyValue = 1.0; -- FLOAT literal
```

## Common Mistakes and Solutions

### Type Selection Mistakes
```sql
-- Common mistakes and their solutions

-- MISTAKE 1: Using VARCHAR(MAX) for everything
-- Problem: Poor performance, excessive storage
CREATE TABLE BadExample (
    ProductCode VARCHAR(MAX),       -- BAD: Only needs 10 characters
    Description VARCHAR(MAX)        -- BAD: Might need it, but probably not
);

-- Solution: Use appropriate sizes
CREATE TABLE GoodExample (
    ProductCode VARCHAR(10),        -- GOOD: Right-sized
    Description NVARCHAR(500)       -- GOOD: Reasonable limit
);

-- MISTAKE 2: Using FLOAT for money
-- Problem: Precision issues
DECLARE @BadPrice FLOAT = 19.99;
DECLARE @Quantity INT = 3;
SELECT @BadPrice * @Quantity AS BadTotal;  -- Might not be exactly 59.97

-- Solution: Use DECIMAL
DECLARE @GoodPrice DECIMAL(10,2) = 19.99;
DECLARE @GoodQuantity INT = 3;
SELECT @GoodPrice * @GoodQuantity AS GoodTotal;  -- Exactly 59.97

-- MISTAKE 3: Using DATETIME instead of DATE for date-only data
-- Problem: Unnecessary storage and potential time component issues
CREATE TABLE BadDates (
    BirthDate DATETIME,             -- BAD: Includes time component
    EventDate DATETIME              -- BAD: 8 bytes instead of 3
);

-- Solution: Use appropriate date types
CREATE TABLE GoodDates (
    BirthDate DATE,                 -- GOOD: Date only, 3 bytes
    EventDateTime DATETIME2(3)      -- GOOD: If time is needed
);

-- MISTAKE 4: Not considering NULL behavior
-- Problem: Unexpected results with NULLs
CREATE TABLE NullIssues (
    Score INT,
    IsActive BIT
);

-- This might not work as expected if Score can be NULL
SELECT * FROM NullIssues WHERE Score > 50;  -- NULLs excluded!

-- Solution: Handle NULLs explicitly
SELECT * FROM NullIssues 
WHERE Score > 50 OR Score IS NULL;  -- Include NULLs if desired

-- Or prevent NULLs with constraints
ALTER TABLE NullIssues 
ALTER COLUMN Score INT NOT NULL;
```

## Summary

Key takeaways for SQL Server 2016 data types:

### 1. **Choose Appropriate Sizes**
- Use the smallest data type that accommodates your range
- Consider future growth but don't over-allocate
- Smaller types = better performance and less storage

### 2. **Financial Data Best Practices**
- Always use DECIMAL/NUMERIC for money
- Never use FLOAT/REAL for financial calculations
- Consider MONEY type for simpler financial applications

### 3. **String Data Guidelines**
- Use NVARCHAR for international applications
- Use VARCHAR for English-only applications
- Avoid deprecated TEXT/NTEXT types
- Use VARCHAR(MAX)/NVARCHAR(MAX) for large content

### 4. **Date and Time Recommendations**
- Use DATE for date-only storage
- Use DATETIME2 instead of DATETIME for new applications
- Use DATETIMEOFFSET for timezone-aware applications
- Consider TIME type for time-only storage

### 5. **Performance Considerations**
- Proper data types enable better indexing
- Avoid unnecessary data type conversions
- Consider storage requirements for large tables
- Use constraints to enforce data integrity

### 6. **SQL Server 2016 Features**
- JSON support in NVARCHAR columns
- Always Encrypted for sensitive data
- Temporal tables for audit trails
- Improved performance for modern data types

Understanding data types is fundamental to efficient database design and optimal query performance. Choose wisely based on your specific requirements, considering both current needs and future scalability.
