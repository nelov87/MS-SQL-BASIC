-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE e.FirstName LIKE 'SA%'

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE e.LastName LIKE '%ei%'

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName FROM Employees AS e
WHERE e.DepartmentID IN (3, 10) AND DATEPART(YEAR ,e.HireDate) >= 1995 AND DATEPART(YEAR ,e.HireDate) <= 2005

SELECT e.FirstName FROM Employees AS e
WHERE e.DepartmentID IN (3, 10) AND DATEPART(YEAR ,e.HireDate) BETWEEN 1995 AND 2005

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE e.JobTitle NOT LIKE '%engineer%'

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT t.[Name] FROM Towns AS t
WHERE LEN(t.[Name]) IN (5,6)
ORDER BY t.[Name] ASC

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Towns AS t
WHERE SUBSTRING(t.[Name], 1,1) IN ('m', 'k', 'b', 'e')
ORDER BY t.[Name] ASC

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Towns AS t
WHERE SUBSTRING(t.[Name], 1,1) NOT IN ('r', 'b', 'd')
ORDER BY t.[Name] ASC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE DATEPART(YEAR, e.HireDate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE LEN(e.LastName) = 5

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY [EmployeeID]) AS Rank 
FROM Employees AS e
WHERE e.Salary BETWEEN 10000 AND 50000
ORDER BY e.Salary DESC

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM (SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY [EmployeeID]) AS Rank 
FROM Employees AS e) AS r
WHERE r.Salary BETWEEN 10000 AND 50000 AND Rank = 2
ORDER BY r.Salary DESC

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.CountryName, c.IsoCode FROM Countries AS c
WHERE c.CountryName LIKE '%a%a%a%'
ORDER BY c.IsoCode

-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT PeakName, RiverName, LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName))) FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY PeakName, RiverName

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd', 'bg-BG') AS [Start] FROM Games
WHERE DATEPART(YEAR ,[Start]) BETWEEN 2011 AND 2012
ORDER BY [Start]ASC, [Name]ASC

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email, 1) + 1, LEN(Email)) AS [Email Provider] FROM Users
ORDER BY [Email Provider], Username

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___[.]1%[.]___'
ORDER BY Username

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT [Name],
CASE 
	WHEN (DATEPART(HOUR ,[Start]) >= 0 AND DATEPART(HOUR ,[Start]) < 12) THEN 'Morning'
	WHEN (DATEPART(HOUR ,[Start]) >= 12 AND DATEPART(HOUR ,[Start]) < 18) THEN 'Afternoon'
	WHEN (DATEPART(HOUR ,[Start]) >= 18 AND DATEPART(HOUR ,[Start]) < 24) THEN 'Evening'
END
 AS [Part of the Day],
 CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'
END
	AS Duration FROM Games
ORDER BY [Name] ASC, Duration ASC, [Part of the Day] ASC

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT ProductName, OrderDate,
DATEADD(DAY, 3, Orderdate) AS [Pay Due],
DATEADD(MONTH, 1, Orderdate) AS [Deliver Due]


 FROM Orders