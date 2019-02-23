-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE DATABASE Supermarket
GO

USE Supermarket
GO

CREATE TABLE Categories
(
Id INT IDENTITY(1,1) PRIMARY KEY, 
[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Items
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(30) NOT NULL,
Price DECIMAL(15,2) NOT NULL,
CategoryId INT NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)

CREATE TABLE Employees
(
Id INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Phone CHAR(12) NOT NULL,
Salary DECIMAL(15,2) NOT NULL
)

CREATE TABLE Orders
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[DateTime] DATETIME NOT NULL,
EmployeeId INT NOT NULL FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)  
)

CREATE TABLE OrderItems
(
OrderId INT FOREIGN KEY (OrderId) REFERENCES Orders(Id),
ItemId INT FOREIGN KEY (ItemId) REFERENCES Items(Id),
Quantity INT NOT NULL CHECK(Quantity >= 1)

CONSTRAINT pk_OrderIdItemId PRIMARY KEY (OrderId, ItemId)
)

CREATE TABLE Shifts
(
Id INT IDENTITY(1,1) ,
EmployeeId INT NOT NULL,
CheckIn DATETIME NOT NULL,
CheckOut DATETIME NOT NULL

CONSTRAINT pk_Id_EmployeeId PRIMARY KEY (Id, EmployeeId)
CONSTRAINT fk_EmployeeIdEmployeesId FOREIGN KEY (EmployeeId) REFERENCES Employees(Id) 
)

ALTER TABLE Shifts
 ADD CONSTRAINT chk_Date CHECK(CheckOut > CheckIn)

 -- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 INSERT INTO Employees (FirstName, LastName, Phone, Salary)
 VALUES
 ('Stoyan', 'Petrov', '888-785-8573', 500.25),
 ('Stamat', 'Nikolov', '789-613-1122', 999995.25),
 ('Evgeni', 'Petkov', '645-369-9517', 1234.51),
 ('Krasimir', 'Vidolov', '321-471-9982', 50.25)

 INSERT INTO Items ([Name], Price, CategoryId)
 VALUES
 ('Tesla battery', 154.25, 8),
 ('Chess', 30.25, 8),
 ('Juice', 5.32, 1),
 ('Glasses', 10.00, 8),
 ('Bottle of water', 1.00, 1)

  -- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UPDATE Items
SET Price *= 1.27
WHERE CategoryId IN (1, 2, 3)

  -- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  DELETE FROM OrderItems
  WHERE OrderId = 48

 -- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 SELECT e.Id, e.FirstName FROM Employees AS e
 WHERE e.Salary > 6500
 ORDER BY e.FirstName, e.Id

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT CONCAT(e.FirstName, ' ', e.LastName), e.Phone FROM Employees AS e
WHERE SUBSTRING(e.Phone,1,1) = 3
ORDER BY e.FirstName ASC, e.Phone ASC


-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.FirstName, e.LastName, COUNT(o.EmployeeId) AS [Count] FROM Orders AS o
	JOIN Employees AS e ON o.EmployeeId = e.Id
WHERE e.Id IN (SELECT ord.EmployeeId FROM Orders AS ord)
GROUP BY e.FirstName, e.LastName
ORDER BY [Count] DESC, e.FirstName

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.FirstName, Source.LastName, AVG(Source.[hours]) AS [Work hours] FROM (
			SELECT e.Id, e.FirstName, e.LastName, DATEDIFF( HOUR , sh.CheckIn, sh.CheckOut) AS [hours] FROM Employees AS e
				JOIN Shifts AS sh ON e.Id = sh.EmployeeId
			GROUP BY e.Id, e.FirstName, e.LastName, sh.CheckIn, sh.CheckOut) AS Source
GROUP BY Source.FirstName, Source.LastName, Source.Id
HAVING AVG(Source.[hours]) > 7
ORDER BY [Work hours] DESC, Source.Id

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(1) Source.Id, SUM(Source.Pr) AS [TotalPrice] FROM ( 
		SELECT o.Id, SUM(i.Price * oi.Quantity) AS pr FROM Orders AS o
			JOIN OrderItems AS oi ON o.Id = oi.OrderId
			JOIN Items AS i ON oi.ItemId = i.Id
			GROUP BY o.Id
			
			) AS Source
GROUP BY Source.Id
ORDER BY SUM(Source.Pr) DESC

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(10) Source.Id AS [OrderId], MAX(Source.Price) AS [ExpensivePrice], MIN(Source.Price) AS [CheapPrice] FROM (
			SELECT o.Id, i.Price FROM Orders AS o
			JOIN OrderItems AS oi ON o.Id = oi.OrderId
			JOIN Items AS i ON oi.ItemId = i.Id
			
			)
			AS Source
GROUP BY Source.Id
ORDER BY [ExpensivePrice] DESC, [OrderId]


-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT e.Id, e.FirstName AS [First Name], e.LastName AS [Last Name] FROM Employees AS e
WHERE e.Id IN (SELECT o.EmployeeId FROM Orders AS o )
ORDER BY e.Id


-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SELECT DISTINCT Source.Id, CONCAT(Source.FirstName, ' ' , Source.LastName) FROM (
			SELECT e.Id, e.FirstName, e.LastName, DATEDIFF( HOUR , sh.CheckIn, sh.CheckOut) AS [hours] FROM Employees AS e
			JOIN Shifts AS sh ON e.Id = sh.EmployeeId
			GROUP BY e.Id, e.FirstName, e.LastName, sh.CheckIn, sh.CheckOut
			HAVING DATEDIFF( HOUR , sh.CheckIn, sh.CheckOut) < 4
			) AS Source


-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT FROM 









