--Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
alter table Sanpham
add ghichu varchar(20)
--Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
alter table KhachHang
add LoaiKH tinyint
--Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
alter table SanPham 
alter column ghichu varchar(100)
--Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
alter table SanPham
drop column ghichu
--Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, ...
alter table KhachHang
alter column LoaiKH varchar(20)
--Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
alter table SanPham
add constraint SanPham_DVT check (DVT ='Cay' or DVT = 'hop' or DVT = 'cai' or DVT ='quyen' or dvt = 'chuc')
--Giá bán của sản phẩm từ 500 đồng trở lên.
alter table SanPham 
add constraint SanPham_Gia check(gia>500)
--Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
alter table CTHD
add constraint CTHD_SL1 check(SL > 0)
--Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
alter table KhachHang
add constraint KhachHang_NGDK_NGSINH check (NGDK > NgSinh)

--Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
select *
from SanPham,KhachHang

--Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
update SanPham set Gia = Gia +Gia/(100/5)
where NuocSX = 'Thai Lan'

--Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
Update SanPham set gia = gia /(100/5) + Gia
where NuocSX  = 'Trung Quoc' and Gia >10000

--Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
update KhachHang set LoaiKH = 'Vip'
where (NGDK <'2011/1/1' and Doanhso >= 10000000) or (NGDK > '2011/1/1' and Doanhso >= 2000000)

--In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
select MaSP , TenSP
from SanPham 
where NuocSx = 'Trung Quoc'

--In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
select Masp , tensp 
from SanPham
where DVT in ('Cay','quyen')

--In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
select Masp , tensp
from SanPham
where MaSP like 'B%01'

--In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
select Masp , tensp ,NuocSX
from SanPham
where NuocSX = 'Trung Quoc'
and Gia between 30000 and 40000 

--In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
select Masp , tensp ,NuocSX
from SanPham
where (NuocSX = 'Trung Quoc' or NuocSX = 'Thai Lan')
and Gia between 30000 and 40000 

--In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
select SoHD , Trigia 
from Hoadon
where NGHD = '2007/1/1' or NgHD = '2007/1/2'


--In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của shóa đơn (giảm dần).
select SoHD , Trigia 
from Hoadon
where year(Nghd) = 2007 and MONTH(nghd) = 1
order by NGHD , TriGia desc 

--In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
select KhachHang.MaKH , HoTEN
from KhachHang, Hoadon
where KhachHang.MaKH = Hoadon.MaKH and Hoadon.NgHD = '2007/1/1'

--In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
select SoHD , trigia 
from Hoadon,NhanVien
where NhanVien.MaNV = Hoadon.MaNV and NhanVien.Hoten = 'Nguyen Van B' and Hoadon.NgHD= '2006/10/28'

--In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select SP.MaSp ,SP.TenSP 
from SanPham SP , Hoadon HD , CTHD CT , KhachHang KH 
where SP.MaSP = CT.MaSP and CT.SoHd = HD.SoHd and HD.MaKH = KH.MaKH and KH.Hoten='Nguyen Van A' and year(NgHD)='2006' and MONTH(NgHD) = '10'