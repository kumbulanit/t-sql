# Lesson 3: Creating Simple Stored Procedures

## Overview

Creating stored procedures is a fundamental skill for database developers and administrators, enabling the encapsulation of business logic, data validation, and complex operations within the database layer. Simple stored procedures form the foundation for more advanced database programming and provide immediate benefits in terms of code reusability, performance optimization, and security enhancement. For TechCorp's development teams, mastering stored procedure creation enables the implementation of standardized data access patterns and centralized business rule enforcement.

## 🏢 TechCorp Business Context

**Stored Procedure Creation in Enterprise Development:**
- **Business Logic Centralization**: Centralized business rules and calculations in database layer
- **Data Access Standardization**: Consistent data manipulation patterns across applications
- **Performance Optimization**: Pre-compiled execution plans for frequently used operations
- **Security Enhancement**: Controlled data access through procedure interfaces
- **Code Reusability**: Shared database functionality across multiple applications and systems

### 📋 TechCorp Database Schema Reference

**Core Tables for Stored Procedure Development:**
```sql
Employees: e.EmployeeID (3001+), e.FirstName, e.LastName, e.BaseSalary, d.DepartmentID, ManagerID, e.JobTitle, e.HireDate, WorkEmail, IsActive
Departments: d.DepartmentID (2001+), d.DepartmentName, d.Budget, Location, IsActive
Projects: ProjectID (4001+), ProjectName, d.Budget, ProjectManagerID, StartDate, EndDate, IsActive
Orders: OrderID (5001+), CustomerID, e.EmployeeID, OrderDate, TotalAmount, IsActive
EmployeeProjects: e.EmployeeID, ProjectID, Role, StartDate, EndDate, HoursWorked, IsActive
Customers: CustomerID (6001+), CompanyName, ContactName, City, Country, WorkEmail, IsActive
```

## Stored Procedure Creation Fundamentals

### Basic CREATE PROCEDURE Syntax

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Stored Procedure Creation Syntax                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  CREATE PROCEDURE procedure_name                                            │
│      @parameter1 datatype = default_value,                                 │
│      @parameter2 datatype OUTPUT                                           │
│  AS                                                                         │
│  BEGIN                                                                      │
│      -- Procedure body                                                     │
│      SET NOCOUNT ON;  -- Suppress row count messages                      │
│                                                                             │
│      -- Variable declarations                                              │
│      DECLARE @variable datatype;                                           │
│                                                                             │
│      -- Error handling                                                     │
│      BEGIN TRY                                                             │
│          -- Main logic                                                     │
│          SELECT columns FROM tables WHERE conditions;                      │
│      END TRY                                                               │
│      BEGIN CATCH                                                           │
│          -- Error handling logic                                          │
│          THROW;                                                            │
│      END CATCH                                                             │
│                                                                             │
│      RETURN return_value;  -- Optional return code                        │
│  END                                                                        │
│                                                                             │
│  Key Components:                                                           │
│  • CREATE PROCEDURE: Defines new stored procedure                         │
│  • Parameters: Input/output data interfaces                               │
│  • AS BEGIN...END: Procedure body encapsulation                          │
│  • SET NOCOUNT ON: Performance optimization                               │
│  • TRY...CATCH: Error handling blocks                                     │
│  • RETURN: Status code return                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Essential Components of Well-Designed Procedures

```sql
-- Template for well-structured TechCorp stored procedures
CREATE PROCEDURE sp_TechCorpTemplate
    @InputParameter INT,
    @OptionalParameter VARCHAR(50) = 'Default Value',
    @OutputParameter INT OUTPUT
AS
BEGIN
    -- 1. Set options for performance and consistency
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    -- 2. Declare local variables
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ReturnCode INT = 0;
    
    -- 3. Initialize output parameters
    SET @OutputParameter = 0;
    
    -- 4. Input validation
    IF @InputParameter IS NULL OR @InputParameter <= 0
    BEGIN
        RAISERROR('Invalid input parameter value.', 16, 1);
        RETURN -1;
    END
    
    -- 5. Main procedure logic with error handling
    BEGIN TRY
        -- Business logic implementation
        -- Data manipulation operations
        -- Calculations and processing
        
    END TRY
    BEGIN CATCH
        -- Error handling and logging
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -99;
    END CATCH
    
    -- 6. Return success code
    RETURN @ReturnCode;
END;
```

## Creating Basic Data Retrieval Procedures

### 1. Simple Employee Lookup Procedures

#### TechCorp Example: Basic Employee Information Retrieval
```sql
-- Create simple employee lookup procedure
CREATE PROCEDURE sp_GetEmployeeBasicInfo
    @e.EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @e.EmployeeID IS NULL OR @e.EmployeeID <= 0
    BEGIN
        RAISERROR('Employee ID must be a positive integer.', 16, 1);
        RETURN -1;
    END
    
    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID)
    BEGIN
        RAISERROR('Employee ID %d does not exist.', 16, 1, @e.EmployeeID);
        RETURN -2;
    END
    
    -- Return employee information
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
        e.BaseSalary,
        d.DepartmentName,
        d.Location AS DepartmentLocation,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        CASE 
            WHEN e.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS EmployeeStatus,
        -- Manager information
        CASE 
            WHEN e.ManagerID IS NOT NULL 
            THEN mgr.e.FirstName + ' ' + mgr.e.LastName
            ELSE 'No Manager Assigned'
        END AS ManagerName,
        -- Service classification
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 10 THEN 'Veteran Employee'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN 'Experienced Employee'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 2 THEN 'Established Employee'
            ELSE 'New Employee'
        END AS ServiceCategory
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.e.EmployeeID
    WHERE e.EmployeeID = @e.EmployeeID
      AND d.IsActive = 1;
    
    RETURN 0;  -- Success
END;

-- Test the procedure
EXEC sp_GetEmployeeBasicInfo @e.EmployeeID = 3001;
EXEC sp_GetEmployeeBasicInfo @e.EmployeeID = 99999;  -- Test error handling
```

#### TechCorp Example: d.DepartmentName Employee List Procedure
```sql
-- Create procedure to list all employees in a d.DepartmentName
CREATE PROCEDURE sp_GetDepartmentEmployeeList
    @d.DepartmentID INT,
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @d.DepartmentID IS NULL OR @d.DepartmentID <= 0
    BEGIN
        RAISERROR('Department ID must be a positive integer.', 16, 1);
        RETURN -1;
    END
    
    -- Verify d.DepartmentName exists
    IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
    BEGIN
        RAISERROR('Department ID %d does not exist or is inactive.', 16, 1, @d.DepartmentID);
        RETURN -2;
    END
    
    -- Get d.DepartmentName information for context
    DECLARE @d.DepartmentName VARCHAR(100), @Location VARCHAR(100);
    SELECT @d.DepartmentName = d.DepartmentName,
        @Location = Location
    FROM Departments d 
    WHERE d.DepartmentID = @d.DepartmentID;
    
    -- Return d.DepartmentName header information
    SELECT 
        @d.DepartmentID AS d.DepartmentID,
        @d.DepartmentName AS d.DepartmentName,
        @Location AS Location,
        GETDATE() AS ReportGeneratedDate,
        @IncludeInactive AS IncludesInactiveEmployees;
    
    -- Return employee list
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.JobTitle,
        FORMAT(e.BaseSalary, 'C') AS e.BaseSalary,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        e.WorkEmail,
        CASE 
            WHEN e.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS Status,
        -- Manager information
        CASE 
            WHEN e.ManagerID IS NOT NULL 
            THEN mgr.e.FirstName + ' ' + mgr.e.LastName
            ELSE 'No Manager'
        END AS ManagerName,
        -- Employee classification
        CASE 
            WHEN e.BaseSalary >= 80000 THEN 'Senior Level'
            WHEN e.BaseSalary >= 60000 THEN 'Mid Level'
            WHEN e.BaseSalary >= 40000 THEN 'Junior Level'
            ELSE 'Entry Level'
        END AS SalaryLevel,
        -- Row number for reporting
        ROW_NUMBER() OVER (ORDER BY e.LastName, e.FirstName) AS RowNumber
    FROM Employees e
    LEFT JOIN Employees mgr ON e.ManagerID = mgr.e.EmployeeID
    WHERE e.d.DepartmentID = @d.DepartmentID
      AND (e.IsActive = 1 OR @IncludeInactive = 1)
    ORDER BY e.LastName, e.FirstName;
    
    -- Return summary statistics
    SELECT 
        COUNT(*) AS TotalEmployeesListed,
        SUM(CASE WHEN e.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveEmployees,
        SUM(CASE WHEN e.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveEmployees,
        FORMAT(AVG(CASE WHEN e.IsActive = 1 THEN e.BaseSalary ELSE NULL END), 'C') AS AverageActiveSalary,
        FORMAT(SUM(CASE WHEN e.IsActive = 1 THEN e.BaseSalary ELSE 0 END), 'C') AS TotalActivePayroll
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.d.DepartmentID = @d.DepartmentID
      AND (e.IsActive = 1 OR @IncludeInactive = 1);
    
    RETURN 0;  -- Success
END;

-- Test the procedure
EXEC sp_GetDepartmentEmployeeList @d.DepartmentID = 2001;
EXEC sp_GetDepartmentEmployeeList @d.DepartmentID = 2002, @IncludeInactive = 1;
```

### 2. Customer and Order Procedures

#### TechCorp Example: Customer Information Retrieval
```sql
-- Create procedure for customer information and order history
CREATE PROCEDURE sp_GetCustomerProfile
    @CustomerID INT,
    @IncludeOrderHistory BIT = 1,
    @MaxOrdersToShow INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Input validation
    IF @CustomerID IS NULL OR @CustomerID <= 0
    BEGIN
        RAISERROR('Customer ID must be a positive integer.', 16, 1);
        RETURN -1;
    END
    
    IF @MaxOrdersToShow <= 0 OR @MaxOrdersToShow > 100
    BEGIN
        SET @MaxOrdersToShow = 10;  -- Default to reasonable limit
    END
    
    -- Verify customer exists
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID AND IsActive = 1)
    BEGIN
        RAISERROR('Customer ID %d does not exist or is inactive.', 16, 1, @CustomerID);
        RETURN -2;
    END
    
    -- Return customer basic information
    SELECT 
        c.CustomerID,
        c.CustomerName,
        CONCAT(c.ContactFirstName, ' ', c.ContactLastName),
        c.City,
        c.CountryID,
        c.WorkEmail,
        -- Order statistics
        ISNULL(order_stats.TotalOrders, 0) AS TotalOrderCount,
        ISNULL(FORMAT(order_stats.TotalOrderValue, 'C'), '$0.00') AS TotalOrderValue,
        ISNULL(FORMAT(order_stats.AverageOrderValue, 'C'), '$0.00') AS AverageOrderValue,
        order_stats.FirstOrderDate,
        order_stats.LastOrderDate,
        CASE 
            WHEN order_stats.LastOrderDate >= DATEADD(MONTH, -3, GETDATE()) THEN 'Active'
            WHEN order_stats.LastOrderDate >= DATEADD(MONTH, -6, GETDATE()) THEN 'Recently Active'
            WHEN order_stats.LastOrderDate >= DATEADD(YEAR, -1, GETDATE()) THEN 'Dormant'
            WHEN order_stats.LastOrderDate IS NOT NULL THEN 'Inactive'
            ELSE 'No Orders'
        END AS CustomerStatus,
        -- Customer classification
        CASE 
            WHEN ISNULL(order_stats.TotalOrderValue, 0) >= 100000 THEN 'Premium Customer'
            WHEN ISNULL(order_stats.TotalOrderValue, 0) >= 50000 THEN 'High Value Customer'
            WHEN ISNULL(order_stats.TotalOrderValue, 0) >= 20000 THEN 'Standard Customer'
            WHEN ISNULL(order_stats.TotalOrderValue, 0) >= 5000 THEN 'Growing Customer'
            WHEN ISNULL(order_stats.TotalOrderValue, 0) > 0 THEN 'New Customer'
            ELSE 'Prospect'
        END AS CustomerClassification
    FROM Customers c
    LEFT JOIN (
        SELECT 
            o.CustomerID,
            COUNT(o.OrderID) AS TotalOrders,
            SUM(o.TotalAmount) AS TotalOrderValue,
            AVG(o.TotalAmount) AS AverageOrderValue,
            MIN(o.OrderDate) AS FirstOrderDate,
            MAX(o.OrderDate) AS LastOrderDate
        FROM Orders o
        WHERE o.IsActive = 1
        GROUP BY o.CustomerID
    ) order_stats ON c.CustomerID = order_stats.CustomerID
    WHERE c.CustomerID = @CustomerID;
    
    -- Return recent order history if requested
    IF @IncludeOrderHistory = 1
    BEGIN
        SELECT 
            o.OrderID,
            o.OrderDate,
            FORMAT(o.TotalAmount, 'C') AS OrderAmount,
            e.FirstName + ' ' + e.LastName AS ProcessedBy,
            d.DepartmentName AS ProcessingDepartment,
            DATEDIFF(DAY, o.OrderDate, GETDATE()) AS DaysAgo,
            -- Order classification
            CASE 
                WHEN o.TotalAmount >= 10000 THEN 'Large Order'
                WHEN o.TotalAmount >= 5000 THEN 'Medium Order'
                WHEN o.TotalAmount >= 1000 THEN 'Standard Order'
                ELSE 'Small Order'
            END AS OrderSize,
            ROW_NUMBER() OVER (ORDER BY o.OrderDate DESC) AS OrderRank
        FROM Orders o
        INNER JOIN Employees e ON o.e.EmployeeID = e.EmployeeID
        INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
        WHERE o.CustomerID = @CustomerID
          AND o.IsActive = 1
          AND e.IsActive = 1
          AND d.IsActive = 1
        ORDER BY o.OrderDate DESC
        OFFSET 0 ROWS FETCH NEXT @MaxOrdersToShow ROWS ONLY;
    END
    
    RETURN 0;  -- Success
END;

-- Test the procedure
EXEC sp_GetCustomerProfile @CustomerID = 6001;
EXEC sp_GetCustomerProfile @CustomerID = 6002, @IncludeOrderHistory = 0;
EXEC sp_GetCustomerProfile @CustomerID = 6003, @MaxOrdersToShow = 5;
```

## Creating Data Modification Procedures

### 1. Employee Management Procedures

#### TechCorp Example: Add New Employee Procedure
```sql
-- Create procedure to add new employee with validation
CREATE PROCEDURE sp_AddNewEmployee
    @e.FirstName VARCHAR(50),
    @e.LastName VARCHAR(50),
    @e.JobTitle VARCHAR(100),
    @e.BaseSalary DECIMAL(10,2),
    @d.DepartmentID INT,
    @ManagerID INT = NULL,
    @WorkEmail VARCHAR(100),
    @e.HireDate DATE = NULL,
    @NewEmployeeID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  -- Ensure transaction consistency
    
    -- Initialize output parameter
    SET @NewEmployeeID = 0;
    
    -- Input validation
    IF LTRIM(RTRIM(@e.FirstName)) = '' OR @e.FirstName IS NULL
    BEGIN
        RAISERROR('First name is required and cannot be empty.', 16, 1);
        RETURN -1;
    END
    
    IF LTRIM(RTRIM(@e.LastName)) = '' OR @e.LastName IS NULL
    BEGIN
        RAISERROR('Last name is required and cannot be empty.', 16, 1);
        RETURN -2;
    END
    
    IF LTRIM(RTRIM(@e.JobTitle)) = '' OR @e.JobTitle IS NULL
    BEGIN
        RAISERROR('Job title is required and cannot be empty.', 16, 1);
        RETURN -3;
    END
    
    IF @e.BaseSalary IS NULL OR @e.BaseSalary <= 0
    BEGIN
        RAISERROR('Base e.BaseSalary must be a positive amount.', 16, 1);
        RETURN -4;
    END
    
    IF @e.BaseSalary > 500000  -- Business rule: maximum e.BaseSalary cap
    BEGIN
        RAISERROR('Base e.BaseSalary cannot exceed $500,000.', 16, 1);
        RETURN -5;
    END
    
    -- Validate d.DepartmentName exists and is active
    IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
    BEGIN
        RAISERROR('Department ID %d does not exist or is inactive.', 16, 1, @d.DepartmentID);
        RETURN -6;
    END
    
    -- Validate manager if provided
    IF @ManagerID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @ManagerID AND IsActive = 1)
        BEGIN
            RAISERROR('Manager ID %d does not exist or is inactive.', 16, 1, @ManagerID);
            RETURN -7;
        END
        
        -- Ensure manager is in same d.DepartmentName or is a senior manager
        IF NOT EXISTS (
            SELECT 1 FROM Employees e
            INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
            WHERE e.EmployeeID = @ManagerID
              AND (e.d.DepartmentID = @d.DepartmentID OR e.BaseSalary >= 80000)
        )
        BEGIN
            RAISERROR('Manager must be in the same d.DepartmentName or be a senior manager.', 16, 1);
            RETURN -8;
        END
    END
    
    -- Validate email format and uniqueness
    IF @WorkEmail NOT LIKE '%_@_%._%'
    BEGIN
        RAISERROR('Work email format is invalid.', 16, 1);
        RETURN -9;
    END
    
    IF EXISTS (SELECT 1 FROM Employees e WHERE WorkEmail = @WorkEmail AND IsActive = 1)
    BEGIN
        RAISERROR('Work email %s already exists for another active employee.', 16, 1, @WorkEmail);
        RETURN -10;
    END
    
    -- Set default hire date if not provided
    SET @e.HireDate = ISNULL(@e.HireDate, GETDATE());
    
    -- Validate hire date is not in the future
    IF @e.HireDate > GETDATE()
    BEGIN
        RAISERROR('Hire date cannot be in the future.', 16, 1);
        RETURN -11;
    END
    
    -- Begin transaction for data consistency
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insert new employee
        INSERT INTO Employees (
            e.FirstName,
            e.LastName,
            e.JobTitle,
            e.BaseSalary,
            d.DepartmentID,
            ManagerID,
            WorkEmail,
            e.HireDate,
            IsActive
        )
        VALUES (
            LTRIM(RTRIM(@e.FirstName)),
            LTRIM(RTRIM(@e.LastName)),
            LTRIM(RTRIM(@e.JobTitle)),
            @e.BaseSalary,
            @d.DepartmentID,
            @ManagerID,
            LOWER(LTRIM(RTRIM(@WorkEmail))),
            @e.HireDate,
            1  -- Active by default
        );
        
        -- Get the new employee ID
        SET @NewEmployeeID = SCOPE_IDENTITY();
        
        -- Commit transaction
        COMMIT TRANSACTION;
        
        -- Return success message
        PRINT 'Employee ' + @e.FirstName + ' ' + @e.LastName + ' (ID: ' + CAST(@NewEmployeeID AS VARCHAR) + ') added successfully.';
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Re-raise the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Failed to add employee: %s', 16, 1, @ErrorMessage);
        RETURN -99;
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Test the procedure
DECLARE @NewEmpID INT;

-- Valid employee addition
EXEC sp_AddNewEmployee 
    @e.FirstName = 'John',
    @e.LastName = 'Smith',
    @e.JobTitle = 'Software Developer',
    @e.BaseSalary = 75000,
    @d.DepartmentID = 2001,
    @ManagerID = 3001,
    @WorkEmail = 'john.smith@techcorp.com',
    @NewEmployeeID = @NewEmpID OUTPUT;

SELECT @NewEmpID AS NewEmployeeID;

-- Test validation errors
EXEC sp_AddNewEmployee 
    @e.FirstName = '',  -- Invalid: empty name
    @e.LastName = 'Test',
    @e.JobTitle = 'Tester',
    @e.BaseSalary = 50000,
    @d.DepartmentID = 2001,
    @WorkEmail = 'test@techcorp.com',
    @NewEmployeeID = @NewEmpID OUTPUT;
```

#### TechCorp Example: Update Employee Information Procedure
```sql
-- Create procedure to update employee information with audit trail
CREATE PROCEDURE sp_UpdateEmployeeInfo
    @e.EmployeeID INT,
    @e.FirstName VARCHAR(50) = NULL,
    @e.LastName VARCHAR(50) = NULL,
    @e.JobTitle VARCHAR(100) = NULL,
    @e.BaseSalary DECIMAL(10,2) = NULL,
    @d.DepartmentID INT = NULL,
    @ManagerID INT = NULL,
    @WorkEmail VARCHAR(100) = NULL,
    @UpdatedBy VARCHAR(100) = 'System',
    @UpdateReason VARCHAR(500) = 'Standard Update'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    -- Validate employee exists and is active
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1)
    BEGIN
        RAISERROR('Employee ID %d does not exist or is inactive.', 16, 1, @e.EmployeeID);
        RETURN -1;
    END
    
    -- Get current employee information for comparison
    DECLARE @CurrentFirstName VARCHAR(50), @CurrentLastName VARCHAR(50), @CurrentJobTitle VARCHAR(100);
    DECLARE @CurrentSalary DECIMAL(10,2), @CurrentDepartmentID INT, @CurrentManagerID INT, @CurrentEmail VARCHAR(100);
    
    SELECT 
        @CurrentFirstName = e.FirstName,
        @CurrentLastName = e.LastName,
        @CurrentJobTitle = e.JobTitle,
        @CurrentSalary = e.BaseSalary,
        @CurrentDepartmentID = d.DepartmentID,
        @CurrentManagerID = ManagerID,
        @CurrentEmail = WorkEmail
    FROM Employees e 
    WHERE e.EmployeeID = @e.EmployeeID;
    
    -- Validate updated values if provided
    IF @e.FirstName IS NOT NULL AND LTRIM(RTRIM(@e.FirstName)) = ''
    BEGIN
        RAISERROR('First name cannot be empty.', 16, 1);
        RETURN -2;
    END
    
    IF @e.LastName IS NOT NULL AND LTRIM(RTRIM(@e.LastName)) = ''
    BEGIN
        RAISERROR('Last name cannot be empty.', 16, 1);
        RETURN -3;
    END
    
    IF @e.BaseSalary IS NOT NULL AND (@e.BaseSalary <= 0 OR @e.BaseSalary > 500000)
    BEGIN
        RAISERROR('Base e.BaseSalary must be between $0 and $500,000.', 16, 1);
        RETURN -4;
    END
    
    IF @d.DepartmentID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID AND IsActive = 1)
    BEGIN
        RAISERROR('Department ID %d does not exist or is inactive.', 16, 1, @d.DepartmentID);
        RETURN -5;
    END
    
    IF @ManagerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @ManagerID AND IsActive = 1)
    BEGIN
        RAISERROR('Manager ID %d does not exist or is inactive.', 16, 1, @ManagerID);
        RETURN -6;
    END
    
    IF @WorkEmail IS NOT NULL
    BEGIN
        IF @WorkEmail NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('Work email format is invalid.', 16, 1);
            RETURN -7;
        END
        
        IF EXISTS (SELECT 1 FROM Employees e WHERE WorkEmail = @WorkEmail AND e.EmployeeID != @e.EmployeeID AND IsActive = 1)
        BEGIN
            RAISERROR('Work email %s already exists for another employee.', 16, 1, @WorkEmail);
            RETURN -8;
        END
    END
    
    -- Check if any updates are actually needed
    IF (@e.FirstName IS NULL OR @e.FirstName = @CurrentFirstName)
       AND (@e.LastName IS NULL OR @e.LastName = @CurrentLastName)
       AND (@e.JobTitle IS NULL OR @e.JobTitle = @CurrentJobTitle)
       AND (@e.BaseSalary IS NULL OR @e.BaseSalary = @CurrentSalary)
       AND (@d.DepartmentID IS NULL OR @d.DepartmentID = @CurrentDepartmentID)
       AND (@ManagerID IS NULL OR (@ManagerID = @CurrentManagerID OR (@ManagerID IS NULL AND @CurrentManagerID IS NULL)))
       AND (@WorkEmail IS NULL OR @WorkEmail = @CurrentEmail)
    BEGIN
        PRINT 'No changes detected. Employee information remains unchanged.';
        RETURN 1;  -- No changes made
    END
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Update employee information
        UPDATE Employees
        SET 
            e.FirstName = ISNULL(@e.FirstName, e.FirstName),
            e.LastName = ISNULL(@e.LastName, e.LastName),
            e.JobTitle = ISNULL(@e.JobTitle, e.JobTitle),
            e.BaseSalary = ISNULL(@e.BaseSalary, e.BaseSalary),
            d.DepartmentID = ISNULL(@d.DepartmentID, d.DepartmentID),
            ManagerID = CASE WHEN @ManagerID IS NOT NULL THEN @ManagerID ELSE ManagerID END,
            WorkEmail = ISNULL(@WorkEmail, WorkEmail)
        WHERE e.EmployeeID = @e.EmployeeID;
        
        -- Log the update (in a real system, this would go to an audit table)
        DECLARE @ChangeLog VARCHAR(1000) = 'Employee ID ' + CAST(@e.EmployeeID AS VARCHAR) + ' updated by ' + @UpdatedBy + '. ';
        
        IF @e.FirstName IS NOT NULL AND @e.FirstName != @CurrentFirstName
            SET @ChangeLog = @ChangeLog + 'e.FirstName: ' + @CurrentFirstName + ' -> ' + @e.FirstName + '. ';
        
        IF @e.LastName IS NOT NULL AND @e.LastName != @CurrentLastName
            SET @ChangeLog = @ChangeLog + 'e.LastName: ' + @CurrentLastName + ' -> ' + @e.LastName + '. ';
            
        IF @e.JobTitle IS NOT NULL AND @e.JobTitle != @CurrentJobTitle
            SET @ChangeLog = @ChangeLog + 'e.JobTitle: ' + @CurrentJobTitle + ' -> ' + @e.JobTitle + '. ';
            
        IF @e.BaseSalary IS NOT NULL AND @e.BaseSalary != @CurrentSalary
            SET @ChangeLog = @ChangeLog + 'e.BaseSalary: ' + FORMAT(@CurrentSalary, 'C') + ' -> ' + FORMAT(@e.BaseSalary, 'C') + '. ';
        
        SET @ChangeLog = @ChangeLog + 'Reason: ' + @UpdateReason;
        
        PRINT @ChangeLog;
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Failed to update employee: %s', 16, 1, @ErrorMessage);
        RETURN -99;
    END CATCH
    
    RETURN 0;  -- Success
END;

-- Test the update procedure
-- Update employee e.BaseSalary and job title
EXEC sp_UpdateEmployeeInfo
    @e.EmployeeID = 3001,
    @e.JobTitle = 'Senior Software Developer',
    @e.BaseSalary = 85000,
    @UpdatedBy = 'HR Manager',
    @UpdateReason = 'Annual promotion and e.BaseSalary increase';

-- Test with no changes
EXEC sp_UpdateEmployeeInfo
    @e.EmployeeID = 3001,
    @e.JobTitle = 'Senior Software Developer';  -- Same as current
```

### 2. Simple Calculation and Business Logic Procedures

#### TechCorp Example: Employee Performance Score Calculator
```sql
-- Create procedure to calculate employee performance scores
CREATE PROCEDURE sp_CalculateEmployeePerformanceScore
    @e.EmployeeID INT,
    @PerformancePeriodMonths INT = 12,
    @PerformanceScore DECIMAL(5,2) OUTPUT,
    @PerformanceGrade VARCHAR(20) OUTPUT,
    @ScoreBreakdown VARCHAR(1000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize output parameters
    SET @PerformanceScore = 0;
    SET @PerformanceGrade = 'Not Evaluated';
    SET @ScoreBreakdown = '';
    
    -- Validate inputs
    IF @e.EmployeeID IS NULL OR NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsActive = 1)
    BEGIN
        SET @ScoreBreakdown = 'Error: Invalid or inactive employee ID.';
        RETURN -1;
    END
    
    IF @PerformancePeriodMonths <= 0 OR @PerformancePeriodMonths > 60
    BEGIN
        SET @ScoreBreakdown = 'Error: Performance period must be between 1 and 60 months.';
        RETURN -2;
    END
    
    -- Declare variables for score components
    DECLARE @ProjectScore DECIMAL(5,2) = 0;
    DECLARE @CustomerScore DECIMAL(5,2) = 0;
    DECLARE @TeamScore DECIMAL(5,2) = 0;
    DECLARE @AttendanceScore DECIMAL(5,2) = 0;
    
    -- Calculate project involvement score (0-30 points)
    SELECT @ProjectScore = 
        CASE 
            WHEN COUNT(DISTINCT ep.ProjectID) >= 5 THEN 30.0
            WHEN COUNT(DISTINCT ep.ProjectID) >= 3 THEN 25.0
            WHEN COUNT(DISTINCT ep.ProjectID) >= 2 THEN 20.0
            WHEN COUNT(DISTINCT ep.ProjectID) >= 1 THEN 15.0
            ELSE 0.0
        END +
        CASE 
            WHEN SUM(ep.HoursWorked) >= 500 THEN 10.0
            WHEN SUM(ep.HoursWorked) >= 300 THEN 7.0
            WHEN SUM(ep.HoursWorked) >= 100 THEN 5.0
            ELSE 0.0
        END
    FROM EmployeeProjects ep
    WHERE ep.e.EmployeeID = @e.EmployeeID
      AND ep.IsActive = 1
      AND ep.StartDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE());
    
    SET @ProjectScore = ISNULL(@ProjectScore, 0);
    IF @ProjectScore > 30 SET @ProjectScore = 30;  -- Cap at maximum
    
    -- Calculate customer service score (0-25 points)
    SELECT @CustomerScore = 
        CASE 
            WHEN COUNT(o.OrderID) >= 50 THEN 25.0
            WHEN COUNT(o.OrderID) >= 25 THEN 20.0
            WHEN COUNT(o.OrderID) >= 10 THEN 15.0
            WHEN COUNT(o.OrderID) >= 5 THEN 10.0
            WHEN COUNT(o.OrderID) >= 1 THEN 5.0
            ELSE 0.0
        END
    FROM Orders o
    WHERE o.e.EmployeeID = @e.EmployeeID
      AND o.IsActive = 1
      AND o.OrderDate >= DATEADD(MONTH, -@PerformancePeriodMonths, GETDATE());
    
    SET @CustomerScore = ISNULL(@CustomerScore, 0);
    
    -- Calculate team leadership score (0-25 points)
    DECLARE @DirectReports INT, @ManagedProjects INT;
    
    SELECT @DirectReports = COUNT(*)
    FROM Employees e
    WHERE ManagerID = @e.EmployeeID AND IsActive = 1;
    
    SELECT @ManagedProjects = COUNT(*)
    FROM Projects p
    WHERE ProjectManagerID = @e.EmployeeID AND IsActive = 1;
    
    SET @TeamScore = 
        CASE 
            WHEN @DirectReports >= 10 THEN 15.0
            WHEN @DirectReports >= 5 THEN 12.0
            WHEN @DirectReports >= 2 THEN 8.0
            WHEN @DirectReports >= 1 THEN 5.0
            ELSE 0.0
        END +
        CASE 
            WHEN @ManagedProjects >= 5 THEN 10.0
            WHEN @ManagedProjects >= 2 THEN 7.0
            WHEN @ManagedProjects >= 1 THEN 5.0
            ELSE 0.0
        END;
    
    IF @TeamScore > 25 SET @TeamScore = 25;  -- Cap at maximum
    
    -- Calculate attendance/reliability score (0-20 points)
    -- Simplified: based on years of service and employment status
    DECLARE @YearsOfService INT;
    SELECT @YearsOfService = DATEDIFF(YEAR, e.HireDate, GETDATE())
    FROM Employees e
    WHERE e.EmployeeID = @e.EmployeeID;
    
    SET @AttendanceScore = 
        CASE 
            WHEN @YearsOfService >= 10 THEN 20.0
            WHEN @YearsOfService >= 5 THEN 17.0
            WHEN @YearsOfService >= 2 THEN 15.0
            WHEN @YearsOfService >= 1 THEN 12.0
            ELSE 10.0
        END;
    
    -- Calculate total performance score
    SET @PerformanceScore = @ProjectScore + @CustomerScore + @TeamScore + @AttendanceScore;
    
    -- Determine performance grade
    SET @PerformanceGrade = 
        CASE 
            WHEN @PerformanceScore >= 90 THEN 'Exceptional (A+)'
            WHEN @PerformanceScore >= 80 THEN 'Outstanding (A)'
            WHEN @PerformanceScore >= 70 THEN 'Exceeds Expectations (B+)'
            WHEN @PerformanceScore >= 60 THEN 'Meets Expectations (B)'
            WHEN @PerformanceScore >= 50 THEN 'Below Expectations (C)'
            ELSE 'Needs Improvement (D)'
        END;
    
    -- Build score breakdown
    SET @ScoreBreakdown = 
        'Performance Score Breakdown: ' +
        'Project Involvement: ' + CAST(@ProjectScore AS VARCHAR) + '/30, ' +
        'Customer Service: ' + CAST(@CustomerScore AS VARCHAR) + '/25, ' +
        'Team Leadership: ' + CAST(@TeamScore AS VARCHAR) + '/25, ' +
        'Attendance/Reliability: ' + CAST(@AttendanceScore AS VARCHAR) + '/20. ' +
        'Total: ' + CAST(@PerformanceScore AS VARCHAR) + '/100. ' +
        'Evaluation Period: ' + CAST(@PerformancePeriodMonths AS VARCHAR) + ' months.';
    
    RETURN 0;  -- Success
END;

-- Test the performance calculation procedure
DECLARE @Score DECIMAL(5,2), @Grade VARCHAR(20), @Breakdown VARCHAR(1000), @Result INT;

EXEC @Result = sp_CalculateEmployeePerformanceScore
    @e.EmployeeID = 3001,
    @PerformancePeriodMonths = 12,
    @PerformanceScore = @Score OUTPUT,
    @PerformanceGrade = @Grade OUTPUT,
    @ScoreBreakdown = @Breakdown OUTPUT;

SELECT 
    @Result AS ReturnCode,
    @Score AS PerformanceScore,
    @Grade AS PerformanceGrade,
    @Breakdown AS ScoreBreakdown;
```

## Best Practices for Simple Stored Procedures

### 1. Error Handling and Validation

```sql
-- ✅ GOOD: Comprehensive error handling template
CREATE PROCEDURE sp_BestPracticeTemplate
    @RequiredParam INT,
    @OptionalParam VARCHAR(50) = 'Default'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    -- Declare variables for error handling
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    
    -- Input validation with specific error codes
    IF @RequiredParam IS NULL
    BEGIN
        RAISERROR('Required parameter cannot be NULL.', 16, 1);
        RETURN -1;
    END
    
    IF @RequiredParam <= 0
    BEGIN
        RAISERROR('Required parameter must be positive.', 16, 1);
        RETURN -2;
    END
    
    -- Business logic with comprehensive error handling
    BEGIN TRY
        -- Main procedure logic here
        SELECT 'Success' AS Status;
        
    END TRY
    BEGIN CATCH
        -- Capture error information
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        -- Log error (in production, log to error table)
        PRINT 'Error in sp_BestPracticeTemplate: ' + @ErrorMessage;
        
        -- Re-raise error with context
        RAISERROR('Procedure failed: %s', @ErrorSeverity, @ErrorState, @ErrorMessage);
        RETURN -99;
    END CATCH
    
    RETURN 0;  -- Success
END;
```

### 2. Documentation and Naming Conventions

```sql
-- ✅ GOOD: Well-documented procedure with clear naming
/*
Purpose: Retrieve employee information with optional manager details
Author: TechCorp Development Team
Created: 2025-01-01
Modified: 2025-01-01

Parameters:
    @EmployeeID - Required: ID of employee to retrieve
    @IncludeManager - Optional: Include manager information (default: 1)
    @OutputFormat - Optional: 'Standard', 'Detailed', 'Summary' (default: 'Standard')

Returns:
    0 = Success
    -1 = Invalid EmployeeID
    -2 = Employee not found
    -99 = System error

Usage Examples:
    EXEC sp_GetEmployeeInfo @EmployeeID = 3001;
    EXEC sp_GetEmployeeInfo @EmployeeID = 3001, @IncludeManager = 0;
*/
CREATE PROCEDURE sp_GetEmployeeInfo  -- Clear, descriptive name with sp_ prefix
    @EmployeeID INT,                 -- Clear parameter names
    @IncludeManager BIT = 1,         -- Appropriate defaults
    @OutputFormat VARCHAR(20) = 'Standard'  -- Enumerated options
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Procedure implementation with clear logic
    -- ... implementation details ...
    
    RETURN 0;
END;
```

## Summary

Creating simple stored procedures provides TechCorp with fundamental database programming capabilities:

**Key Benefits:**
- **Code Reusability**: Centralized logic that can be called from multiple applications
- **Performance**: Pre-compiled execution plans for optimized performance
- **Security**: Controlled data access through procedure interfaces
- **Maintainability**: Centralized business logic easier to modify and maintain
- **Consistency**: Standardized data operations across systems

**Essential Components:**
- **Input Validation**: Comprehensive parameter checking and business rule enforcement
- **Error Handling**: Robust TRY...CATCH blocks with meaningful error messages
- **Transaction Management**: ACID compliance for data modification operations
- **Documentation**: Clear purpose, parameters, and usage examples
- **Return Codes**: Consistent status indication for calling applications

**Business Applications:**
- Employee management and HR operations
- Customer relationship management
- Performance calculation and reporting
- Data validation and business rule enforcement
- Standardized reporting and analytics

**Best Practices:**
- Use clear, consistent naming conventions
- Implement comprehensive input validation
- Provide meaningful error messages and return codes
- Use transactions for data modification operations
- Document procedures thoroughly with examples

Simple stored procedures form the foundation for TechCorp's database application development, enabling the creation of robust, secure, and maintainable database solutions that support enterprise business processes and data management requirements.