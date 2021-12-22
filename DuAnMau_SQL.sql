CREATE DATABASE DuAnMau
GO

USE DuAnMau
GO

CREATE TABLE Mailer(
	UsernameMailer varchar(50) NOT NULL,
	PasswordMailer varchar(255) NOT NULL,
	PRIMARY KEY(UsernameMailer)
)
GO

CREATE TABLE NhanVien(
	MaNV nvarchar(50) NOT NULL,
	MatKhau nvarchar(32) NOT NULL,
	HoTen nvarchar(50) NOT NULL,
	VaiTro bit NOT NULL DEFAULT 0,
	Email nvarchar(50) NOT NULL,
	QuenMK nvarchar(15),
	PRIMARY KEY(MaNV)
)
GO

ALTER TABLE NhanVien
add GioiTinh nvarchar(50);

GO

CREATE TABLE ChuyenDe(
	MaCD nchar(5) NOT NULL,
	TenCD nvarchar(50) NOT NULL,
	HocPhi float NOT NULL DEFAULT 0,
	ThoiLuong int NOT NULL DEFAULT 30,
	Hinh nvarchar(255) NOT NULL DEFAULT 'chuyen-de.png',
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
	Hinh nvarchar(255) NOT NULL DEFAULT 'default.png',
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
	MaKH int NOT NULL,
	MaNH nchar(7) NOT NULL,
	Diem float NOT NULL,
	PRIMARY KEY(MaHV),
	FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH) ON DELETE CASCADE,
	FOREIGN KEY (MaNH) REFERENCES NguoiHoc(MaNH) ON UPDATE CASCADE
)
GO


IF OBJECT_ID('sp_LuongNguoiHoc') IS NOT NULL
	DROP PROC sp_LuongNguoiHoc
GO
CREATE PROC sp_LuongNguoiHoc AS 
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


IF OBJECT_ID('sp_DoanhThu') IS NOT NULL
	DROP PROC sp_DoanhThu
GO
CREATE PROC sp_DoanhThu(@Year INT) AS 
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


IF OBJECT_ID('sp_DiemChuyenDe') IS NOT NULL
	DROP PROC sp_DiemChuyenDe
GO
CREATE PROC sp_DiemChuyenDe AS 
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
GO

--insert du lieu
	-- table nhan vien
INSERT INTO NhanVien VALUES
(N'LongNDH', N'songlong', N'Nguyễn Đình Hoàng Long', 0, N'longndh@gmail.com', NULL),
(N'LongNDT', N'songlong', N'Nguyễn Đình Thiên Long', 0, N'longndt@gmail.com', NULL),
(N'NghiemN', N'songlong', N'Nguyễn Nghiệm', 1, N'nghiemn@gmail.com', NULL),
(N'NoPT', N'123456', N'Phạm Thị Nở', 0, N'nopt@gmail.com', NULL),
(N'PheoNC', N'123456', N'Nguyễn Chí Phèo', 0, N'pheonc@gmail.com', NULL),
(N'TeoNV', N'songlong', N'Nguyễn Văn Tèo', 1, N'tennv@gmail.com', NULL),
(N'phuho', N'123456', N'Hồ Hoàng Phú', 1, N'phuvncom007@gmail.com', NULL),
(N'ngocky', N'123456', N'Hồ Ngọc Kỳ', 1, N'ngocky@gmail.com', NULL),
(N'wibu', N'123456', N'wibumecode', 0, N'wibu@gmail.com', NULL),
(N'ThaoLTH', N'songlong', N'Lê Thị Hương Thảo', 0, N'thaolth@gmail.com', NULL)
GO

	--table nguoi hoc
INSERT INTO NguoiHoc VALUES
(N'PS17588', N'Hồ Hoàng Phú', CAST('09-16-2002' AS Date), 1, N'0357337812', N'phuvncom007@gmail.com', N'1.png', N'Nghèo', N'phuho', getDate()),
(N'PS17599', N'Hồ Ngọc Kỳ', CAST('10-16-2000' AS Date), 0, N'0988818789', N'ngocky@gmail.com', N'2.png', N'', N'phuho', getDate()),
(N'PS01638', N'LỮ HUY CƯỜNG', CAST(0xAF170B00 AS Date), 1, N'0928768265', N'PS01638@fpt.edu.vn', N'3.png', N'0928768265 - LỮ HUY CƯỜNG', N'TeoNV', CAST(0xAF170B00 AS Date)),
(N'PS02037', N'ĐỖ VĂN MINH', CAST(0xC6190B00 AS Date), 1, N'0968095685', N'PS02037@fpt.edu.vn', N'4.png', N'0968095685 - ĐỖ VĂN MINH', N'PheoNC', CAST(0xC6190B00 AS Date)),
(N'PS02771', N'NGUYỄN TẤN HIẾU', CAST(0x2E220B00 AS Date), 1, N'0927594734', N'PS02771@fpt.edu.vn', N'4.png', N'0927594734 - NGUYỄN TẤN HIẾU', N'PheoNC', CAST(0x2E220B00 AS Date)),
(N'PS02867', N'NGUYỄN HỮU TRÍ', CAST(0xEB200B00 AS Date), 1, N'0946984711', N'PS02867@fpt.edu.vn', N'4.png', N'0946984711 - NGUYỄN HỮU TRÍ', N'TeoNV', CAST(0xEB200B00 AS Date)),
(N'PS02930', N'TRẦN VĂN NAM', CAST(0xA1240B00 AS Date), 1, N'0924774498', N'PS02930@fpt.edu.vn', N'3.png', N'0924774498 - TRẦN VĂN NAM', N'TeoNV', CAST(0xA1240B00 AS Date)),
(N'PS02979', N'ĐOÀN TRẦN NHẬT VŨ', CAST(0x671C0B00 AS Date), 1, N'0912374818', N'PS02979@fpt.edu.vn', N'1.png', N'0912374818 - ĐOÀN TRẦN NHẬT VŨ', N'TeoNV', CAST(0x671C0B00 AS Date)),
(N'PS02983', N'NGUYỄN HOÀNG THIÊN PHƯỚC', CAST(0x681A0B00 AS Date), 1, N'0912499836', N'PS02983@fpt.edu.vn', N'3.png', N'0912499836 - NGUYỄN HOÀNG THIÊN PHƯỚC', N'PheoNC', CAST(0x681A0B00 AS Date)),
(N'PS02988', N'HỒ HỮU HẬU', CAST(0x311A0B00 AS Date), 1, N'0924984876', N'PS02988@fpt.edu.vn', N'3.png', N'0924984876 - HỒ HỮU HẬU', N'PheoNC', CAST(0x311A0B00 AS Date)),
(N'PS03031', N'PHAN TẤN VIỆT', CAST(0x21160B00 AS Date), 1, N'0924832716', N'PS03031@fpt.edu.vn', N'3.png', N'0924832716 - PHAN TẤN VIỆT', N'PheoNC', CAST(0x21160B00 AS Date)),
(N'PS03046', N'NGUYỄN CAO PHƯỚC', CAST(0xDE150B00 AS Date), 1, N'0977117727', N'PS03046@fpt.edu.vn', N'default.png', N'0977117727 - NGUYỄN CAO PHƯỚC', N'PheoNC', CAST(0xDE150B00 AS Date)),
(N'PS03080', N'HUỲNH THANH HUY', CAST(0x701C0B00 AS Date), 1, N'0916436052', N'PS03080@fpt.edu.vn', N'default.png', N'0916436052 - HUỲNH THANH HUY', N'PheoNC', CAST(0x701C0B00 AS Date)),
(N'PS03088', N'NGUYỄN HOÀNG TRUNG', CAST(0x24180B00 AS Date), 1, N'0938101529', N'PS03088@fpt.edu.vn', N'default.png', N'0938101529 - NGUYỄN HOÀNG TRUNG', N'PheoNC', CAST(0x24180B00 AS Date)),
(N'PS03096', N'ĐOÀN HỮU KHANG', CAST(0xAB1B0B00 AS Date), 1, N'0945196719', N'PS03096@fpt.edu.vn', N'default.png', N'0945196719 - ĐOÀN HỮU KHANG', N'PheoNC', CAST(0xAB1B0B00 AS Date)),
(N'PS03104', N'LÊ THÀNH PHƯƠNG', CAST(0x3E1A0B00 AS Date), 0, N'0922948096', N'PS03104@fpt.edu.vn', N'default.png', N'0922948096 - LÊ THÀNH PHƯƠNG', N'TeoNV', CAST(0x3E1A0B00 AS Date)),
(N'PS03120', N'PHẠM NGỌC NHẬT TRƯỜNG', CAST(0x48230B00 AS Date), 1, N'0994296169', N'PS03120@fpt.edu.vn', N'default.png', N'0994296169 - PHẠM NGỌC NHẬT TRƯỜNG', N'PheoNC', CAST(0x48230B00 AS Date)),
(N'PS03130', N'ĐẶNG BẢO VIỆT', CAST(0xEF150B00 AS Date), 1, N'0917749344', N'PS03130@fpt.edu.vn', N'default.png', N'0917749344 - ĐẶNG BẢO VIỆT', N'PheoNC', CAST(0xEF150B00 AS Date)),
(N'PS03134', N'LÊ DUY BẢO', CAST(0x2E1F0B00 AS Date), 1, N'0926714368', N'PS03134@fpt.edu.vn', N'default.png', N'0926714368 - LÊ DUY BẢO', N'PheoNC', CAST(0x2E1F0B00 AS Date)),
(N'PS03172', N'NGUYỄN ANH TUẤN', CAST(0xCA180B00 AS Date), 1, N'0920020472', N'PS03172@fpt.edu.vn', N'default.png', N'0920020472 - NGUYỄN ANH TUẤN', N'PheoNC', CAST(0xCA180B00 AS Date)),
(N'PS03202', N'PHAN QUỐC QUI', CAST(0x741E0B00 AS Date), 1, N'0930649274', N'PS03202@fpt.edu.vn', N'default.png', N'0930649274 - PHAN QUỐC QUI', N'PheoNC', CAST(0x741E0B00 AS Date)),
(N'PS03203', N'ĐẶNG LÊ QUANG VINH', CAST(0xC4150B00 AS Date), 1, N'0920197355', N'PS03203@fpt.edu.vn', N'4.png', N'0920197355 - ĐẶNG LÊ QUANG VINH', N'PheoNC', CAST(0xC4150B00 AS Date)),
(N'PS03205', N'NGUYỄN MINH SANG', CAST(0x5E1D0B00 AS Date), 1, N'0967006218', N'PS03205@fpt.edu.vn', N'4.png', N'0967006218 - NGUYỄN MINH SANG', N'PheoNC', CAST(0x5E1D0B00 AS Date)),
(N'PS03222', N'TRẦM MINH MẪN', CAST(0xE71F0B00 AS Date), 1, N'0911183649', N'PS03222@fpt.edu.vn', N'4.png', N'0911183649 - TRẦM MINH MẪN', N'PheoNC', CAST(0xE71F0B00 AS Date)),
(N'PS03230', N'NGUYỄN PHẠM MINH HÂN', CAST(0x26250B00 AS Date), 1, N'0983469892', N'PS03230@fpt.edu.vn', N'4.png', N'0983469892 - NGUYỄN PHẠM MINH HÂN', N'PheoNC', CAST(0x26250B00 AS Date)),
(N'PS03233', N'LƯU KIM HOÀNG DUY', CAST(0x0B1F0B00 AS Date), 1, N'0938357735', N'PS03233@fpt.edu.vn', N'4.png', N'0938357735 - LƯU KIM HOÀNG DUY', N'PheoNC', CAST(0x0B1F0B00 AS Date)),
(N'PS03251', N'TRẦN QUANG VŨ', CAST(0x4C240B00 AS Date), 1, N'0914531913', N'PS03251@fpt.edu.vn', N'4.png', N'0914531913 - TRẦN QUANG VŨ', N'PheoNC', CAST(0x4C240B00 AS Date)),
(N'PS03304', N'BÙI NGỌC THUẬN', CAST(0xFE1C0B00 AS Date), 1, N'0999794115', N'PS03304@fpt.edu.vn', N'4.png', N'0999794115 - BÙI NGỌC THUẬN', N'PheoNC', CAST(0xFE1C0B00 AS Date)),
(N'PS03306', N'HỒ VĂN HÀNH', CAST(0x06190B00 AS Date), 1, N'0912277868', N'PS03306@fpt.edu.vn', N'3.png', N'0912277868 - HỒ VĂN HÀNH', N'PheoNC', CAST(0x06190B00 AS Date)),
(N'PS03308', N'TRẦN VIẾT HÙNG', CAST(0xD0220B00 AS Date), 1, N'0916050164', N'PS03308@fpt.edu.vn', N'3.png', N'0916050164 - TRẦN VIẾT HÙNG', N'PheoNC', CAST(0xD0220B00 AS Date)),
(N'PS03325', N'NGUYỄN HOÀNG MINH ĐỨC', CAST(0xAB1F0B00 AS Date), 1, N'0912234437', N'PS03325@fpt.edu.vn', N'default.png', N'0912234437 - NGUYỄN HOÀNG MINH ĐỨC', N'PheoNC', CAST(0xAB1F0B00 AS Date)),
(N'PS03346', N'PHAN THANH PHONG', CAST(0xD7150B00 AS Date), 1, N'0937891282', N'PS03346@fpt.edu.vn', N'default.png', N'0937891282 - PHAN THANH PHONG', N'PheoNC', CAST(0xD7150B00 AS Date)),
(N'PS03383', N'TRẦN VŨ LUÂN', CAST(0x8E210B00 AS Date), 1, N'0962030316', N'PS03383@fpt.edu.vn', N'default.png', N'0962030316 - TRẦN VŨ LUÂN', N'PheoNC', CAST(0x8E210B00 AS Date)),
(N'PS03389', N'VŨ ĐỨC TUẤN', CAST(0x411A0B00 AS Date), 1, N'0911637415', N'PS03389@fpt.edu.vn', N'default.png', N'0911637415 - VŨ ĐỨC TUẤN', N'PheoNC', CAST(0x411A0B00 AS Date)),
(N'PS03410', N'TRẦN  NHẠT', CAST(0x3C190B00 AS Date), 1, N'0946219377', N'PS03410@fpt.edu.vn', N'3.png', N'0946219377 - TRẦN  NHẠT', N'PheoNC', CAST(0x3C190B00 AS Date)),
(N'PS03411', N'TRƯƠNG THÀNH ĐẠT', CAST(0x3F1B0B00 AS Date), 1, N'0991509408', N'PS03411@fpt.edu.vn', N'default.png', N'0991509408 - TRƯƠNG THÀNH ĐẠT', N'PheoNC', CAST(0x3F1B0B00 AS Date)),
(N'PS03425', N'TÔ VĂN NĂNG', CAST(0x6E190B00 AS Date), 1, N'0915134551', N'PS03425@fpt.edu.vn', N'4.png', N'0915134551 - TÔ VĂN NĂNG', N'PheoNC', CAST(0x6E190B00 AS Date)),
(N'PS03454', N'NGUYỄN NHẬT VĨNH', CAST(0x57230B00 AS Date), 1, N'0917886371', N'PS03454@fpt.edu.vn', N'3.png', N'0917886371 - NGUYỄN NHẬT VĨNH', N'PheoNC', CAST(0x57230B00 AS Date)),
(N'PS03472', N'NGUYỄN VĂN HUY', CAST(0xD8150B00 AS Date), 1, N'0960620997', N'PS03472@fpt.edu.vn', N'3.png', N'0960620997 - NGUYỄN VĂN HUY', N'PheoNC', CAST(0xD8150B00 AS Date)),
(N'PS03488', N'NGUYỄN NHƯ NGỌC', CAST(0x651D0B00 AS Date), 0, N'0912880267', N'PS03488@fpt.edu.vn', N'3.png', N'0912880267 - NGUYỄN NHƯ NGỌC', N'PheoNC', CAST(0x651D0B00 AS Date)),
(N'PS03530', N'PHẠM THÀNH TÂM', CAST(0x4D240B00 AS Date), 1, N'0918161783', N'PS03530@fpt.edu.vn', N'3.png', N'0918161783 - PHẠM THÀNH TÂM', N'PheoNC', CAST(0x4D240B00 AS Date)),
(N'PS03553', N'ĐINH TẤN CÔNG', CAST(0xEA240B00 AS Date), 1, N'0918182551', N'PS03553@fpt.edu.vn', N'3.png', N'0918182551 - ĐINH TẤN CÔNG', N'PheoNC', CAST(0xEA240B00 AS Date)),
(N'PS03561', N'LÊ MINH ĐIỀN', CAST(0xE91C0B00 AS Date), 1, N'0948199564', N'PS03561@fpt.edu.vn', N'4.png', N'0948199564 - LÊ MINH ĐIỀN', N'PheoNC', CAST(0xE91C0B00 AS Date)),
(N'PS03596', N'NGUYỄN THANH HIỀN', CAST(0xED170B00 AS Date), 1, N'0910545901', N'PS03596@fpt.edu.vn', N'default.png', N'0910545901 - NGUYỄN THANH HIỀN', N'PheoNC', CAST(0xED170B00 AS Date)),
(N'PS03603', N'LÊ PHẠM KIM THANH', CAST(0x501C0B00 AS Date), 0, N'0924696779', N'PS03603@fpt.edu.vn', N'default.png', N'0924696779 - LÊ PHẠM KIM THANH', N'PheoNC', CAST(0x501C0B00 AS Date)),
(N'PS03610', N'TRẦN ĐÌNH TRƯỜNG', CAST(0xF41C0B00 AS Date), 1, N'0941528106', N'PS03610@fpt.edu.vn', N'3.png', N'0941528106 - TRẦN ĐÌNH TRƯỜNG', N'PheoNC', CAST(0xF41C0B00 AS Date)),
(N'PS03614', N'NGUYỄN VĂN SÁU', CAST(0x37160B00 AS Date), 1, N'0940711328', N'PS03614@fpt.edu.vn', N'default.png', N'0940711328 - NGUYỄN VĂN SÁU', N'PheoNC', CAST(0x37160B00 AS Date)),
(N'PS03618', N'PHÍ ĐÌNH VIỆT HÙNG', CAST(0xA91F0B00 AS Date), 1, N'0939020097', N'PS03618@fpt.edu.vn', N'4.png', N'0939020097 - PHÍ ĐÌNH VIỆT HÙNG', N'PheoNC', CAST(0xA91F0B00 AS Date)),
(N'PS03638', N'PHẠM NHẬT MINH', CAST(0x86200B00 AS Date), 1, N'0927771672', N'PS03638@fpt.edu.vn', N'3.png', N'0927771672 - PHẠM NHẬT MINH', N'PheoNC', CAST(0x86200B00 AS Date)),
(N'PS03640', N'LƯU THANH NGỌC', CAST(0x591B0B00 AS Date), 0, N'0918358164', N'PS03640@fpt.edu.vn', N'4.png', N'0918358164 - LƯU THANH NGỌC', N'PheoNC', CAST(0x591B0B00 AS Date)),
(N'PS03662', N'NGUYỄN CAO NGỌC LỢI', CAST(0x34160B00 AS Date), 1, N'0930260679', N'PS03662@fpt.edu.vn', N'4.png', N'0930260679 - NGUYỄN CAO NGỌC LỢI', N'PheoNC', CAST(0x34160B00 AS Date)),
(N'PS03674', N'TRẦN TUẤN ANH', CAST(0xF41E0B00 AS Date), 1, N'0914082094', N'PS03674@fpt.edu.vn', N'default.png', N'0914082094 - TRẦN TUẤN ANH', N'PheoNC', CAST(0xF41E0B00 AS Date))
GO

	--table chuyen de
INSERT INTO ChuyenDe VALUES 
(N'JAV01', N'Lập trình Java cơ bản', 250, 90, N'GAME.png', N'JAV01 - Lập trình Java cơ bản'),
(N'JAV02', N'Lập trình Java nâng cao', 300, 90, N'HTCS.jpg', N'JAV02 - Lập trình Java nâng cao'),
(N'JAV03', N'Lập trình mạng với Java', 200, 70, N'INMA.jpg', N'JAV03 - Lập trình mạng với Java'),
(N'JAV04', N'Lập trình desktop với Swing', 200, 70, N'ADAV.jpg', N'JAV04 - Lập trình desktop với Swing'),
(N'PRO01', N'Dự án với công nghệ MS.NET MVC', 300, 90, N'MOWE.png', N'PRO01 - Dự án với công nghệ MS.NET MVC'),
(N'PRO02', N'Dự án với công nghệ Spring MVC', 300, 90, N'Subject.png', N'PRO02 - Dự án với công nghệ Spring MVC'),
(N'PRO03', N'Dự án với công nghệ Servlet/JSP', 300, 90, N'GAME.png', N'PRO03 - Dự án với công nghệ Servlet/JSP'),
(N'PRO04', N'Dự án với AngularJS & WebAPI', 300, 90, N'HTCS.jpg', N'PRO04 - Dự án với AngularJS & WebAPI'),
(N'PRO05', N'Dự án với Swing & JDBC', 300, 90, N'INMA.jpg', N'PRO05 - Dự án với Swing & JDBC'),
(N'PRO06', N'Dự án với WindowForm', 300, 90, N'LAYO.jpg', N'PRO06 - Dự án với WindowForm'),
(N'RDB01', N'Cơ sở dữ liệu SQL Server', 100, 50, N'MOWE.png', N'RDB01 - Cơ sở dữ liệu SQL Server'),
(N'RDB02', N'Lập trình JDBC', 150, 60, N'Subject.png', N'RDB02 - Lập trình JDBC'),
(N'RDB03', N'Lập trình cơ sở dữ liệu Hibernate', 250, 80, N'GAME.png', N'RDB03 - Lập trình cơ sở dữ liệu Hibernate'),
(N'SER01', N'Lập trình web với Servlet/JSP', 350, 100, N'HTCS.jpg', N'SER01 - Lập trình web với Servlet/JSP'),
(N'SER02', N'Lập trình Spring MVC', 400, 110, N'INMA.jpg', N'SER02 - Lập trình Spring MVC'),
(N'SER03', N'Lập trình MS.NET MVC', 400, 110, N'LAYO.jpg', N'SER03 - Lập trình MS.NET MVC'),
(N'SER04', N'Xây dựng Web API với Spring MVC & ASP.NET MVC', 200, 70, N'MOWE.png', N'SER04 - Xây dựng Web API với Spring MVC & ASP.NET MVC'),
(N'WEB01', N'Thiết kế web với HTML và CSS', 200, 70, N'Subject.png', N'WEB01 - Thiết kế web với HTML và CSS'),
(N'WEB02', N'Thiết kế web với Bootstrap', 0, 40, N'GAME.png', N'WEB02 - Thiết kế web với Bootstrap'),
(N'WEB03', N'Lập trình front-end với JavaScript và jQuery', 150, 60, N'HTCS.jpg', N'WEB03 - Lập trình front-end với JavaScript và jQuery'),
(N'WEB04', N'Lập trình AngularJS', 250, 80, N'INMA.jpg', N'WEB04 - Lập trình AngularJS')
GO

	--table Khoa Hoc
INSERT INTO KhoaHoc VALUES 
(N'PRO02', 300, 90, CAST(0xBF3D0B00 AS Date), N'', N'TeoNV', CAST(0xB53D0B00 AS Date)),
(N'JAV04', 300, 90, CAST(0xDF3D0B00 AS Date), N'', N'TeoNV', CAST(0xB53D0B00 AS Date)),
(N'JAV04', 100, 50, CAST(0xFC3D0B00 AS Date), N'', N'TeoNV', CAST(0xB53D0B00 AS Date)),
(N'JAV04', 250, 80, CAST(0x103E0B00 AS Date), N'', N'TeoNV', CAST(0xB53D0B00 AS Date)),
(N'PRO04', 300, 90, CAST(0xD3400B00 AS Date), N'', N'TeoNV', CAST(0xE6400B00 AS Date)),
(N'JAV01', 300, 90, CAST(0xF6400B00 AS Date), N'Lập trình Java cơ bản', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'JAV02', 300, 90, CAST(0xF6400B00 AS Date), N'Lập trình Java nâng cao', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'JAV03', 200, 70, CAST(0xF6400B00 AS Date), N'Lập trình mạng với Java', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'JAV04', 200, 70, CAST(0xF6400B00 AS Date), N'Lập trình ứng dụng Desktop với Java', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'PRO01', 300, 90, CAST(0xF6400B00 AS Date), N'Lập trình .NET MVC', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'PRO02', 300, 90, CAST(0xF6400B00 AS Date), N'Lập trình Spring MVC', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'PRO03', 300, 90, CAST(0xF6400B00 AS Date), N'Làm dự án với Servlet và JSP', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'PRO04', 300, 90, CAST(0xF6400B00 AS Date), N'Làm dự án với REST API và AngularJS', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'JAV01', 300, 90, CAST(0xF4400B00 AS Date), N'Lập trình Java cơ bản', N'TeoNV', CAST(0x0A410B00 AS Date)),
(N'JAV01', 250, 90, CAST(0xF2400B00 AS Date), N'Lập trình Java cơ bản', N'TeoNV', CAST(0x0A410B00 AS Date))
GO

	--table Hoc Vien
INSERT INTO HocVien VALUES
(6, N'PS17588', 9),
(6, N'PS17599', 10),
(2, N'PS01638', 5),
(2, N'PS02988', 3),
(3, N'PS02037', 9),
(3, N'PS02771', 7),
(3, N'PS02867', 2),
(3, N'PS02930', 1),
(1, N'PS01638', 8),
(1, N'PS02037', 9),
(1, N'PS02867', 3),
(1, N'PS02930', 7),
(1, N'PS02771', 8),
(1, N'PS02979', 4),
(1, N'PS02983', 6),
(1, N'PS02988', 0),
(1, N'PS03031', 0),
(1, N'PS03046', 0),
(1, N'PS03080', 0),
(1, N'PS03088', 0),
(1, N'PS03096', 0),
(1, N'PS03104', 0),
(1, N'PS03120', 0),
(1, N'PS03130', 0),
(3, N'PS02983', 5),
(3, N'PS03096', 9),
(3, N'PS03120', 6),
(3, N'PS03046', 7),
(5, N'PS01638', 5),
(5, N'PS02771', 9),
(5, N'PS02037', 0),
(4, N'PS01638', 0),
(4, N'PS03031', 0),
(4, N'PS02979', 0),
(6, N'PS01638', 5),
(6, N'PS02037', 8),
(6, N'PS02771', 9),
(6, N'PS02867', 7),
(6, N'PS02930', 5),
(7, N'PS02930', 5),
(7, N'PS02979', 9),
(7, N'PS02983', 4),
(7, N'PS02988', 0),
(7, N'PS03031', 0),
(7, N'PS03046', 0),
(7, N'PS03080', 0),
(8, N'PS02988', 0),
(8, N'PS03031', 0),
(8, N'PS03046', 0),
(8, N'PS03080', 0),
(8, N'PS03088', 0),
(8, N'PS03096', 0),
(8, N'PS03104', 0),
(8, N'PS03120', 0),
(8, N'PS03130', 0),
(10, N'PS03134', 0),
(10, N'PS03172', 0),
(10, N'PS03202', 0),
(10, N'PS03203', 0),
(10, N'PS03205', 0),
(10, N'PS03222', 0),
(10, N'PS03230', 0),
(10, N'PS03233', 0),
(10, N'PS03251', 0),
(10, N'PS03304', 0),
(10, N'PS03306', 0),
(10, N'PS03308', 0),
(10, N'PS03325', 0),
(10, N'PS03346', 0),
(10, N'PS03383', 0),
(12, N'PS03425', 0),
(12, N'PS03454', 0),
(12, N'PS03472', 0),
(12, N'PS03488', 0),
(12, N'PS03530', 0),
(12, N'PS03553', 0),
(12, N'PS03561', 0),
(12, N'PS03596', 0),
(12, N'PS03603', 0),
(12, N'PS03610', 0),
(12, N'PS03614', 0),
(12, N'PS03618', 0),
(12, N'PS03638', 0),
(12, N'PS03640', 0),
(12, N'PS03662', 0),
(12, N'PS03674', 0),
(5, N'PS03230', 0),
(5, N'PS03233', 0),
(5, N'PS03251', 0),
(5, N'PS03304', 0),
(5, N'PS03306', 0),
(5, N'PS03308', 0),
(5, N'PS03325', 0),
(5, N'PS03346', 0),
(5, N'PS03383', 0),
(5, N'PS03389', 0),
(5, N'PS03410', 0),
(5, N'PS03411', 0),
(13, N'PS01638', 0),
(13, N'PS02037', 0),
(13, N'PS02771', 0),
(13, N'PS02867', 0),
(13, N'PS02930', 0),
(13, N'PS02979', 0),
(13, N'PS02983', 0),
(13, N'PS02988', 0),
(13, N'PS03031', 0),
(13, N'PS03046', 0),
(13, N'PS03080', 0),
(13, N'PS03088', 0),
(14, N'PS02037', 0),
(14, N'PS02771', 0),
(14, N'PS02867', 0),
(14, N'PS02930', 0),
(14, N'PS02979', 0),
(14, N'PS02983', 0),
(14, N'PS02988', 0),
(14, N'PS03031', 0),
(14, N'PS03046', 0),
(14, N'PS03080', 0),
(15, N'PS03088', 5),
(15, N'PS03096', 6),
(15, N'PS03104', 8),
(15, N'PS03120', 2),
(15, N'PS03130', 9),
(15, N'PS03134', 10),
(15, N'PS03172', 10),
(15, N'PS03202', 7),
(6, N'PS03488', 0),
(6, N'PS03553', 0),
(6, N'PS03596', 0),
(6, N'PS03104', 0),
(6, N'PS03411', 0),
(6, N'PS03530', 0),
(14, N'PS03088', 0),
(14, N'PS03104', 0)
GO