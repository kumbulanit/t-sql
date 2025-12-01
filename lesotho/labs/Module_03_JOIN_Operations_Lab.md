# Module 3: JOIN Operations - Querying Multiple Tables
## Central Bank of Lesotho - Data Management Division

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Beginner with optional intermediate/advanced sections  
**Prerequisites:** Modules 1-2 completed

---

## Learning Objectives
1. Understand table relationships and foreign keys
2. Master INNER JOIN operations
3. Join data from multiple sources
4. Create meaningful datasets for reporting
5. Understand join performance considerations

---

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

**Questions:**
- How many indicators are in the Monetary category?
- Which category has the most indicators?

---

**Task 2:** Combine time series data with indicator details
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

---

**Task 3:** Link banking statistics with bank names
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

---

### Exercise 3.2: Three-Table Joins

**Task 4:** Complete indicator information
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

---

**Task 5:** Time series with complete metadata
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

---

### Exercise 3.3: Joining for Report Generation

**Task 6:** Monthly Statistical Bulletin - Key Indicators
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

---

**Task 7:** Banking Sector Report
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

---

### Exercise 3.4: Filtering Joined Data

**Task 8:** External data sources only
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

---

**Task 9:** High-frequency indicators
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

---

## INTERMEDIATE SECTION (Optional)

### Exercise 3.5: Complex Multi-Table Joins

**Task 10:** Complete banking sector analysis
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

---

### Exercise 3.6: Time Series Comparisons

**Task 11:** Year-over-year inflation comparison
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

---

### Exercise 3.7: Data Quality Analysis

**Task 12:** Track data revisions
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

---

### Exercise 3.8: Report Production Workflow

**Task 13:** Published reports with full details
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

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 3.9: Comprehensive Economic Dashboard

**Task 14:** Multi-indicator economic snapshot
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

---

### Exercise 3.10: Banking Sector Trend Analysis

**Task 15:** Quarterly banking sector evolution
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

---

### Exercise 3.11: Data Dissemination Tracking

**Task 16:** Complete dissemination log
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

---

### Exercise 3.13: Hierarchical Category Analysis

**Task 18:** Parent-child category relationships
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
