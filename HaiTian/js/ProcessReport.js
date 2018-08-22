    $(function () {

var cellHeight = 26;

        var bodywidth = $(document.body).width() - 5 - 17;
        
var outGridHeight = cellHeight*10 + scrollWidth;


        $("#billdate").bind("click", function () {
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                maxDate: '2050-01-01',
                minDate: '2000-01-01',
            });
        });

        $("#startdate").bind("click", function () {
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                maxDate: '2050-01-01',
                minDate: '2000-01-01',
            });
        });

        $("#enddate").bind("click", function () {
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                maxDate: '2050-01-01',
                minDate: '2000-01-01',
            });
        });

        $("#startdate").val(getDateToday());
        $("#enddate").val(getDateToday());


        function initjqGrid() {

            $("#jqGrid").jqGrid({
                //url: 'LoadProcessReport.ashx?billno=' + fbillno + '&mo=' + mo + '&matnumber=' + matnumber + '&startdate=' + startdate + '&enddate=' + enddate+'&isThrown='+isThrown,
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "local",
                page: 1,
                colModel: [{
                    label: 'index',
                    name: 'FEntryIndex',
                    width: 75,
                    hidden: true,
                    frozen: true,
                    key: true
                }, {
                    label: '工序汇报单',
                    name: 'FBillNo',
                    width: 100,
                    frozen: true
                }, {
                    label: '汇报日期',
                    name: 'FDate',
                    width: 75,
                    frozen: true
                }, {
                    label: '制单人',
                    name: 'FBiller',
                    width: 100,
                    frozen: true
                }, {
                    label: '已抛转ERP',
                    name: 'IsThrown',
                    width: 60,
                    frozen: true
                }, {
                    label: '作废状态',
                    name: 'FCancellation',
                    width: 60,
                    frozen: true
                }, {
                    label: '工序计划单',
                    name: 'FWBNO',
                    width: 100,

                }, {
                    label: '计划数量',
                    name: 'FAuxQtyPlan',
                    width: 75,

                }, {
                    label: '已汇报数量',
                    name: 'RptNum',
                    width: 75,

                }, {
                    label: '加工说明',
                    name: 'FOperNote',
                    width: 100,
                }, {
                    label: '生产任务单',
                    name: 'FICMONO',
                    width: 120,
                }, {
                    label: '物料代码',
                    name: 'matnumber',
                    width: 200,

                }, {
                    label: '物料名称',
                    name: 'matname',
                    width: 200,

                }, {
                    label: '工序代码',
                    name: 'opnumber',
                    width: 75,

                }, {
                    label: '工序名称',
                    name: 'opname',
                    width: 100,

                },{
                    label: '工价',
                    name: 'opnumber',
                    width: 75,
                    formatter:'currency',
                    formatoptions:{decimalPlaces: 4}

                }, {
                    label: '行号',
                    name: 'FEntryID',
                    width: 50,
                }, {
                    label: '操作工',
                    name: 'FNumber',
                    width: 120,
                }, {
                    label: '操作工姓名',
                    name: 'FName',
                    width: 75,
                }, {
                    label: '实作数量',
                    name: 'FAuxQtyfinish',
                    width: 75,
                }, ],
                viewrecords: true,
                emptyrecords: "没有数据", //右下角显示
                width: bodywidth,
                height: outGridHeight,
                rowNum: 100,
                shrinkToFit: false,
                autoScroll: true,
                pager: "#jqGridPager"
            });

            $("#jqGrid").navGrid("#jqGridPager", {
                edit: false,
                add: false,
                del: false,
                search: false,
                refresh: false,
                view: false,
                align: "left"
            });

            jQuery("#jqGrid").jqGrid('setFrozenColumns');

        }

        initjqGrid();
        
        function query(page) {
            
            if(page===undefined){
                page=1;
            }
            var fbillno = $("#fbillno").val();
            var mo = $("#icmo").val();
            var matnumber = $("#matnumber").val();
            var startdate = $("#startdate").val();
            var enddate = $("#enddate").val();
            var isThrown = $("#is-thrown").val();


            $("#jqGrid").jqGrid('clearGridData'); //清空表格


            $('#jqGrid').jqGrid('setGridParam', {
                url: 'LoadProcessReport.ashx?billno=' + fbillno + '&mo=' + mo + '&matnumber=' + matnumber + '&startdate=' + startdate + '&enddate=' + enddate + '&isThrown=' + isThrown,
                datatype: 'json',
                page: page
            }).trigger('reloadGrid');


        }
        
        $("#query").click(function(){
            query(1);
        })

        var sel = '';
        var arr_prd = new Array();
        var obj = new Object();

function initprGridModal(){
                $("#prGrid").jqGrid({
                //url: 'LoadProcessReportEntry.ashx?billno=' + billno + '',
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "local",
                page: 1,
                colModel: [{
                    label: '主键',
                    name: 'index',
                    width: 75,
                    hidden: true
                }, {
                    label: '行号',
                    name: 'entryID',
                    width: 35,
                }, {
                    label: '操作工',
                    name: 'emp',
                    width: 100,
                    editable: true,
                }, {
                    label: '操作工姓名',
                    name: 'empname',
                    width: 50,
                }, {
                    label: '实作数量',
                    name: 'finishqty',
                    width: 75,
                    editable: true,
                    edittype: "text"

                }, ],
                loadonce: true,
                viewrecords: true,
                width: 500,
                height: window.modalGridHeight,
                rowNum: 100,
                pager: "#prGridPager"
            })

            $("#prGrid").navGrid("#prGridPager", {
                    edit: false,
                    add: false,
                    del: false,
                    search: false,
                    refresh: false,
                    view: false,
                    align: "left"
                }, {
                    zIndex: 102,
                    jqModal: true,
                    modal: true
                }, //option for edit
                {
                    zIndex: 102,
                    jqModal: true,
                    modal: true,
                    beforeSubmit: function (postdata, form, oper) {
                        if (confirm('Are you sure you want to update this row?')) {
                            // do something
                            return [true, ''];
                        } else {
                            return [false, 'You can not submit!'];
                        }
                    }
                }, // for add
                {
                    zIndex: 102,
                    modal: true
                } // del
            )
            
}
        
        initprGridModal();
        
        $("#add").click(function () {

        if(!checkUserName()){
            return false;
        }
            
            $("#prGrid").jqGrid('clearGridData'); //清空表格

            $("#processplan").val("");
            //$("#mo").val("");
            $("#processplan").val("");
            $("#plan-num").val("");
            $("#Rpt-Num").val("");
            $("#mat-number").val("");
            $("#mat-name").val("");
            $("#process-code").val("");
            $("#process-name").val("");
            $("#is-section").val("");

            $("#billdate").val(getDateToday());
            $("#biller").val($.cookie("Name"));

            $.ajax({
                type: "Post",
                url: "GetNewFBillNo.ashx",
                dataType: "json", //预期的服务器响应的数据类型
                success: function (data) {
                    obj = data.rows;

                    $("#billno").val(obj[0].id);

                    return [true, '修改成功!'];

                },
                error: function (xhr, status, error) {
                    return [false, 'You can not submit!'];
                },
                complete: function (data) { //alert(data.responseText)
                }
            });

                        $("#dialog-modal").dialog({
                width: 950,
                modal: true,
                buttons: {
                    "保存": function () {

                        AccountAuthentication();

                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            })


        })

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
            var IsThrown = rowData.IsThrown;
            if (IsThrown === "是") {
                $("#msg").text("已抛转不能修改！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var billno = rowData.FBillNo;
            $("#billno").val(billno);
            $("#mo").val(rowData.FICMONO);
            $("#billdate").val(rowData.FDate);
            $("#biller").val(rowData.FBiller);
            $("#processplan").val(rowData.FWBNO);
            $("#plan-num").val(rowData.FAuxQtyPlan);
            $("#Rpt-Num").val(rowData.RptNum);
            $("#FOperNote").val(rowData.FOperNote);

            $("#mat-number").val(rowData.matnumber);
            $("#mat-name").val(rowData.matname);
            $("#process-code").val(rowData.opnumber);
            $("#process-name").val(rowData.opname);

            $('#prGrid').jqGrid('setGridParam', {
                url: 'LoadProcessReportEntry.ashx?billno=' + billno + '',
                datatype: 'json',
                page: 1
            }).trigger('reloadGrid');

                        $("#dialog-modal").dialog({
                width: 950,
                modal: true,
                buttons: {
                    "保存": function () {

                        AccountAuthentication();

                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            })
            
        })

        $("#delete").click(function () {
            $("#con-msg").text("确定要删除吗！");
            $("#con").dialog({
                modal: true,
                height: 130
            });

            $("#confirm").off();
            $("#confirm").on("click", function () {
                $("#con").dialog("close");
                Delete();
            });
        });
        $("#submit").click(function () {

            $("#con-msg").text("确定要提交吗！");
            $("#con").dialog({
                modal: true,
                height: 130
            });

            $("#confirm").off();
            $("#confirm").on("click", function () {
                $("#con").dialog("close");
                Submit();
            });


        });

        $("#cancel").click(function () {

            var rowId = $('#jqGrid').jqGrid('getGridParam', 'selrow');
            if (rowId === null) {
                $("#msg").text("请选择一行数据！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var rowData = $("#jqGrid").jqGrid('getRowData', rowId);
            var IsThrown = rowData.IsThrown;
            var FCancellation = rowData.FCancellation;

            if (IsThrown === "否") {
                $("#msg").text("没有提交不能作废！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            if (FCancellation === "是") {
                $("#msg").text("单据已作废不能再作废！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var billno = rowData.FBillNo;


            $("#con-msg").text("单据编号:" + billno + ",确定要作废吗?");
            $("#con").dialog({
                modal: true,
                height: 130
            });

            $("#confirm").off();
            $("#confirm").on("click", function () {
                $("#con").dialog("close");
                Cancel(billno);
            });
        })


        function AccountAuthentication() {

            var arr = new Array();
            var prGrid = $("#prGrid").jqGrid("getRowData");

            if ($("#processplan").val() == "") {
                $("#msg").text("工序计划单不能为空！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                })

                return false;
            }

            if (prGrid.length == 0) {
                $("#msg").text("明细数据不能为空！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                })

                return false;
            }

            var sum = $("#Rpt-Num").val() * 100;

            for (var i = 0; i < prGrid.length; i++) {
                var ret = prGrid[i];
                var obj = new Object();

                if (ret.finishqty=="" || isNaN(ret.finishqty) == true) {
                    $("#msg").text("实作数量不是数字！");
                    $("#alert").dialog({
                        modal: true,
                        height: 90
                    })
                    return false;

                }
                obj.entryID = ret.entryID;
                obj.emp = ret.emp;
                obj.finishqty = ret.finishqty;
                arr.push(obj);
                sum += ret.finishqty * 100;
            }
            if (sum > $("#plan-num").val() * 100) {
                $("#msg").text("实作数量之和不能大于计划数量！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var billdate = $("#billdate").val().split("-");
            var y = billdate[0];
            var m = billdate[1];

            $.ajax({
                type: "Post",
                url: 'GetAccountStatus.ashx?y=' + y + '&m=' + m,
                //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                //dataType: "json", //预期的服务器响应的数据类型
                success: function (data) {

                    if (data === "") {
                        $("#msg").text("汇报日期不是开账状态！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                        return false;
                    }

                    var obj = eval('(' + data + ')');

                    if (obj.rows.length === 0) {
                        $("#msg").text("汇报日期不是开账状态！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                        return false;
                    }

                    var status = obj.rows[0].cell[3];

                    if (status != "开账") {
                        $("#msg").text("未开账！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                        return false;
                    }
                    
                                                      showProgressModal("保存中");//显示进度条


                    var PostData = "{\"billno\":\"" + $("#billno").val() + "\",\"billdate\":\"" + $("#billdate").val() + "\",\"biller\":\"" + $("#biller").val() + "\",\"wbno\":\"" + $("#processplan").val() + "\",\"rows\":" + JSON.stringify(arr) + "}";

                    $.ajax({
                        type: "Post",
                        url: "OpGXHBData.ashx?PostData=" + PostData,
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

                            $("#dialog-modal").dialog("destroy");
                            $("#query").click();

                            return [true, '修改成功!'];

                        },
                        error: function (xhr, status, error) {
                            return [false, 'You can not submit!'];
                        },
                        complete: function (data) { //alert(data.responseText)
                                                          closeProgressModal();

                        }
                    });

                },
                error: function (xhr, status, error) {},
                complete: function (data) { //alert(data.responseText)
                }
            })

        }

        function Submit() {

            var rowId = $('#jqGrid').jqGrid('getGridParam', 'selrow');
            if (rowId === null) {
                $("#msg").text("请选择一行数据！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var rowData = $("#jqGrid").jqGrid('getRowData', rowId);
            var IsThrown = rowData.IsThrown;
            var FCancellation = rowData.FCancellation;
            if (IsThrown === "是") {
                $("#msg").text("不能重复提交！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            if (FCancellation === "是") {
                $("#msg").text("单据已作废不能提交！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var billno = rowData.FBillNo;
       var page=$('#jqGrid').getGridParam('page');

            $.ajax({
                type: "Post",
                url: "submit.ashx?billno=" + billno+"&page="+page,
                //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                //dataType: "json", //预期的服务器响应的数据类型
                success: function (data) {

                    var obj = eval('(' + data + ')');
                    if (obj.Result === "True") {
                        $("#msg").text("提交成功！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });
                        
var page=parseInt(obj.Page);
                        
                        query(page);

                    }
                    if (obj.Msg != undefined) {
                        $("#msg").text(obj.Msg);
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                    }

                    return [true, '修改成功!'];

                },
                error: function (xhr, status, error) {
                    return [false, 'You can not submit!'];
                },
                complete: function (data) { //alert(data.responseText)
                }
            });
        }

        function Delete() {
            var rowId = $('#jqGrid').jqGrid('getGridParam', 'selrow');
            if (rowId === null) {
                $("#msg").text("请选择一行数据！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var rowData = $("#jqGrid").jqGrid('getRowData', rowId);
            var IsThrown = rowData.IsThrown;
            var FCancellation = rowData.FCancellation;

            if (IsThrown === "是") {
                $("#msg").text("已提交不能删除！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            if (FCancellation === "是") {
                $("#msg").text("单据已作废不能删除！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            var billno = rowData.FBillNo;

            $.ajax({
                type: "Post",
                url: "DeleteProcessReport.ashx?billno=" + billno,
                //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                //dataType: "json", //预期的服务器响应的数据类型
                success: function (data) {

                    var obj = eval('(' + data + ')');
                    if (obj.jsonResult.Result === "100") {
                        $("#msg").text("删除成功！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                        $("#query").click();

                    }
                    if (obj.jsonResult.Result === "99") {
                        $("#msg").text("删除失败！" + obj.jsonResult.Msg);
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                    }

                    return [true, '修改成功!'];

                },
                error: function (xhr, status, error) {
                    return [false, 'You can not submit!'];
                },
                complete: function (data) { //alert(data.responseText)
                }
            });

        }

        function Cancel(billno) {

            $.ajax({
                type: "Post",
                url: "ProcessReport.ashx?op=Cancel&billno=" + billno,
                //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                //dataType: "json", //预期的服务器响应的数据类型
                success: function (data) {

                    var obj = eval('(' + data + ')');
                    if (obj.jsonResult.Result === "100") {
                        $("#msg").text("作废成功！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                        $("#query").click();

                    }
                    if (obj.jsonResult.Result === "99") {
                        $("#msg").text("作废失败！" + obj.jsonResult.Msg);
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });

                    }

                },
                error: function (xhr, status, error) {},
                complete: function (data) { //alert(data.responseText)
                }
            });

        }


        $("#mo").click(function () {

            //$("#query-mo").click();//查询反而会重置表格状态
                var Modal=$("#mo-modal")

                Modal.dialog({
                autoOpen: true,
                width: "auto",
                modal: true,
                //height:500,
                buttons: {

                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            })

        })

        function initMoGrid(){
            
            var Grid=$("#moGrid")
            var GridPager="#moGridPager"
                        var Modal=$("#mo-modal")

                        Grid.jqGrid({
                //url: 'GetMO.ashx?mo=' + inputmo,
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "local",
                page: 1,
                colModel: [{
                    label: 'ID',
                    name: 'FInterID',
                    width: 75,
                    hidden: true
                }, {
                    label: '工单编号',
                    name: 'FBillNo',
                    width: 150
                }, {
                    label: '物料代码',
                    name: 'FNumber',
                    width: 150,

                }, {
                    label: '物料名称',
                    name: 'FName',
                    width: 150,
                }, ],
                loadonce: true,
                viewrecords: true,
                width: 780,
                height: window.modalGridHeight,
                rowNum: 50,
            ondblClickRow: function (rowId) {
                
            var arr = [];
            var obj1 = {};
            obj1.text = "#mo"
            obj1.col = "FBillNo"
            arr.push(obj1);

            ondblClickRowFun(Grid, rowId, Modal, arr);
            },
                pager: GridPager
            });

            Grid.navGrid(GridPager, {
                edit: false,
                add: false,
                del: false,
                search: true,
                refresh: false,
                view: false,
                align: "left"
            });


        }
        
        initMoGrid();
        
        $("#query-mo").click(function () {
            var inputmo = $("#inputmo").val();

                        $('#moGrid').jqGrid('clearGridData'); //清空表格

            $('#moGrid').jqGrid('setGridParam', {
                url: 'GetMO.ashx?mo=' + inputmo,
                datatype: 'json',
                page: 1
            }).trigger('reloadGrid');


        });

                function initPlanGrid(){
            
            var Grid=$("#planGrid")
            var GridPager="#planGridPager"
                        var Modal=$("#plan-modal")

            Grid.jqGrid({
                //url: "GetProcessPlan.ashx?plan=" + inputplan + "&mo=" + planmo,
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "local",
                page: 1,
                colModel: [{
                    label: 'ID',
                    name: 'FWBInterID',
                    width: 75,
                    hidden: true
                }, {
                    label: '工序计划单',
                    name: 'FWorkBillNO',
                    width: 150
                }, {
                    label: '计划数量',
                    name: 'FAuxQtyPlan',
                    width: 75,

                }, {
                    label: '已汇报数量',
                    name: 'RptNum',
                    width: 75,

                }, {
                    label: '加工说明',
                    name: 'FOperNote',
                    width: 100,
                }, {
                    label: '所属工单',
                    name: 'mo',
                    width: 150,
                }, {
                    label: '物料代码',
                    name: 'matnumber',
                    width: 150,

                }, {
                    label: '物料名称',
                    name: 'matname',
                    width: 75,

                }, {
                    label: '工序代码',
                    name: 'FOperSN',
                    width: 75,

                }, {
                    label: '工序名称',
                    name: 'FOperID',
                    width: 75,

                }, {
                    label: '是工段',
                    name: 'IsSection',
                    width: 75,

                }, ],
                            ondblClickRow: function (rowId) {
                
                        var rowData = $("#planGrid").jqGrid('getRowData', rowId);
                        $("#mo").val(rowData.mo);
                        $("#processplan").val(rowData.FWorkBillNO);
                        $("#plan-num").val(rowData.FAuxQtyPlan);
                        $("#Rpt-Num").val(rowData.RptNum);
                        $("#FOperNote").val(rowData.FOperNote);

                        $("#mat-number").val(rowData.matnumber);
                        $("#mat-name").val(rowData.matname);
                        $("#process-code").val(rowData.FOperSN);
                        $("#process-name").val(rowData.FOperID);
                        $("#is-section").val(rowData.IsSection);
                                
                                Modal.dialog("close");

            },
                loadonce: true,
                viewrecords: true,
                width: 1000,
                height: window.modalGridHeight,
                rowNum: 50,
                pager: GridPager
            })

            Grid.navGrid(GridPager, {
                edit: false,
                add: false,
                del: false,
                search: true,
                refresh: false,
                view: false,
                align: "left"
            })

                        Modal.dialog({
                autoOpen: false,
                width: "auto",
                modal: true,
                //height:500,
                buttons: {
                    "确认": function () {

                ondblClickRowFunConfirm(Grid);
                        
                        $(this).dialog("close");
                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            })

        }
        
        initPlanGrid();

        $("#processplan").click(function () {

            $("#plan-mo").val($("#mo").val());
            //$("#query-plan").click();

            $("#plan-modal").dialog("open")

        })

        $("#query-plan").click(function () {
            var inputplan = $("#inputplan").val();
            var planmo = $("#plan-mo").val();


            $('#planGrid').jqGrid('clearGridData'); //清空表格

            $('#planGrid').jqGrid('setGridParam', {
                url: "GetProcessPlan.ashx?plan=" + inputplan + "&mo=" + planmo,
                datatype: 'json',
                page: 1
            }).trigger('reloadGrid');


        })


        $("#modal-edit").click(function () {

            CheckIsSection();

            var rowId = $('#prGrid').jqGrid('getGridParam', 'selrow');
            if (rowId === null) {
                $("#msg").text("请选择一行数据！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }
            var rowData = $("#prGrid").jqGrid('getRowData', rowId);


            var billno = $("#billno").val();
            $("#entryID").val(rowData.entryID);
            $("#entry-emp").val(rowData.emp);
            $("#entry-empname").val(rowData.empname);
            $("#entry-finishqty").val(rowData.finishqty);


            $("#entry-modal").dialog({
                width: 300,
                modal: true,
                buttons: {
                    "确认": function () {

                        var arr = new Array();
                        var obj = new Object();
                        //obj.index=2;
                        //obj.empname='1';
                        obj.entryID = $("#entryID").val();
                        obj.emp = $("#entry-emp").val();
                        obj.empname = $("#entry-empname").val();
                        obj.finishqty = $("#entry-finishqty").val();
                        arr.push(obj);
                        var dataRow = JSON.stringify(obj);
                        var PostData = "[{\"billno\":\"" + billno + "\",\"entryID\":" + rowData.entryID + ",\"emp\":" + rowData.emp + ",\"finishqty\":" + rowData.finishqty + "}]";

                        $("#prGrid").jqGrid("setRowData", rowId, obj);

                        $(this).dialog("close");
                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            });


        });

        $("#modal-add").click(function () {

            CheckIsSection();

            var jqData = $("#prGrid").jqGrid('getRowData');

            $("#entryID").val(jqData.length + 1);
            $("#entry-emp").val("");
            $("#entry-empname").val("");
            $("#entry-finishqty").val("");


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
                        obj.index = newrowID;
                        //obj.empname='1';
                        obj.entryID = $("#entryID").val();
                        obj.emp = $("#entry-emp").val();
                        obj.empname = $("#entry-empname").val();
                        obj.finishqty = $("#entry-finishqty").val();
                        arr.push(obj);
                        var dataRow = JSON.stringify(obj);

                        $("#prGrid").jqGrid("addRowData", newrowID, obj, "last");

                        $(this).dialog("close");
                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            });


        });

        function CheckIsSection() {

            var IsSection = $("#is-section").val();
            if (IsSection == "" || IsSection == "否") {
                $("#entry-emp").prop("disabled", "")
                $("#entry-empname").prop("disabled", "")
            } else if (IsSection == "是") {
                $("#entry-emp").prop("disabled", "disabled")
                $("#entry-empname").prop("disabled", "disabled")
            }
        }

        $("#modal-delete").click(function () {

            var rowId = $('#prGrid').jqGrid('getGridParam', 'selrow');
            if (rowId === null) {
                $("#msg").text("请选择一行数据！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
            }

            jQuery("#prGrid").delRowData(rowId);

        });

        //利用on方法绑定未来元素
                    $(document).on("click","#query-emp",function () {
                        
                var inputemp = $("#query-input-emp").val();

                //职员Grid已经先在public.js初始化
                $('#empGrid').jqGrid('setGridParam', {
                    url: 'GetEmployee.ashx?emp=' + inputemp,
                    datatype: 'json',
                    page: 1
                }).trigger('reloadGrid')


            })


        $("#entry-emp").click(function () {

                //var GridIDWithout="empGrid";
                //LoadGridState(GridIDWithout);

    $("#emp-modal").dialog({
        autoOpen: true,
        width: "auto",
        modal: true,
        //height:500,
        buttons: {
            "确认": function () {

                ondblClickRowFunConfirm(Grid);
                $(this).dialog("close");
            },
            取消: function () {
                $(this).dialog("close");
            }
        }
    })

        })
    });
    // JavaScript Document