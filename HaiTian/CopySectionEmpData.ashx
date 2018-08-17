<%@ WebHandler Language="C#" Class="CopySectionEmpData" %>

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

public class CopySectionEmpData : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];

        string Msg = "";

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        bool bol = false;
        int intResult = 99;
        string strsql = "";
        strsql = @"insert into t_SectionEmpMapping select " + jo["NewYear"] + @"," + jo["NewMonth"] + @",section,emp,rate from t_SectionEmpMapping where year=" + jo["OldYear"] + @" and month=" + jo["OldMonth"];

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