CREATE DATABASE IF NOT EXISTS designcsdl_db;
USE designcsdl_db;
-- PHẦN 1 --
CREATE TABLE Readers(
	reader_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL ,
    email VARCHAR(55) NOT NULL UNIQUE ,
    phone_number VARCHAR(10) NOT NULL UNIQUE ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
);
CREATE TABLE Membership_Detalls(
	card_id VARCHAR(55) PRIMARY KEY ,
    reader_id INT UNIQUE,
    card_rank VARCHAR(55) DEFAULT 'Standard',
    explry_date DATETIME NOT NULL,
    citizen_id VARCHAR(25) NOT NULL UNIQUE, 
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id)
);
CREATE TABLE Categories(
	category_id INT PRIMARY KEY AUTO_INCREMENT ,
    category_name VARCHAR(255) NOT NULL UNIQUE ,
    description TEXT NOT NULL 
);
CREATE TABLE Books(
	book_id INT PRIMARY KEY AUTO_INCREMENT ,
    title VARCHAR(255) NOT NULL UNIQUE ,
    author VARCHAR(55) NOT NULL ,
    category_id INT ,
    price DECIMAL(10,0) NOT NULL,
    stock_quantity INT NOT NULL,
    CONSTRAINT ck_price CHECK(price > 0),
    CONSTRAINT ck_stock_quantity CHECK(stock_quantity >= 0),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Loan_Records(
	loan_id VARCHAR(55) PRIMARY KEY ,
    reader_id INT ,
    book_id INT ,
    borrow_date DATETIME NOT NULL,
    due_date DATETIME NOT NULL ,
    CONSTRAINT ck_due_date CHECK(due_date > borrow_date),
    return_date DATETIME ,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
-- CHÈN DỮ LIỆU -- 
-- CAU 1 --
INSERT INTO Readers(full_name,email,phone_number,created_at)
	VALUES 
		('Nguyen Van A','anv@gmail.com','901234567','2022-01-15'),
        ('Tran Thi B','btt@gmail.com','912345678','2022-05-20'),
		('Le Van C','cle@yahoo.com','922334455','2023-02-10'),
		('Pham Minh D','dpham@hotmail.com','933445566','2023-11-05'),
		('Hoang Anh E','ehoang@gmail.com','944556677','2023-01-12');
INSERT INTO Membership_Detalls(card_id,reader_id,card_rank,explry_date,citizen_id)
	VALUES 
		('CARD-001',1,'Standard','2025-01-15','123456789'),
        ('CARD-002',2,'VIP','2025-05-20','234567890'),
        ('CARD-003',3,'Standard','2024-02-10','345678901'),
        ('CARD-004',4,'VIP','2025-11-05','456789012'),
        ('CARD-005',5,'Standard','2026-01-12','567890123');
INSERT INTO Categories(category_name,description)
	VALUES
		('IT','Sách về công nghệ thông tin và lập trình'),
        ('Kinh Te','Sách kinh doanh, tài chính, khởi nghiệp'),
        ('Van Hoc','Tiểu thuyết, truyện ngắn, thơ'),
        ('Ngoai Ngu','Sách học tiếng Anh,Nhật,Hàn'),
        ('Lich Su','Sách nghiên cứu lịch sử, văn hóa');
INSERT INTO Books(title,author,category_id,price,stock_quantity)
	VALUES
		('Clean Code','Roberl C.Martin',1,450000,10),
        ('Dac Nhan Tam','Dale Camegie',2,150000,50),
        ('Harry Potter 1','J.K Rowling',3,250000,5),
        ('IELTS Reading','Cambridge',4,180000,0),
        ('Dai Viet Su Ky','Le Van Huu',5,300000,20);
INSERT INTO Loan_Records(loan_id,reader_id,book_id,borrow_date,due_date,return_date)
	VALUES 
		('101',1,1,'2023-11-15','2023-11-22','2023-11-20'),
        ('102',2,2,'2023-12-01','2023-12-08','2023-12-05'),
        ('103',1,3,'2024-01-10','2024-01-17',NULL),
        ('104',3,4,'2023-05-20','2023-05-27',NULL),
        ('105',4,1,'2023-01-18','2024-01-25',NULL);
-- CAU 3 --
DELETE FROM Loan_Records WHERE return_date IS NOT NULL AND MONTH(borrow_date) < 10;
-- PHAN 2 --
-- CAU 1 --
SELECT b.book_id,b.title,b.price FROM Books b
JOIN Categories c
ON 	b.category_id = c.category_id
WHERE category_name = 'IT' AND price > 200000;
-- CAU 2 --
SELECT reader_id,full_name,email FROM Readers 
WHERE YEAR(created_at) = 2022 AND email LIKE '%gmail.com%';
-- CAU 3 --
SELECT * FROM Books 
ORDER BY price DESC 
LIMIT 5 OFFSET 2;
-- PHAN 3 --
-- CAU 1 --
SELECT l.loan_id,r.full_name,b.title,l.borrow_date,l.due_date 
FROM Loan_Records l
JOIN Readers r 
ON l.reader_id =r.reader_id
JOIN Books b
ON l.book_id = b.book_id
WHERE return_date IS NULL;
-- CAU 2 --
SELECT c.category_id,c.category_name , SUM(b.stock_quantity)
FROM Categories c
JOIN Books b 
ON c.category_id = b.category_id
GROUP BY c.category_id,c.category_name
HAVING SUM(b.stock_quantity) > 10;
-- CAU 3 -- 
SELECT full_name FROM Readers r
JOIN Loan_Records l
ON r.reader_id = l.reader_id
JOIN Membership_Detalls md
ON r.reader_id = md.reader_id
JOIN Books b 
ON l.book_id = b.book_id
WHERE card_rank = 'VIP' AND price < 300000;
-- PHAN 4 -- 
-- CAU 1 --
CREATE INDEX idx_loan_dates 
ON Loan_Records(borrow_date,return_date);
-- CAU 2 --
CREATE VIEW vw_overdue_loans AS
SELECT l.loan_id,r.full_name,b.title,l.borrow_date,l.due_date
FROM Loan_Records l
JOIN Readers r 
ON l.reader_id =r.reader_id
JOIN Books b
ON l.book_id = b.book_id
WHERE return_date > due_date OR return_date IS NULL;
SELECT * FROM vw_overdue_loans;
-- PHAN 6  -- 
-- CAU 1 --
DELIMITER $$
CREATE PROCEDURE sp_check_availability(IN p_book_id INT, 
OUT p_message VARCHAR(55))
BEGIN 
	DECLARE v_stock_quantity INT;
    SELECT stock_quantity INTO v_stock_quantity FROM Books 
    WHERE book_id = p_book_id ;
    IF v_stock_quantity > 5 THEN SET p_message ='Còn hàng';
    ELSEIF v_stock_quantity <= 5 AND v_stock_quantity > 0 
    THEN SET p_message = 'Sắp hết';
    ELSEIF v_stock_quantity = 0 THEN SET p_message = 'Hết hàng';
    END IF;
END $$
DELIMITER ;

CALL sp_check_availability(1,@p_message);
SELECT @p_message;