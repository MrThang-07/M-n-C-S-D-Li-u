-- =====================================================
-- BÁO CÁO: KHÁCH SẠN ĐẠT CHUẨN
-- Điều kiện:
-- 1. >= 50 đơn COMPLETED
-- 2. AVG(total_price) > 3,000,000
-- =====================================================


-- =====================================================
-- 1. HƯỚNG TIẾP CẬN 1 – LỌC TRỄ (BAD PRACTICE)
-- Không dùng WHERE, lọc bằng HAVING
-- =====================================================

SELECT 
    hotel_id
FROM bookings
GROUP BY hotel_id
HAVING 
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) >= 50
    AND AVG(CASE 
                WHEN status = 'COMPLETED' THEN total_price 
                ELSE NULL 
            END) > 3000000;



-- =====================================================
-- 2. HƯỚNG TIẾP CẬN 2 – LỌC SỚM (TỐI ƯU - KHUYẾN NGHỊ)
-- Dùng WHERE để loại bỏ dữ liệu không cần thiết trước
-- =====================================================

SELECT 
    hotel_id
FROM bookings
WHERE status = 'COMPLETED'
GROUP BY hotel_id
HAVING 
    COUNT(*) >= 50
    AND AVG(total_price) > 3000000;



-- =====================================================
-- 3. SO SÁNH & ĐÁNH GIÁ (TRADE-OFF)
-- =====================================================

-- Cách 1 (Lọc trễ bằng HAVING):
-- - Xử lý toàn bộ dữ liệu (kể cả đơn FAILED, CANCELLED)
-- - GROUP BY trên tập dữ liệu lớn
-- - Tốn CPU và RAM
-- - Hiệu năng kém khi dữ liệu lớn

-- Cách 2 (Lọc sớm bằng WHERE):
-- - Loại bỏ dữ liệu không cần ngay từ đầu
-- - Chỉ GROUP BY dữ liệu cần thiết
-- - Giảm CPU, RAM
-- - Tận dụng index tốt hơn
-- - Hiệu năng cao hơn nhiều

-- KẾT LUẬN:
-- WHERE dùng để lọc trước GROUP BY (tối ưu)
-- HAVING dùng để lọc sau GROUP BY