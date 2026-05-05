-- =========================================
-- 1. PHÂN TÍCH & BẪY DỮ LIỆU
-- =========================================
-- Hệ thống cần lọc tài xế thỏa mãn:
-- + status = 'AVAILABLE'
-- + trust_score >= 80
-- + trust_score >= min_trust_score (config từ hệ thống)

-- Bẫy: Nếu min_trust_score < 0 (ví dụ -10)
-- => Điều kiện trust_score >= -10 luôn đúng
-- => Lấy cả tài xế điểm thấp → sai nghiệp vụ

-- =========================================
-- 2. LOGIC BACKEND (GIẢ LẬP)
-- =========================================
-- IF min_trust_score < 0 THEN
--     SET min_trust_score = 0
-- END IF

-- =========================================
-- 3. SQL TRIỂN KHAI (CHUẨN)
-- =========================================
SELECT *
FROM drivers
WHERE status = 'AVAILABLE'
  AND trust_score >= GREATEST(80, :min_trust_score)
ORDER BY distance_km ASC, trust_score DESC;