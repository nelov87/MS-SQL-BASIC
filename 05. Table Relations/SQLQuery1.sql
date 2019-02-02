-- 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Passports(
PassportID INT NOT NULL,
PassportNumber NVARCHAR(50) NOT NULL

CONSTRAINT PK_PassportID
PRIMARY KEY (PassportID)
)


CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
Salary DECIMAL NOT NULL,
PassportID INT NOT NULL

CONSTRAINT PK_PersonID
PRIMARY KEY (PersonID)

CONSTRAINT FK_Persons_PassportID
FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)
)

-- 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Manufacturers(
ManufacturerID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
EstablishedOn DATE NOT NULL

CONSTRAINT PK_ManufacturerID
PRIMARY KEY (ManufacturerID)
)

INSERT INTO Manufacturers(ManufacturerID, [Name], EstablishedOn)
VALUES
(1, 'BMW', '1916/03/07'),
(2, 'Tesla', '2003/01/01'),
(3, 'Lada', '1966/05/01')

CREATE TABLE Models(
ModelID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
ManufacturerID INT NOT NULL

CONSTRAINT PK_ModelID
PRIMARY KEY (ModelID)

CONSTRAINT FK_Models_ManufacturersId
FOREIGN KEY(ManufacturerID)
REFERENCES Manufacturers(ManufacturerID) 
)

INSERT INTO Models (ModelID, [Name], ManufacturerID)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

-- 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Students
CREATE TABLE Students(
StudentID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,

CONSTRAINT PK_StudentID
PRIMARY KEY (StudentID)
)

-- Exams
CREATE TABLE Exams(
ExamID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,

CONSTRAINT PK_ExamID
PRIMARY KEY (ExamID)
)

-- StudentsExams
CREATE TABLE StudentsExams(
StudentID INT NOT NULL,
ExamID INT NOT NULL,

CONSTRAINT PK_StudentID_ExamID
PRIMARY KEY (StudentID, ExamID)
,
CONSTRAINT FK_StudentsExams_StudentID
FOREIGN KEY(StudentID)
REFERENCES Students(StudentID) 
,
CONSTRAINT FK_StudentsExams_ExamID
FOREIGN KEY(ExamID)
REFERENCES Exams(ExamID) 
)

INSERT INTO Students(StudentID, [Name])
VALUES
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron')

INSERT INTO Exams(ExamID, [Name])
VALUES
(101, 'SpringMVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

-- 4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Teachers(
TeacherID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
ManagerID INT 

CONSTRAINT PK_TeacherID
PRIMARY KEY (TeacherID)

CONSTRAINT FK_ManagerID_TeacherID
FOREIGN KEY (ManagerID)
REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers (TeacherID, Name, ManagerID)
VALUES 
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

-- 5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Cities(
CityID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers(
CustomerID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Birthday DATE,
CityID INT NOT NULL
)

CREATE TABLE Orders(
OrderID INT NOT NULL,
CustomerID INT NOT NULL
)

CREATE TABLE ItemTypes(
ItemTypeID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Items(
ItemID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ItemTypeID INT NOT NULL
)

CREATE TABLE OrderItems(
OrderID INT NOT NULL,
ItemID INT NOT NULL
)


-- ok
ALTER TABLE Cities
ADD CONSTRAINT PK_CityID PRIMARY KEY (CityID)

-- ok
ALTER TABLE Customers
ADD CONSTRAINT PK_CustomerID PRIMARY KEY (CustomerID)

-- ok
ALTER TABLE Orders
ADD CONSTRAINT PK_OrderID PRIMARY KEY (OrderID) 

-- ok
ALTER TABLE ItemTypes
ADD CONSTRAINT PK_ItemTypes_ItemTypeID PRIMARY KEY (ItemTypeID)


-- ok
ALTER TABLE Items
ADD CONSTRAINT PK_ItemID PRIMARY KEY (ItemID)

-- ok
ALTER TABLE OrderItems
ADD CONSTRAINT PK_OrderItems_OrderID PRIMARY KEY (OrderID, ItemID)

-- ok
ALTER TABLE Customers
ADD CONSTRAINT FK_Customers_CityID FOREIGN KEY (CityID) REFERENCES Cities(CityID)

-- ok
ALTER TABLE Orders
ADD CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

-- ok
ALTER TABLE Items
ADD CONSTRAINT FK_ItemTypeID FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)


-- ok
ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)

-- ok
ALTER TABLE OrderItems
ADD CONSTRAINT FK_ItemID FOREIGN KEY (ItemID) REFERENCES Items(ItemID)


-- 6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GO

CREATE TABLE Payments(
PaymentID INT NOT NULL PRIMARY KEY,
PaymentDate Date,
PaymentAmount DECIMAL NOT NULL,
StudentID INT NOT NULL
)

CREATE TABLE Agenda(
StudentID INT NOT NULL,
SubjectID INT NOT NULL

CONSTRAINT PK_StudentID_SubjectID PRIMARY KEY(StudentID, SubjectID)
)

CREATE TABLE Subjects(
SubjectID INT NOT NULL PRIMARY KEY,
SubjectName VARCHAR(50) NOT NULL
)

CREATE TABLE Students(
StudentID INT NOT NULL PRIMARY KEY,
StudentNumber INT NOT NULL,
StudentName VARCHAR(50) NOT NULL,
MajorID INT NOT NULL
)

CREATE TABLE Majors(
MajorID INT NOT NULL PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL
)

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_StudentID FOREIGN KEY (StudentID) REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_Agenda_StudentID FOREIGN KEY (StudentID) REFERENCES Students (StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_Agenda_SubjectID FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID)

ALTER TABLE Students
ADD CONSTRAINT FK_Students_MajorID FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)


-- 9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT m.MountainRange, p.PeakName, p.Elevation FROM Peaks AS p 
JOIN Mountains AS m 
ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC












-- in case SA is not owner of DB ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


USE Geography 
GO 
ALTER DATABASE Geography set TRUSTWORTHY ON; 
GO 
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false 
GO 
sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
sp_configure 'clr enabled', 1; 
GO 
RECONFIGURE; 
GO
