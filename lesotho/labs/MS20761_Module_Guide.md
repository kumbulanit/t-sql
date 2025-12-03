# MS20761 Alignment Guide – Lesotho SQL Labs
**Primary Topic:** MS20761 Alignment Guide – Lesotho SQL Labs

This guide connects every module in the **MS 20761: Querying Data with Transact-SQL** syllabus to the Central Bank of Lesotho (CBL) training data set. Each section gives a plain-language explanation plus ready-to-run sample queries that reuse the same macroeconomic and banking tables already in the lab environment. No existing lab query was altered; these are additive reference snippets you can paste into SSMS for quick refreshers.

## How to Use This Guide
- Match the NobleProg/MS20761 module you are studying with the section below.
- Read the layman-friendly summary to understand *why* the topic matters for CBL analysts.
- Run the example queries against the `CBL_DataWarehouse` database to reinforce the syntax.
- Use the "What to Remember" bullets as a cheat sheet when tackling the detailed lab files.

---

## Module 1 – Introduction to Microsoft SQL Server 2016
**Layman explanation:** Learn what SQL Server is, how it stores data, and how to open a worksheet (SSMS) to ask questions from tables.

**What to remember**
- SQL Server hosts many databases (like filing cabinets). `CBL_DataWarehouse` is just one of them.
- SSMS is the point-and-click tool; once connected you send commands with `SELECT`.
- Editions (Express, Standard, Enterprise) change limits, not the T-SQL you type.

**Example – basic server and data check**
```sql
SELECT @@SERVERNAME AS ServerName,
       @@VERSION AS EngineVersion;

SELECT TOP (5) IndicatorCode, IndicatorName
FROM EconomicIndicators
ORDER BY IndicatorCode;
```
*Shows where you are connected and proves you can read from a training table.*

---

## Module 2 – Introduction to T-SQL Querying
**Layman explanation:** Discover how SQL treats tables as mathematical sets, why logic matters, and how SQL decides the order of operations.

**What to remember**
- SQL works with whole result sets, not row-by-row loops.
- Predicates (`WHERE`, `AND`, `OR`) behave like true/false questions.
- Logical order: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY`.

**Example – predicate logic with macro data**
```sql
SELECT IndicatorName, CategoryID, UnitOfMeasure
FROM EconomicIndicators
WHERE CategoryID IN (10, 11)      -- CPI & FX related categories
  AND (UnitOfMeasure LIKE '%Index%' OR UnitOfMeasure LIKE '%Rate%');
```
*Filters indicators using set logic and parentheses to control evaluation order.*

---

## Module 3 – Writing SELECT Queries
**Layman explanation:** Build readable answers from tables with column lists, aliases, and simple expressions.

**What to remember**
- `SELECT column AS FriendlyName` makes output readable for reports.
- `DISTINCT` removes duplicates when you only need unique values.
- Simple CASE expressions label data without modifying the table.

**Example – CASE expression on banks**
```sql
SELECT BankName,
       BankType,
       City,
       CASE WHEN IsActive = 1 THEN 'Open for reporting'
            ELSE 'Inactive/legacy'
       END AS ReportingStatus
FROM CommercialBanks
ORDER BY BankName;
```
*Keeps the existing table untouched while presenting easier labels.*

---

## Module 4 – Querying Multiple Tables
**Layman explanation:** Combine related tables (like indicator definitions + values) so analysts do not copy/paste data manually.

**What to remember**
- INNER JOIN returns only matching rows across tables.
- JOINs rely on primary/foreign keys (`EconomicIndicators.CategoryID` → `IndicatorCategories.CategoryID`).
- Use table aliases to keep queries readable.

**Example – map indicator metadata to categories**
```sql
SELECT ei.IndicatorCode,
       ei.IndicatorName,
       ic.CategoryName
FROM EconomicIndicators ei
JOIN IndicatorCategories ic
  ON ei.CategoryID = ic.CategoryID
ORDER BY ic.CategoryName, ei.IndicatorName;
```
*Confirms each indicator is tied to a descriptive category.*

---

## Module 5 – Sorting and Filtering Data
**Layman explanation:** Control which rows you see and how they are ordered, just like sorting spreadsheets.

**What to remember**
- `ORDER BY` defaults to ascending; add `DESC` for reverse ordering.
- `TOP (n)` and `OFFSET/FETCH` limit output without changing data.
- `WHERE ... IS NULL` finds missing submissions or unvalidated rows.

**Example – most recent bank submissions**
```sql
SELECT TOP (10)
       BankID,
       ReportingDate,
       TotalAssets,
       TotalLoans,
       IsValidated
FROM BankingStatistics
WHERE ReportingYear = 2024
ORDER BY ReportingDate DESC, TotalAssets DESC;
```
*Prioritises latest reports and largest balance sheets.*

---

## Module 6 – Working with SQL Server Data Types
**Layman explanation:** Understand how numbers, dates, and text are stored so calculations behave correctly.

**What to remember**
- Use `CAST/CONVERT` when moving between string and numeric/date types.
- Date parts (`YEAR`, `MONTH`) help align time-series.
- DECIMAL precision matters for financial ratios.

**Example – converting date & formatting amounts**
```sql
SELECT TimeSeriesID,
       IndicatorID,
       PeriodDate,
       DATENAME(MONTH, PeriodDate) AS PeriodMonthName,
       CAST(DataValue AS DECIMAL(18,2)) AS AmountRounded
FROM TimeSeriesData
WHERE IndicatorID = (SELECT IndicatorID FROM EconomicIndicators WHERE IndicatorCode = 'CPI-ALL')
ORDER BY PeriodDate DESC;
```
*Shows date extraction plus controlled numeric formatting.*

---

## Module 7 – Using DML to Modify Data
**Layman explanation:** Add, update, or delete rows safely while keeping audit trails intact.

**What to remember**
- Always specify column lists in `INSERT` to avoid schema changes breaking scripts.
- Use `OUTPUT` to log what changed.
- Pair updates/deletes with `WHERE` clauses to avoid mass edits.

**Example – insert a provisional CPI value**
```sql
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue,
                            DataSourceID, CollectionDate, IsProvisional)
OUTPUT inserted.TimeSeriesID, inserted.DataValue
SELECT IndicatorID,
       DATEFROMPARTS(2024, 11, 1),
       2024,
       11,
       118.42,
       DataSourceID,
       CAST(GETDATE() AS DATE),
       1
FROM EconomicIndicators
WHERE IndicatorCode = 'CPI-ALL';
```
*Adds a new row using metadata from the master indicator table.*

---

## Module 8 – Using Built-In Functions
**Layman explanation:** Let SQL do the heavy lifting with ready-made math, text, and conversion helpers.

**What to remember**
- String functions (`UPPER`, `LEN`, `REPLACE`) keep names consistent.
- Date functions (`DATEADD`, `DATEDIFF`) simplify period comparisons.
- `COALESCE/ISNULL` provide business-friendly defaults.

**Example – calculate year-to-date reserve change**
```sql
SELECT TOP (1)
       PeriodDate,
       DataValue AS FXReservesUSD,
       DataValue - LAG(DataValue, 1) OVER (ORDER BY PeriodDate) AS MonthChange,
       DataValue - FIRST_VALUE(DataValue) OVER (PARTITION BY YEAR(PeriodDate)
                                               ORDER BY PeriodDate) AS YTDChange
FROM TimeSeriesData
WHERE IndicatorID = (SELECT IndicatorID FROM EconomicIndicators WHERE IndicatorCode = 'FX-RESERVES')
ORDER BY PeriodDate DESC;
```
*Combines window + built-in functions to explain movements without spreadsheets.*

---

## Module 9 – Grouping and Aggregating Data
**Layman explanation:** Summarize thousands of rows into a single insight (totals, averages, counts).

**What to remember**
- Columns in `SELECT` must be aggregated or appear in `GROUP BY`.
- Use `HAVING` to filter aggregated results (after grouping).
- Aggregations support official publications (totals by bank, quarter, etc.).

**Example – quarterly lending totals by bank**
```sql
SELECT BankID,
       ReportingYear,
       ReportingMonth,
       SUM(TotalLoans) AS MonthlyLoans
FROM BankingStatistics
WHERE ReportingYear = 2024
GROUP BY BankID, ReportingYear, ReportingMonth
HAVING SUM(TotalLoans) > 0
ORDER BY BankID, ReportingMonth;
```
*Foundation for quarterly roll-ups and supervisory dashboards.*

---

## Module 10 – Using Subqueries
**Layman explanation:** Ask a question inside another question—perfect for conditional logic or lookups.

**What to remember**
- Self-contained subqueries run once; correlated ones run per row.
- `EXISTS` is fastest when you only care that a related record is present.
- Use subqueries to avoid manual lookup tables in Excel.

**Example – find indicators missing quality checks**
```sql
SELECT IndicatorCode, IndicatorName
FROM EconomicIndicators ei
WHERE NOT EXISTS (
    SELECT 1
    FROM DataQualityChecks dq
    WHERE dq.IndicatorID = ei.IndicatorID
      AND dq.CheckResult = 'Pass'
);
```
*Highlights metadata needing attention without joining multiple times.*

---

## Module 11 – Using Table Expressions (Views, CTEs, Inline TVFs)
**Layman explanation:** Save complex SELECT logic as reusable virtual tables.

**What to remember**
- Views encapsulate joins/filters so analysts run `SELECT * FROM vwLatestInflation`.
- Common Table Expressions (CTEs) break long queries into readable blocks.
- Inline table-valued functions return parameterised result sets.

**Example – CTE for latest CPI reading per category**
```sql
WITH LatestCPI AS (
    SELECT IndicatorID,
           IndicatorCode,
           ROW_NUMBER() OVER (PARTITION BY IndicatorID ORDER BY PeriodDate DESC) AS rn,
           PeriodDate,
           DataValue
    FROM EconomicIndicators ei
    JOIN TimeSeriesData ts ON ts.IndicatorID = ei.IndicatorID
    WHERE ei.IndicatorCode LIKE 'CPI-%'
)
SELECT IndicatorCode, PeriodDate, DataValue
FROM LatestCPI
WHERE rn = 1;
```
*CTE keeps the window logic tidy and reusable.*

---

## Module 12 – Using Set Operators
**Layman explanation:** Stack compatible result sets or compare differences without extra joins.

**What to remember**
- `UNION ALL` preserves duplicates; `UNION` removes them.
- `EXCEPT` shows rows in the first query but not the second (great for gap checks).
- `INTERSECT` reveals overlaps.

**Example – who requested vs who received banking data**
```sql
SELECT RecipientName, 'Requestor' AS Role
FROM DataDissemination
WHERE DataCategory = 'Banking Statistics'
UNION
SELECT BankName, 'Reporting Bank'
FROM CommercialBanks;
```
*Quickly lists stakeholders touching the same dataset.*

**Example – banks without dissemination records**
```sql
SELECT BankName
FROM CommercialBanks
EXCEPT
SELECT RecipientName
FROM DataDissemination
WHERE RecipientType = 'Commercial Bank';
```
*Identifies banks that never received formal outputs.*

---

## Module 13 – Window Ranking, Offset, and Aggregate Functions
**Layman explanation:** Compare each row to its neighbours without collapsing the entire result set.

**What to remember**
- `ROW_NUMBER`, `RANK`, `DENSE_RANK` answer “what position is this row in a sorted list?”
- `LAG/LEAD` look backward/forward to compute deltas.
- Partition windows by entity (Indicator, Bank) to restart the ranking per group.

**Example – inflation rank by month**
```sql
SELECT PeriodDate,
       DataValue AS InflationRate,
       LAG(DataValue) OVER (ORDER BY PeriodDate) AS PriorMonth,
       DataValue - LAG(DataValue) OVER (ORDER BY PeriodDate) AS MoMChange,
       RANK() OVER (ORDER BY DataValue DESC) AS HighestInflationRank
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'INF-RATE'
ORDER BY PeriodDate DESC;
```
*Generates analytical columns without extra joins.*

---

## Module 14 – Pivoting and Grouping Sets
**Layman explanation:** Rotate rows into columns for dashboards or aggregate multiple roll-ups in one pass.

**What to remember**
- `PIVOT` flips row values into columns—handy for monthly CPI tables.
- `GROUPING SETS` and `ROLLUP` deliver subtotals and grand totals automatically.
- Keep pivots narrow; use `WHERE` to restrict indicator lists.

**Example – pivot CPI by month**
```sql
SELECT *
FROM (
    SELECT FORMAT(PeriodDate, 'yyyy') AS PeriodYear,
           FORMAT(PeriodDate, 'MMM') AS PeriodMonth,
           DataValue
    FROM TimeSeriesData ts
    JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorCode = 'CPI-ALL'
      AND PeriodYear = 2024
) src
PIVOT (
    AVG(DataValue) FOR PeriodMonth IN ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec])
) p;
```

**Example – grouping sets for bank aggregates**
```sql
SELECT COALESCE(CAST(BankID AS NVARCHAR(5)), 'All Banks') AS BankLabel,
       QuarterLabel,
       SUM(TotalAssets) AS TotalAssets
FROM BankingStatistics
CROSS APPLY (VALUES (DATEPART(QUARTER, ReportingDate))) q (QuarterLabel)
WHERE ReportingYear = 2024
GROUP BY GROUPING SETS ((BankID, QuarterLabel), (QuarterLabel));
```
*Generates per-bank and overall totals in one query.*

---

## Module 15 – Executing Stored Procedures
**Layman explanation:** Package frequently-used logic with parameters so anyone can rerun it safely.

**What to remember**
- Stored procedures accept inputs (e.g., reporting year) and return datasets.
- Use `sp_helptext` to inspect definitions without editing them.
- Always qualify with schema, e.g., `EXEC dbo.usp_ReportLatestCPI @Year = 2024`.

**Example – template procedure to list validated bank returns**
```sql
CREATE OR ALTER PROCEDURE dbo.usp_GetValidatedBankingReturns
    @ReportingYear INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT BankID,
           ReportingDate,
           TotalAssets,
           TotalLoans
    FROM BankingStatistics
    WHERE ReportingYear = @ReportingYear
      AND IsValidated = 1
    ORDER BY ReportingDate;
END;
```
*Encapsulates a common filter so analysts dont rewrite it each month.*

---

## Module 16 – Programming with T-SQL
**Layman explanation:** Add variables and control-of-flow so SQL can react to conditions (basic scripting).

**What to remember**
- Use `DECLARE` + `SET/SELECT` for variables.
- `IF...ELSE` or `WHILE` guides procedural logic.
- Keep procedural code lightweight; SQL is best at set operations.

**Example – conditional alert for reserve threshold**
```sql
DECLARE @LatestReserves DECIMAL(18,2);

SELECT TOP (1) @LatestReserves = DataValue
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES'
ORDER BY PeriodDate DESC;

IF @LatestReserves < 800.00
    PRINT 'Alert: FX reserves below comfort level';
ELSE
    PRINT 'FX reserves within acceptable range';
```
*Mixes variables with IF logic to mimic business rules.*

---

## Module 17 – Implementing Error Handling
**Layman explanation:** Catch issues (duplicate rows, constraint failures) so scripts fail gracefully.

**What to remember**
- Wrap risky statements in `TRY...CATCH` blocks.
- `ERROR_NUMBER()`, `ERROR_MESSAGE()` reveal what went wrong.
- Combine with transactions to roll back partial work.

**Example – safe insert with error capture**
```sql
BEGIN TRY
    INSERT INTO EconomicIndicators (IndicatorCode, IndicatorName, CategoryID,
                                    UnitOfMeasure, DataSourceID, FrequencyID)
    VALUES ('NEW-IND', 'New Indicator', 1, 'Index', 4, 3);
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo,
           ERROR_MESSAGE() AS ErrMsg;
END CATCH;
```
*Prevents silent failures when, for example, a duplicate code exists.*

---

## Module 18 – Implementing Transactions
**Layman explanation:** Group multiple statements so they either all succeed or none do—critical for financial data integrity.

**What to remember**
- `BEGIN TRAN` starts the unit of work; `COMMIT` saves; `ROLLBACK` cancels.
- Always include error handling to decide when to roll back.
- Keep transactions short to avoid locking contention.

**Example – revise provisional CPI safely**
```sql
BEGIN TRY
    BEGIN TRAN;

    UPDATE TimeSeriesData
    SET DataValue = 118.72,
        IsProvisional = 0,
        IsRevised = 1,
        RevisionNumber = RevisionNumber + 1,
        ModifiedDate = SYSDATETIME()
    WHERE IndicatorID = (SELECT IndicatorID FROM EconomicIndicators WHERE IndicatorCode = 'CPI-ALL')
      AND PeriodDate = '2024-11-01'
      AND IsProvisional = 1;

    INSERT INTO DataQualityChecks (IndicatorID, CheckDate, CheckType, CheckResult, CheckedBy)
    SELECT IndicatorID, CAST(GETDATE() AS DATE), 'Accuracy', 'Pass', 'QualityBot'
    FROM EconomicIndicators WHERE IndicatorCode = 'CPI-ALL';

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
END CATCH;
```
*Ensures the revision and its audit trail move together or not at all.*

---

### Final Notes
- These snippets intentionally mirror the **CBL_DataWarehouse** schema so they run without extra setup.
- Use them as pre-reading before tackling the deeper exercises in each `Module_0X` lab file.
- When you craft new practice questions, reuse the same tables to stay consistent with the training datasets.
