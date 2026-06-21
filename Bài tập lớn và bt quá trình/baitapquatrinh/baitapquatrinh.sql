-- ========================================================
-- HỆ THỐNG QUẢN LÝ NHÂN SỰ (HR MANAGEMENT)
-- ========================================================

-- Tạo database (bạn có thể bỏ qua 2 dòng này nếu đã có sẵn database)
CREATE DATABASE IF NOT EXISTS HRManagement;
USE HRManagement;

-- ========================================================
-- PHẦN 1: TẠO BẢNG VÀ NHẬP DỮ LIỆU
-- ========================================================

-- 1. Tạo bảng departments (Phòng ban)
CREATE TABLE IF NOT EXISTS departments(
   department_id INT PRIMARY KEY,
   department_name VARCHAR(50)
);

-- Thêm dữ liệu vào bảng departments
INSERT INTO departments VALUES
(1,'IT'),
(2,'HR'),
(3,'Marketing'),
(4,'Finance');

-- 2. Tạo bảng employees (Nhân viên)
CREATE TABLE IF NOT EXISTS employees(
   employee_id INT PRIMARY KEY,
   full_name VARCHAR(100),
   gender VARCHAR(10),
   salary DECIMAL(10,2),
   hire_date DATE,
   department_id INT,
   FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- Thêm dữ liệu vào bảng employees
INSERT INTO employees VALUES
(1,'Nguyen Van An','Male',15000000,'2024-03-15',1),
(2,'Tran Thi Binh','Female',12000000,'2023-08-10',2),
(3,'Le Van Cuong','Male',18000000,'2025-01-20',1),
(4,'Pham Thi Dung','Female',14000000,'2022-11-01',3),
(5,'Hoang Van Em','Male',10000000,'2024-06-15',1),
(6,'Nguyen Thi Giang','Female',16000000,'2025-03-10',2),
(7,'Do Van Hung','Male',9000000,'2024-01-10',4),
(8,'Le Thi Hoa','Female',22000000,'2023-12-01',3),
(9,'Tran Van Khoa','Male',17000000,'2025-04-20',1),
(10,'Pham Thi Lan','Female',11000000,'2024-08-15',2);


-- ========================================================
-- PHẦN 2: ĐÁP ÁN 30 CÂU TRUY VẤN
-- ========================================================

-- Câu 1: Hiển thị: employee_id → Employee ID, full_name → Employee Name, salary → Monthly Salary
SELECT 
    employee_id AS 'Employee ID', 
    full_name AS 'Employee Name', 
    salary AS 'Monthly Salary' 
FROM employees;

-- Câu 2: Hiển thị: Tên nhân viên, Lương năm (salary * 12), Đặt tên cột là: Annual Salary
SELECT 
    full_name, 
    salary * 12 AS 'Annual Salary' 
FROM employees;

-- Câu 3: Hiển thị: Tên nhân viên, Ngày vào làm, Đặt Alias tương ứng: Name, Start Date
SELECT 
    full_name AS 'Name', 
    hire_date AS 'Start Date' 
FROM employees;

-- Câu 4: Đếm tổng số nhân viên trong công ty.
SELECT COUNT(*) AS total_employees FROM employees;

-- Câu 5: Tính tổng quỹ lương của công ty.
SELECT SUM(salary) AS total_salary FROM employees;

-- Câu 6: Tính lương trung bình của công ty.
SELECT AVG(salary) AS avg_salary FROM employees;

-- Câu 7: Tìm mức lương cao nhất.
SELECT MAX(salary) AS max_salary FROM employees;

-- Câu 8: Tìm mức lương thấp nhất.
SELECT MIN(salary) AS min_salary FROM employees;

-- Câu 9: Hiển thị đồng thời: Tổng số nhân viên, Tổng lương, Lương trung bình, Lương cao nhất, Lương thấp nhất
SELECT 
    COUNT(*) AS total_employees, 
    SUM(salary) AS total_salary, 
    AVG(salary) AS avg_salary, 
    MAX(salary) AS max_salary, 
    MIN(salary) AS min_salary 
FROM employees;

-- Câu 10: Đếm số lượng nhân viên của từng phòng ban.
SELECT 
    department_id, 
    COUNT(*) AS total_employee 
FROM employees 
GROUP BY department_id;

-- Câu 11: Tính tổng lương của từng phòng ban.
SELECT 
    department_id, 
    SUM(salary) AS total_salary 
FROM employees 
GROUP BY department_id;

-- Câu 12: Tính lương trung bình của từng phòng ban.
SELECT 
    department_id, 
    AVG(salary) AS avg_salary 
FROM employees 
GROUP BY department_id;

-- Câu 13: Tìm mức lương cao nhất của từng phòng ban.
SELECT 
    department_id, 
    MAX(salary) AS max_salary 
FROM employees 
GROUP BY department_id;

-- Câu 14: Tìm mức lương thấp nhất của từng phòng ban.
SELECT 
    department_id, 
    MIN(salary) AS min_salary 
FROM employees 
GROUP BY department_id;

-- Câu 15: Hiển thị các phòng ban có từ 3 nhân viên trở lên.
SELECT 
    department_id, 
    COUNT(*) AS total_employee 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) >= 3;

-- Câu 16: Hiển thị các phòng ban có tổng lương lớn hơn 35 triệu.
SELECT 
    department_id, 
    SUM(salary) AS total_salary 
FROM employees 
GROUP BY department_id 
HAVING SUM(salary) > 35000000;

-- Câu 17: Hiển thị các phòng ban có lương trung bình lớn hơn 14 triệu.
SELECT 
    department_id, 
    AVG(salary) AS avg_salary 
FROM employees 
GROUP BY department_id 
HAVING AVG(salary) > 14000000;

-- Câu 18: Hiển thị các phòng ban có nhân viên nhiều hơn 2 người và tổng lương trên 30 triệu.
SELECT 
    department_id, 
    COUNT(*) AS total_employee, 
    SUM(salary) AS total_salary 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) > 2 AND SUM(salary) > 30000000;

-- Câu 19: Tìm nhân viên có lương cao nhất.
SELECT * FROM employees 
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Câu 20: Tìm nhân viên có lương thấp nhất.
SELECT * FROM employees 
WHERE salary = (SELECT MIN(salary) FROM employees);

-- Câu 21: Tìm nhân viên có lương lớn hơn lương trung bình của công ty.
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Câu 22: Tìm nhân viên có lương nhỏ hơn lương trung bình của công ty.
SELECT * FROM employees 
WHERE salary < (SELECT AVG(salary) FROM employees);

-- Câu 23: Tìm nhân viên thuộc phòng ban có mã phòng bằng mã phòng của nhân viên "Nguyen Van An".
SELECT * FROM employees 
WHERE department_id = (
    SELECT department_id 
    FROM employees 
    WHERE full_name = 'Nguyen Van An'
);

-- Câu 24: Tìm nhân viên có lương bằng mức lương cao nhất trong công ty.
SELECT * FROM employees 
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Câu 25: Hiển thị: Tên nhân viên, Tên phòng ban
SELECT 
    e.full_name, 
    d.department_name 
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Câu 26: Hiển thị: Tên nhân viên, Giới tính, Tên phòng ban
SELECT 
    e.full_name, 
    e.gender, 
    d.department_name 
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Câu 27: Hiển thị: Tên nhân viên, Lương, Tên phòng ban. Sắp xếp lương giảm dần.
SELECT 
    e.full_name, 
    e.salary, 
    d.department_name 
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY e.salary DESC;

-- Câu 28: Đếm số nhân viên theo tên phòng ban.
SELECT 
    d.department_name, 
    COUNT(e.employee_id) AS total_employee 
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Câu 29: Hiển thị thông vị nhân viên có lương cao nhất trong từng phòng ban.
SELECT 
    e.employee_id, 
    e.full_name, 
    e.salary, 
    d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary) 
    FROM employees e2 
    WHERE e2.department_id = e.department_id
);

-- Câu 30: Hiển thị các phòng ban có lương trung bình cao hơn lương trung bình toàn công ty.
SELECT 
    d.department_name, 
    AVG(e.salary) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);