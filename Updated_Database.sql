-- Creating the Database --
CREATE DATABASE timesheet3
GO
USE [timesheet3]
GO

-- Creating base tables --

-- Creating the table named Companies containing all the company names --

CREATE TABLE Companies (
   CompanyID INT IDENTITY(1,1) PRIMARY KEY,
   CompanyName VARCHAR(50) NOT NULL,
   CONSTRAINT unique_company UNIQUE (CompanyName)
);

-- Inserting values into Companies table --
INSERT INTO Companies (CompanyName)
VALUES ('Cleaning validation MFG6'), ('MFG7'), ('Sanofi Frankfurt'), ('Seres Therapeutics'),
       ('Wuppertal/Aprath'), ('MFG19'), ('WuXi Dundalk MFG7'), ('Tech Transfer'), ('Multiple'),
       ('Innovation Team'), ('Office');


-- Creating the table named Roles containing all the role names --

CREATE TABLE Roles (
   RoleID INT IDENTITY(1,1) PRIMARY KEY,
   RoleName VARCHAR(50) NOT NULL,
   CONSTRAINT unique_role UNIQUE (RoleName)
);

--Inserting values into Roles table --
INSERT INTO Roles (RoleName)
VALUES ('Regular User'), ('Project Manager'), ('Admin'), ('Supervisor');


-- Creating the table named Projects containing all the project names -- 

CREATE TABLE Projects (
   ProjectID INT IDENTITY(1,1) PRIMARY KEY,
   ProjectName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_projects_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

--Inserting values into Projects table --
INSERT INTO Projects (ProjectName, CompanyID)
VALUES
  ('Cleaning validation MFG6', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Cleaning validation MFG6')),
  ('MFG7', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG7')),
  ('Sanofi Frankfurt', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Sanofi Frankfurt')),
  ('Seres Therapeutics', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Seres Therapeutics')),
  ('Wuppertal/Aprath', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Wuppertal/Aprath')),
  ('MFG19', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG19')),
  ('WuXi Dundalk MFG7', (SELECT CompanyID FROM Companies WHERE CompanyName = 'WuXi Dundalk MFG7')),
  ('Tech Transfer', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Tech Transfer')),
  ('Multiple', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Multiple')),
  ('Innovation Team', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Innovation Team')),
  ('Office', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Office'));


-- Creating the table named Users containing all the Users --

CREATE TABLE Users (
   UserID INT IDENTITY(1,1) PRIMARY KEY,
   UserName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_users_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Inserting values to Users table

INSERT INTO Users (UserName, CompanyID)
VALUES
  ('Edem Iron', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Cleaning validation MFG6')),
  ('Ismail Bin On', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG7')),
  ('Aisling Noonan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Sanofi Frankfurt')),
  ('Alicja Zagozdzon', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Seres Therapeutics')),
  ('Declan O Riordan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Wuppertal/Aprath')),
  ('Dylan Leslie', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG19')),
  ('Eoin Reilly', (SELECT CompanyID FROM Companies WHERE CompanyName = 'WuXi Dundalk MFG7')),
  ('Kevin Foley', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Tech Transfer')),
  ('Kevin Sexton', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Multiple')),
  ('Leah Dillon', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Innovation Team')),
  ('Mudiaga Gberevbie', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Office')),
  ('Ed Storan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Cleaning validation MFG6')),
  ('Tony Calnan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG7')),
  ('Orla Barber', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Sanofi Frankfurt')),
  ('Elva O Conaire', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Seres Therapeutics')),
  ('Siobhan Wallace', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Wuppertal/Aprath')),
  ('Bernadette Keohane', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG19')),
  ('Cormac Ring', (SELECT CompanyID FROM Companies WHERE CompanyName = 'WuXi Dundalk MFG7')),
  ('Louis Tate', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Tech Transfer')),
  ('Aoife Anderson', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Multiple')),
  ('Betina Fossati', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Innovation Team')),
  ('Brian O Connell', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Office'));

 
-- Creating the table named UserCredentials containing the credentials for login -- 

CREATE TABLE UserCredentials (
    UserCredentialID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    UserName VARCHAR(255) NOT NULL,
    PassCode VARCHAR(255) NOT NULL,
    CONSTRAINT fk_UserCredentials_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Inserting values to the UserCredentials table

INSERT INTO UserCredentials (UserID, UserName, PassCode)
SELECT u.UserID, u.UserName, CONVERT(varchar(255), NEWID())
FROM Users u
JOIN Companies c ON u.CompanyID = c.CompanyID
WHERE c.CompanyName IN ('Cleaning validation MFG6', 'MFG7', 'Sanofi Frankfurt', 'Seres Therapeutics', 'Wuppertal/Aprath', 'MFG19', 'WuXi Dundalk MFG7', 'Tech Transfer', 'Multiple', 'Innovation Team', 'Office');

-- Creating the table named Office 

CREATE TABLE Office (
   OfficeID INT IDENTITY(1,1) PRIMARY KEY,
   OfficeName VARCHAR(50) NOT NULL
);

-- Inserting values into Office table --
INSERT INTO Office (OfficeName)
VALUES ('Germany'), ('Ireland'), ('USA'), ('Netherlands'), ('Singapore'), ('Switzerland'), ('UK');

-- Creating the table named Department containing the different departments --

CREATE TABLE Department (
   DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
   DepartmentName VARCHAR(50) NOT NULL
);

-- Inserting values into Department table --
INSERT INTO Department (DepartmentName)
VALUES ('Admin'), ('Engineering'), ('Finance'), ('HR/Admin'), ('Innovation'), ('Marketing'), ('Quality'), ('Recruit'), ('Tech Transfer'), ('Training');
-- Creating the table named ProjectManagers containg all the project managers linked with a project --

CREATE TABLE ProjectManagers (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    ManagerName VARCHAR(100) NOT NULL,
    CONSTRAINT unique_ProjectManager UNIQUE (ProjectID),
    CONSTRAINT fk_ProjectManagers_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Inserting into ProjectManagers table

INSERT INTO ProjectManagers (ProjectID, ManagerName)
VALUES
  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
   (SELECT UserName FROM Users WHERE UserName = 'Ed Storan')),
  
  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
   (SELECT UserName FROM Users WHERE UserName = 'Tony Calnan')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
   (SELECT UserName FROM Users WHERE UserName = 'Orla Barber')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
   (SELECT UserName FROM Users WHERE UserName = 'Elva O Conaire')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
   (SELECT UserName FROM Users WHERE UserName = 'Siobhan Wallace')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
   (SELECT UserName FROM Users WHERE UserName = 'Bernadette Keohane')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
   (SELECT UserName FROM Users WHERE UserName = 'Cormac Ring')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
   (SELECT UserName FROM Users WHERE UserName = 'Louis Tate')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
   (SELECT UserName FROM Users WHERE UserName = 'Aoife Anderson')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
   (SELECT UserName FROM Users WHERE UserName = 'Betina Fossati')),

  ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
   (SELECT UserName FROM Users WHERE UserName = 'Brian O Connell'));

-- Link Tables --

-- Creating Link table named UserProjectRoles that creates a link between the users the project they belong to and the role they have --

CREATE TABLE UserProjectRoles (
   UserProjectRoleID INT IDENTITY(1,1) PRIMARY KEY,
   UserID INT NOT NULL,
   ProjectID INT NOT NULL,
   RoleID INT NOT NULL,
   CONSTRAINT fk_UserProjectRoles_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
   CONSTRAINT fk_UserProjectRoles_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
   CONSTRAINT fk_UserProjectRoles_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
   CONSTRAINT unique_UserProjectRole UNIQUE (UserID, ProjectID, RoleID)
);

-- Inserting values to the UserProjectRoles table

INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES
  ((SELECT UserID FROM Users WHERE UserName = 'Edem Iron'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Ismail Bin On'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Aisling Noonan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Alicja Zagozdzon'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Declan O Riordan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Dylan Leslie'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Eoin Reilly'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Kevin Foley'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Kevin Sexton'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Leah Dillon'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Mudiaga Gberevbie'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE UserName = 'Ed Storan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Tony Calnan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Orla Barber'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Elva O Conaire'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Siobhan Wallace'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Bernadette Keohane'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Cormac Ring'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Louis Tate'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Aoife Anderson'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Betina Fossati'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),

  ((SELECT UserID FROM Users WHERE UserName = 'Brian O Connell'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager'));



-- Creating Link table named UserProjectManager that creates a link between the users and the project managers and the project they are linked to --

CREATE TABLE UserProjectManager (
   UserProjectManagerID INT IDENTITY(1,1) PRIMARY KEY,
   UserID INT NOT NULL,
   ProjectID INT NOT NULL,
   ProjectManagerID INT NOT NULL,
   CONSTRAINT unique_UserProjectManager UNIQUE (UserID, ProjectID),
   CONSTRAINT fk_UserProjectManager_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
   CONSTRAINT fk_UserProjectManager_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
   CONSTRAINT fk_UserProjectManager_ProjectManagers FOREIGN KEY (ProjectManagerID) REFERENCES ProjectManagers(ManagerID)
);

-- Inserting values to UserProjectManager table

INSERT INTO UserProjectManager (UserID, ProjectID, ProjectManagerID)
SELECT 
  u.UserID,
  p.ProjectID,
  pm.ManagerID
FROM
  Users u
JOIN Projects p ON u.UserName = 
  CASE 
    WHEN p.ProjectName = 'Cleaning validation MFG6' THEN 'Edem Iron'
    WHEN p.ProjectName = 'MFG7' THEN 'Ismail Bin On'
    WHEN p.ProjectName = 'Sanofi Frankfurt' THEN 'Aisling Noonan'
    WHEN p.ProjectName = 'Seres Therapeutics' THEN 'Alicja Zagozdzon'
    WHEN p.ProjectName = 'Wuppertal/Aprath' THEN 'Declan O''Riordan'
    WHEN p.ProjectName = 'MFG19' THEN 'Dylan Leslie'
    WHEN p.ProjectName = 'WuXi Dundalk MFG7' THEN 'Eoin Reilly'
    WHEN p.ProjectName = 'Tech Transfer' THEN 'Kevin Foley'
    WHEN p.ProjectName = 'Multiple' THEN 'Kevin Sexton'
    WHEN p.ProjectName = 'Innovation Team' THEN 'Leah Dillon'
    WHEN p.ProjectName = 'Office' THEN 'Mudiaga Gberevbie'
    ELSE NULL
  END
JOIN ProjectManagers pm ON p.ProjectID = pm.ProjectID;


-- Creating Link table named UserProjectLink that creates a link between the users and the projects that are linked to the user --

CREATE TABLE UserProjectLink (
   UserProjectLinkID INT IDENTITY(1,1) PRIMARY KEY,
   UserID INT NOT NULL,
   ProjectID INT NOT NULL,
   CONSTRAINT fk_UserProjectLink_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
   CONSTRAINT fk_UserProjectLink_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
   CONSTRAINT unique_UserProjectLink UNIQUE (UserID, ProjectID)
);

-- Inserting values to UserProjectLink table

INSERT INTO UserProjectLink (UserID, ProjectID)
SELECT u.UserID, p.ProjectID
FROM Users u
CROSS JOIN Projects p;

-- Creating table named TimesheetEntries containing the timesheet entries --

CREATE TABLE TimesheetEntries (
    EntryID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ProjectName VARCHAR(50) NOT NULL,
    ManagerID INT NOT NULL,
    WeekNumber INT NOT NULL,
    WeekStartDate DATE NOT NULL,
    WeekEndDate DATE NOT NULL,
    MondayHours DECIMAL(5, 2) NOT NULL,
    TuesdayHours DECIMAL(5, 2) NOT NULL,
    WednesdayHours DECIMAL(5, 2) NOT NULL,
    ThursdayHours DECIMAL(5, 2) NOT NULL,
    FridayHours DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_TimesheetEntries_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT fk_TimesheetEntries_ProjectManagers FOREIGN KEY (ManagerID) REFERENCES ProjectManagers(ManagerID)
);
SELECT * FROM TimesheetEntries
-- Inserting values to TimesheetEntries table

-- Timesheet entry for Ismail Bin On
INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE UserName = 'Ismail Bin On'),
    'MFG7',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE UserName = 'Ismail Bin On') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);

-- Timesheet entry for Aisling Noonan
INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE UserName = 'Aisling Noonan'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE UserName = 'Aisling Noonan') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);


-- Viewing the entire database

SELECT u.UserName,
       c.CompanyName,
       p.ProjectName,
       r.RoleName
FROM Users u
JOIN Companies c ON u.CompanyID = c.CompanyID
JOIN UserProjectRoles upr ON u.UserID = upr.UserID
JOIN Projects p ON upr.ProjectID = p.ProjectID
JOIN Roles r ON upr.RoleID = r.RoleID;

-- View the timesheet entries

SELECT te.UserID,u.UserName, te.ProjectName, pm.ManagerName, te.WeekNumber,
       te.WeekStartDate, te.WeekEndDate,
       te.MondayHours, te.TuesdayHours, te.WednesdayHours, te.ThursdayHours, te.FridayHours
FROM TimesheetEntries te
JOIN Users u ON te.UserID = u.UserID
JOIN ProjectManagers pm ON te.ManagerID = pm.ManagerID;