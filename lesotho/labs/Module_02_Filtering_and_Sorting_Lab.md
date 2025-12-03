# Module 2: Filtering and Sorting Data - Lab Exercise
**Primary Topic:** Module 2: Filtering and Sorting Data - Lab Exercise

## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 75-100 minutes  
**Difficulty:** Beginner with optional intermediate/advanced sections  
**Prerequisites:** Module 1 completed, CBL_DataWarehouse database  
**Target Audience:** Economists and Statisticians conducting data analysis and statistical compilation

---

## Learning Objectives
1. Use WHERE clause to filter observations for statistical subsets and conditional analysis
2. Work with comparison operators for threshold analysis (inflation targets, prudential ratios)
3. Combine conditions with logical operators for complex economic criteria
4. Use BETWEEN for range analysis and IN for categorical filtering (country groups, indicator sets)
5. Apply pattern matching with LIKE for indicator code searching
6. Sort results with ORDER BY for time series chronological ordering and ranking
7. Handle NULL values (missing observations) common in economic datasets
8. Filter date ranges for temporal analysis and period-specific reporting

---

## Lab Setup
**Topic:** MS20761 Module 5 Lab Prep – Set the database context
**Beginner Explanation:** These two lines switch the session into `CBL_DataWarehouse`, ensuring all upcoming sorting and filtering exercises run against the correct training tables.

```sql
USE CBL_DataWarehouse;
GO
```

**Detailed Query Explanation:** `USE CBL_DataWarehouse;` changes the active database, and `GO` tells SSMS to execute that batch immediately. There is no data retrieval yet; it is just environment preparation.
**Detailed Results Explanation:** No result set is expected. If the command succeeds silently, you are ready to run the remaining tasks. Errors indicate the setup script still needs to be executed.

---

## BEGINNER SECTION (Required for All)

### Exercise 2.1: Basic WHERE Clause

**Task 1:** Find specific countries
**Topic:** MS20761 Module 5 Lesson 2 – Filter equality predicates in WHERE
**Beginner Explanation:** This query shows how adding a `WHERE` clause lets you isolate just Lesotho instead of all countries.

```sql
-- Display only Lesotho's information
SELECT * FROM Countries
WHERE CountryName = 'Lesotho';
```

**Detailed Query Explanation:** The statement selects every column but limits the rows to where `CountryName` matches the literal `'Lesotho'`. This is the most basic use of equality filtering.
**Detailed Results Explanation:** Expect exactly one row (assuming countries are unique) showing every detail the warehouse stores about Lesotho, confirming your filter works.

**Task 2:** Filter by data source type
**Topic:** MS20761 Module 5 Lesson 2 – Restrict result sets by categorical values
**Beginner Explanation:** This filter keeps only those sources whose type equals "Internal" so you can focus on in-house feeds.

```sql
-- Show only internal data sources
SELECT SourceCode, SourceName, SourceType
FROM DataSources
WHERE SourceType = 'Internal';
```

**Detailed Query Explanation:** The `WHERE` clause tests each row’s `SourceType`, returning it only when it matches the string `Internal`. The select list stays small so you can read the output quickly.
**Detailed Results Explanation:** The result contains just the internal systems and their codes, making it easy to count or list them in documentation without manual filtering.

**Task 3:** Find active commercial banks
**Topic:** MS20761 Module 5 Lesson 2 – Filter Boolean/flag columns
**Beginner Explanation:** Adding a filter on the `IsActive` flag keeps dormant institutions out of the list so you focus on those operating now.

```sql
-- List all active banks
SELECT BankCode, BankName, BankType, City
FROM CommercialBanks
WHERE IsActive = 1;
```

**Detailed Query Explanation:** The query evaluates the `IsActive` column (typically 1 for yes, 0 for no) and returns rows where it equals 1. The selected columns provide quick reference details for each bank.
**Detailed Results Explanation:** The result set is a clean list of active institutions plus their types and cities, giving supervisors a current-state overview.

---

### Exercise 2.2: Comparison Operators

**Task 4:** Find high inflation periods
**Topic:** MS20761 Module 5 Lesson 2 – Apply comparison operators to numeric data
**Beginner Explanation:** This filter keeps only inflation readings greater than 5.5%, making spikes easy to spot.

```sql
-- Show months where inflation exceeded 5.5%
SELECT 
    PeriodDate,
    DataValue AS 'Inflation Rate (%)',
    IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 6  -- Inflation indicator
  AND DataValue > 5.5;
```

**Detailed Query Explanation:** After restricting the table to indicator 6, the `AND DataValue > 5.5` condition keeps only those records where inflation breached the threshold. The select list returns the date, rate, and whether the value is provisional.
**Detailed Results Explanation:** Expect a short list of periods where inflation was uncomfortably high. Analysts can use the dates to correlate with policy actions or external shocks.

**Task 5:** Foreign reserves above threshold
**Topic:** MS20761 Module 5 Lesson 2 – Filter rows with greater-than-or-equal logic
**Beginner Explanation:** This condition keeps only the months where foreign reserves were at least 1,000 million USD.

```sql
-- Find months with reserves above $1000M
SELECT 
    PeriodDate,
    DataValue AS 'Reserves (Million USD)'
FROM TimeSeriesData
WHERE IndicatorID = 16
  AND DataValue >= 1000;
```

**Detailed Query Explanation:** After filtering for indicator 16 (reserves), the `>= 1000` comparison keeps rows meeting or exceeding the benchmark. The select list pairs the date with the reserve amount in millions.
**Detailed Results Explanation:** You will see only those periods when buffers were strong. These dates can be used for highlighting resilience or comparing with periods below the threshold.

**Task 6:** Staff hired recently
**Topic:** MS20761 Module 5 Lesson 2 – Use date comparisons inside WHERE
**Beginner Explanation:** This query filters the staff table to only those hired after 2020, letting you see newer recruits.

```sql
-- Show staff hired after 2020
SELECT 
  FirstName + ' ' + LastName AS 'Staff Name',
  JobTitle,
  HireDate,
  Division
FROM ResearchStaff
WHERE HireDate > '2020-12-31';
```

**Detailed Query Explanation:** The `WHERE` clause compares each `HireDate` to the cutoff date and returns rows with later dates. Concatenating first and last names improves readability while still returning role and division context.
**Detailed Results Explanation:** Expect a roster of staff members who joined from 2021 onward. This is helpful for onboarding, mentoring plans, or understanding recent staffing trends.

---

### Exercise 2.3: Combining Conditions (AND)

**Task 7:** Filter banking statistics
**Topic:** MS20761 Module 5 Lesson 2 – Combine predicates with AND
**Beginner Explanation:** This example uses two filters at once to highlight banks where bad loans are high and capital buffers are thin.

```sql
-- Find banks with high NPL and low CAR
SELECT 
    BankID,
    ReportingDate,
    NPLRatio,
    CapitalAdequacyRatio
FROM BankingStatistics
WHERE NPLRatio >= 5.0
  AND CapitalAdequacyRatio < 15.0;
```

**Detailed Query Explanation:** Rows must satisfy both conditions: `NPLRatio` at least 5% and `CapitalAdequacyRatio` below 15%. Using `AND` ensures only simultaneously risky situations appear.
**Detailed Results Explanation:** The result set pinpoints where supervisory attention is most urgent. Each row includes the date to confirm the timeframe of concern.

**Task 8:** Published public reports
**Topic:** MS20761 Module 5 Lesson 2 – Require multiple conditions simultaneously
**Beginner Explanation:** This combination of filters ensures you only see final reports that the public is allowed to read.

```sql
-- Show published public reports
SELECT 
    ReportTitle,
    PublicationDate,
    IsPublic
FROM MacroeconomicReports
WHERE Status = 'Published'
  AND IsPublic = 1;
```

**Detailed Query Explanation:** The `WHERE` clause checks two conditions: `Status` equals `Published` and `IsPublic` equals 1. Only records meeting both criteria reach the output.
**Detailed Results Explanation:** Expect a ready-to-share list of official publications, including their titles and publication dates, ideal for dissemination tracking.

---

### Exercise 2.4: Combining Conditions (OR)

**Task 9:** Multiple bank types
**Topic:** MS20761 Module 5 Lesson 2 – Broaden filters using OR
**Beginner Explanation:** This statement keeps rows where the bank type is either Commercial or Development, demonstrating how `OR` broadens a filter.

```sql
-- Show commercial banks OR development banks
SELECT BankName, BankType, IsActive
FROM CommercialBanks
WHERE BankType = 'Commercial Bank'
  OR BankType = 'Development Bank';
```

**Detailed Query Explanation:** The `WHERE` clause evaluates two equality checks joined by `OR`, so if either condition is true the row is returned. Other bank types are excluded.
**Detailed Results Explanation:** The output lists both targeted categories together, making it easy to compare their counts or review their activity status.

**Task 10:** Urgent report statuses
**Topic:** MS20761 Module 5 Lesson 2 – Use OR to monitor workflow stages
**Beginner Explanation:** This query retrieves reports that are either still drafts or undergoing review so teams know what is pending.

```sql
-- Find reports in draft or under review
SELECT 
  ReportTitle,
  Status,
  DraftDate,
  ReviewDate
FROM MacroeconomicReports
WHERE Status = 'Draft'
   OR Status = 'Under Review';
```

**Detailed Query Explanation:** The `OR` logic checks the `Status` column for two possible values. If either matches, the row is included, allowing you to see both stages in one list.
**Detailed Results Explanation:** Expect a workload view showing each unfinished report, its current status, and the relevant milestone dates to manage timelines.

---

### Exercise 2.5: BETWEEN Operator

**Task 11:** Date range filtering
**Topic:** MS20761 Module 5 Lesson 2 – Use BETWEEN for inclusive date ranges
**Beginner Explanation:** This filter returns inflation readings only for October and November 2024, showcasing how `BETWEEN` handles date ranges.

```sql
-- Get inflation data for Q4 2024
SELECT 
    PeriodDate,
    DataValue AS 'Inflation Rate',
    PeriodMonth
FROM TimeSeriesData
WHERE IndicatorID = 6
  AND PeriodDate BETWEEN '2024-10-01' AND '2024-11-30';
```

**Detailed Query Explanation:** After limiting rows to indicator 6, the `BETWEEN` clause keeps only dates from 1 October through 30 November inclusive. The selected columns provide both the actual date and the month number for reference.
**Detailed Results Explanation:** The output shows the two-month window requested, enabling analysts to focus on late-2024 trends without manually filtering the full series.

**Task 12:** Banks by asset size
**Topic:** MS20761 Module 5 Lesson 2 – Apply BETWEEN to numeric bands
**Beginner Explanation:** Here `BETWEEN` finds banks with total assets between 7 and 9 billion (assuming figures are in millions), while still focusing on a single reporting date.

```sql
-- Medium-sized banks (assets between 7B and 9B)
SELECT 
    BankID,
    TotalAssets,
    TotalLoans,
    ReportingDate
FROM BankingStatistics
WHERE TotalAssets BETWEEN 7000 AND 9000
  AND ReportingDate = '2024-09-30';
```

**Detailed Query Explanation:** The expression `TotalAssets BETWEEN 7000 AND 9000` keeps values within the inclusive range. Coupling it with a date filter ensures you compare banks at the same point in time.
**Detailed Results Explanation:** The result lists only the medium-sized institutions, along with their loan totals for context. This helps focus policy conversations on banks falling within that bracket.

---

### Exercise 2.6: IN Operator

**Task 13:** Multiple specific values
**Topic:** MS20761 Module 5 Lesson 2 – Filter discrete sets with IN
**Beginner Explanation:** This filter keeps only September, October, and November values for the inflation series.

```sql
-- Get data from selected months
SELECT 
    PeriodDate,
    PeriodMonth,
    DataValue
FROM TimeSeriesData
WHERE IndicatorID = 6
  AND PeriodMonth IN (9, 10, 11);  -- Sep, Oct, Nov
```

**Detailed Query Explanation:** After restricting to indicator 6, the `IN` list checks whether `PeriodMonth` equals 9, 10, or 11. If so, the row is returned.
**Detailed Results Explanation:** The output shows only the three months of interest, letting you compare them side by side without scrolling through the entire year.

**Task 14:** Specific indicator categories
**Topic:** MS20761 Module 5 Lesson 2 – Combine categorical filters via IN lists
**Beginner Explanation:** This example shows how to return only monetary, banking, and external sector indicators using `IN`.

```sql
-- Show indicators in key categories
SELECT 
  IndicatorCode,
  IndicatorName,
  CategoryID
FROM EconomicIndicators
WHERE CategoryID IN (2, 3, 4);  -- Monetary, Banking, External
```

**Detailed Query Explanation:** The `IN` clause checks whether each row’s `CategoryID` is one of the listed values. Only those categories reach the result set, keeping everything else out.
**Detailed Results Explanation:** You’ll see just the target indicators with their codes and category IDs, simplifying downstream analyses focused on these macro areas.

---

### Exercise 2.7: LIKE Operator (Pattern Matching)

**Task 15:** Search by name pattern
**Topic:** MS20761 Module 5 Lesson 2 – Pattern matching with LIKE
**Beginner Explanation:** This task returns every indicator whose name contains the word "Rate", demonstrating wildcard searches.

```sql
-- Find all indicators with "Rate" in the name
SELECT 
  IndicatorCode,
  IndicatorName,
  UnitOfMeasure
FROM EconomicIndicators
WHERE IndicatorName LIKE '%Rate%';
```

**Detailed Query Explanation:** The `LIKE '%Rate%'` predicate matches any string that has `Rate` anywhere inside it. `%` stands for "any sequence of characters", so it captures prefixes, suffixes, or middle occurrences.
**Detailed Results Explanation:** The returned rows are all rate-related indicators, making it simple to build a list of rate metrics without knowing every exact name.

**Task 16:** Email domain search
**Topic:** MS20761 Module 5 Lesson 2 – Use LIKE to match domain suffixes
**Beginner Explanation:** By searching for addresses that end with `@centralbank.org.ls`, you can isolate official accounts.

```sql
-- Find staff with centralbank.org.ls emails
SELECT 
  FirstName + ' ' + LastName AS 'Staff Name',
  Email,
  JobTitle
FROM ResearchStaff
WHERE Email LIKE '%@centralbank.org.ls';
```

**Detailed Query Explanation:** The `LIKE` pattern `%@centralbank.org.ls` finds any address whose tail matches that domain. The `SELECT` clause provides a readable name plus job title for context.
**Detailed Results Explanation:** Expect a roster of staff using the central bank’s primary domain, useful for security checks or communication planning.

---

### Exercise 2.8: ORDER BY Clause

**Task 17:** Sort by date
**Topic:** MS20761 Module 5 Lesson 1 – Sort datasets with ORDER BY
**Beginner Explanation:** This query shows how `ORDER BY` with `DESC` returns the newest months first so you see the latest numbers immediately.

```sql
-- Recent inflation data, newest first
SELECT 
  PeriodDate,
  DataValue AS 'Inflation Rate',
  IsProvisional
FROM TimeSeriesData
WHERE IndicatorID = 6
ORDER BY PeriodDate DESC;
```

**Detailed Query Explanation:** After filtering for indicator 6, the result set is sorted by `PeriodDate` descending. No limit is applied, but the order ensures the top rows are the most recent observations.
**Detailed Results Explanation:** Analysts can scan the first few rows to answer "what happened last month?" without scrolling, while older data remains available lower in the list.

**Task 18:** Sort by multiple columns
**Topic:** MS20761 Module 5 Lesson 1 – Multi-column ORDER BY sequences
**Beginner Explanation:** This example chains several columns in `ORDER BY` so your roster groups by division and then sorts names within each group.

```sql
-- Staff list ordered by division and name
SELECT 
  Division,
  FirstName + ' ' + LastName AS 'Name',
  JobTitle
FROM ResearchStaff
ORDER BY Division, LastName, FirstName;
```

**Detailed Query Explanation:** The select list builds a friendly name while returning division and job title. `ORDER BY Division, LastName, FirstName` means the result sorts by division alphabetically, then by last name, and finally by first name to break ties.
**Detailed Results Explanation:** This produces a grouped directory where colleagues from the same division appear together, making the output perfect for team-based summaries or sign-in sheets.

---

### Exercise 2.9: NULL Handling

**Task 19:** Find records with missing data
**Topic:** MS20761 Module 5 Lesson 4 – Identify NULL values
**Beginner Explanation:** This `IS NULL` check shows which indicators have no description filled in yet.

```sql
-- Indicators without description
SELECT 
  IndicatorCode,
  IndicatorName,
  Description
FROM EconomicIndicators
WHERE Description IS NULL;
```

**Detailed Query Explanation:** The `WHERE Description IS NULL` predicate catches rows where the description column has no value. Returning the code and name alongside helps you know what needs attention.
**Detailed Results Explanation:** The output highlights data definitions that require updates, letting you prioritize documentation work.

**Task 20:** Records with data present
**Topic:** MS20761 Module 5 Lesson 4 – Require non-NULL values
**Beginner Explanation:** This query demonstrates the opposite of `IS NULL` by returning banks that have both a contact person and email captured.

```sql
-- Banks with contact information
SELECT 
    BankName,
    ContactPerson,
    Email
FROM CommercialBanks
WHERE ContactPerson IS NOT NULL
  AND Email IS NOT NULL;
```

**Detailed Query Explanation:** Two `IS NOT NULL` checks ensure both fields contain data. Using `AND` guarantees that incomplete entries are excluded entirely.
**Detailed Results Explanation:** You’ll get a contact-ready list of banks you can reach out to without digging for missing information.

---

## INTERMEDIATE SECTION (Optional)

### Exercise 2.10: Complex Filtering

**Task 21:** Multi-condition banking analysis
**Topic:** MS20761 Module 5 Lesson 2 – Layer multiple predicates with joins
**Beginner Explanation:** This more advanced query links bank names to their stats and keeps only those with strong capital, low NPLs, and healthy liquidity.

```sql
-- High-performing banks with good ratios
SELECT 
    b.BankName,
    bs.TotalAssets,
    bs.CapitalAdequacyRatio,
    bs.NPLRatio,
    bs.LiquidityRatio
FROM BankingStatistics bs
JOIN CommercialBanks b ON bs.BankID = b.BankID
WHERE bs.ReportingDate = '2024-09-30'
  AND bs.CapitalAdequacyRatio >= 15
  AND bs.NPLRatio < 5
  AND bs.LiquidityRatio > 30
ORDER BY bs.TotalAssets DESC;
```

**Detailed Query Explanation:** The `JOIN` ties statistical records to their bank names, while the `WHERE` clause applies multiple thresholds simultaneously. Ordering by `TotalAssets DESC` sorts the strongest banks to the top once the filters are applied.
**Detailed Results Explanation:** The final table highlights institutions that check every supervisory box, giving decision makers a shortlist of well-performing banks sorted by size.

---

### Exercise 2.11: Date Functions with Filtering

**Task 22:** Recent data submissions
**Topic:** MS20761 Module 6 Lesson 3 – Filter and calculate using date functions
**Beginner Explanation:** This query shows which external data feeds arrived within the last 60 days and how many days have passed since each submission.

```sql
-- External data received in last 60 days
SELECT 
  ds.SourceName,
  eds.SubmissionDate,
  eds.DataCategory,
  eds.ProcessingStatus,
  DATEDIFF(DAY, eds.SubmissionDate, GETDATE()) AS 'Days Ago'
FROM ExternalDataSubmissions eds
JOIN DataSources ds ON eds.DataSourceID = ds.DataSourceID
WHERE eds.SubmissionDate >= DATEADD(DAY, -60, GETDATE())
ORDER BY eds.SubmissionDate DESC;
```

**Detailed Query Explanation:** A join brings in the source name, while `DATEADD(DAY, -60, GETDATE())` computes the cutoff date. `DATEDIFF` calculates how old each submission is, and sorting by submission date descending keeps the newest rows on top.
**Detailed Results Explanation:** The output acts like an intake log, showing which submissions are fresh, their processing status, and exact ages so teams can prioritize reviews.

---

### Exercise 2.12: Negation with NOT

**Task 23:** Exclude specific conditions
**Topic:** MS20761 Module 5 Lesson 2 – Apply NOT and NOT IN
**Beginner Explanation:** This filter removes real-sector categories (7 and 9) and keeps only active indicators, demonstrating negative logic.

```sql
-- Indicators NOT in real sector category
SELECT 
    IndicatorCode,
    IndicatorName,
    CategoryID
FROM EconomicIndicators
WHERE CategoryID NOT IN (7, 9)  -- Exclude real sector
  AND IsActive = 1
ORDER BY IndicatorName;
```

**Detailed Query Explanation:** `NOT IN (7, 9)` filters out the unwanted categories, while `IsActive = 1` ensures only currently tracked indicators stay in the list. Ordering alphabetically by `IndicatorName` improves readability.
**Detailed Results Explanation:** The resulting table is a clean inventory of active indicators outside the real-sector focus, handy for assigning analysis responsibilities.

---

### Exercise 2.13: Combined Pattern Matching

**Task 24:** Advanced LIKE patterns
**Topic:** MS20761 Module 5 Lesson 2 – Combine pattern predicates with OR
**Beginner Explanation:** This query returns sources whose codes start with "CBL" or whose names mention "Bank", showing how you can chain different patterns with `OR`.

```sql
-- Find specific data source patterns
SELECT 
  SourceCode,
  SourceName,
  SourceType
FROM DataSources
WHERE SourceCode LIKE 'CBL%'  -- Starts with CBL
   OR SourceName LIKE '%Bank%'  -- Contains Bank
ORDER BY SourceCode;
```

**Detailed Query Explanation:** The first pattern anchors the beginning of the string, while the second looks for "Bank" anywhere in the name. Using `OR` combines both tests, and ordering by `SourceCode` keeps the output tidy.
**Detailed Results Explanation:** You’ll receive a blended list of internal sources (CBL-prefixed) plus any external ones that reference banks in their names, helping analysts focus on relevant feeds.

---

## ADVANCED SECTION (Optional Challenge)

### Exercise 2.14: Complex Business Logic

**Task 25:** Risk assessment filtering
**Topic:** MS20761 Module 5 Lesson 2 – Build complex conditional logic with CASE
**Beginner Explanation:** This challenge pulls together joins, thresholds, and a `CASE` expression to label banks that need closer monitoring.

```sql
-- Banks requiring supervisory attention
SELECT 
    b.BankName,
    bs.ReportingDate,
    bs.CapitalAdequacyRatio,
    bs.NPLRatio,
    bs.LiquidityRatio,
    CASE 
        WHEN bs.CapitalAdequacyRatio < 10 THEN 'Critical - Below Minimum CAR'
        WHEN bs.NPLRatio > 10 THEN 'High Risk - Excessive NPLs'
        WHEN bs.LiquidityRatio < 20 THEN 'Warning - Low Liquidity'
        ELSE 'Normal'
    END AS 'Risk Assessment'
FROM BankingStatistics bs
JOIN CommercialBanks b ON bs.BankID = b.BankID
WHERE bs.ReportingDate = '2024-09-30'
  AND (
    bs.CapitalAdequacyRatio < 12
    OR bs.NPLRatio > 7
    OR bs.LiquidityRatio < 25
  )
ORDER BY bs.CapitalAdequacyRatio;
```

**Detailed Query Explanation:** The join adds readable bank names, while the `WHERE` clause flags any record failing at least one supervisory threshold. The `CASE` block adds human-readable risk messages based on the most severe issue, and ordering by CAR lets you see the weakest capital positions first.
**Detailed Results Explanation:** The final table tells you which banks triggered alerts, the specific ratios, and the assigned risk label so supervisors know exactly why each bank surfaced.

---

### Exercise 2.15: Time Series Trend Analysis

**Task 26:** Identify inflation trends
**Topic:** MS20761 Module 13 Lesson 2 – Use window functions for trend analysis
**Beginner Explanation:** This pattern computes the previous month with `LAG`, compares it to the current value, and labels the change so you can surface sharp increases or decreases automatically.
```sql
-- Months with significant inflation changes
WITH MonthlyInflation AS (
    SELECT 
        PeriodDate,
        DataValue,
        LAG(DataValue) OVER (ORDER BY PeriodDate) AS PreviousMonth
    FROM TimeSeriesData
    WHERE IndicatorID = 6
)
SELECT 
    PeriodDate,
    DataValue AS CurrentInflation,
    PreviousMonth,
    (DataValue - PreviousMonth) AS Change,
    CASE 
        WHEN (DataValue - PreviousMonth) > 0.5 THEN 'Sharp Increase'
        WHEN (DataValue - PreviousMonth) < -0.5 THEN 'Sharp Decrease'
        ELSE 'Stable'
    END AS Trend
FROM MonthlyInflation
WHERE PreviousMonth IS NOT NULL
  AND ABS(DataValue - PreviousMonth) >= 0.3
ORDER BY PeriodDate DESC;
```

---

### Exercise 2.16: Data Quality Filtering

**Task 27:** Identify provisional vs final data
**Topic:** MS20761 Module 5 Lesson 2 – Filter revision workflows with OR conditions
**Beginner Explanation:** By combining OR predicates on provisional and revision flags, this query extracts all records still in flux so data stewards can focus on pending updates.
```sql
-- Compare provisional and final submissions
SELECT 
    ei.IndicatorName,
    ts.PeriodDate,
    ts.DataValue,
    ts.RevisionNumber,
    ts.IsProvisional,
    ts.IsRevised,
    ts.CollectionDate
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ts.IndicatorID = ei.IndicatorID
WHERE (ts.IsProvisional = 1 OR ts.RevisionNumber > 0)
  AND ts.PeriodDate >= '2024-09-01'
ORDER BY ei.IndicatorName, ts.PeriodDate, ts.RevisionNumber;
```

---

## Practice Exercises (Do It Yourself)

### Beginner Level
1. Find all reports published in 2024
2. List banks established after 2000
3. Show indicators measured in "Percentage"
4. Find all quarterly frequency indicators

### Intermediate Level
5. Get all banking statistics where total loans exceed 5000 million
6. Find staff in "Data Management Division" with Master's degrees
7. Show external data sources from Government Agencies
8. List reports awaiting approval (Status = 'Under Review')

### Advanced Level
9. Find months where both inflation > 5% and reserves > 1000M USD
10. Identify banks with declining deposit trends (compare Q2 vs Q3 2024)
11. Analyze which data sources have the most delayed submissions
12. Find all seasonally adjusted indicators in monetary category

---

## Real-World Scenarios

### Scenario 1: Inflation Target Monitoring
The Monetary Policy Committee wants to see all months where inflation exceeded the upper target band of 6%. Write a query to provide this information with relevant context.

### Scenario 2: Banking Sector Health Check
Create a query to identify banks that need immediate supervisory attention based on key ratios (CAR < 12%, NPL > 8%, or Liquidity < 25%).

### Scenario 3: Data Collection Audit
The Data Management Division needs to audit all external data submissions from the past quarter. Filter for submissions that are still "Pending" or "In Progress".

---

## Key Takeaways

✅ **WHERE Clause:**
- Filters rows before returning results
- Essential for focused data analysis
- Can combine multiple conditions

✅ **Comparison Operators:**
- = (equal), <> or != (not equal)
- <, >, <=, >= for numerical/date comparisons
- Always consider data types

✅ **Logical Operators:**
- AND: All conditions must be true
- OR: At least one condition must be true
- NOT: Negates a condition

✅ **Special Operators:**
- BETWEEN: Range filtering (inclusive)
- IN: Multiple specific values
- LIKE: Pattern matching (%, _)
- IS NULL / IS NOT NULL: Handle missing data

✅ **ORDER BY:**
- Sorts result set
- ASC (ascending) is default
- DESC for descending
- Can sort by multiple columns

---

## Common Mistakes to Avoid

❌ Using = instead of IS NULL for NULL checks  
❌ Forgetting that LIKE is case-insensitive by default  
❌ Not using parentheses with AND/OR combinations  
❌ Comparing dates without considering time component  
❌ Using BETWEEN with exclusive ranges

---

## Next Steps

Proceed to **Module 3: Querying Multiple Tables** where you will learn:
- Understanding table relationships
- INNER JOIN operations
- Combining data from multiple tables
- Working with foreign keys

---

*Central Bank of Lesotho - Research Department*  
*Data Management Division*  
*SQL Training Series - Module 2*
