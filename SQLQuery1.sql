create database DA2_DoCongDuong

use DA2_DoCongDuong;

CREATE TABLE NguoiDung (
    id varchar(10) PRIMARY KEY,
    hoten nvarchar(100),
    email varchar(20) UNIQUE,
    mk varchar(20) NOT NULL,
    vaitro nvarchar(20) NOT NULL 
        CHECK (vaitro IN (N'admin', N'kỹ thuật', N'KhachHang')),
    trangthai bit NOT NULL DEFAULT 1,
    ngaytao datetime2 NOT NULL DEFAULT SYSDATETIME()
);

create table LoaiTaiSan (
	maloaitaisan varchar(10) primary key,
	tenloaitaisan nvarchar(100) not null unique,
	mota nvarchar (max)
);

create table Vitri(
	mavitri varchar(10) primary key,
	tenvitri nvarchar(100) not null,
	diachi nvarchar(200) not null,
	mota nvarchar(max)
);	

create table TaiSan (
	mataisan int identity(1,1) primary key,
	maquanlytaisan varchar(20) not null unique,
	tentaisan nvarchar(100) not null,
	soSerial varchar(100) not null unique,
	maloaitaisan varchar(10) not null,
	tenloaitaisan nvarchar(100) not null,
	mavitri varchar(10),
	ngaymua datetime2 not null default sysdatetime(),
	giamua decimal(18,2) check (giamua is null or giamua >= 0),
	trangthai nvarchar(50) NOT NULL CHECK (trangthai IN
            (
                N'Đang hoạt động',
                N'Đã hỏng',
                N'Đang bảo trì',
                N'Không hoạt động',
                N'Đã thanh lý/ngưng sử dụng'
            )),
	mota nvarchar(max) not null,
	ngaytao datetime2 not null default sysdatetime(),
		ngaycapnhat datetime2,
		daxoa bit not null default 0,
		constraint TaiSan_LoaiTaiSan foreign key(maloaitaisan) references LoaiTaiSan(maloaitaisan),
		constraint TaiSan_Vitri foreign key(mavitri) references Vitri(mavitri)
		

	);
create table BaoHanh(
	mabaohanh varchar(20) primary key,
	mataisan int not null,
	nhacungcap nvarchar(100) not null,
	ngaycungcap date not null,
	ngayketthuc date not null,
	mota nvarchar(max),
	constraint BaoHanh_TaiSan foreign key(mataisan) references TaiSan(mataisan),
	constraint BaoHanh_ThoiGian check (ngayketthuc >= ngaycungcap)
);
CREATE TABLE LichBaoTri
(
    MaLichBaoTri INT IDENTITY(1,1) PRIMARY KEY,
    MaTaiSan INT NOT NULL,

    TenLichBaoTri NVARCHAR(150) NOT NULL,

    LoaiChuKy VARCHAR(20) NOT NULL,
    GiaTriChuKy INT NOT NULL,

    NgayBaoTriGanNhat DATETIME2 NULL,
    NgayBaoTriTiepTheo DATETIME2 NOT NULL,

    DangHoatDong BIT NOT NULL
        CONSTRAINT DF_LichBaoTri_DangHoatDong DEFAULT 1,

    NgayTao DATETIME2 NOT NULL
        CONSTRAINT DF_LichBaoTri_NgayTao DEFAULT SYSDATETIME(),

    CONSTRAINT FK_LichBaoTri_TaiSan
        FOREIGN KEY (MaTaiSan)
        REFERENCES TaiSan(MaTaiSan),

    CONSTRAINT CK_LichBaoTri_LoaiChuKy
        CHECK
        (
            LoaiChuKy IN
            (
                'NGAY',
                'TUAN',
                'THANG',
                'NAM'
            )
        ),

    CONSTRAINT CK_LichBaoTri_GiaTriChuKy
        CHECK (GiaTriChuKy > 0),

    CONSTRAINT CK_LichBaoTri_ThoiGian
        CHECK
        (
            NgayBaoTriGanNhat IS NULL
            OR NgayBaoTriTiepTheo > NgayBaoTriGanNhat
        )
);


);
