CREATE DATABASE DuAnMau
GO

USE DuAnMau
GO


CREATE TABLE NhanVien(
	MaNV nvarchar(50) NOT NULL,
	MatKhau nvarchar(50) NOT NULL,
	HoTen nvarchar(50) NOT NULL,
	VaiTro bit NOT NULL DEFAULT 0,
	PRIMARY KEY(MaNV)
)
GO

CREATE TABLE ChuyenDe(
	MaCD nchar(5) NOT NULL,
	TenCD nvarchar(50) NOT NULL UNIQUE,
	HocPhi float NOT NULL DEFAULT 0,
	ThoiLuong int NOT NULL DEFAULT 30,
	Hinh nvarchar(50) NOT NULL DEFAULT 'chuyen-de.png',
	MoTa nvarchar(255) NOT NULL,
	PRIMARY KEY(MaCD),
	CHECK(HocPhi >= 0 AND ThoiLuong > 0)
)
GO


CREATE TABLE NguoiHoc(
	MaNH nchar(7) NOT NULL,
	HoTen nvarchar(50) NOT NULL,
	NgaySinh date NOT NULL,
	GioiTinh bit NOT NULL DEFAULT 0,
	DienThoai nvarchar(50) NOT NULL,
	Email nvarchar(50) NOT NULL,
	GhiChu nvarchar(max) NULL,
	MaNV nvarchar(50) NOT NULL,
	NgayDK date NOT NULL DEFAULT getdate(),
	PRIMARY KEY(MaNH)
)
GO


CREATE TABLE KhoaHoc(
	MaKH int IDENTITY(1, 1) NOT NULL,
	MaCD nchar(5) NOT NULL,
	HocPhi float NOT NULL DEFAULT 0,
	ThoiLuong int NOT NULL DEFAULT 0,
	NgayKG date NOT NULL,
	GhiChu nvarchar(50) NULL,
	MaNV nvarchar(50) NOT NULL,
	NgayTao date NOT NULL DEFAULT getdate(),
	PRIMARY KEY(MaKH),
	CHECK(HocPhi >= 0 AND ThoiLuong > 0),
	FOREIGN KEY (MaCD) REFERENCES ChuyenDe(MaCD) ON UPDATE CASCADE,
	FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE
)
GO


CREATE TABLE HocVien(
	MaHV int IDENTITY(1, 1) NOT NULL,
	MaKH int NOT NULL UNIQUE,
	MaNH nchar(7) NOT NULL UNIQUE,
	Diem float NOT NULL,
	PRIMARY KEY(MaHV),
	FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH) ON DELETE CASCADE,
	FOREIGN KEY (MaNH) REFERENCES NguoiHoc(MaNH) ON UPDATE CASCADE
)
GO


IF OBJECT_ID('sp_ThongKeNguoiHoc') IS NOT NULL
	DROP PROC sp_ThongKeNguoiHoc
GO
CREATE PROC sp_ThongKeNguoiHoc AS 
BEGIN
	SELECT
		YEAR(NgayDK) Nam,
		COUNT(*) SoLuong,
		MIN(NgayDK) DauTien,
		MAX(NgayDK) CuoiCung
	FROM NguoiHoc
	GROUP BY YEAR(NgayDK)
END
GO


IF OBJECT_ID('sp_ThongKeDoanhThu') IS NOT NULL
	DROP PROC sp_ThongKeDoanhThu
GO
CREATE PROC sp_ThongKeDoanhThu(@Year INT) AS 
BEGIN
	SELECT
		TenCD ChuyenDe,
		COUNT(DISTINCT kh.MaKH) SoKH,
		COUNT(hv.MaHV) SoHV,
		SUM(kh.HocPhi) DoanhThu,
		MIN(kh.HocPhi) ThapNhat,
		MAX(kh.HocPhi) CaoNhat,
		AVG(kh.HocPhi) TrungBinh
	FROM KhoaHoc kh
		JOIN HocVien hv ON kh.MaKH = hv.MaKH
		JOIN ChuyenDe cd ON cd.MaCD = kh.MaCD
	WHERE YEAR(NgayKG) = @Year
	GROUP BY TenCD
END
GO


IF OBJECT_ID('sp_ThongKeDiemChuyenDe') IS NOT NULL
	DROP PROC sp_ThongKeDiemChuyenDe
GO
CREATE PROC sp_ThongKeDiemChuyenDe AS 
BEGIN
	SELECT
		TenCD ChuyenDe,
		COUNT(MaHV) SoHV,
		MIN(Diem) ThapNhat,
		MAX(Diem) CaoNhat,
		AVG(Diem) TrungBinh
	FROM KhoaHoc kh
		JOIN HocVien hv ON kh.MaKH = hv.MaKH
		JOIN ChuyenDe cd ON cd.MaCD = kh.MaCD
	GROUP BY TenCD
END
GO


IF OBJECT_ID('sp_BangDiem') IS NOT NULL
	DROP PROC sp_BangDiem
GO
CREATE PROC sp_BangDiem(@MaKH INT) AS 
BEGIN
	SELECT
		nh.MaNH,
		nh.HoTen,
		hv.Diem
	FROM HocVien hv
		JOIN NguoiHoc nh ON nh.MaNH = hv.MaNH
	WHERE hv.MaKH = @MaKH
	ORDER BY hv.Diem DESC
END