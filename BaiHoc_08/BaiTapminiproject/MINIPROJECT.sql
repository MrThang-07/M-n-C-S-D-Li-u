
CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);


CREATE TABLE Employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    gender INT DEFAULT 1,
    birth_date DATE,
    salary DECIMAL(10,2),
    dept_id INT,
    
    CONSTRAINT fk_employee_department
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON UPDATE CASCADE
);

CREATE TABLE Project (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(150) NOT NULL,
    emp_id INT,
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,

    CONSTRAINT fk_project_employee
        FOREIGN KEY (emp_id)
        REFERENCES Employee(emp_id)
);

ALTER TABLE Employee 
ADD email VARCHAR(100) UNIQUE ;

ALTER TABLE Project MODIFY project_name VARCHAR(200) NOT NULL ;

ALTER TABLE Project ADD CONSTRAINT CHEK_project CHECK( end_date >= start_date);


INSERT INTO Department (dept_id, dept_name, location)
VALUES
(1, 'IT', 'Ha Noi'),
(2, 'HR', 'HCM'),
(3, 'Marketing', 'Da Nang');


INSERT INTO Employee (
    emp_id,
    emp_name,
    gender,
    birth_date,
    salary,
    dept_id,
    email
)
VALUES
(1, 'Nguyen Van A', 1, '1990-01-15', 1500, 1, 'a@gmail.com'),
(2, 'Tran Thi B', 0, '1995-05-20', 1200, 1, 'b@gmail.com'),
(3, 'Le Minh C', 1, '1988-10-10', 2000, 2, 'c@gmail.com'),
(4, 'Pham Thi D', 0, '1992-12-05', 1800, 3, 'd@gmail.com');


INSERT INTO Project (
    project_id,
    project_name,
    emp_id,
    start_date,
    end_date
)
VALUES
(101, 'Website Redesign', 1, '2024-01-01', '2024-06-01'),
(102, 'Recruitment System', 3, '2024-02-01', '2024-08-01'),
(103, 'Marketing Campaign', 4, '2024-03-01', NULL);
	
UPDATE Employee 
SET salary = salary + 200 
WHERE dept_id = 1 ; 

UPDATE Project 
SET end_date = '2024-12-31' 
WHERE end_date IS NULL ;  

DELETE FROM Project 
WHERE start_date < '2024-02-01';

SELECT emp_name, email , CASE 
	WHEN gender = 1 THEN 'NAM'
    WHEN gender = 0 THEN 'NỮ' 
    ELSE 'KHONG XAC DINH ' 
    END AS gender_name 
    FROM Employee ;
    


