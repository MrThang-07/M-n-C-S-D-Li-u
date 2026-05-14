CREATE DATABASE StudentDB;
USE StudentDB;

CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),

    FOREIGN KEY (DeptID)
    REFERENCES Department(DeptID)
);

CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2),

    PRIMARY KEY (StudentID, CourseID),

    FOREIGN KEY (StudentID)
    REFERENCES Student(StudentID),

    FOREIGN KEY (CourseID)
    REFERENCES Course(CourseID)
);

INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','Programming Fundamentals',4),
('C00003','Accounting Principles',3),
('C00004','Business Management',3),
('C00005','Web Development',4);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00002','C00001',9.0),
('S00003','C00004',7.5),
('S00004','C00003',8.0),
('S00005','C00001',9.2),
('S00006','C00004',6.8),
('S00007','C00003',8.7),
('S00008','C00001',7.9),
('S00001','C00002',8.8),
('S00002','C00005',9.1),
('S00005','C00005',8.9),
('S00008','C00002',9.3);

CREATE VIEW ViewStudentBasic AS

SELECT 
    s.StudentID,
    s.FullName,
    d.DeptName

FROM Student s

JOIN Department d
ON s.DeptID = d.DeptID;

SELECT * FROM ViewStudentBasic;

CREATE INDEX idxFullName
ON Student(FullName);

DELIMITER $$

CREATE PROCEDURE GetStudentsIT()

BEGIN

    SELECT 
        s.*,
        d.DeptName

    FROM Student s

    JOIN Department d
    ON s.DeptID = d.DeptID

    WHERE d.DeptName = 'Information Technology';

END $$

DELIMITER ;

CALL GetStudentsIT();

DROP VIEW IF EXISTS ViewStudentCountByDept;

CREATE VIEW ViewStudentCountByDept AS

SELECT 
    d.DeptName,
    COUNT(s.StudentID) AS TotalStudents

FROM Department d

LEFT JOIN Student s
ON s.DeptID = d.DeptID

GROUP BY d.DeptName;

SELECT * FROM ViewStudentCountByDept;

SELECT *
FROM ViewStudentCountByDept
ORDER BY TotalStudents DESC
LIMIT 1;

DELIMITER $$

CREATE PROCEDURE GetStudentsPaging(
    IN p_limit INT,
    IN p_offset INT
)

BEGIN

    SELECT *
    FROM Student

    LIMIT p_limit OFFSET p_offset;

END $$

DELIMITER ;

CALL GetStudentsPaging(3,0);