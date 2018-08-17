ALTER PROCEDURE [dbo].[GetSupplierTotalAmount]
@FSupplier varchar(20),
@startdate varchar(10),
@enddate varchar(10)
AS
BEGIN

set nocount on

declare @perhour varchar(10),@type varchar(10),@ItemClassID varchar(20),@sql varchar(2000)
select @ItemClassID=FItemClassID from t_ItemClass where FName='计时/计件'
select @perhour=FSQLColumnName from t_ItemPropDesc where FItemClassID=@ItemClassID and FName='小时工资'
select @type=FSQLColumnName from t_ItemPropDesc where FItemClassID=3 and FName='计时/计件' --职员表新增计时计件字段

print @perhour print @type print @ItemClassID

set @sql='with temp as(select s.FSup,per.FNumber,per.FName as supname,s.FBillNo,s.FDate,s.FSEOrder,emp.FName as empname,se.FSDate,se.FEDate,FWorkHours,it.FName as itname,se.FRemark,itc.FName,itc.'+@perhour+',FWorkHours*itc.'+@perhour+' as salary from t_dispatchlist_sup s 
join t_DispatchList_SupEntry se on s.FID=se.FID
join t_Supplier per on S.FSup=per.FItemID
join t_Base_Emp emp on se.FEmp=emp.FItemID
left join t_Item_'+@ItemClassID+' itc on emp.'+@type+'=itc.FItemID
join t_Item it on se.FBool=it.FItemID where FMultiCheckStatus=16 and it.FName=''是'''
if (@FSupplier<>'')
begin
set @sql=@sql+' and per.FNumber='''+@FSupplier+''''
end
if (@startdate<>'')
begin
set @sql=@sql+' and FDate>=convert(datetime,'''+@startdate+''',120)'
end
if (@enddate<>'')
begin
set @sql=@sql+' and FDate<=convert(datetime,'''+@enddate+''',120)'
end
set @sql=@sql+' )
select *,1 as orderid from temp
union (select FSup,null,null,''合计'',null,null,null,null,null,null,null,null,null,null,SUM(isnull(salary,0)),2 from temp group by FSup) order by FSup,orderid'

print @sql

exec(@sql)

END
go

alter PROCEDURE [dbo].[GetDepartmentTotalAmount]
@Department varchar(20),
@startdate varchar(10),
@enddate varchar(10)
AS
BEGIN

set nocount on

declare @perhour varchar(10),@type varchar(10),@ItemClassID varchar(20),@sql varchar(2000)
select @ItemClassID=FItemClassID from t_ItemClass where FName='计时/计件'
select @perhour=FSQLColumnName from t_ItemPropDesc where FItemClassID=@ItemClassID and FName='小时工资'
select @type=FSQLColumnName from t_ItemPropDesc where FItemClassID=3 and FName='计时/计件'

set @sql='with temp as(select s.FDep,dep.FNumber,dep.FName as depname,s.FBillNo,s.FDate,s.FSEOrder,emp.FName as empname,se.FSDate,se.FEDate,FWorkHours,it.FName as itname,se.FRemark,itc.FName,itc.'+@perhour+',FWorkHours*itc.'+@perhour+' as salary from t_DispatchList_Dep s 
join t_DispatchList_DepEntry se on s.FID=se.FID
join t_Department dep on S.FDep=dep.FItemID
join t_Base_Emp emp on se.FEmp=emp.FItemID
left join t_Item_'+@ItemClassID+' itc on emp.'+@type+'=itc.FItemID
join t_Item it on se.FBool=it.FItemID where FMultiCheckStatus=16 and it.FName=''是'''
if (@Department<>'')
begin
set @sql=@sql+' and dep.FNumber='''+@Department+''''
end
if (@startdate<>'')
begin
set @sql=@sql+' and FDate>=convert(datetime,'''+@startdate+''',120)'
end
if (@enddate<>'')
begin
set @sql=@sql+' and FDate<=convert(datetime,'''+@enddate+''',120)'
end
set @sql=@sql+' )
select *,1 as orderid from temp
union (select FDep,null,null,''合计'',null,null,null,null,null,null,null,null,null,null,SUM(isnull(salary,0)),2 from temp group by FDep) order by FDep,orderid'

print @sql

exec(@sql)

END
go

create PROCEDURE [dbo].[GetEmployeeTotalAmount]
@Employee varchar(20),
@startdate varchar(10),
@enddate varchar(10)
AS
BEGIN

set nocount on

declare @perhour varchar(10),@type varchar(10),@ItemClassID varchar(20),@sql varchar(2000)
select @ItemClassID=FItemClassID from t_ItemClass where FName='计时/计件'
select @perhour=FSQLColumnName from t_ItemPropDesc where FItemClassID=@ItemClassID and FName='小时工资'
select @type=FSQLColumnName from t_ItemPropDesc where FItemClassID=3 and FName='计时/计件'

set @sql='with temp as(select s.FEmployee,e.FNumber,e.FName as ename,s.FBillNo,s.FDate,s.FSEOrder,emp.FName as empname,se.FSDate,se.FEDate,FWorkHours,it.FName as itname,se.FRemark,itc.FName,itc.'+@perhour+',FWorkHours*itc.'+@perhour+' as salary from t_DispatchList_Emp s 
join t_DispatchList_EmpEntry se on s.FID=se.FID
join t_Base_Emp e on S.FEmployee=e.FItemID
join t_Base_Emp emp on se.FEmp=emp.FItemID
left join t_Item_'+@ItemClassID+' itc on emp.'+@type+'=itc.FItemID
join t_Item it on se.FBool=it.FItemID where FMultiCheckStatus=16 and it.FName=''是'''
if (@Employee<>'')
begin
set @sql=@sql+' and e.FNumber='''+@Employee+''''
end
if (@startdate<>'')
begin
set @sql=@sql+' and FDate>=convert(datetime,'''+@startdate+''',120)'
end
if (@enddate<>'')
begin
set @sql=@sql+' and FDate<=convert(datetime,'''+@enddate+''',120)'
end
set @sql=@sql+' )
select *,1 as orderid from temp
union (select FEmployee,null,null,''合计'',null,null,null,null,null,null,null,null,null,null,SUM(isnull(salary,0)),2 from temp group by FEmployee) order by FEmployee,orderid'

print @sql

exec(@sql)

END
go
