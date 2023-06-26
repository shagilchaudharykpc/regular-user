-- second test with sample values added.
-- Insert values into Companies table
INSERT INTO Companies (CompanyName)
VALUES ('Boston Scientific');

-- Insert values into Projects table, referencing Companies table
INSERT INTO Projects (ProjectName, CompanyID)
VALUES ('Boston Scientific', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Boston Scientific'));

-- Insert values into Users table, referencing Companies table
INSERT INTO Users (FirstName, LastName, CompanyID)
VALUES ('Edem', 'Ironbar', (SELECT CompanyID FROM Companies WHERE CompanyName = 'Boston Scientific'));

-- Insert values into UserCredentials table
INSERT INTO UserCredentials (UserID, UserName, PassCode)
VALUES (@UserID, CONCAT('Edem', ' ', 'Ironbar'), CONVERT(varchar(255), NEWID()));

-- Insert values into UserProjectRoles table
INSERT INTO UserProjectRoles (UserID, ProjectID, RoleID)
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Edem' AND LastName = 'Ironbar'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Boston Scientific'),
        (SELECT RoleID FROM Roles WHERE RoleName = 'Project Manager'));

-- Insert values into ProjectManagers table
INSERT INTO ProjectManagers (ProjectID, ManagerName)
VALUES ((SELECT ProjectID FROM Projects WHERE ProjectName = 'Boston Scientific'),
        (SELECT CONCAT(FirstName, ' ', LastName) FROM Users WHERE FirstName = 'Edem' AND LastName = 'Ironbar'));

-- Insert values into UserProjectManager table
INSERT INTO UserProjectManager (UserID, ProjectID, ProjectManagerID)
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Edem' AND LastName = 'Ironbar'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Boston Scientific'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Boston Scientific')));

--test three

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

--test four

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
INSERT INTO UserProjects (UserID, ProjectID, RoleID)
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

-- Insert values into UserProjectRoles table
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
VALUES ((SELECT UserID FROM Users WHERE FirstName = 'Ed' AND LastName = 'Storan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Cleaning validation MFG6'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Tony' AND LastName = 'Calnan'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG7'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Orla' AND LastName = 'Barber'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Sanofi Frankfurt'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Elva' AND LastName = 'O''Conaire'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Seres Therapeutics'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Siobhan' AND LastName = 'Wallace'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Wuppertal/Aprath'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Bernadette' AND LastName = 'Keohane'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'MFG19'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Cormac' AND LastName = 'Ring'),
        (SELECT ProjectID FROM Projects WHERE ProjectName ='WuXi Dundalk MFG7'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'WuXi Dundalk MFG7'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Louis' AND LastName = 'Tate'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Tech Transfer'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Aoife' AND LastName = 'Anderson'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Multiple'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Betina' AND LastName = 'Fossati'),
        (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'),
        (SELECT ManagerID FROM ProjectManagers WHERE ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Innovation Team'))),
       ((SELECT UserID FROM Users WHERE FirstName = 'Brian' AND LastName = 'O''Connell'),
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

-- Timesheet entry for Alicja Zagozdzon
INSERT INTO TimesheetEntries (UserID, ProjectName, ManagerID, WeekNumber, WeekStartDate, WeekEndDate, MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
VALUES (
    (SELECT UserID FROM Users WHERE FirstName = 'Alicja' AND LastName = 'Zagozdzon'),
    'WuXi',
    (SELECT ProjectManagerID FROM UserProjectManager WHERE UserID = (SELECT UserID FROM Users WHERE FirstName = 'Alicja' AND LastName = 'Zagozdzon') AND ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Zagozdzon')),
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