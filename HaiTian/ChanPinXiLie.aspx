<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChanPinXiLie.aspx.cs" Inherits="ChanPinXiLie" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="name" content="cpxl">
<title></title>

<!--[if lt IE 9]>

    <script src="jquery/jquery-1.8.3.js"
            integrity="sha256-dW19+sSjW7V1Q/Z3KD1saC6NcE5TUIhLJzJbrdKzxKc="
            crossorigin="anonymous"></script>

    <![endif]-->
<!--[if gte IE 9]><!-->

<script src="jquery/jquery-1.11.3/jquery.js"></script>

<!--<![endif]-->

<link rel="stylesheet" href="jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<script src="jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>

<!--[if lt IE 9]>

            <script src="jquery.jqGrid-4.4.3/js/i18n/grid.locale-cn.js"></script>
    <script src="jquery.jqGrid-4.4.3/js/jquery.jqGrid.min.js"></script>
    <link rel="stylesheet" href="jquery.jqGrid-4.4.3/css/ui.jqgrid.css" />

    <![endif]-->
<!--[if gte IE 9]><!-->

<script src="Guriddo_jqGrid_JS_5.2.1/src/i18n/grid.locale-cn.js"></script>
<script src="Guriddo_jqGrid_JS_5.2.1/js/jquery.jqGrid.min.js"></script>
<link rel="stylesheet" href="Guriddo_jqGrid_JS_5.2.1/css/ui.jqgrid.css" />

<!--<![endif]-->

<script type="text/javascript" src="My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="css/HaiTian.css" />
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script src="js/public.js"></script>
<script src="js/CPXL.js"></script>
<script src="js/jszip.min.js"></script>
<script>
</script>
</head>
<body>
<form id="form1">
        <h1 style="text-align: center">产品系列</h1>
            <div id="tabs">
                <ul>
                        
                        <li><a href="#tabs-production">成品物料维护</a></li>
                        <li><a href="#tabs-supplier">供应商维护</a></li>

                </ul>
                <div id="tabs-production">
                                <div>
                        <table class="header">
                                <tr>
                                        <td>产品系列</td>
                                        <td><input ID="cpxl-prd-cpxl" class="form-control" /></td>
                                        <td><input type="button" ID="cpxl-prd-query" value="查询" class="btn btn-default" /></td>
                                </tr>
                        </table>
                </div>
                               <hr/>
                                <div>
                        <input type="button" id="cpxl-prd-add" value="新增" class="btn btn-default" />
                        <input type="button" id="cpxl-prd-edit" value="编辑" class="btn btn-default" />
                        <input type="button" id="cpxl-prd-del" value="删除" class="btn btn-default" />
                </div>
                <table id="Q-prdGrid">
                </table>
                <div id="Q-prdGridPager"></div>

                                <div style="display: none;" id="cpxl-prd-div" title="成品物料维护">
                                <input type="button" id="cpxl-prd-div-select" value="选择物料" />
                                <input type="button" id="cpxl-prd-div-del" value="删除已选" />
                                <input type="button" id="cpxl-prd-div-save" value="保存" />
                                <hr/>
                        <label>产品系列</label>
                        <input type="text" id="cpxl-prd-div-cpxl" class="form-control" readonly=true />
                        
                        <table id="E-prdGrid">
                        </table>
                        <div id="E-prdGridPager"></div>
                </div>
                
                                                <div style="display: none;" id="cpxl-prd-div-select-div" title="成品物料选择">
                        <label>成品物料</label>
                        <input type="text" id="cpxl-prd-div-select-prd-txt" class="form-control" >
                        <input type="button" ID="cpxl-prd-div-select-query" value="查询" class="btn btn-default" />
                        <input type="button" ID="cpxl-prd-div-select-return" value="返回数据" class="btn btn-default" />
                        <table id="prdGrid">
                        </table>
                        <div id="prdGridPager"></div>
                </div>



                </div>
                <div id="tabs-supplier">
                        <div>
                <div>
                        <table class="header">
                                <tr>
                                        <td>产品系列</td>
                                        <td><input ID="cpxl" class="form-control" /></td>
                                        <td>供应商</td>
                                        <td><input ID="sup" class="form-control" /></td>
                                        <td><input type="button" ID="query" value="查询" class="btn btn-default" /></td>
                                </tr>
                        </table>
                </div>
                <hr/>
                <div>
                        <input type="button" id="add" value="新增" class="btn btn-default" />
                        <input type="button" id="edit" value="编辑" class="btn btn-default" />
                        <input ID="import" type="button" value="导入" class="btn btn-default" />
                        <input ID="review" type="button" value="审核" class="btn btn-default" disabled="disabled" />
                        <input ID="cancel-review" type="button" value="反审核" class="btn btn-default" disabled="disabled" />
                        <input ID="change-sup" type="button" value="供应商更换" class="btn btn-default" />
                        <input ID="cpxl-sup-del" type="button" value="删除" class="btn btn-default" />
                </div>
                <table id="jqGrid">
                </table>
                <div id="jqGridPager"></div>
                <div style="display: none;" id="dialog-modal" title="产品系列">
                        <label>产品系列</label>
                        <input type="text" id="modal-cpxl" class="form-control" readonly >
                        <input type="button" value="展开物料" id="expand">
                        <input type="button" value="导出" id="export">
                        <hr>
                        <table id="modalGrid">
                        </table>
                        <div id="modalGridPager"></div>
                </div>
                <div style="display: none;" id="cpxl-modal" title="产品系列">
                        <label>产品系列</label>
                        <input type="text" id="entry-entry-cpxl" class="form-control" >
                        <input type="button" value="查询" id="query-cpxl">
                        <hr>
                        <table id="cpxlGrid">
                        </table>
                        <div id="cpxlGridPager"></div>
                </div>
                <div style="display: none" id="sup-modal" title="供应商">
                        <div>
                                <label>供应商</label>
                                <input id="entry-entry-sup" class="form-control">
                                <input type="button" value="查询" id="query-sup">
                        </div>
                        <hr>
                        <table id="supGrid">
                        </table>
                        <div id="supGridPager"></div>
                </div>
                <div style="display: none" id="div-change-sup" title="供应商更换">
                       <table>
                           <tbody>
                               <tr>
                                   <td><input type="button" value="选择系列" id="div-change-sup-btn-select-cpxl" /></td>
                                   <td><input type="button" value="清空已选" id="div-change-sup-btn-clear-selected" /></td>
                               </tr>
                               <tr>
                                                                      <td><label>已选择的系列</label></td>
                                   <td>
                                   <textarea disabled=disabled id="div-change-sup-textarea-cpxl" ></textarea>
                                   <input type=text style="display: none" id="div-change-sup-txt-cpxl" />
                                   
                                   </td>

                               </tr>
                                <tr>
                                   
                               </tr>
                           </tbody>
                       </table>
                       <hr/>
                       
                        <div>
                                <label>要更换的供应商</label>
                                <input id="change-sup-old-num" class="form-control" readonly=true>
                                <input id="change-sup-old-name" class="form-control" disabled=disabled>
                        </div>
                        <div>
                                <label>更换后的供应商</label>
                                <input id="change-sup-new-num" class="form-control" readonly=true>
                                <input id="change-sup-new-name" class="form-control" disabled=disabled>
                        </div>
                </div>
        </div>
                </div>
                
                                
                                                

        </div>

        
</form>
<div id="importdiv" style="display: none" title="导入">
        <form runat="server">
                <table>
                        <tr>
                                <td><a href="javascript:;" class="a-upload">
                                        <input  id="ImportFile" type="file" runat=server />
                                        选择文件 </a></td>
                                <td><label id="filename" class="showFileName"></label>
                                        <label class="fileerrorTip">未选择导入文件</label></td>
                        </tr>
                </table>
                <hr />
                <!--异步方式适用于多数新版浏览器，但不支持IE9及以下版本，ASP方式适用于IE9及以下版本--> 
                <!--<asp:Button runat="server" ID="importC" text="确认导入ASP.NET方式" style="float:right" class="btn btn-default" OnClick="importC_Click" />-->
                <input type="button" ID="importConfirm" value="确认导入" style="float:right" class="btn btn-default" />
        </form>
</div>
</body>
</html>