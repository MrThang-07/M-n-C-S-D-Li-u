-- ==========================================
-- HỆ THỐNG QUẢN LÝ KHÓA HỌC TRUNG TÂM ĐÀO TẠO
-- ==========================================

CREATE DATABASE IF NOT EXISTS CourseManagement;
USE CourseManagement;

-- 1. Tạo bảng students (Sinh viên)
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT
);

-- 2. Tạo bảng courses (Khóa học)
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    tuition_fee DECIMAL(10, 2) NOT NULL
);

-- 3. Tạo bảng enrollments (Đăng ký học)
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    score DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- ==========================================
-- YÊU CẦU 3: NHẬP DỮ LIỆU
-- ==========================================

-- Chèn 10 sinh viên
INSERT INTO students (full_name, gender, age) VALUES
('Nguyen Van A', 'Nam', 19),
('Tran Thi B', 'Nữ', 20),
('Le Van C', 'Nam', 21),
('Pham Thi D', 'Nữ', 19),
('Hoang Van E', 'Nam', 22),
('Vu Thi F', 'Nữ', 20),
('Do Van G', 'Nam', 23),
('Bui Thi H', 'Nữ', 19),
('Dang Van I', 'Nam', 21),
('Ngo Thi J', 'Nữ', 20);

-- Chèn 5 khóa học
INSERT INTO courses (course_name, tuition_fee) VALUES
('Java', 3000000),
('Python', 2500000),
('MySQL', 2000000),
('ReactJS', 3500000),
('Testing', 2200000);

-- Chèn 15 bản ghi đăng ký học
INSERT INTO enrollments (student_id, course_id, enroll_date, score) VALUES
(1, 1, '2026-01-10', 8.5),
(1, 3, '2026-01-12', 7.0),
(2, 2, '2026-01-15', 9.0),
(2, 4, '2026-01-16', 8.0),
(3, 1, '2026-01-20', 6.5),
(3, 5, '2026-01-22', 7.5),
(4, 3, '2026-02-01', 9.5),
(5, 4, '2026-02-05', 8.5),
(6, 1, '2026-02-10', 7.0),
(6, 2, '2026-02-11', 8.0),
(7, 5, '2026-02-15', 6.0),
(8, 1, '2026-02-20', 9.0),
(8, 4, '2026-02-22', 8.5),
(9, 2, '2026-03-01', 7.5),
(10, 3, '2026-03-05', 8.0);


-- ==========================================
-- ĐÁP ÁN 21 CÂU TRUY VẤN
-- ==========================================

-- Câu 1: Hiển thị toàn bộ sinh viên.
SELECT * FROM students;

-- Câu 2: Hiển thị: Tên sinh viên, Tuổi sử dụng Alias.
SELECT full_name AS 'Tên sinh viên', age AS 'Tuổi' FROM students;

-- Câu 3: Cập nhật tuổi của một sinh viên bất kỳ theo mã sinh viên.
UPDATE students SET age = 22 WHERE student_id = 1;

-- Câu 4: Xóa một bản ghi đăng ký học.
DELETE FROM enrollments WHERE enrollment_id = 15;

-- Câu 5: Đếm số lượng sinh viên.
SELECT COUNT(*) AS total_students FROM students;

-- Câu 6: Tính: Điểm cao nhất, Điểm thấp nhất, Điểm trung bình.
SELECT 
    MAX(score) AS max_score, 
    MIN(score) AS min_score, 
    AVG(score) AS avg_score 
FROM enrollments;

-- Câu 7: Tính tổng học phí của tất cả khóa học.
SELECT SUM(tuition_fee) AS total_tuition_fee FROM courses;

-- Câu 8: Đếm số sinh viên theo từng khóa học.
SELECT c.course_name, COUNT(e.student_id) AS total_student
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Câu 9: Tính điểm trung bình của từng khóa học.
SELECT c.course_name, AVG(e.score) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Câu 10: Tìm khóa học có trên 2 sinh viên.
SELECT c.course_name, COUNT(e.student_id) AS total_student
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 2;

-- Câu 11: Tìm sinh viên có điểm cao nhất.
SELECT s.full_name, c.course_name, e.score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.score = (SELECT MAX(score) FROM enrollments);

-- Câu 12: Tìm sinh viên có điểm thấp nhất.
SELECT s.full_name, c.course_name, e.score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.score = (SELECT MIN(score) FROM enrollments);

-- Câu 13: Tìm sinh viên có điểm cao hơn điểm trung bình.
SELECT s.full_name, c.course_name, e.score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.score > (SELECT AVG(score) FROM enrollments);

-- Câu 14: Tìm khóa học có học phí cao nhất.
SELECT * FROM courses 
WHERE tuition_fee = (SELECT MAX(tuition_fee) FROM courses);

-- Câu 15: Hiển thị: Tên sinh viên, Tên khóa học, Điểm.
SELECT s.full_name, c.course_name, e.score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Câu 16: Hiển thị: Tên sinh viên, Tên khóa học, Ngày đăng ký.
SELECT s.full_name, c.course_name, e.enroll_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Câu 17: Đếm số lượng sinh viên theo từng khóa học.
SELECT c.course_name, COUNT(e.student_id) AS total_student
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Câu 18: Tính điểm trung bình từng khóa học.
SELECT c.course_name, AVG(e.score) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Câu 19: Tìm khóa học có nhiều sinh viên nhất.
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC
LIMIT 1;

-- Câu 20: Tìm sinh viên học nhiều khóa học nhất.
SELECT s.full_name, COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.full_name
ORDER BY course_count DESC
LIMIT 1;

-- Câu 21: Hiển thị danh sách sinh viên có điểm cao hơn điểm trung bình của khóa học đang học.
SELECT s.full_name, c.course_name, e.score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.score > (
    SELECT AVG(e2.score)
    FROM enrollments e2
    WHERE e2.course_id = e.course_id
);