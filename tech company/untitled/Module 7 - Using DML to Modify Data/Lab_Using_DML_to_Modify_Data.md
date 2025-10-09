# Lab: Using DML to Modify Data

## Lab Overview
This comprehensive lab provides hands-on experience with Data Manipulation Language (DML) operations in SQL Server. You'll practice INSERT, UPDATE, and DELETE operations, work with automatic column value generation, and implement real-world business scenarios that require complex data modification techniques.

## Prerequisites
- Access to SQL Server 2016 or later
- Completion of Module 7 Lessons 1-3
- Understanding of basic T-SQL syntax
- Familiarity with table relationships and constraints

## Lab Setup - TechCorp Solutions DML Operations

### The TechCorp Journey - Module 7 Culmination
Congratulations! You've journeyed with TechCorp Solutions from Module 1 through Module 6, building their database system from architecture through complex queries and data types. Now in Module 7, we'll complete the story by performing real-world data modifications as TechCorp's business evolves.

**Our TechCorp Story So Far:**
- **Module 1**: Established TechCorpDB architecture and file structure
- **Module 2**: Created core business tables and learned T-SQL fundamentals  
- **Module 3**: Mastered SELECT statements with TechCorp's expanding data
- **Module 4**: Explored complex relationships through JOINs across business entities
- **Module 5**: Implemented sophisticated sorting and filtering for business reports
- **Module 6**: Optimized data types for TechCorp's diverse business requirements

### Module 7 Prerequisites
```sql
-- Connect to our mature TechCorp database
USE TechCorpDB;
GO

-- Verify our complete schema foundation
SELECT 
    'TechCorp Database IsActive' as IsActive,
    DB_NAME() AS DatabaseName,
    GETDATE() AS Module7StartTime,
    SYSTEM_USER AS CurrentUser;

-- Verify our business data foundation
SELECT 
    'Companies' as Entity, COUNT(*) as Count FROM Companies
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments  
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'EmployeeProjects', COUNT(*) FROM EmployeeProjects;
```

## Exercise 1: Advanced INSERT Operations

### Task 1.1: TechCorp Business Growth - New Client Onboarding
**Business Scenario**: TechCorp has landed several major new clients and needs to expand their database to track additional business entities. We need to add new tables and populate them with data representing TechCorp's growth.

```sql
-- Add new business entities for TechCorp's expansion

-- 1. Client Contacts table - Track multiple contacts per client company
CREATE TABLE ClientContacts (
    ContactID INT PRIMARY KEY IDENTITY(5001,1),
    CompanyID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    WorkEmail NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- 2. Project Phases table - Break down projects into manageable phases
CREATE TABLE ProjectPhases (
    PhaseID INT PRIMARY KEY IDENTITY(4001,1),
    ProjectID INT NOT NULL,
    PhaseName NVARCHAR(100) NOT NULL,
    PhaseDescription NVARCHAR(500) NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    PlannedEndDate DATE NOT NULL,
    Budget DECIMAL(10,2) NOT NULL,
    IsActive NVARCHAR(20) NOT NULL DEFAULT 'Planning',
    CompletionPercentage DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- 3. TimeTracking table - Track employee hours on specific phases
CREATE TABLE TimeTracking (
    TimeEntryID INT PRIMARY KEY IDENTITY(6001,1),
    EmployeeID INT NOT NULL,
    PhaseID INT NOT NULL,
    WorkDate DATE NOT NULL,
    HoursWorked DECIMAL(4,2) NOT NULL,
    Description NVARCHAR(255) NULL,
    BillableHours DECIMAL(4,2) NOT NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PhaseID) REFERENCES ProjectPhases(PhaseID)
);
-- - IsActive: Default to true
-- - LastLoginDate: Nullable date/time
-- - CreatedBy: Auto-populated with current user
-- - ModifiedDate: Auto-populated with current date/time

CREATE TABLE Customers (
    -- Your solution here
    
    
    
    
    
    
    
    
    
);

-- 2. Categories table with business rules
-- Requirements:
-- - CategoryID: Auto-incrementing primary key
-- - CategoryName: Required, unique, max 100 characters
-- - Description: Optional, max 500 characters
-- - IsActive: Default to true
-- - DisplayOrder: Default to 99
-- - CreatedDate: Auto-populated

CREATE TABLE Categories (
    -- Your solution here
    
    
    
    
    
);

-- 3. Products table with computed columns
-- Requirements:
-- - ProductID: Auto-incrementing primary key
-- - CategoryID: Foreign key to Categories
-- - ProductName: Required, max 200 characters
-- - Description: Optional, large text field
-- - BaseSalary: Required, currency with 2 decimal places
-- - UnitsInStock: Default to 0
-- - ReorderLevel: Default to 10
-- - IsDiscontinued: Default to false
-- - SKU: Computed as 'PRD' + zero-padded ProductID (5 digits)
-- - StockIsActive: Computed based on UnitsInStock vs ReorderLevel
-- - CreatedDate: Auto-populated

CREATE TABLE Products (
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
);

-- Your solution here




```

### Task 1.2: Implement Bulk INSERT with Business Logic
```sql
-- TODO: Create a stored procedure that performs bulk customer registration
-- Requirements:
-- 1. Accept a table-valued parameter with customer data
-- 2. Validate email format before insertion
-- 3. Check for duplicate emails
-- 4. Generate welcome email flag based on registration source
-- 5. Return list of successfully registered customers
-- 6. Handle errors gracefully and provide meaningful messages

-- First, create the table type for bulk registration
CREATE TYPE CustomerRegistrationType AS TABLE (
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    WorkEmail NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    DateOfBirth DATE,
    RegistrationSource NVARCHAR(50)
);

-- Create the bulk registration procedure
CREATE PROCEDURE BulkRegisterCustomers
    @CustomerData CustomerRegistrationType READONLY,
    @RegistrationSource NVARCHAR(50) = 'Direct'
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
END;

-- Test the bulk registration procedure
DECLARE @TestCustomers CustomerRegistrationType;

INSERT INTO @TestCustomers (FirstName, LastName, WorkEmail, Phone, DateOfBirth, RegistrationSource)
VALUES 
    ('John', 'Smith', 'john.smith@email.com', '555-0101', '1985-03-15', 'Website'),
    ('Jane', 'Doe', 'jane.doe@email.com', '555-0102', '1990-07-22', 'Mobile App'),
    ('Bob', 'Johnson', 'bob.johnson@email.com', '555-0103', '1978-11-08', 'Referral'),
    ('Alice', 'Williams', 'alice.williams@email.com', '555-0104', '1992-01-30', 'Social Media'),
    ('Charlie', 'Brown', 'charlie.brown@email.com', '555-0105', '1988-05-17', 'Advertisement');

-- Execute the bulk registration
EXEC BulkRegisterCustomers @CustomerData = @TestCustomers, @RegistrationSource = 'Lab Test';

-- Your solution here




```

### Task 1.3: INSERT with Complex Business Rules
```sql
-- TODO: Create a product pricing system with the following requirements:
-- 1. Products can have multiple price tiers based on quantity
-- 2. Prices can vary by customer type and geographic region
-- 3. Implement automatic pricing rule generation based on product categories
-- 4. Use sequences for pricing rule numbering

-- Create supporting tables and sequences
CREATE SEQUENCE PricingRuleSequence
    AS INT
    START WITH 1000
    INCREMENT BY 1
    CACHE 50;

-- Customer types and regions tables
CREATE TABLE CustomerTypes (
    TypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    DiscountPercentage DECIMAL(5,2) DEFAULT 0.00,
    Description NVARCHAR(255)
);

CREATE TABLE Regions (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(100) NOT NULL UNIQUE,
    RegionCode NCHAR(3) NOT NULL UNIQUE,
    TaxRate DECIMAL(5,4) DEFAULT 0.0000,
    ShippingMultiplier DECIMAL(4,2) DEFAULT 1.00
);

-- TODO: Create ProductPricing table with complex business rules
-- Requirements:
-- - PricingRuleID: Use the sequence for numbering
-- - ProductID: Foreign key to Products
-- - CustomerTypeID: Foreign key to CustomerTypes (NULL for general pricing)
-- - RegionID: Foreign key to Regions (NULL for all regions)
-- - MinQuantity: Minimum quantity for this price tier
-- - MaxQuantity: Maximum quantity for this price tier (NULL for unlimited)
-- - BaseSalary: Price per unit for this tier
-- - EffectiveDate: When this pricing becomes active
-- - ExpirationDate: When this pricing expires (NULL for indefinite)
-- - IsActive: Whether this pricing rule is currently active

CREATE TABLE ProductPricing (
    -- Your solution here
    
    
    
    
    
    
    
    
    
);

-- TODO: Create a procedure to automatically generate pricing tiers
-- Requirements:
-- 1. Generate basic pricing tiers for new products (1-10, 11-50, 51+ units)
-- 2. Apply category-based discounts for higher quantities
-- 3. Create region-specific pricing where applicable
-- 4. Handle different customer type pricing

CREATE PROCEDURE GenerateProductPricingTiers
    @ProductID INT,
    @BasePrice DECIMAL(10,2)
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
END;

-- Your solution here




```

## Exercise 2: Advanced UPDATE Operations

### Task 2.1: Implement Complex Price Updates with Audit Trail
```sql
-- TODO: Create a comprehensive price update system
-- Requirements:
-- 1. Update product prices based on various business rules
-- 2. Maintain complete audit trail of all price changes
-- 3. Implement percentage-based and fixed-amount adjustments
-- 4. Handle different update scenarios (category-wide, individual products, etc.)

-- Create price history audit table
CREATE TABLE ProductPriceHistory (
    PriceHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeType NVARCHAR(50),
    ChangeReason NVARCHAR(255),
    EffectiveDate DATETIME2 DEFAULT SYSDATETIME(),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ApprovedBy INT NULL, -- EmployeeID who approved the change
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- TODO: Create a stored procedure for smart price updates
-- Requirements:
-- 1. Support different update types: percentage increase/decrease, fixed amount
-- 2. Allow filtering by category, price range, stock levels
-- 3. Implement approval workflow for large price changes
-- 4. Provide rollback capability
-- 5. Generate comprehensive change summary

CREATE PROCEDURE UpdateProductPrices
    @UpdateType NVARCHAR(20), -- 'PERCENTAGE', 'FIXED_AMOUNT'
    @AdjustmentValue DECIMAL(10,2),
    @CategoryID INT = NULL,
    @MinCurrentPrice DECIMAL(10,2) = NULL,
    @MaxCurrentPrice DECIMAL(10,2) = NULL,
    @MinStockLevel INT = NULL,
    @ChangeReason NVARCHAR(255),
    @RequireApproval BIT = 0,
    @ApprovedBy INT = NULL,
    @PreviewOnly BIT = 0 -- Set to 1 to see what would change without making changes
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Test the price update procedure with various scenarios
-- Test 1: 10% price increase for Electronics category
-- Test 2: $5.00 fixed increase for products under $50
-- Test 3: Preview-only mode for large price changes

-- Your solution here




```

### Task 2.2: Customer Data Management and Synchronization
```sql
-- TODO: Implement customer data synchronization system
-- Requirements:
-- 1. Update customer information from external data sources
-- 2. Handle data conflicts and validation
-- 3. Maintain data quality scores
-- 4. Implement smart merging of duplicate customer records

-- Create customer data quality tracking
ALTER TABLE Customers ADD 
    DataQualityScore INT DEFAULT 100,
    LastDataUpdate DATETIME2 DEFAULT SYSDATETIME(),
    DataSourceLastUpdate NVARCHAR(100) DEFAULT 'Manual Entry';

-- Create external data staging table
CREATE TABLE CustomerDataStaging (
    StagingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL, -- NULL for new customers
    WorkEmail NVARCHAR(100) NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(20),
    DateOfBirth DATE,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(50),
    ZipCode NVARCHAR(20),
    DataSource NVARCHAR(100),
    ImportDate DATETIME2 DEFAULT SYSDATETIME(),
    ProcessedFlag BIT DEFAULT 0,
    ConflictFlag BIT DEFAULT 0,
    Notes NVARCHAR(MAX)
);

-- TODO: Create procedure to process staged customer data
-- Requirements:
-- 1. Match staging records to existing customers by email
-- 2. Identify and flag potential duplicates
-- 3. Update customer records with newer, more complete data
-- 4. Calculate and update data quality scores
-- 5. Handle address standardization

CREATE PROCEDURE ProcessStagedCustomerData
    @DataSource NVARCHAR(100),
    @OverwritePolicy NVARCHAR(20) = 'NEWER_WINS' -- 'NEWER_WINS', 'STAGING_WINS', 'MANUAL_REVIEW'
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Insert test data into staging table and process it
-- Include scenarios for: new customers, existing customer updates, potential duplicates

-- Your solution here




```

### Task 2.3: Inventory Management with Business Rules
```sql
-- TODO: Implement sophisticated inventory management system
-- Requirements:
-- 1. Automatic reorder point calculations based on sales velocity
-- 2. Seasonal adjustments for stock levels
-- 3. Category-based inventory rules
-- 4. Integration with supplier lead times

-- Create supporting tables
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    LeadTimeDays INT DEFAULT 7,
    MinimumOrderQuantity INT DEFAULT 1,
    IsActive BIT DEFAULT 1
);

CREATE TABLE ProductSuppliers (
    ProductSupplierID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    SupplierID INT NOT NULL,
    SupplierProductCode NVARCHAR(50),
    Cost DECIMAL(10,2),
    IsPrimarySupplier BIT DEFAULT 0,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE InventoryTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    TransactionType NVARCHAR(20) NOT NULL, -- 'SALE', 'PURCHASE', 'ADJUSTMENT', 'RETURN'
    Quantity INT NOT NULL,
    UnitCost DECIMAL(10,2),
    TransactionDate DATETIME2 DEFAULT SYSDATETIME(),
    Reference NVARCHAR(100),
    Notes NVARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- TODO: Create stored procedure for intelligent inventory updates
-- Requirements:
-- 1. Calculate optimal reorder points based on sales history
-- 2. Adjust for seasonal patterns
-- 3. Consider supplier lead times and minimum order quantities
-- 4. Flag products that need immediate attention

CREATE PROCEDURE UpdateInventoryReorderPoints
    @AnalysisPeriodDays INT = 90,
    @SeasonalAdjustment BIT = 1,
    @SafetyStockDays INT = 7
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Create sample data and test the inventory management system
-- Include various transaction types and patterns

-- Your solution here




```

## Exercise 3: Advanced DELETE Operations

### Task 3.1: Implement Safe Data Archival System
```sql
-- TODO: Create a comprehensive data archival system
-- Requirements:
-- 1. Implement soft delete functionality
-- 2. Create archival process for old data
-- 3. Maintain referential integrity during archival
-- 4. Provide data restoration capabilities

-- Add soft delete columns to main tables
ALTER TABLE Customers ADD 
    IsDeleted BIT DEFAULT 0,
    DeletedDate DATETIME2 NULL,
    DeletedBy NVARCHAR(100) NULL,
    DeleteReason NVARCHAR(255) NULL;

ALTER TABLE Products ADD 
    IsDeleted BIT DEFAULT 0,
    DeletedDate DATETIME2 NULL,
    DeletedBy NVARCHAR(100) NULL,
    DeleteReason NVARCHAR(255) NULL;

-- Create archive tables
CREATE TABLE CustomersArchive (
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    WorkEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    DateOfBirth DATE,
    RegistrationDate DATETIME2,
    IsActive BIT,
    LastLoginDate DATETIME2,
    -- Archive-specific fields
    ArchivedDate DATETIME2 DEFAULT SYSDATETIME(),
    ArchivedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ArchiveReason NVARCHAR(255),
    OriginalDeleteDate DATETIME2,
    CanRestore BIT DEFAULT 1
);

-- TODO: Create comprehensive soft delete procedure
-- Requirements:
-- 1. Soft delete with cascade to related records
-- 2. Validate business rules before deletion
-- 3. Create audit trail
-- 4. Handle different entity types

CREATE PROCEDURE SoftDeleteWithCascade
    @EntityType NVARCHAR(50), -- 'CUSTOMER', 'PRODUCT', 'CATEGORY'
    @EntityID INT,
    @DeleteReason NVARCHAR(255),
    @CascadeDelete BIT = 1
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Create archival procedure for old deleted records
-- Requirements:
-- 1. Move soft-deleted records older than specified period to archive
-- 2. Maintain referential integrity
-- 3. Compress archived data
-- 4. Generate archival reports

CREATE PROCEDURE ArchiveDeletedRecords
    @ArchiveAfterDays INT = 90,
    @EntityType NVARCHAR(50) = 'ALL' -- 'ALL', 'CUSTOMER', 'PRODUCT'
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Test the soft delete and archival system
-- Test scenarios:
-- 1. Soft delete customer with cascade
-- 2. Soft delete product and check impact
-- 3. Archive old deleted records
-- 4. Attempt to restore archived data

-- Your solution here




```

### Task 3.2: Data Cleanup and Maintenance Operations
```sql
-- TODO: Implement comprehensive data cleanup procedures
-- Requirements:
-- 1. Remove orphaned records
-- 2. Clean up test and invalid data
-- 3. Remove duplicate records intelligently
-- 4. Optimize database performance through cleanup

-- Create data quality analysis table
CREATE TABLE DataQualityIssues (
    IssueID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    IssueType NVARCHAR(50), -- 'ORPHAN', 'DUPLICATE', 'INVALID', 'INCOMPLETE'
    RecordID INT,
    IssueDescription NVARCHAR(500),
    Severity NVARCHAR(20), -- 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL'
    DetectedDate DATETIME2 DEFAULT SYSDATETIME(),
    ResolvedDate DATETIME2 NULL,
    Resolution NVARCHAR(255) NULL
);

-- TODO: Create procedure to identify data quality issues
CREATE PROCEDURE AnalyzeDataQuality
AS
BEGIN
    -- Your solution here
    -- Identify:
    -- 1. Orphaned records in child tables
    -- 2. Duplicate customer records (same email, similar names)
    -- 3. Invalid data (negative prices, future birth dates, etc.)
    -- 4. Incomplete records (missing required business data)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Create procedure to fix data quality issues
CREATE PROCEDURE ResolveDataQualityIssues
    @IssueType NVARCHAR(50) = 'ALL',
    @Severity NVARCHAR(20) = 'ALL',
    @AutoFix BIT = 0 -- Set to 1 to automatically fix issues, 0 to just report
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Test the data quality system
-- 1. Run data quality analysis
-- 2. Review identified issues
-- 3. Resolve issues (first in preview mode, then actual fixes)

-- Your solution here




```

## Exercise 4: Automatic Column Value Generation Integration

### Task 4.1: Implement Complete Audit System with Temporal Tables
```sql
-- TODO: Create a comprehensive audit system using multiple automatic value generation techniques
-- Requirements:
-- 1. Use temporal tables for automatic history tracking
-- 2. Implement custom audit logging with sequences
-- 3. Create audit summary reports with computed columns
-- 4. Use GUIDs for distributed audit correlation

-- Create audit correlation sequence
CREATE SEQUENCE AuditBatchSequence
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    CACHE 100;

-- TODO: Create system-versioned temporal table for product changes
CREATE TABLE ProductsWithHistory (
    -- Your solution here
    -- Requirements:
    -- - All product fields from original Products table
    -- - System-versioned temporal columns
    -- - Audit correlation fields
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
);

-- TODO: Create custom audit log table with automatic value generation
CREATE TABLE CustomAuditLog (
    -- Your solution here
    -- Requirements:
    -- - Use sequence for audit log numbering
    -- - Include GUID for correlation across systems
    -- - Automatic timestamps and user tracking
    -- - Computed columns for audit analysis
    
    
    
    
    
    
    
    
    
    
    
);

-- TODO: Create triggers to populate custom audit log
-- Requirements:
-- 1. Log all INSERT, UPDATE, DELETE operations
-- 2. Capture before and after values
-- 3. Include business context information
-- 4. Handle batch operations efficiently

-- Your solution here




```

### Task 4.2: Document Management System with Advanced Auto-Generation
```sql
-- TODO: Create a complete document management system
-- Requirements:
-- 1. Use GUIDs for document identification
-- 2. Implement automatic versioning with sequences
-- 3. Create computed columns for document analysis
-- 4. Use defaults for metadata and classification

-- Create document classification sequence
CREATE SEQUENCE DocumentVersionSequence
    AS INT
    START WITH 1
    INCREMENT BY 1
    CYCLE
    MAXVALUE 9999
    CACHE 50;

-- TODO: Create comprehensive document table
CREATE TABLE Documents (
    -- Your solution here
    -- Requirements:
    -- - GUID primary key
    -- - Sequential version numbering within document
    -- - Automatic content analysis (computed columns)
    -- - Default values for metadata
    -- - Audit fields with automatic population
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
);

-- TODO: Create document operations with business logic
-- Requirements:
-- 1. Document check-in/check-out system
-- 2. Automatic version management
-- 3. Content-based classification
-- 4. Access control integration

-- Your solution here




```

## Exercise 5: Integration Challenge - Complete Business Workflow

### Task 5.1: E-commerce Order Processing System
```sql
-- TODO: Create a complete order processing system that integrates all DML concepts
-- Requirements:
-- 1. Order placement with inventory checking and automatic updates
-- 2. Payment processing with audit trails
-- 3. Shipping integration with automatic status updates
-- 4. Customer communication triggers
-- 5. Comprehensive reporting with computed values

-- Create order-related tables
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    IsActive NVARCHAR(20) DEFAULT 'Pending',
    SubTotal DECIMAL(12,2),
    TaxAmount DECIMAL(12,2),
    ShippingAmount DECIMAL(12,2),
    TotalAmount AS (SubTotal + TaxAmount + ShippingAmount) PERSISTED,
    ShippingAddress NVARCHAR(MAX),
    BillingAddress NVARCHAR(MAX),
    -- Audit fields
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    ModifiedDate DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) DEFAULT 0.00,
    LineTotal AS ((Quantity * BaseSalary) - DiscountAmount) PERSISTED,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- TODO: Create comprehensive order processing procedure
-- Requirements:
-- 1. Validate customer and product information
-- 2. Check inventory availability
-- 3. Calculate pricing including discounts and taxes
-- 4. Reserve inventory during order processing
-- 5. Handle payment processing simulation
-- 6. Update all related systems
-- 7. Generate confirmation and trigger notifications

CREATE PROCEDURE ProcessOrder
    @CustomerID INT,
    @OrderItems NVARCHAR(MAX), -- JSON array of order items
    @ShippingAddress NVARCHAR(MAX),
    @BillingAddress NVARCHAR(MAX) = NULL,
    @PaymentMethod NVARCHAR(50),
    @OrderID INT OUTPUT
AS
BEGIN
    -- Your solution here
    -- This should be a comprehensive procedure that demonstrates
    -- all the DML concepts learned in this module
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Test the complete order processing system
-- Include test cases for:
-- 1. Successful order placement
-- 2. Insufficient inventory scenarios
-- 3. Invalid customer/product scenarios
-- 4. Payment processing failures
-- 5. Bulk order processing

-- Your solution here




```

### Task 5.2: Reporting and Analytics with DML Integration
```sql
-- TODO: Create comprehensive reporting system
-- Requirements:
-- 1. Real-time sales analytics with automatic updates
-- 2. Customer behavior analysis with computed metrics
-- 3. Inventory turnover analysis
-- 4. Financial reporting with audit integration

-- Create reporting tables with automatic population
CREATE TABLE SalesAnalytics (
    AnalyticsID INT IDENTITY(1,1) PRIMARY KEY,
    ReportDate DATE DEFAULT CAST(GETDATE() AS DATE),
    ProductID INT NOT NULL,
    CategoryID INT NOT NULL,
    TotalQuantitySold INT DEFAULT 0,
    TotalRevenue DECIMAL(12,2) DEFAULT 0.00,
    AverageOrderValue AS CASE WHEN TotalQuantitySold > 0 THEN TotalRevenue / TotalQuantitySold ELSE 0 END,
    UniqueCustomers INT DEFAULT 0,
    LastUpdated DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- TODO: Create triggers or procedures to maintain analytics tables
-- Requirements:
-- 1. Update analytics in real-time as orders are processed
-- 2. Maintain data consistency across all analytics tables
-- 3. Handle historical data corrections
-- 4. Optimize for query performance

-- Your solution here




```

## Challenge Exercises

### Challenge 1: Multi-Tenant Data Management
```sql
-- CHALLENGE: Design and implement a multi-tenant system
-- Requirements:
-- 1. Support multiple organizations in single database
-- 2. Ensure complete data isolation between tenants
-- 3. Implement tenant-aware automatic value generation
-- 4. Create cross-tenant reporting for system administrators
-- 5. Handle tenant provisioning and deprovisioning

-- Your solution here




```

### Challenge 2: Distributed Transaction Coordination
```sql
-- CHALLENGE: Implement distributed transaction patterns
-- Requirements:
-- 1. Coordinate transactions across multiple related systems
-- 2. Implement compensation patterns for failed transactions
-- 3. Create saga pattern for long-running business processes
-- 4. Handle eventual consistency scenarios
-- 5. Implement distributed locking mechanisms

-- Your solution here




```

### Challenge 3: Real-Time Data Synchronization
```sql
-- CHALLENGE: Create real-time data synchronization system
-- Requirements:
-- 1. Synchronize data changes across multiple databases
-- 2. Handle conflict resolution for concurrent updates
-- 3. Implement incremental sync with change tracking
-- 4. Create failover and recovery mechanisms
-- 5. Monitor and report synchronization health

-- Your solution here




```

## Performance and Optimization Exercises

### Task: DML Performance Analysis and Optimization
```sql
-- TODO: Analyze and optimize DML operations for performance
-- Requirements:
-- 1. Create performance baseline measurements
-- 2. Identify bottlenecks in DML operations
-- 3. Implement optimization strategies
-- 4. Compare before and after performance metrics

-- Create performance monitoring table
CREATE TABLE DMLPerformanceLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OperationType NVARCHAR(50),
    TableName NVARCHAR(100),
    RowsAffected INT,
    ExecutionTimeMS INT,
    CPUTimeMS INT,
    LogicalReads INT,
    PhysicalReads INT,
    TestScenario NVARCHAR(100),
    OptimizationApplied NVARCHAR(255),
    ExecutionDate DATETIME2 DEFAULT SYSDATETIME()
);

-- TODO: Create performance testing procedures
-- Test scenarios:
-- 1. Bulk INSERT operations with different batch sizes
-- 2. UPDATE operations with and without proper indexing
-- 3. DELETE operations with cascade vs. manual cleanup
-- 4. Transaction isolation level impact on performance
-- 5. Computed column vs. calculated field performance

-- Your solution here




```

## Validation and Testing

### Automated Testing Framework
```sql
-- Create comprehensive testing framework for DML operations

-- Test results table
CREATE TABLE TestResults (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestName NVARCHAR(100),
    TestCategory NVARCHAR(50),
    Expected NVARCHAR(MAX),
    Actual NVARCHAR(MAX),
    IsActive NVARCHAR(20), -- 'PASS', 'FAIL', 'ERROR'
    ErrorMessage NVARCHAR(MAX),
    ExecutionTime INT,
    TestDate DATETIME2 DEFAULT SYSDATETIME()
);

-- TODO: Create test procedures for each exercise
-- Requirements:
-- 1. Validate data integrity after DML operations
-- 2. Test business rule enforcement
-- 3. Verify audit trail completeness
-- 4. Check performance benchmarks
-- 5. Validate error handling

-- Example test procedure
CREATE PROCEDURE TestCustomerRegistration
AS
BEGIN
    -- Your test implementation here
    
    
    
    
    
    
    
    
    
    
    
END;

-- TODO: Create master test execution procedure
CREATE PROCEDURE RunAllDMLTests
AS
BEGIN
    -- Your solution here
    
    
    
    
    
    
    
    
    
    
    
END;

-- Execute all tests
EXEC RunAllDMLTests;

-- View test results
SELECT 
    TestCategory,
    COUNT(*) AS TotalTests,
    SUM(CASE WHEN IsActive = 'PASS' THEN 1 ELSE 0 END) AS PassedTests,
    SUM(CASE WHEN IsActive = 'FAIL' THEN 1 ELSE 0 END) AS FailedTests,
    SUM(CASE WHEN IsActive = 'ERROR' THEN 1 ELSE 0 END) AS ErrorTests,
    AVG(ExecutionTime) AS AvgExecutionTimeMS
FROM TestResults
GROUP BY TestCategory
ORDER BY TestCategory;
```

## Lab Completion Checklist

### Basic Requirements (Must Complete)
- [ ] Exercise 1: Advanced INSERT operations with bulk processing
- [ ] Exercise 2: Complex UPDATE operations with audit trails
- [ ] Exercise 3: Safe DELETE operations with archival
- [ ] Exercise 4: Automatic value generation integration
- [ ] All tables created with appropriate constraints and defaults
- [ ] Sample data inserted and operations tested
- [ ] Basic error handling implemented

### Advanced Requirements (Recommended)
- [ ] Exercise 5: Complete business workflow integration
- [ ] Performance optimization exercises completed
- [ ] Comprehensive audit system implemented
- [ ] Data quality management system created
- [ ] At least one challenge exercise attempted
- [ ] Automated testing framework implemented

### Expert Level (Optional)
- [ ] All challenge exercises completed
- [ ] Multi-tenant architecture implemented
- [ ] Real-time synchronization system created
- [ ] Distributed transaction patterns implemented
- [ ] Performance benchmarking and optimization completed
- [ ] Complete documentation of design decisions

## Troubleshooting Guide

### Common Issues and Solutions

#### Transaction Deadlocks
```sql
-- Monitor deadlocks
SELECT 
    session_id,
    blocking_session_id,
    wait_type,
    wait_time,
    wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;

-- Solution: Implement proper transaction ordering and timeouts
```

#### IDENTITY Gaps and Sequence Issues
```sql
-- Check IDENTITY current value
DBCC CHECKIDENT('TableName', NORESEED);

-- Reset IDENTITY to proper value
DBCC CHECKIDENT('TableName', RESEED, NewValue);

-- Check SEQUENCE current value
SELECT current_value FROM sys.sequences WHERE name = 'SequenceName';
```

#### Performance Issues
```sql
-- Monitor DML performance
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Your DML operation here

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- Check execution plans for optimization opportunities
```

#### Constraint Violations
```sql
-- Identify constraint violations before they occur
-- Check foreign key constraints
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    tc.name AS ChildTable,
    cp.name AS ParentColumn,
    cc.name AS ChildColumn
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.referenced_object_id = tp.object_id
INNER JOIN sys.tables tc ON fk.parent_object_id = tc.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.referenced_object_id = cp.object_id AND fkc.referenced_column_id = cp.column_id
INNER JOIN sys.columns cc ON fkc.parent_object_id = cc.object_id AND fkc.parent_column_id = cc.column_id;
```

## Lab Assessment Criteria

### Evaluation Points (100 total)
1. **Correct DML Implementation (30 points)**
   - Proper INSERT, UPDATE, DELETE syntax
   - Appropriate use of OUTPUT clauses
   - Correct transaction handling

2. **Business Logic Implementation (25 points)**
   - Realistic business scenarios
   - Proper constraint enforcement
   - Error handling and validation

3. **Automatic Value Generation (20 points)**
   - Appropriate use of IDENTITY, SEQUENCE, defaults
   - Computed columns implementation
   - Audit trail automation

4. **Performance and Optimization (15 points)**
   - Efficient query design
   - Proper indexing strategies
   - Batch processing techniques

5. **Code Quality and Documentation (10 points)**
   - Clear, readable SQL code
   - Comprehensive commenting
   - Proper error handling

### Bonus Points (up to 15 additional)
- Creative solutions to challenge exercises
- Advanced performance optimization
- Comprehensive testing framework
- Real-world applicability of solutions
- Innovation in automatic value generation

Remember to test all solutions thoroughly and verify that your DML operations maintain data integrity while providing optimal performance for real-world scenarios!
