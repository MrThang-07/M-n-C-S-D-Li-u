CREATE DATABASE BAITAP1_SS2;
USE BAITAP1_SS2;

-- Phân tích lỗi:
-- 1. ProductName VARCHAR(255) quá dài dù tên sản phẩm rất ngắn -> lãng phí bộ nhớ
-- 2. Price DECIMAL(18,2) quá lớn nếu chỉ lưu giá sản phẩm thông thường -> dư thừa tài nguyên
-- 3. Description dùng TEXT nếu mô tả ngắn sẽ gây tốn bộ nhớ hơn cần thiết

-- Viết lại chuẩn hơn trong MySQL:

CREATE TABLE Products (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Description VARCHAR(500)
);