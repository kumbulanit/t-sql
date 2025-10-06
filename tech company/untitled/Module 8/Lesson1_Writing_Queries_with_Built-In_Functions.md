# Lesson 1: Writing Queries with Built-In Functions - TechCorp Solutions

## 🎯 What You'll Master Today (🔴 ADVANCED LEVEL)

Welcome to Module 8! You've now progressed from absolute beginner to advanced SQL practitioner. In this lesson, you'll master SQL Server's built-in functions to handle complex business scenarios at TechCorp Solutions. These functions are the power tools that transform raw data into meaningful business intelligence.

## 📖 TechCorp Business Context Review

As TechCorp Solutions has grown, we now need sophisticated data processing capabilities:
- **Complex Reporting**: Executive dashboards with calculated metrics
- **Data Cleansing**: Standardizing client data from various sources
- **Business Intelligence**: Advanced analytics for project profitability
- **Automated Processing**: System-generated reports and alerts

## 🎓 Learning Progression Check

### Where You've Been (Modules 1-7):
✅ **Database Architecture** - Built TechCorp's foundation  
✅ **Basic Queries** - SELECT, filtering, sorting  
✅ **Table Relationships** - JOINs and complex queries  
✅ **Data Modification** - INSERT, UPDATE, DELETE operations  

### Where You're Going (Module 8 - Advanced Functions):
🔄 **String Functions** - Text processing and data cleaning  
🔄 **Date/Time Functions** - Temporal calculations and reporting  
🔄 **Numeric Functions** - Financial calculations and metrics  
🔄 **Conversion Functions** - Data type handling and formatting  
🔄 **System Functions** - Metadata and administrative queries  

## 🏗️ Function Categories Overview

SQL Server provides hundreds of built-in functions organized into categories:

### 1. String Functions (Text Processing)
- Clean and standardize client data
- Format names, addresses, and identifiers
- Extract information from text fields

### 2. Date and Time Functions (Temporal Operations)
- Calculate project durations and deadlines
- Generate time-based reports
- Handle timezone conversions for global clients

### 3. Mathematical Functions (Numeric Calculations)
- Financial computations (interest, ROI, profitability)
- Statistical analysis (averages, percentiles)
- Rounding and precision control

### 4. Conversion Functions (Data Type Management)
- Convert between different data types safely
- Format output for reports and displays
- Handle NULL values intelligently

### 5. System Functions (Metadata and Control)
- Retrieve database and server information
- Implement business logic and validation
- Generate unique identifiers and timestamps

## Part 1: String Functions - Data Cleaning and Formatting 🔤

### 🎓 TUTORIAL: Why String Functions Matter

In the real world, data comes from many sources and isn't always clean:
- Client names entered inconsistently ("TechCorp", "Tech Corp", "TECHCORP")
- Email addresses with extra spaces
- Phone numbers in different formats
- Mixed case data that needs standardization

**Business Impact**: Clean data = accurate reports = better business decisions

### Exercise 1.1: Basic String Functions (🔴 ADVANCED)

**Scenario**: TechCorp's client database has inconsistent data entry. We need to clean and standardize the information for executive reporting.

```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Lab 8.1.1: String Length and Trimming Functions
-- Real business scenario: Clean up company names and contact information

SELECT 
    CompanyID,
    CompanyName,
    LEN(CompanyName) AS OriginalLength,
    
    -- Remove leading and trailing spaces
    LTRIM(RTRIM(CompanyName)) AS CleanedName,
    LEN(LTRIM(RTRIM(CompanyName))) AS CleanedLength,
    
    -- Check for extra spaces
    CASE 
        WHEN LEN(CompanyName) > LEN(LTRIM(RTRIM(CompanyName))) 
        THEN 'Has Extra Spaces'
        ELSE 'Clean'
    END AS DataQualityCheck
FROM Companies
WHERE CompanyName LIKE '% %' OR CompanyName LIKE ' %' OR CompanyName LIKE '% ';

-- Lab 8.1.2: Case Conversion for Standardization
-- Business need: Standardize company names for consistent reporting

SELECT 
    CompanyID,
    CompanyName AS Original,
    
    -- Different case conversions
    UPPER(CompanyName) AS UpperCase,
    LOWER(CompanyName) AS LowerCase,
    
    -- Proper case (first letter of each word capitalized)
    -- Note: SQL Server doesn't have built-in PROPER function, so we'll create logic
    CONCAT(
        UPPER(LEFT(CompanyName, 1)),
        LOWER(SUBSTRING(CompanyName, 2, LEN(CompanyName) - 1))
    ) AS ProperCase,
    
    -- Business rule: Company names in title case for reports
    CASE 
        WHEN CompanyName = UPPER(CompanyName) THEN 'All Uppercase - Needs Fixing'
        WHEN CompanyName = LOWER(CompanyName) THEN 'All Lowercase - Needs Fixing'
        ELSE 'Mixed Case - OK'
    END AS CaseAnalysis
FROM Companies;
```

### Exercise 1.2: String Extraction and Manipulation (🔴 ADVANCED)

**Scenario**: Extract domain names from email addresses to analyze which email providers our clients use.

```sql
-- Lab 8.1.3: Substring and Character Position Functions
-- Business scenario: Analyze client email domains for communication strategy

SELECT 
    CompanyID,
    CompanyName,
    PrimaryEmail,
    
    -- Find the position of @ symbol
    CHARINDEX('@', PrimaryEmail) AS AtPosition,
    
    -- Extract username (everything before @)
    LEFT(PrimaryEmail, CHARINDEX('@', PrimaryEmail) - 1) AS Username,
    
    -- Extract domain (everything after @)
    SUBSTRING(PrimaryEmail, CHARINDEX('@', PrimaryEmail) + 1, LEN(PrimaryEmail)) AS Domain,
    
    -- Alternative method using RIGHT function
    RIGHT(PrimaryEmail, LEN(PrimaryEmail) - CHARINDEX('@', PrimaryEmail)) AS DomainAlt,
    
    -- Business classification of email types
    CASE 
        WHEN PrimaryEmail LIKE '%@gmail.com' THEN 'Personal Gmail'
        WHEN PrimaryEmail LIKE '%@outlook.com' OR PrimaryEmail LIKE '%@hotmail.com' THEN 'Personal Microsoft'
        WHEN PrimaryEmail LIKE '%@yahoo.com' THEN 'Personal Yahoo'
        WHEN CHARINDEX('.', RIGHT(PrimaryEmail, LEN(PrimaryEmail) - CHARINDEX('@', PrimaryEmail))) > 0 
        THEN 'Corporate Domain'
        ELSE 'Other'
    END AS EmailType
FROM Companies
WHERE PrimaryEmail IS NOT NULL;

-- Lab 8.1.4: String Replacement and Pattern Matching
-- Business scenario: Standardize phone number formats

SELECT 
    CompanyID,
    CompanyName,
    PrimaryPhone AS OriginalPhone,
    
    -- Remove common formatting characters
    REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', '') AS DigitsOnly,
    
    -- Standardize to format: +1-555-123-4567
    CASE 
        WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10
        THEN '+1-' + 
             LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 3) + '-' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' +
             RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 4)
        WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', '')) = 11
        THEN '+' + 
             LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 1) + '-' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 2, 3) + '-' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 5, 3) + '-' +
             RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(PrimaryPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 4)
        ELSE 'Invalid Format'
    END AS StandardizedPhone,
    
    -- Validate phone number format
    CASE 
        WHEN PrimaryPhone LIKE '+1-___-___-____' THEN 'Standard Format'
        WHEN PrimaryPhone LIKE '(___) ___-____' THEN 'US Format'
        WHEN PrimaryPhone LIKE '___-___-____' THEN 'Simple Format'
        ELSE 'Non-Standard Format'
    END AS PhoneFormatType
FROM Companies
WHERE PrimaryPhone IS NOT NULL;
```

### Exercise 1.3: Advanced String Functions (🔴 EXPERT LEVEL)

**Scenario**: Create formatted company profiles for client presentations.

```sql
-- Lab 8.1.5: Advanced String Concatenation and Formatting
-- Business scenario: Generate formatted company profiles for proposals

SELECT 
    CompanyID,
    
    -- Create professional company summary
    CONCAT(
        CompanyName, 
        ' is a ', 
        LOWER(CompanySize), 
        ' company in the ', 
        LOWER(i.IndustryName), 
        ' industry, founded in ', 
        FoundedYear,
        '. Located in ', 
        City, ', ', StateProvince, ', ', c.CountryName,
        ', they generate approximately $',
        FORMAT(AnnualRevenue, 'N0'),
        ' in annual revenue with ',
        EmployeeCount,
        ' employees.'
    ) AS CompanyProfile,
    
    -- Create executive summary with string functions
    STUFF(
        CONCAT(
            'COMPANY: ', UPPER(CompanyName), CHAR(13) + CHAR(10),
            'INDUSTRY: ', i.IndustryName, CHAR(13) + CHAR(10),
            'SIZE: ', CompanySize, ' (', EmployeeCount, ' employees)', CHAR(13) + CHAR(10),
            'REVENUE: $', FORMAT(AnnualRevenue, 'N0'), CHAR(13) + CHAR(10),
            'LOCATION: ', City, ', ', StateProvince, CHAR(13) + CHAR(10),
            'WEBSITE: ', Website
        ), 1, 0, ''
    ) AS ExecutiveSummary,
    
    -- Create contact information block
    CONCAT(
        'Primary Contact: ', PrimaryEmail, CHAR(13) + CHAR(10),
        'Phone: ', PrimaryPhone, CHAR(13) + CHAR(10),
        'Address: ', StreetAddress, CHAR(13) + CHAR(10),
        '         ', City, ', ', StateProvince, ' ', PostalCode
    ) AS ContactBlock
    
FROM Companies c
    INNER JOIN Industries i ON c.IndustryID = i.IndustryID
    INNER JOIN Countries ct ON c.CountryID = ct.CountryID
WHERE c.IsActive = 1
    AND AnnualRevenue IS NOT NULL;
```

## Part 2: Date and Time Functions - Temporal Business Logic 📅

### 🎓 TUTORIAL: Why Date/Time Functions Are Critical

Business runs on time:
- **Project Deadlines**: Calculate remaining time, overdue projects
- **Employee Metrics**: Years of service, performance review cycles
- **Financial Reporting**: Quarter-end, year-end, aging analysis
- **Business Intelligence**: Trends, seasonality, growth rates

### Exercise 2.1: Basic Date/Time Functions (🔴 ADVANCED)

**Scenario**: TechCorp needs comprehensive time-based reporting for project management and HR analytics.

```sql
-- Lab 8.2.1: Current Date/Time Functions
-- Business scenario: Real-time dashboard with current information

SELECT 
    'TechCorp Dashboard - Current Status' AS ReportTitle,
    
    -- Different ways to get current date/time
    GETDATE() AS CurrentDateTime_Legacy,
    SYSDATETIME() AS CurrentDateTime_Precise,
    GETUTCDATE() AS CurrentDateTime_UTC,
    
    -- Extract components of current date
    YEAR(GETDATE()) AS CurrentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    DAY(GETDATE()) AS CurrentDay,
    DATEPART(QUARTER, GETDATE()) AS CurrentQuarter,
    DATEPART(WEEK, GETDATE()) AS WeekOfYear,
    DATEPART(DAYOFYEAR, GETDATE()) AS DayOfYear,
    DATENAME(WEEKDAY, GETDATE()) AS CurrentDayName,
    DATENAME(MONTH, GETDATE()) AS CurrentMonthName,
    
    -- Business period calculations
    CASE DATEPART(QUARTER, GETDATE())
        WHEN 1 THEN 'Q1 - Planning & Strategy'
        WHEN 2 THEN 'Q2 - Implementation'
        WHEN 3 THEN 'Q3 - Execution'
        WHEN 4 THEN 'Q4 - Year-End Push'
    END AS BusinessQuarter;

-- Lab 8.2.2: Employee Service Analysis
-- Business scenario: Calculate years of service for performance reviews and bonuses

SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS EmployeeName,
    HireDate,
    
    -- Calculate years of service (different methods)
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsService_Simple,
    
    -- More accurate calculation considering actual dates
    CASE 
        WHEN MONTH(GETDATE()) > MONTH(HireDate) 
        OR (MONTH(GETDATE()) = MONTH(HireDate) AND DAY(GETDATE()) >= DAY(HireDate))
        THEN DATEDIFF(YEAR, HireDate, GETDATE())
        ELSE DATEDIFF(YEAR, HireDate, GETDATE()) - 1
    END AS YearsService_Exact,
    
    -- Calculate total months and days
    DATEDIFF(MONTH, HireDate, GETDATE()) AS TotalMonths,
    DATEDIFF(DAY, HireDate, GETDATE()) AS TotalDays,
    
    -- Business logic for service milestones
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran (10+ years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN 'Senior (5-9 years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 2 THEN 'Experienced (2-4 years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 1 THEN 'Established (1-2 years)'
        ELSE 'New Hire (< 1 year)'
    END AS ServiceCategory,
    
    -- Next anniversary date
    DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()) + 1, HireDate) AS NextAnniversary,
    
    -- Days until next anniversary
    DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()) + 1, HireDate)) AS DaysToAnniversary
    
FROM Employees
WHERE IsActive = 1
ORDER BY YearsService_Exact DESC, LastName;
```

### Exercise 2.2: Advanced Date Calculations (🔴 EXPERT LEVEL)

**Scenario**: Complex project timeline analysis and financial period calculations.

```sql
-- Lab 8.2.3: Project Timeline Analysis
-- Business scenario: Analyze project performance, delays, and resource planning

SELECT 
    p.ProjectID,
    p.ProjectName,
    p.StartDate,
    p.PlannedEndDate,
    p.ActualEndDate,
    
    -- Calculate project durations
    DATEDIFF(DAY, p.StartDate, p.PlannedEndDate) AS PlannedDurationDays,
    DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, GETDATE())) AS ActualDurationDays,
    
    -- Project status analysis
    CASE 
        WHEN p.ActualEndDate IS NULL AND GETDATE() > p.PlannedEndDate 
        THEN DATEDIFF(DAY, p.PlannedEndDate, GETDATE())
        WHEN p.ActualEndDate IS NOT NULL AND p.ActualEndDate > p.PlannedEndDate
        THEN DATEDIFF(DAY, p.PlannedEndDate, p.ActualEndDate)
        ELSE 0
    END AS DaysOverdue,
    
    -- Business performance metrics
    CASE 
        WHEN p.ActualEndDate IS NULL AND GETDATE() <= p.PlannedEndDate THEN 'On Track'
        WHEN p.ActualEndDate IS NULL AND GETDATE() > p.PlannedEndDate THEN 'Overdue'
        WHEN p.ActualEndDate <= p.PlannedEndDate THEN 'Completed On Time'
        WHEN p.ActualEndDate > p.PlannedEndDate THEN 'Completed Late'
    END AS ProjectStatus,
    
    -- Calculate completion percentage for active projects
    CASE 
        WHEN p.ActualEndDate IS NOT NULL THEN 100.0
        WHEN GETDATE() <= p.StartDate THEN 0.0
        WHEN GETDATE() >= p.PlannedEndDate THEN 100.0
        ELSE 
            CAST(DATEDIFF(DAY, p.StartDate, GETDATE()) AS FLOAT) / 
            CAST(DATEDIFF(DAY, p.StartDate, p.PlannedEndDate) AS FLOAT) * 100.0
    END AS EstimatedCompletionPercent,
    
    -- Weekend and business day calculations
    DATEDIFF(WEEK, p.StartDate, ISNULL(p.ActualEndDate, GETDATE())) * 2 AS WeekendDays,
    DATEDIFF(DAY, p.StartDate, ISNULL(p.ActualEndDate, GETDATE())) - 
    (DATEDIFF(WEEK, p.StartDate, ISNULL(p.ActualEndDate, GETDATE())) * 2) AS BusinessDays
    
FROM Projects p
WHERE p.IsActive = 1
ORDER BY 
    CASE 
        WHEN p.ActualEndDate IS NULL AND GETDATE() > p.PlannedEndDate THEN 1
        WHEN p.ActualEndDate IS NULL THEN 2
        ELSE 3
    END,
    DaysOverdue DESC;

-- Lab 8.2.4: Financial Period Analysis
-- Business scenario: Quarter-end reporting and fiscal year calculations

SELECT 
    'Financial Period Analysis' AS ReportType,
    
    -- Current period information
    GETDATE() AS CurrentDate,
    YEAR(GETDATE()) AS FiscalYear,
    DATEPART(QUARTER, GETDATE()) AS CurrentQuarter,
    
    -- Quarter boundaries
    DATEFROMPARTS(YEAR(GETDATE()), ((DATEPART(QUARTER, GETDATE()) - 1) * 3) + 1, 1) AS QuarterStart,
    EOMONTH(DATEFROMPARTS(YEAR(GETDATE()), DATEPART(QUARTER, GETDATE()) * 3, 1)) AS QuarterEnd,
    
    -- Year boundaries
    DATEFROMPARTS(YEAR(GETDATE()), 1, 1) AS YearStart,
    DATEFROMPARTS(YEAR(GETDATE()), 12, 31) AS YearEnd,
    
    -- Days calculations
    DATEDIFF(DAY, DATEFROMPARTS(YEAR(GETDATE()), ((DATEPART(QUARTER, GETDATE()) - 1) * 3) + 1, 1), GETDATE()) + 1 AS DaysIntoQuarter,
    DATEDIFF(DAY, GETDATE(), EOMONTH(DATEFROMPARTS(YEAR(GETDATE()), DATEPART(QUARTER, GETDATE()) * 3, 1))) AS DaysLeftInQuarter,
    DATEDIFF(DAY, DATEFROMPARTS(YEAR(GETDATE()), 1, 1), GETDATE()) + 1 AS DaysIntoYear,
    DATEDIFF(DAY, GETDATE(), DATEFROMPARTS(YEAR(GETDATE()), 12, 31)) AS DaysLeftInYear,
    
    -- Business period progress
    CAST(
        (DATEDIFF(DAY, DATEFROMPARTS(YEAR(GETDATE()), ((DATEPART(QUARTER, GETDATE()) - 1) * 3) + 1, 1), GETDATE()) + 1) AS FLOAT) /
        DATEDIFF(DAY, 
            DATEFROMPARTS(YEAR(GETDATE()), ((DATEPART(QUARTER, GETDATE()) - 1) * 3) + 1, 1),
            EOMONTH(DATEFROMPARTS(YEAR(GETDATE()), DATEPART(QUARTER, GETDATE()) * 3, 1))
        ) * 100.0
    AS QuarterProgressPercent;
```

## Part 3: Mathematical Functions - Business Calculations 🔢

### 🎓 TUTORIAL: Math Functions in Business Context

Numbers drive business decisions:
- **Financial Analysis**: Profit margins, ROI calculations, compound growth
- **Statistical Analysis**: Averages, standard deviations, percentiles
- **Performance Metrics**: Efficiency ratios, productivity measures
- **Precision Control**: Rounding for currency, percentages for reports

### Exercise 3.1: Basic Mathematical Functions (🔴 ADVANCED)

**Scenario**: Calculate financial metrics and performance indicators for TechCorp's projects and employees.

```sql
-- Lab 8.3.1: Project Profitability Analysis
-- Business scenario: Calculate profit margins, ROI, and financial performance

SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    p.ActualCost,
    
    -- Basic calculations
    p.Budget - ISNULL(p.ActualCost, 0) AS GrossProfit,
    
    -- Percentage calculations with rounding
    CASE 
        WHEN p.Budget > 0 THEN 
            ROUND((p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget * 100.0, 2)
        ELSE 0
    END AS ProfitMarginPercent,
    
    -- Advanced mathematical functions
    ABS(p.Budget - ISNULL(p.ActualCost, 0)) AS AbsoluteProfitDifference,
    
    POWER((p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget, 2) AS ProfitVarianceSquared,
    
    SQRT(POWER((p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget, 2)) AS ProfitVarianceStdDev,
    
    -- Ceiling and floor functions for budgeting
    CEILING(p.Budget / 1000.0) * 1000 AS BudgetRoundedUp,
    FLOOR(p.Budget / 1000.0) * 1000 AS BudgetRoundedDown,
    
    -- Sign function for profit/loss indicator
    CASE SIGN(p.Budget - ISNULL(p.ActualCost, 0))
        WHEN 1 THEN 'Profitable'
        WHEN 0 THEN 'Break Even'
        WHEN -1 THEN 'Loss'
    END AS ProfitabilityStatus,
    
    -- Financial performance categories
    CASE 
        WHEN p.Budget > 0 AND (p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget >= 0.30 THEN 'High Profit (30%+)'
        WHEN p.Budget > 0 AND (p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget >= 0.15 THEN 'Good Profit (15-29%)'
        WHEN p.Budget > 0 AND (p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget >= 0.05 THEN 'Low Profit (5-14%)'
        WHEN p.Budget > 0 AND (p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget >= 0 THEN 'Marginal (0-4%)'
        ELSE 'Loss Project'
    END AS ProfitCategory
    
FROM Projects p
WHERE p.IsActive = 1
    AND p.Budget > 0
ORDER BY ProfitMarginPercent DESC;

-- Lab 8.3.2: Employee Compensation Analysis
-- Business scenario: Salary statistics and compensation benchmarking

SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    
    -- Basic statistical functions
    MIN(e.BaseSalary) AS MinSalary,
    MAX(e.BaseSalary) AS MaxSalary,
    AVG(e.BaseSalary) AS AvgSalary,
    
    -- Advanced mathematical calculations
    ROUND(AVG(e.BaseSalary), 0) AS AvgSalaryRounded,
    ROUND(STDEV(e.BaseSalary), 2) AS SalaryStandardDeviation,
    ROUND(VAR(e.BaseSalary), 2) AS SalaryVariance,
    
    -- Percentile calculations (using PERCENTILE_CONT)
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY e.BaseSalary) OVER (PARTITION BY d.DepartmentID) AS Salary25thPercentile,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY e.BaseSalary) OVER (PARTITION BY d.DepartmentID) AS SalaryMedian,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.BaseSalary) OVER (PARTITION BY d.DepartmentID) AS Salary75thPercentile,
    
    -- Mathematical derivations
    MAX(e.BaseSalary) - MIN(e.BaseSalary) AS SalaryRange,
    ROUND((MAX(e.BaseSalary) - MIN(e.BaseSalary)) / AVG(e.BaseSalary) * 100.0, 2) AS SalaryRangePercent,
    
    -- Logarithmic calculations for salary growth analysis
    ROUND(LOG(MAX(e.BaseSalary) / MIN(e.BaseSalary)), 4) AS SalaryGrowthLog,
    
    -- Exponential calculations
    ROUND(EXP(1.0), 4) AS EulerNumber,
    
    -- Trigonometric functions (example for data visualization scaling)
    ROUND(SIN(PI() / 4), 4) AS SineExample,
    ROUND(COS(PI() / 4), 4) AS CosineExample
    
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
    AND e.BaseSalary > 0
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AvgSalary DESC;
```

### Exercise 3.2: Advanced Financial Calculations (🔴 EXPERT LEVEL)

**Scenario**: Implement sophisticated financial models for business analysis.

```sql
-- Lab 8.3.3: Compound Growth and ROI Analysis
-- Business scenario: Calculate compound annual growth rate (CAGR) and investment returns

WITH CompanyGrowth AS (
    -- Simulate historical revenue data for growth calculations
    SELECT 
        CompanyID,
        CompanyName,
        AnnualRevenue AS CurrentRevenue,
        -- Simulate 3-year historical data for CAGR calculation
        AnnualRevenue * 0.75 AS Revenue3YearsAgo,
        FoundedYear,
        YEAR(GETDATE()) - FoundedYear AS CompanyAge
    FROM Companies
    WHERE AnnualRevenue IS NOT NULL
        AND FoundedYear IS NOT NULL
)
SELECT 
    CompanyID,
    CompanyName,
    CurrentRevenue,
    Revenue3YearsAgo,
    CompanyAge,
    
    -- CAGR Calculation: ((Ending Value / Beginning Value) ^ (1/number of years)) - 1
    CASE 
        WHEN Revenue3YearsAgo > 0 THEN
            ROUND((POWER(CurrentRevenue / Revenue3YearsAgo, 1.0/3.0) - 1) * 100.0, 2)
        ELSE NULL
    END AS CAGR_3Year_Percent,
    
    -- Simple growth rate
    CASE 
        WHEN Revenue3YearsAgo > 0 THEN
            ROUND((CurrentRevenue - Revenue3YearsAgo) / Revenue3YearsAgo * 100.0, 2)
        ELSE NULL
    END AS SimpleGrowthPercent,
    
    -- Future value projection (assuming same growth rate)
    CASE 
        WHEN Revenue3YearsAgo > 0 THEN
            ROUND(CurrentRevenue * POWER((CurrentRevenue / Revenue3YearsAgo), 1.0/3.0), 0)
        ELSE NULL
    END AS ProjectedRevenueNextYear,
    
    -- Logarithmic growth analysis
    CASE 
        WHEN Revenue3YearsAgo > 0 THEN
            ROUND(LOG(CurrentRevenue / Revenue3YearsAgo) / 3.0, 4)
        ELSE NULL
    END AS LogGrowthRate,
    
    -- Company maturity analysis using mathematical functions
    CASE 
        WHEN CompanyAge <= 5 THEN 'Startup Phase'
        WHEN CompanyAge <= 15 THEN 'Growth Phase'
        WHEN CompanyAge <= 30 THEN 'Maturity Phase'
        ELSE 'Established Phase'
    END AS BusinessLifecycleStage,
    
    -- Risk assessment using statistical functions
    CASE 
        WHEN Revenue3YearsAgo > 0 AND ABS((CurrentRevenue - Revenue3YearsAgo) / Revenue3YearsAgo) > 0.5 
        THEN 'High Volatility'
        WHEN Revenue3YearsAgo > 0 AND ABS((CurrentRevenue - Revenue3YearsAgo) / Revenue3YearsAgo) > 0.2 
        THEN 'Medium Volatility'
        ELSE 'Low Volatility'
    END AS RevenueVolatility
    
FROM CompanyGrowth
WHERE CurrentRevenue > 0
ORDER BY CAGR_3Year_Percent DESC;

-- Lab 8.3.4: Advanced Project Metrics and KPIs
-- Business scenario: Calculate complex project performance indicators

SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    p.ActualCost,
    p.EstimatedHours,
    p.ActualHours,
    
    -- Efficiency ratios
    CASE 
        WHEN p.EstimatedHours > 0 THEN
            ROUND(p.ActualHours / p.EstimatedHours, 3)
        ELSE NULL
    END AS HourEfficiencyRatio,
    
    CASE 
        WHEN p.Budget > 0 THEN
            ROUND(ISNULL(p.ActualCost, 0) / p.Budget, 3)
        ELSE NULL
    END AS CostEfficiencyRatio,
    
    -- Cost per hour analysis
    CASE 
        WHEN p.ActualHours > 0 THEN
            ROUND(ISNULL(p.ActualCost, 0) / p.ActualHours, 2)
        ELSE NULL
    END AS ActualCostPerHour,
    
    CASE 
        WHEN p.EstimatedHours > 0 THEN
            ROUND(p.Budget / p.EstimatedHours, 2)
        ELSE NULL
    END AS BudgetedCostPerHour,
    
    -- Performance scoring using mathematical transformations
    CASE 
        WHEN p.Budget > 0 AND p.EstimatedHours > 0 THEN
            ROUND(
                (
                    -- Cost efficiency component (weight: 40%)
                    (CASE WHEN ISNULL(p.ActualCost, 0) <= p.Budget THEN 1.0 ELSE p.Budget / ISNULL(p.ActualCost, 1) END * 0.4) +
                    -- Time efficiency component (weight: 40%)
                    (CASE WHEN ISNULL(p.ActualHours, 0) <= p.EstimatedHours THEN 1.0 ELSE p.EstimatedHours / ISNULL(p.ActualHours, 1) END * 0.4) +
                    -- Completion bonus (weight: 20%)
                    (CASE WHEN p.ActualEndDate IS NOT NULL THEN 0.2 ELSE 0 END)
                ) * 100.0, 1
            )
        ELSE NULL
    END AS PerformanceScore,
    
    -- Standard deviation from budget (normalized)
    CASE 
        WHEN p.Budget > 0 THEN
            ROUND(ABS(p.Budget - ISNULL(p.ActualCost, 0)) / p.Budget, 4)
        ELSE NULL
    END AS BudgetDeviationNormalized,
    
    -- Complexity scoring using mathematical functions
    ROUND(
        LOG10(ISNULL(p.Budget, 1)) + 
        SQRT(ISNULL(p.EstimatedHours, 1) / 100.0) + 
        (pt.ComplexityLevel * 0.5), 2
    ) AS ComplexityScore
    
FROM Projects p
    LEFT JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
WHERE p.IsActive = 1
ORDER BY PerformanceScore DESC;
```

## 🎯 Business Application Summary

### What You've Mastered:

1. **String Functions** - Clean and standardize business data
2. **Date/Time Functions** - Handle temporal business logic
3. **Mathematical Functions** - Perform complex business calculations
4. **Advanced Analytics** - Create sophisticated business metrics

### Real-World Applications:

- **Data Quality**: Automated data cleansing and standardization
- **Business Intelligence**: Complex KPIs and performance metrics
- **Financial Analysis**: ROI, CAGR, profitability calculations
- **Operational Reporting**: Timeline analysis, resource planning

### Next Steps:

Continue to Module 8 Lesson 2 where you'll learn about:
- **Conversion Functions** - Data type transformations
- **System Functions** - Metadata and administrative queries
- **Advanced Function Combinations** - Nested functions for complex logic
- **Performance Optimization** - Efficient function usage

---

*You've now mastered advanced SQL functions that form the backbone of professional database development and business intelligence systems!*