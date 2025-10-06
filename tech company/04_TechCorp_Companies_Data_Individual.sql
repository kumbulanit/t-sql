-- =============================================
-- TechCorp Database: Companies Data with Individual Inserts
-- Module 2-3: Core Business Entities
-- =============================================

USE TechCorpDB;
GO

PRINT 'Populating Companies table with individual inserts...';

-- Verify prerequisite tables have data
IF (SELECT COUNT(*) FROM Countries) = 0
BEGIN
    PRINT 'ERROR: Countries table is empty. Please run 03_TechCorp_Lookup_Data.sql first.';
    RETURN;
END

IF (SELECT COUNT(*) FROM Industries) = 0
BEGIN
    PRINT 'ERROR: Industries table is empty. Please run 03_TechCorp_Lookup_Data.sql first.';
    RETURN;
END

-- Clear existing data if any
DELETE FROM Companies;
PRINT 'Existing company data cleared.';

-- Insert companies one by one with error handling
BEGIN TRY
    -- Company 1: TechCorp Solutions
    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
        15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
        '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
        'AA-', 30, 'USD');
    PRINT 'SUCCESS: TechCorp Solutions inserted';
    
END TRY
BEGIN CATCH
    PRINT 'ERROR inserting TechCorp Solutions:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH

BEGIN TRY
    -- Company 2: CloudTech Innovations
    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('CloudTech Innovations', 'CloudTech Innovations LLC', 'CTI2018002', 1, 'Small', 2018,
        4200000.00, 65, 'www.cloudtechinnovations.com', 'hello@cloudtechinnovations.com', '+1-555-0150', 1,
        '800 Cloud Avenue', 'Seattle', 'Washington', '98101', 47.60621000, -122.33207000,
        'A+', 30, 'USD');
    PRINT 'SUCCESS: CloudTech Innovations inserted';
    
END TRY
BEGIN CATCH
    PRINT 'ERROR inserting CloudTech Innovations:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH

BEGIN TRY
    -- Company 3: DevOps Masters
    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('DevOps Masters', 'DevOps Masters Corporation', 'DOM2015003', 1, 'Medium', 2015,
        8750000.00, 95, 'www.devopsmasters.com', 'contact@devopsmasters.com', '+1-555-0175', 1,
        '500 Automation Boulevard', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
        'A', 45, 'USD');
    PRINT 'SUCCESS: DevOps Masters inserted';
    
END TRY
BEGIN CATCH
    PRINT 'ERROR inserting DevOps Masters:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH

-- Check results
DECLARE @CompanyCount INT = (SELECT COUNT(*) FROM Companies);
PRINT 'Total companies inserted: ' + CAST(@CompanyCount AS VARCHAR(10));

IF @CompanyCount > 0
BEGIN
    PRINT 'Sample company data:';
    SELECT TOP 3 CompanyID, CompanyName, LegalName, CreditRating, PreferredCurrency FROM Companies;
END

PRINT 'Companies data population test completed.';