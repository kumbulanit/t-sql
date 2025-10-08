-- TechCorp Database: Comprehensive Column Reference Validation
-- This script validates all common query patterns and provides working examples

USE TechCorpDB;
GO

PRINT '=== TECHCORP DATABASE COLUMN VALIDATION ===';
PRINT 'Testing all common query patterns that might cause column reference errors...';
PRINT '';

-- =============================================
-- TEST 1: BASIC EMPLOYEE QUERIES (Module 2-3)
-- =============================================
PRINT '1. TESTING BASIC EMPLOYEE QUERIES:';
PRINT '==================================';

-- ✅ CORRECT: Basic employee selection
BEGIN TRY
    SELECT TOP 3
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.JobTitle,
        e.BaseSalary
    FROM Employees e
    WHERE e.IsActive = 1
    ORDER BY e.LastName;
    
    PRINT '✅ Basic employee query: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ Basic employee query: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 2: EMPLOYEE-DEPARTMENT JOINS (Module 4)
-- =============================================
PRINT '';
PRINT '2. TESTING EMPLOYEE-DEPARTMENT JOINS:';
PRINT '====================================';

-- ✅ CORRECT: Employee-Department JOIN with proper IsActive
BEGIN TRY
    SELECT TOP 3
        e.FirstName + ' ' + e.LastName as EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        d.Location,
        e.IsActive as EmployeeActive,
        d.IsActive as DepartmentActive
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1 AND d.IsActive = 1
    ORDER BY d.DepartmentName, e.LastName;
    
    PRINT '✅ Employee-Department JOIN: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ Employee-Department JOIN: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 3: HOURSWORKED FROM EMPLOYEEPROJECTS (Module 4-6)
-- =============================================
PRINT '';
PRINT '3. TESTING HOURSWORKED FROM EMPLOYEEPROJECTS:';
PRINT '============================================';

-- ✅ CORRECT: HoursWorked from EmployeeProjects table
BEGIN TRY
    SELECT TOP 5
        e.FirstName + ' ' + e.LastName as EmployeeName,
        p.ProjectName,
        ep.Role,
        ep.HoursWorked,
        ep.HoursAllocated,
        ep.AllocationPercentage
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE e.IsActive = 1 AND ep.IsActive = 1 AND p.IsActive = 1
    ORDER BY ep.HoursWorked DESC;
    
    PRINT '✅ HoursWorked from EmployeeProjects: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ HoursWorked from EmployeeProjects: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 4: HOURSWORKED FROM TIMETRACKING (Advanced)
-- =============================================
PRINT '';
PRINT '4. TESTING HOURSWORKED FROM TIMETRACKING:';
PRINT '========================================';

-- ✅ CORRECT: HoursWorked from TimeTracking table
BEGIN TRY
    SELECT TOP 5
        e.FirstName + ' ' + e.LastName as EmployeeName,
        tt.WorkDate,
        tt.HoursWorked,
        tt.BillableHours,
        tt.ActivityType,
        p.ProjectName
    FROM Employees e
    INNER JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID
    LEFT JOIN Projects p ON tt.ProjectID = p.ProjectID
    WHERE e.IsActive = 1
    ORDER BY tt.WorkDate DESC;
    
    PRINT '✅ HoursWorked from TimeTracking: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ HoursWorked from TimeTracking: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 5: AGGREGATION WITH PROPER COLUMN REFERENCES (Module 9)
-- =============================================
PRINT '';
PRINT '5. TESTING AGGREGATION QUERIES:';
PRINT '==============================';

-- ✅ CORRECT: Department aggregation with proper aliases
BEGIN TRY
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) as EmployeeCount,
        AVG(e.BaseSalary) as AvgSalary,
        SUM(ISNULL(ep.HoursWorked, 0)) as TotalProjectHours
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
    WHERE d.IsActive = 1 AND e.IsActive = 1
    GROUP BY d.DepartmentName, d.DepartmentID
    ORDER BY TotalProjectHours DESC;
    
    PRINT '✅ Department aggregation: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ Department aggregation: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 6: COMPLEX MULTI-TABLE JOINS (Advanced Modules)
-- =============================================
PRINT '';
PRINT '6. TESTING COMPLEX MULTI-TABLE JOINS:';
PRINT '====================================';

-- ✅ CORRECT: Complex join with all proper aliases
BEGIN TRY
    SELECT TOP 3
        co.CompanyName,
        d.DepartmentName,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        p.ProjectName,
        ep.Role,
        ep.HoursWorked,
        co.IsActive as CompanyActive,
        d.IsActive as DepartmentActive,
        e.IsActive as EmployeeActive,
        p.IsActive as ProjectActive,
        ep.IsActive as AssignmentActive
    FROM Companies co
    INNER JOIN Departments d ON co.CompanyID = d.CompanyID
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE co.IsActive = 1 
      AND d.IsActive = 1 
      AND e.IsActive = 1 
      AND p.IsActive = 1 
      AND ep.IsActive = 1
    ORDER BY ep.HoursWorked DESC;
    
    PRINT '✅ Complex multi-table join: SUCCESS';
END TRY
BEGIN CATCH
    PRINT '❌ Complex multi-table join: FAILED - ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- TEST 7: COMMON ERROR PATTERNS (Should Fail)
-- =============================================
PRINT '';
PRINT '7. TESTING COMMON ERROR PATTERNS (These should fail):';
PRINT '====================================================';

-- ❌ WRONG: Trying to get HoursWorked directly from Employees table
PRINT '❌ Testing invalid HoursWorked from Employees...';
BEGIN TRY
    -- This should fail because Employees table has no HoursWorked column
    SELECT TOP 1 e.EmployeeID, e.HoursWorked FROM Employees e;
    PRINT '❌ ERROR: This should have failed! HoursWorked does not exist in Employees table.';
END TRY
BEGIN CATCH
    PRINT '✅ EXPECTED ERROR: ' + ERROR_MESSAGE() + ' (This is correct - Employees has no HoursWorked column)';
END CATCH;

-- ❌ WRONG: Ambiguous IsActive reference (commented out to prevent errors)
PRINT '❌ Example of ambiguous IsActive reference (not executed):';
PRINT 'WRONG: SELECT TOP 1 e.EmployeeID FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE IsActive = 1;';
PRINT 'ERROR: Ambiguous column name ''IsActive'' - both tables have this column';

-- ✅ CORRECT: Fixed version with proper table aliases
PRINT '✅ CORRECT version with proper table aliases:';
BEGIN TRY
    SELECT TOP 1 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        d.DepartmentName,
        e.IsActive AS EmployeeActive,
        d.IsActive AS DepartmentActive
    FROM Employees e 
    JOIN Departments d ON e.DepartmentID = d.DepartmentID 
    WHERE e.IsActive = 1 AND d.IsActive = 1;
    PRINT '✅ SUCCESS: Ambiguous IsActive issue resolved with table aliases';
END TRY
BEGIN CATCH
    PRINT '❌ UNEXPECTED ERROR: ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- SUMMARY AND RECOMMENDATIONS
-- =============================================
PRINT '';
PRINT '=== VALIDATION SUMMARY ===';
PRINT 'If all ✅ tests passed and ❌ tests failed as expected, your database schema is correct.';
PRINT '';
PRINT '📋 CORRECT PATTERNS TO USE:';
PRINT '';
PRINT '1. HoursWorked Column References:';
PRINT '   ✅ ep.HoursWorked (from EmployeeProjects table)';
PRINT '   ✅ tt.HoursWorked (from TimeTracking table)';
PRINT '   ❌ e.HoursWorked (Employees table - does not exist)';
PRINT '';
PRINT '2. IsActive Column References:';
PRINT '   ✅ e.IsActive (Employees table)';
PRINT '   ✅ d.IsActive (Departments table)';
PRINT '   ✅ p.IsActive (Projects table)';
PRINT '   ✅ c.IsActive (Companies table)';
PRINT '   ✅ ep.IsActive (EmployeeProjects table)';
PRINT '   ❌ IsActive (without table alias - ambiguous)';
PRINT '';
PRINT '3. Required JOINs for HoursWorked:';
PRINT '   - To get project hours: JOIN EmployeeProjects';
PRINT '   - To get time tracking hours: JOIN TimeTracking';
PRINT '   - Never select HoursWorked directly from Employees';
PRINT '';
PRINT '4. Always use table aliases in multi-table queries:';
PRINT '   - Prevents ambiguous column references';
PRINT '   - Makes queries more readable';
PRINT '   - Required when same column exists in multiple tables';
PRINT '';
PRINT 'If you are still getting errors, check:';
PRINT '1. Are you using the correct table for HoursWorked?';
PRINT '2. Do you have proper JOINs to access related table columns?';
PRINT '3. Are you using table aliases for IsActive columns?';
PRINT '4. Is your database schema properly created with sample data?';