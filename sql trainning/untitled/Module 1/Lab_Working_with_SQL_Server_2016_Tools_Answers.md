# Lab Answers: Working with SQL Server 2016 Tools

## Lab 1.1: Instance and Edition Verification - Answers

### Lab 1.1.1: Basic Instance Information - Answer
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

**Expected Results:**
- **ServerName**: Shows your computer name and instance name (e.g., DESKTOP-ABC123\SQLEXPRESS)
- **Edition**: Shows the SQL Server edition (Express, Developer, Standard, Enterprise)
- **ProductVersion**: Shows version number starting with 13.x for SQL Server 2016
- **EngineEdition**: 1=Personal/Desktop, 2=Standard, 3=Enterprise, 4=Express

### Lab 1.1.2: Memory and CPU Architecture - Answer
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

**Analysis Points:**
- **LogicalCPUs**: Total logical processors available to SQL Server
- **HyperthreadRatio**: Ratio showing hyperthreading capability
- **PhysicalMemoryGB**: Total physical RAM on the server
- **CommittedMemoryGB**: Memory currently allocated to SQL Server

## Lab 1.2: Database File Architecture Analysis - Answers

### Lab 1.2.1: Create Test Database - Answer
```sql
-- Lab 1.2.1: Create a test database to understand file structure
-- Note: Adjust file paths based on your system configuration
CREATE DATABASE ArchitectureDemo
ON 
(
    NAME = 'ArchitectureDemo_Data',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureDemo.mdf',
    SIZE = 100MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 25MB
)
LOG ON
(
    NAME = 'ArchitectureDemo_Log',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureDemo.ldf',
    SIZE = 25MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
);
GO
```

**Key Points:**
- Adjust file paths to match your SQL Server installation
- Data file (.mdf) stores tables, indexes, and data
- Log file (.ldf) stores transaction log information
- FILEGROWTH settings control automatic expansion

### Lab 1.2.2: Analyze Database File Information - Answer
```sql
-- Lab 1.2.2: Analyze database file information
USE ArchitectureDemo;
GO

SELECT 
    DB_NAME() as DatabaseName,
    file_id,
    name as LogicalName,
    physical_name as PhysicalPath,
    type_desc as FileType,
    size * 8 / 1024 as SizeMB,
    max_size * 8 / 1024 as MaxSizeMB,
    growth * 8 / 1024 as GrowthMB,
    is_percent_growth,
    state_desc as FileState
FROM sys.database_files;
```

**Expected Analysis:**
- File_id 1: Primary data file (.mdf)
- File_id 2: Transaction log file (.ldf)
- Size shown in MB (converted from 8KB pages)
- Growth can be in MB or percentage

## Lab 1.3: SSMS Features Exploration - Answers

### Lab 1.3.1: Object Explorer Navigation - Answer
**Steps to Complete:**
1. **Connect to SQL Server Instance**:
   - Open SSMS
   - Connect to your local SQL Server instance
   - Expand server node in Object Explorer

2. **Navigate Database Structure**:
   ```sql
   -- View system databases
   USE master;
   SELECT name, database_id, create_date, collation_name 
   FROM sys.databases 
   WHERE database_id <= 4;
   
   -- View user databases
   SELECT name, database_id, create_date, collation_name 
   FROM sys.databases 
   WHERE database_id > 4;
   ```

3. **Explore Database Objects**:
   - Expand ArchitectureDemo database
   - Note Tables, Views, Stored Procedures, Functions folders
   - Right-click database → Properties to view settings

### Lab 1.3.2: Query Editor Features - Answer
```sql
-- Lab 1.3.2: Demonstrate Query Editor capabilities
USE ArchitectureDemo;
GO

-- Create sample table to demonstrate features
CREATE TABLE TestTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    CreateDate DATETIME2 DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
GO

-- Insert sample data
INSERT INTO TestTable (Name) VALUES 
('Test Record 1'),
('Test Record 2'),
('Test Record 3');
GO

-- Query with IntelliSense demonstration
SELECT 
    t.ID,
    t.Name,
    t.CreateDate,
    t.IsActive,
    CASE 
        WHEN t.IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END as Status
FROM TestTable t
WHERE t.IsActive = 1
ORDER BY t.CreateDate DESC;
```

**SSMS Features Demonstrated:**
- **IntelliSense**: Auto-completion for table/column names
- **Color Coding**: Keywords in blue, strings in red, comments in green
- **Query Execution**: F5 or Execute button
- **Results Grid**: Shows query results in tabular format
- **Messages Tab**: Shows row counts and execution messages

### Lab 1.3.3: Database Diagram Tool - Answer
**Steps to Create Database Diagram:**
1. **Enable Database Diagrams**:
   ```sql
   -- If database diagrams are not enabled, run:
   USE ArchitectureDemo;
   GO
   
   -- Check if database diagram support exists
   SELECT * FROM sys.objects WHERE name = 'dtproperties';
   ```

2. **Create Additional Tables for Diagram**:
   ```sql
   -- Create related tables to show relationships
   CREATE TABLE Department (
       DeptID INT IDENTITY(1,1) PRIMARY KEY,
       DeptName NVARCHAR(50) NOT NULL,
       Budget DECIMAL(10,2)
   );
   
   CREATE TABLE Employee (
       EmpID INT IDENTITY(1,1) PRIMARY KEY,
       FirstName NVARCHAR(50) NOT NULL,
       LastName NVARCHAR(50) NOT NULL,
       DeptID INT NOT NULL,
       BaseSalary DECIMAL(10,2),
       FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
   );
   ```

3. **Create Diagram Using SSMS**:
   - Right-click "Database Diagrams" → New Database Diagram
   - Add Department and Employee tables
   - Verify foreign key relationship is displayed
   - Save diagram as "CompanyStructure"

## Lab 1.4: Performance Monitoring Setup - Answers

### Lab 1.4.1: Activity Monitor - Answer
**Steps to Access Activity Monitor:**
1. **Open Activity Monitor**:
   - Right-click server name in Object Explorer
   - Select "Activity Monitor" or use Ctrl+Alt+A
   - Wait for Activity Monitor to load

2. **Analyze Current Activity**:
   ```sql
   -- Run this query to generate some activity
   USE ArchitectureDemo;
   GO
   
   DECLARE @i INT = 1;
   WHILE @i <= 1000
   BEGIN
       INSERT INTO TestTable (Name) 
       VALUES ('Performance Test Record ' + CAST(@i AS NVARCHAR(10)));
       SET @i = @i + 1;
   END
   ```

3. **Review Activity Monitor Sections**:
   - **Overview**: CPU, I/O, batch requests/sec
   - **Processes**: Active sessions and queries
   - **Resource Waits**: What SQL Server is waiting for
   - **Data File I/O**: Database file read/write activity
   - **Recent Expensive Queries**: Resource-intensive queries

### Lab 1.4.2: Basic Performance Counters - Answer
```sql
-- Lab 1.4.2: Query performance-related DMVs
USE ArchitectureDemo;
GO

-- Check current database sessions
SELECT 
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    cpu_time,
    memory_usage,
    reads,
    writes,
    logical_reads
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-- Check current wait statistics
SELECT TOP 10
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    max_wait_time_ms,
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_time_ms > 0
ORDER BY wait_time_ms DESC;

-- Check buffer pool usage
SELECT 
    database_id,
    DB_NAME(database_id) as DatabaseName,
    COUNT(*) * 8 / 1024 as BufferSizeMB
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4
GROUP BY database_id
ORDER BY BufferSizeMB DESC;
```

## Lab 1.5: Backup and Recovery Demonstration - Answers

### Lab 1.5.1: Create Full Backup - Answer
```sql
-- Lab 1.5.1: Create full database backup
USE master;
GO

-- Create backup directory (adjust path as needed)
EXEC xp_cmdshell 'mkdir C:\SQLBackups', NO_OUTPUT;
GO

-- Perform full backup
BACKUP DATABASE ArchitectureDemo 
TO DISK = 'C:\SQLBackups\ArchitectureDemo_Full.bak'
WITH 
    FORMAT,
    DESCRIPTION = 'Full backup of ArchitectureDemo - Lab Exercise',
    NAME = 'ArchitectureDemo-Full Database Backup',
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
GO

-- Verify backup
RESTORE VERIFYONLY 
FROM DISK = 'C:\SQLBackups\ArchitectureDemo_Full.bak';
```

### Lab 1.5.2: Transaction Log Backup - Answer
```sql
-- Lab 1.5.2: Create transaction log backup
-- First ensure database is in FULL recovery model
ALTER DATABASE ArchitectureDemo SET RECOVERY FULL;
GO

-- Create some transactions to backup
USE ArchitectureDemo;
GO

INSERT INTO Department (DeptName, Budget) VALUES 
('Research', 150000),
('Quality Assurance', 100000);

INSERT INTO Employee (FirstName, LastName, DeptID, BaseSalary) VALUES 
('John', 'Smith', 1, 65000),
('Jane', 'Doe', 2, 55000);

-- Create transaction log backup
BACKUP LOG ArchitectureDemo 
TO DISK = 'C:\SQLBackups\ArchitectureDemo_Log.trn'
WITH 
    FORMAT,
    DESCRIPTION = 'Transaction log backup of ArchitectureDemo',
    NAME = 'ArchitectureDemo-Log Backup',
    COMPRESSION,
    CHECKSUM;
GO
```

### Lab 1.5.3: Point-in-Time Recovery Simulation - Answer
```sql
-- Lab 1.5.3: Simulate disaster and recovery
USE ArchitectureDemo;
GO

-- Record current time for point-in-time recovery
SELECT GETDATE() as BeforeDisasterTime;

-- Create more data
INSERT INTO Employee (FirstName, LastName, DeptID, BaseSalary) VALUES 
('Mike', 'Johnson', 1, 70000);

-- Simulate accidental data deletion (disaster)
DELETE FROM Employee WHERE FirstName = 'Mike';

-- Record disaster time
SELECT GETDATE() as DisasterTime;

-- Recovery process:
-- 1. Take tail-log backup
BACKUP LOG ArchitectureDemo 
TO DISK = 'C:\SQLBackups\ArchitectureDemo_TailLog.trn'
WITH 
    NO_TRUNCATE,
    DESCRIPTION = 'Tail log backup before restore',
    NAME = 'ArchitectureDemo-Tail Log Backup';

-- 2. Restore full backup with NORECOVERY
RESTORE DATABASE ArchitectureDemo_Recovery 
FROM DISK = 'C:\SQLBackups\ArchitectureDemo_Full.bak'
WITH 
    MOVE 'ArchitectureDemo_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureDemo_Recovery.mdf',
    MOVE 'ArchitectureDemo_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureDemo_Recovery.ldf',
    NORECOVERY,
    REPLACE;

-- 3. Restore log backups
RESTORE LOG ArchitectureDemo_Recovery 
FROM DISK = 'C:\SQLBackups\ArchitectureDemo_Log.trn'
WITH NORECOVERY;

RESTORE LOG ArchitectureDemo_Recovery 
FROM DISK = 'C:\SQLBackups\ArchitectureDemo_TailLog.trn'
WITH RECOVERY;

-- Verify recovery
USE ArchitectureDemo_Recovery;
SELECT * FROM Employee;
```

## Lab Summary and Key Takeaways

### Architecture Understanding
- **SQL Server Components**: Database Engine, SSMS, system databases
- **File Structure**: Data files (.mdf), log files (.ldf), file groups
- **Memory Management**: Buffer pool, committed memory, target memory

### SSMS Proficiency
- **Object Explorer**: Navigate database objects and properties
- **Query Editor**: IntelliSense, syntax highlighting, execution plans
- **Activity Monitor**: Real-time performance monitoring
- **Database Diagrams**: Visual representation of table relationships

### Performance Monitoring
- **DMVs Usage**: sys.dm_exec_sessions, sys.dm_os_wait_stats
- **Activity Monitor**: CPU, I/O, wait statistics, expensive queries
- **Performance Counters**: Buffer cache hit ratio, batch requests/sec

### Backup and Recovery
- **Backup Types**: Full, differential, transaction log, tail-log
- **Recovery Models**: Simple, full, bulk-logged
- **Point-in-Time Recovery**: Restore sequence for disaster recovery

### Best Practices Learned
1. **Regular Monitoring**: Use Activity Monitor and DMVs proactively
2. **Backup Strategy**: Implement appropriate backup schedule based on RTO/RPO
3. **File Management**: Separate data and log files on different drives
4. **Memory Configuration**: Monitor and adjust memory settings as needed
5. **Documentation**: Use SSMS features to document database structure

### Next Steps
- Practice with larger databases to understand performance implications
- Explore advanced SSMS features like execution plans and profiler
- Study backup and recovery scenarios for production environments
- Learn about high availability and disaster recovery options

## Cleanup Commands
```sql
-- Clean up lab environment
USE master;
GO

-- Drop test databases
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ArchitectureDemo')
    DROP DATABASE ArchitectureDemo;

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ArchitectureDemo_Recovery')
    DROP DATABASE ArchitectureDemo_Recovery;

-- Clean up backup files (run in command prompt as administrator)
-- DEL "C:\SQLBackups\ArchitectureDemo_*.bak"
-- DEL "C:\SQLBackups\ArchitectureDemo_*.trn"
```