# Module 7: Using Functions - Enhanced Theory Presentation

## Slide 1: Module Overview
**Mastering SQL Server Functions: Built-in Functions and Custom Logic**

### Learning Objectives
- **Function Categories**: Complete understanding of scalar, aggregate, table-valued, and system functions
- **String Manipulation**: Advanced string processing, pattern matching, and text transformation
- **Date/Time Functions**: Comprehensive date arithmetic, formatting, and business date calculations
- **Mathematical Functions**: Numeric operations, statistical functions, and scientific calculations
- **Conversion Functions**: Safe type conversions, formatting, and data transformation
- **Window Functions**: Advanced analytics, ranking, and statistical analysis
- **User-Defined Functions**: Creating custom reusable logic and performance considerations

### Module Structure
- **Built-in Function Categories**: Comprehensive coverage of all function types
- **Advanced Applications**: Complex business scenarios and real-world usage patterns
- **Performance Optimization**: Function usage best practices and performance implications
- **Custom Functions**: Creating and optimizing user-defined functions

---

## Slide 2: String Functions Mastery
**Advanced Text Processing and Manipulation**

### Core String Functions

#### **String Extraction and Manipulation**
```sql
-- Comprehensive string processing examples
DECLARE @SampleText NVARCHAR(100) = N'  John Michael Smith, Jr.  ';
DECLARE @Email NVARCHAR(100) = N'john.smith@company.com';
DECLARE @PhoneNumber NVARCHAR(20) = N'(555) 123-4567';

SELECT 
    -- Basic string functions
    @SampleText AS OriginalText,
    LEN(@SampleText) AS Length,
    DATALENGTH(@SampleText) AS DataLength,
    LTRIM(RTRIM(@SampleText)) AS Trimmed,
    UPPER(@SampleText) AS UpperCase,
    LOWER(@SampleText) AS LowerCase,
    
    -- Substring operations
    LEFT(@SampleText, 10) AS LeftPortion,
    RIGHT(@SampleText, 10) AS RightPortion,
    SUBSTRING(@SampleText, 3, 10) AS MiddlePortion,
    
    -- String searching
    CHARINDEX('Michael', @SampleText) AS MichaelPosition,
    PATINDEX('%[0-9]%', @PhoneNumber) AS FirstDigitPosition,
    
    -- String replacement
    REPLACE(@PhoneNumber, '(', '') AS RemoveOpenParen,
    REPLACE(REPLACE(REPLACE(@PhoneNumber, '(', ''), ')', ''), ' ', '') AS CleanPhone,
    
    -- String building
    CONCAT('Name: ', LTRIM(RTRIM(@SampleText)), ' | Email: ', @Email) AS ConcatenatedString,
    @SampleText + ' - ' + @Email AS TraditionalConcat;
```

#### **Advanced String Pattern Matching**
```sql
-- Complex pattern matching and validation
CREATE TABLE CustomerData (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    PostalCode NVARCHAR(10)
);

INSERT INTO CustomerData VALUES
    ('John Smith', 'john.smith@email.com', '(555) 123-4567', '12345'),
    ('Jane Doe', 'jane@company.co.uk', '555.123.4567', 'M5V 3L9'),
    ('Bob Johnson', 'bob.johnson+work@domain.org', '555-123-4567', '90210-1234');

-- Pattern validation queries
SELECT 
    CustomerName,
    Email,
    Phone,
    PostalCode,
    
    -- Email validation
    CASE 
        WHEN Email LIKE '%_@_%.__%' 
             AND Email NOT LIKE '%..%' 
             AND Email NOT LIKE '.%'
             AND Email NOT LIKE '%.'
             AND CHARINDEX(' ', Email) = 0
        THEN 'Valid Email'
        ELSE 'Invalid Email'
    END AS EmailStatus,
    
    -- Phone format standardization
    CASE 
        WHEN Phone LIKE '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' THEN 'Format 1'
        WHEN Phone LIKE '[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9][0-9]' THEN 'Format 2'
        WHEN Phone LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' THEN 'Format 3'
        ELSE 'Unknown Format'
    END AS PhoneFormat,
    
    -- Postal code validation (US vs Canadian)
    CASE 
        WHEN PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' THEN 'US ZIP'
        WHEN PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' THEN 'US ZIP+4'
        WHEN PostalCode LIKE '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]' THEN 'Canadian Postal'
        ELSE 'Unknown Format'
    END AS PostalCodeType
FROM CustomerData;
```

### String Parsing and Tokenization

#### **Advanced String Splitting**
```sql
-- String splitting techniques (SQL Server 2016+ has STRING_SPLIT)
DECLARE @DelimitedString NVARCHAR(200) = 'Apple,Orange,Banana,Grape,Pineapple';

-- Using STRING_SPLIT (SQL Server 2016+)
SELECT 
    value AS FruitName,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Position
FROM STRING_SPLIT(@DelimitedString, ',');

-- Manual parsing for complex scenarios
WITH ParsedNames AS (
    SELECT 
        LTRIM(RTRIM(SUBSTRING(@DelimitedString, 1, CHARINDEX(',', @DelimitedString + ',') - 1))) AS FirstName,
        LTRIM(RTRIM(SUBSTRING(@DelimitedString, CHARINDEX(',', @DelimitedString) + 1, 8000))) AS RemainingNames,
        1 AS Position
    
    UNION ALL
    
    SELECT 
        LTRIM(RTRIM(SUBSTRING(RemainingNames, 1, CHARINDEX(',', RemainingNames + ',') - 1))),
        CASE 
            WHEN CHARINDEX(',', RemainingNames) > 0 
            THEN LTRIM(RTRIM(SUBSTRING(RemainingNames, CHARINDEX(',', RemainingNames) + 1, 8000)))
            ELSE ''
        END,
        Position + 1
    FROM ParsedNames
    WHERE RemainingNames <> ''
)
SELECT Position, FirstName AS ParsedValue
FROM ParsedNames
ORDER BY Position;
```

---

## Slide 3: Date and Time Functions Excellence
**Comprehensive Temporal Data Processing**

### Date Arithmetic and Calculations

#### **Advanced Date Manipulation**
```sql
-- Comprehensive date function examples
DECLARE @CurrentDate DATETIME2 = SYSDATETIME();
DECLARE @BirthDate DATE = '1990-05-15';
DECLARE @HireDate DATE = '2020-03-01';

SELECT 
    @CurrentDate AS CurrentDateTime,
    @BirthDate AS BirthDate,
    @HireDate AS HireDate,
    
    -- Date parts extraction
    YEAR(@CurrentDate) AS CurrentYear,
    MONTH(@CurrentDate) AS CurrentMonth,
    DAY(@CurrentDate) AS CurrentDay,
    DATEPART(QUARTER, @CurrentDate) AS CurrentQuarter,
    DATEPART(WEEKDAY, @CurrentDate) AS WeekdayNumber,
    DATENAME(WEEKDAY, @CurrentDate) AS WeekdayName,
    DATENAME(MONTH, @CurrentDate) AS MonthName,
    
    -- Date arithmetic
    DATEDIFF(YEAR, @BirthDate, @CurrentDate) AS ApproximateAge,
    DATEDIFF(DAY, @HireDate, @CurrentDate) AS DaysEmployed,
    DATEDIFF(MONTH, @HireDate, @CurrentDate) AS MonthsEmployed,
    
    -- Accurate age calculation
    DATEDIFF(YEAR, @BirthDate, @CurrentDate) - 
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, @BirthDate, @CurrentDate), @BirthDate) > @CurrentDate 
        THEN 1 
        ELSE 0 
    END AS ExactAge,
    
    -- Date additions
    DATEADD(MONTH, 6, @CurrentDate) AS SixMonthsFromNow,
    DATEADD(YEAR, 1, @HireDate) AS FirstAnniversary,
    DATEADD(DAY, -30, @CurrentDate) AS ThirtyDaysAgo;
```

#### **Business Date Calculations**
```sql
-- Business-specific date calculations
DECLARE @ProjectStartDate DATE = '2023-06-15';
DECLARE @BusinessDays INT = 45;

-- Calculate business days (excluding weekends)
WITH BusinessDayCalculator AS (
    SELECT 
        @ProjectStartDate AS CalcDate,
        CASE 
            WHEN DATEPART(WEEKDAY, @ProjectStartDate) BETWEEN 2 AND 6 -- Monday to Friday
            THEN 1 
            ELSE 0 
        END AS IsBusinessDay,
        1 AS DayNumber
    
    UNION ALL
    
    SELECT 
        DATEADD(DAY, 1, CalcDate),
        CASE 
            WHEN DATEPART(WEEKDAY, DATEADD(DAY, 1, CalcDate)) BETWEEN 2 AND 6 
            THEN 1 
            ELSE 0 
        END,
        DayNumber + 1
    FROM BusinessDayCalculator
    WHERE DayNumber < 100 -- Safety limit
)
SELECT TOP 1
    @ProjectStartDate AS ProjectStart,
    CalcDate AS ProjectEndDate,
    DayNumber AS TotalDays,
    (SELECT SUM(IsBusinessDay) FROM BusinessDayCalculator b WHERE b.DayNumber <= c.DayNumber) AS BusinessDaysCount
FROM BusinessDayCalculator c
WHERE (SELECT SUM(IsBusinessDay) FROM BusinessDayCalculator b WHERE b.DayNumber <= c.DayNumber) >= @BusinessDays
ORDER BY DayNumber;
```

### Date Formatting and Presentation

#### **Comprehensive Date Formatting**
```sql
-- Date formatting examples
DECLARE @SampleDate DATETIME2 = '2023-12-25 14:30:45.123';

SELECT 
    @SampleDate AS OriginalDate,
    
    -- FORMAT function (SQL Server 2012+)
    FORMAT(@SampleDate, 'MM/dd/yyyy') AS USDateFormat,
    FORMAT(@SampleDate, 'dd/MM/yyyy') AS EuropeanDateFormat,
    FORMAT(@SampleDate, 'yyyy-MM-dd') AS ISO8601Date,
    FORMAT(@SampleDate, 'MMMM dd, yyyy') AS LongDateFormat,
    FORMAT(@SampleDate, 'dddd, MMMM dd, yyyy') AS FullDateFormat,
    FORMAT(@SampleDate, 'HH:mm:ss') AS TimeOnly,
    FORMAT(@SampleDate, 'yyyy-MM-dd HH:mm:ss.fff') AS FullTimestamp,
    
    -- CONVERT with style codes
    CONVERT(VARCHAR(10), @SampleDate, 101) AS USDate_101,
    CONVERT(VARCHAR(10), @SampleDate, 103) AS BritishDate_103,
    CONVERT(VARCHAR(10), @SampleDate, 112) AS ISO8601_112,
    CONVERT(VARCHAR(23), @SampleDate, 121) AS FullFormat_121,
    
    -- Custom formatting with DATENAME and DATEPART
    DATENAME(WEEKDAY, @SampleDate) + ', ' + 
    DATENAME(MONTH, @SampleDate) + ' ' + 
    CAST(DAY(@SampleDate) AS VARCHAR(2)) + ', ' + 
    CAST(YEAR(@SampleDate) AS VARCHAR(4)) AS CustomFormat;
```

---

## Slide 4: Mathematical and Statistical Functions
**Numeric Processing and Analysis**

### Basic Mathematical Operations

#### **Comprehensive Math Functions**
```sql
-- Mathematical function examples
DECLARE @Price DECIMAL(10,2) = 19.99;
DECLARE @Quantity INT = 7;
DECLARE @TaxRate DECIMAL(5,4) = 0.0875;

SELECT 
    @Price AS UnitPrice,
    @Quantity AS Quantity,
    @TaxRate AS TaxRate,
    
    -- Basic arithmetic
    @Price * @Quantity AS Subtotal,
    ROUND(@Price * @Quantity * @TaxRate, 2) AS TaxAmount,
    ROUND(@Price * @Quantity * (1 + @TaxRate), 2) AS Total,
    
    -- Rounding functions
    ROUND(19.567, 2) AS RoundToTwoPlaces,
    ROUND(19.567, 0) AS RoundToWhole,
    ROUND(19.567, -1) AS RoundToTens,
    CEILING(19.1) AS CeilingFunction,
    FLOOR(19.9) AS FloorFunction,
    
    -- Mathematical functions
    ABS(-15.5) AS AbsoluteValue,
    SIGN(-15.5) AS SignFunction,
    POWER(2, 8) AS PowerFunction,
    SQRT(64) AS SquareRoot,
    EXP(1) AS ExponentialE,
    LOG(10) AS NaturalLog,
    LOG10(100) AS Log10,
    
    -- Trigonometric functions
    PI() AS PiConstant,
    SIN(PI()/2) AS SineOfPi2,
    COS(0) AS CosineOfZero,
    TAN(PI()/4) AS TangentOfPi4;
```

### Aggregate and Window Functions

#### **Advanced Statistical Analysis**
```sql
-- Create sample data for statistical analysis
WITH SalesData AS (
    SELECT 'Q1' AS Quarter, 'North' AS Region, 15000 AS Sales UNION ALL
    SELECT 'Q1', 'South', 12000 UNION ALL
    SELECT 'Q1', 'East', 18000 UNION ALL
    SELECT 'Q1', 'West', 16000 UNION ALL
    SELECT 'Q2', 'North', 17000 UNION ALL
    SELECT 'Q2', 'South', 13500 UNION ALL
    SELECT 'Q2', 'East', 19500 UNION ALL
    SELECT 'Q2', 'West', 14500 UNION ALL
    SELECT 'Q3', 'North', 16500 UNION ALL
    SELECT 'Q3', 'South', 15000 UNION ALL
    SELECT 'Q3', 'East', 20000 UNION ALL
    SELECT 'Q3', 'West', 17500 UNION ALL
    SELECT 'Q4', 'North', 21000 UNION ALL
    SELECT 'Q4', 'South', 18000 UNION ALL
    SELECT 'Q4', 'East', 23000 UNION ALL
    SELECT 'Q4', 'West', 19000
)
SELECT 
    Quarter,
    Region,
    Sales,
    
    -- Basic aggregates
    SUM(Sales) OVER (PARTITION BY Quarter) AS QuarterTotal,
    AVG(Sales) OVER (PARTITION BY Quarter) AS QuarterAverage,
    COUNT(Sales) OVER (PARTITION BY Quarter) AS QuarterRegionCount,
    MIN(Sales) OVER (PARTITION BY Quarter) AS QuarterMin,
    MAX(Sales) OVER (PARTITION BY Quarter) AS QuarterMax,
    
    -- Running totals
    SUM(Sales) OVER (PARTITION BY Region ORDER BY Quarter) AS RunningRegionTotal,
    
    -- Ranking functions
    ROW_NUMBER() OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS QuarterRank,
    RANK() OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS QuarterRankWithTies,
    DENSE_RANK() OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS QuarterDenseRank,
    NTILE(2) OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS QuarterTile,
    
    -- Percentage calculations
    CAST(Sales AS DECIMAL(10,2)) / SUM(Sales) OVER (PARTITION BY Quarter) * 100 AS PercentOfQuarter,
    
    -- Lead/Lag functions
    LAG(Sales, 1) OVER (PARTITION BY Region ORDER BY Quarter) AS PreviousQuarterSales,
    LEAD(Sales, 1) OVER (PARTITION BY Region ORDER BY Quarter) AS NextQuarterSales,
    
    -- First/Last values
    FIRST_VALUE(Sales) OVER (PARTITION BY Region ORDER BY Quarter) AS FirstQuarterSales,
    LAST_VALUE(Sales) OVER (PARTITION BY Region ORDER BY Quarter 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastQuarterSales
FROM SalesData
ORDER BY Quarter, Region;
```

---

## Slide 5: Conversion and Formatting Functions
**Data Transformation and Presentation**

### Type Conversion Functions

#### **Safe and Efficient Conversions**
```sql
-- Comprehensive conversion examples
DECLARE @StringNumber VARCHAR(20) = '123.45';
DECLARE @StringDate VARCHAR(20) = '2023-12-25';
DECLARE @BadString VARCHAR(20) = 'NotANumber';
DECLARE @BadDate VARCHAR(20) = '2023-13-45'; -- Invalid date

SELECT 
    -- Traditional conversion functions
    CAST(@StringNumber AS DECIMAL(10,2)) AS CastToDecimal,
    CONVERT(DECIMAL(10,2), @StringNumber) AS ConvertToDecimal,
    CAST(@StringDate AS DATE) AS CastToDate,
    CONVERT(DATE, @StringDate) AS ConvertToDate,
    
    -- Safe conversion functions (SQL Server 2012+)
    TRY_CAST(@StringNumber AS DECIMAL(10,2)) AS TryCastNumber,
    TRY_CAST(@BadString AS DECIMAL(10,2)) AS TryCastBadNumber, -- Returns NULL
    TRY_CONVERT(DATE, @StringDate) AS TryConvertDate,
    TRY_CONVERT(DATE, @BadDate) AS TryConvertBadDate, -- Returns NULL
    
    -- Parse functions for specific formats
    TRY_PARSE('$123.45' AS MONEY USING 'en-US') AS ParseMoney,
    TRY_PARSE('25/12/2023' AS DATE USING 'en-GB') AS ParseBritishDate,
    TRY_PARSE('25.12.2023' AS DATE USING 'de-DE') AS ParseGermanDate,
    
    -- IIF for conditional conversion
    IIF(ISNUMERIC(@StringNumber) = 1, CAST(@StringNumber AS DECIMAL(10,2)), 0) AS ConditionalConversion;
```

#### **Advanced Formatting Techniques**
```sql
-- Advanced formatting examples
DECLARE @SampleNumber DECIMAL(15,2) = 1234567.89;
DECLARE @SampleDate DATETIME2 = '2023-12-25 14:30:45';
DECLARE @SamplePercent DECIMAL(5,4) = 0.1234;

SELECT 
    @SampleNumber AS OriginalNumber,
    @SampleDate AS OriginalDate,
    @SamplePercent AS OriginalPercent,
    
    -- Number formatting
    FORMAT(@SampleNumber, 'N2') AS NumberWithCommas,
    FORMAT(@SampleNumber, 'C2') AS Currency,
    FORMAT(@SampleNumber, '###,###,###.00') AS CustomNumberFormat,
    FORMAT(@SampleNumber, '0000000000.00') AS ZeroPadded,
    
    -- Percentage formatting
    FORMAT(@SamplePercent, 'P2') AS PercentageFormat,
    FORMAT(@SamplePercent * 100, '0.00') + '%' AS CustomPercentage,
    
    -- Date formatting
    FORMAT(@SampleDate, 'D') AS LongDatePattern,
    FORMAT(@SampleDate, 'F') AS FullDateTimePattern,
    FORMAT(@SampleDate, 'MM/dd/yyyy hh:mm tt') AS CustomDateTime,
    FORMAT(@SampleDate, 'yyyy-MM-ddTHH:mm:ss.fff') AS ISO8601Format,
    
    -- Conditional formatting
    CASE 
        WHEN @SampleNumber >= 1000000 THEN FORMAT(@SampleNumber/1000000, '0.0') + 'M'
        WHEN @SampleNumber >= 1000 THEN FORMAT(@SampleNumber/1000, '0.0') + 'K'
        ELSE FORMAT(@SampleNumber, '0.0')
    END AS ConditionalFormat;
```

---

## Slide 6: User-Defined Functions and Best Practices
**Creating Custom Reusable Logic**

### Scalar User-Defined Functions

#### **Business Logic Functions**
```sql
-- Create scalar function for business calculations
CREATE FUNCTION dbo.CalculateNetPrice(
    @UnitPrice DECIMAL(10,2),
    @Quantity INT,
    @DiscountPercent DECIMAL(5,2) = 0,
    @TaxRate DECIMAL(5,4) = 0.08
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @NetPrice DECIMAL(12,2);
    
    -- Calculate with discount and tax
    SET @NetPrice = @UnitPrice * @Quantity * (1 - @DiscountPercent / 100) * (1 + @TaxRate);
    
    RETURN ROUND(@NetPrice, 2);
END;

-- Usage example
SELECT 
    ProductID,
    ProductName,
    UnitPrice,
    OrderQuantity,
    dbo.CalculateNetPrice(UnitPrice, OrderQuantity, 10.0, 0.0875) AS NetPrice
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.OrderID = 10248;
```

### Table-Valued Functions

#### **Parameterized Data Sets**
```sql
-- Create table-valued function for flexible reporting
CREATE FUNCTION dbo.GetSalesByDateRange(
    @StartDate DATE,
    @EndDate DATE,
    @MinAmount DECIMAL(10,2) = 0
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        o.OrderID,
        o.CustomerID,
        c.CustomerName,
        o.OrderDate,
        SUM(od.UnitPrice * od.Quantity) AS OrderTotal,
        COUNT(od.ProductID) AS ItemCount
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
    GROUP BY o.OrderID, o.CustomerID, c.CustomerName, o.OrderDate
    HAVING SUM(od.UnitPrice * od.Quantity) >= @MinAmount
);

-- Usage examples
SELECT * FROM dbo.GetSalesByDateRange('2023-01-01', '2023-12-31', 1000.00)
ORDER BY OrderTotal DESC;

-- Use in complex queries
SELECT 
    CustomerName,
    COUNT(*) AS OrderCount,
    SUM(OrderTotal) AS TotalSales,
    AVG(OrderTotal) AS AverageOrder
FROM dbo.GetSalesByDateRange('2023-01-01', '2023-12-31', 500.00)
GROUP BY CustomerName
HAVING COUNT(*) >= 5
ORDER BY TotalSales DESC;
```

### Function Performance Considerations

#### **Optimization Best Practices**
```sql
-- Performance comparison: Function vs Inline calculation
-- BAD: Scalar UDF in SELECT (called for every row)
SELECT 
    OrderID,
    ProductID,
    UnitPrice,
    Quantity,
    dbo.CalculateNetPrice(UnitPrice, Quantity, 0, 0.08) AS NetPrice -- Slow!
FROM OrderDetails
WHERE OrderID BETWEEN 10240 AND 10250;

-- GOOD: Inline calculation (much faster)
SELECT 
    OrderID,
    ProductID,
    UnitPrice,
    Quantity,
    ROUND(UnitPrice * Quantity * 1.08, 2) AS NetPrice
FROM OrderDetails
WHERE OrderID BETWEEN 10240 AND 10250;

-- BETTER: Table-valued function when complex logic is needed
SELECT 
    s.OrderID,
    s.CustomerName,
    s.OrderTotal,
    -- Additional business logic can be added here
    CASE 
        WHEN s.OrderTotal >= 5000 THEN 'Premium'
        WHEN s.OrderTotal >= 1000 THEN 'Standard'
        ELSE 'Basic'
    END AS CustomerTier
FROM dbo.GetSalesByDateRange('2023-01-01', '2023-12-31', 0) s
WHERE s.OrderTotal > 500;
```

This comprehensive Module 7 presentation covers all aspects of SQL Server functions with detailed explanations, practical examples, and performance considerations that will give students expert-level understanding of function usage and optimization.