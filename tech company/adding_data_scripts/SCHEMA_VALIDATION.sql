-- TechCorp Database Schema Validation and Error Fix Script
-- Run this script to identify and fix common schema issues

USE TechCorpDB;
GO

PRINT '=== TechCorp Database Schema Validation ===';
PRINT 'Checking for common issues causing data type conversion errors...';
PRINT '';

-- 1. Check table structures and column data types
PRINT '1. TABLE STRUCTURES AND COLUMN VALIDATION:';
PRINT '==========================================';

-- Check for IsActive columns (should be BIT, not VARCHAR)
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'IsActive'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '2. STATUS COLUMNS (String values):';
PRINT '===================================';

-- Check for Status columns (should be VARCHAR/NVARCHAR for string values)
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Status%'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '3. HOURS-RELATED COLUMNS:';
PRINT '=========================';

-- Check for hours-related columns
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Hours%' 
   OR COLUMN_NAME LIKE '%Allocation%'
ORDER BY TABLE_NAME, COLUMN_NAME;

PRINT '';
PRINT '4. SAMPLE DATA VALIDATION:';
PRINT '==========================';

-- Check Projects table for correct data types
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Projects')
BEGIN
    PRINT 'Projects table - Status and IsActive columns:';
    SELECT TOP 5
        ProjectID,
        ProjectName,
        Status,        -- This should contain string values like 'Active'
        IsActive,      -- This should contain BIT values (1/0)
        CASE 
            WHEN IsActive = 1 THEN 'Active Record'
            ELSE 'Inactive Record'
        END AS RecordStatus
    FROM Projects;
END
ELSE
BEGIN
    PRINT 'Projects table not found!';
END

PRINT '';

-- Check EmployeeProjects for allocation information
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeProjects')
BEGIN
    PRINT 'EmployeeProjects table - Allocation columns:';
    SELECT TOP 5
        EmployeeID,
        ProjectID,
        Role,
        AllocationPercentage,  -- This is the correct column for hours allocation
        IsActive
    FROM EmployeeProjects;
END
ELSE
BEGIN
    PRINT 'EmployeeProjects table not found!';
END

PRINT '';

-- Check TimeTracking for hours information
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TimeTracking')
BEGIN
    PRINT 'TimeTracking table - Hours columns:';
    SELECT TOP 5
        EmployeeID,
        ProjectID,
        WorkDate,
        HoursWorked,     -- Actual hours worked
        BillableHours,   -- Billable hours
        ActivityType
    FROM TimeTracking
    ORDER BY WorkDate DESC;
END
ELSE
BEGIN
    PRINT 'TimeTracking table not found - this might be in advanced schema only.';
END

PRINT '';
PRINT '5. COMMON ERROR FIXES:';
PRINT '======================';

PRINT 'If you are getting "Conversion failed when converting varchar ''Active'' to data type bit":';
PRINT '- Use: WHERE IsActive = 1 (not WHERE IsActive = ''Active'')';
PRINT '- Use: UPDATE Projects SET Status = ''Active'' (not SET IsActive = ''Active'')';
PRINT '';

PRINT 'If you are getting "Invalid column name ''hoursAllocated''":';
PRINT '- Use: AllocationPercentage from EmployeeProjects table';
PRINT '- Use: HoursWorked from TimeTracking table';
PRINT '- Use: EstimatedHours/ActualHours from Projects table (if available)';
PRINT '';

PRINT '6. RECOMMENDED QUERY PATTERNS:';
PRINT '==============================';

PRINT 'For active projects with team allocation:';
PRINT 'SELECT p.ProjectName, p.Status, COUNT(ep.EmployeeID) as TeamSize';
PRINT 'FROM Projects p';
PRINT 'LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID AND ep.IsActive = 1';
PRINT 'WHERE p.IsActive = 1';
PRINT 'GROUP BY p.ProjectID, p.ProjectName, p.Status;';
PRINT '';

PRINT 'For employee project hours (if TimeTracking exists):';
PRINT 'SELECT e.FirstName + '' '' + e.LastName as EmployeeName,';
PRINT '       p.ProjectName,';
PRINT '       ep.AllocationPercentage,';
PRINT '       ISNULL(SUM(tt.HoursWorked), 0) as TotalHours';
PRINT 'FROM Employees e';
PRINT 'INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID';
PRINT 'INNER JOIN Projects p ON ep.ProjectID = p.ProjectID';
PRINT 'LEFT JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID AND p.ProjectID = tt.ProjectID';
PRINT 'WHERE e.IsActive = 1 AND ep.IsActive = 1';
PRINT 'GROUP BY e.EmployeeID, e.FirstName, e.LastName, p.ProjectName, ep.AllocationPercentage;';

PRINT '';
PRINT '=== Validation Complete ===';
PRINT 'Review the output above to identify any schema issues.';
PRINT 'Use ERROR_FIXES.md for detailed solutions.';