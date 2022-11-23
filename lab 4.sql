--Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, cột thứ 2 nhận giá trị
--“TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong phòng mà nhân viên đó đang làm việc.
--“KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương trong phòng mà nhân viên đó đang làm việc.
select iif(luong >=ltb , 'Khong tang luong' ,'Tang luong')
as thuong,tennv,luong,ltb
from 
(select tennv , luong , LTb from NHANVIEN,
	(select phg ,avg(luong) as 'ltb' from NHANVIEN group by PHG ) as temp
	where NHANVIEN.PHG=temp.PHG) as abc

--Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
declare @tbt table(mapb int, luongtb float)
insert into @tbt
select phg, avg(luong) from NHANVIEN group by PHG
select tennv,luong,luongtb,tinhtrang=case
when luong > luongtb then 'truong phong'
else 'nhan vien'
end
  from NHANVIEN a
inner join @tbt b
on a.phg=b.mapb

--Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
select tennv = case PHAI
when 'nam' then 'Mr.'+[TENNV]
else 'Ms.'+[TENNV]
end
from NHANVIEN

--Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
--0<luong<25000 thì đóng 10% tiền lương
--25000<luong<30000 thì đóng 12% tiền lương
--30000<luong<40000 thì đóng 15% tiền lương
--40000<luong<50000 thì đóng 20% tiền lương
--Luong>50000 đóng 25% tiền lương
select TENNV,LUONG,thue=case 
when LUONG	between 0 and 25000 then LUONG*0.1
when LUONG	between 25000 and 30000 then LUONG*0.12
when LUONG	between 30000 and 40000 then LUONG*0.15
when LUONG	between 40000 and 50000 then LUONG*0.2
else LUONG*0.25 end
from NHANVIEN

--Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
declare @dem int = 2;
while @dem <(select count(manv) from NHANVIEN )
	begin 
		select * from NHANVIEN where cast (manv as int ) = @dem
		set @dem = @dem +2 ;
		end

--Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng không tính nhân viên có MaNV là 4.
select * from NHANVIEN
declare @i int =2 , @w int ;
set @w = (select count(*) from NHANVIEN)
while (@i<@w)
begin
	if (@i = 4)
		begin 
			set @i = @i +2;
			continue;
		end
	select MANV , HONV , TENLOT , TENNV from NHANVIEN
	where cast(MANV as int) = @i;
	set @i = @i + 2 ;
end 

--Tổng từ 1 đến 10
DECLARE @cnt INT = 0 , @p int = 10 , @q int
set @q = 1 
while (@q <= @p)
begin 
	if (@q %2 =0)
	set @cnt = @cnt + @q
	set @q = @q + 1
end
print ('Ket qua la') 
print @cnt

--Tổng từ 1 đến 10 bỏ đi 4
DECLARE @bo4 int = 0,@a INT = 10,@f INT
SET @f = 1
WHILE (@f<=@a)
BEGIN
	if (@f %2 =0)
	SET @bo4 = @bo4 + @f
	SET @f = @f + 1 
		if(@f = 4)
		SET @bo4 = @bo4 - 4
END
PRINT ('Ket qua la: ' )
PRINT @bo4

--Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
begin try
	insert PHONGBAN 
	values (799,'zxk-799','2008-07-01','1975-05-22')
	--Nếu lệnh chèn thực thi in ra Thành công
	print 'Thêm dữ liệu thành công'
	end try
	--Nếu có lỗi xảy ra in ra thất bại
begin catch 
	print 'Thêm dữ liệu thất bại'
	print 'Lỗi ' + convert (varchar , Error_NUMBER () , 1) + ',' + Error_Message() 
end catch

--Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng RAISERROR để thông báo lỗi.
begin try 
	declare @chia int 
	set @chia = 55/0 
	end try
begin catch
	declare 
	@ErMessage nvarchar(2048),
	@ErSeverity int ,
	@ErState int 
	Select 
	@ErMessage = ERROR_MESSAGE(),
	@ErSeverity = ERROR_SEVERITY(),
	@ErState = ERROR_STATE()
	RAISERROR ( @ErMessage , @ErSeverity , @ErState )
End Catch
