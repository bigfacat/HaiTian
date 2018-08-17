using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using ConsoleApplication1;
using SQL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// HaiTian 的摘要说明
/// </summary>

namespace HaiTian
{
    public class Public
    {
        public static bool HasValue(string value)
        {
            if (value != "" && value != null && value != "undefined" && value != "null")
            {
                return true;
            }
            return false;
        }

        public static JObject ReturnJObject(int status, string msg)
        {
            JObject JSONResult = new JObject();
            JSONResult["status"] = status;
            JSONResult["msg"] = msg;

            return JSONResult;
        }

        public static string GetJQGridJSONFromDT(DataTable dtResult)
        {
            if (dtResult == null)
            {
                return "";
            }

            if (dtResult.Rows.Count == 0)
            {
                return "";
            }

            string jsondata = "{\"rows\":";
            JArray JArr = new JArray();

            for (int i = 0; i < dtResult.Rows.Count; i++)
            {
                JObject jo = new JObject();
                JArray ja = new JArray();
                for (int j = 0; j < dtResult.Columns.Count; j++)
                {
                    ja.Add(dtResult.Rows[i][j]);
                }

                //jo.Add("id",int.Parse( dtResult.Rows[i][0].ToString()));
                jo.Add("cell", ja);
                JArr.Add(jo);

            }
            jsondata += JArr.ToString();

            jsondata += "}";

            return jsondata;
        }

        public static DataTable GetOmissibleDataTable(DataTable dt, int count)
        {
            int Height = dt.Rows.Count;
            for (int j = 0; j < count; j++)
            {
                object same = dt.Rows[0][j];
                for (int i = 1; i < Height; i++)
                {
                    if (dt.Rows[i][j].Equals(same))
                    {
                        dt.Rows[i][j] = null;
                    }
                    else
                    {
                        same = dt.Rows[i][j];
                    }
                }
            }
            return dt;
        }

    }
    public class ClassHaiTian
    {
        public ClassHaiTian()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        static string Msg = "";

        public static bool ImportLeaveData(string year, string month, DataTable exceltable)
        {
            string sql = "";
            bool bol = false;

            sql = "delete from t_ImportLeaveData where year=" + year + "and month= " + month + "";

            for (int i = 0; i < exceltable.Rows.Count; i++)
            {
                string str1 = exceltable.Rows[i]["工号"].ToString().Trim();
                string str2 = exceltable.Rows[i]["请假小时"].ToString().Trim();

                sql += @" insert into t_ImportLeaveData(year,month,EmpID,LeaveHours) select " + year + "," + month + ",emp.FItemID," + str2 + " from t_Emp emp where emp.FNumber='" + str1 + "'";

                bol = SQLServer.ExecSql(sql, ref Msg);
            }

            return bol;
        }

        public static string GetJQGridJSONData(DataTable dtResult)
        {
            if (dtResult == null)
            {
                return "";
            }

            if (dtResult.Rows.Count == 0)
            {
                return "";
            }

            string jsondata = "{\"rows\":[";

            for (int i = 0; i < dtResult.Rows.Count; i++)
            {
                string colstr = "[";

                for (int j = 0; j < dtResult.Columns.Count; j++)
                {
                    var cellstr = dtResult.Rows[i][j].ToString().Replace("\"", "\\\"");

                    colstr += "\"" + cellstr + "\",";
                }
                colstr = colstr.Substring(0, colstr.Length - 1);
                colstr += "]";

                string rowstr = "{" +
        "\"id\":\"" + dtResult.Rows[i][0] + "\"," +
        "\"cell\":" + colstr;
                rowstr += "},";
                jsondata += rowstr;

            }
            jsondata = jsondata.Substring(0, jsondata.Length - 1);

            jsondata += "]}";

            return jsondata;
        }

        public static string GetJQGridJSONDataWith(int page, int rows, DataTable dtResult)
        {
            if (dtResult == null)
            {
                return "";
            }

            if (dtResult.Rows.Count == 0)
            {
                return "";
            }

            decimal total = Math.Ceiling(decimal.Parse((dtResult.Rows.Count / (double)rows).ToString()));
            int First = (page - 1) * rows;
            int Last = page * rows;

            if (Last > dtResult.Rows.Count)
            {
                Last = dtResult.Rows.Count;
            }

            string jsondata = "{\"records\":\"" + dtResult.Rows.Count + "\",\"page\":\"" + page + "\",\"total\":\"" + total + "\",\"rows\":[";

            for (int i = First; i < Last; i++)
            {
                string colstr = "[";

                for (int j = 0; j < dtResult.Columns.Count; j++)
                {
                    var cellstr = dtResult.Rows[i][j].ToString().Replace("\"", "\\\"");

                    colstr += "\"" + cellstr + "\",";
                }
                colstr = colstr.Substring(0, colstr.Length - 1);
                colstr += "]";

                string rowstr = "{" +
        "\"id\":\"" + dtResult.Rows[i][0] + "\"," +
        "\"cell\":" + colstr;
                rowstr += "},";
                jsondata += rowstr;

            }
            jsondata = jsondata.Substring(0, jsondata.Length - 1);

            jsondata += "]}";

            return jsondata;
        }

        public static string GetJQGridJSONDataWithPage(int page, int rows, DataTable dtResult)
        {
            if (dtResult == null)
            {
                return "";
            }

            if (dtResult.Rows.Count == 0)
            {
                return "";
            }

            decimal total = Math.Ceiling(decimal.Parse((dtResult.Rows.Count / (double)rows).ToString()));
            int First = (page - 1) * rows;
            int Last = page * rows;

            if (Last > dtResult.Rows.Count)
            {
                Last = dtResult.Rows.Count;
            }

            string jsondata = "{\"records\":\"" + dtResult.Rows.Count + "\",\"page\":\"" + page + "\",\"total\":\"" + total + "\",";

            DataRow dr;
            DataTable dt = dtResult.Clone();

            for (int i = First; i < Last; i++)
            {
                 dr = dtResult.Rows[i];
                dt.ImportRow(dr);
            }
            string json= Public.GetJQGridJSONFromDT(dt);
            json = json.Substring(0, json.Length - 1);
            json = json.Substring(1, json.Length - 1);
            jsondata += json;
            jsondata += "}";
            return jsondata;
        }


        /// <summary>
        /// Json 字符串 转换为 DataTable数据集合
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public static DataTable JsonToDataTable(string json)
        {
            DataTable dataTable = new DataTable();  //实例化
            DataTable result;
            try
            {
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
                javaScriptSerializer.MaxJsonLength = Int32.MaxValue; //取得最大数值
                ArrayList arrayList = javaScriptSerializer.Deserialize<ArrayList>(json);
                if (arrayList.Count > 0)
                {
                    foreach (Dictionary<string, object> dictionary in arrayList)
                    {
                        if (dictionary.Keys.Count<string>() == 0)
                        {
                            result = dataTable;
                            return result;
                        }
                        //Columns
                        if (dataTable.Columns.Count == 0)
                        {
                            foreach (string current in dictionary.Keys)
                            {
                                dataTable.Columns.Add(current, dictionary[current].GetType());
                            }
                        }
                        //Rows
                        DataRow dataRow = dataTable.NewRow();
                        foreach (string current in dictionary.Keys)
                        {
                            dataRow[current] = dictionary[current];
                        }
                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中
                    }
                }
            }
            catch
            {
            }
            result = dataTable;
            return result;
        }

        #region Excel2007
        /// <summary>
        /// 将Excel文件中的数据读出到DataTable中(xlsx)
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public static DataTable ExcelToTableForXLSX(string file)
        {
            DataTable dt = new DataTable();
            using (FileStream fs = new FileStream(file, FileMode.Open, FileAccess.Read))
            {
                XSSFWorkbook xssfworkbook = new XSSFWorkbook(fs);
                ISheet sheet = xssfworkbook.GetSheetAt(0);

                //表头
                IRow header = sheet.GetRow(sheet.FirstRowNum);
                List<int> columns = new List<int>();
                for (int i = 0; i < header.LastCellNum; i++)
                {
                    object obj = GetValueTypeForXLSX(header.GetCell(i) as XSSFCell);
                    if (obj == null || obj.ToString() == string.Empty)
                    {
                        dt.Columns.Add(new DataColumn("Columns" + i.ToString()));
                        //continue;
                    }
                    else
                        dt.Columns.Add(new DataColumn(obj.ToString()));
                    columns.Add(i);
                }
                //数据
                for (int i = sheet.FirstRowNum + 1; i <= sheet.LastRowNum; i++)
                {
                    DataRow dr = dt.NewRow();
                    bool hasValue = false;
                    foreach (int j in columns)
                    {
                        dr[j] = GetValueTypeForXLSX(sheet.GetRow(i).GetCell(j) as XSSFCell);
                        if (dr[j] != null && dr[j].ToString() != string.Empty)
                        {
                            hasValue = true;
                        }
                    }
                    if (hasValue)
                    {
                        dt.Rows.Add(dr);
                    }
                }
            }
            return dt;
        }

        /// <summary>
        /// 将DataTable数据导出到Excel文件中(xlsx)
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="file"></param>
        public static void TableToExcelForXLSX(DataTable dt, string file)
        {
            XSSFWorkbook xssfworkbook = new XSSFWorkbook();
            ISheet sheet = xssfworkbook.CreateSheet("Test");

            //表头
            IRow row = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = row.CreateCell(i);
                cell.SetCellValue(dt.Columns[i].ColumnName);
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
            xssfworkbook.Write(stream);
            var buf = stream.ToArray();

            //保存为Excel文件
            using (FileStream fs = new FileStream(file, FileMode.Create, FileAccess.Write))
            {
                fs.Write(buf, 0, buf.Length);
                fs.Flush();
            }
        }

        /// <summary>
        /// 获取单元格类型(xlsx)
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private static object GetValueTypeForXLSX(XSSFCell cell)
        {
            if (cell == null)
                return null;
            switch (cell.CellType)
            {
                case CellType.Blank: //BLANK:
                    return null;
                case CellType.Boolean: //BOOLEAN:
                    return cell.BooleanCellValue;
                case CellType.Numeric: //NUMERIC:
                    return cell.NumericCellValue;
                case CellType.String: //STRING:
                    return cell.StringCellValue;
                case CellType.Error: //ERROR:
                    return cell.ErrorCellValue;
                case CellType.Formula: //FORMULA:
                default:
                    return "=" + cell.CellFormula;
            }
        }
        #endregion

    }

    public class CPXL
    {
        public CPXL()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        static string Msg = "";
        static bool bol = false;


        public static DataTable LoadCPXLData(string cpxl, string sup)
        {
            string sql = @"select cp.id,it.FNumber as xilieID,it.FName as xiliename,ic.FNumber as matno,ic.FName as matname,ic.FModel,per.FNumber as supno,per.FName as supname,cp.status,case cp.status when 1 then '审核' else '保存' end from t_chanpinxilie cp left join t_item it on cp.xilieID=it.FItemID
left join t_icitem ic on cp.childmatID=ic.FItemID left join t_Supplier per on cp.supID=per.FItemID where 1=1";
            if (cpxl != "")
            {
                sql += " and (it.FNumber like '%" + cpxl + "%' or it.FName like '%" + cpxl + "%')";
            }
            if (sup != "")
            {
                sql += " and (per.FNumber like '%" + sup + "%' or per.FName like '%" + sup + "%')";
            }

            sql += " order by it.FNumber,ic.FNumber,per.FNumber";

            return Program.GetDataTableBySqlText(sql);

        }

        public static bool SaveCPXLData(bool repeat, string xilie, string mat, string sup)
        {
            string sql = "";
            if (repeat == true)
            {
                sql = @"update t_chanpinxilie set supID=a.supid from t_chanpinxilie cp join(select it.FItemID as itid,ic.FItemID as icid,per.FItemID as supid from t_item it , t_icitem ic,t_Supplier per where it.FName= '" + xilie + "' and ic.FNumber='" + mat + "' and per.FNumber='" + sup + "')a on cp.xilieID=itid and cp.childmatID=a.icid where xilieID=itid and childmatID=icid";
            }
            else
            {
                sql = @"insert into t_chanpinxilie(xilieID,childmatID,supID) select it.FItemID,ic.FItemID,per.FItemID from t_item it , t_icitem ic,t_Supplier per where it.FName= '" + xilie + "' and ic.FNumber='" + mat + "' and per.FNumber='" + sup + "'";
            }

            return SQLServer.ExecSql(sql, ref Msg);
        }

        public static bool SaveCPXLDataSup(JArray ja)
        {
            string sql = "";

            sql = "delete from t_chanpinxilie where xilieID=(select FItemID from t_Item where FName='" + ja[0]["cpxl"] + "')";
            bol = SQLServer.ExecSql(sql, ref Msg);

            if (bol == false)
            {
                return bol;
            }

            for (int i = 0; i < ja.Count; i++)
            {
                sql = @"insert into t_chanpinxilie(xilieID,childmatID,supID) select it.FItemID,ic.FItemID,per.FItemID from (select FItemID from t_item where FName= '" + ja[i]["cpxl"] + "' ) it join (select FItemID from t_icitem where FNumber='" + ja[i]["mat"] + "') ic on 1=1 left join (select FItemID from t_Supplier where FNumber='" + ja[i]["sup"] + "') per on 1=1";
                bol = SQLServer.ExecSql(sql, ref Msg);

                if (bol == false)
                {
                    return bol;
                }
            }

            return true;
        }

        public static bool SaveCPXLDataQuickly(JArray ja)
        {
            DataTable dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[]{
      new DataColumn("col1",typeof(string )),
      new DataColumn("col2",typeof(string)),
      new DataColumn("col3",typeof(string))});

            for (int i = 0; i < ja.Count; i++)
            {
                DataRow r = dt.NewRow();
                r[0] = ja[i]["cpxl"];
                r[1] = ja[i]["mat"];
                r[2] = ja[i]["sup"];
                dt.Rows.Add(r);
            }

            bol = SQLServer.TableValuedToDB(dt, ref Msg);
            return bol;
        }

        public static bool RepeatingData(string xilie, string mat, string sup)
        {
            string sql = @"select 1 from t_chanpinxilie cp join (select it.FItemID as itid,ic.FItemID as icid from t_item it , t_icitem ic where it.FName= '" + xilie + "' and ic.FNumber='" + mat + "')a on cp.xilieID=itid and cp.childmatID=a.icid";
            DataTable dt = Program.GetDataTableBySqlText(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static bool DeleteCPXLData(List<int> id)
        {
            string sql = "delete from t_chanpinxilie where id in(" + id[0];
            for (int i = 1; i < id.Count; i++)
            {
                sql = sql + " ," + id[i] + "";
            }
            sql = sql + ")";

            return Program.ExecDataBySqlText(sql);
        }

        public static bool UpdateCPXLData(string id, string xilie, string mat, string sup)
        {
            string sql = @"update  t_chanpinxilie set xilieID=a.itid,matID=a.icid,supID=a.supid from (select it.FItemID as itid,ic.FItemID as icid,per.FItemID as supid from t_item it , t_icitem ic,t_Supplier per where it.FName= '" + xilie + "' and ic.FNumber='" + mat + "' and per.FNumber='" + sup + "')a where id=" + id + "";
            return Program.ExecDataBySqlText(sql);

        }

        public static DataTable GetSupData(string sup)
        {
            string sql = @"select FItemID,FNumber,FName from t_Supplier per where 1=1 and FDeleted=0 and FStatus=1072 and (per.FNumber like '%" + sup + "%' or per.FName like '%" + sup + "%')";
            return SQLServer.GetDataTable(sql, ref Msg);
        }

        public static DataTable GetAutoCompleteSup(string sup)
        {
            string sql = @"select FNumber+'|'+FName from t_Supplier per where 1=1 and FDeleted=0 and FStatus=1072 and per.FNumber like '%" + sup + "%'";
            return SQLServer.GetDataTable(sql, ref Msg);
        }

        public static DataTable GetSupName(string sup)
        {
            string sql = @"select FItemID,FNumber,FName from t_Supplier per where 1=1 and FDeleted=0 and FStatus=1072 and per.FNumber ='" + sup + "'";
            return SQLServer.GetDataTable(sql, ref Msg);
        }

        public static DataTable GetCPXL(string cpxl)
        {
            string sql = @"select FItemID,FNumber,FName from t_Item where 1=1 and FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类') and (FNumber like '%" + cpxl + "%' or FName like '%" + cpxl + "%')";
            return SQLServer.GetDataTable(sql, ref Msg);
        }

        public static DataTable ExpandMaterialByCPXL(string cpxl)
        {
            string sql = @";with temp as(select bomc.FItemID,it.FNumber as flnumber,it.FName as flname,ic.FNumber as mat,ic.FName as matname,ic.FModel,null as sup,null as supname from t_Item it join t_xiliefenlei fl on it.FItemID=fl.Series
join t_xiliefenleiEntry fle on fl.FID=fle.FID left join ICBOM bom on fle.Material=bom.FItemID 
join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem ic on bomc.FItemID=ic.FItemID
where 1=1 and FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类') and bom.FUseStatus=1072 and bom.FForbid=0 and ic.FErpClsID<>2 and it.FName='" + cpxl + "')select distinct *from temp";
            return SQLServer.GetDataTable(sql, ref Msg);
        }

        public static bool CPXLReview(string[] id,ref string msg)
        {
            string sql = "update t_chanpinxilie set status=1 where id in(";
            sql += id[0];
            for (int i = 1; i < id.Length; i++)
            {
                sql += "," + id[i];
            }
            sql += ")";
            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }
        public static bool CPXLCancelReview(string[] id, ref string msg)
        {
            string sql = "update t_chanpinxilie set status=0 where id in(";
            sql += id[0];
            for (int i = 1; i < id.Length; i++)
            {
                sql += "," + id[i];
            }
            sql += ")";
            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        /// <summary>
        /// 批量删除产品系列供应商关系
        /// </summary>
        /// <param name="id"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static bool BatchDeleteCPXLSup(string[] id, ref string msg)
        {
            string sql = "delete from t_chanpinxilie where id in(";
            sql += id[0];
            for (int i = 1; i < id.Length; i++)
            {
                sql += "," + id[i];
            }
            sql += ")";
            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        /// <summary>
        /// 批量更换产品系列供应商
        /// </summary>
        /// <param name="CPXLids"></param>
        /// <param name="oldSup"></param>
        /// <param name="newSup"></param>
        /// <param name="msg"></param>
        /// <param name="count"></param>
        /// <returns></returns>
        public static bool CPXLChangeSup(string CPXLids, string oldSup, string newSup, ref string msg, ref int count)
        {
            Msg = "";
            string sql = @"declare @supid int select @supid=FItemID from t_Supplier where FNumber='" + newSup + @"'
update cpxl set supID = @supid from t_chanpinxilie cpxl left join t_Supplier per on cpxl.supID = per.FItemID where FNumber = '" + oldSup + "'";

            if (CPXLids != "")
            {
                sql += " and xilieID in(" + CPXLids + ")";
            }

            sql += " select @@ROWCOUNT";
            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);

            if (Msg == "")
            {
                bol = true;
            }
            else
            {
                bol = false;
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                count = int.Parse(dt.Rows[0][0].ToString());
            }
            msg = Msg;
            return bol;
        }

        public static bool CPXLEditSup(string id,  string sup,ref string msg)
        {
            string sql = "update t_chanpinxilie set supID=per.FItemID from(select*from t_Supplier where FNumber ='" + sup + "')per where id=" + id + "";
            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }
        public static DataTable CPXLRestoreSup(string id,ref string msg)
        {
            string sql = "select FNumber,FName from t_chanpinxilie cpxl left join t_Supplier per on cpxl.supID=per.FItemID where id=" + id + "";
            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            msg = Msg;
            return dt;
        }

        public static bool importCPXL(string filepath, ref string msg)
        {
            DataTable exceltable = null;
            try
            {
                exceltable = Class1.ExcelToTableForXLSX(filepath);
            }
            catch
            {
                msg = "Excel数据格式不正确，请修改后重新导入！";
                return false;
            }
            int total = exceltable.Rows.Count;
            int suc = 0;
            for (int i = 0; i < exceltable.Rows.Count; i++)
            {
                bool bol;

                string str1 = "";
                string str2 = "";
                string str3 = "";
                try
                {
                    str1 = exceltable.Rows[i]["产品系列"].ToString().Trim();
                    str2 = exceltable.Rows[i]["物料"].ToString().Trim();
                    str3 = exceltable.Rows[i]["供应商"].ToString().Trim();
                }
                catch
                {
                    msg = "导入文件列名必须和模板一致，请修改后重新导入！";
                    return false;
                }
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
                msg = "共" + total + "条" + ",成功" + suc + "条";
                return true;
            }
            else
            {
                msg = "";
                return false;
            }

        }

        #region 维护产品系列和成品料号对应关系

        /// <summary>
        /// 主页面查询
        /// </summary>
        /// <param name="name"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static DataTable GetCPXLProduction(string name, ref string msg)
        {
            string sql = @"select FEntryID,it.FNumber,it.FName,ic.FNumber,ic.FName,ic.FModel from t_xiliefenlei fl join t_xiliefenleiEntry fle on fl.FID=fle.FID
left join t_Item it on fl.Series = it.FItemID
left join t_ICItem ic on fle.Material = ic.FItemID and ic.FDeleted = 0
where 1=1";

            if (name.ToString() != "")
            {
                sql += " and it.FName like '%" + name + "%'";
            }

            sql += " order by Series";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            msg = Msg;
            return dt;
        }

        /// <summary>
        /// 单个产品系列查询成品料号明细
        /// </summary>
        /// <param name="cpxl"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static DataTable GetCPXLProductionDetail(string cpxl, ref string msg)
        {
            string sql = @"select ic.FItemID,it.FNumber,it.FName,ic.FNumber,ic.FName,ic.FModel from t_xiliefenlei fl join t_xiliefenleiEntry fle on fl.FID=fle.FID
left join t_Item it on fl.Series = it.FItemID
left join t_ICItem ic on fle.Material = ic.FItemID and ic.FDeleted = 0
where 1=1";

            if (cpxl.ToString() != "")
            {
                sql += " and (it.FName like '%" + cpxl + "%' or it.FNumber like '%" + cpxl + "%')";
            }

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            msg = Msg;
            return dt;
        }

        /// <summary>
        /// 查询成品料号供选择
        /// </summary>
        /// <param name="prd"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static DataTable GetProduction(string prd, ref string msg)
        {
            string sql = @"select FItemID,FNumber,FName,FModel from t_ICItem where FDeleted=0 and FNumber like '8%'";

            if (prd.ToString() != "")
            {
                sql += " and(FNumber like '%" + prd + "%' or FName like '%" + prd + "%')";
            }

            //sql += " order by FNumber";//加上排序查询速度变慢

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            msg = Msg;
            return dt;
        }

        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="cpxl"></param>
        /// <param name="prd"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static bool CPXLProductionSave(string cpxl, string[] prd, ref string msg)
        {
            string sql = @"declare @delid int,@maxid int,@cpxl nvarchar(50)
select @cpxl=FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类') and FName='" + cpxl + @"'
select @delid=FID from t_xiliefenlei fl join t_Item it on fl.Series=it.FItemID where it.FItemID=@cpxl
delete from t_xiliefenlei where FID=@delid
delete from t_xiliefenleiEntry where FID=@delid
select @maxid=max(FID) from t_xiliefenlei
if @maxid is null set @maxid=0
insert into t_xiliefenlei(FID,Series) select @maxid+1,it.FItemID from t_Item it where it.FItemID=@cpxl
insert into t_xiliefenleiEntry(FID,FIndex,Material) select @maxid+1,ROW_NUMBER() OVER(ORDER BY FNumber),ic.FItemID from t_ICItem ic where ic.FItemID in(";

            sql += prd[0];

            for (int i = 1; i < prd.Length; i++)
            {
                sql += "," + prd[i];
            }
            sql += ")";
            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="cpxl"></param>
        /// <param name="msg"></param>
        /// <returns></returns>
        public static bool CPXLProductionDelete(string cpxl, ref string msg)
        {
            string sql = @"declare @delid int,@cpxl nvarchar(50)
select @cpxl=FItemID from t_Item where FItemClassID=(select FItemClassID from t_ItemClass where FName='产品系列分类') and FName='" + cpxl + @"'
select @delid=FID from t_xiliefenlei fl join t_Item it on fl.Series=it.FItemID where it.FItemID=@cpxl
delete from t_xiliefenlei where FID=@delid
delete from t_xiliefenleiEntry where FID=@delid";

            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        #endregion
    }

    public class User
    {

        static string Msg = "";
        static bool bol = false;
        static string sql = "";
        public static DataTable LoadRoleData(string role)
        {

            sql = "select r.id,RoleName,u.username,r.CreateDate,Remark from t_PlugUserRole r left join t_MyUserAccount u on r.Creator=u.id where 1=1";
            if (Public.HasValue(role))
            {
                sql += " and RoleName like '%" + role + "%'";

            }

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

        public static DataTable LoadPlugResource()
        {

            sql = @"select id,1 as ResourceTypeID,'页面' as ResourceType,EName,CName,null from t_PlugWebPage union
select id,2 as ResourceTypeID,'按钮' as ResourceType,code,name,WebPage from t_PlugResource";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

        public static bool AddPlugRole(string rolename, string remark, string creator, JArray rows, ref string msg)
        {
            sql = @"select 1 from t_PlugUserRole where RoleName='" + rolename + "'";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);

            if (dt != null && dt.Rows.Count > 0)
            {
                msg = "用户名已存在";
                return false;
            }

            sql = "begin tran begin try  declare @id int insert into t_PlugUserRole select '" + rolename + "',GETDATE(),u.id,'" + remark + "' from t_MyUserAccount u where u.username='" + creator + "' select @id=max(id) from t_PlugUserRole";

            for (int i = 0; i < rows.Count; i++)
            {
                sql += " insert into t_PlugUserPermission select @id," + rows[i]["id"] + "," + rows[i]["ResourceTypeID"];

            }
            sql += " end try begin catch rollback tran select 1 / 0 return end catch commit tran";

            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        public static bool EditPlugRole(string rolename, string remark, JArray rows, ref string msg)
        {

            sql = "begin tran begin try declare @id int select @id=id from t_PlugUserRole where RoleName='" + rolename + "' update t_PlugUserRole set Remark='" + remark + "' where id=@id delete from t_PlugUserPermission where RoleID=@id";

            for (int i = 0; i < rows.Count; i++)
            {
                sql += " insert into t_PlugUserPermission select @id," + rows[i]["id"] + "," + rows[i]["ResourceTypeID"];

            }
            sql += " end try begin catch rollback tran select 1 / 0 return end catch commit tran";

            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        public static bool DeletePlugRole(string rolename, ref string msg)
        {
            sql = @"select 1 from t_PlugUserRole ur join t_MyUserAccount ua on ur.id=ua.BelongToRole where RoleName='" + rolename + "'";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);

            if (dt != null && dt.Rows.Count > 0)
            {
                msg = "角色已被用户使用！";
                return false;
            }

            sql = "begin tran begin try delete from t_PlugUserRole where RoleName='" + rolename + "'";

            sql += " end try begin catch rollback tran select 1 / 0 return end catch commit tran";

            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        public static bool ChangePlugRole(string username, string rolename, ref string msg)
        {

            sql = "begin tran begin try update t_MyUserAccount set BelongToRole=ur.id from (select *from t_PlugUserRole where RoleName='" + rolename + "')ur where username='" + username + "'";

            sql += " end try begin catch rollback tran select 1 / 0 return end catch commit tran";

            bol = SQLServer.ExecSql(sql, ref Msg);
            msg = Msg;
            return bol;
        }

        public static bool EditPlugRolePermission(string rolename, JArray rows)
        {

            sql = "begin tran begin try declare @id int select @id=id from t_PlugUserRole where RoleName='" + rolename + "' delete from t_PlugUserPermission where RoleID=@id";

            for (int i = 0; i < rows.Count; i++)
            {
                sql += " insert into t_PlugUserPermission select @id," + rows[i]["id"] + "," + rows[i]["ResourceTypeID"];

            }
            sql += " end try begin catch rollback tran select 1 / 0 return end catch commit tran";

            bol = SQLServer.ExecSql(sql, ref Msg);
            return bol;
        }

        public static DataTable LoadRolePermission(string role)
        {
            sql = @"select up.id,ur.RoleName,EName,CName,WebPage from t_PlugUserRole ur
join t_PlugUserPermission up on up.RoleID = ur.id
join (select id,1 as ResourceTypeID,'页面' as ResourceType,EName,CName,null as WebPage from t_PlugWebPage union
select id,2 as ResourceTypeID,'按钮' as ResourceType,code,name,WebPage from t_PlugResource) res on res.id = up.ResourceID and res.ResourceTypeID=up.ResourceType
where 1 = 1";

            if (Public.HasValue(role))
            {
                sql += " and RoleName like '%" + role + "%'";
            }

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

        //角色已有权限
        public static DataTable LoadRoleHavePermission(string role)
        {
            sql = @"select *from (select id,1 as ResourceTypeID,'页面' as ResourceType,EName,CName,null as WebPage from t_PlugWebPage union
select id,2 as ResourceTypeID,'按钮' as ResourceType,code,name,WebPage from t_PlugResource) res where exists (select * from t_PlugUserRole ur
join t_PlugUserPermission up on up.RoleID=ur.id
where RoleName = '" + role + "' and res.id=up.ResourceID and res.ResourceTypeID=up.ResourceType)";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

        //角色未有权限
        public static DataTable LoadRoleNotHavePermission(string role)
        {
            sql = @"select *from (select id,1 as ResourceTypeID,'页面' as ResourceType,EName,CName,null as WebPage from t_PlugWebPage union
select id,2 as ResourceTypeID,'按钮' as ResourceType,code,name,WebPage from t_PlugResource) res where not exists (select * from t_PlugUserRole ur
join t_PlugUserPermission up on up.RoleID=ur.id
where RoleName = '" + role + "' and res.id=up.ResourceID and res.ResourceTypeID=up.ResourceType)";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

        public static bool LoadUserWebPagePermission(string user, string page)
        {
            sql = @"select 1 from t_MyUserAccount ua
join t_PlugUserRole ur on ua.BelongToRole=ur.id
join t_PlugUserPermission up on ur.id=up.RoleID and up.ResourceType=1
join t_PlugWebPage wp on up.ResourceID=wp.id
where ua.username='" + user + "' and wp.EName='" + page + "'";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            if (dt != null && dt.Rows.Count > 0)
            {
                return true;
            }
            return false;
        }
        public static DataTable LoadPlugButtonResource(string user, string page)
        {
            sql = @"select code from t_MyUserAccount ua
join t_PlugUserRole ur on ua.BelongToRole=ur.id
join t_PlugUserPermission up on ur.id=up.RoleID and up.ResourceType=2
join t_PlugResource res on up.ResourceID=res.id
where ua.username='" + user + "' and res.WebPage='" + page + "'";

            DataTable dt = SQLServer.GetDataTable(sql, ref Msg);
            return dt;
        }

    }

}