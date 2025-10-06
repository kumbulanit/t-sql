# Module 9: Using Subqueries - Enhanced Theory Presentation

## Slide 1: Module Overview
**Mastering Subqueries: Nested Queries, CTEs, and Advanced Query Patterns**

### Learning Objectives
- **Subquery Mastery**: Complete understanding of scalar, multi-value, and correlated subqueries
- **Common Table Expressions**: Advanced CTE usage for complex query logic and recursion
- **Performance Optimization**: Efficient subquery patterns and when to use alternatives
- **EXISTS vs IN**: Understanding performance implications and logical differences
- **Recursive Queries**: Hierarchical data processing and tree traversal
- **Advanced Patterns**: Window functions, derived tables, and complex analytical queries

### Module Structure
- **Subquery Fundamentals**: Types, execution order, and logical processing
- **Advanced Techniques**: CTEs, recursive queries, and complex nested patterns
- **Performance Engineering**: Optimization strategies and alternative approaches
- **Real-World Applications**: Complex business scenarios and analytical requirements

---

## Slide 2: Subquery Types and Fundamentals
**Understanding Nested Query Architecture**

### Scalar Subqueries

#### **Single Value Return Subqueries**
```sql
-- Scalar subquery examples (return single value)
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    CategoryID,
    
    -- Scalar subquery for single value
    (SELECT CategoryName FROM Categories c WHERE c.CategoryID = p.CategoryID) AS CategoryName,
    
    -- Scalar subquery with aggregate
    (SELECT AVG(BaseSalary) FROM Products p2 WHERE p2.CategoryID = p.CategoryID) AS CategoryAveragePrice,
    
    -- Scalar subquery for calculations
    BaseSalary - (SELECT AVG(BaseSalary) FROM Products) AS PriceDifferenceFromOverallAverage,
    
    -- Conditional scalar subquery
    CASE 
        WHEN BaseSalary > (SELECT AVG(BaseSalary) FROM Products p3 WHERE p3.CategoryID = p.CategoryID)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS PriceCategory
    
FROM Products p
WHERE Discontinued = 0
ORDER BY CategoryID, BaseSalary DESC;
```

#### **Multi-Value Subqueries with IN**
```sql
-- Multi-value subqueries (return multiple values)
SELECT 
    CustomerID,
    CompanyName,
    Country,
    City
FROM Customers
WHERE CustomerID IN (
    -- Subquery returns multiple CustomerIDs
    SELECT DISTINCT CustomerID 
    FROM Orders 
    WHERE OrderDate >= '2023-01-01'
        AND OrderDate < '2024-01-01'
);

-- Complex multi-value subquery with multiple conditions
SELECT 
    ProductID,
    ProductName,
    BaseSalary,
    CategoryID
FROM Products
WHERE CategoryID IN (
    -- Find categories with average price > $50
    SELECT CategoryID
    FROM Products
    GROUP BY CategoryID
    HAVING AVG(BaseSalary) > 50
)
AND ProductID NOT IN (
    -- Exclude products never ordered
    SELECT DISTINCT ProductID
    FROM OrderDetails
    WHERE ProductID IS NOT NULL
);
```

### Correlated Subqueries

#### **Row-by-Row Processing**
```sql
-- Correlated subqueries (reference outer query)
SELECT 
    e1.EmployeeID,
    e1.FirstName + ' ' + e1.LastName AS EmployeeName,
    e1.Department,
    e1.BaseSalary,
    
    -- Correlated subquery for department ranking
    (SELECT COUNT(*)
     FROM Employees e2 
     WHERE e2.DepartmentID = e1.DepartmentID 
         AND e2.BaseSalary >= e1.BaseSalary) AS DepartmentSalaryRank,
    
    -- Correlated subquery for percentage calculation
    CAST(e1.BaseSalary AS DECIMAL(10,2)) / 
    (SELECT AVG(BaseSalary) FROM Employees e3 WHERE e3.DepartmentID = e1.DepartmentID) * 100 AS PercentOfDeptAverage,
    
    -- Correlated EXISTS subquery
    CASE 
        WHEN EXISTS (SELECT 1 FROM Employees e4 
                    WHERE e4.ManagerID = e1.EmployeeID)
        THEN 'Manager'
        ELSE 'Individual Contributor'
    END AS Role
    
FROM Employees e1
WHERE e1.IsActive = 1
ORDER BY e1.Department, e1.BaseSalary DESC;
```

#### **EXISTS vs IN Performance Comparison**
```sql
-- EXISTS approach (often more efficient)
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c
WHERE EXISTS (
    SELECT 1  -- SELECT 1 is efficient, doesn't return actual values
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
        AND o.OrderDate >= '2023-01-01'
        AND o.TotalAmount > 1000
);

-- IN approach (can be less efficient with large datasets)
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    WHERE o.OrderDate >= '2023-01-01'
        AND o.TotalAmount > 1000
);

-- NOT EXISTS (handles NULLs correctly)
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
        AND o.OrderDate >= '2023-01-01'
);

-- NOT IN (problematic with NULLs)
-- This query may not work as expected if Orders.CustomerID contains NULLs
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE c.CustomerID NOT IN (
    SELECT o.CustomerID
    FROM Orders o
    WHERE o.OrderDate >= '2023-01-01'
        AND o.CustomerID IS NOT NULL  -- Must handle NULLs explicitly
);
```

---

## Slide 3: Common Table Expressions (CTEs)
**Powerful Query Structuring and Recursive Processing**

### Basic CTE Usage

#### **Named Result Sets for Complex Queries**
```sql
-- Multiple CTEs for complex business logic
WITH HighValueCustomers AS (
    -- CTE 1: Identify high-value customers
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.Country,
        SUM(o.TotalAmount) AS TotalPurchases,
        COUNT(o.OrderID) AS OrderCount,
        AVG(o.TotalAmount) AS AverageOrderValue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.OrderDate >= '2023-01-01'
    GROUP BY c.CustomerID, c.CompanyName, c.Country
    HAVING SUM(o.TotalAmount) > 10000
),
ProductPerformance AS (
    -- CTE 2: Product performance metrics
    SELECT 
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        COUNT(od.OrderID) AS TimesOrdered,
        SUM(od.Quantity) AS TotalQuantitySold,
        SUM(od.BaseSalary * od.Quantity) AS TotalRevenue
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= '2023-01-01'
    GROUP BY p.ProductID, p.ProductName, p.CategoryID
),
CustomerProductMatrix AS (
    -- CTE 3: Customer-Product purchase matrix
    SELECT 
        hvc.CustomerID,
        hvc.CompanyName,
        pp.ProductID,
        pp.ProductName,
        SUM(od.Quantity) AS QuantityPurchased,
        SUM(od.BaseSalary * od.Quantity) AS ProductRevenue
    FROM HighValueCustomers hvc
    JOIN Orders o ON hvc.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN ProductPerformance pp ON od.ProductID = pp.ProductID
    GROUP BY hvc.CustomerID, hvc.CompanyName, pp.ProductID, pp.ProductName
)
-- Main query using all CTEs
SELECT 
    cpm.CompanyName,
    cpm.ProductName,
    cpm.QuantityPurchased,
    cpm.ProductRevenue,
    -- Calculate percentage of customer's total purchases
    CAST(cpm.ProductRevenue AS DECIMAL(10,2)) / hvc.TotalPurchases * 100 AS PercentOfCustomerSpending,
    -- Rank products by revenue for each customer
    ROW_NUMBER() OVER (PARTITION BY cpm.CustomerID ORDER BY cpm.ProductRevenue DESC) AS CustomerProductRank
FROM CustomerProductMatrix cpm
JOIN HighValueCustomers hvc ON cpm.CustomerID = hvc.CustomerID
WHERE cpm.ProductRevenue > 500  -- Only significant product purchases
ORDER BY cpm.CompanyName, CustomerProductRank;
```

### Recursive CTEs

#### **Hierarchical Data Processing**
```sql
-- Recursive CTE for organizational hierarchy
WITH EmployeeHierarchy AS (
    -- Anchor member: Top-level managers (no manager)
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS EmployeeName,
        JobTitle,
        ManagerID,
        Department,
        BaseSalary,
        0 AS Level,  -- Top level
        CAST(FirstName + ' ' + LastName AS NVARCHAR(MAX)) AS HierarchyPath
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive member: Employees with managers
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName,
        e.JobTitle,
        e.ManagerID,
        e.Department,
        e.BaseSalary,
        eh.Level + 1,
        eh.HierarchyPath + ' > ' + e.FirstName + ' ' + e.LastName
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
    WHERE eh.Level < 10  -- Prevent infinite recursion
)
SELECT 
    Level,
    REPLICATE('  ', Level) + EmployeeName AS IndentedName,  -- Visual hierarchy
    JobTitle,
    Department,
    BaseSalary,
    HierarchyPath,
    -- Calculate span of control
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = eh.EmployeeID) AS DirectReports,
    -- Calculate total subordinates (recursive count)
    (SELECT COUNT(*) FROM EmployeeHierarchy eh2 
     WHERE eh2.HierarchyPath LIKE eh.HierarchyPath + '%' 
         AND eh2.EmployeeID != eh.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy eh
ORDER BY HierarchyPath;
```

#### **Recursive Calculations**
```sql
-- Recursive CTE for running calculations
WITH MonthlySalesRecursive AS (
    -- Base case: First month
    SELECT 
        1 AS MonthNumber,
        'January' AS MonthName,
        15000.00 AS MonthlySales,
        15000.00 AS CumulativeSales,
        0.00 AS GrowthFromPrevious
    
    UNION ALL
    
    -- Recursive case: Subsequent months with growth calculation
    SELECT 
        msr.MonthNumber + 1,
        CASE msr.MonthNumber + 1
            WHEN 2 THEN 'February'
            WHEN 3 THEN 'March'
            WHEN 4 THEN 'April'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'June'
            WHEN 7 THEN 'July'
            WHEN 8 THEN 'August'
            WHEN 9 THEN 'September'
            WHEN 10 THEN 'October'
            WHEN 11 THEN 'November'
            WHEN 12 THEN 'December'
        END,
        -- Simulate varying monthly sales
        msr.MonthlySales * (1 + (RAND() * 0.2 - 0.1)),  -- +/- 10% variation
        msr.CumulativeSales + (msr.MonthlySales * (1 + (RAND() * 0.2 - 0.1))),
        ((msr.MonthlySales * (1 + (RAND() * 0.2 - 0.1))) - msr.MonthlySales) / msr.MonthlySales * 100
    FROM MonthlySalesRecursive msr
    WHERE msr.MonthNumber < 12
)
SELECT 
    MonthNumber,
    MonthName,
    ROUND(MonthlySales, 2) AS MonthlySales,
    ROUND(CumulativeSales, 2) AS CumulativeSales,
    ROUND(GrowthFromPrevious, 2) AS GrowthPercent
FROM MonthlySalesRecursive
ORDER BY MonthNumber;
```

---

## Slide 4: Advanced Subquery Patterns
**Complex Nested Queries and Analytical Patterns**

### Top-N and Ranking Subqueries

#### **Complex Ranking Scenarios**
```sql
-- Top performers in each category using subqueries
SELECT 
    CategoryID,
    ProductID,
    ProductName,
    BaseSalary,
    CategoryRank
FROM (
    SELECT 
        p.CategoryID,
        p.ProductID,
        p.ProductName,
        p.BaseSalary,
        ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.BaseSalary DESC) AS CategoryRank,
        -- Calculate percentile within category
        PERCENT_RANK() OVER (PARTITION BY p.CategoryID ORDER BY p.BaseSalary) AS PricePercentile
    FROM Products p
    WHERE p.Discontinued = 0
) AS RankedProducts
WHERE CategoryRank <= 3  -- Top 3 in each category
   OR PricePercentile >= 0.9  -- Or top 10% by price
ORDER BY CategoryID, CategoryRank;

-- Alternative approach with correlated subquery
SELECT 
    p1.CategoryID,
    p1.ProductID,
    p1.ProductName,
    p1.BaseSalary
FROM Products p1
WHERE p1.BaseSalary >= (
    -- Find the 3rd highest price in the category
    SELECT MIN(p2.BaseSalary)
    FROM (
        SELECT TOP 3 BaseSalary
        FROM Products p3
        WHERE p3.CategoryID = p1.CategoryID
            AND p3.Discontinued = 0
        ORDER BY BaseSalary DESC
    ) p2
)
AND p1.Discontinued = 0
ORDER BY p1.CategoryID, p1.BaseSalary DESC;
```

### Conditional Aggregation with Subqueries

#### **Complex Business Logic**
```sql
-- Advanced conditional aggregation using subqueries
WITH CustomerAnalysis AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.Country,
        
        -- Total orders and revenue
        (SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders,
        (SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalRevenue,
        
        -- Recent activity (last 6 months)
        (SELECT COUNT(*) 
         FROM Orders o 
         WHERE o.CustomerID = c.CustomerID 
             AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())) AS RecentOrders,
        
        (SELECT ISNULL(SUM(TotalAmount), 0) 
         FROM Orders o 
         WHERE o.CustomerID = c.CustomerID 
             AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())) AS RecentRevenue,
        
        -- High-value orders (>$1000)
        (SELECT COUNT(*) 
         FROM Orders o 
         WHERE o.CustomerID = c.CustomerID 
             AND o.TotalAmount > 1000) AS HighValueOrders,
        
        -- Average order value
        (SELECT AVG(TotalAmount) 
         FROM Orders o 
         WHERE o.CustomerID = c.CustomerID) AS AverageOrderValue,
        
        -- Most recent order date
        (SELECT MAX(OrderDate) 
         FROM Orders o 
         WHERE o.CustomerID = c.CustomerID) AS LastOrderDate,
        
        -- Days since last order
        DATEDIFF(DAY, 
            (SELECT MAX(OrderDate) FROM Orders o WHERE o.CustomerID = c.CustomerID), 
            GETDATE()) AS DaysSinceLastOrder
    FROM Customers c
)
SELECT 
    CustomerID,
    CompanyName,
    Country,
    TotalOrders,
    TotalRevenue,
    RecentOrders,
    RecentRevenue,
    HighValueOrders,
    ROUND(AverageOrderValue, 2) AS AverageOrderValue,
    LastOrderDate,
    DaysSinceLastOrder,
    
    -- Customer segmentation based on multiple factors
    CASE 
        WHEN TotalRevenue >= 50000 AND RecentOrders >= 5 THEN 'VIP Active'
        WHEN TotalRevenue >= 50000 AND DaysSinceLastOrder <= 90 THEN 'VIP Recent'
        WHEN TotalRevenue >= 50000 THEN 'VIP Dormant'
        WHEN TotalRevenue >= 10000 AND RecentOrders >= 3 THEN 'Premium Active'
        WHEN TotalRevenue >= 10000 AND DaysSinceLastOrder <= 180 THEN 'Premium Recent'
        WHEN TotalRevenue >= 10000 THEN 'Premium At Risk'
        WHEN RecentOrders >= 2 THEN 'Standard Active'
        WHEN DaysSinceLastOrder <= 365 THEN 'Standard Recent'
        WHEN TotalOrders > 0 THEN 'Inactive'
        ELSE 'Prospect'
    END AS CustomerSegment,
    
    -- Revenue trend (comparing recent vs historical)
    CASE 
        WHEN TotalOrders > 0 AND RecentRevenue > (TotalRevenue - RecentRevenue) / (TotalOrders - RecentOrders) * RecentOrders 
        THEN 'Growing'
        WHEN RecentOrders > 0 
        THEN 'Stable'
        ELSE 'Declining'
    END AS RevenueTrend
    
FROM CustomerAnalysis
WHERE TotalOrders > 0  -- Only customers with at least one order
ORDER BY TotalRevenue DESC;
```

---

## Slide 5: Performance Optimization for Subqueries
**Efficient Query Patterns and Alternative Approaches**

### Subquery vs JOIN Performance

#### **Converting Subqueries to JOINs**
```sql
-- Subquery approach (potentially less efficient)
SELECT 
    p.ProductID,
    p.ProductName,
    p.BaseSalary,
    (SELECT c.CategoryName FROM Categories c WHERE c.CategoryID = p.CategoryID) AS CategoryName,
    (SELECT COUNT(*) FROM OrderDetails od WHERE od.ProductID = p.ProductID) AS TimesOrdered
FROM Products p
WHERE p.ProductID IN (
    SELECT DISTINCT od.ProductID
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= '2023-01-01'
);

-- JOIN approach (typically more efficient)
SELECT DISTINCT
    p.ProductID,
    p.ProductName,
    p.BaseSalary,
    c.CategoryName,
    product_stats.TimesOrdered
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
JOIN (
    -- Pre-aggregate the order counts
    SELECT 
        ProductID,
        COUNT(*) AS TimesOrdered
    FROM OrderDetails
    GROUP BY ProductID
) product_stats ON p.ProductID = product_stats.ProductID
WHERE o.OrderDate >= '2023-01-01';
```

#### **Window Functions vs Correlated Subqueries**
```sql
-- Correlated subquery approach (less efficient)
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Department,
    e.BaseSalary,
    (SELECT COUNT(*) 
     FROM Employees e2 
     WHERE e2.DepartmentID = e.DepartmentID 
         AND e2.BaseSalary > e.BaseSalary) + 1 AS DepartmentRank
FROM Employees e
WHERE e.IsActive = 1
ORDER BY e.Department, DepartmentRank;

-- Window function approach (more efficient)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS EmployeeName,
    Department,
    BaseSalary,
    RANK() OVER (PARTITION BY DepartmentID ORDER BY BaseSalary DESC) AS DepartmentRank
FROM Employees
WHERE IsActive = 1
ORDER BY DepartmentID, DepartmentRank;
```

### CTE vs Subquery vs Temp Table

#### **Performance Comparison Scenarios**
```sql
-- Scenario 1: CTE approach (good for readability, may execute multiple times)
WITH SalesAnalysis AS (
    SELECT 
        YEAR(o.OrderDate) AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        SUM(od.BaseSalary * od.Quantity) AS MonthlySales
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.OrderDate >= '2022-01-01'
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
)
SELECT 
    sa1.SalesYear,
    sa1.SalesMonth,
    sa1.MonthlySales,
    sa2.MonthlySales AS PreviousMonthSales,
    sa1.MonthlySales - sa2.MonthlySales AS MonthOverMonthChange
FROM SalesAnalysis sa1
LEFT JOIN SalesAnalysis sa2 ON sa1.SalesYear = sa2.SalesYear 
                            AND sa1.SalesMonth = sa2.SalesMonth + 1
ORDER BY sa1.SalesYear, sa1.SalesMonth;

-- Scenario 2: Temp table approach (better for reuse, physical storage)
CREATE TABLE #SalesAnalysis (
    SalesYear INT,
    SalesMonth INT,
    MonthlySales DECIMAL(15,2),
    INDEX IX_SalesAnalysis_YearMonth (SalesYear, SalesMonth)
);

INSERT INTO #SalesAnalysis
SELECT 
    YEAR(o.OrderDate),
    MONTH(o.OrderDate),
    SUM(od.BaseSalary * od.Quantity)
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '2022-01-01'
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate);

SELECT 
    sa1.SalesYear,
    sa1.SalesMonth,
    sa1.MonthlySales,
    sa2.MonthlySales AS PreviousMonthSales,
    sa1.MonthlySales - sa2.MonthlySales AS MonthOverMonthChange
FROM #SalesAnalysis sa1
LEFT JOIN #SalesAnalysis sa2 ON sa1.SalesYear = sa2.SalesYear 
                             AND sa1.SalesMonth = sa2.SalesMonth + 1
ORDER BY sa1.SalesYear, sa1.SalesMonth;

DROP TABLE #SalesAnalysis;
```

---

## Slide 6: Advanced Analytical Patterns
**Complex Business Intelligence Queries**

### Multi-Level Analytics

#### **Comprehensive Business Reporting**
```sql
-- Complex analytical query combining multiple subquery patterns
WITH CustomerMetrics AS (
    -- Base customer metrics
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.Country,
        c.Region,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(od.BaseSalary * od.Quantity) AS TotalRevenue,
        AVG(od.BaseSalary * od.Quantity) AS AverageOrderValue,
        MIN(o.OrderDate) AS FirstOrderDate,
        MAX(o.OrderDate) AS LastOrderDate,
        DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifespanDays
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Country, c.Region
),
RegionBenchmarks AS (
    -- Regional benchmarks for comparison
    SELECT 
        Region,
        AVG(TotalRevenue) AS RegionAvgRevenue,
        AVG(TotalOrders) AS RegionAvgOrders,
        AVG(AverageOrderValue) AS RegionAvgOrderValue,
        STDEV(TotalRevenue) AS RegionRevenueStdDev
    FROM CustomerMetrics
    WHERE TotalOrders > 0
    GROUP BY Region
),
CustomerScores AS (
    -- Calculate customer scores and rankings
    SELECT 
        cm.*,
        rb.RegionAvgRevenue,
        rb.RegionAvgOrders,
        rb.RegionAvgOrderValue,
        
        -- Percentile rankings
        PERCENT_RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenuePercentile,
        PERCENT_RANK() OVER (PARTITION BY Region ORDER BY TotalRevenue DESC) AS RegionRevenuePercentile,
        PERCENT_RANK() OVER (ORDER BY TotalOrders DESC) AS OrderCountPercentile,
        
        -- Z-scores (standard deviations from mean)
        CASE 
            WHEN rb.RegionRevenueStdDev > 0
            THEN (cm.TotalRevenue - rb.RegionAvgRevenue) / rb.RegionRevenueStdDev
            ELSE 0
        END AS RevenueZScore,
        
        -- Customer lifetime value estimation
        CASE 
            WHEN cm.CustomerLifespanDays > 0
            THEN cm.TotalRevenue / (cm.CustomerLifespanDays / 365.0) * 
                 (CASE WHEN DATEDIFF(DAY, cm.LastOrderDate, GETDATE()) < 180 THEN 2.0 ELSE 1.0 END)
            ELSE cm.TotalRevenue
        END AS EstimatedAnnualValue,
        
        -- Recency, Frequency, Monetary (RFM) scoring
        NTILE(5) OVER (ORDER BY DATEDIFF(DAY, LastOrderDate, GETDATE())) AS RecencyScore,
        NTILE(5) OVER (ORDER BY TotalOrders DESC) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY TotalRevenue DESC) AS MonetaryScore
        
    FROM CustomerMetrics cm
    LEFT JOIN RegionBenchmarks rb ON cm.Region = rb.Region
    WHERE cm.TotalOrders > 0
)
SELECT 
    CustomerID,
    CompanyName,
    Country,
    Region,
    TotalOrders,
    ROUND(TotalRevenue, 2) AS TotalRevenue,
    ROUND(AverageOrderValue, 2) AS AverageOrderValue,
    FirstOrderDate,
    LastOrderDate,
    CustomerLifespanDays,
    ROUND(EstimatedAnnualValue, 2) AS EstimatedAnnualValue,
    
    -- Performance vs region
    ROUND((TotalRevenue - RegionAvgRevenue) / RegionAvgRevenue * 100, 1) AS RevenueVsRegionAvgPercent,
    ROUND(RevenueZScore, 2) AS RevenueZScore,
    
    -- Percentile rankings
    ROUND(RevenuePercentile * 100, 1) AS RevenuePercentile,
    ROUND(RegionRevenuePercentile * 100, 1) AS RegionRevenuePercentile,
    
    -- RFM composite score
    RecencyScore + FrequencyScore + MonetaryScore AS RFMScore,
    CONCAT(RecencyScore, FrequencyScore, MonetaryScore) AS RFMSegment,
    
    -- Customer classification
    CASE 
        WHEN RecencyScore >= 4 AND FrequencyScore >= 4 AND MonetaryScore >= 4 THEN 'Champions'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 3 AND MonetaryScore >= 4 THEN 'Loyal Customers'
        WHEN RecencyScore >= 4 AND FrequencyScore <= 2 AND MonetaryScore >= 3 THEN 'Potential Loyalists'
        WHEN RecencyScore >= 4 AND FrequencyScore <= 2 AND MonetaryScore <= 2 THEN 'New Customers'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 3 AND MonetaryScore <= 3 THEN 'Promising'
        WHEN RecencyScore <= 2 AND FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'Need Attention'
        WHEN RecencyScore <= 2 AND FrequencyScore <= 2 AND MonetaryScore >= 4 THEN 'About to Sleep'
        WHEN RecencyScore <= 2 AND FrequencyScore >= 3 AND MonetaryScore <= 2 THEN 'At Risk'
        WHEN RecencyScore <= 1 AND FrequencyScore >= 4 AND MonetaryScore <= 2 THEN 'Cannot Lose Them'
        ELSE 'Hibernating'
    END AS CustomerSegment
    
FROM CustomerScores
ORDER BY TotalRevenue DESC;
```

This comprehensive Module 9 presentation covers all aspects of subqueries with detailed explanations, advanced techniques, performance optimization, and complex analytical patterns that will give students expert-level understanding of nested query processing.