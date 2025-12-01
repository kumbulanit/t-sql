-- Quick test query to verify your JOIN works
USE TechCorpDB;
GO

-- First check if we have data
PRINT 'Checking for data...';
SELECT 'Employees' as TableName, COUNT(*) as RecordCount FROM Employees
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments;

-- Your original query (should work perfectly)
PRINT 'Your query results:';
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    d.Location
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.LastName;

-- If no results, this will show all departments that exist
PRINT 'All departments (if query above is empty):';
SELECT DepartmentID, DepartmentName, Location 
FROM Departments 
ORDER BY DepartmentName;