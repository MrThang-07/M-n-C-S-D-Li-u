-- Lỗi Subquery returns more than 1 row (Truy vấn con trả về nhiều hơn 1 dòng) là một trong những "cái bẫy" kinh điển nhất khi làm việc vớ
-- sửa lại code .
SELECT title, price
FROM Courses
WHERE price IN (SELECT price FROM Courses WHERE instructor_id = 5);