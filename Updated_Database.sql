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


-- Creating the table named Roles containing all the role names --

CREATE TABLE Roles (
   RoleID INT IDENTITY(1,1) PRIMARY KEY,
   RoleName VARCHAR(50) NOT NULL,
   CONSTRAINT unique_role UNIQUE (RoleName)
);

-- Creating the table named Projects containing all the project names -- 

CREATE TABLE Projects (
   ProjectID INT IDENTITY(1,1) PRIMARY KEY,
   ProjectName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_projects_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Creating the table named Users containing all the Users --

CREATE TABLE Users (
   UserID INT IDENTITY(1,1) PRIMARY KEY,
   FirstName VARCHAR(50) NOT NULL,
   LastName VARCHAR(50) NOT NULL,
   CompanyID INT NOT NULL,
   CONSTRAINT fk_users_companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Creating the table named UserCredentials containing the credentials for login -- 

CREATE TABLE UserCredentials (
    UserCredentialID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    UserName VARCHAR(255) NOT NULL,
    PassCode VARCHAR(255) NOT NULL,
    CONSTRAINT fk_UserCredentials_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Creating the table named Office 

CREATE TABLE Office (
   OfficeID INT IDENTITY(1,1) PRIMARY KEY,
   OfficeName VARCHAR(50) NOT NULL
);

-- Creating the table named Department containing the different departments --

CREATE TABLE Department (
   DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
   DepartmentName VARCHAR(50) NOT NULL
);

-- Creating the table named ProjectManagers containg all the project managers linked with a project --

CREATE TABLE ProjectManagers (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    ManagerName VARCHAR(100) NOT NULL,
    CONSTRAINT unique_ProjectManager UNIQUE (ProjectID),
    CONSTRAINT fk_ProjectManagers_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

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

-- Creating Link table named UserProjectLink that creates a link between the users and the projects that are linked to the user --

CREATE TABLE UserProjectLink (
   UserProjectLinkID INT IDENTITY(1,1) PRIMARY KEY,
   UserID INT NOT NULL,
   ProjectID INT NOT NULL,
   CONSTRAINT fk_UserProjectLink_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
   CONSTRAINT fk_UserProjectLink_Projects FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
   CONSTRAINT unique_UserProjectLink UNIQUE (UserID, ProjectID)
);


