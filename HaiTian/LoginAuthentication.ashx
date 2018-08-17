<%@ WebHandler Language="C#" Class="LoginAuthentication" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class LoginAuthentication : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string username = context.Request.QueryString["username"];
        string password = context.Request.QueryString["password"];

        string Msg = "";
        int Result = 99;
        string str = "select 1 from t_MyUserAccount where username='" + username + "' and password='" + password + "'";
        DataTable dt = SQLServer.GetDataTable(str,ref Msg);
        if (dt != null && dt.Rows.Count > 0)
        {
            Result = 100;
        }

        context.Response.Write(Result);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}