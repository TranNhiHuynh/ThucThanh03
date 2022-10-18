CREATE DATABASE ThucTap;
USE ThucTap;

CREATE TABLE TBLKhoa
(Makhoa char(10)primary key,
 Tenkhoa char(30),
 Dienthoai char(10));

CREATE TABLE TBLGiangVien(
Magv int primary key,
Hotengv char(30),
Luong decimal(5,2),
Makhoa char(10) references TBLKhoa);

CREATE TABLE TBLSinhVien(
Masv int primary key,
Hotensv char(40),
Makhoa char(10)foreign key references TBLKhoa,
Namsinh int,
Quequan char(30));

CREATE TABLE TBLDeTai(
Madt char(10)primary key,
Tendt char(30),
Kinhphi int,
Noithuctap char(30));

CREATE TABLE TBLHuongDan(
Masv int primary key,
Madt char(10)foreign key references TBLDeTai,
Magv int foreign key references TBLGiangVien,
KetQua decimal(5,2));

INSERT INTO TBLKhoa VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);

INSERT INTO TBLGiangVien VALUES
(11,'Thanh Binh',700,'Geo'),    
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');

INSERT INTO TBLSinhVien VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

INSERT INTO TBLDeTai VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );

INSERT INTO TBLHuongDan VALUES
(1,'Dt01',11,0),
(2,'Dt02',12,0),
(3,'Dt03',12,7),
(4,'Dt02',11,7),
(5,'Dt01',11,null),
(6,'Dt01',13,null),
(7,'Dt03',15,null)
--- TRUY VẤN ---
--I
--1. Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
SELECT gv.Magv, gv.Hotengv, kh.Tenkhoa
FROM TBLKhoa kh, TBLGiangVien gv
WHERE kh.Makhoa = gv.Makhoa

--2. Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
SELECT gv.Magv, gv.Hotengv, kh.Tenkhoa
FROM TBLKhoa kh, TBLGiangVien gv
WHERE kh.Makhoa = gv.Makhoa and kh.Tenkhoa = 'DIA LY va QLTN'

--3. Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) as 'So sinh vien KHOA CONG NGHE SINH HOC'
FROM TBLKhoa kh, TBLSinhVien sv
WHERE kh.Makhoa = sv.Makhoa and kh.Tenkhoa = 'CONG NGHE SINH HOC'

--4. Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
SELECT sv.Masv, sv.Hotensv,(YEAR(GETDATE()) - sv.Namsinh) as 'Tuoi'
FROM TBLKhoa kh, TBLSinhVien sv
WHERE kh.Makhoa = sv.Makhoa and kh.Tenkhoa = 'TOAN'

--5. Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) as 'So giang vien KHOA CONG NGHE SINH HOC'
FROM TBLKhoa kh, TBLGiangVien gv
WHERE kh.Makhoa = gv.Makhoa and kh.Tenkhoa = 'CONG NGHE SINH HOC'

--6. Cho biết thông tin về sinh viên không tham gia thực tập
SELECT *
FROM TBLSinhVien sv
WHERE sv.Masv not in(
		SELECT hd.Masv
		FROM TBLHuongDan hd
)

--7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT kh.Makhoa, kh.Tenkhoa, count(*) 'So giang vien'
FROM TBLKhoa kh, TBLGiangVien gv
WHERE kh.Makhoa = gv.Makhoa
GROUP BY kh.Makhoa, kh.Tenkhoa

--8. Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
SELECT kh.Dienthoai
FROM TBLKhoa kh, TBLSinhVien sv
WHERE kh.Makhoa = sv.Makhoa and sv.Hotensv = 'Le van son'

--II
--1. Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
SELECT dt.Madt, dt.Tendt
FROM TBLDeTai dt, TBLHuongDan hd, TBLGiangVien gv
WHERE dt.Madt = hd.Madt and hd.Magv = gv.Magv and gv.Hotengv = 'Tran son'

--2. Cho biết tên đề tài không có sinh viên nào thực tập
SELECT dt.Tendt
FROM TBLDeTai dt
WHERE dt.Madt not in(
	SELECT hd.Madt
	FROM TBLHuongDan hd
)

--3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
SELECT gv.Magv, gv.Hotengv , kh.Tenkhoa
FROM TBLGiangVien gv, TBLKhoa kh
WHERE gv.Makhoa = kh.Makhoa and gv.Magv in(
		SELECT hd.Magv
		FROM TBLHuongDan hd
		GROUP BY hd.Magv
		HAVING count(hd.Masv) >= 3
)

--4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
SELECT dt.Madt, dt.Tendt
FROM TBLDeTai dt
WHERE dt.Kinhphi = (
	SELECT MAX(dt.Kinhphi)
	FROM TBLDeTai dt
)

--5. Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
SELECT dt.Madt, dt.Tendt
FROM TBLDeTai dt
WHERE dt.Madt in (
	SELECT hd.Madt
	FROM TBLHuongDan hd
	GROUP BY hd.Madt
	HAVING COUNT(hd.Masv) >2
)

--6. Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘Dia ly va QLTN’
SELECT sv.Masv, sv.Hotensv, hd.KetQua
FROM TBLSinhVien sv, TBLHuongDan hd, TBLKhoa kh
WHERE sv.Makhoa = kh.Makhoa and hd.Masv = sv.Masv and kh.Tenkhoa = 'Dia ly va QLTN'

--7. Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
SELECT kh.Tenkhoa, COUNT(*) as 'So luong sinh vien'
FROM TBLSinhVien sv, TBLKhoa kh
WHERE sv.Makhoa = kh.Makhoa
GROUP BY kh.Tenkhoa

--8. Cho biết thông tin về các sinh viên thực tập tại quê nhà
SELECT sv.*
FROM TBLSinhVien sv, TBLDeTai dt, TBLHuongDan hd
WHERE sv.Masv = hd.Masv and dt.Madt = hd.Madt and sv.Quequan = dt.Noithuctap

--9. Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
SELECT sv.*
FROM TBLSinhVien sv,TBLHuongDan hd
WHERE sv.Masv = hd.Masv and hd.KetQua IS NULL

--10. Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
SELECT sv.Masv, sv.Hotensv
FROM TBLSinhVien sv,TBLHuongDan hd
WHERE sv.Masv = hd.Masv and hd.KetQua = 0
