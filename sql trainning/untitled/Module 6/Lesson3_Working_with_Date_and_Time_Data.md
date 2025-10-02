# Lesson 3: Working with Date and Time Data

## Overview
Date and time data is fundamental to most business applications. SQL Server 2016 provides a comprehensive set of date and time data types with various precision levels and timezone support. This lesson covers all aspects of working with temporal data, including data types, functions, calculations, and best practices for handling dates and times effectively.

## Date and Time Data Types in SQL Server 2016

### Complete Date/Time Type Reference
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SQL SERVER 2016 DATE/TIME DATA TYPES                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Type          │Storage│ Range                  │ Precision    │ Time Zone │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  DATE          │3 bytes│ 0001-01-01 to          │ 1 day        │ No        │
│                │       │ 9999-12-31             │              │           │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  TIME          │3-5 by │ 00:00:00.0000000 to    │ 100 nanosec  │ No        │
│                │       │ 23:59:59.9999999       │              │           │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  SMALLDATETIME │4 bytes│ 1900-01-01 00:00 to    │ 1 minute     │ No        │
│                │       │ 2079-06-06 23:59       │              │           │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  DATETIME      │8 bytes│ 1753-01-01 00:00:00.000│ 3.33 millisec│ No        │
│                │       │ to 9999-12-31 23:59:59.997            │           │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  DATETIME2     │6-8 by │ 0001-01-01 00:00:00 to │ 100 nanosec  │ No        │
│                │       │ 9999-12-31 23:59:59.99999             │           │
│  ──────────────┼───────┼────────────────────────┼──────────────┼───────────┤
│  DATETIMEOFFSET│8-10by │ 0001-01-01 00:00:00 to │ 100 nanosec  │ Yes       │
│                │       │ 9999-12-31 23:59:59.99999 ±14:00      │           │
│  ──────────────┴───────┴────────────────────────┴──────────────┴───────────┤
│                                                                             │
│  Visual Comparison of Precision:                                           │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ SMALLDATETIME: 2024-01-15 14:30                                        │
│  │ DATETIME:      2024-01-15 14:30:25.123                                 │
│  │ DATETIME2(3):  2024-01-15 14:30:25.123                                 │
│  │ DATETIME2(7):  2024-01-15 14:30:25.1234567                             │
│  │ DATETIMEOFFSET:2024-01-15 14:30:25.1234567 -08:00                      │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Migration Path (Legacy → Modern):                                          │
│  DATETIME → DATETIME2 (better precision, wider range)                      │
│  SMALLDATETIME → DATETIME2(0) (wider range, same precision)                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Storage and Precision Details
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        PRECISION AND STORAGE BREAKDOWN                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  DATETIME2 and DATETIMEOFFSET Precision Scale:                             │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ Scale │ Precision           │ Storage  │ Example                        │
│  │ ─────┼─────────────────────┼──────────┼────────────────────────────────┤
│  │   0   │ 1 second            │ 6 bytes  │ 2024-01-15 14:30:25           │
│  │   1   │ 0.1 seconds         │ 6 bytes  │ 2024-01-15 14:30:25.1         │
│  │   2   │ 0.01 seconds        │ 6 bytes  │ 2024-01-15 14:30:25.12        │
│  │   3   │ 0.001 seconds       │ 7 bytes  │ 2024-01-15 14:30:25.123       │
│  │   4   │ 0.0001 seconds      │ 7 bytes  │ 2024-01-15 14:30:25.1234      │
│  │   5   │ 0.00001 seconds     │ 8 bytes  │ 2024-01-15 14:30:25.12345     │
│  │   6   │ 0.000001 seconds    │ 8 bytes  │ 2024-01-15 14:30:25.123456    │
│  │   7   │ 0.0000001 seconds   │ 8 bytes  │ 2024-01-15 14:30:25.1234567   │
│  └─────┴─────────────────────┴──────────┴────────────────────────────────┤
│                                                                             │
│  TIME Type with Scale:                                                      │
│  TIME(0) → 3 bytes: 14:30:25                                              │
│  TIME(3) → 4 bytes: 14:30:25.123                                          │
│  TIME(7) → 5 bytes: 14:30:25.1234567                                      │
│                                                                             │
│  DATETIMEOFFSET adds 2 bytes for timezone offset information               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Working with Date and Time Data Types

### Basic Date/Time Operations
```sql
-- Creating a comprehensive date/time example table
CREATE TABLE DateTimeExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Different date/time types
    EventDate DATE,                         -- Date only
    EventTime TIME(3),                      -- Time with milliseconds
    CreatedDateTime DATETIME,               -- Legacy datetime
    CreatedDateTime2 DATETIME2(7),          -- High precision datetime
    CreatedSmallDateTime SMALLDATETIME,     -- Low precision datetime
    CreatedWithTimeZone DATETIMEOFFSET(3),  -- Timezone-aware datetime
    
    -- Useful computed columns
    CreatedYear AS YEAR(CreatedDateTime2) PERSISTED,
    CreatedMonth AS MONTH(CreatedDateTime2) PERSISTED,
    CreatedDayOfWeek AS DATENAME(WEEKDAY, CreatedDateTime2) PERSISTED
);

-- Inserting sample data with various date formats
INSERT INTO DateTimeExamples (
    EventDate, EventTime, CreatedDateTime, CreatedDateTime2, 
    CreatedSmallDateTime, CreatedWithTimeZone
) VALUES 
    ('2024-01-15', '09:30:00.123', '2024-01-15 09:30:00.123', 
     '2024-01-15 09:30:00.1234567', '2024-01-15 09:30', 
     '2024-01-15 09:30:00.123 -08:00'),
    
    ('2024-03-22', '14:45:30.456', '2024-03-22 14:45:30.456', 
     '2024-03-22 14:45:30.4567890', '2024-03-22 14:45', 
     '2024-03-22 14:45:30.456 +05:30'),
     
    ('2024-07-04', '18:15:45.789', '2024-07-04 18:15:45.789', 
     '2024-07-04 18:15:45.7890123', '2024-07-04 18:15', 
     '2024-07-04 18:15:45.789 +00:00');

-- Viewing different date/time representations
SELECT 
    ID,
    EventDate,
    EventTime,
    CreatedDateTime,
    CreatedDateTime2,
    CreatedSmallDateTime,
    CreatedWithTimeZone,
    CreatedYear,
    CreatedMonth,
    CreatedDayOfWeek
FROM DateTimeExamples;
```

### Current Date/Time Functions
```sql
-- SQL Server date/time functions comparison
SELECT 
    -- Legacy functions
    GETDATE() AS GetDate_DateTime,           -- Returns DATETIME
    GETUTCDATE() AS GetUTCDate_DateTime,     -- Returns DATETIME in UTC
    
    -- Modern functions (SQL Server 2008+)
    SYSDATETIME() AS SysDateTime_DateTime2,  -- Returns DATETIME2(7)
    SYSUTCDATETIME() AS SysUTCDateTime_DateTime2, -- Returns DATETIME2(7) in UTC
    SYSDATETIMEOFFSET() AS SysDateTimeOffset, -- Returns DATETIMEOFFSET(7)
    
    -- Date/time components
    CURRENT_TIMESTAMP AS CurrentTimestamp,   -- ANSI standard, same as GETDATE()
    
    -- Just date and time
    CAST(SYSDATETIME() AS DATE) AS TodayDate,
    CAST(SYSDATETIME() AS TIME) AS CurrentTime;

-- Precision demonstration
SELECT 
    GETDATE() AS GetDate_Precision,          -- 3.33ms precision
    SYSDATETIME() AS SysDateTime_Precision,  -- 100ns precision
    FORMAT(SYSDATETIME(), 'yyyy-MM-dd HH:mm:ss.fffffff') AS FullPrecision;
```

## Date and Time Arithmetic

### Date/Time Calculations and Functions
```sql
-- Comprehensive date arithmetic examples
DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2024-12-31';
DECLARE @SampleDateTime DATETIME2 = '2024-06-15 14:30:25.123';

SELECT 
    -- DATEDIFF variations
    DATEDIFF(DAY, @StartDate, @EndDate) AS DaysDifference,
    DATEDIFF(WEEK, @StartDate, @EndDate) AS WeeksDifference,
    DATEDIFF(MONTH, @StartDate, @EndDate) AS MonthsDifference,
    DATEDIFF(YEAR, @StartDate, @EndDate) AS YearsDifference,
    DATEDIFF(HOUR, @StartDate, @EndDate) AS HoursDifference,
    DATEDIFF(MINUTE, @StartDate, @EndDate) AS MinutesDifference,
    DATEDIFF(SECOND, @StartDate, @EndDate) AS SecondsDifference,
    
    -- DATEDIFF_BIG for large differences (SQL Server 2016+)
    DATEDIFF_BIG(MILLISECOND, @StartDate, @EndDate) AS MillisecondsDifference,
    DATEDIFF_BIG(MICROSECOND, @StartDate, @EndDate) AS MicrosecondsDifference,
    
    -- DATEADD variations
    DATEADD(DAY, 30, @StartDate) AS Add30Days,
    DATEADD(MONTH, -6, @SampleDateTime) AS Subtract6Months,
    DATEADD(YEAR, 1, @EndDate) AS AddOneYear,
    DATEADD(HOUR, 8, @SampleDateTime) AS Add8Hours,
    DATEADD(MINUTE, -15, @SampleDateTime) AS Subtract15Minutes,
    DATEADD(SECOND, 3600, @SampleDateTime) AS Add1HourInSeconds;
```

### Advanced Date Calculations
```sql
-- Complex date calculation scenarios
WITH DateCalculations AS (
    SELECT 
        ID,
        CreatedDateTime2,
        EventDate,
        
        -- Age calculations
        DATEDIFF(YEAR, EventDate, SYSDATETIME()) AS AgeInYears,
        DATEDIFF(MONTH, EventDate, SYSDATETIME()) AS AgeInMonths,
        DATEDIFF(DAY, EventDate, SYSDATETIME()) AS AgeInDays,
        
        -- Business day calculations (approximate)
        CASE DATENAME(WEEKDAY, EventDate)
            WHEN 'Saturday' THEN DATEADD(DAY, 2, EventDate)
            WHEN 'Sunday' THEN DATEADD(DAY, 1, EventDate)
            ELSE EventDate
        END AS NextBusinessDay,
        
        -- Quarter calculations
        DATEPART(QUARTER, EventDate) AS Quarter,
        DATEFROMPARTS(YEAR(EventDate), (DATEPART(QUARTER, EventDate) - 1) * 3 + 1, 1) AS QuarterStart,
        EOMONTH(DATEFROMPARTS(YEAR(EventDate), DATEPART(QUARTER, EventDate) * 3, 1)) AS QuarterEnd,
        
        -- Week calculations
        DATEPART(WEEK, EventDate) AS WeekOfYear,
        DATEPART(WEEKDAY, EventDate) AS DayOfWeek,
        DATEADD(DAY, -(DATEPART(WEEKDAY, EventDate) - 1), EventDate) AS WeekStart,
        DATEADD(DAY, 7 - DATEPART(WEEKDAY, EventDate), EventDate) AS WeekEnd,
        
        -- Month boundaries
        DATEFROMPARTS(YEAR(EventDate), MONTH(EventDate), 1) AS MonthStart,
        EOMONTH(EventDate) AS MonthEnd,
        
        -- Year boundaries
        DATEFROMPARTS(YEAR(EventDate), 1, 1) AS YearStart,
        DATEFROMPARTS(YEAR(EventDate), 12, 31) AS YearEnd
        
    FROM DateTimeExamples
)
SELECT * FROM DateCalculations;

-- Working days calculation (excluding weekends)
CREATE FUNCTION dbo.CalculateWorkingDays(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @WorkingDays INT;
    
    WITH DateRange AS (
        SELECT @StartDate AS CurrentDate
        UNION ALL
        SELECT DATEADD(DAY, 1, CurrentDate)
        FROM DateRange
        WHERE CurrentDate < @EndDate
    )
    SELECT @WorkingDays = COUNT(*)
    FROM DateRange
    WHERE DATENAME(WEEKDAY, CurrentDate) NOT IN ('Saturday', 'Sunday')
    OPTION (MAXRECURSION 10000);
    
    RETURN @WorkingDays;
END;

-- Example usage of working days function
SELECT 
    EventDate,
    DATEADD(MONTH, 1, EventDate) AS OneMonthLater,
    dbo.CalculateWorkingDays(EventDate, DATEADD(MONTH, 1, EventDate)) AS WorkingDaysInMonth
FROM DateTimeExamples;
```

## Date and Time Formatting

### String Formatting and Conversion
```sql
-- Comprehensive date formatting examples
DECLARE @SampleDate DATETIME2 = '2024-03-15 14:30:25.123';
DECLARE @SampleDateOffset DATETIMEOFFSET = '2024-03-15 14:30:25.123 -08:00';

SELECT 
    -- CONVERT with style codes (legacy but still useful)
    CONVERT(VARCHAR(10), @SampleDate, 101) AS US_Format,        -- MM/DD/YYYY
    CONVERT(VARCHAR(10), @SampleDate, 103) AS UK_Format,        -- DD/MM/YYYY
    CONVERT(VARCHAR(10), @SampleDate, 112) AS ISO_Format,       -- YYYYMMDD
    CONVERT(VARCHAR(19), @SampleDate, 120) AS ODBC_Format,      -- YYYY-MM-DD HH:MM:SS
    CONVERT(VARCHAR(23), @SampleDate, 121) AS Extended_Format,  -- YYYY-MM-DD HH:MM:SS.mmm
    
    -- FORMAT function (SQL Server 2012+) - more flexible
    FORMAT(@SampleDate, 'yyyy-MM-dd') AS ISO_Date,
    FORMAT(@SampleDate, 'MM/dd/yyyy') AS US_Date,
    FORMAT(@SampleDate, 'dd-MMM-yyyy') AS Long_Date,
    FORMAT(@SampleDate, 'dddd, MMMM dd, yyyy') AS Full_Date,
    FORMAT(@SampleDate, 'HH:mm:ss') AS Time_24Hour,
    FORMAT(@SampleDate, 'hh:mm:ss tt') AS Time_12Hour,
    FORMAT(@SampleDate, 'yyyy-MM-dd HH:mm:ss.fff') AS DateTime_Milliseconds,
    
    -- Cultural formatting
    FORMAT(@SampleDate, 'D', 'en-US') AS US_Long_Date,
    FORMAT(@SampleDate, 'D', 'en-GB') AS UK_Long_Date,
    FORMAT(@SampleDate, 'D', 'de-DE') AS German_Long_Date,
    FORMAT(@SampleDate, 'D', 'ja-JP') AS Japanese_Long_Date,
    
    -- Custom formatting patterns
    FORMAT(@SampleDate, 'yyyy') AS Year_Only,
    FORMAT(@SampleDate, 'MMMM') AS Month_Name,
    FORMAT(@SampleDate, 'dddd') AS Day_Name,
    FORMAT(@SampleDate, 'yyyy-\QQ') AS Year_Quarter,
    
    -- Timezone formatting
    FORMAT(@SampleDateOffset, 'yyyy-MM-dd HH:mm:ss zzz') AS With_Timezone_Offset;
```

### Parsing and Converting Strings to Dates
```sql
-- String to date conversion examples
DECLARE @StringDates TABLE (
    DateString VARCHAR(50),
    Format VARCHAR(50)
);

INSERT INTO @StringDates VALUES
    ('2024-03-15', 'ISO Format'),
    ('03/15/2024', 'US Format'),
    ('15/03/2024', 'European Format'),
    ('15-Mar-2024', 'Month Name'),
    ('March 15, 2024', 'Long Format'),
    ('2024-03-15 14:30:25', 'DateTime'),
    ('2024-03-15T14:30:25', 'ISO DateTime'),
    ('20240315', 'Compact Format'),
    ('2024-075', 'Julian Date (Day 75)');

-- Safe conversion with error handling
SELECT 
    DateString,
    Format,
    
    -- TRY_CAST - returns NULL if conversion fails
    TRY_CAST(DateString AS DATE) AS TryCast_Result,
    
    -- TRY_CONVERT - returns NULL if conversion fails  
    TRY_CONVERT(DATE, DateString) AS TryConvert_Result,
    
    -- TRY_PARSE - more flexible parsing
    TRY_PARSE(DateString AS DATE) AS TryParse_Result,
    
    -- ISDATE - check if string is valid date
    ISDATE(DateString) AS IsValidDate,
    
    -- Conditional conversion
    CASE 
        WHEN ISDATE(DateString) = 1 THEN CAST(DateString AS DATE)
        ELSE NULL
    END AS SafeConversion

FROM @StringDates;

-- Parsing specific formats
SELECT 
    -- Parse dates with specific cultures
    TRY_PARSE('15/03/2024' AS DATE USING 'en-GB') AS UK_Date_Parse,
    TRY_PARSE('03/15/2024' AS DATE USING 'en-US') AS US_Date_Parse,
    TRY_PARSE('15.03.2024' AS DATE USING 'de-DE') AS German_Date_Parse,
    
    -- Convert with specific style
    TRY_CONVERT(DATE, '15/03/2024', 103) AS UK_Style_Convert,
    TRY_CONVERT(DATE, '03/15/2024', 101) AS US_Style_Convert;
```

## Working with Time Zones

### Time Zone Handling with DATETIMEOFFSET
```sql
-- Comprehensive timezone examples
CREATE TABLE TimezoneExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100),
    LocalTime DATETIME2(3),
    UTCTime DATETIME2(3),
    TimeWithOffset DATETIMEOFFSET(3)
);

-- Insert events from different time zones
INSERT INTO TimezoneExamples (EventName, LocalTime, UTCTime, TimeWithOffset) VALUES
    ('New York Meeting', '2024-03-15 09:00:00.000', '2024-03-15 14:00:00.000', '2024-03-15 09:00:00.000 -05:00'),
    ('London Conference', '2024-03-15 14:00:00.000', '2024-03-15 14:00:00.000', '2024-03-15 14:00:00.000 +00:00'),
    ('Tokyo Presentation', '2024-03-15 23:00:00.000', '2024-03-15 14:00:00.000', '2024-03-15 23:00:00.000 +09:00'),
    ('Los Angeles Call', '2024-03-15 06:00:00.000', '2024-03-15 14:00:00.000', '2024-03-15 06:00:00.000 -08:00');

-- Working with timezone conversions
SELECT 
    EventName,
    TimeWithOffset AS OriginalTime,
    
    -- Convert to UTC
    SWITCHOFFSET(TimeWithOffset, '+00:00') AS UTC_Time,
    
    -- Convert to different time zones
    SWITCHOFFSET(TimeWithOffset, '-05:00') AS Eastern_Time,
    SWITCHOFFSET(TimeWithOffset, '-08:00') AS Pacific_Time,
    SWITCHOFFSET(TimeWithOffset, '+01:00') AS Central_European_Time,
    SWITCHOFFSET(TimeWithOffset, '+09:00') AS Japan_Time,
    
    -- Extract timezone offset
    DATEPART(TZOFFSET, TimeWithOffset) AS Timezone_Offset_Minutes,
    
    -- Convert to local server time (removes offset)
    CAST(TimeWithOffset AS DATETIME2) AS Local_Server_Time

FROM TimezoneExamples;

-- Time zone arithmetic and comparisons
WITH TimezoneCalculations AS (
    SELECT 
        t1.EventName AS Event1,
        t2.EventName AS Event2,
        t1.TimeWithOffset AS Time1,
        t2.TimeWithOffset AS Time2,
        
        -- Calculate time difference (automatically handles timezones)
        DATEDIFF(MINUTE, t1.TimeWithOffset, t2.TimeWithOffset) AS MinutesDifference,
        
        -- Compare times in same timezone
        CASE 
            WHEN SWITCHOFFSET(t1.TimeWithOffset, '+00:00') < SWITCHOFFSET(t2.TimeWithOffset, '+00:00') 
            THEN t1.EventName + ' is before ' + t2.EventName
            WHEN SWITCHOFFSET(t1.TimeWithOffset, '+00:00') > SWITCHOFFSET(t2.TimeWithOffset, '+00:00') 
            THEN t1.EventName + ' is after ' + t2.EventName
            ELSE t1.EventName + ' is at the same time as ' + t2.EventName
        END AS TimeComparison
        
    FROM TimezoneExamples t1
    CROSS JOIN TimezoneExamples t2
    WHERE t1.ID < t2.ID
)
SELECT * FROM TimezoneCalculations;
```

## Advanced Date/Time Scenarios

### Business Logic with Dates
```sql
-- Advanced business date calculations
CREATE TABLE BusinessDateExamples (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME2,
    RequiredDate DATETIME2,
    ShippedDate DATETIME2 NULL,
    CustomerRegion VARCHAR(50)
);

-- Sample business data
INSERT INTO BusinessDateExamples (OrderDate, RequiredDate, ShippedDate, CustomerRegion) VALUES
    ('2024-01-15 10:30:00', '2024-01-20 17:00:00', '2024-01-18 14:30:00', 'North America'),
    ('2024-01-20 09:15:00', '2024-01-25 17:00:00', NULL, 'Europe'),
    ('2024-01-22 16:45:00', '2024-01-27 17:00:00', '2024-01-26 11:00:00', 'Asia Pacific'),
    ('2024-01-25 11:20:00', '2024-01-30 17:00:00', '2024-01-29 15:45:00', 'North America');

-- Complex business logic with dates
SELECT 
    ID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    CustomerRegion,
    
    -- Business days calculation
    CASE 
        WHEN DATENAME(WEEKDAY, OrderDate) IN ('Saturday', 'Sunday') THEN 'Weekend Order'
        ELSE 'Weekday Order'
    END AS OrderTiming,
    
    -- Processing time analysis
    CASE 
        WHEN ShippedDate IS NULL THEN 'Not Shipped'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 1 THEN 'Same/Next Day'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 3 THEN 'Fast Processing'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 7 THEN 'Standard Processing'
        ELSE 'Slow Processing'
    END AS ProcessingSpeed,
    
    -- On-time delivery analysis
    CASE 
        WHEN ShippedDate IS NULL AND RequiredDate < SYSDATETIME() THEN 'Overdue'
        WHEN ShippedDate IS NULL THEN 'Pending'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
        WHEN DATEDIFF(DAY, RequiredDate, ShippedDate) <= 2 THEN 'Slightly Late'
        ELSE 'Very Late'
    END AS DeliveryStatus,
    
    -- Working days between order and required date
    DATEDIFF(DAY, OrderDate, RequiredDate) - 
    (DATEDIFF(WEEK, OrderDate, RequiredDate) * 2) -
    CASE WHEN DATENAME(WEEKDAY, OrderDate) = 'Sunday' THEN 1 ELSE 0 END -
    CASE WHEN DATENAME(WEEKDAY, RequiredDate) = 'Saturday' THEN 1 ELSE 0 END AS BusinessDaysAllowed,
    
    -- Regional business hours consideration
    CASE CustomerRegion
        WHEN 'Asia Pacific' THEN DATEADD(HOUR, 12, OrderDate)  -- +12 hours for APAC
        WHEN 'Europe' THEN DATEADD(HOUR, 6, OrderDate)        -- +6 hours for Europe
        ELSE OrderDate                                          -- Local time for North America
    END AS RegionalOrderTime,
    
    -- Next business day calculation
    CASE 
        WHEN DATENAME(WEEKDAY, DATEADD(DAY, 1, OrderDate)) = 'Saturday' 
             THEN DATEADD(DAY, 3, CAST(OrderDate AS DATE))
        WHEN DATENAME(WEEKDAY, DATEADD(DAY, 1, OrderDate)) = 'Sunday' 
             THEN DATEADD(DAY, 2, CAST(OrderDate AS DATE))
        ELSE DATEADD(DAY, 1, CAST(OrderDate AS DATE))
    END AS NextBusinessDay

FROM BusinessDateExamples;

-- Seasonal and periodic analysis
WITH SeasonalAnalysis AS (
    SELECT 
        *,
        -- Season calculation
        CASE 
            WHEN MONTH(OrderDate) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(OrderDate) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(OrderDate) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS Season,
        
        -- Fiscal quarter (assuming April 1 fiscal year start)
        CASE 
            WHEN MONTH(OrderDate) IN (4, 5, 6) THEN 'Q1'
            WHEN MONTH(OrderDate) IN (7, 8, 9) THEN 'Q2'
            WHEN MONTH(OrderDate) IN (10, 11, 12) THEN 'Q3'
            ELSE 'Q4'
        END AS FiscalQuarter,
        
        -- Holiday proximity (simplified)
        CASE 
            WHEN (MONTH(OrderDate) = 12 AND DAY(OrderDate) >= 20) OR 
                 (MONTH(OrderDate) = 1 AND DAY(OrderDate) <= 5) THEN 'Holiday Season'
            WHEN MONTH(OrderDate) = 11 AND DAY(OrderDate) >= 20 THEN 'Pre-Holiday'
            WHEN MONTH(OrderDate) = 7 AND DAY(OrderDate) <= 10 THEN 'Independence Day Week'
            ELSE 'Regular Period'
        END AS HolidayProximity
        
    FROM BusinessDateExamples
)
SELECT * FROM SeasonalAnalysis;
```

### Date Range Queries and Windows
```sql
-- Advanced date range and windowing functions
WITH DateRangeAnalysis AS (
    SELECT 
        ID,
        OrderDate,
        CustomerRegion,
        
        -- Moving averages using date windows
        COUNT(*) OVER (
            ORDER BY OrderDate 
            RANGE BETWEEN INTERVAL '7' DAY PRECEDING AND CURRENT ROW
        ) AS OrdersLast7Days,
        
        COUNT(*) OVER (
            ORDER BY OrderDate 
            RANGE BETWEEN INTERVAL '30' DAY PRECEDING AND CURRENT ROW
        ) AS OrdersLast30Days,
        
        -- Running totals and sequences
        ROW_NUMBER() OVER (ORDER BY OrderDate) AS OrderSequence,
        ROW_NUMBER() OVER (PARTITION BY CustomerRegion ORDER BY OrderDate) AS RegionalSequence,
        
        -- Date-based ranking
        DENSE_RANK() OVER (ORDER BY CAST(OrderDate AS DATE)) AS DayRank,
        RANK() OVER (PARTITION BY YEAR(OrderDate), MONTH(OrderDate) ORDER BY OrderDate) AS MonthlyRank,
        
        -- Previous and next order dates
        LAG(OrderDate, 1) OVER (ORDER BY OrderDate) AS PreviousOrderDate,
        LEAD(OrderDate, 1) OVER (ORDER BY OrderDate) AS NextOrderDate,
        
        -- Time since last order
        DATEDIFF(DAY, 
            LAG(OrderDate, 1) OVER (ORDER BY OrderDate), 
            OrderDate
        ) AS DaysSinceLastOrder,
        
        -- First and last orders of the month
        FIRST_VALUE(OrderDate) OVER (
            PARTITION BY YEAR(OrderDate), MONTH(OrderDate) 
            ORDER BY OrderDate 
            ROWS UNBOUNDED PRECEDING
        ) AS FirstOrderOfMonth,
        
        LAST_VALUE(OrderDate) OVER (
            PARTITION BY YEAR(OrderDate), MONTH(OrderDate) 
            ORDER BY OrderDate 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS LastOrderOfMonth
        
    FROM BusinessDateExamples
)
SELECT * FROM DateRangeAnalysis;

-- Date-based aggregations and reporting
SELECT 
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    DATENAME(MONTH, OrderDate) AS MonthName,
    DATEPART(WEEK, OrderDate) AS WeekOfYear,
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
    
    COUNT(*) AS OrderCount,
    MIN(OrderDate) AS FirstOrder,
    MAX(OrderDate) AS LastOrder,
    DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)) AS DaysSpan,
    
    -- Average days between orders in this period
    CASE 
        WHEN COUNT(*) > 1 THEN 
            CAST(DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)) AS FLOAT) / (COUNT(*) - 1)
        ELSE NULL
    END AS AvgDaysBetweenOrders

FROM BusinessDateExamples
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATEPART(WEEK, OrderDate), DATENAME(WEEKDAY, OrderDate)
ORDER BY OrderYear, OrderMonth, WeekOfYear;
```

## Performance Considerations

### Date/Time Indexing and Query Optimization
```sql
-- Effective indexing strategies for date columns
CREATE TABLE DatePerformanceExample (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EventDate DATETIME2(3),
    EventType VARCHAR(50),
    CustomerID INT,
    Amount DECIMAL(10,2)
);

-- Efficient indexes for date queries
CREATE INDEX IX_EventDate_Covering 
ON DatePerformanceExample (EventDate) 
INCLUDE (EventType, CustomerID, Amount);

-- Filtered index for recent data
CREATE INDEX IX_EventDate_Recent 
ON DatePerformanceExample (EventDate, CustomerID)
WHERE EventDate >= '2024-01-01';

-- Composite index for date range + filtering
CREATE INDEX IX_EventDate_Type_Customer 
ON DatePerformanceExample (EventDate, EventType, CustomerID);

-- Query optimization examples
-- GOOD: SARGable date range query
SELECT ID, EventDate, EventType, Amount
FROM DatePerformanceExample
WHERE EventDate >= '2024-01-01' 
  AND EventDate < '2024-02-01'
  AND EventType = 'Sale';

-- GOOD: Using date boundaries efficiently
DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2024-01-31';

SELECT ID, EventDate, Amount
FROM DatePerformanceExample
WHERE EventDate >= @StartDate 
  AND EventDate < DATEADD(DAY, 1, @EndDate);  -- Exclusive end

-- AVOID: Non-SARGable date functions in WHERE clause
-- SELECT ID, EventDate FROM DatePerformanceExample 
-- WHERE YEAR(EventDate) = 2024 AND MONTH(EventDate) = 1;  -- Can't use index efficiently

-- BETTER: Use date ranges instead
SELECT ID, EventDate 
FROM DatePerformanceExample
WHERE EventDate >= '2024-01-01' 
  AND EventDate < '2024-02-01';

-- AVOID: GETDATE() in WHERE clause (non-deterministic)
-- SELECT ID FROM DatePerformanceExample WHERE EventDate > GETDATE() - 30;

-- BETTER: Calculate date outside query
DECLARE @CutoffDate DATETIME2 = DATEADD(DAY, -30, SYSDATETIME());
SELECT ID FROM DatePerformanceExample WHERE EventDate > @CutoffDate;
```

### Date/Time Storage Optimization
```sql
-- Storage comparison and optimization
CREATE TABLE DateStorageComparison (
    ID INT IDENTITY(1,1),
    
    -- Different precision levels
    LowPrecision DATETIME2(0),      -- 6 bytes, second precision
    MediumPrecision DATETIME2(3),   -- 7 bytes, millisecond precision  
    HighPrecision DATETIME2(7),     -- 8 bytes, 100ns precision
    
    -- Legacy vs modern
    LegacyDateTime DATETIME,        -- 8 bytes, ~3.33ms precision
    ModernDateTime DATETIME2(3),    -- 7 bytes, 1ms precision
    
    -- Date-only scenarios
    DateOnly DATE,                  -- 3 bytes
    DateTimeForDateOnly DATETIME2,  -- 6-8 bytes (wasteful for date-only)
    
    -- Time-only scenarios
    TimeOnly TIME(3),               -- 4 bytes
    DateTimeForTimeOnly DATETIME2   -- 6-8 bytes (wasteful for time-only)
);

-- Best practices for storage optimization
-- 1. Use appropriate precision
-- 2. Separate date and time when only one is needed
-- 3. Consider computed columns for derived date parts
-- 4. Use DATE type for date-only columns
-- 5. Use TIME type for time-only columns

-- Example of optimized table design
CREATE TABLE OptimizedDateTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Use appropriate precision for your needs
    CreatedDate DATE NOT NULL,               -- 3 bytes, date only
    CreatedTime TIME(0) NOT NULL,            -- 3 bytes, second precision
    ModifiedDateTime DATETIME2(3) NOT NULL,  -- 7 bytes, millisecond precision
    
    -- Computed columns for common queries
    CreatedYear AS YEAR(CreatedDate) PERSISTED,
    CreatedMonth AS MONTH(CreatedDate) PERSISTED,
    CreatedDayOfWeek AS DATEPART(WEEKDAY, CreatedDate) PERSISTED,
    
    -- Full datetime when needed (computed)
    CreatedDateTime AS CAST(CreatedDate AS DATETIME2) + CAST(CreatedTime AS DATETIME2) PERSISTED
);

-- Index on computed columns for performance
CREATE INDEX IX_CreatedYear_Month ON OptimizedDateTable (CreatedYear, CreatedMonth);
CREATE INDEX IX_CreatedDayOfWeek ON OptimizedDateTable (CreatedDayOfWeek);
```

## Common Pitfalls and Best Practices

### Date/Time Common Mistakes
```sql
-- Common date/time pitfalls and solutions

-- PITFALL 1: Implicit conversion and precision loss
DECLARE @DateString VARCHAR(20) = '2024-01-15 14:30:25.123456';

SELECT 
    CAST(@DateString AS DATETIME) AS DateTime_Result,     -- Loses precision
    CAST(@DateString AS DATETIME2) AS DateTime2_Result,   -- Preserves precision
    TRY_CAST(@DateString AS DATETIME2(7)) AS Safe_Result; -- Explicit precision

-- PITFALL 2: Time zone assumptions
-- Storing local times without timezone info
CREATE TABLE BadTimeZoneExample (
    EventTime DATETIME2,  -- BAD: No timezone info
    Description VARCHAR(100)
);

-- Better approach: Always consider timezone
CREATE TABLE GoodTimeZoneExample (
    EventTimeUTC DATETIME2,          -- Store in UTC
    EventTimeLocal DATETIMEOFFSET,   -- Or store with timezone
    TimeZoneOffset INT,              -- Or store offset separately
    Description VARCHAR(100)
);

-- PITFALL 3: Date range queries excluding end date
-- This excludes events on the end date
SELECT * FROM DateTimeExamples 
WHERE EventDate BETWEEN '2024-01-01' AND '2024-01-31';  -- Only gets start of 2024-01-31

-- Better: Use exclusive end date
SELECT * FROM DateTimeExamples 
WHERE EventDate >= '2024-01-01' AND EventDate < '2024-02-01';

-- PITFALL 4: Using DATEDIFF incorrectly for age calculation
DECLARE @BirthDate DATE = '1990-12-31';
DECLARE @CurrentDate DATE = '1991-01-01';

SELECT 
    DATEDIFF(YEAR, @BirthDate, @CurrentDate) AS Wrong_Age,  -- Returns 1, but person is still 0
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, @BirthDate, @CurrentDate), @BirthDate) > @CurrentDate
        THEN DATEDIFF(YEAR, @BirthDate, @CurrentDate) - 1
        ELSE DATEDIFF(YEAR, @BirthDate, @CurrentDate)
    END AS Correct_Age;  -- Returns 0, which is correct

-- PITFALL 5: Not handling leap years properly
-- Wrong way to add a year
SELECT DATEADD(YEAR, 1, '2024-02-29') AS Wrong_Leap_Year;  -- Works but may be unexpected

-- Consider business rules for leap year handling
SELECT 
    CASE 
        WHEN MONTH('2024-02-29') = 2 AND DAY('2024-02-29') = 29 
             AND DAY(DATEADD(YEAR, 1, '2024-02-29')) = 28
        THEN DATEADD(YEAR, 1, '2024-02-29')  -- Feb 28, 2025
        ELSE DATEADD(YEAR, 1, '2024-02-29')
    END AS Leap_Year_Handling;

-- PITFALL 6: Comparing dates with different data types
DECLARE @Date1 DATE = '2024-01-15';
DECLARE @DateTime1 DATETIME2 = '2024-01-15 00:00:00';

-- This works but may be unexpected
SELECT 
    CASE WHEN @Date1 = @DateTime1 THEN 'Equal' ELSE 'Not Equal' END AS Comparison1,
    -- Better to be explicit about comparison
    CASE WHEN @Date1 = CAST(@DateTime1 AS DATE) THEN 'Equal' ELSE 'Not Equal' END AS Comparison2;
```

### Best Practices Summary
```sql
-- Date/Time best practices compilation

-- 1. Use appropriate data types
CREATE TABLE BestPracticesExample (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Use DATE for date-only values
    BirthDate DATE,                     -- Not DATETIME2
    
    -- Use TIME for time-only values
    BusinessHours TIME(0),              -- Not DATETIME2
    
    -- Use DATETIME2 instead of DATETIME for new applications
    CreatedDateTime DATETIME2(3),       -- Better than DATETIME
    
    -- Use DATETIMEOFFSET for timezone-aware applications
    EventDateTime DATETIMEOFFSET(3),    -- For global applications
    
    -- Store UTC times for consistency
    CreatedUTC DATETIME2(3),
    
    -- Use appropriate precision (don't over-specify)
    LogTimestamp DATETIME2(3),          -- 1ms precision usually sufficient
    
    -- Consider computed columns for common date parts
    CreatedYear AS YEAR(CreatedDateTime) PERSISTED,
    CreatedMonth AS MONTH(CreatedDateTime) PERSISTED
);

-- 2. Use proper indexing strategies
CREATE INDEX IX_CreatedDateTime ON BestPracticesExample (CreatedDateTime);
CREATE INDEX IX_BirthDate_Covering ON BestPracticesExample (BirthDate) INCLUDE (ID);

-- 3. Write SARGable queries
-- Good examples:
SELECT * FROM BestPracticesExample 
WHERE CreatedDateTime >= '2024-01-01' AND CreatedDateTime < '2024-02-01';

SELECT * FROM BestPracticesExample 
WHERE BirthDate BETWEEN '1990-01-01' AND '1999-12-31';

-- 4. Handle time zones consistently
-- Store in UTC, display in local time
SELECT 
    EventDateTime AS UTC_Time,
    SWITCHOFFSET(EventDateTime, '-08:00') AS Pacific_Time,
    SWITCHOFFSET(EventDateTime, '-05:00') AS Eastern_Time
FROM BestPracticesExample
WHERE EventDateTime IS NOT NULL;

-- 5. Use safe conversion functions
SELECT 
    TRY_CAST('2024-13-45' AS DATE) AS Safe_Conversion,      -- Returns NULL
    TRY_CONVERT(DATE, 'invalid date') AS Safe_Convert,      -- Returns NULL
    ISDATE('2024-02-29') AS Is_Valid_Date;                  -- Returns 1 (valid)

-- 6. Document date/time business rules clearly
-- Example: "All timestamps stored in UTC"
-- Example: "Business hours calculated in company timezone (PST)"
-- Example: "Age calculated as completed years on current date"
```

## Summary

### Key Takeaways for Date/Time Data

1. **Choose Modern Data Types**
   - Use DATETIME2 instead of DATETIME for new applications
   - Use DATE for date-only storage
   - Use TIME for time-only storage
   - Use DATETIMEOFFSET for timezone-aware applications

2. **Consider Precision and Storage**
   - Choose appropriate precision levels (0-7)
   - Don't over-specify precision
   - Consider storage implications for large tables

3. **Handle Time Zones Properly**
   - Store in UTC when possible
   - Use DATETIMEOFFSET for timezone awareness
   - Be consistent with timezone handling across application

4. **Write Efficient Queries**
   - Use SARGable date range conditions
   - Avoid functions on date columns in WHERE clauses
   - Index date columns appropriately

5. **Format and Convert Safely**
   - Use TRY_CAST/TRY_CONVERT for safe conversions
   - Use FORMAT function for flexible formatting
   - Consider cultural settings for parsing and formatting

6. **Business Logic Considerations**
   - Handle business days, holidays, and seasons appropriately
   - Consider leap years and edge cases
   - Document date/time business rules clearly

7. **Performance Optimization**
   - Use computed columns for frequently queried date parts
   - Consider partitioning large tables by date
   - Use appropriate indexes for date range queries

Understanding date and time data types and their proper usage is essential for building robust, performant applications that handle temporal data correctly across different time zones and business scenarios.
