-- TechCorp Database: HoursWorked and IsActive Column Reference Fix
-- This script fixes common column reference errors in SQL queries

USE TechCorpDB;
GO

PRINT '=== HOURSWORKED AND ISACTIVE COLUMN FIX GUIDE ===';
PRINT '';

-- =============================================
-- PROBLEM ANALYSIS AND SOLUTIONS
-- =============================================

PRINT '1. HOURSWORKED COLUMN LOCATIONS:';
PRINT '================================';

-- Check where HoursWorked columns exist
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    'HoursWorked column found here' as Notes
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'HoursWorked'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '2. ISACTIVE COLUMN LOCATIONS (Multiple tables have this):';
PRINT '=======================================================';

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    'IsActive column found here - use table alias' as Notes
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'IsActive'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '3. CORRECT QUERY PATTERNS FOR HOURSWORKED:';
PRINT '==========================================';

PRINT 'ERROR: SELECT HoursWorked FROM Employees; -- WRONG - Employees table has no HoursWorked column';
PRINT '';
PRINT 'CORRECT PATTERNS:';
PRINT '';

-- Pattern 1: From EmployeeProjects table
PRINT 'A) Get HoursWorked from EmployeeProjects (project assignments):';
SELECT 
    e.FirstName + ' ' + e.LastName as EmployeeName,
    p.ProjectName,
    ep.Role,
    ep.HoursWorked,
    ep.HoursAllocated,
    ep.AllocationPercentage
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1 AND ep.IsActive = 1;

PRINT '';
PRINT 'B) Get HoursWorked from TimeTracking (daily time entries):';
SELECT 
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

PRINT '';
PRINT 'C) Summary of hours by employee (aggregated):';
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    SUM(ep.HoursWorked) as TotalProjectHours,
    SUM(ISNULL(tt.HoursWorked, 0)) as TotalTimeTrackedHours,
    AVG(ep.AllocationPercentage) as AvgAllocation
FROM Employees e
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
LEFT JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID
WHERE e.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle
ORDER BY TotalProjectHours DESC;

PRINT '';
PRINT '4. FIXING AMBIGUOUS ISACTIVE REFERENCES:';
PRINT '========================================';

PRINT 'ERROR: SELECT * FROM Employees e JOIN Departments d ON ... WHERE IsActive = 1; -- AMBIGUOUS';
PRINT '';
PRINT 'CORRECT: Use table aliases for IsActive columns:';

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    c.CompanyName,
    e.IsActive as EmployeeActive,
    d.IsActive as DeptActive,
    c.IsActive as CompanyActive
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN Companies c ON d.CompanyID = c.CompanyID
WHERE e.IsActive = 1 
  AND d.IsActive = 1 
  AND c.IsActive = 1;

PRINT '';
PRINT '5. COMPLEX QUERIES WITH PROPER COLUMN REFERENCES:';
PRINT '=================================================';

-- Employee productivity report with proper HoursWorked references
SELECT 
    'Employee Productivity Report' as ReportTitle,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    COUNT(DISTINCT ep.ProjectID) as ActiveProjects,
    SUM(ep.HoursWorked) as TotalProjectHours,
    AVG(ep.AllocationPercentage) as AvgAllocation,
    COUNT(tt.TimeEntryID) as TimeEntries,
    SUM(tt.HoursWorked) as TotalTrackedHours,
    SUM(tt.BillableHours) as TotalBillableHours,
    CASE 
        WHEN SUM(tt.HoursWorked) > 0 THEN (SUM(tt.BillableHours) / SUM(tt.HoursWorked)) * 100
        ELSE 0
    END as BillabilityPercentage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
LEFT JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID
WHERE e.IsActive = 1 
  AND d.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, d.DepartmentName
HAVING COUNT(DISTINCT ep.ProjectID) > 0
ORDER BY TotalBillableHours DESC;

PRINT '';
PRINT '6. COMMON ERROR FIXES:';
PRINT '=====================';
PRINT '';
PRINT 'If you get "Invalid column name HoursWorked":';
PRINT '- Check which table you are querying from';
PRINT '- Use EmployeeProjects.HoursWorked for project allocations';
PRINT '- Use TimeTracking.HoursWorked for daily time entries';
PRINT '- Never select HoursWorked directly from Employees table';
PRINT '';
PRINT 'If you get "Ambiguous column name IsActive":';
PRINT '- Use table aliases: e.IsActive, d.IsActive, p.IsActive';
PRINT '- Be specific about which table\''s IsActive you want';
PRINT '';
PRINT 'CORRECT REFERENCE PATTERNS:';
PRINT 'Employees.IsActive -> e.IsActive';
PRINT 'Departments.IsActive -> d.IsActive';
PRINT 'Companies.IsActive -> c.IsActive';
PRINT 'Projects.IsActive -> p.IsActive';
PRINT 'EmployeeProjects.IsActive -> ep.IsActive';
PRINT 'EmployeeProjects.HoursWorked -> ep.HoursWorked';
PRINT 'TimeTracking.HoursWorked -> tt.HoursWorked';

-- =============================================
-- SAMPLE CORRECTED QUERIES FOR TUTORIALS
-- =============================================

PRINT '';
PRINT '7. SAMPLE QUERIES FOR MODULE TUTORIALS:';
PRINT '======================================';

-- Basic employee list (Module 3)
PRINT 'Module 3 - Basic SELECT with proper IsActive:';
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary
FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.LastName;

-- Employee-Department JOIN (Module 4)  
PRINT 'Module 4 - JOINs with disambiguated IsActive:';
SELECT 
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    d.Location
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND d.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;

-- Employee hours summary (Module 5-6)
PRINT 'Module 5-6 - Aggregation with HoursWorked:';
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount,
    AVG(e.BaseSalary) as AvgSalary,
    SUM(ISNULL(ep.HoursWorked, 0)) as TotalProjectHours
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
WHERE d.IsActive = 1 AND e.IsActive = 1
GROUP BY d.DepartmentName
ORDER BY TotalProjectHours DESC;

PRINT '';
PRINT '=== FIX COMPLETE ===';
PRINT 'Use the patterns above in your tutorials and exercises.';
PRINT 'Remember: Always use table aliases and reference the correct table for each column!';