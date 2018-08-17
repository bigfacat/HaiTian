select *from t_PlugUserPermission

insert into t_PlugUserPermission values (1,1,1)

delete from t_PlugUserRole where RoleName=''
select *from t_PlugUserRole

declare @userid int=1,@roleid int=1
select @userid=id from t_MyUserAccount where username=''
select @roleid=id from t_PlugUserRole where RoleName=''
delete  from t_MyUserAccount where id=8

insert into t_MyUserAccount(username,password) values ('administrator','8')
insert into t_PlugUserRole values('',GETDATE(),1,'')

delete from t_PlugWebPage where EName='1'

update t_PlugUserRole set rolename='admin'

select * from t_PlugUserRole where RoleName='cx'
select* from t_PlugUserPermission where RoleID=3

begin tran begin try declare @id int select @id=id from t_PlugUserRole where RoleName='cx' delete from t_PlugUserPermission where RoleID=@id insert into t_PlugUserPermission select @id,1,1 insert into t_PlugUserPermission select @id,2,1 end try begin catch rollback tran select 1 / 0 return end catch commit tran

select *from t_PlugWebPage wp where exists (select * from t_PlugUserRole ur
join (select *from t_PlugUserPermission where Permission=1) up on up.RoleID=ur.id
where RoleName = 'cx' and wp.id=up.WebPage)


update t_PlugUserRole set Remark='' where id=0


select * from t_MyUserAccount ua
join t_PlugUserRole ur on ua.BelongToRole=ur.id
join t_PlugUserPermission up on ur.id=up.RoleID
join t_PlugWebPage wp on up.WebPage=wp.id
where ua.username='administrator' and EName='User'

update t_MyUserAccount set BelongToRole=3


select mu.id,mu.username,mu.CreateDate,ua.username as creator,ur.RoleName,FDescription from t_MyUserAccount mu
join t_User u on mu.username=u.FName
left join t_MyUserAccount ua on mu.Creator=ua.id
left join t_PlugUserRole ur on mu.BelongToRole=ur.id where 1=1


select 1 from t_PlugUserRole ur join t_MyUserAccount ua on ur.id=ua.BelongToRole where RoleName=''

update t_MyUserAccount set BelongToRole=ur.id from (select *from t_PlugUserRole where RoleName='')ur where username='administrator'

select *from t_MyUserAccount

select *from t_PlugUserRole where RoleName=''

select *from t_PlugUserRole
insert into t_PlugUserRole(RoleName,CreateDate,Creator,Remark) values ('admin',GETDATE(),1,null)

select *from t_PlugUserPermission
select *from t_PlugWebPage

insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('Administrator',88,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('»Æ·¼À¼',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('×Þ°®Ãñ',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('ÔøÁî±ó',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('Ðì»¶»¶',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('¹ùÃô',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('Íõ¹úÐË',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('ËÕÃ÷ÇÙ',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('²Üºç',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('ÐìÎÄ¾ê',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('³ÂÊÀºê',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('Öì²Ê',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('ÁÖ½¨Ã÷',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('Ò¦Óî½à',123456,GETDATE(),1,1)
insert into t_MyUserAccount(username,[password],CreateDate,Creator,BelongToRole) values('ÕÅ¼Ñ',123456,GETDATE(),1,1)


select id,1 as ResourceTypeID,'Ò³Ãæ' as ResourceType,EName,CName,null as WebPage from t_PlugWebPage union select id,2 as ResourceTypeID,'°´Å¥' as ResourceType,code,name,WebPage from t_PlugResource

select *from t_PlugResource
select id,RoleID,ResourceID,ResourceType,*from t_PlugUserPermission

select up.id,ur.RoleName,EName,CName,WebPage from t_PlugUserRole ur
join t_PlugUserPermission up on up.RoleID = ur.id
join (select id,1 as ResourceTypeID,'Ò³Ãæ' as ResourceType,EName,CName,null as WebPage from t_PlugWebPage union
select id,2 as ResourceTypeID,'°´Å¥' as ResourceType,code,name,WebPage from t_PlugResource) res on res.id = up.ResourceID and res.ResourceTypeID=up.ResourceType
where 1 = 1