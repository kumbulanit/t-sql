-- =============================================
-- TechCorp Database: Data Validation and Error Diagnosis
-- Troubleshooting Script
-- =============================================

USE TechCorpDB;
GO

-- Check if prerequisite tables exist and have data
PRINT 'Checking prerequisite tables...';

-- Check Countries table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Countries')
BEGIN
    PRINT 'Countries table exists';
    SELECT COUNT(*) as CountryCount FROM Countries;
    IF (SELECT COUNT(*) FROM Countries) = 0
        PRINT 'WARNING: Countries table is empty!';
END
ELSE
    PRINT 'ERROR: Countries table does not exist!';

-- Check Industries table  
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Industries')
BEGIN
    PRINT 'Industries table exists';
    SELECT COUNT(*) as IndustryCount FROM Industries;
    IF (SELECT COUNT(*) FROM Industries) = 0
        PRINT 'WARNING: Industries table is empty!';
END
ELSE
    PRINT 'ERROR: Industries table does not exist!';

-- Check Companies table structure
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Companies')
BEGIN
    PRINT 'Companies table exists - checking column lengths:';
    
    SELECT 
        c.COLUMN_NAME,
        c.DATA_TYPE,
        c.CHARACTER_MAXIMUM_LENGTH,
        c.IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_NAME = 'Companies'
    ORDER BY c.ORDINAL_POSITION;
END
ELSE
    PRINT 'ERROR: Companies table does not exist!';

-- Test a single company insert to identify the problematic field
PRINT '';
PRINT 'Testing single company insert...';

BEGIN TRY
    INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
        AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
        StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
        CreditRating, PaymentTerms, PreferredCurrency) VALUES
    ('Test Company', 'Test Company Inc.', 'TEST001', 1, 'Small', 2020, 
        1000000.00, 10, 'www.testcompany.com', 'test@testcompany.com', '+1-555-0000', 1,
        '123 Test Street', 'Test City', 'Test State', '12345', 0.00000000, 0.00000000,
        'A', 30, 'USD');
    
    PRINT 'Single insert successful!';
    
    -- Clean up test record
    DELETE FROM Companies WHERE CompanyName = 'Test Company';
    
END TRY
BEGIN CATCH
    PRINT 'Single insert failed with error:';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
END CATCH;

-- Check for foreign key constraint issues
PRINT '';
PRINT 'Checking foreign key constraints...';

-- Check if IndustryID = 1 exists
IF EXISTS (SELECT * FROM Industries WHERE IndustryID = 1)
    PRINT 'IndustryID = 1 exists';
ELSE
    PRINT 'ERROR: IndustryID = 1 does not exist in Industries table!';

-- Check if CountryID = 1 exists  
IF EXISTS (SELECT * FROM Countries WHERE CountryID = 1)
    PRINT 'CountryID = 1 exists';
ELSE
    PRINT 'ERROR: CountryID = 1 does not exist in Countries table!';

PRINT '';
PRINT 'Diagnosis complete. Check the output above for issues.';