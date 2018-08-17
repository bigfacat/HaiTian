using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using ConsoleApplication1;
using System.Web.Services;
using Newtonsoft.Json;
using DataAccess;
using System.Web.Script.Serialization;
using System.Collections;
using NPOI.SS.UserModel;
using System.IO;
using NPOI.XSSF.UserModel;

namespace ConsoleApplication1
{
    /// <summary>
    /// Class1 的摘要说明
    /// </summary>
    public class Class1
    {
        public Class1()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        public static DataTable GetPrdCapacity(string workshop, string line,string fnumber)
        {
            switch (line)
            {
                case "all": line = ""; break;
            }

            switch (workshop)
            {
                case "all": workshop = ""; break;
            }


            string sql = @"select  p.*,b.FBASEUNITID,mp.FPRODUCEUNITID,case mp.FPERUNITSTANDHOUR when 0 then 0 when null then 0 else convert(decimal(10,4),3600/mp.FPERUNITSTANDHOUR) end as StandCapacity,d.FNUMBER as unitname,c.FNAME,a.FMATERIALID,a.FNUMBER+'|'+c.FNAME as productionname,t0.FNUMBER,FDATAVALUE,t0.FMASTERID,t0.FNUMBER+' '+FDATAVALUE as strline from prdcapacity p
join T_BD_MATERIAL a on p.production = a.FMATERIALID
join T_BD_MATERIALBASE b on a.FMATERIALID = b.FMATERIALID
join T_BD_MATERIALPRODUCE mp on a.FMATERIALID=mp.FMATERIALID
join T_BD_MATERIAL_L c on b.FMATERIALID = c.FMATERIALID
left join T_BAS_ASSISTANTDATAENTRY t0 on t0.FMASTERID=p.line
left join T_BAS_ASSISTANTDATA t on t.FID=t0.FID 
left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID = t0_L.FENTRYID
left join T_BD_UNIT d on mp.FPRODUCEUNITID = d.FUNITID where 1=1 and t.FNUMBER = '001'";
            if (workshop.ToString() != "")
            {
                sql = sql + " and workshop='" + workshop + "'";
            }

            if (line.ToString() != "")
            {
                sql = sql + " and line='" + line + "'";
            }

            if (fnumber.ToString() != "")
            {
                sql = sql + " and (a.FNUMBER like '%" + fnumber + "%' or c.FNAME like '%" + fnumber + "%')";
            }

            sql = sql + " order by workshop,strline";

            return Program.GetDataTableBySqlText(sql);
        }

        public static bool SaveCapacity(string workshop, string line,string production,string unit,string workersnum,string hours,string capacity)
        {
            string sql = @"insert into prdcapacity(workshop,line,production,unit,workersnum,hours,capacity) values('" + workshop + "','" + line + "','" + production + "','" + unit + "','" + workersnum + "','" + hours + "','" + capacity + "')";
            return Program.ExecDataBySqlText(sql);

        }
        public static bool UpdateCapacity(string id, string workshop, string line, string production, string unit, string workersnum, string hours, string capacity)
        {
            string sql = @"update prdcapacity set workshop='" + workshop + "',line='" + line + "',production='" + production + "',unit='" + unit + "',workersnum='" + workersnum + "',hours='" + hours + "',capacity='" + capacity + "' where id='"+id+"'";
            return Program.ExecDataBySqlText(sql);

        }

        public static DataTable GetPrdDetails(string prdno)
        {
            string sql = @"select  b.FBASEUNITID,mp.FPRODUCEUNITID,case mp.FPERUNITSTANDHOUR when 0 then 0 when null then 0 else convert(decimal(10,2),3600/mp.FPERUNITSTANDHOUR) end as StandCapacity,d.FNUMBER as unitname,c.FNAME,a.FMATERIALID,a.FNUMBER+'|'+c.FNAME as productionname from T_BD_MATERIAL a
join T_BD_MATERIALBASE b on a.FMATERIALID = b.FMATERIALID
join T_BD_MATERIALPRODUCE mp on a.FMATERIALID=mp.FMATERIALID
join T_BD_MATERIAL_L c on b.FMATERIALID = c.FMATERIALID
left join T_BD_UNIT d on mp.FPRODUCEUNITID = d.FUNITID
where a.FNUMBER = '" + prdno+"'";

            return Program.GetDataTableBySqlText(sql);
        }

        public static bool DeleteCapacity(List<int> id)
        {
            string sql = "delete from prdcapacity where id in("+id[0];
            for (int i=1;i< id.Count;i++) {
                sql= sql+" ," + id[i] + "";
            }
            sql = sql + ")";

            return Program.ExecDataBySqlText(sql);
        }

        public static DataTable MOInitialization()
        {
            string strSql = @"select c.FNAME as cusName , me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno  as TaskOrder, m.FNUMBER ,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum' ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE,
 isnull(sed.FPLANDELIVERYDATE,me.FPLANFINISHDATE) as deliverydate,ma.FSTATUS,ppd.*,
pc.workersnum,pc.hours,pc.capacity,me.F_PAEZ_ASSISTANT,t0_L.FDATAVALUE,t0.FNUMBER+' '+t0_L.FDATAVALUE as line,pp.*,ppl.diff,
cast((x.inqty-x.reqty) AS decimal(18,2)) as finishqty
from T_PRD_MOENTRY me 
 join T_PRD_MO mo on mo.fid = me.fid
 join T_PRD_MOENTRY_A ma on me.FID=ma.FID and me.fentryid=ma.fentryid
 left join (select o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o 
 join t_sal_orderentry b on o.FID = b.FID ) sed on sed.FBILLNO = me.fsrcbillno and me.fsrcbillentryseq = sed.FSEQ 
 left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID 
 join[T_BD_MATERIAL] m on m.FMATERIALID = me.FMATERIALID 
 join T_BD_MATERIAL_L ml on ml.FMATERIALID = me.FMATERIALID
left join T_BAS_ASSISTANTDATAENTRY t0 on me.F_PAEZ_ASSISTANT=t0.FMASTERID
left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID=t0_L.FENTRYID
left join prdcapacity pc on me.F_PAEZ_ASSISTANT=pc.line and me.FMATERIALID=pc.production
left join ProductionPlan pp on 1=0
left join ProductionPlanDetail ppd on 1=0
left join ProductionPlanLock ppl on 1=0
join(
select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0)) as inqty,sum(isnull(resy.FREALQTY,0)) as reqty from T_PRD_MO mo
join T_PRD_MOENTRY me on mo.FID=me.FID
left join T_PRD_INSTOCKENTRY insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
left join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID
left join T_PRD_RESTOCKENTRY resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
left join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A') res on res.FID=resy.FID
where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ
where ma.FSTATUS in (3,4) order by me.F_PAEZ_ASSISTANT, deliverydate";
            DataTable dtResult = Program.GetDataTableBySqlText(strSql);
            return dtResult;
        }

        public static DataTable GetProductionPlanDetails(string workshop,string line,string versiondate,int versionno,int versionid,int diff)
        {
            string str = "";
            if (diff == 0)
            {
                str = ",ppd.*";
            }
            else
            {
                str =",ppd.id,ppd.orderid,ppd.detailid,ppd.mono,ppd.sumplan";
                for (int i = 0; i <= (34-diff); i++)
                {
                    str = str + ",col" + (diff + i) + "_1 as col" + i + "_1,col" + (diff + i) + "_2 as col" + i + "_2,col" + (diff + i) + "_3 as col" + i + "_3";

                }
                for (int i = 34; i > (34 - diff); i--)
                {
                    str = str + ",null as col" + i + "_1" + ",null as col" + i + "_2" + ",null as col" + i + "_3";
                }
            }

            string strsql = "sum(SumPlan) as sumplan";
            for (int i = 0; i <= 34; i++)
            {
                strsql = strsql + ",convert(decimal(10,1),sum(isnull(col" + i + "_1,0))) as col" + i + "_1,convert(decimal(10,4),sum(isnull(col" + i + "_2,0))) as col" + i + "_2,convert(decimal(18,4),sum(isnull(col" + i + "_3,0))) as col" + i + "_3";
            }

            string wheresql = "where 1=1";
            if (workshop.ToString() != "")
            {
                wheresql = wheresql + " and pp.workshop='" + workshop + "'";
            }

            if (line.ToString() != "")
            {
                wheresql = wheresql + " and t0.FMASTERID='" + line + "'";
            }

            if (versiondate.ToString() != "")
            {
                wheresql = wheresql + " and pp.VersionDate='" + versiondate + "'";
            }

            if (versionno != 0)
            {
                wheresql = wheresql + " and pp.VersionNo=" + versionno;
            }

            if (versionid != 0)
            {
                wheresql = wheresql + " and pp.VersionID=" + versionid;
            }

            string pplsql = "";
            for (int i = 0; i <= 34; i++)
            {
                pplsql += ",ppl.col" + i;
            }

            string strsql2 = "";
            for (int i = 0; i <= 34; i++)
            {
                strsql2 += ",null as col" + i;
            }

            string sql = @"with temp as(select sed.F_PAEZ_TEXT as PO,me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno as TaskOrder,motype.FNAME as fbilltype, m.FNUMBER ,sed.FCUSTMATNO,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum' ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE,
 isnull(sed.FPLANDELIVERYDATE,me.FPLANFINISHDATE) as deliverydate,ma.FSTATUS,pc.workersnum,pc.hours,pc.capacity,me.F_PAEZ_ASSISTANT,t0_L.FDATAVALUE,pp.VersionID,pp.workshop,pp.VersionDate,pp.VersionNo,t0.FMASTERID,t0.FNUMBER+' '+t0_L.FDATAVALUE as line,cast((x.inqty-x.reqty) AS decimal(18,2)) as finishqty" + str+pplsql+ @"
from ProductionPlan pp 
 join ProductionPlanDetail ppd on pp.detailid=ppd.detailid
left join ProductionPlanLock ppl on pp.versionid=ppl.versionid and ppd.mono=ppl.mono
 join T_PRD_MO mo on mo.fbillno=ppd.mono
join T_PRD_MOENTRY me on mo.fid = me.fid
 join T_PRD_MOENTRY_A ma on me.FID=ma.FID and me.fentryid=ma.fentryid
join (select *from T_BAS_BILLTYPE_L where FLOCALEID=2052) motype on mo.FBILLTYPE=motype.FBILLTYPEID
 left join prdcapacity pc on me.F_PAEZ_ASSISTANT=pc.line and me.FMATERIALID=pc.production
 left join (select FCUSTMATNO,o.F_PAEZ_TEXT,o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o 
 join t_sal_orderentry b on o.FID = b.FID left join T_SAL_CUSTMATMAPPINGENTRY cme on FMAPID=convert(nvarchar(10),cme.FID)+'&'+convert(nvarchar(10),cme.FENTRYID)
+'&'+convert(nvarchar(10),FSALEORGID) ) sed on sed.FBILLNO = me.fsrcbillno and me.fsrcbillentryseq = sed.FSEQ 
 left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID 
 join[T_BD_MATERIAL] m on m.FMATERIALID = me.FMATERIALID 
 join T_BD_MATERIAL_L ml on ml.FMATERIALID = me.FMATERIALID
left join T_BAS_ASSISTANTDATAENTRY t0 on me.F_PAEZ_ASSISTANT=t0.FMASTERID
left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID=t0_L.FENTRYID
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
join (select d.FDEPTID,dl.FNAME from T_BAS_ASSISTANTDATAENTRY ade 
  join T_BAS_ASSISTANTDATAENTRY_L adel
  on ade.FENTRYID=adel.FENTRYID
  join T_BD_DEPARTMENT d  on d.FDEPTPROPERTY=ade.FMASTERID
  join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
  where adel.FDATAVALUE = '基本生产部门') y on d.FDEPTID=y.FDEPTID
join(
select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0)) as inqty,sum(isnull(resy.FREALQTY,0)) as reqty,cast(sum(isnull(insy.FREALQTY,0))-sum(isnull(resy.FREALQTY,0)) as decimal(18,2) ) as finishqty from T_PRD_MO mo
join T_PRD_MOENTRY me on mo.FID=me.FID
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_INSTOCKENTRY insy 
 join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID)insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_RESTOCKENTRY resy 
 join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C') res on res.FID=resy.FID)resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ " + wheresql+ @")
 select null as PO,'' as SEOrder,null as FSEQ,null as FQTY,'' as TaskOrder,null as fbilltype,'' as FNUMBER,null as FCUSTMATNO,'' as MaterialName,null as TaskOrderNum,null as FPLANDELIVERYDATE,
 null as deliverydate,null as FSTATUS,null as workersnum,null as hours,null as capacity,F_PAEZ_ASSISTANT,'' as FDATAVALUE,null as VersionID,null as workshop,null as VersionDate,null as VersionNo,null as FMASTERID,'' as line,null as finishqty,null as id,null as orderid,null as detailid,'' as mono," + strsql+ strsql2 + @" from temp group by F_PAEZ_ASSISTANT
 union all select * from temp";

           sql = sql + " order by F_PAEZ_ASSISTANT,orderid desc, deliverydate";

            DataTable dtResult = Program.GetDataTableBySqlText(sql);
            return dtResult;
        }

//        public static DataTable UpdateMO(string workshop, string line, int versionid, int diff)
//        {
//            string str = "";
//            if (diff == 0)
//            {
//                str = ",a.id,a.orderid,a.detailid,a.mono,a.sumplan";

//                for (int i = 0; i <= 34; i++)
//                {
//                    str += ",col" + i + "_1" + ",col" + i + "_2" + ",col" + i + "_3";
//                }

//            }
//            else
//            {
//                str = ",a.id,a.orderid,a.detailid,a.mono,a.sumplan";
//                for (int i = 0; i <= (34 - diff); i++)
//                {
//                    str = str + ",col" + (diff + i) + "_1 as col" + i + "_1,col" + (diff + i) + "_2 as col" + i + "_2,col" + (diff + i) + "_3 as col" + i + "_3";

//                }
//                for (int i = 34; i > (34 - diff); i--)
//                {
//                    str = str + ",null as col" + i + "_1" + ",null as col" + i + "_2" + ",null as col" + i + "_3";
//                }
//            }

//            string strsql = "sum(SumPlan) as sumplan";
//            for (int i = 0; i <= 34; i++)
//            {
//                strsql = strsql + ",convert(decimal(10,1),sum(isnull(col" + i + "_1,0))) as col" + i + "_1,convert(decimal(10,4),sum(isnull(col" + i + "_2,0))) as col" + i + "_2,convert(decimal(18,4),sum(isnull(col" + i + "_3,0))) as col" + i + "_3";
//            }

//            string pplsql = "";
//            for (int i = 0; i <= 34; i++)
//            {
//                pplsql += ",col" + i;
//            }

//            string strsql2 = "";
//            for (int i = 0; i <= 34; i++)
//            {
//                strsql2 += ",null as col" + i;
//            }

//            string wheresql = "where FCANCELSTATUS='A' and ma.FSTATUS in (3,4,5) and finishqty<me.FQTY";
//            if (workshop.ToString() != "")
//            {
//                wheresql = wheresql + " and dl.FNAME='" + workshop + "'";
//            }

//            if (line.ToString() != "")
//            {
//                wheresql = wheresql + " and t0.FMASTERID='" + line + "'";
//            }


//            string sql = @"declare @maxid int select @maxid=isnull(max(versionid),0) from ProductionPlan;with temp as(
//select me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno as TaskOrder,motype.FNAME as fbilltype, m.FNUMBER ,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum' ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE,
// isnull(sed.FPLANDELIVERYDATE,me.FPLANFINISHDATE) as deliverydate,ma.FSTATUS,pc.workersnum,pc.hours,pc.capacity,me.F_PAEZ_ASSISTANT,t0_L.FDATAVALUE,a.VersionID,a.VersionDate,a.VersionNo,t0.FMASTERID,t0.FNUMBER+' '+t0_L.FDATAVALUE as line,finishqty" + str + pplsql + @"
//from (select *from T_PRD_MO)mo
//join T_PRD_MOENTRY me on mo.fid = me.fid
// join T_PRD_MOENTRY_A ma on me.FID=ma.FID and me.fentryid=ma.fentryid
//join (select *from T_BAS_BILLTYPE_L where FLOCALEID=2052) motype on mo.FBILLTYPE=motype.FBILLTYPEID
// left join prdcapacity pc on me.F_PAEZ_ASSISTANT=pc.line and me.FMATERIALID=pc.production
// left join (select o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o 
// join t_sal_orderentry b on o.FID = b.FID ) sed on sed.FBILLNO = me.fsrcbillno  and me.fsrcbillentryseq = sed.FSEQ 
// left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID 
// join[T_BD_MATERIAL] m on m.FMATERIALID = me.FMATERIALID 
// join T_BD_MATERIAL_L ml on ml.FMATERIALID = me.FMATERIALID
//left join T_BAS_ASSISTANTDATAENTRY t0 on me.F_PAEZ_ASSISTANT=t0.FMASTERID
//left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID=t0_L.FENTRYID
//join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
//join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
//join 
//(select d.FDEPTID,dl.FNAME from T_BAS_ASSISTANTDATAENTRY ade 
//  join T_BAS_ASSISTANTDATAENTRY_L adel
//  on ade.FENTRYID=adel.FENTRYID
//  join T_BD_DEPARTMENT d  on d.FDEPTPROPERTY=ade.FMASTERID
//  join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
//  where adel.FDATAVALUE = '基本生产部门') y on d.FDEPTID=y.FDEPTID
//join
//(select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0)) as inqty,sum(isnull(resy.FREALQTY,0)) as reqty,cast(sum(isnull(insy.FREALQTY,0))-sum(isnull(resy.FREALQTY,0)) as decimal(18,2) ) as finishqty from T_PRD_MO mo
//join T_PRD_MOENTRY me on mo.FID=me.FID
//left join T_PRD_INSTOCKENTRY insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
//left join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID
//left join T_PRD_RESTOCKENTRY resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
//left join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A') res on res.FID=resy.FID
//where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ
//left join
//(select ppd.*,pp.VersionID,pp.VersionDate,pp.VersionNo" + pplsql+ @" from ProductionPlan pp join ProductionPlanDetail ppd on pp.detailid=ppd.detailid left join ProductionPlanLock ppl on pp.versionid=ppl.versionid and ppd.mono=ppl.mono where pp.versionid=@maxid) a on mo.fbillno=a.mono " + wheresql + @")
//select '' as SEOrder,null as FSEQ,null as FQTY,'' as TaskOrder,null as fbilltype,'' as FNUMBER,'' as MaterialName,null as TaskOrderNum,null as FPLANDELIVERYDATE,
// null as deliverydate,null as FSTATUS,null as workersnum,null as hours,null as capacity,F_PAEZ_ASSISTANT,'' as FDATAVALUE,null as VersionID,null as VersionDate,null as VersionNo,null as FMASTERID,'' as line,null as finishqty,null as id,null as orderid,null as detailid,'' as mono," + strsql + strsql2 + @" from temp group by F_PAEZ_ASSISTANT
// union all select * from temp";

//            sql = sql + " order by F_PAEZ_ASSISTANT,TaskOrder desc, deliverydate";

//            DataTable dtResult = Program.GetDataTableBySqlText(sql);
//            return dtResult;
//        }

        public static DataTable UpdateMO(string workshop, string line, int versionid, int diff)
        {
            string str = "";
            if (diff == 0)
            {
                str = ",a.id,a.orderid,a.detailid,a.mono,a.sumplan";

                for (int i = 0; i <= 34; i++)
                {
                    str += ",col" + i + "_1" + ",col" + i + "_2" + ",col" + i + "_3";
                }

            }
            else
            {
                str = ",a.id,a.orderid,a.detailid,a.mono,a.sumplan";
                for (int i = 0; i <= (34 - diff); i++)
                {
                    str = str + ",col" + (diff + i) + "_1 as col" + i + "_1,col" + (diff + i) + "_2 as col" + i + "_2,col" + (diff + i) + "_3 as col" + i + "_3";

                }
                for (int i = 34; i > (34 - diff); i--)
                {
                    str = str + ",null as col" + i + "_1" + ",null as col" + i + "_2" + ",null as col" + i + "_3";
                }
            }

            string pplsql = "";
            for (int i = 0; i <= 34; i++)
            {
                pplsql += ",col" + i;
            }


            string wheresql = "where FCANCELSTATUS='A' and ma.FSTATUS in (3,4,5) and finishqty<me.FQTY";
            if (workshop.ToString() != "")
            {
                wheresql = wheresql + " and dl.FNAME='" + workshop + "'";
            }

            if (line.ToString() != "")
            {
                wheresql = wheresql + " and t0.FMASTERID='" + line + "'";
            }


            string sql = @"declare @maxid int select @maxid=isnull(max(versionid),0) from ProductionPlan;with temp as(
select sed.F_PAEZ_TEXT as PO,me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno as TaskOrder,motype.FNAME as fbilltype, m.FNUMBER,sed.FCUSTMATNO,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum' ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE,
 isnull(sed.FPLANDELIVERYDATE,me.FPLANFINISHDATE) as deliverydate,ma.FSTATUS,pc.workersnum,pc.hours,pc.capacity,me.F_PAEZ_ASSISTANT,t0_L.FDATAVALUE,a.VersionID,a.VersionDate,a.VersionNo,t0.FMASTERID,t0.FNUMBER+' '+t0_L.FDATAVALUE as line,finishqty" + str + pplsql + @"
from (select *from T_PRD_MO)mo
join T_PRD_MOENTRY me on mo.fid = me.fid
 join T_PRD_MOENTRY_A ma on me.FID=ma.FID and me.fentryid=ma.fentryid
join (select *from T_BAS_BILLTYPE_L where FLOCALEID=2052) motype on mo.FBILLTYPE=motype.FBILLTYPEID
 left join prdcapacity pc on me.F_PAEZ_ASSISTANT=pc.line and me.FMATERIALID=pc.production
 left join (select FCUSTMATNO,o.F_PAEZ_TEXT,o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o 
 join t_sal_orderentry b on o.FID = b.FID left join T_SAL_CUSTMATMAPPINGENTRY cme on FMAPID=convert(nvarchar(10),cme.FID)+'&'+convert(nvarchar(10),cme.FENTRYID)
+'&'+convert(nvarchar(10),FSALEORGID) ) sed on sed.FBILLNO = me.fsrcbillno  and me.fsrcbillentryseq = sed.FSEQ 
 left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID 
 join[T_BD_MATERIAL] m on m.FMATERIALID = me.FMATERIALID 
 join T_BD_MATERIAL_L ml on ml.FMATERIALID = me.FMATERIALID
left join T_BAS_ASSISTANTDATAENTRY t0 on me.F_PAEZ_ASSISTANT=t0.FMASTERID
left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID=t0_L.FENTRYID
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
join 
(select d.FDEPTID,dl.FNAME from T_BAS_ASSISTANTDATAENTRY ade 
  join T_BAS_ASSISTANTDATAENTRY_L adel
  on ade.FENTRYID=adel.FENTRYID
  join T_BD_DEPARTMENT d  on d.FDEPTPROPERTY=ade.FMASTERID
  join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
  where adel.FDATAVALUE = '基本生产部门') y on d.FDEPTID=y.FDEPTID
join
(select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0)) as inqty,sum(isnull(resy.FREALQTY,0)) as reqty,cast(sum(isnull(insy.FREALQTY,0))-sum(isnull(resy.FREALQTY,0)) as decimal(18,2) ) as finishqty from T_PRD_MO mo
join T_PRD_MOENTRY me on mo.FID=me.FID
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_INSTOCKENTRY insy 
 join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID)insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_RESTOCKENTRY resy 
 join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C') res on res.FID=resy.FID)resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ
left join
(select ppd.*,pp.VersionID,pp.VersionDate,pp.VersionNo" + pplsql + @" from ProductionPlan pp join ProductionPlanDetail ppd on pp.detailid=ppd.detailid left join ProductionPlanLock ppl on pp.versionid=ppl.versionid and ppd.mono=ppl.mono where pp.versionid=@maxid) a on mo.fbillno=a.mono " + wheresql + @")select *from temp";

            sql = sql + " order by F_PAEZ_ASSISTANT, deliverydate";

            DataTable dtResult = Program.GetDataTableBySqlText(sql);
            return dtResult;
        }

        public static DataTable LoadTempData(string workshop, string line, int diff)
        {
            string str = "";
            if (diff == 0)
            {
                str = ",ppd.*";
            }
            else
            {
                str = ",ppd.id,ppd.orderid,ppd.detailid,ppd.mono,ppd.sumplan";

                for (int i = 0; i <= (34 - diff); i++)
                {
                    str = str + ",col" + (diff + i) + "_1 as col" + i + "_1,col" + (diff + i) + "_2 as col" + i + "_2,col" + (diff + i) + "_3 as col" + i + "_3";

                }
                for (int i = 34; i > (34 - diff); i--)
                {
                    str = str + ",null as col" + i + "_1" + ",null as col" + i + "_2" + ",null as col" + i + "_3";
                }
            }

            string strsql = "sum(SumPlan) as sumplan";
            for (int i = 0; i <= 34; i++)
            {
                strsql = strsql + ",convert(decimal(10,1),sum(isnull(col" + i + "_1,0))) as col" + i + "_1,convert(decimal(10,4),sum(isnull(col" + i + "_2,0))) as col" + i + "_2,convert(decimal(18,4),sum(isnull(col" + i + "_3,0))) as col" + i + "_3";
            }

            string pplsql = "";
            for (int i = 0; i <= 34; i++)
            {
                pplsql += ",ppl.col" + i;
            }

            string strsql2 = "";
            for (int i = 0; i <= 34; i++)
            {
                strsql2 += ",null as col" + i;
            }

            string wheresql = "where 1=1";
            if (workshop.ToString() != "")
            {
                wheresql = wheresql + " and pp.workshop='" + workshop + "'";
            }

            if (line.ToString() != "")
            {
                wheresql = wheresql + " and t0.FMASTERID='" + line + "'";
            }


            string sql = @"with temp as(select sed.F_PAEZ_TEXT as PO,me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno as TaskOrder,motype.FNAME as fbilltype, m.FNUMBER,sed.FCUSTMATNO ,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum' ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE,
 isnull(sed.FPLANDELIVERYDATE,me.FPLANFINISHDATE) as deliverydate,ma.FSTATUS,pc.workersnum,pc.hours,pc.capacity,me.F_PAEZ_ASSISTANT,t0_L.FDATAVALUE,pp.VersionID,pp.workshop,pp.VersionDate,pp.VersionNo,t0.FMASTERID,t0.FNUMBER+' '+t0_L.FDATAVALUE as line,cast((x.inqty-x.reqty) AS decimal(18,2)) as finishqty" + str+pplsql + @"
from ProductionPlan_Temp pp 
 join ProductionPlanDetail_Temp ppd on pp.detailid=ppd.detailid
left join ProductionPlanLock ppl on pp.versionid=ppl.versionid and ppd.mono=ppl.mono
 join T_PRD_MO mo on mo.fbillno=ppd.mono
join T_PRD_MOENTRY me on mo.fid = me.fid
 join T_PRD_MOENTRY_A ma on me.FID=ma.FID and me.fentryid=ma.fentryid
join (select *from T_BAS_BILLTYPE_L where FLOCALEID=2052) motype on mo.FBILLTYPE=motype.FBILLTYPEID
 left join prdcapacity pc on me.F_PAEZ_ASSISTANT=pc.line and me.FMATERIALID=pc.production
 left join (select FCUSTMATNO,o.F_PAEZ_TEXT,o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o 
 join t_sal_orderentry b on o.FID = b.FID left join T_SAL_CUSTMATMAPPINGENTRY cme on FMAPID=convert(nvarchar(10),cme.FID)+'&'+convert(nvarchar(10),cme.FENTRYID)
+'&'+convert(nvarchar(10),FSALEORGID) ) sed on sed.FBILLNO = me.fsrcbillno  and me.fsrcbillentryseq = sed.FSEQ 
 left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID 
 join[T_BD_MATERIAL] m on m.FMATERIALID = me.FMATERIALID 
 join T_BD_MATERIAL_L ml on ml.FMATERIALID = me.FMATERIALID

left join T_BAS_ASSISTANTDATAENTRY t0 on me.F_PAEZ_ASSISTANT=t0.FMASTERID
left join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID=t0_L.FENTRYID
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
join (select d.FDEPTID,dl.FNAME from T_BAS_ASSISTANTDATAENTRY ade 
  join T_BAS_ASSISTANTDATAENTRY_L adel
  on ade.FENTRYID=adel.FENTRYID
  join T_BD_DEPARTMENT d  on d.FDEPTPROPERTY=ade.FMASTERID
  join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
  where adel.FDATAVALUE = '基本生产部门') y on d.FDEPTID=y.FDEPTID
join(
select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0)) as inqty,sum(isnull(resy.FREALQTY,0)) as reqty,cast(sum(isnull(insy.FREALQTY,0))-sum(isnull(resy.FREALQTY,0)) as decimal(18,2) ) as finishqty from T_PRD_MO mo
join T_PRD_MOENTRY me on mo.FID=me.FID
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_INSTOCKENTRY insy 
 join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID)insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
left join(select FSRCBILLNO,FSRCENTRYSEQ,FREALQTY from T_PRD_RESTOCKENTRY resy 
 join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A' and FDOCUMENTSTATUS='C') res on res.FID=resy.FID)resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ " + wheresql+ @")
 select null as PO,'' as SEOrder,null as FSEQ,null as FQTY,'' as TaskOrder,null as fbilltype,'' as FNUMBER,null as FCUSTMATNO,'' as MaterialName,null as TaskOrderNum,null as FPLANDELIVERYDATE,
 null as deliverydate,null as FSTATUS,null as workersnum,null as hours,null as capacity,F_PAEZ_ASSISTANT,'' as FDATAVALUE,null as VersionID,null as workshop,null as VersionDate,null as VersionNo,null as FMASTERID,'' as line,null as finishqty,null as id,null as orderid,null as detailid,'' as mono," + strsql + strsql2 + @" from temp group by F_PAEZ_ASSISTANT
 union all select * from temp";

            sql = sql + " order by F_PAEZ_ASSISTANT,orderid desc,deliverydate";

            DataTable dtResult = Program.GetDataTableBySqlText(sql);
            return dtResult;

        }

        public static bool Mo_Change(string workshop)
        {
            string wheresql = "where mo.FCANCELSTATUS='A' and ma.FSTATUS in (3,4,5) and finishqty<me.FQTY";
            if (workshop != "")
            {
                wheresql = wheresql + " and dl.FNAME='" + workshop + "'";
            }

            string strSql = @"declare @maxid int select @maxid=isnull(max(versionid),0) from ProductionPlan where workshop='"+workshop+ @"'; with temp as(select mo.FID,FBILLNO,finishqty,cast(me.FQTY AS decimal(18,2)) as TaskOrderNum from T_PRD_MO mo join T_PRD_MOENTRY_A ma on mo.FID=ma.FID join T_PRD_MOENTRY me on mo.fid = me.fid 
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
join (
select me.FID,me.FSEQ,sum(isnull(insy.FREALQTY,0))-sum(isnull(resy.FREALQTY,0)) as finishqty from T_PRD_MO mo
join T_PRD_MOENTRY me on mo.FID=me.FID
left join T_PRD_INSTOCKENTRY insy on mo.FBILLNO= insy.FSRCBILLNO and me.FSEQ=insy.FSRCENTRYSEQ
left join (select *from T_PRD_INSTOCK where FCANCELSTATUS='A' and convert(varchar(10),FDATE,120)<>convert(varchar(10),GETDATE(),120)) ins on ins.FID=insy.FID
left join T_PRD_RESTOCKENTRY resy on mo.FBILLNO=resy.FSRCBILLNO and me.FSEQ=resy.FSRCENTRYSEQ
left join (select *from T_PRD_RESTOCK where FCANCELSTATUS='A') res on res.FID=resy.FID
where mo.FCANCELSTATUS='A' group by me.FID,me.FSEQ) x on mo.fid=x.fid and me.FSEQ=x.FSEQ " + wheresql+") select FBILLNO from temp mo join T_PRD_MOENTRY_A ma on mo.FID=ma.FID where not exists(select 1 from productionplan pp join productionplandetail ppd on pp.detailid=ppd.detailid where mo.FBILLNO=ppd.MoNo and versionid=@maxid) union select MoNo as FBILLNO from productionplan pp join productionplandetail ppd on pp.detailid=ppd.detailid where not exists(select 1 from temp mo join T_PRD_MOENTRY_A ma on mo.FID=ma.FID where mo.FBILLNO=ppd.MoNo) and versionid=@maxid";
            DataTable dtResult = Program.GetDataTableBySqlText(strSql);
            if (dtResult != null && dtResult.Rows.Count != 0)
            {
                return true;
            }
            return false;
        }

        public static DataTable GetNewMo()
        {
            string strSql = @"select FBILLNO from T_PRD_MO mo join T_PRD_MOENTRY_A ma on mo.FID=ma.FID where ma.FSTATUS=3 and not exists(select *from productionplan pp where mo.FBILLNO=pp.MoNo)
union select MoNo as FBILLNO from productionplan pp where exists(select *from T_PRD_MO mo join T_PRD_MOENTRY_A ma on mo.FID=ma.FID where ma.FSTATUS=3 and mo.FBILLNO=pp.MoNo)";
            DataTable dtResult = Program.GetDataTableBySqlText(strSql);
            return dtResult;
        }

        public static DataTable GetWorkShopList()
        {
            //因为两个组织的车间一样，所以只取其中一个的
            string strSql = @"select d.FDEPTID,FNAME,FHELPCODE from T_BAS_ASSISTANTDATAENTRY t0 
   join T_BAS_ASSISTANTDATAENTRY_L t0_L 
  on t0.FENTRYID=t0_L.FENTRYID
   join T_BD_DEPARTMENT d  on d.FDEPTPROPERTY=t0.FMASTERID
   join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
    where FDATAVALUE = '基本生产部门' and d.FUSEORGID=1";
            DataTable dtResult = Program. GetDataTableBySqlText(strSql);
            return dtResult;
        }

        public static DataTable GetWorkLinesList(string workshop)
        {

            switch (workshop)
            {
                case "all": workshop = ""; break;
                case "装配生产课": workshop = "A"; break;
                case "冲压生产课": workshop = "S"; break;
                case "成型生产课": workshop = "M"; break;
            }
            string strSql = @"select t0.FNUMBER,FDATAVALUE,t0.FMASTERID,t0.FNUMBER+' '+FDATAVALUE as strline from T_BAS_ASSISTANTDATA t join T_BAS_ASSISTANTDATAENTRY t0 on t.FID=t0.FID
   join T_BAS_ASSISTANTDATAENTRY_L t0_L
  on t0.FENTRYID = t0_L.FENTRYID where t.FNUMBER = '001' and t0.FNUMBER like '" + workshop+"%'";
            DataTable dtResult = Program.GetDataTableBySqlText(strSql);
            return dtResult;
        }


        public static DataTable GetProductionPlanDetail()
        {
            string strSql = @"select pc.workersnum,pc.hours,pc.capacity,ppd.*from prdcapacity pc join ProductionPlanDetail ppd on pc.id=ppd.detailid";
            DataTable dtResult = Program.GetDataTableBySqlText(strSql);
            return dtResult;
        }

        public static DataTable GetMaxVersionNo(string workshop,string versiondate)
        {
            string strsql = "select isnull(max(versionno),0) as versionno from ProductionPlan where versiondate='"+versiondate+"' and workshop='"+workshop+"'";
            DataTable dt = Program.GetDataTableBySqlText(strsql);
            return dt;
        }

        public static DataTable GetMaxVersionID(string workshop)
        {
            string strsql = "select isnull(max(versionid),0) as versionid,max(versiondate) as versiondate from ProductionPlan where workshop='" + workshop + "'";
            DataTable dt_versionid = Program.GetDataTableBySqlText(strsql);

            return dt_versionid;
        }

        public static bool SaveData(bool datasource,string workshop,DataTable table, ref string ErrorMessage)
        {

            #region 申明参数    
            string TaskOrderNum = string.Empty;
            string PlanSum = string.Empty;

            string ProductPlanGid = string.Empty;
            string ProductTaskNo = string.Empty;
            string WorkShop = string.Empty;
            string WorkLines = string.Empty;
            int WorkYear = 0;
            int WorkWeek = 0;
            string VersionNo = string.Empty;
            string VersionID = string.Empty;
            string SEOrder = string.Empty;
            int FSEQ = 0;

            string LineDate = string.Empty;
            string Note = "";
            bool IsLatestVersion = false;
            bool IsFirstSave = true;
            int MaxVerisonNo = 0;
            #endregion


            #region  判断当前是不是最新版本号

            VersionID = table.Rows[0]["VersionID"].ToString();

            string str = "select isnull(max(versionid),0) as versionid from ProductionPlan where workshop='"+workshop+"'";
            DataTable dtID = Program.GetDataTableBySqlText(str);

            if (dtID != null && dtID.Rows.Count != 0)
            {
                if (int.Parse(dtID.Rows[0]["versionid"].ToString()) > int.Parse(VersionID)&&VersionID!="0")
                {
                    ErrorMessage = "当前不是最新版本,请切换最新版本再提交.";
                    return false;
                }
            }

            str = "select isnull(max(versionid),0) as versionid from ProductionPlan ";
            DataTable dtID2 = Program.GetDataTableBySqlText(str);

            UpdateLockdataBeforeSave(workshop,int.Parse(dtID2.Rows[0]["versionid"].ToString())+1, datasource);


            VersionNo = table.Rows[0]["VersionNo"].ToString();

            string strsql = "select isnull(max(versionno),0) as versionno from ProductionPlan where versiondate=convert(varchar(10),getdate(),120) and workshop='" + workshop + "'";
            DataTable dt = Program.GetDataTableBySqlText(strsql);

            if (dt != null && dt.Rows.Count != 0)
            {
                if (int.Parse(dt.Rows[0]["versionno"].ToString()) > int.Parse(VersionNo))
                {
                    ErrorMessage = "不是今天最新版本,请切换最新版本再提交.";
                    return false;
                }
            }

            #endregion

            MaxVerisonNo = int.Parse(dt.Rows[0]["versionno"].ToString()) + 1;

            #region 执行SQL

            try
            {
                string strsql2 = @"declare @id uniqueidentifier=newid(),@maxid int
select @maxid =isnull(max(VersionID),0) from ProductionPlan "+@"
insert into ProductionPlan values(@maxid +1,'"+workshop+"',@id,convert(varchar(10),getdate(),120)," + MaxVerisonNo + @")";

                Program.ExecDataBySqlText(strsql2);

                for (int j = 0; j < table.Rows.Count; j++)
                {
                    #region  参数赋值               
                    ProductTaskNo = table.Rows[j]["TaskOrder"].ToString();
                    TaskOrderNum = table.Rows[j]["TaskOrderNum"].ToString();
                    PlanSum = table.Rows[j]["SumPlan"].ToString();

                    SEOrder = table.Rows[j]["SEOrder"].ToString();
                    //FSEQ = int.Parse(table.Rows[j]["FSEQ"].ToString());

                    #endregion

                    string sql = @"declare @detailid uniqueidentifier,@maxid int
select @maxid =isnull(max(VersionID),0) from ProductionPlan " + @"
select @detailid =detailid  from ProductionPlan where VersionID=@maxid
insert into ProductionPlanDetail values("+(table.Rows.Count-j)+",@detailid,'" + ProductTaskNo + "'," + (PlanSum == "" ? "0" : PlanSum) + "";

                    for (int a = 0; a <= 34; a++)
                    {
                        string col1 = table.Rows[j]["col" + a + "_1"].ToString();
                        sql = sql + "," + (col1 == "" ? "null" : col1) + "";

                        string col2 = table.Rows[j]["col" + a + "_2"].ToString();
                        sql = sql + "," + (col2 == "" ? "null" : col2) + "";

                        string col3 = table.Rows[j]["col" + a + "_3"].ToString();
                        sql = sql + "," + (col3 == "" ? "null" : col3) + "";
                    }
                    sql = sql + ")";

                    bool bol = Program.ExecDataBySqlText(sql);
                    if (bol == false)
                    {
                        return bol;
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorMessage = "底层发生错误:" + ex.Message;
                return false;
            }
                #endregion

            return true;
        }

        public static bool SaveData_Temp(bool datasource,string workshop, DataTable table, ref string ErrorMessage)
        {

            UpdateLockdataBeforeSave(workshop,0, datasource);

            #region 申明参数
            string TaskOrderNum = string.Empty;
            string PlanSum = string.Empty;

            string ProductPlanGid = string.Empty;
            string ProductTaskNo = string.Empty;
            string WorkShop = string.Empty;
            string WorkLines = string.Empty;
            int WorkYear = 0;
            int WorkWeek = 0;
            string VersionNo = string.Empty;
            string SEOrder = string.Empty;
            int FSEQ = 0;

            string LineDate = string.Empty;
            string Note = "";
            bool IsLatestVersion = false;
            bool IsFirstSave = true;
            int MaxVerisonNo = 0;
            #endregion

            try
            {
                string sql = @" delete from ProductionPlanDetail_Temp where detailid=(select detailid from ProductionPlan_Temp where workshop='" + workshop + "'" + ") delete from ProductionPlan_Temp where workshop = '" + workshop + "'";

                Program.ExecDataBySqlText(sql);
            }
            catch (Exception ex)
            {
                ErrorMessage = "底层发生错误:" + ex.Message;
                return false;
            }


            try
            {
                string sql = @"declare @id uniqueidentifier=newid()
insert into ProductionPlan_Temp values(0,'" + workshop + "',@id,convert(varchar(10),getdate(),120),null)";

                Program.ExecDataBySqlText(sql);
            }
            catch (Exception ex)
            {
                ErrorMessage = "底层发生错误:" + ex.Message;
                return false;
            }


            for (int j = 0; j < table.Rows.Count; j++)
            {
                #region  参数赋值               
                ProductTaskNo = table.Rows[j]["TaskOrder"].ToString();
                TaskOrderNum = table.Rows[j]["TaskOrderNum"].ToString();
                PlanSum = table.Rows[j]["SumPlan"].ToString();

                SEOrder = table.Rows[j]["SEOrder"].ToString();
                //FSEQ = int.Parse(table.Rows[j]["FSEQ"].ToString());

                #endregion


                #region 执行SQL
                try
                {
                    string sql = @"declare @detailid uniqueidentifier
select @detailid =detailid  from ProductionPlan_Temp where workshop='" + workshop + "'" + @"
insert into ProductionPlanDetail_Temp values(" + (table.Rows.Count - j) + ",@detailid,'" + ProductTaskNo + "'," + (PlanSum == "" ? "0" : PlanSum) + "";

                    for (int a = 0; a <= 34; a++)
                    {
                        string col1 = table.Rows[j]["col" + a + "_1"].ToString();
                        sql = sql + "," + (col1 == "" ? "null" : col1) + "";

                        string col2 = table.Rows[j]["col" + a + "_2"].ToString();
                        sql = sql + "," + (col2 == "" ? "null" : col2) + "";

                        string col3 = table.Rows[j]["col" + a + "_3"].ToString();
                        sql = sql + "," + (col3 == "" ? "null" : col3) + "";
                    }
                    sql = sql + ")";

                    Program.ExecDataBySqlText(sql);
                }
                catch (Exception ex)
                {
                    ErrorMessage = "底层发生错误:" + ex.Message;
                    return false;
                }
                #endregion

            }
            return true;
        }

        public static bool UpdateLockdataBeforeSave(string workshop, int VersionID,bool datasource)
        {
            string sql = @"declare @maxid int select @maxid = isnull(max(VersionID), 0) from ProductionPlan where workshop='" + workshop + @"'
delete ppl from ProductionPlanLock ppl
join T_PRD_MO mo on ppl.MoNo=mo.FBILLNO
join T_PRD_MOENTRY me on mo.fid = me.fid
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
where dl.FNAME='"+workshop+"' and versionid=-1 and versiondate<>convert(varchar(10),getdate(),120) ";

            string selectsql ="";

            int diff = 0;
            string colsql = "";

            if (VersionID >= 2)
            {
                if (datasource == true)
                {

                    diff = GetVersionDateDiff(workshop);

                    selectsql = VersionID + " as versionid,convert(varchar(10),getdate(),120) as versiondate,mono";
                    for (int a = 0; a <= 34 - diff; a++)
                    {
                        selectsql = selectsql + ",col" + (a + diff) + " as col" + a;
                    }
                    for (int a = 34 - diff + 1; a <= 34; a++)
                    {
                        selectsql = selectsql + ",null as col" + a;
                    }

                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }

                    sql += @"insert into ProductionPlanLock select " + selectsql + " from ProductionPlanLock where versionid=" + (VersionID - 1);


                }
                else if (datasource == false)
                {
                    diff = GetVersionDateDiffTemp(workshop);

                    selectsql = VersionID + " as versionid,convert(varchar(10),getdate(),120) as versiondate,mono";
                    for (int a = 0; a <= 34 - diff; a++)
                    {
                        selectsql = selectsql + ",col" + (a + diff) + " as col" + a;
                    }
                    for (int a = 34 - diff + 1; a <= 34; a++)
                    {
                        selectsql = selectsql + ",null as col" + a;
                    }

                    sql += @"insert into ProductionPlanLock select " + selectsql + " from ProductionPlanLock where versionid=0";

                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }

                }

                sql += @";with temp as(select * from ProductionPlanLock where versionid=-1)
update ProductionPlanLock set " + colsql + " from ProductionPlanLock ppl join temp on ppl.MoNo=temp.MoNo where ppl.versionid=" + VersionID + @"
update ProductionPlanLock set versionid=" + VersionID + @",versiondate=convert(varchar(10),getdate(),120) from ProductionPlanLock ppl where versionid=-1 and not exists (select 1 from ProductionPlanLock where versionid=" + VersionID + @" and mono=ppl.mono)
delete from ProductionPlanLock where versionid=-1";
            }
            else if (VersionID == 1)
            {
                if (datasource == true)
                {
                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }
                }
                else if (datasource == false)
                {
                    diff = GetVersionDateDiffTemp(workshop);

                    selectsql = VersionID + " as versionid,convert(varchar(10),getdate(),120) as versiondate,mono";
                    for (int a = 0; a <= 34 - diff; a++)
                    {
                        selectsql = selectsql + ",col" + (a + diff) + " as col" + a;
                    }
                    for (int a = 34 - diff + 1; a <= 34; a++)
                    {
                        selectsql = selectsql + ",null as col" + a;
                    }

                    sql += @"insert into ProductionPlanLock select " + selectsql + " from ProductionPlanLock where versionid=0";

                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }

                }

                sql += @";with temp as(select * from ProductionPlanLock where versionid=-1)
update ProductionPlanLock set " + colsql + " from ProductionPlanLock ppl join temp on ppl.MoNo=temp.MoNo where ppl.versionid=" + VersionID + @"
update ProductionPlanLock set versionid=" + VersionID + @",versiondate=convert(varchar(10),getdate(),120) from ProductionPlanLock ppl where versionid=-1 and not exists (select 1 from ProductionPlanLock where versionid=" + VersionID + @" and mono=ppl.mono)
delete from ProductionPlanLock where versionid=-1";

            }
            else if (VersionID == 0)
            {
                if (datasource == true)
                {
                    diff = GetVersionDateDiff(workshop);

                    selectsql = VersionID + " as versionid,convert(varchar(10),getdate(),120) as versiondate,mono";
                    for (int a = 0; a <= 34 - diff; a++)
                    {
                        selectsql = selectsql + ",col" + (a + diff) + " as col" + a;
                    }
                    for (int a = 34 - diff + 1; a <= 34; a++)
                    {
                        selectsql = selectsql + ",null as col" + a;
                    }

                    sql += @" delete from ProductionPlanLock where versionid=0 insert into ProductionPlanLock select " + selectsql + @" from ProductionPlanLock where versionid=@maxid ";

                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }

                    sql += @";with temp as(select * from ProductionPlanLock where versionid=-1)
update ProductionPlanLock set " + colsql + " from ProductionPlanLock ppl join temp on ppl.MoNo=temp.MoNo where ppl.versionid=" + VersionID + @"
update ProductionPlanLock set versionid=" + VersionID + @",versiondate=convert(varchar(10),getdate(),120) from ProductionPlanLock ppl where versionid=-1 and not exists (select 1 from ProductionPlanLock where versionid=" + VersionID + @" and mono=ppl.mono)
delete from ProductionPlanLock where versionid=-1";

                }
                if (datasource == false)
                {
                    diff = GetVersionDateDiffTemp(workshop);

                    colsql = "versiondate=convert(varchar(10),getdate(),120),col0 = isnull(temp.col0, ppl.col" + 0 + ")";
                    for (int a = 1; a <= 34; a++)
                    {
                        colsql += ",col" + a + "= isnull(temp.col" + a + ", ppl.col" + a + ")";
                    }

                    string _colsql = "versiondate=convert(varchar(10),getdate(),120),col0 =col" + diff + "";
                    for (int a = 1; a <= 34 - diff; a++)
                    {
                        _colsql += ",col" + a + "=col" + (a + diff) + "";
                    }
                    for (int a = 34 - diff + 1; a <= 34; a++)
                    {
                        _colsql += ",col" + a + "=null";
                    }

                    sql += @"update ProductionPlanLock set " + _colsql + @" where versionid = " + VersionID + @";with temp as(select * from ProductionPlanLock where versionid=-1)
update ProductionPlanLock set " + colsql + " from ProductionPlanLock ppl join temp on ppl.MoNo=temp.MoNo where ppl.versionid=" + VersionID + @"
update ProductionPlanLock set versionid=" + VersionID + @",versiondate=convert(varchar(10),getdate(),120) from ProductionPlanLock ppl where versionid=-1 and not exists (select 1 from ProductionPlanLock where versionid=" + VersionID + @" and mono=ppl.mono)
delete from ProductionPlanLock where versionid=-1";

                }

            }

            bool bol = Program.ExecDataBySqlText(sql);
            if (bol == false)
            {
                return false;
            }

            return true;
        }

        public static bool TempDataIsNotNull(string workshop)
        {
            string strsql = @"select 1 from ProductionPlan_Temp pp 
 join ProductionPlanDetail_Temp ppd on pp.detailid = ppd.detailid where 1=1";

            if (workshop != "")
            {
                strsql += " and workshop = '" + workshop + "'";
            }
            else if (workshop == "")
            {
                return false;
            }

            DataTable dtResult = Program.GetDataTableBySqlText(strsql);
            if (dtResult != null && dtResult.Rows.Count > 0)
            {
                return true;
            }

            return false;
        }
        public static int GetVersionDateDiffTemp(string workshop)
        {
            string strsql = "select datediff(DAY,isnull(versiondate,GETDATE()),GETDATE()) from ProductionPlan_Temp where 1=1" ;
            if (workshop != "")
            {
                strsql += " and workshop = '"+workshop+"'";
            }
            else if (workshop == "")
            {
                return 0;
            }

            DataTable dtResult = Program.GetDataTableBySqlText(strsql);
            if (dtResult != null && dtResult.Rows.Count > 0)
            {
                return int.Parse(dtResult.Rows[0][0].ToString());
            }

            return 0;
        }

        public static int GetVersionDateDiff(string workshop)
        {
            string strsql = "select datediff(DAY,isnull(max(versiondate),GETDATE()),GETDATE()) from ProductionPlan where 1=1";

            if (workshop != "")
            {
                strsql += " and workshop = '" + workshop + "'";
            }
            else if (workshop == "")
            {
                return 0;
            }

            DataTable dtResult = Program.GetDataTableBySqlText(strsql);
            if (dtResult != null && dtResult.Rows.Count > 0)
            {
                return int.Parse(dtResult.Rows[0][0].ToString());
            }

            return 0;

        }

        public static bool ClearTempData(string workshop)
        {
            string strsql = @"declare @detailid uniqueidentifier
select @detailid=detailid from ProductionPlan_Temp where workshop='"+workshop+ @"'
delete ProductionPlanDetail_Temp where detailid=@detailid
delete ProductionPlan_Temp where detailid=@detailid

delete ppl from ProductionPlanLock ppl
join T_PRD_MO mo on ppl.MoNo=mo.FBILLNO
join T_PRD_MOENTRY me on mo.fid = me.fid
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
where dl.FNAME='" + workshop + "' and versionid=0";
            bool bol = Program.ExecDataBySqlText(strsql);

            return bol;
        }

        public static bool ClearTempLockData(string workshop)
        {
            string strsql = @"delete ppl from ProductionPlanLock ppl
join T_PRD_MO mo on ppl.MoNo=mo.FBILLNO
join T_PRD_MOENTRY me on mo.fid = me.fid
join T_BD_DEPARTMENT d  on d.FDEPTID=me.FWORKSHOPID
join T_BD_DEPARTMENT_L dl on dl.FDEPTID=d.FDEPTID
where versionid=-1";
            if (workshop.ToLower() != "all")
            {
                strsql += " and dl.FNAME='" + workshop+"'";
            }

            bool bol = Program.ExecDataBySqlText(strsql);
            return bol;
        }
        public static bool ImportExcelData(string materialno,string lineno ,string workersnum, string hours)
        {
            string sql = "";
            string strsql = @"with temp as(select workshop,FMASTERID,FMATERIALID,FUNITID,workersnum,hours,StandCapacity from (select top 1 m.FMATERIALID,d.FUNITID," + workersnum + @" as workersnum," + hours + @" as hours,case mp.FPERUNITSTANDHOUR when 0 then 0 when null then 0 else convert(decimal(10,2),3600/mp.FPERUNITSTANDHOUR) end as StandCapacity from T_BD_MATERIAL m join T_BD_MATERIAL_L ml on m.FMATERIALID=ml.FMATERIALID join T_BD_MATERIALPRODUCE mp on m.FMATERIALID=mp.FMATERIALID left join T_BD_UNIT d on mp.FPRODUCEUNITID = d.FUNITID where m.FNUMBER='" + materialno + "') a,(select t0.FNUMBER,FMASTERID,case when t0.FNUMBER like 'M%' then '成型生产课' when t0.FNUMBER like 'A%' then '装配生产课' when t0.FNUMBER like 'S%' then '冲压生产课' end as workshop from T_BAS_ASSISTANTDATA t join T_BAS_ASSISTANTDATAENTRY t0 on t.FID=t0.FID join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID = t0_L.FENTRYID where t.FNUMBER = '001' and t0.FNUMBER='" +lineno + "')b ) select 1 from temp join prdcapacity pc on temp.FMASTERID=pc.line and temp.FMATERIALID=pc.production";
            DataTable dt = Program.GetDataTableBySqlText(strsql);

            if (dt != null && dt.Rows.Count > 0)
            {
                sql = @"with temp as(select workshop,FMASTERID,FMATERIALID,FUNITID,workersnum,hours,StandCapacity from (select top 1 m.FMATERIALID,d.FUNITID," + workersnum + @" as workersnum," + hours + @" as hours,case mp.FPERUNITSTANDHOUR when 0 then 0 when null then 0 else convert(decimal(10,2),3600/mp.FPERUNITSTANDHOUR) end as StandCapacity from T_BD_MATERIAL m join T_BD_MATERIAL_L ml on m.FMATERIALID=ml.FMATERIALID join T_BD_MATERIALPRODUCE mp on m.FMATERIALID=mp.FMATERIALID left join T_BD_UNIT d on mp.FPRODUCEUNITID = d.FUNITID where m.FNUMBER='" + materialno + "') a,(select t0.FNUMBER,FMASTERID,case when t0.FNUMBER like 'M%' then '成型生产课' when t0.FNUMBER like 'A%' then '装配生产课' when t0.FNUMBER like 'S%' then '冲压生产课' end as workshop from T_BAS_ASSISTANTDATA t join T_BAS_ASSISTANTDATAENTRY t0 on t.FID=t0.FID join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID = t0_L.FENTRYID where t.FNUMBER = '001' and t0.FNUMBER='" + lineno + "')b ) update prdcapacity set workersnum=temp.workersnum,hours=temp.workersnum,capacity=temp.StandCapacity from temp join prdcapacity pc on temp.FMASTERID=pc.line and temp.FMATERIALID=pc.production";
            }
            else if (dt != null && dt.Rows.Count == 0)
            {
                sql = @"with temp as(select workshop,FMASTERID,FMATERIALID,FUNITID,workersnum,hours,StandCapacity from (select top 1 m.FMATERIALID,d.FUNITID," + workersnum + @" as workersnum," + hours + @" as hours,case mp.FPERUNITSTANDHOUR when 0 then 0 when null then 0 else convert(decimal(10,2),3600/mp.FPERUNITSTANDHOUR) end as StandCapacity from T_BD_MATERIAL m join T_BD_MATERIAL_L ml on m.FMATERIALID=ml.FMATERIALID join T_BD_MATERIALPRODUCE mp on m.FMATERIALID=mp.FMATERIALID left join T_BD_UNIT d on mp.FPRODUCEUNITID = d.FUNITID where m.FNUMBER='" + materialno + "') a,(select t0.FNUMBER,FMASTERID,case when t0.FNUMBER like 'M%' then '成型生产课' when t0.FNUMBER like 'A%' then '装配生产课' when t0.FNUMBER like 'S%' then '冲压生产课' end as workshop from T_BAS_ASSISTANTDATA t join T_BAS_ASSISTANTDATAENTRY t0 on t.FID=t0.FID join T_BAS_ASSISTANTDATAENTRY_L t0_L on t0.FENTRYID = t0_L.FENTRYID where t.FNUMBER = '001' and t0.FNUMBER='" + lineno + "')b ) insert into prdcapacity(workshop,line,production,unit,workersnum,hours,capacity) select *from temp";
            }

            bool bol = Program.ExecDataBySqlText(sql);
            if (sql != "" && bol == true)
            {
                return true;
            }
            return false;

        }

        /// <summary>
        /// Json 字符串 转换为 DataTable数据集合
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public static DataTable JsonToDataTable(string json)
        {
            DataTable dataTable = new DataTable();  //实例化
            DataTable result;
            try
            {
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
                javaScriptSerializer.MaxJsonLength = Int32.MaxValue; //取得最大数值
                ArrayList arrayList = javaScriptSerializer.Deserialize<ArrayList>(json);
                if (arrayList.Count > 0)
                {
                    foreach (Dictionary<string, object> dictionary in arrayList)
                    {
                        if (dictionary.Keys.Count<string>() == 0)
                        {
                            result = dataTable;
                            return result;
                        }
                        //Columns
                        if (dataTable.Columns.Count == 0)
                        {
                            foreach (string current in dictionary.Keys)
                            {
                                dataTable.Columns.Add(current, dictionary[current].GetType());
                            }
                        }
                        //Rows
                        DataRow dataRow = dataTable.NewRow();
                        foreach (string current in dictionary.Keys)
                        {
                            dataRow[current] = dictionary[current];
                        }
                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中
                    }
                }
            }
            catch
            {
            }
            result = dataTable;
            return result;
        }

        #region Excel2007
        /// <summary>
        /// 将Excel文件中的数据读出到DataTable中(xlsx)
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public static DataTable ExcelToTableForXLSX(string file)
        {
            DataTable dt = new DataTable();
            using (FileStream fs = new FileStream(file, FileMode.Open, FileAccess.Read))
            {
                XSSFWorkbook xssfworkbook = new XSSFWorkbook(fs);
                ISheet sheet = xssfworkbook.GetSheetAt(0);

                //表头
                IRow header = sheet.GetRow(sheet.FirstRowNum);
                List<int> columns = new List<int>();
                for (int i = 0; i < header.LastCellNum; i++)
                {
                    object obj = GetValueTypeForXLSX(header.GetCell(i) as XSSFCell);
                    if (obj == null || obj.ToString() == string.Empty)
                    {
                        dt.Columns.Add(new DataColumn("Columns" + i.ToString()));
                        //continue;
                    }
                    else
                        dt.Columns.Add(new DataColumn(obj.ToString()));
                    columns.Add(i);
                }
                //数据
                for (int i = sheet.FirstRowNum + 1; i <= sheet.LastRowNum; i++)
                {
                    DataRow dr = dt.NewRow();
                    bool hasValue = false;
                    foreach (int j in columns)
                    {
                        dr[j] = GetValueTypeForXLSX(sheet.GetRow(i).GetCell(j) as XSSFCell);
                        if (dr[j] != null && dr[j].ToString() != string.Empty)
                        {
                            hasValue = true;
                        }
                    }
                    if (hasValue)
                    {
                        dt.Rows.Add(dr);
                    }
                }
            }
            return dt;
        }

        /// <summary>
        /// 将DataTable数据导出到Excel文件中(xlsx)
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="file"></param>
        public static void TableToExcelForXLSX(DataTable dt, string file)
        {
            XSSFWorkbook xssfworkbook = new XSSFWorkbook();
            ISheet sheet = xssfworkbook.CreateSheet("Test");

            //表头
            IRow row = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = row.CreateCell(i);
                cell.SetCellValue(dt.Columns[i].ColumnName);
            }

            //数据
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row1 = sheet.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    ICell cell = row1.CreateCell(j);
                    cell.SetCellValue(dt.Rows[i][j].ToString());
                }
            }

            //转为字节数组
            MemoryStream stream = new MemoryStream();
            xssfworkbook.Write(stream);
            var buf = stream.ToArray();

            //保存为Excel文件
            using (FileStream fs = new FileStream(file, FileMode.Create, FileAccess.Write))
            {
                fs.Write(buf, 0, buf.Length);
                fs.Flush();
            }
        }

        /// <summary>
        /// 获取单元格类型(xlsx)
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private static object GetValueTypeForXLSX(XSSFCell cell)
        {
            if (cell == null)
                return null;
            switch (cell.CellType)
            {
                case CellType.Blank: //BLANK:
                    return null;
                case CellType.Boolean: //BOOLEAN:
                    return cell.BooleanCellValue;
                case CellType.Numeric: //NUMERIC:
                    return cell.NumericCellValue;
                case CellType.String: //STRING:
                    return cell.StringCellValue;
                case CellType.Error: //ERROR:
                    return cell.ErrorCellValue;
                case CellType.Formula: //FORMULA:
                default:
                    return "=" + cell.CellFormula;
            }
        }
        #endregion
    }//class
}//namespace