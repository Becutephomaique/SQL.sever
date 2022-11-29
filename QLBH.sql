create table NhanVien (
	MaNV char(4) primary key,
	Hoten varchar(40) NOT NULL,
	SDT varchar (20) not null,
	NgVL smalldatetime not null,
	)
create table KhachHang (
	MaKH char (4) primary key,
	Hoten varchar (40) not null,
	Gioitinh char (5) not null,
	DChi varchar (40) not null,
	SDT varchar (20) not null,
	Doanhso money ,
	)
create table SanPham (
	MaSP char (4) primary key,
	Tensp varchar (40) not null,
	DVT varchar (20) not null,
	NuocSX varchar (40) not null,
	Gia money ,
	)
create table Hoadon (
	SoHd int primary key,
	NgHD smalldatetime ,
	MaKH char (4) ,
	MaNV char (4),
	constraint fk_Hoadon_MaNV foreign key(MaNV) references NhanVien(MaNV) on delete cascade,
	constraint fk_Hoadon_MaKH foreign key(MaKH) references KhachHang(MaKH)on delete cascade,
	)
create table CTHD (
	SoHd int,
	MaSP char (4) ,
	SL int,
	primary key (SoHd , MaSP),
	constraint fk_CTHD_SoHd foreign key(SoHd) references Hoadon(SoHd) on delete cascade,
	constraint fk_CTHD_MaSP foreign key(MaSP) references SanPham(MaSP) on delete cascade,
	)
