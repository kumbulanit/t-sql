# Archive Folder - Historical Scripts

This folder contains historical development scripts kept for reference purposes only.

## ⚠️ Important Notice

**DO NOT USE THESE SCRIPTS FOR SETUP!**

All fixes, enhancements, and improvements from these scripts have been integrated into the master setup file:
- `../00_TechCorp_MASTER_Setup.sql`

This archive exists solely for historical reference and development tracking.

---

## 📁 Folder Structure

### fix_scripts/
Column fixes, schema enhancements, and validation scripts from the development process.

**Contents:**
- ADD_INDEXES_CONSTRAINTS.sql
- ADD_MISSING_COLUMNS.sql
- COLUMN_ERROR_FIXES.sql
- COLUMN_ISSUES_FINAL_SOLUTION.sql
- COMPLETE_COLUMN_FIX.sql
- COMPREHENSIVE_COLUMN_FIXES.sql
- FIX_Companies_Table.sql
- HOURSWORKED_ISACTIVE_FIXES.sql
- MASTER_COLUMN_ENHANCEMENT.sql
- QUERY_PATTERN_FIXES.sql
- SSMS_COLUMN_FIXES.sql
- TROUBLESHOOT_Companies_Data.sql
- CHECK_Column_Definitions.sql
- SCHEMA_VALIDATION.sql
- TechCorp_Schema_Validation.sql
- VALIDATE_COLUMN_REFERENCES.sql
- ANALYZE_Data_Lengths.sql
- COMPREHENSIVE_MODULE_FIXES.ps1
- DEPLOY_ALL_ENHANCEMENTS.ps1
- Fix-All-Module-Columns.ps1
- Fix-AllModuleColumnReferences.ps1
- Fix-ColumnReferences.ps1

**Purpose:** These scripts were used during development to:
- Fix column reference issues across training modules
- Add missing columns (BonusTarget, EmploymentType, BudgetPeriod, etc.)
- Create training compatibility aliases (ManagerID, Phone, PlannedEndDate)
- Validate schema consistency
- Enhance table structures

### test_scripts/
Test queries and validation scripts used during development.

**Contents:**
- TEST_Single_Company.sql
- test_union_query.sql
- test_your_query.sql

**Purpose:** These scripts were used to:
- Test single company data insertion
- Validate UNION operations
- Verify query patterns

### documentation/
Development notes, enhancement guides, and completion reports.

**Contents:**
- BEGINNER_ENHANCEMENT_GUIDE.md
- ERROR_FIXES.md
- MODULE_7_FIXES_COMPLETED.md
- PROJECT_COMPLETION_REPORT.md
- SCRIPT_INVENTORY.md

**Purpose:** Development documentation tracking:
- Enhancement planning and execution
- Error resolution steps
- Module-specific fix completion
- Project milestones and completion status
- Script inventory and organization

---

## 📅 Timeline

**November 22-25, 2025:** Major schema enhancements
- Added 40+ new columns across multiple tables
- Created training compatibility aliases
- Fixed column reference issues in all 18 modules
- Enhanced PerformanceMetrics, TimeTracking, and Projects tables
- Added EmployeeArchive and DepartmentHistory for advanced modules

**Result:** All enhancements integrated into `00_TechCorp_MASTER_Setup.sql`

---

## 🔍 When to Reference These Files

Reference these archive files only when you need to:
1. Understand the history of schema changes
2. See how specific issues were resolved
3. Review the development process
4. Track enhancement decisions

---

## ✅ Current Best Practice

**For Database Setup:**
Use only `../00_TechCorp_MASTER_Setup.sql` (parent folder)

**For Learning SQL:**
Use the training modules in `../../untitled/` folder

**For Exercises:**
Use the exercises in `../../exercises/` folder

---

Last Updated: December 1, 2025
