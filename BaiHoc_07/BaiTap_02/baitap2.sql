-- ==============================================================================
-- BÀI TẬP: BÁO CÁO "BIẾN MẤT" CỦA PHÒNG ĐÀO TẠO
-- Mục tiêu: Tính tổng số tiền thu được từ học viên VIP (tổng chi tiêu > 10.000.000đ)
-- ==============================================================================

-- [ PHÂN TÍCH LỖI: "Every derived table must have its own alias" ]
-- 1. Derived Table (Bảng dẫn xuất) là gì?
--    - Nó là một bảng dữ liệu tạm thời, sinh ra ngay trong bộ nhớ từ một 
--      câu lệnh SELECT nằm bên trong mệnh đề FROM của truy vấn cha.
--    - Trong bài này, đoạn (SELECT student_id, SUM(amount)...) chính là Derived Table.

-- 2. Tại sao chuẩn SQL bắt buộc phải có Alias (Bí danh)?
--    - Tính định danh: Mọi nguồn dữ liệu ở mệnh đề FROM phải được đối xử như một bảng thực. 
--      Bảng tạm này sinh ra hoàn toàn "vô danh", hệ thống cần tên để tham chiếu.
--    - Tránh nhập nhằng (Ambiguity): Nếu cần JOIN bảng tạm này với bảng khác, 
--      hệ thống bắt buộc phải biết cột total_spent thuộc về bảng nào (ví dụ: TenBangTam.total_spent).
-- 
-- => CÁCH SỬA: Thêm bí danh (ví dụ: AS vip_students) ngay sau dấu ngoặc đóng của subquery.

-- ==============================================================================
-- [ CÂU LỆNH THỰC THI ĐÃ SỬA LỖI ]
-- ==============================================================================

SELECT SUM(total_spent) AS total_revenue_from_vips
FROM (
    SELECT student_id, SUM(amount) AS total_spent
    FROM Payments
    GROUP BY student_id
    HAVING SUM(amount) > 10000000
) AS vip_students; -- Dòng này chứa bí danh bắt buộc để fix lỗi Syntax