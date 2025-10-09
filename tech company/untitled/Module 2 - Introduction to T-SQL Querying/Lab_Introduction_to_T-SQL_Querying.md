# Lab: Introduction to T-SQL Querying - TechCorp Business Queries

## 🎯 What You'll Learn Today (🟢 BEGINNER TO 🟡 INTERMEDIATE)

Welcome to Module 2! You've already created TechCorp's database in Module 1. Now you'll learn how to ask questions of your data using T-SQL - the language that SQL Server understands.

**By the end of this lab, you'll be able to:**
- Write basic SELECT queries to find information
- Understand how databases organize information in tables
- Use TechCorp's business data to practice real-world scenarios
- Master the fundamentals that you'll build on in later modules

## 📖 Quick Review: TechCorp Solutions

Remember, **TechCorp Solutions** is our technology consulting company with:
- 145 employees across 5 departments (Engineering, Sales, Marketing, HR, Finance)
- Clients ranging from small startups to large enterprises  
- Projects including web development, cloud migration, and cybersecurity
- Multiple offices and international clients

## 🎓 Learning Progression for Module 2

### What We're Building On (Module 1 Recap)
✅ You created TechCorp's database structure  
✅ You learned about SQL Server architecture  
✅ You understand basic database concepts  

### What's New in Module 2 (Current Level: 🟡 BEGINNER TO INTERMEDIATE)
🔄 Adding business data to TechCorp's database  
🔄 Learning to write SELECT queries  
🔄 Understanding how to filter and sort information  
🔄 Working with business logic and calculations

## Lab Setup - TechCorp Solutions Database

### Continuing from Module 1
In Module 1, we created the TechCorpDB database and explored SQL Server architecture. Now in Module 2, we'll build the core business tables for TechCorp Solutions and learn T-SQL fundamentals by querying real business data.

**Prerequisites:**
- TechCorpDB database created in Module 1
- Understanding of SQL Server architecture from Module 1

```sql
-- Connect to our TechCorp database from Module 1
USE TechCorpDB;
GO

-- Verify we're in the right database
SELECT 
    DB_NAME() as CurrentDatabase,
    'Module 2 - T-SQL Fundamentals' as ModuleTitle,
    GETDATE() as LabStartTime;
```

### TechCorp Business Schema (Module 2 Foundation)
Now we'll create the core business tables for TechCorp Solutions:

```sql
-- Companies table - TechCorp's clients
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1001,1),
    CompanyName NVARCHAR(100) NOT NULL,
    Industry NVARCHAR(50) NOT NULL,
    CompanySize NVARCHAR(20) NOT NULL,
    AnnualRevenue DECIMAL(15,2) NULL,
    ContactEmail NVARCHAR(100) NOT NULL,
    Country NVARCHAR(50) NOT NULL DEFAULT 'USA',
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME()
);

-- Departments table - TechCorp's internal structure
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    d.DepartmentName NVARCHAR(50) NOT NULL,
    DepartmentCode NVARCHAR(10) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    ManagerID INT NULL,
    Location NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- Employees table - TechCorp's workforce
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(2001,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    WorkEmail NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    ManagerID INT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Title NVARCHAR(100) NOT NULL,
    EmployeeType NVARCHAR(20) NOT NULL DEFAULT 'Full-Time'
);

-- Projects table - TechCorp's client projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(3001,1),
    ProjectName NVARCHAR(100) NOT NULL,
    ProjectCode NVARCHAR(20) NOT NULL,
    CompanyID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Budget DECIMAL(10,2) NOT NULL,
    IsActive NVARCHAR(20) NOT NULL,
    Priority NVARCHAR(10) NOT NULL DEFAULT 'Medium'
);

-- EmployeeProjects table (many-to-many relationship)
CREATE TABLE EmployeeProjects (
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    HoursAllocated DECIMAL(5,2) NOT NULL,
    HoursWorked DECIMAL(5,2) NOT NULL DEFAULT 0,
    HourlyRate DECIMAL(8,2) NULL,
    StartDate DATE NOT NULL,
    PRIMARY KEY (EmployeeID, ProjectID)
);
```

### TechCorp Sample Data

```sql
-- Insert TechCorp client companies
INSERT INTO Companies (CompanyName, Industry, CompanySize, AnnualRevenue, ContactEmail, Country) VALUES
('GlobalTech Industries', 'Manufacturing', 'Large', 250000000.00, 'contact@globaltech.com', 'USA'),
('StartupVenture Inc', 'Technology', 'Small', 5000000.00, 'hello@startupventure.com', 'USA'),
('MegaCorp Solutions', 'Retail', 'Enterprise', 1200000000.00, 'partnerships@megacorp.com', 'USA'),
('InnovateNow Ltd', 'Healthcare', 'Medium', 45000000.00, 'info@innovatenow.com', 'Canada'),
('TechForward Group', 'Financial Services', 'Large', 180000000.00, 'business@techforward.com', 'USA');

-- Insert TechCorp departments
INSERT INTO Departments (DepartmentName, DepartmentCode, Budget, Location) VALUES
('Software Development', 'DEV', 750000, 'Building A - Floor 3'),
('Data Analytics', 'DATA', 450000, 'Building A - Floor 4'),
('Cybersecurity', 'SEC', 600000, 'Building B - Floor 2'),
('Cloud Infrastructure', 'CLOUD', 550000, 'Building A - Floor 5'),
('Project Management', 'PM', 350000, 'Building B - Floor 3'),
('Human Resources', 'HR', 250000, 'Building A - Floor 1'),
('Finance', 'FIN', 300000, 'Building A - Floor 2'),
('Sales & Marketing', 'SALES', 400000, 'Building B - Floor 4');

-- Insert TechCorp employees (key team members for Module 2)
INSERT INTO Employees (FirstName, LastName, MiddleName, WorkEmail, DepartmentID, ManagerID, BaseSalary, HireDate, Title, EmployeeType) VALUES
('Marcus', 'Johnson', 'Ray', 'marcus.johnson@techcorp.com', 1, NULL, 125000, '2019-01-15', 'Development Director', 'Full-Time'),
('Sarah', 'Chen', NULL, 'sarah.chen@techcorp.com', 1, 2001, 95000, '2020-03-10', 'Senior Developer', 'Full-Time'),
('David', 'Rodriguez', 'Luis', 'david.rodriguez@techcorp.com', 1, 2001, 88000, '2020-06-01', 'Backend Developer', 'Full-Time'),
('Dr. Linda', 'Martinez', 'Sofia', 'linda.martinez@techcorp.com', 2, NULL, 135000, '2019-09-05', 'Data Science Director', 'Full-Time'),
('Kevin', 'Park', 'Min', 'kevin.park@techcorp.com', 2, 2004, 105000, '2020-11-15', 'Senior Data Scientist', 'Full-Time'),
('Michael', 'Foster', 'James', 'michael.foster@techcorp.com', 3, NULL, 140000, '2018-12-01', 'Security Director', 'Full-Time'),
('Thomas', 'Anderson', 'Neo', 'thomas.anderson@techcorp.com', 4, NULL, 130000, '2019-05-20', 'Cloud Director', 'Full-Time'),
('Amanda', 'Miller', 'Grace', 'amanda.miller@techcorp.com', 5, NULL, 115000, '2019-11-18', 'PMO Director', 'Full-Time'),
('Patricia', 'White', 'Ann', 'patricia.white@techcorp.com', 6, NULL, 85000, '2020-02-10', 'HR Director', 'Full-Time'),
('Steven', 'Clark', 'Michael', 'steven.clark@techcorp.com', 7, NULL, 95000, '2019-08-22', 'Finance Director', 'Full-Time');

-- Insert TechCorp client projects
INSERT INTO Projects (ProjectName, ProjectCode, CompanyID, StartDate, EndDate, Budget, IsActive, Priority) VALUES
('GlobalTech ERP Migration', 'GT-ERP-2024', 1001, '2024-01-15', '2024-08-30', 850000, 'In Progress', 'High'),
('StartupVenture Mobile App', 'SV-MOB-2024', 1002, '2024-02-01', '2024-06-15', 180000, 'In Progress', 'High'),
('MegaCorp Data Warehouse', 'MC-DW-2024', 1003, '2024-01-08', '2024-12-31', 1200000, 'In Progress', 'Critical'),
('InnovateNow Security Audit', 'IN-SEC-2024', 1004, '2024-03-01', '2024-05-31', 95000, 'Completed', 'High'),
('TechForward Cloud Migration', 'TF-CLOUD-2024', 1005, '2024-02-15', '2024-09-30', 650000, 'In Progress', 'High');

-- Insert employee project assignments
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, HoursAllocated, HoursWorked, HourlyRate, StartDate) VALUES
(2001, 3001, 'Project Lead', 300, 180, 125.00, '2024-01-15'),
(2002, 3001, 'Senior Developer', 400, 245, 95.00, '2024-01-15'),
(2003, 3001, 'Backend Developer', 450, 280, 88.00, '2024-01-15'),
(2002, 3002, 'Lead Developer', 320, 195, 95.00, '2024-02-01'),
(2004, 3003, 'Data Science Lead', 350, 210, 135.00, '2024-01-08'),
(2005, 3003, 'Senior Data Scientist', 400, 240, 105.00, '2024-01-08'),
(2006, 3004, 'Security Lead', 200, 205, 140.00, '2024-03-01'),
(2007, 3005, 'Cloud Architect', 250, 155, 130.00, '2024-02-15'),
(2008, 3001, 'Project Manager', 250, 155, 115.00, '2024-01-15'),
(2008, 3002, 'Project Manager', 200, 125, 115.00, '2024-02-01');
```

## Lab Exercises

### Section 1: Your First T-SQL Queries! (🟢 BEGINNER LEVEL)

**🎓 TUTORIAL: What is a SELECT Query?**

A SELECT query is like asking a question of your database. Think of it like this:
- **You ask**: "Show me all employees in TechCorp"  
- **SQL Server responds**: Shows you a table with employee information
- **The magic word**: SELECT tells SQL Server you want to see data (not change it)

#### Exercise 1.1: Simple SELECT Statements (🟢 ABSOLUTE BEGINNER)

**What you'll learn**: How to ask the database to show you information

**Why this matters**: This is the foundation of everything else - 90% of what you do with databases is asking questions with SELECT

**Step-by-Step Tutorial:**

**Query #1: See All TechCorp Employees (Start Here!)**
```sql
-- Your first real business query!
-- This shows you everyone who works at TechCorp
SELECT * FROM Employees e;
```

**💡 What This Means:**
- `SELECT` = "Show me..."
- `*` = "...everything..." (all columns)  
- `FROM Employees` = "...from the Employees table"
- `;` = End of command (like a period in a sentence)

**Query #2: See Specific Information Only**
```sql
-- Sometimes you don't need all information - just the basics
SELECT 
    FirstName,
    LastName, 
    JobTitle,
    BaseSalary
FROM Employees e;
```

**💡 What This Means:**
- Instead of `*` (everything), we list exactly what we want to see
- This is better because it's faster and easier to read
- Notice we can split the query across multiple lines for readability

**Query #3: Create Your Own Columns with Calculations**
```sql
-- Let's do some business math - calculate monthly salaries
SELECT 
    FirstName + ' ' + LastName AS FullName,    -- Combine first and last name
    BaseSalary,                                -- Annual BaseSalary  
    BaseSalary / 12 AS MonthlySalary,         -- Calculate monthly BaseSalary
    JobTitle
FROM Employees e;
```

**💡 What This Means:**
- `FirstName + ' ' + LastName` = Combines text together (called "concatenation")
- `AS FullName` = Give this new column a name
- `BaseSalary / 12` = Basic math - divide annual BaseSalary by 12 months
- You can create new columns that don't exist in the original table!

**🎯 Success Check**: You should see:
1. A list of all employees (Query #1)
2. Just the basic info for each employee (Query #2)  
3. Full names and monthly BaseSalary calculations (Query #3)

**🚫 Common Beginner Mistakes:**
- Forgetting the semicolon (;) at the end
- Misspelling table or column names (use exact spelling!)  
- Forgetting commas between column names
- **Don't worry** - everyone makes these mistakes at first!
   - Full name in uppercase

5. **Date Functions**: Create a query showing:
   - Employee name
   - Hire date
   - Years of service (from hire date to current date)
   - Hire year

#### Exercise 1.2: Filtering Data
Write queries to:

1. Find all employees with BaseSalary greater than $70,000.

2. Find all employees hired after January 1, 2021.

3. Find all employees in the IT d.DepartmentName (DepartmentID = 1).

4. Find all employees whose first name starts with 'J'.

5. Find all employees with a middle name.

6. Find all active employees with BaseSalary between $50,000 and $80,000.

#### Exercise 1.3: Advanced Filtering
Write queries to:

1. Find employees whose email contains 'gmail' or 'company'.

2. Find employees hired in 2021 or 2022.

3. Find employees with BaseSalary > $60,000 AND (in IT OR Marketing departments).

4. Find employees whose last name ends with 'son' or 'er'.

### Section 2: Set Operations (Lesson 2)

#### Exercise 2.1: Basic Set Operations
Write queries to:

1. **UNION**: Get a list of all first names from both Employees and a hypothetical Customers table (use Employees twice with different filters).

2. **INTERSECT**: Find d.DepartmentName IDs that have both high-BaseSalary employees (>$70k) and low-BaseSalary employees (<$60k).

3. **EXCEPT**: Find employees who are not assigned to any projects.

#### Exercise 2.2: Set Membership
Write queries to:

1. Find employees whose d.DepartmentName ID is in the list (1, 3, 5).

2. Find employees who work on projects with status 'In Progress'.

3. Find departments that have employees (using EXISTS).

4. Find employees who are not managers (not in ManagerID column of other employees).

#### Exercise 2.3: Advanced Set Operations
Write queries to:

1. Find employees who work on ALL active projects.

2. Create a report showing employees who work on the same projects as employee with ID 2.

3. Find departments where ALL employees earn more than $55,000.

### Section 3: Predicate Logic (Lesson 3)

#### Exercise 3.1: NULL Handling
Write queries to:

1. Find employees with no middle name.

2. Find employees where middle name is either NULL or empty string.

3. Create a report showing full names, handling NULL middle names gracefully.

4. Find employees whose manager ID is NULL (top-level managers).

#### Exercise 3.2: Complex Predicates
Write queries to:

1. Find employees where (BaseSalary > $70k AND d.DepartmentName is IT) OR (BaseSalary > $80k).

2. Find projects that are either completed OR have a budget > $100k.

3. Find employees hired in Q1 of any year (January-March).

4. Find employees whose title contains 'Director' or 'Manager'.

#### Exercise 3.3: Advanced Pattern Matching
Write queries to:

1. Find employees with exactly 5-character first names.

2. Find employees whose email follows the pattern: firstname.lastname@company.com.

3. Find projects with names containing exactly two words.

### Section 4: Logical Order of Operations (Lesson 4)

#### Exercise 4.1: Understanding Processing Order
For each query, explain the logical processing order:

1. ```sql
   SELECT DepartmentID, AVG(e.BaseSalary) as AvgSalary
   FROM Employees
   WHERE IsActive = 1
   GROUP BY DepartmentIDID
   HAVING COUNT(*) > 2
   ORDER BY AvgSalary DESC;
   ```

2. ```sql
   SELECT e.FirstName, e.LastName, d.DepartmentName
   FROM Employees e
   JOIN Departments d ON e.DepartmentID = d.DepartmentID
   WHERE e.BaseSalary > 60000
   ORDER BY d.DepartmentName;
   ```

#### Exercise 4.2: Alias Usage
Identify what's wrong with these queries and fix them:

1. ```sql
   SELECT FirstName + ' ' + LastName AS FullName, BaseSalary
   FROM Employees
   WHERE FullName LIKE 'John%';
   ```

2. ```sql
   SELECT DepartmentID, COUNT(*) AS EmpCount
   FROM Employees
   WHERE EmpCount > 2
   GROUP BY DepartmentIDID;
   ```

#### Exercise 4.3: WHERE vs HAVING
Write queries using appropriate filtering:

1. Find departments with more than 2 employees, showing only active employees.

2. Find employees in departments where the average BaseSalary is > $65,000.

3. Show d.DepartmentName statistics, but only for departments with budget > $250,000.

### Section 5: Comprehensive Challenges

#### Challenge 1: d.DepartmentName Analysis
Create a comprehensive d.DepartmentName report showing:
- d.DepartmentName name
- Number of active employees
- Average BaseSalary
- Highest and lowest salaries
- Number of ongoing projects
- Total project budget
Only include departments with at least 2 employees.

#### Challenge 2: Employee Performance Analysis
Create a report showing:
- Employee name and title
- d.DepartmentName name
- Number of projects assigned
- Total hours allocated vs hours worked
- Performance ratio (hours worked / hours allocated)
- Whether they're ahead, behind, or on track

#### Challenge 3: Hierarchical Analysis
Create a query that shows:
- Manager name
- Number of direct reports
- Average BaseSalary of direct reports
- Highest-paid direct report
- Only show managers with at least 2 direct reports

#### Challenge 4: Project Resource Analysis
Create a analysis showing:
- Project name and status
- Number of employees assigned
- Total hours allocated
- Total hours worked
- Percentage completion
- Whether project is over or under allocated

## Lab Deliverables

1. **SQL Scripts**: Create .sql files with your solutions for each section.

2. **Execution Results**: Screenshot or text output showing query results.

3. **Explanations**: Written explanations for the logical processing order exercises.

4. **Reflection**: A brief summary of what you learned and any challenges encountered.

## Tips for Success

1. **Test Incrementally**: Start with simple queries and build complexity gradually.

2. **Use Comments**: Document your queries with comments explaining your logic.

3. **Verify Results**: Cross-check your results with manual calculations where possible.

4. **Performance Awareness**: Consider how your queries might perform on larger datasets.

5. **Handle Edge Cases**: Consider NULL values and empty result sets.

## Additional Practice

After completing the main exercises, try these variations:

1. **Modify the queries** to use different filtering criteria.

2. **Combine multiple concepts** in single queries.

3. **Optimize queries** for better performance.

4. **Add error handling** and data validation.

5. **Create views** based on your complex queries.

This lab provides hands-on experience with core T-SQL concepts and prepares you for more advanced database programming topics.
