# TechCorp Database - Individual Data Scripts

This folder contains the individual SQL scripts that were used to build the TechCorp database incrementally. These scripts have been superseded by the complete `00_TechCorp_Combined_Setup.sql` script in the parent directory.

## 📁 Script Categories

### **Core Setup Scripts (01-13)**
These scripts build the database step by step:

- `01_TechCorp_Database_Creation.sql` - Creates the TechCorpDB database
- `02_TechCorp_Table_Creation.sql` - Creates all table structures
- `03_TechCorp_Lookup_Data.sql` - Populates lookup tables (Countries, Industries, etc.)
- `04_TechCorp_Companies_Data.sql` - Adds company data
- `05_TechCorp_Departments_Data.sql` - Adds d.DepartmentName data
- `06_TechCorp_Employees_Leadership.sql` - Adds leadership employees
- `07_TechCorp_Employees_Regular.sql` - Adds regular employees
- `08_TechCorp_Advanced_Tables.sql` - Creates advanced tables (Skills, Projects, etc.)
- `09_TechCorp_Skills_Data.sql` - Populates skills data
- `10_TechCorp_Projects_Data.sql` - Adds project data
- `11_TechCorp_Employee_Skills.sql` - Links employees to skills
- `12_TechCorp_Project_Assignments.sql` - Assigns employees to projects
- `13_TechCorp_Performance_Data.sql` - Adds performance metrics

### **Alternative Setup Scripts**
- `00_TechCorp_Master_Setup.sql` - Original modular setup using SQLCMD :r commands
- `00_TechCorp_Simple_Setup.sql` - Simplified setup script

### **Troubleshooting & Testing Scripts**
- `TROUBLESHOOT_Companies_Data.sql` - Diagnostic queries for company data issues
- `TEST_Single_Company.sql` - Test script for single company insertion
- `FIX_Companies_Table.sql` - Fixes for company table issues
- `CHECK_Column_Definitions.sql` - Column definition analysis
- `ANALYZE_Data_Lengths.sql` - Data length analysis for truncation issues

## 🚀 Recommended Usage

**For new setups:** Use the `00_TechCorp_Combined_Setup.sql` script in the parent directory instead of these individual scripts.

**For learning/reference:** These scripts show the step-by-step process of building a complex database and can be useful for:
- Understanding database design progression
- Learning modular script organization
- Troubleshooting specific data issues
- Customizing individual components

## 🔧 Historical Context

These scripts were created during the development process to:
1. Build the database incrementally
2. Test individual components
3. Troubleshoot specific data issues (like string truncation errors)
4. Provide modular setup options

The final combined script incorporates all lessons learned from these individual scripts.

## ⚠️ Important Notes

- These scripts require execution in the correct order (01-13)
- Some scripts have dependencies on previous scripts
- The troubleshooting scripts were created to solve specific issues that have been resolved in the combined script
- Column names and table structures in these scripts match the final combined setup