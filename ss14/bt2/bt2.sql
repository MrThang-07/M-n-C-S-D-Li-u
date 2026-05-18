
DROP PROCEDURE IF EXISTS TransferBed;


DELIMITER //

CREATE PROCEDURE TransferBed(
    IN p_patient_id INT, 
    IN p_new_bed_id INT
)
BEGIN
    -- Khai báo Handler để xử lý khi gặp lỗi SQL hoặc sự cố thực thi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Nếu xảy ra lỗi, hoàn nguyên toàn bộ thay đổi về trạng thái ban đầu
        ROLLBACK;
    END;

    -- Bắt đầu một giao dịch (Transaction) an toàn
    START TRANSACTION;

    -- Thao tác 1: Giải phóng giường cũ (chuyển patient_id về NULL)
    UPDATE Beds 
    SET patient_id = NULL 
    WHERE patient_id = p_patient_id;

    -- Thao tác 2: Gán bệnh nhân vào giường mới
    UPDATE Beds 
    SET patient_id = p_patient_id 
    WHERE bed_id = p_new_bed_id;

    -- Nếu cả hai thao tác trên đều thành công, lưu vĩnh viễn thay đổi vào DB
    COMMIT;

END //

DELIMITER ;