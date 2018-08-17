<%@ WebHandler Language="C#" Class="CalculateSalaryReport" %>

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

public class CalculateSalaryReport : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request["PostData"];

        int intResult = 99;
        JObject JSONResult = new JObject();
        string ReturnResult = "";

        bool bol = false;
        string Msg = "";
        string str = "";
        DataTable dtResult;

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        string op = jo["op"].ToString();

        string year = jo["year"].ToString();
        string month = jo["month"].ToString();

        switch (op)
        {
            case "ImportCost":
                int count=0;
                str = "exec usp_ImportDirectLaborCostsToCostObj " + year + "," + month;

                DataTable dt = SQLServer.GetDataTable(str, ref Msg);
                if (dt != null && dt.Rows.Count > 0)
                {
                    intResult = int.Parse(dt.Rows[0][0].ToString());
                    if (intResult == 100)
                    {
                        count = int.Parse(dt.Rows[0][1].ToString());
                    }
                    else
                    {
                        Msg = dt.Rows[0][1].ToString();
                    }
                }

                JSONResult = Public.ReturnJObject(intResult, Msg);
                JSONResult.Add("count",count);
                ReturnResult = JSONResult.ToString();
                break;

            default: /* 可选的 */
                str = "exec usp_CalculateSalary " + year + "," + month+",''";

                dtResult = SQLServer.GetDataTable(str, ref Msg);

                string jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
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