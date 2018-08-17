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
using System.IO;


public class ChanPinXiLie : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request["PostData"];
        string page = context.Request.QueryString["page"];
        string rows = context.Request.QueryString["rows"];
        string sidx = context.Request.QueryString["sidx"];//来获得排序的列名，
        string sord = context.Request.QueryString["sord"];//来获得排序方式，即为重新检索数据，根据所取得的字段值进行重新的查询，然后返回到本页面。当你重复点击列首时，其排序方式是交替改变的。

        //HttpPostedFile postfile = context.Request.Files[0];

        DataTable dtResult = null;
        string ReturnResult = "";
        string jsondata = "";
        bool bol = false;
        string Msg = "";
        int intResult = 99;

        if (page == null)
        {
            page = "1";
        }
        if (rows == null)
        {
            rows = "200";
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
        int intRows = int.Parse(rows);

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
            case "Import":

                if (context.Request.Files.Count == 0)
                {
                    intResult = 99;
                    Msg = "未选择导入文件！";
                }
                else
                {
                    HttpPostedFile postfile = context.Request.Files["myfile"];
                    string filename = Path.GetFileName(postfile.FileName);
                    string filepath = HttpRuntime.AppDomainAppPath + "UploadFile\\" + filename;
                    postfile.SaveAs(filepath);

                    bol = CPXL.importCPXL(filepath, ref Msg);
                    if (bol == true)
                    {
                        intResult = 100;
                    }
                }
                JObject obj=Public.ReturnJObject(intResult,Msg);
                ReturnResult = obj.ToString();
                break;

            case "GetAutoCompleteSup":
                if (jo["sup"] == null)
                {
                    jo["sup"] = "";
                }

                dtResult = CPXL.GetAutoCompleteSup(jo["sup"].ToString());
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    jsondata = Public.GetJQGridJSONFromDT(dtResult);
                    ReturnResult = jsondata;
                }

                break;

            case "GetSup":
                if (jo["sup"] == null)
                {
                    jo["sup"] = "";
                }

                dtResult = CPXL.GetSupData(jo["sup"].ToString());
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    jsondata = ClassHaiTian.GetJQGridJSONData(dtResult);
                    ReturnResult = jsondata;
                }

                break;
            case "GetCPXL":
                if (jo["cpxl"] == null)
                {
                    jo["cpxl"] = "";
                }

                dtResult = CPXL.GetCPXL(jo["cpxl"].ToString());
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    jsondata = Public.GetJQGridJSONFromDT(dtResult);
                    ReturnResult = jsondata;
                }

                break;

            case "Expand":
                if (jo["cpxl"] == null)
                {
                    jo["cpxl"] = "";
                }
                if (sidx == "")
                {
                    sidx = "mat";
                }
                if (sord == "")
                {
                    sord = "asc";
                }

                dtResult = CPXL.ExpandMaterialByCPXL(jo["cpxl"].ToString());

                //DataView dw = dtResult.DefaultView;
                //dw.Sort = sidx + " " + sord;
                //DataTable dt = dw.ToTable();

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    jsondata = Public.GetJQGridJSONFromDT(dtResult);
                    ReturnResult = jsondata;
                }

                break;

            case "Save":
                JArray ja = (JArray)jo["rows"];
                bol = CPXL.SaveCPXLDataQuickly(ja);

                if (bol == false)
                {
                    ReturnResult = "99";

                }
                else if (bol == true)
                {
                    ReturnResult = "100";
                }

                break;

            //供应商更换
            case "ChangeSup":
                string oldsup = jo["oldsup"].ToString();
                string newsup = jo["newsup"].ToString();
                string CPXLids = jo["CPXLids"].ToString();

                if (CPXLids != "")
                {
                    CPXLids = CPXLids.Substring(0, CPXLids.Length - 1);
                }
                int ROWCOUNT = 0;
                bol = CPXL.CPXLChangeSup(CPXLids, oldsup, newsup, ref Msg, ref ROWCOUNT);

                if (bol == true)
                {
                    intResult = 100;
                }

                jo = Public.ReturnJObject(intResult, Msg);
                jo.Add("rowcount", ROWCOUNT);
                ReturnResult = jo.ToString();
                break;

            default: /* 可选的 */ //默认查询功能
                if (jo["cpxl"] == null)
                {
                    jo["cpxl"] = "";
                }

                if (jo["sup"] == null)
                {
                    jo["sup"] = "";
                }

                dtResult = CPXL.LoadCPXLData(jo["cpxl"].ToString(), jo["sup"].ToString());
                jsondata = ClassHaiTian.GetJQGridJSONDataWithPage(intPage, intRows, dtResult);
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