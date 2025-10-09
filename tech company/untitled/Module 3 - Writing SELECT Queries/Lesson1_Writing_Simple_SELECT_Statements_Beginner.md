# Lesson 1: Writing Simple SELECT Statements - Beginner Lesson

## 🎯 What You'll Learn (🟢 COMPLETE BEGINNER LEVEL)

Welcome! This lesson teaches you how to write SELECT statements - the most important skill in SQL. Think of SELECT as asking questions to your database, like "Show me all employees" or "What projects are active?" We'll make it super simple and practical!

## 📖 What is a SELECT Statement?

A SELECT statement is like asking your database a question. It's how you **get information out** of your database.

Think of your database like a filing cabinet:
- **Tables** = File folders (Employees, Departments, Projects)
- **Columns** = Types of information (Name, Salary, Start Date)  
- **Rows** = Individual records (John Smith's information, Sarah's information)

**SELECT** lets you say: "Please show me specific information from specific folders"

## 🎓 What You'll Be Able to Do

After this lesson, you can:

✅ Write basic SELECT statements to get data  
✅ Choose specific columns you want to see  
✅ Get all data or just the first few rows  
✅ Make your results look professional and readable  

## Part 1: Your First SELECT Statement 📊

### 🎓 The Simplest SELECT - See Everything

Let's start by looking at ALL information in the Employees table:

```sql
-- See everything in the Employees table
SELECT *
FROM Employees e;
```

**What this does:**

- `SELECT *` means "show me all columns"
- `FROM Employees e` means "from the Employees table"
- `e` is a nickname for Employees (makes typing easier)

**Result**: You'll see ALL employees with ALL their information (name, salary, hire date, etc.)

### 🎓 But That's Too Much Information!

Seeing ALL columns can be overwhelming. Let's be more specific:

```sql
-- Show just names and job titles  
SELECT 
    e.FirstName,
    e.LastName,
    e.JobTitle
FROM Employees e;
```

**What this does:**

- Shows ONLY the columns you specify
- Much cleaner and easier to read!

### Exercise 1.1: Try Your First Specific SELECT (🟢 SUPER BASIC)

```sql
-- Your turn! Show employee names and salaries
SELECT 
    e.FirstName,
    e.LastName, 
    e.BaseSalary
FROM Employees e;
```

## Part 2: Making Results Look Professional 📊

### 🎓 Using Column Aliases (Friendly Names)

Make your columns have friendly, readable names:

```sql
-- Give columns friendly names using AS
SELECT 
    e.FirstName AS [First Name],        -- Friendly column name
    e.LastName AS [Last Name], 
    e.JobTitle AS [Job Position],
    e.BaseSalary AS [Annual Salary]
FROM Employees e;
```

**What this does:**

- `AS [First Name]` makes the column header "First Name" instead of "FirstName"
- Square brackets `[]` let you use spaces in column names
- Results look much more professional!

### 🎓 Combining Columns Together

You can combine columns to create new information:

```sql
-- Combine first and last names into full names
SELECT 
    e.FirstName + ' ' + e.LastName AS [Full Name],  -- Combine with space
    e.JobTitle AS [Position],
    '$' + CAST(e.BaseSalary AS VARCHAR) AS [Salary] -- Add $ sign
FROM Employees e;
```

**Result**: Instead of separate first/last names, you get "John Smith", "Sarah Johnson", etc.

### Exercise 2.1: Practice Professional Formatting (🟢 BASIC)

```sql
-- Create a professional employee directory
SELECT 
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.JobTitle AS [Job Title], 
    e.Email AS [Email Address],
    e.HireDate AS [Start Date]
FROM Employees e;
```

## Part 3: Controlling How Much Data You See 📊

### 🎓 Using TOP to Limit Results

Sometimes tables have thousands of rows. Use TOP to see just the first few:

```sql
-- Show only the first 5 employees
SELECT TOP 5
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.JobTitle AS [Position]
FROM Employees e;
```

**What TOP does:**

- `TOP 5` = "show me only the first 5 rows"
- `TOP 10` = "show me only the first 10 rows"
- Prevents overwhelming results when learning

### 🎓 Using TOP with Percentages

You can also use percentages:

```sql
-- Show the first 10% of employees
SELECT TOP 10 PERCENT
    e.FirstName AS [Name],
    e.BaseSalary AS [Salary]
FROM Employees e;
```

### Exercise 3.1: Practice with TOP (🟢 BASIC)

```sql
-- Show the first 3 departments  
SELECT TOP 3
    d.DepartmentName AS [Department],
    d.Budget AS [Budget Amount],
    d.Location AS [Office Location]
FROM Departments d;
```

## Part 4: Getting Information from Different Tables 📊

### 🎓 Exploring Different Tables in TechCorp

Our TechCorp database has several tables. Let's see what's available:

**Departments Table:**
```sql  
-- Look at department information
SELECT TOP 5
    d.DepartmentName AS [Department Name],
    d.Budget AS [Department Budget], 
    d.Location AS [Office Location],
    d.ManagerID AS [Manager ID]
FROM Departments d;
```

**Projects Table:**
```sql
-- Look at current projects
SELECT TOP 5  
    p.ProjectName AS [Project Name],
    p.StartDate AS [Started On],
    p.EndDate AS [Due Date],
    p.Budget AS [Project Budget], 
    p.Status AS [Current Status]
FROM Projects p;
```

**Customers Table:**
```sql
-- Look at customer information  
SELECT TOP 5
    c.CompanyName AS [Company Name],
    c.ContactName AS [Contact Person],
    c.Email AS [Email Address],
    c.Phone AS [Phone Number]
FROM Customers c;
```

### Exercise 4.1: Explore Tables Yourself (🟢 EXPLORATION)

Try getting information from each table:

```sql  
-- 1. Get product information
SELECT TOP 3
    p.ProductName AS [Product Name],
    p.Price AS [Price], 
    p.Category AS [Category]
FROM Products p;

-- 2. Get sales information  
SELECT TOP 3
    s.SaleDate AS [Sale Date],
    s.Quantity AS [Quantity Sold],
    s.UnitPrice AS [Unit Price]
FROM Sales s;
```

## 📋 What You've Learned

Congratulations! You now master:

✅ **Basic SELECT syntax**: Getting data from tables  
✅ **Column selection**: Choosing specific information  
✅ **Column aliases**: Making results professional  
✅ **TOP clause**: Limiting result size  
✅ **Column combining**: Creating new information  
✅ **Real queries**: Getting business information  

## 🚀 Ready for More?

Outstanding work! You can now write SELECT statements to get meaningful information from your database. This is the foundation of everything you'll do in SQL!

**Next up**: Lesson 2 - Eliminating Duplicates with DISTINCT (Learning to clean up your results and get unique values)

[This is a template - specific content would be created based on the lesson topic]

### Exercise 1.1: Your First Example (🟢 SUPER BASIC)

**Question**: Let's try the most basic example

```sql
-- Step 1: Use our database
USE TechCorpDB;

-- Step 2: Simple example
-- [Specific SQL example would go here based on lesson topic]
SELECT 'Hello World' AS Message;
```

**What this does:**
- Simple explanation in plain English
- Step-by-step breakdown
- **Result**: What you should expect to see

### Exercise 1.2: Your Turn! (🟢 SUPER BASIC)

**Your turn!** Try this simple example:

```sql
-- Try this yourself
-- [Another basic example]
```

## Part 2: Building Your Skills 📊

### 🎓 Next Level Understanding

Now that you understand the basics, let's add one more concept...

### Exercise 2.1: Slightly More Complex (🟢 BASIC)

```sql
-- A bit more complex but still beginner-friendly
-- [Progressive example]
```

## 📋 What You've Learned

Congratulations! You now know:

✅ **Basic concept 1**  
✅ **Basic concept 2**  
✅ **How to write simple examples**  
✅ **The fundamental patterns**  

## 🚀 Ready for More?

Great job! You've mastered the basics. In the next lesson, we'll build on these concepts and learn more advanced techniques.

**Next up**: [Next lesson in sequence]
