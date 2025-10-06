# Lesson 3: Generating Automatic Column Values

## Overview
Automatic column value generation is essential for creating unique identifiers, timestamps, and calculated values without manual intervention. SQL Server 2016 provides several mechanisms for generating automatic values, including IDENTITY columns, sequences, default constraints, computed columns, and the newer features like system-versioned temporal tables. This lesson covers all methods of automatic value generation and their appropriate use cases.

## IDENTITY Columns

### IDENTITY Column Fundamentals
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            IDENTITY COLUMN CONCEPTS                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  IDENTITY Syntax:                                                           │
│  column_name data_type IDENTITY [(seed, increment)]                         │
│                                                                             │
│  Parameters:                                                                │
│  • seed: Starting value (default = 1)                                      │
│  • increment: Value to add for each new row (default = 1)                  │
│                                                                             │
│  IDENTITY Value Flow:                                                       │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │                                                                         │
│  │  INSERT Request → Check IDENTITY → Generate Next Value → Insert Row    │
│  │                      ↓                    ↑                             │
│  │                 Current Value      SCOPE_IDENTITY()                     │
│  │                 IDENT_CURRENT()   @@IDENTITY                            │
│  │                                   IDENT_INCR()                          │
│  │                                   IDENT_SEED()                          │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Key Characteristics:                                                       │
│  • Only one IDENTITY column per table                                      │
│  • Cannot update IDENTITY values directly                                  │
│  • Values are unique within the table                                      │
│  • Gaps can occur (rollbacks, failed inserts, server restart)             │
│  • Not guaranteed to be sequential without gaps                            │
│                                                                             │
│  Best Practices:                                                            │
│  • Use for surrogate primary keys                                          │
│  • Don't rely on sequential values for business logic                      │
│  • Consider SEQUENCE objects for more control                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Basic IDENTITY Implementation
```sql
-- Create table with IDENTITY column
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,  -- Start at 1, increment by 1
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    OrderTotal DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER
);

-- Create table with custom IDENTITY seed and increment
CREATE TABLE InvoiceNumbers (
    InvoiceID INT IDENTITY(1000, 5) PRIMARY KEY,  -- Start at 1000, increment by 5
    InvoiceDate DATE DEFAULT GETDATE(),
    Amount DECIMAL(12,2),
    CustomerRef NVARCHAR(50)
);

-- Insert data and observe IDENTITY behavior
INSERT INTO Orders (CustomerID, OrderTotal)
VALUES 
    (101, 250.00),
    (102, 175.50),
    (103, 425.75);

-- Check generated IDENTITY values
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    OrderTotal,
    Status
FROM Orders;

-- IDENTITY functions demonstration
SELECT 
    SCOPE_IDENTITY() AS LastInsertedID,        -- Last IDENTITY in current scope
    @@IDENTITY AS LastIdentityAnyScope,        -- Last IDENTITY in session (any scope)
    IDENT_CURRENT('Orders') AS CurrentSeedOrders,  -- Current IDENTITY value for table
    IDENT_SEED('Orders') AS SeedValue,         -- Original seed value
    IDENT_INCR('Orders') AS IncrementValue     -- Increment value
FROM Orders
WHERE OrderID = (SELECT MAX(OrderID) FROM Orders);
```

### IDENTITY Management and Advanced Scenarios
```sql
-- Insert more data to show increment behavior
INSERT INTO InvoiceNumbers (Amount, CustomerRef)
VALUES 
    (1500.00, 'CUST-001'),
    (2750.50, 'CUST-002'),
    (890.25, 'CUST-003');

SELECT * FROM InvoiceNumbers;

-- IDENTITY_INSERT for explicit value insertion
SET IDENTITY_INSERT Orders ON;

-- Insert with explicit IDENTITY value (for data migration scenarios)
INSERT INTO Orders (OrderID, CustomerID, OrderTotal, Status)
VALUES (100, 999, 999.99, 'Migrated');

SET IDENTITY_INSERT Orders OFF;

-- Verify the explicit insert
SELECT * FROM Orders ORDER BY OrderID;

-- Continue with normal inserts (IDENTITY resumes from highest value)
INSERT INTO Orders (CustomerID, OrderTotal)
VALUES (104, 300.00);

-- DBCC CHECKIDENT to manage IDENTITY values
-- Check current IDENTITY value
DBCC CHECKIDENT('Orders', NORESEED);

-- Reseed IDENTITY to specific value
DBCC CHECKIDENT('Orders', RESEED, 1000);

-- Insert after reseed
INSERT INTO Orders (CustomerID, OrderTotal)
VALUES (105, 150.00);

SELECT * FROM Orders ORDER BY OrderID;

-- Reset IDENTITY to proper value (max existing + increment)
DECLARE @MaxID INT = (SELECT ISNULL(MAX(OrderID), 0) FROM Orders);
DBCC CHECKIDENT('Orders', RESEED, @MaxID);
```

### IDENTITY in Multi-Table Scenarios
```sql
-- Create related tables with IDENTITY columns
CREATE TABLE OrderDetails (
    OrderDetailID BIGINT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (Quantity * UnitPrice) PERSISTED,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Demonstrate capturing IDENTITY values for related inserts
DECLARE @NewOrderID INT;

-- Insert parent record and capture IDENTITY
INSERT INTO Orders (CustomerID, OrderTotal)
VALUES (106, 0);  -- Will calculate total later

SET @NewOrderID = SCOPE_IDENTITY();

-- Insert child records using captured IDENTITY
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
    (@NewOrderID, 1, 2, 25.00),
    (@NewOrderID, 2, 1, 45.50),
    (@NewOrderID, 3, 3, 15.75);

-- Update parent with calculated total
UPDATE Orders 
SET OrderTotal = (
    SELECT SUM(LineTotal) 
    FROM OrderDetails 
    WHERE OrderID = @NewOrderID
)
WHERE OrderID = @NewOrderID;

-- Verify the related inserts
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderTotal,
    od.OrderDetailID,
    od.ProductID,
    od.Quantity,
    od.UnitPrice,
    od.LineTotal
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderID = @NewOrderID;
```

## SEQUENCE Objects

### SEQUENCE vs IDENTITY Comparison
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SEQUENCE vs IDENTITY COMPARISON                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Feature              │ IDENTITY Column    │ SEQUENCE Object               │
│  ─────────────────────┼────────────────────┼───────────────────────────────┤
│  Scope                │ Single table       │ Database-wide                 │
│  Multiple columns     │ No (one per table) │ Yes (multiple tables/columns) │
│  Explicit value req   │ IDENTITY_INSERT    │ NEXT VALUE FOR               │
│  Cache options        │ Limited            │ Configurable                 │
│  Cycle support        │ No                 │ Yes                          │
│  Data type support    │ Numeric only       │ All numeric types            │
│  Performance          │ Slightly faster    │ Very fast with caching       │
│  Cross-table sharing  │ No                 │ Yes                          │
│  Rollback behavior    │ Gaps occur         │ Gaps occur                   │
│  ─────────────────────┼────────────────────┼───────────────────────────────┤
│                                                                             │
│  When to use IDENTITY:                                                      │
│  • Simple auto-incrementing primary keys                                   │
│  • Single table scenarios                                                  │
│  • Maximum performance for single-table inserts                           │
│                                                                             │
│  When to use SEQUENCE:                                                      │
│  • Multiple tables need same numbering sequence                            │
│  • Need more control over numbering behavior                               │
│  • Cross-table coordination required                                       │
│  • Business requires specific numbering rules                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Creating and Using SEQUENCE Objects
```sql
-- Basic SEQUENCE creation
CREATE SEQUENCE OrderNumberSequence
    AS INT
    START WITH 10000
    INCREMENT BY 1
    MINVALUE 10000
    MAXVALUE 99999
    CACHE 50;  -- Cache 50 values for performance

-- Advanced SEQUENCE with cycling
CREATE SEQUENCE MonthlyReportSequence
    AS SMALLINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 12
    CYCLE  -- Reset to MINVALUE when MAXVALUE reached
    CACHE 12;

-- Sequence for multiple tables sharing same numbering
CREATE SEQUENCE DocumentSequence
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 100;

-- Create tables using SEQUENCE objects
CREATE TABLE PurchaseOrders (
    DocumentID BIGINT DEFAULT NEXT VALUE FOR DocumentSequence PRIMARY KEY,
    OrderNumber INT DEFAULT NEXT VALUE FOR OrderNumberSequence,
    SupplierID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2)
);

CREATE TABLE SalesInvoices (
    DocumentID BIGINT DEFAULT NEXT VALUE FOR DocumentSequence PRIMARY KEY,
    InvoiceNumber NVARCHAR(20),
    CustomerID INT NOT NULL,
    InvoiceDate DATE DEFAULT GETDATE(),
    Amount DECIMAL(12,2)
);

CREATE TABLE MonthlyReports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportMonth SMALLINT DEFAULT NEXT VALUE FOR MonthlyReportSequence,
    ReportYear INT DEFAULT YEAR(GETDATE()),
    ReportData NVARCHAR(MAX)
);

-- Insert data using SEQUENCE values
INSERT INTO PurchaseOrders (SupplierID, TotalAmount)
VALUES 
    (501, 1500.00),
    (502, 2750.25),
    (503, 890.75);

INSERT INTO SalesInvoices (CustomerID, Amount)
VALUES 
    (101, 950.00),
    (102, 1275.50);

-- Manual SEQUENCE value retrieval
DECLARE @NextOrderNum INT = NEXT VALUE FOR OrderNumberSequence;
DECLARE @NextDocID BIGINT = NEXT VALUE FOR DocumentSequence;

INSERT INTO SalesInvoices (DocumentID, InvoiceNumber, CustomerID, Amount)
VALUES (@NextDocID, 'INV-' + CAST(@NextOrderNum AS VARCHAR(10)), 103, 525.75);

-- View results showing shared sequence usage
SELECT 
    'PurchaseOrder' AS DocumentType,
    DocumentID,
    OrderNumber AS BusinessNumber,
    OrderDate AS DocumentDate,
    TotalAmount AS Amount
FROM PurchaseOrders

UNION ALL

SELECT 
    'SalesInvoice' AS DocumentType,
    DocumentID,
    CAST(SUBSTRING(InvoiceNumber, 5, LEN(InvoiceNumber)) AS INT) AS BusinessNumber,
    InvoiceDate AS DocumentDate,
    Amount
FROM SalesInvoices

ORDER BY DocumentID;
```

### SEQUENCE Management and Monitoring
```sql
-- Query SEQUENCE information
SELECT 
    name AS SequenceName,
    CAST(current_value AS BIGINT) AS CurrentValue,
    CAST(start_value AS BIGINT) AS StartValue,
    CAST(increment AS BIGINT) AS IncrementValue,
    CAST(minimum_value AS BIGINT) AS MinValue,
    CAST(maximum_value AS BIGINT) AS MaxValue,
    is_cycling,
    cache_size
FROM sys.sequences
ORDER BY name;

-- Reset SEQUENCE to specific value
ALTER SEQUENCE OrderNumberSequence RESTART WITH 15000;

-- Modify SEQUENCE properties
ALTER SEQUENCE MonthlyReportSequence
    INCREMENT BY 2
    CACHE 6;

-- Get multiple SEQUENCE values efficiently
DECLARE @SequenceValues TABLE (
    ID INT IDENTITY(1,1),
    OrderNumber INT
);

-- Get batch of sequence values
INSERT INTO @SequenceValues (OrderNumber)
SELECT NEXT VALUE FOR OrderNumberSequence
FROM (VALUES (1),(2),(3),(4),(5)) AS T(N);

SELECT * FROM @SequenceValues;

-- SEQUENCE performance demonstration
DECLARE @StartTime DATETIME2 = SYSDATETIME();

-- Bulk insert using SEQUENCE
INSERT INTO PurchaseOrders (SupplierID, TotalAmount)
SELECT 
    500 + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 10),
    RAND() * 1000 + 100
FROM sys.objects s1
CROSS JOIN sys.objects s2
WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= 1000;

DECLARE @EndTime DATETIME2 = SYSDATETIME();
PRINT 'Bulk insert with SEQUENCE took: ' + 
      CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' ms';
```

## Default Constraints

### Default Constraint Fundamentals
```sql
-- Create table with various default constraints
CREATE TABLE CustomerProfiles (
    ProfileID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    
    -- Date/time defaults
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    LastLoginDate DATETIME2 DEFAULT SYSDATETIME(),
    AccountExpiryDate DATE DEFAULT DATEADD(YEAR, 1, GETDATE()),
    
    -- String defaults
    TimeZone NVARCHAR(50) DEFAULT 'UTC',
    Language NVARCHAR(10) DEFAULT 'en-US',
    CommunicationPreference NVARCHAR(20) DEFAULT 'Email',
    
    -- Numeric defaults
    CreditLimit DECIMAL(10,2) DEFAULT 1000.00,
    DiscountRate DECIMAL(5,4) DEFAULT 0.0000,
    
    -- Boolean defaults
    IsActive BIT DEFAULT 1,
    EmailOptIn BIT DEFAULT 0,
    SMSOptIn BIT DEFAULT 0,
    
    -- Calculated defaults
    AccountType NVARCHAR(20) DEFAULT 'Standard',
    RiskScore AS CASE 
        WHEN CreditLimit > 10000 THEN 'Low'
        WHEN CreditLimit > 5000 THEN 'Medium'
        ELSE 'High'
    END,
    
    -- User context defaults
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedFromIP NVARCHAR(45) DEFAULT '127.0.0.1'
);

-- Insert with various default scenarios
-- All defaults used
INSERT INTO CustomerProfiles (CustomerID)
VALUES (1001);

-- Some defaults overridden
INSERT INTO CustomerProfiles (CustomerID, TimeZone, Language, CreditLimit, EmailOptIn)
VALUES (1002, 'PST', 'es-ES', 5000.00, 1);

-- Explicit NULL values (override defaults)
INSERT INTO CustomerProfiles (CustomerID, TimeZone, CommunicationPreference)
VALUES (1003, NULL, NULL);

-- View results showing default behavior
SELECT 
    ProfileID,
    CustomerID,
    CreatedDate,
    TimeZone,
    Language,
    CommunicationPreference,
    FORMAT(CreditLimit, 'C') AS CreditLimit,
    AccountType,
    RiskScore,
    IsActive,
    EmailOptIn,
    CreatedBy
FROM CustomerProfiles
ORDER BY ProfileID;
```

### Advanced Default Constraints
```sql
-- Function-based defaults
CREATE FUNCTION dbo.GenerateCustomerCode(@CustomerID INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN 'CUST' + RIGHT('00000' + CAST(@CustomerID AS VARCHAR(5)), 5) + 
           FORMAT(GETDATE(), 'yyyyMM');
END;

-- Create table with function-based default
CREATE TABLE CustomerAccounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CustomerCode AS dbo.GenerateCustomerCode(CustomerID) PERSISTED,
    
    -- Complex date defaults
    BillingCycleStart DATE DEFAULT DATEADD(DAY, -(DAY(GETDATE()) - 1), GETDATE()), -- First of current month
    NextBillingDate DATE DEFAULT DATEADD(MONTH, 1, DATEADD(DAY, -(DAY(GETDATE()) - 1), GETDATE())), -- First of next month
    
    -- Random default values
    AccountNumber AS CAST(ABS(CHECKSUM(NEWID())) % 1000000 AS VARCHAR(10)) PERSISTED,
    
    -- Context-sensitive defaults
    RegistrationSource NVARCHAR(50) DEFAULT 'Direct',
    InitialStatus NVARCHAR(20) DEFAULT CASE 
        WHEN DATENAME(WEEKDAY, GETDATE()) IN ('Saturday', 'Sunday') THEN 'Pending Review'
        ELSE 'Active'
    END
);

-- Default constraint with business rules
ALTER TABLE CustomerAccounts
ADD CONSTRAINT DF_CustomerAccounts_CreditScore 
DEFAULT (
    CASE 
        WHEN SYSTEM_USER LIKE '%admin%' THEN 850  -- Admin creates high-score accounts
        WHEN DATEPART(HOUR, GETDATE()) BETWEEN 9 AND 17 THEN 750  -- Business hours
        ELSE 700  -- After hours
    END
) FOR CreditScore;

-- Add the column first
ALTER TABLE CustomerAccounts 
ADD CreditScore INT;

-- Now add the default constraint
ALTER TABLE CustomerAccounts
ADD CONSTRAINT DF_CustomerAccounts_CreditScore 
DEFAULT (
    CASE 
        WHEN SYSTEM_USER LIKE '%admin%' THEN 850
        WHEN DATEPART(HOUR, GETDATE()) BETWEEN 9 AND 17 THEN 750
        ELSE 700
    END
) FOR CreditScore;

-- Test function-based and complex defaults
INSERT INTO CustomerAccounts (CustomerID, RegistrationSource)
VALUES 
    (1001, 'Website'),
    (1002, 'Mobile App'),
    (1003, DEFAULT);  -- Explicit DEFAULT keyword

SELECT 
    AccountID,
    CustomerID,
    CustomerCode,
    AccountNumber,
    BillingCycleStart,
    NextBillingDate,
    RegistrationSource,
    InitialStatus,
    CreditScore
FROM CustomerAccounts;
```

### Managing Default Constraints
```sql
-- Query existing default constraints
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    dc.name AS ConstraintName,
    dc.definition AS DefaultDefinition,
    dc.create_date,
    dc.modify_date
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE t.name IN ('CustomerProfiles', 'CustomerAccounts')
ORDER BY t.name, c.column_id;

-- Drop and recreate default constraints
-- First, find constraint name
DECLARE @ConstraintName NVARCHAR(128);
SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'CustomerProfiles'
  AND c.name = 'CreditLimit';

-- Drop existing constraint
DECLARE @SQL NVARCHAR(MAX) = 'ALTER TABLE CustomerProfiles DROP CONSTRAINT ' + @ConstraintName;
EXEC sp_executesql @SQL;

-- Add new default constraint
ALTER TABLE CustomerProfiles
ADD CONSTRAINT DF_CustomerProfiles_CreditLimit_New
DEFAULT (
    CASE 
        WHEN MONTH(GETDATE()) = 12 THEN 1500.00  -- Holiday bonus credit
        ELSE 1000.00
    END
) FOR CreditLimit;
```

## Computed Columns

### Basic Computed Columns
```sql
-- Create table with various computed column types
CREATE TABLE SalesTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    DiscountPercent DECIMAL(5,2) DEFAULT 0.00,
    TaxRate DECIMAL(5,4) DEFAULT 0.0825,  -- 8.25% tax rate
    
    -- Basic computed columns
    LineTotal AS (Quantity * UnitPrice),
    DiscountAmount AS (Quantity * UnitPrice * DiscountPercent / 100),
    NetAmount AS (Quantity * UnitPrice * (1 - DiscountPercent / 100)),
    TaxAmount AS (Quantity * UnitPrice * (1 - DiscountPercent / 100) * TaxRate),
    GrandTotal AS (Quantity * UnitPrice * (1 - DiscountPercent / 100) * (1 + TaxRate)),
    
    -- String computed columns
    TransactionCode AS ('TXN' + RIGHT('00000' + CAST(TransactionID AS VARCHAR(5)), 5)),
    
    -- Date computed columns
    TransactionDate DATETIME2 DEFAULT SYSDATETIME(),
    TransactionYear AS YEAR(TransactionDate) PERSISTED,
    TransactionQuarter AS DATEPART(QUARTER, TransactionDate) PERSISTED,
    
    -- Conditional computed columns
    VolumeDiscount AS CASE 
        WHEN Quantity >= 100 THEN 0.10
        WHEN Quantity >= 50 THEN 0.05
        WHEN Quantity >= 20 THEN 0.02
        ELSE 0.00
    END,
    
    TransactionCategory AS CASE 
        WHEN Quantity * UnitPrice > 1000 THEN 'Large'
        WHEN Quantity * UnitPrice > 500 THEN 'Medium'
        ELSE 'Small'
    END PERSISTED  -- Persisted for indexing
);

-- Insert test data
INSERT INTO SalesTransactions (CustomerID, ProductID, Quantity, UnitPrice, DiscountPercent)
VALUES 
    (101, 1, 5, 25.00, 5.00),
    (102, 2, 15, 45.50, 10.00),
    (103, 3, 75, 12.25, 15.00),
    (104, 1, 150, 25.00, 20.00);

-- View computed column results
SELECT 
    TransactionID,
    TransactionCode,
    CustomerID,
    ProductID,
    Quantity,
    FORMAT(UnitPrice, 'C') AS UnitPrice,
    CAST(DiscountPercent AS VARCHAR(10)) + '%' AS Discount,
    FORMAT(LineTotal, 'C') AS LineTotal,
    FORMAT(DiscountAmount, 'C') AS DiscountAmount,
    FORMAT(NetAmount, 'C') AS NetAmount,
    FORMAT(TaxAmount, 'C') AS TaxAmount,
    FORMAT(GrandTotal, 'C') AS GrandTotal,
    TransactionCategory,
    CAST(VolumeDiscount * 100 AS VARCHAR(10)) + '%' AS VolumeDiscount
FROM SalesTransactions
ORDER BY TransactionID;
```

### Advanced Computed Columns with Functions
```sql
-- Create user-defined functions for computed columns
CREATE FUNCTION dbo.CalculateShippingCost(
    @Weight DECIMAL(8,2),
    @Distance INT,
    @Priority NVARCHAR(20)
)
RETURNS DECIMAL(8,2)
AS
BEGIN
    DECLARE @BaseCost DECIMAL(8,2) = @Weight * 0.50 + @Distance * 0.10;
    DECLARE @PriorityMultiplier DECIMAL(3,2) = CASE @Priority
        WHEN 'Express' THEN 2.0
        WHEN 'Priority' THEN 1.5
        WHEN 'Standard' THEN 1.0
        ELSE 1.0
    END;
    
    RETURN @BaseCost * @PriorityMultiplier;
END;

CREATE FUNCTION dbo.GetCustomerTier(@CustomerID INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @TotalPurchases DECIMAL(12,2);
    SELECT @TotalPurchases = ISNULL(SUM(GrandTotal), 0)
    FROM SalesTransactions
    WHERE CustomerID = @CustomerID;
    
    RETURN CASE 
        WHEN @TotalPurchases >= 10000 THEN 'Platinum'
        WHEN @TotalPurchases >= 5000 THEN 'Gold'
        WHEN @TotalPurchases >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END;
END;

-- Create table using function-based computed columns
CREATE TABLE ShippingOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Weight DECIMAL(8,2) NOT NULL,
    Distance INT NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'Standard',
    
    -- Function-based computed columns
    ShippingCost AS dbo.CalculateShippingCost(Weight, Distance, Priority) PERSISTED,
    CustomerTier AS dbo.GetCustomerTier(CustomerID),  -- Non-persisted (dynamic)
    
    -- Complex computed columns
    EstimatedDeliveryDays AS CASE Priority
        WHEN 'Express' THEN 1
        WHEN 'Priority' THEN 3
        WHEN 'Standard' THEN 7
        ELSE 7
    END,
    
    EstimatedDeliveryDate AS DATEADD(DAY, 
        CASE Priority
            WHEN 'Express' THEN 1
            WHEN 'Priority' THEN 3
            WHEN 'Standard' THEN 7
            ELSE 7
        END, 
        GETDATE()
    ),
    
    OrderDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Insert shipping orders
INSERT INTO ShippingOrders (CustomerID, Weight, Distance, Priority)
VALUES 
    (101, 5.5, 250, 'Express'),
    (102, 12.3, 150, 'Priority'),
    (103, 8.7, 500, 'Standard'),
    (101, 15.2, 300, 'Express');

-- View computed results
SELECT 
    OrderID,
    CustomerID,
    CustomerTier,
    Weight,
    Distance,
    Priority,
    FORMAT(ShippingCost, 'C') AS ShippingCost,
    EstimatedDeliveryDays,
    EstimatedDeliveryDate,
    OrderDate
FROM ShippingOrders
ORDER BY OrderID;
```

### Computed Column Indexing and Performance
```sql
-- Create indexes on persisted computed columns
CREATE INDEX IX_SalesTransactions_TransactionCategory 
ON SalesTransactions (TransactionCategory);

CREATE INDEX IX_SalesTransactions_Year_Quarter 
ON SalesTransactions (TransactionYear, TransactionQuarter);

-- Demonstrate query optimization with computed column indexes
-- This query can use the index on TransactionCategory
SELECT 
    TransactionCategory,
    COUNT(*) AS TransactionCount,
    FORMAT(SUM(GrandTotal), 'C') AS TotalRevenue,
    FORMAT(AVG(GrandTotal), 'C') AS AverageTransaction
FROM SalesTransactions
WHERE TransactionCategory = 'Large'
GROUP BY TransactionCategory;

-- This query can use the index on year/quarter
SELECT 
    TransactionYear,
    TransactionQuarter,
    COUNT(*) AS TransactionCount,
    FORMAT(SUM(GrandTotal), 'C') AS QuarterlyRevenue
FROM SalesTransactions
WHERE TransactionYear = 2024
GROUP BY TransactionYear, TransactionQuarter
ORDER BY TransactionYear, TransactionQuarter;

-- Performance comparison: computed column vs calculated field
-- Using persisted computed column (faster)
SET STATISTICS IO ON;
SELECT COUNT(*) 
FROM SalesTransactions 
WHERE TransactionCategory = 'Large';

-- Using calculated field (slower, requires calculation for each row)
SELECT COUNT(*) 
FROM SalesTransactions 
WHERE CASE 
    WHEN Quantity * UnitPrice > 1000 THEN 'Large'
    WHEN Quantity * UnitPrice > 500 THEN 'Medium'
    ELSE 'Small'
END = 'Large';
SET STATISTICS IO OFF;
```

## Temporal Tables (System-Versioned)

### System-Versioned Temporal Tables
```sql
-- Create system-versioned temporal table
CREATE TABLE EmployeeHistory (
    EmployeeID INT NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    BaseSalary DECIMAL(10,2),
    DepartmentID INT,
    Position NVARCHAR(100),
    
    -- Required temporal columns (automatically managed)
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory_Archive));

-- Insert initial data
INSERT INTO EmployeeHistory (EmployeeID, FirstName, LastName, Email, BaseSalary, DepartmentID, Position)
VALUES 
    (1, 'John', 'Doe', 'john.doe@company.com', 65000.00, 1, 'Developer'),
    (2, 'Jane', 'Smith', 'jane.smith@company.com', 70000.00, 2, 'Analyst'),
    (3, 'Bob', 'Johnson', 'bob.johnson@company.com', 75000.00, 1, 'Senior Developer');

-- Wait a moment, then update data to create history
WAITFOR DELAY '00:00:02';

UPDATE EmployeeHistory 
SET BaseSalary = 68000.00, Position = 'Senior Developer'
WHERE EmployeeID = 1;

UPDATE EmployeeHistory 
SET DepartmentID = 3, BaseSalary = 72000.00
WHERE EmployeeID = 2;

-- Wait again and make more changes
WAITFOR DELAY '00:00:02';

UPDATE EmployeeHistory 
SET BaseSalary = 80000.00, Position = 'Lead Developer'
WHERE EmployeeID = 3;

-- Query current data (standard query)
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    Email,
    FORMAT(BaseSalary, 'C') AS BaseSalary,
    DepartmentID,
    Position,
    ValidFrom,
    ValidTo
FROM EmployeeHistory;

-- Query historical data at specific point in time
DECLARE @HistoricalDate DATETIME2 = DATEADD(MINUTE, -1, SYSDATETIME());

SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    FORMAT(BaseSalary, 'C') AS SalaryAtTime,
    Position AS PositionAtTime,
    ValidFrom,
    ValidTo
FROM EmployeeHistory FOR SYSTEM_TIME AS OF @HistoricalDate;

-- Query all historical changes for specific employee
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    FORMAT(BaseSalary, 'C') AS BaseSalary,
    Position,
    ValidFrom AS EffectiveFrom,
    ValidTo AS EffectiveTo,
    CASE 
        WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 'Current'
        ELSE 'Historical'
    END AS RecordStatus
FROM EmployeeHistory FOR SYSTEM_TIME ALL
WHERE EmployeeID = 1
ORDER BY ValidFrom;

-- Query changes within a date range
DECLARE @StartDate DATETIME2 = DATEADD(HOUR, -1, SYSDATETIME());
DECLARE @EndDate DATETIME2 = SYSDATETIME();

SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    FORMAT(BaseSalary, 'C') AS BaseSalary,
    Position,
    ValidFrom,
    ValidTo
FROM EmployeeHistory FOR SYSTEM_TIME BETWEEN @StartDate AND @EndDate
ORDER BY EmployeeID, ValidFrom;
```

## UUID/GUID Generation

### UNIQUEIDENTIFIER and NEWID()
```sql
-- Create table with GUID columns
CREATE TABLE DocumentStorage (
    DocumentID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    FileName NVARCHAR(255) NOT NULL,
    FileSize BIGINT,
    ContentType NVARCHAR(100),
    UploadDate DATETIME2 DEFAULT SYSDATETIME(),
    
    -- Sequential GUID for better performance (SQL Server 2005+)
    SequentialID UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    
    -- Custom GUID generation
    CustomID AS CAST(HASHBYTES('MD5', CAST(DocumentID AS VARCHAR(36)) + FileName) AS UNIQUEIDENTIFIER),
    
    UploadedBy NVARCHAR(100) DEFAULT SYSTEM_USER
);

-- Insert documents
INSERT INTO DocumentStorage (FileName, FileSize, ContentType)
VALUES 
    ('contract.pdf', 524288, 'application/pdf'),
    ('presentation.pptx', 2097152, 'application/vnd.openxmlformats-officedocument.presentationml.presentation'),
    ('spreadsheet.xlsx', 1048576, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

-- View generated GUIDs
SELECT 
    DocumentID,
    FileName,
    FileSize,
    SequentialID,
    CustomID,
    UploadDate
FROM DocumentStorage
ORDER BY UploadDate;

-- Demonstrate GUID usage in relationships
CREATE TABLE DocumentVersions (
    VersionID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    DocumentID UNIQUEIDENTIFIER NOT NULL,
    VersionNumber INT NOT NULL,
    ChangeDescription NVARCHAR(MAX),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    
    FOREIGN KEY (DocumentID) REFERENCES DocumentStorage(DocumentID),
    UNIQUE (DocumentID, VersionNumber)
);

-- Insert versions for documents
INSERT INTO DocumentVersions (DocumentID, VersionNumber, ChangeDescription)
SELECT 
    DocumentID,
    1,
    'Initial version'
FROM DocumentStorage;

-- Add more versions
DECLARE @DocID UNIQUEIDENTIFIER = (SELECT TOP 1 DocumentID FROM DocumentStorage WHERE FileName = 'contract.pdf');

INSERT INTO DocumentVersions (DocumentID, VersionNumber, ChangeDescription)
VALUES 
    (@DocID, 2, 'Added signature page'),
    (@DocID, 3, 'Corrected terms and conditions');

-- Query with GUID relationships
SELECT 
    ds.FileName,
    dv.VersionNumber,
    dv.ChangeDescription,
    dv.CreatedDate,
    dv.CreatedBy
FROM DocumentStorage ds
INNER JOIN DocumentVersions dv ON ds.DocumentID = dv.DocumentID
ORDER BY ds.FileName, dv.VersionNumber;
```

## Best Practices and Performance Considerations

### Automatic Value Generation Best Practices
```sql
-- Best practices demonstration table
CREATE TABLE BestPracticesDemo (
    -- Use IDENTITY for simple auto-incrementing primary keys
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Use SEQUENCE for shared numbering across tables
    BusinessNumber INT DEFAULT NEXT VALUE FOR OrderNumberSequence,
    
    -- Use defaults for audit fields
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ModifiedDate DATETIME2 DEFAULT SYSDATETIME(),
    
    -- Use computed columns for calculated values
    BusinessCode AS 'BP' + RIGHT('00000' + CAST(ID AS VARCHAR(5)), 5) PERSISTED,
    
    -- Use GUIDs for distributed systems or external references
    ExternalReference UNIQUEIDENTIFIER DEFAULT NEWID(),
    
    -- Use appropriate defaults for business rules
    Status NVARCHAR(20) DEFAULT 'Active',
    Priority INT DEFAULT 5,  -- Medium priority
    
    -- Business data
    Description NVARCHAR(255) NOT NULL
);

-- Performance comparison: IDENTITY vs SEQUENCE
-- Create test tables
CREATE TABLE IdentityTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data NVARCHAR(50)
);

CREATE SEQUENCE TestSequence AS INT START WITH 1;

CREATE TABLE SequenceTest (
    ID INT DEFAULT NEXT VALUE FOR TestSequence PRIMARY KEY,
    Data NVARCHAR(50)
);

-- Performance test
DECLARE @StartTime DATETIME2;
DECLARE @EndTime DATETIME2;
DECLARE @RowCount INT = 10000;

-- Test IDENTITY performance
SET @StartTime = SYSDATETIME();

INSERT INTO IdentityTest (Data)
SELECT 'Test Data ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10))
FROM sys.objects s1
CROSS JOIN sys.objects s2
WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= @RowCount;

SET @EndTime = SYSDATETIME();
PRINT 'IDENTITY Insert took: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' ms';

-- Test SEQUENCE performance
SET @StartTime = SYSDATETIME();

INSERT INTO SequenceTest (Data)
SELECT 'Test Data ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10))
FROM sys.objects s1
CROSS JOIN sys.objects s2
WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= @RowCount;

SET @EndTime = SYSDATETIME();
PRINT 'SEQUENCE Insert took: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' ms';

-- Cleanup test tables
DROP TABLE IdentityTest;
DROP TABLE SequenceTest;
DROP SEQUENCE TestSequence;
```

### Common Pitfalls and Solutions
```sql
-- Common pitfalls and their solutions

-- PITFALL 1: Assuming IDENTITY values are always sequential
-- Problem: Gaps can occur due to rollbacks, failed inserts, server restarts
-- Solution: Don't rely on IDENTITY for business logic

-- PITFALL 2: Using IDENTITY values across distributed systems
-- Problem: IDENTITY values are not globally unique
-- Solution: Use GUIDs or centralized sequence management

-- PITFALL 3: Not handling IDENTITY gaps in application logic
-- Demonstration of gaps
BEGIN TRANSACTION;
INSERT INTO BestPracticesDemo (Description) VALUES ('Test 1');
PRINT 'Inserted ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR(10));
ROLLBACK TRANSACTION;  -- This creates a gap

INSERT INTO BestPracticesDemo (Description) VALUES ('Test 2');
PRINT 'Next ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR(10));  -- Will skip the rolled-back ID

-- PITFALL 4: Performance issues with NEWID() in clustered indexes
-- Problem: Random GUIDs cause page splits and fragmentation
-- Solution: Use NEWSEQUENTIALID() for better performance

-- PITFALL 5: Computed columns that are not deterministic
-- Problem: Non-deterministic computed columns cannot be indexed
-- This won't work for indexing:
-- ComputedColumn AS GETDATE()  -- Non-deterministic

-- This will work:
-- ComputedColumn AS YEAR(SomeDateColumn)  -- Deterministic

-- PITFALL 6: Not considering time zone issues with default dates
-- Problem: GETDATE() uses server local time
-- Solution: Use GETUTCDATE() for UTC time or be explicit about time zones

SELECT 
    GETDATE() AS LocalTime,
    GETUTCDATE() AS UTCTime,
    SYSDATETIME() AS HighPrecisionLocal,
    SYSUTCDATETIME() AS HighPrecisionUTC,
    SYSDATETIMEOFFSET() AS WithTimeZone;
```

## Summary

### Key Takeaways for Automatic Column Values

1. **IDENTITY Columns**
   - Best for simple auto-incrementing primary keys
   - One per table limitation
   - Gaps can occur and should be expected
   - Use SCOPE_IDENTITY() to get last inserted value

2. **SEQUENCE Objects**
   - More flexible than IDENTITY
   - Can be shared across multiple tables
   - Better control over numbering behavior
   - Slightly more overhead than IDENTITY

3. **Default Constraints**
   - Essential for audit fields and business rules
   - Can use functions and complex expressions
   - Applied only when no explicit value provided
   - Consider performance impact of complex defaults

4. **Computed Columns**
   - Calculated automatically based on other columns
   - PERSISTED computed columns can be indexed
   - Must be deterministic for indexing
   - Great for derived business values

5. **Temporal Tables**
   - Automatic history tracking
   - System-managed temporal columns
   - Powerful for audit and compliance
   - Query historical data with FOR SYSTEM_TIME

6. **GUID Generation**
   - Globally unique across systems
   - Use NEWSEQUENTIALID() for better performance
   - Consider storage overhead (16 bytes)
   - Good for distributed systems

Understanding these automatic value generation techniques is crucial for designing efficient, maintainable database schemas that support business requirements while maintaining performance and data integrity.
