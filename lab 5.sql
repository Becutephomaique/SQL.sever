--In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.
Create Procedure sp_hello
	@Ten nvarchar(50)
as
begin 
	print ' Hello ' + @ten
end;

exec sp_hello N'Hồng Hoang';

--Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
Create Procedure sp_tong @so1 int , @so2 int 
as 
begin 
	declare @tong int;
	set @tong = @so1 + @so2 ;
	print 'Tong la ' +cast (@tong as varchar);
end ;
exec sp_tong 5, 2;

--Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
create proc sp_chan @n int
as 
begin
	declare	@tong1 int , @i int ;
	set @tong1 = 0 ;
	set @i = 1 ;
	while @i <= @n
		begin 
		if @i % 2 = 0
		begin 
			set @tong1 = @tong1 +@i;
		end;
		set @i = @i + 1;
	end;
	print 'Tong cac so chan ' + cast (@tong1 as varchar);
end;

exec sp_chan 114

--Nhập vào 2 số. In ra ước chung lớn nhất của chúng
create proc sp_uoc @uoc1 int , @uoc2 int 
as
begin 
declare @ucl int ;
if @uoc1 > @uoc2
begin 
select @ucl = @uoc1 ,@uoc1 = @uoc2 , @uoc2=@ucl;
end
while @uoc2 % @uoc1 != 0
begin 
select @ucl = @uoc1 ,@uoc1=@uoc1 % @uoc2 , @uoc2 = @ucl;
end;
print 'Uoc chung lon nhat la : ' + cast (@uoc1 as varchar)
end ;
exec sp_uoc 20 ,4;

--Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
create proc sp_timnv @MaNV nvarchar (4)
as
begin 
select * from NHANVIEN where MANV = @MaNV
end ;
exec dbo.sp_timnv 003

--Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
create proc sp_dean
@MaDA nvarchar (4)
as
begin 
select count(ma_nvien) as 'So Luong NV tham giam de an'from PHANCONG where MADA = @MaDA;
end ;
exec dbo.sp_dean 1;

--Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
create proc sp_diadiem 
@MaDA int , @Ddiem nvarchar(15)
as
begin
select count(b.ma_nvien)as 'So Luong' from DEAN a inner join PHANCONG b on a.MADA  = b.MADA
where a.MADA = @MaDA and a.DDIEM_DA = @Ddiem;
end;
exec dbo.sp_diadiem 1,'Vũng Tàu';
select * from DEAN;

--Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân.
create proc sp_trphong @Trphg nvarchar (10)
as
begin
select b.* from PHONGBAN a inner join NHANVIEN b on a.MAPHG = b.PHG
where a.TRPHG = @Trphg 
end;
exec dbo.sp_trphong '005'


--Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không
create proc sp_NVophg 
@MaNV nvarchar (4) , @MaPB int 
as
begin
declare @Dem int ;
select @Dem = count(manv) from NHANVIEN where MANV = @MaNV and PHG = @MaPB ;
return @Dem;
end;
declare @result int ;
exec @result = dbo.sp_NVophg '002' ,1 ;
select @result;

--Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
create proc sp_themphongban @TenPHG nvarchar(15), @MaPHG int,
@TRPHG nvarchar(9) , @NG_NHANCHUC date
as 
if EXISTS (Select * from PHONGBAN where MAPHG = @MaPHG)
Update PHONGBAN set TENPHG =@TenPHG ,TRPHG = @TRPHG, NG_NHANCHUC = @NG_NHANCHUC
where MAPHG = @MaPHG
else
insert into PHONGBAN
values (@TenPHG,@MaPHG,@TRPHG,@NG_NHANCHUC)
drop proc sp_ThemPhongBan
exec sp_themphongban 'CNTT',6 ,'008','1985-01-01'


--Cập nhật phòng ban có tên CNTT thành phòng IT.
create proc sp_capnhatphongban
	@TENPHGCU nvarchar(15),
	@TENPHG nvarchar(15),
	@MAPHG int,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
as
begin
	update PHONGBAN
	set TENPHG = @TENPHG,
		MAPHG = @MAPHG,
		TRPHG = @TRPHG,
		NG_NHANCHUC = @NG_NHANCHUC
	where TENPHG = @TENPHGCU;
end;

exec sp_capnhatphongban 'CNTT', 'IT', 10, '005', '1-1-2020';

--Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu vào :

create proc sp_themnv
	@HONV nvarchar(20),
	@TENLOT nvarchar(20),
	@TENNV nvarchar(20),
	@MANV nvarchar(4),
	@NGSINH datetime,
	@DCHI nvarchar(50),
	@PHAI nvarchar(5),
	@LUONG float,
	@PHG int
as
begin
	if not exists(select*from PHONGBAN where TENPHG = 'IT')
	begin
		print N'Nhân viên phải thuộc phòng IT';
		return;
	end;
	declare @MA_NQL nvarchar(9);
	if @LUONG > 25000
		set @MA_NQL = '005';
	else
		set @MA_NQL = '009';
	declare @age int;
	select @age = DATEDIFF(year,@NGSINH,getdate()) + 1;
	if @PHAI = 'Nam' and (@age < 18 or @age >60)
	begin
		print N'Nam phải có độ tuổi từ 18-65';
		return;
	end;
	else if @PHAI = 'Nữ' and (@age < 18 or @age >60)
	begin
		print N'Nữ phải có độ tuổi từ 18-60';
		return;
	end;
	INSERT INTO NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
		VALUES(@HONV,@TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,@MA_NQL,@PHG)
end;

exec sp_themNV N'Trần',N'Hoàng',N'Hồng','022','23-1-1990',N'Tp HCM','Nam',345000,6;
--Đếm Nhân viên ở tỉnh thành
create procedure DemNva
@cityvar nvarchar (30)
as
declare @num int
select @num = count (*) from nhanvien
where DCHI like '%' + @cityvar
return @num
go
declare @tongso int
exec @tongso = DemNv 'TP HCM'
select @tongso 
go

