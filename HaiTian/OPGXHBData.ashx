<%@ WebHandler Language="C#" Class="OpGXHBData" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Data;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class OpGXHBData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string PostData = context.Request.QueryString["PostData"];
        string y = context.Request.QueryString["y"];
        string emp = context.Request.QueryString["emp"];
        string status = context.Request.QueryString["status"];

        if (PostData == null)
        {
            return;
        }

        string Msg = "";

        JObject jo = (JObject)JsonConvert.DeserializeObject(PostData);
        JArray ja = (JArray)jo["rows"];

        int intResult = 99;
        bool bol = false;
        string strsql = "";
        if (ja != null && ja.Count > 0)
        {
            string str = "select FEntryIndex from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID where FBillNo='" + jo["billno"] + "'";
            DataTable dt = SQLServer.GetDataTable(str, ref Msg);
            if (dt != null && dt.Rows.Count > 0)
            {
                string FEntryIndex = dt.Rows[0][0].ToString();
                strsql = @"
declare @FinterID int,@FworkerID int
select @FinterID = FinterID from t_GXHB where FBillNo = '" + jo["billno"] + @"'
update t_GXHB set FWBNO = '" + jo["wbno"] + "',FDate = CONVERT(datetime,'" + jo["billdate"] + "') where FBillNo = '" + jo["billno"] + @"'
delete from t_GXHBEntry where FinterID = @FinterID";

                for (int i = 0; i < ja.Count; i++)
                {
                    strsql += " select @FworkerID = (select top 1 FItemID from t_Emp emp where emp.FNumber = '" + ja[i]["emp"] + @"') insert into t_GXHBEntry values(@FinterID," + ja[i]["entryID"] + ", 0,isnull(@FworkerID,0), 0, 0, GETDATE(), GETDATE(), " + ja[i]["finishqty"] + ", 0, 0, 1059, 0)";
                }
            }
            else if (dt != null && dt.Rows.Count == 0)
            {
                strsql = @"declare @FInterID int,@FworkerID int,@FUserID int
UPDATE ICMaxNum SET FMaxNum = ISNULL(FMaxNum,0) + 1 WHERE FTableName = 'SHProcRptMain'
SELECT @FInterID = isnull(in1.FMaxNum,0) FROM ICMaxNum in1 WHERE in1.FTableName = 'SHProcRptMain'
select @FUserID=FUserID from t_User where FName='" + jo["biller"] + @"'
exec [usp_Com_UpdateFBillNO] 582
insert into t_GXHB values(@FInterID,'" + jo["billno"] + @"',582,CONVERT(datetime,'" + jo["billdate"] + "'),@FUserID,null,null,0,0,150,0,'" + jo["wbno"] + @"',0,1059,52,0)";
                for (int i = 0; i < ja.Count; i++)
                {

                    strsql += @" select @FworkerID=(select top 1 FItemID from t_Emp emp where emp.FNumber='" + ja[i]["emp"] + @"') insert into t_GXHBEntry values(@FinterID,'" + ja[i]["entryID"] + "',0,isnull(@FworkerID,0),0,0,GETDATE(),GETDATE()," + ja[i]["finishqty"] + ",0,0,1059,0)";
                }
            }
            bol = SQLServer.ExecSql(strsql, ref Msg);
        }

        if (bol == true)
        {
            intResult = 100;
        }

        context.Response.Write(intResult);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}