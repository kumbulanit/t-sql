-- =============================================
-- TechCorp Database: Projects Data Population
-- Module 6-7: Real Project Scenarios
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- PROJECTS DATA
-- =============================================
PRINT 'Populating Projects table...';

INSERT INTO Projects (CompanyID, ProjectTypeID, ProjectName, ProjectCode, ClientContactName, 
    ClientContactEmail, ProjectManagerID, Status, Priority, StartDate, PlannedEndDate, 
    ActualEndDate, Budget, ActualCost, EstimatedHours, ActualHours, BillingType, 
    HourlyRate, Currency, RiskLevel, Description) VALUES

-- TechCorp Solutions Projects
(1001, 7001, 'E-Commerce Platform Redesign', 'TC-2024-001', 'Sarah Johnson', 'sarah.johnson@retailclient.com', 
    4002, 'In Progress', 'High', '2024-03-01', '2024-07-01', NULL, 185000.00, 125000.00, 
    1200.0, 850.0, 'Fixed Price', NULL, 'USD', 2, 
    'Complete redesign of e-commerce platform with modern UI/UX and mobile optimization'),

(1001, 7002, 'CRM Integration System', 'TC-2024-002', 'Michael Chen', 'michael.chen@salesforcemax.com', 
    4007, 'Completed', 'Medium', '2024-01-15', '2024-06-15', '2024-06-10', 320000.00, 298000.00, 
    2100.0, 2050.0, 'Fixed Price', NULL, 'USD', 3, 
    'Enterprise CRM integration with existing ERP and financial systems'),

(1001, 7003, 'Mobile Banking App', 'TC-2024-003', 'Jennifer Walsh', 'j.walsh@mobilefirst.com', 
    4009, 'Planning', 'High', '2024-08-01', '2025-02-01', NULL, 275000.00, NULL, 
    1800.0, NULL, 'Time & Materials', 150.00, 'USD', 4, 
    'iOS and Android banking application with biometric authentication'),

(1001, 7004, 'Data Analytics Dashboard', 'TC-2024-004', 'David Park', 'david.park@analyticsco.com', 
    4010, 'In Progress', 'Medium', '2024-04-15', '2024-12-15', NULL, 195000.00, 85000.00, 
    1400.0, 580.0, 'Fixed Price', NULL, 'USD', 2, 
    'Business intelligence dashboard with real-time analytics and reporting'),

-- CloudTech Innovations Projects
(1002, 7005, 'AWS Cloud Migration', 'CTI-2024-001', 'Robert Smith', 'robert.smith@legacycorp.com', 
    4021, 'In Progress', 'High', '2024-02-01', '2024-10-01', NULL, 450000.00, 280000.00, 
    2800.0, 1750.0, 'Time & Materials', 160.00, 'USD', 4, 
    'Complete migration of on-premises infrastructure to AWS cloud'),

(1002, 7006, 'Security Assessment', 'CTI-2024-002', 'Lisa Anderson', 'lisa.anderson@securefinance.com', 
    4022, 'Completed', 'High', '2024-01-10', '2024-04-10', '2024-04-05', 125000.00, 118000.00, 
    800.0, 765.0, 'Fixed Price', NULL, 'USD', 5, 
    'Comprehensive cybersecurity assessment and penetration testing'),

-- Global Finance Corp Projects
(1004, 7002, 'Trading Platform Upgrade', 'GFC-2024-001', 'Thomas Wilson', 'thomas.wilson@tradingfirm.com', 
    4011, 'In Progress', 'Critical', '2024-01-01', '2024-12-01', NULL, 1500000.00, 850000.00, 
    8500.0, 4800.0, 'Fixed Price', NULL, 'USD', 5, 
    'High-frequency trading platform with low-latency requirements'),

(1004, 7004, 'Risk Analytics System', 'GFC-2024-002', 'Amanda Foster', 'amanda.foster@risktech.com', 
    4012, 'Completed', 'High', '2023-09-01', '2024-05-01', '2024-04-28', 650000.00, 615000.00, 
    4200.0, 4050.0, 'Time & Materials', 155.00, 'USD', 3, 
    'Advanced risk modeling and analytics platform for investment portfolios'),

-- HealthTech Innovations Projects
(1006, 7003, 'Patient Portal Mobile App', 'HTI-2024-001', 'Dr. Maria Rodriguez', 'maria.rodriguez@healthsystem.com', 
    4015, 'In Progress', 'Medium', '2024-03-15', '2024-09-15', NULL, 180000.00, 95000.00, 
    1200.0, 650.0, 'Fixed Price', NULL, 'USD', 3, 
    'Patient portal mobile application with appointment scheduling and health records'),

(1006, 7011, 'Clinical Trial Data Platform', 'HTI-2024-002', 'Dr. James Mitchell', 'james.mitchell@pharmaresearch.com', 
    4016, 'Planning', 'High', '2024-09-01', '2025-06-01', NULL, 420000.00, NULL, 
    2800.0, NULL, 'Time & Materials', 145.00, 'USD', 4, 
    'Machine learning platform for clinical trial data analysis and drug discovery'),

-- AutoManu Systems Projects
(1008, 7007, 'Manufacturing ERP Integration', 'AMS-2024-001', 'Patricia Davis', 'patricia.davis@automanusystems.com', 
    4018, 'In Progress', 'High', '2024-02-15', '2024-11-15', NULL, 750000.00, 425000.00, 
    5000.0, 2850.0, 'Fixed Price', NULL, 'USD', 4, 
    'Integration of manufacturing systems with enterprise resource planning'),

(1008, 7012, 'Production Line Automation', 'AMS-2024-002', 'Kevin Zhang', 'kevin.zhang@automanusystems.com', 
    4019, 'Completed', 'Medium', '2023-10-01', '2024-04-01', '2024-03-28', 380000.00, 365000.00, 
    2400.0, 2350.0, 'Fixed Price', NULL, 'USD', 3, 
    'DevOps implementation for automated testing and deployment pipeline'),

-- EnerTech Global Projects
(1012, 7008, 'Digital Transformation Initiative', 'ETG-2024-001', 'Charles Williams', 'charles.williams@enertechglobal.com', 
    4023, 'In Progress', 'Critical', '2024-01-01', '2025-12-01', NULL, 2500000.00, 1200000.00, 
    15000.0, 7200.0, 'Time & Materials', 175.00, 'USD', 5, 
    'Comprehensive digital transformation of exploration and production systems'),

-- International Projects
(1014, 7001, 'European Market Website', 'GTE-2024-001', 'Hans Mueller', 'hans.mueller@europeanclient.de', 
    4001, 'Completed', 'Medium', '2024-02-01', '2024-06-01', '2024-05-25', 145000.00, 138000.00, 
    950.0, 920.0, 'Fixed Price', NULL, 'EUR', 2, 
    'Multi-language website for European market expansion'),

(1015, 7005, 'Singapore Cloud Infrastructure', 'APS-2024-001', 'Li Wei', 'li.wei@asiatech.sg', 
    4021, 'In Progress', 'High', '2024-04-01', '2024-10-01', NULL, 320000.00, 185000.00, 
    2000.0, 1150.0, 'Time & Materials', 140.00, 'SGD', 3, 
    'Cloud infrastructure setup for Asia-Pacific operations');

SELECT COUNT(*) AS ProjectsInserted FROM Projects;

PRINT 'Projects data populated successfully!';
PRINT 'Total projects: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Show project summary by status
SELECT 
    Status,
    COUNT(*) as ProjectCount,
    SUM(Budget) as TotalBudget,
    AVG(Budget) as AvgBudget
FROM Projects
GROUP BY Status
ORDER BY ProjectCount DESC;

PRINT 'Projects by status summary displayed above.';
PRINT 'Ready for employee project assignments.';