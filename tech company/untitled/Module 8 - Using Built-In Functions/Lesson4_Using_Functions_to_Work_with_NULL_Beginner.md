# Lesson 4: Using Functions to Work with NULL - Beginner Lesson

## 🎯 What You'll Learn (🟢 COMPLETE BEGINNER LEVEL)

Welcome! In this lesson, you'll learn about **NULL values** – the concept of "missing" or "unknown" data – and how to handle them properly in SQL.

**No programming experience needed** – we'll explain everything clearly!

---

## 📖 What Is NULL?

### The Simple Explanation

**NULL** means "we don't know" or "no value exists." It's NOT:
- Zero (0)
- An empty string ('')
- The word "null"

**Real-World Analogy 🏠**

Imagine a form asking for your middle name:
- You write "James" → That's a value
- You leave it blank → That's NULL (unknown/not provided)
- You write nothing ("") → That's an empty string (you answered, but with nothing)

```
Question: What is your middle name?
- "James"  = Has a value
- NULL     = Question wasn't answered / Unknown
- ""       = Answered, but it's empty
```

---

## 📖 Why NULL Can Be Tricky

### The Problem with NULL

NULL behaves differently than other values:

```sql
-- Normal comparison works:
5 = 5          -- TRUE ✓
5 = 10         -- FALSE ✓

-- But NULL is weird:
NULL = NULL    -- Not TRUE! It's "Unknown" 🤔
NULL = 5       -- Not FALSE! It's "Unknown" 🤔
```

**Why?** Because if you don't know two values, you can't say they're equal OR different!

Think about it: "Is the number I'm thinking of equal to the number you're thinking of?"
- Answer: "I don't know" (not yes, not no – just unknown!)

---

## 📖 What You'll Discover

After this lesson, you'll be able to:

✅ Understand what NULL means and why it's special  
✅ Test for NULL values correctly  
✅ Replace NULL with meaningful values  
✅ Handle NULL in calculations  
✅ Use NULL strategically in your queries  

---

## Part 1: Testing for NULL - IS NULL and IS NOT NULL 🔍

### 🎓 The Golden Rule

**Never use `= NULL` or `!= NULL`**. These don't work!

```sql
-- WRONG ❌ (will NOT find NULLs!)
WHERE MiddleName = NULL

-- RIGHT ✓
WHERE MiddleName IS NULL
```

---

### Exercise 1.1: Finding NULL Values (🟢 SUPER BASIC)

**The Problem**: Find all employees who don't have a middle name on file.

```sql
USE TechCorpDB;
GO

-- Find employees with NULL middle names
SELECT 
    FirstName,
    LastName,
    MiddleName
FROM Employees
WHERE MiddleName IS NULL;
```

**Result:** Shows employees where MiddleName has no value (NULL)

---

### Exercise 1.2: Finding Non-NULL Values (🟢 SUPER BASIC)

**The Problem**: Find all employees who DO have a middle name.

```sql
USE TechCorpDB;
GO

-- Find employees WITH middle names
SELECT 
    FirstName,
    LastName,
    MiddleName
FROM Employees
WHERE MiddleName IS NOT NULL;
```

---

### Exercise 1.3: Counting NULLs (🟢 BASIC)

**The Problem**: How many employees are missing phone numbers?

```sql
USE TechCorpDB;
GO

SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END) AS MissingMiddleName,
    SUM(CASE WHEN MiddleName IS NOT NULL THEN 1 ELSE 0 END) AS HasMiddleName
FROM Employees;
```

💡 **Note**: `COUNT(column)` automatically skips NULLs, but `COUNT(*)` counts all rows!

```sql
-- These give different results if there are NULLs:
SELECT 
    COUNT(*) AS AllRows,           -- Counts everything
    COUNT(MiddleName) AS NonNulls  -- Skips NULLs
FROM Employees;
```

---

## Part 2: ISNULL - Replace NULL with a Default Value 🔄

### 🎓 Understanding ISNULL

`ISNULL(value, replacement)` says: "If this value is NULL, use the replacement instead."

**Structure:**
```sql
ISNULL(possibly_null_value, what_to_use_if_null)
```

---

### Exercise 2.1: Basic ISNULL (🟢 SUPER BASIC)

**The Problem**: Show "N/A" instead of empty space for missing middle names.

```sql
USE TechCorpDB;
GO

SELECT 
    FirstName,
    LastName,
    MiddleName,                               -- Shows NULL as blank
    ISNULL(MiddleName, 'N/A') AS DisplayName  -- Shows 'N/A' instead
FROM Employees
WHERE EmployeeID <= 10;
```

**Result:**
| FirstName | LastName | MiddleName | DisplayName |
|-----------|----------|------------|-------------|
| John      | Smith    | NULL       | N/A         |
| Sarah     | Johnson  | Marie      | Marie       |
| Michael   | Williams | NULL       | N/A         |

---

### Exercise 2.2: ISNULL with Numbers (🟢 BASIC)

**The Problem**: Calculate total compensation, but some employees don't have bonus data (NULL).

```sql
USE TechCorpDB;
GO

-- Without ISNULL: NULL + anything = NULL!
-- With ISNULL: Replace NULL bonus with 0

SELECT 
    FirstName,
    LastName,
    BaseSalary,
    BonusAmount,
    BaseSalary + ISNULL(BonusAmount, 0) AS TotalCompensation
FROM Employees e
LEFT JOIN (
    SELECT EmployeeID, SUM(Amount) AS BonusAmount 
    FROM Bonuses 
    GROUP BY EmployeeID
) b ON e.EmployeeID = b.EmployeeID
WHERE e.EmployeeID <= 10;
```

💡 **Key Insight**: In math, `NULL + 100 = NULL`. That's why ISNULL is essential!

```
50000 + NULL = NULL   ← Without ISNULL (wrong!)
50000 + 0 = 50000     ← With ISNULL(NULL, 0) (correct!)
```

---

### Exercise 2.3: ISNULL for Display Formatting (🟢 BASIC)

**The Problem**: Make a clean report where missing data shows dashes.

```sql
USE TechCorpDB;
GO

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    ISNULL(d.DepartmentName, '-- Unassigned --') AS Department,
    ISNULL(CAST(e.BaseSalary AS VARCHAR), '-- Not Set --') AS Salary,
    ISNULL(FORMAT(e.HireDate, 'yyyy-MM-dd'), '-- Unknown --') AS HireDate
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 15;
```

---

## Part 3: COALESCE - Find the First Non-NULL Value 🎯

### 🎓 Understanding COALESCE

`COALESCE` checks multiple values and returns the FIRST one that isn't NULL.

**Structure:**
```sql
COALESCE(value1, value2, value3, ..., default)
```

Think: "Try value1, if NULL try value2, if NULL try value3..."

---

### Exercise 3.1: Basic COALESCE (🟢 BASIC)

**The Problem**: Show the best contact method – prefer email, then phone, then show "No Contact".

```sql
USE TechCorpDB;
GO

-- Try email first, then phone, then default message
SELECT 
    CompanyName,
    PrimaryEmail,
    PrimaryPhone,
    COALESCE(PrimaryEmail, PrimaryPhone, 'No Contact Info') AS BestContact
FROM Companies
WHERE CompanyID <= 10;
```

**How COALESCE Works:**
```
COALESCE('john@email.com', '555-1234', 'None')
         ↓
Returns 'john@email.com' (first non-NULL)

COALESCE(NULL, '555-1234', 'None')
         ↓
Returns '555-1234' (second value, since first was NULL)

COALESCE(NULL, NULL, 'None')
         ↓
Returns 'None' (only non-NULL option)
```

---

### Exercise 3.2: COALESCE vs ISNULL (🟢 BASIC)

```sql
USE TechCorpDB;
GO

-- ISNULL can only check 2 values
SELECT ISNULL(NULL, ISNULL(NULL, 'default')) AS NestedISNULL;

-- COALESCE checks as many as you want (cleaner!)
SELECT COALESCE(NULL, NULL, NULL, 'default') AS SimpleCoalesce;
```

**When to Use Which:**
| Situation | Use This |
|-----------|----------|
| Replace one NULL with one default | ISNULL |
| Check multiple values in order | COALESCE |
| Need exactly 2 options | Either works |
| Need 3+ options | COALESCE |

---

### Exercise 3.3: Real-World COALESCE (🟢 BASIC)

**The Problem**: Show employee phone numbers – try work phone, then cell, then home.

```sql
USE TechCorpDB;
GO

SELECT 
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    WorkPhone,
    CellPhone,
    HomePhone,
    COALESCE(WorkPhone, CellPhone, HomePhone, 'No Phone Available') AS ContactNumber
FROM Employees e
LEFT JOIN EmployeeContacts ec ON e.EmployeeID = ec.EmployeeID
WHERE e.EmployeeID <= 10;
```

---

## Part 4: NULLIF - Turn a Value INTO NULL 🔀

### 🎓 Understanding NULLIF

`NULLIF` does the opposite of ISNULL – it CREATES NULL when two values match.

**Structure:**
```sql
NULLIF(value1, value2)
-- If value1 = value2, return NULL
-- Otherwise, return value1
```

---

### Exercise 4.1: Basic NULLIF (🟢 BASIC)

```sql
USE TechCorpDB;
GO

-- NULLIF returns NULL when both values are equal
SELECT 
    NULLIF(5, 5) AS SameValues,      -- Returns NULL (5 = 5)
    NULLIF(5, 10) AS DifferentValues; -- Returns 5 (5 ≠ 10)
```

---

### Exercise 4.2: NULLIF to Prevent Division by Zero (🟢 BASIC) ⭐

**The Problem**: Dividing by zero crashes your query! NULLIF can prevent this.

```sql
USE TechCorpDB;
GO

-- Without NULLIF: Division by zero = ERROR!
-- SELECT 100 / 0;  -- This crashes!

-- With NULLIF: Division by NULL = NULL (safe!)
SELECT 
    100 / NULLIF(0, 0) AS SafeDivision;  -- Returns NULL, not an error!

-- Real example: Calculate cost per employee
SELECT 
    d.DepartmentName,
    d.Budget,
    COUNT(e.EmployeeID) AS EmployeeCount,
    d.Budget / NULLIF(COUNT(e.EmployeeID), 0) AS BudgetPerEmployee
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName, d.Budget;
```

**Why This Works:**
```
Budget / 0       = ERROR! 💥
Budget / NULL    = NULL (safe) ✓

NULLIF(0, 0) = NULL
So: Budget / NULLIF(0, 0) = Budget / NULL = NULL ✓
```

---

### Exercise 4.3: NULLIF to Clean Data (🟢 BASIC)

**The Problem**: Some systems store "N/A" or "Unknown" as text, but you want to treat them as NULL.

```sql
USE TechCorpDB;
GO

-- Turn placeholder values into proper NULLs
SELECT 
    CompanyName,
    PrimaryPhone,
    NULLIF(PrimaryPhone, 'N/A') AS CleanedPhone,
    NULLIF(NULLIF(PrimaryPhone, 'N/A'), 'Unknown') AS DoubleCleanedPhone
FROM Companies
WHERE CompanyID <= 10;
```

---

## Part 5: NULL in Aggregations and Sorting 📊

### Exercise 5.1: How NULL Affects COUNT and AVG (🟢 BASIC)

```sql
USE TechCorpDB;
GO

-- NULL values are IGNORED by aggregate functions
SELECT 
    COUNT(*) AS TotalRows,              -- Counts all rows
    COUNT(MiddleName) AS NonNullCount,  -- Skips NULLs
    COUNT(*) - COUNT(MiddleName) AS NullCount
FROM Employees;

-- AVG also ignores NULLs
-- If you have: 100, 200, NULL, 400
-- AVG = (100 + 200 + 400) / 3 = 233.33
-- NOT: (100 + 200 + 0 + 400) / 4 = 175
```

💡 **Important**: If you WANT NULLs treated as 0, use ISNULL:
```sql
AVG(ISNULL(BonusAmount, 0))  -- Treats NULL as 0
```

---

### Exercise 5.2: NULL in Sorting (🟢 BASIC)

**The Problem**: Where do NULLs appear when sorting?

```sql
USE TechCorpDB;
GO

-- By default, NULLs sort first in ascending order
SELECT 
    FirstName,
    LastName,
    MiddleName
FROM Employees
ORDER BY MiddleName ASC;  -- NULLs appear first

-- To put NULLs last:
SELECT 
    FirstName,
    LastName,
    MiddleName
FROM Employees
ORDER BY 
    CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END,  -- NULLs get 1, others get 0
    MiddleName ASC;
```

---

## Part 6: Putting It All Together 🎨

### Exercise 6.1: Complete Employee Report (🟢 BASIC)

```sql
USE TechCorpDB;
GO

SELECT 
    -- Name with NULL handling
    CONCAT(
        FirstName, 
        ' ',
        COALESCE(MiddleName + ' ', ''),  -- Add middle name + space if exists
        LastName
    ) AS FullName,
    
    -- Department with default
    ISNULL(d.DepartmentName, 'Unassigned') AS Department,
    
    -- Salary with NULL protection
    FORMAT(ISNULL(e.BaseSalary, 0), 'C') AS Salary,
    
    -- Years employed (handle NULL hire date)
    CASE 
        WHEN e.HireDate IS NULL THEN 'Unknown'
        ELSE CAST(DATEDIFF(YEAR, e.HireDate, GETDATE()) AS VARCHAR) + ' years'
    END AS Tenure,
    
    -- Data quality indicator
    CASE 
        WHEN e.MiddleName IS NULL AND e.HireDate IS NULL THEN '⚠️ Incomplete'
        WHEN e.MiddleName IS NULL OR e.HireDate IS NULL THEN '📝 Partial'
        ELSE '✓ Complete'
    END AS DataQuality

FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 15
ORDER BY 
    CASE WHEN e.HireDate IS NULL THEN 1 ELSE 0 END,
    e.HireDate DESC;
```

---

## 📋 Quick Reference Card 🃏

### Testing for NULL
```sql
-- Correct way:
WHERE column IS NULL
WHERE column IS NOT NULL

-- WRONG (doesn't work!):
WHERE column = NULL    ❌
WHERE column != NULL   ❌
```

### NULL Handling Functions
| Function | What It Does | Example |
|----------|--------------|---------|
| `ISNULL(a, b)` | If a is NULL, use b | `ISNULL(NULL, 'default')` → `'default'` |
| `COALESCE(a,b,c...)` | First non-NULL | `COALESCE(NULL, NULL, 'c')` → `'c'` |
| `NULLIF(a, b)` | If a=b, return NULL | `NULLIF(0, 0)` → `NULL` |

### NULL Behavior
| Operation | Result |
|-----------|--------|
| `NULL + 100` | NULL |
| `NULL = NULL` | Unknown (not TRUE!) |
| `COUNT(*)` | Counts all rows |
| `COUNT(column)` | Skips NULLs |
| `AVG(column)` | Ignores NULLs |

### Practical Patterns
```sql
-- Safe division (prevent divide by zero):
value / NULLIF(divisor, 0)

-- Default for display:
ISNULL(column, 'N/A')

-- Best of multiple options:
COALESCE(preferred, backup, fallback, 'default')

-- Clean placeholder text:
NULLIF(column, 'Unknown')
```

---

## 📋 What You've Learned

Congratulations! 🎉 You now know:

✅ **What NULL means** – Unknown/missing data, not zero or empty  
✅ **IS NULL / IS NOT NULL** – The correct way to test for NULL  
✅ **ISNULL()** – Replace NULL with a default value  
✅ **COALESCE()** – Find the first non-NULL value  
✅ **NULLIF()** – Turn specific values into NULL (great for division!)  
✅ **NULL in aggregations** – How COUNT, AVG, etc. handle NULL  

---

## 🚀 Practice Exercises

1. **Easy**: Find all companies without a phone number
2. **Easy**: Show "No Email" for companies with NULL email addresses
3. **Medium**: Calculate average salary, treating NULL as $40,000
4. **Medium**: Show best contact (email → phone → address → "No contact")
5. **Challenge**: Create a data quality report showing % of NULL values per column

---

## 🎓 Module 8 Complete!

You've finished all four lessons in Module 8: Using Built-In Functions!

**What You've Mastered:**
- ✅ String Functions (text manipulation)
- ✅ Number Functions (math operations)
- ✅ Date Functions (working with dates)
- ✅ Conversion Functions (changing data types)
- ✅ Logical Functions (CASE, IIF, CHOOSE)
- ✅ NULL Handling Functions (ISNULL, COALESCE, NULLIF)

**Next Module**: Module 9 - Grouping and Aggregating Data
