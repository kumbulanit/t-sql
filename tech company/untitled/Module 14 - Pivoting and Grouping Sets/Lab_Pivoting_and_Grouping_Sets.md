# Lab: Pivoting and Grouping Sets

## Lab Overview

This comprehensive lab provides hands-on experience with advanced T-SQL data transformation and aggregation techniques using PIVOT, UNPIVOT, ROLLUP, CUBE, and GROUPING SETS operations. You'll work with real-world TechCorp business scenarios to create sophisticated business intelligence reports, executive dashboards, and multi-dimensional analysis that support strategic decision-making and operational excellence.

## 🏢 TechCorp Business Challenge Context

**Lab Scenario:** TechCorp's executive team requires comprehensive business intelligence capabilities that can present data from multiple perspectives simultaneously. Your task is to create advanced analytical queries that transform raw operational data into meaningful business insights using pivoting and grouping techniques for strategic planning, performance monitoring, and resource optimization.

### 📋 TechCorp Database Schema Reminder

**Core Tables for Lab Exercises:**
```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Exercise 1: PIVOT Operations - Executive Dashboard Creation

### Business Requirement
Create comprehensive executive dashboards that transform operational data into strategic business intelligence using PIVOT operations for cross-tabulated analysis and performance monitoring.

### Task 1.1: Quarterly Financial Performance Matrix
Transform quarterly financial data into executive dashboard format:

**Instructions:**
1. Create quarterly revenue analysis by d.DepartmentName using PIVOT
2. Include performance indicators and growth calculations
3. Add variance analysis and benchmarking
4. Provide strategic recommendations based on performance

**Expected Columns:**
- d.DepartmentName information
- Q1, Q2, Q3, Q4 revenue columns
- Total annual revenue
- Growth trends and performance indicators
- Strategic recommendations

**Starter Template:**
```sql
-- Task 1.1: Quarterly Financial Performance Matrix
WITH QuarterlyFinancialData AS (
    SELECT d.DepartmentName,
        d.Location,
        -- Determine quarter from order date
        CASE 
            WHEN MONTH(o.OrderDate) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(o.OrderDate) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(o.OrderDate) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END AS Quarter,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE o.IsActive = 1
      AND e.IsActive = 1
      AND d.IsActive = 1
      AND YEAR(o.OrderDate) = 2025  -- Focus on current year
)
SELECT d.DepartmentName,
    Location,
    -- Add your PIVOT operation here to create quarterly columns
    -- FORMAT quarterly amounts as currency
    -- Calculate total annual revenue
    -- Add growth trend analysis
    -- Include performance benchmarking
    ...
FROM QuarterlyFinancialData
PIVOT (
    -- Your PIVOT logic here
    SUM(TotalAmount) FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) quarterly_pivot
ORDER BY -- Add appropriate ordering;
```

### Task 1.2: Employee Performance Cross-Tabulation
Create employee performance matrix showing skills and contributions across different dimensions:

**Instructions:**
1. Use PIVOT to create performance matrix by d.DepartmentName and experience level
2. Include productivity metrics and compensation analysis
3. Add performance rankings and categorization
4. Provide development recommendations

### Task 1.3: Customer Analysis Dashboard
Transform customer data into strategic account analysis:

**Instructions:**
1. Create customer revenue analysis by country and order size using PIVOT
2. Include customer lifetime value calculations
3. Add market penetration analysis
4. Provide account management recommendations

## Exercise 2: UNPIVOT Operations - Data Normalization and Analysis

### Business Requirement
Transform cross-tabulated business data back into normalized format for detailed analysis, trend identification, and time-series processing.

### Task 2.1: Performance Metrics Normalization
Convert performance matrices to normalized format for trend analysis:

**Instructions:**
1. Start with a pivoted performance metrics table
2. Use UNPIVOT to normalize the data
3. Add time-series analysis capabilities
4. Include trend identification and forecasting foundation

**Starter Template:**
```sql
-- Task 2.1: Performance Metrics Normalization
WITH PerformanceMatrix AS (
    -- Create a performance matrix (simulated pivoted data)
    SELECT 
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        -- Create performance metrics using CASE statements
        SUM(CASE WHEN ep.Role = 'Lead' THEN ep.HoursWorked ELSE 0 END) AS Leadership_Hours,
        SUM(CASE WHEN ep.Role = 'Developer' THEN ep.HoursWorked ELSE 0 END) AS Development_Hours,
        SUM(CASE WHEN ep.Role = 'Analyst' THEN ep.HoursWorked ELSE 0 END) AS Analysis_Hours,
        SUM(CASE WHEN ep.Role = 'Support' THEN ep.HoursWorked ELSE 0 END) AS Support_Hours
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND ep.IsActive = 1
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName
)
-- Now UNPIVOT the matrix for analysis
SELECT 
    EmployeeName,
    DepartmentName,
    Role_Category,
    Hours_Worked,
    -- Add your analytical columns here:
    -- Performance ranking within d.DepartmentName
    -- Specialization indicators
    -- Development recommendations
    ...
FROM PerformanceMatrix
UNPIVOT (
    Hours_Worked FOR Role_Category IN (
        Leadership_Hours, Development_Hours, Analysis_Hours, Support_Hours
    )
) unpivot_performance
WHERE Hours_Worked > 0  -- Only include categories with actual work
ORDER BY EmployeeName, Hours_Worked DESC;
```

### Task 2.2: Budget Variance Analysis
Normalize budget vs actual data for detailed variance analysis:

**Instructions:**
1. Create budget vs actual matrix using PIVOT techniques
2. Use UNPIVOT to normalize for detailed analysis
3. Add variance calculations and trend analysis
4. Include root cause analysis indicators

### Task 2.3: Time Series Data Preparation
Transform cross-tabulated time data for analytical processing:

**Instructions:**
1. Convert monthly or quarterly matrices to time series format
2. Add temporal analysis capabilities
3. Include seasonality and trend identification
4. Prepare data for predictive analytics

## Exercise 3: ROLLUP Operations - Hierarchical Business Intelligence

### Business Requirement
Create hierarchical business intelligence reports that provide multiple levels of aggregation simultaneously, supporting both detailed operational analysis and executive summary requirements.

### Task 3.1: Organizational Performance Hierarchy
Create comprehensive organizational performance analysis using ROLLUP:

**Instructions:**
1. Use ROLLUP to create hierarchical employee performance analysis
2. Include d.DepartmentName, location, and company-wide summaries
3. Add performance indicators at each level
4. Provide management insights and recommendations

**Starter Template:**
```sql
-- Task 3.1: Organizational Performance Hierarchy
SELECT 
    -- Add CASE statements using GROUPING functions for level identification
    CASE 
        WHEN GROUPING(d.Location) = 1 AND GROUPING(d.DepartmentName) = 1 
        THEN 'COMPANY TOTAL'
        WHEN GROUPING(d.DepartmentName) = 1 
        THEN d.Location + ' LOCATION TOTAL'
        ELSE d.DepartmentName
    END AS Organization_Level,
    -- Add your hierarchy display columns
    CASE WHEN GROUPING(d.Location) = 1 THEN 'All Locations' ELSE d.Location END AS Location,
    -- Add aggregation columns:
    -- Employee counts, e.BaseSalary totals, project involvement
    -- Performance metrics, productivity indicators
    -- Add your calculations here
    ...
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
-- Add additional JOINs as needed for comprehensive analysis
WHERE e.IsActive = 1 AND d.IsActive = 1
GROUP BY ROLLUP(d.Location, d.DepartmentName)
ORDER BY 
    GROUPING(d.Location),
    GROUPING(d.DepartmentName),
    d.Location,
    d.DepartmentName;
```

### Task 3.2: Financial Performance Hierarchy
Create hierarchical financial analysis with subtotals:

**Instructions:**
1. Build comprehensive financial hierarchy using ROLLUP
2. Include revenue, costs, and profitability at each level
3. Add budget variance analysis
4. Include strategic financial recommendations

### Task 3.3: Project Portfolio Analysis
Develop hierarchical project portfolio analysis:

**Instructions:**
1. Create project analysis hierarchy by d.DepartmentName and project manager
2. Include project performance metrics and resource utilization
3. Add portfolio risk assessment
4. Provide project management recommendations

## Exercise 4: CUBE Operations - Multi-Dimensional Analysis

### Business Requirement
Create comprehensive multi-dimensional business analysis that examines all possible combinations of business dimensions for complete strategic insight.

### Task 4.1: Comprehensive Business Intelligence Cube
Build complete business intelligence analysis using CUBE:

**Instructions:**
1. Use CUBE to analyze business performance across multiple dimensions
2. Include all possible combinations of location, d.DepartmentName, and performance tiers
3. Add strategic insights for each dimensional combination
4. Provide comprehensive business recommendations

**Starter Template:**
```sql
-- Task 4.1: Comprehensive Business Intelligence Cube
WITH BusinessIntelligenceData AS (
    SELECT 
        d.Location,
        d.DepartmentName,
        -- Add performance tier classification
        CASE 
            WHEN e.BaseSalary >= 80000 THEN 'High Performers'
            WHEN e.BaseSalary >= 60000 THEN 'Mid-Level Performers'
            ELSE 'Entry Level'
        END AS Performance_Tier,
        e.BaseSalary,
        -- Add additional metrics from joined tables
        -- Project involvement, customer interactions, etc.
        ...
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    -- Add additional joins for comprehensive analysis
    WHERE e.IsActive = 1 AND d.IsActive = 1
)
SELECT 
    -- Add CASE statements for dimensional labeling
    CASE 
        WHEN GROUPING(Location) = 1 AND GROUPING(d.DepartmentName) = 1 AND GROUPING(Performance_Tier) = 1
        THEN 'GLOBAL BUSINESS SUMMARY'
        -- Add all other dimensional combinations
        ...
    END AS Business_Dimension,
    -- Add display columns with proper NULL handling
    -- Add comprehensive metrics and calculations
    -- Include strategic insights and recommendations
    ...
FROM BusinessIntelligenceData
GROUP BY CUBE(Location, DepartmentName, Performance_Tier)
HAVING -- Add appropriate filters
ORDER BY -- Add comprehensive ordering;
```

### Task 4.2: Customer Relationship Analysis Cube
Create comprehensive customer analysis across all dimensions:

**Instructions:**
1. Build customer analysis cube by country, order size, and relationship duration
2. Include customer lifetime value and profitability analysis
3. Add market penetration and opportunity identification
4. Provide customer relationship management strategies

### Task 4.3: Resource Optimization Cube
Develop resource optimization analysis using CUBE:

**Instructions:**
1. Create resource utilization cube by d.DepartmentName, skill level, and project type
2. Include efficiency metrics and capacity analysis
3. Add optimization opportunities identification  
4. Provide resource allocation recommendations

## Exercise 5: Custom GROUPING SETS - Strategic Business Analysis

### Business Requirement
Create sophisticated business analysis using custom GROUPING SETS that align with specific strategic objectives and executive reporting requirements.

### Task 5.1: Executive Strategic Dashboard
Build custom executive dashboard using GROUPING SETS:

**Instructions:**
1. Define custom grouping combinations that align with executive priorities
2. Include strategic KPIs and performance indicators
3. Add competitive analysis and benchmarking
4. Provide strategic planning insights

**Starter Template:**
```sql
-- Task 5.1: Executive Strategic Dashboard
WITH StrategicMetrics AS (
    SELECT 
        d.Location,
        d.DepartmentName,
        -- Add strategic classification dimensions
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 'Strategic Leadership'
            WHEN e.BaseSalary >= 70000 THEN 'Core Operations'
            ELSE 'Growth Potential'
        END AS Strategic_Tier,
        -- Add comprehensive business metrics
        e.BaseSalary,
        -- Include project, customer, and performance data
        ...
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    -- Add comprehensive joins
    WHERE e.IsActive = 1 AND d.IsActive = 1
)
SELECT 
    -- Add custom dimension labeling based on grouping combinations
    -- Include strategic KPI calculations
    -- Add performance benchmarking
    -- Include strategic recommendations
    ...
FROM StrategicMetrics
GROUP BY GROUPING SETS (
    -- Define custom grouping combinations for executive priorities:
    (Location, DepartmentName, Strategic_Tier),  -- Detailed strategic analysis
    (Location, Strategic_Tier),                  -- Regional strategic focus
    (DepartmentName, Strategic_Tier),           -- Functional strategic analysis
    (Location),                                  -- Regional summary
    (Strategic_Tier),                           -- Strategic tier analysis
    ()                                          -- Executive summary
)
ORDER BY -- Add strategic ordering;
```

### Task 5.2: Operational Excellence Analysis
Create operational analysis using targeted GROUPING SETS:

**Instructions:**
1. Define grouping sets focused on operational metrics
2. Include efficiency, productivity, and quality indicators
3. Add operational improvement opportunities
4. Provide operational optimization recommendations

### Task 5.3: Growth Strategy Analysis
Develop growth-focused analysis with custom groupings:

**Instructions:**
1. Create grouping sets aligned with growth objectives
2. Include market expansion and capability development metrics
3. Add investment priority identification
4. Provide growth strategy recommendations

## Exercise 6: Advanced Integration Challenge

### Business Requirement
Create a comprehensive business intelligence solution that combines PIVOT, UNPIVOT, and all grouping operations to deliver integrated strategic analysis.

### Task 6.1: Integrated Executive Intelligence Platform
Build comprehensive business intelligence platform:

**Instructions:**
1. Combine multiple data transformation techniques in a single solution
2. Create dashboard that supports drill-down from summary to detail
3. Include predictive analytics foundation
4. Provide integrated strategic recommendations

**Challenge Requirements:**
- Use PIVOT for cross-tabulated presentations
- Use UNPIVOT for detailed trend analysis
- Use ROLLUP for hierarchical summaries
- Use CUBE for comprehensive dimensional analysis
- Use GROUPING SETS for custom executive views
- Include dynamic SQL for flexible reporting
- Add performance optimization techniques

### Task 6.2: Real-Time Business Intelligence
Create near real-time business intelligence solution:

**Instructions:**
1. Design queries optimized for frequent execution
2. Include incremental data processing capabilities
3. Add automated alerting and exception identification
4. Create foundation for operational dashboards

### Task 6.3: Predictive Analytics Foundation
Build foundation for predictive business analytics:

**Instructions:**
1. Create data structures supporting machine learning
2. Include feature engineering for predictive models
3. Add trend analysis and forecasting capabilities
4. Provide data quality and validation framework

## Lab Validation and Testing

### Query Performance Checklist
- [ ] All queries execute within acceptable time limits (< 30 seconds for complex analysis)
- [ ] Proper indexing strategy implemented for grouping and pivoting columns
- [ ] Memory usage optimized for large dataset processing
- [ ] Query plans reviewed and optimized

### Business Logic Verification
- [ ] PIVOT operations produce correct cross-tabulated results
- [ ] UNPIVOT operations properly normalize data
- [ ] ROLLUP hierarchies provide accurate subtotals
- [ ] CUBE operations include all dimensional combinations
- [ ] GROUPING SETS produce expected custom aggregations
- [ ] Business calculations and KPIs are accurate

### Data Quality Assessment
- [ ] NULL values handled appropriately in all transformations
- [ ] Data types maintained correctly through transformations
- [ ] Aggregation accuracy verified with test data
- [ ] Edge cases properly handled (empty groups, missing data)

## Advanced Challenge Exercises

### Challenge 1: Dynamic Business Intelligence
Create dynamic reporting solution that adapts to changing business requirements:

**Requirements:**
- Dynamic column generation based on available data
- Flexible grouping based on user parameters
- Automated report generation and distribution
- Self-adjusting performance optimization

### Challenge 2: Multi-Tenant Analysis
Build business intelligence solution supporting multiple business units:

**Requirements:**
- Flexible schema supporting different organizational structures
- Security and access control integration
- Cross-business unit benchmarking
- Scalable performance for multiple concurrent users

### Challenge 3: Advanced Analytics Integration
Create foundation for advanced analytics and machine learning:

**Requirements:**
- Feature engineering for predictive models
- Data pipeline for continuous learning
- Integration with external analytics platforms
- Real-time scoring and recommendation engine

## Lab Completion Summary

### Key Learning Objectives Achieved
- **PIVOT Mastery**: Cross-tabulation and dashboard creation expertise
- **UNPIVOT Proficiency**: Data normalization and time-series preparation
- **ROLLUP Excellence**: Hierarchical reporting and organizational analysis
- **CUBE Sophistication**: Multi-dimensional business intelligence
- **GROUPING SETS Expertise**: Custom business analysis and strategic reporting
- **Integration Skills**: Combined technique application for comprehensive solutions

### Business Skills Developed
- Executive dashboard design and implementation
- Strategic business intelligence analysis
- Operational performance monitoring
- Financial reporting and variance analysis
- Customer relationship analytics
- Resource optimization and planning

### Technical Competencies Enhanced
- Advanced T-SQL data transformation techniques
- Performance optimization for complex aggregations
- Dynamic SQL and flexible reporting solutions
- Business intelligence architecture design
- Data quality and validation methodologies
- Integration with business intelligence platforms

This comprehensive lab provides TechCorp analysts with advanced pivoting and grouping skills essential for sophisticated business intelligence, executive reporting, and strategic analysis in modern enterprise environments. The combination of technical proficiency and business acumen enables creation of powerful analytical solutions that drive informed decision-making and organizational success.