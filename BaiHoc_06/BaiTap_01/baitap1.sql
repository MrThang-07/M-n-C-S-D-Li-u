-- ❌ Vấn đề

-- Trong SQL:

-- WHERE chạy trước GROUP BY
-- SUM() là hàm tổng hợp, chỉ có giá trị sau khi GROUP BY

-- => Vì vậy WHERE SUM(...) là sai cú pháp → gây lỗi.
-- ==> phải dùng HAVING (dùng cho dữ liệu sau khi đã GROUP):

SELECT city, SUM(total_price) AS revenue
FROM Bookings
WHERE status = 'COMPLETED'
GROUP BY city
HAVING SUM(total_price) > 0;