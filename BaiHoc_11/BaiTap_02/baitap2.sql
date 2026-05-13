CREATE DATABASE RikkeiClinicDBbt2;
USE RikkeiClinicDBbt2;

-- PHẦN 1: KHỞI TẠO CẤU TRÚC BẢNG 

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 2. Bảng Nhân sự / Bác sĩ (Employees)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

-- 3. Bảng Khoa (Departments)
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Giường bệnh (Beds)
CREATE TABLE Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL, -- NULL nghĩa là giường trống
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 5. Bảng Lịch khám (Appointments)
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Completed', 'Cancelled'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

-- 6. Bảng Kho Vật tư Y tế (Inventory)
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- Chèn Bệnh nhân
INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

-- Chèn Nhân sự 
INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

-- Chèn Khoa
INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi'),
(3, 'Khoa ICU');

-- Chèn Giường bệnh
INSERT INTO Beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),    -- Bệnh nhân 1 đang nằm giường 101 Khoa Ngoại
(201, 2, NULL), -- Giường 201 Khoa Nội đang trống
(301, 3, 2);    -- Bệnh nhân 2 đang nằm ICU

-- Chèn Lịch khám 
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

-- Chèn Vật tư 
INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

-- PHẦN A: PHÂN TÍCH LỖI


-- 1.  procedure cũ đang bị lỗi

DELIMITER //

CREATE PROCEDURE AddInventory(
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE Inventory
    SET stock_quantity = stock_quantity + p_quantity
    WHERE item_id = p_item_id;
END //

DELIMITER ;

-- 2. CALL tái hiện lỗi
-- Nhân viên nhập nhầm số lượng âm -500

CALL AddInventory(10, -500);

-- 3. Kiểm tra tồn kho sau khi lỗi xảy ra

SELECT *
FROM Inventory
WHERE item_id = 10;


-- GIẢI THÍCH LỖI

-- Procedure hiện tại cộng trực tiếp p_quantity vào tồn kho
-- mà không kiểm tra dữ liệu đầu vào.
-- Khi truyền số âm, phép cộng trở thành phép trừ,
-- làm số lượng vật tư trong kho bị giảm sai.


-- PHẦN B: SỬA MÃ NGUỒN


-- 1. Xóa procedure cũ

DROP PROCEDURE IF EXISTS AddInventory;

-- 2. Tạo lại procedure đúng logic

DELIMITER //

CREATE PROCEDURE AddInventory(
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    -- Chỉ cho phép nhập kho khi số lượng > 0

    IF p_quantity > 0 THEN

        UPDATE Inventory
        SET stock_quantity = stock_quantity + p_quantity
        WHERE item_id = p_item_id;

    END IF;

END //

DELIMITER ;


-- KIỂM THỬ SAU KHI FIX


-- Test 1: Nhập hợp lệ

CALL AddInventory(10, 200);

SELECT *
FROM Inventory
WHERE item_id = 10;

-- Test 2: Nhập sai số âm
-- Không được cập nhật kho

CALL AddInventory(10, -500);

SELECT *
FROM Inventory
WHERE item_id = 10;