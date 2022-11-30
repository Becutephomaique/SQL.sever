--Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì xuất thông báo “luong phải >15000’
create trigger CheckLuong_NV 
on NhanVien 
for insert,update
as	
if (select LUONG from inserted )<15000
begin
print 'Tien Luong toi thieu phai lon hon 15000'
 rollback transaction;
 end;

 insert into dbo.NHANVIEN([HONV] , [TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
 values 
 (N'TRAN',N'Hong',N'Hoang','050','15-6-2002','Dong Thap','Nam',200000,'005',1)
--Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.
create trigger tg_checktuoi
on nhanvien
for insert 
as 
declare @tuoi int ;
select @tuoi = datediff (year , ngsinh , GETDATE ()) +1 from inserted;
if @tuoi <18 or @tuoi > 65 
begin 
print N'Tuoi cua nhan vien khong hop le 18<= tuoi <=65';
rollback transaction
end;

 insert into dbo.NHANVIEN([HONV] , [TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
 values 
 (N'TRAN',N'Hong',N'Hoang','050','15-6-2002','Dong Thap','Nam',200000,'005',1)


 --Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM

create trigger tg_update
on NHANVIEN
for update
as
if exists (select dchi from inserted where DCHI like '%HCM%' )
begin
print 'Khong The Cap Nhat'
rollback transaction ;
end
Delete from NhanVien where MANV like '005'

--Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động thêm mới nhân viên.
create trigger tg_NvNuNam
   on NHANVIEN
   AFTER INSERT
AS
   Declare @male int, @female int;
   select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
   select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
   print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
   print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);

INSERT INTO NHANVIEN VALUES ('Trần','Hồng','Hoàngg','034','15-06-2002','TP HCM','Nam',360000,'005',1)
GO


--Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động cập nhật phần giới tính nhân viên
create trigger trg_TongNVSauUpdate
   on NHANVIEN
   AFTER update
AS
   if (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   begin
      Declare @male int, @female int;
      select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
      select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
      print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);
   end;
UPDATE NHANVIEN
   SET HONV = 'Lê',PHAI = N'Nữ'
 WHERE  MaNV = '010'
GO

--Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN
CREATE TRIGGER trg_TongNVSauXoa on DEAN
AFTER DELETE
AS
begin
   SELECT MA_NVIEN, COUNT(MADA) as 'Số đề án đã tham gia' from PHANCONG
      GROUP BY MA_NVIEN
	  end
	  select * from DEAN
insert into dean values ('SQL', 50, 'HH', 4)
delete from dean where MADA=50


--Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA là 1.
create trigger Nv_DA1 on NHANVIEN
after insert 
as
begin
insert into PHANCONG values ((select manv from inserted), 1,2,20)
end
INSERT INTO NHANVIEN VALUES ('Trần','Hồng','Hoàng','031','15-6-2022','TpHCM','Nam',160000,'003',1)



--Đếm các nhân viên đã xóa 
create trigger xoanv
on nhanvien
after delete
as begin
declare @num char;
select @num = count (*) from deleted
print N'So luong nhan vien da xoa = ' + @num
end
delete from NHANVIEN where MANV ='017'