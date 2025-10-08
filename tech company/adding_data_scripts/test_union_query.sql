-- Test the corrected UNION query from Lesson 2
USE TechCorpDB;
GO

-- Test basic UNION (removes duplicates) - corrected version
SELECT FirstName, LastName FROM Employees
UNION
SELECT ContactFirstName AS FirstName, ContactLastName AS LastName FROM Customers;

-- Test UNION ALL (keeps duplicates)
SELECT City FROM Employees
UNION ALL
SELECT City FROM Customers;

-- Test INTERSECT - find cities that have both employees and customers
SELECT City FROM Employees
INTERSECT
SELECT City FROM Customers;

-- Test EXCEPT - find cities with employees but no customers
SELECT City FROM Employees
EXCEPT
SELECT City FROM Customers;