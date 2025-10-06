-- =============================================
-- TechCorp Database: Employee Skills Assignment
-- Module 6-7: Skills Proficiency Data
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- EMPLOYEE SKILLS DATA
-- =============================================
PRINT 'Populating EmployeeSkills table...';

INSERT INTO EmployeeSkills (EmployeeID, SkillID, ProficiencyLevel, YearsExperience, 
    LastUsedDate, CertificationDate, IsPrimary, SelfAssessmentScore, ManagerAssessmentScore, AssessmentDate) VALUES

-- TechCorp Solutions - Engineering Team Skills
-- Sarah Chen (VP Engineering) - Leadership + Technical
(4001, 5001, 5, 12.0, '2024-10-01', '2019-03-15', 1, 9, 9, '2024-09-15'), -- C# .NET
(4001, 5002, 4, 8.0, '2024-09-30', NULL, 0, 8, 8, '2024-09-15'), -- Python
(4001, 5013, 5, 15.0, '2024-10-01', '2018-06-20', 0, 10, 9, '2024-09-15'), -- Agile/Scrum
(4001, 5014, 4, 10.0, '2024-08-15', '2020-01-10', 0, 8, 8, '2024-09-15'), -- PMP

-- Alex Patel (Engineering Manager)
(4007, 5001, 5, 10.0, '2024-10-01', '2020-05-15', 1, 9, 9, '2024-09-15'), -- C# .NET
(4007, 5003, 5, 12.0, '2024-10-01', NULL, 0, 9, 9, '2024-09-15'), -- JavaScript
(4007, 5017, 4, 6.0, '2024-09-20', '2021-08-10', 0, 8, 8, '2024-09-15'), -- Power BI
(4007, 5013, 5, 8.0, '2024-10-01', '2019-11-20', 0, 9, 9, '2024-09-15'), -- Agile/Scrum

-- Emma Davis (Principal Engineer)
(4008, 5002, 5, 8.0, '2024-10-01', '2021-03-15', 1, 10, 9, '2024-09-15'), -- Python
(4008, 5018, 4, 5.0, '2024-09-25', NULL, 0, 8, 8, '2024-09-15'), -- Python Data Science
(4008, 5019, 4, 7.0, '2024-08-30', '2022-06-10', 0, 8, 8, '2024-09-15'), -- AWS
(4008, 5020, 3, 4.0, '2024-07-15', NULL, 0, 7, 7, '2024-09-15'), -- Azure

-- James Wilson (Lead Software Engineer)
(4009, 5003, 5, 8.0, '2024-10-01', NULL, 1, 9, 9, '2024-09-15'), -- JavaScript
(4009, 5004, 4, 6.0, '2024-09-20', '2020-11-15', 0, 8, 8, '2024-09-15'), -- Java
(4009, 5021, 4, 5.0, '2024-09-15', NULL, 0, 8, 8, '2024-09-15'), -- Google Cloud
(4009, 5025, 3, 3.0, '2024-08-10', NULL, 0, 7, 7, '2024-09-15'), -- CI/CD

-- Daniel Chang (Senior Software Engineer)
(4026, 5001, 4, 6.0, '2024-10-01', '2021-09-20', 1, 8, 8, '2024-09-15'), -- C# .NET
(4026, 5003, 4, 5.0, '2024-09-30', NULL, 0, 8, 8, '2024-09-15'), -- JavaScript
(4026, 5016, 3, 3.0, '2024-08-20', NULL, 0, 7, 7, '2024-09-15'), -- SQL Server

-- Jessica Brown (Senior Software Engineer)
(4027, 5002, 4, 5.0, '2024-10-01', NULL, 1, 8, 8, '2024-09-15'), -- Python
(4027, 5003, 4, 6.0, '2024-09-25', NULL, 0, 8, 8, '2024-09-15'), -- JavaScript
(4027, 5020, 3, 2.0, '2024-07-30', NULL, 0, 6, 7, '2024-09-15'), -- Azure

-- CloudTech Innovations - Development Team Skills
-- Mark Stevens (Development Manager)
(4021, 5002, 5, 10.0, '2024-10-01', '2019-08-15', 1, 9, 9, '2024-09-15'), -- Python
(4021, 5019, 5, 8.0, '2024-10-01', '2020-12-10', 0, 9, 9, '2024-09-15'), -- AWS
(4021, 5022, 4, 6.0, '2024-09-20', '2021-05-15', 0, 8, 8, '2024-09-15'), -- Docker
(4021, 5013, 4, 7.0, '2024-10-01', '2018-10-20', 0, 8, 8, '2024-09-15'), -- Agile/Scrum

-- Rachel Adams (DevOps Manager)
(4022, 5025, 5, 7.0, '2024-10-01', '2020-04-15', 1, 9, 9, '2024-09-15'), -- CI/CD
(4022, 5026, 5, 6.0, '2024-10-01', '2021-02-20', 0, 9, 9, '2024-09-15'), -- Infrastructure as Code
(4022, 5022, 5, 8.0, '2024-10-01', '2019-11-10', 0, 9, 9, '2024-09-15'), -- Docker
(4022, 5023, 4, 5.0, '2024-09-25', '2021-08-15', 0, 8, 8, '2024-09-15'), -- Kubernetes

-- Global Finance Corp - Investment Banking Team Skills
-- William Anderson (VP Investment Banking)
(4011, 5014, 5, 20.0, '2024-10-01', '2010-03-15', 1, 10, 10, '2024-09-15'), -- PMP
(4011, 5016, 4, 15.0, '2024-09-20', NULL, 0, 9, 9, '2024-09-15'), -- SQL Server
(4011, 5031, 5, 18.0, '2024-10-01', '2015-06-10', 0, 10, 10, '2024-09-15'), -- Requirements Analysis
(4011, 5017, 3, 5.0, '2024-08-15', NULL, 0, 7, 7, '2024-09-15'), -- Tableau

-- Catherine Brown (Director Risk Management)
(4012, 5016, 5, 12.0, '2024-10-01', '2018-09-15', 1, 9, 9, '2024-09-15'), -- SQL Server
(4012, 5018, 4, 8.0, '2024-09-30', '2020-11-20', 0, 8, 8, '2024-09-15'), -- Python Data Science
(4012, 5019, 3, 3.0, '2024-07-20', NULL, 0, 7, 7, '2024-09-15'), -- R
(4012, 5017, 4, 6.0, '2024-09-15', '2019-12-10', 0, 8, 8, '2024-09-15'), -- Tableau

-- HealthTech Innovations - R&D Team Skills
-- Dr. Amanda Foster (Director R&D)
(4015, 5018, 5, 10.0, '2024-10-01', '2019-05-15', 1, 9, 9, '2024-09-15'), -- Python Data Science
(4015, 5019, 4, 8.0, '2024-09-20', '2020-08-10', 0, 8, 8, '2024-09-15'), -- R
(4015, 5002, 4, 12.0, '2024-09-30', NULL, 0, 8, 8, '2024-09-15'), -- Python
(4015, 5014, 4, 8.0, '2024-08-15', '2018-11-20', 0, 8, 8, '2024-09-15'), -- PMP

-- Dr. James Mitchell (Senior Research Scientist)
(4054, 5018, 5, 8.0, '2024-10-01', '2020-03-15', 1, 9, 9, '2024-09-15'), -- Python Data Science
(4054, 5002, 5, 10.0, '2024-10-01', NULL, 0, 9, 9, '2024-09-15'), -- Python
(4054, 5019, 4, 6.0, '2024-09-25', '2021-07-10', 0, 8, 8, '2024-09-15'), -- R
(4054, 5016, 3, 4.0, '2024-08-20', NULL, 0, 7, 7, '2024-09-15'), -- SQL Server

-- AutoManu Systems - Engineering Team Skills
-- John Miller (VP Engineering)
(4018, 5004, 5, 18.0, '2024-10-01', '2015-04-15', 1, 10, 10, '2024-09-15'), -- Java
(4018, 5014, 5, 15.0, '2024-10-01', '2012-08-20', 0, 10, 10, '2024-09-15'), -- PMP
(4018, 5016, 4, 12.0, '2024-09-20', NULL, 0, 9, 9, '2024-09-15'), -- SQL Server
(4018, 5013, 5, 12.0, '2024-10-01', '2016-03-10', 0, 9, 9, '2024-09-15'), -- Agile/Scrum

-- Sales and Marketing Team Skills
-- Jennifer Kim (Director Sales) - TechCorp
(4003, 5031, 4, 8.0, '2024-09-30', NULL, 1, 8, 8, '2024-09-15'), -- Requirements Analysis
(4003, 5032, 4, 6.0, '2024-09-15', NULL, 0, 8, 8, '2024-09-15'), -- Process Modeling
(4003, 5017, 3, 3.0, '2024-08-10', NULL, 0, 7, 7, '2024-09-15'), -- Tableau

-- David Thompson (Senior Marketing Manager) - TechCorp
(4004, 5034, 4, 7.0, '2024-10-01', NULL, 1, 8, 8, '2024-09-15'), -- UI Design
(4004, 5035, 3, 4.0, '2024-09-20', NULL, 0, 7, 7, '2024-09-15'), -- UX Research
(4004, 5017, 3, 2.0, '2024-08-15', NULL, 0, 6, 7, '2024-09-15'), -- Tableau

-- Additional junior and mid-level employees with varied skills
-- Ryan Miller (Software Engineer) - TechCorp
(4028, 5003, 3, 3.0, '2024-10-01', NULL, 1, 7, 7, '2024-09-15'), -- JavaScript
(4028, 5001, 3, 2.5, '2024-09-25', NULL, 0, 7, 7, '2024-09-15'), -- C# .NET
(4028, 5016, 2, 1.5, '2024-08-20', NULL, 0, 6, 6, '2024-09-15'), -- SQL Server

-- Ashley Garcia (Software Engineer) - TechCorp
(4029, 5002, 3, 2.0, '2024-10-01', NULL, 1, 7, 7, '2024-09-15'), -- Python
(4029, 5003, 3, 3.0, '2024-09-30', NULL, 0, 7, 7, '2024-09-15'), -- JavaScript
(4029, 5020, 2, 1.0, '2024-07-15', NULL, 0, 5, 6, '2024-09-15'), -- Azure

-- Andrew Peterson (Senior Developer) - CloudTech
(4041, 5002, 4, 7.0, '2024-10-01', NULL, 1, 8, 8, '2024-09-15'), -- Python
(4041, 5019, 4, 5.0, '2024-09-25', '2021-11-15', 0, 8, 8, '2024-09-15'), -- AWS
(4041, 5022, 3, 3.0, '2024-08-30', NULL, 0, 7, 7, '2024-09-15'), -- Docker

-- EnerTech Global Skills
-- Charles Williams (VP Production)
(4023, 5014, 5, 20.0, '2024-10-01', '2008-05-15', 1, 10, 10, '2024-09-15'), -- PMP
(4023, 5016, 4, 15.0, '2024-09-20', NULL, 0, 9, 9, '2024-09-15'), -- SQL Server
(4023, 5032, 4, 12.0, '2024-08-30', NULL, 0, 8, 8, '2024-09-15'); -- Process Modeling

SELECT COUNT(*) AS EmployeeSkillsInserted FROM EmployeeSkills;

PRINT 'Employee skills data populated successfully!';
PRINT 'Total skill assignments: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Show skills distribution
SELECT 
    s.SkillName,
    COUNT(es.EmployeeSkillID) as EmployeeCount,
    AVG(CAST(es.ProficiencyLevel AS FLOAT)) as AvgProficiency,
    AVG(es.YearsExperience) as AvgExperience
FROM Skills s
LEFT JOIN EmployeeSkills es ON s.SkillID = es.SkillID
GROUP BY s.SkillID, s.SkillName
HAVING COUNT(es.EmployeeSkillID) > 0
ORDER BY EmployeeCount DESC;

PRINT 'Skills distribution summary displayed above.';
PRINT 'Ready for employee project assignments.';