# Lesson 2: SQL Server Editions and Versions

## Learning Objectives
- Understand different SQL Server editions and their features
- Learn about SQL Server version history and evolution
- Compare licensing models and cost considerations
- Choose appropriate edition for specific scenarios
- Understand compatibility and upgrade paths

## 2.1 SQL Server Editions Overview

Microsoft SQL Server comes in different editions, each designed for specific use cases, from small applications to enterprise-scale deployments.

## 2.1.1 SQL Server 2016 Operating System Requirements

### Supported Windows Operating Systems

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SQL SERVER 2016 OS COMPATIBILITY                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  WINDOWS SERVER EDITIONS (Recommended for Production):                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ • Windows Server 2019 (✓ Fully Supported)                             │
│  │ • Windows Server 2016 (✓ Fully Supported)                             │
│  │ • Windows Server 2012 R2 (✓ Fully Supported)                          │
│  │ • Windows Server 2012 (✓ Fully Supported)                             │
│  │ • Windows Server 2008 R2 SP1 (✓ Minimum Requirement)                  │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  WINDOWS CLIENT EDITIONS (Development/Testing):                            │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ • Windows 11 (✓ Supported)                                             │
│  │ • Windows 10 (✓ Fully Supported)                                       │
│  │ • Windows 8.1 (✓ Fully Supported)                                      │
│  │ • Windows 8 (✓ Supported)                                              │
│  │ • Windows 7 SP1 (✓ Minimum Requirement)                                │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ARCHITECTURE REQUIREMENTS:                                                 │
│  • 64-bit (x64) processors only                                            │
│  • 32-bit (x86) NOT supported for SQL Server 2016                         │
│                                                                             │
│  MINIMUM HARDWARE REQUIREMENTS:                                             │
│  • Processor: 1.4 GHz minimum (2.0 GHz recommended)                       │
│  • Memory: 512 MB minimum (4 GB recommended)                               │
│  • Hard Disk: 6 GB minimum free space                                      │
│                                                                             │
│  NOT SUPPORTED:                                                             │
│  • Windows Vista                                                           │
│  • Windows XP                                                              │
│  • Windows Server 2008 (without R2)                                        │
│  • Any 32-bit Windows versions                                             │
│  • Linux (SQL Server 2017+ supports Linux)                                │
│  • macOS                                                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Detailed OS Requirements by SQL Server 2016 Edition

| Edition | Windows Server | Windows Client | Notes |
|---------|---------------|----------------|-------|
| **Enterprise** | Server 2008 R2 SP1+ | Windows 7 SP1+ | Production use on Server OS recommended |
| **Standard** | Server 2008 R2 SP1+ | Windows 7 SP1+ | Production use on Server OS recommended |
| **Web** | Server 2008 R2 SP1+ | Not recommended | Server OS required for production |
| **Developer** | Server 2008 R2 SP1+ | Windows 7 SP1+ | Any supported OS for development |
| **Express** | Server 2008 R2 SP1+ | Windows 7 SP1+ | Works on all supported OS versions |

### Operating System Feature Dependencies

```sql
-- Check your current Windows version
SELECT 
    windows_release,
    windows_service_pack_level,
    windows_sku,
    os_language_version
FROM sys.dm_os_windows_info;

-- Verify SQL Server 2016 compatibility
SELECT 
    @@VERSION AS SQLServerVersion,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductLevel') AS ServicePackLevel,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;
```

### Important Considerations:

**For Production Environments:**
- **Windows Server** editions are strongly recommended
- **Windows Client** OS (Windows 10, 11) should only be used for development/testing
- Always use the latest service packs and updates

**For Development/Learning:**
- **Windows 10/11** with SQL Server 2016 Developer or Express edition
- **Windows 8.1** is supported but Windows 10+ recommended
- **Windows 7 SP1** is the minimum but not recommended for new installations

**Virtualization Support:**
- Supported on Hyper-V, VMware, and other major virtualization platforms
- Same OS requirements apply to virtual machines
- Consider licensing implications for virtualized environments

### Edition Hierarchy Diagram
```
┌─────────────────────────────────────────────────────────┐
│                    ENTERPRISE                           │
│              (Maximum Features)                         │
│  ┌─────────────────────────────────────────────────────┐ │
│  │                  STANDARD                           │ │
│  │             (Core Features)                         │ │
│  │  ┌─────────────────────────────────────────────────┐ │ │
│  │  │                   WEB                           │ │ │
│  │  │            (Web Hosting)                        │ │ │
│  │  └─────────────────────────────────────────────────┘ │ │
│  │  ┌─────────────────────────────────────────────────┐ │ │
│  │  │                 EXPRESS                         │ │ │
│  │  │            (Free Edition)                       │ │ │
│  │  └─────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────┐ │
│  │                DEVELOPER                            │ │
│  │         (Development/Testing)                       │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 2.2 Detailed Edition Comparison

### 2.2.1 SQL Server Express Edition

**Target Audience:** Small applications, learning, development
**Cost:** FREE
**Limitations:**
- Database size: 10 GB maximum
- Memory usage: 1 GB RAM limit
- CPU: Limited to 1 socket or 4 cores

**Simple Example - Checking Edition:**
```sql
SELECT 
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS Version,
    SERVERPROPERTY('ProductLevel') AS ServicePack;
```

**Use Cases:**
- Small desktop applications
- Learning SQL Server
- Prototype development
- Small websites with limited data

**Features Included:**
- Basic database engine
- SQL Server Management Studio Express
- Basic replication (subscriber only)
- Basic reporting services

### 2.2.2 SQL Server Web Edition

**Target Audience:** Web hosting providers, web applications
**Cost:** Low-cost licensing for hosting scenarios

**Limitations:**
- No high availability features
- Limited to web workloads
- No advanced analytics

**Example - Web Edition Configuration:**
```sql
-- Typical web application database setup
CREATE DATABASE WebAppDB
ON 
(
    NAME = 'WebApp_Data',
    FILENAME = 'C:\WebApps\WebAppDB.mdf',
    SIZE = 500MB,
    FILEGROWTH = 50MB
)
LOG ON
(
    NAME = 'WebApp_Log',
    FILENAME = 'C:\WebApps\WebAppDB.ldf',
    SIZE = 50MB,
    FILEGROWTH = 10%
);

-- Web-optimized settings
ALTER DATABASE WebAppDB SET READ_COMMITTED_SNAPSHOT ON;
```

### 2.2.3 SQL Server Standard Edition

**Target Audience:** Small to medium businesses
**Cost:** Mid-range licensing

**Key Features:**
- Unlimited database size
- Basic Always On (2 replicas)
- Full-text search
- Basic integration services
- Standard reporting services

**Advanced Example - Standard Edition Features:**
```sql
-- Always On Availability Groups (Basic)
CREATE AVAILABILITY GROUP AG_StandardDemo
WITH (
    AUTOMATED_BACKUP_PREFERENCE = SECONDARY,
    DB_FAILOVER = ON
)
FOR DATABASE SalesDB
REPLICA ON 
    'SQL-PRIMARY' WITH (
        ENDPOINT_URL = 'TCP://SQL-PRIMARY:5022',
        AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
        FAILOVER_MODE = AUTOMATIC
    ),
    'SQL-SECONDARY' WITH (
        ENDPOINT_URL = 'TCP://SQL-SECONDARY:5022',
        AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
        FAILOVER_MODE = MANUAL
    );
```

**Resource Limits:**
```
┌─────────────────────────────────────────────────────────┐
│                 STANDARD EDITION LIMITS                │
│                                                         │
│  Max Memory Used by Database Engine: OS Maximum        │
│  Max Compute Capacity: 24 cores                        │
│  Max Database Size: 524 PB                             │
│  Max Always On Replicas: 2                             │
│  Columnstore: Yes (read-only)                          │
│  In-Memory OLTP: Yes (limited)                         │
└─────────────────────────────────────────────────────────┘
```

### 2.2.4 SQL Server Enterprise Edition

**Target Audience:** Large enterprises, mission-critical applications
**Cost:** Premium licensing

**Advanced Features:**
- Unlimited Always On replicas
- Advanced compression
- Partitioning
- Advanced security features
- In-Memory OLTP (unlimited)
- Advanced analytics

**Enterprise Feature Example:**
```sql
-- Advanced partitioning (Enterprise only)
CREATE PARTITION FUNCTION SalesDateRange (datetime)
AS RANGE RIGHT FOR VALUES 
    ('2023-01-01', '2023-04-01', '2023-07-01', '2023-10-01', '2024-01-01');

CREATE PARTITION SCHEME SalesDateScheme
AS PARTITION SalesDateRange
TO ([PRIMARY], [Q1_2023], [Q2_2023], [Q3_2023], [Q4_2023]);

CREATE TABLE Sales_Partitioned
(
    SaleID int IDENTITY(1,1),
    SaleDate datetime,
    CustomerID int,
    Amount decimal(10,2)
) ON SalesDateScheme(SaleDate);
```

**Enterprise Resource Capabilities:**
```
┌─────────────────────────────────────────────────────────┐
│               ENTERPRISE EDITION FEATURES              │
│                                                         │
│  ┌─────────────────┬─────────────────────────────────┐ │
│  │ COMPUTE         │ Operating System Maximum        │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ MEMORY          │ Operating System Maximum        │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ DATABASE SIZE   │ 524 PB                          │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ AVAILABILITY    │ Unlimited Replicas              │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ COLUMNSTORE     │ Full Read/Write Support         │ │
│  └─────────────────┴─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### 2.2.5 SQL Server Developer Edition

**Target Audience:** Developers, testers, non-production environments
**Cost:** FREE for development/testing

**Features:** Same as Enterprise edition but licensed only for development/testing

**Example - Development Environment Setup:**
```sql
-- Enable advanced features for testing
-- (Available in Developer/Enterprise)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'max server memory', 8192; -- 8GB
RECONFIGURE;

-- Enable In-Memory OLTP for testing
ALTER DATABASE TestDB ADD FILEGROUP InMemory_FG 
    CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE TestDB ADD FILE (
    NAME = 'InMemory_File',
    FILENAME = 'C:\Data\TestDB_InMemory'
) TO FILEGROUP InMemory_FG;
```

## 2.3 SQL Server Version History

### Version Timeline
```
2008  ──────→  2008 R2  ──────→  2012  ──────→  2014  ──────→  2016
  │              │               │              │              │
  │              │               │              │              │
  ▼              ▼               ▼              ▼              ▼
Policy-Based   PowerPivot    AlwaysOn       In-Memory      Always
Management     Integration   Availability   OLTP           Encrypted
                             Groups                        
```

```
2017  ──────→  2019  ──────→  2022  ──────→  Future Versions
  │              │              │
  │              │              │
  ▼              ▼              ▼
Linux          Big Data       Azure Arc
Support        Clusters       Integration
```

### Version Feature Comparison

**SQL Server 2016 Key Features:**
```sql
-- Always Encrypted (New in 2016)
CREATE TABLE Customers_Encrypted
(
    CustomerID int,
    CustomerName nvarchar(100),
    SSN nvarchar(11) ENCRYPTED WITH (
        COLUMN_ENCRYPTION_KEY = CEK1,
        ENCRYPTION_TYPE = DETERMINISTIC,
        ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256'
    )
);

-- JSON Support (New in 2016)
SELECT 
    CustomerID,
    JSON_VALUE(CustomerData, '$.Name') as CustomerName,
    JSON_QUERY(CustomerData, '$.Orders') as Orders
FROM CustomersJSON;
```

**SQL Server 2017 Features:**
```sql
-- Graph Database (New in 2017)
CREATE TABLE Person (
    ID INTEGER PRIMARY KEY,
    Name VARCHAR(100)
) AS NODE;

CREATE TABLE Friends (
    StartDate DATE
) AS EDGE;

-- Linux compatibility
-- Cross-platform support
```

**SQL Server 2019 Features:**
```sql
-- Big Data Clusters
-- Intelligent Query Processing
-- Accelerated Database Recovery

-- UTF-8 Support
CREATE TABLE UTF8_Table (
    ID int,
    Description nvarchar(max) COLLATE Latin1_General_100_CI_AS_SC_UTF8
);
```

## 2.4 Licensing Models

### Licensing Comparison Chart
```
┌─────────────────────────────────────────────────────────┐
│                   LICENSING MODELS                     │
│                                                         │
│  ┌─────────────────┬─────────────────────────────────┐ │
│  │ CORE-BASED      │ Per Physical/Virtual Core       │ │
│  │                 │ Minimum 4 cores per processor   │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ SERVER + CAL    │ Server License + Client Access  │ │
│  │                 │ Licenses (User or Device)       │ │
│  ├─────────────────┼─────────────────────────────────┤ │
│  │ CLOUD           │ Pay-as-you-go or Reserved       │ │
│  │                 │ Azure SQL Database/MI           │ │
│  └─────────────────┴─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### Cost Calculation Examples

**Example 1: Small Business (Server + CAL)**
```
Server: SQL Server Standard = $899
CALs: 50 users × $208 = $10,400
Total: $11,299
```

**Example 2: Web Application (Core-based)**
```
Server: 8 cores × $3,945 (Standard per core) = $31,560
(Minimum 4 cores required)
```

**Example 3: Enterprise (Core-based)**
```
Server: 16 cores × $14,256 (Enterprise per core) = $228,096
Software Assurance: 20% additional for support/upgrades
```

## 2.5 Edition Selection Decision Tree

```
START: What is your use case?
    │
    ├── Learning/Development? ──→ DEVELOPER EDITION (Free)
    │
    ├── Small App (<10GB)? ──→ EXPRESS EDITION (Free)
    │
    ├── Web Hosting? ──→ WEB EDITION
    │
    ├── Small-Medium Business? ──→ STANDARD EDITION
    │   │
    │   ├── Need Always On? ──→ Yes: STANDARD (Basic Always On)
    │   └── Advanced Features? ──→ Yes: Consider ENTERPRISE
    │
    └── Enterprise/Mission Critical? ──→ ENTERPRISE EDITION
        │
        ├── Unlimited Always On
        ├── Advanced Security
        ├── Partitioning
        └── In-Memory OLTP
```

## 2.6 Practical Exercises

### Exercise 1: Identify Your Current Edition
```sql
-- Check current SQL Server edition and features
SELECT 
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('EngineEdition') AS EngineEdition,
    SERVERPROPERTY('ProductVersion') AS Version,
    SERVERPROPERTY('ProductLevel') AS ServicePack,
    SERVERPROPERTY('LicenseType') AS LicenseType;

-- Check available features
SELECT 
    feature_name,
    feature_id
FROM sys.dm_db_persisted_sku_features;
```

### Exercise 2: Memory and CPU Limits Check
```sql
-- Check memory configuration
SELECT 
    name,
    value,
    value_in_use,
    description
FROM sys.configurations
WHERE name IN ('max server memory (MB)', 'min server memory (MB)');

-- Check CPU information
SELECT 
    cpu_count,
    hyperthread_ratio,
    physical_memory_kb / 1024 / 1024 AS physical_memory_gb,
    virtual_memory_kb / 1024 / 1024 AS virtual_memory_gb
FROM sys.dm_os_sys_info;
```

### Exercise 3: Feature Availability Test
```sql
-- Test Enterprise features (will fail on lower editions)
-- Compression test
CREATE TABLE TestCompression (
    ID int,
    Data varchar(1000)
) WITH (DATA_COMPRESSION = PAGE); -- Enterprise/Developer only

-- Partitioning test
CREATE PARTITION FUNCTION TestPartition (int)
AS RANGE LEFT FOR VALUES (100, 200, 300); -- Enterprise/Developer only
```

### Exercise 4: Upgrade Path Planning
```sql
-- Check database compatibility level
SELECT 
    name,
    database_id,
    compatibility_level,
    collation_name
FROM sys.databases;

-- Check deprecated features
SELECT 
    object_name,
    counter_name,
    cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Deprecated Features';
```

## 2.7 Migration and Upgrade Considerations

### Version Compatibility Matrix
```
┌─────────────────────────────────────────────────────────┐
│              UPGRADE PATHS                              │
│                                                         │
│  SQL 2008/R2 ──→ 2012 ──→ 2014 ──→ 2016 ──→ 2017     │
│       │          │        │        │        │          │
│       └──────────┼────────┼────────┼────────┼──→ 2019 │
│                  └────────┼────────┼────────┼──→ 2022 │
│                           └────────┼────────┘          │
│                                    └── Direct Upgrade │
│                                        Supported      │
└─────────────────────────────────────────────────────────┘
```

### Pre-Upgrade Checklist
```sql
-- 1. Check current version
SELECT @@VERSION;

-- 2. Run upgrade advisor
-- Use Microsoft Data Migration Assistant (DMA)

-- 3. Check deprecated features
SELECT DISTINCT object_name 
FROM sys.dm_os_performance_counters 
WHERE object_name LIKE '%Deprecated%' 
AND cntr_value > 0;

-- 4. Backup all databases
BACKUP DATABASE [YourDB] 
TO DISK = 'C:\Backup\YourDB_PreUpgrade.bak'
WITH COMPRESSION, CHECKSUM;
```

## Key Takeaways

1. **Edition Selection**: Choose based on features needed, not just cost
2. **Licensing**: Understand core-based vs. Server+CAL models
3. **Development**: Use Developer edition for full feature testing
4. **Small Projects**: Express edition is powerful for small applications
5. **Enterprise Features**: Justify cost with business requirements
6. **Upgrade Planning**: Plan upgrade paths and test compatibility

## Next Steps
- Evaluate your organization's requirements
- Test features in Developer edition
- Plan licensing strategy
- Consider cloud alternatives (Azure SQL)
