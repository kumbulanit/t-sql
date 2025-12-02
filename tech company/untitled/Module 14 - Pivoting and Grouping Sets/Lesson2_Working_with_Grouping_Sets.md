# Lesson 2: Working with Grouping Sets

## Overview

Grouping Sets is a powerful T-SQL feature that extends the capabilities of GROUP BY clauses, enabling multiple levels of aggregation in a single query. This advanced functionality includes ROLLUP, CUBE, and GROUPING SETS operations that provide comprehensive subtotals, cross-tabulations, and hierarchical summaries. For TechCorp's business intelligence and reporting needs, Grouping Sets delivers sophisticated analytical capabilities essential for executive dashboards, financial reporting, and multi-dimensional business analysis.

## 🏢 TechCorp Business Context

**Grouping Sets in Enterprise Analytics:**
- **Financial Reporting**: Multi-level budget analysis with subtotals and grand totals
- **Executive Dashboards**: Hierarchical performance metrics across organizational dimensions
- **Sales Analytics**: Revenue analysis by region, product, time period with all combinations
- **HR Analytics**: Employee cost analysis by d.DepartmentName, level, location with summaries
- **Operational Intelligence**: Resource utilization with multiple aggregation perspectives

### 📋 TechCorp Database Schema Reference

**Core Tables for Grouping Sets Operations:**
```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Understanding Grouping Sets Concepts

### Grouping Sets vs Traditional GROUP BY

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     Grouping Sets Comparison                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Traditional GROUP BY (Single Level):                                      │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT d.DepartmentName, SUM(e.BaseSalary)      │  →  d.DepartmentName │ Total e.BaseSalary    │ │
│  │ FROM Employees e                      │     ─────────────────────────────  │ │
│  │ GROUP BY d.DepartmentName                 │     IT         │ $450,000       │ │
│  └─────────────────────────────────────┘     HR         │ $280,000       │ │
│                                               Sales      │ $520,000       │ │
│                                                                             │
│  GROUPING SETS (Multiple Levels):                                          │
│  ┌─────────────────────────────────────┐                                   │
│  │ SELECT d.DepartmentName, e.JobTitle,        │  →  d.DepartmentName │ e.JobTitle │ Total │ │
│  │        SUM(e.BaseSalary)                  │     ─────────────────────────────  │ │
│  │ FROM Employees e                      │     IT         │ Developer│$200K  │ │
│  │ GROUP BY GROUPING SETS (            │     IT         │ Manager  │$250K  │ │
│  │   (Department, e.JobTitle),           │     IT         │ NULL     │$450K  │ │
│  │   (Department),                     │     HR         │ Manager  │$180K  │ │
│  │   ()                                │     HR         │ NULL     │$280K  │ │
│  │ )                                   │     NULL       │ NULL     │$1.25M │ │
│  └─────────────────────────────────────┘                                   │
│                                                                             │
│  Key Advantages:                                                           │
│  • Multiple aggregation levels in single query                            │
│  • Subtotals and grand totals automatically calculated                    │
│  • ROLLUP for hierarchical summaries                                      │
│  • CUBE for all possible combinations                                     │
│  • Custom grouping combinations with GROUPING SETS                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### ROLLUP, CUBE, and GROUPING SETS Syntax

```sql
-- ROLLUP: Hierarchical subtotals (right-to-left hierarchy)
SELECT columns, AGG_FUNCTION(value)
FROM table
GROUP BY ROLLUP(column1, column2, column3);

-- CUBE: All possible combinations of groupings
SELECT columns, AGG_FUNCTION(value)
FROM table
GROUP BY CUBE(column1, column2, column3);

-- GROUPING SETS: Custom grouping combinations
SELECT columns, AGG_FUNCTION(value)
FROM table
GROUP BY GROUPING SETS (
    (column1, column2),
    (column1),
    (column2),
    ()  -- Grand total
);
```

## Basic ROLLUP Operations

### 1. Hierarchical Financial Reporting

#### TechCorp Example: d.DepartmentName d.Budget Analysis with Subtotals
```sql
-- Create comprehensive budget analysis with hierarchical subtotals
SELECT 
    CASE 
        WHEN GROUPING(d.Location) = 1 AND GROUPING(d.DepartmentName) = 1 
        THEN 'COMPANY TOTAL'
        WHEN GROUPING(d.DepartmentName) = 1 
        THEN d.Location + ' LOCATION TOTAL'
        ELSE d.DepartmentName
    END AS Department_Level,
    CASE 
        WHEN GROUPING(d.Location) = 1 THEN 'ALL LOCATIONS'
        ELSE d.Location
    END AS Location,
    COUNT(e.EmployeeID) AS Employee_Count,
    FORMAT(SUM(e.BaseSalary), 'C') AS Total_Salaries,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary,
    FORMAT(SUM(d.Budget), 'C') AS Department_Budget,
    -- Calculate budget utilization
    CASE 
        WHEN SUM(d.Budget) > 0 
        THEN CAST((SUM(e.BaseSalary) * 100.0 / SUM(d.Budget)) AS DECIMAL(5,2))
        ELSE 0
    END AS Budget_Utilization_Percent,
    -- Add grouping level indicators
    CASE 
        WHEN GROUPING(d.Location) = 1 AND GROUPING(d.DepartmentName) = 1 
        THEN 'Level 0: Company Summary'
        WHEN GROUPING(d.DepartmentName) = 1 
        THEN 'Level 1: Location Summary'
        ELSE 'Level 2: d.DepartmentName Detail'
    END AS Aggregation_Level,
    -- Performance indicators
    CASE 
        WHEN GROUPING(d.DepartmentName) = 0 THEN  -- d.DepartmentName level only
            CASE 
                WHEN SUM(e.BaseSalary) * 100.0 / NULLIF(SUM(d.Budget), 0) > 90 
                THEN '⚠️ Over d.Budget Risk'
                WHEN SUM(e.BaseSalary) * 100.0 / NULLIF(SUM(d.Budget), 0) > 75 
                THEN '✅ Well Utilized'
                WHEN SUM(e.BaseSalary) * 100.0 / NULLIF(SUM(d.Budget), 0) > 50 
                THEN '📊 Moderate Usage'
                ELSE '💡 Under Utilized'
            END
        ELSE ''
    END AS Budget_Status
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
  AND d.IsActive = 1
GROUP BY ROLLUP(d.Location, d.DepartmentName)
ORDER BY 
    GROUPING(d.Location),
    GROUPING(d.DepartmentName),
    d.Location,
    d.DepartmentName;
```

### 2. Time-Based Revenue Analysis

#### TechCorp Example: Quarterly Sales Performance with ROLLUP
```sql
-- Comprehensive quarterly sales analysis with time-based hierarchy
SELECT 
    CASE 
        WHEN GROUPING(SalesYear) = 1 AND GROUPING(SalesQuarter) = 1 
        THEN 'GRAND TOTAL (ALL PERIODS)'
        WHEN GROUPING(SalesQuarter) = 1 
        THEN CAST(SalesYear AS VARCHAR) + ' ANNUAL TOTAL'
        ELSE CAST(SalesYear AS VARCHAR) + ' Q' + CAST(SalesQuarter AS VARCHAR)
    END AS Time_Period,
    CASE 
        WHEN GROUPING(SalesYear) = 1 THEN 'All Years'
        ELSE CAST(SalesYear AS VARCHAR)
    END AS Year_Display,
    CASE 
        WHEN GROUPING(SalesQuarter) = 1 THEN 'All Quarters'
        ELSE 'Q' + CAST(SalesQuarter AS VARCHAR)
    END AS Quarter_Display,
    COUNT(DISTINCT o.CustomerID) AS Unique_Customers,
    COUNT(o.OrderID) AS Total_Orders,
    FORMAT(SUM(o.TotalAmount), 'C') AS Total_Revenue,
    FORMAT(AVG(o.TotalAmount), 'C') AS Average_Order_Value,
    FORMAT(SUM(o.TotalAmount) / NULLIF(COUNT(DISTINCT o.CustomerID), 0), 'C') AS Revenue_Per_Customer,
    -- Growth calculations (where applicable)
    CASE 
        WHEN GROUPING(SalesQuarter) = 0 THEN  -- Quarter level only
            FORMAT(
                SUM(o.TotalAmount) - LAG(SUM(o.TotalAmount)) OVER (
                    ORDER BY SalesYear, SalesQuarter
                ), 'C'
            )
        ELSE NULL
    END AS QoQ_Growth_Amount,
    CASE 
        WHEN GROUPING(SalesQuarter) = 0 THEN  -- Quarter level only
            CAST(
                (SUM(o.TotalAmount) - LAG(SUM(o.TotalAmount)) OVER (
                    ORDER BY SalesYear, SalesQuarter
                )) * 100.0 / NULLIF(LAG(SUM(o.TotalAmount)) OVER (
                    ORDER BY SalesYear, SalesQuarter
                ), 0) AS DECIMAL(5,2)
            )
        ELSE NULL
    END AS QoQ_Growth_Percent,
    -- Performance classification
    CASE 
        WHEN GROUPING(SalesYear) = 1 AND GROUPING(SalesQuarter) = 1 
        THEN '🏆 Company Performance'
        WHEN GROUPING(SalesQuarter) = 1 
        THEN '📅 Annual Performance'
        ELSE '📊 Quarterly Performance'
    END AS Performance_Category
FROM (
    SELECT 
        o.OrderID,
        o.CustomerID,
        o.TotalAmount,
        YEAR(o.OrderDate) AS SalesYear,
        DATEPART(QUARTER, o.OrderDate) AS SalesQuarter
    FROM Orders o
    WHERE o.IsActive = 1
      AND o.OrderDate >= '2024-01-01'  -- Focus on recent performance
      AND o.OrderDate < '2026-01-01'
) o
GROUP BY ROLLUP(SalesYear, SalesQuarter)
HAVING SUM(o.TotalAmount) > 0  -- Exclude periods with no sales
ORDER BY 
    GROUPING(SalesYear),
    GROUPING(SalesQuarter),
    SalesYear,
    SalesQuarter;
```

## Advanced CUBE Operations

### 1. Multi-Dimensional Customer Analysis

#### TechCorp Example: Customer Revenue Analysis by Country and Order Size
```sql
-- Comprehensive customer analysis using CUBE for all dimension combinations
WITH CustomerOrderData AS (
    SELECT 
        c.CountryID,
        CASE 
            WHEN o.TotalAmount >= 10000 THEN 'Large'
            WHEN o.TotalAmount >= 5000 THEN 'Medium'
            WHEN o.TotalAmount >= 1000 THEN 'Small'
            ELSE 'Micro'
        END AS OrderSizeCategory,
        o.TotalAmount,
        o.OrderID,
        c.CustomerID
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(YEAR, -2, GETDATE())
)
SELECT 
    CASE 
        WHEN GROUPING(Country) = 1 AND GROUPING(OrderSizeCategory) = 1 
        THEN '🌍 GLOBAL SUMMARY'
        WHEN GROUPING(OrderSizeCategory) = 1 
        THEN '🏴 ' + Country + ' COUNTRY TOTAL'
        WHEN GROUPING(Country) = 1 
        THEN '📦 ALL COUNTRIES - ' + OrderSizeCategory + ' ORDERS'
        ELSE '📍 ' + Country + ' - ' + OrderSizeCategory + ' Orders'
    END AS Analysis_Dimension,
    CASE 
        WHEN GROUPING(Country) = 1 THEN 'All Countries'
        ELSE Country
    END AS Country_Display,
    CASE 
        WHEN GROUPING(OrderSizeCategory) = 1 THEN 'All Sizes'
        ELSE OrderSizeCategory
    END AS Order_Size_Display,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    COUNT(OrderID) AS Total_Orders,
    FORMAT(SUM(TotalAmount), 'C') AS Total_Revenue,
    FORMAT(AVG(TotalAmount), 'C') AS Average_Order_Value,
    FORMAT(SUM(TotalAmount) / NULLIF(COUNT(DISTINCT CustomerID), 0), 'C') AS Revenue_Per_Customer,
    CAST(COUNT(OrderID) * 1.0 / NULLIF(COUNT(DISTINCT CustomerID), 0) AS DECIMAL(5,2)) AS Orders_Per_Customer,
    -- Market penetration analysis
    CASE 
        WHEN GROUPING(Country) = 0 AND GROUPING(OrderSizeCategory) = 0 THEN
            CAST(
                SUM(TotalAmount) * 100.0 / 
                SUM(SUM(TotalAmount)) OVER (PARTITION BY Country) 
                AS DECIMAL(5,2)
            )
        ELSE NULL
    END AS Country_Size_Mix_Percent,
    -- Performance indicators
    CASE 
        WHEN GROUPING(Country) = 1 AND GROUPING(OrderSizeCategory) = 1 
        THEN '🎯 Overall Business Performance'
        WHEN GROUPING(OrderSizeCategory) = 1 
        THEN '🌐 Geographic Market Analysis'
        WHEN GROUPING(Country) = 1 
        THEN '📊 Order Size Segment Analysis'
        ELSE '🔍 Detailed Market Segment'
    END AS Analysis_Type,
    -- Strategic recommendations
    CASE 
        WHEN GROUPING(Country) = 0 AND GROUPING(OrderSizeCategory) = 0 THEN
            CASE 
                WHEN COUNT(DISTINCT CustomerID) < 5 AND SUM(TotalAmount) > 50000
                THEN 'High-value niche market - expand customer base'
                WHEN COUNT(OrderID) * 1.0 / COUNT(DISTINCT CustomerID) > 5
                THEN 'Strong repeat business - leverage for growth'
                WHEN AVG(TotalAmount) < 2000
                THEN 'Focus on order value enhancement'
                ELSE 'Stable market segment'
            END
        ELSE NULL
    END AS Strategic_Recommendation
FROM CustomerOrderData
GROUP BY CUBE(Country, OrderSizeCategory)
HAVING SUM(TotalAmount) > 0
ORDER BY 
    GROUPING(Country),
    GROUPING(OrderSizeCategory),
    SUM(TotalAmount) DESC;
```

### 2. Employee Performance Matrix

#### TechCorp Example: Multi-Dimensional Employee Analysis
```sql
-- Comprehensive employee performance analysis using CUBE
WITH EmployeePerformanceData AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        d.Location,
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 2 THEN 'Junior'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 5 THEN 'Mid-Level'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 10 THEN 'Senior'
            ELSE 'Executive'
        END AS ExperienceLevel,
        e.BaseSalary,
        ISNULL(project_metrics.ProjectCount, 0) AS ProjectCount,
        ISNULL(project_metrics.TotalHours, 0) AS TotalProjectHours,
        ISNULL(order_metrics.OrderCount, 0) AS CustomerOrderCount,
        ISNULL(order_metrics.TotalRevenue, 0) AS CustomerRevenue
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    LEFT JOIN (
        -- Project involvement metrics
        SELECT 
            ep.e.EmployeeID,
            COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
            SUM(ep.HoursWorked) AS TotalHours
        FROM EmployeeProjects ep
        WHERE ep.IsActive = 1
          AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY ep.e.EmployeeID
    ) project_metrics ON e.EmployeeID = project_metrics.e.EmployeeID
    LEFT JOIN (
        -- Customer interaction metrics
        SELECT 
            o.e.EmployeeID,
            COUNT(o.OrderID) AS OrderCount,
            SUM(o.TotalAmount) AS TotalRevenue
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY o.e.EmployeeID
    ) order_metrics ON e.EmployeeID = order_metrics.e.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
)
SELECT 
    CASE 
        WHEN GROUPING(Location) = 1 AND GROUPING(d.DepartmentName) = 1 AND GROUPING(ExperienceLevel) = 1
        THEN '🏢 COMPANY-WIDE SUMMARY'
        WHEN GROUPING(d.DepartmentName) = 1 AND GROUPING(ExperienceLevel) = 1
        THEN '🏢 ' + Location + ' LOCATION TOTAL'
        WHEN GROUPING(ExperienceLevel) = 1
        THEN '🏢 ' + Location + ' - ' + d.DepartmentName + ' DEPT TOTAL'
        WHEN GROUPING(d.DepartmentName) = 1
        THEN '👥 ' + Location + ' - ALL DEPTS - ' + ExperienceLevel + ' LEVEL'
        WHEN GROUPING(Location) = 1
        THEN '🎯 ALL LOCATIONS - ' + d.DepartmentName + ' - ' + ExperienceLevel
        ELSE '👤 ' + Location + ' - ' + d.DepartmentName + ' - ' + ExperienceLevel
    END AS Analysis_Dimension,
    CASE WHEN GROUPING(Location) = 1 THEN 'All Locations' ELSE Location END AS Location_Display,
    CASE WHEN GROUPING(d.DepartmentName) = 1 THEN 'All Departments' ELSE d.DepartmentName END AS Department_Display,
    CASE WHEN GROUPING(ExperienceLevel) = 1 THEN 'All Levels' ELSE ExperienceLevel END AS Experience_Display,
    COUNT(e.EmployeeID) AS Employee_Count,
    FORMAT(SUM(e.BaseSalary), 'C') AS Total_Compensation,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary,
    SUM(ProjectCount) AS Total_Project_Involvement,
    SUM(TotalProjectHours) AS Total_Project_Hours,
    SUM(CustomerOrderCount) AS Total_Customer_Orders,
    FORMAT(SUM(CustomerRevenue), 'C') AS Total_Customer_Revenue,
    -- Productivity metrics
    CASE 
        WHEN COUNT(e.EmployeeID) > 0 
        THEN CAST(SUM(TotalProjectHours) * 1.0 / COUNT(e.EmployeeID) AS DECIMAL(8,2))
        ELSE 0
    END AS Avg_Hours_Per_Employee,
    CASE 
        WHEN COUNT(e.EmployeeID) > 0 
        THEN FORMAT(SUM(CustomerRevenue) / COUNT(e.EmployeeID), 'C')
        ELSE '$0'
    END AS Avg_Revenue_Per_Employee,
    -- Efficiency ratios
    CASE 
        WHEN SUM(e.BaseSalary) > 0 
        THEN CAST(SUM(CustomerRevenue) * 1.0 / SUM(e.BaseSalary) AS DECIMAL(5,2))
        ELSE 0
    END AS Revenue_To_Salary_Ratio,
    -- Performance classification
    CASE 
        WHEN GROUPING(Location) = 1 AND GROUPING(d.DepartmentName) = 1 AND GROUPING(ExperienceLevel) = 1
        THEN '🎯 Executive Summary'
        WHEN GROUPING(d.DepartmentName) = 1 AND GROUPING(ExperienceLevel) = 1
        THEN '🌍 Location Analysis'
        WHEN GROUPING(ExperienceLevel) = 1
        THEN '🏬 d.DepartmentName Analysis'
        ELSE '👥 Detailed Segment Analysis'
    END AS Analysis_Category,
    -- Strategic insights
    CASE 
        WHEN COUNT(e.EmployeeID) > 0 AND GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 0 AND GROUPING(ExperienceLevel) = 0
        THEN
            CASE 
                WHEN SUM(CustomerRevenue) / NULLIF(SUM(e.BaseSalary), 0) > 3 
                THEN '🌟 High ROI Segment - Scale Up'
                WHEN SUM(TotalProjectHours) / COUNT(e.EmployeeID) > 150 
                THEN '⚡ High Utilization - Monitor Burnout'
                WHEN AVG(e.BaseSalary) > 80000 AND SUM(CustomerRevenue) / COUNT(e.EmployeeID) < 50000
                THEN '💡 High Cost, Low Revenue - Optimize'
                ELSE '📊 Standard Performance Segment'
            END
        ELSE NULL
    END AS Strategic_Insight
FROM EmployeePerformanceData
GROUP BY CUBE(Location, d.DepartmentName, ExperienceLevel)
HAVING COUNT(e.EmployeeID) > 0
ORDER BY 
    GROUPING(Location),
    GROUPING(d.DepartmentName),
    GROUPING(ExperienceLevel),
    SUM(CustomerRevenue) DESC;
```

## Custom GROUPING SETS Operations

### 1. Flexible Business Intelligence Reporting

#### TechCorp Example: Custom Executive Dashboard Groupings
```sql
-- Create custom grouping combinations for executive dashboard
WITH ExecutiveMetrics AS (
    SELECT 
        d.Location,
        d.DepartmentName,
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 'Executive'
            WHEN e.BaseSalary >= 70000 THEN 'Senior'
            WHEN e.BaseSalary >= 50000 THEN 'Mid-Level'
            ELSE 'Entry Level'
        END AS SalaryTier,
        DATEPART(QUARTER, GETDATE()) AS CurrentQuarter,
        e.BaseSalary,
        ISNULL(project_data.ProjectBudget, 0) AS ProjectBudget,
        ISNULL(order_data.OrderRevenue, 0) AS OrderRevenue
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    LEFT JOIN (
        -- Project budget by employee
        SELECT 
            p.ProjectManagerID AS e.EmployeeID,
            SUM(p.d.Budget) AS ProjectBudget
        FROM Projects p
        WHERE p.IsActive = 1
          AND p.StartDate >= DATEADD(QUARTER, -1, GETDATE())
        GROUP BY p.ProjectManagerID
    ) project_data ON e.EmployeeID = project_data.e.EmployeeID
    LEFT JOIN (
        -- Order revenue by employee
        SELECT 
            o.e.EmployeeID,
            SUM(o.TotalAmount) AS OrderRevenue
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(QUARTER, -1, GETDATE())
        GROUP BY o.e.EmployeeID
    ) order_data ON e.EmployeeID = order_data.e.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
)
SELECT 
    -- Custom dimension labels based on grouping combination
    CASE 
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 0 AND GROUPING(SalaryTier) = 0
        THEN '🎯 Detailed: ' + Location + ' - ' + d.DepartmentName + ' - ' + SalaryTier
        WHEN GROUPING(Location) = 0 AND GROUPING(SalaryTier) = 0 AND GROUPING(d.DepartmentName) = 1
        THEN '🌍 Location + Tier: ' + Location + ' - ' + SalaryTier + ' Employees'
        WHEN GROUPING(d.DepartmentName) = 0 AND GROUPING(SalaryTier) = 0 AND GROUPING(Location) = 1
        THEN '🏬 d.DepartmentName + Tier: ' + d.DepartmentName + ' - ' + SalaryTier + ' Level'
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 1 AND GROUPING(SalaryTier) = 1
        THEN '📍 Location Summary: ' + Location
        WHEN GROUPING(d.DepartmentName) = 0 AND GROUPING(Location) = 1 AND GROUPING(SalaryTier) = 1
        THEN '🏢 d.DepartmentName Summary: ' + d.DepartmentName
        WHEN GROUPING(SalaryTier) = 0 AND GROUPING(Location) = 1 AND GROUPING(d.DepartmentName) = 1
        THEN '💰 e.BaseSalary Tier Summary: ' + SalaryTier + ' Level'
        ELSE '🏆 COMPANY TOTAL'
    END AS Executive_Summary_Level,
    -- Display columns
    CASE WHEN GROUPING(Location) = 1 THEN 'All Locations' ELSE Location END AS Location,
    CASE WHEN GROUPING(d.DepartmentName) = 1 THEN 'All Departments' ELSE d.DepartmentName END AS d.DepartmentName,
    CASE WHEN GROUPING(SalaryTier) = 1 THEN 'All Tiers' ELSE SalaryTier END AS Salary_Tier,
    -- Core metrics
    COUNT(*) AS Employee_Count,
    FORMAT(SUM(e.BaseSalary), 'C') AS Total_Compensation,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary,
    FORMAT(SUM(ProjectBudget), 'C') AS Total_Project_Budget,
    FORMAT(SUM(OrderRevenue), 'C') AS Total_Order_Revenue,
    -- Calculated KPIs
    FORMAT(
        (SUM(ProjectBudget) + SUM(OrderRevenue)) / NULLIF(COUNT(*), 0), 'C'
    ) AS Revenue_Per_Employee,
    CAST(
        (SUM(ProjectBudget) + SUM(OrderRevenue)) * 100.0 / NULLIF(SUM(e.BaseSalary), 0) 
        AS DECIMAL(5,2)
    ) AS ROI_Percentage,
    -- Performance indicators
    CASE 
        WHEN (SUM(ProjectBudget) + SUM(OrderRevenue)) / NULLIF(SUM(e.BaseSalary), 0) > 2.5 
        THEN '🌟 Exceptional Performance'
        WHEN (SUM(ProjectBudget) + SUM(OrderRevenue)) / NULLIF(SUM(e.BaseSalary), 0) > 1.5 
        THEN '✅ Strong Performance'
        WHEN (SUM(ProjectBudget) + SUM(OrderRevenue)) / NULLIF(SUM(e.BaseSalary), 0) > 0.8 
        THEN '📊 Adequate Performance'
        ELSE '⚠️ Below Expectations'
    END AS Performance_Rating,
    -- Business insights
    CASE 
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 0 AND GROUPING(SalaryTier) = 0
        THEN 
            CASE 
                WHEN COUNT(*) = 1 AND (SUM(ProjectBudget) + SUM(OrderRevenue)) > SUM(e.BaseSalary) * 3
                THEN 'Star Performer - Consider for Leadership'
                WHEN COUNT(*) > 10 AND AVG(e.BaseSalary) < 60000
                THEN 'Large Team, Lower Cost - Growth Opportunity'
                WHEN SUM(ProjectBudget) = 0 AND SUM(OrderRevenue) = 0
                THEN 'No Revenue Generation - Reassess Role'
                ELSE 'Standard Business Unit'
            END
        ELSE NULL
    END AS Business_Insight
FROM ExecutiveMetrics
GROUP BY GROUPING SETS (
    -- Executive-focused grouping combinations
    (Location, d.DepartmentName, SalaryTier),  -- Detailed analysis
    (Location, SalaryTier),                  -- Location + tier focus
    (d.DepartmentName, SalaryTier),           -- d.DepartmentName + tier focus
    (Location),                              -- Location summary
    (d.DepartmentName),                        -- d.DepartmentName summary
    (SalaryTier),                           -- e.BaseSalary tier summary
    ()                                       -- Grand total
)
ORDER BY 
    GROUPING(Location),
    GROUPING(d.DepartmentName),
    GROUPING(SalaryTier),
    SUM(ProjectBudget + OrderRevenue) DESC;
```

### 2. Financial Analysis with Custom Groupings

#### TechCorp Example: d.Budget vs Actual Analysis
```sql
-- Comprehensive budget vs actual analysis with custom groupings
WITH BudgetActualData AS (
    SELECT 
        d.Location,
        d.DepartmentName,
        YEAR(GETDATE()) AS FiscalYear,
        DATEPART(QUARTER, GETDATE()) AS FiscalQuarter,
        -- d.Budget data
        d.Budget AS DepartmentBudget,
        -- Actual e.BaseSalary costs
        SUM(e.BaseSalary) AS ActualSalaryCost,
        -- Actual project spending
        ISNULL(project_spending.ProjectSpending, 0) AS ActualProjectSpending,
        -- Revenue generation
        ISNULL(revenue_data.GeneratedRevenue, 0) AS GeneratedRevenue
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.d.DepartmentID
    LEFT JOIN (
        -- Project spending by d.DepartmentName
        SELECT 
            e.d.DepartmentID,
            SUM(p.d.Budget) AS ProjectSpending
        FROM Projects p
        INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
        WHERE p.IsActive = 1
          AND p.StartDate >= DATEADD(YEAR, 0, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0))
        GROUP BY e.d.DepartmentID
    ) project_spending ON d.DepartmentID = project_spending.d.DepartmentID
    LEFT JOIN (
        -- Revenue by d.DepartmentName
        SELECT 
            e.d.DepartmentID,
            SUM(o.TotalAmount) AS GeneratedRevenue
        FROM Orders o
        INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(YEAR, 0, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0))
        GROUP BY e.d.DepartmentID
    ) revenue_data ON d.DepartmentID = revenue_data.d.DepartmentID
    WHERE d.IsActive = 1
      AND e.IsActive = 1
    GROUP BY 
        d.DepartmentID, d.Location, d.DepartmentName, d.Budget,
        project_spending.ProjectSpending, revenue_data.GeneratedRevenue
)
SELECT 
    -- Dynamic summary labels
    CASE 
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 0
        THEN '📊 ' + Location + ' - ' + d.DepartmentName
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 1
        THEN '🌍 ' + Location + ' Location Total'
        WHEN GROUPING(Location) = 1 AND GROUPING(d.DepartmentName) = 0
        THEN '🏢 All Locations - ' + d.DepartmentName
        ELSE '🏆 Company-Wide Financial Summary'
    END AS Financial_Analysis_Level,
    CASE WHEN GROUPING(Location) = 1 THEN 'All Locations' ELSE Location END AS Location,
    CASE WHEN GROUPING(d.DepartmentName) = 1 THEN 'All Departments' ELSE d.DepartmentName END AS d.DepartmentName,
    -- d.Budget metrics
    FORMAT(SUM(DepartmentBudget), 'C') AS Allocated_Budget,
    FORMAT(SUM(ActualSalaryCost), 'C') AS Actual_Salary_Cost,
    FORMAT(SUM(ActualProjectSpending), 'C') AS Actual_Project_Spending,
    FORMAT(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 'C') AS Total_Actual_Spending,
    -- Variance analysis
    FORMAT(
        SUM(DepartmentBudget) - (SUM(ActualSalaryCost) + SUM(ActualProjectSpending)), 'C'
    ) AS Budget_Variance,
    CAST(
        ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0))
        AS DECIMAL(5,2)
    ) AS Budget_Utilization_Percent,
    -- Revenue metrics
    FORMAT(SUM(GeneratedRevenue), 'C') AS Generated_Revenue,
    CAST(
        SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0)
        AS DECIMAL(5,2)
    ) AS ROI_Percent,
    -- Performance indicators
    CASE 
        WHEN ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0)) > 95
        THEN '🔴 Over d.Budget Risk'
        WHEN ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0)) > 85
        THEN '🟡 High Utilization'
        WHEN ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0)) > 70
        THEN '🟢 Good Utilization'
        ELSE '🔵 Under Utilized'
    END AS Budget_Status,
    -- ROI classification
    CASE 
        WHEN SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0) > 300
        THEN '🌟 Exceptional ROI'
        WHEN SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0) > 200
        THEN '✅ Strong ROI'
        WHEN SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0) > 100
        THEN '📊 Positive ROI'
        ELSE '⚠️ Below Breakeven'
    END AS ROI_Classification,
    -- Strategic recommendations
    CASE 
        WHEN GROUPING(Location) = 0 AND GROUPING(d.DepartmentName) = 0 THEN
            CASE 
                WHEN ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0)) > 95
                     AND (SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0)) < 150
                THEN 'Cost Management + Revenue Enhancement Needed'
                WHEN SUM(GeneratedRevenue) * 100.0 / NULLIF(SUM(ActualSalaryCost) + SUM(ActualProjectSpending), 0) > 300
                THEN 'Scale Up Operations - High Profitability'
                WHEN ((SUM(ActualSalaryCost) + SUM(ActualProjectSpending)) * 100.0 / NULLIF(SUM(DepartmentBudget), 0)) < 60
                THEN 'Investigate Low Utilization'
                ELSE 'Continue Current Strategy'
            END
        ELSE NULL
    END AS Strategic_Recommendation
FROM BudgetActualData
GROUP BY GROUPING SETS (
    (Location, d.DepartmentName),    -- Detailed d.DepartmentName analysis
    (Location),                    -- Location-level summary
    (d.DepartmentName),             -- d.DepartmentName type analysis
    ()                            -- Company-wide summary
)
HAVING SUM(DepartmentBudget) > 0
ORDER BY 
    GROUPING(Location),
    GROUPING(d.DepartmentName),
    SUM(GeneratedRevenue) DESC;
```

## Advanced GROUPING Functions

### 1. GROUPING and GROUPING_ID Functions

#### TechCorp Example: Advanced Grouping Identification
```sql
-- Demonstrate advanced grouping identification and custom labels
SELECT 
    Location,
    DepartmentName,
    e.JobTitle,
    COUNT(*) AS Employee_Count,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary,
    -- GROUPING function for individual columns (returns 0 or 1)
    GROUPING(Location) AS Location_Grouped,
    GROUPING(d.DepartmentName) AS Department_Grouped,
    GROUPING(e.JobTitle) AS JobTitle_Grouped,
    -- GROUPING_ID for combination identification (returns bitmask)
    GROUPING_ID(Location, DepartmentName, e.JobTitle) AS Grouping_Level_ID,
    -- Custom level identification using GROUPING_ID
    CASE GROUPING_ID(Location, DepartmentName, e.JobTitle)
        WHEN 0 THEN 'L4: Detailed (Location + d.DepartmentName + Job Title)'
        WHEN 1 THEN 'L3: Location + d.DepartmentName Summary'
        WHEN 2 THEN 'L3: Location + Job Title Summary'
        WHEN 3 THEN 'L2: Location Summary'
        WHEN 4 THEN 'L3: d.DepartmentName + Job Title Summary'
        WHEN 5 THEN 'L2: d.DepartmentName Summary'
        WHEN 6 THEN 'L2: Job Title Summary'
        WHEN 7 THEN 'L1: Grand Total'
        ELSE 'Unknown Level'
    END AS Analysis_Level,
    -- Business intelligence based on grouping level
    CASE GROUPING_ID(Location, DepartmentName, e.JobTitle)
        WHEN 0 THEN 'Operational Detail Analysis'
        WHEN 1 THEN 'Department Management Analysis'
        WHEN 2 THEN 'Location Role Analysis'
        WHEN 3 THEN 'Regional Performance Analysis'
        WHEN 4 THEN 'Role Distribution Analysis'
        WHEN 5 THEN 'Department Strategy Analysis'
        WHEN 6 THEN 'Company-wide Role Analysis'
        WHEN 7 THEN 'Executive Summary'
    END AS Business_Purpose
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND d.IsActive = 1
GROUP BY CUBE(Location, DepartmentName, e.JobTitle)
ORDER BY 
    GROUPING_ID(Location, DepartmentName, e.JobTitle),
    Location,
    DepartmentName,
    e.JobTitle;
```

## Performance Optimization for Grouping Sets

### 1. Indexing Strategy

```sql
-- Recommended indexes for optimal Grouping Sets performance
-- CREATE INDEX IX_Employees_Dept_Location_Salary ON Employees(DepartmentID, IsActive) INCLUDE (e.BaseSalary, e.JobTitle, e.HireDate);
-- CREATE INDEX IX_Departments_Location_Budget ON Departments(Location, IsActive) INCLUDE (DepartmentName, Budget);
-- CREATE INDEX IX_Orders_Employee_Date_Amount ON Orders(e.EmployeeID, OrderDate, IsActive) INCLUDE (TotalAmount, CustomerID);

-- Optimized Grouping Sets query with proper indexing
SELECT 
    d.Location,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS Employee_Count,
    FORMAT(SUM(e.BaseSalary), 'C') AS Total_Compensation,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary
FROM Employees e WITH(INDEX(IX_Employees_Dept_Location_Salary))
INNER JOIN Departments d WITH(INDEX(IX_Departments_Location_Budget)) 
    ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 
  AND d.IsActive = 1
GROUP BY ROLLUP(d.Location, d.DepartmentName)
ORDER BY 
    GROUPING(d.Location),
    GROUPING(d.DepartmentName),
    d.Location,
    d.DepartmentName;
```

### 2. Query Optimization Best Practices

```sql
-- ✅ GOOD: Efficient Grouping Sets with proper filtering
WITH FilteredEmployeeData AS (
    -- Pre-filter data to reduce processing overhead
    SELECT 
        d.Location,
        d.DepartmentName,
        e.BaseSalary,
        e.JobTitle
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND e.HireDate >= DATEADD(YEAR, -5, GETDATE())  -- Recent hires only
      AND e.BaseSalary > 0  -- Valid e.BaseSalary data only
)
SELECT 
    ISNULL(Location, 'All Locations') AS Location,
    ISNULL(DepartmentName, 'All Departments') AS DepartmentName,
    COUNT(*) AS Employee_Count,
    FORMAT(AVG(e.BaseSalary), 'C') AS Average_Salary,
    FORMAT(MIN(e.BaseSalary), 'C') AS Min_Salary,
    FORMAT(MAX(e.BaseSalary), 'C') AS Max_Salary
FROM FilteredEmployeeData
GROUP BY ROLLUP(Location, d.DepartmentName)
HAVING COUNT(*) >= 2  -- Only show groups with meaningful sample size
ORDER BY 
    GROUPING(Location),
    GROUPING(d.DepartmentName),
    AVG(e.BaseSalary) DESC;
```

## Summary

Grouping Sets provide TechCorp with powerful multi-dimensional analysis capabilities:

**Key Benefits:**
- **Multi-Level Aggregation**: Single query produces multiple aggregation levels
- **Subtotal Automation**: Automatic calculation of subtotals and grand totals
- **Flexible Grouping**: Custom grouping combinations for specific business needs
- **Performance Efficiency**: More efficient than multiple separate GROUP BY queries

**Business Applications:**
- Executive dashboard creation with hierarchical summaries
- Financial reporting with budget vs actual analysis
- Performance analysis across multiple organizational dimensions
- Strategic planning with comprehensive business intelligence

**Technical Advantages:**
- ROLLUP for hierarchical data organization
- CUBE for comprehensive cross-tabulation analysis
- GROUPING SETS for custom aggregation combinations
- GROUPING functions for dynamic result labeling

**Best Practices:**
- Use appropriate indexing strategies for grouping columns
- Pre-filter data to improve performance
- Leverage GROUPING functions for dynamic labeling
- Combine with CTEs for complex data preparation
- Apply HAVING clauses to filter meaningful aggregations

Grouping Sets operations enable TechCorp to create sophisticated business intelligence reports, executive dashboards, and multi-dimensional analysis that support strategic decision-making and operational excellence across all organizational levels.