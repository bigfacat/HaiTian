<%@ WebHandler Language="C#" Class="Test" %>

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

public class Test : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/html";
        if (context.Request.Files.Count > 0)
        {
            HttpPostedFile postfile = context.Request.Files["myfile"];
            string filename = Path.GetFileName(postfile.FileName);
            string filepath =HttpRuntime.AppDomainAppPath+ "UploadFile\\" + filename;
                            postfile.SaveAs(filepath);

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