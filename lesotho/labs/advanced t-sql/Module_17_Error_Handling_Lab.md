# Module 17: Implementing Error Handling
**Primary Topic:** Module 17: Implementing Error Handling

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 75 minutes  
**Difficulty:** Advanced  
**Prerequisites:** Modules 1-16 completed  
**Target Audience:** Analysts responsible for resilient data pipelines and auditability

---

## Learning Objectives
1. Wrap risky statements inside TRY...CATCH blocks
2. Retrieve detailed error metadata (number, severity, state)
3. Combine error handling with transactions for safe rollbacks
4. Log failures into dedicated audit tables
5. Re-throw exceptions with `THROW` for upstream awareness
6. Test failure scenarios deliberately to validate controls

---

## BEGINNER SECTION (Required)

### Exercise 17.1: Basic TRY...CATCH

**Task 1:** Duplicate indicator insert test  
**Topic:** MS20761 Module 17 Lesson 1 – Trap primary-key/unique violations  
**Beginner Explanation:** Attempt to insert a duplicate indicator code and capture the error without crashing the script.

```sql
BEGIN TRY
    INSERT INTO EconomicIndicators (IndicatorCode, IndicatorName, CategoryID, UnitOfMeasure, DataSourceID, FrequencyID)
    VALUES ('CPI-ALL', 'Duplicate CPI', 6, 'Index', 1, 3);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrNumber,
        ERROR_SEVERITY() AS ErrSeverity,
        ERROR_STATE() AS ErrState,
        ERROR_MESSAGE() AS ErrMessage,
        ERROR_LINE() AS ErrLine;
END CATCH;
```

**Detailed Explanation:** Shows how to capture structured metadata when unique constraints fail.

---

### Exercise 17.2: TRY...CATCH with logging

**Task 2:** Log failed banking update  
**Topic:** MS20761 Module 17 Lesson 2 – Insert into logging table during catch block  
**Beginner Explanation:** When an update fails, insert the error details into `DataQualityChecks` or a dedicated log for review.

```sql
BEGIN TRY
    UPDATE BankingStatistics
    SET TotalAssets = TotalAssets * 1.05
    WHERE StatisticID = -1;  -- intentionally invalid
END TRY
BEGIN CATCH
    INSERT INTO ErrorLog (ErrorDate, ErrNumber, ErrMessage, FailedProcedure)
    VALUES (SYSDATETIME(), ERROR_NUMBER(), ERROR_MESSAGE(), 'Module17Task2');

    SELECT 'Update failed; details logged.' AS StatusMessage;
END CATCH;
```

> **Note:** Create `ErrorLog` table beforehand:
```sql
CREATE TABLE ErrorLog (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorDate DATETIME2 NOT NULL,
    ErrNumber INT NOT NULL,
    ErrMessage NVARCHAR(4000) NOT NULL,
    FailedProcedure NVARCHAR(200) NULL
);
```

**Detailed Explanation:** Provides a persistent trail for incident response teams.

---

### Exercise 17.3: TRY...CATCH with THROW

**Task 3:** Rethrow after cleanup  
**Topic:** MS20761 Module 17 Lesson 3 – Use THROW to bubble errors  
**Beginner Explanation:** Clean up temp tables, log the failure, and rethrow so calling apps still know the operation failed.

```sql
BEGIN TRY
    CREATE TABLE #TempAudit (IndicatorID INT);
    INSERT INTO #TempAudit (IndicatorID)
    SELECT IndicatorID FROM EconomicIndicators WHERE IndicatorCode LIKE 'TEST-%';

    -- Force an error
    RAISERROR('Manual failure for training', 16, 1);
END TRY
BEGIN CATCH
    IF OBJECT_ID('tempdb..#TempAudit') IS NOT NULL DROP TABLE #TempAudit;

    INSERT INTO ErrorLog (ErrorDate, ErrNumber, ErrMessage, FailedProcedure)
    VALUES (SYSDATETIME(), ERROR_NUMBER(), ERROR_MESSAGE(), 'Module17Task3');

    THROW;  -- rethrow original error
END CATCH;
```

**Detailed Explanation:** `THROW` preserves the original error context after cleanup/logging finishes.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 17.4: Error handling with transactions

**Task 4:** Safe indicator creation workflow  
**Topic:** MS20761 Module 17 Lesson 4 – TRY...CATCH + transaction + THROW  
**Explanation:** Combine commits/rollbacks with error logging.

```sql
BEGIN TRY
    BEGIN TRAN;

    INSERT INTO EconomicIndicators (IndicatorCode, IndicatorName, CategoryID, UnitOfMeasure, DataSourceID, FrequencyID)
    VALUES ('NEW-FX', 'New FX Metric', 4, 'Millions USD', 3, 3);

    INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate)
    VALUES (SCOPE_IDENTITY(), '2024-10-01', 2024, 10, 900.0, 3, CAST(GETDATE() AS DATE));

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;

    INSERT INTO ErrorLog (ErrorDate, ErrNumber, ErrMessage, FailedProcedure)
    VALUES (SYSDATETIME(), ERROR_NUMBER(), ERROR_MESSAGE(), 'Module17Task4');

    THROW;
END CATCH;
```

**Detailed Explanation:** Ensures either both insert statements succeed together or neither is persisted.

---

## Testing Checklist
- [ ] Exercise 17.1 Task 1
- [ ] Exercise 17.2 Task 2
- [ ] Exercise 17.3 Task 3
- [ ] Exercise 17.4 Task 4

Attach captured error numbers/messages to `sql_validation_report.md`.
