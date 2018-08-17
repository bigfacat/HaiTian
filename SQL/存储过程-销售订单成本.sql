-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE usp_SalesOrderCost
	-- Add the parameters for the stored procedure here
	@FNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @ItemID int
	select @ItemID=FItemID from t_ICItem where FNumber=@FNumber

 if exists (select * from tempdb.dbo.sysobjects where name like N'%#ATemp%' and type='U')
drop table #ATemp
create table #ATemp
(HeadItem0 int null,
BodyItem0 int null,
FNumber,temp0.FName
FPrice0 decimal(28,10) null,
FAuxQty0 decimal(28,10) null,
Amount0 decimal(28,10) null,
HeadItem1 int null,
BodyItem1 int null,
FPrice1 decimal(28,10) null,
FAuxQty1 decimal(28,10) null,
Amount1 decimal(28,10) null,
HeadItem2 int null,
BodyItem2 int null,
FPrice2 decimal(28,10) null,
FAuxQty2 decimal(28,10) null,
Amount2 decimal(28,10) null,
HeadItem3 int null,
BodyItem3 int null,
FPrice3 decimal(28,10) null,
FAuxQty3 decimal(28,10) null,
Amount3 decimal(28,10) null,
HeadItem4 int null,
BodyItem4 int null,
FPrice4 decimal(28,10) null,
FAuxQty4 decimal(28,10) null,
Amount4 decimal(28,10) null,
HeadItem5 int null,
BodyItem5 int null,
FPrice5 decimal(28,10) null,
FAuxQty5 decimal(28,10) null,
Amount5 decimal(28,10) null,
)

;with temp as (select bom.FItemID as HeadItem,bomc.FItemID as BodyItem,it.FNumber,it.FName,se.FPrice,bomc.FAuxQty,convert(decimal(28,10),se.FPrice*bomc.FAuxQty) as money from ICBOM bom join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem it on bomc.FItemID=it.FItemID
--join t_chanpinxilie cpxl on cpxl.matID=bomc.FItemID
left join (select max(FPrice) as FPrice,FItemID from t_SupplyEntry group by FItemID) se on se.FItemID=bomc.FItemID
where bom.FUseStatus=1072 and bom.FForbid=0)
insert into #ATemp
select 
temp0.HeadItem as HeadItem0,temp0.BodyItem as BodyItem0,temp0.FNumber,temp0.FName,temp0.FPrice as FPrice0,temp0.FAuxQty as FAuxQty0,null as Amount0,
temp1.HeadItem as HeadItem1,temp1.BodyItem as BodyItem1,temp1.FNumber,temp1.FName,temp1.FPrice as FPrice1,temp1.FAuxQty as FAuxQty1,null as Amount1,
temp2.HeadItem as HeadItem2,temp2.BodyItem as BodyItem2,temp2.FNumber,temp2.FName,temp2.FPrice as FPrice2,temp2.FAuxQty as FAuxQty2,null as Amount2,
temp3.HeadItem as HeadItem3,temp3.BodyItem as BodyItem3,temp3.FNumber,temp3.FName,temp3.FPrice as FPrice3,temp3.FAuxQty as FAuxQty3,null as Amount3,
temp4.HeadItem as HeadItem4,temp4.BodyItem as BodyItem4,temp4.FNumber,temp4.FName,temp4.FPrice as FPrice4,temp4.FAuxQty as FAuxQty4,null as Amount4,
temp5.HeadItem as HeadItem5,temp5.BodyItem as BodyItem5,temp5.FNumber,temp5.FName,temp5.FPrice as FPrice5,temp5.FAuxQty as FAuxQty5,null as Amount5
from (select *from temp where HeadItem =51426 ) temp0
join (select *from temp where HeadItem =51426 ) temp1 on temp0.BodyItem=temp1.BodyItem
left join temp temp2 on temp1.BodyItem=temp2.HeadItem
left join temp temp3 on temp2.BodyItem=temp3.HeadItem
left join temp temp4 on temp3.BodyItem=temp4.HeadItem
left join temp temp5 on temp4.BodyItem=temp5.HeadItem
order by temp1.BodyItem,temp2.BodyItem,temp3.BodyItem,temp4.BodyItem,temp5.BodyItem

--select *from #ATemp where HeadItem3 is not null
--select *from #ATemp where HeadItem2 is not null

--从第五阶开始往上推
begin
declare @a int,@error int,@Data varchar(100)

--第五阶
declare @HeadItem5 int,@sum5 decimal(28,10)
          declare c1 cursor for
select HeadItem5,SUM(FAuxQty5*isnull(FPrice5,Amount5)) from #ATemp where HeadItem5 is not null group by HeadItem5
          open c1
          fetch next from c1 into @HeadItem5,@sum5
          while @@fetch_status=0
begin 

    set @error=0
	set @a=0
    declare order_cursor cursor 
    for (select 1 from #ATemp where HeadItem5=@HeadItem5)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @Data
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态
        begin     
		set @a+=1

		if @a=1 
	update #ATemp set Amount4=@sum5 where current of order_cursor
	else update #ATemp set BodyItem4=null,FAuxQty4=null,Amount4=null where current of order_cursor
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @Data
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标

fetch next from c1 into @HeadItem5,@sum5
end

close c1
deallocate c1

--第四阶
declare @HeadItem4 int,@sum4 decimal(28,10)
          declare c1 cursor for
select HeadItem4,SUM(FAuxQty4*isnull(FPrice4,Amount4)) from #ATemp where HeadItem4 is not null group by HeadItem4
          open c1
          fetch next from c1 into @HeadItem4,@sum4
          while @@fetch_status=0
begin 

    set @error=0
	set @a=0
    declare order_cursor cursor 
    for (select 1 from #ATemp where HeadItem4=@HeadItem4)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @Data
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态
        begin     
		set @a+=1

		if @a=1 
	update #ATemp set Amount3=@sum4 where current of order_cursor
	else update #ATemp set BodyItem3=null,FAuxQty3=null,Amount3=null where current of order_cursor
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @Data
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标

fetch next from c1 into @HeadItem4,@sum4
end

close c1
deallocate c1

--第三阶
declare @HeadItem3 int,@sum3 decimal(28,10)
          declare c1 cursor for
select HeadItem3,SUM(FAuxQty3*isnull(FPrice3,Amount3)) from #ATemp where HeadItem3 is not null group by HeadItem3
          open c1
          fetch next from c1 into @HeadItem3,@sum3
          while @@fetch_status=0
begin 

    set @error=0
	set @a=0
    declare order_cursor cursor 
    for (select 1 from #ATemp where HeadItem3=@HeadItem3)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @Data
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态
        begin     
		set @a+=1

		if @a=1 
	update #ATemp set Amount2=@sum3 where current of order_cursor
	else update #ATemp set BodyItem2=null,FAuxQty2=null,Amount2=null where current of order_cursor
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @Data
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标

fetch next from c1 into @HeadItem3,@sum3 
end

close c1
deallocate c1

--第二阶
declare @HeadItem2 int,@sum2 decimal(28,10)
          declare c1 cursor for
select HeadItem2,SUM(FAuxQty2*isnull(FPrice2,Amount2)) from #ATemp where HeadItem2 is not null group by HeadItem2
          open c1
          fetch next from c1 into @HeadItem2,@sum2
          while @@fetch_status=0
begin 

    set @error=0
	set @a=0
    declare order_cursor cursor 
    for (select 1 from #ATemp where HeadItem2=@HeadItem2)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @Data
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态
        begin     
		set @a+=1

		if @a=1 
	update #ATemp set Amount1=@sum2 where current of order_cursor
	else update #ATemp set BodyItem1=null,FAuxQty1=null,Amount1=null where current of order_cursor
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @Data
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标

fetch next from c1 into @HeadItem2,@sum2
end
close c1
deallocate c1

--第一阶
declare @HeadItem1 int,@sum1 decimal(28,10)
          declare c1 cursor for
select HeadItem1,SUM(FAuxQty1*isnull(FPrice1,Amount1)) from #ATemp where HeadItem1 is not null group by HeadItem1
          open c1
          fetch next from c1 into @HeadItem1,@sum1
          while @@fetch_status=0
begin 

    set @error=0
	set @a=0
    declare order_cursor cursor 
    for (select 1 from #ATemp where HeadItem1=@HeadItem1)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @Data
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态
        begin     
		set @a+=1

		if @a=1 
	update #ATemp set Amount0=@sum1 where current of order_cursor
	else update #ATemp set HeadItem0=null,Amount0=null where current of order_cursor
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @Data
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标

fetch next from c1 into @HeadItem2,@sum2
end
close c1
deallocate c1

end

select HeadItem0,Amount0,BodyItem1,FAuxQty1,FPrice1,Amount1,BodyItem2,FAuxQty2,FPrice2,Amount2,BodyItem3,FAuxQty3,FPrice3,Amount3,BodyItem4,FAuxQty4,FPrice4,Amount4,BodyItem5,FAuxQty5,FPrice5,Amount5 from #ATemp

end--存储过程

select * from tempdb.dbo.sysobjects where name like N'%#ATemp%' and type='U'