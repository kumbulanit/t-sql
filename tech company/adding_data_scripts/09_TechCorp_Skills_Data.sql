-- =============================================
-- TechCorp Database: Skills Data Population
-- Module 5-6: Skills and Competency Data
-- =============================================

USE TechCorpDB;
GO

-- =============================================
-- SKILLS DATA
-- =============================================
PRINT 'Populating Skills table...';

INSERT INTO Skills (CategoryID, SkillName, SkillDescription, RequiredCertification, 
    MarketValue, DemandTrend, TechnologyStack, YearsInMarket) VALUES

-- Programming Skills (CategoryID = 1)
(1, 'C# .NET', 'Microsoft .NET framework development', 'Microsoft Certified Developer', 
    650.00, 'Stable', '.NET Core, ASP.NET, Entity Framework', 15),
(1, 'Python', 'Python programming for web and data applications', 'Python Institute PCAP', 
    700.00, 'Growing', 'Django, Flask, NumPy, Pandas', 12),
(1, 'JavaScript', 'Frontend and backend JavaScript development', NULL, 
    600.00, 'Growing', 'React, Node.js, Vue, Angular', 25),
(1, 'Java', 'Enterprise Java application development', 'Oracle Certified Professional', 
    650.00, 'Stable', 'Spring, Hibernate, Maven', 20),
(1, 'Go', 'Modern systems programming language', NULL, 
    750.00, 'Growing', 'Docker, Kubernetes, Microservices', 8),
(1, 'Rust', 'Systems programming with memory safety', NULL, 
    850.00, 'Growing', 'WebAssembly, Blockchain, Systems', 5),

-- Project Management Skills (CategoryID = 2)
(2, 'Agile/Scrum', 'Agile project management methodologies', 'Certified Scrum Master', 
    550.00, 'Stable', 'Jira, Azure DevOps, Trello', 20),
(2, 'PMP', 'Project Management Professional practices', 'PMP Certification', 
    800.00, 'Stable', 'MS Project, Primavera, Smartsheet', 30),
(2, 'Kanban', 'Lean project management methodology', 'Kanban Certification', 
    500.00, 'Growing', 'Trello, Azure Boards, Asana', 15),
(2, 'SAFe', 'Scaled Agile Framework', 'SAFe Certification', 
    700.00, 'Growing', 'Rally, Jira Align, Azure DevOps', 10),

-- Data Analysis Skills (CategoryID = 3)
(3, 'SQL Server', 'Microsoft SQL Server database management', 'MCSA SQL Server', 
    500.00, 'Stable', 'T-SQL, SSIS, SSRS, Power BI', 25),
(3, 'Tableau', 'Data visualization and business intelligence', 'Tableau Desktop Specialist', 
    650.00, 'Growing', 'Tableau Server, Prep, Online', 10),
(3, 'Power BI', 'Microsoft business intelligence platform', 'Microsoft Certified: Data Analyst', 
    550.00, 'Growing', 'DAX, Power Query, Power Apps', 8),
(3, 'Python Data Science', 'Data analysis and machine learning with Python', 'IBM Data Science Certificate', 
    750.00, 'Growing', 'Pandas, NumPy, Scikit-learn, Jupyter', 10),
(3, 'R', 'Statistical computing and data analysis', 'R Programming Certification', 
    600.00, 'Stable', 'ggplot2, dplyr, Shiny', 15),

-- Cloud Technologies Skills (CategoryID = 4)
(4, 'AWS', 'Amazon Web Services cloud platform', 'AWS Certified Solutions Architect', 
    950.00, 'Growing', 'EC2, S3, Lambda, RDS, CloudFormation', 15),
(4, 'Azure', 'Microsoft Azure cloud services', 'Azure Solutions Architect Expert', 
    900.00, 'Growing', 'App Service, SQL Database, Functions, DevOps', 12),
(4, 'Google Cloud', 'Google Cloud Platform services', 'Google Cloud Professional', 
    850.00, 'Growing', 'Compute Engine, BigQuery, Kubernetes Engine', 10),
(4, 'Docker', 'Container technology and orchestration', 'Docker Certified Associate', 
    650.00, 'Growing', 'Kubernetes, Swarm, Compose', 8),
(4, 'Kubernetes', 'Container orchestration platform', 'Certified Kubernetes Administrator', 
    800.00, 'Growing', 'Helm, Istio, Prometheus', 6),

-- Cybersecurity Skills (CategoryID = 5)
(5, 'Penetration Testing', 'Ethical hacking and security assessment', 'CEH, OSCP', 
    1200.00, 'Growing', 'Metasploit, Nmap, Wireshark, Burp Suite', 20),
(5, 'Security Architecture', 'Design secure systems and networks', 'CISSP, SABSA', 
    1100.00, 'Growing', 'Firewalls, IDS/IPS, SIEM', 15),
(5, 'Compliance', 'Regulatory compliance and governance', 'CISA, CISM', 
    900.00, 'Stable', 'SOX, PCI-DSS, GDPR, ISO 27001', 25),
(5, 'Incident Response', 'Security incident handling and forensics', 'GCIH, GCFA', 
    1000.00, 'Growing', 'SIEM, EDR, Forensic Tools', 18),

-- Business Analysis Skills (CategoryID = 6)
(6, 'Requirements Analysis', 'Business requirements gathering and analysis', 'CBAP, PMI-PBA', 
    600.00, 'Stable', 'Visio, Lucidchart, JIRA', 20),
(6, 'Process Modeling', 'Business process analysis and optimization', 'Six Sigma Black Belt', 
    700.00, 'Stable', 'BPMN, Visio, Bizagi', 15),
(6, 'Stakeholder Management', 'Managing project stakeholders', 'PMI-PBA', 
    650.00, 'Stable', 'Stakeholder analysis tools', 18),

-- DevOps Skills (CategoryID = 7)
(7, 'CI/CD', 'Continuous Integration and Deployment', 'Jenkins Certified Engineer', 
    750.00, 'Growing', 'Jenkins, GitLab CI, Azure DevOps', 10),
(7, 'Infrastructure as Code', 'Automated infrastructure provisioning', 'Terraform Associate', 
    800.00, 'Growing', 'Terraform, ARM Templates, CloudFormation', 8),
(7, 'Monitoring', 'Application and infrastructure monitoring', 'Certified Monitoring Professional', 
    650.00, 'Growing', 'Prometheus, Grafana, ELK Stack', 12),

-- UI/UX Design Skills (CategoryID = 8)
(8, 'UI Design', 'User interface design and prototyping', 'Adobe Certified Expert', 
    600.00, 'Growing', 'Figma, Adobe XD, Sketch', 10),
(8, 'UX Research', 'User experience research and testing', 'Google UX Design Certificate', 
    650.00, 'Growing', 'UserTesting, Hotjar, Google Analytics', 8),
(8, 'Frontend Development', 'Modern frontend development', 'Frontend Masters Certificate', 
    700.00, 'Growing', 'React, Vue, Angular, TypeScript', 12);

SELECT COUNT(*) AS SkillsInserted FROM Skills;

PRINT 'Skills data populated successfully!';
PRINT 'Total skills: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- =============================================
-- PROJECT TYPES DATA
-- =============================================
PRINT 'Populating ProjectTypes table...';

INSERT INTO ProjectTypes (TypeName, Description, TypicalDurationMonths, ComplexityLevel, RequiredTeamSize, BudgetRange) VALUES
('Web Development', 'Custom web applications and e-commerce sites', 4, 2, 5, '$50K-$200K'),
('Enterprise Software', 'Large-scale business applications', 12, 4, 15, '$500K-$2M'),
('Mobile App', 'iOS and Android mobile applications', 6, 3, 4, '$75K-$300K'),
('Data Analytics', 'Business intelligence and reporting solutions', 8, 3, 8, '$100K-$500K'),
('Cloud Migration', 'Infrastructure modernization projects', 10, 4, 12, '$200K-$1M'),
('Cybersecurity', 'Security assessments and implementations', 6, 5, 6, '$150K-$600K'),
('System Integration', 'Connecting multiple business systems', 9, 4, 10, '$300K-$800K'),
('Digital Transformation', 'Comprehensive business process digitization', 18, 5, 20, '$1M-$5M'),
('Database Migration', 'Database platform and version upgrades', 5, 3, 6, '$100K-$400K'),
('API Development', 'RESTful and GraphQL API development', 3, 2, 4, '$75K-$250K'),
('Machine Learning', 'AI and ML model development and deployment', 9, 5, 8, '$200K-$800K'),
('DevOps Implementation', 'CI/CD pipeline and automation setup', 6, 4, 5, '$150K-$500K');

SELECT COUNT(*) AS ProjectTypesInserted FROM ProjectTypes;

PRINT 'Project types data populated successfully!';
PRINT 'Ready for employee skills and project assignments.';