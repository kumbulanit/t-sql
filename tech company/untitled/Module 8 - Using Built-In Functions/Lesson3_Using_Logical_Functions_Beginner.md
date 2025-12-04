# Lesson 3: Using Logical Functions - Beginner Lesson

## 🎯 What You'll Learn (🟢 COMPLETE BEGINNER LEVEL)

Welcome! In this lesson, you'll learn about **logical functions** – these let you make decisions in your SQL queries. Think of it like teaching your database to say "IF this, THEN do that!"

**No programming experience needed** – we'll explain everything with real-world examples.

---

## 📖 What Are Logical Functions?

### The Simple Explanation

Logical functions help you:
- Make YES/NO decisions
- Choose between different values
- Apply business rules to your data
- Create custom categories

**Real-World Analogy 🏠**

Imagine you're sorting mail:
- IF the envelope is a bill → Put in "Bills" folder
- IF the envelope is a card → Put in "Personal" folder  
- IF anything else → Put in "Other" folder

SQL logical functions work the same way!

---

## 📖 What You'll Discover

After this lesson, you'll be able to:

✅ Use CASE statements to create custom categories  
✅ Use IIF for simple yes/no decisions  
✅ Apply business rules in your queries  
✅ Create calculated columns based on conditions  

---

## Part 1: The CASE Statement - Your Decision Maker 🔀

### 🎓 Understanding CASE

The `CASE` statement is like a series of IF-THEN rules. It checks conditions and returns different values based on what it finds.

**Basic Structure:**
```sql
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

Think of it as:
- "Check condition1 – if true, give result1"
- "Otherwise, check condition2 – if true, give result2"
- "If nothing matches, give default_result"

---

### Exercise 1.1: Simple CASE - Categorizing Salaries (🟢 SUPER BASIC)

**The Problem**: You want to label each employee's salary as "High", "Medium", or "Low".

**The Solution**: Use CASE to create categories!

```sql
USE TechCorpDB;
GO

SELECT 
    FirstName,
    LastName,
    BaseSalary,
    CASE 
        WHEN BaseSalary >= 100000 THEN 'High'
        WHEN BaseSalary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees
WHERE EmployeeID <= 10;
```

**How It Works Step by Step:**

For an employee earning $85,000:
1. Check: Is 85000 >= 100000? NO → Skip "High"
2. Check: Is 85000 >= 60000? YES → Return "Medium" ✓
3. (Stop checking – we found a match!)

**Expected Result:**
| FirstName | LastName | BaseSalary | SalaryCategory |
|-----------|----------|------------|----------------|
| John      | Smith    | 120000     | High           |
| Sarah     | Johnson  | 85000      | Medium         |
| Mike      | Williams | 55000      | Low            |

💡 **Important**: CASE checks conditions IN ORDER and stops at the first match!

---

### Exercise 1.2: CASE with Multiple Categories (🟢 BASIC)

**The Problem**: Create employee tenure categories based on how long they've worked.

```sql
USE TechCorpDB;
GO

SELECT 
    FirstName,
    LastName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsWorked,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 3 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 10 THEN 'Senior'
        ELSE 'Veteran'
    END AS ExperienceLevel
FROM Employees
WHERE EmployeeID <= 10;
```

**Visual Timeline:**
```
Years:     0        1        3        5        10       
           |--------|--------|--------|--------|--------|
Category:  New Hire   Junior   Mid-Lvl   Senior    Veteran
```

---

### Exercise 1.3: Simple CASE - Matching Specific Values (🟢 BASIC)

**The Problem**: Different departments have different bonus percentages. Show the bonus rate for each employee.

```sql
USE TechCorpDB;
GO

-- Simple CASE checks one value against multiple options
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    CASE d.DepartmentName
        WHEN 'Sales' THEN '15%'
        WHEN 'Engineering' THEN '12%'
        WHEN 'Marketing' THEN '10%'
        WHEN 'Human Resources' THEN '8%'
        ELSE '5%'
    END AS BonusRate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 10;
```

**Two Types of CASE:**
```sql
-- "Searched CASE" - checks any condition
CASE 
    WHEN salary > 100000 THEN 'High'
    WHEN department = 'Sales' THEN 'Sales Team'
END

-- "Simple CASE" - checks one value against many options
CASE department
    WHEN 'Sales' THEN 'Sales Team'
    WHEN 'Engineering' THEN 'Tech Team'
END
```

---

### Exercise 1.4: CASE in ORDER BY (🟢 BASIC)

**The Problem**: You want to sort employees with a custom order – managers first, then by name.

```sql
USE TechCorpDB;
GO

SELECT 
    FirstName,
    LastName,
    JobTitle,
    BaseSalary
FROM Employees
WHERE EmployeeID <= 20
ORDER BY 
    CASE 
        WHEN JobTitle LIKE '%Manager%' THEN 1
        WHEN JobTitle LIKE '%Lead%' THEN 2
        WHEN JobTitle LIKE '%Senior%' THEN 3
        ELSE 4
    END,
    LastName;
```

**This Sorts:**
1. First: All Managers (sorted by LastName)
2. Then: All Leads (sorted by LastName)
3. Then: All Seniors (sorted by LastName)
4. Finally: Everyone else (sorted by LastName)

---

## Part 2: The IIF Function - Quick Yes/No Decisions ✅❌

### 🎓 Understanding IIF

`IIF` is a shortcut for simple two-option decisions. It's like a mini-CASE statement.

**Structure:**
```sql
IIF(condition, value_if_true, value_if_false)
```

Think: "IF this is true, THEN this, ELSE that"

---

### Exercise 2.1: Simple IIF - Active/Inactive Status (🟢 SUPER BASIC)

```sql
USE TechCorpDB;
GO

-- IIF is perfect for yes/no situations
SELECT 
    FirstName,
    LastName,
    IsActive,
    IIF(IsActive = 1, 'Active', 'Inactive') AS Status
FROM Employees
WHERE EmployeeID <= 10;
```

**Comparison:**
```sql
-- IIF version (shorter):
IIF(IsActive = 1, 'Active', 'Inactive')

-- CASE version (longer):
CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END
```

💡 **Use IIF** when you only have 2 options. **Use CASE** when you have more than 2.

---

### Exercise 2.2: IIF for Calculations (🟢 BASIC)

**The Problem**: Calculate bonus – give 10% bonus to high performers, 5% to others.

```sql
USE TechCorpDB;
GO

SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary,
    pr.OverallRating,
    
    -- Calculate bonus based on performance rating
    IIF(pr.OverallRating >= 4, 
        e.BaseSalary * 0.10,  -- 10% for high performers
        e.BaseSalary * 0.05   -- 5% for others
    ) AS BonusAmount
    
FROM Employees e
LEFT JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
WHERE e.EmployeeID <= 10;
```

---

### Exercise 2.3: Nested IIF (🟢 BASIC)

**The Problem**: You need 3 categories but IIF only handles 2. Can you nest them?

```sql
USE TechCorpDB;
GO

-- You CAN nest IIF, but it gets messy
SELECT 
    FirstName,
    BaseSalary,
    IIF(BaseSalary >= 100000, 'High',
        IIF(BaseSalary >= 60000, 'Medium', 'Low')
    ) AS SalaryLevel
FROM Employees
WHERE EmployeeID <= 10;
```

⚠️ **Warning**: Nested IIF is hard to read! For 3+ options, use CASE instead:

```sql
-- Much cleaner with CASE:
CASE 
    WHEN BaseSalary >= 100000 THEN 'High'
    WHEN BaseSalary >= 60000 THEN 'Medium'
    ELSE 'Low'
END
```

---

## Part 3: CHOOSE Function - Pick from a List 📋

### 🎓 Understanding CHOOSE

`CHOOSE` picks an item from a list based on position number.

**Structure:**
```sql
CHOOSE(position, option1, option2, option3, ...)
```

---

### Exercise 3.1: CHOOSE for Day Names (🟢 BASIC)

```sql
USE TechCorpDB;
GO

-- DATEPART(WEEKDAY, date) returns 1-7 for Sunday-Saturday
-- CHOOSE picks from a list based on that number

SELECT 
    FirstName,
    HireDate,
    DATEPART(WEEKDAY, HireDate) AS DayNumber,
    CHOOSE(DATEPART(WEEKDAY, HireDate),
        'Sunday', 'Monday', 'Tuesday', 'Wednesday', 
        'Thursday', 'Friday', 'Saturday'
    ) AS DayHired
FROM Employees
WHERE EmployeeID <= 10;
```

**How CHOOSE Works:**
```
CHOOSE(3, 'A', 'B', 'C', 'D')
        ↑   ↑    ↑    ↑    ↑
        |   1    2    3    4
        |             ↓
        └───────→ Returns 'C' (3rd item)
```

---

### Exercise 3.2: CHOOSE for Rating Labels (🟢 BASIC)

```sql
USE TechCorpDB;
GO

-- Convert numeric ratings to text descriptions
SELECT 
    e.FirstName,
    e.LastName,
    pr.OverallRating,
    CHOOSE(pr.OverallRating,
        'Poor',           -- 1
        'Below Average',  -- 2
        'Average',        -- 3
        'Good',           -- 4
        'Excellent'       -- 5
    ) AS RatingDescription
FROM Employees e
INNER JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
WHERE e.EmployeeID <= 10;
```

---

## Part 4: Combining Logical Functions 🎨

### Exercise 4.1: Real Business Report (🟢 BASIC)

Let's create an employee dashboard combining multiple logical functions:

```sql
USE TechCorpDB;
GO

SELECT 
    -- Employee info
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    d.DepartmentName,
    
    -- Status using IIF
    IIF(e.IsActive = 1, '✓ Active', '✗ Inactive') AS Status,
    
    -- Salary category using CASE
    FORMAT(e.BaseSalary, 'C') AS Salary,
    CASE 
        WHEN e.BaseSalary >= 100000 THEN '💰 High Earner'
        WHEN e.BaseSalary >= 70000 THEN '📊 Mid Range'
        ELSE '📈 Growth Potential'
    END AS SalaryTier,
    
    -- Tenure category
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN '⭐ Veteran'
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN '🔷 Experienced'
        ELSE '🆕 New'
    END AS TenureLevel,
    
    -- Day of week hired using CHOOSE
    CHOOSE(DATEPART(WEEKDAY, e.HireDate),
        'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
    ) AS HiredOn

FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID <= 15
ORDER BY 
    CASE WHEN e.IsActive = 1 THEN 0 ELSE 1 END,  -- Active employees first
    e.BaseSalary DESC;
```

---

## 📋 Quick Reference Card 🃏

### CASE Statement
```sql
-- Searched CASE (any conditions):
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END

-- Simple CASE (checking one value):
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

### IIF Function
```sql
-- Two-option shortcut:
IIF(condition, true_value, false_value)

-- Example:
IIF(salary > 50000, 'Good', 'Low')
```

### CHOOSE Function
```sql
-- Pick from a list by position:
CHOOSE(index, option1, option2, option3, ...)

-- Example (index 2 returns 'B'):
CHOOSE(2, 'A', 'B', 'C')  → 'B'
```

### When to Use What?
| Situation | Use This |
|-----------|----------|
| Two options only | `IIF()` |
| Multiple conditions | `CASE WHEN` |
| One value, many matches | `CASE value WHEN` |
| Pick by position number | `CHOOSE()` |

---

## 📋 What You've Learned

Congratulations! 🎉 You now know:

✅ **CASE statements** – Make complex decisions with multiple conditions  
✅ **IIF function** – Quick two-option decisions  
✅ **CHOOSE function** – Pick from a list by position  
✅ **Combining functions** – Create powerful business logic  
✅ **Using CASE in ORDER BY** – Custom sorting  

---

## 🚀 Practice Exercises

1. **Easy**: Use IIF to show "Yes" if an employee is active, "No" if not
2. **Easy**: Use CASE to label salaries under $50K as "Entry Level"
3. **Medium**: Create categories for project budgets (Small/Medium/Large)
4. **Medium**: Show performance ratings as stars (★★★★★ for rating 5)
5. **Challenge**: Create a report that sorts by department priority AND salary

---

## 🚀 Ready for More?

Great job! In the next lesson (**Lesson 4: Working with NULL**), you'll learn how to:
- Handle missing data professionally
- Use ISNULL, COALESCE, and NULLIF effectively
- Prevent NULL-related errors in calculations

**Next up**: Lesson 4 - Using Functions to Work with NULL (Beginner)
