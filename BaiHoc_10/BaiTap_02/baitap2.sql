-- 1 
CREATE DATABASE IF NOT EXISTS HospitalManagement;
USE HospitalManagement;

DROP TABLE IF EXISTS Patients;
CREATE TABLE Patients (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);


-- 2. TẠO PROCEDURE CHÈN 500.000 DỮ LIỆU GIẢ LẬP

DELIMITER //
DROP PROCEDURE IF EXISTS SeedPatients //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (CONCAT('Patient ', i), CONCAT('090', i), FLOOR(RAND()*100), 'Ho Chi Minh City');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- Gọi procedure để nạp dữ liệu :
CALL SeedPatients();



-- 3. TẠO PROCEDURE CHÈN 1.000 DÒNG (ĐỂ TEST TỐC ĐỘ GHI INSERT)

DELIMITER //
DROP PROCEDURE IF EXISTS TestInsert1000 //
CREATE PROCEDURE TestInsert1000()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (CONCAT('New Patient ', i), CONCAT('091', i), 30, 'Ho Chi Minh City');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;



-- 4. KỊCH BẢN KIỂM THỬ TRƯỚC KHI CÓ INDEX (KHÔNG CÓ CHỈ MỤC)


-- a. Đo lường tốc độ ĐỌC (SELECT)
SELECT * FROM Patients WHERE Phone = '090123456';

EXPLAIN SELECT * FROM Patients WHERE Phone = '090123456';

-- b. Đo lường tốc độ GHI (INSERT) - TRƯỚC khi có Index

CALL TestInsert1000();



-- 5. TẠO INDEX VÀ KỊCH BẢN KIỂM THỬ SAU KHI CÓ INDEX


-- Tạo Index trên cột Phone
CREATE INDEX idx_phone ON Patients(Phone);

-- a. Đo lường tốc độ ĐỌC (SELECT) - SAU KHI CÓ INDEX
SELECT * FROM Patients WHERE Phone = '090123456';

-- Dùng EXPLAIN để phân tích: Kết quả type = 'ref', rows = 1 (Dùng B-Tree Index)
EXPLAIN SELECT * FROM Patients WHERE Phone = '090123456';

-- b. Đo lường tốc độ GHI (INSERT) - SAU KHI CÓ INDEX

CALL TestInsert1000();



 --  6. TỔNG HỢP BÁO CÁO NHẬN XÉT (ĐÁNH GIÁ SỰ TRADE-OFF)

  -- 1. Về tốc độ truy vấn (SELECT):
   --   - TRƯỚC khi có Index: Hệ thống phải quét toàn bộ bảng (Full Table Scan), duyệt qua hàng trăm ngàn dòng để tìm kết quả. Điều này mất nhiều thời gian.
     -- - SAU khi có Index: Hệ thống sử dụng cây chỉ mục, trỏ thẳng đến vị trí dữ liệu. Thời gian phản hồi giảm xuống mức mili-giây, khắc phục triệt để tình trạng chờ đợi dài.

   -- 2. Về tốc độ ghi dữ liệu (INSERT):
    --  - TRƯỚC khi có Index: Thao tác Insert 1000 dòng diễn ra nhanh chóng vì dữ liệu chỉ việc ghi nối tiếp vào cuối bảng.
    --  - SAU khi có Index: Tốc độ Insert 1000 dòng bị chậm đi. Nguyên nhân là do sau mỗi lượt thêm dữ liệu, Database phải mất thêm tài nguyên để tính toán, sắp xếp và cập nhật lại cấu trúc cây Index (idx_phone).

  -- 3. Kết luận về sự đánh đổi:
   --   - Đây là sự đánh đổi (Trade-off) kinh điển trong cơ sở dữ liệu: Việc thêm Index làm TĂNG NHANH tốc độ ĐỌC, nhưng lại làm GIẢM tốc độ GHI.
    --  - Đối với hệ thống tiếp nhận của bệnh viện, nhân viên lễ tân tìm kiếm hồ sơ cũ liên tục (thao tác Đọc rất nhiều). Nếu tìm kiếm mất 3 giây/người sẽ gây ùn tắc hàng đợi. Trong khi đó, việc mất thêm vài mili-giây để ghi nhận 1 bệnh nhân mới là không thể nhận ra và không ảnh hưởng đến trải nghiệm.
    --  => Kết luận: Việc đánh Index lên cột Phone là HOÀN TOÀN XỨNG ĐÁNG và LÀ BẮT BUỘC để tối ưu hiệu năng hệ thống.
