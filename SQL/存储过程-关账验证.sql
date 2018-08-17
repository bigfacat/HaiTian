-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE usp_CloseAccountCheck
	-- Add the parameters for the stored procedure here
	@year varchar(4),@month varchar(2),@op varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @date1 datetime,@date2 datetime
	SELECT @date1= DATEADD(mm, DATEDIFF(mm,0,CONVERT(datetime,@year+'-'+@month+'-'+'01')), 0)
	SELECT @date2= dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,CONVERT(datetime,@year+'-'+@month+'-'+'01'))+1, 0))

declare @qty int=0
if exists ( select name from sysobjects where name='t_DispatchList_Sup' and type='U')
begin
select * into #C from(select '����㱨' as BillType,FBillNo from t_GXHB where IsThrown=0 and FDate>=@date1 and FDate<=@date2 --δ�ύ
union all
select '����㱨' as BillType,FBillNo from SHProcRptMain where FTranType=582 and FCancellation=0 and ISNULL(FCheckerID,0)=0 and FDate>=@date1 and FDate<=@date2 --δ������δ���
union all
select BillType,FBillNo from(select '���ɹ���_��Ӧ��' as BillType,FID,FBillNo,FDate,FMultiCheckStatus from t_DispatchList_Sup union select '���ɹ���_����' as BillType,FID,FBillNo,FDate,FMultiCheckStatus from t_DispatchList_Dep union select '���ɹ���_ְԱ' as BillType,FID,FBillNo,FDate,FMultiCheckStatus from t_DispatchList_Emp)x
where FMultiCheckStatus<>16 and FDate>=@date1 and FDate<=@date2 --δ���
)xx
select @qty=COUNT(*)from #C

if @op<>'half'
select *from #C

return @qty

end

else
begin
select * into #D from(select '����㱨' as BillType,FBillNo from t_GXHB where IsThrown=0 and FDate>=@date1 and FDate<=@date2 --δ�ύ
union all select '����㱨' as BillType,FBillNo from SHProcRptMain where FTranType=582 and FCancellation=0 and ISNULL(FCheckerID,0)=0 and FDate>=@date1 and FDate<=@date2 --δ������δ���
)xx
select @qty=COUNT(*)from #D

if @op<>'half'
select *from #D

return @qty

end

end