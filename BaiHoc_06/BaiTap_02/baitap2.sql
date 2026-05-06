-- ========================================
-- TÍNH GIÁ RẺ NHẤT MỖI KHÁCH SẠN
-- ========================================

SELECT 
    hotel_id,
    MIN(price_per_night) AS min_price
FROM Rooms
GROUP BY hotel_id;

-- ========================================
-- PHÂN TÍCH LỖI BAN ĐẦU
-- ========================================

-- Query sai ban đầu:
-- SELECT hotel_id, room_name, MIN(price_per_night)
-- FROM Rooms
-- GROUP BY hotel_id;

-- ❌ Lỗi xảy ra do:
-- Khi GROUP BY hotel_id, mỗi khách sạn là 1 nhóm.
-- Nhưng trong SELECT lại có thêm room_name.

-- 👉 Trong 1 khách sạn có nhiều phòng → nhiều room_name khác nhau
-- Ví dụ:
-- hotel_id = 1 có:
--   room A - 500k
--   room B - 300k

-- MIN(price_per_night) = 300k (xác định được)
-- Nhưng room_name là gì?
-- → A hay B ❓ → KHÔNG XÁC ĐỊNH

-- ❌ Vi phạm quy tắc GROUP BY:
-- Mỗi cột trong SELECT phải:
--   1. Nằm trong GROUP BY
--   2. Hoặc là hàm tổng hợp (MIN, MAX, SUM...)

-- room_name:
--   - Không nằm trong GROUP BY
--   - Không phải hàm tổng hợp
-- → Gây mơ hồ dữ liệu (ambiguous result)

-- ❌ MySQL 8.0 (ONLY_FULL_GROUP_BY):
-- Không cho phép trả về dữ liệu "không xác định"
-- → Nên báo lỗi để tránh sai logic

-- ========================================
-- KẾT LUẬN
-- ========================================

-- ✔ Chỉ chọn những cột hợp lệ:
--   - hotel_id (GROUP BY)
--   - MIN(price_per_night) (hàm tổng hợp)

-- ✔ Nếu muốn lấy thêm room_name:
-- → Phải dùng JOIN hoặc subquery để xác định đúng phòng có giá thấp nhất
-- ========================================