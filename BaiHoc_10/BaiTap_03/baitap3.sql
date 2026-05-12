CREATE DATABASE IF NOT EXISTS HospitalManagement1;
USE HospitalManagement1;

-- Bảng Khoa
CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100)
);

-- Bảng Hóa đơn (Kết nối bệnh nhân và khoa)
CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT,
    Dept_ID INT,
    Amount DECIMAL(10, 2)
);

-- Chèn dữ liệu mẫu
INSERT INTO Departments VALUES (1, 'Nội'), (2, 'Ngoại');
INSERT INTO Invoices VALUES 
(101, 1, 1, 500.00), 
(102, 2, 1, 300.00), 
(103, 3, 2, 1000.00);


CREATE VIEW Department_Revenue_View AS
SELECT 
    d.Dept_Name AS 'Tên khoa',
    COUNT(DISTINCT i.Patient_ID) AS 'Tổng số bệnh nhân',
    SUM(i.Amount) AS 'Tổng doanh thu'
FROM 
    Departments d
JOIN 
    Invoices i ON d.Dept_ID = i.Dept_ID
GROUP BY 
    d.Dept_ID, 
    d.Dept_Name;
    
    
    
SELECT * FROM Department_Revenue_View;

-- Thử cập nhật doanh thu của khoa Nội
UPDATE Department_Revenue_View
SET `Tổng doanh thu` = 9999.00
WHERE `Tên khoa` = 'Nội';

-- Error Code: 1288. The target table Department_Revenue_View of the UPDATE is not updatable	0.016 sec