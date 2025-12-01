-- =============================================
-- ADD INDEXES AND CONSTRAINTS FOR NEW COLUMNS
-- Optimizes performance for the newly added columns
-- =============================================

USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'ADDING INDEXES AND CONSTRAINTS FOR NEW COLUMNS';
PRINT 'Performance optimization for added columns';
PRINT '==============================================';
PRINT '';

-- =============================================
-- STEP 1: ADD INDEXES FOR CUSTOMERS TABLE NEW COLUMNS
-- =============================================
PRINT 'STEP 1: Adding indexes for Customers table new columns...';

-- Index on CompanyName for faster searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Customers_CompanyName')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_CompanyName
    ON Customers (CompanyName)
    WHERE CompanyName IS NOT NULL;
    
    PRINT '✅ Created index IX_Customers_CompanyName';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Customers_CompanyName already exists';
END

-- Index on ContactName for faster searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Customers_ContactName')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_ContactName
    ON Customers (ContactName)
    WHERE ContactName IS NOT NULL;
    
    PRINT '✅ Created index IX_Customers_ContactName';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Customers_ContactName already exists';
END

-- Index on Country for faster filtering
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Customers_Country')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_Country
    ON Customers (Country)
    INCLUDE (CompanyName, ContactName, IsActive)
    WHERE Country IS NOT NULL;
    
    PRINT '✅ Created index IX_Customers_Country with included columns';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Customers_Country already exists';
END

-- =============================================
-- STEP 2: ADD INDEXES FOR EMPLOYEES TABLE NEW COLUMNS
-- =============================================
PRINT '';
PRINT 'STEP 2: Adding indexes for Employees table new columns...';

-- Index on HoursWorked for range queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_HoursWorked')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Employees_HoursWorked
    ON Employees (HoursWorked)
    INCLUDE (FirstName, LastName, IsActive)
    WHERE HoursWorked > 0;
    
    PRINT '✅ Created index IX_Employees_HoursWorked';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Employees_HoursWorked already exists';
END

-- Index on HoursAllocated for range queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_HoursAllocated')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Employees_HoursAllocated
    ON Employees (HoursAllocated)
    INCLUDE (FirstName, LastName, IsActive)
    WHERE HoursAllocated > 0;
    
    PRINT '✅ Created index IX_Employees_HoursAllocated';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Employees_HoursAllocated already exists';
END

-- Composite index for common queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_IsActive_Hours')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Employees_IsActive_Hours
    ON Employees (IsActive, HoursWorked)
    INCLUDE (FirstName, LastName, JobTitle, DepartmentID)
    WHERE IsActive = 1;
    
    PRINT '✅ Created composite index IX_Employees_IsActive_Hours';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Employees_IsActive_Hours already exists';
END

-- =============================================
-- STEP 3: ADD CHECK CONSTRAINTS FOR DATA INTEGRITY
-- =============================================
PRINT '';
PRINT 'STEP 3: Adding check constraints for data integrity...';

-- Check constraint for HoursWorked (must be non-negative)
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Employees_HoursWorked_NonNegative')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT CK_Employees_HoursWorked_NonNegative
    CHECK (HoursWorked >= 0);
    
    PRINT '✅ Added check constraint CK_Employees_HoursWorked_NonNegative';
END
ELSE
BEGIN
    PRINT '⚠️  Check constraint CK_Employees_HoursWorked_NonNegative already exists';
END

-- Check constraint for HoursAllocated (must be non-negative)
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Employees_HoursAllocated_NonNegative')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT CK_Employees_HoursAllocated_NonNegative
    CHECK (HoursAllocated >= 0);
    
    PRINT '✅ Added check constraint CK_Employees_HoursAllocated_NonNegative';
END
ELSE
BEGIN
    PRINT '⚠️  Check constraint CK_Employees_HoursAllocated_NonNegative already exists';
END

-- Check constraint for reasonable hours (optional business rule)
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Employees_ReasonableHours')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT CK_Employees_ReasonableHours
    CHECK (HoursWorked <= 10000 AND HoursAllocated <= 10000);  -- Max 10,000 hours total
    
    PRINT '✅ Added check constraint CK_Employees_ReasonableHours';
END
ELSE
BEGIN
    PRINT '⚠️  Check constraint CK_Employees_ReasonableHours already exists';
END

-- =============================================
-- STEP 4: CREATE COMPUTED COLUMNS FOR EFFICIENCY
-- =============================================
PRINT '';
PRINT 'STEP 4: Adding computed columns for common calculations...';

-- Add computed column for hours utilization percentage
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'HoursUtilization')
BEGIN
    ALTER TABLE Employees
    ADD HoursUtilization AS (
        CASE 
            WHEN HoursAllocated > 0 THEN CAST((HoursWorked * 100.0 / HoursAllocated) AS DECIMAL(5,2))
            ELSE 0
        END
    ) PERSISTED;
    
    PRINT '✅ Added computed column HoursUtilization (percentage of allocated hours worked)';
END
ELSE
BEGIN
    PRINT '⚠️  Computed column HoursUtilization already exists';
END

-- Add computed column for full contact info in Customers
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Customers' AND COLUMN_NAME = 'FullContactInfo')
BEGIN
    ALTER TABLE Customers
    ADD FullContactInfo AS (
        ISNULL(CompanyName, '') + 
        CASE 
            WHEN ContactName IS NOT NULL AND CompanyName IS NOT NULL THEN ' - ' + ContactName
            WHEN ContactName IS NOT NULL THEN ContactName
            ELSE ''
        END +
        CASE 
            WHEN Country IS NOT NULL THEN ' (' + Country + ')'
            ELSE ''
        END
    ) PERSISTED;
    
    PRINT '✅ Added computed column FullContactInfo (combined company, contact, and country)';
END
ELSE
BEGIN
    PRINT '⚠️  Computed column FullContactInfo already exists';
END

-- =============================================
-- STEP 5: ADD INDEXES FOR COMPUTED COLUMNS
-- =============================================
PRINT '';
PRINT 'STEP 5: Adding indexes for computed columns...';

-- Index on HoursUtilization for performance queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employees_HoursUtilization')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Employees_HoursUtilization
    ON Employees (HoursUtilization)
    INCLUDE (FirstName, LastName, JobTitle)
    WHERE HoursUtilization IS NOT NULL AND IsActive = 1;
    
    PRINT '✅ Created index IX_Employees_HoursUtilization';
END
ELSE
BEGIN
    PRINT '⚠️  Index IX_Employees_HoursUtilization already exists';
END

-- =============================================
-- STEP 6: CREATE STATISTICS FOR QUERY OPTIMIZATION
-- =============================================
PRINT '';
PRINT 'STEP 6: Creating statistics for query optimization...';

-- Statistics on new columns for better query plans
IF NOT EXISTS (SELECT * FROM sys.stats WHERE name = 'ST_Customers_CompanyName')
BEGIN
    CREATE STATISTICS ST_Customers_CompanyName ON Customers (CompanyName);
    PRINT '✅ Created statistics ST_Customers_CompanyName';
END

IF NOT EXISTS (SELECT * FROM sys.stats WHERE name = 'ST_Employees_HoursCombined')
BEGIN
    CREATE STATISTICS ST_Employees_HoursCombined ON Employees (HoursWorked, HoursAllocated);
    PRINT '✅ Created statistics ST_Employees_HoursCombined';
END

-- =============================================
-- STEP 7: VERIFY ALL ADDITIONS
-- =============================================
PRINT '';
PRINT 'STEP 7: Verifying indexes and constraints...';

-- List all indexes on the modified tables
PRINT '';
PRINT 'Indexes on Customers table:';
SELECT 
    i.name as IndexName,
    i.type_desc as IndexType,
    i.is_unique,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic
        JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') as Columns
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('Customers')
  AND i.name LIKE 'IX_Customers_%'
ORDER BY i.name;

PRINT '';
PRINT 'Indexes on Employees table:';
SELECT 
    i.name as IndexName,
    i.type_desc as IndexType,
    i.is_unique,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic
        JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') as Columns
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('Employees')
  AND i.name LIKE 'IX_Employees_%'
ORDER BY i.name;

-- List check constraints
PRINT '';
PRINT 'Check constraints on Employees table:';
SELECT 
    cc.name as ConstraintName,
    cc.definition as ConstraintDefinition
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('Employees')
  AND cc.name LIKE 'CK_Employees_%'
ORDER BY cc.name;

-- =============================================
-- STEP 8: PERFORMANCE TEST QUERIES
-- =============================================
PRINT '';
PRINT 'STEP 8: Performance test queries...';

-- Test query performance with new indexes
SET STATISTICS IO ON;

PRINT '';
PRINT 'Testing performance - Customer searches:';
SELECT COUNT(*) as CustomerCount
FROM Customers
WHERE CompanyName LIKE 'A%' AND Country = 'United States' AND IsActive = 1;

PRINT '';
PRINT 'Testing performance - Employee hours queries:';
SELECT COUNT(*) as HighPerformerCount
FROM Employees
WHERE IsActive = 1 AND HoursWorked > 100 AND HoursUtilization > 80;

SET STATISTICS IO OFF;

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'INDEXES AND CONSTRAINTS COMPLETE!';
PRINT '==============================================';
PRINT '';
PRINT '✅ INDEXES CREATED:';
PRINT '1. IX_Customers_CompanyName - Fast company name searches';
PRINT '2. IX_Customers_ContactName - Fast contact name searches';  
PRINT '3. IX_Customers_Country - Fast country filtering';
PRINT '4. IX_Employees_HoursWorked - Fast hours range queries';
PRINT '5. IX_Employees_HoursAllocated - Fast allocation queries';
PRINT '6. IX_Employees_IsActive_Hours - Composite for common patterns';
PRINT '7. IX_Employees_HoursUtilization - Performance metrics queries';
PRINT '';
PRINT '✅ CONSTRAINTS ADDED:';
PRINT '1. CK_Employees_HoursWorked_NonNegative - Data integrity';
PRINT '2. CK_Employees_HoursAllocated_NonNegative - Data integrity';
PRINT '3. CK_Employees_ReasonableHours - Business rules';
PRINT '';
PRINT '✅ COMPUTED COLUMNS:';
PRINT '1. Employees.HoursUtilization - Automatic percentage calculation';
PRINT '2. Customers.FullContactInfo - Combined contact information';
PRINT '';
PRINT '📈 PERFORMANCE BENEFITS:';
PRINT '- Faster searches on CompanyName, ContactName, Country';
PRINT '- Optimized range queries on HoursWorked/HoursAllocated';
PRINT '- Efficient filtering on IsActive + hours combinations';
PRINT '- Automatic calculation of utilization metrics';
PRINT '';
PRINT '==============================================';

GO