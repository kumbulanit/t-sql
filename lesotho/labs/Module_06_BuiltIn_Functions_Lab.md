# Module 6: Built-In Functions
## Central Bank of Lesotho - Data Management Division

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-5 completed

---

## Learning Objectives
1. Master string manipulation functions
2. Use date and time functions effectively
3. Apply mathematical and numeric functions
4. Perform data type conversions
5. Format data for reports and exports

---

## BEGINNER SECTION (Required)

### Exercise 6.1: String Functions

**Task 1:** Format indicator names for display
```sql
-- Clean and format indicator names
SELECT 
    IndicatorCode,
    IndicatorName,
    UPPER(IndicatorCode) AS 'Code Upper',
    LOWER(IndicatorName) AS 'Name Lower',
    LEN(IndicatorName) AS 'Name Length',
    LEFT(IndicatorCode, 3) AS 'Code Prefix',
    RIGHT(IndicatorCode, 4) AS 'Code Suffix'
FROM EconomicIndicators
WHERE IsActive = 1
ORDER BY IndicatorCode;
```

---

**Task 2:** Extract bank information
```sql
-- Parse bank details
SELECT 
    BankCode,
    BankName,
    SUBSTRING(BankCode, 1, 3) AS 'Bank Prefix',
    REVERSE(BankName) AS 'Reversed',
    REPLACE(Email, '@', ' [at] ') AS 'Masked Email',
    CONCAT(BankCode, ' - ', BankName) AS 'Full Description'
FROM CommercialBanks
WHERE IsActive = 1;
```

---

**Task 3:** Clean and standardize text data
```sql
-- Trim and clean indicator descriptions
SELECT 
    IndicatorCode,
    Description AS 'Original',
    LTRIM(RTRIM(Description)) AS 'Trimmed',
    REPLACE(Description, '  ', ' ') AS 'Single Spaces',
    UPPER(LEFT(Description, 1)) + LOWER(SUBSTRING(Description, 2, LEN(Description))) AS 'Proper Case'
FROM EconomicIndicators
WHERE Description IS NOT NULL;
```

---

### Exercise 6.2: Date Functions

**Task 4:** Extract date components
```sql
-- Break down reporting dates
SELECT 
    ReportingDate,
    YEAR(ReportingDate) AS 'Year',
    MONTH(ReportingDate) AS 'Month Number',
    DATENAME(MONTH, ReportingDate) AS 'Month Name',
    DATEPART(QUARTER, ReportingDate) AS 'Quarter',
    DAY(ReportingDate) AS 'Day',
    DATENAME(WEEKDAY, ReportingDate) AS 'Day of Week'
FROM BankingStatistics
ORDER BY ReportingDate;
```

---

**Task 5:** Calculate date differences
```sql
-- Measure reporting timeliness
SELECT 
    cb.BankName,
    bs.ReportingDate AS 'Quarter End',
    bs.SubmittedDate AS 'Submission Date',
    DATEDIFF(DAY, bs.ReportingDate, bs.SubmittedDate) AS 'Days After Quarter',
    DATEDIFF(WEEK, bs.ReportingDate, bs.SubmittedDate) AS 'Weeks After Quarter',
    CASE 
        WHEN DATEDIFF(DAY, bs.ReportingDate, bs.SubmittedDate) <= 30 THEN 'On Time'
        WHEN DATEDIFF(DAY, bs.ReportingDate, bs.SubmittedDate) <= 45 THEN 'Slightly Late'
        ELSE 'Late'
    END AS 'Timeliness Status'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
ORDER BY bs.ReportingDate, cb.BankName;
```

---

**Task 6:** Work with current date
```sql
-- Calculate data freshness
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    MAX(ts.PeriodDate) AS 'Latest Data',
    GETDATE() AS 'Today',
    DATEDIFF(DAY, MAX(ts.PeriodDate), GETDATE()) AS 'Days Old',
    CASE 
        WHEN DATEDIFF(DAY, MAX(ts.PeriodDate), GETDATE()) <= 7 THEN 'Current'
        WHEN DATEDIFF(DAY, MAX(ts.PeriodDate), GETDATE()) <= 30 THEN 'Recent'
        WHEN DATEDIFF(DAY, MAX(ts.PeriodDate), GETDATE()) <= 90 THEN 'Moderately Old'
        ELSE 'Stale'
    END AS 'Freshness'
FROM EconomicIndicators ei
INNER JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IsActive = 1
GROUP BY ei.IndicatorCode, ei.IndicatorName
ORDER BY MAX(ts.PeriodDate) DESC;
```

---

### Exercise 6.3: Mathematical Functions

**Task 7:** Round numeric values
```sql
-- Format financial data
SELECT 
    BankName,
    ReportingDate,
    TotalAssets AS 'Exact Assets',
    ROUND(TotalAssets, 0) AS 'Rounded',
    ROUND(TotalAssets, -3) AS 'Thousands',
    ROUND(TotalAssets, -6) AS 'Millions',
    CEILING(TotalAssets) AS 'Ceiling',
    FLOOR(TotalAssets) AS 'Floor'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30';
```

---

**Task 8:** Calculate percentages and ratios
```sql
-- Banking sector ratios
SELECT 
    cb.BankName,
    bs.ReportingDate,
    bs.TotalLoans,
    bs.TotalDeposits,
    bs.TotalAssets,
    ROUND((bs.TotalLoans / bs.TotalDeposits) * 100, 2) AS 'Loan-to-Deposit %',
    ROUND((bs.TotalLoans / bs.TotalAssets) * 100, 2) AS 'Loan-to-Asset %',
    ABS(bs.TotalLoans - bs.TotalDeposits) AS 'Loan-Deposit Gap',
    POWER((1 + bs.NPLRatio/100), 4) AS 'Annual NPL Impact'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30'
ORDER BY bs.TotalAssets DESC;
```

---

## INTERMEDIATE SECTION (Optional)

### Exercise 6.4: Advanced String Manipulation

**Task 9:** Build formatted report labels
```sql
-- Create publication-ready labels
SELECT 
    ei.IndicatorCode,
    CONCAT(
        UPPER(ic.CategoryName), 
        ' - ', 
        ei.IndicatorName,
        ' (', 
        df.FrequencyName,
        ')'
    ) AS 'Full Label',
    STUFF(ei.IndicatorCode, CHARINDEX('_', ei.IndicatorCode), 1, ' - ') AS 'Readable Code',
    STRING_AGG(ds.SourceCode, ', ') WITHIN GROUP (ORDER BY ds.SourceCode) AS 'Sources'
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
WHERE ei.IsActive = 1
GROUP BY ei.IndicatorCode, ei.IndicatorName, ic.CategoryName, df.FrequencyName
ORDER BY ic.CategoryName, ei.IndicatorCode;
```

---

**Task 10:** Search and pattern matching
```sql
-- Find indicators with specific patterns
SELECT 
    IndicatorCode,
    IndicatorName,
    Description,
    CHARINDEX('Rate', IndicatorName) AS 'Position of Rate',
    PATINDEX('%[0-9]%', Description) AS 'First Number Position',
    CASE 
        WHEN IndicatorName LIKE '%Rate%' THEN 'Rate Indicator'
        WHEN IndicatorName LIKE '%Total%' THEN 'Total/Sum Indicator'
        WHEN IndicatorName LIKE '%Ratio%' THEN 'Ratio Indicator'
        ELSE 'Other'
    END AS 'Indicator Type'
FROM EconomicIndicators
WHERE IsActive = 1;
```

---

### Exercise 6.5: Advanced Date Calculations

**Task 11:** Generate fiscal year dates
```sql
-- Calculate fiscal year (April-March for Lesotho)
SELECT 
    ts.PeriodDate AS 'Calendar Date',
    CASE 
        WHEN MONTH(ts.PeriodDate) >= 4 
        THEN CONCAT(YEAR(ts.PeriodDate), '/', YEAR(ts.PeriodDate) + 1)
        ELSE CONCAT(YEAR(ts.PeriodDate) - 1, '/', YEAR(ts.PeriodDate))
    END AS 'Fiscal Year',
    CASE 
        WHEN MONTH(ts.PeriodDate) IN (4, 5, 6) THEN 'Q1'
        WHEN MONTH(ts.PeriodDate) IN (7, 8, 9) THEN 'Q2'
        WHEN MONTH(ts.PeriodDate) IN (10, 11, 12) THEN 'Q3'
        ELSE 'Q4'
    END AS 'Fiscal Quarter',
    DATEADD(MONTH, 
        CASE 
            WHEN MONTH(ts.PeriodDate) >= 4 THEN MONTH(ts.PeriodDate) - 4
            ELSE MONTH(ts.PeriodDate) + 8
        END,
        DATEFROMPARTS(
            CASE WHEN MONTH(ts.PeriodDate) >= 4 
            THEN YEAR(ts.PeriodDate) 
            ELSE YEAR(ts.PeriodDate) - 1 END,
            4, 1
        )
    ) AS 'Fiscal Month Start'
FROM TimeSeriesData ts
WHERE ts.PeriodDate >= '2024-01-01'
GROUP BY ts.PeriodDate
ORDER BY ts.PeriodDate;
```

---

**Task 12:** Calculate month-end and period dates
```sql
-- Work with period boundaries
SELECT 
    ReportingDate,
    EOMONTH(ReportingDate) AS 'Month End',
    EOMONTH(ReportingDate, -1) AS 'Previous Month End',
    DATEADD(QUARTER, DATEDIFF(QUARTER, 0, ReportingDate), 0) AS 'Quarter Start',
    EOMONTH(DATEADD(MONTH, 2, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, ReportingDate), 0))) AS 'Quarter End',
    DATEFROMPARTS(YEAR(ReportingDate), 1, 1) AS 'Year Start',
    DATEFROMPARTS(YEAR(ReportingDate), 12, 31) AS 'Year End'
FROM BankingStatistics
GROUP BY ReportingDate
ORDER BY ReportingDate;
```

---

### Exercise 6.6: Data Type Conversions

**Task 13:** Convert and format data types
```sql
-- Format data for reports
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    -- Different format styles
    CAST(ts.DataValue AS VARCHAR(20)) AS 'Cast to String',
    CONVERT(VARCHAR(20), ts.DataValue, 1) AS 'Formatted Number',
    FORMAT(ts.DataValue, 'N2') AS 'Number Format',
    FORMAT(ts.DataValue, 'C2', 'en-LS') AS 'Currency Format',
    FORMAT(ts.DataValue, 'P2') AS 'Percentage Format',
    -- Date formatting
    CONVERT(VARCHAR, ts.PeriodDate, 103) AS 'DD/MM/YYYY',
    CONVERT(VARCHAR, ts.PeriodDate, 106) AS 'DD Mon YYYY',
    FORMAT(ts.PeriodDate, 'MMMM yyyy') AS 'Month Year',
    FORMAT(ts.PeriodDate, 'yyyy-MM') AS 'ISO Month'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode IN ('INF_RATE', 'FX_USD', 'GDP_REAL')
  AND ts.PeriodDate >= '2024-01-01'
ORDER BY ei.IndicatorCode, ts.PeriodDate;
```

---

### Exercise 6.7: NULL Handling Functions

**Task 14:** Handle missing data gracefully
```sql
-- Deal with NULLs in reports
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    ISNULL(ts.DataValue, 0) AS 'Default to Zero',
    COALESCE(ts.DataValue, ts.RevisedValue, 0) AS 'First Available',
    NULLIF(ts.DataValue, 0) AS 'NULL if Zero',
    CASE 
        WHEN ts.DataValue IS NULL THEN 'No Data'
        WHEN ts.IsProvisional = 1 THEN 'Provisional: ' + CAST(ts.DataValue AS VARCHAR)
        ELSE 'Final: ' + CAST(ts.DataValue AS VARCHAR)
    END AS 'Status Display'
FROM EconomicIndicators ei
LEFT JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID 
    AND ts.PeriodDate = '2024-09-01'
WHERE ei.IsActive = 1
ORDER BY ei.IndicatorCode;
```

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 6.8: Complex Date Calculations

**Task 15:** Year-over-year comparisons with date functions
```sql
-- Calculate YoY growth using date functions
WITH CurrentYear AS (
    SELECT 
        ei.IndicatorCode,
        MONTH(ts.PeriodDate) AS MonthNum,
        DATENAME(MONTH, ts.PeriodDate) AS MonthName,
        AVG(ts.DataValue) AS CurrentValue
    FROM TimeSeriesData ts
    INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
    WHERE YEAR(ts.PeriodDate) = 2024
      AND ei.IndicatorCode IN ('INF_RATE', 'GDP_REAL', 'FX_USD')
    GROUP BY ei.IndicatorCode, MONTH(ts.PeriodDate), DATENAME(MONTH, ts.PeriodDate)
),
PreviousYear AS (
    SELECT 
        ei.IndicatorCode,
        MONTH(ts.PeriodDate) AS MonthNum,
        AVG(ts.DataValue) AS PreviousValue
    FROM TimeSeriesData ts
    INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
    WHERE YEAR(ts.PeriodDate) = 2023
      AND ei.IndicatorCode IN ('INF_RATE', 'GDP_REAL', 'FX_USD')
    GROUP BY ei.IndicatorCode, MONTH(ts.PeriodDate)
)
SELECT 
    cy.IndicatorCode,
    cy.MonthName,
    ROUND(cy.CurrentValue, 2) AS '2024 Value',
    ROUND(py.PreviousValue, 2) AS '2023 Value',
    ROUND(cy.CurrentValue - py.PreviousValue, 2) AS 'Absolute Change',
    ROUND(((cy.CurrentValue - py.PreviousValue) / py.PreviousValue) * 100, 2) AS 'YoY Growth %',
    SIGN(cy.CurrentValue - py.PreviousValue) AS 'Direction'
FROM CurrentYear cy
LEFT JOIN PreviousYear py ON cy.IndicatorCode = py.IndicatorCode 
    AND cy.MonthNum = py.MonthNum
ORDER BY cy.IndicatorCode, cy.MonthNum;
```

---

### Exercise 6.9: Custom Formatting for Reports

**Task 16:** Create publication-ready formatted output
```sql
-- Monthly Statistical Bulletin formatted data
SELECT 
    FORMAT(ts.PeriodDate, 'MMMM yyyy') AS 'Reporting Period',
    UPPER(ei.IndicatorName) AS 'Indicator',
    -- Format based on unit of measure
    CASE ei.UnitOfMeasure
        WHEN 'Percentage' THEN FORMAT(ts.DataValue, 'N2') + '%'
        WHEN 'Millions' THEN 'M ' + FORMAT(ts.DataValue, 'N2')
        WHEN 'LSL' THEN 'LSL ' + FORMAT(ts.DataValue, 'N2')
        WHEN 'Rate' THEN FORMAT(ts.DataValue, 'N4')
        ELSE FORMAT(ts.DataValue, 'N2')
    END AS 'Formatted Value',
    -- Status badge
    CASE 
        WHEN ts.IsProvisional = 1 THEN '[P]'
        ELSE '[F]'
    END AS 'Status',
    -- Data quality indicator
    CASE 
        WHEN dq.QualityStatus = 'Validated' THEN '✓'
        WHEN dq.QualityStatus = 'Flagged' THEN '⚠'
        WHEN dq.QualityStatus = 'Error' THEN '✗'
        ELSE '?'
    END AS 'Quality',
    -- Source abbreviation
    LEFT(ds.SourceCode, 10) AS 'Source',
    -- Revision info
    CASE 
        WHEN ts.RevisedValue IS NOT NULL 
        THEN 'Rev: ' + FORMAT(ts.RevisionDate, 'dd-MMM')
        ELSE '-'
    END AS 'Revision'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
LEFT JOIN DataQualityChecks dq ON ts.TimeSeriesID = dq.TimeSeriesID
WHERE ts.PeriodDate >= DATEADD(MONTH, -3, GETDATE())
  AND ei.IsActive = 1
ORDER BY ts.PeriodDate DESC, ei.IndicatorCode;
```

---

### Exercise 6.10: Advanced String Aggregations

**Task 17:** Build comma-separated lists
```sql
-- Create summary with aggregated strings
SELECT 
    ic.CategoryName,
    COUNT(ei.IndicatorID) AS 'Indicator Count',
    STRING_AGG(ei.IndicatorCode, ', ') WITHIN GROUP (ORDER BY ei.IndicatorCode) AS 'Indicator Codes',
    STRING_AGG(
        CONCAT(ei.IndicatorCode, ' (', df.FrequencyName, ')'),
        '; '
    ) WITHIN GROUP (ORDER BY ei.IndicatorCode) AS 'Detailed List',
    STRING_AGG(
        CAST(ei.IndicatorID AS VARCHAR),
        ','
    ) AS 'Indicator IDs'
FROM IndicatorCategories ic
INNER JOIN EconomicIndicators ei ON ic.CategoryID = ei.CategoryID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
WHERE ei.IsActive = 1
GROUP BY ic.CategoryName
ORDER BY COUNT(ei.IndicatorID) DESC;
```

---

### Exercise 6.11: Complex Mathematical Calculations

**Task 18:** Calculate compound growth and statistical measures
```sql
-- Banking sector growth analysis with complex math
WITH BankGrowth AS (
    SELECT 
        cb.BankID,
        cb.BankName,
        MIN(bs.ReportingDate) AS FirstQuarter,
        MAX(bs.ReportingDate) AS LastQuarter,
        DATEDIFF(QUARTER, MIN(bs.ReportingDate), MAX(bs.ReportingDate)) AS Quarters,
        MIN(bs.TotalAssets) AS StartAssets,
        MAX(bs.TotalAssets) AS EndAssets
    FROM CommercialBanks cb
    INNER JOIN BankingStatistics bs ON cb.BankID = bs.BankID
    WHERE bs.ReportingDate >= '2024-01-01'
    GROUP BY cb.BankID, cb.BankName
)
SELECT 
    BankName,
    FORMAT(FirstQuarter, 'MMM yyyy') AS 'Start',
    FORMAT(LastQuarter, 'MMM yyyy') AS 'End',
    Quarters,
    FORMAT(StartAssets, 'N2') AS 'Initial Assets',
    FORMAT(EndAssets, 'N2') AS 'Final Assets',
    -- Simple growth
    FORMAT(EndAssets - StartAssets, 'N2') AS 'Absolute Growth',
    FORMAT(((EndAssets - StartAssets) / StartAssets) * 100, 'N2') + '%' AS 'Total Growth %',
    -- Compound quarterly growth rate (CQGR)
    FORMAT(
        (POWER((EndAssets / StartAssets), (1.0 / NULLIF(Quarters, 0))) - 1) * 100,
        'N2'
    ) + '%' AS 'Quarterly Growth Rate',
    -- Annualized growth
    FORMAT(
        (POWER((EndAssets / StartAssets), (4.0 / NULLIF(Quarters, 0))) - 1) * 100,
        'N2'
    ) + '%' AS 'Annualized Growth Rate'
FROM BankGrowth
WHERE Quarters > 0
ORDER BY EndAssets DESC;
```

---

## Practice Exercises (Do It Yourself)

### Beginner
1. Extract first 3 characters of indicator codes
2. Calculate days between today and last data update
3. Round all exchange rates to 2 decimal places
4. Convert all bank names to uppercase

### Intermediate
5. Format phone numbers as (XXX) XXX-XXXX
6. Calculate business days between submission deadlines
7. Create fiscal year labels for all time series data
8. Build formatted email list for all banks

### Advanced
9. Calculate moving averages using date functions
10. Create pivot-style output using STRING_AGG
11. Build comprehensive data quality score with multiple functions
12. Generate formatted executive summary report

---

## Real-World Scenarios

### Scenario 1: Monthly Bulletin Publication
Format all economic indicators for the Monthly Statistical Bulletin. Include proper number formatting, date displays (Month YYYY), status indicators (Provisional/Final), and source citations. Use FORMAT, CONVERT, and CONCAT functions.

### Scenario 2: Banking Supervision Alert System
Create an alert system that identifies banks with declining performance. Calculate quarter-over-quarter changes, format percentage declines with color codes (text-based), and generate human-readable messages using string functions.

### Scenario 3: IMF Data Package
Prepare a formatted dataset for IMF submission. Convert all dates to ISO format (YYYY-MM-DD), standardize number formats (2 decimal places), create indicator descriptions with units, and generate metadata fields using string concatenation.

---

## Key Takeaways

✅ **String Functions:**
- UPPER/LOWER: Change case
- LEN: String length
- SUBSTRING: Extract portion
- CONCAT: Combine strings
- REPLACE: Substitute text
- STRING_AGG: Aggregate to comma-separated list

✅ **Date Functions:**
- GETDATE: Current date/time
- DATEPART: Extract component
- DATEDIFF: Calculate difference
- DATEADD: Add intervals
- EOMONTH: Month end date
- FORMAT: Custom date display

✅ **Math Functions:**
- ROUND: Round numbers
- CEILING/FLOOR: Round up/down
- ABS: Absolute value
- POWER: Exponentiation
- SIGN: Positive/negative indicator

✅ **Conversion:**
- CAST: Simple conversion
- CONVERT: With formatting
- FORMAT: Advanced formatting
- ISNULL/COALESCE: Handle NULLs

---

## Next Steps

Proceed to **Module 7: DML - Data Modification**

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 6*
