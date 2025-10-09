# Lab: Using Set Operators

## Lab Overview

This comprehensive lab provides hands-on experience with all T-SQL set operators: UNION, UNION ALL, EXCEPT, INTERSECT, CROSS APPLY, and OUTER APPLY. You'll work with real-world TechCorp business scenarios to master advanced data analysis techniques and solve complex business challenges using sophisticated query patterns.

## 🏢 TechCorp Business Challenge Context

**Lab Scenario:** TechCorp's executive team requires comprehensive business intelligence reports that combine data from multiple sources, identify patterns and anomalies, and provide actionable insights for strategic decision-making. Your task is to create sophisticated queries that leverage set operators to deliver enterprise-level analytics.

### 📋 TechCorp Database Schema Reminder

**Core Tables for Lab Exercises:**
```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
EmployeeArchive: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ArchiveDate, ReasonForLeaving
```

## Exercise 1: UNION Operations - Strategic Contact Directory

### Business Requirement
Create a comprehensive contact directory that combines current employees, archived employees, and customers into a unified communication list for TechCorp's marketing and HR departments.

### Task 1.1: Basic Contact Consolidation
Create a query that combines all contact information using UNION operations:

**Instructions:**
1. Combine current employee contacts (WorkEmail, first name, last name)
2. Include archived employee contacts with their departure information
3. Add customer contacts with company affiliation
4. Ensure no duplicate email addresses
5. Sort by contact type and last name

**Expected Columns:**
- ContactType (Employee, Former Employee, Customer)
- FullName
- EmailAddress
- Organization (Department/Company)
- Status
- AdditionalInfo

**Starter Template:**
```sql
-- Your UNION query here
-- Hint: Use UNION to eliminate duplicates, UNION ALL if you need to preserve them
-- Remember to use consistent column names and data types across all SELECT statements

SELECT 
    'Current Employee' AS ContactType,
    -- Add your columns here
    ...
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

UNION

-- Add archived employees section

UNION

-- Add customers section

ORDER BY ContactType, e.LastName;
```

### Task 1.2: Advanced Contact Analysis
Extend your contact directory with business intelligence:

**Instructions:**
1. Add contact value classification (High Value, Medium Value, Standard)
2. Include contact recency information
3. Segment contacts by geographic region
4. Add recommended engagement strategy

**Business Logic:**
- High Value: Customers with orders >$50,000 total OR employees with BaseSalary >$80,000
- Medium Value: Customers with orders >$20,000 total OR employees with BaseSalary >$60,000
- Standard: All other contacts

## Exercise 2: EXCEPT Operations - Data Quality and Compliance

### Business Requirement
TechCorp's compliance team needs to identify data inconsistencies, missing relationships, and potential security issues across the organization.

### Task 2.1: Employee Compliance Audit
Identify employees who don't meet specific compliance requirements:

**Instructions:**
1. Find employees who have never been assigned to projects
2. Identify employees without managers (except executives)
3. Locate employees with access issues (missing email patterns)
4. Find departments with employees but no active projects

**Starter Template:**
```sql
-- Task 2.1.1: Employees never assigned to projects
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    'Never Assigned Projects' AS ComplianceIssue
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1

EXCEPT

-- Add your EXCEPT logic to exclude employees with project assignments
-- Hint: SELECT employees who HAVE been assigned to projects

ORDER BY d.DepartmentName, EmployeeName;
```

### Task 2.2: Customer Data Validation
Use EXCEPT to identify customer data quality issues:

**Instructions:**
1. Find customers with orders but missing critical information
2. Identify customers who haven't placed orders in the last 12 months
3. Locate customers with inconsistent geographic data
4. Find customers without recent employee interactions

### Task 2.3: Security and Access Review
Create compliance reports for security audit:

**Instructions:**
1. Identify employees with access levels inconsistent with their roles
2. Find former employees who might still have system access
3. Locate customers with unusual order patterns
4. Check for email domain inconsistencies

## Exercise 3: INTERSECT Operations - Business Intelligence

### Business Requirement
TechCorp's strategy team needs to identify overlapping patterns, common characteristics, and shared attributes across different business entities for market analysis and organizational optimization.

### Task 3.1: High-Performance Intersection Analysis
Find employees who are both high performers and high earners:

**Instructions:**
1. Define high performers (top 20% by project involvement and customer interaction)
2. Define high earners (top 25% by BaseSalary within department)
3. Use INTERSECT to find employees meeting both criteria
4. Analyze their characteristics and d.DepartmentName distribution

**Starter Template:**
```sql
-- High performers based on activity metrics
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.EmployeeID IN (
      -- Define high performer criteria here
      -- Consider project involvement, customer orders, etc.
  )

INTERSECT

-- High earners within their departments
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    e.BaseSalary
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND e.BaseSalary >= (
      -- Calculate d.DepartmentName e.BaseSalary threshold (75th percentile)
  )

ORDER BY d.DepartmentName, e.BaseSalary DESC;
```

### Task 3.2: Customer Segment Overlap Analysis
Identify customers who belong to multiple valuable segments:

**Instructions:**
1. Define high-value customers (top orders by amount)
2. Define frequent customers (high order frequency)
3. Define loyal customers (long relationship duration)
4. Use INTERSECT to find overlaps between segments

### Task 3.3: d.DepartmentName Capability Analysis
Find departments that excel in multiple areas:

**Instructions:**
1. Identify departments with high employee satisfaction (high salaries, low turnover)
2. Find departments with strong project performance (on-time, within budget)
3. Locate departments with excellent customer service (high order values, frequent orders)
4. Use INTERSECT to find departments excelling in multiple areas

## Exercise 4: APPLY Operations - Advanced Analytics

### Business Requirement
TechCorp's executive dashboard requires sophisticated per-entity analysis that cannot be achieved with standard JOIN operations. Use APPLY operations to create dynamic, contextual business intelligence.

### Task 4.1: Employee Performance Dashboard
Create comprehensive employee performance profiles using CROSS APPLY:

**Instructions:**
1. For each employee, calculate dynamic performance metrics
2. Include project success rates, customer satisfaction scores, and team contributions
3. Provide personalized career development recommendations
4. Rank employees within their departments and roles

**Starter Template:**
```sql
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    FORMAT(e.BaseSalary, 'C') AS e.BaseSalary,
    performance_metrics.ProjectScore,
    performance_metrics.CustomerScore,
    performance_metrics.TeamScore,
    performance_metrics.OverallRating,
    performance_metrics.CareerRecommendation,
    performance_metrics.DepartmentRank
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
CROSS APPLY (
    SELECT 
        -- Calculate project performance score (0-100)
        project_data.ProjectScore,
        -- Calculate customer interaction score (0-100)
        customer_data.CustomerScore,
        -- Calculate team contribution score (0-100)
        team_data.TeamScore,
        -- Overall performance rating
        CAST((
            (project_data.ProjectScore * 0.4) +
            (customer_data.CustomerScore * 0.3) +
            (team_data.TeamScore * 0.3)
        ) AS DECIMAL(5,2)) AS OverallRating,
        -- Personalized recommendations
        CASE 
            WHEN project_data.ProjectScore < 50 THEN 'Focus on project engagement'
            WHEN customer_data.CustomerScore < 50 THEN 'Enhance customer relations'
            WHEN team_data.TeamScore < 50 THEN 'Develop team collaboration'
            ELSE 'Continue excellent performance'
        END AS CareerRecommendation,
        -- d.DepartmentName ranking
        ROW_NUMBER() OVER (
            PARTITION BY e.d.DepartmentID 
            ORDER BY (
                (project_data.ProjectScore * 0.4) +
                (customer_data.CustomerScore * 0.3) +
                (team_data.TeamScore * 0.3)
            ) DESC
        ) AS DepartmentRank
    FROM (
        -- Project performance calculation
        SELECT 
            -- Your project scoring logic here
            -- Consider: number of projects, hours worked, completion rates
            CASE 
                WHEN project_count >= 5 THEN 100
                WHEN project_count >= 3 THEN 80
                WHEN project_count >= 1 THEN 60
                ELSE 0
            END AS ProjectScore
        FROM (
            SELECT COUNT(DISTINCT ep.ProjectID) AS project_count
            FROM EmployeeProjects ep
            WHERE ep.e.EmployeeID = e.EmployeeID
              AND ep.IsActive = 1
        ) project_summary
    ) project_data
    CROSS JOIN (
        -- Customer interaction scoring
        -- Your customer scoring logic here
    ) customer_data
    CROSS JOIN (
        -- Team contribution scoring
        -- Your team scoring logic here
    ) team_data
) performance_metrics
WHERE e.IsActive = 1
  AND d.IsActive = 1
ORDER BY d.DepartmentName, performance_metrics.OverallRating DESC;
```

### Task 4.2: Customer Relationship Analysis
Use OUTER APPLY to analyze customer relationships comprehensively:

**Instructions:**
1. For each customer, analyze order patterns and trends
2. Calculate customer lifetime value and growth potential
3. Identify relationship risks and opportunities
4. Provide account management recommendations

### Task 4.3: d.DepartmentName Resource Optimization
Create department-level analysis using APPLY operations:

**Instructions:**
1. Analyze each department's resource utilization
2. Calculate efficiency metrics and performance indicators
3. Identify optimization opportunities
4. Provide strategic recommendations for resource allocation

## Exercise 5: Complex Business Intelligence Challenge

### Business Requirement
TechCorp's CEO requires a comprehensive executive dashboard that combines all set operators to provide integrated business intelligence across all organizational dimensions.

### Task 5.1: Executive Summary Dashboard
Create a comprehensive query that combines multiple set operators:

**Instructions:**
1. Use UNION to combine different types of business metrics
2. Use EXCEPT to identify performance gaps and missing elements
3. Use INTERSECT to find areas of excellence and overlap
4. Use APPLY to calculate dynamic, contextual metrics

**Dashboard Requirements:**
- d.DepartmentName performance summary with key metrics
- Employee performance distribution and outliers
- Customer relationship health indicators
- Project portfolio analysis
- Financial performance indicators
- Risk assessment and opportunity identification

**Starter Template:**
```sql
-- Executive Dashboard: Combined Set Operations
WITH DepartmentMetrics AS (
    -- Use APPLY operations for department-level analysis
    SELECT d.DepartmentName,
        dept_analysis.EmployeeCount,
        dept_analysis.AvgSalary,
        dept_analysis.ProjectCount,
        dept_analysis.Revenue,
        dept_analysis.PerformanceRating
    FROM Departments d
    CROSS APPLY (
        -- Your comprehensive d.DepartmentName analysis here
        -- Include employee metrics, project success, customer satisfaction
    ) dept_analysis
    WHERE d.IsActive = 1
),
PerformanceGaps AS (
    -- Use EXCEPT to identify performance gaps
    -- Find departments/employees not meeting benchmarks
),
ExcellenceAreas AS (
    -- Use INTERSECT to find areas of excellence
    -- Identify high-performing intersections
)
-- Combine all metrics with UNION operations
SELECT 
    'Department Performance' AS MetricCategory,
    d.DepartmentName AS Entity,
    -- Add metrics columns
FROM DepartmentMetrics

UNION ALL

SELECT 
    'Performance Gaps' AS MetricCategory,
    -- Add gap analysis
FROM PerformanceGaps

UNION ALL

SELECT 
    'Excellence Areas' AS MetricCategory,
    -- Add excellence analysis
FROM ExcellenceAreas

ORDER BY MetricCategory, Entity;
```

### Task 5.2: Strategic Planning Analysis
Create advanced strategic planning queries:

**Instructions:**
1. Identify growth opportunities using INTERSECT operations
2. Find resource allocation gaps using EXCEPT operations
3. Create combined opportunity/risk matrices using UNION operations
4. Develop detailed action plans using APPLY operations

### Task 5.3: Predictive Analytics Foundation
Build queries that support predictive analytics:

**Instructions:**
1. Create trend analysis using historical and current data combinations
2. Identify leading indicators using pattern recognition
3. Build foundation for machine learning data sets
4. Create automated alerting criteria

## Lab Validation and Testing

### Data Validation Checklist
- [ ] All queries execute without errors
- [ ] Results contain expected data types and formats
- [ ] NULL values are handled appropriately
- [ ] Business logic is correctly implemented
- [ ] Performance is acceptable for expected data volumes

### Business Logic Verification
- [ ] Contact directory includes all required sources
- [ ] Compliance reports identify actual issues
- [ ] Performance metrics align with business definitions
- [ ] Dashboard provides actionable insights
- [ ] Strategic analysis supports decision-making

### Performance Testing
- [ ] Queries complete within acceptable time limits
- [ ] Resource usage is optimized
- [ ] Indexes are utilized effectively
- [ ] Large dataset performance is validated

## Advanced Challenge Exercises

### Challenge 1: Real-time Business Intelligence
Create queries that could support near real-time dashboard updates:

**Requirements:**
- Optimize for frequent execution
- Minimize resource consumption
- Provide incremental data processing
- Support automated refresh scenarios

### Challenge 2: Multi-dimensional Analysis
Build queries that analyze business performance across multiple dimensions simultaneously:

**Requirements:**
- Time-based trending analysis
- Geographic performance comparison
- d.DepartmentName vs role vs performance matrices
- Customer segment profitability analysis

### Challenge 3: Exception and Anomaly Detection
Develop sophisticated exception detection using set operators:

**Requirements:**
- Statistical outlier identification
- Pattern deviation detection
- Automated alert generation
- Root cause analysis support

## Lab Completion Summary

### Key Learning Objectives Achieved
- **UNION Mastery**: Combining heterogeneous data sources for comprehensive analysis
- **EXCEPT Proficiency**: Identifying gaps, exceptions, and compliance issues
- **INTERSECT Expertise**: Finding overlaps, patterns, and commonalities
- **APPLY Sophistication**: Per-row dynamic analysis and complex correlations
- **Business Intelligence**: Integrated analytical thinking and practical application

### Business Skills Developed
- Strategic thinking through data analysis
- Compliance and audit methodology
- Performance measurement and evaluation
- Risk assessment and opportunity identification
- Executive-level reporting and presentation

### Technical Competencies Enhanced
- Advanced T-SQL query optimization
- Complex business logic implementation
- Multi-table relationship management
- Performance tuning and resource optimization
- Data quality and validation techniques

This comprehensive lab provides TechCorp analysts with the advanced set operator skills necessary for sophisticated business intelligence, strategic analysis, and executive decision support in modern enterprise environments.