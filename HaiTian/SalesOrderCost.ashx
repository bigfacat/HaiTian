<%@ WebHandler Language="C#" Class="SalesOrderCost" %>

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

public class SalesOrderCost : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string username = context.Request.QueryString["username"];

        string Msg = "";
        string str = "exec usp_SalesOrderCost '8.DK.OD147.1050ABD-39W'";

        if (username != null && username != "" && username != "undefined")
        {
            str += " and username like '%" + username + "%'";
        }

        DataTable dtResult = SQLServer.GetDataTable(str, ref Msg);

        string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
        context.Response.Write(jsondata);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}