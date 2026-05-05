-- Tạo database
CREATE DATABASE EmployeeDB;
USE EmployeeDB;

-- Tạo bảng Employees
CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Phone VARCHAR(15),
    Department VARCHAR(50)
);

-- Thêm dữ liệu mẫu
INSERT INTO Employees (ID, EmpName, Phone, Department) VALUES
(101, 'Nguyen Van Anh', '0901234567', 'IT'),
(102, 'Tran Thi Bich', '0912345678', 'HR'),
(103, 'Le Van Chi', '0923456789', 'Marketing');

-- =========================
-- Bước 1: Lấy toàn bộ dữ liệu
SELECT * 
FROM Employees;

-- =========================
-- Bước 2: Lấy cột theo thứ tự yêu cầu
SELECT EmpName, Phone, ID, Department
FROM Employees;

-- =========================
-- Bước 3: Đặt Alias tiếng Việt
SELECT 
    ID AS 'Mã nhân viên',
    EmpName AS 'Tên nhân viên',
    Phone AS 'Số điện thoại',
    Department AS 'Phòng ban'
FROM Employees;