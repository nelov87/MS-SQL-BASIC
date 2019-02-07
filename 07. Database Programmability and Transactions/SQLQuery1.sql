-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE PROC dbo.usp_GetEmployeesSalaryAbove35000
AS
	SELECT e.FirstName, e.LastName FROM Employees AS e
	WHERE e.Salary > 35000

EXEC dbo.usp_GetEmployeesSalaryAbove35000

GO
-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE PROC dbo.usp_GetEmployeesSalaryAboveNumber (@Number DECIMAL(18,4))
AS
	SELECT e.FirstName, e.LastName FROM Employees AS e
	WHERE e.Salary >= @Number

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

GO

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE PROC dbo.usp_GetTownsStartingWith (@StringPart NVARCHAR(20))
AS
	SELECT t.[Name] FROM Towns AS t
	WHERE @StringPart IN (SUBSTRING(t.[Name], 1, LEN(@StringPart)))

EXEC dbo.usp_GetTownsStartingWith 'b'

GO

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE PROC dbo.usp_GetEmployeesFromTown (@Town NVARCHAR(20))
AS
	SELECT e.FirstName, e.LastName FROM Employees AS e
		JOIN Addresses AS a ON e.AddressID = a.AddressID
		JOIN Towns AS t ON a.TownID = t.TownID
	WHERE @Town = t.[Name]

EXEC dbo.usp_GetEmployeesFromTown Sofia

GO

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
DECLARE @SalaryLevel NVARCHAR(10)
	IF(@Salary < 30000)
	BEGIN
		SET @SalaryLevel = 'Low'
	END
	IF (@Salary >= 30000 AND @Salary <= 50000)
	BEGIN
		SET @SalaryLevel = 'Average'
	END
	IF(@Salary > 50000)
	BEGIN
		SET @SalaryLevel = 'High'
	END
	RETURN @SalaryLevel
END

GO

SELECT e.Salary, dbo.ufn_GetSalaryLevel(e.Salary) FROM Employees AS e


-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE PROC dbo.usp_EmployeesBySalaryLevel (@Level NVARCHAR(10))
AS
	SELECT e.FirstName, e.LastName FROM Employees AS e
	WHERE dbo.ufn_GetSalaryLevel(e.Salary) = @Level


EXEC dbo.usp_EmployeesBySalaryLevel 'high'

GO

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE FUNCTION dbo.ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @WordLength INT = LEN(@word)
	DECLARE @Index INT = 1

	WHILE(@Index <= @WordLength)
	BEGIN
		IF(CHARINDEX(SUBSTRING(@word, @Index, 1), @setOfLetters)) = 0
		BEGIN
			RETURN 0
		END
		SET @Index+=1
	END
	RETURN 1
END

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')
SELECT dbo.ufn_IsWordComprised('bobr', 'Rob')
SELECT dbo.ufn_IsWordComprised('pppp', 'Guy')


-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE PROC dbo.usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

ALTER TABLE [dbo].[Departments]
ALTER COLUMN [ManagerID] INT

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Departments
SET ManagerID = NULL
WHERE DepartmentID = @departmentId

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

DELETE FROM Employees
WHERE DepartmentID = @departmentId

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*) FROM Employees
WHERE DepartmentID = @departmentId

GO


EXEC dbo.usp_DeleteEmployeesFromDepartment 1

GO

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR ALTER PROC dbo.usp_GetHoldersFullName
AS
SELECT CONCAT(Source.FirstName, ' ', Source.LastName) AS [Full Name] FROM (
	SELECT ah.Id, ah.FirstName, ah.LastName FROM dbo.AccountHolders AS ah
	
) AS Source

GO 

EXEC dbo.usp_GetHoldersFullName

GO
-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR ALTER PROC dbo.usp_GetHoldersWithBalanceHigherThan (@amount DECIMAL(18,4))
AS
SELECT Source.FirstName, Source.LastName FROM (
	SELECT ah.Id, ah.FirstName, ah.LastName, SUM(a.Balance) AS TotalSumBlance FROM dbo.AccountHolders AS ah
	JOIN dbo.Accounts AS a on ah.Id = a.AccountHolderId
	GROUP BY ah.Id, ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @amount
) AS Source
ORDER BY Source.FirstName ASC, Source.LastName ASC

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 20000

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GO

CREATE OR ALTER FUNCTION dbo.ufn_CalculateFutureValue (@initialSum DECIMAL(18,4), @yir FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
AS
BEGIN 
DECLARE @totalSum DECIMAL(18,4)

	SET @totalSum = @initialSum * (POWER((@yir + 1), @numberOfYears))

RETURN @totalSum
END

GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--FV=I×((1+R)T)

GO
-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE PROC dbo.usp_CalculateFutureValueForAccount (@AcID INT, @interest FLOAT)
AS
SELECT 
	  a.Id AS [Account Id]
	, ah.FirstName AS [First Name]
	, ah.LastName AS [Last Name]
	, a.Balance AS [Current Balance]
	, dbo.ufn_CalculateFutureValue(a.Balance, @interest, 5) AS [Balance in 5 years]
FROM dbo.AccountHolders AS ah
JOIN dbo.Accounts AS a ON ah.Id = a.AccountHolderId
WHERE a.Id = @AcID


EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1


-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

