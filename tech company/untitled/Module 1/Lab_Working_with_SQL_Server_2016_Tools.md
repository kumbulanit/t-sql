# Lab: Working with SQL Server 2016 Tools - Building TechCorp Solutions Database

## 🎯 What You'll Learn Today
This is your first hands-on lab! You'll learn SQL Server basics while building a real database for **TechCorp Solutions**, a technology consulting company. Don't worry if you're new to databases - we'll start simple and explain everything step by step.

## 📖 Before We Start: Meet TechCorp Solutions

🏢 **TechCorp Solutions** is a fictional technology consulting company with 145 employees. They help other businesses build software, move to the cloud, and improve their technology. 

🎓 **Why learn with TechCorp?** Instead of using boring sample data, you'll work with realistic business information that tells a story. This makes SQL more interesting and prepares you for real-world work!

**What TechCorp does:**
- Builds websites and mobile apps for clients
- Helps companies move their data to the cloud  
- Creates reports and dashboards for business decisions
- Provides cybersecurity services
- Connects different business systems together

## 🎓 Your Learning Journey (Beginner to Expert)

### Module 1 (Today): Database Foundation 
**🟢 BEGINNER LEVEL** - Learn the basics of databases and SQL Server
- What is a database and why do we need one?
- How to create TechCorp's database structure
- Basic tools like SQL Server Management Studio

### Modules 2-3: Simple Queries
**🟢 STILL BEGINNER** - Learn to ask questions of your data
- "Who are all the employees?"
- "Which department does John work in?"
- "Show me all projects started this year"

### Modules 4-5: Connecting Information  
**🟡 GETTING INTERMEDIATE** - Learn to combine information from multiple places
- "Which employees work on which projects?"
- "Show me all projects and their managers"
- "List employees with their department and company info"

### Modules 6-7: Advanced Business Analysis
**🔴 BECOMING EXPERT** - Handle complex business scenarios
- Calculate employee performance ratings
- Track project profitability
- Generate executive reports with complex calculations

## 📋 Lab Overview
Today you'll create the foundation database that we'll use throughout the entire course. Think of it like building the foundation of a house - it needs to be strong and well-planned to support everything else.

**Prerequisites:**
- SQL Server 2016 (any edition) - your instructor will help if you need it
- SQL Server Management Studio (SSMS) - the main tool we'll use
- Basic computer skills (you've got this!)
- Willingness to learn (most important!)

**Estimated Time:** 3-4 hours (take breaks - learning takes time!)

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

## Part 1: Getting Started - Your First SQL Commands! 🚀

**🎓 BEGINNER TUTORIAL: Understanding What We're Doing**

Before we start building TechCorp's database, let's understand what SQL Server is and why businesses need it:

- **SQL Server** = A program that stores and manages business data (like a super-powered filing cabinet)
- **Database** = A collection of related information (like all of TechCorp's employee records)  
- **Query** = A question you ask the database (like "Who are our senior developers?")

### Exercise 1.1: Meet Your SQL Server (🟢 BEGINNER LEVEL)

**What you'll learn**: How to find out what version of SQL Server you're using

**Why this matters**: Different versions have different features, just like different versions of Windows or iPhone apps

**Step-by-Step Tutorial:**

1. **Open SQL Server Management Studio (SSMS)**
   - Look for the blue database icon in your Start menu
   - Connect to your server (usually called "localhost" or your computer name)

2. **Copy and paste this query into the query window:**

```sql
-- Lab 1.1.1: What version of SQL Server am I using?
-- Don't worry about memorizing this - focus on understanding what it shows you

SELECT 
    @@SERVERNAME as ServerName,              -- The name of your database server
    SERVERPROPERTY('Edition') as Edition,    -- What type: Express, Standard, Enterprise, etc.
    SERVERPROPERTY('ProductVersion') as Version; -- Version number (should be 13.x for SQL Server 2016)
```

3. **Press F5 or click Execute to run the query**

4. **Understanding Your Results:**
   - `ServerName`: Usually your computer name + \SQLEXPRESS or similar
   - `Edition`: Express (free), Developer (free), Standard (paid), Enterprise (expensive)
   - `Version`: Should start with "13" for SQL Server 2016

**💡 Beginner Tips**: 
   - If you see an error, ask your instructor for help - it's probably a connection issue
   - The query window is like a text editor where you type SQL commands
   - Results appear in the bottom panel after you run a query

**🎯 Success Check**: You should see results showing your server name and SQL Server 2016 (version 13.x)

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

### Exercise 1.2: Building TechCorp's Database (🟢 BEGINNER LEVEL)

**🎓 TUTORIAL: What is a Database?**

Think of a database like a digital filing cabinet for a business:
- **TechCorp** has 145 employees, multiple departments, and many projects
- Without a database, they'd have to store employee info in Excel files, project details in Word documents, etc.
- A database keeps everything organized and connected so you can easily find answers like "Which employees work on Project ABC?"

**What you'll learn**: How to create TechCorp's main database that will store all their business information

**Why this matters**: Every business application needs a database - this is like building the foundation of a house

**Step-by-Step Tutorial:**

1. **Understand what we're building:**
   - We're creating a database called "TechCorpDB" 
   - This will hold information about TechCorp's employees, projects, departments, and more
   - We'll use this same database throughout the entire course

2. **Copy and run this code to create TechCorp's database:**

```sql
-- Lab 1.2.1: Create TechCorp's main database
-- This is like creating a new filing cabinet for all of TechCorp's information

CREATE DATABASE TechCorpDB
ON 
(
    NAME = 'TechCorpDB_Data',
    FILENAME = 'C:\LabFiles\TechCorpDB.mdf',
    SIZE = 500MB,
    MAXSIZE = 2GB,
    FILEGROWTH = 100MB
),
(
    NAME = 'TechCorpDB_Data2',
    FILENAME = 'C:\LabFiles\TechCorpDB_Data2.ndf',
    SIZE = 200MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 50MB
)
LOG ON
(
    NAME = 'TechCorpDB_Log',
    FILENAME = 'C:\LabFiles\TechCorpDB.ldf',
    SIZE = 100MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 25MB
);
GO

-- Lab 1.2.2: Analyze TechCorp database file information
USE TechCorpDB;
GO

-- Create comprehensive schema foundation with diverse data types
-- This will support all modules with progressive complexity

-- 1. BASIC LOOKUP TABLES (Simple data - Module 1/2 level)
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY IDENTITY(1,1),
    CountryCode CHAR(2) NOT NULL UNIQUE,
    CountryName NVARCHAR(100) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    TimeZoneOffset DECIMAL(3,1) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Industries (
    IndustryID INT PRIMARY KEY IDENTITY(1,1),
    IndustryCode NVARCHAR(10) NOT NULL UNIQUE,
    IndustryName NVARCHAR(100) NOT NULL,
    IndustryDescription NVARCHAR(MAX) NULL,
    RiskLevel TINYINT NOT NULL DEFAULT 1, -- 1-5 scale
    RegulationLevel NVARCHAR(20) NOT NULL DEFAULT 'Standard'
);

CREATE TABLE SkillCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    CategoryDescription NVARCHAR(255) NULL,
    DifficultyLevel TINYINT NOT NULL DEFAULT 1, -- 1-5 scale
    MarketDemand DECIMAL(3,2) NOT NULL DEFAULT 1.00 -- demand multiplier
);

-- 2. CORE BUSINESS ENTITIES (Moderate complexity - Module 2/3 level)
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1001,1),
    CompanyName NVARCHAR(100) NOT NULL,
    LegalName NVARCHAR(150) NULL,
    TaxID NVARCHAR(20) NULL,
    IndustryID INT NOT NULL,
    CompanySize NVARCHAR(20) NOT NULL CHECK (CompanySize IN ('Startup', 'Small', 'Medium', 'Large', 'Enterprise')),
    FoundedYear SMALLINT NULL,
    AnnualRevenue DECIMAL(15,2) NULL,
    EmployeeCount INT NULL,
    Website NVARCHAR(255) NULL,
    PrimaryEmail NVARCHAR(100) NOT NULL,
    PrimaryPhone NVARCHAR(20) NULL,
    CountryID INT NOT NULL,
    StreetAddress NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    Latitude DECIMAL(10,8) NULL,
    Longitude DECIMAL(11,8) NULL,
    CreditRating CHAR(3) NULL, -- AAA, AA+, etc.
    PaymentTerms TINYINT NOT NULL DEFAULT 30, -- days
    PreferredCurrency CHAR(3) NOT NULL DEFAULT 'USD',
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (IndustryID) REFERENCES Industries(IndustryID),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(2001,1),
    CompanyID INT NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    DepartmentCode NVARCHAR(10) NOT NULL,
    ManagerEmployeeID INT NULL, -- Self-referencing, will be added later
    CostCenter NVARCHAR(20) NULL,
    Budget DECIMAL(12,2) NULL,
    BudgetPeriod NVARCHAR(20) NULL, -- 'Annual', 'Quarterly', etc.
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE JobLevels (
    JobLevelID INT PRIMARY KEY IDENTITY(3001,1),
    LevelName NVARCHAR(50) NOT NULL,
    LevelCode NVARCHAR(10) NOT NULL UNIQUE,
    MinSalary DECIMAL(10,2) NULL,
    MaxSalary DECIMAL(10,2) NULL,
    RequiredYearsExperience TINYINT NULL,
    AuthorityLevel TINYINT NOT NULL DEFAULT 1, -- 1-10 scale
    CanApproveExpenses BIT NOT NULL DEFAULT 0,
    MaxExpenseApproval DECIMAL(10,2) NULL
);

-- 3. MASTER DATA ENTITIES (Complex data - Module 3/4 level)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(4001,1),
    CompanyID INT NOT NULL,
    DepartmentID INT NOT NULL,
    JobLevelID INT NOT NULL,
    EmployeeNumber NVARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    PreferredName NVARCHAR(50) NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    DirectManagerID INT NULL, -- Self-referencing
    Email NVARCHAR(100) NOT NULL UNIQUE,
    WorkPhone NVARCHAR(20) NULL,
    MobilePhone NVARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    SalaryFrequency NVARCHAR(20) NOT NULL DEFAULT 'Annual',
    BonusTarget DECIMAL(5,2) NULL, -- percentage
    Commission DECIMAL(5,2) NULL, -- percentage
    EmploymentType NVARCHAR(20) NOT NULL DEFAULT 'Full-Time',
    WorkLocation NVARCHAR(100) NULL,
    TimeZone NVARCHAR(50) NULL,
    BirthDate DATE NULL,
    Gender CHAR(1) NULL CHECK (Gender IN ('M', 'F', 'O')),
    Nationality NVARCHAR(50) NULL,
    EmergencyContact NVARCHAR(100) NULL,
    EmergencyPhone NVARCHAR(20) NULL,
    BloodType CHAR(3) NULL,
    AllergiesNotes NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (JobLevelID) REFERENCES JobLevels(JobLevelID),
    FOREIGN KEY (DirectManagerID) REFERENCES Employees(EmployeeID)
);

-- Add the manager reference back to Departments now that Employees exists
ALTER TABLE Departments 
ADD CONSTRAINT FK_Departments_Manager 
FOREIGN KEY (ManagerEmployeeID) REFERENCES Employees(EmployeeID);

-- 4. SKILLS AND COMPETENCY TRACKING (Module 5/6 level complexity)
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(5001,1),
    CategoryID INT NOT NULL,
    SkillName NVARCHAR(100) NOT NULL,
    SkillDescription NVARCHAR(500) NULL,
    RequiredCertification NVARCHAR(200) NULL,
    MarketValue DECIMAL(8,2) NULL, -- daily rate premium
    DemandTrend NVARCHAR(20) NOT NULL DEFAULT 'Stable', -- Growing, Stable, Declining
    TechnologyStack NVARCHAR(200) NULL,
    YearsInMarket TINYINT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (CategoryID) REFERENCES SkillCategories(CategoryID)
);

CREATE TABLE EmployeeSkills (
    EmployeeSkillID INT PRIMARY KEY IDENTITY(6001,1),
    EmployeeID INT NOT NULL,
    SkillID INT NOT NULL,
    ProficiencyLevel TINYINT NOT NULL CHECK (ProficiencyLevel BETWEEN 1 AND 5),
    YearsExperience DECIMAL(3,1) NULL,
    LastUsedDate DATE NULL,
    CertificationDate DATE NULL,
    CertificationExpiry DATE NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    SelfAssessmentScore TINYINT NULL CHECK (SelfAssessmentScore BETWEEN 1 AND 10),
    ManagerAssessmentScore TINYINT NULL CHECK (ManagerAssessmentScore BETWEEN 1 AND 10),
    AssessmentDate DATE NULL,
    AssessmentNotes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID),
    UNIQUE (EmployeeID, SkillID)
);

-- 5. PROJECT AND ASSIGNMENT TRACKING (Module 7 level complexity)
CREATE TABLE ProjectTypes (
    ProjectTypeID INT PRIMARY KEY IDENTITY(7001,1),
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL,
    TypicalDurationMonths TINYINT NULL,
    ComplexityLevel TINYINT NOT NULL DEFAULT 1 CHECK (ComplexityLevel BETWEEN 1 AND 5),
    RequiredTeamSize TINYINT NULL,
    BudgetRange NVARCHAR(50) NULL
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(8001,1),
    CompanyID INT NOT NULL,
    ProjectTypeID INT NOT NULL,
    ProjectName NVARCHAR(200) NOT NULL,
    ProjectCode NVARCHAR(20) NOT NULL UNIQUE,
    ClientContactName NVARCHAR(100) NULL,
    ClientContactEmail NVARCHAR(100) NULL,
    ProjectManagerID INT NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Planning',
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium',
    StartDate DATE NOT NULL,
    PlannedEndDate DATE NOT NULL,
    ActualEndDate DATE NULL,
    Budget DECIMAL(12,2) NOT NULL,
    ActualCost DECIMAL(12,2) NULL,
    EstimatedHours DECIMAL(8,1) NULL,
    ActualHours DECIMAL(8,1) NULL,
    BillingType NVARCHAR(20) NOT NULL DEFAULT 'Fixed Price',
    HourlyRate DECIMAL(8,2) NULL,
    Currency CHAR(3) NOT NULL DEFAULT 'USD',
    RiskLevel TINYINT NOT NULL DEFAULT 1 CHECK (RiskLevel BETWEEN 1 AND 5),
    Description NVARCHAR(MAX) NULL,
    DeliveryAddress NVARCHAR(500) NULL,
    ContractSignedDate DATE NULL,
    WarrantyMonths TINYINT NULL DEFAULT 12,
    MaintenanceIncluded BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (ProjectTypeID) REFERENCES ProjectTypes(ProjectTypeID),
    FOREIGN KEY (ProjectManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE EmployeeProjects (
    AssignmentID INT PRIMARY KEY IDENTITY(9001,1),
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Role NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    AllocationPercentage DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    BillableRate DECIMAL(8,2) NULL,
    EstimatedHours DECIMAL(8,1) NULL,
    ActualHours DECIMAL(8,1) NULL,
    PerformanceRating TINYINT NULL CHECK (PerformanceRating BETWEEN 1 AND 5),
    IsLead BIT NOT NULL DEFAULT 0,
    ResponsibilityArea NVARCHAR(200) NULL,
    KeyAchievements NVARCHAR(MAX) NULL,
    ChallengesFaced NVARCHAR(MAX) NULL,
    ClientFeedbackScore TINYINT NULL CHECK (ClientFeedbackScore BETWEEN 1 AND 10),
    InternalFeedbackScore TINYINT NULL CHECK (InternalFeedbackScore BETWEEN 1 AND 10),
    IsActive BIT NOT NULL DEFAULT 1,
    AssignedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    AssignedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- 6. FINANCIAL AND PERFORMANCE TRACKING (Advanced Module 6/7 level)
CREATE TABLE TimeTracking (
    TimeEntryID INT PRIMARY KEY IDENTITY(10001,1),
    EmployeeID INT NOT NULL,
    ProjectID INT NULL,
    AssignmentID INT NULL,
    WorkDate DATE NOT NULL,
    StartTime TIME(0) NOT NULL,
    EndTime TIME(0) NULL,
    BreakMinutes SMALLINT NOT NULL DEFAULT 0,
    TotalHours DECIMAL(4,2) NOT NULL,
    BillableHours DECIMAL(4,2) NOT NULL DEFAULT 0,
    OvertimeHours DECIMAL(4,2) NOT NULL DEFAULT 0,
    WorkType NVARCHAR(50) NOT NULL DEFAULT 'Regular',
    Location NVARCHAR(100) NULL,
    TaskDescription NVARCHAR(500) NULL,
    IsApproved BIT NOT NULL DEFAULT 0,
    ApprovedBy INT NULL,
    ApprovedDate DATETIME2(3) NULL,
    SubmittedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AssignmentID) REFERENCES EmployeeProjects(AssignmentID),
    FOREIGN KEY (ApprovedBy) REFERENCES Employees(EmployeeID)
);

CREATE TABLE PerformanceMetrics (
    MetricID INT PRIMARY KEY IDENTITY(11001,1),
    EmployeeID INT NOT NULL,
    MetricType NVARCHAR(50) NOT NULL,
    MetricName NVARCHAR(100) NOT NULL,
    TargetValue DECIMAL(10,2) NOT NULL,
    ActualValue DECIMAL(10,2) NULL,
    MeasurementUnit NVARCHAR(20) NULL,
    PeriodStart DATE NOT NULL,
    PeriodEnd DATE NOT NULL,
    Weight DECIMAL(3,2) NOT NULL DEFAULT 1.00, -- importance weighting
    Achievement DECIMAL(5,2) NULL, -- percentage achieved
    Comments NVARCHAR(MAX) NULL,
    ReviewedBy INT NULL,
    ReviewDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReviewedBy) REFERENCES Employees(EmployeeID)
);
GO

-- Lab 1.2.2: Analyze TechCorp database file information
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

-- Lab 1.2.3: Populate TechCorp database with realistic sample data
-- This data will be used across all modules to demonstrate progressive complexity

-- 1. BASIC REFERENCE DATA (Module 1/2 complexity)
INSERT INTO Countries (CountryCode, CountryName, CurrencyCode, TimeZoneOffset) VALUES
('US', 'United States', 'USD', -5.0),
('CA', 'Canada', 'CAD', -5.0),
('UK', 'United Kingdom', 'GBP', 0.0),
('DE', 'Germany', 'EUR', 1.0),
('AU', 'Australia', 'AUD', 10.0),
('SG', 'Singapore', 'SGD', 8.0),
('JP', 'Japan', 'JPY', 9.0),
('BR', 'Brazil', 'BRL', -3.0);

INSERT INTO Industries (IndustryCode, IndustryName, IndustryDescription, RiskLevel, RegulationLevel) VALUES
('TECH', 'Technology', 'Software development, IT services, digital transformation', 2, 'Standard'),
('FINC', 'Financial Services', 'Banking, insurance, investment services', 4, 'High'),
('HLTH', 'Healthcare', 'Hospitals, medical devices, pharmaceutical', 3, 'High'),
('MANU', 'Manufacturing', 'Industrial production, automotive, aerospace', 3, 'Standard'),
('RETL', 'Retail', 'Consumer goods, e-commerce, retail chains', 2, 'Standard'),
('ERGY', 'Energy', 'Oil, gas, renewable energy, utilities', 5, 'High'),
('EDUC', 'Education', 'Universities, training, e-learning platforms', 1, 'Standard'),
('GOVT', 'Government', 'Public sector, municipal services', 2, 'High');

INSERT INTO SkillCategories (CategoryName, CategoryDescription, DifficultyLevel, MarketDemand) VALUES
('Programming', 'Software development and coding skills', 3, 1.50),
('Project Management', 'Planning, coordination, and delivery management', 2, 1.25),
('Data Analysis', 'Statistics, reporting, and business intelligence', 3, 1.40),
('Cloud Technologies', 'AWS, Azure, Google Cloud platforms', 4, 1.75),
('Cybersecurity', 'Information security and risk management', 4, 1.60),
('Business Analysis', 'Requirements gathering and process optimization', 2, 1.20),
('DevOps', 'Continuous integration and deployment', 4, 1.65),
('UI/UX Design', 'User interface and user experience design', 3, 1.35);

-- 2. COMPANY DATA (Module 2/3 complexity with diverse data types)
INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
    AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
    StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
    CreditRating, PaymentTerms, PreferredCurrency) VALUES
('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
    15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
    '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
    'AA-', 30, 'USD'),
('Global Finance Corp', 'Global Finance Corporation Ltd.', 'GFC2015002', 2, 'Large', 2008,
    125000000.00, 850, 'www.globalfinancecorp.com', 'contact@globalfinancecorp.com', '+1-555-0200', 1,
    '500 Wall Street', 'New York', 'New York', '10005', 40.70589000, -74.00889000,
    'AAA', 15, 'USD'),
('HealthTech Innovations', 'HealthTech Innovations LLC', 'HTI2017003', 3, 'Medium', 2015,
    8750000.00, 95, 'www.healthtechinnovations.com', 'hello@healthtechinnovations.com', '+1-555-0300', 1,
    '2000 Medical Center Drive', 'Boston', 'Massachusetts', '02115', 42.33143000, -71.10611000,
    'A+', 45, 'USD'),
('AutoManu Systems', 'AutoManu Systems International Inc.', 'AMS2012004', 4, 'Large', 2005,
    89200000.00, 1200, 'www.automanusystems.com', 'sales@automanusystems.com', '+1-555-0400', 1,
    '1500 Industrial Parkway', 'Detroit', 'Michigan', '48201', 42.33143000, -83.04575000,
    'A', 60, 'USD'),
('RetailMax Solutions', 'RetailMax Solutions Corp.', 'RMS2018005', 5, 'Small', 2018,
    3200000.00, 45, 'www.retailmaxsolutions.com', 'support@retailmaxsolutions.com', '+1-555-0500', 1,
    '800 Commerce Street', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
    'BBB+', 30, 'USD'),
('EnerTech Global', 'EnerTech Global Ltd.', 'ETG2011006', 6, 'Enterprise', 2003,
    245000000.00, 2100, 'www.enertechglobal.com', 'info@enertechglobal.com', '+1-555-0600', 1,
    '3500 Energy Plaza', 'Houston', 'Texas', '77002', 29.76043000, -95.36980000,
    'AA', 30, 'USD');

INSERT INTO ProjectTypes (TypeName, Description, TypicalDurationMonths, ComplexityLevel, RequiredTeamSize, BudgetRange) VALUES
('Web Development', 'Custom web applications and e-commerce sites', 4, 2, 5, '$50K-$200K'),
('Enterprise Software', 'Large-scale business applications', 12, 4, 15, '$500K-$2M'),
('Mobile App', 'iOS and Android mobile applications', 6, 3, 4, '$75K-$300K'),
('Data Analytics', 'Business intelligence and reporting solutions', 8, 3, 8, '$100K-$500K'),
('Cloud Migration', 'Infrastructure modernization projects', 10, 4, 12, '$200K-$1M'),
('Cybersecurity', 'Security assessments and implementations', 6, 5, 6, '$150K-$600K'),
('System Integration', 'Connecting multiple business systems', 9, 4, 10, '$300K-$800K'),
('Digital Transformation', 'Comprehensive business process digitization', 18, 5, 20, '$1M-$5M');

INSERT INTO JobLevels (LevelName, LevelCode, MinSalary, MaxSalary, RequiredYearsExperience, 
    AuthorityLevel, CanApproveExpenses, MaxExpenseApproval) VALUES
('Junior', 'L1', 45000.00, 65000.00, 0, 1, 0, NULL),
('Intermediate', 'L2', 60000.00, 85000.00, 2, 2, 1, 500.00),
('Senior', 'L3', 80000.00, 120000.00, 5, 4, 1, 2000.00),
('Lead', 'L4', 110000.00, 160000.00, 8, 6, 1, 5000.00),
('Principal', 'L5', 150000.00, 220000.00, 12, 8, 1, 10000.00),
('Director', 'L6', 200000.00, 300000.00, 15, 9, 1, 25000.00),
('VP', 'L7', 275000.00, 450000.00, 18, 10, 1, 50000.00);

-- 3. ORGANIZATIONAL STRUCTURE (Module 3/4 complexity with relationships)
INSERT INTO Departments (CompanyID, DepartmentName, DepartmentCode, CostCenter, Budget, BudgetPeriod) VALUES
(1001, 'Engineering', 'ENG', 'CC-ENG-001', 2500000.00, 'Annual'),
(1001, 'Sales', 'SALES', 'CC-SALES-001', 800000.00, 'Annual'),
(1001, 'Marketing', 'MKT', 'CC-MKT-001', 450000.00, 'Annual'),
(1001, 'Human Resources', 'HR', 'CC-HR-001', 320000.00, 'Annual'),
(1001, 'Finance', 'FIN', 'CC-FIN-001', 280000.00, 'Annual'),
(1002, 'Investment Banking', 'IB', 'CC-IB-001', 15000000.00, 'Annual'),
(1002, 'Risk Management', 'RISK', 'CC-RISK-001', 2200000.00, 'Annual'),
(1002, 'Compliance', 'COMP', 'CC-COMP-001', 1800000.00, 'Annual'),
(1003, 'Research & Development', 'RND', 'CC-RND-001', 1200000.00, 'Annual'),
(1003, 'Clinical Affairs', 'CLIN', 'CC-CLIN-001', 950000.00, 'Annual');

INSERT INTO Skills (CategoryID, SkillName, SkillDescription, RequiredCertification, 
    MarketValue, DemandTrend, TechnologyStack, YearsInMarket) VALUES
(1, 'C# .NET', 'Microsoft .NET framework development', 'Microsoft Certified Developer', 
    650.00, 'Stable', '.NET Core, ASP.NET, Entity Framework', 15),
(1, 'Python', 'Python programming for web and data applications', 'Python Institute PCAP', 
    700.00, 'Growing', 'Django, Flask, NumPy, Pandas', 12),
(1, 'JavaScript', 'Frontend and backend JavaScript development', NULL, 
    600.00, 'Growing', 'React, Node.js, Vue, Angular', 25),
(2, 'Agile/Scrum', 'Agile project management methodologies', 'Certified Scrum Master', 
    550.00, 'Stable', 'Jira, Azure DevOps, Trello', 20),
(2, 'PMP', 'Project Management Professional practices', 'PMP Certification', 
    800.00, 'Stable', 'MS Project, Primavera, Smartsheet', 30),
(3, 'SQL Server', 'Microsoft SQL Server database management', 'MCSA SQL Server', 
    500.00, 'Stable', 'T-SQL, SSIS, SSRS, Power BI', 25),
(3, 'Tableau', 'Data visualization and business intelligence', 'Tableau Desktop Specialist', 
    650.00, 'Growing', 'Tableau Server, Prep, Online', 10),
(4, 'AWS', 'Amazon Web Services cloud platform', 'AWS Certified Solutions Architect', 
    950.00, 'Growing', 'EC2, S3, Lambda, RDS, CloudFormation', 15),
(4, 'Azure', 'Microsoft Azure cloud services', 'Azure Solutions Architect Expert', 
    900.00, 'Growing', 'App Service, SQL Database, Functions, DevOps', 12),
(5, 'Penetration Testing', 'Ethical hacking and security assessment', 'CEH, OSCP', 
    1200.00, 'Growing', 'Metasploit, Nmap, Wireshark, Burp Suite', 20);
GO
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
    JSON_VALUE(CustomerData, '$.name') as CustomerName,
    JSON_VALUE(CustomerData, '$.email') as Email,
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
    Department nvarchar(50) NOT NULL,
    BaseSalary decimal(10,2) NOT NULL,
    
    -- System versioning columns
    ValidFrom datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeInfo_History));

-- Insert and update data to see temporal features
INSERT INTO EmployeeInfo (EmployeeID, Name, Position, Department, BaseSalary)
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
    Email nvarchar(255) NOT NULL,
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
    Email nvarchar(255) UNIQUE NOT NULL,
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
    UnitPrice decimal(10,2) NOT NULL,
    UnitsInStock int DEFAULT 0,
    ReorderLevel int DEFAULT 10,
    Discontinued bit DEFAULT 0,
    
    INDEX IX_Products_Category (CategoryID),
    INDEX IX_Products_Price (UnitPrice)
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
    UnitPrice decimal(10,2) NOT NULL,
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
INSERT INTO HR.Employees (FirstName, LastName, Email, HireDate, BaseSalary)
VALUES 
('John', 'Doe', 'john.doe@company.com', '2024-01-15', 65000),
('Jane', 'Smith', 'jane.smith@company.com', '2024-02-01', 70000);

-- Compare current data with snapshot
SELECT 'Current Database' as Source, COUNT(*) as EmployeeCount
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
    INSERT INTO HR.Employees (FirstName, LastName, Email, HireDate, BaseSalary)
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
