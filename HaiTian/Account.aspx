<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Account.aspx.cs" Inherits="Account" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
   <meta name="name" content="a">
    <title></title>
<%--    <link rel="stylesheet" href="js/jquery-ui-1.9.2.custom/css/smoothness/jquery-ui-1.9.2.custom.css">--%>
    <link rel="stylesheet" href="jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
    <script src="jquery/jquery-1.11.3/jquery.js"></script>
    <script src="jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<%--    <script src="js/jquery-ui-1.9.2.custom/js/jquery-ui-1.9.2.custom.js"></script>--%>
    <script src="Guriddo_jqGrid_JS_5.2.1/src/i18n/grid.locale-cn.js"></script>
    <script src="Guriddo_jqGrid_JS_5.2.1/js/jquery.jqGrid.min.js"></script>
    <link rel="stylesheet" href="Guriddo_jqGrid_JS_5.2.1/css/ui.jqgrid.css" />
    <script type="text/javascript" src="My97DatePicker/WdatePicker.js"></script>
<%--    <script type="text/javascript" src="js/jquery-ui-1.9.2.custom/development-bundle/ui/jquery.ui.datepicker.js"></script>--%>
<%--    <link rel="stylesheet" href="js/jquery-ui-1.9.2.custom/development-bundle/themes/smoothness/jquery-ui.css" />--%>
<%--    <link rel="stylesheet" href="js/jquery-ui-1.9.2.custom/development-bundle/themes/smoothness/jquery.ui.theme.css" />--%>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
    <link rel="stylesheet" href="css/HaiTian.css" />
    <script src="js/public.js"></script>
    <script src="js/Account.js"></script>

<script>

</script>
</head>
<body>
    <form id="form1" runat="server">

        <h1 style="text-align: center">薪资期间管理</h1>

    <div>
    <div>

        <table id="header">
            <tr>
                <td >年份</td>
                <td >
                    <select id="select_year" class="form-control" runat="server">
                        <option Value="">请选择</option>
                        <option Value="2017">2017</option>
                        <option Value="2018">2018</option>
                        <option Value="2019">2019</option>
                        <option Value="2020">2020</option>
                        <option Value="2021">2021</option>
                        <option Value="2022">2022</option>
                        <option Value="2023">2023</option>
                        <option Value="2024">2024</option>
                        <option Value="2025">2025</option>
                    </select>

                </td>
                
                <td >月份</td>
                <td >
                    <asp:DropDownList id="select_mon" class="form-control" runat="server">
                        <asp:ListItem Value="">请选择</asp:ListItem>
                        <asp:ListItem Value="1">1</asp:ListItem>
                        <asp:ListItem Value="2">2</asp:ListItem>
                        <asp:ListItem Value="3">3</asp:ListItem>
                        <asp:ListItem Value="4">4</asp:ListItem>
                        <asp:ListItem Value="5">5</asp:ListItem>
                        <asp:ListItem Value="6">6</asp:ListItem>
                        <asp:ListItem Value="7">7</asp:ListItem>
                        <asp:ListItem Value="8">8</asp:ListItem>
                        <asp:ListItem Value="9">9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                        <asp:ListItem Value="11">11</asp:ListItem>
                        <asp:ListItem Value="12">12</asp:ListItem>
                    </asp:DropDownList>
                </td>

                <td>状态</td>
                <td>
                    <select id="S" class="form-control">
                        <option value="">请选择</option>
                        <option value="1">开账</option>
                        <option value="0">关账</option>
                    </select>
                </td>
                <td>
                    <input ID="query" type="button" value="查询" class="btn btn-default" />
                </td>
            </tr>
    </table>

</div>


        <div class="btn-group">
        <input ID="switch" type="button" value="开关账" class="btn btn-default" />

        </div>

        <table id="jqGrid"></table>
        <div id="jqGridPager"></div>

    </div>
    </form>

    <div style="display: none" id="dialog-modal" title="开关账">
        <table>
        <tr>
            <td>
            <label for="year">选择年份</label>
            <select name="year" id="year" class="myModal select">
                <option>2017</option>
                <option>2018</option>
                <option>2019</option>
                <option>2020</option>
                <option>2021</option>
                <option>2022</option>
                <option>2023</option>
                <option>2024</option>
                <option>2025</option>
            </select>
            <label for="month">选择月份</label>
            <select name="month" id="month" class="myModal select">
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
            </select>
                </td>
        </tr>
        <tr>
            <td>
            <label for="m_switch">选择开关</label>
            <select name="m_switch" id="m_switch" class="myModal select">
                <option value="1">开账</option>
                <option value="0">关账</option>
            </select>
            </td>
        </tr>
            </table>
    </div>
    <div style="display: none" id="bill-modal" title="单据">
        <div>
               <b><p>存在未提交或未审核的单据！</p></b>
                
        </div>
        <hr>
        <table id="billGrid">
        </table>
        <div id="billGridPager"></div>
</div>

</body>
</html>
