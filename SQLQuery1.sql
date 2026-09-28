create database DA2_DoCongDuong

use DA2_DoCongDuong;

create table NguoiDung (
	NDid varchar(10) primary key,
	HoTen nvarchar(100),
	Email varchar(20) unique,
	MK varchar(20) not null,
	quyenhan varchar(10) not null check ( quyenhan IN(N'admin' , N'kỹ thuật', N'KhachHang'))


);