Use master;
go

-- ======================================
-- 1. TẠO NGƯỜI DÙNG
-- ======================================

-- Tạo login cho quản trị viên
if not exists (select * from sys.server_principals where name = 'AdminQLD')
    create login AdminQLD with password = 'Admin@2025', default_database = QLTRANDAU;
go

-- Tạo login cho người dùng quản lý đội bóng
if not exists (select * from sys.server_principals where name = 'QlyDoibong')
    create login QlyDoibong with password = 'qldb@2025', default_database = QLTRANDAU;
go

-- Tạo login cho người quản lý trận đấu
if not exists (select * from sys.server_principals where name = 'QlyTrandau')
    create login QlyTrandau with password = 'qltd@2025', default_database = QLTRANDAU;
go

-- Tạo login cho người dùng chỉ có quyền đọc dữ liệu
if not exists (select * from sys.server_principals where name = 'Reporter')
    create login Reporter with password = 'rpt@2025', default_database = QLTRANDAU;
go

USE QLTRANDAU;
go

-- Tạo user từ login
if not exists (select * from sys.server_principals where name = 'AdminQLD')
	create USER AdminQLD for LOGIN AdminQLD;
go

if not exists (select * from sys.server_principals where name = 'QlyDoibong')
	create USER QlyDoibong for LOGIN QlyDoibong;
go

if not exists (select * from sys.server_principals where name = 'QlyTrandau')
	create USER QlyTrandau for LOGIN QlyTrandau;
go

if not exists (select * from sys.server_principals where name = 'QlyDoibong')
	create USER Reporter for LOGIN AdminQLD;
go
    
-- =============================================
-- 2. THIẾT LẬP QUYỀN TRUY CẬP VÀ PHÂN QUYỀN
-- =============================================


-- Tạo vai trò (role) cho các nhóm người dùng
if not exists (select * from sys.server_principals where name = 'ReporterROLE')
	create ROLE ReporterROLE;
go

if not exists (select * from sys.server_principals where name = 'QlyTrandauROLE')
	create ROLE QlyTrandauROLE;
go

if not exists (select * from sys.server_principals where name = 'QlyDoibongROLE')
	create ROLE QlyDoibongROLE;
go

-- Them USER vao ROLE
ALTER ROLE ReporterROLE ADD MEMBER Reporter;
ALTER ROLE QlyTrandauROLE ADD MEMBER QlyTrandau;
ALTER ROLE QlyDoibongROLE ADD MEMBER QlyDoibong;
go

-- Phân quyền cho vai trò quản lý đội bóng
GRANT select, insert, update, delete on DOIBONG to QlyDoibongROLE;
GRANT select, insert, update, delete on VITRI to QlyDoibongROLE;
GRANT select, insert, update, delete on CAUTHU to QlyDoibongROLE;
go

-- Phân quyền cho vai trò quản lý trận đấu
GRANT select, insert, update, delete on TRANDAU to QlyTrandau;
GRANT select, insert, update, delete on DOITHAMGIA to QlyTrandau;
GRANT select, insert, update, delete on GHIBAN to QlyTrandau;
GRANT select, insert, update, delete on TRANDAU to QlyTrandau;
GRANT select, insert, update, delete on TRONGTAI to QlyTrandau;
GRANT select, insert, update, delete on PHANCONGTRONGTAI to QlyTrandau;
GRANT select, insert, update, delete on THEPHAT to QlyTrandau;
GRANT select, insert, update, delete on THAYNGUOI to QlyTrandau;
GRANT select on DOIBONG to QlyTrandau;
GRANT select on CAUTHU to QlyTrandau;
go

GRANT select on schema::dbo to ReporterROLE;
go

-- Cấp quyền db_owner cho AdminQLD trong database QLTRANDAU
exec sp_addrolemember 'db_owner', 'AdminQLD';
go

-- =============================================
-- 3. QUẢN LÝ SAO LƯU VÀ PHỤC HỒI DỮ LIỆU
-- =============================================

-- Script để sao lưu đầy đủ database (Full backup)
BACKUP DATABASE QLTRANDAU
to disk = 'D:\BACKUP_DB\QLTRANDAU_FULL.bak'
with init, -- Ghi đè file backup cũ
	 name = 'QLTRANDAU-Full Database Backup ',
	 description = 'Sao lưu đầy đủ database QLTRANDAU';
go

-- Script để sao lưu nhật ký giao dịch (Transaction log backup)
BACKUP LOG QLTRANDAU
to disk = 'D:\BACKUP_DB\QLTRANDAU_Log.trn'
with init,
	 name = 'QLTRANDAU-Transaction Log Backup',
	 description = 'Sao lưu nhật ký giao dịch QLTRANDAU';
go

USE master;
go

RESTORE DATABASE QLTRANDAU
from disk = 'D:\BACKUP_DB\QLTRANDAU_FULL.bak'
with RECOVERY,-- Để database có thể sử dụng sau khi khôi phục
	 REPLACE;-- Ghi đè lên database cũ nếu đã tồn tại
go

-- =============================================
-- TẠO BÁO CÁO VÀ VIEW CHO NGƯỜI DÙNG
-- =============================================

-- View đã đc tạo trc đó
-- Phân quyền cho các view
GRANT select on vw_ThongTinCauThu to ReporterROLE;
GRANT select on vw_ThongTinTranDau to ReporterROLE;
go

