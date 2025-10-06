-- =============================================
-- TechCorp Database Creation Script
-- Module 1: Database Foundation
-- =============================================

-- Create TechCorp Solutions Database
USE master;
GO

-- Drop database if exists (for clean setup)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TechCorpDB')
BEGIN
    ALTER DATABASE TechCorpDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechCorpDB;
END
GO

-- Create database with proper file structure
CREATE DATABASE TechCorpDB
ON (
    NAME = 'TechCorpDB_Data',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\TechCorpDB.mdf',
    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 10MB
)
LOG ON (
    NAME = 'TechCorpDB_Log',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\TechCorpDB.ldf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 1MB
);
GO

-- Switch to TechCorp database
USE TechCorpDB;
GO

PRINT 'TechCorpDB database created successfully!';
PRINT 'Ready for table creation and data population.';