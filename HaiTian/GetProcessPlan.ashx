<%@ WebHandler Language="C#" Class="GetProcessPlan" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
    using HaiTian;

public class GetProcessPlan : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string plan = context.Request.QueryString["plan"];
        string mo = context.Request.QueryString["mo"];

        using (SqlConnection conn = new SqlConnection())
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                //FEntrySelfz0374(是工段) 要根据客户实际部署情况修改字段名
                string strSql = @"select FWBInterID,FWorkBillNO,convert(decimal(10,2),wbe.FAuxQtyPlan),convert(decimal(10,2),wbe.FAuxQtyFinish+isnull(gge.sumqty,0)) as ReportedQty,wbe.FOperNote,wb.FICMONO,ic.FNumber as matnumber,ic.FName as matname,sm61.FID as opnumber,sm61.FName as opname,it.FName
from SHWorkBillEntry wbe
join SHWorkBill wb on wb.FInterID=wbe.FinterID
join t_ICItem ic on wb.FItemID=ic.FItemID
join (select * from t_SubMessage where FTypeID=61) sm61 on sm61.FInterID=wbe.FOperID
left join t_Item it on wbe.FEntrySelfz0374=it.FItemID
left join(select g.FWBNO,SUM(ge.FAuxQtyfinish) as sumqty from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID where IsThrown=0 group by g.FWBNO)gge on wbe.FWorkBillNO=gge.FWBNO
where wbe.FCancellation='0' and wbe.FStatus in (1) and wbe.FIsOut=1059 and (wbe.FAuxQtyFinish+isnull(gge.sumqty,0))<wbe.FAuxQtyPlan";

                if (plan != null&&plan != "")
                {
                    strSql += " and wbe.FWorkBillNO like '%" + plan+"%'";
                }
                if (mo!= null&&mo!= "")
                {
                    strSql += " and FICMONO like '%" + mo+"%'";
                }

                DataTable dtResult = Program.GetDataTableBySqlText(strSql);

        string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
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