# Lab: Writing Basic SELECT Statements - Beginner Lab

## 🎯 Lab Overview (🟢 COMPLETE BEGINNER LEVEL)

Welcome! This hands-on lab lets you practice writing SELECT statements step by step. You'll work through real TechCorp scenarios, starting with the simplest queries and building up your confidence. Perfect for complete beginners!

## 📖 What You'll Practice

In this lab, you'll practice:

✅ Writing your first SELECT statements  
✅ Choosing specific columns to display  
✅ Using professional column names (aliases)  
✅ Limiting results with TOP  
✅ Combining columns creatively  
✅ Solving real business questions  

## 🎯 Lab Scenario

You're the new Data Assistant at TechCorp! Your manager needs various reports about employees, departments, and projects. You'll use SELECT statements to create these reports.

## Part 1: Your First SELECT Statements 📊

### Exercise 1.1: See All Employee Data (🟢 SUPER BASIC)

**Task**: Your manager wants to see what employee data we have. Show all columns from the Employees table, but limit it to just 3 employees so it's not overwhelming.

```sql
-- Write your query here:

-- SOLUTION (try first, then check):
SELECT TOP 3 *
FROM Employees e;
```

**Expected Result**: You should see the first 3 employees with all their information columns.

### Exercise 1.2: Choose Specific Columns (🟢 BASIC)

**Task**: The manager only needs employee names and job titles for a meeting. Show FirstName, LastName, and JobTitle for the first 5 employees.

```sql
-- Write your query here:




-- SOLUTION:
SELECT TOP 5
    e.FirstName,
    e.LastName,
    e.JobTitle
FROM Employees e;
```

### Exercise 1.3: Make It Look Professional (🟢 BASIC)

**Task**: The previous report looked too technical. Make the column headers friendly by using aliases: "First Name", "Last Name", and "Job Position".

```sql
-- Write your query here:




-- SOLUTION:
SELECT TOP 5
    e.FirstName AS [First Name],
    e.LastName AS [Last Name], 
    e.JobTitle AS [Job Position]
FROM Employees e;
-- Your solution here:
-- [Space for student to write their answer]
```

## 📋 Lab Summary

Congratulations! In this lab you practiced:

✅ **Basic techniques**  
✅ **Hands-on examples**  
✅ **Real-world scenarios**  
✅ **Problem-solving skills**  

Great job building your SQL skills! Keep practicing to build your confidence.

**Next Lab**: [Next lab in sequence]
