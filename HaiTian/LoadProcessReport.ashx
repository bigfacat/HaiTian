<%@ WebHandler Language="C#" Class="LoadProcessReport" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
using HaiTian;

public class LoadProcessReport : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string billno = context.Request.QueryString["billno"];
        string mo = context.Request.QueryString["mo"];
        string matnumber = context.Request.QueryString["matnumber"];
        string startdate = context.Request.QueryString["startdate"];
        string enddate = context.Request.QueryString["enddate"];
        string isThrown = context.Request.QueryString["isThrown"];

        string page = context.Request.QueryString["page"];
        string rowsNum = context.Request.QueryString["rows"];
        string sidx = context.Request.QueryString["sidx"];//来获得排序的列名
        string sord = context.Request.QueryString["sord"];//来获得排序方式，即为重新检索数据，根据所取得的字段值进行重新的查询，然后返回到本页面。当你重复点击列首时，其排序方式是交替改变的。

        if (isThrown.ToUpper() == "ALL")
        {
            isThrown = "";
        }

                int intPage = int.Parse(page);
        int intRows = int.Parse(rowsNum);


        using (SqlConnection conn = new SqlConnection())
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                string strSql = @"select FEntryIndex,g.FBillNo,convert(varchar(10),g.FDate,120),u.FName,case IsThrown when 1 then '是' else '否' end,case g.FCancellation when 1 then '是' else '否' end,g.FWBNO,convert(decimal(8,2),wbe.FAuxQtyPlan),convert(decimal(10,2),wbe.FAuxQtyFinish+isnull(gge.sumqty,0)) as ReportedQty,wbe.FOperNote,wb.FICMONO,ic.FNumber as matnumber,ic.FName as matname,sm61.FID as opnumber,sm61.FName as opname,wbe.FPieceRate,ge.FEntryID,emp.FNumber,emp.FName,convert(decimal(8,2),ge.FAuxQtyfinish)
from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID
join SHWorkBillEntry wbe on g.FWBNO=wbe.FWorkBillNO 
join SHWorkBill wb on wb.FInterID=wbe.FinterID
left join t_Emp emp on ge.FWorkerID=emp.FItemID
left join t_User u on g.FBillerID=u.FUserID
join t_ICItem ic on wb.FItemID=ic.FItemID
join (select * from t_SubMessage where FTypeID=61) sm61 on sm61.FInterID=wbe.FOperID
left join(select g.FWBNO,SUM(ge.FAuxQtyfinish) as sumqty from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID where IsThrown=0 group by g.FWBNO)gge on wbe.FWorkBillNO=gge.FWBNO
where 1=1";
                if (billno!=null&&billno != "")
                {
                    strSql += " and g.fbillno like '%" + billno + "%'";
                }
                if (mo != null&&mo != "")
                {
                    strSql += " and wb.FICMONO like '%" + mo + "%'";
                }
                if (matnumber!= null&&matnumber!= "")
                {
                    strSql += " and ic.FNumber like '%" + matnumber + "%'";
                }
                if (startdate != null && startdate != "" && startdate != "undefined")
                {
                    strSql += " and g.FDate >= CONVERT(datetime,'" + startdate + "')";
                }
                if (enddate != null && enddate != "" && enddate != "undefined")
                {
                    strSql += " and g.FDate <= CONVERT(datetime,'" + enddate + "')";
                }
                if (isThrown != null && isThrown != "" && isThrown != "undefined")
                {
                    strSql += " and g.IsThrown =" + isThrown + "";
                }

                strSql += " order by g.FBillNo,ge.FEntryID";

                DataTable dtResult = Program.GetDataTableBySqlText(strSql);

                string jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage,intRows,dtResult);
                context.Response.Write(jsondata);
            }
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}