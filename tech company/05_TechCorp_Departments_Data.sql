-- =============================================
-- TechCorp Database: Departments Data Population
-- Module 2-3: Organizational Structure
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- DEPARTMENTS DATA
-- =============================================
PRINT 'Populating Departments table...';

INSERT INTO Departments (CompanyID, DepartmentName, DepartmentCode, CostCenter, Budget, BudgetPeriod) VALUES

-- TechCorp Solutions (1001) - Technology Company
(1001, 'Engineering', 'ENG', 'CC-ENG-001', 2500000.00, 'Annual'),
(1001, 'Product Management', 'PM', 'CC-PM-001', 1200000.00, 'Annual'),
(1001, 'Sales', 'SALES', 'CC-SALES-001', 800000.00, 'Annual'),
(1001, 'Marketing', 'MKT', 'CC-MKT-001', 450000.00, 'Annual'),
(1001, 'Human Resources', 'HR', 'CC-HR-001', 320000.00, 'Annual'),
(1001, 'Finance', 'FIN', 'CC-FIN-001', 280000.00, 'Annual'),
(1001, 'Operations', 'OPS', 'CC-OPS-001', 350000.00, 'Annual'),

-- CloudTech Innovations (1002) - Small Tech Company
(1002, 'Development', 'DEV', 'CC-DEV-001', 800000.00, 'Annual'),
(1002, 'DevOps', 'DEVOPS', 'CC-DEVOPS-001', 400000.00, 'Annual'),
(1002, 'Sales & Marketing', 'SM', 'CC-SM-001', 300000.00, 'Annual'),
(1002, 'Support', 'SUP', 'CC-SUP-001', 200000.00, 'Annual'),

-- DevOps Masters (1003) - Medium Tech Company
(1003, 'Engineering', 'ENG', 'CC-ENG-001', 1500000.00, 'Annual'),
(1003, 'Consulting', 'CONS', 'CC-CONS-001', 900000.00, 'Annual'),
(1003, 'Training', 'TRAIN', 'CC-TRAIN-001', 600000.00, 'Annual'),
(1003, 'Business Development', 'BD', 'CC-BD-001', 400000.00, 'Annual'),

-- Global Finance Corp (1004) - Large Financial Services
(1004, 'Investment Banking', 'IB', 'CC-IB-001', 15000000.00, 'Annual'),
(1004, 'Risk Management', 'RISK', 'CC-RISK-001', 2200000.00, 'Annual'),
(1004, 'Compliance', 'COMP', 'CC-COMP-001', 1800000.00, 'Annual'),
(1004, 'Technology', 'TECH', 'CC-TECH-001', 5000000.00, 'Annual'),
(1004, 'Operations', 'OPS', 'CC-OPS-001', 3500000.00, 'Annual'),
(1004, 'Human Resources', 'HR', 'CC-HR-001', 1200000.00, 'Annual'),

-- Investment Partners LLC (1005) - Medium Financial Services
(1005, 'Portfolio Management', 'PM', 'CC-PM-001', 8000000.00, 'Annual'),
(1005, 'Research', 'RES', 'CC-RES-001', 3000000.00, 'Annual'),
(1005, 'Client Services', 'CS', 'CC-CS-001', 2000000.00, 'Annual'),
(1005, 'Risk & Compliance', 'RC', 'CC-RC-001', 1500000.00, 'Annual'),

-- HealthTech Innovations (1006) - Medium Healthcare
(1006, 'Research & Development', 'RND', 'CC-RND-001', 2500000.00, 'Annual'),
(1006, 'Clinical Affairs', 'CLIN', 'CC-CLIN-001', 1800000.00, 'Annual'),
(1006, 'Regulatory Affairs', 'REG', 'CC-REG-001', 900000.00, 'Annual'),
(1006, 'Quality Assurance', 'QA', 'CC-QA-001', 750000.00, 'Annual'),
(1006, 'Sales & Marketing', 'SM', 'CC-SM-001', 1200000.00, 'Annual'),

-- MedDevice Solutions (1007) - Large Healthcare
(1007, 'Research & Development', 'RND', 'CC-RND-001', 12000000.00, 'Annual'),
(1007, 'Manufacturing', 'MFG', 'CC-MFG-001', 8500000.00, 'Annual'),
(1007, 'Quality Control', 'QC', 'CC-QC-001', 3500000.00, 'Annual'),
(1007, 'Regulatory Affairs', 'REG', 'CC-REG-001', 2000000.00, 'Annual'),
(1007, 'Sales', 'SALES', 'CC-SALES-001', 4500000.00, 'Annual'),
(1007, 'Clinical Support', 'CS', 'CC-CS-001', 2500000.00, 'Annual'),

-- AutoManu Systems (1008) - Large Manufacturing
(1008, 'Engineering', 'ENG', 'CC-ENG-001', 18000000.00, 'Annual'),
(1008, 'Manufacturing', 'MFG', 'CC-MFG-001', 25000000.00, 'Annual'),
(1008, 'Quality Assurance', 'QA', 'CC-QA-001', 5000000.00, 'Annual'),
(1008, 'Supply Chain', 'SC', 'CC-SC-001', 8000000.00, 'Annual'),
(1008, 'Sales & Marketing', 'SM', 'CC-SM-001', 6000000.00, 'Annual'),
(1008, 'Information Technology', 'IT', 'CC-IT-001', 4000000.00, 'Annual'),

-- Precision Manufacturing (1009) - Medium Manufacturing
(1009, 'Production', 'PROD', 'CC-PROD-001', 8000000.00, 'Annual'),
(1009, 'Engineering', 'ENG', 'CC-ENG-001', 4500000.00, 'Annual'),
(1009, 'Quality Control', 'QC', 'CC-QC-001', 2000000.00, 'Annual'),
(1009, 'Sales', 'SALES', 'CC-SALES-001', 1800000.00, 'Annual'),

-- RetailMax Solutions (1010) - Small Retail
(1010, 'Technology', 'TECH', 'CC-TECH-001', 1500000.00, 'Annual'),
(1010, 'Operations', 'OPS', 'CC-OPS-001', 800000.00, 'Annual'),
(1010, 'Marketing', 'MKT', 'CC-MKT-001', 600000.00, 'Annual'),
(1010, 'Customer Success', 'CS', 'CC-CS-001', 400000.00, 'Annual'),

-- E-Commerce Plus (1011) - Medium Retail
(1011, 'Technology', 'TECH', 'CC-TECH-001', 4500000.00, 'Annual'),
(1011, 'Operations', 'OPS', 'CC-OPS-001', 3000000.00, 'Annual'),
(1011, 'Marketing', 'MKT', 'CC-MKT-001', 2500000.00, 'Annual'),
(1011, 'Customer Service', 'CS', 'CC-CS-001', 1200000.00, 'Annual'),
(1011, 'Analytics', 'ANALYTICS', 'CC-ANALYTICS-001', 800000.00, 'Annual'),

-- EnerTech Global (1012) - Large Energy
(1012, 'Exploration', 'EXPL', 'CC-EXPL-001', 45000000.00, 'Annual'),
(1012, 'Production', 'PROD', 'CC-PROD-001', 65000000.00, 'Annual'),
(1012, 'Engineering', 'ENG', 'CC-ENG-001', 25000000.00, 'Annual'),
(1012, 'Environmental', 'ENV', 'CC-ENV-001', 8000000.00, 'Annual'),
(1012, 'Health & Safety', 'HS', 'CC-HS-001', 6000000.00, 'Annual'),
(1012, 'Information Technology', 'IT', 'CC-IT-001', 12000000.00, 'Annual'),

-- EduTech Solutions (1013) - Medium Education
(1013, 'Product Development', 'PD', 'CC-PD-001', 3000000.00, 'Annual'),
(1013, 'Content Creation', 'CC', 'CC-CC-001', 2000000.00, 'Annual'),
(1013, 'Sales & Marketing', 'SM', 'CC-SM-001', 1800000.00, 'Annual'),
(1013, 'Customer Success', 'CS', 'CC-CS-001', 1200000.00, 'Annual'),

-- Global Tech Europe (1014) - Large International Tech
(1014, 'Engineering', 'ENG', 'CC-ENG-001', 12000000.00, 'Annual'),
(1014, 'Sales', 'SALES', 'CC-SALES-001', 8000000.00, 'Annual'),
(1014, 'Marketing', 'MKT', 'CC-MKT-001', 5000000.00, 'Annual'),
(1014, 'Operations', 'OPS', 'CC-OPS-001', 6000000.00, 'Annual'),
(1014, 'Human Resources', 'HR', 'CC-HR-001', 2000000.00, 'Annual'),

-- Asia Pacific Solutions (1015) - Medium International Tech
(1015, 'Development', 'DEV', 'CC-DEV-001', 5500000.00, 'Annual'),
(1015, 'Sales & Marketing', 'SM', 'CC-SM-001', 4000000.00, 'Annual'),
(1015, 'Customer Support', 'CS', 'CC-CS-001', 2500000.00, 'Annual'),
(1015, 'Operations', 'OPS', 'CC-OPS-001', 3000000.00, 'Annual');

SELECT COUNT(*) AS DepartmentsInserted FROM Departments;

PRINT 'Departments data populated successfully!';
PRINT 'Total departments: ' + CAST(@@ROWCOUNT AS VARCHAR(10));