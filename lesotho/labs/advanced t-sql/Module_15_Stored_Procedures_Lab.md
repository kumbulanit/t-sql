# Module 15: Executing Stored Procedures
**Primary Topic:** Module 15: Executing Stored Procedures

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 75 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-14 completed  
**Target Audience:** Analysts encapsulating reusable logic for operations teams

---

## Learning Objectives
1. Create parameterised stored procedures with validation logic
2. Use `SET NOCOUNT ON` and output parameters for consistency
3. Encapsulate multi-step analysis (joins, aggregations) inside procedures
4. Implement security-conscious patterns (schema-qualified names)
5. Develop maintenance procedures for data quality actions
6. Execute procedures with varying parameter values and capture results

---

## BEGINNER SECTION (Required)

### Exercise 15.1: Basic parameterised procedure

**Task 1:** Latest validated banking returns  
**Topic:** MS20761 Module 15 Lesson 1 – Create/execute a simple procedure  
**Beginner Explanation:** Package a recurring query so analysts specify year and validation flag without rewriting filters.

```sql
CREATE OR ALTER PROCEDURE dbo.usp_GetValidatedBankingReturns
    @ReportingYear INT,
    @OnlyValidated BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cb.BankName,
        bs.ReportingDate,
        bs.TotalAssets,
        bs.TotalLoans,
        bs.IsValidated
    FROM BankingStatistics bs
    JOIN CommercialBanks cb ON cb.BankID = bs.BankID
    WHERE bs.ReportingYear = @ReportingYear
      AND (@OnlyValidated = 0 OR bs.IsValidated = 1)
    ORDER BY bs.ReportingDate DESC, cb.BankName;
END;
GO

EXEC dbo.usp_GetValidatedBankingReturns @ReportingYear = 2024, @OnlyValidated = 1;
```

**Detailed Explanation:** Optional parameters allow the same procedure to handle validated-only and raw views without branching logic.

---

### Exercise 15.2: Output parameters

**Task 2:** Procedure returning counts  
**Topic:** MS20761 Module 15 Lesson 2 – Use output parameters for summary info  
**Beginner Explanation:** Return both a rowset and a scalar count to calling applications.

```sql
CREATE OR ALTER PROCEDURE dbo.usp_GetIndicatorFreshness
    @MaxDaysOld INT,
    @IndicatorsFlagged INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ei.IndicatorCode,
        ei.IndicatorName,
        MAX(ts.PeriodDate) AS LatestDate,
        DATEDIFF(DAY, MAX(ts.PeriodDate), CAST(GETDATE() AS DATE)) AS DaysOld
    INTO #Freshness
    FROM EconomicIndicators ei
    JOIN TimeSeriesData ts ON ts.IndicatorID = ei.IndicatorID
    GROUP BY ei.IndicatorCode, ei.IndicatorName
    HAVING DATEDIFF(DAY, MAX(ts.PeriodDate), CAST(GETDATE() AS DATE)) > @MaxDaysOld;

    SELECT * FROM #Freshness;

    SELECT @IndicatorsFlagged = COUNT(*) FROM #Freshness;
END;
GO

DECLARE @Flagged INT;
EXEC dbo.usp_GetIndicatorFreshness @MaxDaysOld = 60, @IndicatorsFlagged = @Flagged OUTPUT;
SELECT @Flagged AS IndicatorsNeedingAttention;
```

**Detailed Explanation:** Temp table captures filtered results; the output parameter gives calling code a quick status indicator.

---

### Exercise 15.3: Maintenance procedure

**Task 3:** Bulk finalize provisional data  
**Topic:** MS20761 Module 15 Lesson 3 – Encapsulate multi-step UPDATE logic  
**Beginner Explanation:** Wrap the “mark provisional data as final” routine into a procedure to reduce copy/paste errors.

```sql
CREATE OR ALTER PROCEDURE dbo.usp_FinalizeIndicatorData
    @IndicatorCode NVARCHAR(50),
    @CutoffDate DATE,
    @User NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ts
    SET IsProvisional = 0,
        IsRevised = 1,
        RevisionNumber = RevisionNumber + 1,
        ModifiedDate = SYSDATETIME(),
        ModifiedBy = @User
    FROM TimeSeriesData ts
    JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorCode = @IndicatorCode
      AND ts.PeriodDate <= @CutoffDate
      AND ts.IsProvisional = 1;

    SELECT @@ROWCOUNT AS RowsFinalized;
END;
GO

EXEC dbo.usp_FinalizeIndicatorData @IndicatorCode = 'CPI-ALL', @CutoffDate = '2024-09-01', @User = 'quality_team';
```

**Detailed Explanation:** Using a stored procedure enforces consistent audit metadata each time provisional rows are finalized.

---

## Testing Checklist
- [ ] Exercise 15.1 Task 1
- [ ] Exercise 15.2 Task 2
- [ ] Exercise 15.3 Task 3

Record execution screenshots, row counts, and output parameter values in `sql_validation_report.md`.
