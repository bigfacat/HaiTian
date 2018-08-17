use AIS20120418193840

select *from t_xiliefenlei a,t_xiliefenleientry b where a.fid=b.fid

select *from t_xiliefenleientry

select *from t_icitem
select *from t_item where fname like '产品系列分类1'

select top 100 * from t_supplier

select *from t_supply su join t_supplyentry sue on su.fitemid=sue.fitemid and su.fsupid=sue.fsupid
select *from t_supply

select *from t_chanpinxilie

insert into t_chanpinxilie values(4,5,6)


delete t_chanpinxilie  where id=1

select *from t_xiliefenlei a,t_xiliefenleientry b where a.fid=b.fid

select *from t_xiliefenleientry
select *from t_icitem ic where ic.FItemID in (2066,2338,3273,12705)
select *from t_icitem ic where ic.FNumber='8.SA.0V630.1155ARPA-29G'
select *from t_item where fname like '产品系列分类1' 
select *from t_ItemClass where FItemClassID=3015
alter table  t_dispatchlist_supentry drop column fworkhours

select COUNT(*) from t_item where FDeleted=0
select top 100 * from t_supplier

select *from t_supply su join t_supplyentry sue on su.fitemid=sue.fitemid and su.fsupid=sue.fsupid
select *from t_supply

select cp.id,it.FNumber+'|'+it.FName as xiliename,ic.FNumber as matno,ic.FNumber +'|'+ic.FName as matname,ic.FModel,per.FName as supname from t_chanpinxilie cp left join t_item it on cp.xilieID=it.FItemID
left join t_icitem ic on cp.childmatID=ic.FItemID left join t_Supplier per on cp.supID=per.FItemID

select FNumber+'|'+FName as xiliename,*from t_chanpinxilie cp join t_item it on cp.xilieID=it.FItemID

select ic.FNumber+'|'+ic.FName as matname from t_item it join t_xiliefenlei fl on it.FItemID=fl.FBase1
join t_xiliefenleiEntry fle on fl.FID=fle.FID
join t_ICItem ic on fle.FBase=ic.FItemID where it.FNumber='' and it.FName=''

insert into t_chanpinxilie select it.FItemID,ic.FItemID,per.FItemID from t_item it , t_icitem ic,t_Supplier per where it.FName= '产品系列分类1' and ic.FNumber='8.SA.0V630.1155ARPA-29G' and per.FNumber='G.018'

update  t_chanpinxilie set xilieID=a.itname,childmatID=a.icname,supID=a.supname from (select it.FItemID as itname,ic.FItemID as icname,per.FItemID as supname from t_item it , t_icitem ic,t_Supplier per where it.FName= '产品系列分类1' and ic.FNumber='8.SA.0V630.1155ARPA-29G' and per.FNumber='G.018')a where id=2

select *from t_chanpinxilie 
update t_chanpinxilie set childmatID=39335 where id=2

delete t_chanpinxilie  where id=1

select *from t_supply su join t_supplyentry sue on su.fitemid=sue.fitemid and su.fsupid=sue.fsupid

select per.FNumber+'|'+per.FName as supname,ic.FNumber from t_supply su join t_ICItem ic on su.FItemID=ic.FItemID
join t_Supplier per on FSupID=per.FItemID where ic.FNumber='8.SA.0V630.1155ARPA-29G'

select *from t_xiliefenlei fl join t_xiliefenleiEntry fle on fl.FID=fle.FID join ICBOM bom on fle.FBase=bom.FItemID
update t_xiliefenleiEntry set FBase='39335'
delete from t_xiliefenleiEntry where FEntryID=4
select FItemID,COUNT(*) from ICBOM bom  group by FItemID having COUNT(*)>0 
select distinct FForbid from ICBOM bom

select FNumber+'|'+FName as xiliename from t_xiliefenlei fl join t_item it on fl.series=it.FItemID

ALTER TABLE t_xiliefenlei 
DROP COLUMN fbase1
delete from t_xiliefenlei where FID=1001

select* from t_chanpinxilie cp

select FPrice,per.FNumber from t_chanpinxilie cp join t_Supply s on cp.childmatID=s.FItemID and cp.supID=s.FSupID join (select *from t_SupplyEntry where FUsed=1 and FQuoteTime<=GETDATE() and FDisableDate>=GETDATE()) se on se.FItemID=s.FItemID and se.FSupID=s.FSupID left join t_Item it on cp.xilieID=it.FItemID left join t_ICItem ic on cp.childmatID=ic.FItemID join t_Supplier per on se.FSupID=per.FItemID where it.FName='产品系列分类1' and ic.FNumber=''

select icic.FNumber+'|'+icic.FName as matname,* from (select *from t_item where FDeleted=0) it 
join t_xiliefenlei fl on it.FItemID=fl.FBase1
join t_xiliefenleiEntry fle on fl.FID=fle.FID 
join (select *from t_ICItem where FDeleted=0) ic on fle.FBase=ic.FItemID 
join (select *from ICBOM where FCancellation=0 and FForbid=0) bom on bom.FItemID=ic.FItemID
join ICBOMChild bomc on bom.FInterID= bomc.FInterID
join (select *from t_ICItem where FDeleted=0) icic on bomc.FItemID=icic.FItemID 
where it.FName= '产品系列分类1'

select ic.FNumber,ic.FItemID from t_ICItem ic join ICBOM bom on bom.FItemID=ic.FItemID
left join ICBOMChild bomc on bom.FInterID= bomc.FInterID
where FNumber='8.SA.0V630.1155ARPA-29G' and ic.FDeleted=0
and bom.FItemID= 12703

select *from t_dispatchlist_sup s join t_DispatchList_SupEntry se on s.FID=se.FID

where FMultiCheckStatus=16
--select *from t_dispatchlist_supentry

 
select *from t_dispatchlist_emp

select id,YEAR,MONTH,case status when 1 then '开帐' when 0 then '关账' end as status from t_AccountStatus
insert into t_AccountStatus values(2018,1,0)


select FItemID,FNumber,FName from t_Supplier per where 1=1 and FDeleted=0 and FStatus=1072
and (FNumber like '%1%' or FName like '%1%')


select cp.id,it.FNumber as xilieID,it.FName as xiliename,ic.FNumber as matno,ic.FName as matname,ic.FModel,per.FNumber as supno,per.FName as supname from t_chanpinxilie cp left join t_item it on cp.xilieID=it.FItemID
left join t_icitem ic on cp.childmatID=ic.FItemID left join t_Supplier per on cp.supID=per.FItemID where 1=1

select *from t_chanpinxilie
insert into t_chanpinxilie values (129500,94891,204)
--exec sp_rename 't_chanpinxilie.matID','childmatID','column';

select * from t_chanpinxilie where xilieID=(select FItemID from t_Item where FName='cc6')
delete from t_chanpinxilie where xilieID=(select FItemID from t_Item where FName='cc6')

select FItemID,FNumber,FName from t_Item where 1=1 and FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类')

select *from t_ItemClass

;with temp as(select bomc.FItemID,it.FNumber as flnumber,it.FName as flname,ic.FNumber,ic.FName,ic.FModel,null as sup,null as supname from t_Item it join t_xiliefenlei fl on it.FItemID=fl.Series
join t_xiliefenleiEntry fle on fl.FID=fle.FID left join ICBOM bom on fle.Material=bom.FItemID 
join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem ic on bomc.FItemID=ic.FItemID
where 1=1 and FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类') and bom.FUseStatus=1072 and bom.FForbid=0 and ic.FErpClsID=1 and it.FName='DD2')select distinct *from temp


select * from ICBOM bom join ICBOMChild bomc on bom.FInterID=bomc.FInterID where bom.FItemID=51432


select per.FItemID,per.FNumber,ic.FItemID,ic.FNumber,ic.FName,FPrice,*from t_Supply s join (select *from t_SupplyEntry where FUsed=1 and FQuoteTime<=GETDATE() and FDisableDate>=GETDATE()) se on se.FItemID=s.FItemID and se.FSupID=s.FSupID
left join t_Supplier per on se.FSupID=per.FItemID
left join t_ICItem ic on ic.FItemID=se.FItemID
where per.FNumber='A.001'

select *from t_Item_3007

select *from t_Item_3008

select *from t_Item_3014

select *from t_Item_3015


update t_chanpinxilie set status=1 where id in(1,2,3)


alter table t_chanpinxilie alter column [status] int null
select status,case status when 1 then '审核' else '保存' end,* from t_chanpinxilie


update t_chanpinxilie set supID=per.FItemID from(select*from t_Supplier where FNumber ='A.001')per where id=30

select FNumber,FName from t_chanpinxilie cpxl left join t_Supplier per on cpxl.supID=per.FItemID where id=37

update t_chanpinxilie set supID=per.FItemID from(select*from t_Supplier where FNumber ='A.001')per where id=30

declare @supid int select @supid=FItemID from t_Supplier where FNumber=''
update cpxl set supID=@supid from t_chanpinxilie cpxl left join t_Supplier per on cpxl.supID=per.FItemID where FNumber='' 
select *
select @@ROWCOUNT