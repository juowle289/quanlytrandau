USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QLTRANDAU')
    DROP DATABASE QLTRANDAU;
GO
CREATE DATABASE QLTRANDAU;
GO
USE QLTRANDAU;
GO

-- Xóa bảng Thay người
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'THAYNGUOI')
BEGIN
    DROP TABLE THAYNGUOI;
END

-- Xóa bảng Thẻ phạt
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'THEPHAT')
BEGIN
    DROP TABLE THEPHAT;
END

-- Xóa bảng Phân công trọng tài cho trận đấu
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PHANCONGTRONGTAI')
BEGIN
    DROP TABLE PHANCONGTRONGTAI;
END

-- Xóa bảng Trọng tài
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TRONGTAI')
BEGIN
    DROP TABLE TRONGTAI;
END

-- Xóa bảng Ghi bàn
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GHIBAN')
BEGIN
    DROP TABLE GHIBAN;
END

-- Xóa bảng Đội tham gia trận đấu
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DOITHAMGIA')
BEGIN
    DROP TABLE DOITHAMGIA;
END

-- Xóa bảng Trận đấu
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TRANDAU')
BEGIN
    DROP TABLE TRANDAU;
END

-- Xóa bảng Cầu thủ
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CAUTHU')
BEGIN
    DROP TABLE CAUTHU;
END

-- Xóa bảng Vị trí chơi
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VITRI')
BEGIN
    DROP TABLE VITRI;
END

-- Xóa bảng Đội bóng
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DOIBONG')
BEGIN
    DROP TABLE DOIBONG;
END

-- Tạo bảng Đội bóng
CREATE TABLE DOIBONG (
    MaDoiBong INT PRIMARY KEY,
    TenDoiBong NVARCHAR(100) NOT NULL
);
GO

-- Tạo bảng Vị trí chơi
CREATE TABLE VITRI (
    MaViTri VARCHAR(2) PRIMARY KEY,
    TenViTri NVARCHAR(50) NOT NULL
);
GO

-- Tạo bảng Cầu thủ
CREATE TABLE CAUTHU (
    MaCauThu INT PRIMARY KEY,
    TenCauThu NVARCHAR(100) NOT NULL,
    SoAo INT,
    MaViTri VARCHAR(2) NOT NULL,
    MaDoiBong INT NOT NULL,
    FOREIGN KEY (MaViTri) REFERENCES VITRI(MaViTri),
    FOREIGN KEY (MaDoiBong) REFERENCES DOIBONG(MaDoiBong)
);
GO

-- Tạo bảng Trận đấu
CREATE TABLE TRANDAU (
    MaTranDau INT PRIMARY KEY,
    NgayTranDau DATE NOT NULL,
	ThoiGian TIME NOT NULL,
    DiaDiem NVARCHAR(100) NOT NULL,
    DoiDau NVARCHAR(100) NOT NULL
);
GO

-- Tạo bảng Đội tham gia trận đấu
CREATE TABLE DOITHAMGIA (
    MaTranDau INT,
    MaDoiBong INT,
    PRIMARY KEY (MaTranDau, MaDoiBong),
    FOREIGN KEY (MaTranDau) REFERENCES TRANDAU(MaTranDau),
    FOREIGN KEY (MaDoiBong) REFERENCES DOIBONG(MaDoiBong)
);
GO

-- Tạo bảng Ghi bàn
CREATE TABLE GHIBAN (
    MaTranDau INT,
    MaCauThu INT,
    SoBanThang INT CHECK (SoBanThang >= 0),
    PRIMARY KEY (MaTranDau, MaCauThu),
    FOREIGN KEY (MaTranDau) REFERENCES TRANDAU(MaTranDau),
    FOREIGN KEY (MaCauThu) REFERENCES CAUTHU(MaCauThu)
);
GO

-- Tạo bảng Trọng tài
CREATE TABLE TRONGTAI (
    MaTrongTai INT PRIMARY KEY,
    TenTrongTai NVARCHAR(100) NOT NULL,
    QuocTich NVARCHAR(50) NOT NULL
);
GO

-- Tạo bảng Phân công trọng tài cho trận đấu
CREATE TABLE PHANCONGTRONGTAI (
    MaTranDau INT,
    MaTrongTai INT,
    VaiTro NVARCHAR(50) NOT NULL, -- Trọng tài chính, biên, góc
    PRIMARY KEY (MaTranDau, MaTrongTai),
    FOREIGN KEY (MaTranDau) REFERENCES TRANDAU(MaTranDau),
    FOREIGN KEY (MaTrongTai) REFERENCES TRONGTAI(MaTrongTai)
);
GO

-- Tạo bảng Thẻ phạt
CREATE TABLE THEPHAT (
    MaThePhat INT PRIMARY KEY IDENTITY(1,1),
    MaTranDau INT NOT NULL,
    MaCauThu INT NOT NULL,
    LoaiThe NVARCHAR(10) CHECK (LoaiThe IN (N'Vàng', N'Đỏ')) NOT NULL,
    ThoiDiem TIME NOT NULL,
    FOREIGN KEY (MaTranDau) REFERENCES TRANDAU(MaTranDau),
    FOREIGN KEY (MaCauThu) REFERENCES CAUTHU(MaCauThu)
);
GO

-- Tạo bảng Thay người
CREATE TABLE THAYNGUOI (
    MaThayNguoi INT PRIMARY KEY IDENTITY(1,1),
    MaTranDau INT NOT NULL,
    MaCauThuVao INT NOT NULL,
    MaCauThuRa INT NOT NULL,
    ThoiDiem TIME NOT NULL,
    FOREIGN KEY (MaTranDau) REFERENCES TRANDAU(MaTranDau),
    FOREIGN KEY (MaCauThuVao) REFERENCES CAUTHU(MaCauThu),
    FOREIGN KEY (MaCauThuRa) REFERENCES CAUTHU(MaCauThu)
);
GO
-- Chèn dữ liệu mẫu vào bảng Đội bóng
INSERT INTO DOIBONG (MaDoiBong, TenDoiBong) VALUES
(111, N'Công an Hà Nội'),
(222, N'Hà Nội'),
(333, N'Thép Xanh Nam Định'),
(444, N'Thể Công-Viettel'),
(555, N'Hoàng Anh Gia Lai'),
(666, N'Becamex Bình Dương'),
(777, N'Phù Đổng Ninh Bình'),
(888, N'Hải Phòng'),
(999, N'Đông Á Thanh Hoá');
GO

-- Chèn dữ liệu mẫu vào bảng Vị trí chơi
INSERT INTO VITRI (MaViTri, TenViTri) VALUES
('TM', N'Thủ môn'),
('HV', N'Hậu vệ'),
('TV', N'Trung vệ'),
('TD', N'Tiền đạo');
GO

-- Chèn dữ liệu mẫu vào bảng Cầu thủ
INSERT INTO CAUTHU (MaCauThu, TenCauThu, SoAo, MaViTri, MaDoiBong) VALUES
(101, N'Nguyễn Filip', 1, 'TM', 111),
(102, N'Đỗ Duy Mạnh', 2, 'HV', 222),
(103, N'Nguyễn Văn Vĩ', 3, 'HV', 333),
(104, N'Bùi Tiến Dũng', 4, 'HV', 444),
(105, N'Trương Tiến Anh', 5, 'HV', 444),
(106, N'Nguyễn Thanh Bình', 6, 'HV', 444),
(107, N'Phạm Xuân Mạnh', 7, 'HV', 222),
(108, N'Châu Ngọc Quang', 8, 'TV', 555),
(109, N'Nguyễn Văn Toàn', 9, 'TD', 333),
(110, N'Phạm Tuấn Hải', 10, 'TD', 222),
(111, N'Lê Phạm Thành Long', 11, 'TV', 111),
(112, N'Nguyễn Xuân Son', 12, 'TD', 333),
(113, N'Hồ Tấn Tài', 13, 'HV', 666),
(114, N'Nguyễn Hoàng Đức', 14, 'TV', 777),
(115, N'Bùi Vĩ Hào', 15, 'TD', 666),
(116, N'Nguyễn Thành Chung', 16, 'HV', 222),
(117, N'Vũ Văn Thanh', 17, 'HV', 111),
(118, N'Đinh Thanh Bình', 18, 'TD', 777),
(119, N'Nguyễn Quang Hải', 19, 'TV', 111),
(120, N'Bùi Hoàng Việt Anh', 20, 'HV', 111),
(121, N'Nguyễn Đình Triệu', 21, 'TM', 888),
(122, N'Nguyễn Tiến Linh', 22, 'TD', 666),
(123, N'Trần Trung Kiên', 23, 'TM', 555),
(124, N'Nguyễn Hai Long', 24, 'TV', 222),
(125, N'Doãn Ngọc Tân', 25, 'TV', 999),
(126, N'Khuất Văn Khang', 26, 'TV', 444);
GO

-- Chèn dữ liệu mẫu vào bảng Trận đấu
INSERT INTO TRANDAU (MaTranDau, NgayTranDau, ThoiGian, DiaDiem, DoiDau) VALUES
(1, '2024-01-05', '15:00', N'Sân vận động Quốc gia Mỹ Đình', 'CAHN vs HANOI'),
(2, '2024-01-12', '20:00', N'Sân vận động Lạch Tray', 'TXND vs VTL'),
(3, '2024-01-19', '13:00', N'Sân vận động Hàng Đẫy', 'HAGL vs BBD'),
(4, '2024-01-26', '14:00', N'Sân vận động Việt Trì', 'PDNB vs HP'),
(5, '2024-02-02', '15:00', N'Sân vận động Thống Nhất', 'DAT vs VTL'),
(6, '2024-02-09', '22:00', N'Sân vận động Quốc gia Mỹ Đình', 'CAHN vs HANOI'),
(7, '2024-02-16', '19:00', N'Sân vận động Lạch Tray', 'TXND vs VTL'),
(8, '2024-02-23', '19:30', N'Sân vận động Hàng Đẫy', 'HAGL vs BBD'),
(9, '2024-03-01', '15:40', N'Sân vận động Việt Trì', 'PDNB vs HP'),
(10, '2024-03-08', '14:30', N'Sân vận động Thống Nhất', 'DAT vs VTL'),
(11, '2024-03-15', '20:30', N'Sân vận động Quốc gia Mỹ Đình', 'CAHN vs HANOI'),
(12, '2024-03-22', '22:10', 'Sân vận động Lạch Tray', 'TXND vs VTL');
GO

-- Chèn dữ liệu mẫu vào bảng Đội tham gia
INSERT INTO DOITHAMGIA (MaTranDau, MaDoiBong) VALUES
(1, 111),
(1, 222),
(2, 333),
(2, 444),
(3, 555),
(3, 666),
(4, 777),
(4, 888),
(5, 999),
(5, 444);
GO

-- Chèn dữ liệu mẫu vào bảng Ghi bàn
INSERT INTO GHIBAN (MaCauThu, MaTranDau, SoBanThang) VALUES
(110, 2, 1),  -- Phạm Tuấn Hải ghi		1 bàn thắng trận 2
(109, 3, 2),  -- Nguyễn Văn Toàn ghi	2 bàn thắng trận 3
(112, 4, 1),  -- Nguyễn Xuân Son ghi	1 bàn thắng trận 4
(122, 5, 1),  -- Nguyễn Tiến Linh ghi	1 bàn thắng trận 5
(117, 6, 1),  -- Vũ Văn Thanh ghi		1 bàn thắng trận 6
(115, 7, 1),  -- Bùi Vĩ Hào ghi			1 bàn thắng trận 7
(114, 8, 2),  -- Nguyễn Hoàng Đức ghi	2 bàn thắng trận 8
(119, 9, 1),  -- Nguyễn Quang Hải ghi	1 bàn thắng trận 9
(118, 10, 1), -- Đinh Thanh Bình ghi	1 bàn thắng trận 10
(116, 11, 1), -- Nguyễn Thành Chung ghi 1 bàn thắng trận 11
(113, 12, 0); -- Hồ Tấn Tài ghi			0 bàn thắng trận 12
GO

-- Chèn dữ liệu vào bảng TRONGTAI
INSERT INTO TRONGTAI (MaTrongTai, TenTrongTai, QuocTich) VALUES
(201, N'Nguyễn Văn An', N'Việt Nam'),
(202, N'Trần Thị Bình', N'Việt Nam'),
(203, N'Lê Văn Cường', N'Việt Nam'),
(204, N'Phạm Thị Duyên', N'Việt Nam'),
(205, N'Nguyễn Hoàng Hải', N'Việt Nam'),
(206, N'Trần Minh Hòa', N'Việt Nam'),
(207, N'John Smith', N'Mỹ'),
(208, N'Anna Johnson', N'Anh'),
(209, N'Carlos Garcia', N'Tây Ban Nha'),
(210, N'Sofia Martinez', N'Argentina'),
(211, N'Yuki Tanaka', N'Nhật Bản'),
(212, N'Fatima Al-Farsi', N'Oman');
GO

-- Chèn dữ liệu vào bảng PHANCONGTRONGTAI với vai trò mới
INSERT INTO PHANCONGTRONGTAI (MaTranDau, MaTrongTai, VaiTro) VALUES
(1, 201, N'Trọng tài chính'),
(1, 202, N'Trọng tài biên'),
(1, 203, N'Trọng tài góc'),
(2, 201, N'Trọng tài chính'),
(2, 205, N'Trọng tài biên'),
(2, 206, N'Trọng tài góc'),
(3, 207, N'Trọng tài chính'),
(3, 208, N'Trọng tài biên'),
(3, 209, N'Trọng tài góc'),
(4, 210, N'Trọng tài chính'),
(4, 211, N'Trọng tài biên'),
(4, 212, N'Trọng tài góc');
GO



INSERT INTO THAYNGUOI (MaTranDau, MaCauThuVao, MaCauThuRa, ThoiDiem) VALUES
(1, 101, 102, '15:10'),
(1, 103, 104, '15:20'),
(2, 105, 106, '20:05'),
(2, 107, 108, '20:30'),
(3, 109, 110, '13:10'),
(3, 111, 112, '13:40'),
(4, 113, 114, '14:10'),
(4, 115, 116, '14:20'),
(5, 117, 118, '15:05'),
(5, 119, 120, '15:15'),
(6, 121, 122, '22:00'),
(6, 123, 124, '22:20');
GO

INSERT INTO THEPHAT (MaTranDau, MaCauThu, LoaiThe, ThoiDiem) VALUES
(1, 101, N'Vàng', '15:30'),
(1, 102, N'Đỏ', '16:00'),
(2, 103, N'Vàng', '20:15'),
(2, 104, N'Vàng', '20:45'),
(3, 105, N'Đỏ', '13:30'),
(3, 106, N'Vàng', '14:00'),
(4, 107, N'Vàng', '14:30'),
(4, 108, N'Đỏ', '15:00'),
(5, 109, N'Vàng', '15:15'),
(5, 110, N'Vàng', '15:45'),
(6, 111, N'Đỏ', '22:05'),
(6, 112, N'Vàng', '22:15');
GO