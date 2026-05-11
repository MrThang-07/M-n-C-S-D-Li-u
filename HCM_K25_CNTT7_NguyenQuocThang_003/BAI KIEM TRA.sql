CREATE DATABASE hackathon_db ;
USE hackathon_db;
-- Phần 1 -- 

CREATE TABLE Department(
	department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE ,
    location VARCHAR(255) 
    );
CREATE TABLE Employee(
	employee_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) ,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    hire_date DATE ,
    department_id VARCHAR(10) ,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);
CREATE TABLE Project(
	project_id INT PRIMARY KEY AUTO_INCREMENT ,
    project_name VARCHAR(150),
    budget DECIMAL(15,2) ,
    status VARCHAR(50) DEFAULT('Active')
);
CREATE TABLE Assignment(
	assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(10),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    project_id INT ,
    FOREIGN KEY (project_id) REFERENCES Project(project_id),
    role VARCHAR(50) DEFAULT('Manager'),
    bonus_amount DECIMAL(10,2) 
);

INSERT INTO Department(department_id,department_name,location)
VALUES 
	('D001', 'Information Technology', 'Floor 4,Building A'),
    ('D002', 'Human Resources', 'Floor 2,Building B'),
    ('D003', 'Finance & Accounting', 'Floor 3,Building A'),
    ('D004', 'Marketing & Sales', 'Floor 5,Building C'),
    ('D005', 'Research & Development', 'Floor 6,Building D');
    
INSERT INTO Employee(employee_id,full_name,email,phone_number,hire_date,department_id)
VALUES 
	('E001', 'Nguyen Minh Anh', 'anh.nm@company.com', 0912345678, '2022-01-15', 'D001'),
    ('E002', 'Tran Thi Thanh', 'thanh.tt@company.com', 0923456789, '2021-05-20', 'D002'),
    ('E003', 'Pham Hoang Nam', 'nam.ph@company.com', 0934567890, '2023-03-10', 'D001'),
    ('E004', 'Le Thu Thao', 'thao.lt@company.com', 0945678901, '2020-11-25', 'D003'),
    ('E005', 'Vu Duc Cuong', 'cuong.vd@company.com', 0956789012, '2024-02-01', 'D005');
    
 INSERT INTO Project(project_id,project_name,budget,status)
 VALUES 
	(1, 'FRP System Upgrade', 500000.00, 'Active'),
    (2, 'Mobile App Launch', 250000.00, 'Pending'),
    (3, 'Annual Finanacial Audit', 100000.00, 'Completed'),
    (4, 'Market Expansion Asia', 800000.00, 'Active'),
    (5, 'AI Research Pilot', 150000.00, 'Pending');
    
INSERT INTO Assignment(assignment_id,employee_id,project_id,role,bonus_amount)
VALUES 
	(1, 'E001', 1, 'Manager', 2000.00),
    (2, 'E003', 1, 'Developer', 1700.00),
    (3, 'E002', 4, 'Developer', 1500.00),
    (4, 'E004', 3, 'Tester', 1300.00),
    (5, 'E001', 5, 'Tester', 1000.00);
-- câu 3 -- 
UPDATE Department
SET location = 'Landmark Tower HCM City' WHERE department_id = 'D003';
-- câu 4 -- 
UPDATE Project
SET budget = budget * 1.2  WHERE project_id = 1;
-- câu 5 --
DELETE FROM Assignment
WHERE bonus_amount < 1200 AND status = 'Completed';
-- Phần 2 --- 
-- câu 6 --
SELECT project_id,project_name FROM Project 
WHERE budget > 300000 AND status ='Active';
-- câu 7 -- 
SELECT full_name,email,phone_number FROM Employee
WHERE full_name LIKE '%Anh%';
-- câu 8 -- 
SELECT employee_id,full_name,hire_date FROM Employee
ORDER BY hire_date DESC;
-- câu 9 -- 
SELECT * FROM Employee
ORDER BY hire_date ASC
LIMIT 3;
-- 10 -- 
SELECT employee_id,full_name FROM Employee
LIMIT 2 OFFSET 2 ;
-- 11 --
SELECT e.employee_id,e.full_name,d.department_name From Employee e
JOIN Department d 
ON e.department_id = d.department_id;
-- 12 --
SELECT e.employee_id,d.* FROM Employee e
RIGHT JOIN Department d
ON e.department_id = d.department_id;
-- 13 -- 
SELECT status , SUM(budget) AS SUM_budget FROM Project
GROUP BY status 



