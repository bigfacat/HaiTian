<%@ WebHandler Language="C#" Class="OPUserData" %>

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

public class OPUserData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];

        string Msg = "";

        bool bol = false;
        int intResult = 99;
        JObject JSONResult = new JObject();
        string strsql = "";

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        if (jo["op"].ToString() == "1")
        {
            strsql = @"select 1 from t_MyUserAccount where username= '" + jo["user"] + "'";
            DataTable dt = SQLServer.GetDataTable(strsql, ref Msg);
            if (dt != null && dt.Rows.Count > 0)
            {
                Msg = "账号已存在！";
            }
            else if (dt != null && dt.Rows.Count == 0)
            {
                strsql = @"declare @creatorid int=1,@roleid int=1
select @creatorid=id from t_MyUserAccount where username='" + jo["creator"] + @"'
select @roleid=id from t_PlugUserRole where RoleName='" + jo["rolename"] + @"'
insert into t_MyUserAccount values ('" + jo["user"] + @"','" + jo["password"] + @"',getdate(),@creatorid,@roleid)";
                bol = SQLServer.ExecSql(strsql, ref Msg);
            }
        }
        else if (jo["op"].ToString() == "2")
        {
            strsql = @"update t_MyUserAccount set password='" + jo["password"] + @"' where username='" + jo["user"] + @"'";
            bol = SQLServer.ExecSql(strsql, ref Msg);
        }
        else if (jo["op"].ToString() == "0")
        {
            strsql = @"delete from t_MyUserAccount where id='" + jo["id"] + @"'";
            bol = SQLServer.ExecSql(strsql, ref Msg);
        }

        if (bol == true)
        {
            intResult = 100;
        }
        JSONResult["status"] = intResult;
        JSONResult["msg"] = Msg;

        context.Response.Write(JSONResult);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}