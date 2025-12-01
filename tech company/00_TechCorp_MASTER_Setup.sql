-- =============================================
-- TechCorp Database: Complete Setup Script for SSMS
-- All components combined into a single executable script
-- =============================================

USE master;
GO

PRINT '==============================================';
PRINT 'TechCorp Database Setup - Combined Script';
PRINT 'This script will create and populate the complete TechCorp database';
PRINT '==============================================';
PRINT '';

-- =============================================
-- STEP 1: DATABASE CREATION
-- =============================================
PRINT 'Step 1: Creating TechCorp database...';

-- Drop database if exists (for clean setup)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'Dropping existing TechCorpDB database...';
    ALTER DATABASE TechCorpDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechCorpDB;
END

-- Create new database (using default file locations)
PRINT 'Creating TechCorpDB database...';
CREATE DATABASE TechCorpDB;

-- Verify database creation
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'TechCorpDB database created successfully.';
END
ELSE
BEGIN
    PRINT 'ERROR: Failed to create TechCorpDB database.';
    PRINT 'Please check your SQL Server permissions and try again.';
    RETURN;
END
GO

-- Switch to the new database
USE TechCorpDB;
GO

-- Verify we're in the correct database
IF DB_NAME() = 'TechCorpDB'
BEGIN
    PRINT 'Successfully connected to TechCorpDB database.';
END
ELSE
BEGIN
    PRINT 'ERROR: Could not connect to TechCorpDB database.';
    RETURN;
END

-- =============================================
-- STEP 2: DROP EXISTING TABLES (Complete Clean Setup)
-- =============================================
PRINT 'Step 2: Dropping ALL existing tables for complete clean setup...';

-- Drop all tables in reverse dependency order to avoid foreign key constraint errors

-- Drop advanced/junction tables first
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'TimeTracking')
BEGIN
    DROP TABLE TimeTracking;
    PRINT '✓ Dropped TimeTracking table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PerformanceMetrics')
BEGIN
    DROP TABLE PerformanceMetrics;
    PRINT '✓ Dropped PerformanceMetrics table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'DepartmentHistory')
BEGIN
    DROP TABLE DepartmentHistory;
    PRINT '✓ Dropped DepartmentHistory table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeArchive')
BEGIN
    DROP TABLE EmployeeArchive;
    PRINT '✓ Dropped EmployeeArchive table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductSuppliers')
BEGIN
    DROP TABLE ProductSuppliers;
    PRINT '✓ Dropped ProductSuppliers table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderDetails')
BEGIN
    DROP TABLE OrderDetails;
    PRINT '✓ Dropped OrderDetails table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    DROP TABLE Orders;
    PRINT '✓ Dropped Orders table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    DROP TABLE Products;
    PRINT '✓ Dropped Products table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
BEGIN
    DROP TABLE Suppliers;
    PRINT '✓ Dropped Suppliers table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
BEGIN
    DROP TABLE Customers;
    PRINT '✓ Dropped Customers table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeProjects')
BEGIN
    DROP TABLE EmployeeProjects;
    PRINT '✓ Dropped EmployeeProjects table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeSkills')
BEGIN
    DROP TABLE EmployeeSkills;
    PRINT '✓ Dropped EmployeeSkills table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Projects')
BEGIN
    DROP TABLE Projects;
    PRINT '✓ Dropped Projects table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProjectTypes')
BEGIN
    DROP TABLE ProjectTypes;
    PRINT '✓ Dropped ProjectTypes table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Skills')
BEGIN
    DROP TABLE Skills;
    PRINT '✓ Dropped Skills table';
END

-- Drop core business tables
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Employees')
BEGIN
    DROP TABLE Employees;
    PRINT '✓ Dropped Employees table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Departments')
BEGIN
    DROP TABLE Departments;
    PRINT '✓ Dropped Departments table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Companies')
BEGIN
    DROP TABLE Companies;
    PRINT '✓ Dropped Companies table';
END

-- Drop lookup tables
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'JobLevels')
BEGIN
    DROP TABLE JobLevels;
    PRINT '✓ Dropped JobLevels table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SkillCategories')
BEGIN
    DROP TABLE SkillCategories;
    PRINT '✓ Dropped SkillCategories table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Industries')
BEGIN
    DROP TABLE Industries;
    PRINT '✓ Dropped Industries table';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Countries')
BEGIN
    DROP TABLE Countries;
    PRINT '✓ Dropped Countries table';
END

PRINT 'ALL existing tables dropped successfully.';
PRINT 'Database is now completely clean and ready for fresh setup.';
PRINT '';

-- =============================================
-- STEP 3: TABLE CREATION
-- =============================================
PRINT 'Step 3: Creating database tables...';

-- LOOKUP TABLES (Module 1 level)
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY IDENTITY(1,1),
    CountryName NVARCHAR(100) NOT NULL UNIQUE,
    CountryCode CHAR(2) NOT NULL UNIQUE,
    Region NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Industries (
    IndustryID INT PRIMARY KEY IDENTITY(1,1),
    IndustryName NVARCHAR(100) NOT NULL UNIQUE,
    IndustryCode NVARCHAR(10) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE SkillCategories (
    SkillCategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE JobLevels (
    JobLevelID INT PRIMARY KEY IDENTITY(1,1),
    LevelName NVARCHAR(50) NOT NULL UNIQUE,
    LevelCode NVARCHAR(10) NOT NULL UNIQUE,
    MinSalary DECIMAL(10,2) NULL,
    MaxSalary DECIMAL(10,2) NULL,
    Description NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- CORE BUSINESS ENTITIES (Module 2/3 level)
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
    CreditRating NVARCHAR(3) NULL,
    PaymentTerms TINYINT NOT NULL DEFAULT 30,
    PreferredCurrency NVARCHAR(3) NOT NULL DEFAULT 'USD',
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
    ManagerEmployeeID INT NULL,
    Budget DECIMAL(12,2) NULL,
    BudgetPeriod NVARCHAR(20) NULL CHECK (BudgetPeriod IN ('Annual', 'Quarterly', 'Monthly')),
    CostCenter NVARCHAR(20) NULL,
    Location NVARCHAR(100) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(3001,1),
    CompanyID INT NOT NULL,
    DepartmentID INT NOT NULL,
    JobLevelID INT NOT NULL,
    EmployeeNumber NVARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    ReportsToEmployeeID INT NULL,
    ManagerID INT NULL, -- Alias for ReportsToEmployeeID for training compatibility
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    BonusTarget DECIMAL(10,2) NULL,
    CommissionRate DECIMAL(5,4) NULL,
    BonusEligible BIT NOT NULL DEFAULT 1,
    EmploymentType NVARCHAR(20) NULL CHECK (EmploymentType IN ('Full-Time', 'Part-Time', 'Contract', 'Temporary', 'Intern')),
    WorkEmail NVARCHAR(100) NOT NULL UNIQUE,
    WorkPhone NVARCHAR(20) NULL,
    Phone NVARCHAR(20) NULL, -- Alias for WorkPhone for training compatibility
    PersonalEmail NVARCHAR(100) NULL,
    PersonalPhone NVARCHAR(20) NULL,
    BirthDate DATE NULL,
    Gender CHAR(1) NULL CHECK (Gender IN ('M', 'F', 'N')),
    Nationality NVARCHAR(50) NULL,
    MaritalStatus CHAR(1) NULL CHECK (MaritalStatus IN ('S', 'M', 'D', 'W')),
    EmergencyContact NVARCHAR(100) NULL,
    EmergencyPhone NVARCHAR(20) NULL,
    StreetAddress NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    CountryID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (JobLevelID) REFERENCES JobLevels(JobLevelID),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID),
    FOREIGN KEY (ReportsToEmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

PRINT 'Core tables created successfully.';

-- =============================================
-- STEP 4: CLEAR EXISTING DATA (Complete Clean Data)
-- =============================================
PRINT 'Step 4: Clearing any existing data from tables...';

-- Clear all data from tables (in case tables exist but weren't dropped)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'TimeTracking')
    TRUNCATE TABLE TimeTracking;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PerformanceMetrics')
    DELETE FROM PerformanceMetrics;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'DepartmentHistory')
    DELETE FROM DepartmentHistory;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeArchive')
    DELETE FROM EmployeeArchive;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductSuppliers')
    TRUNCATE TABLE ProductSuppliers;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderDetails')
    TRUNCATE TABLE OrderDetails;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
    DELETE FROM Orders;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
    DELETE FROM Products;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
    DELETE FROM Suppliers;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
    DELETE FROM Customers;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeProjects')
    TRUNCATE TABLE EmployeeProjects;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeSkills')
    TRUNCATE TABLE EmployeeSkills;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Projects')
    DELETE FROM Projects;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProjectTypes')
    DELETE FROM ProjectTypes;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Skills')
    DELETE FROM Skills;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Employees')
    DELETE FROM Employees;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Departments')
    DELETE FROM Departments;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Companies')
    DELETE FROM Companies;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'JobLevels')
    DELETE FROM JobLevels;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SkillCategories')
    DELETE FROM SkillCategories;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Industries')
    DELETE FROM Industries;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Countries')
    DELETE FROM Countries;

PRINT 'All existing data cleared successfully.';
PRINT '';

-- =============================================
-- STEP 5: LOOKUP DATA POPULATION
-- =============================================
PRINT 'Step 5: Populating lookup tables with fresh data...';

-- Countries data
INSERT INTO Countries (CountryName, CountryCode, Region) VALUES
('United States', 'US', 'North America'),
('Canada', 'CA', 'North America'),
('United Kingdom', 'GB', 'Europe'),
('Germany', 'DE', 'Europe'),
('France', 'FR', 'Europe'),
('Japan', 'JP', 'Asia Pacific'),
('Singapore', 'SG', 'Asia Pacific'),
('Australia', 'AU', 'Asia Pacific'),
('Brazil', 'BR', 'South America'),
('India', 'IN', 'Asia Pacific');

-- Industries data
INSERT INTO Industries (IndustryName, IndustryCode, Description) VALUES
('Technology', 'TECH', 'Software development, IT services, and technology consulting'),
('Financial Services', 'FINSERV', 'Banking, insurance, investment, and financial consulting'),
('Healthcare', 'HEALTH', 'Medical devices, pharmaceuticals, and healthcare services'),
('Manufacturing', 'MANUF', 'Industrial manufacturing, automotive, and production'),
('Retail', 'RETAIL', 'Consumer goods, e-commerce, and retail services'),
('Energy', 'ENERGY', 'Oil, gas, renewable energy, and utilities'),
('Education', 'EDUC', 'Educational institutions, training, and e-learning');

-- Skill Categories data
INSERT INTO SkillCategories (CategoryName, Description) VALUES
('Technical', 'Programming, database, and technical skills'),
('Leadership', 'Management and leadership capabilities'),
('Communication', 'Written and verbal communication skills'),
('Analytical', 'Data analysis and problem-solving skills'),
('Project Management', 'Project planning and execution skills'),
('Domain Expertise', 'Industry-specific knowledge and expertise');

-- Job Levels data
INSERT INTO JobLevels (LevelName, LevelCode, MinSalary, MaxSalary, Description) VALUES
('Executive', 'EXEC', 150000.00, 500000.00, 'C-level executives and senior leadership'),
('Senior Management', 'SRMGMT', 100000.00, 200000.00, 'Directors and senior managers'),
('Management', 'MGMT', 70000.00, 130000.00, 'Team leads and middle management'),
('Senior Professional', 'SRPROF', 80000.00, 150000.00, 'Senior individual contributors'),
('Professional', 'PROF', 50000.00, 100000.00, 'Mid-level professionals'),
('Associate', 'ASSOC', 35000.00, 70000.00, 'Junior professionals and associates'),
('Entry Level', 'ENTRY', 25000.00, 50000.00, 'New graduates and entry-level positions');

PRINT 'Lookup data populated successfully.';

-- =============================================
-- STEP 6: COMPANIES DATA
-- =============================================
PRINT 'Step 6: Populating companies data...';

INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
    AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
    StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
    CreditRating, PaymentTerms, PreferredCurrency) VALUES

-- Technology Companies
('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
    15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
    '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
    'AA-', 30, 'USD'),

('CloudTech Innovations', 'CloudTech Innovations LLC', 'CTI2018002', 1, 'Small', 2018,
    4200000.00, 65, 'www.cloudtechinnovations.com', 'hello@cloudtechinnovations.com', '+1-555-0150', 1,
    '800 Cloud Avenue', 'Seattle', 'Washington', '98101', 47.60621000, -122.33207000,
    'A+', 30, 'USD'),

('DevOps Masters', 'DevOps Masters Corporation', 'DOM2015003', 1, 'Medium', 2015,
    8750000.00, 95, 'www.devopsmasters.com', 'contact@devopsmasters.com', '+1-555-0175', 1,
    '500 Automation Boulevard', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
    'A', 45, 'USD'),

-- Financial Services Companies
('Global Finance Corp', 'Global Finance Corporation Ltd.', 'GFC2015004', 2, 'Large', 2008,
    125000000.00, 850, 'www.globalfinancecorp.com', 'contact@globalfinancecorp.com', '+1-555-0200', 1,
    '500 Wall Street', 'New York', 'New York', '10005', 40.70589000, -74.00889000,
    'AAA', 15, 'USD'),

('Investment Partners LLC', 'Investment Partners LLC', 'IPL2012005', 2, 'Medium', 2012,
    45000000.00, 320, 'www.investmentpartners.com', 'info@investmentpartners.com', '+1-555-0250', 1,
    '200 Financial Plaza', 'Chicago', 'Illinois', '60601', 41.88425000, -87.63245000,
    'AA', 30, 'USD'),

-- Healthcare Companies
('HealthTech Innovations', 'HealthTech Innovations LLC', 'HTI2017006', 3, 'Medium', 2015,
    18750000.00, 185, 'www.healthtechinnovations.com', 'hello@healthtechinnovations.com', '+1-555-0300', 1,
    '900 Medical Center Drive', 'Boston', 'Massachusetts', '02101', 42.35843000, -71.06350000,
    'A+', 45, 'USD'),

('MedDevice Solutions', 'MedDevice Solutions Inc.', 'MDS2014007', 3, 'Large', 2014,
    75000000.00, 420, 'www.meddevicesolutions.com', 'sales@meddevicesolutions.com', '+1-555-0350', 1,
    '1500 Innovation Parkway', 'San Diego', 'California', '92101', 32.71533000, -117.15726000,
    'AA-', 60, 'USD'),

-- Manufacturing Companies
('AutoManu Systems', 'AutoManu Systems International Inc.', 'AMS2012008', 4, 'Large', 2005,
    189200000.00, 1200, 'www.automanusystems.com', 'sales@automanusystems.com', '+1-555-0400', 1,
    '2000 Industrial Boulevard', 'Detroit', 'Michigan', '48201', 42.33143000, -83.04575000,
    'A', 60, 'USD'),

('Precision Manufacturing', 'Precision Manufacturing Corp.', 'PMC2010009', 4, 'Medium', 2010,
    32000000.00, 285, 'www.precisionmfg.com', 'info@precisionmfg.com', '+1-555-0450', 1,
    '800 Manufacturing Way', 'Cleveland', 'Ohio', '44101', 41.49932000, -81.69436000,
    'A-', 45, 'USD'),

-- Retail Companies
('RetailMax Solutions', 'RetailMax Solutions LLC', 'RMS2016010', 5, 'Small', 2016,
    8200000.00, 95, 'www.retailmaxsolutions.com', 'support@retailmaxsolutions.com', '+1-555-0500', 1,
    '800 Commerce Street', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
    'B+', 30, 'USD'),

('E-Commerce Plus', 'E-Commerce Plus LLC', 'ECP2016011', 5, 'Medium', 2016,
    22500000.00, 165, 'www.ecommerceplus.com', 'hello@ecommerceplus.com', '+1-555-0550', 1,
    '1000 Digital Avenue', 'Portland', 'Oregon', '97201', 45.51179000, -122.67563000,
    'A-', 30, 'USD'),

-- Energy Company
('EnerTech Global', 'EnerTech Global Corporation', 'ETG2009012', 6, 'Enterprise', 2009,
    345000000.00, 2100, 'www.enertechglobal.com', 'info@enertechglobal.com', '+1-555-0600', 1,
    '3000 Energy Plaza', 'Houston', 'Texas', '77001', 29.76043000, -95.36980000,
    'AA', 30, 'USD'),

-- Education Company
('EduTech Solutions', 'EduTech Solutions Inc.', 'ETS2017013', 7, 'Medium', 2017,
    12500000.00, 125, 'www.edutechsolutions.com', 'contact@edutechsolutions.com', '+1-555-0700', 1,
    '400 Education Drive', 'Phoenix', 'Arizona', '85001', 33.44838000, -112.07404000,
    'A', 30, 'USD'),

-- International Companies
('Global Tech Europe', 'Global Tech Europe GmbH', 'GTE2013014', 1, 'Large', 2013,
    65000000.00, 480, 'www.globaltecheurope.com', 'info@globaltecheurope.com', '+49-30-555-0800', 4,
    'Alexanderplatz 1', 'Berlin', 'Berlin', '10178', 52.52000000, 13.40495000,
    'AA-', 30, 'EUR'),

('Asia Pacific Solutions', 'Asia Pacific Solutions Pte Ltd', 'APS2015015', 1, 'Medium', 2015,
    28000000.00, 195, 'www.asiapacificsolutions.com', 'hello@asiapacificsolutions.com', '+65-6555-0900', 7,
    '1 Raffles Place', 'Singapore', 'Singapore', '048616', 1.28967000, 103.85007000,
    'A+', 30, 'SGD');

PRINT 'Companies data populated successfully.';

-- =============================================
-- STEP 7: DEPARTMENTS DATA
-- =============================================
PRINT 'Step 7: Populating departments data...';

INSERT INTO Departments (CompanyID, DepartmentName, DepartmentCode, Budget, CostCenter, Location) VALUES
-- TechCorp Solutions Departments (CompanyID 1001)
(1001, 'Engineering', 'ENG', 2500000.00, 'CC-1001-ENG', 'San Francisco HQ'),
(1001, 'Sales', 'SALES', 1800000.00, 'CC-1001-SAL', 'San Francisco HQ'),
(1001, 'Marketing', 'MKT', 950000.00, 'CC-1001-MKT', 'San Francisco HQ'),
(1001, 'Human Resources', 'HR', 650000.00, 'CC-1001-HR', 'San Francisco HQ'),
(1001, 'Finance', 'FIN', 450000.00, 'CC-1001-FIN', 'San Francisco HQ'),

-- CloudTech Innovations Departments (CompanyID 1002)
(1002, 'Development', 'DEV', 1200000.00, 'CC-1002-DEV', 'Seattle Office'),
(1002, 'DevOps', 'OPS', 800000.00, 'CC-1002-OPS', 'Seattle Office'),
(1002, 'Sales', 'SALES', 650000.00, 'CC-1002-SAL', 'Seattle Office'),
(1002, 'Support', 'SUP', 420000.00, 'CC-1002-SUP', 'Seattle Office'),

-- DevOps Masters Departments (CompanyID 1003)
(1003, 'Consulting', 'CONS', 1650000.00, 'CC-1003-CON', 'Austin Office'),
(1003, 'Training', 'TRN', 950000.00, 'CC-1003-TRN', 'Austin Office'),
(1003, 'Sales', 'SALES', 750000.00, 'CC-1003-SAL', 'Austin Office'),
(1003, 'Operations', 'OPS', 580000.00, 'CC-1003-OPS', 'Austin Office'),

-- Global Finance Corp Departments (CompanyID 1004)
(1004, 'Investment Banking', 'IB', 15000000.00, 'CC-1004-IB', 'New York HQ'),
(1004, 'Risk Management', 'RISK', 8500000.00, 'CC-1004-RSK', 'New York HQ'),
(1004, 'Trading', 'TRADE', 12000000.00, 'CC-1004-TRD', 'New York HQ'),
(1004, 'Compliance', 'COMP', 3200000.00, 'CC-1004-CMP', 'New York HQ'),
(1004, 'Technology', 'TECH', 6800000.00, 'CC-1004-TCH', 'New York HQ'),

-- Investment Partners LLC Departments (CompanyID 1005)
(1005, 'Portfolio Management', 'PM', 5500000.00, 'CC-1005-PM', 'Chicago Office'),
(1005, 'Research', 'RES', 3200000.00, 'CC-1005-RES', 'Chicago Office'),
(1005, 'Client Services', 'CS', 2800000.00, 'CC-1005-CS', 'Chicago Office'),
(1005, 'Operations', 'OPS', 1850000.00, 'CC-1005-OPS', 'Chicago Office');

PRINT 'Departments data populated successfully.';

-- =============================================
-- STEP 8: EMPLOYEES DATA (LEADERSHIP)
-- =============================================
PRINT 'Step 8: Populating leadership employees...';

-- Insert leadership employees first (they don't report to anyone initially)
INSERT INTO Employees (CompanyID, DepartmentID, JobLevelID, EmployeeNumber, FirstName, LastName, 
    JobTitle, HireDate, BaseSalary, WorkEmail, WorkPhone, BirthDate, Gender, MaritalStatus, 
    StreetAddress, City, StateProvince, PostalCode, CountryID) VALUES

-- TechCorp Solutions Leadership
(1001, 2001, 1, 'TC001', 'Sarah', 'Johnson', 'Chief Executive Officer', '2010-03-15', 
    285000.00, 'sarah.johnson@techcorpsolutions.com', '+1-555-0101', '1975-08-22', 'F', 'M',
    '450 Pacific Heights', 'San Francisco', 'California', '94109', 1),
    
(1001, 2001, 2, 'TC002', 'Michael', 'Chen', 'Chief Technology Officer', '2010-04-01', 
    225000.00, 'michael.chen@techcorpsolutions.com', '+1-555-0102', '1978-11-15', 'M', 'M',
    '720 Mission Bay', 'San Francisco', 'California', '94158', 1),
    
(1001, 2002, 2, 'TC003', 'Jennifer', 'Davis', 'VP of Sales', '2010-06-15', 
    195000.00, 'jennifer.davis@techcorpsolutions.com', '+1-555-0103', '1980-03-08', 'F', 'S',
    '890 Russian Hill', 'San Francisco', 'California', '94133', 1),

-- CloudTech Innovations Leadership  
(1002, 2006, 1, 'CT001', 'David', 'Rodriguez', 'Chief Executive Officer', '2018-01-10',
    245000.00, 'david.rodriguez@cloudtechinnovations.com', '+1-555-0151', '1982-05-12', 'M', 'M',
    '1200 Capitol Hill', 'Seattle', 'Washington', '98102', 1),
    
(1002, 2006, 2, 'CT002', 'Lisa', 'Wang', 'VP of Engineering', '2018-02-01',
    185000.00, 'lisa.wang@cloudtechinnovations.com', '+1-555-0152', '1985-09-30', 'F', 'S',
    '800 Fremont', 'Seattle', 'Washington', '98103', 1),

-- Global Finance Corp Leadership
(1004, 2014, 1, 'GF001', 'Robert', 'Thompson', 'Chief Executive Officer', '2008-03-01',
    425000.00, 'robert.thompson@globalfinancecorp.com', '+1-555-0201', '1970-12-03', 'M', 'M',
    '875 Park Avenue', 'New York', 'New York', '10075', 1),
    
(1004, 2015, 2, 'GF002', 'Amanda', 'Foster', 'Chief Risk Officer', '2008-05-15',
    315000.00, 'amanda.foster@globalfinancecorp.com', '+1-555-0202', '1973-07-18', 'F', 'M',
    '920 Upper East Side', 'New York', 'New York', '10021', 1);

PRINT 'Leadership employees populated successfully.';

-- =============================================
-- STEP 8.5: SYNCHRONIZE ALIAS FIELDS FOR TRAINING COMPATIBILITY
-- =============================================
PRINT 'Step 8.5: Synchronizing alias fields for training compatibility...';

-- Update ManagerID to match ReportsToEmployeeID for all employees
UPDATE Employees 
SET ManagerID = ReportsToEmployeeID,
    Phone = WorkPhone; -- Synchronize Phone alias

-- Update department managers (some examples)
UPDATE Departments SET ManagerEmployeeID = 3001 WHERE DepartmentID = 2001; -- Sarah Johnson manages Engineering
UPDATE Departments SET ManagerEmployeeID = 3003 WHERE DepartmentID = 2002; -- Jennifer Davis manages Sales  
UPDATE Departments SET ManagerEmployeeID = 3004 WHERE DepartmentID = 2006; -- David Rodriguez manages Development
UPDATE Departments SET ManagerEmployeeID = 3006 WHERE DepartmentID = 2014; -- Robert Thompson manages Investment Banking

PRINT 'Alias fields synchronized successfully (ManagerID, Phone).';

-- =============================================
-- STEP 9: ADVANCED TABLES CREATION
-- =============================================
PRINT 'Step 9: Creating advanced tables...';

-- Skills table
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(1,1),
    SkillName NVARCHAR(100) NOT NULL UNIQUE,
    SkillCategoryID INT NOT NULL,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (SkillCategoryID) REFERENCES SkillCategories(SkillCategoryID)
);

-- Customers table (Missing but referenced in queries)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(4001,1),
    CompanyID INT NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerType NVARCHAR(20) NOT NULL CHECK (CustomerType IN ('Individual', 'Business', 'Enterprise', 'Government')),
    ContactFirstName NVARCHAR(50) NULL,
    ContactLastName NVARCHAR(50) NULL,
    ContactTitle NVARCHAR(100) NULL,
    PrimaryEmail NVARCHAR(100) NOT NULL,
    PrimaryPhone NVARCHAR(20) NULL,
    SecondaryPhone NVARCHAR(20) NULL,
    Website NVARCHAR(255) NULL,
    IndustryID INT NULL,
    CountryID INT NOT NULL,
    StreetAddress NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    CreditLimit DECIMAL(12,2) NULL,
    CurrentBalance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    PaymentTerms TINYINT NOT NULL DEFAULT 30,
    AccountStatus NVARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (AccountStatus IN ('Active', 'Inactive', 'Suspended', 'Closed')),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (IndustryID) REFERENCES Industries(IndustryID),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

-- Products/Services table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(6001,1),
    CompanyID INT NOT NULL,
    ProductName NVARCHAR(200) NOT NULL,
    ProductCode NVARCHAR(20) NOT NULL UNIQUE,
    ProductCategory NVARCHAR(50) NOT NULL,
    Description NVARCHAR(1000) NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Cost DECIMAL(10,2) NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    MinStockLevel INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(7001,1),
    CustomerID INT NOT NULL,
    CompanyID INT NOT NULL,
    OrderNumber NVARCHAR(20) NOT NULL UNIQUE,
    OrderDate DATE NOT NULL,
    RequiredDate DATE NULL,
    ShippedDate DATE NULL,
    OrderStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    SubTotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    TaxAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    ShippingCost DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Paid', 'Partial', 'Overdue')),
    PaymentMethod NVARCHAR(50) NULL,
    Notes NVARCHAR(500) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Order Details table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(5,4) NOT NULL DEFAULT 0.00,
    LineTotal AS (Quantity * UnitPrice * (1 - Discount)) PERSISTED,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Suppliers table (for supply chain queries)
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(8001,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100) NULL,
    ContactTitle NVARCHAR(50) NULL,
    PrimaryEmail NVARCHAR(100) NOT NULL,
    PrimaryPhone NVARCHAR(20) NULL,
    CountryID INT NOT NULL,
    StreetAddress NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    Website NVARCHAR(255) NULL,
    PaymentTerms TINYINT NOT NULL DEFAULT 30,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

-- Product Suppliers junction table
CREATE TABLE ProductSuppliers (
    ProductSupplierID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    SupplierID INT NOT NULL,
    SupplierProductCode NVARCHAR(50) NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    LeadTimeDays INT NOT NULL DEFAULT 7,
    MinOrderQuantity INT NOT NULL DEFAULT 1,
    IsPreferredSupplier BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    UNIQUE(ProductID, SupplierID)
);

-- Project Types table
CREATE TABLE ProjectTypes (
    ProjectTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(5001,1),
    CompanyID INT NOT NULL,
    ProjectName NVARCHAR(200) NOT NULL,
    ProjectCode NVARCHAR(20) NOT NULL UNIQUE,
    ProjectTypeID INT NOT NULL,
    ProjectManagerID INT NULL, -- Project manager (references Employees)
    StartDate DATE NOT NULL,
    PlannedEndDate DATE NULL,
    EndDate DATE NULL, -- Alias for PlannedEndDate for backward compatibility
    ActualEndDate DATE NULL,
    Budget DECIMAL(12,2) NULL,
    ActualCost DECIMAL(12,2) NULL,
    EstimatedHours DECIMAL(8,1) NULL,
    ActualHours DECIMAL(8,1) NULL,
    BillingType NVARCHAR(20) NULL CHECK (BillingType IN ('Fixed Price', 'Time & Materials', 'Retainer', 'Milestone')),
    HourlyRate DECIMAL(8,2) NULL,
    Currency NVARCHAR(3) NULL DEFAULT 'USD',
    RiskLevel TINYINT NULL CHECK (RiskLevel BETWEEN 1 AND 5),
    ClientName NVARCHAR(100) NULL,
    ClientContactName NVARCHAR(100) NULL,
    ClientContactEmail NVARCHAR(100) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    Priority NVARCHAR(10) NOT NULL DEFAULT 'Medium',
    Description NVARCHAR(1000) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (ProjectTypeID) REFERENCES ProjectTypes(ProjectTypeID),
    FOREIGN KEY (ProjectManagerID) REFERENCES Employees(EmployeeID)
);

-- Employee Skills junction table
CREATE TABLE EmployeeSkills (
    EmployeeSkillID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    SkillID INT NOT NULL,
    ProficiencyLevel TINYINT NOT NULL CHECK (ProficiencyLevel BETWEEN 1 AND 5),
    YearsExperience DECIMAL(4,1) NULL,
    LastAssessed DATE NULL,
    LastUsedDate DATE NULL,
    CertificationDate DATE NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    SelfAssessmentScore TINYINT NULL CHECK (SelfAssessmentScore BETWEEN 1 AND 10),
    ManagerAssessmentScore TINYINT NULL CHECK (ManagerAssessmentScore BETWEEN 1 AND 10),
    AssessmentDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID),
    UNIQUE(EmployeeID, SkillID)
);

-- Employee Projects junction table
CREATE TABLE EmployeeProjects (
    EmployeeProjectID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Role NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    AllocationPercentage DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    HoursWorked DECIMAL(8,2) NOT NULL DEFAULT 0,
    HoursAllocated DECIMAL(8,2) NOT NULL DEFAULT 0, -- Keep for backward compatibility
    EstimatedHours DECIMAL(8,2) NULL,
    BillableRate DECIMAL(8,2) NULL,
    HourlyRate DECIMAL(8,2) NULL,
    PerformanceRating TINYINT NULL CHECK (PerformanceRating BETWEEN 1 AND 5),
    IsLead BIT NOT NULL DEFAULT 0,
    ResponsibilityArea NVARCHAR(200) NULL,
    ClientFeedbackScore TINYINT NULL CHECK (ClientFeedbackScore BETWEEN 1 AND 5),
    InternalFeedbackScore TINYINT NULL CHECK (InternalFeedbackScore BETWEEN 1 AND 5),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Performance Metrics table
CREATE TABLE PerformanceMetrics (
    PerformanceMetricID INT PRIMARY KEY IDENTITY(1,1),
    MetricID INT NULL, -- Alias for PerformanceMetricID for backward compatibility
    EmployeeID INT NOT NULL,
    MetricType NVARCHAR(50) NOT NULL,
    MetricName NVARCHAR(100) NULL,
    TargetValue DECIMAL(10,2) NULL,
    Target DECIMAL(10,2) NULL, -- Alias for TargetValue for backward compatibility
    ActualValue DECIMAL(10,2) NULL,
    MetricValue DECIMAL(10,2) NULL, -- Alias for ActualValue for backward compatibility
    MeasurementUnit NVARCHAR(50) NULL,
    Achievement DECIMAL(5,2) NULL, -- Percentage of target achieved
    PeriodStart DATE NULL,
    PeriodEnd DATE NULL,
    MeasurementDate DATE NULL,
    ReviewDate DATE NULL,
    Quarter TINYINT NULL,
    Year SMALLINT NULL,
    Weight DECIMAL(5,2) NULL,
    Comments NVARCHAR(500) NULL,
    ReviewedBy NVARCHAR(100) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Time Tracking table
CREATE TABLE TimeTracking (
    TimeTrackingID INT PRIMARY KEY IDENTITY(1,1),
    TimeEntryID INT NULL, -- Alias for TimeTrackingID for backward compatibility
    EmployeeID INT NOT NULL,
    ProjectID INT NULL,
    WorkDate DATE NOT NULL,
    HoursWorked DECIMAL(4,2) NOT NULL,
    WorkCategory NVARCHAR(50) NULL,
    ActivityType NVARCHAR(50) NULL, -- Alias for WorkCategory for backward compatibility
    Description NVARCHAR(500) NULL,
    BillableHours DECIMAL(4,2) NOT NULL DEFAULT 0,
    HourlyRate DECIMAL(8,2) NULL,
    IsApproved BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Employee Archive table (for Module 11, 12, 13 - UNION, Set Operators, Window Functions)
CREATE TABLE EmployeeArchive (
    EmployeeArchiveID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    JobTitle NVARCHAR(100) NULL,
    BaseSalary DECIMAL(10,2) NULL,
    DepartmentID INT NULL,
    DepartmentName NVARCHAR(100) NULL,
    ArchiveDate DATE NOT NULL DEFAULT GETDATE(),
    TerminationDate DATE NULL,
    ReasonForLeaving NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 0,
    ArchivedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Department History table (for Module 11 - EXCEPT operations)
CREATE TABLE DepartmentHistory (
    DepartmentHistoryID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentID INT NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    DepartmentCode NVARCHAR(10) NULL,
    Budget DECIMAL(12,2) NULL,
    Location NVARCHAR(100) NULL,
    EffectiveDate DATE NOT NULL,
    EndDate DATE NULL,
    ChangeType NVARCHAR(50) NULL,
    ChangedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

PRINT 'Advanced tables created successfully (including EmployeeArchive and DepartmentHistory).';

-- =============================================
-- STEP 9.5: ADD MISSING FOREIGN KEY CONSTRAINTS
-- =============================================
PRINT 'Step 9.5: Adding missing foreign key constraints...';

-- Add foreign key constraint for Departments.ManagerEmployeeID
-- (This must be done after Employees table is created due to circular reference)
ALTER TABLE Departments 
ADD CONSTRAINT FK_Departments_ManagerEmployeeID 
FOREIGN KEY (ManagerEmployeeID) REFERENCES Employees(EmployeeID);

PRINT 'Missing foreign key constraints added successfully.';

-- =============================================
-- STEP 10: SKILLS DATA
-- =============================================
PRINT 'Step 10: Populating skills data...';

-- Project Types
INSERT INTO ProjectTypes (TypeName, Description) VALUES
('Software Development', 'Custom software development projects'),
('System Integration', 'Integration of different systems and platforms'),
('Data Analytics', 'Business intelligence and data analysis projects'),
('Infrastructure', 'IT infrastructure and cloud migration projects'),
('Consulting', 'Business and technology consulting engagements'),
('Training', 'Employee training and development programs'),
('Research', 'Research and development initiatives'),
('Maintenance', 'System maintenance and support projects');

-- Skills
INSERT INTO Skills (SkillName, SkillCategoryID, Description) VALUES
-- Technical Skills (CategoryID 1)
('C# Programming', 1, 'Microsoft C# development and .NET framework'),
('SQL Server', 1, 'Microsoft SQL Server database administration and development'),
('JavaScript', 1, 'Client-side and server-side JavaScript development'),
('Python Programming', 1, 'Python development for various applications'),
('Java Programming', 1, 'Enterprise Java development'),
('React', 1, 'React.js frontend framework development'),
('Angular', 1, 'Angular frontend framework development'),
('Node.js', 1, 'Server-side JavaScript with Node.js'),
('Azure Cloud', 1, 'Microsoft Azure cloud platform services'),
('AWS', 1, 'Amazon Web Services cloud platform'),
('Docker', 1, 'Containerization with Docker'),
('Kubernetes', 1, 'Container orchestration with Kubernetes'),

-- Leadership Skills (CategoryID 2)
('Team Leadership', 2, 'Leading and managing development teams'),
('Strategic Planning', 2, 'Long-term planning and strategy development'),
('Change Management', 2, 'Managing organizational change initiatives'),
('Conflict Resolution', 2, 'Resolving team and organizational conflicts'),

-- Communication Skills (CategoryID 3)
('Technical Writing', 3, 'Creating technical documentation and specifications'),
('Public Speaking', 3, 'Presenting to large audiences and stakeholders'),
('Client Communication', 3, 'Effective communication with clients and customers'),
('Cross-functional Collaboration', 3, 'Working effectively across different departments'),

-- Analytical Skills (CategoryID 4)
('Data Analysis', 4, 'Analyzing and interpreting business data'),
('Business Intelligence', 4, 'BI tools and reporting solutions'),
('Statistical Analysis', 4, 'Statistical methods and analysis techniques'),
('Financial Analysis', 4, 'Financial modeling and analysis'),

-- Project Management Skills (CategoryID 5)
('Agile Methodology', 5, 'Agile project management and Scrum'),
('Waterfall Methodology', 5, 'Traditional waterfall project management'),
('Risk Management', 5, 'Identifying and managing project risks'),
('Budget Management', 5, 'Managing project budgets and resources'),

-- Domain Expertise (CategoryID 6)
('Financial Services', 6, 'Understanding of financial services industry'),
('Healthcare Technology', 6, 'Healthcare industry technology expertise'),
('E-commerce', 6, 'E-commerce platform and business expertise'),
('Manufacturing Systems', 6, 'Manufacturing and industrial systems knowledge'),
('Regulatory Compliance', 6, 'Understanding of industry regulations and compliance');

PRINT 'Skills data populated successfully.';

-- =============================================
-- STEP 11: PROJECTS DATA
-- =============================================
PRINT 'Step 11: Populating projects data...';

INSERT INTO Projects (CompanyID, ProjectName, ProjectCode, ProjectTypeID, ProjectManagerID, StartDate, EndDate, 
    Budget, Status, Priority, Description) VALUES

-- TechCorp Solutions Projects
(1001, 'Customer Portal Redesign', 'TC-2024-001', 1, 3002, '2024-01-15', '2024-06-30', 
    850000.00, 'Active', 'High', 'Complete redesign of customer-facing web portal with modern UI/UX'),
    
(1001, 'API Integration Platform', 'TC-2024-002', 2, 3002, '2024-03-01', '2024-08-15', 
    1200000.00, 'Active', 'High', 'Unified API platform for third-party integrations'),
    
(1001, 'Data Analytics Dashboard', 'TC-2024-003', 3, 3001, '2024-02-01', '2024-05-30', 
    650000.00, 'Completed', 'Medium', 'Executive dashboard for business intelligence and reporting'),

-- CloudTech Innovations Projects
(1002, 'Cloud Migration Phase 2', 'CT-2024-001', 4, 3005, '2024-01-10', '2024-07-31', 
    950000.00, 'Active', 'High', 'Migration of legacy systems to Azure cloud platform'),
    
(1002, 'DevOps Automation', 'CT-2024-002', 1, 3005, '2024-04-01', '2024-09-30', 
    420000.00, 'Active', 'Medium', 'Automated CI/CD pipeline implementation'),

-- Global Finance Corp Projects
(1004, 'Risk Management System', 'GF-2024-001', 1, 3007, '2024-01-05', '2024-12-31', 
    2500000.00, 'Active', 'Critical', 'Next-generation risk assessment and management platform'),
    
(1004, 'Regulatory Compliance Upgrade', 'GF-2024-002', 1, 3006, '2024-02-15', '2024-08-30', 
    1800000.00, 'Active', 'High', 'System upgrades for new financial regulations compliance'),
    
(1004, 'Trading Platform Enhancement', 'GF-2024-003', 1, 3007, '2024-03-01', '2024-10-15', 
    3200000.00, 'Active', 'High', 'Performance improvements and new features for trading platform');

PRINT 'Projects data populated successfully.';

-- =============================================
-- STEP 11.5: EMPLOYEE PROJECTS AND TIME TRACKING DATA
-- =============================================
PRINT 'Step 11.5: Populating employee project assignments and time tracking...';

-- Insert Employee Project assignments
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, StartDate, AllocationPercentage, HoursWorked, HoursAllocated, HourlyRate) VALUES
-- TechCorp Solutions project assignments
(3001, 5001, 'Project Sponsor', '2024-01-15', 25.00, 45.50, 160.00, 200.00),
(3002, 5001, 'Technical Lead', '2024-01-15', 75.00, 185.25, 240.00, 150.00),
(3002, 5002, 'Technical Lead', '2024-03-01', 80.00, 95.75, 120.00, 150.00),
(3003, 5001, 'Sales Coordinator', '2024-01-20', 15.00, 22.00, 80.00, 125.00),

-- CloudTech Innovations project assignments
(3004, 5004, 'Project Manager', '2024-01-10', 90.00, 215.50, 280.00, 175.00),
(3005, 5004, 'Technical Lead', '2024-01-15', 85.00, 198.75, 260.00, 160.00),
(3005, 5005, 'DevOps Lead', '2024-04-01', 70.00, 48.25, 100.00, 160.00),

-- Global Finance Corp project assignments  
(3006, 5006, 'Executive Sponsor', '2024-01-05', 20.00, 35.50, 150.00, 250.00),
(3007, 5006, 'Technical Director', '2024-01-10', 85.00, 245.75, 320.00, 180.00),
(3006, 5007, 'Compliance Lead', '2024-02-15', 60.00, 125.00, 180.00, 250.00),
(3007, 5008, 'Platform Architect', '2024-03-01', 75.00, 89.50, 140.00, 180.00);

-- Insert Time Tracking entries
INSERT INTO TimeTracking (EmployeeID, ProjectID, WorkDate, HoursWorked, ActivityType, Description, BillableHours, HourlyRate, IsApproved) VALUES
-- Recent time entries for active projects
(3002, 5001, '2024-10-01', 8.50, 'Development', 'Portal redesign - user authentication module', 8.00, 150.00, 1),
(3002, 5001, '2024-10-02', 7.25, 'Development', 'Portal redesign - UI components', 7.25, 150.00, 1),
(3002, 5002, '2024-10-03', 8.00, 'Architecture', 'API platform design review', 8.00, 150.00, 1),
(3005, 5004, '2024-10-01', 8.75, 'Cloud Migration', 'Azure infrastructure setup', 8.75, 160.00, 1),
(3005, 5004, '2024-10-02', 7.50, 'Cloud Migration', 'Data migration testing', 7.50, 160.00, 1),
(3007, 5006, '2024-10-01', 8.00, 'System Design', 'Risk management architecture', 8.00, 180.00, 1),
(3007, 5008, '2024-10-02', 6.50, 'Development', 'Trading platform enhancement', 6.50, 180.00, 1),
(3001, 5001, '2024-10-01', 4.00, 'Project Management', 'Stakeholder meeting and planning', 4.00, 200.00, 1),
(3004, 5004, '2024-10-01', 8.25, 'Project Management', 'Cloud migration coordination', 8.25, 175.00, 1),
(3006, 5007, '2024-10-02', 6.00, 'Compliance Review', 'Regulatory requirements analysis', 6.00, 250.00, 1);

PRINT 'Employee project assignments and time tracking data populated successfully.';

-- Synchronize alias columns in TimeTracking
UPDATE TimeTracking
SET TimeEntryID = TimeTrackingID,
    WorkCategory = ActivityType;

-- Synchronize alias columns in Projects (PlannedEndDate = EndDate for backward compatibility)
UPDATE Projects
SET PlannedEndDate = EndDate;

-- =============================================
-- STEP 11.6: EMPLOYEE ARCHIVE AND DEPARTMENT HISTORY DATA
-- =============================================
PRINT 'Step 11.6: Populating employee archive and department history...';

-- Insert archived employees (formerly employed)
INSERT INTO EmployeeArchive (EmployeeID, FirstName, LastName, MiddleName, JobTitle, BaseSalary, DepartmentID, DepartmentName, ArchiveDate, TerminationDate, ReasonForLeaving)
VALUES 
(9001, 'James', 'Anderson', 'Michael', 'Senior Software Engineer', 95000.00, 2001, 'Engineering', '2023-12-31', '2023-12-15', 'Accepted position at competitor'),
(9002, 'Mary', 'Williams', 'Elizabeth', 'Sales Manager', 105000.00, 2002, 'Sales', '2023-10-31', '2023-10-15', 'Career advancement opportunity'),
(9003, 'Robert', 'Martinez', 'James', 'Software Developer', 78000.00, 2001, 'Engineering', '2023-08-31', '2023-08-15', 'Relocation to another state'),
(9004, 'Patricia', 'Garcia', 'Ann', 'Marketing Specialist', 68000.00, 2003, 'Marketing', '2023-06-30', '2023-06-15', 'Personal/family reasons'),
(9005, 'Michael', 'Rodriguez', 'David', 'HR Coordinator', 62000.00, 2004, 'Human Resources', '2023-03-31', '2023-03-15', 'Early retirement'),
(9006, 'Linda', 'Wilson', 'Marie', 'Financial Analyst', 72000.00, 2005, 'Finance', '2023-01-31', '2023-01-15', 'Pursuing graduate education'),
(9007, 'William', 'Davis', 'John', 'DevOps Engineer', 88000.00, 2006, 'Development', '2022-12-31', '2022-12-15', 'Contract completion'),
(9008, 'Barbara', 'Lopez', 'Jean', 'Sales Representative', 58000.00, 2008, 'Sales', '2022-10-31', '2022-10-15', 'Performance issues'),
(9009, 'Richard', 'Gonzalez', 'Paul', 'Junior Developer', 55000.00, 2001, 'Engineering', '2022-08-31', '2022-08-15', 'Career change to different field'),
(9010, 'Susan', 'Hernandez', 'Kay', 'Marketing Coordinator', 52000.00, 2003, 'Marketing', '2022-06-30', '2022-06-15', 'Voluntary resignation');

PRINT '✓ EmployeeArchive data populated (10 archived employees)';

-- Insert department history (previous budget and location changes)
INSERT INTO DepartmentHistory (DepartmentID, DepartmentName, DepartmentCode, Budget, Location, EffectiveDate, EndDate, ChangeType)
SELECT 
    DepartmentID, 
    DepartmentName,
    DepartmentCode,
    Budget * 0.85, -- Historical budget was 15% lower
    Location,
    DATEADD(YEAR, -1, GETDATE()),
    DATEADD(DAY, -1, GETDATE()),
    'Annual Budget Increase'
FROM Departments
WHERE DepartmentID IN (2001, 2002, 2003, 2004, 2005);

-- Add some location changes
INSERT INTO DepartmentHistory (DepartmentID, DepartmentName, DepartmentCode, Budget, Location, EffectiveDate, EndDate, ChangeType)
VALUES
(2001, 'Engineering', 'ENG', 2125000.00, 'San Francisco HQ - Old Building', DATEADD(YEAR, -2, GETDATE()), DATEADD(YEAR, -1, GETDATE()), 'Office Relocation'),
(2002, 'Sales', 'SALES', 1530000.00, 'San Francisco HQ - Floor 3', DATEADD(MONTH, -18, GETDATE()), DATEADD(MONTH, -6, GETDATE()), 'Departmental Reorganization');

PRINT '✓ DepartmentHistory data populated (7 historical records)';
PRINT 'Employee archive and department history data populated successfully.';

-- =============================================
-- STEP 11.7: EMPLOYEE SKILLS AND PERFORMANCE METRICS DATA
-- =============================================
PRINT 'Step 11.7: Populating employee skills and performance metrics...';

-- Insert employee skills (linking employees to their competencies)
INSERT INTO EmployeeSkills (EmployeeID, SkillID, ProficiencyLevel, YearsExperience, LastAssessed, CertificationDate)
VALUES 
-- Leadership skills
(3001, 13, 5, 15.0, '2024-01-15', '2010-06-01'), -- CEO - Team Leadership (Expert)
(3001, 14, 5, 18.0, '2024-01-15', '2008-03-15'), -- CEO - Strategic Planning (Expert)
(3001, 31, 5, 20.0, '2024-01-15', NULL),         -- CEO - Financial Services Domain

-- CTO skills
(3002, 1, 5, 12.0, '2024-02-01', '2012-09-01'),  -- CTO - C# Programming (Expert)
(3002, 2, 5, 15.0, '2024-02-01', '2010-04-15'),  -- CTO - SQL Server (Expert)
(3002, 9, 4, 10.0, '2024-02-01', '2015-07-20'),  -- CTO - Azure Cloud (Advanced)
(3002, 13, 4, 8.0, '2024-02-01', NULL),          -- CTO - Team Leadership (Advanced)

-- VP Sales skills
(3003, 17, 5, 12.0, '2024-02-15', NULL),         -- VP Sales - Client Communication (Expert)
(3003, 13, 4, 10.0, '2024-02-15', NULL),         -- VP Sales - Team Leadership (Advanced)
(3003, 14, 4, 8.0, '2024-02-15', NULL),          -- VP Sales - Strategic Planning (Advanced)

-- CloudTech CEO
(3004, 13, 5, 15.0, '2024-01-20', '2009-05-01'), -- CEO - Team Leadership (Expert)
(3004, 14, 5, 18.0, '2024-01-20', '2007-08-10'), -- CEO - Strategic Planning (Expert)
(3004, 9, 4, 12.0, '2024-01-20', '2015-03-15'),  -- CEO - Azure Cloud (Advanced)

-- CloudTech VP Engineering
(3005, 1, 5, 10.0, '2024-02-01', '2014-06-01'),  -- VP Eng - C# Programming (Expert)
(3005, 3, 5, 12.0, '2024-02-01', '2012-04-15'),  -- VP Eng - JavaScript (Expert)
(3005, 9, 5, 8.0, '2024-02-01', '2018-09-20'),   -- VP Eng - Azure Cloud (Expert)
(3005, 12, 4, 6.0, '2024-02-01', '2019-11-10'),  -- VP Eng - Kubernetes (Advanced)

-- Global Finance CEO
(3006, 13, 5, 20.0, '2024-01-10', '2005-03-01'), -- CEO - Team Leadership (Expert)
(3006, 14, 5, 22.0, '2024-01-10', '2003-01-15'), -- CEO - Strategic Planning (Expert)
(3006, 22, 5, 25.0, '2024-01-10', NULL),         -- CEO - Financial Analysis (Expert)
(3006, 31, 5, 20.0, '2024-01-10', NULL),         -- CEO - Financial Services Domain (Expert)

-- Global Finance CRO
(3007, 24, 5, 15.0, '2024-01-15', NULL),         -- CRO - Risk Management (Expert)
(3007, 22, 5, 18.0, '2024-01-15', '2010-05-20'), -- CRO - Financial Analysis (Expert)
(3007, 33, 5, 12.0, '2024-01-15', '2015-07-10'); -- CRO - Regulatory Compliance (Expert)

PRINT '✓ EmployeeSkills data populated (20 skill assignments)';

-- Insert performance metrics for employees
INSERT INTO PerformanceMetrics (EmployeeID, MetricType, MetricValue, Target, Achievement, MeasurementDate, Quarter, Year, Comments)
VALUES 
-- Q1 2024 Leadership Performance
(3001, 'Leadership Score', 95.00, 90.00, 105.56, '2024-03-31', 1, 2024, 'Excellent strategic direction'),
(3001, 'Revenue Growth', 12.50, 10.00, 125.00, '2024-03-31', 1, 2024, 'Exceeded revenue targets'),
(3002, 'Technical Delivery', 92.00, 90.00, 102.22, '2024-03-31', 1, 2024, 'Strong technical leadership'),
(3002, 'Team Satisfaction', 88.00, 85.00, 103.53, '2024-03-31', 1, 2024, 'High team morale'),
(3003, 'Sales Target', 88.00, 85.00, 103.53, '2024-03-31', 1, 2024, 'Beat quarterly sales goal'),
(3003, 'Client Retention', 94.00, 90.00, 104.44, '2024-03-31', 1, 2024, 'Excellent client relationships'),

-- Q1 2024 CloudTech Performance
(3004, 'Leadership Score', 93.00, 90.00, 103.33, '2024-03-31', 1, 2024, 'Strong company growth'),
(3005, 'Technical Delivery', 96.00, 90.00, 106.67, '2024-03-31', 1, 2024, 'Outstanding project delivery'),
(3005, 'Innovation', 90.00, 85.00, 105.88, '2024-03-31', 1, 2024, 'Introduced new cloud solutions'),

-- Q1 2024 Global Finance Performance
(3006, 'Leadership Score', 98.00, 90.00, 108.89, '2024-03-31', 1, 2024, 'Exceptional leadership'),
(3006, 'Financial Performance', 105.00, 100.00, 105.00, '2024-03-31', 1, 2024, 'Exceeded all financial targets'),
(3007, 'Risk Management', 94.00, 90.00, 104.44, '2024-03-31', 1, 2024, 'Effective risk mitigation'),
(3007, 'Compliance Score', 100.00, 95.00, 105.26, '2024-03-31', 1, 2024, 'Perfect compliance record'),

-- Q2 2024 Performance
(3001, 'Leadership Score', 93.00, 90.00, 103.33, '2024-06-30', 2, 2024, 'Consistent leadership'),
(3002, 'Technical Delivery', 95.00, 90.00, 105.56, '2024-06-30', 2, 2024, 'Improved delivery metrics'),
(3003, 'Sales Target', 92.00, 90.00, 102.22, '2024-06-30', 2, 2024, 'Strong Q2 performance'),
(3004, 'Leadership Score', 91.00, 90.00, 101.11, '2024-06-30', 2, 2024, 'Solid quarter'),
(3005, 'Technical Delivery', 94.00, 90.00, 104.44, '2024-06-30', 2, 2024, 'Continued excellence'),
(3006, 'Financial Performance', 102.00, 100.00, 102.00, '2024-06-30', 2, 2024, 'Strong financial results'),
(3007, 'Risk Management', 96.00, 90.00, 106.67, '2024-06-30', 2, 2024, 'Enhanced risk controls');

PRINT '✓ PerformanceMetrics data populated (20 performance records)';

-- Synchronize alias columns in PerformanceMetrics
UPDATE PerformanceMetrics
SET MetricID = PerformanceMetricID,
    TargetValue = Target,
    ActualValue = MetricValue;

PRINT 'Employee skills and performance metrics data populated successfully.';

-- =============================================
-- STEP 12: CUSTOMERS DATA
-- =============================================
PRINT 'Step 12: Populating customers data...';

INSERT INTO Customers (CompanyID, CustomerName, CustomerType, ContactFirstName, ContactLastName, 
    ContactTitle, PrimaryEmail, PrimaryPhone, IndustryID, CountryID, StreetAddress, City, 
    StateProvince, PostalCode, CreditLimit, CurrentBalance, PaymentTerms, AccountStatus) VALUES

-- TechCorp Solutions Customers
(1001, 'Acme Corporation', 'Business', 'John', 'Smith', 'IT Director', 'john.smith@acmecorp.com', '+1-555-1001', 4, 1,
    '100 Industrial Way', 'San Jose', 'California', '95110', 500000.00, 45000.00, 30, 'Active'),
    
(1001, 'Global Retail Inc', 'Enterprise', 'Maria', 'Garcia', 'CTO', 'maria.garcia@globalretail.com', '+1-555-1002', 5, 1,
    '500 Commerce Plaza', 'Los Angeles', 'California', '90210', 1000000.00, 125000.00, 45, 'Active'),
    
(1001, 'StartupTech LLC', 'Business', 'David', 'Wilson', 'Founder', 'david@startuptech.com', '+1-555-1003', 1, 1,
    '800 Innovation Street', 'Palo Alto', 'California', '94301', 100000.00, 15000.00, 30, 'Active'),

-- CloudTech Innovations Customers
(1002, 'Healthcare Systems Co', 'Enterprise', 'Sarah', 'Johnson', 'VP Technology', 'sarah.j@healthsys.com', '+1-555-2001', 3, 1,
    '200 Medical Center Drive', 'Portland', 'Oregon', '97201', 750000.00, 85000.00, 30, 'Active'),
    
(1002, 'FinanceFirst Bank', 'Enterprise', 'Robert', 'Brown', 'Chief Information Officer', 'rbrown@financefirst.com', '+1-555-2002', 2, 1,
    '300 Banking Boulevard', 'Seattle', 'Washington', '98101', 2000000.00, 200000.00, 15, 'Active'),

-- Global Finance Corp Customers
(1004, 'Investment Holdings Ltd', 'Enterprise', 'Jennifer', 'Davis', 'Managing Director', 'j.davis@invholdings.com', '+1-555-4001', 2, 1,
    '100 Wall Street', 'New York', 'New York', '10005', 5000000.00, 750000.00, 15, 'Active'),
    
(1004, 'Pension Fund Associates', 'Enterprise', 'Michael', 'Chen', 'Portfolio Manager', 'm.chen@pensionfund.com', '+1-555-4002', 2, 1,
    '400 Financial Center', 'Boston', 'Massachusetts', '02101', 3000000.00, 450000.00, 30, 'Active'),

-- Additional Business Customers
(1001, 'Metro Government', 'Government', 'Lisa', 'Anderson', 'IT Procurement Manager', 'l.anderson@metro.gov', '+1-555-1004', 7, 1,
    '1000 City Hall Plaza', 'Sacramento', 'California', '95814', 2000000.00, 100000.00, 60, 'Active'),
    
(1002, 'Small Business Solutions', 'Business', 'Tom', 'Rodriguez', 'Owner', 'tom@smallbizsol.com', '+1-555-2003', 1, 1,
    '50 Main Street', 'Portland', 'Oregon', '97205', 50000.00, 8500.00, 30, 'Active'),
    
(1001, 'Individual Client - Alex', 'Individual', 'Alex', 'Thompson', 'Consultant', 'alex.thompson@email.com', '+1-555-1005', NULL, 1,
    '123 Residential Ave', 'Mountain View', 'California', '94041', 25000.00, 2500.00, 30, 'Active');

PRINT 'Customers data populated successfully.';

-- =============================================
-- STEP 13: PRODUCTS/SERVICES DATA
-- =============================================
PRINT 'Step 13: Populating products/services data...';

INSERT INTO Products (CompanyID, ProductName, ProductCode, ProductCategory, Description, 
    UnitPrice, Cost, StockQuantity, MinStockLevel) VALUES

-- TechCorp Solutions Products/Services
(1001, 'Enterprise Software License', 'TC-SW-001', 'Software', 'Annual license for enterprise software platform', 
    25000.00, 8000.00, 50, 5),
    
(1001, 'Custom Development Hours', 'TC-DEV-001', 'Services', 'Custom software development consulting hours', 
    150.00, 75.00, 1000, 100),
    
(1001, 'System Integration Service', 'TC-INT-001', 'Services', 'Complete system integration and setup service', 
    5000.00, 2000.00, 25, 5),
    
(1001, 'Technical Support - Premium', 'TC-SUP-001', 'Support', '24/7 premium technical support package', 
    2500.00, 800.00, 100, 10),

-- CloudTech Innovations Products
(1002, 'Cloud Migration Service', 'CT-MIG-001', 'Services', 'Complete cloud infrastructure migration', 
    15000.00, 6000.00, 20, 2),
    
(1002, 'DevOps Automation Setup', 'CT-DEV-001', 'Services', 'CI/CD pipeline setup and configuration', 
    8000.00, 3200.00, 15, 3),
    
(1002, 'Cloud Monitoring Solution', 'CT-MON-001', 'Software', 'Advanced cloud infrastructure monitoring', 
    3000.00, 1000.00, 50, 8),

-- Global Finance Corp Products
(1004, 'Risk Assessment Platform', 'GF-RISK-001', 'Software', 'Comprehensive financial risk assessment tool', 
    50000.00, 15000.00, 10, 2),
    
(1004, 'Trading Analytics Suite', 'GF-TRADE-001', 'Software', 'Advanced trading analytics and reporting', 
    75000.00, 22500.00, 5, 1),
    
(1004, 'Compliance Monitoring', 'GF-COMP-001', 'Services', 'Regulatory compliance monitoring service', 
    12000.00, 4800.00, 25, 5);

PRINT 'Products/services data populated successfully.';

-- =============================================
-- STEP 14: SUPPLIERS DATA
-- =============================================
PRINT 'Step 14: Populating suppliers data...';

INSERT INTO Suppliers (SupplierName, ContactName, ContactTitle, PrimaryEmail, PrimaryPhone, 
    CountryID, StreetAddress, City, StateProvince, PostalCode, Website, PaymentTerms) VALUES

('Microsoft Corporation', 'Enterprise Sales Team', 'Account Manager', 'enterprise@microsoft.com', '+1-800-642-7676', 1,
    'One Microsoft Way', 'Redmond', 'Washington', '98052', 'www.microsoft.com', 30),
    
('Amazon Web Services', 'Business Development', 'Solutions Architect', 'aws-sales@amazon.com', '+1-206-266-1000', 1,
    '410 Terry Avenue North', 'Seattle', 'Washington', '98109', 'aws.amazon.com', 30),
    
('Oracle Corporation', 'Partner Solutions', 'Partnership Manager', 'partners@oracle.com', '+1-650-506-7000', 1,
    '500 Oracle Parkway', 'Redwood City', 'California', '94065', 'www.oracle.com', 45),
    
('Salesforce Inc', 'Channel Partners', 'Channel Manager', 'partners@salesforce.com', '+1-415-901-7000', 1,
    'Salesforce Tower', 'San Francisco', 'California', '94105', 'www.salesforce.com', 30),
    
('Adobe Systems', 'Business Solutions', 'Account Executive', 'business@adobe.com', '+1-408-536-6000', 1,
    '345 Park Avenue', 'San Jose', 'California', '95110', 'www.adobe.com', 30);

PRINT 'Suppliers data populated successfully.';

-- =============================================
-- STEP 15: ORDERS DATA
-- =============================================
PRINT 'Step 15: Populating orders data...';

INSERT INTO Orders (CustomerID, CompanyID, OrderNumber, OrderDate, RequiredDate, ShippedDate, 
    OrderStatus, SubTotal, TaxAmount, ShippingCost, TotalAmount, PaymentStatus, PaymentMethod, Notes) VALUES

-- Recent Orders
(4001, 1001, 'TC-2024-001', '2024-01-15', '2024-02-15', '2024-01-20', 'Delivered', 
    25000.00, 2250.00, 0.00, 27250.00, 'Paid', 'Bank Transfer', 'Enterprise license renewal'),
    
(4002, 1001, 'TC-2024-002', '2024-02-01', '2024-03-01', '2024-02-05', 'Delivered', 
    15000.00, 1350.00, 0.00, 16350.00, 'Paid', 'Credit Card', 'Custom development project'),
    
(4004, 1002, 'CT-2024-001', '2024-02-15', '2024-03-15', '2024-02-20', 'Delivered', 
    15000.00, 1350.00, 0.00, 16350.00, 'Paid', 'Wire Transfer', 'Cloud migration phase 1'),
    
(4005, 1002, 'CT-2024-002', '2024-03-01', '2024-04-01', NULL, 'Processing', 
    8000.00, 720.00, 0.00, 8720.00, 'Pending', 'Purchase Order', 'DevOps setup project'),
    
(4006, 1004, 'GF-2024-001', '2024-01-10', '2024-02-10', '2024-01-15', 'Delivered', 
    50000.00, 4500.00, 0.00, 54500.00, 'Paid', 'Bank Transfer', 'Risk platform license'),
    
(4007, 1004, 'GF-2024-002', '2024-03-15', '2024-04-15', NULL, 'Shipped', 
    75000.00, 6750.00, 0.00, 81750.00, 'Paid', 'Wire Transfer', 'Trading analytics implementation');

-- Insert Order Details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
-- TC-2024-001 details
(7001, 6001, 1, 25000.00, 0.00),

-- TC-2024-002 details  
(7002, 6002, 100, 150.00, 0.00),

-- CT-2024-001 details
(7003, 6005, 1, 15000.00, 0.00),

-- CT-2024-002 details
(7004, 6006, 1, 8000.00, 0.00),

-- GF-2024-001 details
(7005, 6008, 1, 50000.00, 0.00),

-- GF-2024-002 details
(7006, 6009, 1, 75000.00, 0.00);

PRINT 'Orders data populated successfully.';

-- =============================================
-- STEP 16: PRODUCT SUPPLIERS DATA
-- =============================================
PRINT 'Step 16: Populating product suppliers relationships...';

INSERT INTO ProductSuppliers (ProductID, SupplierID, SupplierProductCode, CostPrice, LeadTimeDays, 
    MinOrderQuantity, IsPreferredSupplier) VALUES

-- TechCorp's relationships with suppliers
(6001, 8001, 'MSFT-ENT-001', 8000.00, 5, 1, 1), -- Microsoft for enterprise software
(6004, 8001, 'MSFT-SUP-001', 800.00, 3, 1, 1),  -- Microsoft support services

-- CloudTech's relationships  
(6005, 8002, 'AWS-MIG-001', 6000.00, 7, 1, 1),  -- AWS for migration services
(6007, 8002, 'AWS-MON-001', 1000.00, 5, 1, 1),  -- AWS monitoring tools

-- Global Finance relationships
(6008, 8003, 'ORA-RISK-001', 15000.00, 14, 1, 1), -- Oracle for risk platform
(6009, 8004, 'SF-TRADE-001', 22500.00, 10, 1, 1); -- Salesforce for trading analytics

PRINT 'Product suppliers data populated successfully.';

PRINT '';
PRINT 'All comprehensive data populated successfully!';
PRINT 'Database now includes:';
PRINT '- 15 Companies across multiple industries';
PRINT '- 20+ Departments with budgets and locations';
PRINT '- Leadership employees with realistic profiles';
PRINT '- 10 Customers (Business, Enterprise, Government, Individual)';
PRINT '- 10 Products/Services with pricing and inventory';
PRINT '- 6 Recent orders with order details';
PRINT '- 5 Suppliers with product relationships';
PRINT '- 30+ Skills across 6 categories';
PRINT '- 8+ Active projects with budgets and timelines';
PRINT '- 10 Archived employees (for UNION operations - Module 11)';
PRINT '- 7 Department history records (for EXCEPT operations - Module 11)';
PRINT '- 20 Employee skill assignments (proficiency tracking)';
PRINT '- 20 Performance metric records (KPI tracking)';
PRINT '- Complete business ecosystem for ALL 18 SQL training modules';

-- =============================================
-- FINAL VERIFICATION
-- =============================================
USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'TECHCORP DATABASE SETUP COMPLETE!';
PRINT '==============================================';
PRINT '';

-- Display summary statistics
PRINT 'DATABASE SUMMARY:';
PRINT '----------------------------------------';

SELECT 'Countries' as TableName, COUNT(*) as RecordCount FROM Countries
UNION ALL
SELECT 'Industries', COUNT(*) FROM Industries
UNION ALL
SELECT 'SkillCategories', COUNT(*) FROM SkillCategories
UNION ALL
SELECT 'JobLevels', COUNT(*) FROM JobLevels
UNION ALL
SELECT 'Companies', COUNT(*) FROM Companies
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'EmployeeArchive', COUNT(*) FROM EmployeeArchive
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM OrderDetails
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM Suppliers
UNION ALL
SELECT 'Skills', COUNT(*) FROM Skills
UNION ALL
SELECT 'EmployeeSkills', COUNT(*) FROM EmployeeSkills
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'EmployeeProjects', COUNT(*) FROM EmployeeProjects
UNION ALL
SELECT 'TimeTracking', COUNT(*) FROM TimeTracking
UNION ALL
SELECT 'PerformanceMetrics', COUNT(*) FROM PerformanceMetrics
UNION ALL
SELECT 'DepartmentHistory', COUNT(*) FROM DepartmentHistory;

PRINT '';
PRINT 'Companies by Size:';
SELECT 
    CompanySize,
    COUNT(*) as CompanyCount,
    AVG(AnnualRevenue) as AvgRevenue
FROM Companies 
GROUP BY CompanySize
ORDER BY CompanyCount DESC;

PRINT '';
PRINT '==============================================';
PRINT 'TechCorp Database is ready for SQL training!';
PRINT 'Basic structure created with 5 companies for testing';
PRINT '==============================================';

-- Sample verification queries
PRINT '';
PRINT 'Sample verification queries:';
PRINT '';

-- Basic SELECT (Module 2-3)
PRINT '1. All companies with revenue > $10M:';
SELECT CompanyName, AnnualRevenue, CompanySize, FoundedYear
FROM Companies 
WHERE AnnualRevenue > 10000000
ORDER BY AnnualRevenue DESC;

PRINT '';
PRINT '2. Customer Orders with Details (JOIN examples):';
SELECT TOP 5
    c.CustomerName,
    o.OrderNumber,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.LineTotal
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate DESC;

PRINT '';
PRINT '3. Companies with Customer Count (GROUP BY examples):';
SELECT 
    co.CompanyName,
    COUNT(c.CustomerID) as CustomerCount,
    SUM(c.CurrentBalance) as TotalBalance
FROM Companies co
LEFT JOIN Customers c ON co.CompanyID = c.CompanyID
GROUP BY co.CompanyID, co.CompanyName
HAVING COUNT(c.CustomerID) > 0
ORDER BY CustomerCount DESC;

PRINT '';
PRINT '4. Product Inventory Status (CASE/Conditional examples):';
SELECT 
    ProductName,
    StockQuantity,
    MinStockLevel,
    CASE 
        WHEN StockQuantity <= MinStockLevel THEN 'REORDER NEEDED'
        WHEN StockQuantity <= MinStockLevel * 2 THEN 'LOW STOCK'
        ELSE 'IN STOCK'
    END as StockStatus,
    UnitPrice
FROM Products
ORDER BY StockQuantity;

PRINT '';
PRINT '==============================================';
PRINT 'COMPLETE DATABASE SETUP FINISHED!';
PRINT 'TechCorp database ready for ALL SQL training modules';
PRINT 'Includes: Companies, Departments, Employees, Customers,';
PRINT 'Products, Orders, Suppliers, Skills, Projects & More!';
PRINT '';
PRINT 'SCHEMA ENHANCEMENTS (November 25, 2025):';
PRINT '✓ Added comprehensive column coverage for all modules';
PRINT '✓ Training compatibility aliases:';
PRINT '  - Employees: ManagerID = ReportsToEmployeeID';
PRINT '  - Employees: Phone = WorkPhone';
PRINT '  - Projects: PlannedEndDate = EndDate';
PRINT '  - PerformanceMetrics: MetricID, TargetValue, ActualValue aliases';
PRINT '  - TimeTracking: TimeEntryID, WorkCategory aliases';
PRINT '✓ Enhanced columns:';
PRINT '  - Employees: BonusTarget, EmploymentType, Nationality';
PRINT '  - Departments: BudgetPeriod';
PRINT '  - Projects: Extended tracking (Billing, Client, Risk, etc.)';
PRINT '  - EmployeeSkills: Assessment scores (Self/Manager)';
PRINT '  - EmployeeProjects: Performance tracking fields';
PRINT '  - PerformanceMetrics: Comprehensive metric tracking';
PRINT '✓ All 18 training modules fully supported';
PRINT '==============================================';