--Drop Existing Tables
--DROP TABLE IF EXISTS dataACCOUTING;
--DROP TABLE IF EXISTS dataTRANSACTION;
--DROP TABLE IF EXISTS dataEMPLOYEE;
--DROP TABLE IF EXISTS dataAGENCY;
--DROP TABLE IF EXISTS dataCUSTOMER;
--DROP TABLE IF EXISTS dataCAR;

--Create dataCAR table
CREATE TABLE dataCAR(
    Model_Car_ID VARCHAR(255),
    Model_Car_Name VARCHAR(255) NOT NULL,
    Price FLOAT NOT NULL,
    Color VARCHAR(255) NOT NULL,
    Origin_Of_Car VARCHAR(255) NOT NULL,
    Date_Of_Import DATE NOT NULL,
    Car_Number_Availability INT NOT NULL,
    Car_Sold INT NOT NULL,
    Lauching_Year INT NOT NULL,
    PRIMARY KEY(Model_Car_ID)
);

--Create dataCUSTOMER table
CREATE TABLE dataCUSTOMER(
    Citizen_ID VARCHAR(255), --có vấn đề - pros add number transaction | cons: 2 custommer nhap cung id, nhung khac ten-- > conflict 
	Email VARCHAR(255) NOT NULL UNIQUE,
    Customer_Name VARCHAR(255) NOT NULL,
    Phone_No VARCHAR(10) NOT NULL UNIQUE,
    Address VARCHAR(255) NOT NULL UNIQUE,
    Number_Transaction INT NOT NULL,
    PRIMARY KEY(Citizen_ID)
);
--DELETE FROM users WHERE citizen_id = '0123456';
--DELETE FROM dataCUSTOMER WHERE Citizen_ID = '0123456';

--Create dataAGENCY table
CREATE TABLE dataAGENCY(
    Agency_ID VARCHAR(255),
    Agency_Email VARCHAR(255) NOT NULL UNIQUE,
    Agency_Brand  VARCHAR(255) NOT NULL UNIQUE,
    Phone_No VARCHAR(10) NOT NULL UNIQUE,
    Address VARCHAR(255) NOT NULL UNIQUE,
    Pass_Word VARCHAR(255) NOT NULL,
    PRIMARY KEY(Agency_ID)
);

--Create dataEMPLOYEE table
CREATE TABLE dataEMPLOYEE(
    Employee_CitizenID  VARCHAR(255),
    Employee_Name VARCHAR(255) NOT NULL,
    Employee_Birthday DATE NOT NULL,
    Employee_Phone_No VARCHAR(10) NOT NULL UNIQUE,
    Employee_Email VARCHAR(255) NOT NULL UNIQUE,
    Employee_Address VARCHAR(255) NOT NULL UNIQUE,
    Role_Title VARCHAR(255) NOT NULL,
    PRIMARY KEY(Employee_CitizenID)
);

--Create dataTRANSACTION table
CREATE TABLE dataTRANSACTION(
    Transaction_ID VARCHAR(255) PRIMARY KEY,
    Citizen_ID VARCHAR(255) NOT NULL, --remove Unique, customers can buy multiple
    Model_Car_ID VARCHAR(255) NOT NULL,
    Transaction_Date DATE NOT NULL,
    Payment_Date DATE NOT NULL,
    Warranty_Valid_Date DATE NOT NULL,
    Status_Of_Purchasing VARCHAR(255) NOT NULL, --deposited, paid, canceled
    FOREIGN KEY(Citizen_ID) REFERENCES dataCUSTOMER(Citizen_ID),
    FOREIGN KEY(Model_Car_ID) REFERENCES dataCAR(Model_Car_ID)
);

--Create dataACCOUTING table
CREATE TABLE dataACCOUTING(
    Transaction_ID VARCHAR(255) NOT NULL UNIQUE,
    Citizen_ID VARCHAR(255) NOT NULL UNIQUE,
    Transaction_Price FLOAT NOT NULL,
    Deposit_Price FLOAT NOT NULL,

    FOREIGN KEY(Citizen_ID) REFERENCES dataCUSTOMER(Citizen_ID),
    FOREIGN KEY(Transaction_ID) REFERENCES dataTRANSACTION(Transaction_ID),
    CONSTRAINT PK_Accouting PRIMARY KEY(Citizen_ID, Transaction_ID)
);

--DELETE FROM dataCUSTOMER;
--TRUNCATE TABLE dataCUSTOMER;

SELECT * FROM dataTransaction;

INSERT INTO dataAGENCY (Agency_ID, Agency_Email, Agency_Brand, Phone_No, Address, Pass_word)
VALUES (
    'AGENCY9',
    'anotheragency@example.com',
    'Vinfast .LTD',
    '0123456789',
    '123 Ho Chi Minh City, Vietnam',
    '123456789'  
);
	
INSERT INTO dataCAR (Model_Car_ID, Model_Car_Name, Price, Color, Origin_Of_Car, Date_Of_Import, Car_Number_Availability, Car_Sold, Lauching_Year)
VALUES
('VINVFWG', 'VF Wild', 50000.00, 'Grey', 'Vietnam', '2024-06-01', 8, 5, 2024),
	('VINVF8BL', 'VF 8', 47200.00, 'Black', 'Vietnam', '2024-06-01', 8, 3, 2023),
	('VINVF8WH', 'VF 8', 47200.00, 'White', 'Vietnam', '2024-06-01', 9, 7, 2023),
	('VINVF8B', 'VF 8', 47200.00, 'Blue', 'Vietnam', '2024-06-01', 9, 4, 2023),
	('VINVF9CR', 'VF 9', 81000.00, 'Crimson Red', 'Vietnam', '2024-06-01', 10, 10, 2023),
	('VINVF9BL', 'VF 9', 81000.00, 'Black', 'Vietnam', '2024-06-01', 10, 8, 2023),
	('VINVF9SL', 'VF 9', 81000.00, 'Silver', 'Vietnam', '2024-06-01', 9, 12, 2023),
	('VINVF5B', 'VF 5', 30000.00, 'Blue', 'Vietnam', '2024-07-01', 8, 12, 2023),
	('VINVF6G', 'VF 6', 35000.00, 'Green', 'Vietnam', '2024-08-01', 8, 8, 2023),
	('VINVF7R', 'VF 7', 37000.00, 'Red', 'Vietnam', '2024-09-01', 9, 6, 2023),
	('VINVF7BL', 'VF 7', 37000.00, 'Black', 'Vietnam', '2024-09-01', 9, 8, 2023),
	('VINVF7B', 'VF 7', 37000.00, 'Blue', 'Vietnam', '2024-09-01', 9, 8, 2023),
	('VINVF3B', 'VF 3', 16000.00, 'Blue', 'Vietnam', '2024-10-01', 7, 20, 2023),
	('VINVF3YL', 'VF 3', 16000.00, 'Yello', 'Vietnam', '2024-10-01', 7, 20, 2023),
	('VINVF3PK', 'VF 3', 16000.00, 'Pink', 'Vietnam', '2024-10-01', 7, 20, 2023),
	('VINE34WH', 'VF e34', 26000.00, 'White', 'Vietnam', '2024-05-01', 8, 15, 2023),
	('VINE34B', 'VF e34', 26000.00, 'Black', 'Vietnam', '2024-05-01', 9, 10, 2023);

-- Thêm dữ liệu cho bảng dataCUSTOMER
INSERT INTO dataCUSTOMER (Citizen_ID, Email, Customer_Name, Phone_No, Address, Number_Transaction)
VALUES
    ('0000001', 'customer1@example.com', 'Nguyễn Văn A', '0912345678', '123 Lê Lợi, Quận 1, TP.HCM', 2),
    ('0000002', 'customer2@example.com', 'Trần Thị B', '0987654321', '456 Nguyễn Trãi, Quận 5, TP.HCM', 1),
    ('0000003', 'customer3@example.com', 'Lê Văn C', '0901234567', '789 Pasteur, Quận 3, TP.HCM', 0),
    ('0000004', 'customer4@example.com', 'Phạm Thị D', '0976543210', '1011 CMT8, Quận 10, TP.HCM', 3),
    ('0000005', 'customer5@example.com', 'Hoàng Văn E', '0965432109', '1213 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', 0);

-- Thêm dữ liệu cho bảng dataEMPLOYEE
INSERT INTO dataEMPLOYEE (Employee_CitizenID, Employee_Name, Employee_Birthday, Employee_Phone_No, Employee_Email, Employee_Address, Role_Title)
VALUES
    ('EMP001', 'Trần Văn An', '1990-05-10', '0987654321', 'employee1@example.com', '123 Lê Lợi, Quận 1, TP.HCM', 'Sales Manager'),
    ('EMP002', 'Nguyễn Thị Bình', '1995-08-15', '0912345678', 'employee2@example.com', '456 Nguyễn Trãi, Quận 5, TP.HCM', 'Salesperson'),
    ('EMP003', 'Lê Văn Cường', '1988-03-20', '0901234567', 'employee3@example.com', '789 Pasteur, Quận 3, TP.HCM', 'Service Advisor'),
    ('EMP004', 'Phạm Thị Diệu', '1992-11-25', '0976543210', 'employee4@example.com', '1011 CMT8, Quận 10, TP.HCM', 'Technician'),
    ('EMP005', 'Hoàng Văn Em', '1985-06-30', '0965432109', 'employee5@example.com', '1213 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', 'Accountant');