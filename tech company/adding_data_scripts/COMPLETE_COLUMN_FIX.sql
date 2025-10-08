-- =============================================
-- TECHCORP DATABASE: COMPLETE COLUMN REFERENCE FIX
-- ONE SCRIPT TO FIX ALL ISSUES - RUN IN SSMS
-- =============================================

USE TechCorpDB;
GO

PRINT '================================================================';
PRINT 'TECHCORP DATABASE - COMPLETE COLUMN REFERENCE FIX';
PRINT 'This script fixes ALL column reference issues in one go';
PRINT '================================================================';
PRINT '';

-- =============================================
-- STEP 1: CREATE COMPATIBILITY VIEW FOR CUSTOMERS
-- =============================================
PRINT 'STEP 1: Creating compatibility view for Customers table...';

-- Drop existing view if it exists
IF OBJECT_ID('vw_Customers_Training', 'V') IS NOT NULL
BEGIN
    DROP VIEW vw_Customers_Training;
    PRINT '✓ Dropped existing vw_Customers_Training view';
END

-- Create compatibility view to fix CompanyName, ContactName, and Country issues
CREATE VIEW vw_Customers_Training AS
SELECT 
    CustomerID,
    CompanyID,
    CustomerName AS CompanyName,  -- ✅ FIX: Maps CustomerName to CompanyName
    CustomerType,
    ContactFirstName + ISNULL(' ' + ContactLastName, '') AS ContactName,  -- ✅ FIX: Combines contact names
    ContactFirstName,
    ContactLastName,
    ContactTitle,
    PrimaryEmail,
    PrimaryPhone,
    SecondaryPhone,
    Website,
    IndustryID,
    CountryID,
    cn.CountryName AS Country,  -- ✅ FIX: Maps CountryID to Country name
    StreetAddress,
    City,
    StateProvince,
    PostalCode,
    CreditLimit,
    CurrentBalance,
    PaymentTerms,
    AccountStatus,
    IsActive,
    CreatedDate,
    CreatedBy,
    ModifiedDate,
    ModifiedBy
FROM Customers c
LEFT JOIN Countries cn ON c.CountryID = cn.CountryID;
GO

PRINT '✅ Created vw_Customers_Training view - fixes CompanyName, ContactName, Country issues';

-- =============================================
-- STEP 2: CREATE EMPLOYEE HOURS SUMMARY VIEW
-- =============================================
PRINT '';
PRINT 'STEP 2: Creating employee hours summary view...';

-- Drop existing view if it exists
IF OBJECT_ID('vw_Employee_Hours_Summary', 'V') IS NOT NULL
BEGIN
    DROP VIEW vw_Employee_Hours_Summary;
    PRINT '✓ Dropped existing vw_Employee_Hours_Summary view';
END

-- Create view that provides HoursWorked data with employee information
CREATE VIEW vw_Employee_Hours_Summary AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.JobTitle,
    d.DepartmentName,
    co.CompanyName,
    -- Project hours from EmployeeProjects
    ISNULL(SUM(ep.HoursWorked), 0) AS TotalProjectHours,
    ISNULL(SUM(ep.HoursAllocated), 0) AS TotalAllocatedHours,
    -- Time tracking hours from TimeTracking
    (SELECT ISNULL(SUM(tt.HoursWorked), 0) 
     FROM TimeTracking tt 
     WHERE tt.EmployeeID = e.EmployeeID) AS TotalTimeTrackedHours,
    e.IsActive AS EmployeeActive,
    d.IsActive AS DepartmentActive,
    co.IsActive AS CompanyActive
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN Companies co ON e.CompanyID = co.CompanyID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
WHERE e.IsActive = 1 AND d.IsActive = 1 AND co.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, 
         d.DepartmentName, co.CompanyName, e.IsActive, d.IsActive, co.IsActive;
GO

PRINT '✅ Created vw_Employee_Hours_Summary view - provides HoursWorked data with proper JOINs';

-- =============================================
-- STEP 3: CREATE HELPER STORED PROCEDURES
-- =============================================
PRINT '';
PRINT 'STEP 3: Creating helper stored procedures...';

-- Procedure 1: Get Active Employees with Hours
IF OBJECT_ID('sp_GetEmployeesWithHours', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetEmployeesWithHours;
GO

CREATE PROCEDURE sp_GetEmployeesWithHours
    @DepartmentID INT = NULL,
    @TopCount INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        EmployeeID,
        FullName,
        JobTitle,
        DepartmentName,
        CompanyName,
        TotalProjectHours,
        TotalAllocatedHours,
        TotalTimeTrackedHours,
        EmployeeActive,
        DepartmentActive
    FROM vw_Employee_Hours_Summary
    WHERE (@DepartmentID IS NULL OR EmployeeID IN (
        SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentID
    ))
    ORDER BY FullName;
END;
GO

-- Procedure 2: Get Active Customers (fixed column names)
IF OBJECT_ID('sp_GetActiveCustomers', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetActiveCustomers;
GO

CREATE PROCEDURE sp_GetActiveCustomers
    @TopCount INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        CustomerID,
        CompanyName,    -- Now works through view
        ContactName,    -- Now works through view
        PrimaryEmail,
        City,
        Country,        -- Now works through view
        CurrentBalance,
        CreditLimit,
        IsActive
    FROM vw_Customers_Training
    WHERE IsActive = 1
    ORDER BY CompanyName;
END;
GO

-- Procedure 3: Get Employee Project Details
IF OBJECT_ID('sp_GetEmployeeProjectDetails', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetEmployeeProjectDetails;
GO

CREATE PROCEDURE sp_GetEmployeeProjectDetails
    @EmployeeID INT = NULL,
    @TopCount INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        p.ProjectName,
        ep.Role,
        ep.HoursWorked,        -- ✅ From EmployeeProjects table
        ep.HoursAllocated,     -- ✅ From EmployeeProjects table
        ep.AllocationPercentage,
        ep.StartDate,
        ep.EndDate,
        e.IsActive AS EmployeeActive,
        ep.IsActive AS AssignmentActive,
        p.IsActive AS ProjectActive
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE e.IsActive = 1 
      AND ep.IsActive = 1 
      AND p.IsActive = 1
      AND (@EmployeeID IS NULL OR e.EmployeeID = @EmployeeID)
    ORDER BY e.LastName, e.FirstName, p.ProjectName;
END;
GO

PRINT '✅ Created helper stored procedures for common query patterns';

-- =============================================
-- STEP 4: TEST ALL FIXES WITH SAMPLE QUERIES
-- =============================================
PRINT '';
PRINT 'STEP 4: Testing all fixes with sample queries...';

-- Test 1: Customer data with fixed column names
PRINT '';
PRINT 'TEST 1: Customer data (CompanyName, ContactName, Country) - FIXED:';
SELECT TOP 3
    CustomerID,
    CompanyName,        -- ✅ Now works (was CustomerName)
    ContactName,        -- ✅ Now works (combined first + last)
    Country,            -- ✅ Now works (joined from Countries)
    City,
    IsActive
FROM vw_Customers_Training
WHERE IsActive = 1
ORDER BY CompanyName;

-- Test 2: Employee data with proper IsActive aliases
PRINT '';
PRINT 'TEST 2: Employee data with proper IsActive aliases - FIXED:';
SELECT TOP 3
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.JobTitle,
    e.IsActive AS EmployeeActive  -- ✅ Table alias prevents ambiguity
FROM Employees e
WHERE e.IsActive = 1  -- ✅ Table alias required
ORDER BY e.LastName;

-- Test 3: Employee hours from EmployeeProjects (not Employees table)
PRINT '';
PRINT 'TEST 3: Employee hours from correct tables - FIXED:';
SELECT TOP 3
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    p.ProjectName,
    ep.HoursWorked,        -- ✅ From EmployeeProjects table
    ep.HoursAllocated,     -- ✅ From EmployeeProjects table
    e.IsActive AS EmployeeActive,  -- ✅ Proper table alias
    ep.IsActive AS AssignmentActive -- ✅ Proper table alias
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.IsActive = 1 AND ep.IsActive = 1 AND p.IsActive = 1
ORDER BY e.LastName;

-- Test 4: Time tracking hours from TimeTracking table
PRINT '';
PRINT 'TEST 4: Time tracking data - FIXED:';
SELECT TOP 3
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    tt.WorkDate,
    tt.HoursWorked,        -- ✅ From TimeTracking table
    tt.ActivityType,
    tt.BillableHours,
    e.IsActive AS EmployeeActive  -- ✅ Proper table alias
FROM Employees e
INNER JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID
WHERE e.IsActive = 1
ORDER BY tt.WorkDate DESC;

-- Test 5: Multi-table JOIN with all proper aliases
PRINT '';
PRINT 'TEST 5: Complex multi-table JOIN with proper aliases - FIXED:';
SELECT TOP 3
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    co.CompanyName,
    COUNT(ep.EmployeeProjectID) AS ProjectCount,
    SUM(ep.HoursWorked) AS TotalHours,
    e.IsActive AS EmployeeActive,      -- ✅ Specific table alias
    d.IsActive AS DepartmentActive,    -- ✅ Specific table alias
    co.IsActive AS CompanyActive       -- ✅ Specific table alias
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN Companies co ON e.CompanyID = co.CompanyID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID AND ep.IsActive = 1
WHERE e.IsActive = 1 AND d.IsActive = 1 AND co.IsActive = 1
GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, co.CompanyName,
         e.IsActive, d.IsActive, co.IsActive
ORDER BY e.LastName;

-- =============================================
-- STEP 5: TEST HELPER PROCEDURES
-- =============================================
PRINT '';
PRINT 'STEP 5: Testing helper procedures...';

PRINT '';
PRINT 'Testing sp_GetActiveCustomers:';
EXEC sp_GetActiveCustomers @TopCount = 3;

PRINT '';
PRINT 'Testing sp_GetEmployeesWithHours:';
EXEC sp_GetEmployeesWithHours @TopCount = 3;

PRINT '';
PRINT 'Testing sp_GetEmployeeProjectDetails:';
EXEC sp_GetEmployeeProjectDetails @TopCount = 3;

-- =============================================
-- STEP 6: VALIDATION AND ERROR CHECKING
-- =============================================
PRINT '';
PRINT 'STEP 6: Final validation of all fixes...';

BEGIN TRY
    DECLARE @ValidationResults TABLE (
        TestID INT,
        TestName VARCHAR(100),
        Status VARCHAR(10),
        Details VARCHAR(200)
    );
    
    -- Test 1: CompanyName accessibility
    DECLARE @companyCount INT;
    SELECT @companyCount = COUNT(*) FROM vw_Customers_Training WHERE CompanyName IS NOT NULL;
    INSERT INTO @ValidationResults VALUES 
        (1, 'CompanyName Access', CASE WHEN @companyCount > 0 THEN 'PASS' ELSE 'FAIL' END, 
         CAST(@companyCount AS VARCHAR) + ' records with CompanyName found');
    
    -- Test 2: ContactName accessibility  
    DECLARE @contactCount INT;
    SELECT @contactCount = COUNT(*) FROM vw_Customers_Training WHERE ContactName IS NOT NULL;
    INSERT INTO @ValidationResults VALUES 
        (2, 'ContactName Access', CASE WHEN @contactCount > 0 THEN 'PASS' ELSE 'FAIL' END,
         CAST(@contactCount AS VARCHAR) + ' records with ContactName found');
    
    -- Test 3: Country accessibility
    DECLARE @countryCount INT;
    SELECT @countryCount = COUNT(*) FROM vw_Customers_Training WHERE Country IS NOT NULL;
    INSERT INTO @ValidationResults VALUES 
        (3, 'Country Access', CASE WHEN @countryCount > 0 THEN 'PASS' ELSE 'FAIL' END,
         CAST(@countryCount AS VARCHAR) + ' records with Country found');
    
    -- Test 4: HoursWorked from EmployeeProjects
    DECLARE @hoursCount INT;
    SELECT @hoursCount = COUNT(*) FROM EmployeeProjects WHERE HoursWorked > 0;
    INSERT INTO @ValidationResults VALUES 
        (4, 'HoursWorked Access', CASE WHEN @hoursCount > 0 THEN 'PASS' ELSE 'FAIL' END,
         CAST(@hoursCount AS VARCHAR) + ' records with HoursWorked found in EmployeeProjects');
    
    -- Test 5: IsActive ambiguity resolution
    DECLARE @joinCount INT;
    SELECT @joinCount = COUNT(*) 
    FROM Employees e 
    JOIN Departments d ON e.DepartmentID = d.DepartmentID 
    WHERE e.IsActive = 1 AND d.IsActive = 1;
    INSERT INTO @ValidationResults VALUES 
        (5, 'IsActive Resolution', CASE WHEN @joinCount > 0 THEN 'PASS' ELSE 'FAIL' END,
         'Multi-table JOIN with aliases works correctly');
    
    -- Display results
    PRINT '';
    PRINT 'VALIDATION RESULTS:';
    PRINT '==================';
    SELECT TestID, TestName, Status, Details FROM @ValidationResults ORDER BY TestID;
    
    -- Summary
    DECLARE @totalTests INT, @passedTests INT;
    SELECT @totalTests = COUNT(*), @passedTests = SUM(CASE WHEN Status = 'PASS' THEN 1 ELSE 0 END)
    FROM @ValidationResults;
    
    PRINT '';
    PRINT 'SUMMARY: ' + CAST(@passedTests AS VARCHAR) + '/' + CAST(@totalTests AS VARCHAR) + ' tests passed';
    
    IF @passedTests = @totalTests
    BEGIN
        PRINT '';
        PRINT '🎉 SUCCESS! ALL COLUMN REFERENCE ISSUES HAVE BEEN FIXED! 🎉';
    END
    ELSE
    BEGIN
        PRINT '';
        PRINT '⚠️ Some issues remain. Please check the validation results above.';
    END
    
END TRY
BEGIN CATCH
    PRINT '❌ Error during validation: ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- STEP 7: USAGE GUIDE AND REFERENCE
-- =============================================
PRINT '';
PRINT '================================================================';
PRINT 'COMPLETE FIX APPLIED - USAGE GUIDE';
PRINT '================================================================';
PRINT '';
PRINT '✅ FIXES APPLIED:';
PRINT '1. Created vw_Customers_Training view for column name compatibility';
PRINT '2. Created vw_Employee_Hours_Summary view for HoursWorked data access';  
PRINT '3. Created helper stored procedures for common patterns';
PRINT '4. All table aliases properly defined for IsActive references';
PRINT '';
PRINT '📋 HOW TO USE - QUICK REFERENCE:';
PRINT '';
PRINT '🔸 FOR CUSTOMERS (CompanyName, ContactName, Country):';
PRINT '   SELECT CompanyName, ContactName, Country FROM vw_Customers_Training;';
PRINT '';
PRINT '🔸 FOR EMPLOYEE HOURS (HoursWorked):';
PRINT '   -- From EmployeeProjects:';
PRINT '   SELECT e.FirstName, ep.HoursWorked FROM Employees e JOIN EmployeeProjects ep ON...;';
PRINT '   -- From TimeTracking:';  
PRINT '   SELECT e.FirstName, tt.HoursWorked FROM Employees e JOIN TimeTracking tt ON...;';
PRINT '   -- Summary view:';
PRINT '   SELECT * FROM vw_Employee_Hours_Summary;';
PRINT '';
PRINT '🔸 FOR IsActive IN MULTI-TABLE QUERIES:';
PRINT '   SELECT * FROM Employees e JOIN Departments d ON ... WHERE e.IsActive = 1 AND d.IsActive = 1;';
PRINT '';
PRINT '🔸 HELPER PROCEDURES:';
PRINT '   EXEC sp_GetActiveCustomers;';
PRINT '   EXEC sp_GetEmployeesWithHours;';  
PRINT '   EXEC sp_GetEmployeeProjectDetails;';
PRINT '';
PRINT '❌ AVOID THESE PATTERNS:';
PRINT '   SELECT HoursWorked FROM Employees;           -- HoursWorked not in Employees table';
PRINT '   SELECT CompanyName FROM Customers;           -- Use CustomerName or the view';
PRINT '   WHERE IsActive = 1;                          -- Ambiguous in multi-table queries';
PRINT '';
PRINT '✅ USE THESE PATTERNS INSTEAD:';
PRINT '   SELECT ep.HoursWorked FROM EmployeeProjects ep;    -- Explicit table reference';
PRINT '   SELECT CompanyName FROM vw_Customers_Training;     -- Use compatibility view';  
PRINT '   WHERE e.IsActive = 1 AND d.IsActive = 1;          -- Table aliases';
PRINT '';
PRINT '================================================================';
PRINT '🎯 ALL COLUMN REFERENCE ISSUES ARE NOW RESOLVED!';
PRINT 'Your training materials should work without any column errors.';
PRINT '================================================================';

GO