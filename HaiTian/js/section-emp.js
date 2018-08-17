 $(function () {


     var date = new Date();
     var year = date.getFullYear();
     var month = date.getMonth() + 1;
     $("#year").val(year);
     $("#month").val(month);
     $("#new-year").val(year);
     $("#new-month").val(month);


     function LoadGridData(GridID, URL) {

         var GridPagerID = GridID + "Pager";

         $(GridID).jqGrid({
             url: URL,
             //editurl: 'clientArray',
             mtype: "GET",
             datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
                 frozen: true
             }, {
                 label: '年',
                 name: 'year',
                 width: 100,
             }, {
                 label: '月',
                 name: 'month',
                 width: 75,
                 frozen: true
             }, {
                 label: '工段代码',
                 name: 'section',
                 width: 75
             }, {
                 label: '工段名称',
                 name: 'sectionname',
                 width: 75
             }, {
                 label: '职员代码',
                 name: 'emp',
                 width: 100,

             }, {
                 label: '职员姓名',
                 name: 'empname',
                 width: 75
             }, {
                 label: '比例',
                 name: 'rate',
                 width: 75,

             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: 900,
             height: window.GridHeight,
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

         $(GridID).jqGrid('clearGridData'); //清空表格


         $(GridID).jqGrid('setGridParam', {
             url: URL,
             datatype: 'json',
             loadComplete: function (xhr) {
                 var rowNum = parseInt($(this).getGridParam("records"), 10);
                 if (rowNum <= 0) {
                     alert("没有符合条件的记录！");
                 }
             },
             page: 1
         }).trigger('reloadGrid');
     }


     $("#query").click(function () {
         var y = $("#year").val();
         var m = $("#month").val();
         var section = $("#section").val();
         var url = 'LoadSectionEmpMapData.ashx?y=' + y + '&m=' + m + '&section=' + section;

         LoadGridData("#jqGrid", url);

     });

     $("#query").click();

     $("#section,#modal-section").click(function () {

         var ThisID = $(this).prop("id");
         ThisID = "#" + ThisID;
         $("#query-section").click();

         $("#section-modal").dialog({
             width: 600,
             modal: true,
             //height:500,
             buttons: {
                 "确认": function () {

                     var rowId = $('#sectionGrid').jqGrid('getGridParam', 'selrow');
                     var rowData = $("#sectionGrid").jqGrid('getRowData', rowId);
                     $(ThisID).val(rowData.FNumber);
                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });

     });


     function InitSectionGrid(GridID) {

         var sectionGrid = $(GridID)
         var GridPagerID = GridID + "Pager";

         var input_section = $("#input-section").val();
         var URL = 'GetSection.ashx?section=' + input_section;

         sectionGrid.jqGrid({
             url: URL,
             mtype: "GET",
             datatype: 'json',
             colModel: [{
                 label: 'ID',
                 name: 'ID',
                 width: 75,
                 key: true,
                 hidden: true
             }, {
                 label: '工序代码',
                 name: 'FNumber',
                 width: 75
             }, {
                 label: '工序名称',
                 name: 'FName',
                 width: 75,

             }, ],
             viewrecords: true,
             width: 580,
             height: 300,
             rowNum: 50,
             pager: GridPagerID
         });

         sectionGrid.navGrid(GridPagerID, {
             edit: false,
             add: false,
             del: false,
             search: false,
             refresh: false,
             view: false,
             align: "left"
         });

     }

     InitSectionGrid("#sectionGrid");

     $("#query-section").click(function () {
         var input_section = $("#input-section").val();
         var sectionGrid = $("#sectionGrid");
         var URL = 'GetSection.ashx?section=' + input_section;
         sectionGrid.jqGrid('clearGridData');
         sectionGrid.jqGrid('setGridParam', {
             url: URL,
         }).trigger('reloadGrid')

     })

     $("#add").click(function () {

         $("#modal-year").val($("#year").val());
         $("#modal-month").val($("#month").val());
         $("#modal-section").val();


         var GridID = "#dialogGrid";
         var GridPagerID = GridID + "Pager";

         $(GridID).jqGrid({
             //url: URL,
             //editurl: 'clientArray',
             mtype: "GET",
             datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
                 frozen: true
             }, {
                 label: '职员',
                 name: 'emp',
                 width: 100,

             }, {
                 label: '职员姓名',
                 name: 'empname',
                 width: 100,

             }, {
                 label: '比例',
                 name: 'rate',
                 width: 75,
                 formatter: "number"

             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: 700,
             height: 300,
             rowNum: 10,
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

         $(GridID).jqGrid('clearGridData'); //清空表格


         $("#dialog-modal").dialog({
             width: 800,
             modal: true,
             buttons: {
                 "保存": function () {

                     Save();

                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     });

     $("#edit").click(function () {

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

         $("#modal-section").val(rowData.section);
         $("#modal-year").val(rowData.year);
         $("#modal-month").val(rowData.month);


         var y = $("#modal-year").val();
         var m = $("#modal-month").val();
         var section = $("#modal-section").val();
         var url = 'LoadSectionEmpMapDataEntry.ashx?y=' + y + '&m=' + m + '&section=' + section;

         var GridID = "#dialogGrid";
         var GridPagerID = GridID + "Pager";

         $(GridID).jqGrid({
             url: url,
             //editurl: 'clientArray',
             mtype: "GET",
             datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
                 frozen: true
             }, {
                 label: '职员',
                 name: 'emp',
                 width: 100,

             }, {
                 label: '职员姓名',
                 name: 'empname',
                 width: 100,

             }, {
                 label: '比例',
                 name: 'rate',
                 width: 75,
                 formatter: "number"

             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: 700,
             height: 300,
             rowNum: 10,
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


         $(GridID).jqGrid('clearGridData'); //清空表格


         $(GridID).jqGrid('setGridParam', {
             url: url,
             datatype: 'json',
             loadComplete: function (xhr) {
                 var rowNum = parseInt($(this).getGridParam("records"), 10);
                 if (rowNum <= 0) {
                     alert("没有符合条件的记录！");
                 }
             },
             page: 1
         }).trigger('reloadGrid');


         $("#dialog-modal").dialog({
             width: 800,
             modal: true,
             buttons: {
                 "保存": function () {

                     Save();

                     $(this).dialog("close");
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

         var y = rowData.year;
         var m = rowData.month;
         var section = rowData.section;

         $("#msg-tip").text("确认要删除吗！");

         $("#alert-tip").dialog({
             height: 145,
             modal: true,
             zIndex: 1300, //不起作用
             buttons: {
                 "确认": function () {

                     var PostData = "{\"year\":\"" + y + "\",\"month\":\"" + m + "\",\"section\":\"" + section + "\"}";

                     $.ajax({
                         type: "Post",
                         url: "DeleteSectionEmpData.ashx?PostData=" + PostData,
                         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                         //dataType: "json", //预期的服务器响应的数据类型
                         success: function (data) {

                             if (data === "100") {
                                 $("#msg").text("删除成功！");

                             } else {
                                 $("#msg").text("删除失败！");

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

     $("#copy").click(function () {

         $("#old-year").val($("#year").val());
         $("#old-month").val($("#month").val());

         $("#copy-modal").dialog({
             width: 300,
             modal: true,
             buttons: {
                 "确认": function () {

                     var OldYear = $("#old-year").val();
                     var OldMonth = $("#old-month").val();
                     var NewYear = $("#new-year").val();
                     var NewMonth = $("#new-month").val();


                     var PostData = "{\"OldYear\":\"" + OldYear + "\",\"OldMonth\":\"" + OldMonth + "\",\"NewYear\":\"" + NewYear + "\",\"NewMonth\":" + NewMonth + "}";

                     $.ajax({
                         type: "Post",
                         url: "CopySectionEmpData.ashx?PostData=" + PostData,
                         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                         //dataType: "json", //预期的服务器响应的数据类型
                         success: function (data) {

                             if (data === "100") {
                                 $("#msg").text("操作成功！");

                             } else {
                                 $("#msg").text("操作失败！");

                             }
                             $("#alert").dialog({
                                 modal: true,
                                 height: 90
                             });

                             $("#copy-modal").dialog("close");
                             $("#query").click();

                             return [true, '修改成功!'];

                         },
                         error: function (xhr, status, error) {
                             return [false, 'You can not submit!'];
                         },
                         complete: function (data) { //alert(data.responseText)
                         }
                     });


                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });

         $(".select").selectmenu({
             width: 100
         });
         $('.select').selectmenu("refresh");


     });


     function Save() {

         var dialogGrid = $("#dialogGrid").jqGrid("getRowData");

         if ($("#modal-section").val() == "") {
             $("#msg").text("工段不能为空！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }
         if (dialogGrid.length == 0) {
             $("#msg").text("明细数据不能为空！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }

         var arr = new Array();

         for (var i = 0; i < dialogGrid.length; i++) {
             var ret = dialogGrid[i];
             var obj = new Object();

             if (isNaN(ret.rate) == true) {
                 $("#msg").text("比例不是数字！");
                 $("#alert").dialog({
                     modal: true,
                     height: 90
                 })
                 return false;

             }
             obj.emp = ret.emp;
             obj.rate = ret.rate;
             arr.push(obj);
         }
         var PostData = "{\"year\":\"" + $("#modal-year").val() + "\",\"month\":\"" + $("#modal-month").val() + "\",\"section\":\"" + $("#modal-section").val() + "\",\"rows\":" + JSON.stringify(arr) + "}";

         $.ajax({
             type: "Post",
             url: "OPSectionEmpData.ashx?PostData=" + PostData,
             //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
             //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
             //dataType: "json", //预期的服务器响应的数据类型
             success: function (data) {

                 if (data === "100") {
                     $("#msg").text("保存成功！");

                 } else {
                     $("#msg").text("保存失败！");

                 }
                 $("#alert").dialog({
                     modal: true,
                     height: 90
                 });

                 $("#dialog-modal").dialog("close");
                 $("#query").click();

                 return [true, '修改成功!'];

             },
             error: function (xhr, status, error) {
                 return [false, 'You can not submit!'];
             },
             complete: function (data) { //alert(data.responseText)
             }
         });
     }

     $("#modal-edit").click(function () {

         var rowId = $('#dialogGrid').jqGrid('getGridParam', 'selrow');
         if (rowId === null) {
             $("#msg").text("请选择一行数据！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }
         var rowData = $("#dialogGrid").jqGrid('getRowData', rowId);


         var billno = $("#billno").val();
         $("#entry-emp").val(rowData.emp);
         $("#entry-empname").val(rowData.empname);
         $("#entry-rate").val(rowData.rate);


         $("#entry-modal").dialog({
             width: 300,
             modal: true,
             buttons: {
                 "确认": function () {

                     var arr = new Array();
                     var obj = new Object();
                     obj.id = rowId;
                     obj.emp = $("#entry-emp").val();
                     obj.empname = $("#entry-empname").val();
                     obj.rate = $("#entry-rate").val();
                     arr.push(obj);
                     var dataRow = JSON.stringify(obj);
                     var PostData = "[{\"billno\":\"" + billno + "\",\"entryID\":" + rowData.entryID + ",\"emp\":" + rowData.emp + ",\"finishqty\":" + rowData.finishqty + "}]";

                     $("#dialogGrid").jqGrid("setRowData", rowId, obj);

                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     });

     $("#modal-add").click(function () {

         var jqData = $("#dialogGrid").jqGrid('getRowData');

         $("#entry-emp").val("");
         $("#entry-empname").val("");
         $("#entry-rate").val("");


         var newrowID = 1;
         if (jqData.length > 0) {
             newrowID = parseInt(jqData[jqData.length - 1].index) + 1;

         }


         $("#entry-modal").dialog({
             width: 300,
             modal: true,
             buttons: {
                 "确认": function () {

                     var arr = new Array();
                     var obj = new Object();
                     obj.id = newrowID;
                     obj.emp = $("#entry-emp").val();
                     obj.empname = $("#entry-empname").val();
                     obj.rate = $("#entry-rate").val();
                     arr.push(obj);
                     var dataRow = JSON.stringify(obj);

                     $("#dialogGrid").jqGrid("addRowData", newrowID, obj, "last");

                     $(this).dialog("close");
                 },
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
         });


     });
     $("#modal-delete").click(function () {

         var rowId = $('#dialogGrid').jqGrid('getGridParam', 'selrow');
         if (rowId === null) {
             $("#msg").text("请选择一行数据！");
             $("#alert").dialog({
                 modal: true,
                 height: 90
             });
             return false;
         }

         jQuery("#dialogGrid").delRowData(rowId);

     });

     $("#entry-emp").click(function () {

         $("#query-emp").click(function () {
             var inputemp = $("#query-input-emp").val();

             $('#empGrid').jqGrid('setGridParam', {
                 url: 'GetEmployee.ashx?emp=' + inputemp,
                 datatype: 'json',
                 page: 1
             }).trigger('reloadGrid');

         })

         $("#query-emp").click();

         $("#emp-modal").dialog("open")

     })


 })