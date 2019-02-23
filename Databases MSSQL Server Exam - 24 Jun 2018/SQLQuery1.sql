-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Cities
(
Id INT PRIMARY KEY IDENTITY (1,1),
[Name] NVARCHAR(20) NOT NULL,
CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels
(
Id INT PRIMARY KEY IDENTITY (1,1),
[Name] NVARCHAR(30) NOT NULL,
CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(18,2)
)

CREATE TABLE Rooms
(
Id INT PRIMARY KEY IDENTITY (1,1),
Price MONEY NOT NULL,
[Type] NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id)
)

CREATE TABLE Trips
(
Id INT PRIMARY KEY IDENTITY (1,1),
RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id),
BookDate DATE NOT NULL,
ArrivalDate DATE NOT NULL,
ReturnDate DATE NOT NULL,
CancelDate DATE
)

ALTER TABLE Trips
ADD CONSTRAINT chk_BookDATE CHECK(BookDate < ArrivalDate)
ALTER TABLE Trips
ADD CONSTRAINT chk_ArrivalDate CHECK(ArrivalDate < ReturnDate)


CREATE TABLE Accounts
(
Id INT PRIMARY KEY IDENTITY (1,1),
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(50) NOT NULL,
CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
BirthDate DATE NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE
)


CREATE TABLE AccountsTrips
(
AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts(Id),
TripId INT NOT NULL FOREIGN KEY REFERENCES Trips(Id),
Luggage INT NOT NULL CHECK(Luggage >= 0)
)

ALTER TABLE AccountsTrips
ADD CONSTRAINT pk_AccountId_TripId PRIMARY KEY (AccountId, TripId)

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO Trips(RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)


-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


UPDATE Rooms
SET Price *= 1.14
WHERE HotelId IN (5, 7, 9)



-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DELETE FROM AccountsTrips
WHERE AccountId = 47


-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.Id, c.[Name] FROM Cities AS c
WHERE c.CountryCode = 'BG'
ORDER BY c.[Name]

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT CONCAT(a.FirstName, ' '+ a.MiddleName, ' ', a.LastName) AS [Full Name], YEAR(a.BirthDate) AS [BirthYear] FROM Accounts AS a
WHERE YEAR(a.BirthDate) > 1991
ORDER BY YEAR(a.BirthDate) DESC, [Full Name] ASC 

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT a.FirstName, a.LastName, FORMAT( a.BirthDate, 'MM-dd-yyyy', 'en-US' ) AS [BirthDate], c.[Name] AS [Hometown], a.Email FROM Accounts AS a
JOIN Cities AS c ON a.CityId = c.Id
WHERE SUBSTRING(a.Email, 1, 1) = 'e'
ORDER BY c.[Name] DESC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.[Name] AS [City], COUNT(h.Id) AS [Hotels] FROM Cities AS c
LEFT OUTER JOIN Hotels AS h ON c.Id = h.CityId
GROUP BY c.[Name]
ORDER BY COUNT(h.Id) DESC, c.[Name] ASC


-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SELECT r.Id, r.Price, h.[Name] AS [Hotel], c.[Name] AS [City] FROM Hotels AS h
JOIN Rooms AS r ON r.HotelId = h.Id
JOIN Cities AS c ON h.CityId = c.Id
WHERE r.[Type] = 'First Class' 
ORDER BY r.Price DESC, r.Id ASC

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT a.Id, CONCAT(a.FirstName, ' ', a.LastName), MAX(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)), MIN(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) FROM Accounts AS a
JOIN AccountsTrips AS at ON a.Id = at.AccountId
JOIN Trips AS t ON at.TripId = t.Id
WHERE t.CancelDate IS NULL AND a.MiddleName IS NULL
GROUP BY a.Id, a.FirstName, a.LastName
ORDER BY MAX(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) DESC, a.Id

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(5) c.Id, c.[Name] AS [City], c.CountryCode AS [Country], COUNT(a.Id) AS [Accounts] FROM Cities AS c
JOIN Accounts AS a ON a.CityId = c.Id
GROUP BY c.Id, c.[Name], c.CountryCode
ORDER BY COUNT(a.Id) DESC

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT a.Id, a.Email, c.[Name] AS [City], COUNT(t.Id) AS [Trips] FROM Accounts AS a
JOIN AccountsTrips AS at ON a.Id = at.AccountId
JOIN Trips AS t ON at.TripId = t.Id
JOIN Rooms AS r ON t.RoomId = r.Id 
JOIN Hotels AS h ON r.HotelId = h.Id
JOIN Cities AS c ON h.CityId = c.Id
WHERE a.CityId = h.CityId
GROUP BY a.Id, a.Email, c.[Name]
ORDER BY COUNT(t.Id) DESC, a.Id ASC


-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(10) c.Id, c.[Name], SUM(h.BaseRate + r.Price) AS [Total Revenue], COUNT(*) AS [Trips] FROM Hotels AS h
JOIN Rooms AS r ON r.HotelId = h.Id
JOIN Trips AS t ON t.RoomId = r.Id
JOIN Cities AS c ON c.Id = h.CityId
WHERE YEAR(t.BookDate) = 2016
GROUP BY c.Id, c.[Name]
ORDER BY [Total Revenue] DESC, [Trips]

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.TripId, Source.[Name], Source.[Type] AS [RoomType], Source.Revenue FROM (
			SELECT [at].TripId, h.[Name], r.[Type] , SUM(h.BaseRate + r.Price) AS [R] ,
			CASE
				WHEN t.CancelDate IS NOT NULL THEN  0
				WHEN t.CancelDate IS NULL THEN SUM(h.BaseRate + r.Price)
			END AS [Revenue]
			 FROM Trips AS t
			 JOIN Rooms AS r ON r.Id = t.RoomId
			 JOIN Hotels AS h ON h.Id = r.HotelId
			 JOIN AccountsTrips As [at] ON t.Id = [at].TripId
			GROUP BY [at].TripId, h.[Name], r.[Type], t.CancelDate
			) AS Source
ORDER BY Source.[Type], Source.TripId

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.AccountId, Source.Email, Source.CountryCode, Source.Trips FROM (
			SELECT a.Id AS [AccountId], a.Email, c.CountryCode, COUNT(*) AS [Trips], DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY COUNT(*) DESC, a.Id) AS [Rank]  FROM Accounts AS a
			JOIN AccountsTrips AS att ON a.Id = att.AccountId
			JOIN Trips AS t ON t.Id = att.TripId
			JOIN Rooms AS r ON r.Id = t.RoomId
			JOIN Hotels AS h ON h.Id = r.HotelId
			JOIN Cities AS c ON c.Id = h.CityId
			GROUP BY a.Id, a.Email, c.CountryCode
			) AS Source
WHERE [Rank] = 1
ORDER BY Source.Trips DESC, Source.AccountId

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT att.TripId, SUM(att.Luggage) AS [Luggage], '$' + 
CONVERT( NVARCHAR,
(CASE
	WHEN SUM(att.Luggage) > 5 THEN SUM(att.Luggage) * 5
	ELSE 0
END)) AS [Fee] 
FROM AccountsTrips AS att
GROUP BY att.TripId
HAVING SUM(att.Luggage) > 0
ORDER BY [Luggage] DESC


-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT t.Id, CONCAT(a.FirstName, ' '+a.MiddleName, ' ', a.LastName) AS [Full Name], c.[Name] AS [From], (SELECT TOP(1) [Name] FROM Cities WHERE Id = h.CityId) AS [To], 
CASE 
	WHEN t.CancelDate IS NULL THEN CONVERT( NVARCHAR, DATEDIFF(DAY , t.ArrivalDate, t.ReturnDate)) + ' days'
	ELSE 'Canceled'
END AS [Duration]
 FROM Trips AS t
JOIN AccountsTrips AS att ON att.TripId = t.Id
JOIN Accounts AS a ON a.Id = att.AccountId
JOIN Cities AS c ON c.Id = a.CityId
JOIN Rooms AS r ON r.Id = t.RoomId
JOIN Hotels AS h ON h.Id = r.HotelId
ORDER BY [Full Name], t.Id


-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE OR ALTER FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(100)
AS
BEGIN
DECLARE @Result NVARCHAR(100)

DECLARE @TableRessults TABLE(RoomId INT, RoomType NVARCHAR(20), Beds INT, TotalPrice DECIMAL(18,2))

INSERT INTO @TableRessults
	SELECT TOP(1) r.Id, r.[Type], r.Beds, (h.BaseRate + r.Price) * @People AS [pr] FROM Trips AS t
	JOIN Rooms AS r ON r.Id = t.RoomId
	JOIN Hotels AS h ON h.Id = r.HotelId
	WHERE (t.ArrivalDate <> @Date AND t.ReturnDate <> @Date OR t.CancelDate IS NULL) AND h.Id = @HotelId AND r.Beds >= @People
	GROUP BY r.Id, r.[Type], r.Beds, h.BaseRate, r.Price
	ORDER BY [pr] DESC



DECLARE  @Rooms INT = (SELECT COUNT(*) FROM @TableRessults)

IF(@Rooms = 0)
BEGIN
	SET @Result = 'No rooms available'
	
END
ELSE
BEGIN
	SET @Result = 'Room ' + CONVERT(NVARCHAR, (SELECT RoomId FROM @TableRessults)) + ': ' + CONVERT(NVARCHAR, (SELECT RoomType FROM @TableRessults)) + ' (' + CONVERT(NVARCHAR, (SELECT Beds FROM @TableRessults)) + ' beds) - $' + CONVERT(NVARCHAR, (SELECT TotalPrice FROM @TableRessults))
	
END
RETURN @Result
END

SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(6, '2012-11-01', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)

