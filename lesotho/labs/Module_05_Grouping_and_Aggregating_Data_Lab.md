# Module 5: Grouping and Aggregating Data
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-4 completed  
**Target Audience:** Economists and Statisticians performing statistical aggregation and descriptive analysis

---

## Learning Objectives
1. Master GROUP BY clause for statistical summarization and cross-tabulation
2. Use aggregate functions for descriptive statistics (COUNT, SUM, AVG, MIN, MAX, STDEV)
3. Apply HAVING clause for conditional aggregation in economic analysis
4. Calculate key statistical measures (mean, variance, range) for econometric datasets
5. Generate summary statistics tables for policy reports and economic bulletins
6. Compute sector aggregates and composite economic indicators

---

## BEGINNER SECTION (Required)

### Exercise 5.1: Basic Aggregations

**Task 1:** Count indicators by category
**Topic:** MS20761 Module 9 Lesson 1 – Count indicators per category with active/inactive splits
**Beginner Explanation:** This aggregation shows how many total, active, and inactive indicators sit under each category name.

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

**Detailed Query Explanation:** Joining categories to indicators ensures each indicator contributes to its category totals. Conditional `COUNT` expressions separate active vs inactive counts, while `GROUP BY ic.CategoryName` yields one row per category.
**Detailed Results Explanation:** Each row summarizes a category’s indicator inventory, making it easy to spot well-populated categories or those needing development.

---

**Task 2:** Banking sector totals
**Topic:** MS20761 Module 9 Lesson 1 – Summarize total sector size for a given reporting date
**Beginner Explanation:** This query aggregates assets, loans, deposits, and the average NPL ratio for all banks that reported on 30 Sept 2024.

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

**Detailed Query Explanation:** Filtering to one date ensures a single snapshot. Aggregates compute sums and averages across all reporting banks, while `COUNT(DISTINCT BankID)` verifies how many banks submitted data for that date.
**Detailed Results Explanation:** The output is a one-row sector dashboard showing totals and the mean NPL ratio, perfect for briefing notes or executive summaries.

---

**Task 3:** Data frequency distribution
**Topic:** MS20761 Module 9 Lesson 2 – Show how many indicators run at each reporting frequency
**Beginner Explanation:** This aggregation counts indicators per frequency and expresses each as a percentage of all indicators.

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

**Detailed Query Explanation:** Joining frequencies to indicators ensures each indicator contributes to exactly one frequency bucket. The scalar subquery gets the overall indicator count, enabling a percentage for each row. Sorting uses `SortOrder` to respect logical frequency progression.
**Detailed Results Explanation:** The result highlights the distribution of daily, monthly, quarterly, etc., indicators plus their share of the catalog, helping allocate resources to the busiest cadences.

---

### Exercise 5.2: MIN and MAX Functions

**Task 4:** Find range of inflation rates
**Topic:** MS20761 Module 9 Lesson 2 – Summarize inflation variation for the current year
**Beginner Explanation:** This aggregation finds the min, max, average, and range of 2024 inflation readings, plus how many observations exist.

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

**Detailed Query Explanation:** Filtering by indicator code and year isolates the 2024 inflation series. Aggregate functions compute descriptive statistics directly over the filtered set without needing `GROUP BY`.
**Detailed Results Explanation:** Expect a single row showing the extremes and average inflation, plus the number of data points used—ideal for briefing policymakers on volatility.

---

**Task 5:** Exchange rate ranges by currency
**Topic:** MS20761 Module 9 Lesson 2 – Compare minimum, maximum, and average FX rates for major currencies
**Beginner Explanation:** This report summarizes how each tracked currency traded in 2024 by listing its lowest, highest, and average exchange rate plus the number of trading days recorded.

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

**Detailed Query Explanation:** Filtering to three FX indicator codes confines the dataset to USD, ZAR, and EUR series. Grouping by `IndicatorName` rolls each currency’s 2024 data into one row while aggregates compute the desired statistics and day counts.
**Detailed Results Explanation:** The output shows volatility bands per currency, letting analysts quickly see which FX pair was most stable or volatile and how deep the sample size is for each.

---

### Exercise 5.3: GROUP BY with Multiple Columns

**Task 6:** Data submissions by source and month
**Topic:** MS20761 Module 9 Lesson 3 – Track how many data points each source delivers every month
**Beginner Explanation:** This aggregation counts how many individual observations and unique indicators each data source supplied per month in 2024, splitting provisional versus final entries.

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

**Detailed Query Explanation:** Joining `TimeSeriesData` to sources via indicators links every observation to its origin. Grouping by both source and formatted month produces a grid of counts, while `COUNT(DISTINCT ts.IndicatorID)` measures breadth and the CASE expressions split provisional vs final.
**Detailed Results Explanation:** Expect one row per source-month showing delivery volume and quality mix. Use it to spot contributors with declining submissions or high provisional proportions needing follow-up.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 5.4: HAVING Clause

**Task 7:** Find categories with many indicators
**Topic:** MS20761 Module 9 Lesson 4 – Highlight indicator categories that have rich coverage
**Beginner Explanation:** This query finds every category that contains more than two indicators and lists their codes so you can focus on the most populated subject areas.

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

**Detailed Query Explanation:** Standard grouping accumulates indicators per category, while `HAVING COUNT(...) > 2` keeps only the categories exceeding the threshold. `STRING_AGG` concisely lists the indicator codes for reference.
**Detailed Results Explanation:** Output rows show categories ranked by size with their constituent indicators, helping curriculum designers or economists focus on areas with ample data coverage.

---

**Task 8:** Banks with high NPL ratios
**Topic:** MS20761 Module 9 Lesson 4 – Flag banks whose average NPL ratio exceeds the sector benchmark
**Beginner Explanation:** The CTE captures the sector-wide average NPL ratio, then each bank’s average across three quarters is compared to highlight those performing worse than the aggregate.

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

**Detailed Query Explanation:** The `SectorAvg` CTE calculates a baseline once. The main query aggregates each bank’s NPL ratio and uses `HAVING` to keep only those above the baseline. Additional columns show the difference to contextualize the deviation.
**Detailed Results Explanation:** Each returned bank is underperforming relative to the sector, along with how many reports underpin the average, giving supervisors a targeted watchlist.

---

### Exercise 5.5: Statistical Calculations

**Task 9:** Calculate GDP growth statistics
**Topic:** MS20761 Module 9 Lesson 2 – Produce quarterly descriptive stats for real GDP
**Beginner Explanation:** Grouping GDP observations by year and quarter lets you see average output, min/max values, dispersion, and how many data points inform each quarter.

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

**Detailed Query Explanation:** Filtering to real GDP records from 2023 onward, the query derives quarter and year via `DATEPART`, groups by both, and applies aggregate functions to describe the distribution within each quarter.
**Detailed Results Explanation:** Expect one row per quarter containing average GDP levels, the spread of values, and sample counts—useful for tracking volatility or anomalies across reporting periods.

---

### Exercise 5.6: Multi-Level Grouping

**Task 10:** Banking sector breakdown by quarter and bank
**Topic:** MS20761 Module 9 Lesson 3 – Summarize banking metrics by quarter and bank type
**Beginner Explanation:** This grouping aggregates assets, loans, deposits, and ratios for each bank type per quarter, giving a multi-level view of the sector’s structure.

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

**Detailed Query Explanation:** The concatenated quarter label is derived from `DATEPART`. Grouping on quarter/year plus `BankType` creates a matrix of aggregates, while derived ratios like loan-to-asset use the already aggregated sums to avoid double counting.
**Detailed Results Explanation:** Each row describes a bank type’s footprint within a quarter, helping analysts quickly compare commercial vs development banks on key KPIs.

---

### Exercise 5.7: Aggregates with Filtering

**Task 11:** Monthly inflation above target
**Topic:** MS20761 Module 9 Lesson 4 – Count how often inflation breaches the 5% target each year
**Beginner Explanation:** Grouping inflation readings by year reveals how many months stay within or exceed the 5% target, along with averages and peaks for context.

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

**Detailed Query Explanation:** The query filters to the inflation series, derives the calendar year, and uses conditional `COUNT` expressions to split months above vs within target. Aggregates add mean and maximum inflation for each year.
**Detailed Results Explanation:** Each row summarizes yearly inflation performance, making it easy to see troublesome years that frequently overshoot the target.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 5.8: Complex Summary Report

**Task 12:** Comprehensive economic dashboard
**Topic:** MS20761 Module 9 Lesson 5 – Build an executive summary table for each indicator category
**Beginner Explanation:** This aggregation counts indicators, data points, coverage dates, data quality percentages, and source counts per category to form a wide-ranging dashboard.

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

**Detailed Query Explanation:** After joining categories to indicators and optional time series records, the query aggregates various metrics per category, including distinct counts, min/max dates, and calculated percentages derived from aggregated values.
**Detailed Results Explanation:** Each row serves as a dashboard card showing how much data exists for a category, how current it is, and how much is final vs provisional—ideal for management briefings.

---

### Exercise 5.9: Banking Sector Trends

**Task 13:** Quarterly banking trends with growth rates
**Topic:** MS20761 Module 9 Lesson 5 & Module 13 Lesson 2 – Compare quarter-over-quarter banking aggregates and growth
**Beginner Explanation:** The CTE produces totals per reporting date, then each quarter is compared to the prior one to calculate growth percentages for assets and loans.

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

**Detailed Query Explanation:** The CTE pre-aggregates each quarter once, simplifying the main query. A self-join aligns each quarter with its predecessor so growth rates can be computed using prior totals, guarding with `CASE` to avoid division by zero.
**Detailed Results Explanation:** The resulting timeline shows raw totals and growth metrics per quarter, providing an easy trend view for macro reports and stress tests.

---

### Exercise 5.10: Data Quality Metrics

**Task 14:** Calculate data completeness scores
**Topic:** MS20761 Module 9 Lesson 5 – Measure whether each active indicator delivered its expected 2024 observations
**Beginner Explanation:** The query compares how many records each indicator should have (based on frequency) against how many it actually delivered, producing completeness and finalization percentages plus reporting lag.

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

**Detailed Query Explanation:** `ExpectedCounts` maps each indicator to its annual expectation while `ActualCounts` tallies 2024 submissions. Joining them enables percentage calculations via aggregated values, and `ISNULL` keeps indicators with zero data visible.
**Detailed Results Explanation:** Each row highlights whether an indicator met its data delivery quota, how much was finalized, and average reporting lag—key inputs for the data quality dashboard.

---

### Exercise 5.11: Report Generation Summary

**Task 15:** Monthly Statistical Bulletin metrics
**Topic:** MS20761 Module 9 Lesson 5 – Produce a monthly roll-up for the statistical bulletin
**Beginner Explanation:** This query groups 2024 observations by calendar month to count how many indicators, categories, and sources appear, plus provisional/final splits and collection lag metrics.

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

**Detailed Query Explanation:** Formatting the period date into `MMMM yyyy` makes a readable label while grouping also includes year/month numbers for proper ordering. Aggregate counts and averages provide the bulletin KPIs, and `HAVING` ensures only substantial months are included.
**Detailed Results Explanation:** Each row is a monthly briefing card showing breadth of coverage, provisional mix, timeliness, and last update date—ready to insert into the publication workflow.

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

### Scenario 1: Governor's Monthly Economic Brief (Economist Task)
The Governor needs a one-page statistical summary showing: total banking sector assets (aggregate), average inflation rate (mean), foreign reserves level, and key economic indicators with their descriptive statistics. As an economist, create aggregate queries that provide summary statistics including means, totals, and period-over-period changes.

### Scenario 2: IMF Article IV Statistical Package (Statistician Task)
Prepare aggregated statistical tables for IMF reporting: quarterly GDP aggregates with seasonal adjustment flags, annual inflation averages with standard deviations, banking sector concentration ratios (Herfindahl index components), and external sector balances. Use GROUP BY for time series aggregation and HAVING to filter statistically significant indicators.

### Scenario 3: Statistical Quality Assessment Dashboard (Data Quality Officer Task)
The Senior Statistician needs a weekly quality dashboard showing: data completeness ratios by source, timeliness metrics (mean lag in days), provisional vs final data proportions, coefficient of variation for volatility assessment, and missing data alerts. Build aggregated queries using statistical measures for this quality assurance dashboard.

---

## Key Takeaways

✅ **GROUP BY:**
- Groups rows with same values
- Must include all non-aggregated columns
- Creates summary rows

✅ **Aggregate Functions (Descriptive Statistics):**
- COUNT: Count observations/sample size (n)
- SUM: Total aggregate (Σx) for economic totals
- AVG: Arithmetic mean (μ or x̄) for central tendency
- MIN/MAX: Range boundaries for distribution analysis
- STDEV: Standard deviation (σ) for dispersion/volatility
- VAR: Variance (σ²) for variability analysis

✅ **HAVING (Post-Aggregation Filtering):**
- Filters grouped statistical results
- Uses aggregate functions for conditional analysis
- Applied after GROUP BY (similar to subset selection in statistical software)
- Different from WHERE (filters before aggregation/grouping)

✅ **Best Practices for Economists & Statisticians:**
- Use meaningful aliases for statistical measures
- Include all non-aggregated dimensions in GROUP BY
- HAVING for filtering on summary statistics
- WHERE for filtering raw observations
- Document calculation methods for reproducibility

---

## Next Steps

Proceed to **Module 6: Built-In Functions**

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 5*
