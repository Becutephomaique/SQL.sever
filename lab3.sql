--Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
--Xuất định dạng "Tổng số giờ làm việc "kiểu decimal vưới 2 số thập phân 
SELECT        dbo.DEAN.TENDEAN, CAST(SUM(dbo.PHANCONG.THOIGIAN) AS decimal(5, 2)) AS [Tổng số giờ làm việc]
FROM            dbo.DEAN INNER JOIN
                         dbo.PHANCONG ON dbo.DEAN.MADA = dbo.PHANCONG.MADA
GROUP BY dbo.DEAN.TENDEAN

--Xuất định dạng "Tổng số giờ làm việc" kiểu varchar.
SELECT        dbo.DEAN.TENDEAN, CAST(SUM(dbo.PHANCONG.THOIGIAN) AS varchar) AS [Tổng số giờ làm việc]
FROM            dbo.DEAN INNER JOIN
                         dbo.PHANCONG ON dbo.DEAN.MADA = dbo.PHANCONG.MADA
GROUP BY dbo.DEAN.TENDEAN

--Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm việc cho phòng ban đó.
--Xuất định dạng "Lương trung bình"kiểu decimal vưới 2 số thập phân , dùng dấu phẩy tách phần nguyên và phần thập phân.
SELECT        dbo.PHONGBAN.MAPHG, dbo.PHONGBAN.TENPHG, CAST(AVG(dbo.NHANVIEN.LUONG) AS decimal(15, 2)) AS 'Lương trung bình'
FROM            dbo.NHANVIEN INNER JOIN
                         dbo.PHONGBAN ON dbo.NHANVIEN.PHG = dbo.PHONGBAN.MAPHG
GROUP BY dbo.PHONGBAN.MAPHG, dbo.PHONGBAN.TENPHG

--Xuất định dạng "Lương trung bình"kiểu varchar , dùng dấu phẩy tách cứ mỗi 3 chữ số trong chuỗi ra , gợi ý dùng Left , Replace.
SELECT        dbo.PHONGBAN.MAPHG, dbo.PHONGBAN.TENPHG, LEFT(CAST(AVG(dbo.NHANVIEN.LUONG) AS varchar), 3) + [,] + REPLACE(CAST(AVG(dbo.NHANVIEN.LUONG) AS varchar), LEFT(CAST(AVG(dbo.NHANVIEN.LUONG) AS varchar), 
                         3), [,]) AS 'Lương trung bình'
FROM            dbo.NHANVIEN INNER JOIN
                         dbo.PHONGBAN ON dbo.NHANVIEN.PHG = dbo.PHONGBAN.MAPHG
GROUP BY dbo.PHONGBAN.MAPHG, dbo.PHONGBAN.TENPHG

--Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
--Xuất định dạng "Tổng số giờ làm việc " với hàm Ceiling 
SELECT        dbo.DEAN.TENDEAN, CEILING(SUM(dbo.PHANCONG.THOIGIAN)) AS [Tổng số giờ làm việc]
FROM            dbo.DEAN INNER JOIN
                         dbo.PHANCONG ON dbo.DEAN.MADA = dbo.PHANCONG.MADA
GROUP BY dbo.DEAN.TENDEAN

--Xuất định dạng "Tổng số giờ làm việc "với hàm Floor
SELECT        dbo.DEAN.TENDEAN, FLOOR(SUM(dbo.PHANCONG.THOIGIAN)) AS [Tổng số giờ làm việc]
FROM            dbo.DEAN INNER JOIN
                         dbo.PHANCONG ON dbo.DEAN.MADA = dbo.PHANCONG.MADA
GROUP BY dbo.DEAN.TENDEAN
--Xuất định dạng "Tổng số giờ làm việc " làm tròn tới 2 chữ số thập phân
SELECT        dbo.DEAN.TENDEAN, ROUND(SUM(dbo.PHANCONG.THOIGIAN), 2) AS [Tổng số giờ làm việc]
FROM            dbo.DEAN INNER JOIN
                         dbo.PHANCONG ON dbo.DEAN.MADA = dbo.PHANCONG.MADA
GROUP BY dbo.DEAN.TENDEAN

--Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình(làm tròn đến 2 số thập phân) của phòng "Nghiên cứu".
SELECT        HONV + ' ' + TENLOT + ' ' + TENNV AS 'Họ tên nhân viên có lương trung bình trên mức lương trung bình của phòng "Nghiên cứu"', LUONG
FROM            dbo.NHANVIEN
WHERE        (LUONG >
                             (SELECT        ROUND(AVG(NHANVIEN_1.LUONG), 2) AS 'Lương trung bình của nhân viên là :'
                               FROM            dbo.NHANVIEN AS NHANVIEN_1 INNER JOIN
                                                         dbo.PHONGBAN ON NHANVIEN_1.PHG = dbo.PHONGBAN.MAPHG
                               WHERE        (dbo.PHONGBAN.TENPHG = N'Nghiên cứu')))

 --Danh  sách  những  nhân  viên  (HONV,  TENLOT,  TENNV)  có  trên  2  thân nhân thỏa các yêu cầu sau.
 --Dữ liệu cột HONV được viết 
 --Dữ liệu cột TENLOT được viết thường
 --Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết thường( ví dụ: kHanh)
 --Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác như số nhà hay thành phố.
SELECT        UPPER(dbo.NHANVIEN.HONV) AS HONV, LOWER(dbo.NHANVIEN.TENLOT) AS TENLOT, LOWER(SUBSTRING(dbo.NHANVIEN.TENNV, 1, 1)) + UPPER(SUBSTRING(dbo.NHANVIEN.TENNV, 2, 1)) 
                         + SUBSTRING(dbo.NHANVIEN.TENNV, 3, 10) AS TENNV , dbo.NHANVIEN.DIACHI
FROM            dbo.NHANVIEN INNER JOIN
                         dbo.THANNHAN ON dbo.NHANVIEN.MANV = dbo.THANNHAN.MA_NVIEN
GROUP BY dbo.NHANVIEN.HONV, dbo.NHANVIEN.TENLOT, dbo.NHANVIEN.TENNV
HAVING        (COUNT(dbo.THANNHAN.MA_NVIEN) > 2)

--Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
--Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
--Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.
-- Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)
select *
	from NHANVIEN
	where Year(NGSINH) Between 1960 and 1965

select TENNV, year (getdate()) - year (ngsinh) as 'Tuoi' from NHANVIEN

select tennv ,ngsinh case
	when dayofweek (ngsinh) = '1' then 'Thứ 2'
	when dayofweek (ngsinh) = '2' then 'Thứ 3'
	when dayofweek (ngsinh) = '3' then 'Thứ 4'
	when dayofweek (ngsinh) = '4' then 'Thứ 5'
	when dayofweek (ngsinh) = '5' then 'Thứ 6'
	when dayofweek (ngsinh) = '6' then 'Thứ 7'
	when dayofweek (ngsinh) = '7' then 'Chủ Nhật'
	else 'Không phải là thứ mấy cả'
end
from NHANVIEN

select convert(varchar , ngsinh , 105 ) as 'Ngay sinh' from NhanVien




