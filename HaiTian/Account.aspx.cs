using SQL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using Newtonsoft.Json;
using System.Collections;
using System.IO;
using Newtonsoft.Json.Linq;

public partial class Account : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }

        if (IsPostBack)
        {
        }

    }

    [WebMethod]
    public static string GetXiLieName(string no)
    {
        string Msg = "";

        string strSql = @"select FNumber+'|'+FName as xiliename from t_chanpinxilie cp join t_item it on cp.xilieID=it.FItemID";
        DataTable dtResult = SQLServer.GetDataTable(strSql, ref Msg);
        string Jsonstring = string.Empty;
        Jsonstring = JsonConvert.SerializeObject(dtResult);
        return Jsonstring;
    }

    [WebMethod]
    public static string LoadChanPinXiLieData()
    {
        string Msg = "";

        string strSql = @"select *from t_xiliefenlei xl";
        DataTable dtResult = SQLServer.GetDataTable(strSql, ref Msg);
        string Jsonstring = string.Empty;
        Jsonstring = JsonConvert.SerializeObject(dtResult);

        string jsondata = "{\"page\":\"1\"," +
        "      \"total\":2," +
        "      \"records\":\"13\"," +
        "      \"rows\":" +
        "          [";

        for (int i = 0; i < dtResult.Rows.Count; i++) {
            string colstr = "[\""+ dtResult.Rows[i][0]+"\"";

            for (int j = 1; j < dtResult.Columns.Count; j++)
            {
                colstr += ",\""+dtResult.Rows[i][j]+"\"";
            }
            colstr += "]";

            string rowstr = "{" +
    "              \"id\":\"13\"," +
    "              \"cell\":" +colstr;
            rowstr += "}";
            jsondata += rowstr;
        }

        jsondata += "]}";
        return jsondata;
    }


    [WebMethod]
    public static int EditAccountData(string PostData)
    {
        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);

        int intResult = 99;
        bool bol = false;

        string Msg = "";

        string str = "select id from t_AccountStatus where year=" + jo["Year"] + " and month=" + jo["Month"];
        DataTable dt = SQLServer.GetDataTable(str,ref Msg);
        if (dt != null && dt.Rows.Count > 0)
        {
            string id = dt.Rows[0][0].ToString();
            str = "update t_AccountStatus set status=" + jo["Switch"] + " where id=" + id + "";
        }
        else if (dt != null && dt.Rows.Count == 0)
        {
            str = "insert into t_AccountStatus values(" + jo["Year"] + "," + jo["Month"] + "," + jo["Switch"] + ")";
        }
        bol = SQLServer.ExecSql(str, ref Msg);

        if (bol == true)
        {
            intResult = 100;
        }

        return intResult;
    }

    [WebMethod]
    public static bool AddChanPinXiLieData(string PostData)
    {
        string Msg = "";
        JArray ja = (JArray)JsonConvert.DeserializeObject(PostData);
        JObject o = (JObject)ja[0];

        bool bol = false;

        if (ja != null && ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                string str = "insert into t_chanpinxilie values(" + ja[i]["xilie"] + "," + ja[i]["material"] + "," + ja[i]["supplier"] + ")";
                bol = SQLServer.ExecSql(str, ref Msg);
            }
        }
        return bol;
    }

}