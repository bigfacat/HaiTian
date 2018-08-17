<%@ WebHandler Language="C#" Class="DeleteSectionEmpData" %>

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

public class DeleteSectionEmpData : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];

        string Msg = "";

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        bool bol = false;
        int intResult = 99;
        string strsql = "";
        strsql = @"declare @sectionID int
select @sectionID=(select top 1 FInterID from t_SubMessage where FTypeID=61 and FID='" + jo["section"] + @"')
delete from t_SectionEmpMapping where year=" + jo["year"] + @" and month=" + jo["month"] + @" and section=@sectionID";

        bol = SQLServer.ExecSql(strsql, ref Msg);

        if (bol == true)
        {
            intResult = 100;
        }
        context.Response.Write(intResult);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}