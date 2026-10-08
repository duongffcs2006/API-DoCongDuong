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
CREATE TABLE PhieuBaoSuCo
(
    MaPhieuBaoSuCo INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieu VARCHAR(50) NOT NULL,

    MaTaiSan INT NOT NULL,
    MaNguoiBaoCao INT NOT NULL,

    TieuDe NVARCHAR(200) NOT NULL,
    MoTa NVARCHAR(2000) NOT NULL,

    MucDoUuTien VARCHAR(20) NOT NULL
        CONSTRAINT DF_PhieuBaoSuCo_MucDoUuTien DEFAULT 'TRUNG_BINH',

    TrangThai VARCHAR(30) NOT NULL
        CONSTRAINT DF_PhieuBaoSuCo_TrangThai DEFAULT 'MOI_TAO',

    ThoiGianBaoCao DATETIME2 NOT NULL
        CONSTRAINT DF_PhieuBaoSuCo_ThoiGianBaoCao DEFAULT SYSDATETIME(),

    ThoiGianXuLyXong DATETIME2 NULL,
    ThoiGianDong DATETIME2 NULL,

    NgayTao DATETIME2 NOT NULL
        CONSTRAINT DF_PhieuBaoSuCo_NgayTao DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_PhieuBaoSuCo_MaPhieu
        UNIQUE (MaPhieu),

    CONSTRAINT FK_PhieuBaoSuCo_TaiSan
        FOREIGN KEY (MaTaiSan)
        REFERENCES TaiSan(MaTaiSan),

    CONSTRAINT FK_PhieuBaoSuCo_NguoiBaoCao
        FOREIGN KEY (MaNguoiBaoCao)
        REFERENCES NguoiDung(MaNguoiDung),

    CONSTRAINT CK_PhieuBaoSuCo_MucDoUuTien
        CHECK
        (
            MucDoUuTien IN
            (
                'THAP',
                'TRUNG_BINH',
                'CAO',
                'KHAN_CAP'
            )
        ),

    CONSTRAINT CK_PhieuBaoSuCo_TrangThai
        CHECK
        (
            TrangThai IN
            (
                'MOI_TAO',
                'DA_PHAN_CONG',
                'DANG_XU_LY',
                'DA_XU_LY',
                'DA_DONG',
                'DA_HUY'
            )
        ),

    CONSTRAINT CK_PhieuBaoSuCo_ThoiGianXuLy
        CHECK
        (
            ThoiGianXuLyXong IS NULL
            OR ThoiGianXuLyXong >= ThoiGianBaoCao
        ),

    CONSTRAINT CK_PhieuBaoSuCo_ThoiGianDong
        CHECK
        (
            ThoiGianDong IS NULL
            OR
            (
                ThoiGianXuLyXong IS NOT NULL
                AND ThoiGianDong >= ThoiGianXuLyXong
            )
        )
);



CREATE TABLE PhieuCongViec
(
    MaPhieuCongViec INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieu VARCHAR(50) NOT NULL,

    MaTaiSan INT NOT NULL,

    MaPhieuBaoSuCo INT NULL,
    MaLichBaoTri INT NULL,

    LoaiCongViec VARCHAR(10) NOT NULL,

    TieuDe NVARCHAR(200) NOT NULL,
    MoTa NVARCHAR(2000) NULL,

    MaKyThuatVien INT NULL,

    MucDoUuTien VARCHAR(20) NOT NULL
        CONSTRAINT DF_PhieuCongViec_MucDoUuTien DEFAULT 'TRUNG_BINH',

    TrangThai VARCHAR(30) NOT NULL
        CONSTRAINT DF_PhieuCongViec_TrangThai DEFAULT 'CHO_XU_LY',

    ThoiGianDuKienBatDau DATETIME2 NULL,
    ThoiGianDuKienKetThuc DATETIME2 NULL,

    ThoiGianThucTeBatDau DATETIME2 NULL,
    ThoiGianThucTeKetThuc DATETIME2 NULL,

    ChiPhiNhanCong DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_PhieuCongViec_ChiPhiNhanCong DEFAULT 0,

    ChiPhiLinhKien DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_PhieuCongViec_ChiPhiLinhKien DEFAULT 0,

    ChiPhiKhac DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_PhieuCongViec_ChiPhiKhac DEFAULT 0,

    NgayTao DATETIME2 NOT NULL
        CONSTRAINT DF_PhieuCongViec_NgayTao DEFAULT SYSDATETIME(),

    NgayHoanThanh DATETIME2 NULL,

    CONSTRAINT UQ_PhieuCongViec_MaPhieu
        UNIQUE (MaPhieu),

    CONSTRAINT FK_PhieuCongViec_TaiSan
        FOREIGN KEY (MaTaiSan)
        REFERENCES TaiSan(MaTaiSan),

    CONSTRAINT FK_PhieuCongViec_PhieuBaoSuCo
        FOREIGN KEY (MaPhieuBaoSuCo)
        REFERENCES PhieuBaoSuCo(MaPhieuBaoSuCo),

    CONSTRAINT FK_PhieuCongViec_LichBaoTri
        FOREIGN KEY (MaLichBaoTri)
        REFERENCES LichBaoTri(MaLichBaoTri),

    CONSTRAINT FK_PhieuCongViec_KyThuatVien
        FOREIGN KEY (MaKyThuatVien)
        REFERENCES NguoiDung(MaNguoiDung),

    CONSTRAINT CK_PhieuCongViec_LoaiCongViec
        CHECK
        (
            LoaiCongViec IN ('PM', 'CM')
        ),

    CONSTRAINT CK_PhieuCongViec_NguonCongViec
        CHECK
        (
            (
                LoaiCongViec = 'CM'
                AND MaPhieuBaoSuCo IS NOT NULL
                AND MaLichBaoTri IS NULL
            )
            OR
            (
                LoaiCongViec = 'PM'
                AND MaLichBaoTri IS NOT NULL
                AND MaPhieuBaoSuCo IS NULL
            )
        ),

    CONSTRAINT CK_PhieuCongViec_MucDoUuTien
        CHECK
        (
            MucDoUuTien IN
            (
                'THAP',
                'TRUNG_BINH',
                'CAO',
                'KHAN_CAP'
            )
        ),

    CONSTRAINT CK_PhieuCongViec_TrangThai
        CHECK
        (
            TrangThai IN
            (
                'CHO_XU_LY',
                'DA_PHAN_CONG',
                'DANG_XU_LY',
                'HOAN_THANH',
                'DA_HUY'
            )
        ),

    CONSTRAINT CK_PhieuCongViec_ThoiGianDuKien
        CHECK
        (
            ThoiGianDuKienKetThuc IS NULL
            OR ThoiGianDuKienBatDau IS NULL
            OR ThoiGianDuKienKetThuc >= ThoiGianDuKienBatDau
        ),

    CONSTRAINT CK_PhieuCongViec_ThoiGianThucTe
        CHECK
        (
            ThoiGianThucTeKetThuc IS NULL
            OR
            (
                ThoiGianThucTeBatDau IS NOT NULL
                AND ThoiGianThucTeKetThuc >= ThoiGianThucTeBatDau
            )
        ),

    CONSTRAINT CK_PhieuCongViec_NgayHoanThanh
        CHECK
        (
            NgayHoanThanh IS NULL
            OR ThoiGianThucTeBatDau IS NULL
            OR NgayHoanThanh >= ThoiGianThucTeBatDau
        ),

    CONSTRAINT CK_PhieuCongViec_ChiPhiNhanCong
        CHECK (ChiPhiNhanCong >= 0),

    CONSTRAINT CK_PhieuCongViec_ChiPhiLinhKien
        CHECK (ChiPhiLinhKien >= 0),

    CONSTRAINT CK_PhieuCongViec_ChiPhiKhac
        CHECK (ChiPhiKhac >= 0)
);



CREATE TABLE LinhKien
(
    MaLinhKien INT IDENTITY(1,1) PRIMARY KEY,
    MaQuanLyLinhKien VARCHAR(50) NOT NULL,
    TenLinhKien NVARCHAR(150) NOT NULL,
    DonViTinh NVARCHAR(50) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,

    TonKhoToiThieu INT NOT NULL
        CONSTRAINT DF_LinhKien_TonKhoToiThieu DEFAULT 0,

    DangHoatDong BIT NOT NULL
        CONSTRAINT DF_LinhKien_DangHoatDong DEFAULT 1,

    CONSTRAINT UQ_LinhKien_MaQuanLyLinhKien
        UNIQUE (MaQuanLyLinhKien),

    CONSTRAINT CK_LinhKien_DonGia
        CHECK (DonGia >= 0),

    CONSTRAINT CK_LinhKien_TonKhoToiThieu
        CHECK (TonKhoToiThieu >= 0)
);



CREATE TABLE Kho
(
    MaKho INT IDENTITY(1,1) PRIMARY KEY,
    TenKho NVARCHAR(150) NOT NULL,
    MaViTri INT NOT NULL,

    CONSTRAINT UQ_Kho_TenKho
        UNIQUE (TenKho),

    CONSTRAINT FK_Kho_ViTri
        FOREIGN KEY (MaViTri)
        REFERENCES ViTri(MaViTri)
);



CREATE TABLE TonKho
(
    MaTonKho INT IDENTITY(1,1) PRIMARY KEY,
    MaLinhKien INT NOT NULL,
    MaKho INT NOT NULL,

    SoLuong INT NOT NULL
        CONSTRAINT DF_TonKho_SoLuong DEFAULT 0,

    CONSTRAINT FK_TonKho_LinhKien
        FOREIGN KEY (MaLinhKien)
        REFERENCES LinhKien(MaLinhKien),

    CONSTRAINT FK_TonKho_Kho
        FOREIGN KEY (MaKho)
        REFERENCES Kho(MaKho),

    CONSTRAINT UQ_TonKho_LinhKien_Kho
        UNIQUE (MaLinhKien, MaKho),

    CONSTRAINT CK_TonKho_SoLuong
        CHECK (SoLuong >= 0)
);



CREATE TABLE SuDungLinhKien
(
    MaSuDungLinhKien INT IDENTITY(1,1) PRIMARY KEY,

    MaPhieuCongViec INT NOT NULL,
    MaLinhKien INT NOT NULL,
    MaKho INT NOT NULL,

    SoLuong INT NOT NULL,
    DonGiaThucTe DECIMAL(18,2) NOT NULL,

    MaNguoiSuDung INT NOT NULL,

    ThoiGianSuDung DATETIME2 NOT NULL
        CONSTRAINT DF_SuDungLinhKien_ThoiGianSuDung DEFAULT SYSDATETIME(),

    GhiChu NVARCHAR(500) NULL,

    CONSTRAINT FK_SuDungLinhKien_PhieuCongViec
        FOREIGN KEY (MaPhieuCongViec)
        REFERENCES PhieuCongViec(MaPhieuCongViec),

    CONSTRAINT FK_SuDungLinhKien_LinhKien
        FOREIGN KEY (MaLinhKien)
        REFERENCES LinhKien(MaLinhKien),

    CONSTRAINT FK_SuDungLinhKien_Kho
        FOREIGN KEY (MaKho)
        REFERENCES Kho(MaKho),

    CONSTRAINT FK_SuDungLinhKien_NguoiDung
        FOREIGN KEY (MaNguoiSuDung)
        REFERENCES NguoiDung(MaNguoiDung),

    CONSTRAINT CK_SuDungLinhKien_SoLuong
        CHECK (SoLuong > 0),

    CONSTRAINT CK_SuDungLinhKien_DonGiaThucTe
        CHECK (DonGiaThucTe >= 0)
);



CREATE TABLE GiaoDichKho
(
    MaGiaoDich BIGINT IDENTITY(1,1) PRIMARY KEY,

    MaLinhKien INT NOT NULL,
    MaKho INT NOT NULL,
    MaPhieuCongViec INT NULL,

    LoaiGiaoDich VARCHAR(20) NOT NULL,

    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NULL,

    MaNguoiThucHien INT NOT NULL,

    ThoiGianTao DATETIME2 NOT NULL
        CONSTRAINT DF_GiaoDichKho_ThoiGianTao DEFAULT SYSDATETIME(),

    GhiChu NVARCHAR(500) NULL,

    CONSTRAINT FK_GiaoDichKho_LinhKien
        FOREIGN KEY (MaLinhKien)
        REFERENCES LinhKien(MaLinhKien),

    CONSTRAINT FK_GiaoDichKho_Kho
        FOREIGN KEY (MaKho)
        REFERENCES Kho(MaKho),

    CONSTRAINT FK_GiaoDichKho_PhieuCongViec
        FOREIGN KEY (MaPhieuCongViec)
        REFERENCES PhieuCongViec(MaPhieuCongViec),

    CONSTRAINT FK_GiaoDichKho_NguoiDung
        FOREIGN KEY (MaNguoiThucHien)
        REFERENCES NguoiDung(MaNguoiDung),

    CONSTRAINT CK_GiaoDichKho_LoaiGiaoDich
        CHECK
        (
            LoaiGiaoDich IN
            (
                'NHAP',
                'XUAT',
                'TRA_LAI',
                'DIEU_CHINH'
            )
        ),

    CONSTRAINT CK_GiaoDichKho_SoLuong
        CHECK (SoLuong > 0),

    CONSTRAINT CK_GiaoDichKho_DonGia
        CHECK (DonGia IS NULL OR DonGia >= 0)
);


-- 1. Tài sản
CREATE INDEX IX_TaiSan_MaLoaiTaiSan
ON TaiSan(maloaitaisan);
GO

CREATE INDEX IX_TaiSan_MaViTri
ON TaiSan(mavitri);
GO

CREATE INDEX IX_TaiSan_TrangThai
ON TaiSan(trangthai);
GO


-- 2. Lịch bảo trì
CREATE INDEX IX_LichBaoTri_NgayBaoTriTiepTheo
ON LichBaoTri(ngaybaotritieptheo);
GO


-- 3. Phiếu báo sự cố
CREATE INDEX IX_PhieuBaoSuCo_MaTaiSan
ON PhieuBaoSuCo(mataisan);
GO

CREATE INDEX IX_PhieuBaoSuCo_MaNguoiBaoCao
ON PhieuBaoSuCo(manguoibaocao);
GO

CREATE INDEX IX_PhieuBaoSuCo_TrangThai
ON PhieuBaoSuCo(trangthai);
GO


-- 4. Phiếu công việc
CREATE INDEX IX_PhieuCongViec_MaTaiSan
ON PhieuCongViec(mataisan);
GO

CREATE INDEX IX_PhieuCongViec_MaKyThuatVien
ON PhieuCongViec(makythuatvien);
GO

CREATE INDEX IX_PhieuCongViec_TrangThai
ON PhieuCongViec(trangthai);
GO


-- 5. Linh kiện đã sử dụng
CREATE INDEX IX_SuDungLinhKien_MaPhieuCongViec
ON SuDungLinhKien(maphieucongviec);
GO


);
