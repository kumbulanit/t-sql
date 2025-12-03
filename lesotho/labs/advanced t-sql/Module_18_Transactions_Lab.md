# Module 18: Implementing Transactions
**Primary Topic:** Module 18: Implementing Transactions

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Advanced  
**Prerequisites:** Modules 1-17 completed  
**Target Audience:** Analysts safeguarding multi-step updates for financial integrity

---

## Learning Objectives
1. Start, commit, and roll back transactions intentionally
2. Use `XACT_STATE()` to detect transaction health in CATCH blocks
3. Implement savepoints for partial rollbacks
4. Combine transactions with auditing requirements
5. Understand isolation considerations for batch updates
6. Document recovery steps for failed operations

---

## BEGINNER SECTION (Required)

### Exercise 18.1: Basic transaction workflow

**Task 1:** Insert indicator + seed data atomically  
**Topic:** MS20761 Module 18 Lesson 1 – BEGIN TRAN / COMMIT  
**Beginner Explanation:** Ensure both metadata and initial time-series rows persist together or not at all.

```sql
BEGIN TRY
    BEGIN TRAN;

    DECLARE @NewIndicatorID INT;

    INSERT INTO EconomicIndicators (IndicatorCode, IndicatorName, CategoryID, UnitOfMeasure, DataSourceID, FrequencyID)
    VALUES ('CREDIT-AGR', 'Agricultural Credit', 3, 'Millions', 1, 3);

    SET @NewIndicatorID = SCOPE_IDENTITY();

    INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate)
    VALUES 
        (@NewIndicatorID, '2024-07-01', 2024, 7, 120.5, 1, CAST(GETDATE() AS DATE)),
        (@NewIndicatorID, '2024-08-01', 2024, 8, 123.8, 1, CAST(GETDATE() AS DATE));

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
END CATCH;
```

**Detailed Explanation:** Captures the new `IndicatorID` before inserting dependent rows; any failure reverts the entire transaction.

---

### Exercise 18.2: Savepoints

**Task 2:** Partial rollback for staged updates  
**Topic:** MS20761 Module 18 Lesson 2 – SAVE TRAN usage  
**Beginner Explanation:** Update provisional data, set a savepoint, and roll back only the risky portion if it fails.

```sql
BEGIN TRY
    BEGIN TRAN;

    UPDATE TimeSeriesData
    SET Notes = 'Initial mass update'
    WHERE IsProvisional = 1
      AND PeriodDate >= '2024-01-01';

    SAVE TRAN ProvisionalEdits;

    UPDATE TimeSeriesData
    SET DataValue = DataValue * 1.02
    WHERE IsProvisional = 1
      AND PeriodDate BETWEEN '2024-06-01' AND '2024-08-01';

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() = -1
        ROLLBACK; -- entire transaction doomed
    ELSE IF XACT_STATE() = 1
    BEGIN
        ROLLBACK TRAN ProvisionalEdits; -- revert only risky portion
        COMMIT; -- keep initial note updates
    END;

    INSERT INTO ErrorLog (ErrorDate, ErrNumber, ErrMessage, FailedProcedure)
    VALUES (SYSDATETIME(), ERROR_NUMBER(), ERROR_MESSAGE(), 'Module18Task2');
END CATCH;
```

**Detailed Explanation:** Demonstrates selective rollback using savepoints when part of the batch errors out.

---

### Exercise 18.3: Transactions with auditing

**Task 3:** Encapsulate revisions plus audit trail  
**Topic:** MS20761 Module 18 Lesson 3 – Combine transaction + audit insert  
**Beginner Explanation:** Update CPI data and simultaneously insert a quality check entry in the same transaction.

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
      AND PeriodDate = '2024-11-01';

    INSERT INTO DataQualityChecks (IndicatorID, CheckDate, CheckType, CheckResult, CheckedBy)
    SELECT IndicatorID, CAST(GETDATE() AS DATE), 'Accuracy', 'Pass', 'QualityBot'
    FROM EconomicIndicators
    WHERE IndicatorCode = 'CPI-ALL';

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
END CATCH;
```

**Detailed Explanation:** Guarantees the revision and audit trail succeed or fail together, critical for governance.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 18.4: Long-running batch with monitoring

**Task 4:** Batched dissemination clean-up  
**Topic:** MS20761 Module 18 Lesson 4 – Loop with periodic commits  
**Explanation:** Process large batches in manageable chunks.

```sql
DECLARE @BatchSize INT = 100;
DECLARE @RowsAffected INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRAN;

    WITH OldDisseminations AS (
        SELECT TOP (@BatchSize) DisseminationID
        FROM DataDissemination
        WHERE DisseminationDate < DATEADD(YEAR, -5, CAST(GETDATE() AS DATE))
        ORDER BY DisseminationDate
    )
    DELETE FROM DataDissemination
    OUTPUT DELETED.DisseminationID INTO #DeletedDisseminations
    WHERE DisseminationID IN (SELECT DisseminationID FROM OldDisseminations);

    SET @RowsAffected = @@ROWCOUNT;

    COMMIT;

    PRINT CONCAT('Deleted ', @RowsAffected, ' rows in this batch.');
END;
```

> **Note:** Create temp table `#DeletedDisseminations` beforehand to review removals.

**Detailed Explanation:** Smaller transactions limit locking impact; loop exits when no rows remain.

---

## Testing Checklist
- [ ] Exercise 18.1 Task 1
- [ ] Exercise 18.2 Task 2
- [ ] Exercise 18.3 Task 3
- [ ] Exercise 18.4 Task 4

Document commit/rollback behaviour plus any lock contention observations in `sql_validation_report.md`.
