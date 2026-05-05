-- =========================================
-- BÀI: TỐI ƯU BỘ LỌC "ĐƠN HÀNG THẤT BẠI"
-- =========================================

-- 1. Tạo Database
CREATE DATABASE order_management;
USE order_management;

-- 2. Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255),
    failure_reason VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Dữ liệu mẫu
INSERT INTO orders (customer_name, failure_reason) VALUES
('Nguyen Van A', 'KHACH_HUY'),
('Tran Thi B', 'QUAN_DONG_CUA'),
('Le Van C', 'KHONG_CO_TAI_XE'),
('Pham Thi D', 'BOM_HANG'),
('Hoang Van E', 'KHACH_HUY'),
('Do Thi F', NULL),
('Nguyen Van G', 'GIAO_THANH_CONG');

-- =========================================
-- 4. GIẢI PHÁP 1: DÙNG OR
-- =========================================
SELECT *
FROM orders
WHERE failure_reason = 'KHACH_HUY'
   OR failure_reason = 'QUAN_DONG_CUA'
   OR failure_reason = 'KHONG_CO_TAI_XE'
   OR failure_reason = 'BOM_HANG';

-- =========================================
-- 5. GIẢI PHÁP 2: DÙNG IN (KHUYẾN NGHỊ)
-- =========================================
SELECT *
FROM orders
WHERE failure_reason IN (
    'KHACH_HUY',
    'QUAN_DONG_CUA',
    'KHONG_CO_TAI_XE',
    'BOM_HANG'
);

-- =========================================
-- 6. SO SÁNH
-- =========================================
/*
1. Code sạch:
- OR: dài, khó đọc
- IN: ngắn gọn, dễ hiểu

2. Mở rộng:
- OR: khó khi có nhiều điều kiện
- IN: dễ thêm vào danh sách

3. Hiệu năng:
- OR: parse nhiều điều kiện
- IN: tối ưu hơn khi danh sách lớn

=> Kết luận: NÊN dùng IN
*/

-- =========================================
-- 7. XỬ LÝ BẪY MẢNG RỖNG
-- =========================================

-- ❌ Sai (gây lỗi syntax)
-- SELECT * FROM orders WHERE failure_reason IN ();

-- ✅ Cách an toàn 1: trả về rỗng
SELECT *
FROM orders
WHERE 1 = 0;

-- =========================================
-- 8. TỐI ƯU HIỆU NĂNG (INDEX)
-- =========================================
CREATE INDEX idx_failure_reason ON orders(failure_reason);

-- =========================================
-- 9. CODE CHỐT (DÙNG THỰC TẾ)
-- =========================================
SELECT *
FROM orders
WHERE failure_reason IN (
    'KHACH_HUY',
    'QUAN_DONG_CUA',
    'KHONG_CO_TAI_XE',
    'BOM_HANG'
);

-- =========================================
-- KẾT LUẬN
-- =========================================
/*
- Dùng IN thay vì OR
- Dễ đọc, dễ bảo trì
- Mở rộng tốt
- Kết hợp INDEX để tăng tốc

=> Chuẩn thực tế production
*/