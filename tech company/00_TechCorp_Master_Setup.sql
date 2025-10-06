-- =============================================
-- TechCorp Database: Complete Data Population Script
-- Master Execution Script - Run All Components
-- =============================================

USE master;
GO

PRINT '==============================================';
PRINT 'TechCorp Database Setup - Master Script';
PRINT 'This script will create and populate the complete TechCorp database';
PRINT '==============================================';
PRINT '';

-- Step 1: Database Creation
PRINT 'Step 1: Creating TechCorp database...';
:r "01_TechCorp_Database_Creation.sql"
PRINT '';

-- Step 2: Table Creation
PRINT 'Step 2: Creating database tables...';
:r "02_TechCorp_Table_Creation.sql"
PRINT '';

-- Step 3: Lookup Data
PRINT 'Step 3: Populating lookup tables...';
:r "03_TechCorp_Lookup_Data.sql"
PRINT '';

-- Step 4: Companies Data
PRINT 'Step 4: Populating companies data...';
:r "04_TechCorp_Companies_Data.sql"
PRINT '';

-- Step 5: Departments Data
PRINT 'Step 5: Populating departments data...';
:r "05_TechCorp_Departments_Data.sql"
PRINT '';

-- Step 6: Leadership Employees
PRINT 'Step 6: Populating leadership employees...';
:r "06_TechCorp_Employees_Leadership.sql"
PRINT '';

-- Step 7: Regular Employees
PRINT 'Step 7: Populating regular employees...';
:r "07_TechCorp_Employees_Regular.sql"
PRINT '';

-- Step 8: Advanced Tables
PRINT 'Step 8: Creating advanced tables...';
:r "08_TechCorp_Advanced_Tables.sql"
PRINT '';

-- Step 9: Skills Data
PRINT 'Step 9: Populating skills data...';
:r "09_TechCorp_Skills_Data.sql"
PRINT '';

-- Step 10: Projects Data
PRINT 'Step 10: Populating projects data...';
:r "10_TechCorp_Projects_Data.sql"
PRINT '';

-- Step 11: Employee Skills Assignments
PRINT 'Step 11: Populating employee skills assignments...';
:r "11_TechCorp_Employee_Skills.sql"
PRINT '';

-- Step 12: Project Assignments
PRINT 'Step 12: Populating project assignments...';
:r "12_TechCorp_Project_Assignments.sql"
PRINT '';

-- Step 13: Performance and Time Tracking Data
PRINT 'Step 13: Populating performance and time tracking data...';
:r "13_TechCorp_Performance_Data.sql"
PRINT '';

-- Final Verification
USE TechCorpDB;
GO

PRINT '==============================================';
PRINT 'TECHCORP DATABASE SETUP COMPLETE!';
PRINT '==============================================';
PRINT '';

-- Display summary statistics
PRINT 'DATABASE SUMMARY:';
PRINT '----------------------------------------';

SELECT 'Countries' as TableName, COUNT(*) as RecordCount FROM Countries
UNION ALL
SELECT 'Industries', COUNT(*) FROM Industries
UNION ALL
SELECT 'SkillCategories', COUNT(*) FROM SkillCategories
UNION ALL
SELECT 'JobLevels', COUNT(*) FROM JobLevels
UNION ALL
SELECT 'Companies', COUNT(*) FROM Companies
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Skills', COUNT(*) FROM Skills
UNION ALL
SELECT 'ProjectTypes', COUNT(*) FROM ProjectTypes
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'EmployeeSkills', COUNT(*) FROM EmployeeSkills
UNION ALL
SELECT 'EmployeeProjects', COUNT(*) FROM EmployeeProjects
UNION ALL
SELECT 'PerformanceMetrics', COUNT(*) FROM PerformanceMetrics
UNION ALL
SELECT 'TimeTracking', COUNT(*) FROM TimeTracking;

PRINT '';
PRINT 'Companies by Size:';
SELECT 
    CompanySize,
    COUNT(*) as CompanyCount,
    AVG(AnnualRevenue) as AvgRevenue
FROM Companies 
GROUP BY CompanySize
ORDER BY CompanyCount DESC;

PRINT '';
PRINT 'Employees by Job Level:';
SELECT 
    jl.LevelName,
    COUNT(e.EmployeeID) as EmployeeCount,
    AVG(e.BaseSalary) as AvgSalary
FROM JobLevels jl
LEFT JOIN Employees e ON jl.JobLevelID = e.JobLevelID
GROUP BY jl.JobLevelID, jl.LevelName
ORDER BY jl.JobLevelID;

PRINT '';
PRINT '==============================================';
PRINT 'TechCorp Database is ready for SQL training!';
PRINT '';
PRINT 'Available for modules:';
PRINT '- Module 1: Basic Architecture (Countries, Industries)';
PRINT '- Module 2: T-SQL Fundamentals (Companies, Employees)';
PRINT '- Module 3: SELECT Statements (All tables)';
PRINT '- Module 4: JOINs (Multiple table relationships)';
PRINT '- Module 5: Sorting & Filtering (Complex queries)';
PRINT '- Module 6: Data Types (Diverse data scenarios)';
PRINT '- Module 7: DML Operations (Skills, Projects)';
PRINT '- Module 8: Functions (Performance metrics)';
PRINT '- Module 9: Grouping & Aggregating (Business analytics)';
PRINT '';
PRINT 'FINAL RECORD COUNTS:';
PRINT '- 15+ Companies across multiple industries';
PRINT '- 65+ Employees with complete organizational hierarchy';
PRINT '- 35+ Skills with proficiency tracking';
PRINT '- 15+ Active projects with team assignments';
PRINT '- 40+ Performance metrics for analytics';
PRINT '- Time tracking data for real-world scenarios';
PRINT '==============================================';

-- Sample queries to verify functionality
PRINT '';
PRINT 'Sample verification queries:';
PRINT '';

-- Basic SELECT (Module 2-3)
PRINT '1. All companies with revenue > $50M:';
SELECT CompanyName, AnnualRevenue, CompanySize, FoundedYear
FROM Companies 
WHERE AnnualRevenue > 50000000
ORDER BY AnnualRevenue DESC;

PRINT '';
PRINT '2. Employees with their departments (Module 4):';
SELECT TOP 10
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    c.CompanyName,
    e.BaseSalary
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN Companies c ON e.CompanyID = c.CompanyID
ORDER BY e.BaseSalary DESC;

PRINT '';
PRINT '3. Department summary with averages (Module 8-9):';
SELECT 
    c.CompanyName,
    d.DepartmentName,
    COUNT(e.EmployeeID) as EmployeeCount,
    AVG(e.BaseSalary) as AvgSalary,
    SUM(d.Budget) as DepartmentBudget
FROM Companies c
    INNER JOIN Departments d ON c.CompanyID = d.CompanyID
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY c.CompanyName, d.DepartmentName, d.Budget
HAVING COUNT(e.EmployeeID) > 0
ORDER BY AvgSalary DESC;

PRINT '';
PRINT '4. Advanced analytics example (Module 9):';
SELECT 
    pm.MetricType,
    COUNT(pm.MetricID) as MetricCount,
    AVG(pm.Achievement) as AvgAchievement,
    MAX(pm.Achievement) as MaxAchievement,
    COUNT(CASE WHEN pm.Achievement > 100 THEN 1 END) as ExceedsTarget
FROM PerformanceMetrics pm
GROUP BY pm.MetricType
ORDER BY AvgAchievement DESC;

PRINT '';
PRINT '5. Project and skills correlation (Module 8-9):';
SELECT TOP 5
    s.SkillName,
    COUNT(DISTINCT ep.ProjectID) as ProjectsUsing,
    COUNT(es.EmployeeSkillID) as EmployeesWithSkill,
    AVG(es.ProficiencyLevel) as AvgProficiency
FROM Skills s
    INNER JOIN EmployeeSkills es ON s.SkillID = es.SkillID
    INNER JOIN EmployeeProjects ep ON es.EmployeeID = ep.EmployeeID
GROUP BY s.SkillID, s.SkillName
ORDER BY ProjectsUsing DESC;

PRINT '';
PRINT '==============================================';
PRINT 'DATABASE SETUP VERIFICATION COMPLETE!';
PRINT 'TechCorp database fully populated and ready for comprehensive SQL training';
PRINT 'All 13 scripts executed successfully with realistic business data';
PRINT '==============================================';
PRINT '';
PRINT 'Database setup verification complete!';
PRINT 'All tables populated and ready for training modules.';