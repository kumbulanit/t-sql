# Module 7: DML - Data Modification
## Central Bank of Lesotho - Data Management Division

### Lab Overview
**Duration:** 90-120 minutes  
**Difficulty:** Intermediate to Advanced  
**Prerequisites:** Modules 1-6 completed

### ⚠️ IMPORTANT SAFETY NOTICE
This module involves INSERT, UPDATE, and DELETE operations. Always:
- Work in a test environment first
- Use transactions for safety
- Test SELECT before UPDATE/DELETE
- Keep backups of important data
- Use WHERE clauses carefully

---

## Learning Objectives
1. Insert new data records safely
2. Update existing data correctly
3. Delete data with precision
4. Use transactions for data integrity
5. Handle errors and maintain audit trails

---

## BEGINNER SECTION (Required)

### Exercise 7.1: INSERT - Single Row

**Task 1:** Add a new data source
```sql
-- Insert a new external data source
INSERT INTO DataSources (
    SourceCode,
    SourceName,
    SourceType,
    Description
)
VALUES (
    'SARB',
    'South African Reserve Bank',
    'External',
    'Regional central bank data provider'
);

-- Verify the insertion
SELECT *
FROM DataSources
WHERE SourceCode = 'SARB';
```

---

**Task 2:** Add a new economic indicator
```sql
-- Insert tourism indicator
INSERT INTO EconomicIndicators (
    IndicatorCode,
    IndicatorName,
    Description,
    CategoryID,
    DataSourceID,
    FrequencyID,
    UnitOfMeasure,
    IsActive
)
VALUES (
    'TOUR_ARR',
    'Tourist Arrivals',
    'Monthly tourist arrival numbers',
    8,  -- External Sector category
    1,  -- Bureau of Statistics
    3,  -- Monthly
    'Number',
    1
);

-- Verify
SELECT 
    ei.IndicatorCode,
    ei.IndicatorName,
    ic.CategoryName,
    ds.SourceName,
    df.FrequencyName
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataSources ds ON ei.DataSourceID = ds.DataSourceID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
WHERE ei.IndicatorCode = 'TOUR_ARR';
```

---

### Exercise 7.2: INSERT - Multiple Rows

**Task 3:** Add multiple time series data points
```sql
-- Insert several months of inflation data
INSERT INTO TimeSeriesData (
    IndicatorID,
    PeriodDate,
    DataValue,
    IsProvisional,
    EntryDate,
    EnteredBy
)
VALUES 
    (6, '2024-10-01', 5.2, 1, GETDATE(), 'training_user'),
    (6, '2024-11-01', 5.4, 1, GETDATE(), 'training_user'),
    (6, '2024-12-01', 5.6, 1, GETDATE(), 'training_user');

-- Verify insertion
SELECT 
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    CASE WHEN ts.IsProvisional = 1 THEN 'Provisional' ELSE 'Final' END AS Status
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorID = 6
  AND ts.PeriodDate >= '2024-10-01'
ORDER BY ts.PeriodDate;
```

---

**Task 4:** Insert data from SELECT query
```sql
-- Create backup of Q3 2024 banking statistics
-- First, create a backup table structure
SELECT TOP 0 *
INTO BankingStatistics_Backup
FROM BankingStatistics;

-- Insert Q3 2024 data into backup
INSERT INTO BankingStatistics_Backup
SELECT *
FROM BankingStatistics
WHERE ReportingDate = '2024-09-30';

-- Verify
SELECT 
    COUNT(*) AS 'Records Backed Up',
    MIN(ReportingDate) AS 'Date',
    SUM(TotalAssets) AS 'Total Assets Backed Up'
FROM BankingStatistics_Backup;
```

---

### Exercise 7.3: UPDATE - Single Column

**Task 5:** Correct a data value
```sql
-- First, view current value
SELECT 
    TimeSeriesID,
    IndicatorID,
    PeriodDate,
    DataValue,
    IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 4  -- CPI
  AND PeriodDate = '2024-09-01';

-- Update the value (example: correcting CPI)
UPDATE TimeSeriesData
SET DataValue = 108.5
WHERE IndicatorID = 4
  AND PeriodDate = '2024-09-01';

-- Verify the update
SELECT 
    TimeSeriesID,
    IndicatorID,
    PeriodDate,
    DataValue,
    IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 4
  AND PeriodDate = '2024-09-01';
```

---

**Task 6:** Mark provisional data as final
```sql
-- View provisional data
SELECT 
    ei.IndicatorCode,
    ts.PeriodDate,
    ts.DataValue,
    ts.IsProvisional
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ts.PeriodDate = '2024-08-01'
  AND ts.IsProvisional = 1;

-- Update to final status
UPDATE TimeSeriesData
SET IsProvisional = 0,
    LastModifiedDate = GETDATE(),
    LastModifiedBy = 'data_quality_team'
WHERE PeriodDate = '2024-08-01'
  AND IsProvisional = 1;

-- Verify
SELECT 
    ei.IndicatorCode,
    ts.PeriodDate,
    ts.DataValue,
    CASE WHEN ts.IsProvisional = 1 THEN 'Provisional' ELSE 'Final' END AS Status
FROM TimeSeriesData ts
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ts.PeriodDate = '2024-08-01';
```

---

### Exercise 7.4: DELETE - Selective Removal

**Task 7:** Remove test data
```sql
-- View test records first
SELECT *
FROM TimeSeriesData
WHERE EnteredBy = 'training_user'
  AND PeriodDate >= '2024-10-01';

-- Delete test records
DELETE FROM TimeSeriesData
WHERE EnteredBy = 'training_user'
  AND PeriodDate >= '2024-10-01';

-- Verify deletion (should return 0 rows)
SELECT COUNT(*) AS 'Remaining Test Records'
FROM TimeSeriesData
WHERE EnteredBy = 'training_user'
  AND PeriodDate >= '2024-10-01';
```

---

## INTERMEDIATE SECTION (Optional)

### Exercise 7.5: UPDATE with JOIN

**Task 8:** Update based on related table data
```sql
-- Update indicator descriptions based on category
UPDATE ei
SET ei.Description = CONCAT(
    ic.CategoryName, 
    ' indicator: ', 
    ei.IndicatorName,
    ' measured ', 
    df.FrequencyName
)
FROM EconomicIndicators ei
INNER JOIN IndicatorCategories ic ON ei.CategoryID = ic.CategoryID
INNER JOIN DataFrequencies df ON ei.FrequencyID = df.FrequencyID
WHERE ei.Description IS NULL
  OR ei.Description = '';

-- Verify updates
SELECT 
    IndicatorCode,
    IndicatorName,
    Description
FROM EconomicIndicators
WHERE Description LIKE '%indicator:%';
```

---

**Task 9:** Populate calculated fields
```sql
-- Add calculated ratios to banking statistics
UPDATE bs
SET bs.LoanToAssetRatio = ROUND((bs.TotalLoans / bs.TotalAssets) * 100, 2),
    bs.DepositToAssetRatio = ROUND((bs.TotalDeposits / bs.TotalAssets) * 100, 2)
FROM BankingStatistics bs
WHERE bs.LoanToAssetRatio IS NULL;

-- Verify calculations
SELECT 
    cb.BankName,
    bs.ReportingDate,
    bs.TotalLoans,
    bs.TotalAssets,
    bs.LoanToAssetRatio AS 'Calculated Ratio'
FROM BankingStatistics bs
INNER JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30';
```

---

### Exercise 7.6: Transactions - Basic

**Task 10:** Safe multi-step data entry
```sql
-- Begin transaction for new indicator and its data
BEGIN TRANSACTION;

    -- Insert new indicator
    DECLARE @NewIndicatorID INT;
    
    INSERT INTO EconomicIndicators (
        IndicatorCode,
        IndicatorName,
        Description,
        CategoryID,
        DataSourceID,
        FrequencyID,
        UnitOfMeasure,
        IsActive
    )
    VALUES (
        'REMIT_IN',
        'Remittance Inflows',
        'Monthly remittances from abroad',
        8,  -- External Sector
        1,  -- Bureau of Statistics
        3,  -- Monthly
        'Millions',
        1
    );
    
    -- Get the new ID
    SET @NewIndicatorID = SCOPE_IDENTITY();
    
    -- Insert initial data
    INSERT INTO TimeSeriesData (
        IndicatorID,
        PeriodDate,
        DataValue,
        IsProvisional,
        EntryDate,
        EnteredBy
    )
    VALUES 
        (@NewIndicatorID, '2024-07-01', 450.5, 0, GETDATE(), 'migration_team'),
        (@NewIndicatorID, '2024-08-01', 465.2, 0, GETDATE(), 'migration_team'),
        (@NewIndicatorID, '2024-09-01', 478.9, 1, GETDATE(), 'migration_team');
    
    -- Verify before commit
    SELECT 
        ei.IndicatorCode,
        ei.IndicatorName,
        ts.PeriodDate,
        ts.DataValue
    FROM EconomicIndicators ei
    INNER JOIN TimeSeriesData ts ON ei.IndicatorID = ts.IndicatorID
    WHERE ei.IndicatorID = @NewIndicatorID;

-- If everything looks good, commit
COMMIT TRANSACTION;
-- If there's an issue, use: ROLLBACK TRANSACTION;
```

---

### Exercise 7.7: Conditional Updates

**Task 11:** Update with CASE logic
```sql
-- Update data quality status based on rules
UPDATE dq
SET dq.QualityStatus = CASE
    WHEN ts.DataValue IS NULL THEN 'Error'
    WHEN ts.DataValue < 0 AND ei.UnitOfMeasure IN ('Millions', 'Number') THEN 'Flagged'
    WHEN ABS(ts.DataValue - AVG(ts.DataValue) OVER (PARTITION BY ts.IndicatorID)) > 
         3 * STDEV(ts.DataValue) OVER (PARTITION BY ts.IndicatorID) THEN 'Flagged'
    ELSE 'Validated'
END,
    dq.CheckDate = GETDATE()
FROM DataQualityChecks dq
INNER JOIN TimeSeriesData ts ON dq.TimeSeriesID = ts.TimeSeriesID
INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ts.PeriodDate >= '2024-01-01';

-- Review quality distribution
SELECT 
    QualityStatus,
    COUNT(*) AS 'Count',
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2) AS 'Percentage'
FROM DataQualityChecks
WHERE CheckDate >= CAST(GETDATE() AS DATE)
GROUP BY QualityStatus;
```

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 7.8: Complex Transaction with Error Handling

**Task 12:** Robust data revision process
```sql
-- Revise data with full audit trail
BEGIN TRY
    BEGIN TRANSACTION;
    
        DECLARE @IndicatorID INT = 6;  -- Inflation Rate
        DECLARE @PeriodDate DATE = '2024-07-01';
        DECLARE @NewValue DECIMAL(18,4) = 5.35;
        DECLARE @RevisionReason VARCHAR(500) = 'Source data correction from BOS';
        DECLARE @OldValue DECIMAL(18,4);
        
        -- Get old value
        SELECT @OldValue = DataValue
        FROM TimeSeriesData
        WHERE IndicatorID = @IndicatorID
          AND PeriodDate = @PeriodDate;
        
        -- Store revision in audit table (create if doesn't exist)
        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DataRevisions')
        BEGIN
            CREATE TABLE DataRevisions (
                RevisionID INT IDENTITY(1,1) PRIMARY KEY,
                IndicatorID INT,
                PeriodDate DATE,
                OldValue DECIMAL(18,4),
                NewValue DECIMAL(18,4),
                RevisionReason VARCHAR(500),
                RevisionDate DATETIME,
                RevisedBy VARCHAR(100)
            );
        END
        
        INSERT INTO DataRevisions (
            IndicatorID,
            PeriodDate,
            OldValue,
            NewValue,
            RevisionReason,
            RevisionDate,
            RevisedBy
        )
        VALUES (
            @IndicatorID,
            @PeriodDate,
            @OldValue,
            @NewValue,
            @RevisionReason,
            GETDATE(),
            SYSTEM_USER
        );
        
        -- Update the actual data
        UPDATE TimeSeriesData
        SET DataValue = @NewValue,
            RevisedValue = @OldValue,
            RevisionDate = GETDATE(),
            LastModifiedDate = GETDATE(),
            LastModifiedBy = SYSTEM_USER
        WHERE IndicatorID = @IndicatorID
          AND PeriodDate = @PeriodDate;
        
        -- Verify revision
        SELECT 
            'Revision Complete' AS Status,
            ei.IndicatorName,
            ts.PeriodDate,
            ts.RevisedValue AS 'Old Value',
            ts.DataValue AS 'New Value',
            ts.RevisionDate
        FROM TimeSeriesData ts
        INNER JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
        WHERE ts.IndicatorID = @IndicatorID
          AND ts.PeriodDate = @PeriodDate;
    
    COMMIT TRANSACTION;
    PRINT 'Revision completed successfully';
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    PRINT 'Revision rolled back';
END CATCH;
```

---

### Exercise 7.9: Bulk Data Operations

**Task 13:** Efficient bulk insert from staging
```sql
-- Create staging table for bulk import
IF OBJECT_ID('TimeSeriesData_Staging', 'U') IS NOT NULL
    DROP TABLE TimeSeriesData_Staging;

CREATE TABLE TimeSeriesData_Staging (
    IndicatorCode VARCHAR(20),
    PeriodDate DATE,
    DataValue DECIMAL(18,4),
    IsProvisional BIT,
    SourceFile VARCHAR(200)
);

-- Simulate bulk import
INSERT INTO TimeSeriesData_Staging (IndicatorCode, PeriodDate, DataValue, IsProvisional, SourceFile)
VALUES 
    ('CPI_ALL', '2024-10-01', 109.2, 1, 'BOS_October_2024.xlsx'),
    ('CPI_FOOD', '2024-10-01', 112.5, 1, 'BOS_October_2024.xlsx'),
    ('INF_RATE', '2024-10-01', 5.8, 1, 'BOS_October_2024.xlsx'),
    ('M2_TOTAL', '2024-10-01', 15200.0, 1, 'CBL_Monetary_Oct2024.xlsx'),
    ('FX_USD', '2024-10-15', 18.25, 0, 'CBL_Daily_FX.xlsx');

-- Validate and insert into main table
BEGIN TRANSACTION;

    -- Insert valid records
    INSERT INTO TimeSeriesData (
        IndicatorID,
        PeriodDate,
        DataValue,
        IsProvisional,
        EntryDate,
        EnteredBy
    )
    SELECT 
        ei.IndicatorID,
        stg.PeriodDate,
        stg.DataValue,
        stg.IsProvisional,
        GETDATE(),
        'bulk_import_' + stg.SourceFile
    FROM TimeSeriesData_Staging stg
    INNER JOIN EconomicIndicators ei ON stg.IndicatorCode = ei.IndicatorCode
    WHERE NOT EXISTS (
        -- Avoid duplicates
        SELECT 1
        FROM TimeSeriesData ts
        WHERE ts.IndicatorID = ei.IndicatorID
          AND ts.PeriodDate = stg.PeriodDate
    );
    
    -- Log import results
    SELECT 
        'Import Summary' AS Report,
        COUNT(*) AS 'Records Processed',
        SUM(CASE WHEN ei.IndicatorID IS NOT NULL THEN 1 ELSE 0 END) AS 'Valid Records',
        SUM(CASE WHEN ei.IndicatorID IS NULL THEN 1 ELSE 0 END) AS 'Invalid Codes'
    FROM TimeSeriesData_Staging stg
    LEFT JOIN EconomicIndicators ei ON stg.IndicatorCode = ei.IndicatorCode;

COMMIT TRANSACTION;
```

---

### Exercise 7.10: Cascading Updates

**Task 14:** Update related records consistently
```sql
-- Change indicator frequency and update all related records
BEGIN TRANSACTION;

    DECLARE @TargetIndicatorID INT = 1;  -- Example indicator
    DECLARE @NewFrequencyID INT = 4;  -- Change to Quarterly
    
    -- Update indicator frequency
    UPDATE EconomicIndicators
    SET FrequencyID = @NewFrequencyID,
        LastModifiedDate = GETDATE()
    WHERE IndicatorID = @TargetIndicatorID;
    
    -- Archive incompatible time series data
    SELECT *
    INTO TimeSeriesData_Archive_Freq_Change
    FROM TimeSeriesData
    WHERE IndicatorID = @TargetIndicatorID
      AND DAY(PeriodDate) NOT IN (31, 30);  -- Keep only quarter-end dates
    
    -- Remove non-quarterly data
    DELETE FROM TimeSeriesData
    WHERE IndicatorID = @TargetIndicatorID
      AND DAY(PeriodDate) NOT IN (31, 30);
    
    -- Log the change
    PRINT CONCAT('Frequency changed for indicator ', @TargetIndicatorID);
    PRINT CONCAT(@@ROWCOUNT, ' non-quarterly records archived');

COMMIT TRANSACTION;
```

---

### Exercise 7.11: Merge Operations (UPSERT)

**Task 15:** Insert or update based on existence
```sql
-- Merge new banking statistics (insert if new, update if exists)
MERGE INTO BankingStatistics AS target
USING (
    VALUES 
        (1, '2024-09-30', 8500.00, 5200.00, 6800.00, 3.5, '2024-10-15', 1),
        (2, '2024-09-30', 6200.00, 3800.00, 5100.00, 2.8, '2024-10-15', 1)
) AS source (BankID, ReportingDate, TotalAssets, TotalLoans, TotalDeposits, NPLRatio, SubmittedDate, IsValidated)
ON (target.BankID = source.BankID AND target.ReportingDate = source.ReportingDate)

WHEN MATCHED THEN
    UPDATE SET 
        target.TotalAssets = source.TotalAssets,
        target.TotalLoans = source.TotalLoans,
        target.TotalDeposits = source.TotalDeposits,
        target.NPLRatio = source.NPLRatio,
        target.SubmittedDate = source.SubmittedDate,
        target.IsValidated = source.IsValidated,
        target.LastModifiedDate = GETDATE()

WHEN NOT MATCHED THEN
    INSERT (BankID, ReportingDate, TotalAssets, TotalLoans, TotalDeposits, NPLRatio, SubmittedDate, IsValidated)
    VALUES (source.BankID, source.ReportingDate, source.TotalAssets, source.TotalLoans, 
            source.TotalDeposits, source.NPLRatio, source.SubmittedDate, source.IsValidated)

OUTPUT 
    $action AS Action,
    inserted.BankID,
    inserted.ReportingDate,
    inserted.TotalAssets;
```

---

## Practice Exercises (Do It Yourself)

### Beginner
1. Insert a new staff member into ResearchStaff
2. Update bank contact information
3. Delete old quality check records (>1 year)
4. Insert quarterly GDP values

### Intermediate
5. Update all provisional data to final for August 2024
6. Insert time series data using values from another indicator
7. Delete duplicate time series entries
8. Update indicator categories in bulk

### Advanced
9. Create stored procedure for data revision with audit
10. Implement soft delete (IsDeleted flag) instead of hard delete
11. Build ETL process with staging, validation, and loading
12. Create trigger to log all data modifications

---

## Real-World Scenarios

### Scenario 1: Monthly Data Collection Process
The Data Management Division receives monthly submissions from 12 sources. Write a complete DML script that:
1. Creates staging tables for each source
2. Validates data before insertion
3. Inserts valid records with proper audit fields
4. Logs any validation failures
5. Commits successfully or rolls back entirely

### Scenario 2: Data Revision Workflow
A data provider submitted a correction for three months of historical data. Create a transaction that:
1. Backs up original values
2. Updates the main data table
3. Records revision history
4. Sends notification (simulated)
5. Handles any errors gracefully

### Scenario 3: Year-End Data Finalization
At fiscal year end, all provisional data must be marked final. Build a script that:
1. Identifies all provisional records for completed fiscal year
2. Validates data quality
3. Updates IsProvisional flag
4. Archives any flagged records
5. Generates completion report

---

## Key Takeaways

✅ **INSERT:**
- Add new records to tables
- Can insert single or multiple rows
- Use SELECT to insert from queries
- Get new identity with SCOPE_IDENTITY()

✅ **UPDATE:**
- Modify existing records
- Always use WHERE clause (unless intentional)
- Can update with JOINs
- Use CASE for conditional updates

✅ **DELETE:**
- Remove records permanently
- Always use WHERE clause
- Consider soft deletes for audit
- Test with SELECT first

✅ **TRANSACTIONS:**
- BEGIN TRANSACTION starts
- COMMIT saves changes
- ROLLBACK undoes changes
- Use TRY/CATCH for error handling

✅ **Best Practices:**
- Always use transactions for critical data
- Test with SELECT before DELETE/UPDATE
- Maintain audit trails
- Use WHERE clauses carefully
- Back up before major changes
- Log all modifications

---

## Safety Checklist

Before running DML statements:
- [ ] Have I tested with SELECT first?
- [ ] Am I in the correct database?
- [ ] Do I have a backup?
- [ ] Is my WHERE clause specific enough?
- [ ] Am I using a transaction?
- [ ] Do I have error handling?
- [ ] Have I verified the affected row count?
- [ ] Can I roll back if needed?

---

## Completion Certificate

🎓 **Congratulations!**

You have completed all 7 modules of the CBL Data Management SQL Training Series. You now have the skills to:
- Query complex economic datasets
- Join multiple tables for analysis
- Aggregate and summarize data
- Format output for reports
- Modify data safely with transactions
- Build production-ready SQL scripts

**Next Steps:**
- Apply these skills to real CBL data
- Build automated reporting queries
- Develop data quality checks
- Create stored procedures for workflows

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 7 (Final)*
