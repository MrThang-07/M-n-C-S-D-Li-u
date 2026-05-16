CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;

-- =========================================================
-- PHẦN 1: KHỞI TẠO CẤU TRÚC BẢNG (ĐÃ BỔ SUNG BẢNG LOG)
-- =========================================================

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

-- 7. Bảng Kho Thuốc (Medicines)
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- [BỔ SUNG] 7.1 Bảng Nhật ký biến động giá thuốc (Price_Changes_Log)
CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(18,2) NOT NULL,
    new_price DECIMAL(18,2) NOT NULL,
    price_diff DECIMAL(18,2) NOT NULL,
    change_status VARCHAR(20) NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

-- 8. Bảng Công nợ Bệnh nhân (Patient_Invoices)
CREATE TABLE Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 9. Bảng Sản phẩm (Products)
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 10. Bảng Dịch vụ khám (Services) 
CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử (Wallets) 
CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Inactive'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ (Service_Usages) 
CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);


-- =========================================================
-- PHẦN 2: CHÈN DỮ LIỆU MẪU (TEST CASES)
-- =========================================================

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
(101, 1, 1),    
(201, 2, NULL), 
(301, 3, 2);    

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

-- Chèn Thuốc
INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),  
(2, 'Panadol Extra', 5000, 5);         

-- Chèn Công nợ Bệnh nhân
INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), 
(2, 0),
(3, 0);

-- Chèn Sản phẩm E-commerce 
INSERT INTO Products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

-- Chèn Dịch vụ
INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

-- Chèn Ví điện tử
INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),    
(2, 50000.00, 'Active'),     
(3, 1000000.00, 'Inactive'); 


-- =========================================================
-- PHẦN 3: ĐỊNH NGHĨA TRIGGER BẢO VỆ VÀ GHI NHẬT KÝ
-- =========================================================
DELIMITER $$

CREATE TRIGGER trg_Medicines_BeforeUpdate
BEFORE UPDATE ON Medicines
FOR EACH ROW
BEGIN
    -- 1. KIỂM TRA RÀO CHẮN LỖI: Nếu giá trị mới âm hoặc bằng 0
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- 2. XỬ LÝ GHI NHẬT KÝ: Chỉ ghi nhận nếu có sự thay đổi thực tế về giá (Chống log rác)
    IF NEW.price <> OLD.price THEN
        -- Trường hợp giá tăng
        IF NEW.price > OLD.price THEN
            INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, price_diff, change_status)
            VALUES (OLD.medicine_id, OLD.price, NEW.price, (NEW.price - OLD.price), 'TĂNG GIÁ');
        
        -- Trường hợp giá giảm
        ELSEIF NEW.price < OLD.price THEN
            INSERT INTO Price_Changes_Log (medicine_id, old_price, new_price, price_diff, change_status)
            VALUES (OLD.medicine_id, OLD.price, NEW.price, (OLD.price - NEW.price), 'GIẢM GIÁ');
        END IF;
    END IF;
END$$

DELIMITER ;


-- =========================================================
-- PHẦN 4: KỊCH BẢN KIỂM THỬ (4 TEST CASES)
-- =========================================================

-- [TEST CASE 1]: Cập nhật tăng giá hợp lệ
UPDATE Medicines 
SET price = 18500 
WHERE medicine_id = 1;

-- Kiểm tra kết quả log (Kỳ vọng: Có 1 bản ghi 'TĂNG GIÁ' kèm chênh lệch là 3500)
SELECT * FROM Price_Changes_Log;


-- [TEST CASE 2]: Cập nhật giảm giá hợp lệ
UPDATE Medicines 
SET price = 4200 
WHERE medicine_id = 2;

-- Kiểm tra kết quả log (Kỳ vọng: Thêm 1 bản ghi 'GIẢM GIÁ' kèm chênh lệch là 800)
SELECT * FROM Price_Changes_Log;


-- [TEST CASE 3]: Cập nhật thông tin khác, GIỮ NGUYÊN GIÁ (Chống log rác)
UPDATE Medicines 
SET stock = 120 
WHERE medicine_id = 1;

-- Kiểm tra kết quả log (Kỳ vọng: Số lượng log vẫn giữ nguyên là 2, không sinh ra dòng rác)
SELECT * FROM Price_Changes_Log;


-- [TEST CASE 4]: Cập nhật lỗi gõ nhầm giá âm (Đánh chặn hệ thống)
-- Lệnh này sẽ vấp phải rào chắn của Trigger, dừng thực thi và bắn ra lỗi đỏ.
UPDATE Medicines 
SET price = -5000 
WHERE medicine_id = 1;

-- Kiểm tra lại bảng Medicines (Kỳ vọng: Giá của thuốc ID 1 vẫn an toàn ở mức 18500, không bị đổi thành âm)
SELECT * FROM Medicines WHERE medicine_id = 1;