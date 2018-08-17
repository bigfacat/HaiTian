 $(function () {

     var date = new Date();
     var year = date.getFullYear();
     var month = date.getMonth() + 1;
     $("#year").val(year);
     $("#month").val(month);
     
     function LoadGridData(GridID,URL){
         
         var GridPagerID=GridID+"Pager";
         
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
                 frozen: true
             }, {
                 label: '姓名',
                 name: 'name',
                 width: 100,
                frozen: true

             }, {
                 label: '工种',
                 name: 'gz',
                 width: 75,
                 frozen: true
             }, {
                 label: '工序计件工资',
                 name: 'promoney',
                 width: 75
             },{
                 label: '工段工资',
                 name: 'secmoney',
                 width: 75
             }, {
                 label: '工序奖金',
                 name: 'bonus',
                 width: 100,

             },{
                 label: '合计工资',
                 name: 'sum',
                 width: 75
             }],
             loadonce: true,
             viewrecords: true,
             emptyrecords: "没有数据", //右下角显示
             width: 900,
             height: window.GridWidth,
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
var url='SalesOrderCost.ashx?year=' + y + '&month=' + m;
         
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
                    
                    LoadGridData("#jqGrid",url);


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

     $("#query").click();

    
 })