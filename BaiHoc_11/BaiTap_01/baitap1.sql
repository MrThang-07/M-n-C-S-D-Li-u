CREATE DATABASE RikkeiClinicDBbt1;
USE RikkeiClinicDBbt1;

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


-- PHẦN 2: CHÈN DỮ LIỆU MẪU (TEST CASES)
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


-- PHẦN A: PHÂN TÍCH LỖI


-- 1. Stored Procedure cũ đang bị lỗi logic

DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    UPDATE Appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id;
END //

DELIMITER ;

-- 2. Gọi thủ tục để tái hiện lỗi


CALL CancelAppointment(105);

-- 3. Kiểm tra dữ liệu sau khi gọi procedure

SELECT * 
FROM Appointments
WHERE appointment_id = 105;
-- GIẢI THÍCH LỖI

-- Procedure hiện tại chỉ kiểm tra appointment_id
-- mà không kiểm tra trạng thái lịch khám.
-- Vì vậy các lịch đã Completed vẫn bị cập nhật thành Cancelled,
-- gây sai lệch dữ liệu hệ thống.


-- PHẦN B: SỬA MÃ NGUỒN

-- 1. Xóa thủ tục cũ bị lỗi

DROP PROCEDURE IF EXISTS CancelAppointment;

-- 2. Tạo lại procedure đúng logic

DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    UPDATE Appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id
      AND status = 'Pending';
END //

DELIMITER ;


-- KIỂM THỬ SAU KHI FIX
-- Test 1:
-- appointment_id = 104 đang là Pending
-- => được phép hủy

CALL CancelAppointment(104);

SELECT * 
FROM Appointments
WHERE appointment_id = 104;

-- Test 2:
-- appointment_id = 105 đang là Completed
-- => KHÔNG được phép hủy

CALL CancelAppointment(105);

SELECT * 
FROM Appointments
WHERE appointment_id = 105;
