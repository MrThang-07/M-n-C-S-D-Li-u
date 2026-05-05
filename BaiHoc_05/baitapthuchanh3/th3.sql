-- Tạo database
CREATE DATABASE StudentDB;
USE StudentDB;

-- Tạo bảng Students
CREATE TABLE Students (
    StudentId INT PRIMARY KEY,
    FullName VARCHAR(100),
    Major VARCHAR(50),
    Gpa DECIMAL(3,1)
);

-- Thêm dữ liệu
INSERT INTO Students (StudentId, FullName, Major, Gpa) VALUES
(101, 'Lê Quốc Bảo', 'IT', 8.5),
(102, 'Trần Mai Phương', 'Design', 7.2),
(103, 'Nguyễn Văn Tuấn', 'IT', 9.1),
(104, 'Phạm Hải Yến', 'Design', 8.8),
(105, 'Hoàng Minh Trí', 'Marketing', 7.5);

-- =====================================
-- Bước 1: Sắp xếp mặc định (tăng dần)
SELECT *
FROM Students
ORDER BY Gpa;

-- =====================================
-- Bước 2: Sắp xếp giảm dần (cao -> thấp)
SELECT *
FROM Students
ORDER BY Gpa DESC;

-- =====================================
-- Bước 3: Sắp xếp tăng dần (ASC)
SELECT *
FROM Students
ORDER BY Gpa ASC;