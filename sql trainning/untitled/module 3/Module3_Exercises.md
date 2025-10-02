# Module 3 Exercises: Writing Basic SELECT Statements

## Exercise Set Overview
These exercises test your mastery of fundamental SELECT statement concepts: basic queries, DISTINCT operations, aliases, and CASE expressions. Each exercise builds upon previous concepts while introducing new challenges.

## Instructions
- Complete all exercises in order
- Write clean, well-formatted SQL queries
- Use meaningful aliases throughout
- Include comments for complex logic
- Test all queries against the sample database

---

## Exercise 1: SELECT Statement Fundamentals (20 points)

### 1.1 Basic Query Construction (4 points each)

**Question 1.1.1**: Create a query to display employee information with the following requirements:
- Show employee full name (handle middle names properly)
- Display formatted salary as currency
- Calculate and show age in years
- Show hire date in "Month DD, YYYY" format
- Include phone number formatted as (XXX) XXX-XXXX

**Question 1.1.2**: Build a project analysis query that shows:
- Project name and status
- Budget utilization percentage (actual cost / budget * 100)
- Days elapsed since project start
- Projected vs actual timeline variance in days
- Client type classification (Internal vs External)

**Question 1.1.3**: Create a department overview showing:
- Department name and location
- Budget formatted with commas and dollar sign
- Cost center information
- Manager information (if available)
- Department size category based on budget ranges

**Question 1.1.4**: Write a query for employee contact management:
- Employee name and title
- Complete address (city, state)
- All contact information formatted properly
- Emergency contact details
- Email domain classification (company vs external)

**Question 1.1.5**: Develop a skills inventory query displaying:
- Skill name and category
- Difficulty level assessment
- Usage frequency (count of employees with this skill)
- Experience level distribution
- Certification requirements indicator

---

## Exercise 2: DISTINCT Operations and Data Analysis (25 points)

### 2.1 Data Profiling with DISTINCT (5 points each)

**Question 2.1.1**: Perform a comprehensive data uniqueness analysis:
- Count total records vs unique values for key fields
- Identify potential data quality issues
- Show percentage of unique values for each analyzed field
- Highlight fields with high duplication rates
- Recommend data cleanup priorities

**Question 2.1.2**: Create a location diversity analysis:
- Find all unique city/state combinations
- Identify geographic distribution patterns
- Show employee concentration by location
- Analyze remote vs office-based work patterns
- Determine optimal office locations

**Question 2.1.3**: Analyze project portfolio diversity:
- Find unique combinations of status, priority, and client type
- Identify project distribution patterns
- Show resource allocation across different project types
- Analyze client engagement patterns
- Determine project management capacity

**Question 2.1.4**: Conduct a skills diversity assessment:
- Find unique skill category and difficulty combinations
- Analyze skill distribution across the organization
- Identify skill gaps and oversupply areas
- Show certification vs non-certification patterns
- Determine training program priorities

**Question 2.1.5**: Perform organizational structure analysis:
- Find unique department and title combinations
- Identify career path diversity within departments
- Analyze management structure patterns
- Show hierarchy distribution
- Determine organizational complexity metrics

---

## Exercise 3: Advanced Alias Implementation (20 points)

### 3.1 Professional Reporting with Aliases (4 points each)

**Question 3.1.1**: Create an Executive Summary Report with aliases that:
- Use professional business terminology
- Include calculated KPIs with meaningful names
- Show financial metrics with appropriate formatting
- Display time-based analyses with clear descriptions
- Present data ready for board-level presentation

**Question 3.1.2**: Build a Human Resources Dashboard with:
- Employee lifecycle stage indicators
- Compensation analysis with market position terms
- Performance metrics using business language
- Diversity and inclusion measurements
- Retention risk assessments with clear naming

**Question 3.1.3**: Develop a Project Management Dashboard featuring:
- Resource utilization metrics with industry-standard names
- Timeline analysis using project management terminology
- Budget performance indicators with financial terms
- Risk assessment categories with standard classifications
- Quality metrics using accepted project management language

**Question 3.1.4**: Create a Skills Development Report with:
- Competency mapping using HR terminology
- Career development pathways with professional names
- Training effectiveness metrics
- Certification tracking with industry-standard terms
- Skills gap analysis using workforce development language

**Question 3.1.5**: Design a Financial Performance Report showing:
- Cost center analysis with accounting terminology
- Budget variance reporting with financial language
- ROI calculations with investment terminology
- Efficiency metrics using operational terms
- Strategic alignment indicators with business language

---

## Exercise 4: Complex CASE Expression Logic (25 points)

### 4.1 Business Rule Implementation (5 points each)

**Question 4.1.1**: Implement a comprehensive employee performance rating system using CASE expressions:
- Base rating on multiple criteria: tenure, salary progression, project involvement
- Include department-specific performance indicators
- Account for role-level expectations
- Implement bonus eligibility determination
- Create development recommendations based on performance profile

**Question 4.1.2**: Design a project risk assessment system that:
- Evaluates budget variance, timeline adherence, and resource allocation
- Considers client type and project complexity
- Includes early warning indicators for troubled projects
- Provides actionable recommendations for project managers
- Implements escalation criteria for executive attention

**Question 4.1.3**: Create a dynamic compensation analysis tool:
- Implement market positioning logic based on role, tenure, and performance
- Include cost-of-living adjustments by location
- Calculate retention risk based on compensation competitiveness
- Determine promotion readiness using multiple criteria
- Provide salary adjustment recommendations

**Question 4.1.4**: Build an intelligent resource allocation system:
- Assess employee availability based on current project load
- Evaluate skill matching for project requirements
- Consider employee career development goals
- Implement workload balancing logic
- Create capacity planning recommendations

**Question 4.1.5**: Design a strategic workforce planning tool:
- Classify employees by potential and performance
- Identify succession planning candidates
- Assess skills portfolio strength and gaps
- Evaluate retention strategies by employee segment
- Provide strategic hiring recommendations

---

## Exercise 5: Integrated Business Intelligence (30 points)

### 5.1 Comprehensive Business Analysis (15 points each)

**Question 5.1.1**: **Strategic Workforce Analytics Dashboard**
Create a comprehensive query that combines all module concepts to deliver:

**Requirements:**
- Employee segmentation using complex CASE logic (high/medium/low performers)
- Skills portfolio analysis with gap identification
- Career development pathway recommendations
- Retention risk assessment with actionable insights
- Succession planning readiness indicators
- ROI analysis for training and development investments

**Technical Requirements:**
- Use meaningful aliases throughout for business presentation
- Implement nested CASE expressions for complex business rules
- Use DISTINCT appropriately for data deduplication
- Include calculated fields for all key metrics
- Format all output for executive consumption

**Business Logic:**
- Performance rating: Combine salary progression, tenure, project success
- Retention risk: Consider market positioning, workload, career growth
- Development priority: Based on skills gaps, role requirements, career aspirations
- Succession readiness: Evaluate leadership potential, experience, skills

**Question 5.1.2**: **Project Portfolio Optimization Engine**
Develop a sophisticated project analysis system that:

**Requirements:**
- Project health scoring using multiple performance indicators
- Resource optimization recommendations across all active projects
- Timeline and budget forecasting with risk assessments
- Client satisfaction indicators and relationship management insights
- Strategic alignment scoring for project prioritization
- Capacity planning for future project intake

**Technical Requirements:**
- Advanced CASE expressions for multi-criteria decision logic
- Professional aliases for all business metrics
- Complex calculations with proper NULL handling
- DISTINCT operations for eliminating data redundancy
- Integration of financial, operational, and strategic metrics

**Business Logic:**
- Health score: Budget adherence + timeline performance + resource efficiency
- Risk assessment: Client type + project complexity + team experience + budget size
- Priority ranking: Strategic value + client importance + resource requirements
- Capacity impact: Current utilization + skill requirements + timeline constraints

---

## Bonus Challenge: Advanced Integration (10 points)

### Executive Decision Support System

**Challenge**: Build a comprehensive executive dashboard query that integrates all Module 3 concepts to support strategic decision-making.

**Requirements:**
1. **Employee Excellence Engine**: Identify top performers, flight risks, and development candidates
2. **Project Success Predictor**: Forecast project outcomes and recommend interventions
3. **Skills Investment Optimizer**: Determine optimal training and hiring strategies
4. **Organizational Health Monitor**: Assess department effectiveness and balance

**Technical Constraints:**
- Single query result set suitable for executive visualization
- All business rules implemented through CASE expressions
- Professional aliases suitable for board presentation
- Optimized for performance and maintainability
- Comprehensive NULL handling and edge case management

**Business Impact:**
- Support hiring decisions with data-driven recommendations
- Optimize resource allocation across projects and departments
- Identify strategic risks and opportunities
- Provide actionable insights for organizational development

---

## Submission Guidelines

### Code Quality Standards
1. **Formatting**: Consistent indentation, capitalization, and spacing
2. **Comments**: Explain complex business logic and calculations
3. **Aliases**: Use professional, meaningful names throughout
4. **Error Handling**: Proper NULL handling and edge case management

### Documentation Requirements
1. **Business Logic Explanation**: Document the reasoning behind CASE expression conditions
2. **Assumption Documentation**: List any assumptions made about data or business rules
3. **Testing Notes**: Include verification steps for calculated fields
4. **Performance Considerations**: Note any potential optimization opportunities

### Evaluation Criteria

**Technical Proficiency (40%)**
- Correct syntax and query execution
- Proper use of DISTINCT, aliases, and CASE expressions
- Appropriate data type handling and conversions

**Business Logic Implementation (35%)**
- Realistic and practical business rules
- Comprehensive condition coverage in CASE expressions
- Meaningful categorizations and classifications

**Code Quality and Presentation (25%)**
- Professional formatting and organization
- Meaningful aliases and clear code structure
- Comprehensive documentation and comments

### Time Allocation
- Exercise 1: 1.5 hours
- Exercise 2: 2 hours  
- Exercise 3: 1.5 hours
- Exercise 4: 2.5 hours
- Exercise 5: 3 hours
- Bonus Challenge: 1.5 hours
- **Total Recommended Time: 12 hours**

### Success Tips
1. **Build Incrementally**: Start with simple queries and add complexity gradually
2. **Test Frequently**: Verify each component before combining with others
3. **Think Business First**: Consider the business value of each query result
4. **Document Decisions**: Explain your logic for complex CASE conditions
5. **Format Professionally**: Treat every query as a potential production report
6. **Validate Results**: Cross-check calculations and verify business logic

This exercise set will demonstrate your mastery of fundamental SELECT statement concepts and prepare you for advanced T-SQL development challenges.
