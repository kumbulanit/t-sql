# Lesson 3: Using Logical Functions - TechCorp Business Rules Engine

## 🎯 Master Business Logic with SQL (🔴 EXPERT LEVEL)

Welcome to the most sophisticated aspect of SQL Server functions! Logical functions allow you to implement complex business rules directly in your queries. You'll learn to handle conditional logic, decision trees, and automated business processes that make TechCorp's operations intelligent and efficient.

## 📖 TechCorp's Business Logic Challenges

As TechCorp Solutions has evolved into a sophisticated consulting firm, we need intelligent data processing:
- **Automated Decision Making**: Project approval workflows based on multiple criteria
- **Dynamic Pricing**: Client rates based on project complexity, risk, and market conditions
- **Performance Evaluation**: Multi-factor employee assessments with weighted criteria
- **Risk Assessment**: Intelligent project risk scoring using historical data patterns

## 🎓 Learning Progression: Advanced Business Intelligence

### Where You've Mastered (Previous Lessons):
✅ **String Functions** - Data cleaning and standardization  
✅ **Date/Time Functions** - Temporal calculations and analysis  
✅ **Mathematical Functions** - Financial computations and metrics  
✅ **Conversion Functions** - Data type transformations  

### What You'll Master Now (Logical Functions):
🔄 **Conditional Logic** - Complex IF-THEN-ELSE scenarios  
🔄 **Multi-Criteria Decisions** - Nested CASE expressions  
🔄 **Boolean Operations** - AND, OR, NOT logic in business rules  
🔄 **Risk Assessment** - Intelligent scoring systems  
🔄 **Automated Classification** - Smart categorization algorithms  

## Part 1: CASE Expressions - The Foundation of Business Logic 🧠

### 🎓 TUTORIAL: Why CASE Expressions Are Essential

CASE expressions are like having a programming language inside SQL:
- **Business Rules**: Implement complex decision logic
- **Data Classification**: Automatically categorize information
- **Dynamic Calculations**: Different formulas based on conditions
- **Report Formatting**: Conditional formatting and presentation

**Business Impact**: Smart logic = automated decisions = increased efficiency = higher profits

### Exercise 1.1: Basic CASE Logic (🔴 ADVANCED)

**Scenario**: TechCorp needs intelligent employee performance rating system based on multiple business criteria.

```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Lab 8.3.1: Simple CASE - Employee Performance Classification
-- Business scenario: Automated performance rating for annual reviews

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    e.HireDate,
    d.DepartmentName,
    jl.LevelName,
    
    -- Simple CASE for e.BaseSalary bands
    CASE 
        WHEN e.BaseSalary >= 150000 THEN 'Executive Level'
        WHEN e.BaseSalary >= 100000 THEN 'Senior Professional'
        WHEN e.BaseSalary >= 75000 THEN 'Mid-Level Professional'
        WHEN e.BaseSalary >= 50000 THEN 'Professional'
        ELSE 'Entry Level'
    END AS SalaryBand,
    
    -- CASE with date logic for service recognition
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Veteran (10+ years)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Senior (5-9 years)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Experienced (2-4 years)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 THEN 'Established (1-2 years)'
        ELSE 'New Hire (< 1 year)'
    END AS ServiceLevel,
    
    -- Business logic for bonus eligibility
    CASE 
        WHEN e.BaseSalary >= 100000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 
        THEN 'Eligible for Performance Bonus'
        WHEN e.BaseSalary >= 75000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 
        THEN 'Eligible for Standard Bonus'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 
        THEN 'Eligible for Recognition Bonus'
        ELSE 'Not Eligible - Probationary Period'
    END AS BonusEligibility,
    
    -- Department-specific logic
    CASE d.DepartmentName
        WHEN 'Engineering' THEN 
            CASE 
                WHEN e.BaseSalary > 120000 THEN 'Senior Engineer - Tech Lead Potential'
                WHEN e.BaseSalary > 90000 THEN 'Engineer - Project Lead Ready'
                ELSE 'Engineer - Individual Contributor'
            END
        WHEN 'Sales' THEN 
            CASE 
                WHEN e.BaseSalary > 100000 THEN 'Senior Sales - Enterprise Accounts'
                WHEN e.BaseSalary > 70000 THEN 'Sales Professional - Major Accounts'
                ELSE 'Sales Representative - Standard Accounts'
            END
        WHEN 'Marketing' THEN 'Marketing Professional'
        WHEN 'Human Resources' THEN 'HR Professional'
        WHEN 'Finance' THEN 'Finance Professional'
        ELSE 'General Staff'
    END AS RoleSpecialization,
    
    -- Combined criteria for promotion readiness
    CASE 
        WHEN e.BaseSalary < jl.MaxSalary * 0.8 
             AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 
             AND d.DepartmentName IN ('Engineering', 'Sales') 
        THEN 'Ready for Promotion'
        WHEN e.BaseSalary < jl.MaxSalary * 0.9 
             AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 
        THEN 'Consider for Promotion'
        WHEN e.BaseSalary >= jl.MaxSalary * 0.95 
        THEN 'Ready for Level Advancement'
        ELSE 'Continue Current Development'
    END AS PromotionIsActive
    
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
WHERE e.IsActive = 1
ORDER BY e.BaseSalary DESC, d.DepartmentName;

-- Lab 8.3.2: Searched CASE - Complex Project Risk Assessment
-- Business scenario: Intelligent project risk scoring for management decisions

SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    p.EstimatedHours,
    c.CompanyName AS ClientName,
    pt.TypeName AS ProjectType,
    
    -- Multi-factor risk assessment using searched CASE
    CASE 
        -- High risk scenarios
        WHEN p.Budget > 1000000 AND pt.ComplexityLevel >= 4 THEN 'HIGH RISK'
        WHEN p.Budget > 500000 AND c.CreditRating IN ('B', 'C', 'D') THEN 'HIGH RISK'
        WHEN pt.ComplexityLevel = 5 AND p.EstimatedHours > 5000 THEN 'HIGH RISK'
        WHEN DATEDIFF(DAY, p.StartDate, p.PlannedEndDate) > 365 THEN 'HIGH RISK'
        
        -- Medium risk scenarios
        WHEN p.Budget > 500000 AND pt.ComplexityLevel >= 3 THEN 'MEDIUM RISK'
        WHEN p.Budget > 250000 AND c.CreditRating = 'BBB' THEN 'MEDIUM RISK'
        WHEN pt.ComplexityLevel >= 4 THEN 'MEDIUM RISK'
        WHEN DATEDIFF(DAY, p.StartDate, p.PlannedEndDate) > 180 THEN 'MEDIUM RISK'
        
        -- Low risk scenarios
        WHEN p.Budget < 100000 AND pt.ComplexityLevel <= 2 THEN 'LOW RISK'
        WHEN c.CreditRating IN ('AAA', 'AA', 'A') AND pt.ComplexityLevel <= 3 THEN 'LOW RISK'
        
        -- Default
        ELSE 'STANDARD RISK'
    END AS RiskLevel,
    
    -- Approval workflow logic
    CASE 
        WHEN p.Budget > 1000000 THEN 'Requires VP Approval'
        WHEN p.Budget > 500000 THEN 'Requires Director Approval'
        WHEN p.Budget > 100000 THEN 'Requires Manager Approval'
        ELSE 'Standard Approval Process'
    END AS ApprovalRequired,
    
    -- Resource allocation recommendations
    CASE 
        WHEN pt.ComplexityLevel = 5 AND p.Budget > 500000 
        THEN 'Assign Senior Team Lead + Architect'
        WHEN pt.ComplexityLevel >= 4 
        THEN 'Assign Senior Team Lead'
        WHEN pt.ComplexityLevel >= 3 
        THEN 'Assign Experienced Team Lead'
        ELSE 'Standard Team Assignment'
    END AS RecommendedStaffing,
    
    -- Client management strategy
    CASE 
        WHEN c.AnnualRevenue > 100000000 THEN 'Executive Account Management'
        WHEN c.AnnualRevenue > 10000000 THEN 'Senior Account Management'
        WHEN c.CompanySize IN ('Large', 'Enterprise') THEN 'Standard Account Management'
        ELSE 'Basic Account Management'
    END AS AccountManagementLevel,
    
    -- Pricing strategy based on multiple factors
    CASE 
        WHEN c.CreditRating IN ('AAA', 'AA') AND p.Budget > 500000 
        THEN 'Premium Pricing - Low Risk Client'
        WHEN pt.ComplexityLevel >= 4 AND c.AnnualRevenue > 50000000 
        THEN 'Value Pricing - Complex High-Value'
        WHEN c.CompanySize = 'Startup' 
        THEN 'Competitive Pricing - Growth Client'
        WHEN pt.ComplexityLevel <= 2 
        THEN 'Standard Pricing - Simple Project'
        ELSE 'Market Pricing - Standard Terms'
    END AS PricingStrategy
    
FROM Projects p
    INNER JOIN Companies c ON p.CompanyID = c.CompanyID
    INNER JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
WHERE p.IsActive = 1
ORDER BY 
    CASE 
        WHEN p.Budget > 1000000 AND pt.ComplexityLevel >= 4 THEN 1
        WHEN p.Budget > 500000 AND c.CreditRating IN ('B', 'C', 'D') THEN 1
        ELSE 2
    END,
    p.Budget DESC;
```

### Exercise 1.2: Advanced Nested CASE Logic (🔴 EXPERT LEVEL)

**Scenario**: Implement TechCorp's sophisticated commission calculation system with multiple business rules.

```sql
-- Lab 8.3.3: Nested CASE - Advanced Commission Calculation System
-- Business scenario: Complex commission structure for sales team

WITH SalesMetrics AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS SalesRep,
        e.BaseSalary,
        e.Commission,
        d.DepartmentName,
        
        -- Calculate total project value for each sales rep
        SUM(p.Budget) AS TotalSalesValue,
        COUNT(p.ProjectID) AS ProjectCount,
        AVG(p.Budget) AS AvgProjectValue,
        
        -- Calculate project success metrics
        COUNT(CASE WHEN p.ActualEndDate <= p.PlannedEndDate THEN 1 END) AS OnTimeProjects,
        COUNT(CASE WHEN p.ActualEndDate IS NOT NULL THEN 1 END) AS CompletedProjects
        
    FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE d.DepartmentName = 'Sales' 
        AND e.IsActive = 1
        AND p.CreatedDate >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, e.Commission, d.DepartmentName
)
SELECT 
    e.EmployeeID,
    SalesRep,
    e.BaseSalary,
    Commission AS BaseCommissionPercent,
    FORMAT(TotalSalesValue, 'C') AS TotalSalesValue,
    ProjectCount,
    FORMAT(AvgProjectValue, 'C') AS AvgProjectValue,
    
    -- Nested CASE for commission tier calculation
    CASE 
        -- Tier 1: High performers
        WHEN TotalSalesValue >= 2000000 THEN
            CASE 
                WHEN AvgProjectValue >= 300000 THEN 'Tier 1A - Elite Enterprise Sales'
                WHEN ProjectCount >= 10 THEN 'Tier 1B - High Volume Sales'
                ELSE 'Tier 1C - High Value Sales'
            END
        
        -- Tier 2: Good performers  
        WHEN TotalSalesValue >= 1000000 THEN
            CASE 
                WHEN AvgProjectValue >= 200000 THEN 'Tier 2A - Enterprise Sales'
                WHEN ProjectCount >= 8 THEN 'Tier 2B - Volume Sales'
                ELSE 'Tier 2C - Solid Performance'
            END
        
        -- Tier 3: Standard performers
        WHEN TotalSalesValue >= 500000 THEN
            CASE 
                WHEN AvgProjectValue >= 100000 THEN 'Tier 3A - Mid-Market Sales'
                WHEN ProjectCount >= 5 THEN 'Tier 3B - Active Sales'
                ELSE 'Tier 3C - Standard Performance'
            END
        
        -- Development tier
        ELSE 'Development Tier - Building Pipeline'
    END AS CommissionTier,
    
    -- Calculate bonus commission rate using nested logic
    CASE 
        WHEN TotalSalesValue >= 2000000 THEN
            CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.9 
                THEN Commission + 3.0  -- Base + 3% bonus for on-time delivery
                WHEN AvgProjectValue >= 300000 
                THEN Commission + 2.5  -- Base + 2.5% for high-value deals
                ELSE Commission + 2.0  -- Base + 2% for volume
            END
        
        WHEN TotalSalesValue >= 1000000 THEN
            CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.85 
                THEN Commission + 2.0
                WHEN AvgProjectValue >= 200000 
                THEN Commission + 1.5
                ELSE Commission + 1.0
            END
        
        WHEN TotalSalesValue >= 500000 THEN
            CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.8 
                THEN Commission + 1.0
                ELSE Commission + 0.5
            END
        
        ELSE Commission  -- Base commission only
    END AS FinalCommissionRate,
    
    -- Calculate actual commission earnings
    CASE 
        WHEN TotalSalesValue >= 2000000 THEN
            TotalSalesValue * 
            (CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.9 
                THEN Commission + 3.0
                WHEN AvgProjectValue >= 300000 
                THEN Commission + 2.5
                ELSE Commission + 2.0
            END) / 100.0
        
        WHEN TotalSalesValue >= 1000000 THEN
            TotalSalesValue * 
            (CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.85 
                THEN Commission + 2.0
                WHEN AvgProjectValue >= 200000 
                THEN Commission + 1.5
                ELSE Commission + 1.0
            END) / 100.0
        
        WHEN TotalSalesValue >= 500000 THEN
            TotalSalesValue * 
            (CASE 
                WHEN CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.8 
                THEN Commission + 1.0
                ELSE Commission + 0.5
            END) / 100.0
        
        ELSE TotalSalesValue * Commission / 100.0
    END AS CommissionEarnings,
    
    -- Performance rating using nested conditions
    CASE 
        WHEN TotalSalesValue >= 2000000 AND 
             CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) >= 0.9 
        THEN 'Outstanding Performance'
        
        WHEN TotalSalesValue >= 1500000 OR 
             (TotalSalesValue >= 1000000 AND AvgProjectValue >= 250000) 
        THEN 'Excellent Performance'
        
        WHEN TotalSalesValue >= 1000000 OR 
             (TotalSalesValue >= 750000 AND ProjectCount >= 8) 
        THEN 'Good Performance'
        
        WHEN TotalSalesValue >= 500000 
        THEN 'Satisfactory Performance'
        
        ELSE 'Needs Improvement'
    END AS PerformanceRating,
    
    -- Success rate calculation
    FORMAT(
        CAST(OnTimeProjects AS FLOAT) / NULLIF(CompletedProjects, 0) * 100, 
        'N1'
    ) + '%' AS OnTimeDeliveryRate
    
FROM SalesMetrics
ORDER BY TotalSalesValue DESC;
```

## Part 2: IIF Function - Simplified Conditional Logic ⚡

### 🎓 TUTORIAL: IIF - The Quick Decision Function

IIF (Immediate IF) is SQL Server's simplified conditional function:
- **Quick Decisions**: Simple true/false logic
- **Inline Conditions**: Replace simple CASE expressions
- **Readable Code**: Clear, concise conditional logic
- **Performance**: Optimized for simple conditions

### Exercise 2.1: IIF for Business Rules (🔴 ADVANCED)

**Scenario**: Implement quick business decisions throughout TechCorp's operations.

```sql
-- Lab 8.3.4: IIF Function - Quick Business Decisions
-- Business scenario: Streamlined conditional logic for operational efficiency

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    e.HireDate,
    e.TerminationDate,
    
    -- Simple active/inactive status
    IIF(e.IsActive = 1, 'Active Employee', 'Former Employee') AS EmploymentIsActive,
    
    -- e.BaseSalary level indicator
    IIF(e.BaseSalary >= 100000, 'Senior Level', 'Junior-Mid Level') AS SalaryLevel,
    
    -- Years of service category
    IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5, 'Veteran', 'Newer Employee') AS ServiceCategory,
    
    -- Bonus eligibility
    IIF(e.BaseSalary >= 75000 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1, 
        'Bonus Eligible', 'Not Eligible') AS BonusIsActive,
    
    -- Overtime eligibility (typically non-exempt employees under certain e.BaseSalary threshold)
    IIF(e.BaseSalary < 50000, 'Overtime Eligible', 'Exempt from Overtime') AS OvertimeIsActive,
    
    -- Performance review frequency
    IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1, 'Quarterly Reviews', 'Annual Reviews') AS ReviewFrequency,
    
    -- Training budget allocation
    IIF(e.BaseSalary >= 80000, '$3,000 Training Budget', '$1,500 Training Budget') AS TrainingBudget,
    
    -- Nested IIFs for more complex logic
    IIF(e.BaseSalary >= 120000, 
        'Executive Parking',
        IIF(e.BaseSalary >= 80000, 'Reserved Parking', 'General Parking')
    ) AS ParkingAssignment,
    
    -- Manager flag based on job level
    IIF(EXISTS(SELECT 1 FROM Employees e e2 WHERE e2.DirectManagerID = e.EmployeeID AND e2.IsActive = 1),
        'Manager', 'Individual Contributor') AS ManagementRole,
    
    -- Calculate working years (handling current employees vs. terminated)
    IIF(e.TerminationDate IS NULL,
        DATEDIFF(YEAR, e.HireDate, GETDATE()),
        DATEDIFF(YEAR, e.HireDate, e.TerminationDate)
    ) AS YearsOfService
    
FROM Employees e
ORDER BY e.BaseSalary DESC;

-- Lab 8.3.5: IIF in Aggregations - Business Metrics
-- Business scenario: Quick conditional aggregations for dashboards

SELECT d.DepartmentName,
    COUNT(*) AS TotalEmployees,
    
    -- Count employees by e.BaseSalary level using IIF
    COUNT(IIF(e.BaseSalary >= 100000, 1, NULL)) AS HighSalaryCount,
    COUNT(IIF(e.BaseSalary < 100000, 1, NULL)) AS StandardSalaryCount,
    
    -- Calculate percentages
    FORMAT(
        COUNT(IIF(e.BaseSalary >= 100000, 1, NULL)) * 100.0 / COUNT(*), 
        'N1'
    ) + '%' AS HighSalaryPercentage,
    
    -- e.BaseSalary statistics with conditional logic
    AVG(IIF(e.BaseSalary >= 100000, e.BaseSalary, NULL)) AS AvgHighSalary,
    AVG(IIF(e.BaseSalary < 100000, e.BaseSalary, NULL)) AS AvgStandardSalary,
    
    -- Experience-based counts
    COUNT(IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5, 1, NULL)) AS VeteranEmployees,
    COUNT(IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) < 5, 1, NULL)) AS NewerEmployees,
    
    -- Gender distribution (if available)
    COUNT(IIF(e.Gender = 'M', 1, NULL)) AS MaleEmployees,
    COUNT(IIF(e.Gender = 'F', 1, NULL)) AS FemaleEmployees,
    COUNT(IIF(e.Gender IS NULL OR e.Gender = 'O', 1, NULL)) AS OtherUnknownGender,
    
    -- Manager vs Individual Contributor count
    COUNT(IIF(EXISTS(SELECT 1 FROM Employees e e2 WHERE e2.DirectManagerID = e.EmployeeID), 1, NULL)) AS ManagerCount,
    COUNT(IIF(NOT EXISTS(SELECT 1 FROM Employees e e2 WHERE e2.DirectManagerID = e.EmployeeID), 1, NULL)) AS ICCount,
    
    -- Performance indicators
    FORMAT(AVG(e.BaseSalary), 'C') AS AvgDepartmentSalary,
    IIF(AVG(e.BaseSalary) > 80000, 'High-Value Department', 'Standard Department') AS DepartmentCategory
    
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AVG(e.BaseSalary) DESC;
```

## Part 3: CHOOSE and Advanced Logical Functions 🎲

### 🎓 TUTORIAL: CHOOSE Function for Dynamic Selection

CHOOSE function selects from a list of values based on an index:
- **Dynamic Content**: Select different values based on calculations
- **Lookup Alternative**: Replace complex CASE expressions
- **Array-like Behavior**: SQL Server's closest thing to arrays
- **Business Applications**: Dynamic labels, categories, formatting

### Exercise 3.1: CHOOSE for Business Intelligence (🔴 EXPERT LEVEL)

**Scenario**: Create dynamic business intelligence reports with intelligent categorization.

```sql
-- Lab 8.3.6: CHOOSE Function - Dynamic Business Intelligence
-- Business scenario: Smart categorization and dynamic reporting

SELECT 
    p.ProjectID,
    p.ProjectName,
    p.Budget,
    pt.ComplexityLevel,
    p.IsActive,
    
    -- Use CHOOSE to convert numeric complexity to descriptive text
    CHOOSE(pt.ComplexityLevel,
        'Simple - Basic Requirements',
        'Moderate - Standard Complexity', 
        'Advanced - Complex Integration',
        'Expert - High Technical Complexity',
        'Master - Cutting-Edge Technology'
    ) AS ComplexityDescription,
    
    -- Dynamic project category based on budget ranges
    CHOOSE(
        CASE 
            WHEN p.Budget < 50000 THEN 1
            WHEN p.Budget < 150000 THEN 2
            WHEN p.Budget < 500000 THEN 3
            WHEN p.Budget < 1000000 THEN 4
            ELSE 5
        END,
        'Small Project',
        'Medium Project',
        'Large Project', 
        'Enterprise Project',
        'Strategic Initiative'
    ) AS ProjectCategory,
    
    -- Dynamic risk assessment messages
    CHOOSE(
        CASE 
            WHEN p.Budget > 500000 AND pt.ComplexityLevel >= 4 THEN 1
            WHEN p.Budget > 250000 AND pt.ComplexityLevel >= 3 THEN 2
            WHEN pt.ComplexityLevel >= 4 THEN 3
            ELSE 4
        END,
        'HIGH RISK - Executive oversight required',
        'MEDIUM RISK - Manager approval needed',
        'ELEVATED RISK - Additional review recommended',
        'STANDARD RISK - Normal process'
    ) AS RiskAssessment,
    
    -- Dynamic status indicators with colors (for reporting)
    CHOOSE(
        CASE p.IsActive
            WHEN 'Planning' THEN 1
            WHEN 'Active' THEN 2
            WHEN 'On Hold' THEN 3
            WHEN 'Completed' THEN 4
            WHEN 'Cancelled' THEN 5
            ELSE 6
        END,
        '🔵 Planning Phase',
        '🟢 Active Development',
        '🟡 On Hold',
        '✅ Successfully Completed',
        '❌ Cancelled',
        '❓ IsActive Unknown'
    ) AS IsActiveIndicator,
    
    -- Dynamic team size recommendations
    CHOOSE(
        CASE 
            WHEN pt.ComplexityLevel <= 2 AND p.Budget < 100000 THEN 1
            WHEN pt.ComplexityLevel <= 3 AND p.Budget < 300000 THEN 2
            WHEN pt.ComplexityLevel <= 4 AND p.Budget < 750000 THEN 3
            ELSE 4
        END,
        'Small Team (2-4 people)',
        'Medium Team (5-8 people)',
        'Large Team (9-15 people)',
        'Enterprise Team (16+ people)'
    ) AS RecommendedTeamSize,
    
    -- Dynamic client communication frequency
    CHOOSE(
        CASE 
            WHEN p.Budget >= 1000000 THEN 1
            WHEN p.Budget >= 500000 THEN 2
            WHEN p.Budget >= 100000 THEN 3
            ELSE 4
        END,
        'Daily Updates - Premium Service',
        'Bi-weekly Updates - Priority Service',
        'Weekly Updates - Standard Service',
        'Monthly Updates - Basic Service'
    ) AS CommunicationLevel
    
FROM Projects p
    INNER JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
WHERE p.IsActive = 1
ORDER BY p.Budget DESC;

-- Lab 8.3.7: Advanced Logical Combinations
-- Business scenario: Complex business rule engine for automated decision making

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    e.HireDate,
    d.DepartmentName,
    jl.LevelName,
    
    -- Complex eligibility determination using multiple logical functions
    CASE 
        WHEN IIF(e.BaseSalary >= 100000, 1, 0) = 1 
             AND IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3, 1, 0) = 1 
             AND d.DepartmentName IN ('Engineering', 'Sales')
        THEN 'Eligible for Leadership Program'
        
        WHEN IIF(e.BaseSalary >= 75000, 1, 0) = 1 
             AND IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2, 1, 0) = 1
        THEN 'Eligible for Senior Professional Track'
        
        WHEN IIF(DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1, 1, 0) = 1
        THEN 'Eligible for Professional Development'
        
        ELSE 'Focus on Core Skills Development'
    END AS DevelopmentTrack,
    
    -- Combine CHOOSE with CASE for dynamic vacation entitlement
    CHOOSE(
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 5
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 4
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 THEN 3
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 THEN 2
            ELSE 1
        END,
        '2 weeks vacation (New Employee)',
        '3 weeks vacation (1+ years)',
        '4 weeks vacation (3+ years)',
        '5 weeks vacation (5+ years)',
        '6 weeks vacation (10+ years)'
    ) AS VacationEntitlement,
    
    -- Stock option eligibility (complex business rules)
    CASE 
        WHEN jl.AuthorityLevel >= 8 THEN 'Executive Stock Package'
        WHEN jl.AuthorityLevel >= 6 AND e.BaseSalary >= 120000 THEN 'Senior Stock Package'
        WHEN jl.AuthorityLevel >= 4 AND DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Standard Stock Package'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 1 THEN 'Basic Stock Package'
        ELSE 'Not Eligible (Probationary)'
    END AS StockOptionLevel,
    
    -- Performance bonus calculation tier
    CHOOSE(
        CASE 
            WHEN e.BaseSalary >= 150000 AND jl.AuthorityLevel >= 7 THEN 1
            WHEN e.BaseSalary >= 100000 AND jl.AuthorityLevel >= 5 THEN 2
            WHEN e.BaseSalary >= 75000 AND jl.AuthorityLevel >= 3 THEN 3
            WHEN e.BaseSalary >= 50000 THEN 4
            ELSE 5
        END,
        'Executive Tier - Up to 50% of e.BaseSalary',
        'Senior Tier - Up to 25% of e.BaseSalary',
        'Professional Tier - Up to 15% of e.BaseSalary',
        'Standard Tier - Up to 10% of e.BaseSalary',
        'Entry Tier - Up to 5% of e.BaseSalary'
    ) AS BonusTier
    
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN JobLevels jl ON e.JobLevelID = jl.JobLevelID
WHERE e.IsActive = 1
ORDER BY jl.AuthorityLevel DESC, e.BaseSalary DESC;
```

## 🎯 Business Logic Mastery Summary

### Advanced Logical Functions You've Mastered:

1. **CASE Expressions**:
   - Simple CASE for straightforward conditions
   - Searched CASE for complex business logic
   - Nested CASE for sophisticated decision trees

2. **IIF Function**:
   - Quick true/false decisions
   - Simplified conditional logic
   - Performance-optimized simple conditions

3. **CHOOSE Function**:
   - Dynamic value selection
   - Array-like behavior in SQL
   - Complex categorization systems

4. **Advanced Combinations**:
   - Multiple functions working together
   - Complex business rule engines
   - Automated decision-making systems

### Real-World Business Applications:

- **Automated Decision Making**: Project approvals, employee classifications
- **Dynamic Pricing**: Intelligent pricing strategies based on multiple factors
- **Performance Management**: Sophisticated rating and bonus systems
- **Risk Assessment**: Multi-factor risk scoring algorithms
- **Business Intelligence**: Smart categorization and reporting

### Professional Skills Achieved:

- **Business Rules Implementation**: Translate complex business logic into SQL
- **Decision Tree Creation**: Build sophisticated conditional logic systems
- **Performance Optimization**: Choose the right logical function for each scenario
- **Maintainable Code**: Write clear, understandable conditional logic
- **Automated Processing**: Create self-managing business systems

---

*You've now mastered the logical functions that power intelligent business systems. These skills enable you to create sophisticated, automated decision-making processes that are essential in modern enterprise applications!*

## Next Steps:
Continue to Lesson 4 where you'll master NULL handling - the final piece of the advanced functions puzzle that ensures data quality and robust business logic in real-world scenarios.

*Welcome to the ranks of expert SQL developers who can implement complex business intelligence directly in the database!* 🧠⚡