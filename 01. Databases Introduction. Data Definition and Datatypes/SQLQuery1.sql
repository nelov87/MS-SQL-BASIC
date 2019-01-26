
CREATE TABLE Minions (
Id int PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
Age INT
)

CREATE TABLE Towns (
Id INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50)
)

ALTER TABLE Minions
ADD TownId INT NOT NULL

DROP TABLE Minions

ALTER TABLE Minions
ADD CONSTRAINT FK_TownID
FOREIGN KEY (TownID) REFERENCES Towns(Id)

INSERT INTO Towns(Id, [Name])
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')


INSERT INTO Minions (Id, [Name], Age, TownId)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

TRUNCATE TABLE Minions

DROP TABLE Towns

-- Gender CHAR(1) CHECK(Gender = 'm' OR Gender = 'f')
-- 7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(200) NOT NULL,
Picture VARBINARY CHECK(DATALENGTH(Picture) < 2 * 1024),
Height DECIMAL(3,2),
[Weight] DECIMAL(5,2),
Gender CHAR(1) CHECK(Gender = 'm' OR Gender = 'f') NOT NULL,
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
)

INSERT INTO People ([Name], Height, [Weight], Gender, Birthdate, Biography)
VALUES('Pesho', 1.65, 70.50, 'm', '19871011', 'Loremsdfmsdkfsdlkdslfsldkmfdlskmfldks'),
	  ('Ivan', 1.78, 60.50, 'm', '19900519', 'Some text goes here'),
	  ('Pesho', 1.65, 70.50, 'm', '19871011', 'Loremsdfmsdkfsdlkdslfsldkmfdlskmfldks'),
	  ('Pesho', 1.65, 70.50, 'm', '19871021', 'Loremsdfmsdkfsdlkdslfsldkmfdlskmfldks'),
	  ('Pesho', 1.65, 70.50, 'm', '19871011', 'Loremsdfmsdkfsdlkdslfsldkmfdlskmfldks')

DROP TABLE People

-- 8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Users(
Id BIGINT PRIMARY KEY IDENTITY(1,1),
Username VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY CHECK(DATALENGTH(ProfilePicture) < 910 * 1024),
LastLoginTime DATETIME,
IsDeleted BIT
)

INSERT INTO Users (Username, [Password], LastLoginTime, IsDeleted)
VALUES('Pesho', 'sdds2dss0', '19871011 10:34:09 AM', 0),
	  ('Ivan', 'sdds2dss0', '19871011 10:34:09 AM', 0),
	  ('Gosho', 'sdds2dss0', '19871011 10:34:09 AM', 0),
	  ('Pencho', 'sdds2dss0', '19871011 10:34:09 AM', 0),
	  ('Toshko', 'sdds2dss0', '19871011 10:34:09 AM', 0)

-- 9 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ALTER TABLE USERS
DROP CONSTRAINT PK__Users__3214EC07B065BD72

ALTER TABLE Users
ADD CONSTRAINT PK_Id_User
PRIMARY KEY (Id, Username)

-- 10 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ALTER TABLE Users
ADD CONSTRAINT PassLength CHECK(LEN([Password]) >= 5)

-- 11 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ALTER TABLE USERS
ADD DEFAULT GETDATE() FOR LastLoginTime

-- 12 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ALTER TABLE Users
DROP CONSTRAINT [PK_Id_User]

ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CHK_UserLength
CHECK(LEN(Username) >=3)

-- 13 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors(
Id INT PRIMARY KEY IDENTITY(1,1),
DirectorName NVARCHAR(100) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Genres(
Id INT PRIMARY KEY IDENTITY(1,1),
GenreName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY(1,1),
CategoryName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Movies(
Id INT PRIMARY KEY IDENTITY(1,1),
Title NVARCHAR(50),
DirectorId INT NOT NULL FOREIGN KEY(DirectorId) REFERENCES Directors(Id),
CopyrightYear SMALLINT NOT NULL,
[Length] DECIMAL(5, 2),
GenreId INT NOT NULL FOREIGN KEY(GenreId) REFERENCES Genres(Id),
CategoryId INT NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
Rating DECIMAL(3,1),
Notes NVARCHAR(MAX)
)

INSERT INTO Directors(DirectorName, Notes)
VALUES('Ivo Nelov', 'dlkfhsiudfsdgkahdkhhsfkhv'),
	  ('rgdff', 'dlkfhsiudfsdgkahdkhhsfkhv'),
	  ('fffffv', NULL),
	  ('hjklkl', NULL),
	  ('fghh', 'dlkfhsiudfsdgkahdkhhsfkhv')

INSERT INTO Genres (GenreName, Notes)
VALUES('Drama', 'bulshet'),
	  ('Horor', 'ddvjvnfj'),
	  ('Comedy', 'dd'),
	  ('SetCom', 'l;kl;'),
	  ('Porn', 'jjjjjj')

INSERT INTO Categories(CategoryName, Notes)
VALUES('one', '1'),
	  ('two', '2'),
	  ('Tree', '3'),
	  ('Four', '4'),
	  ('Five', '5')

INSERT INTO Movies(Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes)
VALUES('Title 1', 2, 2000, 90.00, 3, 1, 5.00, 'fshgfjfffffffffffffffj'),
	  ('Title 2', 1, 2010, 120.00, 2, 2, 5.00, 'fshgfjfffffffffffffffj'),
	  ('Title 3', 3, 1995, 93.15, 1, 3, 5.00, 'fshgfjfffffffffffffffj'),
	  ('Title 4', 4, 1987, 92.00, 4, 4, 5.00, 'fshgfjfffffffffffffffj'),
	  ('Title 5', 5, 2018, 100.00, 5, 5, 5.00, 'fshgfjfffffffffffffffj')

-- 14 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY(1,1),
CategoryName NVARCHAR(50) NOT NULL,
DailyRate DECIMAL(5,2) NOT NULL,
WeeklyRate DECIMAL(5,2) NOT NULL,
MonthlyRate DECIMAL(5,2) NOT NULL,
WeekendRate DECIMAL(5,2) NOT NULL
)

CREATE TABLE Cars (
Id INT PRIMARY KEY IDENTITY(1,1),
PlateNumber NVARCHAR(10) NOT NULL,
Manufacturer NVARCHAR(50) NOT NULL,
Model NVARCHAR(50) NOT NULL,
CarYear SMALLINT NOT NULL,
CategoryId INT NOT NULL,
Doors SMALLINT NOT NULL,
Picture VARBINARY CHECK(DATALENGTH(Picture) <= 10 * 1024),
Condition NVARCHAR(100) NOT NULL,
Available NVARCHAR(50) NOT NULL
) 

ALTER TABLE Cars
ADD CONSTRAINT FK_CategoryId
FOREIGN KEY(CategoryId) REFERENCES Categories(Id)

CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Title NVARCHAR(20) nOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers (
Id INT PRIMARY KEY IDENTITY(1,1),
DriverLicenceNumber NVARCHAR(50) NOT NULL,
FullName NVARCHAR(100) NOT NULL,
[Address] NVARCHAR(100),
City NVARCHAR(50),
ZIPCode SMALLINT NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RentalOrders (
Id INT PRIMARY KEY IDENTITY(1,1),
EmployeeId INT NOT NULL,
CustomerId INT NOT NULL,
CarId INT NOT NULL,
TankLevel NVARCHAR(20) NOT NULL,
KilometrageStart INT NOT NULL,
KilometrageEnd INT NOT NULL,
TotalKilometrage INT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
TotalDays SMALLINT NOT NULL,
RateApplied DECIMAL(6,2) NOT NULL,
TaxRate DECIMAL(6,2) NOT NULL,
OrderStatus NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_EmployeeId
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_CustomerId
FOREIGN KEY (CustomerId) REFERENCES Customers(Id)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('fsdv', 25.00, 100.00, 100.00, 35.00),
	  ('ffff', 25.00, 100.00, 100.00, 35.00),
	  ('gggg', 25.00, 100.00, 100.00, 35.00)
	  

INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES('fsdfsd', 'sdfsd', 'sddsfsdfds', 2000, 3, 4, NULL, 'Good', 'Available'),
	  ('fsdfsd', 'sdfsd', 'sddsfsdfds', 2000, 3, 4, NULL, 'Good', 'Available'),
	  ('fsdfsd', 'sdfsd', 'sddsfsdfds', 2000, 3, 4, NULL, 'Good', 'Available')

INSERT INTO Employees(FirstName, LastName, Title, Notes)
VALUES('fffff', 'ggggg', 'sdfsdfds', Null),
	  ('sssss', 'ccccc', 'vvvvvvvv', 'klklkjlkknk'),
	  ('wwwww', 'eeeee', 'rrrrrrrr', NULL)
	  
INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
VALUES('BH8789687KS', 'lisi fgfgs', 'sdgffgfgdf 34 ', 'Vratza', 3000, NULL),
	  ('BR6131663KS', 'afdv fgfdgfd', 'hjghg 67 ', 'Vratza', 3000, NULL),
	  ('BR5645123KS', 'wfugfsjkdb ugfghsf', 'hjghg 67 ', 'Vratza', 3000, NULL)

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES(1, 2, 3, 'Full', 200000, 200001, 200000, '20190117', '20190120', 3, 25.00, 20, 'Complited', NULL),
	  (1, 2, 3, 'Full', 200000, 200001, 200000, '20190117', '20190120', 3, 25.00, 20, 'Complited', NULL),
	  (1, 2, 3, 'Full', 200000, 200001, 200000, '20190117', '20190120', 3, 25.00, 20, 'Complited', NULL)

-- 15 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Title NVARCHAR(100) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers (
AccountNumber INT PRIMARY KEY NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
PhoneNumber INT NOT NULL,
EmergencyName NVARCHAR(50),
EmergencyNumber INT,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomStatus (
RoomStatus NVARCHAR(20) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomTypes (
RoomType NVARCHAR(20) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE BedTypes (
BedType NVARCHAR(20) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Rooms (
RoomNumber INT PRIMARY KEY NOT NULL,
RoomType NVARCHAR(20) NOT NULL FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
BedType NVARCHAR(20) NOT NULL FOREIGN KEY(BedType) REFERENCES BedTypes(BedType),
Rate DECIMAL(5,2) NOT NULL,
RoomStatus NVARCHAR(20) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Payments (
Id INT PRIMARY KEY IDENTITY(1,1),
EmployeeId INT NOT NULL FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
PaymentDate DATE NOT NULL,
AccountNumber INT NOT NULL,
FirstDateOccupied DATE NOT NULL,
LastDateOccupied DATE NOT NULL,
TotalDays INT NOT NULL,
AmountCharged DECIMAL(5,2),
TaxRate DECIMAL(5,2),
TaxAmount DECIMAL(5,2),
PaymentTotal DECIMAL(5,2),
Notes NVARCHAR(MAX)
)

CREATE TABLE Occupancies (
Id INT PRIMARY KEY IDENTITY(1,1),
EmployeeId INT NOT NULL FOREIGN KEY(EmployeeId) REFERENCES Employees(Id),
DateOccupied DATE NOT NULL,
AccountNumber INT NOT NULL,
RoomNumber SMALLINT NOT NULL,
RateApplied DECIMAL(5,2),
PhoneCharge DECIMAL(5,2),
Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES('dsfad', 'adcdsc', 'dsds', 'fvfvvvvvvvvvvvvvvvvvvvv'),
	  ('dsfad', 'adcdsc', 'dsds', 'fvfvvvvvvvvvvvvvvvvvvvv'),
	  ('dsfad', 'adcdsc', 'dsds', 'fvfvvvvvvvvvvvvvvvvvvvv')

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES(123456789, 'asdds', 'svff', 512154521, 'gfsgfsd sfgsfsdf', 551155121, 'sdfsdsd'),
	  (123456790, 'asdds', 'svff', 512154521, 'gfsgfsd sfgsfsdf', 551155121, 'sdfsdsd'),
	  (123456791, 'asdds', 'svff', 512154521, 'gfsgfsd sfgsfsdf', 551155121, 'sdfsdsd')

INSERT INTO RoomStatus (RoomStatus, Notes)
VALUES('sdsvfsavcv', NULL),
	  ('sdsvfsavck', NULL),
	  ('sdsvfsavcn', NULL)

INSERT INTO RoomTypes (RoomType, Notes)
VALUES('dsfvsf', NULL),
	  ('dsfvsl', NULL),
	  ('dsfvsp', NULL)

INSERT INTO BedTypes (BedType, Notes)
VALUES('svghjgm', NULL),
	  ('svghjgn', NULL),
	  ('svghjgo', NULL)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES(21, 'dsfvsf', 'svghjgm', 52.20, 'sdsvfsavcv', NULL),
	  (22, 'dsfvsf', 'svghjgm', 52.20, 'sdsvfsavcv', NULL),
	  (23, 'dsfvsf', 'svghjgm', 52.20, 'sdsvfsavcv', NULL)

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
VALUES(1, '20190120', 513213135, '20190111', '20190120', 8, 52.20, 20.00, 10.00, 52.00, NULL),
	  (2, '20190120', 513213135, '20190111', '20190120', 8, 52.20, 20.00, 10.00, 52.00, NULL),
	  (3, '20190120', 513213135, '20190111', '20190120', 8, 52.20, 20.00, 10.00, 52.00, NULL)

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES(1, '20190111', 513213135, 21, 52.20, 0, NULL),
	  (1, '20190111', 513213135, 21, 52.20, 0, NULL),
	  (1, '20190111', 513213135, 21, 52.20, 0, NULL)




-- 16 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns(
Id INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(50)
)

CREATE TABLE Addresses(
Id INT PRIMARY KEY IDENTITY(1,1),
AddressText NVARCHAR(100) NOT NULL,
TownId INT
)

ALTER TABLE Addresses
ADD CONSTRAINT FK_TownsId_Towns
FOREIGN KEY (TownId) REFERENCES Towns(Id)

CREATE TABLE Departments(
Id INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
JobTitle NVARCHAR(50) NOT NULL,
DepartmentId INT NOT NULL,
HireDate DATE NOT NULL,
Salary INT NOT NULL,
AddressId INT NOT NULL
)

ALTER TABLE Employees
ADD CONSTRAINT FK_DepartmentId_Departments
FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)

ALTER TABLE Employees
ADD CONSTRAINT FK_AddressId_Addresses
FOREIGN KEY (AddressId) REFERENCES Addresses(Id)

EXEC sp_spaceused @updateusage = N'TRUE'; 

-- 18 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO Towns (Name) 
VALUES('Sofia'),
	  ('Plovdiv'),
	  ('Varna'), 
	  ('Burgas')

INSERT INTO Departments(Name) 
VALUES('Engineering'),
	  ('Sales'),
	  ('Marketing'),
	  ('Software Development'), 
	  ('Quality Assurance')

INSERT INTO Addresses(AddressText, [TownId])
VALUES('sgdhfgjhgfhf', 1),
	  ('hgfjkhj', 2),
	  ('ggkjhg', 3),
	  ('aaaa', 4),
	  ('uuuu', 4)

INSERT INTO Employees (FirstName, MiddleName, LastName, [JobTitle], [DepartmentId], [HireDate], [Salary], [AddressId])
 VALUES('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '20130201', 3500.00 , 1),
	  ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '20040302', 4000.00 , 2),
	  ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '20160828', 525.25 , 3),
	  ('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '20071209', 3000.00 , 4),
	  ('Peter', 'Pan', 'Pan', 'Intern', 3, '20160828', 599.88 , 5)

	  
-- 19 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

-- 20 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT [Name] FROM Towns
ORDER BY Name

SELECT [Name] FROM Departments
ORDER BY Name

SELECT FirstName, LastName, JobTitle, Salary FROM Employees


-- 21 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT [Name] FROM Towns
ORDER BY Name

SELECT [Name] FROM Departments
ORDER BY Name

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC

-- 22 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UPDATE Employees
SET Salary += Salary * 0.1

SELECT Salary From Employees

-- 23 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USE Hotel

UPDATE Payments
SET TaxRate -= TaxRate * 0.03

SELECT TaxRate FROM Payments

-- 23 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

TRUNCATE TABLE [dbo].[Occupancies]