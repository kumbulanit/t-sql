│                                                                             │
│  BACKUP DIRECTORY:                                                          │
│  C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup    │
│                                                                             │
│  RECOMMENDED CUSTOM LAYOUT (Optional):                                      │
│  • Data files: C:\SQLData\                                                 │
│  • Log files: C:\SQLLogs\                                                  │
│  • Backups: C:\SQLBackups\                                                 │
│                                                                             │
│  BENEFITS OF SEPARATE DRIVES:                                               │
│  • Better I/O performance                                                  │
│  • Easier backup and maintenance                                           │
│  • Better capacity management                                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**12. Ready to Install**
- Review all configuration settings
- Note the configuration file location for future reference
- Click "Install" to begin installation

**13. Installation Progress**
- Monitor installation progress
- Installation typically takes 15-30 minutes
- Do not interrupt the installation process

**14. Complete**
- Review installation results
- Note any warnings or errors
- Click "Close" to finish

### Step 4: Post-Installation Configuration

#### Verify Installation
```sql
-- Connect to SQL Server and run these verification queries

-- Check SQL Server version and edition
SELECT 
    @@VERSION AS SQLServerVersion,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductLevel') AS ServicePack,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('InstanceName') AS InstanceName;

-- Check service status
SELECT 
    servicename,
    status_desc,
    startup_type_desc,
    service_account
FROM sys.dm_server_services;

-- Check database files and locations
SELECT 
    name AS DatabaseName,
    database_id,
    create_date,
    physical_name AS DatabaseFile,
    size * 8 / 1024 AS SizeMB,
    type_desc AS FileType
FROM sys.master_files
ORDER BY database_id, type_desc;
```

#### Configure SQL Server Network Settings
```sql
-- Enable TCP/IP protocol (if needed)
-- This is typically done through SQL Server Configuration Manager

-- Check current network configuration
SELECT 
    protocol_desc,
    endpoint_id,
    is_admin_endpoint,
    port,
    ip_address
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;

-- Enable remote connections (if needed)
EXEC sp_configure 'remote access', 1;
RECONFIGURE;

-- Configure maximum memory (optional - set to 75% of available RAM)
-- Example: For 8GB server, set to 6GB (6144 MB)
EXEC sp_configure 'max server memory', 6144;
RECONFIGURE;

-- Show advanced configuration options
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
```

#### Windows Firewall Configuration
```powershell
# Run as Administrator to configure Windows Firewall for SQL Server

# Enable SQL Server Database Engine (default port 1433)
New-NetFirewallRule -DisplayName "SQL Server Database Engine" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow

# Enable SQL Server Browser (UDP 1434)
New-NetFirewallRule -DisplayName "SQL Server Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow

# Enable dedicated admin connection (1434)
New-NetFirewallRule -DisplayName "SQL Server DAC" -Direction Inbound -Protocol TCP -LocalPort 1434 -Action Allow

# For named instances, may need to enable dynamic ports
# Check SQL Server Configuration Manager for the actual port

Write-Host "Firewall rules created for SQL Server" -ForegroundColor Green
```

### Step 5: Install SQL Server Management Studio (SSMS)

**1. Download SSMS**
```
Current SSMS Download: https://aka.ms/ssmsfullsetup
File: SSMS-Setup-ENU.exe (typically 600+ MB)
```

**2. Install SSMS**
```batch
:: Run the SSMS installer
SSMS-Setup-ENU.exe

:: Installation steps:
:: 1. Accept license terms
:: 2. Choose installation location (default recommended)
:: 3. Wait for installation (10-15 minutes)
:: 4. Restart if prompted
```

**3. First Connection to SQL Server**
```
1. Start SQL Server Management Studio
2. Connect to Database Engine:
   - Server type: Database Engine
   - Server name: localhost or (local) or server IP
   - Authentication: Windows Authentication (recommended)
   - Or SQL Server Authentication using 'sa' account

3. Verify connection:
   - Expand Databases node
   - You should see system databases (master, model, msdb, tempdb)
```

## 4.4 Installation Verification and Testing

### Complete Installation Test Script
```sql
-- Comprehensive SQL Server 2016 installation verification script
-- Run this in SSMS after installation

PRINT '=== SQL Server 2016 Installation Verification ==='
PRINT ''

-- 1. Basic server information
PRINT '1. Server Information:'
SELECT 
    'Server Name' AS Property, @@SERVERNAME AS Value
UNION ALL
SELECT 'SQL Server Version', @@VERSION
UNION ALL
SELECT 'Edition', CAST(SERVERPROPERTY('Edition') AS VARCHAR(100))
UNION ALL
SELECT 'Product Level', CAST(SERVERPROPERTY('ProductLevel') AS VARCHAR(100))
UNION ALL
SELECT 'Collation', CAST(SERVERPROPERTY('Collation') AS VARCHAR(100));

PRINT ''
PRINT '2. Service Status:'
SELECT 
    servicename,
    status_desc,
    startup_type_desc
FROM sys.dm_server_services
WHERE servicename LIKE '%SQL%';

PRINT ''
PRINT '3. Database Information:'
SELECT 
    name AS DatabaseName,
    database_id,
    create_date,
    state_desc AS Status,
    recovery_model_desc AS RecoveryModel
FROM sys.databases
ORDER BY database_id;

PRINT ''
PRINT '4. Memory Configuration:'
SELECT 
    name,
    value_in_use,
    description
FROM sys.configurations
WHERE name IN ('max server memory (MB)', 'min server memory (MB)');

PRINT ''
PRINT '5. Test Database Creation:'
-- Create a test database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'InstallationTest')
BEGIN
    CREATE DATABASE InstallationTest;
    PRINT 'Test database created successfully';
END
ELSE
    PRINT 'Test database already exists';

-- Use the test database
USE InstallationTest;

-- Create a test table
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TestTable')
BEGIN
    CREATE TABLE TestTable (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        TestData NVARCHAR(100),
        CreatedDate DATETIME2 DEFAULT SYSDATETIME()
    );
    PRINT 'Test table created successfully';
END

-- Insert test data
INSERT INTO TestTable (TestData) VALUES ('SQL Server 2016 Installation Test');

-- Query test data
SELECT * FROM TestTable;

-- Clean up (optional)
-- USE master;
-- DROP DATABASE InstallationTest;

PRINT ''
PRINT '=== Installation Verification Complete ==='
PRINT 'If no errors appeared above, SQL Server 2016 is properly installed!'
```

### Performance Baseline Setup
```sql
-- Set up basic performance monitoring after installation
# Lesson 4: Installing SQL Server 2016 on Windows Server
-- 1. Configure basic performance counters
-- Enable query store for performance tracking
ALTER DATABASE InstallationTest SET QUERY_STORE = ON;

-- 2. Basic server configuration for optimal performance
-- Configure max degree of parallelism (usually number of cores)
DECLARE @CoreCount INT = (SELECT cpu_count FROM sys.dm_os_sys_info);
EXEC sp_configure 'max degree of parallelism', @CoreCount;
RECONFIGURE;

-- 3. Configure cost threshold for parallelism
EXEC sp_configure 'cost threshold for parallelism', 50;
RECONFIGURE;

-- 4. Show current configuration
EXEC sp_configure;

PRINT 'Basic performance configuration completed';
```

## 4.5 Common Installation Issues and Solutions

### Troubleshooting Guide

#### Issue 1: Installation Fails with .NET Framework Error
```
Problem: "This SQL Server setup media does not support the language of the OS"
Solution:
1. Download and install .NET Framework 4.6 or later
2. Install all Windows Updates
3. Restart the server
4. Re-run SQL Server setup
```

#### Issue 2: Service Account Issues
```powershell
# Problem: Services fail to start due to account permissions
# Solution: Grant proper permissions to service accounts

# For Virtual Accounts (NT SERVICE\MSSQLSERVER)
# Usually no action needed - automatic permissions

# For Domain Accounts - run these on domain controller:
# Grant "Log on as a service" right
# Grant "Perform volume maintenance tasks" right
# Grant "Lock pages in memory" right (for large memory servers)

# Check service account permissions
whoami /priv
```

#### Issue 3: Firewall Blocking Connections
```powershell
# Problem: Cannot connect to SQL Server from remote machines
# Solution: Configure Windows Firewall

# Check if SQL Server is listening
netstat -an | findstr :1433

# Test connectivity from client
Test-NetConnection -ComputerName ServerName -Port 1433

# Alternative firewall configuration
netsh advfirewall firewall add rule name="SQL Server" dir=in action=allow protocol=TCP localport=1433
```

#### Issue 4: Authentication Problems
```sql
-- Problem: Cannot connect with SQL Authentication
-- Solution: Verify mixed mode authentication

-- Check authentication mode
SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
    WHEN 1 THEN 'Windows Authentication'
    WHEN 0 THEN 'Mixed Mode'
END AS AuthenticationMode;

-- Enable mixed mode if needed (requires restart)
-- Use SQL Server Configuration Manager or:
EXEC xp_instance_regwrite 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode', REG_DWORD, 2;

-- Note: SQL Server service restart required after this change
```

#### Issue 5: Performance Issues After Installation
```sql
-- Problem: SQL Server running slowly
-- Solution: Basic performance tuning

-- Check memory allocation
SELECT 
    physical_memory_kb / 1024 AS TotalMemoryMB,
    virtual_memory_kb / 1024 AS VirtualMemoryMB,
    committed_kb / 1024 AS CommittedMemoryMB,
    committed_target_kb / 1024 AS TargetMemoryMB
FROM sys.dm_os_sys_memory;

-- Check wait statistics
SELECT TOP 10
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    max_wait_time_ms,
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN ('CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 
    'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 
    'LOGMGR_QUEUE', 'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH',
    'XE_TIMER_EVENT', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT',
    'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
    'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP')
ORDER BY wait_time_ms DESC;
```

## 4.6 Post-Installation Security Hardening

### Security Configuration Checklist
```sql
-- SQL Server 2016 Security Hardening Script
-- Run after installation to improve security

PRINT '=== SQL Server Security Hardening ==='

-- 1. Disable unnecessary services and features
-- Disable SQL Browser if not needed for named instances
-- (Done through SQL Server Configuration Manager)

-- 2. Configure minimum password requirements
-- Check current password policy
SELECT name, value_in_use, description 
FROM sys.configurations 
WHERE name LIKE '%password%';

-- 3. Disable 'sa' account if not needed
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'sa' AND is_disabled = 0)
BEGIN
    ALTER LOGIN [sa] DISABLE;
    PRINT 'SA account disabled for security';
END

-- 4. Remove sample databases (if any were installed)
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'AdventureWorks2016')
    DROP DATABASE AdventureWorks2016;

-- 5. Configure surface area reduction
-- Disable xp_cmdshell if not needed
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;

-- Disable CLR if not needed
EXEC sp_configure 'clr enabled', 0;
RECONFIGURE;

-- Disable OLE Automation if not needed
EXEC sp_configure 'Ole Automation Procedures', 0;
RECONFIGURE;

-- 6. Configure audit login events
-- Enable failed login auditing
EXEC xp_instance_regwrite 
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'AuditLevel', REG_DWORD, 2;

PRINT 'Security hardening completed - restart SQL Server service';
```

### Network Security Configuration
```powershell
# Additional network security for SQL Server

# 1. Disable unnecessary protocols
# Keep only TCP/IP enabled (done through SQL Server Configuration Manager)

# 2. Change default port (optional but recommended for production)
# Use SQL Server Configuration Manager to change from 1433 to custom port

# 3. Enable SSL encryption (for production environments)
# Requires SSL certificate - configure through Configuration Manager

# 4. Restrict IP addresses (if needed)
# Configure specific IP addresses in SQL Server Configuration Manager

Write-Host "Network security configuration guidelines applied" -ForegroundColor Green
```

## 4.7 Maintenance and Updates

### Keeping SQL Server 2016 Updated
```sql
-- Check current version and available updates
SELECT 
    SERVERPROPERTY('ProductVersion') AS CurrentVersion,
    SERVERPROPERTY('ProductLevel') AS ServicePackLevel,
    SERVERPROPERTY('Edition') AS Edition;

-- Check last update installation
SELECT 
    create_date,
    name
FROM sys.databases
WHERE name = 'master';

-- Set up automatic updates (optional)
-- Configure through Windows Update or WSUS
```

### Backup Strategy Setup
```sql
-- Set up basic backup strategy immediately after installation

-- 1. Create backup devices
EXEC sp_addumpdevice 'disk', 'SystemBackup',
'C:\SQLBackups\SystemBackup.bak';

-- 2. Backup system databases
BACKUP DATABASE master TO SystemBackup;
BACKUP DATABASE model TO DISK = 'C:\SQLBackups\model.bak';
BACKUP DATABASE msdb TO DISK = 'C:\SQLBackups\msdb.bak';

-- 3. Set up maintenance plan (basic)
-- This should be done through SSMS Maintenance Plan Wizard

PRINT 'Basic backup strategy implemented';
PRINT 'Consider setting up automated maintenance plans';
```

## 4.8 Installation Checklist Summary

### Final Verification Checklist
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     POST-INSTALLATION CHECKLIST                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  INSTALLATION VERIFICATION:                                                 │
│  ☐ SQL Server 2016 services are running                                   │
│  ☐ Can connect via SSMS using Windows Authentication                       │
│  ☐ Can connect via SSMS using SQL Authentication (if enabled)              │
│  ☐ System databases are accessible (master, model, msdb, tempdb)           │
│  ☐ Can create test database and tables                                     │
│                                                                             │
│  CONFIGURATION:                                                             │
│  ☐ Memory configuration optimized                                          │
│  ☐ Network protocols configured                                            │
│  ☐ Firewall rules created                                                  │
│  ☐ Service accounts properly configured                                    │
│  ☐ Authentication mode set appropriately                                   │
│                                                                             │
│  SECURITY:                                                                  │
│  ☐ Strong SA password set (if using SQL Authentication)                    │
│  ☐ Unnecessary features disabled                                           │
│  ☐ Appropriate administrator accounts configured                           │
│  ☐ Audit settings configured                                               │
│                                                                             │
│  MAINTENANCE:                                                               │
│  ☐ Basic backup strategy implemented                                       │
│  ☐ Update strategy planned                                                 │
│  ☐ Monitoring baseline established                                         │
│                                                                             │
│  DOCUMENTATION:                                                             │
│  ☐ Installation settings documented                                        │
│  ☐ Service account information recorded                                    │
│  ☐ Network configuration documented                                        │
│  ☐ Security settings documented                                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Summary

### Key Takeaways for SQL Server 2016 Installation

1. **Pre-Installation Planning**
   - Verify system requirements thoroughly
   - Plan service accounts and authentication modes
   - Prepare directory structure and security

2. **Edition Selection for Learning**
   - Developer Edition: Best for learning all features (FREE)
   - Express Edition: Good for basic learning (FREE, 10GB limit)
   - Evaluation Edition: Full features for 180 days

3. **Installation Best Practices**
   - Use default instance for simplicity
   - Configure mixed authentication mode for flexibility
   - Set strong passwords and proper service accounts
   - Plan data file locations for performance

4. **Post-Installation Configuration**
   - Verify installation with test scripts
   - Configure network and firewall settings
   - Implement basic security hardening
   - Set up monitoring and maintenance

5. **Security Considerations**
   - Change default passwords immediately
   - Disable unnecessary features and accounts
   - Configure appropriate audit settings
   - Plan network security measures

6. **Ongoing Maintenance**
   - Implement backup strategy immediately
   - Plan for updates and patches
   - Monitor performance and security
   - Document all configurations

### Next Steps After Installation
- Complete Module 1 Lab exercises
- Practice connecting with SSMS (Lesson 3)
- Begin T-SQL learning with Module 2
- Set up sample databases for practice

This installation provides the foundation for all subsequent SQL Server 2016 learning and development activities in this course.

## Learning Objectives
- Understand SQL Server 2016 installation requirements and prerequisites
- Learn step-by-step installation process on Windows Server
- Configure SQL Server 2016 for optimal performance and security
- Understand licensing options and where to obtain trial/community editions
- Troubleshoot common installation issues

## Overview
This lesson provides a comprehensive guide to installing SQL Server 2016 on Windows Server, including preparation, installation steps, post-installation configuration, and licensing considerations. We'll focus on using free editions (Express, Developer) and trial versions suitable for learning and development.

## 4.1 Pre-Installation Planning

### Installation Requirements Checklist
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SQL SERVER 2016 INSTALLATION CHECKLIST                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  HARDWARE REQUIREMENTS:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ☐ Processor: x64-based, 1.4 GHz minimum (2.0 GHz recommended)         │
│  │ ☐ Memory: 1 GB minimum (4 GB+ recommended for production)              │
│  │ ☐ Hard Disk: 6 GB minimum (20 GB+ recommended)                         │
│  │ ☐ Available disk space for databases and logs                          │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SOFTWARE REQUIREMENTS:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ☐ Windows Server 2008 R2 SP1 or later                                 │
│  │ ☐ .NET Framework 4.6 or later                                          │
│  │ ☐ Windows PowerShell 2.0 or later                                      │
│  │ ☐ Latest Windows Updates installed                                      │
│  │ ☐ Windows Installer 4.5 or later                                       │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  NETWORK REQUIREMENTS:                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ☐ TCP/IP protocol enabled                                              │
│  │ ☐ Firewall configured for SQL Server ports                             │
│  │ ☐ Domain/Workgroup configuration planned                               │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SECURITY PLANNING:                                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ ☐ Service accounts planned (domain or built-in)                        │
│  │ ☐ Authentication mode decided (Windows/Mixed)                          │
│  │ ☐ SA password planned (if using SQL authentication)                    │
│  │ ☐ SQL Server administrators identified                                 │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### System Configuration Check
```powershell
# PowerShell script to check system readiness
# Run as Administrator on target Windows Server

Write-Host "=== SQL Server 2016 Pre-Installation Check ===" -ForegroundColor Green

# Check OS Version
$OS = Get-WmiObject -Class Win32_OperatingSystem
Write-Host "Operating System: $($OS.Caption) $($OS.Version)" -ForegroundColor Yellow

# Check Architecture
if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
    Write-Host "✓ 64-bit Architecture: Supported" -ForegroundColor Green
} else {
    Write-Host "✗ 32-bit Architecture: NOT Supported" -ForegroundColor Red
}

# Check Memory
$Memory = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
Write-Host "Physical Memory: $Memory GB" -ForegroundColor Yellow
if ($Memory -ge 4) {
    Write-Host "✓ Memory: Adequate for production" -ForegroundColor Green
} elseif ($Memory -ge 1) {
    Write-Host "⚠ Memory: Minimum requirement met, consider upgrade" -ForegroundColor Yellow
} else {
    Write-Host "✗ Memory: Below minimum requirement" -ForegroundColor Red
}

# Check Disk Space
$Disk = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
foreach ($Drive in $Disk) {
    $FreeGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
    Write-Host "Drive $($Drive.DeviceID) Free Space: $FreeGB GB" -ForegroundColor Yellow
    if ($FreeGB -ge 20) {
        Write-Host "✓ Disk Space: Adequate" -ForegroundColor Green
    } elseif ($FreeGB -ge 6) {
        Write-Host "⚠ Disk Space: Minimum requirement met" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Disk Space: Insufficient" -ForegroundColor Red
    }
}

# Check .NET Framework
$NETVersion = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" -Name Release -ErrorAction SilentlyContinue
if ($NETVersion.Release -ge 393295) {
    Write-Host "✓ .NET Framework: 4.6+ Installed" -ForegroundColor Green
} else {
    Write-Host "✗ .NET Framework: 4.6+ Required" -ForegroundColor Red
}

# Check PowerShell Version
$PSVersion = $PSVersionTable.PSVersion.Major
if ($PSVersion -ge 2) {
    Write-Host "✓ PowerShell: Version $PSVersion" -ForegroundColor Green
} else {
    Write-Host "✗ PowerShell: Version 2.0+ Required" -ForegroundColor Red
}

Write-Host "=== Pre-Installation Check Complete ===" -ForegroundColor Green
```

## 4.2 Obtaining SQL Server 2016

### License Options and Download Sources

#### Free Editions for Learning and Development

**1. SQL Server 2016 Express Edition (FREE)**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SQL SERVER 2016 EXPRESS                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  FEATURES:                                                                  │
│  • Database Engine (10 GB database size limit)                             │
│  • SQL Server Management Studio                                            │
│  • Basic Reporting Services                                                │
│  • No licensing cost                                                       │
│                                                                             │
│  DOWNLOAD SOURCE:                                                           │
│  https://www.microsoft.com/en-us/sql-server/sql-server-downloads            │
│                                                                             │
│  VARIANTS:                                                                  │
│  • Express: Core database engine only                                      │
│  • Express with Tools: Includes SSMS                                       │
│  • Express with Advanced Services: Includes Reporting Services             │
│                                                                             │
│  BEST FOR:                                                                  │
│  • Learning SQL Server                                                     │
│  • Small applications                                                      │
│  • Development environments                                                │
│  • Proof of concepts                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**2. SQL Server 2016 Developer Edition (FREE)**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       SQL SERVER 2016 DEVELOPER                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  FEATURES:                                                                  │
│  • ALL Enterprise Edition features                                         │
│  • No production use licensing                                             │
│  • Unlimited database size                                                 │
│  • All advanced features (Always On, Partitioning, etc.)                  │
│                                                                             │
│  LICENSING:                                                                 │
│  • FREE for development and testing                                        │
│  • NOT licensed for production use                                         │
│  • Perfect for learning all SQL Server features                           │
│                                                                             │
│  DOWNLOAD SOURCE:                                                           │
│  https://www.microsoft.com/en-us/sql-server/sql-server-downloads            │
│  (Select "Developer" edition)                                              │
│                                                                             │
│  BEST FOR:                                                                  │
│  • Learning advanced SQL Server features                                   │
│  • Development environments                                                │
│  • Testing enterprise features                                             │
│  • Training and certification prep                                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**3. SQL Server 2016 Evaluation Edition (180-Day Trial)**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       SQL SERVER 2016 EVALUATION                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  FEATURES:                                                                  │
│  • ALL Enterprise Edition features                                         │
│  • 180-day trial period                                                    │
│  • Can be used in production during trial                                  │
│  • Automatically expires after 180 days                                   │
│                                                                             │
│  DOWNLOAD SOURCE:                                                           │
│  https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2016       │
│                                                                             │
│  CONVERSION OPTIONS:                                                        │
│  • Can upgrade to licensed edition                                         │
│  • Can downgrade to Express edition                                        │
│  • Data preserved during edition changes                                   │
│                                                                             │
│  BEST FOR:                                                                  │
│  • Evaluating enterprise features                                          │
│  • Short-term projects                                                     │
│  • Production evaluation                                                   │
│  • Proof of concept with full features                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Recommended Download for This Course
**For this training course, we recommend SQL Server 2016 Developer Edition:**
- All Enterprise features available
- Free for development and learning
- No limitations on database size or features
- Perfect for learning all SQL Server capabilities

## 4.3 Step-by-Step Installation Process

### Step 1: Download SQL Server 2016 Developer Edition

1. **Navigate to Microsoft Download Center**
   ```
   URL: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
   ```

2. **Select Developer Edition**
   - Click "Download now" under Developer section
   - File name: `SQLServer2016-SSEI-Dev.exe` (Web installer)
   - Or download full ISO: `SQLServer2016SP2-FullSlipstream-x64-ENU-DEV.iso`

3. **Download SQL Server Management Studio (SSMS) Separately**
   ```
   URL: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
   ```
   - SSMS is now a separate download starting with SQL Server 2016
   - Always download the latest version of SSMS

### Step 2: Prepare Windows Server Environment

```powershell
# Run these commands as Administrator on Windows Server

# 1. Enable .NET Framework 3.5 (if not already enabled)
Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All

# 2. Install .NET Framework 4.6+ (if not present)
# Download from: https://dotnet.microsoft.com/download/dotnet-framework

# 3. Ensure Windows Updates are current
Write-Host "Please ensure Windows Updates are installed before proceeding"

# 4. Create directories for SQL Server (optional but recommended)
New-Item -Path "C:\Program Files\Microsoft SQL Server" -ItemType Directory -Force
New-Item -Path "C:\SQLData" -ItemType Directory -Force
New-Item -Path "C:\SQLLogs" -ItemType Directory -Force
New-Item -Path "C:\SQLBackups" -ItemType Directory -Force

Write-Host "Environment preparation complete!" -ForegroundColor Green
```

### Step 3: Run SQL Server 2016 Installation

#### Installation Wizard Walkthrough

**1. Start the Installation**
```batch
:: If using web installer
SQLServer2016-SSEI-Dev.exe

:: If using ISO, mount and run
D:\Setup.exe
```

**2. Installation Center Welcome Screen**
- Select "Installation" from the left panel
- Choose "New SQL Server stand-alone installation or add features to an existing installation"

**3. Product Key**
- For Developer Edition: No product key required
- For Evaluation: Select "Specify a free edition" → "Evaluation"
- For Express: Select "Express" edition

**4. License Terms**
- Accept the Microsoft Software License Terms
- Check "I accept the license terms"
- Click "Next"

**5. Global Rules Check**
- Setup will automatically check system requirements
- Address any warnings or errors before proceeding
- Common issues and solutions:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        COMMON INSTALLATION ISSUES                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ISSUE: "Windows Management Framework" warning                             │
│  SOLUTION: Install PowerShell 3.0+                                         │
│                                                                             │
│  ISSUE: ".NET Framework" error                                             │
│  SOLUTION: Install .NET Framework 4.6+                                     │
│                                                                             │
│  ISSUE: "Windows Firewall" warning                                         │
│  SOLUTION: Configure firewall (can be done post-installation)              │
│                                                                             │
│  ISSUE: "Performance counter registry hive consistency" warning            │
│  SOLUTION: Can usually be ignored for development environments             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**6. Microsoft Update (Optional)**
- Choose whether to use Microsoft Update for SQL Server updates
- Recommended: Check "Use Microsoft Update to check for updates"

**7. Product Updates**
- Setup will check for available SQL Server updates
- Recommended: Include available updates

**8. Feature Selection**
Select the features you want to install:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           RECOMMENDED FEATURES                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  DATABASE ENGINE SERVICES (Required):                                      │
│  ☑ Database Engine Services                                               │
│                                                                             │
│  ANALYSIS SERVICES (Optional):                                             │
│  ☐ Analysis Services (for OLAP/Data Mining)                               │
│                                                                             │
│  REPORTING SERVICES (Recommended):                                         │
│  ☑ Reporting Services - Native                                            │
│                                                                             │
│  INTEGRATION SERVICES (Recommended):                                       │
│  ☑ Integration Services                                                    │
│                                                                             │
│  SHARED FEATURES:                                                           │
│  ☑ SQL Server Data Tools for Business Intelligence                        │
│  ☑ Client Tools Connectivity                                              │
│  ☑ Management Tools - Basic                                               │
│  ☑ Management Tools - Complete                                            │
│                                                                             │
│  INSTALLATION DIRECTORIES:                                                 │
│  Instance root directory: C:\Program Files\Microsoft SQL Server\          │
│  Shared feature directory: C:\Program Files\Microsoft SQL Server\         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**9. Instance Configuration**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         INSTANCE CONFIGURATION                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  INSTANCE TYPE:                                                             │
│  ● Default instance (recommended for first installation)                   │
│  ○ Named instance                                                          │
│                                                                             │
│  INSTANCE NAME: MSSQLSERVER (for default instance)                         │
│                                                                             │
│  INSTANCE ID: MSSQL16.MSSQLSERVER                                          │
│                                                                             │
│  INSTANCE ROOT DIRECTORY:                                                   │
│  C:\Program Files\Microsoft SQL Server\                                    │
│                                                                             │
│  NOTE: Use default instance for simplicity unless you need multiple        │
│        SQL Server instances on the same server                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**10. Server Configuration - Service Accounts**
Configure service accounts for SQL Server services:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SERVICE ACCOUNTS                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SERVICE                    │ ACCOUNT TYPE          │ STARTUP TYPE         │
│  ──────────────────────────┼──────────────────────┼─────────────────────┤
│  SQL Server Database Engine│ Virtual Account       │ Automatic            │
│                             │ NT SERVICE\MSSQLSERVER│                     │
│  ──────────────────────────┼──────────────────────┼─────────────────────┤
│  SQL Server Agent          │ Virtual Account       │ Automatic            │
│                             │ NT SERVICE\SQLSERVERAGENT                   │
│  ──────────────────────────┼──────────────────────┼─────────────────────┤
│  SQL Server Reporting      │ Virtual Account       │ Automatic            │
│  Services                   │ NT SERVICE\ReportServer                     │
│  ──────────────────────────┼──────────────────────┼─────────────────────┤
│  SQL Server Integration    │ Virtual Account       │ Manual               │
│  Services                   │ NT SERVICE\MsDtsServer130                   │
│                                                                             │
│  RECOMMENDATIONS:                                                           │
│  • Use Virtual Accounts for development/testing                            │
│  • Use Domain Accounts for production environments                         │
│  • Set Database Engine and Agent to Automatic startup                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**11. Database Engine Configuration**

**Authentication Mode:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        AUTHENTICATION CONFIGURATION                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  AUTHENTICATION MODE:                                                       │
│  ● Mixed Mode (SQL Server authentication and Windows authentication)      │
│  ○ Windows authentication mode                                             │
│                                                                             │
│  REASONING FOR MIXED MODE:                                                  │
│  • Allows both Windows and SQL Server logins                              │
│  • More flexible for development and testing                               │
│  • Required for some applications                                          │
│  • Can always disable SQL authentication later                             │
│                                                                             │
│  SA PASSWORD: [Create a strong password]                                   │
│  Example: SQLServer2016!Admin                                              │
│                                                                             │
│  PASSWORD REQUIREMENTS:                                                     │
│  • At least 8 characters                                                   │
│  • Mix of uppercase, lowercase, numbers, and symbols                       │
│  • Cannot contain the word "password" or user account name                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**SQL Server Administrators:**
```
Add Windows accounts/groups that should have sysadmin privileges:
• Current user (automatically added)
• Domain administrators (if domain-joined)
• Local administrators group

Example entries:
• DOMAIN\SQLAdmins (if using domain)
• SERVERNAME\Administrators (local group)
• Individual user accounts as needed
```

**Data Directories:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DATA DIRECTORIES                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  DEFAULT LOCATIONS (can be customized):                                    │
│                                                                             │
│  DATA ROOT DIRECTORY:                                                       │
│  C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL           │
│                                                                             │
│  USER DATABASE DIRECTORY:                                                   │
│  C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA      │
│                                                                             │
│  USER DATABASE LOG DIRECTORY:                                               │
│  C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA      │

