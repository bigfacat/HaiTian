<%@ WebHandler Language="C#" Class="Test" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SQL;
using System.IO;
using HaiTian;
using System.Diagnostics;
using Newtonsoft;

public class Test : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string top = context.Request.QueryString["top"];

        string strSql = @"
select top " + top + @" FName from t_Item where FName like '%" + "\"" + "%'";

        DataTable dtResult = Program.GetDataTableBySqlText(strSql);

        Stopwatch sw = new Stopwatch();
        sw.Start();
        string jsondata = Public.GetJQGridJSONFromDT(dtResult);
        //string jsondata = JsonConvert.SerializeObject(dtResult);

        //jsondata = "{\"rows\":[{\"cell\":[\"2809\",\"WORK001737\",\"8.SA.51100.1350ABV-29G\",\"四轮拉杆箱小号/有伸缩(美国版)\"]} ]}";
        sw.Stop();
        TimeSpan ts2 = sw.Elapsed;
        context.Response.Write(jsondata);
        //context.Response.Write(ts2.TotalMilliseconds/1000);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}