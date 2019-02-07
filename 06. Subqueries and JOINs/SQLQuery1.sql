-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SELECT TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText FROM Employees AS e
INNER JOIN Addresses AS a
ON e.AddressID = a.AddressID
ORDER BY e.AddressID ASC

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(50) e.FirstName, e.LastName, t.[Name], a.AddressText FROM Employees AS e
INNER JOIN Addresses AS a
ON e.AddressID = a.AddressID
INNER JOIN Towns AS t
ON a.TownID = t.TownID
ORDER BY e.FirstName ASC, e.LastName

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] FROM Employees AS e
INNER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] IN ('Sales')
ORDER BY e.EmployeeID

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name] AS ['DepartmentName'] FROM Employees AS e
INNER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary >= 15000
ORDER BY e.DepartmentID ASC

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(3) Source.EmployeeID, Source.FirstName FROM (SELECT e.EmployeeID, e.FirstName, ep.EmployeeID AS [ProjectEmployID] FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID) AS Source
WHERE Source.ProjectEmployID IS NULL

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS [DeptName] FROM Employees AS e 
JOIN Departments AS d 
	ON e.DepartmentID = d.DepartmentID 
	AND e.HireDate >= '1999-01-01' 
	AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP (5) e.EmployeeID, e.FirstName, p.[Name] FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.EmployeeID, e.FirstName, 
CASE
	WHEN (p.StartDate >= '2005') THEN NULL ELSE (p.[Name])
	END AS [ProjectName]
FROM Employees AS e
RIGHT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
RIGHT JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = '24'

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.EmployeeID, e.FirstName, m.EmployeeID, m.FirstName AS [ManagerName] FROM Employees AS e
	JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID ASC

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(50) e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS [EmployeeName], CONCAT(m.FirstName, ' ', m.LastName) AS [ManagerName], d.[Name] AS [DepartmentName] FROM Employees AS e
	JOIN Employees AS m ON e.ManagerID = m.EmployeeID
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID ASC

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT MIN(Sorce.avgSalary) 
FROM (
	  SELECT AVG(em.Salary) AS avgSalary 
	  FROM Employees AS em 
	  GROUP BY em.DepartmentID 
	  ) 
AS Sorce

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation  FROM Countries AS c
	JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	JOIN Peaks AS p ON mc.MountainId = p.MountainId
	JOIN Mountains AS m ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG' AND p.Elevation >= 2835
ORDER BY p.Elevation DESC

-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.CountryCode, COUNT(Source.MountainRange) AS [MountainRanges] 
FROM (
	SELECT c.CountryCode, m.MountainRange FROM Countries AS c
	JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	JOIN Mountains AS m ON mc.MountainId = m.Id) AS Source
WHERE Source.CountryCode IN ('BG', 'RU', 'US')
GROUP BY Source.CountryCode

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(5) c.CountryName, r.RiverName FROM Continents AS cont
	LEFT JOIN Countries AS c ON cont.ContinentCode = c.ContinentCode
	LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE cont.ContinentCode = 'AF'
ORDER BY c.CountryName

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT ContinentCode, CurrencyCode, CurrencyUsage
FROM(
SELECT ContinentCode, CurrencyCode, CurrencyUsage,
DENSE_RANK() OVER(PARTITION BY(ContinentCode) ORDER BY CurrencyUsage DESC 
)AS [Rank]
FROM(
SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS CurrencyUsage FROM Countries 
GROUP BY CurrencyCode, ContinentCode) AS curen
) AS rankedcur
WHERE [Rank] = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT COUNT(CountryCode) AS CountryCode FROM Countries
WHERE CountryCode NOT IN (SELECT CountryCode FROM MountainsCountries )

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS [HighestPeakElevation], MAX(r.[Length]) AS [LongestRiverLength] FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT OUTER JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON m.Id = p.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY MAX(p.Elevation) DESC, MAX(r.[Length]) DESC, c.CountryName ASC


-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

WITH CTE_CountriesHighestElevation AS
(
	SELECT c.CountryName,
		CASE 
			WHEN MAX(p.Elevation) IS NULL THEN 0
			ELSE MAX(p.Elevation)
		END AS [Highest Peak Elevation] FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc
	ON mc.CountryCode = c.CountryCode
	LEFT JOIN Peaks As p
	ON p.MountainId = mc.MountainId
	GROUP BY c.CountryName
),

CTE_MountainHighestElevation AS
(
	SELECT m.Id, MAX(p.Elevation) AS mhe FROM Mountains AS m
	JOIN Peaks AS p
	ON p.MountainId = m.Id
	GROUP BY m.Id
)

SELECT TOP 5
	he.CountryName AS Country,
	CASE
		WHEN p.PeakName IS NULL THEN '(no highest peak)'
		ELSE p.PeakName
	END AS [Highest Peak Name],

	he.[Highest Peak Elevation],
	CASE
		WHEN m.MountainRange IS NULL THEN '(no mountain)'
		ELSE m.MountainRange
	END AS Mountain

FROM CTE_CountriesHighestElevation As he
JOIN Countries AS c
ON c.CountryName = he.CountryName
LEFT JOIN MountainsCountries AS mc
ON mc.CountryCode = c.CountryCode
LEFT JOIN CTE_MountainHighestElevation AS mh
ON mh.Id = mc.MountainId AND mh.mhe = [Highest Peak Elevation]
LEFT JOIN Peaks AS p
ON p.Elevation = mh.mhe
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
WHERE he.[Highest Peak Elevation] = p.Elevation OR he.[Highest Peak Elevation] = 0
ORDER BY he.CountryName
