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

SELECT Source.EmployeeID, Source.FirstName FROM (SELECT DISTINCT * FROM Employees AS e
	FULL OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID) AS Source
--WHERE e.EmployeeID NOT IN (ep.EmployeeID)

