CREATE DATABASE timesheet2
GO
USE [timesheet2]
GO

CREATE TABLE Companies (
   CompanyID INT IDENTITY(1,1) PRIMARY KEY,
   CompanyName VARCHAR(50) NOT NULL,
   CONSTRAINT unique_company UNIQUE (CompanyName)
);


CREATE TABLE Roles (
   RoleID INT IDENTITY(1,1) PRIMARY KEY,
   RoleName VARCHAR(50) NOT NULL,
   CONSTRAINT unique_role UNIQUE (RoleName)
);


CREATE TABLE Projects (
   ProjectID INT IDENTITY(1,1) PRIMARY KEY,
   ProjectName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_projects_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);


CREATE TABLE Users (
   UserID INT IDENTITY(1,1) PRIMARY KEY,
   FirstName VARCHAR(50) NOT NULL,
   LastName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_users_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

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


CREATE TABLE UserCredentials (
    UserCredentialID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    UserName VARCHAR(255) NOT NULL,
    PassCode VARCHAR(255) NOT NULL,
    CONSTRAINT fk_UserCredentials_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Office (
   OfficeID INT IDENTITY(1,1) PRIMARY KEY,
   OfficeName VARCHAR(50) NOT NULL
);

CREATE TABLE Department (
   DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
   DepartmentName VARCHAR(50) NOT NULL
);

-- Create the ProjectManagers table
CREATE TABLE ProjectManagers (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    ManagerName VARCHAR(100) NOT NULL,
    CONSTRAINT unique_ProjectManager UNIQUE (ProjectID),
    CONSTRAINT fk_ProjectManagers_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

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


-- Insert values into Companies table
INSERT INTO Companies (CompanyName)
VALUES ('KPC'), ('XYZ Company'), ('123 Company');


-- Insert values into Roles table
INSERT INTO Roles (RoleName)
VALUES ('Regular User'), ('Project Manager'), ('Admin'), ('Supervisor');


-- Insert values into Projects table, referencing Companies table
INSERT INTO Projects (ProjectName, CompanyID)
VALUES ('NuaVal', 1), ('Timesheet', 1), ('WUXI', 2);


-- Insert values into Users table, referencing Companies table
INSERT INTO Users (FirstName, LastName, CompanyID)
VALUES ('Daniel', 'Devlin', 1), ('Shagil', 'Chaudhary', 1), ('Mick', 'O''Gorman', 2), ('John', 'Devlin', 3);


-- Insert values into UserProjectsRoles table, referencing Users, Projects and Roles tables
INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Daniel' AND LastName = 'Devlin'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'NuaVal'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Daniel' AND LastName = 'Devlin'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'Timesheet'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Shagil' AND LastName = 'Chaudhary'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'NuaVal'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Shagil' AND LastName = 'Chaudhary'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'Timesheet'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Mick' AND LastName = 'O''Gorman'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'NuaVal'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Mick' AND LastName = 'O''Gorman'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'Timesheet'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),
      ((SELECT UserID FROM Users WHERE FirstName = 'Mick' AND LastName = 'O''Gorman'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'WUXI'), (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
      ((SELECT UserID FROM Users WHERE FirstName = 'John' AND LastName = 'Devlin'), (SELECT ProjectID FROM Projects WHERE ProjectName = 'Timesheet'), (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager'));

INSERT INTO UserCredentials (UserID, UserName, PassCode)
SELECT UserID, CONCAT(FirstName, ' ', LastName) AS UserName, CONVERT(varchar(255), NEWID()) AS PassCode
FROM Users;

INSERT INTO office (OfficeName)
VALUES ('Ireland Staff'), ('Ireland Contractor'), ('UK Staff'), ('UK Contractors'), ('Germany Staff'), ('Germany Contractors');

INSERT INTO Department (DepartmentName)
VALUES ('Engineering'), ('Tech Transfer'), ('Recruitment'), ('Finance');

-- Insert data into ProjectManagers table
INSERT INTO ProjectManagers (ProjectID, ManagerName)
SELECT upr.ProjectID, CONCAT(u.FirstName, ' ', u.LastName) AS ManagerName
FROM UserProjectRoles upr
JOIN Users u ON u.UserID = upr.UserID
WHERE upr.RoleID = 2;

INSERT INTO UserProjectManager (UserID, ProjectID, ProjectManagerID)
SELECT upr.UserID, upr.ProjectID, pm.ManagerID
FROM UserProjectRoles upr
JOIN ProjectManagers pm ON pm.ProjectID = upr.ProjectID
WHERE upr.RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User');

-- Insert value into Users table
INSERT INTO Users (FirstName, LastName, CompanyID)
VALUES ('Gerry', 'James', (SELECT CompanyID FROM Companies WHERE CompanyName = 'XYZ Company'));

-- Get the UserID for the newly inserted user
DECLARE @UserID INT;
SET @UserID = SCOPE_IDENTITY();

-- Insert value into UserCredentials table
INSERT INTO UserCredentials (UserID, UserName, PassCode)
VALUES (@UserID, CONCAT('Gerry', ' ', 'James'), CONVERT(varchar(255), NEWID()));

-- Insert value into UserProjectRoles table
INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES (@UserID, (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi'), (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User'));

-- Insert value into UserProjectManager table
INSERT INTO UserProjectManager (UserID, ProjectID, ProjectManagerID)
VALUES (@UserID, (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi'), (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi')));


SELECT u.FirstName AS 'User First Name', u.LastName AS 'User Last Name',
   c.CompanyName AS 'Company Name', p.ProjectName, r.RoleName
FROM Users u
JOIN Companies c ON u.CompanyID = c.CompanyID
JOIN UserProjectRoles upr ON u.UserID = upr.UserID
JOIN Projects p ON upr.ProjectID = p.ProjectID
JOIN Roles r ON upr.RoleID = r.RoleID;


-- timesheet testing
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

INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE FirstName = 'Gerry' AND LastName = 'James'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Gerry' AND LastName = 'James') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);

-- Insert values into Companies table
INSERT INTO Companies (CompanyName)
VALUES ('Cleaning validation MFG6'), ('MFG7'), ('Sanofi Frankfurt'), ('Seres Therapeutics'),
       ('Wuppertal/Aprath'), ('MFG19'), ('WuXi Dundalk MFG7'), ('Tech Transfer'), ('Multiple'),
       ('Innovation Team'), ('Office');

-- Insert values into Projects table, referencing Companies table
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


-- Insert values into Users table, referencing Companies table
INSERT INTO Users (FirstName, LastName, CompanyID)
VALUES
  ('Edem', 'Iron', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Cleaning validation MFG6')),
  ('Ismail', 'Bin On', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG7')),
  ('Aisling', 'Noonan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Sanofi Frankfurt')),
  ('Alicja', 'Zagozdzon', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Seres Therapeutics')),
  ('Declan', 'O''Riordan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Wuppertal/Aprath')),
  ('Dylan', 'Leslie', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG19')),
  ('Eoin', 'Reilly', (SELECT CompanyID FROM Companies WHERE CompanyName = 'WuXi Dundalk MFG7')),
  ('Kevin', 'Foley', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Tech Transfer')),
  ('Kevin', 'Sexton', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Multiple')),
  ('Leah', 'Dillon', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Innovation Team')),
  ('Mudiaga', 'Gberevbie', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Office'))

-- Insert values into UserCredentials table for each user
INSERT INTO UserCredentials (UserID, UserName, PassCode)
SELECT u.UserID, CONCAT(u.FirstName, ' ', u.LastName), CONVERT(varchar(255), NEWID())
FROM Users u
JOIN Companies c ON u.CompanyID = c.CompanyID
WHERE c.CompanyName IN ('Cleaning validation MFG6', 'MFG7', 'Sanofi Frankfurt', 'Seres Therapeutics', 'Wuppertal/Aprath', 'MFG19', 'WuXi Dundalk MFG7', 'Tech Transfer', 'Multiple', 'Innovation Team', 'Office');

-- Insert values into UserProjectRoles table
INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES
  ((SELECT UserID FROM Users WHERE FirstName = 'Edem' AND LastName = 'Iron'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Ismail' AND LastName = 'Bin On'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Aisling' AND LastName = 'Noonan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Alicja' AND LastName = 'Zagozdzon'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Declan' AND LastName = 'O''Riordan'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Dylan' AND LastName = 'Leslie'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Eoin' AND LastName = 'Reilly'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Kevin' AND LastName = 'Foley'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Kevin' AND LastName = 'Sexton'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Leah' AND LastName = 'Dillon'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User')),

  ((SELECT UserID FROM Users WHERE FirstName = 'Mudiaga' AND LastName = 'Gberevbie'),
  (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
  (SELECT RoleID FROM Roles WHERE RoleName = 'Regular User'))


INSERT INTO Users (FirstName, LastName, CompanyID)
VALUES ('Ed', 'Storan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Cleaning validation MFG6')),
       ('Tony', 'Calnan', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG7')),
       ('Orla', 'Barber', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Sanofi Frankfurt')),
       ('Elva', 'O''Conaire', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Seres Therapeutics')),
       ('Siobhan', 'Wallace', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Wuppertal/Aprath')),
       ('Bernadette', 'Keohane', (SELECT CompanyID FROM Companies WHERE CompanyName = 'MFG19')),
       ('Cormac', 'Ring', (SELECT CompanyID FROM Companies WHERE CompanyName = 'WuXi Dundalk MFG7')),
       ('Louis', 'Tate', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Tech Transfer')),
       ('Aoife', 'Anderson', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Multiple')),
       ('Betina', 'Fossati', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Innovation Team')),
       ('Brian', 'O''Connell', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Office'));

-- Insert values into UserCredentials table
INSERT INTO UserCredentials (UserID, UserName, PassCode)
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Ed' AND LastName = 'Storan'),
        CONCAT('Ed', ' ', 'Storan'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Tony' AND LastName = 'Calnan'),
        CONCAT('Tony', ' ', 'Calnan'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Orla' AND LastName = 'Barber'),
        CONCAT('Orla', ' ', 'Barber'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Elva' AND LastName = 'O''Conaire'),
        CONCAT('Elva', ' ', 'O''Conaire'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Siobhan' AND LastName = 'Wallace'),
        CONCAT('Siobhan', ' ', 'Wallace'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Bernadette' AND LastName = 'Keohane'),
        CONCAT('Bernadette', ' ', 'Keohane'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Cormac' AND LastName = 'Ring'),
        CONCAT('Cormac', ' ', 'Ring'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Louis' AND LastName = 'Tate'),
        CONCAT('Louis', ' ', 'Tate'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Aoife' AND LastName = 'Anderson'),
        CONCAT('Aoife', ' ', 'Anderson'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Betina' AND LastName = 'Fossati'),
        CONCAT('Betina', ' ', 'Fossati'), CONVERT(varchar(255), NEWID())),
       ((SELECT UserID FROM Users WHERE FirstName = 'Brian' AND LastName = 'O''Connell'),
        CONCAT('Brian', ' ', 'O''Connell'), CONVERT(varchar(255), NEWID()));

-- Insert values into UserProjects table
INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES ((SELECT

 UserID FROM Users WHERE FirstName = 'Ed' AND LastName = 'Storan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Tony' AND LastName = 'Calnan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Orla' AND LastName = 'Barber'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Elva' AND LastName = 'O''Conaire'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Siobhan' AND LastName = 'Wallace'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Bernadette' AND LastName = 'Keohane'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Cormac' AND LastName = 'Ring'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Louis' AND LastName = 'Tate'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Aoife' AND LastName = 'Anderson'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Betina' AND LastName = 'Fossati'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager')),
       ((SELECT UserID FROM Users WHERE FirstName = 'Brian' AND LastName = 'O''Connell'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager'));

-- Insert values into ProjectManagers table
INSERT INTO ProjectManagers (ProjectID, ManagerName)
VALUES ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Ed' AND LastName = 'Storan')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Tony' AND LastName = 'Calnan')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Orla' AND LastName = 'Barber')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Elva' AND LastName = 'O''Conaire')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Siobhan' AND LastName = 'Wallace')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Bernadette' AND LastName = 'Keohane')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Cormac' AND LastName = 'Ring')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Louis' AND LastName = 'Tate')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Aoife' AND LastName = 'Anderson')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Betina' AND LastName = 'Fossati')),
       ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Brian' AND LastName = 'O''Connell'));

-- Insert values into UserProjectManager table
INSERT INTO UserProjectManager (UserID, ProjectID, ProjectManagerID)
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Edem' AND LastName = 'Iron'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Ismail' AND LastName = 'Bin On'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Aisling' AND LastName = 'Noonan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Alicja' AND LastName = 'Zagozdzon'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Declan' AND LastName = 'O''Riordan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Dylan' AND LastName = 'Leslie'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Eoin' AND LastName = 'Reilly'),
        (SELECT ProjectID FROM Projects WHERE ProjectName ='WuXi Dundalk MFG7'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Kevin' AND LastName = 'Foley'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Kevin' AND LastName = 'Sexton'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Leah' AND LastName = 'Dillon'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Mudiaga' AND LastName = 'Gberevbie'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Office')));


-- test timesheet entries

-- Timesheet entry for Ismail Bin On
INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE FirstName = 'Ismail' AND LastName = 'Bin On'),
    'MFG7',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Ismail' AND LastName = 'Bin On') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);

INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE FirstName = 'Gerry' AND LastName = 'James'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Gerry' AND LastName = 'James') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi')),
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
    (SELECT UserID FROM Users WHERE FirstName = 'Aisling' AND LastName = 'Noonan'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Aisling' AND LastName = 'Noonan') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);


-- Timesheet entry for Declan O'Riordan
INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE FirstName = 'Declan' AND LastName = 'O''Riordan'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Declan' AND LastName = 'O''Riordan') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath')),
    (SELECT (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1), -- Calculate the week number based on January 1 every year
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7), '2023-01-01')), -- Calculate the start date of the week
    (SELECT DATEADD(WEEK, (DATEDIFF(DAY, '2023-01-01', GETDATE()) / 7) + 1, '2023-01-01')), -- Calculate the end date of the week
    8, -- Monday hours
    8, -- Tuesday hours
    8, -- Wednesday hours
    8, -- Thursday hours
    8  -- Friday hours
);

---END TEST

SELECT * FROM TimesheetEntries
-- view the created timesheet
SELECT te.UserID,u.FirstName, te.ProjectName, pm.ManagerName, te.WeekNumber,
       te.WeekStartDate, te.WeekEndDate,
       te.MondayHours, te.TuesdayHours, te.WednesdayHours, te.ThursdayHours, te.FridayHours
FROM TimesheetEntries te
JOIN Users u ON te.UserID = u.UserID
JOIN ProjectManagers pm ON te.ManagerID = pm.ManagerID;


SELECT * FROM UserProjectRoles
SELECT (u.FirstName + ' ' + u.LastName) AS 'Username',
       c.CompanyName AS 'Company Name',
       p.ProjectName,
       r.RoleName
FROM Users u
JOIN Companies c ON u.CompanyID = c.CompanyID
JOIN UserProjectRoles upr ON u.UserID = upr.UserID
JOIN Projects p ON upr.ProjectID = p.ProjectID
JOIN Roles r ON upr.RoleID = r.RoleID;

CREATE TABLE UserProjectLink (
   UserProjectLinkID INT IDENTITY(1,1) PRIMARY KEY,
   UserID INT NOT NULL,
   ProjectID INT NOT NULL,
   CONSTRAINT fk_UserProjectLink_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
   CONSTRAINT fk_UserProjectLink_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
   CONSTRAINT unique_UserProjectLink UNIQUE (UserID, ProjectID)
);

-- Add columns for UserName and ProjectName
ALTER TABLE UserProjectLink
ADD UserName NVARCHAR(100),
    ProjectName NVARCHAR(100);

-- Update the UserName and ProjectName columns
UPDATE UserProjectLink
SET UserName = CONCAT(Users.FirstName, ' ', Users.LastName),
    ProjectName = Projects.ProjectName
FROM UserProjectLink
JOIN Users ON Users.UserID = UserProjectLink.UserID
JOIN Projects ON Projects.ProjectID = UserProjectLink.ProjectID;

INSERT INTO UserProjectLink (UserName, ProjectName)
SELECT CONCAT(Users.FirstName, ' ', Users.LastName), Projects.ProjectName
FROM Users
JOIN UserProjectLink ON Users.UserID = UserProjectLink.UserID
JOIN Projects ON Projects.ProjectID = UserProjectLink.ProjectID
WHERE CONCAT(Users.FirstName, ' ', Users.LastName, Projects.ProjectName) NOT IN (
    SELECT CONCAT(UserName, ProjectName)
    FROM UserProjectLink
);



SELECT * FROM UserProjectLink
drop database timesheet2
SELECT * FROM Users

-- Insert values into UserProjectLink table for all existing users
INSERT INTO UserProjectLink (UserID, ProjectID)
SELECT u.UserID, p.ProjectID
FROM Users u
CROSS JOIN Projects p;

