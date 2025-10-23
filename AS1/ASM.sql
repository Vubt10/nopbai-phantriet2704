

-- Bảng STUDENTS
CREATE TABLE STUDENTS (
    MASV NVARCHAR(50) NOT NULL PRIMARY KEY,
    Hoten NVARCHAR(50),
    Email NVARCHAR(50),
    SoDT NVARCHAR(15),
    Gioitinh BIT,
    Diachi NVARCHAR(50),
    Hinh VARCHAR(5000)
);
--select MASV,Hoten,Email,SoDT,Gioitinh,Diachi,Hinh  from STUDENTS 
--insert into STUDENTS(MASV,Hoten,Email,SoDT,Gioitinh,Diachi,Hinh),
--values(?,?,?,?,?,?,?)
-- Bảng GRADE
CREATE TABLE GRADE (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MASV NVARCHAR(50),
    Tienganh INT,
    Tinhoc INT,
    GDTC INT,
    FOREIGN KEY (MASV) REFERENCES STUDENTS(MASV)
);

-- Bảng USERS
CREATE TABLE USERS (
    username NVARCHAR(50) NOT NULL PRIMARY KEY,
    password NVARCHAR(50),
	role nvarchar(50)
);
-- STUDENTS
INSERT INTO STUDENTS VALUES
('SV001', N'Lê Văn A', 'a@example.com', '0909123456', 1, N'HCM', 'a.jpg'),
('SV002', N'Nguyễn Thị B', 'b@example.com', '0909234567', 0, N'HN', 'b.jpg'),
('SV003', N'Trần Văn C', 'c@example.com', '0909345678', 1, N'DN', 'c.jpg');

-- GRADE
INSERT INTO GRADE VALUES
(1, 'SV001', 8, 9, 7),
(2, 'SV002', 6, 7, 8),
(3, 'SV003', 9, 8, 9);

-- USERS
INSERT INTO USERS VALUES
('baytt', '123456','gv'),
('daotao', '123456','cbdt'),
('student', 'stud789','free');

INSERT INTO STUDENTS VALUES
('SV004', N'Phạm Văn D', 'd@example.com', '0909456789', 1, N'CT', 'd.jpg');

DELETE FROM STUDENTS WHERE MASV = 'SV002';

UPDATE STUDENTS
SET Hoten = N'Nguyễn Thị B (Updated)', Email = 'newb@example.com'
WHERE MASV = 'SV002';
