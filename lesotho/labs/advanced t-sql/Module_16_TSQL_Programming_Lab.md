# Module 16: Programming with T-SQL
**Primary Topic:** Module 16: Programming with T-SQL

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 90 minutes  
**Difficulty:** Advanced  
**Prerequisites:** Modules 1-15 completed  
**Target Audience:** Analysts automating validation logic and conditional workflows

---

## Learning Objectives
1. Declare and manipulate variables for scenario analysis
2. Use IF/ELSE for conditional execution paths
3. Employ WHILE loops for batch-style processing
4. Build dynamic messages and logging statements
5. Combine procedural logic with set-based operations responsibly
6. Understand when to prefer stored procedures over ad-hoc scripts

---

## BEGINNER SECTION (Required)

### Exercise 16.1: Variables and IF blocks

**Task 1:** FX reserve alert script  
**Topic:** MS20761 Module 16 Lesson 1 – Variables, SELECT assignment, IF/ELSE output  
**Beginner Explanation:** Pull the latest FX reserves value into a variable then branch based on policy thresholds.

```sql
DECLARE @LatestReserves DECIMAL(18,2);
DECLARE @AlertThreshold DECIMAL(18,2) = 800.00;
DECLARE @WarningThreshold DECIMAL(18,2) = 950.00;

SELECT TOP (1) @LatestReserves = DataValue
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES'
ORDER BY ts.PeriodDate DESC;

IF @LatestReserves < @AlertThreshold
    PRINT CONCAT('ALERT: Reserves at ', @LatestReserves, ' (below critical threshold).');
ELSE IF @LatestReserves < @WarningThreshold
    PRINT CONCAT('Warning: Reserves at ', @LatestReserves, ' (monitor weekly).');
ELSE
    PRINT CONCAT('Reserves healthy at ', @LatestReserves, '.');
```

**Detailed Explanation:** Variables store thresholds, `SELECT TOP (1)` assigns the latest value, and chained IF statements print human-readable guidance.

---

### Exercise 16.2: WHILE loop processing

**Task 2:** Batch-validate pending submissions  
**Topic:** MS20761 Module 16 Lesson 2 – Looping with cursors/WHILE  
**Beginner Explanation:** Iterate through unvalidated submissions and mark them as reviewed in a controlled manner.

```sql
DECLARE @SubmissionID INT;

DECLARE SubmissionCursor CURSOR FOR
SELECT StatisticID
FROM BankingStatistics
WHERE IsValidated = 0;

OPEN SubmissionCursor;
FETCH NEXT FROM SubmissionCursor INTO @SubmissionID;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE BankingStatistics
    SET IsValidated = 1,
        ValidatedBy = 'automation_bot',
        ValidationDate = CAST(GETDATE() AS DATE)
    WHERE StatisticID = @SubmissionID;

    PRINT CONCAT('Validated submission ', @SubmissionID);

    FETCH NEXT FROM SubmissionCursor INTO @SubmissionID;
END

CLOSE SubmissionCursor;
DEALLOCATE SubmissionCursor;
```

**Detailed Explanation:** Demonstrates cursor-based iteration when set-based updates are not feasible (e.g., conditional external checks). Emphasize eventual refactor to set logic where possible.

---

### Exercise 16.3: Dynamic control flow

**Task 3:** Targeted quality review  
**Topic:** MS20761 Module 16 Lesson 3 – Combining variables, table-valued parameters, and logging  
**Beginner Explanation:** Build a script that selects indicators needing review, logs the action, and prepares follow-up statements.

```sql
DECLARE @IndicatorTable TABLE (IndicatorID INT, IndicatorCode NVARCHAR(50));

INSERT INTO @IndicatorTable (IndicatorID, IndicatorCode)
SELECT IndicatorID, IndicatorCode
FROM EconomicIndicators
WHERE IsActive = 1
  AND IndicatorCode LIKE 'CPI-%';

DECLARE @CurrentIndicator INT;
DECLARE @CurrentCode NVARCHAR(50);

WHILE EXISTS (SELECT 1 FROM @IndicatorTable)
BEGIN
    SELECT TOP (1) @CurrentIndicator = IndicatorID, @CurrentCode = IndicatorCode
    FROM @IndicatorTable;

    PRINT CONCAT('Running checks for ', @CurrentCode);

    INSERT INTO DataQualityChecks (IndicatorID, CheckDate, CheckType, CheckResult, CheckedBy)
    VALUES (@CurrentIndicator, CAST(GETDATE() AS DATE), 'Completeness', 'Pass', 'tsql_script');

    DELETE FROM @IndicatorTable WHERE IndicatorID = @CurrentIndicator;
END;
```

**Detailed Explanation:** Temporary table stores worklist entries; WHILE loop processes each indicator, demonstrating procedural automation.

---

## Testing Checklist
- [ ] Exercise 16.1 Task 1
- [ ] Exercise 16.2 Task 2
- [ ] Exercise 16.3 Task 3

Document console output and row counts inside `sql_validation_report.md`.
