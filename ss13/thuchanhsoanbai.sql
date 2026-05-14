


CREATE DATABASE session12;

USE session12;

-- tạo bảng Student
CREATE TABLE Student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    sex BIT,
    birthday DATE,
    phone VARCHAR(11) UNIQUE
);

-- tạo trigger kiểm tra ngày sinh trước khi insert
DELIMITER $$

CREATE TRIGGER trigger_before_insert_student
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    -- kiểm tra ngày sinh phải nhỏ hơn ngày hiện tại
    IF NEW.birthday >= CURRENT_DATE() THEN
        
        -- ném thông báo lỗi
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the them ngay sinh lon hon hoac bang ngay hien tai';
        
    END IF;
END $$

DELIMITER ;

-- test insert dữ liệu hợp lệ
INSERT INTO Student(name, sex, birthday, phone)
VALUES ('Nguyen Van A', 1, '2003-12-12', '0932974868');

-- test insert dữ liệu lỗi
INSERT INTO Student(name, sex, birthday, phone)
VALUES ('Nguyen Van B', 1, '2025-12-12', '0912345678');


SELECT * FROM Student;