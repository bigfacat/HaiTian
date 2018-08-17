<%@ WebHandler Language="C#" Class="GetAccountStatus" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using HaiTian;

public class GetAccountStatus : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string y = context.Request.QueryString["y"];
        string m = context.Request.QueryString["m"];
        string status = context.Request.QueryString["status"];

        string Msg = "";
        string str = "select id,YEAR,MONTH,case status when 1 then '开账' when 0 then '关账' end from t_AccountStatus where 1=1";
        if (y != null && y != "" && y != "undefined")
        {
            str += " and year=" + y + "";
        }

        if (m != null && m != "" && m != "undefined")
        {
            str += " and month=" + m + "";
        }

        if (status != null && status != "" && status != "undefined")
        {
            str += " and status=" + status + "";
        }

        str += " order by year desc,month desc";

        DataTable dtResult = SQLServer.GetDataTable(str, ref Msg);

        string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
        context.Response.Write(jsondata);

    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}