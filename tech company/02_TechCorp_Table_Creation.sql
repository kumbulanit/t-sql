-- =============================================
-- TechCorp Database Table Creation Script
-- Module 1: Foundation Tables & Schema
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- 1. BASIC LOOKUP TABLES (Module 1/2 level)
-- =============================================

-- Countries table
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY IDENTITY(1,1),
    CountryCode CHAR(2) NOT NULL UNIQUE,
    CountryName NVARCHAR(100) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    TimeZoneOffset DECIMAL(3,1) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- Industries table
CREATE TABLE Industries (
    IndustryID INT PRIMARY KEY IDENTITY(1,1),
    IndustryCode NVARCHAR(10) NOT NULL UNIQUE,
    IndustryName NVARCHAR(100) NOT NULL,
    IndustryDescription NVARCHAR(MAX) NULL,
    RiskLevel TINYINT NOT NULL DEFAULT 1, -- 1-5 scale
    RegulationLevel NVARCHAR(20) NOT NULL DEFAULT 'Standard'
);

-- Skill Categories table
CREATE TABLE SkillCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    CategoryDescription NVARCHAR(255) NULL,
    DifficultyLevel TINYINT NOT NULL DEFAULT 1, -- 1-5 scale
    MarketDemand DECIMAL(3,2) NOT NULL DEFAULT 1.00 -- demand multiplier
);

-- =============================================
-- 2. CORE BUSINESS ENTITIES (Module 2/3 level)
-- =============================================

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
    CreditRating NVARCHAR(3) NULL, -- AAA, AA+, etc.
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

-- Job Levels table
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

-- Departments table
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

-- =============================================
-- 3. EMPLOYEE DATA ENTITIES (Module 3/4 level)
-- =============================================

-- Employees table
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

-- Add the manager reference back to Departments
ALTER TABLE Departments 
ADD CONSTRAINT FK_Departments_Manager 
FOREIGN KEY (ManagerEmployeeID) REFERENCES Employees(EmployeeID);

PRINT 'TechCorp database tables created successfully!';
PRINT 'Ready for data population scripts.';