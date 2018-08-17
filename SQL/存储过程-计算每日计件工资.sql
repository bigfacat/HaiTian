alter PROCEDURE usp_CalculateDailySalaryByDate
	-- Add the parameters for the stored procedure here
	@date varchar(10),@dept varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;

if @date='' set @date=CONVERT(varchar(10),GETDATE(),120)

declare @year int,@month int
select @year=substring(@date,1,4)
select @month=substring(@date,6,2)

exec usp_CalculateSalary @year,@month,'half'

if exists ( select name from sysobjects where name='#S' and type='U') drop table #S

select workerID,@date as FDate,d.FNumber as DNumber,d.FName as DName,emp.FName as EName,SumMoney into #S
from(select workerID,SUM(money) as SumMoney from t_WageTemp
where CONVERT(date,FDate,120)=CONVERT(date,@date,120) and [Is]=1 group by workerID)temp
join t_Emp emp on temp.workerID=emp.FItemID
left join t_Department d on emp.FDepartmentID=d.FItemID

if @dept=''
select *from #S
else
select *from #S where DNumber like '%'+@dept+'%'

End