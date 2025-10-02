# Lab Answers: Using DML to Modify Data

## Exercise 1: Adding Data to Tables - Answers

### Task 1.1: Basic INSERT Operations - Answers

#### Question 1: Insert single record with all columns
**Task:** Insert a new product with all column values specified.

```sql
-- Answer 1: Insert single record with all columns
USE Northwind;
GO

-- Insert a new product
INSERT INTO Products (
    ProductName, 
    SupplierID, 
    CategoryID, 
    QuantityPerUnit, 
    UnitPrice, 
    UnitsInStock, 
    UnitsOnOrder, 
    ReorderLevel, 
    Discontinued
)
VALUES (
    'Gourmet Coffee Blend',
    1,                          -- Exotic Liquids
    1,                          -- Beverages
    '12 - 250g bags',
    25.99,
    50,
    0,
    10,
    0                           -- Not discontinued
);

-- Verify the insert
SELECT TOP 1 * 
FROM Products 
WHERE ProductName = 'Gourmet Coffee Blend'
ORDER BY ProductID DESC;
```

#### Question 2: Insert with default and NULL values
**Task:** Insert records using default values and explicit NULLs.

```sql
-- Answer 2: Insert with default and NULL values
-- First, let's create a test table to demonstrate defaults
CREATE TABLE TestProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(40) NOT NULL,
    UnitPrice MONEY DEFAULT 0.00,
    UnitsInStock SMALLINT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(255) NULL
);

-- Insert using defaults and NULL
INSERT INTO TestProducts (ProductName, UnitPrice, Description)
VALUES 
    ('Basic Product', 10.50, 'This is a basic product'),
    ('Free Sample', DEFAULT, NULL),  -- Use default price, NULL description
    ('Premium Product', 99.99, 'Premium quality item');

-- Insert using column list (defaults will be used for omitted columns)
INSERT INTO TestProducts (ProductName)
VALUES ('Minimal Product');

-- Verify the inserts
SELECT * FROM TestProducts;

-- Clean up
DROP TABLE TestProducts;
```

#### Question 3: Multiple record insert
**Task:** Insert multiple records in a single statement.

```sql
-- Answer 3: Multiple record insert
-- Insert multiple categories (example data)
INSERT INTO Categories (CategoryName, Description)
VALUES 
    ('Health Foods', 'Organic and health-conscious food products'),
    ('Frozen Foods', 'Frozen meals and convenience foods'),
    ('Pet Supplies', 'Food and accessories for pets');

-- Insert multiple related products
INSERT INTO Products (
    ProductName, 
    SupplierID, 
    CategoryID, 
    QuantityPerUnit, 
    UnitPrice, 
    UnitsInStock, 
    UnitsOnOrder, 
    ReorderLevel, 
    Discontinued
)
VALUES 
    ('Organic Quinoa', 7, (SELECT CategoryID FROM Categories WHERE CategoryName = 'Health Foods'), '500g bag', 12.99, 25, 0, 5, 0),
    ('Frozen Pizza Supreme', 5, (SELECT CategoryID FROM Categories WHERE CategoryName = 'Frozen Foods'), '1 pizza', 8.99, 40, 10, 8, 0),
    ('Premium Dog Food', 3, (SELECT CategoryID FROM Categories WHERE CategoryName = 'Pet Supplies'), '5kg bag', 29.99, 15, 5, 3, 0);

-- Verify the inserts
SELECT p.ProductName, c.CategoryName, p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Health Foods', 'Frozen Foods', 'Pet Supplies');
```

### Task 1.2: INSERT with SELECT Statements - Answers

#### Question 1: Copy data from existing table
**Task:** Create a backup table and copy selected data.

```sql
-- Answer 1: Copy data from existing table
-- Create a backup table for discontinued products
CREATE TABLE DiscontinuedProducts (
    ProductID INT,
    ProductName NVARCHAR(40),
    CategoryName NVARCHAR(15),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    ArchiveDate DATETIME DEFAULT GETDATE()
);

-- Insert discontinued products with category information
INSERT INTO DiscontinuedProducts (
    ProductID, 
    ProductName, 
    CategoryName, 
    UnitPrice, 
    UnitsInStock
)
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    p.UnitsInStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 1;

-- Verify the copy
SELECT * FROM DiscontinuedProducts;

-- Show count comparison
SELECT 
    'Original Table' as Source,
    COUNT(*) as DiscontinuedCount
FROM Products 
WHERE Discontinued = 1
UNION ALL
SELECT 
    'Backup Table',
    COUNT(*)
FROM DiscontinuedProducts;

-- Clean up
DROP TABLE DiscontinuedProducts;
```

#### Question 2: Aggregate data insertion
**Task:** Insert summary data based on calculations.

```sql
-- Answer 2: Aggregate data insertion
-- Create a summary table for category statistics
CREATE TABLE CategorySummary (
    CategoryID INT,
    CategoryName NVARCHAR(15),
    ProductCount INT,
    AveragePrice MONEY,
    TotalInventoryValue MONEY,
    SummaryDate DATETIME DEFAULT GETDATE()
);

-- Insert aggregated category data
INSERT INTO CategorySummary (
    CategoryID,
    CategoryName,
    ProductCount,
    AveragePrice,
    TotalInventoryValue
)
SELECT 
    c.CategoryID,
    c.CategoryName,
    COUNT(p.ProductID) as ProductCount,
    AVG(p.UnitPrice) as AveragePrice,
    SUM(p.UnitPrice * p.UnitsInStock) as TotalInventoryValue
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.Discontinued = 0 OR p.Discontinued IS NULL
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) > 0;

-- Verify the summary
SELECT 
    CategoryName,
    ProductCount,
    FORMAT(AveragePrice, 'C') as FormattedAvgPrice,
    FORMAT(TotalInventoryValue, 'C') as FormattedInventoryValue,
    SummaryDate
FROM CategorySummary
ORDER BY TotalInventoryValue DESC;

-- Clean up
DROP TABLE CategorySummary;
```

### Task 1.3: Advanced INSERT Techniques - Answers

#### Question 1: INSERT with IDENTITY columns
**Task:** Handle IDENTITY columns properly in INSERT operations.

```sql
-- Answer 1: INSERT with IDENTITY columns
-- Create a test table with IDENTITY
CREATE TABLE TestEmployees (
    EmployeeID INT IDENTITY(100, 5) PRIMARY KEY,  -- Start at 100, increment by 5
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    HireDate DATE DEFAULT GETDATE()
);

-- Normal insert (IDENTITY value generated automatically)
INSERT INTO TestEmployees (FirstName, LastName)
VALUES 
    ('John', 'Smith'),
    ('Jane', 'Doe'),
    ('Mike', 'Johnson');

-- View the generated IDENTITY values
SELECT * FROM TestEmployees;

-- Insert with explicit IDENTITY values (requires IDENTITY_INSERT ON)
SET IDENTITY_INSERT TestEmployees ON;

INSERT INTO TestEmployees (EmployeeID, FirstName, LastName, HireDate)
VALUES (200, 'Alice', 'Wilson', '2023-01-15');

SET IDENTITY_INSERT TestEmployees OFF;

-- Continue with normal inserts
INSERT INTO TestEmployees (FirstName, LastName)
VALUES ('Bob', 'Brown');

-- Check the final results
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName as FullName,
    HireDate,
    'Next ID would be: ' + CAST(IDENT_CURRENT('TestEmployees') + IDENT_INCR('TestEmployees') AS VARCHAR(10)) as NextIDInfo
FROM TestEmployees
ORDER BY EmployeeID;

-- Clean up
DROP TABLE TestEmployees;
```

#### Question 2: Conditional INSERT (MERGE simulation)
**Task:** Insert data only if it doesn't already exist.

```sql
-- Answer 2: Conditional INSERT
-- Create a staging table for demonstration
CREATE TABLE StagingCustomers (
    CustomerID NCHAR(5),
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    City NVARCHAR(15),
    Country NVARCHAR(15)
);

-- Add some test data to staging
INSERT INTO StagingCustomers VALUES
    ('NEWCO', 'New Company Inc', 'John Manager', 'Seattle', 'USA'),
    ('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Berlin', 'Germany'),  -- This exists
    ('FRESH', 'Fresh Foods Ltd', 'Sarah Fresh', 'London', 'UK');

-- Conditional insert - only insert if CustomerID doesn't exist
INSERT INTO Customers (CustomerID, CompanyName, ContactName, City, Country)
SELECT 
    s.CustomerID,
    s.CompanyName,
    s.ContactName,
    s.City,
    s.Country
FROM StagingCustomers s
WHERE NOT EXISTS (
    SELECT 1 
    FROM Customers c 
    WHERE c.CustomerID = s.CustomerID
);

-- Check results
SELECT 'Staging Records' as Source, COUNT(*) as RecordCount FROM StagingCustomers
UNION ALL
SELECT 'Records Inserted', @@ROWCOUNT
UNION ALL
SELECT 'Existing Customers', COUNT(*) FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM StagingCustomers);

-- Alternative approach using LEFT JOIN
INSERT INTO Customers (CustomerID, CompanyName, ContactName, City, Country)
SELECT 
    s.CustomerID,
    s.CompanyName + ' (Alternative)',
    s.ContactName,
    s.City,
    s.Country
FROM StagingCustomers s
LEFT JOIN Customers c ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
  AND s.CustomerID NOT IN ('NEWCO', 'FRESH');  -- Avoid duplicates from previous insert

-- Clean up staging table
DROP TABLE StagingCustomers;
```

## Exercise 2: Modifying and Removing Data - Answers

### Task 2.1: Basic UPDATE Operations - Answers

#### Question 1: Update single record
**Task:** Update a specific product's price and stock level.

```sql
-- Answer 1: Update single record
-- First, let's see the current values
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE ProductName = 'Gourmet Coffee Blend';

-- Update specific product
UPDATE Products
SET 
    UnitPrice = 27.99,
    UnitsInStock = 75,
    ReorderLevel = 15
WHERE ProductName = 'Gourmet Coffee Blend';

-- Verify the update
SELECT 
    ProductID, 
    ProductName, 
    UnitPrice, 
    UnitsInStock, 
    ReorderLevel,
    'Updated: ' + FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') as UpdateInfo
FROM Products
WHERE ProductName = 'Gourmet Coffee Blend';

-- Show the number of rows affected
PRINT 'Rows affected: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
```

#### Question 2: Update multiple records with conditions
**Task:** Apply price increases to products in specific categories.

```sql
-- Answer 2: Update multiple records with conditions
-- First, let's see current prices for beverages
SELECT 
    p.ProductName,
    c.CategoryName,
    p.UnitPrice as CurrentPrice,
    p.UnitPrice * 1.10 as NewPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND p.Discontinued = 0;

-- Apply 10% price increase to all active beverages
UPDATE p
SET UnitPrice = p.UnitPrice * 1.10
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND p.Discontinued = 0;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' beverage products with 10% price increase';

-- Verify the updates
SELECT 
    p.ProductName,
    c.CategoryName,
    p.UnitPrice as UpdatedPrice,
    FORMAT(p.UnitPrice / 1.10, 'N2') as OriginalPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND p.Discontinued = 0
ORDER BY p.UnitPrice DESC;
```

#### Question 3: Update with calculated values
**Task:** Update reorder levels based on average sales calculations.

```sql
-- Answer 3: Update with calculated values
-- Create a more sophisticated update based on order history
UPDATE p
SET ReorderLevel = 
    CASE 
        WHEN avg_monthly_sales.AvgMonthlySales > 50 THEN 25
        WHEN avg_monthly_sales.AvgMonthlySales > 20 THEN 15
        WHEN avg_monthly_sales.AvgMonthlySales > 10 THEN 10
        ELSE 5
    END
FROM Products p
INNER JOIN (
    SELECT 
        od.ProductID,
        AVG(od.Quantity) as AvgMonthlySales
    FROM [Order Details] od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= DATEADD(MONTH, -12, GETDATE())  -- Last 12 months
    GROUP BY od.ProductID
) avg_monthly_sales ON p.ProductID = avg_monthly_sales.ProductID
WHERE p.Discontinued = 0;

PRINT 'Updated reorder levels for ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' products based on sales history';

-- Show the results of the update
SELECT 
    p.ProductName,
    p.ReorderLevel,
    COALESCE(sales.AvgMonthlySales, 0) as AvgMonthlySales,
    CASE 
        WHEN COALESCE(sales.AvgMonthlySales, 0) > 50 THEN 'High Volume'
        WHEN COALESCE(sales.AvgMonthlySales, 0) > 20 THEN 'Medium Volume'
        WHEN COALESCE(sales.AvgMonthlySales, 0) > 10 THEN 'Low Volume'
        ELSE 'Very Low Volume'
    END as SalesCategory
FROM Products p
LEFT JOIN (
    SELECT 
        od.ProductID,
        AVG(od.Quantity) as AvgMonthlySales
    FROM [Order Details] od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= DATEADD(MONTH, -12, GETDATE())
    GROUP BY od.ProductID
) sales ON p.ProductID = sales.ProductID
WHERE p.Discontinued = 0
ORDER BY sales.AvgMonthlySales DESC;
```

### Task 2.2: DELETE Operations - Answers

#### Question 1: Delete specific records
**Task:** Remove discontinued products that have no sales history.

```sql
-- Answer 1: Delete specific records
-- First, identify products to be deleted
SELECT 
    p.ProductID,
    p.ProductName,
    p.Discontinued,
    COUNT(od.OrderID) as SalesCount
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.Discontinued = 1
GROUP BY p.ProductID, p.ProductName, p.Discontinued
HAVING COUNT(od.OrderID) = 0;

-- Count before deletion
DECLARE @BeforeCount INT = (SELECT COUNT(*) FROM Products WHERE Discontinued = 1);

-- Delete discontinued products with no sales history
DELETE p
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.Discontinued = 1
GROUP BY p.ProductID, p.ProductName, p.UnitPrice, p.SupplierID, p.CategoryID, 
         p.QuantityPerUnit, p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, p.Discontinued
HAVING COUNT(od.OrderID) = 0;

-- Count after deletion
DECLARE @AfterCount INT = (SELECT COUNT(*) FROM Products WHERE Discontinued = 1);

PRINT 'Deleted ' + CAST(@BeforeCount - @AfterCount AS VARCHAR(10)) + ' discontinued products with no sales history';
PRINT 'Remaining discontinued products: ' + CAST(@AfterCount AS VARCHAR(10));
```

#### Question 2: Conditional DELETE with subquery
**Task:** Delete customers who have never placed an order.

```sql
-- Answer 2: Conditional DELETE with subquery
-- First, let's see which customers have never ordered
SELECT 
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    COUNT(o.OrderID) as OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName
HAVING COUNT(o.OrderID) = 0;

-- Create a backup before deletion
SELECT *
INTO CustomerBackup
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders WHERE CustomerID IS NOT NULL);

-- Count customers before deletion
DECLARE @CustomersToDelete INT = (
    SELECT COUNT(*)
    FROM Customers c
    WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID)
);

-- Delete customers with no orders
DELETE FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID 
    FROM Orders 
    WHERE CustomerID IS NOT NULL
);

PRINT 'Deleted ' + CAST(@CustomersToDelete AS VARCHAR(10)) + ' customers who never placed orders';
PRINT 'Backup created in CustomerBackup table with ' + CAST((SELECT COUNT(*) FROM CustomerBackup) AS VARCHAR(10)) + ' records';

-- Clean up backup table (optional)
-- DROP TABLE CustomerBackup;
```

### Task 2.3: Advanced DML Operations - Answers

#### Question 1: MERGE operation simulation
**Task:** Implement UPSERT logic (Insert if not exists, Update if exists).

```sql
-- Answer 1: MERGE operation simulation
-- Create a staging table for product updates
CREATE TABLE ProductUpdates (
    ProductID INT,
    ProductName NVARCHAR(40),
    UnitPrice MONEY,
    UnitsInStock SMALLINT,
    Action NVARCHAR(10)
);

-- Insert sample update data
INSERT INTO ProductUpdates (ProductID, ProductName, UnitPrice, UnitsInStock)
VALUES 
    (1, 'Chai - Premium Blend', 25.00, 50),      -- Update existing
    (999, 'New Exotic Tea', 22.00, 30),          -- Insert new
    (2, 'Chang - Updated Formula', 28.00, 45);   -- Update existing

-- Implement MERGE-like logic using separate operations
-- Step 1: Update existing products
UPDATE p
SET 
    p.ProductName = pu.ProductName,
    p.UnitPrice = pu.UnitPrice,
    p.UnitsInStock = pu.UnitsInStock
FROM Products p
INNER JOIN ProductUpdates pu ON p.ProductID = pu.ProductID;

-- Mark updated records
UPDATE ProductUpdates 
SET Action = 'UPDATED'
WHERE ProductID IN (SELECT ProductID FROM Products);

-- Step 2: Insert new products
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
SELECT 
    pu.ProductName,
    1,  -- Default supplier
    1,  -- Default category
    '1 unit',
    pu.UnitPrice,
    pu.UnitsInStock,
    0,
    10,
    0
FROM ProductUpdates pu
WHERE pu.ProductID NOT IN (SELECT ProductID FROM Products WHERE ProductID IS NOT NULL);

-- Mark inserted records
UPDATE ProductUpdates 
SET Action = 'INSERTED'
WHERE Action IS NULL;

-- Show summary of actions
SELECT 
    Action,
    COUNT(*) as RecordCount
FROM ProductUpdates
GROUP BY Action;

-- Show detailed results
SELECT 
    pu.ProductID as UpdateProductID,
    pu.ProductName as UpdateName,
    pu.Action,
    p.ProductID as ActualProductID,
    p.ProductName as ActualName,
    p.UnitPrice,
    p.UnitsInStock
FROM ProductUpdates pu
LEFT JOIN Products p ON pu.ProductName = p.ProductName
ORDER BY pu.Action, pu.ProductID;

-- Clean up
DROP TABLE ProductUpdates;
```

#### Question 2: Transaction-based DML operations
**Task:** Perform multiple related DML operations in a transaction.

```sql
-- Answer 2: Transaction-based DML operations
-- Simulate order processing with inventory updates
BEGIN TRANSACTION OrderProcessing;

BEGIN TRY
    DECLARE @OrderID INT;
    DECLARE @CustomerID NCHAR(5) = 'ALFKI';
    DECLARE @ProductID1 INT = 1;
    DECLARE @ProductID2 INT = 2;
    DECLARE @Quantity1 INT = 10;
    DECLARE @Quantity2 INT = 5;
    
    -- Check if we have enough inventory
    IF (SELECT UnitsInStock FROM Products WHERE ProductID = @ProductID1) < @Quantity1
    BEGIN
        RAISERROR('Insufficient inventory for Product ID %d', 16, 1, @ProductID1);
    END
    
    IF (SELECT UnitsInStock FROM Products WHERE ProductID = @ProductID2) < @Quantity2
    BEGIN
        RAISERROR('Insufficient inventory for Product ID %d', 16, 1, @ProductID2);
    END
    
    -- Create new order
    INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight)
    VALUES (@CustomerID, 1, GETDATE(), DATEADD(DAY, 7, GETDATE()), 1, 15.50);
    
    SET @OrderID = SCOPE_IDENTITY();
    
    -- Add order details
    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    SELECT @OrderID, @ProductID1, UnitPrice, @Quantity1, 0.0
    FROM Products WHERE ProductID = @ProductID1;
    
    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    SELECT @OrderID, @ProductID2, UnitPrice, @Quantity2, 0.05  -- 5% discount
    FROM Products WHERE ProductID = @ProductID2;
    
    -- Update inventory
    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity1
    WHERE ProductID = @ProductID1;
    
    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity2
    WHERE ProductID = @ProductID2;
    
    -- Log the transaction
    PRINT 'Order ' + CAST(@OrderID AS VARCHAR(10)) + ' created successfully';
    PRINT 'Updated inventory for products ' + CAST(@ProductID1 AS VARCHAR(10)) + ' and ' + CAST(@ProductID2 AS VARCHAR(10));
    
    -- Show order summary
    SELECT 
        o.OrderID,
        o.CustomerID,
        o.OrderDate,
        od.ProductID,
        p.ProductName,
        od.Quantity,
        od.UnitPrice,
        od.Quantity * od.UnitPrice * (1 - od.Discount) as LineTotal,
        p.UnitsInStock as RemainingStock
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE o.OrderID = @OrderID;
    
    COMMIT TRANSACTION OrderProcessing;
    PRINT 'Transaction committed successfully';
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION OrderProcessing;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH
```

## Exercise 3: Generating Automatic Column Values - Answers

### Task 3.1: IDENTITY Columns - Answers

#### Question 1: Working with IDENTITY properties
**Task:** Create and manage tables with IDENTITY columns.

```sql
-- Answer 1: Working with IDENTITY properties
-- Create a test table with IDENTITY
CREATE TABLE InventoryLog (
    LogID INT IDENTITY(1000, 1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ChangeType NVARCHAR(20) NOT NULL,
    OldValue INT,
    NewValue INT,
    ChangeDate DATETIME DEFAULT GETDATE(),
    UserName NVARCHAR(50) DEFAULT SYSTEM_USER
);

-- Insert some test records
INSERT INTO InventoryLog (ProductID, ChangeType, OldValue, NewValue)
VALUES 
    (1, 'Stock Adjustment', 50, 75),
    (2, 'Sale', 30, 25),
    (1, 'Restock', 75, 100);

-- Check IDENTITY properties
SELECT 
    IDENT_SEED('InventoryLog') as IdentitySeed,
    IDENT_INCR('InventoryLog') as IdentityIncrement,
    IDENT_CURRENT('InventoryLog') as CurrentIdentityValue;

-- Show the inserted records
SELECT * FROM InventoryLog;

-- Demonstrate IDENTITY_INSERT
SET IDENTITY_INSERT InventoryLog ON;

INSERT INTO InventoryLog (LogID, ProductID, ChangeType, OldValue, NewValue)
VALUES (5000, 3, 'Manual Entry', 0, 25);

SET IDENTITY_INSERT InventoryLog OFF;

-- Continue with normal inserts
INSERT INTO InventoryLog (ProductID, ChangeType, OldValue, NewValue)
VALUES (3, 'Sale', 25, 20);

-- Final check
SELECT 
    LogID,
    ProductID,
    ChangeType,
    OldValue,
    NewValue,
    ChangeDate,
    UserName,
    CASE 
        WHEN LogID = 5000 THEN 'Manually Inserted'
        ELSE 'Auto Generated'
    END as IDType
FROM InventoryLog
ORDER BY LogID;

-- Clean up
DROP TABLE InventoryLog;
```

#### Question 2: Resetting and managing IDENTITY values
**Task:** Demonstrate IDENTITY management techniques.

```sql
-- Answer 2: Resetting and managing IDENTITY values
-- Create test table
CREATE TABLE TestCounter (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    Description NVARCHAR(50)
);

-- Insert some records
INSERT INTO TestCounter (Description)
VALUES ('First'), ('Second'), ('Third');

SELECT 'Before Reset' as Stage, * FROM TestCounter;

-- Delete all records
DELETE FROM TestCounter;

-- Check current IDENTITY value
SELECT 'After Delete - Current Identity: ' + CAST(IDENT_CURRENT('TestCounter') AS VARCHAR(10)) as Info;

-- Reset IDENTITY to start over
DBCC CHECKIDENT('TestCounter', RESEED, 0);

-- Insert new record
INSERT INTO TestCounter (Description) VALUES ('Reset First');

SELECT 'After Reset' as Stage, * FROM TestCounter;

-- Demonstrate checking and setting specific IDENTITY values
DBCC CHECKIDENT('TestCounter', RESEED, 100);

INSERT INTO TestCounter (Description) VALUES ('Set to 100');

SELECT 'After Setting to 100' as Stage, * FROM TestCounter;

-- Show IDENTITY information
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IDENT_SEED(TABLE_NAME) as Seed,
    IDENT_INCR(TABLE_NAME) as Increment,
    IDENT_CURRENT(TABLE_NAME) as CurrentValue
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMNPROPERTY(OBJECT_ID(TABLE_SCHEMA + '.' + TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1
  AND TABLE_NAME = 'TestCounter';

-- Clean up
DROP TABLE TestCounter;
```

### Task 3.2: Default Constraints and Computed Columns - Answers

#### Question 1: Working with DEFAULT constraints
**Task:** Create table with various DEFAULT constraint types.

```sql
-- Answer 1: Working with DEFAULT constraints
-- Create comprehensive table with defaults
CREATE TABLE CustomerOrders (
    OrderID INT IDENTITY(1, 1) PRIMARY KEY,
    CustomerID NCHAR(5) NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    RequiredDate DATETIME DEFAULT DATEADD(DAY, 14, GETDATE()),
    Status NVARCHAR(20) DEFAULT 'Pending',
    Priority INT DEFAULT 3,  -- 1=High, 2=Medium, 3=Normal, 4=Low
    OrderTotal MONEY DEFAULT 0.00,
    CreatedBy NVARCHAR(50) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsRush BIT DEFAULT 0,
    Notes NVARCHAR(255) DEFAULT 'Standard processing'
);

-- Insert using defaults
INSERT INTO CustomerOrders (CustomerID)
VALUES ('ALFKI');

-- Insert with some explicit values
INSERT INTO CustomerOrders (CustomerID, Priority, IsRush, Notes)
VALUES ('BLONP', 1, 1, 'Rush order - customer called');

-- Insert with explicit date overrides
INSERT INTO CustomerOrders (CustomerID, OrderDate, RequiredDate, Status)
VALUES ('CHOPS', '2024-01-15', '2024-01-20', 'Processing');

-- Show results
SELECT 
    OrderID,
    CustomerID,
    FORMAT(OrderDate, 'yyyy-MM-dd HH:mm') as OrderDate,
    FORMAT(RequiredDate, 'yyyy-MM-dd') as RequiredDate,
    Status,
    CASE Priority
        WHEN 1 THEN 'High'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Normal'
        WHEN 4 THEN 'Low'
        ELSE 'Unknown'
    END as PriorityDesc,
    OrderTotal,
    CreatedBy,
    CASE WHEN IsRush = 1 THEN 'Yes' ELSE 'No' END as IsRushOrder,
    Notes
FROM CustomerOrders
ORDER BY OrderID;

-- Show DEFAULT constraint information
SELECT 
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.IS_NULLABLE,
    c.COLUMN_DEFAULT,
    CASE 
        WHEN c.COLUMN_DEFAULT IS NOT NULL THEN 'Has Default'
        ELSE 'No Default'
    END as DefaultStatus
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME = 'CustomerOrders'
ORDER BY c.ORDINAL_POSITION;

-- Clean up
DROP TABLE CustomerOrders;
```

#### Question 2: Computed columns
**Task:** Create table with computed columns (persisted and non-persisted).

```sql
-- Answer 2: Computed columns
-- Create table with computed columns
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1, 1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    Discount REAL DEFAULT 0.0,
    -- Non-persisted computed columns
    LineTotal AS (UnitPrice * Quantity * (1 - Discount)),
    DiscountAmount AS (UnitPrice * Quantity * Discount),
    -- Persisted computed column (stored physically)
    LineTotalPersisted AS (UnitPrice * Quantity * (1 - Discount)) PERSISTED,
    -- Complex computed column
    PriceCategory AS (
        CASE 
            WHEN UnitPrice < 10 THEN 'Budget'
            WHEN UnitPrice < 50 THEN 'Standard'
            WHEN UnitPrice < 100 THEN 'Premium'
            ELSE 'Luxury'
        END
    ),
    -- Date-based computed column
    CreatedDate DATETIME DEFAULT GETDATE(),
    DaysOld AS (DATEDIFF(DAY, CreatedDate, GETDATE()))
);

-- Insert test data
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES 
    (1, 1, 15.50, 10, 0.0),
    (1, 2, 25.00, 5, 0.05),
    (2, 3, 75.99, 2, 0.10),
    (2, 1, 15.50, 20, 0.15);

-- Wait a moment and insert another record to show DaysOld calculation
WAITFOR DELAY '00:00:02';
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (3, 4, 125.00, 1, 0.0);

-- Show computed column results
SELECT 
    DetailID,
    OrderID,
    ProductID,
    FORMAT(UnitPrice, 'C') as UnitPrice,
    Quantity,
    FORMAT(Discount, 'P') as DiscountPct,
    FORMAT(LineTotal, 'C') as LineTotal,
    FORMAT(DiscountAmount, 'C') as DiscountAmount,
    FORMAT(LineTotalPersisted, 'C') as LineTotalPersisted,
    PriceCategory,
    CreatedDate,
    DaysOld,
    -- Show comparison between computed and persisted
    CASE 
        WHEN LineTotal = LineTotalPersisted THEN 'Match'
        ELSE 'Mismatch'
    END as ComputedVsPersisted
FROM OrderDetails
ORDER BY DetailID;

-- Show computed column definitions
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMNPROPERTY(OBJECT_ID('OrderDetails'), COLUMN_NAME, 'IsComputed') as IsComputed,
    COLUMNPROPERTY(OBJECT_ID('OrderDetails'), COLUMN_NAME, 'IsPersisted') as IsPersisted
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OrderDetails'
ORDER BY ORDINAL_POSITION;

-- Demonstrate that you cannot INSERT into computed columns
-- This would cause an error:
-- INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, LineTotal)
-- VALUES (4, 5, 50.00, 2, 100.00);

-- Clean up
DROP TABLE OrderDetails;
```

### Task 3.3: Advanced Automatic Value Generation - Answers

#### Question 1: Using SEQUENCE objects (SQL Server 2012+)
**Task:** Create and use SEQUENCE objects for generating values.

```sql
-- Answer 1: Using SEQUENCE objects
-- Create different types of sequences
CREATE SEQUENCE InvoiceNumberSeq
    START WITH 10000
    INCREMENT BY 1
    MINVALUE 10000
    MAXVALUE 99999
    CYCLE;

CREATE SEQUENCE CustomerNumberSeq
    START WITH 1000
    INCREMENT BY 5
    MINVALUE 1000
    MAXVALUE 50000
    NO CYCLE;

-- Create table to use sequences
CREATE TABLE InvoiceHeaders (
    InvoiceID INT PRIMARY KEY DEFAULT (NEXT VALUE FOR InvoiceNumberSeq),
    CustomerNumber INT DEFAULT (NEXT VALUE FOR CustomerNumberSeq),
    InvoiceDate DATE DEFAULT GETDATE(),
    InvoiceAmount MONEY
);

-- Insert using sequence defaults
INSERT INTO InvoiceHeaders (InvoiceAmount)
VALUES (150.00), (275.50), (89.99);

-- Insert using explicit sequence values
INSERT INTO InvoiceHeaders (InvoiceID, CustomerNumber, InvoiceAmount)
VALUES 
    (NEXT VALUE FOR InvoiceNumberSeq, NEXT VALUE FOR CustomerNumberSeq, 325.00),
    (NEXT VALUE FOR InvoiceNumberSeq, NEXT VALUE FOR CustomerNumberSeq, 445.75);

-- Show results
SELECT 
    InvoiceID,
    CustomerNumber,
    InvoiceDate,
    FORMAT(InvoiceAmount, 'C') as InvoiceAmount
FROM InvoiceHeaders
ORDER BY InvoiceID;

-- Check sequence current values
SELECT 
    'InvoiceNumberSeq' as SequenceName,
    NEXT VALUE FOR InvoiceNumberSeq as NextValue;

SELECT 
    'CustomerNumberSeq' as SequenceName,
    NEXT VALUE FOR CustomerNumberSeq as NextValue;

-- Restart a sequence
ALTER SEQUENCE CustomerNumberSeq RESTART WITH 2000;

INSERT INTO InvoiceHeaders (InvoiceAmount)
VALUES (199.99);

-- Show sequence information
SELECT 
    name as SequenceName,
    start_value,
    increment,
    minimum_value,
    maximum_value,
    current_value,
    is_cycling
FROM sys.sequences
WHERE name IN ('InvoiceNumberSeq', 'CustomerNumberSeq');

-- Clean up
DROP TABLE InvoiceHeaders;
DROP SEQUENCE InvoiceNumberSeq;
DROP SEQUENCE CustomerNumberSeq;
```

#### Question 2: Custom auto-generation using triggers
**Task:** Create custom automatic value generation using triggers.

```sql
-- Answer 2: Custom auto-generation using triggers
-- Create table for custom ID generation
CREATE TABLE Products_Custom (
    ProductID NVARCHAR(20) PRIMARY KEY,  -- Will be auto-generated
    ProductName NVARCHAR(40) NOT NULL,
    CategoryID INT,
    UnitPrice MONEY,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Create trigger for custom ID generation
CREATE TRIGGER tr_Products_Custom_AutoID
ON Products_Custom
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Products_Custom (ProductID, ProductName, CategoryID, UnitPrice, CreatedDate, ModifiedDate)
    SELECT 
        'PROD-' + 
        FORMAT(ISNULL((SELECT MAX(CAST(SUBSTRING(ProductID, 6, 10) AS INT)) FROM Products_Custom WHERE ProductID LIKE 'PROD-%'), 0) + ROW_NUMBER() OVER (ORDER BY ProductName), '000000') as ProductID,
        ProductName,
        CategoryID,
        UnitPrice,
        GETDATE(),
        GETDATE()
    FROM inserted;
END;

-- Create trigger for auto-updating ModifiedDate
CREATE TRIGGER tr_Products_Custom_AutoUpdate
ON Products_Custom
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Products_Custom
    SET ModifiedDate = GETDATE()
    WHERE ProductID IN (SELECT ProductID FROM inserted);
END;

-- Test the custom auto-generation
INSERT INTO Products_Custom (ProductName, CategoryID, UnitPrice)
VALUES 
    ('Custom Product A', 1, 25.99),
    ('Custom Product B', 2, 15.50),
    ('Custom Product C', 1, 35.75);

-- Show generated IDs
SELECT * FROM Products_Custom ORDER BY ProductID;

-- Test update trigger
UPDATE Products_Custom 
SET UnitPrice = 29.99 
WHERE ProductName = 'Custom Product A';

-- Show updated ModifiedDate
SELECT 
    ProductID,
    ProductName,
    FORMAT(UnitPrice, 'C') as UnitPrice,
    CreatedDate,
    ModifiedDate,
    DATEDIFF(SECOND, CreatedDate, ModifiedDate) as SecondsBetweenCreateAndModify
FROM Products_Custom
ORDER BY ProductID;

-- Clean up
DROP TABLE Products_Custom;
```

## Key Learning Points Summary

### INSERT Statement Mastery
1. **Basic INSERT**: Single and multiple row inserts with explicit values
2. **INSERT with SELECT**: Copying data between tables and creating backups
3. **DEFAULT Values**: Using DEFAULT keyword and omitting columns with defaults
4. **IDENTITY Handling**: Working with IDENTITY_INSERT ON/OFF
5. **Conditional INSERT**: Using NOT EXISTS and LEFT JOIN for upsert logic

### UPDATE Statement Techniques
1. **Basic UPDATE**: Single and multiple column updates with WHERE clauses
2. **JOIN-based UPDATE**: Updating tables based on related table data
3. **Calculated Updates**: Using expressions and functions in SET clauses
4. **Subquery Updates**: Updating based on aggregate calculations
5. **Transaction Safety**: Implementing updates within transactions

### DELETE Statement Operations
1. **Conditional DELETE**: Using WHERE clauses with complex conditions
2. **JOIN-based DELETE**: Deleting based on related table criteria
3. **Subquery DELETE**: Using NOT EXISTS and NOT IN for deletions
4. **Safety Measures**: Creating backups before deletion operations
5. **Cascading Effects**: Understanding referential integrity impacts

### Automatic Value Generation
1. **IDENTITY Columns**: Configuration, management, and troubleshooting
2. **DEFAULT Constraints**: System functions, expressions, and constants
3. **Computed Columns**: Persisted vs non-persisted, complex calculations
4. **SEQUENCE Objects**: Modern alternative to IDENTITY with more flexibility
5. **Custom Generation**: Using triggers for complex auto-generation logic

### Advanced DML Concepts
1. **Transaction Management**: BEGIN/COMMIT/ROLLBACK for data consistency
2. **Error Handling**: TRY/CATCH blocks with proper rollback logic
3. **Merge Simulation**: Implementing upsert logic with separate operations
4. **Performance Considerations**: Batch operations and efficient WHERE clauses
5. **Data Integrity**: Maintaining referential integrity during DML operations

### Best Practices Applied
1. **Safety First**: Always backup data before major DML operations
2. **Transaction Usage**: Group related DML operations in transactions
3. **Efficient Filtering**: Use appropriate indexes and SARGABLE predicates
4. **Error Prevention**: Validate data before operations, use TRY functions
5. **Documentation**: Comment complex DML operations and business logic
6. **Testing**: Test DML operations on small datasets before production use