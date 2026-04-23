CREATE DATABASE BAITAP4_SS2;
USE BAITAP4_SS2;
-- Hiện trạng:
-- Cột Phone đang là INT
-- Ví dụ: 098xxxx sẽ bị lưu thành 98xxxx (mất số 0 đầu)

-- Mục tiêu:
-- Đổi sang VARCHAR(15) để lưu đúng số điện thoại

-- ==================================================
-- GIẢI PHÁP 1: MODIFY trực tiếp cột hiện tại
-- ==================================================

-- ALTER TABLE Users
-- MODIFY Phone VARCHAR(15);

-- Ưu điểm:
-- Nhanh, ngắn gọn
-- Không cần thêm cột mới

-- Nhược điểm:
-- Với bảng 2 triệu bản ghi:
-- dễ lock bảng lâu
-- có thể làm chậm hoặc sập hệ thống đang chạy
-- rủi ro cao khi production

-- ==================================================
-- GIẢI PHÁP 2: Thêm cột mới rồi migrate dữ liệu
-- ==================================================

-- ALTER TABLE Users
-- ADD Phone_New VARCHAR(15);

-- Sau đó cập nhật dữ liệu dần dần:
-- UPDATE Users SET Phone_New = CAST(Phone AS CHAR);

-- Khi ổn định mới đổi tên cột

-- Ưu điểm:
-- An toàn hơn
-- giảm rủi ro downtime
-- phù hợp hệ thống lớn đang hoạt động

-- Nhược điểm:
-- nhiều bước hơn
-- tốn thời gian hơn


-- ==================================================
-- BẢNG SO SÁNH
-- ==================================================

-- | Giải pháp | Ưu điểm | Nhược điểm |
-- |---|---|---|
-- | MODIFY trực tiếp | nhanh, đơn giản | dễ lock bảng, nguy cơ sập hệ thống |
-- | Thêm cột mới | an toàn, ít downtime | phức tạp hơn, nhiều bước |

-- ==================================================
-- LỰA CHỌN
-- ==================================================

-- Chọn GIẢI PHÁP 2
-- vì hệ thống có 2 triệu bản ghi
-- ưu tiên an toàn hơn tốc độ

-- ==================================================
-- DDL DUY NHẤT ĐƯỢC CHỌN
-- ==================================================
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Phone INT
);


ALTER TABLE Users
ADD Phone_New VARCHAR(15);