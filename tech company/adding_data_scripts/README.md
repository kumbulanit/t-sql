# TechCorp Database - Modular Setup Scripts

## ⚠️ Important Notice

**For most users, we recommend using the master setup file instead:**
- `../00_TechCorp_MASTER_Setup.sql` (in parent folder)

This folder contains **modular component scripts** for advanced users who prefer to run setup in separate steps.

---

## 📋 Script Execution Order

### **Recommended: Single-File Setup**
Use the master script in the parent folder:
```sql
-- Execute in SQL Server Management Studio (SSMS)
-- File: ../00_TechCorp_MASTER_Setup.sql
-- One file, complete setup, ready in seconds!
```

### **Alternative: Step-by-Step Modular Setup**
If you prefer running individual components, execute these scripts in this exact order:

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

---

## 📂 Folder Contents

### Current Scripts (01-13)
Component scripts listed above that build the database incrementally.

### Archive Folder
Historical development scripts:
- **archive/fix_scripts/** - Column fixes, enhancements, validation scripts
- **archive/test_scripts/** - Test queries from development
- **archive/documentation/** - Development notes and guides

⚠️ Archive files are for reference only. All enhancements are already in the master setup.

---

## 🎯 When to Use Modular Scripts

Use these modular scripts if you:
- Want to understand the database build process step-by-step
- Need to customize specific components
- Are teaching database design and want to show progressive building
- Want to run only specific portions of the setup

---

## ✅ Advantages of Master Setup

The master file (`../00_TechCorp_MASTER_Setup.sql`) is recommended because it:
- ✅ Runs in one execution (no manual ordering)
- ✅ Includes all latest enhancements (November 25, 2025)
- ✅ Has complete error handling and cleanup
- ✅ Includes verification queries
- ✅ Handles foreign key dependencies automatically
- ✅ Synchronizes alias columns (ManagerID, Phone, PlannedEndDate)

---

## 🔍 Comparison

| Feature | Master Setup | Modular Scripts |
|---------|-------------|-----------------|
| **Execution** | Single file | 13 separate files |
| **Time** | ~10 seconds | ~5 minutes |
| **Complexity** | Simple | Must follow exact order |
| **Risk** | Low | Higher (if order wrong) |
| **Latest Enhancements** | ✅ Included | ⚠️ May need updates |
| **Best For** | Production, Training | Learning, Customization |

---

## 📚 Additional Resources

- **Parent Folder README:** See `../README.md` for complete database documentation
- **Training Modules:** See `../../untitled/` for 18 progressive SQL modules
- **Exercises:** See `../../exercises/` for practice questions and solutions

---

**Recommendation:** Start with `../00_TechCorp_MASTER_Setup.sql` for the best experience!

---

Last Updated: December 1, 2025
