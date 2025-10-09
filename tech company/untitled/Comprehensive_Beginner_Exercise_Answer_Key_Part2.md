# 🎯 COMPREHENSIVE BEGINNER EXERCISE - ANSWER KEY PART 2

## Continued Solutions: Functions, Aggregation, DML, and Final Capstone

---

## 🔧 **PART 5 SOLUTIONS: FUNCTION MASTERY SHOWCASE**

### **Task 5.1: Data Transformation & Quality Report - SOLUTIONS**

#### **1. String Function Mastery - SOLUTION**

```sql
-- ================================
-- STRING FUNCTION MASTERY AND DATA STANDARDIZATION
-- Module References: Module 8 (Lessons 1-2 - String Functions)
-- ================================

SELECT 
    e.EmployeeID,
    
    -- Original data for comparison
    e.FirstName as OriginalFirstName,
    e.LastName as OriginalLastName,
    e.Email as OriginalEmail,
    e.Phone as OriginalPhone,
    
    -- Standardized name formatting
    UPPER(LEFT(LTRIM(RTRIM(e.FirstName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(e.FirstName)), 2, LEN(LTRIM(RTRIM(e.FirstName))))) as StandardizedFirstName,
    UPPER(LEFT(LTRIM(RTRIM(e.LastName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(e.LastName)), 2, LEN(LTRIM(RTRIM(e.LastName))))) as StandardizedLastName,
    
    -- Full name with proper formatting
    CONCAT(
        UPPER(LEFT(LTRIM(RTRIM(e.FirstName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(e.FirstName)), 2, LEN(LTRIM(RTRIM(e.FirstName))))),
        CASE 
            WHEN e.MiddleName IS NOT NULL 
            THEN ' ' + UPPER(LEFT(LTRIM(RTRIM(e.MiddleName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(e.MiddleName)), 2, LEN(LTRIM(RTRIM(e.MiddleName))))) + ' '
            ELSE ' '
        END,
        UPPER(LEFT(LTRIM(RTRIM(e.LastName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(e.LastName)), 2, LEN(LTRIM(RTRIM(e.LastName)))))
    ) as FormattedFullName,
    
    -- Email domain extraction and validation
    RIGHT(e.Email, LEN(e.Email) - CHARINDEX('@', e.Email)) as EmailDomain,
    
    -- Email domain categorization
    CASE 
        WHEN RIGHT(e.Email, LEN(e.Email) - CHARINDEX('@', e.Email)) = 'techcorp.com' THEN 'Corporate Email'
        WHEN RIGHT(e.Email, LEN(e.Email) - CHARINDEX('@', e.Email)) IN ('gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com') THEN 'Personal Email'
        ELSE 'External/Other Domain'
    END as EmailClassification,
    
    -- Phone number standardization (assuming 10-digit US format)
    CASE 
        WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10 
        THEN '(' + LEFT(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 3) + ') ' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' +
             RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 4)
        WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 11 
        THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 2, 3) + ') ' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 5, 3) + '-' +
             RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', ''), 4)
        ELSE 'Invalid Format: ' + e.Phone
    END as StandardizedPhone,
    
    -- Job title analysis for seniority detection
    CASE 
        WHEN e.JobTitle LIKE '%Senior%' OR e.JobTitle LIKE '%Sr.%' OR e.JobTitle LIKE '%Lead%' THEN 'Senior Level'
        WHEN e.JobTitle LIKE '%Junior%' OR e.JobTitle LIKE '%Jr.%' OR e.JobTitle LIKE '%Associate%' THEN 'Junior Level'
        WHEN e.JobTitle LIKE '%Manager%' OR e.JobTitle LIKE '%Director%' OR e.JobTitle LIKE '%VP%' OR e.JobTitle LIKE '%Chief%' THEN 'Management'
        WHEN e.JobTitle LIKE '%Intern%' OR e.JobTitle LIKE '%Trainee%' THEN 'Entry Level'
        ELSE 'Mid Level'
    END as SeniorityLevel,
    
    -- Extract keywords from job titles
    CASE 
        WHEN CHARINDEX(' ', e.JobTitle) > 0 THEN LEFT(e.JobTitle, CHARINDEX(' ', e.JobTitle) - 1)
        ELSE e.JobTitle
    END as PrimaryJobFunction,
    
    -- Address standardization (if address fields exist)
    UPPER(LEFT(LTRIM(RTRIM(ISNULL(e.Address, 'N/A'))), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(ISNULL(e.Address, 'N/A'))), 2, LEN(LTRIM(RTRIM(ISNULL(e.Address, 'N/A')))))) as StandardizedAddress,
    
    -- Data quality indicators
    CASE 
        WHEN e.FirstName IS NULL OR LTRIM(RTRIM(e.FirstName)) = '' THEN 'Missing First Name'
        WHEN e.LastName IS NULL OR LTRIM(RTRIM(e.LastName)) = '' THEN 'Missing Last Name'
        WHEN e.Email IS NULL OR CHARINDEX('@', e.Email) = 0 THEN 'Invalid Email'
        WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(e.Phone, '(', ''), ')', ''), '-', ''), ' ', '')) NOT IN (10, 11) THEN 'Invalid Phone'
        ELSE 'Complete Profile'
    END as DataQualityStatus,
    
    -- Character count analysis
    LEN(LTRIM(RTRIM(e.FirstName))) as FirstNameLength,
    LEN(LTRIM(RTRIM(e.LastName))) as LastNameLength,
    LEN(e.Email) as EmailLength

FROM Employees e
WHERE e.IsActive = 1

ORDER BY 
    CASE 
        WHEN e.FirstName IS NULL OR LTRIM(RTRIM(e.FirstName)) = '' THEN 1
        WHEN e.LastName IS NULL OR LTRIM(RTRIM(e.LastName)) = '' THEN 2
        WHEN e.Email IS NULL OR CHARINDEX('@', e.Email) = 0 THEN 3
        ELSE 4
    END,
    e.LastName,
    e.FirstName;
```

**🎯 Business Explanation**: Data standardization is crucial for reporting accuracy and professional presentation. This transformation ensures all employee names follow consistent formatting, phone numbers are readable, and email addresses are properly categorized. Clean data improves customer-facing reports and internal communications.

**🔧 Technical Breakdown**:

- **String manipulation functions**: UPPER, LOWER, LEFT, RIGHT, SUBSTRING (Module 8, Lesson 2)
- **Whitespace handling**: LTRIM, RTRIM for cleaning (Module 8, Lesson 2)  
- **String searching**: CHARINDEX for finding characters (Module 8, Lesson 2)
- **Complex CASE logic**: Multi-condition string analysis
- **CONCAT vs + operator**: Safe string concatenation handling NULLs
- **LEN function**: String length analysis for validation

---

#### **2. Date/Time Function Excellence - SOLUTION**

```sql
-- ================================
-- DATE/TIME FUNCTION MASTERY AND TEMPORAL ANALYSIS
-- Module References: Module 6 (Lesson 3), Module 8 (Lesson 3)
-- ================================

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName as EmployeeName,
    e.HireDate,
    e.BirthDate,
    
    -- Precise employment duration calculations
    DATEDIFF(YEAR, e.HireDate, GETDATE()) as CompletedYears,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 as AdditionalMonths,
    DATEDIFF(DAY, 
        DATEADD(MONTH, DATEDIFF(MONTH, e.HireDate, GETDATE()), e.HireDate), 
        GETDATE()
    ) as AdditionalDays,
    
    -- Total employment in different units
    DATEDIFF(DAY, e.HireDate, GETDATE()) as TotalDaysEmployed,
    DATEDIFF(WEEK, e.HireDate, GETDATE()) as TotalWeeksEmployed,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) as TotalMonthsEmployed,
    
    -- Upcoming work anniversaries (next 90 days)
    DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, GETDATE()) + 1, e.HireDate) as NextAnniversary,
    DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, GETDATE()) + 1, e.HireDate)) as DaysToAnniversary,
    
    -- Anniversary milestone detection
    CASE 
        WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, GETDATE()) + 1, e.HireDate)) <= 30 THEN 'Anniversary This Month'
        WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, GETDATE()) + 1, e.HireDate)) <= 90 THEN 'Anniversary Next Quarter'
        ELSE 'No Upcoming Anniversary'
    END as AnniversaryAlert,
    
    -- Hiring pattern analysis by date parts
    DATENAME(MONTH, e.HireDate) as HireMonth,
    DATENAME(QUARTER, e.HireDate) as HireQuarter,
    YEAR(e.HireDate) as HireYear,
    DATENAME(WEEKDAY, e.HireDate) as HireDayOfWeek,
    
    -- Age calculations (if birth date available)
    CASE 
        WHEN e.BirthDate IS NOT NULL 
        THEN DATEDIFF(YEAR, e.BirthDate, GETDATE())
        ELSE NULL
    END as CurrentAge,
    
    CASE 
        WHEN e.BirthDate IS NOT NULL 
        THEN DATEDIFF(YEAR, e.BirthDate, e.HireDate)
        ELSE NULL
    END as AgeAtHire,
    
    -- Retirement planning (assuming retirement age 65)
    CASE 
        WHEN e.BirthDate IS NOT NULL 
        THEN DATEADD(YEAR, 65, e.BirthDate)
        ELSE NULL
    END as EstimatedRetirementDate,
    
    CASE 
        WHEN e.BirthDate IS NOT NULL 
        THEN DATEDIFF(YEAR, GETDATE(), DATEADD(YEAR, 65, e.BirthDate))
        ELSE NULL
    END as YearsUntilRetirement,
    
    -- Time zone and business day calculations
    GETDATE() as CurrentDateTime,
    GETUTCDATE() as CurrentUTCDateTime,
    
    -- First and last day of current month
    DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) as FirstDayOfCurrentMonth,
    EOMONTH(GETDATE()) as LastDayOfCurrentMonth,
    
    -- Calculate business days employed (approximate - excludes weekends)
    DATEDIFF(DAY, e.HireDate, GETDATE()) - 
    (DATEDIFF(WEEK, e.HireDate, GETDATE()) * 2) - 
    CASE WHEN DATENAME(WEEKDAY, e.HireDate) = 'Sunday' THEN 1 ELSE 0 END -
    CASE WHEN DATENAME(WEEKDAY, GETDATE()) = 'Saturday' THEN 1 ELSE 0 END as ApproxBusinessDaysEmployed,
    
    -- Seasonal hiring analysis
    CASE 
        WHEN MONTH(e.HireDate) IN (12, 1, 2) THEN 'Winter Hire'
        WHEN MONTH(e.HireDate) IN (3, 4, 5) THEN 'Spring Hire'
        WHEN MONTH(e.HireDate) IN (6, 7, 8) THEN 'Summer Hire'
        WHEN MONTH(e.HireDate) IN (9, 10, 11) THEN 'Fall Hire'
    END as HiringSeason,
    
    -- Generation classification based on birth year
    CASE 
        WHEN YEAR(e.BirthDate) >= 1997 THEN 'Gen Z'
        WHEN YEAR(e.BirthDate) >= 1981 THEN 'Millennial'
        WHEN YEAR(e.BirthDate) >= 1965 THEN 'Gen X'
        WHEN YEAR(e.BirthDate) >= 1946 THEN 'Baby Boomer'
        WHEN YEAR(e.BirthDate) < 1946 THEN 'Silent Generation'
        ELSE 'Unknown Generation'
    END as GenerationGroup

FROM Employees e
WHERE e.IsActive = 1

ORDER BY e.HireDate DESC;

-- Summary of hiring patterns for HR analysis
SELECT 
    YEAR(e.HireDate) as HireYear,
    DATENAME(QUARTER, e.HireDate) as Quarter,
    COUNT(*) as EmployeesHired,
    AVG(DATEDIFF(YEAR, e.BirthDate, e.HireDate)) as AvgAgeAtHire,
    MIN(e.HireDate) as EarliestHireDate,
    MAX(e.HireDate) as LatestHireDate
FROM Employees e
WHERE e.IsActive = 1
    AND e.HireDate >= DATEADD(YEAR, -5, GETDATE())  -- Last 5 years only
GROUP BY YEAR(e.HireDate), DATENAME(QUARTER, e.HireDate)
ORDER BY HireYear DESC, Quarter;
```

**🎯 Business Explanation**: This temporal analysis supports HR planning, anniversary recognition programs, and workforce demographics analysis. Understanding hiring patterns helps predict seasonal staffing needs and plan retention programs around key milestones.

**🔧 Technical Breakdown**:

- **DATEDIFF variations**: Calculate differences in various time units (Module 6, Lesson 3)
- **DATEADD function**: Add/subtract time periods (Module 6, Lesson 3)
- **Date part functions**: YEAR, MONTH, DAY, DATENAME (Module 6, Lesson 3)
- **EOMONTH function**: End of month calculations (Module 6, Lesson 3)
- **DATEFROMPARTS**: Construct dates from components (Module 6, Lesson 3)
- **Complex date arithmetic**: Business day calculations
- **UTC vs local time**: Time zone awareness

---

#### **3. Mathematical Function Applications - SOLUTION**

```sql
-- ================================
-- MATHEMATICAL FUNCTION MASTERY AND FINANCIAL ANALYSIS
-- Module References: Module 8 (Lesson 4 - Mathematical Functions)
-- ================================

WITH SalaryAnalytics AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        d.DepartmentName,
        e.JobTitle,
        e.BaseSalary,
        e.HireDate,
        
        -- Get salary history for calculations (simulated with random increases)
        e.BaseSalary * 0.95 as EstimatedStartingSalary,  -- Assume 5% growth
        
        -- Performance metrics
        (SELECT AVG(pm.Achievement) 
         FROM PerformanceMetrics pm 
         WHERE pm.EmployeeID = e.EmployeeID) as AvgPerformanceRating,
        
        -- Project budget data
        (SELECT SUM(p.Budget) 
         FROM Projects p 
         INNER JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
         WHERE ep.EmployeeID = e.EmployeeID) as TotalProjectBudgetManaged
         
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
)

SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentName,
    JobTitle,
    
    -- Salary calculations with mathematical functions
    FORMAT(BaseSalary, 'C') as CurrentSalary,
    FORMAT(EstimatedStartingSalary, 'C') as EstimatedStartingSalary,
    
    -- Percentage calculations
    CAST(
        ((BaseSalary - EstimatedStartingSalary) / EstimatedStartingSalary) * 100 
        AS DECIMAL(5,2)
    ) as SalaryGrowthPercentage,
    
    -- Annual calculations
    CAST(BaseSalary / 12 AS DECIMAL(10,2)) as MonthlySalary,
    CAST(BaseSalary / 52 AS DECIMAL(10,2)) as WeeklySalary,
    CAST(BaseSalary / 260 AS DECIMAL(10,2)) as DailySalary,  -- 260 work days per year
    CAST(BaseSalary / 2080 AS DECIMAL(10,2)) as HourlySalary,  -- 2080 work hours per year
    
    -- Mathematical functions for analysis
    ROUND(BaseSalary, -3) as SalaryRoundedToNearestThousand,
    CEILING(BaseSalary / 1000) * 1000 as SalaryCeilingThousand,
    FLOOR(BaseSalary / 1000) * 1000 as SalaryFloorThousand,
    
    -- Statistical calculations
    ABS(BaseSalary - 75000) as DeviationFromTarget75K,
    
    -- Power and exponential calculations for projections
    POWER((BaseSalary / EstimatedStartingSalary), 
          1.0 / DATEDIFF(YEAR, HireDate, GETDATE())) as AnnualGrowthRate,
    
    -- Compound interest projection (3% annual increases)
    CAST(
        BaseSalary * POWER(1.03, 5) AS DECIMAL(10,2)
    ) as ProjectedSalaryIn5Years,
    
    -- Logarithmic calculations for analysis
    LOG(BaseSalary) as LogSalary,
    LOG10(BaseSalary) as Log10Salary,
    
    -- Trigonometric functions for performance visualization (example)
    SIN(ISNULL(AvgPerformanceRating, 3) * PI() / 10) as PerformanceSineWave,
    
    -- Random functions for sampling (deterministic based on employee ID)
    (EmployeeID % 100) / 100.0 as PseudoRandomSample,
    
    -- Financial calculations
    CASE 
        WHEN TotalProjectBudgetManaged IS NOT NULL AND TotalProjectBudgetManaged > 0
        THEN CAST(TotalProjectBudgetManaged / BaseSalary AS DECIMAL(10,2))
        ELSE 0
    END as BudgetToSalaryRatio,
    
    -- ROI calculations (simplified)
    CASE 
        WHEN AvgPerformanceRating IS NOT NULL AND AvgPerformanceRating > 0
        THEN CAST((AvgPerformanceRating * BaseSalary) / BaseSalary AS DECIMAL(5,2))
        ELSE 0
    END as PerformanceROI,
    
    -- Quartile assignments using mathematical division
    CASE 
        WHEN BaseSalary <= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY BaseSalary) FROM SalaryAnalytics) THEN 1
        WHEN BaseSalary <= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY BaseSalary) FROM SalaryAnalytics) THEN 2
        WHEN BaseSalary <= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY BaseSalary) FROM SalaryAnalytics) THEN 3
        ELSE 4
    END as SalaryQuartile,
    
    -- Square root for standard deviation-like calculations
    SQRT(ABS(BaseSalary - (SELECT AVG(BaseSalary) FROM SalaryAnalytics WHERE DepartmentName = sa.DepartmentName))) as SalaryDeviationSqrt,
    
    -- Modulo operations for grouping
    EmployeeID % 10 as EmployeeGroupMod10,
    
    -- Tax bracket simulation (simplified US federal rates)
    CASE 
        WHEN BaseSalary <= 10275 THEN BaseSalary * 0.10
        WHEN BaseSalary <= 41775 THEN 1027.50 + (BaseSalary - 10275) * 0.12
        WHEN BaseSalary <= 89450 THEN 4807.50 + (BaseSalary - 41775) * 0.22
        WHEN BaseSalary <= 190750 THEN 15213.50 + (BaseSalary - 89450) * 0.24
        ELSE 39895.50 + (BaseSalary - 190750) * 0.32
    END as EstimatedFederalTax,
    
    -- Net salary calculation
    BaseSalary - (
        CASE 
            WHEN BaseSalary <= 10275 THEN BaseSalary * 0.10
            WHEN BaseSalary <= 41775 THEN 1027.50 + (BaseSalary - 10275) * 0.12
            WHEN BaseSalary <= 89450 THEN 4807.50 + (BaseSalary - 41775) * 0.22
            WHEN BaseSalary <= 190750 THEN 15213.50 + (BaseSalary - 89450) * 0.24
            ELSE 39895.50 + (BaseSalary - 190750) * 0.32
        END
    ) - (BaseSalary * 0.0765) as EstimatedNetSalary  -- Subtract FICA taxes

FROM SalaryAnalytics sa

ORDER BY BaseSalary DESC;
```

**🎯 Business Explanation**: Mathematical analysis of compensation data supports budgeting, tax planning, and performance evaluation. These calculations help HR understand the financial impact of salary decisions and project future compensation costs.

**🔧 Technical Breakdown**:

- **Basic arithmetic**: Addition, subtraction, multiplication, division
- **Advanced math functions**: POWER, LOG, SQRT, SIN, COS (Module 8, Lesson 4)
- **Rounding functions**: ROUND, CEILING, FLOOR (Module 8, Lesson 4)
- **Statistical functions**: ABS, percentile calculations
- **Financial modeling**: Compound interest, tax brackets
- **Modulo operations**: % operator for grouping

---

## 📈 **PART 6 SOLUTIONS: AGGREGATION & ANALYTICS MASTERY**

### **Task 6.1: Executive KPI Dashboard - SOLUTIONS**

#### **1. Departmental Performance Metrics - SOLUTION**

```sql
-- ================================
-- COMPREHENSIVE DEPARTMENTAL PERFORMANCE DASHBOARD
-- Module References: Module 9 (All Lessons - Grouping and Aggregating)
-- ================================

WITH DepartmentMetrics AS (
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        c.CompanyName,
        
        -- Employee counts and demographics
        COUNT(e.EmployeeID) as TotalEmployees,
        COUNT(CASE WHEN e.Gender = 'M' THEN 1 END) as MaleEmployees,
        COUNT(CASE WHEN e.Gender = 'F' THEN 1 END) as FemaleEmployees,
        COUNT(CASE WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) < 30 THEN 1 END) as EmployeesUnder30,
        COUNT(CASE WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) >= 30 AND DATEDIFF(YEAR, e.BirthDate, GETDATE()) < 50 THEN 1 END) as Employees30to50,
        COUNT(CASE WHEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) >= 50 THEN 1 END) as EmployeesOver50,
        
        -- Salary statistics
        AVG(e.BaseSalary) as AvgSalary,
        MIN(e.BaseSalary) as MinSalary,
        MAX(e.BaseSalary) as MaxSalary,
        STDEV(e.BaseSalary) as SalaryStdDev,
        SUM(e.BaseSalary) as TotalPayroll,
        
        -- Tenure analysis
        AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) as AvgYearsService,
        MIN(e.HireDate) as EarliestHireDate,
        MAX(e.HireDate) as LatestHireDate,
        
        -- Performance metrics
        AVG(pm.Achievement) as AvgPerformanceRating,
        COUNT(CASE WHEN pm.Achievement >= 4.5 THEN 1 END) as TopPerformers,
        COUNT(CASE WHEN pm.Achievement < 3.0 THEN 1 END) as UnderPerformers,
        
        -- Skills diversity
        COUNT(DISTINCT es.SkillID) as UniqueSkills,
        AVG(emp_skills.SkillCount) as AvgSkillsPerEmployee
        
    FROM Departments d
        INNER JOIN Companies c ON d.CompanyID = c.CompanyID
        LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
        LEFT JOIN (
            -- Get latest performance rating for each employee
            SELECT DISTINCT
                pm1.EmployeeID, 
                pm1.Achievement,
                ROW_NUMBER() OVER (PARTITION BY pm1.EmployeeID ORDER BY pm1.ReviewDate DESC) as rn
            FROM PerformanceMetrics pm1
        ) pm ON e.EmployeeID = pm.EmployeeID AND pm.rn = 1
        LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
        LEFT JOIN (
            -- Count skills per employee
            SELECT EmployeeID, COUNT(*) as SkillCount
            FROM EmployeeSkills
            GROUP BY EmployeeID
        ) emp_skills ON e.EmployeeID = emp_skills.EmployeeID
        
    GROUP BY d.DepartmentID, d.DepartmentName, c.CompanyName
    HAVING COUNT(e.EmployeeID) > 0  -- Only departments with employees
),

ProjectMetrics AS (
    SELECT 
        d.DepartmentID,
        COUNT(DISTINCT p.ProjectID) as ActiveProjects,
        SUM(p.Budget) as TotalProjectBudget,
        AVG(p.Budget) as AvgProjectBudget,
        COUNT(CASE WHEN p.ProjectStatus = 'Completed' THEN 1 END) as CompletedProjects,
        COUNT(CASE WHEN p.ProjectStatus = 'Active' THEN 1 END) as CurrentActiveProjects,
        COUNT(CASE WHEN p.ProjectStatus = 'On Hold' THEN 1 END) as ProjectsOnHold
    FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
        LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
        LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
    GROUP BY d.DepartmentID
)

-- Final comprehensive dashboard
SELECT 
    dm.DepartmentName,
    dm.CompanyName,
    
    -- Employee Statistics
    dm.TotalEmployees,
    FORMAT(dm.AvgSalary, 'C') as AverageSalary,
    FORMAT(dm.MinSalary, 'C') as MinimumSalary,
    FORMAT(dm.MaxSalary, 'C') as MaximumSalary,
    FORMAT(dm.TotalPayroll, 'C') as DepartmentPayroll,
    
    -- Diversity Metrics
    CAST(dm.FemaleEmployees * 100.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(5,1)) as FemalePercentage,
    CAST(dm.EmployeesUnder30 * 100.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(5,1)) as Under30Percentage,
    CAST(dm.Employees30to50 * 100.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(5,1)) as Age30to50Percentage,
    
    -- Performance Analytics
    CAST(dm.AvgPerformanceRating AS DECIMAL(3,1)) as AvgPerformance,
    CAST(dm.TopPerformers * 100.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(5,1)) as TopPerformerRate,
    CAST(dm.UnderPerformers * 100.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(5,1)) as UnderPerformerRate,
    
    -- Skills and Development
    dm.UniqueSkills as TotalSkills,
    CAST(dm.AvgSkillsPerEmployee AS DECIMAL(4,1)) as AvgSkillsPerEmployee,
    CAST(dm.UniqueSkills * 1.0 / NULLIF(dm.TotalEmployees, 0) AS DECIMAL(4,1)) as SkillDiversityIndex,
    
    -- Tenure Analysis  
    CAST(dm.AvgYearsService AS DECIMAL(4,1)) as AvgYearsService,
    DATEDIFF(YEAR, dm.EarliestHireDate, GETDATE()) as LongestTenure,
    DATEDIFF(MONTH, dm.LatestHireDate, GETDATE()) as NewestHireMonths,
    
    -- Project Portfolio
    ISNULL(pm.ActiveProjects, 0) as ActiveProjects,
    FORMAT(ISNULL(pm.TotalProjectBudget, 0), 'C') as ProjectBudgetManaged,
    FORMAT(ISNULL(pm.AvgProjectBudget, 0), 'C') as AvgProjectBudget,
    pm.CompletedProjects as CompletedProjects,
    pm.ProjectsOnHold as ProjectsOnHold,
    
    -- Efficiency Ratios
    CASE 
        WHEN pm.TotalProjectBudget IS NOT NULL AND dm.TotalPayroll > 0 
        THEN CAST(pm.TotalProjectBudget / dm.TotalPayroll AS DECIMAL(5,2))
        ELSE 0
    END as ProjectBudgetToPayrollRatio,
    
    CASE 
        WHEN dm.TotalEmployees > 0 AND pm.ActiveProjects IS NOT NULL
        THEN CAST(pm.ActiveProjects * 1.0 / dm.TotalEmployees AS DECIMAL(4,2))
        ELSE 0
    END as ProjectsPerEmployee,
    
    -- Department Health Score (composite metric)
    (
        -- Performance component (40%)
        CASE 
            WHEN dm.AvgPerformanceRating >= 4.0 THEN 40
            WHEN dm.AvgPerformanceRating >= 3.5 THEN 30
            WHEN dm.AvgPerformanceRating >= 3.0 THEN 20
            ELSE 10
        END +
        
        -- Retention component (30%) - based on tenure
        CASE 
            WHEN dm.AvgYearsService >= 5 THEN 30
            WHEN dm.AvgYearsService >= 3 THEN 20
            WHEN dm.AvgYearsService >= 1 THEN 15
            ELSE 10
        END +
        
        -- Skill diversity component (20%)
        CASE 
            WHEN dm.AvgSkillsPerEmployee >= 4 THEN 20
            WHEN dm.AvgSkillsPerEmployee >= 3 THEN 15
            WHEN dm.AvgSkillsPerEmployee >= 2 THEN 10
            ELSE 5
        END +
        
        -- Project engagement component (10%)
        CASE 
            WHEN pm.ActiveProjects >= dm.TotalEmployees * 0.5 THEN 10
            WHEN pm.ActiveProjects >= dm.TotalEmployees * 0.25 THEN 7
            ELSE 3
        END
    ) as DepartmentHealthScore,
    
    -- Strategic Recommendations
    CASE 
        WHEN dm.AvgPerformanceRating < 3.0 THEN 'Focus on Performance Improvement'
        WHEN dm.UnderPerformers * 100.0 / dm.TotalEmployees > 20 THEN 'Address Under-Performance'
        WHEN dm.AvgSkillsPerEmployee < 2 THEN 'Invest in Skills Development'
        WHEN pm.ActiveProjects < dm.TotalEmployees * 0.25 THEN 'Increase Project Engagement'
        WHEN dm.FemaleEmployees * 100.0 / dm.TotalEmployees < 30 THEN 'Improve Gender Diversity'
        ELSE 'Maintain Current Excellence'
    END as PrimaryRecommendation

FROM DepartmentMetrics dm
    LEFT JOIN ProjectMetrics pm ON dm.DepartmentID = pm.DepartmentID

ORDER BY 
    (
        CASE 
            WHEN dm.AvgPerformanceRating >= 4.0 THEN 40
            WHEN dm.AvgPerformanceRating >= 3.5 THEN 30
            WHEN dm.AvgPerformanceRating >= 3.0 THEN 20
            ELSE 10
        END +
        CASE 
            WHEN dm.AvgYearsService >= 5 THEN 30
            WHEN dm.AvgYearsService >= 3 THEN 20
            WHEN dm.AvgYearsService >= 1 THEN 15
            ELSE 10
        END +
        CASE 
            WHEN dm.AvgSkillsPerEmployee >= 4 THEN 20
            WHEN dm.AvgSkillsPerEmployee >= 3 THEN 15
            WHEN dm.AvgSkillsPerEmployee >= 2 THEN 10
            ELSE 5
        END +
        CASE 
            WHEN pm.ActiveProjects >= dm.TotalEmployees * 0.5 THEN 10
            WHEN pm.ActiveProjects >= dm.TotalEmployees * 0.25 THEN 7
            ELSE 3
        END
    ) DESC;
```

**🎯 Business Explanation**: This comprehensive departmental dashboard provides executives with key performance indicators for strategic decision-making. The health score combines multiple factors to quickly identify departments needing attention or investment.

**🔧 Technical Breakdown**:

- **Complex CTEs**: Multi-stage data preparation (advanced Module 9)
- **Multiple GROUP BY levels**: Department and project aggregations (Module 9, Lesson 2)
- **Conditional aggregation**: COUNT(CASE WHEN) pattern (Module 9, Lesson 1)
- **Statistical functions**: STDEV, percentiles, ratios (Module 9, Lesson 1)
- **Window functions**: ROW_NUMBER for latest performance data (Module 9)
- **HAVING clauses**: Filter aggregated results (Module 9, Lesson 3)
- **NULLIF function**: Prevent division by zero errors (Module 8)

**💡 Beginner Tips**:

- Use CTEs to break complex queries into logical steps
- NULLIF prevents division by zero in ratio calculations  
- Conditional aggregation is powerful for creating multiple metrics in one query
- Always consider what NULL values mean in your business context

---

## 🎯 **FINAL CAPSTONE SOLUTIONS: STRATEGIC BUSINESS INTELLIGENCE**

### **Task 8: CEO Executive Brief - COMPLETE SOLUTION**

```sql
-- ================================
-- STRATEGIC BUSINESS INTELLIGENCE FOR CEO EXECUTIVE BRIEF
-- Module References: ALL MODULES (1-9) - Complete Integration
-- ================================

-- Executive Summary: TechCorp's Strategic Position
WITH ExecutiveSummary AS (
    -- Overall company metrics
    SELECT 
        COUNT(DISTINCT e.EmployeeID) as TotalEmployees,
        COUNT(DISTINCT d.DepartmentID) as TotalDepartments,
        COUNT(DISTINCT p.ProjectID) as TotalProjects,
        COUNT(DISTINCT c.CompanyID) as TotalCompanies,
        
        -- Financial overview
        SUM(e.BaseSalary) as TotalAnnualPayroll,
        AVG(e.BaseSalary) as AvgEmployeeSalary,
        SUM(p.Budget) as TotalProjectBudgets,
        
        -- Performance overview
        AVG(pm.Achievement) as OverallPerformanceRating,
        COUNT(CASE WHEN pm.Achievement >= 4.0 THEN 1 END) * 100.0 / COUNT(pm.Achievement) as HighPerformerPercentage
        
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        INNER JOIN Companies c ON d.CompanyID = c.CompanyID
        LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
        LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
        LEFT JOIN (
            SELECT DISTINCT
                pm1.EmployeeID, 
                pm1.Achievement,
                ROW_NUMBER() OVER (PARTITION BY pm1.EmployeeID ORDER BY pm1.ReviewDate DESC) as rn
            FROM PerformanceMetrics pm1
        ) pm ON e.EmployeeID = pm.EmployeeID AND pm.rn = 1
    WHERE e.IsActive = 1
),

-- Competitive positioning analysis
CompetitiveAnalysis AS (
    SELECT 
        d.DepartmentName,
        
        -- Talent competitiveness
        AVG(e.BaseSalary) as AvgDeptSalary,
        COUNT(DISTINCT es.SkillID) as UniqueSkillsInDept,
        AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) as AvgTenure,
        
        -- Performance metrics
        AVG(pm.Achievement) as DeptPerformanceRating,
        
        -- Innovation indicators (projects per employee)
        COUNT(DISTINCT p.ProjectID) * 1.0 / COUNT(DISTINCT e.EmployeeID) as ProjectsPerEmployee,
        
        -- Skill diversity index
        COUNT(DISTINCT es.SkillID) * 1.0 / COUNT(DISTINCT e.EmployeeID) as SkillDiversityIndex
        
    FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
        LEFT JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
        LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
        LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
        LEFT JOIN (
            SELECT DISTINCT
                pm1.EmployeeID, 
                pm1.Achievement,
                ROW_NUMBER() OVER (PARTITION BY pm1.EmployeeID ORDER BY pm1.ReviewDate DESC) as rn
            FROM PerformanceMetrics pm1
        ) pm ON e.EmployeeID = pm.EmployeeID AND pm.rn = 1
    GROUP BY d.DepartmentID, d.DepartmentName
),

-- Risk and opportunity assessment
RiskOpportunityAnalysis AS (
    SELECT 
        -- Retention risks
        COUNT(CASE WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 4 
                    AND pm.Achievement >= 4.0 
                    AND e.BaseSalary < dept_avg.AvgSalary * 0.9 
              THEN 1 END) as HighRiskRetention,
              
        -- Growth opportunities (underutilized talent)
        COUNT(CASE WHEN pm.Achievement >= 4.0 
                    AND NOT EXISTS (
                        SELECT 1 FROM EmployeeProjects ep2 
                        INNER JOIN Projects p2 ON ep2.ProjectID = p2.ProjectID
                        WHERE ep2.EmployeeID = e.EmployeeID 
                        AND p2.ProjectStatus = 'Active'
                    )
              THEN 1 END) as UnderutilizedTalent,
              
        -- Skill gaps (departments with low skill diversity)
        COUNT(CASE WHEN dept_skills.SkillCount < 5 THEN 1 END) as DepartmentsWithSkillGaps,
        
        -- Revenue growth potential (projects in pipeline)
        SUM(CASE WHEN p.ProjectStatus = 'Planning' THEN p.Budget ELSE 0 END) as PipelineValue
        
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN (
            SELECT DepartmentID, AVG(BaseSalary) as AvgSalary
            FROM Employees 
            WHERE IsActive = 1
            GROUP BY DepartmentID
        ) dept_avg ON e.DepartmentID = dept_avg.DepartmentID
        LEFT JOIN (
            SELECT d2.DepartmentID, COUNT(DISTINCT es2.SkillID) as SkillCount
            FROM Departments d2
            LEFT JOIN Employees e2 ON d2.DepartmentID = e2.DepartmentID
            LEFT JOIN EmployeeSkills es2 ON e2.EmployeeID = es2.EmployeeID
            GROUP BY d2.DepartmentID
        ) dept_skills ON d.DepartmentID = dept_skills.DepartmentID
        LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
        LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID
        LEFT JOIN (
            SELECT DISTINCT
                pm1.EmployeeID, 
                pm1.Achievement,
                ROW_NUMBER() OVER (PARTITION BY pm1.EmployeeID ORDER BY pm1.ReviewDate DESC) as rn
            FROM PerformanceMetrics pm1
        ) pm ON e.EmployeeID = pm.EmployeeID AND pm.rn = 1
    WHERE e.IsActive = 1
)

-- Final Executive Brief Report
SELECT 
    '=== TECHCORP SOLUTIONS EXECUTIVE BRIEF ===' as ExecutiveBrief,
    GETDATE() as ReportDate,
    
    -- 1. CURRENT COMPETITIVE POSITION
    '--- COMPETITIVE POSITION ANALYSIS ---' as Section1,
    
    FORMAT(es.TotalAnnualPayroll, 'C') as TotalAnnualPayroll,
    es.TotalEmployees as WorkforceSize,
    es.TotalDepartments as OrganizationalSpan,
    es.TotalProjects as ActivePortfolio,
    FORMAT(es.AvgEmployeeSalary, 'C') as AverageCompensation,
    FORMAT(es.TotalProjectBudgets, 'C') as TotalProjectValue,
    CAST(es.OverallPerformanceRating AS DECIMAL(3,1)) as OverallPerformance,
    CAST(es.HighPerformerPercentage AS DECIMAL(5,1)) as HighPerformerRate,
    
    -- Competitive strength indicator
    CASE 
        WHEN es.OverallPerformanceRating >= 4.0 AND es.HighPerformerPercentage >= 60 
        THEN 'MARKET LEADING - Strong competitive position'
        WHEN es.OverallPerformanceRating >= 3.5 AND es.HighPerformerPercentage >= 40 
        THEN 'COMPETITIVE - Good market position'
        WHEN es.OverallPerformanceRating >= 3.0 AND es.HighPerformerPercentage >= 25 
        THEN 'MARKET AVERAGE - Room for improvement'
        ELSE 'BELOW MARKET - Significant improvement needed'
    END as CompetitivePosition,
    
    -- 2. OPPORTUNITIES AND RISKS
    '--- STRATEGIC OPPORTUNITIES & RISKS ---' as Section2,
    
    roa.HighRiskRetention as EmployeesAtRisk,
    roa.UnderutilizedTalent as UnderutilizedHighPerformers,
    roa.DepartmentsWithSkillGaps as DepartmentsNeedingSkills,
    FORMAT(roa.PipelineValue, 'C') as RevenueGrowthPipeline,
    
    -- Risk assessment
    CASE 
        WHEN roa.HighRiskRetention > es.TotalEmployees * 0.15 
        THEN 'HIGH RETENTION RISK - Immediate action required'
        WHEN roa.HighRiskRetention > es.TotalEmployees * 0.08 
        THEN 'MODERATE RETENTION RISK - Monitor closely'
        ELSE 'LOW RETENTION RISK - Maintain current programs'
    END as RetentionRiskLevel,
    
    -- Opportunity assessment
    CASE 
        WHEN roa.UnderutilizedTalent > 0 AND roa.PipelineValue > es.TotalAnnualPayroll * 2
        THEN 'HIGH GROWTH OPPORTUNITY - Scale operations with existing talent'
        WHEN roa.UnderutilizedTalent > 0 OR roa.PipelineValue > es.TotalAnnualPayroll
        THEN 'MODERATE GROWTH OPPORTUNITY - Strategic resource reallocation'
        ELSE 'STEADY STATE - Focus on operational excellence'
    END as GrowthOpportunity,
    
    -- 3. STRATEGIC PRIORITIES
    '--- RECOMMENDED STRATEGIC PRIORITIES ---' as Section3,
    
    -- Priority 1: Based on highest impact/urgency
    CASE 
        WHEN roa.HighRiskRetention > es.TotalEmployees * 0.15 
        THEN '1. URGENT: Implement retention strategy for high performers'
        WHEN es.OverallPerformanceRating < 3.5 
        THEN '1. URGENT: Launch performance improvement initiative'
        WHEN roa.DepartmentsWithSkillGaps > es.TotalDepartments * 0.5
        THEN '1. HIGH: Invest in skills development and training'
        ELSE '1. OPTIMIZE: Enhance operational efficiency and innovation'
    END as Priority1,
    
    -- Priority 2: Based on growth potential
    CASE 
        WHEN roa.UnderutilizedTalent > es.TotalEmployees * 0.1
        THEN '2. HIGH: Optimize talent utilization and project assignment'
        WHEN roa.PipelineValue > es.TotalAnnualPayroll * 1.5
        THEN '2. HIGH: Scale operations to capture pipeline opportunities'
        WHEN es.HighPerformerPercentage < 40
        THEN '2. MEDIUM: Develop high-potential employees'
        ELSE '2. MEDIUM: Expand market presence and client base'
    END as Priority2,
    
    -- Priority 3: Based on long-term sustainability
    CASE 
        WHEN roa.DepartmentsWithSkillGaps > 0
        THEN '3. MEDIUM: Build comprehensive skills portfolio'
        WHEN es.HighPerformerPercentage > 60
        THEN '3. MEDIUM: Maintain excellence and knowledge transfer'
        ELSE '3. LOW: Continue current strategic direction'
    END as Priority3,
    
    -- 4. SUCCESS METRICS
    '--- KEY SUCCESS METRICS TO TRACK ---' as Section4,
    
    -- Quarterly KPIs
    'Monthly: Retention rate of 4.0+ performers (Target: >95%)' as MonthlyKPI1,
    'Monthly: Project utilization rate (Target: 75-85%)' as MonthlyKPI2,
    'Quarterly: Overall performance rating (Target: >3.7)' as QuarterlyKPI1,
    'Quarterly: Revenue per employee growth (Target: 10% YoY)' as QuarterlyKPI2,
    'Annual: Skills diversity index improvement (Target: 15% YoY)' as AnnualKPI1,
    'Annual: Employee engagement scores (Target: >4.2/5.0)' as AnnualKPI2,
    
    -- Investment recommendations with ROI projections
    '--- INVESTMENT RECOMMENDATIONS ---' as Section5,
    
    CASE 
        WHEN roa.HighRiskRetention > 0
        THEN FORMAT(roa.HighRiskRetention * es.AvgEmployeeSalary * 0.15, 'C') + ' - Retention bonuses (ROI: 300%)'
        ELSE '$0 - No immediate retention investment needed'
    END as RetentionInvestment,
    
    CASE 
        WHEN roa.DepartmentsWithSkillGaps > 0
        THEN FORMAT(es.TotalEmployees * 2500, 'C') + ' - Skills development (ROI: 200% over 2 years)'
        ELSE '$0 - Skills portfolio adequate'
    END as SkillsInvestment,
    
    CASE 
        WHEN roa.UnderutilizedTalent > es.TotalEmployees * 0.05
        THEN FORMAT(50000, 'C') + ' - Project management tools (ROI: 150% in Year 1)'
        ELSE '$0 - Talent utilization optimized'
    END as OperationalInvestment,
    
    -- Expected outcomes timeline
    '--- EXPECTED OUTCOMES TIMELINE ---' as Section6,
    
    '30 Days: Retention conversations with at-risk high performers' as Outcome30Days,
    '90 Days: Skills assessment and development planning' as Outcome90Days,
    '6 Months: Measurable improvement in key performance metrics' as Outcome6Months,
    '12 Months: Market-leading performance and competitive advantage' as Outcome12Months

FROM ExecutiveSummary es
    CROSS JOIN RiskOpportunityAnalysis roa;

-- Supporting departmental analysis for deep-dive discussions
SELECT 
    '=== DEPARTMENTAL DEEP DIVE ANALYSIS ===' as DepartmentalAnalysis,
    ca.DepartmentName,
    FORMAT(ca.AvgDeptSalary, 'C') as AverageSalary,
    ca.UniqueSkillsInDept as SkillPortfolio,
    CAST(ca.AvgTenure AS DECIMAL(3,1)) as AverageTenure,
    CAST(ca.DeptPerformanceRating AS DECIMAL(3,1)) as PerformanceRating,
    CAST(ca.ProjectsPerEmployee AS DECIMAL(3,1)) as ProjectsPerEmployee,
    CAST(ca.SkillDiversityIndex AS DECIMAL(3,1)) as SkillDiversityIndex,
    
    -- Department health score
    (
        CASE WHEN ca.DeptPerformanceRating >= 4.0 THEN 25 WHEN ca.DeptPerformanceRating >= 3.5 THEN 20 ELSE 15 END +
        CASE WHEN ca.AvgTenure >= 3 THEN 25 WHEN ca.AvgTenure >= 2 THEN 20 ELSE 15 END +
        CASE WHEN ca.SkillDiversityIndex >= 3 THEN 25 WHEN ca.SkillDiversityIndex >= 2 THEN 20 ELSE 15 END +
        CASE WHEN ca.ProjectsPerEmployee >= 1 THEN 25 WHEN ca.ProjectsPerEmployee >= 0.5 THEN 20 ELSE 15 END
    ) as HealthScore,
    
    -- Strategic recommendation per department
    CASE 
        WHEN ca.DeptPerformanceRating < 3.5 THEN 'Performance Improvement Focus'
        WHEN ca.SkillDiversityIndex < 2 THEN 'Skills Development Investment'
        WHEN ca.ProjectsPerEmployee < 0.5 THEN 'Increase Project Engagement'
        WHEN ca.AvgTenure < 2 THEN 'Retention and Stability Focus'
        ELSE 'Maintain Excellence and Scale'
    END as DepartmentRecommendation

FROM CompetitiveAnalysis ca
ORDER BY 
    (
        CASE WHEN ca.DeptPerformanceRating >= 4.0 THEN 25 WHEN ca.DeptPerformanceRating >= 3.5 THEN 20 ELSE 15 END +
        CASE WHEN ca.AvgTenure >= 3 THEN 25 WHEN ca.AvgTenure >= 2 THEN 20 ELSE 15 END +
        CASE WHEN ca.SkillDiversityIndex >= 3 THEN 25 WHEN ca.SkillDiversityIndex >= 2 THEN 20 ELSE 15 END +
        CASE WHEN ca.ProjectsPerEmployee >= 1 THEN 25 WHEN ca.ProjectsPerEmployee >= 0.5 THEN 20 ELSE 15 END
    ) DESC;
```

**🎯 Business Explanation**: This executive brief provides the CEO with a comprehensive, data-driven view of TechCorp's strategic position, immediate risks, growth opportunities, and recommended actions. It combines operational metrics with strategic analysis to support board-level decision making.

**🔧 Technical Breakdown - Complete Module Integration**:

- **Module 1**: Database architecture understanding, SSMS usage
- **Module 2**: T-SQL fundamentals, logical operations, set theory
- **Module 3**: Complex SELECT statements, aliases, CASE expressions
- **Module 4**: Multi-table JOINs, self-joins, relationship analysis
- **Module 5**: Advanced filtering, sorting, TOP operations, NULL handling
- **Module 6**: Data type conversions, date calculations, formatting
- **Module 7**: Implied data modification recommendations
- **Module 8**: All function categories (string, date, math, logical, conversion)
- **Module 9**: Advanced grouping, aggregation, window functions, CTEs

**💡 Executive Summary of Learning Achievement**:

This comprehensive exercise demonstrates mastery of all SQL Server 2016 T-SQL concepts from Modules 1-9:

✅ **Technical Mastery**: Complex queries integrating all major T-SQL features  
✅ **Business Application**: Real-world scenarios solving actual business problems  
✅ **Strategic Thinking**: Data-driven insights supporting executive decision-making  
✅ **Professional Presentation**: Executive-ready reports and recommendations  

**🚀 Next Steps for Continued Learning**:

1. **Advanced Analytics**: Window functions, pivots, statistical analysis
2. **Performance Optimization**: Query plans, indexing strategies, optimization
3. **Database Design**: Normalization, constraints, advanced modeling
4. **Stored Procedures**: Automation, error handling, transaction management
5. **Business Intelligence**: SSRS, Power BI integration, data warehousing

---

**🎉 CONGRATULATIONS! You have successfully demonstrated comprehensive mastery of SQL Server 2016 T-SQL fundamentals. This exercise integrates everything learned across Modules 1-9 and prepares you for advanced database development and business intelligence roles.**