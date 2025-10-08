-- COMMON QUERY FIXES FOR TECHCORP DATABASE ERRORS
-- Copy and modify these corrected query patterns

USE TechCorpDB;
GO

PRINT '=== CORRECTED QUERY EXAMPLES ===';
PRINT '';

-- FIX 1: Employee queries (EmployeeID column reference)
PRINT '1. EMPLOYEE QUERIES - CORRECT PATTERNS:';
PRINT '======================================';

-- Basic employee selection
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    e.BaseSalary
FROM Employees e
WHERE e.IsActive = 1;

-- Employee with department (fixing ambiguous IsActive)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName,
    d.Location,
    e.IsActive as EmployeeActive,
    d.IsActive as DepartmentActive
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND d.IsActive = 1;

PRINT '';
PRINT '2. COMPANY-CUSTOMER QUERIES - CORRECT PATTERNS:';
PRINT '==============================================';

-- Company and customer data (fixing CompanyName and ContactName)
SELECT 
    co.CompanyName,
    co.IndustryID,
    cust.CustomerName,
    cust.ContactFirstName + ' ' + cust.ContactLastName as ContactName,
    cust.PrimaryEmail,
    cust.AccountStatus
FROM Companies co
INNER JOIN Customers cust ON co.CompanyID = cust.CompanyID
WHERE co.IsActive = 1 AND cust.IsActive = 1;

PRINT '';
PRINT '3. MULTI-TABLE JOINS - AVOIDING AMBIGUOUS COLUMNS:';
PRINT '=================================================';

-- Complex join with proper aliases for IsActive columns
SELECT 
    co.CompanyName,
    d.DepartmentName,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    p.ProjectName,
    ep.Role as ProjectRole,
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
  AND ep.IsActive = 1;

PRINT '';
PRINT '4. SPECIFIC ERROR FIXES:';
PRINT '=======================';

-- If you got "Invalid column name 'EmployeeID'" - use this pattern:
SELECT e.EmployeeID FROM Employees e; -- ✓ Correct

-- If you got "Ambiguous column name 'IsActive'" - use this pattern:
SELECT e.IsActive, d.IsActive 
FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID; -- ✓ Correct with aliases

-- If you got "Invalid column name 'CompanyName'" from Customers table:
SELECT 
    c.CompanyName,      -- ✓ From Companies table
    cust.CustomerName   -- ✓ From Customers table
FROM Companies c
JOIN Customers cust ON c.CompanyID = cust.CompanyID;

-- If you got "Invalid column name 'ContactName'":
SELECT 
    cust.ContactFirstName,
    cust.ContactLastName,
    cust.ContactFirstName + ' ' + cust.ContactLastName as FullContactName
FROM Customers cust;

PRINT '';
PRINT '5. TABLE COLUMN REFERENCE GUIDE:';
PRINT '================================';

-- Employees table key columns
PRINT 'EMPLOYEES TABLE:';
PRINT 'EmployeeID, FirstName, LastName, JobTitle, ManagerID, IsActive';
PRINT '';

-- Departments table key columns  
PRINT 'DEPARTMENTS TABLE:';
PRINT 'DepartmentID, DepartmentName, Location, ManagerEmployeeID, IsActive';
PRINT '';

-- Companies table key columns
PRINT 'COMPANIES TABLE:';  
PRINT 'CompanyID, CompanyName, IndustryID, IsActive';
PRINT '';

-- Customers table key columns
PRINT 'CUSTOMERS TABLE:';
PRINT 'CustomerID, CustomerName, ContactFirstName, ContactLastName, IsActive';
PRINT 'NOTE: No "ContactName" - use ContactFirstName + ContactLastName';
PRINT '';

-- Projects table key columns
PRINT 'PROJECTS TABLE:';
PRINT 'ProjectID, ProjectName, Status, IsActive';
PRINT '';

-- EmployeeProjects junction table
PRINT 'EMPLOYEEPROJECTS TABLE:';
PRINT 'EmployeeProjectID, EmployeeID, ProjectID, Role, AllocationPercentage, HoursWorked, IsActive';
PRINT '';

PRINT '=== QUERY FIXES COMPLETE ===';
PRINT 'Use the patterns above to fix your specific queries.';