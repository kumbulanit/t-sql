# Lesson 1: Writing Queries with Built-In Functions - TechCorp Solutions - Beginner Lesson

## 🎯 What You'll Learn (🟢 COMPLETE BEGINNER LEVEL)

Welcome! In this lesson, you'll learn about **built-in functions** in SQL. Think of functions like helpful tools in a toolbox – each one does a specific job to make your work easier. Just like a calculator helps you add numbers, SQL functions help you work with data!

**No programming experience needed** – we'll explain everything in plain English with lots of examples.

---

## 📖 What Are Built-In Functions?

### The Simple Explanation

Imagine you have a spreadsheet with employee names. If you wanted to:
- Make all names UPPERCASE
- Count how many characters are in each name
- Find today's date

You'd use a **function** – a pre-built tool that does the work for you!

### Real-World Analogy 🏠

Think of functions like kitchen appliances:
- **Blender** = Takes ingredients, blends them, gives you a smoothie
- **SQL Function** = Takes data, processes it, gives you a result

For example:
- `UPPER('hello')` → Returns `'HELLO'` (like a blender that makes everything uppercase!)
- `LEN('hello')` → Returns `5` (counts the letters for you)

---

## 📖 What You'll Discover

After this lesson, you'll be able to:

✅ Understand what functions are and why they're useful  
✅ Use text functions to change how words look (uppercase, lowercase)  
✅ Use number functions to do math on your data  
✅ Use date functions to work with dates  
✅ Feel confident writing queries with functions  

---

## Part 1: Text (String) Functions - Working with Words 📝

### 🎓 What Are String Functions?

**String** is just a fancy word for text. String functions help you:
- Change text to UPPERCASE or lowercase
- Count letters in words
- Find specific characters
- Combine words together

### Exercise 1.1: Making Text UPPERCASE (🟢 SUPER BASIC)

**The Problem**: You have employee names stored as "john smith" but you want them to appear as "JOHN SMITH" in a report.

**The Solution**: Use the `UPPER()` function!

```sql
-- Connect to our database first
USE TechCorpDB;
GO

-- Let's make text uppercase
-- UPPER() converts any text to capital letters

SELECT 
    FirstName,                    -- Original name
    UPPER(FirstName) AS UpperName -- Name in capitals
FROM Employees
WHERE EmployeeID <= 5;            -- Just show first 5 employees
```

**What Each Part Means:**
| Code | Plain English |
|------|---------------|
| `SELECT` | "Show me..." |
| `FirstName` | "...the FirstName column..." |
| `UPPER(FirstName)` | "...and also the FirstName converted to uppercase..." |
| `AS UpperName` | "...call this new column 'UpperName'" |
| `FROM Employees` | "...get this from the Employees table" |

**Expected Result:**
| FirstName | UpperName |
|-----------|-----------|
| John      | JOHN      |
| Sarah     | SARAH     |
| Michael   | MICHAEL   |

💡 **Key Insight**: The original data doesn't change! `UPPER()` just shows it differently.

---

### Exercise 1.2: Making Text lowercase (🟢 SUPER BASIC)

**Your Turn!** What if you want everything in lowercase instead?

```sql
USE TechCorpDB;
GO

-- LOWER() converts text to lowercase letters
SELECT 
    FirstName,                     -- Original name
    LOWER(FirstName) AS LowerName  -- Name in lowercase
FROM Employees
WHERE EmployeeID <= 5;
```

**Expected Result:**
| FirstName | LowerName |
|-----------|-----------|
| John      | john      |
| Sarah     | sarah     |
| Michael   | michael   |

---

### Exercise 1.3: Counting Characters with LEN() (🟢 SUPER BASIC)

**The Problem**: How long are our department names? Which is the longest?

**The Solution**: Use `LEN()` to count characters!

```sql
USE TechCorpDB;
GO

-- LEN() counts how many characters (letters, numbers, spaces) are in text
SELECT 
    DepartmentName,
    LEN(DepartmentName) AS NameLength  -- Count the characters
FROM Departments;
```

**What This Shows:**
| DepartmentName | NameLength |
|----------------|------------|
| Engineering    | 11         |
| Sales          | 5          |
| Human Resources| 15         |

💡 **Fun Fact**: `LEN()` counts ALL characters including spaces!

---

### Exercise 1.4: Combining Text with CONCAT() (🟢 BASIC)

**The Problem**: Employee first names and last names are in separate columns, but you want to show the full name together.

**The Solution**: Use `CONCAT()` to join text together!

```sql
USE TechCorpDB;
GO

-- CONCAT() joins multiple pieces of text together
-- Think of it like gluing words together!

SELECT 
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS FullName  -- Join with a space between
FROM Employees
WHERE EmployeeID <= 5;
```

**Breaking It Down:**
- `CONCAT(` = Start combining
- `FirstName` = First piece of text
- `' '` = A space character (the comma separates each piece)
- `LastName` = Second piece of text
- `)` = Done combining

**Expected Result:**
| FirstName | LastName | FullName      |
|-----------|----------|---------------|
| John      | Smith    | John Smith    |
| Sarah     | Johnson  | Sarah Johnson |

---

### Exercise 1.5: Extracting Parts of Text with LEFT(), RIGHT(), SUBSTRING() (🟢 BASIC)

**The Problem**: You only need part of a text value – like the first 3 characters of a department code.

**The Solution**: Use extraction functions!

```sql
USE TechCorpDB;
GO

-- LEFT(text, number) - Gets characters from the left side
-- RIGHT(text, number) - Gets characters from the right side
-- SUBSTRING(text, start, length) - Gets characters from anywhere

SELECT 
    DepartmentName,
    LEFT(DepartmentName, 3) AS FirstThree,      -- First 3 letters
    RIGHT(DepartmentName, 3) AS LastThree,      -- Last 3 letters
    SUBSTRING(DepartmentName, 2, 4) AS Middle   -- 4 letters starting at position 2
FROM Departments;
```

**Visual Example:**
```
DepartmentName: E N G I N E E R I N G
Position:       1 2 3 4 5 6 7 8 9 10 11

LEFT(DepartmentName, 3)     = "ENG"        (positions 1-3)
RIGHT(DepartmentName, 3)    = "ING"        (last 3 positions)
SUBSTRING(DepartmentName, 2, 4) = "NGIN"   (4 chars starting at position 2)
```

---

### Exercise 1.6: Finding Text with CHARINDEX() (🟢 BASIC)

**The Problem**: You need to find where a specific character or word appears in text (like finding "@" in an email).

**The Solution**: Use `CHARINDEX()` to find the position!

```sql
USE TechCorpDB;
GO

-- CHARINDEX(what_to_find, where_to_look)
-- Returns the position number, or 0 if not found

SELECT 
    PrimaryEmail,
    CHARINDEX('@', PrimaryEmail) AS AtPosition  -- Where is the @ symbol?
FROM Companies
WHERE CompanyID <= 5;
```

**Example Result:**
| PrimaryEmail           | AtPosition |
|------------------------|------------|
| info@techcorp.com      | 5          |
| sales@acme.com         | 6          |

💡 **Use Case**: This is super helpful when you need to split emails into username and domain!

---

## Part 2: Number Functions - Doing Math 🔢

### 🎓 What Are Numeric Functions?

These functions help you:
- Round numbers up or down
- Find the absolute value
- Calculate averages
- Do math operations

### Exercise 2.1: Rounding Numbers with ROUND() (🟢 BASIC)

**The Problem**: Salaries show as `75432.5678` but you want nice round numbers for reports.

**The Solution**: Use `ROUND()` to round to a specific number of decimal places!

```sql
USE TechCorpDB;
GO

-- ROUND(number, decimal_places)
-- decimal_places = how many numbers after the decimal point

SELECT 
    FirstName,
    LastName,
    BaseSalary,
    ROUND(BaseSalary, 0) AS RoundedSalary,    -- Round to whole number
    ROUND(BaseSalary, 2) AS TwoDecimals       -- Round to 2 decimal places
FROM Employees
WHERE EmployeeID <= 5;
```

**How ROUND() Works:**
| Original | ROUND(..., 0) | ROUND(..., 2) |
|----------|---------------|---------------|
| 75432.5678 | 75433 | 75432.57 |
| 85000.1234 | 85000 | 85000.12 |

💡 **The Second Number Explained:**
- `0` = No decimal places (whole number)
- `1` = One decimal place (like 75432.6)
- `2` = Two decimal places (like 75432.57)
- `-1` = Round to nearest 10
- `-2` = Round to nearest 100
- `-3` = Round to nearest 1000

---

### Exercise 2.2: Rounding Up and Down with CEILING() and FLOOR() (🟢 BASIC)

**The Problem**: Sometimes you need to always round UP (like calculating how many boxes needed) or always round DOWN.

**The Solution**: Use `CEILING()` and `FLOOR()`!

```sql
USE TechCorpDB;
GO

-- CEILING() always rounds UP to the next whole number
-- FLOOR() always rounds DOWN to the previous whole number

SELECT 
    4.1 AS OriginalNumber,
    CEILING(4.1) AS RoundedUp,    -- Result: 5
    FLOOR(4.1) AS RoundedDown;    -- Result: 4

-- Real example: If each box holds 10 items, how many boxes for 95 items?
SELECT 
    95 AS TotalItems,
    10 AS ItemsPerBox,
    95.0 / 10 AS ExactBoxes,              -- 9.5 boxes
    CEILING(95.0 / 10) AS BoxesNeeded;    -- Need 10 boxes!
```

**Visual Explanation:**
```
Number Line:    4 ----- 4.1 ----- 4.5 ----- 5
                ↓                           ↓
            FLOOR(4.1)                  CEILING(4.1)
              = 4                         = 5
```

---

### Exercise 2.3: Finding Absolute Values with ABS() (🟢 BASIC)

**The Problem**: You're calculating profit/loss and some numbers are negative. You need to know the size without the minus sign.

**The Solution**: Use `ABS()` for absolute value!

```sql
USE TechCorpDB;
GO

-- ABS() removes the negative sign
-- Think of it as "how far from zero" regardless of direction

SELECT 
    -50 AS OriginalNumber,
    ABS(-50) AS AbsoluteValue;  -- Result: 50

-- Real example: Variance from budget (positive or negative)
SELECT 
    ProjectName,
    Budget,
    ActualCost,
    Budget - ActualCost AS Variance,           -- Could be negative
    ABS(Budget - ActualCost) AS AbsoluteGap    -- Always positive
FROM Projects
WHERE ProjectID <= 3;
```

---

## Part 3: Date Functions - Working with Time 📅

### 🎓 What Are Date Functions?

These help you:
- Get today's date
- Find out what day of the week it is
- Calculate how many days between two dates
- Extract the year, month, or day from a date

### Exercise 3.1: Getting Today's Date with GETDATE() (🟢 SUPER BASIC)

```sql
USE TechCorpDB;
GO

-- GETDATE() gives you the current date and time
-- No input needed - it just knows!

SELECT GETDATE() AS RightNow;
```

**Result:** Shows something like `2025-12-04 15:30:45.123`

---

### Exercise 3.2: Extracting Parts of a Date (🟢 BASIC)

**The Problem**: You have a hire date but need to know just the year, or just the month.

**The Solution**: Use `YEAR()`, `MONTH()`, and `DAY()`!

```sql
USE TechCorpDB;
GO

-- These functions pull out specific parts of a date
SELECT 
    FirstName,
    HireDate,
    YEAR(HireDate) AS HireYear,    -- Just the year (e.g., 2023)
    MONTH(HireDate) AS HireMonth,  -- Just the month number (1-12)
    DAY(HireDate) AS HireDay       -- Just the day number (1-31)
FROM Employees
WHERE EmployeeID <= 5;
```

**Example Result:**
| FirstName | HireDate   | HireYear | HireMonth | HireDay |
|-----------|------------|----------|-----------|---------|
| John      | 2023-03-15 | 2023     | 3         | 15      |
| Sarah     | 2022-07-01 | 2022     | 7         | 1       |

💡 **Real-World Use**: "Show me all employees hired in 2023" becomes:
```sql
WHERE YEAR(HireDate) = 2023
```

---

### Exercise 3.3: Getting the Day Name with DATENAME() (🟢 BASIC)

**The Problem**: You want to know what day of the week someone was hired (Monday, Tuesday, etc.).

**The Solution**: Use `DATENAME()`!

```sql
USE TechCorpDB;
GO

-- DATENAME(part, date) returns the name as text
SELECT 
    FirstName,
    HireDate,
    DATENAME(WEEKDAY, HireDate) AS DayOfWeek,   -- Monday, Tuesday, etc.
    DATENAME(MONTH, HireDate) AS MonthName      -- January, February, etc.
FROM Employees
WHERE EmployeeID <= 5;
```

**Example Result:**
| FirstName | HireDate   | DayOfWeek | MonthName |
|-----------|------------|-----------|-----------|
| John      | 2023-03-15 | Wednesday | March     |
| Sarah     | 2022-07-01 | Friday    | July      |

---

### Exercise 3.4: Calculating Time Differences with DATEDIFF() (🟢 BASIC)

**The Problem**: How long has each employee worked at the company?

**The Solution**: Use `DATEDIFF()` to calculate the difference between two dates!

```sql
USE TechCorpDB;
GO

-- DATEDIFF(unit, start_date, end_date)
-- unit = what you're measuring (DAY, MONTH, YEAR)

SELECT 
    FirstName,
    LastName,
    HireDate,
    DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed,
    DATEDIFF(MONTH, HireDate, GETDATE()) AS MonthsEmployed,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsEmployed
FROM Employees
WHERE EmployeeID <= 5;
```

**Understanding DATEDIFF:**
```
DATEDIFF(YEAR, '2020-01-01', '2025-12-04')
         ↑          ↑             ↑
     Measure    Start Date    End Date
        in
      Years
      
Result: 5 (years between the two dates)
```

---

### Exercise 3.5: Adding Time to Dates with DATEADD() (🟢 BASIC)

**The Problem**: When is 90 days from now? When is 1 year from an employee's hire date?

**The Solution**: Use `DATEADD()` to add time to a date!

```sql
USE TechCorpDB;
GO

-- DATEADD(unit, number, date)
-- Adds (or subtracts with negative numbers) time to a date

SELECT 
    GETDATE() AS Today,
    DATEADD(DAY, 30, GETDATE()) AS In30Days,
    DATEADD(MONTH, 6, GETDATE()) AS In6Months,
    DATEADD(YEAR, -1, GETDATE()) AS OneYearAgo;

-- Real example: When is each employee's 1-year anniversary?
SELECT 
    FirstName,
    HireDate,
    DATEADD(YEAR, 1, HireDate) AS FirstAnniversary
FROM Employees
WHERE EmployeeID <= 5;
```

---

## Part 4: Putting It All Together 🎨

### Exercise 4.1: Real Business Report (🟢 BASIC)

Let's create a simple employee report using multiple functions:

```sql
USE TechCorpDB;
GO

-- Create a nice employee summary using several functions
SELECT 
    -- Full name in uppercase
    UPPER(CONCAT(FirstName, ' ', LastName)) AS EmployeeName,
    
    -- Department name
    d.DepartmentName,
    
    -- Salary rounded to nearest thousand
    ROUND(e.BaseSalary, -3) AS RoundedSalary,
    
    -- Hire information
    DATENAME(WEEKDAY, e.HireDate) AS HiredOnDay,
    DATENAME(MONTH, e.HireDate) AS HiredInMonth,
    YEAR(e.HireDate) AS HiredInYear,
    
    -- Years at company
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsAtCompany
    
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 10;
```

**This Report Shows:**
- Employee names in caps
- Their department
- Salary rounded nicely
- What day and month they were hired
- How many years they've worked

---

## 📋 Quick Reference Card 🃏

### Text (String) Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `UPPER(text)` | Makes text UPPERCASE | `UPPER('hello')` → `'HELLO'` |
| `LOWER(text)` | Makes text lowercase | `LOWER('HELLO')` → `'hello'` |
| `LEN(text)` | Counts characters | `LEN('hello')` → `5` |
| `CONCAT(a, b, ...)` | Joins text together | `CONCAT('Hi', ' ', 'there')` → `'Hi there'` |
| `LEFT(text, n)` | First n characters | `LEFT('hello', 2)` → `'he'` |
| `RIGHT(text, n)` | Last n characters | `RIGHT('hello', 2)` → `'lo'` |
| `SUBSTRING(text, start, len)` | Extract middle part | `SUBSTRING('hello', 2, 3)` → `'ell'` |
| `CHARINDEX(find, text)` | Find position | `CHARINDEX('l', 'hello')` → `3` |

### Number Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `ROUND(num, places)` | Rounds to decimal places | `ROUND(3.14159, 2)` → `3.14` |
| `CEILING(num)` | Always rounds UP | `CEILING(4.1)` → `5` |
| `FLOOR(num)` | Always rounds DOWN | `FLOOR(4.9)` → `4` |
| `ABS(num)` | Removes negative sign | `ABS(-5)` → `5` |

### Date Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `GETDATE()` | Current date/time | Returns now |
| `YEAR(date)` | Extracts the year | `YEAR('2025-12-04')` → `2025` |
| `MONTH(date)` | Extracts the month | `MONTH('2025-12-04')` → `12` |
| `DAY(date)` | Extracts the day | `DAY('2025-12-04')` → `4` |
| `DATENAME(part, date)` | Gets name (weekday, month) | `DATENAME(WEEKDAY, '2025-12-04')` → `'Thursday'` |
| `DATEDIFF(unit, start, end)` | Difference between dates | `DATEDIFF(DAY, '2025-01-01', '2025-01-10')` → `9` |
| `DATEADD(unit, num, date)` | Add time to date | `DATEADD(MONTH, 1, '2025-01-15')` → `'2025-02-15'` |

---

## 📋 What You've Learned

Congratulations! 🎉 You now know:

✅ **What functions are** – Pre-built tools that process your data  
✅ **Text functions** – UPPER, LOWER, LEN, CONCAT, LEFT, RIGHT, SUBSTRING, CHARINDEX  
✅ **Number functions** – ROUND, CEILING, FLOOR, ABS  
✅ **Date functions** – GETDATE, YEAR, MONTH, DAY, DATENAME, DATEDIFF, DATEADD  
✅ **How to combine functions** – Use multiple functions in one query  

---

## 🚀 Practice Exercises

Try these on your own:

1. **Easy**: Write a query to show all department names in lowercase
2. **Easy**: Find the length of each project name
3. **Medium**: Show employee full names with how many days they've worked
4. **Medium**: Round all salaries to the nearest hundred dollars
5. **Medium**: Find the first 5 characters of each company name
6. **Challenge**: Show employees hired on a Friday

---

## 🚀 Ready for More?

Great job mastering the basics! In the next lesson (**Lesson 2: Conversion and System Functions**), you'll learn how to:
- Convert between different data types (text to numbers, numbers to dates)
- Handle special cases and errors safely
- Use system information in your queries

**Next up**: Lesson 2 - Conversion and System Functions (Beginner)
