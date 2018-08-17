using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using DataAccess;
using System.Web.UI.WebControls;
using System.IO;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Collections;

/// <summary>
/// common 的摘要说明
/// </summary>
public class common
{
   public static string  costreporttype = "标准成本";
    public static string  costreportMode_caiwu = "财务";
    public  static string  costreportMode_nocaiwu = "非财务";
    public common()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    public static bool CheckModelByUserID(int userid, string type, string mode, ref string errorMessage)
    {
        string strsql = "select * from ModelRoleManage m inner join UserRoleManage u on m.id = u.id " +
                                "where m.moderoleName = '" + mode + "' and m.modetype = '" + type + "' and u.fuserid = " + userid + " ";

        DataAccess.DALTranscation dal = new DataAccess.DALTranscation();
        DataTable dt = dal.GetDataTableBySQLText(strsql);
        if (dt != null && dt.Rows.Count > 0)
        {
            return true;
        }
        else
        {
            errorMessage = "当前用户没有权限操作,请联系管理员.";
            return false;
        } 
    }

    public static DataTable GetUserData( string modename, string username)
    {
        StringBuilder strSql = new StringBuilder();
        strSql.Append("select t.FNAME ,m.modeRoleName, m.ModeType from ModelRoleManage m inner join UserRoleManage u on m.id = u.id ");
        strSql.Append(" inner join T_SEC_USER t on t.FUSERID = u.fuserid  where 1=1 " );
        if (modename != "")
        {
            strSql.Append(" and m.modetype='"+modename +"'");
        }
        if (username != "")
        {
            strSql.Append(" and t.FNAME like '%" + username + "%'");
        }
        strSql.Append(" order by t.fname");
        DataAccess.DALTranscation dal = new DataAccess.DALTranscation();
        DataTable dt = dal.GetDataTableBySQLText(strSql.ToString());
        return dt;
    }

    public static DataTable GetModeType()
    {
        string sql = "select '请选择' as ModeType, '' as value , 'A' as seq  union  select distinct ModeType,  ModeType as value, 'b' as seq from ModelRoleManage order by seq";
        DataAccess.DALTranscation dal = new DataAccess.DALTranscation();
        DataTable dt = dal.GetDataTableBySQLText(sql);
        return dt;
    }

    public static DataTable GetModeRoleName()
    {
        string sql = "select ModeRoleName  from ModelRoleManage";
        DataAccess.DALTranscation dal = new DataAccess.DALTranscation();
        DataTable dt = dal.GetDataTableBySQLText(sql);
        return dt;
    }

    public static DataTable GetUserlist()
    {
        string sql = "select FNAME  from T_SEC_USER ";
        DataAccess.DALTranscation dal = new DataAccess.DALTranscation();
        DataTable dt = dal.GetDataTableBySQLText(sql);
        return dt;
    }

    public static bool  SaveModeRole(string username, string moderolename)
    {
        DC_Error error = new DC_Error();
        int iAffected = 0;
        Dictionary<string, object> dic = new Dictionary<string, object>();
        dic.Add("@username", username);
        dic.Add("@moleRoleName", moderolename);
        DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
        bool result = myDALTranscation.ExecuteTransactionSP("usp_SaveModeRoleManage", dic, ref error, ref iAffected);
        return result;
    }


    public static void ExportToExcel(System.Web.UI.Page page, string fileName, GridView gdv, DataTable dt, bool isdt)
    {
        //W1303002 改压缩文档
        String filePath = System.Web.HttpContext.Current.Server.MapPath("~/DownloadFiles");
        string filename = fileName;

        string filenames = filePath + "\\" + filename + ".xls";
        #region 为excel赋值
        if (isdt)
            if(gdv !=null)
             common.TableToExcel (dt, gdv, filenames);
            else
              common.TableToExcel(dt, filenames);
        else 
        common.RenderDataTableToExcel(gdv , filenames);
        string fname = string.Empty;
        fname = filePath  + "\\" + filename + ".xls";
        
        ResponseFile(fname, filename);
        #endregion
    }

    public static FileStream RenderDataTableToExcel(GridView gv, string filename)
    {
        HSSFWorkbook workbook = new HSSFWorkbook();
        FileStream ms = new FileStream(filename, FileMode.Create);
        HSSFSheet sheet = (HSSFSheet)workbook.CreateSheet();
        HSSFRow headerRow = (HSSFRow)sheet.CreateRow(0);

        // handling header.
        for (int i = 0; i < gv.Columns.Count; i++)
        {
            headerRow.CreateCell(i).SetCellValue(gv.Columns[i].HeaderText.ToString());
        }

        for (int i = 0; i < gv.Rows.Count; i++)
        {
            HSSFRow dataRow = (HSSFRow)sheet.CreateRow(i + 1);
            for (int j = 0; j < gv.Columns.Count; j++)
            {
                string value = gv.Rows[i].Cells[j].Text.ToString();
                string values = gv.Rows[0].Cells[0].Text;
                dataRow.CreateCell(j).SetCellValue(value.Replace("&nbsp;", ""));
            }
        }

        workbook.Write(ms);
        ms.Close();

        sheet = null;
        headerRow = null;
        workbook = null;

        return ms;
    }

    public static string YaSuo(string PathSave, string FilePath, string WinRAR)
    {

        string rarurlPath = string.Empty;
        Boolean bo = false;
        System.Diagnostics.Process pro = new System.Diagnostics.Process();
        pro.StartInfo.FileName = WinRAR;//WinRAR所在路径
        //pro.StartInfo.Arguments = "a " + yasuoPathSave + " " + yasuoPath + " -r ";//dir是你的目录名 
        pro.StartInfo.Arguments = string.Format("a {0} {1} -r", PathSave, FilePath);

        pro.Start();
        TimeSpan times = pro.TotalProcessorTime;
        bo = pro.WaitForExit(60000);//设定一分钟
        if (!bo)
            pro.Kill();
        pro.Close();
        pro.Dispose();
        rarurlPath = PathSave;
        return rarurlPath;
    }


    protected static void ResponseFile(string filename,string files)
    {
        files = files + "-" + DateTime.Now.ToString("yyyyMMddhhmmss")+".xls";
        System.IO.FileInfo file = new System.IO.FileInfo(filename);//创建一个文件对象
        System.Web.HttpContext.Current.Response.Clear();//清除所有缓存区的内容
        System.Web.HttpContext.Current.Response.Charset = "GB2312";//定义输出字符集
        System.Web.HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;//输出内容的编码为默认编码
        System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + files);
        //添加头信息。为“文件下载/另存为”指定默认文件名称
        System.Web.HttpContext.Current.Response.AddHeader("Content-Length", file.Length.ToString());
        //添加头文件，指定文件的大小，让浏览器显示文件下载的速度 
        System.Web.HttpContext.Current.Response.WriteFile(file.FullName);// 把文件流发送到客户端
        System.Web.HttpContext.Current.Response.End();
    }

    public static void TableToExcel(DataTable dt, GridView gv, string file)
    {
        IWorkbook workbook;
        string fileExt = Path.GetExtension(file).ToLower();
   
        workbook = new HSSFWorkbook();
      
        if (workbook == null) { return; }
        ISheet sheet = string.IsNullOrEmpty(dt.TableName) ? workbook.CreateSheet("Sheet1") : workbook.CreateSheet(dt.TableName);

        //表头  
        try
        {
            IRow row = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = row.CreateCell(i);
                cell.SetCellValue(gv.Columns[i].HeaderText.ToString());
            }
            //数据  
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row1 = sheet.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    ICell cell = row1.CreateCell(j);
                    cell.SetCellValue(dt.Rows[i][j].ToString());
                }
            }
        }
        catch(Exception ex)
        {

        }

        //转为字节数组  
        MemoryStream stream = new MemoryStream();
        workbook.Write(stream);
        var buf = stream.ToArray();

        //保存为Excel文件  
        using (FileStream fs = new FileStream(file, FileMode.Create, FileAccess.Write))
        {
            fs.Write(buf, 0, buf.Length);
            fs.Flush();
        }
    }

    public static  void TableToExcel(DataTable dt, string file)
    {
        IWorkbook workbook;
        string fileExt = Path.GetExtension(file).ToLower();
        workbook = new HSSFWorkbook();

        if (workbook == null) { return; }
        ISheet sheet = string.IsNullOrEmpty(dt.TableName) ? workbook.CreateSheet("Sheet1") : workbook.CreateSheet(dt.TableName);

        //表头  
        IRow row = sheet.CreateRow(0);
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            ICell cell = row.CreateCell(i);
            cell.SetCellValue(dt.Columns[i].ColumnName.ToString());
        }
        //数据  
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            IRow row1 = sheet.CreateRow(i + 1);
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                ICell cell = row1.CreateCell(j);
                cell.SetCellValue(dt.Rows[i][j].ToString());
            }
        }

        //转为字节数组  
        MemoryStream stream = new MemoryStream();
        workbook.Write(stream);
        var buf = stream.ToArray();

        //保存为Excel文件  
        using (FileStream fs = new FileStream(file, FileMode.Create, FileAccess.Write))
        {
            fs.Write(buf, 0, buf.Length);
            fs.Flush();
        }
    }


    /// 班车数据导出成EXCEL
    /// </summary>
    /// <param name="conferenceID"></param>
    /// <returns></returns>
    //[HttpGet]
    //public HttpResponseMessage ExportExcelDataForBusRoute(string conferenceID)
    //{
    //    HttpResponseMessage result = new HttpResponseMessage();
    //    ControllerHelp.RunAction(() =>
    //    {
    //        BusRouteModelCollection busColl = BusRouteModelAdapter.Instance.Load(m => m.AppendItem("ConferenceID", conferenceID));
    //        //如果想要某个单元格内容显示多列，在内容中加入： "\n"  换行字符
    //        Dictionary<string, string> dicColl = new Dictionary<string, string>() {
    //                {"路线标题","Title" },
    //                {"发车时间","DepartDate" },
    //                {"出发地","BeginPlace" },
    //                {"对接人","ContactsName" },
    //                {"对接人电话","ContactsPhone" }
    //            };
    //        result = ExcelHelp<BusRouteModel, BusRouteModelCollection>.ExportExcelData(dicColl, busColl, "BusRoute");
    //    });
    //    return result;
    //}


}