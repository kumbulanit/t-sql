-- =============================================
-- TechCorp Database: Test Single Company Insert
-- =============================================

USE TechCorpDB;
GO

-- Test single company insert to identify truncation issue
INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
    AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
    StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
    CreditRating, PaymentTerms, PreferredCurrency) VALUES
('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
    15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
    '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
    'AA-', 30, 'USD');

-- Verify the insert
SELECT * FROM Companies WHERE CompanyName = 'TechCorp Solutions';

PRINT 'Single company test completed successfully.';