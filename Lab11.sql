--Câu 1 Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
create function diemtb(@masv nvarchar(10))
returns float 
as 
begin
return(select (avg(Diemthi)) from KetQua where @masv = MaSV)
end
go
print('Điểm trung bình là: '+CONVERT(nvarchar,dbo.diemtb('002')))

--Câu 2 Viết hàm bằng 2 cách (table – value fuction và multistatement value function) tính điểm trung bình của cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1
go
create function Tinhdiem(@malop nvarchar(10))
returns table 
as 
return
	select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
go
create function trbinhlop(@malop nvarchar(10))
returns @dsdiemtb table (masv char(5), tensv nvarchar(20), dtb float)
as
begin
 insert @dsdiemtb
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
 return
end
go
select * from trbinhlop('L01')
--Câu 3 Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên có MaSV=01 thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi môn nào”
go
create proc kiemtra @masv nvarchar(10)
as
begin
 declare @dem int
 set @dem=(select count(*) from KetQua where MaSV=@masv)
 if @dem = 0
 print 'sinh vien '+@masv + ' khong thi mon nao'
 else
 print 'sinh vien '+ @masv+ ' thi '+cast(@dem as nvarchar(10))+ 'mon'
end
go
exec kiemtra '001'
--Câu 4 Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách sinh viên thì hệ thống cập nhật lại siso của lớp, mỗi lớp tối đa 10SV, nếu thêm vào &gt;10 thì thông báo lớp đầy và hủy giao dịch
go
create trigger kt_ss
on sinhvien for insert
as
begin
 declare @siso int
 set @siso=(select count(*) from sinhvien s
 where malop in(select malop from inserted))
 if @siso > 10
	 begin
	print 'Lop day'
	rollback tran
	end
	else
	begin
		 update lop
		set SiSo=@siso
		where malop in (select malop from inserted)
 end
 end