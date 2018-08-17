<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CalculateSalaryReport.aspx.cs" Inherits="CalculateSalaryReport" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="name" content="csr">
<title></title>
<link rel="stylesheet" href="jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<script src="jquery/jquery-1.11.3/jquery.js"></script>
<script src="jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="Guriddo_jqGrid_JS_5.2.1/src/i18n/grid.locale-cn.js"></script>
<script src="Guriddo_jqGrid_JS_5.2.1/js/jquery.jqGrid.min.js"></script>
<link rel="stylesheet" href="Guriddo_jqGrid_JS_5.2.1/css/ui.jqgrid.css" />
<script type="text/javascript" src="My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="css/HaiTian.css" />
<script type="text/javascript" src="js/jquery.cookie.js"></script>
    <script src="js/public.js"></script>
<script src="js/CalculateSalaryReport.js"></script>

</head>
<body>
<form id="form1">
        <div id="Menu"></div>
        <h1>薪资计算</h1>
        <div>
                <div class="header">
                        <table id="header">
                                <tr>
                                        <td ><label for="year">选择年份</label></td>
                                        <td ><select name="year" id="year" class="form-control">
                                                        <option>2017</option>
                                                        <option>2018</option>
                                                        <option>2019</option>
                                                        <option>2020</option>
                                                        <option>2021</option>
                                                        <option>2022</option>
                                                        <option>2023</option>
                                                        <option>2024</option>
                                                        <option>2025</option>
                                                </select></td>
                                        <td ><label for="month">选择月份</label></td>
                                        <td ><select name="month" id="month" class="form-control">
                                                        <option>1</option>
                                                        <option>2</option>
                                                        <option>3</option>
                                                        <option>4</option>
                                                        <option>5</option>
                                                        <option>6</option>
                                                        <option>7</option>
                                                        <option>8</option>
                                                        <option>9</option>
                                                        <option>10</option>
                                                        <option>11</option>
                                                        <option>12</option>
                                                </select></td>
                                        <td><input ID="query" type="button" value="计算" class="btn btn-default" /></td>
                                        <td>
                                            <input ID="export" type=button value="导出" class="btn btn-default" />
                                        </td>
                                                                                <td>
                                            <input ID="import" type=button value="导入请假" class="btn btn-default" />
                                        </td>
                                                                                                                        <td>
                                            <input ID="import-cost" type=button value="导入直接人工成本" class="btn btn-default" />
                                        </td>


                                </tr>
                        </table>
                </div>
                <hr>
                <div>
                <table id="jqGrid">
                </table>
                <div id="jqGridPager"></div>
                </div>
        </div>
</form>
        
                        <div id="portdiv" style="display: none" title="">
                       <form runat="server">
                        <table>
                        <tr>
                                <td><label>年份</label></td>
                                <td><select id="myear" class="form-control" runat=server>
                                <option>2017</option>
                                                        <option>2018</option>
                                                        <option>2019</option>
                                                        <option>2020</option>
                                                        <option>2021</option>
                                                        <option>2022</option>
                                                        <option>2023</option>
                                                        <option>2024</option>
                                                        <option>2025</option>
                                                </select></td>
                                <td><label>月份</label></td>
                                <td><select id="mmonth" class="form-control" runat=server>
                                <option>1</option>
                                                        <option>2</option>
                                                        <option>3</option>
                                                        <option>4</option>
                                                        <option>5</option>
                                                        <option>6</option>
                                                        <option>7</option>
                                                        <option>8</option>
                                                        <option>9</option>
                                                        <option>10</option>
                                                        <option>11</option>
                                                        <option>12</option>
                                    </select></td>
                        </tr>
                        </table>
                                                       <table><tbody>
                                                        <tr id="import-tr">
                                        <td><a href="javascript:;" class="a-upload">
                                                <input id="file" type="file" runat="server" />
                                                选择文件 </a></td>
                                        <td><label id="filename" class="showFileName"></label>
                                                <label class="fileerrorTip">未选择导入文件</label></td>
                                </tr>
</tbody></table>
                        <hr />
                        <asp:Button ID="importC" runat="server" Text="确认导入" style="float:right" class="btn btn-default" OnClick="importC_Click" />
                        <asp:Button ID="exportC" runat="server" Text="确认导出" style="float:right" class="btn btn-default" OnClick="exportC_Click" />
                           </form>
                </div>
                
                                        <div id="import-cost-div" style="display: none" title="导入">
                        <table>
                        <tr>
                                <td><label>年份</label></td>
                                <td><select id="cost-year" class="form-control">
                                                </select></td>
                                <td><label>月份</label></td>
                                <td><select id="cost-month" class="form-control">
                                <option>1</option>
                                                        <option>2</option>
                                                        <option>3</option>
                                                        <option>4</option>
                                                        <option>5</option>
                                                        <option>6</option>
                                                        <option>7</option>
                                                        <option>8</option>
                                                        <option>9</option>
                                                        <option>10</option>
                                                        <option>11</option>
                                                        <option>12</option>
                                    </select></td>
                        </tr>
                        </table>
                </div>


</body>
</html>
