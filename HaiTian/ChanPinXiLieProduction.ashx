<%@ WebHandler Language="C#" Class="ChanPinXiLieProduction" %>

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

public class ChanPinXiLieProduction : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string cpxl = context.Request["cpxl"];
        string prd = context.Request["prd"];
        string PostData = context.Request.Form["PostData"];

        string op = context.Request["op"];
        string page = context.Request.QueryString["page"];
        string rows = context.Request.QueryString["rows"];

        if (page == null)
        {
            page = "1";
        }
        if (rows == null)
        {
            rows = "200";
        }

        int intPage = int.Parse(page);
        int intRows = int.Parse(rows);


        int intResult = 99;
        string jsondata = "";

        JObject jo = new JObject();
        DataTable dtResult = null;
        string ReturnResult = "";
        bool bol = false;
        string Msg = "";
        string[] prd_arr=null;

        if (Public.HasValue(PostData))
        {
            prd_arr = PostData.Split(',');
        }

        switch (op)
        {
            case "GetCPXLProduction":
                //获取产品系列对应成品物料信息
                dtResult = CPXL.GetCPXLProduction(cpxl, ref Msg);
                jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage, intRows, dtResult);
                ReturnResult = jsondata;
                break;
            case "GetCPXLProductionDetail":
                //获取产品系列对应成品物料信息
                dtResult = CPXL.GetCPXLProductionDetail(cpxl, ref Msg);
                jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage, intRows, dtResult);
                ReturnResult = jsondata;
                break;

            case "GetProduction":
                //获取产品系列对应成品物料信息
                dtResult = CPXL.GetProduction(prd, ref Msg);
                jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage, intRows, dtResult);
                ReturnResult = jsondata;
                break;
            case "Save":
                //产品系列对应成品物料保存
                bol = CPXL.CPXLProductionSave(cpxl, prd_arr, ref Msg);
                if (bol == true)
                {
                    intResult = 100;
                }
                jo = Public.ReturnJObject(intResult, Msg);
                ReturnResult = jo.ToString();
                break;
            case "Delete":
                //产品系列对应成品物料保存
                bol = CPXL.CPXLProductionDelete(cpxl, ref Msg);
                if (bol == true)
                {
                    intResult = 100;
                }
                jo = Public.ReturnJObject(intResult, Msg);
                ReturnResult = jo.ToString();
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