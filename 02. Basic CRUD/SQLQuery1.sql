-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT * FROM Departments

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT d.Name FROM Departments AS d

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, e.Salary FROM Employees AS e

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.MiddleName, e.LastName FROM Employees AS e

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName + '.' + e.LastName + '@softuni.bg' AS [Full Email Address] FROM Employees AS e

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT e.Salary FROM Employees AS e

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Employees AS e
WHERE e.JobTitle = 'Sales Representative'

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, e.JobTitle FROM Employees AS e
WHERE e.Salary BETWEEN 20000 AND 30000

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName + ' ' + e.MiddleName + ' ' + e.LastName AS [Full Name] FROM Employees AS e
WHERE e.Salary IN (25000, 14000, 12500, 23600)

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE e.ManagerID IS NULL

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, e.Salary FROM Employees AS e
WHERE e.Salary > 50000
ORDER BY e.Salary DESC 

-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(5) e.FirstName, e.LastName FROM Employees AS e
ORDER BY e.Salary DESC

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName FROM Employees AS e
WHERE e.DepartmentID <> 4

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Employees AS e
ORDER BY e.Salary DESC, e.FirstName ASC, e.LastName DESC

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE VIEW v_EmployeesSalaries AS
SELECT e.FirstName, e.LastName, e.Salary FROM Employees AS e

GO

SELECT * FROM v_EmployeesSalaries

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GO
 
CREATE VIEW V_EmployeeNameJobTitle AS
SELECT CONCAT(e.FirstName, ' ', e.MiddleName, ' ' ,e.LastName) AS [Full Name], e.JobTitle AS [Job Title] FROM Employees AS e

GO
--SELECT e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '')  + e.LastName AS [Full Name], e.JobTitle AS [Job Title] FROM Employees AS e
SELECT * FROM V_EmployeeNameJobTitle

-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT e.JobTitle FROM Employees AS e

-- 19 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(10) * FROM Projects as p
ORDER BY p.StartDate ASC, p.Name ASC

-- 20 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(7) e.FirstName, e.LastName, e.HireDate FROM Employees AS e
ORDER BY e.HireDate DESC

-- 21 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USE SoftUni
BACKUP DATABASE SoftUni TO DISK = 'D:\backup.bac'

UPDATE Employees
SET Salary += Salary * 0.12
WHERE DepartmentID IN (1, 2, 4, 11)

SELECT e.Salary FROM Employees AS e

USE master
RESTORE DATABASE SoftUni FROM DISK = 'D:\backup.bac'

-- 22 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USE Geography

SELECT p.PeakName FROM Peaks AS p
ORDER BY p.PeakName ASC

-- 22 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(30) c.CountryName, c.[Population] FROM Countries AS c
WHERE c.ContinentCode IN ('EU')
ORDER BY c.[Population] DESC, c.CountryName ASC

-- 23 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.CountryName, c.CountryCode, 
CASE
	WHEN c.CurrencyCode IN ('EUR') THEN 'Euro'
	WHEN c.CurrencyCode != 'EUR' THEN 'Not Euro'
	WHEN c.CurrencyCode IS NULL THEN 'Not Euro'
END
	AS [Currency] FROM Countries AS c
ORDER BY c.CountryName ASC 

-- 24 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

USE Diablo

SELECT c.Name FROM Characters AS c
ORDER BY c.Name ASC