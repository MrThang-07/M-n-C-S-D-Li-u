-- Tạo database
CREATE DATABASE EmployeeDB2;
USE EmployeeDB2;

-- Tạo bảng Employees
CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary INT,
    DeptId INT,
    Phone VARCHAR(15)
);

-- Thêm dữ liệu
INSERT INTO Employees (EmpId, EmpName, Salary, DeptId, Phone) VALUES
(101, 'Nguyễn Thị Mai', 800, 1, '0901112233'),
(102, 'Trần Văn Hùng', 400, 2, '0912223344'),
(103, 'Lê Hoàng Phúc', 1500, 1, '0923334455'),
(104, 'Nguyễn Tuấn Anh', 2500, 3, '0934445566'),
(105, 'Phạm Trà My', 600, 2, '0945556677');

-- =====================================
-- Bước 1: Lọc Salary > 800
SELECT *
FROM Employees
WHERE Salary > 800;

-- =====================================
-- Bước 2: Lọc khoảng 500 -> 1500
SELECT *
FROM Employees
WHERE Salary BETWEEN 500 AND 1500;

-- =====================================
-- Bước 3: Lọc phòng ban 1 và 3
SELECT *
FROM Employees
WHERE DeptId IN (1, 3);

-- =====================================
-- Bước 4: Tìm họ "Nguyễn"
SELECT *
FROM Employees
WHERE EmpName LIKE 'Nguyễn%';

-- =====================================
-- Bước 5: Phân loại mức lương
SELECT 
    EmpId,
    EmpName,
    Salary,
    CASE 
        WHEN Salary < 500 THEN 'Thực tập'
        WHEN Salary < 1000 THEN 'Nhân viên'
        WHEN Salary < 2000 THEN 'Trưởng nhóm'
        ELSE 'Quản lý'
    END AS SalaryLevel
FROM Employees;