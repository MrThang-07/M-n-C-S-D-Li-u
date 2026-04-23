-- 1 :
-- Input (Đầu vào): Bảng CUSTOMERS.
-- Output (Đầu ra): Chỉ lấy 2 cột là FullName và Email
-- dùng SELECT *  là sai lầm gây : Lãng phí tài nguyên mạng VÀ Lãng phí bộ nhớ (RAM) 
-- Nếu dùng SELECT *, cơ sở dữ liệu phải gom toàn bộ cục dữ liệu khổng lồ (bao gồm cả những cột không cần thiết như Địa chỉ, Ngày sinh
-- , Điểm thưởng...) để đẩy qua đường truyền mạng về máy chủ ứng dụng. Điều này làm nghẽn băng thông . 
-- 2: Lọc vị trí: Khách hàng ở Hà Nội-> City = 'Hà Nội'
-- Lọc thời gian: Không mua hàng hơn 6 tháng tính từ 01/04/2026. LastPurchaseDate <= '2025-10-01'
-- Vượt bẫy 1 (Thiếu Email): Loại bỏ những người không có Email -> Email IS NOT NULL .
-- Vượt bẫy 2 (Tài khoản khóa): Chỉ lấy những người đang hoạt động -> Status = 'Active'. 
-- Triển khai code ---
CREATE DATABASE BAITAP3_SS3;
USE BAITAP3_SS3;
CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    LastPurchaseDate DATE,
    Status VARCHAR(20),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Points INT,
    Address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO CUSTOMERS (FullName, Email, City, LastPurchaseDate, Status) VALUES
('Nguyễn Văn A', 'anv@gmail.com', 'Hà Nội', '2025-05-20', 'Active'),
('Trần Thị B', 'btt@gmail.com', 'Hà Nội', '2026-02-10', 'Active'),
('Lê Văn C', NULL, 'Hà Nội', '2025-01-15', 'Active'),
('Phạm Minh D', 'dpm@gmail.com', 'Hà Nội', '2024-12-01', 'Locked'),
('Hoàng An E', 'eha@gmail.com', 'TP HCM', '2025-03-01', 'Active');

SELECT FullName ,  Email  FROM CUSTOMERS WHERE 
 City = 'Hà Nội' AND LastPurchaseDate <= '2025-10-01' AND Email IS NOT NULL AND Status = 'Active' AND CustomerID > 0;