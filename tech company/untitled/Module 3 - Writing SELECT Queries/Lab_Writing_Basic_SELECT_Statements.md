# Lab: Writing Basic SELECT Statements

## Lab Overview
This lab provides hands-on practice with fundamental SELECT statement concepts including basic queries, using DISTINCT, working with aliases, and implementing CASE expressions. You'll work with a comprehensive database to reinforce the concepts learned in Lessons 1-4 of Module 3.

## Lab Setup - TechCorp Solutions Continued

### Continuing from Module 2
In Module 2, we created the TechCorp database schema and populated it with basic company data. Now in Module 3, we'll expand the data and learn advanced SELECT statement techniques by working with TechCorp's growing business.

**Prerequisites:**
- TechCorpDB database with tables from Module 2
- Understanding of T-SQL fundamentals from Module 2

```sql
-- Connect to our TechCorp database
USE TechCorpDB;
GO

-- Verify our existing data
SELECT 
    'Companies' as TableName, COUNT(*) as RecordCount FROM Companies
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments  
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects;
```

### Module 3 Schema Extensions
We'll add new tables to support advanced SELECT operations:

```sql
-- Employees table (expanded)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    WorkEmail NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL,
    DepartmentID INT NOT NULL,
    ManagerID INT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Title NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NULL,
    State NVARCHAR(2) NULL,
    BirthDate DATE NULL,
    EmergencyContact NVARCHAR(100) NULL
);

-- Departments table (expanded)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL,
    DepartmentCode NVARCHAR(10) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    ManagerID INT NULL,
    Location NVARCHAR(50) NULL,
    CostCenter NVARCHAR(20) NULL
);

-- Projects table (expanded)
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(100) NOT NULL,
    ProjectCode NVARCHAR(20) NOT NULL,
    Description TEXT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    PlannedEndDate DATE NULL,
    Budget DECIMAL(10,2) NOT NULL,
    ActualCost DECIMAL(10,2) NULL,
    IsActive NVARCHAR(20) NOT NULL,
    Priority NVARCHAR(10) NOT NULL,
    ClientName NVARCHAR(100) NULL
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
    EndDate DATE NULL,
    PRIMARY KEY (EmployeeID, ProjectID)
);

-- Skills table
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(1,1),
    SkillName NVARCHAR(50) NOT NULL,
    SkillCategory NVARCHAR(30) NOT NULL,
    DifficultyLevel NVARCHAR(20) NOT NULL
);

-- EmployeeSkills table
CREATE TABLE EmployeeSkills (
    EmployeeID INT NOT NULL,
    SkillID INT NOT NULL,
    ProficiencyLevel NVARCHAR(20) NOT NULL,
    YearsExperience INT NOT NULL,
    CertificationDate DATE NULL,
    PRIMARY KEY (EmployeeID, SkillID)
);
```

### Sample Data
```sql
-- Insert expanded sample data
INSERT INTO Departments (DepartmentName, DepartmentCode, Budget, Location, CostCenter) VALUES
('Information Technology', 'IT', 750000, 'Building A - Floor 3', 'CC001'),
('Human Resources', 'HR', 300000, 'Building A - Floor 2', 'CC002'),
('Finance', 'FIN', 450000, 'Building A - Floor 4', 'CC003'),
('Marketing', 'MKT', 350000, 'Building B - Floor 1', 'CC004'),
('Operations', 'OPS', 600000, 'Building B - Floor 2', 'CC005'),
('Research & Development', 'RND', 800000, 'Building C - Floor 1', 'CC006');

INSERT INTO Employees (FirstName, LastName, MiddleName, WorkEmail, Phone, DepartmentID, ManagerID, BaseSalary, HireDate, Title, City, State, BirthDate, EmergencyContact) VALUES
('John', 'Smith', 'Michael', 'john.smith@company.com', '555-0101', 1, NULL, 95000, '2020-01-15', 'IT Director', 'Seattle', 'WA', '1985-03-12', 'Jane Smith'),
('Sarah', 'Johnson', NULL, 'sarah.johnson@company.com', '555-0102', 1, 1, 75000, '2021-03-10', 'Senior Developer', 'Seattle', 'WA', '1990-07-22', 'Mike Johnson'),
('Mike', 'Davis', 'Robert', 'mike.davis@company.com', '555-0103', 1, 1, 65000, '2021-06-01', 'Developer', 'Bellevue', 'WA', '1992-11-08', 'Lisa Davis'),
('Emma', 'Wilson', 'Kate', 'emma.wilson@company.com', '555-0104', 2, NULL, 80000, '2020-02-20', 'HR Director', 'Seattle', 'WA', '1983-09-15', 'Tom Wilson'),
('David', 'Brown', NULL, 'david.brown@company.com', '555-0105', 2, 4, 55000, '2022-01-10', 'HR Specialist', 'Redmond', 'WA', '1995-01-30', 'Mary Brown'),
('Lisa', 'Miller', 'Ann', 'lisa.miller@company.com', '555-0106', 3, NULL, 90000, '2019-11-05', 'Finance Director', 'Seattle', 'WA', '1980-12-03', 'James Miller'),
('Tom', 'Anderson', 'James', 'tom.anderson@company.com', '555-0107', 3, 6, 60000, '2021-09-15', 'Financial Analyst', 'Tacoma', 'WA', '1988-04-18', 'Sue Anderson'),
('Jennifer', 'Taylor', NULL, 'jennifer.taylor@company.com', '555-0108', 4, NULL, 85000, '2020-05-12', 'Marketing Director', 'Seattle', 'WA', '1987-06-25', 'Bob Taylor'),
('Robert', 'Clark', 'Lee', 'robert.clark@company.com', '555-0109', 4, 8, 50000, '2022-03-20', 'Marketing Specialist', 'Spokane', 'WA', '1993-08-14', 'Amy Clark'),
('Amanda', 'Lewis', 'Grace', 'amanda.lewis@company.com', '555-0110', 5, NULL, 88000, '2020-08-18', 'Operations Director', 'Seattle', 'WA', '1982-02-28', 'Steve Lewis'),
('Kevin', 'White', NULL, 'kevin.white@company.com', '555-0111', 1, 1, 72000, '2021-12-01', 'Senior Developer', 'Seattle', 'WA', '1989-10-05', 'Carol White'),
('Nancy', 'Martinez', 'Rose', 'nancy.martinez@company.com', '555-0112', 6, NULL, 92000, '2019-09-30', 'R&D Director', 'Bellevue', 'WA', '1979-11-12', 'Carlos Martinez'),
('Chris', 'Garcia', 'Allen', 'chris.garcia@company.com', '555-0113', 6, 12, 70000, '2021-04-22', 'Research Scientist', 'Seattle', 'WA', '1986-05-17', 'Maria Garcia'),
('Diana', 'Rodriguez', NULL, 'diana.rodriguez@company.com', '555-0114', 2, 4, 52000, '2022-07-11', 'HR Coordinator', 'Federal Way', 'WA', '1994-09-02', 'Luis Rodriguez'),
('Mark', 'Thompson', 'William', 'mark.thompson@company.com', '555-0115', 5, 10, 58000, '2021-11-08', 'Operations Analyst', 'Kent', 'WA', '1991-12-20', 'Linda Thompson');

INSERT INTO Projects (ProjectName, ProjectCode, Description, StartDate, EndDate, PlannedEndDate, Budget, ActualCost, IsActive, Priority, ClientName) VALUES
('Website Redesign', 'WEB001', 'Complete redesign of company website', '2023-01-01', '2023-06-30', '2023-06-15', 150000, 148000, 'Completed', 'High', 'Internal'),
('ERP Implementation', 'ERP001', 'Enterprise Resource Planning system implementation', '2023-03-01', NULL, '2024-02-28', 500000, 275000, 'In Progress', 'Critical', 'Internal'),
('Marketing Campaign Q4', 'MKT001', 'Q4 2023 marketing campaign launch', '2023-07-01', '2023-12-31', '2023-12-31', 100000, 95000, 'Completed', 'Medium', 'External Client A'),
('Security Audit', 'SEC001', 'Comprehensive security assessment', '2023-09-01', NULL, '2024-01-31', 75000, 32000, 'In Progress', 'High', 'Internal'),
('Mobile App Development', 'MOB001', 'Customer-facing mobile application', '2023-05-01', NULL, '2024-04-30', 200000, 125000, 'In Progress', 'High', 'External Client B'),
('Data Migration', 'DAT001', 'Legacy system data migration', '2023-08-15', '2023-11-30', '2023-11-15', 80000, 82000, 'Completed', 'Medium', 'Internal'),
('Training Program', 'TRN001', 'Employee skills development program', '2023-10-01', NULL, '2024-03-31', 60000, 25000, 'In Progress', 'Low', 'Internal');

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, HoursAllocated, HoursWorked, HourlyRate, StartDate) VALUES
(1, 2, 'Project Manager', 200, 150, 95.00, '2023-03-01'),
(2, 1, 'Lead Developer', 300, 320, 75.00, '2023-01-01'),
(2, 2, 'Senior Developer', 250, 180, 75.00, '2023-03-01'),
(3, 1, 'Developer', 280, 290, 65.00, '2023-01-01'),
(3, 4, 'Developer', 150, 95, 65.00, '2023-09-01'),
(8, 3, 'Campaign Manager', 200, 210, 85.00, '2023-07-01'),
(9, 3, 'Marketing Assistant', 180, 175, 50.00, '2023-07-01'),
(10, 5, 'Project Coordinator', 160, 120, 88.00, '2023-05-01'),
(11, 2, 'Developer', 220, 160, 72.00, '2023-03-01'),
(11, 5, 'Mobile Developer', 180, 140, 72.00, '2023-05-01'),
(12, 7, 'Training Coordinator', 120, 85, 92.00, '2023-10-01'),
(13, 6, 'Data Analyst', 200, 205, 70.00, '2023-08-15');

INSERT INTO Skills (SkillName, SkillCategory, DifficultyLevel) VALUES
('SQL Server', 'Database', 'Intermediate'),
('C#', 'Programming', 'Advanced'),
('JavaScript', 'Programming', 'Intermediate'),
('Project Management', 'Management', 'Advanced'),
('Data Analysis', 'Analytics', 'Intermediate'),
('Marketing Strategy', 'Marketing', 'Advanced'),
('Financial Analysis', 'Finance', 'Intermediate'),
('Python', 'Programming', 'Intermediate'),
('Azure', 'Cloud', 'Advanced'),
('Power BI', 'Analytics', 'Beginner');

INSERT INTO EmployeeSkills (EmployeeID, SkillID, ProficiencyLevel, YearsExperience, CertificationDate) VALUES
(1, 1, 'Expert', 8, '2018-05-15'),
(1, 4, 'Expert', 10, '2017-03-20'),
(1, 9, 'Advanced', 5, '2020-08-10'),
(2, 1, 'Advanced', 5, '2021-02-14'),
(2, 2, 'Expert', 6, '2019-11-30'),
(2, 3, 'Advanced', 4, NULL),
(3, 1, 'Intermediate', 3, NULL),
(3, 2, 'Advanced', 4, '2022-01-15'),
(3, 8, 'Intermediate', 2, NULL),
(6, 7, 'Expert', 12, '2015-06-20'),
(7, 7, 'Advanced', 3, NULL),
(8, 6, 'Expert', 8, '2018-09-10'),
(11, 2, 'Advanced', 4, '2021-12-05'),
(11, 3, 'Expert', 5, '2020-07-22'),
(12, 5, 'Expert', 9, '2019-04-18'),
(13, 5, 'Advanced', 4, NULL);
```

## Lab Exercises

### Section 1: Basic SELECT Statements (Lesson 1)

#### Exercise 1.1: Simple Data Retrieval
Write queries to:

1. **All Employee Information**: Select all columns from the Employees table.

2. **Specific Columns**: Select only FirstName, LastName, Title, and BaseSalary from Employees.

3. **Department Information**: Select DepartmentName, Budget, and Location from Departments.

4. **Project Overview**: Select ProjectName, IsActive, Budget, and ClientName from Projects.

#### Exercise 1.2: Calculated Columns
Write queries to:

1. **Employee Full Names**: Create a query showing:
   - Full name (FirstName + MiddleName + LastName, handling NULLs)
   - WorkEmail domain (part after @)
   - Years of service
   - Monthly BaseSalary

2. **Project Financial Analysis**: Create a query showing:
   - Project name and code
   - Budget vs actual cost variance
   - Percentage of budget used
   - Days from start to planned end
   - Project duration category (Short: <90 days, Medium: 90-365 days, Long: >365 days)

3. **Employee Demographics**: Create a query showing:
   - Employee name
   - Current age (calculated from birth date)
   - Age when hired
   - Phone number formatted as (XXX) XXX-XXXX

#### Exercise 1.3: String and Date Manipulations
Write queries to:

1. **Advanced String Operations**: 
   - Create employee initials (first letter of each name)
   - Extract city and state as "City, State"
   - Generate employee codes: first 3 letters of last name + employee ID
   - Identify employees with similar names (same first 3 letters of last name)

2. **Date Analysis**:
   - Find employees hired in each season (Spring, Summer, Fall, Winter)
   - Calculate exact tenure in years, months, and days
   - Identify hire date patterns (weekday vs weekend)
   - Find employees with birthdays in the current month

### Section 2: Working with DISTINCT (Lesson 2)

#### Exercise 2.1: Basic DISTINCT Operations
Write queries to:

1. **Unique Values Analysis**:
   - Find all unique job titles in the company
   - List all unique cities where employees live
   - Show all unique department locations
   - Find all unique project statuses and priorities

2. **Data Profiling**:
   - Count total employees vs unique first names
   - Count total vs unique email domains
   - Find unique BaseSalary amounts and count how many earn each amount
   - Identify unique skill categories and difficulty levels

#### Exercise 2.2: DISTINCT with Multiple Columns
Write queries to:

1. **Combination Analysis**:
   - Find unique department and title combinations
   - List unique city and state combinations
   - Show unique project status and priority combinations
   - Find unique skill category and difficulty level pairs

2. **Business Intelligence**:
   - Identify unique employee role types across projects
   - Find unique client and project status combinations
   - Show unique hire year and department combinations

#### Exercise 2.3: Advanced DISTINCT Applications
Write queries to:

1. **Data Quality Assessment**:
   - Find potential duplicate employees (same name combinations)
   - Identify inconsistent data entry in city names
   - Find unique email domain patterns for validation

2. **Complex Distinct Analysis**:
   - Find departments with unique organizational structures
   - Identify employees with unique skill combinations
   - Analyze project diversity across departments

### Section 3: Using Aliases (Lesson 3)

#### Exercise 3.1: Column Aliases
Write queries to:

1. **Professional Report Headers**:
   - Create a employee directory with professional column names
   - Generate a project status report with business-friendly headers
   - Produce a department budget report with formatted column names

2. **Calculated Field Aliases**:
   - Create meaningful names for all calculated fields
   - Use aliases that clearly describe business metrics
   - Ensure all output is ready for business presentation

#### Exercise 3.2: Table Aliases
Write queries to:

1. **Simple Join Scenarios**:
   - Join Employees and Departments using meaningful table aliases
   - Join Projects and EmployeeProjects with clear alias conventions
   - Create multi-table joins with consistent alias patterns

2. **Self-Join Scenarios**:
   - Find manager-employee relationships using appropriate aliases
   - Identify employees with the same BaseSalary using self-join
   - Compare project costs using self-referencing aliases

#### Exercise 3.3: Complex Alias Scenarios
Write queries to:

1. **Advanced Multi-Table Queries**:
   - Create comprehensive employee-project-department reports
   - Build skill analysis reports across multiple tables
   - Generate complex business intelligence queries with clear aliases

2. **Subquery Aliases**:
   - Use subqueries with meaningful aliases
   - Create derived tables with business-relevant names
   - Build nested queries with clear alias hierarchies

### Section 4: CASE Expressions (Lesson 4)

#### Exercise 4.1: Simple CASE Expressions
Write queries to:

1. **Basic Categorization**:
   - Create BaseSalary categories (Entry, Mid, Senior, Executive)
   - Categorize employees by tenure (New, Junior, Experienced, Veteran)
   - Classify projects by duration (Short, Medium, Long-term)
   - Group departments by budget size (Small, Medium, Large)

2. **IsActive Indicators**:
   - Convert bit fields to readable status
   - Transform project status codes to descriptions
   - Create employee availability indicators

#### Exercise 4.2: Searched CASE Expressions
Write queries to:

1. **Complex Business Rules**:
   - Implement performance rating based on multiple criteria
   - Create bonus eligibility determination logic
   - Build project risk assessment categories
   - Develop employee career track recommendations

2. **Multi-Criteria Classification**:
   - Combine BaseSalary, tenure, and department for employee segmentation
   - Use project budget, duration, and status for project classification
   - Create comprehensive skill level assessments

#### Exercise 4.3: Advanced CASE Applications
Write queries to:

1. **Conditional Calculations**:
   - Calculate different bonus amounts based on department and performance
   - Determine project completion bonuses with complex criteria
   - Create dynamic hourly rate adjustments

2. **Business Intelligence Scenarios**:
   - Build management dashboard indicators
   - Create automated alert systems using CASE logic
   - Develop predictive categorization for resource planning

### Section 5: Comprehensive Integration Challenges

#### Challenge 1: Employee Performance Dashboard
Create a comprehensive query that includes:
- Employee demographics with proper aliases
- Service tenure categorization using CASE
- BaseSalary position analysis within department
- Project involvement summary
- Performance indicators using complex business rules
- Professional presentation with meaningful column names

#### Challenge 2: Project Resource Analysis
Build a detailed project analysis including:
- Project financial health indicators
- Resource utilization metrics
- Timeline analysis with CASE-based categorization
- Team composition and skill analysis
- Risk assessment using multiple criteria
- Executive summary format with business aliases

#### Challenge 3: Department Optimization Report
Develop a department analysis featuring:
- Budget utilization and efficiency metrics
- Employee distribution and diversity analysis
- Skill gap identification across departments
- Performance benchmarking using CASE expressions
- Resource allocation recommendations
- Strategic insights with professional presentation

#### Challenge 4: Skills and Career Development Analysis
Create a comprehensive skills analysis including:
- Employee skill portfolio assessment
- Career development recommendations using CASE logic
- Training needs identification
- Skill gap analysis across projects
- Professional development pathways
- Certification tracking and recommendations

## Lab Deliverables

1. **SQL Query Files**: Organized .sql files for each section
2. **Results Documentation**: Screenshots or exported results for key queries
3. **Business Explanations**: Written explanations of complex business logic
4. **Best Practices Report**: Documentation of alias conventions and CASE logic used
5. **Challenge Solutions**: Complete solutions to integration challenges with explanations

## Evaluation Criteria

### Technical Accuracy (40%)
- Queries execute without errors
- Results are logically correct
- Proper syntax and formatting used

### Best Practices Implementation (25%)
- Meaningful aliases throughout
- Proper CASE expression structure
- Efficient DISTINCT usage
- Professional query formatting

### Business Logic (20%)
- CASE expressions implement realistic business rules
- Calculated fields provide meaningful insights
- Results are business-relevant and actionable

### Code Quality (15%)
- Clear, readable code structure
- Consistent naming conventions
- Appropriate comments and documentation
- Maintainable query design

## Tips for Success

1. **Start Simple**: Begin with basic queries and gradually add complexity
2. **Test Incrementally**: Verify each component before combining
3. **Use Meaningful Names**: All aliases should be self-documenting
4. **Document Complex Logic**: Explain your CASE expression reasoning
5. **Consider Performance**: Think about efficiency in your query design
6. **Format Consistently**: Use consistent indentation and capitalization
7. **Validate Results**: Cross-check calculations and logic manually

## Time Allocation
- Section 1 (Basic SELECT): 1.5 hours
- Section 2 (DISTINCT): 1 hour
- Section 3 (Aliases): 1 hour
- Section 4 (CASE): 1.5 hours
- Section 5 (Challenges): 2 hours
- **Total Recommended Time: 7 hours**

This lab will solidify your foundation in basic SELECT statement construction and prepare you for more advanced T-SQL concepts in subsequent modules.
