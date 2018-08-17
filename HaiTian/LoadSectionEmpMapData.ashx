<%@ WebHandler Language="C#" Class="LoadSectionEmpMapData" %>

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

public class LoadSectionEmpMapData : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string y = context.Request.QueryString["y"];
        string m = context.Request.QueryString["m"];
        string section = context.Request.QueryString["section"];

        string Msg = "";
        string str = @"select id,year,month,rom.FID,rom.FName,emp.FNumber,emp.FName,rate from t_SectionEmpMapping s 
left join t_Emp emp on s.emp=emp.FItemID
left join (select FInterID,FID,FName from t_SubMessage where FTypeID=61) rom on s.section=rom.FInterID where 1=1";
        if (y != null && y != "" && y != "undefined")
        {
            str += " and year=" + y + "";
        }

        if (m != null && m != "" && m != "undefined")
        {
            str += " and month=" + m + "";
        }

        if (section != null && section != "" && section != "undefined")
        {
            str += " and rom.FID like '%" + section + "%'";
        }

        str += " order by section,emp";

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