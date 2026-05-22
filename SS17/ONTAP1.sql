CREATE DATABASE IF NOT EXISTS TechEdu_DB;
USE TechEdu_DB;

-- Bảng Học viên
CREATE TABLE IF NOT EXISTS Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active'
);

-- Bảng Khóa học
CREATE TABLE IF NOT EXISTS Courses (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    fee DECIMAL(10, 2) CHECK (fee >= 0)
);

-- Bảng Đăng ký học
CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id VARCHAR(10),
    grade DECIMAL(4, 2) CHECK (grade >= 0 AND grade <= 10),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ==========================================
-- 2. CHÈN DỮ LIỆU MẪU (DML)
-- ==========================================

-- Dữ liệu Học viên
-- Cố tình để Phạm Thị D không đăng ký môn nào (Phục vụ câu 14)
INSERT INTO Students (full_name, email, balance) VALUES 
('Nguyễn Văn A', 'vana@gmail.com', 1500000),
('Lê Thị B', 'lethib@gmail.com', 500000),
('Trần Văn C', 'tranc@gmail.com', 0),
('Phạm Thị D', 'phamd@gmail.com', 2000000),
('Hoàng Văn E', 'hoange@gmail.com', 100000);

-- Dữ liệu Khóa học
-- Cố tình để PY01 không có học viên đăng ký (Phục vụ câu 11)
INSERT INTO Courses (course_id, course_name, fee) VALUES 
('SQL01', 'Lập trình Cơ sở dữ liệu với MySQL', 1200000),
('WEB01', 'Lập trình Frontend với ReactJS', 2000000),
('PY01', 'Khoa học dữ liệu với Python', 2500000),
('JAVA01', 'Lập trình Backend Java Spring', 2200000);

-- Dữ liệu Đăng ký học (Enrollments)
-- Bao gồm các mức điểm khác nhau và có giá trị NULL (Phục vụ câu 9, câu 12, câu 13)
INSERT INTO Enrollments (student_id, course_id, grade) VALUES 
(1, 'SQL01', 7.5),     -- A học SQL được 7.5
(2, 'SQL01', 9.0),     -- B học SQL được 9.0 (Cao nhất môn SQL)
(3, 'SQL01', 5.0),     -- C học SQL được 5.0
(5, 'SQL01', 1.5),     -- E học SQL được 1.5 (Sẽ bị xóa ở Câu 6)
(1, 'WEB01', 8.0),     -- A học thêm Web
(2, 'WEB01', NULL),    -- B học Web nhưng chưa thi (grade là NULL)
(3, 'JAVA01', 6.5);    -- C học Java

-- CAU 5 -- 
-- Học viên có student_id = 1 vừa nộp bài thi. Viết câu lệnh UPDATE cập nhật điểm (grade) 
-- thành 8.5 cho học viên này tại khóa học có course_id = 'SQL01'.
UPDATE Enrollments SET grade = 8.5 WHERE course_id = 'SQL01' AND student_id = 1 ;
-- CAU 6 -- 
-- Viết câu lệnh DELETE để xóa tất cả các bản ghi đăng ký (Enrollments) có điểm số dưới 2.0. 
-- (Nêu một lưu ý ngắn gọn bằng comment -- về rủi ro nếu quên mệnh đề WHERE trong lệnh DELETE).
DELETE FROM Enrollments WHERE grade < 2.0 ;
-- CAU 7 -- 
-- Viết câu lệnh SELECT lấy ra full_name, email của tất cả học viên, sắp xếp tên theo thứ tự bảng chữ cái (ORDER BY ASC).
SELECT full_name, email FROM Students 
ORDER BY full_name ASC;
-- CAU 8 -- 
-- Viết câu lệnh truy vấn lấy ra danh sách 10 học viên ở trang thứ 3 (Giả sử mỗi trang hiển thị 10 học viên). Cần dùng LIMIT và OFFSET.
SELECT * FROM Students 
LIMIT 10 OFFSET 20 ;
--  CAU 9 -- 
-- (Sử dụng CASE WHEN): Hiển thị danh sách student_id, course_id, grade 
-- và tạo thêm một cột bí danh (Alias) tên là XepLoai. Logic phân loại:
-- grade >= 8 -> 'Giỏi'
-- grade >= 6 -> 'Khá'
-- grade dưới 6 -> 'Trung bình'
-- NULL -> 'Chưa thi'
SELECT student_id, course_id, grade , CASE 
	WHEN grade >= 8 THEN 'Giỏi'
	WHEN grade >= 6 THEN 'Khá'
    WHEN grade IS NULL THEN 'Chưa thi'
    ELSE  'Trung bình'
    END AS XepLoai
    FROM Enrollments;
-- CAU 10 -- 
-- Sử dụng INNER JOIN, hiển thị danh sách chi tiết các đăng ký gồm: full_name, course_name, grade
SELECT s.full_name, c.course_name, e.grade
FROM Students s
INNER JOIN Enrollments e 
ON s.student_id = e.student_id
INNER JOIN Courses c
ON e.course_id = c.course_id;
-- cau 11 -- 
-- Sử dụng LEFT JOIN, liệt kê tất cả các khóa học (course_name) và số lượng học viên đã đăng ký khóa đó. (Gợi ý: Dùng COUNT).
--  Những khóa chưa có ai đăng ký phải hiển thị số lượng là 0.
SELECT c.course_name ,COUNT(student_id) AS SOLUONG FROM Courses c
LEFT JOIN Enrollments e
ON e.course_id = c.course_id
GROUP BY c.course_name;
-- cau 12 -- 
-- Tính điểm trung bình (AVG) của từng khóa học.
--  Chỉ hiển thị những khóa học có điểm trung bình lớn hơn 7.0 (Sử dụng GROUP BY và HAVING).
SELECT course_id ,AVG(grade) FROM Enrollments
GROUP BY course_id
HAVING 7.0 < AVG(grade) ;
-- CAU13 --
-- (Scalar Subquery): Tìm danh sách các học viên (student_id, full_name) có điểm số ở môn 'SQL01' lớn hơn điểm trung bình của toàn bộ lớp 'SQL01'

SELECT s.student_id, s.full_name FROM Students s 
INNER JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 'SQL01' AND e.grade > (SELECT AVG(grade) 
      FROM Enrollments 
      WHERE course_id = 'SQL01' );

 -- CAU 14 -- 
 --  (Independent Subquery): Sử dụng NOT IN hoặc NOT EXISTS để tìm danh sách những học viên chưa từng đăng ký bất kỳ khóa học nào.
SELECT * FROM Students WHERE student_id NOT IN (SELECT student_id FROM Enrollments );
-- CAU 15 -- 
--  (Correlated Subquery): Truy vấn nhiều cấp độ. Viết câu lệnh tìm ra học viên có điểm số cao nhất trong mỗi khóa học.
SELECT s.student_id,s.full_name,e.grade, e.course_id FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id 
WHERE e.grade = (SELECT MAX(grade) FROM Enrollments e2 WHERE e2.course_id = e.course_id);
-- cau 16 -- 
-- (View): Tạo một View có tên vw_Studen tGrades tổng hợp thông tin: Mã học viên, Tên học viên, Tên khóa học và Điểm số.
CREATE VIEW vw_StudentGrades AS 
SELECT s.student_id,s.full_name, e.course_id, e.grade FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id ;

SELECT * FROM vw_StudentGrades;
--  CAU 17 -- 
--  (Stored Procedure với Tham số): Viết một thủ tục lưu trữ tên sp_EnrollCours
--  nhận vào 2 tham số IN: p_student_id và p_course_id, cùng 1 tham số OUT: p_message.
-- Logic: Chèn 1 dòng mới vào bảng Enrollments. Sau đó gán 'Đăng ký thành công' cho p_message.
DELIMITER $$ 
CREATE PROCEDURE sp_EnrollCours(IN p_student_id INT,IN p_course_id VARCHAR(10), OUT p_message VARCHAR(100))
BEGIN
		INSERT INTO Enrollments(student_id,course_id)
        VALUES 
			(p_student_id,p_course_id);
		SET p_message = 'Đăng ký thành công';
END $$
DELIMITER ;
CALL sp_EnrollCours(1,'SQL01',@p_message);
SELECT @p_message AS THONGBAO;
-- CAU 18 -- 
-- (Trigger với OLD/NEW): Tạo một Trigger có tên trg_AuditGradeUpdate:
-- Logic: Nếu điểm mới nhỏ hơn điểm cũ, hãy chặn thao tác cập nhật và báo lỗi.
DELIMITER $$ 
CREATE TRIGGER trg_AuditGradeUpdate
BEFORE UPDATE ON Enrollments 
FOR EACH ROW	
BEGIN
	IF 
		NEW.grade < OLD.grade THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'điểm mới nhỏ hơn điểm cũ' ;
	END IF;
END $$ 
DELIMITER ;
-- CAU 19 -- 
-- Trung tâm có nghiệp vụ "Thanh toán học phí". Yêu cầu viết một khối lệnh TRANSACTION thực hiện đồng thời 2 việc:
-- Trừ tiền balance của học viên (Bảng Students).
-- Ghi nhận trạng thái đăng ký vào bảng Enrollments.
-- Sử dụng START TRANSACTION, COMMIT và ROLLBACK để đảm bảo tính nguyên tử (Atomicity). Viết mã giả hoặc câu lệnh SQL mô phỏng nếu xảy ra lỗi không đủ tiền thì ROLLBACK.
DELIMITER $$
CREATE PROCEDURE sp_ThanhToanHocPhi(IN p_student_id INT , IN p_course_id VARCHAR(10))
	
BEGIN
	DECLARE v_balance DECIMAL(10, 2);
    DECLARE v_fee DECIMAL(10, 2);
SELECT 
    balance
INTO v_balance FROM
    Students
WHERE
    student_id = p_student_id;
SELECT 
    fee
INTO v_fee FROM
    Courses
WHERE
    course_id = p_course_id;
    START TRANSACTION;
    IF v_balance < v_fee THEN 
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' SỐ DƯ KHÔNG ĐỦ ';
	ELSE 
		UPDATE Students SET balance = balance - v_fee WHERE student_id = p_student_id;
        INSERT INTO Enrollments(student_id,course_id)
        VALUES (p_student_id,p_course_id);
        COMMIT ;
    END IF;
END $$
DELIMITER ;