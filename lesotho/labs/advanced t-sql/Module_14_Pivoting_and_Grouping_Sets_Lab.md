# Module 14: Pivoting and Grouping Sets
**Primary Topic:** Module 14: Pivoting and Grouping Sets

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Advanced  
**Prerequisites:** Modules 1-13 completed  
**Target Audience:** Analysts building multi-view tables for publications and dashboards

---

## Learning Objectives
1. Use PIVOT to rotate row values into columns
2. Apply UNPIVOT to normalize legacy spreadsheets
3. Combine GROUPING SETS, ROLLUP, and CUBE for multi-level summaries
4. Use GROUPING() and GROUPING_ID() to label subtotal rows
5. Craft publication-ready tables without exporting to Excel first
6. Capture performance considerations when pivoting large datasets

---

## BEGINNER SECTION (Required)

### Exercise 14.1: Classic pivot

**Task 1:** Monthly CPI table  
**Topic:** MS20761 Module 14 Lesson 1 – Pivot monthly CPI values by month name  
**Beginner Explanation:** Produce a single row per year with months as columns for bulletins.

```sql
-- Pivot CPI values by month
WITH SourceData AS (
    SELECT 
        ts.PeriodYear,
        FORMAT(ts.PeriodDate, 'MMM') AS PeriodMonth,
        ts.DataValue
    FROM TimeSeriesData ts
    JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorCode = 'CPI-ALL'
      AND ts.PeriodYear IN (2023, 2024)
)
SELECT *
FROM SourceData
PIVOT (
    AVG(DataValue) FOR PeriodMonth IN ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec])
) p
ORDER BY PeriodYear;
```

**Detailed Explanation:** The pivoted output displays months as columns, enabling quick scanning for month-to-month trends.

---

### Exercise 14.2: UNPIVOT cleanup

**Task 2:** Normalize Excel-style submissions  
**Topic:** MS20761 Module 14 Lesson 2 – UNPIVOT to convert columns back to rows  
**Beginner Explanation:** Assume a staging table `MonthlyBankMetrics` with Year plus Month columns; convert them into row-based format ready for insertion into `BankingStatistics`.

```sql
-- Demo structure for UNPIVOT
SELECT 
    BankID,
    MetricName,
    PeriodDate,
    MetricValue
FROM (
    SELECT 
        BankID,
        ReportingYear,
        Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
    FROM MonthlyBankMetrics  -- staging table
) src
UNPIVOT (
    MetricValue FOR MetricMonth IN (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
) unp
CROSS APPLY (
    SELECT DATEFROMPARTS(ReportingYear, 
        CASE MetricMonth
            WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2 WHEN 'Mar' THEN 3 WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6
            WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9 WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12
        END, 1) AS PeriodDate
) month_map
CROSS APPLY (
    SELECT CASE 
        WHEN MetricName IS NOT NULL THEN MetricName
        ELSE 'TotalLoans'
    END AS MetricName
) metric_alias;
```

**Detailed Explanation:** UNPIVOT converts monthly columns to rows, while `CROSS APPLY` rebuilds date columns for integration with normalized tables.

---

### Exercise 14.3: Grouping sets

**Task 3:** Bank totals with subtotals  
**Topic:** MS20761 Module 14 Lesson 3 – GROUPING SETS for multiple totals  
**Beginner Explanation:** Generate bank-level and overall totals for total assets in a single scan.

```sql
SELECT 
    CASE WHEN GROUPING(cb.BankName) = 1 THEN 'All Banks' ELSE cb.BankName END AS BankLabel,
    CASE WHEN GROUPING(bs.ReportingQuarter) = 1 THEN 'All Quarters' ELSE CONCAT('Q', bs.ReportingQuarter) END AS QuarterLabel,
    SUM(bs.TotalAssets) AS TotalAssets
FROM (
    SELECT *, DATEPART(QUARTER, ReportingDate) AS ReportingQuarter
    FROM BankingStatistics
    WHERE ReportingYear = 2024
) bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
GROUP BY GROUPING SETS ((cb.BankName, bs.ReportingQuarter), (cb.BankName), (bs.ReportingQuarter), ())
ORDER BY BankLabel, QuarterLabel;
```

**Detailed Explanation:** `GROUPING SETS` produces per-bank-per-quarter, per-bank, per-quarter, and grand totals in one query.

---

### Exercise 14.4: ROLLUP for dissemination

**Task 4:** Dissemination summary  
**Topic:** MS20761 Module 14 Lesson 3 – ROLLUP for hierarchical totals  
**Beginner Explanation:** Provide dissemination counts by recipient type and delivery method with subtotals.

```sql
SELECT 
    RecipientType,
    DeliveryMethod,
    COUNT(*) AS Dispatches,
    GROUPING(RecipientType) AS RecipientGroupFlag,
    GROUPING(DeliveryMethod) AS MethodGroupFlag
FROM DataDissemination
WHERE DisseminationDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
GROUP BY ROLLUP (RecipientType, DeliveryMethod)
ORDER BY RecipientType, DeliveryMethod;
```

**Detailed Explanation:** GROUPING() flags help consumers distinguish subtotal rows when exporting to Excel.

---

## Testing Checklist
- [ ] Exercise 14.1 Task 1
- [ ] Exercise 14.2 Task 2
- [ ] Exercise 14.3 Task 3
- [ ] Exercise 14.4 Task 4

Capture screenshot evidence of pivot outputs or note any performance tuning in `sql_validation_report.md`.
