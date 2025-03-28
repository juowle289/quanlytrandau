
-- 1. Trigger kiểm tra số áo của cầu thủ
create trigger trg_CheckSoAo
on CAUTHU
after insert, update
as
begin
    if exists (
        select 1 
        from CAUTHU 
        where SoAo in (select SoAo from inserted) 
        group by SoAo 
        having count(*) > 1
    )
    begin
        rollback transaction;
        print N'Số áo không được trùng lặp!';
    end
end;
go

insert into CAUTHU (MaCauThu, TenCauThu, SoAo, MaViTri, MaDoiBong)
values (127, N'CT Trùng SoAo', 1, 'HV', 111);
go

-- 2. Trigger kiểm tra ngày trận đấu
create trigger trg_CheckNgayTranDau
on TRANDAU
after insert, update
as
begin
    if exists (
        select 1 
        from inserted 
        where NgayTranDau < GETDATE()
    )
    begin
        rollback transaction;
        print N'Ngày trận đấu không được trong quá khứ!';
    end
end;
go

INSERT INTO TRANDAU (MaTranDau, NgayTranDau, ThoiGian, DiaDiem, DoiDau) VALUES
(19, '2004-01-05', '21:00', N'Sân vận động Quốc gia Mỹ Đình', 'CAHN vs HANOI');
go

-- 3. Trigger kiểm tra số lượng cầu thủ trong đội
create trigger trg_CheckSoLuongCauThu
on CAUTHU
after insert
as
begin
    if (select count(*) from CAUTHU where MaDoiBong in (select MaDoiBong from inserted)) > 30
    begin
        rollback transaction;
        print N'Số lượng cầu thủ trong đội không được vượt quá 30!';
    end
end;
go

-- 4. Trigger kiểm tra thời điểm thay người
create trigger trg_CheckThoiDiemThayNguoi
on THAYNGUOI
after insert
as
begin
    if exists (
        select 1 
        from THAYNGUOI tn
        join inserted i on tn.MaTranDau = i.MaTranDau and tn.ThoiDiem = i.ThoiDiem
    )
    begin
        rollback transaction;
        print N'Thời điểm thay người không được trùng lặp trong cùng một trận đấu!';
    end
end;
go
INSERT INTO THAYNGUOI (MaTranDau, MaCauThuVao, MaCauThuRa, ThoiDiem) VALUES
(1, 104, 106, '15:10');
go

-- 5. Trigger kiểm tra quốc tịch của trọng tài
create trigger trg_CheckQuocTichTrongTai
on TRONGTAI
after insert, update
as
begin
    if exists (
        select 1 
        from inserted 
        where QuocTich not in ('Việt Nam', 'Thái Lan', 'Malaysia', 'Indonesia')
    )
    begin
        rollback transaction;
        print N'Quốc tịch không hợp lệ!';
    end
end;
go
INSERT INTO TRONGTAI (MaTrongTai, TenTrongTai, QuocTich) VALUES
(213, N'Ktra Qtich TT', N'Hàn Quốc');
go

-- 6. Trigger kiểm tra thông tin cầu thủ
create trigger trg_CheckThongTinCauThu
on CAUTHU
after insert, update
as
begin
    if exists (
        select 1 
        from inserted 
        where TenCauThu is NULL or SoAo is NULL
    )
    begin
        rollback transaction;
        print N'Thông tin cầu thủ không được để trống!';
    end
end;
go
INSERT INTO CAUTHU (MaCauThu, TenCauThu, SoAo, MaViTri, MaDoiBong) VALUES
(133, N'Lê Tiến Được', NULL, 'TM', 111);
go

-- 7. Trigger Kiểm tra số lượng thẻ phạt của cầu thủ
create trigger trg_CheckSoLuongThePhat
on THEPHAT
after insert, update
as
begin
    -- Kiểm tra nếu cầu thủ nhận quá 2 thẻ vàng trong một trận đấu
    if exists (
        select MaCauThu, MaTranDau
        from THEPHAT
        where LoaiThe = N'Vàng'
        group by MaCauThu, MaTranDau
        having count(*) > 2
    )
    begin
        rollback transaction;
        print N'Một cầu thủ không thể nhận quá 2 thẻ vàng trong một trận đấu!';
        return;
    end

    -- Kiểm tra nếu cầu thủ nhận quá 1 thẻ đỏ trong một trận đấu
    if exists (
        select MaCauThu, MaTranDau
        from THEPHAT
        where LoaiThe = N'Đỏ'
        group by MaCauThu, MaTranDau
        having count(*) > 1
    )
    begin
        rollback transaction;
        print N'Một cầu thủ không thể nhận quá 1 thẻ đỏ trong một trận đấu!';
        return;
    end
end;
go
INSERT INTO THEPHAT (MaTranDau, MaCauThu, LoaiThe, ThoiDiem) VALUES
(1, 102, N'Đỏ', '16:01')