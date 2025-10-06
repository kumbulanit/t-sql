# Lesson 2: Understanding Sets

## Overview
In T-SQL, understanding sets is fundamental to writing effective queries. SQL is based on set theory, where tables represent sets of data and operations are performed on these sets. This lesson covers set operations, set-based thinking, and how to work with sets in T-SQL.

## What are Sets in SQL?

A set in SQL context is a collection of distinct elements (rows) with no inherent order. Tables in relational databases represent sets, and SQL operations work on these sets to produce new sets as results.

### Visual Representation of Sets
```
Set A (Employees)          Set B (Customers)
┌─────────────────┐       ┌─────────────────┐
│                 │       │                 │
│   John Smith    │       │   Jane Doe      │
│   Mary Johnson  │       │   Bob Wilson    │
│   David Brown   │       │   Sarah Davis   │
│                 │       │                 │
└─────────────────┘       └─────────────────┘
```

### Key Set Properties:
- **Uniqueness**: No duplicate elements (rows)
- **No Order**: Sets have no inherent sequence
- **Operations**: Union, Intersection, Difference
- **Predicates**: Membership testing (IN, EXISTS)

## Set Operations in T-SQL

### Set Operations Visualized

#### 1. UNION - Combining Sets
```
Set A ∪ Set B (UNION)
┌─────────────────────────────────────┐
│                                     │
│  ┌─────────────┐ ┌─────────────┐    │
│  │    Set A    │ │    Set B    │    │
│  │             │ │             │    │
│  │  Elements   │ │  Elements   │    │
│  │  from A     │ │  from B     │    │
│  │             │ │             │    │
│  └─────────────┘ └─────────────┘    │
│                                     │
└─────────────────────────────────────┘
Result: All unique elements from both sets
```

#### 2. INTERSECT - Common Elements
```
Set A ∩ Set B (INTERSECT)
┌─────────────┐
│    Set A    │
│  ┌─────────┐│ ┌─────────────┐
│  │░░░░░░░░░││ │    Set B    │
│  │░Common░ ││ │             │
│  │░Elements│││ │             │
│  │░░░░░░░░░││ │             │
│  └─────────┘│ │             │
│             │ │             │
└─────────────┘ └─────────────┘
Result: Only elements present in both sets
```

#### 3. EXCEPT - Set Difference
```
Set A - Set B (EXCEPT)
┌─────────────┐
│    Set A    │
│ ┌─────────┐ │ ┌─────────────┐
│ │████████ │ │ │    Set B    │
│ │Elements │ │ │             │
│ │only in A│ │ │             │
│ │████████ │ │ │             │
│ └─────────┘ │ │             │
│             │ │             │
└─────────────┘ └─────────────┘
Result: Elements in A but not in B
```

### Simple Examples

#### 1. UNION - Combining Sets
```sql
-- Basic UNION (removes duplicates)
SELECT FirstName, LastName FROM Employees
UNION
SELECT FirstName, LastName FROM Customers;

-- UNION ALL (keeps duplicates)
SELECT City FROM Employees
UNION ALL
SELECT City FROM Customers;
```

#### 2. INTERSECT - Common Elements
```sql
-- Find cities that have both employees and customers
SELECT City FROM Employees
INTERSECT
SELECT City FROM Customers;
```

#### 3. EXCEPT - Set Difference
```sql
-- Find cities with employees but no customers
SELECT City FROM Employees
EXCEPT
SELECT City FROM Customers;
```

### Intermediate Examples

#### 1. Complex Set Operations
```sql
-- Multiple set operations with ordering
(
    SELECT 'Employee' AS Type, FirstName, LastName, City
    FROM Employees
    WHERE City IN ('New York', 'Los Angeles')
)
UNION
(
    SELECT 'Customer' AS Type, FirstName, LastName, City
    FROM Customers
    WHERE City IN ('New York', 'Los Angeles')
)
ORDER BY City, Type, LastName;
```

#### 2. Set Membership with IN
```sql
-- Simple membership test
SELECT * FROM Products
WHERE CategoryID IN (1, 3, 5);

-- Subquery membership test
SELECT * FROM Employees
WHERE DepartmentID IN (
    SELECT DepartmentID 
    FROM Departments 
    WHERE Budget > 100000
);
```

#### 3. EXISTS vs IN
```sql
-- Using EXISTS (more efficient for large datasets)
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.EmployeeID = e.EmployeeID
);

-- Using IN (simpler syntax)
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.EmployeeID IN (
    SELECT DISTINCT o.EmployeeID 
    FROM Orders o
);
```

### Advanced Examples

#### 1. Set Operations with CTEs
```sql
-- Complex set analysis using CTEs
WITH HighValueCustomers AS (
    SELECT CustomerID, SUM(OrderTotal) AS TotalSpent
    FROM Orders
    GROUP BY CustomerID
    HAVING SUM(OrderTotal) > 10000
),
RecentCustomers AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE OrderDate >= DATEADD(MONTH, -6, GETDATE())
),
ActiveHighValueCustomers AS (
    SELECT CustomerID FROM HighValueCustomers
    INTERSECT
    SELECT CustomerID FROM RecentCustomers
)
SELECT 
    c.FirstName,
    c.LastName,
    hvc.TotalSpent
FROM Customers c
INNER JOIN HighValueCustomers hvc ON c.CustomerID = hvc.CustomerID
WHERE c.CustomerID IN (SELECT CustomerID FROM ActiveHighValueCustomers);
```

#### 2. Set-Based Data Comparison
```sql
-- Find employees with unique skill combinations
WITH EmployeeSkills AS (
    SELECT 
        EmployeeID,
        STRING_AGG(SkillName, ',') WITHIN GROUP (ORDER BY SkillName) AS SkillSet
    FROM EmployeeSkills es
    INNER JOIN Skills s ON es.SkillID = s.SkillID
    GROUP BY EmployeeID
)
SELECT 
    e.FirstName,
    e.LastName,
    es.SkillSet
FROM Employees e
INNER JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
WHERE es.SkillSet NOT IN (
    SELECT SkillSet 
    FROM EmployeeSkills 
    WHERE EmployeeID != e.EmployeeID
);
```

#### 3. Advanced Set-Based Problem Solving
```sql
-- Find products that are ordered by all customers in a specific region
WITH RegionCustomers AS (
    SELECT DISTINCT CustomerID
    FROM Customers
    WHERE Region = 'North America'
),
ProductCustomerPairs AS (
    SELECT DISTINCT p.ProductID, o.CustomerID
    FROM Products p
    CROSS JOIN RegionCustomers rc
    LEFT JOIN Orders o ON rc.CustomerID = o.CustomerID
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID AND p.ProductID = od.ProductID
    WHERE od.ProductID IS NOT NULL
),
ProductsOrderedByAll AS (
    SELECT ProductID
    FROM ProductCustomerPairs
    GROUP BY ProductID
    HAVING COUNT(DISTINCT CustomerID) = (SELECT COUNT(*) FROM RegionCustomers)
)
SELECT 
    p.ProductName,
    p.Price
FROM Products p
WHERE p.ProductID IN (SELECT ProductID FROM ProductsOrderedByAll);
```

## Set-Based Thinking vs Procedural Thinking

### Procedural Approach (Avoid)
```sql
-- Inefficient cursor-based approach
DECLARE @EmployeeID INT;
DECLARE @TotalSales DECIMAL(10,2);
DECLARE employee_cursor CURSOR FOR 
    SELECT EmployeeID FROM Employees;

OPEN employee_cursor;
FETCH NEXT FROM employee_cursor INTO @EmployeeID;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @TotalSales = SUM(OrderTotal)
    FROM Orders
    WHERE EmployeeID = @EmployeeID;
    
    UPDATE Employees 
    SET TotalSales = @TotalSales
    WHERE EmployeeID = @EmployeeID;
    
    FETCH NEXT FROM employee_cursor INTO @EmployeeID;
END

CLOSE employee_cursor;
DEALLOCATE employee_cursor;
```

### Set-Based Approach (Preferred)
```sql
-- Efficient set-based approach
UPDATE e
SET TotalSales = ISNULL(o.TotalSales, 0)
FROM Employees e
LEFT JOIN (
    SELECT 
        EmployeeID,
        SUM(OrderTotal) AS TotalSales
    FROM Orders
    GROUP BY EmployeeID
) o ON e.EmployeeID = o.EmployeeID;
```

## Working with NULL Values in Sets

### NULL Handling in Set Operations
```sql
-- NULL values in UNION
SELECT Name FROM Table1 WHERE Name IS NOT NULL
UNION
SELECT Name FROM Table2 WHERE Name IS NOT NULL;

-- NULL-safe comparisons
SELECT *
FROM Employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.EmployeeID != e1.EmployeeID
    AND (
        (e2.MiddleName = e1.MiddleName) OR 
        (e2.MiddleName IS NULL AND e1.MiddleName IS NULL)
    )
);
```

## Set Operations Performance Considerations

### Best Practices for Performance

#### 1. Index Usage
```sql
-- Ensure proper indexing for set operations
CREATE INDEX IX_Employees_City ON Employees(City);
CREATE INDEX IX_Customers_City ON Customers(City);

-- Now set operations will be more efficient
SELECT City FROM Employees
INTERSECT
SELECT City FROM Customers;
```

#### 2. Use Appropriate Set Operation
```sql
-- UNION vs UNION ALL
-- Use UNION ALL when you know there are no duplicates
-- or when duplicates are acceptable
SELECT CustomerID FROM Orders WHERE OrderDate = '2023-01-01'
UNION ALL  -- Faster than UNION
SELECT CustomerID FROM Orders WHERE OrderDate = '2023-01-02';
```

#### 3. EXISTS vs IN for Large Sets
```sql
-- EXISTS is often more efficient for large datasets
SELECT c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.CustomerID = c.CustomerID 
    AND o.OrderDate >= '2023-01-01'
);
```

## Common Set Patterns

### 1. Finding Missing Values
```sql
-- Find employees without orders
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.EmployeeID = e.EmployeeID
);
```

### 2. Set Equality Check
```sql
-- Check if two tables have the same set of values
WITH Table1Count AS (
    SELECT COUNT(*) AS Cnt FROM (
        SELECT Column1 FROM Table1
        EXCEPT
        SELECT Column1 FROM Table2
    ) t
),
Table2Count AS (
    SELECT COUNT(*) AS Cnt FROM (
        SELECT Column1 FROM Table2
        EXCEPT
        SELECT Column1 FROM Table1
    ) t
)
SELECT 
    CASE 
        WHEN (SELECT Cnt FROM Table1Count) = 0 
         AND (SELECT Cnt FROM Table2Count) = 0 
        THEN 'Tables have same set'
        ELSE 'Tables have different sets'
    END AS Result;
```

### 3. Set Division Pattern
```sql
-- Find customers who have ordered ALL products in a category
WITH CategoryProducts AS (
    SELECT ProductID 
    FROM Products 
    WHERE CategoryID = 1
),
CustomerProductCombos AS (
    SELECT DISTINCT c.CustomerID, p.ProductID
    FROM Customers c
    CROSS JOIN CategoryProducts p
),
ActualOrders AS (
    SELECT DISTINCT o.CustomerID, od.ProductID
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE od.ProductID IN (SELECT ProductID FROM CategoryProducts)
)
SELECT c.CustomerID, c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM CustomerProductCombos cpc
    WHERE cpc.CustomerID = c.CustomerID
    AND NOT EXISTS (
        SELECT 1 
        FROM ActualOrders ao
        WHERE ao.CustomerID = cpc.CustomerID
        AND ao.ProductID = cpc.ProductID
    )
);
```

## Summary

Key concepts for working with sets in T-SQL:

1. **Think in Sets**: Avoid row-by-row processing when possible
2. **Use Set Operations**: UNION, INTERSECT, EXCEPT for combining sets
3. **Membership Testing**: IN, EXISTS for testing set membership
4. **Performance**: Consider indexes and choose appropriate operations
5. **NULL Handling**: Be aware of how NULLs behave in set operations
6. **Set-Based Solutions**: Often more efficient than procedural approaches

Understanding sets is crucial for writing efficient T-SQL queries and thinking about data relationships in a relational database context.
