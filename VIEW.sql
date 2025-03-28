use QLTRANDAU
go
-- 1 Thông tin cầu thủ đầy đủ
create view vw_ThongTinCauThu as
select 
    c.MaCauThu, 
    c.TenCauThu, 
    c.SoAo, 
    v.TenViTri, 
    d.TenDoiBong
from CAUTHU c 
join VITRI v on c.MaViTri = v.MaViTri 
join DOIBONG d on c.MaDoiBong = d.MaDoiBong;
go
select * from vw_ThongTinCauThu;
go

-- 2 Thống kê các lần thay người
create view vw_ThongKeThaynguoi as
select 
    tn.MaTranDau, 
    td.NgayTranDau, 
    td.DoiDau, 
    c1.TenCauThu as CauThuVao, 
    c2.TenCauThu as CauThuRa, 
    tn.ThoiDiem, 
    db.TenDoiBong 
from THAYNGUOI tn
join TRANDAU td on tn.MaTranDau = td.MaTranDau 
join CAUTHU c1 on tn.MaCauThuVao = c1.MaCauThu 
join CAUTHU c2 on tn.MaCauThuRa = c2.MaCauThu 
join DOIBONG db on c1.MaDoiBong = db.MaDoiBong;
go
select * from vw_ThongKeThaynguoi;
go

-- 3 Thống kê thẻ phạt trong trận đấu
create view vw_ThongKeThePhat as
select 
    tp.MaTranDau, 
    t.NgayTranDau, 
    t.DoiDau, 
    c.TenCauThu, 
    tp.LoaiThe, 
    tp.ThoiDiem, 
    d.TenDoiBong 
from THEPHAT tp 
join TRANDAU t on tp.MaTranDau = t.MaTranDau 
join CAUTHU c on tp.MaCauThu = c.MaCauThu 
join DOIBONG d on c.MaDoiBong = d.MaDoiBong;
go
select * from vw_ThongKeThePhat;
go

-- 4 Thống kê thẻ phạt của cầu thủ
create view vw_ThongKeThePhatCuaCT as
select 
    c.MaCauThu, 
    c.TenCauThu, 
    d.TenDoiBong,
    count(case when tp.LoaiThe = N'Vàng' then 1 end) as SoTheVang,
    count(case when tp.LoaiThe = N'Đỏ' then 1 end) as SoTheDo
from CAUTHU c 
left join THEPHAT tp on c.MaCauThu = tp.MaCauThu 
join DOIBONG d on c.MaDoiBong = d.MaDoiBong 
group by c.MaCauThu, c.TenCauThu, d.TenDoiBong;
go
select * from vw_ThongKeThePhatCuaCT;
go

-- 5 View cầu thủ theo đội bóng
create view vw_CTTheoDB as
select ct.TenCauThu, db.TenDoiBong from CAUTHU ct
join DOIBONG db on ct.MaDoiBong = db.MaDoiBong;
go
select * from vw_CTTheoDB;
go

-- 6 View tổng số bàn thắng của từng cầu thủ
create view vw_TongGBcuaCT as
select ct.TenCauThu, ISNULL(SUM(gb.SoBanThang), 0) AS TongSoBanThang from CAUTHU ct
left join GHIBAN gb on gb.MaCauThu = ct.MaCauThu
group by ct.TenCauThu;
go
select * from vw_TongGBcuaCT;
go

-- 7 Trọng tài điều hành nhiều trận nhất
create view vw_TrongTaiNhieuTranNhat as
with TrongTaiSoTran as (
    select tt.MaTrongTai, tt.TenTrongTai, count(pctt.MaTranDau) as SoTranDieuHanh
    from TRONGTAI tt
    left join PHANCONGTRONGTAI pctt on tt.MaTrongTai = pctt.MaTrongTai
    group by tt.MaTrongTai, tt.TenTrongTai
)
select * from TrongTaiSoTran
where SoTranDieuHanh = (select max(SoTranDieuHanh) from TrongTaiSoTran);
go
select * from vw_TrongTaiNhieuTranNhat;
go

-- 8 View thông tin trận đấu
create view vw_ThongTinTranDau as
select 
    td.MaTranDau,
    td.NgayTranDau,
    td.ThoiGian,
    td.DiaDiem,
    td.DoiDau,
    db.TenDoiBong,
    count(distinct gb.MaCauThu) as SoCauThuGhiBan,
    isnull(sum(gb.SoBanThang), 0) as TongSoBanThang
from TRANDAU td
join DOITHAMGIA dtg on td.MaTranDau = dtg.MaTranDau
join DOIBONG db on dtg.MaDoiBong = db.MaDoiBong
left join GHIBAN gb on td.MaTranDau = gb.MaTranDau
group by 
    td.MaTranDau,
    td.NgayTranDau,
    td.ThoiGian,
    td.DiaDiem,
    td.DoiDau,
    db.TenDoiBong;
go
select * from vw_ThongTinTranDau;
go

-- 9 View thông tin ghi bàn từng trận đấu
create view vw_ThongTinGBTheoTD as
select td.MaTranDau, td.NgayTranDau, td.ThoiGian, td.DiaDiem, td.DoiDau, ct.TenCauThu, ct.SoAo, gb.SoBanThang  from GHIBAN gb
join TRANDAU td on td.MaTranDau = gb.MaTranDau
join CAUTHU ct on ct.MaCauThu = gb.MaCauThu;
go
select * from vw_ThongTinGBTheoTD;
go





