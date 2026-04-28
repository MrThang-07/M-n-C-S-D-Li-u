CREATE DATABASE SalesManagement;
USE SalesManagement;

CREATE TABLE Product (
	product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL ,
    manufacturer VARCHAR(255) NOT NULL ,
    price DECIMAL(12,2) NOT NULL ,
    stock_quantity INT NOT NULL 
);

CREATE TABLE  Customer (
	customer_id VARCHAR(10) PRIMARY KEY ,
    full_name VARCHAR(255) NOT NULL ,
    email VARCHAR(255) UNIQUE ,
    phone VARCHAR(20) ,
    address VARCHAR(255)
);





ALTER TABLE Product 
CHANGE manufacturer nha_san_xuat VARCHAR(255) NOT NULL ;

DROP TABLE Order_Detail;
DROP TABLE  Orders; 

INSERT INTO Product (product_id, product_name, nha_san_xuat, price, stock_quantity)
VALUES 
('SP001', 'MacBook Air M2', 'Apple', 28500000, 10),
('SP002', 'iPhone 15', 'Apple', 22000000, 15),
('SP003', 'Dell XPS 13', 'DELL', 31000000, 8),
('SP004', 'Logitech MX Master 3', 'Logitech', 2500000, 20),
('SP005', 'Samsung SSD 1TB', 'Samsung', 3200000, 25);

INSERT INTO Customer (customer_id, full_name, email, phone, address)
VALUES 
	('KH001', 'Nguyen Van A', 'a@gmail.com', '0901111111', 'Ha Noi'),
    ('KH002', 'Tran Thi B', 'b@gmail.com', '0902222222', 'Da Nang'),
	('KH003', 'Le Van C', 'c@gmail.com', NULL, 'Hai Phong'),
    ('KH004', 'Pham Thi D', 'd@gmail.com', '0904444444', 'TP HCM'),
    ('KH005', 'Hoang Van E', 'e@gmail.com', NULL, 'Can Tho');


CREATE TABLE Orders (
	order_id VARCHAR(10) PRIMARY KEY ,
    order_date DATE NOT NULL ,
    total_amount DECIMAL(12,2) NOT NULL ,
    customer_id VARCHAR(10) ,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) 
);
ALTER TABLE Orders 
ADD note TEXT ;
INSERT INTO Orders (order_id, order_date, total_amount, customer_id, note)
VALUES 
    ('DH001', '2026-04-20', 50500000, 'KH001', 'Giao nhanh'),
    ('DH002', '2026-04-21', 22000000, 'KH002', 'Thanh toan COD'),
    ('DH003', '2026-04-22', 31000000, 'KH004', 'Khach quen'),
    ('DH004', '2026-04-23', 5700000, 'KH001', 'Don phu kien'),
    ('DH005', '2026-04-24', 28500000, 'KH002', 'Dat online');


CREATE TABLE Order_Detail (
	order_id VARCHAR(10) ,
    product_id VARCHAR(10) ,
    quantity INT NOT NULL , 
    sale_price DECIMAL(12,2) NOT NULL ,
    PRIMARY KEY (order_id, product_id) , 
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ,
	FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
INSERT INTO Order_Detail (order_id, product_id, quantity, sale_price)
VALUES 
	('DH001', 'SP001', 1, 28500000),
    ('DH001', 'SP002', 1, 22000000),
    ('DH002', 'SP002', 1, 22200000),
    ('DH003', 'SP003', 1, 31000000),
    ('DH004', 'SP004', 1, 2500000),
    ('DH004', 'SP005', 1, 3200000),
    ('DH005', 'SP001', 1, 28500000);

UPDATE Product 
SET price = price * 1.10
WHERE nha_san_xuat = 'Apple' ;

DELETE FROM Customer 
WHERE phone IS NULL ;


SELECT * FROM Product WHERE price BETWEEN 10000000 AND 20000000;

