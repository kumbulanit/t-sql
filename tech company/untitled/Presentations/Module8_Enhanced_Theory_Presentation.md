# Module 8: Grouping and Aggregating Data - Enhanced Theory Presentation

## Slide 1: Module Overview
**Mastering Data Aggregation: GROUP BY, HAVING, and Advanced Analytics**

### Learning Objectives
- **Aggregation Mastery**: Complete understanding of GROUP BY mechanics and aggregate functions
- **Advanced Grouping**: ROLLUP, CUBE, and GROUPING SETS for multi-dimensional analysis
- **HAVING Clause Expertise**: Filtering grouped data with complex conditions
- **Window Functions**: Advanced analytics with OVER clause and partitioning
- **Performance Optimization**: Efficient grouping strategies and index design
- **Business Intelligence**: Real-world reporting and analytical query patterns

### Module Structure
- **Fundamentals**: GROUP BY clause mechanics and aggregate function theory
- **Advanced Techniques**: Multi-level grouping and analytical functions
- **Performance Engineering**: Optimization strategies for aggregation queries
- **Practical Applications**: Business reporting and data analysis scenarios

---

## Slide 2: GROUP BY Fundamentals and Mechanics
**Understanding Data Aggregation and Grouping Theory**

### GROUP BY Processing Order

#### **Logical Query Processing with GROUP BY**
```sql
-- Complete GROUP BY query structure and processing order
SELECT 
    -- 5. SELECT: Project aggregated results
    Department,
    JobTitle,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AverageSalary,
    SUM(Salary) AS TotalSalary,
    MIN(HireDate) AS EarliestHire,
    MAX(HireDate) AS LatestHire
-- 1. FROM: Start with source table
FROM Employees
-- 2. WHERE: Filter individual rows (before grouping)
WHERE IsActive = 1 
    AND HireDate >= '2020-01-01'
-- 3. GROUP BY: Group rows by specified columns
GROUP BY Department, JobTitle
-- 4. HAVING: Filter groups (after grouping)
HAVING COUNT(*) >= 3 
    AND AVG(Salary) > 50000
-- 6. ORDER BY: Sort final result set
ORDER BY Department, AverageSalary DESC;
```

#### **Grouping Rules and Constraints**
```sql
-- Understanding GROUP BY rules and valid expressions
CREATE TABLE SalesData (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    SalesPersonID INT,
    CustomerID INT,
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Commission DECIMAL(5,4)
);

-- VALID: All non-aggregate columns in SELECT must be in GROUP BY
SELECT 
    SalesPersonID,
    YEAR(SaleDate) AS SaleYear,
    COUNT(*) AS TotalSales,
    SUM(Quantity * UnitPrice) AS TotalRevenue,
    AVG(Commission) AS AverageCommission
FROM SalesData
GROUP BY SalesPersonID, YEAR(SaleDate);

-- INVALID: CustomerID not in GROUP BY but in SELECT
-- SELECT SalesPersonID, CustomerID, COUNT(*) FROM SalesData GROUP BY SalesPersonID;

-- VALID: Expressions in SELECT that match GROUP BY expressions
SELECT 
    SalesPersonID,
    CASE 
        WHEN MONTH(SaleDate) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(SaleDate) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(SaleDate) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    SUM(Quantity * UnitPrice) AS QuarterlyRevenue
FROM SalesData
GROUP BY SalesPersonID, 
         CASE 
             WHEN MONTH(SaleDate) BETWEEN 1 AND 3 THEN 'Q1'
             WHEN MONTH(SaleDate) BETWEEN 4 AND 6 THEN 'Q2'
             WHEN MONTH(SaleDate) BETWEEN 7 AND 9 THEN 'Q3'
             ELSE 'Q4'
         END;
```

### Aggregate Functions Deep Dive

#### **Statistical Aggregate Functions**
```sql
-- Comprehensive aggregate function examples
WITH ProductSales AS (
    SELECT 'Electronics' AS Category, 'Laptop' AS Product, 1200.00 AS Price, 5 AS UnitsSold UNION ALL
    SELECT 'Electronics', 'Phone', 800.00, 12 UNION ALL
    SELECT 'Electronics', 'Tablet', 600.00, 8 UNION ALL
    SELECT 'Clothing', 'Shirt', 45.00, 25 UNION ALL
    SELECT 'Clothing', 'Pants', 75.00, 15 UNION ALL
    SELECT 'Clothing', 'Shoes', 120.00, 10 UNION ALL
    SELECT 'Books', 'Novel', 15.00, 50 UNION ALL
    SELECT 'Books', 'Textbook', 200.00, 8 UNION ALL
    SELECT 'Books', 'Magazine', 5.00, 100
)
SELECT 
    Category,
    
    -- Count functions
    COUNT(*) AS ProductCount,
    COUNT(Price) AS NonNullPrices,
    COUNT(DISTINCT FLOOR(Price/100)*100) AS PriceRanges,
    
    -- Sum and average
    SUM(Price * UnitsSold) AS TotalRevenue,
    SUM(UnitsSold) AS TotalUnitsSold,
    AVG(Price) AS AveragePrice,
    AVG(Price * UnitsSold) AS AverageRevenue,
    
    -- Min and Max
    MIN(Price) AS CheapestProduct,
    MAX(Price) AS MostExpensiveProduct,
    MIN(UnitsSold) AS LowestSales,
    MAX(UnitsSold) AS HighestSales,
    
    -- Standard deviation and variance (SQL Server 2008+)
    STDEV(Price) AS PriceStandardDeviation,
    VAR(Price) AS PriceVariance,
    
    -- Statistical functions
    STDEVP(Price) AS PriceStandardDeviationPopulation,
    VARP(Price) AS PriceVariancePopulation
FROM ProductSales
GROUP BY Category
ORDER BY TotalRevenue DESC;
```

#### **String Aggregation**
```sql
-- String aggregation using STRING_AGG (SQL Server 2017+)
SELECT 
    Category,
    COUNT(*) AS ProductCount,
    STRING_AGG(Product, ', ') AS ProductList,
    STRING_AGG(Product, ', ') WITHIN GROUP (ORDER BY Price DESC) AS ProductsByPrice,
    STRING_AGG(CONCAT(Product, ' ($', CAST(Price AS VARCHAR(10)), ')'), '; ') AS ProductsWithPrices
FROM ProductSales
GROUP BY Category
ORDER BY Category;

-- For older SQL Server versions, use XML PATH
SELECT 
    Category,
    STUFF((
        SELECT ', ' + Product
        FROM ProductSales ps2
        WHERE ps2.Category = ps1.Category
        ORDER BY Product
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ProductList
FROM ProductSales ps1
GROUP BY Category;
```

---

## Slide 3: Advanced Grouping with ROLLUP, CUBE, and GROUPING SETS
**Multi-Dimensional Data Analysis**

### ROLLUP Operation

#### **Hierarchical Aggregation**
```sql
-- ROLLUP for hierarchical subtotals
WITH SalesHierarchy AS (
    SELECT 'North' AS Region, 'Electronics' AS Category, 'Laptop' AS Product, 15000.00 AS Sales UNION ALL
    SELECT 'North', 'Electronics', 'Phone', 12000.00 UNION ALL
    SELECT 'North', 'Clothing', 'Shirt', 8000.00 UNION ALL
    SELECT 'North', 'Clothing', 'Pants', 6000.00 UNION ALL
    SELECT 'South', 'Electronics', 'Laptop', 18000.00 UNION ALL
    SELECT 'South', 'Electronics', 'Phone', 14000.00 UNION ALL
    SELECT 'South', 'Clothing', 'Shirt', 9000.00 UNION ALL
    SELECT 'South', 'Clothing', 'Pants', 7000.00
)
SELECT 
    Region,
    Category,
    Product,
    SUM(Sales) AS TotalSales,
    -- GROUPING function shows aggregation level
    GROUPING(Region) AS Region_Grouping,
    GROUPING(Category) AS Category_Grouping,
    GROUPING(Product) AS Product_Grouping,
    -- Identify aggregation level
    CASE 
        WHEN GROUPING(Region) = 1 THEN 'Grand Total'
        WHEN GROUPING(Category) = 1 THEN 'Region Total'
        WHEN GROUPING(Product) = 1 THEN 'Category Total'
        ELSE 'Product Detail'
    END AS AggregationLevel
FROM SalesHierarchy
GROUP BY ROLLUP(Region, Category, Product)
ORDER BY GROUPING(Region), Region, GROUPING(Category), Category, GROUPING(Product), Product;
```

### CUBE Operation

#### **Multi-Dimensional Cross-Tabulation**
```sql
-- CUBE for all possible combinations
SELECT 
    Region,
    Category,
    SUM(Sales) AS TotalSales,
    COUNT(*) AS ProductCount,
    -- GROUPING_ID provides unique identifier for each grouping combination
    GROUPING_ID(Region, Category) AS GroupingID,
    CASE GROUPING_ID(Region, Category)
        WHEN 0 THEN 'Region + Category Detail'  -- 00
        WHEN 1 THEN 'Region Total'              -- 01
        WHEN 2 THEN 'Category Total'            -- 10
        WHEN 3 THEN 'Grand Total'               -- 11
    END AS GroupingDescription
FROM SalesHierarchy
GROUP BY CUBE(Region, Category)
ORDER BY GROUPING_ID(Region, Category), Region, Category;
```

### GROUPING SETS

#### **Custom Aggregation Combinations**
```sql
-- GROUPING SETS for specific combinations
SELECT 
    Region,
    Category,
    Product,
    SUM(Sales) AS TotalSales,
    CASE 
        WHEN GROUPING_ID(Region, Category, Product) = 0 THEN 'Product Detail'
        WHEN GROUPING_ID(Region, Category, Product) = 1 THEN 'Category by Region'
        WHEN GROUPING_ID(Region, Category, Product) = 3 THEN 'Region Total'
        WHEN GROUPING_ID(Region, Category, Product) = 6 THEN 'Product Across Regions'
        WHEN GROUPING_ID(Region, Category, Product) = 7 THEN 'Grand Total'
    END AS AggregationLevel
FROM SalesHierarchy
GROUP BY GROUPING SETS (
    (Region, Category, Product),  -- Detail level
    (Region, Category),           -- Category totals by region
    (Region),                     -- Region totals
    (Product),                    -- Product totals across regions
    ()                            -- Grand total
)
ORDER BY GROUPING_ID(Region, Category, Product), Region, Category, Product;
```

---

## Slide 4: HAVING Clause Mastery
**Filtering Aggregated Data**

### Complex HAVING Conditions

#### **Multi-Condition Filtering**
```sql
-- Complex HAVING clause scenarios
SELECT 
    Department,
    JobTitle,
    COUNT(*) AS EmployeeCount,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinSalary,
    MAX(Salary) AS MaxSalary,
    MAX(Salary) - MIN(Salary) AS SalaryRange,
    STDEV(Salary) AS SalaryStandardDeviation
FROM Employees
WHERE IsActive = 1
GROUP BY Department, JobTitle
HAVING 
    -- Multiple aggregate conditions
    COUNT(*) >= 5                               -- At least 5 employees
    AND AVG(Salary) BETWEEN 50000 AND 150000    -- Average salary in range
    AND MAX(Salary) - MIN(Salary) > 20000       -- Significant salary variation
    AND STDEV(Salary) < 15000                   -- Not too much variation
    -- Percentage-based conditions
    AND MIN(Salary) > 0.7 * AVG(Salary)        -- Min salary at least 70% of average
ORDER BY Department, AverageSalary DESC;
```

#### **Conditional Aggregation in HAVING**
```sql
-- Advanced conditional aggregation
SELECT 
    CustomerID,
    YEAR(OrderDate) AS OrderYear,
    COUNT(*) AS TotalOrders,
    SUM(OrderTotal) AS TotalRevenue,
    -- Conditional counts
    SUM(CASE WHEN OrderTotal > 1000 THEN 1 ELSE 0 END) AS HighValueOrders,
    SUM(CASE WHEN MONTH(OrderDate) BETWEEN 11 AND 12 THEN OrderTotal ELSE 0 END) AS HolidayRevenue,
    -- Percentage calculations
    CAST(SUM(CASE WHEN OrderTotal > 1000 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS HighValueOrderPercent
FROM Orders
WHERE OrderDate >= '2023-01-01'
GROUP BY CustomerID, YEAR(OrderDate)
HAVING 
    COUNT(*) >= 10                              -- At least 10 orders
    AND SUM(OrderTotal) >= 25000                -- At least $25K revenue
    -- At least 30% of orders are high-value
    AND CAST(SUM(CASE WHEN OrderTotal > 1000 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) >= 0.3
    -- Holiday season contributes at least 25% of revenue
    AND SUM(CASE WHEN MONTH(OrderDate) BETWEEN 11 AND 12 THEN OrderTotal ELSE 0 END) >= 0.25 * SUM(OrderTotal)
ORDER BY TotalRevenue DESC;
```

---

## Slide 5: Window Functions and Advanced Analytics
**OVER Clause and Analytical Functions**

### Window Function Categories

#### **Ranking Functions**
```sql
-- Comprehensive ranking function examples
WITH EmployeeRankings AS (
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS EmployeeName,
        Department,
        JobTitle,
        Salary,
        HireDate,
        
        -- Ranking functions
        ROW_NUMBER() OVER (ORDER BY Salary DESC) AS SalaryRowNumber,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryDenseRank,
        NTILE(4) OVER (ORDER BY Salary DESC) AS SalaryQuartile,
        
        -- Department-specific rankings
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank,
        RANK() OVER (PARTITION BY Department ORDER BY HireDate) AS DeptSeniorityRank,
        
        -- Percentage ranking
        PERCENT_RANK() OVER (ORDER BY Salary) AS SalaryPercentRank,
        CUME_DIST() OVER (ORDER BY Salary) AS SalaryCumulativeDistribution,
        
        -- Window frame calculations
        AVG(Salary) OVER (PARTITION BY Department) AS DeptAverageSalary,
        SUM(Salary) OVER (PARTITION BY Department) AS DeptTotalSalary,
        COUNT(*) OVER (PARTITION BY Department) AS DeptEmployeeCount
        
    FROM Employees
    WHERE IsActive = 1
)
SELECT 
    *,
    -- Calculated fields using window functions
    Salary - DeptAverageSalary AS SalaryDifferenceFromDeptAvg,
    CASE 
        WHEN SalaryPercentRank >= 0.9 THEN 'Top 10%'
        WHEN SalaryPercentRank >= 0.75 THEN 'Top 25%'
        WHEN SalaryPercentRank >= 0.5 THEN 'Top 50%'
        ELSE 'Bottom 50%'
    END AS SalaryPercentile
FROM EmployeeRankings
ORDER BY Department, DeptSalaryRank;
```

#### **Analytical Functions**
```sql
-- Advanced analytical window functions
WITH MonthlySales AS (
    SELECT 
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(OrderTotal) AS MonthlySales
    FROM Orders
    WHERE OrderDate >= '2022-01-01'
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
SalesAnalytics AS (
    SELECT 
        SalesYear,
        SalesMonth,
        MonthlySales,
        
        -- Moving averages
        AVG(MonthlySales) OVER (
            ORDER BY SalesYear, SalesMonth 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS ThreeMonthMovingAverage,
        
        AVG(MonthlySales) OVER (
            ORDER BY SalesYear, SalesMonth 
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) AS SixMonthMovingAverage,
        
        -- Running totals
        SUM(MonthlySales) OVER (
            PARTITION BY SalesYear 
            ORDER BY SalesMonth
        ) AS YearToDateSales,
        
        SUM(MonthlySales) OVER (
            ORDER BY SalesYear, SalesMonth
        ) AS CumulativeSales,
        
        -- Lead and lag functions
        LAG(MonthlySales, 1) OVER (ORDER BY SalesYear, SalesMonth) AS PreviousMonthSales,
        LAG(MonthlySales, 12) OVER (ORDER BY SalesYear, SalesMonth) AS SameMonthLastYear,
        LEAD(MonthlySales, 1) OVER (ORDER BY SalesYear, SalesMonth) AS NextMonthSales,
        
        -- First and last values
        FIRST_VALUE(MonthlySales) OVER (
            PARTITION BY SalesYear 
            ORDER BY SalesMonth
        ) AS FirstMonthOfYear,
        
        LAST_VALUE(MonthlySales) OVER (
            PARTITION BY SalesYear 
            ORDER BY SalesMonth 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS LastMonthOfYear
        
    FROM MonthlySales
)
SELECT 
    *,
    -- Growth calculations
    CASE 
        WHEN PreviousMonthSales IS NOT NULL AND PreviousMonthSales > 0
        THEN ((MonthlySales - PreviousMonthSales) / PreviousMonthSales) * 100
        ELSE NULL
    END AS MonthOverMonthGrowthPercent,
    
    CASE 
        WHEN SameMonthLastYear IS NOT NULL AND SameMonthLastYear > 0
        THEN ((MonthlySales - SameMonthLastYear) / SameMonthLastYear) * 100
        ELSE NULL
    END AS YearOverYearGrowthPercent,
    
    -- Variance from moving average
    CASE 
        WHEN ThreeMonthMovingAverage > 0
        THEN ((MonthlySales - ThreeMonthMovingAverage) / ThreeMonthMovingAverage) * 100
        ELSE NULL
    END AS VarianceFromMovingAverage
    
FROM SalesAnalytics
ORDER BY SalesYear, SalesMonth;
```

---

## Slide 6: Performance Optimization for Aggregation Queries
**Efficient Grouping and Index Strategies**

### Index Design for GROUP BY Queries

#### **Covering Indexes for Aggregation**
```sql
-- Optimize common aggregation patterns with proper indexing

-- Query pattern: Sales summary by date and salesperson
SELECT 
    SalesPersonID,
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    COUNT(*) AS TransactionCount,
    SUM(SaleAmount) AS TotalSales,
    AVG(SaleAmount) AS AverageSale
FROM Sales
WHERE SaleDate >= '2023-01-01'
    AND SalesPersonID IN (1, 2, 3, 4, 5)
GROUP BY SalesPersonID, YEAR(SaleDate), MONTH(SaleDate)
ORDER BY SalesPersonID, SaleYear, SaleMonth;

-- Optimal covering index for above query
CREATE NONCLUSTERED INDEX IX_Sales_SalesPersonDate_Covering
ON Sales (SalesPersonID, SaleDate)
INCLUDE (SaleAmount);

-- Alternative index if ORDER BY is different
CREATE NONCLUSTERED INDEX IX_Sales_DateSalesPerson_Covering  
ON Sales (SaleDate, SalesPersonID)
INCLUDE (SaleAmount);
```

#### **Indexed Views for Complex Aggregations**
```sql
-- Create indexed view for frequently used aggregations
CREATE VIEW dbo.vw_MonthlySalesSummary
WITH SCHEMABINDING
AS
SELECT 
    SalesPersonID,
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    COUNT_BIG(*) AS TransactionCount,
    SUM(SaleAmount) AS TotalSales,
    SUM(ISNULL(SaleAmount, 0)) AS TotalSalesWithNulls -- Required for indexed view
FROM dbo.Sales
WHERE SaleDate IS NOT NULL  -- Required for indexed view
GROUP BY SalesPersonID, YEAR(SaleDate), MONTH(SaleDate);

-- Create unique clustered index on the view
CREATE UNIQUE CLUSTERED INDEX IX_vw_MonthlySalesSummary
ON dbo.vw_MonthlySalesSummary (SalesPersonID, SaleYear, SaleMonth);

-- Query automatically uses the indexed view
SELECT 
    SalesPersonID,
    SUM(TotalSales) AS YearlyTotal,
    AVG(TotalSales) AS MonthlyAverage
FROM dbo.vw_MonthlySalesSummary
WHERE SaleYear = 2023
GROUP BY SalesPersonID;
```

### Query Optimization Techniques

#### **Efficient Aggregation Strategies**
```sql
-- Performance comparison: Different aggregation approaches

-- Approach 1: Single pass with CASE expressions (Efficient)
SELECT 
    ProductCategory,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN UnitPrice > 100 THEN 1 ELSE 0 END) AS ExpensiveProducts,
    SUM(CASE WHEN UnitPrice <= 100 THEN 1 ELSE 0 END) AS AffordableProducts,
    AVG(UnitPrice) AS AveragePrice,
    SUM(CASE WHEN UnitPrice > 100 THEN UnitPrice ELSE 0 END) / 
        NULLIF(SUM(CASE WHEN UnitPrice > 100 THEN 1 ELSE 0 END), 0) AS AvgExpensivePrice
FROM Products
GROUP BY ProductCategory;

-- Approach 2: Multiple subqueries (Less efficient)
SELECT 
    p1.ProductCategory,
    p1.TotalProducts,
    p2.ExpensiveProducts,
    p3.AffordableProducts,
    p1.AveragePrice
FROM (
    SELECT ProductCategory, COUNT(*) AS TotalProducts, AVG(UnitPrice) AS AveragePrice
    FROM Products GROUP BY ProductCategory
) p1
JOIN (
    SELECT ProductCategory, COUNT(*) AS ExpensiveProducts
    FROM Products WHERE UnitPrice > 100 GROUP BY ProductCategory
) p2 ON p1.ProductCategory = p2.ProductCategory
JOIN (
    SELECT ProductCategory, COUNT(*) AS AffordableProducts
    FROM Products WHERE UnitPrice <= 100 GROUP BY ProductCategory
) p3 ON p1.ProductCategory = p3.ProductCategory;
```

This comprehensive Module 8 presentation covers all aspects of data aggregation and grouping with detailed explanations, advanced techniques, and performance optimization strategies.