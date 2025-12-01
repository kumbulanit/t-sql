# Economist and Statistician Enhancements
## Central Bank of Lesotho SQL Training Materials

### Overview
All training materials have been enhanced with terminology, concepts, and scenarios specifically tailored for **economists and statisticians** working at the Central Bank of Lesotho's Research Department.

---

## Key Enhancements Made

### 1. **Target Audience Specification**
- All modules now explicitly state "For Economists and Statisticians"
- Professional context added to every lab header
- Learning objectives rewritten with economic and statistical terminology

### 2. **Statistical Terminology Integration**

#### Descriptive Statistics
- **Mean (μ or x̄)** - using AVG() function
- **Standard Deviation (σ)** - using STDEV() function
- **Variance (σ²)** - using VAR() function
- **Range** - using MIN() and MAX()
- **Sample Size (n)** - using COUNT()
- **Sum (Σx)** - using SUM() function

#### Economic Concepts
- Time series analysis
- Panel data structures
- Longitudinal comparisons
- Cross-sectional analysis
- Seasonal adjustment
- Index numbers and ratios
- Growth rate calculations
- Econometric data preparation

### 3. **Professional Responsibilities**

Each module now emphasizes:
- **Policy Analysis**: Supporting monetary policy decisions with data
- **Statistical Compilation**: Following international standards (IMF SDDS, DQAF)
- **Economic Research**: Preparing datasets for econometric analysis
- **Data Dissemination**: Publishing statistical bulletins and reports
- **Quality Assurance**: Statistical validation and data governance
- **Forecasting Support**: Data preparation for economic models

### 4. **Real-World Scenarios Enhanced**

#### Module 1: Introduction
- Querying economic indicators for policy briefs
- Extracting time series for econometric software (Stata, R, Python)

#### Module 2: Filtering
- Inflation target monitoring (above/below 5% threshold)
- Banking prudential ratio analysis
- Missing data identification

#### Module 3: JOINs
- Creating denormalized datasets for statistical analysis
- Building publication tables with proper labels
- Cross-sectional and panel data preparation

#### Module 4: Advanced JOINs
- Handling unbalanced panels
- Missing at random (MAR) analysis
- Data gap identification for policy reporting

#### Module 5: Aggregation
- Descriptive statistics for economic bulletins
- Sector aggregates (banking sector totals)
- IMF Article IV statistical packages
- Quality assessment dashboards

#### Module 6: Functions
- Fiscal year calculations (April-March for Lesotho)
- Index number formatting
- Growth rate computations
- International standards compliance (SDDS formatting)

#### Module 7: DML
- Data revision management (provisional → final)
- Version control for time series
- Audit trails for data governance
- Statistical integrity through transactions

### 5. **Database Design Context**

The CBL_DataWarehouse now explicitly supports:
- **Time Series Data**: Longitudinal economic indicators
- **Classification Systems**: Economic categories and taxonomies
- **Metadata Management**: Data dictionaries and variable labels
- **Version Control**: Provisional vs. final data tracking
- **Quality Flags**: Statistical validation status
- **Audit Trails**: Complete data lineage

### 6. **Economic Indicators Coverage**

All exercises use realistic CBL indicators:
- **Real Sector**: GDP (real/nominal), unemployment
- **Prices**: CPI, inflation rate, PPI
- **Monetary**: M1, M2, money multiplier, base rate
- **Banking**: Assets, loans, deposits, NPL ratios
- **External**: FX reserves, exchange rates, trade balance
- **Fiscal**: Government revenue, expenditure, debt

### 7. **Statistical Software Integration**

Training now prepares data for:
- **Stata**: Denormalized datasets with labels
- **R**: CSV exports with proper formatting
- **Python/Pandas**: Time series DataFrames
- **Excel**: Publication-ready pivot tables
- **SDMX**: International statistical standards

### 8. **Professional Vocabulary**

Enhanced terminology includes:
- Observations (not just "rows")
- Variables/Indicators (not just "columns")
- Time series/Panel data (not just "tables")
- Missing at random (MAR)
- Statistical significance
- Descriptive statistics
- Cross-tabulation
- Aggregation levels
- Temporal analysis
- Econometric datasets

---

## Module-by-Module Summary

### Module 1: Introduction to T-SQL
**For:** Junior economists and statisticians learning SQL
**Focus:** Basic data extraction for statistical analysis
**Skills:** Querying economic indicators, simple calculations

### Module 2: Filtering and Sorting
**For:** Economists conducting threshold analysis
**Focus:** Conditional selection and subset analysis
**Skills:** Inflation target monitoring, range filtering

### Module 3: JOIN Operations
**For:** Statisticians building comprehensive datasets
**Focus:** Relational data integration
**Skills:** Creating analysis-ready denormalized tables

### Module 4: Advanced JOINs
**For:** Senior statisticians handling complex data
**Focus:** Missing data analysis, panel data
**Skills:** Outer joins, self-joins for comparisons

### Module 5: Grouping and Aggregating
**For:** Economists preparing summary statistics
**Focus:** Descriptive statistics and aggregation
**Skills:** Mean, variance, sector totals, cross-tabs

### Module 6: Built-In Functions
**For:** Data officers formatting for publication
**Focus:** Statistical table formatting
**Skills:** Date functions, fiscal years, index formatting

### Module 7: DML - Data Modification
**For:** Data curators managing revisions
**Focus:** Data lifecycle and governance
**Skills:** Revision tracking, transactions, audit trails

---

## Target User Profiles

### 1. **Junior Economist**
- Recently graduated with economics degree
- Learning data management for policy analysis
- Needs to extract data for reports
- Modules 1-3 primary focus

### 2. **Statistician (Your Profile)**
- BSc/MSc in Statistics
- Responsible for data compilation
- Produces Monthly Statistical Bulletin
- Modules 1-7 comprehensive training

### 3. **Senior Economist**
- MSc/PhD in Economics
- Conducts econometric analysis
- Needs complex datasets for modeling
- Modules 4-7 advanced skills

### 4. **Data Quality Officer**
- Background in statistics/data management
- Validates data submissions
- Maintains data governance
- Modules 5-7 quality assurance focus

---

## Alignment with International Standards

Training materials now reference:
- **IMF SDDS**: Special Data Dissemination Standard
- **IMF DQAF**: Data Quality Assessment Framework
- **BIS Guidelines**: Banking statistics standards
- **SARB Standards**: Regional alignment with South African Reserve Bank
- **SDMX**: Statistical Data and Metadata eXchange

---

## Statistical Concepts Covered

### Time Series Analysis
- Temporal ordering and chronological data
- Period-over-period comparisons (MoM, QoQ, YoY)
- Lag operations for time series transformations
- Fiscal year vs. calendar year calculations

### Panel Data
- Cross-sectional time series (TSCS)
- Balanced vs. unbalanced panels
- Entity-time observations
- Missing data patterns (MAR, MCAR)

### Descriptive Statistics
- Central tendency: Mean, median, mode
- Dispersion: Standard deviation, variance, range
- Distribution analysis: Min, max, quartiles
- Sample size and observation counts

### Data Quality
- Completeness ratios
- Timeliness measures (reporting lag)
- Accuracy flags (provisional vs. final)
- Consistency checks across sources

---

## Next Steps for Users

After completing this training, economists and statisticians will be able to:
1. Query macroeconomic databases independently
2. Prepare datasets for econometric analysis
3. Generate statistical tables for publications
4. Perform data quality checks
5. Manage data revisions properly
6. Support policy analysis with data
7. Contribute to IMF/World Bank reporting
8. Build automated statistical workflows

---

## Key Terminology Reference

| Statistical Term | SQL Concept | Example Use |
|-----------------|-------------|-------------|
| Observations | Rows | Individual data points in time series |
| Variables | Columns | Economic indicators (CPI, GDP, etc.) |
| Sample Size (n) | COUNT(*) | Number of observations |
| Mean (μ) | AVG() | Average inflation rate |
| Std Dev (σ) | STDEV() | Volatility of exchange rates |
| Variance (σ²) | VAR() | Dispersion of growth rates |
| Panel Data | JOIN with time | Entity-time observations |
| Cross-section | GROUP BY entity | Data at single point in time |
| Time Series | ORDER BY date | Chronological observations |
| Missing Data | NULL values | Unreported or unavailable data |

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*Updated: December 2025*  
*For Economists and Statisticians*
