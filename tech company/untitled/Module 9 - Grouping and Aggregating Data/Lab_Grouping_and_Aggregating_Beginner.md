# Lab: Practice Your Data Counting and Grouping Skills - Beginner Lab

## 🎯 Practice What You've Learned (🟢 COMPLETE BEGINNER LEVEL)

Welcome to your practice lab! This lab is designed for complete beginners who want to practice the basics of counting, adding, and grouping data. No experience necessary - just follow along and try each exercise.

## 📖 What You'll Practice

In this lab, you will practice:

- **Counting things** in your database
- **Adding up numbers** (like salaries and budgets)  
- **Finding averages** and extremes (highest/lowest)
- **Grouping data** by categories
- **Filtering groups** to show only what you want
- **Answering simple business questions** with data

## 🎓 Before You Start

Make sure you understand these basic concepts:

✅ **COUNT(*)** = Count how many things you have  
✅ **SUM(column)** = Add up all the numbers in a column  
✅ **AVG(column)** = Find the average (typical) number  
✅ **GROUP BY** = Sort data into groups (like by department)  
✅ **HAVING** = Filter out groups you don't want to see  

Don't worry if you need to look back at the lessons - that's normal!

## Section 1: Basic Counting Practice 📊

Let's start with simple counting exercises.

### Exercise 1.1: Count Everything (🟢 SUPER EASY)

**Goal**: Practice counting different things in the database.

```sql
-- Connect to the database first
USE TechCorpDB;

-- Exercise 1.1a: How many employees work at TechCorp?
SELECT COUNT(*) AS TotalEmployees 
FROM Employees;

-- Exercise 1.1b: How many projects does TechCorp have?
SELECT COUNT(*) AS TotalProjects
FROM Projects;

-- Exercise 1.1c: How many clients does TechCorp serve?
SELECT COUNT(*) AS TotalClients
FROM Clients;

-- Exercise 1.1d: How many departments exist?
SELECT COUNT(*) AS TotalDepartments  
FROM Departments;
```

**Expected Results**: You should get four different numbers - one for each table.

### Exercise 1.2: Your Turn to Count (🟢 EASY)

Try writing these counting queries yourself:

```sql
-- Challenge 1.2a: Count how many different job levels exist
-- Hint: Use COUNT(*) and the Employees table, look at JobLevel column
SELECT COUNT(DISTINCT JobLevel) AS NumberOfJobLevels
FROM Employees;

-- Challenge 1.2b: Count projects that have started (StartDate is not null)  
-- Hint: Use WHERE StartDate IS NOT NULL
SELECT COUNT(*) AS ProjectsStarted
FROM Projects
WHERE StartDate IS NOT NULL;
```

## Section 2: Adding and Averaging Practice 📊

### Exercise 2.1: Simple Math with Money (🟢 EASY)

**Goal**: Practice adding up salaries and budgets.

```sql
-- Exercise 2.1a: What's the total salary expense for all employees?
SELECT SUM(Salary) AS TotalPayroll
FROM Employees;

-- Exercise 2.1b: What's the total value of all projects?  
SELECT SUM(Budget) AS TotalProjectValue
FROM Projects;

-- Exercise 2.1c: What's the average employee salary?
SELECT AVG(Salary) AS AverageSalary
FROM Employees;

-- Exercise 2.1d: What's the average project size?
SELECT AVG(Budget) AS AverageProjectSize  
FROM Projects;
```

### Exercise 2.2: Find the Extremes (🟢 EASY)

**Goal**: Find the highest and lowest values.

```sql
-- Exercise 2.2a: What's the highest and lowest salary?
SELECT 
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employees;

-- Exercise 2.2b: What's the biggest and smallest project budget?
SELECT 
    MAX(Budget) AS LargestProject,
    MIN(Budget) AS SmallestProject  
FROM Projects;
```

### Exercise 2.3: Complete Summary Reports (🟢 EASY)

**Goal**: Get all statistics in one query.

```sql
-- Exercise 2.3a: Complete employee summary
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalPayroll, 
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS LowestSalary,
    MAX(Salary) AS HighestSalary
FROM Employees;

-- Exercise 2.3b: Complete project summary
SELECT 
    COUNT(*) AS TotalProjects,
    SUM(Budget) AS TotalBudget,
    AVG(Budget) AS AverageBudget, 
    MIN(Budget) AS SmallestBudget,
    MAX(Budget) AS LargestBudget
FROM Projects;
```

## Section 3: Basic Grouping Practice 📊

Now let's practice organizing data into groups.

### Exercise 3.1: Simple Grouping (🟢 EASY)

**Goal**: Count things by category.

```sql
-- Exercise 3.1a: How many employees are in each department?
SELECT 
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees  
GROUP BY Department
ORDER BY Department;

-- Exercise 3.1b: How many projects are in each status?
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount
FROM Projects
GROUP BY ProjectStatus
ORDER BY ProjectCount DESC;

-- Exercise 3.1c: How many clients are in each city?
SELECT 
    City,
    COUNT(*) AS ClientCount  
FROM Clients
GROUP BY City
ORDER BY ClientCount DESC;
```

### Exercise 3.2: Adding Money by Groups (🟢 EASY)

**Goal**: Add up salaries and budgets for each group.

```sql
-- Exercise 3.2a: Total salary cost by department
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    SUM(Salary) AS TotalSalaryCost
FROM Employees
GROUP BY Department  
ORDER BY TotalSalaryCost DESC;

-- Exercise 3.2b: Total budget by project status
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    SUM(Budget) AS TotalBudget
FROM Projects
GROUP BY ProjectStatus
ORDER BY TotalBudget DESC;
```

### Exercise 3.3: Finding Averages by Groups (🟢 EASY)

**Goal**: Calculate average salaries and budgets for each group.

```sql
-- Exercise 3.3a: Average salary by department
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY AverageSalary DESC;

-- Exercise 3.3b: Average project size by status  
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    AVG(Budget) AS AverageProjectSize
FROM Projects  
GROUP BY ProjectStatus
ORDER BY AverageProjectSize DESC;
```

## Section 4: Filtering Groups Practice 📊

Now let's practice showing only the groups we care about.

### Exercise 4.1: Filter by Count (🟢 EASY)

**Goal**: Show only groups that have enough items.

```sql
-- Exercise 4.1a: Show only departments with more than 2 employees
SELECT 
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2
ORDER BY EmployeeCount DESC;

-- Exercise 4.1b: Show only project statuses with 2 or more projects
SELECT 
    ProjectStatus,  
    COUNT(*) AS ProjectCount
FROM Projects
GROUP BY ProjectStatus
HAVING COUNT(*) >= 2
ORDER BY ProjectCount DESC;

-- Exercise 4.1c: Show only cities with multiple clients
SELECT 
    City,
    COUNT(*) AS ClientCount
FROM Clients
GROUP BY City  
HAVING COUNT(*) > 1
ORDER BY ClientCount DESC;
```

### Exercise 4.2: Filter by Money Amounts (🟢 EASY)

**Goal**: Show only groups with high costs or budgets.

```sql  
-- Exercise 4.2a: Show departments spending more than $100,000 on salaries
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    SUM(Salary) AS TotalSalaryCost
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 100000
ORDER BY TotalSalaryCost DESC;

-- Exercise 4.2b: Show project statuses with total budgets over $50,000  
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    SUM(Budget) AS TotalBudget
FROM Projects
GROUP BY ProjectStatus  
HAVING SUM(Budget) > 50000
ORDER BY TotalBudget DESC;
```

### Exercise 4.3: Filter by Averages (🟢 INTERMEDIATE)

**Goal**: Show only groups with high average values.

```sql
-- Exercise 4.3a: Show departments with average salary above $45,000
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,  
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 45000
ORDER BY AverageSalary DESC;

-- Exercise 4.3b: Show project statuses with average budget above $25,000
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    AVG(Budget) AS AverageProjectSize
FROM Projects
GROUP BY ProjectStatus
HAVING AVG(Budget) > 25000  
ORDER BY AverageProjectSize DESC;
```

## Section 5: Real Business Questions 📊

Let's answer questions that a real manager might ask.

### Exercise 5.1: Employee Questions (🟢 INTERMEDIATE)

```sql
-- Question 5.1a: "Which departments have both many employees AND high costs?"
-- (More than 2 employees AND total salaries over $150,000)
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    SUM(Salary) AS TotalSalaryCost,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2 AND SUM(Salary) > 150000  
ORDER BY TotalSalaryCost DESC;

-- Question 5.1b: "What's the salary range in each department?"
SELECT 
    Department,
    COUNT(*) AS EmployeeCount,
    MIN(Salary) AS LowestSalary,  
    MAX(Salary) AS HighestSalary,
    MAX(Salary) - MIN(Salary) AS SalaryRange
FROM Employees
GROUP BY Department
ORDER BY SalaryRange DESC;
```

### Exercise 5.2: Project Questions (🟢 INTERMEDIATE)

```sql
-- Question 5.2a: "Which project statuses are both active AND valuable?"
-- (2 or more projects AND average budget above $30,000)
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    AVG(Budget) AS AverageProjectSize,
    SUM(Budget) AS TotalValue
FROM Projects  
GROUP BY ProjectStatus
HAVING COUNT(*) >= 2 AND AVG(Budget) > 30000
ORDER BY TotalValue DESC;

-- Question 5.2b: "What's the project size range for each status?"
SELECT 
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    MIN(Budget) AS SmallestProject,
    MAX(Budget) AS LargestProject,  
    MAX(Budget) - MIN(Budget) AS ProjectRange
FROM Projects
GROUP BY ProjectStatus
ORDER BY ProjectRange DESC;
```

### Exercise 5.3: Client and Industry Questions (🟢 INTERMEDIATE)

```sql
-- Question 5.3a: "How much business do we get from each industry?"
SELECT 
    c.Industry,
    COUNT(DISTINCT c.ClientID) AS NumberOfClients,
    COUNT(p.ProjectID) AS NumberOfProjects,
    SUM(p.Budget) AS TotalRevenue
FROM Clients c
LEFT JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.Industry
ORDER BY TotalRevenue DESC;

-- Question 5.3b: "Which industries give us the most valuable projects on average?"
SELECT 
    c.Industry,
    COUNT(p.ProjectID) AS NumberOfProjects,  
    AVG(p.Budget) AS AverageProjectValue,
    SUM(p.Budget) AS TotalValue
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.Industry
HAVING COUNT(p.ProjectID) >= 2  -- Only industries with multiple projects
ORDER BY AverageProjectValue DESC;
```

## Section 6: Challenge Exercises 📊

Ready for slightly harder challenges? Try these!

### Challenge 6.1: Time-Based Analysis (🟢 CHALLENGING)

```sql
-- Challenge 6.1a: "Which years were we busiest hiring?"  
-- (Show years with 2 or more hires)
SELECT 
    YEAR(HireDate) AS HireYear,
    COUNT(*) AS EmployeesHired
FROM Employees
WHERE HireDate IS NOT NULL
GROUP BY YEAR(HireDate)
HAVING COUNT(*) >= 2
ORDER BY EmployeesHired DESC;

-- Challenge 6.1b: "Which months do we typically start the most projects?"
SELECT 
    MONTH(StartDate) AS StartMonth,
    COUNT(*) AS ProjectsStarted  
FROM Projects
WHERE StartDate IS NOT NULL
GROUP BY MONTH(StartDate)
ORDER BY ProjectsStarted DESC;
```

### Challenge 6.2: Multi-Level Grouping (🟢 CHALLENGING)

```sql
-- Challenge 6.2a: "How many junior vs senior employees in each department?"
SELECT 
    Department,
    JobLevel,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department, JobLevel  
ORDER BY Department, JobLevel;

-- Challenge 6.2b: "Project activity by year and status"
SELECT 
    YEAR(StartDate) AS ProjectYear,
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    AVG(Budget) AS AverageProjectSize
FROM Projects
WHERE StartDate IS NOT NULL
GROUP BY YEAR(StartDate), ProjectStatus
ORDER BY ProjectYear, ProjectStatus;
```

### Challenge 6.3: Business Intelligence Report (🟢 CHALLENGING)

```sql
-- Challenge 6.3: "Create a comprehensive business overview"
-- This query combines multiple concepts to create a business dashboard
SELECT 
    'TechCorp Business Overview' AS ReportSection,
    'Employee Statistics' AS Category,
    (SELECT COUNT(*) FROM Employees) AS TotalEmployees,
    (SELECT FORMAT(AVG(Salary), 'C0') FROM Employees) AS AvgSalary,
    (SELECT FORMAT(SUM(Salary), 'C0') FROM Employees) AS TotalPayroll
    
UNION ALL

SELECT 
    'TechCorp Business Overview' AS ReportSection,
    'Project Statistics' AS Category, 
    (SELECT COUNT(*) FROM Projects) AS TotalProjects,
    (SELECT FORMAT(AVG(Budget), 'C0') FROM Projects) AS AvgProjectSize,
    (SELECT FORMAT(SUM(Budget), 'C0') FROM Projects) AS TotalProjectValue
    
UNION ALL

SELECT 
    'TechCorp Business Overview' AS ReportSection,
    'Client Statistics' AS Category,
    (SELECT COUNT(*) FROM Clients) AS TotalClients,
    'N/A' AS AvgValue,  
    (SELECT COUNT(DISTINCT Industry) FROM Clients) AS TotalIndustries;
```

## 📝 Lab Summary

Congratulations! You've practiced:

1. **Basic Counting** - Using COUNT(*) to count records
2. **Adding and Averaging** - Using SUM() and AVG() for calculations  
3. **Finding Extremes** - Using MIN() and MAX() to find highest/lowest values
4. **Grouping Data** - Using GROUP BY to organize data into categories
5. **Filtering Groups** - Using HAVING to show only important groups
6. **Business Analysis** - Answering real questions with your data

## 🎯 Key Skills You've Developed

✅ **Data Summarization** - Turning lots of data into useful numbers  
✅ **Categorical Analysis** - Breaking down data by groups  
✅ **Business Thinking** - Using data to answer business questions  
✅ **SQL Confidence** - Writing queries step by step  
✅ **Problem Solving** - Breaking complex questions into simple steps  

## 🚀 What You Can Do Now

With these skills, you can:

- **Answer business questions** with data from any database
- **Create simple reports** that managers will find useful  
- **Spot patterns** and trends in your organization's data
- **Make data-driven arguments** for business decisions
- **Build confidence** to learn more advanced SQL techniques

## 💡 Tips for Continued Learning

1. **Practice regularly** - Try writing queries for your own data
2. **Start simple** - Always begin with basic queries and add complexity  
3. **Ask business questions** - Think about what information would be useful
4. **Don't be afraid to experiment** - SQL won't break if you make mistakes
5. **Build up gradually** - Each query can be a building block for more complex ones

**Key Takeaway**: Data analysis is about asking good questions and using simple tools to find answers. You now have those tools!