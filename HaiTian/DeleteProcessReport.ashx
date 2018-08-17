<%@ WebHandler Language="C#" Class="DeleteProcessReport" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class DeleteProcessReport : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string billno = context.Request.QueryString["billno"];

        if (billno != null && billno != "")
        {
            bool bol = false;
            int IntResult = 99;
            string Msg = "";
            string json_return = "{\"jsonResult\":{";
            string strsql = "";
            strsql = @"declare @FInterID int
select @FInterID=FInterID from t_GXHB where FBillNo='" + billno + "'" + @"
delete from t_GXHB where FInterID=@FInterID
delete from t_GXHBEntry where FInterID=@FInterID";

            bol = SQLServer.ExecSql(strsql, ref Msg);

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
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}