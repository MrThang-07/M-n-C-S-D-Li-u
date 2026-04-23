-- CÓ 2 LỖI ---
-- LỖI THỨ 1 : Bị thiếu một dấu nháy đơn đóng ' cho giá trị chuỗi của cột ShipperName .
-- LỖI THỨ 2 : Không khai báo danh sách cột cần chèn dữ liệu.Cú pháp INSERT INTO SHIPPERS VALUES (...) (không có danh sách cột)
-- bắt buộc bạn phải truyền vào đủ số lượng giá trị tương ứng với số cột trong bảng (ở đây bảng có 3 cột: ShipperID, ShipperName, Phone).
-- chỉ truyền 1 giá trị là 'Viettel Post', do đó MySQL sẽ báo lỗi “Column count doesn't match value count”
-- SỬA LẠI 

CREATE DATABASE BAITAP2_SS3;
USE BAITAP2_SS3;

CREATE TABLE SHIPPERS (
    ShipperID INT PRIMARY KEY AUTO_INCREMENT,
    ShipperName VARCHAR(255),
    Phone VARCHAR(20)
);

INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Giao Hàng Nhanh', '0901234567');

INSERT INTO SHIPPERS (ShipperName)
VALUES ('Viettel Post');