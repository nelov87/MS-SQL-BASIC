-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- schoolAgain

CREATE TABLE Students
(
Id INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(30) NOT NULL,
MiddleName NVARCHAR(25),
LastName NVARCHAR(30) NOT NULL,
Age INT NOT NULL CHECK((Age > 5 AND Age < 100)),
[Address] NVARCHAR(50),
Phone CHAR(10)
)

CREATE TABLE Subjects
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(20) NOT NULL,
Lessons INT NOT NULL CHECK(Lessons > 0)
)

CREATE TABLE StudentsSubjects
(
Id INT IDENTITY(1,1) PRIMARY KEY,
StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
Grade DECIMAL(18,2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6 )
)

CREATE TABLE Exams
(
Id INT IDENTITY(1,1) PRIMARY KEY,
[Date] DATETIME,
SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE StudentsExams
(
StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
ExamId INT NOT NULL FOREIGN KEY REFERENCES Exams(Id),
Grade DECIMAL(18,2) NOT NULL CHECK(Grade >= 2 AND Grade <= 6 )

CONSTRAINT pk_StudentId_ExamId PRIMARY KEY(StudentId, ExamId)
)

CREATE TABLE Teachers
(
Id INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
[Address] NVARCHAR(20) NOT NULL,
Phone CHAR(10),
SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE StudentsTeachers
(
StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id)

CONSTRAINT pk_StudentId_TeacherId PRIMARY KEY(StudentId, TeacherId)
)

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO Teachers (FirstName, LastName, [Address], Phone, SubjectId)
VALUES
('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
('Gerrard','Lowin', '370 Talisman Plaza', '3324874824', 2),
('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)


INSERT INTO Subjects([Name], Lessons)
VALUES
('Geometry', 12),
('Health', 10),
('Drama', 7),
('Sports', 9)


-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE SubjectId IN (1, 2) AND Grade >= 5.50

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE CHARINDEX('72', Phone, 1) > 0)

DELETE FROM Teachers
WHERE CHARINDEX('72', Phone, 1) > 0

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT s.FirstName, s.LastName, s.Age FROM Students AS s
WHERE Age >= 12
ORDER BY s.FirstName ASC, s.LastName ASC

-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT CONCAT(s.FirstName, ' ', s.MiddleName,' ', s.LastName), s.[Address] FROM Students AS s
WHERE CHARINDEX('road', [Address], 1) > 0
ORDER BY s.FirstName ASC, s.LastName ASC, s.[Address] ASC

-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT s.FirstName, s.[Address], s.Phone FROM Students AS s
WHERE s.MiddleName IS NOT NULL AND CHARINDEX('42', s.Phone, 1) = 1
ORDER BY s.FirstName ASC

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT s.FirstName, s.LastName, COUNT(st.TeacherId) AS [TeachersCount] FROM Students AS s
JOIN StudentsTeachers AS st ON s.Id = st.StudentId
GROUP BY s.FirstName, s.LastName

-- 9 -----------------------++++++++++++++++++++++++++++++++++++++++++++++++

SELECT t.FirstName + ' ' + t.LastName AS Name, s.Name + '-' + CAST(s.Lessons AS NVARCHAR(5)) AS Subjects,
COUNT(ss.StudentId) AS Students
FROM Teachers AS t
JOIN Subjects AS s
ON s.Id = t.SubjectId
JOIN StudentsTeachers AS ss
ON ss.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName, s.Name,s.Lessons
ORDER BY COUNT(ss.StudentId) DESC, Name, Subjects


-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT Source.[Full Name] FROM (SELECT CONCAT(s.FirstName,' ', s.LastName) AS [Full Name], se.ExamId FROM Students AS s
			LEFT OUTER JOIN StudentsExams AS se ON s.Id = se.StudentId
			)AS Source
WHERE Source.ExamId IS NULL
ORDER BY Source.[Full Name] ASC


-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(10) t.FirstName, t.LastName, COUNT(st.StudentId) AS [StudentsCount] FROM Teachers AS t
JOIN StudentsTeachers AS st ON t.Id = st.TeacherId
GROUP BY t.FirstName, t.LastName
ORDER BY [StudentsCount] DESC, t.FirstName ASC


-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT TOP(10) s.FirstName, s.LastName, CONVERT(DECIMAL(18,2), AVG(se.Grade)) AS [Grade] FROM Students AS s
JOIN StudentsExams AS se ON s.Id = se.StudentId
GROUP BY s.FirstName, s.LastName
ORDER BY [Grade] DESC, s.FirstName ASC, s.LastName ASC


-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT Source.FirstName, Source.LastName, Source.Grade FROM (
			SELECT s.FirstName, s.LastName, ROW_NUMBER() OVER(PARTITION BY FirstName, LastName ORDER BY Grade DESC) AS [Rank], se.Grade FROM Students AS s
			JOIN StudentsSubjects AS se ON s.Id = se.StudentId
			) AS Source
WHERE Source.[Rank] = 2
ORDER BY Source.FirstName ASC, Source.LastName ASC

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT CONCAT(s.FirstName, ' '+s.MiddleName, ' ', s.LastName) AS [Full Name] FROM Students AS s
LEFT OUTER JOIN StudentsSubjects AS ss ON s.Id = ss.StudentId
WHERE ss.StudentId IS NULL
ORDER BY [Full Name]


-- 15 -------------+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT
    [Teacher FULL Name], [Subject Name], [Student FULL Name], CAST(Grade AS NUMERIC(10, 2)) AS Grade
    FROM(
SELECT
    CONCAT(t.FirstName, ' ', t.LastName) AS [Teacher FULL Name],
    sb.[Name] AS [Subject Name],
    CONCAT(s.FirstName, ' ', s.LastName) AS [Student FULL Name],
    AVG(ss.Grade) AS Grade,
    ROW_NUMBER() OVER (PARTITION BY t.FirstName, t.LastName ORDER BY AVG(ss.Grade) DESC) AS [Rank]
    FROM Students AS s
    JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
    JOIN StudentsTeachers AS st ON st.StudentId = s.Id
    JOIN Teachers AS t ON t.Id = st.TeacherId
    JOIN Subjects AS sb ON sb.Id = t.SubjectId
    WHERE t.SubjectId = ss.SubjectId
    GROUP BY s.Id, s.FirstName, s.LastName, t.FirstName, t.LastName, sb.[Name]
    ) AS t
    WHERE [Rank] = 1
ORDER BY [Subject Name], [Teacher FULL Name], Grade DESC
	
)


SELECT t.FirstName + ' ' + t.LastName AS [tname], sub.[Name], cte.fname + cte.lname, cte.grade FROM Teachers AS t
JOIN Subjects AS sub ON t.SubjectId = sub.Id
JOIN StudentsSubjects AS ss ON sub.Id = ss.SubjectId
JOIN Students AS s ON ss.StudentId = s.Id
JOIN Temp_CTE AS cte ON sub.Id = cte.subId
GROUP BY t.FirstName, t.LastName, sub.[Name], cte.fname, cte.lname, cte.grade
ORDER BY sub.[Name], [tname], cte.grade DESC

-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT sub.[Name], AVG(ss.Grade) FROM Subjects As sub
JOIN StudentsSubjects AS ss ON sub.Id = ss.SubjectId
GROUP BY sub.[Name],sub.Id
ORDER BY sub.Id ASC


-- 17 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT  k.Quarter, k.SubjectName, COUNT(k.StudentId) AS StudentsCount
  FROM (
  SELECT s.Name AS SubjectName,
		 se.StudentId,
		 CASE
		 WHEN DATEPART(MONTH, Date) BETWEEN 1 AND 3 THEN 'Q1'
		 WHEN DATEPART(MONTH, Date) BETWEEN 4 AND 6 THEN 'Q2'
		 WHEN DATEPART(MONTH, Date) BETWEEN 7 AND 9 THEN 'Q3'
		 WHEN DATEPART(MONTH, Date) BETWEEN 10 AND 12 THEN 'Q4'
		 WHEN Date IS NULL THEN 'TBA'
		 END AS [Quarter]
    FROM Exams AS e
	JOIN Subjects AS s ON s.Id = e.SubjectId 
	JOIN StudentsExams AS se ON se.ExamId = e.Id
	WHERE se.Grade >= 4
) AS k
GROUP BY k.Quarter, k.SubjectName
ORDER BY k.Quarter

-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE OR ALTER FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(18,2))
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @Result NVARCHAR(MAX)

	IF(@grade >= 6.00)
	BEGIN
		SET @Result = 'Grade cannot be above 6.00!'
	END

	IF(@studentId NOT IN (SELECT Id FROM Students))
	BEGIN 
		SET @Result = 'The student with provided id does not exist in the school!'
	END

	IF(@studentId IN (SELECT Id FROM Students) AND @grade < 6.00)
	BEGIN
		DECLARE @NumberOfGrades INT = (
		SELECT COUNT(ss.Grade) FROM Students AS s
		JOIN StudentsExams AS ss ON s.Id = ss.StudentId
		WHERE s.Id = @studentId AND ss.Grade <= @grade + 0.50 AND ss.Grade >= @grade
		
		)
	DECLARE @Name NVARCHAR(MAX) = (SELECT TOP(1) s.FirstName FROM Students AS s
		JOIN StudentsExams AS ss ON s.Id = ss.StudentId
		WHERE s.Id = @studentId AND ss.Grade <= @grade + 0.50 AND ss.Grade >= @grade
		) 
		SET @Result = 'You have to update ' + CONVERT(NVARCHAR, @NumberOfGrades) + ' grades for the student ' + @Name
	END

RETURN @Result
END

SELECT dbo.udf_ExamGradesToUpdate(12, 6.20)
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)



-- 19 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GO

CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN
	BEGIN TRAN
		IF(@StudentId NOT IN (SELECT Id FROM Students))
		BEGIN
			RAISERROR('This school has no student with the provided id!', 16, 1)
			ROLLBACK
		END
		ELSE
		BEGIN
			DELETE FROM StudentsExams
			WHERE StudentId = @StudentId

			DELETE FROM StudentsSubjects
			WHERE StudentId = @StudentId

			DELETE FROM StudentsTeachers
			WHERE StudentId = @StudentId

			DELETE FROM Students
			WHERE Id = @StudentId
		END
	COMMIT
	RETURN @StudentId
END

EXEC usp_ExcludeFromSchool 1






-- 20 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE ExcludedStudents
(
StudentId INT ,
StudentName NVARCHAR(MAX)
)

GO

CREATE TRIGGER tr_MoveDeletedStudents ON [dbo].[Students] AFTER DELETE
AS
INSERT INTO ExcludedStudents SELECT d.Id, CONCAT(d.FirstName,' ', d.LastName) FROM deleted AS d




