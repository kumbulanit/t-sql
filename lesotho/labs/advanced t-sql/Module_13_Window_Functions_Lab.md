# Module 13: Window Ranking, Offset, and Aggregate Functions
**Primary Topic:** Module 13: Window Ranking, Offset, and Aggregate Functions

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Intermediate to Advanced  
**Prerequisites:** Modules 1-12 completed  
**Target Audience:** Analysts producing peer rankings, running totals, and comparative analytics

---

## Learning Objectives
1. Use ROW_NUMBER, RANK, and DENSE_RANK appropriately
2. Apply LAG/LEAD for period-over-period comparisons
3. Configure window partitions to reset calculations per entity
4. Mix window aggregates with standard GROUP BY logic
5. Understand frame clauses (ROWS vs RANGE)
6. Translate analytical requirements into single-set queries

---

## BEGINNER SECTION (Required)

### Exercise 13.1: Ranking banks

**Task 1:** Asset league tables  
**Topic:** MS20761 Module 13 Lesson 1 – ROW_NUMBER vs RANK  
**Beginner Explanation:** Produce simultaneous rankings for total assets with and without ties.

```sql
SELECT 
    bs.ReportingDate,
    cb.BankName,
    bs.TotalAssets,
    ROW_NUMBER() OVER (PARTITION BY bs.ReportingDate ORDER BY bs.TotalAssets DESC) AS RowNumRank,
    RANK() OVER (PARTITION BY bs.ReportingDate ORDER BY bs.TotalAssets DESC) AS RankWithTies,
    DENSE_RANK() OVER (PARTITION BY bs.ReportingDate ORDER BY bs.TotalAssets DESC) AS DenseRankWithTies
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingDate = '2024-09-30'
ORDER BY bs.TotalAssets DESC;
```

**Detailed Explanation:** Shows the difference between ROW_NUMBER and the tie-aware ranking functions for the same dataset.

---

### Exercise 13.2: Offset functions

**Task 2:** Loan growth tracking  
**Topic:** MS20761 Module 13 Lesson 2 – LAG for deltas  
**Beginner Explanation:** Compare each bank’s quarterly loan book to the prior quarter to compute growth percentages.

```sql
WITH QuarterlyLoans AS (
    SELECT 
        BankID,
        DATEFROMPARTS(ReportingYear, ReportingMonth, 1) AS PeriodStart,
        SUM(TotalLoans) AS MonthlyLoans
    FROM BankingStatistics
    GROUP BY BankID, ReportingYear, ReportingMonth
)
SELECT 
    cb.BankName,
    ql.PeriodStart,
    ql.MonthlyLoans,
    LAG(ql.MonthlyLoans) OVER (PARTITION BY cb.BankName ORDER BY ql.PeriodStart) AS PriorMonthLoans,
    ROUND(((ql.MonthlyLoans - LAG(ql.MonthlyLoans) OVER (PARTITION BY cb.BankName ORDER BY ql.PeriodStart))
          / NULLIF(LAG(ql.MonthlyLoans) OVER (PARTITION BY cb.BankName ORDER BY ql.PeriodStart), 0)) * 100, 2) AS PercentChange
FROM QuarterlyLoans ql
JOIN CommercialBanks cb ON cb.BankID = ql.BankID
WHERE ql.PeriodStart >= '2024-01-01'
ORDER BY cb.BankName, ql.PeriodStart;
```

**Detailed Explanation:** `LAG` fetches the previous month for each bank, enabling inline growth calculations.

---

**Task 3:** Forward-looking provisioning  
**Topic:** MS20761 Module 13 Lesson 2 – LEAD for comparing future values  
**Beginner Explanation:** Compare current NPL ratio to next month’s to anticipate deteriorations.

```sql
SELECT 
    bs.ReportingDate,
    cb.BankName,
    bs.NPLRatio,
    LEAD(bs.NPLRatio) OVER (PARTITION BY cb.BankName ORDER BY bs.ReportingDate) AS NextMonthNPL,
    CASE 
        WHEN LEAD(bs.NPLRatio) OVER (PARTITION BY cb.BankName ORDER BY bs.ReportingDate) > bs.NPLRatio THEN 'Worsening'
        ELSE 'Stable/Improving'
    END AS Outlook
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingYear = 2024
ORDER BY cb.BankName, bs.ReportingDate;
```

**Detailed Explanation:** LEAD highlights potential deterioration before it appears in headline reports.

---

### Exercise 13.3: Window aggregates

**Task 4:** Running reserves total  
**Topic:** MS20761 Module 13 Lesson 3 – SUM OVER with frame  
**Beginner Explanation:** Display cumulative FX reserves for the year to date.

```sql
SELECT 
    ts.PeriodDate,
    ts.DataValue,
    SUM(ts.DataValue) OVER (ORDER BY ts.PeriodDate ROWS UNBOUNDED PRECEDING) AS CumulativeReserves
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES'
  AND ts.PeriodYear = 2024
ORDER BY ts.PeriodDate;
```

**Detailed Explanation:** The frame `ROWS UNBOUNDED PRECEDING` accumulates values from the start of the partition.

---

**Task 5:** Percent of yearly total  
**Topic:** MS20761 Module 13 Lesson 3 – Window SUM in denominator  
**Beginner Explanation:** Express each month’s CPI value as a percentage of the year’s total.

```sql
SELECT 
    ts.PeriodDate,
    ts.DataValue,
    ROUND((ts.DataValue / NULLIF(SUM(ts.DataValue) OVER (PARTITION BY ts.PeriodYear), 0)) * 100, 2) AS ShareOfYear
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'CPI-ALL'
  AND ts.PeriodYear = 2024
ORDER BY ts.PeriodDate;
```

**Detailed Explanation:** Partitioning by year calculates the denominator for each row without collapsing the dataset.

---

## Testing Checklist
- [ ] Exercise 13.1 Task 1
- [ ] Exercise 13.2 Task 2
- [ ] Exercise 13.2 Task 3
- [ ] Exercise 13.3 Task 4
- [ ] Exercise 13.3 Task 5

Record ranking accuracy and any discrepancies inside `sql_validation_report.md`.
