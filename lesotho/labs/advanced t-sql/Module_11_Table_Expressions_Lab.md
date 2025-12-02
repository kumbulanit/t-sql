# Module 11: Table Expressions (CTEs, Views, Inline TVFs)
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-10 completed  
**Target Audience:** Analysts refactoring complex SELECT statements into reusable virtual tables

---

## Learning Objectives
1. Build Common Table Expressions (CTEs) to stage calculations
2. Chain multiple CTEs for readability
3. Create inline table-valued functions (iTVFs) for parameterised result sets
4. Draft views that encapsulate frequently used joins
5. Understand scope rules for table expressions
6. Document usage patterns for downstream teams

---

## BEGINNER SECTION (Required)

### Exercise 11.1: Single CTE

**Task 1:** Latest observation per indicator  
**Topic:** MS20761 Module 11 Lesson 1 – ROW_NUMBER in a CTE  
**Beginner Explanation:** A CTE assigns row numbers inside each indicator partition, allowing you to filter to the newest entry without nested subqueries.

```sql
WITH LatestSeries AS (
    SELECT 
        ts.TimeSeriesID,
        ts.IndicatorID,
        ts.PeriodDate,
        ts.DataValue,
        ROW_NUMBER() OVER (PARTITION BY ts.IndicatorID ORDER BY ts.PeriodDate DESC) AS rn
    FROM TimeSeriesData ts
)
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ls.PeriodDate,
    ls.DataValue
FROM LatestSeries ls
JOIN EconomicIndicators ei ON ei.IndicatorID = ls.IndicatorID
WHERE ls.rn = 1
ORDER BY ei.IndicatorCode;
```

**Detailed Explanation:** The CTE isolates ranking logic; the outer query simply filters to `rn = 1` for clarity.

---

**Task 2:** Break down CPI contributions  
**Topic:** MS20761 Module 11 Lesson 1 – Multiple aggregates using CTE  
**Beginner Explanation:** Stage aggregate totals in one CTE and compute percentage contributions in the outer SELECT.

```sql
WITH CPIContributions AS (
    SELECT 
        ts.IndicatorID,
        SUM(ts.DataValue) AS TotalContribution
    FROM TimeSeriesData ts
    JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorCode LIKE 'CPI-%'
      AND ts.PeriodYear = 2024
    GROUP BY ts.IndicatorID
)
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    cc.TotalContribution,
    ROUND((cc.TotalContribution / NULLIF(
        (SELECT SUM(TotalContribution) FROM CPIContributions), 0
    )) * 100, 2) AS SharePercent
FROM CPIContributions cc
JOIN EconomicIndicators ei ON ei.IndicatorID = cc.IndicatorID
ORDER BY SharePercent DESC;
```

**Detailed Explanation:** Reusing the CTE inside the outer SELECT avoids recalculating totals for every row.

---

### Exercise 11.2: Nested CTEs and Views

**Task 3:** Chain reusable logic  
**Topic:** MS20761 Module 11 Lesson 2 – Multiple CTE blocks  
**Beginner Explanation:** The first CTE filters validated bank submissions; the second computes growth; the final SELECT presents results.

```sql
WITH ValidatedReturns AS (
    SELECT *
    FROM BankingStatistics
    WHERE IsValidated = 1
),
QuarterlyTotals AS (
    SELECT 
        BankID,
        DATEPART(QUARTER, ReportingDate) AS QuarterNumber,
        ReportingYear,
        SUM(TotalLoans) AS QuarterlyLoans
    FROM ValidatedReturns
    GROUP BY BankID, ReportingYear, DATEPART(QUARTER, ReportingDate)
)
SELECT 
    cb.BankName,
    qt.ReportingYear,
    qt.QuarterNumber,
    qt.QuarterlyLoans,
    LAG(qt.QuarterlyLoans) OVER (PARTITION BY cb.BankName ORDER BY qt.ReportingYear, qt.QuarterNumber) AS PriorQuarterLoans
FROM QuarterlyTotals qt
JOIN CommercialBanks cb ON cb.BankID = qt.BankID
ORDER BY cb.BankName, qt.ReportingYear, qt.QuarterNumber;
```

**Detailed Explanation:** Chaining CTEs keeps filtering and aggregation logic modular.

---

**Task 4:** Create a view for dissemination monitoring  
**Topic:** MS20761 Module 11 Lesson 3 – View definition best practices  
**Beginner Explanation:** Encapsulate a frequent join so teams can simply `SELECT * FROM vwLatestDisseminations` without rewriting filters.

```sql
CREATE OR ALTER VIEW dbo.vwLatestDisseminations
AS
SELECT 
    dd.DisseminationID,
    dd.DisseminationDate,
    dd.DataCategory,
    dd.RecipientType,
    dd.RecipientName,
    mr.ReportTitle,
    mr.ReportPeriod
FROM DataDissemination dd
LEFT JOIN MacroeconomicReports mr ON mr.ReportID = dd.ReportID
WHERE dd.DisseminationDate >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE));
```

**Detailed Explanation:** The view restricts to the last six months, providing a load-balanced data source for portals.

---

### Exercise 11.3: Inline Table-Valued Function

**Task 5:** Parameterized macro series  
**Topic:** MS20761 Module 11 Lesson 4 – iTVF returning filtered time series  
**Beginner Explanation:** Wrap a commonly requested query (series by code and date range) into a function that other queries call.

```sql
CREATE OR ALTER FUNCTION dbo.ufn_GetIndicatorSeries
(
    @IndicatorCode NVARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        ts.PeriodDate,
        ts.DataValue,
        ts.IsProvisional,
        ts.IsRevised
    FROM TimeSeriesData ts
    JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorCode = @IndicatorCode
      AND ts.PeriodDate BETWEEN @StartDate AND @EndDate
);
GO

-- Usage example
SELECT *
FROM dbo.ufn_GetIndicatorSeries('FX-RESERVES', '2023-01-01', '2024-12-31')
ORDER BY PeriodDate;
```

**Detailed Explanation:** Inline TVFs simply return a SELECT statement, inheriting performance benefits compared to multi-statement TVFs.

---

## Testing Checklist
- [ ] Exercise 11.1 Task 1
- [ ] Exercise 11.1 Task 2
- [ ] Exercise 11.2 Task 3
- [ ] Exercise 11.2 Task 4
- [ ] Exercise 11.3 Task 5

Document execution notes plus any required permissions (CREATE VIEW/FUNCTION) in `sql_validation_report.md`.
