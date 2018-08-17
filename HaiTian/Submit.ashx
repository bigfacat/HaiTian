<%@ WebHandler Language="C#" Class="Submit" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class Submit : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string page = context.Request.QueryString["page"];
        string rowsNum = context.Request.QueryString["rows"];
        string sidx = context.Request.QueryString["sidx"];//来获得排序的列名
        string sord = context.Request.QueryString["sord"];//来获得排序方式，即为重新检索数据，根据所取得的字段值进行重新的查询，然后返回到本页面。当你重复点击列首时，其排序方式是交替改变的。

        if (page == null)
        {
            page = "1";
        }

        string billno = context.Request.QueryString["billno"];

        if (billno != null && billno != "")
        {
            bool bol = false;
            string Msg = "";
            JObject jo = new JObject();

            string json_return = "{";
            string strsql = "";
            strsql = "select 1 from SHProcRptMain where FBillNo='" + billno + "'";
            DataTable dt = SQLServer.GetDataTable(strsql,ref Msg);
            if (dt != null && dt.Rows.Count > 0)
            {
                json_return += "\"Msg\":\"已存在相同单据，不能重复提交！\"";
            }
            else if (dt != null && dt.Rows.Count == 0)
            {
                strsql = "exec usp_ImportProcRptDataToWise '" + billno + "'";
                bol = SQLServer.ExecSql(strsql,ref Msg);
                json_return += "\"Result\":\"" + bol + "\"";
            }

            json_return += ",\"Page\":\"" + page + "\"";

            json_return += "}";
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