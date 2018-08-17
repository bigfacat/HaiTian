
drop table t_chanpinxilie
create table t_chanpinxilie
(
id int identity(1,1),
xilieID int ,
childmatID int,
supID int,
[status] int null
)

drop table t_AccountStatus
create table t_AccountStatus
(
id int identity(1,1),
year int,
[month] int,
status int,
)

 if exists ( select name from sysobjects where name='t_GXHB' and type='U')
 drop table t_GXHB
CREATE TABLE t_GXHB(
	[FInterID] [int] NOT NULL DEFAULT (0),
	[FBillNo] [varchar](255) NOT NULL,
	[FTranType] [int] NOT NULL DEFAULT (0),
	[FDate] [datetime] NULL,
	[FBillerID] [int] NOT NULL DEFAULT (0),
	[FCheckerID] [int] NULL,
	[FCheckDate] [datetime] NULL,
	[FStatus] [smallint] NOT NULL DEFAULT (0),
	[FCancellation] [bit] NOT NULL DEFAULT (0),
	[FAuxQtyPlan] [decimal](28, 10) NOT NULL DEFAULT (0),
	[FTaskDispBillID] [int] NOT NULL DEFAULT (0),
	[FWBNO] [varchar](255) NULL,
	[FOperAuxQtyFinishTotal] [decimal](28, 10) NOT NULL DEFAULT (0),
	[FCheckStatus] [int] NOT NULL DEFAULT (1059),
	[FClassTypeID] [int] NOT NULL DEFAULT (52),
	IsThrown int default 0,
 CONSTRAINT [PK_GXHB] PRIMARY KEY CLUSTERED 
(
	[FInterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

 if exists ( select name from sysobjects where name='t_GXHBEntry' and type='U')
 drop table t_GXHBEntry
CREATE TABLE t_GXHBEntry(
	[FinterID] [int] NOT NULL DEFAULT (0),
	[FEntryID] [int] NOT NULL DEFAULT (0),
	[Fstatus] [int] NOT NULL DEFAULT (0),
	[FworkerID] [int] NOT NULL DEFAULT (0),
	[FdeviceID] [int] NOT NULL DEFAULT (0),
	[FteamID] [int] NOT NULL DEFAULT (0),
	[FstartWorkDate] [datetime] NULL,
	[FEndWorkDate] [datetime] NULL,
	[FAuxQtyfinish] [decimal](28, 10) NOT NULL DEFAULT (0),
	[FTimeMachine] [decimal](28, 10) NOT NULL DEFAULT (0),
	[FTeamtimeID] [int] NOT NULL DEFAULT (0),
	[FEntryIndex] [int] IDENTITY(1,1) NOT NULL,
	[FIsLastReport] [int] NOT NULL DEFAULT (1059),
	[FOperGroupID] [int] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_GXHBEntry] PRIMARY KEY NONCLUSTERED 
(
	[FEntryIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

 if exists ( select name from sysobjects where name='t_MyUserAccount' and type='U')
 drop table t_MyUserAccount
CREATE TABLE t_MyUserAccount(
id int primary key identity(1,1),
username nvarchar(20) not null,
[password] varchar(50) not null,
CreateDate datetime,
Creator int,
BelongToRole int
)
insert into t_MyUserAccount(username,password,CreateDate) values('Administrator','88',GETDATE())

if exists ( select name from sysobjects where name='t_PlugUserRole' and type='U')
drop table t_PlugUserRole
create table t_PlugUserRole
(
id int primary key identity(1,1),
RoleName nvarchar(20) not null,
CreateDate datetime,
Creator int,
Remark varchar(50)
)

if exists ( select name from sysobjects where name='t_PlugUserPermission' and type='U')
drop table t_PlugUserPermission
create table t_PlugUserPermission
(
id int primary key identity(1,1),
RoleID int not null,
ResourceID int not null,
ResourceType int not null,--资源类型--1页面,2按钮
)

if exists ( select name from sysobjects where name='t_PlugWebPage' and type='U')
drop table t_PlugWebPage
create table t_PlugWebPage
(
id int primary key identity(1,1),
EName varchar(20) not null,
CName varchar(20) not null,
)

insert into t_PlugWebPage values('User','用户管理')
insert into t_PlugWebPage values('PR','工序汇报')
insert into t_PlugWebPage values('CPXL','产品系列')
insert into t_PlugWebPage values('Ａ','薪资期间管理')
insert into t_PlugWebPage values('CSR','薪资计算')
insert into t_PlugWebPage values('SE','工段人员比例维护')


if exists ( select name from sysobjects where name='t_SectionEmpMapping' and type='U')
drop table t_SectionEmpMapping
CREATE TABLE t_SectionEmpMapping(
id int primary key identity(1,1),
[year] int not null,
[month] int not null,
section int not null,
emp int not null,
rate decimal(8,3) not null
)

 if exists ( select name from sysobjects where name='t_ImportLeaveData' and type='U')
 drop table t_ImportLeaveData
CREATE TABLE t_ImportLeaveData(
[year] int not null,
[month] int not null,
EmpID int not null,
[LeaveHours] decimal(4,1) not null,
)

--为了快速保存产品系列对应供应商而建立的表值类型
drop type SaveCPXLType
create type SaveCPXLType as table
(
col1 varchar(20),
col2 varchar(50),
col3 varchar(20)
)

if exists ( select name from sysobjects where name='t_PlugResource' and type='U')
drop table t_PlugResource
CREATE TABLE t_PlugResource(
id int primary key identity(1,1),
code varchar(20) not null,
name varchar(20) not null,
WebPage varchar(20) not null,
)
insert into t_PlugResource(code,name,WebPage) values('review','审核','CPXL')
insert into t_PlugResource(code,name,WebPage) values('cancel-review','反审核','CPXL')