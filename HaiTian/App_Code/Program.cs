using System;
using System.Collections.Generic;
using System.Text;
using Kingdee.BOS.WebApi.Client;
using System.Data;
using System.Web;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Web.Services;
using System.Web.UI;
using System.Data.SqlClient;
using DataAccess;
namespace ConsoleApplication1
{
    public class Program
    {
        static void Main(string[] args)
        {

        }

        public static string GetTaskNo(string salesNo, int fseq, ref string errorMessage)
        {
            K3CloudApiClient client = new K3CloudApiClient("http://desktop-0c5pip8/K3Cloud/");
            salesNo = "XSDD000065";
            fseq = 1;
            var ret = client.ValidateLogin("59b8b44da7fbee", "Administrator", "888888", 2052);
            var result = JObject.Parse(ret)["LoginResultType"].Value<int>();
            // 登陆成功
            if (result == 1)
            {
                try
                {
                    string jsonStr = GetJson(salesNo, fseq);
                    string APIResult = client.Save("PRD_MO", jsonStr);
                    object obj = JsonConvert.DeserializeObject(APIResult);
                    return "TaksNo001";
                }
                catch (Exception ex)
                {
                    //{"Result":{"ResponseStatus":{"ErrorCode":500,"IsSuccess":false,"Errors":[{"FieldName":"FQTY","Message":"第1行分录，数量大于入库上限！",
                    //"DIndex":0}],"SuccessEntitys":[],"SuccessMessages":[]},"Id":"","NeedReturnData":[{}]}}
                    errorMessage = ex.Message.ToString();
                    return null;
                }
            }
            return null;
        }
        public static string GetJson(string salesNo, int fseq)
        {
            string strSql = "select  o.FNUMBER as FPrdOrgId ,o2.FNUMBER as FStockInOrgId ,b.FQty, m.FNUMBER as FMaterial  ,u.FNUMBER  as  FUnitId from t_sal_order h " +
                                   " left join t_sal_orderentry b on  h.FID = b.FID " +
                                   " left join[T_BD_MATERIAL] m on m.FMATERIALID = b.FMATERIALID " +
                                   " left join T_BD_UNIT u on u.FUNITID = b.FUNITID " +
                                   " left join T_ORG_ORGANIZATIONS o on FORGID = h.FSALEORGID " +
                                   " left  join T_ORG_ORGANIZATIONS o2 on o2.FORGID = b.FSTOCKORGID " +
                                   " where FBILLNO ='" + salesNo + "' and b.fseq = '" + fseq + "'";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            string FPrdOrgId = "102";
            string FMaterial = "A01-003";
            string FUnitId = "Pcs";
            string FQty = "100";
            string FStockInOrgId = "102";
            string FReqType = "相关";
            string FCreateType = "手工录入";
            string FPlanStartDate = "2014 - 09 - 12";
            string FPlanFinishDate = "2014 - 09 - 09";
            string FDate = "2014-09-09";
            string FSrcBillEntrySeq = "1";
            string FSrcBillNo = "XSDD000065";
            //if (dtResult.Rows.Count > 0)
            //{
            //    FPrdOrgId = dtResult.Rows[0]["FPrdOrgId"].ToString();
            //    FMaterial = dtResult.Rows[0]["FMaterial"].ToString();
            //    FUnitId = dtResult.Rows[0]["FUnitId"].ToString();
            //    FQty = dtResult.Rows[0]["FQty"].ToString();
            //    FStockInOrgId = dtResult.Rows[0]["FStockInOrgId"].ToString();
            //}
            //else
            //{
            //    return null;
            //}
            StringBuilder str = new StringBuilder();
            str.Append("{");
            str.Append("\"Creator\": \"\",");
            str.Append("\"NeedUpDateFields\": [ ],");
            str.Append("\"NeedReturnFields\": [],");
            str.Append("\"IsDeleteEntry\": \"True\",");
            str.Append("\"SubSystemId\": \"\",");
            str.Append("\"IsVerifyBaseDataField\": \"false\",");
            str.Append(" \"IsEntryBatchFill\": \"True\",");
            str.Append("\"Model\": {");
            str.Append("\"FID\": \"0\",");
            str.Append("\"FBillType\": {");//单据类型->   直接入库-普通生产
            str.Append("\"FNumber\": \"SCDD03_SYS\"");
            str.Append("},");
            str.Append(" \"FDate\": \"" + FDate + "\",");//单据日期   
            str.Append("\"FPrdOrgId\": {");//生产组织  
            str.Append(" \"FNumber\": \"" + FPrdOrgId + "\"");
            str.Append("},");
            str.Append(" \"FSrcBillEntrySeq\":\"" + FSrcBillEntrySeq + "\",");// 源单分录行号
            str.Append("\" FSrcBillNo\":\"" + FSrcBillNo + "\",");// 源单编号
            str.Append(" \"FSrcBillType\":\"SAL_SaleOrder\",");// 源单类型
            str.Append("\"FWorkShopID0\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append(" },");
            str.Append("\"FWorkGroupId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append(" \"FPlannerID\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FOwnerTypeId\": \"BD_OwnerOrg\",");//货主类型
            str.Append("\"FIsRework\": \"false\",");
            str.Append("\"FBusinessType\": \"\",");
            str.Append("\"FOwnerId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FTrustteed\": \"false\",");
            str.Append("\"FDescription\": \"\",");
            str.Append("\"FIsEntrust\": \"false\",");
            str.Append("\"FEnTrustOrgId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append(" },");
            str.Append("\"FPPBOMType\": \"1\",");//用料清单展开
            str.Append("\"FTreeEntity\": [{");
            str.Append("\"FEntryId\": \"0\",");//行号
            str.Append("\"FProductType\": \"\",");//产品类型
            str.Append("\"FMaterialId\": {");//物料编码
            str.Append("\"FNumber\": \"" + FMaterial + "\"");
            str.Append(" },");
            str.Append("\"FWorkShopID\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append(" \"FUnitId\": {");//单位
            str.Append("\"FNumber\": \"" + FUnitId + "\"");
            str.Append("},");
            str.Append("\"FQty\": \"" + FQty + "\",");
            str.Append("\"FYieldQty\": \"0\",");
            str.Append("\"FPlanStartDate\": \"" + FPlanStartDate + "\",");//计划开工时间
            str.Append("\"FPlanFinishDate\": \"" + FPlanFinishDate + "\",");//计划完工时间
            str.Append("\"FRequestOrgId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FBomId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FISBACKFLUSH\": \"false\",");
            str.Append("\"FLot\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FStockInOrgId\": {"); //入库组织
            str.Append(" \"FNumber\": \"" + FStockInOrgId + "\"");
            str.Append("},");
            str.Append("\"FBaseYieldQty\": \"0\",");
            str.Append("\"FReqType\": \"" + FReqType + "\",");//需求类型
            str.Append("\"FPriority\": \"0\",");
            str.Append("\"FSTOCKREADY\": \"0\",");
            str.Append("\"FBaseStockReady\": \"0\",");
            str.Append("\"FBaseRepairQty\": \"0\",");
            str.Append("\"FRepairQty\": \"0\",");
            str.Append("\"FBaseStockInScrapSelQty\": \"0\",");
            str.Append("\"FStockInScrapSelQty\": \"0\",");
            str.Append("\"FBaseStockInScrapQty\": \"0\",");
            str.Append("\"FStockInScrapQty\": \"0\",");
            str.Append("\"FBaseRptFinishQty\": \"0\",");
            str.Append("\"FRptFinishQty\": \"0\",");
            str.Append("\"FMTONO\": \"\",");
            str.Append("\"FStockInFailSelAuxQty\": \"0\",");
            str.Append("\"FStockInUlRatio\": \"0\",");
            str.Append("\"FInStockOwnerTypeId\": \"\",");
            str.Append("\"FAuxPropId\": {");
            str.Append(" \"FAUXPROPID__FF100001\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append("},");
            str.Append(" \"FAUXPROPID__FF100004\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FAUXPROPID__FF100002\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("}");
            str.Append("},");
            str.Append("\"FBaseStockInLimitH\": \"0\",");
            str.Append("\"FInStockOwnerId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append(" },");
            str.Append(" \"FInStockType\": \"\",");
            str.Append("\"FStockInLlRatio\": \"0\",");
            str.Append("\"FCheckProduct\": \"false\",");
            str.Append("\"FOutPutOptQueue\": \"\",");
            str.Append(" \"FBaseStockInLimitL\": \"0\",");
            str.Append("\"FBaseUnitQty\": \"0\",");
            str.Append("\"FRepQuaSelAuxQty\": \"0\",");
            str.Append(" \"FRepQuaAuxQty\": \"0\",");
            str.Append("\"FRepFailSelAuxQty\": \"0\",");
            str.Append("\"FMemoItem\": \"\",");
            str.Append("\"FRoutingId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append(" },");
            str.Append("\"FRepFailAuxQty\": \"0\",");
            str.Append("\"FStockInQuaAuxQty\": \"0\",");
            str.Append(" \"FStockInQuaSelAuxQty\": \"0\",");
            str.Append(" \"FStockInFailAuxQty\": \"0\",");
            str.Append("\"FStockInQuaSelQty\": \"0\",");
            str.Append("\"FStockInQuaQty\": \"0\",");
            str.Append("\"FBaseUnitId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FStockInFailSelQty\": \"0\",");
            str.Append("\"FStockId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append(" },");
            str.Append("\"FStockInFailQty\": \"0\",");
            str.Append("\"FRepQuaSelQty\": \"0\",");
            str.Append("\"FStockLocId\": {");
            str.Append("\"FSTOCKLOCID__FF100001\": {");
            str.Append("\"FNUMBER\": \"\"");
            str.Append("} },");
            str.Append("\"FRepQuaQty\": \"0\",");
            str.Append("\"FStockInLimitH\": \"0\",");
            str.Append(" \"FRepFailSelQty\": \"0\",");
            str.Append("\"FRepFailQty\": \"0\",");
            str.Append("\"FStockInLimitL\": \"0\",");
            str.Append("\"FOperId\": \"0\",");
            str.Append("\"FProcessId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FCostRate\": \"0\",");
            str.Append("\"FCreateType\": \"" + FCreateType + "\","); //生成方式
            str.Append("\"FYieldRate\": \"0\",");
            str.Append("\"FGroup\": \"0\",");
            str.Append("\"FNoStockInQty\": \"0\",");
            str.Append("\"FParentRowId\": \"\",");
            str.Append("\"FBaseNoStockInQty\": \"0\",");
            str.Append("\"FRowExpandType\": \"0\",");
            str.Append("\"FRowId\": \"\",");
            str.Append("\"FREMWorkShopId\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FCloseType\": \"\",");
            str.Append("\"FScheduleSeq\": \"0\",");
            str.Append("\"FScheduleStartTime\": \"1900-01-01\",");
            str.Append("\"FScheduleFinishTime\": \"1900-01-01\",");
            str.Append("\"FForceCloserId\": {");
            str.Append("\"FUserID\": \"0\"");
            str.Append("},");
            str.Append("\"FSNUnitID\": {");
            str.Append("\"FNumber\": \"\"");
            str.Append("},");
            str.Append("\"FSNQty\": \"0\",");
            str.Append("\"FScheduleProcSplit\": \"0\",");
            str.Append("\"FReStkQuaQty\": \"0\",");
            str.Append("\"FBaseReStkQuaQty\": \"0\",");
            str.Append(" \"FReStkFailQty\": \"0\",");
            str.Append("\"FBaseReStkFailQty\": \"0\",");
            str.Append("\"FReStkScrapQty\": \"0\",");
            str.Append(" \"FBaseReStkScrapQty\": \"0\",");
            str.Append("\"FPickMtrlStatus\": \"\",");
            str.Append("\"FISNEWLC\": \"0\",");
            str.Append("\"FSerialSubEntity\": [");
            str.Append("{");
            str.Append("\"FDetailID\": \"0\",");
            str.Append("\"FSNQty1\": \"0\",");
            str.Append("\"FSerialNo\": \"\",");
            str.Append("\"FSerialId\": {");
            str.Append(" \"FNumber\": \"\"");
            str.Append("},");
            str.Append(" \"FSNRptSelQty\": \"0\",");
            str.Append(" \"FSNStockInSelQty\": \"0\",");
            str.Append("\"FSerialNote\": \"\",");
            str.Append("\"FBaseSNQty\": \"0\",");
            str.Append("\"FBaseSNRptSelQty\": \"0\",");
            str.Append("\"FBaseSNStockInSelQty\": \"0\"");
            str.Append(" }] } ]} }");
            return str.ToString();
        }

        public static bool ExecDataBySqlText(string strSql)
        {
            DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
            bool result = myDALTranscation.ExecuteNonQuerySQLText(strSql);
            return result;
        }
        public static DataTable GetDataTableBySqlText(string strSql)
        {
            DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
            DataTable dt = myDALTranscation.GetDataTableBySQLText(strSql);
            return dt;
        }

        [WebMethod]
        /// <summary>
        /// 获取默认版本号
        /// </summary>
        /// <returns></returns>
        public static DataTable GetDefalutVersionNo(string workshop, string line, int year, int week)
        {
            string strSql = "select 'A' as VersionNo union select VersionNo  from ProductVersion where WorkShop ='" + workshop + "' and WorkLines ='" + line + "' and WorkYear =" + year + " and WorkWeek =" + week + " order by VersionNo desc ";
            DataTable dt = GetDataTableBySqlText(strSql);
            return dt;
        }

        [WebMethod]
        /// <summary>
        /// 得到车间下拉值
        /// </summary>
        /// <returns></returns>
        public static DataTable GetWorkShopList()
        {
            string strSql = "select FDEPTID , FName from T_BD_DEPARTMENT_L";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }
        public static DataTable GetWorkShopNameByID(string id)
        {
            string strSql = "select FName from T_BD_DEPARTMENT_L where FDEPTID='" + id + "'";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }
        public static DataTable GetWorkLinesNameByID(string id)
        {
            string strSql = "select FName from T_BD_DEPARTMENT_L where FDEPTID='" + id + "'";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }
        [WebMethod]
        /// <summary>
        /// 得到线别下拉值
        /// </summary>
        /// <returns></returns>
        public static DataTable GetWorkLinesList()
        {
            string strSql = "select FDEPTID , FName from T_BD_DEPARTMENT_L";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }

        [WebMethod]
        /// <summary>
        /// 根据销售单和行号获取销售信息
        /// </summary>
        /// <param name="salesOrder"></param>
        /// <param name="enteyid"></param>
        /// <returns></returns>
        public static DataTable GetSalOrderList(string salesOrder, int fseq)
        {
            //select  c.FNAME as '客户名称'  , b.FQTY as '销售订单数量'  , m.FNUMBER as  '物料编码', ml.FNAME as '物料名称' , b.FPLANDELIVERYDATE as '出货日期'  
            string strSql = "select  c.FNAME as 'cusName'  ,  Convert( decimal(18,2),  b.FQTY )   as 'FQTY'  , m.FNUMBER , ml.FNAME as 'MaterialName' , CAST(  b.FPLANDELIVERYDATE AS DATE ) AS  FPLANDELIVERYDATE " +
            " from t_sal_order o  inner  join t_sal_orderentry b on o.FID = b.FID " +
            " left   join [T_BD_CUSTOMER_L] c on c.FCUSTID = o.FCUSTID " +
            " left   join [T_BD_MATERIAL] m on m.FMATERIALID = b.FMATERIALID " +
            " left   join T_BD_MATERIAL_L ml on ml.FMATERIALID = b.FMATERIALID " +
            " where FBILLNO = '" + salesOrder + "'  and b.FSEQ = '" + fseq + "'";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }

        [WebMethod]
        /// <summary>
        /// 根据销售单号得到行号信息
        /// </summary>
        /// <param name="salesOrder"></param>
        /// <returns></returns>
        public static DataTable GetEntrybySeOrderNo(string salesOrder)
        {
            string strSql = "select b.FSEQ  from t_sal_order a inner join t_sal_orderentry b on a.fid=b.fid where a.FBILLNO = '" + salesOrder + "' ";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }


        public static DataTable GetAllSEOrderListByBillNo(string no)
        {
            string strSql = "select top 20 fbillno from t_sal_order where FBILLNO like '%" + no + "%' ";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }



        public static DataTable GetAllTaskOrderNoListByBillNo(string no)
        {
            string strSql = "select top 20 fbillno from t_prd_mo where FBILLNO like '%" + no + "%' ";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }


        [WebMethod]
        /// <summary>
        /// 根据车间， 线别，年，周 ，版本号获取计划生产表数据
        /// </summary>
        /// <param name="work"></param>
        /// <param name="line"></param>
        /// <param name="year"></param>
        /// <param name="week"></param>
        /// <param name="version"></param>
        /// <returns></returns>
        public static DataTable GetPlanDataList(string work, string line, int year, int week, string version)
        {
            string strSql = "select d.gid ,c.FNAME as cusName , d.SEOrder , sed.FSEQ ,cast(sed.FQTY as decimal (18,2))as FQTY , mo.FBILLNO as 'TaskOrder' ,d.LineNum as TaskOrderNum, m.FNUMBER ,ml.FNAME as MaterialName ,d.LineDate , CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE," +
                            " SunDate,SunNum ,MonDate ,MonNum ,TuesDate ,TuesNum ,WedDate,WedNum ,ThurDate ,ThurNum ,FriDate ,FriNum ,SatDate ,SatNum ,d.Note " +
                            " from ProductVersionDetails d left join  (select o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE   from t_sal_order o " +
                            " inner join t_sal_orderentry b on o.FID = b.FID ) sed on sed.FBILLNO = d.SEOrder  and d.EntryID = sed.FSEQ  " +
                            " left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID " +
                            " left join[T_BD_MATERIAL] m on m.FMATERIALID = sed.FMATERIALID  " +
                            " left join T_BD_MATERIAL_L ml on ml.FMATERIALID = sed.FMATERIALID " +
                            " left join T_PRD_MOENTRY me on me.fsrcbillno = d.SEOrder and me.FSRCBILLENTRYSEQ = d.EntryID " +
                            " left join T_PRD_MO mo on mo.FID = me.FID and mo.fbillno=d.TaskOrder" +
                            " where fgid in (select Gid from ProductVersion where WorkShop = '" + work + "' and WorkLines = '" + line + "' and WorkYear = " + year + " and WorkWeek = " + week + " and VersionNo = '" + version + "' )  order by d.LineDate,d.OrderNo";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }

        [WebMethod]
        /// <summary>
        /// 根据销售任务单 获取具体信息
        /// </summary>
        /// <param name="taskOrder"></param>
        /// <returns></returns>
        public static DataTable GetTaskDetailByTaskOrder(string taskOrder)
        {
            string strSql = " select d.gid , c.FNAME as cusName , me.fsrcbillno as SEOrder , sed.FSEQ , cast(sed.FQTY as decimal(18,2))as FQTY, mo.fbillno  as TaskOrder, m.FNUMBER ,ml.FNAME as MaterialName  ,cast(me.FQTY AS decimal(18,2)) as 'TaskOrderNum',d.LineDate ,CAST( sed.FPLANDELIVERYDATE AS DATE ) AS FPLANDELIVERYDATE, " +
                               "   SunDate,SunNum ,MonDate ,MonNum ,TuesDate ,TuesNum ,WedDate,WedNum ,ThurDate ,ThurNum ,FriDate ,FriNum ,SatDate ,SatNum,d.Note " +
                               "   from T_PRD_MOENTRY me " +
                               "   inner join T_PRD_mo mo on mo.fid = me.fid " +
                               "   left join (select o.FBILLNO, b.FSEQ, o.FCUSTID, b.FMATERIALID, b.FQTY, b.FPLANDELIVERYDATE from t_sal_order o " +
                               "   inner join t_sal_orderentry b on o.FID = b.FID ) sed on sed.FBILLNO = me.fsrcbillno  and me.fsrcbillentryseq = sed.FSEQ " +
                               "   left join[T_BD_CUSTOMER_L] c on c.FCUSTID = sed.FCUSTID " +
                               "   left join[T_BD_MATERIAL] m on m.FMATERIALID = sed.FMATERIALID " +
                               "   left join T_BD_MATERIAL_L ml on ml.FMATERIALID = sed.FMATERIALID " +
                               "   left join ProductVersionDetails d on d.SEOrder = me.fsrcbillno and d.EntryID = me.fsrcbillentryseq and d.TaskOrder = '" + taskOrder + "'" +
                               "   where mo.fbillno = '" + taskOrder + "' ";
            DataTable dtResult = GetDataTableBySqlText(strSql);
            return dtResult;
        }

        [WebMethod]
        /// <summary>
        /// 提交数据 格式参见方法体
        /// </summary>
        /// <param name="json"></param>
        public static bool SaveDataOld(DataTable table, ref string ErrorMessage)
        {

            #region 申明参数
            decimal RsumLine = 0;
            decimal seorderNum = 0;
            string ProductPlanGid = string.Empty;
            string ProductTaskNo = string.Empty;
            string WorkShop = string.Empty;
            string WorkLines = string.Empty;
            int WorkYear = 0;
            int WorkWeek = 0;
            string VersionNo = string.Empty;
            string SEOrder = string.Empty;
            int FSEQ = 0;
            Decimal SumLineNum = 0;
            Decimal LineNum = 0;
            string LineDate = string.Empty;
            string SunDate = string.Empty;
            Decimal SunNum = 0;
            string SatDate = string.Empty;
            Decimal SatNum = 0;
            string FriDate = string.Empty;
            Decimal FriNum = 0;
            string ThurDate = string.Empty;
            Decimal ThurNum = 0;
            string WedDate = string.Empty;
            Decimal WedNum = 0;
            string TuesDate = string.Empty;
            Decimal TuesNum = 0;
            string MonDate = string.Empty;
            Decimal MonNum = 0;
            string Note = "";
            bool IsLatestVersion = false;
            bool IsFirstSave = true;
            string NewVerisonNo = "";
            #endregion

            #region 计算SumLineNum 
            table.Columns.Add("SumLineNum", typeof(Decimal));
            for (int i = 0; i < table.Rows.Count; i++)
            {
                table.Rows[i]["SumLineNum"] = table.Rows[i]["LineNum"].ToString() == "" ? 0 : table.Rows[i]["LineNum"];
                for (int j = 0; j < table.Rows.Count; j++)
                {
                    if (i != j && table.Rows[i]["SEOrder"] == table.Rows[j]["SEOrder"] && table.Rows[i]["FSEQ"] == table.Rows[j]["FSEQ"])
                    {
                        table.Rows[i]["SumLineNum"] = decimal.Parse(table.Rows[i]["SumLineNum"].ToString()) +
                        decimal.Parse(table.Rows[j]["LineNum"].ToString() == "" ? "0" : table.Rows[j]["LineNum"].ToString());
                    }
                }
            }
            #endregion

            #region  生产任务单验证
            for (int i = 0; i < table.Rows.Count; i++)
            {
                #region  参数赋值       
                try
                {
                    ProductTaskNo = table.Rows[i]["TaskOrder"].ToString();
                    SumLineNum = decimal.Parse(table.Rows[i]["SumLineNum"].ToString());
                    SEOrder = table.Rows[i]["SEOrder"].ToString();
                    FSEQ = int.Parse(table.Rows[i]["FSEQ"].ToString());
                    LineNum = decimal.Parse(table.Rows[i]["LineNum"].ToString());
                    SunNum = decimal.Parse(table.Rows[i]["SunNum"].ToString() == "" ? "0" : table.Rows[i]["SunNum"].ToString());
                    SatNum = decimal.Parse(table.Rows[i]["SatNum"].ToString() == "" ? "0" : table.Rows[i]["SatNum"].ToString());
                    FriNum = decimal.Parse(table.Rows[i]["FriNum"].ToString() == "" ? "0" : table.Rows[i]["FriNum"].ToString());
                    ThurNum = decimal.Parse(table.Rows[i]["ThurNum"].ToString() == "" ? "0" : table.Rows[i]["ThurNum"].ToString());
                    WedNum = decimal.Parse(table.Rows[i]["WedNum"].ToString() == "" ? "0" : table.Rows[i]["WedNum"].ToString());
                    TuesNum = decimal.Parse(table.Rows[i]["TuesNum"].ToString() == "" ? "0" : table.Rows[i]["TuesNum"].ToString());
                    MonNum = decimal.Parse(table.Rows[i]["MonNum"].ToString() == "" ? "0" : table.Rows[i]["MonNum"].ToString());
                }
                catch (Exception ex)
                {
                    ErrorMessage = ex.Message;
                    return false;
                }
                #endregion
                string strSql = "select 1  from t_sal_orderentry d inner  join t_sal_order a on a.fid = d.fid " +
                                            "  inner join T_PRD_MOENTRY t on t.fsrcbillno = a.FBILLNO " +
                                            "  inner join T_PRD_mo m on m.FID = t.fid " +
                                            "  where a.FBILLNO = '" + SEOrder + "' and d.FSEQ = " + FSEQ + " and m.FBILLNO ='" + ProductTaskNo + "'";
                bool hasData = ExecDataBySqlText(strSql);
                if (!hasData)
                {
                    ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次的任务生产单号[ " + ProductTaskNo + " ]不存在，请重新检查.";
                    return false;
                }
                string sumLine = " select max( d.fqty), isnull(sum(t.FQTY ),0)  from t_sal_orderentry d inner  join t_sal_order a on a.fid = d.fid " +
                                             " left join T_PRD_MOENTRY t on t.fsrcbillno = a.FBILLNO " +
                                             " where a.FBILLNO = '" + SEOrder + "' and d.FSEQ = " + FSEQ + "";
                DataTable dtr = GetDataTableBySqlText(sumLine);
                try
                {
                    RsumLine = dtr.Rows[0][1] == null ? 0 : decimal.Parse(dtr.Rows[0][0].ToString());
                    seorderNum = decimal.Parse(dtr.Rows[0][0].ToString());

                    if (RsumLine + SumLineNum > seorderNum)
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次已经超过销售订单数量.";
                        return false;
                    }
                    decimal PlanSum = SunNum + SatNum + FriNum + TuesNum + WedNum + TuesNum + MonNum;
                    if (PlanSum == 0)
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次周计划数量不能为0.";
                        return false;
                    }
                    if (PlanSum > LineNum)
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次周计划数量总和不能超过生产任务单数量.";
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    ErrorMessage = ex.Message;
                    return false;
                }
            }
            #endregion


            for (int i = 0; i < table.Rows.Count; i++)
            {
                #region  参数赋值               
                ProductPlanGid = table.Rows[i]["gid"].ToString();
                ProductTaskNo = table.Rows[i]["TaskOrder"].ToString();
                Note = table.Rows[i]["Note"].ToString();
                WorkShop = table.Rows[i]["WorkShop"].ToString();
                WorkLines = table.Rows[i]["WorkLines"].ToString();
                WorkYear = int.Parse(table.Rows[i]["WorkYear"].ToString());
                WorkWeek = int.Parse(table.Rows[i]["WorkWeek"].ToString());
                VersionNo = table.Rows[i]["VersionNo"].ToString();
                SEOrder = table.Rows[i]["SEOrder"].ToString();
                FSEQ = int.Parse(table.Rows[i]["FSEQ"].ToString());
                LineNum = decimal.Parse(table.Rows[i]["LineNum"].ToString());
                LineDate = table.Rows[i]["LineDate"].ToString();

                SunDate = table.Rows[i]["SunDate"].ToString();
                SatDate = table.Rows[i]["SatDate"].ToString();
                FriDate = table.Rows[i]["FriDate"].ToString();
                ThurDate = table.Rows[i]["ThurDate"].ToString();
                WedDate = table.Rows[i]["WedDate"].ToString();
                TuesDate = table.Rows[i]["TuesDate"].ToString();
                MonDate = table.Rows[i]["MonDate"].ToString();

                SunNum = decimal.Parse(table.Rows[i]["SunNum"].ToString() == "" ? "0" : table.Rows[i]["SunNum"].ToString());
                SatNum = decimal.Parse(table.Rows[i]["SatNum"].ToString() == "" ? "0" : table.Rows[i]["SatNum"].ToString());
                FriNum = decimal.Parse(table.Rows[i]["FriNum"].ToString() == "" ? "0" : table.Rows[i]["FriNum"].ToString());
                ThurNum = decimal.Parse(table.Rows[i]["ThurNum"].ToString() == "" ? "0" : table.Rows[i]["ThurNum"].ToString());
                WedNum = decimal.Parse(table.Rows[i]["WedNum"].ToString() == "" ? "0" : table.Rows[i]["WedNum"].ToString());
                TuesNum = decimal.Parse(table.Rows[i]["TuesNum"].ToString() == "" ? "0" : table.Rows[i]["TuesNum"].ToString());
                MonNum = decimal.Parse(table.Rows[i]["MonNum"].ToString() == "" ? "0" : table.Rows[i]["MonNum"].ToString());
                #endregion

                if (LineDate == string.Empty)
                {
                    LineDate = SunNum != 0 ? SunDate : SatNum != 0 ? SatDate : FriNum != 0 ? FriDate : ThurNum != 0 ? ThurDate : WedNum != 0 ? WedDate : TuesNum != 0 ? TuesDate : MonDate;
                }

                #region  判断当前是不是最新版本号
                if (!IsLatestVersion)
                {
                    string sql = "select VersionNo from ProductVersion where WorkShop = '" + WorkShop + "' and WorkLines = '" + WorkLines + "' and WorkYear = " + WorkYear + " and WorkWeek = " + WorkWeek + " and IslastestVersion=1 ";
                    DataTable dt = GetDataTableBySqlText(sql);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        IsFirstSave = false;
                        if (VersionNo != dt.Rows[0][0].ToString())
                        {
                            ErrorMessage = "当前不是最新版本,请切换最新版本再提交.";
                            return false;
                        }
                    }
                    IsLatestVersion = true;
                }
                #endregion

                #region 生成新版本号
                if (NewVerisonNo == "")
                {
                    if (!IsFirstSave)
                    {
                        string getVersion = " select codevalue  from codetable where codetype='VesionRecord' and codeid=( select codeid+1 from codetable where codetype = 'VesionRecord' and codevalue = '" + VersionNo + "')";
                        DataTable dtVersion = GetDataTableBySqlText(getVersion);
                        if (dtVersion.Rows != null && dtVersion.Rows.Count > 0)
                        {
                            NewVerisonNo = dtVersion.Rows[0][0].ToString();
                        }
                        else
                        {
                            ErrorMessage = "超过现有的版本数，无法跟新下一个版本，请更新版本数.";
                            return false;
                        }
                    }
                    else
                    {
                        NewVerisonNo = "A";
                    }
                }
                #endregion

                #region 生成生产任务单号(如果是新增的数据并且还没有生成生产任务单)
                if (ProductPlanGid == "" && ProductTaskNo == "")
                {
                    string message = "";
                    //ProductTaskNo = GetTaskNo(SEOrder, FSEQ, ref message);
                    ProductTaskNo = DateTime.Now.ToString("yyyy-mm-dd").Replace("-", "") + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();
                    if (ProductTaskNo == null)
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次生成任务单号失败：" + message + "'";
                        return false;
                    }
                }
                #endregion

                #region  存储过程生成生产计划表
                DC_Error error = new DC_Error();
                int iAffected = 0;
                Dictionary<string, object> dict = new Dictionary<string, object>();
                dict.Add("@gid", ProductPlanGid);
                dict.Add("@WorkShop", WorkShop);
                dict.Add("@WorkLines", WorkLines);
                dict.Add("@WorkYear", WorkYear);
                dict.Add("@WorkWeek", WorkWeek);

                dict.Add("@VersionNo", NewVerisonNo);
                dict.Add("@SEOrder", SEOrder);
                dict.Add("@FSEQ", FSEQ);
                dict.Add("@TaskOrder", ProductTaskNo);
                dict.Add("@LineNum", LineNum);

                dict.Add("@LineDate", DateTime.Parse(LineDate));
                dict.Add("@SunDate", DateTime.Parse(SunDate));
                dict.Add("@SatDate", DateTime.Parse(SatDate));
                dict.Add("@FriDate", DateTime.Parse(FriDate));
                dict.Add("@ThurDate", DateTime.Parse(ThurDate));

                dict.Add("@WedDate", DateTime.Parse(WedDate));
                dict.Add("@TuesDate", DateTime.Parse(TuesDate));
                dict.Add("@MonDate", DateTime.Parse(MonDate));
                dict.Add("@SunNum", SunNum);
                dict.Add("@SatNum", SatNum);

                dict.Add("@FriNum", FriNum);
                dict.Add("@ThurNum", ThurNum);
                dict.Add("@WedNum", WedNum);
                dict.Add("@TuesNum", TuesNum);
                dict.Add("@MonNum", MonNum);
                dict.Add("@Note", Note);
                DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
                bool result = myDALTranscation.ExecuteTransactionSP("[usp_create_ProductPan]", dict, ref error, ref iAffected);
                #endregion
            }
            return true;
        }

        public static bool SaveData(DataTable table, ref string ErrorMessage)
        {

            #region 申明参数    
            string TaskOrderNum = string.Empty;
            string ProductPlanGid = string.Empty;
            string ProductTaskNo = string.Empty;
            string WorkShop = string.Empty;
            string WorkLines = string.Empty;
            int WorkYear = 0;
            int WorkWeek = 0;
            string VersionNo = string.Empty;
            string SEOrder = string.Empty;
            int FSEQ = 0;

            string LineDate = string.Empty;
            string SunDate = string.Empty;
            string SunNum = string.Empty;
            string SatDate = string.Empty;
            string SatNum = string.Empty;
            string FriDate = string.Empty;
            string FriNum = string.Empty;
            string ThurDate = string.Empty;
            string ThurNum = string.Empty;
            string WedDate = string.Empty;
            string WedNum = string.Empty;
            string TuesDate = string.Empty;
            string TuesNum = string.Empty;
            string MonDate = string.Empty;
            string MonNum = string.Empty;
            string Note = "";
            bool IsLatestVersion = false;
            bool IsFirstSave = true;
            string NewVerisonNo = "";
            #endregion    

            #region  生产任务单验证
            for (int i = 0; i < table.Rows.Count; i++)
            {
                #region  参数赋值       
                try
                {
                    ProductTaskNo = table.Rows[i]["TaskOrder"].ToString();
                    TaskOrderNum = table.Rows[i]["TaskOrderNum"].ToString();
                    SEOrder = table.Rows[i]["SEOrder"].ToString();
                    FSEQ = int.Parse(table.Rows[i]["FSEQ"].ToString());
                    SunNum = table.Rows[i]["SunNum"].ToString();
                    SatNum = table.Rows[i]["SatNum"].ToString();
                    FriNum = table.Rows[i]["FriNum"].ToString();
                    ThurNum = table.Rows[i]["ThurNum"].ToString();
                    WedNum = table.Rows[i]["WedNum"].ToString();
                    TuesNum = table.Rows[i]["TuesNum"].ToString();
                    MonNum = table.Rows[i]["MonNum"].ToString();
                }
                catch (Exception ex)
                {
                    ErrorMessage = ex.Message;
                    return false;
                }
                #endregion
                if (ProductTaskNo != "")
                {
                    string strSql = "select 1  from t_sal_orderentry d inner  join t_sal_order a on a.fid = d.fid " +
                                                             "  inner join T_PRD_MOENTRY t on t.fsrcbillno = a.FBILLNO " +
                                                             "  inner join T_PRD_mo m on m.FID = t.fid " +
                                                             "  where a.FBILLNO = '" + SEOrder + "' and d.FSEQ = " + FSEQ + " and m.FBILLNO ='" + ProductTaskNo + "'";
                    DataTable DT = GetDataTableBySqlText(strSql);
                    if (!(DT.Rows != null && DT.Rows.Count > 0))
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次的任务生产单号[ " + ProductTaskNo + " ]不存在.";
                        return false;
                    }
                    //decimal PlanSum = SunNum + decimal.Parse(SatNum==""?"0": SatNum) + FriNum + TuesNum + WedNum + TuesNum + MonNum;
                    decimal PlanSum = decimal.Parse(SunNum == "" ? "0" : SunNum) +
                                      decimal.Parse(SatNum == "" ? "0" : SatNum)
                                     + decimal.Parse(FriNum == "" ? "0" : FriNum) +
                                     decimal.Parse(TuesNum == "" ? "0" : TuesNum) +
                                     decimal.Parse(WedNum == "" ? "0" : WedNum) +
                                     decimal.Parse(TuesNum == "" ? "0" : TuesNum) +
                                     decimal.Parse(MonNum == "" ? "0" : MonNum);
                    if (PlanSum == 0)
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次周计划数量不能为0.";
                        return false;
                    }
                    if (PlanSum > Decimal.Parse(TaskOrderNum == "" ? "0" : TaskOrderNum))
                    {
                        ErrorMessage = "销售订单号[ " + SEOrder + " ] " + FSEQ + " 项次周计划数量总和不能超过生产任务单数量.";
                        return false;
                    }

                }
            }
            #endregion


            for (int j = 0; j < table.Rows.Count; j++)
            {
                #region  参数赋值               
                ProductPlanGid = table.Rows[j]["gid"].ToString();
                ProductTaskNo = table.Rows[j]["TaskOrder"].ToString();
                TaskOrderNum = table.Rows[j]["TaskOrderNum"].ToString();
                Note = table.Rows[j]["Note"].ToString();
                WorkShop = table.Rows[j]["WorkShop"].ToString();
                WorkLines = table.Rows[j]["WorkLines"].ToString();
                WorkYear = int.Parse(table.Rows[j]["WorkYear"].ToString());
                WorkWeek = int.Parse(table.Rows[j]["WorkWeek"].ToString());
                VersionNo = table.Rows[j]["VersionNo"].ToString();
                SEOrder = table.Rows[j]["SEOrder"].ToString();
                FSEQ = int.Parse(table.Rows[j]["FSEQ"].ToString());
                LineDate = table.Rows[j]["LineDate"].ToString();

                SunDate = table.Rows[j]["SunDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["SunDate"].ToString();
                SatDate = table.Rows[j]["SatDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["SatDate"].ToString();
                FriDate = table.Rows[j]["FriDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["FriDate"].ToString();
                ThurDate = table.Rows[j]["ThurDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["ThurDate"].ToString();
                WedDate = table.Rows[j]["WedDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["WedDate"].ToString();
                TuesDate = table.Rows[j]["TuesDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["TuesDate"].ToString();
                MonDate = table.Rows[j]["MonDate"].ToString() == "" ? "1900-01-01" : table.Rows[j]["MonDate"].ToString();

                SunNum = table.Rows[j]["SunNum"].ToString();
                SatNum = table.Rows[j]["SatNum"].ToString();
                FriNum = table.Rows[j]["FriNum"].ToString();
                ThurNum = table.Rows[j]["ThurNum"].ToString();
                WedNum = table.Rows[j]["WedNum"].ToString();
                TuesNum = table.Rows[j]["TuesNum"].ToString();
                MonNum = table.Rows[j]["MonNum"].ToString();

                //SunNum = decimal.Parse(table.Rows[j]["SunNum"].ToString() == "" ? "0" : table.Rows[j]["SunNum"].ToString());
                //SatNum = decimal.Parse(table.Rows[j]["SatNum"].ToString() == "" ? "0" : table.Rows[j]["SatNum"].ToString());
                //FriNum = decimal.Parse(table.Rows[j]["FriNum"].ToString() == "" ? "0" : table.Rows[j]["FriNum"].ToString());
                //ThurNum = decimal.Parse(table.Rows[j]["ThurNum"].ToString() == "" ? "0" : table.Rows[j]["ThurNum"].ToString());
                //WedNum = decimal.Parse(table.Rows[j]["WedNum"].ToString() == "" ? "0" : table.Rows[j]["WedNum"].ToString());
                //TuesNum = decimal.Parse(table.Rows[j]["TuesNum"].ToString() == "" ? "0" : table.Rows[j]["TuesNum"].ToString());
                //MonNum = decimal.Parse(table.Rows[j]["MonNum"].ToString() == "" ? "0" : table.Rows[j]["MonNum"].ToString());
                #endregion

                if (LineDate == string.Empty)
                {
                    LineDate = decimal.Parse(SunNum == "" ? "0" : SunNum) > 0 ? SunDate :
                                decimal.Parse(SatNum == "" ? "0" : SatNum) > 0 ? SatDate :
                                decimal.Parse(FriNum == "" ? "0" : FriNum) > 0 ? FriDate :
                                decimal.Parse(ThurNum == "" ? "0" : ThurNum) > 0 ? ThurDate :
                                 decimal.Parse(WedNum == "" ? "0" : WedNum) > 0 ? WedDate :
                                 decimal.Parse(TuesNum == "" ? "0" : TuesNum) > 0 ? TuesDate :
                                 decimal.Parse(MonNum == "" ? "0" : MonNum) > 0 ? MonDate : LineDate;

                }

                #region  判断当前是不是最新版本号
                if (!IsLatestVersion)
                {
                    string sql = "select VersionNo from ProductVersion where WorkShop = '" + WorkShop + "' and WorkLines = '" + WorkLines + "' and WorkYear = " + WorkYear + " and WorkWeek = " + WorkWeek + " and IslastestVersion=1 ";
                    DataTable dt = GetDataTableBySqlText(sql);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        IsFirstSave = false;
                        if (VersionNo != dt.Rows[0][0].ToString())
                        {
                            ErrorMessage = "当前不是最新版本,请切换最新版本再提交.";
                            return false;
                        }
                    }
                    IsLatestVersion = true;
                }
                #endregion

                #region 生成新版本号
                if (NewVerisonNo == "")
                {
                    if (!IsFirstSave)
                    {
                        string getVersion = " select codevalue  from codetable where codetype='VesionRecord' and codeid=( select codeid+1 from codetable where codetype = 'VesionRecord' and codevalue = '" + VersionNo + "')";
                        DataTable dtVersion = GetDataTableBySqlText(getVersion);
                        if (dtVersion.Rows != null && dtVersion.Rows.Count > 0)
                        {
                            NewVerisonNo = dtVersion.Rows[0][0].ToString();
                        }
                        else
                        {
                            ErrorMessage = "超过现有的版本数，无法跟新下一个版本，请更新版本数.";
                            return false;
                        }
                    }
                    else
                    {
                        NewVerisonNo = "A";
                    }
                }
                #endregion            

                #region  存储过程生成生产计划表
                DC_Error error = new DC_Error();
                int iAffected = 0;
                Dictionary<string, object> dict = new Dictionary<string, object>();
                dict.Add("@Gid", ProductPlanGid);
                dict.Add("@WorkShop", WorkShop);
                dict.Add("@WorkLines", WorkLines);
                dict.Add("@WorkYear", WorkYear);
                dict.Add("@WorkWeek", WorkWeek);
                dict.Add("@VersionNo", NewVerisonNo);
                dict.Add("@SEOrder", SEOrder);
                dict.Add("@FSEQ", FSEQ);
                dict.Add("@TaskOrder", ProductTaskNo);

                dict.Add("@LineNum", TaskOrderNum);

                dict.Add("@LineDate", LineDate);
                dict.Add("@SunDate", DateTime.Parse(SunDate));
                dict.Add("@SatDate", DateTime.Parse(SatDate));
                dict.Add("@FriDate", DateTime.Parse(FriDate));
                dict.Add("@ThurDate", DateTime.Parse(ThurDate));
                dict.Add("@WedDate", DateTime.Parse(WedDate));
                dict.Add("@TuesDate", DateTime.Parse(TuesDate));
                dict.Add("@MonDate", DateTime.Parse(MonDate));

                dict.Add("@SunNum", SunNum);
                dict.Add("@SatNum", SatNum);
                dict.Add("@FriNum", FriNum);
                dict.Add("@ThurNum", ThurNum);
                dict.Add("@WedNum", WedNum);
                dict.Add("@TuesNum", TuesNum);
                dict.Add("@MonNum", MonNum);
                dict.Add("@Note", Note);
                dict.Add("@OrderNo", j+1);
                DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
                bool result = myDALTranscation.ExecuteTransactionSP("usp_create_ProductPan", dict, ref error, ref iAffected);
                if (!result)
                {
                    ErrorMessage = error.ErrorDesc;
                    return false;
                }
                #endregion
            }
            return true;
        }

        /// <summary>
        /// 提交产生销售
        /// </summary>
        /// <param name="seorderNo"></param>
        /// <param name="fseq"></param>
        /// <param name="taksOrdernum"></param>
        /// <param name="errormessage"></param>
        /// <returns></returns>
        public static bool SubmitTaskOrder(string seorderNo, int fseq, decimal taksOrdernum, ref string errormessage)
        {
            string data = " select max( d.fqty), isnull(sum(t.FQTY ),0)  from t_sal_orderentry d inner  join t_sal_order a on a.fid = d.fid " +
                                           " left join T_PRD_MOENTRY t on t.fsrcbillno = a.FBILLNO " +
                                           " where a.FBILLNO = '" + seorderNo + "' and d.FSEQ = " + fseq + "";
            DataTable dtr = GetDataTableBySqlText(data);

            decimal sumTaskOrderNum = dtr.Rows[0][1] == null ? 0 : decimal.Parse(dtr.Rows[0][1].ToString());
            decimal seorderNum = decimal.Parse(dtr.Rows[0][0].ToString());

            if (sumTaskOrderNum + taksOrdernum > seorderNum)
            {
                errormessage = "销售订单号[ " + seorderNo + " ] " + fseq + " 项次的生产任务单数量已经超过所需生产总量.";
                return false;
            }

            string message = "";
            string ProductTaskNo = GetTaskNo(seorderNo, fseq, ref message);
            //ProductTaskNo = DateTime.Now.ToString("yyyy-mm-dd").Replace("-", "") + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();
            if (ProductTaskNo == "" || ProductTaskNo == null)
            {
                errormessage = "销售订单号[ " + seorderNo + " ] " + fseq + " 项次生成任务单号失败：" + message + "'";
                return false;
            }
            return true;
        }

        [WebMethod]
        /// <summary>
        /// 获取调整单默认版本号
        /// </summary>
        /// <returns></returns>
        public static DataTable GetAdjustDefalutVersionNo(string workshop, string line, int year, int week)
        {
            string strSql = "select '请选择' AS VersionNo UNION  select VersionNo  from AdjustVersion where WorkShop ='" + workshop + "' and WorkLines ='" + line + "' and WorkYear =" + year + " and WorkWeek =" + week + " order by VersionNo desc ";
            DataTable dt = GetDataTableBySqlText(strSql);
            return dt;
        }

        /// <summary>
        /// 根据车间， 线别， 年 周  ， 版本号 获取最新生产调整单
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        [WebMethod]
        public static DataTable GetAdjustedList(string workshop, string worklines, int workYear, int workWeek, string versionNo)
        {
            string sql = "";
            //string sqlcon = "select 1 from AdjustVersion WHERE WorkShop ='" + workshop + "' AND WorkLines = '" + worklines + "' AND WorkYear ='" + workYear + "' AND WorkWeek = " + workWeek + " and IslastestVersion = 1";
            //DataTable  hasAdjust = GetDataTableBySqlText (sqlcon);
            //if (hasAdjust.Rows !=null && hasAdjust.Rows.Count >0)
            if(versionNo !="请选择")
            {
                sql = "SELECT distinct d.FDGid as gid, c.FNAME as 'cusName', pd.SEOrder, pd.EntryID AS FSEQ, Convert(decimal(18,2),b.FQTY) as 'FQTY'," +
                          " pd.TaskOrder,m.FNUMBER as 'FNumber', ml.FNAME as 'MaterialName',pd.LineNum ,pd.LineDate ,p.WorkShop,p.WorkLines,d.AdjustToWorkshop ,d.AdjustToWorkLines,d.AdjustToWorkshop as YuanWorkShop,d.AdjustToWorkLines as YuanWorkLines," +
                          " SunDate,SunNum ,MonDate ,MonNum ,TuesDate ,TuesNum ,WedDate,WedNum ,ThurDate ,ThurNum ,FriDate ,FriNum ,SatDate ,SatNum ,pd.Note " +
                          " FROM AdjustVersion p " +
                          " INNER JOIN AdjustVersionDetatils d on d.FGid = p.gid " +
                          " INNER JOIN ProductVersionDetails pd on pd.gid = d.fdgid " +
                          " INNER JOIN t_sal_order s on s.fbillNO = pd.seorder " +
                          " INNER JOIN t_sal_orderentry b on s.FID = b.FID and b.fseq=pd.entryid " +
                          " LEFT JOIN [T_BD_CUSTOMER_L] c on c.FCUSTID = s.FCUSTID " +
                          " LEFT JOIN [T_BD_MATERIAL] m on m.FMATERIALID = b.FMATERIALID " +
                          " LEFT JOIN T_BD_MATERIAL_L ml on ml.FMATERIALID = b.FMATERIALID " +
                          " WHERE WorkShop ='" + workshop + "' AND WorkLines = '" + worklines + "' AND WorkYear ='" + workYear + "' AND WorkWeek = " + workWeek + " and versionNO = '" + versionNo + "' order by pd.LineDate";
            }
            else
            {
                sql = "SELECT d.gid, c.FNAME as 'CusName',d.seorder, d.EntryID AS FSEQ, Convert(decimal(18,2), b.FQTY )as 'FQTY'," +
                      " d.TaskOrder, m.FNUMBER as  'FNumber', ml.FNAME as 'MaterialName' , d.LineNum , d.LineDate ,WorkShop,WorkLines ,WorkShop as AdjustToWorkshop,WorkLines as AdjustToWorkLines,WorkShop as YuanWorkShop,WorkLines as YuanWorkLines," +
                      " SunDate,SunNum ,MonDate ,MonNum ,TuesDate ,TuesNum ,WedDate,WedNum ,ThurDate ,ThurNum ,FriDate ,FriNum ,SatDate ,SatNum ,d.Note " +
                      " FROM ProductVersion  p  " +
                         " INNER JOIN ProductVersionDetails  d on d.FGid = p.gid " +
                         " inner join t_sal_order s on s.fbillNO = d.seorder " +
                         " inner join t_sal_orderentry b on s.FID = b.FID and b.FSEQ =d.EntryID " +
                         " left join[T_BD_CUSTOMER_L] c on c.FCUSTID = s.FCUSTID " +
                         " left join[T_BD_MATERIAL] m on m.FMATERIALID = b.FMATERIALID " +
                         " left join T_BD_MATERIAL_L ml on ml.FMATERIALID = b.FMATERIALID " +
                         " WHERE WorkShop ='" + workshop + "' AND WorkLines = '" + worklines + "' AND WorkYear ='" + workYear + "' AND WorkWeek = " + workWeek + " and IslastestVersion = 1 order by d.LineDate";
            }
            DataTable dt = GetDataTableBySqlText(sql);
            return dt;
        }



        /// <summary>
        /// 调整单保存功能
        /// </summary>
        /// <returns></returns>  
        [WebMethod]
        public static bool AdjustProductPlan(DataTable dt, ref string errorMessage)
        {
            string gid = string.Empty;
            string workshopTo = string.Empty;
            string worklinesTo = string.Empty;
            string Yuanworkshop = string.Empty;
            string Yuanworklines = string.Empty;
            string LogversionNo = DateTime.Now.ToString();
            string versionNo = string.Empty;
            string workshop = string.Empty;
            string worklines = string.Empty;
            string workYear = DateTime.Now.ToString();
            string workWeek = string.Empty;
            string sql = "";
            bool IsLatestVersion = false;
            try
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    gid = dt.Rows[i]["gid"].ToString();
                    workshopTo = dt.Rows[i]["AdjustToWorkshop"].ToString();
                    worklinesTo = dt.Rows[i]["AdjustToWorkLines"].ToString();
                    Yuanworkshop = dt.Rows[i]["YuanWorkShop"].ToString();
                    Yuanworklines = dt.Rows[i]["YuanWorkLines"].ToString();
                    versionNo = dt.Rows[i]["VersionNo"].ToString()=="请选择"?"": dt.Rows[i]["VersionNo"].ToString();
                    workshop = dt.Rows[i]["WorkShop"].ToString();
                    worklines = dt.Rows[i]["WorkLines"].ToString();
                    workYear = dt.Rows[i]["WorkYear"].ToString();
                    workWeek = dt.Rows[i]["WorkWeek"].ToString();
                    #region  判断当前是不是最新版本号
                    if (!IsLatestVersion)
                    {
                        //sql = "select VersionNo from AdjustVersion where WorkShop = '" + workshop + "' and WorkLines = '" + worklines + "' and WorkYear = " + workYear + " and WorkWeek = " + workWeek + " and IslastestVersion=1 ";
                        //DataTable dtt = GetDataTableBySqlText(sql);
                        //if (dtt != null && dtt.Rows.Count > 0)
                        //{
                        if (versionNo != "")
                        {
                            errorMessage = "当前不是最新版本,请切换最新版本再提交.";
                            return false;
                        }
                        //}

                        IsLatestVersion = true;
                    }
                    if (gid == "")
                    {
                        errorMessage = "外键GID不能为空";
                    }
                    sql = "insert into AdjustPanLog (versionNo,fgid,AdjustToWorkshop,AdjustToWorkLines, WorkShop,WorkLines,WorkYear,WorkWeek,YuanWorkshop, YuanWorkLines) values('" + LogversionNo + "','" + gid + "','" + workshopTo + "','" + worklinesTo + "','" + workshop + "','" + worklines + "','" + workYear + "','" + workWeek + "','"+Yuanworkshop +"','"+Yuanworklines +"')";
                    ExecDataBySqlText(sql);
                   
                    #endregion
                }
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                return false;
            }

           
            DataAccess.DALTranscation myDALTranscation = new DataAccess.DALTranscation();
            try
            {
                SqlParameter Logversion = new SqlParameter();
                Logversion.Direction = ParameterDirection.Input;
                Logversion.ParameterName = "@LogversionNo";
                Logversion.SqlDbType = SqlDbType.VarChar;
                Logversion.Size = 80;
                Logversion.Value = LogversionNo;

                SqlParameter paraReturn = new SqlParameter();
                paraReturn.Direction = ParameterDirection.Output;
                paraReturn.ParameterName = "@ErrorMessage";
                paraReturn.SqlDbType = SqlDbType.VarChar;
                paraReturn.Size = 4000;
                paraReturn.Value = "";

                errorMessage = myDALTranscation.ExecuteNonQueryRtnString (CommandType.StoredProcedure, "[usp_AdjustProductPlan]",
                  new SqlParameter[] { Logversion, paraReturn });
                if (errorMessage != "")
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                errorMessage = "中间层发生错误:" + ex.Message;

            }
            return true;
        }

    }
}
