# Module 2: Filtering and Sorting Data - Lab Exercise
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 75-100 minutes  
**Difficulty:** Beginner with optional intermediate/advanced sections  
**Prerequisites:** Module 1 completed, CBL_DataWarehouse database  
**Target Audience:** Economists and Statisticians conducting data analysis and statistical compilation

---

## Learning Objectives
1. Use WHERE clause to filter observations for statistical subsets and conditional analysis
2. Work with comparison operators for threshold analysis (inflation targets, prudential ratios)
3. Combine conditions with logical operators for complex economic criteria
4. Use BETWEEN for range analysis and IN for categorical filtering (country groups, indicator sets)
5. Apply pattern matching with LIKE for indicator code searching
6. Sort results with ORDER BY for time series chronological ordering and ranking
7. Handle NULL values (missing observations) common in economic datasets
8. Filter date ranges for temporal analysis and period-specific reporting

---

## Lab Setup
```sql
USE CBL_DataWarehouse;
GO
```

---

## BEGINNER SECTION (Required for All)

### Exercise 2.1: Basic WHERE Clause

**Task 1:** Find specific countries
```sql
-- Display only Lesotho's information
SELECT * FROM Countries
WHERE CountryName = 'Lesotho';
```

**Task 2:** Filter by data source type
```sql
-- Show only internal data sources
SELECT SourceCode, SourceName, SourceType
FROM DataSources
WHERE SourceType = 'Internal';
```

**Task 3:** Find active commercial banks
```sql
-- List all active banks
SELECT BankCode, BankName, BankType, City
FROM CommercialBanks
WHERE IsActive = 1;
```

---

### Exercise 2.2: Comparison Operators

**Task 4:** Find high inflation periods
```sql
-- Show months where inflation exceeded 5.5%
SELECT 
    PeriodDate,
    DataValue AS 'Inflation Rate (%)',
    IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 6  -- Inflation indicator
  AND DataValue > 5.5;
```

**Task 5:** Foreign reserves above threshold
```sql
-- Find months with reserves above $1000M
SELECT 
    PeriodDate,
    DataValue AS 'Reserves (Million USD)'
FROM TimeSeriesData
WHERE IndicatorID = 16
  AND DataValue >= 1000;
```

**Task 6:** Staff hired recently
```sql
-- Show staff hired after 2020
SELECT 
    FirstName + ' ' + LastName AS 'Staff Name',
    JobTitle,
    HireDate,
    Division
FROM ResearchStaff
WHERE HireDate > '2020-12-31';
```

---

### Exercise 2.3: Combining Conditions (AND)

**Task 7:** Filter banking statistics
```sql
-- Find banks with high NPL and low CAR
SELECT 
    BankID,
    ReportingDate,
    NPLRatio,
    CapitalAdequacyRatio
FROM BankingStatistics
WHERE NPLRatio >= 5.0
  AND CapitalAdequacyRatio < 15.0;
```

**Task 8:** Published public reports
```sql
-- Show published public reports
SELECT 
    ReportTitle,
    PublicationDate,
    IsPublic
FROM MacroeconomicReports
WHERE Status = 'Published'
  AND IsPublic = 1;
```

---

### Exercise 2.4: Combining Conditions (OR)

**Task 9:** Multiple bank types
```sql
-- Show commercial banks OR development banks
SELECT BankName, BankType, IsActive
FROM CommercialBanks
WHERE BankType = 'Commercial Bank'
   OR BankType = 'Development Bank';
```

**Task 10:** Urgent report statuses
```sql
-- Find reports in draft or under review
SELECT 
    ReportTitle,
    Status,
    DraftDate,
    ReviewDate
FROM MacroeconomicReports
WHERE Status = 'Draft'
   OR Status = 'Under Review';
```

---

### Exercise 2.5: BETWEEN Operator

**Task 11:** Date range filtering
```sql
-- Get inflation data for Q4 2024
SELECT 
    PeriodDate,
    DataValue AS 'Inflation Rate',
    PeriodMonth
FROM TimeSeriesData
WHERE IndicatorID = 6
  AND PeriodDate BETWEEN '2024-10-01' AND '2024-11-30';
```

**Task 12:** Banks by asset size
```sql
-- Medium-sized banks (assets between 7B and 9B)
SELECT 
    BankID,
    TotalAssets,
    TotalLoans,
    ReportingDate
FROM BankingStatistics
WHERE TotalAssets BETWEEN 7000 AND 9000
  AND ReportingDate = '2024-09-30';
```

---

### Exercise 2.6: IN Operator

**Task 13:** Multiple specific values
```sql
-- Get data from selected months
SELECT 
    PeriodDate,
    PeriodMonth,
    DataValue
FROM TimeSeriesData
WHERE IndicatorID = 6
  AND PeriodMonth IN (9, 10, 11);  -- Sep, Oct, Nov
```

**Task 14:** Specific indicator categories
```sql
-- Show indicators in key categories
SELECT 
    IndicatorCode,
    IndicatorName,
    CategoryID
FROM EconomicIndicators
WHERE CategoryID IN (2, 3, 4);  -- Monetary, Banking, External
```

---

### Exercise 2.7: LIKE Operator (Pattern Matching)

**Task 15:** Search by name pattern
```sql
-- Find all indicators with "Rate" in the name
SELECT 
    IndicatorCode,
    IndicatorName,
    UnitOfMeasure
FROM EconomicIndicators
WHERE IndicatorName LIKE '%Rate%';
```

**Task 16:** Email domain search
```sql
-- Find staff with centralbank.org.ls emails
SELECT 
    FirstName + ' ' + LastName AS 'Staff Name',
    Email,
    JobTitle
FROM ResearchStaff
WHERE Email LIKE '%@centralbank.org.ls';
```

---

### Exercise 2.8: ORDER BY Clause

**Task 17:** Sort by date
```sql
-- Recent inflation data, newest first
SELECT 
    PeriodDate,
    DataValue AS 'Inflation Rate',
    IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 6
ORDER BY PeriodDate DESC;
```

**Task 18:** Sort by multiple columns
```sql
-- Staff list ordered by division and name
SELECT 
    Division,
    FirstName + ' ' + LastName AS 'Name',
    JobTitle
FROM ResearchStaff
ORDER BY Division, LastName, FirstName;
```

---

### Exercise 2.9: NULL Handling

**Task 19:** Find records with missing data
```sql
-- Indicators without description
SELECT 
    IndicatorCode,
    IndicatorName,
    Description
FROM EconomicIndicators
WHERE Description IS NULL;
```

**Task 20:** Records with data present
```sql
-- Banks with contact information
SELECT 
    BankName,
    ContactPerson,
    Email
FROM CommercialBanks
WHERE ContactPerson IS NOT NULL
  AND Email IS NOT NULL;
```

---

## INTERMEDIATE SECTION (Optional)

### Exercise 2.10: Complex Filtering

**Task 21:** Multi-condition banking analysis
```sql
-- High-performing banks with good ratios
SELECT 
    b.BankName,
    bs.TotalAssets,
    bs.CapitalAdequacyRatio,
    bs.NPLRatio,
    bs.LiquidityRatio
FROM BankingStatistics bs
JOIN CommercialBanks b ON bs.BankID = b.BankID
WHERE bs.ReportingDate = '2024-09-30'
  AND bs.CapitalAdequacyRatio >= 15
  AND bs.NPLRatio < 5
  AND bs.LiquidityRatio > 30
ORDER BY bs.TotalAssets DESC;
```

---

### Exercise 2.11: Date Functions with Filtering

**Task 22:** Recent data submissions
```sql
-- External data received in last 60 days
SELECT 
    ds.SourceName,
    eds.SubmissionDate,
    eds.DataCategory,
    eds.ProcessingStatus,
    DATEDIFF(DAY, eds.SubmissionDate, GETDATE()) AS 'Days Ago'
FROM ExternalDataSubmissions eds
JOIN DataSources ds ON eds.DataSourceID = ds.DataSourceID
WHERE eds.SubmissionDate >= DATEADD(DAY, -60, GETDATE())
ORDER BY eds.SubmissionDate DESC;
```

---

### Exercise 2.12: Negation with NOT

**Task 23:** Exclude specific conditions
```sql
-- Indicators NOT in real sector category
SELECT 
    IndicatorCode,
    IndicatorName,
    CategoryID
FROM EconomicIndicators
WHERE CategoryID NOT IN (7, 9)  -- Exclude real sector
  AND IsActive = 1
ORDER BY IndicatorName;
```

---

### Exercise 2.13: Combined Pattern Matching

**Task 24:** Advanced LIKE patterns
```sql
-- Find specific data source patterns
SELECT 
    SourceCode,
    SourceName,
    SourceType
FROM DataSources
WHERE SourceCode LIKE 'CBL%'  -- Starts with CBL
   OR SourceName LIKE '%Bank%'  -- Contains Bank
ORDER BY SourceCode;
```

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 2.14: Complex Business Logic

**Task 25:** Risk assessment filtering
```sql
-- Banks requiring supervisory attention
SELECT 
    b.BankName,
    bs.ReportingDate,
    bs.CapitalAdequacyRatio,
    bs.NPLRatio,
    bs.LiquidityRatio,
    CASE 
        WHEN bs.CapitalAdequacyRatio < 10 THEN 'Critical - Below Minimum CAR'
        WHEN bs.NPLRatio > 10 THEN 'High Risk - Excessive NPLs'
        WHEN bs.LiquidityRatio < 20 THEN 'Warning - Low Liquidity'
        ELSE 'Normal'
    END AS 'Risk Assessment'
FROM BankingStatistics bs
JOIN CommercialBanks b ON bs.BankID = b.BankID
WHERE bs.ReportingDate = '2024-09-30'
  AND (
    bs.CapitalAdequacyRatio < 12
    OR bs.NPLRatio > 7
    OR bs.LiquidityRatio < 25
  )
ORDER BY bs.CapitalAdequacyRatio;
```

---

### Exercise 2.15: Time Series Trend Analysis

**Task 26:** Identify inflation trends
```sql
-- Months with significant inflation changes
WITH MonthlyInflation AS (
    SELECT 
        PeriodDate,
        DataValue,
        LAG(DataValue) OVER (ORDER BY PeriodDate) AS PreviousMonth
    FROM TimeSeriesData
    WHERE IndicatorID = 6
)
SELECT 
    PeriodDate,
    DataValue AS CurrentInflation,
    PreviousMonth,
    (DataValue - PreviousMonth) AS Change,
    CASE 
        WHEN (DataValue - PreviousMonth) > 0.5 THEN 'Sharp Increase'
        WHEN (DataValue - PreviousMonth) < -0.5 THEN 'Sharp Decrease'
        ELSE 'Stable'
    END AS Trend
FROM MonthlyInflation
WHERE PreviousMonth IS NOT NULL
  AND ABS(DataValue - PreviousMonth) >= 0.3
ORDER BY PeriodDate DESC;
```

---

### Exercise 2.16: Data Quality Filtering

**Task 27:** Identify provisional vs final data
```sql
-- Compare provisional and final submissions
SELECT 
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    ts.RevisionNumber,
    ts.IsProvisional,
    ts.IsRevised,
    ts.CollectionDate
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE (ts.IsProvisional = 1 OR ts.RevisionNumber > 0)
  AND ts.PeriodDate >= '2024-09-01'
ORDER BY ei.IndicatorName, ts.PeriodDate, ts.RevisionNumber;
```

---

## Practice Exercises (Do It Yourself)

### Beginner Level
1. Find all reports published in 2024
2. List banks established after 2000
3. Show indicators measured in "Percentage"
4. Find all quarterly frequency indicators

### Intermediate Level
5. Get all banking statistics where total loans exceed 5000 million
6. Find staff in "Data Management Division" with Master's degrees
7. Show external data sources from Government Agencies
8. List reports awaiting approval (Status = 'Under Review')

### Advanced Level
9. Find months where both inflation > 5% and reserves > 1000M USD
10. Identify banks with declining deposit trends (compare Q2 vs Q3 2024)
11. Analyze which data sources have the most delayed submissions
12. Find all seasonally adjusted indicators in monetary category

---

## Real-World Scenarios

### Scenario 1: Inflation Target Monitoring
The Monetary Policy Committee wants to see all months where inflation exceeded the upper target band of 6%. Write a query to provide this information with relevant context.

### Scenario 2: Banking Sector Health Check
Create a query to identify banks that need immediate supervisory attention based on key ratios (CAR < 12%, NPL > 8%, or Liquidity < 25%).

### Scenario 3: Data Collection Audit
The Data Management Division needs to audit all external data submissions from the past quarter. Filter for submissions that are still "Pending" or "In Progress".

---

## Key Takeaways

✅ **WHERE Clause:**
- Filters rows before returning results
- Essential for focused data analysis
- Can combine multiple conditions

✅ **Comparison Operators:**
- = (equal), <> or != (not equal)
- <, >, <=, >= for numerical/date comparisons
- Always consider data types

✅ **Logical Operators:**
- AND: All conditions must be true
- OR: At least one condition must be true
- NOT: Negates a condition

✅ **Special Operators:**
- BETWEEN: Range filtering (inclusive)
- IN: Multiple specific values
- LIKE: Pattern matching (%, _)
- IS NULL / IS NOT NULL: Handle missing data

✅ **ORDER BY:**
- Sorts result set
- ASC (ascending) is default
- DESC for descending
- Can sort by multiple columns

---

## Common Mistakes to Avoid

❌ Using = instead of IS NULL for NULL checks  
❌ Forgetting that LIKE is case-insensitive by default  
❌ Not using parentheses with AND/OR combinations  
❌ Comparing dates without considering time component  
❌ Using BETWEEN with exclusive ranges

---

## Next Steps

Proceed to **Module 3: Querying Multiple Tables** where you will learn:
- Understanding table relationships
- INNER JOIN operations
- Combining data from multiple tables
- Working with foreign keys

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 2*
