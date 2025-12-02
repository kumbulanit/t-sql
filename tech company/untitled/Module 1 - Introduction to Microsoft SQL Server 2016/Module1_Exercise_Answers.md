# Module 1 Exercise Answers: SQL Server 2016 Tools

## Exercise Set 1: SQL Server Architecture (Lesson 1) - Answers

### Exercise 1.1: Instance Information - Answers

**Tasks Solutions**:

1. **Connect to SQL Server instance and retrieve information**:

```sql
-- Basic instance information
SELECT 
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('ServerName') AS ServerPropertyName,
    @@VERSION AS FullVersion,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('EngineEdition') AS EngineEdition,
    SERVERPROPERTY('Collation') AS Collation;

-- System resource information
SELECT 
    cpu_count AS LogicalCPUs,
    physical_memory_kb / 1024 / 1024 AS PhysicalMemoryGB,
    virtual_memory_kb / 1024 / 1024 AS VirtualMemoryGB,
    committed_kb / 1024 / 1024 AS CommittedMemoryGB
FROM sys.dm_os_sys_info;
```

**Questions Answers**:

1. **Difference between @@SERVERNAME and SERVERPROPERTY('ServerName')**:
   - `@@SERVERNAME` returns the name that was set during SQL Server installation
   - `SERVERPROPERTY('ServerName')` returns the current computer name
   - They may differ if the computer was renamed after SQL Server installation

2. **Determining if instance is default**:
   - If `@@SERVERNAME` doesn't contain a backslash, it's the default instance
   - Default instance uses port 1433 by default
   - Named instances include the instance name after a backslash

3. **EngineEdition property meanings**:
   - 1 = Personal/Desktop Engine
   - 2 = Standard
   - 3 = Enterprise
   - 4 = Express
   - 5 = SQL Database
   - 6 = SQL Data Warehouse

### Exercise 1.2: Database File Architecture - Answers

**Tasks Solutions**:

```sql
-- Create test database with specific file settings
CREATE DATABASE ArchitectureTest
ON 
(
    NAME = 'ArchitectureTest_Data',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureTest.mdf',
    SIZE = 100MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 25MB
),
(
    NAME = 'ArchitectureTest_Data2',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureTest_Data2.ndf',
    SIZE = 50MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = 'ArchitectureTest_Log',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ArchitectureTest.ldf',
    SIZE = 25MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
);

-- Query database file information
USE ArchitectureTest;
SELECT 
    file_id,
    name AS logical_name,
    physical_name,
    type_desc AS file_type,
    size * 8 / 1024 AS size_mb,
    max_size * 8 / 1024 AS max_size_mb,
    growth * 8 / 1024 AS growth_mb,
    is_percent_growth
FROM sys.database_files;

-- File usage statistics
SELECT 
    DB_NAME() AS database_name,
    name AS logical_name,
    size * 8 / 1024 AS total_size_mb,
    FILEPROPERTY(name, 'SpaceUsed') * 8 / 1024 AS used_space_mb,
    size * 8 / 1024 - FILEPROPERTY(name, 'SpaceUsed') * 8 / 1024 AS free_space_mb
FROM sys.database_files;
```

**Questions Answers**:

1. **Initial size vs Maximum size**:
   - Initial size: The starting size of the database file when created
   - Maximum size: The largest size the file can grow to (prevents runaway growth)
   - Files grow automatically based on FILEGROWTH settings until MAXSIZE is reached

2. **Separating data and log files**:
   - **Performance**: Reduces I/O contention between data reads/writes and log writes
   - **Reliability**: If one drive fails, the other may still be accessible
   - **Backup strategy**: Allows separate backup schedules for data and logs
   - **Recovery**: Enables point-in-time recovery using log backups

3. **When database file reaches maximum size**:
   - New data insertion/updates that require space will fail
   - Error 1105: "Could not allocate space for object"
   - Database becomes read-only for operations requiring additional space
   - Must increase MAXSIZE or add new files to continue operations

### Exercise 1.3: System Databases - Answers

**Tasks Solutions**:

```sql
-- List all databases including system databases
SELECT 
    name AS database_name,
    database_id,
    create_date,
    collation_name,
    state_desc,
    recovery_model_desc,
    CASE 
        WHEN database_id <= 4 THEN 'System Database'
        ELSE 'User Database'
    END AS database_type
FROM sys.databases
ORDER BY database_id;

-- Examine master database contents (key tables)
USE master;
SELECT 
    'sys.databases' AS table_name,
    COUNT(*) AS row_count
FROM sys.databases
UNION ALL
SELECT 'sys.server_principals', COUNT(*) FROM sys.server_principals
UNION ALL
SELECT 'sys.endpoints', COUNT(*) FROM sys.endpoints;

-- Check tempdb configuration
SELECT 
    name,
    physical_name,
    size * 8 / 1024 AS size_mb,
    max_size * 8 / 1024 AS max_size_mb
FROM tempdb.sys.database_files;

-- Model database properties
USE model;
SELECT 
    name,
    collation_name,
    create_date,
    compatibility_level
FROM sys.databases 
WHERE name = 'model';
```

**Questions Answers**:

1. **Master database corruption consequences**:
   - SQL Server instance cannot start
   - No access to any user databases
   - Must restore from backup or rebuild master database
   - All instance-level configuration is lost if rebuilt
   - **Prevention**: Regular backups of master database

2. **Why not store user data in system databases**:
   - **System integrity**: Risk of corrupting system functions
   - **Backup/Recovery**: System databases have special backup requirements
   - **Maintenance**: System databases undergo special maintenance procedures
   - **Upgrades**: May be affected during SQL Server upgrades
   - **Security**: System databases have elevated security requirements

3. **Model database role in new database creation**:
   - Template for all new user databases
   - Default size, growth, and recovery model settings
   - Any objects created in model appear in new databases
   - Configuration options are inherited by new databases

## Exercise Set 2: SQL Server Editions and Versions (Lesson 2) - Answers

### Exercise 2.1: Edition Comparison - Answers

**Feature Comparison Summary**:

| Feature | Express | Standard | Enterprise |
|---------|---------|----------|------------|
| Max Database Size | 10 GB | 524 PB | 524 PB |
| Max Memory | 1410 MB | 128 GB | OS Maximum |
| Max CPU Cores | 1 | 4 | OS Maximum |
| AlwaysOn Availability Groups | No | Basic (2 nodes) | Yes (8 nodes) |
| Columnstore Index | Read-only | Yes | Yes |
| In-Memory OLTP | No | Yes | Yes |
| Advanced Analytics | No | No | Yes |

**Questions Answers**:

1. **SQL Server Express Edition limitations**:
   - Database size limited to 10 GB
   - Maximum 1 GB RAM usage
   - Single CPU core utilization
   - No SQL Server Agent
   - No advanced high availability features
   - No advanced analytics services

2. **Standard vs Enterprise Edition choice**:
   - **Choose Standard when**:
     - Budget constraints exist
     - Basic high availability needs
     - Smaller scale operations
     - Core features meet requirements
   - **Choose Enterprise when**:
     - Need advanced high availability
     - Large-scale operations
     - Advanced analytics required
     - Maximum performance needed

3. **Developer Edition benefits**:
   - All Enterprise features included
   - Free for development/testing
   - Cannot be used in production
   - Identical feature set to Enterprise
   - Perfect for learning and development

### Exercise 2.2: Version Compatibility - Answers

**Questions Answers**:

1. **SQL Server 2016 to 2014 restore**:
   - **Cannot restore directly** - newer version backups cannot be restored to older versions
   - Must use Export/Import or Generate Scripts wizard
   - Can use backup/restore between same versions
   - Can restore older version backups to newer versions

2. **Migration tools available**:
   - **SQL Server Migration Assistant (SSMA)**
   - **Database Migration Assistant (DMA)**
   - **SQL Server Data Tools (SSDT)**
   - **Import/Export Wizard**
   - **Generate Scripts Wizard**
   - **Third-party tools**

3. **Compatibility levels effect**:
   - Controls T-SQL behavior and features available
   - Allows gradual migration to new features
   - Database can run on newer SQL Server with older compatibility level
   - Affects query optimizer behavior
   - Can be changed after migration for testing

## Exercise Set 3: Getting Started with SSMS (Lesson 3) - Answers

### Exercise 3.1: SSMS Interface Exploration - Answers

**Customization Steps**:

```sql
-- Query to show current connection information
SELECT 
    @@SERVERNAME AS server_name,
    DB_NAME() AS current_database,
    SYSTEM_USER AS current_user,
    GETDATE() AS current_time;
```

**Questions Answers**:

1. **Saving custom layouts in SSMS**:
   - Use Window > Save Window Layout
   - Layouts saved to user profile
   - Can export/import layout files
   - Reset layout using Window > Reset Window Layout

2. **Benefits of multiple query windows**:
   - Work on different databases simultaneously
   - Compare results side by side
   - Maintain context while switching tasks
   - Keep reference queries open
   - Test different connection contexts

3. **Managing multiple server connections**:
   - Use Registered Servers for frequently used connections
   - Group servers by environment (Dev, Test, Prod)
   - Use color coding for different environments
   - Save connection information securely
   - Use SQL Server Authentication sparingly

### Exercise 3.2: Query Editor Features - Answers

**IntelliSense Configuration**:

```sql
-- Enable/disable IntelliSense (Tools > Options > Text Editor > Transact-SQL > IntelliSense)
-- Query to refresh IntelliSense cache
-- Edit > IntelliSense > Refresh Local Cache

-- Example of code that benefits from IntelliSense
SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
```

**Questions Answers**:

1. **IntelliSense efficiency improvements**:
   - Auto-completion of table and column names
   - Syntax error highlighting
   - Parameter hints for functions
   - Keyword completion
   - Reduces typing errors and time

2. **Execution plan information**:
   - Shows query execution strategy
   - Identifies performance bottlenecks
   - Reveals missing indexes
   - Shows actual vs estimated costs
   - Helps optimize query performance

3. **Creating custom code snippets**:
   - Tools > Code Snippets Manager
   - Create .snippet files
   - Define replacement parameters
   - Use Ctrl+K, Ctrl+X to insert
   - Share snippets across team

### Exercise 3.3: SSMS Tools and Utilities - Answers

**Questions Answers**:

1. **Import/Export Wizard vs SSIS**:
   - **Import/Export Wizard**: Simple, one-time data transfers
   - **SSIS**: Complex ETL processes, scheduling, error handling
   - **Use Import/Export for**: Quick data migration, simple transformations
   - **Use SSIS for**: Recurring processes, complex business logic

2. **Database script generation options**:
   - Script data only, schema only, or both
   - Include triggers, indexes, constraints
   - Generate for specific SQL Server version
   - Save to file, clipboard, or publish to provider
   - Advanced options for dependencies

3. **Activity Monitor troubleshooting**:
   - View active processes and blocking
   - Identify resource waits
   - Monitor I/O, CPU, and memory usage
   - Find expensive queries
   - Real-time performance monitoring

## Exercise Set 4: Installing SQL Server 2016 (Lesson 4) - Answers

### Exercise 4.1: Installation Planning - Answers

**Hardware Requirements Planning**:

```sql
-- Query to check current system resources
SELECT 
    cpu_count AS logical_processors,
    physical_memory_kb / 1024 / 1024 AS total_physical_memory_gb,
    virtual_memory_kb / 1024 / 1024 AS total_virtual_memory_gb,
    committed_kb / 1024 / 1024 AS committed_memory_gb,
    committed_target_kb / 1024 / 1024 AS committed_target_gb
FROM sys.dm_os_sys_info;
```

**Questions Answers**:

1. **Minimum hardware requirements for SQL Server 2016**:
   - **Processor**: x64 processor, 1.4 GHz minimum
   - **Memory**: 1 GB minimum (Express), 4 GB recommended
   - **Disk Space**: 6 GB minimum
   - **Operating System**: Windows Server 2012 or later
   - **Network**: TCP/IP protocol

2. **Service account planning importance**:
   - **Security**: Principle of least privilege
   - **Functionality**: Different services need different permissions
   - **Management**: Easier to manage with planned accounts
   - **Authentication**: Domain vs local accounts
   - **Password policies**: Must comply with organization policies

3. **Memory allocation determination**:
   - Leave 2-4 GB for operating system
   - Consider other applications on server
   - Monitor memory usage patterns
   - Use dynamic memory allocation initially
   - Adjust based on performance monitoring

### Exercise 4.2: Installation Best Practices - Answers

**Questions Answers**:

1. **Mixed mode authentication security implications**:
   - **Advantages**: Supports legacy applications, SQL-only authentication
   - **Disadvantages**: Additional attack surface, password management
   - **Best practice**: Use Windows Authentication when possible
   - **Requirement**: Strong SA password if mixed mode chosen

2. **Backup strategy from installation**:
   - Plan backup locations during installation
   - Configure backup devices immediately
   - Test restore procedures
   - Document backup and recovery procedures
   - Consider backup encryption

3. **Post-installation security steps**:
   - Disable SA account if not needed
   - Remove unnecessary features and services
   - Configure Windows Firewall
   - Apply security updates
   - Configure audit logging
   - Review default permissions

### Exercise 4.3: Post-Installation Configuration - Answers

**Configuration Queries**:

```sql
-- Check current memory configuration
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max server memory (MB)';

-- Configure max server memory (example: 8GB on 12GB system)
EXEC sp_configure 'max server memory (MB)', 8192;
RECONFIGURE;

-- Check SQL Server Agent status
SELECT 
    servicename,
    status_desc,
    startup_type_desc
FROM sys.dm_server_services
WHERE servicename LIKE '%Agent%';
```

**Questions Answers**:

1. **Optimal memory configuration determination**:
   - Total system memory minus OS requirements (2-4 GB)
   - Consider other applications on server
   - Monitor performance counters
   - Start conservative and adjust based on usage
   - Use dynamic allocation for most scenarios

2. **Automated maintenance plans benefits**:
   - Consistent maintenance execution
   - Reduces administrative overhead
   - Prevents human error
   - Provides audit trail
   - Can be customized for different databases

3. **SQL Server Agent automatic startup**:
   - When scheduled jobs are required
   - For automated backups and maintenance
   - When using database mail
   - For replication scenarios
   - In production environments (almost always)

## Practical Scenarios - Answers

### Scenario 1: New Environment Setup - Answer

**Recommendation**: SQL Server Standard Edition

**Justification**:
- Budget-conscious but allows for growth
- Supports basic high availability features
- No 10 GB database size limitation
- Includes SQL Server Agent for automation
- Supports advanced backup features

**Installation Plan**:
1. **File Locations**:
   - System databases: C:\Program Files\Microsoft SQL Server\
   - User databases: D:\Data\
   - Log files: E:\Logs\
   - Backups: F:\Backups\

2. **Security Settings**:
   - Windows Authentication mode
   - Disable SA account
   - Create dedicated service accounts
   - Configure Windows Firewall

3. **Post-Installation Steps**:
   - Configure memory (leave 25% for OS)
   - Set up maintenance plans
   - Configure backup strategy
   - Install security updates

### Scenario 2: SSMS Configuration for Team - Answer

**Standardized Configuration**:

1. **Connection Management**:
   - Registered Server Groups: Development, Test, Production
   - Color-coded connections (Red for Production)
   - Shared connection files
   - Standard naming conventions

2. **Interface Layout**:
   - Standard window arrangement
   - Consistent toolbar setup
   - Shared template library
   - Common code snippets

3. **Security Guidelines**:
   - Windows Authentication only
   - Limited production access
   - Read-only connections for developers to production
   - Audit trail for production changes

### Scenario 3: Architecture Analysis - Answer

**Documentation Template**:

```sql
-- Instance inventory query
SELECT 
    @@SERVERNAME AS instance_name,
    SERVERPROPERTY('Edition') AS edition,
    SERVERPROPERTY('ProductVersion') AS version,
    SERVERPROPERTY('ProductLevel') AS service_pack,
    cpu_count AS logical_cpus,
    physical_memory_kb / 1024 / 1024 AS memory_gb
FROM sys.dm_os_sys_info;

-- Database file locations and sizes
SELECT 
    DB_NAME(database_id) AS database_name,
    name AS logical_name,
    physical_name,
    type_desc AS file_type,
    size * 8 / 1024 AS size_mb,
    growth,
    is_percent_growth
FROM sys.master_files
ORDER BY database_id, file_id;
```

**Recommendations**:
1. Separate data and log files on different drives
2. Implement proper backup strategy
3. Configure maintenance plans
4. Update to latest service pack
5. Review security configuration

## Review Questions - Answers

### Multiple Choice Answers
1. **c) msdb** - The msdb database stores SQL Server Agent job information
2. **c) 10 GB** - SQL Server Express has a 10 GB database size limit
3. **a) Windows Authentication only** - Most secure for production environments

### Short Answer Answers

1. **System Database Purposes**:
   - **master**: Instance configuration, system information
   - **model**: Template for new databases
   - **msdb**: SQL Server Agent, backup history
   - **tempdb**: Temporary objects, work tables

2. **Standard vs Enterprise Differences**:
   - **Memory limits**: Standard 128 GB, Enterprise unlimited
   - **CPU cores**: Standard 4, Enterprise unlimited
   - **High availability**: Standard basic, Enterprise advanced
   - **Advanced features**: Enterprise has columnstore, partitioning

3. **Post-Installation Tasks**:
   - Configure memory settings
   - Set up backup strategy
   - Configure security settings
   - Install security updates
   - Create maintenance plans

### Practical Tasks - Sample Solutions

1. **Instance Information Query**:
```sql
SELECT 
    'Server Information' AS category,
    @@SERVERNAME AS server_name,
    SERVERPROPERTY('Edition') AS edition,
    SERVERPROPERTY('ProductVersion') AS version,
    SERVERPROPERTY('Collation') AS collation
UNION ALL
SELECT 
    'Hardware Information',
    CAST(cpu_count AS VARCHAR(50)),
    CAST(physical_memory_kb / 1024 / 1024 AS VARCHAR(50)) + ' GB',
    '',
    ''
FROM sys.dm_os_sys_info;
```

2. **Installation Checklist**:
   - [ ] Verify hardware requirements
   - [ ] Plan service accounts
   - [ ] Design file layout
   - [ ] Configure security settings
   - [ ] Test installation in non-production
   - [ ] Prepare rollback plan
   - [ ] Document configuration settings

3. **SSMS Configuration Guide**:
   - Connection setup procedures
   - Interface customization steps
   - Security guidelines
   - Code template library
   - Best practices for team environment