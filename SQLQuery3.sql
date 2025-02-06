IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Academy4')    CREATE DATABASE Academy4;
GO
USE Academy4;
CREATE TABLE Teachers
(   [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [Name] nvarchar(max) NOT NULL CHECK (LEN([Name]) >= 1),    
	[Surname] nvarchar(max) NOT NULL CHECK (LEN([Surname]) >= 1),
    [EmploymentDate] date NOT NULL CHECK (EmploymentDate >= '1990-01-01'),    
	[Premium] money NOT NULL DEFAULT 0 CHECK (Premium >= 0),
	[Position] nvarchar(max) NOT NULL,
	[IsAssistant] bit DEFAULT 0,
	[IsProfessor] bit DEFAULT 0,
    [Salary] money NOT NULL CHECK (Salary > 0));
CREATE TABLE Groups
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,    
	[Name] nvarchar(10) UNIQUE NOT NULL CHECK (LEN([Name]) >= 1),
    [Rating] int NOT NULL CHECK (Rating >= 0 AND Rating <= 5),    
	[Year] int NOT NULL CHECK (Year >= 1 AND Year <= 5)
);
CREATE TABLE Departments(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,    
	[Name] nvarchar(100) UNIQUE NOT NULL CHECK (LEN([Name]) >= 1),
    [Financing] money NOT NULL DEFAULT 0 CHECK (Financing >= 0));
CREATE TABLE Faculties
(    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[Dean]nvarchar(max) NOT NULL CHECK (LEN([Dean]) >=1),  
    [Name] nvarchar(100) UNIQUE NOT NULL CHECK (LEN([Name]) >= 1));

INSERT INTO Teachers(Name, Surname, EmploymentDate, Premium, Position, IsAssistant, IsProfessor, Salary)
VALUES (N'Huseyn',N'Ismayilov','2005-02-12',5000,N'Python Teacher',0,1,25000),
	   (N'Rustam',N'Farzaliyev','2008-05-06',2000,N'English Teacher',1,0,15000);

INSERT INTO Teachers(Name, Surname, EmploymentDate, Premium, Position, IsAssistant, IsProfessor, Salary)
VALUES (N'Farid',N'Nuriyev','1999-02-12',200,N'Python Teacher',0,1,900);
	   


UPDATE Academy4.[dbo].Teachers
Set Premium = 250
Where Id = 2;

INSERT INTO Groups(Name,Rating,Year)
VALUES (N'700B',3,2),
	   (N'200A',1,3);

INSERT INTO Departments(Name,Financing)
VALUES (N'Programming',50000),
	   (N'Languages',35000)

INSERT INTO Departments(Name,Financing)
VALUES  (N'Wordpress',15000);

INSERT INTO Faculties(Dean,Name)
VALUES (N'Huseyn',N'Python'),
	   (N'Sabina',N'English');

SELECT * from Departments
Order by Financing;

Select Name, Rating from Groups

Select 'The dean of faculty of ' + Name +' is ' + Dean
FROM Faculties

SELECT Surname from Teachers
WHERE IsProfessor = 1 AND Salary>16000;

SELECT Name from Departments
Where Financing <11000 or Financing>25000;

SELECT Name 
FROM Faculties
WHERE Name <> 'English'

SELECT Name, Position from Teachers
Where IsProfessor = 0;

SELECT Surname, Position, Salary, Premium from Teachers
Where IsAssistant = 1 AND Premium >160 and Premium <500;

SELECT Surname, Salary from Teachers
Where IsAssistant = 1;

SELECT Surname, Position from Teachers
Where EmploymentDate < '01.01.2000'; 

SELECT Surname from Teachers
GROUP BY Surname
Having SUM(Salary + Premium) <1200;

SELECT Name from Groups
Where Year = 5 and Rating >= 2 and Rating <=5;

SELECT Surname from Teachers
Where IsAssistant = 1 and Salary <550 or Premium <200;