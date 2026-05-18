

CREATE DATABASE IF NOT EXISTS RikkeiClinicDB;
USE RikkeiClinicDB;

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 2. Bảng Nhân sự / Bác sĩ (Employees)
CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

-- 3. Bảng Khoa (Departments)
CREATE TABLE IF NOT EXISTS Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Giường bệnh (Beds)
CREATE TABLE IF NOT EXISTS Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL, 
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 5. Bảng Lịch khám (Appointments)
CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', 
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

-- 6. Bảng Kho Vật tư Y tế (Inventory)
CREATE TABLE IF NOT EXISTS Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 7. Bảng Kho Thuốc (Medicines)
CREATE TABLE IF NOT EXISTS Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 8. Bảng Công nợ Bệnh nhân (Patient_Invoices)
CREATE TABLE IF NOT EXISTS Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 9. Bảng Sản phẩm (Products)
CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 10. Bảng Dịch vụ khám (Services) 
CREATE TABLE IF NOT EXISTS Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử (Wallets) 
CREATE TABLE IF NOT EXISTS Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', 
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ (Service_Usages) 
CREATE TABLE IF NOT EXISTS Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- Xóa dữ liệu cũ (nếu chạy lại script)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Service_Usages; TRUNCATE TABLE Wallets; TRUNCATE TABLE Services;
TRUNCATE TABLE Products; TRUNCATE TABLE Patient_Invoices; TRUNCATE TABLE Medicines;
TRUNCATE TABLE Inventory; TRUNCATE TABLE Appointments; TRUNCATE TABLE Beds;
TRUNCATE TABLE Departments; TRUNCATE TABLE Employees; TRUNCATE TABLE Patients;
SET FOREIGN_KEY_CHECKS = 1;

-- Chèn dữ liệu mẫu
INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'), (2, 'Khoa Noi'), (3, 'Khoa ICU');

INSERT INTO Beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1), (201, 2, NULL), (301, 3, 2);

INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000), (11, 'Gang tay vo trung', 500), (12, 'Dung dich sat khuan', 200);

INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100), (2, 'Panadol Extra', 5000, 5);

INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), (2, 0), (3, 0);

INSERT INTO Products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20), ('May do duong huyet', 450000.00, 15);

INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00), (2, 'Xet nghiem mau', 150000.00), (3, 'Chup X-Quang', 250000.00);

INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'), (2, 50000.00, 'Active'), (3, 1000000.00, 'Inactive');


-- =========================================================
-- PHẦN 3: TÍCH HỢP STORED PROCEDURES (Đã map đúng tên cột)
-- =========================================================

-- ---------------------------------------------------------
-- 3.1. Procedure: Quản lý chuyển giường (TransferBed)
-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS TransferBed;

DELIMITER //
CREATE PROCEDURE TransferBed(
    IN p_patient_id INT, 
    IN p_new_bed_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Beds SET patient_id = NULL WHERE patient_id = p_patient_id;
    UPDATE Beds SET patient_id = p_patient_id WHERE bed_id = p_new_bed_id;

    COMMIT;
END //
DELIMITER ;


-- ---------------------------------------------------------
-- 3.2. Procedure: Cấp phát thuốc (DispenseMedicine)
-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS DispenseMedicine;

DELIMITER //
CREATE PROCEDURE DispenseMedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_status_message VARCHAR(255)
)
BEGIN
    DECLARE v_stock INT DEFAULT 0;
    DECLARE v_price DECIMAL(18,2) DEFAULT 0.00;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status_message = 'Lỗi hệ thống: Quá trình cấp phát thất bại.';
    END;

    START TRANSACTION;

    -- Lấy dữ liệu tồn kho và giá, khóa dòng tránh xung đột
    SELECT stock, price INTO v_stock, v_price 
    FROM Medicines 
    WHERE medicine_id = p_medicine_id 
    FOR UPDATE;

    IF v_stock < p_quantity THEN
        SET p_status_message = 'Lỗi: Số lượng tồn kho không đủ';
        ROLLBACK;
    ELSE
        -- Trừ kho
        UPDATE Medicines 
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;

        -- Cộng công nợ
        UPDATE Patient_Invoices 
        SET total_due = total_due + (p_quantity * v_price),
            last_updated = CURRENT_TIMESTAMP
        WHERE patient_id = p_patient_id;

        SET p_status_message = 'Đã cấp phát thành công';
        COMMIT;
    END IF;

END //
DELIMITER ;