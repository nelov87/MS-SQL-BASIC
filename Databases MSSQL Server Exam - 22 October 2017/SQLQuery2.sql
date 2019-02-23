-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


CREATE TABLE Users
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Username NVARCHAR(30) NOT NULL UNIQUE,
[Password] NVARCHAR(50) NOT NULL,
[Name] NVARCHAR(50),
Gender CHAR(1) CHECK(Gender = 'M' OR Gender = 'F') NOT NULL,
BirthDate DATETIME,
Age INT,
Email NVARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
Id INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(25),
LastName NVARCHAR(25),
Gender CHAR(1) CHECK(Gender = 'M' OR Gender = 'F') NOT NULL,
BirthDate DATETIME,
Age INT,
DepartmentId INT FOREIGN KEY REFERENCES Departments (Id) NOT NULL
)

CREATE TABLE Categories
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments (Id) NOT NULL
)

CREATE TABLE [Status]
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Label NVARCHAR(30) NOT NULL
)

CREATE TABLE Reports
(
Id INT IDENTITY(1,1) PRIMARY KEY,
CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
StatusId INT NOT NULL FOREIGN KEY REFERENCES [Status](Id),
OpenDate DATETIME NOT NULL,
CloseDate DATETIME,
[Description] NVARCHAR(200),
UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO Employees (FirstName, LastName, Gender, Birthdate, DepartmentId)
VALUES 
('Marlo', 'O’Malley', 'M', '9/21/1958', 1),
('Niki', 'Stanaghan', 'F', '11/26/1969', 4),
('Ayrton', 'Senna', 'M', '03/21/1960', 9),
('Ronnie', 'Peterson', 'M', '02/14/1944', 9),
('Giovanna', 'Amati', 'F', '07/20/1959', 5)

INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
VALUES
(1, 1, '04/13/2017', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '09/05/2015', '12/06/2015', 'Charity trail running', 3, 5),
(14, 2, '09/07/2015', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '07/03/2017', '07/06/2017', 'Cut off streetlight on Str.11', 1, 1)


-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UPDATE Reports 
SET StatusId = 2
WHERE StatusId = 1 AND CategoryId = 4

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DELETE FROM Reports
WHERE StatusId = 4

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT u.Username, u.Age FROM Users AS u
ORDER BY u.Age ASC, u.Username DESC

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT r.[Description], r.OpenDate FROM Reports AS r
WHERE EmployeeId IS NULL
ORDER BY r.OpenDate ASC, r.[Description] ASC

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, r.[Description], FORMAT(r.OpenDate, 'yyyy-MM-dd ') FROM Employees AS e
JOIN Reports AS r ON e.Id = r.EmployeeId
ORDER BY e.Id ASC, r.OpenDate ASC, r.Id ASC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SELECT c.[Name], COUNT(r.CategoryId) AS [ReportsNumber] FROM Reports AS r
JOIN Categories AS c ON r.CategoryId = c.Id
GROUP BY c.[Name]
ORDER BY COUNT(r.CategoryId) DESC, c.[Name] ASC

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SELECT c.[Name] AS [CategoryName], COUNT(e.Id) AS [Employees Number] FROM Employees AS e
JOIN Departments AS d ON d.Id = e.DepartmentId
JOIN Categories AS c ON c.DepartmentId = d.Id
GROUP BY c.[Name]
ORDER BY c.[Name]


-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT e.FirstName + ' ' + e.LastName AS [Name], COUNT(r.UserId) AS [Users Number] FROM Employees AS e
LEFT OUTER JOIN Reports AS r ON r.EmployeeId = e.Id
GROUP BY e.FirstName, e.LastName
ORDER BY [Users Number] DESC, [Name]ASC


-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT r.OpenDate, r.Description, u.Email FROM Reports AS r
JOIN Categories AS c ON r.CategoryId = c.Id
JOIN Users AS u ON r.UserId = u.Id
WHERE r.CloseDate IS NULL AND LEN(r.Description) > 20 AND CHARINDEX('str', r.Description) > 0 AND c.DepartmentId IN (1, 4, 5)
ORDER BY r.OpenDate ASC, u.Email ASC, u.Id ASC

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT c.[Name] FROM Reports AS r
JOIN Users AS u ON r.UserId = u.Id
JOIN Categories AS c ON r.CategoryId = c.Id
WHERE CONCAT(DATEPART(MONTH, r.OpenDate), '-',DATEPART(DAY, r.OpenDate)) = CONCAT(DATEPART(MONTH, u.BirthDate), '-', DATEPART(DAY, u.BirthDate))


-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT u.Username FROM Users AS u
JOIN Reports AS r ON r.UserId = u.Id
WHERE SUBSTRING(Username, 1, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') 
				AND
				CONCAT(r.CategoryId, '') = SUBSTRING(Username, 1, 1)
		OR
		SUBSTRING(Username, LEN(Username), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
				AND
				CONCAT(r.CategoryId, '') = SUBSTRING(Username, LEN(Username), 1)
ORDER BY u.Username ASC


-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT CONCAT(e.FirstName, ' ', e.LastName) AS [Name], CONCAT(COUNT(r.CloseDate), '/', COUNT(r.OpenDate)) FROM Employees AS e
JOIN Reports AS r ON e.Id = r.EmployeeId
WHERE DATEPART(YEAR, r.OpenDate) = 2016 OR DATEPART(YEAR, r.CloseDate) = 2016
GROUP BY e.FirstName, e.LastName, e.Id
ORDER BY [Name] ASC, e.Id 

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.[Name] AS [Department Name], 
CASE
	WHEN Source.[Average Duration] IS NULL THEN 'no info'
	WHEN Source.[Average Duration] IS NOT NULL THEN CONCAT(Source.[Average Duration], '')
	END
	AS [Average Duration]

 FROM (SELECT d.[Name], AVG(DATEDIFF(DAY, r.OpenDate, r.CloseDate)) AS [Average Duration] FROM Departments AS d
			LEFT OUTER JOIN Categories AS c ON d.Id = c.DepartmentId
			JOIN Reports AS r ON c.Id = r.CategoryId
			GROUP BY d.[Name]
			) AS Source
ORDER BY Source.[Name]

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

WITH CTE_TotalReportsByDepartment (DepartmentId, Count) AS
(
	SELECT d.Id, COUNT(r.Id) FROM Departments AS d
	JOIN Categories AS c ON d.Id = c.DepartmentId
	JOIN Reports AS r ON c.Id = r.CategoryId
	GROUP BY d.Id
)

SELECT d.Name AS [Department Name], c.Name AS [Category Name], CAST(ROUND(CEILING(CAST(COUNT(r.Id) AS DECIMAL(7,2)) * 100)/tr.Count, 0) AS INT) AS Percentage FROM Departments AS d
JOIN CTE_TotalReportsByDepartment AS tr ON d.Id = tr.DepartmentId
JOIN Categories AS c ON d.Id = c.DepartmentId
JOIN Reports AS r ON c.Id = r.CategoryId
GROUP BY d.Name, c.Name, tr.Count


-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
