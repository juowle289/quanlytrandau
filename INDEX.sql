
-- 1. Index cầu thủ có số áo từ 1 đến 11
create index IX_CAUTHU_SoAo_1_99 
on CAUTHU(MaCauThu, TenCauThu) 
where SoAo >= 1 AND SoAo <= 99;
go

--2 Index thẻ đỏ
create index IX_THEPHAT_ThangDo 
on THEPHAT(MaCauThu, LoaiThe) 
where LoaiThe = N'Đỏ';
go

-- 3 Index trên NgayTranDau để tìm kiếm và lọc trận đấu theo ngày
create index IX_TRANDAU_NgayTranDau on TRANDAU(NgayTranDau);
go

-- 4 Index kết hợp trên MaTranDau và MaCauThu trong bảng GHIBAN
create index IX_GHIBAN_MaTranDau_MaCauThu on GHIBAN(MaTranDau, MaCauThu);
go

--5 Index trên MaCauThu trong bảng THEPHAT để tìm nhanh thẻ phạt theo cầu thủ
create index IX_THEPHAT_MaCauThu on THEPHAT(MaCauThu);
go

--6. Index trên LoaiThe để lọc nhanh các loại thẻ
create index IX_THEPHAT_LoaiThe on THEPHAT(LoaiThe);
go

-- 7 Index kết hợp trên MaTranDau và ThoiDiem trong bảng THAYNGUOI
create index IX_THAYNGUOI_MaTranDau_ThoiDiem on THAYNGUOI(MaTranDau, ThoiDiem);
go

-- 8 Index kết hợp trên MaCauThuVao, MaCauThuRa trong bảng THAYNGUOI
create index IX_THAYNGUOI_MaCauThuVao_MaCauThuRa on THAYNGUOI(MaCauThuVao, MaCauThuRa);
go

-- 9 Index trên QuocTich trong bảng TRONGTAI
create index IX_TRONGTAI_QuocTich on TRONGTAI(QuocTich);
go

-- 10 Index chỉ các cầu thủ có vị trí tiền đạo
create index IX_CAUTHU_TienDao 
on CAUTHU(MaCauThu, TenCauThu)
where MaViTri = 'TD';
go