# Module 8: Advanced Built-In Functions
**Primary Topic:** Module 8: Advanced Built-In Functions

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-7 completed  
**Target Audience:** Analysts polishing macroeconomic series for publication-quality outputs

---

## Learning Objectives
1. Combine nested string functions to standardize indicator metadata
2. Use fiscal and calendar date helpers to flag reporting lags
3. Apply mathematical helpers for chained growth and smoothing
4. Convert data types for downstream BI tools
5. Introduce NULL-handling functions to protect official calculations
6. Document validation notes with deterministic formatting rules

---

## BEGINNER SECTION (Required)

### Exercise 8.1: String Pipelines

**Task 1:** Clean indicator names for dashboards  
**Topic:** MS20761 Module 8 Lesson 1 – Stack string helpers for metadata maintenance  
**Beginner Explanation:** Analysts often need consistent short labels. This query trims whitespace, uppercases codes, and concatenates descriptions so BI users read the same format everywhere.

```sql
-- Standardize indicator codes for dashboard usage
SELECT 
    IndicatorID,
    UPPER(LTRIM(RTRIM(IndicatorCode))) AS CleanCode,
    CONCAT(LEFT(IndicatorName, 40), '…') AS ShortName,
    CONCAT('[' , UPPER(LEFT(IndicatorCode, 4)), '] ', IndicatorName) AS DisplayLabel,
    REPLACE(ISNULL(Description, 'No description provided'), '  ', ' ') AS CleanDescription
FROM EconomicIndicators
WHERE IsActive = 1
ORDER BY CleanCode;
```

**Detailed Query Explanation:** `LTRIM/RTRIM` remove trailing spaces before `UPPER` forces uniform casing. `LEFT` plus ellipsis keeps names short, while `ISNULL` ensures narrative text never shows NULL.
**Detailed Results Explanation:** Expect one formatted row per active indicator with cleaned code, shortened name, and a consistent display label for dashboards.

---

**Task 2:** Build reporting alias strings  
**Topic:** MS20761 Module 8 Lesson 1 – Combine multiple functions to produce audit-friendly keys  
**Beginner Explanation:** Create a consistent alias using bank name initials, city, and bank type so spreadsheets and SQL consumers reference the same identifier.

```sql
-- Generate human-friendly aliases for banks
SELECT 
    BankID,
    BankName,
    CONCAT(
        LEFT(REPLACE(BankName, ' ', ''), 4),
        '-',
        UPPER(ISNULL(City, 'MAS')),
        '-',
        LEFT(BankType, 3)
    ) AS BankAlias,
    LEN(BankName) AS NameLength,
    TRANSLATE(BankName, 'éèêë', 'eeee') AS NormalizedName
FROM CommercialBanks
WHERE IsActive = 1;
```

**Detailed Query Explanation:** `REPLACE` strips spaces before `LEFT` takes the first four characters, `ISNULL` plugs missing city codes, and `TRANSLATE` normalizes accented characters into ASCII.
**Detailed Results Explanation:** Output shows deterministic aliases and name lengths so analysts can reconcile banks between SQL and Excel extracts.

---

### Exercise 8.2: Date Calculations

**Task 3:** Flag stale data feeds  
**Topic:** MS20761 Module 8 Lesson 2 – Compare latest observation dates to today  
**Beginner Explanation:** This aggregation shows the most recent period captured per indicator and whether it violates freshness thresholds.

```sql
-- Check how current each indicator is
SELECT 
    ei.IndicatorCode,
    MAX(ts.PeriodDate) AS LatestPeriod,
    DATEDIFF(DAY, MAX(ts.PeriodDate), CAST(GETDATE() AS DATE)) AS DaysOld,
    CASE 
        WHEN DATEDIFF(DAY, MAX(ts.PeriodDate), CAST(GETDATE() AS DATE)) <= 30 THEN 'On schedule'
        WHEN DATEDIFF(DAY, MAX(ts.PeriodDate), CAST(GETDATE() AS DATE)) <= 90 THEN 'Needs follow-up'
        ELSE 'Escalate'
    END AS FreshnessFlag
FROM EconomicIndicators ei
JOIN TimeSeriesData ts ON ts.IndicatorID = ei.IndicatorID
GROUP BY ei.IndicatorCode
ORDER BY DaysOld DESC;
```

**Detailed Query Explanation:** `MAX` surfaces the most recent observation, and `DATEDIFF` against `GETDATE()` powers the `CASE` expression that produces governance labels.
**Detailed Results Explanation:** Each indicator shows how many days ago it was last updated and whether action is required.

---

**Task 4:** Derive fiscal quarters from dates  
**Topic:** MS20761 Module 8 Lesson 2 – Use DATEFROMPARTS, DATEADD, and DATENAME  
**Beginner Explanation:** Convert monthly reporting dates into fiscal-quarter end dates so economists can align to budgeting cycles.

```sql
-- Translate reporting months into fiscal quarter boundaries
SELECT 
    ReportingDate,
    DATEFROMPARTS(ReportingYear, ReportingMonth, 1) AS PeriodStart,
    EOMONTH(DATEFROMPARTS(ReportingYear, ReportingMonth, 1)) AS PeriodEnd,
    DATEPART(QUARTER, ReportingDate) AS CalendarQuarter,
    DATENAME(QUARTER, ReportingDate) AS QuarterLabel,
    DATEADD(MONTH, 3, ReportingDate) AS PlusOneQuarter
FROM BankingStatistics
WHERE ReportingYear = 2024;
```

**Detailed Query Explanation:** `DATEFROMPARTS` rebuilds the first day of the month, `EOMONTH` finds the last day, and `DATEADD` projects a comparison point one quarter ahead.
**Detailed Results Explanation:** Each row now carries start/end stamps and ready-made quarter labels for reporting templates.

---

### Exercise 8.3: Math & Conversion Helpers

**Task 5:** Calculate chained growth  
**Topic:** MS20761 Module 8 Lesson 3 – Layer math functions with NULL protection  
**Beginner Explanation:** Compute month-on-month and year-on-year growth for inflation while preventing divide-by-zero errors.

```sql
-- Inflation growth calculations with safeguards
SELECT 
    ts.PeriodDate,
    ts.DataValue AS CPI,
    LAG(ts.DataValue) OVER (ORDER BY ts.PeriodDate) AS PriorMonth,
    LAG(ts.DataValue, 12) OVER (ORDER BY ts.PeriodDate) AS PriorYear,
    ROUND(((ts.DataValue - LAG(ts.DataValue) OVER (ORDER BY ts.PeriodDate)) / NULLIF(LAG(ts.DataValue) OVER (ORDER BY ts.PeriodDate), 0)) * 100, 2) AS MoMGrowth,
    ROUND(((ts.DataValue - LAG(ts.DataValue, 12) OVER (ORDER BY ts.PeriodDate)) / NULLIF(LAG(ts.DataValue, 12) OVER (ORDER BY ts.PeriodDate), 0)) * 100, 2) AS YoYGrowth
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'CPI-ALL'
ORDER BY ts.PeriodDate DESC;
```

**Detailed Query Explanation:** `LAG` fetches prior periods, `NULLIF` shields against division by zero, and `ROUND` formats the growth rates in percentage terms.
**Detailed Results Explanation:** Output lists CPI values with calculated month-on-month and year-on-year growth, ready for bulletin footnotes.

---

**Task 6:** Cast metrics for presentation  
**Topic:** MS20761 Module 8 Lesson 3 – Demonstrate CAST/TRY_CONVERT with banking ratios  
**Beginner Explanation:** Format ratios and currency columns for charting tools that expect consistent decimal precision.

```sql
-- Convert numeric formats for BI tools
SELECT 
    cb.BankName,
    bs.ReportingDate,
    TRY_CONVERT(DECIMAL(18,2), bs.TotalAssets / 1000000.0) AS AssetsInMillions,
    FORMAT(bs.LiquidityRatio / 100.0, 'P2') AS LiquidityPercent,
    FORMAT(bs.CapitalAdequacyRatio / 100.0, 'P2') AS CapitalPercent
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingDate = '2024-09-30';
```

**Detailed Query Explanation:** `TRY_CONVERT` safeguards against conversion errors, while `FORMAT` expresses ratios as percentages with two decimal places.
**Detailed Results Explanation:** The query produces clean million-based asset values and human-readable percentage strings for dashboards.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 8.4: Nested NULL Handling

**Task 7:** Default missing reserve notes  
**Topic:** MS20761 Module 8 Lesson 3 – Use COALESCE with concatenation  
**Explanation:** Ensures analysts always see a contextual note even if manual commentary is absent.

```sql
SELECT 
    ts.PeriodDate,
    ts.DataValue,
    COALESCE(ts.Notes, CONCAT('Auto-note: Finalized on ', FORMAT(ts.ModifiedDate, 'yyyy-MM-dd'))) AS AuditNote
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES'
  AND ts.PeriodDate >= '2024-01-01';
```

**What to Look For:** Any NULL notes get an auto-generated explanation referencing the modified date.

---

## Testing Checklist
- [ ] Exercise 8.1 Task 1
- [ ] Exercise 8.1 Task 2
- [ ] Exercise 8.2 Task 3
- [ ] Exercise 8.2 Task 4
- [ ] Exercise 8.3 Task 5
- [ ] Exercise 8.3 Task 6
- [ ] Exercise 8.4 Task 7

Record pass/fail outcomes plus error messages in `sql_validation_report.md` after running in the `CBL_DataWarehouse` database.
