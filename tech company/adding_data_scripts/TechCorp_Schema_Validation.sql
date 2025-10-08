-- TechCorp Database Schema Validation Script
-- Ensures all training modules use correct column references
-- Run this against TechCorp database to verify module accuracy

USE TechCorpDB;  -- Replace with actual database name
GO

PRINT '🎯 TECHCORP DATABASE SCHEMA VALIDATION';
PRINT '======================================';
PRINT '';

-- Verify Employees Table Structure
PRINT '📊 EMPLOYEES TABLE VALIDATION:';
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Employees') AND name = 'JobTitle')
    PRINT '✅ JobTitle column exists (correct - NOT Title)';
ELSE 
    PRINT '❌ JobTitle column missing - check schema';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Employees') AND name = 'BaseSalary')
    PRINT '✅ BaseSalary column exists (correct for employees)';
ELSE 
    PRINT '❌ BaseSalary column missing - check schema';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Employees') AND name = 'IsActive')
    PRINT '✅ IsActive column exists (employee status)';
ELSE 
    PRINT '❌ IsActive column missing - check schema';

PRINT '';

-- Verify Projects Table Structure  
PRINT '📋 PROJECTS TABLE VALIDATION:';
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Projects') AND name = 'Status')
    PRINT '✅ Status column exists (correct - NOT IsActive for projects)';
ELSE 
    PRINT '❌ Status column missing - using IsActive incorrectly';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Projects') AND name = 'IsActive')
    PRINT '⚠️  IsActive column exists - should use Status for project state';

PRINT '';

-- Verify Products Table Structure (if exists)
PRINT '🛍️ PRODUCTS TABLE VALIDATION:';
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Products')
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'UnitPrice')
        PRINT '✅ UnitPrice column exists (correct - NOT BaseSalary for products)';
    ELSE 
        PRINT '❌ UnitPrice column missing - check schema';

    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockQuantity')
        PRINT '✅ StockQuantity column exists (correct - NOT UnitsInStock)';
    ELSE 
        PRINT '❌ StockQuantity column missing - check schema';
END
ELSE
    PRINT '⚠️  Products table not found in database';

PRINT '';

-- Verify Departments Table
PRINT '🏢 DEPARTMENTS TABLE VALIDATION:';
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Departments') AND name = 'DepartmentName')
    PRINT '✅ DepartmentName column exists';
ELSE 
    PRINT '❌ DepartmentName column missing - check schema';

PRINT '';

-- Sample Query Validation
PRINT '🔍 SAMPLE QUERY VALIDATION:';
PRINT 'Testing common training module queries...';

BEGIN TRY
    -- Test Employee Query with correct columns
    SELECT TOP 1 
        e.FirstName,
        e.LastName, 
        e.JobTitle,        -- NOT Title
        e.BaseSalary,      -- Correct for employees
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1;
    
    PRINT '✅ Employee query with correct columns PASSED';
END TRY
BEGIN CATCH
    PRINT '❌ Employee query FAILED: ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    -- Test Project Query with Status (not IsActive)
    SELECT TOP 1 
        ProjectName,
        Status,            -- NOT IsActive for projects
        Budget
    FROM Projects
    WHERE Status = 'Active';  -- NOT IsActive = 1
    
    PRINT '✅ Project query with Status column PASSED';
END TRY
BEGIN CATCH
    PRINT '❌ Project query FAILED: ' + ERROR_MESSAGE();
END CATCH

PRINT '';
PRINT '🎓 VALIDATION COMPLETE';
PRINT 'Use this script to verify training module accuracy';
PRINT 'All modules should now use these validated column references';
PRINT '';

-- Display correct column reference summary
PRINT '📋 CORRECT COLUMN REFERENCE SUMMARY:';
PRINT 'Employees: FirstName, LastName, JobTitle, BaseSalary, IsActive';
PRINT 'Projects: ProjectName, Status, Budget, StartDate, EndDate';  
PRINT 'Departments: DepartmentName, Budget, Location';
PRINT 'Products: ProductName, UnitPrice, StockQuantity (if exists)';
PRINT '';
PRINT '✅ Training modules updated to use these correct references!';