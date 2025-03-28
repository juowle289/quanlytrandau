--Truy vấn 1: Liệt kê tất cả các đội bóng 
select * from DOIBONG;
--Truy vấn 2: Liệt kê tất cả các cầu thủ, kèm thông tin về đội bóng và vị trí
select c.MaCauThu, c.TenCauThu, c.SoAo, v.TenViTri, d.TenDoiBong
from CAUTHU c
join VITRI v on c.MaViTri = v.MaViTri
join DOIBONG d on c.MaDoiBong = d.MaDoiBong;
--Truy vấn 3: Liệt kê tất cả các trận đấu và đội tham gia
select t.MaTranDau, t.NgayTranDau, t.ThoiGian, t.DiaDiem, t.DoiDau, d.TenDoiBong
from TRANDAU t
join DOITHAMGIA dt on t.MaTranDau = dt.MaTranDau
join DOIBONG d on dt.MaDoiBong = d.MaDoiBong
order by t.NgayTranDau;	

/*Truy vấn INSERT*/
--Truy vấn 1: Thêm một đội bóng mới
insert into DOIBONG (MaDoiBong, TenDoiBong)
values (1010, N'shb đà nẵng');
--Truy vấn 2: Thêm một cầu thủ mới
insert into CAUTHU (MaCauThu, TenCauThu, SoAo, MaViTri, MaDoiBong)
values (127, N'nguyễn văn nam', 7, 'td', 1010);
--Truy vấn 3: Thêm một trận đấu mới
insert into TRANDAU (MaTranDau, NgayTranDau, ThoiGian, DiaDiem, DoiDau)
values (13, '2024-03-29', '19:00', N'sân vận động hòa xuân', 'shbdn vs hagl');


--Truy vấn UPDATE
--Truy vấn 1: Cập nhật tên đội bóng
update DOIBONG
set TenDoiBong = N'shb đà nẵng fc'
where MaDoiBong = 1010;
--Truy vấn 2: Cập nhật số áo của cầu thủ
update CAUTHU
set SoAo = 99
where MaCauThu = 127;
--Truy vấn 3: Cập nhật thời gian trận đấu
update TRANDAU
set ThoiGian = '19:30'
where
 MaTranDau = 13;


--Truy vấn DELETE
--Truy vấn 1: Xóa một trận đấu
delete from TRANDAU
where MaTranDau = 13;

--Truy vấn 2: Xóa một cầu thủ
delete from CAUTHU
where MaCauThu = 127;

--Truy vấn 3: Xóa một đội bóng
delete from DOIBONG
where MaDoiBong = 1010;

--Truy vấn nâng cao
-- Truy vấn INNER JOIN
--Truy vấn 1: Liệt kê tất cả các bàn thắng kèm thông tin cầu thủ và trận đấu
select g.MaTranDau, t.NgayTranDau, t.DoiDau, c.TenCauThu, d.TenDoiBong, g.SoBanThang
from GHIBAN g
inner join TRANDAU t on g.MaTranDau = t.MaTranDau
inner join CAUTHU c on g.MaCauThu = c.MaCauThu
inner join DOIBONG d on c.MaDoiBong = d.MaDoiBong
order by t.NgayTranDau;
--Truy vấn 2: Liệt kê tất cả các thẻ phạt kèm thông tin cầu thủ và trận đấu
select tp.MaThePhat, t.MaTranDau, t.NgayTranDau, t.DoiDau, c.TenCauThu, d.TenDoiBong, tp.LoaiThe, tp.ThoiDiem
from THEPHAT tp
inner join TRANDAU t on tp.MaTranDau = t.MaTranDau
inner join CAUTHU c on tp.MaCauThu = c.MaCauThu
inner join DOIBONG d on c.MaDoiBong = d.MaDoiBong
order by t.NgayTranDau;

-- Truy vấn GROUP BY và HAVING
--Truy vấn 1: Thống kê số bàn thắng của mỗi cầu thủ
select c.MaCauThu, c.TenCauThu, d.TenDoiBong, sum(g.SoBanThang) as TongSoBanThang
from CAUTHU c
inner join GHIBAN g on c.MaCauThu = g.MaCauThu
inner join DOIBONG d on c.MaDoiBong = d.MaDoiBong
group by c.MaCauThu, c.TenCauThu, d.TenDoiBong
having sum(g.SoBanThang) > 0
order by TongSoBanThang desc;
--Truy vấn 2: Thống kê số thẻ phạt của mỗi đội bóng
select d.MaDoiBong, d.TenDoiBong, 
       count(case when tp.LoaiThe = N'vàng' then 1 end) as SoTheVang,
       count(case when tp.LoaiThe = N'đỏ' then 1 end) as SoTheDo
from DOIBONG d
inner join CAUTHU c on d.MaDoiBong = c.MaDoiBong
inner join THEPHAT tp on c.MaCauThu = tp.MaCauThu
group by d.MaDoiBong, d.TenDoiBong
order by SoTheVang desc, SoTheDo desc;

--Truy vấn SUBQUERY
--Truy vấn 1: Liệt kê các cầu thủ chưa từng ghi bàn
select c.MaCauThu, c.TenCauThu, d.TenDoiBong
from CAUTHU c
inner join DOIBONG d on c.MaDoiBong = d.MaDoiBong
where c.MaCauThu not in (
select distinct MaCauThu from GHIBAN where SoBanThang > 0
);
--Truy vấn 2: Liệt kê các đội bóng có cầu thủ nhận thẻ đỏ
select distinct d.MaDoiBong, d.TenDoiBong
from DOIBONG d
where d.MaDoiBong in (
    select distinct c.MaDoiBong
    from CAUTHU c
    inner join THEPHAT tp on c.MaCauThu = tp.MaCauThu
    where tp.LoaiThe = N'đỏ'
);


 select * from DOIBONG;
 select * from TRANDAU
 select * from CAUTHU