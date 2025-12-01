# Module 3: JOIN Operations - Querying Multiple Tables
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians
**Topic:** MS20761 Module 4 Lesson 3 – See every dissemination event with linked report info
**Beginner Explanation:** This query shows how to use LEFT JOINs so that dissemination records still appear even if no report metadata exists, while including titles and report types when available.

```sql
-- Track all data dissemination with full context
SELECT 
    dd.DisseminationDate,
    dd.DisseminationType,
    dd.RecipientType,
    dd.RecipientName,
    dd.DataCategory,
    rt.ReportName,
    mr.ReportTitle,
    dd.DeliveryMethod,
    dd.ApprovedBy,
    dd.Purpose
FROM DataDissemination dd
LEFT JOIN MacroeconomicReports mr ON dd.ReportID = mr.ReportID
LEFT JOIN ReportTypes rt ON mr.ReportTypeID = rt.ReportTypeID
ORDER BY dd.DisseminationDate DESC;
```

**Detailed Query Explanation:** `LEFT JOIN` ensures every dissemination row is returned, even when the associated report fields are null. When a report exists, the join adds its title and type. Ordering by dissemination date descending keeps the most recent activity on top.
**Detailed Results Explanation:** The result acts like a dissemination log, showing when and how data was shared, with report titles filled in when applicable—useful for compliance tracking.
## Understanding CBL Data Relationships

```
EconomicIndicators (Master)
    ├─► TimeSeriesData (actual values)
    ├─► IndicatorCategories (classification)
    ├─► DataSources (origin)
    └─► DataFrequencies (periodicity)

CommercialBanks (Master)
    └─► BankingStatistics (financial data)

MacroeconomicReports
    └─► ReportTypes (classification)
```

---

## BEGINNER SECTION (Required for All)

### Exercise 3.1: Basic INNER JOIN

**Task 1:** Join indicators with their categories
**Topic:** MS20761 Module 4 Lesson 2 – Attach readable category names to each indicator
**Beginner Explanation:** This inner join links each indicator to its category so you see the code, name, and classification together.

```sql
-- Display indicators with category names
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ic.CategoryName
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
ORDER BY ic.CategoryName, ei.IndicatorName;
```

**Detailed Query Explanation:** The join pairs rows where `EconomicIndicators.CategoryID` equals `IndicatorCategories.CategoryID`. Ordering by category then indicator keeps the output grouped logically.
**Detailed Results Explanation:** Each row lists one indicator along with the human-friendly category label, making it simple to count indicators by category or scan for duplicates.

**Questions:**
- How many indicators are in the Monetary category?
- Which category has the most indicators?

---

**Task 2:** Combine time series data with indicator details
**Topic:** MS20761 Module 4 Lesson 2 – Blend indicator metadata with actual time series values
**Beginner Explanation:** This join combines inflation readings with the indicator’s name, code, and unit so each row is self-explanatory.

```sql
-- Get inflation data with full indicator information
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    ei.UnitOfMeasure
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode = 'INF-RATE'
ORDER BY ts.PeriodDate DESC;
```

**Detailed Query Explanation:** The join uses the `IndicatorID` foreign key to pull descriptive fields from `EconomicIndicators`. Filtering on `IndicatorCode = 'INF-RATE'` isolates inflation, and ordering descending shows most recent periods first.
**Detailed Results Explanation:** Each row now contains the context (indicator code/name/unit) alongside the values and dates. This format is ideal for exporting series to spreadsheets or reports without extra lookup steps.

---

**Task 3:** Link banking statistics with bank names
**Topic:** MS20761 Module 4 Lesson 2 – Combine numeric bank stats with their names and types
**Beginner Explanation:** This join adds readable bank info to the quarterly statistics so the numbers aren’t floating without context.

```sql
-- Banking sector summary with bank names
SELECT 
    cb.BankName,
    cb.BankType,
    bs.ReportingDate,
    bs.TotalAssets,
    bs.TotalLoans,
    bs.TotalDeposits
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30'
ORDER BY bs.TotalAssets DESC;
```

**Detailed Query Explanation:** The `INNER JOIN` matches each `BankingStatistics` row to its `CommercialBanks` master record using `BankID`. Filtering on the Q3 2024 date ensures a single snapshot, and sorting by `TotalAssets` descending ranks banks by size.
**Detailed Results Explanation:** Expect one row per active bank showing its core totals plus name and type, ready for supervisory summaries or comparative charts.

---

### Exercise 3.2: Three-Table Joins

**Task 4:** Complete indicator information
**Topic:** MS20761 Module 4 Lesson 1 – Join multiple lookup tables to see every metadata field
**Beginner Explanation:** This three-way join shows how to add category, source, and frequency details to each indicator record.

```sql
-- Indicators with category, source, and frequency
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ic.CategoryName,
    ds.SourceName,
    df.FrequencyName
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
ORDER BY ic.CategoryName, ei.IndicatorCode;
```

**Detailed Query Explanation:** Each `INNER JOIN` brings in another descriptive table, matching on the relevant foreign key. Ordering by category then code makes the catalog easier to read.
**Detailed Results Explanation:** The output is a comprehensive indicator catalog showing the category, source institution, and publication frequency for each series—perfect for documentation or audits.

---

**Task 5:** Time series with complete metadata
**Topic:** MS20761 Module 4 Lesson 1 – Add source information to CPI readings
**Beginner Explanation:** This query puts each CPI observation together with the indicator name, units, and the data source so nothing is ambiguous.

```sql
-- Latest CPI data with full context
SELECT 
    ts.PeriodDate,
    ei.IndicatorName,
    ts.DataValue,
    ei.UnitOfMeasure,
    ds.SourceName AS 'Data Source',
    ts.IsProvisional
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN DataSources ds ON ts.DataSourceID = ds.DataSourceID
WHERE ei.IndicatorCode = 'CPI-ALL'
ORDER BY ts.PeriodDate DESC;
```

**Detailed Query Explanation:** The join to `EconomicIndicators` brings in descriptive details while the join to `DataSources` shows provenance. Filtering to the `CPI-ALL` code centers on the main CPI series, and sorting by `PeriodDate DESC` delivers the newest figures first.
**Detailed Results Explanation:** Use the resulting table as a ready-to-publish CPI sheet, complete with measurement units, source attribution, and flags for provisional values.

---

### Exercise 3.3: Joining for Report Generation

**Task 6:** Monthly Statistical Bulletin - Key Indicators
**Topic:** MS20761 Module 4 Lesson 2 – Build a bulletin-ready table for November 2024
**Beginner Explanation:** This join-heavy query grabs all published indicators for November 2024 with their category, units, and source so you can drop the table straight into the monthly bulletin.

```sql
-- Key economic indicators for November 2024
SELECT 
        ic.CategoryName AS 'Category',
        ei.IndicatorName AS 'Indicator',
        ts.DataValue AS 'Value',
        ei.UnitOfMeasure AS 'Unit',
        ds.SourceName AS 'Source'
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataSources ds ON ts.DataSourceID = ds.DataSourceID
WHERE ts.PeriodDate = '2024-11-30'
    AND ei.IsPublished = 1
ORDER BY ic.CategoryName, ei.IndicatorName;
```

**Detailed Query Explanation:** Each join supplies categorical, indicator, and source metadata for the selected date. Filtering on `IsPublished = 1` ensures only approved indicators appear, while ordering by category then indicator yields a polished grouping.
**Detailed Results Explanation:** The output is a curated snapshot of all published November indicators, including the actual values, making it trivial to populate summary tables or slides.

---

**Task 7:** Banking Sector Report
**Topic:** MS20761 Module 4 Lesson 2 – Provide a banking sector dashboard with ratios
**Beginner Explanation:** This query ties bank names to their Q3 2024 totals and ratios, but only for active banks, so supervisors can compare them in one list.

```sql
-- Q3 2024 Banking Sector Summary
SELECT 
        cb.BankName,
        cb.BankType,
        bs.TotalAssets AS 'Assets (M LSL)',
        bs.TotalLoans AS 'Loans (M LSL)',
        bs.TotalDeposits AS 'Deposits (M LSL)',
        bs.NPLRatio AS 'NPL %',
        bs.CapitalAdequacyRatio AS 'CAR %',
        bs.LiquidityRatio AS 'Liquidity %'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30'
    AND cb.IsActive = 1
ORDER BY bs.TotalAssets DESC;
```

**Detailed Query Explanation:** The join fetches bank names/types, while the WHERE clause fixes the quarter and filters out inactive institutions. Ordering by assets descending instantly ranks the sector by size.
**Detailed Results Explanation:** Each row is a mini profile containing assets, loans, deposits, and key prudential ratios, making it easy to benchmark banks in a single glance.

---

### Exercise 3.4: Filtering Joined Data

**Task 8:** External data sources only
**Topic:** MS20761 Module 4 Lesson 2 – Keep only indicators fed by external providers
**Beginner Explanation:** This join filters the indicator catalog to rows whose data source type is External or Government Agency.

```sql
-- Indicators from external sources
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ds.SourceName,
    ds.SourceType
FROM EconomicIndicators ei
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
WHERE ds.SourceType IN ('External', 'Government Agency')
ORDER BY ds.SourceName, ei.IndicatorName;
```

**Detailed Query Explanation:** After joining to `DataSources`, the `WHERE` clause restricts rows to specific source types. Sorting by source name keeps related indicators grouped.
**Detailed Results Explanation:** The table shows exactly which indicators rely on outside entities, aiding in outreach planning or dependency tracking.

---

**Task 9:** High-frequency indicators
**Topic:** MS20761 Module 4 Lesson 2 – Focus on high-frequency (daily/weekly) indicators
**Beginner Explanation:** This query shows which indicators are reported daily or weekly by filtering on the frequency code after joining.

```sql
-- Daily and weekly indicators
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    df.FrequencyName,
    ei.Description
FROM EconomicIndicators ei
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
WHERE df.FrequencyCode IN ('D', 'W')
ORDER BY ei.IndicatorName;
```

**Detailed Query Explanation:** Joining to `DataFrequencies` reveals each indicator’s periodicity. The `IN ('D','W')` filter retains only daily or weekly series, and ordering by name provides a neat alphabetical list.
**Detailed Results Explanation:** Use this output to coordinate high-frequency monitoring tasks or to ensure dashboards refresh at the right cadence.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 3.5: Complex Multi-Table Joins

**Task 10:** Complete banking sector analysis
**Topic:** MS20761 Module 4 Lesson 1 – Produce a rich banking profile with calculated ratios
**Beginner Explanation:** This multi-column query marries bank details with the latest stats and even computes structural ratios and age so analysts get everything in one table.

```sql
-- Banking statistics with bank details and calculated ratios
SELECT 
    cb.BankCode,
    cb.BankName,
    cb.BankType,
    cb.EstablishedDate,
    bs.ReportingDate,
    bs.TotalAssets,
    bs.TotalLoans,
    bs.TotalDeposits,
    bs.TotalEquity,
    -- Calculated metrics
    ROUND((bs.TotalLoans / bs.TotalAssets) * 100, 2) AS 'Loan-to-Asset %',
    ROUND((bs.TotalDeposits / bs.TotalAssets) * 100, 2) AS 'Deposit-to-Asset %',
    bs.NPLRatio,
    bs.CapitalAdequacyRatio,
    bs.LiquidityRatio,
    -- Age of bank
    DATEDIFF(YEAR, cb.EstablishedDate, GETDATE()) AS 'Years Operating'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30'
ORDER BY bs.TotalAssets DESC;
```

**Detailed Query Explanation:** Joining `BankingStatistics` to `CommercialBanks` provides descriptive attributes. The query then computes ratios using `ROUND` and calculates operational age with `DATEDIFF`. Filtering to the specified reporting date ensures consistency.
**Detailed Results Explanation:** Each row becomes a comprehensive bank fact sheet containing codes, size, ratios, and longevity, making it ideal for regulatory dossiers or presentations.

---

### Exercise 3.6: Time Series Comparisons

**Task 11:** Year-over-year inflation comparison
**Topic:** MS20761 Module 4 Lesson 4 – Compare each month’s inflation with the same month last year
**Beginner Explanation:** This self-join pairs each current observation with the value one year earlier so you can see year-over-year changes row by row.

```sql
-- Current vs previous year inflation
SELECT 
        ts_current.PeriodDate AS 'Current Period',
        ts_current.DataValue AS 'Current Inflation',
        ts_previous.PeriodDate AS 'Previous Year',
        ts_previous.DataValue AS 'Previous Inflation',
        (ts_current.DataValue - ts_previous.DataValue) AS 'Change',
        ei.IndicatorName
FROM TimeSeriesData ts_current
INNER JOIN EconomicIndicators ei ON ts_current.IndicatorID = ei.IndicatorID
INNER JOIN TimeSeriesData ts_previous ON 
        ts_previous.IndicatorID = ts_current.IndicatorID
        AND ts_previous.PeriodDate = DATEADD(YEAR, -1, ts_current.PeriodDate)
WHERE ei.IndicatorCode = 'INF-RATE'
    AND ts_current.PeriodDate >= '2024-01-01'
ORDER BY ts_current.PeriodDate;
```

**Detailed Query Explanation:** The query aliases `TimeSeriesData` twice: once for the current year, once for the prior year. The join condition matches indicator IDs and requires the previous row’s `PeriodDate` to be exactly one year earlier via `DATEADD`. Subtracting the two values computes the change.
**Detailed Results Explanation:** Each row displays the current inflation reading, last year’s figure, and the difference, enabling immediate YOY analysis without manual calculations.

---

### Exercise 3.7: Data Quality Analysis

**Task 12:** Track data revisions
**Topic:** MS20761 Module 4 Lesson 1 – Track provisional and revised data points with context
**Beginner Explanation:** This query lists every observation that was provisional or revised, along with indicator and source info, so you can monitor data quality.

```sql
-- Indicators with revision history
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    ts.RevisionNumber,
    ts.IsProvisional,
    ts.IsRevised,
    ds.SourceName,
    ts.CollectionDate
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
INNER JOIN DataSources ds ON ts.DataSourceID = ds.DataSourceID
WHERE ts.RevisionNumber > 0 OR ts.IsProvisional = 1
ORDER BY ei.IndicatorCode, ts.PeriodDate, ts.RevisionNumber;
```

**Detailed Query Explanation:** Joining to `EconomicIndicators` and `DataSources` adds descriptive context, while the `WHERE` clause captures rows where a revision occurred or the data is flagged provisional. Sorting by indicator, date, and revision number makes the history easy to follow.
**Detailed Results Explanation:** The output highlights which series require follow-up, showing when data was collected, whether it has been revised, and which source supplied it.

---

### Exercise 3.8: Report Production Workflow

**Task 13:** Published reports with full details
**Topic:** MS20761 Module 4 Lesson 3 – List published reports alongside their type and access level
**Beginner Explanation:** This join adds the report type name and a clear Public/Internal label so you can see all published outputs at a glance.

```sql
-- Complete report information
SELECT 
    mr.ReportTitle,
    rt.ReportName AS 'Report Type',
    mr.ReportPeriod,
    mr.AuthorName,
    mr.DivisionName,
    mr.PublicationDate,
    mr.Status,
    CASE WHEN mr.IsPublic = 1 THEN 'Public' ELSE 'Internal' END AS 'Access Level'
FROM MacroeconomicReports mr
INNER JOIN ReportTypes rt ON mr.ReportTypeID = rt.ReportTypeID
WHERE mr.Status = 'Published'
ORDER BY mr.PublicationDate DESC;
```

**Detailed Query Explanation:** Joining `MacroeconomicReports` to `ReportTypes` supplies the descriptive type label. The `CASE` expression converts the numeric `IsPublic` flag into a friendly phrase, and filtering by `Status = 'Published'` keeps only finalized documents.
**Detailed Results Explanation:** You’ll get a reverse-chronological catalog of published reports with author, division, period, and access level—ideal for distribution logs or website updates.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 3.9: Comprehensive Economic Dashboard

**Task 14:** Multi-indicator economic snapshot
**Topic:** MS20761 Module 4 Lesson 1 & Module 13 Lesson 1 – Build a one-row-per-indicator dashboard with the latest values
**Beginner Explanation:** This advanced query joins all metadata tables and uses a window function to pull only the most recent observation for each published indicator.

```sql
-- Latest values for all key indicators by category
SELECT 
    ic.CategoryName,
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.DataValue,
    ei.UnitOfMeasure,
    ts.PeriodDate,
    ds.SourceName,
    df.FrequencyName
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
LEFT JOIN (
    -- Get latest value for each indicator
    SELECT 
        IndicatorID,
        DataValue,
        PeriodDate,
        ROW_NUMBER() OVER (PARTITION BY IndicatorID ORDER BY PeriodDate DESC) AS rn
    FROM TimeSeriesData
) ts ON ei.IndicatorID = ts.IndicatorID AND ts.rn = 1
WHERE ei.IsPublished = 1
ORDER BY ic.CategoryName, ei.IndicatorCode;
```

**Detailed Query Explanation:** The subquery ranks observations per indicator, and the outer `LEFT JOIN` keeps only the latest (`rn = 1`). Joining to categories, sources, and frequencies enriches the output, while `IsPublished = 1` filters out unpublished series.
**Detailed Results Explanation:** The result is a publication-ready dashboard listing each published indicator once, along with its freshest value, unit, source, and category grouping.

---

### Exercise 3.10: Banking Sector Trend Analysis

**Task 15:** Quarterly banking sector evolution
**Topic:** MS20761 Module 13 Lesson 2 – Analyze quarter-over-quarter bank trends with window functions
**Beginner Explanation:** This query uses `LAG` to pull the previous quarter’s assets per bank so you can calculate growth percentages across 2024.

```sql
-- Banking sector trends across quarters
SELECT 
    cb.BankName,
    bs.ReportingDate,
    bs.ReportingYear,
    bs.ReportingQuarter,
    bs.TotalAssets,
    bs.TotalLoans,
    bs.TotalDeposits,
    bs.NPLRatio,
    bs.CapitalAdequacyRatio,
    -- Quarter-over-quarter growth
    LAG(bs.TotalAssets) OVER (PARTITION BY cb.BankID ORDER BY bs.ReportingDate) AS 'Previous Q Assets',
    ROUND(
        ((bs.TotalAssets - LAG(bs.TotalAssets) OVER (PARTITION BY cb.BankID ORDER BY bs.ReportingDate)) 
        / NULLIF(LAG(bs.TotalAssets) OVER (PARTITION BY cb.BankID ORDER BY bs.ReportingDate), 0)) * 100, 
        2
    ) AS 'Asset Growth %'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingYear = 2024
ORDER BY cb.BankName, bs.ReportingDate;
```

**Detailed Query Explanation:** The join attaches bank names, while the window function `LAG` looks at the prior row within each bank’s time-ordered data. The expression computes percentage growth safely via `NULLIF` to avoid division by zero. Restricting to 2024 keeps the trend focused.
**Detailed Results Explanation:** For each bank-quarter combination, you’ll see current metrics alongside last quarter’s assets and the computed growth rate, enabling trend analysis without exporting to another tool.

---

### Exercise 3.11: Data Dissemination Tracking

**Task 16:** Complete dissemination log
**Topic:** MS20761 Module 4 Lesson 3 – Maintain a dissemination log with optional report links
**Beginner Explanation:** This LEFT JOIN keeps every dissemination entry visible while adding report titles and types when a matching record exists, giving compliance teams full context.
```sql
-- Track all data dissemination with full context
SELECT 
    dd.DisseminationDate,
    dd.DisseminationType,
    dd.RecipientType,
    dd.RecipientName,
    dd.DataCategory,
    rt.ReportName,
    mr.ReportTitle,
    dd.DeliveryMethod,
    dd.ApprovedBy,
    dd.Purpose
FROM DataDissemination dd
LEFT JOIN MacroeconomicReports mr ON dd.ReportID = mr.ReportID
LEFT JOIN ReportTypes rt ON mr.ReportTypeID = rt.ReportTypeID
ORDER BY dd.DisseminationDate DESC;
```

---

### Exercise 3.12: Data Collection Efficiency Analysis

**Task 17:** Source performance metrics
**Topic:** MS20761 Module 6 Lesson 1 – Evaluate data source coverage and timeliness
**Beginner Explanation:** This aggregate query counts how many indicators each source provides and measures how quickly they deliver data since 2024.

```sql
-- Analyze data sources by number of indicators and timeliness
SELECT 
    ds.SourceCode,
    ds.SourceName,
    ds.SourceType,
    COUNT(DISTINCT ei.IndicatorID) AS 'Indicators Provided',
    COUNT(DISTINCT ts.TimeSeriesID) AS 'Data Points',
    MIN(ts.CollectionDate) AS 'First Collection',
    MAX(ts.CollectionDate) AS 'Latest Collection',
    AVG(DATEDIFF(DAY, ts.PeriodDate, ts.CollectionDate)) AS 'Avg Collection Lag (Days)'
FROM DataSources ds
INNER JOIN EconomicIndicators ei ON ds.DataSourceID = ei.DataSourceID
LEFT JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID
WHERE ts.PeriodDate >= '2024-01-01'
GROUP BY ds.SourceCode, ds.SourceName, ds.SourceType
ORDER BY COUNT(DISTINCT ei.IndicatorID) DESC;
```

**Detailed Query Explanation:** The join to indicators counts how many series each source owns, and the left join to time series pulls actual submissions. Aggregate functions compute totals, min/max collection dates, and average collection lag, with a filter keeping only recent periods.
**Detailed Results Explanation:** One row per source shows coverage breadth and timeliness metrics, which helps prioritize follow-ups with slower providers or celebrate top performers.

---

### Exercise 3.13: Hierarchical Category Analysis

**Task 18:** Parent-child category relationships
**Topic:** MS20761 Module 4 Lesson 4 – Visualize category hierarchies and the indicators under each
**Beginner Explanation:** This self-join shows how parent and child categories relate, while aggregations count indicators and list their codes.

```sql
-- Show indicator categories with parent-child relationships
SELECT 
    parent.CategoryName AS 'Parent Category',
    child.CategoryName AS 'Sub-Category',
    COUNT(ei.IndicatorID) AS 'Number of Indicators',
    STRING_AGG(ei.IndicatorCode, ', ') AS 'Indicator Codes'
FROM IndicatorCategories child
LEFT JOIN IndicatorCategories parent ON child.ParentCategoryID = parent.CategoryID
LEFT JOIN EconomicIndicators ei ON child.CategoryID = ei.CategoryID
GROUP BY parent.CategoryName, child.CategoryName
ORDER BY parent.CategoryName, child.CategoryName;
```

**Detailed Query Explanation:** The `LEFT JOIN` back to `IndicatorCategories` brings in the parent name (if any), while another left join counts and concatenates indicators tied to each child category. Grouping by parent/child combination enables the aggregate calculations.
**Detailed Results Explanation:** Each row lists a sub-category, its parent category, how many indicators belong to it, and the codes, delivering a ready-made taxonomy overview.

---

## Practice Exercises (Do It Yourself)

### Beginner Level
1. Join ResearchStaff with their division to show all staff members
2. Display all reports with their type names
3. Show countries with their regions and currencies
4. List all data sources with contact information

### Intermediate Level
5. Create a report showing all monetary indicators with their latest values
6. Calculate average banking ratios across all banks for Q3 2024
7. Show all indicators collected monthly from external sources
8. Display banking statistics with bank establishment dates

### Advanced Level
9. Create a comprehensive indicator catalog with all metadata
10. Analyze data collection patterns by source and frequency
11. Track revision history for all indicators in November 2024
12. Build a banking sector market share analysis

---

## Real-World Scenarios

### Scenario 1: Monthly Statistical Bulletin Preparation
Your supervisor asks you to compile the key economic indicators for the November 2024 bulletin. Write a query that shows:
- Indicator name and category
- Latest value with unit of measure
- Data source
- Whether data is provisional

### Scenario 2: Banking Supervision Quarterly Report
The Banking Supervision division needs a comprehensive view of all banks' performance for Q3 2024. Include:
- Bank name, type, and contact details
- All key financial ratios
- Comparative ranking by total assets

### Scenario 3: External Data Quality Audit
The Data Management Division needs to audit data quality from external sources. Create a query showing:
- External data sources
- Number of indicators they provide
- Average collection lag time
- Any missing or delayed submissions

---

## Key Takeaways

✅ **INNER JOIN Basics:**
- Matches rows from two tables based on a condition
- Returns only rows with matching data in both tables
- Most common join type for related data

✅ **Join Syntax:**
```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.key = table2.key
```

✅ **Multiple Joins:**
- Can join 3+ tables in a single query
- Each JOIN adds another table to the result set
- Order matters for readability, not results

✅ **Best Practices:**
- Always use table aliases for clarity (ei, ts, ds)
- Specify which table each column comes from
- Filter joined data with WHERE clause
- Consider join performance with indexes

✅ **CBL-Specific Applications:**
- Link indicators to their metadata
- Combine time series with source information
- Join banking data with bank details
- Connect reports to their classifications

---

## Common Mistakes to Avoid

❌ Forgetting the ON clause (causes Cartesian product)  
❌ Using wrong join keys (data integrity issues)  
❌ Not using table aliases with column names  
❌ Filtering in ON clause instead of WHERE  
❌ Joining too many tables without need

---

## Performance Tips

💡 **Join on indexed columns** (primary/foreign keys)  
💡 **Filter early** - use WHERE to reduce dataset size  
💡 **Limit columns** - select only what you need  
💡 **Test with small datasets** first  
💡 **Check execution plans** for optimization

---

## Next Steps

Proceed to **Module 4: Advanced JOIN Operations** where you will learn:
- LEFT/RIGHT OUTER JOINs
- Finding missing data
- FULL OUTER JOINs
- Self-joins for hierarchical data

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 3*
