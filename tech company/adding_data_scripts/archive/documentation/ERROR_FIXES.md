# TechCorp Database - Error Fixes

## Error Resolution for Common Schema Issues

### Issue 1: Data Type Conversion Error
**Error**: `Conversion failed when converting the varchar value 'Active' to data type bit`

**Root Cause**: Attempting to assign string values like `'Active'` to BIT columns that expect 1/0 values.

**Solution**: Use the correct column and data type mappings:

```sql
-- ❌ INCORRECT - This will cause the error
UPDATE SomeTable SET IsActive = 'Active';

-- ✅ CORRECT - Use BIT values for IsActive columns
UPDATE SomeTable SET IsActive = 1; -- For active records
UPDATE SomeTable SET IsActive = 0; -- For inactive records

-- ✅ CORRECT - Use Status column for string values
UPDATE Projects SET Status = 'Active' WHERE ProjectID = 5001;
UPDATE Projects SET Status = 'Completed' WHERE ProjectID = 5002;
UPDATE Projects SET Status = 'On Hold' WHERE ProjectID = 5003;
```

### Issue 2: Missing Column `hoursAllocated`
**Error**: `Invalid column name 'hoursAllocated'`

**Root Cause**: The column `hoursAllocated` doesn't exist in the current schema.

**Available Columns for Hours Tracking**:

```sql
-- ✅ CORRECT column names in different tables:

-- In EmployeeProjects table:
SELECT AllocationPercentage FROM EmployeeProjects; -- Percentage allocation

-- In TimeTracking table:
SELECT HoursWorked, BillableHours FROM TimeTracking;

-- In Projects table (from advanced tables):
SELECT EstimatedHours, ActualHours FROM Projects;

-- In PerformanceMetrics table:
SELECT MetricValue FROM PerformanceMetrics WHERE MetricType = 'Hours';
```

## Quick Fix Examples

### Example 1: Correct Project Status Updates
```sql
-- Update project status using correct column names
UPDATE Projects 
SET Status = 'Active', 
    IsActive = 1 
WHERE ProjectID = 5001;

UPDATE Projects 
SET Status = 'Completed', 
    IsActive = 1 
WHERE ProjectID = 5002;

UPDATE Projects 
SET Status = 'On Hold', 
    IsActive = 0  -- Inactive projects
WHERE ProjectID = 5003;
```

### Example 2: Correct Hours Tracking
```sql
-- ❌ INCORRECT - Column doesn't exist
SELECT EmployeeID, hoursAllocated FROM EmployeeProjects;

-- ✅ CORRECT - Use proper column names
SELECT 
    EmployeeID, 
    AllocationPercentage,
    CASE 
        WHEN AllocationPercentage = 100 THEN 'Full Time'
        WHEN AllocationPercentage >= 50 THEN 'Part Time'
        ELSE 'Minimal'
    END AS AllocationLevel
FROM EmployeeProjects;

-- ✅ CORRECT - Get actual hours worked
SELECT 
    EmployeeID,
    SUM(HoursWorked) AS TotalHours,
    SUM(BillableHours) AS TotalBillableHours
FROM TimeTracking 
GROUP BY EmployeeID;
```

### Example 3: Comprehensive Employee Project Hours
```sql
-- Get complete hours information for employees
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    p.ProjectName,
    ep.AllocationPercentage,
    ep.Role,
    ISNULL(SUM(tt.HoursWorked), 0) AS ActualHours,
    ISNULL(SUM(tt.BillableHours), 0) AS BillableHours,
    CASE 
        WHEN ep.IsActive = 1 THEN 'Active Assignment'
        ELSE 'Inactive Assignment'
    END AS AssignmentStatus
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID
LEFT JOIN TimeTracking tt ON e.EmployeeID = tt.EmployeeID 
    AND p.ProjectID = tt.ProjectID
WHERE e.IsActive = 1  -- Use BIT value, not string
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName, p.ProjectName,
    ep.AllocationPercentage, ep.Role, ep.IsActive
ORDER BY e.EmployeeID, p.ProjectName;
```

## Schema Reference

### BIT Columns (Use 1/0, not strings):
- `IsActive` in all tables
- `IsApproved` in TimeTracking

### String Status Columns:
- `Status` in Projects ('Active', 'Completed', 'On Hold', etc.)
- `AccountStatus` in Customers ('Active', 'Inactive', 'Suspended', 'Closed')

### Hours-Related Columns:
- `HoursWorked` in TimeTracking
- `BillableHours` in TimeTracking  
- `EstimatedHours` in Projects (if using advanced schema)
- `ActualHours` in Projects (if using advanced schema)
- `AllocationPercentage` in EmployeeProjects

## Common Query Patterns

### Safe Status Checking:
```sql
-- For BIT columns
WHERE IsActive = 1
WHERE IsApproved = 0

-- For string status columns  
WHERE Status = 'Active'
WHERE AccountStatus IN ('Active', 'Suspended')
```

### Hours Calculations:
```sql
-- Total hours per employee
SELECT 
    EmployeeID,
    SUM(HoursWorked) as TotalHours,
    AVG(HoursWorked) as AvgDailyHours
FROM TimeTracking
WHERE WorkDate >= '2024-01-01'
GROUP BY EmployeeID;

-- Project allocation summary
SELECT 
    ProjectID,
    COUNT(EmployeeID) as TeamSize,
    AVG(AllocationPercentage) as AvgAllocation
FROM EmployeeProjects
WHERE IsActive = 1
GROUP BY ProjectID;
```

Use these patterns to avoid the data type conversion and missing column errors!