-- 1. Tạo và sử dụng Database
CREATE DATABASE IF NOT EXISTS mini_ecommerce;
USE mini_ecommerce;

-- 2. Tạo bảng customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ;

-- 3. Tạo bảng products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0),
    stock_quantity INT DEFAULT 0
) ;

-- 4. Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2) DEFAULT 0,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
    -- Tuyệt đối không dùng ON DELETE CASCADE theo yêu cầu
) ;

-- 5. Tạo bảng order_details
CREATE TABLE order_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    sub_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    -- Tuyệt đối không dùng ON DELETE CASCADE theo yêu cầu
) ;

-- ==========================================
-- THÊM DỮ LIỆU MẪU (SAMPLE DATA)
-- ==========================================

-- Thêm dữ liệu mẫu khách hàng (Mật khẩu mô phỏng đã mã hóa)
INSERT INTO customers (full_name, email, password) VALUES
('Nguyen Van A', 'nguyenvana@gmail.com', 'hashed_pwd_123'),
('Tran Thi B', 'tranthib@gmail.com', 'hashed_pwd_456'),
('Le Van C', 'levanc@gmail.com', 'hashed_pwd_789');

-- Thêm dữ liệu mẫu sản phẩm
INSERT INTO products (product_name, price, stock_quantity) VALUES
('Laptop Dell XPS 15', 1500.00, 15),
('Chuột không dây Logitech G304', 45.50, 50),
('Bàn phím cơ Keychron K8', 85.00, 30),
('Màn hình LG 24 inch 144Hz', 200.00, 20),
('Tai nghe Sony WH-1000XM5', 350.00, 10);

-- Thêm dữ liệu mẫu đơn hàng
INSERT INTO orders (customer_id, total_amount, order_date) VALUES
(1, 1545.50, '2026-05-18 10:30:00'),
(2, 85.00, '2026-05-19 14:15:00'),
(3, 550.00, '2026-05-19 16:45:00');

-- Thêm dữ liệu mẫu chi tiết đơn hàng
-- Đơn hàng 1 của Nguyen Van A: Mua 1 Laptop và 1 Chuột
INSERT INTO order_details (order_id, product_id, quantity, sub_total) VALUES
(1, 1, 1, 1500.00),
(1, 2, 1, 45.50);

-- Đơn hàng 2 của Tran Thi B: Mua 1 Bàn phím
INSERT INTO order_details (order_id, product_id, quantity, sub_total) VALUES
(2, 3, 1, 85.00);

-- Đơn hàng 3 của Le Van C: Mua 1 Màn hình và 1 Tai nghe
INSERT INTO order_details (order_id, product_id, quantity, sub_total) VALUES
(3, 4, 1, 200.00),
(3, 5, 1, 350.00);

-- CHUC NANG 1 --
CREATE VIEW view_customer_info AS 
SELECT customer_id, full_name, email FROM customers ;
SELECT * FROM view_customer_info ;
-- CHUC NANG 2 -- 
CREATE FULLTEXT INDEX idx_product_name ON products(product_name);
SELECT * FROM products 
WHERE MATCH(product_name) AGAINST('Logitech' IN natural language mode);
-- CHUC NANG 3 -- 
DELIMITER $$
CREATE PROCEDURE sp_register_customer(in_full_name VARCHAR(100), in_email VARCHAR(100),in_password VARCHAR(255))
BEGIN 
	IF EXISTS (SELECT 1 FROM customers WHERE email =in_email) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bị trùng email';
	ELSE 
		INSERT INTO customers(full_name, email,password)
        VALUES (in_full_name , in_email,in_password);
	END IF;
END $$
DELIMITER ;
CALL sp_register_customer('Kẻ Mạo Danh', 'nguyenvana@gmail.com', '123456');
-- CHUC NANG 4 -- 
DELIMITER $$ 
CREATE TRIGGER tg_after_order_detail_insert
AFTER INSERT ON order_details
FOR EACH ROW 
BEGIN 
	UPDATE products SET stock_quantity = stock_quantity - NEW.quantity WHERE  product_id  = NEW.product_id ;
END $$ 
DELIMITER ;
INSERT INTO order_details (order_id, product_id, quantity, sub_total) 
VALUES (1, 1, 5, 7500.00);


SELECT * FROM products WHERE product_id = 1;
-- CHUC NANG 5 -- 
DELIMITER $$ 
CREATE PROCEDURE sp_delete_customer(in_customer_id INT)

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
		ROLLBACK;
	END;
    START TRANSACTION ;
		DELETE FROM order_details WHERE order_id IN (SELECT order_id FROM orders WHERE customer_id = in_customer_id);
        DELETE FROM orders WHERE customer_id = in_customer_id;
        DELETE FROM customers WHERE customer_id = in_customer_id;
        COMMIT ;
END $$
DELIMITER ;
CALL sp_delete_customer(1);