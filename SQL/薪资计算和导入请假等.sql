 insert into t_ImportLeaveData(year,month,EmpID,LeaveHours) select 2018,2,emp.FItemID,4 from t_Emp emp where emp.FNumber='20071010172642200'

select *from t_ImportLeaveData

select  32-Day(getdate()+(32-Day(getdate())))

select 32-Day(CONVERT(datetime,'2018'+'-'+'4'+'-'+'01')+(32-Day(CONVERT(datetime,'2018'+'-'+'4'+'-'+'01'))))

select day( dateadd(day,-1, dateadd(month,1,CONVERT(datetime,2018+'-'+4+'-'+'01'))))

select day( dateadd(day,-1, dateadd(month,1,CONVERT(datetime,'2018'+'-'+'2'+'-'+'01'))) )

exec usp_CalculateSalary 2018,4,''

select *from t_WageTemp

exec usp_CalculateDailySalaryByDate '2018-02-11',''

exec usp_ImportDirectLaborCostsToCostObj 2018,4

select *from CBCostExpenseInfo

select *from t_WageResult
select *from #B

select name from sysobjects where name='#S' and type='U'

exec sp_configure 'show advanced options',1
RECONFIGURE
GO
exec sp_configure 'Ad Hoc Distributed Queries',1
RECONFIGURE
GO
select * into #JobInfo_S1
from openrowset('sqloledb', 'server=192.168.1.165;trusted_connection=yes','select * from dbo.t_Emp')

select * from #JobInfo_S1
drop table #JobInfo_S1

select DB_NAME()
select CONVERT(varchar(10),FDate,120) from t_WageTemp

begin tran
update wbe set wbe.FEntrySelfz0374=2430,wbe.FPieceRate=10 from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wbe.FWorkBillNO='WB000203'

update wbe set wbe.FEntrySelfz0374=2429,wbe.FPieceRate=12 from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wbe.FWorkBillNO='WB000205'

commit tran
select * from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wb.FBillNO='WB000033'

select FInterID,FID,FName from t_SubMessage where FTypeID=61--工序资料

select * from t_SubMessage where FTypeID=62--班组
