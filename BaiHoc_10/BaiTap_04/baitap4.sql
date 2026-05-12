

CREATE DATABASE IF NOT EXISTS HospitalManagement2;
USE HospitalManagement2;

-- Xóa bảng nếu đã tồn tại để làm lại từ đầu
DROP TABLE IF EXISTS Pharmacy_Inventory;

-- Tạo cấu trúc bảng
CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Drug_Name VARCHAR(255),
    Batch_Number VARCHAR(50),
    Expiry_Date DATE,
    Quantity INT
);

-- Chèn một số dữ liệu mẫu (Dummy data) để test các câu truy vấn
INSERT INTO Pharmacy_Inventory (Drug_Name, Batch_Number, Expiry_Date, Quantity) VALUES
('Paracetamol 500mg', 'B001', '2026-10-01', 1000),
('Amoxicillin 250mg', 'B002', '2025-12-15', 500),
('Paracetamol 500mg', 'B003', '2026-11-20', 2000),
('Ibuprofen 400mg', 'B004', '2027-01-10', 1500),
('Vitamin C 1000mg', 'B005', '2026-05-30', 3000),
('Paracetamol 500mg', 'B006', '2025-08-20', 800);



-- Tạo 2 Index đơn độc lập
CREATE INDEX idx_drug_name ON Pharmacy_Inventory(Drug_Name);
CREATE INDEX idx_expiry_date ON Pharmacy_Inventory(Expiry_Date);

-- Chạy EXPLAIN để phân tích. 
-- Bạn hãy chú ý cột 'key' trong kết quả trả về, MySQL thường sẽ chỉ chọn 1 trong 2 index.
EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol 500mg' AND Expiry_Date < '2026-12-31';

-- Xóa các Index đơn này đi để chuẩn bị test Composite Index
DROP INDEX idx_drug_name ON Pharmacy_Inventory;
DROP INDEX idx_expiry_date ON Pharmacy_Inventory;



-- Tạo 1 Index kết hợp trên cả 2 cột
CREATE INDEX idx_drug_expiry ON Pharmacy_Inventory(Drug_Name, Expiry_Date);

-- Chạy EXPLAIN lần nữa. 
-- Lần này ở cột 'key' sẽ hiện 'idx_drug_expiry', và số dòng quét (cột 'rows') sẽ được tối ưu tối đa.
EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol 500mg' AND Expiry_Date < '2026-12-31';




--  Vấn đề: Tìm kiếm với dấu % ở đầu
-- Chạy EXPLAIN câu này, bạn sẽ thấy cột 'key' là NULL và cột 'type' là ALL (Full Table Scan)
EXPLAIN SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE '%cetamol%';

--  Giải pháp 1: Ràng buộc LIKE từ ký tự đầu tiên
-- Nếu bỏ dấu % ở đầu, MySQL sẽ lại dùng được cấu trúc B-Tree của Index
EXPLAIN SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE 'Para%';

-- . Giải pháp 2: Sử dụng Full-Text Search (Dành cho tìm kiếm linh hoạt)
-- Thêm Full-Text Index cho cột Drug_Name
ALTER TABLE Pharmacy_Inventory ADD FULLTEXT idx_fulltext_drug (Drug_Name);

-- Sử dụng MATCH ... AGAINST để tìm kiếm từ khóa
-- Chạy EXPLAIN câu này sẽ thấy 'type' là fulltext, tốc độ tra cứu cực kỳ nhanh với dữ liệu văn bản lớn
EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE MATCH(Drug_Name) AGAINST('Paracetamol' IN NATURAL LANGUAGE MODE);

-- Truy vấn thực tế để xem kết quả
SELECT * FROM Pharmacy_Inventory 
WHERE MATCH(Drug_Name) AGAINST('Paracetamol' IN NATURAL LANGUAGE MODE);