# Lab: Introduction to T-SQL Querying

## Lab Overview
This lab provides hands-on practice with T-SQL fundamentals including basic querying, set operations, predicate logic, and understanding the logical order of operations. You'll work with a sample database to reinforce the concepts learned in Lessons 1-4.

## Lab Setup

### Sample Database Schema
For this lab, we'll use a simplified company database with the following tables:

```sql
-- Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    Email NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    ManagerID INT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Title NVARCHAR(100) NOT NULL
);

-- Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    ManagerID INT NULL
);

-- Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Budget DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(20) NOT NULL
);

-- EmployeeProjects table (many-to-many relationship)
CREATE TABLE EmployeeProjects (
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    HoursAllocated DECIMAL(5,2) NOT NULL,
    HoursWorked DECIMAL(5,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (EmployeeID, ProjectID)
);
```

### Sample Data
```sql
-- Insert sample departments
INSERT INTO Departments (DepartmentName, Budget, ManagerID) VALUES
('Information Technology', 500000, NULL),
('Human Resources', 200000, NULL),
('Finance', 300000, NULL),
('Marketing', 250000, NULL),
('Operations', 400000, NULL);

-- Insert sample employees
INSERT INTO Employees (FirstName, LastName, MiddleName, Email, DepartmentID, ManagerID, BaseSalary, HireDate, Title) VALUES
('John', 'Smith', 'Michael', 'john.smith@company.com', 1, NULL, 95000, '2020-01-15', 'IT Director'),
('Sarah', 'Johnson', NULL, 'sarah.johnson@company.com', 1, 1, 75000, '2021-03-10', 'Senior Developer'),
('Mike', 'Davis', 'Robert', 'mike.davis@company.com', 1, 1, 65000, '2021-06-01', 'Developer'),
('Emma', 'Wilson', 'Kate', 'emma.wilson@company.com', 2, NULL, 80000, '2020-02-20', 'HR Director'),
('David', 'Brown', NULL, 'david.brown@company.com', 2, 4, 55000, '2022-01-10', 'HR Specialist'),
('Lisa', 'Miller', 'Ann', 'lisa.miller@company.com', 3, NULL, 90000, '2019-11-05', 'Finance Director'),
('Tom', 'Anderson', 'James', 'tom.anderson@company.com', 3, 6, 60000, '2021-09-15', 'Financial Analyst'),
('Jennifer', 'Taylor', NULL, 'jennifer.taylor@company.com', 4, NULL, 85000, '2020-05-12', 'Marketing Director'),
('Robert', 'Clark', 'Lee', 'robert.clark@company.com', 4, 8, 50000, '2022-03-20', 'Marketing Specialist'),
('Amanda', 'Lewis', 'Grace', 'amanda.lewis@company.com', 5, NULL, 88000, '2020-08-18', 'Operations Director');

-- Insert sample projects
INSERT INTO Projects (ProjectName, StartDate, EndDate, Budget, Status) VALUES
('Website Redesign', '2023-01-01', '2023-06-30', 150000, 'Completed'),
('ERP Implementation', '2023-03-01', NULL, 300000, 'In Progress'),
('Marketing Campaign Q3', '2023-07-01', '2023-09-30', 75000, 'Completed'),
('Security Audit', '2023-09-01', NULL, 50000, 'In Progress'),
('Process Optimization', '2023-05-01', '2023-11-30', 100000, 'In Progress');

-- Insert sample employee project assignments
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursAllocated, HoursWorked) VALUES
(1, 2, 100, 75),
(2, 1, 200, 210),
(2, 2, 150, 120),
(3, 1, 180, 185),
(3, 4, 80, 60),
(8, 3, 160, 165),
(9, 3, 120, 125),
(10, 5, 200, 150);
```

## Lab Exercises

### Section 1: Basic T-SQL Queries (Lesson 1)

#### Exercise 1.1: Simple SELECT Statements
Write queries to:

1. **Basic Selection**: Select all columns from the Employees table.

2. **Column Selection**: Select only FirstName, LastName, and BaseSalary from Employees.

3. **Calculated Columns**: Create a query that shows:
   - Full name (FirstName + LastName)
   - Annual salary
   - Monthly salary (annual salary / 12)

4. **String Functions**: Create a query showing:
   - Employee email username (part before @)
   - Email domain (part after @)
   - Full name in uppercase

5. **Date Functions**: Create a query showing:
   - Employee name
   - Hire date
   - Years of service (from hire date to current date)
   - Hire year

#### Exercise 1.2: Filtering Data
Write queries to:

1. Find all employees with salary greater than $70,000.

2. Find all employees hired after January 1, 2021.

3. Find all employees in the IT department (DepartmentID = 1).

4. Find all employees whose first name starts with 'J'.

5. Find all employees with a middle name.

6. Find all active employees with salary between $50,000 and $80,000.

#### Exercise 1.3: Advanced Filtering
Write queries to:

1. Find employees whose email contains 'gmail' or 'company'.

2. Find employees hired in 2021 or 2022.

3. Find employees with salary > $60,000 AND (in IT OR Marketing departments).

4. Find employees whose last name ends with 'son' or 'er'.

### Section 2: Set Operations (Lesson 2)

#### Exercise 2.1: Basic Set Operations
Write queries to:

1. **UNION**: Get a list of all first names from both Employees and a hypothetical Customers table (use Employees twice with different filters).

2. **INTERSECT**: Find department IDs that have both high-salary employees (>$70k) and low-salary employees (<$60k).

3. **EXCEPT**: Find employees who are not assigned to any projects.

#### Exercise 2.2: Set Membership
Write queries to:

1. Find employees whose department ID is in the list (1, 3, 5).

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

1. Find employees where (salary > $70k AND department is IT) OR (salary > $80k).

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
   SELECT DepartmentID, AVG(BaseSalary) as AvgSalary
   FROM Employees
   WHERE IsActive = 1
   GROUP BY DepartmentID
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
   GROUP BY DepartmentID;
   ```

#### Exercise 4.3: WHERE vs HAVING
Write queries using appropriate filtering:

1. Find departments with more than 2 employees, showing only active employees.

2. Find employees in departments where the average salary is > $65,000.

3. Show department statistics, but only for departments with budget > $250,000.

### Section 5: Comprehensive Challenges

#### Challenge 1: Department Analysis
Create a comprehensive department report showing:
- Department name
- Number of active employees
- Average salary
- Highest and lowest salaries
- Number of ongoing projects
- Total project budget
Only include departments with at least 2 employees.

#### Challenge 2: Employee Performance Analysis
Create a report showing:
- Employee name and title
- Department name
- Number of projects assigned
- Total hours allocated vs hours worked
- Performance ratio (hours worked / hours allocated)
- Whether they're ahead, behind, or on track

#### Challenge 3: Hierarchical Analysis
Create a query that shows:
- Manager name
- Number of direct reports
- Average salary of direct reports
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
