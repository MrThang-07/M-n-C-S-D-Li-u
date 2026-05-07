-- ==============================================================================
-- BÀI TẬP: THẢM HỌA "BLACK FRIDAY"
-- Mục tiêu: Lấy danh sách khóa học chưa ai đăng ký (vượt qua bẫy dữ liệu NULL)
-- Kiến thức: Three-Valued Logic (Logic 3 trạng thái trong SQL)
-- ==============================================================================

-- [ PHẦN 1: KHÁM NGHIỆM TỬ THI - TẠI SAO TRUY VẤN SỤP ĐỔ VÌ 1 DÒNG NULL? ]
-- 1. Bản chất của NULL trong SQL:
--    - NULL không phải là số 0, cũng không phải chuỗi rỗng. NULL mang ý nghĩa là 
--      "UNKNOWN" (Không xác định/Không biết).
--    - Bạn không thể so sánh bằng (=) hay khác (!=) với một cái "Không biết". 
--      Mọi phép toán (id = NULL) hay (id != NULL) đều trả về kết quả là UNKNOWN.

-- 2. Phân tích toán học (Boolean Logic) của mệnh đề NOT IN:
--    - Giả sử hệ thống quét tới Khóa học có id = 5.
--    - Subquery trả về danh sách: (1, 2, NULL).
--    - Biểu thức: WHERE 5 NOT IN (1, 2, NULL)
--    - SQL sẽ phân giải (parse) biểu thức này thành chuỗi các phép toán AND:
--      => (5 != 1) AND (5 != 2) AND (5 != NULL)
--      => (TRUE)   AND (TRUE)   AND (UNKNOWN)
--      => Kết quả cuối cùng = UNKNOWN.

-- 3. Hậu quả:
--    - Mệnh đề WHERE của SQL cực kỳ nghiêm ngặt: Nó CHỈ giữ lại những dòng có 
--      kết quả đánh giá là TRUE tuyệt đối. 
--    - Vì vướng phải UNKNOWN, mọi dòng dữ liệu (dù id là gì đi nữa) đều bị 
--      đánh giá rớt. Truy vấn bên ngoài lập tức trả về tập hợp rỗng (0 dòng).

-- ==============================================================================
-- [ PHẦN 2: GIẢI PHÁP KIẾN TRÚC & THỰC THI ]
-- ==============================================================================

-- CÁCH 1: VÁ LỖ HỔNG CHO "NOT IN" (Vẫn dùng cấu trúc cũ nhưng phòng thủ)
-- Giải pháp: Thêm mệnh đề "WHERE course_id IS NOT NULL" vào ngay trong Subquery 
-- để lọc sạch rác trước khi đưa danh sách ra cho truy vấn cha xử lý.

SELECT * FROM Courses
WHERE id NOT IN (
    SELECT course_id 
    FROM Enrollments 
    WHERE course_id IS NOT NULL -- Tấm khiên chắn dữ liệu rác
);

-- ------------------------------------------------------------------------------

-- CÁCH 2: CHUYỂN SANG DÙNG "NOT EXISTS" (Lựa chọn của Tech Lead - An toàn tuyệt đối)
-- Tại sao an toàn? 
-- - EXISTS/NOT EXISTS chỉ quan tâm đến việc "Dòng dữ liệu có thỏa mãn điều kiện 
--   JOIN (c.id = e.course_id) hay không?", chứ không tạo ra một danh sách để so sánh.
-- - Khi e.course_id là NULL, phép so sánh (c.id = NULL) sinh ra UNKNOWN -> bị đánh 
--   giá là FALSE -> Nghĩa là "Không tồn tại dòng map với nhau" -> Vượt qua an toàn!

SELECT c.*
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.id
);