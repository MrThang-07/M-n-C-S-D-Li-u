-- 1. Tạo cơ sở dữ liệu và bảng dữ liệu mẫu
CREATE DATABASE bank;
USE bank;

CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    balance INT
);

-- 2. Thử nghiệm tính năng TRANSACTION cơ bản (Hình 2 + Hình 3)
START TRANSACTION;
INSERT INTO accounts(name, balance)
VALUES ('Nguyen Van A', 150),
       ('Nguyen Van B', 100);
ROLLBACK; -- Quay lại thời điểm trước khi thêm nếu không muốn lưu


-- 3. Đổi bộ phân tách lệnh để định nghĩa STORED PROCEDURE (Thủ tục lưu trữ)
DELIMITER $$

CREATE PROCEDURE send_money(IN sender_id INT, IN receiver_id INT, IN amount INT)
BEGIN
    -- Khai báo biến để kiểm tra số dư người gửi
    DECLARE balance_sender INT DEFAULT 0;

    -- Bắt đầu một giao dịch (đảm bảo tính toàn vẹn dữ liệu)
    START TRANSACTION;

    -- Cộng tiền vào tài khoản người nhận
    UPDATE accounts 
    SET balance = balance + amount 
    WHERE id = receiver_id;

    -- Trừ tiền từ tài khoản người gửi
    UPDATE accounts 
    SET balance = balance - amount 
    WHERE id = sender_id;

    -- Lấy số dư mới của người gửi để kiểm tra
    SELECT balance INTO balance_sender 
    FROM accounts 
    WHERE id = sender_id;

    -- Nếu số dư sau khi trừ bị âm (< 0), tiến hành hủy giao dịch
    IF balance_sender < 0 THEN
        ROLLBACK; -- quay lại thời điểm trc khi thay đổi
    ELSE
        COMMIT;   -- Nếu hợp lệ thì lưu vĩnh viễn thay đổi vào database
    END IF;

END $$

-- Trả lại bộ phân tách lệnh mặc định
DELIMITER ;


-- 4. Chạy thử nghiệm thủ tục chuyển tiền (Hình 7)
-- Giả sử bạn đã thêm lại dữ liệu mẫu có id = 3 và id = 4
-- Gọi thủ tục: chuyển 60 từ tài khoản id=3 sang tài khoản id=4
CALL send_money(3, 4, 60);

-- Kiểm tra lại kết quả trong bảng
SELECT * FROM accounts;