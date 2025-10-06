-- =============================================
-- TechCorp Database: Lookup Tables Data Population
-- Module 1-2: Basic Reference Data
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- 1. COUNTRIES DATA
-- =============================================
PRINT 'Populating Countries table...';

INSERT INTO Countries (CountryCode, CountryName, CurrencyCode, TimeZoneOffset) VALUES
('US', 'United States', 'USD', -5.0),
('CA', 'Canada', 'CAD', -5.0),
('UK', 'United Kingdom', 'GBP', 0.0),
('DE', 'Germany', 'EUR', 1.0),
('FR', 'France', 'EUR', 1.0),
('AU', 'Australia', 'AUD', 10.0),
('SG', 'Singapore', 'SGD', 8.0),
('JP', 'Japan', 'JPY', 9.0),
('BR', 'Brazil', 'BRL', -3.0),
('IN', 'India', 'INR', 5.5),
('CN', 'China', 'CNY', 8.0),
('MX', 'Mexico', 'MXN', -6.0);

SELECT COUNT(*) AS CountriesInserted FROM Countries;

-- =============================================
-- 2. INDUSTRIES DATA
-- =============================================
PRINT 'Populating Industries table...';

INSERT INTO Industries (IndustryCode, IndustryName, IndustryDescription, RiskLevel, RegulationLevel) VALUES
('TECH', 'Technology', 'Software development, IT services, digital transformation', 2, 'Standard'),
('FINC', 'Financial Services', 'Banking, insurance, investment services', 4, 'High'),
('HLTH', 'Healthcare', 'Hospitals, medical devices, pharmaceutical', 3, 'High'),
('MANU', 'Manufacturing', 'Industrial production, automotive, aerospace', 3, 'Standard'),
('RETL', 'Retail', 'Consumer goods, e-commerce, retail chains', 2, 'Standard'),
('ERGY', 'Energy', 'Oil, gas, renewable energy, utilities', 5, 'High'),
('EDUC', 'Education', 'Universities, training, e-learning platforms', 1, 'Standard'),
('GOVT', 'Government', 'Public sector, municipal services', 2, 'High'),
('CONS', 'Construction', 'Building, infrastructure, real estate development', 3, 'Standard'),
('TELE', 'Telecommunications', 'Mobile, internet, satellite communications', 2, 'Standard'),
('TRAN', 'Transportation', 'Logistics, shipping, airlines', 3, 'Standard'),
('AGRI', 'Agriculture', 'Farming, food production, agribusiness', 2, 'Standard');

SELECT COUNT(*) AS IndustriesInserted FROM Industries;

-- =============================================
-- 3. SKILL CATEGORIES DATA
-- =============================================
PRINT 'Populating SkillCategories table...';

INSERT INTO SkillCategories (CategoryName, CategoryDescription, DifficultyLevel, MarketDemand) VALUES
('Programming', 'Software development and coding skills', 3, 1.50),
('Project Management', 'Planning, coordination, and delivery management', 2, 1.25),
('Data Analysis', 'Statistics, reporting, and business intelligence', 3, 1.40),
('Cloud Technologies', 'AWS, Azure, Google Cloud platforms', 4, 1.75),
('Cybersecurity', 'Information security and risk management', 4, 1.60),
('Business Analysis', 'Requirements gathering and process optimization', 2, 1.20),
('DevOps', 'Continuous integration and deployment', 4, 1.65),
('UI/UX Design', 'User interface and user experience design', 3, 1.35),
('Database Administration', 'Database design, optimization, and maintenance', 3, 1.30),
('Network Administration', 'Network infrastructure and security', 3, 1.25),
('Quality Assurance', 'Software testing and quality control', 2, 1.15),
('Technical Writing', 'Documentation and technical communication', 2, 1.10);

SELECT COUNT(*) AS SkillCategoriesInserted FROM SkillCategories;

-- =============================================
-- 4. JOB LEVELS DATA
-- =============================================
PRINT 'Populating JobLevels table...';

INSERT INTO JobLevels (LevelName, LevelCode, MinSalary, MaxSalary, RequiredYearsExperience, 
    AuthorityLevel, CanApproveExpenses, MaxExpenseApproval) VALUES
('Intern', 'L0', 25000.00, 35000.00, 0, 1, 0, NULL),
('Junior', 'L1', 45000.00, 65000.00, 0, 1, 0, NULL),
('Intermediate', 'L2', 60000.00, 85000.00, 2, 2, 1, 500.00),
('Senior', 'L3', 80000.00, 120000.00, 5, 4, 1, 2000.00),
('Lead', 'L4', 110000.00, 160000.00, 8, 6, 1, 5000.00),
('Principal', 'L5', 150000.00, 220000.00, 12, 8, 1, 10000.00),
('Manager', 'M1', 120000.00, 180000.00, 8, 7, 1, 15000.00),
('Senior Manager', 'M2', 160000.00, 240000.00, 12, 8, 1, 25000.00),
('Director', 'D1', 200000.00, 300000.00, 15, 9, 1, 50000.00),
('VP', 'VP1', 275000.00, 450000.00, 18, 10, 1, 100000.00);

SELECT COUNT(*) AS JobLevelsInserted FROM JobLevels;

PRINT 'Lookup tables populated successfully!';
PRINT 'Ready for company and organizational data.';