<%@ WebHandler Language="C#" Class="ChanPinXiLie" %>

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

public class ChanPinXiLie : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request["PostData"];
        string page = context.Request.QueryString["page"];
        string rowsNum = context.Request.QueryString["rows"];
        String sidx = context.Request.QueryString["sidx"];//来获得排序的列名，
        String sord = context.Request.QueryString["sord"];//来获得排序方式，即为重新检索数据，根据所取得的字段值进行重新的查询，然后返回到本页面。当你重复点击列首时，其排序方式是交替改变的。
                                                          //HttpPostedFile postfile = context.Request.Files[0];

        string username = "";
        string pagename = "";//控制页面权限用
        //新建和修改角色用
        string rolename = "";
        string remark;
        string creator ;
        JArray Rows ;//


        int intResult = 99;
        JObject JSONResult = new JObject();

        DataTable dtResult = null;
        string ReturnResult = "";
        bool bol = false;
        string Msg = "";
        string sql = "";
        string jsondata = "";

        if (page == null)
        {
            page = "1";
        }
        if (rowsNum == null)
        {
            rowsNum = "200";
        }
        if (sidx == null)
        {
            sidx = "";
        }
        if (sord == null)
        {
            sord = "";
        }

        int intPage = int.Parse(page);
        int intRows = int.Parse(rowsNum);

        if (PostData == null)
        {
            context.Response.Write("PostData为空");
            return;
        }

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        if (jo["op"] == null)
        {
            jo["op"] = "";
        }

        string op = jo["op"].ToString();

        switch (op)
        {
            case "GetUser":
                if (jo["username"] == null)
                {
                    jo["username"] = "";
                }
                username = jo["username"].ToString();
                sql = "select FUserID,FName,FDescription from t_User where 1=1";

                if (username != null && username != "" && username != "undefined")
                {
                    sql += " and FName like '%" + username + "%'";
                }

                dtResult = SQLServer.GetDataTable(sql, ref Msg);
                jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
                ReturnResult = jsondata;

                break;
            case "LoadRole":
                rolename     =   jo["rolename"].ToString();
                dtResult = User.LoadRoleData(rolename);

                jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
                ReturnResult = jsondata;

                break;
            case "AddRole":
                rolename     =   jo["rolename"].ToString();


                remark= jo["remark"].ToString();
                creator= jo["creator"].ToString();
                Rows= (JArray)(jo["rows"]);

                bol = User.AddPlugRole(rolename,remark,creator,Rows,ref Msg);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;
                break;

            case "DeteleRole":
                rolename     =   jo["rolename"].ToString();

                bol = User.DeletePlugRole(rolename,ref Msg);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;
                break;

            case "ChangeRole":
                rolename     =   jo["rolename"].ToString();
                username     =   jo["username"].ToString();
                bol = User.ChangePlugRole(username,rolename,ref Msg);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;
                break;


            case "EditRole":
                rolename     =   jo["rolename"].ToString();
                remark= jo["remark"].ToString();
                Rows= (JArray)(jo["rows"]);

                bol = User.EditPlugRole(rolename,remark,Rows,ref Msg);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;
                break;


            case "EditPermission":
                rolename     =   jo["rolename"].ToString();

                Rows= (JArray)(jo["rows"]);

                bol = User.EditPlugRolePermission(rolename,Rows);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;

                break;

            case "LoadRolePermission":
                rolename     =   jo["rolename"].ToString();
                dtResult = User.LoadRolePermission(rolename);

                jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
                ReturnResult = jsondata;

                break;

            case "LoadRoleBothPermission":
                rolename     =   jo["rolename"].ToString();
                DataTable dt1 = User.LoadRoleNotHavePermission(rolename);
                DataTable dt2= User.LoadRoleHavePermission(rolename);
                string   jsondata1 = Public.GetJQGridJSONFromDT(dt1);
                string   jsondata2 = Public.GetJQGridJSONFromDT(dt2);

                ReturnResult = "[" + jsondata1 + "," + jsondata2 + "]";

                break;


            case "LoadPlugResource":
                dtResult = User.LoadPlugResource();

                jsondata = Public.GetJQGridJSONFromDT(dtResult);
                ReturnResult = jsondata;

                break;

            case "LoadUserWebPagePermission":
                username     =   jo["username"].ToString();
                pagename = jo["pagename"].ToString();
                bol = User.LoadUserWebPagePermission(username,pagename);

                if (bol == true)
                {
                    intResult = 100;
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                context.Response.Write(JSONResult);
                return;
                break;

            case "LoadPlugButtonResource":

                username = jo["username"].ToString();
                pagename = jo["pagename"].ToString();
                dtResult = User.LoadPlugButtonResource(username,pagename);
                jsondata = JsonConvert.SerializeObject(dtResult);
                ReturnResult = jsondata;

                break;

            default: /* 可选的 */ //默认查询功能
                if (jo["username"] == null)
                {
                    jo["username"] = "";
                }
                username = jo["username"].ToString();

                sql = @"select mu.id,mu.username,mu.CreateDate,ua.username as creator,ur.RoleName,FDescription from t_MyUserAccount mu
join t_User u on mu.username=u.FName
left join t_MyUserAccount ua on mu.Creator=ua.id
left join t_PlugUserRole ur on mu.BelongToRole=ur.id where 1=1";

                if (username != null && username != "" && username != "undefined")
                {
                    sql += " and mu.username like '%" + username + "%'";
                }

                dtResult = SQLServer.GetDataTable(sql, ref Msg);
                jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
                ReturnResult = jsondata;

                break;
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