DROP DATABASE IF EXISTS RikkeiClinicDB;
CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;

-- =========================================================
-- PHẦN 1: KHỞI TẠO CẤU TRÚC HỆ THỐNG BẢNG
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
    patient_id INT DEFAULT NULL,
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
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
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
-- PHẦN 2: CHÈN DỮ LIỆU MẪU ĐỂ KHỞI TẠO HỆ THỐNG
-- =========================================================

INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Nội'),
(3, 'Khoa ICU');

INSERT INTO Beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),    
(201, 2, NULL), 
(301, 3, 2);    

-- Khởi tạo lịch khám gốc để làm nền test trùng lịch
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),   -- Ca đang chờ khám của Dr. Hoang Minh
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');   -- Ca đã hủy của Dr. Hoang Minh

INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),  
(2, 'Panadol Extra', 5000, 5);         

INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), 
(2, 0),
(3, 0);

INSERT INTO Products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),    
(2, 50000.00, 'Active'),     
(3, 1000000.00, 'Inactive'); 


-- =========================================================
-- PHẦN 3: ĐỊNH NGHĨA 2 TRIGGER CHỐNG TRÙNG LỊCH BÁC SĨ
-- =========================================================
DELIMITER $$

-- 1. TRIGGER đánh chặn khi THÊM MỚI lịch hẹn (INSERT)
CREATE TRIGGER trg_Appointments_CheckOverlap_Insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu bác sĩ đã có lịch hẹn chưa hủy trong vòng 60 phút
    IF EXISTS (
        SELECT 1 
        FROM Appointments 
        WHERE doctor_id = NEW.doctor_id
          AND ABS(TIMESTAMPDIFF(MINUTE, appointment_date, NEW.appointment_date)) < 60
          AND status <> 'Cancelled' -- Ngoại lệ 1: Bỏ qua ca đã hủy
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;
END$$

-- 2. TRIGGER đánh chặn khi CẬP NHẬT / DỜI lịch hẹn (UPDATE)
CREATE TRIGGER trg_Appointments_CheckOverlap_Update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- Nếu đổi trạng thái thành 'Cancelled' thì cho qua luôn
    IF NEW.status <> 'Cancelled' THEN
        -- Kiểm tra trùng lịch và loại trừ chính ID đang sửa
        IF EXISTS (
            SELECT 1 
            FROM Appointments 
            WHERE doctor_id = NEW.doctor_id
              AND ABS(TIMESTAMPDIFF(MINUTE, appointment_date, NEW.appointment_date)) < 60
              AND status <> 'Cancelled' -- Ngoại lệ 1: Bỏ qua ca đã hủy
              AND appointment_id <> NEW.appointment_id -- Ngoại lệ 2: Tránh tự trùng chính mình
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
        END IF;
    END IF;
END$$

DELIMITER ;


-- =========================================================
-- PHẦN 4: KỊCH BẢN KIỂM THỬ NGHIỆM THU (4 TEST CASES)
-- =========================================================

-- [TEST CASE 1]: Lịch mới đưa vào khung giờ hoàn toàn trống
-- Hành động: Đặt lịch mới (ID: 107) lúc 07:00:00 (Cách ca 08:30 tận 90 phút) -> KỲ VỌNG: THÀNH CÔNG.
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) 
VALUES (107, 2, 101, '2026-06-10 07:00:00', 'Pending');

-- Xem lại bảng để kiểm tra ca 107 đã vào hệ thống chưa
SELECT * FROM Appointments WHERE appointment_id = 107;


-- [TEST CASE 2]: Lịch mới đưa vào khung giờ đang có ca 'Pending'
-- Hành động: Đặt lịch mới (ID: 108) lúc 09:00:00 (Trùng ca 104 lúc 08:30:00 vì cách nhau chỉ 30 phút) -> KỲ VỌNG: BỊ CHẶN & THẨY LỖI.
-- (Khi chạy câu lệnh dưới đây, MySQL sẽ báo lỗi "Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này")
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) 
VALUES (108, 3, 101, '2026-06-10 09:00:00', 'Pending');


-- [TEST CASE 3]: Lịch mới đưa vào khung giờ đang có ca 'Cancelled'
-- Hành động: Đặt lịch mới (ID: 109) lúc 10:15:00 ngày 2026-05-02 (Trùng giờ ca cũ 10:00:00 nhưng ca đó đã hủy) -> KỲ VỌNG: THÀNH CÔNG.
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) 
VALUES (109, 1, 101, '2026-05-02 10:15:00', 'Pending');

-- Xem lại bảng để kiểm tra ca 109 đã vào hệ thống
SELECT * FROM Appointments WHERE appointment_id = 109;


-- [TEST CASE 4]: Cập nhật trạng thái một ca khám từ 'Pending' sang 'Completed'
-- Hành động: Hoàn thành ca khám ID 104 -> KỲ VỌNG: THÀNH CÔNG (Không bị lỗi tự nhận diện trùng lịch chính mình).
UPDATE Appointments 
SET status = 'Completed' 
WHERE appointment_id = 104;

-- Kiểm tra kết quả cập nhật trạng thái của ca 104
SELECT * FROM Appointments WHERE appointment_id = 104;