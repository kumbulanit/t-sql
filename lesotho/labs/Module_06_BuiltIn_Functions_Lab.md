# Module 6: Built-In Functions
**Primary Topic:** Module 6: Built-In Functions

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-5 completed  
**Target Audience:** Economists and Statisticians formatting data for publication and analysis

---

## Learning Objectives
1. Master string manipulation for creating variable labels and metadata
2. Use date and time functions for temporal analysis and fiscal year calculations
3. Apply mathematical functions for index numbers, ratios, and growth rate calculations
4. Perform data type conversions for econometric software compatibility
5. Format statistical tables for publication in economic bulletins and policy briefs
6. Generate standardized outputs compliant with international statistical standards (IMF SDDS)

---

## BEGINNER SECTION (Required)

### Exercise 6.1: String Functions

**Task 1:** Format indicator names for display
**Topic:** MS20761 Module 8 Lesson 1 – Explore string casing and slicing functions on indicator metadata
**Beginner Explanation:** This query shows how functions like `UPPER`, `LOWER`, `LEFT`, and `RIGHT` reformat indicator codes and names while keeping the original columns for comparison.

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

**Detailed Query Explanation:** Each selected function acts on the base columns without altering data, demonstrating uppercase/lowercase conversions, string length calculation, and extracting prefixes/suffixes.
**Detailed Results Explanation:** The output lists one row per active indicator with multiple formatted versions, helping beginners see exactly how each string function transforms the text.

---

**Task 2:** Extract bank information
**Topic:** MS20761 Module 8 Lesson 1 – Demonstrate substring, reverse, replace, and concat on bank data
**Beginner Explanation:** This example slices bank codes, reverses names, masks emails, and builds a combined description so you can see common string utilities in action.

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

**Detailed Query Explanation:** `SUBSTRING` pulls the prefix, `REVERSE` showcases string flipping, `REPLACE` masks the email’s @ symbol, and `CONCAT` builds a readable label, all sourced from active banks.
**Detailed Results Explanation:** Expect enriched rows that provide both raw and formatted bank information—useful for data cleaning and report-ready presentations.

---

**Task 3:** Clean and standardize text data
**Topic:** MS20761 Module 8 Lesson 1 – Trim whitespace and normalize description casing
**Beginner Explanation:** This query shows how to remove leading/trailing spaces, collapse double spaces, and create proper-case sentences for indicator descriptions.

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

**Detailed Query Explanation:** `LTRIM/RTRIM` eliminate outside whitespace, `REPLACE` swaps double spaces, and the combined `UPPER`/`LOWER` logic capitalizes only the first letter while lowering the rest.
**Detailed Results Explanation:** Each row contrasts the original description with cleaned versions, helping you choose the right formatting for publications.

---

### Exercise 6.2: Date Functions

**Task 4:** Extract date components
**Topic:** MS20761 Module 8 Lesson 2 – Break reporting dates into useful pieces
**Beginner Explanation:** This sample shows how to pull the year, month, quarter, day, and weekday name from each reporting date so you can build calendar dimensions.

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

**Detailed Query Explanation:** Date functions such as `YEAR`, `MONTH`, `DATENAME`, and `DATEPART` read from the same column to expose multiple calendar perspectives without additional joins.
**Detailed Results Explanation:** Each row appends calendar metadata to the raw reporting date, enabling easier grouping or formatting in downstream analyses.

---

**Task 5:** Calculate date differences
**Topic:** MS20761 Module 8 Lesson 2 – Measure how long banks take to submit reports after quarter-end
**Beginner Explanation:** This query uses `DATEDIFF` to express lag in days and weeks, then categorizes timeliness to quickly judge each submission.

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

**Detailed Query Explanation:** Two `DATEDIFF` calls create numeric measures, and a `CASE` expression bins them into status labels while ordering keeps reports grouped chronologically per bank.
**Detailed Results Explanation:** Each row reveals whether a bank was on time, slightly late, or late for each quarter, supporting supervisory follow-up.

---

**Task 6:** Work with current date
**Topic:** MS20761 Module 8 Lesson 2 – Compare latest data dates to today to assess freshness
**Beginner Explanation:** Aggregating each indicator’s most recent observation and comparing it to `GETDATE()` tells you how stale or current the series is.

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

**Detailed Query Explanation:** `MAX(ts.PeriodDate)` surfaces the latest record per indicator, and `DATEDIFF` against the current date powers the `CASE` label describing freshness tiers.
**Detailed Results Explanation:** Each row highlights whether a series is current, recent, moderately old, or stale—useful for maintenance queues and publication readiness.

---

### Exercise 6.3: Mathematical Functions

**Task 7:** Round numeric values
**Topic:** MS20761 Module 8 Lesson 3 – Practice rounding, ceiling, and floor functions on financial data
**Beginner Explanation:** This example displays raw totals alongside rounded versions to the nearest unit, thousand, or million, plus forced up/down values.

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

**Detailed Query Explanation:** Multiple `ROUND` calls with different precision arguments show scaling, while `CEILING` and `FLOOR` demonstrate directional rounding for each bank’s figures.
**Detailed Results Explanation:** Analysts can immediately see how amounts will appear in various publications (exact vs thousands vs millions) without altering stored data.

---

**Task 8:** Calculate percentages and ratios
**Topic:** MS20761 Module 8 Lesson 3 – Derive common banking ratios with math functions
**Beginner Explanation:** This calculation adds loan-to-deposit and loan-to-asset percentages, gap sizes, and a compounded NPL impact metric for each bank’s September 2024 report.

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

**Detailed Query Explanation:** Straightforward arithmetic combined with `ROUND`, `ABS`, and `POWER` transforms raw totals into interpretable ratios, sorted by bank size.
**Detailed Results Explanation:** The output gives decision-makers ready-to-use KPI columns per bank, showing leverage, asset deployment, and modeled NPL effect.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 6.4: Advanced String Manipulation

**Task 9:** Build formatted report labels
**Topic:** MS20761 Module 8 Lesson 1 – Combine multiple fields into publication-ready labels
**Beginner Explanation:** This query demonstrates `CONCAT`, `STUFF`, and `STRING_AGG` to produce clean indicator labels and source lists for active indicators.

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

**Detailed Query Explanation:** `CONCAT` stitches together category, name, and frequency; `STUFF` inserts a separator into the code; and `STRING_AGG` collects multiple source codes ordered alphabetically.
**Detailed Results Explanation:** The resulting rows supply all the descriptive strings needed to populate headers or metadata tables without manual editing.

---

**Task 10:** Search and pattern matching
**Topic:** MS20761 Module 8 Lesson 1 – Use pattern functions to classify indicators
**Beginner Explanation:** The query finds the position of key words or digits and assigns a simple type label based on whether the name contains Rate, Total, or Ratio.

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

**Detailed Query Explanation:** `CHARINDEX` and `PATINDEX` locate substrings or digits, while the `CASE` block inspects the name with `LIKE` to categorize each indicator.
**Detailed Results Explanation:** You’ll get a quick scan of which indicators mention specific terms and where numbers first appear in descriptions, aiding metadata tagging.

---

### Exercise 6.5: Advanced Date Calculations

**Task 11:** Generate fiscal year dates
**Topic:** MS20761 Module 8 Lesson 2 – Translate calendar dates into Lesotho’s fiscal calendar
**Beginner Explanation:** This query maps each observation date to the correct fiscal year, quarter, and fiscal month start using conditional logic and `DATEADD`.

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

**Detailed Query Explanation:** Two `CASE` expressions derive fiscal year and quarter based on month, and the final `DATEADD`/`DATEFROMPARTS` block constructs the first day of the fiscal month for alignment.
**Detailed Results Explanation:** Each row now includes fiscal calendar metadata, enabling easy grouping of data into government reporting cycles.

---

**Task 12:** Calculate month-end and period dates
**Topic:** MS20761 Module 8 Lesson 2 – Derive key period boundaries for each reporting date
**Beginner Explanation:** This example uses functions like `EOMONTH`, `DATEADD`, and `DATEFROMPARTS` to find month ends, quarter starts/ends, and year bounds in one pass.

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

**Detailed Query Explanation:** By referencing the same `ReportingDate`, the query computes aligned boundaries using pairs of `DATEADD`/`DATEDIFF` operations, ensuring consistent period calculations.
**Detailed Results Explanation:** Each row outputs a mini calendar reference, making it simple to tie KPIs to the correct fiscal month, quarter, or year markers.

---

### Exercise 6.6: Data Type Conversions

**Task 13:** Convert and format data types
**Topic:** MS20761 Module 6 Lesson 2 – Showcase CAST, CONVERT, and FORMAT for numbers and dates
**Beginner Explanation:** This query outputs multiple formatted versions of the same values so you can see how each function affects presentation for reports.

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

**Detailed Query Explanation:** Numeric values are cast to strings, formatted with pattern codes, and even shown as currency or percentages, while dates are converted into common publication-friendly layouts.
**Detailed Results Explanation:** Each row becomes a reference table demonstrating exactly how the same underlying data appears under different formatting strategies.

---

### Exercise 6.7: NULL Handling Functions

**Task 14:** Handle missing data gracefully
**Topic:** MS20761 Module 8 Lesson 3 – Demonstrate ISNULL, COALESCE, NULLIF, and CASE for data quality messaging
**Beginner Explanation:** This query shows how to supply default values, prioritize replacements, turn zeros into NULLs, and build status strings for time series data.

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

**Detailed Query Explanation:** `ISNULL` replaces missing data with zero, `COALESCE` falls back to revised values, `NULLIF` converts zero to NULL, and the `CASE` statement builds a human-friendly status message.
**Detailed Results Explanation:** The table makes it obvious which indicators lack data, which values are provisional, and what substitutes get displayed, supporting report automation.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 6.8: Complex Date Calculations

**Task 15:** Year-over-year comparisons with date functions
**Topic:** MS20761 Module 8 Lesson 2 & Module 13 Lesson 2 – Compare monthly averages between two years using date logic
**Beginner Explanation:** The paired CTEs compute monthly averages for 2024 and 2023, then align them by indicator and month to derive YoY changes.

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

**Detailed Query Explanation:** Each CTE groups by indicator and month number, ensuring comparable granularity. The final join merges current and previous year values, enabling arithmetic for absolute and percentage change along with direction via `SIGN`.
**Detailed Results Explanation:** Output rows list monthly YoY comparisons per indicator, providing quick insight into acceleration or deceleration patterns.

---

### Exercise 6.9: Custom Formatting for Reports

**Task 16:** Create publication-ready formatted output
**Topic:** MS20761 Module 8 Lesson 1 – Apply conditional formatting, badges, and source info for bulletin tables
**Beginner Explanation:** This query shows how to format values based on units, append status icons, include data quality symbols, and display revision notes for recent months.

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

**Detailed Query Explanation:** Nested `CASE` expressions tailor number formats and metadata columns, while joins to data quality and source tables bring in extra context for each observation.
**Detailed Results Explanation:** The result set mirrors a polished bulletin table row-by-row, complete with visual cues for provisional data, validation status, sources, and revisions.

---

### Exercise 6.10: Advanced String Aggregations

**Task 17:** Build comma-separated lists
**Topic:** MS20761 Module 8 Lesson 1 – Use STRING_AGG to summarize indicators per category
**Beginner Explanation:** This aggregation counts indicators in each category and builds comma/semicolon-separated lists that include codes and frequencies.

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

**Detailed Query Explanation:** `STRING_AGG` combines codes in configurable formats while the `COUNT` shows how many entries feed each list; ordering by count surfaces the most populated categories first.
**Detailed Results Explanation:** Each row becomes a ready-made summary statement describing category coverage plus detailed code listings for documentation.

---

### Exercise 6.11: Complex Mathematical Calculations

**Task 18:** Calculate compound growth and statistical measures
**Topic:** MS20761 Module 8 Lesson 3 & Module 13 Lesson 2 – Combine windowed aggregates with math functions for growth analysis
**Beginner Explanation:** The CTE gathers first/last quarters and asset levels per bank, then the main query computes absolute, total, and compound growth rates with formatted outputs.

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

**Detailed Query Explanation:** The CTE ensures each bank has a single summary row with start/end metrics. The main select applies formatting plus arithmetic and `POWER`-based formulas to express different growth perspectives, guarding divisions with `NULLIF`.
**Detailed Results Explanation:** Each bank’s row reads like a mini growth report, showing time span, asset change, and comparable compounded rates—ideal for supervisory dashboards.

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
