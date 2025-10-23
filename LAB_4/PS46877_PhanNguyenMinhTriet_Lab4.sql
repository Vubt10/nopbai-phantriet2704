USE QLDA

-- Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, cột thứ 2 nhận giá trị 
-- CASE 
SELECT 
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen,
    CASE 
        WHEN NV.LUONG < (SELECT AVG(LUONG) FROM NHANVIEN WHERE PHG = NV.PHG)
            THEN N'TangLuong'
        ELSE N'KhongTangLuong'
    END AS XetTangLuong
FROM NHANVIEN NV;
-- IF ELSE
SELECT NV.TENNV,
        CASE 
            WHEN NV.LUONG < (SELECT AVG(LUONG) 
                             FROM NHANVIEN 
                             WHERE PHG = NV.PHG) 
                THEN N'TangLuong'
            ELSE N'KhongTangLuong'
        END AS KetQua
FROM NHANVIEN NV;

-- Viết chương trình phân loại nhân viên dựa vào mức lương. 
-- Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
-- CASE
    SELECT 
        NV.TENNV,
        CASE 
            WHEN NV.LUONG < (SELECT AVG(LUONG) 
                             FROM NHANVIEN 
                             WHERE PHG = NV.PHG)
                THEN N'nhanvien'
            ELSE N'truongphong'
        END AS LoaiNV
    FROM NHANVIEN NV;
-- IF ELSE
BEGIN
    SELECT 
        NV.TENNV,
        CASE 
            WHEN NV.LUONG < (SELECT AVG(LUONG) 
                             FROM NHANVIEN 
                             WHERE PHG = NV.PHG)
                THEN N'nhanvien'
            ELSE N'truongphong'
        END AS LoaiNV
    FROM NHANVIEN NV;
END;
GO


-- Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
-- Dùng CASE
BEGIN
    SELECT 
        CASE 
            WHEN PHAI = N'Nữ' THEN 'Ms. ' + TENNV
            WHEN PHAI = N'Nam' THEN 'Mr. ' + TENNV
            ELSE TENNV
        END AS TenNV
    FROM NHANVIEN;
END;
-- Dùng IF ELSE 
BEGIN
    DECLARE @Ten NVARCHAR(50), @Phai NVARCHAR(5), @HienThi NVARCHAR(60);

    CREATE TABLE #KetQua (TenNV NVARCHAR(60));

    DECLARE cur CURSOR FOR
        SELECT TENNV, PHAI FROM NHANVIEN;

    OPEN cur;
    FETCH NEXT FROM cur INTO @Ten, @Phai;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Phai = N'Nữ'
            SET @HienThi = 'Ms. ' + @Ten;
        ELSE IF @Phai = N'Nam'
            SET @HienThi = 'Mr. ' + @Ten;
        ELSE
            SET @HienThi = @Ten;

        INSERT INTO #KetQua VALUES (@HienThi);

        FETCH NEXT FROM cur INTO @Ten, @Phai;
    END
        CLOSE cur;
    DEALLOCATE cur;

    SELECT * FROM #KetQua;
END;

-- Viết chương trình tính thuế mà nhân viên phải đóng theo công thức
-- Dùng CASE 
SELECT TenNV, Luong,
       CASE 
            WHEN Luong > 0 AND Luong < 25000 THEN Luong * 0.10
            WHEN Luong >= 25000 AND Luong < 30000 THEN Luong * 0.12
            WHEN Luong >= 30000 AND Luong < 40000 THEN Luong * 0.15
            WHEN Luong >= 40000 AND Luong < 50000 THEN Luong * 0.20
            WHEN Luong >= 50000 THEN Luong * 0.25
            ELSE 0
       END AS ThuePhaiDong
FROM NhanVien;

-- Dùng IF ELSE
DECLARE @Luong FLOAT;

-- Giả sử tính thuế cho từng nhân viên, lấy một NV cụ thể
SELECT @Luong = Luong FROM NhanVien WHERE MaNV = '001';

IF (@Luong > 0 AND @Luong < 25000)
    PRINT 'Thuế: ' + CAST(@Luong * 0.10 AS VARCHAR);
ELSE IF (@Luong >= 25000 AND @Luong < 30000)
    PRINT 'Thuế: ' + CAST(@Luong * 0.12 AS VARCHAR);
ELSE IF (@Luong >= 30000 AND @Luong < 40000)
    PRINT 'Thuế: ' + CAST(@Luong * 0.15 AS VARCHAR);
ELSE IF (@Luong >= 40000 AND @Luong < 50000)
    PRINT 'Thuế: ' + CAST(@Luong * 0.20 AS VARCHAR);
ELSE IF (@Luong >= 50000)
    PRINT 'Thuế: ' + CAST(@Luong * 0.25 AS VARCHAR);
ELSE
    PRINT 'Không hợp lệ';

-- Bài 2: (2 điểm) Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng vòng lặp 

--- Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn. ---
USE QLDA;
GO
DECLARE @MinID INT, @MaxID INT, @CurrentID INT;
-- Tìm min và max của MA_NVIEN
SELECT @MinID = MIN(CAST(MANV AS INT)),
       @MaxID = MAX(CAST(MANV AS INT))
FROM NHANVIEN;

SET @CurrentID = @MinID;
-- Bảng tạm kết quả
CREATE TABLE #KetQua1 (
    HONV NVARCHAR(15),
    TENLOT NVARCHAR(15),
    TENNV NVARCHAR(15),
    MANV CHAR(9)
);
-- Duyệt vòng lặp
WHILE @CurrentID <= @MaxID
BEGIN
    IF @CurrentID % 2 = 0
    BEGIN
        INSERT INTO #KetQua1(HONV, TENLOT, TENNV, MANV)
        SELECT HONV, TENLOT, TENNV, MANV
        FROM NHANVIEN
        WHERE CAST(MANV AS INT) = @CurrentID;
    END

    SET @CurrentID = @CurrentID + 1;
END;
-- Xuất kết quả
SELECT HONV, TENLOT, TENNV, MANV FROM #KetQua1;
DROP TABLE #KetQua1;


--- Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng không tính nhân viên có MaNV là 4.---
USE QLDA;
GO

SELECT HONV, TENLOT, TENNV, MANV
FROM NHANVIEN
WHERE CAST(MANV AS INT) % 2 = 0   -- Lấy mã chẵn
  AND CAST(MANV AS INT) <> 4;     -- Bỏ nhân viên mã = 4

--- BÀI 3 ---
--- Quản lý lỗi chương trình ---
USE QLDA;
GO
BEGIN TRY
    INSERT INTO PHONGBAN(TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
    VALUES (N'Phong CNTT', 10, '001', GETDATE());
    
    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
END CATCH;

--- Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng RAISERROR để thông báo lỗi. --- 
USE QLDA;
GO

DECLARE @chia INT = 10;
DECLARE @mau INT = 0;
DECLARE @ketqua FLOAT;

BEGIN TRY
    IF @mau = 0
    BEGIN
        RAISERROR (N'Lỗi: Không thể chia cho 0', 16, 1);
    END
    ELSE
    BEGIN
        SET @ketqua = @chia / @mau;
        PRINT N'Kết quả phép chia là: ' + CAST(@ketqua AS NVARCHAR(50));
    END
END TRY
BEGIN CATCH
    PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
END CATCH;














