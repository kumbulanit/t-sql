# Lesson 2: Working with Character Data

## Overview
Character data types are among the most commonly used data types in SQL Server. Understanding how to work effectively with character data is crucial for database design, data manipulation, and application development. This lesson covers all aspects of character data in SQL Server 2016, including data types, encoding, collations, and best practices.

## Character Data Type Fundamentals

### Character Data Type Categories
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CHARACTER DATA TYPE LANDSCAPE                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────┐        ┌─────────────────────┐                     │
│  │    NON-UNICODE      │        │      UNICODE        │                     │
│  │   (Single Byte)     │        │   (Double Byte)     │                     │
│  │                     │        │                     │                     │
│  │  CHAR(n)            │        │  NCHAR(n)           │                     │
│  │  • Fixed length     │        │  • Fixed length     │                     │
│  │  • 1-8000 bytes     │        │  • 1-4000 chars     │                     │
│  │  • Space padded     │        │  • Space padded     │                     │
│  │                     │        │                     │                     │
│  │  VARCHAR(n)         │        │  NVARCHAR(n)        │                     │
│  │  • Variable length  │        │  • Variable length  │                     │
│  │  • 1-8000 bytes     │        │  • 1-4000 chars     │                     │
│  │  • No padding       │        │  • No padding       │                     │
│  │                     │        │                     │                     │
│  │  VARCHAR(MAX)       │        │  NVARCHAR(MAX)      │                     │
│  │  • Variable length  │        │  • Variable length  │                     │
│  │  • Up to 2GB        │        │  • Up to 1GB        │                     │
│  │  • LOB storage      │        │  • LOB storage      │                     │
│  │                     │        │                     │                     │
│  │  TEXT (deprecated)  │        │  NTEXT (deprecated) │                     │
│  │  • Use VARCHAR(MAX) │        │  • Use NVARCHAR(MAX)│                     │
│  └─────────────────────┘        └─────────────────────┘                     │
│                                                                             │
│  Storage Comparison:                                                        │
│  'Hello' stored as:                                                         │
│  CHAR(10):    [H][e][l][l][o][ ][ ][ ][ ][ ]     = 10 bytes                │
│  VARCHAR(10): [H][e][l][l][o] + 2-byte length    = 7 bytes                 │
│  NCHAR(10):   [H][e][l][l][o][ ][ ][ ][ ][ ]     = 20 bytes (2 per char)  │
│  NVARCHAR(10):[H][e][l][l][o] + 2-byte length    = 12 bytes                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Character Encoding and Unicode
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CHARACTER ENCODING GUIDE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ASCII/ANSI (Non-Unicode):                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ • 1 byte per character                                                  │
│  │ • Limited to 256 characters (code page dependent)                      │
│  │ • English and limited international support                            │
│  │ • Uses: VARCHAR, CHAR, TEXT                                            │
│  │                                                                         │
│  │ Examples:                                                               │
│  │ 'A' = 65 (1 byte)                                                      │
│  │ 'Hello' = [72][101][108][108][111] (5 bytes)                           │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Unicode (UTF-16):                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ • 2 bytes per character (basic multilingual plane)                     │
│  │ • Supports all world languages                                         │
│  │ • 65,536+ characters available                                         │
│  │ • Uses: NVARCHAR, NCHAR, NTEXT                                         │
│  │                                                                         │
│  │ Examples:                                                               │
│  │ 'A' = 65 (2 bytes: [65][0])                                           │
│  │ 'Hello' = [72][0][101][0][108][0][108][0][111][0] (10 bytes)           │
│  │ '你好' = [20320][22909] (4 bytes total)                                │
│  │ 'مرحبا' = Arabic characters (10 bytes total)                           │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  When to Use Unicode:                                                       │
│  ✓ International applications                                               │
│  ✓ Multi-language support required                                          │
│  ✓ Future-proofing                                                          │
│  ✗ English-only, storage-sensitive applications                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Working with Character Data Types

### Basic Character Data Operations
```sql
-- Creating tables with different character types
CREATE TABLE CharacterDataExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Fixed-length types
    CountryCode CHAR(2),                    -- Always 2 bytes: 'US', 'CA'
    StateCode CHAR(3),                      -- Always 3 bytes: 'WA ', 'CA '
    UnicodeCountryCode NCHAR(2),            -- Always 4 bytes: Unicode
    
    -- Variable-length types
    FirstName VARCHAR(50),                  -- 1-52 bytes (data + 2 overhead)
    LastName VARCHAR(50),                   -- English names
    InternationalName NVARCHAR(50),         -- 2-102 bytes, supports all languages
    
    -- Large text storage
    EnglishDescription VARCHAR(MAX),        -- Up to 2GB
    MultilingualDescription NVARCHAR(MAX), -- Up to 1GB, Unicode
    
    -- Demonstration columns
    FixedChar CHAR(10),                     -- Always 10 bytes
    VariableChar VARCHAR(10)                -- 2-12 bytes
);

-- Inserting sample data
INSERT INTO CharacterDataExamples (
    CountryCode, StateCode, UnicodeCountryCode,
    FirstName, LastName, InternationalName,
    EnglishDescription, MultilingualDescription,
    FixedChar, VariableChar
) VALUES 
    ('US', 'WA', N'US', 'John', 'Smith', N'John Smith', 
     'American software engineer', N'American software engineer',
     'Test', 'Test'),
    ('JP', 'TK', N'JP', 'Yuki', 'Tanaka', N'田中 雪', 
     'Japanese developer', N'日本のソフトウェア開発者',
     'Hello', 'Hello'),
    ('DE', 'BY', N'DE', 'Hans', 'Mueller', N'Hans Müller', 
     'German analyst', N'Deutscher Analytiker',
     'Data', 'Data');

-- Viewing the data
SELECT 
    CountryCode,
    StateCode,
    FirstName,
    LastName,
    InternationalName,
    MultilingualDescription
FROM CharacterDataExamples;
```

### String Length and Storage
```sql
-- Understanding string length vs storage
SELECT 
    FixedChar,
    VariableChar,
    -- Character length
    LEN(FixedChar) AS FixedCharLength,          -- Returns trimmed length
    LEN(VariableChar) AS VariableCharLength,    -- Returns actual length
    -- Storage size in bytes
    DATALENGTH(FixedChar) AS FixedCharBytes,    -- Always full allocation
    DATALENGTH(VariableChar) AS VariableCharBytes, -- Actual storage used
    -- Unicode comparison
    DATALENGTH(InternationalName) AS UnicodeBytes, -- 2 bytes per character
    LEN(InternationalName) AS UnicodeLength        -- Character count
FROM CharacterDataExamples;

-- Demonstrating padding behavior
DECLARE @FixedString CHAR(10) = 'Hello';
DECLARE @VariableString VARCHAR(10) = 'Hello';

SELECT 
    '[' + @FixedString + ']' AS FixedWithBrackets,      -- [Hello     ]
    '[' + @VariableString + ']' AS VariableWithBrackets, -- [Hello]
    LEN(@FixedString) AS FixedLength,                    -- 5 (trimmed)
    LEN(@VariableString) AS VariableLength,              -- 5
    DATALENGTH(@FixedString) AS FixedBytes,              -- 10
    DATALENGTH(@VariableString) AS VariableBytes;        -- 5
```

## String Manipulation Functions

### Core String Functions
```sql
-- Essential string manipulation functions
DECLARE @SampleText VARCHAR(100) = '  Hello World, Welcome to SQL Server!  ';
DECLARE @UnicodeText NVARCHAR(100) = N'Здравствуй мир, 欢迎来到 SQL Server!';

SELECT 
    -- Length and positioning
    LEN(@SampleText) AS TextLength,
    DATALENGTH(@SampleText) AS TextBytes,
    CHARINDEX('World', @SampleText) AS WorldPosition,
    PATINDEX('%W_rld%', @SampleText) AS PatternPosition,
    
    -- Extraction functions
    LEFT(@SampleText, 10) AS LeftPart,
    RIGHT(@SampleText, 10) AS RightPart,
    SUBSTRING(@SampleText, 8, 5) AS MiddlePart,
    
    -- Case conversion
    UPPER(@SampleText) AS UpperCase,
    LOWER(@SampleText) AS LowerCase,
    
    -- Trimming functions
    LTRIM(@SampleText) AS LeftTrimmed,
    RTRIM(@SampleText) AS RightTrimmed,
    LTRIM(RTRIM(@SampleText)) AS BothTrimmed,
    TRIM(@SampleText) AS TrimFunction,  -- SQL Server 2017+
    
    -- Replacement and modification
    REPLACE(@SampleText, 'World', 'Universe') AS Replaced,
    REVERSE(@SampleText) AS Reversed,
    
    -- String building
    REPLICATE('*', 5) AS Stars,
    SPACE(10) AS TenSpaces,
    
    -- Unicode handling
    @UnicodeText AS UnicodeOriginal,
    LEN(@UnicodeText) AS UnicodeLength,
    DATALENGTH(@UnicodeText) AS UnicodeBytes;
```

### Advanced String Functions (SQL Server 2016+)
```sql
-- Advanced string functions introduced in recent versions
DECLARE @TextList VARCHAR(200) = 'Apple,Banana,Cherry,Date,Elderberry';
DECLARE @JsonData NVARCHAR(MAX) = N'{"name": "John", "age": 30, "city": "Seattle"}';

SELECT 
    -- String aggregation (SQL Server 2017+)
    STRING_AGG(FirstName, ', ') AS NameList,
    
    -- String splitting (SQL Server 2016+)
    value AS SplitValue
FROM CharacterDataExamples
CROSS APPLY STRING_SPLIT(@TextList, ',')
WHERE FirstName IS NOT NULL;

-- CONCAT function (handles NULLs gracefully)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT_WS(' - ', CountryCode, StateCode, FirstName) AS FormattedInfo,
    
    -- FORMAT function for string formatting
    FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate,
    FORMAT(12345.67, 'N2') AS FormattedNumber,
    FORMAT(12345.67, 'C', 'en-US') AS FormattedCurrency
FROM CharacterDataExamples;

-- JSON functions (SQL Server 2016+)
SELECT 
    JSON_VALUE(@JsonData, '$.name') AS ExtractedName,
    JSON_VALUE(@JsonData, '$.age') AS ExtractedAge,
    JSON_QUERY(@JsonData, '$') AS EntireJson,
    ISJSON(@JsonData) AS IsValidJson;
```

### Pattern Matching and Search
```sql
-- LIKE operator patterns
SELECT 
    FirstName,
    LastName,
    InternationalName
FROM CharacterDataExamples
WHERE 
    -- Basic patterns
    FirstName LIKE 'J%'                    -- Starts with 'J'
    OR LastName LIKE '%er'                 -- Ends with 'er'
    OR InternationalName LIKE '%[äöüß]%'   -- Contains German characters
    OR FirstName LIKE '_ohn'               -- Second char starts 'ohn'
    OR LastName LIKE '[M-S]%';             -- Starts with M through S

-- Advanced pattern matching with character classes
SELECT FirstName, LastName
FROM CharacterDataExamples
WHERE 
    -- Character ranges and sets
    FirstName LIKE '[A-M]%'                -- Starts with A through M
    OR LastName LIKE '%[0-9]%'             -- Contains any digit
    OR FirstName LIKE '%[^aeiou]%'         -- Contains non-vowels
    OR LastName LIKE '%[a-z][A-Z]%';       -- Mixed case pattern

-- Using ESCAPE for special characters
DECLARE @SearchPattern VARCHAR(50) = '50% off';
SELECT @SearchPattern AS OriginalPattern,
       'Product 50% off sale' AS TestString,
       CASE 
           WHEN 'Product 50% off sale' LIKE '%' + @SearchPattern + '%' 
           THEN 'Found (but % is wildcard!)'
           ELSE 'Not found'
       END AS WrongSearch,
       CASE 
           WHEN 'Product 50% off sale' LIKE '%' + REPLACE(@SearchPattern, '%', '[%]') + '%'
           THEN 'Found correctly'
           ELSE 'Not found'
       END AS CorrectSearch;
```

## Collations and Sorting

### Understanding Collations
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              COLLATION CONCEPTS                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Collation Format: Language_Country_Charset_SortingRules                   │
│                                                                             │
│  Example: SQL_Latin1_General_CP1_CI_AS                                     │
│  ├─ SQL_Latin1_General: Character set (Western European)                   │
│  ├─ CP1: Code page 1252                                                     │
│  ├─ CI: Case Insensitive                                                    │
│  └─ AS: Accent Sensitive                                                    │
│                                                                             │
│  Common Collation Suffixes:                                                │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ CI = Case Insensitive     │ CS = Case Sensitive                        │
│  │ AI = Accent Insensitive   │ AS = Accent Sensitive                      │
│  │ KI = Kana Insensitive     │ KS = Kana Sensitive (Japanese)             │
│  │ WI = Width Insensitive    │ WS = Width Sensitive                       │
│  │ BIN = Binary sort         │ BIN2 = Binary code point sort             │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Impact on Comparisons:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Case Insensitive (CI): 'Apple' = 'APPLE' = 'apple'                    │
│  │ Case Sensitive (CS):   'Apple' ≠ 'APPLE' ≠ 'apple'                    │
│  │ Accent Insensitive:    'café' = 'cafe'                                 │
│  │ Accent Sensitive:      'café' ≠ 'cafe'                                 │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Working with Collations
```sql
-- Checking current collations
SELECT 
    SERVERPROPERTY('Collation') AS ServerCollation,
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS DatabaseCollation;

-- Column-specific collations
CREATE TABLE CollationExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Default collation (inherited from database)
    DefaultText VARCHAR(50),
    
    -- Case sensitive collation
    CaseSensitiveText VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS,
    
    -- Case insensitive collation
    CaseInsensitiveText VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
    
    -- Binary collation (fastest, byte-by-byte comparison)
    BinaryText VARCHAR(50) COLLATE SQL_Latin1_General_CP1_BIN2,
    
    -- Unicode collations
    UnicodeText NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
);

-- Insert test data
INSERT INTO CollationExamples (DefaultText, CaseSensitiveText, CaseInsensitiveText, BinaryText, UnicodeText)
VALUES 
    ('Apple', 'Apple', 'Apple', 'Apple', N'Apple'),
    ('APPLE', 'APPLE', 'APPLE', 'APPLE', N'APPLE'),
    ('apple', 'apple', 'apple', 'apple', N'apple'),
    ('Café', 'Café', 'Café', 'Café', N'Café'),
    ('CAFÉ', 'CAFÉ', 'CAFÉ', 'CAFÉ', N'CAFÉ');

-- Demonstrating collation effects
SELECT 
    DefaultText,
    CaseSensitiveText,
    CaseInsensitiveText,
    BinaryText
FROM CollationExamples
WHERE CaseSensitiveText = 'Apple';      -- Only exact case match

SELECT 
    DefaultText,
    CaseSensitiveText,
    CaseInsensitiveText,
    BinaryText
FROM CollationExamples
WHERE CaseInsensitiveText = 'Apple';    -- All case variations match

-- Overriding collation in queries
SELECT * FROM CollationExamples
WHERE DefaultText COLLATE SQL_Latin1_General_CP1_CS_AS = 'Apple';  -- Force case sensitive

-- Sorting with different collations
SELECT DefaultText
FROM CollationExamples
ORDER BY DefaultText;  -- Default sort

SELECT DefaultText
FROM CollationExamples
ORDER BY DefaultText COLLATE SQL_Latin1_General_CP1_BIN2;  -- Binary sort
```

## Performance Considerations

### Storage and Memory Optimization
```sql
-- Storage comparison demonstration
CREATE TABLE StorageComparison (
    ID INT IDENTITY(1,1),
    
    -- Fixed vs Variable length impact
    ProductCode_Fixed CHAR(10),        -- Always 10 bytes
    ProductCode_Variable VARCHAR(10),  -- 2-12 bytes
    
    -- Unicode vs Non-Unicode impact
    Description_ASCII VARCHAR(255),    -- 1 byte per character
    Description_Unicode NVARCHAR(255), -- 2 bytes per character
    
    -- Large object considerations
    SmallText VARCHAR(8000),           -- In-row storage
    LargeText VARCHAR(MAX),            -- LOB storage when > 8000 bytes
    UnicodeText NVARCHAR(MAX)          -- LOB storage when > 4000 characters
);

-- Performance testing setup
INSERT INTO StorageComparison (ProductCode_Fixed, ProductCode_Variable, Description_ASCII, Description_Unicode)
SELECT 
    'PROD' + CAST(n AS CHAR(6)) AS ProductCode_Fixed,
    'PROD' + CAST(n AS VARCHAR(6)) AS ProductCode_Variable,
    'Product description for item ' + CAST(n AS VARCHAR(10)) AS Description_ASCII,
    N'Product description for item ' + CAST(n AS NVARCHAR(10)) AS Description_Unicode
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects s1 CROSS JOIN sys.objects s2
) AS Numbers
WHERE n <= 10000;

-- Analyze storage usage
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    index_id,
    avg_record_size_in_bytes,
    page_count,
    avg_page_space_used_in_percent,
    record_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('StorageComparison'), NULL, NULL, 'DETAILED')
WHERE index_id IN (0, 1);  -- Heap or clustered index
```

### Indexing Character Data
```sql
-- Effective indexing strategies for character data
CREATE TABLE IndexingExample (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    WorkEmail VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Description NVARCHAR(MAX)
);

-- Efficient indexes for character data
-- 1. Covering index for name searches
CREATE INDEX IX_Name_Covering 
ON IndexingExample (LastName, FirstName) 
INCLUDE (WorkEmail, PhoneNumber);

-- 2. Index for email lookups (unique constraint)
CREATE UNIQUE INDEX IX_Email_Unique 
ON IndexingExample (WorkEmail);

-- 3. Prefix index for partial matching (if supported)
-- Note: SQL Server doesn't support prefix indexes like MySQL
-- Instead, consider computed columns for common prefixes
ALTER TABLE IndexingExample 
ADD LastNamePrefix AS LEFT(LastName, 3) PERSISTED;

CREATE INDEX IX_LastNamePrefix 
ON IndexingExample (LastNamePrefix);

-- 4. Full-text indexing for large text content
-- Enable full-text search on the database first
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;

CREATE FULLTEXT INDEX ON IndexingExample (Description)
KEY INDEX PK__IndexingExample__ID;

-- Demonstrating index usage
-- Good: Uses index efficiently
SELECT ID, FirstName, LastName, WorkEmail
FROM IndexingExample
WHERE LastName = 'Smith'
ORDER BY FirstName;

-- Less efficient: Leading wildcard prevents index use
SELECT ID, FirstName, LastName
FROM IndexingExample
WHERE LastName LIKE '%son';

-- Better: Use full-text search for complex text searches
SELECT ID, FirstName, LastName
FROM IndexingExample
WHERE CONTAINS(Description, 'manager OR supervisor');
```

## Data Validation and Constraints

### Character Data Validation
```sql
-- Comprehensive character data validation
CREATE TABLE ValidatedCharacterData (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- WorkEmail validation using CHECK constraint
    WorkEmail VARCHAR(255) NOT NULL,
    CONSTRAINT CK_Email_Format CHECK (
        WorkEmail LIKE '%_@__%.__%' AND
        WorkEmail NOT LIKE '%@%@%' AND
        LEN(WorkEmail) >= 5
    ),
    
    -- Phone number validation
    PhoneNumber VARCHAR(20),
    CONSTRAINT CK_Phone_Format CHECK (
        PhoneNumber IS NULL OR
        PhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' OR
        PhoneNumber LIKE '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
    ),
    
    -- Product code validation (specific format)
    ProductCode CHAR(8) NOT NULL,
    CONSTRAINT CK_ProductCode_Format CHECK (
        ProductCode LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][A-Z]'
    ),
    
    -- Description length validation
    Description NVARCHAR(500),
    CONSTRAINT CK_Description_Length CHECK (
        LEN(TRIM(Description)) >= 10 OR Description IS NULL
    ),
    
    -- Name validation (no numbers or special characters)
    FirstName VARCHAR(50) NOT NULL,
    CONSTRAINT CK_FirstName_Alpha CHECK (
        FirstName NOT LIKE '%[^A-Za-z ]%' AND
        LEN(TRIM(FirstName)) >= 2
    ),
    
    -- Case-sensitive unique constraint
    UserName VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_UserName_CaseSensitive UNIQUE (UserName) 
);

-- Testing validation constraints
-- These should succeed
INSERT INTO ValidatedCharacterData (WorkEmail, PhoneNumber, ProductCode, Description, FirstName, UserName)
VALUES 
    ('john.doe@company.com', '425-555-1234', 'AB123456C', 'High-quality product with excellent features', 'John', 'johndoe'),
    ('jane.smith@email.org', '(206) 555-9876', 'XY789012D', 'Premium service offering for enterprise clients', 'Jane', 'janesmith');

-- These should fail due to constraint violations
/*
-- Invalid email format
INSERT INTO ValidatedCharacterData (WorkEmail, ProductCode, FirstName, UserName)
VALUES ('invalid-email', 'AB123456C', 'John', 'test1');

-- Invalid phone format
INSERT INTO ValidatedCharacterData (WorkEmail, PhoneNumber, ProductCode, FirstName, UserName)
VALUES ('test@test.com', '1234567890', 'AB123456C', 'John', 'test2');

-- Invalid product code format
INSERT INTO ValidatedCharacterData (WorkEmail, ProductCode, FirstName, UserName)
VALUES ('test@test.com', 'invalid', 'John', 'test3');

-- Description too short
INSERT INTO ValidatedCharacterData (WorkEmail, ProductCode, Description, FirstName, UserName)
VALUES ('test@test.com', 'AB123456C', 'Too short', 'John', 'test4');

-- Invalid first name (contains numbers)
INSERT INTO ValidatedCharacterData (WorkEmail, ProductCode, FirstName, UserName)
VALUES ('test@test.com', 'AB123456C', 'John123', 'test5');
*/
```

## Working with Large Character Data

### VARCHAR(MAX) and NVARCHAR(MAX) Best Practices
```sql
-- Working with large character data efficiently
CREATE TABLE LargeTextData (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentTitle NVARCHAR(255) NOT NULL,
    DocumentContent NVARCHAR(MAX),
    DocumentSummary NVARCHAR(500),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    
    -- Computed column for content length
    ContentLength AS LEN(DocumentContent) PERSISTED,
    
    -- Computed column for word count approximation
    EstimatedWordCount AS (LEN(DocumentContent) - LEN(REPLACE(DocumentContent, ' ', '')) + 1) PERSISTED
);

-- Efficient operations with large text
DECLARE @LargeText NVARCHAR(MAX) = N'';
DECLARE @Counter INT = 1;

-- Build large text content efficiently
WHILE @Counter <= 1000
BEGIN
    SET @LargeText = @LargeText + 
        N'This is paragraph ' + CAST(@Counter AS NVARCHAR(10)) + 
        N'. It contains sample text for testing large character data operations. ' +
        N'We want to demonstrate how to work efficiently with VARCHAR(MAX) and NVARCHAR(MAX) columns. ';
    SET @Counter = @Counter + 1;
END;

INSERT INTO LargeTextData (DocumentTitle, DocumentContent, DocumentSummary)
VALUES 
    (N'Large Document Test', @LargeText, N'A test document with repeated paragraphs for testing large text operations.'),
    (N'Sample Report', N'Executive Summary: This report contains important findings...', N'Executive summary of business findings.');

-- Efficient searching in large text
-- 1. Use CHARINDEX for simple searches
SELECT ID, DocumentTitle, ContentLength
FROM LargeTextData
WHERE CHARINDEX('testing', DocumentContent) > 0;

-- 2. Use LIKE for pattern matching (less efficient for very large text)
SELECT ID, DocumentTitle
FROM LargeTextData
WHERE DocumentContent LIKE '%important%';

-- 3. Extract portions of large text efficiently
SELECT 
    ID,
    DocumentTitle,
    LEFT(DocumentContent, 100) + '...' AS ContentPreview,
    ContentLength,
    EstimatedWordCount
FROM LargeTextData
WHERE ContentLength > 1000;

-- 4. Full-text search for complex queries (most efficient for large text)
-- First, create full-text index
CREATE FULLTEXT INDEX ON LargeTextData (DocumentContent, DocumentTitle)
KEY INDEX PK__LargeTextData__ID;

-- Then use full-text search
SELECT ID, DocumentTitle, ContentLength
FROM LargeTextData
WHERE CONTAINS(DocumentContent, '"sample text" OR "important findings"');

-- Performance considerations for large text
-- Use SUBSTRING instead of RIGHT for extracting from middle/end
SELECT 
    ID,
    DocumentTitle,
    SUBSTRING(DocumentContent, LEN(DocumentContent) - 99, 100) AS LastHundredChars
FROM LargeTextData
WHERE ContentLength >= 100;

-- Avoid string concatenation in loops for large text
-- Use table variables or temp tables to build content instead
```

## String Aggregation and Advanced Operations

### String Aggregation Techniques
```sql
-- Modern string aggregation (SQL Server 2017+)
-- Sample data for aggregation examples
CREATE TABLE EmployeeDepartments (
    DepartmentID INT,
    d.DepartmentName VARCHAR(50),
    EmployeeName VARCHAR(100)
);

INSERT INTO EmployeeDepartments VALUES
(1, 'IT', 'John Smith'),
(1, 'IT', 'Jane Doe'),
(1, 'IT', 'Bob Johnson'),
(2, 'HR', 'Alice Brown'),
(2, 'HR', 'Charlie Wilson'),
(3, 'Finance', 'Diana Miller');

-- Using STRING_AGG (SQL Server 2017+)
SELECT d.DepartmentName,
    STRING_AGG(EmployeeName, ', ') AS EmployeeList,
    STRING_AGG(EmployeeName, ', ') WITHIN GROUP (ORDER BY EmployeeName) AS SortedEmployeeList,
    COUNT(*) AS EmployeeCount
FROM EmployeeDepartments
GROUP BY DepartmentIDID, d.DepartmentName;

-- Legacy string aggregation methods (for older versions)
-- Method 1: Using FOR XML PATH
SELECT d.DepartmentName,
    STUFF((
        SELECT ', ' + EmployeeName
        FROM EmployeeDepartments e2
        WHERE e2.DepartmentID = e1.DepartmentID
        ORDER BY EmployeeName
        FOR XML PATH('')
    ), 1, 2, '') AS EmployeeList
FROM EmployeeDepartments e1
GROUP BY DepartmentIDID, d.DepartmentName;

-- Method 2: Using recursive CTE (complex but works in all versions)
WITH EmployeeCTE AS (
    SELECT 
        DepartmentID,
        DepartmentName,
        EmployeeName,
        ROW_NUMBER() OVER (PARTITION BY DepartmentIDID ORDER BY EmployeeName) AS RowNum,
        COUNT(*) OVER (PARTITION BY DepartmentIDID) AS TotalCount
    FROM EmployeeDepartments
),
AggregationCTE AS (
    -- Anchor: First employee in each d.DepartmentName
    SELECT 
        DepartmentID,
        DepartmentName,
        EmployeeName AS EmployeeList,
        RowNum,
        TotalCount
    FROM EmployeeCTE
    WHERE RowNum = 1
    
    UNION ALL
    
    -- Recursive: Add remaining employees
    SELECT 
        e.DepartmentID,
        e.DepartmentName,
        a.EmployeeList + ', ' + e.EmployeeName,
        e.RowNum,
        e.TotalCount
    FROM EmployeeCTE e
    INNER JOIN AggregationCTE a ON e.DepartmentID = a.DepartmentID AND e.RowNum = a.RowNum + 1
)
SELECT d.DepartmentName,
    EmployeeList
FROM AggregationCTE
WHERE RowNum = TotalCount;
```

### Advanced Text Processing
```sql
-- Complex text processing scenarios
CREATE TABLE TextProcessingExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RawData NVARCHAR(MAX),
    ProcessedData NVARCHAR(MAX),
    Keywords NVARCHAR(255)
);

-- Sample data with various text processing needs
INSERT INTO TextProcessingExamples (RawData) VALUES
(N'  Product: Laptop Computer, Price: $1,299.99, Category: Electronics  '),
(N'Item: "Wireless Mouse" (Model: MX-2024) - $29.95 [In Stock]'),
(N'Book Title: "Advanced SQL Programming" Author: John Smith ISBN: 978-1234567890');

-- Comprehensive text processing
UPDATE TextProcessingExamples
SET 
    ProcessedData = 
        -- Clean and normalize text
        LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(RawData, '  ', ' '),  -- Remove double spaces
                    CHAR(13) + CHAR(10), ' '),    -- Replace line breaks
                CHAR(9), ' ')                     -- Replace tabs
        )),
    
    Keywords = 
        -- Extract keywords (simple approach)
        SUBSTRING(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(RawData, ',', ' '),
                        ':', ' '),
                    '(', ' '),
                ')', ' '),
            1, 255)
FROM TextProcessingExamples;

-- Advanced pattern extraction using multiple string functions
SELECT 
    ID,
    RawData,
    
    -- Extract price (look for $X.XX pattern)
    CASE 
        WHEN CHARINDEX('$', RawData) > 0 THEN
            SUBSTRING(RawData, 
                CHARINDEX('$', RawData), 
                PATINDEX('%[^0-9.,]%', 
                    SUBSTRING(RawData, CHARINDEX('$', RawData) + 1, LEN(RawData))
                ) + 1
            )
        ELSE NULL
    END AS ExtractedPrice,
    
    -- Extract quoted text
    CASE 
        WHEN CHARINDEX('"', RawData) > 0 AND 
             CHARINDEX('"', RawData, CHARINDEX('"', RawData) + 1) > 0 THEN
            SUBSTRING(RawData,
                CHARINDEX('"', RawData) + 1,
                CHARINDEX('"', RawData, CHARINDEX('"', RawData) + 1) - CHARINDEX('"', RawData) - 1
            )
        ELSE NULL
    END AS ExtractedQuotedText,
    
    -- Clean and format text
    UPPER(LEFT(LTRIM(RTRIM(RawData)), 1)) + 
    LOWER(SUBSTRING(LTRIM(RTRIM(RawData)), 2, LEN(LTRIM(RTRIM(RawData))))) AS ProperCase,
    
    -- Word count
    LEN(RawData) - LEN(REPLACE(RawData, ' ', '')) + 1 AS WordCount,
    
    -- Character analysis
    LEN(RawData) - LEN(REPLACE(UPPER(RawData), 'A', '')) AS CountOfA,
    LEN(RawData) - LEN(REPLACE(RawData, ' ', '')) AS NonSpaceChars
    
FROM TextProcessingExamples;
```

## Common Pitfalls and Best Practices

### Character Data Pitfalls
```sql
-- Common mistakes and their solutions

-- PITFALL 1: Concatenation with NULL values
DECLARE @FirstName VARCHAR(50) = 'John';
DECLARE @MiddleName VARCHAR(50) = NULL;  -- NULL value
DECLARE @LastName VARCHAR(50) = 'Smith';

SELECT 
    @FirstName + ' ' + @MiddleName + ' ' + @LastName AS WrongWay,  -- Returns NULL!
    CONCAT(@FirstName, ' ', @MiddleName, ' ', @LastName) AS RightWay1,  -- Handles NULLs
    @FirstName + ' ' + ISNULL(@MiddleName, '') + ' ' + @LastName AS RightWay2;  -- Explicit NULL handling

-- PITFALL 2: Trailing spaces in comparisons
CREATE TABLE SpaceIssues (
    FixedField CHAR(10),
    VariableField VARCHAR(10)
);

INSERT INTO SpaceIssues VALUES ('Test', 'Test');

-- These comparisons behave differently
SELECT 
    CASE WHEN FixedField = 'Test' THEN 'Equal' ELSE 'Not Equal' END AS FixedComparison,
    CASE WHEN VariableField = 'Test' THEN 'Equal' ELSE 'Not Equal' END AS VariableComparison,
    '[' + FixedField + ']' AS FixedWithBrackets,
    '[' + VariableField + ']' AS VariableWithBrackets
FROM SpaceIssues;

-- PITFALL 3: Case sensitivity assumptions
CREATE TABLE CaseIssues (
    CaseSensitiveCol VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS,
    CaseInsensitiveCol VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
);

INSERT INTO CaseIssues VALUES ('Test', 'Test'), ('TEST', 'TEST'), ('test', 'test');

-- Different results based on collation
SELECT COUNT(*) AS CaseSensitiveCount
FROM CaseIssues
WHERE CaseSensitiveCol = 'Test';  -- Only exact match

SELECT COUNT(*) AS CaseInsensitiveCount
FROM CaseIssues
WHERE CaseInsensitiveCol = 'Test';  -- All variations match

-- PITFALL 4: Unicode vs Non-Unicode mixing
DECLARE @UnicodeStr NVARCHAR(50) = N'Hello';
DECLARE @NonUnicodeStr VARCHAR(50) = 'World';

SELECT 
    @UnicodeStr + @NonUnicodeStr AS ConcatenationResult,  -- Works, but conversion occurs
    DATALENGTH(@UnicodeStr) AS UnicodeBytes,              -- 10 bytes (5 chars * 2)
    DATALENGTH(@NonUnicodeStr) AS NonUnicodeBytes,        -- 5 bytes
    DATALENGTH(@UnicodeStr + @NonUnicodeStr) AS ResultBytes; -- 20 bytes (converted to Unicode)

-- PITFALL 5: Inefficient string building
-- WRONG: Building large strings in loops
/*
DECLARE @LargeString VARCHAR(MAX) = '';
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    SET @LargeString = @LargeString + 'Item ' + CAST(@i AS VARCHAR(10)) + '; ';
    SET @i = @i + 1;
END;
*/

-- RIGHT: Use table-based approach for large string building
WITH Numbers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects s1 CROSS JOIN sys.objects s2
)
SELECT STRING_AGG('Item ' + CAST(n AS VARCHAR(10)), '; ') AS EfficientLargeString
FROM Numbers
WHERE n <= 10000;

-- CLEANUP
DROP TABLE IF EXISTS SpaceIssues;
DROP TABLE IF EXISTS CaseIssues;
```

## Summary

### Key Takeaways for Character Data

1. **Choose the Right Data Type**
   - Use VARCHAR for variable-length English text
   - Use NVARCHAR for international/Unicode text
   - Use CHAR only for fixed-length codes
   - Avoid deprecated TEXT/NTEXT types

2. **Understand Storage Implications**
   - CHAR pads with spaces, VARCHAR doesn't
   - Unicode types use 2 bytes per character
   - VARCHAR(MAX)/NVARCHAR(MAX) for large content

3. **Consider Collation Impact**
   - Affects sorting, comparison, and indexing
   - Choose appropriate case/accent sensitivity
   - Use binary collations for performance when appropriate

4. **Performance Best Practices**
   - Index character columns appropriately
   - Use covering indexes for frequent queries
   - Consider full-text search for large text content
   - Avoid leading wildcards in LIKE patterns

5. **Handle NULLs Properly**
   - Use CONCAT or ISNULL for concatenation
   - Be explicit about NULL handling in constraints
   - Consider default values where appropriate

6. **Validation and Constraints**
   - Use CHECK constraints for format validation
   - Implement proper email/phone number patterns
   - Validate data length and content appropriately

7. **Modern SQL Server Features**
   - Use STRING_AGG for string aggregation (2017+)
   - Leverage JSON functions for structured text (2016+)
   - Consider CONCAT_WS for conditional concatenation

Understanding character data types and their proper usage is crucial for building efficient, scalable, and maintainable database applications. Choose data types based on your specific requirements, considering storage, performance, and internationalization needs.
