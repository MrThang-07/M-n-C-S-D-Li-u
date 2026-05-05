-- =========================================
-- 1. PHÂN TÍCH
-- =========================================
-- LIMIT không có ORDER BY => kết quả ngẫu nhiên
-- Không đảm bảo lấy đúng 5 quán mới nhất

-- =========================================
-- 2. QUERY SAI
-- =========================================
SELECT *
FROM restaurants
LIMIT 5;

-- =========================================
-- 3. QUERY ĐÚNG (FIX)
-- =========================================
SELECT *
FROM restaurants
ORDER BY created_at DESC
LIMIT 5;