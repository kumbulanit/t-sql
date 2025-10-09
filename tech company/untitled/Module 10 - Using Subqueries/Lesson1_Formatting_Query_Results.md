# Lesson 1: Formatting Query Results and Output Customization

## Learning Objectives
- Master various result formatting techniques in SQL Server
- Understand output customization options in SSMS
- Learn to format data types for better presentation
- Control result set appearance and readability

## 1.1 Introduction to Result Formatting

When working with SQL Server, presenting data in a readable and professional format is crucial for reporting, analysis, and user experience. This lesson covers fundamental techniques for formatting query results.

### Why Format Results?
- **Readability**: Make data easier to understand
- **Presentation**: Professional appearance for reports
- **User Experience**: Improve data consumption
- **Business Requirements**: Meet specific formatting standards

## 1.2 Basic String Formatting Functions

### CONCAT Function
The CONCAT function combines multiple strings into a single string.

```sql
-- Basic employee name formatting
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    CONCAT(e.FirstName, ' ', ISNULL(e.MiddleName + ' ', ''), e.LastName) AS CompleteFullName
FROM Employees e;

-- Professional title formatting
SELECT 
    CONCAT(e.FirstName, ' ', e.LastName, ' - ', e.JobTitle) AS EmployeeTitle,
    CONCAT(d.DepartmentName, ' Department') AS Department
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
```

### FORMAT Function
The FORMAT function provides culture-aware formatting for numbers, dates, and other data types.

```sql
-- Currency formatting
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    FORMAT(e.BaseSalary, 'C', 'en-US') AS FormattedSalary,
    FORMAT(e.BaseSalary, 'N0') AS SalaryWithCommas
FROM Employees e;

-- Date formatting options
SELECT 
    p.ProjectName,
    FORMAT(p.StartDate, 'MMMM dd, yyyy') AS StartDateLong,
    FORMAT(p.StartDate, 'MMM dd, yy') AS StartDateShort,
    FORMAT(p.StartDate, 'dd/MM/yyyy') AS StartDateEuropean
FROM Projects p;

-- Percentage formatting
SELECT 
    p.ProjectName,
    FORMAT(p.ActualCost / p.Budget, 'P2') AS BudgetUtilization,
    FORMAT((p.ActualCost - p.Budget) / p.Budget, 'P1') AS VariancePercent
FROM Projects p
WHERE p.Budget > 0;
```

## 1.3 Advanced String Manipulation

### String Padding and Alignment
```sql
-- Right-align numbers with padding
SELECT 
    RIGHT('000' + CAST(e.EmployeeID AS VARCHAR), 4) AS PaddedID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    RIGHT(SPACE(15) + CAST(e.BaseSalary AS VARCHAR), 15) AS AlignedSalary
FROM Employees e
ORDER BY e.EmployeeID;

-- Left-pad with zeros for employee IDs
SELECT 
    FORMAT(e.EmployeeID, '0000') AS FormattedEmployeeID,
    UPPER(e.LastName) + ', ' + e.FirstName AS LastFirstName
FROM Employees e;
```

### Case Conversion and Text Formatting
```sql
-- Professional name formatting
SELECT 
    e.EmployeeID,
    UPPER(LEFT(e.FirstName, 1)) + LOWER(SUBSTRING(e.FirstName, 2, LEN(e.FirstName))) AS ProperFirstName,
    UPPER(e.LastName) AS LastNameUpper,
    LOWER(e.WorkEmail) AS EmailLower,
    REPLACE(e.PhoneNumber, '-', '.') AS PhoneFormatted
FROM Employees e;

-- Address formatting
SELECT 
    c.CompanyName,
    c.Address1 + 
    CASE 
        WHEN c.Address2 IS NOT NULL THEN ', ' + c.Address2 
        ELSE '' 
    END + ', ' + 
    c.City + ', ' + c.State + ' ' + c.ZipCode AS FullAddress
FROM Companies c;
```

## 1.4 Numeric Formatting Techniques

### Decimal Precision Control
```sql
-- Precise decimal formatting
SELECT 
    p.ProjectName,
    CAST(p.Budget AS DECIMAL(15,2)) AS PreciseBudget,
    ROUND(p.ActualCost, 2) AS RoundedActualCost,
    CAST(ROUND(p.ActualCost / p.Budget * 100, 1) AS DECIMAL(5,1)) AS UtilizationPercent
FROM Projects p
WHERE p.Budget > 0;

-- Scientific notation for large numbers
SELECT 
    c.CompanyName,
    c.AnnualRevenue,
    FORMAT(c.AnnualRevenue, 'E2') AS ScientificNotation,
    CASE 
        WHEN c.AnnualRevenue >= 1000000000 THEN FORMAT(c.AnnualRevenue/1000000000.0, 'N1') + 'B'
        WHEN c.AnnualRevenue >= 1000000 THEN FORMAT(c.AnnualRevenue/1000000.0, 'N1') + 'M'
        WHEN c.AnnualRevenue >= 1000 THEN FORMAT(c.AnnualRevenue/1000.0, 'N1') + 'K'
        ELSE FORMAT(c.AnnualRevenue, 'N0')
    END AS AbbreviatedRevenue
FROM Companies c;
```

## 1.5 Date and Time Formatting

### Comprehensive Date Formatting
```sql
-- Multiple date format options
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.HireDate,
    FORMAT(e.HireDate, 'yyyy-MM-dd') AS ISODate,
    FORMAT(e.HireDate, 'MMMM d, yyyy') AS LongDate,
    FORMAT(e.HireDate, 'ddd, MMM dd') AS ShortDate,
    DATENAME(WEEKDAY, e.HireDate) AS HireDayOfWeek,
    DATENAME(MONTH, e.HireDate) AS HireMonth
FROM Employees e;

-- Time duration formatting
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed,
    DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12 AS AdditionalMonths,
    CONCAT(
        DATEDIFF(YEAR, e.HireDate, GETDATE()), 
        ' years, ', 
        DATEDIFF(MONTH, e.HireDate, GETDATE()) % 12, 
        ' months'
    ) AS TenureFormatted
FROM Employees e;
```

## 1.6 Conditional Formatting with CASE

### Status and Category Formatting
```sql
-- Employee status formatting
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.BaseSalary,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN '🔥 High Earner'
        WHEN e.BaseSalary >= 75000 THEN '⭐ Above Average'
        WHEN e.BaseSalary >= 50000 THEN '✅ Average'
        ELSE '📈 Entry Level'
    END AS SalaryCategory,
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Veteran (10+ years)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Experienced (5-9 years)'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Mid-level (2-4 years)'
        ELSE 'New Hire (< 2 years)'
    END AS TenureCategory
FROM Employees e;

-- Project status with colors (for SSMS display)
SELECT 
    p.ProjectID,
    p.ProjectName,
    CASE p.Status
        WHEN 'Completed' THEN '✅ ' + p.Status
        WHEN 'In Progress' THEN '🔄 ' + p.Status
        WHEN 'On Hold' THEN '⏸️ ' + p.Status
        WHEN 'Cancelled' THEN '❌ ' + p.Status
        ELSE '❓ ' + ISNULL(p.Status, 'Unknown')
    END AS StatusFormatted,
    FORMAT(p.Budget, 'C0') AS BudgetFormatted
FROM Projects p;
```

## 1.7 SSMS Result Grid Customization

### Grid Display Options
To enhance result readability in SQL Server Management Studio:

1. **Tools → Options → Query Results → SQL Server → Results to Grid**
   - Maximum Characters Per Column: Increase for long text
   - Include column headers when copying: Enable for Excel export
   - Quote strings containing list separators: Enable for CSV export

2. **Font and Color Settings**
   - Tools → Options → Environment → Fonts and Colors
   - Select "Text Editor" for query editor
   - Select "Grid Results" for result formatting

### Result Set Navigation
```sql
-- Add row numbers for easy reference
SELECT 
    ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNum,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    FORMAT(e.BaseSalary, 'C0') AS Salary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.LastName, e.FirstName;
```

## 1.8 Practical Exercises

### Exercise 1: Employee Directory Formatting
Create a professional employee directory with the following formatting:
- Employee ID padded to 4 digits
- Full name in "Last, First" format
- Salary formatted as currency
- Hire date in "Month DD, YYYY" format
- Years of service calculated and formatted

### Exercise 2: Project Dashboard
Build a project status dashboard showing:
- Project name with status icons
- Budget vs actual cost with percentage variance
- Timeline information formatted professionally
- Client information with proper capitalization

### Exercise 3: Financial Summary Report
Create a financial summary with:
- Department names formatted consistently
- Budget amounts with proper number formatting
- Percentage calculations with 2 decimal places
- Variance indicators using symbols

## Key Takeaways
- Use FORMAT function for culture-aware formatting
- CONCAT provides clean string combination
- CASE statements enable conditional formatting
- Proper formatting improves data readability
- SSMS settings can enhance result presentation
- Consider your audience when choosing format styles

## Next Steps
In the next lesson, we'll explore advanced visualization techniques including creating charts and graphs directly from SQL Server data.