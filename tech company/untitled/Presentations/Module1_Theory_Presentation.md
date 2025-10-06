# Module 1: SQL Server Basic Architecture - Theory Presentation

## Slide 1: Module Overview
**SQL Server 2016 Basic Architecture**
- Understanding SQL Server components and services
- Database file structure and organization
- Installation and configuration fundamentals
- SQL Server Management Studio (SSMS) introduction
- Best practices for SQL Server deployment

---

## Slide 2: What is SQL Server?
**Microsoft SQL Server 2016**
- Relational Database Management System (RDBMS)
- Enterprise-grade data platform
- Supports ACID transactions (Atomicity, Consistency, Isolation, Durability)
- Scalable from single-user to enterprise-wide deployments
- Integrated with Microsoft ecosystem

---

## Slide 3: SQL Server Architecture Components
**Core Components**
- **Database Engine**: Core relational database service
- **Analysis Services**: OLAP and data mining services
- **Reporting Services**: Report generation and delivery
- **Integration Services**: ETL (Extract, Transform, Load) tools
- **Master Data Services**: Master data management
- **Data Quality Services**: Data cleansing and matching

---

## Slide 4: Database Engine Architecture
**Database Engine Components**
- **Storage Engine**: Manages data files and memory
- **Query Processor**: Parses, optimizes, and executes queries
- **Transaction Manager**: Ensures ACID compliance
- **Lock Manager**: Controls concurrent access
- **Buffer Manager**: Manages memory allocation
- **Log Manager**: Handles transaction logging

---

## Slide 5: SQL Server Services
**Windows Services**
- **SQL Server (Instance Name)**: Main database engine service
- **SQL Server Agent**: Job scheduling and automation
- **SQL Server Browser**: Instance discovery service
- **SQL Server Integration Services**: SSIS service
- **SQL Server Analysis Services**: SSAS service
- **SQL Server Reporting Services**: SSRS service

---

## Slide 6: Database File Structure
**Physical File Types**
- **Primary Data File (.mdf)**: Contains startup information and data
- **Secondary Data Files (.ndf)**: Additional data storage (optional)
- **Transaction Log File (.ldf)**: Records all transactions
- **File Groups**: Logical grouping of database files
- **Pages**: 8KB storage units (fundamental storage unit)

---

## Slide 7: Database Components
**Logical Database Objects**
- **Tables**: Store data in rows and columns
- **Indexes**: Improve query performance
- **Views**: Virtual tables based on queries
- **Stored Procedures**: Precompiled SQL code
- **Functions**: Return values based on input parameters
- **Triggers**: Execute automatically on data changes

---

## Slide 8: SQL Server Editions
**Edition Comparison**
- **Enterprise**: Full features, unlimited scale
- **Standard**: Core features, limited scale
- **Web**: Web hosting optimized
- **Express**: Free, limited features
- **Developer**: Full features, development only
- **Compact**: Embedded database engine

---

## Slide 9: Memory Architecture
**Memory Management**
- **Buffer Pool**: Caches data pages in memory
- **Plan Cache**: Stores compiled query execution plans
- **Log Cache**: Buffers transaction log records
- **Connection Memory**: Per-connection memory allocation
- **Lock Memory**: Memory for locking mechanisms
- **Thread Memory**: Memory for worker threads

---

## Slide 10: Security Architecture
**Security Layers**
- **Windows Authentication**: Uses Windows credentials
- **SQL Server Authentication**: SQL Server-specific logins
- **Database Roles**: Group permissions for easy management
- **Schema-level Security**: Object-level permissions
- **Row-level Security**: Filter data by user context
- **Encryption**: Data protection at rest and in transit

---

## Slide 11: Transaction Processing
**ACID Properties**
- **Atomicity**: All or nothing transaction execution
- **Consistency**: Database remains in valid state
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed changes persist permanently

**Transaction Isolation Levels**
- Read Uncommitted, Read Committed, Repeatable Read, Serializable

---

## Slide 12: Backup and Recovery
**Recovery Models**
- **Full**: Complete backup and point-in-time recovery
- **Bulk-Logged**: Optimized for bulk operations
- **Simple**: No transaction log backups

**Backup Types**
- Full, Differential, Transaction Log backups
- File and Filegroup backups

---

## Slide 13: SQL Server Tools
**Management Tools**
- **SQL Server Management Studio (SSMS)**: Primary management interface
- **SQL Server Configuration Manager**: Service and network configuration
- **SQL Server Profiler**: Performance monitoring and auditing
- **Database Engine Tuning Advisor**: Performance optimization
- **SQL Server Data Tools (SSDT)**: Development environment

---

## Slide 14: High Availability Options
**HA/DR Solutions**
- **Always On Availability Groups**: Automatic failover clustering
- **Failover Cluster Instances**: Shared storage clustering
- **Database Mirroring**: Real-time database copy (deprecated)
- **Log Shipping**: Automated backup/restore process
- **Replication**: Data distribution across servers

---

## Slide 15: Performance Monitoring
**Key Performance Metrics**
- **CPU Utilization**: Processor usage by SQL Server
- **Memory Usage**: Buffer hit ratio and memory pressure
- **Disk I/O**: Read/write operations and latency
- **Wait Statistics**: Bottleneck identification
- **Query Execution Plans**: Optimization analysis
- **Index Usage**: Index effectiveness monitoring

---

## Slide 16: Best Practices
**Installation and Configuration**
- Separate system and data drives
- Proper memory allocation (leave memory for OS)
- Configure appropriate recovery model
- Regular maintenance plan implementation
- Security hardening following Microsoft guidelines
- Regular backup and restore testing

---

## Slide 17: Common Maintenance Tasks
**Regular Maintenance**
- **Index Maintenance**: Rebuild/reorganize fragmented indexes
- **Statistics Updates**: Keep query optimizer statistics current
- **Database Consistency Checks**: DBCC CHECKDB
- **Backup Verification**: Test backup integrity
- **Log File Management**: Control transaction log growth
- **Space Management**: Monitor database growth

---

## Slide 18: Troubleshooting Approach
**Problem Resolution Process**
1. **Identify Symptoms**: Performance issues, errors, failures
2. **Gather Information**: Error logs, performance counters
3. **Analyze Data**: Identify root cause
4. **Implement Solution**: Apply appropriate fix
5. **Monitor Results**: Verify problem resolution
6. **Document Changes**: Maintain change log

---

## Slide 19: Learning Objectives Achieved
**Module 1 Outcomes**
✅ Understand SQL Server architecture components
✅ Identify different SQL Server services and their roles
✅ Explain database file structure and organization
✅ Navigate SQL Server Management Studio effectively
✅ Apply security best practices
✅ Implement basic maintenance procedures

---

## Slide 20: Next Steps
**Module 2 Preview: Introduction to T-SQL Querying**
- T-SQL language fundamentals
- Understanding database sets and logic
- Query structure and syntax
- Logical order of operations
- Hands-on query development

**Key Preparation**
- Ensure SQL Server 2016 installation is complete
- Verify SSMS connectivity
- Review database concepts and terminology