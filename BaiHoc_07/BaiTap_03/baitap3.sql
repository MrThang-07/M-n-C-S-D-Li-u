-- ==============================================================================
-- BÀI TẬP: CHIẾN DỊCH "ĐÁNH THỨC HỌC VIÊN NGỦ ĐÔNG"
-- Mục tiêu: Lấy danh sách Email học viên chưa từng mua khóa học nào trong năm 2024.
-- Bối cảnh: Database lớn (5 triệu users). So sánh hiệu năng NOT IN vs NOT EXISTS.
-- ==============================================================================

-- [ PHẦN 1: BẢO VỆ QUAN ĐIỂM - TẠI SAO BẠN B (NOT EXISTS) THẮNG? ]
-- Dưới góc độ Tech Lead quản trị Database 5 triệu users, hiệu năng (Performance) 
-- là yếu tố sống còn. Lựa chọn NOT EXISTS tối ưu hơn hẳn vì cơ chế "Short-circuit":
--
-- 1. Cơ chế của NOT IN (Lựa chọn của bạn A - Kém tối ưu cho Big Data):
--    - Hệ thống thường phải thực thi subquery từ đầu đến cuối để tạo ra một 
--      "danh sách" (list) khổng lồ trong bộ nhớ chứa hàng triệu ID đã thanh toán năm 2024.
--    - Sau đó, quét bảng Students và đem từng ID dò tìm (scan) trong danh sách khổng lồ kia. 
--      Việc này tiêu tốn cực kỳ nhiều RAM và I/O.
--    - (Bonus: NOT IN sẽ bị sai logic nghiêm trọng nếu subquery vô tình lọt dù chỉ 1 giá trị NULL).
--
-- 2. Cơ chế Short-circuit (Dừng sớm) của NOT EXISTS (Lựa chọn của bạn B - Tối ưu):
--    - EXISTS/NOT EXISTS hoạt động theo nguyên lý kiểm tra sự tồn tại (trả về TRUE/FALSE).
--    - Nó duyệt từng dòng của bảng ngoài (Students), truyền ID vào subquery để kiểm tra.
--    - >> ĐIỂM ĂN TIỀN (Short-circuit): Ngay khi rà soát bảng Payments và tìm thấy 
--      DÒNG ĐẦU TIÊN của học viên đó trong năm 2024, hệ thống LẬP TỨC DỪNG TÌM KIẾM 
--      cho học viên đó và đánh giá là FALSE (vì đang dùng NOT EXISTS). Nó không cần 
--      quan tâm học viên đó còn 10 hay 100 hóa đơn khác nữa.
-- 
-- => KẾT LUẬN: "Dừng sớm" giúp MySQL gạch bỏ hàng triệu phép toán quét dữ liệu dư thừa. 
--    Với 5 triệu records, bạn B đã viết ra một truy vấn có khả năng Scale (mở rộng) vượt trội.

-- ==============================================================================
-- [ PHẦN 2: THỰC THI - CÂU LỆNH SQL HOÀN CHỈNH ]
-- Kỹ thuật: NOT EXISTS + Truy vấn lồng tương quan (Correlated Subquery)
-- ==============================================================================

SELECT s.email
FROM Students s
WHERE NOT EXISTS (
    -- Truy vấn lồng tương quan: Lấy ID từ bảng ngoài (s.student_id) ráp vào bảng trong (p.student_id)
    -- Tech Lead Tip: Dùng SELECT 1 thay vì SELECT * để tối ưu, vì EXISTS chỉ cần 
    -- kiểm tra xem có dòng nào tồn tại hay không, không cần lôi dữ liệu thực tế ra.
    SELECT 1
    FROM Payments p
    WHERE p.student_id = s.student_id
      -- Tech Lead Tip 2: Không dùng hàm YEAR(p.payment_date) = 2024.
      -- Bọc hàm quanh cột sẽ làm chết Index (Non-SARGable). 
      -- Phải dùng toán tử so sánh khoảng thời gian để quét Index nhanh nhất.
      AND p.payment_date >= '2024-01-01' 
      AND p.payment_date < '2025-01-01'
);