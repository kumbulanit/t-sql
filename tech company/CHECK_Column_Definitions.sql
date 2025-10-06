-- =============================================
-- TechCorp Database: Column Analysis for Truncation Error
-- =============================================

USE TechCorpDB;
GO

-- Check column definitions
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Companies'
ORDER BY ORDINAL_POSITION;

-- Check if required lookup tables exist
SELECT 'Industries Count' as TableCheck, COUNT(*) as RecordCount FROM Industries;
SELECT 'Countries Count' as TableCheck, COUNT(*) as RecordCount FROM Countries;

-- Test data lengths for potential truncation issues
SELECT 
    'TechCorp Solutions Inc.' as TestValue,
    LEN('TechCorp Solutions Inc.') as Length,
    'LegalName max 150' as ColumnInfo
UNION ALL
SELECT 
    'www.techcorpsolutions.com',
    LEN('www.techcorpsolutions.com'),
    'Website max 255'
UNION ALL
SELECT 
    'info@techcorpsolutions.com',
    LEN('info@techcorpsolutions.com'),
    'PrimaryEmail max 100'
UNION ALL
SELECT 
    '1200 Innovation Drive',
    LEN('1200 Innovation Drive'),
    'StreetAddress max 255';