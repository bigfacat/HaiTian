using HaiTian;
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
using SQL;

public partial class CalculateSalaryReport : System.Web.UI.Page
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


    protected void exportC_Click(object sender, EventArgs e)
    {

        string y = myear.Value;
        string m = mmonth.Value;

        string Msg = "";
        string str = "exec usp_CalculateSalary " + y + "," + m + ",''";

        DataTable dtResult = SQLServer.GetDataTable(str, ref Msg);

        string filepath = "DownLoadFile\\\\" + y + "年" + m + "月" + "薪资.xlsx";
        string FullFilePath = Server.MapPath("~/") + "DownLoadFile\\" +y+"年"+m+"月"+ "薪资.xlsx";

        if (dtResult == null)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>alert('" + "DataTable为空" + "');</script>", false);
            return;
        }
        ClassHaiTian.TableToExcelForXLSX(dtResult, FullFilePath);

        ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>window.open('"+filepath+"');</script>", false);

    }
    protected void importC_Click(object sender, EventArgs e)
    {
        string y = myear.Value;
        string m = mmonth.Value;
        bool bol = false;

        HttpPostedFile postfile = Context.Request.Files[0];
        string filename = Path.GetFileName(postfile.FileName);
        string filepath = Server.MapPath("~/") + "UploadFile\\" + filename;
        postfile.SaveAs(filepath);

        DataTable exceltable = ClassHaiTian.ExcelToTableForXLSX(filepath);

        int total = exceltable.Rows.Count;

        if (total > 0)
        {
            bol = ClassHaiTian.ImportLeaveData(y, m, exceltable);
        }
        if (bol == true)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>$('#msg').text('导入成功！');$('#alert').dialog({modal: true,height: 90})</script>", false);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>$('#msg').text('导入失败！');$('#alert').dialog({modal: true,height: 90})</script>", false);
        }

    }

}