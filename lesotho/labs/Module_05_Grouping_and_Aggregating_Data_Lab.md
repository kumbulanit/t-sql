# Module 5: Grouping and Aggregating Data
## Central Bank of Lesotho - Data Management Division

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-4 completed

---

## Learning Objectives
1. Master GROUP BY clause for data summarization
2. Use aggregate functions (COUNT, SUM, AVG, MIN, MAX)
3. Apply HAVING clause for filtered aggregates
4. Calculate statistical measures for reporting
5. Generate summary reports for management

---

## BEGINNER SECTION (Required)

### Exercise 5.1: Basic Aggregations

**Task 1:** Count indicators by category
```sql
-- How many indicators in each category?
SELECT 
    ic.CategoryName,
    COUNT(ei.IndicatorID) AS 'Total Indicators',
    COUNT(CASE WHEN ei.IsActive = 1 THEN 1 END) AS 'Active Indicators',
    COUNT(CASE WHEN ei.IsActive = 0 THEN 1 END) AS 'Inactive Indicators'
FROM IndicatorCategories ic
LEFT JOIN EconomicIndicators ei ON ic.CategoryID = ei.CategoryID
GROUP BY ic.CategoryName
ORDER BY COUNT(ei.IndicatorID) DESC;
```

---

**Task 2:** Banking sector totals
```sql
-- Latest aggregate statistics for banking sector
SELECT 
    bs.ReportingDate,
    COUNT(DISTINCT bs.BankID) AS 'Banks Reporting',
    SUM(bs.TotalAssets) AS 'Sector Total Assets',
    SUM(bs.TotalLoans) AS 'Sector Total Loans',
    SUM(bs.TotalDeposits) AS 'Sector Total Deposits',
    ROUND(AVG(bs.NPLRatio), 2) AS 'Average NPL Ratio %'
FROM BankingStatistics bs
WHERE bs.ReportingDate = '2024-09-30'
GROUP BY bs.ReportingDate;
```

---

**Task 3:** Data frequency distribution
```sql
-- Count indicators by frequency
SELECT 
    df.FrequencyName,
    COUNT(ei.IndicatorID) AS 'Indicator Count',
    ROUND(
        (CAST(COUNT(ei.IndicatorID) AS FLOAT) / 
         (SELECT COUNT(*) FROM EconomicIndicators)) * 100, 
        2
    ) AS 'Percentage %'
FROM DataFrequencies df
LEFT JOIN EconomicIndicators ei ON df.FrequencyID = ei.FrequencyID
GROUP BY df.FrequencyName, df.SortOrder
ORDER BY df.SortOrder;
```

---

### Exercise 5.2: MIN and MAX Functions

**Task 4:** Find range of inflation rates
```sql
-- Inflation statistics for 2024
SELECT 
    MIN(ts.DataValue) AS 'Minimum Inflation %',
    MAX(ts.DataValue) AS 'Maximum Inflation %',
    AVG(ts.DataValue) AS 'Average Inflation %',
    MAX(ts.DataValue) - MIN(ts.DataValue) AS 'Range',
    COUNT(*) AS 'Observations'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode = 'INF_RATE'
  AND YEAR(ts.PeriodDate) = 2024;
```

---

**Task 5:** Exchange rate ranges by currency
```sql
-- FX rate statistics by currency
SELECT 
    ei.IndicatorName AS 'Currency',
    MIN(ts.DataValue) AS 'Min Rate',
    MAX(ts.DataValue) AS 'Max Rate',
    AVG(ts.DataValue) AS 'Avg Rate',
    COUNT(*) AS 'Trading Days'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode IN ('FX_USD', 'FX_ZAR', 'FX_EUR')
  AND YEAR(ts.PeriodDate) = 2024
GROUP BY ei.IndicatorName;
```

---

### Exercise 5.3: GROUP BY with Multiple Columns

**Task 6:** Data submissions by source and month
```sql
-- Track data collection by source over time
SELECT 
    ds.SourceName,
    FORMAT(ts.PeriodDate, 'yyyy-MM') AS 'Month',
    COUNT(ts.TimeSeriesID) AS 'Data Points',
    COUNT(DISTINCT ts.IndicatorID) AS 'Unique Indicators',
    COUNT(CASE WHEN ts.IsProvisional = 1 THEN 1 END) AS 'Provisional',
    COUNT(CASE WHEN ts.IsProvisional = 0 THEN 1 END) AS 'Final'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
WHERE YEAR(ts.PeriodDate) = 2024
GROUP BY ds.SourceName, FORMAT(ts.PeriodDate, 'yyyy-MM')
ORDER BY ds.SourceName, FORMAT(ts.PeriodDate, 'yyyy-MM');
```

---

## INTERMEDIATE SECTION (Optional)

### Exercise 5.4: HAVING Clause

**Task 7:** Find categories with many indicators
```sql
-- Categories with more than 2 indicators
SELECT 
    ic.CategoryName,
    COUNT(ei.IndicatorID) AS 'Indicator Count',
    STRING_AGG(ei.IndicatorCode, ', ') AS 'Indicator Codes'
FROM IndicatorCategories ic
INNER JOIN EconomicIndicators ei ON ic.CategoryID = ei.CategoryID
GROUP BY ic.CategoryName
HAVING COUNT(ei.IndicatorID) > 2
ORDER BY COUNT(ei.IndicatorID) DESC;
```

---

**Task 8:** Banks with high NPL ratios
```sql
-- Banks with average NPL above sector average
WITH SectorAvg AS (
    SELECT AVG(NPLRatio) AS AvgNPL
    FROM BankingStatistics
    WHERE ReportingDate IN ('2024-03-31', '2024-06-30', '2024-09-30')
)
SELECT 
    cb.BankName,
    COUNT(bs.StatisticID) AS 'Reports Submitted',
    AVG(bs.NPLRatio) AS 'Average NPL %',
    (SELECT AvgNPL FROM SectorAvg) AS 'Sector Avg NPL %',
    AVG(bs.NPLRatio) - (SELECT AvgNPL FROM SectorAvg) AS 'Difference'
FROM CommercialBanks cb
INNER JOIN BankingStatistics bs ON cb.BankID = bs.BankID
WHERE bs.ReportingDate IN ('2024-03-31', '2024-06-30', '2024-09-30')
GROUP BY cb.BankName
HAVING AVG(bs.NPLRatio) > (SELECT AvgNPL FROM SectorAvg)
ORDER BY AVG(bs.NPLRatio) DESC;
```

---

### Exercise 5.5: Statistical Calculations

**Task 9:** Calculate GDP growth statistics
```sql
-- Quarterly GDP summary with growth rates
SELECT 
    DATEPART(QUARTER, ts.PeriodDate) AS 'Quarter',
    DATEPART(YEAR, ts.PeriodDate) AS 'Year',
    AVG(ts.DataValue) AS 'Avg GDP (Millions)',
    MIN(ts.DataValue) AS 'Min GDP',
    MAX(ts.DataValue) AS 'Max GDP',
    STDEV(ts.DataValue) AS 'Std Deviation',
    COUNT(*) AS 'Observations'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode = 'GDP_REAL'
  AND ts.PeriodDate >= '2023-01-01'
GROUP BY DATEPART(QUARTER, ts.PeriodDate), DATEPART(YEAR, ts.PeriodDate)
ORDER BY DATEPART(YEAR, ts.PeriodDate), DATEPART(QUARTER, ts.PeriodDate);
```

---

### Exercise 5.6: Multi-Level Grouping

**Task 10:** Banking sector breakdown by quarter and bank
```sql
-- Detailed banking sector analysis
SELECT 
    CONCAT('Q', DATEPART(QUARTER, bs.ReportingDate), ' ', YEAR(bs.ReportingDate)) AS 'Quarter',
    cb.BankType,
    COUNT(DISTINCT cb.BankID) AS 'Number of Banks',
    SUM(bs.TotalAssets) AS 'Total Assets',
    SUM(bs.TotalLoans) AS 'Total Loans',
    SUM(bs.TotalDeposits) AS 'Total Deposits',
    ROUND(AVG(bs.NPLRatio), 2) AS 'Avg NPL %',
    ROUND((SUM(bs.TotalLoans) / SUM(bs.TotalAssets)) * 100, 2) AS 'Loan-to-Asset %'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate >= '2024-01-01'
GROUP BY 
    DATEPART(QUARTER, bs.ReportingDate), 
    YEAR(bs.ReportingDate),
    cb.BankType
ORDER BY 
    YEAR(bs.ReportingDate), 
    DATEPART(QUARTER, bs.ReportingDate),
    cb.BankType;
```

---

### Exercise 5.7: Aggregates with Filtering

**Task 11:** Monthly inflation above target
```sql
-- Count months where inflation exceeds 5% target
SELECT 
    YEAR(ts.PeriodDate) AS 'Year',
    COUNT(*) AS 'Total Months',
    COUNT(CASE WHEN ts.DataValue > 5.0 THEN 1 END) AS 'Months Above Target',
    COUNT(CASE WHEN ts.DataValue <= 5.0 THEN 1 END) AS 'Months Within Target',
    AVG(ts.DataValue) AS 'Average Inflation %',
    MAX(ts.DataValue) AS 'Peak Inflation %'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode = 'INF_RATE'
  AND ts.PeriodDate >= '2023-01-01'
GROUP BY YEAR(ts.PeriodDate)
ORDER BY YEAR(ts.PeriodDate);
```

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 5.8: Complex Summary Report

**Task 12:** Comprehensive economic dashboard
```sql
-- Executive summary by indicator category
SELECT 
    ic.CategoryName AS 'Category',
    COUNT(DISTINCT ei.IndicatorID) AS 'Indicators',
    COUNT(DISTINCT ts.TimeSeriesID) AS 'Data Points',
    MIN(ts.PeriodDate) AS 'Earliest Data',
    MAX(ts.PeriodDate) AS 'Latest Data',
    DATEDIFF(DAY, MIN(ts.PeriodDate), MAX(ts.PeriodDate)) AS 'Days Coverage',
    AVG(CASE WHEN ts.IsProvisional = 0 THEN 1.0 ELSE 0.0 END) * 100 AS 'Final Data %',
    COUNT(DISTINCT ds.DataSourceID) AS 'Data Sources'
FROM IndicatorCategories ic
INNER JOIN EconomicIndicators ei ON ic.CategoryID = ei.CategoryID
LEFT JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID
LEFT JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
WHERE ts.PeriodDate >= '2024-01-01'
GROUP BY ic.CategoryName
ORDER BY COUNT(DISTINCT ts.TimeSeriesID) DESC;
```

---

### Exercise 5.9: Banking Sector Trends

**Task 13:** Quarterly banking trends with growth rates
```sql
-- Banking sector performance tracking
WITH QuarterlySummary AS (
    SELECT 
        bs.ReportingDate,
        COUNT(DISTINCT bs.BankID) AS BankCount,
        SUM(bs.TotalAssets) AS TotalAssets,
        SUM(bs.TotalLoans) AS TotalLoans,
        SUM(bs.TotalDeposits) AS TotalDeposits,
        AVG(bs.NPLRatio) AS AvgNPL
    FROM BankingStatistics bs
    GROUP BY bs.ReportingDate
)
SELECT 
    FORMAT(current.ReportingDate, 'Q') + 
    CAST(DATEPART(QUARTER, current.ReportingDate) AS VARCHAR) + 
    ' ' + CAST(YEAR(current.ReportingDate) AS VARCHAR) AS 'Quarter',
    current.BankCount AS 'Banks',
    current.TotalAssets AS 'Total Assets',
    current.TotalLoans AS 'Total Loans',
    current.TotalDeposits AS 'Total Deposits',
    ROUND(current.AvgNPL, 2) AS 'Avg NPL %',
    -- Quarter-over-quarter growth
    CASE 
        WHEN previous.TotalAssets IS NOT NULL 
        THEN ROUND(((current.TotalAssets - previous.TotalAssets) / previous.TotalAssets) * 100, 2)
        ELSE NULL
    END AS 'Asset Growth %',
    CASE 
        WHEN previous.TotalLoans IS NOT NULL 
        THEN ROUND(((current.TotalLoans - previous.TotalLoans) / previous.TotalLoans) * 100, 2)
        ELSE NULL
    END AS 'Loan Growth %'
FROM QuarterlySummary current
LEFT JOIN QuarterlySummary previous ON 
    previous.ReportingDate = DATEADD(QUARTER, -1, current.ReportingDate)
ORDER BY current.ReportingDate;
```

---

### Exercise 5.10: Data Quality Metrics

**Task 14:** Calculate data completeness scores
```sql
-- Data quality scorecard by indicator
WITH ExpectedCounts AS (
    SELECT 
        ei.IndicatorID,
        ei.IndicatorCode,
        ei.IndicatorName,
        df.FrequencyName,
        CASE df.FrequencyName
            WHEN 'Daily' THEN 365
            WHEN 'Monthly' THEN 12
            WHEN 'Quarterly' THEN 4
            WHEN 'Annual' THEN 1
        END AS ExpectedAnnualObservations
    FROM EconomicIndicators ei
    INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
    WHERE ei.IsActive = 1
),
ActualCounts AS (
    SELECT 
        ts.IndicatorID,
        COUNT(*) AS ActualObservations,
        COUNT(CASE WHEN ts.IsProvisional = 0 THEN 1 END) AS FinalObservations,
        AVG(DATEDIFF(DAY, ts.PeriodDate, ts.EntryDate)) AS AvgReportingLag
    FROM TimeSeriesData ts
    WHERE YEAR(ts.PeriodDate) = 2024
    GROUP BY ts.IndicatorID
)
SELECT 
    ec.IndicatorCode,
    ec.IndicatorName,
    ec.FrequencyName,
    ec.ExpectedAnnualObservations AS 'Expected 2024',
    ISNULL(ac.ActualObservations, 0) AS 'Actual 2024',
    ISNULL(ac.FinalObservations, 0) AS 'Final Data',
    ROUND(
        (CAST(ISNULL(ac.ActualObservations, 0) AS FLOAT) / ec.ExpectedAnnualObservations) * 100,
        2
    ) AS 'Completeness %',
    ROUND(
        (CAST(ISNULL(ac.FinalObservations, 0) AS FLOAT) / ISNULL(ac.ActualObservations, 1)) * 100,
        2
    ) AS 'Finalized %',
    ROUND(ISNULL(ac.AvgReportingLag, 0), 1) AS 'Avg Lag Days'
FROM ExpectedCounts ec
LEFT JOIN ActualCounts ac ON ec.IndicatorID = ac.IndicatorID
ORDER BY 'Completeness %' DESC;
```

---

### Exercise 5.11: Report Generation Summary

**Task 15:** Monthly Statistical Bulletin metrics
```sql
-- Generate summary for monthly bulletin publication
SELECT 
    FORMAT(ts.PeriodDate, 'MMMM yyyy') AS 'Reporting Month',
    COUNT(DISTINCT ei.IndicatorID) AS 'Indicators Included',
    COUNT(DISTINCT ic.CategoryID) AS 'Categories Covered',
    COUNT(DISTINCT ds.DataSourceID) AS 'Data Sources',
    COUNT(ts.TimeSeriesID) AS 'Total Data Points',
    COUNT(CASE WHEN ts.IsProvisional = 1 THEN 1 END) AS 'Provisional',
    COUNT(CASE WHEN ts.IsProvisional = 0 THEN 1 END) AS 'Final',
    AVG(DATEDIFF(DAY, ts.PeriodDate, ts.EntryDate)) AS 'Avg Collection Lag',
    MAX(ts.EntryDate) AS 'Last Update Date'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
WHERE YEAR(ts.PeriodDate) = 2024
  AND ei.IsActive = 1
GROUP BY FORMAT(ts.PeriodDate, 'MMMM yyyy'), YEAR(ts.PeriodDate), MONTH(ts.PeriodDate)
HAVING COUNT(ts.TimeSeriesID) > 10
ORDER BY YEAR(ts.PeriodDate), MONTH(ts.PeriodDate);
```

---

## Practice Exercises (Do It Yourself)

### Beginner
1. Count reports by type
2. Calculate average foreign reserves for 2024
3. Find total number of data quality checks by status
4. Sum all commercial bank deposits by quarter

### Intermediate
5. Calculate average exchange rates by month with standard deviation
6. Find data sources with more than 5 indicators
7. Identify indicators with less than 80% data completeness
8. Calculate money supply growth rates (M1, M2) year-over-year

### Advanced
9. Create comprehensive banking sector dashboard with ratios
10. Build data collection performance scorecard by source
11. Generate quarterly economic bulletin summary statistics
12. Calculate correlation between inflation and exchange rates

---

## Real-World Scenarios

### Scenario 1: Governor's Monthly Brief
The Governor needs a one-page summary showing: total banking sector assets, average inflation, foreign reserves level, and key economic indicators. Create an aggregate query that provides all these metrics for the current month.

### Scenario 2: IMF Reporting Package
Prepare aggregated statistics for IMF reporting: quarterly GDP, annual inflation averages, banking sector concentration ratios, and external sector balances. Use GROUP BY and HAVING to filter significant indicators.

### Scenario 3: Data Quality Dashboard
The Data Management Division manager needs a weekly dashboard showing: data completeness by source, timeliness metrics (average lag), provisional vs final data ratios, and missing data alerts. Build aggregated queries for this dashboard.

---

## Key Takeaways

✅ **GROUP BY:**
- Groups rows with same values
- Must include all non-aggregated columns
- Creates summary rows

✅ **Aggregate Functions:**
- COUNT: Count rows/non-null values
- SUM: Total of numeric values
- AVG: Mean/average
- MIN/MAX: Smallest/largest values
- STDEV: Standard deviation

✅ **HAVING:**
- Filters grouped results
- Uses aggregate functions
- Applied after GROUP BY
- Different from WHERE (filters before grouping)

✅ **Best Practices:**
- Use meaningful aliases
- Include all non-aggregated columns in GROUP BY
- HAVING for aggregate conditions
- WHERE for row-level filtering

---

## Next Steps

Proceed to **Module 6: Built-In Functions**

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 5*
