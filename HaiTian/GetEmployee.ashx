<%@ WebHandler Language="C#" Class="GetEmployee" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
using HaiTian;

public class GetEmployee : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string emp = context.Request.QueryString["emp"];
        string strSql = "";
        strSql = @"select emp.FNumber,emp.FName,d.FNumber,d.FName from t_Emp emp
left join t_Department d on emp.FDepartmentID=d.FItemID where emp.FDeleted=0";

        //正式环境用
        //        strSql = @"select emp.FNumber,emp.FName,d.FNumber,d.FName from t_Emp emp
        //left join t_Department d on emp.FDepartmentID=d.FItemID where emp.FDeleted=0
        //and (F_107=(select FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FName='计时/计件') and FName='计件') or F_107 is null)";

        if (emp != null && emp != "")
        {
            strSql += " and (emp.FNumber like '%" + emp + "%' or emp.FName like '%" + emp + "%')";
        }

        DataTable dtResult = Program.GetDataTableBySqlText(strSql);

        string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
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