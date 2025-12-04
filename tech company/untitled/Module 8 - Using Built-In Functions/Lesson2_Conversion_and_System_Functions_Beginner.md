# Lesson 2: Conversion and System Functions - Beginner Lesson

## 🎯 What You'll Learn (🟢 COMPLETE BEGINNER LEVEL)

Welcome back! In this lesson, you'll learn about **conversion functions** (changing data from one type to another) and **system functions** (getting information about your database). These are essential tools for working with real-world data!

**No programming experience needed** – we'll explain everything step by step.

---

## 📖 Why Do We Need to Convert Data?

### The Simple Explanation

Imagine you have:
- A number stored as text: `'123'` (with quotes – it's text!)
- A number stored as a number: `123` (no quotes – it's actually a number)

These look the same but behave differently! You can't do math with text, even if it looks like a number.

**Real-World Example:**
```
You can't add these together:
'100' + '50' = '10050'  ← Text gets joined, not added!

But you can add these:
100 + 50 = 150  ← Numbers get added correctly!
```

Conversion functions help you change `'100'` into `100` so your math works!

---

## 📖 What You'll Discover

After this lesson, you'll be able to:

✅ Convert text to numbers and numbers to text  
✅ Convert dates to different formats  
✅ Handle conversion errors safely  
✅ Use system functions to get database information  

---

## Part 1: Converting Between Data Types 🔄

### 🎓 Understanding Data Types

**Data types** are categories of information:
- **Text (VARCHAR/CHAR)**: Names, descriptions, emails → `'John Smith'`
- **Numbers (INT, DECIMAL)**: Quantities, money → `42` or `99.99`
- **Dates (DATE, DATETIME)**: When things happen → `'2025-12-04'`

Sometimes you need to change one type to another!

---

### Exercise 1.1: Converting with CAST() (🟢 SUPER BASIC)

**The Problem**: You have a number but need to display it as text in a message.

**The Solution**: Use `CAST()` to convert between types!

```sql
USE TechCorpDB;
GO

-- CAST(value AS new_type)
-- Think of it as "transform this value into that type"

-- Convert number to text
SELECT 
    123 AS OriginalNumber,
    CAST(123 AS VARCHAR(10)) AS NumberAsText;

-- Now we can combine it with other text!
SELECT 
    'Employee ID: ' + CAST(EmployeeID AS VARCHAR(10)) AS Message
FROM Employees
WHERE EmployeeID <= 3;
```

**What Happens:**
| Expression | Result | Type |
|------------|--------|------|
| `123` | 123 | Number |
| `CAST(123 AS VARCHAR(10))` | '123' | Text |

💡 **Why VARCHAR(10)?** This means "text up to 10 characters long"

---

### Exercise 1.2: Converting Text to Numbers (🟢 BASIC)

**The Problem**: Someone stored prices as text like `'99.99'` and you need to do math with them.

**The Solution**: Cast the text to a number!

```sql
USE TechCorpDB;
GO

-- Convert text to a number
SELECT 
    '99.99' AS TextPrice,
    CAST('99.99' AS DECIMAL(10,2)) AS NumberPrice,
    CAST('99.99' AS DECIMAL(10,2)) * 1.1 AS PriceWith10PercentTax;
```

**Understanding DECIMAL(10,2):**
```
DECIMAL(10, 2)
        ↑   ↑
        |   └── 2 digits after decimal point
        └────── 10 total digits maximum

Examples: 12345678.99 ✓ (10 digits, 2 after decimal)
          123456789.99 ✗ (11 digits - too many!)
```

---

### Exercise 1.3: Converting with CONVERT() (🟢 BASIC)

**The Problem**: You want more control over how conversions look, especially for dates.

**The Solution**: Use `CONVERT()` – it's like CAST but with extra formatting options!

```sql
USE TechCorpDB;
GO

-- CONVERT(target_type, value, style)
-- The style number controls the format (mainly for dates)

SELECT 
    GETDATE() AS CurrentDateTime,
    
    -- Different date formats using style codes
    CONVERT(VARCHAR(10), GETDATE(), 101) AS US_Format,      -- 12/04/2025
    CONVERT(VARCHAR(10), GETDATE(), 103) AS UK_Format,      -- 04/12/2025
    CONVERT(VARCHAR(10), GETDATE(), 23) AS ISO_Format,      -- 2025-12-04
    CONVERT(VARCHAR(20), GETDATE(), 100) AS Default_Format; -- Dec  4 2025
```

**Common Date Format Styles:**
| Style | Format | Example |
|-------|--------|---------|
| 101 | US (MM/DD/YYYY) | 12/04/2025 |
| 103 | UK (DD/MM/YYYY) | 04/12/2025 |
| 23 | ISO (YYYY-MM-DD) | 2025-12-04 |
| 100 | Default | Dec  4 2025 |
| 108 | Time only | 15:30:45 |

---

### Exercise 1.4: Safe Conversion with TRY_CAST() (🟢 BASIC)

**The Problem**: What if someone tries to convert text that ISN'T a valid number? Regular CAST crashes with an error!

**The Solution**: Use `TRY_CAST()` – it returns NULL instead of crashing!

```sql
USE TechCorpDB;
GO

-- Regular CAST crashes on bad data:
-- SELECT CAST('hello' AS INT);  -- ERROR! 'hello' is not a number

-- TRY_CAST returns NULL instead of crashing
SELECT 
    'hello' AS OriginalText,
    TRY_CAST('hello' AS INT) AS SafeResult;  -- Returns NULL, not an error!

-- This is useful for cleaning messy data
SELECT 
    '123' AS GoodData,
    TRY_CAST('123' AS INT) AS ConvertedGood,    -- Returns 123
    'abc' AS BadData,
    TRY_CAST('abc' AS INT) AS ConvertedBad;     -- Returns NULL (no crash!)
```

**Why This Matters:**
```
Real data is often messy!
UserInput column might contain: '500', 'N/A', '250', 'unknown', '100'

With TRY_CAST, you can safely convert what's convertible
and handle the rest gracefully.
```

---

## Part 2: Formatting Functions 🎨

### Exercise 2.1: Formatting Numbers with FORMAT() (🟢 BASIC)

**The Problem**: You want salaries to display as `$75,000.00` with commas and currency symbols.

**The Solution**: Use `FORMAT()` for pretty output!

```sql
USE TechCorpDB;
GO

-- FORMAT(value, format_string)
-- Makes numbers and dates look nice!

SELECT 
    FirstName,
    BaseSalary,
    FORMAT(BaseSalary, 'C') AS CurrencyFormat,     -- $75,000.00
    FORMAT(BaseSalary, 'N0') AS NoDecimals,        -- 75,000
    FORMAT(BaseSalary, 'N2') AS TwoDecimals        -- 75,000.00
FROM Employees
WHERE EmployeeID <= 5;
```

**Common Format Codes:**
| Code | Meaning | Example |
|------|---------|---------|
| `C` | Currency | $1,234.56 |
| `N0` | Number, no decimals | 1,235 |
| `N2` | Number, 2 decimals | 1,234.56 |
| `P` | Percentage | 85.50% |

---

### Exercise 2.2: Formatting Dates with FORMAT() (🟢 BASIC)

**The Problem**: You want dates to display in a specific format like "Thursday, December 4, 2025".

**The Solution**: Use FORMAT() with date codes!

```sql
USE TechCorpDB;
GO

SELECT 
    FirstName,
    HireDate,
    FORMAT(HireDate, 'MMMM d, yyyy') AS LongDate,           -- December 4, 2025
    FORMAT(HireDate, 'dddd, MMMM d, yyyy') AS FullDate,     -- Thursday, December 4, 2025
    FORMAT(HireDate, 'MM/dd/yyyy') AS USDate,               -- 12/04/2025
    FORMAT(HireDate, 'dd-MMM-yyyy') AS ShortDate            -- 04-Dec-2025
FROM Employees
WHERE EmployeeID <= 5;
```

**Date Format Codes:**
| Code | Meaning | Example |
|------|---------|---------|
| `d` | Day (1-31) | 4 |
| `dd` | Day with zero (01-31) | 04 |
| `ddd` | Day name short | Thu |
| `dddd` | Day name full | Thursday |
| `M` | Month (1-12) | 12 |
| `MM` | Month with zero | 12 |
| `MMM` | Month name short | Dec |
| `MMMM` | Month name full | December |
| `yy` | Year (2 digit) | 25 |
| `yyyy` | Year (4 digit) | 2025 |

---

## Part 3: System Functions - Getting Information 📊

### 🎓 What Are System Functions?

System functions tell you things about:
- Your database and server
- The current user
- Row counts and identities
- Environment information

Think of them as asking the database "Hey, what's your name?" or "Who am I logged in as?"

---

### Exercise 3.1: Getting Database Information (🟢 SUPER BASIC)

```sql
USE TechCorpDB;
GO

-- These functions tell you about your environment
SELECT 
    DB_NAME() AS CurrentDatabase,              -- TechCorpDB
    @@SERVERNAME AS ServerName,                -- Your server's name
    SYSTEM_USER AS LoginName,                  -- Who you're logged in as
    USER_NAME() AS DatabaseUser,               -- Your database user
    @@VERSION AS SQLServerVersion;             -- Full version info
```

**Note:** Functions starting with `@@` are called "global variables" – they're built-in values SQL Server tracks automatically.

---

### Exercise 3.2: Getting Row Information (🟢 BASIC)

**The Problem**: After inserting data, you want to know what ID was assigned, or how many rows were affected.

**The Solution**: Use `@@IDENTITY`, `@@ROWCOUNT`, and `SCOPE_IDENTITY()`!

```sql
USE TechCorpDB;
GO

-- First, let's see how many employees we have
SELECT COUNT(*) AS TotalEmployees FROM Employees;

-- @@ROWCOUNT tells you how many rows the last statement affected
SELECT * FROM Employees WHERE DepartmentID = 1;
SELECT @@ROWCOUNT AS RowsReturned;  -- How many rows came back?

-- Example with UPDATE (don't run this - just showing the concept):
-- UPDATE Employees SET BaseSalary = BaseSalary * 1.05 WHERE DepartmentID = 1;
-- SELECT @@ROWCOUNT AS EmployeesGotRaise;
```

💡 **When This Is Useful:**
- After INSERT: "Did my insert work? How many rows?"
- After UPDATE: "How many records did I just change?"
- After DELETE: "How many rows did I remove?"

---

### Exercise 3.3: Using ISNULL() and COALESCE() (🟢 BASIC)

**The Problem**: Some data is missing (NULL). You want to show a default value instead of blank.

**The Solution**: Use `ISNULL()` or `COALESCE()` to substitute values!

```sql
USE TechCorpDB;
GO

-- ISNULL(value, replacement)
-- If value is NULL, use replacement instead

SELECT 
    FirstName,
    LastName,
    MiddleName,
    ISNULL(MiddleName, 'No Middle Name') AS DisplayMiddleName
FROM Employees
WHERE EmployeeID <= 10;

-- COALESCE(value1, value2, value3, ...)
-- Returns the first non-NULL value in the list

SELECT 
    CompanyName,
    PrimaryPhone,
    SecondaryPhone,
    COALESCE(PrimaryPhone, SecondaryPhone, 'No Phone Available') AS ContactPhone
FROM Customers
WHERE CustomerID <= 5;
```

**Visual Comparison:**
```
ISNULL(A, B)          → Returns A unless A is NULL, then returns B
COALESCE(A, B, C, D)  → Returns first non-NULL value: checks A, then B, then C, then D
```

**Real-World Example:**
```sql
-- Show employee phone number - try work phone first, then cell, then home
SELECT 
    EmployeeID,
    COALESCE(WorkPhone, CellPhone, HomePhone, 'No Contact') AS BestPhone
FROM EmployeeContacts;
```

---

### Exercise 3.4: Using NULLIF() (🟢 BASIC)

**The Problem**: You want to treat certain values AS IF they were NULL (like treating 0 as "no data").

**The Solution**: Use `NULLIF()` to convert a specific value to NULL!

```sql
USE TechCorpDB;
GO

-- NULLIF(value1, value2)
-- If value1 equals value2, return NULL
-- Otherwise, return value1

-- Example: Prevent division by zero
SELECT 
    ProjectName,
    Budget,
    ActualCost,
    -- If ActualCost is 0, this would crash without NULLIF!
    Budget / NULLIF(ActualCost, 0) AS BudgetRatio
FROM Projects;

-- Without NULLIF: Budget / 0 = ERROR!
-- With NULLIF:    Budget / NULL = NULL (no error!)
```

**Why This Is Important:**
Division by zero crashes your query! NULLIF turns 0 into NULL, and anything divided by NULL just gives NULL (safely).

---

## Part 4: Putting It All Together 🎨

### Exercise 4.1: Employee Report with Formatting (🟢 BASIC)

```sql
USE TechCorpDB;
GO

SELECT 
    -- Name formatting
    UPPER(FirstName) + ' ' + UPPER(LastName) AS EmployeeName,
    
    -- Salary with currency formatting
    FORMAT(BaseSalary, 'C') AS Salary,
    
    -- Hire date formatted nicely
    FORMAT(HireDate, 'MMMM d, yyyy') AS StartDate,
    
    -- Calculate tenure
    CAST(DATEDIFF(YEAR, HireDate, GETDATE()) AS VARCHAR(5)) + ' years' AS Tenure,
    
    -- Handle NULL middle names
    ISNULL(MiddleName, '-') AS MiddleInitial,
    
    -- Department with default
    COALESCE(d.DepartmentName, 'Unassigned') AS Department

FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 10;
```

---

## 📋 Quick Reference Card 🃏

### Conversion Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `CAST(x AS type)` | Convert to new type | `CAST('123' AS INT)` → `123` |
| `CONVERT(type, x, style)` | Convert with format options | `CONVERT(VARCHAR, GETDATE(), 101)` → `'12/04/2025'` |
| `TRY_CAST(x AS type)` | Safe convert (NULL on failure) | `TRY_CAST('abc' AS INT)` → `NULL` |
| `TRY_CONVERT(type, x)` | Safe convert with format | `TRY_CONVERT(INT, 'abc')` → `NULL` |

### Formatting Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `FORMAT(num, 'C')` | Currency format | `FORMAT(1234.5, 'C')` → `'$1,234.50'` |
| `FORMAT(num, 'N2')` | Number with decimals | `FORMAT(1234.5, 'N2')` → `'1,234.50'` |
| `FORMAT(date, 'pattern')` | Date formatting | `FORMAT(GETDATE(), 'yyyy-MM-dd')` |

### NULL Handling Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `ISNULL(a, b)` | If a is NULL, use b | `ISNULL(NULL, 'default')` → `'default'` |
| `COALESCE(a, b, c...)` | First non-NULL value | `COALESCE(NULL, NULL, 'c')` → `'c'` |
| `NULLIF(a, b)` | If a=b, return NULL | `NULLIF(0, 0)` → `NULL` |

### System Functions
| Function | What It Does |
|----------|--------------|
| `DB_NAME()` | Current database name |
| `@@SERVERNAME` | Server name |
| `SYSTEM_USER` | Login name |
| `@@ROWCOUNT` | Rows affected by last statement |
| `@@VERSION` | SQL Server version |

---

## 📋 What You've Learned

Congratulations! 🎉 You now know:

✅ **CAST and CONVERT** – Change data types  
✅ **TRY_CAST** – Convert safely without crashes  
✅ **FORMAT** – Make numbers and dates look pretty  
✅ **ISNULL and COALESCE** – Handle missing data  
✅ **NULLIF** – Prevent division by zero  
✅ **System Functions** – Get database information  

---

## 🚀 Practice Exercises

1. **Easy**: Convert the number 12345 to text
2. **Easy**: Display today's date in format "Month Day, Year"
3. **Medium**: Format a salary of 75000 as currency
4. **Medium**: Write a query that shows "N/A" for any NULL phone numbers
5. **Challenge**: Calculate average salary but handle cases where salary might be 0

---

## 🚀 Ready for More?

Great job! In the next lesson (**Lesson 3: Using Logical Functions**), you'll learn how to:
- Make decisions in your queries with CASE statements
- Use IIF for simple if-then logic
- Apply business rules to your data

**Next up**: Lesson 3 - Using Logical Functions (Beginner)
