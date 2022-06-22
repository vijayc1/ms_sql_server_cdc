create database vijay_cdc_dev;

use vijay_cdc_dev;

exec sp_changedbowner 'sa';

exec sys.sp_cdc_enable_db  ;

select * from cdc.change_tables;

CREATE Table cdc_fake_records
(
   Id nvarchar(50) primary key,
   TeamId nvarchar(50),
   TeamCode nvarchar(50),
   FirstName nvarchar(50),
   LastName nvarchar(50),
   Address1 nvarchar(50),
   Address2 nvarchar(50),
   city nvarchar(50),
   State nvarchar(50),
   Pin nvarchar(50)
)
;

Declare @Id int
Set @Id = 1
While @Id <= 1500
Begin 
   Insert Into cdc_fake_records values 
   (
   NEWID(),
   'TeamId - ' + CAST(@Id as nvarchar(10)),
   'TeamCode - ' + CAST(@Id as nvarchar(10)),
   'FirstName - ' + CAST(@Id as nvarchar(10)),
   'LastName  - ' + CAST(@Id as nvarchar(10)),
   'Address1 - ' + CAST(@Id as nvarchar(10)),
   'Address2 - ' + CAST(@Id as nvarchar(10)),
   'City - ' + CAST(@Id as nvarchar(10)),
   'State - ' + CAST(@Id as nvarchar(10)),
   '60000' + CAST(@Id as nvarchar(10))
   )
   Set @Id = @Id + 1
End
;


EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'cdc_fake_records',  
@role_name     = NULL,  
@capture_instance = NULL,
@supports_net_changes = 1,
@captured_column_list = N'Id, Address1, Address2, City, Pin',
@filegroup_name = N'PRIMARY';
GO

select * from cdc.change_tables;

EXEC sys.sp_cdc_disable_table 
@source_schema = N'dbo',
@source_name = N'cdc_fake_records',
@capture_instance = N'dbo_cdc_fake_records'
;


select count(*) from cdc_fake_records;

Declare @Id int
Set @Id = 1
While @Id <= 1
Begin 
   Insert Into cdc_fake_records values 
   (
   NEWID(),
   'TeamId - ' + CAST(@Id as nvarchar(10)),
   'TeamCode - ' + CAST(@Id as nvarchar(10)),
   'FirstName - ' + CAST(@Id as nvarchar(10)),
   'LastName  - ' + CAST(@Id as nvarchar(10)),
   'Address1 - ' + CAST(@Id as nvarchar(10)),
   'Address2 - ' + CAST(@Id as nvarchar(10)),
   'City - ' + CAST(@Id as nvarchar(10)),
   'State - ' + CAST(@Id as nvarchar(10)),
   '60000' + CAST(@Id as nvarchar(10))
   )
   Set @Id = @Id + 1
End
;

delete from cdc_fake_records where TeamId = 'TeamId - 1';

update cdc_fake_records 
set TeamId = 'TeamId - 1212 - Test'
where TeamId = 'TeamId - 1212'
;

select * from cdc_fake_records;

select * from cdc.dbo_cdc_fake_records_ct;

