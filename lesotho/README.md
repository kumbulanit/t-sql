# Central Bank of Lesotho - SQL Training Database
## Research Department - Data Management Division

---

## 📊 Overview

This training database is specifically designed for **economists and statisticians** at the Central Bank of Lesotho's Research Department, focusing on the Data Management Division's work with macroeconomic time series data, econometric analysis, and statistical reporting.

### Purpose
- Train **economists and statisticians** in T-SQL for data warehousing and econometric data management
- Provide realistic scenarios based on CBL's macroeconomic analysis and statistical compilation
- Support enterprise data warehouse development for economic research and policy analysis
- Enable practice with time series analysis, seasonal adjustment, and statistical validation workflows
- Facilitate economic indicator compilation and dissemination for policy makers

---

## 🏦 About the Data Management Division

**Department:** Research Department  
**Division:** Data Management Division  
**Target Audience:** Economists and Statisticians  
**Primary Responsibilities:**
- Collect and curate macroeconomic time series data for econometric analysis
- Compile, validate, and perform statistical quality checks on economic indicators
- Conduct descriptive statistics and trend analysis for policy reports
- Produce macroeconomic reports (Monthly Statistical Bulletin, Quarterly Economic Review)
- Perform seasonal adjustment and time series decomposition
- Calculate economic ratios, indices, and composite indicators
- Disseminate statistical data to policy makers, researchers, and international organizations
- Support econometric modeling and forecasting activities

**Data Sources:**
- Internal: CBL Core Banking, RTGS, Foreign Exchange Division
- Commercial Banks: FNB, Nedbank, Standard Lesotho Bank, CBL Bank
- External: Bureau of Statistics, Lesotho Revenue Authority
- International: IMF, World Bank, SARB

---

## 🚀 Quick Start

### Step 1: Database Setup
Run the master setup script to create the complete database:

```sql
-- Execute in SQL Server Management Studio (SSMS)
-- File: 00_CBL_DataWarehouse_Setup.sql
```

**What it creates:**
- ✅ CBL_DataWarehouse database
- ✅ 15 tables (lookup tables, operational tables, reporting tables)
- ✅ 1,000+ rows of realistic sample data
- ✅ Time series data for 2024
- ✅ Banking statistics (Q1-Q3 2024)
- ✅ Economic indicators and metadata

**Setup Time:** ~30 seconds

### Step 2: Start Training
Begin with Module 1 in the `labs/` folder and progress through modules 1-7.

---

## 📁 Repository Structure

```
lesotho/
├── 00_CBL_DataWarehouse_Setup.sql     ⭐ MASTER SETUP (RUN THIS FIRST)
├── README.md                           📖 This file
└── labs/                               📚 Training exercises
    ├── Module_01_Introduction_to_TSQL_Lab.md
    ├── Module_02_Filtering_and_Sorting_Lab.md
    ├── Module_03_Querying_Multiple_Tables_Lab.md (create this next)
    ├── Module_04_Advanced_JOIN_Operations_Lab.md
    ├── Module_05_Grouping_and_Aggregating_Lab.md
    ├── Module_06_Built_In_Functions_Lab.md
    └── Module_07_DML_Modifications_Lab.md
```

---

## 📊 Database Schema

### Lookup/Reference Tables
| Table | Purpose | Records |
|-------|---------|---------|
| **Countries** | Country/currency reference | 12 |
| **DataSources** | Internal/external data sources | 12 |
| **DataFrequencies** | Data collection frequencies | 7 |
| **IndicatorCategories** | Economic indicator categories | 14 |
| **ReportTypes** | Types of macroeconomic reports | 8 |

### Core Operational Tables
| Table | Purpose | Records |
|-------|---------|---------|
| **CommercialBanks** | Registered banks in Lesotho | 5 |
| **EconomicIndicators** | Master list of tracked indicators | 24 |
| **TimeSeriesData** | Actual indicator values over time | 100+ |
| **BankingStatistics** | Monthly/quarterly bank reports | 9 |
| **ExternalDataSubmissions** | Data received from external sources | Sample |

### Reporting & Dissemination Tables
| Table | Purpose | Records |
|-------|---------|---------|
| **MacroeconomicReports** | Published/draft reports | 5 |
| **DataDissemination** | Data sharing log | 8 |
| **ResearchStaff** | Research department staff | 7 |
| **DataQualityChecks** | Quality assurance records | Sample |

---

## 📚 Training Modules

### Module 1: Introduction to T-SQL Querying
**Duration:** 60-90 minutes  
**Topics:**
- Basic SELECT statements
- Column selection and aliases
- Simple calculations
- Expression evaluation

**Key Skills:**
- Query single tables
- Format output for reports
- Perform calculations on financial data
- Create meaningful column aliases

---

### Module 2: Filtering and Sorting Data
**Duration:** 75-100 minutes  
**Topics:**
- WHERE clause filtering
- Comparison operators
- Logical operators (AND, OR, NOT)
- BETWEEN, IN, LIKE operators
- ORDER BY sorting
- NULL handling

**Key Skills:**
- Filter macroeconomic data by date ranges
- Search for specific indicators
- Sort time series data
- Handle missing data appropriately

---

### Module 3: Querying Multiple Tables *(Lab to be created)*
**Duration:** 90-120 minutes  
**Topics:**
- Table relationships and foreign keys
- INNER JOIN operations
- Combining data from multiple sources
- Multi-table queries

**Real-World Applications:**
- Join indicator metadata with time series values
- Combine bank information with statistics
- Link reports to data sources

---

### Module 4: Advanced JOIN Operations *(Lab to be created)*
**Duration:** 90-120 minutes  
**Topics:**
- LEFT/RIGHT OUTER JOINs
- FULL OUTER JOINs
- CROSS JOINs
- Self-joins

**Real-World Applications:**
- Find banks without recent submissions
- Compare current vs previous period data
- Analyze hierarchical indicator categories

---

### Module 5: Grouping and Aggregating Data *(Lab to be created)*
**Duration:** 90-120 minutes  
**Topics:**
- GROUP BY clause
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- HAVING clause
- Statistical calculations

**Real-World Applications:**
- Calculate banking sector totals
- Average inflation rates by quarter
- Count indicators by category
- Summarize data submissions by source

---

### Module 6: Built-In Functions *(Lab to be created)*
**Duration:** 90-120 minutes  
**Topics:**
- String functions
- Date/time functions
- Mathematical functions
- Conversion functions

**Real-World Applications:**
- Format reports with proper date display
- Calculate year-over-year changes
- Round financial figures appropriately
- Extract quarters and years from dates

---

### Module 7: DML - Data Modification *(Lab to be created)*
**Duration:** 90-120 minutes  
**Topics:**
- INSERT statements
- UPDATE statements
- DELETE statements
- Data integrity considerations

**Real-World Applications:**
- Insert new time series data
- Update provisional data to final
- Correct data entry errors
- Manage revision numbers

---

## 🎯 Key Economic Indicators in Database

### Monetary Indicators
- **M1, M2:** Money supply measures
- **Base Rate:** CBL policy rate
- **Lending/Deposit Rates:** Commercial bank rates

### Price Indicators
- **CPI:** Consumer Price Index
- **Inflation Rate:** Annual inflation percentage

### Banking Sector
- **Total Assets/Loans/Deposits:** Banking sector aggregates
- **NPL Ratio:** Non-performing loans ratio
- **CAR:** Capital adequacy ratio

### External Sector
- **FX Reserves:** Foreign exchange reserves (USD)
- **Exchange Rates:** LSL/USD, LSL/ZAR
- **Trade Balance:** Exports minus imports

### Fiscal Indicators
- **Government Revenue/Expenditure**
- **Government Debt**

### Real Sector
- **GDP:** Real and nominal GDP
- **Unemployment Rate**

---

## 💡 Learning Path

### For Complete Beginners
1. Start with Module 1 - Basic SELECT
2. Complete all "Beginner" sections in each module
3. Practice with provided sample queries
4. Complete "Do It Yourself" exercises
5. Progress to Module 2 when comfortable

### For Intermediate Users
1. Review Module 1-2 quickly
2. Focus on "Intermediate" sections
3. Complete real-world scenarios
4. Try creating your own queries
5. Advance to JOIN operations (Module 3-4)

### For Advanced Users
1. Jump to "Advanced" sections in each module
2. Complete challenge exercises
3. Modify queries for different scenarios
4. Combine concepts across modules
5. Create custom analyses and reports

---

## 🔍 Real-World Use Cases

### Daily Operations
- Extract latest exchange rates for reports
- Monitor inflation trends
- Check foreign reserve levels
- Validate banking submissions

### Monthly Reporting
- Compile Monthly Statistical Bulletin
- Calculate month-over-month changes
- Generate banking sector summaries
- Prepare inflation analysis

### Quarterly Analysis
- Aggregate quarterly GDP data
- Analyze banking sector trends
- Compare quarter-over-quarter performance
- Prepare Balance of Payments reports

### Annual Reporting
- Calculate annual averages and totals
- Year-over-year comparisons
- Long-term trend analysis
- Annual Report preparation

---

## 📋 Data Collection Workflow

```
1. DATA COLLECTION
   ├─ Internal Systems (CBL Core Banking, RTGS, FX Division)
   ├─ Commercial Banks (Monthly returns)
   └─ External Sources (BOS, LRA, International Organizations)

2. DATA VALIDATION
   ├─ Completeness checks
   ├─ Accuracy verification
   ├─ Consistency validation
   └─ Quality assurance

3. DATA COMPILATION
   ├─ Insert into TimeSeriesData
   ├─ Update indicator metadata
   ├─ Calculate derived indicators
   └─ Handle revisions

4. REPORT PRODUCTION
   ├─ Query compiled data
   ├─ Generate statistical tables
   ├─ Create analytical charts
   └─ Draft reports

5. DATA DISSEMINATION
   ├─ Internal (Government ministries)
   ├─ External (IMF, World Bank, SARB)
   ├─ Public (Website, publications)
   └─ Media (Press releases)
```

---

## 🛠️ Tools and Technologies

**Required:**
- SQL Server 2016 or later
- SQL Server Management Studio (SSMS)

**Recommended:**
- SQL Server 2019/2022 for latest features
- Azure Data Studio (alternative to SSMS)
- Excel for data visualization

---

## 📖 Additional Learning Resources

### CBL-Specific Documentation
- [Central Bank of Lesotho Website](https://www.centralbank.org.ls)
- Monthly Statistical Bulletins
- Quarterly Economic Reviews
- Annual Reports

### SQL Learning Resources
- Microsoft SQL Server Documentation
- T-SQL Tutorial Sites
- SQL Server Performance Tuning Guides
- Data Warehousing Best Practices

### Statistical Resources
- IMF Data Standards
- SDMX (Statistical Data and Metadata eXchange)
- Time Series Analysis Methods
- Economic Indicator Compilation Guides

---

## 🤝 Best Practices for Data Management

### Data Quality
✅ Always validate data before loading  
✅ Track data lineage (source, collection date)  
✅ Maintain revision history  
✅ Document data definitions  
✅ Implement quality checks

### Database Operations
✅ Use transactions for data modifications  
✅ Backup before major updates  
✅ Test queries on sample data first  
✅ Document complex queries  
✅ Follow naming conventions

### Reporting
✅ Verify data before publication  
✅ Include metadata (sources, dates, notes)  
✅ Maintain consistency across reports  
✅ Archive historical reports  
✅ Track data dissemination

---

## ❓ Frequently Asked Questions

**Q: Why is this database specific to Lesotho?**  
A: It uses realistic scenarios based on CBL operations, Lesotho's banking sector, and actual macroeconomic indicators tracked by the Research Department.

**Q: Can I modify the data for practice?**  
A: Yes! Module 7 covers data modifications. You can always re-run the setup script to reset the database.

**Q: How does this relate to the Enterprise Data Warehouse?**  
A: This training database mirrors the structure and workflows of CBL's planned Enterprise Data Warehouse, providing hands-on experience with similar tables and operations.

**Q: What if I get stuck on an exercise?**  
A: Each module includes solutions, hints, and progressive difficulty levels. Start with beginner sections and advance gradually.

**Q: How long does the full training take?**  
A: Expect 8-12 hours to complete Modules 1-7 at a comfortable pace, including practice exercises.

---

## 🎓 Skills You Will Gain

After completing this training, you will be able to:

✅ Write complex SQL queries for macroeconomic data  
✅ Extract and compile data from multiple sources  
✅ Perform statistical calculations in SQL  
✅ Generate reports from time series data  
✅ Validate and quality-check economic indicators  
✅ Manage data revisions and versions  
✅ Join data from transactional and reference tables  
✅ Create aggregated summaries for publications  
✅ Handle provisional vs final data appropriately  
✅ Support the Enterprise Data Warehouse project

---

## 📞 Support and Feedback

This training material is designed for CBL's Data Management Division. For questions or feedback:

- **Internal Users:** Contact your training coordinator
- **Technical Issues:** IT Department
- **Content Suggestions:** Research Department management

---

## 🔄 Updates and Maintenance

**Current Version:** 1.0 (December 2025)

**Recent Updates:**
- Initial release with 7 training modules
- Complete database schema for macroeconomic data
- Sample data covering 2024 time series
- Real-world scenarios based on CBL operations

---

## ⚖️ Data Usage Policy

This training database contains **sample/dummy data only**. It does not contain actual confidential CBL data. The structure and workflows mirror real operations, but all values are for training purposes only.

---

## 🎉 Getting Started Checklist

Before beginning training:

- [ ] SQL Server installed and accessible
- [ ] SQL Server Management Studio (SSMS) installed
- [ ] `00_CBL_DataWarehouse_Setup.sql` executed successfully
- [ ] Database verified with sample queries
- [ ] Module 1 lab document opened
- [ ] Notebook ready for taking notes

---

**Ready to Begin?**

Start with Module 1 in the `labs/` folder!

---

*Central Bank of Lesotho*  
*Research Department - Data Management Division*  
*Enterprise Data Warehouse Training Series*  
*December 2025*
