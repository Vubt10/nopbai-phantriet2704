
-- Bài 1️: SỬ DỤNG CƠ SỞ DỮ LIỆU QLDA. VỚI MỖI CÂU TRUY VẤN THỰC HIỆN 2 CÁCH(CAST VÀ CONVERT)
USE QLDA
-- Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc của các nhân viên
-- ĐỊNH DẠNG DECIMAL(10,2)
-- CAST
SELECT DA.TENDEAN,
       CAST(SUM(PC.THOIGIAN) AS DECIMAL(10,2)) AS TongGio_Decimal_CAST
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

--  CONVERT
SELECT DA.TENDEAN,
       CONVERT(DECIMAL(10,2), SUM(PC.THOIGIAN)) AS TongGio_Decimal_CONVERT
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- ĐỊNH DẠNG VARCHAR
-- CAST
SELECT DA.TENDEAN,
       CAST(SUM(PC.THOIGIAN) AS VARCHAR(20)) AS TongGio_Varchar_CAST
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- CONVERT
SELECT DA.TENDEAN,
       CONVERT(VARCHAR(20), SUM(PC.THOiGIAN)) AS TongGio_Varchar_CONVERT
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;


-- Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình nhân viên
-- ĐỊNH DẠNG DECIMAL(10,2)
-- CAST
SELECT PB.TENPHG,
       CAST(AVG(NV.LUONG) AS DECIMAL(10,2)) AS LuongTB_Decimal_CAST
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

-- CONVERT
SELECT PB.TENPHG,
       CONVERT(DECIMAL(10,2), AVG(NV.LUONG)) AS LuongTB_Decimal_CONVERT
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

-- ĐỊNH DẠNG VARCHAR
-- Dùng CAST
SELECT PB.TENPHG,
       LEFT(REPLACE(CAST(AVG(NV.LUONG) AS VARCHAR(20)), '.', ','), 20) AS LuongTB_Varchar_CAST
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

-- Dùng CONVERT
SELECT PB.TENPHG,
       LEFT(REPLACE(CONVERT(VARCHAR(20), AVG(NV.LUONG)), '.', ','), 20) AS LuongTB_Varchar_CONVERT
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;


-- BÀI 2: SỬ DỤNG CÁC HÀM TOÁN HỌC
-- Câu 1: Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc
-- a) Xuất định dạng "tổng số giờ làm việc" với hàm CEILING
SELECT 
    DA.TENDEAN,
    CEILING(SUM(PC.THOIGIAN)) AS [Tổng giờ (CEILING)]
FROM DEAN DA
LEFT JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- b) Xuất định dạng "tổng số giờ làm việc" với hàm FLOOR
SELECT 
    DA.TENDEAN,
    FLOOR(SUM(PC.THOIGIAN)) AS [Tổng giờ (FLOOR)]
FROM DEAN DA
LEFT JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- c) Xuất định dạng "tổng số giờ làm việc" làm tròn tới 2 chữ số thập phân
SELECT 
    DA.TENDEAN,
    ROUND(SUM(PC.THOIGIAN), 2) AS [Tổng giờ (ROUND)]
FROM DEAN DA
LEFT JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- Câu 2: Cho biết họ tên nhân viên có mức lương trên mức lương trung bình 
-- (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
SELECT 
    NV.HONV,
    NV.TENLOT,
    NV.TENNV,
    NV.LUONG
FROM NHANVIEN NV
WHERE NV.LUONG > (
    SELECT ROUND(AVG(NV2.LUONG), 2)
    FROM NHANVIEN NV2
    INNER JOIN PHONGBAN PB ON NV2.PHG = PB.MAPHG
    WHERE PB.TENPHG = N'Nghiên cứu'
);


-- =============================================
-- BÀI 3: SỬ DỤNG CÁC HÀM XỬ LÝ CHUỖI
-- =============================================

-- Câu 1: Danh sách những nhân viên có trên 2 thân nhân
SELECT 
    UPPER(NV.HONV) AS HONV,
    LOWER(NV.TENLOT) AS TENLOT,
    LOWER(LEFT(NV.TENNV, 1)) + UPPER(SUBSTRING(NV.TENNV, 2, 1)) + LOWER(SUBSTRING(NV.TENNV, 3, LEN(NV.TENNV))) AS TENNV,
    SUBSTRING(NV.DCHI, 
              CHARINDEX(' ', NV.DCHI) + 1, 
              CHARINDEX(',', NV.DCHI) - CHARINDEX(' ', NV.DCHI) - 1) AS DCHI
FROM NHANVIEN NV
WHERE NV.MANV IN (
    SELECT TN.MA_NVIEN
    FROM THANNHAN TN
    GROUP BY TN.MA_NVIEN
    HAVING COUNT(*) > 2
);

-- Câu 2: Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
-- Hiển thị thêm một cột thay thế tên trưởng phòng bằng tên "Fpoly"
SELECT 
    PB.TENPHG,
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS [Họ tên trưởng phòng],
    REPLACE(NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV, NV.TENNV, 'Fpoly') AS [Tên thay thế]
FROM PHONGBAN PB
INNER JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
WHERE PB.MAPHG = (
    SELECT TOP 1 PHG
    FROM NHANVIEN
    GROUP BY PHG
    ORDER BY COUNT(*) DESC
);

-- BÀI 4: SỬ DỤNG CÁC HÀM NGÀY THÁNG NĂM
-- Câu 1: Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965
SELECT 
    NV.HONV,
    NV.TENLOT,
    NV.TENNV,
    NV.NGSINH,
    YEAR(NV.NGSINH) AS [Năm sinh]
FROM NHANVIEN NV
WHERE YEAR(NV.NGSINH) BETWEEN 1960 AND 1965;

-- Câu 2: Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại
SELECT 
    NV.HONV,
    NV.TENLOT,
    NV.TENNV,
    NV.NGSINH,
    DATEDIFF(YEAR, NV.NGSINH, GETDATE()) AS [Tuổi]
FROM NHANVIEN NV;

-- Hoặc tính tuổi chính xác hơn (tính cả tháng và ngày)
SELECT 
    NV.HONV,
    NV.TENLOT,
    NV.TENNV,
    NV.NGSINH,
    DATEDIFF(YEAR, NV.NGSINH, GETDATE()) - 
    CASE 
        WHEN MONTH(NV.NGSINH) > MONTH(GETDATE()) OR 
             (MONTH(NV.NGSINH) = MONTH(GETDATE()) AND DAY(NV.NGSINH) > DAY(GETDATE()))
        THEN 1 
        ELSE 0 
    END AS [Tuổi chính xác]
FROM NHANVIEN NV;

-- Câu 3: Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy
SELECT 
    NV.HONV,
    NV.TENLOT,
    NV.TENNV,
    NV.NGSINH,
    DATENAME(WEEKDAY, NV.NGSINH) AS [Thứ (tiếng Anh)],
    CASE DATEPART(WEEKDAY, NV.NGSINH)
        WHEN 1 THEN N'Chủ nhật'
        WHEN 2 THEN N'Thứ hai'
        WHEN 3 THEN N'Thứ ba'
        WHEN 4 THEN N'Thứ tư'
        WHEN 5 THEN N'Thứ năm'
        WHEN 6 THEN N'Thứ sáu'
        WHEN 7 THEN N'Thứ bảy'
    END AS [Thứ (tiếng Việt)]
FROM NHANVIEN NV;

-- Câu 4: Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng
-- và ngày nhận chức hiển thị theo định dạng dd-mm-yy
SELECT 
    PB.TENPHG,
    COUNT(NV.MANV) AS [Số lượng nhân viên],
    TP.HONV + ' ' + TP.TENLOT + ' ' + TP.TENNV AS [Tên trưởng phòng],
    PB.NG_NHANCHUC AS [Ngày nhận chức],
    FORMAT(PB.NG_NHANCHUC, 'dd-MM-yy') AS [Ngày nhận chức (dd-mm-yy)]
FROM PHONGBAN PB
LEFT JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
INNER JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV
GROUP BY 
    PB.TENPHG, 
    PB.NG_NHANCHUC, 
    TP.HONV, 
    TP.TENLOT, 
    TP.TENNV;

-- Cách 2: Sử dụng CONVERT
SELECT 
    PB.TENPHG,
    COUNT(NV.MANV) AS [Số lượng nhân viên],
    TP.HONV + ' ' + TP.TENLOT + ' ' + TP.TENNV AS [Tên trưởng phòng],
    PB.NG_NHANCHUC AS [Ngày nhận chức],
    CONVERT(VARCHAR(10), PB.NG_NHANCHUC, 5) AS [Ngày nhận chức (dd-mm-yy)]
FROM PHONGBAN PB
LEFT JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
INNER JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV
GROUP BY 
    PB.TENPHG, 
    PB.NG_NHANCHUC, 
    TP.HONV, 
    TP.TENLOT, 
    TP.TENNV;


