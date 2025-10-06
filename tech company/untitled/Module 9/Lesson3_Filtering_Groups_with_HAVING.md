# Lesson 3: Filtering Groups with HAVING - TechCorp Strategic Filtering Engine

## 🎯 Master Advanced Group Filtering for Precision Business Intelligence (🔴 EXPERT LEVEL)

Welcome to the final piece of the business intelligence puzzle! The HAVING clause allows you to apply sophisticated filters to your grouped data, creating laser-focused insights that drive strategic decisions. You'll learn to identify high-value client segments, underperforming business units, and emerging market opportunities with surgical precision.

## 📖 TechCorp's Strategic Filtering Requirements

As TechCorp Solutions operates at enterprise scale, strategic focus becomes critical:

- **High-Value Segment Identification**: Focus on clients and markets that drive profitability
- **Performance Threshold Analysis**: Identify departments and teams exceeding targets
- **Risk Management**: Flag underperforming segments before they become problems
- **Resource Optimization**: Allocate resources to segments with proven returns
- **Strategic Opportunity Discovery**: Find emerging markets and growth opportunities
- **Executive Exception Reporting**: Surface only the most critical insights for leadership

## 🎓 Learning Progression: Precision Intelligence Mastery

### Where You've Mastered (Previous Lessons)

✅ **Module 1-8**: Complete SQL foundation from basics to advanced functions  
✅ **Module 9 Lesson 1**: Core aggregate functions for business metrics  
✅ **Module 9 Lesson 2**: GROUP BY clauses for dimensional analysis  

### What You'll Master Now (HAVING Clause Precision)

🔄 **Strategic Filtering** - HAVING with complex business conditions  
🔄 **Performance Thresholds** - Identify top and bottom performers  
🔄 **Multi-Criteria Filtering** - Complex business rule applications  
🔄 **Exception Reporting** - Surface critical insights for leadership  
🔄 **Competitive Intelligence** - Focus on market leaders and opportunities  

## Part 1: Basic HAVING Clause - Strategic Focus 🎯

### 🎓 TUTORIAL: Why HAVING Is Critical for Executive Intelligence

The HAVING clause transforms your GROUP BY analysis from comprehensive reporting to strategic intelligence:

- **Executive Focus**: Show only groups that meet strategic criteria
- **Performance Standards**: Apply business thresholds to identify winners and losers
- **Resource Prioritization**: Focus on segments that meet minimum investment criteria
- **Risk Management**: Surface groups that fall below acceptable performance levels
- **Opportunity Identification**: Find emerging segments that exceed growth thresholds

**Business Impact**: Strategic filtering = focused insights = targeted actions = optimized results

### Exercise 1.1: High-Performance Department Identification (🔴 ADVANCED)

**Scenario**: Identify TechCorp departments that exceed performance thresholds for recognition, investment, and best practice sharing.

```sql
-- Connect to TechCorp database
USE TechCorpDB;
GO

-- Lab 9.3.1: High-Performance Department Analysis
-- Business scenario: Identify departments exceeding strategic performance thresholds

SELECT 
    d.DepartmentName,
    
    -- EMPLOYEE METRICS
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
    COUNT(DISTINCT CASE WHEN e.IsActive = 1 THEN e.EmployeeID END) AS ActiveEmployees,
    
    -- FINANCIAL PERFORMANCE
    FORMAT(SUM(e.BaseSalary), 'C0') AS TotalPayroll,
    FORMAT(AVG(e.BaseSalary), 'C0') AS AvgSalary,
    
    -- PROJECT PERFORMANCE
    COUNT(DISTINCT p.ProjectID) AS ProjectsManaged,
    FORMAT(SUM(p.Budget), 'C0') AS TotalRevenue,
    FORMAT(AVG(p.Budget), 'C0') AS AvgProjectValue,
    
    -- PROFITABILITY METRICS
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS DepartmentProfit,
    
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS ProfitMargin,
    
    -- EFFICIENCY METRICS
    FORMAT(
        SUM(p.Budget) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0), 
        'C0'
    ) AS RevenuePerEmployee,
    
    FORMAT(
        (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0), 
        'C0'
    ) AS ProfitPerEmployee,
    
    -- DELIVERY PERFORMANCE
    COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END) AS CompletedProjects,
    COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) AS OnTimeProjects,
    
    FORMAT(
        COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS OnTimeDeliveryRate,
    
    -- STRATEGIC CLASSIFICATION
    CASE 
        WHEN SUM(p.Budget) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0) >= 2000000 
             AND COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
                 NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 90
        THEN '🌟 ELITE PERFORMER - Revenue + Delivery Excellence'
        WHEN (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0 / NULLIF(SUM(p.Budget), 0) >= 30
        THEN '💎 PROFIT CHAMPION - Exceptional Margins'
        WHEN SUM(p.Budget) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0) >= 1500000
        THEN '🚀 REVENUE LEADER - High Per-Employee Performance'
        ELSE '📈 SOLID PERFORMER - Meeting Standards'
    END AS PerformanceClassification,
    
    -- INVESTMENT RECOMMENDATIONS
    CASE 
        WHEN SUM(p.Budget) / NULLIF(COUNT(DISTINCT e.EmployeeID), 0) >= 2000000 
        THEN 'EXPAND: Increase headcount and capacity immediately'
        WHEN (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0 / NULLIF(SUM(p.Budget), 0) >= 30
        THEN 'SCALE: Replicate successful model across organization'
        WHEN COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
             NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 85
        THEN 'STUDY: Document best practices for organizational learning'
        ELSE 'MAINTAIN: Continue current performance level'
    END AS InvestmentRecommendation

FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
WHERE d.IsActive = 1 
    AND p.IsActive = 1
    AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY d.DepartmentID, d.DepartmentName

-- STRATEGIC HAVING CLAUSES for high-performance identification
HAVING 
    -- Minimum scale requirement
    COUNT(DISTINCT e.EmployeeID) >= 5
    AND COUNT(DISTINCT p.ProjectID) >= 10
    
    -- Performance excellence thresholds (ANY of these conditions)
    AND (
        -- Revenue per employee exceeds $1.5M
        SUM(p.Budget) / COUNT(DISTINCT e.EmployeeID) >= 1500000
        
        -- OR profit margin exceeds 25%
        OR ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) >= 25
        
        -- OR on-time delivery rate exceeds 85%
        OR COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
           NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 85
        
        -- OR total revenue exceeds $10M
        OR SUM(p.Budget) >= 10000000
    )

ORDER BY SUM(p.Budget) / COUNT(DISTINCT e.EmployeeID) DESC;

-- Lab 9.3.2: Premium Client Segment Analysis
-- Business scenario: Identify high-value clients for executive account management

SELECT 
    c.CompanyName,
    c.Industry,
    c.CompanySize,
    c.AnnualRevenue,
    
    -- CLIENT RELATIONSHIP METRICS
    COUNT(DISTINCT p.ProjectID) AS TotalProjects,
    COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END) AS CompletedProjects,
    COUNT(CASE WHEN p.Status = 'Active' THEN 1 END) AS ActiveProjects,
    
    -- FINANCIAL VALUE
    FORMAT(SUM(p.Budget), 'C0') AS TotalClientValue,
    FORMAT(AVG(p.Budget), 'C0') AS AvgProjectValue,
    FORMAT(MAX(p.Budget), 'C0') AS LargestProject,
    
    -- PROFITABILITY
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS ClientProfitability,
    
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS ClientProfitMargin,
    
    -- RELATIONSHIP DURATION AND FREQUENCY
    DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE()))) AS RelationshipMonths,
    
    FORMAT(
        COUNT(p.ProjectID) * 12.0 / 
        NULLIF(DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE()))), 0), 
        'N1'
    ) AS ProjectsPerYear,
    
    -- DELIVERY PERFORMANCE FOR CLIENT
    FORMAT(
        COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS ClientOnTimeRate,
    
    -- CLIENT RISK ASSESSMENT
    c.CreditRating,
    
    -- STRATEGIC CLIENT CLASSIFICATION
    CASE 
        WHEN SUM(p.Budget) >= 10000000 
             AND COUNT(p.ProjectID) >= 15
             AND COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
                 NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 85
        THEN '👑 STRATEGIC ENTERPRISE CLIENT - Crown Jewel'
        WHEN SUM(p.Budget) >= 5000000 
             AND (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0 / NULLIF(SUM(p.Budget), 0) >= 25
        THEN '💎 PREMIUM CLIENT - High Value & Profitable'
        WHEN COUNT(p.ProjectID) >= 10 
             AND AVG(p.Budget) >= 400000
        THEN '🏆 MAJOR CLIENT - Consistent High-Value Work'
        WHEN SUM(p.Budget) >= 2000000
        THEN '🎯 KEY CLIENT - Significant Relationship'
        ELSE '📈 GROWTH CLIENT - Expanding Relationship'
    END AS ClientSegment,
    
    -- ACCOUNT MANAGEMENT STRATEGY
    CASE 
        WHEN SUM(p.Budget) >= 10000000 THEN 'Dedicated C-Suite Relationship + Account Team'
        WHEN SUM(p.Budget) >= 5000000 THEN 'Senior Partner + Dedicated Account Manager'
        WHEN SUM(p.Budget) >= 2000000 THEN 'Partner-Level Account Management'
        WHEN AVG(p.Budget) >= 500000 THEN 'Senior Account Manager'
        ELSE 'Standard Account Management'
    END AS RecommendedAccountManagement,
    
    -- EXPANSION OPPORTUNITIES
    CASE 
        WHEN COUNT(p.ProjectID) * 12.0 / 
             NULLIF(DATEDIFF(MONTH, MIN(p.StartDate), MAX(ISNULL(p.ActualEndDate, GETDATE()))), 0) >= 6
             AND c.AnnualRevenue >= 100000000
        THEN 'HIGH POTENTIAL: Frequent projects + Large enterprise = Expansion opportunity'
        WHEN (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0 / NULLIF(SUM(p.Budget), 0) >= 30
             AND COUNT(p.ProjectID) < 5
        THEN 'UNTAPPED VALUE: High margins suggest pricing power for more services'
        WHEN COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
             NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 90
        THEN 'SHOWCASE CLIENT: Excellent delivery record = Reference for new business'
        ELSE 'MAINTAIN: Continue current relationship strategy'
    END AS ExpansionStrategy

FROM Companies c
    INNER JOIN Projects p ON c.CompanyID = p.CompanyID
WHERE c.IsActive = 1 
    AND p.IsActive = 1
    AND p.StartDate >= DATEADD(YEAR, -3, GETDATE())
GROUP BY 
    c.CompanyID, c.CompanyName, c.Industry, c.CompanySize, c.AnnualRevenue, c.CreditRating

-- STRATEGIC HAVING CLAUSES for premium client identification
HAVING 
    -- Minimum relationship threshold
    COUNT(p.ProjectID) >= 3
    
    -- High-value criteria (MUST meet at least one)
    AND (
        -- Total client value exceeds $2M
        SUM(p.Budget) >= 2000000
        
        -- OR average project value exceeds $400K
        OR AVG(p.Budget) >= 400000
        
        -- OR client has enterprise-level annual revenue
        OR c.AnnualRevenue >= 100000000
        
        -- OR exceptional profitability (30%+ margin)
        OR ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) >= 30
    )
    
    -- Quality relationship requirement
    AND COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) >= 70

ORDER BY SUM(p.Budget) DESC, AVG(p.Budget) DESC;
```

### Exercise 1.2: Underperforming Segment Identification (🔴 ADVANCED)

**Scenario**: Identify underperforming business segments that require immediate attention, process improvement, or strategic repositioning.

```sql
-- Lab 9.3.3: Underperforming Segment Analysis
-- Business scenario: Early warning system for business segments requiring intervention

SELECT 
    ISNULL(c.Industry, 'Unknown Industry') AS Industry,
    pt.TypeName AS ServiceLine,
    pt.ComplexityLevel,
    
    -- PERFORMANCE METRICS
    COUNT(p.ProjectID) AS TotalProjects,
    COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END) AS CompletedProjects,
    COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) AS CancelledProjects,
    
    -- FINANCIAL PERFORMANCE
    FORMAT(SUM(p.Budget), 'C0') AS TotalRevenue,
    FORMAT(AVG(p.Budget), 'C0') AS AvgProjectValue,
    FORMAT(SUM(ISNULL(p.ActualCost, 0)), 'C0') AS TotalCosts,
    
    -- PROFITABILITY ISSUES
    FORMAT(
        SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0)), 
        'C0'
    ) AS TotalProfit,
    
    FORMAT(
        CASE 
            WHEN SUM(p.Budget) > 0 
            THEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / SUM(p.Budget)
            ELSE 0 
        END, 
        'N1'
    ) + '%' AS ProfitMargin,
    
    -- DELIVERY PROBLEMS
    FORMAT(
        COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0), 
        'N1'
    ) + '%' AS OnTimeDeliveryRate,
    
    -- CANCELLATION RATE
    FORMAT(
        COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID), 
        'N1'
    ) + '%' AS ProjectCancellationRate,
    
    -- COST OVERRUN ANALYSIS
    COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) AS MajorCostOverruns,
    
    FORMAT(
        COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID), 
        'N1'
    ) + '%' AS MajorOverrunRate,
    
    -- TIME OVERRUN ANALYSIS
    COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate > DATEADD(MONTH, 2, p.PlannedEndDate) THEN 1 END) AS MajorDelays,
    
    -- PROBLEM SEVERITY CLASSIFICATION
    CASE 
        -- Critical issues requiring immediate intervention
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 5
             AND COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 20
        THEN '🔴 CRITICAL - Severe profitability and delivery issues'
        
        -- Major profitability concerns
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 10
        THEN '🟠 MAJOR CONCERN - Profitability below sustainable levels'
        
        -- Delivery problems
        WHEN COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
             NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) < 60
        THEN '🟡 DELIVERY ISSUES - Client satisfaction at risk'
        
        -- Quality concerns
        WHEN COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 30
        THEN '⚠️ QUALITY ISSUES - Frequent cost overruns indicate process problems'
        
        ELSE '🔍 MINOR ISSUES - Requires monitoring'
    END AS ProblemSeverity,
    
    -- ROOT CAUSE ANALYSIS
    CASE 
        WHEN pt.ComplexityLevel >= 4 
             AND COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
                 NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) < 60
        THEN 'COMPLEXITY MISMATCH: High complexity services need better project management'
        
        WHEN AVG(p.Budget) < 100000 
             AND ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 15
        THEN 'PRICING PRESSURE: Small projects with low margins indicate pricing issues'
        
        WHEN c.Industry IN ('Retail', 'Manufacturing') 
             AND COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 15
        THEN 'INDUSTRY CHALLENGES: Traditional industries may have different needs'
        
        WHEN COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 25
        THEN 'ESTIMATION PROBLEMS: Frequent cost overruns indicate poor estimation'
        
        ELSE 'MULTIPLE FACTORS: Requires detailed analysis'
    END AS RootCauseAnalysis,
    
    -- STRATEGIC RECOMMENDATIONS
    CASE 
        -- Exit strategy for severely problematic segments
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 0
             AND COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 25
        THEN 'EXIT STRATEGY: Consider discontinuing this service-market combination'
        
        -- Urgent improvement needed
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 10
        THEN 'URGENT IMPROVEMENT: Implement cost control and process improvement immediately'
        
        -- Pricing strategy revision
        WHEN AVG(p.Budget) < 150000 
             AND ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 20
        THEN 'PRICING REVISION: Increase prices or reduce scope to improve margins'
        
        -- Process improvement focus
        WHEN COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 20
        THEN 'PROCESS IMPROVEMENT: Focus on estimation accuracy and cost control'
        
        -- Delivery methodology improvement
        WHEN COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
             NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) < 70
        THEN 'DELIVERY IMPROVEMENT: Implement better project management practices'
        
        ELSE 'MONITOR CLOSELY: Watch for further deterioration'
    END AS StrategicRecommendation,
    
    -- URGENCY ASSESSMENT
    CASE 
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 5
        THEN 'IMMEDIATE ACTION REQUIRED'
        WHEN COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 20
        THEN 'ACTION REQUIRED WITHIN 30 DAYS'
        WHEN COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 25
        THEN 'ACTION REQUIRED WITHIN 60 DAYS'
        ELSE 'MONITOR AND REVIEW QUARTERLY'
    END AS ActionUrgency

FROM Companies c
    INNER JOIN Projects p ON c.CompanyID = p.CompanyID
    INNER JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
WHERE c.IsActive = 1 
    AND p.IsActive = 1
    AND pt.IsActive = 1
    AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY 
    c.Industry, pt.ProjectTypeID, pt.TypeName, pt.ComplexityLevel

-- STRATEGIC HAVING CLAUSES for underperforming segment identification
HAVING 
    -- Minimum volume for statistical significance
    COUNT(p.ProjectID) >= 5
    
    -- Performance problems (ANY of these conditions indicates issues)
    AND (
        -- Low profitability (less than 15% margin)
        ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 15
        
        -- OR poor delivery performance (less than 70% on-time)
        OR COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) * 100.0 / 
           NULLIF(COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END), 0) < 70
        
        -- OR high cancellation rate (more than 15%)
        OR COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 15
        
        -- OR frequent major cost overruns (more than 20% of projects over 120% of budget)
        OR COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 20
    )

ORDER BY 
    -- Prioritize by severity of problems
    CASE 
        WHEN ((SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) * 100.0) / NULLIF(SUM(p.Budget), 0) < 5 THEN 1
        WHEN COUNT(CASE WHEN p.Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 20 THEN 2
        WHEN COUNT(CASE WHEN ISNULL(p.ActualCost, 0) > ISNULL(p.Budget, 0) * 1.2 THEN 1 END) * 100.0 / COUNT(p.ProjectID) >= 25 THEN 3
        ELSE 4
    END,
    SUM(p.Budget) DESC; -- Secondary sort by revenue impact
```

## Part 2: Advanced HAVING Techniques - Complex Business Intelligence 🧠

### 🎓 TUTORIAL: Complex HAVING Conditions for Strategic Intelligence

Advanced HAVING techniques enable sophisticated business rules:

- **Multi-Condition Logic**: Combine multiple performance criteria with AND/OR logic
- **Statistical Thresholds**: Apply percentile-based and standard deviation filters
- **Temporal Conditions**: Filter based on time-based performance trends
- **Comparative Analysis**: Compare groups against benchmarks and peer groups

### Exercise 2.1: Emerging Opportunity Identification (🔴 EXPERT LEVEL)

**Scenario**: Use complex HAVING conditions to identify emerging market opportunities and high-growth potential segments.

```sql
-- Lab 9.3.4: Emerging Opportunity Analysis with Complex HAVING
-- Business scenario: Identify high-growth potential segments for strategic investment

WITH GrowthAnalysis AS (
    SELECT 
        c.Industry,
        pt.TypeName AS ServiceLine,
        
        -- Current year metrics
        COUNT(CASE WHEN p.StartDate >= DATEADD(YEAR, -1, GETDATE()) THEN p.ProjectID END) AS CurrentYearProjects,
        SUM(CASE WHEN p.StartDate >= DATEADD(YEAR, -1, GETDATE()) THEN p.Budget ELSE 0 END) AS CurrentYearRevenue,
        AVG(CASE WHEN p.StartDate >= DATEADD(YEAR, -1, GETDATE()) THEN p.Budget END) AS CurrentYearAvgValue,
        
        -- Previous year metrics for comparison
        COUNT(CASE WHEN p.StartDate >= DATEADD(YEAR, -2, GETDATE()) AND p.StartDate < DATEADD(YEAR, -1, GETDATE()) THEN p.ProjectID END) AS PreviousYearProjects,
        SUM(CASE WHEN p.StartDate >= DATEADD(YEAR, -2, GETDATE()) AND p.StartDate < DATEADD(YEAR, -1, GETDATE()) THEN p.Budget ELSE 0 END) AS PreviousYearRevenue,
        AVG(CASE WHEN p.StartDate >= DATEADD(YEAR, -2, GETDATE()) AND p.StartDate < DATEADD(YEAR, -1, GETDATE()) THEN p.Budget END) AS PreviousYearAvgValue,
        
        -- Overall performance metrics
        COUNT(p.ProjectID) AS TotalProjects,
        SUM(p.Budget) AS TotalRevenue,
        AVG(p.Budget) AS OverallAvgValue,
        
        -- Quality metrics
        COUNT(CASE WHEN p.Status = 'Completed' AND p.ActualEndDate <= p.PlannedEndDate THEN 1 END) AS OnTimeProjects,
        COUNT(CASE WHEN p.Status = 'Completed' THEN 1 END) AS CompletedProjects,
        
        -- Profitability
        (SUM(ISNULL(p.Budget, 0)) - SUM(ISNULL(p.ActualCost, 0))) AS TotalProfit,
        SUM(p.Budget) AS TotalBudget
        
    FROM Companies c
        INNER JOIN Projects p ON c.CompanyID = p.CompanyID
        INNER JOIN ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
    WHERE c.IsActive = 1 
        AND p.IsActive = 1
        AND pt.IsActive = 1
        AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
    GROUP BY c.Industry, pt.ProjectTypeID, pt.TypeName
)

SELECT 
    Industry,
    ServiceLine,
    
    -- CURRENT PERFORMANCE
    CurrentYearProjects,
    FORMAT(CurrentYearRevenue, 'C0') AS CurrentYearRevenue,
    FORMAT(CurrentYearAvgValue, 'C0') AS CurrentYearAvgProjectValue,
    
    -- GROWTH METRICS
    PreviousYearProjects,
    FORMAT(PreviousYearRevenue, 'C0') AS PreviousYearRevenue,
    
    -- GROWTH CALCULATIONS
    FORMAT(
        CASE 
            WHEN PreviousYearRevenue > 0 
            THEN ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / PreviousYearRevenue
            ELSE NULL 
        END, 
        'N1'
    ) + '%' AS RevenueGrowthRate,
    
    FORMAT(
        CASE 
            WHEN PreviousYearProjects > 0 
            THEN ((CurrentYearProjects - PreviousYearProjects) * 100.0) / PreviousYearProjects
            ELSE NULL 
        END, 
        'N1'
    ) + '%' AS ProjectVolumeGrowthRate,
    
    FORMAT(
        CASE 
            WHEN PreviousYearAvgValue > 0 
            THEN ((CurrentYearAvgValue - PreviousYearAvgValue) * 100.0) / PreviousYearAvgValue
            ELSE NULL 
        END, 
        'N1'
    ) + '%' AS AvgValueGrowthRate,
    
    -- QUALITY INDICATORS
    FORMAT(OverallAvgValue, 'C0') AS OverallAvgProjectValue,
    FORMAT(
        OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0), 
        'N1'
    ) + '%' AS OnTimeDeliveryRate,
    
    FORMAT(
        TotalProfit * 100.0 / NULLIF(TotalBudget, 0), 
        'N1'
    ) + '%' AS ProfitMargin,
    
    -- OPPORTUNITY CLASSIFICATION
    CASE 
        -- High-growth, high-value opportunities
        WHEN ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / NULLIF(PreviousYearRevenue, 0) >= 50
             AND CurrentYearAvgValue >= 300000
             AND OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0) >= 80
        THEN '🚀 ROCKET SHIP - High growth + Premium value + Excellent delivery'
        
        -- Emerging high-value markets
        WHEN CurrentYearAvgValue >= 500000
             AND ((CurrentYearProjects - PreviousYearProjects) * 100.0) / NULLIF(PreviousYearProjects, 0) >= 25
        THEN '💎 PREMIUM EMERGENCE - High-value projects with growing volume'
        
        -- Volume growth opportunities
        WHEN ((CurrentYearProjects - PreviousYearProjects) * 100.0) / NULLIF(PreviousYearProjects, 0) >= 100
             AND CurrentYearRevenue >= 1000000
        THEN '📈 VOLUME SURGE - Massive growth in project count'
        
        -- Value growth opportunities
        WHEN ((CurrentYearAvgValue - PreviousYearAvgValue) * 100.0) / NULLIF(PreviousYearAvgValue, 0) >= 40
             AND TotalProfit * 100.0 / NULLIF(TotalBudget, 0) >= 25
        THEN '💰 VALUE EXPANSION - Projects getting more valuable and profitable'
        
        -- Solid growth with good fundamentals
        WHEN ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / NULLIF(PreviousYearRevenue, 0) >= 25
             AND TotalProfit * 100.0 / NULLIF(TotalBudget, 0) >= 20
        THEN '🌱 STEADY GROWTH - Consistent growth with good margins'
        
        ELSE '🔍 EMERGING POTENTIAL - Early stage opportunity'
    END AS OpportunityType,
    
    -- INVESTMENT STRATEGY
    CASE 
        WHEN ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / NULLIF(PreviousYearRevenue, 0) >= 50
             AND CurrentYearAvgValue >= 300000
        THEN 'AGGRESSIVE INVESTMENT: Hire specialists, build dedicated team, premium positioning'
        
        WHEN CurrentYearAvgValue >= 500000 
             AND OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0) >= 85
        THEN 'PREMIUM POSITIONING: Develop thought leadership, premium pricing, expert team'
        
        WHEN ((CurrentYearProjects - PreviousYearProjects) * 100.0) / NULLIF(PreviousYearProjects, 0) >= 100
        THEN 'SCALE RAPIDLY: Build delivery capacity, standardize processes, hire aggressively'
        
        WHEN TotalProfit * 100.0 / NULLIF(TotalBudget, 0) >= 30
        THEN 'OPTIMIZE MARGINS: Maintain profitability while scaling, selective growth'
        
        ELSE 'MONITORED INVESTMENT: Cautious expansion, prove model before scaling'
    END AS InvestmentStrategy,
    
    -- COMPETITIVE INTELLIGENCE
    CASE 
        WHEN Industry IN ('Technology', 'Financial Services') 
             AND CurrentYearAvgValue >= 750000
        THEN 'DIGITAL TRANSFORMATION LEADER - Ride the technology wave'
        
        WHEN Industry IN ('Healthcare', 'Government') 
             AND ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / NULLIF(PreviousYearRevenue, 0) >= 40
        THEN 'REGULATED SECTOR OPPORTUNITY - Compliance and modernization needs'
        
        WHEN ServiceLine LIKE '%Cloud%' OR ServiceLine LIKE '%Digital%'
        THEN 'TECHNOLOGY TREND BENEFICIARY - Leveraging market transformation'
        
        WHEN CurrentYearAvgValue >= 400000 
             AND OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0) >= 85
        THEN 'PREMIUM SERVICE PROVIDER - Quality differentiation'
        
        ELSE 'MARKET SPECIFIC OPPORTUNITY - Industry or service specific advantage'
    END AS CompetitivePosition,
    
    -- RISK ASSESSMENT
    CASE 
        WHEN CurrentYearProjects < 3 
        THEN '⚠️ VOLUME RISK - Small sample size, growth may not be sustainable'
        
        WHEN OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0) < 75
        THEN '🔴 DELIVERY RISK - Poor delivery record may limit growth potential'
        
        WHEN TotalProfit * 100.0 / NULLIF(TotalBudget, 0) < 15
        THEN '💰 MARGIN RISK - Low profitability may not support investment'
        
        WHEN PreviousYearProjects = 0
        THEN '🆕 NEW MARKET RISK - No historical baseline, uncertain sustainability'
        
        ELSE '✅ BALANCED RISK - Fundamentals support growth opportunity'
    END AS RiskAssessment

FROM GrowthAnalysis

-- COMPLEX HAVING CONDITIONS for emerging opportunity identification
HAVING 
    -- Minimum current year activity for relevance
    CurrentYearProjects >= 3
    AND CurrentYearRevenue >= 500000
    
    -- Growth criteria (ANY of these conditions indicates opportunity)
    AND (
        -- Strong revenue growth (25%+ year-over-year)
        (PreviousYearRevenue > 0 AND 
         ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / PreviousYearRevenue >= 25)
        
        -- OR strong project volume growth (50%+ year-over-year)
        OR (PreviousYearProjects > 0 AND 
            ((CurrentYearProjects - PreviousYearProjects) * 100.0) / PreviousYearProjects >= 50)
        
        -- OR strong project value growth (30%+ year-over-year)
        OR (PreviousYearAvgValue > 0 AND 
            ((CurrentYearAvgValue - PreviousYearAvgValue) * 100.0) / PreviousYearAvgValue >= 30)
        
        -- OR high current project values indicating premium positioning
        OR CurrentYearAvgValue >= 400000
        
        -- OR new market entry with significant scale
        OR (PreviousYearProjects = 0 AND CurrentYearProjects >= 5 AND CurrentYearRevenue >= 1000000)
    )
    
    -- Quality standards (MUST meet basic delivery and profitability standards)
    AND OnTimeProjects * 100.0 / NULLIF(CompletedProjects, 0) >= 70  -- Minimum 70% on-time delivery
    AND TotalProfit * 100.0 / NULLIF(TotalBudget, 0) >= 10  -- Minimum 10% profit margin

ORDER BY 
    -- Prioritize by growth potential and current scale
    ((CurrentYearRevenue - PreviousYearRevenue) * 100.0) / NULLIF(PreviousYearRevenue, 0) DESC,
    CurrentYearRevenue DESC;
```

## 🎯 HAVING Clause Mastery Summary

### Advanced HAVING Techniques You've Mastered

1. **Strategic Filtering**: Apply business thresholds to identify key segments
2. **Performance Benchmarking**: Filter groups based on performance standards
3. **Multi-Criteria Logic**: Complex AND/OR conditions for sophisticated filtering
4. **Exception Reporting**: Surface only the most critical insights for leadership
5. **Opportunity Discovery**: Identify emerging markets and growth potential

### Real-World Business Applications

- **Executive Exception Reporting**: Show only segments that require leadership attention
- **Resource Allocation**: Focus investment on segments meeting strategic criteria
- **Performance Management**: Identify top performers and underperformers automatically
- **Risk Management**: Early warning system for segments requiring intervention
- **Strategic Planning**: Data-driven identification of growth opportunities

### Professional Skills Achieved

- **Strategic Focus**: Transform comprehensive analysis into targeted insights
- **Executive Communication**: Create reports that surface only critical information
- **Performance Standards**: Apply business thresholds systematically
- **Risk Management**: Identify problems before they become critical
- **Opportunity Recognition**: Spot emerging trends and growth potential

---

*You've now mastered the HAVING clause - the precision tool that transforms broad analysis into strategic intelligence. These skills enable you to create executive-level reports that focus leadership attention on what matters most!*

## Next Steps

Continue to the comprehensive Lab where you'll combine all Module 9 skills (Aggregate Functions, GROUP BY, and HAVING) in sophisticated business scenarios that showcase the full power of SQL Server's data aggregation and analysis capabilities.

*Welcome to the elite level of strategic business intelligence!* 🎯🧠