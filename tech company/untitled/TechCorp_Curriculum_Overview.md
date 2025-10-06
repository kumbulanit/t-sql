# TechCorp Solutions - Unified SQL Server 2016 Training Curriculum

## Overview
This comprehensive training program uses **TechCorp Solutions**, a fictional technology consulting company, to provide a consistent, progressive learning experience across all 7 modules. The curriculum demonstrates real-world business scenarios with increasing data complexity and advanced SQL Server features.

## Business Context: TechCorp Solutions
**TechCorp Solutions** is a mid-sized technology consulting firm specializing in digital transformation projects for enterprise clients across multiple industries. The company provides:
- Custom software development
- Cloud migration services
- Data analytics and business intelligence
- Cybersecurity assessments
- Enterprise system integration

## Progressive Complexity Design

### Data Complexity Progression
The TechCorp database demonstrates increasing complexity across modules:

**Modules 1-2 (Foundation)**: Simple lookup tables and basic relationships
- Countries, Industries, SkillCategories
- Basic data types: INT, NVARCHAR, BIT
- Simple primary/foreign key relationships

**Modules 3-4 (Intermediate)**: Business entities with moderate complexity
- Companies, Departments, Employees, Projects
- Geographic data (Latitude/Longitude)
- Financial data (Salaries, Budgets, Revenue)
- Hierarchical relationships (Manager-Employee, Department-Employee)

**Modules 5-7 (Advanced)**: Complex business scenarios
- Time tracking with temporal data
- Performance metrics with weighted calculations
- Multi-dimensional project assignments
- Advanced data types: DECIMAL(15,2), DATETIME2(3), hierarchical IDs

### Database Schema Evolution

#### Module 1: Architecture Foundation
```sql
-- Database creation with proper file structure
CREATE DATABASE TechCorpDB
-- Comprehensive schema with 12+ interconnected tables
-- Progressive ID ranges: Countries(1+), Companies(1001+), Employees(4001+)
```

#### Module 2: T-SQL Fundamentals
```sql
-- Core business queries using TechCorp data
SELECT * FROM Companies WHERE AnnualRevenue > 10000000;
SELECT * FROM Employees WHERE HireDate > '2020-01-01';
```

#### Module 3: Basic SELECT Operations
```sql
-- Column aliases and CASE expressions with TechCorp context
SELECT 
    FirstName + ' ' + LastName AS FullName,
    CASE 
        WHEN BaseSalary > 100000 THEN 'Senior Level'
        WHEN BaseSalary > 60000 THEN 'Mid Level'
        ELSE 'Junior Level'
    END AS SalaryBand
FROM Employees;
```

#### Module 4: Multi-Table Queries
```sql
-- Complex JOINs across TechCorp business entities
SELECT 
    c.CompanyName,
    d.DepartmentName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    p.ProjectName,
    ep.Role
FROM Companies c
    INNER JOIN Departments d ON c.CompanyID = d.CompanyID
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID;
```

#### Module 5: Sorting and Filtering
```sql
-- Advanced filtering with business logic
SELECT TOP 10 
    e.FirstName + ' ' + e.LastName AS TopPerformer,
    e.BaseSalary,
    pm.Achievement,
    jl.LevelName
FROM Employees e
    INNER JOIN PerformanceMetrics pm ON e.EmployeeID = pm.EmployeeID
    INNER JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
WHERE pm.Achievement > 95.0
    AND e.IsActive = 1
ORDER BY pm.Achievement DESC, e.BaseSalary DESC;
```

#### Module 6: Data Types
```sql
-- Complex data type scenarios with TechCorp business data
-- Financial precision: DECIMAL(15,2) for revenue, DECIMAL(10,2) for salaries
-- Geographic precision: DECIMAL(10,8) for latitude, DECIMAL(11,8) for longitude
-- Temporal precision: DATETIME2(3) for audit trails
-- Performance calculations with weighted metrics
```

#### Module 7: DML Operations
```sql
-- Complex INSERT/UPDATE/DELETE operations
-- Employee lifecycle management
-- Project assignment workflows
-- Performance metric calculations
-- Time tracking and billing scenarios
```

#### Module 8: Built-in Functions (🔴 EXPERT LEVEL)
```sql
-- Advanced string manipulation for data cleansing
-- Complex date/time calculations for business intelligence
-- Mathematical functions for financial analysis
-- Conversion functions for data integration
-- Logical functions for business rules
-- NULL handling for data quality
-- System functions for metadata and monitoring
```

#### Module 9: Grouping and Aggregating Data (🔴 EXPERT LEVEL)
```sql
-- Board-level financial performance reporting
-- Multi-dimensional business analysis
-- Statistical aggregations for executive decision-making
-- Complex GROUP BY strategies for business intelligence
-- Advanced HAVING clauses for sophisticated filtering
-- Performance metrics across departments, time periods, and client segments
-- Strategic KPI calculations for enterprise-scale operations
```

#### Module 9 Lab: Grouping and Aggregating (🔴 EXPERT LEVEL)
```sql
-- Capstone integration lab: Strategic Intelligence Command Center
-- Combines aggregate functions, GROUP BY, HAVING, and predictive analytics
-- Executive dashboards, competitive intelligence, and forecasting
-- Real-world business intelligence for board-level decision-making
-- Predictive analytics and risk assessment for strategic planning
-- Performance monitoring and opportunity identification
```

## Data Diversity Highlights

### Geographic Data
- Companies with latitude/longitude coordinates
- Multi-country operations (US, CA, UK, DE, AU, SG, JP, BR)
- Currency and timezone handling

### Financial Data
- Revenue ranges from $3.2M to $245M
- BaseSalary bands from $45K to $450K
- Budget allocations and cost center tracking
- Multi-currency support (USD, CAD, GBP, EUR, AUD, SGD, JPY, BRL)

### Temporal Data
- Employee hire dates spanning multiple years
- Project timelines with start/end dates
- Time tracking with minute-level precision
- Performance review cycles

### Hierarchical Data
- Employee-manager relationships
- Department-company relationships
- Project-assignment relationships
- Skill categorization and proficiency levels

### Performance Data
- Weighted performance metrics
- Achievement percentages with decimal precision
- Client and internal feedback scores
- Billable vs. non-billable hour tracking

## Learning Objectives Met

### Progressive SQL Skills Development
1. **Module 1**: Database architecture and file management
2. **Module 2**: Basic T-SQL syntax with business context
3. **Module 3**: SELECT statements with TechCorp reporting needs
4. **Module 4**: Complex joins for organizational reporting
5. **Module 5**: Advanced filtering for performance analysis
6. **Module 6**: Data type optimization for business requirements
7. **Module 7**: DML operations for business process automation

### Real-World Business Scenarios
- **Reporting**: Generate executive dashboards with company performance
- **Analytics**: Calculate employee productivity metrics
- **Operations**: Manage project assignments and resource allocation
- **Finance**: Track billing, budgets, and revenue recognition
- **HR**: Handle employee lifecycle and performance management

## Key Benefits of Unified Approach

### Consistency
- Same business context across all modules
- Familiar data relationships reduce cognitive load
- Progressive skill building on known datasets

### Relevance
- Real-world business scenarios
- Industry-standard data structures
- Practical query patterns used in actual consulting work

### Scalability
- Database grows in complexity across modules
- Advanced features build on foundational concepts
- Extensible for additional training modules

## Technical Implementation Notes

### Database Design Principles
- **Normalization**: Proper 3NF design with lookup tables
- **Constraints**: Foreign keys, check constraints, and unique indexes
- **Performance**: Strategic indexing on commonly queried columns
- **Audit Trail**: Created/Modified date and user tracking
- **Data Integrity**: Comprehensive referential integrity

### Sample Data Strategy
- **Volume**: Sufficient records to demonstrate query performance concepts
- **Variety**: Diverse data types and value ranges
- **Veracity**: Realistic business data that passes validation rules
- **Relationships**: Complex interconnections that mirror real-world scenarios

This unified TechCorp Solutions curriculum provides students with a comprehensive, progressive learning experience that builds from basic database concepts to advanced SQL Server 2016 features, all within the context of a realistic business scenario.