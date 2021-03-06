-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT COUNT(*) AS [Count] FROM WizzardDeposits

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT MAX(w.MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits AS w

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, MAX(w.MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits AS w
GROUP BY w.DepositGroup


-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(2) DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, SUM(w.DepositAmount) FROM WizzardDeposits AS w
GROUP BY w.DepositGroup

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, SUM(w.DepositAmount) FROM WizzardDeposits AS w
WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, SUM(w.DepositAmount) FROM WizzardDeposits AS w
WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup
HAVING SUM(w.DepositAmount) < 150000
ORDER BY SUM(w.DepositAmount) DESC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, w.MagicWandCreator, MIN(w.DepositCharge) FROM WizzardDeposits AS w
GROUP BY w.DepositGroup, w.MagicWandCreator
ORDER BY w.MagicWandCreator, w.DepositGroup

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT 
	AgeGroup.AgeGroup,
	COUNT(*)
FROM 
	(
	SELECT 
		CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age >= 61 THEN '[61+]'
		END
	AS
		AgeGroup 
	FROM 
		WizzardDeposits 
	AS w
	) 
AS 
	AgeGroup
GROUP BY AgeGroup.AgeGroup


-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT SUBSTRING(w.FirstName, 1, 1) AS fl FROM WizzardDeposits AS w
WHERE w.DepositGroup = 'Troll Chest'
GROUP BY SUBSTRING(w.FirstName, 1, 1)
ORDER BY fl

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT w.DepositGroup, w.IsDepositExpired, AVG(w.DepositInterest) AS [AverageInterest] FROM WizzardDeposits AS w
WHERE 
	DATEPART(YEAR, w.DepositStartDate) >= 1985 
AND 
	DATEPART(MONTH, w.DepositStartDate) >= 01 
AND
	DATEPART(DAY, w.DepositStartDate) >= 01
GROUP BY w.DepositGroup, w.IsDepositExpired
ORDER BY w.DepositGroup DESC, w.IsDepositExpired ASC

-- OR =============================================================================

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE DepositStartDate > '1985/01/01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.DepartmentID, SUM(e.Salary) FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID ASC

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.DepartmentID, MIN(e.Salary) FROM Employees AS e
WHERE e.HireDate > '01/01/2000' AND e.DepartmentID IN (2, 5, 7)
GROUP BY e.DepartmentID

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * INTO NewEmployees FROM Employees AS e
WHERE e.Salary > 30000

DELETE FROM NewEmployees
WHERE ManagerID = 42

UPDATE NewEmployees
SET Salary += 5000
WHERE DepartmentID = 1

SELECT ne.DepartmentID, AVG(ne.Salary) FROM NewEmployees AS ne
GROUP BY ne.DepartmentID

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.DepartmentID, MAX(e.Salary) FROM Employees AS e
GROUP BY e.DepartmentID
HAVING MAX(e.Salary) < 30000 OR MAX(e.Salary) > 70000

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT COUNT(e.Salary) FROM Employees AS e
GROUP BY ManagerID
HAVING ManagerID IS NULL

-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT
	Ranked.DepartmentID, Ranked.Salary
FROM
(SELECT e.DepartmentID, Salary, 
	DENSE_RANK() 
	OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) 
	AS [Rank] 
	FROM Employees 
	AS e) AS [Ranked]
WHERE Ranked.[Rank] = 3

-- 19 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT FirstName, LastName, DepartmentID FROM (SELECT e.DepartmentID,  FROM Employees AS e)
WHERE Salary 




SELECT 'd' AS dd, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16] FROM (SELECT DepartmentID, Salary FROM Employees AS src) AS e
PIVOT(
	SUM(e.Salary)
	FOR DepartmentID IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16])
) AS PivotTable

