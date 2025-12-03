# Module 9: Advanced Grouping and Aggregation
**Primary Topic:** Module 9: Advanced Grouping and Aggregation

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-8 completed  
**Target Audience:** Analysts producing sector summaries and peer comparisons

---

## Learning Objectives
1. Layer multiple aggregates in a single SELECT
2. Apply HAVING for statistical quality thresholds
3. Use GROUP BY with expressions (date parts, CASE) for fiscal periods
4. Combine aggregates with window functions for validation
5. Capture dispersion metrics (variance, std dev) for risk teams
6. Build reusable summary templates for economic bulletins

---

## BEGINNER SECTION (Required)

### Exercise 9.1: Multi-measure summaries

**Task 1:** Treasury deposit posture  
**Topic:** MS20761 Module 9 Lesson 1 – Aggregate deposits and funds concentration  
**Beginner Explanation:** Understand total banking deposits, the largest contributor, and concentration ratio on the latest quarter.

```sql
-- Sector-wide deposit snapshot
SELECT 
    bs.ReportingDate,
    COUNT(DISTINCT bs.BankID) AS BanksReporting,
    SUM(bs.TotalDeposits) AS TotalDeposits,
    MAX(bs.TotalDeposits) AS LargestSingleBank,
    SUM(bs.TotalDeposits) - MAX(bs.TotalDeposits) AS DepositsExclLargest,
    ROUND((MAX(bs.TotalDeposits) / NULLIF(SUM(bs.TotalDeposits), 0)) * 100, 2) AS LargestSharePct
FROM BankingStatistics bs
WHERE bs.ReportingDate = '2024-09-30'
GROUP BY bs.ReportingDate;
```

**Detailed Explanation:** Standard aggregates summarise the sector, while the ratio highlights concentration risk for supervisors.

---

**Task 2:** Indicator counts by status  
**Topic:** MS20761 Module 9 Lesson 1 – Conditional counts with HAVING  
**Beginner Explanation:** Discover which categories have more inactive than active indicators.

```sql
-- Categories that need indicator cleanup
SELECT 
    ic.CategoryName,
    SUM(CASE WHEN ei.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount,
    SUM(CASE WHEN ei.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveCount
FROM IndicatorCategories ic
LEFT JOIN EconomicIndicators ei ON ei.CategoryID = ic.CategoryID
GROUP BY ic.CategoryName
HAVING SUM(CASE WHEN ei.IsActive = 0 THEN 1 ELSE 0 END) > SUM(CASE WHEN ei.IsActive = 1 THEN 1 ELSE 0 END)
ORDER BY ic.CategoryName;
```

**Detailed Explanation:** Conditional sums inside HAVING highlight neglected categories requiring maintenance.

---

### Exercise 9.2: Fiscal reshaping

**Task 3:** Quarterly lending scoreboard  
**Topic:** MS20761 Module 9 Lesson 2 – GROUP BY expressions  
**Beginner Explanation:** Convert monthly data to quarterly totals using `DATEPART` and `DATENAME` for a quick scoreboard.

```sql
-- Aggregate loans to fiscal quarters
SELECT 
    cb.BankName,
    DATEPART(QUARTER, bs.ReportingDate) AS QuarterNumber,
    DATENAME(QUARTER, bs.ReportingDate) AS QuarterName,
    SUM(bs.TotalLoans) AS QuarterlyLoans
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingYear = 2024
GROUP BY cb.BankName, DATEPART(QUARTER, bs.ReportingDate), DATENAME(QUARTER, bs.ReportingDate)
ORDER BY cb.BankName, QuarterNumber;
```

**Detailed Explanation:** Date expressions in both SELECT and GROUP BY guarantee consistent bucketing per bank per quarter.

---

**Task 4:** Inflation dispersion check  
**Topic:** MS20761 Module 9 Lesson 3 – STDEV and VAR calculations  
**Beginner Explanation:** Summarize variability in inflation series to flag volatile periods.

```sql
-- Volatility metrics for CPI headline
SELECT 
    YEAR(ts.PeriodDate) AS PeriodYear,
    COUNT(*) AS Observations,
    AVG(ts.DataValue) AS AverageCPI,
    STDEV(ts.DataValue) AS StdDevCPI,
    VAR(ts.DataValue) AS VarianceCPI
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'CPI-ALL'
GROUP BY YEAR(ts.PeriodDate)
HAVING COUNT(*) >= 6
ORDER BY PeriodYear DESC;
```

**Detailed Explanation:** `HAVING COUNT(*) >= 6` ignores partially reported years, while `STDEV/VAR` quantify dispersion for each year.

---

### Exercise 9.3: Quality rules

**Task 5:** Identify stale bank submissions  
**Topic:** MS20761 Module 9 Lesson 4 – Combining aggregates with CASE  
**Beginner Explanation:** For each bank, compute days since the last validated submission and produce a compliance label.

```sql
-- Validation recency per bank
WITH LatestReturns AS (
    SELECT 
        BankID,
        MAX(ValidationDate) AS LastValidatedDate
    FROM BankingStatistics
    WHERE IsValidated = 1
    GROUP BY BankID
)
SELECT 
    cb.BankName,
    lr.LastValidatedDate,
    DATEDIFF(DAY, lr.LastValidatedDate, CAST(GETDATE() AS DATE)) AS DaysSinceValidation,
    CASE 
        WHEN DATEDIFF(DAY, lr.LastValidatedDate, CAST(GETDATE() AS DATE)) <= 45 THEN 'Compliant'
        WHEN DATEDIFF(DAY, lr.LastValidatedDate, CAST(GETDATE() AS DATE)) <= 90 THEN 'Monitor'
        ELSE 'Escalate'
    END AS ComplianceFlag
FROM LatestReturns lr
JOIN CommercialBanks cb ON cb.BankID = lr.BankID
ORDER BY DaysSinceValidation DESC;
```

**Detailed Explanation:** The CTE aggregates by bank; adding `DATEDIFF` plus `CASE` translates into operational labels used by supervision teams.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 9.4: Rolling aggregations

**Task 6:** Rolling twelve-month reserves  
**Topic:** MS20761 Module 9 Lesson 5 – SUM with window frames  
**Explanation:** Combine aggregate-style windows with grouping logic to produce rolling totals.

```sql
SELECT 
    ts.PeriodDate,
    ts.DataValue AS ReserveUSD,
    SUM(ts.DataValue) OVER (ORDER BY ts.PeriodDate ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS Rolling12MonthTotal
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES'
ORDER BY ts.PeriodDate;
```

**What to Look For:** Rolling totals only appear after month 12, demonstrating how analytic windows complement grouped outputs.

---

## Testing Checklist
- [ ] Exercise 9.1 Task 1
- [ ] Exercise 9.1 Task 2
- [ ] Exercise 9.2 Task 3
- [ ] Exercise 9.2 Task 4
- [ ] Exercise 9.3 Task 5
- [ ] Exercise 9.4 Task 6

Log validation outcomes in `sql_validation_report.md` with screenshots or error messages.
