-- DEMO THUC HANH SS11 / Nguyễn Quốc Thắng --

CREATE DATABASE DEMO_SS11;
USE DEMO_SS11;

CREATE TABLE persons (
    personId INT PRIMARY KEY,
    lastName VARCHAR(255),
    firstName VARCHAR(255),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(255),
    phone VARCHAR(20)
);

INSERT INTO persons (personId, lastName, firstName, email, address, city)
VALUES (1, 'Hung', 'Ho', 'hung@gmail.com', 'HN', 'HN');

--  TẠO THỦ TỤC 1: Lấy tất cả thông tin (getAllPersons)
DELIMITER $$
CREATE PROCEDURE getAllPersons()
BEGIN
    SELECT * FROM persons;
END $$
DELIMITER ;

-- 3. TẠO THỦ TỤC 2: Thêm mới person (insertPerson)
DELIMITER $$
CREATE PROCEDURE insertPerson(
    id_in INT, 
    last_name VARCHAR(255), 
    first_name VARCHAR(255), 
    email_in VARCHAR(100)
)
BEGIN
    INSERT INTO persons(personId, lastName, firstName, email)
    VALUES (id_in, last_name, first_name, email_in);
END $$
DELIMITER ;


--  GỌI THỦ TỤC
-- Gọi thủ tục insertPerson để thêm người mới
CALL insertPerson(2, 'Minh', 'Nguyen', 'minhnh@gmail.com');
CALL insertPerson(3, 'Tu', 'Huynh', 'tuhuynh@gmail.com');
-- Gọi thủ tục getAllPersons để xem kết quả toàn bộ bảng sau khi thêm
CALL getAllPersons();

-- lession 2 --

DELIMITER $$

CREATE PROCEDURE TinhTienGiamGia(
    IN don_gia DECIMAL(10,2),    -- Tham số IN: Ứng dụng truyền vào
    IN so_luong INT,             -- Tham số IN: Ứng dụng truyền vào
    OUT tien_thanh_toan DECIMAL(10,2) -- Tham số OUT: Trả về cho ứng dụng
)
BEGIN
    -- 1. Khai báo BIẾN NỘI BỘ (Chỉ dùng để nháp)
    DECLARE tong_tien_ban_dau DECIMAL(10,2);
    DECLARE ty_le_giam_gia DECIMAL(4,2) DEFAULT 0.00;

    -- 2. Tính toán lưu vào BIẾN NỘI BỘ
    SET tong_tien_ban_dau = don_gia * so_luong;

    -- 3. Xử lý logic phức tạp (Dùng biến nội bộ để ra quyết định)
    IF tong_tien_ban_dau > 1000 THEN
        SET ty_le_giam_gia = 0.10; -- Giảm 10%
    ELSEIF tong_tien_ban_dau > 500 THEN
        SET ty_le_giam_gia = 0.05; -- Giảm 5%
    END IF;

    -- 4. Đẩy kết quả cuối cùng ra THAM SỐ OUT
    SET tien_thanh_toan = tong_tien_ban_dau - (tong_tien_ban_dau * ty_le_giam_gia);
    
END $$

DELIMITER ;

CALL TinhTienGiamGia(120, 5, @ket_qua_tien);

SELECT @ket_qua_tien AS SoTienCanThanhToan;