select *from t_ItemClass

select *from cbCostObj

select FCostObjID,FProductID,*from cb_CostObj_Product where FQuotiety<>1

select *from CBCostExpenseInfo

select co.FItemID,co.FNumber,co.FName,ic.FItemID,ic.FNumber,ic.FName from cbCostObj co
join cb_CostObj_Product cop on co.FItemID=cop.FCostObjID
join t_ICItem ic on cop.FProductID=ic.FItemID

select  * from ICMaxNum where FTableName='CBCostExpenseInfo'

INSERT INTO CBCostExpenseInfo(FInterID,FBillNo,FDate,FYear,FPeriod,
FExpID,FDeptID,FCostObjID,FCostItemID,FExpAcctID,FPayAcctID,FExpTypeID,
FAmount,FStandardData,FVchInterID,FNote,
FPurposeID,FSInterID,FStandardID,FIsImport,FCostObjGroupID) VALUES
(1219,'B1219','2018-04-11',2018,3,
61,236,55,2213,0,0,0,
100.00,0,0,'',
0,0,0,0,0,0)
--FExpIDҪ�ط���
--FExpAcctID���ÿ�Ŀ
--FPayAcctID���ʿ�Ŀ
--FExpTypeID��Ա���
--FVchInterIDƾ֤
--FPurposeID��;

declare @int int
exec GetICMaxNum 'CBCostExpenseInfo',@int output
print @int


select d.FName,*from ICMO mo join t_Department d on mo.FWorkShop=d.FItemID


exec usp_CalculateSalary 2018,2,''
exec usp_ImportDirectLaborCostsToCostObj 2018,2

select *from t_WageTemp
select *from t_WageResult

select FCostObjID,WorkShop,SUM([money]) from t_WageTemp temp join cb_CostObj_Product cop on temp.FItemID=cop.FProductID group by cop.FCostObjID,temp.WorkShop

select FItemID from cbCostItem where FName='ֱ���˹�'

select * from cbCostItem where FName='ֱ���˹�'