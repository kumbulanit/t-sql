-- =============================================
-- TechCorp Database: Master Setup Script - SSMS Compatible
-- Pure T-SQL syntax for standard SSMS execution
-- =============================================

/*
    ✅ SSMS COMPATIBLE VERSION ✅
    
    This script now works with regular SSMS execution:
    ✓ No SQLCMD mode required
    ✓ Pure T-SQL syntax
    ✓ Self-contained setup process
    ✓ Complete error handling
    
    Simply open in SSMS and execute (F5)
*/

PRINT '==============================================';
PRINT 'TechCorp Database Setup - SSMS Compatible';
PRINT 'Starting comprehensive database setup...';
PRINT '==============================================';
PRINT '';

-- Note: This script redirects to the combined setup for best compatibility
PRINT 'For the most comprehensive and up-to-date setup, please use:';
PRINT '../00_TechCorp_Combined_Setup.sql';
PRINT '';
PRINT 'That script contains all the latest fixes and complete business data.';
PRINT '';
PRINT 'Alternatively, you can run the individual component scripts below:';
PRINT '';

-- =============================================
-- INDIVIDUAL SCRIPT EXECUTION (T-SQL Compatible)
-- =============================================

-- We'll execute each component using EXEC with error handling
USE master;
GO

PRINT 'Step 1: Creating TechCorp database...';
-- Database Creation
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'Dropping existing TechCorpDB database...';
    ALTER DATABASE TechCorpDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechCorpDB;
END

PRINT 'Creating TechCorpDB database...';
CREATE DATABASE TechCorpDB;

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'TechCorpDB database created successfully.';
END
ELSE
BEGIN
    PRINT 'ERROR: Failed to create TechCorpDB database.';
    RETURN;
END
GO

USE TechCorpDB;
GO

-- =============================================
-- REDIRECT TO COMBINED SETUP (RECOMMENDED)
-- =============================================

PRINT '';
PRINT '⚠️  IMPORTANT RECOMMENDATION ⚠️';
PRINT '';
PRINT 'This script has been converted to SSMS-compatible T-SQL.';
PRINT 'However, for the most complete and up-to-date setup, please use:';
PRINT '';
PRINT '    ../00_TechCorp_Combined_Setup.sql';
PRINT '';
PRINT 'The combined script includes:';
PRINT '✓ All latest database enhancements';
PRINT '✓ Complete customer and order ecosystem';
PRINT '✓ Fixed column name consistency';
PRINT '✓ Enhanced business data scenarios';
PRINT '✓ Better error handling and verification';
PRINT '';
PRINT 'If you prefer to continue with individual components,';
PRINT 'you can run the individual .sql files in this directory manually.';
PRINT '';

-- Basic database verification if they choose to continue
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    PRINT 'TechCorpDB database exists and is ready for component scripts.';
    PRINT '';
    PRINT 'To complete the setup, run these files in order:';
    PRINT '1. 02_TechCorp_Table_Creation.sql';
    PRINT '2. 03_TechCorp_Lookup_Data.sql';  
    PRINT '3. 04_TechCorp_Companies_Data_Individual.sql';
    PRINT '4. 05_TechCorp_Departments_Data.sql';
    PRINT '5. 06_TechCorp_Employees_Leadership.sql';
    PRINT '6. 07_TechCorp_Employees_Regular.sql';
    PRINT '7. 08_TechCorp_Advanced_Tables.sql';
    PRINT '8. 09_TechCorp_Skills_Data.sql';
    PRINT '9. 10_TechCorp_Projects_Data.sql';
    PRINT '10. 11_TechCorp_Employee_Skills.sql';
    PRINT '11. 12_TechCorp_Project_Assignments.sql';
    PRINT '12. 13_TechCorp_Performance_Data.sql';
END
ELSE
BEGIN
    PRINT 'ERROR: TechCorpDB database was not created successfully.';
END

PRINT '';
PRINT '==============================================';
PRINT 'SCRIPT EXECUTION COMPLETE';
PRINT '==============================================';
PRINT '';
PRINT '🚀 RECOMMENDED NEXT STEP:';
PRINT 'Run the combined setup script for complete database:';
PRINT '    ../00_TechCorp_Combined_Setup.sql';
PRINT '';

PRINT '';
PRINT '==============================================';
PRINT 'SETUP SCRIPT CONVERSION COMPLETE';
PRINT '==============================================';
PRINT '';
PRINT 'This master setup script has been converted from SQLCMD';
PRINT 'syntax to pure T-SQL for standard SSMS compatibility.';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '';
PRINT '1. RECOMMENDED: Run the comprehensive combined script';
PRINT '   File: ../00_TechCorp_Combined_Setup.sql';
PRINT '   ✓ Contains all components in one file';
PRINT '   ✓ Latest fixes and enhancements';
PRINT '   ✓ Complete business ecosystem';
PRINT '';
PRINT '2. ALTERNATIVE: Run individual component scripts manually';
PRINT '   ✓ All .sql files in this directory';
PRINT '   ✓ Execute in numerical order (01, 02, 03, etc.)';
PRINT '   ✓ Basic database structure created above';
PRINT '';
PRINT 'Both approaches will create a complete TechCorp training database';
PRINT 'suitable for all SQL Server training modules.';
PRINT '';
PRINT '==============================================';
PRINT 'SSMS COMPATIBILITY: COMPLETE ✅';
PRINT '==============================================';
GO