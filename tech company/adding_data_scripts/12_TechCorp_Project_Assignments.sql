-- =============================================
-- TechCorp Database: Employee Project Assignments
-- Module 7-8: Project Team Data
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- EMPLOYEE PROJECT ASSIGNMENTS
-- =============================================
PRINT 'Populating EmployeeProjects table...';

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, StartDate, EndDate, 
    AllocationPercentage, BillableRate, EstimatedHours, ActualHours, PerformanceRating, 
    IsLead, ResponsibilityArea, ClientFeedbackScore, InternalFeedbackScore) VALUES

-- TC-2024-001: E-Commerce Platform Redesign (TechCorp Solutions)
(4002, 8001, 'Project Manager', '2024-03-01', NULL, 100.00, 180.00, 240.0, 170.0, 5, 1, 'Overall project coordination and client communication', 9, 9),
(4009, 8001, 'Lead Developer', '2024-03-01', NULL, 80.00, 145.00, 320.0, 285.0, 4, 1, 'Frontend development and team leadership', 8, 8),
(4026, 8001, 'Senior Frontend Developer', '2024-03-01', NULL, 90.00, 125.00, 280.0, 245.0, 4, 0, 'React.js development and UI implementation', 8, 8),
(4027, 8001, 'Backend Developer', '2024-03-15', NULL, 75.00, 120.00, 240.0, 195.0, 4, 0, 'API development and database integration', 8, 7),
(4039, 8001, 'UX Designer', '2024-03-01', '2024-05-15', 60.00, 95.00, 160.0, 155.0, 4, 0, 'User experience design and testing', 9, 8),

-- TC-2024-002: CRM Integration System (TechCorp Solutions) - COMPLETED
(4007, 8002, 'Technical Lead', '2024-01-15', '2024-06-10', 100.00, 165.00, 420.0, 410.0, 5, 1, 'System architecture and integration oversight', 9, 9),
(4008, 8002, 'Senior Developer', '2024-01-15', '2024-06-10', 85.00, 155.00, 380.0, 375.0, 5, 0, 'Backend integration and API development', 9, 9),
(4026, 8002, 'Integration Specialist', '2024-02-01', '2024-06-10', 70.00, 125.00, 320.0, 315.0, 4, 0, 'CRM system integration and data migration', 8, 8),
(4006, 8002, 'Business Analyst', '2024-01-15', '2024-04-15', 50.00, 110.00, 240.0, 235.0, 4, 0, 'Requirements analysis and process mapping', 8, 8),

-- TC-2024-003: Mobile Banking App (TechCorp Solutions)
(4009, 8003, 'Project Lead', '2024-08-01', NULL, 100.00, 145.00, 360.0, NULL, NULL, 1, 'Mobile app development leadership', NULL, NULL),
(4027, 8003, 'iOS Developer', '2024-08-01', NULL, 90.00, 120.00, 320.0, NULL, NULL, 0, 'iOS native development', NULL, NULL),
(4030, 8003, 'Android Developer', '2024-08-01', NULL, 90.00, 118.00, 320.0, NULL, NULL, 0, 'Android native development', NULL, NULL),
(4028, 8003, 'Backend Developer', '2024-08-15', NULL, 80.00, 105.00, 280.0, NULL, NULL, 0, 'API and security implementation', NULL, NULL),

-- TC-2024-004: Data Analytics Dashboard (TechCorp Solutions)
(4010, 8004, 'Product Manager', '2024-04-15', NULL, 100.00, 135.00, 280.0, 145.0, 4, 1, 'Product requirements and stakeholder management', 8, 8),
(4008, 8004, 'Data Engineer', '2024-04-15', NULL, 75.00, 155.00, 240.0, 125.0, 4, 0, 'Data pipeline and ETL development', 8, 8),
(4028, 8004, 'Frontend Developer', '2024-05-01', NULL, 60.00, 105.00, 200.0, 95.0, 3, 0, 'Dashboard UI development', 7, 7),

-- CTI-2024-001: AWS Cloud Migration (CloudTech Innovations)
(4021, 8005, 'Cloud Architect', '2024-02-01', NULL, 100.00, 175.00, 560.0, 350.0, 5, 1, 'Cloud architecture design and migration strategy', 9, 9),
(4022, 8005, 'DevOps Lead', '2024-02-01', NULL, 90.00, 165.00, 480.0, 300.0, 5, 1, 'CI/CD pipeline and infrastructure automation', 9, 9),
(4041, 8005, 'Senior Cloud Engineer', '2024-02-15', NULL, 85.00, 140.00, 420.0, 265.0, 4, 0, 'AWS services implementation', 8, 8),
(4042, 8005, 'Cloud Engineer', '2024-03-01', NULL, 70.00, 125.00, 360.0, 220.0, 4, 0, 'Migration execution and testing', 8, 8),
(4045, 8005, 'Junior DevOps Engineer', '2024-02-15', NULL, 60.00, 95.00, 280.0, 175.0, 3, 0, 'Monitoring and deployment support', 7, 7),

-- CTI-2024-002: Security Assessment (CloudTech Innovations) - COMPLETED
(4022, 8006, 'Security Lead', '2024-01-10', '2024-04-05', 100.00, 165.00, 160.0, 155.0, 5, 1, 'Security assessment coordination', 9, 9),
(4041, 8006, 'Penetration Tester', '2024-01-10', '2024-04-05', 80.00, 140.00, 240.0, 235.0, 5, 0, 'Vulnerability assessment and testing', 9, 9),
(4043, 8006, 'Security Analyst', '2024-01-15', '2024-04-05', 70.00, 120.00, 200.0, 195.0, 4, 0, 'Security documentation and reporting', 8, 8),

-- GFC-2024-001: Trading Platform Upgrade (Global Finance Corp)
(4011, 8007, 'Executive Sponsor', '2024-01-01', NULL, 25.00, 250.00, 340.0, 192.0, 5, 1, 'Executive oversight and stakeholder management', 10, 10),
(4014, 8007, 'Technical Director', '2024-01-01', NULL, 90.00, 185.00, 850.0, 480.0, 5, 1, 'Technical architecture and team coordination', 9, 9),
(4047, 8007, 'Senior Developer', '2024-01-15', NULL, 100.00, 165.00, 680.0, 385.0, 4, 0, 'Core trading system development', 8, 8),
(4048, 8007, 'Senior Developer', '2024-01-15', NULL, 100.00, 162.00, 680.0, 380.0, 4, 0, 'Low-latency optimization', 8, 8),
(4049, 8007, 'Junior Developer', '2024-02-01', NULL, 80.00, 95.00, 480.0, 275.0, 3, 0, 'Testing and quality assurance', 7, 7),

-- GFC-2024-002: Risk Analytics System (Global Finance Corp) - COMPLETED
(4012, 8008, 'Analytics Director', '2023-09-01', '2024-04-28', 80.00, 175.00, 560.0, 540.0, 5, 1, 'Analytics strategy and model validation', 9, 9),
(4051, 8008, 'Senior Risk Analyst', '2023-09-01', '2024-04-28', 90.00, 145.00, 640.0, 630.0, 5, 0, 'Risk model development', 9, 9),
(4052, 8008, 'Data Scientist', '2023-10-01', '2024-04-28', 85.00, 140.00, 520.0, 510.0, 4, 0, 'Statistical modeling and validation', 8, 8),
(4014, 8008, 'Technical Lead', '2023-09-15', '2024-04-28', 60.00, 185.00, 420.0, 415.0, 5, 0, 'Platform architecture and integration', 9, 9),

-- HTI-2024-001: Patient Portal Mobile App (HealthTech Innovations)
(4015, 8009, 'Product Director', '2024-03-15', NULL, 50.00, 165.00, 200.0, 108.0, 4, 1, 'Product strategy and clinical requirements', 8, 8),
(4054, 8009, 'Mobile Development Lead', '2024-03-15', NULL, 90.00, 135.00, 320.0, 175.0, 4, 1, 'Mobile app development coordination', 8, 8),
(4055, 8009, 'iOS Developer', '2024-03-15', NULL, 85.00, 115.00, 280.0, 152.0, 4, 0, 'iOS app development', 8, 8),
(4056, 8009, 'Android Developer', '2024-03-20', NULL, 85.00, 112.00, 280.0, 148.0, 4, 0, 'Android app development', 8, 8),
(4016, 8009, 'Clinical Consultant', '2024-03-15', '2024-06-15', 30.00, 145.00, 120.0, 118.0, 5, 0, 'Clinical workflow validation', 9, 9),

-- AMS-2024-001: Manufacturing ERP Integration (AutoManu Systems)
(4018, 8011, 'Integration Director', '2024-02-15', NULL, 60.00, 195.00, 500.0, 285.0, 5, 1, 'ERP integration strategy and oversight', 9, 9),
(4058, 8011, 'Senior Integration Developer', '2024-02-15', NULL, 90.00, 145.00, 680.0, 388.0, 4, 0, 'ERP system integration development', 8, 8),
(4059, 8011, 'Systems Analyst', '2024-02-15', NULL, 80.00, 125.00, 520.0, 295.0, 4, 0, 'Business process analysis', 8, 8),
(4060, 8011, 'Database Developer', '2024-03-01', NULL, 75.00, 118.00, 440.0, 248.0, 4, 0, 'Database integration and migration', 8, 8),

-- AMS-2024-002: Production Line Automation (AutoManu Systems) - COMPLETED
(4019, 8012, 'Automation Manager', '2023-10-01', '2024-03-28', 80.00, 155.00, 480.0, 470.0, 5, 1, 'Production automation coordination', 9, 9),
(4062, 8012, 'DevOps Engineer', '2023-10-01', '2024-03-28', 100.00, 125.00, 560.0, 550.0, 5, 0, 'CI/CD pipeline implementation', 9, 9),
(4058, 8012, 'Software Engineer', '2023-10-15', '2024-03-28', 70.00, 145.00, 420.0, 415.0, 4, 0, 'Automation software development', 8, 8),
(4020, 8012, 'Quality Engineer', '2023-11-01', '2024-03-28', 60.00, 108.00, 320.0, 315.0, 4, 0, 'Testing and quality validation', 8, 8),

-- ETG-2024-001: Digital Transformation Initiative (EnerTech Global)
(4023, 8013, 'Transformation Director', '2024-01-01', NULL, 40.00, 225.00, 1200.0, 576.0, 5, 1, 'Digital transformation strategy', 10, 10),
(4024, 8013, 'Project Manager', '2024-01-01', NULL, 90.00, 165.00, 1080.0, 518.0, 4, 1, 'Project coordination and delivery', 8, 8),
(4025, 8013, 'Technical Lead', '2024-01-15', NULL, 80.00, 155.00, 960.0, 462.0, 4, 0, 'Technical architecture and development', 8, 8);

SELECT COUNT(*) AS ProjectAssignmentsInserted FROM EmployeeProjects;

PRINT 'Employee project assignments populated successfully!';
PRINT 'Total project assignments: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Show project team sizes
SELECT 
    p.ProjectName,
    p.Status,
    COUNT(ep.AssignmentID) as TeamSize,
    AVG(ep.AllocationPercentage) as AvgAllocation,
    SUM(ep.EstimatedHours) as TotalEstimatedHours
FROM Projects p
LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
GROUP BY p.ProjectID, p.ProjectName, p.Status
ORDER BY TeamSize DESC;

PRINT 'Project team summary displayed above.';
PRINT 'Ready for performance metrics and time tracking data.';