# Module 4 Exercises: Querying Multiple Tables

## Exercise Set Overview
These exercises test your mastery of all join types and multi-table querying techniques. You'll work with complex business scenarios requiring inner joins, outer joins, self joins, and cross joins to solve real-world problems.

## Instructions
- Complete all exercises using the enhanced database schema from the lab
- Write efficient, well-documented queries
- Use appropriate join types for each scenario
- Include proper NULL handling and error checking
- Optimize for both performance and readability

---

## Exercise 1: Inner Join Mastery (30 points)

### 1.1 Basic Inner Join Applications (6 points each)

**Question 1.1.1**: Employee Project Performance Analysis
Create a query that shows the performance of employees on their current projects. Include:
- Employee name, title, and department
- Project name, status, and priority
- Role on project and hours worked vs allocated
- Efficiency percentage (hours worked / hours allocated * 100)
- Hourly rate and total earnings from project
- Only include active employees on in-progress projects
- Order by efficiency percentage descending

**Question 1.1.2**: Department Resource Utilization
Build a comprehensive department analysis showing:
- Department name, budget, and location
- Number of active employees
- Total salary expense and percentage of budget used
- Number of active projects and total project hours
- Average employee utilization rate
- Skills diversity score (count of unique skills in department)
- Only include departments with active employees

**Question 1.1.3**: Skills Market Value Analysis
Develop a skills analysis that combines market demand with internal supply:
- Skill name, category, and market demand level
- Number of employees with this skill
- Average years of experience across employees
- Percentage of skilled employees who are certified
- Average salary of employees with this skill
- Skills gap indicator (high demand, low internal supply)
- Only include skills where at least one employee is certified

**Question 1.1.4**: Client Project Portfolio Review
Create a client-focused analysis showing:
- Company name, industry, and annual revenue
- Project name, budget, and current status
- Project manager name and contact information
- Days since project start and days to planned completion
- Budget utilization percentage
- Team size and total allocated hours
- Only include companies with projects over $200,000 budget

**Question 1.1.5**: High-Value Employee Identification
Identify top-performing employees using multiple criteria:
- Employee name, title, and years of service
- Department and current manager
- Number of active projects and total hours committed
- Average hourly rate across all projects
- Total potential project earnings
- Skills count and certification percentage
- Performance score (combine multiple factors)
- Only include employees with 2+ active projects

---

## Exercise 2: Outer Join Applications (35 points)

### 2.1 LEFT JOIN for Comprehensive Analysis (7 points each)

**Question 2.1.1**: Complete Employee Integration Assessment
Create a comprehensive employee status report using LEFT JOINs:
- All active employees (regardless of assignments)
- Department assignment status (assigned/unassigned)
- Manager assignment status (has manager/no manager)
- Project involvement (number of projects, 0 if none)
- Skills registration status (has skills/no skills)
- Integration score based on completeness of assignments
- Flag employees requiring immediate attention

**Question 2.1.2**: Department Efficiency and Capacity Analysis
Build a complete department overview including empty departments:
- All departments (active and inactive)
- Current headcount (0 if no employees)
- Budget vs actual salary costs
- Project portfolio size and status
- Average employee efficiency across projects
- Skills coverage within department
- Capacity recommendations (hiring/restructuring needs)

**Question 2.1.3**: Project Staffing and Resource Gaps
Analyze all projects for staffing completeness:
- All projects in planning or active status
- Current team composition and size
- Required vs actual skill coverage
- Budget allocation vs team capacity
- Timeline risk assessment based on staffing
- Immediate staffing needs identification
- Resource reallocation recommendations

**Question 2.1.4**: Skills Development and Training Needs
Comprehensive skills gap analysis across the organization:
- All employees and their current skill portfolios
- Market-demanded skills vs internal capabilities
- Certification opportunities for each employee
- Training investment recommendations
- Career development pathway suggestions
- Skills that need immediate attention (high demand, low supply)

**Question 2.1.5**: Organizational Structure and Reporting Analysis
Complete organizational hierarchy and management analysis:
- All employees and their reporting relationships
- Management span of control analysis
- Employees without proper management structure
- BaseSalary progression through hierarchy levels
- Organizational efficiency indicators
- Management development opportunities

---

## Exercise 3: Advanced Multi-Table Integration (25 points)

### 3.1 Complex Business Intelligence Scenarios (12-13 points each)

**Question 3.1.1**: Strategic Workforce Planning Dashboard
Create an executive-level workforce analysis that integrates:
- Employee demographics and performance metrics
- Department efficiency and budget utilization
- Project portfolio health and resource allocation
- Skills inventory and market alignment
- Succession planning readiness indicators
- Financial ROI analysis for human capital investments
- Strategic recommendations for workforce optimization

**Technical Requirements:**
- Use at least 6 different tables
- Implement complex business logic with nested CASE statements
- Include rolling averages and trend calculations
- Handle all edge cases and NULL values appropriately
- Optimize query performance with proper indexing considerations

**Question 3.1.2**: Project Portfolio Risk and Opportunity Assessment
Develop a comprehensive project analysis system:
- Project financial health and budget forecasting
- Resource allocation efficiency and optimization opportunities
- Client relationship strength and revenue potential
- Timeline adherence and delivery risk factors
- Team composition effectiveness and collaboration metrics
- Market opportunity assessment and strategic value scoring
- Portfolio balancing recommendations

**Technical Requirements:**
- Combine data from all relevant tables
- Implement predictive scoring algorithms
- Use window functions for comparative analysis
- Include scenario modeling capabilities
- Present results in executive-ready format

---

## Exercise 4: Self Join and Hierarchical Analysis (20 points)

### 4.1 Organizational and Comparative Analysis (6-7 points each)

**Question 4.1.1**: Multi-Level Organizational Hierarchy
Build a comprehensive organizational structure analysis:
- Employee hierarchy up to 4 management levels
- Organizational path from employee to CEO
- Span of control analysis for each manager
- BaseSalary progression and equity analysis through levels
- Management effectiveness indicators
- Succession planning depth assessment
- Organizational optimization recommendations

**Question 4.1.2**: Employee Peer Comparison and Benchmarking
Create a sophisticated peer analysis system:
- Compare employees within same department and level
- BaseSalary equity analysis with experience adjustment
- Skills portfolio comparison and gaps
- Project performance benchmarking
- Career progression rate analysis
- Development recommendation engine
- Promotion readiness assessment

**Question 4.1.3**: Project Team Collaboration Analysis
Develop a team dynamics and collaboration assessment:
- Identify employees working on multiple shared projects
- Analyze cross-functional collaboration patterns
- Skills complementarity within project teams
- Workload distribution and balance analysis
- Team effectiveness scoring
- Collaboration network strength indicators
- Team optimization recommendations

---

## Exercise 5: Cross Join and Matrix Applications (15 points)

### 5.1 Strategic Planning and Scenario Analysis (7-8 points each)

**Question 5.1.1**: Comprehensive Resource Allocation Matrix
Generate a strategic resource planning analysis:
- All possible employee-project assignment scenarios
- Skills matching and gap analysis for each combination
- Capacity constraints and optimization opportunities
- Cost-benefit analysis for different allocation strategies
- Timeline impact assessment for resource changes
- Strategic recommendations for optimal allocation

**Question 5.1.2**: Skills Development and Career Planning Matrix
Create a comprehensive career development planning system:
- Employee-skill development pathway analysis
- Training investment scenarios and ROI calculations
- Certification pathway planning and timeline
- Career advancement opportunity mapping
- Skills market demand vs internal supply planning
- Strategic investment prioritization framework

---

## Advanced Integration Challenge (25 points)

### Comprehensive Business Intelligence Platform

**Challenge**: Build an integrated business intelligence system that provides complete organizational insights for executive decision-making.

**Requirements:**

**1. Financial Performance Module (8 points)**
- Department budget performance and forecasting
- Employee cost analysis and ROI calculations
- Project profitability and portfolio optimization
- Client value analysis and retention strategies

**2. Operational Excellence Module (8 points)**
- Resource utilization and efficiency metrics
- Project delivery performance and risk assessment
- Skills utilization and development tracking
- Quality indicators and improvement opportunities

**3. Strategic Planning Module (9 points)**
- Workforce planning and succession readiness
- Market opportunity analysis and capability gaps
- Growth scenario modeling and resource requirements
- Competitive advantage assessment and development strategies

**Technical Excellence Requirements:**
- Use all join types appropriately within the solution
- Implement complex business logic with proper error handling
- Optimize for performance with large datasets
- Include comprehensive data quality validation
- Present results in multiple formats (summary, detail, trend analysis)
- Document all business rules and assumptions

**Business Impact Requirements:**
- Provide actionable insights for immediate decision-making
- Include predictive indicators and early warning systems
- Support scenario planning and what-if analysis
- Enable drill-down capabilities from summary to detail
- Integrate financial, operational, and strategic perspectives

---

## Submission Guidelines

### Technical Requirements
1. **Query Optimization**: All queries must include execution plan analysis
2. **Error Handling**: Implement proper NULL handling and edge case management
3. **Documentation**: Comprehensive comments explaining business logic
4. **Performance**: Queries should execute efficiently on large datasets
5. **Formatting**: Consistent, professional SQL formatting standards

### Business Requirements
1. **Relevance**: Results must address real business needs
2. **Accuracy**: All calculations and logic must be verified
3. **Completeness**: Address all aspects of each requirement
4. **Presentation**: Format output for executive consumption
5. **Insights**: Include interpretation and recommendations

### Deliverables
1. **SQL Scripts**: Complete, tested query files
2. **Results Samples**: Representative output from each query
3. **Performance Analysis**: Execution plans and optimization notes
4. **Business Documentation**: Explanation of insights and recommendations
5. **Technical Documentation**: Query logic and design decisions

## Evaluation Criteria

### Technical Proficiency (40%)
- Correct implementation of all join types
- Query efficiency and performance optimization
- Proper handling of complex scenarios and edge cases
- Code quality, readability, and maintainability

### Business Application (35%)
- Relevance and value of analysis to business stakeholders
- Accuracy of business logic implementation
- Quality of insights and recommendations
- Professional presentation of results

### Problem Solving (15%)
- Creative approaches to complex requirements
- Integration of multiple concepts and techniques
- Handling of ambiguous or incomplete specifications
- Innovation in analysis methodology

### Documentation and Communication (10%)
- Clarity of technical documentation
- Quality of business explanations
- Professional presentation standards
- Completeness of deliverables

## Time Allocation Recommendations
- Exercise 1 (Inner Joins): 3 hours
- Exercise 2 (Outer Joins): 4 hours
- Exercise 3 (Advanced Integration): 3.5 hours
- Exercise 4 (Self Joins): 2.5 hours
- Exercise 5 (Cross Joins): 2 hours
- Advanced Challenge: 4 hours
- Documentation and Review: 1 hour
- **Total Recommended Time: 20 hours**

## Success Strategies

1. **Plan Before Coding**: Understand business requirements thoroughly
2. **Start with Simple Cases**: Build complexity incrementally
3. **Test with Sample Data**: Verify logic with known results
4. **Consider Performance**: Think about execution efficiency from the start
5. **Document Decisions**: Explain your approach and business logic
6. **Validate Results**: Cross-check calculations and verify business sense
7. **Think Like an Executive**: Present results for decision-making impact

This comprehensive exercise set will demonstrate your mastery of multi-table querying and prepare you for advanced database development and business intelligence roles.
