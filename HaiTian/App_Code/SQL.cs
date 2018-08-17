using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

/// <summary>
/// sql 的摘要说明
/// </summary>

namespace SQL
{
    public class SQLServer
    {
        public SQLServer()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        public static bool ExecSql(string strSql, ref string Message)
        {
            bool bol = false;
            String connStr = ConfigurationManager.AppSettings["ConnectionString"];
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();    //真正与数据库连接
            SqlCommand cmd = new SqlCommand();   //创建命令对象
            cmd.CommandText = strSql;   //写SQL语句
            cmd.Connection = conn;             //指定连接对象，即上面创建的
            try
            {
                cmd.ExecuteNonQuery();  //这个仅仅执行SQL命令，不返回结果集，实用于建表、批量更新等不需要返回结果的操作
                bol = true;
            }
            catch (Exception e)
            {
                Message = e.Message;
                bol = false;
            }
            conn.Close();
            return bol;
        }

        public static DataTable GetDataTable(string strSql, ref string Message)
        {
            String connStr = ConfigurationManager.AppSettings["ConnectionString"];
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();    //真正与数据库连接
            SqlCommand cmd = new SqlCommand();   //创建命令对象
            cmd.CommandText = strSql;   //写SQL语句
            cmd.Connection = conn;             //指定连接对象，即上面创建的
            SqlDataAdapter dbAdapter = new SqlDataAdapter(cmd); //注意与上面的区分开
            DataSet ds = new DataSet(); //创建数据集对象
            DataTable dt = null;
            try
            {
                dbAdapter.Fill(ds);
            }
            catch (Exception e)
            {
                Message = e.Message;
                return dt;
            }
            if (ds.Tables.Count != 0)
            {
                dt = ds.Tables[0];
            }
            conn.Close();
            return dt;

        }

        public static bool TableValuedToDB(DataTable dt,ref string Msg)
        {
            SqlConnection sqlConn = new SqlConnection(
              ConfigurationManager.AppSettings["ConnectionString"]);
            string delsql = "delete from t_chanpinxilie where xilieID=(select FItemID from t_Item where FName='" + dt.Rows[0][0] + "')";

             string TSqlStatement =
             delsql+" insert into t_chanpinxilie(xilieID,childmatID,supID) select it.FItemID,ic.FItemID,per.FItemID FROM @BulkTest nc join t_item it on it.FName=nc.col1 join t_icitem ic on ic.FNumber=nc.col2 left join t_Supplier per on nc.col3=per.FNumber";
            SqlCommand cmd = new SqlCommand(TSqlStatement, sqlConn);
            SqlParameter catParam = cmd.Parameters.AddWithValue("@BulkTest", dt);
            catParam.SqlDbType = SqlDbType.Structured;
            //表值参数的名字叫BulkUdt，在上面的建立测试环境的SQL中有。
            catParam.TypeName = "dbo.SaveCPXLType";
            try
            {
                sqlConn.Open();
                if (dt != null && dt.Rows.Count != 0)
                {
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                sqlConn.Close();
            }

            return true;
        }

    }
}