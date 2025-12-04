# Column Reference Fix Report

- Total references inspected: 119
- Changes applied: 1
- Unresolved references: 4

## Changes
### Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md
- Line 131: `e.d.DepartmentName` → `d.DepartmentName` (removed duplicate qualifier)

## Unresolved References
- Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md (line 132): `e.AvgSalary` — no column named `AvgSalary` in table `Employees`
- Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md (line 143): `e.DepartmentName` — no column named `DepartmentName` in table `Employees`
- Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md (line 144): `e.AvgSalary` — no column named `AvgSalary` in table `Employees`
- Module 2 - Introduction to T-SQL Querying/Lesson4_Understanding_Logical_Order_of_Operations.md (line 145): `e.AvgSalary` — no column named `AvgSalary` in table `Employees`

## Column Usage (top 20)
- Employees.BaseSalary: 28
- Employees.DepartmentID: 17
- Departments.DepartmentID: 17
- Departments.DepartmentName: 14
- Employees.FirstName: 12
- Employees.LastName: 11
- Employees.HireDate: 6
- Employees.avgsalary: 3
- EmployeeProjects.HoursWorked: 3
- Employees.departmentname: 1
- Departments.DepartmentCode: 1
- Projects.ProjectName: 1
- Employees.EmployeeID: 1
- EmployeeProjects.EmployeeID: 1
- EmployeeProjects.ProjectID: 1
- Projects.ProjectID: 1
- Employees.IsActive: 1
