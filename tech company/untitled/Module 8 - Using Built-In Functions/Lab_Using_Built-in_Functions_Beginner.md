# Lab: Using Built-In Functions - Beginner Practice Lab

## 🎯 Lab Overview (🟢 BEGINNER FRIENDLY)

Welcome to your hands-on practice session! This lab gives you guided exercises to practice everything you've learned about built-in functions. Think of it as your training ground – safe to experiment and learn!

**Time Required**: 45-60 minutes  
**Difficulty**: Beginner  
**Prerequisites**: Complete Lessons 1-4 of Module 8

---

## 🎓 What You'll Practice

In this lab, you'll:

✅ Use string functions to manipulate text  
✅ Apply date functions for time calculations  
✅ Format numbers and dates for reports  
✅ Handle NULL values like a pro  
✅ Create business logic with CASE statements  

---

## 🛠️ Setup - Run This First!

```sql
-- Always start by connecting to our database
USE TechCorpDB;
GO

-- Verify connection
SELECT DB_NAME() AS CurrentDatabase;
```

**Expected Output**: `TechCorpDB`

---

## Part 1: String Functions Practice 📝

### Exercise 1.1: Text Case Conversion (🟢 SUPER BASIC)

**Your Task**: Display employee names in different formats.

```sql
-- Write a query that shows:
-- 1. FirstName as-is
-- 2. FirstName in UPPERCASE
-- 3. FirstName in lowercase
-- 4. Full name (FirstName + LastName) in uppercase

SELECT 
    FirstName,
    _______(FirstName) AS UpperFirst,     -- Fill in the function
    _______(FirstName) AS LowerFirst,     -- Fill in the function
    _______(_______(FirstName, ' ', LastName)) AS FullNameUpper
FROM Employees
WHERE EmployeeID <= 5;
```

<details>
<summary>💡 Click for Hint</summary>

Use `UPPER()` for uppercase, `LOWER()` for lowercase, and `CONCAT()` to join strings.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    FirstName,
    UPPER(FirstName) AS UpperFirst,
    LOWER(FirstName) AS LowerFirst,
    UPPER(CONCAT(FirstName, ' ', LastName)) AS FullNameUpper
FROM Employees
WHERE EmployeeID <= 5;
```

</details>

---

### Exercise 1.2: String Length and Extraction (🟢 BASIC)

**Your Task**: Analyze department names.

```sql
-- Write a query that shows:
-- 1. DepartmentName
-- 2. How many characters in the name
-- 3. First 3 characters
-- 4. Last 3 characters

SELECT 
    DepartmentName,
    _______(DepartmentName) AS NameLength,
    _______(DepartmentName, 3) AS FirstThree,
    _______(DepartmentName, 3) AS LastThree
FROM Departments;
```

<details>
<summary>💡 Click for Hint</summary>

Use `LEN()` for length, `LEFT()` for first characters, `RIGHT()` for last characters.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    DepartmentName,
    LEN(DepartmentName) AS NameLength,
    LEFT(DepartmentName, 3) AS FirstThree,
    RIGHT(DepartmentName, 3) AS LastThree
FROM Departments;
```

</details>

---

### Exercise 1.3: Email Domain Extraction (🟢 BASIC)

**Your Task**: Extract the domain from company email addresses.

```sql
-- Write a query that shows:
-- 1. CompanyName
-- 2. PrimaryEmail
-- 3. Position of @ symbol
-- 4. Domain name (everything after @)

SELECT 
    CompanyName,
    PrimaryEmail,
    _______(_____, PrimaryEmail) AS AtPosition,
    SUBSTRING(PrimaryEmail, 
              CHARINDEX('@', PrimaryEmail) + 1, 
              _______(PrimaryEmail)) AS Domain
FROM Companies
WHERE PrimaryEmail IS NOT NULL
AND CompanyID <= 5;
```

<details>
<summary>💡 Click for Hint</summary>

Use `CHARINDEX('@', PrimaryEmail)` to find the @ position, and `LEN()` for the length.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CompanyName,
    PrimaryEmail,
    CHARINDEX('@', PrimaryEmail) AS AtPosition,
    SUBSTRING(PrimaryEmail, 
              CHARINDEX('@', PrimaryEmail) + 1, 
              LEN(PrimaryEmail)) AS Domain
FROM Companies
WHERE PrimaryEmail IS NOT NULL
AND CompanyID <= 5;
```

</details>

---

## Part 2: Date Functions Practice 📅

### Exercise 2.1: Date Extraction (🟢 SUPER BASIC)

**Your Task**: Break down hire dates into components.

```sql
-- Write a query that shows:
-- 1. Employee name
-- 2. HireDate
-- 3. Year hired
-- 4. Month hired (number)
-- 5. Day hired

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    _______(HireDate) AS YearHired,
    _______(HireDate) AS MonthHired,
    _______(HireDate) AS DayHired
FROM Employees
WHERE EmployeeID <= 5;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    YEAR(HireDate) AS YearHired,
    MONTH(HireDate) AS MonthHired,
    DAY(HireDate) AS DayHired
FROM Employees
WHERE EmployeeID <= 5;
```

</details>

---

### Exercise 2.2: Employee Tenure Calculation (🟢 BASIC)

**Your Task**: Calculate how long employees have worked.

```sql
-- Write a query that shows:
-- 1. Employee name
-- 2. HireDate
-- 3. Days employed
-- 4. Months employed
-- 5. Years employed

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    _______(DAY, HireDate, _______()) AS DaysEmployed,
    _______(MONTH, HireDate, _______()) AS MonthsEmployed,
    _______(YEAR, HireDate, _______()) AS YearsEmployed
FROM Employees
WHERE EmployeeID <= 10;
```

<details>
<summary>💡 Click for Hint</summary>

Use `DATEDIFF(unit, start_date, end_date)` and `GETDATE()` for today's date.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed,
    DATEDIFF(MONTH, HireDate, GETDATE()) AS MonthsEmployed,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed
FROM Employees
WHERE EmployeeID <= 10;
```

</details>

---

### Exercise 2.3: Anniversary Calculator (🟢 BASIC)

**Your Task**: Find when each employee's next work anniversary is.

```sql
-- Write a query that shows:
-- 1. Employee name
-- 2. HireDate
-- 3. Years at company
-- 4. Next anniversary date (add years to hire date to get next one)

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsAtCompany,
    _______(YEAR, 
            DATEDIFF(YEAR, HireDate, GETDATE()) + 1, 
            HireDate) AS NextAnniversary
FROM Employees
WHERE EmployeeID <= 10;
```

<details>
<summary>💡 Click for Hint</summary>

Use `DATEADD(YEAR, number, date)` to add years to the hire date.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsAtCompany,
    DATEADD(YEAR, 
            DATEDIFF(YEAR, HireDate, GETDATE()) + 1, 
            HireDate) AS NextAnniversary
FROM Employees
WHERE EmployeeID <= 10;
```

</details>

---

## Part 3: Number Functions & Formatting Practice 🔢

### Exercise 3.1: Salary Rounding (🟢 BASIC)

**Your Task**: Display salaries in different rounded formats.

```sql
-- Write a query that shows:
-- 1. Employee name
-- 2. BaseSalary (original)
-- 3. Salary rounded to nearest dollar
-- 4. Salary rounded to nearest hundred
-- 5. Salary rounded to nearest thousand

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    BaseSalary,
    _______(BaseSalary, 0) AS RoundedDollar,
    _______(BaseSalary, -2) AS RoundedHundred,
    _______(BaseSalary, -3) AS RoundedThousand
FROM Employees
WHERE EmployeeID <= 5;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    BaseSalary,
    ROUND(BaseSalary, 0) AS RoundedDollar,
    ROUND(BaseSalary, -2) AS RoundedHundred,
    ROUND(BaseSalary, -3) AS RoundedThousand
FROM Employees
WHERE EmployeeID <= 5;
```

</details>

---

### Exercise 3.2: Salary Formatting (🟢 BASIC)

**Your Task**: Format salaries for a professional report.

```sql
-- Write a query that shows:
-- 1. Employee name
-- 2. Salary as currency ($XX,XXX.XX)
-- 3. Salary as number with commas
-- 4. Hire date formatted as "Month Day, Year"

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    _______(BaseSalary, 'C') AS SalaryCurrency,
    _______(BaseSalary, 'N0') AS SalaryNumber,
    _______(HireDate, 'MMMM d, yyyy') AS FormattedHireDate
FROM Employees
WHERE EmployeeID <= 5;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    FORMAT(BaseSalary, 'C') AS SalaryCurrency,
    FORMAT(BaseSalary, 'N0') AS SalaryNumber,
    FORMAT(HireDate, 'MMMM d, yyyy') AS FormattedHireDate
FROM Employees
WHERE EmployeeID <= 5;
```

</details>

---

## Part 4: NULL Handling Practice 🔍

### Exercise 4.1: Finding and Replacing NULLs (🟢 BASIC)

**Your Task**: Handle missing middle names.

```sql
-- Write a query that shows:
-- 1. Full name with middle initial (if exists)
-- 2. "No Middle Name" if MiddleName is NULL
-- 3. A flag indicating if middle name is missing

SELECT 
    FirstName,
    LastName,
    _______(MiddleName, 'No Middle Name') AS MiddleNameDisplay,
    CASE 
        WHEN MiddleName _______ THEN 'Missing'
        ELSE 'Present'
    END AS DataStatus
FROM Employees
WHERE EmployeeID <= 10;
```

<details>
<summary>💡 Click for Hint</summary>

Use `ISNULL()` to replace NULL, and `IS NULL` to test for NULL.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    FirstName,
    LastName,
    ISNULL(MiddleName, 'No Middle Name') AS MiddleNameDisplay,
    CASE 
        WHEN MiddleName IS NULL THEN 'Missing'
        ELSE 'Present'
    END AS DataStatus
FROM Employees
WHERE EmployeeID <= 10;
```

</details>

---

### Exercise 4.2: COALESCE for Contact Priority (🟢 BASIC)

**Your Task**: Show the best available contact method.

```sql
-- Write a query that shows company contact info
-- Priority: Email → Phone → "No Contact Available"

SELECT 
    CompanyName,
    PrimaryEmail,
    PrimaryPhone,
    _______(PrimaryEmail, PrimaryPhone, 'No Contact Available') AS BestContact
FROM Companies
WHERE CompanyID <= 10;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CompanyName,
    PrimaryEmail,
    PrimaryPhone,
    COALESCE(PrimaryEmail, PrimaryPhone, 'No Contact Available') AS BestContact
FROM Companies
WHERE CompanyID <= 10;
```

</details>

---

### Exercise 4.3: Safe Division with NULLIF (🟢 BASIC)

**Your Task**: Calculate budget per employee without division errors.

```sql
-- Write a query that calculates budget per employee
-- Handle departments with 0 employees (prevent division by zero)

SELECT 
    d.DepartmentName,
    d.Budget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    d.Budget / _______(COUNT(e.EmployeeID), 0) AS BudgetPerEmployee
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.Budget;
```

<details>
<summary>💡 Click for Hint</summary>

Use `NULLIF(value, 0)` to turn 0 into NULL, making the division return NULL instead of error.

</details>

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    d.DepartmentName,
    d.Budget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    d.Budget / NULLIF(COUNT(e.EmployeeID), 0) AS BudgetPerEmployee
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.Budget;
```

</details>

---

## Part 5: CASE Statement Practice 🔀

### Exercise 5.1: Salary Categories (🟢 BASIC)

**Your Task**: Categorize employees by salary range.

```sql
-- Write a query that categorizes salaries:
-- >= $100,000: "Executive"
-- >= $75,000: "Senior"
-- >= $50,000: "Mid-Level"
-- < $50,000: "Entry"

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    FORMAT(BaseSalary, 'C') AS Salary,
    _______ 
        WHEN BaseSalary >= 100000 THEN 'Executive'
        _______ BaseSalary >= 75000 THEN 'Senior'
        _______ BaseSalary >= 50000 THEN 'Mid-Level'
        _______ 'Entry'
    _______ AS SalaryLevel
FROM Employees
WHERE EmployeeID <= 15;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    FORMAT(BaseSalary, 'C') AS Salary,
    CASE 
        WHEN BaseSalary >= 100000 THEN 'Executive'
        WHEN BaseSalary >= 75000 THEN 'Senior'
        WHEN BaseSalary >= 50000 THEN 'Mid-Level'
        ELSE 'Entry'
    END AS SalaryLevel
FROM Employees
WHERE EmployeeID <= 15;
```

</details>

---

### Exercise 5.2: Tenure Categories (🟢 BASIC)

**Your Task**: Categorize employees by how long they've worked.

```sql
-- Write a query that creates tenure categories:
-- Less than 1 year: "New Hire"
-- 1-2 years: "Junior"
-- 3-5 years: "Experienced"
-- 5+ years: "Veteran"

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN _______
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) <= 2 THEN _______
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) <= 5 THEN _______
        ELSE _______
    END AS TenureCategory
FROM Employees
WHERE EmployeeID <= 15;
```

<details>
<summary>✅ Click for Solution</summary>

```sql
SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) <= 2 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) <= 5 THEN 'Experienced'
        ELSE 'Veteran'
    END AS TenureCategory
FROM Employees
WHERE EmployeeID <= 15;
```

</details>

---

## 🏆 Final Challenge: Complete Employee Dashboard

**Your Mission**: Create a comprehensive employee report using EVERYTHING you've learned!

The report should include:
1. Employee full name (UPPERCASE)
2. Department name (or "Unassigned" if NULL)
3. Salary formatted as currency
4. Salary category (High/Medium/Low)
5. Hire date formatted nicely
6. Years at company
7. Tenure category
8. Data quality indicator (Complete/Incomplete based on NULL fields)

```sql
-- Your comprehensive employee dashboard
SELECT 
    -- 1. Full name in uppercase
    
    -- 2. Department with NULL handling
    
    -- 3. Salary as currency
    
    -- 4. Salary category using CASE
    
    -- 5. Formatted hire date
    
    -- 6. Years at company
    
    -- 7. Tenure category
    
    -- 8. Data quality check

FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 20
ORDER BY e.BaseSalary DESC;
```

<details>
<summary>✅ Click for Complete Solution</summary>

```sql
SELECT 
    -- 1. Full name in uppercase
    UPPER(CONCAT(FirstName, ' ', LastName)) AS EmployeeName,
    
    -- 2. Department with NULL handling
    ISNULL(d.DepartmentName, 'Unassigned') AS Department,
    
    -- 3. Salary as currency
    FORMAT(e.BaseSalary, 'C') AS Salary,
    
    -- 4. Salary category using CASE
    CASE 
        WHEN e.BaseSalary >= 100000 THEN 'High'
        WHEN e.BaseSalary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory,
    
    -- 5. Formatted hire date
    FORMAT(e.HireDate, 'MMMM d, yyyy') AS HireDate,
    
    -- 6. Years at company
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsAtCompany,
    
    -- 7. Tenure category
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 3 THEN 'Junior'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 5 THEN 'Mid-Level'
        ELSE 'Veteran'
    END AS TenureLevel,
    
    -- 8. Data quality check
    CASE 
        WHEN e.MiddleName IS NULL OR d.DepartmentID IS NULL THEN 'Incomplete'
        ELSE 'Complete'
    END AS DataQuality

FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 20
ORDER BY e.BaseSalary DESC;
```

</details>

---

## 📋 Lab Summary

Congratulations! 🎉 In this lab you practiced:

✅ **String functions** – UPPER, LOWER, CONCAT, LEN, LEFT, RIGHT, CHARINDEX  
✅ **Date functions** – YEAR, MONTH, DAY, DATEDIFF, DATEADD, FORMAT  
✅ **Number functions** – ROUND, FORMAT  
✅ **NULL handling** – ISNULL, COALESCE, NULLIF, IS NULL  
✅ **Logical functions** – CASE statements  
✅ **Combining everything** – Building real business reports  

---

## 🎯 Self-Assessment Checklist

Before moving on, make sure you can:

- [ ] Convert text to uppercase and lowercase
- [ ] Extract parts of strings using LEFT, RIGHT, SUBSTRING
- [ ] Find character positions with CHARINDEX
- [ ] Calculate differences between dates with DATEDIFF
- [ ] Add time to dates with DATEADD
- [ ] Format numbers as currency
- [ ] Format dates in custom patterns
- [ ] Replace NULL values with ISNULL
- [ ] Find first non-NULL with COALESCE
- [ ] Prevent division by zero with NULLIF
- [ ] Create categories with CASE statements

**Great job completing the Built-In Functions Lab!** 🚀

**Next Module**: Module 9 - Grouping and Aggregating Data
