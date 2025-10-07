# Lab Answers: Working with SQL Server 2016 Data Types

## Exercise 1: Character Data Types - Answers

### Task 1.1: Basic Character Data Operations - Answers

#### Question 1: String concatenation and length analysis
**Task:** Analyze customer names and create formatted display names.

```sql
-- Answer 1: String concatenation and length analysis
USE Northwind;
GO

SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    -- Basic concatenation
    CompanyName + ' - ' + ContactName AS DisplayName,
    -- Length analysis
    LEN(CompanyName) AS CompanyNameLength,
    LEN(ContactName) AS ContactNameLength,
    LEN(CompanyName + ' - ' + ContactName) AS TotalLength,
    -- String functions
    UPPER(CompanyName) AS CompanyNameUpper,
    LOWER(ContactName) AS ContactNameLower,
    -- Substring operations
    LEFT(CompanyName, 10) AS CompanyAbbrev,
    RIGHT(ContactName, CHARINDEX(' ', REVERSE(ContactName)) - 1) AS LastName
FROM Customers
WHERE CompanyName IS NOT NULL AND ContactName IS NOT NULL
ORDER BY CompanyNameLength DESC;
```

#### Question 2: Character data validation
**Task:** Validate and clean character data in the database.

```sql
-- Answer 2: Character data validation
SELECT 
    ProductName,
    LEN(ProductName) AS NameLength,
    -- Check for leading/trailing spaces
    CASE 
        WHEN ProductName <> LTRIM(RTRIM(ProductName)) THEN 'Has Extra Spaces'
        ELSE 'Clean'
    END AS SpaceIsActive,
    -- Clean version
    LTRIM(RTRIM(ProductName)) AS CleanName,
    -- Check for special characters
    CASE 
        WHEN ProductName LIKE '%[^A-Za-z0-9 ''-]%' THEN 'Has Special Chars'
        ELSE 'Standard Chars Only'
    END AS CharacterValidation,
    -- Extract first word
    CASE 
        WHEN CHARINDEX(' ', ProductName) > 0 
        THEN LEFT(ProductName, CHARINDEX(' ', ProductName) - 1)
        ELSE ProductName
    END AS FirstWord
FROM Products
ORDER BY NameLength DESC;
```

### Task 1.2: Advanced String Manipulation - Answers

#### Question 1: WorkEmail domain analysis
**Task:** Extract and analyze email domains from contact information.

```sql
-- Answer 1: WorkEmail domain analysis
-- Note: Northwind doesn't have email fields, so we'll simulate this
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    -- Simulate email addresses
    LOWER(REPLACE(ContactName, ' ', '.')) + '@' + 
    LOWER(REPLACE(CompanyName, ' ', '')) + '.com' AS SimulatedEmail,
    -- Extract parts
    LOWER(REPLACE(ContactName, ' ', '.')) AS EmailUser,
    LOWER(REPLACE(CompanyName, ' ', '')) + '.com' AS EmailDomain,
    -- Analyze domain
    CASE 
        WHEN LOWER(REPLACE(CompanyName, ' ', '')) + '.com' LIKE '%.gov'
        THEN 'Government'
        WHEN LOWER(REPLACE(CompanyName, ' ', '')) + '.com' LIKE '%.edu'
        THEN 'Education'
        WHEN LOWER(REPLACE(CompanyName, ' ', '')) + '.com' LIKE '%.org'
        THEN 'Organization'
        ELSE 'Commercial'
    END AS DomainType
FROM Customers
WHERE ContactName IS NOT NULL AND CompanyName IS NOT NULL
ORDER BY EmailDomain;
```

#### Question 2: Pattern matching and replacement
**Task:** Use pattern matching to categorize and format product names.

```sql
-- Answer 2: Pattern matching and replacement
SELECT 
    ProductName,
    CategoryID,
    -- Pattern matching for product types
    CASE 
        WHEN ProductName LIKE '%Cheese%' THEN 'Cheese Product'
        WHEN ProductName LIKE '%Coffee%' OR ProductName LIKE '%Tea%' THEN 'Hot Beverage'
        WHEN ProductName LIKE '%Beer%' OR ProductName LIKE '%Wine%' THEN 'Alcoholic Beverage'
        WHEN ProductName LIKE '%Sauce%' OR ProductName LIKE '%Syrup%' THEN 'Condiment'
        WHEN ProductName LIKE '%Meat%' OR ProductName LIKE '%Beef%' OR ProductName LIKE '%Chicken%' THEN 'Meat Product'
        ELSE 'Other'
    END AS ProductType,
    -- Format product name
    STUFF(ProductName, 1, 1, UPPER(LEFT(ProductName, 1))) AS FormattedName,
    -- Replace common abbreviations
    REPLACE(REPLACE(REPLACE(ProductName, '&', 'and'), 'Co.', 'Company'), 'Ltd.', 'Limited') AS ExpandedName,
    -- Create product code
    UPPER(LEFT(ProductName, 3)) + '-' + CAST(ProductID AS VARCHAR(5)) AS ProductCode
FROM Products
ORDER BY ProductType, ProductName;
```

## Exercise 2: Numeric Data Types - Answers

### Task 2.1: Precision and Scale Handling - Answers

#### Question 1: Price calculations with different precision
**Task:** Perform price calculations showing precision and rounding effects.

```sql
-- Answer 1: Price calculations with different precision
SELECT 
    ProductName,
    BaseSalary,
    -- Different precision calculations
    BaseSalary * 1.15 AS PriceWith15PercentIncrease,
    ROUND(BaseSalary * 1.15, 2) AS RoundedPrice,
    CEILING(BaseSalary * 1.15) AS CeilingPrice,
    FLOOR(BaseSalary * 1.15) AS FloorPrice,
    -- Discount calculations
    BaseSalary * 0.90 AS DiscountedPrice,
    BaseSalary - (BaseSalary * 0.10) AS AlternativeDiscount,
    -- Precision demonstration
    CAST(BaseSalary AS DECIMAL(10,4)) AS HighPrecisionPrice,
    CAST(BaseSalary AS DECIMAL(6,1)) AS LowPrecisionPrice,
    -- Calculate tax (different rates)
    BaseSalary * 1.08 AS PriceWithTax8Percent,
    ROUND(BaseSalary * 1.08, 2) AS RoundedTaxPrice
FROM Products
WHERE BaseSalary IS NOT NULL
ORDER BY BaseSalary DESC;
```

#### Question 2: Inventory value analysis
**Task:** Calculate inventory values with proper numeric handling.

```sql
-- Answer 2: Inventory value analysis
SELECT 
    ProductName,
    BaseSalary,
    UnitsInStock,
    -- Basic inventory calculations
    COALESCE(BaseSalary * UnitsInStock, 0) AS InventoryValue,
    -- Handle NULL values properly
    CASE 
        WHEN BaseSalary IS NULL OR UnitsInStock IS NULL THEN 0
        ELSE BaseSalary * UnitsInStock
    END AS SafeInventoryValue,
    -- Different rounding strategies
    ROUND(COALESCE(BaseSalary * UnitsInStock, 0), 0) AS RoundedValue,
    CEILING(COALESCE(BaseSalary * UnitsInStock, 0)) AS CeilingValue,
    -- Percentage of total inventory
    COALESCE(BaseSalary * UnitsInStock, 0) / 
    NULLIF((SELECT SUM(BaseSalary * UnitsInStock) FROM Products WHERE BaseSalary IS NOT NULL AND UnitsInStock IS NOT NULL), 0) * 100 AS PercentOfTotal,
    -- Value categories
    CASE 
        WHEN COALESCE(BaseSalary * UnitsInStock, 0) > 1000 THEN 'High Value'
        WHEN COALESCE(BaseSalary * UnitsInStock, 0) > 500 THEN 'Medium Value'
        WHEN COALESCE(BaseSalary * UnitsInStock, 0) > 0 THEN 'Low Value'
        ELSE 'No Value'
    END AS ValueCategory
FROM Products
ORDER BY InventoryValue DESC;
```

### Task 2.2: Mathematical Operations - Answers

#### Question 1: Statistical analysis of prices
**Task:** Perform statistical calculations on product prices.

```sql
-- Answer 1: Statistical analysis of prices
SELECT 
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    -- Basic statistics
    MIN(p.BaseSalary) AS MinPrice,
    MAX(p.BaseSalary) AS MaxPrice,
    AVG(p.BaseSalary) AS AvgPrice,
    -- Advanced calculations
    STDEV(p.BaseSalary) AS StandardDeviation,
    VAR(p.BaseSalary) AS Variance,
    -- Percentile approximations
    AVG(p.BaseSalary) - STDEV(p.BaseSalary) AS LowerBound,
    AVG(p.BaseSalary) + STDEV(p.BaseSalary) AS UpperBound,
    -- Range analysis
    MAX(p.BaseSalary) - MIN(p.BaseSalary) AS PriceRange,
    (MAX(p.BaseSalary) - MIN(p.BaseSalary)) / NULLIF(AVG(p.BaseSalary), 0) * 100 AS RangeAsPercentOfAvg
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.BaseSalary IS NOT NULL
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) > 3
ORDER BY AvgPrice DESC;
```

#### Question 2: Financial calculations
**Task:** Perform compound interest and growth calculations.

```sql
-- Answer 2: Financial calculations
SELECT 
    ProductName,
    BaseSalary AS CurrentPrice,
    -- Simple interest calculations (assuming 5% annual growth)
    BaseSalary * POWER(1.05, 1) AS PriceAfter1Year,
    BaseSalary * POWER(1.05, 2) AS PriceAfter2Years,
    BaseSalary * POWER(1.05, 5) AS PriceAfter5Years,
    -- Compound monthly (5% annual, compounded monthly)
    BaseSalary * POWER(1 + 0.05/12, 12) AS MonthlyCompound1Year,
    -- Logarithmic calculations
    LOG(BaseSalary) AS NaturalLog,
    LOG10(BaseSalary) AS Log10,
    -- Growth rate needed to double price in 5 years
    POWER(2, 1.0/5) - 1 AS RequiredGrowthRate,
    -- Present value calculations (discount rate 8%)
    BaseSalary / POWER(1.08, 1) AS PresentValue1Year,
    BaseSalary / POWER(1.08, 5) AS PresentValue5Years
FROM Products
WHERE BaseSalary > 10  -- Only meaningful prices
ORDER BY BaseSalary DESC;
```

## Exercise 3: Date and Time Data Types - Answers

### Task 3.1: Date Arithmetic and Calculations - Answers

#### Question 1: Order processing time analysis
**Task:** Analyze order processing and shipping times.

```sql
-- Answer 1: Order processing time analysis
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    -- Basic date differences
    DATEDIFF(DAY, OrderDate, RequiredDate) AS DaysToRequired,
    DATEDIFF(DAY, OrderDate, COALESCE(ShippedDate, GETDATE())) AS DaysToShipped,
    DATEDIFF(DAY, RequiredDate, ShippedDate) AS DaysLateOrEarly,
    -- Processing time categories
    CASE 
        WHEN ShippedDate IS NULL THEN 'Not Shipped'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 3 THEN 'Fast'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 7 THEN 'Normal'
        WHEN DATEDIFF(DAY, OrderDate, ShippedDate) <= 14 THEN 'Slow'
        ELSE 'Very Slow'
    END AS ProcessingSpeed,
    -- On-time delivery analysis
    CASE 
        WHEN ShippedDate IS NULL THEN 'Pending'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
        WHEN DATEDIFF(DAY, RequiredDate, ShippedDate) <= 2 THEN 'Slightly Late'
        ELSE 'Late'
    END AS DeliveryIsActive,
    -- Business days calculation (approximate)
    CASE 
        WHEN ShippedDate IS NOT NULL THEN
            DATEDIFF(DAY, OrderDate, ShippedDate) - 
            (DATEDIFF(WEEK, OrderDate, ShippedDate) * 2)
        ELSE NULL
    END AS BusinessDaysToShip
FROM Orders
WHERE OrderDate >= '1997-01-01'
ORDER BY OrderDate DESC;
```

#### Question 2: Employee tenure and age analysis
**Task:** Calculate employee tenure and age-related statistics.

```sql
-- Answer 2: Employee tenure and age analysis
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS EmployeeName,
    BirthDate,
    HireDate,
    -- Age calculations
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS CurrentAge,
    DATEDIFF(YEAR, BirthDate, HireDate) AS AgeWhenHired,
    -- Tenure calculations
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    DATEDIFF(MONTH, HireDate, GETDATE()) AS MonthsOfService,
    DATEDIFF(DAY, HireDate, GETDATE()) AS DaysOfService,
    -- Milestone calculations
    DATEADD(YEAR, 5, HireDate) AS FiveYearAnniversary,
    DATEADD(YEAR, 10, HireDate) AS TenYearAnniversary,
    DATEADD(YEAR, 65 - DATEDIFF(YEAR, BirthDate, GETDATE()), GETDATE()) AS RetirementDate,
    -- Service categories
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran (10+ years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN 'Experienced (5-9 years)'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 2 THEN 'Established (2-4 years)'
        ELSE 'New (0-1 years)'
    END AS ServiceCategory,
    -- Generation analysis
    CASE 
        WHEN YEAR(BirthDate) >= 1980 THEN 'Millennial'
        WHEN YEAR(BirthDate) >= 1965 THEN 'Generation X'
        WHEN YEAR(BirthDate) >= 1946 THEN 'Baby Boomer'
        ELSE 'Silent Generation'
    END AS Generation
FROM Employees
WHERE BirthDate IS NOT NULL AND HireDate IS NOT NULL
ORDER BY YearsOfService DESC;
```

### Task 3.2: Date Formatting and Extraction - Answers

#### Question 1: Sales reporting by time periods
**Task:** Create time-based sales reports with various date formats.

```sql
-- Answer 1: Sales reporting by time periods
SELECT 
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    DATENAME(MONTH, OrderDate) AS MonthName,
    DATEPART(QUARTER, OrderDate) AS Quarter,
    DATEPART(WEEK, OrderDate) AS WeekNumber,
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
    -- Formatted dates
    FORMAT(OrderDate, 'yyyy-MM') AS YearMonth,
    FORMAT(OrderDate, 'MMMM yyyy') AS MonthYear,
    FORMAT(OrderDate, 'dd/MM/yyyy') AS FormattedDate,
    FORMAT(OrderDate, 'dddd, MMMM dd, yyyy') AS LongDate,
    -- Sales metrics
    COUNT(OrderID) AS OrderCount,
    AVG(Freight) AS AvgFreight,
    SUM(Freight) AS TotalFreight,
    -- First and last order dates
    MIN(OrderDate) AS FirstOrderDate,
    MAX(OrderDate) AS LastOrderDate
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01'
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate),
    DATEPART(QUARTER, OrderDate),
    DATEPART(WEEK, OrderDate),
    DATENAME(WEEKDAY, OrderDate)
ORDER BY OrderYear, OrderMonth;
```

#### Question 2: Date range and period analysis
**Task:** Analyze data across different date ranges and periods.

```sql
-- Answer 2: Date range and period analysis
SELECT 
    'Current Month' AS Period,
    COUNT(*) AS OrderCount,
    AVG(Freight) AS AvgFreight
FROM Orders
WHERE OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))

UNION ALL

SELECT 
    'Last 30 Days',
    COUNT(*),
    AVG(Freight)
FROM Orders
WHERE OrderDate >= DATEADD(DAY, -30, GETDATE())

UNION ALL

SELECT 
    'Current Quarter',
    COUNT(*),
    AVG(Freight)
FROM Orders
WHERE OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), ((DATEPART(QUARTER, GETDATE()) - 1) * 3) + 1, 1)

UNION ALL

SELECT 
    'Year To Date',
    COUNT(*),
    AVG(Freight)
FROM Orders
WHERE YEAR(OrderDate) = YEAR(GETDATE())

UNION ALL

SELECT 
    'Previous Year Same Period',
    COUNT(*),
    AVG(Freight)
FROM Orders
WHERE OrderDate >= DATEADD(YEAR, -1, DATEFROMPARTS(YEAR(GETDATE()), 1, 1))
  AND OrderDate < DATEADD(YEAR, -1, DATEFROMPARTS(YEAR(GETDATE()) + 1, 1, 1))

ORDER BY Period;
```

## Exercise 4: Advanced Data Type Operations - Answers

### Task 4.1: Data Type Conversions - Answers

#### Question 1: Safe data type conversions
**Task:** Demonstrate safe conversion techniques between data types.

```sql
-- Answer 1: Safe data type conversions
SELECT 
    ProductName,
    BaseSalary,
    UnitsInStock,
    -- String to numeric conversions (safe)
    CASE 
        WHEN ISNUMERIC(CAST(ProductID AS VARCHAR(10))) = 1 
        THEN CAST(ProductID AS VARCHAR(10))
        ELSE 'Invalid'
    END AS ProductIDString,
    -- Numeric to string with formatting
    FORMAT(BaseSalary, 'C', 'en-US') AS FormattedPrice,
    FORMAT(BaseSalary, 'N2') AS NumericFormat,
    CAST(BaseSalary AS VARCHAR(20)) AS PriceString,
    STR(BaseSalary, 10, 2) AS STRFunction,
    -- Date conversions
    CAST(GETDATE() AS DATE) AS DateOnly,
    CAST(GETDATE() AS TIME) AS TimeOnly,
    CONVERT(VARCHAR(20), GETDATE(), 101) AS USDateFormat,
    CONVERT(VARCHAR(20), GETDATE(), 103) AS UKDateFormat,
    CONVERT(VARCHAR(20), GETDATE(), 120) AS ISO8601Format,
    -- Boolean-like conversions
    CASE WHEN Discontinued = 1 THEN 'Yes' ELSE 'No' END AS DiscontinuedText,
    CAST(Discontinued AS VARCHAR(5)) AS DiscontinuedString
FROM Products
WHERE BaseSalary IS NOT NULL
ORDER BY ProductName;
```

#### Question 2: Data validation and conversion errors
**Task:** Handle potential conversion errors gracefully.

```sql
-- Answer 2: Data validation and conversion errors
SELECT 
    CustomerID,
    CompanyName,
    PostalCode,
    -- Safe numeric conversion of postal codes
    CASE 
        WHEN ISNUMERIC(PostalCode) = 1 AND PostalCode NOT LIKE '%.%'
        THEN TRY_CAST(PostalCode AS INT)
        ELSE NULL
    END AS NumericPostalCode,
    -- Length validation
    CASE 
        WHEN LEN(PostalCode) = 5 AND ISNUMERIC(PostalCode) = 1 THEN 'US ZIP'
        WHEN LEN(PostalCode) = 10 AND PostalCode LIKE '_____-____' THEN 'US ZIP+4'
        WHEN LEN(LTRIM(RTRIM(PostalCode))) BETWEEN 5 AND 7 THEN 'International'
        ELSE 'Invalid Format'
    END AS PostalCodeType,
    -- Phone number formatting (if available)
    CASE 
        WHEN LEN(REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', '')) = 10
        AND ISNUMERIC(REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', '')) = 1
        THEN '(' + LEFT(REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', ''), 3) + ') ' +
             SUBSTRING(REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', ''), 4, 3) + '-' +
             RIGHT(REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', ''), 4)
        ELSE 'N/A'
    END AS FormattedPhone,
    -- Data quality score
    (CASE WHEN CustomerID IS NOT NULL THEN 1 ELSE 0 END +
     CASE WHEN CompanyName IS NOT NULL AND LEN(CompanyName) > 0 THEN 1 ELSE 0 END +
     CASE WHEN PostalCode IS NOT NULL AND LEN(PostalCode) > 0 THEN 1 ELSE 0 END) AS DataQualityScore
FROM Customers
ORDER BY DataQualityScore DESC, CustomerID;
```

### Task 4.2: Complex Data Manipulations - Answers

#### Question 1: Multi-step data transformations
**Task:** Perform complex data transformations combining multiple operations.

```sql
-- Answer 1: Multi-step data transformations
WITH ProductAnalysis AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        p.BaseSalary,
        p.UnitsInStock,
        c.CategoryName,
        -- Calculate derived values
        COALESCE(p.BaseSalary * p.UnitsInStock, 0) AS InventoryValue,
        ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.BaseSalary DESC) AS PriceRankInCategory,
        NTILE(4) OVER (ORDER BY p.BaseSalary) AS PriceQuartile
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE p.BaseSalary IS NOT NULL
),
CategoryStats AS (
    SELECT 
        CategoryName,
        COUNT(*) AS ProductCount,
        AVG(BaseSalary) AS AvgPrice,
        MAX(BaseSalary) AS MaxPrice,
        SUM(InventoryValue) AS TotalInventoryValue
    FROM ProductAnalysis
    GROUP BY CategoryName
)
SELECT 
    pa.ProductName,
    pa.CategoryName,
    pa.BaseSalary,
    pa.InventoryValue,
    pa.PriceRankInCategory,
    CASE 
        WHEN pa.PriceQuartile = 4 THEN 'Premium'
        WHEN pa.PriceQuartile = 3 THEN 'High'
        WHEN pa.PriceQuartile = 2 THEN 'Medium'
        ELSE 'Budget'
    END AS PriceTier,
    cs.AvgPrice AS CategoryAvgPrice,
    pa.BaseSalary - cs.AvgPrice AS PriceVsAverage,
    CAST((pa.InventoryValue * 100.0 / cs.TotalInventoryValue) AS DECIMAL(5,2)) AS PercentOfCategoryValue,
    -- Complex formatting
    CONCAT(
        pa.ProductName, 
        ' (', 
        pa.CategoryName, 
        ') - $', 
        FORMAT(pa.BaseSalary, 'N2'),
        CASE 
            WHEN pa.PriceRankInCategory = 1 THEN ' [TOP PRICE]'
            WHEN pa.BaseSalary > cs.AvgPrice THEN ' [ABOVE AVG]'
            ELSE ''
        END
    ) AS ProductSummary
FROM ProductAnalysis pa
INNER JOIN CategoryStats cs ON pa.CategoryName = cs.CategoryName
ORDER BY pa.CategoryName, pa.PriceRankInCategory;
```

## Exercise 5: Data Type Best Practices - Answers

### Task 5.1: Performance Optimization - Answers

#### Question 1: Efficient data type usage
**Task:** Demonstrate efficient data type selection for performance.

```sql
-- Answer 1: Efficient data type usage
-- Create a temporary analysis table to demonstrate concepts
WITH DataTypeAnalysis AS (
    SELECT 
        ProductID,
        ProductName,
        -- Appropriate numeric types
        CAST(BaseSalary AS DECIMAL(19,4)) AS PrecisePrice,  -- High precision for financial
        CAST(UnitsInStock AS SMALLINT) AS StockCount,      -- Small range, use SMALLINT
        CAST(Discontinued AS BIT) AS IsDiscontinued,       -- Boolean values
        -- String types optimization
        CAST(ProductName AS NVARCHAR(40)) AS OptimizedName, -- Fixed appropriate size
        -- Date optimization
        CAST(GETDATE() AS DATE) AS DateOnly,               -- DATE vs DATETIME when time not needed
        -- Avoid implicit conversions
        ProductID AS IntegerID,                            -- Keep as INT, don't convert unnecessarily
        -- Index-friendly operations
        LEFT(ProductName, 1) AS FirstLetter                -- Deterministic for indexing
    FROM Products
    WHERE ProductID IS NOT NULL
)
SELECT 
    *,
    -- Show data type sizes for comparison
    DATALENGTH(OptimizedName) AS OptimizedNameBytes,
    DATALENGTH(ProductName) AS OriginalNameBytes,
    -- Demonstrate efficient filtering
    CASE 
        WHEN FirstLetter BETWEEN 'A' AND 'M' THEN 'First Half'
        ELSE 'Second Half'
    END AS AlphabeticalGroup
FROM DataTypeAnalysis
ORDER BY ProductID;
```

#### Question 2: Index-friendly queries
**Task:** Write queries that work efficiently with indexes.

```sql
-- Answer 2: Index-friendly queries
-- Demonstrate SARGABLE vs non-SARGABLE predicates

-- GOOD: Index-friendly queries
SELECT 
    ProductID,
    ProductName,
    BaseSalary
FROM Products
WHERE ProductID BETWEEN 10 AND 20           -- SARGABLE: Can use index seek
  AND BaseSalary >= 10.00                    -- SARGABLE: Can use index
  AND ProductName LIKE 'C%'                 -- SARGABLE: Can use index for prefix

UNION ALL

-- Show date range filtering (index-friendly)
SELECT 
    OrderID,
    CustomerID,
    OrderDate
FROM Orders
WHERE OrderDate >= '1997-01-01'             -- SARGABLE: Can use index
  AND OrderDate < '1997-02-01'              -- SARGABLE: Range query

UNION ALL

-- AVOID: Non-index-friendly queries (examples of what NOT to do)
-- These are shown for educational purposes
SELECT 
    ProductID,
    ProductName,
    BaseSalary
FROM Products
WHERE UPPER(ProductName) LIKE 'C%'          -- NON-SARGABLE: Function on column
  OR SUBSTRING(ProductName, 1, 1) = 'C'     -- NON-SARGABLE: Function on column
  OR ProductID * 2 = 20                     -- NON-SARGABLE: Calculation on column

-- Better alternatives demonstrated:
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    -- Show efficient pattern matching
    CASE 
        WHEN ProductName LIKE 'A%' THEN 'Starts with A'
        WHEN ProductName LIKE 'B%' THEN 'Starts with B'
        WHEN ProductName LIKE 'C%' THEN 'Starts with C'
        ELSE 'Other'
    END AS NameCategory,
    -- Efficient date calculations
    DATEDIFF(YEAR, '1990-01-01', GETDATE()) AS YearsSince1990
FROM Products
WHERE ProductName >= 'C' AND ProductName < 'D'  -- Range query instead of LIKE 'C%'
ORDER BY ProductID;
```

### Task 5.2: Data Integrity and Validation - Answers

#### Question 1: Comprehensive data validation
**Task:** Implement comprehensive data validation checks.

```sql
-- Answer 1: Comprehensive data validation
WITH ValidationResults AS (
    SELECT 
        ProductID,
        ProductName,
        BaseSalary,
        UnitsInStock,
        Discontinued,
        -- Validation checks
        CASE 
            WHEN ProductName IS NULL OR LEN(LTRIM(RTRIM(ProductName))) = 0 
            THEN 'Product name is required'
            WHEN LEN(ProductName) > 40 
            THEN 'Product name too long'
            ELSE 'Valid'
        END AS NameValidation,
        
        CASE 
            WHEN BaseSalary IS NULL 
            THEN 'Price is required'
            WHEN BaseSalary < 0 
            THEN 'Price cannot be negative'
            WHEN BaseSalary > 999.99 
            THEN 'Price exceeds maximum'
            ELSE 'Valid'
        END AS PriceValidation,
        
        CASE 
            WHEN UnitsInStock IS NULL 
            THEN 'Stock level is required'
            WHEN UnitsInStock < 0 
            THEN 'Stock cannot be negative'
            WHEN UnitsInStock > 32767 
            THEN 'Stock exceeds maximum'
            ELSE 'Valid'
        END AS StockValidation,
        
        CASE 
            WHEN Discontinued NOT IN (0, 1) 
            THEN 'Discontinued must be 0 or 1'
            ELSE 'Valid'
        END AS DiscontinuedValidation
    FROM Products
),
ValidationSummary AS (
    SELECT 
        *,
        CASE 
            WHEN NameValidation = 'Valid' 
             AND PriceValidation = 'Valid' 
             AND StockValidation = 'Valid' 
             AND DiscontinuedValidation = 'Valid'
            THEN 'PASS'
            ELSE 'FAIL'
        END AS OverallValidation,
        -- Count validation errors
        (CASE WHEN NameValidation <> 'Valid' THEN 1 ELSE 0 END +
         CASE WHEN PriceValidation <> 'Valid' THEN 1 ELSE 0 END +
         CASE WHEN StockValidation <> 'Valid' THEN 1 ELSE 0 END +
         CASE WHEN DiscontinuedValidation <> 'Valid' THEN 1 ELSE 0 END) AS ErrorCount
    FROM ValidationResults
)
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    UnitsInStock,
    OverallValidation,
    ErrorCount,
    -- Show specific validation errors
    CASE 
        WHEN ErrorCount = 0 THEN 'All validations passed'
        ELSE 
            STUFF(
                (CASE WHEN NameValidation <> 'Valid' THEN '; ' + NameValidation ELSE '' END +
                 CASE WHEN PriceValidation <> 'Valid' THEN '; ' + PriceValidation ELSE '' END +
                 CASE WHEN StockValidation <> 'Valid' THEN '; ' + StockValidation ELSE '' END +
                 CASE WHEN DiscontinuedValidation <> 'Valid' THEN '; ' + DiscontinuedValidation ELSE '' END),
                1, 2, ''
            )
    END AS ValidationErrors
FROM ValidationSummary
ORDER BY ErrorCount DESC, ProductID;
```

## Key Learning Points Summary

### Character Data Type Mastery
1. **String Functions**: LEN, LEFT, RIGHT, SUBSTRING, CHARINDEX, REPLACE, STUFF
2. **Case Conversion**: UPPER, LOWER, proper case techniques
3. **Trimming**: LTRIM, RTRIM for cleaning data
4. **Pattern Matching**: LIKE operator with % and _ wildcards
5. **Concatenation**: + operator and CONCAT function
6. **Unicode Handling**: NCHAR, NVARCHAR for international characters

### Numeric Data Type Operations
1. **Precision and Scale**: DECIMAL, NUMERIC for exact calculations
2. **Rounding Functions**: ROUND, CEILING, FLOOR
3. **Mathematical Functions**: POWER, LOG, SQRT, ABS
4. **Statistical Functions**: AVG, STDEV, VAR
5. **Type Conversion**: CAST, CONVERT, TRY_CAST for safe conversions
6. **Financial Calculations**: Compound interest, present value calculations

### Date and Time Handling
1. **Date Arithmetic**: DATEDIFF, DATEADD for calculations
2. **Date Parts**: YEAR, MONTH, DAY, DATEPART, DATENAME
3. **Formatting**: FORMAT, CONVERT with style codes
4. **Date Construction**: DATEFROMPARTS for building dates
5. **Current Date/Time**: GETDATE, SYSDATETIME, GETUTCDATE
6. **Business Logic**: Working days, age calculations, tenure analysis

### Data Type Best Practices
1. **Appropriate Sizing**: Choose smallest appropriate data type
2. **Index Optimization**: Write SARGABLE queries
3. **Conversion Safety**: Use TRY_CAST to avoid errors
4. **Validation Logic**: Implement comprehensive data validation
5. **Performance Considerations**: Avoid functions on indexed columns
6. **Data Integrity**: Ensure consistent data types across related columns

### Advanced Techniques Applied
1. **Complex Transformations**: Multi-step data processing with CTEs
2. **Window Functions**: ROW_NUMBER, NTILE for ranking and distribution
3. **Conditional Logic**: CASE expressions for complex business rules
4. **Error Handling**: TRY_CAST, ISNUMERIC for safe operations
5. **Data Quality**: Validation rules and quality scoring
6. **Formatting Standards**: Consistent display formats for different data types