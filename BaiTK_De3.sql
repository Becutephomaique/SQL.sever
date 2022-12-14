
--CAU 2 Đưa ra hóa đơn có tổng tiền vật tư nhiều nhất gồm : MAHD , Tổng Tiền
select top 1 MAHD, sum(DONGIA*SLBan) as TongTien from HANGXUAT group by MAHD,
DONGIA order by DONGIA desc
--CAU 3 Viết hàm truyền vào tham số truyền vào là MaHD , hàm trả về một bảng gồm các thông tin : MaHD, NgayXuat,MaTV,DonGia,SLBan.
CREATE FUNCTION thoigian(
    @MAHD varchar(10)
)
RETURNS TABLE
AS
RETURN
    SELECT 
        HX.MAHD,
        HD.NGAYXUAT,
        HX.MaVT,
        HX.DONGIA,
        HX.SLBAN,  
        CASE
            WHEN datename(WEEKDAY, NgayXuat) = 0 THEN N'Thứ hai'            
            WHEN dATENAME(WEEKDAY, NgayXuat) = 1 THEN N'Thứ ba'
            WHEN datename(WEEKDAY, NgayXuat) = 2 THEN N'Thứ tư'
            WHEN datename(WEEKDAY, NgayXuat) = 3 THEN N'Thứ năm'
            WHEN datename(WEEKDAY, NgayXuat) = 4 THEN N'Thứ sáu'
            WHEN datename(WEEKDAY, NgayXuat) = 5 THEN N'Thứ bảy'
            ELSE N'Chủ nhật'
        END AS NGAYTHU
    FROM HANGXUAT HX
    INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
    WHERE HX.MAHD = @MAHD;

--CAU 4 Hãy tạo ra thủ tục lưu trữ in ra tổng tiền vật tư xuất theo tháng và năm là bao nhiêu ?
CREATE PROCEDURE Xuatngay 
@thang int, @nam int 
AS
SELECT 
SUM(SLBAN * DONGIA)
FROM HANGXUAT HX
INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
where MONTH(HD.NGAYXUAT) = @THANG AND YEAR(HD.NGAYXUAT) = @NAM;
select top 1 MAHD, sum(DONGIA) as TongTien from HANGXUAT group by MAHD,
DONGIA order by DONGIA desc

SELECT DATENAME(WEEKDAY, NgayXuat) from HDBan;


