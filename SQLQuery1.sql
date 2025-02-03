SELECT T.Name, T.Surname, G.Name AS GroupName
FROM Teachers T, Groups G

SELECT F.Name AS FacultyName
FROM Faculties F
JOIN Departments D ON F.Id = D.FacultyId
GROUP BY F.Id, F.Name, F.Financing
HAVING SUM(D.Financing) > F.Financing;

SELECT C.Surname AS CuratorSurname, G.Name AS GroupName
FROM GroupsCurators GC
JOIN Curators C ON GC.CuratorId = C.Id
JOIN Groups G ON GC.GroupId = G.Id;

SELECT T.Name, T.Surname
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON GL.GroupId = G.Id
WHERE G.Name = 'FSDA_1_24_2_ru';

SELECT T.Surname AS TeacherSurname, F.Name AS FacultyName
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN Subjects S ON L.SubjectId = S.Id
JOIN Departments D ON S.Id = D.Id
JOIN Faculties F ON D.FacultyId = F.Id;

SELECT D.Name AS DepartmentName, G.Name AS GroupName
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id;

SELECT S.Name AS SubjectName
FROM Subjects S
JOIN Lectures L ON S.Id = L.SubjectId
JOIN Teachers T ON L.TeacherId = T.Id
WHERE T.Name = 'Huseyn' AND T.Surname = 'Ismayilov';

SELECT D.Name AS DepartmentName
FROM Departments D
JOIN Groups G ON D.Id = G.DepartmentId
JOIN GroupsLectures GL ON G.Id = GL.GroupId
JOIN Lectures L ON GL.LectureId = L.Id
JOIN Subjects S ON L.SubjectId = S.Id
WHERE S.Name = 'Writing';

SELECT G.Name AS GroupName
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'Python';

SELECT G.Name AS GroupName, F.Name AS FacultyName
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE G.Year = 2;

SELECT T.Name AS TeacherName, T.Surname AS TeacherSurname, 
       S.Name AS SubjectName, G.Name AS GroupName
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN Subjects S ON L.SubjectId = S.Id
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON GL.GroupId = G.Id
WHERE L.LectureRoom = '1A';
