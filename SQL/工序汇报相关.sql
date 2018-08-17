
select top 10 FInterID,FBillNo from ICMO where FCancellation='0' and FStatus in (1)
select wbe.FWBInterID,FWorkBillNO,FAuxQtyPlan,FICMONO as mo from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wbe.FCancellation='0'
and wbe.FStatus in (1) and FICMONO like '%%'
and wbe.FWorkBillNO like '%WB000041%'

select *from t_Emp

select FID,FNumber,FName from t_Emp where FDeleted=0

select * from SHWorkBill  
select FOperNote,* from SHWorkBillEntry  ---  工序计划 
select * from ICTaskDispBill   
select *  from ICTaskDispBillEntry   ---派工单 
select FTaskDispBillID,FOperAuxQtyFinishTotal,* from SHProcRptMain where FBillNo='GXHB000004'   --工序汇报
select *from t_RoutingOperMng
select *from t_RoutingOperMngEntry
select * from ICMO where FBillNo='WORK00020611'
select * from ICMO where FBillNo='WORK00023401'
select distinct FCancellation from ICMO

select FUnitID,wb.FitemID,FPlanStartDate,FWorkCenterID,FWBInterID,FqualityChkID,* from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wbe.FCancellation='0' and wbe.FStatus in (1) and wb.FinterID=3241
and wbe.FWorkBillNO='WB000198'

select *from ICClassType where FID=1002520

select prm.FAuxQtyPlan,FBillerID,* from SHProcRptMain prm
select prm.FAuxQtyPlan,pr.FAuxQtyfinish,FQtyPlan,Fqtyfinish,FworkerID,FIsLastReport,FWBNO,prm.FWBinterID,FOperAuxQtyPlan,FOperAuxQtyFinish,FOperAuxQtyFinishTotal,* from SHProcRptMain prm join SHProcRpt pr on prm.FInterID=pr.FinterID
 where FBillNo= 'GXHB000081'

 select *from t_Emp where FItemID=16394

SELECT * FROM ICTransactionType AS it

select *from ICSerial


select * from t_SubMesType


select * from t_SubMessage where FTypeID=61


select *from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID
join SHWorkBillEntry wbe on g.FWBNO=wbe.FWorkBillNO join SHWorkBill wb on wb.FInterID=wbe.FinterID

insert into t_GXHB values(1,'gxhb001',582,GETDATE(),16394,null,null,0,0,150,0,'WB000198',0,1059,52)
insert into t_GXHBEntry values(1,2,0,2371,0,0,null,null,10,0,0,0,0)


select FItemID,*from t_Emp

select FBillNo,FEntryIndex,FEntryID,emp.FNumber,emp.FName,FAuxQtyfinish,* from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID 
join t_Emp emp on ge.FworkerID=emp.FItemID where FBillNo='gxhb000081' --and FEntryID=1

update t_GXHBEntry set FworkerID=emp.FItemID,FAuxQtyfinish=10 from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID
join t_Emp emp on ge.FworkerID=emp.FItemID where FBillNo='gxhb000081' and FEntryID=1

UPDATE ICMaxNum SET FMaxNum = ISNULL(FMaxNum,0) + 1 WHERE FTableName = 'SHProcRptMain'
update t_GXHB set FInterID=1101 where FInterID=1100
update t_GXHBEntry set FInterID=1101 where FInterID=1100

select *from ICMaxNum WHERE FTableName = 'SHProcRptMain'
 
update t_GXHBEntry set FworkerID=(select top 1 FItemID from t_Emp emp where emp.FNumber='6.08.002'),FAuxQtyfinish=10 where FEntryIndex=1

declare @FinterID int,@FworkerID int
select @FinterID=FinterID from t_GXHB where FBillNo=''
update t_GXHB set FWBNO='' where FBillNo=''
delete from t_GXHBEntry where FinterID=@FinterID
insert into t_GXHBEntry values(@FinterID,2,0,@FworkerID,0,0,null,null,10,0,0,1059,0)


select FEntryIndex,g.FBillNo,FWBNO,wb.FICMONO,ic.FNumber,ic.FName,wbe.FOperSN,wbe.FOperID,ge.FEntryID,emp.FNumber,emp.FName,convert(decimal(8,2),ge.FAuxQtyfinish) 
from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID
join SHWorkBillEntry wbe on g.FWBNO=wbe.FWorkBillNO 
join SHWorkBill wb on wb.FInterID=wbe.FinterID
join t_Emp emp on ge.FWorkerID=emp.FItemID
join t_ICItem ic on wb.FItemID=ic.FItemID where 1=1

select *from t_icItem where FItemID=40089


declare @FBillNo varchar(50)
exec [usp_Com_GetFBillNO] 582,@FBillNo output
select @FBillNo
go

declare @FInterID int,@FworkerID int
SELECT @FInterID = isnull(in1.FMaxNum,0) FROM ICMaxNum in1 WHERE in1.FTableName = 'SHProcRptMain'
insert into t_GXHB values(@FInterID,'',582,GETDATE(),0,null,null,0,0,150,0,'',0,1059,56)
select @FworkerID=(select top 1 FItemID from t_Emp emp where emp.FNumber='')
insert into t_GXHBEntry values(@FinterID,'',0,@FworkerID,0,0,null,null,10,0,0,1059,0)


select *from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID where g.FBillNo='GXHB000085'

update t_GXHB set fwbno='WB000030' where FInterID=1099

select *from  t_billcoderule where FBillTypeID=582
exec usp_ImportProcRptDataToWise 'GXHB000083'
exec [usp_Com_UpdateFBillNO] 582

delete from SHProcRptMain where FInterID=1103
delete from SHProcRpt where FInterID=1103

select * from SHProcRptMain prm join SHProcRpt pr on prm.FInterID=pr.FinterID
where FBillNo= 'GXHB000085'

select * from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
where wbe.FCancellation='0' and wbe.FStatus in (1) and wb.FinterID=3241

update SHWorkBillEntry set FAuxQtyFinish=0, FAuxQtyTaskDispAck=0,FAuxQtyTaskDispSel=0,
FQtyFinish=0,FQtyTaskDispAck=0,FQtyTaskDispSel=0 where FWorkBillNO=''
select CONVERT(datetime,'2018-01-01')

declare @FInterID int
select @FInterID=FInterID from t_GXHB where FBillNo=''
delete from t_GXHB where FInterID=@FInterID
delete from t_GXHBEntry where FInterID=@FInterID

select *from t_GXHB where FDate<=CONVERT(datetime,'2018-01-01')

select case IsThrown when 1 then '是' else '否' end from t_GXHB

update t_GXHB set IsThrown=1

select * from t_User where FName='administrator'

select FUserID,FName,FDescription from t_User where 1=1

select *from t_ItemClass where FItemID=10001
select mu.id,username,CreateDate,FDescription,* from t_MyUserAccount mu join t_User u on mu.username=u.FName
where 1=1 and username like '%c%'

select *from t_Emp emp where FName like '%小%'

select *from sysobjects where name='t_prd_mo'

select obj.name,*from syscolumns col join sysobjects obj on col.id=obj.id where col.name like '%usertype%'  and id='898974429'

select *from ICMsgDefineUser
select *from ICClassMCTaskUser
select *from t_SMSObjectControl
--insert into t_MyUserAccount values ('administrator','8',getdate())

--alter table t_MyUserAccount add CreateDate datetime

select *from t_MyUserAccount

select id,YEAR,MONTH,case status when 1 then '开账' when 0 then '关账' end from t_accountstatus where month=02

select id,year,month,rom.FNumber,rom.FName,emp.FNumber,emp.FName,rate from t_SectionEmpMapping s 
left join t_Emp emp on s.emp=emp.FItemID
left join t_RoutingOperMng rom on s.section=rom.FID where 1=1

select id,emp.FNumber,emp.FName,rate from t_SectionEmpMapping s 
left join t_Emp emp on s.emp=emp.FItemID
left join t_RoutingOperMng rom on s.section=rom.FID where 1=1

select * from t_SectionEmpMapping
delete from t_SectionEmpMapping where year=0 and month=0 and section=0
insert into t_SectionEmpMapping values(0,0,0,0,0)

insert into t_SectionEmpMapping select 2018,3,section,emp,rate from t_SectionEmpMapping where year=2018 and month=2

select top 1 FID from t_RoutingOperMng where FNumber=''

select FID,FNumber,FName from t_RoutingOperMng where 1=1 and (FNumber like '%%' or FName like '%%')
select * from t_RoutingOperMng

select * from t_RoutingOper  

select FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FNumber='2050') and FName='是'


select FCheckStatus,FTaskDispBillID,* from SHProcRptMain prm join SHProcRpt pr on prm.FInterID=pr.FinterID 
where FBillNo in ('GXHB000088')

select *from ICTaskDispBill 
select *from ICTaskDispBillEntry 


select id,year,month,rom.FNumber,rom.FName,emp.FNumber,emp.FName,rate from t_SectionEmpMapping s 
left join t_Emp emp on s.emp=emp.FItemID
left join t_RoutingOperMng rom on s.section=rom.FID where 1=1

select FID,FNumber,FName from t_RoutingOperMng where 1=1

update SHProcRptMain set FTaskDispBillID=0  where FBillNo in ('GXHB000088')

update SHProcRptMain set FStatus=1,FCheckerID=16394 where FBillNo='GXHB000088' 


select  * from t_User


exec usp_CalculateSalary 2018,2

select *from t_WageTemp

drop table t_WageTemp

SELECT dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,CONVERT(datetime,'2018-01-01'))+1, 0))


exec usp_CloseAccountCheck 2018,1


select * from t_AccountStatus where 1=1 and year=2018 and month=1

update t_AccountStatus set status=0 where 1=1 and year=2018 and month=1

select  * from ICBOM where  finterid=1368

select  * from ICBOM where FBOMNumber in('BOM000761','BOM001247','BOM001248')

select *from t_ICItem where FNumber='8.DK.OD147.1050ABD-39W'
select 2 as orderid,bomc.FItemID,temp2.item2 as SrcItemID


select bomc.FAuxQty,bomc.FQty,* from ICBOM bom join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem it on bom.FItemID=it.FItemID where it.FNumber in('8.DK.OD147.1050ABD-39W')
--order by FItemID,orderid


select bom.FItemID,bomc.FItemID,FName from ICBOM bom join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem it on bomc.FItemID=it.FItemID
where bom.FItemID in(51426)and bom.FUseStatus=1072 and bom.FForbid=0

select *from ICBOMChild

select *from t_xiliefenleiEntry


exec usp_SalesOrderCost '8.DK.OD147.1050ABD-39W'

exec usp_SalesOrderCost '8.DK.OD147.1050A-39W'

select *from t_ICItem where FNumber='Y.Y.0900000-0A0'

--update #ATemp set Amount1=FPrice1
--update x set Amount1=0 from #ATemp x join (select * from ICBOM where FUseStatus=1072 and FForbid=0) bom on x.BodyItem1=bom.FItemID

exec usp_SalesOrderCost '8.DK.OD147.1050ABD-39W'

select * from tempdb.dbo.sysobjects where name like N'%#ATemp%' and type='U'


select FStatus,FCancellation,FClosed,*from ICMO


update SHProcRptMain set FCancellation=1,FCheckerID=null,FCheckDate=null where FBillNo='GXHB000099'
update t_GXHB set FCancellation=1 where FBillNo='GXHB000031'

select FCheckStatus,FStatus,FCancellation,*from SHProcRptMain where FBillNo='GXHB000099'


select *from t_Item where FItemClassID=3008

select *from t_Item_3008

