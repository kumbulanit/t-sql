-- =============================================
-- TechCorp Database: Advanced Tables Creation
-- Module 5-7: Skills, Projects, and Performance
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- 4. SKILLS AND COMPETENCY TRACKING (Module 5/6 level)
-- =============================================

-- Skills table
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(5001,1),
    CategoryID INT NOT NULL,
    SkillName NVARCHAR(100) NOT NULL,
    SkillDescription NVARCHAR(500) NULL,
    RequiredCertification NVARCHAR(200) NULL,
    MarketValue DECIMAL(8,2) NULL, -- daily rate premium
    DemandTrend NVARCHAR(20) NOT NULL DEFAULT 'Stable', -- Growing, Stable, Declining
    TechnologyStack NVARCHAR(200) NULL,
    YearsInMarket TINYINT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (CategoryID) REFERENCES SkillCategories(CategoryID)
);

-- Employee Skills junction table
CREATE TABLE EmployeeSkills (
    EmployeeSkillID INT PRIMARY KEY IDENTITY(6001,1),
    EmployeeID INT NOT NULL,
    SkillID INT NOT NULL,
    ProficiencyLevel TINYINT NOT NULL CHECK (ProficiencyLevel BETWEEN 1 AND 5),
    YearsExperience DECIMAL(3,1) NULL,
    LastUsedDate DATE NULL,
    CertificationDate DATE NULL,
    CertificationExpiry DATE NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    SelfAssessmentScore TINYINT NULL CHECK (SelfAssessmentScore BETWEEN 1 AND 10),
    ManagerAssessmentScore TINYINT NULL CHECK (ManagerAssessmentScore BETWEEN 1 AND 10),
    AssessmentDate DATE NULL,
    AssessmentNotes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID),
    UNIQUE (EmployeeID, SkillID)
);

-- =============================================
-- 5. PROJECT AND ASSIGNMENT TRACKING (Module 7 level)
-- =============================================

-- Project Types table
CREATE TABLE ProjectTypes (
    ProjectTypeID INT PRIMARY KEY IDENTITY(7001,1),
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL,
    TypicalDurationMonths TINYINT NULL,
    ComplexityLevel TINYINT NOT NULL DEFAULT 1 CHECK (ComplexityLevel BETWEEN 1 AND 5),
    RequiredTeamSize TINYINT NULL,
    BudgetRange NVARCHAR(50) NULL
);

-- Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(8001,1),
    CompanyID INT NOT NULL,
    ProjectTypeID INT NOT NULL,
    ProjectName NVARCHAR(200) NOT NULL,
    ProjectCode NVARCHAR(20) NOT NULL UNIQUE,
    ClientContactName NVARCHAR(100) NULL,
    ClientContactEmail NVARCHAR(100) NULL,
    ProjectManagerID INT NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Planning',
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium',
    StartDate DATE NOT NULL,
    PlannedEndDate DATE NOT NULL,
    ActualEndDate DATE NULL,
    Budget DECIMAL(12,2) NOT NULL,
    ActualCost DECIMAL(12,2) NULL,
    EstimatedHours DECIMAL(8,1) NULL,
    ActualHours DECIMAL(8,1) NULL,
    BillingType NVARCHAR(20) NOT NULL DEFAULT 'Fixed Price',
    HourlyRate DECIMAL(8,2) NULL,
    Currency CHAR(3) NOT NULL DEFAULT 'USD',
    RiskLevel TINYINT NOT NULL DEFAULT 1 CHECK (RiskLevel BETWEEN 1 AND 5),
    Description NVARCHAR(MAX) NULL,
    DeliveryAddress NVARCHAR(500) NULL,
    ContractSignedDate DATE NULL,
    WarrantyMonths TINYINT NULL DEFAULT 12,
    MaintenanceIncluded BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (ProjectTypeID) REFERENCES ProjectTypes(ProjectTypeID),
    FOREIGN KEY (ProjectManagerID) REFERENCES Employees(EmployeeID)
);

-- Employee Projects assignment table
CREATE TABLE EmployeeProjects (
    AssignmentID INT PRIMARY KEY IDENTITY(9001,1),
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Role NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    AllocationPercentage DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    BillableRate DECIMAL(8,2) NULL,
    EstimatedHours DECIMAL(8,1) NULL,
    ActualHours DECIMAL(8,1) NULL,
    PerformanceRating TINYINT NULL CHECK (PerformanceRating BETWEEN 1 AND 5),
    IsLead BIT NOT NULL DEFAULT 0,
    ResponsibilityArea NVARCHAR(200) NULL,
    KeyAchievements NVARCHAR(MAX) NULL,
    ChallengesFaced NVARCHAR(MAX) NULL,
    ClientFeedbackScore TINYINT NULL CHECK (ClientFeedbackScore BETWEEN 1 AND 10),
    InternalFeedbackScore TINYINT NULL CHECK (InternalFeedbackScore BETWEEN 1 AND 10),
    IsActive BIT NOT NULL DEFAULT 1,
    AssignedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    AssignedBy NVARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- =============================================
-- 6. TIME TRACKING AND PERFORMANCE (Advanced Module 6/7 level)
-- =============================================

-- Time Tracking table
CREATE TABLE TimeTracking (
    TimeEntryID INT PRIMARY KEY IDENTITY(10001,1),
    EmployeeID INT NOT NULL,
    ProjectID INT NULL,
    AssignmentID INT NULL,
    WorkDate DATE NOT NULL,
    StartTime TIME(0) NOT NULL,
    EndTime TIME(0) NULL,
    BreakMinutes SMALLINT NOT NULL DEFAULT 0,
    TotalHours DECIMAL(4,2) NOT NULL,
    BillableHours DECIMAL(4,2) NOT NULL DEFAULT 0,
    OvertimeHours DECIMAL(4,2) NOT NULL DEFAULT 0,
    WorkType NVARCHAR(50) NOT NULL DEFAULT 'Regular',
    Location NVARCHAR(100) NULL,
    TaskDescription NVARCHAR(500) NULL,
    IsApproved BIT NOT NULL DEFAULT 0,
    ApprovedBy INT NULL,
    ApprovedDate DATETIME2(3) NULL,
    SubmittedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AssignmentID) REFERENCES EmployeeProjects(AssignmentID),
    FOREIGN KEY (ApprovedBy) REFERENCES Employees(EmployeeID)
);

-- Performance Metrics table
CREATE TABLE PerformanceMetrics (
    MetricID INT PRIMARY KEY IDENTITY(11001,1),
    EmployeeID INT NOT NULL,
    MetricType NVARCHAR(50) NOT NULL,
    MetricName NVARCHAR(100) NOT NULL,
    TargetValue DECIMAL(10,2) NOT NULL,
    ActualValue DECIMAL(10,2) NULL,
    MeasurementUnit NVARCHAR(20) NULL,
    PeriodStart DATE NOT NULL,
    PeriodEnd DATE NOT NULL,
    Weight DECIMAL(3,2) NOT NULL DEFAULT 1.00, -- importance weighting
    Achievement DECIMAL(5,2) NULL, -- percentage achieved
    Comments NVARCHAR(MAX) NULL,
    ReviewedBy INT NULL,
    ReviewDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReviewedBy) REFERENCES Employees(EmployeeID)
);

PRINT 'Advanced tables created successfully!';
PRINT 'Ready for skills, projects, and performance data population.';