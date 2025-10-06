# Module 7: Using DML to Modify Data - Theory Presentation

## Slide 1: Module Overview
**Using DML to Modify Data**

- INSERT statements for adding new data efficiently
- UPDATE statements for modifying existing records safely
- DELETE statements for removing data with proper controls
- MERGE statements for complex data synchronization
- Transaction control, concurrency, and data integrity

---

## Slide 2: Data Manipulation Language (DML) Overview
**DML Statement Types**

- **INSERT**: Add new rows to tables
- **UPDATE**: Modify existing row data
- **DELETE**: Remove rows from tables
- **MERGE**: Synchronize data between tables
- **TRUNCATE**: Fast removal of all table data (DDL, not DML)

**Key Concepts**: Atomicity, Consistency, Isolation, Durability (ACID)

---

## Slide 3: INSERT Statement Fundamentals
**Adding New Data**

```sql
-- Basic INSERT syntax
INSERT INTO table_name (column_list)
VALUES (value_list);

-- Multiple row INSERT
INSERT INTO table_name (column_list)
VALUES 
    (value_list1),
    (value_list2),
    (value_list3);

-- INSERT from SELECT
INSERT INTO table_name (column_list)
SELECT column_list FROM source_table WHERE condition;
```

---

## Slide 4: INSERT Statement Variations
**Different INSERT Approaches**

```sql
-- All columns (not recommended in production)
INSERT INTO Employees
VALUES (4001, 'John', 'Smith', 'john.smith@techcorp.com', '2023-01-15', 75000);

-- Specific columns (recommended)
INSERT INTO Employees (FirstName, LastName, Email, HireDate, Salary)
VALUES ('John', 'Smith', 'john.smith@techcorp.com', '2023-01-15', 75000);

-- With DEFAULT and NULL values
INSERT INTO Employees (FirstName, LastName, Email, HireDate, Salary, IsActive)
VALUES ('Jane', 'Doe', 'jane.doe@techcorp.com', DEFAULT, 65000, DEFAULT);
```

---

## Slide 5: INSERT with IDENTITY Columns
**Auto-Generated Primary Keys**

```sql
-- Table with IDENTITY column
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    HireDate DATE DEFAULT GETDATE()
);

-- INSERT without specifying IDENTITY
INSERT INTO Employees (FirstName, LastName, HireDate)
VALUES ('John', 'Smith', '2023-01-15');

-- Get the inserted IDENTITY value
SELECT SCOPE_IDENTITY() AS NewEmployeeID;
```

---

## Slide 6: Bulk INSERT Operations
**Efficient Large Data Insertion**

```sql
-- Multiple VALUES
INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary)
VALUES 
    ('John', 'Smith', 1, 75000),
    ('Jane', 'Doe', 2, 80000),
    ('Mike', 'Wilson', 1, 70000);

-- INSERT from SELECT (data migration)
INSERT INTO EmployeeBackup (EmployeeID, FirstName, LastName, BackupDate)
SELECT EmployeeID, FirstName, LastName, GETDATE()
FROM Employees
WHERE IsActive = 1;

-- INSERT with CTE
WITH NewHires AS (
    SELECT * FROM StagingEmployees WHERE ProcessDate = CAST(GETDATE() AS DATE)
)
INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary)
SELECT FirstName, LastName, DepartmentID, Salary FROM NewHires;
```

---

## Slide 7: UPDATE Statement Fundamentals
**Modifying Existing Data**

```sql
-- Basic UPDATE syntax
UPDATE table_name
SET column1 = value1,
    column2 = value2
WHERE condition;

-- Example: Salary increase
UPDATE Employees
SET Salary = Salary * 1.05,
    LastModified = GETDATE()
WHERE DepartmentID = 1
    AND IsActive = 1;
```

**Critical**: Always use WHERE clause to prevent unintended updates

---

## Slide 8: UPDATE with JOINs
**Complex Update Scenarios**

```sql
-- UPDATE with INNER JOIN
UPDATE e
SET e.Salary = e.Salary * (1 + d.BonusMultiplier),
    e.LastModified = GETDATE()
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.PerformanceRating >= 4
    AND d.BudgetApproved = 1;

-- UPDATE with subquery
UPDATE Employees
SET Salary = (
    SELECT AVG(Salary) * 1.1
    FROM Employees e2
    WHERE e2.DepartmentID = Employees.DepartmentID
      AND e2.IsActive = 1
)
WHERE PerformanceRating >= 4;
```

---

## Slide 9: Conditional UPDATE Operations
**Smart Data Modifications**

```sql
-- CASE expressions in UPDATE
UPDATE Employees
SET SalaryBand = 
    CASE 
        WHEN Salary >= 100000 THEN 'Executive'
        WHEN Salary >= 75000 THEN 'Senior'
        WHEN Salary >= 50000 THEN 'Mid-Level'
        ELSE 'Junior'
    END,
    LastReviewDate = GETDATE()
WHERE LastReviewDate < DATEADD(YEAR, -1, GETDATE());

-- Conditional logic
UPDATE Projects
SET Status = 
    CASE 
        WHEN GETDATE() > PlannedEndDate AND Status = 'Active' THEN 'Overdue'
        WHEN GETDATE() > PlannedEndDate AND Status = 'Completed' THEN 'Completed Late'
        ELSE Status
    END;
```

---

## Slide 10: DELETE Statement Fundamentals
**Removing Data Safely**

```sql
-- Basic DELETE syntax
DELETE FROM table_name
WHERE condition;

-- Example: Remove inactive employees
DELETE FROM Employees
WHERE IsActive = 0
    AND TerminationDate < DATEADD(YEAR, -2, GETDATE());

-- DELETE with EXISTS
DELETE FROM Projects
WHERE NOT EXISTS (
    SELECT 1 FROM Employees 
    WHERE EmployeeID = Projects.ProjectManagerID
        AND IsActive = 1
);
```

**Warning**: DELETE without WHERE removes all rows!

---

## Slide 11: DELETE with JOINs
**Complex Deletion Scenarios**

```sql
-- DELETE with JOIN (SQL Server syntax)
DELETE e
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.IsActive = 0
    AND e.LastLoginDate < DATEADD(MONTH, -6, GETDATE());

-- Alternative using EXISTS
DELETE FROM Employees
WHERE EXISTS (
    SELECT 1 FROM Departments d
    WHERE d.DepartmentID = Employees.DepartmentID
        AND d.IsActive = 0
)
AND LastLoginDate < DATEADD(MONTH, -6, GETDATE());
```

---

## Slide 12: Soft DELETE Pattern
**Logical Data Removal**

```sql
-- Soft delete implementation
UPDATE Employees
SET IsActive = 0,
    TerminationDate = GETDATE(),
    TerminatedBy = SYSTEM_USER
WHERE EmployeeID = @EmployeeID;

-- Views for active data only
CREATE VIEW ActiveEmployees AS
SELECT EmployeeID, FirstName, LastName, Email, Salary
FROM Employees
WHERE IsActive = 1;

-- Queries using soft delete
SELECT * FROM ActiveEmployees
WHERE DepartmentID = 1;
```

**Benefits**: Data retention, audit trails, referential integrity

---

## Slide 13: TRUNCATE vs DELETE
**Performance Considerations**

```sql
-- DELETE (slower, logged, can rollback)
DELETE FROM StagingTable;

-- TRUNCATE (faster, minimally logged, cannot rollback easily)
TRUNCATE TABLE StagingTable;
```

**TRUNCATE Characteristics**:
- Faster for large tables
- Resets IDENTITY seed
- Cannot use WHERE clause
- Minimal logging
- Requires ALTER permission

---

## Slide 14: MERGE Statement Introduction
**Data Synchronization**

```sql
-- MERGE syntax overview
MERGE target_table AS target
USING source_table AS source
ON merge_condition
WHEN MATCHED THEN
    UPDATE SET column1 = source.value1
WHEN NOT MATCHED BY TARGET THEN
    INSERT (columns) VALUES (source.values)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

**Use Cases**: ETL processes, data synchronization, upsert operations

---

## Slide 15: MERGE Statement Examples
**Practical MERGE Implementation**

```sql
-- Employee data synchronization
MERGE Employees AS target
USING EmployeeUpdates AS source
ON target.EmployeeID = source.EmployeeID
WHEN MATCHED AND source.LastModified > target.LastModified THEN
    UPDATE SET 
        FirstName = source.FirstName,
        LastName = source.LastName,
        Email = source.Email,
        Salary = source.Salary,
        LastModified = source.LastModified
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, FirstName, LastName, Email, Salary, LastModified)
    VALUES (source.EmployeeID, source.FirstName, source.LastName, 
            source.Email, source.Salary, source.LastModified)
WHEN NOT MATCHED BY SOURCE AND target.IsActive = 1 THEN
    UPDATE SET IsActive = 0, TerminationDate = GETDATE();
```

---

## Slide 16: OUTPUT Clause
**Capturing DML Results**

```sql
-- INSERT with OUTPUT
INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary)
OUTPUT INSERTED.EmployeeID, INSERTED.FirstName, INSERTED.LastName
VALUES ('John', 'Smith', 1, 75000);

-- UPDATE with OUTPUT
UPDATE Employees
SET Salary = Salary * 1.05
OUTPUT 
    DELETED.EmployeeID,
    DELETED.Salary AS OldSalary,
    INSERTED.Salary AS NewSalary,
    GETDATE() AS UpdateTime
WHERE DepartmentID = 1;

-- DELETE with OUTPUT
DELETE FROM Employees
OUTPUT DELETED.*
WHERE IsActive = 0;
```

---

## Slide 17: Transaction Control
**Ensuring Data Consistency**

```sql
-- Explicit transaction
BEGIN TRANSACTION;

    -- Multiple DML operations
    UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1;
    UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 2;
    
    -- Check for errors
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transaction rolled back due to error';
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Transaction committed successfully';
    END

-- Using TRY-CATCH
BEGIN TRY
    BEGIN TRANSACTION;
    -- DML operations here
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
```

---

## Slide 18: Concurrency and Locking
**Multi-User Considerations**

```sql
-- Lock hints for specific scenarios
SELECT * FROM Employees WITH (NOLOCK);  -- Read uncommitted

UPDATE Employees WITH (ROWLOCK)
SET Salary = 75000
WHERE EmployeeID = 1001;

-- Avoiding deadlocks
-- Always access tables in same order
-- Keep transactions short
-- Use appropriate isolation levels

-- Checking for locks
SELECT 
    resource_type,
    resource_database_id,
    resource_description,
    request_mode,
    request_status
FROM sys.dm_tran_locks
WHERE request_session_id = @@SPID;
```

---

## Slide 19: Error Handling in DML
**Robust Data Modification**

```sql
-- Error handling with TRY-CATCH
BEGIN TRY
    INSERT INTO Employees (FirstName, LastName, Email, DepartmentID)
    VALUES ('John', 'Smith', 'john.smith@techcorp.com', 999);  -- Invalid DepartmentID
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_LINE() AS ErrorLine;
        
    -- Log error to audit table
    INSERT INTO ErrorLog (ErrorMessage, ErrorDate, UserName)
    VALUES (ERROR_MESSAGE(), GETDATE(), SYSTEM_USER);
END CATCH
```

---

## Slide 20: Constraints and DML
**Data Integrity Enforcement**

```sql
-- PRIMARY KEY constraint
-- Prevents duplicate keys during INSERT

-- FOREIGN KEY constraint  
-- Prevents invalid references during INSERT/UPDATE

-- CHECK constraint
-- Validates data values during INSERT/UPDATE

-- UNIQUE constraint
-- Prevents duplicate values during INSERT/UPDATE

-- NOT NULL constraint
-- Requires values during INSERT/UPDATE

-- Example with constraint violation handling
INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Salary)
VALUES ('John', 'Smith', 'existing@email.com', 1, -50000);  -- May violate constraints
```

---

## Slide 21: Stored Procedures for DML
**Encapsulating Data Operations**

```sql
-- Stored procedure for employee management
CREATE PROCEDURE sp_AddEmployee
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DepartmentID INT,
    @Salary MONEY,
    @NewEmployeeID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Salary)
        VALUES (@FirstName, @LastName, @Email, @DepartmentID, @Salary);
        
        SET @NewEmployeeID = SCOPE_IDENTITY();
        
        -- Log the operation
        INSERT INTO AuditLog (Action, TableName, RecordID, UserName, ActionDate)
        VALUES ('INSERT', 'Employees', @NewEmployeeID, SYSTEM_USER, GETDATE());
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
```

---

## Slide 22: Performance Optimization for DML
**Efficient Data Modifications**

```sql
-- Batch processing for large updates
DECLARE @BatchSize INT = 1000;
DECLARE @RowsUpdated INT = @BatchSize;

WHILE @RowsUpdated = @BatchSize
BEGIN
    UPDATE TOP (@BatchSize) Employees
    SET IsActive = 0
    WHERE TerminationDate < DATEADD(YEAR, -2, GETDATE())
        AND IsActive = 1;
    
    SET @RowsUpdated = @@ROWCOUNT;
    
    -- Small delay to reduce blocking
    WAITFOR DELAY '00:00:01';
END

-- Index considerations
-- Ensure WHERE clause columns are indexed
-- Consider impact on INSERT/UPDATE/DELETE performance
-- Monitor index fragmentation after bulk operations
```

---

## Slide 23: Data Validation Strategies
**Ensuring Data Quality**

```sql
-- Input validation before DML
IF @Salary < 0 OR @Salary > 1000000
BEGIN
    RAISERROR('Salary must be between 0 and 1,000,000', 16, 1);
    RETURN;
END

-- Business rule validation
IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @DepartmentID AND IsActive = 1)
BEGIN
    RAISERROR('Invalid or inactive department', 16, 1);
    RETURN;
END

-- Data format validation
IF @Email NOT LIKE '%@%.%'
BEGIN
    RAISERROR('Invalid email format', 16, 1);
    RETURN;
END
```

---

## Slide 24: Common DML Mistakes
**Pitfalls to Avoid**

```sql
-- Mistake 1: Missing WHERE clause
UPDATE Employees SET Salary = 100000;  -- Updates ALL employees!

-- Mistake 2: Incorrect JOIN in UPDATE/DELETE
UPDATE e SET Salary = 50000
FROM Employees e, Departments d  -- Cartesian product!

-- Mistake 3: Not handling NULLs
UPDATE Employees SET FullName = FirstName + ' ' + LastName;  -- NULL if MiddleName is involved

-- Mistake 4: Ignoring transaction boundaries
-- Multiple related operations without proper transaction control

-- Mistake 5: Not using parameterized queries (SQL injection risk)
EXEC('UPDATE Employees SET Salary = ' + @UserInput);  -- Dangerous!
```

---

## Slide 25: Learning Objectives Achieved
**Module 7 Outcomes**

✅ Master INSERT statements for efficient data addition
✅ Implement UPDATE statements with proper safety controls
✅ Use DELETE statements responsibly with appropriate filtering
✅ Apply MERGE statements for complex data synchronization
✅ Handle transactions, concurrency, and error scenarios
✅ Optimize DML performance for large-scale operations

---

## Slide 26: Next Steps
**Module 8 Preview: Built-in Functions (🔴 EXPERT LEVEL)**

- Advanced string manipulation and pattern matching
- Complex date/time calculations and formatting
- Mathematical functions for business calculations
- Conversion functions and data type handling
- System functions for metadata and administration
- Performance optimization with function usage

**Key Preparation**
- Practice complex DML scenarios with sample data
- Understand transaction isolation levels and locking
- Review constraint types and their DML implications