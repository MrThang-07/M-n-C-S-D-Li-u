CREATE DATABASE cine_magic;
USE cine_magic;

CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    age_restriction INT DEFAULT 0 CHECK (age_restriction IN (0, 13, 16, 18))
);

CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    max_seats INT NOT NULL CHECK (max_seats > 0),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'maintenance'))
);

CREATE TABLE showtimes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),
    
    FOREIGN KEY (movie_id) REFERENCES movies(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO movies (title, duration_minutes, age_restriction) VALUES
('Avengers: Secret Wars', 150, 13),
('Fast & Furious 11', 140, 16),
('The Nun 3', 120, 18),
('Doraemon Movie 2025', 100, 0);

INSERT INTO rooms (name, max_seats, status) VALUES
('Room A', 100, 'active'),
('Room B', 80, 'active'),
('Room C', 120, 'maintenance');

INSERT INTO showtimes (movie_id, room_id, show_time, ticket_price) VALUES
(1, 1, '2026-05-01 18:00:00', 90000),
(2, 2, '2026-05-01 20:00:00', 95000),
(3, 1, '2026-05-02 21:00:00', 100000),
(4, 2, '2026-05-02 17:00:00', 80000),
(1, 1, '2026-05-03 19:00:00', 90000);

INSERT INTO bookings (showtime_id, customer_name, phone) VALUES
(1, 'Nguyen Van A', '0901234567'),
(1, 'Tran Thi B', '0902345678'),
(2, 'Le Van C', '0903456789'),
(2, 'Pham Thi D', '0904567890'),
(3, 'Hoang Van E', '0905678901'),
(3, 'Vo Thi F', '0906789012'),
(4, 'Nguyen Van G', '0907890123'),
(4, 'Tran Thi H', '0908901234'),
(5, 'Le Van I', '0909012345'),
(5, 'Pham Thi K', '0910123456');