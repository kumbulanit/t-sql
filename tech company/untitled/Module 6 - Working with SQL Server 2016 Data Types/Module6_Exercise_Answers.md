# Module 6 Exercise Answers: Working with SQL Server 2016 Data Types

## Exercise Set 1: Introducing SQL Server 2016 Data Types (Lesson 1) - Answers

### Exercise 1.1: Data Type Fundamentals - Answers

**Tasks Solutions**:

1. **Create employee table with appropriate data types**:

```sql
CREATE TABLE Employees_DataTypes (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    ProfilePhoto VARBINARY(MAX) NULL
);
```

2. **Demonstrate storage size differences between VARCHAR and NVARCHAR**:

```sql
-- Create test table
CREATE TABLE StorageComparison (
    ID INT IDENTITY(1,1),
    VarcharColumn VARCHAR(50),
    NVarcharColumn NVARCHAR(50)
);

-- Insert sample data
INSERT INTO StorageComparison (VarcharColumn, NVarcharColumn)
VALUES ('Hello World', N'Hello World');

-- Check actual storage usage
SELECT 
    DATALENGTH(VarcharColumn) as VarcharBytes,
    DATALENGTH(NVarcharColumn) as NVarcharBytes,
    LEN(VarcharColumn) as VarcharLength,
    LEN(NVarcharColumn) as NVarcharLength
FROM StorageComparison;

-- Result: VARCHAR(50) uses 11 bytes, NVARCHAR(50) uses 22 bytes for 'Hello World'
```

3. **Demonstrate DECIMAL precision and scale**:

```sql
-- Create table with different DECIMAL configurations
CREATE TABLE DecimalExamples (
    ID INT IDENTITY(1,1),
    Price1 DECIMAL(5,2),  -- Max: 999.99
    Price2 DECIMAL(10,4), -- Max: 999999.9999
    Price3 DECIMAL(18,0)  -- Integer, max: 999,999,999,999,999,999
);

-- Insert test data
INSERT INTO DecimalExamples (Price1, Price2, Price3)
VALUES (123.45, 12345.6789, 123456789012345678);

-- Show precision and scale behavior
SELECT Price1, Price2, Price3 FROM DecimalExamples;
```

4. **Demonstrate integer type ranges**:

```sql
-- Create table with different integer types
CREATE TABLE IntegerRanges (
    TinyIntCol TINYINT,      -- 0 to 255
    SmallIntCol SMALLINT,    -- -32,768 to 32,767
    IntCol INT,              -- -2,147,483,648 to 2,147,483,647
    BigIntCol BIGINT         -- -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
);

-- Insert maximum values
INSERT INTO IntegerRanges VALUES (255, 32767, 2147483647, 9223372036854775807);

-- Try to insert values that exceed limits (will cause errors)
-- INSERT INTO IntegerRanges VALUES (256, 32768, 2147483648, 9223372036854775808);
```

**Questions Answers**:

1. **Difference between exact numeric and approximate numeric data types**:
   - **Exact numeric**: DECIMAL, NUMERIC, INT, BIGINT - exact representation
   - **Approximate numeric**: FLOAT, REAL - may have rounding differences
   - Exact types are preferred for financial calculations
   - Approximate types are faster for scientific calculations

2. **When to choose VARCHAR over CHAR**:
   - **VARCHAR**: When string lengths vary significantly (saves space)
   - **CHAR**: When all strings are the same length (slight performance advantage)
   - VARCHAR is more commonly used in modern applications
   - CHAR is better for fixed-format codes (like country codes)

3. **How Unicode support affects storage requirements**:
   - Unicode (NVARCHAR, NCHAR) uses 2 bytes per character
   - Non-Unicode (VARCHAR, CHAR) uses 1 byte per character
   - Unicode supports international character sets
   - Doubles storage requirements but provides global compatibility

4. **Implications of choosing wrong data type**:
   - **Performance**: Inefficient queries and increased I/O
   - **Storage**: Wasted space or insufficient precision
   - **Data integrity**: Truncation or precision loss
   - **Maintenance**: Difficult to change later without downtime

### Exercise 1.2: Data Type Categories - Answers

**Tasks Solutions**:

1. **Comprehensive table showing data type categories**:

```sql
CREATE TABLE DataTypeExamples (
    -- Exact numeric types
    TinyIntExample TINYINT,
    SmallIntExample SMALLINT,
    IntExample INT,
    BigIntExample BIGINT,
    DecimalExample DECIMAL(10,2),
    
    -- Approximate numeric types
    FloatExample FLOAT,
    RealExample REAL,
    
    -- Date and time types
    DateExample DATE,
    TimeExample TIME,
    DateTimeExample DATETIME,
    DateTime2Example DATETIME2(3),
    DateTimeOffsetExample DATETIMEOFFSET,
    
    -- Character string types
    CharExample CHAR(10),
    VarcharExample VARCHAR(50),
    TextExample VARCHAR(MAX),
    
    -- Unicode character string types
    NCharExample NCHAR(10),
    NVarcharExample NVARCHAR(50),
    NTextExample NVARCHAR(MAX),
    
    -- Binary string types
    BinaryExample BINARY(8),
    VarbinaryExample VARBINARY(100),
    ImageExample VARBINARY(MAX)
);
```

2. **Demonstrate implicit conversions**:

```sql
-- Implicit conversion examples
SELECT 
    123 + 45.67 as IntPlusDecimal,        -- INT converted to DECIMAL
    'Order #' + CAST(123 AS VARCHAR(10)) as StringConcat,  -- Explicit conversion required
    GETDATE() + 30 as DatePlusDays;       -- INT converted to days
```

3. **Examples of explicit conversion using CAST and CONVERT**:

```sql
-- CAST examples
SELECT 
    CAST(123.456 AS INT) as CastToInt,
    CAST('2023-12-25' AS DATE) as CastToDate,
    CAST(12345.67 AS VARCHAR(20)) as CastToString;

-- CONVERT examples (SQL Server specific)
SELECT 
    CONVERT(INT, 123.456) as ConvertToInt,
    CONVERT(VARCHAR(20), GETDATE(), 101) as ConvertDateUSFormat,
    CONVERT(VARCHAR(20), GETDATE(), 103) as ConvertDateUKFormat;
```

4. **Demonstrate data type precedence**:

```sql
-- Data type precedence demonstration
SELECT 
    SQL_VARIANT_PROPERTY(123 + 45.67, 'BaseType') as ResultType1,
    SQL_VARIANT_PROPERTY('123' + 45, 'BaseType') as ResultType2;  -- Error: must convert explicitly
```

**Questions Answers**:

1. **Data type precedence and importance**:
   - Determines which data type is used in mixed expressions
   - Higher precedence types "win" in conversions
   - Order: User-defined types, sql_variant, xml, datetimeoffset, datetime2, datetime, smalldatetime, date, time, float, real, decimal, money, smallmoney, bigint, int, smallint, tinyint, bit, ntext, text, image, timestamp, uniqueidentifier, nvarchar, nchar, varchar, char, varbinary, binary
   - Important for avoiding unexpected conversion errors

2. **How SQL Server handles mixed data types**:
   - Automatic implicit conversion when possible
   - Uses data type precedence rules
   - May result in precision loss or errors
   - Best practice: be explicit with conversions

3. **Risks of implicit conversions**:
   - Unexpected results or precision loss
   - Performance impact (prevents index usage)
   - Potential runtime errors
   - Maintenance issues when data types change

4. **When to use CAST vs CONVERT**:
   - **CAST**: ANSI standard, portable across databases
   - **CONVERT**: SQL Server specific, more formatting options
   - Use CAST for simple conversions
   - Use CONVERT for date/time formatting

### Exercise 1.3: Choosing Appropriate Data Types - Answers

**Tasks Solutions**:

1. **Analyze and improve poor table design**:

```sql
-- Original bad design
CREATE TABLE BadExample (
    ID NVARCHAR(100),     -- Should be INT IDENTITY
    Age NVARCHAR(10),     -- Should be TINYINT
    BaseSalary NVARCHAR(20),  -- Should be DECIMAL(10,2)
    HireDate NVARCHAR(30),-- Should be DATE
    IsActive NVARCHAR(5)  -- Should be BIT
);

-- Improved design
CREATE TABLE GoodExample (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Age TINYINT CHECK (Age BETWEEN 16 AND 120),
    BaseSalary DECIMAL(10,2) CHECK (BaseSalary >= 0),
    HireDate DATE,
    IsActive BIT NOT NULL DEFAULT 1
);
```

2. **Script to safely migrate data**:

```sql
-- Insert sample bad data
INSERT INTO BadExample VALUES 
('1', '25', '50000.00', '2020-01-15', 'True'),
('2', '35', '75000.50', '2019-06-10', 'False'),
('3', 'Invalid', 'Not a number', 'Invalid Date', 'Maybe');

-- Safe migration with error handling
INSERT INTO GoodExample (Age, BaseSalary, HireDate, IsActive)
SELECT 
    CASE 
        WHEN ISNUMERIC(Age) = 1 AND CAST(Age AS INT) BETWEEN 16 AND 120 
        THEN CAST(Age AS TINYINT) 
        ELSE NULL 
    END,
    CASE 
        WHEN ISNUMERIC(BaseSalary) = 1 
        THEN CAST(BaseSalary AS DECIMAL(10,2)) 
        ELSE NULL 
    END,
    CASE 
        WHEN ISDATE(HireDate) = 1 
        THEN CAST(HireDate AS DATE) 
        ELSE NULL 
    END,
    CASE 
        WHEN UPPER(IsActive) IN ('TRUE', '1', 'YES') THEN 1
        WHEN UPPER(IsActive) IN ('FALSE', '0', 'NO') THEN 0
        ELSE 0
    END
FROM BadExample
WHERE ISNUMERIC(ID) = 1;  -- Only migrate valid IDs
```

3. **Calculate storage space savings**:

```sql
-- Calculate storage requirements
WITH StorageCalculation AS (
    SELECT 
        -- Bad design storage per row
        100 * 2 +    -- ID: NVARCHAR(100) = 200 bytes max
        10 * 2 +     -- Age: NVARCHAR(10) = 20 bytes max  
        20 * 2 +     -- BaseSalary: NVARCHAR(20) = 40 bytes max
        30 * 2 +     -- HireDate: NVARCHAR(30) = 60 bytes max
        5 * 2        -- IsActive: NVARCHAR(5) = 10 bytes max
        as BadDesignMaxBytes,
        
        -- Good design storage per row
        4 +          -- ID: INT = 4 bytes
        1 +          -- Age: TINYINT = 1 byte
        9 +          -- BaseSalary: DECIMAL(10,2) = 9 bytes
        3 +          -- HireDate: DATE = 3 bytes
        1            -- IsActive: BIT = 1 byte (approximately)
        as GoodDesignBytes
)
SELECT 
    BadDesignMaxBytes,
    GoodDesignBytes,
    BadDesignMaxBytes - GoodDesignBytes as SpaceSavedPerRow,
    (BadDesignMaxBytes - GoodDesignBytes) * 100.0 / BadDesignMaxBytes as PercentSavings
FROM StorageCalculation;
```

4. **Performance comparison queries**:

```sql
-- Performance test: searching in bad design
SELECT COUNT(*) FROM BadExample WHERE Age = '25';

-- Performance test: searching in good design  
SELECT COUNT(*) FROM GoodExample WHERE Age = 25;

-- The good design will be much faster due to proper indexing and data types
```

**Questions Answers**:

1. **Performance implications of inappropriate data types**:
   - **Index inefficiency**: Wrong types prevent optimal index usage
   - **Conversion overhead**: Implicit conversions slow queries
   - **Storage bloat**: Oversized types waste space and memory
   - **Comparison slowdown**: String comparisons slower than numeric

2. **Planning for future data growth**:
   - Choose types with appropriate ranges for expected growth
   - Consider VARCHAR over CHAR for variable-length data
   - Plan for international requirements (Unicode)
   - Balance current needs with future scalability

3. **Considerations for international applications**:
   - Use Unicode data types (NVARCHAR, NCHAR)
   - Consider collation settings for sorting/comparison
   - Plan for different date/time formats
   - Account for currency and numeric formatting differences

4. **How data types affect indexing strategies**:
   - Smaller data types create more efficient indexes
   - Variable-length types may cause index fragmentation
   - Appropriate types enable better index seeks
   - Wrong types may prevent index usage entirely

## Exercise Set 2: Working with Character Data (Lesson 2) - Answers

### Exercise 2.1: String Data Types and Storage - Answers

**Tasks Solutions**:

1. **Compare CHAR, VARCHAR, NCHAR, and NVARCHAR**:

```sql
-- Create comparison table
CREATE TABLE StringComparison (
    ID INT IDENTITY(1,1),
    CharCol CHAR(10),
    VarcharCol VARCHAR(10),
    NCharCol NCHAR(10),
    NVarcharCol NVARCHAR(10)
);

-- Insert test data
INSERT INTO StringComparison VALUES 
('ABC', 'ABC', N'ABC', N'ABC'),
('1234567890', '1234567890', N'1234567890', N'1234567890');

-- Check storage and behavior
SELECT 
    '[' + CharCol + ']' as CharWithBrackets,
    '[' + VarcharCol + ']' as VarcharWithBrackets,
    '[' + NCharCol + ']' as NCharWithBrackets,
    '[' + NVarcharCol + ']' as NVarcharWithBrackets,
    DATALENGTH(CharCol) as CharBytes,
    DATALENGTH(VarcharCol) as VarcharBytes,
    DATALENGTH(NCharCol) as NCharBytes,
    DATALENGTH(NVarcharCol) as NVarcharBytes
FROM StringComparison;
```

2. **Demonstrate trailing spaces with CHAR vs VARCHAR**:

```sql
CREATE TABLE SpaceTest (
    CharCol CHAR(10),
    VarcharCol VARCHAR(10)
);

INSERT INTO SpaceTest VALUES ('ABC   ', 'ABC   ');

-- Show trailing space behavior
SELECT 
    '[' + CharCol + ']' as CharColumn,
    '[' + VarcharCol + ']' as VarcharColumn,
    LEN(CharCol) as CharLength,
    LEN(VarcharCol) as VarcharLength,
    DATALENGTH(CharCol) as CharBytes,
    DATALENGTH(VarcharCol) as VarcharBytes
FROM SpaceTest;

-- Comparison behavior
SELECT 
    CASE WHEN CharCol = 'ABC' THEN 'Equal' ELSE 'Not Equal' END as CharComparison,
    CASE WHEN VarcharCol = 'ABC' THEN 'Equal' ELSE 'Not Equal' END as VarcharComparison
FROM SpaceTest;
```

3. **Compare storage requirements**:

```sql
CREATE TABLE StorageTest (
    SmallVarchar VARCHAR(100),
    LargeVarchar VARCHAR(8000),
    MaxVarchar VARCHAR(MAX)
);

-- Insert test data of different sizes
INSERT INTO StorageTest VALUES 
('Small text', 'Small text in large column', 'Small text in MAX column');

-- Check actual storage usage
SELECT 
    DATALENGTH(SmallVarchar) as SmallVarcharBytes,
    DATALENGTH(LargeVarchar) as LargeVarcharBytes,
    DATALENGTH(MaxVarchar) as MaxVarcharBytes
FROM StorageTest;
```

4. **Demonstrate VARCHAR(MAX) vs VARCHAR(8000)**:

```sql
-- VARCHAR(8000) - stored in-row
CREATE TABLE RegularVarchar (
    ID INT IDENTITY(1,1),
    TextData VARCHAR(8000)
);

-- VARCHAR(MAX) - may be stored out-of-row for large values
CREATE TABLE MaxVarchar (
    ID INT IDENTITY(1,1),
    TextData VARCHAR(MAX)
);

-- Insert large text data
DECLARE @LargeText VARCHAR(MAX) = REPLICATE('This is a test string. ', 1000);

INSERT INTO RegularVarchar (TextData) VALUES (LEFT(@LargeText, 8000));
INSERT INTO MaxVarchar (TextData) VALUES (@LargeText);
```

**Questions Answers**:

1. **When to use fixed-length vs variable-length character types**:
   - **Fixed-length (CHAR)**: When all values are the same length (codes, flags)
   - **Variable-length (VARCHAR)**: When lengths vary significantly
   - CHAR has slight performance advantage for fixed-size data
   - VARCHAR saves storage space for variable-length data

2. **How trailing spaces affect comparisons and indexing**:
   - CHAR automatically pads with spaces, affecting comparisons
   - VARCHAR preserves trailing spaces but ignores them in comparisons
   - Can cause unexpected JOIN failures or WHERE clause misses
   - Index seeks may be affected by space handling

3. **Limitations of MAX data types**:
   - Cannot be used in indexes beyond 900 bytes
   - May be stored out-of-row, affecting performance
   - Cannot be used in some functions and operations
   - Limited sorting and grouping capabilities

4. **How page compression affects character data**:
   - Removes duplicate string prefixes and suffixes
   - More effective with repetitive data
   - Can significantly reduce storage for structured text
   - Trade-off between CPU overhead and storage savings

### Exercise 2.2: String Functions and Manipulation - Answers

**Tasks Solutions**:

1. **Various string functions demonstration**:

```sql
-- Create test data
DECLARE @TestString NVARCHAR(100) = '  Hello World!  ';

SELECT 
    @TestString as OriginalString,
    LEN(@TestString) as StringLength,
    DATALENGTH(@TestString) as DataLength,
    LEFT(@TestString, 5) as LeftFive,
    RIGHT(@TestString, 5) as RightFive,
    SUBSTRING(@TestString, 3, 5) as SubstringExample,
    LTRIM(@TestString) as LeftTrimmed,
    RTRIM(@TestString) as RightTrimmed,
    LTRIM(RTRIM(@TestString)) as BothTrimmed,
    UPPER(@TestString) as UpperCase,
    LOWER(@TestString) as LowerCase,
    REPLACE(@TestString, 'World', 'Universe') as ReplacedString,
    STUFF(@TestString, 8, 5, 'SQL Server') as StuffedString;
```

2. **Clean and standardize customer names**:

```sql
-- Sample customer data with inconsistent formatting
CREATE TABLE #CompanyNames (
    CustomerID INT,
    RawName NVARCHAR(100)
);

INSERT INTO #CompanyNames VALUES 
(1, '  JOHN    SMITH  '),
(2, 'mary   JONES'),
(3, 'bob  o''connor ');

-- Clean and standardize
SELECT 
    CustomerID,
    RawName,
    -- Clean and proper case
    UPPER(LEFT(LTRIM(RTRIM(RawName)), 1)) + 
    LOWER(SUBSTRING(LTRIM(RTRIM(RawName)), 2, LEN(LTRIM(RTRIM(RawName))))) as CleanedName,
    -- Remove extra spaces
    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(RawName, '  ', ' '), '  ', ' '), '  ', ' '))) as NoExtraSpaces
FROM #CompanyNames;
```

3. **Validation and formatting functions**:

```sql
-- Phone number formatting function
CREATE FUNCTION FormatPhoneNumber(@PhoneNumber NVARCHAR(20))
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @CleanPhone NVARCHAR(20);
    
    -- Remove all non-numeric characters
    SET @CleanPhone = @PhoneNumber;
    WHILE PATINDEX('%[^0-9]%', @CleanPhone) > 0
        SET @CleanPhone = STUFF(@CleanPhone, PATINDEX('%[^0-9]%', @CleanPhone), 1, '');
    
    -- Format as (XXX) XXX-XXXX if 10 digits
    IF LEN(@CleanPhone) = 10
        SET @CleanPhone = '(' + LEFT(@CleanPhone, 3) + ') ' + 
                         SUBSTRING(@CleanPhone, 4, 3) + '-' + 
                         RIGHT(@CleanPhone, 4);
    
    RETURN @CleanPhone;
END;

-- Test the function
SELECT dbo.FormatPhoneNumber('1234567890') as FormattedPhone;

-- WorkEmail validation (basic)
SELECT 
    WorkEmail,
    CASE 
        WHEN WorkEmail LIKE '%_@_%._%' AND WorkEmail NOT LIKE '%@%@%' 
        THEN 'Valid Format' 
        ELSE 'Invalid Format' 
    END as EmailValidation
FROM (VALUES 
    ('user@domain.com'),
    ('invalid.email'),
    ('user@@domain.com')
) AS EmailTests(WorkEmail);
```

4. **String concatenation methods**:

```sql
-- Different concatenation approaches
DECLARE @FirstName NVARCHAR(50) = 'John';
DECLARE @LastName NVARCHAR(50) = 'Smith';
DECLARE @MiddleInitial NVARCHAR(1) = NULL;

SELECT 
    -- + operator (returns NULL if any part is NULL)
    @FirstName + ' ' + @LastName as PlusOperator,
    
    -- CONCAT function (handles NULLs gracefully)
    CONCAT(@FirstName, ' ', @MiddleInitial, ' ', @LastName) as ConcatFunction,
    
    -- Using ISNULL to handle NULLs with + operator
    @FirstName + ISNULL(' ' + @MiddleInitial, '') + ' ' + @LastName as PlusWithISNULL;

-- STRING_AGG example (SQL Server 2017+)
-- SELECT STRING_AGG(ProductName, ', ') as ProductList FROM Products WHERE CategoryID = 1;
```

**Questions Answers**:

1. **Difference between LEN() and DATALENGTH()**:
   - **LEN()**: Returns number of characters, excludes trailing spaces
   - **DATALENGTH()**: Returns number of bytes used for storage
   - For Unicode data, DATALENGTH is typically 2x LEN
   - LEN is affected by data type (CHAR vs VARCHAR trailing space handling)

2. **How string functions handle NULL values**:
   - Most string functions return NULL when input is NULL
   - Concatenation with + operator returns NULL if any operand is NULL
   - CONCAT() function treats NULL as empty string
   - Use ISNULL() or COALESCE() to handle NULLs explicitly

3. **Performance considerations for string manipulation**:
   - String functions can prevent index usage in WHERE clauses
   - LIKE with leading wildcards requires table scans
   - Complex string manipulation should be done in application layer when possible
   - Consider computed columns for frequently used string expressions

4. **When to use LIKE vs string functions for pattern matching**:
   - **LIKE**: Simple wildcard patterns, can use indexes with trailing wildcards
   - **String functions**: Complex logic, exact position matching
   - LIKE is more efficient for simple pattern matching
   - String functions offer more flexibility but are slower

### Exercise 2.3: Collation and Cultural Considerations - Answers

**Tasks Solutions**:

1. **Demonstrate effects of different collations**:

```sql
-- Create tables with different collations
CREATE TABLE CaseSensitiveTest (
    ID INT IDENTITY(1,1),
    CaseSensitiveColumn VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS,
    CaseInsensitiveColumn VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
);

-- Insert test data
INSERT INTO CaseSensitiveTest VALUES ('Apple', 'Apple'), ('APPLE', 'APPLE'), ('apple', 'apple');

-- Demonstrate case sensitivity differences
SELECT * FROM CaseSensitiveTest WHERE CaseSensitiveColumn = 'Apple';
SELECT * FROM CaseSensitiveTest WHERE CaseInsensitiveColumn = 'Apple';

-- Sorting differences
SELECT CaseSensitiveColumn FROM CaseSensitiveTest ORDER BY CaseSensitiveColumn;
SELECT CaseInsensitiveColumn FROM CaseSensitiveTest ORDER BY CaseInsensitiveColumn;
```

2. **Collation conflicts and resolution**:

```sql
-- Create tables with different collations
CREATE TABLE Table1 (ID INT, Name VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS);
CREATE TABLE Table2 (ID INT, Name VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS);

INSERT INTO Table1 VALUES (1, 'Test');
INSERT INTO Table2 VALUES (1, 'Test');

-- This will cause a collation conflict
-- SELECT * FROM Table1 t1 JOIN Table2 t2 ON t1.Name = t2.Name;

-- Resolution using COLLATE clause
SELECT * FROM Table1 t1 
JOIN Table2 t2 ON t1.Name = t2.Name COLLATE SQL_Latin1_General_CP1_CI_AS;
```

3. **Using COLLATE clause in queries**:

```sql
-- Demonstrate different sorting with COLLATE
CREATE TABLE InternationalNames (
    ID INT IDENTITY(1,1),
    Name NVARCHAR(50)
);

INSERT INTO InternationalNames VALUES 
(N'André'), (N'Andrei'), (N'Andreas'), (N'Østen'), (N'Ostergaard');

-- Default sorting
SELECT Name FROM InternationalNames ORDER BY Name;

-- Accent-insensitive sorting
SELECT Name FROM InternationalNames 
ORDER BY Name COLLATE SQL_Latin1_General_CP1_CI_AI;

-- Binary sorting
SELECT Name FROM InternationalNames 
ORDER BY Name COLLATE Latin1_General_BIN;
```

4. **Unicode handling for international character sets**:

```sql
-- Demonstrate Unicode support
CREATE TABLE UnicodeTest (
    ID INT IDENTITY(1,1),
    EnglishText VARCHAR(100),
    UnicodeText NVARCHAR(100)
);

-- Insert international characters
INSERT INTO UnicodeTest VALUES 
('Cannot store: Chinese characters', N'可以存储: 中文字符'),
('Cannot store: Russian text', N'Можно сохранить: русский текст'),
('Cannot store: Arabic text', N'يمكن تخزين: النص العربي');

-- Show the difference
SELECT EnglishText, UnicodeText FROM UnicodeTest;
```

**Questions Answers**:

1. **What is collation and why is it important**:
   - Collation defines rules for comparing and sorting character data
   - Controls case sensitivity, accent sensitivity, and cultural sorting rules
   - Affects WHERE clauses, JOINs, ORDER BY, and indexes
   - Critical for international applications and data consistency

2. **How to handle collation conflicts in JOINs**:
   - Use COLLATE clause to explicitly specify collation for comparison
   - Change one of the columns to match the other's collation
   - Use a database-level collation that both can use
   - Consider using COLLATE DATABASE_DEFAULT for consistency

3. **Performance implications of changing collation in queries**:
   - COLLATE clause can prevent index usage
   - May require data conversion at runtime
   - Can significantly slow down large queries
   - Better to set appropriate collations at design time

4. **How collation affects indexing**:
   - Indexes are created using the column's collation
   - Different collations may sort the same data differently
   - Case-sensitive collations create different index key distributions
   - Collation changes may require index rebuilding

## Exercise Set 3: Working with Date and Time Data (Lesson 3) - Answers

### Exercise 3.1: Date and Time Data Types - Answers

**Tasks Solutions**:

1. **Examples of all date and time data types**:

```sql
CREATE TABLE DateTimeExamples (
    ID INT IDENTITY(1,1),
    DateExample DATE,
    TimeExample TIME(3),
    DateTimeExample DATETIME,
    DateTime2Example DATETIME2(3),
    SmallDateTimeExample SMALLDATETIME,
    DateTimeOffsetExample DATETIMEOFFSET(3)
);

-- Insert current date/time in various formats
INSERT INTO DateTimeExamples VALUES (
    GETDATE(),                    -- DATE
    GETDATE(),                    -- TIME
    GETDATE(),                    -- DATETIME
    SYSDATETIME(),               -- DATETIME2
    GETDATE(),                    -- SMALLDATETIME
    SYSDATETIMEOFFSET()          -- DATETIMEOFFSET
);

-- Show the results
SELECT * FROM DateTimeExamples;
```

2. **Compare storage requirements and precision**:

```sql
-- Storage comparison
SELECT 
    'DATE' as DataType, 3 as StorageBytes, 'Day precision' as Precision
UNION ALL SELECT 'TIME', 3, 'Up to 100 nanoseconds'
UNION ALL SELECT 'DATETIME', 8, '3.33 milliseconds'
UNION ALL SELECT 'DATETIME2(3)', 7, '1 millisecond'
UNION ALL SELECT 'SMALLDATETIME', 4, '1 minute'
UNION ALL SELECT 'DATETIMEOFFSET(3)', 10, '1 millisecond + timezone';

-- Precision demonstration
DECLARE @PreciseTime DATETIME2(7) = SYSDATETIME();
SELECT 
    @PreciseTime as DateTime2_7,
    CAST(@PreciseTime AS DATETIME) as DateTime_Converted,
    CAST(@PreciseTime AS SMALLDATETIME) as SmallDateTime_Converted;
```

3. **Demonstrate valid ranges**:

```sql
-- Valid ranges for date/time types
SELECT 
    'DATE' as DataType, 
    '0001-01-01' as MinValue, 
    '9999-12-31' as MaxValue
UNION ALL
SELECT 'DATETIME', '1753-01-01 00:00:00.000', '9999-12-31 23:59:59.997'
UNION ALL
SELECT 'DATETIME2', '0001-01-01 00:00:00.0000000', '9999-12-31 23:59:59.9999999'
UNION ALL
SELECT 'SMALLDATETIME', '1900-01-01 00:00:00', '2079-06-06 23:59:00';

-- Test boundary conditions
INSERT INTO DateTimeExamples (DateExample, DateTimeExample) 
VALUES ('0001-01-01', '1753-01-01');
```

4. **Time zone handling with DATETIMEOFFSET**:

```sql
-- DATETIMEOFFSET examples
DECLARE @UTCTime DATETIMEOFFSET = '2023-12-25 12:00:00.000 +00:00';
DECLARE @EasternTime DATETIMEOFFSET = '2023-12-25 07:00:00.000 -05:00';
DECLARE @PacificTime DATETIMEOFFSET = '2023-12-25 04:00:00.000 -08:00';

SELECT 
    @UTCTime as UTC_Time,
    @EasternTime as Eastern_Time,
    @PacificTime as Pacific_Time,
    -- All represent the same moment in time
    CASE WHEN @UTCTime = @EasternTime THEN 'Same Time' ELSE 'Different Time' END as Comparison1,
    CASE WHEN @UTCTime = @PacificTime THEN 'Same Time' ELSE 'Different Time' END as Comparison2;
```

**Questions Answers**:

1. **When to choose DATETIME vs DATETIME2**:
   - **DATETIME2**: New applications, higher precision needed, wider date range
   - **DATETIME**: Legacy compatibility, existing applications
   - DATETIME2 is generally preferred for new development
   - DATETIME2 offers better precision and range

2. **Benefits of separate DATE and TIME types**:
   - **Storage efficiency**: Only store what you need
   - **Clarity**: Makes intent clear (date-only vs time-only)
   - **Performance**: Smaller data types can improve query performance
   - **Validation**: Prevents time components in date-only fields

3. **How DATETIMEOFFSET helps with global applications**:
   - Preserves original time zone information
   - Enables accurate time comparisons across time zones
   - Supports global user bases with different time zones
   - Prevents data loss during time zone conversions

4. **Performance implications of higher precision date types**:
   - Larger storage requirements
   - Potentially slower comparisons and sorting
   - More precise but may be overkill for many applications
   - Consider actual precision needs vs. performance

### Exercise 3.2: Date and Time Functions - Answers

**Tasks Solutions**:

1. **Date/time functions demonstration**:

```sql
-- Current date/time functions
SELECT 
    GETDATE() as GetDate,
    GETUTCDATE() as GetUTCDate,
    SYSDATETIME() as SysDateTime,
    SYSDATETIMEOFFSET() as SysDateTimeOffset,
    SYSUTCDATETIME() as SysUTCDateTime;

-- Date part extraction
DECLARE @TestDate DATETIME = '2023-12-25 14:30:45.123';
SELECT 
    @TestDate as OriginalDate,
    YEAR(@TestDate) as Year_Part,
    MONTH(@TestDate) as Month_Part,
    DAY(@TestDate) as Day_Part,
    DATEPART(HOUR, @TestDate) as Hour_Part,
    DATEPART(MINUTE, @TestDate) as Minute_Part,
    DATEPART(SECOND, @TestDate) as Second_Part,
    DATENAME(MONTH, @TestDate) as Month_Name,
    DATENAME(WEEKDAY, @TestDate) as Weekday_Name;
```

2. **Common date calculations**:

```sql
-- Age calculation
DECLARE @BirthDate DATE = '1990-05-15';
DECLARE @CurrentDate DATE = GETDATE();

SELECT 
    @BirthDate as BirthDate,
    @CurrentDate as CurrentDate,
    DATEDIFF(YEAR, @BirthDate, @CurrentDate) as Age_Simple,
    -- More accurate age calculation
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, @BirthDate, @CurrentDate), @BirthDate) > @CurrentDate
        THEN DATEDIFF(YEAR, @BirthDate, @CurrentDate) - 1
        ELSE DATEDIFF(YEAR, @BirthDate, @CurrentDate)
    END as Age_Accurate;

-- Business days between dates
DECLARE @StartDate DATE = '2023-12-01';
DECLARE @EndDate DATE = '2023-12-31';

WITH DateSeries AS (
    SELECT @StartDate as DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSeries
    WHERE DateValue < @EndDate
)
SELECT COUNT(*) as BusinessDays
FROM DateSeries
WHERE DATEPART(WEEKDAY, DateValue) BETWEEN 2 AND 6  -- Monday to Friday
OPTION (MAXRECURSION 0);

-- End of month/quarter/year
SELECT 
    EOMONTH(GETDATE()) as EndOfCurrentMonth,
    EOMONTH(GETDATE(), -1) as EndOfLastMonth,
    EOMONTH(GETDATE(), 1) as EndOfNextMonth,
    -- End of quarter
    EOMONTH(DATEADD(MONTH, (3 - (MONTH(GETDATE()) - 1) % 3) - 1, GETDATE())) as EndOfQuarter,
    -- End of year
    DATEFROMPARTS(YEAR(GETDATE()), 12, 31) as EndOfYear;
```

3. **Working with different date formats**:

```sql
-- Date format conversions
DECLARE @TestDate DATETIME = GETDATE();

SELECT 
    @TestDate as OriginalDate,
    CONVERT(VARCHAR(20), @TestDate, 101) as MM_DD_YYYY,
    CONVERT(VARCHAR(20), @TestDate, 103) as DD_MM_YYYY,
    CONVERT(VARCHAR(20), @TestDate, 120) as YYYY_MM_DD_24H,
    FORMAT(@TestDate, 'MMMM dd, yyyy') as Formatted_Long,
    FORMAT(@TestDate, 'yyyy-MM-dd HH:mm:ss') as ISO_Format;

-- Parsing different date strings
SELECT 
    CAST('2023-12-25' AS DATE) as ISO_Date,
    CAST('12/25/2023' AS DATE) as US_Date,
    CAST('25/12/2023' AS DATE) as UK_Date;  -- May fail depending on DATEFORMAT setting
```

4. **Date-based reporting**:

```sql
-- Year-over-year comparison
WITH SalesByYear AS (
    SELECT 
        YEAR(o.OrderDate) as SalesYear,
        MONTH(o.OrderDate) as SalesMonth,
        SUM(od.BaseSalary * od.Quantity * (1 - od.Discount)) as MonthlySales
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
)
SELECT 
    s1.SalesYear,
    s1.SalesMonth,
    s1.MonthlySales as CurrentYear,
    s2.MonthlySales as PreviousYear,
    s1.MonthlySales - ISNULL(s2.MonthlySales, 0) as YearOverYearChange
FROM SalesByYear s1
LEFT JOIN SalesByYear s2 ON s1.SalesMonth = s2.SalesMonth 
                        AND s1.SalesYear = s2.SalesYear + 1
ORDER BY s1.SalesYear, s1.SalesMonth;
```

**Questions Answers**:

1. **Difference between GETDATE() and SYSDATETIME()**:
   - **GETDATE()**: Returns DATETIME, precision to 3.33 milliseconds
   - **SYSDATETIME()**: Returns DATETIME2(7), precision to 100 nanoseconds
   - SYSDATETIME() provides much higher precision
   - Use SYSDATETIME() for high-precision timing requirements

2. **Ensuring accurate date calculations across time zones**:
   - Use DATETIMEOFFSET for time zone-aware data
   - Store all times in UTC when possible
   - Convert to local time zones only for display
   - Be aware of daylight saving time transitions

3. **Performance implications of date functions in WHERE clauses**:
   - Date functions on columns prevent index usage
   - Use date ranges instead of functions when possible
   - Consider computed columns for frequently used date calculations
   - Index on computed date expressions when appropriate

4. **Handling leap years in date calculations**:
   - DATEDIFF and DATEADD handle leap years automatically
   - Be careful with February 29th in date arithmetic
   - Test date calculations around leap year boundaries
   - Consider business rules for leap year handling

### Exercise 3.3: Advanced Date and Time Scenarios - Answers

**Tasks Solutions**:

1. **Create a comprehensive calendar table**:

```sql
-- Create calendar table
CREATE TABLE CalendarTable (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(10) NOT NULL,
    DayOfMonth INT NOT NULL,
    DayOfYear INT NOT NULL,
    WeekOfYear INT NOT NULL,
    MonthName VARCHAR(10) NOT NULL,
    MonthOfYear INT NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL,
    IsWeekend BIT NOT NULL,
    IsBusinessDay BIT NOT NULL,
    IsHoliday BIT NOT NULL,
    HolidayName VARCHAR(50) NULL,
    FiscalYear INT NOT NULL,
    FiscalQuarter INT NOT NULL
);

-- Populate calendar table (10 years)
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2029-12-31';

WITH DateSeries AS (
    SELECT @StartDate as CalDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalDate)
    FROM DateSeries
    WHERE CalDate < @EndDate
)
INSERT INTO CalendarTable (
    DateKey, FullDate, DayOfWeek, DayName, DayOfMonth, DayOfYear,
    WeekOfYear, MonthName, MonthOfYear, Quarter, Year, IsWeekend,
    IsBusinessDay, IsHoliday, FiscalYear, FiscalQuarter
)
SELECT 
    CAST(FORMAT(CalDate, 'yyyyMMdd') AS INT) as DateKey,
    CalDate,
    DATEPART(WEEKDAY, CalDate),
    DATENAME(WEEKDAY, CalDate),
    DAY(CalDate),
    DATEPART(DAYOFYEAR, CalDate),
    DATEPART(WEEK, CalDate),
    DATENAME(MONTH, CalDate),
    MONTH(CalDate),
    DATEPART(QUARTER, CalDate),
    YEAR(CalDate),
    CASE WHEN DATEPART(WEEKDAY, CalDate) IN (1, 7) THEN 1 ELSE 0 END,
    CASE WHEN DATEPART(WEEKDAY, CalDate) BETWEEN 2 AND 6 THEN 1 ELSE 0 END,
    0,  -- Default no holidays, would need separate logic
    -- Fiscal year starts July 1st
    CASE WHEN MONTH(CalDate) >= 7 THEN YEAR(CalDate) + 1 ELSE YEAR(CalDate) END,
    CASE 
        WHEN MONTH(CalDate) IN (7, 8, 9) THEN 1
        WHEN MONTH(CalDate) IN (10, 11, 12) THEN 2
        WHEN MONTH(CalDate) IN (1, 2, 3) THEN 3
        ELSE 4
    END
FROM DateSeries
OPTION (MAXRECURSION 0);
```

2. **Complex date scenarios**:

```sql
-- Last business day of each month
WITH MonthEnds AS (
    SELECT DISTINCT
        YEAR(FullDate) as Year,
        MonthOfYear,
        EOMONTH(FullDate) as LastDayOfMonth
    FROM CalendarTable
    WHERE Year = 2023
)
SELECT 
    Year,
    MonthOfYear,
    LastDayOfMonth,
    -- Find last business day
    (SELECT MAX(FullDate) 
     FROM CalendarTable c 
     WHERE c.FullDate <= m.LastDayOfMonth 
       AND c.IsBusinessDay = 1
       AND c.MonthOfYear = m.MonthOfYear
       AND c.Year = m.Year) as LastBusinessDay
FROM MonthEnds m
ORDER BY Year, MonthOfYear;

-- Elapsed time excluding weekends
CREATE FUNCTION dbo.CalculateBusinessDays(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @BusinessDays INT;
    
    SELECT @BusinessDays = COUNT(*)
    FROM CalendarTable
    WHERE FullDate >= @StartDate 
      AND FullDate <= @EndDate
      AND IsBusinessDay = 1;
    
    RETURN @BusinessDays;
END;

-- Test the function
SELECT dbo.CalculateBusinessDays('2023-12-01', '2023-12-31') as BusinessDaysInDecember;
```

3. **Date validation and error handling**:

```sql
-- Safe date parsing function
CREATE FUNCTION dbo.SafeDateParse(@DateString VARCHAR(50))
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE = NULL;
    
    -- Try different date formats
    IF ISDATE(@DateString) = 1
        SET @Result = TRY_CAST(@DateString AS DATE);
    
    RETURN @Result;
END;

-- Date range validation
CREATE FUNCTION dbo.ValidateDateRange(@StartDate DATE, @EndDate DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;
    
    IF @StartDate IS NOT NULL 
       AND @EndDate IS NOT NULL 
       AND @StartDate <= @EndDate
       AND @StartDate >= '1900-01-01'
       AND @EndDate <= '2100-12-31'
        SET @IsValid = 1;
    
    RETURN @IsValid;
END;

-- Test validation
SELECT 
    dbo.SafeDateParse('2023-12-25') as ValidDate,
    dbo.SafeDateParse('invalid date') as InvalidDate,
    dbo.ValidateDateRange('2023-01-01', '2023-12-31') as ValidRange,
    dbo.ValidateDateRange('2023-12-31', '2023-01-01') as InvalidRange;
```

4. **Efficient date-based queries**:

```sql
-- Optimized date range query
-- Bad: WHERE YEAR(OrderDate) = 2023
-- Good: Use date ranges
SELECT COUNT(*)
FROM Orders
WHERE OrderDate >= '2023-01-01' AND OrderDate < '2024-01-01';

-- Index suggestion for date queries
CREATE INDEX IX_Orders_OrderDate_Includes 
ON Orders (OrderDate) 
INCLUDE (CustomerID, EmployeeID, OrderID);

-- Using calendar table for reporting
SELECT 
    c.Year,
    c.MonthName,
    COUNT(o.OrderID) as OrderCount,
    SUM(od.BaseSalary * od.Quantity * (1 - od.Discount)) as TotalSales
FROM CalendarTable c
LEFT JOIN Orders o ON c.FullDate = CAST(o.OrderDate AS DATE)
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.Year = 2023 AND c.IsBusinessDay = 1
GROUP BY c.Year, c.MonthOfYear, c.MonthName
ORDER BY c.MonthOfYear;
```

**Questions Answers**:

1. **Why calendar tables are useful for reporting**:
   - Pre-calculated date attributes improve query performance
   - Consistent date dimensions across all reports
   - Easy handling of business rules (holidays, fiscal years)
   - Simplifies complex date calculations and groupings

2. **How to optimize queries with date ranges**:
   - Use SARGable predicates (avoid functions on columns)
   - Create indexes on date columns
   - Use covering indexes for frequently accessed columns
   - Consider partitioning for very large date ranges

3. **Best practices for storing historical time zone data**:
   - Use DATETIMEOFFSET for time zone-aware data
   - Store original time zone information separately if needed
   - Consider UTC storage with separate local time conversion
   - Document time zone handling policies clearly

4. **Handling date arithmetic across time zones**:
   - Perform calculations in UTC when possible
   - Be aware of daylight saving time transitions
   - Use AT TIME ZONE clause for conversions
   - Test edge cases around time zone boundaries

## Review Questions - Answers

### Multiple Choice Answers

1. **c) DECIMAL(19,4)** - DECIMAL provides exact precision for currency values, avoiding floating-point rounding errors

2. **c) Up to 100 bytes plus 2 bytes overhead** - NVARCHAR(50) can store up to 50 Unicode characters (100 bytes) plus 2 bytes for length overhead

3. **b) DATETIME2(7)** - DATETIME2(7) has the highest precision at 100 nanoseconds

4. **b) An error occurs** - By default, SQL Server will raise an error when data exceeds the column's defined length

5. **b) LEN()** - LEN() returns the number of characters in a string, excluding trailing spaces

### Short Answer Answers

1. **Difference between CHAR and VARCHAR and when to use each**:
   - **CHAR**: Fixed-length, always uses full declared size, slight performance advantage
   - **VARCHAR**: Variable-length, only uses space needed plus overhead
   - **Use CHAR**: When all values are the same length (codes, flags)
   - **Use VARCHAR**: When lengths vary significantly to save storage space

2. **Advantages and disadvantages of Unicode data types**:
   - **Advantages**: Support for international characters, consistent across platforms
   - **Disadvantages**: Double storage requirements, potential performance impact
   - **Use when**: Supporting multiple languages or international applications
   - **Avoid when**: Storage space is critical and only ASCII characters are needed

3. **Choosing between DATETIME and DATETIME2 for new applications**:
   - **DATETIME2**: Preferred for new applications, higher precision, wider range
   - **DATETIME**: Only for legacy compatibility
   - **Consider**: Precision requirements, date range needs, storage constraints
   - **Default choice**: DATETIME2 unless specific legacy requirements exist

4. **Factors influencing DECIMAL precision choice**:
   - **Business requirements**: How many digits before/after decimal point
   - **Storage considerations**: Higher precision uses more space
   - **Performance**: Lower precision can be faster for calculations
   - **Future growth**: Plan for potential increases in value ranges

5. **Data type precedence concept and example**:
   - **Precedence**: Rules determining which data type is used in mixed expressions
   - **Higher precedence types**: Take priority in implicit conversions
   - **Example**: INT + DECIMAL results in DECIMAL (DECIMAL has higher precedence)
   - **Important for**: Avoiding unexpected conversion errors and results

### Practical Tasks - Sample Solutions

1. **Script to analyze existing database data type usage**:

```sql
-- Analyze data type usage and identify optimization opportunities
WITH DataTypeAnalysis AS (
    SELECT 
        t.TABLE_SCHEMA,
        t.TABLE_NAME,
        c.COLUMN_NAME,
        c.DATA_TYPE,
        c.CHARACTER_MAXIMUM_LENGTH,
        c.NUMERIC_PRECISION,
        c.NUMERIC_SCALE,
        c.IS_NULLABLE,
        -- Identify potential issues
        CASE 
            WHEN c.DATA_TYPE IN ('varchar', 'nvarchar') AND c.CHARACTER_MAXIMUM_LENGTH = -1 
            THEN 'Consider if MAX is necessary'
            WHEN c.DATA_TYPE = 'nvarchar' AND c.CHARACTER_MAXIMUM_LENGTH > 50 
            THEN 'Check if Unicode is required'
            WHEN c.DATA_TYPE = 'datetime' 
            THEN 'Consider upgrading to DATETIME2'
            WHEN c.DATA_TYPE = 'text' OR c.DATA_TYPE = 'ntext' 
            THEN 'Deprecated: Use VARCHAR(MAX) or NVARCHAR(MAX)'
            ELSE 'OK'
        END as Recommendation
    FROM INFORMATION_SCHEMA.TABLES t
    JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME 
                                     AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
    WHERE t.TABLE_TYPE = 'BASE TABLE'
)
SELECT * FROM DataTypeAnalysis
WHERE Recommendation != 'OK'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;
```

2. **Function to safely convert strings to dates with error handling**:

```sql
CREATE FUNCTION dbo.SafeStringToDate(@InputString VARCHAR(50), @DefaultValue DATE = NULL)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE = @DefaultValue;
    
    -- Try TRY_CAST first (SQL Server 2012+)
    SET @Result = TRY_CAST(@InputString AS DATE);
    
    -- If that fails and we don't have a result, try different formats
    IF @Result IS NULL AND @InputString IS NOT NULL
    BEGIN
        -- Try various common formats
        SET @Result = TRY_CAST(@InputString AS DATE);
        
        -- Could add more format-specific parsing logic here
        IF @Result IS NULL
        BEGIN
            -- Try parsing common formats manually
            IF @InputString LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'
                SET @Result = TRY_CAST(@InputString AS DATE);
        END
    END
    
    RETURN @Result;
END;

-- Test the function
SELECT 
    dbo.SafeStringToDate('2023-12-25', '1900-01-01') as Test1,
    dbo.SafeStringToDate('12/25/2023', '1900-01-01') as Test2,
    dbo.SafeStringToDate('invalid', '1900-01-01') as Test3,
    dbo.SafeStringToDate(NULL, '1900-01-01') as Test4;
```

3. **Table structure for storing product reviews supporting multiple languages**:

```sql
CREATE TABLE ProductReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    ReviewDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    Rating TINYINT CHECK (Rating BETWEEN 1 AND 5),
    LanguageCode CHAR(2) NOT NULL,  -- ISO 639-1 codes
    ReviewTitle NVARCHAR(200) NOT NULL,
    ReviewText NVARCHAR(MAX) NOT NULL,
    IsVerifiedPurchase BIT NOT NULL DEFAULT 0,
    HelpfulVotes INT NOT NULL DEFAULT 0,
    TotalVotes INT NOT NULL DEFAULT 0,
    ModeratorApproved BIT NOT NULL DEFAULT 0,
    CreatedBy NVARCHAR(100) NOT NULL,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL
);

-- Supporting tables
CREATE TABLE SupportedLanguages (
    LanguageCode CHAR(2) PRIMARY KEY,
    LanguageName NVARCHAR(50) NOT NULL,
    DisplayName NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- Insert sample languages
INSERT INTO SupportedLanguages VALUES 
('en', 'English', 'English', 1),
('es', 'Spanish', 'Español', 1),
('fr', 'French', 'Français', 1),
('de', 'German', 'Deutsch', 1),
('zh', 'Chinese', '中文', 1);

-- Foreign key constraint
ALTER TABLE ProductReviews 
ADD CONSTRAINT FK_ProductReviews_Language 
FOREIGN KEY (LanguageCode) REFERENCES SupportedLanguages(LanguageCode);
```

4. **Queries demonstrating performance difference between appropriate and inappropriate data type choices**:

```sql
-- Create test tables
CREATE TABLE BadDataTypes (
    ID NVARCHAR(100),
    Amount NVARCHAR(50),
    TransactionDate NVARCHAR(30),
    IsActive NVARCHAR(10)
);

CREATE TABLE GoodDataTypes (
    ID INT IDENTITY(1,1),
    Amount DECIMAL(19,4),
    TransactionDate DATETIME2(3),
    IsActive BIT
);

-- Insert test data
DECLARE @Counter INT = 1;
WHILE @Counter <= 100000
BEGIN
    INSERT INTO BadDataTypes VALUES 
    (CAST(@Counter AS NVARCHAR(100)), 
     CAST(RAND() * 1000 AS NVARCHAR(50)), 
     CONVERT(NVARCHAR(30), DATEADD(DAY, -RAND() * 365, GETDATE()), 120),
     CASE WHEN RAND() > 0.5 THEN 'True' ELSE 'False' END);
    
    INSERT INTO GoodDataTypes VALUES 
    (RAND() * 1000, 
     DATEADD(DAY, -RAND() * 365, GETDATE()),
     CASE WHEN RAND() > 0.5 THEN 1 ELSE 0 END);
    
    SET @Counter = @Counter + 1;
END;

-- Performance comparison queries
-- Bad query (requires conversion)
SET STATISTICS IO ON;
SELECT COUNT(*) FROM BadDataTypes 
WHERE CAST(Amount AS DECIMAL(19,4)) > 500;

-- Good query (direct comparison)
SELECT COUNT(*) FROM GoodDataTypes 
WHERE Amount > 500;
SET STATISTICS IO OFF;
```

5. **Comprehensive data validation routine for user registration form**:

```sql
CREATE FUNCTION dbo.ValidateUserRegistration(
    @WorkEmail NVARCHAR(255),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @PhoneNumber NVARCHAR(20),
    @PostalCode NVARCHAR(10)
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        -- WorkEmail validation
        CASE 
            WHEN @WorkEmail IS NULL OR @WorkEmail = '' THEN 'WorkEmail is required'
            WHEN @WorkEmail NOT LIKE '%_@_%._%' THEN 'Invalid email format'
            WHEN @WorkEmail LIKE '%@%@%' THEN 'Invalid email format'
            WHEN LEN(@WorkEmail) > 255 THEN 'WorkEmail too long'
            ELSE 'Valid'
        END as EmailValidation,
        
        -- Name validation
        CASE 
            WHEN @FirstName IS NULL OR LTRIM(RTRIM(@FirstName)) = '' THEN 'First name required'
            WHEN LEN(@FirstName) > 50 THEN 'First name too long'
            WHEN @FirstName LIKE '%[0-9]%' THEN 'First name cannot contain numbers'
            ELSE 'Valid'
        END as FirstNameValidation,
        
        CASE 
            WHEN @LastName IS NULL OR LTRIM(RTRIM(@LastName)) = '' THEN 'Last name required'
            WHEN LEN(@LastName) > 50 THEN 'Last name too long'
            WHEN @LastName LIKE '%[0-9]%' THEN 'Last name cannot contain numbers'
            ELSE 'Valid'
        END as LastNameValidation,
        
        -- Date of birth validation
        CASE 
            WHEN @DateOfBirth IS NULL THEN 'Date of birth required'
            WHEN @DateOfBirth > GETDATE() THEN 'Date of birth cannot be in future'
            WHEN DATEDIFF(YEAR, @DateOfBirth, GETDATE()) < 13 THEN 'Must be at least 13 years old'
            WHEN DATEDIFF(YEAR, @DateOfBirth, GETDATE()) > 120 THEN 'Invalid date of birth'
            ELSE 'Valid'
        END as DateOfBirthValidation,
        
        -- Phone validation
        CASE 
            WHEN @PhoneNumber IS NULL OR @PhoneNumber = '' THEN 'Phone number required'
            WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(@PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', '')) < 10 
            THEN 'Phone number too short'
            WHEN @PhoneNumber NOT LIKE '%[0-9]%' THEN 'Phone number must contain digits'
            ELSE 'Valid'
        END as PhoneValidation,
        
        -- Postal code validation (basic)
        CASE 
            WHEN @PostalCode IS NULL OR @PostalCode = '' THEN 'Postal code required'
            WHEN LEN(@PostalCode) < 5 THEN 'Postal code too short'
            WHEN LEN(@PostalCode) > 10 THEN 'Postal code too long'
            ELSE 'Valid'
        END as PostalCodeValidation
);

-- Test the validation function
SELECT * FROM dbo.ValidateUserRegistration(
    'test@example.com',
    'John',
    'Smith',
    '1990-05-15',
    '(555) 123-4567',
    '12345'
);
```