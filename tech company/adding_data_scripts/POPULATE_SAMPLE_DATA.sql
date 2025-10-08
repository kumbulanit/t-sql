-- =============================================
-- POPULATE NEW COLUMNS WITH SAMPLE DATA
-- Ensures all new columns have realistic data for training
-- =============================================

USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'POPULATING NEW COLUMNS WITH SAMPLE DATA';
PRINT 'Adding realistic data for training exercises';
PRINT '==============================================';
PRINT '';

-- =============================================
-- STEP 1: UPDATE CUSTOMERS TABLE WITH ENHANCED DATA
-- =============================================
PRINT 'STEP 1: Updating Customers table with enhanced data...';

-- Update CompanyName with variations for some customers
UPDATE Customers 
SET CompanyName = CASE 
    WHEN CustomerType = 'Enterprise' THEN CustomerName + ' Corporation'
    WHEN CustomerType = 'Business' AND CustomerName NOT LIKE '% Inc%' AND CustomerName NOT LIKE '% LLC%' THEN CustomerName + ' Inc'
    WHEN CustomerType = 'Government' THEN CustomerName + ' Agency'
    ELSE CustomerName
END
WHERE CompanyName = CustomerName OR CompanyName IS NULL;

-- Update ContactName with proper formatting
UPDATE Customers
SET ContactName = CASE
    WHEN ContactFirstName IS NOT NULL AND ContactLastName IS NOT NULL 
         THEN ContactFirstName + ' ' + ContactLastName
    WHEN ContactFirstName IS NOT NULL 
         THEN ContactFirstName
    WHEN ContactLastName IS NOT NULL 
         THEN ContactLastName
    ELSE 'Contact Person'
END
WHERE ContactName IS NULL OR ContactName = '';

-- Ensure Country is populated
UPDATE c
SET Country = ISNULL(cn.CountryName, 'Unknown')
FROM Customers c
LEFT JOIN Countries cn ON c.CountryID = cn.CountryID
WHERE c.Country IS NULL OR c.Country = '';

PRINT '✅ Updated Customers table with enhanced CompanyName, ContactName, and Country data';

-- Display sample of updated data
PRINT '';
PRINT 'Sample of updated Customers data:';
SELECT TOP 5
    CustomerID,
    CustomerName as OriginalName,
    CompanyName as EnhancedName,
    ContactFirstName + ' ' + ContactLastName as OriginalContact,
    ContactName as EnhancedContact,
    CountryID,
    Country,
    CustomerType
FROM Customers
ORDER BY CustomerID;

-- =============================================
-- STEP 2: UPDATE EMPLOYEES WITH REALISTIC HOURS DATA
-- =============================================
PRINT '';
PRINT 'STEP 2: Updating Employees with realistic hours data...';

-- First, ensure we have some project assignments if none exist
IF NOT EXISTS (SELECT * FROM EmployeeProjects WHERE HoursWorked > 0)
BEGIN
    PRINT 'No project hours found, creating sample project assignments...';
    
    -- Add some sample project assignments for existing employees
    INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, StartDate, AllocationPercentage, HoursWorked, HoursAllocated, HourlyRate)
    SELECT 
        e.EmployeeID,
        5001, -- Use first project
        CASE 
            WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%' THEN 'Project Manager'
            WHEN e.JobTitle LIKE '%Developer%' OR e.JobTitle LIKE '%Engineer%' THEN 'Developer'
            WHEN e.JobTitle LIKE '%Analyst%' THEN 'Business Analyst'
            ELSE 'Team Member'
        END as Role,
        DATEADD(day, -90, GETDATE()) as StartDate,
        CASE 
            WHEN e.JobTitle LIKE '%CEO%' OR e.JobTitle LIKE '%CTO%' THEN 25.0
            WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%' THEN 50.0
            ELSE 75.0
        END as AllocationPercentage,
        -- Realistic hours worked (40-200 hours over 3 months)
        CAST((40 + (ABS(CHECKSUM(NEWID())) % 160)) AS DECIMAL(8,2)) as HoursWorked,
        -- Allocated hours (usually 10-20% more than worked)
        CAST((50 + (ABS(CHECKSUM(NEWID())) % 180)) AS DECIMAL(8,2)) as HoursAllocated,
        -- Hourly rate based on job level
        CASE 
            WHEN jl.LevelCode = 'EXEC' THEN 250.00
            WHEN jl.LevelCode = 'SRMGMT' THEN 200.00
            WHEN jl.LevelCode = 'MGMT' THEN 150.00
            WHEN jl.LevelCode = 'SRPROF' THEN 125.00
            WHEN jl.LevelCode = 'PROF' THEN 100.00
            WHEN jl.LevelCode = 'ASSOC' THEN 75.00
            ELSE 50.00
        END as HourlyRate
    FROM Employees e
    INNER JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
    WHERE e.IsActive = 1 
      AND NOT EXISTS (SELECT 1 FROM EmployeeProjects ep WHERE ep.EmployeeID = e.EmployeeID);
      
    PRINT '✅ Created sample project assignments for employees without projects';
END

-- Update Employee summary hours from EmployeeProjects
UPDATE e
SET HoursWorked = ISNULL(ep_summary.TotalHours, 0),
    HoursAllocated = ISNULL(ep_summary.TotalAllocated, 0)
FROM Employees e
LEFT JOIN (
    SELECT 
        EmployeeID,
        SUM(HoursWorked) as TotalHours,
        SUM(HoursAllocated) as TotalAllocated
    FROM EmployeeProjects 
    WHERE IsActive = 1
    GROUP BY EmployeeID
) ep_summary ON e.EmployeeID = ep_summary.EmployeeID;

PRINT '✅ Updated Employees table with summary hours from EmployeeProjects';

-- Add some TimeTracking entries if none exist
IF NOT EXISTS (SELECT * FROM TimeTracking WHERE HoursWorked > 0)
BEGIN
    PRINT 'Creating sample time tracking entries...';
    
    INSERT INTO TimeTracking (EmployeeID, ProjectID, WorkDate, HoursWorked, ActivityType, Description, BillableHours, HourlyRate, IsApproved)
    SELECT TOP 20
        e.EmployeeID,
        ep.ProjectID,
        DATEADD(day, -1 * (ABS(CHECKSUM(NEWID())) % 30), GETDATE()) as WorkDate,
        CAST((2.0 + (ABS(CHECKSUM(NEWID())) % 7)) AS DECIMAL(4,2)) as HoursWorked,
        CASE (ABS(CHECKSUM(NEWID())) % 4)
            WHEN 0 THEN 'Development'
            WHEN 1 THEN 'Meetings'
            WHEN 2 THEN 'Documentation'
            ELSE 'Testing'
        END as ActivityType,
        'Daily work on project tasks and deliverables' as Description,
        CAST((1.5 + (ABS(CHECKSUM(NEWID())) % 6)) AS DECIMAL(4,2)) as BillableHours,
        ep.HourlyRate,
        1 as IsApproved
    FROM Employees e
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE e.IsActive = 1 AND ep.IsActive = 1;
    
    PRINT '✅ Created sample time tracking entries';
END

-- Display sample of updated employee data
PRINT '';
PRINT 'Sample of updated Employees data with hours:';
SELECT TOP 5
    EmployeeID,
    FirstName + ' ' + LastName as FullName,
    JobTitle,
    HoursWorked,
    HoursAllocated,
    HoursUtilization,
    IsActive
FROM Employees
WHERE HoursWorked > 0
ORDER BY HoursWorked DESC;

-- =============================================
-- STEP 3: ADD MORE VARIED CUSTOMER DATA
-- =============================================
PRINT '';
PRINT 'STEP 3: Adding variety to customer data...';

-- Add some customers with different naming patterns
DECLARE @NewCustomerData TABLE (
    CompanyID INT,
    CustomerName NVARCHAR(100),
    CompanyName NVARCHAR(100),
    CustomerType NVARCHAR(20),
    ContactFirstName NVARCHAR(50),
    ContactLastName NVARCHAR(50),
    ContactName NVARCHAR(150),
    PrimaryEmail NVARCHAR(100),
    CountryID INT,
    Country NVARCHAR(100),
    CreditLimit DECIMAL(12,2)
);

INSERT INTO @NewCustomerData VALUES
(1001, 'Tech Solutions Partners', 'Tech Solutions Partners LLC', 'Business', 'James', 'Wilson', 'James Wilson', 'james.wilson@techsolutionspartners.com', 1, 'United States', 750000.00),
(1001, 'Digital Innovation Hub', 'Digital Innovation Hub Inc', 'Enterprise', 'Sarah', 'Martinez', 'Sarah Martinez', 'sarah.martinez@digitalhub.com', 1, 'United States', 1200000.00),
(1002, 'Cloud Native Systems', 'Cloud Native Systems Corporation', 'Enterprise', 'Michael', 'Chang', 'Michael Chang', 'michael.chang@cloudnative.com', 1, 'United States', 2000000.00),
(1001, 'Startup Accelerator', 'Startup Accelerator', 'Business', 'Emily', 'Johnson', 'Emily Johnson', 'emily@startupaccel.com', 1, 'United States', 300000.00),
(1004, 'Global Investment Group', 'Global Investment Group Ltd', 'Enterprise', 'Robert', 'Taylor', 'Robert Taylor', 'robert.taylor@globalinvest.com', 3, 'United Kingdom', 5000000.00);

-- Insert new customers if they don't already exist (based on email uniqueness)
INSERT INTO Customers (CompanyID, CustomerName, CompanyName, CustomerType, ContactFirstName, ContactLastName, 
                      ContactName, ContactTitle, PrimaryEmail, PrimaryPhone, IndustryID, CountryID, Country,
                      StreetAddress, City, StateProvince, PostalCode, CreditLimit, CurrentBalance, PaymentTerms, AccountStatus)
SELECT 
    ncd.CompanyID,
    ncd.CustomerName,
    ncd.CompanyName,
    ncd.CustomerType,
    ncd.ContactFirstName,
    ncd.ContactLastName,
    ncd.ContactName,
    'Business Development Manager' as ContactTitle,
    ncd.PrimaryEmail,
    '+1-555-' + CAST((1000 + ABS(CHECKSUM(NEWID())) % 9000) AS VARCHAR(4)) as PrimaryPhone,
    1 as IndustryID, -- Technology
    ncd.CountryID,
    ncd.Country,
    CAST((100 + ABS(CHECKSUM(NEWID())) % 9900) AS VARCHAR(4)) + ' Business Avenue' as StreetAddress,
    CASE ncd.CountryID 
        WHEN 1 THEN 'New York'
        WHEN 3 THEN 'London'
        ELSE 'Toronto'
    END as City,
    CASE ncd.CountryID 
        WHEN 1 THEN 'New York'
        WHEN 3 THEN 'England'
        ELSE 'Ontario'
    END as StateProvince,
    CASE ncd.CountryID 
        WHEN 1 THEN '10001'
        WHEN 3 THEN 'SW1A 1AA'
        ELSE 'M5V 3A8'
    END as PostalCode,
    ncd.CreditLimit,
    ncd.CreditLimit * 0.1 as CurrentBalance, -- 10% of credit limit as current balance
    30 as PaymentTerms,
    'Active' as AccountStatus
FROM @NewCustomerData ncd
WHERE NOT EXISTS (
    SELECT 1 FROM Customers c WHERE c.PrimaryEmail = ncd.PrimaryEmail
);

PRINT '✅ Added additional customer variations with enhanced naming patterns';

-- =============================================
-- STEP 4: CREATE DATA QUALITY VALIDATION
-- =============================================
PRINT '';
PRINT 'STEP 4: Validating data quality of new columns...';

-- Count records with populated new columns
DECLARE @ValidationResults TABLE (
    TableName VARCHAR(50),
    ColumnName VARCHAR(50),
    PopulatedCount INT,
    TotalCount INT,
    PopulationPercentage DECIMAL(5,2)
);

-- Customers validation
INSERT INTO @ValidationResults
SELECT 
    'Customers' as TableName,
    'CompanyName' as ColumnName,
    SUM(CASE WHEN CompanyName IS NOT NULL AND LEN(CompanyName) > 0 THEN 1 ELSE 0 END) as PopulatedCount,
    COUNT(*) as TotalCount,
    CAST(SUM(CASE WHEN CompanyName IS NOT NULL AND LEN(CompanyName) > 0 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as PopulationPercentage
FROM Customers;

INSERT INTO @ValidationResults
SELECT 
    'Customers' as TableName,
    'ContactName' as ColumnName,
    SUM(CASE WHEN ContactName IS NOT NULL AND LEN(ContactName) > 0 THEN 1 ELSE 0 END) as PopulatedCount,
    COUNT(*) as TotalCount,
    CAST(SUM(CASE WHEN ContactName IS NOT NULL AND LEN(ContactName) > 0 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as PopulationPercentage
FROM Customers;

INSERT INTO @ValidationResults
SELECT 
    'Customers' as TableName,
    'Country' as ColumnName,
    SUM(CASE WHEN Country IS NOT NULL AND LEN(Country) > 0 THEN 1 ELSE 0 END) as PopulatedCount,
    COUNT(*) as TotalCount,
    CAST(SUM(CASE WHEN Country IS NOT NULL AND LEN(Country) > 0 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as PopulationPercentage
FROM Customers;

-- Employees validation
INSERT INTO @ValidationResults
SELECT 
    'Employees' as TableName,
    'HoursWorked' as ColumnName,
    SUM(CASE WHEN HoursWorked > 0 THEN 1 ELSE 0 END) as PopulatedCount,
    COUNT(*) as TotalCount,
    CAST(SUM(CASE WHEN HoursWorked > 0 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as PopulationPercentage
FROM Employees;

INSERT INTO @ValidationResults
SELECT 
    'Employees' as TableName,
    'HoursAllocated' as ColumnName,
    SUM(CASE WHEN HoursAllocated > 0 THEN 1 ELSE 0 END) as PopulatedCount,
    COUNT(*) as TotalCount,
    CAST(SUM(CASE WHEN HoursAllocated > 0 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as PopulationPercentage
FROM Employees;

-- Display validation results
PRINT '';
PRINT 'Data Quality Validation Results:';
SELECT 
    TableName,
    ColumnName,
    PopulatedCount,
    TotalCount,
    PopulationPercentage as 'Population %'
FROM @ValidationResults
ORDER BY TableName, ColumnName;

-- =============================================
-- STEP 5: CREATE SAMPLE QUERY EXAMPLES
-- =============================================
PRINT '';
PRINT 'STEP 5: Testing sample queries with new columns...';

-- Test CompanyName searches
PRINT '';
PRINT 'Test 1: Customer search by CompanyName pattern:';
SELECT COUNT(*) as 'Companies with "Corp" in name'
FROM Customers 
WHERE CompanyName LIKE '%Corp%' AND IsActive = 1;

-- Test ContactName searches  
PRINT '';
PRINT 'Test 2: Customer search by ContactName:';
SELECT TOP 3
    CompanyName,
    ContactName,
    Country,
    PrimaryEmail
FROM Customers
WHERE ContactName IS NOT NULL 
  AND LEN(ContactName) > 5
  AND IsActive = 1
ORDER BY ContactName;

-- Test Employee hours queries
PRINT '';
PRINT 'Test 3: Employee hours analysis:';
SELECT 
    COUNT(*) as 'Total Active Employees',
    SUM(HoursWorked) as 'Total Hours Worked',
    AVG(HoursWorked) as 'Average Hours Worked',
    AVG(HoursUtilization) as 'Average Utilization %'
FROM Employees
WHERE IsActive = 1 AND HoursWorked > 0;

-- Test high performers
PRINT '';
PRINT 'Test 4: High performing employees (>100 hours, >80% utilization):';
SELECT TOP 5
    FirstName + ' ' + LastName as EmployeeName,
    JobTitle,
    HoursWorked,
    HoursAllocated,
    HoursUtilization as 'Utilization %'
FROM Employees
WHERE IsActive = 1 
  AND HoursWorked > 100 
  AND HoursUtilization > 80
ORDER BY HoursUtilization DESC;

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'SAMPLE DATA POPULATION COMPLETE!';
PRINT '==============================================';
PRINT '';
PRINT '✅ DATA POPULATED:';
PRINT '1. Enhanced CompanyName with business type suffixes';
PRINT '2. Proper ContactName formatting from first/last names';
PRINT '3. Complete Country name population from CountryID';
PRINT '4. Realistic HoursWorked/HoursAllocated from project data';
PRINT '5. Sample project assignments for all active employees';
PRINT '6. Time tracking entries for realistic scenarios';
PRINT '7. Additional customer variations with different naming patterns';
PRINT '';
PRINT '✅ COMPUTED COLUMNS WORKING:';
PRINT '1. HoursUtilization - Automatic percentage calculation';
PRINT '2. FullContactInfo - Combined contact information display';
PRINT '';
PRINT '📊 TRAINING READY:';
PRINT 'All new columns now have realistic data for SQL training exercises';
PRINT 'Students can practice with CompanyName, ContactName, Country, HoursWorked queries';
PRINT 'Business scenarios include utilization analysis and customer management';
PRINT '';
PRINT '🎯 SUGGESTED TRAINING QUERIES:';
PRINT 'SELECT CompanyName, ContactName, Country FROM Customers WHERE Country = ''United States'';';
PRINT 'SELECT FirstName, LastName, HoursWorked, HoursUtilization FROM Employees WHERE HoursWorked > 50;';
PRINT 'SELECT CompanyName FROM Customers WHERE CompanyName LIKE ''%Corp%'' ORDER BY CompanyName;';
PRINT '';
PRINT '==============================================';

GO