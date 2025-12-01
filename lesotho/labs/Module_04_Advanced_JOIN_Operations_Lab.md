# Module 4: Advanced JOIN Operations
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate with advanced sections  
**Prerequisites:** Module 3 completed  
**Target Audience:** Economists and Statisticians handling incomplete datasets and panel data

---

## Learning Objectives
1. Master LEFT and RIGHT OUTER JOINs for handling missing observations in economic datasets
2. Use FULL OUTER JOIN for complete coverage analysis and data gap identification
3. Identify missing data points and non-reporting entities (missing at random analysis)
4. Apply self-joins for longitudinal comparisons and time series transformations
5. Use CROSS JOIN for generating balanced panels and scenario analysis
6. Handle unbalanced datasets common in economic statistics

---

## BEGINNER SECTION (Required)

### Exercise 4.1: LEFT OUTER JOIN

**Task 1:** Find all banks including those without statistics
**Topic:** MS20761 Module 4 Lesson 2 – Use LEFT JOIN to list every bank even if data is missing
**Beginner Explanation:** This query keeps all banks in the result and shows their Q3 2024 stats when present, leaving NULLs when data is absent.

```sql
-- All banks with their latest statistics (if available)
SELECT 
    cb.BankName,
    cb.BankType,
    cb.IsActive,
    bs.ReportingDate,
    bs.TotalAssets,
    bs.TotalLoans
FROM CommercialBanks cb
LEFT JOIN BankingStatistics bs ON cb.BankID = bs.BankID 
    AND bs.ReportingDate = '2024-09-30'
ORDER BY cb.BankName;
```

**Detailed Query Explanation:** `LEFT JOIN` guarantees each `CommercialBanks` row appears even when no matching `BankingStatistics` row exists for the specified date. Matching rows show reporting date and totals; missing ones display NULLs.
**Detailed Results Explanation:** You’ll see every bank alphabetically with assets/loans filled in when the submission exists. Missing numbers highlight who has not reported for that quarter.

---

**Task 2:** Indicators with optional latest values
**Topic:** MS20761 Module 4 Lesson 2 & Module 13 Lesson 1 – Attach the latest observation to every indicator
**Beginner Explanation:** This LEFT JOIN ensures each indicator appears once, paired with its most recent value when one exists.

```sql
-- All indicators with their most recent value
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ei.IsActive,
    ts.PeriodDate AS 'Latest Date',
    ts.DataValue AS 'Latest Value'
FROM EconomicIndicators ei
LEFT JOIN (
    SELECT IndicatorID, PeriodDate, DataValue,
           ROW_NUMBER() OVER (PARTITION BY IndicatorID ORDER BY PeriodDate DESC) AS rn
    FROM TimeSeriesData
) ts ON ei.IndicatorID = ts.IndicatorID AND ts.rn = 1
ORDER BY ei.IndicatorCode;
```

**Detailed Query Explanation:** The subquery ranks time series entries per indicator; joining on `ts.rn = 1` returns only the latest row. Because it’s a LEFT JOIN, indicators without data still show up with NULL dates/values.
**Detailed Results Explanation:** The output is a catalog showing whether each indicator has a fresh value. Missing dates signal gaps needing follow-up.

---

### Exercise 4.2: Finding Missing Data

**Task 3:** Banks without Q3 2024 submissions
**Topic:** MS20761 Module 4 Lesson 2 – Flag active banks that skipped the Q3 2024 submission
**Beginner Explanation:** This LEFT JOIN pattern highlights banks lacking a matching stats record by checking for NULLs after the join.

```sql
-- Identify banks that haven't submitted Q3 2024 data
SELECT 
        cb.BankCode,
        cb.BankName,
        cb.Email,
        cb.Phone,
        'Missing Q3 2024 Report' AS Status
FROM CommercialBanks cb
LEFT JOIN BankingStatistics bs ON cb.BankID = bs.BankID 
        AND bs.ReportingDate = '2024-09-30'
WHERE cb.IsActive = 1
    AND bs.StatisticID IS NULL;
```

**Detailed Query Explanation:** The join tries to locate a Q3 2024 `BankingStatistics` row for each active bank. If none exists, `bs.StatisticID` remains NULL, and the `WHERE` clause keeps only those gaps.
**Detailed Results Explanation:** The result is an actionable contact list (with email and phone) of banks needing reminders about their missing Q3 report.

---

**Task 4:** Indicators without recent data
**Topic:** MS20761 Module 4 Lesson 2 – Spot active indicators whose data is stale
**Beginner Explanation:** This aggregate LEFT JOIN shows the last update date per active indicator and filters to those with no data in the past 60 days.

```sql
-- Active indicators with no data in last 60 days
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ds.SourceName,
    MAX(ts.PeriodDate) AS 'Last Update',
    DATEDIFF(DAY, MAX(ts.PeriodDate), GETDATE()) AS 'Days Since Update'
FROM EconomicIndicators ei
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
LEFT JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IsActive = 1
GROUP BY ei.IndicatorCode, ei.IndicatorName, ds.SourceName
HAVING MAX(ts.PeriodDate) < DATEADD(DAY, -60, GETDATE())
    OR MAX(ts.PeriodDate) IS NULL
ORDER BY MAX(ts.PeriodDate);
```

**Detailed Query Explanation:** Joining to `DataSources` adds the provider, while the LEFT JOIN with `TimeSeriesData` collects any submissions. `MAX(ts.PeriodDate)` finds the latest observation per indicator, and the HAVING clause keeps those older than 60 days (or missing entirely).
**Detailed Results Explanation:** Each row is an overdue indicator along with its source and days since last update, helping you focus follow-up actions.

---

### Exercise 4.3: RIGHT OUTER JOIN

**Task 5:** All data sources with indicator counts
**Topic:** MS20761 Module 4 Lesson 2 – Use RIGHT JOIN to list every data source even if unused
**Beginner Explanation:** This query counts how many indicators each source feeds, but still shows sources with zero indicators by joining from the indicator table to the data sources.

```sql
-- Data sources including those without indicators
SELECT 
    ds.SourceCode,
    ds.SourceName,
    ds.SourceType,
    COUNT(ei.IndicatorID) AS 'Indicator Count'
FROM EconomicIndicators ei
RIGHT JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
GROUP BY ds.SourceCode, ds.SourceName, ds.SourceType
ORDER BY COUNT(ei.IndicatorID) DESC;
```

**Detailed Query Explanation:** The RIGHT JOIN ensures every row from `DataSources` appears. Aggregating `COUNT(ei.IndicatorID)` tallies linked indicators, and sources with none show a count of zero.
**Detailed Results Explanation:** The output ranks data sources by indicator coverage while still highlighting unused sources, helping you identify underutilized partnerships.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 4.4: FULL OUTER JOIN

**Task 6:** Complete indicator coverage analysis
**Topic:** MS20761 Module 4 Lesson 3 – Compare expected monthly submissions against what actually arrived
**Beginner Explanation:** This FULL OUTER JOIN highlights whether CPI, inflation, and M2 indicators delivered data for every 2024 month or if any periods are missing or provisional.

```sql
-- Compare expected vs actual data submissions
WITH ExpectedData AS (
    SELECT 
        ei.IndicatorID,
        ei.IndicatorCode,
        DATEFROMPARTS(2024, m.MonthNum, 1) AS ExpectedDate
    FROM EconomicIndicators ei
    CROSS JOIN (
        SELECT 1 AS MonthNum UNION SELECT 2 UNION SELECT 3 
        UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
        UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
        UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
    ) m
    WHERE ei.FrequencyID = 3  -- Monthly indicators
)
SELECT 
    COALESCE(ed.IndicatorCode, ei.IndicatorCode) AS 'Indicator',
    ed.ExpectedDate,
    ts.PeriodDate AS 'Actual Date',
    ts.DataValue,
    CASE 
        WHEN ts.PeriodDate IS NULL THEN 'Missing'
        WHEN ts.IsProvisional = 1 THEN 'Provisional'
        ELSE 'Final'
    END AS Status
FROM ExpectedData ed
FULL OUTER JOIN TimeSeriesData ts ON ed.IndicatorID = ts.IndicatorID 
    AND YEAR(ts.PeriodDate) = 2024 
    AND MONTH(ts.PeriodDate) = MONTH(ed.ExpectedDate)
LEFT JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ed.IndicatorID IN (4, 6, 8)  -- CPI, Inflation, M2
ORDER BY ed.IndicatorCode, ed.ExpectedDate;
```

**Detailed Query Explanation:** The `ExpectedData` CTE generates every expected monthly date for each monthly indicator. The FULL OUTER JOIN matches expected rows to actual submissions, preserving unmatched sides so gaps appear. The `CASE` statement labels each row Missing, Provisional, or Final.
**Detailed Results Explanation:** For each indicator-month combination you will see whether a value exists and its quality, allowing instant identification of missing months in 2024.

---

### Exercise 4.5: Self-Joins

**Task 7:** Compare indicator values across periods
**Topic:** MS20761 Module 4 Lesson 4 – Compare each inflation month against the prior month using a self-join
**Beginner Explanation:** This LEFT JOIN lines up every month with the immediately preceding month to calculate the change and label the trend.

```sql
-- Month-over-month inflation comparison
SELECT 
    current.PeriodDate AS 'Current Month',
    current.DataValue AS 'Current Inflation',
    previous.PeriodDate AS 'Previous Month',
    previous.DataValue AS 'Previous Inflation',
    (current.DataValue - previous.DataValue) AS 'Monthly Change',
    CASE 
        WHEN current.DataValue > previous.DataValue THEN 'Increasing'
        WHEN current.DataValue < previous.DataValue THEN 'Decreasing'
        ELSE 'Stable'
    END AS 'Trend'
FROM TimeSeriesData current
LEFT JOIN TimeSeriesData previous ON 
    current.IndicatorID = previous.IndicatorID
    AND previous.PeriodDate = DATEADD(MONTH, -1, current.PeriodDate)
WHERE current.IndicatorID = 6  -- Inflation Rate
  AND current.PeriodDate >= '2024-01-01'
ORDER BY current.PeriodDate;
```

**Detailed Query Explanation:** Aliasing `TimeSeriesData` twice lets you match each row with its prior month via the date math in the join condition. A LEFT JOIN keeps the current month even if the previous month is missing (e.g., the first row). The `CASE` expression turns the numeric change into a qualitative trend.
**Detailed Results Explanation:** Rows display current vs previous month values, the numeric difference, and whether inflation is rising, falling, or stable—handy for narrative summaries.

---

**Task 8:** Hierarchical category analysis
**Topic:** MS20761 Module 4 Lesson 4 – Show category hierarchies via a self-join
**Beginner Explanation:** This query pairs every child indicator category with its parent (if one exists) to make the hierarchy explicit.

```sql
-- Parent-child indicator categories with self-join
SELECT 
    parent.CategoryCode AS 'Parent Code',
    parent.CategoryName AS 'Parent Category',
    child.CategoryCode AS 'Child Code',
    child.CategoryName AS 'Child Category',
    child.Description
FROM IndicatorCategories child
LEFT JOIN IndicatorCategories parent ON child.ParentCategoryID = parent.CategoryID
ORDER BY parent.CategoryName, child.CategoryName;
```

**Detailed Query Explanation:** Joining `IndicatorCategories` to itself using the `ParentCategoryID` column brings in the parent’s code and name. A LEFT JOIN keeps top-level categories where the parent is NULL. Sorting by parent then child keeps families together.
**Detailed Results Explanation:** Each row reveals the relationship between parent and child categories, plus the child description, assisting in documentation or navigation menus.

---

### Exercise 4.6: Complex Outer Join Scenarios

**Task 9:** Banking sector gap analysis
**Topic:** MS20761 Module 4 Lesson 3 – Build a matrix of expected bank submissions vs actual reports
**Beginner Explanation:** This query generates every active bank/quarter combination and uses a LEFT JOIN to show whether the corresponding report was submitted, validated, or missing.

```sql
-- Identify missing banking reports across quarters
WITH AllBanksQuarters AS (
    SELECT 
        cb.BankID,
        cb.BankName,
        q.QuarterDate
    FROM CommercialBanks cb
    CROSS JOIN (
        VALUES 
            ('2024-03-31'),
            ('2024-06-30'),
            ('2024-09-30')
    ) q(QuarterDate)
    WHERE cb.IsActive = 1
)
SELECT 
    abq.BankName,
    abq.QuarterDate AS 'Expected Reporting Date',
    bs.ReportingDate AS 'Actual Reporting Date',
    bs.SubmittedDate,
    CASE 
        WHEN bs.StatisticID IS NULL THEN 'NOT SUBMITTED'
        WHEN bs.IsValidated = 0 THEN 'PENDING VALIDATION'
        ELSE 'COMPLETE'
    END AS 'Status',
    DATEDIFF(DAY, abq.QuarterDate, bs.SubmittedDate) AS 'Days After Quarter End'
FROM AllBanksQuarters abq
LEFT JOIN BankingStatistics bs ON abq.BankID = bs.BankID 
    AND bs.ReportingDate = abq.QuarterDate
ORDER BY abq.BankName, abq.QuarterDate;
```

**Detailed Query Explanation:** The CTE `AllBanksQuarters` uses a CROSS JOIN to create every expected reporting date per active bank. The subsequent LEFT JOIN attempts to match an actual submission; missing matches stay NULL and are labeled `NOT SUBMITTED` by the CASE expression. The `DATEDIFF` shows how late each submission was.
**Detailed Results Explanation:** The result provides a quarter-by-quarter status grid for each bank, highlighting missing or pending reports and summarizing timeliness.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 4.7: Data Completeness Dashboard

**Task 10:** Comprehensive data completeness report
**Topic:** MS20761 Module 4 Lesson 3 – Build a completeness dashboard comparing expected vs actual submissions
**Beginner Explanation:** This query counts how many monthly observations were expected and how many actually arrived, breaking them into provisional versus final values.

```sql
-- Track data completeness by indicator and period
WITH MonthlyExpectations AS (
    SELECT 
        ei.IndicatorID,
        ei.IndicatorCode,
        ei.IndicatorName,
        EOMONTH(DATEADD(MONTH, n.num, '2023-12-31')) AS ExpectedDate
    FROM EconomicIndicators ei
    CROSS JOIN (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num
        FROM master.dbo.spt_values
        WHERE num <= 11
    ) n
    WHERE ei.FrequencyID = 3  -- Monthly
      AND ei.IsActive = 1
)
SELECT 
    me.IndicatorCode,
    me.IndicatorName,
    COUNT(DISTINCT me.ExpectedDate) AS 'Expected Submissions',
    COUNT(DISTINCT ts.PeriodDate) AS 'Actual Submissions',
    COUNT(DISTINCT CASE WHEN ts.IsProvisional = 0 THEN ts.PeriodDate END) AS 'Final Data',
    COUNT(DISTINCT CASE WHEN ts.IsProvisional = 1 THEN ts.PeriodDate END) AS 'Provisional Data',
    ROUND(
        (CAST(COUNT(DISTINCT ts.PeriodDate) AS FLOAT) / 
         COUNT(DISTINCT me.ExpectedDate)) * 100, 
        2
    ) AS 'Completeness %'
FROM MonthlyExpectations me
LEFT JOIN TimeSeriesData ts ON me.IndicatorID = ts.IndicatorID 
    AND YEAR(ts.PeriodDate) = 2024 
    AND MONTH(ts.PeriodDate) = MONTH(me.ExpectedDate)
GROUP BY me.IndicatorCode, me.IndicatorName
ORDER BY 'Completeness %';
```

**Detailed Query Explanation:** The CTE enumerates each expected month for active monthly indicators. After joining to actual submissions, aggregate counts tally expected vs actual records and split provisional vs final data, culminating in a completeness percentage.
**Detailed Results Explanation:** Each row reveals whether an indicator met its submission targets for 2024, highlighting where coverage is strong and where gaps exist.

---

### Exercise 4.8: Advanced Self-Join Analysis

**Task 11:** Multi-period banking comparison
**Topic:** MS20761 Module 4 Lesson 4 & Module 13 Lesson 2 – Compare each bank’s quarterly assets and ratios side by side
**Beginner Explanation:** This self-join pattern brings Q1, Q2, and Q3 rows onto one line per bank so you can compute growth rates and NPL changes.

```sql
-- Compare banking performance across quarters
SELECT 
    cb.BankName,
    q3.ReportingDate AS 'Q3 2024',
    q3.TotalAssets AS 'Q3 Assets',
    q2.TotalAssets AS 'Q2 Assets',
    q1.TotalAssets AS 'Q1 Assets',
    -- Q-o-Q growth
    ROUND(((q3.TotalAssets - q2.TotalAssets) / q2.TotalAssets) * 100, 2) AS 'Q3 vs Q2 Growth %',
    ROUND(((q2.TotalAssets - q1.TotalAssets) / q1.TotalAssets) * 100, 2) AS 'Q2 vs Q1 Growth %',
    -- Ratios comparison
    q3.NPLRatio AS 'Q3 NPL%',
    q2.NPLRatio AS 'Q2 NPL%',
    (q3.NPLRatio - q2.NPLRatio) AS 'NPL Change'
FROM CommercialBanks cb
LEFT JOIN BankingStatistics q3 ON cb.BankID = q3.BankID 
    AND q3.ReportingDate = '2024-09-30'
LEFT JOIN BankingStatistics q2 ON cb.BankID = q2.BankID 
    AND q2.ReportingDate = '2024-06-30'
LEFT JOIN BankingStatistics q1 ON cb.BankID = q1.BankID 
    AND q1.ReportingDate = '2024-03-31'
WHERE cb.IsActive = 1
ORDER BY q3.TotalAssets DESC;
```

**Detailed Query Explanation:** Three LEFT JOINs pull the statistics for different quarters onto the same row keyed by `BankID`. Calculated expressions compare quarter-over-quarter asset growth and NPL changes. LEFT JOIN preserves banks even if a particular quarter is missing.
**Detailed Results Explanation:** Each row becomes a compact quarterly comparison showing assets, growth percentages, and change in NPL ratios, enabling quick trend assessments.

---

### Exercise 4.9: CROSS JOIN for Scenario Analysis

**Task 12:** Generate all possible indicator-period combinations
**Topic:** MS20761 Module 4 Lesson 3 – Generate every quarterly indicator/period pair for planning
**Beginner Explanation:** By cross joining indicators with quarter names, this query creates a template showing whether each expected observation has been collected, is provisional, or is missing.

```sql
-- Create template for quarterly data collection
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    quarters.QuarterName,
    quarters.QuarterDate,
    ds.SourceName AS 'Expected Source',
    ts.DataValue AS 'Actual Value',
    CASE 
        WHEN ts.TimeSeriesID IS NULL THEN 'Awaiting Collection'
        WHEN ts.IsProvisional = 1 THEN 'Provisional - Awaiting Final'
        ELSE 'Complete'
    END AS 'Collection Status'
FROM EconomicIndicators ei
CROSS JOIN (
    VALUES 
        ('Q1 2024', '2024-03-31'),
        ('Q2 2024', '2024-06-30'),
        ('Q3 2024', '2024-09-30'),
        ('Q4 2024', '2024-12-31')
) quarters(QuarterName, QuarterDate)
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
LEFT JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID 
    AND ts.PeriodDate = quarters.QuarterDate
WHERE ei.FrequencyID = 4  -- Quarterly indicators
ORDER BY quarters.QuarterDate, ei.IndicatorCode;
```

**Detailed Query Explanation:** The `CROSS JOIN` produces every combination of quarterly indicator and quarter date. Joining to `DataSources` supplies the expected provider, while the LEFT JOIN fills in actual values when available. The CASE expression interprets each row’s collection status.
**Detailed Results Explanation:** The final grid shows, for each quarter, whether a quarterly indicator has delivered data, is provisional, or has yet to be collected—ideal for monitoring scenario plans or collection schedules.

---

## Practice Exercises (Do It Yourself)

### Beginner
1. Find all categories including those without indicators
2. Show all staff with optional specializations
3. List reports with optional dissemination records
4. Display data sources that haven't provided data in 2024

### Intermediate
5. Compare FX reserves month-over-month for 2024
6. Find indicators measured in "Percentage" without recent data
7. Show all banks with their Q2 vs Q3 2024 deposit growth
8. Identify data sources with delayed submissions

### Advanced
9. Create quarterly compliance dashboard for all banks
10. Build multi-year inflation comparison (2023 vs 2024)
11. Analyze seasonal patterns in tourism-related indicators
12. Track revisions for all fiscal indicators

---

## Real-World Scenarios

### Scenario 1: Regulatory Compliance Check
The Banking Supervision division needs to ensure all active banks have submitted their quarterly reports. Create a query showing banks that are non-compliant with submission deadlines.

### Scenario 2: Data Quality Audit
The Data Management Division needs to audit data completeness for all monetary indicators. Show which indicators have missing months and need follow-up with data providers.

### Scenario 3: IMF Article IV Consultation
The IMF requires a comprehensive dataset showing all macroeconomic indicators with complete time series. Identify gaps that need to be filled before the consultation.

---

## Key Takeaways

✅ **LEFT JOIN:**
- Returns all rows from left table
- NULL for unmatched right table rows
- Perfect for "all X with optional Y"

✅ **RIGHT JOIN:**
- Returns all rows from right table
- Less common (can rewrite as LEFT JOIN)
- Useful for specific perspectives

✅ **FULL OUTER JOIN:**
- Returns all rows from both tables
- NULL for unmatched rows from either side
- Complete picture of relationships

✅ **Self-Join:**
- Join table to itself
- Great for comparisons and hierarchies
- Requires different aliases

✅ **CROSS JOIN:**
- Cartesian product (all combinations)
- No ON clause needed
- Useful for generating test data/templates

---

## Next Steps

Proceed to **Module 5: Grouping and Aggregating Data**

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 4*
