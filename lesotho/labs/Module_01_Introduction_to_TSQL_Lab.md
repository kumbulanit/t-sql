# Module 1: Introduction to T-SQL Querying - Lab Exercise
## Central Bank of Lesotho - Data Management Division

### Lab Overview
**Duration:** 60-90 minutes  
**Difficulty:** Beginner with optional intermediate/advanced sections  
**Prerequisites:** CBL_DataWarehouse database setup completed

---

## Learning Objectives
By the end of this lab, you will be able to:
1. Write basic SELECT statements to retrieve data
2. Use SELECT with specific columns
3. Understand the difference between SELECT * and specific columns
4. Use simple expressions and calculations in queries
5. Understand basic SQL syntax and statement structure

---

## Lab Setup
Ensure you have run the `00_CBL_DataWarehouse_Setup.sql` script before starting.

```sql
-- Verify database connection
USE CBL_DataWarehouse;
GO

-- Check if tables exist
SELECT 'Setup Verified' AS Status;
```

---

## BEGINNER SECTION (Required for All)

### Exercise 1.1: Basic SELECT Statements

**Task 1:** Retrieve all countries in the database
```sql
-- Display all information about countries
SELECT * FROM Countries;
```

**Questions:**
- How many countries are in the database?
- What columns are available in the Countries table?

---

**Task 2:** Select specific columns from DataSources
```sql
-- Display only source code and name
SELECT SourceCode, SourceName 
FROM DataSources;
```

**Questions:**
- How many data sources does the CBL work with?
- List three internal data sources.

---

**Task 3:** View all commercial banks
```sql
-- Display bank information
SELECT BankCode, BankName, BankType, City
FROM CommercialBanks;
```

**Questions:**
- How many commercial banks are registered?
- Which bank is classified as a Development Bank?

---

### Exercise 1.2: Simple Calculations

**Task 4:** View inflation data with descriptions
```sql
-- Display inflation rates with custom labels
SELECT 
    PeriodDate AS 'Reporting Date',
    DataValue AS 'Inflation Rate (%)',
    'Annual Inflation' AS Description
FROM TimeSeriesData
WHERE IndicatorID = 6;  -- Inflation Rate indicator
```

**Questions:**
- What was the inflation rate in November 2024?
- Is the inflation rate increasing or decreasing over time?

---

**Task 5:** Calculate simple statistics
```sql
-- Show foreign reserves in both USD and estimated LSL
SELECT 
    PeriodDate,
    DataValue AS 'Reserves (Million USD)',
    DataValue * 18.30 AS 'Estimated Reserves (Million LSL)'
FROM TimeSeriesData
WHERE IndicatorID = 16;  -- Foreign Reserves
```

**Questions:**
- What are the current foreign reserves in USD?
- What would be the approximate value in LSL?

---

### Exercise 1.3: Understanding Column Aliases

**Task 6:** Create meaningful column names
```sql
-- Display research staff with friendly column names
SELECT 
    EmployeeNumber AS 'Employee ID',
    FirstName AS 'First Name',
    LastName AS 'Last Name',
    JobTitle AS 'Position',
    Email AS 'Email Address'
FROM ResearchStaff;
```

---

### Exercise 1.4: Basic Expressions

**Task 7:** Combine text columns
```sql
-- Create full names for research staff
SELECT 
    FirstName + ' ' + LastName AS 'Full Name',
    JobTitle,
    Email
FROM ResearchStaff;
```

---

### Exercise 1.5: Working with Numbers

**Task 8:** Perform calculations on banking data
```sql
-- Calculate loan-to-deposit ratio
SELECT 
    BankID,
    TotalLoans,
    TotalDeposits,
    (TotalLoans / TotalDeposits) * 100 AS 'Loan-to-Deposit Ratio (%)'
FROM BankingStatistics
WHERE ReportingDate = '2024-09-30';
```

**Questions:**
- Which bank has the highest loan-to-deposit ratio?
- Is this ratio healthy for banking operations?

---

## INTERMEDIATE SECTION (Optional)

### Exercise 1.6: Complex Calculations

**Task 9:** Calculate multiple financial ratios
```sql
-- Banking sector efficiency metrics
SELECT 
    BankID,
    ReportingDate,
    TotalAssets AS 'Total Assets (M LSL)',
    TotalLoans AS 'Total Loans (M LSL)',
    TotalDeposits AS 'Total Deposits (M LSL)',
    ROUND((TotalLoans / TotalAssets) * 100, 2) AS 'Loans-to-Assets %',
    ROUND((TotalDeposits / TotalAssets) * 100, 2) AS 'Deposits-to-Assets %',
    ROUND((TotalEquity / TotalAssets) * 100, 2) AS 'Equity Ratio %'
FROM BankingStatistics
WHERE ReportingDate = '2024-09-30';
```

---

### Exercise 1.7: String Manipulation

**Task 10:** Format data source information
```sql
-- Display formatted data source information
SELECT 
    SourceCode AS 'Code',
    UPPER(SourceName) AS 'Source Name (Uppercase)',
    LOWER(SourceType) AS 'Type (Lowercase)',
    LEN(SourceName) AS 'Name Length',
    ContactEmail
FROM DataSources;
```

---

### Exercise 1.8: Date Calculations

**Task 11:** Calculate staff tenure
```sql
-- Calculate how long staff have been employed
SELECT 
    FirstName + ' ' + LastName AS 'Staff Name',
    JobTitle,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS 'Years of Service',
    DATEDIFF(MONTH, HireDate, GETDATE()) AS 'Months of Service'
FROM ResearchStaff;
```

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 1.9: Complex Business Calculations

**Task 12:** Calculate banking sector efficiency indicators
```sql
-- Advanced banking performance metrics
SELECT 
    BankID,
    ReportingDate,
    -- Profitability Metrics
    ROUND((NetIncome / TotalAssets) * 100, 2) AS 'ROA (%)',
    ROUND((NetIncome / TotalEquity) * 100, 2) AS 'ROE (%)',
    ROUND(((InterestIncome - InterestExpense) / InterestIncome) * 100, 2) AS 'Net Interest Margin (%)',
    
    -- Risk Metrics
    NPLRatio AS 'NPL Ratio (%)',
    ROUND((NonPerformingLoans / TotalLoans) * 100, 2) AS 'NPL to Loans (%)',
    
    -- Capital Metrics
    CapitalAdequacyRatio AS 'CAR (%)',
    LiquidityRatio AS 'Liquidity Ratio (%)'
FROM BankingStatistics
WHERE ReportingDate = '2024-09-30'
ORDER BY BankID;
```

**Analysis Questions:**
- Which bank has the best Return on Assets (ROA)?
- Are all banks meeting the minimum Capital Adequacy Ratio of 10%?
- What does the liquidity ratio indicate about each bank's health?

---

### Exercise 1.10: Time Series Analysis Preparation

**Task 13:** Prepare inflation data for analysis
```sql
-- Calculate month-over-month changes in inflation
SELECT 
    ts.PeriodDate,
    ts.PeriodYear,
    ts.PeriodMonth,
    ts.DataValue AS 'Inflation Rate',
    CASE 
        WHEN ts.DataValue > 6.0 THEN 'Above Target'
        WHEN ts.DataValue BETWEEN 4.0 AND 6.0 THEN 'Within Target'
        ELSE 'Below Target'
    END AS 'Policy Assessment',
    ts.IsProvisional AS 'Provisional'
FROM TimeSeriesData ts
WHERE ts.IndicatorID = 6  -- Inflation Rate
ORDER BY ts.PeriodDate;
```

---

### Exercise 1.11: Economic Indicator Dashboard

**Task 14:** Create a comprehensive economic snapshot
```sql
-- Economic indicators dashboard for latest month
SELECT 
    'CPI' AS Indicator,
    CAST(DataValue AS VARCHAR(20)) AS Value,
    'Index Points' AS Unit,
    PeriodDate AS 'As of Date'
FROM TimeSeriesData
WHERE IndicatorID = 4 AND PeriodDate = '2024-11-30'

UNION ALL

SELECT 
    'Inflation Rate',
    CAST(DataValue AS VARCHAR(20)),
    'Percentage',
    PeriodDate
FROM TimeSeriesData
WHERE IndicatorID = 6 AND PeriodDate = '2024-11-30'

UNION ALL

SELECT 
    'FX Reserves',
    CAST(DataValue AS VARCHAR(20)),
    'Million USD',
    PeriodDate
FROM TimeSeriesData
WHERE IndicatorID = 16 AND PeriodDate = '2024-11-30';
```

---

## Practice Exercises (Do It Yourself)

### Beginner Level
1. Display all economic indicators with their codes and names
2. List all report types that are public (IsPublic = 1)
3. Show all data frequencies ordered by SortOrder
4. Display indicator categories with their descriptions

### Intermediate Level
5. Calculate the average exchange rate for November 2024
6. Count how many indicators belong to each category
7. Show staff members hired after 2020
8. Display banks established before 2010

### Advanced Level
9. Create a summary showing total banking sector assets, loans, and deposits for Q3 2024
10. Calculate the percentage change in foreign reserves from January to November 2024
11. Identify which data sources provide the most indicators
12. Analyze the relationship between interest income and interest expense across banks

---

## Self-Assessment Questions

### Conceptual Understanding
1. What is the difference between SELECT * and selecting specific columns?
2. Why are column aliases useful in SQL queries?
3. When would you use calculations in a SELECT statement?
4. What does the ROUND function do and why is it useful for financial data?

### Practical Application
5. How would you format a query result to be more readable for a report?
6. What financial ratios are most important for banking sector analysis?
7. How can SQL help automate the compilation of macroeconomic data?
8. What role does SQL play in the data dissemination process?

---

## Real-World Application Scenarios

### Scenario 1: Monthly Report Preparation
Your supervisor asks you to prepare a list of all economic indicators collected last month. What query would you write?

### Scenario 2: Banking Supervision
The Banking Supervision department needs a quick overview of all banks' capital adequacy ratios. How would you extract this information?

### Scenario 3: Data Quality Check
You need to identify all provisional data entries for quality review. Which table would you query and what condition would you use?

---

## Key Takeaways

✅ **SELECT Statement Structure:**
- SELECT [columns] FROM [table];
- Use specific columns for better performance
- Use * only when you need all columns

✅ **Column Aliases:**
- Make output more readable
- Essential for calculated columns
- Use AS keyword or just space

✅ **Calculations:**
- Perform arithmetic operations in SELECT
- Use functions like ROUND for formatting
- Combine columns using operators

✅ **Best Practices:**
- Always specify database with USE statement
- Use meaningful aliases for clarity
- Format queries for readability
- Comment your code for documentation

---

## Additional Resources

### CBL-Specific Contexts
- **TimeSeriesData:** Core table for macroeconomic indicators
- **BankingStatistics:** Monthly/quarterly bank reports
- **DataSources:** Critical for data lineage tracking
- **EconomicIndicators:** Master list of tracked indicators

### Important Indicators for CBL
- Inflation Rate (IndicatorID = 6)
- Foreign Reserves (IndicatorID = 16)
- Exchange Rates (IndicatorID = 17, 18)
- Money Supply M2 (IndicatorID = 8)

---

## Next Steps

Proceed to **Module 2: Querying Multiple Tables** where you will learn:
- Using WHERE clause to filter data
- Working with comparison operators
- Combining multiple conditions
- Pattern matching with LIKE

---

**Lab Complete!** 🎉

Remember: The key to mastering SQL is practice. Try modifying these queries with different indicators, date ranges, and calculations.

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 1*
