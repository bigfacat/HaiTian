<%@ WebHandler Language="C#" Class="ProcessReport" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class ProcessReport : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string op = context.Request.QueryString["op"];

        string billno = context.Request.QueryString["billno"];

        bool bol = false;
        int IntResult = 99;
        string Msg = "";
        string json_return = "{\"jsonResult\":{";
        string strsql = "";


        if (billno == null && billno == "")
        {
            return;
        }

        if (op == null)
        {
            op = "";
        }

        switch (op)
        {
            case "Cancel":
                strsql = @"update SHProcRptMain set FCancellation=1,FCheckerID=null,FCheckDate=null where FBillNo='" + billno + "'" + @"
update t_GXHB set FCancellation=1 where FBillNo='" + billno + "'" + @"with temp as(select wbe.FWorkBillNO,SUM(pr.Fqtyfinish) as sumqty from SHProcRptMain prm 
join SHProcRpt pr on prm.FInterID=pr.FinterID
join SHWorkBillEntry wbe on prm.FWBNO=wbe.FWorkBillNO
where FBillNo='" + billno + @"' group by wbe.FWorkBillNO
)update wbe set wbe.FAuxQtyFinish=wbe.FAuxQtyFinish-temp.sumqty,wbe.FQtyFinish=wbe.FQtyFinish-temp.sumqty from SHWorkBillEntry wbe join temp on wbe.FWorkBillNO=temp.FWorkBillNO";
                bol = SQLServer.ExecSql(strsql, ref Msg);
                break;
        }


        if (bol == true)
        {
            IntResult = 100;
            json_return += "\"Result\":\"" + IntResult + "\"";
        }
        else if (bol == false)
        {
            json_return += "\"Result\":\"" + IntResult + "\"";
            json_return += "\"Msg\":\"" + Msg + "\"";
        }

        json_return += "}}";
        context.Response.Write(json_return);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}