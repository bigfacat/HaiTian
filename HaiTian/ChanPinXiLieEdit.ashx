<%@ WebHandler Language="C#" Class="ChanPinXiLieEdit" %>

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

public class ChanPinXiLieEdit : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string sup = context.Request["sup"];
        string id = context.Request["id"];
        string oper = context.Request["oper"];

        int intResult = 99;
        JObject jo = new JObject();
        DataTable dtResult = null;
        string ReturnResult = "";
        bool bol = false;
        string Msg = "";

        switch (oper)
        {
            case "edit":
                if (!Public.HasValue(sup))
                {
                    ReturnResult = "";
                    context.Response.Write(ReturnResult);
                    return;
                }
                string[] arr = sup.Split('|');
                string SupNo = arr[0];

                string name = "";
                string number = "";

                dtResult = CPXL.GetSupName(SupNo);

                if (dtResult.Rows.Count == 0)
                {
                }
                else
                {
                    name = dtResult.Rows[0]["FName"].ToString();
                    number = dtResult.Rows[0]["FNumber"].ToString();

                    jo.Add("FName", name);
                    jo.Add("FNumber", number);
                    jo.Add("id", id);

                    bol = CPXL.CPXLEditSup(id, SupNo, ref Msg);
                    if (bol == true)
                    {
                        intResult = 100;
                    }
                    jo.Add("status", intResult);
                    jo.Add("msg", Msg);

                }

                break;
            case "RestoreSup":
                dtResult = CPXL.CPXLRestoreSup(id, ref Msg);

                if (dtResult.Rows.Count == 0)
                {
                }
                else
                {
                    name = dtResult.Rows[0]["FName"].ToString();
                    number = dtResult.Rows[0]["FNumber"].ToString();

                    jo.Add("FName", name);
                    jo.Add("FNumber", number);
                    jo.Add("id", id);

                }
                break;
        }

        //jsondata = JsonConvert.SerializeObject(dtResult);
        ReturnResult = jo.ToString();
        context.Response.Write(jo);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}