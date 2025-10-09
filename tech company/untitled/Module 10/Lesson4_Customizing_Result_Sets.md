
# Lesson 4: Making Your Results Look Just Right (Beginner Friendly)

## What You’ll Learn (In Plain English)

- How to make your results look neat and tidy
- How to show or hide columns based on who’s looking
- How to add simple “traffic lights” or icons to your results
- How to make your tables easy to read for everyone

## 4.1 What Does “Customizing Results” Mean? (Like Setting Up a Table for Guests)

Imagine you’re setting a table for dinner. You might use different plates for kids and adults, or add name cards for a party. Customizing results in SQL is just like that—you make your data look right for whoever is reading it!

### Dynamic Column Selection

```sql
-- Dynamically customize columns based on user role
DECLARE @UserRole VARCHAR(20) = 'Manager'; -- 'Executive', 'Manager', 'Employee'

SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    
    -- Role-based conditional columns
    CASE WHEN @UserRole IN ('Executive', 'Manager') 
         THEN FORMAT(e.BaseSalary, 'C0') 
         ELSE 'Confidential' 
    END AS Salary,
    
    CASE WHEN @UserRole = 'Executive'
         THEN FORMAT(e.BaseSalary * 0.15, 'C0')
         ELSE NULL
    END AS EstimatedBenefits,
    
    d.DepartmentName,
    e.JobTitle,
    
    -- Always visible columns
    FORMAT(e.HireDate, 'MMM dd, yyyy') AS HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService
    
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.LastName;
```

### Conditional Result Formatting

```sql
-- Advanced conditional formatting with status indicators
WITH EmployeeAnalysis AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.BaseSalary,
        e.HireDate,
        d.DepartmentName,
        e.JobTitle,
        
        -- Performance indicators
        CASE 
            WHEN e.BaseSalary >= 100000 THEN 'High Performer'
            WHEN e.BaseSalary >= 75000 THEN 'Strong Performer'  
            WHEN e.BaseSalary >= 50000 THEN 'Standard Performer'
            ELSE 'Entry Level'
        END AS PerformanceLevel,
        
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS Tenure,
        
        -- Risk indicators
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 15 THEN 'Retirement Risk'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 1 THEN 'New Hire'
            WHEN e.BaseSalary < (SELECT AVG(BaseSalary) * 0.8 FROM Employees WHERE DepartmentID = e.DepartmentID) THEN 'Flight Risk'
            ELSE 'Stable'
        END AS RiskCategory
        
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
)
SELECT 
    EmployeeName,
    DepartmentName,
    JobTitle,
    
    -- Formatted performance with visual indicators
    CASE PerformanceLevel
        WHEN 'High Performer' THEN '🌟 ' + PerformanceLevel
        WHEN 'Strong Performer' THEN '⭐ ' + PerformanceLevel
        WHEN 'Standard Performer' THEN '✓ ' + PerformanceLevel
        ELSE '📈 ' + PerformanceLevel
    END AS PerformanceStatus,
    
    -- Risk assessment with color coding suggestions
    CASE RiskCategory
        WHEN 'Retirement Risk' THEN '🕐 ' + RiskCategory + ' (Plan Succession)'
        WHEN 'New Hire' THEN '🆕 ' + RiskCategory + ' (Monitor Progress)'
        WHEN 'Flight Risk' THEN '⚠️ ' + RiskCategory + ' (Review Compensation)'
        ELSE '✅ ' + RiskCategory
    END AS RiskAssessment,
    
    FORMAT(BaseSalary, 'C0') AS CurrentSalary,
    CAST(Tenure AS VARCHAR) + ' years' AS ServiceYears
    
FROM EmployeeAnalysis
ORDER BY 
    CASE PerformanceLevel 
        WHEN 'High Performer' THEN 1
        WHEN 'Strong Performer' THEN 2
        WHEN 'Standard Performer' THEN 3
        ELSE 4
    END,
    EmployeeName;
```

## 4.2 Responsive Layout Design

### Multi-Column Layout Simulation

```sql
-- Create newspaper-style column layout
WITH ProjectSummary AS (
    SELECT 
        p.ProjectName,
        p.Status,
        FORMAT(p.Budget, 'C0') AS Budget,
        c.CompanyName AS Client,
        ROW_NUMBER() OVER (ORDER BY p.Budget DESC) AS RowNum
    FROM Projects p
    LEFT JOIN Companies c ON p.CompanyID = c.CompanyID
),
ColumnLayout AS (
    SELECT 
        RowNum,
        ProjectName,
        Status,
        Budget,
        Client,
        CASE (RowNum - 1) % 3 
            WHEN 0 THEN 'Column1'
            WHEN 1 THEN 'Column2'
            ELSE 'Column3'
        END AS ColumnPosition,
        CEILING(RowNum / 3.0) AS RowGroup
    FROM ProjectSummary
)
SELECT 
    'Row ' + CAST(RowGroup AS VARCHAR) AS LayoutRow,
    
    MAX(CASE WHEN ColumnPosition = 'Column1' 
        THEN LEFT(ProjectName + SPACE(25), 25) + Status 
        ELSE '' END) AS LeftColumn,
        
    MAX(CASE WHEN ColumnPosition = 'Column2' 
        THEN LEFT(ProjectName + SPACE(25), 25) + Status 
        ELSE '' END) AS MiddleColumn,
        
    MAX(CASE WHEN ColumnPosition = 'Column3' 
        THEN LEFT(ProjectName + SPACE(25), 25) + Status 
        ELSE '' END) AS RightColumn
        
FROM ColumnLayout
GROUP BY RowGroup
ORDER BY RowGroup;
```

### Adaptive Width Tables

```sql
-- Table with adaptive column widths based on content
WITH ContentAnalysis AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C0') AS Salary,
        
        -- Calculate required column widths
        LEN(e.FirstName + ' ' + e.LastName) AS NameLength,
        LEN(d.DepartmentName) AS DeptLength,
        LEN(e.JobTitle) AS TitleLength
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
),
ColumnWidths AS (
    SELECT 
        MAX(NameLength) AS MaxNameWidth,
        MAX(DeptLength) AS MaxDeptWidth,
        MAX(TitleLength) AS MaxTitleWidth
    FROM ContentAnalysis
)
SELECT 
    '┌' + REPLICATE('─', w.MaxNameWidth + 2) + 
    '┬' + REPLICATE('─', w.MaxDeptWidth + 2) + 
    '┬' + REPLICATE('─', w.MaxTitleWidth + 2) + 
    '┬' + REPLICATE('─', 12) + '┐' AS TableBorder
FROM ColumnWidths w

UNION ALL

SELECT 
    '│ ' + LEFT(ca.EmployeeName + SPACE(w.MaxNameWidth), w.MaxNameWidth) + 
    ' │ ' + LEFT(ca.DepartmentName + SPACE(w.MaxDeptWidth), w.MaxDeptWidth) + 
    ' │ ' + LEFT(ca.JobTitle + SPACE(w.MaxTitleWidth), w.MaxTitleWidth) + 
    ' │ ' + RIGHT(SPACE(10) + ca.Salary, 10) + ' │'
FROM ContentAnalysis ca
CROSS JOIN ColumnWidths w

UNION ALL

SELECT 
    '└' + REPLICATE('─', w.MaxNameWidth + 2) + 
    '┴' + REPLICATE('─', w.MaxDeptWidth + 2) + 
    '┴' + REPLICATE('─', w.MaxTitleWidth + 2) + 
    '┴' + REPLICATE('─', 12) + '┘'
FROM ColumnWidths w;
```

## 4.3 Interactive Result Navigation

### Pagination Simulation

```sql
-- Simulate result pagination
DECLARE @PageSize INT = 10;
DECLARE @PageNumber INT = 1;

WITH PaginatedResults AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNumber,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C0') AS Salary
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
),
PageInfo AS (
    SELECT 
        COUNT(*) AS TotalRecords,
        CEILING(COUNT(*) / CAST(@PageSize AS FLOAT)) AS TotalPages,
        @PageNumber AS CurrentPage,
        (@PageNumber - 1) * @PageSize + 1 AS StartRecord,
        MIN(@PageNumber * @PageSize, COUNT(*)) AS EndRecord
    FROM PaginatedResults
)
SELECT 
    '📄 PAGE ' + CAST(pi.CurrentPage AS VARCHAR) + ' OF ' + CAST(pi.TotalPages AS VARCHAR) + 
    ' (Records ' + CAST(pi.StartRecord AS VARCHAR) + '-' + CAST(pi.EndRecord AS VARCHAR) + 
    ' of ' + CAST(pi.TotalRecords AS VARCHAR) + ')' AS PageHeader
FROM PageInfo pi

UNION ALL

SELECT REPLICATE('═', 80)

UNION ALL

SELECT 
    LEFT(CAST(pr.RowNumber AS VARCHAR) + '. ' + pr.EmployeeName + SPACE(35), 35) +
    LEFT(pr.DepartmentName + SPACE(20), 20) +
    LEFT(pr.JobTitle + SPACE(25), 25) +
    pr.Salary
FROM PaginatedResults pr
CROSS JOIN PageInfo pi
WHERE pr.RowNumber BETWEEN pi.StartRecord AND pi.EndRecord;
```

### Search Result Highlighting

```sql
-- Highlight search terms in results
DECLARE @SearchTerm VARCHAR(50) = 'Manager';

WITH SearchResults AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        e.JobTitle,
        d.DepartmentName,
        
        -- Highlight matching terms
        CASE 
            WHEN CHARINDEX(@SearchTerm, e.JobTitle) > 0 THEN 
                REPLACE(e.JobTitle, @SearchTerm, '>>> ' + @SearchTerm + ' <<<')
            ELSE e.JobTitle
        END AS HighlightedTitle,
        
        CASE 
            WHEN CHARINDEX(@SearchTerm, d.DepartmentName) > 0 THEN 
                REPLACE(d.DepartmentName, @SearchTerm, '>>> ' + @SearchTerm + ' <<<')
            ELSE d.DepartmentName
        END AS HighlightedDepartment,
        
        -- Relevance scoring
        (CASE WHEN CHARINDEX(@SearchTerm, e.JobTitle) > 0 THEN 2 ELSE 0 END +
         CASE WHEN CHARINDEX(@SearchTerm, d.DepartmentName) > 0 THEN 1 ELSE 0 END +
         CASE WHEN CHARINDEX(@SearchTerm, e.FirstName + ' ' + e.LastName) > 0 THEN 1 ELSE 0 END) AS RelevanceScore
        
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE 
        CHARINDEX(@SearchTerm, e.JobTitle) > 0 OR
        CHARINDEX(@SearchTerm, d.DepartmentName) > 0 OR
        CHARINDEX(@SearchTerm, e.FirstName + ' ' + e.LastName) > 0
)
SELECT 
    '🔍 Search Results for: "' + @SearchTerm + '"' AS SearchHeader
UNION ALL
SELECT REPLICATE('─', 60)
UNION ALL
SELECT 
    '⭐'.repeat(RelevanceScore) + ' ' +
    EmployeeName + ' | ' + 
    HighlightedTitle + ' | ' + 
    HighlightedDepartment
FROM SearchResults
ORDER BY RelevanceScore DESC;
```

## 4.4 Theme-Based Result Styling

### Professional Business Theme

```sql
-- Professional business report theme
WITH BusinessReport AS (
    SELECT 
        d.DepartmentName,
        COUNT(e.EmployeeID) AS HeadCount,
        FORMAT(AVG(e.BaseSalary), 'C0') AS AvgSalary,
        FORMAT(SUM(e.BaseSalary), 'C0') AS TotalPayroll,
        COUNT(p.ProjectID) AS ActiveProjects
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID AND p.Status = 'In Progress'
    GROUP BY d.DepartmentName, d.DepartmentID
)
SELECT 
    '╔══════════════════════════════════════════════════════════════════════════╗' AS ReportFrame
UNION ALL
SELECT '║                          TECHCORP SOLUTIONS                              ║'
UNION ALL
SELECT '║                      DEPARTMENT ANALYSIS REPORT                          ║'
UNION ALL
SELECT '║                        ' + FORMAT(GETDATE(), 'MMMM dd, yyyy') + '                               ║'
UNION ALL
SELECT '╠══════════════════════════════════════════════════════════════════════════╣'
UNION ALL
SELECT '║                                                                          ║'
UNION ALL
SELECT 
    '║ ' + LEFT(DepartmentName + SPACE(18), 18) + 
    '│ Staff: ' + RIGHT(SPACE(3) + CAST(HeadCount AS VARCHAR), 3) + 
    '│ Avg: ' + RIGHT(SPACE(8) + AvgSalary, 8) + 
    '│ Projects: ' + RIGHT(SPACE(2) + CAST(ActiveProjects AS VARCHAR), 2) + ' ║'
FROM BusinessReport
UNION ALL
SELECT '║                                                                          ║'
UNION ALL
SELECT '╚══════════════════════════════════════════════════════════════════════════╝';
```

### Dashboard Theme with Metrics

```sql
-- Dashboard-style metrics display
WITH DashboardMetrics AS (
    SELECT 
        'Employees' AS MetricName,
        COUNT(*) AS MetricValue,
        'people' AS Unit,
        '👥' AS Icon,
        CASE 
            WHEN COUNT(*) >= 100 THEN 'success'
            WHEN COUNT(*) >= 50 THEN 'warning'
            ELSE 'info'
        END AS Status
    FROM Employees
    
    UNION ALL
    
    SELECT 
        'Avg Salary',
        CAST(AVG(BaseSalary) AS INT),
        'USD',
        '💰',
        CASE 
            WHEN AVG(BaseSalary) >= 80000 THEN 'success'
            WHEN AVG(BaseSalary) >= 60000 THEN 'warning'
            ELSE 'danger'
        END
    FROM Employees
    WHERE BaseSalary IS NOT NULL
    
    UNION ALL
    
    SELECT 
        'Active Projects',
        COUNT(*),
        'projects',
        '📊',
        CASE 
            WHEN COUNT(*) >= 10 THEN 'success'
            WHEN COUNT(*) >= 5 THEN 'warning'
            ELSE 'info'
        END
    FROM Projects
    WHERE Status = 'In Progress'
)
SELECT 
    '┌─────────────────────────────────────────────────────────────────┐' AS DashboardFrame
UNION ALL
SELECT '│                    📈 TECHCORP DASHBOARD                        │'
UNION ALL
SELECT '├─────────────────────────────────────────────────────────────────┤'
UNION ALL
SELECT 
    '│ ' + Icon + ' ' + LEFT(MetricName + SPACE(15), 15) + 
    '│ ' + RIGHT(SPACE(8) + FORMAT(MetricValue, 'N0'), 8) + ' ' + LEFT(Unit + SPACE(8), 8) + 
    '│ ' + CASE Status
            WHEN 'success' THEN '🟢'
            WHEN 'warning' THEN '🟡' 
            WHEN 'info' THEN '🔵'
            ELSE '🔴'
          END + ' │'
FROM DashboardMetrics
UNION ALL
SELECT '└─────────────────────────────────────────────────────────────────┘';
```

## 4.5 Export Format Optimization

### Excel-Optimized Output

```sql
-- Format data specifically for Excel import
SELECT 
    'Employee_ID' AS A,
    'Full_Name' AS B,
    'Department' AS C,
    'Job_Title' AS D,
    'Hire_Date' AS E,
    'Base_Salary' AS F,
    'Years_Service' AS G,
    'Performance_Rating' AS H
    
UNION ALL

SELECT 
    CAST(e.EmployeeID AS VARCHAR),
    e.FirstName + ' ' + e.LastName,
    d.DepartmentName,
    e.JobTitle,
    FORMAT(e.HireDate, 'yyyy-MM-dd'),
    CAST(e.BaseSalary AS VARCHAR),
    CAST(DATEDIFF(YEAR, e.HireDate, GETDATE()) AS VARCHAR),
    CASE 
        WHEN e.BaseSalary >= (SELECT AVG(BaseSalary) * 1.2 FROM Employees) THEN 'Excellent'
        WHEN e.BaseSalary >= (SELECT AVG(BaseSalary) FROM Employees) THEN 'Good'
        WHEN e.BaseSalary >= (SELECT AVG(BaseSalary) * 0.8 FROM Employees) THEN 'Average'
        ELSE 'Below Average'
    END
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

### JSON-Style Output

```sql
-- Generate JSON-formatted result sets
SELECT 
    '{' +
    '"employeeId":' + CAST(e.EmployeeID AS VARCHAR) + ',' +
    '"name":"' + e.FirstName + ' ' + e.LastName + '",' +
    '"department":"' + d.DepartmentName + '",' +
    '"salary":' + CAST(e.BaseSalary AS VARCHAR) + ',' +
    '"hireDate":"' + FORMAT(e.HireDate, 'yyyy-MM-dd') + '"' +
    '}' AS JsonRecord
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.BaseSalary IS NOT NULL;
```

## 4.6 Practical Exercises

### Exercise 1: Executive Dashboard Design

Create a comprehensive executive dashboard featuring:

- Key performance indicators with visual status
- Trend analysis with directional arrows
- Department comparison matrix
- Risk assessment summary

### Exercise 2: Responsive Report Layout

Design a responsive report that adapts to different screen sizes:

- Mobile-friendly single column layout
- Tablet two-column layout
- Desktop multi-column layout
- Print-optimized format

### Exercise 3: Interactive Search Interface

Build an interactive search and filter system:

- Search term highlighting
- Relevance scoring
- Pagination controls
- Sort options with visual indicators

### Exercise 4: Multi-Format Export System

Create a system that outputs the same data in multiple formats:

- Screen-optimized display
- CSV export format
- Excel-ready format
- JSON API format

## Key Takeaways

- Customize result sets based on user roles and needs
- Implement responsive design principles in SQL output
- Use conditional formatting for better data interpretation
- Design for multiple export formats
- Include interactive elements like pagination and search
- Apply consistent theming for professional appearance
- Consider screen size and display constraints

## Next Steps

This completes Module 10's comprehensive coverage of data visualization, formatting, and reporting in SQL Server. These skills will enhance your ability to present data professionally and create compelling reports for various audiences and business needs.