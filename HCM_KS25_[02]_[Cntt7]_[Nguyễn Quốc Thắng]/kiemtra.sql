CREATE DATABASE CenterManagement;
USE CenterManagement;

CREATE TABLE Student(
	Student_id INT AUTO_INCREMENT PRIMARY KEY ,
    Name_Student CHAR(255) NOT NULL ,
    Email CHAR(255) NOT NULL ,
    Phonenumber CHAR(10) NOT NULL ,
    DateStudent date not null 
);

CREATE TABLE Course(
	Course_ID INT AUTO_INCREMENT PRIMARY KEY ,
    CourseName CHAR(255) NOT NULL ,
    LECTURER CHAR(255) NOT NULL ,
    TuitionFee INT NOT NULL ,
    DURATION INT NOT NULL ,  
    Student_id INT , 
    FOREIGN KEY (Student_id) REFERENCES Student(Student_id)
);

CREATE TABLE Enrollment(
	Enrollment_id VARCHAR(55) PRIMARY KEY ,
    EnrollmentDate DATE ,
    PAYMENTMETHODS CHAR(55) NOT NULL ,
    Course_ID INT , 
	FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    Student_id INT ,
    FOREIGN KEY (Student_id) REFERENCES Student(Student_id)
);

CREATE TABLE Enrollment_Detail(
	Enrollment_Detail_ID INT AUTO_INCREMENT PRIMARY KEY ,
    Status_study char(55) NOT NULL ,
    CourseName_Detail CHAR(255) NOT NULL ,
    Giang_vien CHAR(255) NOT NULL,
    Diem_So FLOAT(3,2) NOT NULL ,
    Enrollment_id VARCHAR(55) , 
    FOREIGN KEY (Enrollment_id) REFERENCES Enrollment(Enrollment_id),
    Course_ID  INT, 
	FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    Student_id INT ,
    FOREIGN KEY (Student_id) REFERENCES Student(Student_id)
);

ALTER TABLE Enrollment
ADD Ghi_chu TEXT ; 

ALTER TABLE Course
CHANGE LECTURER Giao_Vien CHAR(255) NOT NULL ;

DROP TABLE Enrollment_Detail;
DROP TABLE Enrollment;

INSERT INTO Student(Name_Student,Email,Phonenumber,DateStudent)
VALUES 
('Thang', 'tn111@gamil.com', '0361111111', '2007-05-04'),
('Toan', 'tn222@gamil.com', '0362222222', '2007-05-06'),
('Hai', 'tn333@gamil.com', '0363333333', '2007-07-07'),
('Hieu', 'tn444@gamil.com', '0364444444', '2007-05-08'),
('Nhat', 'tn555@gamil.com', '0365555555', '2007-05-09');

INSERT INTO Course(CourseName,Giao_Vien,TuitionFee,DURATION)
VALUES 
('Cơ sở dữ liệu','Trần Anh', 1000000, 3),
('lập trình C','Nguyen Van B', 2000000, 4),
('Lập trình WEB','Nguyen Van C', 3000000, 5),
('Tieng anh giao tiep cơ bản','Nguyen Van D', 1000000, 2),
('IELTS 6.5','Nguyen Van E', 3000000, 2);

INSERT INTO Enrollment(Enrollment_id,EnrollmentDate,PAYMENTMETHODS,Student_id)
VALUES 
('PDK001', '2026-05-04', 'TIỀN MẶT', 1),
('PDK002', '2026-07-05', 'TIỀN MẶT', 2),
('PDK003', '2026-05-06', 'CHUYỂN KHOẢN', 3),
('PDK004', '2026-07-07', 'TIỀN MẶT', 4),
('PDK005', '2026-05-08', 'CHUYỂN KHOẢN', 5);

INSERT INTO Enrollment_Detail(Enrollment_id,CourseName_Detail,Giang_vien,Diem_So,Status_study)
VALUES 
('PDK001', 'Cơ sở dữ liệu', 'Trần Anh', 8.9, 'Đang học'),
('PDK002', 'lập trình C', 'Nguyen Van B', 7, 'Đang học'),
('PDK003', 'Lập trình WEB', 'Nguyen Van C', 5, 'Bảo lưu'),
('PDK004', 'Tieng anh giao tiep cơ bản', 'Nguyen Van D', 8, 'Đang học'),
('PDK005', 'IELTS 6.5', 'Nguyen Van E', 9, 'Đang học');

DELETE FROM Student WHERE Emai is null ;