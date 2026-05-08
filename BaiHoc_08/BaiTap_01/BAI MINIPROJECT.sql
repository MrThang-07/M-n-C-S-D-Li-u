CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;

-- 1. Bảng Khách hàng
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE NOT NULL,
    ngay_sinh DATE,
    address VARCHAR(255)
);

-- 2. Bảng Danh mục
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- 3. Bảng Sản phẩm
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    
    -- Khóa ngoại nối với bảng Category
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- 4. Bảng Đơn hàng
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATETIME NOT NULL,
    status VARCHAR(50),
    
    -- Khóa ngoại nối với bảng Customer
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 5. Bảng Chi tiết đơn hàng
CREATE TABLE Order_Detail (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    
    -- Khóa chính là sự kết hợp của 2 cột
    PRIMARY KEY (order_id, product_id),
    
    -- 2 Khóa ngoại nối với bảng Orders và Product
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


INSERT INTO Customer (full_name, email, phone, address,ngay_sinh)
VALUES 
    ('Nguyễn Văn A', 'nva@gmail.com', '0901234567', 'Hà Nội', '2001-05-15'),
    ('Trần Thị B', 'ttb@gmail.com', '0912345678', 'TP. Hồ Chí Minh', '2003-10-20'),
    ('Lê Văn C', 'lvc@gmail.com', '0923456789', 'Đà Nẵng', '1998-02-28'),
    ('Phạm Thị D', 'ptd@gmail.com', '0934567890', 'Cần Thơ', '2005-07-11'),
    ('Hoàng Văn E', 'hve@gmail.com', '0945678901', 'Hải Phòng', '2000-12-05');

INSERT INTO Category (category_name, description)
VALUES 
    ('Điện thoại', 'Các dòng điện thoại thông minh (Smartphone)'),
    ('Laptop', 'Máy tính xách tay các hãng'),
    ('Máy tính bảng', 'iPad và các loại Tablet Android'),
    ('Phụ kiện', 'Tai nghe, cáp sạc, ốp lưng...'),
    ('Đồng hồ', 'Đồng hồ thông minh (Smartwatch)');

INSERT INTO Product (product_name, price, stock_quantity, category_id)
VALUES 
    ('iPhone 15 Pro Max', 29000000.00, 50, 1),
    ('Samsung Galaxy S24', 22000000.00, 40, 1),
    ('MacBook Air M2', 20000000.00, 30, 2),
    ('Tai nghe AirPods Pro', 5000000.00, 100, 4),
    ('Apple Watch Series 9', 10000000.00, 20, 5);

INSERT INTO Orders (order_date, status, customer_id)
VALUES 
    ('2026-05-01 09:30:00', 'Đã giao', 1),
    ('2026-05-02 14:15:00', 'Đang xử lý', 2),
    ('2026-05-03 10:00:00', 'Chờ xác nhận', 3),
    ('2026-05-04 16:45:00', 'Đã giao', 4),
    ('2026-05-05 08:20:00', 'Đang giao', 5);

INSERT INTO Order_Detail (order_id, product_id, quantity, unit_price)
VALUES 
    (1, 1, 1, 29000000.00),
    (1, 4, 2, 5000000.00),
    (2, 2, 1, 22000000.00),
    (3, 3, 1, 20000000.00),
    (4, 5, 1, 10000000.00),
    (5, 1, 1, 29000000.00);
    -- Cập nhật --
UPDATE Product
SET price = 10000000.00 WHERE product_id = 1;

UPDATE Customer
SET email = 'nva1@gmail.com'  WHERE product_id = 1;
-- PHẦN 4 --
DELETE FROM Orders WHERE order_id = 3;
-- PHẦN 5 -----
SELECT full_name, email ,
CASE 
	WHEN customer_id IN (1,3,5) THEN 'Nam'
    WHEN customer_id IN (2,4) THEN 'Nữ'
    ELSE 'BEDE'
END AS Set_customer 
FROM Customer ;

SELECT full_name, email, phone, address , (YEAR(NOW()) - YEAR(ngay_sinh)) AS TUOI FROM Customer
ORDER BY TUOI ASC
LIMIT 3;


SELECT c.full_name, o.order_id, o.order_date
FROM Customer c 
JOIN Orders o 
ON c.customer_id = o.customer_id ;

SELECT c.category_name , COUNT(p.product_id) AS SOLUONG FROM Category c
JOIN Product p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING SOLUONG >= 2 ; 


SELECT  product_name , price FROM Product
WHERE price > (SELECT AVG(price) FROM Product) ;



SELECT * FROM Customer
WHERE customer_id NOT IN (
    SELECT o.customer_id 
    FROM Orders o
);

SELECT 
    c.category_name, 
    SUM(od.quantity * od.unit_price) AS Category_Revenue
FROM Category c
JOIN Product p ON c.category_id = p.category_id
JOIN Order_Detail od ON p.product_id = od.product_id
GROUP BY c.category_name
HAVING Category_Revenue > (
    -- Tính mốc 120% doanh thu trung bình của các đơn hàng
    SELECT AVG(total_per_order) * 1.2
    FROM (
        SELECT SUM(quantity * unit_price) AS total_per_order
        FROM Order_Detail
        GROUP BY order_id
    ) AS SubTable
);

SELECT p.product_name, p.price, p.category_id
FROM Product p
JOIN (
    -- Bước 1: Lập danh sách kỷ lục
    SELECT category_id, MAX(price) AS max_price
    FROM Product
    GROUP BY category_id
) AS TopPriceTable 
ON p.category_id = TopPriceTable.category_id 
AND p.price = TopPriceTable.max_price;


SELECT full_name 
FROM Customer 
WHERE customer_id IN (
    -- Cấp 1: Lấy danh sách khách hàng từ bảng Orders
    SELECT customer_id 
    FROM Orders 
    WHERE order_id IN (
        -- Cấp 2: Lấy mã đơn hàng có chứa sản phẩm mục tiêu từ Order_Detail
        SELECT order_id 
        FROM Order_Detail 
        WHERE product_id IN (
            -- Cấp 3: Lấy mã sản phẩm thuộc danh mục 'Điện tử'
            SELECT p.product_id 
            FROM Product p
            JOIN Category c ON p.category_id = c.category_id
            WHERE c.category_name = 'Điện tử'
        )
    )
);

