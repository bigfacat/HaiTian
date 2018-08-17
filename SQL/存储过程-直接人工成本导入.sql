-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE usp_ImportDirectLaborCostsToCostObj
	-- Add the parameters for the stored procedure here
	@year varchar(4),@month varchar(2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @status int,@qty int
select @status=[status] from t_AccountStatus where year=@year and month=@month
if @status=1
begin
select 99 as status,'δ����' as msg
return
end

exec @qty=usp_CloseAccountCheck @year,@month,'half'
if @qty>0
begin
select 99 as status,'�����´���δ��˻�δ�ύ�ĵ���' as msg
return
end

if exists ( select name from sysobjects where name='t_WageResult' and type='U') drop table t_WageResult
CREATE TABLE t_WageResult(
workerID int not null,
EmpName varchar(20) null,
WorkType varchar(20) null,
ProMoney decimal(10,2) null,
SecMoney decimal(10,2) null,
Bonus decimal(10,2) null,
Sum decimal(10,2) null,
)

declare @SumAllPieceSalary decimal(10,2),@SumBonus decimal(10,2)
--exec usp_CalculateSalary 2018,4,'half'
--exec usp_CalculateSalary 2018,4,''

insert into t_WageResult exec usp_CalculateSalary @year,@month,''
select @SumAllPieceSalary=SUM(ISNULL([money],0)) from t_WageTemp
select @SumBonus=SUM(ISNULL(Bonus,0)) from t_WageResult

select FCostObjID,WorkShop,SUM([money]) as SumGroupPieceMoney,
SUM([money])/@SumAllPieceSalary*@SumBonus as RateBonus,
SUM([money])+SUM([money])/@SumAllPieceSalary*@SumBonus as SumBoth into #B
from t_WageTemp temp join cb_CostObj_Product cop on temp.FItemID=cop.FProductID group by cop.FCostObjID,temp.WorkShop

begin tran
begin try

delete from CBCostExpenseInfo where FYear=@year and FPeriod=@month and FNote='���ϵͳ�Զ�����'

declare @CostObjID int,@WorkShop int,@count int=0

    declare order_cursor cursor 
    for (select FCostObjID,WorkShop from #B)
    --���α�--
    open order_cursor
    --��ʼѭ���α����--
    fetch next from order_cursor into @CostObjID,@WorkShop
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬
        begin     

declare @FInterID int,@FBillNo varchar(20),@FCostItemID int,@FDate varchar(10)
set @FDate=@year+'-'+@month+'-01'
exec GetICMaxNum 'CBCostExpenseInfo',@FInterID output
set @FBillNo='B'+CONVERT(varchar(10),@FInterID)
select @FCostItemID=FItemID from cbCostItem where FName='ֱ���˹�'

--FExpIDҪ�ط���
--FExpAcctID���ÿ�Ŀ
--FPayAcctID���ʿ�Ŀ
--FExpTypeID��Ա���
--FVchInterIDƾ֤
--FPurposeID��;

insert into CBCostExpenseInfo (FInterID,FBillNo,FDate,FYear,FPeriod,
FExpID,FDeptID,FCostObjID,FCostItemID,FExpAcctID,FPayAcctID,FExpTypeID,
FAmount,FStandardData,FVchInterID,FNote,
FPurposeID,FSInterID,FStandardID,FIsImport,FCostObjGroupID)
select @FInterID,@FBillNo,CONVERT(date,@FDate,120),@year,@month,
61,b.WorkShop,b.FCostObjID,@FCostItemID,0,0,0,
b.SumBoth,0,0,'���ϵͳ�Զ�����',
0,0,0,0,0
from #B b where b.FCostObjID=@CostObjID and b.WorkShop=@WorkShop

set @count=@count+1
            fetch next from order_cursor into @CostObjID,@WorkShop
        end
    close order_cursor  --�ر��α�
    deallocate order_cursor   --�ͷ��α�

end try
begin catch
rollback tran
--print ERROR_MESSAGE()
select 99 as status,ERROR_MESSAGE() as msg
return
end catch
commit tran
select 100 as status,@count as [count]

End