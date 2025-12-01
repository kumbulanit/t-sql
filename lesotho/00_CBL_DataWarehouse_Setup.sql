-- =============================================
-- CENTRAL BANK OF LESOTHO (CBL)
-- Enterprise Data Warehouse - Training Database
-- Research Department - Data Management Division
-- FOR ECONOMISTS AND STATISTICIANS
-- =============================================
-- Purpose: Complete setup for macroeconomic data management training
--          Designed for economists conducting policy analysis and
--          statisticians performing data compilation and dissemination
-- Author: Data Management Division
-- Date: December 2025
-- Database: CBL_DataWarehouse
-- Target Users: Economists, Statisticians, Econometricians, Data Analysts
-- =============================================

USE master;
GO

PRINT '=============================================';
PRINT 'CENTRAL BANK OF LESOTHO';
PRINT 'Enterprise Data Warehouse Setup';
PRINT 'Research Department - Data Management Division';
PRINT 'For Economists and Statisticians';
PRINT '=============================================';
PRINT '';

-- =============================================
-- STEP 1: DATABASE CREATION AND SETUP
-- =============================================
PRINT 'Step 1: Creating CBL_DataWarehouse database...';

-- Drop database if exists (for clean setup)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CBL_DataWarehouse')
BEGIN
    ALTER DATABASE CBL_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CBL_DataWarehouse;
    PRINT '✓ Existing database dropped for clean setup';
END

-- Create new database
CREATE DATABASE CBL_DataWarehouse;
GO

USE CBL_DataWarehouse;
GO

PRINT '✓ CBL_DataWarehouse database created successfully';
PRINT '';

-- =============================================
-- STEP 2: LOOKUP/REFERENCE TABLES
-- =============================================
PRINT 'Step 2: Creating lookup and reference tables...';

-- Countries/Regions for international data
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY IDENTITY(1,1),
    CountryCode CHAR(3) NOT NULL UNIQUE,
    CountryName NVARCHAR(100) NOT NULL UNIQUE,
    Region NVARCHAR(50) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    CurrencyName NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Data sources (internal/external)
CREATE TABLE DataSources (
    DataSourceID INT PRIMARY KEY IDENTITY(1,1),
    SourceCode NVARCHAR(20) NOT NULL UNIQUE,
    SourceName NVARCHAR(100) NOT NULL,
    SourceType NVARCHAR(50) NOT NULL CHECK (SourceType IN ('Internal', 'External', 'Commercial Bank', 'Government Agency')),
    ContactPerson NVARCHAR(100) NULL,
    ContactEmail NVARCHAR(100) NULL,
    ContactPhone NVARCHAR(20) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Data frequency types
CREATE TABLE DataFrequencies (
    FrequencyID INT PRIMARY KEY IDENTITY(1,1),
    FrequencyCode NVARCHAR(10) NOT NULL UNIQUE,
    FrequencyName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL,
    SortOrder INT NOT NULL
);

-- Economic indicator categories
CREATE TABLE IndicatorCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    ParentCategoryID INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (ParentCategoryID) REFERENCES IndicatorCategories(CategoryID)
);

-- Report types
CREATE TABLE ReportTypes (
    ReportTypeID INT PRIMARY KEY IDENTITY(1,1),
    ReportCode NVARCHAR(20) NOT NULL UNIQUE,
    ReportName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    PublicationFrequency NVARCHAR(20) NULL,
    IsPublic BIT NOT NULL DEFAULT 1,
    IsActive BIT NOT NULL DEFAULT 1
);

PRINT '✓ Lookup tables created successfully';

-- =============================================
-- STEP 3: CORE OPERATIONAL TABLES
-- =============================================
PRINT 'Step 3: Creating core operational tables...';

-- Commercial Banks in Lesotho
CREATE TABLE CommercialBanks (
    BankID INT PRIMARY KEY IDENTITY(1,1),
    BankCode NVARCHAR(10) NOT NULL UNIQUE,
    BankName NVARCHAR(100) NOT NULL,
    BankType NVARCHAR(50) NOT NULL CHECK (BankType IN ('Commercial Bank', 'Development Bank', 'Microfinance', 'Investment Bank')),
    RegistrationNumber NVARCHAR(50) NULL,
    HeadOfficeAddress NVARCHAR(255) NULL,
    City NVARCHAR(50) NULL,
    PostalCode NVARCHAR(10) NULL,
    ContactPerson NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    EstablishedDate DATE NULL,
    LicenseNumber NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Economic Indicators Master
CREATE TABLE EconomicIndicators (
    IndicatorID INT PRIMARY KEY IDENTITY(1,1),
    IndicatorCode NVARCHAR(50) NOT NULL UNIQUE,
    IndicatorName NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    UnitOfMeasure NVARCHAR(50) NOT NULL,
    DataSourceID INT NOT NULL,
    FrequencyID INT NOT NULL,
    Description NVARCHAR(1000) NULL,
    CalculationMethod NVARCHAR(500) NULL,
    IsSeasonallyAdjusted BIT NOT NULL DEFAULT 0,
    IsPublished BIT NOT NULL DEFAULT 1,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CategoryID) REFERENCES IndicatorCategories(CategoryID),
    FOREIGN KEY (DataSourceID) REFERENCES DataSources(DataSourceID),
    FOREIGN KEY (FrequencyID) REFERENCES DataFrequencies(FrequencyID)
);

-- Time Series Data (actual values)
CREATE TABLE TimeSeriesData (
    TimeSeriesID BIGINT PRIMARY KEY IDENTITY(1,1),
    IndicatorID INT NOT NULL,
    PeriodDate DATE NOT NULL,
    PeriodYear INT NOT NULL,
    PeriodQuarter INT NULL CHECK (PeriodQuarter BETWEEN 1 AND 4),
    PeriodMonth INT NULL CHECK (PeriodMonth BETWEEN 1 AND 12),
    DataValue DECIMAL(18,6) NOT NULL,
    DataSourceID INT NOT NULL,
    CollectionDate DATE NOT NULL,
    PublicationDate DATE NULL,
    IsProvisional BIT NOT NULL DEFAULT 0,
    IsRevised BIT NOT NULL DEFAULT 0,
    RevisionNumber INT NOT NULL DEFAULT 0,
    Notes NVARCHAR(500) NULL,
    CollectedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (IndicatorID) REFERENCES EconomicIndicators(IndicatorID),
    FOREIGN KEY (DataSourceID) REFERENCES DataSources(DataSourceID),
    UNIQUE (IndicatorID, PeriodDate, RevisionNumber)
);

-- Banking Statistics (from commercial banks)
CREATE TABLE BankingStatistics (
    StatisticID BIGINT PRIMARY KEY IDENTITY(1,1),
    BankID INT NOT NULL,
    ReportingDate DATE NOT NULL,
    ReportingMonth INT NOT NULL CHECK (ReportingMonth BETWEEN 1 AND 12),
    ReportingYear INT NOT NULL,
    TotalAssets DECIMAL(18,2) NULL,
    TotalLoans DECIMAL(18,2) NULL,
    TotalDeposits DECIMAL(18,2) NULL,
    CustomerDeposits DECIMAL(18,2) NULL,
    InterbankDeposits DECIMAL(18,2) NULL,
    TotalEquity DECIMAL(18,2) NULL,
    NetIncome DECIMAL(18,2) NULL,
    InterestIncome DECIMAL(18,2) NULL,
    InterestExpense DECIMAL(18,2) NULL,
    NonPerformingLoans DECIMAL(18,2) NULL,
    NPLRatio DECIMAL(5,2) NULL,
    CapitalAdequacyRatio DECIMAL(5,2) NULL,
    LiquidityRatio DECIMAL(5,2) NULL,
    SubmittedDate DATE NOT NULL,
    IsValidated BIT NOT NULL DEFAULT 0,
    ValidatedBy NVARCHAR(100) NULL,
    ValidationDate DATE NULL,
    Notes NVARCHAR(500) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (BankID) REFERENCES CommercialBanks(BankID),
    UNIQUE (BankID, ReportingDate)
);

-- External Data Sources (Bureau of Statistics, Revenue Authority, etc.)
CREATE TABLE ExternalDataSubmissions (
    SubmissionID INT PRIMARY KEY IDENTITY(1,1),
    DataSourceID INT NOT NULL,
    SubmissionDate DATE NOT NULL,
    ReportingPeriod DATE NOT NULL,
    DataCategory NVARCHAR(100) NOT NULL,
    NumberOfRecords INT NOT NULL,
    FileReference NVARCHAR(255) NULL,
    ReceivedBy NVARCHAR(100) NOT NULL,
    ProcessingStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (ProcessingStatus IN ('Pending', 'In Progress', 'Validated', 'Published', 'Rejected')),
    ValidationDate DATE NULL,
    ValidationNotes NVARCHAR(1000) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (DataSourceID) REFERENCES DataSources(DataSourceID)
);

PRINT '✓ Core operational tables created successfully';

-- =============================================
-- STEP 4: REPORTING AND DISSEMINATION TABLES
-- =============================================
PRINT 'Step 4: Creating reporting and dissemination tables...';

-- Macroeconomic Reports
CREATE TABLE MacroeconomicReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReportTypeID INT NOT NULL,
    ReportTitle NVARCHAR(255) NOT NULL,
    ReportPeriod DATE NOT NULL,
    ReportYear INT NOT NULL,
    ReportQuarter INT NULL CHECK (ReportQuarter BETWEEN 1 AND 4),
    ReportMonth INT NULL CHECK (ReportMonth BETWEEN 1 AND 12),
    AuthorName NVARCHAR(100) NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL DEFAULT 'Research Department',
    DivisionName NVARCHAR(100) NOT NULL DEFAULT 'Data Management Division',
    DraftDate DATE NULL,
    ReviewDate DATE NULL,
    ReviewedBy NVARCHAR(100) NULL,
    ApprovalDate DATE NULL,
    ApprovedBy NVARCHAR(100) NULL,
    PublicationDate DATE NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Under Review', 'Approved', 'Published', 'Archived')),
    IsPublic BIT NOT NULL DEFAULT 0,
    FileLocation NVARCHAR(500) NULL,
    Notes NVARCHAR(1000) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (ReportTypeID) REFERENCES ReportTypes(ReportTypeID)
);

-- Data Dissemination Log
CREATE TABLE DataDissemination (
    DisseminationID INT PRIMARY KEY IDENTITY(1,1),
    DisseminationType NVARCHAR(50) NOT NULL CHECK (DisseminationType IN ('Internal', 'External', 'Public', 'Confidential')),
    RecipientType NVARCHAR(50) NOT NULL CHECK (RecipientType IN ('Government Ministry', 'International Organization', 'Commercial Bank', 'Research Institution', 'Public', 'Media')),
    RecipientName NVARCHAR(200) NOT NULL,
    RecipientContact NVARCHAR(100) NULL,
    DataCategory NVARCHAR(100) NOT NULL,
    ReportID INT NULL,
    DisseminationDate DATE NOT NULL,
    DeliveryMethod NVARCHAR(50) NOT NULL CHECK (DeliveryMethod IN ('Email', 'Portal', 'API', 'Physical Copy', 'Website')),
    RequestedBy NVARCHAR(100) NULL,
    ApprovedBy NVARCHAR(100) NOT NULL,
    Purpose NVARCHAR(500) NULL,
    Notes NVARCHAR(500) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (ReportID) REFERENCES MacroeconomicReports(ReportID)
);

-- Research Staff (Data Management Division)
CREATE TABLE ResearchStaff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeNumber NVARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    Division NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL DEFAULT 'Research Department',
    Specialization NVARCHAR(200) NULL,
    EducationLevel NVARCHAR(50) NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Data Quality Checks
CREATE TABLE DataQualityChecks (
    CheckID INT PRIMARY KEY IDENTITY(1,1),
    IndicatorID INT NOT NULL,
    CheckDate DATE NOT NULL,
    CheckType NVARCHAR(50) NOT NULL CHECK (CheckType IN ('Completeness', 'Accuracy', 'Consistency', 'Timeliness', 'Validity')),
    CheckResult NVARCHAR(20) NOT NULL CHECK (CheckResult IN ('Pass', 'Fail', 'Warning')),
    IssuesFound NVARCHAR(1000) NULL,
    CorrectiveAction NVARCHAR(1000) NULL,
    CheckedBy NVARCHAR(100) NOT NULL,
    ResolvedDate DATE NULL,
    ResolvedBy NVARCHAR(100) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (IndicatorID) REFERENCES EconomicIndicators(IndicatorID)
);

PRINT '✓ Reporting and dissemination tables created successfully';
PRINT '';

-- =============================================
-- STEP 5: POPULATE LOOKUP DATA
-- =============================================
PRINT 'Step 5: Populating lookup tables with reference data...';

-- Countries
INSERT INTO Countries (CountryCode, CountryName, Region, CurrencyCode, CurrencyName) VALUES
('LSO', 'Lesotho', 'Southern Africa', 'LSL', 'Lesotho Loti'),
('ZAF', 'South Africa', 'Southern Africa', 'ZAR', 'South African Rand'),
('BWA', 'Botswana', 'Southern Africa', 'BWP', 'Botswana Pula'),
('NAM', 'Namibia', 'Southern Africa', 'NAD', 'Namibian Dollar'),
('SWZ', 'Eswatini', 'Southern Africa', 'SZL', 'Swazi Lilangeni'),
('ZWE', 'Zimbabwe', 'Southern Africa', 'ZWL', 'Zimbabwean Dollar'),
('MOZ', 'Mozambique', 'Southern Africa', 'MZN', 'Mozambican Metical'),
('USA', 'United States', 'North America', 'USD', 'US Dollar'),
('GBR', 'United Kingdom', 'Europe', 'GBP', 'British Pound'),
('EUR', 'Eurozone', 'Europe', 'EUR', 'Euro'),
('CHN', 'China', 'Asia', 'CNY', 'Chinese Yuan'),
('JPN', 'Japan', 'Asia', 'JPY', 'Japanese Yen');

-- Data Sources
INSERT INTO DataSources (SourceCode, SourceName, SourceType, ContactPerson, ContactEmail) VALUES
('CBL-CORE', 'Central Bank of Lesotho - Core Banking System', 'Internal', 'IT Department', 'it@centralbank.org.ls'),
('CBL-RTGS', 'Real-Time Gross Settlement System', 'Internal', 'Payments Division', 'payments@centralbank.org.ls'),
('CBL-FX', 'Foreign Exchange Division', 'Internal', 'FX Manager', 'forex@centralbank.org.ls'),
('BOS', 'Bureau of Statistics Lesotho', 'Government Agency', 'Chief Statistician', 'info@bos.gov.ls'),
('LRA', 'Lesotho Revenue Authority', 'Government Agency', 'Commissioner', 'info@lra.org.ls'),
('FNB-LSO', 'First National Bank Lesotho', 'Commercial Bank', 'Head of Compliance', 'compliance@fnb.co.ls'),
('NED-LSO', 'Nedbank Lesotho', 'Commercial Bank', 'Reporting Manager', 'reporting@nedbank.co.ls'),
('STD-LSO', 'Standard Lesotho Bank', 'Commercial Bank', 'Finance Director', 'finance@standardbank.co.ls'),
('CBL-BANK', 'CBL Bank (Formerly Lesotho PostBank)', 'Commercial Bank', 'Operations Manager', 'ops@cblbank.co.ls'),
('IMF', 'International Monetary Fund', 'External', 'Africa Department', 'afr@imf.org'),
('WORLDBANK', 'World Bank', 'External', 'Lesotho Office', 'lesotho@worldbank.org'),
('SARB', 'South African Reserve Bank', 'External', 'Research Department', 'research@resbank.co.za');

-- Data Frequencies
INSERT INTO DataFrequencies (FrequencyCode, FrequencyName, Description, SortOrder) VALUES
('D', 'Daily', 'Data collected every day', 1),
('W', 'Weekly', 'Data collected every week', 2),
('M', 'Monthly', 'Data collected every month', 3),
('Q', 'Quarterly', 'Data collected every quarter', 4),
('S', 'Semi-Annual', 'Data collected twice a year', 5),
('A', 'Annual', 'Data collected once a year', 6),
('I', 'Irregular', 'Data collected on irregular basis', 7);

-- Indicator Categories
INSERT INTO IndicatorCategories (CategoryCode, CategoryName, Description, ParentCategoryID) VALUES
('MACRO', 'Macroeconomic Indicators', 'Overall macroeconomic performance indicators', NULL),
('MONETARY', 'Monetary Indicators', 'Money supply, interest rates, credit', NULL),
('BANKING', 'Banking Sector', 'Commercial banking statistics and performance', NULL),
('EXTERNAL', 'External Sector', 'Balance of payments, foreign exchange reserves', NULL),
('FISCAL', 'Fiscal Indicators', 'Government revenue, expenditure, debt', NULL),
('PRICES', 'Price Indicators', 'Inflation, consumer prices, producer prices', NULL),
('REAL', 'Real Sector', 'GDP, employment, production', NULL),
('TRADE', 'Trade Statistics', 'Imports, exports, trade balance', NULL);

-- Sub-categories
INSERT INTO IndicatorCategories (CategoryCode, CategoryName, Description, ParentCategoryID) VALUES
('GDP', 'Gross Domestic Product', 'GDP and its components', 7),
('CPI', 'Consumer Price Index', 'Consumer price inflation measures', 6),
('RESERVES', 'Foreign Reserves', 'International reserves and foreign assets', 4),
('CREDIT', 'Credit Statistics', 'Bank credit to various sectors', 3),
('DEPOSITS', 'Deposit Statistics', 'Bank deposits by type and sector', 3),
('EXCHRATE', 'Exchange Rates', 'Foreign exchange rates', 4);

-- Report Types
INSERT INTO ReportTypes (ReportCode, ReportName, Description, PublicationFrequency, IsPublic) VALUES
('MONTHLY-STAT', 'Monthly Statistical Bulletin', 'Comprehensive monthly economic and financial statistics', 'Monthly', 1),
('QUARTERLY-REV', 'Quarterly Economic Review', 'Quarterly analysis of economic developments', 'Quarterly', 1),
('ANNUAL-REP', 'Annual Report', 'Comprehensive annual report of the Central Bank', 'Annual', 1),
('BANKING-SUP', 'Banking Supervision Report', 'Quarterly banking sector supervision report', 'Quarterly', 0),
('BOP', 'Balance of Payments', 'Quarterly balance of payments statistics', 'Quarterly', 1),
('MONETARY-POL', 'Monetary Policy Statement', 'Semi-annual monetary policy review', 'Semi-Annual', 1),
('INFLATION-REP', 'Inflation Report', 'Monthly inflation analysis and forecasts', 'Monthly', 1),
('FINSTAB-REP', 'Financial Stability Report', 'Annual financial stability assessment', 'Annual', 1);

PRINT '✓ Lookup tables populated successfully';

-- =============================================
-- STEP 6: POPULATE OPERATIONAL DATA
-- =============================================
PRINT 'Step 6: Populating operational tables with sample data...';

-- Commercial Banks
INSERT INTO CommercialBanks (BankCode, BankName, BankType, City, Email, Phone, EstablishedDate, LicenseNumber, IsActive) VALUES
('FNB', 'First National Bank Lesotho', 'Commercial Bank', 'Maseru', 'info@fnb.co.ls', '+266 2231 6000', '1999-03-15', 'CBL-LIC-001', 1),
('NED', 'Nedbank Lesotho', 'Commercial Bank', 'Maseru', 'info@nedbank.co.ls', '+266 2231 2000', '1991-06-01', 'CBL-LIC-002', 1),
('STD', 'Standard Lesotho Bank', 'Commercial Bank', 'Maseru', 'info@standardbank.co.ls', '+266 2231 3000', '1973-04-20', 'CBL-LIC-003', 1),
('CBL-BANK', 'CBL Bank (Lesotho PostBank)', 'Development Bank', 'Maseru', 'info@cblbank.co.ls', '+266 2231 4000', '2021-01-15', 'CBL-LIC-004', 1),
('LETSHEGO', 'Letshego Bank Lesotho', 'Microfinance', 'Maseru', 'info@letshego.co.ls', '+266 2231 5000', '2008-11-10', 'CBL-LIC-005', 1);

-- Economic Indicators
INSERT INTO EconomicIndicators (IndicatorCode, IndicatorName, CategoryID, UnitOfMeasure, DataSourceID, FrequencyID, Description, IsSeasonallyAdjusted, IsPublished) VALUES
-- Real Sector
('GDP-REAL', 'Real GDP', 9, 'Million LSL', 4, 4, 'Gross Domestic Product at constant prices', 1, 1),
('GDP-NOM', 'Nominal GDP', 9, 'Million LSL', 4, 4, 'Gross Domestic Product at current prices', 0, 1),
('UNEMP-RATE', 'Unemployment Rate', 7, 'Percentage', 4, 4, 'National unemployment rate', 1, 1),

-- Price Indicators
('CPI-ALL', 'Consumer Price Index (All Items)', 10, 'Index (2016=100)', 4, 3, 'Overall consumer price index', 0, 1),
('CPI-FOOD', 'CPI - Food', 10, 'Index (2016=100)', 4, 3, 'Food component of CPI', 0, 1),
('INF-RATE', 'Inflation Rate (Annual)', 6, 'Percentage', 4, 3, 'Year-on-year inflation rate', 0, 1),

-- Monetary Indicators
('M1', 'Money Supply M1', 2, 'Million LSL', 1, 3, 'Narrow money supply', 0, 1),
('M2', 'Money Supply M2', 2, 'Million LSL', 1, 3, 'Broad money supply', 0, 1),
('BASE-RATE', 'CBL Base Rate', 2, 'Percentage', 1, 3, 'Central Bank base lending rate', 0, 1),
('INT-LENDING', 'Average Lending Rate', 2, 'Percentage', 1, 3, 'Average commercial bank lending rate', 0, 1),
('INT-DEPOSIT', 'Average Deposit Rate', 2, 'Percentage', 1, 3, 'Average commercial bank deposit rate', 0, 1),

-- Banking Sector
('BANK-ASSETS', 'Total Banking Sector Assets', 3, 'Million LSL', 1, 3, 'Aggregate assets of commercial banks', 0, 1),
('BANK-LOANS', 'Total Banking Sector Loans', 12, 'Million LSL', 1, 3, 'Aggregate loans and advances', 0, 1),
('BANK-DEPOSITS', 'Total Banking Sector Deposits', 13, 'Million LSL', 1, 3, 'Aggregate customer deposits', 0, 1),
('NPL-RATIO', 'Non-Performing Loans Ratio', 3, 'Percentage', 1, 3, 'Banking sector NPL ratio', 0, 1),

-- External Sector
('FX-RESERVES', 'Foreign Exchange Reserves', 11, 'Million USD', 3, 3, 'Gross foreign exchange reserves', 0, 1),
('EXCHRATE-USD', 'LSL/USD Exchange Rate', 14, 'LSL per USD', 3, 5, 'Lesotho Loti to US Dollar exchange rate', 0, 1),
('EXCHRATE-ZAR', 'LSL/ZAR Exchange Rate', 14, 'LSL per ZAR', 3, 5, 'Lesotho Loti to South African Rand (1:1 peg)', 0, 1),
('EXPORTS', 'Total Exports', 8, 'Million LSL', 5, 3, 'Total value of exports', 0, 1),
('IMPORTS', 'Total Imports', 8, 'Million LSL', 5, 3, 'Total value of imports', 0, 1),
('TRADE-BAL', 'Trade Balance', 8, 'Million LSL', 5, 3, 'Trade balance (Exports - Imports)', 0, 1),

-- Fiscal
('GOV-REV', 'Government Revenue', 5, 'Million LSL', 5, 3, 'Total government revenue', 0, 1),
('GOV-EXP', 'Government Expenditure', 5, 'Million LSL', 5, 3, 'Total government expenditure', 0, 1),
('GOV-DEBT', 'Government Debt', 5, 'Million LSL', 5, 4, 'Total government debt outstanding', 0, 1);

PRINT '✓ Economic indicators configured successfully';

-- =============================================
-- STEP 7: POPULATE TIME SERIES DATA (SAMPLE)
-- =============================================
PRINT 'Step 7: Populating time series data with sample values...';

-- Sample time series data for 2024 (monthly data for key indicators)
-- CPI Data (2024)
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate, IsProvisional) VALUES
(4, '2024-01-31', 2024, 1, 128.5, 4, '2024-02-15', 0),
(4, '2024-02-29', 2024, 2, 129.2, 4, '2024-03-15', 0),
(4, '2024-03-31', 2024, 3, 129.8, 4, '2024-04-15', 0),
(4, '2024-04-30', 2024, 4, 130.5, 4, '2024-05-15', 0),
(4, '2024-05-31', 2024, 5, 131.2, 4, '2024-06-15', 0),
(4, '2024-06-30', 2024, 6, 131.8, 4, '2024-07-15', 0),
(4, '2024-07-31', 2024, 7, 132.5, 4, '2024-08-15', 0),
(4, '2024-08-31', 2024, 8, 133.1, 4, '2024-09-15', 0),
(4, '2024-09-30', 2024, 9, 133.7, 4, '2024-10-15', 0),
(4, '2024-10-31', 2024, 10, 134.3, 4, '2024-11-15', 0),
(4, '2024-11-30', 2024, 11, 134.9, 4, '2024-12-15', 1);

-- Inflation Rate (monthly)
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate, IsProvisional) VALUES
(6, '2024-01-31', 2024, 1, 5.2, 4, '2024-02-15', 0),
(6, '2024-02-29', 2024, 2, 5.4, 4, '2024-03-15', 0),
(6, '2024-03-31', 2024, 3, 5.6, 4, '2024-04-15', 0),
(6, '2024-04-30', 2024, 4, 5.8, 4, '2024-05-15', 0),
(6, '2024-05-31', 2024, 5, 6.0, 4, '2024-06-15', 0),
(6, '2024-06-30', 2024, 6, 5.9, 4, '2024-07-15', 0),
(6, '2024-07-31', 2024, 7, 5.7, 4, '2024-08-15', 0),
(6, '2024-08-31', 2024, 8, 5.5, 4, '2024-09-15', 0),
(6, '2024-09-30', 2024, 9, 5.3, 4, '2024-10-15', 0),
(6, '2024-10-31', 2024, 10, 5.1, 4, '2024-11-15', 0),
(6, '2024-11-30', 2024, 11, 4.9, 4, '2024-12-15', 1);

-- Money Supply M2 (monthly)
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate, IsProvisional) VALUES
(8, '2024-01-31', 2024, 1, 18500.5, 1, '2024-02-10', 0),
(8, '2024-02-29', 2024, 2, 18650.3, 1, '2024-03-10', 0),
(8, '2024-03-31', 2024, 3, 18800.7, 1, '2024-04-10', 0),
(8, '2024-04-30', 2024, 4, 18950.2, 1, '2024-05-10', 0),
(8, '2024-05-31', 2024, 5, 19100.8, 1, '2024-06-10', 0),
(8, '2024-06-30', 2024, 6, 19250.4, 1, '2024-07-10', 0),
(8, '2024-07-31', 2024, 7, 19400.6, 1, '2024-08-10', 0),
(8, '2024-08-31', 2024, 8, 19550.9, 1, '2024-09-10', 0),
(8, '2024-09-30', 2024, 9, 19700.5, 1, '2024-10-10', 0),
(8, '2024-10-31', 2024, 10, 19850.2, 1, '2024-11-10', 0),
(8, '2024-11-30', 2024, 11, 20000.8, 1, '2024-12-10', 1);

-- Foreign Exchange Reserves (monthly)
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate, IsProvisional) VALUES
(16, '2024-01-31', 2024, 1, 952.3, 3, '2024-02-05', 0),
(16, '2024-02-29', 2024, 2, 958.7, 3, '2024-03-05', 0),
(16, '2024-03-31', 2024, 3, 965.2, 3, '2024-04-05', 0),
(16, '2024-04-30', 2024, 4, 971.8, 3, '2024-05-05', 0),
(16, '2024-05-31', 2024, 5, 978.5, 3, '2024-06-05', 0),
(16, '2024-06-30', 2024, 6, 985.3, 3, '2024-07-05', 0),
(16, '2024-07-31', 2024, 7, 992.1, 3, '2024-08-05', 0),
(16, '2024-08-31', 2024, 8, 998.9, 3, '2024-09-05', 0),
(16, '2024-09-30', 2024, 9, 1005.8, 3, '2024-10-05', 0),
(16, '2024-10-31', 2024, 10, 1012.7, 3, '2024-11-05', 0),
(16, '2024-11-30', 2024, 11, 1019.6, 3, '2024-12-05', 1);

-- Exchange Rates USD (daily - sample for Nov 2024)
INSERT INTO TimeSeriesData (IndicatorID, PeriodDate, PeriodYear, PeriodMonth, DataValue, DataSourceID, CollectionDate, IsProvisional) VALUES
(17, '2024-11-01', 2024, 11, 18.25, 3, '2024-11-01', 0),
(17, '2024-11-04', 2024, 11, 18.28, 3, '2024-11-04', 0),
(17, '2024-11-05', 2024, 11, 18.30, 3, '2024-11-05', 0),
(17, '2024-11-06', 2024, 11, 18.27, 3, '2024-11-06', 0),
(17, '2024-11-07', 2024, 11, 18.26, 3, '2024-11-07', 0),
(17, '2024-11-08', 2024, 11, 18.29, 3, '2024-11-08', 0),
(17, '2024-11-11', 2024, 11, 18.31, 3, '2024-11-11', 0),
(17, '2024-11-12', 2024, 11, 18.33, 3, '2024-11-12', 0),
(17, '2024-11-13', 2024, 11, 18.35, 3, '2024-11-13', 0),
(17, '2024-11-14', 2024, 11, 18.32, 3, '2024-11-14', 0);

PRINT '✓ Sample time series data populated successfully';

-- =============================================
-- STEP 8: BANKING STATISTICS
-- =============================================
PRINT 'Step 8: Populating banking statistics...';

-- Banking statistics for major banks (Q3 2024)
INSERT INTO BankingStatistics (BankID, ReportingDate, ReportingMonth, ReportingYear, 
    TotalAssets, TotalLoans, TotalDeposits, CustomerDeposits, InterbankDeposits,
    TotalEquity, NetIncome, InterestIncome, InterestExpense,
    NonPerformingLoans, NPLRatio, CapitalAdequacyRatio, LiquidityRatio,
    SubmittedDate, IsValidated, ValidatedBy, ValidationDate) VALUES
-- FNB Lesotho
(1, '2024-09-30', 9, 2024, 8500.5, 5200.3, 7200.8, 6800.5, 400.3, 850.2, 45.5, 420.3, 180.5, 260.1, 5.0, 15.8, 32.5, '2024-10-15', 1, 'John Mohapi', '2024-10-20'),
(1, '2024-06-30', 6, 2024, 8300.2, 5100.8, 7000.5, 6600.2, 400.3, 830.5, 42.3, 410.2, 175.8, 255.0, 5.0, 15.5, 31.8, '2024-07-15', 1, 'John Mohapi', '2024-07-20'),
(1, '2024-03-31', 3, 2024, 8100.8, 5000.5, 6800.2, 6400.8, 399.4, 810.3, 40.1, 400.5, 170.2, 250.0, 5.0, 15.3, 31.2, '2024-04-15', 1, 'John Mohapi', '2024-04-20'),

-- Nedbank Lesotho
(2, '2024-09-30', 9, 2024, 7200.8, 4300.5, 6100.3, 5750.2, 350.1, 720.5, 38.2, 350.8, 155.3, 215.0, 5.0, 16.2, 33.2, '2024-10-15', 1, 'John Mohapi', '2024-10-20'),
(2, '2024-06-30', 6, 2024, 7000.5, 4200.2, 5900.8, 5550.5, 350.3, 700.2, 35.8, 340.5, 150.2, 210.0, 5.0, 16.0, 32.8, '2024-07-15', 1, 'John Mohapi', '2024-07-20'),
(2, '2024-03-31', 3, 2024, 6800.3, 4100.8, 5700.5, 5350.2, 350.3, 680.5, 33.5, 330.2, 145.8, 205.0, 4.9, 15.8, 32.5, '2024-04-15', 1, 'John Mohapi', '2024-04-20'),

-- Standard Lesotho Bank
(3, '2024-09-30', 9, 2024, 9500.3, 6200.8, 8000.5, 7500.2, 500.3, 950.2, 52.3, 480.5, 210.3, 310.0, 5.0, 14.8, 30.5, '2024-10-15', 1, 'John Mohapi', '2024-10-20'),
(3, '2024-06-30', 6, 2024, 9300.8, 6100.5, 7800.2, 7300.8, 499.4, 930.5, 49.8, 470.2, 205.5, 305.0, 5.0, 14.5, 30.2, '2024-07-15', 1, 'John Mohapi', '2024-07-20'),
(3, '2024-03-31', 3, 2024, 9100.5, 6000.2, 7600.8, 7100.5, 500.3, 910.2, 47.5, 460.8, 200.3, 300.0, 5.0, 14.3, 29.8, '2024-04-15', 1, 'John Mohapi', '2024-04-20');

PRINT '✓ Banking statistics populated successfully';

-- =============================================
-- STEP 9: RESEARCH STAFF AND REPORTS
-- =============================================
PRINT 'Step 9: Populating research staff and reports...';

-- Research Staff
INSERT INTO ResearchStaff (EmployeeNumber, FirstName, LastName, JobTitle, Division, Specialization, EducationLevel, Email, Phone, HireDate) VALUES
('CBL-RES-001', 'Thabo', 'Molapo', 'Director of Research', 'Management', 'Macroeconomic Policy', 'PhD Economics', 'thabo.molapo@centralbank.org.ls', '+266 2231 7001', '2015-03-01'),
('CBL-RES-002', 'Mamello', 'Tau', 'Senior Statistician', 'Data Management Division', 'Economic Statistics', 'MSc Statistics', 'mamello.tau@centralbank.org.ls', '+266 2231 7002', '2018-06-15'),
('CBL-RES-003', 'Lerato', 'Mohapi', 'Data Analyst', 'Data Management Division', 'Data Analytics', 'MSc Statistics', 'lerato.mohapi@centralbank.org.ls', '+266 2231 7003', '2020-01-10'),
('CBL-RES-004', 'Mpho', 'Ntšo', 'Economist', 'Economic Research Division', 'Monetary Economics', 'MA Economics', 'mpho.ntso@centralbank.org.ls', '+266 2231 7004', '2019-08-20'),
('CBL-RES-005', 'Palesa', 'Ramokoena', 'Research Economist', 'Economic Research Division', 'Financial Markets', 'MSc Economics', 'palesa.ramokoena@centralbank.org.ls', '+266 2231 7005', '2021-02-01'),
('CBL-RES-006', 'Teboho', 'Mofolo', 'Junior Statistician', 'Data Management Division', 'Database Management', 'BSc Statistics', 'teboho.mofolo@centralbank.org.ls', '+266 2231 7006', '2023-07-01'),
('CBL-RES-007', 'Kabelo', 'Letsie', 'Data Quality Officer', 'Data Management Division', 'Data Quality Management', 'MSc Data Science', 'kabelo.letsie@centralbank.org.ls', '+266 2231 7007', '2022-03-15');

-- Macroeconomic Reports
INSERT INTO MacroeconomicReports (ReportTypeID, ReportTitle, ReportPeriod, ReportYear, ReportMonth,
    AuthorName, DivisionName, DraftDate, ReviewDate, ReviewedBy, ApprovalDate, ApprovedBy,
    PublicationDate, Status, IsPublic) VALUES
(1, 'Monthly Statistical Bulletin - November 2024', '2024-11-30', 2024, 11, 'Mamello Tau', 'Data Management Division',
    '2024-12-05', '2024-12-10', 'Thabo Molapo', '2024-12-12', 'Governor', '2024-12-15', 'Published', 1),
(1, 'Monthly Statistical Bulletin - October 2024', '2024-10-31', 2024, 10, 'Mamello Tau', 'Data Management Division',
    '2024-11-05', '2024-11-10', 'Thabo Molapo', '2024-11-12', 'Governor', '2024-11-15', 'Published', 1),
(2, 'Quarterly Economic Review - Q3 2024', '2024-09-30', 2024, NULL, 'Mpho Ntšo', 'Economic Research Division',
    '2024-10-15', '2024-10-25', 'Thabo Molapo', '2024-10-28', 'Governor', '2024-10-31', 'Published', 1),
(7, 'Inflation Report - November 2024', '2024-11-30', 2024, 11, 'Palesa Ramokoena', 'Economic Research Division',
    '2024-12-08', '2024-12-12', 'Thabo Molapo', '2024-12-14', 'Governor', '2024-12-16', 'Published', 1),
(5, 'Balance of Payments - Q3 2024', '2024-09-30', 2024, NULL, 'Lerato Mohapi', 'Data Management Division',
    '2024-10-20', '2024-10-28', 'Thabo Molapo', '2024-10-30', 'Governor', '2024-11-05', 'Published', 1);

PRINT '✓ Research staff and reports populated successfully';

-- =============================================
-- STEP 10: DATA DISSEMINATION RECORDS
-- =============================================
PRINT 'Step 10: Populating data dissemination records...';

INSERT INTO DataDissemination (DisseminationType, RecipientType, RecipientName, RecipientContact,
    DataCategory, ReportID, DisseminationDate, DeliveryMethod, ApprovedBy, Purpose) VALUES
('External', 'International Organization', 'International Monetary Fund', 'afr@imf.org',
    'Monetary Statistics', NULL, '2024-11-20', 'API', 'Thabo Molapo', 'IMF Article IV Consultation'),
('External', 'International Organization', 'World Bank', 'lesotho@worldbank.org',
    'Economic Indicators', NULL, '2024-11-15', 'Email', 'Thabo Molapo', 'Country Economic Memorandum'),
('Internal', 'Government Ministry', 'Ministry of Finance', 'psfinance@gov.ls',
    'Banking Statistics', 4, '2024-11-25', 'Email', 'Thabo Molapo', 'Budget Planning'),
('Public', 'Public', 'Website Publication', 'N/A',
    'Monthly Statistics', 1, '2024-12-15', 'Website', 'Governor', 'Public Dissemination'),
('Internal', 'Government Ministry', 'Ministry of Development Planning', 'planning@gov.ls',
    'GDP Statistics', NULL, '2024-11-10', 'Email', 'Thabo Molapo', 'National Development Plan'),
('External', 'Research Institution', 'National University of Lesotho', 'economics@nul.ls',
    'Economic Data', NULL, '2024-11-28', 'Portal', 'Thabo Molapo', 'Academic Research'),
('External', 'Commercial Bank', 'First National Bank Lesotho', 'research@fnb.co.ls',
    'Economic Indicators', 2, '2024-11-01', 'Email', 'Thabo Molapo', 'Market Analysis'),
('Public', 'Media', 'Lesotho Times', 'news@lestimes.co.ls',
    'Inflation Data', 4, '2024-12-16', 'Email', 'Governor', 'Press Release');

PRINT '✓ Data dissemination records populated successfully';
PRINT '';

-- =============================================
-- FINAL VERIFICATION
-- =============================================
USE CBL_DataWarehouse;
GO

PRINT '==============================================';
PRINT 'CBL DATA WAREHOUSE SETUP COMPLETE!';
PRINT '==============================================';
PRINT '';

-- Display summary statistics
PRINT 'DATABASE SUMMARY:';
PRINT '----------------------------------------';

SELECT 'Countries' as TableName, COUNT(*) as RecordCount FROM Countries
UNION ALL SELECT 'DataSources', COUNT(*) FROM DataSources
UNION ALL SELECT 'DataFrequencies', COUNT(*) FROM DataFrequencies
UNION ALL SELECT 'IndicatorCategories', COUNT(*) FROM IndicatorCategories
UNION ALL SELECT 'ReportTypes', COUNT(*) FROM ReportTypes
UNION ALL SELECT 'CommercialBanks', COUNT(*) FROM CommercialBanks
UNION ALL SELECT 'EconomicIndicators', COUNT(*) FROM EconomicIndicators
UNION ALL SELECT 'TimeSeriesData', COUNT(*) FROM TimeSeriesData
UNION ALL SELECT 'BankingStatistics', COUNT(*) FROM BankingStatistics
UNION ALL SELECT 'MacroeconomicReports', COUNT(*) FROM MacroeconomicReports
UNION ALL SELECT 'DataDissemination', COUNT(*) FROM DataDissemination
UNION ALL SELECT 'ResearchStaff', COUNT(*) FROM ResearchStaff;

PRINT '';
PRINT '==============================================';
PRINT 'Sample Verification Queries:';
PRINT '==============================================';

-- 1. Recent inflation data
PRINT '1. Recent Inflation Rates:';
SELECT TOP 6
    ts.PeriodDate,
    ei.IndicatorName,
    ts.DataValue as InflationRate,
    ts.IsProvisional
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE ei.IndicatorCode = 'INF-RATE'
ORDER BY ts.PeriodDate DESC;

PRINT '';
PRINT '2. Banking Sector Summary (Q3 2024):';
SELECT 
    cb.BankName,
    bs.TotalAssets,
    bs.TotalLoans,
    bs.TotalDeposits,
    bs.NPLRatio,
    bs.CapitalAdequacyRatio
FROM BankingStatistics bs
JOIN CommercialBanks cb ON bs.BankID = cb.BankID
WHERE bs.ReportingDate = '2024-09-30'
ORDER BY bs.TotalAssets DESC;

PRINT '';
PRINT '==============================================';
PRINT 'CBL Data Warehouse ready for training!';
PRINT 'Database designed for macroeconomic data management';
PRINT 'Research Department - Data Management Division';
PRINT '==============================================';
