# Lab: Working with SQL Server 2016 Tools

## Lab Overview
This comprehensive lab provides hands-on experience with SQL Server 2016 tools, integrating concepts from all three lessons. You'll work with SQL Server architecture, explore edition features, and master SSMS functionality.

**Prerequisites:**
- SQL Server 2016 (any edition)
- SQL Server Management Studio (SSMS)
- Basic understanding of T-SQL

**Estimated Time:** 3-4 hours

## Lab Environment Setup

### Environment Diagram
```
┌─────────────────────────────────────────────────────────┐
│                LAB ENVIRONMENT                          │
│                                                         │
│  ┌─────────────────┐         ┌─────────────────────────┐ │
│  │  SSMS CLIENT    │   ────→ │   SQL SERVER 2016       │ │
│  │  (Management)   │         │   (Database Engine)     │ │
│  └─────────────────┘         └─────────────────────────┘ │
│                                        │                │
│  ┌─────────────────────────────────────┼──────────────┐  │
│  │            LAB DATABASES            │              │  │
│  │  ┌─────────────┬─────────────┬──────▼────────────┐ │  │
│  │  │ CompanyDB   │ PerformanceDB │ ArchitectureDB │ │  │
│  │  │ (Main Lab)  │ (Perf Test)  │ (Architecture)  │ │  │
│  │  └─────────────┴─────────────┴─────────────────┘ │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Part 1: SQL Server 2016 Architecture Exploration

### Lab 1.1: Instance and Edition Verification

**Objective:** Verify your SQL Server 2016 installation and understand its architecture.

```sql
-- Lab 1.1.1: Basic Instance Information
SELECT 
    @@SERVERNAME as ServerName,
    @@VERSION as FullVersion,
    SERVERPROPERTY('ProductVersion') as ProductVersion,
    SERVERPROPERTY('ProductLevel') as ProductLevel,
    SERVERPROPERTY('Edition') as Edition,
    SERVERPROPERTY('EngineEdition') as EngineEdition,
    SERVERPROPERTY('BuildClrVersion') as CLRVersion;
```

**Expected Output Analysis:**
```
ServerName: YOUR-COMPUTER\SQLEXPRESS (or similar)
Edition: Express Edition (64-bit) / Developer Edition / Standard / Enterprise
ProductVersion: 13.x.xxxx.x (SQL Server 2016)
```

```sql
-- Lab 1.1.2: Memory and CPU Architecture
SELECT 
    cpu_count as LogicalCPUs,
    hyperthread_ratio as HyperthreadRatio,
    physical_memory_kb / 1024 / 1024 as PhysicalMemoryGB,
    virtual_memory_kb / 1024 / 1024 as VirtualMemoryGB,
    committed_kb / 1024 / 1024 as CommittedMemoryGB,
    committed_target_kb / 1024 / 1024 as CommittedTargetGB
FROM sys.dm_os_sys_info;
```

### Lab 1.2: Database File Architecture Analysis

```sql
-- Lab 1.2.1: Create a test database to understand file structure
CREATE DATABASE ArchitectureDemo
ON 
(
    NAME = 'ArchitectureDemo_Data',
    FILENAME = 'C:\LabFiles\ArchitectureDemo.mdf',
    SIZE = 100MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 25MB
)
LOG ON
(
    NAME = 'ArchitectureDemo_Log',
    FILENAME = 'C:\LabFiles\ArchitectureDemo.ldf',
    SIZE = 25MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
);
GO

-- Lab 1.2.2: Analyze database file information
USE ArchitectureDemo;
GO

SELECT 
    DB_NAME() as DatabaseName,
    file_id,
    name as LogicalName,
    physical_name as PhysicalName,
    type_desc as FileType,
    size * 8 / 1024 as SizeMB,
    max_size * 8 / 1024 as MaxSizeMB,
    CASE 
        WHEN is_percent_growth = 1 
        THEN CAST(growth as varchar(10)) + '%'
        ELSE CAST(growth * 8 / 1024 as varchar(10)) + 'MB'
    END as GrowthSetting
FROM sys.database_files;
```

### Lab 1.3: Buffer Pool and Memory Analysis

```sql
-- Lab 1.3.1: Buffer pool distribution by database
SELECT 
    CASE 
        WHEN database_id = 32767 THEN 'ResourceDB'
        ELSE DB_NAME(database_id)
    END as DatabaseName,
    COUNT(*) as PageCount,
    COUNT(*) * 8 / 1024 as BufferSizeMB,
    AVG(read_microsec) as AvgReadMicrosec
FROM sys.dm_os_buffer_descriptors bd
LEFT JOIN sys.dm_io_virtual_file_stats(NULL, NULL) vfs 
    ON bd.database_id = vfs.database_id 
    AND bd.file_id = vfs.file_id
GROUP BY database_id
ORDER BY BufferSizeMB DESC;
```

```sql
-- Lab 1.3.2: Memory usage by component
SELECT 
    type as MemoryType,
    SUM(pages_kb) / 1024 as MemoryUsedMB,
    COUNT(*) as AllocationCount
FROM sys.dm_os_memory_clerks
GROUP BY type
HAVING SUM(pages_kb) / 1024 > 1
ORDER BY MemoryUsedMB DESC;
```

## Part 2: SQL Server 2016 Edition Features Testing

### Lab 2.1: Edition Feature Verification

```sql
-- Lab 2.1.1: Check available features
SELECT feature_name, feature_id
FROM sys.dm_db_persisted_sku_features
ORDER BY feature_name;

-- Lab 2.1.2: Test compression features (Standard+ editions)
USE ArchitectureDemo;
GO

-- Create table with compression (Standard/Enterprise feature)
CREATE TABLE CompressionTest (
    ID int IDENTITY(1,1),
    LargeText varchar(1000),
    DateCreated datetime2 DEFAULT GETDATE()
) WITH (DATA_COMPRESSION = PAGE);

-- Insert test data
INSERT INTO CompressionTest (LargeText)
SELECT REPLICATE('Sample data for compression testing. ', 20)
FROM sys.objects
CROSS JOIN sys.objects;

-- Check compression effectiveness
SELECT 
    OBJECT_NAME(object_id) as TableName,
    partition_number,
    data_compression_desc,
    row_count,
    reserved_page_count * 8 as ReservedKB,
    used_page_count * 8 as UsedKB
FROM sys.dm_db_partition_stats ps
INNER JOIN sys.partitions p ON ps.partition_id = p.partition_id
WHERE OBJECT_NAME(ps.object_id) = 'CompressionTest';
```

### Lab 2.2: SQL Server 2016 New Features

```sql
-- Lab 2.2.1: JSON Support (New in SQL Server 2016)
CREATE TABLE JsonDemo (
    ID int IDENTITY(1,1),
    CustomerData nvarchar(max) CHECK (ISJSON(CustomerData) = 1)
);

INSERT INTO JsonDemo (CustomerData) VALUES 
('{"name": "John Smith", "email": "john@email.com", "orders": [{"id": 1, "amount": 250.00}, {"id": 2, "amount": 175.50}]}'),
('{"name": "Jane Doe", "email": "jane@email.com", "orders": [{"id": 3, "amount": 420.00}]}'),
('{"name": "Bob Johnson", "email": "bob@email.com", "orders": [{"id": 4, "amount": 325.75}, {"id": 5, "amount": 180.25}]}');

-- Query JSON data
SELECT 
    ID,
    JSON_VALUE(CustomerData, '$.name') as CompanyName,
    JSON_VALUE(CustomerData, '$.email') as WorkEmail,
    JSON_QUERY(CustomerData, '$.orders') as OrdersArray,
    JSON_VALUE(CustomerData, '$.orders[0].amount') as FirstOrderAmount
FROM JsonDemo;
```

```sql
-- Lab 2.2.2: Temporal Tables (System-Versioned Tables) - Enterprise/Developer
CREATE TABLE EmployeeInfo (
    EmployeeID int NOT NULL PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Position nvarchar(100) NOT NULL,
    d.DepartmentName nvarchar(50) NOT NULL,
    BaseSalary decimal(10,2) NOT NULL,
    
    -- System versioning columns
    ValidFrom datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeInfo_History));

-- Insert and update data to see temporal features
INSERT INTO EmployeeInfo (EmployeeID, Name, Position, d.DepartmentName, BaseSalary)
VALUES 
(1, 'John Smith', 'Developer', 'IT', 75000),
(2, 'Jane Doe', 'Manager', 'Sales', 85000);

-- Wait a moment, then update
WAITFOR DELAY '00:00:02';

UPDATE EmployeeInfo 
SET BaseSalary = 80000, Position = 'Senior Developer'
WHERE EmployeeID = 1;

-- Query temporal data
SELECT 
    EmployeeID, 
    Name, 
    Position, 
    BaseSalary, 
    ValidFrom, 
    ValidTo
FROM EmployeeInfo 
FOR SYSTEM_TIME ALL
WHERE EmployeeID = 1
ORDER BY ValidFrom;
```

### Lab 2.3: Always Encrypted (Enterprise/Developer Feature)

```sql
-- Lab 2.3.1: Always Encrypted Setup (Demo - requires certificate setup)
-- Note: This requires additional setup in SSMS for full functionality

-- Check if Always Encrypted is available
SELECT 
    name,
    type_desc,
    encryption_type_desc
FROM sys.column_encryption_keys;

-- Create sample table structure for Always Encrypted
CREATE TABLE SecureCustomers (
    CustomerID int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    WorkEmail nvarchar(255) NOT NULL,
    -- In real scenario, these would be encrypted
    CreditCardNumber nvarchar(19), -- Would be ENCRYPTED WITH clause
    SSN nvarchar(11) -- Would be ENCRYPTED WITH clause
);
```

## Part 3: SSMS 2016 Advanced Features Lab

### Lab 3.1: Query Store (New in SQL Server 2016)

```sql
-- Lab 3.1.1: Enable Query Store
USE ArchitectureDemo;
GO

ALTER DATABASE ArchitectureDemo 
SET QUERY_STORE = ON 
(
    OPERATION_MODE = READ_WRITE,
    CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
    DATA_FLUSH_INTERVAL_SECONDS = 900,
    MAX_STORAGE_SIZE_MB = 100,
    INTERVAL_LENGTH_MINUTES = 60
);

-- Lab 3.1.2: Create test workload for Query Store
CREATE TABLE SalesData (
    SaleID int IDENTITY(1,1) PRIMARY KEY,
    ProductID int,
    CustomerID int,
    SaleDate datetime2,
    Amount decimal(10,2),
    Quantity int
);

-- Insert sample data
INSERT INTO SalesData (ProductID, CustomerID, SaleDate, Amount, Quantity)
SELECT 
    ABS(CHECKSUM(NEWID())) % 100 + 1,
    ABS(CHECKSUM(NEWID())) % 1000 + 1,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    RAND(CHECKSUM(NEWID())) * 1000 + 10,
    ABS(CHECKSUM(NEWID())) % 10 + 1
FROM sys.objects a
CROSS JOIN sys.objects b;

-- Create different query patterns
-- Query Pattern 1: Simple aggregation
SELECT 
    ProductID,
    COUNT(*) as SalesCount,
    SUM(Amount) as TotalAmount,
    AVG(Amount) as AvgAmount
FROM SalesData
WHERE SaleDate >= DATEADD(MONTH, -3, GETDATE())
GROUP BY ProductID
ORDER BY TotalAmount DESC;

-- Query Pattern 2: Complex join with filtering
SELECT 
    s.CustomerID,
    COUNT(DISTINCT s.ProductID) as UniqueProducts,
    SUM(s.Amount) as TotalSpent,
    MAX(s.SaleDate) as LastPurchase
FROM SalesData s
WHERE s.SaleDate >= DATEADD(MONTH, -6, GETDATE())
    AND s.Amount > 100
GROUP BY s.CustomerID
HAVING COUNT(*) > 5
ORDER BY TotalSpent DESC;

-- Lab 3.1.3: Query the Query Store
SELECT 
    qt.query_text_id,
    qt.query_sql_text,
    qp.plan_id,
    qs.count_executions,
    qs.avg_duration,
    qs.avg_cpu_time,
    qs.avg_logical_io_reads
FROM sys.query_store_query_text qt
INNER JOIN sys.query_store_query q ON qt.query_text_id = q.query_text_id
INNER JOIN sys.query_store_plan qp ON q.query_id = qp.query_id
INNER JOIN sys.query_store_runtime_stats qs ON qp.plan_id = qs.plan_id
ORDER BY qs.avg_duration DESC;
```

### Lab 3.2: Live Query Statistics and Execution Plans

```sql
-- Lab 3.2.1: Enable Live Query Statistics in SSMS
-- Query → Include Live Query Statistics (Ctrl+Shift+Alt+L)

-- Run this complex query and observe live statistics
WITH CustomerAnalysis AS (
    SELECT 
        CustomerID,
        COUNT(*) as OrderCount,
        SUM(Amount) as TotalAmount,
        AVG(Amount) as AvgAmount,
        MIN(SaleDate) as FirstOrder,
        MAX(SaleDate) as LastOrder
    FROM SalesData
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY CustomerID
),
ProductAnalysis AS (
    SELECT 
        ProductID,
        COUNT(*) as SalesCount,
        SUM(Amount) as Revenue,
        COUNT(DISTINCT CustomerID) as UniqueCustomers
    FROM SalesData
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY ProductID
)
SELECT 
    ca.CustomerID,
    ca.OrderCount,
    ca.TotalAmount,
    pa.ProductID,
    pa.Revenue as ProductRevenue,
    DATEDIFF(DAY, ca.FirstOrder, ca.LastOrder) as CustomerLifetimeDays
FROM CustomerAnalysis ca
CROSS JOIN ProductAnalysis pa
WHERE ca.TotalAmount > 1000 
    AND pa.Revenue > 5000
ORDER BY ca.TotalAmount DESC, pa.Revenue DESC;
```

### Lab 3.3: Extended Events (XEvents) - SQL Server 2016 Features

```sql
-- Lab 3.3.1: Create Extended Events session
CREATE EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER 
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_name,sqlserver.username)
    WHERE ([duration]>(1000000) AND [database_name]=N'ArchitectureDemo')
),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_name,sqlserver.username)
    WHERE ([duration]>(1000000) AND [database_name]=N'ArchitectureDemo')
)
ADD TARGET package0.event_file(SET filename=N'C:\LabFiles\SQL2016_Performance_Monitor')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF);

-- Start the session
ALTER EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER STATE = START;

-- Lab 3.3.2: Generate some events
DECLARE @Counter int = 1;
WHILE @Counter <= 100
BEGIN
    SELECT 
        COUNT(*) as RecordCount,
        SUM(Amount) as TotalAmount,
        AVG(Amount) as AvgAmount
    FROM SalesData s1
    CROSS JOIN SalesData s2
    WHERE s1.SaleDate >= DATEADD(DAY, -30, GETDATE());
    
    SET @Counter = @Counter + 1;
    WAITFOR DELAY '00:00:01';
END;

-- Stop the session
ALTER EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER STATE = STOP;

-- Lab 3.3.3: Query Extended Events data
SELECT 
    event_data.value('(event/@name)[1]', 'varchar(50)') as event_name,
    event_data.value('(event/@timestamp)[1]', 'datetime2') as timestamp,
    event_data.value('(event/data[@name="duration"]/value)[1]', 'bigint') as duration_microseconds,
    event_data.value('(event/action[@name="database_name"]/value)[1]', 'varchar(128)') as database_name,
    event_data.value('(event/data[@name="statement"]/value)[1]', 'varchar(max)') as sql_text
FROM (
    SELECT CAST(event_data as xml) as event_data
    FROM sys.fn_xe_file_target_read_file('C:\LabFiles\SQL2016_Performance_Monitor*.xel', NULL, NULL, NULL)
) as events
ORDER BY timestamp DESC;
```

## Part 4: SSMS Integration and Productivity Lab

### Lab 4.1: Database Project and Source Control Integration

```sql
-- Lab 4.1.1: Create a comprehensive database schema
USE ArchitectureDemo;
GO

-- Create schema for organization
CREATE SCHEMA Sales;
CREATE SCHEMA HR;
CREATE SCHEMA Inventory;
GO

-- Create tables with proper relationships
CREATE TABLE HR.Employees (
    EmployeeID int IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    WorkEmail nvarchar(255) UNIQUE NOT NULL,
    HireDate date NOT NULL,
    DepartmentID int,
    ManagerID int,
    BaseSalary decimal(10,2),
    
    CONSTRAINT FK_Employee_Manager FOREIGN KEY (ManagerID) 
        REFERENCES HR.Employees(EmployeeID)
);

CREATE TABLE Inventory.Products (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL,
    CategoryID int,
    BaseSalary decimal(10,2) NOT NULL,
    UnitsInStock int DEFAULT 0,
    ReorderLevel int DEFAULT 10,
    Discontinued bit DEFAULT 0,
    
    INDEX IX_Products_Category (CategoryID),
    INDEX IX_Products_Price (BaseSalary)
);

CREATE TABLE Sales.Orders (
    OrderID int IDENTITY(1,1) PRIMARY KEY,
    CustomerID int NOT NULL,
    EmployeeID int NOT NULL,
    OrderDate datetime2 DEFAULT GETDATE(),
    RequiredDate datetime2,
    ShippedDate datetime2,
    TotalAmount decimal(12,2),
    
    CONSTRAINT FK_Orders_Employee FOREIGN KEY (EmployeeID) 
        REFERENCES HR.Employees(EmployeeID)
);

CREATE TABLE Sales.OrderDetails (
    OrderDetailID int IDENTITY(1,1) PRIMARY KEY,
    OrderID int NOT NULL,
    ProductID int NOT NULL,
    BaseSalary decimal(10,2) NOT NULL,
    Quantity int NOT NULL,
    Discount float DEFAULT 0,
    
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderID) 
        REFERENCES Sales.Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Product FOREIGN KEY (ProductID) 
        REFERENCES Inventory.Products(ProductID)
);
```

### Lab 4.2: Advanced SSMS Features Testing

```sql
-- Lab 4.2.1: Database Snapshots (Enterprise/Developer)
-- Create a database snapshot for point-in-time recovery testing
CREATE DATABASE ArchitectureDemo_Snapshot ON
(
    NAME = 'ArchitectureDemo_Data',
    FILENAME = 'C:\LabFiles\ArchitectureDemo_Snapshot.ss'
)
AS SNAPSHOT OF ArchitectureDemo;

-- Test data modification and snapshot comparison
USE ArchitectureDemo;
INSERT INTO HR.Employees (FirstName, LastName, WorkEmail, HireDate, BaseSalary)
VALUES 
('John', 'Doe', 'john.doe@company.com', '2024-01-15', 65000),
('Jane', 'Smith', 'jane.smith@company.com', '2024-02-01', 70000);

-- Compare current data with snapshot
SELECT 'Current Database' as Source, COUNT(*) AS EmployeeCount
FROM HR.Employees
UNION ALL
SELECT 'Snapshot', COUNT(*) 
FROM ArchitectureDemo_Snapshot.HR.Employees;
```

### Lab 4.3: Performance Monitoring and Alerting

```sql
-- Lab 4.3.1: Create performance monitoring queries
-- Long-running queries detection
SELECT 
    session_id,
    request_id,
    start_time,
    status,
    command,
    database_id,
    DB_NAME(database_id) as DatabaseName,
    cpu_time,
    total_elapsed_time,
    logical_reads,
    writes,
    blocking_session_id,
    wait_type,
    wait_time,
    last_wait_type,
    wait_resource
FROM sys.dm_exec_requests
WHERE total_elapsed_time > 5000 -- More than 5 seconds
ORDER BY total_elapsed_time DESC;

-- Lab 4.3.2: Database file growth monitoring
SELECT 
    database_id,
    DB_NAME(database_id) as DatabaseName,
    file_id,
    type_desc,
    name,
    physical_name,
    size * 8.0 / 1024 as CurrentSizeMB,
    max_size * 8.0 / 1024 as MaxSizeMB,
    CASE 
        WHEN max_size = -1 THEN 'Unlimited'
        ELSE CAST((max_size - size) * 8.0 / 1024 as varchar(20))
    END as RemainingSpaceMB,
    CASE is_percent_growth
        WHEN 1 THEN CAST(growth as varchar(20)) + '%'
        ELSE CAST(growth * 8.0 / 1024 as varchar(20)) + 'MB'
    END as GrowthSetting
FROM sys.master_files
WHERE database_id > 4 -- Exclude system databases
ORDER BY database_id, file_id;
```

## Part 5: Comprehensive Assessment Lab

### Lab 5.1: Real-World Scenario Implementation

**Scenario:** You're tasked with setting up a comprehensive monitoring and maintenance solution for a SQL Server 2016 environment.

```sql
-- Lab 5.1.1: Create maintenance database
CREATE DATABASE MaintenanceDB
ON 
(
    NAME = 'MaintenanceDB_Data',
    FILENAME = 'C:\LabFiles\MaintenanceDB.mdf',
    SIZE = 250MB,
    FILEGROWTH = 50MB
)
LOG ON
(
    NAME = 'MaintenanceDB_Log',
    FILENAME = 'C:\LabFiles\MaintenanceDB.ldf',
    SIZE = 50MB,
    FILEGROWTH = 10MB
);

USE MaintenanceDB;
GO

-- Create monitoring tables
CREATE TABLE PerformanceMetrics (
    MetricID int IDENTITY(1,1) PRIMARY KEY,
    ServerName nvarchar(128) DEFAULT @@SERVERNAME,
    DatabaseName nvarchar(128),
    MetricType nvarchar(50),
    MetricValue decimal(18,2),
    CollectionTime datetime2 DEFAULT GETDATE()
);

CREATE TABLE QueryPerformance (
    QueryID int IDENTITY(1,1) PRIMARY KEY,
    QueryHash binary(8),
    QueryText nvarchar(max),
    ExecutionCount int,
    TotalDuration bigint,
    AvgDuration bigint,
    LastExecutionTime datetime2,
    CollectionTime datetime2 DEFAULT GETDATE()
);

-- Lab 5.1.2: Create monitoring stored procedures
CREATE PROCEDURE CollectPerformanceMetrics
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Collect buffer cache hit ratio
    INSERT INTO PerformanceMetrics (DatabaseName, MetricType, MetricValue)
    SELECT 
        'System',
        'Buffer Cache Hit Ratio',
        (cntr_value * 1.0 / base_cntr_value) * 100
    FROM sys.dm_os_performance_counters 
    WHERE counter_name = 'Buffer cache hit ratio'
        AND object_name = 'SQLServer:Buffer Manager';
    
    -- Collect database sizes
    INSERT INTO PerformanceMetrics (DatabaseName, MetricType, MetricValue)
    SELECT 
        DB_NAME(database_id),
        'Database Size MB',
        SUM(size * 8.0 / 1024)
    FROM sys.master_files
    WHERE type = 0 -- Data files only
    GROUP BY database_id;
    
    -- Collect transaction log usage
    INSERT INTO PerformanceMetrics (DatabaseName, MetricType, MetricValue)
    SELECT 
        name,
        'Log Used Percent',
        used_log_space_in_percent
    FROM sys.databases
    WHERE database_id > 4;
END;
GO

-- Lab 5.1.3: Test the monitoring solution
EXEC CollectPerformanceMetrics;

-- View collected metrics
SELECT 
    DatabaseName,
    MetricType,
    MetricValue,
    CollectionTime
FROM PerformanceMetrics
ORDER BY CollectionTime DESC, DatabaseName, MetricType;
```

### Lab 5.2: Advanced Query Optimization Lab

```sql
-- Lab 5.2.1: Create performance test scenario
USE ArchitectureDemo;
GO

-- Create index strategy testing
-- Populate tables with substantial data
DECLARE @Counter int = 1;
WHILE @Counter <= 1000
BEGIN
    INSERT INTO HR.Employees (FirstName, LastName, WorkEmail, HireDate, BaseSalary)
    VALUES 
    (
        'Employee' + CAST(@Counter as varchar(10)),
        'LastName' + CAST(@Counter as varchar(10)),
        'employee' + CAST(@Counter as varchar(10)) + '@company.com',
        DATEADD(DAY, -(@Counter % 1000), GETDATE()),
        40000 + (@Counter % 50000)
    );
    SET @Counter = @Counter + 1;
END;

-- Lab 5.2.2: Test different indexing strategies
-- Test 1: Query without index
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BaseSalary
FROM HR.Employees
WHERE BaseSalary BETWEEN 60000 AND 80000
    AND HireDate >= '2023-01-01'
ORDER BY BaseSalary DESC;

-- Create covering index
CREATE INDEX IX_Employees_Salary_HireDate_Covering
ON HR.Employees (BaseSalary, HireDate)
INCLUDE (FirstName, LastName);

-- Test 2: Same query with index
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BaseSalary
FROM HR.Employees
WHERE BaseSalary BETWEEN 60000 AND 80000
    AND HireDate >= '2023-01-01'
ORDER BY BaseSalary DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- Compare execution plans and statistics
```

## Lab Validation and Assessment

### Validation Checklist

**Architecture Understanding:**
- [ ] Successfully identified SQL Server 2016 edition and version
- [ ] Analyzed memory and CPU configuration
- [ ] Understood database file structure
- [ ] Monitored buffer pool usage

**Edition Features:**
- [ ] Tested compression features (if available)
- [ ] Implemented JSON functionality
- [ ] Explored temporal tables (if available)
- [ ] Set up Always Encrypted demo (if available)

**SSMS Mastery:**
- [ ] Configured Query Store
- [ ] Used Live Query Statistics
- [ ] Created Extended Events session
- [ ] Implemented database diagrams

**Advanced Features:**
- [ ] Created database snapshots (if available)
- [ ] Set up performance monitoring
- [ ] Implemented maintenance procedures
- [ ] Optimized queries with indexing

### Performance Benchmarks

**Expected Metrics:**
```sql
-- Final assessment query
SELECT 
    'Lab Assessment Results' as Assessment,
    COUNT(DISTINCT table_name) as TablesCreated,
    COUNT(DISTINCT routine_name) as ProceduresCreated,
    COUNT(DISTINCT index_name) as IndexesCreated
FROM information_schema.tables t
FULL OUTER JOIN information_schema.routines r ON 1=1
FULL OUTER JOIN sys.indexes i ON 1=1
WHERE t.table_schema IN ('Sales', 'HR', 'Inventory')
    OR r.routine_schema IN ('Sales', 'HR', 'Inventory')
    OR OBJECT_SCHEMA_NAME(i.object_id) IN ('Sales', 'HR', 'Inventory');
```

## Lab Cleanup

```sql
-- Cleanup script (run at end of lab)
USE master;
GO

-- Stop Extended Events session
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'SQL2016_Performance_Monitor')
    ALTER EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER STATE = STOP;

-- Drop databases
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'ArchitectureDemo_Snapshot')
    DROP DATABASE ArchitectureDemo_Snapshot;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'ArchitectureDemo')
    DROP DATABASE ArchitectureDemo;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'MaintenanceDB')
    DROP DATABASE MaintenanceDB;

-- Remove Extended Events session
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'SQL2016_Performance_Monitor')
    DROP EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER;
```

## Key Learning Outcomes

After completing this lab, you should be able to:

1. **Analyze SQL Server 2016 architecture** and understand component interactions
2. **Identify and utilize edition-specific features** appropriate for your environment
3. **Navigate SSMS efficiently** and use advanced features for productivity
4. **Implement performance monitoring** and optimization strategies
5. **Configure SQL Server 2016 new features** like Query Store and JSON support
6. **Create maintenance and monitoring solutions** for production environments

## Next Steps

- Practice with production-like workloads
- Explore SQL Server 2016 Integration Services (SSIS)
- Learn SQL Server 2016 Reporting Services (SSRS)
- Study SQL Server 2016 Analysis Services (SSAS)
- Implement Always On Availability Groups
- Explore In-Memory OLTP features
