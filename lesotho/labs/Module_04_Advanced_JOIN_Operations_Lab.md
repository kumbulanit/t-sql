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

---

**Task 2:** Indicators with optional latest values
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

---

### Exercise 4.2: Finding Missing Data

**Task 3:** Banks without Q3 2024 submissions
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

---

**Task 4:** Indicators without recent data
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

---

### Exercise 4.3: RIGHT OUTER JOIN

**Task 5:** All data sources with indicator counts
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

---

## INTERMEDIATE SECTION (Optional)

### Exercise 4.4: FULL OUTER JOIN

**Task 6:** Complete indicator coverage analysis
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

---

### Exercise 4.5: Self-Joins

**Task 7:** Compare indicator values across periods
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

---

**Task 8:** Hierarchical category analysis
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

---

### Exercise 4.6: Complex Outer Join Scenarios

**Task 9:** Banking sector gap analysis
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

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 4.7: Data Completeness Dashboard

**Task 10:** Comprehensive data completeness report
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

---

### Exercise 4.8: Advanced Self-Join Analysis

**Task 11:** Multi-period banking comparison
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

---

### Exercise 4.9: CROSS JOIN for Scenario Analysis

**Task 12:** Generate all possible indicator-period combinations
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
