-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE usp_CalculateSalary
	-- Add the parameters for the stored procedure here
	@year varchar(4),@month varchar(2),@op varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @date1 datetime,@date2 datetime,@days int
	select @days= day( dateadd(day,-1, dateadd(month,1,CONVERT(datetime,@year+'-'+@month+'-'+'01'))) )
	SELECT @date1= DATEADD(mm, DATEDIFF(mm,0,CONVERT(datetime,@year+'-'+@month+'-'+'01')), 0)
	SELECT @date2= dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,CONVERT(datetime,@year+'-'+@month+'-'+'01'))+1, 0))

--SELECT FFieldName FROM ICTemplateEntry AS i WHERE i.FID = 'Z02' and FHeadCaption='是工段'

if exists ( select name from sysobjects where name='t_WageTemp' and type='U') drop table t_WageTemp
CREATE TABLE t_WageTemp(
FDate datetime not null,
FItemID varchar(50) not null,
WorkShop int not null,
workerID int null,
OperID int not null,
[Is] int not null,
Qty decimal(10,2) not null,
PieceRate decimal(18,8) not null,
[money] decimal(18,2) null,
ProRate decimal(10,2) not null,
MOQty decimal(10,2) null,
)

--t_Item_3008 工序计件翻倍系数--海天测试环境3019
--核算项目'是否'在海天测试环境代码是2052
insert into t_WageTemp
select prm.FDate,mo.FItemID,mo.FWorkShop,pr.FworkerID,prm.FOperID,1,pr.FAuxQtyfinish,wbe.FPieceRate,pr.FAuxQtyfinish*wbe.FPieceRate*ISNULL(coe.F_103,1),ISNULL(coe.F_103,1) as prorate,mo.FAuxQty from
SHProcRptMain prm join SHProcRpt pr on prm.FInterID=pr.FinterID
join SHWorkBillEntry wbe on prm.FWBNO=wbe.FWorkBillNO 
join SHWorkBill wb on wb.FInterID=wbe.FinterID
join ICMO mo on mo.FInterID=wb.FICMOInterID
left join t_Item_3008 coe on 1=1 and mo.FAuxQty>=coe.F_101 and mo.FAuxQty<=coe.F_102 and wbe.FTeamID<>0
where pr.FworkerID<>0 and isnull(prm.FCheckerID,0)<>0 and prm.FCancellation=0 and ISNULL(wbe.FEntrySelfz0374,0) in((select FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FName='是否') and FName='否'),0)
and prm.FDate>=@date1 and prm.FDate<=@date2

--是工序，班组不为空，工单数量符合条件
--FEntrySelfZ0236 工艺路线表体增加的栏位：是工段
--FEntrySelfz0374 工序计划单表体增加的栏位：是工段
--如果某人没有统计到工序工资，可能是未审核或已作废

insert into t_WageTemp
select prm.FDate,mo.FItemID,mo.FWorkShop,sem.emp,prm.FOperID,2,pr.FAuxQtyfinish,FPieceRate,pr.FAuxQtyfinish*FPieceRate*rate,1,null from SHProcRptMain prm join SHProcRpt pr on prm.FInterID=pr.FinterID
join SHWorkBillEntry wbe on prm.FWBNO=wbe.FWorkBillNO 
join SHWorkBill wb on wb.FInterID=wbe.FinterID
join ICMO mo on mo.FInterID=wb.FICMOInterID
join (select *from t_SectionEmpMapping where year=@year and month=@month) sem on prm.FOperID=sem.section
where pr.FworkerID=0 and isnull(prm.FCheckerID,0)<>0 and prm.FCancellation=0 and wbe.FEntrySelfz0374=(select FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FName='是否') and FName='是')
and prm.FDate>=@date1 and prm.FDate<=@date2

--select *from t_WageTemp

if @op='half' return

--t_Item_3007 工种奖金系数--海天测试环境3018
select ISNULL(a.workerID,b.workerID) as '职员ID',ISNULL(d.FName,d2.FName) as '部门',
ISNULL(emp.FNumber,emp2.FNumber) as '职员代码',isnull(emp.FName,emp2.FName) as '职员姓名',isnull(sm.FName,sm2.FName) as '工种',promoney as '工序工资',secmoney as '工段工资',convert(decimal(10,2),ru.F_104*(@days-isnull(leavedays,0))/@days) as bonus,(isnull(promoney,0)+isnull(secmoney,0)+isnull(convert(decimal(10,2),ru.F_104*(@days-isnull(leavedays,0))/@days),0)) as '合计'
from(select workerID,SUM(money) as promoney,SUM(Qty) as prosumqty from t_WageTemp where [Is]=1 group by workerID)a
full join (select workerID,SUM(money) as secmoney from t_WageTemp where [Is]=2 group by workerID)b on a.workerID=b.workerID
left join t_Emp emp on a.workerID=emp.FItemID
left join t_Department d on d.FItemID=emp.FDepartmentID
left join t_SubMessage sm on emp.FDuty=sm.FInterID
left join t_Item_3007 ru on emp.FDuty=ru.F_105 and a.promoney>=ru.F_102 and a.promoney<=ru.F_103 
left join (select EmpID,SUM(LeaveHours)/8 as leavedays from t_ImportLeaveData where year=@year and month=@month group by EmpID) ild on ild.EmpID=a.workerID
left join t_Emp emp2 on b.workerID=emp2.FItemID
left join t_Department d2 on d2.FItemID=emp2.FDepartmentID
left join t_SubMessage sm2 on emp2.FDuty=sm2.FInterID
order by '职员代码'

End