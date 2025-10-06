-- =============================================
-- TechCorp Database: Companies Data Population
-- Module 2-3: Core Business Entities
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- COMPANIES DATA
-- =============================================
PRINT 'Populating Companies table...';

INSERT INTO Companies (CompanyName, LegalName, TaxID, IndustryID, CompanySize, FoundedYear, 
    AnnualRevenue, EmployeeCount, Website, PrimaryEmail, PrimaryPhone, CountryID, 
    StreetAddress, City, StateProvince, PostalCode, Latitude, Longitude, 
    CreditRating, PaymentTerms, PreferredCurrency) VALUES

-- Technology Companies
('TechCorp Solutions', 'TechCorp Solutions Inc.', 'TC2016001', 1, 'Medium', 2010, 
    15500000.00, 145, 'www.techcorpsolutions.com', 'info@techcorpsolutions.com', '+1-555-0100', 1,
    '1200 Innovation Drive', 'San Francisco', 'California', '94107', 37.77493000, -122.41942000,
    'AA-', 30, 'USD'),

('CloudTech Innovations', 'CloudTech Innovations LLC', 'CTI2018002', 1, 'Small', 2018,
    4200000.00, 65, 'www.cloudtechinnovations.com', 'hello@cloudtechinnovations.com', '+1-555-0150', 1,
    '800 Cloud Avenue', 'Seattle', 'Washington', '98101', 47.60621000, -122.33207000,
    'A+', 30, 'USD'),

('DevOps Masters', 'DevOps Masters Corporation', 'DOM2015003', 1, 'Medium', 2015,
    8750000.00, 95, 'www.devopsmasters.com', 'contact@devopsmasters.com', '+1-555-0175', 1,
    '500 Automation Boulevard', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
    'A', 45, 'USD'),

-- Financial Services Companies
('Global Finance Corp', 'Global Finance Corporation Ltd.', 'GFC2015004', 2, 'Large', 2008,
    125000000.00, 850, 'www.globalfinancecorp.com', 'contact@globalfinancecorp.com', '+1-555-0200', 1,
    '500 Wall Street', 'New York', 'New York', '10005', 40.70589000, -74.00889000,
    'AAA', 15, 'USD'),

('Investment Partners LLC', 'Investment Partners Limited Liability Company', 'IPL2012005', 2, 'Medium', 2012,
    45000000.00, 320, 'www.investmentpartners.com', 'info@investmentpartners.com', '+1-555-0250', 1,
    '200 Financial Plaza', 'Chicago', 'Illinois', '60601', 41.88425000, -87.63245000,
    'AA', 30, 'USD'),

-- Healthcare Companies
('HealthTech Innovations', 'HealthTech Innovations LLC', 'HTI2017006', 3, 'Medium', 2015,
    18750000.00, 185, 'www.healthtechinnovations.com', 'hello@healthtechinnovations.com', '+1-555-0300', 1,
    '2000 Medical Center Drive', 'Boston', 'Massachusetts', '02115', 42.33143000, -71.10611000,
    'A+', 45, 'USD'),

('MedDevice Solutions', 'MedDevice Solutions Inc.', 'MDS2014007', 3, 'Large', 2014,
    75000000.00, 420, 'www.meddevicesolutions.com', 'sales@meddevicesolutions.com', '+1-555-0350', 1,
    '1500 Research Parkway', 'San Diego', 'California', '92121', 32.90829000, -117.20116000,
    'AA-', 60, 'USD'),

-- Manufacturing Companies
('AutoManu Systems', 'AutoManu Systems International Inc.', 'AMS2012008', 4, 'Large', 2005,
    189200000.00, 1200, 'www.automanusystems.com', 'sales@automanusystems.com', '+1-555-0400', 1,
    '1500 Industrial Parkway', 'Detroit', 'Michigan', '48201', 42.33143000, -83.04575000,
    'A', 60, 'USD'),

('Precision Manufacturing', 'Precision Manufacturing Corp.', 'PMC2010009', 4, 'Medium', 2010,
    32000000.00, 285, 'www.precisionmfg.com', 'info@precisionmfg.com', '+1-555-0450', 1,
    '3000 Manufacturing Way', 'Milwaukee', 'Wisconsin', '53201', 43.04181000, -87.91683000,
    'A-', 45, 'USD'),

-- Retail Companies
('RetailMax Solutions', 'RetailMax Solutions Corp.', 'RMS2018010', 5, 'Small', 2018,
    8200000.00, 95, 'www.retailmaxsolutions.com', 'support@retailmaxsolutions.com', '+1-555-0500', 1,
    '800 Commerce Street', 'Austin', 'Texas', '78701', 30.26759000, -97.74299000,
    'BBB+', 30, 'USD'),

('E-Commerce Plus', 'E-Commerce Plus LLC', 'ECP2016011', 5, 'Medium', 2016,
    22500000.00, 165, 'www.ecommerceplus.com', 'hello@ecommerceplus.com', '+1-555-0550', 1,
    '1200 Digital Avenue', 'Denver', 'Colorado', '80202', 39.74739000, -104.99183000,
    'A-', 30, 'USD'),

-- Energy Companies
('EnerTech Global', 'EnerTech Global Ltd.', 'ETG2011012', 6, 'Enterprise', 2003,
    345000000.00, 2100, 'www.enertechglobal.com', 'info@enertechglobal.com', '+1-555-0600', 1,
    '3500 Energy Plaza', 'Houston', 'Texas', '77002', 29.76043000, -95.36980000,
    'AA', 30, 'USD'),

-- Education Companies
('EduTech Solutions', 'EduTech Solutions Inc.', 'ETS2017013', 7, 'Medium', 2017,
    12500000.00, 125, 'www.edutechsolutions.com', 'contact@edutechsolutions.com', '+1-555-0700', 1,
    '400 Learning Lane', 'Raleigh', 'North Carolina', '27601', 35.78043000, -78.64398000,
    'A', 30, 'USD'),

-- International Companies
('Global Tech Europe', 'Global Tech Europe GmbH', 'GTE2013014', 1, 'Large', 2013,
    65000000.00, 480, 'www.globaltecheurope.com', 'info@globaltecheurope.com', '+49-30-555-0800', 4,
    'Unter den Linden 1', 'Berlin', 'Berlin', '10117', 52.51607000, 13.37699000,
    'AA-', 30, 'EUR'),

('Asia Pacific Solutions', 'Asia Pacific Solutions Pte Ltd', 'APS2015015', 1, 'Medium', 2015,
    28000000.00, 195, 'www.asiapacificsolutions.com', 'hello@asiapacificsolutions.com', '+65-6555-0900', 7,
    '1 Marina Bay Drive', 'Singapore', 'Singapore', '018989', 1.28670000, 103.85470000,
    'A+', 30, 'SGD');

SELECT COUNT(*) AS CompaniesInserted FROM Companies;

PRINT 'Companies data populated successfully!';
PRINT 'Total companies: ' + CAST(@@ROWCOUNT AS VARCHAR(10));