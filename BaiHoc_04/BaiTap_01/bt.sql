CREATE DATABASE course;
USE course;

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    birthday DATE,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(255) NOT NULL,
    description TEXT,
    total_sessions INT NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

CREATE TABLE score (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    midterm_score DECIMAL(4,2) CHECK (midterm_score >= 0 AND midterm_score <= 10),
    final_score DECIMAL(4,2) CHECK (final_score >= 0 AND final_score <= 10),
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

INSERT INTO student (fullname, birthday, email)
VALUES
('Nguyen Van A', '2003-05-10', 'a@gmail.com'),
('Tran Thi B', '2002-08-15', 'b@gmail.com'),
('Le Van C', '2001-11-20', 'c@gmail.com'),
('Pham Thi D', '2003-03-12', 'd@gmail.com'),
('Hoang Van E', '2002-07-25', 'e@gmail.com');

INSERT INTO teacher (fullname, email)
VALUES
('Nguyen Teacher 1', 'teacher1@gmail.com'),
('Tran Teacher 2', 'teacher2@gmail.com'),
('Le Teacher 3', 'teacher3@gmail.com'),
('Pham Teacher 4', 'teacher4@gmail.com'),
('Hoang Teacher 5', 'teacher5@gmail.com');

INSERT INTO course (course_name, description, total_sessions, teacher_id)
VALUES
('SQL Basic', 'Hoc co ban ve SQL', 20, 1),
('Java Core', 'Lap trinh Java co ban', 25, 2),
('Web HTML CSS', 'Thiet ke giao dien web', 18, 3),
('JavaScript', 'Lap trinh frontend JS', 22, 4),
('Database Design', 'Thiet ke co so du lieu', 15, 5);

INSERT INTO enrollment (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2026-04-01'),
(1, 2, '2026-04-02'),
(2, 1, '2026-04-03'),
(3, 3, '2026-04-04'),
(4, 4, '2026-04-05');

INSERT INTO score (student_id, course_id, midterm_score, final_score)
VALUES
(1, 1, 8.5, 9.0),
(1, 2, 7.5, 8.0),
(2, 1, 9.0, 9.5),
(3, 3, 6.5, 7.0),
(4, 4, 8.0, 8.8);

UPDATE student
SET email = 'newemail@gmail.com'
WHERE student_id = 1;

UPDATE course
SET description = 'Cap nhat mo ta moi cho khoa hoc SQL'
WHERE course_id = 1;

UPDATE score
SET final_score = 9.8
WHERE student_id = 1 AND course_id = 1;

DELETE FROM enrollment
WHERE enrollment_id = 5;

DELETE FROM score
WHERE student_id = 4 AND course_id = 4;

SELECT * FROM student;

SELECT * FROM teacher;

SELECT * FROM course;

SELECT * FROM enrollment;

SELECT * FROM score;