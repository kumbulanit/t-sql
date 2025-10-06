-- =============================================
-- TechCorp Database: Performance Metrics & Time Tracking
-- Module 8-9: Advanced Analytics Data
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- PERFORMANCE METRICS DATA
-- =============================================
PRINT 'Populating PerformanceMetrics table...';

INSERT INTO PerformanceMetrics (EmployeeID, MetricType, MetricName, TargetValue, ActualValue, 
    MeasurementUnit, PeriodStart, PeriodEnd, Weight, Achievement, Comments, ReviewedBy, ReviewDate) VALUES

-- Q3 2024 Performance Metrics - TechCorp Solutions Leadership
(4001, 'Leadership', 'Team Productivity Index', 85.00, 92.00, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 108.24, 'Exceptional team performance and project delivery', NULL, '2024-10-05'),
(4001, 'Financial', 'Department Budget Adherence', 100.00, 98.50, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 98.50, 'Strong budget management with slight savings', 4001, '2024-10-05'),
(4001, 'Quality', 'Client Satisfaction Score', 8.50, 9.20, 'Scale 1-10', '2024-07-01', '2024-09-30', 1.75, 108.24, 'Outstanding client feedback across all projects', NULL, '2024-10-05'),

(4007, 'Technical', 'Code Quality Score', 85.00, 88.50, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 104.12, 'Consistent high-quality code delivery', 4001, '2024-10-05'),
(4007, 'Leadership', 'Team Development', 3.00, 4.00, 'Team Members Promoted', '2024-07-01', '2024-09-30', 1.00, 133.33, 'Successfully mentored 4 team members for promotion', 4001, '2024-10-05'),
(4007, 'Delivery', 'Project Delivery Timeliness', 95.00, 96.50, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 101.58, 'All projects delivered on or ahead of schedule', 4001, '2024-10-05'),

(4008, 'Technical', 'Innovation Score', 75.00, 85.00, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 113.33, 'Led implementation of new Python ML frameworks', 4007, '2024-10-05'),
(4008, 'Knowledge', 'Technical Certifications', 2.00, 3.00, 'Certifications Earned', '2024-07-01', '2024-09-30', 1.00, 150.00, 'Earned AWS, Python Data Science, and Azure certifications', 4007, '2024-10-05'),

-- Engineering Team Individual Contributors
(4026, 'Technical', 'Code Commits', 180.00, 195.00, 'Commits per Quarter', '2024-07-01', '2024-09-30', 1.00, 108.33, 'Consistent and high-quality contributions', 4009, '2024-10-05'),
(4026, 'Quality', 'Bug Resolution Rate', 90.00, 94.00, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 104.44, 'Quick resolution of assigned bugs', 4009, '2024-10-05'),
(4026, 'Learning', 'Skill Development Hours', 40.00, 48.00, 'Hours', '2024-07-01', '2024-09-30', 0.75, 120.00, 'Exceeded learning goals with React and TypeScript', 4009, '2024-10-05'),

(4027, 'Technical', 'Feature Delivery', 8.00, 9.00, 'Features Completed', '2024-07-01', '2024-09-30', 1.50, 112.50, 'Delivered 9 features including complex integrations', 4009, '2024-10-05'),
(4027, 'Quality', 'Code Review Participation', 85.00, 92.00, 'Percentage', '2024-07-01', '2024-09-30', 1.00, 108.24, 'Active in code reviews and knowledge sharing', 4009, '2024-10-05'),

-- CloudTech Innovations Performance
(4021, 'Leadership', 'Team Utilization Rate', 82.00, 87.50, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 106.71, 'Optimal team resource allocation', NULL, '2024-10-05'),
(4021, 'Business', 'Client Retention Rate', 95.00, 98.00, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 103.16, 'Excellent client relationship management', NULL, '2024-10-05'),
(4021, 'Financial', 'Revenue per Employee', 120000.00, 135000.00, 'USD', '2024-07-01', '2024-09-30', 1.75, 112.50, 'Strong revenue growth and productivity', NULL, '2024-10-05'),

(4022, 'Technical', 'Infrastructure Uptime', 99.50, 99.85, 'Percentage', '2024-07-01', '2024-09-30', 1.75, 100.35, 'Exceptional system reliability', 4021, '2024-10-05'),
(4022, 'Efficiency', 'Deployment Frequency', 24.00, 32.00, 'Deployments per Month', '2024-07-01', '2024-09-30', 1.25, 133.33, 'Improved CI/CD pipeline efficiency', 4021, '2024-10-05'),
(4022, 'Security', 'Security Incidents', 0.00, 0.00, 'Incidents', '2024-07-01', '2024-09-30', 2.00, 100.00, 'Zero security incidents with proactive monitoring', 4021, '2024-10-05'),

-- Global Finance Corp Performance
(4011, 'Financial', 'Revenue Generation', 5000000.00, 5850000.00, 'USD', '2024-07-01', '2024-09-30', 2.00, 117.00, 'Exceeded revenue targets through strategic deals', NULL, '2024-10-05'),
(4011, 'Leadership', 'Team Performance Index', 88.00, 91.50, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 103.98, 'Strong team leadership and motivation', NULL, '2024-10-05'),
(4011, 'Compliance', 'Regulatory Compliance Score', 100.00, 100.00, 'Percentage', '2024-07-01', '2024-09-30', 1.75, 100.00, 'Perfect compliance record', NULL, '2024-10-05'),

(4012, 'Risk', 'Risk Assessment Accuracy', 92.00, 95.50, 'Percentage', '2024-07-01', '2024-09-30', 1.75, 103.80, 'Highly accurate risk predictions', 4011, '2024-10-05'),
(4012, 'Analytics', 'Model Performance Index', 85.00, 89.20, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 104.94, 'Improved risk models with better accuracy', 4011, '2024-10-05'),
(4012, 'Efficiency', 'Report Delivery Timeliness', 95.00, 98.50, 'Percentage', '2024-07-01', '2024-09-30', 1.25, 103.68, 'Consistent on-time report delivery', 4011, '2024-10-05'),

-- HealthTech Innovations Performance
(4015, 'Research', 'Research Publications', 3.00, 4.00, 'Publications', '2024-07-01', '2024-09-30', 1.50, 133.33, 'Published 4 high-impact research papers', NULL, '2024-10-05'),
(4015, 'Innovation', 'Patent Applications', 2.00, 3.00, 'Applications Filed', '2024-07-01', '2024-09-30', 1.75, 150.00, 'Filed 3 patent applications for new medical devices', NULL, '2024-10-05'),
(4015, 'Leadership', 'Team Research Output', 75.00, 82.00, 'Publications Index', '2024-07-01', '2024-09-30', 1.25, 109.33, 'Team exceeded research publication goals', NULL, '2024-10-05'),

(4054, 'Research', 'Clinical Trial Progress', 80.00, 85.00, 'Percentage Complete', '2024-07-01', '2024-09-30', 1.75, 106.25, 'Clinical trials ahead of schedule', 4015, '2024-10-05'),
(4054, 'Quality', 'Data Quality Score', 95.00, 97.50, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 102.63, 'Exceptional data quality and integrity', 4015, '2024-10-05'),

-- AutoManu Systems Performance
(4018, 'Engineering', 'Design Efficiency', 85.00, 91.00, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 107.06, 'Improved design processes and automation', NULL, '2024-10-05'),
(4018, 'Quality', 'Manufacturing Defect Rate', 2.50, 1.80, 'Percentage', '2024-07-01', '2024-09-30', 1.75, 128.00, 'Significant reduction in manufacturing defects', NULL, '2024-10-05'),
(4018, 'Innovation', 'Process Improvements', 5.00, 7.00, 'Improvements Implemented', '2024-07-01', '2024-09-30', 1.25, 140.00, 'Led 7 major process improvement initiatives', NULL, '2024-10-05'),

-- EnerTech Global Performance
(4023, 'Production', 'Production Efficiency', 88.00, 92.50, 'Percentage', '2024-07-01', '2024-09-30', 1.75, 105.11, 'Improved production line efficiency', NULL, '2024-10-05'),
(4023, 'Safety', 'Safety Incident Rate', 0.50, 0.20, 'Incidents per 1000 hours', '2024-07-01', '2024-09-30', 2.00, 150.00, 'Exceptional safety record improvement', NULL, '2024-10-05'),
(4023, 'Environmental', 'Environmental Compliance', 100.00, 100.00, 'Percentage', '2024-07-01', '2024-09-30', 1.50, 100.00, 'Perfect environmental compliance record', NULL, '2024-10-05');

SELECT COUNT(*) AS PerformanceMetricsInserted FROM PerformanceMetrics;

PRINT 'Performance metrics data populated successfully!';
PRINT 'Total performance metrics: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- =============================================
-- TIME TRACKING DATA (Sample for current week)
-- =============================================
PRINT 'Populating TimeTracking table...';

INSERT INTO TimeTracking (EmployeeID, ProjectID, AssignmentID, WorkDate, StartTime, EndTime, 
    BreakMinutes, TotalHours, BillableHours, OvertimeHours, WorkType, Location, 
    TaskDescription, IsApproved, ApprovedBy, ApprovedDate) VALUES

-- Week of 2024-09-30 to 2024-10-04 (Recent time entries)
-- Sarah Chen (VP Engineering) - Mixed activities
(4001, NULL, NULL, '2024-09-30', '08:00', '17:30', 60, 8.50, 0.00, 0.50, 'Management', 'San Francisco Office', 'Executive meetings and strategic planning', 1, NULL, '2024-10-02'),
(4001, 8001, 9001, '2024-10-01', '09:00', '12:00', 0, 3.00, 3.00, 0.00, 'Project Management', 'San Francisco Office', 'E-commerce project review and client meeting', 1, NULL, '2024-10-03'),
(4001, NULL, NULL, '2024-10-02', '08:30', '17:00', 45, 7.75, 0.00, 0.00, 'Management', 'San Francisco Office', 'Team performance reviews and budget planning', 1, NULL, '2024-10-04'),

-- Alex Patel (Engineering Manager) - Project work
(4007, 8002, 9006, '2024-09-30', '08:30', '17:00', 60, 7.50, 7.50, 0.00, 'Development', 'San Francisco Office', 'CRM integration architecture review', 1, 4001, '2024-10-02'),
(4007, 8001, NULL, '2024-10-01', '09:00', '18:00', 60, 8.00, 6.00, 1.00, 'Development', 'San Francisco Office', 'E-commerce platform code review and mentoring', 1, 4001, '2024-10-03'),
(4007, NULL, NULL, '2024-10-02', '08:00', '17:30', 60, 8.50, 0.00, 0.50, 'Management', 'San Francisco Office', 'Team meetings and performance discussions', 1, 4001, '2024-10-04'),

-- Emma Davis (Principal Engineer) - Technical work
(4008, 8004, 9014, '2024-09-30', '09:00', '18:30', 45, 8.75, 8.00, 0.75, 'Development', 'Remote', 'Data pipeline development for analytics dashboard', 1, 4007, '2024-10-02'),
(4008, 8001, 9002, '2024-10-01', '08:30', '17:00', 60, 7.50, 7.50, 0.00, 'Development', 'San Francisco Office', 'Backend API development for e-commerce platform', 1, 4007, '2024-10-03'),
(4008, NULL, NULL, '2024-10-02', '10:00', '15:00', 30, 4.50, 0.00, 0.00, 'Learning', 'Remote', 'Machine learning certification study', 1, 4007, '2024-10-04'),

-- Daniel Chang (Senior Developer) - Project assignments
(4026, 8001, 9003, '2024-09-30', '09:00', '18:00', 60, 8.00, 8.00, 0.00, 'Development', 'San Francisco Office', 'React component development for e-commerce UI', 1, 4009, '2024-10-02'),
(4026, 8002, 9008, '2024-10-01', '08:30', '17:30', 60, 8.00, 8.00, 0.00, 'Development', 'San Francisco Office', 'CRM integration testing and bug fixes', 1, 4009, '2024-10-03'),
(4026, 8001, 9003, '2024-10-02', '09:30', '18:30', 45, 8.25, 8.00, 0.25, 'Development', 'San Francisco Office', 'Frontend optimization and performance tuning', 1, 4009, '2024-10-04'),

-- CloudTech Innovations team
(4021, 8005, 9016, '2024-09-30', '08:00', '17:00', 60, 8.00, 8.00, 0.00, 'Architecture', 'Seattle Office', 'AWS migration architecture design', 1, NULL, '2024-10-02'),
(4022, 8005, 9017, '2024-09-30', '08:30', '18:30', 60, 9.00, 8.00, 1.00, 'DevOps', 'Seattle Office', 'CI/CD pipeline configuration for cloud migration', 1, 4021, '2024-10-02'),
(4041, 8005, 9018, '2024-09-30', '09:00', '18:00', 45, 8.25, 8.00, 0.25, 'Development', 'Remote', 'AWS Lambda functions development', 1, 4021, '2024-10-02'),

-- Global Finance Corp team
(4011, 8007, 9021, '2024-09-30', '07:30', '16:30', 60, 8.00, 4.00, 0.00, 'Management', 'New York Office', 'Trading platform stakeholder meetings', 1, NULL, '2024-10-02'),
(4047, 8007, 9023, '2024-09-30', '08:00', '19:00', 60, 10.00, 10.00, 2.00, 'Development', 'New York Office', 'High-frequency trading algorithm optimization', 1, 4014, '2024-10-02'),
(4012, 8008, 9026, '2024-09-30', '08:30', '17:30', 60, 8.00, 8.00, 0.00, 'Analytics', 'New York Office', 'Risk model validation and testing', 1, 4011, '2024-10-02'),

-- Weekend and overtime entries
(4008, 8004, 9014, '2024-10-05', '10:00', '15:00', 30, 4.50, 4.50, 0.00, 'Development', 'Remote', 'Weekend development work on analytics dashboard', 0, NULL, NULL),
(4022, 8005, 9017, '2024-10-05', '14:00', '19:00', 0, 5.00, 5.00, 5.00, 'DevOps', 'Remote', 'Emergency deployment and system maintenance', 0, NULL, NULL);

SELECT COUNT(*) AS TimeEntriesInserted FROM TimeTracking;

PRINT 'Time tracking data populated successfully!';
PRINT 'Total time entries: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Show performance summary
SELECT 
    'Performance Metrics Summary' as ReportType,
    COUNT(*) as TotalMetrics,
    AVG(Achievement) as AvgAchievement,
    MIN(Achievement) as MinAchievement,
    MAX(Achievement) as MaxAchievement
FROM PerformanceMetrics
UNION ALL
SELECT 
    'Time Tracking Summary',
    COUNT(*),
    AVG(TotalHours),
    MIN(TotalHours),
    MAX(TotalHours)
FROM TimeTracking;

PRINT 'Performance and time tracking data population completed!';
PRINT 'Database fully populated and ready for advanced analytics queries.';