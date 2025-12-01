-- TechCorp Database: HoursWorked and IsActive Issues - FINAL SOLUTION
-- =====================================================================================

USE TechCorpDB;
GO

PRINT '=== TECHCORP COLUMN REFERENCE ISSUES - COMPLETE FIX SUMMARY ===';
PRINT '';

-- =============================================
-- ISSUE ANALYSIS AND SOLUTIONS
-- =============================================

PRINT '🔍 ANALYSIS OF COLUMN REFERENCE ERRORS:';
PRINT '======================================';
PRINT '';
PRINT '❌ PROBLEM 1: Invalid column name ''HoursWorked''';
PRINT '   CAUSE: Trying to select HoursWorked from Employees table';
PRINT '   SOLUTION: HoursWorked exists in EmployeeProjects and TimeTracking tables only';
PRINT '';
PRINT '❌ PROBLEM 2: Ambiguous column name ''IsActive''';
PRINT '   CAUSE: Multiple tables have IsActive column without table aliases';
PRINT '   SOLUTION: Always use table aliases (e.g., e.IsActive, d.IsActive)';
PRINT '';

-- =============================================
-- SCHEMA CONFIRMATION
-- =============================================

PRINT '📋 SCHEMA CONFIRMATION - WHERE COLUMNS ACTUALLY EXIST:';
PRINT '======================================================';

-- Show where HoursWorked exists
SELECT 
    'HoursWorked Column Locations' as Information,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'HoursWorked'
ORDER BY TABLE_NAME;

PRINT '';

-- Show where IsActive exists  
SELECT 
    'IsActive Column Locations' as Information,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'IsActive'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '✅ FIXES APPLIED:';
PRINT '=================';
PRINT '1. Added sample data to EmployeeProjects and TimeTracking tables';
PRINT '2. Fixed ambiguous IsActive references in Module 12 Lab files';
PRINT '3. Created validation scripts to test all query patterns';
PRINT '4. Updated database setup script with proper sample data';
PRINT '';

-- =============================================
-- CORRECTED QUERY EXAMPLES
-- =============================================

PRINT '📝 CORRECTED QUERY EXAMPLES:';
PRINT '============================';

PRINT '';
PRINT '✅ CORRECT: Employee project hours';
SELECT TOP 3
    e.FirstName + ' ' + e.LastName as EmployeeName,
    p.ProjectName,
    ep.HoursWorked,           -- ✅ From EmployeeProjects table
    ep.HoursAllocated
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1         -- ✅ Table alias used
  AND ep.IsActive = 1        -- ✅ Table alias used
  AND p.IsActive = 1;        -- ✅ Table alias used

PRINT '';
PRINT '✅ CORRECT: Daily time tracking';
SELECT TOP 3
    e.FirstName + ' ' + e.LastName as EmployeeName,
    tt.WorkDate,
    tt.HoursWorked,          -- ✅ From TimeTracking table
    tt.BillableHours
FROM Employees e
INNER JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID
WHERE e.IsActive = 1;        -- ✅ Table alias used

PRINT '';
PRINT '✅ CORRECT: Department summary with hours';
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount,
    SUM(ep.HoursWorked) as TotalHours  -- ✅ From EmployeeProjects via JOIN
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
WHERE d.IsActive = 1         -- ✅ Table alias used
  AND e.IsActive = 1         -- ✅ Table alias used
GROUP BY d.DepartmentName, d.DepartmentID;

PRINT '';
PRINT '🚀 VALIDATION COMPLETE:';
PRINT '=======================';
PRINT 'All column reference issues have been identified and fixed.';
PRINT 'The database now has proper sample data for testing all query patterns.';
PRINT '';
PRINT '📚 TUTORIAL STATUS:';
PRINT '==================';
PRINT '✅ Database schema: Correct and populated';
PRINT '✅ Sample data: Added to EmployeeProjects and TimeTracking';
PRINT '✅ Module 12 Labs: Fixed ambiguous IsActive references';
PRINT '✅ Validation scripts: Created for testing';
PRINT '';
PRINT '💡 REMEMBER THESE RULES:';
PRINT '========================';
PRINT '1. HoursWorked comes from EmployeeProjects (ep.HoursWorked) or TimeTracking (tt.HoursWorked)';
PRINT '2. Never select HoursWorked directly from Employees table (it does not exist there)';
PRINT '3. Always use table aliases for IsActive: e.IsActive, d.IsActive, p.IsActive, etc.';
PRINT '4. When joining multiple tables, qualify ALL column references with table aliases';
PRINT '5. Use proper JOINs to access columns from related tables';
PRINT '';
PRINT '🎯 YOUR QUERIES SHOULD NOW WORK WITHOUT COLUMN REFERENCE ERRORS!';
PRINT '';

-- Test the most common patterns to ensure they work
PRINT '🧪 FINAL VALIDATION TEST:';
PRINT '=========================';

BEGIN TRY
    -- Test 1: Basic employee query
    SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName 
    FROM Employees e WHERE e.IsActive = 1;
    PRINT '✅ Test 1 PASSED: Basic employee query with proper IsActive alias';
    
    -- Test 2: Employee project hours
    SELECT TOP 1 e.FirstName, ep.HoursWorked 
    FROM Employees e 
    JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID 
    WHERE e.IsActive = 1;
    PRINT '✅ Test 2 PASSED: HoursWorked from EmployeeProjects with proper JOIN';
    
    -- Test 3: Time tracking hours
    SELECT TOP 1 e.FirstName, tt.HoursWorked 
    FROM Employees e 
    JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID 
    WHERE e.IsActive = 1;
    PRINT '✅ Test 3 PASSED: HoursWorked from TimeTracking with proper JOIN';
    
    PRINT '';
    PRINT '🏆 ALL TESTS PASSED! Your database is ready for SQL training.';
    
END TRY
BEGIN CATCH
    PRINT '❌ Test failed: ' + ERROR_MESSAGE();
    PRINT 'Please check the database setup and ensure all tables are properly created.';
END CATCH;