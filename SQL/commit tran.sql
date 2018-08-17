--Create Table  
Create table BulkTestTable(  
Id int primary key,  
UserName nvarchar(32),  
Pwd varchar(16))

CREATE TYPE BulkUdt AS TABLE  
  (Id int,  
   UserName nvarchar(32),  
   Pwd varchar(16))


truncate table t_chanpinxilie

select *from t_chanpinxilie

insert into t_MyUserAccount values('administrator',8,GETDATE(),1,null)

select mu.id,username,CreateDate,FDescription from t_MyUserAccount mu join t_User u on mu.username=u.FName where 1=1

insert into t_PlugUserRole select '产品系列',GETDATE(),u.id,'' from t_MyUserAccount u where u.username=''
select r.id,RoleName,r.CreateDate,u.username,Remark from t_PlugUserRole r left join t_MyUserAccount u on r.Creator=u.id


insert into t_PlugWebPage values('PR','工序汇报')
insert into t_PlugWebPage values('CPXL','产品系列')

select *from t_PlugWebPage where 1=1 and (EName like '%%' or CName like '%%')

insert into t_PlugUserPermission select 1,1,1

declare @error int
begin tran 
exec ('select *from t_PlugUserPermissio')
select @error=@@ERROR
print @error
if (@error!=0)
rollback tran
else
commit tran

begin tran
begin try 
insert into t_PlugWebPage values ('1','2')
exec ('select *from t_PlugUserPermissio')
end try
begin catch
rollback tran
select 1/0
return
end catch
commit tran

select '111' from t_PlugWebPage where id=15