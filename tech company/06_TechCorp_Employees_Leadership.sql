-- =============================================
-- TechCorp Database: Employees Data Population
-- Module 3-4: Employee Records (Part 1 - Leadership)
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- EMPLOYEES DATA - PART 1: LEADERSHIP & MANAGEMENT
-- Note: We'll start with leadership to establish manager relationships
-- =============================================
PRINT 'Populating Employees table (Leadership & Management)...';

INSERT INTO Employees (CompanyID, DepartmentID, JobLevelID, EmployeeNumber, FirstName, LastName, 
    JobTitle, DirectManagerID, Email, WorkPhone, HireDate, BaseSalary, BonusTarget, 
    EmploymentType, WorkLocation, Gender, Nationality) VALUES

-- TechCorp Solutions (1001) - Leadership Team
(1001, 2001, 3010, 'TC001', 'Sarah', 'Chen', 'VP of Engineering', NULL, 'sarah.chen@techcorpsolutions.com', '+1-555-0101', '2018-03-15', 425000.00, 25.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),
(1001, 2002, 3009, 'TC002', 'Michael', 'Rodriguez', 'Director of Product', NULL, 'michael.rodriguez@techcorpsolutions.com', '+1-555-0102', '2019-01-20', 285000.00, 20.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2003, 3009, 'TC003', 'Jennifer', 'Kim', 'Director of Sales', NULL, 'jennifer.kim@techcorpsolutions.com', '+1-555-0103', '2018-08-10', 275000.00, 30.00, 'Full-Time', 'San Francisco, CA', 'F', 'Korean-American'),
(1001, 2004, 3008, 'TC004', 'David', 'Thompson', 'Senior Marketing Manager', 4003, 'david.thompson@techcorpsolutions.com', '+1-555-0104', '2019-06-05', 165000.00, 15.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2005, 3008, 'TC005', 'Lisa', 'Wang', 'Senior HR Manager', NULL, 'lisa.wang@techcorpsolutions.com', '+1-555-0105', '2018-11-12', 155000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'F', 'Chinese-American'),
(1001, 2006, 3008, 'TC006', 'Robert', 'Johnson', 'Senior Finance Manager', NULL, 'robert.johnson@techcorpsolutions.com', '+1-555-0106', '2019-02-28', 160000.00, 15.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),

-- TechCorp Solutions - Senior Engineers and Leads
(1001, 2001, 3006, 'TC007', 'Alex', 'Patel', 'Engineering Manager', 4001, 'alex.patel@techcorpsolutions.com', '+1-555-0107', '2019-04-10', 185000.00, 18.00, 'Full-Time', 'San Francisco, CA', 'M', 'Indian-American'),
(1001, 2001, 3005, 'TC008', 'Emma', 'Davis', 'Principal Engineer', 4007, 'emma.davis@techcorpsolutions.com', '+1-555-0108', '2018-07-15', 195000.00, 15.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),
(1001, 2001, 3004, 'TC009', 'James', 'Wilson', 'Lead Software Engineer', 4007, 'james.wilson@techcorpsolutions.com', '+1-555-0109', '2019-09-20', 145000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2002, 3004, 'TC010', 'Sophie', 'Martinez', 'Lead Product Manager', 4002, 'sophie.martinez@techcorpsolutions.com', '+1-555-0110', '2020-01-08', 155000.00, 18.00, 'Full-Time', 'San Francisco, CA', 'F', 'Spanish-American'),

-- Global Finance Corp (1004) - Leadership Team
(1004, 2015, 3010, 'GFC001', 'William', 'Anderson', 'VP Investment Banking', NULL, 'william.anderson@globalfinancecorp.com', '+1-555-0201', '2015-06-01', 485000.00, 40.00, 'Full-Time', 'New York, NY', 'M', 'American'),
(1004, 2016, 3009, 'GFC002', 'Catherine', 'Brown', 'Director of Risk Management', NULL, 'catherine.brown@globalfinancecorp.com', '+1-555-0202', '2016-03-15', 325000.00, 25.00, 'Full-Time', 'New York, NY', 'F', 'American'),
(1004, 2017, 3009, 'GFC003', 'Thomas', 'Lee', 'Director of Compliance', NULL, 'thomas.lee@globalfinancecorp.com', '+1-555-0203', '2016-08-20', 315000.00, 20.00, 'Full-Time', 'New York, NY', 'M', 'Korean-American'),
(1004, 2018, 3009, 'GFC004', 'Michelle', 'Garcia', 'Director of Technology', NULL, 'michelle.garcia@globalfinancecorp.com', '+1-555-0204', '2017-01-10', 295000.00, 22.00, 'Full-Time', 'New York, NY', 'F', 'Mexican-American'),

-- HealthTech Innovations (1006) - Leadership Team
(1006, 2023, 3009, 'HTI001', 'Dr. Amanda', 'Foster', 'Director of R&D', NULL, 'amanda.foster@healthtechinnovations.com', '+1-555-0301', '2016-04-01', 285000.00, 20.00, 'Full-Time', 'Boston, MA', 'F', 'American'),
(1006, 2024, 3008, 'HTI002', 'Dr. Richard', 'Kumar', 'Clinical Affairs Manager', 4015, 'richard.kumar@healthtechinnovations.com', '+1-555-0302', '2017-02-15', 175000.00, 15.00, 'Full-Time', 'Boston, MA', 'M', 'Indian-American'),
(1006, 2025, 3008, 'HTI003', 'Maria', 'Gonzalez', 'Regulatory Affairs Manager', 4015, 'maria.gonzalez@healthtechinnovations.com', '+1-555-0303', '2017-06-10', 165000.00, 12.00, 'Full-Time', 'Boston, MA', 'F', 'Mexican-American'),

-- AutoManu Systems (1008) - Leadership Team
(1008, 2032, 3010, 'AMS001', 'John', 'Miller', 'VP of Engineering', NULL, 'john.miller@automanusystems.com', '+1-555-0401', '2012-01-15', 395000.00, 30.00, 'Full-Time', 'Detroit, MI', 'M', 'American'),
(1008, 2033, 3009, 'AMS002', 'Patricia', 'Davis', 'Director of Manufacturing', NULL, 'patricia.davis@automanusystems.com', '+1-555-0402', '2013-05-20', 275000.00, 25.00, 'Full-Time', 'Detroit, MI', 'F', 'American'),
(1008, 2034, 3008, 'AMS003', 'Kevin', 'Zhang', 'Quality Assurance Manager', 4019, 'kevin.zhang@automanusystems.com', '+1-555-0403', '2014-03-10', 155000.00, 15.00, 'Full-Time', 'Detroit, MI', 'M', 'Chinese-American'),

-- CloudTech Innovations (1002) - Small Company Leadership
(1002, 2008, 3008, 'CTI001', 'Mark', 'Stevens', 'Development Manager', NULL, 'mark.stevens@cloudtechinnovations.com', '+1-555-0151', '2019-01-15', 145000.00, 18.00, 'Full-Time', 'Seattle, WA', 'M', 'American'),
(1002, 2009, 3007, 'CTI002', 'Rachel', 'Adams', 'DevOps Manager', 4021, 'rachel.adams@cloudtechinnovations.com', '+1-555-0152', '2019-03-20', 135000.00, 15.00, 'Full-Time', 'Seattle, WA', 'F', 'American'),

-- EnerTech Global (1012) - Large Energy Company Leadership
(1012, 2047, 3010, 'ETG001', 'Charles', 'Williams', 'VP of Production', NULL, 'charles.williams@enertechglobal.com', '+1-555-0601', '2010-03-01', 465000.00, 35.00, 'Full-Time', 'Houston, TX', 'M', 'American'),
(1012, 2046, 3009, 'ETG002', 'Sandra', 'Johnson', 'Director of Exploration', NULL, 'sandra.johnson@enertechglobal.com', '+1-555-0602', '2011-07-15', 325000.00, 28.00, 'Full-Time', 'Houston, TX', 'F', 'American'),
(1012, 2048, 3009, 'ETG003', 'Robert', 'Taylor', 'Director of Engineering', NULL, 'robert.taylor@enertechglobal.com', '+1-555-0603', '2012-02-10', 295000.00, 25.00, 'Full-Time', 'Houston, TX', 'M', 'American');

SELECT COUNT(*) AS LeadershipEmployeesInserted FROM Employees;

PRINT 'Leadership and management employees populated successfully!';
PRINT 'Total leadership employees: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Now update department managers
PRINT 'Updating department manager assignments...';

UPDATE Departments SET ManagerEmployeeID = 4001 WHERE DepartmentID = 2001; -- Engineering - Sarah Chen
UPDATE Departments SET ManagerEmployeeID = 4002 WHERE DepartmentID = 2002; -- Product - Michael Rodriguez
UPDATE Departments SET ManagerEmployeeID = 4003 WHERE DepartmentID = 2003; -- Sales - Jennifer Kim
UPDATE Departments SET ManagerEmployeeID = 4004 WHERE DepartmentID = 2004; -- Marketing - David Thompson
UPDATE Departments SET ManagerEmployeeID = 4005 WHERE DepartmentID = 2005; -- HR - Lisa Wang
UPDATE Departments SET ManagerEmployeeID = 4006 WHERE DepartmentID = 2006; -- Finance - Robert Johnson

UPDATE Departments SET ManagerEmployeeID = 4011 WHERE DepartmentID = 2015; -- Investment Banking - William Anderson
UPDATE Departments SET ManagerEmployeeID = 4012 WHERE DepartmentID = 2016; -- Risk Management - Catherine Brown
UPDATE Departments SET ManagerEmployeeID = 4013 WHERE DepartmentID = 2017; -- Compliance - Thomas Lee
UPDATE Departments SET ManagerEmployeeID = 4014 WHERE DepartmentID = 2018; -- Technology - Michelle Garcia

UPDATE Departments SET ManagerEmployeeID = 4015 WHERE DepartmentID = 2023; -- R&D - Dr. Amanda Foster
UPDATE Departments SET ManagerEmployeeID = 4016 WHERE DepartmentID = 2024; -- Clinical Affairs - Dr. Richard Kumar
UPDATE Departments SET ManagerEmployeeID = 4017 WHERE DepartmentID = 2025; -- Regulatory Affairs - Maria Gonzalez

UPDATE Departments SET ManagerEmployeeID = 4018 WHERE DepartmentID = 2032; -- Engineering - John Miller
UPDATE Departments SET ManagerEmployeeID = 4019 WHERE DepartmentID = 2033; -- Manufacturing - Patricia Davis
UPDATE Departments SET ManagerEmployeeID = 4020 WHERE DepartmentID = 2034; -- Quality Assurance - Kevin Zhang

UPDATE Departments SET ManagerEmployeeID = 4021 WHERE DepartmentID = 2008; -- Development - Mark Stevens
UPDATE Departments SET ManagerEmployeeID = 4022 WHERE DepartmentID = 2009; -- DevOps - Rachel Adams

UPDATE Departments SET ManagerEmployeeID = 4023 WHERE DepartmentID = 2047; -- Production - Charles Williams
UPDATE Departments SET ManagerEmployeeID = 4024 WHERE DepartmentID = 2046; -- Exploration - Sandra Johnson
UPDATE Departments SET ManagerEmployeeID = 4025 WHERE DepartmentID = 2048; -- Engineering - Robert Taylor

PRINT 'Department manager assignments completed!';
PRINT 'Ready for regular employee data population.';