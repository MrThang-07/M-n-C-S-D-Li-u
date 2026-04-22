CREATE DATABASE BTTH1_SS2;
USE BTTH1_SS2;

CREATE TABLE Persons(
	personId INT NOT NULL PRIMARY KEY ,
    lastName CHAR(255) NOT NULL , 
    FirtsName CHAR(255) NOT NULL , 
    email char(100) UNIQUE ,
    address CHAR(255) ,
    city CHAR(255) 
    
);

CREATE TABLE Hobbies (
	id INT PRIMARY KEY ,
    name CHAR(100) CHECK(length(name) > 4 ) ,
    personId INT ,
    CONSTRAINT fk_hobbies_persons
	FOREIGN KEY (personId)
	REFERENCES persons(personId)
);

ALTER TABLE Persons
ADD  COLUMN phone CHAR(20) ;

ALTER TABLE Persons persons
DROP COLUMN city; 
