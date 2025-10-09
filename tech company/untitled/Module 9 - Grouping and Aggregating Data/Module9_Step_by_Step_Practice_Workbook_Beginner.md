# Module 9 - Beginner Practice Workbook: Step-by-Step Exercises

## 🎯 Your Personal SQL Practice Guide (🟢 COMPLETE BEGINNER LEVEL)

Welcome to your step-by-step practice workbook! This guide walks you through exercises that combine your Module 9 skills (counting, adding, grouping) with everything you learned in Modules 3-8. Each exercise is clearly labeled and explained in simple terms.

## 📋 How to Use This Workbook

1. **Read the explanation** for each exercise
2. **Try the example** exactly as written first
3. **Modify the exercise** with the suggested changes
4. **Check your understanding** with the provided questions
5. **Move to the next level** when you feel confident

---

## 🏁 Getting Started: Connect to Database

Always start with this command:

```sql
USE TechCorpDB;
```

---

## Chapter 1: Counting Made Easy 📊
**Combining: Module 3 (Basic SELECT) + Module 9 (COUNT)**

### Practice 1.1: Count Everything (🟢 START HERE)

**What you'll learn:** Basic counting with friendly names

```sql
-- Example: Count all employees
SELECT COUNT(*) AS 'Total Employees'
FROM Employees e;

-- Try this: Count all projects  
SELECT COUNT(*) AS 'Total Projects'
FROM Projects p;

-- Your turn: Count all clients
SELECT COUNT(*) AS 'Total Clients'  
FROM Clients;
```

**Questions to check your understanding:**
- What does `COUNT(*)` do?
- Why do we use `AS 'Total Employees'`?
- What would happen if you forgot the `AS` part?

### Practice 1.2: Counting with Conditions (🟢 EASY)

**What you'll learn:** Count only specific things

```sql
-- Example: Count high-paid employees (Module 5 WHERE + Module 9 COUNT)
SELECT COUNT(*) AS 'High Paid Employees'
FROM Employees e  
WHERE e.BaseSalary > 50000;

-- Try this: Count large projects
SELECT COUNT(*) AS 'Large Projects'
FROM Projects p
WHERE d.Budget > 40000;

-- Your turn: Count recent employees (hired after 2022)
SELECT COUNT(*) AS 'Recent Hires'
FROM Employees e
WHERE e.HireDate > '2022-01-01';
```

**Modify and practice:**
- Change the BaseSalary amount to 45000
- Change the budget amount to 30000  
- Change the hire date to 2023-01-01

---

## Chapter 2: Adding Numbers Like a Pro 📊
**Combining: Module 3 (SELECT with formatting) + Module 9 (SUM, AVG)**

### Practice 2.1: Simple Adding (🟢 EASY)

**What you'll learn:** Add up numbers and make them look nice

```sql
-- Example: Total e.BaseSalary cost with nice formatting
SELECT 
    FORMAT(SUM(e.BaseSalary), 'C0') AS 'Total Payroll Cost'
FROM Employees e;

-- Try this: Total project budgets
SELECT 
    FORMAT(SUM(d.Budget), 'C0') AS 'Total Project Value'
FROM Projects p;

-- Your turn: Average employee e.BaseSalary
SELECT 
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average Employee e.BaseSalary'
FROM Employees e;
```

**What does FORMAT do?**
- `FORMAT(50000, 'C0')` turns `50000` into `$50,000`
- `'C0'` means "currency with no decimal places"

### Practice 2.2: Multiple Calculations (🟢 BASIC)

**What you'll learn:** Get several answers in one query

```sql
-- Example: Complete e.BaseSalary overview
SELECT 
    COUNT(*) AS 'Number of Employees',
    FORMAT(SUM(e.BaseSalary), 'C0') AS 'Total Cost',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average e.BaseSalary',
    FORMAT(MIN(e.BaseSalary), 'C0') AS 'Lowest e.BaseSalary',
    FORMAT(MAX(e.BaseSalary), 'C0') AS 'Highest e.BaseSalary'
FROM Employees e;

-- Your turn: Complete project overview
SELECT 
    COUNT(*) AS 'Number of Projects',
    FORMAT(SUM(d.Budget), 'C0') AS 'Total d.Budget',
    FORMAT(AVG(d.Budget), 'C0') AS 'Average Project Size',
    FORMAT(MIN(d.Budget), 'C0') AS 'Smallest Project',
    FORMAT(MAX(d.Budget), 'C0') AS 'Largest Project'  
FROM Projects p;
```

**Check your understanding:**
- What information does this give a manager?
- Which number would be most important for budgeting?

---

## Chapter 3: Organizing into Groups 📊
**Combining: Module 3 (SELECT) + Module 9 (GROUP BY)**

### Practice 3.1: Your First Grouping (🟢 BASIC)

**What you'll learn:** Count things by category

```sql
-- Example: Count employees by d.DepartmentName
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(e.EmployeeID) DESC;

-- Try this: Client names with project counts
SELECT 
    c.ClientName,
    COUNT(p.ProjectID) AS 'Number of Projects'
FROM Clients c
INNER JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.ClientName
ORDER BY COUNT(p.ProjectID) DESC;
```

**Why join tables?**
- The Employees table has d.DepartmentID (just a number)
- The Departments table has d.DepartmentName (the actual name)
- JOIN connects them so we can show the real d.DepartmentName names

### Practice 4.2: More Complex Joining (🟢 INTERMEDIATE)

**What you'll learn:** Combine three tables for better insights

```sql
-- Example: Which departments manage the most project money?
SELECT d.DepartmentName,
    COUNT(p.ProjectID) AS 'Projects Managed',
    FORMAT(SUM(p.d.Budget), 'C0') AS 'Total d.Budget Managed'
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.d.DepartmentID  
INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
GROUP BY d.DepartmentName
ORDER BY SUM(p.d.Budget) DESC;
```

**What's happening?**
1. Start with Departments table
2. JOIN to Employees to see which employees are in each d.DepartmentName
3. JOIN to Projects to see which projects each employee manages
4. GROUP BY d.DepartmentName to see totals for each d.DepartmentName

---

## Chapter 5: Filtering Groups 📊
**Combining: Module 5 (WHERE) + Module 9 (HAVING)**

### Practice 5.1: Show Only Big Groups (🟢 BASIC)

**What you'll learn:** Filter out small groups you don't care about

```sql
-- Example: Show only departments with 3+ employees
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(*) DESC;

-- Step 3: Tenure analysis
SELECT 
    'Tenure Analysis' AS 'Report Section',
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1 THEN 'New (< 1 year)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 3 THEN 'Experienced (1-3 years)'
        ELSE 'Veteran (3+ years)'
    END AS 'Category',
    COUNT(*) AS 'Employee Count',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average e.BaseSalary'
FROM Employees e
WHERE e.HireDate IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1 THEN 'New (< 1 year)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 3 THEN 'Experienced (1-3 years)'  
        ELSE 'Veteran (3+ years)'
    END
ORDER BY AVG(e.BaseSalary) DESC;
```

### Project 8.2: Client Value Analysis (🟢 CHALLENGING)

**Your mission:** Find out which clients are most valuable

```sql
-- Step 1: Client overview
SELECT 
    c.ClientName,
    c.Industry,
    c.City,
    COUNT(p.ProjectID) AS 'Number of Projects',
    FORMAT(SUM(p.Budget), 'C0') AS 'Total Project Value',
    FORMAT(AVG(p.Budget), 'C0') AS 'Average Project Size'
FROM Clients c
LEFT JOIN Projects p ON c.ClientID = p.ClientID  -- LEFT JOIN includes clients with no projects
GROUP BY c.ClientName, c.Industry, c.City
ORDER BY SUM(p.Budget) DESC;

-- Step 2: Industry analysis
SELECT 
    c.Industry,
    COUNT(DISTINCT c.ClientID) AS 'Number of Clients',
    COUNT(p.ProjectID) AS 'Total Projects',
    FORMAT(SUM(p.Budget), 'C0') AS 'Industry Revenue',
    FORMAT(AVG(p.Budget), 'C0') AS 'Average Project Size'
FROM Clients c
INNER JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.Industry
HAVING COUNT(p.ProjectID) >= 2  -- Industries with multiple projects
ORDER BY SUM(p.Budget) DESC;
```

---

## 📚 Your Learning Checklist

Check off each skill as you master it:

### Basic Skills
- [ ] Count records with COUNT(*)
- [ ] Add numbers with SUM()
- [ ] Find averages with AVG()
- [ ] Find highest/lowest with MAX()/MIN()
- [ ] Use GROUP BY to organize data
- [ ] Use HAVING to filter groups

### Intermediate Skills  
- [ ] Join two tables with INNER JOIN
- [ ] Join multiple tables
- [ ] Use WHERE and HAVING together
- [ ] Group by date parts (YEAR, QUARTER)
- [ ] Use CASE expressions with GROUP BY
- [ ] Format results for business presentation

### Advanced Skills
- [ ] Create multi-step analysis reports
- [ ] Combine string functions with grouping
- [ ] Use mathematical calculations in GROUP BY
- [ ] Build executive dashboard queries
- [ ] Handle NULL values in aggregations

## 🎯 Next Steps

1. **Practice regularly** - Try variations of these exercises
2. **Ask business questions** - What would your manager want to know?
3. **Experiment safely** - SQL won't break if you make mistakes
4. **Build complexity gradually** - Start simple, add features
5. **Focus on business value** - Every query should answer a real question

**Remember:** The goal isn't to memorize syntax, it's to solve business problems with data!

**Key Takeaway:** SQL becomes powerful when you combine simple building blocks to answer complex business questions!