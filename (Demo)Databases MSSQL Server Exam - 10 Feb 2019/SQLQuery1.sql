-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Planets
(
Id INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
Id INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(50) NOT NULL,
PlanetId INT NOT NULL FOREIGN KEY REFERENCES Planets(Id)
)

CREATE TABLE Spaceships
(
Id INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(50) NOT NULL,
Manufacturer NVARCHAR(30) NOT NULL,
LightSpeedRate INT DEFAULT(0)
)

CREATE TABLE Colonists 
(
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Ucn NVARCHAR(10) NOT NULL UNIQUE,
BirthDate DATE NOT NULL
)

CREATE TABLE Journeys
(
Id INT PRIMARY KEY IDENTITY(1,1),
JourneyStart DATETIME NOT NULL,
JourneyEnd DATETIME NOT NULL,
Purpose NVARCHAR(11) CHECK( Purpose = 'Medical' OR Purpose = 'Technical' OR Purpose = 'Educational' OR Purpose = 'Military') ,
DestinationSpaceportId INT NOT NULL FOREIGN KEY REFERENCES Spaceports(Id),
SpaceshipId INT NOT NULL FOREIGN KEY REFERENCES Spaceships(Id)
)

CREATE TABLE TravelCards
(
Id INT PRIMARY KEY IDENTITY(1,1),
CardNumber NCHAR(10) NOT NULL UNIQUE,
JobDuringJourney NVARCHAR(8) NOT NULL CHECK(JobDuringJourney = 'Pilot' OR JobDuringJourney = 'Engineer' OR JobDuringJourney = 'Trooper' OR JobDuringJourney = 'Cleaner' OR JobDuringJourney = 'Cook'),
ColonistId INT NOT NULL FOREIGN KEY REFERENCES Colonists(Id),
JourneyId INT NOT NULL FOREIGN KEY REFERENCES Journeys(Id)
)


-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO Planets ([Name])
VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO Spaceships ([Name], Manufacturer, LightSpeedRate)
VALUES
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX',  1),
('Bed', 'Vidolov', 6)


-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UPDATE Spaceships
SET LightSpeedRate +=1
WHERE Id >= 8 AND Id <= 12

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DELETE FROM TravelCards
WHERE JourneyId IN (1, 2, 3)

DELETE FROM Journeys
WHERE Id IN (1, 2, 3)

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT tc.CardNumber, tc.JobDuringJourney FROM TravelCards AS tc
ORDER BY tc.CardNumber ASC

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.Id, CONCAT(c.FirstName, ' ', c.LastName) AS [FullName], c.Ucn FROM Colonists AS c
ORDER BY c.FirstName, c.LastName, c.Id

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT j.Id, FORMAT(j.JourneyStart, 'd', 'en-gb'), FORMAT(j.JourneyEnd, 'd', 'en-gb') FROM Journeys AS j
WHERE j.Purpose = 'Military'
ORDER BY j.JourneyStart ASC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT c.Id, CONCAT(c.FirstName, ' ', c.LastName) AS [full_name] FROM Colonists AS c
JOIN TravelCards AS tc ON c.Id = tc.ColonistId
WHERE tc.JobDuringJourney = 'Pilot'
ORDER BY c.Id ASC

-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT COUNT(c.Id) FROM Colonists AS c
JOIN TravelCards AS tc ON c.Id = tc.ColonistId
JOIN Journeys AS j ON tc.JourneyId = j.Id
WHERE j.Purpose = 'Technical'


-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(1) s.[Name] AS [SpaceshipName], p.[Name] AS [SpaceportName] FROM Journeys AS j
JOIN Spaceships AS s ON j.SpaceshipId = s.Id
JOIN Spaceports AS p ON j.DestinationSpaceportId = p.Id
ORDER BY s.LightSpeedRate DESC

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT s.[Name], s.Manufacturer AS [Manufacturer] FROM Colonists AS c
JOIN TravelCards AS tc ON c.Id = tc.ColonistId
JOIN Journeys AS j ON tc.JourneyId = j.Id
JOIN Spaceships AS s ON j.SpaceshipId = s.Id
WHERE DATEPART(YEAR ,GETDATE()) - DATEPART(YEAR, c.BirthDate) < 30 AND tc.JobDuringJourney = 'Pilot'
ORDER BY s.[Name] ASC

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT pl.[Name], p.[Name] FROM Journeys AS j
JOIN Spaceports AS p ON j.DestinationSpaceportId = p.Id
JOIN Planets AS pl ON p.PlanetId = pl.Id
WHERE j.Purpose = 'Educational'
ORDER BY p.[Name] DESC

-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT pl.[Name] AS [PlanetName], COUNT(pl.[Name]) AS [JourneysCount] FROM Journeys AS j
JOIN Spaceports AS p ON j.DestinationSpaceportId = p.Id
JOIN Planets AS pl ON p.PlanetId = pl.Id
GROUP BY pl.[Name]
ORDER BY JourneysCount DESC, PlanetName ASC

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(1) Source.Id, Source.PlanetName, Source.SpaceportName, Source.JourneyPurpose FROM (
			SELECT j.Id, pl.[Name] AS [PlanetName], p.[Name] AS [SpaceportName], j.Purpose AS [JourneyPurpose], DATEDIFF(DAY, j.JourneyStart, j.JourneyEnd) AS [Duration] FROM Journeys AS j
			JOIN Spaceports AS p ON j.DestinationSpaceportId = p.Id
			JOIN Planets AS pl ON p.PlanetId = pl.Id
			) AS Source
ORDER BY Source.Duration

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(1) Source.Id, Source.JobDuringJourney AS [JobName] FROM (
			SELECT j.Id, tc.JobDuringJourney, COUNT(tc.ColonistId) AS [Count] FROM Journeys AS j
			JOIN TravelCards AS tc ON tc.JourneyId = j.Id
			WHERE j.Id = 7
			GROUP BY j.Id, tc.JobDuringJourney
			) AS Source
ORDER BY Source.[Count]


-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT k.JobDuringJourney, c.FirstName + ' ' + c.LastName AS FullName, k.JobRank
  FROM (
  SELECT tc.JobDuringJourney AS JobDuringJourney, tc.ColonistId,
DENSE_RANK() OVER (PARTITION BY tc.JobDuringJourney ORDER BY co.Birthdate ASC) AS JobRank
  FROM TravelCards AS tc
  JOIN Colonists AS co ON co.Id = tc.ColonistId
  GROUP BY tc.JobDuringJourney, co.Birthdate, tc.ColonistId
  ) AS k
  JOIN Colonists AS c ON c.Id = k.ColonistId
  WHERE k.JobRank = 2
  ORDER BY k.JobDuringJourney

-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT pl.[Name], COUNT(p.PlanetId) AS [Count] FROM Spaceports AS p
RIGHT OUTER JOIN Planets AS pl ON p.PlanetId = pl.Id
GROUP BY pl.[Name]
ORDER BY [Count] DESC, pl.[Name]

-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GO

CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(c.Id) AS [Count] FROM Journeys AS j
		JOIN TravelCards AS tc ON j.Id = tc.JourneyId
		JOIN Colonists AS c ON tc.ColonistId = c.Id
		JOIN Spaceports AS p ON j.DestinationSpaceportId = p.Id
		JOIN Planets AS pl ON p.PlanetId = pl.Id
		WHERE pl.[Name] = @PlanetName
		)
END

	GO

SELECT dbo.udf_GetColonistsCount('Otroyphus')


-- 19 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose NVARCHAR(11))
AS

	IF(@JourneyId NOT IN (SELECT j.Id FROM Journeys AS j))
	BEGIN
		RAISERROR('The journey does not exist!', 16, 1)
		ROLLBACK
	END

	IF(@NewPurpose IN (SELECT j.Purpose FROM Journeys AS j WHERE j.Id = @JourneyId))
	BEGIN
	RAISERROR('You cannot change the purpose!', 16, 2)
		ROLLBACK
	END

	UPDATE Journeys
	SET Purpose = @NewPurpose
	WHERE Id = @JourneyId

-- 20 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE DeletedJourneys
(
Id INT NOT NULL,
JourneyStart DATE NOT NULL,
JourneyEnd DATE NOT NULL,
Purpose NVARCHAR(11) CHECK( Purpose = 'Medical' OR Purpose = 'Technical' OR Purpose = 'Educational' OR Purpose = 'Military'),
DestinationSpaceportId INT NOT NULL,
SpaceshipId INT NOT NULL
)

GO

CREATE OR ALTER TRIGGER tr_MoveDeletedJourneis ON Journeys AFTER DELETE
AS
	INSERT INTO DeletedJourneys SELECT d.Id, d.JourneyStart, d.JourneyEnd, d.Purpose, d.DestinationSpaceportId, d.SpaceshipId FROM deleted AS d 










