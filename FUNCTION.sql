
-- 1.1 Hàm trả về kiểu vô hướng: Tính tổng số bàn thắng của một cầu thủ
create function TongGBcuaCT (@MaCauThu int)
returns int
as
begin
	declare @TongBanThang int;
	select @TongBanThang = SUM(SoBanThang) from GHIBAN

	return ISNULL(@TongBanThang, 0);
end;
go
select dbo.TongGBcuaCT(116) as TongBanThangCuaCT;
go

-- 1.2 Hàm lấy tên đội bóng theo mã đội
create function TenDoiBongTheoMaDoi(@MaDoiBong int)
returns nvarchar(100)
as
begin
	declare @TenDoiBong nvarchar(100);
	select @TenDoiBong = TenDoiBong from DOIBONG 
	where MaDoiBong = @MaDoiBong
	return @TenDoiBong;
end;
go
declare @MaDoiBong int = 333;
declare @TenDoiBong nvarchar(100);
set @TenDoiBong = dbo.TenDoiBongTheoMaDoi(@MaDoiBong);
select @TenDoiBong as TenDoiBong;
go

-- 1.3 Tính số thẻ phạt của một cầu thủ
create function dbo.fn_SoThePhat(@MaCauThu int)
returns int
as
begin
    declare @SoThePhat int;
    select @SoThePhat = count(*) from THEPHAT where MaCauThu = @MaCauThu;
    return isnull(@SoThePhat, 0);
end;
go
-- 1.4 Hàm lấy vị trí chơi của cầu thủ
create function VTcuaCT (@MaCauThu int)
returns nvarchar(50)
as
begin
	declare @TenViTri nvarchar(50)
	select @TenViTri = TenViTri from VITRI 
	where MaViTri = (select MaViTri from CAUTHU
						where MaCauThu = @MaCauThu)

	return @TenViTri;
end;
go
declare @MaCauThu int = 123; 
declare @TenViTri nvarchar(50);
set @TenViTri = dbo.VTcuaCT(@MaCauThu);
select @TenViTri as ViTriCauThu;
go
 

-- 2.1 Tạo hàm trả về kiểu bảng: Lấy danh sách cầu thủ theo đội bóng
create function DsachCTTheoDB(@MaDoiBong int)
returns table
as
return(
	select
		MaCauThu,
		TenCauThu,
		SoAo,
		MaViTri
	from CAUTHU
	where MaDoiBong = @MaDoiBong
);
go
select * from dbo.DsachCTTheoDB(333) as DanhSachCTTheoDoiBong;
go

-- 2.2 Hàm lấy danh sách cầu thủ ghi bàn nhiều nhất theo đội bóng
create function DsachCTGBNhieuNhatTheoDB(@MaDoiBong int)
returns table
as
return (
	select 
		ct.MaCauThu, 
		ct.TenCauThu, 
		ct.SoAo, 
		db.TenDoiBong, 
		SUM(gb.SoBanThang) as TongSoBanThang 
	from CAUTHU ct
	join DOIBONG db on db.MaDoiBong = ct.MaDoiBong
	left join GHIBAN gb on gb.MaCauThu = ct.MaCauThu
	where ct.MaDoiBong = @MaDoiBong
	group by ct.MaCauThu, ct.TenCauThu, ct.SoAo, db.TenDoiBong
	having SUM(gb.SoBanThang)>0
);
go
select * from DsachCTGBNhieuNhatTheoDB(333) as DsachCTGBNhieuNhatTheoDB
order by TongSoBanThang DESC;
go

-- 2.3 Hàm lấy danh sách cầu thủ ghi bàn theo khoảng thời gian
create function DsachCTGBTheoThoiGian 
	(@StartDate DATE, @EndDate DATE)
returns table
as
return (
	select 
		ct.MaCauThu, 
		ct.TenCauThu, 
		SUM(gb.SoBanThang) as TongSoBanThang,
		td.DoiDau
	from CAUTHU ct
	join GHIBAN gb on gb.MaCauThu = ct.MaCauThu
	join TRANDAU td on td.MaTranDau = gb.MaTranDau
	where td.NgayTranDau between @StartDate and @EndDate
	group by ct.MaCauThu, ct.TenCauThu, td.DoiDau
);
go
select * from DsachCTGBTheoThoiGian('2024-01-01', '2024-02-02');
go

--2.4 Hàm lấy danh sách đội bóng có số bàn thắng tối thiểu
create function DsachDBGBHon2Ban(@BanThangMin int)
returns table
as
return (
	select 
		db.MaDoiBong,
		db.TenDoiBong,
		SUM(gb.SoBanThang) SoBanThang
	from DOIBONG db
	join CAUTHU ct on ct.MaDoiBong = db.MaDoiBong
	join GHIBAN gb on ct.MaCauThu = gb.MaCauThu
	group by db.TenDoiBong, db.MaDoiBong
	having SUM(gb.SoBanThang) > @BanThangMin
);
go
select * from DsachDBGBHon2Ban(2);
go

-- 3.1 Hàm lấy danh sách cầu thủ chưa ghi bàn
create function DsachCTChuaGB()
returns table
as
return(
	select ct.* from CAUTHU ct
	where ct.MaCauThu not in (select distinct MaCauThu from GHIBAN)
);
go
select * from DsachCTChuaGB();
go

-- 3.2 Lấy danh sách các đội bóng có cầu thủ nhận thẻ đỏ
create function DoiBongCoThePhatDo()
returns table
as
return (
    select db.TenDoiBong from DOIBONG db
	join CAUTHU ct on ct.MaCauThu = db.MaDoiBong
	join THEPHAT tp on tp.MaCauThu = ct.MaCauThu
	where LoaiThe = N'Đỏ'
);
go
select * from DoiBongCoThePhatDo();
go

