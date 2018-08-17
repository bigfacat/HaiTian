using ConsoleApplication1;
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
using HaiTian;

public partial class ChanPinXiLie : System.Web.UI.Page
{
    DataTable dt = null;
    public static string workshop = "";
    public static string workline = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

        }

        if (IsPostBack)
        {
        }

    }

    protected void importC_Click(object sender, EventArgs e)
    {
        HttpPostedFile postfile = Request.Files[0];
        string filename = Path.GetFileName(postfile.FileName);
        string filepath = Server.MapPath("~/") + "UploadFile\\" + filename;
        postfile.SaveAs(filepath);

        DataTable exceltable = Class1.ExcelToTableForXLSX(filepath);

        int total = exceltable.Rows.Count;
        int suc = 0;
        for (int i = 0; i < exceltable.Rows.Count; i++)
        {
            bool bol;

            string str1 = exceltable.Rows[i]["产品系列"].ToString().Trim();
            string str2 = exceltable.Rows[i]["物料"].ToString().Trim();
            string str3 = exceltable.Rows[i]["供应商"].ToString().Trim();

            bool repeating = CPXL.RepeatingData(str1, str2, str3);
            if (repeating == true)
            {
                bol = CPXL.SaveCPXLData(true, str1, str2, str3);
            }
            else
            {
                bol = CPXL.SaveCPXLData(false, str1, str2, str3);
            }
            if (bol == true)
            {
                suc++;
            }
        }
        if (suc > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>$('#msg').text('资料已导入！成功" + suc + "条，共" + total + "条');$('#alert').dialog({modal: true,height: 90})</script>", false);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>$('#msg').text('导入失败！');$('#alert').dialog({modal: true,height: 90})</script>", false);
        }

    }

    public DataTable GetDataTableFromGridView(GridView gv, DataTable DT, ref string Error)
    {
        DT.Rows.Clear();

        for (int j = 0; j < gv.Rows.Count; j++)
        {
            DataRow dr = DT.NewRow();

            Label lbid = (Label)gv.Rows[j].FindControl("lbid");
            if (lbid.Text != "")
            {
                dr["lbid"] = lbid.Text.Trim();
            }

            TextBox tbsalesOrder = (TextBox)gv.Rows[j].FindControl("tbsalesOrder");
            dr["SEOrder"] = tbsalesOrder.Text.Trim();

            DropDownList ddlFSEQ = (DropDownList)gv.Rows[j].FindControl("ddlFSEQ");
            if (ddlFSEQ.Text != "")
            {
                dr["FSEQ"] = ddlFSEQ.Text.Trim();
            }

            Label lblFQty = (Label)gv.Rows[j].FindControl("lblFQty");
            if (lblFQty.Text != "")
            {
                dr["FQty"] = lblFQty.Text.Trim();
            }

            TextBox tbMO = (TextBox)gv.Rows[j].FindControl("tbMO");
            if (tbMO.Text != "")
            {
                dr["TaskOrder"] = tbMO.Text.Trim();
            }

            Label lblFNumber = (Label)gv.Rows[j].FindControl("lblFNumber");
            if (lblFNumber.Text != "")
            {
                dr["FNumber"] = lblFNumber.Text.Trim();
            }

            Label lblMName = (Label)gv.Rows[j].FindControl("lblMName");
            if (lblMName.Text != "")
            {
                dr["MaterialName"] = lblMName.Text.Trim();
            }

            TextBox TaskOrderNum = (TextBox)gv.Rows[j].FindControl("lblNum");

            if (TaskOrderNum.Text.Trim() != "")
            {
                if (IsNumeric(TaskOrderNum.Text.Trim()) || IsInt(TaskOrderNum.Text.Trim()))
                {
                    dr["TaskOrderNum"] = TaskOrderNum.Text.Trim();
                }
                else
                {
                    Error = TaskOrderNum.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbplandate = (TextBox)gv.Rows[j].FindControl("tbplandate");
            if (tbplandate.Text != "")
            {
                dr["LineDate"] = tbplandate.Text.Trim();
            }

            Label lbloutdate = (Label)gv.Rows[j].FindControl("lbloutdate");
            if (lbloutdate.Text != "")
            {
                dr["FPLANDELIVERYDATE"] = lbloutdate.Text.Trim();
            }

            TextBox tbsunday = (TextBox)gv.Rows[j].FindControl("tbsunday");
            if (tbsunday.Text.Trim() != "")
            {
                if (IsNumeric(tbsunday.Text.Trim()) || IsInt(tbsunday.Text.Trim()))
                {
                    dr["SunNum"] = tbsunday.Text.Trim();
                }
                else
                {
                    Error = tbsunday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbmonday = (TextBox)gv.Rows[j].FindControl("tbmonday");
            if (tbmonday.Text.Trim() != "")
            {
                if (IsNumeric(tbmonday.Text.Trim()) || IsInt(tbmonday.Text.Trim()))
                {
                    dr["MonNum"] = tbmonday.Text.Trim();
                }
                else
                {
                    Error = tbmonday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbtuesday = (TextBox)gv.Rows[j].FindControl("tbtuesday");
            if (tbtuesday.Text.Trim() != "")
            {
                if (IsNumeric(tbtuesday.Text.Trim()) || IsInt(tbtuesday.Text.Trim()))
                {
                    dr["TuesNum"] = tbtuesday.Text.Trim();
                }
                else
                {
                    Error = tbtuesday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbwednesday = (TextBox)gv.Rows[j].FindControl("tbwednesday");
            if (tbwednesday.Text.Trim() != "")
            {
                if (IsNumeric(tbwednesday.Text.Trim()) || IsInt(tbwednesday.Text.Trim()))
                {
                    dr["WedNum"] = tbwednesday.Text.Trim();
                }
                else
                {
                    Error = tbwednesday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbThursday = (TextBox)gv.Rows[j].FindControl("tbThursday");
            if (tbThursday.Text.Trim() != "")
            {
                if (IsNumeric(tbThursday.Text.Trim()) || IsInt(tbThursday.Text.Trim()))
                {
                    dr["ThurNum"] = tbThursday.Text.Trim();
                }
                else
                {
                    Error = tbThursday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbFriday = (TextBox)gv.Rows[j].FindControl("tbFriday");
            if (tbFriday.Text.Trim() != "")
            {
                if (IsNumeric(tbFriday.Text.Trim()) || IsInt(tbFriday.Text.Trim()))
                {
                    dr["FriNum"] = tbFriday.Text.Trim();
                }
                else
                {
                    Error = tbFriday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            TextBox tbSaturday = (TextBox)gv.Rows[j].FindControl("tbSaturday");
            if (tbSaturday.Text.Trim() != "")
            {
                if (IsNumeric(tbSaturday.Text.Trim()) || IsInt(tbSaturday.Text.Trim()))
                {
                    dr["SatNum"] = tbSaturday.Text.Trim();
                }
                else
                {
                    Error = tbSaturday.Text.Trim() + "不是数字,请重新输入!";
                }
            }

            DateTime first = DateTime.MinValue;
            DateTime last = DateTime.MaxValue;
            //bool b = GetDaysOfWeeks(Convert.ToInt32(select_year.SelectedValue), Convert.ToInt32(select_week.SelectedValue), out first, out last);

            Label lblSunday = (Label)gv.HeaderRow.FindControl("lblSunday");
            if (lblSunday.Text != "")
            {
                dr["SunDate"] = last.AddDays(-6);
            }

            Label lblMonday = (Label)gv.HeaderRow.FindControl("lblMonday");
            if (lblMonday.Text != "")
            {
                dr["MonDate"] = last.AddDays(-5);
            }

            Label lblTuesday = (Label)gv.HeaderRow.FindControl("lblTuesday");
            if (lblTuesday.Text != "")
            {
                dr["TuesDate"] = last.AddDays(-4);
            }

            Label lblWednesday = (Label)gv.HeaderRow.FindControl("lblWednesday");
            if (lblWednesday.Text != "")
            {
                dr["WedDate"] = last.AddDays(-3);
            }

            Label lblThursday = (Label)gv.HeaderRow.FindControl("lblThursday");
            if (lblThursday.Text != "")
            {
                dr["ThurDate"] = last.AddDays(-2);
            }

            Label lblFriday = (Label)gv.HeaderRow.FindControl("lblFriday");
            if (lblFriday.Text != "")
            {
                dr["FriDate"] = last.AddDays(-1);
            }

            Label lblSaturday = (Label)gv.HeaderRow.FindControl("lblSaturday");
            if (lblSunday.Text != "")
            {
                dr["SatDate"] = last;
            }

            DT.Rows.Add(dr);

        }
        return DT;
    }

    public static bool IsNumeric(string value)
    {
        return Regex.IsMatch(value, @"^[+-]?\d+[.]\d*$");
        //return Regex.IsMatch(value, @"\d");
    }
    public static bool IsInt(string value)
    {
        return Regex.IsMatch(value, @"^[+-]?\d+$");
    }

    /// <summary>
    /// 获取指定周数的开始日期和结束日期，开始日期为周日
    /// </summary>
    /// <param name="year">年份</param>
    /// <param name="index">周数</param>
    /// <param name="first">当此方法返回时，则包含参数 year 和 index 指定的周的开始日期的 System.DateTime 值；如果失败，则为 System.DateTime.MinValue。</param>
    /// <param name="last">当此方法返回时，则包含参数 year 和 index 指定的周的结束日期的 System.DateTime 值；如果失败，则为 System.DateTime.MinValue。</param>
    /// <returns></returns>
    public static bool GetDaysOfWeeks(int year, int index, out DateTime first, out DateTime last)
    {
        first = DateTime.MinValue;
        last = DateTime.MaxValue;
        if (year < 1700 || year > 9999)
        {
            //"年份超限"
            return false;
        }
        if (index < 1 || index > 53)
        {
            //"周数错误"
            return false;
        }
        DateTime startDay = new DateTime(year, 1, 1);  //该年第一天
        DateTime endDay = new DateTime(year + 1, 1, 1).AddMilliseconds(-1);
        int dayOfWeek = 0;
        if (Convert.ToInt32(startDay.DayOfWeek.ToString("d")) > 0)
            dayOfWeek = Convert.ToInt32(startDay.DayOfWeek.ToString("d"));  //该年第一天为星期几
        if (dayOfWeek == 7) { dayOfWeek = 0; }
        if (index == 1)
        {
            first = startDay;
            if (dayOfWeek == 6)
            {
                last = first;
            }
            else
            {
                last = startDay.AddDays((6 - dayOfWeek));
            }
        }
        else
        {
            first = startDay.AddDays((7 - dayOfWeek) + (index - 2) * 7); //index周的起始日期
            last = first.AddDays(6);
            //if (last > endDay)
            //{
            //    last = endDay;
            //}
        }
        if (first > endDay)  //startDayOfWeeks不在该年范围内
        {
            //"输入周数大于本年最大周数";
            return false;
        }
        return true;
    }


    [WebMethod]
    public static string GetProduction(string no)
    {
        string strSql = @"select c.FNAME,a.FMATERIALID,a.FNUMBER,a.FNUMBER+'|'+c.FNAME as production from T_BD_MATERIAL a
join T_BD_MATERIALBASE b on a.FMATERIALID = b.FMATERIALID
join T_BD_MATERIAL_L c on b.FMATERIALID = c.FMATERIALID
join T_BD_MATERIALCATEGORY cg on b.FCATEGORYID=cg.FCATEGORYID
join T_BD_MATERIALCATEGORY_L cgl on cg.FCATEGORYID=cgl.FCATEGORYID
where cg.FCATEGORYID=239 or cg.FCATEGORYID = 241";
        DataTable dtResult = Program.GetDataTableBySqlText(strSql);
        string Jsonstring = string.Empty;
        Jsonstring = JsonConvert.SerializeObject(dtResult);
        return Jsonstring;
    }



    protected void tbprd_TextChanged(object sender, EventArgs e)
    {
        TextBox tbprd = (TextBox)(sender);
        string[] arr = tbprd.Text.Split('|');
        DataTable detail = Class1.GetPrdDetails(arr[0]);
        if (detail.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertScript", "<script>alert(\"" + "产品不存在!" + "\")</script>", false);
            return;
        }

        Label lbunit = (Label)tbprd.FindControl("lbunit");
        lbunit.Text = detail.Rows[0]["unitname"].ToString();

        Label lbcapacity = (Label)tbprd.FindControl("lbcapacity");
        lbcapacity.Text = detail.Rows[0]["StandCapacity"].ToString();
    }



    protected void gvselect_work_TextChanged(object sender, EventArgs e)
    {
        DropDownList gvselect_work = (DropDownList)(sender);
        DropDownList gvselect_line = (DropDownList)gvselect_work.FindControl("gvselect_line");
        gvselect_line.Items.Clear();
        DataTable dt_line = ConsoleApplication1.Class1.GetWorkLinesList(gvselect_work.SelectedValue);
        for (int i = 0; i < dt_line.Rows.Count; i++)
        {
            gvselect_line.Items.Add(new ListItem(dt_line.Rows[i]["strline"].ToString(), dt_line.Rows[i]["FMASTERID"].ToString()));
        }

    }


    [WebMethod]
    public static string GetXiLieName(string no)
    {
        string strSql = @"select FNumber+'|'+FName as xiliename from t_xiliefenlei fl join t_item it on fl.Series=it.FItemID";
        DataTable dtResult = Program.GetDataTableBySqlText(strSql);
        string Jsonstring = string.Empty;
        Jsonstring = JsonConvert.SerializeObject(dtResult);
        return Jsonstring;
    }

    [WebMethod]
    public static string GetMaterialByCPXL(string cpxl)
    {
        string[] arr = cpxl.Split('|');
        if (arr[0].Length== 0)
        {
            return "{}";
        }
        if (arr[0].ToString() == "")
        {
            return "{}";
        }
        string strSql = @"select icic.FNumber+'|'+icic.FName as matname from (select *from t_item where FDeleted=0) it 
join t_xiliefenlei fl on it.FItemID=fl.Series
join t_xiliefenleiEntry fle on fl.FID=fle.FID 
join (select *from t_ICItem where FDeleted=0) ic on fle.Material=ic.FItemID 
join (select *from ICBOM where FCancellation=0 and FForbid=0) bom on bom.FItemID=ic.FItemID
join ICBOMChild bomc on bom.FInterID= bomc.FInterID
join (select *from t_ICItem where FDeleted=0) icic on bomc.FItemID=icic.FItemID 
where it.FName='" + arr[1] + "'";
        DataTable dtResult = Program.GetDataTableBySqlText(strSql);
        string Jsonstring = string.Empty;
        if (dtResult != null && dtResult.Rows.Count > 0)
        {
            Jsonstring = JsonConvert.SerializeObject(dtResult);
        }
        else
        {
            Jsonstring = JsonConvert.SerializeObject("");
        }
        return Jsonstring;
    }

    [WebMethod]
    public static string GetSupplierByMaterial(string Material)
    {
        string[] arr = Material.Split('|');
        if (arr[0].Length == 0)
        {
            return "{}";
        }
        if (arr[0].ToString() == "")
        {
            return "{}";
        }
        string strSql = @"select per.FNumber+'|'+per.FName as supname from t_supply su join t_ICItem ic on su.FItemID=ic.FItemID
join t_Supplier per on FSupID=per.FItemID where ic.FNumber='" + arr[0] + "'";
        DataTable dtResult = Program.GetDataTableBySqlText(strSql);
        string Jsonstring = string.Empty;
        if (dtResult != null && dtResult.Rows.Count > 0)
        {
            Jsonstring = JsonConvert.SerializeObject(dtResult);
        }
        else
        {
            Jsonstring = JsonConvert.SerializeObject("");
        }
        return Jsonstring;
    }

    protected void tbxl_TextChanged(object sender, EventArgs e)
    {

    }

    protected void matname_TextChanged(object sender, EventArgs e)
    {
        TextBox matname = (TextBox)(sender);
       Label FModel=(Label) matname.FindControl("FModel");
    }
}