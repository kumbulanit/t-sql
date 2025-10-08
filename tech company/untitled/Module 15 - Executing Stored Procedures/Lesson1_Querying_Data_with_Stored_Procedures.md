# Lesson 1: Querying Data with Stored Procedures

## 🎯 **Overview for Beginners**

**What is a Stored Procedure?**
Think of a stored procedure as a **"recipe card"** stored in your database:

**Real-World Analogy:**
- **Recipe Card** ➜ Has step-by-step instructions to make a dish
- **Stored Procedure** ➜ Has step-by-step T-SQL instructions to get data

**Simple Example:**
Instead of writing the same complex query every time:
```sql
-- Instead of writing this repeatedly:
SELECT e.FirstName, e.LastName, e.JobTitle, d.DepartmentName, e.BaseSalary
FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1 AND d.DepartmentName = 'Engineering'
ORDER BY e.BaseSalary DESC;
```

You create a "recipe" (stored procedure) and just call it:
```sql
-- Much simpler - just call the procedure:
EXEC GetEngineeringEmployees;
```

## 🔍 **Why Use Stored Procedures? (Beginner Benefits)**

**For Beginners, Stored Procedures are Like:**
- **📋 Recipe Cards:** Write once, use many times
- **🔐 Safety Locks:** Controlled access to data  
- **⚡ Express Lane:** Faster execution than regular queries
- **📝 Standard Forms:** Everyone uses the same format

**Real TechCorp Benefits:**
- **Consistency:** Every department gets employee reports the same way
- **Speed:** Pre-optimized queries run faster than ad-hoc queries
- **Security:** Users can run procedures without accessing tables directly
- **Maintenance:** Fix the procedure once, all applications benefit

## 🏢 TechCorp Business Context

**Stored Procedures in Enterprise Operations:**
- **Standardized Reporting**: Consistent data retrieval patterns for executive dashboards and operational reports
- **Business Logic Centralization**: Centralized calculations and business rules in database layer
- **Security Enhancement**: Controlled data access through procedure execution rather than direct table access
- **Performance Optimization**: Pre-compiled execution plans for frequently accessed data
- **API Integration**: Database endpoints for application integration and service layer architecture

### 📋 TechCorp Database Schema Reference

**Core Tables for Stored Procedure Operations:**
```sql
Employees: EmployeeID (3001+), FirstName, LastName, BaseSalary, DepartmentID, ManagerID, JobTitle, HireDate, WorkEmail, IsActive
Departments: DepartmentID (2001+), DepartmentName, Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Understanding Stored Procedures

### Stored Procedure Architecture and Benefits

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Stored Procedure Architecture                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Client Application                                                         │
│  ┌──────────────────────┐                                                   │
│  │ EXEC sp_GetEmployees │  →  Database Server                               │
│  │ @DepartmentID = 2001 │     ┌─────────────────────────────────────────┐   │
│  └──────────────────────┘     │ Stored Procedure Cache                  │   │
│                                │ ┌─────────────────────────────────────┐ │   │
│  vs                            │ │ sp_GetEmployees                     │ │   │
│                                │ │ - Pre-compiled execution plan       │ │   │
│  ┌──────────────────────┐     │ │ - Optimized query structure         │ │   │
│  │ SELECT * FROM        │  →  │ │ - Parameter validation             │ │   │
│  │ Employees WHERE      │     │ │ - Business logic encapsulation     │ │   │
│  │ DepartmentID = 2001  │     │ └─────────────────────────────────────┘ │   │
│  └──────────────────────┘     └─────────────────────────────────────────┘   │
│  (Ad-hoc Query)                                                             │
│                                                                             │
│  Key Advantages:                                                           │
│  • Performance: Pre-compiled execution plans                              │
│  • Security: Parameterized execution prevents SQL injection               │
│  • Maintainability: Centralized business logic                           │
│  • Consistency: Standardized data access patterns                        │
│  • Modularity: Reusable database functionality                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Basic Stored Procedure Syntax

```sql
-- Basic stored procedure structure
CREATE PROCEDURE procedure_name
    @parameter1 datatype = default_value,
    @parameter2 datatype = default_value
AS
BEGIN
    -- Procedure body with T-SQL statements
    SELECT columns
    FROM tables
    WHERE conditions;
END;

-- Executing stored procedures
EXEC procedure_name @parameter1 = value1, @parameter2 = value2;
-- OR
EXECUTE procedure_name value1, value2;  -- Positional parameters
```

## Existing TechCorp Stored Procedures

### 1. Employee Information Retrieval

#### TechCorp Example: Department Employee Listing
```sql
-- Create stored procedure for department employee analysis
CREATE PROCEDURE sp_GetDepartmentEmployees
    @DepartmentID INT = NULL,
    @IncludeInactive BIT = 0,
    @SortBy VARCHAR(20) = 'LastName'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @DepartmentID IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Departments WHERE DepartmentID = @DepartmentID
    )
    BEGIN
        RAISERROR('Department ID %d does not exist.', 16, 1, @DepartmentID);
        RETURN;
    END
    
    -- Main query with dynamic sorting
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
        e.BaseSalary,
        d.DepartmentName,
        d.Location,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        CASE 
            WHEN e.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS EmployeeStatus,
        -- Manager information
        ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'No Manager') AS ManagerName,
        -- Performance indicators
        CASE 
            WHEN e.BaseSalary >= 80000 THEN 'Senior Level'
            WHEN e.BaseSalary >= 60000 THEN 'Mid Level'
            WHEN e.BaseSalary >= 40000 THEN 'Junior Level'
            ELSE 'Entry Level'
        END AS SalaryBand,
        -- Employment duration classification
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Veteran (10+ years)'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Experienced (5-9 years)'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Established (2-4 years)'
            ELSE 'New Hire (< 2 years)'
        END AS ServiceCategory
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.EmployeeID
    WHERE (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
      AND (e.IsActive = 1 OR @IncludeInactive = 1)
      AND d.IsActive = 1
    ORDER BY 
        CASE 
            WHEN @SortBy = 'LastName' THEN e.LastName
            WHEN @SortBy = 'FirstName' THEN e.FirstName
            WHEN @SortBy = 'HireDate' THEN CAST(e.HireDate AS VARCHAR)
            WHEN @SortBy = 'Salary' THEN CAST(e.BaseSalary AS VARCHAR)
            ELSE e.LastName
        END,
        e.FirstName;
END;

-- Example executions
EXEC sp_GetDepartmentEmployees @DepartmentID = 2001;  -- IT Department
EXEC sp_GetDepartmentEmployees @DepartmentID = 2002, @SortBy = 'Salary';  -- HR by Salary
EXEC sp_GetDepartmentEmployees @IncludeInactive = 1, @SortBy = 'HireDate';  -- All employees by hire date
```

#### TechCorp Example: Employee Performance Summary
```sql
-- Create comprehensive employee performance analysis procedure
CREATE PROCEDURE sp_GetEmployeePerformanceSummary
    @EmployeeID INT = NULL,
    @DepartmentID INT = NULL,
    @PerformancePeriodMonths INT = 12
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @PerformancePeriodMonths <= 0 OR @PerformancePeriodMonths > 60
    BEGIN
        RAISERROR('Performance period must be between 1 and 60 months.', 16, 1);
        RETURN;
    END
    
    -- Performance analysis query
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        d.Location,
        FORMAT(e.BaseSalary, 'C') AS CurrentSalary,
        -- Project involvement metrics
        ISNULL(project_metrics.ProjectCount, 0) AS ProjectsInvolved,
        ISNULL(project_metrics.TotalProjectHours, 0) AS TotalProjectHours,
        ISNULL(FORMAT(project_metrics.TotalProjectBudget, 'C'), '$0') AS ProjectBudgetManaged,
        -- Customer interaction metrics
        ISNULL(customer_metrics.OrdersProcessed, 0) AS CustomerOrdersProcessed,
        ISNULL(FORMAT(customer_metrics.TotalRevenue, 'C'), '$0') AS CustomerRevenueGenerated,
        ISNULL(customer_metrics.UniqueCustomers, 0) AS UniqueCustomersServed,
        -- Performance calculations
        CASE 
            WHEN ISNULL(project_metrics.TotalProjectHours, 0) >= 500 THEN 'High Project Engagement'
            WHEN ISNULL(project_metrics.TotalProjectHours, 0) >= 200 THEN 'Moderate Project Engagement'
            WHEN ISNULL(project_metrics.TotalProjectHours, 0) > 0 THEN 'Limited Project Engagement'
            ELSE 'No Project Engagement'
        END AS ProjectEngagementLevel,
        CASE 
            WHEN ISNULL(customer_metrics.TotalRevenue, 0) >= 100000 THEN 'High Revenue Generator'
            WHEN ISNULL(customer_metrics.TotalRevenue, 0) >= 50000 THEN 'Moderate Revenue Generator'
            WHEN ISNULL(customer_metrics.TotalRevenue, 0) > 0 THEN 'Revenue Contributor'
            ELSE 'No Direct Revenue'
        END AS RevenueContributionLevel,
        -- Overall performance score calculation
        CAST((
            (CASE WHEN ISNULL(project_metrics.ProjectCount, 0) > 0 THEN 25 ELSE 0 END) +
            (CASE WHEN ISNULL(project_metrics.TotalProjectHours, 0) >= 200 THEN 25 ELSE ISNULL(project_metrics.TotalProjectHours, 0) / 8 END) +
            (CASE WHEN ISNULL(customer_metrics.OrdersProcessed, 0) >= 10 THEN 25 ELSE ISNULL(customer_metrics.OrdersProcessed, 0) * 2.5 END) +
            (CASE WHEN ISNULL(customer_metrics.TotalRevenue, 0) >= 50000 THEN 25 ELSE ISNULL(customer_metrics.TotalRevenue, 0) / 2000 END)
        ) AS DECIMAL(5,2)) AS PerformanceScore,
        -- Performance recommendations
        CASE 
            WHEN ISNULL(project_metrics.ProjectCount, 0) = 0 AND ISNULL(customer_metrics.OrdersProcessed, 0) = 0
                THEN 'Requires immediate performance review and goal setting'
            WHEN ISNULL(project_metrics.TotalProjectHours, 0) < 100 AND ISNULL(customer_metrics.TotalRevenue, 0) < 25000
                THEN 'Consider additional responsibilities and training opportunities'
            WHEN ISNULL(project_metrics.ProjectCount, 0) >= 3 AND ISNULL(customer_metrics.TotalRevenue, 0) >= 75000
                THEN 'Excellent performance - consider for leadership opportunities'
            ELSE 'Solid contributor - continue current trajectory with minor improvements'
        END AS PerformanceRecommendation
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN (
        -- Project involvement aggregation
        SELECT 
            ep.EmployeeID,
            COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
            SUM(ep.HoursWorked) AS TotalProjectHours,
            SUM(p.Budget) AS TotalProjectBudget
        FROM EmployeeProjects ep
        INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
        WHERE ep.IsActive = 1
          AND p.IsActive = 1
          AND ep.StartDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE())
        GROUP BY ep.EmployeeID
    ) project_metrics ON e.EmployeeID = project_metrics.EmployeeID
    LEFT JOIN (
        -- Customer interaction aggregation
        SELECT 
            o.EmployeeID,
            COUNT(o.OrderID) AS OrdersProcessed,
            SUM(o.TotalAmount) AS TotalRevenue,
            COUNT(DISTINCT o.CustomerID) AS UniqueCustomers
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE())
        GROUP BY o.EmployeeID
    ) customer_metrics ON e.EmployeeID = customer_metrics.EmployeeID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND (@EmployeeID IS NULL OR e.EmployeeID = @EmployeeID)
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
    ORDER BY PerformanceScore DESC, e.LastName, e.FirstName;
END;

-- Example executions
EXEC sp_GetEmployeePerformanceSummary @EmployeeID = 3001;  -- Specific employee
EXEC sp_GetEmployeePerformanceSummary @DepartmentID = 2001, @PerformancePeriodMonths = 6;  -- IT Dept, 6 months
EXEC sp_GetEmployeePerformanceSummary @PerformancePeriodMonths = 24;  -- All employees, 2 years
```

### 2. Financial and Business Analysis

#### TechCorp Example: Department Financial Analysis
```sql
-- Create comprehensive department financial analysis procedure
CREATE PROCEDURE sp_GetDepartmentFinancialAnalysis
    @DepartmentID INT = NULL,
    @AnalysisPeriodMonths INT = 12,
    @IncludeBudgetVariance BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @AnalysisPeriodMonths <= 0 OR @AnalysisPeriodMonths > 120
    BEGIN
        RAISERROR('Analysis period must be between 1 and 120 months.', 16, 1);
        RETURN;
    END
    
    -- Financial analysis query
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Location,
        FORMAT(d.Budget, 'C') AS AllocatedBudget,
        -- Employee cost analysis
        employee_costs.ActiveEmployeeCount,
        FORMAT(employee_costs.TotalSalaryCost, 'C') AS TotalSalaryCost,
        FORMAT(employee_costs.AverageSalary, 'C') AS AverageSalary,
        -- Project financial metrics
        ISNULL(project_financials.ActiveProjectCount, 0) AS ActiveProjectCount,
        ISNULL(FORMAT(project_financials.TotalProjectBudget, 'C'), '$0') AS TotalProjectBudget,
        ISNULL(FORMAT(project_financials.AverageProjectBudget, 'C'), '$0') AS AverageProjectBudget,
        -- Revenue generation metrics
        ISNULL(revenue_metrics.TotalRevenue, 0) AS TotalRevenueGenerated,
        ISNULL(FORMAT(revenue_metrics.TotalRevenue, 'C'), '$0') AS FormattedTotalRevenue,
        ISNULL(revenue_metrics.OrderCount, 0) AS TotalOrdersProcessed,
        ISNULL(revenue_metrics.UniqueCustomerCount, 0) AS UniqueCustomersServed,
        -- Financial ratios and analysis
        CASE 
            WHEN @IncludeBudgetVariance = 1 AND d.Budget > 0 THEN
                CAST((employee_costs.TotalSalaryCost * 100.0 / d.Budget) AS DECIMAL(5,2))
            ELSE NULL
        END AS SalaryBudgetUtilizationPercent,
        CASE 
            WHEN employee_costs.TotalSalaryCost > 0 THEN
                CAST((ISNULL(revenue_metrics.TotalRevenue, 0) * 1.0 / employee_costs.TotalSalaryCost) AS DECIMAL(5,2))
            ELSE 0
        END AS RevenueToSalaryRatio,
        CASE 
            WHEN employee_costs.ActiveEmployeeCount > 0 THEN
                FORMAT((ISNULL(revenue_metrics.TotalRevenue, 0) / employee_costs.ActiveEmployeeCount), 'C')
            ELSE '$0'
        END AS RevenuePerEmployee,
        -- Performance classifications
        CASE 
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) / NULLIF(employee_costs.TotalSalaryCost, 0) >= 3.0 
                THEN 'Highly Profitable'
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) / NULLIF(employee_costs.TotalSalaryCost, 0) >= 2.0 
                THEN 'Profitable'
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) / NULLIF(employee_costs.TotalSalaryCost, 0) >= 1.0 
                THEN 'Break Even'
            ELSE 'Cost Center'
        END AS ProfitabilityClassification,
        CASE 
            WHEN @IncludeBudgetVariance = 1 THEN
                CASE 
                    WHEN (employee_costs.TotalSalaryCost * 100.0 / NULLIF(d.Budget, 0)) > 95 
                        THEN 'Over Budget Risk'
                    WHEN (employee_costs.TotalSalaryCost * 100.0 / NULLIF(d.Budget, 0)) > 85 
                        THEN 'High Utilization'
                    WHEN (employee_costs.TotalSalaryCost * 100.0 / NULLIF(d.Budget, 0)) > 70 
                        THEN 'Good Utilization'
                    ELSE 'Under Utilized'
                END
            ELSE 'Budget Analysis Disabled'
        END AS BudgetStatus,
        -- Strategic recommendations
        CASE 
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) = 0 AND employee_costs.TotalSalaryCost > 200000
                THEN 'Critical: High cost department with no revenue - requires strategic review'
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) / NULLIF(employee_costs.TotalSalaryCost, 0) >= 4.0
                THEN 'Excellent ROI - consider expansion and investment'
            WHEN employee_costs.ActiveEmployeeCount < 3 AND ISNULL(project_financials.ActiveProjectCount, 0) = 0
                THEN 'Small department with low activity - evaluate necessity'
            WHEN (employee_costs.TotalSalaryCost * 100.0 / NULLIF(d.Budget, 0)) < 60
                THEN 'Under-utilized budget - opportunity for growth or reallocation'
            ELSE 'Department performing within normal parameters'
        END AS StrategicRecommendation
    FROM Departments d
    INNER JOIN (
        -- Employee cost aggregation
        SELECT 
            e.DepartmentID,
            COUNT(*) AS ActiveEmployeeCount,
            SUM(e.BaseSalary) AS TotalSalaryCost,
            AVG(e.BaseSalary) AS AverageSalary
        FROM Employees e
        WHERE e.IsActive = 1
        GROUP BY e.DepartmentID
    ) employee_costs ON d.DepartmentID = employee_costs.DepartmentID
    LEFT JOIN (
        -- Project financial aggregation
        SELECT 
            e.DepartmentID,
            COUNT(DISTINCT p.ProjectID) AS ActiveProjectCount,
            SUM(p.Budget) AS TotalProjectBudget,
            AVG(p.Budget) AS AverageProjectBudget
        FROM Projects p
        INNER JOIN Employees e ON p.ProjectManagerID = e.EmployeeID
        WHERE p.IsActive = 1
          AND e.IsActive = 1
          AND p.StartDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
        GROUP BY e.DepartmentID
    ) project_financials ON d.DepartmentID = project_financials.DepartmentID
    LEFT JOIN (
        -- Revenue generation aggregation
        SELECT 
            e.DepartmentID,
            SUM(o.TotalAmount) AS TotalRevenue,
            COUNT(o.OrderID) AS OrderCount,
            COUNT(DISTINCT o.CustomerID) AS UniqueCustomerCount
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        WHERE o.IsActive = 1
          AND e.IsActive = 1
          AND o.OrderDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
        GROUP BY e.DepartmentID
    ) revenue_metrics ON d.DepartmentID = revenue_metrics.DepartmentID
    WHERE d.IsActive = 1
      AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    ORDER BY 
        CASE 
            WHEN ISNULL(revenue_metrics.TotalRevenue, 0) > 0 
            THEN ISNULL(revenue_metrics.TotalRevenue, 0) / NULLIF(employee_costs.TotalSalaryCost, 0)
            ELSE 0
        END DESC,
        d.DepartmentName;
END;

-- Example executions
EXEC sp_GetDepartmentFinancialAnalysis @DepartmentID = 2001;  -- IT Department analysis
EXEC sp_GetDepartmentFinancialAnalysis @AnalysisPeriodMonths = 6, @IncludeBudgetVariance = 1;  -- All departments, 6 months
EXEC sp_GetDepartmentFinancialAnalysis @AnalysisPeriodMonths = 24, @IncludeBudgetVariance = 0;  -- 2-year analysis without budget comparison
```

### 3. Customer and Sales Analysis

#### TechCorp Example: Customer Relationship Analysis
```sql
-- Create comprehensive customer relationship analysis procedure
CREATE PROCEDURE sp_GetCustomerRelationshipAnalysis
    @CustomerID INT = NULL,
    @Country VARCHAR(50) = NULL,
    @MinimumOrderValue DECIMAL(10,2) = 0,
    @AnalysisPeriodMonths INT = 12
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @MinimumOrderValue < 0
    BEGIN
        RAISERROR('Minimum order value cannot be negative.', 16, 1);
        RETURN;
    END
    
    IF @AnalysisPeriodMonths <= 0 OR @AnalysisPeriodMonths > 120
    BEGIN
        RAISERROR('Analysis period must be between 1 and 120 months.', 16, 1);
        RETURN;
    END
    
    -- Customer relationship analysis query
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.City,
        c.Country,
        c.WorkEmail,
        -- Order activity metrics
        ISNULL(order_metrics.TotalOrders, 0) AS TotalOrders,
        ISNULL(FORMAT(order_metrics.TotalOrderValue, 'C'), '$0') AS TotalOrderValue,
        ISNULL(FORMAT(order_metrics.AverageOrderValue, 'C'), '$0') AS AverageOrderValue,
        ISNULL(FORMAT(order_metrics.MinOrderValue, 'C'), '$0') AS MinimumOrderValue,
        ISNULL(FORMAT(order_metrics.MaxOrderValue, 'C'), '$0') AS MaximumOrderValue,
        -- Relationship timeline
        order_metrics.FirstOrderDate,
        order_metrics.LastOrderDate,
        ISNULL(DATEDIFF(DAY, order_metrics.FirstOrderDate, order_metrics.LastOrderDate), 0) AS RelationshipDurationDays,
        CASE 
            WHEN order_metrics.TotalOrders > 1 AND order_metrics.FirstOrderDate IS NOT NULL AND order_metrics.LastOrderDate IS NOT NULL
            THEN DATEDIFF(DAY, order_metrics.FirstOrderDate, order_metrics.LastOrderDate) / (order_metrics.TotalOrders - 1)
            ELSE NULL
        END AS AverageOrderFrequencyDays,
        -- Employee interaction analysis
        ISNULL(employee_interaction.UniqueEmployeesServed, 0) AS UniqueEmployeesServed,
        ISNULL(employee_interaction.PrimaryContactEmployee, 'No Primary Contact') AS PrimaryContactEmployee,
        ISNULL(employee_interaction.PrimaryContactDepartment, 'No Department') AS PrimaryContactDepartment,
        -- Customer classification
        CASE 
            WHEN ISNULL(order_metrics.TotalOrderValue, 0) >= 100000 THEN 'Premium Customer'
            WHEN ISNULL(order_metrics.TotalOrderValue, 0) >= 50000 THEN 'High Value Customer'
            WHEN ISNULL(order_metrics.TotalOrderValue, 0) >= 20000 THEN 'Standard Customer'
            WHEN ISNULL(order_metrics.TotalOrderValue, 0) >= 5000 THEN 'Developing Customer'
            WHEN ISNULL(order_metrics.TotalOrderValue, 0) > 0 THEN 'New Customer'
            ELSE 'Inactive Customer'
        END AS CustomerClassification,
        CASE 
            WHEN order_metrics.LastOrderDate >= DATEADD(MONTH, -3, GETDATE()) THEN 'Active'
            WHEN order_metrics.LastOrderDate >= DATEADD(MONTH, -6, GETDATE()) THEN 'Recently Active'
            WHEN order_metrics.LastOrderDate >= DATEADD(MONTH, -12, GETDATE()) THEN 'Dormant'
            WHEN order_metrics.LastOrderDate IS NOT NULL THEN 'Inactive'
            ELSE 'No Orders'
        END AS ActivityStatus,
        -- Business potential analysis
        CASE 
            WHEN ISNULL(order_metrics.TotalOrders, 0) >= 20 AND ISNULL(order_metrics.TotalOrderValue, 0) >= 75000
                THEN 'Strategic Account - Maintain and Expand'
            WHEN ISNULL(order_metrics.TotalOrders, 0) >= 10 AND order_metrics.LastOrderDate >= DATEADD(MONTH, -6, GETDATE())
                THEN 'Growing Relationship - Nurture and Develop'
            WHEN ISNULL(order_metrics.TotalOrders, 0) = 1 AND order_metrics.LastOrderDate >= DATEADD(MONTH, -3, GETDATE())
                THEN 'New Customer - Follow Up Required'
            WHEN order_metrics.LastOrderDate < DATEADD(MONTH, -6, GETDATE()) AND ISNULL(order_metrics.TotalOrderValue, 0) > 10000
                THEN 'Re-engagement Opportunity'
            WHEN ISNULL(order_metrics.TotalOrders, 0) = 0
                THEN 'Prospect - No Purchase History'
            ELSE 'Standard Maintenance Required'
        END AS AccountManagementStrategy,
        -- Risk assessment
        CASE 
            WHEN order_metrics.LastOrderDate < DATEADD(MONTH, -12, GETDATE()) AND ISNULL(order_metrics.TotalOrderValue, 0) > 25000
                THEN 'High Risk - Valuable Customer Gone Inactive'
            WHEN ISNULL(order_metrics.TotalOrders, 0) = 1 AND order_metrics.LastOrderDate < DATEADD(MONTH, -6, GETDATE())
                THEN 'Medium Risk - Single Purchase, No Follow-up'
            WHEN order_metrics.LastOrderDate >= DATEADD(MONTH, -3, GETDATE()) AND ISNULL(order_metrics.TotalOrderValue, 0) >= 50000
                THEN 'Low Risk - Active High Value Customer'
            ELSE 'Standard Risk Level'
        END AS RiskAssessment
    FROM Customers c
    LEFT JOIN (
        -- Order metrics aggregation
        SELECT 
            o.CustomerID,
            COUNT(o.OrderID) AS TotalOrders,
            SUM(o.TotalAmount) AS TotalOrderValue,
            AVG(o.TotalAmount) AS AverageOrderValue,
            MIN(o.TotalAmount) AS MinOrderValue,
            MAX(o.TotalAmount) AS MaxOrderValue,
            MIN(o.OrderDate) AS FirstOrderDate,
            MAX(o.OrderDate) AS LastOrderDate
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
          AND o.TotalAmount >= @MinimumOrderValue
        GROUP BY o.CustomerID
    ) order_metrics ON c.CustomerID = order_metrics.CustomerID
    LEFT JOIN (
        -- Employee interaction aggregation
        SELECT 
            o.CustomerID,
            COUNT(DISTINCT o.EmployeeID) AS UniqueEmployeesServed,
            (SELECT TOP 1 e.FirstName + ' ' + e.LastName
             FROM Orders o2 
             INNER JOIN Employees e ON o2.EmployeeID = e.EmployeeID
             WHERE o2.CustomerID = o.CustomerID 
               AND o2.IsActive = 1
               AND e.IsActive = 1
             GROUP BY e.EmployeeID, e.FirstName, e.LastName
             ORDER BY COUNT(*) DESC) AS PrimaryContactEmployee,
            (SELECT TOP 1 d.DepartmentName
             FROM Orders o2 
             INNER JOIN Employees e ON o2.EmployeeID = e.EmployeeID
             INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
             WHERE o2.CustomerID = o.CustomerID 
               AND o2.IsActive = 1
               AND e.IsActive = 1
               AND d.IsActive = 1
             GROUP BY d.DepartmentName
             ORDER BY COUNT(*) DESC) AS PrimaryContactDepartment
        FROM Orders o
        WHERE o.IsActive = 1
          AND o.OrderDate >= DATEADD(MONTH, -@AnalysisPeriodMonths, GETDATE())
        GROUP BY o.CustomerID
    ) employee_interaction ON c.CustomerID = employee_interaction.CustomerID
    WHERE c.IsActive = 1
      AND (@CustomerID IS NULL OR c.CustomerID = @CustomerID)
      AND (@Country IS NULL OR c.Country = @Country)
      AND (order_metrics.TotalOrderValue IS NULL OR order_metrics.TotalOrderValue >= @MinimumOrderValue)
    ORDER BY 
        ISNULL(order_metrics.TotalOrderValue, 0) DESC,
        order_metrics.LastOrderDate DESC,
        c.CompanyName;
END;

-- Example executions
EXEC sp_GetCustomerRelationshipAnalysis @CustomerID = 6001;  -- Specific customer analysis
EXEC sp_GetCustomerRelationshipAnalysis @Country = 'USA', @MinimumOrderValue = 5000;  -- US customers with significant orders
EXEC sp_GetCustomerRelationshipAnalysis @AnalysisPeriodMonths = 6, @MinimumOrderValue = 1000;  -- Recent 6 months, orders above $1000
```

## Executing and Managing Stored Procedures

### 1. Basic Execution Patterns

#### Different Ways to Execute Stored Procedures
```sql
-- Method 1: Named parameters (recommended for clarity)
EXEC sp_GetDepartmentEmployees 
    @DepartmentID = 2001, 
    @IncludeInactive = 0, 
    @SortBy = 'Salary';

-- Method 2: Positional parameters (must match parameter order)
EXEC sp_GetDepartmentEmployees 2001, 0, 'Salary';

-- Method 3: Mixed approach (named after positional)
EXEC sp_GetDepartmentEmployees 2001, @SortBy = 'LastName';

-- Method 4: Using DEFAULT values
EXEC sp_GetDepartmentEmployees @DepartmentID = 2002;  -- Uses defaults for other parameters

-- Method 5: Using EXECUTE instead of EXEC
EXECUTE sp_GetEmployeePerformanceSummary @DepartmentID = 2001, @PerformancePeriodMonths = 6;
```

### 2. Error Handling and Validation

#### Stored Procedure Error Handling Examples
```sql
-- Example: Robust stored procedure with comprehensive error handling
CREATE PROCEDURE sp_GetEmployeeDetailsWithValidation
    @EmployeeID INT,
    @IncludeProjectDetails BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Error handling setup
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    
    BEGIN TRY
        -- Input validation
        IF @EmployeeID IS NULL OR @EmployeeID <= 0
        BEGIN
            RAISERROR('Employee ID must be a positive integer.', 16, 1);
            RETURN;
        END
        
        -- Check if employee exists
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            RAISERROR('Employee ID %d does not exist in the system.', 16, 1, @EmployeeID);
            RETURN;
        END
        
        -- Main query execution
        SELECT 
            e.EmployeeID,
            e.FirstName + ' ' + e.LastName AS EmployeeName,
            e.JobTitle,
            d.DepartmentName,
            d.Location,
            FORMAT(e.BaseSalary, 'C') AS Salary,
            e.WorkEmail,
            e.HireDate,
            DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
            -- Conditional project details
            CASE 
                WHEN @IncludeProjectDetails = 1 THEN ISNULL(project_summary.ProjectCount, 0)
                ELSE NULL
            END AS ProjectCount,
            CASE 
                WHEN @IncludeProjectDetails = 1 THEN ISNULL(project_summary.TotalHours, 0)
                ELSE NULL
            END AS TotalProjectHours
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN (
            SELECT 
                ep.EmployeeID,
                COUNT(DISTINCT ep.ProjectID) AS ProjectCount,
                SUM(ep.HoursWorked) AS TotalHours
            FROM EmployeeProjects ep
            WHERE ep.IsActive = 1 AND @IncludeProjectDetails = 1
            GROUP BY ep.EmployeeID
        ) project_summary ON e.EmployeeID = project_summary.EmployeeID
        WHERE e.EmployeeID = @EmployeeID
          AND e.IsActive = 1
          AND d.IsActive = 1;
          
        -- Success message
        PRINT 'Employee details retrieved successfully for Employee ID: ' + CAST(@EmployeeID AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        -- Error information capture
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
            
        -- Log error (in real implementation, this would go to an error log table)
        PRINT 'ERROR in sp_GetEmployeeDetailsWithValidation:';
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS VARCHAR);
        PRINT 'Error State: ' + CAST(@ErrorState AS VARCHAR);
        
        -- Re-raise the error
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

-- Testing error handling
EXEC sp_GetEmployeeDetailsWithValidation @EmployeeID = NULL;  -- Should raise parameter error
EXEC sp_GetEmployeeDetailsWithValidation @EmployeeID = 99999;  -- Should raise not found error
EXEC sp_GetEmployeeDetailsWithValidation @EmployeeID = 3001, @IncludeProjectDetails = 1;  -- Should succeed
```

### 3. Performance Monitoring and Optimization

#### Monitoring Stored Procedure Performance
```sql
-- Query to analyze stored procedure performance
SELECT 
    p.name AS ProcedureName,
    s.execution_count AS ExecutionCount,
    s.total_elapsed_time / 1000 AS TotalElapsedTimeMS,
    s.avg_elapsed_time / 1000 AS AvgElapsedTimeMS,
    s.min_elapsed_time / 1000 AS MinElapsedTimeMS,
    s.max_elapsed_time / 1000 AS MaxElapsedTimeMS,
    s.total_logical_reads AS TotalLogicalReads,
    s.avg_logical_reads AS AvgLogicalReads,
    s.last_execution_time AS LastExecutionTime,
    -- Performance classification
    CASE 
        WHEN s.avg_elapsed_time / 1000 > 5000 THEN 'Slow (>5 seconds)'
        WHEN s.avg_elapsed_time / 1000 > 1000 THEN 'Moderate (1-5 seconds)'
        ELSE 'Fast (<1 second)'
    END AS PerformanceClassification
FROM sys.procedures p
INNER JOIN sys.dm_exec_procedure_stats s ON p.object_id = s.object_id
WHERE p.name LIKE 'sp_Get%'  -- Filter for our TechCorp procedures
ORDER BY s.avg_elapsed_time DESC;

-- Clear procedure cache for testing (use with caution in production)
-- DBCC FREEPROCCACHE;
```

## Best Practices for Querying with Stored Procedures

### 1. Parameter Usage and Validation

```sql
-- ✅ GOOD: Proper parameter validation and default values
CREATE PROCEDURE sp_GetEmployeeReportGood
    @DepartmentID INT = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @MaxResults INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate parameters
    IF @MaxResults <= 0 OR @MaxResults > 1000
    BEGIN
        RAISERROR('MaxResults must be between 1 and 1000.', 16, 1);
        RETURN;
    END
    
    IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate > @EndDate
    BEGIN
        RAISERROR('Start date cannot be greater than end date.', 16, 1);
        RETURN;
    END
    
    -- Set defaults
    SET @StartDate = ISNULL(@StartDate, DATEADD(YEAR, -1, GETDATE()));
    SET @EndDate = ISNULL(@EndDate, GETDATE());
    
    -- Main query with proper filtering
    SELECT TOP (@MaxResults)
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.HireDate
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.IsActive = 1
      AND d.IsActive = 1
      AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
      AND e.HireDate BETWEEN @StartDate AND @EndDate
    ORDER BY e.HireDate DESC;
END;
```

### 2. Result Set Consistency

```sql
-- ✅ GOOD: Consistent result set structure
CREATE PROCEDURE sp_GetDepartmentSummaryConsistent
    @IncludeEmpty BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        d.Location,
        ISNULL(emp_count.EmployeeCount, 0) AS EmployeeCount,
        ISNULL(FORMAT(emp_count.TotalSalary, 'C'), '$0') AS TotalSalary,
        CASE 
            WHEN ISNULL(emp_count.EmployeeCount, 0) = 0 THEN 'Empty Department'
            WHEN ISNULL(emp_count.EmployeeCount, 0) < 5 THEN 'Small Department'
            WHEN ISNULL(emp_count.EmployeeCount, 0) < 15 THEN 'Medium Department'
            ELSE 'Large Department'
        END AS SizeCategory
    FROM Departments d
    LEFT JOIN (
        SELECT 
            e.DepartmentID,
            COUNT(*) AS EmployeeCount,
            SUM(e.BaseSalary) AS TotalSalary
        FROM Employees e
        WHERE e.IsActive = 1
        GROUP BY e.DepartmentID
    ) emp_count ON d.DepartmentID = emp_count.DepartmentID
    WHERE d.IsActive = 1
      AND (@IncludeEmpty = 1 OR emp_count.EmployeeCount > 0)
    ORDER BY d.DepartmentName;
END;
```

## Summary

Querying data with stored procedures provides TechCorp with powerful enterprise capabilities:

**Key Benefits:**
- **Performance**: Pre-compiled execution plans for optimal query performance
- **Security**: Parameterized execution prevents SQL injection attacks
- **Consistency**: Standardized data access patterns across applications
- **Maintainability**: Centralized business logic and easy modification
- **Reusability**: Modular database functionality for multiple applications

**Business Applications:**
- Employee performance analysis and reporting
- Financial analysis and budget monitoring
- Customer relationship management and analysis
- Department operational metrics and KPIs
- Executive dashboard data provisioning

**Technical Advantages:**
- Optimized query execution with cached plans
- Reduced network traffic through server-side processing
- Enhanced security through controlled data access
- Simplified application development with database APIs
- Centralized business rule enforcement

**Best Practices:**
- Implement comprehensive parameter validation
- Use proper error handling and logging
- Maintain consistent result set structures
- Monitor performance and optimize regularly
- Document procedure functionality and usage

Stored procedures enable TechCorp to create robust, scalable, and secure data access layers that support enterprise applications, business intelligence systems, and operational reporting requirements while maintaining high performance and data integrity standards.