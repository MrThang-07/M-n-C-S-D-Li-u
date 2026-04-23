CREATE DATABASE BAITAP3_SS2;
USE BAITAP3_SS2;


-- Phân tích:
-- 1 khách hàng có thể có nhiều đơn hàng
-- 1 đơn hàng bắt buộc phải thuộc về 1 khách hàng có thật

-- Vì vậy:
-- Phải tạo bảng CUSTOMERS trước
-- rồi mới tạo bảng ORDERS để dùng khóa ngoại FOREIGN KEY

-- =========================
-- Tạo bảng CUSTOMERS
-- =========================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- =========================
-- Tạo bảng ORDERS
-- =========================

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    CustomerID INT NOT NULL,

    CONSTRAINT fk_customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
);