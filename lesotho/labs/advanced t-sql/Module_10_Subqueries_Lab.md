# Module 10: Using Subqueries
**Primary Topic:** Module 10: Using Subqueries

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-9 completed  
**Target Audience:** Analysts performing conditional lookups and complex filtering

---

## Learning Objectives
1. Differentiate scalar, multi-value, and correlated subqueries
2. Replace manual lookups with subqueries to enforce referential logic
3. Use EXISTS/NOT EXISTS for compliance checks
4. Build inline derived tables for ranking benchmarks
5. Combine aggregation subqueries with outer SELECT clauses
6. Document performance considerations when subqueries run per row

---

## BEGINNER SECTION (Required)

### Exercise 10.1: Scalar subqueries

**Task 1:** Latest CPI baseline  
**Topic:** MS20761 Module 10 Lesson 1 – Use scalar subquery in SELECT list  
**Beginner Explanation:** Tie each CPI component to the latest headline CPI value so the percentage of baseline displays inline.

```sql
-- CPI components versus headline
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    (SELECT TOP (1) DataValue
     FROM TimeSeriesData tsh
     JOIN EconomicIndicators eih ON eih.IndicatorID = tsh.IndicatorID
     WHERE eih.IndicatorCode = 'CPI-ALL'
     ORDER BY tsh.PeriodDate DESC) AS LatestHeadlineCPI,
    ROUND((ts.DataValue / NULLIF((SELECT TOP (1) DataValue
                                  FROM TimeSeriesData tsc
                                  JOIN EconomicIndicators eic ON eic.IndicatorID = tsc.IndicatorID
                                  WHERE eic.IndicatorCode = 'CPI-ALL'
                                  ORDER BY tsc.PeriodDate DESC), 0)) * 100, 2) AS PercentOfHeadline
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode LIKE 'CPI-%'
  AND ts.PeriodDate = '2024-09-01';
```

**Detailed Explanation:** A scalar subquery fetches the most recent headline CPI; referencing it twice supplies both the baseline and percentage calculation without joins.

---

**Task 2:** Pull default data source  
**Topic:** MS20761 Module 10 Lesson 1 – Scalar subquery in WHERE clause  
**Beginner Explanation:** Filter time series rows to only those matching the indicator’s configured data source.

```sql
-- Keep rows whose source matches the indicator setup
SELECT 
    ts.TimeSeriesID,
    ts.IndicatorID,
    ts.PeriodDate,
    ts.DataSourceID
FROM TimeSeriesData ts
WHERE ts.DataSourceID = (
    SELECT ei.DataSourceID
    FROM EconomicIndicators ei
    WHERE ei.IndicatorID = ts.IndicatorID
);
```

**Detailed Explanation:** The correlated scalar subquery returns the reference data source for each indicator, ensuring only aligned entries appear.

---

### Exercise 10.2: Multi-value subqueries

**Task 3:** Banks exceeding average assets  
**Topic:** MS20761 Module 10 Lesson 2 – IN clause with subquery  
**Beginner Explanation:** Compare each bank’s total assets to the sector average without hard-coding thresholds.

```sql
-- Identify banks above sector average assets
SELECT 
    cb.BankName,
    bs.ReportingDate,
    bs.TotalAssets
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingDate = '2024-09-30'
  AND bs.TotalAssets > (
        SELECT AVG(bs2.TotalAssets)
        FROM BankingStatistics bs2
        WHERE bs2.ReportingDate = '2024-09-30'
    )
ORDER BY bs.TotalAssets DESC;
```

**Detailed Explanation:** The subquery calculates the average for the selected period; the outer query filters to banks above that average.

---

**Task 4:** Indicators missing quality checks  
**Topic:** MS20761 Module 10 Lesson 2 – NOT IN guard  
**Beginner Explanation:** Show indicator metadata where no quality check has ever passed, helping governance teams focus efforts.

```sql
-- Which indicators never passed a quality check?
SELECT IndicatorCode, IndicatorName, CategoryID
FROM EconomicIndicators ei
WHERE ei.IndicatorID NOT IN (
    SELECT DISTINCT dq.IndicatorID
    FROM DataQualityChecks dq
    WHERE dq.CheckResult = 'Pass'
);
```

**Detailed Explanation:** `NOT IN` identifies orphan indicators lacking passing records, surfacing compliance gaps.

---

### Exercise 10.3: EXISTS/NOT EXISTS

**Task 5:** Validate dissemination coverage  
**Topic:** MS20761 Module 10 Lesson 3 – EXISTS for quick existence checks  
**Beginner Explanation:** Confirm which reports already have dissemination records without duplicating joins.

```sql
-- Reports that were disseminated at least once
SELECT 
    mr.ReportID,
    mr.ReportTitle,
    mr.ReportPeriod
FROM MacroeconomicReports mr
WHERE EXISTS (
    SELECT 1
    FROM DataDissemination dd
    WHERE dd.ReportID = mr.ReportID
);
```

**Detailed Explanation:** `EXISTS` stops scanning once a match is found, offering efficient verification for large tables.

---

**Task 6:** Unfulfilled external requests  
**Topic:** MS20761 Module 10 Lesson 3 – NOT EXISTS gap analysis  
**Beginner Explanation:** Identify external recipients requesting datasets that never appear in the dissemination log.

```sql
-- External requests without matching deliveries
SELECT DISTINCT dd.RequestedBy, dd.DataCategory
FROM DataDissemination dd
WHERE dd.RecipientType = 'International Organization'
  AND NOT EXISTS (
        SELECT 1
        FROM DataDissemination delivered
        WHERE delivered.RecipientName = dd.RequestedBy
          AND delivered.DataCategory = dd.DataCategory
          AND delivered.DisseminationDate >= dd.DisseminationDate
    );
```

**Detailed Explanation:** The correlated NOT EXISTS compares requested deliveries to later disseminations to ensure commitments were honored.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 10.4: Derived tables

**Task 7:** Top-performing banks per period  
**Topic:** MS20761 Module 10 Lesson 4 – Derived table with ROW_NUMBER  
**Explanation:** The inner query ranks banks by assets; the outer query filters to top performers.

```sql
SELECT 
    Ranked.ReportingDate,
    Ranked.BankName,
    Ranked.TotalAssets
FROM (
    SELECT 
        bs.ReportingDate,
        cb.BankName,
        bs.TotalAssets,
        ROW_NUMBER() OVER (PARTITION BY bs.ReportingDate ORDER BY bs.TotalAssets DESC) AS rn
    FROM BankingStatistics bs
    JOIN CommercialBanks cb ON cb.BankID = bs.BankID
    WHERE bs.ReportingYear = 2024
) Ranked
WHERE Ranked.rn <= 3
ORDER BY Ranked.ReportingDate DESC, Ranked.TotalAssets DESC;
```

**What to Look For:** Only top three banks per reporting date appear, perfect for dashboard leaderboards.

---

## Testing Checklist
- [ ] Exercise 10.1 Task 1
- [ ] Exercise 10.1 Task 2
- [ ] Exercise 10.2 Task 3
- [ ] Exercise 10.2 Task 4
- [ ] Exercise 10.3 Task 5
- [ ] Exercise 10.3 Task 6
- [ ] Exercise 10.4 Task 7

Capture query outcomes or error details in `sql_validation_report.md`.
