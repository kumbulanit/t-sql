# Module 10 Lab: Advanced Data Visualization and Reporting

## Lab Overview

This lab provides hands-on practice with advanced data visualization techniques, result formatting, chart creation, and professional report generation using the TechCorp Solutions database.

## Learning Objectives

- Apply advanced formatting techniques to create professional reports
- Generate charts and visual representations from SQL data
- Create interactive dashboards and summaries
- Master export formats for different business needs

## Prerequisites

- Complete understanding of Modules 1-9
- Access to TechCorp Solutions sample database
- SQL Server Management Studio (SSMS)
- Basic understanding of data presentation principles

---

## Lab Exercise 1: Professional Employee Directory (25 points)

### Objective
Create a comprehensive, professionally formatted employee directory with multiple visualization options.

### Task 1.1: Basic Directory Format (8 points)
Create an employee directory with the following specifications:

```sql
-- Your solution here
-- Requirements:
-- 1. Employee ID padded to 4 digits with leading zeros
-- 2. Full name in "Last, First Middle" format (handle nulls properly)
-- 3. Job title with department in parentheses
-- 4. Hire date in "Month DD, YYYY" format
-- 5. Years of service calculated and displayed as "X years, Y months"
-- 6. Salary formatted as currency with appropriate grouping
-- 7. Contact information formatted as "(XXX) XXX-XXXX"
```

### Task 1.2: Visual Status Indicators (8 points)
Add visual status indicators to the directory:

```sql
-- Your solution here
-- Requirements:
-- 1. Tenure category with icons (🆕 New, ⭐ Experienced, 🏆 Veteran)
-- 2. Salary performance level with visual bars
-- 3. Department color coding suggestions
-- 4. Employee status risk assessment indicators
```

### Task 1.3: Executive Summary Section (9 points)
Create an executive summary header for the directory:

```sql
-- Your solution here
-- Requirements:
-- 1. Report generation timestamp and user information
-- 2. Total employee count by department with percentages
-- 3. Salary distribution summary with ranges
-- 4. New hire statistics for last 12 months
-- 5. Professional formatting with borders and alignment
```

---

## Lab Exercise 2: Project Portfolio Dashboard (25 points)

### Objective
Build a comprehensive project portfolio dashboard with charts and visual indicators.

### Task 2.1: Project Status Pie Chart Data (8 points)
Prepare data suitable for pie chart creation:

```sql
-- Your solution here
-- Requirements:
-- 1. Project count by status with percentages
-- 2. Budget allocation by status with visual representation
-- 3. Client distribution analysis
-- 4. Include data validation and completeness checks
-- 5. Format for easy copy/paste into Excel for chart creation
```

### Task 2.2: Budget Analysis with Visual Bars (9 points)
Create budget analysis with ASCII-based visual elements:

```sql
-- Your solution here
-- Requirements:
-- 1. Budget vs actual cost comparison with progress bars
-- 2. Department-wise project investment visualization
-- 3. Over-budget project identification with warning indicators
-- 4. Timeline analysis with milestone tracking
-- 5. ROI calculations where applicable
```

### Task 2.3: Interactive Project Browser (8 points)
Design a drill-down project browser:

```sql
-- Your solution here
-- Requirements:
-- 1. Hierarchical display: Company → Department → Project → Details
-- 2. Pagination simulation with page navigation info
-- 3. Search functionality with term highlighting
-- 4. Sort options with visual direction indicators
-- 5. Filter by status, budget range, and date range
```

---

## Lab Exercise 3: Financial Summary Reports (25 points)

### Objective
Generate comprehensive financial reports with multiple format options and advanced calculations.

### Task 3.1: Monthly Financial Dashboard (10 points)
Create a monthly financial summary dashboard:

```sql
-- Your solution here
-- Requirements:
-- 1. Month-over-month revenue/cost analysis
-- 2. Department budget utilization with traffic light indicators
-- 3. Payroll cost analysis with trend arrows
-- 4. Project profitability rankings
-- 5. Cash flow indicators and projections
```

### Task 3.2: Multi-Format Export System (8 points)
Design the same report in multiple output formats:

```sql
-- Format 1: Screen Display (with visual elements)
-- Your screen format solution here

-- Format 2: CSV Export (clean data for Excel)
-- Your CSV format solution here

-- Format 3: JSON Structure (for web APIs)
-- Your JSON format solution here

-- Format 4: Print-Friendly (formatted for paper)
-- Your print format solution here
```

### Task 3.3: Executive Financial Summary (7 points)
Create an executive-level financial summary:

```sql
-- Your solution here
-- Requirements:
-- 1. Key financial metrics with benchmarks
-- 2. Performance indicators with traffic light system
-- 3. Variance analysis with explanatory notes
-- 4. Risk assessment with mitigation recommendations
-- 5. Professional formatting suitable for board presentation
```

---

## Lab Exercise 4: Custom Analytics and Insights (25 points)

### Objective
Create advanced analytics reports with predictive insights and trend analysis.

### Task 4.1: Predictive Analytics Report (10 points)
Generate a report with predictive insights:

```sql
-- Your solution here
-- Requirements:
-- 1. Employee retention risk scoring
-- 2. Salary progression trend analysis
-- 3. Department growth/decline predictions
-- 4. Project success probability indicators
-- 5. Resource allocation optimization suggestions
```

### Task 4.2: Comparative Analysis Dashboard (8 points)
Build a comparative analysis dashboard:

```sql
-- Your solution here
-- Requirements:
-- 1. Year-over-year comparison with percentage changes
-- 2. Department benchmarking against company averages
-- 3. Industry standard comparisons (simulated)
-- 4. Performance ranking with quartile classifications
-- 5. Best/worst performer identification
```

### Task 4.3: Interactive Drill-Down Report (7 points)
Create a multi-level drill-down report:

```sql
-- Your solution here
-- Requirements:
-- 1. Company-wide overview level
-- 2. Department detail level
-- 3. Individual employee level
-- 4. Project detail level
-- 5. Navigation breadcrumbs and level indicators
```

---

## Bonus Challenge: Advanced Visualization (Extra 10 points)

### Creative Visualization Challenge
Create an innovative data visualization using only SQL:

```sql
-- Your creative solution here
-- Suggestions:
-- 1. Organization chart using ASCII art
-- 2. Gantt chart representation for project timelines
-- 3. Heat map simulation for department performance
-- 4. Network diagram showing employee relationships
-- 5. Geographic distribution map (text-based)
```

---

## Lab Deliverables and Evaluation

### Required Deliverables

1. **Completed SQL scripts** for all exercises with proper formatting
2. **Documentation** explaining your design choices and formatting decisions
3. **Sample outputs** showing the formatted results
4. **Export examples** demonstrating different output formats

### Evaluation Criteria

**Technical Accuracy (40%)**
- Correct SQL syntax and logic
- Proper data formatting and calculations
- Appropriate use of functions and techniques

**Professional Presentation (30%)**
- Clean, readable output formatting
- Consistent styling and alignment
- Effective use of visual indicators

**Business Value (20%)**
- Reports address real business needs
- Insights are actionable and relevant
- Data is presented in context

**Innovation and Creativity (10%)**
- Creative use of formatting techniques
- Innovative visualization approaches
- Professional design considerations

### Submission Guidelines

1. **File naming**: `Module10_Lab_[YourName]_[ExerciseNumber].sql`
2. **Comments**: Include detailed comments explaining your approach
3. **Testing**: Verify all queries execute without errors
4. **Documentation**: Provide brief documentation for each solution

### Additional Resources

- SQL Server FORMAT function documentation
- SSMS result formatting options
- Excel chart creation from SQL data
- Professional report design principles

### Time Allocation

- **Total lab time**: 4 hours
- **Exercise 1**: 60 minutes
- **Exercise 2**: 60 minutes  
- **Exercise 3**: 60 minutes
- **Exercise 4**: 60 minutes
- **Documentation and review**: 30 minutes

### Success Indicators

Upon completion, you should be able to:
- Create professional-quality formatted reports
- Generate chart-ready data from SQL queries
- Design responsive and adaptive result layouts
- Export data in multiple formats for different tools
- Apply advanced formatting techniques consistently

---

## Getting Started

1. **Set up your environment**: Ensure you have access to the TechCorp database
2. **Review requirements**: Read through all exercises before starting
3. **Plan your approach**: Consider the formatting and presentation needs
4. **Start with basics**: Begin with simple formatting and build complexity
5. **Test frequently**: Verify your output at each step
6. **Document choices**: Explain your design decisions

Good luck with your advanced data visualization and reporting lab!