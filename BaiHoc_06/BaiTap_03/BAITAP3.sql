SELECT user_id ,
 COUNT(*)  AS total_orders,
 SUM(CASE 
		WHEN status = 'CANCELLED' THEN 1 
        ELSE 0 
	END) AS cancelled_orders 
 FROM Bookings 
 GROUP BY user_id 
 HAVING 
	 COUNT(*) >= 10  AND
     SUM(CASE 
		WHEN status = 'CANCELLED' THEN 1 
        ELSE 0 
	END) > 5  ;
-- ========================================
-- GIẢI THÍCH
-- ========================================

-- 1. COUNT(*)
-- → Đếm tổng số đơn của mỗi user

-- 2. SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END)
-- → Nếu đơn là CANCELLED → +1
-- → Ngược lại → +0
-- → => Tổng chính là số đơn bị hủy

-- 3. HAVING
-- → Lọc sau khi GROUP BY
-- → Áp điều kiện:
--    - Tổng đơn ≥ 10
--    - Đơn hủy > 5

-- ========================================
-- KẾT LUẬN
-- ========================================

-- ✔ CASE WHEN giúp "lọc trong khi đang GROUP"
-- ✔ SUM dùng để đếm có điều kiện
-- ✔ HAVING dùng để lọc trên dữ liệu đã nhóm