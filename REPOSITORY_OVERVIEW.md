# 📚 T-SQL Training Repository - Complete Overview

## 🎯 **Repository Purpose**

This repository is a **comprehensive SQL Server 2016 training program** designed to teach T-SQL (Transact-SQL) from beginner to advanced levels. It provides a complete learning ecosystem with theory, practical exercises, database scripts, and presentation materials.

---

## 🏢 **What's Inside: TechCorp Solutions Training Database**

The repository centers around **TechCorp Solutions**, a fictional technology consulting company used as a realistic business scenario for learning SQL. The database includes:

- **145 employees** across 7 departments
- **15 companies** spanning multiple industries (Technology, Finance, Healthcare, Manufacturing, Energy)
- **$15.5M annual revenue** data
- **Multiple client projects** with team assignments
- **Comprehensive skill tracking** and performance metrics
- **Global operations** across 12 countries

---

## 📂 **Repository Structure**

```
t-sql/
├── README.md                          # Main repository introduction
└── tech company/                      # Main training content directory
    ├── README.md                      # Detailed setup instructions
    ├── 00_TechCorp_Combined_Setup.sql # All-in-one database setup script
    │
    ├── adding_data_scripts/           # Database creation and population
    │   ├── 00_TechCorp_Master_Setup.sql
    │   ├── 01_TechCorp_Database_Creation.sql
    │   ├── 02-13 (various setup scripts)
    │   └── ~38 SQL files total
    │
    ├── exercises/                     # Comprehensive practice exercises
    │   ├── Comprehensive_Beginner_Exercise_Complete.md
    │   └── Progressive_Exercise_Answer_Key_Complete.md
    │
    └── untitled/                      # Training modules and materials
        ├── Module 1 - Introduction to Microsoft SQL Server 2016
        ├── Module 2 - Introduction to T-SQL Querying
        ├── Module 3 - Writing SELECT Queries
        ├── Module 4 - Querying Multiple Tables
        ├── Module 5 - Sorting and Filtering Data
        ├── Module 6 - Working with SQL Server 2016 Data Types
        ├── Module 7 - Using DML to Modify Data
        ├── Module 8 - Using Built-In Functions
        ├── Module 9 - Grouping and Aggregating Data
        ├── Module 10 - Using Subqueries / Data Visualization
        ├── Module 11 - Using Table Expressions
        ├── Module 12 - Using Set Operators
        ├── Module 13 - Using Window Functions
        ├── Module 14 - Pivoting and Grouping Sets
        ├── Module 15 - Executing Stored Procedures
        ├── Module 16 - Programming with T-SQL
        ├── Module 17 - Implementing Error Handling
        ├── Module 18 - Implementing Transactions
        ├── Presentations/             # Training presentation materials
        └── Data_Visualization_and_Reporting/
```

---

## 📖 **Training Curriculum: 18 Comprehensive Modules**

### **Foundation Modules (1-3)**
- **Module 1**: SQL Server Architecture, SSMS, Database Tools
- **Module 2**: T-SQL Fundamentals, Set Theory, Predicate Logic
- **Module 3**: SELECT Statements, DISTINCT, Aliases, CASE Expressions

### **Core Query Skills (4-6)**
- **Module 4**: INNER/OUTER/CROSS Joins, Self Joins, Multi-table Queries
- **Module 5**: ORDER BY, WHERE, TOP, OFFSET-FETCH, NULL Handling
- **Module 6**: Data Types, Type Conversion, Date/Time Operations

### **Data Manipulation (7-9)**
- **Module 7**: INSERT, UPDATE, DELETE, Transaction Management
- **Module 8**: Built-in Functions (String, Math, Date, Logical)
- **Module 9**: GROUP BY, Aggregate Functions, HAVING, Analytics

### **Advanced Querying (10-14)**
- **Module 10**: Subqueries, Data Visualization, Reporting
- **Module 11**: Common Table Expressions (CTEs), Derived Tables
- **Module 12**: UNION, INTERSECT, EXCEPT Set Operations
- **Module 13**: Window Functions, Ranking, LEAD/LAG
- **Module 14**: PIVOT/UNPIVOT, Grouping Sets, ROLLUP, CUBE

### **Professional Development (15-18)**
- **Module 15**: Stored Procedures, Parameters, Return Values
- **Module 16**: T-SQL Programming (Variables, Loops, Cursors)
- **Module 17**: Error Handling (TRY/CATCH, THROW)
- **Module 18**: Transaction Management, Locking, Isolation Levels

---

## 📊 **Content Statistics**

- **~272 Markdown files** - Lessons, labs, exercises, presentations
- **~38 SQL scripts** - Database setup and data population
- **18 complete modules** - Progressive learning path
- **Multiple skill levels** - Beginner, Intermediate, Advanced versions of many lessons
- **Comprehensive presentations** - ~382KB of training materials

---

## 🚀 **Getting Started**

### **Prerequisites**
- SQL Server 2016 or later
- SQL Server Management Studio (SSMS)
- Database CREATE permissions
- ~50MB disk space

### **Quick Setup (3 Steps)**

1. **Clone this repository**
   ```bash
   git clone https://github.com/kumbulanit/t-sql.git
   cd t-sql
   ```

2. **Open SQL Server Management Studio (SSMS)**
   - Connect to your SQL Server instance

3. **Run the setup script**
   ```sql
   -- In SSMS, open and execute:
   :r "tech company/00_TechCorp_Combined_Setup.sql"
   
   -- OR run the master setup:
   :r "tech company/adding_data_scripts/00_TechCorp_Master_Setup.sql"
   ```

### **Verify Installation**
```sql
-- Check that tables were created
USE TechCorpDB;
GO

SELECT 'Companies' as TableName, COUNT(*) as RecordCount FROM Companies
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL  
SELECT 'Departments', COUNT(*) FROM Departments;

-- Should return:
-- Companies: 15 records
-- Employees: 65+ records
-- Departments: 60+ records
```

---

## 🎓 **How to Use This Repository**

### **For Learners**
1. Start with Module 1 materials in `tech company/untitled/Module 1 - Introduction to Microsoft SQL Server 2016/`
2. Read the lesson markdown files (start with `Lesson1_*.md`)
3. Complete the exercises and labs
4. Practice with the TechCorp database
5. Check your answers against the answer keys
6. Progress through modules sequentially

### **For Instructors**
1. Use the comprehensive presentations in `tech company/untitled/Presentations/`
2. Each presentation includes theory, examples, and best practices
3. Enhanced versions available for deep-dive sessions
4. Assign exercises from the `exercises/` directory
5. Adapt content to match student skill levels (Beginner/Advanced versions available)

### **For Self-Study**
1. Set up the TechCorp database
2. Follow the progressive curriculum from Module 1 to Module 18
3. Practice all SQL queries in the lessons
4. Complete the comprehensive exercises
5. Review presentations for deeper understanding

---

## 💼 **The TechCorp Solutions Database**

### **Business Domain Coverage**

The database simulates a real technology consulting firm with:

- **Core Tables**: Companies, Departments, Employees, Countries
- **Lookup Tables**: Industries, SkillCategories, JobLevels, ProjectTypes
- **Advanced Tables**: Skills, Projects, EmployeeSkills, ProjectAssignments
- **Analytics Tables**: PerformanceMetrics, TimeTracking

### **Realistic Data**

- **Salary ranges**: $25K (interns) to $485K (VPs)
- **Geographic diversity**: 12 countries with coordinates
- **Industry variety**: Technology, Finance, Healthcare, Manufacturing, Energy
- **Skills tracking**: 35+ technical and business skills across 8 categories
- **Employee hierarchy**: Multiple management levels with reporting relationships
- **Project data**: Real-world project scenarios with team assignments

### **Query Examples Supported**

Every type of SQL query is demonstrated:
- Simple SELECT statements
- Complex multi-table JOINs (6+ tables)
- Aggregations and analytics (GROUP BY, window functions)
- Subqueries and CTEs
- Data modifications (INSERT, UPDATE, DELETE)
- Advanced features (PIVOT, window functions, transactions)

---

## 📝 **Key Features**

### ✅ **Comprehensive Coverage**
- Complete SQL Server 2016 curriculum
- Theory + Practice + Real-world scenarios
- Beginner to Advanced progression

### ✅ **Progressive Learning**
- 18 modules building on each other
- Multiple difficulty levels for most lessons
- Scaffolded exercises with answer keys

### ✅ **Professional Quality**
- Industry-standard best practices
- Performance optimization techniques
- Real business scenarios and use cases

### ✅ **Rich Training Materials**
- Detailed lesson plans
- Hands-on labs and exercises
- Comprehensive presentations
- Complete answer keys

### ✅ **Ready-to-Use Database**
- One-click setup scripts
- Realistic, interconnected data
- Supports all training exercises
- ~145 employees, 15 companies, multiple projects

---

## 🎯 **Learning Outcomes**

After completing this training, you will be able to:

- ✅ Design and query relational databases efficiently
- ✅ Write complex T-SQL queries with multiple JOINs
- ✅ Use advanced features (window functions, CTEs, pivoting)
- ✅ Optimize query performance and understand execution plans
- ✅ Implement error handling and transaction management
- ✅ Create stored procedures and T-SQL programs
- ✅ Perform business analytics and reporting
- ✅ Apply SQL Server best practices in professional environments

---

## 🔧 **Technical Requirements**

### **Minimum Requirements**
- SQL Server 2016 or later (Express Edition is sufficient)
- SQL Server Management Studio (SSMS)
- Windows OS (or SQL Server on Linux)
- 4GB RAM minimum
- ~50MB disk space for database

### **Recommended Setup**
- SQL Server 2016 Developer Edition (free)
- Latest version of SSMS
- 8GB+ RAM for better performance
- SSD storage for optimal query execution

---

## 📚 **Additional Resources**

### **Module Structure**
Each module typically contains:
- `Lesson#_TopicName.md` - Core lesson content
- `Lesson#_TopicName_Beginner.md` - Simplified version
- `Lesson#_TopicName_Advanced.md` - Deep-dive version
- `Lab_*.md` - Hands-on practical exercises
- `Module#_Exercises.md` - Practice questions
- `Module#_Exercise_Answers.md` - Solution keys

### **Presentations Folder**
- Theory presentations for each module
- Enhanced presentations with deep technical content
- Individual presentation guides
- Real-world examples and use cases

---

## 🎓 **Target Audience**

This repository is perfect for:

- **Database Administrators** - Learn T-SQL fundamentals and administration
- **Developers** - Master SQL for application development
- **Data Analysts** - Build analytical and reporting skills
- **Business Intelligence Professionals** - Advanced querying and analytics
- **Students** - Comprehensive academic SQL training
- **Career Changers** - Complete SQL Server bootcamp

---

## 📊 **Training Program Stats**

- **Total Training Hours**: ~120-150 hours (self-paced)
- **Modules**: 18 comprehensive modules
- **Lessons**: 50+ individual lessons
- **Labs**: 30+ hands-on labs
- **Exercises**: 100+ practice questions
- **Presentations**: 23 professional presentation files
- **Database Tables**: 20+ interconnected tables
- **Sample Records**: 200+ realistic business records

---

## 🚦 **Current Repository Status**

- ✅ Complete curriculum (Modules 1-18)
- ✅ Production-ready database scripts
- ✅ Comprehensive exercises with answer keys
- ✅ Professional presentation materials
- ✅ Multiple difficulty levels
- ✅ Ready for immediate use in training

---

## 💡 **Why This Repository Exists**

This repository was created to provide:

1. **A complete, structured SQL Server training program** that takes learners from zero to professional proficiency
2. **Real-world business context** through the TechCorp Solutions database
3. **Hands-on practice** with realistic data and scenarios
4. **Professional training materials** suitable for classroom or self-study
5. **Industry-standard skills** that translate directly to job requirements

---

## 🔗 **Next Steps**

1. **Set up the database** using the setup scripts
2. **Start with Module 1** to build a solid foundation
3. **Complete exercises** to reinforce learning
4. **Progress through modules** at your own pace
5. **Practice regularly** with the TechCorp database
6. **Apply knowledge** to real-world SQL Server projects

---

## 📞 **Support & Questions**

This is a comprehensive, self-contained training program. All materials needed for learning SQL Server 2016 are included in this repository.

For additional help:
- Review the detailed README files in each directory
- Check the presentation materials for theory
- Consult the exercise answer keys
- Refer to official Microsoft SQL Server documentation

---

## ✨ **Summary**

**The kumbulanit/t-sql repository** is a professional-grade SQL Server 2016 training program featuring:

- **18 comprehensive modules** covering beginner to advanced topics
- **TechCorp Solutions database** with realistic business data
- **270+ lesson and exercise files** with detailed content
- **38 SQL setup scripts** for one-click database creation
- **Complete training ecosystem** with theory, practice, and presentations
- **Professional quality** suitable for corporate training or academic courses
- **Self-contained** - everything needed to become proficient in T-SQL

**Ready to master SQL Server? Start with Module 1 and begin your journey! 🚀**
