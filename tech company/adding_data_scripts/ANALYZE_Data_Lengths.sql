-- =============================================
-- TechCorp Database: Detailed Data Length Analysis
-- =============================================

USE TechCorpDB;
GO

-- Get exact column specifications
SELECT 
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.CHARACTER_MAXIMUM_LENGTH,
    c.NUMERIC_PRECISION,
    c.NUMERIC_SCALE,
    c.IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME = 'Companies'
ORDER BY c.ORDINAL_POSITION;

PRINT '=== Testing data lengths for first company record ===';

-- Test each value from the first company record
SELECT 
    'CompanyName' as Field,
    'TechCorp Solutions' as Value,
    LEN('TechCorp Solutions') as ActualLength,
    100 as MaxLength,
    CASE WHEN LEN('TechCorp Solutions') > 100 THEN 'TOO LONG' ELSE 'OK' END as Status
UNION ALL
SELECT 
    'LegalName',
    'TechCorp Solutions Inc.',
    LEN('TechCorp Solutions Inc.'),
    150,
    CASE WHEN LEN('TechCorp Solutions Inc.') > 150 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'TaxID',
    'TC2016001',
    LEN('TC2016001'),
    20,
    CASE WHEN LEN('TC2016001') > 20 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'Website',
    'www.techcorpsolutions.com',
    LEN('www.techcorpsolutions.com'),
    255,
    CASE WHEN LEN('www.techcorpsolutions.com') > 255 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'PrimaryEmail',
    'info@techcorpsolutions.com',
    LEN('info@techcorpsolutions.com'),
    100,
    CASE WHEN LEN('info@techcorpsolutions.com') > 100 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'PrimaryPhone',
    '+1-555-0100',
    LEN('+1-555-0100'),
    20,
    CASE WHEN LEN('+1-555-0100') > 20 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'StreetAddress',
    '1200 Innovation Drive',
    LEN('1200 Innovation Drive'),
    255,
    CASE WHEN LEN('1200 Innovation Drive') > 255 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'City',
    'San Francisco',
    LEN('San Francisco'),
    100,
    CASE WHEN LEN('San Francisco') > 100 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'StateProvince',
    'California',
    LEN('California'),
    100,
    CASE WHEN LEN('California') > 100 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'PostalCode',
    '94107',
    LEN('94107'),
    20,
    CASE WHEN LEN('94107') > 20 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'CreditRating',
    'AA-',
    LEN('AA-'),
    3,
    CASE WHEN LEN('AA-') > 3 THEN 'TOO LONG' ELSE 'OK' END
UNION ALL
SELECT 
    'PreferredCurrency',
    'USD',
    LEN('USD'),
    3,
    CASE WHEN LEN('USD') > 3 THEN 'TOO LONG' ELSE 'OK' END;

-- Test if foreign key values exist
PRINT '=== Testing foreign key references ===';
SELECT 'IndustryID 1 exists' as Test, CASE WHEN EXISTS(SELECT 1 FROM Industries WHERE IndustryID = 1) THEN 'YES' ELSE 'NO' END as Result
UNION ALL
SELECT 'CountryID 1 exists', CASE WHEN EXISTS(SELECT 1 FROM Countries WHERE CountryID = 1) THEN 'YES' ELSE 'NO' END;