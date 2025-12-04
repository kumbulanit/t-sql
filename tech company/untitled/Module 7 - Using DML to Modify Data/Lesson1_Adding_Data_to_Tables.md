# Lesson 1: Adding Data to Tables

## Overview
The INSERT statement is the primary method for adding data to tables in SQL Server. This lesson covers all aspects of inserting data, from basic single-row inserts to complex multi-table scenarios. Understanding proper INSERT techniques is fundamental to effective database management and application development.

## INSERT Statement Fundamentals

### Basic INSERT Syntax
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INSERT STATEMENT SYNTAX                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Basic Forms:                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. INSERT with VALUES clause:                                          │
│  │    INSERT INTO table_name [(column_list)]                              │
│  │    VALUES (value_list);                                                │
│  │                                                                         │
│  │ 2. INSERT with SELECT statement:                                       │
│  │    INSERT INTO table_name [(column_list)]                              │
│  │    SELECT columns FROM source_table [WHERE conditions];                │
│  │                                                                         │
│  │ 3. INSERT with TOP clause:                                             │
│  │    INSERT TOP (n) INTO table_name [(column_list)]                      │
│  │    SELECT columns FROM source_table;                                   │
│  │                                                                         │
│  │ 4. INSERT with OUTPUT clause:                                          │
│  │    INSERT INTO table_name [(column_list)]                              │
│  │    OUTPUT inserted.column1, inserted.column2                           │
│  │    VALUES (value_list);                                                │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Execution Flow:                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. Parse and validate SQL syntax                                       │
│  │ 2. Check table and column existence                                    │
│  │ 3. Validate data types and constraints                                 │
│  │ 4. Acquire necessary locks                                             │
│  │ 5. Insert data into data pages                                         │
│  │ 6. Update indexes                                                      │
│  │ 7. Log transaction details                                             │
│  │ 8. Check foreign key constraints                                       │
│  │ 9. Fire triggers (if any)                                             │
│  │ 10. Commit or rollback transaction                                     │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Table Setup for Examples
```sql
-- Create sample tables for INSERT demonstrations
CREATE TABLE Employees (
    e.EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    e.FirstName NVARCHAR(50) NOT NULL,
    e.LastName NVARCHAR(50) NOT NULL,
    WorkEmail NVARCHAR(100) UNIQUE,
    e.HireDate DATE DEFAULT GETDATE(),
    e.BaseSalary DECIMAL(10,2),
    d.DepartmentID INT,
    ManagerID INT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2 DEFAULT SYSDATETIME()
);

CREATE TABLE Departments (
    d.DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    d.DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    Location NVARCHAR(100),
    ManagerID INT,
    d.Budget DECIMAL(12,2),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
);

CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    StartDate DATE,
    EndDate DATE,
    d.Budget DECIMAL(12,2),
    IsActive NVARCHAR(20) DEFAULT 'Planning',
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Add foreign key relationships
ALTER TABLE Employees 
ADD CONSTRAINT FK_Employees_Department 
FOREIGN KEY (d.DepartmentID) REFERENCES Departments(d.DepartmentID);

ALTER TABLE Employees 
ADD CONSTRAINT FK_Employees_Manager 
FOREIGN KEY (ManagerID) REFERENCES Employees(e.EmployeeID);
```

## Basic INSERT Operations

### Single Row Inserts
```sql
-- Basic INSERT with all columns specified
INSERT INTO Departments (d.DepartmentName, Location, d.Budget)
VALUES ('Information Technology', 'Building A, Floor 3', 500000.00);

INSERT INTO Departments (d.DepartmentName, Location, d.Budget)
VALUES ('Human Resources', 'Building B, Floor 1', 250000.00);

INSERT INTO Departments (d.DepartmentName, Location, d.Budget)
VALUES ('Finance', 'Building A, Floor 2', 300000.00);

-- INSERT with explicit column list (recommended practice)
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
VALUES ('John', 'Smith', 'john.smith@company.com', 75000.00, 1);

-- INSERT without column list (not recommended - fragile)
-- INSERT INTO Employees VALUES (2, 'Jane', 'Doe', 'jane.doe@company.com', ...);

-- INSERT with NULL values and defaults
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, d.DepartmentID)
VALUES ('Alice', 'Johnson', 'alice.johnson@company.com', 2);  -- e.BaseSalary will be NULL, e.HireDate will use default

-- INSERT with explicit NULLs
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, ManagerID)
VALUES ('Bob', 'Wilson', 'bob.wilson@company.com', 65000.00, 1, NULL);

-- Verifying the inserts
SELECT * FROM Departments d ORDER BY DepartmentIDID;
SELECT * FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID ORDER BY e.EmployeeID;
```

### Multiple Row Inserts
```sql
-- Multiple VALUES clauses (SQL Server 2008+)
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, ManagerID)
VALUES 
    ('Sarah', 'Davis', 'sarah.davis@company.com', 80000.00, 1, 1),
    ('Michael', 'Brown', 'michael.brown@company.com', 72000.00, 2, NULL),
    ('Lisa', 'Miller', 'lisa.miller@company.com', 85000.00, 3, NULL),
    ('David', 'Garcia', 'david.garcia@company.com', 68000.00, 1, 1),
    ('Emily', 'Rodriguez', 'emily.rodriguez@company.com', 71000.00, 2, 3),
    ('James', 'Martinez', 'james.martinez@company.com', 90000.00, 3, 4);

-- INSERT multiple projects
INSERT INTO Projects (ProjectName, Description, StartDate, EndDate, d.Budget, IsActive)
VALUES 
    ('ERP System Upgrade', 'Upgrade enterprise resource planning system', '2024-01-15', '2024-06-30', 250000.00, 'In Progress'),
    ('Data Warehouse Migration', 'Migrate data warehouse to cloud platform', '2024-02-01', '2024-08-15', 180000.00, 'Planning'),
    ('Mobile App Development', 'Develop customer-facing mobile application', '2024-03-01', '2024-09-30', 120000.00, 'Planning'),
    ('Security Audit', 'Comprehensive security assessment and remediation', '2024-01-10', '2024-04-30', 75000.00, 'In Progress');

-- Verify multiple row inserts
SELECT COUNT(*) AS EmployeeCount FROM Employees e;
SELECT COUNT(*) AS ProjectCount FROM Projects p;
```

### INSERT with Calculations and Functions
```sql
-- INSERT with calculated values
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, e.HireDate)
VALUES 
    ('Thomas', 'Anderson', 'thomas.anderson@company.com', 
     (SELECT AVG(e.BaseSalary) * 1.1 FROM Employees e WHERE d.DepartmentID = 1), -- 10% above IT average
     1, 
     DATEADD(DAY, 30, GETDATE())); -- Start date 30 days from now

-- INSERT with string functions
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
VALUES 
    ('Jennifer', 'Williams-Jones', 
     LOWER('Jennifer') + '.' + LOWER(REPLACE('Williams-Jones', '-', '')) + '@company.com',
     67500.00, 2);

-- INSERT with CASE expressions
INSERT INTO Projects (ProjectName, Description, StartDate, EndDate, d.Budget, IsActive)
VALUES 
    ('Q4 Planning Initiative', 
     'Strategic planning for fourth quarter',
     GETDATE(),
     DATEADD(MONTH, 3, GETDATE()),
     CASE 
         WHEN MONTH(GETDATE()) >= 10 THEN 50000.00  -- Q4 budget
         ELSE 25000.00  -- Other quarters
     END,
     'Planning');
```

## INSERT from SELECT Statements

### Basic INSERT...SELECT
```sql
-- Create a table to hold employee backup data
CREATE TABLE EmployeeBackup (
    BackupID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT,
    e.FirstName NVARCHAR(50),
    e.LastName NVARCHAR(50),
    WorkEmail NVARCHAR(100),
    e.BaseSalary DECIMAL(10,2),
    d.DepartmentName NVARCHAR(100),
    BackupDate DATETIME2 DEFAULT SYSDATETIME()
);

-- INSERT...SELECT with JOIN
INSERT INTO EmployeeBackup (e.EmployeeID, e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentName)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.WorkEmail,
    e.BaseSalary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;

-- Verify the backup
SELECT * FROM EmployeeBackup ORDER BY e.EmployeeID;

-- INSERT...SELECT with aggregation
CREATE TABLE DepartmentSummary (
    SummaryID INT IDENTITY(1,1) PRIMARY KEY,
    d.DepartmentID INT,
    d.DepartmentName NVARCHAR(100),
    EmployeeCount INT,
    AverageSalary DECIMAL(10,2),
    TotalSalary DECIMAL(12,2),
    SummaryDate DATETIME2 DEFAULT SYSDATETIME()
);

INSERT INTO DepartmentSummary (d.DepartmentID, d.DepartmentName, EmployeeCount, AverageSalary, TotalSalary)
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    SUM(e.BaseSalary) AS TotalSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 OR e.IsActive IS NULL
GROUP BY d.DepartmentID, d.DepartmentName;

SELECT * FROM Departments dummary;
```

### Advanced INSERT...SELECT Scenarios
```sql
-- INSERT...SELECT with WHERE clause and complex logic
CREATE TABLE HighPerformers (
    PerformerID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT,
    e.FirstName NVARCHAR(50),
    e.LastName NVARCHAR(50),
    CurrentSalary DECIMAL(10,2),
    SalaryRank INT,
    d.DepartmentName NVARCHAR(100),
    PerformanceCategory NVARCHAR(50),
    IdentifiedDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Complex INSERT...SELECT with window functions
INSERT INTO HighPerformers (e.EmployeeID, e.FirstName, e.LastName, CurrentSalary, SalaryRank, d.DepartmentName, PerformanceCategory)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    RANK() OVER (PARTITION BY d.DepartmentName ORDER BY e.BaseSalary DESC) AS SalaryRank,
    d.DepartmentName,
    CASE 
        WHEN RANK() OVER (PARTITION BY d.DepartmentName ORDER BY e.BaseSalary DESC) = 1 THEN 'Top Performer'
        WHEN RANK() OVER (PARTITION BY d.DepartmentName ORDER BY e.BaseSalary DESC) <= 2 THEN 'High Performer'
        WHEN e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e WHERE d.DepartmentID = d.DepartmentID) THEN 'Above Average'
        ELSE 'Standard'
    END AS PerformanceCategory
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 
  AND e.BaseSalary IS NOT NULL
  AND (RANK() OVER (PARTITION BY d.DepartmentName ORDER BY e.BaseSalary DESC) <= 2 
       OR e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e WHERE d.DepartmentID = d.DepartmentID));

SELECT * FROM HighPerformers ORDER BY DepartmentIDName, SalaryRank;

-- INSERT...SELECT with UNION for combining data from multiple sources
CREATE TABLE AllContacts (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    ContactType NVARCHAR(20),
    e.FirstName NVARCHAR(50),
    e.LastName NVARCHAR(50),
    WorkEmail NVARCHAR(100),
    d.DepartmentName NVARCHAR(100),
    ContactDate DATETIME2 DEFAULT SYSDATETIME()
);

INSERT INTO AllContacts (ContactType, e.FirstName, e.LastName, WorkEmail, Department)
SELECT 
    'Employee' AS ContactType,
    e.FirstName,
    e.LastName,
    e.WorkEmail,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION ALL

SELECT 
    'Manager' AS ContactType,
    m.FirstName,
    m.LastName,
    m.WorkEmail,
    d.DepartmentName
FROM Employees e
INNER JOIN Employees m ON e.ManagerID = m.EmployeeID
INNER JOIN Departments d ON d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND m.IsActive = 1;

SELECT ContactType, COUNT(*) AS ContactCount 
FROM AllContacts 
GROUP BY ContactType;
```

## INSERT with OUTPUT Clause

### Basic OUTPUT Usage
```sql
-- INSERT with OUTPUT to capture inserted values
DECLARE @InsertedEmployees TABLE (
    e.EmployeeID INT,
    FullName NVARCHAR(101),
    WorkEmail NVARCHAR(100),
    e.HireDate DATE
);

-- INSERT with OUTPUT clause
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
OUTPUT 
    inserted.EmployeeID,
    inserted.FirstName + ' ' + inserted.LastName AS FullName,
    inserted.WorkEmail,
    inserted.HireDate
INTO @InsertedEmployees
VALUES 
    ('Amanda', 'Taylor', 'amanda.taylor@company.com', 73000.00, 2),
    ('Christopher', 'Moore', 'christopher.moore@company.com', 79000.00, 1);

-- View the captured output
SELECT * FROM @InsertedEmployees;

-- INSERT with OUTPUT to permanent table
CREATE TABLE InsertLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    Action NVARCHAR(20),
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    InsertedDate DATETIME2 DEFAULT SYSDATETIME()
);

INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
OUTPUT 
    'Employees' AS TableName,
    'INSERT' AS Action,
    inserted.EmployeeID,
    inserted.FirstName + ' ' + inserted.LastName AS EmployeeName,
    SYSDATETIME()
INTO InsertLog (TableName, Action, e.EmployeeID, EmployeeName, InsertedDate)
VALUES ('Nicole', 'Jackson', 'nicole.jackson@company.com', 71500.00, 3);

SELECT * FROM InsertLog;
```

### Advanced OUTPUT Scenarios
```sql
-- INSERT...SELECT with OUTPUT
CREATE TABLE ProjectAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT,
    e.EmployeeID INT,
    AssignedDate DATE DEFAULT GETDATE(),
    Role NVARCHAR(50),
    AllocationPercentage DECIMAL(5,2)
);

-- Track assignments as they're created
DECLARE @NewAssignments TABLE (
    AssignmentID INT,
    ProjectName NVARCHAR(100),
    EmployeeName NVARCHAR(101),
    Role NVARCHAR(50)
);

INSERT INTO ProjectAssignments (ProjectID, e.EmployeeID, Role, AllocationPercentage)
OUTPUT 
    inserted.AssignmentID,
    (SELECT ProjectName FROM Projects p WHERE ProjectID = inserted.ProjectID) AS ProjectName,
    (SELECT e.FirstName + ' ' + e.LastName FROM Employees e WHERE e.EmployeeID = inserted.EmployeeID) AS EmployeeName,
    inserted.Role
INTO @NewAssignments
SELECT 
    p.ProjectID,
    e.EmployeeID,
    CASE 
        WHEN e.BaseSalary >= 80000 THEN 'Senior Developer'
        WHEN e.BaseSalary >= 70000 THEN 'Developer'
        ELSE 'Junior Developer'
    END AS Role,
    CASE 
        WHEN e.BaseSalary >= 80000 THEN 75.00
        WHEN e.BaseSalary >= 70000 THEN 50.00
        ELSE 25.00
    END AS AllocationPercentage
FROM Projects p
CROSS JOIN Employees e
WHERE p.IsActive = 'Planning' 
  AND e.d.DepartmentID = 1  -- IT d.DepartmentName
  AND e.IsActive = 1;

-- View the assignment results
SELECT * FROM @NewAssignments ORDER BY ProjectName, Role DESC;
```

## Error Handling and Constraints

### Constraint Violations and Error Handling
```sql
-- Demonstrate constraint violations and error handling
BEGIN TRY
    -- This will succeed
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
    VALUES ('Valid', 'Employee', 'valid.employee@company.com', 65000.00, 1);
    
    PRINT 'First insert succeeded';
    
    -- This will fail due to duplicate email (UNIQUE constraint)
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
    VALUES ('Duplicate', 'WorkEmail', 'valid.employee@company.com', 70000.00, 2);
    
    PRINT 'This should not print - duplicate email insert';
    
END TRY
BEGIN CATCH
    PRINT 'Error caught: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH;

-- INSERT with foreign key constraint handling
BEGIN TRY
    -- This will fail due to invalid d.DepartmentID (foreign key constraint)
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
    VALUES ('Invalid', 'Department', 'invalid.dept@company.com', 65000.00, 999);
    
END TRY
BEGIN CATCH
    PRINT 'Foreign key violation: ' + ERROR_MESSAGE();
    
    -- Handle the error by using a valid d.DepartmentName
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
    VALUES ('Corrected', 'Employee', 'corrected.employee@company.com', 65000.00, 1);
    
    PRINT 'Corrected insert completed successfully';
END CATCH;
```

### Data Validation Before INSERT
```sql
-- Validate data before INSERT
CREATE PROCEDURE InsertEmployeeWithValidation
    @e.FirstName NVARCHAR(50),
    @e.LastName NVARCHAR(50),
    @WorkEmail NVARCHAR(100),
    @e.BaseSalary DECIMAL(10,2),
    @d.DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(500) = '';
    DECLARE @ValidationPassed BIT = 1;
    
    -- Validate inputs
    IF @e.FirstName IS NULL OR LEN(TRIM(@e.FirstName)) = 0
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'First name is required. ';
        SET @ValidationPassed = 0;
    END
    
    IF @e.LastName IS NULL OR LEN(TRIM(@e.LastName)) = 0
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'Last name is required. ';
        SET @ValidationPassed = 0;
    END
    
    IF @WorkEmail IS NULL OR @WorkEmail NOT LIKE '%_@__%.__%'
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'Valid email is required. ';
        SET @ValidationPassed = 0;
    END
    
    IF EXISTS (SELECT 1 FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE WorkEmail = @WorkEmail)
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'WorkEmail already exists. ';
        SET @ValidationPassed = 0;
    END
    
    IF @e.BaseSalary IS NOT NULL AND (@e.BaseSalary < 0 OR @e.BaseSalary > 1000000)
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'e.BaseSalary must be between 0 and 1,000,000. ';
        SET @ValidationPassed = 0;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID)
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'Invalid d.DepartmentName ID. ';
        SET @ValidationPassed = 0;
    END
    
    -- If validation passed, insert the record
    IF @ValidationPassed = 1
    BEGIN
        INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID)
        VALUES (@e.FirstName, @e.LastName, @WorkEmail, @e.BaseSalary, @d.DepartmentID);
        
        PRINT 'Employee inserted successfully. e.EmployeeID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR(10));
    END
    ELSE
    BEGIN
        PRINT 'Validation failed: ' + @ErrorMessage;
    END
END;

-- Test the validation procedure
EXEC InsertEmployeeWithValidation 'Test', 'User', 'test.user@company.com', 75000.00, 1;  -- Should succeed
EXEC InsertEmployeeWithValidation '', 'Invalid', 'bad-email', -1000, 999;  -- Should fail
```

## Performance Considerations

### Bulk INSERT Operations
```sql
-- Efficient bulk INSERT strategies
CREATE TABLE BulkInsertDemo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RandomNumber INT,
    RandomText NVARCHAR(50),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Method 1: Single INSERT with multiple VALUES (efficient for moderate amounts)
DECLARE @StartTime DATETIME2 = SYSDATETIME();

INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
VALUES 
    (RAND() * 1000, 'Text1'),
    (RAND() * 1000, 'Text2'),
    (RAND() * 1000, 'Text3'),
    -- ... would continue for many rows
    (RAND() * 1000, 'Text10');

DECLARE @Method1Time INT = DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME());
PRINT 'Method 1 (Multiple VALUES) took: ' + CAST(@Method1Time AS VARCHAR(10)) + ' ms';

-- Method 2: INSERT...SELECT from CTE (efficient for large datasets)
SET @StartTime = SYSDATETIME();

WITH NumberSequence AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM NumberSequence
    WHERE n < 1000
)
INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
SELECT 
    n * RAND(),
    'Generated Text ' + CAST(n AS VARCHAR(10))
FROM NumberSequence
OPTION (MAXRECURSION 1000);

DECLARE @Method2Time INT = DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME());
PRINT 'Method 2 (INSERT...SELECT with CTE) took: ' + CAST(@Method2Time AS VARCHAR(10)) + ' ms';

-- Check row counts
SELECT COUNT(*) AS TotalRows FROM BulkInsertDemo;

-- Performance tips for bulk operations
-- 1. Use minimal logging when possible
-- 2. Consider disabling indexes during bulk operations
-- 3. Use appropriate transaction management
-- 4. Consider using BULK INSERT for file-based imports
```

### INSERT Performance Optimization
```sql
-- Demonstrate performance optimization techniques

-- 1. Batch size optimization
CREATE PROCEDURE OptimizedBulkInsert
    @BatchSize INT = 1000
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Counter INT = 1;
    DECLARE @TotalRows INT = 10000;
    
    WHILE @Counter <= @TotalRows
    BEGIN
        -- Insert in batches
        WITH BatchData AS (
            SELECT 
                @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS RowNum
            FROM sys.objects s1
            CROSS JOIN sys.objects s2
        )
        INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
        SELECT 
            RowNum * 17 % 1000,  -- Pseudo-random number
            'Batch Text ' + CAST(RowNum AS VARCHAR(10))
        FROM BatchData
        WHERE RowNum BETWEEN @Counter AND (@Counter + @BatchSize - 1)
          AND RowNum <= @TotalRows;
        
        SET @Counter = @Counter + @BatchSize;
        
        -- Optional: Add delay to prevent blocking
        -- WAITFOR DELAY '00:00:00.010';  -- 10ms delay
    END
END;

-- 2. Transaction management for bulk operations
CREATE PROCEDURE BulkInsertWithTransactionControl
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TransactionStarted BIT = 0;
    
    BEGIN TRY
        -- Start transaction only if not already in one
        IF @@TRANCOUNT = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @TransactionStarted = 1;
        END
        
        -- Bulk insert operation
        INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
        SELECT 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 1000,
            'Transaction Text ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10))
        FROM sys.objects
        WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= 5000;
        
        -- Commit only if we started the transaction
        IF @TransactionStarted = 1
            COMMIT TRANSACTION;
            
        PRINT 'Bulk insert completed successfully';
        
    END TRY
    BEGIN CATCH
        -- Rollback only if we started the transaction
        IF @TransactionStarted = 1 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        PRINT 'Error during bulk insert: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
```

## Advanced INSERT Techniques

### INSERT with Common Table Expressions (CTEs)
```sql
-- Complex INSERT using CTEs for data transformation
CREATE TABLE EmployeeHierarchy (
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    ManagerID INT,
    ManagerName NVARCHAR(101),
    HierarchyLevel INT,
    HierarchyPath NVARCHAR(1000),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Build employee hierarchy using recursive CTE
WITH EmployeeHierarchyCTE AS (
    -- Anchor: Top-level managers (no manager)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.ManagerID,
        CAST(NULL AS NVARCHAR(101)) AS ManagerName,
        1 AS HierarchyLevel,
        CAST(e.FirstName + ' ' + e.LastName AS NVARCHAR(1000)) AS HierarchyPath
    FROM Employees e
    WHERE e.ManagerID IS NULL AND e.IsActive = 1
    
    UNION ALL
    
    -- Recursive: Employees with managers
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.ManagerID,
        h.EmployeeName AS ManagerName,
        h.HierarchyLevel + 1 AS HierarchyLevel,
        h.HierarchyPath + ' -> ' + e.FirstName + ' ' + e.LastName AS HierarchyPath
    FROM Employees e
    INNER JOIN EmployeeHierarchyCTE h ON e.ManagerID = h.EmployeeID
    WHERE e.IsActive = 1
)
INSERT INTO EmployeeHierarchy (e.EmployeeID, EmployeeName, ManagerID, ManagerName, HierarchyLevel, HierarchyPath)
SELECT 
    e.EmployeeID,
    EmployeeName,
    ManagerID,
    ManagerName,
    HierarchyLevel,
    HierarchyPath
FROM EmployeeHierarchyCTE;

-- View the hierarchy
SELECT 
    REPLICATE('  ', HierarchyLevel - 1) + EmployeeName AS HierarchyDisplay,
    HierarchyLevel,
    ManagerName,
    HierarchyPath
FROM EmployeeHierarchy
ORDER BY HierarchyPath;
```

### INSERT with Window Functions
```sql
-- Create performance rankings table
CREATE TABLE EmployeePerformanceRanking (
    RankingID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    d.DepartmentName NVARCHAR(100),
    e.BaseSalary DECIMAL(10,2),
    DepartmentRank INT,
    OverallRank INT,
    SalaryPercentile DECIMAL(5,2),
    SalaryQuartile INT,
    AboveAverage BIT,
    RankingDate DATETIME2 DEFAULT SYSDATETIME()
);

INSERT INTO EmployeePerformanceRanking (
    e.EmployeeID, EmployeeName, DepartmentName, e.BaseSalary, 
    DepartmentRank, OverallRank, SalaryPercentile, SalaryQuartile, AboveAverage
)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    e.BaseSalary,
    -- Department-specific ranking
    ROW_NUMBER() OVER (PARTITION BY d.DepartmentName ORDER BY e.BaseSalary DESC) AS DepartmentRank,
    -- Overall ranking
    ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS OverallRank,
    -- e.BaseSalary percentile
    CAST(PERCENT_RANK() OVER (ORDER BY e.BaseSalary) * 100 AS DECIMAL(5,2)) AS SalaryPercentile,
    -- e.BaseSalary quartile
    NTILE(4) OVER (ORDER BY e.BaseSalary) AS SalaryQuartile,
    -- Above average flag
    CASE 
        WHEN e.BaseSalary > AVG(e.BaseSalary) OVER() THEN 1
        ELSE 0
    END AS AboveAverage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND e.BaseSalary IS NOT NULL;

-- View performance rankings
SELECT 
    EmployeeName,
    DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    DepartmentRank,
    OverallRank,
    SalaryPercentile,
    CASE SalaryQuartile
        WHEN 1 THEN 'Bottom 25%'
        WHEN 2 THEN 'Lower Middle 25%'
        WHEN 3 THEN 'Upper Middle 25%'
        WHEN 4 THEN 'Top 25%'
    END AS SalaryQuartileDescription,
    CASE WHEN AboveAverage = 1 THEN 'Yes' ELSE 'No' END AS AboveCompanyAverage
FROM EmployeePerformanceRanking
ORDER BY OverallRank;
```

## Best Practices and Common Pitfalls

### INSERT Best Practices
```sql
-- Best practices demonstration

-- 1. Always specify column list (maintainable and safe)
-- GOOD
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, DepartmentID)
VALUES ('Best', 'Practice', 'best.practice@company.com', 75000.00, 1);

-- AVOID (fragile if table structure changes)
-- INSERT INTO Employees VALUES (999, 'Bad', 'Practice', 'bad@company.com', ...);

-- 2. Use appropriate transaction boundaries
BEGIN TRANSACTION;
BEGIN TRY
    -- Related inserts that should succeed or fail together
    DECLARE @NewDeptID INT;
    
    INSERT INTO Departments (DepartmentName, Location, Budget)
    VALUES ('Research & Development', 'Building C, Floor 2', 400000.00);
    
    SET @NewDeptID = SCOPE_IDENTITY();
    
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, DepartmentID)
    VALUES ('Research', 'Director', 'research.director@company.com', 95000.00, @NewDeptID);
    
    COMMIT TRANSACTION;
    PRINT 'Department and director created successfully';
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error creating department: ' + ERROR_MESSAGE();
END CATCH;

-- 3. Use IDENTITY_INSERT when necessary (rare scenarios)
-- Enable identity insert for specific scenarios
SET IDENTITY_INSERT Employees ON;

INSERT INTO Employees (e.EmployeeID, e.FirstName, e.LastName, WorkEmail, e.BaseSalary, DepartmentID)
VALUES (1000, 'Specific', 'ID', 'specific.id@company.com', 80000.00, 1);

SET IDENTITY_INSERT Employees OFF;

-- 4. Handle default values appropriately
-- Let defaults work when appropriate
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, DepartmentID)
VALUES ('Default', 'Values', 'default.values@company.com', 1);
-- e.HireDate, IsActive, CreatedDate, ModifiedDate will use defaults

-- 5. Use OUTPUT for auditing and logging
INSERT INTO Projects (ProjectName, Description, StartDate, Budget)
OUTPUT 
    'Project Created: ' + inserted.ProjectName AS LogMessage,
    inserted.ProjectID,
    inserted.CreatedDate
VALUES ('Best Practices Project', 'Implementing coding standards', GETDATE(), 50000.00);
```

### Common INSERT Pitfalls
```sql
-- Common mistakes and how to avoid them

-- PITFALL 1: Not handling NULL values properly
-- Problem: Assuming NOT NULL columns will auto-populate
-- Solution: Always provide values for required columns or set appropriate defaults

-- PITFALL 2: String truncation issues
BEGIN TRY
    -- This may fail if e.FirstName column is shorter than the value
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, DepartmentID)
    VALUES (REPLICATE('VeryLongFirstName', 10), 'User', 'long.name@company.com', 1);
END TRY
BEGIN CATCH
    PRINT 'String truncation error: ' + ERROR_MESSAGE();
    
    -- Solution: Validate string lengths before insert
    DECLARE @e.FirstName NVARCHAR(50) = LEFT(REPLICATE('VeryLongFirstName', 10), 50);
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, DepartmentID)
    VALUES (@e.FirstName, 'User', 'truncated.name@company.com', 1);
END CATCH;

-- PITFALL 3: Performance issues with single-row inserts in loops
-- AVOID: Multiple single inserts
/*
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
    VALUES (@i, 'Text ' + CAST(@i AS VARCHAR(10)));
    SET @i = @i + 1;
END
*/

-- BETTER: Batch inserts or INSERT...SELECT
WITH Numbers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects s1 CROSS JOIN sys.objects s2
)
INSERT INTO BulkInsertDemo (RandomNumber, RandomText)
SELECT 
    n,
    'Text ' + CAST(n AS VARCHAR(10))
FROM Numbers
WHERE n <= 1000;

-- PITFALL 4: Not considering concurrent access
-- Use appropriate isolation levels and locking hints when necessary
-- Example: Preventing duplicate inserts in multi-user environment
BEGIN TRANSACTION;

-- Check if record already exists with appropriate locking
IF NOT EXISTS (
    SELECT 1 FROM Employees e WITH (UPDLOCK, HOLDLOCK) 
    WHERE WorkEmail = 'unique.email@company.com'
)
BEGIN
    INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, DepartmentID)
    VALUES ('Unique', 'User', 'unique.email@company.com', 70000.00, 1);
END
ELSE
BEGIN
    PRINT 'Employee with this email already exists';
END

COMMIT TRANSACTION;
```

## Summary

### Key Takeaways for INSERT Operations

1. **Use Explicit Column Lists**
   - Always specify column names for maintainability
   - Protects against table structure changes
   - Makes code self-documenting

2. **Handle Constraints and Errors Properly**
   - Use TRY...CATCH for error handling
   - Validate data before INSERT when possible
   - Understand constraint violation scenarios

3. **Leverage OUTPUT Clause**
   - Capture inserted values for logging or processing
   - Useful for getting IDENTITY values
   - Essential for audit trails

4. **Optimize for Performance**
   - Use batch operations for bulk data
   - Consider transaction management
   - Choose appropriate isolation levels

5. **Use Advanced Techniques When Appropriate**
   - INSERT...SELECT for data transformation
   - CTEs for complex data preparation
   - Window functions for calculations

6. **Follow Best Practices**
   - Specify column lists explicitly
   - Use appropriate transaction boundaries
   - Handle defaults and NULLs properly
   - Consider concurrent access scenarios

Understanding these INSERT techniques and best practices is essential for effective data management and building robust, performant database applications.
