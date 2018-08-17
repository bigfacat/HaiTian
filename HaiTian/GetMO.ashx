<%@ WebHandler Language="C#" Class="GetMO" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using ConsoleApplication1;
using Newtonsoft.Json;
using HaiTian;

public class GetMO : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string mo = context.Request.QueryString["mo"];

        using (SqlConnection conn = new SqlConnection())
        {
            using (SqlCommand cmd = new SqlCommand())
            {

                string strSql = @"
select FInterID,FBillNo,FNumber,FName from ICMO mo 
join t_ICItem ic on mo.FItemID=ic.FItemID
where FCancellation='0' and FStatus in (1)";
                if (mo != null && mo != "")
                {
                    strSql += " and FBillNo like '%" + mo + "%'";
                }
                strSql += " order by FBillNo";

                DataTable dtResult = Program.GetDataTableBySqlText(strSql);

                string jsondata = Public.GetJQGridJSONFromDT(dtResult);
                context.Response.Write(jsondata);
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}