# Module 1: Introduction to T-SQL Querying - Lab Exercise
**Primary Topic:** Module 1: Introduction to T-SQL Querying - Lab Exercise

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 60-90 minutes  
**Difficulty:** Beginner with optional intermediate/advanced sections  
**Prerequisites:** CBL_DataWarehouse database setup completed  
**Target Audience:** Economists and Statisticians working with macroeconomic data

---

## Learning Objectives
By the end of this lab, you will be able to:
1. Write basic SELECT statements to retrieve economic indicators and time series data
2. Query macroeconomic datasets using specific columns relevant to statistical analysis
3. Extract data for econometric analysis and statistical reporting
4. Perform simple calculations on economic variables (growth rates, ratios, indices)
5. Understand SQL syntax for querying data warehouses used in economic research

---

## Lab Setup
Ensure you have run the `00_CBL_DataWarehouse_Setup.sql` script before starting.

**Topic:** MS20761 Module 2 – Environment handshake before querying
**Beginner Explanation:** Treat this as a quick handshake with the training database: we switch into `CBL_DataWarehouse` and ask it to echo "Setup Verified" so we know the lab environment is ready for every exercise that follows.

```sql
-- Verify database connection
USE CBL_DataWarehouse;
GO

-- Check if tables exist
SELECT 'Setup Verified' AS Status;
```

**Detailed Query Explanation:** First, `USE CBL_DataWarehouse` changes the context to the training database, then the follow-up `SELECT` returns a single literal value. Any failure here signals an environment issue rather than a problem with SQL syntax.
**Detailed Results Explanation:** A one-row result containing `Setup Verified` confirms the warehouse is available. If the row is missing or an error appears, rerun the setup script before attempting later modules.

---

## BEGINNER SECTION (Required for All)

### Exercise 1.1: Basic SELECT Statements

**Task 1:** Retrieve all countries in the database
**Topic:** MS20761 Module 3 Lesson 1 – Simple SELECT statements across a whole table
**Beginner Explanation:** This practice run shows how `SELECT *` returns every column for every row in `Countries`, helping you understand the table structure before applying filters or column lists.

```sql
-- Display all information about countries
SELECT * FROM Countries;
```

**Detailed Query Explanation:** `SELECT *` requests every column exactly as stored, and because no `WHERE` clause is present the engine scans the entire `Countries` table from top to bottom.
**Detailed Results Explanation:** Expect a complete listing of countries with all available attributes, which you can use to count records and decide which columns matter for later tasks.

**Questions:**
- How many countries are in the database?
- What columns are available in the Countries table?

---

**Task 2:** Select specific columns from DataSources
**Topic:** MS20761 Module 3 Lesson 1 – Selecting specific columns
**Beginner Explanation:** This step narrows the select list to just the source code and name so you can see how to return only the fields required for a quick inventory.

```sql
-- Display only source code and name
SELECT SourceCode, SourceName 
FROM DataSources;
```

**Detailed Query Explanation:** Listing `SourceCode` and `SourceName` explicitly limits the projection to those two columns, keeping the dataset small and easy to read when scanning sources.
**Detailed Results Explanation:** The query returns one row per data source with only its identifier and descriptive label—ideal for quick counts or catalog reviews.

**Questions:**
- How many data sources does the CBL work with?
- List three internal data sources.

---

**Task 3:** View all commercial banks
**Topic:** MS20761 Module 3 Lesson 1 – Writing SELECT statements with targeted columns
**Beginner Explanation:** This query selects four descriptive fields so you can quickly list every bank along with its type and city without reviewing unnecessary metadata.

```sql
-- Display bank information
SELECT BankCode, BankName, BankType, City
FROM CommercialBanks;
```

**Detailed Query Explanation:** Specifying the column list keeps the output concise, while omitting a `WHERE` clause ensures every record from `CommercialBanks` appears in the result.
**Detailed Results Explanation:** The output shows each bank’s code, name, type, and location, giving you the information needed to classify institutions and answer the follow-up questions.

**Questions:**
- How many commercial banks are registered?
- Which bank is classified as a Development Bank?

---

### Exercise 1.2: Simple Calculations

**Task 4:** View inflation data with descriptions
**Topic:** MS20761 Module 3 Lesson 3 – Using column aliases for readability
**Beginner Explanation:** This example renames each output column so the inflation series becomes self-explanatory, which is essential when sharing results with non-technical audiences.

```sql
-- Display inflation rates with custom labels
SELECT 
    PeriodDate AS 'Reporting Date',
    DataValue AS 'Inflation Rate (%)',
    'Annual Inflation' AS Description
FROM TimeSeriesData
WHERE IndicatorID = 6;  -- Inflation Rate indicator
```

**Detailed Query Explanation:** The `WHERE` clause restricts the dataset to the inflation indicator, and aliases applied via `AS` rename each column to plain-language labels without altering the underlying data.
**Detailed Results Explanation:** Every row now includes an intuitive header such as `Reporting Date` or `Inflation Rate (%)`, making the time series suitable for direct use in macroeconomic reports.

**Questions:**
- What was the inflation rate in November 2024?
- Is the inflation rate increasing or decreasing over time?

---

**Task 5:** Calculate simple statistics
**Topic:** MS20761 Module 3 Lesson 4 – Applying arithmetic expressions in SELECT
**Beginner Explanation:** Here we reuse the reserve value twice—once as stored in USD and once multiplied by an assumed FX rate—to demonstrate how SELECT expressions support simple currency conversions.

```sql
-- Show foreign reserves in both USD and estimated LSL
SELECT 
    PeriodDate,
    DataValue AS 'Reserves (Million USD)',
    DataValue * 18.30 AS 'Estimated Reserves (Million LSL)'
FROM TimeSeriesData
WHERE IndicatorID = 16;  -- Foreign Reserves
```

**Detailed Query Explanation:** The select list includes the original value plus an expression (`DataValue * 18.30`) that performs an inline multiplication, allowing the query to output both denominations without post-processing.
**Detailed Results Explanation:** Each row shows the reserves in their native USD units along with the estimated maloti equivalent, so you can discuss buffer levels in whichever unit stakeholders prefer.

**Questions:**
- What are the current foreign reserves in USD?
- What would be the approximate value in LSL?

---

### Exercise 1.3: Understanding Column Aliases

**Task 6:** Create meaningful column names
**Topic:** MS20761 Module 3 Lesson 3 – Presenting lookup data with readable aliases
**Beginner Explanation:** Aliases let you re-label raw column names so the staff list looks like an HR directory without changing any stored data.

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

**Detailed Query Explanation:** Using `AS 'Friendly Name'` on each column provides human-readable headers while returning the original values directly from `ResearchStaff`.
**Detailed Results Explanation:** The result reads like a personnel roster with meaningful labels for ID, name, position, and email, making it ready for quick sharing.

---

### Exercise 1.4: Basic Expressions

**Task 7:** Combine text columns
**Topic:** MS20761 Module 3 Lesson 4 – Combining character data with expressions
**Beginner Explanation:** Concatenating first and last names illustrates how character expressions can improve readability when producing staff rosters.

```sql
-- Create full names for research staff
SELECT 
    FirstName + ' ' + LastName AS 'Full Name',
    JobTitle,
    Email
FROM ResearchStaff;
```

**Detailed Query Explanation:** The expression `FirstName + ' ' + LastName` concatenates two columns with a space, and the query returns additional fields unchanged so you can see the combined output alongside existing data.
**Detailed Results Explanation:** The output includes a `Full Name` column plus job titles and emails, illustrating how basic expressions make final reports easier to consume.

---

### Exercise 1.5: Working with Numbers

**Task 8:** Perform calculations on banking data
**Topic:** MS20761 Module 3 Lesson 4 – Deriving numeric ratios inside SELECT statements
**Beginner Explanation:** Calculating the loan-to-deposit ratio shows how to embed arithmetic in a query so banking metrics are delivered as interpretable percentages.

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

**Detailed Query Explanation:** The query returns loans and deposits for each bank plus a computed expression `(TotalLoans / TotalDeposits) * 100`, with the `WHERE` clause restricting the analysis to a single reporting date.
**Detailed Results Explanation:** Results list every bank’s totals alongside the derived ratio, making it straightforward to identify institutions with higher leverage relative to deposits.

**Questions:**
- Which bank has the highest loan-to-deposit ratio?
- Is this ratio healthy for banking operations?

---

## INTERMEDIATE SECTION (Optional)

### Exercise 1.6: Complex Calculations

**Task 9:** Calculate multiple financial ratios
**Topic:** MS20761 Module 3 Lesson 4 – Combining multiple expressions in a single query
**Beginner Explanation:** This exercise collects assets, loans, deposits, and equity and derives three ratios so you can review a bank’s balance-sheet structure in one result set.

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

**Detailed Query Explanation:** Each expression divides a component by total assets and multiplies by 100, with `ROUND` adding two decimal places. The reporting date filter keeps every row aligned to the same snapshot.
**Detailed Results Explanation:** The output functions like a compact dashboard that highlights funding mix and capitalization levels for each bank without additional processing.

---

### Exercise 1.7: String Manipulation

**Task 10:** Format data source information
**Topic:** MS20761 Module 8 Lesson 1 – Applying built-in string functions
**Beginner Explanation:** This demonstration uppercases, lowercases, and counts characters to show how string functions prepare source metadata for publication-ready outputs.

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

**Detailed Query Explanation:** Functions such as `UPPER`, `LOWER`, and `LEN` operate directly on each row, creating transformed values alongside the base code and contact information.
**Detailed Results Explanation:** The output illustrates how each text function affects the strings, making it easier to standardize labels or validate name lengths without leaving SQL Server.

---

### Exercise 1.8: Date Calculations

**Task 11:** Calculate staff tenure
**Topic:** MS20761 Module 6 Lesson 3 – Working with date and time data
**Beginner Explanation:** This tenure report concatenates names and uses `DATEDIFF` to show years and months of service, reinforcing how date functions support HR analytics.

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

**Detailed Query Explanation:** Two `DATEDIFF` calls compute tenure in years and months relative to `GETDATE()`, while the concatenated name and hire date complete the roster view.
**Detailed Results Explanation:** Each row lists staff along with service length, letting you rank experience levels or identify upcoming milestone anniversaries directly from SQL output.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 1.9: Complex Business Calculations

**Task 12:** Calculate banking sector efficiency indicators
**Topic:** MS20761 Module 9 Lesson 1 – Using aggregate and ratio calculations for dashboards
**Beginner Explanation:** This scorecard example surfaces profitability, risk, and capital indicators in one query so you can evaluate each bank’s health without switching contexts.

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

**Detailed Query Explanation:** The query derives ROA, ROE, and Net Interest Margin using arithmetic expressions, reports the stored NPL ratio plus an additional loan-quality metric, and exposes capital and liquidity ratios for each bank.
**Detailed Results Explanation:** Each record consolidates all major supervisory metrics, making it simple to benchmark profitability, asset quality, and capital adequacy across institutions.

**Analysis Questions:**
- Which bank has the best Return on Assets (ROA)?
- Are all banks meeting the minimum Capital Adequacy Ratio of 10%?
- What does the liquidity ratio indicate about each bank's health?

---

### Exercise 1.10: Time Series Analysis Preparation

**Task 13:** Prepare inflation data for analysis
**Topic:** MS20761 Module 5 Lesson 4 – Working with conditional logic for policy flags
**Beginner Explanation:** This query categorizes each inflation reading as above, within, or below target using a `CASE` expression so the time series speaks directly to policy thresholds.

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

**Detailed Query Explanation:** Selecting calendar parts plus the rate and applying a `CASE` expression produces a categorical assessment column, while the `WHERE` clause focuses the dataset on the inflation indicator.
**Detailed Results Explanation:** The result table doubles as a monitoring sheet: each row shows the rate, the policy band it falls into, and whether the entry is provisional.

---

### Exercise 1.11: Economic Indicator Dashboard

**Task 14:** Create a comprehensive economic snapshot
**Topic:** MS20761 Module 12 Lesson 1 – Using set operators to build dashboards
**Beginner Explanation:** This example uses `UNION ALL` to stack CPI, inflation, and reserves into one table so stakeholders can review multiple headline indicators in a single glance.

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

**Detailed Query Explanation:** Three filtered SELECT statements pull specific indicators for the same reporting date, cast their values to text, label them, and then the `UNION ALL` operator stacks the rows without eliminating duplicates.
**Detailed Results Explanation:** The final output delivers a compact dashboard with one row per indicator, suitable for pasting directly into a briefing or executive summary.

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
