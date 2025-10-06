# Module 8: Built-in Functions - Theory Presentation (🔴 EXPERT LEVEL)

## Slide 1: Module Overview
**Built-in Functions - Expert Level**

- Advanced string manipulation and pattern matching techniques
- Complex date/time calculations and business logic
- Mathematical functions for sophisticated business calculations
- Conversion functions and advanced data type handling
- System functions for metadata and administrative tasks
- Performance optimization strategies with function usage

---

## Slide 2: SQL Server Function Categories
**Comprehensive Function Classification**

- **String Functions**: LEN, SUBSTRING, CHARINDEX, PATINDEX, REPLACE, STUFF
- **Date/Time Functions**: DATEADD, DATEDIFF, FORMAT, PARSE, SWITCHOFFSET
- **Mathematical Functions**: ROUND, CEILING, FLOOR, POWER, LOG, RAND
- **Conversion Functions**: CAST, CONVERT, TRY_CAST, TRY_CONVERT, PARSE
- **Logical Functions**: CHOOSE, IIF, CASE, COALESCE, NULLIF
- **System Functions**: @@IDENTITY, @@ROWCOUNT, HOST_NAME, SYSTEM_USER
- **Aggregate Functions**: SUM, COUNT, AVG, STRING_AGG, STDEV

---

## Slide 3: Advanced String Functions
**Expert String Manipulation**

```sql
-- Complex string operations
SELECT 
    -- Extract domain from email
    RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS Domain,
    
    -- Clean phone numbers
    REPLACE(REPLACE(REPLACE(PhoneNumber, '(', ''), ')', ''), '-', '') AS CleanPhone,
    
    -- Format names properly
    UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName))) AS ProperFirst,
    
    -- Extract initials
    LEFT(FirstName, 1) + LEFT(LastName, 1) AS Initials,
    
    -- Mask sensitive data
    LEFT(SSN, 3) + '-XX-' + RIGHT(SSN, 4) AS MaskedSSN
FROM Employees;
```

---

## Slide 4: Pattern Matching and Text Search
**Advanced Text Analysis**

```sql
-- PATINDEX for pattern matching
SELECT 
    FirstName,
    PATINDEX('%[0-9]%', FirstName) AS FirstDigitPosition,
    PATINDEX('%[^A-Za-z]%', FirstName) AS FirstNonLetterPosition
FROM Employees;

-- STRING_SPLIT (SQL Server 2016+)
SELECT 
    EmployeeID,
    value AS Skill
FROM Employees
CROSS APPLY STRING_SPLIT(SkillsList, ',')
WHERE TRIM(value) <> '';

-- Advanced LIKE patterns with ESCAPE
SELECT * FROM Products
WHERE ProductName LIKE '%50\% Off%' ESCAPE '\';
```

---

## Slide 5: String Aggregation and JSON
**Modern String Functions**

```sql
-- STRING_AGG (SQL Server 2017+)
SELECT 
    DepartmentID,
    STRING_AGG(FirstName + ' ' + LastName, '; ') WITHIN GROUP (ORDER BY LastName) AS EmployeeList
FROM Employees
WHERE IsActive = 1
GROUP BY DepartmentID;

-- JSON functions (SQL Server 2016+)
SELECT 
    EmployeeID,
    JSON_VALUE(ContactInfo, '$.email') AS Email,
    JSON_VALUE(ContactInfo, '$.phone') AS Phone,
    JSON_QUERY(ContactInfo, '$.address') AS Address
FROM Employees
WHERE ISJSON(ContactInfo) = 1;

-- Format as JSON
SELECT 
    EmployeeID,
    FirstName,
    LastName
FROM Employees
FOR JSON PATH;
```

---

## Slide 6: Advanced Date and Time Functions
**Complex Temporal Calculations**

```sql
-- Business day calculations
SELECT 
    @StartDate AS StartDate,
    @EndDate AS EndDate,
    
    -- Calculate business days (excluding weekends)
    DATEDIFF(DAY, @StartDate, @EndDate) - 
    (DATEDIFF(WEEK, @StartDate, @EndDate) * 2) -
    CASE WHEN DATEPART(WEEKDAY, @StartDate) = 1 THEN 1 ELSE 0 END -
    CASE WHEN DATEPART(WEEKDAY, @EndDate) = 7 THEN 1 ELSE 0 END AS BusinessDays,
    
    -- Age calculation considering leap years
    DATEDIFF(YEAR, BirthDate, GETDATE()) - 
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, BirthDate, GETDATE()), BirthDate) > GETDATE() 
        THEN 1 
        ELSE 0 
    END AS ExactAge
FROM Employees;
```

---

## Slide 7: Date Formatting and Parsing
**International Date Handling**

```sql
-- FORMAT function (SQL Server 2012+)
SELECT 
    OrderDate,
    FORMAT(OrderDate, 'dd/MM/yyyy') AS UKFormat,
    FORMAT(OrderDate, 'MM/dd/yyyy') AS USFormat,
    FORMAT(OrderDate, 'yyyy-MM-dd') AS ISOFormat,
    FORMAT(OrderDate, 'dddd, MMMM dd, yyyy') AS LongFormat,
    FORMAT(OrderDate, 'D', 'de-DE') AS GermanLongDate
FROM Orders;

-- PARSE function with culture
SELECT 
    TRY_PARSE('31/12/2023' AS DATE USING 'en-GB') AS UKDate,
    TRY_PARSE('12/31/2023' AS DATE USING 'en-US') AS USDate,
    TRY_PARSE('€1.234,56' AS MONEY USING 'de-DE') AS GermanMoney
```

---

## Slide 8: Time Zone Handling
**Global DateTime Management**

```sql
-- Working with DATETIMEOFFSET
SELECT 
    EventTime,
    EventTime AT TIME ZONE 'UTC' AS UTCTime,
    EventTime AT TIME ZONE 'Eastern Standard Time' AS EasternTime,
    EventTime AT TIME ZONE 'Pacific Standard Time' AS PacificTime,
    
    -- Convert between time zones
    SWITCHOFFSET(EventTime, '+05:30') AS IndiaTime,
    SWITCHOFFSET(EventTime, '-08:00') AS PacificOffset
FROM GlobalEvents;

-- Time zone conversions
DECLARE @UTCTime DATETIME2 = '2023-06-15 14:30:00';
SELECT 
    @UTCTime AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' AS EasternLocal,
    @UTCTime AT TIME ZONE 'UTC' AT TIME ZONE 'Tokyo Standard Time' AS TokyoLocal;
```

---

## Slide 9: Mathematical Functions for Business
**Financial and Statistical Calculations**

```sql
-- Advanced mathematical operations
SELECT 
    EmployeeID,
    BaseSalary,
    
    -- Compound interest calculation
    BaseSalary * POWER(1.03, 5) AS FiveYearProjection,
    
    -- Logarithmic calculations
    LOG(BaseSalary / 30000) AS SalaryLogRatio,
    LOG10(BaseSalary) AS SalaryLog10,
    
    -- Random values for sampling
    RAND(CHECKSUM(NEWID())) AS RandomValue,
    
    -- Trigonometric functions (rare in business, but available)
    SIN(PI() / 6) AS SineExample,
    
    -- Statistical functions
    SIGN(BaseSalary - 50000) AS SalaryComparison,
    ABS(BaseSalary - 65000) AS SalaryDeviation
FROM Employees;
```

---

## Slide 10: Advanced Conversion Functions
**Robust Data Type Handling**

```sql
-- Safe conversion with error handling
SELECT 
    EmployeeID,
    
    -- Safe conversions return NULL on failure
    TRY_CAST(BadData AS INT) AS SafeInteger,
    TRY_CONVERT(DATE, DateString) AS SafeDate,
    TRY_PARSE(MoneyString AS MONEY USING 'en-US') AS SafeMoney,
    
    -- ISNUMERIC for validation
    CASE WHEN ISNUMERIC(SalaryText) = 1 
         THEN CAST(SalaryText AS MONEY) 
         ELSE 0 END AS ValidatedSalary,
    
    -- Custom conversion logic
    CASE 
        WHEN TRY_CAST(AgeText AS INT) IS NOT NULL AND TRY_CAST(AgeText AS INT) BETWEEN 16 AND 100
        THEN TRY_CAST(AgeText AS INT)
        ELSE NULL
    END AS ValidatedAge
FROM EmployeeImport;
```

---

## Slide 11: Logical Functions and Conditional Logic
**Advanced Decision Making**

```sql
-- IIF function (SQL Server 2012+)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    IIF(BaseSalary > 75000, 'High Earner', 'Standard Earner') AS EarningCategory,
    
    -- CHOOSE function
    CHOOSE(MONTH(HireDate), 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec') AS HireMonth,
    
    -- COALESCE for NULL handling
    COALESCE(MiddleName, 'N/A') AS MiddleNameDisplay,
    
    -- NULLIF to convert values to NULL
    NULLIF(Department, 'Unknown') AS CleanDepartment
FROM Employees;
```

---

## Slide 12: System and Metadata Functions
**Administrative and Diagnostic Functions**

```sql
-- System information functions
SELECT 
    @@VERSION AS SQLServerVersion,
    @@SERVERNAME AS ServerName,
    DB_NAME() AS CurrentDatabase,
    SYSTEM_USER AS CurrentUser,
    USER_NAME() AS DatabaseUser,
    HOST_NAME() AS ClientHostName,
    APP_NAME() AS ApplicationName,
    
    -- Session and connection info
    @@SPID AS SessionID,
    @@ROWCOUNT AS LastRowCount,
    @@IDENTITY AS LastIdentity,
    SCOPE_IDENTITY() AS CurrentScopeIdentity,
    IDENT_CURRENT('Employees') AS TableLastIdentity;

-- Object metadata
SELECT 
    OBJECT_ID('Employees') AS TableObjectID,
    OBJECT_NAME(OBJECT_ID('Employees')) AS TableName,
    SCHEMA_NAME(SCHEMA_ID('dbo')) AS SchemaName,
    COL_LENGTH('Employees', 'FirstName') AS ColumnMaxLength;
```

---

## Slide 13: Window Functions Integration
**Advanced Analytical Functions**

```sql
-- Window functions with built-in functions
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    BaseSalary,
    DepartmentID,
    
    -- Ranking functions
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY BaseSalary DESC) AS SalaryRank,
    RANK() OVER (ORDER BY BaseSalary DESC) AS OverallRank,
    DENSE_RANK() OVER (ORDER BY YEAR(HireDate)) AS HireYearRank,
    
    -- Aggregate window functions
    AVG(BaseSalary) OVER (PARTITION BY DepartmentID) AS DeptAvgSalary,
    SUM(BaseSalary) OVER (ORDER BY EmployeeID ROWS UNBOUNDED PRECEDING) AS RunningTotal,
    
    -- Lead/Lag functions
    LAG(BaseSalary, 1, 0) OVER (ORDER BY HireDate) AS PreviousEmployeeSalary,
    LEAD(HireDate, 1) OVER (ORDER BY HireDate) AS NextEmployeeHireDate
FROM Employees;
```

---

## Slide 14: Error Handling Functions
**Robust Function Usage**

```sql
-- Error information functions
BEGIN TRY
    -- Some operation that might fail
    SELECT CAST('Invalid' AS INT);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_LINE() AS ErrorLine,
        ERROR_PROCEDURE() AS ErrorProcedure;
END CATCH

-- Validation functions
SELECT 
    EmployeeID,
    Email,
    CASE 
        WHEN Email LIKE '%@%.%' AND CHARINDEX(' ', Email) = 0 
        THEN 'Valid'
        ELSE 'Invalid'
    END AS EmailValidation,
    
    CASE 
        WHEN ISNUMERIC(PhoneNumber) = 1 AND LEN(PhoneNumber) = 10
        THEN 'Valid'
        ELSE 'Invalid'
    END AS PhoneValidation
FROM Employees;
```

---

## Slide 15: Performance Considerations with Functions
**Optimization Strategies**

```sql
-- SARGable vs Non-SARGable predicates
-- BAD: Function on indexed column
WHERE YEAR(HireDate) = 2023                    -- Non-SARGable
WHERE UPPER(LastName) = 'SMITH'                -- Non-SARGable
WHERE DATEDIFF(DAY, HireDate, GETDATE()) > 365 -- Non-SARGable

-- GOOD: SARGable alternatives
WHERE HireDate >= '2023-01-01' AND HireDate < '2024-01-01'
WHERE LastName = 'Smith'  -- Case-insensitive collation
WHERE HireDate < DATEADD(DAY, -365, GETDATE())

-- Computed columns for complex functions
ALTER TABLE Employees 
ADD HireYear AS YEAR(HireDate) PERSISTED;

CREATE INDEX IX_Employees_HireYear ON Employees(HireYear);
```

---

## Slide 16: Function Nesting and Complexity
**Managing Complex Function Logic**

```sql
-- Complex nested functions
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    
    -- Nested string functions
    UPPER(
        LEFT(
            LTRIM(RTRIM(FirstName)), 1
        )
    ) + 
    LOWER(
        SUBSTRING(
            LTRIM(RTRIM(FirstName)), 
            2, 
            LEN(LTRIM(RTRIM(FirstName))) - 1
        )
    ) AS ProperFirstName,
    
    -- Complex date calculations
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 
             AND MONTH(DATEADD(YEAR, 5, HireDate)) = MONTH(GETDATE())
        THEN 'Eligible for 5-year bonus'
        ELSE 'Not eligible'
    END AS BonusEligibility
FROM Employees;
```

---

## Slide 17: User-Defined Functions vs Built-in
**When to Create Custom Functions**

```sql
-- Scalar User-Defined Function
CREATE FUNCTION dbo.CalculateAge(@BirthDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @BirthDate, GETDATE()) - 
           CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @BirthDate, GETDATE()), @BirthDate) > GETDATE() 
                THEN 1 ELSE 0 END;
END

-- Table-Valued Function
CREATE FUNCTION dbo.GetEmployeesInDepartment(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT EmployeeID, FirstName, LastName, BaseSalary
    FROM Employees
    WHERE DepartmentID = @DepartmentID AND IsActive = 1
);

-- Usage
SELECT dbo.CalculateAge(BirthDate) AS Age FROM Employees;
SELECT * FROM dbo.GetEmployeesInDepartment(1);
```

---

## Slide 18: Function Performance Best Practices
**Optimization Guidelines**

**Do's:**
- Use built-in functions when possible
- Create indexed computed columns for frequently used expressions
- Use table-valued functions over scalar functions in FROM/JOIN
- Consider deterministic vs non-deterministic functions

**Don'ts:**
- Avoid scalar UDFs in SELECT lists (row-by-row execution)
- Don't use functions on indexed columns in WHERE clauses
- Avoid complex nested function calls in frequently executed queries

```sql
-- Performance comparison
-- Slow: Scalar UDF in SELECT
SELECT EmployeeID, dbo.ComplexCalculation(BaseSalary) FROM Employees;

-- Fast: Inline calculation or computed column
SELECT EmployeeID, BaseSalary * 1.05 * POWER(1.03, 5) FROM Employees;
```

---

## Slide 19: Function Security and Permissions
**Access Control for Functions**

```sql
-- Grant permissions on functions
GRANT EXECUTE ON dbo.CalculateAge TO [SalesRole];
GRANT SELECT ON dbo.GetEmployeesInDepartment TO [ManagerRole];

-- Schema-bound functions for security
CREATE FUNCTION dbo.SecureEmployeeView()
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 
        EmployeeID, 
        FirstName, 
        LastName,
        CASE WHEN IS_MEMBER('SalaryViewers') = 1 
             THEN BaseSalary 
             ELSE NULL END AS BaseSalary
    FROM dbo.Employees
    WHERE IsActive = 1
);
```

---

## Slide 20: Cross-Database and Linked Server Functions
**Enterprise Function Usage**

```sql
-- Cross-database function calls
SELECT dbo.CalculateBusinessDays(StartDate, EndDate)
FROM [AnotherDatabase].dbo.Projects;

-- Linked server function usage
SELECT OPENQUERY(LinkedServer, 
    'SELECT CustomerID, CalculateDiscount(PurchaseAmount) FROM Sales'
);

-- Distributed queries with functions
SELECT 
    LocalTable.ID,
    LocalTable.Amount,
    [LinkedServer].[RemoteDB].[dbo].[ConvertCurrency](Amount, 'USD', 'EUR') AS EuroAmount
FROM LocalTable;
```

---

## Slide 21: Function Testing and Debugging
**Quality Assurance for Functions**

```sql
-- Unit testing approach
-- Test edge cases
SELECT dbo.CalculateAge('1900-01-01') AS EdgeCase1;
SELECT dbo.CalculateAge('2099-12-31') AS EdgeCase2;
SELECT dbo.CalculateAge(NULL) AS NullCase;

-- Performance testing
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT COUNT(*) FROM Employees WHERE dbo.ComplexFunction(BaseSalary) > 1000000;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Function validation
SELECT 
    Input,
    ExpectedOutput,
    dbo.TestFunction(Input) AS ActualOutput,
    CASE WHEN dbo.TestFunction(Input) = ExpectedOutput 
         THEN 'PASS' ELSE 'FAIL' END AS TestResult
FROM TestCases;
```

---

## Slide 22: Advanced Aggregation Functions
**Statistical and Business Intelligence Functions**

```sql
-- Statistical aggregate functions
SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount,
    AVG(BaseSalary) AS AvgSalary,
    STDEV(BaseSalary) AS SalaryStdDev,
    VAR(BaseSalary) AS SalaryVariance,
    
    -- Percentile functions
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY BaseSalary) AS MedianSalary,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY BaseSalary) AS Q3Salary,
    
    -- String aggregation
    STRING_AGG(FirstName + ' ' + LastName, ', ') AS EmployeeList
FROM Employees
WHERE IsActive = 1
GROUP BY DepartmentID;
```

---

## Slide 23: Integration with Business Logic
**Real-World Function Applications**

```sql
-- Business rule implementation with functions
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    OrderAmount,
    
    -- Complex business calculations
    dbo.CalculateDiscount(CustomerID, OrderAmount, OrderDate) AS DiscountAmount,
    dbo.CalculateShipping(CustomerID, OrderAmount, ShipToCountry) AS ShippingCost,
    dbo.CalculateTax(OrderAmount, ShipToState) AS TaxAmount,
    
    -- Final calculations
    OrderAmount - dbo.CalculateDiscount(CustomerID, OrderAmount, OrderDate) +
    dbo.CalculateShipping(CustomerID, OrderAmount, ShipToCountry) +
    dbo.CalculateTax(OrderAmount, ShipToState) AS FinalAmount
FROM Orders
WHERE OrderDate >= DATEADD(MONTH, -1, GETDATE());
```

---

## Slide 24: Learning Objectives Achieved
**Module 8 Expert Outcomes**

✅ Master advanced string manipulation and pattern matching
✅ Implement complex date/time calculations for business scenarios
✅ Apply mathematical functions for financial and statistical analysis
✅ Handle data type conversions with robust error handling
✅ Utilize system functions for administrative tasks
✅ Optimize function usage for maximum performance
✅ Create and integrate user-defined functions appropriately

---

## Slide 25: Next Steps
**Module 9 Preview: Grouping and Aggregating Data (🔴 EXPERT LEVEL)**

- Advanced aggregate functions for business intelligence
- Complex GROUP BY strategies for multi-dimensional analysis  
- HAVING clauses for sophisticated group filtering
- Window functions for analytical reporting
- Statistical functions for data analysis
- Performance optimization for large-scale aggregations

**Key Preparation**
- Master function performance optimization techniques
- Understand when to use built-in vs user-defined functions
- Practice complex nested function scenarios
- Review statistical and mathematical concepts for business applications