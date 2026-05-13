CREATE DATABASE RikkeiClinicDBbt4;
USE RikkeiClinicDBbt4;

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

-- Chèn Vật tư 
INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

-- Chèn Thuốc
INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),  -- Tồn kho nhiều
(2, 'Panadol Extra', 5000, 5);         -- Tồn kho ít

-- Chèn Công nợ Bệnh nhân
INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), -- Đã sửa: Nợ 1.5tr để test bài Giải phóng giường bệnh
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
(1, 500000.00, 'Active'),    -- Test Case 1: Đủ tiền thanh toán
(2, 50000.00, 'Active'),     -- Test Case 3: Cháy ví (Chỉ có 50k, không đủ khám 200k)
(3, 1000000.00, 'Inactive'); -- Test Case 2: Nhiều tiền nhưng thẻ bị khóa




-- =========================================================
-- PHẦN A: PHÂN TÍCH & ĐỀ XUẤT ĐA GIẢI PHÁP
-- =========================================================

-- =========================================================
-- 1. ĐỊNH NGHĨA INPUT / OUTPUT
-- =========================================================

-- INPUT:
-- p_patient_id : Mã bệnh nhân
-- p_phone      : Số điện thoại

-- OUTPUT:
-- p_total_due  : Tổng công nợ
-- p_message    : Thông báo trạng thái

-- Loại tham số:
-- IN  : dùng để nhận dữ liệu tìm kiếm
-- OUT : dùng để trả kết quả cho Frontend

-- =========================================================
-- 2. ĐỀ XUẤT 2 GIẢI PHÁP
-- =========================================================

-- ---------------------------------------------------------
-- GIẢI PHÁP 1: Dùng IF / ELSEIF
-- ---------------------------------------------------------

-- Logic:
-- - Nếu có ID => tìm theo ID
-- - Nếu không có ID nhưng có Phone => tìm theo Phone
-- - Nếu có cả 2 => ưu tiên ID hoặc kết hợp cả 2

-- Ưu điểm:
-- - Dễ đọc
-- - Dễ debug
-- - Logic rõ ràng

-- Nhược điểm:
-- - Code dài hơn
-- - Nhiều nhánh xử lý


-- ---------------------------------------------------------
-- GIẢI PHÁP 2: Dùng WHERE linh hoạt
-- ---------------------------------------------------------

-- Ví dụ:
-- WHERE (patient_id = p_patient_id OR p_patient_id IS NULL)
--   AND (phone = p_phone OR p_phone IS NULL)

-- Ưu điểm:
-- - Code ngắn hơn
-- - Ít IF ELSE

-- Nhược điểm:
-- - Khó đọc hơn với người mới
-- - Có thể giảm hiệu năng nếu dữ liệu lớn


-- =========================================================
-- 3. SO SÁNH & LỰA CHỌN
-- =========================================================

-- +-------------------+----------------------+----------------------+
-- | Tiêu chí          | IF / ELSEIF         | WHERE linh hoạt      |
-- +-------------------+----------------------+----------------------+
-- | Dễ đọc            | Tốt                 | Trung bình           |
-- | Dễ bảo trì        | Tốt                 | Khó hơn              |
-- | Code ngắn gọn     | Trung bình          | Tốt                  |
-- | Hiệu năng         | Tốt                 | Có thể giảm          |
-- | Phù hợp bài toán  | Rất phù hợp         | Phù hợp              |
-- +-------------------+----------------------+----------------------+

-- Lựa chọn:
-- Chọn giải pháp IF / ELSEIF
-- vì dễ kiểm soát logic và dễ bảo trì hơn.


-- =========================================================
-- PHẦN B: THIẾT KẾ & TRIỂN KHAI
-- =========================================================

-- =========================================================
-- 1. THIẾT KẾ LUỒNG XỬ LÝ
-- =========================================================

-- Bước 1:
-- Nhận patient_id và phone

-- Bước 2:
-- Nếu cả 2 đều NULL
-- => chặn xử lý và báo lỗi

-- Bước 3:
-- Nếu có ID
-- => tìm công nợ theo ID

-- Bước 4:
-- Nếu không có ID nhưng có Phone
-- => tìm patient_id qua bảng Patients
-- => lấy công nợ

-- Bước 5:
-- Nếu không tìm thấy dữ liệu
-- => trả total_due = 0
-- => thông báo không tìm thấy

-- Bước 6:
-- Nếu tìm thấy
-- => trả tổng nợ và thông báo thành công


-- =========================================================
-- 2. TRIỂN KHAI PROCEDURE
-- =========================================================

DROP PROCEDURE IF EXISTS GetPatientDebt;

DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),

    OUT p_total_due DECIMAL(18,2),
    OUT p_message VARCHAR(100)
)
BEGIN

    DECLARE v_patient_id INT;

    -- =====================================
    -- Kiểm tra NULL cả 2
    -- =====================================

    IF p_patient_id IS NULL
       AND p_phone IS NULL THEN

        SET p_total_due = 0;
        SET p_message = 'Lỗi: Vui lòng nhập ID hoặc số điện thoại';

    ELSE

        -- =====================================
        -- Có ID
        -- =====================================

        IF p_patient_id IS NOT NULL THEN

            SELECT total_due
            INTO p_total_due
            FROM Patient_Invoices
            WHERE patient_id = p_patient_id;

        -- =====================================
        -- Có PHONE
        -- =====================================

        ELSE

            SELECT patient_id
            INTO v_patient_id
            FROM Patients
            WHERE phone = p_phone;

            SELECT total_due
            INTO p_total_due
            FROM Patient_Invoices
            WHERE patient_id = v_patient_id;

        END IF;

        -- =====================================
        -- Không tìm thấy dữ liệu
        -- =====================================

        IF p_total_due IS NULL THEN

            SET p_total_due = 0;
            SET p_message = 'Không tìm thấy bệnh nhân';

        ELSE

            SET p_message = 'Tra cứu thành công';

        END IF;

    END IF;

END //

DELIMITER ;


-- =========================================================
-- 3. NGHIỆM THU / KIỂM THỬ
-- =========================================================

-- =====================================================
-- TEST 1: Chỉ truyền ID
-- =====================================================

CALL GetPatientDebt(
    1,
    NULL,
    @total_due,
    @message
);

SELECT @total_due AS total_due,
       @message AS message;

-- Kết quả mong đợi:
-- total_due = 1500000
-- message = Tra cứu thành công


-- =====================================================
-- TEST 2: Chỉ truyền PHONE
-- =====================================================

CALL GetPatientDebt(
    NULL,
    '0912222333',
    @total_due,
    @message
);

SELECT @total_due AS total_due,
       @message AS message;

-- Kết quả mong đợi:
-- total_due = 0
-- message = Tra cứu thành công


-- =====================================================
-- TEST 3: NULL cả 2
-- =====================================================

CALL GetPatientDebt(
    NULL,
    NULL,
    @total_due,
    @message
);

SELECT @total_due AS total_due,
       @message AS message;

-- Kết quả mong đợi:
-- total_due = 0
-- message = Lỗi: Vui lòng nhập ID hoặc số điện thoại


-- =====================================================
-- TEST 4: Dữ liệu không tồn tại
-- =====================================================

CALL GetPatientDebt(
    999,
    NULL,
    @total_due,
    @message
);

SELECT @total_due AS total_due,
       @message AS message;

-- Kết quả mong đợi:
-- total_due = 0
-- message = Không tìm thấy bệnh nhân