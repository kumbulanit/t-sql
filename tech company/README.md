# TechCorp Database - SQL Training Data Scripts

This folder contains comprehensive SQL scripts to create and populate the **TechCorp Solutions** database for SQL Server 2016 training across all modules.

## 📋 Script Execution Order

### **Quick Setup (Recommended)**
Run the master script to create everything at once:
```sql
-- Execute in SQL Server Management Studio (SSMS)
:r "00_TechCorp_Master_Setup.sql"
```

### **Step-by-Step Setup**
Or run individual scripts in this exact order:

1. **`01_TechCorp_Database_Creation.sql`** - Creates the TechCorpDB database
2. **`02_TechCorp_Table_Creation.sql`** - Creates all database tables and relationships
3. **`03_TechCorp_Lookup_Data.sql`** - Populates lookup tables (Countries, Industries, etc.)
4. **`04_TechCorp_Companies_Data.sql`** - Populates company data
5. **`05_TechCorp_Departments_Data.sql`** - Populates department data
6. **`06_TechCorp_Employees_Leadership.sql`** - Populates leadership employees (managers/directors)
7. **`07_TechCorp_Employees_Regular.sql`** - Populates regular employees
8. **`08_TechCorp_Advanced_Tables.sql`** - Creates advanced tables (Skills, Projects, etc.)
9. **`09_TechCorp_Skills_Data.sql`** - Populates skills and project types
10. **`10_TechCorp_Projects_Data.sql`** - Populates real project data with teams
11. **`11_TechCorp_Employee_Skills.sql`** - Assigns skills to employees with proficiency levels
12. **`12_TechCorp_Project_Assignments.sql`** - Assigns employees to projects with roles
13. **`13_TechCorp_Performance_Data.sql`** - Performance metrics and time tracking data

## 🏢 Database Structure Overview

### **Module 1-2 (Foundation Tables)**
- **Countries** (12 records) - Global locations
- **Industries** (12 records) - Business sectors  
- **SkillCategories** (12 records) - Skill classifications
- **JobLevels** (10 records) - Career progression levels

### **Module 2-3 (Core Business)**
- **Companies** (15 records) - Diverse company sizes and industries
- **Departments** (60+ records) - Organizational structure
- **Employees** (65+ records) - Complete employee hierarchy

### **Module 5-7 (Advanced Features)**
- **Skills** (35+ records) - Technical and business skills
- **ProjectTypes** (12 records) - Project classifications
- **Projects** - Real-world project scenarios
- **EmployeeSkills** - Skill proficiency tracking
- **PerformanceMetrics** - Employee performance data

## 🎯 Training Module Support

| Module | Focus Area | Sample Data Available |
|--------|------------|----------------------|
| **Module 1** | SQL Server Architecture | Database files, basic tables |
| **Module 2** | T-SQL Fundamentals | Simple SELECT statements |
| **Module 3** | Basic SELECT | Column aliases, CASE expressions |
| **Module 4** | Multiple Tables | Complex JOINs across 6+ tables |
| **Module 5** | Sorting & Filtering | Advanced WHERE, ORDER BY, TOP |
| **Module 6** | Data Types | Diverse data types and scenarios |
| **Module 7** | DML Operations | INSERT, UPDATE, DELETE scenarios |
| **Module 8** | Functions | Built-in functions with real data |
| **Module 9** | Grouping & Aggregating | Business analytics queries |

## 💼 Business Context: TechCorp Solutions

**TechCorp Solutions** is a fictional technology consulting firm with:
- **145 employees** across 7 departments
- **$15.5M annual revenue**
- **Multiple client projects** spanning various industries
- **Global presence** with international partnerships
- **Comprehensive skill tracking** and performance metrics

### Sample Companies Included:
- **Technology**: TechCorp Solutions, CloudTech Innovations, DevOps Masters
- **Financial**: Global Finance Corp, Investment Partners LLC  
- **Healthcare**: HealthTech Innovations, MedDevice Solutions
- **Manufacturing**: AutoManu Systems, Precision Manufacturing
- **Energy**: EnerTech Global
- **International**: Global Tech Europe (Germany), Asia Pacific Solutions (Singapore)

## 🔍 Data Characteristics

### **Progressive Complexity**
- **Basic**: Simple lookups and reference data
- **Intermediate**: Business relationships and hierarchies  
- **Advanced**: Performance metrics and analytics data

### **Realistic Business Scenarios**
- **BaseSalary ranges**: $25K (interns) to $485K (VPs)
- **Geographic diversity**: 12 countries with coordinates
- **Industry variety**: 12 sectors with risk levels
- **Skill tracking**: 35+ skills across 8 categories

### **Query Examples Supported**
```sql
-- Module 2: Simple queries
SELECT * FROM Companies WHERE AnnualRevenue > 10000000;

-- Module 4: Complex JOINs
SELECT c.CompanyName, e.FirstName + ' ' + e.LastName as Manager
FROM Companies c
    INNER JOIN Departments d ON c.CompanyID = d.CompanyID
    INNER JOIN Employees e ON d.ManagerEmployeeID = e.EmployeeID;

-- Module 9: Advanced analytics
SELECT 
    c.CompanyName,
    COUNT(e.EmployeeID) as EmployeeCount,
    AVG(e.BaseSalary) as AvgSalary,
    MAX(e.BaseSalary) as MaxSalary
FROM Companies c
    LEFT JOIN Employees e ON c.CompanyID = e.CompanyID
GROUP BY c.CompanyID, c.CompanyName
ORDER BY AvgSalary DESC;
```

## 🚀 Getting Started

1. **Open SQL Server Management Studio (SSMS)**
2. **Connect to your SQL Server 2016 instance**
3. **Run the master setup script**: `00_TechCorp_Master_Setup.sql`
4. **Verify setup** with the sample queries provided
5. **Start training** with Module 1 exercises

## 📊 Verification Queries

After setup, verify with these queries:

```sql
-- Check record counts
SELECT 'Companies' as Table, COUNT(*) as Records FROM Companies
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL  
SELECT 'Departments', COUNT(*) FROM Departments;

-- Test relationships
SELECT TOP 5
    e.FirstName + ' ' + e.LastName as Employee,
    d.DepartmentName,
    c.CompanyName
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN Companies c ON e.CompanyID = c.CompanyID;
```

## 🛠️ Technical Requirements

- **SQL Server 2016** or later
- **SQL Server Management Studio (SSMS)**
- **Database permissions** to CREATE DATABASE
- **Approximately 50MB** disk space

## 📞 Support

This database supports all SQL Server 2016 training modules with realistic, interconnected business data that demonstrates real-world scenarios students will encounter in professional environments.

---
**Ready to start your SQL training journey with TechCorp Solutions!** 🚀