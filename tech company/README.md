# TechCorp SQL Training Database

## Overview
Complete T-SQL training database with comprehensive business data covering 18 progressive training modules. Perfect for learning SQL from beginner to advanced concepts.

## 🚀 Quick Start

### Master Setup Script
**File:** `00_TechCorp_MASTER_Setup.sql`

This is the **ONLY** file you need to run to set up the entire database.

```sql
-- Run this single file in SQL Server Management Studio (SSMS)
-- It creates everything: database, tables, sample data, and verification queries
```

**What it includes:**
- ✅ Complete database creation and cleanup
- ✅ 22+ tables with full schema definitions
- ✅ 1,500+ rows of realistic sample data
- ✅ Foreign key relationships and constraints
- ✅ Training compatibility aliases (ManagerID, Phone, PlannedEndDate)
- ✅ Advanced tables for Module 11-18 (EmployeeArchive, DepartmentHistory, etc.)
- ✅ Verification queries to confirm setup

**Size:** 1,598 lines | **Last Updated:** November 25, 2025

---

## 📊 Database Schema

### Core Tables
- **Countries** - Lookup table for countries and regions
- **Industries** - Business industry classifications
- **Companies** - 15 companies across multiple industries
- **Departments** - 20+ departments with budgets and locations
- **Employees** - Employee records with full details
- **JobLevels** - Job level classifications with salary ranges

### Skills & Projects
- **Skills** - 30+ technical and soft skills
- **SkillCategories** - Skill classification system
- **Projects** - Active and completed projects
- **EmployeeSkills** - Employee skill proficiency tracking
- **EmployeeProjects** - Project assignment and allocation

### Business Operations
- **Customers** - Business, Enterprise, Government, Individual customers
- **Products** - Products and services catalog
- **Orders** - Sales orders with full lifecycle
- **OrderDetails** - Line items for orders
- **Suppliers** - Supplier relationships
- **ProductSuppliers** - Product-supplier junction table

### Performance & Analytics
- **PerformanceMetrics** - KPI and performance tracking
- **TimeTracking** - Employee time entries
- **EmployeeArchive** - Historical employee records (for UNION operations)
- **DepartmentHistory** - Department change history (for temporal queries)

---

## 📚 Module Coverage

This database supports **all 18 SQL training modules**:

### Beginner (Modules 1-6)
- Module 1-2: Basic SELECT, WHERE, ORDER BY
- Module 3-4: JOIN operations (INNER, LEFT, RIGHT, FULL)
- Module 5-6: Aggregate functions, GROUP BY, HAVING

### Intermediate (Modules 7-12)
- Module 7-8: Subqueries, derived tables
- Module 9-10: Advanced JOINs, self-joins
- Module 11: Set operators (UNION, INTERSECT, EXCEPT)
- Module 12: Common Table Expressions (CTEs)

### Advanced (Modules 13-18)
- Module 13: Window functions (ROW_NUMBER, RANK, PARTITION BY)
- Module 14: Advanced analytics and calculations
- Module 15-16: Stored procedures and functions
- Module 17-18: Performance optimization and indexing

---

## 📁 Folder Structure

```
tech company/
├── 00_TechCorp_MASTER_Setup.sql          ⭐ MASTER SETUP FILE (USE THIS)
├── README.md                              📖 This file
├── adding_data_scripts/                   📂 Modular setup scripts (optional)
│   ├── 01_TechCorp_Database_Creation.sql
│   ├── 02_TechCorp_Table_Creation.sql
│   ├── 03-13_*.sql                       (Component scripts)
│   ├── README.md                          (Documentation for modular approach)
│   └── archive/                           🗄️ Historical fix and test scripts
│       ├── fix_scripts/                   (Column fixes, enhancements, validations)
│       ├── test_scripts/                  (Test queries and validation scripts)
│       └── documentation/                 (Development notes and guides)
├── exercises/                             📝 Training exercises with solutions
│   ├── Comprehensive_Beginner_Exercise_Complete.md
│   └── Progressive_Exercise_Answer_Key_Complete.md
└── untitled/                              🎓 18 Training modules
    ├── Module_01_Basic_SELECT/
    ├── Module_02_Filtering_WHERE/
    ├── ...
    └── Module_18_Performance_Optimization/
```

---

## 🎯 Usage Instructions

### Option 1: Single-File Setup (RECOMMENDED)
```sql
-- Step 1: Open SSMS
-- Step 2: Open 00_TechCorp_MASTER_Setup.sql
-- Step 3: Execute (F5 or Execute button)
-- Step 4: Done! Database is ready for training
```

### Option 2: Modular Setup (Advanced Users)
If you prefer to run component scripts individually, use the files in `adding_data_scripts/` folder:
- Run scripts in numerical order (01, 02, 03... 13)
- See `adding_data_scripts/README.md` for detailed instructions

---

## 🔍 Sample Queries

After setup, verify with these queries:

```sql
-- Check database summary
USE TechCorpDB;
SELECT 'Countries' as TableName, COUNT(*) as RecordCount FROM Countries
UNION ALL SELECT 'Companies', COUNT(*) FROM Companies
UNION ALL SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL SELECT 'Orders', COUNT(*) FROM Orders;

-- View companies by size
SELECT CompanySize, COUNT(*) as CompanyCount, AVG(AnnualRevenue) as AvgRevenue
FROM Companies 
GROUP BY CompanySize
ORDER BY CompanyCount DESC;

-- Employee project assignments
SELECT e.FirstName + ' ' + e.LastName as EmployeeName, 
       p.ProjectName, 
       ep.Role, 
       ep.HoursWorked
FROM Employees e
JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE ep.IsActive = 1
ORDER BY e.LastName;
```

---

## 🛠️ Archive Folder

The `adding_data_scripts/archive/` folder contains historical scripts:

- **fix_scripts/** - Column fixes, schema enhancements, validation scripts (kept for reference)
- **test_scripts/** - Test queries used during development
- **documentation/** - Development notes, enhancement guides, completion reports

⚠️ **Note:** Archive files are for reference only. The master setup file already includes all fixes and enhancements.

---

## 📋 Database Statistics

- **15 Companies** across 7 industries
- **20+ Departments** with full budget tracking
- **7 Leadership Employees** (C-level executives, VPs, Directors)
- **10 Customers** (Business, Enterprise, Government, Individual)
- **10 Products/Services** with pricing and inventory
- **8 Active Projects** with budgets and timelines
- **30+ Skills** across 6 categories
- **20 Employee Skills** assignments with proficiency levels
- **20 Performance Metrics** records
- **10 Time Tracking** entries
- **10 Archived Employees** (for UNION operations - Module 11)
- **7 Department History** records (for temporal queries - Module 11)
- **6 Recent Orders** with order details

---

## 🔄 Updates & Maintenance

**Current Version:** 2.0 (November 25, 2025)

**Recent Enhancements:**
- ✅ Added BonusTarget, EmploymentType, BudgetPeriod columns
- ✅ Training compatibility aliases (ManagerID, Phone, PlannedEndDate)
- ✅ Extended Projects table with BillingType, HourlyRate, Currency
- ✅ Enhanced PerformanceMetrics with Achievement calculations
- ✅ Added EmployeeArchive and DepartmentHistory for advanced modules
- ✅ Complete foreign key relationships and constraints

---

## 🤝 Contributing

This database is designed for SQL training. If you find issues or want to suggest enhancements:
1. Document the issue or enhancement clearly
2. Test with the master setup file
3. Submit changes via pull request

---

## 📞 Support

For questions or issues:
- Review the `exercises/` folder for training examples
- Check the `untitled/` modules for progressive learning content
- Consult `adding_data_scripts/archive/documentation/` for historical context

---

## ⚖️ License

This training database is provided for educational purposes.

---

**Happy Learning! 🎓**
