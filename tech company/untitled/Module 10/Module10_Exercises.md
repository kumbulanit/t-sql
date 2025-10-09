
# Module 10 Exercises: Easy Charts and Reports (Beginner Friendly)

## What Are These Exercises?

These are simple practice problems to help you get comfortable making your data look good. You’ll learn how to make charts, format your results, and create easy-to-read reports—step by step!

## How to Do These Exercises

- Try each exercise in order (they start easy and get a little harder)
- Don’t worry if you’re new—just do your best!
- Use the examples in the lessons to help you
- Ask for help if you get stuck
- Have fun making your data look awesome!

---

---

## 🟢 Exercise 1: Making Pretty Employee Lists (25 points)

### Easy Practice: Making Employee Information Look Professional

Think of this like making a nice business card or name tag for each employee!

### 🎯 Question 1.1.1: Making a Professional Employee Directory (5 points)

**Your Goal**: Make an employee list that looks like it belongs in a professional company directory.

**What you need to do (step by step):**

1. **Employee ID with leading zeros**: Turn "42" into "0042" (like making all ID badges the same length)
2. **Full name format**: Turn "John" "Smith" into "Smith, John" (like how phone books list names)
3. **Job title with department**: Turn "Developer" in "IT" into "Developer [IT]"
4. **Pretty hire date**: Turn "2023-03-15" into "15-Mar-2023" (easier to read)
5. **How long they've worked**: Turn hire date into "2 years, 3 months"

**Hint**: Use FORMAT, CONCAT, and CASE like we learned in the lessons!

**What your result should look like:**
```
EmployeeID: 0042
FullName: Smith, John M.  
JobInfo: Developer [IT]
HireDate: 15-Mar-2021
Tenure: 3 years, 6 months
```

### 🎯 Question 1.1.2: Making a Salary Report with Star Ratings (5 points)

**Your Goal**: Create a fun report that shows who earns what, with star ratings like a video game!

**What you need to do (in plain English):**

1. **Add star ratings**: Give people stars based on salary (★ = Entry, ★★ = Good, ★★★ = Excellent)
2. **Make money pretty**: Turn "75000" into "$75,000" (with commas and dollar sign)
3. **Compare to average**: Show if someone earns more or less than others in their department
4. **Give salary levels**: Entry Level, Mid Level, Senior Level, Executive Level
5. **Make text bars**: Use characters like ████ to show salary size visually

**What your result should look like:**
```
John Smith ★★ | $75,000 | 15% above average | Senior Level | ████████
```

**Question 1.1.3**: Design a contact directory format displaying:
- Employee name with job title on separate lines
- Department and location information
- Formatted phone number as (XXX) XXX-XXXX
- Email address in lowercase
- Complete mailing address on multiple lines

**Question 1.1.4**: Create a skills matrix visualization:
- Employee name with skill count indicator
- Primary skills listed with proficiency levels (●●●○○)
- Skills grouped by category with headers
- Years of experience in each skill area
- Skill rarity indicator (Common, Uncommon, Rare)

**Question 1.1.5**: Develop a project assignment summary:
- Employee name with current project status
- Project timeline with visual progress bar
- Budget responsibility and utilization percentage
- Team role and reporting structure
- Workload indicator with capacity assessment

### 1.2 Executive Dashboard Formatting (5 points each)

**Question 1.2.1**: Build a company metrics dashboard:
- Key performance indicators with status icons (🔴🟡🟢)
- Month-over-month change indicators (↗️↘️➡️)
- Percentage achievements with visual progress bars
- Target vs actual comparisons with variance analysis
- Professional border and section separators

## Exercise 2: Chart Data Preparation and Visualization (25 points)

### 2.1 Pie Chart Data Generation (5 points each)

**Question 2.1.1**: Prepare department distribution data for pie charts:
- Employee count by department with percentages
- Include data labels suitable for chart legends
- Calculate slice angles for 360-degree representation
- Provide color scheme recommendations
- Format for direct Excel import

**Question 2.1.2**: Create project budget allocation chart data:
- Budget amounts by project status with percentages
- Include total budget validation
- Provide hierarchical grouping options
- Calculate cumulative percentages
- Add drill-down category information

**Question 2.1.3**: Generate skills distribution visualization data:
- Skill categories with employee counts
- Include proficiency level breakdowns
- Calculate market value indicators
- Provide trend analysis data points
- Format for web chart libraries (JSON-like)

**Question 2.1.4**: Build salary range distribution data:
- Salary brackets with employee counts and percentages
- Include gender distribution within ranges
- Calculate median and average for each range
- Provide benchmark comparison data
- Add statistical significance indicators

**Question 2.1.5**: Design project timeline chart data:
- Monthly project start/completion counts
- Include budget impact by time period
- Calculate resource utilization by month
- Provide seasonal trend indicators
- Format for Gantt chart representation

### 2.2 Advanced Visual Elements (5 points each)

**Question 2.2.1**: Create ASCII-based bar charts:
- Department budget comparison with scaled bars
- Include numerical values and percentages
- Add axis labels and scale indicators
- Provide legend and explanation
- Use consistent character width formatting

## Exercise 3: Professional Report Generation (25 points)

### 3.1 Multi-Section Reports (5 points each)

**Question 3.1.1**: Generate a comprehensive quarterly business report:
- Executive summary with key highlights
- Department performance analysis with visual indicators
- Financial metrics with trend arrows
- Risk assessment with mitigation suggestions
- Professional headers, footers, and page breaks

**Question 3.1.2**: Create an employee performance review report:
- Individual performance metrics with ratings
- Goal achievement tracking with progress bars
- Skill development recommendations
- Career progression pathway visualization
- 360-degree feedback summary formatting

**Question 3.1.3**: Build a project portfolio status report:
- Project health dashboard with traffic lights
- Budget variance analysis with explanations
- Timeline adherence with milestone tracking
- Resource allocation optimization suggestions
- Client satisfaction indicators

**Question 3.1.4**: Design a financial compliance report:
- Regulatory requirement tracking
- Audit trail formatting with timestamps
- Exception reporting with severity levels
- Approval workflow status indicators
- Document reference and validation

**Question 3.1.5**: Develop a strategic planning report:
- Market analysis with competitive positioning
- Growth opportunity identification
- Resource requirement forecasting
- Risk/reward analysis matrices
- Implementation timeline with dependencies

### 3.2 Interactive Report Elements (5 points each)

**Question 3.2.1**: Create a drill-down organizational report:
- Company overview with expansion capabilities
- Department details with employee listings  
- Individual profile access with full information
- Cross-reference navigation between levels
- Breadcrumb navigation indicators

## Exercise 4: Custom Output Formats and Export Options (25 points)

### 4.1 Multi-Format Export System (5 points each)

**Question 4.1.1**: Design the same data in four different formats:
- Screen display with visual enhancements
- CSV export with clean data structure  
- JSON format for API consumption
- Print-friendly format with page breaks
- Excel-ready format with formulas

**Question 4.1.2**: Create responsive layout adaptations:
- Mobile-friendly single column layout
- Tablet optimized two-column format
- Desktop multi-panel dashboard
- Print version with minimal graphics
- Email format with inline styles

**Question 4.1.3**: Build automated report templates:
- Parameter-driven content selection
- Dynamic date range calculations
- User role-based data filtering
- Automated scheduling metadata
- Error handling and validation

**Question 4.1.4**: Generate web-ready visualization data:
- HTML table format with CSS classes
- JavaScript chart data structures
- SVG-compatible data coordinates
- REST API response formatting
- Real-time dashboard data feeds

**Question 4.1.5**: Create presentation-ready outputs:
- PowerPoint slide data formatting
- Executive briefing summaries
- Board meeting report formats
- Stakeholder communication templates
- Media-ready infographic data

## Bonus Challenge Questions (Extra Credit)

### Advanced Visualization Techniques

**Bonus 1**: Create a text-based organization chart using SQL:
- Show hierarchical reporting relationships
- Include employee names and titles
- Use ASCII art for connection lines
- Provide department grouping indicators
- Handle complex reporting structures

**Bonus 2**: Generate a project Gantt chart representation:
- Timeline visualization with task dependencies
- Resource allocation indicators
- Milestone markers and deadlines
- Progress tracking with completion percentages
- Critical path highlighting

**Bonus 3**: Design a geographic distribution map:
- Text-based representation of office locations
- Employee distribution by region
- Travel pattern analysis
- Cost center allocation by geography
- Market penetration visualization

## Evaluation Rubric

### Technical Excellence (40%)
- Correct SQL syntax and execution
- Proper use of formatting functions
- Accurate calculations and data handling
- Error-free query execution

### Professional Presentation (35%)
- Clean, readable output formatting
- Consistent styling and alignment
- Effective use of visual indicators
- Professional appearance standards

### Business Value (15%)
- Reports address real business needs
- Data provides actionable insights
- Information is relevant and timely
- Presentation suits target audience

### Innovation (10%)
- Creative formatting approaches
- Unique visualization techniques
- Effective use of available tools
- Professional design thinking

## Submission Requirements

1. **File Format**: Save each exercise as separate .sql files
2. **Naming Convention**: Module10_Exercise_[Number]_[YourName].sql  
3. **Documentation**: Include comments explaining your approach
4. **Sample Output**: Provide screenshots or text output examples
5. **Explanation**: Brief summary of design choices and techniques used

## Time Management Suggestions

- **Exercise 1**: 45 minutes (focus on formatting accuracy)
- **Exercise 2**: 45 minutes (emphasize visualization creativity)  
- **Exercise 3**: 60 minutes (prioritize professional appearance)
- **Exercise 4**: 45 minutes (ensure export compatibility)
- **Review and Testing**: 15 minutes

## Success Criteria

Upon completion, you should demonstrate:
- Mastery of advanced SQL formatting functions
- Ability to create chart-ready data from SQL queries
- Skills in professional report generation
- Competency in multi-format data export
- Understanding of business presentation requirements

## Getting Help

- Review Module 10 lessons for formatting techniques
- Consult SQL Server documentation for function syntax
- Test formatting with small data sets first
- Verify output in different viewing environments
- Ask for clarification on business requirements

Good luck with your data visualization and reporting exercises!