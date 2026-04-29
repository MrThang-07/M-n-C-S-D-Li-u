CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE Book (
    book_id VARCHAR(10) PRIMARY KEY,
    book_name VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publish_year INT NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE Reader (
    reader_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE Borrow_Card (
    borrow_card_id VARCHAR(10) PRIMARY KEY,
    borrow_date DATE NOT NULL,
    return_date DATE NOT NULL,
    reader_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);

CREATE TABLE Borrow_Detail (
    borrow_card_id VARCHAR(10),
    book_id VARCHAR(10),
    book_status VARCHAR(50) NOT NULL,
    borrow_fee DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (borrow_card_id, book_id),
    FOREIGN KEY (borrow_card_id) REFERENCES Borrow_Card(borrow_card_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

ALTER TABLE Reader
ADD address TEXT;

ALTER TABLE Book
CHANGE publish_year nam_phat_hanh INT NOT NULL;

DROP TABLE Borrow_Detail;
DROP TABLE Borrow_Card;

CREATE TABLE Borrow_Card (
    borrow_card_id VARCHAR(10) PRIMARY KEY,
    borrow_date DATE NOT NULL,
    return_date DATE NOT NULL,
    reader_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);

CREATE TABLE Borrow_Detail (
    borrow_card_id VARCHAR(10),
    book_id VARCHAR(10),
    book_status VARCHAR(50) NOT NULL,
    borrow_fee DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (borrow_card_id, book_id),
    FOREIGN KEY (borrow_card_id) REFERENCES Borrow_Card(borrow_card_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

INSERT INTO Book (book_id, book_name, author, nam_phat_hanh, quantity)
VALUES
('B001', 'Mat Biec', 'Nguyễn Nhật Ánh', 1990, 10),
('B002', 'Cho Toi Xin Mot Ve Di Tuoi Tho', 'Nguyễn Nhật Ánh', 2008, 8),
('B003', 'Dac Nhan Tam', 'Dale Carnegie', 1936, 12),
('B004', 'Sherlock Holmes', 'Arthur Conan Doyle', 1892, 6),
('B005', 'Hai So Phan', 'Jeffrey Archer', 1979, 7);

INSERT INTO Reader (reader_id, full_name, email, phone, birth_date, address)
VALUES
('R001', 'Nguyen Van A', 'vana@gmail.com', '0901111111', '2000-05-10', 'Ha Noi'),
('R002', 'Tran Thi B', 'thib@gmail.com', '0902222222', '2001-08-15', 'Da Nang'),
('R003', 'Le Van C', NULL, '0903333333', '1999-12-20', 'Ho Chi Minh'),
('R004', 'Pham Thi D', 'thid@gmail.com', '0904444444', '2002-03-12', 'Can Tho'),
('R005', 'Hoang Van E', NULL, '0905555555', '2001-09-09', 'Hai Phong');

INSERT INTO Borrow_Card (borrow_card_id, borrow_date, return_date, reader_id)
VALUES
('BC001', '2026-04-01', '2026-04-10', 'R001'),
('BC002', '2026-04-02', '2026-04-11', 'R002'),
('BC003', '2026-04-03', '2026-04-12', 'R003'),
('BC004', '2026-04-04', '2026-04-13', 'R004'),
('BC005', '2026-04-05', '2026-04-14', 'R005');

INSERT INTO Borrow_Detail (borrow_card_id, book_id, book_status, borrow_fee)
VALUES
('BC001', 'B001', 'Moi', 15000),
('BC002', 'B002', 'Cu', 10000),
('BC003', 'B003', 'Moi', 20000),
('BC004', 'B004', 'Cu', 12000),
('BC005', 'B005', 'Moi', 18000);

UPDATE Book
SET quantity = quantity + 5
WHERE author = 'Nguyễn Nhật Ánh';

DELETE FROM Reader
WHERE email IS NULL;