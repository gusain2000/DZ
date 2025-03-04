CREATE DATABASE Triggers3;
GO
Use Triggers3;
 
CREATE TABLE Student (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(255),
    GroupId INT,
    Grade INT CHECK (Grade BETWEEN 0 AND 12) 
);
 
 
CREATE TABLE Groups (
    GroupId INT PRIMARY KEY,
    GroupName VARCHAR(255),
    StudentsCount INT
);
 
CREATE TABLE Course (
    CourseId INT PRIMARY KEY,
    CourseName VARCHAR(255)
);
 
CREATE TABLE Grade (
    GradeId INT PRIMARY KEY,
    StudentId INT,
    CourseId INT,
    Grade INT CHECK (Grade BETWEEN 0 AND 12),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId),
    FOREIGN KEY (CourseId) REFERENCES Course(CourseId)
);
 
CREATE TABLE Attendance (
    AttendanceId INT PRIMARY KEY,
    StudentId INT,
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);
 
CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    StudentId INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);
 
CREATE TABLE Warnings (
    WarningId INT PRIMARY KEY,
    StudentId INT,
    Reason VARCHAR(255),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);
 
INSERT INTO Groups (GroupId, GroupName)
VALUES
(1, 'Group A');
 
INSERT INTO Student (StudentId, Name, GroupId, Grade)
VALUES
(1, 'Huseyn', 1, 9),
(2, 'Rustam', 1, 7),
(3, 'Ilkin', 1, 10),
(4, 'Sabina', 1, 6),
(5, 'Ramin', 1, 8),
(6, 'Rauf', 1, 11);
 
INSERT INTO Student (StudentId, Name, GroupId, Grade)
VALUES
(7, 'Isa', 1, 5);
 
INSERT INTO Student (StudentId, Name, GroupId, Grade)
VALUES
(8, 'asdasd', 1, 5);
 
INSERT INTO Course (CourseId, CourseName)
VALUES
(1, N'Введение в программирование'),
(2, 'Python'),
(3, 'C');
 
INSERT INTO Grade (GradeId, StudentId, CourseId, Grade)
VALUES
(1, 1, 1, 9),
(2, 1, 2, 8),
(3, 2, 1, 7),
(4, 2, 3, 6),
(5, 3, 1, 10),
(6, 4, 2, 8), 
(7, 5, 3, 7),
(8, 6, 1, 11);
 
INSERT INTO Attendance (AttendanceId, StudentId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);
 
INSERT INTO Payments (PaymentId, StudentId, Amount)
VALUES
(1, 1, 1000.00),
(2, 2, 1500.00),
(3, 3, 1200.00),
(4, 4, 1300.00),
(5, 5, 1100.00),
(6, 6, 1400.00);
 
 
CREATE TRIGGER CheckGroupStudentsCount
On Student
FOR INSERT
AS
BEGIN
    IF (SELECT COUNT(*) FROM Student
        INNER JOIN [Groups] on [Groups].GroupId = Student.GroupId) >= 8
        print(N'Group is full!');
        ROLLBACK TRANSACTION;
END
 
CREATE TRIGGER UpdateGroupStudentCount
ON Student
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE Groups
    SET StudentsCount = (SELECT COUNT(*) FROM Student WHERE GroupId = Groups.GroupId)
    WHERE GroupId IN (SELECT DISTINCT GroupId FROM inserted UNION SELECT DISTINCT GroupId FROM deleted);
END;

CREATE TRIGGER AutoRegistrationToCourse
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO Grade (StudentId, CourseId, Grade)
    SELECT inserted.StudentId, Course.CourseId, NULL
    FROM inserted, Course
    WHERE Course.CourseName = N'Введение в программирование';
END;

CREATE TRIGGER LowGradeWarning
ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO Warnings (StudentId, Reason)
    SELECT StudentId, N'Низкая оценка' FROM inserted WHERE Grade < 3;
END;

CREATE TRIGGER SaveGradeHistory
ON Grade
AFTER UPDATE
AS
BEGIN
    INSERT INTO GradeHistory (StudentId, CourseId, OldGrade, NewGrade, ChangeDate)
    SELECT d.StudentId, d.CourseId, d.Grade, i.Grade, GETDATE()
    FROM deleted d
    JOIN inserted i ON d.StudentId = i.StudentId AND d.CourseId = i.CourseId;
END;

CREATE TRIGGER MissedLessons
ON Attendance
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT StudentId FROM Attendance WHERE StudentId IN (SELECT StudentId FROM inserted)
               GROUP BY StudentId HAVING COUNT(*) > 5)
    BEGIN
        PRINT N'Студент пропустил более 5 занятий!';
    END
END;

CREATE TRIGGER StudentDeletionStop
ON Student
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Payments WHERE StudentId IN (SELECT StudentId FROM deleted))
        OR EXISTS (SELECT 1 FROM Grade WHERE StudentId IN (SELECT StudentId FROM deleted) AND Grade < 3)
    BEGIN
        PRINT N'Студент имеет долги или низкие оценки!';
        ROLLBACK TRANSACTION;
    END
    ELSE
        DELETE FROM Student WHERE StudentId IN (SELECT StudentId FROM deleted);
END;

CREATE TRIGGER StudentAverageScoreUpdate
ON Grade
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Student
    SET Grade = (SELECT AVG(Grade) FROM Grade WHERE StudentId = Student.StudentId)
    WHERE StudentId IN (SELECT DISTINCT StudentId FROM inserted UNION SELECT DISTINCT StudentId FROM deleted);
END;
