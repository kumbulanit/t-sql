# Lesson 1: Writing Queries with PIVOT and UNPIVOT

## Overview

PIVOT and UNPIVOT are powerful T-SQL operators that enable data transformation between normalized and denormalized formats. PIVOT transforms unique row values into columns, creating cross-tabulation reports and analytical summaries. UNPIVOT performs the reverse operation, converting columns back into rows for normalized data processing. These operations are essential for TechCorp's business intelligence, reporting, and data analysis requirements.

## 🏢 TechCorp Business Context

**PIVOT/UNPIVOT Operations in Enterprise Analytics:**
- **Executive Dashboards**: Cross-tabulated performance metrics and KPI summaries
- **Financial Reporting**: Budget vs actual analysis across departments and time periods
- **Sales Analytics**: Revenue breakdown by product, region, and time dimensions
- **HR Analytics**: Employee distribution and compensation analysis by various dimensions
- **Operational Reporting**: Resource utilization and productivity metrics transformation

### 📋 TechCorp Database Schema Reference

**Core Tables for PIVOT/UNPIVOT Operations:**
```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Understanding PIVOT Operations

### PIVOT Mechanics and Use Cases

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PIVOT Operation Flow                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Source Data (Normalized):           PIVOT Result (Cross-tabulated):       │
│  ┌─────────────────────────┐        ┌─────────────────────────────────────┐ │
│  │ Department  │ Month │ Amt│   →    │ Department │ Jan │ Feb │ Mar │ Apr │ │
│  ├─────────────┼───────┼───┤        ├────────────┼─────┼─────┼─────┼─────┤ │
│  │ IT          │ Jan   │100│        │ IT         │ 100 │ 150 │ 200 │ 175 │ │
│  │ IT          │ Feb   │150│        │ HR         │  80 │ 120 │ 160 │ 140 │ │
│  │ IT          │ Mar   │200│        │ Sales      │ 300 │ 450 │ 500 │ 425 │ │
│  │ HR          │ Jan   │ 80│        └─────────────────────────────────────┘ │
│  │ HR          │ Feb   │120│                                                │
│  │ Sales       │ Jan   │300│        Key Benefits:                          │
│  │ ...         │ ...   │...│        • Easy cross-tabulation                │
│  └─────────────────────────┘        • Matrix-style reporting              │
│                                     • Comparative analysis                 │
│                                     • Executive dashboard format          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### PIVOT Syntax Structure

```sql
-- Basic PIVOT Syntax
SELECT pivot_columns, [pivot_value1], [pivot_value2], [pivot_value3]
FROM (
    SELECT columns_for_pivot, pivot_column, aggregate_column
    FROM source_table
    WHERE filter_conditions
) source_query
PIVOT (
    AGG_FUNCTION(aggregate_column)
    FOR pivot_column IN ([pivot_value1], [pivot_value2], [pivot_value3])
) pivot_alias;
```

## Basic PIVOT Operations

### 1. Department Budget Analysis

#### TechCorp Example: Quarterly Budget Performance
```sql
-- Transform quarterly budget data into cross-tabulated format for executive review
WITH QuarterlyBudgetData AS (
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN MONTH(p.StartDate) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(p.StartDate) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(p.StartDate) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END AS Quarter,
        p.Budget AS ProjectBudget
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE d.IsActive = 1
      AND e.IsActive = 1 
      AND p.IsActive = 1
      AND p.StartDate >= '2025-01-01'
      AND p.StartDate < '2026-01-01'
)
SELECT 
    DepartmentName,
    FORMAT(ISNULL([Q1], 0), 'C') AS Q1_Budget,
    FORMAT(ISNULL([Q2], 0), 'C') AS Q2_Budget,
    FORMAT(ISNULL([Q3], 0), 'C') AS Q3_Budget,
    FORMAT(ISNULL([Q4], 0), 'C') AS Q4_Budget,
    FORMAT(ISNULL([Q1], 0) + ISNULL([Q2], 0) + ISNULL([Q3], 0) + ISNULL([Q4], 0), 'C') AS Total_Annual_Budget,
    -- Calculate variance indicators
    CASE 
        WHEN ISNULL([Q4], 0) > ISNULL([Q1], 0) * 1.2 THEN 'Growing'
        WHEN ISNULL([Q4], 0) < ISNULL([Q1], 0) * 0.8 THEN 'Declining'
        ELSE 'Stable'
    END AS Budget_Trend
FROM QuarterlyBudgetData
PIVOT (
    SUM(ProjectBudget)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) pivot_table
ORDER BY Total_Annual_Budget DESC;
```

### 2. Employee Performance Matrix

#### TechCorp Example: Salary Distribution by Department and Experience Level
```sql
-- Create salary distribution matrix for HR compensation analysis
WITH EmployeeExperienceData AS (
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 2 THEN 'Entry Level'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 5 THEN 'Mid Level'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 10 THEN 'Senior Level'
            ELSE 'Executive Level'
        END AS ExperienceLevel,
        e.BaseSalary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
)
SELECT 
    DepartmentName,
    FORMAT(ISNULL([Entry Level], 0), 'C') AS Entry_Level_Avg,
    FORMAT(ISNULL([Mid Level], 0), 'C') AS Mid_Level_Avg,
    FORMAT(ISNULL([Senior Level], 0), 'C') AS Senior_Level_Avg,
    FORMAT(ISNULL([Executive Level], 0), 'C') AS Executive_Level_Avg,
    -- Calculate department salary range
    FORMAT(
        ISNULL([Executive Level], 0) - ISNULL([Entry Level], 0), 
        'C'
    ) AS Salary_Range_Span,
    -- Growth potential indicator
    CAST(
        CASE 
            WHEN ISNULL([Entry Level], 0) > 0 
            THEN (ISNULL([Executive Level], 0) * 1.0 / ISNULL([Entry Level], 0))
            ELSE 0
        END AS DECIMAL(4,2)
    ) AS Growth_Multiplier
FROM EmployeeExperienceData
PIVOT (
    AVG(BaseSalary)
    FOR ExperienceLevel IN ([Entry Level], [Mid Level], [Senior Level], [Executive Level])
) salary_pivot
ORDER BY Growth_Multiplier DESC, DepartmentName;
```

### 3. Customer Order Analysis

#### TechCorp Example: Revenue by Customer Country and Order Size Category
```sql
-- Transform customer revenue data for geographic and segment analysis
WITH CustomerOrderSegmentation AS (
    SELECT 
        c.Country,
        CASE 
            WHEN o.TotalAmount >= 10000 THEN 'Large Orders'
            WHEN o.TotalAmount >= 5000 THEN 'Medium Orders'
            WHEN o.TotalAmount >= 1000 THEN 'Small Orders'
            ELSE 'Micro Orders'
        END AS OrderSizeCategory,
        o.TotalAmount
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.IsActive = 1
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())
)
SELECT 
    Country,
    FORMAT(ISNULL([Large Orders], 0), 'C') AS Large_Orders_Revenue,
    FORMAT(ISNULL([Medium Orders], 0), 'C') AS Medium_Orders_Revenue,
    FORMAT(ISNULL([Small Orders], 0), 'C') AS Small_Orders_Revenue,
    FORMAT(ISNULL([Micro Orders], 0), 'C') AS Micro_Orders_Revenue,
    FORMAT(
        ISNULL([Large Orders], 0) + ISNULL([Medium Orders], 0) + 
        ISNULL([Small Orders], 0) + ISNULL([Micro Orders], 0), 
        'C'
    ) AS Total_Country_Revenue,
    -- Market penetration analysis
    CAST((ISNULL([Large Orders], 0) * 100.0 / 
         NULLIF(ISNULL([Large Orders], 0) + ISNULL([Medium Orders], 0) + 
                ISNULL([Small Orders], 0) + ISNULL([Micro Orders], 0), 0)) 
         AS DECIMAL(5,2)) AS Large_Order_Percentage,
    -- Revenue concentration indicator
    CASE 
        WHEN ISNULL([Large Orders], 0) > (ISNULL([Medium Orders], 0) + ISNULL([Small Orders], 0) + ISNULL([Micro Orders], 0))
        THEN 'High-Value Focused'
        WHEN ISNULL([Small Orders], 0) + ISNULL([Micro Orders], 0) > ISNULL([Large Orders], 0) + ISNULL([Medium Orders], 0)
        THEN 'Volume Focused'
        ELSE 'Balanced Mix'
    END AS Revenue_Profile
FROM CustomerOrderSegmentation
PIVOT (
    SUM(TotalAmount)
    FOR OrderSizeCategory IN ([Large Orders], [Medium Orders], [Small Orders], [Micro Orders])
) revenue_pivot
WHERE ([Large Orders] + [Medium Orders] + [Small Orders] + [Micro Orders]) > 0
ORDER BY Total_Country_Revenue DESC;
```

## Advanced PIVOT Applications

### 1. Dynamic PIVOT with Variable Columns

#### TechCorp Example: Monthly Sales Performance Dashboard
```sql
-- Dynamic PIVOT for flexible monthly reporting (2025 example)
DECLARE @PivotColumns NVARCHAR(MAX) = '';
DECLARE @PivotQuery NVARCHAR(MAX) = '';

-- Build dynamic column list for all months with data
SELECT @PivotColumns = STRING_AGG(QUOTENAME(MonthName), ', ')
FROM (
    SELECT DISTINCT 
        FORMAT(o.OrderDate, 'yyyy-MM') + ' - ' + FORMAT(o.OrderDate, 'MMM') AS MonthName
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE o.IsActive = 1
      AND e.IsActive = 1
      AND d.IsActive = 1
      AND o.OrderDate >= '2025-01-01'
      AND o.OrderDate < '2026-01-01'
) month_list;

-- Build dynamic PIVOT query
SET @PivotQuery = '
WITH MonthlySalesData AS (
    SELECT 
        d.DepartmentName,
        FORMAT(o.OrderDate, ''yyyy-MM'') + '' - '' + FORMAT(o.OrderDate, ''MMM'') AS MonthName,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE o.IsActive = 1
      AND e.IsActive = 1
      AND d.IsActive = 1
      AND o.OrderDate >= ''2025-01-01''
      AND o.OrderDate < ''2026-01-01''
)
SELECT 
    DepartmentName,' + @PivotColumns + ',
    FORMAT((' + REPLACE(@PivotColumns, ', ', ' + ') + '), ''C'') AS Total_Annual_Revenue
FROM MonthlySalesData
PIVOT (
    SUM(TotalAmount)
    FOR MonthName IN (' + @PivotColumns + ')
) monthly_pivot
ORDER BY Total_Annual_Revenue DESC;';

-- Execute dynamic query
EXEC sp_executesql @PivotQuery;
```

### 2. Multi-Level PIVOT Operations

#### TechCorp Example: Employee Project Allocation Matrix
```sql
-- Complex PIVOT showing employee allocation across projects and roles
WITH ProjectAllocationData AS (
    SELECT 
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        p.ProjectName,
        ep.Role,
        ep.HoursWorked,
        -- Create project-role combination for pivot
        p.ProjectName + ' - ' + ep.Role AS ProjectRoleCombo
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND ep.IsActive = 1
      AND p.IsActive = 1
      AND ep.StartDate >= DATEADD(YEAR, -1, GETDATE())
),
ProjectRolePivot AS (
    SELECT 
        EmployeeName,
        DepartmentName,
        -- Get top 6 project-role combinations for manageable matrix
        [ProjectRole1], [ProjectRole2], [ProjectRole3], 
        [ProjectRole4], [ProjectRole5], [ProjectRole6]
    FROM (
        SELECT 
            EmployeeName,
            DepartmentName,
            ProjectRoleCombo,
            HoursWorked,
            ROW_NUMBER() OVER (ORDER BY ProjectRoleCombo) AS ProjectRoleRank
        FROM ProjectAllocationData
    ) ranked_data
    PIVOT (
        SUM(HoursWorked)
        FOR ProjectRoleRank IN ([1], [2], [3], [4], [5], [6])
    ) project_pivot
)
-- Final result with meaningful column names
SELECT 
    EmployeeName,
    DepartmentName,
    ISNULL([ProjectRole1], 0) AS Primary_Assignment_Hours,
    ISNULL([ProjectRole2], 0) AS Secondary_Assignment_Hours,
    ISNULL([ProjectRole3], 0) AS Additional_Assignment_1,
    ISNULL([ProjectRole4], 0) AS Additional_Assignment_2,
    ISNULL([ProjectRole5], 0) AS Additional_Assignment_3,
    ISNULL([ProjectRole6], 0) AS Additional_Assignment_4,
    -- Calculate utilization metrics
    (ISNULL([ProjectRole1], 0) + ISNULL([ProjectRole2], 0) + 
     ISNULL([ProjectRole3], 0) + ISNULL([ProjectRole4], 0) + 
     ISNULL([ProjectRole5], 0) + ISNULL([ProjectRole6], 0)) AS Total_Project_Hours,
    -- Workload assessment
    CASE 
        WHEN (ISNULL([ProjectRole1], 0) + ISNULL([ProjectRole2], 0) + 
              ISNULL([ProjectRole3], 0) + ISNULL([ProjectRole4], 0) + 
              ISNULL([ProjectRole5], 0) + ISNULL([ProjectRole6], 0)) > 200 
        THEN 'Overallocated'
        WHEN (ISNULL([ProjectRole1], 0) + ISNULL([ProjectRole2], 0) + 
              ISNULL([ProjectRole3], 0) + ISNULL([ProjectRole4], 0) + 
              ISNULL([ProjectRole5], 0) + ISNULL([ProjectRole6], 0)) > 120
        THEN 'Fully Utilized'
        WHEN (ISNULL([ProjectRole1], 0) + ISNULL([ProjectRole2], 0) + 
              ISNULL([ProjectRole3], 0) + ISNULL([ProjectRole4], 0) + 
              ISNULL([ProjectRole5], 0) + ISNULL([ProjectRole6], 0)) > 40
        THEN 'Underutilized'
        ELSE 'Available'
    END AS Utilization_Status
FROM ProjectRolePivot
ORDER BY Total_Project_Hours DESC, DepartmentName, EmployeeName;
```

## Understanding UNPIVOT Operations

### UNPIVOT Mechanics and Use Cases

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         UNPIVOT Operation Flow                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Source Data (Cross-tabulated):      UNPIVOT Result (Normalized):          │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────────┐ │
│  │ Department │ Q1  │ Q2  │ Q3  │Q4│  │ Department │ Quarter │ Amount      │ │
│  ├────────────┼─────┼─────┼─────┼──┤  ├────────────┼─────────┼─────────────┤ │
│  │ IT         │ 100 │ 150 │ 200 │175│  │ IT         │ Q1      │ 100         │ │
│  │ HR         │  80 │ 120 │ 160 │140│  │ IT         │ Q2      │ 150         │ │
│  │ Sales      │ 300 │ 450 │ 500 │425│  │ IT         │ Q3      │ 200         │ │
│  └─────────────────────────────────┘  │ IT         │ Q4      │ 175         │ │
│                                       │ HR         │ Q1      │  80         │ │
│                 ↓ UNPIVOT              │ HR         │ Q2      │ 120         │ │
│                                       │ ...        │ ...     │ ...         │ │
│  Key Benefits:                        └─────────────────────────────────────┘ │
│  • Normalize crosstab data                                                  │
│  • Enable standard aggregations                                            │
│  • Facilitate time series analysis                                         │
│  • Support data warehouse ETL                                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### UNPIVOT Syntax Structure

```sql
-- Basic UNPIVOT Syntax
SELECT fixed_columns, unpivot_column, value_column
FROM (
    SELECT fixed_columns, [col1], [col2], [col3], [col4]
    FROM source_table
    WHERE filter_conditions
) source_query
UNPIVOT (
    value_column FOR unpivot_column IN ([col1], [col2], [col3], [col4])
) unpivot_alias;
```

## Basic UNPIVOT Operations

### 1. Quarterly Report Normalization

#### TechCorp Example: Converting Quarterly Budget Matrix to Time Series
```sql
-- Normalize quarterly budget data for trend analysis and forecasting
WITH QuarterlyBudgetMatrix AS (
    -- Simulate quarterly budget crosstab (would typically come from PIVOT or imported data)
    SELECT 
        d.DepartmentName,
        SUM(CASE WHEN MONTH(p.StartDate) BETWEEN 1 AND 3 THEN p.Budget ELSE 0 END) AS Q1_Budget,
        SUM(CASE WHEN MONTH(p.StartDate) BETWEEN 4 AND 6 THEN p.Budget ELSE 0 END) AS Q2_Budget,
        SUM(CASE WHEN MONTH(p.StartDate) BETWEEN 7 AND 9 THEN p.Budget ELSE 0 END) AS Q3_Budget,
        SUM(CASE WHEN MONTH(p.StartDate) BETWEEN 10 AND 12 THEN p.Budget ELSE 0 END) AS Q4_Budget
    FROM Departments d
    INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
    INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE d.IsActive = 1
      AND e.IsActive = 1
      AND p.IsActive = 1
      AND YEAR(p.StartDate) = 2025
    GROUP BY d.DepartmentName
)
SELECT 
    DepartmentName,
    Quarter,
    FORMAT(QuarterlyBudget, 'C') AS Quarterly_Budget,
    -- Add analytical columns for time series analysis
    CASE Quarter
        WHEN 'Q1' THEN 1
        WHEN 'Q2' THEN 2
        WHEN 'Q3' THEN 3
        WHEN 'Q4' THEN 4
    END AS Quarter_Number,
    -- Calculate quarter-over-quarter growth
    FORMAT(
        QuarterlyBudget - LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        ), 'C'
    ) AS QoQ_Change,
    -- Calculate growth percentage
    CAST(
        (QuarterlyBudget - LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        )) * 100.0 / NULLIF(LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        ), 0) AS DECIMAL(5,2)
    ) AS QoQ_Growth_Percent,
    -- Trend classification
    CASE 
        WHEN QuarterlyBudget > LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        ) * 1.1 THEN 'Strong Growth'
        WHEN QuarterlyBudget > LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        ) THEN 'Moderate Growth'
        WHEN QuarterlyBudget < LAG(QuarterlyBudget) OVER (
            PARTITION BY DepartmentName 
            ORDER BY CASE Quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4 END
        ) * 0.9 THEN 'Declining'
        ELSE 'Stable'
    END AS Trend_Classification
FROM QuarterlyBudgetMatrix
UNPIVOT (
    QuarterlyBudget FOR Quarter IN (Q1_Budget, Q2_Budget, Q3_Budget, Q4_Budget)
) unpivot_data
-- Clean up column names for better readability
CROSS APPLY (
    SELECT 
        CASE Quarter
            WHEN 'Q1_Budget' THEN 'Q1'
            WHEN 'Q2_Budget' THEN 'Q2'
            WHEN 'Q3_Budget' THEN 'Q3'
            WHEN 'Q4_Budget' THEN 'Q4'
        END AS Quarter
) quarter_cleanup
WHERE QuarterlyBudget > 0  -- Exclude quarters with no budget activity
ORDER BY DepartmentName, Quarter_Number;
```

### 2. Employee Performance Data Normalization

#### TechCorp Example: Converting Performance Matrix to Analytical Format
```sql
-- Transform employee performance matrix into normalized format for detailed analysis
WITH PerformanceMatrix AS (
    -- Create performance metrics matrix (simulated multi-dimensional data)
    SELECT 
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.JobTitle,
        -- Performance metrics by category
        CAST(ISNULL(proj_metrics.ProjectScore, 0) AS DECIMAL(5,2)) AS Project_Performance,
        CAST(ISNULL(customer_metrics.CustomerScore, 0) AS DECIMAL(5,2)) AS Customer_Relations,
        CAST(ISNULL(team_metrics.TeamScore, 0) AS DECIMAL(5,2)) AS Team_Collaboration,
        CAST(ISNULL(innovation_metrics.InnovationScore, 0) AS DECIMAL(5,2)) AS Innovation_Index
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN (
        -- Project performance scoring
        SELECT 
            ep.EmployeeID,
            AVG(CASE WHEN ep.HoursWorked > 40 THEN 85 + (ep.HoursWorked - 40) * 0.3 ELSE ep.HoursWorked * 2 END) AS ProjectScore
        FROM EmployeeProjects ep
        WHERE ep.IsActive = 1
        GROUP BY ep.EmployeeID
    ) proj_metrics ON e.EmployeeID = proj_metrics.EmployeeID
    LEFT JOIN (
        -- Customer relations scoring
        SELECT 
            o.EmployeeID,
            AVG(CASE WHEN o.TotalAmount > 5000 THEN 90 ELSE 60 + (o.TotalAmount / 100) END) AS CustomerScore
        FROM Orders o
        WHERE o.IsActive = 1
        GROUP BY o.EmployeeID
    ) customer_metrics ON e.EmployeeID = customer_metrics.EmployeeID
    LEFT JOIN (
        -- Team collaboration scoring (based on management span)
        SELECT 
            mgr.EmployeeID,
            CASE 
                WHEN subordinate_count.SubCount > 5 THEN 95
                WHEN subordinate_count.SubCount > 2 THEN 80
                WHEN subordinate_count.SubCount > 0 THEN 70
                ELSE 60
            END AS TeamScore
        FROM Employees mgr
        LEFT JOIN (
            SELECT ManagerID, COUNT(*) AS SubCount
            FROM Employees
            WHERE IsActive = 1
            GROUP BY ManagerID
        ) subordinate_count ON mgr.EmployeeID = subordinate_count.ManagerID
        WHERE mgr.IsActive = 1
    ) team_metrics ON e.EmployeeID = team_metrics.EmployeeID
    LEFT JOIN (
        -- Innovation index (project variety and complexity)
        SELECT 
            ep.EmployeeID,
            COUNT(DISTINCT ep.Role) * 15 + COUNT(DISTINCT ep.ProjectID) * 5 AS InnovationScore
        FROM EmployeeProjects ep
        WHERE ep.IsActive = 1
        GROUP BY ep.EmployeeID
    ) innovation_metrics ON e.EmployeeID = innovation_metrics.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
)
-- UNPIVOT the performance matrix for analytical processing
SELECT 
    EmployeeName,
    DepartmentName,
    JobTitle,
    Performance_Category,
    Performance_Score,
    -- Add performance grade
    CASE 
        WHEN Performance_Score >= 90 THEN 'Exceptional'
        WHEN Performance_Score >= 75 THEN 'High Performer'
        WHEN Performance_Score >= 60 THEN 'Meets Expectations'
        WHEN Performance_Score >= 40 THEN 'Needs Improvement'
        ELSE 'Below Standards'
    END AS Performance_Grade,
    -- Calculate departmental ranking for each category
    RANK() OVER (
        PARTITION BY DepartmentName, Performance_Category 
        ORDER BY Performance_Score DESC
    ) AS Department_Rank,
    -- Calculate company-wide ranking for each category
    RANK() OVER (
        PARTITION BY Performance_Category 
        ORDER BY Performance_Score DESC
    ) AS Company_Rank,
    -- Performance improvement recommendations
    CASE Performance_Category
        WHEN 'Project_Performance' THEN 
            CASE 
                WHEN Performance_Score < 60 THEN 'Increase project involvement and training'
                WHEN Performance_Score < 80 THEN 'Focus on project leadership opportunities'
                ELSE 'Consider mentoring others'
            END
        WHEN 'Customer_Relations' THEN 
            CASE 
                WHEN Performance_Score < 60 THEN 'Customer service training recommended'
                WHEN Performance_Score < 80 THEN 'Expand customer interaction opportunities'
                ELSE 'Lead customer relationship initiatives'
            END
        WHEN 'Team_Collaboration' THEN 
            CASE 
                WHEN Performance_Score < 60 THEN 'Team building and communication training'
                WHEN Performance_Score < 80 THEN 'Take on team lead responsibilities'
                ELSE 'Mentor team collaboration best practices'
            END
        WHEN 'Innovation_Index' THEN 
            CASE 
                WHEN Performance_Score < 60 THEN 'Encourage creative problem-solving initiatives'
                WHEN Performance_Score < 80 THEN 'Lead innovation projects'
                ELSE 'Drive organization-wide innovation programs'
            END
    END AS Development_Recommendation
FROM PerformanceMatrix
UNPIVOT (
    Performance_Score FOR Performance_Category IN (
        Project_Performance, Customer_Relations, Team_Collaboration, Innovation_Index
    )
) performance_unpivot
WHERE Performance_Score > 0  -- Only include categories with actual performance data
ORDER BY EmployeeName, 
         CASE Performance_Category 
             WHEN 'Project_Performance' THEN 1
             WHEN 'Customer_Relations' THEN 2
             WHEN 'Team_Collaboration' THEN 3
             WHEN 'Innovation_Index' THEN 4
         END;
```

## Advanced PIVOT/UNPIVOT Combinations

### 1. Comprehensive Business Intelligence Dashboard

#### TechCorp Example: Executive KPI Dashboard with Data Transformation
```sql
-- Complex business intelligence query combining PIVOT and UNPIVOT operations
WITH DepartmentKPIMatrix AS (
    -- First, create a comprehensive KPI matrix using PIVOT
    SELECT 
        DepartmentName,
        [Employee_Count] AS Active_Employees,
        [Avg_Salary] AS Average_Salary,
        [Total_Projects] AS Active_Projects,
        [Project_Budget] AS Total_Project_Budget,
        [Customer_Orders] AS Customer_Orders_Processed,
        [Order_Revenue] AS Total_Order_Revenue
    FROM (
        SELECT 
            d.DepartmentName,
            'Employee_Count' AS KPI_Type,
            CAST(COUNT(DISTINCT e.EmployeeID) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
        WHERE d.IsActive = 1
        GROUP BY d.DepartmentName
        
        UNION ALL
        
        SELECT 
            d.DepartmentName,
            'Avg_Salary' AS KPI_Type,
            CAST(AVG(e.BaseSalary) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        WHERE d.IsActive = 1 AND e.IsActive = 1
        GROUP BY d.DepartmentName
        
        UNION ALL
        
        SELECT 
            d.DepartmentName,
            'Total_Projects' AS KPI_Type,
            CAST(COUNT(DISTINCT p.ProjectID) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
        WHERE d.IsActive = 1 AND e.IsActive = 1 AND p.IsActive = 1
        GROUP BY d.DepartmentName
        
        UNION ALL
        
        SELECT 
            d.DepartmentName,
            'Project_Budget' AS KPI_Type,
            CAST(SUM(p.Budget) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
        WHERE d.IsActive = 1 AND e.IsActive = 1 AND p.IsActive = 1
        GROUP BY d.DepartmentName
        
        UNION ALL
        
        SELECT 
            d.DepartmentName,
            'Customer_Orders' AS KPI_Type,
            CAST(COUNT(o.OrderID) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
        WHERE d.IsActive = 1 AND e.IsActive = 1 AND o.IsActive = 1
        GROUP BY d.DepartmentName
        
        UNION ALL
        
        SELECT 
            d.DepartmentName,
            'Order_Revenue' AS KPI_Type,
            CAST(SUM(o.TotalAmount) AS DECIMAL(15,2)) AS KPI_Value
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
        WHERE d.IsActive = 1 AND e.IsActive = 1 AND o.IsActive = 1
        GROUP BY d.DepartmentName
    ) kpi_source
    PIVOT (
        SUM(KPI_Value) FOR KPI_Type IN (
            [Employee_Count], [Avg_Salary], [Total_Projects], 
            [Project_Budget], [Customer_Orders], [Order_Revenue]
        )
    ) kpi_pivot
),
NormalizedKPIData AS (
    -- Then UNPIVOT the matrix for detailed analysis
    SELECT 
        DepartmentName,
        KPI_Category,
        KPI_Value,
        -- Add performance benchmarks and classifications
        CASE KPI_Category
            WHEN 'Active_Employees' THEN 
                CASE 
                    WHEN KPI_Value >= 20 THEN 'Large Department'
                    WHEN KPI_Value >= 10 THEN 'Medium Department'
                    WHEN KPI_Value >= 5 THEN 'Small Department'
                    ELSE 'Micro Department'
                END
            WHEN 'Average_Salary' THEN 
                CASE 
                    WHEN KPI_Value >= 80000 THEN 'High Compensation'
                    WHEN KPI_Value >= 60000 THEN 'Competitive Compensation'
                    WHEN KPI_Value >= 40000 THEN 'Standard Compensation'
                    ELSE 'Below Market Compensation'
                END
            WHEN 'Active_Projects' THEN 
                CASE 
                    WHEN KPI_Value >= 10 THEN 'Highly Active'
                    WHEN KPI_Value >= 5 THEN 'Active'
                    WHEN KPI_Value >= 2 THEN 'Moderately Active'
                    ELSE 'Low Activity'
                END
            ELSE 'Standard Range'
        END AS Performance_Classification,
        -- Calculate department efficiency ratios
        CASE 
            WHEN KPI_Category = 'Total_Order_Revenue' AND Active_Employees > 0 
            THEN KPI_Value / Active_Employees
            WHEN KPI_Category = 'Total_Project_Budget' AND Active_Employees > 0 
            THEN KPI_Value / Active_Employees
            ELSE NULL
        END AS Per_Employee_Metric,
        -- Add ranking within category
        RANK() OVER (PARTITION BY KPI_Category ORDER BY KPI_Value DESC) AS Category_Rank,
        -- Add percentile ranking
        PERCENT_RANK() OVER (PARTITION BY KPI_Category ORDER BY KPI_Value) AS Percentile_Rank
    FROM DepartmentKPIMatrix
    UNPIVOT (
        KPI_Value FOR KPI_Category IN (
            Active_Employees, Average_Salary, Active_Projects,
            Total_Project_Budget, Customer_Orders, Total_Order_Revenue
        )
    ) unpivot_kpis
    WHERE KPI_Value IS NOT NULL AND KPI_Value > 0
)
-- Final executive dashboard with comprehensive insights
SELECT 
    DepartmentName,
    KPI_Category,
    CASE KPI_Category
        WHEN 'Average_Salary' THEN FORMAT(KPI_Value, 'C')
        WHEN 'Total_Project_Budget' THEN FORMAT(KPI_Value, 'C')
        WHEN 'Total_Order_Revenue' THEN FORMAT(KPI_Value, 'C')
        ELSE FORMAT(KPI_Value, 'N0')
    END AS Formatted_KPI_Value,
    Performance_Classification,
    Category_Rank,
    CONCAT(CAST(ROUND(Percentile_Rank * 100, 1) AS VARCHAR), '%') AS Percentile_Position,
    -- Strategic recommendations based on KPI performance
    CASE 
        WHEN Percentile_Rank >= 0.8 THEN 'Leverage as best practice model'
        WHEN Percentile_Rank >= 0.6 THEN 'Good performance, optimize further'
        WHEN Percentile_Rank >= 0.4 THEN 'Monitor and improve'
        WHEN Percentile_Rank >= 0.2 THEN 'Requires attention and resources'
        ELSE 'Critical improvement needed'
    END AS Strategic_Recommendation,
    -- Performance trend indicator (simplified)
    CASE 
        WHEN Category_Rank <= 2 THEN '↗️ Top Performer'
        WHEN Category_Rank <= CEILING((SELECT COUNT(DISTINCT DepartmentName) FROM DepartmentKPIMatrix) * 0.5) 
             THEN '→ Average Performer'
        ELSE '↘️ Below Average'
    END AS Trend_Indicator
FROM NormalizedKPIData
ORDER BY DepartmentName, 
         CASE KPI_Category 
             WHEN 'Active_Employees' THEN 1
             WHEN 'Average_Salary' THEN 2
             WHEN 'Active_Projects' THEN 3
             WHEN 'Total_Project_Budget' THEN 4
             WHEN 'Customer_Orders' THEN 5
             WHEN 'Total_Order_Revenue' THEN 6
         END;
```

## Performance Optimization for PIVOT/UNPIVOT

### 1. Indexing Strategy for PIVOT Operations

```sql
-- Recommended indexes for optimal PIVOT/UNPIVOT performance
-- CREATE INDEX IX_Orders_Employee_Date_Amount ON Orders(EmployeeID, OrderDate, TotalAmount) INCLUDE (CustomerID, IsActive);
-- CREATE INDEX IX_EmployeeProjects_Employee_Project ON EmployeeProjects(EmployeeID, ProjectID, IsActive) INCLUDE (Role, HoursWorked);
-- CREATE INDEX IX_Employees_Department_Salary ON Employees(DepartmentID, BaseSalary, IsActive) INCLUDE (FirstName, LastName, JobTitle);

-- Example of optimized PIVOT query design
WITH OptimizedPivotSource AS (
    SELECT 
        d.DepartmentName,
        DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
        o.TotalAmount
    FROM Orders o WITH(INDEX(IX_Orders_Employee_Date_Amount))  -- Force index usage
    INNER JOIN Employees e WITH(INDEX(IX_Employees_Department_Salary)) ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE o.IsActive = 1
      AND e.IsActive = 1
      AND d.IsActive = 1
      AND o.OrderDate >= DATEADD(YEAR, -1, GETDATE())  -- Limit date range for performance
)
SELECT 
    DepartmentName,
    FORMAT(ISNULL([1], 0), 'C') AS Q1_Revenue,
    FORMAT(ISNULL([2], 0), 'C') AS Q2_Revenue,
    FORMAT(ISNULL([3], 0), 'C') AS Q3_Revenue,
    FORMAT(ISNULL([4], 0), 'C') AS Q4_Revenue
FROM OptimizedPivotSource
PIVOT (
    SUM(TotalAmount) FOR OrderQuarter IN ([1], [2], [3], [4])
) revenue_pivot
ORDER BY DepartmentName;
```

### 2. Best Practices for Large Dataset Operations

```sql
-- ✅ GOOD: Efficient PIVOT with proper filtering and aggregation
WITH FilteredData AS (
    -- Pre-filter data to reduce processing overhead
    SELECT 
        d.DepartmentName,
        FORMAT(o.OrderDate, 'yyyy-MM') AS OrderMonth,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE o.IsActive = 1
      AND e.IsActive = 1
      AND d.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -12, GETDATE())  -- Only last 12 months
      AND o.TotalAmount > 0  -- Exclude zero-value orders
),
MonthlyAggregation AS (
    -- Pre-aggregate before PIVOT to improve performance
    SELECT 
        DepartmentName,
        OrderMonth,
        SUM(TotalAmount) AS MonthlyRevenue
    FROM FilteredData
    GROUP BY DepartmentName, OrderMonth
)
SELECT 
    DepartmentName,
    -- Only include months with significant data
    FORMAT(ISNULL([2025-01], 0), 'C') AS Jan_2025,
    FORMAT(ISNULL([2025-02], 0), 'C') AS Feb_2025,
    FORMAT(ISNULL([2025-03], 0), 'C') AS Mar_2025,
    FORMAT(ISNULL([2025-04], 0), 'C') AS Apr_2025,
    FORMAT(ISNULL([2025-05], 0), 'C') AS May_2025,
    FORMAT(ISNULL([2025-06], 0), 'C') AS Jun_2025
FROM MonthlyAggregation
PIVOT (
    SUM(MonthlyRevenue) FOR OrderMonth IN (
        [2025-01], [2025-02], [2025-03], [2025-04], [2025-05], [2025-06]
    )
) monthly_pivot
ORDER BY DepartmentName;
```

## Common Pitfalls and Solutions

### 1. NULL Handling in PIVOT Operations

```sql
-- ❌ PROBLEM: PIVOT doesn't handle NULLs as expected
SELECT DepartmentName, [Q1], [Q2], [Q3], [Q4]
FROM (
    SELECT d.DepartmentName, 'Q1' AS Quarter, NULL AS Revenue
    FROM Departments d
) source_data
PIVOT (SUM(Revenue) FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])) pivot_table;
-- Result: NULL values in PIVOT columns

-- ✅ SOLUTION: Proper NULL handling with ISNULL and default values
SELECT 
    DepartmentName,
    FORMAT(ISNULL([Q1], 0), 'C') AS Q1_Revenue,
    FORMAT(ISNULL([Q2], 0), 'C') AS Q2_Revenue,
    FORMAT(ISNULL([Q3], 0), 'C') AS Q3_Revenue,
    FORMAT(ISNULL([Q4], 0), 'C') AS Q4_Revenue,
    -- Add meaningful indicators for missing data
    CASE 
        WHEN ([Q1] IS NULL AND [Q2] IS NULL AND [Q3] IS NULL AND [Q4] IS NULL)
        THEN 'No Data Available'
        WHEN ([Q1] IS NULL OR [Q2] IS NULL OR [Q3] IS NULL OR [Q4] IS NULL)
        THEN 'Partial Data'
        ELSE 'Complete Data'
    END AS Data_Completeness
FROM (
    SELECT 
        d.DepartmentName,
        CASE 
            WHEN MONTH(p.StartDate) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(p.StartDate) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(p.StartDate) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END AS Quarter,
        p.Budget AS Revenue
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
    WHERE d.IsActive = 1
      AND (e.IsActive = 1 OR e.EmployeeID IS NULL)
      AND (p.IsActive = 1 OR p.ProjectID IS NULL)
) source_data
PIVOT (SUM(Revenue) FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])) pivot_table
ORDER BY DepartmentName;
```

### 2. Dynamic Column Challenges

```sql
-- ❌ PROBLEM: Hard-coded column names in PIVOT
SELECT DepartmentName, [Project Alpha], [Project Beta], [Project Gamma]
FROM project_data
PIVOT (SUM(Budget) FOR ProjectName IN ([Project Alpha], [Project Beta], [Project Gamma])) p;
-- Problem: Doesn't adapt to new projects

-- ✅ SOLUTION: Dynamic PIVOT with proper error handling
DECLARE @ProjectColumns NVARCHAR(MAX) = '';
DECLARE @DynamicPivotSQL NVARCHAR(MAX) = '';

-- Build column list safely
SELECT @ProjectColumns = STRING_AGG(QUOTENAME(ProjectName), ', ')
FROM (
    SELECT DISTINCT TOP 20 p.ProjectName  -- Limit columns for manageability
    FROM Projects p
    WHERE p.IsActive = 1
      AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())  -- Recent projects only
    ORDER BY p.ProjectName
) active_projects;

-- Validate that we have columns to work with
IF @ProjectColumns IS NOT NULL AND LEN(@ProjectColumns) > 0
BEGIN
    SET @DynamicPivotSQL = N'
    WITH ProjectBudgetData AS (
        SELECT 
            d.DepartmentName,
            p.ProjectName,
            p.Budget
        FROM Departments d
        INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
        INNER JOIN Projects p ON e.EmployeeID = p.ProjectManagerID
        WHERE d.IsActive = 1
          AND e.IsActive = 1
          AND p.IsActive = 1
          AND p.StartDate >= DATEADD(YEAR, -2, GETDATE())
    )
    SELECT 
        DepartmentName,
        ' + @ProjectColumns + ',
        FORMAT((' + REPLACE(@ProjectColumns, ', ', ' + ISNULL(') + ', 0) + ISNULL(') + ', 0)), ''C'') AS Total_Department_Budget
    FROM ProjectBudgetData
    PIVOT (
        SUM(Budget) FOR ProjectName IN (' + @ProjectColumns + ')
    ) project_pivot
    ORDER BY Total_Department_Budget DESC;';

    EXEC sp_executesql @DynamicPivotSQL;
END
ELSE
BEGIN
    SELECT 'No active projects found for PIVOT operation' AS Message;
END
```

## Summary

PIVOT and UNPIVOT operations are essential for TechCorp's advanced data analysis:

**Key Benefits:**
- **Data Transformation**: Convert between normalized and cross-tabulated formats
- **Executive Reporting**: Create dashboard-ready matrix presentations
- **Analytical Flexibility**: Enable different perspectives on the same data
- **Business Intelligence**: Support sophisticated KPI and performance analysis

**Business Applications:**
- Financial reporting and budget analysis
- Performance dashboards and scorecards
- Sales and revenue analysis by multiple dimensions
- Employee performance evaluation matrices
- Customer behavior and segmentation analysis

**Technical Advantages:**
- Efficient data reshaping operations
- Integration with standard SQL operations
- Support for dynamic column generation
- Optimized query execution plans

**Best Practices:**
- Pre-filter data to improve performance
- Handle NULL values appropriately
- Use dynamic SQL for flexible column sets
- Implement proper indexing strategies
- Combine with CTEs for complex transformations

PIVOT and UNPIVOT operations provide TechCorp with powerful data transformation capabilities that enable sophisticated business intelligence, executive reporting, and strategic analysis through flexible data presentation formats.