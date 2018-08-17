 $(function () {


     var date = new Date();
     var year = date.getFullYear();
     var month = date.getMonth() + 1;
     $("#year").val(year);
     $("#month").val(month);
     
     function initSelectYear(select,count){
         
         for(var i=-1;i<count;i++){
             select.append("<option value='"+(year+i)+"'>"+(year+i)+"</option>")
         }
         
     }
          var select=$("#cost-year")
initSelectYear(select,8)

     function LoadGridData(GridID, URL) {

         var GridPagerID = GridID + "Pager";

         $(GridID).jqGrid({
             //url: URL,
             //mtype: "GET",
             //datatype: "json",
             page: 1,
             colModel: [{
                 label: 'id',
                 name: 'id',
                 width: 75,
                 hidden: true,
                 frozen: true
             },{
                 label: '部门',
                 name: 'dept',
                 width: 120,
                 frozen: true
             },  {
                 label: '员工代码',
                 name: 'empno',
                 width: 120,
                 frozen: true
             }, {
                 label: '员工姓名',
                 name: 'name',
                 width: 75,
             }, {
                 label: '工种',
                 name: 'gz',
                 width: 75,
                 frozen: true
             }, {
                 label: '工序计件工资',
                 name: 'promoney',
                 width: 75
             }, {
                 label: '工段计件工资',
                 name: 'secmoney',
                 width: 75
             }, {
                 label: '工序奖金',
                 name: 'bonus',
                 width: 75,

             }, {
                 label: '合计工资',
                 name: 'sum',
                 width: 75
             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: 1200,
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

     }


     $("#query").click(function () {

         var y = $("#year").val();
         var m = $("#month").val();
                               var strPostData = "{\"op\":\"\",\"year\":\"" + y + "\",\"month\":\"" + m + "\"}";

         var url = 'CalculateSalaryReport.ashx?PostData=' + strPostData;
         

         $.ajax({
             type: "Post",
             url: 'GetAccountStatus.ashx?y=' + y + '&m=' + m,
             //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
             //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
             //dataType: "json", //预期的服务器响应的数据类型
             success: function (data) {

                 if (data === "") {
                     $("#msg").text("当前周期未关账，不能计算薪资！");
                     $("#alert").dialog({
                         modal: true,
                         height: 90
                     });

                     return false;
                 }

                 var obj = eval('(' + data + ')');

                 if (obj.rows.length === 0) {
                     $("#msg").text("当前周期未关账，不能计算薪资！");
                     $("#alert").dialog({
                         modal: true,
                         height: 90
                     });

                     return false;
                 }

                 var status = obj.rows[0].cell[3];

                 if (status != "关账") {
                     $("#msg").text("当前周期未关账，不能计算薪资！");
                     $("#alert").dialog({
                         modal: true,
                         height: 90
                     });

                     return false;
                 }

                 $("#jqGrid").jqGrid('clearGridData'); //清空表格

                 $("#jqGrid").jqGrid('setGridParam', {
                     url: url,
                     mtype: "GET",
                     datatype: 'json',
                     loadComplete: function (xhr) {
                         var rowNum = parseInt($(this).getGridParam("records"), 10);
                         if (rowNum <= 0) {
                             alert("没有符合条件的记录！");
                         }
                     },
                     page: 1
                 }).trigger('reloadGrid');


             },
             error: function (xhr, status, error) {
                 $("#msg").text("请求失败！");
                 $("#alert").dialog({
                     modal: true,
                     height: 90
                 });

                 return false;

             },
             complete: function (data) { //alert(data.responseText)
             }
         })

     });


     var y = $("#year").val();
     var m = $("#month").val();
     var url = 'CalculateSalaryReport.ashx?year=' + y + '&month=' + m;

     LoadGridData("#jqGrid", url);

     $('#export').click(function () {
         //JS文件夹要加转义符\
         //window.open('DownLoadFile\\2018年3月薪资.xlsx');
         
                    $("#myear").val($("#year").val());
                      $("#mmonth").val($("#month").val());

         $("#import-tr").css("display", "none");
         $("#importC").css("display", "none");
$("#exportC").css("display", "");
         $("#portdiv").dialog({
             width: 350,
             modal: true,
             title:"导出",
         })
     })

     $('#import').click(function () {
         //JS文件夹要加转义符\
         //window.open('DownLoadFile\\2018年3月薪资.xlsx');

                             $("#myear").val($("#year").val());
                      $("#mmonth").val($("#month").val());

         $("#import-tr").css("display", "");
         $("#importC").css("display", "");
         $("#exportC").css("display", "none");
         $("#portdiv").dialog({
             width: 350,
             modal: true,
             title:"导入",
         })

     })
     
          $('#import-cost').click(function () {
         //JS文件夹要加转义符\

                   $("#cost-year").val($("#year").val());
     $("#cost-month").val($("#month").val());

                       $("#import-cost-div").dialog({
             modal: true,
                            buttons: {
                 "确认导入": function () {
                     
                     showProgressModal("导入中")
                     
                     var year = $("#cost-year").val();
                                          var month=$("#cost-month").val();

             var strPostData = "{\"op\":\"ImportCost\",\"year\":\"" + year + "\",\"month\":\"" + month + "\"}";
         var PostData = {
             "PostData": strPostData
         }
         
                  $.ajax({
             type: "Post",
             url: "CalculateSalaryReport.ashx",
             data: PostData,
             //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
             //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
             //dataType: "json", //预期的服务器响应的数据类型
             success: function (data) {

             var obj = eval('(' + data + ')');

                 var msg
             if (obj.status === 100) {
                 msg="导入成功！"+"导入单据数量："+obj.count;

             } else {
                 msg="导入失败！" + obj.msg;

             }
             myAlert(msg);

             },
             error: function (xhr, status, error) {
                 alertAjaxError();
             },
             complete: function (data) {
                 closeProgressModal()
             }
         })
                  
                  $(this).dialog("close");
},
                 取消: function () {
                     $(this).dialog("close");
                 }
             }
            
         })


     })


         $("#importC").click(function () {

        var filePath = $(".a-upload input[type='file']").val();
        if (filePath.indexOf("xlsx") == -1 && filePath.indexOf("xls") == -1) {
            return false;
        }

    })


    $(".a-upload").on("change", "input[type='file']", function () {
        var filePath = $(this).val();

        if (filePath.indexOf("xlsx") != -1 || filePath.indexOf("xls") != -1) {
            $(".fileerrorTip").html("").hide();
            var arr = filePath.split('\\');
            var fileName = arr[arr.length - 1];
            $(".showFileName").html(fileName);
        } else {
            $(".showFileName").html("");
            $(".fileerrorTip").html("导入文件类型有误！").show();
            return false
        }
    })


 })