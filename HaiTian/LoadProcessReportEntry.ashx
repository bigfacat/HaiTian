<%@ WebHandler Language="C#" Class="LoadProcessReportEntry" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
    using HaiTian;

public class LoadProcessReportEntry : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string prefixText = context.Request.QueryString["q"];
        string billno = context.Request.QueryString["billno"];
        string m = context.Request.QueryString["m"];
        string status = context.Request.QueryString["status"];

        using (SqlConnection conn = new SqlConnection())
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                string strSql = @"select FEntryIndex,FEntryID,emp.FNumber,emp.FName,convert(decimal(8,2),ge.FAuxQtyfinish) from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID
left join t_Emp emp on ge.FworkerID=emp.FItemID where 1=1";
                if (billno!=null&&billno != "")
                {
                    strSql += " and g.fbillno='" + billno + "'";
                }
                if (m != null&&m != "")
                {
                    strSql += " and month=" + m;
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