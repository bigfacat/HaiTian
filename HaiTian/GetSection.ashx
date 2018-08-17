<%@ WebHandler Language="C#" Class="GetSection" %>

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

public class GetSection : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string section = context.Request.QueryString["section"];
        string page = context.Request.QueryString["page"];
        string rows = context.Request.QueryString["rows"];

        if (page == null)
        {
            page = "1";
        }
        if (rows == null)
        {
            rows = "10";
        }

        int intPage = int.Parse(page);
        int intRows = int.Parse(rows);

        string Msg = "";
        string str = "select FInterID,FID,FName from t_SubMessage where FTypeID=61";

        if (section != null && section != "" && section != "undefined")
        {
            str += " and (FID like '%" + section + "%' or FName like '%" + section + "%')";
        }

        DataTable dtResult = SQLServer.GetDataTable(str, ref Msg);

        string jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage, intRows, dtResult);
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