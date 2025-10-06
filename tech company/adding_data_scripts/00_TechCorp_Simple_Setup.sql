-- =============================================
-- TechCorp Database: Simple Setup Script
-- Works with any SQL Server configuration
-- =============================================

-- Check if we can create databases
IF HAS_PERMS_BY_NAME(NULL, NULL, 'CREATE DATABASE') = 0
BEGIN
    PRINT 'ERROR: You do not have permission to create databases.';
    PRINT 'Please ask your database administrator to create the TechCorpDB database first,';
    PRINT 'or run this script as a user with database creation permissions.';
    PRINT '';
    PRINT 'Alternative: Create database manually and run the table creation part only.';
    RETURN;
END

USE master;
GO

PRINT '==============================================';
PRINT 'TechCorp Database Setup - Simple Version';
PRINT 'Creating database with default settings';
PRINT '==============================================';
PRINT '';

-- Drop database if exists (for clean setup)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'Dropping existing TechCorpDB database...';
    ALTER DATABASE TechCorpDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechCorpDB;
    PRINT 'Existing database dropped.';
END

-- Create new database with simple syntax
PRINT 'Creating TechCorpDB database...';
BEGIN TRY
    CREATE DATABASE TechCorpDB;
    PRINT 'TechCorpDB database created successfully.';
END TRY
BEGIN CATCH
    PRINT 'ERROR creating database:';
    PRINT ERROR_MESSAGE();
    PRINT 'Please create the database manually or check permissions.';
    RETURN;
END CATCH
GO

-- Switch to the new database with error handling
BEGIN TRY
    USE TechCorpDB;
    PRINT 'Connected to TechCorpDB successfully.';
END TRY
BEGIN CATCH
    PRINT 'ERROR connecting to database:';
    PRINT ERROR_MESSAGE();
    RETURN;
END CATCH
GO

-- =============================================
-- TABLE CREATION WITH ERROR HANDLING
-- =============================================
PRINT 'Creating database tables...';

BEGIN TRY
    -- Countries table
    CREATE TABLE Countries (
        CountryID INT PRIMARY KEY IDENTITY(1,1),
        CountryName NVARCHAR(100) NOT NULL UNIQUE,
        CountryCode CHAR(2) NOT NULL UNIQUE,
        Region NVARCHAR(50) NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    PRINT '✓ Countries table created';

    -- Industries table
    CREATE TABLE Industries (
        IndustryID INT PRIMARY KEY IDENTITY(1,1),
        IndustryName NVARCHAR(100) NOT NULL UNIQUE,
        IndustryCode NVARCHAR(10) NOT NULL UNIQUE,
        Description NVARCHAR(500) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    PRINT '✓ Industries table created';

    -- SkillCategories table
    CREATE TABLE SkillCategories (
        SkillCategoryID INT PRIMARY KEY IDENTITY(1,1),
        CategoryName NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(200) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    PRINT '✓ SkillCategories table created';

    -- JobLevels table
    CREATE TABLE JobLevels (
        JobLevelID INT PRIMARY KEY IDENTITY(1,1),
        LevelName NVARCHAR(50) NOT NULL UNIQUE,
        LevelCode NVARCHAR(10) NOT NULL UNIQUE,
        MinSalary DECIMAL(10,2) NULL,
        MaxSalary DECIMAL(10,2) NULL,
        Description NVARCHAR(200) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    PRINT '✓ JobLevels table created';

    -- Companies table
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
    PRINT '✓ Companies table created';

    -- Departments table  
    CREATE TABLE Departments (
        DepartmentID INT PRIMARY KEY IDENTITY(2001,1),
        CompanyID INT NOT NULL,
        DepartmentName NVARCHAR(100) NOT NULL,
        DepartmentCode NVARCHAR(10) NOT NULL,
        ManagerEmployeeID INT NULL,
        Budget DECIMAL(12,2) NULL,
        CostCenter NVARCHAR(20) NULL,
        Location NVARCHAR(100) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
        CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
        ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
        ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
        FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
    );
    PRINT '✓ Departments table created';

    -- Employees table
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
        HireDate DATE NOT NULL,
        TerminationDate DATE NULL,
        BaseSalary DECIMAL(10,2) NOT NULL,
        CommissionRate DECIMAL(5,4) NULL,
        BonusEligible BIT NOT NULL DEFAULT 1,
        WorkEmail NVARCHAR(100) NOT NULL UNIQUE,
        WorkPhone NVARCHAR(20) NULL,
        PersonalEmail NVARCHAR(100) NULL,
        PersonalPhone NVARCHAR(20) NULL,
        BirthDate DATE NULL,
        Gender CHAR(1) NULL CHECK (Gender IN ('M', 'F', 'N')),
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
        FOREIGN KEY (ReportsToEmployeeID) REFERENCES Employees(EmployeeID)
    );
    PRINT '✓ Employees table created';

    PRINT 'All tables created successfully!';

END TRY
BEGIN CATCH
    PRINT 'ERROR creating tables:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    RETURN;
END CATCH

-- =============================================
-- DATA POPULATION WITH ERROR HANDLING
-- =============================================
PRINT '';
PRINT 'Populating lookup tables...';

BEGIN TRY
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
    PRINT '✓ Countries data inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records';

    -- Industries data
    INSERT INTO Industries (IndustryName, IndustryCode, Description) VALUES
    ('Technology', 'TECH', 'Software development, IT services, and technology consulting'),
    ('Financial Services', 'FINSERV', 'Banking, insurance, investment, and financial consulting'),
    ('Healthcare', 'HEALTH', 'Medical devices, pharmaceuticals, and healthcare services'),
    ('Manufacturing', 'MANUF', 'Industrial manufacturing, automotive, and production'),
    ('Retail', 'RETAIL', 'Consumer goods, e-commerce, and retail services'),
    ('Energy', 'ENERGY', 'Oil, gas, renewable energy, and utilities'),
    ('Education', 'EDUC', 'Educational institutions, training, and e-learning');
    PRINT '✓ Industries data inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records';

    -- Skill Categories data
    INSERT INTO SkillCategories (CategoryName, Description) VALUES
    ('Technical', 'Programming, database, and technical skills'),
    ('Leadership', 'Management and leadership capabilities'),
    ('Communication', 'Written and verbal communication skills'),
    ('Analytical', 'Data analysis and problem-solving skills'),
    ('Project Management', 'Project planning and execution skills'),
    ('Domain Expertise', 'Industry-specific knowledge and expertise');
    PRINT '✓ SkillCategories data inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records';

    -- Job Levels data
    INSERT INTO JobLevels (LevelName, LevelCode, MinSalary, MaxSalary, Description) VALUES
    ('Executive', 'EXEC', 150000.00, 500000.00, 'C-level executives and senior leadership'),
    ('Senior Management', 'SRMGMT', 100000.00, 200000.00, 'Directors and senior managers'),
    ('Management', 'MGMT', 70000.00, 130000.00, 'Team leads and middle management'),
    ('Senior Professional', 'SRPROF', 80000.00, 150000.00, 'Senior individual contributors'),
    ('Professional', 'PROF', 50000.00, 100000.00, 'Mid-level professionals'),
    ('Associate', 'ASSOC', 35000.00, 70000.00, 'Junior professionals and associates'),
    ('Entry Level', 'ENTRY', 25000.00, 50000.00, 'New graduates and entry-level positions');
    PRINT '✓ JobLevels data inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records';

END TRY
BEGIN CATCH
    PRINT 'ERROR inserting lookup data:';
    PRINT ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- COMPANIES DATA POPULATION
-- =============================================
PRINT '';
PRINT 'Populating companies data...';

BEGIN TRY
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
        'AA', 30, 'USD');

    PRINT '✓ Companies data inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records';

END TRY
BEGIN CATCH
    PRINT 'ERROR inserting companies data:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    -- Continue with verification even if companies insert fails
END CATCH

-- =============================================
-- FINAL VERIFICATION AND SUMMARY
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'TECHCORP DATABASE SETUP COMPLETE!';
PRINT '==============================================';

-- Display summary statistics
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
ORDER BY RecordCount DESC;

PRINT '';
PRINT 'Sample data verification:';
SELECT TOP 3 CompanyName, CompanySize, AnnualRevenue, CountryID FROM Companies;

PRINT '';
PRINT '==============================================';
PRINT 'TechCorp Database setup completed successfully!';
PRINT 'Database is ready for SQL training exercises.';
PRINT '==============================================';