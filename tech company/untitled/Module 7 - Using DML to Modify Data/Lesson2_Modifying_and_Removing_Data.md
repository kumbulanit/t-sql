# Lesson 2: Modifying and Removing Data

## Overview
The UPDATE and DELETE statements are essential for maintaining data accuracy and managing database content over time. This lesson covers all aspects of modifying and removing data, from basic single-table operations to complex multi-table scenarios, including performance optimization and safety considerations.

## UPDATE Statement Fundamentals

### Basic UPDATE Syntax and Execution Flow
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           UPDATE STATEMENT SYNTAX                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Basic Forms:                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. Simple UPDATE:                                                      │
│  │    UPDATE table_name                                                   │
│  │    SET column1 = value1, column2 = value2                              │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 2. UPDATE with JOIN:                                                   │
│  │    UPDATE t1                                                           │
│  │    SET t1.column = t2.column                                           │
│  │    FROM table1 t1                                                      │
│  │    INNER JOIN table2 t2 ON t1.id = t2.id                              │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 3. UPDATE with OUTPUT:                                                 │
│  │    UPDATE table_name                                                   │
│  │    SET column = value                                                  │
│  │    OUTPUT deleted.column, inserted.column                             │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 4. UPDATE with TOP:                                                    │
│  │    UPDATE TOP (n) table_name                                          │
│  │    SET column = value                                                  │
│  │    [WHERE conditions];                                                 │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Execution Process:                                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. Parse and validate SQL syntax                                       │
│  │ 2. Identify target table and columns                                   │
│  │ 3. Evaluate WHERE clause to find matching rows                         │
│  │ 4. Acquire necessary locks (shared for read, exclusive for write)      │
│  │ 5. Validate new values against constraints                             │
│  │ 6. Update data pages                                                   │
│  │ 7. Update indexes                                                      │
│  │ 8. Log changes for transaction recovery                                │
│  │ 9. Check foreign key constraints                                       │
│  │ 10. Fire triggers (if any)                                            │
│  │ 11. Commit or rollback transaction                                     │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Safety Considerations:                                                     │
│  • Always use WHERE clause (unless updating all rows intentionally)       │
│  • Test UPDATE statements with SELECT first                                │
│  • Use transactions for multiple related updates                           │
│  • Consider OUTPUT clause for audit trails                                 │
│  • Be aware of locking and blocking implications                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Sample Data Setup
```sql
-- Use the tables from Lesson 1 and add some test data for modification examples
-- First, let's ensure we have sufficient test data

-- Add more employees for UPDATE examples
INSERT INTO Employees (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, ManagerID)
VALUES 
    ('Robert', 'Johnson', 'robert.johnson@company.com', 72000.00, 1, NULL),
    ('Maria', 'Garcia', 'maria.garcia@company.com', 68000.00, 2, NULL),
    ('William', 'Brown', 'william.brown@company.com', 81000.00, 3, NULL),
    ('Jennifer', 'Davis', 'jennifer.davis@company.com', 74000.00, 1, 1),
    ('Charles', 'Miller', 'charles.miller@company.com', 69000.00, 2, 2),
    ('Patricia', 'Wilson', 'patricia.wilson@company.com', 77000.00, 3, 3);

-- Add employee status tracking table
CREATE TABLE EmployeeIsActiveHistory (
    IsActiveID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT NOT NULL,
    PreviousIsActive NVARCHAR(20),
    NewIsActive NVARCHAR(20),
    IsActiveChangeDate DATETIME2 DEFAULT SYSDATETIME(),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    Reason NVARCHAR(255),
    FOREIGN KEY (e.EmployeeID) REFERENCES Employees(e.EmployeeID)
);

-- Add e.BaseSalary history table
CREATE TABLE SalaryHistory (
    SalaryHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT NOT NULL,
    PreviousSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    EffectiveDate DATE,
    ChangeReason NVARCHAR(100),
    ApprovedBy INT,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (e.EmployeeID) REFERENCES Employees(e.EmployeeID),
    FOREIGN KEY (ApprovedBy) REFERENCES Employees(e.EmployeeID)
);

-- View current employee data
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    WorkEmail,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    d.DepartmentID,
    ManagerID,
    e.HireDate,
    IsActive
FROM Employees e
ORDER BY e.EmployeeID;
```

## Basic UPDATE Operations

### Simple Column Updates
```sql
-- Basic single column update
UPDATE Employees 
SET ModifiedDate = SYSDATETIME()
WHERE e.EmployeeID = 1;

-- Multiple column update
UPDATE Employees 
SET 
    e.BaseSalary = 78000.00,
    ModifiedDate = SYSDATETIME()
WHERE e.EmployeeID = 1;

-- Update with calculations
UPDATE Employees 
SET 
    e.BaseSalary = e.BaseSalary * 1.05,  -- 5% raise
    ModifiedDate = SYSDATETIME()
WHERE d.DepartmentID = 1 AND IsActive = 1;

-- Update with string functions
UPDATE Employees 
SET 
    WorkEmail = LOWER(REPLACE(e.FirstName + '.' + e.LastName + '@company.com', ' ', '')),
    ModifiedDate = SYSDATETIME()
WHERE WorkEmail IS NULL OR WorkEmail = '';

-- Update with conditional logic
UPDATE Employees 
SET 
    e.BaseSalary = CASE 
        WHEN e.BaseSalary < 70000 THEN e.BaseSalary * 1.08  -- 8% raise for lower salaries
        WHEN e.BaseSalary < 80000 THEN e.BaseSalary * 1.05  -- 5% raise for mid salaries
        ELSE e.BaseSalary * 1.03                      -- 3% raise for higher salaries
    END,
    ModifiedDate = SYSDATETIME()
WHERE IsActive = 1;

-- Verify the updates
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    FORMAT(e.BaseSalary, 'C') AS FormattedSalary,
    WorkEmail,
    ModifiedDate
FROM Employees e
WHERE IsActive = 1
ORDER BY e.BaseSalary DESC;
```

### UPDATE with WHERE Clause Variations
```sql
-- Update based on date ranges
UPDATE Employees 
SET e.BaseSalary = e.BaseSalary * 1.02  -- 2% cost of living adjustment
WHERE e.HireDate <= DATEADD(YEAR, -1, GETDATE())  -- Employees hired more than 1 year ago
  AND IsActive = 1;

-- Update based on NULL values
UPDATE Employees 
SET 
    ManagerID = 1,  -- Assign to default manager
    ModifiedDate = SYSDATETIME()
WHERE ManagerID IS NULL 
  AND d.DepartmentID = 1 
  AND IsActive = 1;

-- Update with subquery conditions
UPDATE Employees 
SET 
    e.BaseSalary = e.BaseSalary * 1.10,  -- 10% raise for high performers
    ModifiedDate = SYSDATETIME()
WHERE e.EmployeeID IN (
    SELECT e.EmployeeID 
    FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
    WHERE e.BaseSalary > (
        SELECT AVG(e.BaseSalary) 
        FROM Employees e 
        WHERE d.DepartmentID = e.d.DepartmentID AND IsActive = 1
    )
    AND e.IsActive = 1
);

-- Update with EXISTS
UPDATE Employees 
SET 
    IsActive = 0,  -- Deactivate employees with no recent activity
    ModifiedDate = SYSDATETIME()
WHERE NOT EXISTS (
    SELECT 1 
    FROM EmployeeIsActiveHistory esh
    WHERE esh.e.EmployeeID = Employees.e.EmployeeID
      AND esh.IsActiveChangeDate >= DATEADD(MONTH, -6, GETDATE())
);
```

## UPDATE with JOINs

### UPDATE with INNER JOIN
```sql
-- Update employee salaries based on d.DepartmentName budget
UPDATE e
SET 
    e.BaseSalary = CASE 
        WHEN d.Budget > 400000 THEN e.BaseSalary * 1.06  -- High budget dept: 6% raise
        WHEN d.Budget > 200000 THEN e.BaseSalary * 1.04  -- Medium budget: 4% raise
        ELSE e.BaseSalary * 1.02                         -- Low budget: 2% raise
    END,
    ModifiedDate = SYSDATETIME()
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1;

-- Update d.DepartmentName manager based on highest e.BaseSalary in d.DepartmentName
UPDATE d
SET 
    ManagerID = emp.EmployeeID,
    ModifiedDate = SYSDATETIME()
FROM Departments d
INNER JOIN (
    SELECT 
        d.DepartmentID,
        e.EmployeeID,
        ROW_NUMBER() OVER (PARTITION BY DepartmentIDID ORDER BY e.BaseSalary DESC) as rn
    FROM Employees e
    WHERE IsActive = 1
) emp ON d.DepartmentID = emp.d.DepartmentID AND emp.rn = 1;

-- Verify the d.DepartmentName manager updates
SELECT d.DepartmentName,
    e.FirstName + ' ' + e.LastName AS ManagerName,
    FORMAT(e.BaseSalary, 'C') AS ManagerSalary
FROM Departments d
LEFT JOIN Employees e ON d.ManagerID = e.EmployeeID;
```

### UPDATE with Multiple JOINs
```sql
-- Complex update involving multiple tables
UPDATE e
SET 
    e.BaseSalary = CASE 
        WHEN mgr.e.BaseSalary IS NOT NULL AND e.BaseSalary > mgr.e.BaseSalary * 0.9 
            THEN mgr.e.BaseSalary * 0.85  -- Cap at 85% of manager e.BaseSalary
        ELSE e.BaseSalary
    END,
    ModifiedDate = SYSDATETIME()
FROM Employees e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
LEFT JOIN Employees mgr ON e.ManagerID = mgr.e.EmployeeID
WHERE e.IsActive = 1 
  AND mgr.IsActive = 1;

-- Update project budgets based on assigned employee costs
CREATE TABLE EmployeeProjects (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    AllocationPercentage DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (e.EmployeeID) REFERENCES Employees(e.EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Add some project assignments
INSERT INTO EmployeeProjects (e.EmployeeID, ProjectID, AllocationPercentage, StartDate)
VALUES 
    (1, 1, 75.00, '2024-01-01'),
    (2, 1, 50.00, '2024-01-01'),
    (3, 2, 100.00, '2024-02-01'),
    (4, 2, 25.00, '2024-02-01'),
    (5, 3, 50.00, '2024-03-01');

-- Update project budgets based on employee allocations
UPDATE p
SET 
    d.Budget = calculated_costs.TotalEmployeeCost * 1.3,  -- Add 30% overhead
    ModifiedDate = SYSDATETIME()
FROM Projects p
INNER JOIN (
    SELECT 
        ep.ProjectID,
        SUM(e.BaseSalary * (ep.AllocationPercentage / 100.0) * 
            DATEDIFF(MONTH, ep.StartDate, ISNULL(ep.EndDate, DATEADD(MONTH, 6, ep.StartDate))) / 12.0
        ) AS TotalEmployeeCost
    FROM EmployeeProjects ep
    INNER JOIN Employees e ON ep.e.EmployeeID = e.EmployeeID
    WHERE e.IsActive = 1
    GROUP BY ep.ProjectID
) calculated_costs ON p.ProjectID = calculated_costs.ProjectID;

-- View updated project budgets
SELECT 
    ProjectName,
    FORMAT(d.Budget, 'C') AS UpdatedBudget,
    IsActive
FROM Projects p
ORDER BY d.Budget DESC;
```

## UPDATE with OUTPUT Clause

### Capturing UPDATE Changes
```sql
-- Create audit table for tracking changes
CREATE TABLE EmployeeAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT,
    ChangeType NVARCHAR(20),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ColumnName NVARCHAR(100),
    ChangeDate DATETIME2 DEFAULT SYSDATETIME(),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER
);

-- UPDATE with OUTPUT to capture changes
DECLARE @SalaryChanges TABLE (
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    PercentageIncrease DECIMAL(5,2)
);

-- Update salaries and capture the changes
UPDATE Employees
SET 
    e.BaseSalary = e.BaseSalary * 1.07,  -- 7% across-the-board raise
    ModifiedDate = SYSDATETIME()
OUTPUT 
    inserted.e.EmployeeID,
    inserted.e.FirstName + ' ' + inserted.e.LastName,
    deleted.e.BaseSalary,
    inserted.e.BaseSalary,
    CAST(((inserted.e.BaseSalary - deleted.e.BaseSalary) / deleted.e.BaseSalary) * 100 AS DECIMAL(5,2))
INTO @SalaryChanges
WHERE IsActive = 1 AND e.BaseSalary IS NOT NULL;

-- Process the captured changes
INSERT INTO SalaryHistory (e.EmployeeID, PreviousSalary, NewSalary, EffectiveDate, ChangeReason)
SELECT 
    e.EmployeeID,
    OldSalary,
    NewSalary,
    GETDATE(),
    'Annual Review - ' + CAST(PercentageIncrease AS VARCHAR(10)) + '% increase'
FROM @SalaryChanges;

-- Display the changes
SELECT 
    EmployeeName,
    FORMAT(OldSalary, 'C') AS PreviousSalary,
    FORMAT(NewSalary, 'C') AS NewSalary,
    CAST(PercentageIncrease AS VARCHAR(10)) + '%' AS PercentIncrease
FROM @SalaryChanges
ORDER BY PercentageIncrease DESC;
```

### Complex OUTPUT Scenarios
```sql
-- UPDATE with OUTPUT to multiple destinations
DECLARE @IsActiveChanges TABLE (
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    OldIsActive BIT,
    NewIsActive BIT,
    ChangeReason NVARCHAR(255)
);

-- Bulk status update with detailed tracking
UPDATE Employees
SET 
    IsActive = CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 30 THEN 0  -- Retirement eligibility
        WHEN e.BaseSalary IS NULL THEN 0  -- Invalid employee data
        ELSE IsActive
    END,
    ModifiedDate = SYSDATETIME()
OUTPUT 
    inserted.e.EmployeeID,
    inserted.e.FirstName + ' ' + inserted.e.LastName,
    deleted.IsActive,
    inserted.IsActive,
    CASE 
        WHEN deleted.IsActive = 1 AND inserted.IsActive = 0 AND DATEDIFF(YEAR, inserted.e.HireDate, GETDATE()) >= 30 
            THEN 'Retirement Eligibility'
        WHEN deleted.IsActive = 1 AND inserted.IsActive = 0 AND inserted.e.BaseSalary IS NULL 
            THEN 'Invalid e.BaseSalary Data'
        ELSE 'No Change'
    END
INTO @IsActiveChanges
WHERE IsActive = 1;

-- Log status changes
INSERT INTO EmployeeIsActiveHistory (e.EmployeeID, PreviousIsActive, NewIsActive, Reason)
SELECT 
    e.EmployeeID,
    CASE OldIsActive WHEN 1 THEN 'Active' ELSE 'Inactive' END,
    CASE NewIsActive WHEN 1 THEN 'Active' ELSE 'Inactive' END,
    ChangeReason
FROM @IsActiveChanges
WHERE OldIsActive != NewIsActive;

-- Report on changes made
SELECT 
    EmployeeName,
    CASE OldIsActive WHEN 1 THEN 'Active' ELSE 'Inactive' END AS PreviousIsActive,
    CASE NewIsActive WHEN 1 THEN 'Active' ELSE 'Inactive' END AS CurrentIsActive,
    ChangeReason
FROM @IsActiveChanges
WHERE OldIsActive != NewIsActive;
```

## DELETE Statement Fundamentals

### Basic DELETE Syntax and Safety
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DELETE STATEMENT SYNTAX                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Basic Forms:                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. Simple DELETE:                                                      │
│  │    DELETE [FROM] table_name                                            │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 2. DELETE with JOIN:                                                   │
│  │    DELETE t1                                                           │
│  │    FROM table1 t1                                                      │
│  │    INNER JOIN table2 t2 ON t1.id = t2.id                              │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 3. DELETE with OUTPUT:                                                 │
│  │    DELETE FROM table_name                                              │
│  │    OUTPUT deleted.column1, deleted.column2                            │
│  │    [WHERE conditions];                                                 │
│  │                                                                         │
│  │ 4. DELETE with TOP:                                                    │
│  │    DELETE TOP (n) FROM table_name                                      │
│  │    [WHERE conditions];                                                 │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  CRITICAL SAFETY RULES:                                                    │
│  ┌─────────────────────────────────────────────────────────────────────────┤
│  │ 1. ALWAYS test with SELECT first:                                      │
│  │    SELECT * FROM table WHERE conditions; -- Test before DELETE        │
│  │                                                                         │
│  │ 2. Use transactions for safety:                                        │
│  │    BEGIN TRANSACTION;                                                  │
│  │    DELETE FROM table WHERE conditions;                                 │
│  │    -- Verify results, then COMMIT or ROLLBACK                         │
│  │                                                                         │
│  │ 3. Consider soft deletes for important data:                           │
│  │    UPDATE table SET IsDeleted = 1 WHERE conditions;                   │
│  │                                                                         │
│  │ 4. Check foreign key dependencies first                                │
│  │ 5. Use OUTPUT to capture deleted data for audit                        │
│  │ 6. Be aware of triggers and cascading deletes                          │
│  └─────────────────────────────────────────────────────────────────────────┤
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Safe DELETE Practices
```sql
-- Create a test table for DELETE demonstrations
CREATE TABLE EmployeeTemp AS 
SELECT * FROM Employees e;

-- Add test data that's safe to delete
INSERT INTO EmployeeTemp (e.FirstName, e.LastName, WorkEmail, e.BaseSalary, d.DepartmentID, IsActive)
VALUES 
    ('Test', 'User1', 'test.user1@company.com', 50000.00, 1, 0),
    ('Test', 'User2', 'test.user2@company.com', 50000.00, 1, 0),
    ('Test', 'User3', 'test.user3@company.com', 50000.00, 2, 0),
    ('Temporary', 'Employee', 'temp.employee@company.com', 45000.00, 1, 0);

-- STEP 1: Always test your WHERE clause with SELECT first
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    WorkEmail,
    IsActive
FROM EmployeeTemp
WHERE e.FirstName IN ('Test', 'Temporary') AND IsActive = 0;

-- STEP 2: Use transaction for safety
BEGIN TRANSACTION;

-- STEP 3: DELETE with OUTPUT to capture what's being deleted
DECLARE @DeletedEmployees TABLE (
    e.EmployeeID INT,
    EmployeeName NVARCHAR(101),
    WorkEmail NVARCHAR(100),
    DeletionDate DATETIME2
);

DELETE FROM EmployeeTemp
OUTPUT 
    deleted.e.EmployeeID,
    deleted.e.FirstName + ' ' + deleted.e.LastName,
    deleted.WorkEmail,
    SYSDATETIME()
INTO @DeletedEmployees
WHERE e.FirstName IN ('Test', 'Temporary') AND IsActive = 0;

-- STEP 4: Verify the deletion results
SELECT 
    COUNT(*) AS DeletedCount,
    'Test employees deleted' AS Message
FROM @DeletedEmployees;

-- STEP 5: Check remaining data
SELECT COUNT(*) AS RemainingEmployees 
FROM EmployeeTemp;

-- STEP 6: Commit if satisfied, rollback if not
COMMIT TRANSACTION;  -- or ROLLBACK TRANSACTION;

-- Show what was deleted
SELECT * FROM @DeletedEmployees;
```

## Basic DELETE Operations

### Simple DELETE Examples
```sql
-- Delete inactive test employees
DELETE FROM EmployeeTemp 
WHERE IsActive = 0 AND WorkEmail LIKE '%test%';

-- Delete employees with NULL salaries (data quality cleanup)
DELETE FROM EmployeeTemp 
WHERE e.BaseSalary IS NULL;

-- Delete old temporary records
DELETE FROM EmployeeTemp 
WHERE CreatedDate < DATEADD(DAY, -30, GETDATE()) 
  AND e.FirstName LIKE 'Temp%';

-- Delete based on e.BaseSalary range
DELETE FROM EmployeeTemp 
WHERE e.BaseSalary < 30000 AND IsActive = 0;

-- Verify remaining records
SELECT 
    COUNT(*) AS TotalEmployees,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) AS ActiveEmployees,
    COUNT(CASE WHEN IsActive = 0 THEN 1 END) AS InactiveEmployees
FROM EmployeeTemp;
```

### DELETE with Subqueries
```sql
-- Delete employees who are not assigned to any projects
DELETE FROM EmployeeTemp 
WHERE e.EmployeeID NOT IN (
    SELECT DISTINCT e.EmployeeID 
    FROM EmployeeProjects 
    WHERE e.EmployeeID IS NOT NULL
)
AND IsActive = 0;

-- Delete employees in departments with low budgets
DELETE FROM EmployeeTemp 
WHERE d.DepartmentID IN (
    SELECT d.DepartmentID 
    FROM Departments d 
    WHERE d.Budget < 200000
)
AND IsActive = 0;

-- Delete duplicate employees (keep the one with lowest e.EmployeeID)
DELETE e1
FROM EmployeeTemp e1
WHERE EXISTS (
    SELECT 1 
    FROM EmployeeTemp e2 
    WHERE e2.WorkEmail = e1.WorkEmail 
      AND e2.e.EmployeeID < e1.e.EmployeeID
);

-- Verify no duplicates remain
SELECT 
    WorkEmail, 
    COUNT(*) AS DuplicateCount
FROM EmployeeTemp
GROUP BY WorkEmail
HAVING COUNT(*) > 1;
```

## DELETE with JOINs

### DELETE with INNER JOIN
```sql
-- Create sample data for JOIN DELETE examples
CREATE TABLE InactiveEmployeeCleanup (
    e.EmployeeID INT,
    LastActivityDate DATE,
    CleanupReason NVARCHAR(255)
);

INSERT INTO InactiveEmployeeCleanup 
SELECT 
    e.EmployeeID,
    DATEADD(DAY, -RAND() * 365, GETDATE()),
    'No recent activity'
FROM EmployeeTemp 
WHERE IsActive = 0;

-- DELETE with INNER JOIN
DELETE e
FROM EmployeeTemp e
INNER JOIN InactiveEmployeeCleanup ic ON e.EmployeeID = ic.e.EmployeeID
WHERE ic.LastActivityDate < DATEADD(MONTH, -6, GETDATE());

-- DELETE employees from specific departments with low performance
CREATE TABLE PerformanceReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    e.EmployeeID INT,
    ReviewScore DECIMAL(3,1),
    ReviewDate DATE,
    Reviewer INT
);

INSERT INTO PerformanceReviews (e.EmployeeID, ReviewScore, ReviewDate, Reviewer)
SELECT 
    e.EmployeeID,
    CAST(RAND() * 5 + 1 AS DECIMAL(3,1)),  -- Random score 1-5
    DATEADD(DAY, -30, GETDATE()),
    1
FROM EmployeeTemp 
WHERE IsActive = 0;

-- Delete low-performing inactive employees
DELETE e
FROM EmployeeTemp e
INNER JOIN PerformanceReviews pr ON e.EmployeeID = pr.e.EmployeeID
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
WHERE pr.ReviewScore < 2.0 
  AND e.IsActive = 0
  AND d.DepartmentName != 'Human Resources';  -- Don't auto-delete HR employees
```

### DELETE with Multiple JOINs and Complex Logic
```sql
-- Complex deletion scenario: Remove employees who meet multiple criteria
DELETE e
FROM EmployeeTemp e
INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.e.EmployeeID
LEFT JOIN PerformanceReviews pr ON e.EmployeeID = pr.e.EmployeeID
WHERE e.IsActive = 0  -- Must be inactive
  AND d.Budget < 100000  -- From low-budget departments
  AND ep.e.EmployeeID IS NULL  -- Not assigned to any projects
  AND (pr.ReviewScore < 2.5 OR pr.ReviewScore IS NULL)  -- Poor or no performance review
  AND DATEDIFF(MONTH, e.HireDate, GETDATE()) < 6;  -- Recent hires (probationary)

-- Verify the complex deletion
SELECT 
    COUNT(*) AS RemainingEmployees,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) AS ActiveCount,
    COUNT(CASE WHEN IsActive = 0 THEN 1 END) AS InactiveCount
FROM EmployeeTemp;
```

## DELETE with OUTPUT and Auditing

### Comprehensive DELETE Auditing
```sql
-- Create comprehensive audit table
CREATE TABLE DeletionAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    DeletedRecordID INT,
    DeletedData NVARCHAR(MAX),
    DeletionReason NVARCHAR(255),
    DeletedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    DeletionDate DATETIME2 DEFAULT SYSDATETIME()
);

-- DELETE with comprehensive OUTPUT
DECLARE @DeletedData TABLE (
    e.EmployeeID INT,
    EmployeeData NVARCHAR(MAX),
    DeletionReason NVARCHAR(255)
);

-- Delete and capture all deleted employee data
DELETE FROM EmployeeTemp
OUTPUT 
    deleted.e.EmployeeID,
    'ID:' + CAST(deleted.e.EmployeeID AS VARCHAR(10)) + 
    ',Name:' + deleted.e.FirstName + ' ' + deleted.e.LastName +
    ',WorkEmail:' + ISNULL(deleted.WorkEmail, 'NULL') +
    ',e.BaseSalary:' + ISNULL(CAST(deleted.e.BaseSalary AS VARCHAR(20)), 'NULL') +
    ',Dept:' + CAST(deleted.DepartmentID AS VARCHAR(10)) +
    ',Active:' + CAST(deleted.IsActive AS VARCHAR(1)),
    CASE 
        WHEN deleted.IsActive = 0 THEN 'Inactive employee cleanup'
        WHEN deleted.e.BaseSalary IS NULL THEN 'Data quality - NULL e.BaseSalary'
        WHEN deleted.WorkEmail IS NULL OR deleted.WorkEmail = '' THEN 'Data quality - missing email'
        ELSE 'General cleanup'
    END
INTO @DeletedData
WHERE IsActive = 0 OR e.BaseSalary IS NULL OR WorkEmail IS NULL OR WorkEmail = '';

-- Log all deletions to audit table
INSERT INTO DeletionAudit (TableName, DeletedRecordID, DeletedData, DeletionReason)
SELECT 
    'EmployeeTemp',
    e.EmployeeID,
    EmployeeData,
    DeletionReason
FROM @DeletedData;

-- Report on deletions
SELECT 
    DeletionReason,
    COUNT(*) AS DeletedCount
FROM @DeletedData
GROUP BY DeletionReason
ORDER BY DeletedCount DESC;

-- View audit trail
SELECT 
    TableName,
    COUNT(*) AS TotalDeletions,
    MIN(DeletionDate) AS FirstDeletion,
    MAX(DeletionDate) AS LastDeletion,
    DeletedBy
FROM DeletionAudit
GROUP BY TableName, DeletedBy
ORDER BY TotalDeletions DESC;
```

## Soft Deletes vs Hard Deletes

### Implementing Soft Delete Pattern
```sql
-- Add soft delete columns to main table
ALTER TABLE Employees 
ADD IsDeleted BIT DEFAULT 0,
    DeletedDate DATETIME2 NULL,
    DeletedBy NVARCHAR(100) NULL;

-- Create soft delete procedure
CREATE PROCEDURE SoftDeleteEmployee
    @e.EmployeeID INT,
    @DeletionReason NVARCHAR(255) = 'Not specified'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EmployeeName NVARCHAR(101);
    
    -- Check if employee exists and is not already deleted
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsDeleted = 0)
    BEGIN
        PRINT 'Employee not found or already deleted';
        RETURN;
    END
    
    -- Get employee name for logging
    SELECT @EmployeeName = e.FirstName + ' ' + e.LastName 
    FROM Employees e 
    WHERE e.EmployeeID = @e.EmployeeID;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Soft delete the employee
        UPDATE Employees 
        SET 
            IsDeleted = 1,
            DeletedDate = SYSDATETIME(),
            DeletedBy = SYSTEM_USER,
            IsActive = 0,
            ModifiedDate = SYSDATETIME()
        WHERE e.EmployeeID = @e.EmployeeID;
        
        -- Log the soft deletion
        INSERT INTO EmployeeIsActiveHistory (e.EmployeeID, PreviousIsActive, NewIsActive, Reason)
        VALUES (@e.EmployeeID, 'Active', 'Soft Deleted', @DeletionReason);
        
        -- Log to deletion audit
        INSERT INTO DeletionAudit (TableName, DeletedRecordID, DeletedData, DeletionReason)
        VALUES ('Employees', @e.EmployeeID, @EmployeeName, 'Soft Delete: ' + @DeletionReason);
        
        COMMIT TRANSACTION;
        PRINT 'Employee ' + @EmployeeName + ' soft deleted successfully';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error during soft delete: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;

-- Test soft delete
EXEC SoftDeleteEmployee @e.EmployeeID = 1, @DeletionReason = 'Employee resignation';

-- Create view to exclude soft-deleted records
CREATE VIEW ActiveEmployees AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    WorkEmail,
    e.BaseSalary,
    d.DepartmentID,
    ManagerID,
    e.HireDate,
    IsActive,
    CreatedDate,
    ModifiedDate
FROM Employees e
WHERE IsDeleted = 0;

-- Test the view
SELECT * FROM ActiveEmployees ORDER BY e.EmployeeID;

-- Create procedure to restore soft-deleted employees
CREATE PROCEDURE RestoreSoftDeletedEmployee
    @e.EmployeeID INT,
    @RestoreReason NVARCHAR(255) = 'Administrative restore'
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Employees e WHERE e.EmployeeID = @e.EmployeeID AND IsDeleted = 1)
    BEGIN
        PRINT 'Employee not found or not soft deleted';
        RETURN;
    END
    
    UPDATE Employees 
    SET 
        IsDeleted = 0,
        DeletedDate = NULL,
        DeletedBy = NULL,
        IsActive = 1,
        ModifiedDate = SYSDATETIME()
    WHERE e.EmployeeID = @e.EmployeeID;
    
    -- Log the restoration
    INSERT INTO EmployeeIsActiveHistory (e.EmployeeID, PreviousIsActive, NewIsActive, Reason)
    VALUES (@e.EmployeeID, 'Soft Deleted', 'Active', @RestoreReason);
    
    PRINT 'Employee restored successfully';
END;
```

## Performance Considerations and Optimization

### Batch DELETE Operations
```sql
-- Efficient batch deletion for large datasets
CREATE PROCEDURE BatchDeleteInactiveEmployees
    @BatchSize INT = 1000,
    @MaxBatches INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchCount INT = 0;
    DECLARE @RowsDeleted INT = 1;
    DECLARE @TotalDeleted INT = 0;
    
    PRINT 'Starting batch deletion process...';
    
    WHILE @RowsDeleted > 0 AND @BatchCount < @MaxBatches
    BEGIN
        BEGIN TRANSACTION;
        
        -- Delete in batches to avoid long-running transactions
        DELETE TOP (@BatchSize) FROM EmployeeTemp 
        WHERE IsActive = 0 
          AND CreatedDate < DATEADD(MONTH, -6, GETDATE());
        
        SET @RowsDeleted = @@ROWCOUNT;
        SET @TotalDeleted = @TotalDeleted + @RowsDeleted;
        SET @BatchCount = @BatchCount + 1;
        
        COMMIT TRANSACTION;
        
        PRINT 'Batch ' + CAST(@BatchCount AS VARCHAR(10)) + 
              ': Deleted ' + CAST(@RowsDeleted AS VARCHAR(10)) + ' rows';
        
        -- Small delay to prevent blocking other operations
        WAITFOR DELAY '00:00:01';
    END
    
    PRINT 'Batch deletion completed. Total rows deleted: ' + CAST(@TotalDeleted AS VARCHAR(10));
END;

-- Performance monitoring for DELETE operations
CREATE TABLE DeletePerformanceLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OperationType NVARCHAR(50),
    TableName NVARCHAR(100),
    RowsAffected INT,
    ExecutionTimeMS INT,
    StartTime DATETIME2,
    EndTime DATETIME2,
    AdditionalInfo NVARCHAR(MAX)
);

-- Example of monitored DELETE operation
DECLARE @StartTime DATETIME2 = SYSDATETIME();
DECLARE @RowsAffected INT;

DELETE FROM EmployeeTemp 
WHERE IsActive = 0 AND d.DepartmentID = 999;  -- Non-existent d.DepartmentName

SET @RowsAffected = @@ROWCOUNT;

DECLARE @EndTime DATETIME2 = SYSDATETIME();

INSERT INTO DeletePerformanceLog (OperationType, TableName, RowsAffected, ExecutionTimeMS, StartTime, EndTime)
VALUES (
    'DELETE',
    'EmployeeTemp',
    @RowsAffected,
    DATEDIFF(MILLISECOND, @StartTime, @EndTime),
    @StartTime,
    @EndTime
);
```

### Index Considerations for UPDATE/DELETE
```sql
-- Analyze index usage for UPDATE/DELETE operations
-- Check existing indexes
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    ic.key_ordinal AS KeyOrdinal,
    ic.is_included_column AS IsIncluded
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Employees')
ORDER BY i.name, ic.key_ordinal;

-- Create optimized indexes for common UPDATE/DELETE patterns
-- Index for status updates
CREATE INDEX IX_Employees_IsActive_Filtered 
ON Employees (IsActive) 
WHERE IsActive = 0;

-- Index for date-based cleanup operations
CREATE INDEX IX_Employees_CreatedDate_IsActive 
ON Employees (CreatedDate, IsActive);

-- Index for department-based operations
CREATE INDEX IX_Employees_DepartmentID_IsActive 
ON Employees (d.DepartmentID, IsActive) 
INCLUDE (e.EmployeeID, e.FirstName, e.LastName);

-- Index for e.BaseSalary-based updates
CREATE INDEX IX_Employees_Salary_IsActive 
ON Employees (e.BaseSalary, IsActive) 
WHERE e.BaseSalary IS NOT NULL;

-- Demonstrate index usage impact
SET STATISTICS IO ON;

-- Query that should use index efficiently
UPDATE Employees 
SET ModifiedDate = SYSDATETIME()
WHERE IsActive = 0;

-- Query execution plan will show index usage
SET STATISTICS IO OFF;
```

## Error Handling and Transaction Management

### Comprehensive Error Handling for DML Operations
```sql
-- Comprehensive UPDATE/DELETE error handling procedure
CREATE PROCEDURE SafeBulkEmployeeUpdate
    @d.DepartmentID INT,
    @SalaryIncreasePercent DECIMAL(5,2),
    @UpdateReason NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  -- Automatic rollback on error
    
    DECLARE @UpdatedCount INT = 0;
    DECLARE @ErrorOccurred BIT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);
    
    -- Validation
    IF @SalaryIncreasePercent <= 0 OR @SalaryIncreasePercent > 50
    BEGIN
        PRINT 'Error: e.BaseSalary increase must be between 0 and 50 percent';
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = @d.DepartmentID)
    BEGIN
        PRINT 'Error: Invalid d.DepartmentName ID';
        RETURN;
    END
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Capture before state
        DECLARE @EmployeesBeforeUpdate TABLE (
            e.EmployeeID INT,
            OldSalary DECIMAL(10,2),
            NewSalary DECIMAL(10,2)
        );
        
        INSERT INTO @EmployeesBeforeUpdate (e.EmployeeID, OldSalary, NewSalary)
        SELECT 
            e.EmployeeID,
            e.BaseSalary,
            e.BaseSalary * (1 + @SalaryIncreasePercent / 100.0)
        FROM Employees e
        WHERE d.DepartmentID = @d.DepartmentID 
          AND IsActive = 1 
          AND e.BaseSalary IS NOT NULL;
        
        -- Perform the update
        UPDATE e
        SET 
            e.BaseSalary = e.BaseSalary * (1 + @SalaryIncreasePercent / 100.0),
            ModifiedDate = SYSDATETIME()
        FROM Employees e
    INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
        WHERE e.d.DepartmentID = @d.DepartmentID 
          AND e.IsActive = 1 
          AND e.BaseSalary IS NOT NULL;
        
        SET @UpdatedCount = @@ROWCOUNT;
        
        -- Log e.BaseSalary changes
        INSERT INTO SalaryHistory (e.EmployeeID, PreviousSalary, NewSalary, EffectiveDate, ChangeReason)
        SELECT 
            e.EmployeeID,
            OldSalary,
            NewSalary,
            GETDATE(),
            @UpdateReason
        FROM @EmployeesBeforeUpdate;
        
        COMMIT TRANSACTION;
        
        PRINT 'Successfully updated ' + CAST(@UpdatedCount AS VARCHAR(10)) + ' employees';
        
        -- Return summary of changes
        SELECT d.DepartmentName,
            COUNT(*) AS EmployeesUpdated,
            FORMAT(AVG(bu.OldSalary), 'C') AS AverageOldSalary,
            FORMAT(AVG(bu.NewSalary), 'C') AS AverageNewSalary,
            CAST(@SalaryIncreasePercent AS VARCHAR(10)) + '%' AS IncreasePercent
        FROM @EmployeesBeforeUpdate bu
        INNER JOIN Employees e ON bu.e.EmployeeID = e.EmployeeID
        INNER JOIN Departments d ON e.d.DepartmentID = d.DepartmentID
        GROUP BY d.DepartmentName;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SET @ErrorMessage = 'Error during bulk update: ' + ERROR_MESSAGE() +
                           ' (Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ')';
        PRINT @ErrorMessage;
        
        -- Log the error
        INSERT INTO DeletionAudit (TableName, DeletedRecordID, DeletedData, DeletionReason)
        VALUES ('Employees', @d.DepartmentID, 'Bulk Update Failed', @ErrorMessage);
        
        THROW;
    END CATCH
END;

-- Test the error handling procedure
EXEC SafeBulkEmployeeUpdate 
    @d.DepartmentID = 1, 
    @SalaryIncreasePercent = 5.0, 
    @UpdateReason = 'Q1 Performance Review';
```

## Best Practices Summary

### UPDATE/DELETE Best Practices Checklist
```sql
-- Best practices demonstration and checklist

-- ✓ 1. ALWAYS test with SELECT first
-- GOOD: Test the WHERE clause
SELECT COUNT(*) AS RecordsToUpdate
FROM Employees e 
WHERE DepartmentID = 1 AND IsActive = 1;

-- Then perform the UPDATE
UPDATE Employees 
SET e.BaseSalary = e.BaseSalary * 1.03
WHERE DepartmentID = 1 AND IsActive = 1;

-- ✓ 2. Use transactions for important operations
BEGIN TRANSACTION;
    -- Your UPDATE/DELETE operations here
    -- Verify results before committing
COMMIT TRANSACTION;

-- ✓ 3. Use OUTPUT clause for auditing
UPDATE Employees 
SET IsActive = 0
OUTPUT 
    deleted.e.EmployeeID,
    deleted.e.FirstName + ' ' + deleted.e.LastName AS EmployeeName,
    'Deactivated on ' + CAST(SYSDATETIME() AS VARCHAR(30)) AS AuditInfo
WHERE e.EmployeeID = 999;

-- ✓ 4. Consider soft deletes for important data
-- Instead of: DELETE FROM Employees e WHERE e.EmployeeID = 1;
UPDATE Employees 
SET IsDeleted = 1, DeletedDate = SYSDATETIME()
WHERE e.EmployeeID = 1;

-- ✓ 5. Use appropriate batch sizes for large operations
DECLARE @BatchSize INT = 1000;
WHILE @@ROWCOUNT > 0
BEGIN
    DELETE TOP (@BatchSize) FROM LargeTable 
    WHERE IsActiveID = 'OBSOLETE';
    
    -- Small delay to prevent blocking
    IF @@ROWCOUNT = @BatchSize
        WAITFOR DELAY '00:00:01';
END

-- ✓ 6. Handle foreign key constraints properly
-- Check dependencies before deletion
SELECT 
    fk.name AS ForeignKey,
    tp.name AS ParentTable,
    tc.name AS ChildTable
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.referenced_object_id = tp.object_id
INNER JOIN sys.tables tc ON fk.parent_object_id = tc.object_id
WHERE tp.name = 'Employees';

-- ✓ 7. Use proper error handling
BEGIN TRY
    -- DML operations
    UPDATE Employees SET e.BaseSalary = e.BaseSalary * 1.05 WHERE DepartmentID = 1;
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
    -- Handle appropriately
END CATCH;

-- ✓ 8. Monitor performance impact
-- Use execution plans and statistics
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Your UPDATE/DELETE operation
UPDATE Employees SET ModifiedDate = SYSDATETIME() WHERE IsActive = 1;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

## Summary

### Key Takeaways for UPDATE and DELETE Operations

1. **Safety First**
   - Always test WHERE clauses with SELECT before UPDATE/DELETE
   - Use transactions for multi-step operations
   - Consider soft deletes for recoverable data

2. **Performance Optimization**
   - Use appropriate indexes for WHERE clauses
   - Batch large operations to prevent blocking
   - Monitor execution plans and statistics

3. **Auditing and Compliance**
   - Use OUTPUT clause to capture changes
   - Maintain comprehensive audit trails
   - Log all significant data modifications

4. **Error Handling**
   - Implement comprehensive TRY...CATCH blocks
   - Validate inputs before processing
   - Handle constraint violations gracefully

5. **Advanced Techniques**
   - Leverage JOINs for complex updates/deletes
   - Use CTEs for complex data transformations
   - Implement business logic in UPDATE statements

6. **Best Practices**
   - Specify column lists explicitly
   - Handle NULLs appropriately
   - Consider concurrent access scenarios
   - Document business rules and logic

Understanding proper UPDATE and DELETE techniques is crucial for maintaining data integrity while ensuring optimal performance and comprehensive auditing in production database systems.
