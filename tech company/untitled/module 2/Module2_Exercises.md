# Module 2 Exercises: T-SQL Fundamentals - TechCorp Solutions Business Scenarios

## Exercise Set Overview
These exercises test your understanding of T-SQL fundamentals using **TechCorp Solutions** business data. You'll work with realistic consulting company scenarios while mastering: Introducing T-SQL, Understanding Sets, Understanding Predicate Logic, and Understanding the Logical Order of Operations in SELECT Statements.

## 🏢 TechCorp Business Context
**TechCorp Solutions** is your learning environment - a technology consulting company with 145 employees working on software development, cloud migration, and cybersecurity projects for clients ranging from startups to enterprises.

## Instructions
- Complete all exercises in order using TechCorp's database
- Write your SQL queries clearly with proper formatting
- Test your queries against the TechCorpDB database
- Include business-focused comments explaining your logic
- Think about how each query helps TechCorp make business decisions

---

## Exercise 1: T-SQL Basics (25 points)

### 1.1 Basic Queries (5 points each)

**Question 1.1.1**: TechCorp HR needs a comprehensive employee directory. Write a query to display all TechCorp employee information formatted for business use:
- Full name as "LastName, FirstName MiddleInitial" (handle NULL middle names gracefully)
- BaseSalary formatted with currency symbol and commas for HR reports
- Years of service as a whole number for recognition programs
- WorkEmail domain only (part after @) to identify external vs company emails
- Include department information for organizational clarity

**Question 1.1.2**: TechCorp's compensation team needs to analyze BaseSalary bands for their technology consulting roles. Create a query that categorizes TechCorp employees based on their BaseSalary ranges:
- "Junior Consultant": < $60,000 (entry-level developers, analysts)
- "Consultant": $60,000 - $80,000 (mid-level engineers, project coordinators)
- "Senior Consultant": $80,000 - $110,000 (senior developers, team leads)
- "Principal Consultant": > $110,000 (architects, directors, VPs)
Show employee name, department, BaseSalary, and consulting level category.

**Question 1.1.3**: Write a query to find the employee(s) with the longest tenure in each department. Include department name, employee name, and years of service.

**Question 1.1.4**: Create a query that shows employees hired in the same month across different years. Group results by month and show hire month, year, and employee details.

**Question 1.1.5**: Write a query to identify potential email conflicts by finding employees whose first name and last name combination could create duplicate email addresses (ignoring middle names).

---

## Exercise 2: Set Operations and Logic (30 points)

### 2.1 Set Operations (6 points each)

**Question 2.1.1**: TechCorp's executive team wants to identify high-investment departments for strategic planning. Using set operations, create a report that shows:
- All TechCorp departments that either have a budget > $500,000 OR have employees with average BaseSalary > $75,000
- Use UNION to combine these two investment criteria
- Show department name, location, and the reason (high budget or high salaries) why it was included
- This helps TechCorp understand where they're making significant investments in talent and operations

**Question 2.1.2**: Find employees who work on projects with the same status as their department's primary focus:
- Use INTERSECT to find the overlap between employee project statuses and some business rule
- Assume IT projects should be "In Progress", Marketing should be "Completed"

**Question 2.1.3**: Using EXCEPT, find employees who:
- Are in departments with budget > $250,000 
- BUT are not assigned to any projects
- Show why this might be a management concern

**Question 2.1.4**: Create a query using multiple set operations to categorize all employees into:
- "Project Leaders": Work on 2+ projects
- "Contributors": Work on exactly 1 project  
- "Available": Not assigned to any projects
Use appropriate set operations to create these categories.

**Question 2.1.5**: Write a query to find "skill gaps" by identifying:
- Employees who work on projects but lack certain qualifications
- Use set operations to compare required vs. actual employee assignments

### 2.2 Complex Predicates (6 points each)

**Question 2.2.1**: Write a query with complex predicate logic to find employees who meet ALL of these criteria:
- Hired after 2020 OR have BaseSalary > $80,000
- Work in departments with budget > $200,000
- Either have no middle name OR their title contains "Director"
- Are currently active

**Question 2.2.2**: Create a query using EXISTS to find departments where:
- At least one employee earns more than the department's average BaseSalary
- At least one project is assigned to department employees
- The department budget is justified by employee productivity

**Question 2.2.3**: Write a query using NOT EXISTS to identify:
- Projects with no employee assignments
- Departments with no active projects
- Potential resource allocation issues

---

## Exercise 3: Logical Order Understanding (25 points)

### 3.1 Processing Order Analysis (8 points each)

**Question 3.1.1**: Given this query, explain the logical processing order and identify any issues:
```sql
SELECT d.DepartmentName, AVG(e.BaseSalary) as AvgSal, TeamSize
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE TeamSize > 2
GROUP BY d.DepartmentName
HAVING AVG(e.BaseSalary) > 60000
ORDER BY AvgSal DESC;
```
What's wrong with this query and how would you fix it?

**Question 3.1.2**: Analyze this query and explain why it fails, then provide the correct version:
```sql
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    ProjectCount,
    CASE WHEN ProjectCount > 1 THEN 'Multi-Project' ELSE 'Single-Project' END AS Category
FROM Employees e
LEFT JOIN (
    SELECT EmployeeID, COUNT(*) AS ProjectCount
    FROM EmployeeProjects 
    GROUP BY EmployeeID
) p ON e.EmployeeID = p.EmployeeID
WHERE Category = 'Multi-Project'
ORDER BY ProjectCount DESC;
```

**Question 3.1.3**: Create a query that demonstrates the difference between WHERE and HAVING by:
- Filtering employees hired after 2020 (use WHERE)
- Grouping by department
- Showing only departments with average BaseSalary > $65,000 (use HAVING)
- Explain why each filter belongs in its respective clause

---

## Exercise 4: Advanced Integration (20 points)

### 4.1 Comprehensive Scenarios (10 points each)

**Question 4.1.1**: **Management Dashboard Query**
Create a single query that provides a management dashboard showing:
- Department performance metrics (employee count, avg BaseSalary, project count)
- Resource utilization (total hours allocated vs worked across all projects)
- Department ranking based on productivity
- Identify departments that may need attention
Use multiple concepts: joins, aggregation, window functions, case statements, and proper filtering.

**Question 4.1.2**: **Employee Career Path Analysis**
Write a query to analyze career progression by:
- Comparing employees' current roles with their hiring positions
- Identifying promotion patterns within departments
- Finding employees ready for advancement (based on tenure, performance, BaseSalary relative to peers)
- Suggesting career development opportunities
Use subqueries, CTEs, ranking functions, and complex predicates.

---

## Bonus Challenge (10 points)

### Advanced Problem Solving

**Bonus Question**: **Resource Optimization Problem**
You're tasked with optimizing project resource allocation. Create a comprehensive solution that:

1. Identifies overallocated employees (working more hours than allocated)
2. Finds underutilized employees (working fewer hours than allocated or not assigned)
3. Suggests project reassignments to balance workload
4. Calculates the impact of proposed changes on project timelines
5. Provides a priority ranking for management action

Your solution should use:
- Multiple CTEs for different analysis components
- Set operations to compare different employee groups
- Complex predicates for business rule implementation
- Window functions for ranking and comparison
- Proper logical ordering for optimal performance

Requirements:
- Query must be efficient and well-commented
- Results must be actionable for management
- Include explanation of your approach and business reasoning

---

## Submission Guidelines

1. **Code Quality**: Write clean, well-formatted SQL with meaningful variable names and comments
2. **Testing**: Verify all queries execute successfully against the sample database
3. **Documentation**: Include brief explanations for complex logic
4. **Performance**: Consider query efficiency, especially for bonus questions
5. **Business Logic**: Ensure results make business sense and are actionable

## Grading Criteria

- **Correctness (40%)**: Queries produce accurate results
- **Code Quality (25%)**: Clean, readable, well-documented code
- **Complexity Handling (20%)**: Proper use of advanced T-SQL concepts
- **Business Understanding (15%)**: Results are meaningful and actionable

## Time Allocation
- Exercises 1-2: 2 hours
- Exercise 3: 1.5 hours
- Exercise 4: 2 hours
- Bonus: 1 hour
- **Total Recommended Time: 6.5 hours**

Good luck! These exercises will solidify your understanding of T-SQL fundamentals and prepare you for advanced database development challenges.
