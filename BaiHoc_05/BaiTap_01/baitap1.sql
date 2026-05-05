-- =========================================
-- 1. PHÂN TÍCH LỖI
-- =========================================
-- Nguyên nhân: AND có độ ưu tiên cao hơn OR
-- Query sai sẽ được hiểu là:
-- district = 'Quận 1'
-- OR (district = 'Quận 3' AND rating > 4.0)
-- => Quận 1 không bị lọc rating

-- =========================================
-- 2. TẠO DATABASE & BẢNG
-- =========================================
CREATE DATABASE promotion_test;
USE promotion_test;

CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    district VARCHAR(50) NOT NULL,
    rating DECIMAL(2,1) NOT NULL
);

-- =========================================
-- 3. DỮ LIỆU MẪU
-- =========================================
INSERT INTO restaurants (name, district, rating) VALUES
('Quan A', 'Quận 1', 2.5),
('Quan B', 'Quận 1', 4.5),
('Quan C', 'Quận 3', 4.2),
('Quan D', 'Quận 3', 3.5),
('Quan E', 'Quận 5', 4.8);

-- =========================================
-- 4. QUERY SAI
-- =========================================
SELECT *
FROM restaurants
WHERE district = 'Quận 1'
   OR district = 'Quận 3'
   AND rating > 4.0;

-- =========================================
-- 5. QUERY ĐÚNG (ĐÃ FIX)
-- =========================================
SELECT *
FROM restaurants
WHERE (district = 'Quận 1' OR district = 'Quận 3')
  AND rating > 4.0;