CREATE DATABASE BAITAP2_SS2;
USE BAITAP2_SS2;

CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100), -- Allows NULL
    Age INT             -- No control over negative values
);
-- Phân tích lỗi:
-- 1. Email cho phép NULL -> nhiều khách hàng không có email làm hệ thống gửi mail bị lỗi
-- 2. Age không có ràng buộc -> có thể nhập tuổi âm như -5
-- 3. FullName cũng nên NOT NULL để tránh dữ liệu rác

-- KHÔNG dùng DROP TABLE
-- Dùng ALTER TABLE để sửa
ALTER TABLE Customers
MODIFY FullName VARCHAR(100) NOT NULL;

ALTER TABLE Customers
MODIFY Email VARCHAR(100) NOT NULL;

ALTER TABLE Customers
MODIFY Age INT NOT NULL;

ALTER TABLE Customers
ADD CONSTRAINT chk_age
CHECK (Age >= 0);