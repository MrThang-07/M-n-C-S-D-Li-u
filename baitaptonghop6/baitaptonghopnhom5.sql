CREATE DATABASE TopUser_VIP_db;
USE TopUser_VIP_db;

CREATE TABLE Hotels(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    StarRating INT NOT NULL
);

CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    User_name VARCHAR(50) NOT NULL,
    Phone CHAR(13),
    email VARCHAR(50) UNIQUE,
    Dob DATE,
    address VARCHAR(50)
);

CREATE TABLE Bookings(
    Bookings_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(12,2) NOT NULL,
    status VARCHAR(20),
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(id)
);

INSERT INTO Hotels(name, StarRating) VALUES
('Thành đẹp trai',5),
('Thiên lý ơi',4),
('Khiêm lùn',3),
('thắng',2),
('Thua',1),
('Đâu cũng được',5);

INSERT INTO users (User_name, Phone, email, Dob, address)
VALUES
('Nguyen Van A', '0123456789012', 'vana@example.com', '1990-05-12', 'Hanoi'),
('Tran Thi B', '0987654321098', 'thib@example.com', '1988-11-23', 'Ho Chi Minh City'),
('Le Van C', '0912345678901', 'vanc@example.com', '1995-07-01', 'Da Nang'),
('Pham Thi D', '0934567890123', 'thid@example.com', '2000-02-14', 'Can Tho'),
('Hoang Van E', '0909876543210', 'vane@example.com', '1992-09-30', 'Hue');

INSERT INTO Bookings (price, status, user_id, hotel_id)
VALUES
(50000000, 'COMPLETED', 1, 1),
(20000000, 'COMPLETED', 1, 6),
(60000000, 'COMPLETED', 2, 2),
(-2000000, 'COMPLETED', 2, 2),
(70000000, 'COMPLETED', 3, 1),
(30000000, 'PENDING', 4, 3),
(80000000, 'COMPLETED', 5, 1);

SELECT 
    users.User_name,
    Hotels.StarRating,
    SUM(Bookings.price) AS total_spent
FROM users
JOIN Bookings 
    ON users.user_id = Bookings.user_id
JOIN Hotels 
    ON Bookings.hotel_id = Hotels.id
WHERE 
    Bookings.status = 'COMPLETED'
    AND Bookings.price > 0
GROUP BY 
    users.User_name,
    Hotels.StarRating
HAVING 
    SUM(Bookings.price) > 50000000
ORDER BY 
    Hotels.StarRating DESC,
    total_spent DESC;