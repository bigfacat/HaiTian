<%@ WebHandler Language="C#" Class="CloseAccountCheck" %>

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

public class CloseAccountCheck : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];

                    JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);


        string Msg = "";
        string ReturnResult = "";
        string str = @"exec usp_CloseAccountCheck " + jo["Year"] + "," + jo["Month"] + ",''";

        DataTable dtResult = SQLServer.GetDataTable(str, ref Msg);

        if (dtResult != null && dtResult.Rows.Count > 0)
        {
            string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
            ReturnResult = jsondata;
        }
        if (dtResult == null)
        {
            ReturnResult = "{\"Result\":\"99\"}";
        }

        context.Response.Write(ReturnResult);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}