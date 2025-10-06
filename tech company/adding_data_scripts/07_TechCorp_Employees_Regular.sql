-- =============================================
-- TechCorp Database: Employees Data Population
-- Module 3-4: Employee Records (Part 2 - Regular Staff)
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- EMPLOYEES DATA - PART 2: REGULAR EMPLOYEES
-- =============================================
PRINT 'Populating Employees table (Regular Staff)...';

INSERT INTO Employees (CompanyID, DepartmentID, JobLevelID, EmployeeNumber, FirstName, LastName, 
    JobTitle, DirectManagerID, Email, WorkPhone, HireDate, BaseSalary, BonusTarget, 
    EmploymentType, WorkLocation, Gender, Nationality) VALUES

-- TechCorp Solutions (1001) - Engineering Team
(1001, 2001, 3004, 'TC011', 'Daniel', 'Chang', 'Senior Software Engineer', 4007, 'daniel.chang@techcorpsolutions.com', '+1-555-0111', '2020-03-15', 125000.00, 10.00, 'Full-Time', 'San Francisco, CA', 'M', 'Korean-American'),
(1001, 2001, 3004, 'TC012', 'Jessica', 'Brown', 'Senior Software Engineer', 4007, 'jessica.brown@techcorpsolutions.com', '+1-555-0112', '2020-05-20', 120000.00, 10.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),
(1001, 2001, 3003, 'TC013', 'Ryan', 'Miller', 'Software Engineer', 4009, 'ryan.miller@techcorpsolutions.com', '+1-555-0113', '2021-01-10', 95000.00, 8.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2001, 3003, 'TC014', 'Ashley', 'Garcia', 'Software Engineer', 4009, 'ashley.garcia@techcorpsolutions.com', '+1-555-0114', '2021-02-15', 92000.00, 8.00, 'Full-Time', 'San Francisco, CA', 'F', 'Mexican-American'),
(1001, 2001, 3002, 'TC015', 'Brandon', 'Lee', 'Junior Software Engineer', 4026, 'brandon.lee@techcorpsolutions.com', '+1-555-0115', '2022-06-01', 72000.00, 5.00, 'Full-Time', 'San Francisco, CA', 'M', 'Korean-American'),
(1001, 2001, 3002, 'TC016', 'Samantha', 'Taylor', 'Junior Software Engineer', 4026, 'samantha.taylor@techcorpsolutions.com', '+1-555-0116', '2022-08-15', 70000.00, 5.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),

-- TechCorp Solutions - Product Management Team
(1001, 2002, 3003, 'TC017', 'Kevin', 'White', 'Product Manager', 4002, 'kevin.white@techcorpsolutions.com', '+1-555-0117', '2020-09-10', 105000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2002, 3003, 'TC018', 'Nicole', 'Anderson', 'Product Manager', 4002, 'nicole.anderson@techcorpsolutions.com', '+1-555-0118', '2021-01-20', 102000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),
(1001, 2002, 3002, 'TC019', 'Jason', 'Rodriguez', 'Associate Product Manager', 4010, 'jason.rodriguez@techcorpsolutions.com', '+1-555-0119', '2022-03-05', 78000.00, 8.00, 'Full-Time', 'San Francisco, CA', 'M', 'Mexican-American'),

-- TechCorp Solutions - Sales Team
(1001, 2003, 3004, 'TC020', 'Steven', 'Davis', 'Senior Sales Manager', 4003, 'steven.davis@techcorpsolutions.com', '+1-555-0120', '2019-11-15', 135000.00, 20.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2003, 3003, 'TC021', 'Michelle', 'Wilson', 'Sales Manager', 4035, 'michelle.wilson@techcorpsolutions.com', '+1-555-0121', '2020-04-10', 95000.00, 15.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),
(1001, 2003, 3002, 'TC022', 'Christopher', 'Jones', 'Sales Representative', 4036, 'christopher.jones@techcorpsolutions.com', '+1-555-0122', '2021-07-20', 65000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'M', 'American'),
(1001, 2003, 3002, 'TC023', 'Amanda', 'Martinez', 'Sales Representative', 4036, 'amanda.martinez@techcorpsolutions.com', '+1-555-0123', '2021-09-15', 63000.00, 12.00, 'Full-Time', 'San Francisco, CA', 'F', 'Spanish-American'),

-- TechCorp Solutions - Marketing Team
(1001, 2004, 3003, 'TC024', 'Jonathan', 'Lopez', 'Marketing Manager', 4004, 'jonathan.lopez@techcorpsolutions.com', '+1-555-0124', '2020-08-05', 88000.00, 10.00, 'Full-Time', 'San Francisco, CA', 'M', 'Mexican-American'),
(1001, 2004, 3002, 'TC025', 'Stephanie', 'Clark', 'Marketing Specialist', 4039, 'stephanie.clark@techcorpsolutions.com', '+1-555-0125', '2021-11-10', 68000.00, 8.00, 'Full-Time', 'San Francisco, CA', 'F', 'American'),

-- CloudTech Innovations (1002) - Development Team
(1002, 2008, 3004, 'CTI003', 'Andrew', 'Peterson', 'Senior Developer', 4021, 'andrew.peterson@cloudtechinnovations.com', '+1-555-0153', '2019-08-10', 115000.00, 12.00, 'Full-Time', 'Seattle, WA', 'M', 'American'),
(1002, 2008, 3003, 'CTI004', 'Lauren', 'Scott', 'Full Stack Developer', 4041, 'lauren.scott@cloudtechinnovations.com', '+1-555-0154', '2020-02-15', 95000.00, 10.00, 'Full-Time', 'Seattle, WA', 'F', 'American'),
(1002, 2008, 3003, 'CTI005', 'Tyler', 'Green', 'Backend Developer', 4041, 'tyler.green@cloudtechinnovations.com', '+1-555-0155', '2020-06-20', 92000.00, 10.00, 'Full-Time', 'Seattle, WA', 'M', 'American'),
(1002, 2008, 3002, 'CTI006', 'Megan', 'Hall', 'Junior Developer', 4042, 'megan.hall@cloudtechinnovations.com', '+1-555-0156', '2021-09-01', 72000.00, 8.00, 'Full-Time', 'Seattle, WA', 'F', 'American'),

-- CloudTech Innovations - DevOps Team
(1002, 2009, 3003, 'CTI007', 'Nathan', 'Young', 'DevOps Engineer', 4022, 'nathan.young@cloudtechinnovations.com', '+1-555-0157', '2020-01-15', 105000.00, 12.00, 'Full-Time', 'Seattle, WA', 'M', 'American'),
(1002, 2009, 3002, 'CTI008', 'Brittany', 'King', 'Junior DevOps Engineer', 4045, 'brittany.king@cloudtechinnovations.com', '+1-555-0158', '2021-04-10', 78000.00, 8.00, 'Full-Time', 'Seattle, WA', 'F', 'American'),

-- Global Finance Corp (1004) - Investment Banking Team
(1004, 2015, 3004, 'GFC005', 'Matthew', 'Turner', 'Senior Investment Banker', 4011, 'matthew.turner@globalfinancecorp.com', '+1-555-0205', '2017-09-15', 185000.00, 35.00, 'Full-Time', 'New York, NY', 'M', 'American'),
(1004, 2015, 3004, 'GFC006', 'Elizabeth', 'Phillips', 'Senior Investment Banker', 4011, 'elizabeth.phillips@globalfinancecorp.com', '+1-555-0206', '2018-01-20', 182000.00, 35.00, 'Full-Time', 'New York, NY', 'F', 'American'),
(1004, 2015, 3003, 'GFC007', 'Joshua', 'Campbell', 'Investment Banker', 4047, 'joshua.campbell@globalfinancecorp.com', '+1-555-0207', '2019-03-10', 125000.00, 25.00, 'Full-Time', 'New York, NY', 'M', 'American'),
(1004, 2015, 3003, 'GFC008', 'Sarah', 'Parker', 'Investment Banker', 4047, 'sarah.parker@globalfinancecorp.com', '+1-555-0208', '2019-06-15', 122000.00, 25.00, 'Full-Time', 'New York, NY', 'F', 'American'),
(1004, 2015, 3002, 'GFC009', 'Michael', 'Evans', 'Analyst', 4049, 'michael.evans@globalfinancecorp.com', '+1-555-0209', '2021-07-01', 85000.00, 15.00, 'Full-Time', 'New York, NY', 'M', 'American'),

-- Global Finance Corp - Risk Management Team
(1004, 2016, 3004, 'GFC010', 'Jennifer', 'Morris', 'Senior Risk Analyst', 4012, 'jennifer.morris@globalfinancecorp.com', '+1-555-0210', '2018-05-20', 145000.00, 20.00, 'Full-Time', 'New York, NY', 'F', 'American'),
(1004, 2016, 3003, 'GFC011', 'David', 'Rogers', 'Risk Analyst', 4051, 'david.rogers@globalfinancecorp.com', '+1-555-0211', '2020-02-15', 95000.00, 15.00, 'Full-Time', 'New York, NY', 'M', 'American'),
(1004, 2016, 3003, 'GFC012', 'Lisa', 'Reed', 'Risk Analyst', 4051, 'lisa.reed@globalfinancecorp.com', '+1-555-0212', '2020-04-10', 92000.00, 15.00, 'Full-Time', 'New York, NY', 'F', 'American'),

-- HealthTech Innovations (1006) - R&D Team
(1006, 2023, 3004, 'HTI004', 'Dr. James', 'Mitchell', 'Senior Research Scientist', 4015, 'james.mitchell@healthtechinnovations.com', '+1-555-0304', '2017-08-15', 145000.00, 15.00, 'Full-Time', 'Boston, MA', 'M', 'American'),
(1006, 2023, 3003, 'HTI005', 'Dr. Emily', 'Cooper', 'Research Scientist', 4054, 'emily.cooper@healthtechinnovations.com', '+1-555-0305', '2018-11-20', 115000.00, 12.00, 'Full-Time', 'Boston, MA', 'F', 'American'),
(1006, 2023, 3003, 'HTI006', 'Dr. Carlos', 'Ramirez', 'Research Scientist', 4054, 'carlos.ramirez@healthtechinnovations.com', '+1-555-0306', '2019-01-10', 112000.00, 12.00, 'Full-Time', 'Boston, MA', 'M', 'Mexican-American'),
(1006, 2023, 3002, 'HTI007', 'Rachel', 'Ward', 'Research Associate', 4055, 'rachel.ward@healthtechinnovations.com', '+1-555-0307', '2020-09-15', 78000.00, 8.00, 'Full-Time', 'Boston, MA', 'F', 'American'),

-- AutoManu Systems (1008) - Engineering Team
(1008, 2032, 3004, 'AMS004', 'Robert', 'Johnson', 'Senior Mechanical Engineer', 4018, 'robert.johnson@automanusystems.com', '+1-555-0404', '2015-07-20', 125000.00, 15.00, 'Full-Time', 'Detroit, MI', 'M', 'American'),
(1008, 2032, 3004, 'AMS005', 'Linda', 'Williams', 'Senior Electrical Engineer', 4018, 'linda.williams@automanusystems.com', '+1-555-0405', '2016-02-15', 122000.00, 15.00, 'Full-Time', 'Detroit, MI', 'F', 'American'),
(1008, 2032, 3003, 'AMS006', 'Thomas', 'Brown', 'Mechanical Engineer', 4058, 'thomas.brown@automanusystems.com', '+1-555-0406', '2018-04-10', 95000.00, 12.00, 'Full-Time', 'Detroit, MI', 'M', 'American'),
(1008, 2032, 3003, 'AMS007', 'Maria', 'Garcia', 'Software Engineer', 4058, 'maria.garcia@automanusystems.com', '+1-555-0407', '2018-08-25', 98000.00, 12.00, 'Full-Time', 'Detroit, MI', 'F', 'Mexican-American'),

-- AutoManu Systems - Manufacturing Team
(1008, 2033, 3003, 'AMS008', 'Paul', 'Martinez', 'Production Manager', 4019, 'paul.martinez@automanusystems.com', '+1-555-0408', '2016-11-15', 85000.00, 10.00, 'Full-Time', 'Detroit, MI', 'M', 'Mexican-American'),
(1008, 2033, 3002, 'AMS009', 'Jennifer', 'Anderson', 'Production Supervisor', 4062, 'jennifer.anderson@automanusystems.com', '+1-555-0409', '2019-03-20', 68000.00, 8.00, 'Full-Time', 'Detroit, MI', 'F', 'American'),
(1008, 2033, 3002, 'AMS010', 'Mark', 'Thompson', 'Production Supervisor', 4062, 'mark.thompson@automanusystems.com', '+1-555-0410', '2019-07-10', 70000.00, 8.00, 'Full-Time', 'Detroit, MI', 'M', 'American');

SELECT COUNT(*) AS RegularEmployeesInserted FROM Employees WHERE EmployeeID >= 4026;

PRINT 'Regular employees populated successfully!'; 
PRINT 'Total regular employees added: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Show summary of all employees by company
SELECT 
    c.CompanyName,
    COUNT(e.EmployeeID) as TotalEmployees,
    AVG(e.BaseSalary) as AvgSalary
FROM Companies c
LEFT JOIN Employees e ON c.CompanyID = e.CompanyID
GROUP BY c.CompanyID, c.CompanyName
ORDER BY TotalEmployees DESC;

PRINT 'Employee data population completed!';
PRINT 'Ready for additional tables (Skills, Projects, etc.)';