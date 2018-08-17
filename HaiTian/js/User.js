 $(function () {

     var cellHeight = 26;

     var GridHeight = cellHeight * 10;

     $("#tabs").tabs();

     function initUserGrid(GridID) {

         var GridPagerID = GridID + "Pager";

         $(GridID).jqGrid({
             //url: URL,
             //editurl: 'clientArray',
             //mtype: "GET",
             datatype: "local",
             //page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
             }, {
                 label: '用户名',
                 name: 'username',
                 width: 75,
             }, {
                 label: '创建日期',
                 name: 'CreateDate',
                 width: 75,
             }, {
                 label: '创建人',
                 name: 'Creator',
                 width: 75,
             }, {
                 label: '所属角色',
                 name: 'BelongRole',
                 width: 75,
             }, {
                 label: '描述',
                 name: 'FDescription',
                 width: 75,
             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: mainGridWidth,
             height: GridHeight,
             rowNum: window.rowNum,
             pager: GridPagerID
         });

         $(GridID).navGrid(GridPagerID, {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

         jQuery(GridID).jqGrid('setFrozenColumns');

     }

     initUserGrid("#jqGrid");

     function initRoleGrid(GridID) {

         var Grid = $(GridID)

         var GridPagerID = GridID + "Pager";

         Grid.jqGrid({
             //url: URL,
             //editurl: 'clientArray',
             //mtype: "GET",
             //datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
                 frozen: true
             }, {
                 label: '角色名',
                 name: 'rolename',
                 width: 75,
             }, {
                 label: '创建人',
                 name: 'Creator',
                 width: 75,
             }, {
                 label: '创建日期',
                 name: 'CreateDate',
                 width: 75,
             }, {
                 label: '备注',
                 name: 'remark',
                 width: 75,
             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: mainGridWidth,
             height: GridHeight,
             rowNum: window.rowNum,
             pager: GridPagerID
         });

         Grid.navGrid(GridPagerID, {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

         Grid.jqGrid('setFrozenColumns');

     }

     initRoleGrid("#roleGrid");

     function PermissionToggle(rowid, Grid1, Grid2) {
         var rowData = Grid1.jqGrid('getRowData', rowid);

         Grid1.delRowData(rowid);
         Grid2.jqGrid('addRowData', rowid, rowData, "last");

     }


     function initPermissionWebPageGrid(GridID1, GridID2) {

         var Grid1 = $(GridID1)
         var Grid2 = $(GridID2)
         var caption

         if (GridID1 == "#notHaveGrid") {
             caption = "未有权限"
         } else {
             caption = "已有权限"
         }

         Grid1.jqGrid({
             //url: URL,
             //mtype: "GET",
             //datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden:true
             }, {
                 label: '资源类型ID',
                 name: 'ResourceTypeID',
                 width: 75,
                 hidden:true
             }, {
                 label: '资源类型',
                 name: 'ResourceType',
                 width: 75,
             }, {
                 label: '权限名称',
                 name: 'EName',
                 width: 75,
             }, {
                 label: '中文名称',
                 name: 'CName',
                 width: 75,
             },{
                 label: '所属页面',
                 name: 'Page',
                 width: 75,
             }, ],
             loadonce: true,
             viewrecords: true,
             width: Width,
             height: Height,
             rowNum: 20,
             caption: caption,
             ondblClickRow: function (rowid) {

                 PermissionToggle(rowid, Grid1, Grid2);
             },
         })

     }

     initPermissionWebPageGrid("#notHaveGrid", "#haveGrid");
     initPermissionWebPageGrid("#haveGrid", "#notHaveGrid");

     function initPermissionRptGrid(GridID) {

         var Grid = $(GridID)

         var GridPagerID = GridID + "Pager";

         Grid.jqGrid({
             //url: URL,
             //editurl: 'clientArray',
             //mtype: "GET",
             datatype: "local",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
             }, {
                 label: '角色名',
                 name: 'rolename',
                 width: 75,
             }, {
                 label: '权限',
                 name: 'EName',
                 width: 75,
             }, {
                 label: '权限名称',
                 name: 'CName',
                 width: 75,
             },
                        {
                 label: '所属页面',
                 name: 'Page',
                 width: 75,
             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: mainGridWidth,
             height: GridHeight,
             rowNum: window.rowNum,
             pager: GridPagerID
         });

         Grid.navGrid(GridPagerID, {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

         Grid.jqGrid('setFrozenColumns');

     }

     initPermissionRptGrid("#perGrid");

     $("#query").click(function () {
         var username = $("#username").val();
         var PostData = "{\"username\":\"" + username + "\"}";
         var URL = 'User.ashx?PostData=' + PostData;
         var GridID = "#jqGrid";

         $(GridID).jqGrid('clearGridData'); //清空表格


         $(GridID).jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             loadComplete: function (xhr) {},
             page: 1
         }).trigger('reloadGrid');


     })

     $("#query").click();

     $("#add").click(function () {

         $("#modal-user").prop("disabled", "");
         $("#modal-password").parent().parent().css("display", "");
         $("#modal-password-repeat").parent().parent().css("display", "");


         var obj = new Object();
         obj.id = "#dialog-modal";
         obj.Save = Save;

         $("#dialog-modal").dialog({
             width: 300,
             modal: true,
             appendTo: "form",
             buttons: {
                 "保存": function () {

                     if (!checkUserName()) {
                         return false;
                     }

                     var user = $("#modal-user").val();
                     var creator = $.cookie("Name");
                     var rolename = $("#belong-role").val();

                     var password = $("#modal-password").val();
                     var passwordRepeat = $("#modal-password-repeat").val();

                     obj.Save(1, user, creator, rolename, password, passwordRepeat);

                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     });

     $("#belong-role").click(function () {

         $("#role-button-toggle").css("display", "none")

         var Grid = $("#roleGrid")

         Grid.jqGrid('clearGridData'); //清空表格

         var strPostData = "{\"op\":\"LoadRole\",\"rolename\":\"" + "" + "\"}";

         var URL = "User.ashx?PostData=" + strPostData;

         Grid.jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             ondblClickRow: function (rowId) {

                 var rowId = Grid.jqGrid('getGridParam', 'selrow');

                 var rowData = Grid.jqGrid('getRowData', rowId);

                 var rolename = rowData.rolename;

                 $("#belong-role").val(rolename)
                 $("#role-button-toggle").css("display", "")
                 $("#role-div").dialog("destroy");
             },
             page: 1
         }).trigger('reloadGrid');


         $("#role-div").dialog({
             width: 1000,
             modal: true,
             zIndex: 1300, //不起作用
             close: function (event, ui) {
                     $(this).dialog("destroy");
                     $("#role-button-toggle").css("display", "")
                 } //关闭事件的回调函数
         });

     })


     $("#edit-password").click(function () {

         var rowId = $('#jqGrid').jqGrid('getGridParam', 'selrow');
         if (rowId === null) {
             $("#msg").text("请选择数据！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }

         var rowData = $("#jqGrid").jqGrid('getRowData', rowId);

         $("#user-edit").val(rowData.username);

         var obj = new Object();
         obj.id = "#edit-modal";
         obj.Save = Save;

         $("#edit-modal").dialog({
             width: 300,
             modal: true,
             buttons: {
                 "保存": function () {

                     var user = $("#user-edit").val();
                     var password = $("#password-edit").val();
                     var passwordRepeat = $("#password-repeat-edit").val();

                     obj.Save(2, user, undefined, undefined, password, passwordRepeat);

                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     });


     $("#delete").click(function () {

         var rowId = $('#jqGrid').jqGrid('getGridParam', 'selrow');
         if (rowId === null) {
             $("#msg").text("请选择数据！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }

         var rowData = $("#jqGrid").jqGrid('getRowData', rowId);

         if (rowData.username.toLowerCase() === "administrator") {
             $("#msg").text("系统内置账号不允许删除！");
             myAlert('', 0, 0);
             return false;
         }

         var id = rowData.id;

         $("#msg-tip").text("确认要删除吗！");

         $("#alert-tip").dialog({
             height: 145,
             modal: true,
             zIndex: 1300, //不起作用
             buttons: {
                 "确认": function () {

                     var PostData = "{\"op\":\"" + 0 + "\",\"id\":\"" + id + "\"}";

                     $.ajax({
                         type: "Post",
                         url: "OPUserData.ashx?PostData=" + PostData,
                         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                         //dataType: "json", //预期的服务器响应的数据类型
                         success: function (data) {

                             var obj = eval('(' + data + ')');

                             if (obj.status === 100) {
                                 $("#msg").text("删除成功！");

                             } else {
                                 $("#msg").text("删除失败！" + obj.msg);

                             }
                             $("#alert").dialog({
                                 modal: true,
                                 height: 90
                             });

                             $("#query").click();

                         },
                         error: function (xhr, status, error) {
                             return [false, 'You can not submit!'];
                         },
                         complete: function (data) {
                             //alert(data.responseText)
                         }
                     });

                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });

     });

     function initWiseUserGrid() {
         var Grid = $("#userGrid")
         var Modal = $("#user-modal")

         $("#userGrid").jqGrid({
             //url: 'User.ashx?PostData=' + PostData,
             //editurl: 'clientArray',
             mtype: "GET",
             datatype: "local",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
             }, {
                 label: '用户名',
                 name: 'FName',
                 width: 75
             }, {
                 label: '描述',
                 name: 'FDescription',
                 width: 75,

             }],
             ondblClickRow: function (rowId) {

                 var arr = [];
                 var obj1 = {};
                 obj1.text = "#modal-user"
                 obj1.col = "FName"
                 arr.push(obj1);

                 ondblClickRowFun(Grid, rowId, Modal, arr);
             },
             loadonce: true,
             viewrecords: true,
             width: 600,
             height: Height,
             rowNum: 50,
             pager: "#userGridPager"
         });

         $("#userGrid").navGrid("#userGridPager", {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

     }
     initWiseUserGrid();

     $("#modal-user").click(function () {

         $("#query-user").click(function () {
             var user = $("#input-user").val();
             var PostData = "{\"op\":\"GetUser\",\"username\":\"" + user + "\"}";

             $('#userGrid').jqGrid('setGridParam', {
                 url: 'User.ashx?PostData=' + PostData,
                 datatype: 'json',
                 page: 1
             }).trigger('reloadGrid');

         })

         $("#user-modal").dialog({
             width: 700,
             modal: true,
             zIndex: 1300, //不起作用
             buttons: {
                 "确认": function () {

                     var rowId = $('#userGrid').jqGrid('getGridParam', 'selrow');
                     var rowData = $("#userGrid").jqGrid('getRowData', rowId);
                     $("#modal-user").val(rowData.FName);

                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });

     })

     $("#query-role").click(function () {
         var rolename = $("#rolename").val();
         var PostData = "{\"op\":\"LoadRole\",\"rolename\":\"" + rolename + "\"}";
         var URL = 'User.ashx?PostData=' + PostData;
         var Grid = $("#roleGrid");

         Grid.jqGrid('clearGridData'); //清空表格


         Grid.jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             page: 1
         }).trigger('reloadGrid');


     })


     $("#role-add").click(function () {

         if (!checkUserName()) {
             return false;
         }
         $("#DoubleGrid").appendTo($("#role-modal"))


         $("#role-creator").val($.cookie("Name"));

         $("#role-name").prop("disabled", "");

         $("#role-name").val("");
         $("#role-remark").val("");
         $("#role-createdate").val(getDateToday());

         var PostData = "{\"op\":\"LoadPlugResource\"}";
         var URL = 'User.ashx?PostData=' + PostData;
         var Grid1 = $("#notHaveGrid");
         var Grid2 = $("#haveGrid");

         Grid1.jqGrid('clearGridData'); //清空表格

         Grid2.jqGrid('clearGridData'); //清空表格

         Grid1.jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             loadComplete: function (xhr) {},
             page: 1
         }).trigger('reloadGrid');


         $("#role-modal").dialog({
             width: roleDialogWidth,
             title: "",
             modal: true,
             appendTo: "form", //涉及到 z-index
             buttons: {
                 "保存": function () {

                     var rolename = $("#role-name").val();
                     SaveRole("AddRole", rolename);

                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     })

     $("#role-edit").click(function () {

         EditRole("EditRole");


     })

     $("#role-delete").click(function () {

         var Grid
         Grid = $('#roleGrid');


         var rowId = Grid.jqGrid('getGridParam', 'selrow');
         var msg
         if (rowId === null) {
             msg = "请选择数据！";
             myAlert(msg);
             return false;
         }

         var rowData = Grid.jqGrid('getRowData', rowId);
         var rolename = rowData.rolename;

         $("#con-msg").text("确定要删除角色" + rolename + "吗?");
         $("#con").dialog({
             modal: true,
             height: 130
         });

         $("#confirm").off();
         $("#confirm").on("click", function () {
             $("#con").dialog("close");
             Delete(rolename);
         });


     })

     $("#change-role").click(function () {

         var Grid
         Grid = $('#jqGrid');


         var rowId = Grid.jqGrid('getGridParam', 'selrow');
         var msg
         if (rowId === null) {
             msg = "请选择数据！";
             myAlert(msg);
             return false;
         }

         var rowData = Grid.jqGrid('getRowData', rowId);
         var username = rowData.username;
         var BelongRole = rowData.BelongRole;

         if (username.toLowerCase() === "administrator") {
             msg = "系统账号不允许修改！";
             myAlert(msg);

             return false; //管理员拥有无限制的权限
         }

         $("#modal-user").prop("disabled", "disabled");
         $("#modal-password").parent().parent().css("display", "none");
         $("#modal-password-repeat").parent().parent().css("display", "none");

         $("#modal-user").val(username);

         $("#belong-role").val(BelongRole);

         $("#dialog-modal").dialog({
             width: 300,
             modal: true,
             appendTo: "form", //涉及到ZIndex
             buttons: {
                 "保存": function () {


                     var user = $("#modal-user").val();
                     var rolename = $("#belong-role").val();

                     var strPostData = "{\"op\":\"ChangeRole\",\"username\":\"" + user + "\",\"rolename\":\"" + rolename + "\"}";
                     var PostData = {
                         "PostData": strPostData
                     }

                     $.ajax({
                         type: "Post",
                         url: "User.ashx",
                         data: PostData,
                         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                         //dataType: "json", //预期的服务器响应的数据类型
                         success: function (data) {

                             var obj = eval('(' + data + ')');

                             var msg
                             if (obj.status === 100) {
                                 msg = "操作成功！";

                             } else {
                                 msg = "操作失败！" + obj.msg;

                             }
                             myAlert(msg);
                             $("#query").click();

                         },
                         error: function (xhr, status, error) {
                             alertAjaxError();
                         },
                         complete: function (data) {}
                     })

                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     })

     function Delete(rolename) {

         var strPostData = "{\"op\":\"DeteleRole\",\"rolename\":\"" + rolename + "\"}";
         var PostData = {
             "PostData": strPostData
         }

         $.ajax({
             type: "Post",
             url: "User.ashx",
             data: PostData,
             //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
             //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
             //dataType: "json", //预期的服务器响应的数据类型
             success: function (data) {

                 var obj = eval('(' + data + ')');

                 var msg
                 if (obj.status === 100) {
                     msg = "删除成功！";

                 } else {
                     msg = "删除失败！" + obj.msg;

                 }
                 myAlert(msg);
                 $("#query-role").click();

             },
             error: function (xhr, status, error) {
                 alertAjaxError();
             },
             complete: function (data) {}
         })


     }

     $("#query-permission").click(function () {
         var rolename = $("#permission-rolename").val();
         var PostData = "{\"op\":\"LoadRolePermission\",\"rolename\":\"" + rolename + "\"}";
         var URL = 'User.ashx?PostData=' + PostData;
         var Grid = $("#perGrid");

         Grid.jqGrid('clearGridData'); //清空表格


         Grid.jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             loadComplete: function (xhr) {},
             page: 1
         }).trigger('reloadGrid');


     })

     $("#permission-edit").click(function () {

         EditRole("EditPermission");
     })
     
          function initPermissionResourceGrid(GridID) {

         var Grid = $(GridID)

         var GridPagerID = GridID + "Pager";

         Grid.jqGrid({
             //url: URL,
             //editurl: 'clientArray',
             //mtype: "GET",
             datatype: "local",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden:true
             }, {
                 label: '资源类型ID',
                 name: 'ResourceTypeID',
                 width: 75,
                 hidden:true
             }, {
                 label: '资源类型',
                 name: 'ResourceType',
                 width: 75,
             }, {
                 label: '权限名称',
                 name: 'EName',
                 width: 75,
             }, {
                 label: '中文名称',
                 name: 'CName',
                 width: 75,
             },{
                 label: '所属页面',
                 name: 'Page',
                 width: 75,
             }, ],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: mainGridWidth,
             height: GridHeight,
             rowNum: window.rowNum,
             pager: GridPagerID
         });

         Grid.navGrid(GridPagerID, {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

         Grid.jqGrid('setFrozenColumns');

     }

     initPermissionResourceGrid("#funGrid");

     
          $("#query-function").click(function () {
         var PostData = "{\"op\":\"LoadPlugResource\"}";
         var URL = 'User.ashx?PostData=' + PostData;
         var Grid = $("#funGrid");

         Grid.jqGrid('clearGridData'); //清空表格

         Grid.jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             loadComplete: function (xhr) {},
             page: 1
         }).trigger('reloadGrid');

     })


 })

 var Width = 500
 var mainGridWidth = 900
 var roleDialogWidth = Width * 2 + 50
 var Height = cellHeight * 10 + scrollWidth //26*10+17


 function SaveRole(op, rolename) {
     var Grid2 = $("#haveGrid")
     var remark = $("#role-remark").val();
     var creator = $("#role-creator").val();

     var arr = new Array();

     var Grid2Data = Grid2.jqGrid("getRowData");

     if (rolename === "" || rolename === undefined || rolename === null) {
         var msg = "角色名不能为空！";

         myAlert(msg);
         return false;
     }

     if (Grid2Data.length === 0) {
         $("#msg").text("请至少选择一个权限！");
         myAlert();
         return false;
     }

     showProgressModal("保存中"); //显示进度条


     for (var i = 0; i < Grid2Data.length; i++) {
         var obj = new Object();

         var ret = Grid2Data[i];

         obj.id = ret.id;
         obj.ResourceTypeID = ret.ResourceTypeID;
         arr.push(obj);
     }

     switch (op) {
         case "EditPermission":
             var strPostData = "{\"op\":\"" + op + "\",\"rolename\":\"" + rolename + "\",\"rows\":" + JSON.stringify(arr) + "}";
             var dialog = $("#per-modal");

             break;
         case "EditRole":
             var strPostData = "{\"op\":\"" + op + "\",\"rolename\":\"" + rolename + "\",\"remark\":\"" + remark + "\",\"rows\":" + JSON.stringify(arr) + "}";
             var dialog = $("#role-modal");

             break;
         case "AddRole":
             var strPostData = "{\"op\":\"" + op + "\",\"rolename\":\"" + rolename + "\",\"remark\":\"" + remark + "\",\"creator\":\"" + creator + "\",\"rows\":" + JSON.stringify(arr) + "}";
             var dialog = $("#role-modal");

             break;

     }

     var PostData = {
         "PostData": strPostData
     }

     $.ajax({
         type: "Post",
         url: "User.ashx",
         data: PostData,
         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
         //dataType: "json", //预期的服务器响应的数据类型
         success: function (data) {

             var obj = eval('(' + data + ')');

             if (obj.status === 100) {
                 $("#msg").text("操作成功！");
                 dialog.dialog("destroy");

             } else {
                 $("#msg").text("操作失败！" + obj.msg);

             }
             myAlert();
             $("#query-role").click();
             $("#query-permission").click();

         },
         error: function (xhr, status, error) {
             alertAjaxError();
         },
         complete: function (data) {
             //alert(data.responseText)
             closeProgressModal();
         }
     })

 }

 function EditRole(op) {
     var Grid
     if (op === "EditRole") {
         $("#DoubleGrid").appendTo($("#role-modal"))
         Grid = $('#roleGrid');

     } else {
         $("#DoubleGrid").appendTo($("#per-modal"))
         Grid = $('#perGrid');

     }


     var rowId = Grid.jqGrid('getGridParam', 'selrow');
     if (rowId === null) {
         $("#msg").text("请选择数据！");
         myAlert();
         return false;
     }

     var rowData = Grid.jqGrid('getRowData', rowId);

     if (op === "EditRole") {
         $("#role-name").prop("disabled", "disabled");

         $("#role-name").val(rowData.rolename);
         $("#role-remark").val(rowData.remark);
         $("#role-creator").val(rowData.Creator);
         $("#role-createdate").val(rowData.CreateDate);

     }


     var title = rowData.rolename;

     var rolename = rowData.rolename;
     var strPostData = "{\"op\":\"LoadRoleBothPermission\",\"rolename\":\"" + rolename + "\"}";
     var PostData = {
         "PostData": strPostData
     }

     var Grid1 = $("#notHaveGrid");
     var Grid2 = $("#haveGrid");

     Grid1.jqGrid('clearGridData'); //清空表格

     Grid2.jqGrid('clearGridData'); //清空表格

     $.ajax({
         type: "Post",
         url: "User.ashx",
         data: PostData,
         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
         //dataType: "json", //预期的服务器响应的数据类型
         success: function (data) {

             var obj = eval('(' + data + ')');
             var arr1 = [];
             var arr2 = [];

             if (obj[0] !== undefined) {
                 for (var i = 0; i < obj[0].rows.length; i++) {
                     var data1 = {};
                     var rows = obj[0].rows[i];
                                   data1.id = rows.cell[0];
                 data1.ResourceTypeID = rows.cell[1];   
                 data1.ResourceType = rows.cell[2];
                 data1.EName = rows.cell[3];
                 data1.CName = rows.cell[4];
                 data1.Page = rows.cell[5];
                     arr1.push(data1);
                 }

             }

             for (var i = 0; i < obj[1].rows.length; i++) {
                 var data2 = {};
                 var rows = obj[1].rows[i];
                                                    data2.id = rows.cell[0];
                 data2.ResourceTypeID = rows.cell[1];

                 data2.ResourceType = rows.cell[2];
                 data2.EName = rows.cell[3];
                 data2.CName = rows.cell[4];
                 data2.Page = rows.cell[5];
                 arr2.push(data2);
             }


             Grid1.jqGrid('setGridParam', {
                 data: arr1,
                 datatype: 'local',
                 page: 1
             }).trigger('reloadGrid')

             Grid2.jqGrid('setGridParam', {
                 data: arr2,
                 datatype: 'local',
                 page: 1
             }).trigger('reloadGrid')

             var modal
             if (op === "EditRole") {
                 modal = $("#role-modal")
             } else {
                 modal = $("#per-modal")
             }


             modal.dialog({
                 width: roleDialogWidth,
                 title: title,
                 modal: true,
                 buttons: {
                     "保存": function () {
                         SaveRole(op, rolename);


                     },
                     取消: function () {
                         $(this).dialog("close");
                     }
                 }
             })

         },
         error: function (xhr, status, error) {
             alertAjaxError();
         },
         complete: function (data) {
             //alert(data.responseText)
         }
     })

 }