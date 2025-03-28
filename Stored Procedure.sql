
-- 1 Lấy danh sách tất cả cầu thủ
create proc sp_DsachCT as
begin
	select * from CAUTHU;
end;
go
exec sp_DsachCT;
go

-- 2. Lấy top 5 cầu thủ ghi nhiều bàn thắng nhất
create procedure sp_Top5CauThuGhiBan
as
begin
    select top 5 
        ct.MaCauThu, 
        ct.TenCauThu, 
        db.TenDoiBong, 
        sum(gb.SoBanThang) as TongSoBanThang
    from CAUTHU ct 
    join GHIBAN gb on ct.MaCauThu = gb.MaCauThu 
    join DOIBONG db on ct.MaDoiBong = db.MaDoiBong 
    group by ct.MaCauThu, ct.TenCauThu, db.TenDoiBong 
    order by TongSoBanThang desc;
end;
go
exec sp_Top5CauThuGhiBan;
go

-- 3 Lấy cầu thủ theo đội bóng
create proc sp_CTtheoDB
	@MaDoiBong int
as
begin
	select * from CAUTHU where MaDoiBong = @MaDoiBong;	
end;
go
exec sp_CTtheoDB @MaDoiBong = 333;
go

-- 4 Lấy tổng số bàn thắng của một cầu thủ
create proc sp_TongSoBanThangCuaCT
	@MaCauThu INT,
	@TongSoBanThang INT OUTPUT
as
begin
	select @TongSoBanThang = SUM(SoBanThang) from GHIBAN
	where MaCauThu = @MaCauThu;
end;
go
declare @TongSoBanThang int;

exec sp_TongSoBanThangCuaCT 
    @MaCauThu = 115, 
    @TongSoBanThang = @TongSoBanThang output;

print N'Tổng số bàn thắng của cầu thủ có mã 115 là: ' + CAST(@TongSoBanThang AS NVARCHAR(10));
go

-- 5 Cập nhật thông tin thay người
create procedure sp_CapNhatThongTinTN
    @Matrandau INT,
    @Macauthura INT,
    @Macauthuvao INT,
    @Thoidiem DATETIME
as
begin
    update THAYNGUOI
    set
        Macauthura = @Macauthura, 
        Macauthuvao = @Macauthuvao, 
        Thoidiem = @Thoidiem
    where Matrandau = @Matrandau;
end;
go
EXEC sp_CapNhatThongTinTN
    @MaTranDau = 2,
    @MaCauThuRa = 103,
    @MaCauThuVao = 107,
    @ThoiDiem = '2023-10-01 21:05:00';
select * from THAYNGUOI
go

-- 6 Lấy cầu thủ theo vị trí
create proc sp_CTTheoVT
	@MaViTri varchar(2)
as
begin
	select * from CAUTHU where MaViTri = @MaViTri;
end;
go
exec sp_CTTheoVT @MaViTri = 'TV';
go

-- 7 Tìm trận đấu trong khoảng thời gian
create proc sp_TDTrongKhoangThoiGian
	@StartDate DATE,
	@EndDate DATE
as
begin
	select * from TRANDAU
	where NgayTranDau BETWEEN @StartDate AND @EndDate;
end;
go
exec sp_TDTrongKhoangThoiGian 
	@StartDate = '2024-01-01',
	@EndDate = '2024-01-31';
go

-- 8 Cập nhật thông tin cầu thủ
create proc sp_CapNhatThongTinCT
	@MaCauThu int,
	@TenCauThu nvarchar(100),
	@SoAo int,
	@MaViTri varchar(2),
	@MaDoiBong int
as
begin
	update CAUTHU
	set TenCauThu = @TenCauThu,
		SoAo = @SoAo,
		MaViTri = @MaViTri,
		MaDoiBong = @MaDoiBong
	where MaCauThu = @MaCauThu;
end;
go
exec sp_CapNhatThongTinCT
    @MaCauThu = 109, 
    @TenCauThu = N'Nguyễn Văn Toàn',
    @SoAo = 2,
    @MaViTri = 'TV',
    @MaDoiBong = 333;
select * from CAUTHU where MaCauThu = 109;
go

-- 19 Danh sách thẻ phạt theo loại
create procedure sp_DsachThePhatTheoLoai
    @LoaiThe nvarchar(10)
as
begin
    select * 
    from THEPHAT 
    where LoaiThe = @LoaiThe;
end
go
exec sp_DsachThePhatTheoLoai @LoaiThe = 'Vàng';
go

