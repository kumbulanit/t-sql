# Lesson 1: Basic Counting and Adding with SQL - Beginner Lesson

## 🎯 Learn Simple Math with Your Database (🟢 COMPLETE BEGINNER LEVEL)

Welcome! This lesson teaches you how to do simple math with your database data. Think of it like using a calculator, but the calculator can work with hundreds or thousands of numbers at once. No prior experience needed!

## 📖 What Will You Learn?

You'll learn to ask your database simple questions like:

- **"How many employees do we have?"** (Counting)
- **"What's the total of all salaries?"** (Adding)  
- **"What's the average BaseSalary?"** (Average)
- **"Who earns the most/least?"** (Highest/Lowest)

These are called **aggregate functions** - fancy words for "math functions that work on groups of data."

## 🎓 What You'll Be Able to Do

After this lesson, you can:

✅ Count things in your database  
✅ Add up numbers  
✅ Find averages  
✅ Find the biggest and smallest numbers  
✅ Answer basic business questions with data  

## Part 1: Counting Things 📊

### 🎓 Let's Start Simple: Counting

Imagine you have a box of marbles and want to know how many you have. Instead of counting by hand, SQL can count for you!

**The COUNT Function**: `COUNT(*)` = "Count everything"

### Exercise 1.1: Count All Employees (🟢 SUPER BASIC)

**Question**: "How many people work at TechCorp?"

```sql
-- Step 1: Tell SQL which database to use
USE TechCorpDB;

-- Step 2: Count all employees
SELECT COUNT(*) AS NumberOfEmployees
FROM Employees e;
```

**What this does:**
- `COUNT(*)` counts every row in the Employees table
- `AS NumberOfEmployees` gives our answer a nice name
- **Result**: You'll get one number, like `15`

**In plain English**: "SQL, please count all the employees and call the answer 'NumberOfEmployees'"

### Exercise 1.2: Count Projects (🟢 SUPER BASIC)

**Your turn!** Count how many projects TechCorp has:

```sql
-- Count all projects
SELECT COUNT(*) AS NumberOfProjects  
FROM Projects;
```

**Expected result**: A single number showing total projects.

## Part 2: Adding Numbers 📊

### 🎓 Adding Up Money: The SUM Function

If you have a pile of dollar bills and want to know the total value, you add them up. SQL can do the same with BaseSalary data!

**The SUM Function**: `SUM(column_name)` = "Add up all the numbers in this column"

### Exercise 2.1: Total BaseSalary Cost (🟢 SUPER BASIC)

**Question**: "How much does TechCorp spend on all salaries combined?"

```sql
-- Add up all salaries
SELECT SUM(e.BaseSalary) AS TotalBaseSalaryExpense
FROM Employees e;
```

**What this does:**
- `SUM(e.BaseSalary)` adds up every BaseSalary number
- **Example**: If salaries are 50000 + 60000 + 45000 = 155000
- **Result**: One big number representing total cost

### Exercise 2.2: Total Project Budgets (🟢 SUPER BASIC)

**Your turn!** Add up all project budgets:

```sql
-- Add up all project budgets  
SELECT SUM(Budget) AS TotalProjectBudgets
FROM Projects;
```

## Part 3: Finding Averages 📊

### 🎓 What's Typical? The AVG Function

An average tells you what's "normal" or "typical." Like the average height of students in a class.

**The AVG Function**: `AVG(column_name)` = "What's the average of all these numbers?"

### Exercise 3.1: Average BaseSalary (🟢 SUPER BASIC)

**Question**: "What's the typical BaseSalary at TechCorp?"

```sql
-- Calculate average BaseSalary
SELECT AVG(e.BaseSalary) AS AverageBaseSalary
FROM Employees e;
```

**What this does:**
- Adds up all salaries, then divides by number of employees
- **Example**: (50000 + 60000 + 45000) ÷ 3 = 51667
- **Result**: The "typical" BaseSalary amount

### Exercise 3.2: Average Project Size (🟢 SUPER BASIC)

```sql
-- Find average project budget
SELECT AVG(Budget) AS AverageProjectBudget
FROM Projects;
```

## Part 4: Finding Extremes (Biggest and Smallest) 📊

### 🎓 Who's the Highest and Lowest?

Sometimes you want to know the extremes - the highest BaseSalary or smallest project budget.

**MIN and MAX Functions**: 
- `MIN(column_name)` = "Find the smallest number"
- `MAX(column_name)` = "Find the biggest number"

### Exercise 4.1: BaseSalary Extremes (🟢 SUPER BASIC)

**Questions**: "Who earns the most? Who earns the least?"

```sql
-- Find highest BaseSalary
SELECT MAX(e.BaseSalary) AS HighestBaseSalary
FROM Employees e;

-- Find lowest BaseSalary  
SELECT MIN(e.BaseSalary) AS LowestBaseSalary
FROM Employees e;
```

### Exercise 4.2: Get Both in One Query (🟢 BASIC)

```sql
-- Get both highest and lowest in one go
SELECT 
    MAX(e.BaseSalary) AS HighestBaseSalary,
    MIN(e.BaseSalary) AS LowestBaseSalary  
FROM Employees e;
```

## Part 5: Putting It All Together 📊

### Exercise 5.1: Complete Employee Summary (🟢 BASIC)

**Goal**: Get a complete picture of employee data in one query.

```sql
-- Complete employee statistics
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(e.BaseSalary) AS TotalPayroll,
    AVG(e.BaseSalary) AS AverageBaseSalary,
    MIN(e.BaseSalary) AS LowestBaseSalary,
    MAX(e.BaseSalary) AS HighestBaseSalary
FROM Employees e;
```

**Result will look like:**
```
TotalEmployees | TotalPayroll | AverageSalary | LowestSalary | HighestSalary
15             | 750000       | 50000         | 35000        | 85000
```

**In plain English**: "15 employees, total cost $750,000, average $50,000, range from $35,000 to $85,000"

### Exercise 5.2: Project Summary (🟢 BASIC)

**Your turn!** Create a complete project summary:

```sql
-- Complete project statistics
SELECT 
    COUNT(*) AS TotalProjects,
    SUM(Budget) AS TotalBudgets,
    AVG(Budget) AS AverageProjectSize,
    MIN(Budget) AS SmallestProject,
    MAX(Budget) AS LargestProject
FROM Projects;
```

## Part 6: Real Business Questions 📊

### Exercise 6.1: Answer Business Questions (🟢 BASIC)

Let's answer real questions a manager might ask:

```sql
-- Question 1: How many employees do we have?
SELECT COUNT(*) AS 'Number of Employees'
FROM Employees e;

-- Question 2: What's our monthly payroll cost?
SELECT SUM(e.BaseSalary) / 12 AS 'Monthly Payroll Cost'
FROM Employees e;

-- Question 3: What's a typical project worth?
SELECT AVG(Budget) AS 'Typical Project Value'
FROM Projects;

-- Question 4: What's our biggest project?
SELECT MAX(Budget) AS 'Largest Project Budget'
FROM Projects;
```

### Exercise 6.2: Making Numbers Easier to Read (🟢 INTERMEDIATE)

```sql
-- Format numbers to be easier to read
SELECT 
    COUNT(*) AS Employees,
    FORMAT(SUM(e.BaseSalary), 'C0') AS 'Total Payroll',
    FORMAT(AVG(e.BaseSalary), 'C0') AS 'Average BaseSalary'
FROM Employees e;
```

**What FORMAT does**: Turns `50000` into `$50,000` (easier to read!)

## 🎯 Practice Exercises for Beginners

### Practice 1: Client Analysis
```sql
-- How many clients does TechCorp have?
SELECT COUNT(*) AS 'Number of Clients'
FROM Clients;
```

### Practice 2: d.DepartmentName Count
```sql  
-- How many different departments exist?
SELECT COUNT(*) AS 'Number of Departments'
FROM Departments;
```

### Practice 3: Complete Business Overview
```sql
-- Get a complete business overview
SELECT 
    'TechCorp Business Overview' AS Report,
    (SELECT COUNT(*) FROM Employees e) AS Employees,
    (SELECT COUNT(*) FROM Clients) AS Clients,
    (SELECT COUNT(*) FROM Projects) AS Projects,
    (SELECT FORMAT(SUM(Budget), 'C0') FROM Projects) AS 'Total Project Value'
```

## 📝 Summary - What You Learned

You now know the 5 basic math functions in SQL:

1. **COUNT(*)** - Counts how many things you have
2. **SUM(column)** - Adds up all the numbers  
3. **AVG(column)** - Finds the average (typical) number
4. **MIN(column)** - Finds the smallest number
5. **MAX(column)** - Finds the biggest number

## 🎯 Key Points for Beginners

✅ **These functions work on entire columns of data**  
✅ **They give you ONE answer per function**  
✅ **You can use multiple functions in one query**  
✅ **They help answer business questions quickly**  
✅ **No math skills needed - SQL does the math for you!**  

## 🚀 What's Next?

In the next lesson, you'll learn about **GROUP BY** - this lets you break your data into groups (like by department) and do math on each group separately. 

**Example**: Instead of "average BaseSalary for everyone," you'll learn "average BaseSalary per department."

**Key Takeaway**: SQL's math functions are like having a super-fast calculator that works with lots of data at once!