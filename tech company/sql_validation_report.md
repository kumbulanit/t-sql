# SQL Validation Report

Generated: 2025-12-02 08:18:49
- Total SQL blocks: 2752
- ✅ Passed: 2752
- ❌ Failed: 0

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 1, line 47)
> -- 1. Connect to TechCorp database using SSMS / -- 2. Verify server information and database details / -- 3. List all tables and their row counts

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 2, line 73)
> -- Employee full name (handle middle names gracefully) / -- Job title and d.DepartmentName / -- Formatted BaseSalary with currency symbol

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 3, line 104)
> -- Show BaseSalary distribution by d.DepartmentName / -- Calculate BaseSalary percentiles and ranges / -- Identify potential pay equity issues

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 4, line 125)
> -- d.DepartmentName name and head information / -- Total employees and average BaseSalary per d.DepartmentName / -- Active projects per d.DepartmentName

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 5, line 147)
> -- Show which employees work on which projects / -- Identify cross-departmental collaboration / -- Find employees working on multiple projects

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 6, line 167)
> -- Find top 10 highest-paid employees by d.DepartmentName / -- Identify employees eligible for promotion (based on tenure/performance) / -- Show employees with rare or valuable skills

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 7, line 190)
> -- Show projects sorted by priority and deadline / -- Filter for projects at risk (behind schedule or over budget) / -- Identify projects needing immediate attention

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 8, line 209)
> -- Clean and standardize employee names / -- Extract domain names from email addresses / -- Format phone numbers consistently

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 9, line 217)
> -- Calculate exact years of service / -- Show upcoming work anniversaries / -- Analyze hiring patterns by month/year

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 10, line 225)
> -- Convert BaseSalary data to different currencies / -- Format numbers with appropriate precision / -- Handle data type conversions safely

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 11, line 232)
> -- Use IIF for inline conditional logic / -- Implement CHOOSE for multi-option scenarios / -- Handle complex business rules

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 12, line 239)
> -- Use ISNULL and COALESCE appropriately / -- Handle missing data gracefully / -- Provide meaningful defaults

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 13, line 263)
> -- Total employees, average BaseSalary, BaseSalary ranges / -- Min/max tenure, average experience / -- Skill count and diversity metrics

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 14, line 271)
> -- Project count by status and priority / -- Total/average budget and actual costs / -- Success rate and completion metrics

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 15, line 279)
> -- Revenue by d.DepartmentName and project type / -- Profit margins and cost analysis / -- Growth trends and forecasting data

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 16, line 300)
> -- d.DepartmentName efficiency ratios / -- Employee utilization rates / -- Project success metrics

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 17, line 317)
> -- Give 5% raise to employees with > 3 years tenure / -- Apply merit increases to top performers / -- Adjust salaries for market competitiveness

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 18, line 324)
> -- Update project statuses based on completion criteria / -- Add new projects for Q4 planning / -- Modify project budgets based on scope changes

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 19, line 331)
> -- Add new hire records / -- Update employee information (promotions, transfers) / -- Handle employee departure procedures

✅ **tech company/untitled/COMPREHENSIVE_BEGINNER_CHALLENGE.md** (block 20, line 377)
> -- Well-commented, properly formatted query

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 1, line 17)
> SELECT Companies.CompanyName, Departments.d.DepartmentName, Employees.e.FirstName / FROM Companies / INNER JOIN Departments d ON Companies.CompanyID = Departments.CompanyID

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 2, line 25)
> SELECT c.CompanyName, d.DepartmentName, e.FirstName / FROM Companies c                    -- "c" is the alias for Companies / INNER JOIN Departments d ON c.CompanyID = d.CompanyID    -- "d" is alias for Departments

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 3, line 54)
> -- ================================ / -- QUESTION 1: BASIC T-SQL SYNTAX / -- Module 2, Lesson 1: Introducing T-SQL

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 4, line 101)
> -- ================================ / -- DATA EXPLORATION WITH BASIC T-SQL / -- Module References: Module 2 (Lesson 1), Module 3 (Lesson 1 preview)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 5, line 156)
> -- ================================ / -- SET THEORY AND PREDICATE LOGIC IN T-SQL / -- Module References: Module 2 (Lessons 2-4)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 6, line 285)
> -- ================================ / -- DATABASE SCHEMA AND TABLE ANALYSIS / -- Module References: Module 1 (Lesson 3), Module 2 (Lesson 2)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 7, line 350)
> -- ================================ / -- DATA QUALITY AND COMPLETENESS CHECK / -- Module References: Module 5 (Lesson 4), Module 8 (Lesson 4)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 8, line 419)
> -- ================================ / -- COMPREHENSIVE EMPLOYEE PROFILE DASHBOARD / -- Module References: Module 3 (All Lessons), Module 6 (Lessons 2-3)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 9, line 531)
> -- ================================ / -- COMPENSATION ANALYSIS AND EQUITY REVIEW / -- Module References: Module 3 (Lesson 2), Module 9 (Lessons 1-3)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 10, line 655)
> -- ================================ / -- MANAGEMENT HIERARCHY AND SPAN OF CONTROL / -- Module References: Module 4 (Lesson 4 - Self Joins)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 11, line 738)
> -- ================================ / -- d.DepartmentName COLLABORATION AND CROSS-FUNCTIONAL ANALYSIS / -- Module References: Module 4 (Lesson 4 - Cross Joins)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 12, line 822)
> -- ================================ / -- PROJECT TEAM COMPOSITION AND SKILL ANALYSIS / -- Module References: Module 4 (Lessons 2-3 - Inner and Outer Joins)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 13, line 953)
> -- ================================ / -- TOP PERFORMER IDENTIFICATION BY d.DepartmentName / -- Module References: Module 5 (Lessons 1-3)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part1.md** (block 14, line 1061)
> -- ================================ / -- RETENTION RISK ASSESSMENT AND EARLY WARNING SYSTEM / -- Module References: Module 5 (Lessons 2-4)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part2.md** (block 1, line 13)
> -- ================================ / -- STRING FUNCTION MASTERY AND DATA STANDARDIZATION / -- Module References: Module 8 (Lessons 1-2 - String Functions)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part2.md** (block 2, line 127)
> -- ================================ / -- DATE/TIME FUNCTION MASTERY AND TEMPORAL ANALYSIS / -- Module References: Module 6 (Lesson 3), Module 8 (Lesson 3)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part2.md** (block 3, line 263)
> -- ================================ / -- MATHEMATICAL FUNCTION MASTERY AND FINANCIAL ANALYSIS / -- Module References: Module 8 (Lesson 4 - Mathematical Functions)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part2.md** (block 4, line 418)
> -- ================================ / -- COMPREHENSIVE DEPARTMENTAL PERFORMANCE DASHBOARD / -- Module References: Module 9 (All Lessons - Grouping and Aggregating)

✅ **tech company/untitled/Comprehensive_Beginner_Exercise_Answer_Key_Part2.md** (block 5, line 649)
> -- ================================ / -- STRATEGIC BUSINESS INTELLIGENCE FOR CEO EXECUTIVE BRIEF / -- Module References: ALL MODULES (1-9) - Complete Integration

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 1, line 14)
> -- Format currency values for charts and reports / SELECT / d.DepartmentName AS Department,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 2, line 28)
> -- Format dates for different chart requirements / SELECT / e.HireDate,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 3, line 45)
> -- Calculate department budget percentages for pie charts / WITH DepartmentTotals AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 4, line 69)
> -- Employee performance indicators with color codes / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 5, line 97)
> -- Project status with visual indicators / SELECT / p.ProjectName,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 6, line 130)
> -- Employee count by department and job level (for stacked bar charts) / SELECT / d.DepartmentName AS Category,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 7, line 147)
> -- Monthly hiring trends (for line charts) / WITH MonthlyHires AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 8, line 180)
> -- Department KPIs formatted for dashboard display / WITH DepartmentMetrics AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 9, line 214)
> -- Top performing employees with ranking / SELECT / ROW_NUMBER() OVER (ORDER BY e.BaseSalary DESC) AS Rank,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 10, line 242)
> -- Clean CSV export format (no special characters that break CSV) / SELECT / REPLACE(REPLACE(d.DepartmentName, ',', '-'), '"', '''') AS Department,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson1_Data_Formatting_Foundations.md** (block 11, line 259)
> -- JSON-friendly format for web charts / SELECT / '{"name":"' + d.DepartmentName +

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 1, line 14)
> -- Employee distribution by department (Basic Pie Chart) / SELECT / d.DepartmentName AS Category,

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 2, line 29)
> -- Department budget distribution for pie chart / WITH BudgetData AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 3, line 56)
> -- Employee distribution with job level breakdown / WITH EmployeeLevels AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 4, line 109)
> -- Project status distribution with budget weighting / WITH ProjectMetrics AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 5, line 158)
> -- Drill-down from departments to job titles / WITH HierarchicalData AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 6, line 199)
> -- Employee hiring trends by quarter (for animated pie charts) / DECLARE @StartDate DATE = '2020-01-01'; / DECLARE @EndDate DATE = GETDATE();

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 7, line 246)
> -- Department salary distribution with explosion flags / WITH SalaryDistribution AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 8, line 297)
> -- Project complexity analysis for 3D visualization / WITH ProjectComplexity AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 9, line 353)
> -- Chart.js pie chart data format / WITH ChartData AS ( / SELECT

✅ **tech company/untitled/Data_Visualization_and_Reporting/Lesson3_Pie_Charts_and_Percentage_Calculations.md** (block 10, line 396)
> -- Power BI optimized pie chart dataset / SELECT / d.DepartmentName AS Department,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 1, line 59)
> ┌─────────────────────────────────────────────────────────┐ / │                LAB ENVIRONMENT                          │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 2, line 102)
> -- Lab 1.1.1: What version of SQL Server am I using? / -- Don't worry about memorizing this - focus on understanding what it shows you / SELECT

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 3, line 127)
> ServerName: YOUR-COMPUTER\SQLEXPRESS (or similar) / Edition: Express Edition (64-bit) / Developer Edition / Standard / Enterprise / ProductVersion: 13.x.xxxx.x (SQL Server 2016)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 4, line 133)
> -- Lab 1.1.2: Memory and CPU Architecture / SELECT / cpu_count as LogicalCPUs,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 5, line 167)
> -- Lab 1.2.1: Create TechCorp's main database / -- This is like creating a new filing cabinet for all of TechCorp's information / CREATE DATABASE TechCorpDB

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 6, line 632)
> -- Lab 1.3.1: Buffer pool distribution by database / SELECT / CASE

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 7, line 650)
> -- Lab 1.3.2: Memory usage by component / SELECT / type as MemoryType,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 8, line 666)
> -- Lab 2.1.1: Check available features / SELECT feature_name, feature_id / FROM sys.dm_db_persisted_sku_features

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 9, line 704)
> -- Lab 2.2.1: JSON Support (New in SQL Server 2016) / CREATE TABLE JsonDemo ( / ID int IDENTITY(1,1),

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 10, line 726)
> -- Lab 2.2.2: Temporal Tables (System-Versioned Tables) - Enterprise/Developer / CREATE TABLE EmployeeInfo ( / EmployeeID int NOT NULL PRIMARY KEY,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 11, line 770)
> -- Lab 2.3.1: Always Encrypted Setup (Demo - requires certificate setup) / -- Note: This requires additional setup in SSMS for full functionality / -- Check if Always Encrypted is available

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 12, line 796)
> -- Lab 3.1.1: Enable Query Store / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 13, line 875)
> -- Lab 3.2.1: Enable Live Query Statistics in SSMS / -- Query → Include Live Query Statistics (Ctrl+Shift+Alt+L) / -- Run this complex query and observe live statistics

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 14, line 918)
> -- Lab 3.3.1: Create Extended Events session / CREATE EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER / ADD EVENT sqlserver.sql_statement_completed(

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 15, line 972)
> -- Lab 4.1.1: Create a comprehensive database schema / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 16, line 1041)
> -- Lab 4.2.1: Database Snapshots (Enterprise/Developer) / -- Create a database snapshot for point-in-time recovery testing / CREATE DATABASE ArchitectureDemo_Snapshot ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 17, line 1068)
> -- Lab 4.3.1: Create performance monitoring queries / -- Long-running queries detection / SELECT

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 18, line 1121)
> -- Lab 5.1.1: Create maintenance database / CREATE DATABASE MaintenanceDB / ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 19, line 1215)
> -- Lab 5.2.1: Create performance test scenario / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 20, line 1305)
> -- Final assessment query / SELECT / 'Lab Assessment Results' as Assessment,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools.md** (block 21, line 1322)
> -- Cleanup script (run at end of lab) / USE master; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 1, line 6)
> -- Lab 1.1.1: Basic Instance Information / SELECT / @@SERVERNAME as ServerName,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 2, line 25)
> -- Lab 1.1.2: Memory and CPU Architecture / SELECT / cpu_count as LogicalCPUs,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 3, line 46)
> -- Lab 1.2.1: Create a test database to understand file structure / -- Note: Adjust file paths based on your system configuration / CREATE DATABASE ArchitectureDemo

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 4, line 76)
> -- Lab 1.2.2: Analyze database file information / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 5, line 111)
> -- View system databases / USE master; / SELECT name, database_id, create_date, collation_name

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 6, line 130)
> -- Lab 1.3.2: Demonstrate Query Editor capabilities / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 7, line 176)
> -- If database diagrams are not enabled, run: / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 8, line 186)
> -- Create related tables to show relationships / CREATE TABLE d.DepartmentName ( / DeptID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 9, line 220)
> -- Run this query to generate some activity / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 10, line 242)
> -- Lab 1.4.2: Query performance-related DMVs / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 11, line 287)
> -- Lab 1.5.1: Create full database backup / USE master; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 12, line 314)
> -- Lab 1.5.2: Create transaction log backup / -- First ensure database is in FULL recovery model / ALTER DATABASE ArchitectureDemo SET RECOVERY FULL;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 13, line 345)
> -- Lab 1.5.3: Simulate disaster and recovery / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers.md** (block 14, line 432)
> -- Clean up lab environment / USE master; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lab_Working_with_SQL_Server_2016_Tools_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 1, line 13)
> ┌─────────────────────────────────────────────────────────┐ / │                 CLIENT APPLICATIONS                     │ / │           (SSMS, Apps, Web Services)                   │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 2, line 62)
> -- Client connects and sends this query / SELECT @@SERVERNAME;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 3, line 82)
> -- 1. Parser checks syntax / SELECT CompanyName, OrderDate / FROM Customers C

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 4, line 101)
> ┌─────────────────────────────────────────────────────┐ / │                BUFFER POOL                          │ / │  ┌─────────────┬─────────────┬─────────────────────┐ │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 5, line 119)
> BEGIN TRANSACTION; / UPDATE Products SET Price = Price * 1.1 WHERE CategoryID = 1; / INSERT INTO PriceHistory (ProductID, OldPrice, NewPrice, ChangeDate)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 6, line 131)
> DATABASE / ├── PRIMARY FILE GROUP / │   ├── .mdf (Primary Data File)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 7, line 146)
> -- Create database with specific file configuration / CREATE DATABASE SalesDB / ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 8, line 169)
> ┌─────────────────────────────────────────────────────┐ / │              SQL SERVER MEMORY                      │ / │                                                     │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 9, line 193)
> -- Check buffer pool usage / SELECT / database_id,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 10, line 213)
> CLIENT QUERY / ↓ / ┌─────────────┐

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 11, line 236)
> -- Enable execution plan analysis / SET STATISTICS IO ON; / SET STATISTICS TIME ON;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 12, line 261)
> -- Check SQL Server instance information / SELECT / @@SERVERNAME as ServerName,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 13, line 279)
> -- Monitor buffer cache hit ratio / SELECT / object_name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture.md** (block 14, line 291)
> -- Monitor transaction log usage / SELECT / name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson1_SQL_Server_Basic_Architecture_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 1, line 18)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    SQL SERVER 2016 OS COMPATIBILITY                        │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 2, line 73)
> -- Check your current Windows version / SELECT / windows_release,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 3, line 108)
> ┌─────────────────────────────────────────────────────────┐ / │                    ENTERPRISE                           │ / │              (Maximum Features)                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 4, line 143)
> SELECT / SERVERPROPERTY('Edition') AS Edition, / SERVERPROPERTY('ProductVersion') AS Version,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 5, line 173)
> -- Typical web application database setup / CREATE DATABASE WebAppDB / ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 6, line 208)
> -- Always On Availability Groups (Basic) / CREATE AVAILABILITY GROUP AG_StandardDemo / WITH (

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 7, line 230)
> ┌─────────────────────────────────────────────────────────┐ / │                 STANDARD EDITION LIMITS                │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 8, line 257)
> -- Advanced partitioning (Enterprise only) / CREATE PARTITION FUNCTION SalesDateRange (datetime) / AS RANGE RIGHT FOR VALUES

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 9, line 277)
> ┌─────────────────────────────────────────────────────────┐ / │               ENTERPRISE EDITION FEATURES              │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 10, line 303)
> -- Enable advanced features for testing / -- (Available in Developer/Enterprise) / EXEC sp_configure 'show advanced options', 1;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 11, line 325)
> 2008  ──────→  2008 R2  ──────→  2012  ──────→  2014  ──────→  2016 / │              │               │              │              │ / │              │               │              │              │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 12, line 335)
> 2017  ──────→  2019  ──────→  2022  ──────→  Future Versions / │              │              │ / │              │              │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 13, line 347)
> -- Always Encrypted (New in 2016) / CREATE TABLE Customers_Encrypted / (

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 14, line 369)
> -- Graph Database (New in 2017) / CREATE TABLE Person ( / ID INTEGER PRIMARY KEY,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 15, line 385)
> -- Big Data Clusters / -- Intelligent Query Processing / -- Accelerated Database Recovery

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 16, line 400)
> ┌─────────────────────────────────────────────────────────┐ / │                   LICENSING MODELS                     │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 17, line 420)
> Server: SQL Server Standard = $899 / CALs: 50 users × $208 = $10,400 / Total: $11,299

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 18, line 427)
> Server: 8 cores × $3,945 (Standard per core) = $31,560 / (Minimum 4 cores required)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 19, line 433)
> Server: 16 cores × $14,256 (Enterprise per core) = $228,096 / Software Assurance: 20% additional for support/upgrades

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 20, line 440)
> START: What is your use case? / │ / ├── Learning/Development? ──→ DEVELOPER EDITION (Free)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 21, line 465)
> -- Check current SQL Server edition and features / SELECT / SERVERPROPERTY('Edition') AS Edition,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 22, line 482)
> -- Check memory configuration / SELECT / name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 23, line 502)
> -- Test Enterprise features (will fail on lower editions) / -- Compression test / CREATE TABLE TestCompression (

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 24, line 516)
> -- Check database compatibility level / SELECT / name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 25, line 537)
> ┌─────────────────────────────────────────────────────────┐ / │              UPGRADE PATHS                              │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions.md** (block 26, line 552)
> -- 1. Check current version / SELECT @@VERSION; / -- 2. Run upgrade advisor

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson2_SQL_Server_Editions_and_Versions_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 1, line 16)
> ┌─────────────────────────────────────────────────────────────────┐ / │                          SSMS INTERFACE                        │ / │                                                                 │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 2, line 50)
> Download from: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms / Installation Steps: / 1. Run SSMS-Setup-ENU.exe

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 3, line 64)
> ┌─────────────────────────────────────────────────────────┐ / │               CONNECT TO SERVER                         │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 4, line 85)
> Server Name: localhost / Authentication: Windows Authentication

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 5, line 91)
> Server Name: MYSERVER\SQLEXPRESS / Authentication: Windows Authentication

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 6, line 97)
> Server Name: 192.168.1.100 / Authentication: SQL Server Authentication / Login: sa

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 7, line 120)
> SERVER INSTANCE / ├── Databases / │   ├── System Databases

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 8, line 161)
> -- Right-click on Tables → New → Table / -- Right-click on database → New Query / -- Right-click on table → Select Top 1000 Rows

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 9, line 173)
> ┌─────────────────────────────────────────────────────────┐ / │  File Edit View Query Project Debug Tools Window Help  │ / ├─────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 10, line 198)
> -- IntelliSense example / SELECT c.CustomerID, c.CustomerName, o.OrderDate / FROM Customers c -- IntelliSense suggests columns

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 11, line 217)
> -- Configure results options / -- Query → Query Options → Results → Grid / -- □ Include column headers when copying or saving results

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 12, line 234)
> -- Switch to Results to Text (Ctrl+T) / SELECT / REPLICATE('-', 50) as Separator,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 13, line 260)
> -- Database → Create Database / -- Table → Create Table / -- Index → Create Index

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 14, line 289)
> View → Registered Servers (Ctrl+Alt+G) / 1. Right-click "Local Server Groups" / 2. New → Server Registration

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 15, line 299)
> Registered Servers / ├── Development Servers / │   ├── DEV-SQL01\INSTANCE1

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 16, line 321)
> ┌─────────────────────────────────────────────────────────┐ / │                 ACTIVITY MONITOR                        │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 17, line 355)
> -- Find currently running queries / SELECT / session_id,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 18, line 381)
> -- Include Actual Execution Plan (Ctrl+M) / -- Include Live Query Statistics (Ctrl+Shift+Alt+L) / -- Example query with execution plan

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 19, line 406)
> Query Plan Diagram: / ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ / │   SELECT    │◄───│    SORT     │◄───│   HASH      │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 20, line 430)
> -- Tools → SQL Server Profiler / -- Create new trace with events: / -- - SQL:BatchCompleted

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 21, line 447)
> -- 1. Expand Database → Database Diagrams / -- 2. Right-click → New Database Diagram / -- 3. Add tables to diagram

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 22, line 481)
> Tools → Options → Environment / General: / - Font and Colors

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 23, line 498)
> Ctrl + N         : New Query / Ctrl + O         : Open File / Ctrl + S         : Save

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 24, line 547)
> -- Central Management Servers / -- 1. View → Registered Servers / -- 2. Right-click Central Management Servers

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 25, line 566)
> -- 1. Connect to SQL Server / -- 2. Explore Object Explorer hierarchy / -- 3. Open a new query window

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 26, line 582)
> -- 1. Create a new database / CREATE DATABASE SSMS_Training; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 27, line 606)
> -- 1. Enable execution plan (Ctrl+M) / -- 2. Run this query and analyze the plan: / WITH CustomerSummary AS (

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 28, line 636)
> -- 1. Open Activity Monitor (Ctrl+Alt+A) / -- 2. Create a trace in SQL Server Profiler / -- 3. Use Template Explorer to create a stored procedure

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 29, line 647)
> -- Test connectivity / SELECT @@SERVERNAME, GETDATE(); / -- Check SQL Server services

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS.md** (block 30, line 659)
> -- Clear query plan cache if needed / DBCC FREEPROCCACHE; / -- Update statistics

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson3_Getting_Started_with_SSMS_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 1, line 16)
> **12. Ready to Install** / - Review all configuration settings / - Note the configuration file location for future reference

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 2, line 66)
> #### Configure SQL Server Network Settings

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 3, line 95)
> #### Windows Firewall Configuration

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 4, line 114)
> ### Step 5: Install SQL Server Management Studio (SSMS) / **1. Download SSMS**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 5, line 122)
> **2. Install SSMS**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 6, line 134)
> **3. First Connection to SQL Server**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 7, line 148)
> ## 4.4 Installation Verification and Testing / ### Complete Installation Test Script

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 8, line 240)
> ### Performance Baseline Setup

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 9, line 264)
> ## 4.5 Common Installation Issues and Solutions / ### Troubleshooting Guide / #### Issue 1: Installation Fails with .NET Framework Error

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 10, line 278)
> #### Issue 2: Service Account Issues

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 11, line 295)
> #### Issue 3: Firewall Blocking Connections

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 12, line 310)
> #### Issue 4: Authentication Problems

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 13, line 331)
> #### Issue 5: Performance Issues After Installation

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 14, line 361)
> ## 4.6 Post-Installation Security Hardening / ### Security Configuration Checklist

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 15, line 414)
> ### Network Security Configuration

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 16, line 433)
> ## 4.7 Maintenance and Updates / ### Keeping SQL Server 2016 Updated

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 17, line 454)
> ### Backup Strategy Setup

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 18, line 474)
> ## 4.8 Installation Checklist Summary / ### Final Verification Checklist

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 19, line 516)
> ## Summary / ### Key Takeaways for SQL Server 2016 Installation / 1. **Pre-Installation Planning**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 20, line 615)
> ### System Configuration Check

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 21, line 677)
> ## 4.2 Obtaining SQL Server 2016 / ### License Options and Download Sources / #### Free Editions for Learning and Development

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 22, line 712)
> **2. SQL Server 2016 Developer Edition (FREE)**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 23, line 742)
> **3. SQL Server 2016 Evaluation Edition (180-Day Trial)**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 24, line 771)
> ### Recommended Download for This Course / **For this training course, we recommend SQL Server 2016 Developer Edition:** / - All Enterprise features available

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 25, line 787)
> 2. **Select Developer Edition** / - Click "Download now" under Developer section / - File name: `SQLServer2016-SSEI-Dev.exe` (Web installer)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 26, line 797)
> - SSMS is now a separate download starting with SQL Server 2016 / - Always download the latest version of SSMS / ### Step 2: Prepare Windows Server Environment

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 27, line 822)
> ### Step 3: Run SQL Server 2016 Installation / #### Installation Wizard Walkthrough / **1. Start the Installation**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 28, line 835)
> **2. Installation Center Welcome Screen** / - Select "Installation" from the left panel / - Choose "New SQL Server stand-alone installation or add features to an existing installation"

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 29, line 874)
> **6. Microsoft Update (Optional)** / - Choose whether to use Microsoft Update for SQL Server updates / - Recommended: Check "Use Microsoft Update to check for updates"

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 30, line 915)
> **9. Instance Configuration**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 31, line 938)
> **10. Server Configuration - Service Accounts** / Configure service accounts for SQL Server services:

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 32, line 968)
> **11. Database Engine Configuration** / **Authentication Mode:**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 33, line 997)
> **SQL Server Administrators:**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server.md** (block 34, line 1010)
> **Data Directories:**

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Lesson4_Installing_SQL_Server_2016_on_Windows_Server_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 1, line 11)
> -- Basic instance information / SELECT / @@SERVERNAME AS ServerName,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 2, line 56)
> -- Create test database with specific file settings / CREATE DATABASE ArchitectureTest / ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 3, line 129)
> -- List all databases including system databases / SELECT / name AS database_name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 4, line 273)
> -- Query to show current connection information / SELECT / @@SERVERNAME AS server_name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 5, line 308)
> -- Enable/disable IntelliSense (Tools > Options > Text Editor > Transact-SQL > IntelliSense) / -- Query to refresh IntelliSense cache / -- Edit > IntelliSense > Refresh Local Cache

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 6, line 375)
> -- Query to check current system resources / SELECT / cpu_count AS logical_processors,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 7, line 438)
> -- Check current memory configuration / EXEC sp_configure 'show advanced options', 1; / RECONFIGURE;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 8, line 538)
> -- Instance inventory query / SELECT / @@SERVERNAME AS instance_name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/Module1_Exercise_Answers.md** (block 9, line 600)
> SELECT / 'Server Information' AS category, / @@SERVERNAME AS server_name,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 1, line 59)
> ┌─────────────────────────────────────────────────────────┐ / │                LAB ENVIRONMENT                          │ / │                                                         │

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 2, line 102)
> -- Lab 1.1.1: What version of SQL Server am I using? / -- Don't worry about memorizing this - focus on understanding what it shows you / SELECT

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 3, line 127)
> ServerName: YOUR-COMPUTER\SQLEXPRESS (or similar) / Edition: Express Edition (64-bit) / Developer Edition / Standard / Enterprise / ProductVersion: 13.x.xxxx.x (SQL Server 2016)

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 4, line 133)
> -- Lab 1.1.2: Memory and CPU Architecture / SELECT / cpu_count as LogicalCPUs,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 5, line 167)
> -- Lab 1.2.1: Create TechCorp's main database / -- This is like creating a new filing cabinet for all of TechCorp's information / CREATE DATABASE TechCorpDB

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 6, line 632)
> -- Lab 1.3.1: Buffer pool distribution by database / SELECT / CASE

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 7, line 650)
> -- Lab 1.3.2: Memory usage by component / SELECT / type as MemoryType,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 8, line 666)
> -- Lab 2.1.1: Check available features / SELECT feature_name, feature_id / FROM sys.dm_db_persisted_sku_features

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 9, line 704)
> -- Lab 2.2.1: JSON Support (New in SQL Server 2016) / CREATE TABLE JsonDemo ( / ID int IDENTITY(1,1),

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 10, line 726)
> -- Lab 2.2.2: Temporal Tables (System-Versioned Tables) - Enterprise/Developer / CREATE TABLE EmployeeInfo ( / EmployeeID int NOT NULL PRIMARY KEY,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 11, line 770)
> -- Lab 2.3.1: Always Encrypted Setup (Demo - requires certificate setup) / -- Note: This requires additional setup in SSMS for full functionality / -- Check if Always Encrypted is available

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 12, line 796)
> -- Lab 3.1.1: Enable Query Store / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 13, line 875)
> -- Lab 3.2.1: Enable Live Query Statistics in SSMS / -- Query → Include Live Query Statistics (Ctrl+Shift+Alt+L) / -- Run this complex query and observe live statistics

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 14, line 918)
> -- Lab 3.3.1: Create Extended Events session / CREATE EVENT SESSION [SQL2016_Performance_Monitor] ON SERVER / ADD EVENT sqlserver.sql_statement_completed(

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 15, line 972)
> -- Lab 4.1.1: Create a comprehensive database schema / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 16, line 1041)
> -- Lab 4.2.1: Database Snapshots (Enterprise/Developer) / -- Create a database snapshot for point-in-time recovery testing / CREATE DATABASE ArchitectureDemo_Snapshot ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 17, line 1068)
> -- Lab 4.3.1: Create performance monitoring queries / -- Long-running queries detection / SELECT

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 18, line 1121)
> -- Lab 5.1.1: Create maintenance database / CREATE DATABASE MaintenanceDB / ON

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 19, line 1215)
> -- Lab 5.2.1: Create performance test scenario / USE ArchitectureDemo; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 20, line 1305)
> -- Final assessment query / SELECT / 'Lab Assessment Results' as Assessment,

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 21, line 1322)
> -- Cleanup script (run at end of lab) / USE master; / GO

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 22, line 1379)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 23, line 1408)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-advanced.md** (block 24, line 1416)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/lab-sql-server-tools-beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 1, line 31)
> -- Your solution here / -- Requirements: / -- 1. Employee ID padded to 4 digits with leading zeros

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 2, line 46)
> -- Your solution here / -- Requirements: / -- 1. Tenure category with icons (🆕 New, ⭐ Experienced, 🏆 Veteran)

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 3, line 58)
> -- Your solution here / -- Requirements: / -- 1. Report generation timestamp and user information

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 4, line 78)
> -- Your solution here / -- Requirements: / -- 1. Project count by status with percentages

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 5, line 91)
> -- Your solution here / -- Requirements: / -- 1. Budget vs actual cost comparison with progress bars

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 6, line 104)
> -- Your solution here / -- Requirements: / -- 1. Hierarchical display: Company → Department → Project → Details

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 7, line 124)
> -- Your solution here / -- Requirements: / -- 1. Month-over-month revenue/cost analysis

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 8, line 137)
> -- Format 1: Screen Display (with visual elements) / -- Your screen format solution here / -- Format 2: CSV Export (clean data for Excel)

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 9, line 154)
> -- Your solution here / -- Requirements: / -- 1. Key financial metrics with benchmarks

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 10, line 174)
> -- Your solution here / -- Requirements: / -- 1. Employee retention risk scoring

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 11, line 187)
> -- Your solution here / -- Requirements: / -- 1. Year-over-year comparison with percentage changes

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 12, line 200)
> -- Your solution here / -- Requirements: / -- 1. Company-wide overview level

✅ **tech company/untitled/Module 10/Lab_Advanced_Data_Visualization.md** (block 13, line 217)
> -- Your creative solution here / -- Suggestions: / -- 1. Organization chart using ASCII art

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 1, line 29)
> -- Simple name gluing (like making a name tag) / SELECT / FirstName,           -- Shows: John

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 2, line 46)
> -- Making fancy employee name tags / SELECT / CONCAT(FirstName, ' ', LastName, ' - ', JobTitle) AS EmployeeNameTag

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 3, line 65)
> -- Smart name formatting (handles missing middle names) / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 4, line 85)
> -- Making a professional employee directory / SELECT / CONCAT(e.FirstName, ' ', e.LastName, ' - ', e.JobTitle) AS EmployeeTitle,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 5, line 106)
> -- Turn boring numbers into pretty money / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 6, line 123)
> -- Turn computer dates into human dates / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 7, line 140)
> -- Turn decimals into percentages / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 8, line 156)
> -- Right-align numbers with padding / SELECT / RIGHT('000' + CAST(e.EmployeeID AS VARCHAR), 4) AS PaddedID,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 9, line 174)
> -- Professional name formatting / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 10, line 200)
> -- Precise decimal formatting / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 11, line 228)
> -- Multiple date format options / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 12, line 266)
> -- Turn salary numbers into easy categories (like T-shirt sizes!) / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 13, line 289)
> -- Turn hire dates into friendly time periods / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10/Lesson1_Formatting_Query_Results.md** (block 14, line 318)
> ## 1.7 SSMS Result Grid Customization / ### Grid Display Options / To enhance result readability in SQL Server Management Studio:

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 1, line 26)
> -- Step 1: Let's count how many people work in each department / SELECT / d.DepartmentName AS Category,           -- The department name (like "Sales")

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 2, line 45)
> -- Step 2: Let's see how money is divided between project types / SELECT / ISNULL(p.Status, 'Unknown') AS ProjectStatus,     -- Project status (like "Completed")

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 3, line 63)
> -- Salary distribution by ranges / WITH SalaryRanges AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 4, line 106)
> -- Skills distribution with visual indicators / SELECT / sc.CategoryName,

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 5, line 130)
> -- Let's make a text-based bar chart showing department budgets / WITH DeptBudgets AS ( / -- Step 1: Add up all the budget money for each department

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 6, line 164)
> -- Project completion progress / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 7, line 191)
> -- Data formatted for Excel pivot charts / SELECT / 'Department Distribution' AS ChartType,

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 8, line 219)
> -- Generate JSON-like output for web charting libraries / SELECT / '{"name":"' + d.DepartmentName + '","value":' + CAST(COUNT(*) AS VARCHAR) +

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 9, line 234)
> -- Hierarchical data for drill-down charts / WITH EmployeeHierarchy AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 10, line 258)
> -- Monthly hiring trends / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 11, line 276)
> -- Status-based color recommendations / SELECT / p.Status,

✅ **tech company/untitled/Module 10/Lesson2_Creating_Charts_and_Visualizations.md** (block 12, line 305)
> -- Executive dashboard data / SELECT / 'Total Employees' AS Metric,

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 1, line 36)
> -- Step 1: Make a title for your report / SELECT 'TechCorp Employee Report' AS ReportTitle; / -- Step 2: Add today's date

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 2, line 56)
> -- Part 1: Report header / SELECT 'Employee List Report' AS ReportSection / UNION ALL

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 3, line 74)
> -- Style 1: Simple and clean / SELECT 'EMPLOYEE REPORT' AS Title; / -- Style 2: With decorative borders

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 4, line 102)
> -- Create a professional header with company info / DECLARE @ReportDate DATETIME = GETDATE(); / DECLARE @ReportTitle VARCHAR(100) = 'TechCorp Solutions - Employee Analysis Report';

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 5, line 125)
> -- Create comprehensive report metadata / WITH ReportMetadata AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 6, line 161)
> -- Executive summary with key metrics / WITH ExecutiveSummary AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 7, line 226)
> -- Comprehensive department analysis report / WITH DepartmentAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 8, line 276)
> -- Hiring trends with visual indicators / WITH MonthlyHiring AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 9, line 316)
> -- Project performance metrics report / WITH ProjectMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 10, line 361)
> -- Parameterized report template / DECLARE @StartDate DATE = DATEADD(MONTH, -1, GETDATE()); / DECLARE @EndDate DATE = GETDATE();

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 11, line 404)
> -- CSV-friendly report format / SELECT / '"Report_Type","Department","Metric","Value","Period"' AS CSVHeader

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 12, line 431)
> -- Report validation and quality checks / WITH DataQuality AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson3_Advanced_Report_Generation.md** (block 13, line 473)
> -- Hierarchical drill-down report / WITH HierarchicalData AS ( / -- Level 1: Company Overview

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 1, line 25)
> -- Let's pretend we're logged in as a Manager (not a regular employee) / DECLARE @UserRole VARCHAR(20) = 'Manager'; -- This could be 'Executive', 'Manager', or 'Employee' / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 2, line 65)
> -- Advanced conditional formatting with status indicators / WITH EmployeeAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 3, line 136)
> -- Create newspaper-style column layout / WITH ProjectSummary AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 4, line 185)
> -- Table with adaptive column widths based on content / WITH ContentAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 5, line 240)
> -- Simulate result pagination / DECLARE @PageSize INT = 10; / DECLARE @PageNumber INT = 1;

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 6, line 289)
> -- Highlight search terms in results / DECLARE @SearchTerm VARCHAR(50) = 'Manager'; / WITH SearchResults AS (

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 7, line 343)
> -- Professional business report theme / WITH BusinessReport AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 8, line 384)
> -- Dashboard-style metrics display / WITH DashboardMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 9, line 454)
> -- Format data specifically for Excel import / SELECT / 'Employee_ID' AS A,

✅ **tech company/untitled/Module 10/Lesson4_Customizing_Result_Sets.md** (block 10, line 488)
> -- Generate JSON-formatted result sets / SELECT / '{' +

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 1, line 14)
> -- Professional employee summary with comprehensive formatting / SELECT / -- Padded Employee ID with leading zeros

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 2, line 52)
> -- Salary analysis with performance tiers and visual elements / WITH SalaryAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 3, line 117)
> -- Contact directory with professional multi-line formatting / SELECT / -- Employee name and title on separate conceptual lines

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 4, line 153)
> -- Skills matrix with proficiency indicators / WITH EmployeeSkillSummary AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 5, line 202)
> -- Project assignment summary with workload indicators / WITH ProjectAssignments AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 6, line 251)
> -- Executive dashboard with comprehensive KPIs and visual indicators / WITH CompanyMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 7, line 338)
> -- Department distribution data optimized for pie chart creation / WITH DepartmentStats AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 8, line 392)
> -- Project budget allocation with hierarchical breakdown / WITH BudgetAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers copy.md** (block 9, line 442)
> -- Quarterly business report with multiple sections and professional formatting / DECLARE @ReportQuarter VARCHAR(10) = 'Q' + CAST(DATEPART(QUARTER, GETDATE()) AS VARCHAR) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR); / DECLARE @GeneratedDate DATETIME = GETDATE();

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 1, line 19)
> -- Step-by-step solution: Making a professional employee directory / SELECT / -- STEP 1: Make employee ID look neat with leading zeros

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 2, line 70)
> -- Salary analysis with performance tiers and visual elements / WITH SalaryAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 3, line 135)
> -- Contact directory with professional multi-line formatting / SELECT / -- Employee name and title on separate conceptual lines

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 4, line 171)
> -- Skills matrix with proficiency indicators / WITH EmployeeSkillSummary AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 5, line 220)
> -- Project assignment summary with workload indicators / WITH ProjectAssignments AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 6, line 269)
> -- Executive dashboard with comprehensive KPIs and visual indicators / WITH CompanyMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 7, line 356)
> -- Department distribution data optimized for pie chart creation / WITH DepartmentStats AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 8, line 410)
> -- Project budget allocation with hierarchical breakdown / WITH BudgetAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10/Module10_Exercise_Answers.md** (block 9, line 460)
> -- Quarterly business report with multiple sections and professional formatting / DECLARE @ReportQuarter VARCHAR(10) = 'Q' + CAST(DATEPART(QUARTER, GETDATE()) AS VARCHAR) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR); / DECLARE @GeneratedDate DATETIME = GETDATE();

✅ **tech company/untitled/Module 10/Module10_Exercises.md** (block 1, line 41)
> EmployeeID: 0042 / FullName: Smith, John M. / JobInfo: Developer [IT]

✅ **tech company/untitled/Module 10/Module10_Exercises.md** (block 2, line 62)
> John Smith ★★ | $75,000 | 15% above average | Senior Level | ████████

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 1, line 31)
> -- Your solution here / -- Requirements: / -- 1. Employee ID padded to 4 digits with leading zeros

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 2, line 46)
> -- Your solution here / -- Requirements: / -- 1. Tenure category with icons (🆕 New, ⭐ Experienced, 🏆 Veteran)

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 3, line 58)
> -- Your solution here / -- Requirements: / -- 1. Report generation timestamp and user information

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 4, line 78)
> -- Your solution here / -- Requirements: / -- 1. Project count by status with percentages

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 5, line 91)
> -- Your solution here / -- Requirements: / -- 1. Budget vs actual cost comparison with progress bars

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 6, line 104)
> -- Your solution here / -- Requirements: / -- 1. Hierarchical display: Company → Department → Project → Details

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 7, line 124)
> -- Your solution here / -- Requirements: / -- 1. Month-over-month revenue/cost analysis

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 8, line 137)
> -- Format 1: Screen Display (with visual elements) / -- Your screen format solution here / -- Format 2: CSV Export (clean data for Excel)

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 9, line 154)
> -- Your solution here / -- Requirements: / -- 1. Key financial metrics with benchmarks

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 10, line 174)
> -- Your solution here / -- Requirements: / -- 1. Employee retention risk scoring

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 11, line 187)
> -- Your solution here / -- Requirements: / -- 1. Year-over-year comparison with percentage changes

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 12, line 200)
> -- Your solution here / -- Requirements: / -- 1. Company-wide overview level

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Advanced_Data_Visualization.md** (block 13, line 217)
> -- Your creative solution here / -- Suggestions: / -- 1. Organization chart using ASCII art

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 2, line 49)
> -- Write your solution here: / -- Expected approach: Use scalar subquery in SELECT and WHERE clauses

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 3, line 69)
> -- Write your solution here: / -- Expected approach: Use IN subquery with TOP clause

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 4, line 95)
> -- Write your solution here: / -- Expected approach: Multiple correlated subqueries for different calculations

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 5, line 117)
> -- Write your solution here: / -- Expected approach: Correlated subqueries with SUM and AVG calculations

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 6, line 142)
> -- Write your solution here: / -- Expected approach: EXISTS for managers, NOT EXISTS for projects

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 7, line 164)
> -- Write your solution here: / -- Expected approach: EXISTS for any orders, NOT EXISTS for recent orders

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 8, line 196)
> -- Write your solution here: / -- Expected approach: Multiple subquery types working together

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 9, line 226)
> -- Write your solution here: / -- Expected approach: Comprehensive scoring with multiple subquery patterns

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 10, line 238)
> -- HR Department: Employees Above Company Average / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 11, line 270)
> -- Sales Team: Customers with Top-Tier Order Values / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 12, line 301)
> -- Management: High-Performing Employees by d.DepartmentName / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 13, line 345)
> -- Project Management: Employee Workload Analysis / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 14, line 408)
> -- Data Quality: Managers Without Project Assignments / SELECT / e.FirstName + ' ' + e.LastName AS ManagerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 15, line 449)
> -- Customer Success: At-Risk Customer Analysis / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 16, line 517)
> -- Senior Management: d.DepartmentName Performance Dashboard / SELECT d.DepartmentName, / FORMAT(d.Budget, 'C') AS DepartmentBudget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries.md** (block 17, line 611)
> -- Comprehensive Employee Performance Scorecard / WITH PerformanceScores AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lab_Using_Subqueries_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 1, line 24)
> -- Basic employee name formatting / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 2, line 43)
> -- Currency formatting / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 3, line 72)
> -- Right-align numbers with padding / SELECT / RIGHT('000' + CAST(e.EmployeeID AS VARCHAR), 4) AS PaddedID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 4, line 89)
> -- Professional name formatting / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 5, line 114)
> -- Precise decimal formatting / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 6, line 141)
> -- Multiple date format options / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 7, line 172)
> -- Employee status formatting / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Formatting_Query_Results.md** (block 8, line 223)
> -- Add row numbers for easy reference / SELECT / ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNum,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 1, line 17)
> Employees: e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID, d.DepartmentName, d.Budget, IsActive / Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, Status

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 2, line 40)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    SELF-CONTAINED SUBQUERY EXECUTION                       │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 3, line 71)
> -- Find employees earning above company average / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 4, line 86)
> -- Find departments with budgets above company average / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 5, line 106)
> -- Find employees working in departments with budgets over $500,000 / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 6, line 127)
> -- Find projects managed by employees hired before 2020 / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 7, line 150)
> -- Create d.DepartmentName summary and find above-average departments / SELECT ds.d.DepartmentName, / ds.EmployeeCount,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 8, line 183)
> -- Employees earning in top 25% of company salaries / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 9, line 205)
> -- Orders above average order value / SELECT / o.OrderID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 10, line 229)
> -- Find managers who manage more people than average / SELECT / mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 11, line 266)
> -- Complex employee analysis with multiple benchmarks / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 12, line 299)
> -- Departments with above-average employee retention and high budgets / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 13, line 338)
> -- ✅ GOOD: Subquery with proper filtering / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 14, line 360)
> -- Subquery approach / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 15, line 396)
> -- Always validate subquery results make business sense / -- Test the subquery alone first: / SELECT AVG(e.BaseSalary) FROM Employees e WHERE IsActive = 1;

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 16, line 413)
> -- ❌ PROBLEM: Subquery might return NULL / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries.md** (block 17, line 435)
> -- ✅ GOOD: Ensure compatible data types / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson1_Writing_Self-Contained_Subqueries_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 1, line 28)
> -- Employee distribution by department (Pie Chart Data) / SELECT / d.DepartmentName AS Category,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 2, line 52)
> -- Salary distribution by ranges / WITH SalaryRanges AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 3, line 95)
> -- Skills distribution with visual indicators / SELECT / sc.CategoryName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 4, line 113)
> -- Department budget visualization / WITH DeptBudgets AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 5, line 138)
> -- Project completion progress / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 6, line 165)
> -- Data formatted for Excel pivot charts / SELECT / 'Department Distribution' AS ChartType,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 7, line 193)
> -- Generate JSON-like output for web charting libraries / SELECT / '{"name":"' + d.DepartmentName + '","value":' + CAST(COUNT(*) AS VARCHAR) +

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 8, line 208)
> -- Hierarchical data for drill-down charts / WITH EmployeeHierarchy AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 9, line 232)
> -- Monthly hiring trends / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 10, line 250)
> -- Status-based color recommendations / SELECT / p.Status,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Creating_Charts_and_Visualizations.md** (block 11, line 279)
> -- Executive dashboard data / SELECT / 'Total Employees' AS Metric,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 1, line 17)
> Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID, d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 2, line 35)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    CORRELATED SUBQUERY EXECUTION                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 3, line 68)
> -- Find employees earning above their d.DepartmentName average / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 4, line 96)
> -- Rank each d.DepartmentName by its position relative to other departments / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 5, line 115)
> -- Find managers with their direct report count and average team e.BaseSalary / SELECT / mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 6, line 146)
> -- Compare each employee's tenure to others in their d.DepartmentName / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 7, line 174)
> -- Calculate running total of project budgets by start date / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 8, line 197)
> -- Identify high performers: above dept average e.BaseSalary + above avg project hours / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 9, line 238)
> -- Rank employees by their order performance within d.DepartmentName / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 10, line 281)
> -- ✅ GOOD: Correlated subquery with proper indexing / -- Assumes indexes on: Employees(d.DepartmentID, IsActive, e.BaseSalary) / SELECT e.FirstName, e.LastName, e.BaseSalary

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 11, line 308)
> -- Correlated subquery approach (slower) / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 12, line 335)
> -- Correlated subquery for counting / SELECT d.DepartmentName, / (SELECT COUNT(*) FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 13, line 357)
> -- Multi-dimensional employee performance analysis / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 14, line 395)
> -- Analyze d.DepartmentName efficiency relative to peers / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 15, line 432)
> -- ✅ GOOD: Clear table aliases and correlation / SELECT / outer_emp.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 16, line 457)
> -- Test query performance with actual data volumes / SET STATISTICS IO ON; / SET STATISTICS TIME ON;

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 17, line 479)
> -- ✅ GOOD: Handle potential NULL results / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 18, line 496)
> -- ❌ PROBLEM: Correlated subquery in SELECT list causes N+1 query problem / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries.md** (block 19, line 522)
> -- ❌ PROBLEM: Incorrect correlation can cause unexpected results / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson2_Writing_Correlated_Subqueries_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 1, line 26)
> -- Report header information / DECLARE @ReportDate DATETIME = GETDATE(); / DECLARE @ReportTitle VARCHAR(100) = 'TechCorp Solutions - Employee Analysis Report';

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 2, line 53)
> -- Create comprehensive report metadata / WITH ReportMetadata AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 3, line 89)
> -- Executive summary with key metrics / WITH ExecutiveSummary AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 4, line 154)
> -- Comprehensive department analysis report / WITH DepartmentAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 5, line 204)
> -- Hiring trends with visual indicators / WITH MonthlyHiring AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 6, line 244)
> -- Project performance metrics report / WITH ProjectMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 7, line 289)
> -- Parameterized report template / DECLARE @StartDate DATE = DATEADD(MONTH, -1, GETDATE()); / DECLARE @EndDate DATE = GETDATE();

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 8, line 332)
> -- CSV-friendly report format / SELECT / '"Report_Type","Department","Metric","Value","Period"' AS CSVHeader

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 9, line 359)
> -- Report validation and quality checks / WITH DataQuality AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Advanced_Report_Generation.md** (block 10, line 401)
> -- Hierarchical drill-down report / WITH HierarchicalData AS ( / -- Level 1: Company Overview

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 1, line 19)
> Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, IsActive / Departments: d.DepartmentID, d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID, ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 2, line 41)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    EXISTS vs OTHER SUBQUERY COMPARISONS                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 3, line 74)
> -- Find all employees who have processed at least one order / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 4, line 94)
> -- Find departments that have at least one active project / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 5, line 115)
> -- Find employees who have never processed an order / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 6, line 136)
> -- Find customers who haven't placed orders in the last 90 days / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 7, line 164)
> -- Find employees who are managers AND have worked on projects AND have processed orders / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 8, line 202)
> -- Find customers who have high-value orders AND multiple recent orders / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 9, line 242)
> -- Find all managers at different levels with their span of control / SELECT / mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 10, line 298)
> -- ✅ GOOD: EXISTS with correlation (usually faster) / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 11, line 329)
> -- Ensure proper indexes for EXISTS performance / -- For this query pattern: / SELECT e.FirstName, e.LastName

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 12, line 350)
> -- Find employees in specific departments who have recent high-value orders / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 13, line 375)
> -- Find orphaned records - employees without valid departments / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 14, line 410)
> -- Segment customers based on order patterns / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 15, line 451)
> -- Monitor various business activities and employee engagement / SELECT d.DepartmentName, / -- Active employees count

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 16, line 517)
> -- ✅ GOOD: Use constants in SELECT clause of EXISTS / WHERE EXISTS ( / SELECT 1                    -- Or SELECT NULL, SELECT 'X' - all equivalent

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 17, line 545)
> -- EXISTS naturally handles NULL values correctly / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 18, line 562)
> -- Test your EXISTS logic with explicit counts / -- Original EXISTS query / SELECT COUNT(*) as EmployeesWithOrders

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 19, line 590)
> -- ❌ PROBLEM: Functions in WHERE clause prevent index usage / WHERE EXISTS ( / SELECT 1

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 20, line 612)
> -- ❌ PROBLEM: Incorrect logic - missing proper correlation / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries.md** (block 21, line 638)
> -- Method 1: Convert EXISTS to COUNT for debugging / SELECT / e.FirstName,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson3_Using_EXISTS_Predicate_with_Subqueries_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 1, line 16)
> -- Dynamically customize columns based on user role / DECLARE @UserRole VARCHAR(20) = 'Manager'; -- 'Executive', 'Manager', 'Employee' / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 2, line 49)
> -- Advanced conditional formatting with status indicators / WITH EmployeeAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 3, line 120)
> -- Create newspaper-style column layout / WITH ProjectSummary AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 4, line 169)
> -- Table with adaptive column widths based on content / WITH ContentAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 5, line 224)
> -- Simulate result pagination / DECLARE @PageSize INT = 10; / DECLARE @PageNumber INT = 1;

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 6, line 273)
> -- Highlight search terms in results / DECLARE @SearchTerm VARCHAR(50) = 'Manager'; / WITH SearchResults AS (

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 7, line 327)
> -- Professional business report theme / WITH BusinessReport AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 8, line 368)
> -- Dashboard-style metrics display / WITH DashboardMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 9, line 438)
> -- Format data specifically for Excel import / SELECT / 'Employee_ID' AS A,

✅ **tech company/untitled/Module 10 - Using Subqueries/Lesson4_Customizing_Result_Sets.md** (block 10, line 472)
> -- Generate JSON-formatted result sets / SELECT / '{' +

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 1, line 14)
> -- Professional employee summary with comprehensive formatting / SELECT / -- Padded Employee ID with leading zeros

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 2, line 52)
> -- Salary analysis with performance tiers and visual elements / WITH SalaryAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 3, line 117)
> -- Contact directory with professional multi-line formatting / SELECT / -- Employee name and title on separate conceptual lines

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 4, line 153)
> -- Skills matrix with proficiency indicators / WITH EmployeeSkillSummary AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 5, line 202)
> -- Project assignment summary with workload indicators / WITH ProjectAssignments AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 6, line 251)
> -- Executive dashboard with comprehensive KPIs and visual indicators / WITH CompanyMetrics AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 7, line 338)
> -- Department distribution data optimized for pie chart creation / WITH DepartmentStats AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 8, line 392)
> -- Project budget allocation with hierarchical breakdown / WITH BudgetAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 10 - Using Subqueries/Module10_Exercise_Answers.md** (block 9, line 442)
> -- Quarterly business report with multiple sections and professional formatting / DECLARE @ReportQuarter VARCHAR(10) = 'Q' + CAST(DATEPART(QUARTER, GETDATE()) AS VARCHAR) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR); / DECLARE @GeneratedDate DATETIME = GETDATE();

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 1, line 22)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 2, line 56)
> -- Write your solution here: / -- Expected approach: UNION with proper column alignment and formatting

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 3, line 79)
> -- Write your solution here: / -- Expected approach: UNION ALL with date calculations and proper status handling

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 4, line 109)
> -- Write your solution here: / -- Expected approach: EXCEPT to find employees without project assignments

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 5, line 130)
> -- Write your solution here: / -- Expected approach: EXCEPT comparing high earners with current managers

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 6, line 160)
> -- Write your solution here: / -- Expected approach: INTERSECT to find employees in both categories

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 7, line 183)
> -- Write your solution here: / -- Expected approach: INTERSECT with aggregated customer metrics

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 8, line 220)
> -- Write your solution here: / -- Expected approach: CROSS APPLY with complex scoring calculation

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 9, line 258)
> -- Write your solution here: / -- Expected approach: OUTER APPLY with multiple metrics and trend analysis

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 10, line 294)
> -- Write your solution here: / -- Expected approach: Multiple UNION ALL with complex business logic

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 11, line 326)
> -- Write your solution here: / -- Expected approach: Complex combination of set operators for validation

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 12, line 338)
> -- HR Department: Unified Contact Directory / SELECT / 'Employee' AS ContactType,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 13, line 378)
> -- Management: Comprehensive e.BaseSalary Analysis / SELECT / 'Active' AS EmployeeStatus,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 14, line 419)
> -- IT Department: Employees Without Project Assignments / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 15, line 460)
> -- Policy Compliance: High Earners Without Management Responsibilities / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 16, line 505)
> -- Project Management Office: Versatile Employees Analysis / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 17, line 559)
> -- Sales Team: Premium Customer Analysis / SELECT / c.CompanyName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 18, line 614)
> -- Senior Management: d.DepartmentName Performance Dashboard / SELECT d.DepartmentName, / top_performers.EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators.md** (block 19, line 707)
> -- Customer Success: Comprehensive Customer Analysis / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lab_Using_Set_Operators_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.JobTitle, e.HireDate, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                          UNION vs UNION ALL                                │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 3, line 71)
> -- Consolidate all contact information FROM Employees e and customers / SELECT / 'Employee' AS ContactType,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 4, line 101)
> -- Combine different revenue sources for comprehensive analysis / SELECT / 'Current Orders' AS RevenueSource,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 5, line 135)
> -- Create comprehensive employee directory including terminated employees / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 6, line 176)
> -- Create unified performance metrics from multiple business areas / SELECT / 'Employee Performance' AS MetricCategory,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 7, line 235)
> -- Analyze business trends across multiple quarters / SELECT / 'Q1 2024' AS Period,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 8, line 303)
> -- Create comprehensive skill inventory from multiple sources / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 9, line 363)
> -- ✅ GOOD: Use UNION ALL when duplicates are acceptable or known not to exist / SELECT c.CompanyID, c.CompanyName FROM Companies c INNER JOIN Countries co ON c.CountryID = co.CountryID WHERE co.CountryCode = 'US' AND c.IsActive = 1 / UNION ALL  -- Faster - no duplicate checking

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 10, line 386)
> -- Ensure proper indexes for optimal UNION performance / -- Recommended indexes: / -- CREATE INDEX IX_Orders_OrderDate_IsActive ON Orders(OrderDate, IsActive);

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 11, line 421)
> -- Monthly executive summary combining key business metrics / SELECT / FORMAT(GETDATE(), 'MMMM yyyy') AS ReportPeriod,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 12, line 497)
> -- Identify data inconsistencies across related tables / SELECT 'Missing d.DepartmentName References' AS IssueType, / 'Employees without valid departments' AS Description,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 13, line 559)
> -- ✅ GOOD: Clear formatting and consistent column naming / SELECT / e.EmployeeID AS ID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 14, line 591)
> -- ✅ GOOD: Explicit data type conversion / SELECT / CAST(e.EmployeeID AS VARCHAR(50)) AS RecordID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 15, line 616)
> -- ✅ GOOD: Filter before UNION, use appropriate indexes / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 16, line 648)
> -- ❌ PROBLEM: Different number of columns / SELECT e.FirstName, e.LastName FROM Employees e / UNION

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 17, line 663)
> -- ❌ PROBLEM: Incompatible data types / SELECT e.EmployeeID, e.BaseSalary FROM Employees e  -- INT, DECIMAL / UNION

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 18, line 678)
> -- ❌ PROBLEM: ORDER BY in individual SELECT statements / SELECT e.FirstName, e.LastName FROM Employees e ORDER BY e.LastName  -- This ORDER BY is ignored / UNION

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson1_Writing_Queries_with_UNION_Operator_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    EXCEPT and INTERSECT Operations                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 3, line 75)
> -- Find employees who exist but have never processed any orders / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 4, line 105)
> -- Identify projects that have no employee assignments / SELECT / p.ProjectID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 5, line 135)
> -- Compare current d.DepartmentName budgets with previous month / -- (Assuming we have a DepartmentHistory table) / SELECT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 6, line 159)
> -- Find customers who placed orders this month but not last month / SELECT DISTINCT / c.CustomerID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 7, line 191)
> -- Find employees who should be managers based on e.BaseSalary but aren't / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 8, line 228)
> -- Find employees who both manage projects AND process orders / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 9, line 258)
> -- Find customers who have orders from multiple departments / SELECT DISTINCT / c.CustomerID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 10, line 290)
> -- Find employees who worked on both high-budget and low-budget projects / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 11, line 326)
> -- Find customers who are both high-value (>$10k orders) AND frequent (>5 orders) / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 12, line 358)
> -- Find employees who meet multiple performance criteria / -- High e.BaseSalary AND project management experience / SELECT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 13, line 392)
> -- Complex analysis: (Managers OR High Earners) BUT NOT Recent Hires / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 14, line 448)
> -- ✅ GOOD: Proper indexing for EXCEPT/INTERSECT / -- Recommended indexes: / -- CREATE INDEX IX_Employees_DepartmentID_IsActive ON Employees(DepartmentID, IsActive);

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 15, line 469)
> -- EXCEPT equivalent using NOT EXISTS (sometimes more efficient) / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 16, line 510)
> -- Validate employee data consistency across systems / -- Find employees in HR system but not in payroll system / SELECT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 17, line 535)
> -- Find customers who are in both premium segment AND loyal segment / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 18, line 569)
> -- ✅ GOOD: Well-structured set operations with comments / -- Find employees who are eligible for promotion / -- (High performers who haven't been promoted recently)

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 19, line 600)
> -- ✅ GOOD: Filter early and use appropriate indexes / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 20, line 619)
> -- ✅ GOOD: Ensure consistent data types / SELECT / CAST(e.EmployeeID AS VARCHAR(20)) AS ID,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 21, line 643)
> -- Set operations treat NULL as equal to NULL / SELECT NULL AS Value / INTERSECT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 22, line 656)
> -- ❌ PROBLEM: Order matters with EXCEPT / SELECT e.FirstName FROM Employees e / EXCEPT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 23, line 677)
> -- ❌ PROBLEM: Inefficient set operations on large datasets / SELECT * FROM LargeTable1 / EXCEPT

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         APPLY Operation Types                               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 3, line 80)
> -- Find the top 3 highest-paid employees in each d.DepartmentName / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 4, line 108)
> -- Get the 5 most recent orders for each customer / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 5, line 139)
> -- Calculate comprehensive performance metrics for each employee / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 6, line 190)
> -- Show all departments with their recent activity (if any) / SELECT d.DepartmentName, / d.Budget,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 7, line 242)
> -- Analyze management structure with subordinate details / SELECT / mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 8, line 281)
> -- Analyze customer purchasing trends over time / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 9, line 326)
> -- Analyze project resource allocation and identify optimization opportunities / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 10, line 390)
> -- Recommended indexes for optimal APPLY performance: / -- CREATE INDEX IX_Employees_DepartmentID_Salary ON Employees(d.DepartmentID, e.BaseSalary DESC, IsActive); / -- CREATE INDEX IX_Orders_CustomerID_OrderDate ON Orders(CustomerID, OrderDate DESC, IsActive);

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 11, line 416)
> -- ✅ APPLY approach (efficient for Top-N per group) / SELECT d.DepartmentName, top_emp.FirstName, top_emp.LastName, top_emp.BaseSalary / FROM Departments d

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 12, line 458)
> -- ✅ GOOD: Well-structured APPLY with clear purpose and aliases / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 13, line 498)
> -- ✅ GOOD: Proper NULL handling with OUTER APPLY / SELECT d.DepartmentName, / ISNULL(emp_stats.EmployeeCount, 0) AS EmployeeCount,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 14, line 523)
> -- ✅ GOOD: Early filtering and appropriate TOP usage / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 15, line 550)
> -- Create comprehensive executive dashboard using APPLY / SELECT / 'Department Performance' AS ReportSection,

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 16, line 615)
> -- ❌ PROBLEM: Inefficient APPLY without proper filtering / SELECT c.CustomerName, all_orders.* / FROM Customers c

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 17, line 640)
> -- ❌ PROBLEM: Using CROSS APPLY when you want all departments / SELECT d.DepartmentName, emp.FirstName / FROM Departments d

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY.md** (block 18, line 666)
> -- ❌ PROBLEM: Overly complex nested APPLY (hard to maintain) / SELECT d.DepartmentName, complex_data.* / FROM Departments d

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 11 - Using Table Expressions/Lesson3_Using_APPLY_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 1, line 15)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.HireDate, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 2, line 46)
> -- Write your UNION query here / -- Combine current and former employees

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 3, line 63)
> -- Write your UNION query for revenue analysis

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 4, line 83)
> -- Write your UNION ALL query for activity log

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 5, line 99)
> -- Write your UNION ALL query for budget analysis

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 6, line 119)
> -- Write your EXCEPT query to find underutilized employees

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 7, line 135)
> -- Write your EXCEPT query for customer retention analysis

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 8, line 155)
> -- Write your INTERSECT query for collaboration analysis

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 9, line 171)
> -- Write your INTERSECT query for high-value customer identification

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 10, line 191)
> -- Write your CROSS APPLY query for dynamic performance analysis

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 11, line 207)
> -- Write your OUTER APPLY query for customer segmentation

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 12, line 233)
> -- Write your comprehensive executive dashboard query

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 13, line 249)
> -- Write your advanced analytics query for resource optimization

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 14, line 269)
> -- Optimized Query 1: (Choose one of your previous queries to optimize) / -- Optimization techniques used: / -- 1.

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 15, line 279)
> -- Optimized Query 2: (Choose another query to optimize) / -- Optimization techniques used: / -- 1.

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators.md** (block 16, line 297)
> -- Validation 1: Check UNION vs UNION ALL understanding / SELECT 'UNION removes duplicates' AS Concept, COUNT(*) AS ResultCount / FROM (

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lab_Using_Set_Operators_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.HireDate, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 2, line 38)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            UNION Operator Syntax                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 3, line 60)
> -- Example: Create comprehensive employee contact directory / -- Combines active employees with recent departures for transition management / -- Create a unified employee contact list

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 4, line 103)
> -- TechCorp Example: Comprehensive Project Timeline Report / -- Combines project milestones with employee assignments / -- Project activity timeline using UNION ALL for better performance

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 5, line 156)
> -- TechCorp Example: Financial Transaction Summary / -- Combines different types of financial data with proper type handling / -- Comprehensive financial summary using UNION with type conversion

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 6, line 208)
> -- TechCorp Example: Employee Performance Analysis with UNION and CTEs / -- Creates comprehensive performance metrics from multiple data sources / WITH HighPerformers AS (

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 7, line 282)
> -- TechCorp Example: Executive Dashboard Summary / -- Combines multiple business metrics into a single executive report / -- Executive summary combining multiple KPIs

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 8, line 382)
> -- TechCorp Example: Optimized UNION Query for Large Datasets / -- Demonstrates performance optimization techniques / -- Optimized employee and customer contact consolidation

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator.md** (block 9, line 471)
> -- TechCorp Example: Conditional Reporting with UNION / -- Creates dynamic reports based on business conditions / DECLARE @ReportType NVARCHAR(20) = 'COMPREHENSIVE'; -- 'SUMMARY', 'DETAILED', 'COMPREHENSIVE'

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson1_Writing_Queries_with_the_UNION_Operator_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 2, line 38)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            EXCEPT Operator Syntax                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 3, line 61)
> -- Example: Find employees who are not currently assigned to any active projects / -- This helps identify available resources for new project assignments / -- Find employees without current project assignments

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 4, line 142)
> -- TechCorp Example: Find employees who are both project managers and team members / -- This identifies employees with dual roles in project management / -- Find employees who serve as both project managers and team members

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 5, line 250)
> -- TechCorp Example: Data Integrity Audit / -- Identify data inconsistencies between related tables / -- Find customers who have placed orders but don't have complete profile information

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 6, line 385)
> -- TechCorp Example: High-Value Employee Identification / -- Find employees who meet multiple high-performance criteria / -- Criteria 1: High e.BaseSalary employees (top 25% in their department)

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 7, line 514)
> -- TechCorp Example: Project Resource Optimization Analysis / -- Complex analysis combining multiple set operations / -- Step 1: Define different employee categories

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 8, line 652)
> -- TechCorp Example: Using CROSS APPLY for correlated operations / -- Find top 3 highest-paid employees in each d.DepartmentName / -- Using CROSS APPLY to get top employees per d.DepartmentName

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 9, line 709)
> -- TechCorp Example: Complex project analysis using APPLY / -- Analyze project performance with employee contribution details / -- Create a table-valued function for project analysis (run this separately)

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson2_Using_EXCEPT_and_INTERSECT_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 2, line 38)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           CROSS APPLY Syntax                               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 3, line 62)
> -- Example: Find top 3 highest-paid employees in each d.DepartmentName / -- This demonstrates how CROSS APPLY enables dynamic top-N analysis / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 4, line 138)
> -- TechCorp Example: d.DepartmentName Analysis with Employee Statistics / -- Shows all departments, even those without employees / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 5, line 240)
> -- First, create a table-valued function for employee project analysis / -- (Run this separately as a DDL statement) / /*

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 6, line 322)
> -- TechCorp Example: Dynamic Customer Analysis with Varying Criteria / -- Shows how APPLY can handle different analysis requirements per customer / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 7, line 451)
> -- TechCorp Example: Optimized APPLY operations for large datasets / -- Demonstrates performance optimization techniques / -- Step 1: Create appropriate indexes (run separately)

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY.md** (block 8, line 557)
> -- TechCorp Example: Comparing APPLY vs JOIN approaches / -- Shows scenarios where APPLY provides advantages over traditional JOINs / -- Scenario 1: Traditional JOIN approach (limited flexibility)

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Lesson3_Using_APPLY_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 1, line 15)
> -- Combine current and former employees for HR communication initiative / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 2, line 59)
> -- Combined revenue analysis FROM Projects p and orders / WITH ProjectRevenue AS ( / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 3, line 115)
> -- Comprehensive activity log using UNION ALL / SELECT / activity_log.ActivityType,

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 4, line 184)
> -- d.DepartmentName budget allocation analysis using UNION ALL / WITH BudgetAllocations AS ( / -- e.BaseSalary Allocations

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 5, line 272)
> -- Find employees not assigned to recent projects / WITH ActiveEmployees AS ( / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 6, line 347)
> -- Identify customers with declining activity using EXCEPT / WITH LastYearCustomers AS ( / SELECT DISTINCT

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 7, line 426)
> -- Find employees working across multiple departments using INTERSECT concept / WITH EmployeeDepartmentProjects AS ( / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 8, line 510)
> -- Find customers who are both high-volume AND high-value using INTERSECT / WITH HighVolumeCustomers AS ( / SELECT

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 9, line 631)
> -- Dynamic performance analysis using CROSS APPLY / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 12 - Using Set Operators/Module12_Exercise_Answers.md** (block 10, line 773)
> -- Dynamic customer segmentation using OUTER APPLY / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 1, line 14)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 2, line 48)
> -- Your UNION query here / -- Hint: Use UNION to eliminate duplicates, UNION ALL if you need to preserve them / -- Remember to use consistent column names and data types across all SELECT statements

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 3, line 101)
> -- Task 2.1.1: Employees never assigned to projects / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 4, line 154)
> -- High performers based on activity metrics / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 5, line 222)
> SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName, / e.JobTitle,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lab_Using_Set_Operators.md** (block 6, line 339)
> -- Executive Dashboard: Combined Set Operations / WITH DepartmentMetrics AS ( / -- Use APPLY operations for department-level analysis

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    UNION vs UNION ALL - Performance Analysis               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 3, line 71)
> -- Create unified contact list for emergency communications / SELECT / 'Internal' AS ContactCategory,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 4, line 107)
> -- Combine revenue streams for executive financial reporting / SELECT / 'Current Period' AS ReportingPeriod,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 5, line 145)
> -- Comprehensive employee analysis including current and former employees / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 6, line 199)
> -- Comprehensive business metrics dashboard using UNION operations / SELECT / 'Human Resources' AS BusinessDimension,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 7, line 287)
> -- Comprehensive quarterly business comparison / SELECT / 'Q1 2024' AS Quarter,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 8, line 359)
> -- Create comprehensive employee skills and capabilities matrix / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 9, line 448)
> -- Performance comparison: UNION vs UNION ALL / -- Set up performance monitoring / SET STATISTICS IO ON;

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 10, line 485)
> -- Optimized UNION query with proper indexing strategy / -- Recommended indexes: / -- CREATE INDEX IX_Orders_OrderDate_IsActive ON Orders(OrderDate, IsActive) INCLUDE (CustomerID, TotalAmount);

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 11, line 529)
> -- Complete audit trail for compliance reporting / SELECT / 'Employee Transaction' AS AuditCategory,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 12, line 586)
> -- Data quality assessment across all major entities / SELECT / 'Employee Data Quality' AS DataCategory,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 13, line 651)
> -- ✅ GOOD: Explicit data type conversions for compatibility / SELECT / CAST(e.EmployeeID AS VARCHAR(20)) AS RecordID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 14, line 681)
> -- ✅ GOOD: Filter early in each SELECT statement / SELECT d.DepartmentName, / 'Current' AS Period,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 15, line 712)
> -- ✅ GOOD: Descriptive and consistent column aliases / SELECT / 'Employee Contact' AS ContactSource,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 16, line 747)
> -- ❌ PROBLEM: Different number of columns / SELECT e.FirstName, e.LastName FROM Employees e WHERE IsActive = 1 / UNION

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 17, line 762)
> -- ❌ PROBLEM: Incompatible data types / SELECT e.EmployeeID, e.BaseSalary FROM Employees e  -- INT, DECIMAL / UNION

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson1_Writing_Queries_with_UNION_Operator.md** (block 18, line 780)
> -- ❌ PROBLEM: ORDER BY in individual SELECT statements (ignored) / SELECT e.FirstName, e.LastName FROM Employees e WHERE IsActive = 1 ORDER BY e.LastName / UNION

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 2, line 33)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                     EXCEPT and INTERSECT Visual Guide                      │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 3, line 82)
> -- Identify employees who should be assigned to projects but aren't / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 4, line 120)
> -- Find customers who were active but haven't placed orders recently / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 5, line 177)
> -- Identify employees violating company policy: high e.BaseSalary without management duties / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 6, line 221)
> -- Track new employees added since last reporting period / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 7, line 276)
> -- Find employees who are both high earners AND have project management experience / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 8, line 331)
> -- Identify customers who are both high-value AND high-frequency purchasers / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 9, line 373)
> -- Find employees who work on projects across multiple departments / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 10, line 437)
> -- Multi-layered compliance check: Employees who meet ALL criteria vs those who don't / WITH HighPerformers AS ( / -- Employees meeting performance criteria

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 11, line 491)
> -- Identify customers with specific purchasing patterns / SELECT / analysis_results.CustomerID,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 12, line 542)
> -- Recommended indexes for optimal performance: / -- CREATE INDEX IX_Employees_Active_Salary ON Employees(IsActive, e.BaseSalary) INCLUDE (e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, DepartmentID); / -- CREATE INDEX IX_Projects_Active_Manager ON Projects(IsActive, ProjectManagerID) INCLUDE (ProjectID, ProjectName, Budget);

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 13, line 575)
> -- Set operation approach / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 14, line 620)
> -- Key performance indicators requiring set operations / SELECT / 'Employee Utilization' AS KPICategory,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 15, line 677)
> -- ✅ GOOD: Clear, well-documented set operations / -- Business Rule: Find senior employees (5+ years) who lack project leadership experience / SELECT

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 16, line 717)
> -- Multi-layered data validation using set operations / SELECT ValidationResults.* / FROM (

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 17, line 773)
> -- Set operations treat NULL as equal to NULL / -- This may produce unexpected results / -- Example: Finding employees without email addresses

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 18, line 793)
> -- ❌ PROBLEM: Inconsistent column types or order / SELECT e.EmployeeID, e.BaseSalary FROM Employees e  -- INT, DECIMAL / EXCEPT

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson2_Using_EXCEPT_and_INTERSECT.md** (block 19, line 816)
> -- ❌ PROBLEM: Set operations on large unfiltered datasets / SELECT * FROM LargeTable1 / EXCEPT

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                       APPLY Operation Comparison                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 3, line 83)
> -- Find the top 3 highest-paid employees in each d.DepartmentName with detailed metrics / SELECT d.DepartmentName, / d.Budget AS DepartmentBudget,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 4, line 113)
> -- Get the 5 most recent orders for each customer with order details / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 5, line 154)
> -- Calculate comprehensive performance metrics for each employee / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 6, line 284)
> -- Comprehensive d.DepartmentName analysis including those with no recent activity / SELECT d.DepartmentName, / FORMAT(d.Budget, 'C') AS DepartmentBudget,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 7, line 383)
> -- Analyze management effectiveness with detailed subordinate metrics / SELECT / mgr.e.FirstName + ' ' + mgr.e.LastName AS ManagerName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 8, line 478)
> -- Analyze customer growth patterns and predict future behavior / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 9, line 585)
> -- Recommended indexes for optimal APPLY performance: / -- CREATE INDEX IX_Employees_Department_Salary ON Employees(d.DepartmentID, e.BaseSalary DESC, IsActive) INCLUDE (e.FirstName, e.LastName, e.JobTitle); / -- CREATE INDEX IX_Orders_Customer_Date ON Orders(CustomerID, OrderDate DESC, IsActive) INCLUDE (TotalAmount, e.EmployeeID);

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 10, line 616)
> -- APPLY approach (efficient for Top-N with complex logic) / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 11, line 667)
> -- ✅ GOOD: Clear structure with meaningful aliases and comments / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 12, line 718)
> -- ✅ GOOD: Comprehensive NULL handling with OUTER APPLY / SELECT d.DepartmentName, / ISNULL(dept_stats.EmployeeCount, 0) AS EmployeeCount,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 13, line 772)
> -- ✅ GOOD: Early filtering and appropriate TOP usage / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 14, line 812)
> -- ❌ PROBLEM: Inefficient APPLY without proper filtering / SELECT c.CustomerName, all_orders.* / FROM Customers c

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 15, line 843)
> -- ❌ PROBLEM: Using CROSS APPLY when you want all departments / SELECT d.DepartmentName, emp.FirstName, emp.BaseSalary / FROM Departments d

✅ **tech company/untitled/Module 13 - Using Window Ranking, Offset, and Aggregate Functions/Lesson3_Using_APPLY.md** (block 16, line 876)
> -- ❌ PROBLEM: Overly complex nested APPLY (hard to maintain) / SELECT d.DepartmentName, complex_data.* / FROM Departments d

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 1, line 14)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 2, line 45)
> -- Task 1.1: Quarterly Financial Performance Matrix / WITH QuarterlyFinancialData AS ( / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 3, line 115)
> -- Task 2.1: Performance Metrics Normalization / WITH PerformanceMatrix AS ( / -- Create a performance matrix (simulated pivoted data)

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 4, line 189)
> -- Task 3.1: Organizational Performance Hierarchy / SELECT / -- Add CASE statements using GROUPING functions for level identification

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 5, line 252)
> -- Task 4.1: Comprehensive Business Intelligence Cube / WITH BusinessIntelligenceData AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lab_Pivoting_and_Grouping_Sets.md** (block 6, line 324)
> -- Task 5.1: Executive Strategic Dashboard / WITH StrategicMetrics AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           PIVOT Operation Flow                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 3, line 57)
> -- Basic PIVOT Syntax / SELECT pivot_columns, [pivot_value1], [pivot_value2], [pivot_value3] / FROM (

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 4, line 76)
> -- Transform quarterly budget data into cross-tabulated format for executive review / WITH QuarterlyBudgetData AS ( / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 5, line 119)
> -- Create e.BaseSalary distribution matrix for HR compensation analysis / WITH EmployeeExperienceData AS ( / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 6, line 164)
> -- Transform customer revenue data for geographic and segment analysis / WITH CustomerOrderSegmentation AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 7, line 220)
> -- Dynamic PIVOT for flexible monthly reporting (2025 example) / DECLARE @PivotColumns NVARCHAR(MAX) = ''; / DECLARE @PivotQuery NVARCHAR(MAX) = '';

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 8, line 271)
> -- Complex PIVOT showing employee allocation across projects and roles / WITH ProjectAllocationData AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 9, line 351)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         UNPIVOT Operation Flow                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 10, line 378)
> -- Basic UNPIVOT Syntax / SELECT fixed_columns, unpivot_column, value_column / FROM (

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 11, line 396)
> -- Normalize quarterly budget data for trend analysis and forecasting / WITH QuarterlyBudgetMatrix AS ( / -- Simulate quarterly budget crosstab (would typically come from PIVOT or imported data)

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 12, line 478)
> -- Transform employee performance matrix into normalized format for detailed analysis / WITH PerformanceMatrix AS ( / -- Create performance metrics matrix (simulated multi-dimensional data)

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 13, line 615)
> -- Complex business intelligence query combining PIVOT and UNPIVOT operations / WITH DepartmentKPIMatrix AS ( / -- First, create a comprehensive KPI matrix using PIVOT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 14, line 790)
> -- Recommended indexes for optimal PIVOT/UNPIVOT performance / -- CREATE INDEX IX_Orders_Employee_Date_Amount ON Orders(EmployeeID, OrderDate, TotalAmount) INCLUDE (CustomerID, IsActive); / -- CREATE INDEX IX_EmployeeProjects_Employee_Project ON EmployeeProjects(EmployeeID, ProjectID, IsActive) INCLUDE (Role, HoursWorked);

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 15, line 823)
> -- ✅ GOOD: Efficient PIVOT with proper filtering and aggregation / WITH FilteredData AS ( / -- Pre-filter data to reduce processing overhead

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 16, line 868)
> -- ❌ PROBLEM: PIVOT doesn't handle NULLs as expected / SELECT d.DepartmentName, [Q1], [Q2], [Q3], [Q4] / FROM (

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson1_Writing_Queries_with_PIVOT_and_UNPIVOT.md** (block 17, line 914)
> -- ❌ PROBLEM: Hard-coded column names in PIVOT / SELECT d.DepartmentName, [Project Alpha], [Project Beta], [Project Gamma] / FROM project_data

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                     Grouping Sets Comparison                               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 3, line 69)
> -- ROLLUP: Hierarchical subtotals (right-to-left hierarchy) / SELECT columns, AGG_FUNCTION(value) / FROM table

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 4, line 96)
> -- Create comprehensive budget analysis with hierarchical subtotals / SELECT / CASE

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 5, line 157)
> -- Comprehensive quarterly sales analysis with time-based hierarchy / SELECT / CASE

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 6, line 235)
> -- Comprehensive customer analysis using CUBE for all dimension combinations / WITH CustomerOrderData AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 7, line 325)
> -- Comprehensive employee performance analysis using CUBE / WITH EmployeePerformanceData AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 8, line 452)
> -- Create custom grouping combinations for executive dashboard / WITH ExecutiveMetrics AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 9, line 574)
> -- Comprehensive budget vs actual analysis with custom groupings / WITH BudgetActualData AS ( / SELECT

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 10, line 706)
> -- Demonstrate advanced grouping identification and custom labels / SELECT / Location,

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 11, line 758)
> -- Recommended indexes for optimal Grouping Sets performance / -- CREATE INDEX IX_Employees_Dept_Location_Salary ON Employees(DepartmentID, IsActive) INCLUDE (e.BaseSalary, e.JobTitle, e.HireDate); / -- CREATE INDEX IX_Departments_Location_Budget ON Departments(Location, IsActive) INCLUDE (DepartmentName, Budget);

✅ **tech company/untitled/Module 14 - Pivoting and Grouping Sets/Lesson2_Working_with_Grouping_Sets.md** (block 12, line 786)
> -- ✅ GOOD: Efficient Grouping Sets with proper filtering / WITH FilteredEmployeeData AS ( / -- Pre-filter data to reduce processing overhead

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 1, line 17)
> -- Employees table (Sample data: e.EmployeeID starts from 3001) / Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / -- Departments table (Sample data: d.DepartmentID starts from 2001)

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 2, line 41)
> -- Lab Setup: Verify database connection and table availability / -- Execute these queries to confirm your environment is ready / -- Check table existence and sample data

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 3, line 87)
> -- Step 1: Create a simple employee lookup procedure / CREATE PROCEDURE sp_Lab_GetEmployeeInfo / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 4, line 172)
> -- Step 1: Create d.DepartmentName summary procedure / CREATE PROCEDURE sp_Lab_GetDepartmentSummary / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 5, line 281)
> -- Step 1: Create employee addition procedure / CREATE PROCEDURE sp_Lab_AddEmployee / @e.FirstName VARCHAR(50),

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 6, line 485)
> -- Step 1: Create employee performance evaluation procedure / CREATE PROCEDURE sp_Lab_EvaluateEmployeePerformance / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 7, line 719)
> -- Step 1: Create dynamic business intelligence reporting procedure / CREATE PROCEDURE sp_Lab_GenerateBusinessReport / @ReportType VARCHAR(50),  -- 'SalesAnalysis', 'EmployeeProductivity', 'DepartmentPerformance', 'CustomerInsights'

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 8, line 1039)
> -- Step 1: Create transaction-safe order processing procedure / CREATE PROCEDURE sp_Lab_ProcessOrderWithValidation / @CustomerID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lab_Executing_Stored_Procedures.md** (block 9, line 1283)
> -- Execute this query to analyze the procedures created during the lab / SELECT / p.name AS ProcedureName,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 1, line 14)
> -- Instead of writing this repeatedly: / SELECT e.FirstName, e.LastName, e.JobTitle, d.DepartmentName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 2, line 24)
> -- Much simpler - just call the procedure: / EXEC GetEngineeringEmployees;

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 3, line 55)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 4, line 68)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    Stored Procedure Architecture                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 5, line 100)
> -- Basic stored procedure structure / CREATE PROCEDURE procedure_name / @parameter1 datatype = default_value,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 6, line 124)
> -- Create stored procedure for d.DepartmentName employee analysis / CREATE PROCEDURE sp_GetDepartmentEmployees / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 7, line 201)
> -- Create comprehensive employee performance analysis procedure / CREATE PROCEDURE sp_GetEmployeePerformanceSummary / @e.EmployeeID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 8, line 308)
> -- Create comprehensive d.DepartmentName financial analysis procedure / CREATE PROCEDURE sp_GetDepartmentFinancialAnalysis / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 9, line 456)
> -- Create comprehensive customer relationship analysis procedure / CREATE PROCEDURE sp_GetCustomerRelationshipAnalysis / @CustomerID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 10, line 614)
> -- Method 1: Named parameters (recommended for clarity) / EXEC sp_GetDepartmentEmployees / @d.DepartmentID = 2001,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 11, line 637)
> -- Example: Robust stored procedure with comprehensive error handling / CREATE PROCEDURE sp_GetEmployeeDetailsWithValidation / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 12, line 732)
> -- Query to analyze stored procedure performance / SELECT / p.name AS ProcedureName,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 13, line 763)
> -- ✅ GOOD: Proper parameter validation and default values / CREATE PROCEDURE sp_GetEmployeeReportGood / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson1_Querying_Data_with_Stored_Procedures.md** (block 14, line 809)
> -- ✅ GOOD: Consistent result set structure / CREATE PROCEDURE sp_GetDepartmentSummaryConsistent / @IncludeEmpty BIT = 0

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        Parameter Types Overview                             │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 3, line 76)
> -- Complete parameter syntax / CREATE PROCEDURE procedure_name / -- Input parameters

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 4, line 102)
> -- Create comprehensive employee search with multiple input parameters / CREATE PROCEDURE sp_SearchEmployeesAdvanced / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 5, line 262)
> -- Create comprehensive financial analysis with date and filtering parameters / CREATE PROCEDURE sp_AnalyzeDepartmentFinancials / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 6, line 479)
> -- Create procedure with multiple output parameters for comprehensive statistics / CREATE PROCEDURE sp_CalculateEmployeeStatistics / @d.DepartmentID INT = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 7, line 654)
> -- Create order processing procedure with comprehensive output parameters / CREATE PROCEDURE sp_ProcessCustomerOrderBatch / @CustomerID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 8, line 819)
> -- Create procedure with input/output parameters for performance calculations / CREATE PROCEDURE sp_CalculateEmployeePerformanceRating / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 9, line 1067)
> -- ✅ GOOD: Comprehensive parameter validation / CREATE PROCEDURE sp_ValidateParametersExample / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson2_Passing_Parameters_to_Stored_Procedures.md** (block 10, line 1130)
> -- ✅ GOOD: Well-designed parameter structure / CREATE PROCEDURE sp_ParameterDesignExample / -- Group related parameters

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 1, line 19)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 2, line 32)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    Stored Procedure Creation Syntax                        │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 3, line 74)
> -- Template for well-structured TechCorp stored procedures / CREATE PROCEDURE sp_TechCorpTemplate / @InputParameter INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 4, line 124)
> -- Create simple employee lookup procedure / CREATE PROCEDURE sp_GetEmployeeBasicInfo / @e.EmployeeID INT

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 5, line 192)
> -- Create procedure to list all employees in a d.DepartmentName / CREATE PROCEDURE sp_GetDepartmentEmployeeList / @d.DepartmentID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 6, line 289)
> -- Create procedure for customer information and order history / CREATE PROCEDURE sp_GetCustomerProfile / @CustomerID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 7, line 406)
> -- Create procedure to add new employee with validation / CREATE PROCEDURE sp_AddNewEmployee / @e.FirstName VARCHAR(50),

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 8, line 589)
> -- Create procedure to update employee information with audit trail / CREATE PROCEDURE sp_UpdateEmployeeInfo / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 9, line 755)
> -- Create procedure to calculate employee performance scores / CREATE PROCEDURE sp_CalculateEmployeePerformanceScore / @e.EmployeeID INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 10, line 923)
> -- ✅ GOOD: Comprehensive error handling template / CREATE PROCEDURE sp_BestPracticeTemplate / @RequiredParam INT,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson3_Creating_Simple_Stored_Procedures.md** (block 11, line 978)
> -- ✅ GOOD: Well-documented procedure with clear naming / /* / Purpose: Retrieve employee information with optional manager details

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 2, line 34)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         Dynamic SQL Architecture                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 3, line 76)
> -- Pattern 1: Simple dynamic query construction / DECLARE @SQL NVARCHAR(MAX); / DECLARE @TableName SYSNAME = 'Employees';

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 4, line 111)
> -- Create flexible employee search procedure with dynamic criteria / CREATE PROCEDURE sp_SearchEmployeesDynamic / @e.FirstName VARCHAR(50) = NULL,

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 5, line 350)
> -- Create dynamic reporting procedure with configurable columns / CREATE PROCEDURE sp_GenerateDepartmentReportDynamic / @DepartmentIDs VARCHAR(500) = NULL,  -- Comma-separated list: '2001,2002,2003'

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 6, line 577)
> -- Create advanced order analysis with complex dynamic conditions / CREATE PROCEDURE sp_AnalyzeOrdersAdvancedDynamic / @AnalysisType VARCHAR(50) = 'Summary',  -- 'Summary', 'Trends', 'Performance', 'Detailed'

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 7, line 849)
> -- ❌ DANGEROUS: Vulnerable to SQL injection / CREATE PROCEDURE sp_UnsafeSearch / @SearchTerm VARCHAR(100)

✅ **tech company/untitled/Module 15 - Executing Stored Procedures/Lesson4_Working_with_Dynamic_SQL.md** (block 8, line 932)
> -- Performance-optimized dynamic search with plan reuse / CREATE PROCEDURE sp_OptimizedDynamicSearch / @SearchFirstName VARCHAR(50) = NULL,

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 1, line 17)
> -- Employees table (Sample data: e.EmployeeID starts from 3001) / Employees: e.EmployeeID, e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / -- Departments table (Sample data: d.DepartmentID starts from 2001)

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 2, line 44)
> -- Lab Setup: Verify database connection and table availability / -- Execute these queries to confirm your environment is ready / -- Check table existence and sample data

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 3, line 78)
> -- Challenge: Implement e.BaseSalary analysis using T-SQL variables / -- Declare and initialize variables for calculation parameters / DECLARE @d.DepartmentID INT = 2001;  -- IT d.DepartmentName

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 4, line 129)
> -- Challenge: Use table variables for complex data processing / -- Declare table variable for employee performance metrics / DECLARE @PerformanceMetrics TABLE (

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 5, line 199)
> -- Challenge: Create intelligent e.BaseSalary adjustment logic using IF...ELSE / DECLARE @e.EmployeeID INT = 3001;  -- Test with specific employee / DECLARE @CurrentSalary DECIMAL(10,2);

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 6, line 291)
> -- Challenge: Use WHILE loops for iterative batch processing / -- Variables for batch processing / DECLARE @BatchSize INT = 10;

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 7, line 431)
> -- Challenge: Create scalar and table-valued functions for TechCorp / -- TODO: Create a scalar function to calculate employee performance score / CREATE FUNCTION dbo.fn_CalculatePerformanceScore

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 8, line 539)
> -- Challenge: Create a comprehensive error handling system / -- Create error log table / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog')

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 9, line 745)
> -- Challenge: Build a complete automated employee management system / -- Create comprehensive management procedure / CREATE OR ALTER PROCEDURE sp_TechCorp_EmployeeManagementSystem

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lab_Programming_with_T-SQL.md** (block 10, line 975)
> -- Validate your implementations with these comprehensive tests / -- Test 1: Variable Usage Validation / DECLARE @TestResults TABLE (TestName VARCHAR(100), Status VARCHAR(20), Details VARCHAR(200));

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 2, line 34)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        T-SQL Variable Management                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 3, line 72)
> -- Demonstrate variable declaration and usage for TechCorp e.BaseSalary analysis / DECLARE @CurrentDate DATE = GETDATE(); / DECLARE @AnalysisYear INT = YEAR(@CurrentDate);

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 4, line 152)
> -- Demonstrate table variables for employee project analysis / DECLARE @EmployeeProjectSummary TABLE ( / e.EmployeeID INT,

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 5, line 249)
> -- Demonstrate various T-SQL functions in TechCorp business context / DECLARE @AnalysisDate DATE = GETDATE(); / DECLARE @FiscalYearStart DATE = DATEFROMPARTS(YEAR(@AnalysisDate), 4, 1); -- April 1st fiscal year

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 6, line 388)
> -- Create scalar function for employee performance calculation / CREATE FUNCTION dbo.fn_CalculateEmployeePerformanceScore / (

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 7, line 640)
> -- Demonstrate comprehensive operator usage in business calculations / DECLARE @BonusPoolTotal DECIMAL(12,2) = 500000.00; / DECLARE @CompanyRevenue DECIMAL(15,2) = 50000000.00;

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson1_T-SQL_Programming_Elements.md** (block 8, line 791)
> -- Demonstrate advanced error handling in T-SQL programming / CREATE PROCEDURE sp_TechCorp_ProcessEmployeeSalaryUpdate / @e.EmployeeID INT,

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 2, line 34)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        T-SQL Conditional Control Flow                      │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 3, line 77)
> -- Comprehensive employee performance review system using conditional logic / CREATE PROCEDURE sp_TechCorp_ProcessPerformanceReview / @e.EmployeeID INT,

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 4, line 382)
> -- Demonstrate WHILE loop usage for batch processing / CREATE PROCEDURE sp_TechCorp_ProcessMonthlyBonusCalculation / @ProcessingYear INT = NULL,

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 5, line 669)
> -- Demonstrate branching and control transfer in data validation workflow / CREATE PROCEDURE sp_TechCorp_DataValidationWorkflow / @ValidationMode VARCHAR(20) = 'FULL', -- 'FULL', 'QUICK', 'CRITICAL'

✅ **tech company/untitled/Module 16 - Programming with T-SQL/Lesson2_Controlling_Program_Flow.md** (block 6, line 1025)
> -- Advanced exception handling for critical business operations / CREATE PROCEDURE sp_TechCorp_CriticalOrderProcessing / @CustomerID INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 1, line 15)
> Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, HireDate, IsActive / Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 2, line 45)
> -- Create your ManageEmployee procedure here / CREATE OR ALTER PROCEDURE ManageEmployee / @Operation NVARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 3, line 79)
> -- Create your transaction-safe order processing procedure here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 4, line 101)
> -- Create error classification tables / CREATE TABLE ErrorCategories ( / -- Define your table structure

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 5, line 132)
> -- Create your retry mechanism procedure here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 6, line 154)
> -- Create your multi-level error handling procedure here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 7, line 172)
> -- Create your error reporting procedures here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 8, line 194)
> -- Create your business rule validation framework here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 9, line 212)
> -- Create your error notification system here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 10, line 234)
> -- Create your optimized error handling solution here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 11, line 252)
> -- Create your system health monitoring solution here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 12, line 274)
> -- Create your error handling test suite here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 13, line 292)
> -- Create your error simulation and load testing tools here

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lab_Implementing_Error_Handling.md** (block 14, line 303)
> -- Validation 1: Error logging functionality / SELECT / 'Error Logging Test' AS TestType,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 2, line 39)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            T-SQL Error Categories                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 3, line 68)
> -- TechCorp Example: Understanding Error Information Functions / -- These functions are available within error handling blocks / SELECT

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 4, line 138)
> -- Basic TRY...CATCH structure for TechCorp operations / BEGIN TRY / -- Code that might cause an error

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 5, line 207)
> -- Comprehensive employee e.BaseSalary update with error handling / CREATE OR ALTER PROCEDURE UpdateEmployeeSalary / @e.EmployeeID INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 6, line 358)
> -- TechCorp Example: Complex project assignment with full error handling / CREATE OR ALTER PROCEDURE AssignEmployeeToProject / @e.EmployeeID INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 7, line 557)
> -- TechCorp Example: Custom error messages for business rules / CREATE OR ALTER PROCEDURE ProcessCustomerOrder / @CustomerID INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson1_Implementing_T-SQL_Error_Handling.md** (block 8, line 777)
> -- TechCorp Standard Error Handling Template / CREATE OR ALTER PROCEDURE TechCorpProcedureTemplate / @Parameter1 INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson2_Implementing_Structured_Exception_Handling.md** (block 1, line 21)
> ErrorLog: ErrorLogID, ErrorNumber, ErrorMessage, ErrorProcedure, ErrorLine, ErrorSeverity, ErrorState, UserName, ErrorTime, AdditionalInfo / ErrorCategories: CategoryID, CategoryName, Description, HandlingStrategy, IsActive / ErrorHandlingRules: RuleID, ErrorNumber, CategoryID, RetryCount, RetryInterval, EscalationLevel, IsActive

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson2_Implementing_Structured_Exception_Handling.md** (block 2, line 36)
> -- TechCorp Example: Multi-level error handling for complex business processes / CREATE OR ALTER PROCEDURE ProcessMonthlyPayroll / @PayrollMonth DATE,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson2_Implementing_Structured_Exception_Handling.md** (block 3, line 325)
> -- TechCorp Error Classification Framework / CREATE OR ALTER PROCEDURE ClassifyAndRouteError / @ErrorNumber INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson2_Implementing_Structured_Exception_Handling.md** (block 4, line 514)
> -- TechCorp Automatic Error Recovery System / CREATE OR ALTER PROCEDURE ExecuteWithRetry / @ProcedureName NVARCHAR(128),

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Lesson2_Implementing_Structured_Exception_Handling.md** (block 5, line 726)
> -- TechCorp Error Analytics and Reporting System / CREATE OR ALTER PROCEDURE GenerateErrorReport / @StartDate DATE = NULL,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Module17_Exercise_Answers.md** (block 1, line 13)
> -- Comprehensive Employee Management Procedure with Error Handling / CREATE OR ALTER PROCEDURE ManageEmployee / @Operation NVARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Module17_Exercise_Answers.md** (block 2, line 459)
> -- Transaction-Safe Order Processing with Comprehensive Error Handling / CREATE OR ALTER PROCEDURE ProcessOrderWithInventory / @CustomerID INT,

✅ **tech company/untitled/Module 17 - Implementing Error Handling/Module17_Exercise_Answers.md** (block 3, line 822)
> -- Create Error Classification Infrastructure / CREATE TABLE ErrorCategories ( / CategoryID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 1, line 17)
> -- Core Business Tables / Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 2, line 36)
> -- Lab Setup: Create supporting tables and verify environment / -- Create Transaction Audit table / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TransactionAudit')

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 3, line 106)
> -- Challenge: Create a transaction-controlled e.BaseSalary update procedure / -- Requirements: Update employee e.BaseSalary and adjust d.DepartmentName budget accordingly / CREATE OR ALTER PROCEDURE sp_UpdateEmployeeSalary

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 4, line 276)
> -- Challenge: Implement comprehensive order processing with transaction control / -- First, create Order Items table if it doesn't exist / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 5, line 401)
> -- Challenge: Implement project setup with multiple phases and savepoint-based rollback / -- Create necessary supporting tables / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProjectBudgetAllocations')

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 6, line 527)
> -- Challenge: Create payroll processing with different isolation level strategies / -- Create payroll processing tables / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PayrollProcessing')

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 7, line 677)
> -- Challenge: Create distributed transaction for complex financial operations / -- Create financial system integration tables / IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FinancialTransactions')

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 8, line 818)
> -- Challenge: Create enterprise-grade transaction management system / CREATE OR ALTER PROCEDURE sp_TechCorp_TransactionManagementSystem / @Operation NVARCHAR(50),  -- 'PROCESS_PAYROLL', 'SETUP_PROJECT', 'PROCESS_ORDERS', 'FINANCIAL_TRANSFER'

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 9, line 998)
> -- Comprehensive lab validation and performance analysis / CREATE OR ALTER PROCEDURE sp_ValidateTransactionLabCompletion / AS

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lab_Implementing_Transactions.md** (block 10, line 1096)
> -- Transaction performance benchmarking / CREATE OR ALTER PROCEDURE sp_BenchmarkTransactionPerformance / @TestDurationSeconds INT = 30

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 2, line 38)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            Transaction Lifecycle                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 3, line 61)
> -- Example: Updating employee e.BaseSalary with d.DepartmentName budget adjustment / -- This demonstrates a complete transaction that maintains data consistency / BEGIN TRANSACTION EmpSalaryUpdate;

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 4, line 129)
> -- TechCorp Example: Project Assignment Transaction / -- Either all operations succeed, or all are rolled back / BEGIN TRANSACTION ProjectAssignment;

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 5, line 173)
> -- TechCorp Example: Order Processing with Inventory Management / -- Maintains referential integrity and business rules / CREATE OR ALTER PROCEDURE sp_ProcessCustomerOrder

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 6, line 242)
> -- TechCorp Example: Concurrent e.BaseSalary Processing / -- Demonstrates isolation levels to prevent conflicts / -- Session 1: Processing e.BaseSalary increases

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 7, line 269)
> -- Session 2: Reading e.BaseSalary information (concurrent operation) / SET TRANSACTION ISOLATION LEVEL READ COMMITTED; / -- This will wait for Session 1 to complete due to isolation

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 8, line 287)
> -- TechCorp Example: Critical Financial Transaction with Durability Assurance / -- Ensures permanent storage of important business data / CREATE OR ALTER PROCEDURE sp_ProcessCriticalPayroll

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 9, line 346)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        SQL Server Transaction Log                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 10, line 370)
> -- Monitor transaction log usage for TechCorp database / SELECT / name AS DatabaseName,

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 11, line 409)
> -- TechCorp Example: Lock Monitoring During Busy Operations / -- Monitor locks during employee e.BaseSalary processing / -- Query to view current locks

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 12, line 465)
> -- TechCorp Example: Comprehensive Transaction Performance Analysis / -- Create procedure to analyze transaction performance / CREATE OR ALTER PROCEDURE sp_AnalyzeTransactionPerformance

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson1_Transactions_and_the_Database_Engine.md** (block 13, line 528)
> -- Best Practice Example: Well-designed transaction with proper error handling / CREATE OR ALTER PROCEDURE sp_TechCorp_OptimalTransaction / @e.EmployeeID INT,

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 1, line 21)
> Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.HireDate, IsActive / Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive / Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 2, line 39)
> -- TechCorp Example: Employee Transfer with Explicit Transaction Control / -- Demonstrates complete control over transaction lifecycle / CREATE OR ALTER PROCEDURE sp_TransferEmployee

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 3, line 190)
> -- TechCorp Example: Complex Project Setup with Savepoints / -- Demonstrates granular transaction control with multiple rollback points / CREATE OR ALTER PROCEDURE sp_SetupComplexProject

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 4, line 409)
> -- TechCorp Example: Demonstrating Different Isolation Levels / -- Shows impact of isolation levels on concurrent operations / -- Create test procedure for isolation level demonstration

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 5, line 493)
> -- TechCorp Example: Using Snapshot Isolation for Consistent Reporting / -- Ensures consistent reporting data even during concurrent updates / -- Enable snapshot isolation for the database (run once)

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 6, line 600)
> -- TechCorp Example: Distributed Transaction for Cross-System Integration / -- Demonstrates coordination between multiple databases/systems / CREATE OR ALTER PROCEDURE sp_ProcessDistributedPayroll

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 7, line 704)
> -- TechCorp Example: Dynamic Transaction Control for Flexible Operations / -- Demonstrates transaction control with dynamically generated SQL / CREATE OR ALTER PROCEDURE sp_DynamicDataArchival

✅ **tech company/untitled/Module 18 - Implementing Transactions/Lesson2_Controlling_Transactions.md** (block 8, line 849)
> -- TechCorp Example: Comprehensive Transaction Performance Monitoring / -- Tools for analyzing and optimizing transaction performance / CREATE OR ALTER PROCEDURE sp_AnalyzeTransactionPerformance

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 1, line 43)
> -- Connect to our TechCorp database from Module 1 / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 2, line 58)
> -- Companies table - TechCorp's clients / CREATE TABLE Companies ( / CompanyID INT PRIMARY KEY IDENTITY(1001,1),

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 3, line 127)
> -- Insert TechCorp client companies / INSERT INTO Companies (CompanyName, Industry, CompanySize, AnnualRevenue, ContactEmail, Country) VALUES / ('GlobalTech Industries', 'Manufacturing', 'Large', 250000000.00, 'contact@globaltech.com', 'USA'),

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 4, line 202)
> -- Your first real business query! / -- This shows you everyone who works at TechCorp / SELECT * FROM Employees e;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 5, line 215)
> -- Sometimes you don't need all information - just the basics / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 6, line 231)
> -- Let's do some business math - calculate monthly salaries / SELECT / e.FirstName + ' ' + e.LastName AS FullName,    -- Combine first and last name

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 7, line 360)
> SELECT DepartmentID, AVG(e.BaseSalary) as AvgSalary / FROM Employees e / WHERE IsActive = 1

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 8, line 369)
> SELECT e.FirstName, e.LastName, d.DepartmentName / FROM Employees e / JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 9, line 380)
> SELECT FirstName + ' ' + LastName AS FullName, BaseSalary / FROM Employees e / WHERE FullName LIKE 'John%';

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying.md** (block 10, line 386)
> SELECT DepartmentID, COUNT(*) AS EmpCount / FROM Employees e / WHERE EmpCount > 2

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 1, line 10)
> -- Answer 1: Basic Selection / SELECT * FROM Employees e;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 2, line 18)
> -- Answer 2: Column Selection / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 3, line 27)
> -- Answer 3: Calculated Columns / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 4, line 39)
> -- Answer 4: String Functions / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 5, line 52)
> -- Answer 5: Date Functions / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 6, line 67)
> -- Answer 1: e.BaseSalary Filter / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 7, line 77)
> -- Answer 2: Hire Date Filter / SELECT e.FirstName, e.LastName, e.HireDate / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 8, line 87)
> -- Answer 3: d.DepartmentName Filter / SELECT e.FirstName, e.LastName, Title, d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 9, line 98)
> -- Answer 4: Name Pattern Filter / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 10, line 108)
> -- Answer 5: Middle Name Filter / SELECT e.FirstName, MiddleName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 11, line 118)
> -- Answer 6: Range Filter / SELECT e.FirstName, e.LastName, e.BaseSalary, IsActive / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 12, line 131)
> -- Answer 1: WorkEmail Pattern Filter / SELECT e.FirstName, e.LastName, WorkEmail / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 13, line 142)
> -- Answer 2: Year Range Filter / SELECT e.FirstName, e.LastName, e.HireDate / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 14, line 154)
> -- Answer 3: Complex Logic Filter / SELECT e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 15, line 165)
> -- Answer 4: Name Suffix Filter / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 16, line 180)
> -- Answer 1: UNION Operation / SELECT e.FirstName FROM Employees e WHERE d.DepartmentID <= 2 / UNION

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 17, line 190)
> -- Answer 2: INTERSECT Operation / SELECT d.DepartmentID FROM Employees e WHERE e.BaseSalary > 70000 / INTERSECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 18, line 200)
> -- Answer 3: EXCEPT Operation / SELECT e.EmployeeID FROM Employees e / EXCEPT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 19, line 212)
> -- Answer 1: IN Operator / SELECT e.FirstName, e.LastName, d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 20, line 222)
> -- Answer 2: Project IsActive Filter / SELECT DISTINCT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 21, line 234)
> -- Answer 3: EXISTS Operation / SELECT d.DepartmentName / FROM Departments d

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 22, line 248)
> -- Answer 4: Manager Filter / SELECT e.FirstName, e.LastName / FROM Employees e e1

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 23, line 264)
> -- Answer 1: ALL Projects / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 24, line 283)
> -- Answer 2: Same Projects as Employee 2 / SELECT DISTINCT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 25, line 299)
> -- Answer 3: High-e.BaseSalary Departments / SELECT d.DepartmentName / FROM Departments d

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 26, line 324)
> -- Answer 1: No Middle Name / SELECT e.FirstName, e.LastName, MiddleName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 27, line 334)
> -- Answer 2: NULL or Empty Middle Name / SELECT e.FirstName, e.LastName, MiddleName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 28, line 344)
> -- Answer 3: Full Names with NULL Handling / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 29, line 362)
> -- Answer 4: Top-Level Managers / SELECT e.FirstName, e.LastName, Title, ManagerID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 30, line 374)
> -- Answer 1: Complex e.BaseSalary and d.DepartmentName Logic / SELECT e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 31, line 386)
> -- Answer 2: Project IsActive and d.Budget Logic / SELECT ProjectName, IsActive, d.Budget / FROM Projects p

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 32, line 401)
> -- Answer 1: Logical Processing Order / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,  -- 5. SELECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 33, line 424)
> -- Answer 2: Alias Usage Demonstration / -- CORRECT: Using alias in ORDER BY (processed after SELECT) / SELECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 34, line 452)
> -- Answer 1: Complex Query with All Clauses / SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS EmployeeCount,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 35, line 471)
> -- Answer 2: Subquery Processing Order / -- Subquery in WHERE clause (processed during WHERE phase) / SELECT e.FirstName, e.LastName, e.BaseSalary

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 36, line 512)
> -- Answer: Employee Performance Report / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 37, line 537)
> -- Answer: Project Resource Allocation / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers.md** (block 38, line 558)
> -- Answer: d.DepartmentName d.Budget Analysis / SELECT d.DepartmentName, / d.Budget AS DepartmentBudget,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lab_Introduction_to_T-SQL_Querying_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 1, line 22)
> -- Select all columns from a table / SELECT * FROM Employees e; / -- Select specific columns

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 2, line 32)
> -- Filter records with conditions / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 3, line 40)
> -- Common T-SQL data types / DECLARE @Name NVARCHAR(50) = 'John Doe'; / DECLARE @Age INT = 30;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 4, line 51)
> -- String functions / SELECT / UPPER(e.FirstName) AS UpperFirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 5, line 68)
> -- Using CASE statement / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 6, line 83)
> -- GROUP BY with aggregate functions / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 7, line 99)
> -- CTE for complex queries / WITH EmployeeSalaryRanking AS ( / SELECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 8, line 116)
> -- Advanced window functions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 9, line 130)
> -- Recursive CTE for hierarchical data / WITH EmployeeHierarchy AS ( / -- Anchor member (top-level managers)

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 10, line 167)
> -- T-SQL specific / DECLARE @Variable INT = 10; / -- Standard SQL (not supported in all databases)

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 11, line 176)
> -- T-SQL IF...ELSE / IF @BaseSalary > 50000 / BEGIN

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 12, line 189)
> -- T-SQL specific functions / SELECT / ISNULL(MiddleName, 'No Middle Name') AS MiddleName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 13, line 200)
> -- Good / SELECT emp.FirstName, emp.LastName / FROM Employees e emp;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 14, line 211)
> -- Good / SELECT * FROM dbo.Employees; / -- Avoid

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 15, line 220)
> -- Well formatted / SELECT / emp.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL.md** (block 16, line 234)
> -- Use ISNULL or COALESCE / SELECT / FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 1, line 33)
> -- This is your first T-SQL statement / SELECT 'Hello, I am learning T-SQL!' AS MyFirstMessage;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 2, line 48)
> -- Your turn! Try this: / SELECT 'I am practicing T-SQL!' AS Practice;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 3, line 68)
> -- Connect to our TechCorp database / USE TechCorpDB; / -- Ask for basic information

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 4, line 80)
> -- Simple math / SELECT / 2 + 2 AS Addition,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 5, line 102)
> -- Look at all employees (just first 5 to keep it simple) / SELECT TOP 5 * / FROM Employees e;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 6, line 115)
> -- Get just names and job titles / SELECT TOP 5 / e.FirstName AS [First Name],

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 7, line 130)
> -- This is a comment - it explains what the code does / -- Comments help you and others understand your work / -- Get employee information for a report

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 8, line 144)
> -- Your turn! Write a query with comments / -- Get department information / SELECT TOP 5

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 9, line 172)
> -- Run this and practice reading the results / SELECT TOP 3 / e.FirstName AS [Name],

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 10, line 196)
> -- Your solution here: / -- [Try to write this yourself first!] / -- Solution:

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 11, line 231)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 12, line 249)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson1_Introducing_T-SQL_Beginner.md** (block 13, line 262)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 1, line 11)
> Set A (Employees)          Set B (Customers) / ┌─────────────────┐       ┌─────────────────┐ / │                 │       │                 │

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 2, line 33)
> Set A ∪ Set B (UNION) / ┌─────────────────────────────────────┐ / │                                     │

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 3, line 50)
> Set A ∩ Set B (INTERSECT) / ┌─────────────┐ / │    Set A    │

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 4, line 66)
> Set A - Set B (EXCEPT) / ┌─────────────┐ / │    Set A    │

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 5, line 84)
> -- Basic UNION (removes duplicates) / SELECT e.FirstName, e.LastName FROM Employees e / UNION

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 6, line 97)
> -- Find cities that have both employees and customers / SELECT City FROM Employees e / INTERSECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 7, line 105)
> -- Find cities with employees but no customers / SELECT City FROM Employees e / EXCEPT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 8, line 115)
> -- Multiple set operations with ordering / ( / SELECT 'Employee' AS Type, e.FirstName, e.LastName, City

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 9, line 132)
> -- Simple membership test / SELECT CustomerID, CompanyName FROM Customers / WHERE CategoryID IN (1, 3, 5);

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 10, line 147)
> -- Using EXISTS (more efficient for large datasets) / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 11, line 169)
> -- Complex set analysis using CTEs / WITH HighValueCustomers AS ( / SELECT CustomerID, SUM(OrderTotal) AS TotalSpent

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 12, line 197)
> -- Find employees with unique skill combinations / WITH EmployeeSkills AS ( / SELECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 13, line 221)
> -- Find products that are ordered by all customers in a specific region / WITH RegionCustomers AS ( / SELECT DISTINCT CustomerID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 14, line 252)
> -- Inefficient cursor-based approach / DECLARE @e.EmployeeID INT; / DECLARE @TotalSales DECIMAL(10,2);

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 15, line 280)
> -- Efficient set-based approach / UPDATE e / SET TotalSales = ISNULL(o.TotalSales, 0)

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 16, line 297)
> -- NULL values in UNION / SELECT Name FROM Table1 WHERE Name IS NOT NULL / UNION

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 17, line 322)
> -- Ensure proper indexing for set operations / CREATE INDEX IX_Employees_City ON Employees(City); / CREATE INDEX IX_Customers_City ON Customers(City);

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 18, line 334)
> -- UNION vs UNION ALL / -- Use UNION ALL when you know there are no duplicates / -- or when duplicates are acceptable

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 19, line 344)
> -- EXISTS is often more efficient for large datasets / SELECT c.CustomerName / FROM Customers c

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 20, line 358)
> -- Find employees without orders / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 21, line 369)
> -- Check if two tables have the same set of values / WITH Table1Count AS ( / SELECT COUNT(*) AS Cnt FROM (

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets.md** (block 22, line 395)
> -- Find customers who have ordered ALL products in a category / WITH CategoryProducts AS ( / SELECT ProductID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson2_Understanding_Sets_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 1, line 19)
> AND   │ TRUE  │ FALSE │ UNKNOWN / ──────┼───────┼───────┼───────── / TRUE  │ TRUE  │ FALSE │ UNKNOWN

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 2, line 28)
> OR    │ TRUE  │ FALSE │ UNKNOWN / ──────┼───────┼───────┼───────── / TRUE  │ TRUE  │ TRUE  │ TRUE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 3, line 37)
> Expression │ NOT Expression / ───────────┼─────────────── / TRUE       │ FALSE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 4, line 46)
> ┌─────────────────┐ / │   Input Data    │ / └─────────┬───────┘

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 5, line 69)
> -- Basic comparison operators / SELECT * FROM Employees e WHERE e.BaseSalary > 50000;        -- Greater than / SELECT * FROM Employees e WHERE Age <= 30;             -- Less than or equal

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 6, line 79)
> -- Range checking / SELECT * FROM Employees e / WHERE e.BaseSalary BETWEEN 40000 AND 80000;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 7, line 94)
> -- List membership / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 8, line 114)
> -- Basic pattern matching / SELECT * FROM Employees e WHERE e.FirstName LIKE 'J%';     -- Starts with 'J' / SELECT * FROM Employees e WHERE e.FirstName LIKE '%son';   -- Ends with 'son'

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 9, line 128)
> -- Testing for NULL values / SELECT * FROM Employees e WHERE MiddleName IS NULL; / SELECT * FROM Employees e WHERE MiddleName IS NOT NULL;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 10, line 139)
> -- Correlated subquery existence test / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 11, line 159)
> -- AND, OR, NOT operators with proper grouping / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 12, line 182)
> -- Multi-condition evaluation / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 13, line 206)
> -- Complex LIKE patterns with character classes / SELECT CustomerID, CompanyName FROM Customers / WHERE ProductCode LIKE '[A-Z][A-Z][0-9][0-9][0-9]';  -- Two letters followed by three digits

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 14, line 222)
> -- Double negation (find customers who have ordered ALL products from a category) / SELECT c.CustomerName / FROM Customers c

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 15, line 254)
> -- Understanding AND with NULLs / /* / TRUE  AND TRUE  = TRUE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 16, line 275)
> -- Understanding OR with NULLs / /* / TRUE  OR TRUE  = TRUE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 17, line 296)
> -- Understanding NOT with NULLs / /* / NOT TRUE  = FALSE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 18, line 316)
> -- Flexible search with optional parameters / DECLARE @SearchName NVARCHAR(50) = NULL; / DECLARE @SearchDept NVARCHAR(50) = 'IT';

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 19, line 331)
> -- Flexible date filtering / SELECT * / FROM Orders

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 20, line 352)
> -- ANY/ALL predicates (SQL Standard - limited support in T-SQL) / SELECT * / FROM Products

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 21, line 375)
> -- Sargable (Search ARGument ABLE) - can use indexes efficiently / SELECT * FROM Employees e WHERE e.BaseSalary > 50000; / SELECT * FROM Employees e WHERE e.LastName = 'Smith';

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 22, line 388)
> -- Instead of complex OR conditions that can't use indexes well / SELECT * FROM Employees e / WHERE e.FirstName = 'John' OR e.LastName = 'Smith' OR d.DepartmentName = 'Engineering';

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 23, line 402)
> -- EXISTS often performs better with correlated subqueries / SELECT c.CustomerName / FROM Customers c

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 24, line 420)
> -- Always be explicit about NULL handling / SELECT * / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 25, line 433)
> -- Clear precedence with parentheses / SELECT * / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic.md** (block 26, line 444)
> -- Ensure consistent data types to avoid implicit conversions / SELECT * / FROM Orders

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson3_Understanding_Predicate_Logic_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 1, line 9)
> SELECT column_list / FROM table_source / WHERE filter_condition

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 2, line 31)
> -- Written order / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 3, line 47)
> -- Written order / SELECT DepartmentID, COUNT(*) AS EmployeeCount / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 4, line 62)
> -- Written order / SELECT DepartmentID, AVG(e.BaseSalary) AS AvgSalary / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 5, line 81)
> -- Written order / SELECT d.DepartmentName, / AVG(e.BaseSalary) AS AvgSalary,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 6, line 105)
> -- This works - alias can be used in ORDER BY / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 7, line 129)
> -- Each subquery follows its own logical processing order / SELECT e.d.DepartmentName, / e.AvgSalary,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 8, line 151)
> -- Window functions are processed during the SELECT phase / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 9, line 174)
> -- CTEs are processed before the main query / WITH DepartmentStats AS ( / -- This CTE follows standard logical order

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 10, line 207)
> -- Complex join with multiple processing phases / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 11, line 236)
> -- WRONG: Trying to use alias in WHERE clause / SELECT / e.BaseSalary * 1.1 AS IncreasedSalary

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 12, line 263)
> -- WRONG: Selecting non-grouped columns / SELECT d.DepartmentName, / e.FirstName,      -- Error: not in GROUP BY

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 13, line 282)
> -- Use WHERE for row-level filtering (before grouping) / SELECT DepartmentID, COUNT(*) AS EmployeeCount / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 14, line 306)
> -- Good: Filter early in WHERE clause / SELECT d.DepartmentName, / AVG(e.BaseSalary) AS AvgSalary

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 15, line 327)
> -- Sargable predicates in WHERE can use indexes / SELECT * / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 16, line 347)
> -- ORDER BY is processed last, so it works on final result set / -- Consider covering indexes for ORDER BY columns / CREATE INDEX IX_Employees_Dept_Salary

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 17, line 364)
> -- Break down complex queries step by step / -- Step 1: Start with FROM and WHERE / SELECT *

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md** (block 18, line 400)
> -- Optimize based on logical order / -- 1. Optimize FROM clause (choose right tables, join order) / -- 2. Optimize WHERE clause (most selective filters first, sargable predicates)

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 1, line 13)
> SELECT / e.LastName + ', ' + e.FirstName + / CASE

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 2, line 30)
> SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName, / e.BaseSalary,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 3, line 47)
> WITH EmployeeTenure AS ( / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 4, line 70)
> SELECT / DATENAME(MONTH, e.HireDate) AS HireMonth, / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 5, line 89)
> WITH EmailBase AS ( / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 6, line 117)
> SELECT d.DepartmentName, 'High d.Budget' AS Reason / FROM Departments d / WHERE d.Budget > 300000

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 7, line 140)
> -- Employees in IT working on "In Progress" projects / SELECT e.EmployeeID / FROM Employees e

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 8, line 161)
> SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName, / d.DepartmentName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 9, line 188)
> -- Project Leaders (2+ projects) / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 10, line 231)
> -- Assuming a Skills table exists, this would identify gaps / WITH ProjectRequiredSkills AS ( / -- Hypothetical: projects require certain skills

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 11, line 267)
> SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName, / e.HireDate,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 12, line 287)
> SELECT DISTINCT d.DepartmentName / FROM Departments d / WHERE EXISTS (

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 13, line 320)
> -- Projects with no employee assignments / SELECT p.ProjectName, 'No employees assigned' AS Issue / FROM Projects p

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 14, line 368)
> -- PROBLEM: 'TeamSize' column doesn't exist and is used in WHERE before being defined / -- INCORRECT QUERY ISSUES: / -- 1. 'TeamSize' is not a column in any table

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 15, line 395)
> -- PROBLEM: 'Category' alias used in WHERE clause before SELECT processing / -- INCORRECT QUERY ISSUES: / -- 1. Aliases created in SELECT are not available in WHERE clause

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 16, line 447)
> SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount, / AVG(e.BaseSalary) AS AvgSalary

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 17, line 481)
> WITH DepartmentMetrics AS ( / SELECT / d.DepartmentID,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 18, line 546)
> WITH EmployeeMetrics AS ( / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercise_Answers.md** (block 19, line 631)
> -- Comprehensive Resource Optimization Analysis / WITH EmployeeWorkload AS ( / SELECT

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercises.md** (block 1, line 92)
> SELECT d.DepartmentName, AVG(e.BaseSalary) as AvgSal, TeamSize / FROM Departments d / JOIN Employees e ON d.DepartmentID = e.d.DepartmentID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/Module2_Exercises.md** (block 2, line 104)
> SELECT / e.EmployeeID, / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 1, line 43)
> -- Connect to our TechCorp database from Module 1 / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 2, line 58)
> -- Companies table - TechCorp's clients / CREATE TABLE Companies ( / CompanyID INT PRIMARY KEY IDENTITY(1001,1),

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 3, line 127)
> -- Insert TechCorp client companies / INSERT INTO Companies (CompanyName, Industry, CompanySize, AnnualRevenue, ContactEmail, Country) VALUES / ('GlobalTech Industries', 'Manufacturing', 'Large', 250000000.00, 'contact@globaltech.com', 'USA'),

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 4, line 202)
> -- Your first real business query! / -- This shows you everyone who works at TechCorp / SELECT * FROM Employees e;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 5, line 215)
> -- Sometimes you don't need all information - just the basics / SELECT / e.FirstName,

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 6, line 231)
> -- Let's do some business math - calculate monthly salaries / SELECT / e.FirstName + ' ' + e.LastName AS FullName,    -- Combine first and last name

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 7, line 360)
> SELECT DepartmentID, AVG(e.BaseSalary) as AvgSalary / FROM Employees e / WHERE IsActive = 1

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 8, line 369)
> SELECT e.FirstName, e.LastName, d.DepartmentName / FROM Employees e / JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 9, line 380)
> SELECT FirstName + ' ' + LastName AS FullName, BaseSalary / FROM Employees e / WHERE FullName LIKE 'John%';

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 10, line 386)
> SELECT DepartmentID, COUNT(*) AS EmpCount / FROM Employees e / WHERE EmpCount > 2

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 11, line 491)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 12, line 520)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-advanced.md** (block 13, line 528)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 2 - Introduction to T-SQL Querying/lab-tsql-querying-beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements.md** (block 1, line 15)
> -- Connect to our TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements.md** (block 2, line 34)
> -- Employees table (expanded) / CREATE TABLE Employees ( / EmployeeID INT PRIMARY KEY IDENTITY(1,1),

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements.md** (block 3, line 116)
> -- Insert expanded sample data / INSERT INTO Departments (DepartmentName, DepartmentCode, Budget, Location, CostCenter) VALUES / ('Information Technology', 'IT', 750000, 'Building A - Floor 3', 'CC001'),

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 1, line 10)
> -- Answer 1: Select All Employees / SELECT * FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 2, line 26)
> -- Answer 2: Select Specific Columns / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 3, line 43)
> -- Answer 3: Select with Calculated Columns / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 4, line 77)
> -- Answer 1: String Manipulations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 5, line 94)
> -- Answer 2: Date Operations / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 6, line 112)
> -- Answer 3: Numeric Operations / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 7, line 133)
> -- Answer 1: Distinct Departments / SELECT DISTINCT d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 8, line 143)
> -- Answer 2: Distinct Cities / SELECT DISTINCT City / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 9, line 154)
> -- Answer 3: Distinct Job Titles / SELECT DISTINCT Title / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 10, line 166)
> -- Answer 1: Distinct City-State Combinations / SELECT DISTINCT City, State / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 11, line 177)
> -- Answer 2: Distinct Department-Title Combinations / SELECT DISTINCT / d.DepartmentName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 12, line 192)
> -- Answer 1: Count of Employees by d.DepartmentName / -- Using GROUP BY (preferred for aggregations) / SELECT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 13, line 218)
> -- Answer 1: Meaningful Column Names / SELECT / e.FirstName AS [First Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 14, line 235)
> -- Answer 2: Aliases with Special Characters / SELECT / e.FirstName + ' ' + e.LastName AS "Employee Name",

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 15, line 255)
> -- Answer 1: Simple Table Aliases / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 16, line 270)
> -- Answer 2: Multiple Table Aliases / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 17, line 291)
> -- Answer 1: Employee-Manager Relationship / SELECT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 18, line 310)
> -- Answer 1: e.BaseSalary Categories / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 19, line 328)
> -- Answer 2: Employment IsActive / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 20, line 350)
> -- Answer 1: d.DepartmentName e.BaseSalary Analysis / SELECT d.DepartmentName, / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 21, line 370)
> -- Answer 2: Project Status Summary / SELECT / COUNT(*) AS TotalProjects,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 22, line 388)
> -- Answer 1: Complex Employee Classification / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 23, line 423)
> -- Answer 2: Performance Rating / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 24, line 462)
> -- Answer 1: Employee Contact Information Report / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 25, line 502)
> -- Answer 1: Employee Data Completeness Analysis / SELECT / 'Total Employees' AS DataField,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers.md** (block 26, line 565)
> -- Answer 1: d.DepartmentName Summary Dashboard / SELECT d.DepartmentName AS d.DepartmentName, / d.DepartmentCode AS [Dept Code],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Beginner.md** (block 1, line 28)
> -- Write your query here: / -- SOLUTION (try first, then check): / SELECT TOP 3 *

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Beginner.md** (block 2, line 42)
> -- Write your query here: / -- SOLUTION: / SELECT TOP 5

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lab_Writing_Basic_SELECT_Statements_Beginner.md** (block 3, line 60)
> -- Write your query here: / -- SOLUTION: / SELECT TOP 5

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 1, line 9)
> SELECT column_list / FROM table_name / [WHERE condition]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 2, line 17)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                          SELECT STATEMENT EXECUTION FLOW                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 3, line 75)
> -- Retrieve all columns FROM Employees e table / SELECT * FROM Employees e; / -- More explicit version (better practice)

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 4, line 92)
> -- Basic column selection / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 5, line 106)
> -- Columns appear in the order specified / SELECT / e.LastName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 6, line 124)
> -- Including literal values in results / SELECT / 'Employee' AS RecordType,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 7, line 147)
> -- Mathematical operations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 8, line 172)
> -- Basic string concatenation / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 9, line 195)
> -- Date calculations and formatting / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 10, line 218)
> -- Simple filtering / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 11, line 251)
> -- Advanced business calculations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 12, line 282)
> -- Complex string operations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 13, line 304)
> -- Comprehensive date analysis / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 14, line 341)
> -- Advanced business rule implementation / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 15, line 382)
> -- Good: Specify only needed columns / SELECT e.FirstName, e.LastName, WorkEmail / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 16, line 392)
> -- Good: Consistent, readable formatting / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 17, line 408)
> -- Good: Clear, descriptive names / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeFullName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 18, line 424)
> -- Good: Explicit NULL handling / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 19, line 441)
> -- Employee compensation analysis with business context / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 20, line 465)
> -- Problematic: Mixing data types / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 21, line 482)
> -- Problematic: NULL in concatenation makes entire result NULL / SELECT / e.FirstName + ' ' + MiddleName + ' ' + e.LastName AS FullName

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 22, line 495)
> -- Problematic: Potential division by zero / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 23, line 517)
> -- More efficient: Select only needed columns / SELECT e.FirstName, e.LastName, WorkEmail / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 24, line 527)
> -- Consider performance impact of functions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements.md** (block 25, line 541)
> -- For frequently used complex calculations, consider computed columns / -- or views rather than repeating logic in every query / -- Example: This complex calculation in every query

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 1, line 33)
> -- See everything in the Employees table / SELECT * / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 2, line 51)
> -- Show just names and job titles / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 3, line 67)
> -- Your turn! Show employee names and salaries / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 4, line 82)
> -- Give columns friendly names using AS / SELECT / e.FirstName AS [First Name],        -- Friendly column name

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 5, line 102)
> -- Combine first and last names into full names / SELECT / e.FirstName + ' ' + e.LastName AS [Full Name],  -- Combine with space

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 6, line 115)
> -- Create a professional employee directory / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 7, line 131)
> -- Show only the first 5 employees / SELECT TOP 5 / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 8, line 149)
> -- Show the first 10% of employees / SELECT TOP 10 PERCENT / e.FirstName AS [Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 9, line 159)
> -- Show the first 3 departments / SELECT TOP 3 / d.DepartmentName AS [Department],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 10, line 175)
> -- Look at department information / SELECT TOP 5 / d.DepartmentName AS [Department Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 11, line 186)
> -- Look at current projects / SELECT TOP 5 / p.ProjectName AS [Project Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 12, line 198)
> -- Look at customer information / SELECT TOP 5 / c.CustomerName AS [Company Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 13, line 212)
> -- 1. Get product information / SELECT TOP 3 / p.ProductName AS [Product Name],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 14, line 251)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 15, line 269)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson1_Writing_Simple_SELECT_Statements_Beginner.md** (block 16, line 282)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 1, line 12)
> SELECT DISTINCT column_list / FROM table_name / [WHERE condition]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 2, line 22)
> -- Without DISTINCT - shows all d.DepartmentName IDs (with duplicates) / SELECT d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 3, line 42)
> -- Find all unique job titles in the company / SELECT DISTINCT Title / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 4, line 60)
> -- Count total employees / SELECT COUNT(*) AS TotalEmployees / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 5, line 80)
> -- DISTINCT applies to the combination of ALL columns / SELECT DISTINCT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 6, line 97)
> -- Unique e.BaseSalary ranges / SELECT DISTINCT / CASE

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 7, line 122)
> -- Find employees who work in departments that have more than one unique title / SELECT e.FirstName, e.LastName, d.DepartmentID, Title / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 8, line 149)
> -- Assuming we have a Departments table / -- Find unique d.DepartmentName names that have employees / SELECT DISTINCT d.DepartmentName

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 9, line 169)
> -- Find employees with unique skill combinations (assuming EmployeeSkills table) / WITH EmployeeSkillSets AS ( / SELECT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 10, line 188)
> -- Find distinct e.BaseSalary ranks within each d.DepartmentName / SELECT DISTINCT / DepartmentID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 11, line 208)
> -- Find potential duplicate employees (same name, different IDs) / WITH PotentialDuplicates AS ( / SELECT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 12, line 249)
> -- Comprehensive distinct analysis for management reporting / WITH DistinctAnalysis AS ( / SELECT DISTINCT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 13, line 305)
> -- DISTINCT - simply removes duplicates / SELECT DISTINCT DepartmentID / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 14, line 325)
> -- Use DISTINCT when you only need to eliminate duplicates / SELECT DISTINCT City / FROM Employees e

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 15, line 346)
> -- DISTINCT requires sorting/hashing - can be expensive on large datasets / -- Consider if you really need DISTINCT or if duplicates are acceptable / -- More efficient: Use EXISTS instead of DISTINCT with subqueries

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 16, line 373)
> -- DISTINCT can benefit from appropriate indexes / -- For this query: / SELECT DISTINCT DepartmentID, Title

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 17, line 384)
> -- Instead of DISTINCT in large datasets, consider GROUP BY / -- DISTINCT approach / SELECT DISTINCT DepartmentID

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 18, line 409)
> -- WRONG: Thinking DISTINCT applies to individual columns / -- This gets distinct combinations of DepartmentID and e.FirstName / SELECT DISTINCT DepartmentID, e.FirstName

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 19, line 426)
> -- WRONG: Using DISTINCT when not needed / SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 20, line 438)
> -- Be careful with functions in DISTINCT / SELECT DISTINCT UPPER(e.FirstName) / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 21, line 454)
> -- DISTINCT treats NULL as a distinct value / SELECT DISTINCT MiddleName / FROM Employees e;

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 22, line 473)
> -- Quick data profiling with DISTINCT / SELECT 'DepartmentID' AS ColumnName, COUNT(DISTINCT DepartmentID) AS UniqueValues FROM Employees e / UNION ALL

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 23, line 485)
> -- Find inconsistent data entry / SELECT DISTINCT UPPER(City) AS City, COUNT(*) AS Variations / FROM (

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT.md** (block 24, line 496)
> -- Market analysis: distinct customer segments / SELECT DISTINCT / CASE

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson2_Eliminating_Duplicates_with_DISTINCT_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 1, line 14)
> -- Column aliases / SELECT column_name AS alias_name / SELECT column_name alias_name  -- AS keyword is optional

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 2, line 27)
> -- Using AS keyword (recommended) / SELECT / e.FirstName AS First,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 3, line 51)
> -- Mathematical calculations with descriptive aliases / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 4, line 72)
> -- Simple table alias / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 5, line 93)
> -- Table aliases essential for joins / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 6, line 115)
> -- Self-join requires different aliases for the same table / SELECT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 7, line 137)
> -- Business logic with descriptive aliases / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 8, line 158)
> -- Subquery with table alias / SELECT dept_stats.d.DepartmentName, / dept_stats.EmployeeCount,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 9, line 177)
> -- Advanced scenario with multiple aliases and calculations / SELECT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 10, line 201)
> -- Window functions with meaningful aliases / SELECT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 11, line 219)
> -- Common Table Expression with comprehensive aliases / WITH EmployeePerformanceMetrics AS ( / SELECT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 12, line 268)
> -- Using aliases in pivot scenarios / WITH MonthlySales AS ( / SELECT

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 13, line 301)
> -- Good: Clear, descriptive aliases / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeFullName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 14, line 320)
> -- Good: Consistent naming pattern / SELECT / emp.EmployeeID AS e.EmployeeID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 15, line 335)
> -- Good: Always use table aliases in joins / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 16, line 358)
> -- Good: Short, intuitive aliases / SELECT / emp.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 17, line 377)
> -- Problematic: Using reserved words / SELECT / e.FirstName AS [Order],    -- 'Order' is reserved

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 18, line 394)
> -- Wrong: Trying to use column alias in WHERE clause / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 19, line 422)
> -- Inconsistent: Sometimes using alias, sometimes not / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 20, line 445)
> -- Aliases are cosmetic and don't affect query performance / SELECT / e.EmployeeID AS ID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 21, line 462)
> -- Readable queries are easier to maintain and optimize / SELECT / emp.EmployeeID AS e.EmployeeID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 22, line 478)
> -- Clean, professional report output / SELECT / ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS [Row #],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases.md** (block 23, line 499)
> -- Prepare data for export with clean column names / SELECT / e.EmployeeID AS employee_id,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson3_Using_Column_and_Table_Aliases_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 1, line 16)
> -- Simple CASE / CASE expression / WHEN value1 THEN result1

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 2, line 35)
> -- Simple CASE based on d.DepartmentName ID / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 3, line 67)
> -- Searched CASE for e.BaseSalary categorization / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 4, line 98)
> -- CASE for bonus calculations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 5, line 121)
> -- Complex string formatting with CASE / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 6, line 147)
> -- Date-based business logic / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 7, line 172)
> -- Using CASE in WHERE clause for conditional filtering / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 8, line 202)
> -- CASE in aggregate functions / SELECT / DepartmentID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 9, line 225)
> -- Complex nested CASE logic / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 10, line 274)
> -- Advanced business logic implementation / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 11, line 323)
> -- CASE expressions with analytical functions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 12, line 355)
> -- CASE expressions in join conditions and complex scenarios / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 13, line 393)
> -- Good: Always include ELSE for completeness / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 14, line 415)
> -- Good: Order from most specific to least specific / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 15, line 439)
> -- Good: Consistent return types / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 16, line 460)
> -- For frequently used complex CASE logic, consider computed columns / -- or views instead of repeating the logic / -- Instead of repeating this complex CASE in multiple queries:

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 17, line 481)
> -- Problem: Unexpected NULLs / SELECT / e.FirstName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 18, line 506)
> -- Problem: Overlapping conditions / SELECT / e.BaseSalary,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 19, line 529)
> -- Problem: Mixed return types cause conversion issues / SELECT / CASE

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 20, line 552)
> -- Single query with CASE (generally more efficient) / SELECT / DepartmentID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions.md** (block 21, line 569)
> -- Simple CASE (slightly more efficient for equality comparisons) / CASE DepartmentID / WHEN 1 THEN 'IT'

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Lesson4_Writing_Simple_CASE_Expressions_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 1, line 13)
> SELECT / -- Full name handling middle names properly / e.FirstName +

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 2, line 53)
> SELECT / p.ProjectName AS [Project Name], / p.IsActive AS [Current IsActive],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 3, line 97)
> SELECT d.DepartmentName AS [Department], / d.Location AS [Office Location], / -- Formatted budget

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 4, line 134)
> SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name], / e.JobTitle AS [Position],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 5, line 175)
> SELECT / s.SkillName AS [Skill], / s.SkillCategoryID AS [Category],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 6, line 220)
> WITH DataProfileAnalysis AS ( / -- Employee data analysis / SELECT 'Employees' AS TableName, 'e.FirstName' AS FieldName,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 7, line 279)
> WITH LocationAnalysis AS ( / SELECT DISTINCT / e.City,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 8, line 324)
> SELECT DISTINCT / p.IsActive AS [Project IsActive], / p.Priority AS [Priority Level],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 9, line 366)
> WITH SkillDiversityAnalysis AS ( / SELECT DISTINCT / s.SkillCategoryID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 10, line 428)
> SELECT DISTINCT / d.DepartmentName AS [Department], / e.JobTitle AS [Position Title],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 11, line 479)
> SELECT / -- Executive KPIs with professional terminology / COUNT(emp.EmployeeID) AS [Total Workforce],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 12, line 528)
> SELECT dept.d.DepartmentName AS [Business Unit], / -- Employee lifecycle indicators with HR terminology / COUNT(emp.EmployeeID) AS [Current Headcount],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 13, line 578)
> SELECT / proj.ProjectName AS [Project Title], / proj.ProjectCode AS [Project Identifier],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 14, line 652)
> SELECT / emp.FirstName + ' ' + emp.LastName AS [Employee Name], / emp.Title AS [Current Role],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 15, line 724)
> SELECT dept.d.DepartmentName AS [Cost Center], / dept.CostCenter AS [Accounting Code], / -- Cost center analysis with accounting terminology

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 16, line 801)
> SELECT / emp.FirstName + ' ' + emp.LastName AS [Employee Name], / emp.Title AS [Position],

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 17, line 941)
> -- Key CASE expressions for project risk assessment: / -- 1. Budget variance analysis with escalating risk levels / -- 2. Timeline adherence with milestone tracking

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 18, line 951)
> -- Key CASE expressions for compensation analysis: / -- 1. Market positioning by role, location, and experience / -- 2. Performance-based adjustment calculations

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 19, line 961)
> -- Key CASE expressions for resource allocation: / -- 1. Employee availability based on current workload / -- 2. Skill matching algorithm for project requirements

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 20, line 971)
> -- Key CASE expressions for workforce planning: / -- 1. 9-box grid classification (potential vs performance) / -- 2. Succession planning readiness assessment

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 21, line 987)
> WITH EmployeeMetrics AS ( / SELECT / emp.EmployeeID,

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/Module3_Exercise_Answers.md** (block 22, line 1122)
> -- This would include: / -- 1. Multi-criteria project health scoring / -- 2. Resource optimization algorithms

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/lab-select-queries-advanced.md** (block 1, line 15)
> -- Connect to our TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/lab-select-queries-advanced.md** (block 2, line 34)
> -- Employees table (expanded) / CREATE TABLE Employees ( / EmployeeID INT PRIMARY KEY IDENTITY(1,1),

✅ **tech company/untitled/Module 3 - Writing SELECT Queries/lab-select-queries-advanced.md** (block 3, line 116)
> -- Insert expanded sample data / INSERT INTO Departments (DepartmentName, DepartmentCode, Budget, Location, CostCenter) VALUES / ('Information Technology', 'IT', 750000, 'Building A - Floor 3', 'CC001'),

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables.md** (block 1, line 15)
> -- Connect to our TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables.md** (block 2, line 34)
> -- Companies table (for client management) / CREATE TABLE Companies ( / CompanyID INT PRIMARY KEY IDENTITY(1,1),

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables.md** (block 3, line 156)
> -- Insert enhanced sample data / INSERT INTO Companies (CompanyName, Industry, CompanySize, AnnualRevenue, Country) VALUES / ('TechCorp Solutions', 'Technology', 'Large', 50000000, 'USA'),

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 1, line 10)
> -- Answer 1: Employee and d.DepartmentName Information / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 2, line 26)
> -- Answer 2: Employee Project Assignments / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 3, line 44)
> -- Answer 3: Three-Table Join / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 4, line 68)
> -- Answer 1: High-e.BaseSalary Employees with Projects / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 5, line 89)
> -- Answer 2: Active Projects with Team Members / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 6, line 116)
> -- Answer 1: All Employees with d.DepartmentName Information / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 7, line 133)
> -- Answer 2: All Employees with Project Assignments / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 8, line 154)
> -- Answer 1: All Departments with Employee Count / SELECT d.DepartmentName, / d.DepartmentCode,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 9, line 171)
> -- Answer 2: All Projects with Employee Assignments / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 10, line 195)
> -- Answer 1: Complete Employee-Department Relationship / SELECT / COALESCE(e.FirstName + ' ' + e.LastName, 'No Employee') AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 11, line 220)
> -- Answer 1: Employee-Project Combinations / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 12, line 241)
> -- Answer 2: Department-Project Matrix / SELECT d.DepartmentName, / p.ProjectName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 13, line 261)
> -- Answer 1: Employee-Manager Relationships / SELECT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 14, line 285)
> -- Answer 2: Employee Colleagues / SELECT / e1.e.FirstName + ' ' + e1.e.LastName AS Employee1,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 15, line 306)
> -- Answer 3: Hierarchical Structure / WITH EmployeeHierarchy AS ( / -- Anchor: Top-level managers

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 16, line 350)
> -- Answer 1: Comprehensive Employee Report / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 17, line 379)
> -- Answer 1: Employees Working on High-d.Budget Projects / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 18, line 407)
> -- Answer 2: d.DepartmentName Performance Comparison / SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS EmployeeCount,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 19, line 439)
> -- Answer 1: Skills Gap Analysis / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 20, line 478)
> -- Answer 1: Optimized Employee Project Report / -- Using specific columns and appropriate indexes / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers.md** (block 21, line 503)
> -- Answer 1: EXISTS vs JOIN Comparison / -- Method 1: Using EXISTS (good for checking existence) / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lab_Querying_Multiple_Tables_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 1, line 20)
> SELECT columns / FROM table1 / JOIN table2 ON table1.column = table2.column;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 2, line 36)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           JOIN TYPES VISUAL GUIDE                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 3, line 55)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                               INNER JOIN                                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 4, line 74)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            LEFT OUTER JOIN                                  │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 5, line 94)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           RIGHT OUTER JOIN                                  │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 6, line 114)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            FULL OUTER JOIN                                  │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 7, line 135)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                              CROSS JOIN                                     │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 8, line 157)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                                SELF JOIN                                   │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 9, line 181)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            WHICH JOIN TO USE?                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 10, line 230)
> -- Employees table / CREATE TABLE Employees ( / e.EmployeeID INT PRIMARY KEY,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 11, line 261)
> -- Join employees with their departments / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 12, line 275)
> -- Include all employees, even those without departments / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 13, line 291)
> -- Join three tables: Employees, Departments, and Projects / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 14, line 308)
> -- Count employees by d.DepartmentName / SELECT d.DepartmentName, / d.Location,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 15, line 321)
> -- Find employees in specific departments with certain conditions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 16, line 340)
> -- Comprehensive employee analysis with multiple joins / WITH EmployeeSummary AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 17, line 391)
> -- Find employees who work on the same projects as their managers / SELECT DISTINCT / emp.FirstName + ' ' + emp.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 18, line 411)
> -- Ensure proper indexes on join columns / CREATE INDEX IX_Employees_DepartmentID ON Employees(DepartmentID); / CREATE INDEX IX_EmployeeProjects_EmployeeID ON EmployeeProjects(e.EmployeeID);

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 19, line 424)
> -- SQL Server's query optimizer typically handles join order, / -- but understanding can help with complex queries / -- Generally efficient: Start with most selective table

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 20, line 437)
> -- WRONG: Missing join condition creates Cartesian product / SELECT e.FirstName, d.DepartmentName / FROM Employees e, Departments d;  -- Avoid this syntax

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 21, line 451)
> -- Good: Clear and readable / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 22, line 470)
> -- Good: Explicit join type / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 23, line 483)
> -- Good: Filter in WHERE clause for final results / SELECT e.FirstName, e.LastName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 24, line 498)
> -- Consider NULL behavior in joins / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 25, line 512)
> -- Replace ID with descriptive name / SELECT / o.OrderID,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 26, line 525)
> -- Summarize related data / SELECT / c.CustomerName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 27, line 538)
> -- Self-join for hierarchical data / SELECT / emp.FirstName + ' ' + emp.LastName AS Employee,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 28, line 552)
> -- Handle many-to-many relationships through junction table / SELECT / s.StudentName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 29, line 568)
> -- WRONG: Missing join condition / SELECT * FROM Employees e, Departments; / -- CORRECT: Always specify join relationship

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 30, line 578)
> -- WRONG: Using INNER JOIN when you need all records / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 31, line 592)
> -- WRONG: Ambiguous column name / SELECT e.EmployeeID, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 32, line 608)
> -- Check for duplicate join keys / SELECT DepartmentID, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 33, line 622)
> -- Check for NULL values in join columns / SELECT COUNT(*) AS EmployeesWithoutDepartment / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins.md** (block 34, line 636)
> -- Check execution plan for missing indexes / -- Use SET STATISTICS IO ON to see reads / SET STATISTICS IO ON;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson1_Understanding_Joins_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 1, line 12)
> SELECT columns / FROM table1 / INNER JOIN table2 ON table1.column = table2.column;

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 2, line 24)
> Table A         Table B         Result (A ∩ B) / ┌─────┐        ┌─────┐         ┌─────┐ / │  1  │        │  1  │    →    │  1  │

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 3, line 37)
> -- Join employees with their departments / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 4, line 52)
> -- Professional report with meaningful column names / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 5, line 66)
> -- Find IT d.DepartmentName employees with specific criteria / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 6, line 85)
> -- Join employees, departments, and their current projects / SELECT / e.JobTitle,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 7, line 104)
> -- d.DepartmentName summary with employee counts and average salaries / SELECT d.DepartmentName AS [Department], / d.Location AS [Location],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 8, line 122)
> -- Find employees working on high-priority projects / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 9, line 145)
> -- Advanced filtering across multiple tables / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 10, line 170)
> -- Comprehensive employee performance analysis / WITH ProjectPerformance AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 11, line 244)
> -- Employee ranking within departments / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 12, line 288)
> -- Project profitability analysis / SELECT / p.ProjectName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 13, line 361)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         INNER JOIN EXECUTION FLOW                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 14, line 406)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           INDEX PERFORMANCE IMPACT                         │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 15, line 458)
> -- Create appropriate indexes for common join patterns / CREATE INDEX IX_Employees_DepartmentID ON Employees(d.DepartmentID); / CREATE INDEX IX_EmployeeProjects_EmployeeID ON EmployeeProjects(e.EmployeeID);

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 16, line 472)
> -- Good: Equality join on indexed column / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 17, line 490)
> -- Filter early in the join process / SELECT e.FirstName, e.LastName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 18, line 512)
> -- Orders with order details / SELECT / o.OrderID,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 19, line 529)
> -- Replace codes with descriptions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 20, line 544)
> -- Students and their enrolled courses / SELECT / s.StudentName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 21, line 563)
> -- Good: Clear and concise / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 22, line 576)
> -- Start with the most selective table when possible / SELECT p.ProjectName, e.FirstName, e.LastName / FROM Projects p  -- If fewer projects than employees

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 23, line 586)
> -- Well-formatted multi-table join / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 24, line 608)
> -- PROBLEM: This excludes employees without projects / SELECT e.FirstName, e.LastName, p.ProjectName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 25, line 623)
> -- WRONG: Missing join condition creates Cartesian product / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins.md** (block 26, line 636)
> -- PROBLEM: Double-counting due to multiple related records / SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS EmployeeCount  -- This might be wrong if employees have multiple projects

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 1, line 42)
> -- Looking at employees alone - we see department IDs but not names / SELECT TOP 3 / e.FirstName AS [Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 2, line 53)
> -- Looking at departments alone - we see names but not who works there / SELECT TOP 3 / d.DepartmentID AS [Dept ID],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 3, line 71)
> -- INNER JOIN: Connecting employees to their departments / SELECT TOP 5 / e.FirstName AS [First Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 4, line 91)
> -- Your turn! Get employee names with department names / SELECT TOP 3 / e.FirstName + ' ' + e.LastName AS [Full Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 5, line 107)
> SELECT                              -- 1. Choose what columns to show / e.FirstName,                    -- 2. From employees table (e) / d.DepartmentName                -- 3. From departments table (d)

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 6, line 124)
> -- Connect employees to their job titles and departments / SELECT TOP 5 / e.FirstName AS [Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 7, line 144)
> -- Find all Engineering employees / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 8, line 159)
> -- Find managers and their departments / SELECT / e.FirstName + ' ' + e.LastName AS [Manager Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 9, line 175)
> -- Your solution here: / -- [Try to write this yourself first!] / -- Solution:

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 10, line 200)
> -- Connect employees, departments, AND projects / SELECT TOP 5 / e.FirstName + ' ' + e.LastName AS [Employee],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 11, line 220)
> -- Show employees, their departments, and project budgets / SELECT TOP 3 / e.FirstName AS [Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 12, line 241)
> -- WRONG - Missing ON clause: / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 13, line 256)
> -- WRONG - Using wrong columns: / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 14, line 272)
> -- This query has an error - can you fix it? / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 15, line 301)
> -- Your solution here: / -- [Try to write this yourself first!] / -- Solution:

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 16, line 342)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 17, line 360)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson2_Querying_with_Inner_Joins_Beginner.md** (block 18, line 373)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           OUTER JOINS COMPARISON                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 2, line 33)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                              LEFT OUTER JOIN                               │ / │              SELECT * FROM Employees e LEFT JOIN Departments d             │

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 3, line 65)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                             RIGHT OUTER JOIN                               │ / │              SELECT * FROM Employees e RIGHT JOIN Departments d            │

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 4, line 97)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                             FULL OUTER JOIN                                │ / │              SELECT * FROM Employees e FULL OUTER JOIN Departments d       │

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 5, line 126)
> LEFT JOIN          RIGHT JOIN         FULL OUTER JOIN / ┌─────────┐       ┌─────────┐        ┌─────────────┐ / │ A │ A∩B │       │ A∩B │ B │        │ A │ A∩B │ B │

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 6, line 136)
> -- All employees with their d.DepartmentName info (includes employees without departments) / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 7, line 152)
> -- All departments with their employees (includes departments with no employees) / SELECT d.DepartmentName, / d.Location,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 8, line 168)
> -- Complete view of employees and departments relationship / SELECT / ISNULL(e.FirstName + ' ' + e.LastName, 'No Employee') AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 9, line 190)
> -- Find employees who are NOT assigned to any projects / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 10, line 208)
> -- d.DepartmentName headcount including departments with zero employees / SELECT d.DepartmentName, / d.Location,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 11, line 234)
> -- Comprehensive employee profile with optional data / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 12, line 278)
> -- Comprehensive project resource analysis / WITH ProjectResourceSummary AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 13, line 362)
> -- Data integrity and completeness analysis / SELECT / 'Employee Data Completeness' AS AnalysisType,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 14, line 415)
> -- Executive dashboard with comprehensive metrics / WITH DepartmentMetrics AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 15, line 511)
> -- Good: Explicit NULL handling / SELECT / e.FirstName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 16, line 524)
> -- Provide business-meaningful defaults / SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS EmployeeCount,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 17, line 539)
> -- Use WHERE clauses carefully with outer joins / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 18, line 549)
> -- When you only need to check existence, use EXISTS / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 19, line 567)
> -- Find employees without projects / SELECT e.FirstName, e.LastName, 'No Projects' AS IsActive / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 20, line 582)
> -- Orders with optional shipping information / SELECT / o.OrderID,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 21, line 596)
> -- Employee hierarchy with optional managers / SELECT / e.FirstName + ' ' + e.LastName AS Employee,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 22, line 613)
> -- PROBLEM: Using INNER JOIN when you want all records / SELECT e.FirstName, p.ProjectName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 23, line 629)
> -- PROBLEM: WHERE clause eliminates outer join benefits / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins.md** (block 24, line 644)
> -- PROBLEM: Counting NULLs incorrectly / SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount / FROM Departments d

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson3_Querying_with_Outer_Joins_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 1, line 12)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           CROSS JOIN EXPLAINED                             │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 2, line 39)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         CROSS JOIN GROWTH WARNING                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 3, line 67)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                       WORK SCHEDULE GENERATION                             │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 4, line 100)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           SELF JOIN - HIERARCHY                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 5, line 140)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        SELF JOIN - COMPARISON                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 6, line 182)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                      MULTI-LEVEL HIERARCHY ANALYSIS                        │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 7, line 230)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                     SELF JOIN VS OTHER JOINS                               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 8, line 275)
> -- WARNING: Cross joins can create very large result sets / -- Always consider the impact: / -- Table A (1000 rows) × Table B (1000 rows) = 1,000,000 rows

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 9, line 292)
> -- Index the join columns for better performance / CREATE INDEX IX_Employees_ManagerID ON Employees(ManagerID); / CREATE INDEX IX_Employees_DepartmentID_Salary ON Employees(DepartmentID, e.BaseSalary);

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins.md** (block 10, line 323)
> -- Good: Clear aliases and conditions / SELECT / emp.FirstName AS EmployeeName,

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Lesson4_Querying_with_Cross_Joins_and_Self_Joins_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 1, line 13)
> -- Employee project performance with efficiency calculations / SELECT / e.FirstName + ' ' + e.LastName AS [Employee Name],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 2, line 61)
> -- Comprehensive d.DepartmentName resource analysis / WITH DepartmentMetrics AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 3, line 109)
> -- Skills market value and internal supply analysis / SELECT / s.SkillName AS [Skill],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 4, line 167)
> -- Client-focused project portfolio analysis / SELECT / c.CompanyName AS [Client],

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 5, line 229)
> -- High-value employee identification with multi-factor scoring / WITH EmployeeMetrics AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 6, line 302)
> -- Comprehensive employee integration analysis using LEFT JOINs / WITH EmployeeIntegration AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 7, line 377)
> -- Complete d.DepartmentName analysis including vacant departments / WITH DepartmentAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 8, line 461)
> -- Key elements: LEFT JOIN all projects with optional employee assignments / -- Analyze: Required vs actual staffing, skill coverage, budget allocation / -- Identify: Understaffed projects, skill gaps, timeline risks

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 9, line 469)
> -- Key elements: LEFT JOIN employees with optional skills / -- Analyze: Market demand vs internal supply, certification gaps / -- Calculate: Training ROI, career development pathways

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 10, line 477)
> -- Key elements: Self LEFT JOIN for manager relationships / -- Analyze: Span of control, e.BaseSalary progression, hierarchy depth / -- Identify: Management gaps, succession planning needs

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 11, line 491)
> -- Executive workforce planning dashboard with comprehensive metrics / WITH EmployeeMetrics AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 12, line 591)
> -- Key components: / -- 1. Financial health scoring (budget, timeline, cost overruns) / -- 2. Resource efficiency analysis (team utilization, skills alignment)

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 13, line 607)
> -- Multi-level organizational hierarchy with comprehensive analysis / WITH OrganizationalHierarchy AS ( / SELECT

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 14, line 724)
> -- Key elements: Self-join employees within same d.DepartmentName / -- Compare: BaseSalary equity, experience alignment, skills portfolio / -- Analyze: Performance benchmarking, career progression

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 15, line 732)
> -- Key elements: Self-join through project assignments / -- Identify: Shared project relationships, collaboration patterns / -- Analyze: Skills complementarity, workload distribution

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 16, line 746)
> -- Cross join employees with projects for complete allocation matrix / -- Filter by skills matching and availability constraints / -- Calculate cost-benefit for different scenarios

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 17, line 755)
> -- Cross join employees with skills for development matrix / -- Analyze training pathways and ROI calculations / -- Map certification requirements and timelines

✅ **tech company/untitled/Module 4 - Querying Multiple Tables/Module4_Exercise_Answers.md** (block 18, line 771)
> -- Financial Performance Module / WITH FinancialMetrics AS ( / -- d.DepartmentName budget performance, ROI calculations

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 1, line 12)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 2, line 46)
> -- TODO: Sort all employees by last name alphabetically / -- Expected: Employees listed A to Z by last name / SELECT e.EmployeeID, e.FirstName, e.LastName, e.JobTitle, e.BaseSalary

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 3, line 73)
> -- TODO: Sort employees by company, then by d.DepartmentName within each company / -- Expected: Companies in order, departments alphabetically within each company / SELECT

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 4, line 109)
> -- TODO: Sort products by total inventory value (BaseSalary * UnitsInStock) descending / -- Handle NULL values appropriately / -- TODO: Sort customers by the length of their company name, shortest first

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 5, line 127)
> -- TODO: Find all customers from Germany / -- Expected: Only German customers / -- TODO: Find all products with unit price greater than $20

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 6, line 143)
> -- TODO: Find customers from USA or Canada with 'Sales' in their contact title / -- Expected: North American sales contacts only / -- TODO: Find products that are discontinued OR have less than 10 units in stock

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 7, line 159)
> -- TODO: Find all customers whose company name starts with 'A' and ends with 's' / -- Expected: Company names like "Around the Horn", etc. / -- TODO: Find products from categories 1, 3, or 7 with names containing 'cheese'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 8, line 177)
> -- TODO: Get the top 5 most expensive products / -- Expected: 5 products with highest unit prices / -- TODO: Get the top 10% of customers by alphabetical order

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 9, line 193)
> -- TODO: Get products 11-20 when sorted by product name / -- Expected: Second page of products (10 per page) / -- TODO: Get customers 21-30 when sorted by customer ID

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 10, line 209)
> -- TODO: Create a paging solution for products by category / -- Show page 2 (rows 6-10) of products in category 1, sorted by product name / -- TODO: Implement pagination for customer orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 11, line 227)
> -- TODO: Find all customers who don't have a region specified / -- Expected: Customers with NULL region / -- TODO: Find all products where units in stock is unknown (NULL)

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 12, line 243)
> -- TODO: Calculate total inventory value for all products / -- Treat NULL stock as 0, NULL price as 0 / -- Expected: Sum of (BaseSalary * UnitsInStock) with NULL handling

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 13, line 262)
> -- TODO: Create a product availability report / -- Show product name, current stock, on order, and availability status / -- IsActive: 'In Stock', 'Out of Stock', 'Stock Unknown', 'Discontinued'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 14, line 283)
> -- TODO: Top 10 customers by total order value / -- Calculate total value per customer, sort descending, handle NULLs / -- Show customer name and total order value

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 15, line 302)
> -- TODO: Paginated customer order history / -- Show page 2 (orders 11-20) of all customer orders with customer info / -- Sort by order date descending, 10 orders per page

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 16, line 325)
> -- TODO: Optimize a customer search query / -- Find customers by partial company name match (case-insensitive) / -- Ensure the query can use indexes effectively

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 17, line 346)
> -- TODO: Create a parameterized query that can sort customers by: / -- 1. Company name (A-Z or Z-A) / -- 2. Country then city

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 18, line 357)
> -- TODO: Create a stored procedure for product pagination that returns: / -- 1. The requested page of products / -- 2. Total number of products

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 19, line 369)
> -- TODO: Create a data quality report showing: / -- 1. Percentage of NULL values in each nullable column / -- 2. Tables with the most NULL values

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data.md** (block 20, line 382)
> -- Verify sorting results / SELECT TOP 5 CustomerID, CustomerName / FROM Customers

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 1, line 10)
> -- Answer 1: Sort customers by company name alphabetically / USE Northwind; / GO

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 2, line 28)
> -- Answer 2: Sort products by unit price from highest to lowest / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 3, line 43)
> -- Answer 3: Sort employees by hire date, newest first / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 4, line 60)
> -- Answer 1: Sort customers by country, then by city / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 5, line 75)
> -- Answer 2: Sort products by category, then by unit price / SELECT / p.ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 6, line 90)
> -- Answer 3: Sort orders by customer, then by order date / SELECT / o.OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 7, line 108)
> -- Answer 1: Sort products by total inventory value / SELECT / ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 8, line 122)
> -- Answer 2: Sort customers by company name length / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 9, line 136)
> -- Answer 3: Sort employees by age, oldest first / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 10, line 156)
> -- Answer 1: Find all customers from Germany / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 11, line 172)
> -- Answer 2: Find products with unit price greater than $20 / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 12, line 188)
> -- Answer 3: Find orders placed in 1997 / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 13, line 206)
> -- Answer 1: Find customers from USA or Canada with 'Sales' in contact title / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 14, line 223)
> -- Answer 2: Find discontinued products or products with low stock / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 15, line 244)
> -- Answer 3: Find orders with specific shipping conditions / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 16, line 266)
> -- Answer 1: Top 5 most expensive products / SELECT TOP 5 / ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 17, line 280)
> -- Answer 2: Top 10 customers by number of orders / SELECT TOP 10 / c.CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 18, line 295)
> -- Answer 3: Top 3 categories by average product price / SELECT TOP 3 / c.CategoryName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 19, line 314)
> -- Answer 1: Top 25% of products by price / SELECT TOP 25 PERCENT / ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 20, line 327)
> -- Answer 2: Top 10% of orders by freight cost / SELECT TOP 10 PERCENT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 21, line 344)
> -- Answer 1: Products pagination - Page 2 / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 22, line 360)
> -- Answer 2: Customers pagination with filtering / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 23, line 377)
> -- Answer 3: Orders pagination with complex sorting / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 24, line 398)
> -- Answer 1: Customers without region information / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 25, line 415)
> -- Answer 2: Products without category assignment / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 26, line 431)
> -- Answer 3: Orders with missing shipped dates / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 27, line 450)
> -- Answer 1: Safe inventory value calculation / SELECT / ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 28, line 470)
> -- Answer 2: Order processing time with NULL handling / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 29, line 492)
> -- Answer 1: Aggregation with NULL values / SELECT / 'All Products' AS Category,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 30, line 523)
> -- Answer 2: Three-valued logic demonstration / SELECT / 'Equal to NULL' AS ComparisonType,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 31, line 555)
> -- Answer 1: Complex product search / SELECT / p.ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 32, line 575)
> -- Answer 2: Customer order analysis / SELECT DISTINCT / c.CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 33, line 599)
> -- Answer 1: Quarterly sales analysis / SELECT / MONTH(OrderDate) AS OrderMonth,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 34, line 618)
> -- Answer 2: Shipping performance analysis / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 35, line 639)
> -- Answer 1: Company name pattern analysis / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 36, line 669)
> -- Answer 2: Product name search / SELECT / ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 37, line 700)
> -- Answer 1: Conditional sorting based on product category / SELECT / p.ProductName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 38, line 728)
> -- Answer 2: Custom order status sorting / SELECT / OrderID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers.md** (block 39, line 755)
> -- Answer 1: Optimized customer search / -- First, let's see what indexes exist / SELECT

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lab_Sorting_and_Filtering_Data_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 1, line 9)
> SELECT columns / FROM table / WHERE conditions

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 2, line 23)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           SORT ORDER CONCEPTS                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 3, line 54)
> -- Sort employees by last name (ascending - default) / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 4, line 72)
> -- Sort by d.DepartmentName first, then by e.BaseSalary within d.DepartmentName / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 5, line 96)
> -- Sort by calculated columns using aliases / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 6, line 113)
> -- Sort by calculated expressions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 7, line 128)
> -- Custom sort order using CASE expressions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 8, line 171)
> -- Sort by string manipulations / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 9, line 200)
> -- Advanced employee ranking with multiple business criteria / WITH EmployeeMetrics AS ( / SELECT

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 10, line 265)
> -- Parameterized sorting for flexible reporting / DECLARE @SortColumn NVARCHAR(50) = 'e.BaseSalary'; / DECLARE @SortDirection NVARCHAR(4) = 'DESC';

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 11, line 309)
> -- Sort using ranking and analytical functions / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 12, line 334)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         SORTING PERFORMANCE GUIDE                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 13, line 387)
> -- Create indexes to support common sorting patterns / CREATE INDEX IX_Employees_LastName_FirstName / ON Employees (e.LastName, e.FirstName);

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 14, line 413)
> -- Understanding NULL sorting behavior / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 15, line 445)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           NULL SORTING BEHAVIOR                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 16, line 484)
> -- Executive summary sorting / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 17, line 515)
> -- Complex date sorting / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 18, line 552)
> -- Good: Use indexed columns for sorting / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 19, line 576)
> -- Good: Use meaningful column aliases / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 20, line 610)
> -- Problem: Sorting entire table unnecessarily / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 21, line 624)
> -- Problem: Unnecessary complex sorting / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data.md** (block 22, line 643)
> -- Problem: Mixing data types in sort expressions / SELECT e.FirstName, e.LastName, / CAST(e.EmployeeID AS VARCHAR) AS EmpID

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson1_Sorting_Data_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 1, line 12)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         THREE-VALUED LOGIC SYSTEM                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 2, line 49)
> -- Equal to / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 3, line 74)
> -- Range filtering with BETWEEN (inclusive) / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 4, line 94)
> -- List membership / SELECT e.FirstName, e.LastName, d.DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 5, line 122)
> -- Wildcard patterns / SELECT e.FirstName, e.LastName, WorkEmail / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 6, line 157)
> -- AND operator (all conditions must be true) / SELECT e.FirstName, e.LastName, e.BaseSalary, DepartmentID / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 7, line 181)
> -- IS NULL / IS NOT NULL / SELECT e.FirstName, e.LastName, MiddleName / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 8, line 199)
> -- EXISTS with correlated subquery / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 9, line 234)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           PREDICATE COMBINATIONS                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 10, line 275)
> -- Multi-level filtering with business logic / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 11, line 309)
> -- Filter by calculated values / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 12, line 333)
> -- Filter using correlated subqueries / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 13, line 373)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        SARGABLE PREDICATE GUIDE                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 14, line 417)
> -- Create indexes to support common filtering patterns / CREATE INDEX IX_Employees_Active_Salary / ON Employees (IsActive, e.BaseSalary)

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 15, line 447)
> -- Good: Most selective predicates first / SELECT e.FirstName, e.LastName, Title / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 16, line 467)
> -- Handle NULLs explicitly / SELECT e.FirstName, e.LastName, MiddleName / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 17, line 485)
> -- Implement complex business rules with clear logic / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 18, line 534)
> -- WRONG: NULL comparisons always return UNKNOWN / SELECT * FROM Employees e WHERE MiddleName = NULL;     -- Returns no rows / SELECT * FROM Employees e WHERE MiddleName != NULL;    -- Returns no rows

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 19, line 545)
> -- PROBLEMATIC: NOT IN with potential NULLs / SELECT * FROM Employees e / WHERE DepartmentID NOT IN (

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates.md** (block 20, line 563)
> -- INEFFICIENT: Function on filtered column / SELECT * FROM Employees e / WHERE UPPER(e.LastName) = 'SMITH';

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson2_Filtering_Data_with_Predicates_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 1, line 9)
> -- Basic TOP syntax / SELECT TOP (n) columns / FROM table

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 2, line 24)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            TOP CLAUSE BEHAVIOR                             │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 3, line 64)
> -- Get top 5 highest paid employees / SELECT TOP (5) / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 4, line 84)
> -- Get top 10% of employees by e.BaseSalary / SELECT TOP (10) PERCENT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 5, line 103)
> -- Dynamic TOP using variables / DECLARE @TopCount INT = 10; / DECLARE @TopPercent FLOAT = 15.5;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 6, line 126)
> -- Standard OFFSET-FETCH syntax (SQL Server 2012+) / SELECT columns / FROM table

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 7, line 145)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        OFFSET-FETCH vs TOP Comparison                      │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 8, line 183)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           PAGINATION WITH OFFSET-FETCH                     │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 9, line 219)
> -- Page 1 (first 10 records) / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 10, line 255)
> -- Parameterized pagination function / DECLARE @PageNumber INT = 3;        -- Page to retrieve (1-based) / DECLARE @PageSize INT = 15;         -- Records per page

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 11, line 288)
> -- Complex multi-column sorting with pagination / SELECT / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 12, line 315)
> -- Get page data with total count for pagination controls / WITH EmployeeData AS ( / SELECT

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 13, line 349)
> -- Cursor-based pagination for better performance on large datasets / -- Instead of OFFSET which scans all previous rows / -- Method 1: Using ROW_NUMBER with filtering

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 14, line 383)
> -- Top performers analysis with business rules / WITH EmployeePerformance AS ( / SELECT

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 15, line 431)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         PAGINATION PERFORMANCE GUIDE                       │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 16, line 470)
> -- Complete pagination solution with search / DECLARE @SearchTerm NVARCHAR(100) = 'Manager'; / DECLARE @DepartmentFilter INT = NULL;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 17, line 523)
> -- Top 5 departments by average e.BaseSalary / SELECT TOP (5) / d.DepartmentName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 18, line 548)
> -- Random sampling using TOP with NEWID() / SELECT TOP (100) / e.FirstName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 19, line 575)
> -- Good: Use specific ORDER BY for consistent results / SELECT TOP (10) e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH.md** (block 20, line 592)
> -- Always include a unique column in ORDER BY for deterministic results / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson3_Filtering_Data_with_TOP_and_OFFSET-FETCH_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 1, line 15)
> -- These all evaluate to UNKNOWN (not TRUE or FALSE) / SELECT 1 = NULL;        -- UNKNOWN / SELECT NULL = NULL;     -- UNKNOWN

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 2, line 26)
> -- Correct way to test for NULL / SELECT CustomerID, CompanyName, Region / FROM Customers

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 3, line 45)
> -- WRONG - This will not work as expected / SELECT CustomerID, CompanyName / FROM Customers

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 4, line 60)
> -- Any arithmetic operation with NULL returns NULL / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 5, line 73)
> -- NULL in concatenation makes entire result NULL / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 6, line 92)
> -- ISNULL replaces NULL with specified value / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 7, line 112)
> -- COALESCE returns first non-NULL value / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 8, line 130)
> -- NULLIF returns NULL if two expressions are equal / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 9, line 143)
> SELECT / CustomerID, / CustomerName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 10, line 158)
> -- IIF function for simple conditional logic / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 11, line 172)
> -- Aggregate functions ignore NULL values / SELECT / COUNT(*) AS TotalProducts,           -- Counts all rows

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 12, line 192)
> -- Build complete contact information handling NULLs / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 13, line 213)
> -- Analyze product inventory with NULL handling / SELECT / CategoryID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 14, line 236)
> -- Correct / WHERE Region IS NULL / -- Incorrect

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 15, line 245)
> -- Outer joins may introduce NULLs / SELECT / c.CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 16, line 260)
> -- Always consider NULL in calculations / SELECT / ProductID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 17, line 276)
> -- Be explicit about NULL handling in complex queries / SELECT / CustomerID,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 18, line 296)
> -- Efficient NULL handling in WHERE clauses / SELECT CustomerID, CustomerName / FROM Customers

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 19, line 313)
> -- Problem: NULL makes entire result NULL / SELECT e.FirstName + ' ' + e.LastName AS FullName / FROM Employees e;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 20, line 328)
> -- Problem: This might not return expected results / SELECT CustomerID, CompanyName FROM Customers / WHERE NOT (UnitsInStock > 10);

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values.md** (block 21, line 339)
> -- Understanding what these return / SELECT / COUNT(*) AS AllRows,           -- Includes rows with NULL

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Lesson4_Working_with_Unknown_Values_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 1, line 11)
> SELECT CustomerID, CompanyName, ContactName, Country / FROM Customers / ORDER BY CompanyName ASC;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 2, line 20)
> SELECT ProductName, e.BaseSalary, CategoryID / FROM Products / ORDER BY e.BaseSalary DESC;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 3, line 28)
> SELECT e.EmployeeID, e.FirstName, e.LastName, Title / FROM Employees e / ORDER BY e.LastName, e.FirstName;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 4, line 36)
> SELECT OrderID, CustomerID, OrderDate, ShippedDate / FROM Orders / ORDER BY OrderDate DESC, CustomerID;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 5, line 60)
> SELECT p.ProductName, p.e.BaseSalary / FROM Products p / INNER JOIN Categories c ON p.CategoryID = c.CategoryID

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 6, line 69)
> SELECT e.EmployeeID, e.FirstName, e.LastName, e.HireDate / FROM Employees e / ORDER BY

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 7, line 79)
> SELECT ProductName, e.BaseSalary, Discontinued / FROM Products / ORDER BY

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 8, line 89)
> SELECT CustomerID, CompanyName, Country / FROM Customers / ORDER BY

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 9, line 121)
> -- Without index (table scan + sort) / SELECT OrderID, CustomerID, OrderDate / FROM Orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 10, line 138)
> -- Composite index for multi-column sorting / CREATE INDEX IX_Orders_OrderDate_CustomerID / ON Orders(OrderDate, CustomerID);

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 11, line 151)
> -- Filter first, then sort (more efficient) / SELECT OrderID, CustomerID, OrderDate / FROM Orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 12, line 190)
> SELECT ProductID, ProductName, e.BaseSalary / FROM Products / WHERE e.BaseSalary > 20

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 13, line 199)
> SELECT CustomerID, CompanyName, Country / FROM Customers / WHERE Country = 'Germany' OR Country = 'France'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 14, line 208)
> SELECT OrderID, CustomerID, OrderDate / FROM Orders / WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 15, line 217)
> SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e / WHERE e.FirstName LIKE 'A%'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 16, line 226)
> SELECT ProductID, ProductName / FROM Products / WHERE ProductName LIKE '%chocolate%'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 17, line 259)
> SELECT ProductID, ProductName, e.BaseSalary, Discontinued / FROM Products / WHERE Discontinued = 1 OR e.BaseSalary < 10

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 18, line 268)
> SELECT CustomerID, CompanyName, Country / FROM Customers / WHERE CompanyName LIKE '%Restaurant%' AND Country = 'USA'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 19, line 277)
> -- Method 1: Using BETWEEN / SELECT OrderID, CustomerID, OrderDate / FROM Orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 20, line 293)
> SELECT p.ProductID, p.ProductName, p.e.BaseSalary, c.CategoryName / FROM Products p / INNER JOIN Categories c ON p.CategoryID = c.CategoryID

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 21, line 304)
> SELECT CustomerID, CompanyName, Country / FROM Customers / WHERE Country NOT IN ('Germany', 'France', 'UK')

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 22, line 337)
> SELECT p.ProductID, p.ProductName, c.CategoryName / FROM Products p / INNER JOIN Categories c ON p.CategoryID = c.CategoryID

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 23, line 347)
> SELECT c.CustomerID, c.CustomerName, c.CountryID / FROM Customers c / WHERE EXISTS (

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 24, line 360)
> SELECT p.ProductID, p.ProductName, p.e.BaseSalary / FROM Products p / WHERE NOT EXISTS (

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 25, line 373)
> -- Using ROW_NUMBER() window function / SELECT CategoryID, ProductName, e.BaseSalary / FROM (

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 26, line 413)
> SELECT TOP 5 ProductID, ProductName, e.BaseSalary / FROM Products / ORDER BY e.BaseSalary DESC;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 27, line 421)
> SELECT TOP 10 PERCENT c.CustomerID, c.CustomerName, / SUM(od.e.BaseSalary * od.Quantity * (1 - od.Discount)) as TotalOrderValue / FROM Customers c

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 28, line 433)
> SELECT TOP 1 WITH TIES ProductID, ProductName, e.BaseSalary / FROM Products / ORDER BY e.BaseSalary DESC;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 29, line 441)
> SELECT CustomerID, OrderID, OrderDate / FROM ( / SELECT CustomerID, OrderID, OrderDate,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 30, line 478)
> SELECT ProductID, ProductName, e.BaseSalary / FROM Products / ORDER BY ProductName

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 31, line 488)
> DECLARE @PageNumber INT = 2;  -- Page 2 / DECLARE @PageSize INT = 15; / SELECT CustomerID, CompanyName, Country

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 32, line 501)
> DECLARE @PageNumber INT = 2; / DECLARE @PageSize INT = 10; / SELECT ProductID, ProductName, e.BaseSalary

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 33, line 515)
> -- Using TOP (gets first 10) / SELECT TOP 10 ProductID, ProductName / FROM Products

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 34, line 544)
> OFFSET = (PageNumber - 1) * PageSize / -- Example: Page 3, Size 20 = (3-1) * 20 = 40

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 35, line 555)
> -- TOP performance (efficient) / SELECT TOP 1000 OrderID, CustomerID, OrderDate / FROM Orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 36, line 578)
> SELECT o.OrderID, c.CustomerName, o.OrderDate, / SUM(od.e.BaseSalary * od.Quantity) as OrderTotal / FROM Orders o

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 37, line 592)
> -- Use unique column in ORDER BY for consistency / SELECT OrderID, CustomerID, OrderDate / FROM Orders

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 38, line 629)
> SELECT CustomerID, CompanyName, City, Region, Country / FROM Customers / WHERE Region IS NULL

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 39, line 638)
> SELECT e.EmployeeID, e.FirstName, e.LastName, City, Region / FROM Employees e / WHERE City IS NOT NULL AND Region IS NOT NULL

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 40, line 647)
> SELECT COUNT(*) as CustomersWithNullFax / FROM Customers / WHERE Fax IS NULL;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 41, line 655)
> SELECT / COUNT(*) as TotalRows, / COUNT(Region) as NonNullRegions,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 42, line 690)
> SELECT CustomerID, CompanyName, City, / ISNULL(Region, 'Not Specified') as Region, / Country

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 43, line 700)
> SELECT CustomerID, CompanyName, / COALESCE(Region, City, Country, 'Unknown Location') as Location / FROM Customers

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 44, line 709)
> -- First, let's see the current data / SELECT CustomerID, CompanyName, / Region,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 45, line 721)
> -- Calculate total order value handling potential NULLs / SELECT od.OrderID, od.ProductID, / od.BaseSalary,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 46, line 758)
> -- LEFT JOIN to include customers even if EmployeeID is NULL / SELECT c.CustomerID, c.CustomerName, / ISNULL(e.FirstName + ' ' + e.LastName, 'No Sales Rep') as SalesRep

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 47, line 769)
> SELECT CustomerID, CompanyName, Country, Region, / CASE / WHEN Region IS NULL AND Country = 'USA' THEN 'Unknown State'

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 48, line 782)
> SELECT p.CategoryID, / COUNT(*) as TotalProducts, / COUNT(p.UnitsInStock) as ProductsWithStockInfo,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 49, line 795)
> SELECT CustomerID, CompanyName, Region, PostalCode, Fax / FROM Customers / WHERE Region IS NULL AND PostalCode IS NULL AND Fax IS NULL

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 50, line 826)
> DECLARE @PageNumber INT = 1; / DECLARE @PageSize INT = 20; / WITH CustomerOrderTotals AS (

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 51, line 853)
> SELECT TOP 15 / p.ProductID, p.ProductName, c.CategoryName, / p.UnitsInStock,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 52, line 868)
> WITH CustomerSalesLast6Months AS ( / SELECT c.CustomerID, / ISNULL(c.CustomerName, 'Unknown Customer') as CompanyName,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 53, line 938)
> SELECT CategoryID, ProductName, BaseSalary / FROM ( / SELECT p.CategoryID, p.ProductName, p.BaseSalary,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 54, line 951)
> SELECT ProductID, ProductName, BaseSalary, Discontinued / FROM Products / WHERE Discontinued = 0

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 55, line 962)
> SELECT OrderID, ProductID, / BaseSalary, / Quantity,

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 56, line 974)
> DECLARE @ProductName NVARCHAR(50) = NULL; / DECLARE @MinPrice MONEY = NULL; / DECLARE @MaxPrice MONEY = NULL;

✅ **tech company/untitled/Module 5 - Sorting and Filtering Data/Module5_Exercise_Answers.md** (block 57, line 991)
> SELECT CustomerID, / CompanyName, / ISNULL(Address, 'Address Not Available') as MailingAddress,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 1, line 15)
> -- Connect to the existing TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 2, line 77)
> -- TODO: Create an Employees table with the following requirements: / -- 1. EmployeeID: Auto-incrementing integer, primary key / -- 2. Age: Supports ages 0-150

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 3, line 102)
> -- TODO: Insert the following employee records: / -- 1. John Smith, Age 35, Dept 1001, BaseSalary $75,000, Bonus 15%, Commission 5.25%, 8 years service, Score 87.5 / -- 2. Jane Doe, Age 29, Dept 2050, BaseSalary $92,500.50, Bonus 12.5%, Commission 7.1234%, 5 years service, Score 94.25

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 4, line 122)
> -- TODO: Create a query that calculates: / -- 1. Annual bonus amount (BaseSalary * BonusPercentage) / -- 2. Monthly commission potential (BaseSalary * CommissionRate / 12)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 5, line 141)
> -- TODO: Create a Products table with these requirements: / -- 1. ProductID: Auto-incrementing primary key / -- 2. ProductCode: Fixed 8-character code (format: AB123456)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 6, line 167)
> -- TODO: Add constraints to the Products table: / -- 1. ProductCode must follow pattern: 2 letters + 6 digits / -- 2. ProductName cannot be empty and must be at least 3 characters

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 7, line 197)
> -- TODO: Write queries to demonstrate string functions: / -- 1. Extract the letter prefix and numeric suffix from ProductCode / -- 2. Create a display name combining first 3 chars of category with product name

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 8, line 215)
> -- TODO: Create an Events table with comprehensive date/time handling: / -- 1. EventID: Auto-incrementing primary key / -- 2. EventName: Event title (up to 200 characters)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 9, line 243)
> -- TODO: Insert sample events and implement business logic: / -- 1. Create events in different time zones / -- 2. Calculate event duration in hours and minutes

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 10, line 275)
> -- TODO: Implement complex date/time scenarios: / -- 1. Calculate working days between registration deadline and event / -- 2. Find events that conflict with each other (same day, overlapping times)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 11, line 293)
> -- TODO: Create a comprehensive system that uses all data types appropriately / -- Design tables for: Customers, Orders, OrderItems, Products (extend existing) / -- Include proper relationships, constraints, and business logic

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 12, line 321)
> -- TODO: Implement advanced operations that combine multiple data types: / -- 1. Customer lifetime value calculation / -- 2. Seasonal sales analysis using date functions

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 13, line 339)
> -- TODO: Compare performance of different data type choices: / -- 1. Create identical tables with different numeric precisions / -- 2. Compare storage size of CHAR vs VARCHAR vs NVARCHAR

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 14, line 375)
> -- TODO: Optimize storage for a large-scale scenario: / -- 1. Design a logging table that stores 1 million records per day / -- 2. Choose optimal data types for minimal storage overhead

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 15, line 398)
> -- TODO: Design a complete e-commerce platform with proper data types: / -- Tables needed: Users, Categories, Products, Reviews, Carts, Orders, Payments / -- Consider: International support, currency handling, timestamps, ratings, etc.

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 16, line 411)
> -- TODO: Design tables for a financial application requiring: / -- 1. Exact monetary calculations (no rounding errors) / -- 2. High-precision interest rate storage

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 17, line 427)
> -- TODO: Design a system for collecting IoT sensor data: / -- 1. Device readings every second (timestamp precision) / -- 2. Temperature (-40°C to 85°C, 0.1 degree precision)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 18, line 448)
> -- TODO: Create a robust validation system: / -- 1. WorkEmail format validation using CHECK constraints / -- 2. Phone number format validation (multiple international formats)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 19, line 464)
> -- TODO: Create stored procedures for safe data type conversions: / -- 1. Convert string to numeric with error handling / -- 2. Parse dates from various string formats

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 20, line 482)
> -- CHALLENGE: You've inherited a poorly designed database with wrong data types / -- TODO: Create migration scripts to fix these issues: / -- 1. Ages stored as VARCHAR(50) - convert to appropriate numeric type

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 21, line 518)
> -- CHALLENGE: Optimize a slow-performing query by fixing data type issues / -- TODO: Given this poorly performing query, identify and fix data type problems: / -- Slow query (don't run this as-is, it's intentionally slow):

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 22, line 544)
> -- CHALLENGE: Design a globally distributed application / -- TODO: Create a system that handles: / -- 1. Multiple currencies with proper precision

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 23, line 563)
> -- Verify your solutions with these validation queries / -- 1. Check data type choices / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 24, line 637)
> -- Problem: "Conversion failed when converting..." / -- Solution: Use TRY_CAST or TRY_CONVERT / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 25, line 649)
> -- Problem: CHECK constraint violations / -- Solution: Test constraints incrementally / -- First, check if data would pass constraint

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 26, line 663)
> -- Problem: Excessive storage usage / -- Solution: Analyze column usage and optimize / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types.md** (block 27, line 684)
> -- Quick reference for data type limits / SELECT / 'TINYINT' AS DataType, 0 AS MinValue, 255 AS MaxValue, 1 AS StorageBytes

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 1, line 10)
> -- Answer 1: String concatenation and length analysis / USE Northwind; / GO

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 2, line 39)
> -- Answer 2: Character data validation / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 3, line 71)
> -- Answer 1: WorkEmail domain analysis / -- Note: Northwind doesn't have email fields, so we'll simulate this / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 4, line 102)
> -- Answer 2: Pattern matching and replacement / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 5, line 133)
> -- Answer 1: Price calculations with different precision / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 6, line 160)
> -- Answer 2: Inventory value analysis / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 7, line 195)
> -- Answer 1: Statistical analysis of prices / SELECT / c.CategoryName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 8, line 224)
> -- Answer 2: Financial calculations / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 9, line 255)
> -- Answer 1: Order processing time analysis / SELECT / OrderID,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 10, line 297)
> -- Answer 2: Employee tenure and age analysis / SELECT / e.EmployeeID,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 11, line 339)
> -- Answer 1: Sales reporting by time periods / SELECT / YEAR(OrderDate) AS OrderYear,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 12, line 375)
> -- Answer 2: Date range and period analysis / SELECT / 'Current Month' AS Period,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 13, line 432)
> -- Answer 1: Safe data type conversions / SELECT / ProductName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 14, line 466)
> -- Answer 2: Data validation and conversion errors / SELECT / CustomerID,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 15, line 507)
> -- Answer 1: Multi-step data transformations / WITH ProductAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 16, line 574)
> -- Answer 1: Efficient data type usage / -- Create a temporary analysis table to demonstrate concepts / WITH DataTypeAnalysis AS (

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 17, line 613)
> -- Answer 2: Index-friendly queries / -- Demonstrate SARGABLE vs non-SARGABLE predicates / -- GOOD: Index-friendly queries

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers.md** (block 18, line 675)
> -- Answer 1: Comprehensive data validation / WITH ValidationResults AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lab_Working_with_SQL_Server_2016_Data_Types_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 1, line 15)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    SQL SERVER 2016 DATA TYPE CATEGORIES                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 2, line 53)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           INTEGER DATA TYPES                               │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 3, line 85)
> -- Integer type examples / CREATE TABLE IntegerExamples ( / -- TINYINT: Perfect for small counts, ages, etc.

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 4, line 120)
> -- DECIMAL and NUMERIC (synonymous) / -- DECIMAL(precision, scale) or NUMERIC(precision, scale) / -- precision: total number of digits (1-38)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 5, line 156)
> -- MONEY and SMALLMONEY types / CREATE TABLE MoneyExamples ( / -- MONEY: 8 bytes, 4 decimal places, range ±922,337,203,685,477.5808

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 6, line 187)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                       FLOATING POINT DATA TYPES                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 7, line 221)
> -- Floating point examples and pitfalls / CREATE TABLE FloatingPointExamples ( / ScientificValue FLOAT,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 8, line 269)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                          CHARACTER DATA TYPES                              │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 9, line 318)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         DATE AND TIME DATA TYPES                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 10, line 359)
> -- Binary data types / CREATE TABLE BinaryExamples ( / -- Fixed-length binary data

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 11, line 386)
> -- Special data types examples / CREATE TABLE SpecialTypesExamples ( / -- BIT: Boolean values

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 12, line 434)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        DATA TYPE CONVERSION HIERARCHY                      │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 13, line 480)
> -- Conversion examples / -- Implicit conversions (automatic) / DECLARE @Int INT = 42;

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 14, line 520)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        DATA TYPE SELECTION GUIDE                           │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 15, line 562)
> -- Best practices for data type selection / -- 1. Use appropriate integer sizes / CREATE TABLE BestPracticesExample (

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 16, line 613)
> -- SQL Server 2016 introduced JSON support / CREATE TABLE JSONExample ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 17, line 643)
> -- Always Encrypted (SQL Server 2016+) / -- Note: This requires client-side configuration / -- Create column master key and column encryption key first

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 18, line 662)
> -- Temporal tables track data changes over time / CREATE TABLE EmployeeHistory ( / EmployeeID INT NOT NULL PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 19, line 694)
> -- Storage size comparison / CREATE TABLE StorageComparison ( / ID INT,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types.md** (block 20, line 745)
> -- Common mistakes and their solutions / -- MISTAKE 1: Using VARCHAR(MAX) for everything / -- Problem: Poor performance, excessive storage

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson1_Introducing_SQL_Server_2016_Data_Types_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        CHARACTER DATA TYPE LANDSCAPE                       │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 2, line 48)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                          CHARACTER ENCODING GUIDE                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 3, line 91)
> -- Creating tables with different character types / CREATE TABLE CharacterDataExamples ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 4, line 144)
> -- Understanding string length vs storage / SELECT / FixedChar,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 5, line 176)
> -- Essential string manipulation functions / DECLARE @SampleText VARCHAR(100) = '  Hello World, Welcome to SQL Server!  '; / DECLARE @UnicodeText NVARCHAR(100) = N'Здравствуй мир, 欢迎来到 SQL Server!';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 6, line 218)
> -- Advanced string functions introduced in recent versions / DECLARE @TextList VARCHAR(200) = 'Apple,Banana,Cherry,Date,Elderberry'; / DECLARE @JsonData NVARCHAR(MAX) = N'{"name": "John", "age": 30, "city": "Seattle"}';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 7, line 253)
> -- LIKE operator patterns / SELECT / FirstName,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 8, line 297)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                              COLLATION CONCEPTS                            │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 9, line 331)
> -- Checking current collations / SELECT / SERVERPROPERTY('Collation') AS ServerCollation,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 10, line 400)
> -- Storage comparison demonstration / CREATE TABLE StorageComparison ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 11, line 445)
> -- Effective indexing strategies for character data / CREATE TABLE IndexingExample ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 12, line 503)
> -- Comprehensive character data validation / CREATE TABLE ValidatedCharacterData ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 13, line 582)
> -- Working with large character data efficiently / CREATE TABLE LargeTextData ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 14, line 664)
> -- Modern string aggregation (SQL Server 2017+) / -- Sample data for aggregation examples / CREATE TABLE EmployeeDepartments (

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 15, line 742)
> -- Complex text processing scenarios / CREATE TABLE TextProcessingExamples ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data.md** (block 16, line 828)
> -- Common mistakes and their solutions / -- PITFALL 1: Concatenation with NULL values / DECLARE @FirstName VARCHAR(50) = 'John';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson2_Working_with_Character_Data_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                    SQL SERVER 2016 DATE/TIME DATA TYPES                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 2, line 52)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                        PRECISION AND STORAGE BREAKDOWN                     │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 3, line 84)
> -- Creating a comprehensive date/time example table / CREATE TABLE DateTimeExamples ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 4, line 136)
> -- SQL Server date/time functions comparison / SELECT / -- Legacy functions

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 5, line 165)
> -- Comprehensive date arithmetic examples / DECLARE @StartDate DATE = '2024-01-01'; / DECLARE @EndDate DATE = '2024-12-31';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 6, line 195)
> -- Complex date calculation scenarios / WITH DateCalculations AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 7, line 271)
> -- Comprehensive date formatting examples / DECLARE @SampleDate DATETIME2 = '2024-03-15 14:30:25.123'; / DECLARE @SampleDateOffset DATETIMEOFFSET = '2024-03-15 14:30:25.123 -08:00';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 8, line 310)
> -- String to date conversion examples / DECLARE @StringDates TABLE ( / DateString VARCHAR(50),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 9, line 368)
> -- Comprehensive timezone examples / CREATE TABLE TimezoneExamples ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 10, line 437)
> -- Advanced business date calculations / CREATE TABLE BusinessDateExamples ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 11, line 545)
> -- Advanced date range and windowing functions / WITH DateRangeAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 12, line 627)
> -- Effective indexing strategies for date columns / CREATE TABLE DatePerformanceExample ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 13, line 687)
> -- Storage comparison and optimization / CREATE TABLE DateStorageComparison ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 14, line 743)
> -- Common date/time pitfalls and solutions / -- PITFALL 1: Implicit conversion and precision loss / DECLARE @DateString VARCHAR(20) = '2024-01-15 14:30:25.123456';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data.md** (block 15, line 815)
> -- Date/Time best practices compilation / -- 1. Use appropriate data types / CREATE TABLE BestPracticesExample (

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Lesson3_Working_with_Date_and_Time_Data_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 1, line 11)
> CREATE TABLE Employees_DataTypes ( / EmployeeID INT IDENTITY(1,1) PRIMARY KEY, / FirstName NVARCHAR(50) NOT NULL,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 2, line 25)
> -- Create test table / CREATE TABLE StorageComparison ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 3, line 50)
> -- Create table with different DECIMAL configurations / CREATE TABLE DecimalExamples ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 4, line 69)
> -- Create table with different integer types / CREATE TABLE IntegerRanges ( / TinyIntCol TINYINT,      -- 0 to 255

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 5, line 117)
> CREATE TABLE DataTypeExamples ( / -- Exact numeric types / TinyIntExample TINYINT,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 6, line 156)
> -- Implicit conversion examples / SELECT / 123 + 45.67 as IntPlusDecimal,        -- INT converted to DECIMAL

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 7, line 166)
> -- CAST examples / SELECT / CAST(123.456 AS INT) as CastToInt,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 8, line 182)
> -- Data type precedence demonstration / SELECT / SQL_VARIANT_PROPERTY(123 + 45.67, 'BaseType') as ResultType1,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 9, line 221)
> -- Original bad design / CREATE TABLE BadExample ( / ID NVARCHAR(100),     -- Should be INT IDENTITY

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 10, line 243)
> -- Insert sample bad data / INSERT INTO BadExample VALUES / ('1', '25', '50000.00', '2020-01-15', 'True'),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 11, line 279)
> -- Calculate storage requirements / WITH StorageCalculation AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 12, line 309)
> -- Performance test: searching in bad design / SELECT COUNT(*) FROM BadExample WHERE Age = '25'; / -- Performance test: searching in good design

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 13, line 353)
> -- Create comparison table / CREATE TABLE StringComparison ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 14, line 383)
> CREATE TABLE SpaceTest ( / CharCol CHAR(10), / VarcharCol VARCHAR(10)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 15, line 410)
> CREATE TABLE StorageTest ( / SmallVarchar VARCHAR(100), / LargeVarchar VARCHAR(8000),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 16, line 431)
> -- VARCHAR(8000) - stored in-row / CREATE TABLE RegularVarchar ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 17, line 483)
> -- Create test data / DECLARE @TestString NVARCHAR(100) = '  Hello World!  '; / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 18, line 505)
> -- Sample customer data with inconsistent formatting / CREATE TABLE #CompanyNames ( / CustomerID INT,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 19, line 531)
> -- Phone number formatting function / CREATE FUNCTION FormatPhoneNumber(@PhoneNumber NVARCHAR(20)) / RETURNS NVARCHAR(20)

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 20, line 573)
> -- Different concatenation approaches / DECLARE @FirstName NVARCHAR(50) = 'John'; / DECLARE @LastName NVARCHAR(50) = 'Smith';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 21, line 625)
> -- Create tables with different collations / CREATE TABLE CaseSensitiveTest ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 22, line 647)
> -- Create tables with different collations / CREATE TABLE Table1 (ID INT, Name VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS); / CREATE TABLE Table2 (ID INT, Name VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CS_AS);

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 23, line 665)
> -- Demonstrate different sorting with COLLATE / CREATE TABLE InternationalNames ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 24, line 689)
> -- Demonstrate Unicode support / CREATE TABLE UnicodeTest ( / ID INT IDENTITY(1,1),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 25, line 741)
> CREATE TABLE DateTimeExamples ( / ID INT IDENTITY(1,1), / DateExample DATE,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 26, line 768)
> -- Storage comparison / SELECT / 'DATE' as DataType, 3 as StorageBytes, 'Day precision' as Precision

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 27, line 788)
> -- Valid ranges for date/time types / SELECT / 'DATE' as DataType,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 28, line 808)
> -- DATETIMEOFFSET examples / DECLARE @UTCTime DATETIMEOFFSET = '2023-12-25 12:00:00.000 +00:00'; / DECLARE @EasternTime DATETIMEOFFSET = '2023-12-25 07:00:00.000 -05:00';

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 29, line 855)
> -- Current date/time functions / SELECT / GETDATE() as GetDate,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 30, line 880)
> -- Age calculation / DECLARE @BirthDate DATE = '1990-05-15'; / DECLARE @CurrentDate DATE = GETDATE();

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 31, line 925)
> -- Date format conversions / DECLARE @TestDate DATETIME = GETDATE(); / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 32, line 946)
> -- Year-over-year comparison / WITH SalesByYear AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 33, line 1001)
> -- Create calendar table / CREATE TABLE CalendarTable ( / DateKey INT PRIMARY KEY,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 34, line 1068)
> -- Last business day of each month / WITH MonthEnds AS ( / SELECT DISTINCT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 35, line 1114)
> -- Safe date parsing function / CREATE FUNCTION dbo.SafeDateParse(@DateString VARCHAR(50)) / RETURNS DATE

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 36, line 1156)
> -- Optimized date range query / -- Bad: WHERE YEAR(OrderDate) = 2023 / -- Good: Use date ranges

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 37, line 1259)
> -- Analyze data type usage and identify optimization opportunities / WITH DataTypeAnalysis AS ( / SELECT

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 38, line 1295)
> CREATE FUNCTION dbo.SafeStringToDate(@InputString VARCHAR(50), @DefaultValue DATE = NULL) / RETURNS DATE / AS

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 39, line 1333)
> CREATE TABLE ProductReviews ( / ReviewID INT IDENTITY(1,1) PRIMARY KEY, / ProductID INT NOT NULL,

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 40, line 1376)
> -- Create test tables / CREATE TABLE BadDataTypes ( / ID NVARCHAR(100),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercise_Answers.md** (block 41, line 1424)
> CREATE FUNCTION dbo.ValidateUserRegistration( / @WorkEmail NVARCHAR(255), / @FirstName NVARCHAR(50),

✅ **tech company/untitled/Module 6 - Working with SQL Server 2016 Data Types/Module6_Exercises.md** (block 1, line 64)
> CREATE TABLE BadExample ( / ID NVARCHAR(100), / Age NVARCHAR(10),

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 1, line 26)
> -- Connect to our mature TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 2, line 56)
> -- Add new business entities for TechCorp's expansion / -- 1. Client Contacts table - Track multiple contacts per client company / CREATE TABLE ClientContacts (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 3, line 174)
> -- TODO: Create a stored procedure that performs bulk customer registration / -- Requirements: / -- 1. Accept a table-valued parameter with customer data

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 4, line 236)
> -- TODO: Create a product pricing system with the following requirements: / -- 1. Products can have multiple price tiers based on quantity / -- 2. Prices can vary by customer type and geographic region

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 5, line 328)
> -- TODO: Create a comprehensive price update system / -- Requirements: / -- 1. Update product prices based on various business rules

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 6, line 406)
> -- TODO: Implement customer data synchronization system / -- Requirements: / -- 1. Update customer information from external data sources

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 7, line 488)
> -- TODO: Implement sophisticated inventory management system / -- Requirements: / -- 1. Automatic reorder point calculations based on sales velocity

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 8, line 583)
> -- TODO: Create a comprehensive data archival system / -- Requirements: / -- 1. Implement soft delete functionality

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 9, line 705)
> -- TODO: Implement comprehensive data cleanup procedures / -- Requirements: / -- 1. Remove orphaned records

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 10, line 815)
> -- TODO: Create a comprehensive audit system using multiple automatic value generation techniques / -- Requirements: / -- 1. Use temporal tables for automatic history tracking

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 11, line 890)
> -- TODO: Create a complete document management system / -- Requirements: / -- 1. Use GUIDs for document identification

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 12, line 951)
> -- TODO: Create a complete order processing system that integrates all DML concepts / -- Requirements: / -- 1. Order placement with inventory checking and automatic updates

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 13, line 1108)
> -- TODO: Create comprehensive reporting system / -- Requirements: / -- 1. Real-time sales analytics with automatic updates

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 14, line 1148)
> -- CHALLENGE: Design and implement a multi-tenant system / -- Requirements: / -- 1. Support multiple organizations in single database

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 15, line 1165)
> -- CHALLENGE: Implement distributed transaction patterns / -- Requirements: / -- 1. Coordinate transactions across multiple related systems

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 16, line 1182)
> -- CHALLENGE: Create real-time data synchronization system / -- Requirements: / -- 1. Synchronize data changes across multiple databases

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 17, line 1201)
> -- TODO: Analyze and optimize DML operations for performance / -- Requirements: / -- 1. Create performance baseline measurements

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 18, line 1242)
> -- Create comprehensive testing framework for DML operations / -- Test results table / CREATE TABLE TestResults (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 19, line 1350)
> -- Monitor deadlocks / SELECT / session_id,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 20, line 1365)
> -- Check IDENTITY current value / DBCC CHECKIDENT('TableName', NORESEED); / -- Reset IDENTITY to proper value

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 21, line 1377)
> -- Monitor DML performance / SET STATISTICS IO ON; / SET STATISTICS TIME ON;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data.md** (block 22, line 1391)
> -- Identify constraint violations before they occur / -- Check foreign key constraints / SELECT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 1, line 10)
> -- Answer 1: Insert single record with all columns / USE Northwind; / GO

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 2, line 49)
> -- Answer 2: Insert with default and NULL values / -- First, let's create a test table to demonstrate defaults / CREATE TABLE TestProducts (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 3, line 82)
> -- Answer 3: Multiple record insert / -- Insert multiple categories (example data) / INSERT INTO Categories (CategoryName, Description)

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 4, line 120)
> -- Answer 1: Copy data from existing table / -- Create a backup table for discontinued products / CREATE TABLE DiscontinuedProducts (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 5, line 172)
> -- Answer 2: Aggregate data insertion / -- Create a summary table for category statistics / CREATE TABLE CategorySummary (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 6, line 223)
> -- Answer 1: INSERT with IDENTITY columns / -- Create a test table with IDENTITY / CREATE TABLE TestEmployees (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 7, line 271)
> -- Answer 2: Conditional INSERT / -- Create a staging table for demonstration / CREATE TABLE StagingCustomers (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 8, line 334)
> -- Answer 1: Update single record / -- First, let's see the current values / SELECT ProductID, ProductName, BaseSalary, UnitsInStock

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 9, line 367)
> -- Answer 2: Update multiple records with conditions / -- First, let's see current prices for beverages / SELECT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 10, line 406)
> -- Answer 3: Update with calculated values / -- Create a more sophisticated update based on order history / UPDATE p

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 11, line 461)
> -- Answer 1: Delete specific records / -- First, identify products to be deleted / SELECT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 12, line 497)
> -- Answer 2: Conditional DELETE with subquery / -- First, let's see which customers have never ordered / SELECT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 13, line 543)
> -- Answer 1: MERGE operation simulation / -- Create a staging table for product updates / CREATE TABLE ProductUpdates (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 14, line 623)
> -- Answer 2: Transaction-based DML operations / -- Simulate order processing with inventory updates / BEGIN TRANSACTION OrderProcessing;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 15, line 708)
> -- Answer 1: Working with IDENTITY properties / -- Create a test table with IDENTITY / CREATE TABLE InventoryLog (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 16, line 772)
> -- Answer 2: Resetting and managing IDENTITY values / -- Create test table / CREATE TABLE TestCounter (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 17, line 828)
> -- Answer 1: Working with DEFAULT constraints / -- Create comprehensive table with defaults / CREATE TABLE CustomerOrders (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 18, line 899)
> -- Answer 2: Computed columns / -- Create table with computed columns / CREATE TABLE OrderDetails (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 19, line 989)
> -- Answer 1: Using SEQUENCE objects / -- Create different types of sequences / CREATE SEQUENCE InvoiceNumberSeq

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers.md** (block 20, line 1069)
> -- Answer 2: Custom auto-generation using triggers / -- Create table for custom ID generation / CREATE TABLE Products_Custom (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Answers_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lab_Using_DML_to_Modify_Data_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           INSERT STATEMENT SYNTAX                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 2, line 52)
> -- Create sample tables for INSERT demonstrations / CREATE TABLE Employees ( / e.EmployeeID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 3, line 101)
> -- Basic INSERT with all columns specified / INSERT INTO Departments (d.DepartmentName, Location, d.Budget) / VALUES ('Information Technology', 'Building A, Floor 3', 500000.00);

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 4, line 134)
> -- Multiple VALUES clauses (SQL Server 2008+) / INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, ManagerID) / VALUES

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 5, line 159)
> -- INSERT with calculated values / INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, e.HireDate) / VALUES

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 6, line 192)
> -- Create a table to hold employee backup data / CREATE TABLE EmployeeBackup ( / BackupID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 7, line 248)
> -- INSERT...SELECT with WHERE clause and complex logic / CREATE TABLE HighPerformers ( / PerformerID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 8, line 329)
> -- INSERT with OUTPUT to capture inserted values / DECLARE @InsertedEmployees TABLE ( / e.EmployeeID INT,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 9, line 377)
> -- INSERT...SELECT with OUTPUT / CREATE TABLE ProjectAssignments ( / AssignmentID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 10, line 429)
> -- Demonstrate constraint violations and error handling / BEGIN TRY / -- This will succeed

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 11, line 472)
> -- Validate data before INSERT / CREATE PROCEDURE InsertEmployeeWithValidation / @e.FirstName NVARCHAR(50),

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 12, line 547)
> -- Efficient bulk INSERT strategies / CREATE TABLE BulkInsertDemo ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 13, line 601)
> -- Demonstrate performance optimization techniques / -- 1. Batch size optimization / CREATE PROCEDURE OptimizedBulkInsert

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 14, line 683)
> -- Complex INSERT using CTEs for data transformation / CREATE TABLE EmployeeHierarchy ( / e.EmployeeID INT,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 15, line 743)
> -- Create performance rankings table / CREATE TABLE EmployeePerformanceRanking ( / RankingID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 16, line 807)
> -- Best practices demonstration / -- 1. Always specify column list (maintainable and safe) / -- GOOD

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables.md** (block 17, line 866)
> -- Common mistakes and how to avoid them / -- PITFALL 1: Not handling NULL values properly / -- Problem: Assuming NOT NULL columns will auto-populate

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson1_Adding_Data_to_Tables_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           UPDATE STATEMENT SYNTAX                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 2, line 66)
> -- Use the tables from Lesson 1 and add some test data for modification examples / -- First, let's ensure we have sufficient test data / -- Add more employees for UPDATE examples

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 3, line 123)
> -- Basic single column update / UPDATE Employees / SET ModifiedDate = SYSDATETIME()

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 4, line 174)
> -- Update based on date ranges / UPDATE Employees / SET e.BaseSalary = e.BaseSalary * 1.02  -- 2% cost of living adjustment

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 5, line 223)
> -- Update employee salaries based on d.DepartmentName budget / UPDATE e / SET

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 6, line 261)
> -- Complex update involving multiple tables / UPDATE e / SET

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 7, line 328)
> -- Create audit table for tracking changes / CREATE TABLE EmployeeAudit ( / AuditID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 8, line 385)
> -- UPDATE with OUTPUT to multiple destinations / DECLARE @IsActiveChanges TABLE ( / e.EmployeeID INT,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 9, line 442)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                           DELETE STATEMENT SYNTAX                          │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 10, line 491)
> -- Create a test table for DELETE demonstrations / CREATE TABLE EmployeeTemp AS / SELECT * FROM Employees e;

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 11, line 553)
> -- Delete inactive test employees / DELETE FROM EmployeeTemp / WHERE IsActive = 0 AND WorkEmail LIKE '%test%';

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 12, line 580)
> -- Delete employees who are not assigned to any projects / DELETE FROM EmployeeTemp / WHERE e.EmployeeID NOT IN (

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 13, line 621)
> -- Create sample data for JOIN DELETE examples / CREATE TABLE InactiveEmployeeCleanup ( / e.EmployeeID INT,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 14, line 672)
> -- Complex deletion scenario: Remove employees who meet multiple criteria / DELETE e / FROM EmployeeTemp e

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 15, line 696)
> -- Create comprehensive audit table / CREATE TABLE DeletionAudit ( / AuditID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 16, line 766)
> -- Add soft delete columns to main table / ALTER TABLE Employees / ADD IsDeleted BIT DEFAULT 0,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 17, line 883)
> -- Efficient batch deletion for large datasets / CREATE PROCEDURE BatchDeleteInactiveEmployees / @BatchSize INT = 1000,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 18, line 958)
> -- Analyze index usage for UPDATE/DELETE operations / -- Check existing indexes / SELECT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 19, line 1008)
> -- Comprehensive UPDATE/DELETE error handling procedure / CREATE PROCEDURE SafeBulkEmployeeUpdate / @d.DepartmentID INT,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data.md** (block 20, line 1120)
> -- Best practices demonstration and checklist / -- ✓ 1. ALWAYS test with SELECT first / -- GOOD: Test the WHERE clause

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson2_Modifying_and_Removing_Data_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 1, line 9)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                            IDENTITY COLUMN CONCEPTS                         │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 2, line 49)
> -- Create table with IDENTITY column / CREATE TABLE Orders ( / OrderID INT IDENTITY(1,1) PRIMARY KEY,  -- Start at 1, increment by 1

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 3, line 96)
> -- Insert more data to show increment behavior / INSERT INTO InvoiceNumbers (Amount, CustomerRef) / VALUES

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 4, line 141)
> -- Create related tables with IDENTITY columns / CREATE TABLE OrderDetails ( / OrderDetailID BIGINT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 5, line 196)
> ┌─────────────────────────────────────────────────────────────────────────────┐ / │                         SEQUENCE vs IDENTITY COMPARISON                    │ / ├─────────────────────────────────────────────────────────────────────────────┤

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 6, line 229)
> -- Basic SEQUENCE creation / CREATE SEQUENCE OrderNumberSequence / AS INT

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 7, line 324)
> -- Query SEQUENCE information / SELECT / name AS SequenceName,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 8, line 379)
> -- Create table with various default constraints / CREATE TABLE CustomerProfiles ( / ProfileID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 9, line 449)
> -- Function-based defaults / CREATE FUNCTION dbo.GenerateCustomerCode(@CustomerID INT) / RETURNS NVARCHAR(20)

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 10, line 527)
> -- Query existing default constraints / SELECT / t.name AS TableName,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 11, line 569)
> -- Create table with various computed column types / CREATE TABLE SalesTransactions ( / TransactionID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 12, line 639)
> -- Create user-defined functions for computed columns / CREATE FUNCTION dbo.CalculateShippingCost( / @Weight DECIMAL(8,2),

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 13, line 735)
> -- Create indexes on persisted computed columns / CREATE INDEX IX_SalesTransactions_TransactionCategory / ON SalesTransactions (TransactionCategory);

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 14, line 786)
> -- Create system-versioned temporal table / CREATE TABLE EmployeeHistory ( / EmployeeID INT NOT NULL PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 15, line 887)
> -- Create table with GUID columns / CREATE TABLE DocumentStorage ( / DocumentID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 16, line 967)
> -- Best practices demonstration table / CREATE TABLE BestPracticesDemo ( / -- Use IDENTITY for simple auto-incrementing primary keys

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values.md** (block 17, line 1045)
> -- Common pitfalls and their solutions / -- PITFALL 1: Assuming IDENTITY values are always sequential / -- Problem: Gaps can occur due to rollbacks, failed inserts, server restarts

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 7 - Using DML to Modify Data/Lesson3_Generating_Automatic_Column_Values_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions.md** (block 1, line 34)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions.md** (block 2, line 371)
> -- Lab 8.5.2: Predictive Business Analytics Integration / -- Business scenario: Advanced analytics for strategic planning using all function types / WITH HistoricalTrends AS (

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions.md** (block 3, line 639)
> -- Lab 8.5.3: Master Data Quality Management System / -- Business scenario: Complete data validation, cleaning, and quality reporting / WITH DataQualityAssessment AS (

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Advanced.md** (block 1, line 11)
> -- Complex scenario requiring optimization / USE TechCorpDB; / -- Performance monitoring setup

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Advanced.md** (block 2, line 40)
> -- Your enterprise solution: / -- [Space for complex implementation]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Advanced.md** (block 3, line 48)
> -- Advanced integration exercise / -- [Multi-concept exercise]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Beginner.md** (block 1, line 19)
> -- Always start by connecting to our database / USE TechCorpDB;

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Beginner.md** (block 2, line 25)
> -- Your first practice query / -- [Exercise based on lab topic] / SELECT 'Practice makes perfect!' AS LearningMessage;

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Beginner.md** (block 3, line 38)
> -- Practice exercise 2 / -- [Progressive exercise]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lab_Using_Built-in_Functions_Beginner.md** (block 4, line 50)
> -- Your solution here: / -- [Space for student to write their answer]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 1, line 75)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 2, line 132)
> -- Lab 8.1.3: Substring and Character Position Functions / -- Business scenario: Analyze client email domains for communication strategy / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 3, line 207)
> -- Lab 8.1.5: Advanced String Concatenation and Formatting / -- Business scenario: Generate formatted company profiles for proposals / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 4, line 273)
> -- Lab 8.2.1: Current Date/Time Functions / -- Business scenario: Real-time dashboard with current information / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 5, line 350)
> -- Lab 8.2.3: Project Timeline Analysis / -- Business scenario: Analyze project performance, delays, and resource planning / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 6, line 456)
> -- Lab 8.3.1: Project Profitability Analysis / -- Business scenario: Calculate profit margins, ROI, and financial performance / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions.md** (block 7, line 555)
> -- Lab 8.3.3: Compound Growth and ROI Analysis / -- Business scenario: Calculate compound annual growth rate (CAGR) and investment returns / WITH CompanyGrowth AS (

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson1_Writing_Queries_with_Built-In_Functions_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions.md** (block 1, line 31)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions.md** (block 2, line 128)
> -- Lab 8.2.2: FORMAT Function and Advanced Conversions / -- Business scenario: Create executive reports with proper formatting / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions.md** (block 3, line 292)
> -- Lab 8.2.4: System Information Functions / -- Business scenario: Generate database documentation and health reports / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions.md** (block 4, line 456)
> -- Lab 8.2.7: Performance and Security Analysis / -- Business scenario: Comprehensive system monitoring for TechCorp operations / -- Current activity and performance

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson2_Conversion_and_System_Functions_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions.md** (block 1, line 46)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions.md** (block 2, line 221)
> -- Lab 8.3.3: Nested CASE - Advanced Commission Calculation System / -- Business scenario: Complex commission structure for sales team / WITH SalesMetrics AS (

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions.md** (block 3, line 396)
> -- Lab 8.3.4: IIF Function - Quick Business Decisions / -- Business scenario: Streamlined conditional logic for operational efficiency / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions.md** (block 4, line 506)
> -- Lab 8.3.6: CHOOSE Function - Dynamic Business Intelligence / -- Business scenario: Smart categorization and dynamic reporting / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson3_Using_Logical_Functions_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL.md** (block 1, line 52)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL.md** (block 2, line 206)
> -- Lab 8.4.3: ISNULL in Business Intelligence Dashboard / -- Business scenario: Executive dashboard that never breaks due to missing data / -- Monthly Revenue Report with NULL Protection

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL.md** (block 3, line 354)
> -- Lab 8.4.5: NULLIF - Data Cleaning and Standardization / -- Business scenario: Clean imported data with placeholder values / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL.md** (block 4, line 472)
> -- Lab 8.4.7: COALESCE - Advanced Data Integration / -- Business scenario: Consolidate employee data from multiple systems / SELECT

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL.md** (block 5, line 705)
> -- Lab 8.4.9: Data Quality Audit Reports / -- Business scenario: Comprehensive data quality assessment across all systems / -- Employee Data Quality Report

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Advanced.md** (block 1, line 20)
> -- Advanced example with performance considerations / USE TechCorpDB; / -- Set performance monitoring

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Advanced.md** (block 2, line 33)
> -- Production-ready implementation with error handling / BEGIN TRY / -- Advanced implementation

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Advanced.md** (block 3, line 53)
> -- Advanced performance analysis / -- [Performance-focused examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Advanced.md** (block 4, line 61)
> -- Enterprise-level implementation patterns / -- [Real-world, production-ready examples]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Beginner.md** (block 1, line 28)
> -- Step 1: Use our database / USE TechCorpDB; / -- Step 2: Simple example

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Beginner.md** (block 2, line 46)
> -- Try this yourself / -- [Another basic example]

✅ **tech company/untitled/Module 8 - Using Built-In Functions/Lesson4_Using_Functions_to_Work_with_NULL_Beginner.md** (block 3, line 59)
> -- A bit more complex but still beginner-friendly / -- [Progressive example]

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 1, line 38)
> -- Connect to the database first / USE TechCorpDB; / -- Exercise 1.1a: How many employees work at TechCorp?

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 2, line 65)
> -- Challenge 1.2a: Count how many different job levels exist / -- Hint: Use COUNT(*) and the Employees table, look at JobLevel column / SELECT COUNT(DISTINCT JobLevel) AS NumberOfJobLevels

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 3, line 84)
> -- Exercise 2.1a: What's the total e.BaseSalary expense for all employees? / SELECT SUM(e.BaseSalary) AS TotalPayroll / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 4, line 106)
> -- Exercise 2.2a: What's the highest and lowest e.BaseSalary? / SELECT / MAX(e.BaseSalary) AS HighestBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 5, line 124)
> -- Exercise 2.3a: Complete employee summary / SELECT / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 6, line 152)
> -- Exercise 3.1a: How many employees are in each department? / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 7, line 179)
> -- Exercise 4.1a: Show only departments with more than 2 employees / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 8, line 206)
> -- Question 5.1a: "Which departments have both many employees AND high costs?" / -- (More than 2 employees AND total salaries over $150,000) / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating.md** (block 9, line 230)
> -- Challenge 6.3: "Create a comprehensive business overview" / -- This query combines multiple concepts to create a business dashboard / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Advanced.md** (block 1, line 34)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Advanced.md** (block 2, line 442)
> -- Lab 9.4.2: Predictive Analytics and Forecasting System / -- Business scenario: Advanced analytics for strategic planning and forecasting / WITH HistoricalPerformance AS (

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 1, line 38)
> -- Connect to the database first / USE TechCorpDB; / -- Exercise 1.1a: How many employees work at TechCorp?

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 2, line 65)
> -- Challenge 1.2a: Count how many different job levels exist / -- Hint: Use COUNT(*) and the Employees table, look at JobLevel column / SELECT COUNT(DISTINCT JobLevel) AS NumberOfJobLevels

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 3, line 84)
> -- Exercise 2.1a: What's the total e.BaseSalary expense for all employees? / SELECT SUM(e.BaseSalary) AS TotalPayroll / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 4, line 106)
> -- Exercise 2.2a: What's the highest and lowest e.BaseSalary? / SELECT / MAX(e.BaseSalary) AS HighestBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 5, line 124)
> -- Exercise 2.3a: Complete employee summary / SELECT / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 6, line 152)
> -- Exercise 3.1a: How many employees are in each department? / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 7, line 179)
> -- Exercise 4.1a: Show only departments with more than 2 employees / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 8, line 206)
> -- Question 5.1a: "Which departments have both many employees AND high costs?" / -- (More than 2 employees AND total salaries over $150,000) / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lab_Grouping_and_Aggregating_Beginner.md** (block 9, line 230)
> -- Challenge 6.3: "Create a comprehensive business overview" / -- This query combines multiple concepts to create a business dashboard / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 1, line 40)
> -- Step 1: Tell SQL which database to use / USE TechCorpDB; / -- Step 2: Count all employees

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 2, line 60)
> -- Count all projects / SELECT COUNT(*) AS NumberOfProjects / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 3, line 80)
> -- Add up all salaries / SELECT SUM(e.BaseSalary) AS TotalSalaryExpense / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 4, line 95)
> -- Add up all project budgets / SELECT SUM(Budget) AS TotalProjectBudgets / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 5, line 113)
> -- Calculate average e.BaseSalary / SELECT AVG(e.BaseSalary) AS AverageBaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 6, line 126)
> -- Find average project budget / SELECT AVG(Budget) AS AverageProjectBudget / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 7, line 146)
> -- Find highest e.BaseSalary / SELECT MAX(e.BaseSalary) AS HighestBaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 8, line 158)
> -- Get both highest and lowest in one go / SELECT / MAX(e.BaseSalary) AS HighestBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 9, line 172)
> -- Complete employee statistics / SELECT / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 10, line 184)
> TotalEmployees | TotalPayroll | AverageSalary | LowestSalary | HighestSalary / 15             | 750000       | 50000         | 35000        | 85000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 11, line 195)
> -- Complete project statistics / SELECT / COUNT(*) AS TotalProjects,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 12, line 212)
> -- Question 1: How many employees do we have? / SELECT COUNT(*) AS 'Number of Employees' / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 13, line 232)
> -- Format numbers to be easier to read / SELECT / COUNT(*) AS Employees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 14, line 246)
> -- How many clients does TechCorp have? / SELECT COUNT(*) AS 'Number of Clients' / FROM Clients;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 15, line 253)
> -- How many different departments exist? / SELECT COUNT(*) AS 'Number of Departments' / FROM Departments;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions.md** (block 16, line 260)
> -- Get a complete business overview / SELECT / 'TechCorp Business Overview' AS Report,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Advanced.md** (block 1, line 54)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Advanced.md** (block 2, line 191)
> -- Lab 9.1.3: Advanced Statistical Analysis for Strategic Planning / -- Business scenario: Statistical insights for executive decision making / WITH ProjectStatistics AS (

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Advanced.md** (block 3, line 412)
> -- Lab 9.1.5: Executive KPI Dashboard - Board-Level Metrics / -- Business scenario: Comprehensive executive dashboard for strategic oversight / WITH ExecutiveMetrics AS (

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 1, line 40)
> -- Step 1: Tell SQL which database to use / USE TechCorpDB; / -- Step 2: Count all employees

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 2, line 60)
> -- Count all projects / SELECT COUNT(*) AS NumberOfProjects / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 3, line 80)
> -- Add up all salaries / SELECT SUM(e.BaseSalary) AS TotalBaseSalaryExpense / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 4, line 95)
> -- Add up all project budgets / SELECT SUM(Budget) AS TotalProjectBudgets / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 5, line 113)
> -- Calculate average e.BaseSalary / SELECT AVG(e.BaseSalary) AS AverageBaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 6, line 126)
> -- Find average project budget / SELECT AVG(Budget) AS AverageProjectBudget / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 7, line 146)
> -- Find highest e.BaseSalary / SELECT MAX(e.BaseSalary) AS HighestBaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 8, line 158)
> -- Get both highest and lowest in one go / SELECT / MAX(e.BaseSalary) AS HighestBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 9, line 172)
> -- Complete employee statistics / SELECT / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 10, line 184)
> TotalEmployees | TotalPayroll | AverageSalary | LowestSalary | HighestSalary / 15             | 750000       | 50000         | 35000        | 85000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 11, line 195)
> -- Complete project statistics / SELECT / COUNT(*) AS TotalProjects,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 12, line 212)
> -- Question 1: How many employees do we have? / SELECT COUNT(*) AS 'Number of Employees' / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 13, line 232)
> -- Format numbers to be easier to read / SELECT / COUNT(*) AS Employees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 14, line 246)
> -- How many clients does TechCorp have? / SELECT COUNT(*) AS 'Number of Clients' / FROM Clients;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 15, line 253)
> -- How many different departments exist? / SELECT COUNT(*) AS 'Number of Departments' / FROM Departments;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson1_Using_Aggregate_Functions_Beginner.md** (block 16, line 260)
> -- Get a complete business overview / SELECT / 'TechCorp Business Overview' AS Report,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 1, line 42)
> -- Connect to database / USE TechCorpDB; / -- Count employees in each d.DepartmentName

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 2, line 55)
> d.DepartmentName  | AverageSalary / IT          | 55000 / Sales       | 50000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 3, line 71)
> -- Complete d.DepartmentName analysis / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 4, line 82)
> d.DepartmentName | JobLevel | EmployeeCount | AverageSalary / IT         | Junior   | 2             | 45000 / IT         | Senior   | 3             | 62000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 5, line 98)
> -- Analyze business by client industry / SELECT / c.Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 6, line 114)
> -- Count projects started by month / SELECT / YEAR(StartDate) AS ProjectYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 7, line 131)
> -- Good: d.DepartmentName is in GROUP BY, COUNT is a math function / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 8, line 140)
> -- Bad: EmployeeName is not in GROUP BY / SELECT d.DepartmentName, EmployeeName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 9, line 156)
> -- How many clients are in each city? / SELECT / City,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 10, line 167)
> -- How many employees were hired each year? / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause.md** (block 11, line 178)
> -- Complete analysis of clients by industry / SELECT / Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Advanced.md** (block 1, line 51)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Advanced.md** (block 2, line 265)
> -- Lab 9.2.3: Industry Vertical Performance Analysis / -- Business scenario: Market positioning and vertical expertise development / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Advanced.md** (block 3, line 402)
> -- Lab 9.2.4: Multi-Dimensional d.DepartmentName and Time Analysis / -- Business scenario: Strategic planning and budget allocation by d.DepartmentName over time / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Advanced.md** (block 4, line 558)
> -- Lab 9.2.5: Industry-Service Line Cross-Analysis / -- Business scenario: Optimal service-market fit analysis for strategic positioning / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 1, line 42)
> -- Connect to database / USE TechCorpDB; / -- Count employees in each d.DepartmentName

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 2, line 55)
> d.DepartmentName  | AverageSalary / IT          | 55000 / Sales       | 50000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 3, line 71)
> -- Complete d.DepartmentName analysis / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 4, line 82)
> d.DepartmentName | JobLevel | EmployeeCount | AverageSalary / IT         | Junior   | 2             | 45000 / IT         | Senior   | 3             | 62000

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 5, line 98)
> -- Analyze business by client industry / SELECT / c.Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 6, line 114)
> -- Count projects started by month / SELECT / YEAR(StartDate) AS ProjectYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 7, line 131)
> -- Good: d.DepartmentName is in GROUP BY, COUNT is a math function / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 8, line 140)
> -- Bad: EmployeeName is not in GROUP BY / SELECT d.DepartmentName, EmployeeName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 9, line 156)
> -- How many clients are in each city? / SELECT / City,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 10, line 167)
> -- How many employees were hired each year? / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson2_Using_the_GROUP_BY_Clause_Beginner.md** (block 11, line 178)
> -- Complete analysis of clients by industry / SELECT / Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 1, line 46)
> -- All departments with their employee counts / USE TechCorpDB; / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 2, line 60)
> d.DepartmentName  | EmployeeCount / IT          | 5 / Sales       | 4

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 3, line 72)
> -- Show project statuses with multiple projects / SELECT / Status,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 4, line 89)
> -- Departments with high e.BaseSalary costs / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 5, line 106)
> -- Departments that are either large OR expensive / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 6, line 129)
> -- Industries with multiple projects and good total revenue / SELECT / c.Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 7, line 146)
> -- Busy months for project starts / SELECT / YEAR(StartDate) AS ProjectYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 8, line 163)
> -- WRONG: This won't work / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 9, line 181)
> -- WRONG: HAVING before GROUP BY / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 10, line 199)
> SELECT column_list / FROM table_name / WHERE row_conditions      -- Filter rows first

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 11, line 211)
> -- Which cities have 2 or more clients? / SELECT / City,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 12, line 223)
> -- Which years had 3 or more employees hired? / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING.md** (block 13, line 235)
> -- Which clients have given us projects worth more than $50,000 total? / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Advanced.md** (block 1, line 52)
> -- Connect to TechCorp database / USE TechCorpDB; / GO

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Advanced.md** (block 2, line 302)
> -- Lab 9.3.3: Underperforming Segment Analysis / -- Business scenario: Early warning system for business segments requiring intervention / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Advanced.md** (block 3, line 500)
> -- Lab 9.3.4: Emerging Opportunity Analysis with Complex HAVING / -- Business scenario: Identify high-growth potential segments for strategic investment / WITH GrowthAnalysis AS (

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 1, line 46)
> -- All departments with their employee counts / USE TechCorpDB; / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 2, line 60)
> d.DepartmentName  | EmployeeCount / IT          | 5 / Sales       | 4

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 3, line 72)
> -- Show project statuses with multiple projects / SELECT / Status,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 4, line 89)
> -- Departments with high e.BaseSalary costs / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 5, line 106)
> -- Departments that are either large OR expensive / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 6, line 129)
> -- Industries with multiple projects and good total revenue / SELECT / c.Industry,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 7, line 146)
> -- Busy months for project starts / SELECT / YEAR(StartDate) AS ProjectYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 8, line 163)
> -- WRONG: This won't work / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 9, line 181)
> -- WRONG: HAVING before GROUP BY / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 10, line 199)
> SELECT column_list / FROM table_name / WHERE row_conditions      -- Filter rows first

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 11, line 211)
> -- Which cities have 2 or more clients? / SELECT / City,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 12, line 223)
> -- Which years had 3 or more employees hired? / SELECT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Lesson3_Filtering_Groups_with_HAVING_Beginner.md** (block 13, line 235)
> -- Which clients have given us projects worth more than $50,000 total? / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 1, line 42)
> -- Step 1: Tell SQL which database to use / USE TechCorpDB; / -- Step 2: Count all employees

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 2, line 61)
> -- Count all projects / SELECT COUNT(*) AS TotalProjects / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 3, line 68)
> -- Count all clients / SELECT COUNT(*) AS TotalClients / FROM Clients;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 4, line 78)
> -- Count employees who have a phone number / SELECT COUNT(PhoneNumber) AS EmployeesWithPhone / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 5, line 100)
> -- Add up all salaries / SELECT SUM(e.BaseSalary) AS TotalBaseSalaryCost / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 6, line 110)
> -- Add up all project budgets / SELECT SUM(Budget) AS TotalProjectBudgets / FROM Projects p;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 7, line 120)
> -- Add up all client contract values / SELECT SUM(ContractValue) AS TotalRevenue / FROM Clients;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 8, line 132)
> -- Calculate average e.BaseSalary / SELECT AVG(e.BaseSalary) AS AverageBaseSalary / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 9, line 142)
> -- Format as currency / SELECT / FORMAT(AVG(e.BaseSalary), 'C0') AS AverageBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 10, line 158)
> -- Find e.BaseSalary range / SELECT / MIN(e.BaseSalary) AS LowestBaseSalary,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 11, line 168)
> -- Find earliest and latest project dates / SELECT / MIN(StartDate) AS EarliestProject,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 12, line 180)
> -- Get complete e.BaseSalary statistics / SELECT / COUNT(*) AS TotalEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 13, line 230)
> -- Connect to database / USE TechCorpDB; / -- Count employees in each d.DepartmentName

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 14, line 244)
> -- Total project budget for each client / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 15, line 259)
> -- Show departments sorted by size (largest first) / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 16, line 273)
> -- Count employees by d.DepartmentName AND position / SELECT d.DepartmentName, / Position,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 17, line 285)
> d.DepartmentName  | Position    | EmployeeCount / IT          | Developer   | 3 / IT          | Manager     | 1

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 18, line 335)
> -- All departments with their employee counts / USE TechCorpDB; / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 19, line 348)
> d.DepartmentName  | EmployeeCount / IT          | 5 / Sales       | 4

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 20, line 363)
> -- Show only departments with more than 3 employees / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 21, line 376)
> -- Show clients with total project budget over $50,000 / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 22, line 395)
> -- Multiple HAVING conditions / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 23, line 414)
> -- Complete d.DepartmentName analysis / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 24, line 431)
> -- Employee tenure and e.BaseSalary analysis / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 25, line 446)
> -- Executive Dashboard: Complete company overview / SELECT / 'Company Overview' AS ReportSection,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 26, line 503)
> SELECT column(s) / FROM table(s) / WHERE condition_for_rows

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 27, line 536)
> -- WRONG: / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 28, line 552)
> -- WRONG: / SELECT d.DepartmentName, EmployeeName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 29, line 567)
> -- WRONG: / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 30, line 590)
> -- Multi-level business analysis / WITH DepartmentStats AS ( / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Complete_Beginner_Guide_All_In_One.md** (block 31, line 624)
> -- Yearly hiring and project trends / SELECT / analysis_year,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 1, line 36)
> -- Connect to database / USE TechCorpDB; / -- Exercise 1.1a: Employee overview with aliases (Module 3 + 9)

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 2, line 59)
> -- Exercise 1.2a: Categorize employees by e.BaseSalary level / SELECT / COUNT(*) AS 'Total Employees',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 3, line 85)
> -- Exercise 2.1a: Employee count and e.BaseSalary by d.DepartmentName name / SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS 'Number of Employees',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 4, line 111)
> -- Exercise 2.2a: d.DepartmentName project management analysis / SELECT d.DepartmentName, / COUNT(p.ProjectID) AS 'Projects Managed',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 5, line 145)
> -- Exercise 3.1a: High-paid employees by d.DepartmentName / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 6, line 171)
> -- Exercise 3.2a: Top performing departments (recent hires, good salaries) / SELECT TOP 3 / d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 7, line 208)
> -- Exercise 4.1a: Hiring trends by year / SELECT / YEAR(e.HireDate) AS 'Hire Year',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 8, line 235)
> -- Exercise 4.2a: Employee tenure analysis / SELECT / CASE

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 9, line 280)
> -- Exercise 5.1a: Employee name length analysis by d.DepartmentName / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 10, line 314)
> -- Exercise 7.1a: Employee contact information completeness by d.DepartmentName / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 11, line 345)
> -- Exercise 8.1: Complete business overview combining all concepts / WITH DepartmentStats AS ( / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Comprehensive_Practice_Exercises_Beginner.md** (block 12, line 397)
> -- Exercise 8.2: Comprehensive trend analysis / SELECT / YEAR(e.HireDate) AS AnalysisYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 1, line 14)
> -- Basic pattern: / SELECT / COUNT(*) AS 'Friendly Name',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 2, line 31)
> -- Basic pattern: / SELECT / t1.CategoryColumn,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 3, line 44)
> -- Basic pattern: / SELECT / CategoryColumn,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 4, line 59)
> -- Basic pattern: / SELECT / YEAR(DateColumn) AS 'Year',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 5, line 75)
> SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 6, line 85)
> -- WRONG: / SELECT d.DepartmentName, EmployeeName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 7, line 100)
> -- WRONG: / SELECT d.DepartmentName, COUNT(*) / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Quick_Reference_Skills_Combinations.md** (block 8, line 156)
> SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 1, line 21)
> USE TechCorpDB;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 2, line 34)
> -- Example: Count all employees / SELECT COUNT(*) AS 'Total Employees' / FROM Employees e;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 3, line 57)
> -- Example: Count high-paid employees (Module 5 WHERE + Module 9 COUNT) / SELECT COUNT(*) AS 'High Paid Employees' / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 4, line 88)
> -- Example: Total e.BaseSalary cost with nice formatting / SELECT / FORMAT(SUM(e.BaseSalary), 'C0') AS 'Total Payroll Cost'

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 5, line 113)
> -- Example: Complete e.BaseSalary overview / SELECT / COUNT(*) AS 'Number of Employees',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 6, line 146)
> -- Example: Count employees by d.DepartmentName / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 7, line 174)
> -- Example: Which departments manage the most project money? / SELECT d.DepartmentName, / COUNT(p.ProjectID) AS 'Projects Managed',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 8, line 201)
> -- Example: Show only departments with 3+ employees / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Step_by_Step_Practice_Workbook_Beginner.md** (block 9, line 235)
> -- Step 1: Client overview / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 1, line 40)
> -- Module 1: Connect to database and understand structure / USE TechCorpDB; / -- Show which database you're working with (Module 1 skill)

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 2, line 61)
> -- Use Module 1 knowledge: Check database info / -- Use Module 9 knowledge: Count and analyze data / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 3, line 85)
> -- Step 1: In SSMS Object Explorer, expand TechCorpDB > Tables / -- Step 2: Right-click Employees table > Select Top 1000 Rows / -- Step 3: Now run aggregate analysis:

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 4, line 128)
> -- Module 2: Proper T-SQL formatting and comments / -- Module 9: Using aggregate functions with good syntax / -- ================================

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 5, line 161)
> -- Declare variables (Module 2 skill) / DECLARE @AverageSalary DECIMAL(10,2); / DECLARE @TotalEmployees INT;

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 6, line 183)
> -- Working with different data types in aggregation / SELECT d.DepartmentName,                          -- NVARCHAR data type / COUNT(*) AS EmployeeCount,          -- INT result

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 7, line 215)
> -- Module 3: Basic SELECT with specific columns / SELECT / e.FirstName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 8, line 236)
> -- Using Module 3 column aliases to make Module 9 aggregates business-friendly / SELECT d.DepartmentName AS 'Department Name', / COUNT(*) AS 'Number of Employees',

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 9, line 254)
> -- Module 3: Using DISTINCT to eliminate duplicates / -- Module 9: Using COUNT with DISTINCT for unique values / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 10, line 281)
> -- Combining tables (Module 4) with aggregation (Module 9) / SELECT / c.ClientName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 11, line 310)
> -- Three-table join with comprehensive aggregation / SELECT d.DepartmentName, / -- Employee metrics

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 12, line 358)
> -- Module 5: Basic filtering and sorting / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 13, line 381)
> -- Complex filtering + aggregation + sorting / SELECT TOP 3                           -- Limit results (Module 5) / d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 14, line 403)
> -- Date filtering + aggregation + complex sorting / SELECT / YEAR(StartDate) AS ProjectYear,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 15, line 434)
> -- Complex WHERE conditions + advanced HAVING / SELECT d.DepartmentName, / Position,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 16, line 482)
> -- Understanding how different data types work with aggregation / SELECT / 'Data Type Analysis' AS ReportType,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 17, line 509)
> -- Module 6: Working with DATE data types / -- Module 9: Grouping and aggregating date data / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 18, line 533)
> -- Module 6: String data types and functions / -- Module 9: Aggregating string data / SELECT

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 19, line 571)
> -- Module 6: Proper NULL handling / -- Module 9: How aggregates handle NULLs / SELECT d.DepartmentName,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 20, line 621)
> -- Before making changes: Check current state with aggregation / SELECT / 'BEFORE Changes' AS Status,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 21, line 653)
> -- Step 1: Analyze BEFORE the update (Module 9) / SELECT 'IT d.DepartmentName - BEFORE Raise' AS Status, / COUNT(*) AS ITEmployees,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 22, line 689)
> -- Step 1: Identify data quality issues (Module 9) / SELECT / 'Data Quality Report - BEFORE Cleanup' AS Status,

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 23, line 726)
> -- Monitor large data operations with aggregation / -- Scenario: Archive old projects and analyze impact / -- Step 1: Analyze projects before archiving (Module 9)

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 24, line 780)
> -- Module 8 + Module 9: Functions working with aggregation / SELECT / -- String functions with aggregation

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 25, line 811)
> -- Complex date functions with aggregation / SELECT / -- Tenure grouping using date functions

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 26, line 863)
> -- String functions combined with grouping / SELECT / -- Extract and group by name characteristics

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 27, line 899)
> -- Advanced math functions with aggregation for business metrics / SELECT d.DepartmentName, / -- Basic aggregation

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 28, line 955)
> -- ============================================================================ / -- EXECUTIVE DASHBOARD: Complete Company Analysis / -- Integrating ALL Modules 1-9 for Business Intelligence

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 29, line 1042)
> -- ============================================================================ / -- TEMPORAL BUSINESS INTELLIGENCE: Multi-Year Trend Analysis / -- Combining Modules 1-9 for Historical Business Insights

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 30, line 1103)
> -- ============================================================================ / -- CLIENT INTELLIGENCE: Complete Customer Analysis / -- Master-level integration of ALL Modules 1-9

✅ **tech company/untitled/Module 9 - Grouping and Aggregating Data/Module9_Ultimate_Integration_ALL_MODULES_1-9.md** (block 31, line 1240)
> SELECT     -- What you want to see / FROM       -- Where the data lives / WHERE      -- Filter individual rows

✅ **tech company/untitled/Presentations/Individual_Presentation_Guide.md** (block 1, line 105)
> Create individual presentation for [TOPIC]: / - 21 slides following the standard framework / - Include TechCorp Solutions business context

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 1, line 39)
> -- Verify TechCorp database connection / USE TechCorpDB; / -- Review available tables

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 2, line 78)
> -- Select all columns FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID table / SELECT * FROM Employees e

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 3, line 116)
> -- Avoid SELECT * in production queries / -- Instead, specify needed columns explicitly / SELECT

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 4, line 155)
> -- Basic table alias / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 5, line 194)
> -- Descriptive column aliases / SELECT / e.EmployeeID AS [Employee ID],

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 6, line 236)
> -- Simple equality condition / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 7, line 262)
> -- AND operator / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 8, line 286)
> -- Equality and inequality / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.BaseSalary = 75000;      -- Equal

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 9, line 317)
> -- NULL comparisons (special operators required) / SELECT * FROM Employees e WHERE MiddleName IS NULL; / SELECT * FROM Employees e WHERE MiddleName IS NOT NULL;

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 10, line 329)
> -- Wildcard patterns / SELECT * FROM Employees e WHERE e.LastName LIKE 'Sm%';     -- Starts with 'Sm' / SELECT * FROM Employees e WHERE e.FirstName LIKE '%ohn';   -- Ends with 'ohn'

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 11, line 357)
> -- Single column sorting / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 12, line 383)
> -- Sort by calculated columns / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 13, line 405)
> -- Basic arithmetic / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 14, line 428)
> -- String concatenation and functions / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 15, line 444)
> -- Integer operations / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 16, line 461)
> -- Date formatting and extraction / SELECT / e.HireDate,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 17, line 474)
> -- String functions / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 18, line 491)
> -- Multiple AND conditions / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 19, line 530)
> -- Basic CASE for categorization / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 20, line 560)
> -- Multiple conditions in CASE / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 21, line 580)
> -- Efficient column selection / -- Good: Select only needed columns / SELECT e.EmployeeID, e.FirstName, e.LastName

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 22, line 599)
> -- Check existing indexes / SELECT / i.name AS IndexName,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 23, line 617)
> -- Count records to verify results / SELECT COUNT(*) AS TotalEmployees FROM Employees e; / SELECT COUNT(*) AS ITEmployees FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering';

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 24, line 652)
> -- Common mistakes and corrections / -- Mistake: Missing FROM clause / -- SELECT e.FirstName, e.LastName;

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 25, line 672)
> -- Mistake: Incorrect operator precedence / -- SELECT * FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering' OR 'Finance' AND e.BaseSalary > 70000; / -- Correct:

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 26, line 691)
> -- New hire report / SELECT / e.FirstName + ' ' + e.LastName AS NewHire,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 27, line 719)
> -- d.DepartmentName cost analysis / SELECT d.DepartmentName, / COUNT(*) AS HeadCount,

✅ **tech company/untitled/Presentations/Lab_Basic_SELECT_Presentation.md** (block 28, line 748)
> -- Comprehensive test query / SELECT / e.EmployeeID AS ID,

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 1, line 49)
> -- Verify SQL Server installation / SELECT @@VERSION AS SQLServerVersion; / SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion;

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 2, line 68)
> -- Server name examples / localhost / .\SQLEXPRESS

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 3, line 117)
> -- Alternative T-SQL approach / CREATE DATABASE TechCorpDB / ON (

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 4, line 148)
> CREATE TABLE Employees ( / EmployeeID INT IDENTITY(1,1) PRIMARY KEY, / FirstName NVARCHAR(50) NOT NULL,

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 5, line 179)
> -- Database information query / SELECT / name AS DatabaseName,

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 6, line 217)
> -- d.DepartmentName data / INSERT INTO Departments (DepartmentName, Location) VALUES / ('Information Technology', 'New York'),

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 7, line 245)
> -- Full database backup / BACKUP DATABASE TechCorpDB / TO DISK = 'C:\Backups\TechCorpDB_Full.bak'

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 8, line 275)
> -- Create SQL Server login / CREATE LOGIN TechCorpUser / WITH PASSWORD = 'SecurePassword123!';

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 9, line 308)
> -- Current connections / SELECT / session_id,

✅ **tech company/untitled/Presentations/Lab_Tools_Presentation.md** (block 10, line 394)
> -- Using templates / -- Ctrl+Alt+T to open Template Explorer / -- Navigate to Stored Procedure → Create Procedure

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 1, line 252)
> Page Structure (8KB = 8,192 bytes): / ┌─────────────────────────────────────┐ / │ Page Header (96 bytes)              │ ← Metadata and system information

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 2, line 281)
> Database / ├── Filegroups (logical grouping) / │   ├── PRIMARY (always exists)

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 3, line 331)
> Optimization Phases: / ┌─────────────────────────────────────┐ / │ 1. Simplification                   │ ← Remove redundancies

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 4, line 402)
> BEGIN TRANSACTION / UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1; / UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 2;

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 5, line 466)
> Lock Compatibility Matrix: / │ None │  S   │  U   │  X   │  IS  │  IX  │ SIX / ───────────┼──────┼──────┼──────┼──────┼──────┼──────┼─────

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 6, line 571)
> -- Monitor buffer cache hit ratio / SELECT / object_name,

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 7, line 588)
> -- Check database file I/O statistics / SELECT / DB_NAME(vfs.database_id) AS database_name,

✅ **tech company/untitled/Presentations/Lesson1_Architecture_Presentation.md** (block 8, line 747)
> -- Monitor active sessions / SELECT / session_id,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 1, line 63)
> -- Create database objects / CREATE TABLE Employees ( / e.EmployeeID INT PRIMARY KEY,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 2, line 79)
> -- Insert data / INSERT INTO Employees VALUES (1, 'John', 'Smith'); / -- Update records

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 3, line 103)
> -- Conditional logic / IF @Department = 'IT' / SELECT * FROM ITEmployees;

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 4, line 136)
> -- Valid identifier examples / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 5, line 159)
> DECLARE @e.EmployeeID INT = 100; / DECLARE @e.BaseSalary DECIMAL(10,2) = 75000.50; / DECLARE @BonusRate FLOAT = 0.15;

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 6, line 167)
> DECLARE @e.FirstName NVARCHAR(50) = 'John'; / DECLARE @Description VARCHAR(MAX) = 'Long text content'; / DECLARE @Code CHAR(5) = 'EMP01';

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 7, line 174)
> DECLARE @e.HireDate DATE = '2023-01-15'; / DECLARE @LastLogin DATETIME = GETDATE(); / DECLARE @ProcessTime TIME = '14:30:00';

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 8, line 191)
> SELECT column1, column2, column3 / FROM table_name / WHERE condition

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 9, line 199)
> -- Retrieve employee information / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 10, line 225)
> -- Variable declaration / DECLARE @EmployeeCount INT; / DECLARE @d.DepartmentName NVARCHAR(50) = 'IT';

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 11, line 246)
> CREATE PROCEDURE GetEmployeesByDept / @DeptName NVARCHAR(50) / AS

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 12, line 261)
> SELECT / e.BaseSalary, / e.BaseSalary * 1.10 AS SalaryWithRaise,      -- Multiplication

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 13, line 272)
> WHERE e.BaseSalary > 50000              -- Greater than / AND e.HireDate <= '2023-01-01'    -- Less than or equal / AND d.DepartmentName <> 'HR'          -- Not equal

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 14, line 291)
> SELECT / UPPER(e.FirstName) AS UpperFirst, / LEN(e.LastName) AS LastNameLength,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 15, line 301)
> SELECT / GETDATE() AS CurrentDateTime, / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 16, line 311)
> SELECT / COUNT(*) AS TotalEmployees, / AVG(e.BaseSalary) AS AverageBaseSalary,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 17, line 326)
> -- Single line comment / /* Multi-line comment / for detailed explanations

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 18, line 359)
> BEGIN TRY / -- Potentially error-prone code / UPDATE Employees

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 19, line 414)
> -- Efficient query structure / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 20, line 446)
> -- Use consistent formatting / SELECT / emp.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 21, line 480)
> -- Employee performance reporting / SELECT / emp.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 22, line 498)
> -- d.DepartmentName e.BaseSalary analysis / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount,

✅ **tech company/untitled/Presentations/Lesson1_TSQL_Introduction_Presentation.md** (block 23, line 516)
> -- Incorrect (missing FROM) / SELECT e.FirstName, e.LastName; / -- Correct

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 1, line 45)
> -- TechCorp Departments (as a set) / {'Information Technology', 'Human Resources', 'Finance', 'Marketing'} / -- Employee IDs (as a set)

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 2, line 67)
> -- Employees table as a set of employee records / CREATE TABLE Employees ( / e.EmployeeID INT PRIMARY KEY,    -- Ensures uniqueness

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 3, line 102)
> -- Check if employee belongs to IT d.DepartmentName set / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 4, line 132)
> -- Query returning no results = Empty Set / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 5, line 145)
> -- All employees = Universal set for this context / SELECT * FROM Employees e;  -- Universal set of all employees / -- All records in database context

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 6, line 172)
> -- Combine IT and HR employees / SELECT e.EmployeeID, e.FirstName, e.LastName, 'IT' AS Source / FROM Employees e INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.DepartmentName = 'Engineering'

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 7, line 189)
> -- UNION (removes duplicates - true set operation) / SELECT d.DepartmentName FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 8, line 215)
> -- Employees who are both in IT and have high salaries / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 9, line 253)
> -- Employees in IT but not earning high salaries / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 10, line 297)
> -- Cartesian product (usually unintentional) / SELECT / e.FirstName + ' ' + e.LastName AS Employee,

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 11, line 328)
> -- DISTINCT enforces set behavior / SELECT DISTINCT d.DepartmentName FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 12, line 342)
> -- Default SQL behavior allows duplicates / SELECT d.DepartmentName FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 13, line 365)
> -- IN operator (element of set) / SELECT * FROM Employees e / WHERE d.DepartmentName IN ('IT', 'Finance', 'HR');

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 14, line 399)
> -- NULL values in set membership / SELECT * FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 15, line 436)
> -- Efficient set membership (indexed column) / SELECT * FROM Employees e / WHERE DepartmentID IN (1, 2, 3);  -- Fast with index

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 16, line 469)
> -- Active employees with specific skills / SELECT e.EmployeeID, e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 17, line 484)
> -- Employees available for new projects / SELECT e.EmployeeID FROM Employees e / WHERE IsActive = 1

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 18, line 497)
> -- d.DepartmentName union for company-wide reports / SELECT DepartmentID, COUNT(*) AS EmployeeCount / FROM (

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 19, line 520)
> -- Good: Set-based approach / UPDATE Employees / SET e.BaseSalary = e.BaseSalary * 1.10

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 20, line 544)
> -- Mistake: Expecting set behavior but getting multiset / SELECT d.DepartmentName FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;  -- May have duplicates

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 21, line 555)
> -- Mistake: NULL equality comparison / WHERE d.DepartmentName = NULL;  -- Always false / -- Correct: IS NULL comparison

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 22, line 564)
> -- Mistake: Wrong set operation / SELECT * FROM A UNION SELECT * FROM B;     -- Union (removes duplicates) / -- When you meant:

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 23, line 582)
> -- Check if all IT employees have high salaries (subset test) / SELECT / CASE

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 24, line 597)
> -- Compare two sets for equality / WITH Set1 AS (SELECT DISTINCT d.DepartmentName FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID),

✅ **tech company/untitled/Presentations/Lesson2_Understanding_Sets_Presentation.md** (block 25, line 627)
> -- Many-to-many relationship as set of pairs / CREATE TABLE EmployeeProjects ( / EmployeeID INT,

✅ **tech company/untitled/Presentations/Lesson3_SSMS_Presentation.md** (block 1, line 77)
> -- Connect to SQL Server instance / Server: localhost\SQLEXPRESS / Authentication: Windows Authentication

✅ **tech company/untitled/Presentations/Lesson3_SSMS_Presentation.md** (block 2, line 110)
> -- IntelliSense example / SELECT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Lesson3_SSMS_Presentation.md** (block 3, line 151)
> -- Execute current query (F5 or Ctrl+E) / SELECT * FROM Employees e; / -- Execute selected text

✅ **tech company/untitled/Presentations/Lesson3_SSMS_Presentation.md** (block 4, line 183)
> -- Script generation example / -- Right-click table → Script Table as → CREATE To → New Query Editor Window / CREATE TABLE [dbo].[Employees](

✅ **tech company/untitled/Presentations/Lesson3_SSMS_Presentation.md** (block 5, line 250)
> -- Display execution plan / SET SHOWPLAN_ALL ON; / SELECT * FROM Employees e WHERE DepartmentID = 1;

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 1, line 62)
> -- T-SQL: What you want (declarative) / SELECT CompanyName, TotalOrders / FROM Customers c

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 2, line 73)
> // Imperative: How to get it (step-by-step) / CustomerList = [] / For each customer in Customers:

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 3, line 95)
> -- AVOID: Cursor-based row-by-row processing / DECLARE customer_cursor CURSOR FOR / SELECT CustomerID FROM Customers;

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 4, line 136)
> -- Mathematical: A ∪ B = {x | x ∈ A or x ∈ B} / -- SQL Implementation: / SELECT CustomerID, CompanyName FROM Customers_USA

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 5, line 153)
> -- Mathematical: A ∩ B = {x | x ∈ A and x ∈ B} / -- SQL Implementation: / SELECT ProductID FROM Orders_Q1

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 6, line 164)
> -- Mathematical: A − B = {x | x ∈ A and x ∉ B} / -- SQL Implementation: / SELECT CustomerID FROM All_Customers

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 7, line 175)
> -- Mathematical: A × B = {(a,b) | a ∈ A and b ∈ B} / -- SQL Implementation: / SELECT Colors.ColorName, Sizes.SizeName

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 8, line 188)
> -- Mathematical: σ(condition)(R) / -- Selects tuples that satisfy the condition / SELECT * FROM Employees e

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 9, line 199)
> -- Mathematical: π(attribute_list)(R) / -- Projects specified attributes from relation / SELECT e.EmployeeID, e.FirstName, e.LastName

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 10, line 236)
> -- Example relation structure / CREATE TABLE Employees ( / EmployeeID int PRIMARY KEY,      -- Unique identifier

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 11, line 269)
> -- Single column primary key / CREATE TABLE Customers ( / CustomerID int IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 12, line 286)
> -- Foreign key with referential integrity / CREATE TABLE Orders ( / OrderID int PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 13, line 299)
> -- Multiple candidate keys / CREATE TABLE Employees ( / EmployeeID int PRIMARY KEY,         -- Primary key

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 14, line 344)
> SELECT column_list / FROM table_name / WHERE condition

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 15, line 394)
> WHERE e.BaseSalary > 50000 AND d.DepartmentName = 'Engineering'

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 16, line 410)
> SELECT FirstName + ' ' + LastName AS full_name, / e.BaseSalary * 1.1 AS projected_salary

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 17, line 427)
> GROUP BY d.DepartmentName, job_title

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 18, line 443)
> HAVING COUNT(*) > 5 AND AVG(e.BaseSalary) > 60000

✅ **tech company/untitled/Presentations/Module2_Theory_Presentation.md** (block 19, line 459)
> ORDER BY e.BaseSalary DESC, e.LastName ASC

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 1, line 29)
> -- Written Order: / SELECT [DISTINCT] <column_list> / FROM <table_name>

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 2, line 92)
> -- Best Practice: Specify only needed columns / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 3, line 110)
> -- Sometimes Appropriate: Exploratory queries, views with same structure / SELECT * FROM Employees e; / -- More Controlled: Using table aliases

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 4, line 126)
> SELECT / e.EmployeeID, / e.FirstName,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 5, line 140)
> SELECT / e.EmployeeID, / e.FirstName + ' ' + e.LastName AS FullName,              -- Concatenation

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 6, line 153)
> SELECT / e.EmployeeID, / e.FirstName,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 7, line 172)
> SELECT / e.EmployeeID, / e.FirstName,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 8, line 219)
> -- Single column DISTINCT / SELECT DISTINCT d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 9, line 241)
> -- DISTINCT approach / SELECT DISTINCT d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 10, line 264)
> -- Complex DISTINCT scenarios / SELECT DISTINCT / YEAR(e.HireDate) AS HireYear,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 11, line 283)
> -- Inefficient: DISTINCT on large result set / SELECT DISTINCT * / FROM LargeTable

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 12, line 309)
> -- Multiple valid alias syntaxes / SELECT / e.FirstName AS EmployeeFirstName,        -- Standard AS syntax

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 13, line 321)
> -- Good aliasing practices / SELECT / e.EmployeeID AS EmpID,                 -- Meaningful abbreviation

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 14, line 344)
> -- Professional table aliasing / SELECT / emp.EmployeeID,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 15, line 359)
> -- Common aliasing patterns / SELECT / c.CustomerID,

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 16, line 389)
> **Important**: DISTINCT applies to the entire row, not individual columns / --- / ## Slide 5: DISTINCT Performance Considerations

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 17, line 426)
> **Benefits**: Improved readability, custom column headers / --- / ## Slide 7: Table Aliases

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 18, line 446)
> **Best Practice**: Use meaningful, short aliases / --- / ## Slide 8: Calculated Columns

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 19, line 464)
> **Common Calculations**: Mathematical operations, date differences, string concatenation / --- / ## Slide 9: String Concatenation

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 20, line 485)
> --- / ## Slide 10: Introduction to CASE Expressions / **Conditional Logic in Queries**

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 21, line 510)
> --- / ## Slide 11: Simple CASE Expression / **Value-Based Conditions**

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 22, line 531)
> **Use When**: Comparing single column to multiple specific values / --- / ## Slide 12: Searched CASE Expression

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 23, line 553)
> **Use When**: Complex conditions involving multiple columns or ranges / --- / ## Slide 13: Nested CASE Expressions

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 24, line 579)
> **Use Carefully**: Can become complex and hard to maintain / --- / ## Slide 14: CASE with Aggregate Functions

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 25, line 596)
> **Powerful Technique**: Allows selective aggregation based on conditions / --- / ## Slide 15: NULL Handling in CASE

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 26, line 614)
> **Remember**: CASE returns NULL if no conditions match and no ELSE clause exists / --- / ## Slide 16: Performance Considerations

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 27, line 637)
> --- / ## Slide 17: Common SELECT Patterns / **Frequently Used Techniques**

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 28, line 657)
> --- / ## Slide 18: String Functions in SELECT / **Text Manipulation**

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 29, line 672)
> **Common Functions**: UPPER, LOWER, LEN, SUBSTRING, TRIM, LEFT, RIGHT / --- / ## Slide 19: Date Functions in SELECT

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 30, line 690)
> **Common Functions**: GETDATE, YEAR, MONTH, DAY, DATEDIFF, DATEADD / --- / ## Slide 20: Numeric Functions in SELECT

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 31, line 708)
> **Common Functions**: ROUND, ABS, CEILING, FLOOR, POWER, SQRT / --- / ## Slide 21: Data Type Conversion

✅ **tech company/untitled/Presentations/Module3_Theory_Presentation.md** (block 32, line 725)
> **Use CAST**: ANSI standard, portable / **Use CONVERT**: SQL Server specific, more formatting options / ---

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 1, line 36)
> -- BAD: Violates 1NF (repeating groups) / CREATE TABLE EmployeesBAD ( / e.EmployeeID int,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 2, line 47)
> -- GOOD: Follows 1NF / CREATE TABLE Employees ( / e.EmployeeID int PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 3, line 85)
> -- One-to-One: Employee to Employee Security Clearance / CREATE TABLE Employees ( / e.EmployeeID int PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 4, line 105)
> -- One-to-Many: d.DepartmentName to Employees / CREATE TABLE Departments ( / d.DepartmentID int PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 5, line 123)
> -- Many-to-Many: Students to Courses (via Enrollments) / CREATE TABLE Students ( / StudentID int PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 6, line 157)
> -- Conceptual algorithm: / FOR each row R1 in Table1: / FOR each row R2 in Table2:

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 7, line 173)
> -- Conceptual algorithm: / Sort Table1 by JOIN_COLUMN if not already sorted / Sort Table2 by JOIN_COLUMN if not already sorted

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 8, line 188)
> -- Conceptual algorithm: / 1. Build Phase: Create hash table from smaller table / 2. Probe Phase: Probe hash table with larger table rows

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 9, line 203)
> -- Modern, explicit JOIN syntax / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 10, line 214)
> -- Old-style implicit JOIN (avoid in new code) / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 11, line 239)
> SELECT / e.EmployeeID, / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 12, line 251)
> -- Join on multiple columns for composite keys / SELECT / od.OrderID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 13, line 267)
> -- Five-table join with proper ordering / SELECT / c.CustomerName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 14, line 289)
> -- Employee-Manager relationship (self-join) / SELECT / emp.EmployeeID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 15, line 304)
> -- Optimal indexes for JOIN performance / CREATE INDEX IX_Employees_DepartmentID ON Employees (d.DepartmentID); / CREATE INDEX IX_Orders_CustomerID ON Orders (CustomerID);

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 16, line 318)
> -- Query optimizer typically handles this, but understanding helps / SELECT / c.CustomerName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 17, line 347)
> -- All customers with their orders (including customers without orders) / SELECT / c.CustomerID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 18, line 362)
> -- Customers who have never placed an order / SELECT / c.CustomerID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 19, line 375)
> -- Customer summary with order statistics / SELECT / c.CustomerID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 20, line 397)
> -- These queries are equivalent: / -- RIGHT JOIN version / SELECT c.CustomerName, o.OrderID

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 21, line 417)
> -- All customers and all orders (complete picture) / SELECT / c.CustomerID,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 22, line 437)
> SELECT columns / FROM table1 t1 / INNER JOIN table2 t2 ON t1.key = t2.key;

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 23, line 448)
> -- ANSI JOIN syntax (recommended) / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 24, line 468)
> SELECT / e.FirstName, / e.LastName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 25, line 487)
> SELECT / e.FirstName, / e.LastName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 26, line 505)
> SELECT / e.FirstName, / e.LastName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 27, line 523)
> SELECT / e.FirstName, / e.LastName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 28, line 541)
> -- Explicit CROSS JOIN / SELECT / s.SkillName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 29, line 562)
> -- Finding employees and their managers / SELECT / e.FirstName + ' ' + e.LastName AS Employee,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 30, line 579)
> -- Equality condition (most common) / ON e.d.DepartmentID = d.DepartmentID / -- Multiple conditions

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 31, line 599)
> -- JOIN condition: defines relationship / SELECT e.FirstName, d.DepartmentName / FROM Employees e

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 32, line 620)
> -- Multiple paths to same table / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 33, line 650)
> -- Missing JOIN condition (Cartesian product) / SELECT * FROM Employees e, Departments; / -- Wrong JOIN type

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 34, line 669)
> SELECT d.DepartmentName, / COUNT(e.EmployeeID) AS EmployeeCount, / AVG(e.BaseSalary) AS AverageBaseSalary,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 35, line 696)
> -- JOIN approach / SELECT DISTINCT e.FirstName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 36, line 714)
> -- Many-to-many: Employees and Skills / SELECT / e.FirstName + ' ' + e.LastName AS EmployeeName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 37, line 734)
> -- Current and former employees / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module4_Theory_Presentation.md** (block 38, line 762)
> -- Handle NULLs in JOIN results / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 1, line 44)
> -- View current database collation / SELECT DATABASEPROPERTYEX('YourDatabase', 'Collation') AS DatabaseCollation; / -- Different collation behaviors

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 2, line 65)
> -- Complex multi-level sorting with business logic / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 3, line 98)
> -- Sort by calculated expressions / SELECT / ProductID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 4, line 127)
> -- Explicit NULL handling / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 5, line 160)
> -- Understanding NULL behavior in WHERE clauses / SELECT 'Result when NULL = NULL: ' AS Description, / CASE WHEN NULL = NULL THEN 'TRUE'

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 6, line 175)
> -- Complex predicate with proper precedence / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 7, line 203)
> -- BETWEEN is inclusive on both ends / SELECT / OrderID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 8, line 225)
> -- IN clause for multiple discrete values / SELECT / ProductID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 9, line 257)
> -- Advanced LIKE patterns / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 10, line 285)
> -- Proper NULL checking / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 11, line 313)
> -- Fixed number of rows / SELECT TOP 10 / ProductID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 12, line 341)
> -- Include tied values / SELECT TOP 5 WITH TIES / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 13, line 358)
> -- Page 1 (first 20 records) / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 14, line 387)
> -- Parameterized paging approach / DECLARE @PageNumber int = 3; / DECLARE @PageSize int = 20;

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 15, line 417)
> -- Create covering index for paging queries / CREATE NONCLUSTERED INDEX IX_Products_Paging / ON Products (Discontinued, ProductName)

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 16, line 430)
> -- More efficient for deep paging using cursor/key-based approach / DECLARE @LastProductName nvarchar(40) = 'Previous Page Last Product'; / SELECT TOP 20

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 17, line 455)
> -- Enable full-text indexing (requires appropriate setup) / -- CREATE FULLTEXT CATALOG ProductCatalog AS DEFAULT; / -- CREATE FULLTEXT INDEX ON Products(ProductName, Description)

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 18, line 476)
> -- Complex pattern matching scenarios / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 19, line 501)
> -- Case-insensitive search regardless of column collation / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 20, line 525)
> -- Alternative approach using UPPER function / SELECT / ProductID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 21, line 541)
> -- Computed column for normalized search / ALTER TABLE Customers / ADD CompanyNameUpper AS UPPER(CompanyName) PERSISTED;

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 22, line 556)
> -- Optimized search query with proper indexing / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 23, line 591)
> -- Query pattern analysis / SELECT / o.OrderID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 24, line 617)
> -- Index column order matters for query performance / -- Rule: Most selective columns first, then ORDER BY columns / -- Good index design (supports WHERE and ORDER BY)

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 25, line 635)
> -- Query that requires sorting / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 26, line 663)
> -- Monitor sort operations in query plans / SELECT / query_plan,

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 27, line 688)
> -- SARGable (Good - can use indexes efficiently) / WHERE e.LastName LIKE 'Smith%'        -- Index seek possible / WHERE OrderDate >= '2023-01-01'     -- Index seek possible

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 28, line 703)
> -- BAD: OR conditions with different columns (forces index scan) / SELECT * FROM Employees e / WHERE e.FirstName = 'John' OR e.LastName = 'Smith';

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 29, line 725)
> -- Query requiring specific sort order / SELECT ProductID, ProductName, BaseSalary / FROM Products

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 30, line 742)
> -- BAD: Sorting large result set unnecessarily / SELECT * FROM Orders / ORDER BY OrderDate

✅ **tech company/untitled/Presentations/Module5_Enhanced_Theory_Presentation.md** (block 31, line 758)
> -- Professional query formatting / SELECT / -- Customer information

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 1, line 23)
> SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e / ORDER BY e.BaseSalary DESC, e.LastName ASC;

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 2, line 34)
> -- Basic sorting / ORDER BY e.LastName / -- Multiple columns with different directions

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 3, line 58)
> -- Default NULL behavior / SELECT e.FirstName, MiddleName, e.LastName / FROM Employees e

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 4, line 84)
> SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e / INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 5, line 98)
> -- Equality and inequality / WHERE e.BaseSalary = 50000 / WHERE d.DepartmentName <> 'Engineering'

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 6, line 120)
> -- Wildcard patterns / WHERE e.LastName LIKE 'Sm%'        -- Starts with 'Sm' / WHERE e.LastName LIKE '%son'       -- Ends with 'son'

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 7, line 141)
> -- BETWEEN (inclusive range) / WHERE e.BaseSalary BETWEEN 40000 AND 60000 / WHERE e.HireDate BETWEEN '2020-01-01' AND '2020-12-31'

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 8, line 161)
> -- Testing for NULL / WHERE MiddleName IS NULL / WHERE MiddleName IS NOT NULL

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 9, line 183)
> -- AND (both conditions must be TRUE) / WHERE d.DepartmentName = 'Engineering' AND e.BaseSalary > 50000 / -- OR (either condition can be TRUE)

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 10, line 204)
> -- Fixed number of rows / SELECT TOP 10 e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 11, line 228)
> -- Skip first 10 rows, get next 5 / SELECT e.FirstName, e.LastName, e.BaseSalary / FROM Employees e

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 12, line 252)
> -- Date range filtering / WHERE e.HireDate >= DATEADD(YEAR, -2, GETDATE()) / WHERE YEAR(e.HireDate) = 2020

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 13, line 273)
> -- Scalar subquery / WHERE e.BaseSalary > (SELECT AVG(e.BaseSalary) FROM Employees e) / -- EXISTS subquery

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 14, line 301)
> -- Dynamic filtering based on parameter / DECLARE @FilterType NVARCHAR(20) = 'HighSalary'; / SELECT e.FirstName, e.LastName, e.BaseSalary

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 15, line 333)
> -- SARGable (good) / WHERE e.HireDate >= '2020-01-01' / -- Non-SARGable (poor performance)

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 16, line 346)
> -- Function on indexed column (non-SARGable) / WHERE UPPER(e.LastName) = 'SMITH' / -- Better: WHERE e.LastName = 'smith' (with appropriate collation)

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 17, line 369)
> -- Filtering before JOIN (usually better) / SELECT e.FirstName, e.LastName, d.DepartmentName / FROM (

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 18, line 390)
> -- Row numbering with custom sort / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 19, line 420)
> -- Efficient pagination / WITH EmployeePage AS ( / SELECT

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 20, line 441)
> -- Today's records / WHERE CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE) / -- Better: WHERE CreatedDate >= CAST(GETDATE() AS DATE)

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 21, line 463)
> -- Full-text search (if available) / WHERE CONTAINS(Description, 'database OR query') / WHERE FREETEXT(Description, 'database management system')

✅ **tech company/untitled/Presentations/Module5_Theory_Presentation.md** (block 22, line 481)
> -- Optional parameters / DECLARE @Department NVARCHAR(50) = NULL; / DECLARE @MinSalary MONEY = NULL;

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 1, line 28)
> -- Integer type comparison with storage and range / CREATE TABLE NumericComparison ( / TinyIntCol    TINYINT,      -- 1 byte: 0 to 255

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 2, line 47)
> -- Precise decimal arithmetic / DECLARE @Price DECIMAL(10,2) = 19.99; / DECLARE @TaxRate DECIMAL(5,4) = 0.0875;

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 3, line 66)
> -- Float and Real precision issues / DECLARE @Float FLOAT = 0.1; / DECLARE @Real REAL = 0.1;

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 4, line 92)
> -- Storage and performance implications / CREATE TABLE CharacterComparison ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 5, line 120)
> -- Unicode string handling / DECLARE @EnglishText NVARCHAR(50) = N'Hello World'; / DECLARE @ChineseText NVARCHAR(50) = N'你好世界';

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 6, line 139)
> -- Collation-sensitive operations / CREATE TABLE CompanyNames ( / CustomerID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 7, line 167)
> -- Modern date/time types (SQL Server 2008+) / CREATE TABLE DateTimeComparison ( / EventID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 8, line 202)
> -- Advanced date arithmetic for business scenarios / DECLARE @OrderDate DATE = '2023-06-15'; / DECLARE @PaymentTerms INT = 30; -- Net 30 days

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 9, line 241)
> -- XML data type usage / CREATE TABLE ProductCatalog ( / ProductID INT PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 10, line 282)
> -- JSON data handling / CREATE TABLE CustomerProfiles ( / CustomerID INT PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 11, line 317)
> -- Spatial data for location-based applications / CREATE TABLE StoreLocations ( / StoreID INT PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 12, line 356)
> -- Data type precedence hierarchy demonstration / SELECT / -- Implicit conversions (automatic)

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 13, line 373)
> -- Performance comparison: implicit vs explicit conversions / CREATE TABLE ConversionTest ( / ID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 14, line 404)
> -- Efficient data type selection examples / CREATE TABLE OptimizedEmployees ( / EmployeeID INT IDENTITY(1,1) PRIMARY KEY,  -- 4 bytes, sufficient range

✅ **tech company/untitled/Presentations/Module6_Enhanced_Theory_Presentation.md** (block 15, line 439)
> -- Data type matching for optimal join performance / CREATE TABLE Orders ( / OrderID INT PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 1, line 42)
> -- Integer types by range and storage / TINYINT     -- 0 to 255 (1 byte) / SMALLINT    -- -32,768 to 32,767 (2 bytes)

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 2, line 62)
> -- DECIMAL/NUMERIC (identical functionality) / DECIMAL(precision, scale) / NUMERIC(precision, scale)

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 3, line 84)
> -- Floating point types / FLOAT(n)     -- n = 1-53 (precision in bits) / REAL         -- Equivalent to FLOAT(24)

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 4, line 102)
> -- Fixed length / CHAR(n)      -- Always uses n bytes (space-padded) / -- Variable length

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 5, line 123)
> -- Unicode types (2 bytes per character) / NCHAR(n)      -- Fixed length Unicode / NVARCHAR(n)   -- Variable length Unicode

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 6, line 142)
> -- Storage calculations / CHAR(10)        -- Always 10 bytes / VARCHAR(10)     -- 1-10 bytes + 2 bytes overhead

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 7, line 163)
> -- Legacy types (avoid for new development) / DATETIME     -- 1753-9999, 3.33ms accuracy, 8 bytes / SMALLDATETIME -- 1900-2079, 1 minute accuracy, 4 bytes

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 8, line 182)
> -- DATE type advantages / CREATE TABLE Events ( / EventID INT IDENTITY,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 9, line 205)
> -- TIME type usage / CREATE TABLE Schedule ( / ScheduleID INT IDENTITY,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 10, line 229)
> -- DATETIME2 advantages over DATETIME / CREATE TABLE Audit ( / AuditID INT IDENTITY,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 11, line 252)
> -- Global timestamp storage / CREATE TABLE GlobalEvents ( / EventID INT IDENTITY,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 12, line 273)
> -- Binary types / BINARY(n)       -- Fixed length binary / VARBINARY(n)    -- Variable length binary

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 13, line 296)
> -- UNIQUEIDENTIFIER (GUID) / CustomerID UNIQUEIDENTIFIER DEFAULT NEWID(), / RowGuid UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID()

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 14, line 315)
> -- CAST (ANSI standard) / SELECT / CAST(e.BaseSalary AS VARCHAR(20)) AS SalaryText,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 15, line 334)
> -- TRY_ functions (SQL Server 2012+) / SELECT / TRY_CAST('ABC' AS INT) AS SafeCast,           -- Returns NULL

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 16, line 356)
> -- Implicit conversion (automatic) / SELECT e.EmployeeID + '1'  -- INT + VARCHAR → VARCHAR result / -- Data type precedence (highest to lowest):

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 17, line 377)
> -- String functions with different data types / SELECT / LEN(e.FirstName) AS NameLength,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 18, line 395)
> -- Date arithmetic and formatting / SELECT / GETDATE() AS CurrentDateTime,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 19, line 421)
> -- Numeric functions / SELECT / ABS(-42) AS AbsoluteValue,

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 20, line 442)
> -- Storage and performance comparison / -- Smaller data types = better performance / -- Index efficiency

✅ **tech company/untitled/Presentations/Module6_Theory_Presentation.md** (block 21, line 467)
> -- Mistake 1: Wrong precision / Price DECIMAL(5,2)  -- Only up to 999.99 - too small for products / -- Mistake 2: Using deprecated types

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 1, line 29)
> -- Comprehensive string processing examples / DECLARE @SampleText NVARCHAR(100) = N'  John Michael Smith, Jr.  '; / DECLARE @WorkEmail NVARCHAR(100) = N'john.smith@company.com';

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 2, line 63)
> -- Complex pattern matching and validation / CREATE TABLE CustomerData ( / CustomerID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 3, line 117)
> -- String splitting techniques (SQL Server 2016+ has STRING_SPLIT) / DECLARE @DelimitedString NVARCHAR(200) = 'Apple,Orange,Banana,Grape,Pineapple'; / -- Using STRING_SPLIT (SQL Server 2016+)

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 4, line 160)
> -- Comprehensive date function examples / DECLARE @CurrentDate DATETIME2 = SYSDATETIME(); / DECLARE @BirthDate DATE = '1990-05-15';

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 5, line 200)
> -- Business-specific date calculations / DECLARE @ProjectStartDate DATE = '2023-06-15'; / DECLARE @BusinessDays INT = 45;

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 6, line 242)
> -- Date formatting examples / DECLARE @SampleDate DATETIME2 = '2023-12-25 14:30:45.123'; / SELECT

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 7, line 279)
> -- Mathematical function examples / DECLARE @Price DECIMAL(10,2) = 19.99; / DECLARE @Quantity INT = 7;

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 8, line 321)
> -- Create sample data for statistical analysis / WITH SalesData AS ( / SELECT 'Q1' AS Quarter, 'North' AS Region, 15000 AS Sales UNION ALL

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 9, line 385)
> -- Comprehensive conversion examples / DECLARE @StringNumber VARCHAR(20) = '123.45'; / DECLARE @StringDate VARCHAR(20) = '2023-12-25';

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 10, line 415)
> -- Advanced formatting examples / DECLARE @SampleNumber DECIMAL(15,2) = 1234567.89; / DECLARE @SampleDate DATETIME2 = '2023-12-25 14:30:45';

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 11, line 458)
> -- Create scalar function for business calculations / CREATE FUNCTION dbo.CalculateNetPrice( / @BaseSalary DECIMAL(10,2),

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 12, line 492)
> -- Create table-valued function for flexible reporting / CREATE FUNCTION dbo.GetSalesByDateRange( / @StartDate DATE,

✅ **tech company/untitled/Presentations/Module7_Enhanced_Theory_Presentation.md** (block 13, line 537)
> -- Performance comparison: Function vs Inline calculation / -- BAD: Scalar UDF in SELECT (called for every row) / SELECT

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 1, line 30)
> -- Basic INSERT syntax / INSERT INTO table_name (column_list) / VALUES (value_list);

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 2, line 52)
> -- All columns (not recommended in production) / INSERT INTO Employees / VALUES (4001, 'John', 'Smith', 'john.smith@techcorp.com', '2023-01-15', 75000);

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 3, line 71)
> -- Table with IDENTITY column / CREATE TABLE Employees ( / e.EmployeeID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 4, line 93)
> -- Multiple VALUES / INSERT INTO Employees (e.FirstName, e.LastName, d.DepartmentID, e.BaseSalary) / VALUES

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 5, line 120)
> -- Basic UPDATE syntax / UPDATE table_name / SET column1 = value1,

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 6, line 142)
> -- UPDATE with INNER JOIN / UPDATE e / SET e.BaseSalary = e.BaseSalary * (1 + d.BonusMultiplier),

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 7, line 168)
> -- CASE expressions in UPDATE / UPDATE Employees / SET SalaryBand =

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 8, line 196)
> -- Basic DELETE syntax / DELETE FROM table_name / WHERE condition;

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 9, line 222)
> -- DELETE with JOIN (SQL Server syntax) / DELETE e / FROM Employees e

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 10, line 245)
> -- Soft delete implementation / UPDATE Employees / SET IsActive = 0,

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 11, line 271)
> -- DELETE (slower, logged, can rollback) / DELETE FROM StagingTable; / -- TRUNCATE (faster, minimally logged, cannot rollback easily)

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 12, line 291)
> -- MERGE syntax overview / MERGE target_table AS target / USING source_table AS source

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 13, line 311)
> -- Employee data synchronization / MERGE Employees AS target / USING EmployeeUpdates AS source

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 14, line 336)
> -- INSERT with OUTPUT / INSERT INTO Employees (e.FirstName, e.LastName, d.DepartmentID, e.BaseSalary) / OUTPUT INSERTED.e.EmployeeID, INSERTED.e.FirstName, INSERTED.e.LastName

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 15, line 363)
> -- Explicit transaction / BEGIN TRANSACTION; / -- Multiple DML operations

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 16, line 400)
> -- Lock hints for specific scenarios / SELECT * FROM Employees e WITH (NOLOCK);  -- Read uncommitted / UPDATE Employees WITH (ROWLOCK)

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 17, line 429)
> -- Error handling with TRY-CATCH / BEGIN TRY / INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, d.DepartmentID)

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 18, line 454)
> -- PRIMARY KEY constraint / -- Prevents duplicate keys during INSERT / -- FOREIGN KEY constraint

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 19, line 480)
> -- Stored procedure for employee management / CREATE PROCEDURE sp_AddEmployee / @e.FirstName NVARCHAR(50),

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 20, line 515)
> -- Batch processing for large updates / DECLARE @BatchSize INT = 1000; / DECLARE @RowsUpdated INT = @BatchSize;

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 21, line 544)
> -- Input validation before DML / IF @e.BaseSalary < 0 OR @e.BaseSalary > 1000000 / BEGIN

✅ **tech company/untitled/Presentations/Module7_Theory_Presentation.md** (block 22, line 572)
> -- Mistake 1: Missing WHERE clause / UPDATE Employees SET e.BaseSalary = 100000;  -- Updates ALL employees! / -- Mistake 2: Incorrect JOIN in UPDATE/DELETE

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 1, line 28)
> -- Complete GROUP BY query structure and processing order / SELECT / -- 5. SELECT: Project aggregated results

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 2, line 55)
> -- Understanding GROUP BY rules and valid expressions / CREATE TABLE SalesData ( / SaleID INT IDENTITY(1,1) PRIMARY KEY,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 3, line 104)
> -- Comprehensive aggregate function examples / WITH ProductSales AS ( / SELECT 'Electronics' AS Category, 'Laptop' AS Product, 1200.00 AS Price, 5 AS UnitsSold UNION ALL

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 4, line 150)
> -- String aggregation using STRING_AGG (SQL Server 2017+) / SELECT / Category,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 5, line 184)
> -- ROLLUP for hierarchical subtotals / WITH SalesHierarchy AS ( / SELECT 'North' AS Region, 'Electronics' AS Category, 'Laptop' AS Product, 15000.00 AS Sales UNION ALL

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 6, line 220)
> -- CUBE for all possible combinations / SELECT / Region,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 7, line 243)
> -- GROUPING SETS for specific combinations / SELECT / Region,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 8, line 276)
> -- Complex HAVING clause scenarios / SELECT d.DepartmentName, / e.JobTitle,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 9, line 302)
> -- Advanced conditional aggregation / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 10, line 335)
> -- Comprehensive ranking function examples / WITH EmployeeRankings AS ( / SELECT

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 11, line 384)
> -- Advanced analytical window functions / WITH MonthlySales AS ( / SELECT

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 12, line 475)
> -- Optimize common aggregation patterns with proper indexing / -- Query pattern: Sales summary by date and salesperson / SELECT

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 13, line 504)
> -- Create indexed view for frequently used aggregations / CREATE VIEW dbo.vw_MonthlySalesSummary / WITH SCHEMABINDING

✅ **tech company/untitled/Presentations/Module8_Enhanced_Theory_Presentation.md** (block 14, line 537)
> -- Performance comparison: Different aggregation approaches / -- Approach 1: Single pass with CASE expressions (Efficient) / SELECT d.DepartmentName,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 1, line 31)
> -- Complex string operations / SELECT / -- Extract domain from email

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 2, line 56)
> -- PATINDEX for pattern matching / SELECT / e.FirstName,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 3, line 82)
> -- STRING_AGG (SQL Server 2017+) / SELECT / DepartmentID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 4, line 114)
> -- Business day calculations / SELECT / @StartDate AS StartDate,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 5, line 141)
> -- FORMAT function (SQL Server 2012+) / SELECT / OrderDate,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 6, line 164)
> -- Working with DATETIMEOFFSET / SELECT / EventTime,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 7, line 189)
> -- Advanced mathematical operations / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 8, line 219)
> -- Safe conversion with error handling / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 9, line 248)
> -- IIF function (SQL Server 2012+) / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 10, line 273)
> -- System information functions / SELECT / @@VERSION AS SQLServerVersion,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 11, line 304)
> -- Window functions with built-in functions / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 12, line 333)
> -- Error information functions / BEGIN TRY / -- Some operation that might fail

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 13, line 372)
> -- SARGable vs Non-SARGable predicates / -- BAD: Function on indexed column / WHERE YEAR(e.HireDate) = 2023                    -- Non-SARGable

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 14, line 396)
> -- Complex nested functions / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 15, line 432)
> -- Scalar User-Defined Function / CREATE FUNCTION dbo.CalculateAge(@BirthDate DATE) / RETURNS INT

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 16, line 475)
> -- Performance comparison / -- Slow: Scalar UDF in SELECT / SELECT e.EmployeeID, dbo.ComplexCalculation(e.BaseSalary) FROM Employees e;

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 17, line 489)
> -- Grant permissions on functions / GRANT EXECUTE ON dbo.CalculateAge TO [SalesRole]; / GRANT SELECT ON dbo.GetEmployeesInDepartment TO [ManagerRole];

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 18, line 518)
> -- Cross-database function calls / SELECT dbo.CalculateBusinessDays(StartDate, EndDate) / FROM [AnotherDatabase].dbo.Projects;

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 19, line 541)
> -- Unit testing approach / -- Test edge cases / SELECT dbo.CalculateAge('1900-01-01') AS EdgeCase1;

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 20, line 572)
> -- Statistical aggregate functions / SELECT / DepartmentID,

✅ **tech company/untitled/Presentations/Module8_Theory_Presentation.md** (block 21, line 597)
> -- Business rule implementation with functions / SELECT / OrderID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 1, line 28)
> -- Scalar subquery examples (return single value) / SELECT / ProductID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 2, line 58)
> -- Multi-value subqueries (return multiple values) / SELECT / CustomerID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 3, line 99)
> -- Correlated subqueries (reference outer query) / SELECT / e1.e.EmployeeID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 4, line 135)
> -- EXISTS approach (often more efficient) / SELECT DISTINCT c.CustomerID, c.CustomerName / FROM Customers c

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 5, line 187)
> -- Multiple CTEs for complex business logic / WITH HighValueCustomers AS ( / -- CTE 1: Identify high-value customers

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 6, line 253)
> -- Recursive CTE for organizational hierarchy / WITH EmployeeHierarchy AS ( / -- Anchor member: Top-level managers (no manager)

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 7, line 304)
> -- Recursive CTE for running calculations / WITH MonthlySalesRecursive AS ( / -- Base case: First month

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 8, line 358)
> -- Top performers in each category using subqueries / SELECT / CategoryID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 9, line 407)
> -- Advanced conditional aggregation using subqueries / WITH CustomerAnalysis AS ( / SELECT

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 10, line 501)
> -- Subquery approach (potentially less efficient) / SELECT / p.ProductID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 11, line 540)
> -- Correlated subquery approach (less efficient) / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 12, line 571)
> -- Scenario 1: CTE approach (good for readability, may execute multiple times) / WITH SalesAnalysis AS ( / SELECT

✅ **tech company/untitled/Presentations/Module9_Enhanced_Theory_Presentation.md** (block 13, line 634)
> -- Complex analytical query combining multiple subquery patterns / WITH CustomerMetrics AS ( / -- Base customer metrics

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 1, line 30)
> -- Comprehensive aggregate analysis / SELECT / d.DepartmentID,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 2, line 59)
> -- Percentile and distribution analysis / SELECT / Industry,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 3, line 85)
> -- Single dimension grouping / SELECT d.DepartmentName, / COUNT(*) AS EmployeeCount,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 4, line 113)
> -- Hierarchical grouping with ROLLUP / SELECT / ISNULL(Industry, 'ALL INDUSTRIES') AS Industry,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 5, line 141)
> -- Strategic filtering on aggregated data / SELECT / d.DepartmentID,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 6, line 165)
> -- Multi-criteria strategic analysis / SELECT / c.IndustryID,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 7, line 191)
> -- Combining aggregates with window functions / SELECT / e.EmployeeID,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 8, line 222)
> -- Monthly performance trending / SELECT / YEAR(p.StartDate) AS ProjectYear,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 9, line 257)
> -- Conditional aggregation for complex business metrics / SELECT / d.DepartmentID,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 10, line 290)
> -- STRING_AGG for comprehensive reporting (SQL Server 2017+) / SELECT / c.CompanyName,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 11, line 319)
> -- Optimized aggregation strategies / -- 1. Use covering indexes / CREATE INDEX IX_Employees_Covering ON Employees (d.DepartmentID, IsActive)

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 12, line 348)
> -- Mistake 1: Non-aggregate columns not in GROUP BY / SELECT d.DepartmentID, e.FirstName, COUNT(*)  -- ERROR: e.FirstName not in GROUP BY / FROM Employees e GROUP BY DepartmentIDID;

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 13, line 374)
> -- Customer segmentation analysis / WITH CustomerMetrics AS ( / SELECT

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 14, line 416)
> -- Growth trend analysis using aggregations / WITH MonthlyMetrics AS ( / SELECT

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 15, line 479)
> -- Comprehensive executive summary / WITH ExecutiveSummary AS ( / -- d.DepartmentName performance

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 16, line 543)
> -- Data quality checks using aggregations / SELECT / 'Data Quality Report' AS ReportType,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 17, line 575)
> -- Stored procedure for comprehensive business reporting / CREATE PROCEDURE sp_ExecutiveReport / @StartDate DATE = NULL,

✅ **tech company/untitled/Presentations/Module9_Theory_Presentation.md** (block 18, line 674)
> -- Integration patterns for modern BI tools / -- Power BI, Tableau, QlikView connectivity / CREATE VIEW vw_ExecutiveDashboard AS

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 1, line 39)
> -- Database creation with proper file structure / CREATE DATABASE TechCorpDB / -- Comprehensive schema with 12+ interconnected tables

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 2, line 47)
> -- Core business queries using TechCorp data / SELECT * FROM Companies WHERE AnnualRevenue > 10000000; / SELECT * FROM Employees e WHERE e.HireDate > '2020-01-01';

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 3, line 54)
> -- Column aliases and CASE expressions with TechCorp context / SELECT / e.FirstName + ' ' + e.LastName AS FullName,

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 4, line 67)
> -- Complex JOINs across TechCorp business entities / SELECT / c.CompanyName,

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 5, line 83)
> -- Advanced filtering with business logic / SELECT TOP 10 / e.FirstName + ' ' + e.LastName AS TopPerformer,

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 6, line 99)
> -- Complex data type scenarios with TechCorp business data / -- Financial precision: DECIMAL(15,2) for revenue, DECIMAL(10,2) for salaries / -- Geographic precision: DECIMAL(10,8) for latitude, DECIMAL(11,8) for longitude

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 7, line 108)
> -- Complex INSERT/UPDATE/DELETE operations / -- Employee lifecycle management / -- Project assignment workflows

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 8, line 117)
> -- Advanced string manipulation for data cleansing / -- Complex date/time calculations for business intelligence / -- Mathematical functions for financial analysis

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 9, line 128)
> -- Board-level financial performance reporting / -- Multi-dimensional business analysis / -- Statistical aggregations for executive decision-making

✅ **tech company/untitled/TechCorp_Curriculum_Overview.md** (block 10, line 139)
> -- Capstone integration lab: Strategic Intelligence Command Center / -- Combines aggregate functions, GROUP BY, HAVING, and predictive analytics / -- Executive dashboards, competitive intelligence, and forecasting

✅ **tech company/untitled/TechCorp_Tutorial_Progression.md** (block 1, line 37)
> -- Beginner: Simple system information / SELECT @@SERVERNAME as ServerName; / -- Explanation: "This tells you the name of your database server -

✅ **tech company/untitled/TechCorp_Tutorial_Progression.md** (block 2, line 64)
> -- Beginner: Show all employees / SELECT * FROM Employees e; / -- Explanation: "This shows you everyone who works at TechCorp"

✅ **tech company/untitled/TechCorp_Tutorial_Progression.md** (block 3, line 95)
> -- Intermediate: Professional reporting / SELECT / CASE

✅ **tech company/untitled/TechCorp_Tutorial_Progression.md** (block 4, line 127)
> -- Intermediate to Advanced: Multi-table business analysis / SELECT / c.CompanyName as Client,

✅ **tech company/untitled/TechCorp_Tutorial_Progression.md** (block 5, line 157)
> -- Advanced: Complex business intelligence query / SELECT TOP 10 / e.FirstName + ' ' + e.LastName AS TopPerformer,
