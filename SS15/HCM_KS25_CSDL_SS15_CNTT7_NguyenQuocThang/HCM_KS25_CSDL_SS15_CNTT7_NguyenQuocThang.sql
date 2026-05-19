-- 1. Tạo và sử dụng Cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS StudentManagement;
USE StudentManagement;

-- 2. Xóa các bảng cũ nếu đã tồn tại theo đúng thứ tự ràng buộc khóa ngoại
DROP TABLE IF EXISTS grade_log;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS students;

-- 3. Tạo bảng students (Thông tin sinh viên)
CREATE TABLE students (
    student_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    total_debt DECIMAL(10,2) DEFAULT 0.00
);

-- 4. Tạo bảng subjects (Môn học)
CREATE TABLE subjects (
    subject_id VARCHAR(5) PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL,
    credits INT,
    CONSTRAINT chk_credits CHECK (credits > 0)
);

-- 5. Tạo bảng grades (Điểm số)
CREATE TABLE grades (
    student_id VARCHAR(5),
    subject_id VARCHAR(5),
    score DECIMAL(4,2),
    PRIMARY KEY (student_id, subject_id), -- Khóa chính phức hợp
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 10)
);

-- 6. Tạo bảng grade_log (Lịch sử sửa điểm)
CREATE TABLE grade_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(5),
    old_score DECIMAL(4,2),
    new_score DECIMAL(4,2),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- ---------------------------------------------------------------------
-- CHÈN DỮ LIỆU MẪU KIỂM THỬ (TEST CASES SUITE)
-- ---------------------------------------------------------------------

-- Chèn dữ liệu mẫu cho bảng Sinh viên (students)
INSERT INTO students (student_id, full_name, total_debt) VALUES 
('SV01', 'Le Hoang Nam', 3500000.00), -- Phục vụ cho câu 4 (Đóng học phí)
('SV03', 'Tran Quoc Anh', 0.00),       -- Sinh viên sạch nợ
('SV04', 'Vu Phuong Thao', 1500000.00);

-- Chèn dữ liệu mẫu cho bảng Môn học (subjects)
INSERT INTO subjects (subject_id, subject_name, credits) VALUES 
('SUB01', 'Database Systems', 3),
('SUB02', 'Java Programming', 4),
('SUB03', 'Web Development', 3);

-- Chèn dữ liệu mẫu cho bảng Điểm số (grades)
INSERT INTO grades (student_id, subject_id, score) VALUES 
('SV01', 'SUB01', 3.50),  -- Điểm < 4.0: Phục vụ test Câu 5 (Cho phép sửa điểm vì tạch môn)
('SV01', 'SUB02', 7.50),  -- Điểm >= 4.0: Phục vụ test Câu 5 (Chặn sửa điểm vì đã qua môn)
('SV04', 'SUB01', 5.00);

-- ---------------------------------------------------------------------
-- XÁC MINH DỮ LIỆU SAU KHI KHỞI TẠO
-- ---------------------------------------------------------------------
SELECT 'students' AS Table_Name, COUNT(*) AS Total_Rows FROM students
UNION ALL
SELECT 'subjects', COUNT(*) FROM subjects
UNION ALL
SELECT 'grades', COUNT(*) FROM grades
UNION ALL
SELECT 'grade_log', COUNT(*) FROM grade_log;

-- CAU 1 --
DELIMITER $$
CREATE TRIGGER tg_check_score
BEFORE INSERT ON  grades
FOR EACH ROW 
BEGIN 
	IF NEW.score > 0 
		THEN SET  NEW.score = 0 ;
    ELSEIF NEW.score > 10 
		THEN SET score = 10 ;
    END IF ;
END $$
DELIMITER ;

-- CAU 2 --
DELIMITER $$
CREATE PROCEDURE All_or_Nothing
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN 
		ROLLBACK;
	END ;
	START TRANSACTION ;
    INSERT IN students(student_id, full_name)
    VALUES ('SV02','Ha Bich Ngoc');
    UPDATE FROM students SET total_debt =  5.000.000;
    COMMIT ;
DELIMITER ;
-- CAU 3 --
DELIMITER $$
CREATE TRIGGER tg_log_grade_update
AFTER UPDATE ON  grades
FOR EACH ROW 
BEGIN 
	DECLARE V_OLDscore DECIMAL(4,2);
    DECLARE V_NEWscore DECIMAL(4,2);
	SELECT OLD.score INTO V_OLDscore FROM grades WHERE student_id = NEW.student_id;
	SELECT NEW.score INTO V_NEWscore FROM grades WHERE student_id = NEW.student_id;
	INSERT INTO grade_log(student_id, old_score,new_score,change_date )
    VALUES (NEW.student_id,V_OLDscore,V_NEWscore,NOW());
END $$
DELIMITER ;
-- CAU 4 -- 
-- CAU 5 -- 
DELIMITER //

CREATE TRIGGER tg_prevent_pass_update
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN 
	IF OLD.score >= 4 THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Lỗi: Điểm cũ trên 4 không đảm bảo tính minh bạch';
    END IF;
END //

DELIMITER ;