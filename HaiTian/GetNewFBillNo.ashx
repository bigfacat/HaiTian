<%@ WebHandler Language="C#" Class="GetNewFBillNo" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
    using HaiTian;

public class GetNewFBillNo : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string prefixText = context.Request.QueryString["q"];
        string y = context.Request.QueryString["y"];
        string emp = context.Request.QueryString["emp"];
        string status = context.Request.QueryString["status"];

        using (SqlConnection conn = new SqlConnection())
        {
            using (SqlCommand cmd = new SqlCommand())
            {

                string strSql = @"
declare @FBillNo varchar(50)
exec [usp_Com_GetFBillNO] 582,@FBillNo output
select @FBillNo";
                if (y!=null&&y != "")
                {
                    strSql += " and year=" + y;
                }
                if (emp != null&&emp != "")
                {
                    strSql += " and FNumber like '%" + emp+"%'";
                }
                if (status!= null&&status!= "")
                {
                    strSql += " and status=" + status;
                }

                DataTable dtResult = Program.GetDataTableBySqlText(strSql);

        string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
        context.Response.Write(jsondata);
            }
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}