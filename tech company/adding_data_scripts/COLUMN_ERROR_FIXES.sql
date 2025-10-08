-- TechCorp Database Column Reference Quick Fix Guide
-- Run this to identify missing columns and ambiguous references

USE TechCorpDB;
GO

PRINT '=== COLUMN VALIDATION AND ERROR FIXES ===';
PRINT '';

-- 1. Check if tables exist and their column structures
PRINT '1. VERIFYING TABLE EXISTENCE:';
PRINT '=============================';

SELECT 
    TABLE_NAME,
    'Exists' as Status
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '2. CHECKING FOR COMMON PROBLEMATIC COLUMNS:';
PRINT '===========================================';

-- Check for EmployeeID columns
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%EmployeeID%'
ORDER BY TABLE_NAME, COLUMN_NAME;

PRINT '';
PRINT '3. CHECKING FOR IsActive COLUMNS (Ambiguous Reference Issue):';
PRINT '============================================================';

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'IsActive'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '4. CHECKING FOR CompanyName AND ContactName COLUMNS:';
PRINT '====================================================';

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('CompanyName', 'ContactName')
ORDER BY TABLE_NAME, COLUMN_NAME;

PRINT '';
PRINT '5. SAMPLE CORRECTED QUERIES:';
PRINT '=============================';

-- Example 1: Employees query (fixing EmployeeID reference)
PRINT 'Correct Employee Query:';
PRINT 'SELECT e.EmployeeID, e.FirstName, e.LastName, e.JobTitle';
PRINT 'FROM Employees e';
PRINT 'WHERE e.IsActive = 1;';
PRINT '';

-- Example 2: Fixing ambiguous IsActive (multiple tables have this column)
PRINT 'Correct Multi-table Query with IsActive (avoiding ambiguity):';
PRINT 'SELECT ';
PRINT '    e.EmployeeID,';
PRINT '    e.FirstName,';
PRINT '    e.LastName,';
PRINT '    d.DepartmentName,';
PRINT '    e.IsActive as EmployeeIsActive,';
PRINT '    d.IsActive as DepartmentIsActive';
PRINT 'FROM Employees e';
PRINT 'INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID';
PRINT 'WHERE e.IsActive = 1 AND d.IsActive = 1;';
PRINT '';

-- Example 3: Companies and Customers (fixing CompanyName/ContactName)
PRINT 'Correct Company-Customer Query:';
PRINT 'SELECT ';
PRINT '    c.CompanyName,';
PRINT '    cust.CustomerName,';
PRINT '    cust.ContactFirstName,';
PRINT '    cust.ContactLastName';
PRINT 'FROM Companies c';
PRINT 'INNER JOIN Customers cust ON c.CompanyID = cust.CompanyID';
PRINT 'WHERE c.IsActive = 1;';
PRINT '';

PRINT '6. COMMON ERROR PATTERNS AND FIXES:';
PRINT '===================================';
PRINT '';
PRINT 'ERROR: "Invalid column name ''EmployeeID''" ';
PRINT 'FIX: Make sure you are selecting from Employees table or joining properly';
PRINT '     Use: SELECT e.EmployeeID FROM Employees e';
PRINT '';
PRINT 'ERROR: "Ambiguous column name ''IsActive''"';
PRINT 'FIX: Use table aliases: e.IsActive, d.IsActive, c.IsActive';
PRINT '     Multiple tables have IsActive columns';
PRINT '';
PRINT 'ERROR: "Invalid column name ''CompanyName''"';
PRINT 'FIX: CompanyName exists in Companies table, not Customers';
PRINT '     Use proper JOIN: Companies c JOIN Customers cust ON c.CompanyID = cust.CompanyID';
PRINT '';
PRINT 'ERROR: "Invalid column name ''ContactName''"';
PRINT 'FIX: Customers table has ContactFirstName and ContactLastName, not ContactName';
PRINT '     Use: cust.ContactFirstName + '' '' + cust.ContactLastName as ContactName';

PRINT '';
PRINT '=== VALIDATION COMPLETE ===';
PRINT 'Check the output above to fix your specific query errors.';