-- Tạo database
CREATE DATABASE EmployeeDB3;
USE EmployeeDB3;

-- Tạo bảng Employees
CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    Salary INT
);

-- Thêm dữ liệu
INSERT INTO Employees (EmpId, FullName, Position, Salary) VALUES
(101, 'Nguyễn Văn Tuấn', 'Developer', 1500),
(102, 'Trần Mai Phương', 'Designer', 1200),
(103, 'Lê Quốc Bảo', 'Tester', 1000),
(104, 'Phạm Hải Yến', 'HR Manager', 1800),
(105, 'Hoàng Minh Trí', 'Marketing', 1300),
(106, 'Đặng Thị Hoa', 'Accountant', 1400),
(107, 'Vũ Hoàng Anh', 'Sales', 1100);

-- =====================================
-- Bước 1: Lấy 3 bản ghi đầu tiên (Trang 1)
SELECT *
FROM Employees
LIMIT 3;

-- =====================================
-- Bước 2: Trang 2 (bỏ qua 3 dòng đầu, lấy 3 dòng tiếp)
SELECT *
FROM Employees
LIMIT 3 OFFSET 3;