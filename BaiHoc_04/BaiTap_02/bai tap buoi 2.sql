CREATE DATABASE book_worm;
USE book_worm;

CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    birth_year INT,
    nationality VARCHAR(100)
);

CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    author_id INT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (price >= 0),
    publish_year INT,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    registration_date DATE DEFAULT (CURRENT_DATE)
);

INSERT INTO authors (full_name, birth_year, nationality)
VALUES
('Nguyen Nhat Anh', 1955, 'Viet Nam'),
('Agatha Christie', 1890, 'England'),
('Dale Carnegie', 1888, 'USA');

INSERT INTO books (book_name, category, author_id, price, publish_year)
VALUES
('Mat Biec', 'Van hoc', 1, 85000, 1990),
('Cho Toi Xin Mot Ve Di Tuoi Tho', 'Van hoc', 1, 90000, 2008),
('Toi Thay Hoa Vang Tren Co Xanh', 'Van hoc', 1, 95000, 2010),
('Murder on the Orient Express', 'Trinh tham', 2, 120000, 1934),
('And Then There Were None', 'Trinh tham', 2, 130000, 1939),
('The ABC Murders', 'Trinh tham', 2, 115000, 1936),
('Dac Nhan Tam', 'Ky nang', 3, 110000, 1936),
('Quang Ganh Lo Di Va Vui Song', 'Ky nang', 3, 105000, 1948);

INSERT INTO customers (full_name, email, phone, registration_date)
VALUES
('Nguyen Van A', 'vana@gmail.com', '0901111111', '2026-04-20'),
('Tran Thi B', 'thib@gmail.com', '0902222222', '2026-04-21'),
('Le Van C', 'vanc@gmail.com', '0903333333', '2026-04-22'),
('Pham Thi D', 'thid@gmail.com', '0904444444', '2026-04-23'),
('Hoang Van E', 'vane@gmail.com', '0905555555', '2026-04-24');

INSERT INTO customers (full_name, email, phone, registration_date)
VALUES
('Nguyen Van F', 'vana@gmail.com', '0906666666', '2026-04-25');

-- Câu lệnh trên sẽ báo lỗi vì email 'vana@gmail.com' đã tồn tại
-- trong bảng customers và cột email được thiết lập ràng buộc UNIQUE
-- nên hệ thống sẽ chặn việc nhập dữ liệu trùng lặp.