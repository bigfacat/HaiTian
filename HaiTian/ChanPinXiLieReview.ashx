<%@ WebHandler Language="C#" Class="ChanPinXiLieReview" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SQL;
using System.IO;
using HaiTian;
using System.Diagnostics;
using Newtonsoft;
using System.Collections.Generic;

public class ChanPinXiLieReview : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.Form["PostData"];
        string op = context.Request["op"];
        //string Post = context.Request.Form[0];

        int intResult = 99;
        string Msg = "";
        bool bol = false;
        //string ReturnResult = "";
        string[] arr = PostData.Split(',');
        switch (op)
        {
            case "review":
                bol = CPXL.CPXLReview(arr, ref Msg);
                if (bol == true)
                {
                    intResult = 100;
                }
                break;
            case "cancelreview":
                bol = CPXL.CPXLCancelReview(arr, ref Msg);
                if (bol == true)
                {
                    intResult = 100;
                }
                break;
            case "Delete":
                bol = CPXL.BatchDeleteCPXLSup(arr, ref Msg);
                if (bol == true)
                {
                    intResult = 100;
                }
                break;

        }
        JObject jo = Public.ReturnJObject(intResult, Msg);

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