# Module 9 - Quick Reference Guide: Combining Skills

## 🎯 Your SQL Skills Combination Cheat Sheet (🟢 BEGINNER LEVEL)

This guide shows you exactly how to combine your Module 9 skills with everything you learned in Modules 3-8. Use this as a quick reference while practicing!

---

## 📋 Module Combinations Quick Reference

### Module 3 + Module 9: SELECT with Aggregates
**What you combine:** Basic queries + counting/adding

```sql
-- Basic pattern:
SELECT 
    COUNT(*) AS 'Friendly Name',
    SUM(column) AS 'Total Amount',
    AVG(column) AS 'Average'
FROM TableName;

-- With CASE expressions:
SELECT 
    COUNT(CASE WHEN condition THEN 1 END) AS 'Count of Specific Items'
FROM TableName;
```

### Module 4 + Module 9: JOIN with GROUP BY
**What you combine:** Connecting tables + grouping results

```sql
-- Basic pattern:
SELECT 
    t1.CategoryColumn,
    COUNT(t2.ID) AS 'Count'
FROM Table1 t1
INNER JOIN Table2 t2 ON t1.ID = t2.ForeignID
GROUP BY t1.CategoryColumn;
```

### Module 5 + Module 9: WHERE + HAVING
**What you combine:** Filtering rows and groups

```sql
-- Basic pattern:
SELECT 
    CategoryColumn,
    COUNT(*) AS 'Count'
FROM TableName
WHERE condition_for_rows        -- Filter rows first
GROUP BY CategoryColumn
HAVING COUNT(*) > number        -- Filter groups second
ORDER BY COUNT(*) DESC;
```

### Module 6 + Module 8 + Module 9: Dates + Functions + Grouping
**What you combine:** Date handling + math + grouping

```sql
-- Basic pattern:
SELECT 
    YEAR(DateColumn) AS 'Year',
    COUNT(*) AS 'Count per Year'
FROM TableName
WHERE DateColumn IS NOT NULL
GROUP BY YEAR(DateColumn)
ORDER BY YEAR(DateColumn);
```

---

## 🔧 Common Patterns You'll Use

### Pattern 1: d.DepartmentName Analysis
```sql
SELECT d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(*) > 2;
```

### Mistake 2: Selecting non-grouped columns
```sql
-- WRONG:
SELECT d.DepartmentName, EmployeeName, COUNT(*)
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- RIGHT:
SELECT d.DepartmentName, COUNT(*)
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
```

### Mistake 3: Using WHERE for group conditions
```sql
-- WRONG:
SELECT d.DepartmentName, COUNT(*)
FROM Employees e
WHERE COUNT(*) > 2
GROUP BY d.DepartmentName;

-- RIGHT:
SELECT d.DepartmentName, COUNT(*)
FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(*) > 2;
```

---

## 🎯 Practice Checklist

Use this to track your progress:

**Basic Combinations:**
- [ ] COUNT with basic SELECT
- [ ] SUM/AVG with formatting
- [ ] GROUP BY with one column
- [ ] Simple INNER JOIN with GROUP BY

**Intermediate Combinations:**
- [ ] WHERE + GROUP BY + HAVING
- [ ] Multiple table JOINs with GROUP BY
- [ ] Date functions with GROUP BY
- [ ] CASE expressions with aggregates

**Advanced Combinations:**
- [ ] Multi-level grouping (multiple columns)
- [ ] Complex date analysis with DATEDIFF
- [ ] String functions with grouping
- [ ] Business intelligence style reports

**Real-World Applications:**
- [ ] d.DepartmentName analysis reports
- [ ] Client value analysis
- [ ] Time trend analysis
- [ ] Performance dashboards

---

## 💡 Tips for Success

1. **Start simple** - Master one combination before moving to the next
2. **Use real questions** - Always ask "What business question am I answering?"
3. **Check your logic** - Does the result make business sense?
4. **Format results** - Use FORMAT() to make numbers readable
5. **Comment your code** - Add comments explaining what you're doing

**Remember the SQL order:**
```
SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY
```

**Key Takeaway:** These combinations turn simple SQL skills into powerful business analysis tools!