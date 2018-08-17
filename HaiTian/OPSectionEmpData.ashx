<%@ WebHandler Language="C#" Class="OPSectionEmpData" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using HaiTian;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class OPSectionEmpData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];

        string Msg = "";

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);
        JArray ja = (JArray)jo["rows"];

        bool bol = false;
        int intResult = 99;
        string strsql = "";
        if (ja != null && ja.Count > 0)
        {
            strsql = @"declare @sectionID int,@empID int
select @sectionID=(select top 1 FInterID from (select FInterID,FID,FName from t_SubMessage where FTypeID=61) sm61 where FID='" + jo["section"] + @"')
delete from t_SectionEmpMapping where year=" + jo["year"] + @" and month=" + jo["month"] + @" and section=@sectionID";

            for (int i = 0; i < ja.Count; i++)
            {
                strsql += " select @empID=(select top 1 FItemID from t_Emp emp where emp.FNumber='" + ja[i]["emp"] + @"') insert into t_SectionEmpMapping values(" + jo["year"] + @"," + jo["month"] + @",@sectionID,@empID," + ja[i]["rate"] + @")";
            }
            bol = SQLServer.ExecSql(strsql, ref Msg);
        }

        if (bol == true)
        {
            intResult = 100;
        }
        context.Response.Write(intResult);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}