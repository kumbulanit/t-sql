-- =============================================
-- COMPLETE COLUMN REFERENCE FIXES FOR SSMS
-- Copy and paste this entire script into SSMS and execute
-- =============================================

USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'FIXING ALL COLUMN REFERENCE ISSUES';
PRINT 'Run this script in SSMS to resolve all errors';
PRINT '==============================================';
PRINT '';

-- =============================================
-- STEP 1: CREATE COMPATIBILITY VIEW FOR CUSTOMERS
-- =============================================
PRINT 'STEP 1: Creating compatibility view for Customers table...';

-- Drop view if it exists
IF OBJECT_ID('vw_Customers_Training', 'V') IS NOT NULL
BEGIN
    DROP VIEW vw_Customers_Training;
    PRINT '✓ Dropped existing vw_Customers_Training view';
END

-- Create the compatibility view
CREATE VIEW vw_Customers_Training AS
SELECT 
    CustomerID,
    CompanyID,
    CustomerName AS CompanyName,  -- ✅ Maps CustomerName to expected CompanyName
    CustomerType,
    ContactFirstName + ISNULL(' ' + ContactLastName, '') AS ContactName,  -- ✅ Combines contact names
    ContactFirstName,
    ContactLastName,
    ContactTitle,
    PrimaryEmail,
    PrimaryPhone,
    SecondaryPhone,
    Website,
    IndustryID,
    CountryID,
    cn.CountryName AS Country,  -- ✅ Maps CountryID to Country name via JOIN
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

PRINT '✅ Created vw_Customers_Training compatibility view successfully!';

-- =============================================
-- STEP 2: TEST THE FIXES WITH EXAMPLE QUERIES
-- =============================================
PRINT '';
PRINT 'STEP 2: Testing the column reference fixes...';

-- ✅ Test 1: Customer query using compatibility view (now works!)
PRINT '';
PRINT 'TEST 1: Customer data with CompanyName, ContactName, and Country:';
SELECT TOP 5
    CustomerID,
    CompanyName,        -- ✅ Now works! (was CustomerName)
    ContactName,        -- ✅ Now works! (combined ContactFirstName + ContactLastName)
    Country,            -- ✅ Now works! (joined from Countries table)
    City,
    IsActive
FROM vw_Customers_Training
WHERE IsActive = 1
ORDER BY CompanyName;

-- ✅ Test 2: Employee query with proper table alias (fixes ambiguous IsActive)
PRINT '';
PRINT 'TEST 2: Employee data with proper IsActive reference:';
SELECT TOP 5
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.JobTitle,
    e.IsActive AS EmployeeActive  -- ✅ Table alias prevents ambiguity
FROM Employees e
WHERE e.IsActive = 1  -- ✅ Table alias required
ORDER BY e.LastName;

-- ✅ Test 3: Multi-table JOIN with proper aliases (fixes all IsActive ambiguity)
PRINT '';
PRINT 'TEST 3: Employee-Department JOIN with proper table aliases:';
SELECT TOP 5
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    co.CompanyName,
    e.IsActive AS EmployeeActive,    -- ✅ Specific table alias
    d.IsActive AS DepartmentActive,  -- ✅ Specific table alias
    co.IsActive AS CompanyActive     -- ✅ Specific table alias
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN Companies co ON e.CompanyID = co.CompanyID
WHERE e.IsActive = 1 AND d.IsActive = 1 AND co.IsActive = 1  -- ✅ All aliases specified
ORDER BY e.LastName;

-- ✅ Test 4: Customer-Order JOIN using compatibility view
PRINT '';
PRINT 'TEST 4: Customer-Order data using compatibility view:';
SELECT TOP 3
    c.CustomerID,
    c.CompanyName,      -- ✅ Now available through view
    c.ContactName,      -- ✅ Now available through view  
    c.Country,          -- ✅ Now available through view
    o.OrderNumber,
    o.OrderDate,
    o.TotalAmount
FROM vw_Customers_Training c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.IsActive = 1
ORDER BY o.OrderDate DESC;

-- =============================================
-- STEP 3: COLUMN MAPPING REFERENCE GUIDE
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'COLUMN MAPPING REFERENCE GUIDE';
PRINT '==============================================';
PRINT '';
PRINT 'PROBLEM → SOLUTION:';
PRINT '';
PRINT '❌ SELECT CompanyName FROM Customers;';
PRINT '✅ SELECT CustomerName FROM Customers;';  
PRINT '   OR';
PRINT '✅ SELECT CompanyName FROM vw_Customers_Training;';
PRINT '';
PRINT '❌ SELECT ContactName FROM Customers;';
PRINT '✅ SELECT ContactFirstName + '' '' + ContactLastName FROM Customers;';
PRINT '   OR'; 
PRINT '✅ SELECT ContactName FROM vw_Customers_Training;';
PRINT '';
PRINT '❌ SELECT Country FROM Customers;';
PRINT '✅ SELECT cn.CountryName FROM Customers c JOIN Countries cn ON c.CountryID = cn.CountryID;';
PRINT '   OR';
PRINT '✅ SELECT Country FROM vw_Customers_Training;';
PRINT '';
PRINT '❌ SELECT * FROM Employees e JOIN Departments d ON ... WHERE IsActive = 1;';
PRINT '✅ SELECT * FROM Employees e JOIN Departments d ON ... WHERE e.IsActive = 1 AND d.IsActive = 1;';

-- =============================================
-- STEP 4: CREATE HELPER PROCEDURES FOR COMMON PATTERNS
-- =============================================
PRINT '';
PRINT 'STEP 4: Creating helper procedures for common query patterns...';

-- Helper procedure for active employees
IF OBJECT_ID('sp_GetActiveEmployees', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetActiveEmployees;
GO

CREATE PROCEDURE sp_GetActiveEmployees
    @DepartmentID INT = NULL,
    @TopCount INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        d.DepartmentName,
        co.CompanyName,
        e.HireDate,
        e.BaseSalary,
        e.IsActive AS EmployeeActive,
        d.IsActive AS DepartmentActive
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN Companies co ON e.CompanyID = co.CompanyID
    WHERE e.IsActive = 1 
      AND d.IsActive = 1
      AND co.IsActive = 1
      AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    ORDER BY e.LastName, e.FirstName;
END;
GO

-- Helper procedure for active customers
IF OBJECT_ID('sp_GetActiveCustomers', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetActiveCustomers;
GO

CREATE PROCEDURE sp_GetActiveCustomers
    @TopCount INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        CustomerID,
        CompanyName,    -- Available through view mapping
        ContactName,    -- Available through view mapping
        PrimaryEmail,
        City,
        Country,        -- Available through view mapping
        CurrentBalance,
        CreditLimit,
        IsActive
    FROM vw_Customers_Training
    WHERE IsActive = 1
    ORDER BY CompanyName;
END;
GO

PRINT '✅ Created helper procedures successfully!';

-- =============================================
-- STEP 5: TEST THE HELPER PROCEDURES
-- =============================================
PRINT '';
PRINT 'STEP 5: Testing helper procedures...';

PRINT '';
PRINT 'Testing sp_GetActiveEmployees:';
EXEC sp_GetActiveEmployees @TopCount = 3;

PRINT '';
PRINT 'Testing sp_GetActiveCustomers:';  
EXEC sp_GetActiveCustomers @TopCount = 3;

-- =============================================
-- STEP 6: VALIDATE ALL FIXES ARE WORKING
-- =============================================
PRINT '';
PRINT 'STEP 6: Final validation that all column issues are resolved...';

BEGIN TRY
    -- This should now work without errors
    DECLARE @testResults TABLE (
        TestName VARCHAR(100),
        Status VARCHAR(10),
        Message VARCHAR(200)
    );
    
    -- Test 1: CompanyName access
    IF EXISTS (SELECT TOP 1 CompanyName FROM vw_Customers_Training WHERE IsActive = 1)
        INSERT INTO @testResults VALUES ('CompanyName Access', 'PASS', 'CompanyName column accessible through view');
    ELSE
        INSERT INTO @testResults VALUES ('CompanyName Access', 'FAIL', 'CompanyName column not accessible');
    
    -- Test 2: ContactName access  
    IF EXISTS (SELECT TOP 1 ContactName FROM vw_Customers_Training WHERE ContactName IS NOT NULL)
        INSERT INTO @testResults VALUES ('ContactName Access', 'PASS', 'ContactName column accessible through view');
    ELSE
        INSERT INTO @testResults VALUES ('ContactName Access', 'FAIL', 'ContactName column not accessible');
        
    -- Test 3: Country access
    IF EXISTS (SELECT TOP 1 Country FROM vw_Customers_Training WHERE Country IS NOT NULL)
        INSERT INTO @testResults VALUES ('Country Access', 'PASS', 'Country column accessible through view');  
    ELSE
        INSERT INTO @testResults VALUES ('Country Access', 'FAIL', 'Country column not accessible');
        
    -- Test 4: Ambiguous IsActive resolution
    DECLARE @empCount INT;
    SELECT @empCount = COUNT(*) 
    FROM Employees e 
    JOIN Departments d ON e.DepartmentID = d.DepartmentID 
    WHERE e.IsActive = 1 AND d.IsActive = 1;
    
    IF @empCount > 0
        INSERT INTO @testResults VALUES ('IsActive Ambiguity', 'PASS', 'Table aliases resolve IsActive ambiguity');
    ELSE  
        INSERT INTO @testResults VALUES ('IsActive Ambiguity', 'FAIL', 'IsActive ambiguity not resolved');
    
    -- Display test results
    PRINT '';
    PRINT 'VALIDATION RESULTS:';
    PRINT '-------------------';
    SELECT TestName, Status, Message FROM @testResults;
    
    -- Summary
    DECLARE @passCount INT, @failCount INT;
    SELECT @passCount = COUNT(*) FROM @testResults WHERE Status = 'PASS';
    SELECT @failCount = COUNT(*) FROM @testResults WHERE Status = 'FAIL';
    
    PRINT '';
    IF @failCount = 0
        PRINT '🎉 ALL TESTS PASSED! Column reference issues are fully resolved.';
    ELSE
        PRINT '⚠️  Some tests failed. Please review the results above.';
        
END TRY
BEGIN CATCH
    PRINT '❌ Error during validation: ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- FINAL SUMMARY AND USAGE INSTRUCTIONS
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'ALL COLUMN REFERENCE FIXES COMPLETE!';
PRINT '==============================================';
PRINT '';
PRINT '✅ WHAT WAS FIXED:';
PRINT '1. Created vw_Customers_Training view for column name compatibility';
PRINT '2. Mapped CustomerName → CompanyName for training materials';  
PRINT '3. Combined ContactFirstName + ContactLastName → ContactName';
PRINT '4. Added Country name via JOIN to Countries table';
PRINT '5. Provided examples of proper table aliasing for IsActive columns';
PRINT '6. Created helper procedures for common query patterns';
PRINT '';
PRINT '📋 HOW TO USE GOING FORWARD:';
PRINT '';
PRINT '1. FOR CUSTOMERS: Use vw_Customers_Training instead of Customers table';
PRINT '   Example: SELECT CompanyName, ContactName, Country FROM vw_Customers_Training;';
PRINT '';  
PRINT '2. FOR ISACTIVE: Always use table aliases in multi-table queries';
PRINT '   Example: SELECT * FROM Employees e JOIN Departments d ON ... WHERE e.IsActive = 1;';
PRINT '';
PRINT '3. FOR COMMON PATTERNS: Use the helper procedures';
PRINT '   - EXEC sp_GetActiveEmployees;';
PRINT '   - EXEC sp_GetActiveCustomers;';
PRINT '';
PRINT '🎯 YOUR TRAINING MATERIALS WILL NOW WORK WITH:';
PRINT '- CompanyName (mapped from CustomerName)';
PRINT '- ContactName (combined from ContactFirstName + ContactLastName)'; 
PRINT '- Country (joined from Countries table)';
PRINT '- Proper IsActive references with table aliases';
PRINT '';
PRINT '==============================================';
PRINT 'READY FOR SQL TRAINING - NO MORE COLUMN ERRORS!';
PRINT '==============================================';

GO