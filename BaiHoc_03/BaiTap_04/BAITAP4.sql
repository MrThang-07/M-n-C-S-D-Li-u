-- Phân tích & Đề xuất: 
	-- Giải pháp 1: Hard Delete (Xóa vật lý) -> Dùng lệnh DELETE FROM ORDERS WHERE Status = 'Canceled';
	-- -> Bản chất: Xóa triệt để và vĩnh viễn các dòng dữ liệu có trạng thái hủy ra khỏi đĩa cứng của máy chủ cơ sở dữ liệu.
	-- Giải pháp 2: Soft Delete ->  Thêm một cột cờ hiệu (flag) như IsDeleted TINYINT(1) DEFAULT 0. 
	-- Dùng lệnh UPDATE ORDERS SET IsDeleted = 1 WHERE Status = 'Canceled';
	-- Bản chất: Dữ liệu vẫn nằm nguyên trên ổ cứng, ta chỉ đánh dấu nó là "đã bị xóa". Các truy vấn sau này của ứng dụng sẽ phải thêm điều kiện WHERE IsDeleted = 0 để phớt lờ các dòng này đi.
-- THỰC THI PHƯƠNG PHÁP 2 -----
CREATE DATABASE BAITAP4_SS3;
USE BAITAP4_SS3;
CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status VARCHAR(20), 
    IsDeleted TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO ORDERS (CustomerName, OrderDate, TotalAmount, Status) VALUES
('Nguyễn Văn A', '2023-01-10', 500000, 'Completed'),
('Khách hàng vãng lai', '2023-02-15', 1200000, 'Canceled'), 
('Trần Thị B', '2023-05-20', 300000, 'Canceled'),        
('Lê Văn C', '2024-01-05', 850000, 'Completed');

UPDATE ORDERS 
SET IsDeleted = 1 
WHERE Status = 'Canceled';
-- Truy vấn cho App Bán Hàng / Hệ thống thông thường (Không thấy đơn hủy)
SELECT * FROM ORDERS
WHERE IsDeleted = 0 ;

-- Truy vấn cho Kế toán / Kiểm toán (Chỉ xem các đơn đã bị hủy/xóa mềm)
SELECT * FROM ORDERS 
WHERE IsDeleted = 1;