-- =============================================
-- TechCorp Database: Fix Companies Table and Data
-- =============================================

USE TechCorpDB;
GO

PRINT 'Fixing Companies table structure and data...';

-- First, drop and recreate the Companies table to ensure clean structure
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Companies')
BEGIN
    PRINT 'Dropping existing Companies table...';
    DROP TABLE Companies;
END

PRINT 'Creating Companies table with correct structure...';

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
    CreditRating NVARCHAR(3) NULL, -- Changed from CHAR to NVARCHAR
    PaymentTerms TINYINT NOT NULL DEFAULT 30,
    PreferredCurrency NVARCHAR(3) NOT NULL DEFAULT 'USD', -- Changed from CHAR to NVARCHAR
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    ModifiedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (IndustryID) REFERENCES Industries(IndustryID),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

PRINT 'Companies table created successfully.';

-- Now insert the data with individual INSERT statements for better error handling
PRINT 'Inserting company data with error handling...';

BEGIN TRY
    -- Technology Companies
    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
        15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
        '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
        'AA-', 30, 'USD');
    PRINT 'Inserted: TechCorp Solutions';

    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('CloudTech Innovations', 'CloudTech Innovations LLC', 'CTI2018002', 1, 'Small', 2018,
        4200000.00, 65, 'www.cloudtechinnovations.com', 'hello@cloudtechinnovations.com', '+1-555-0150', 1,
        '800 Cloud Avenue', 'Seattle', 'Washington', '98101', 47.60621000, -122.33207000,
        'A+', 30, 'USD');
    PRINT 'Inserted: CloudTech Innovations';

    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('DevOps Masters', 'DevOps Masters Corporation', 'DOM2015003', 1, 'Medium', 2015,
        8750000.00, 95, 'www.devopsmasters.com', 'contact@devopsmasters.com', '+1-555-0175', 1,
        '500 Automation Boulevard', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
        'A', 45, 'USD');
    PRINT 'Inserted: DevOps Masters';

END TRY
BEGIN CATCH
    PRINT 'Error occurred during insert:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH

-- Check results
SELECT COUNT(*) as CompaniesCount FROM Companies;
SELECT TOP 3 CompanyID, CompanyName, LegalName, CreditRating, PreferredCurrency FROM Companies;

PRINT 'Companies table fix completed.';