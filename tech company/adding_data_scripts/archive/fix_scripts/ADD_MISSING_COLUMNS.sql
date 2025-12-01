-- =============================================
-- ADD MISSING COLUMNS TO EXISTING TABLES
-- Safely adds columns that are referenced in training materials
-- =============================================

USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'ADDING MISSING COLUMNS TO EXISTING TABLES';
PRINT 'Safe column additions with default values';
PRINT '==============================================';
PRINT '';

-- =============================================
-- STEP 1: ADD COMPANYNAME COLUMN TO CUSTOMERS TABLE
-- =============================================
PRINT 'STEP 1: Adding CompanyName column to Customers table...';

-- Check if CompanyName column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Customers' AND COLUMN_NAME = 'CompanyName')
BEGIN
    -- Add CompanyName column
    ALTER TABLE Customers 
    ADD CompanyName NVARCHAR(100) NULL;
    
    -- Populate with existing CustomerName data
    UPDATE Customers 
    SET CompanyName = CustomerName 
    WHERE CompanyName IS NULL;
    
    PRINT '✅ Added CompanyName column to Customers table';
    PRINT '✅ Populated CompanyName with CustomerName data';
END
ELSE
BEGIN
    PRINT '⚠️  CompanyName column already exists in Customers table';
END

-- =============================================
-- STEP 2: ADD CONTACTNAME COLUMN TO CUSTOMERS TABLE
-- =============================================
PRINT '';
PRINT 'STEP 2: Adding ContactName column to Customers table...';

-- Check if ContactName column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Customers' AND COLUMN_NAME = 'ContactName')
BEGIN
    -- Add ContactName column
    ALTER TABLE Customers 
    ADD ContactName NVARCHAR(150) NULL;
    
    -- Populate by combining FirstName and LastName
    UPDATE Customers 
    SET ContactName = ContactFirstName + ISNULL(' ' + ContactLastName, '')
    WHERE ContactName IS NULL;
    
    PRINT '✅ Added ContactName column to Customers table';
    PRINT '✅ Populated ContactName by combining ContactFirstName + ContactLastName';
END
ELSE
BEGIN
    PRINT '⚠️  ContactName column already exists in Customers table';
END

-- =============================================
-- STEP 3: ADD COUNTRY COLUMN TO CUSTOMERS TABLE
-- =============================================
PRINT '';
PRINT 'STEP 3: Adding Country column to Customers table...';

-- Check if Country column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Customers' AND COLUMN_NAME = 'Country')
BEGIN
    -- Add Country column
    ALTER TABLE Customers 
    ADD Country NVARCHAR(100) NULL;
    
    -- Populate with CountryName from Countries table
    UPDATE c 
    SET Country = cn.CountryName
    FROM Customers c
    INNER JOIN Countries cn ON c.CountryID = cn.CountryID
    WHERE c.Country IS NULL;
    
    PRINT '✅ Added Country column to Customers table';
    PRINT '✅ Populated Country with CountryName from Countries table';
END
ELSE
BEGIN
    PRINT '⚠️  Country column already exists in Customers table';
END

-- =============================================
-- STEP 4: ADD HOURSWORKED COLUMN TO EMPLOYEES TABLE (OPTIONAL)
-- =============================================
PRINT '';
PRINT 'STEP 4: Adding HoursWorked column to Employees table (summary field)...';

-- Check if HoursWorked column already exists in Employees
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'HoursWorked')
BEGIN
    -- Add HoursWorked column as summary field
    ALTER TABLE Employees 
    ADD HoursWorked DECIMAL(10,2) NULL DEFAULT 0;
    
    -- Populate with total hours from EmployeeProjects
    UPDATE e
    SET HoursWorked = ISNULL(ep_totals.TotalHours, 0)
    FROM Employees e
    LEFT JOIN (
        SELECT 
            EmployeeID,
            SUM(HoursWorked) as TotalHours
        FROM EmployeeProjects 
        WHERE IsActive = 1
        GROUP BY EmployeeID
    ) ep_totals ON e.EmployeeID = ep_totals.EmployeeID
    WHERE e.HoursWorked IS NULL OR e.HoursWorked = 0;
    
    PRINT '✅ Added HoursWorked column to Employees table (summary field)';
    PRINT '✅ Populated with total hours from EmployeeProjects';
END
ELSE
BEGIN
    PRINT '⚠️  HoursWorked column already exists in Employees table';
END

-- =============================================
-- STEP 5: ADD HOURSALLOCATED COLUMN TO EMPLOYEES TABLE (OPTIONAL)
-- =============================================
PRINT '';
PRINT 'STEP 5: Adding HoursAllocated column to Employees table (summary field)...';

-- Check if HoursAllocated column already exists in Employees
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'HoursAllocated')
BEGIN
    -- Add HoursAllocated column as summary field
    ALTER TABLE Employees 
    ADD HoursAllocated DECIMAL(10,2) NULL DEFAULT 0;
    
    -- Populate with total allocated hours from EmployeeProjects
    UPDATE e
    SET HoursAllocated = ISNULL(ep_totals.TotalAllocated, 0)
    FROM Employees e
    LEFT JOIN (
        SELECT 
            EmployeeID,
            SUM(HoursAllocated) as TotalAllocated
        FROM EmployeeProjects 
        WHERE IsActive = 1
        GROUP BY EmployeeID
    ) ep_totals ON e.EmployeeID = ep_totals.EmployeeID
    WHERE e.HoursAllocated IS NULL OR e.HoursAllocated = 0;
    
    PRINT '✅ Added HoursAllocated column to Employees table (summary field)';
    PRINT '✅ Populated with total allocated hours from EmployeeProjects';
END
ELSE
BEGIN
    PRINT '⚠️  HoursAllocated column already exists in Employees table';
END

-- =============================================
-- STEP 6: CREATE UPDATE TRIGGERS FOR AUTOMATIC SYNC
-- =============================================
PRINT '';
PRINT 'STEP 6: Creating triggers to keep summary columns synchronized...';

-- Trigger to update Customers.Country when CountryID changes
IF OBJECT_ID('tr_Customers_UpdateCountry', 'TR') IS NOT NULL
    DROP TRIGGER tr_Customers_UpdateCountry;
GO

CREATE TRIGGER tr_Customers_UpdateCountry
ON Customers
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update Country name when CountryID changes
    UPDATE c
    SET Country = cn.CountryName
    FROM Customers c
    INNER JOIN inserted i ON c.CustomerID = i.CustomerID
    INNER JOIN Countries cn ON i.CountryID = cn.CountryID
    WHERE UPDATE(CountryID);
END;
GO

-- Trigger to update Customers.ContactName when contact names change
IF OBJECT_ID('tr_Customers_UpdateContactName', 'TR') IS NOT NULL
    DROP TRIGGER tr_Customers_UpdateContactName;
GO

CREATE TRIGGER tr_Customers_UpdateContactName
ON Customers
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update ContactName when ContactFirstName or ContactLastName changes
    UPDATE c
    SET ContactName = i.ContactFirstName + ISNULL(' ' + i.ContactLastName, '')
    FROM Customers c
    INNER JOIN inserted i ON c.CustomerID = i.CustomerID
    WHERE UPDATE(ContactFirstName) OR UPDATE(ContactLastName);
END;
GO

-- Trigger to update Employee hours when EmployeeProjects changes
IF OBJECT_ID('tr_EmployeeProjects_UpdateEmployeeHours', 'TR') IS NOT NULL
    DROP TRIGGER tr_EmployeeProjects_UpdateEmployeeHours;
GO

CREATE TRIGGER tr_EmployeeProjects_UpdateEmployeeHours
ON EmployeeProjects
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get affected employees
    DECLARE @AffectedEmployees TABLE (EmployeeID INT);
    
    INSERT INTO @AffectedEmployees (EmployeeID)
    SELECT DISTINCT EmployeeID FROM inserted
    UNION
    SELECT DISTINCT EmployeeID FROM deleted;
    
    -- Update employee summary hours
    UPDATE e
    SET HoursWorked = ISNULL(ep_totals.TotalHours, 0),
        HoursAllocated = ISNULL(ep_totals.TotalAllocated, 0)
    FROM Employees e
    INNER JOIN @AffectedEmployees ae ON e.EmployeeID = ae.EmployeeID
    LEFT JOIN (
        SELECT 
            EmployeeID,
            SUM(HoursWorked) as TotalHours,
            SUM(HoursAllocated) as TotalAllocated
        FROM EmployeeProjects 
        WHERE IsActive = 1
        GROUP BY EmployeeID
    ) ep_totals ON e.EmployeeID = ep_totals.EmployeeID;
END;
GO

PRINT '✅ Created triggers for automatic column synchronization';

-- =============================================
-- STEP 7: VERIFY ALL ADDITIONS
-- =============================================
PRINT '';
PRINT 'STEP 7: Verifying all column additions...';

-- Check Customers table columns
PRINT '';
PRINT 'Customers table columns after additions:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Customers'
  AND COLUMN_NAME IN ('CustomerName', 'CompanyName', 'ContactFirstName', 'ContactLastName', 'ContactName', 'CountryID', 'Country')
ORDER BY COLUMN_NAME;

-- Check Employees table columns
PRINT '';
PRINT 'Employees table new summary columns:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Employees'
  AND COLUMN_NAME IN ('HoursWorked', 'HoursAllocated')
ORDER BY COLUMN_NAME;

-- Sample data verification
PRINT '';
PRINT 'Sample data verification - Customers with new columns:';
SELECT TOP 3
    CustomerID,
    CustomerName,
    CompanyName,      -- New column
    ContactFirstName,
    ContactLastName,
    ContactName,      -- New column
    CountryID,
    Country          -- New column
FROM Customers
ORDER BY CustomerID;

PRINT '';
PRINT 'Sample data verification - Employees with new summary columns:';
SELECT TOP 3
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    HoursWorked,     -- New summary column
    HoursAllocated   -- New summary column
FROM Employees
ORDER BY EmployeeID;

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'COLUMN ADDITIONS COMPLETE!';
PRINT '==============================================';
PRINT '';
PRINT '✅ COLUMNS ADDED:';
PRINT '1. Customers.CompanyName (mapped from CustomerName)';
PRINT '2. Customers.ContactName (combined from ContactFirstName + ContactLastName)';
PRINT '3. Customers.Country (populated from Countries.CountryName)';
PRINT '4. Employees.HoursWorked (summary from EmployeeProjects)';
PRINT '5. Employees.HoursAllocated (summary from EmployeeProjects)';
PRINT '';
PRINT '✅ TRIGGERS CREATED:';
PRINT '1. Auto-update Country when CountryID changes';
PRINT '2. Auto-update ContactName when contact names change';
PRINT '3. Auto-update Employee hours when project assignments change';
PRINT '';
PRINT '📋 NOW YOU CAN USE:';
PRINT 'SELECT CompanyName, ContactName, Country FROM Customers;';
PRINT 'SELECT FirstName, LastName, HoursWorked FROM Employees;';
PRINT '';
PRINT '⚠️  NOTE: The view-based approach (vw_Customers_Training) is still recommended';
PRINT 'for better performance and data integrity, but direct column access now works too.';
PRINT '';
PRINT '==============================================';

GO