    $(function () {

        function LoadCloseAccountCheckGridData(GridID, URL) {

            var GridPagerID = GridID + "Pager";

            $(GridID).jqGrid({
                url: URL,
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "json",
                page: 1,
                colModel: [{
                    label: '单据名称',
                    name: 'BillType',
                    width: 100,
                }, {
                    label: '单据编号',
                    name: 'BillNo',
                    width: 100,
                }],
                loadonce: true,
                viewrecords: true,
                emptyrecords: "没有数据", //右下角显示
                width: 550,
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

        var sel = '';

        $("#switch").click(function () {

            $("#dialog-modal").dialog({
                width: 400,
                modal: true,
                buttons: {
                    "确认": function () {

                        var Year = $("#year").val();
                        var Month = $("#month").val();
                        var Switch = $("#m_switch").val();
                        var PostData = "{\"Year\":" + Year + ",\"Month\":" + Month + ",\"Switch\":" + Switch + "}";
                        var url = "CloseAccountCheck.ashx?PostData=" + PostData;

                        if (Switch === "0") {

                            $.ajax({
                                type: "Post",
                                url: url,
                                //context: document.body,//为所有 AJAX 相关的回调函数规定 "this" 值
                                //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                                //data: JSON.stringify({"salesOrder":"XSDD000064"}),
                                //data: "",
                                contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                                //dataType: "json",//预期的服务器响应的数据类型
                                success: function (data) {

                                    if (data !== "") {

                                        obj = eval("(" + data + ")");
                                        if (obj.Result === "99") {
                                            $("#msg").text("请求错误！");
                                            $("#alert").dialog({
                                                modal: true,
                                                height: 90
                                            });
                                            return false;

                                        } else if (obj.rows.length > 0) {

                                            LoadCloseAccountCheckGridData("#billGrid", url)
                                            $("#bill-modal").dialog({
                                                width: 600,
                                                modal: true,
                                            });


                                            return false;

                                        }


                                    } else if (data === "") {
                                        OPAccountData(PostData);

                                    }


                                },
                                error: function (xhr, status, error) {},
                                complete: function (data) { //alert(data.responseText)
                                }
                            });

                        } else if (Switch === "1") {
                            OPAccountData(PostData);
                        }

                    },
                    取消: function () {
                        $(this).dialog("close");
                    }
                }
            });

            function OPAccountData(PostData) {

                $.ajax({
                    type: "Post",
                    url: "Account.aspx/EditAccountData",
                    //context: document.body,//为所有 AJAX 相关的回调函数规定 "this" 值
                    data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                    //data: JSON.stringify({"salesOrder":"XSDD000064"}),
                    //data: "",
                    contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                    dataType: "json", //预期的服务器响应的数据类型
                    success: function (data) {

                        obj = eval("(" + data.d + ")");
                        if (obj === 100) {
                            $("#msg").text("操作成功！");
                            $("#alert").dialog({
                                modal: true,
                                height: 90
                            });
                            $("#dialog-modal").dialog("close");
                        } else {
                            $("#msg").text("操作失败！");
                            $("#alert").dialog({
                                modal: true,
                                height: 90
                            });
                        }

                        $("#query").click();

                    },
                    error: function (xhr, status, error) {
                        $("#msg").text("请求错误！");
                        $("#alert").dialog({
                            modal: true,
                            height: 90
                        });
                        return false;

                    },
                    complete: function (data) { //alert(data.responseText)
                    }
                });

            }

            var date = new Date()
            var year = date.getFullYear()
            var month = date.getMonth() + 1

            $("#year option").each(function () {
                if ($(this).text() == year) {
                    $(this).prop("selected", 'selected');
                }
            })
            $("#month option").each(function () {
                if ($(this).text() == month) {
                    $(this).prop("selected", 'selected');
                }
            })

            $("#year").selectmenu({
                width: 100
            });
            $("#month").selectmenu({
                width: 70
            });
            $("#m_switch").selectmenu({
                width: 100
            });
            
            $('.select').selectmenu("refresh");


        })

        $("#query").click(function () {
            var y = $("#select_year").val()
            var m = $("#select_mon").val()
            var status = $("#S").val()


            $("#jqGrid").jqGrid({
                url: 'GetAccountStatus.ashx?y=' + y + '&m=' + m + '&status=' + status,
                //editurl: 'clientArray',
                mtype: "GET",
                datatype: "json",
                page: 1,
                colModel: [{
                    label: 'ID',
                    name: 'orderID',
                    width: 75,
                    hidden: true
                }, {
                    label: '年份',
                    name: 'year',
                    width: 75
                }, {
                    label: '月份',
                    name: 'month',
                    width: 75,

                }, {
                    label: '账套状态',
                    name: 'status',
                    width: 75,
                }, ],
                loadonce: true,
                viewrecords: true,
                width: 780,
                height: window.GridHeight,
                rowNum: window.rowNum,
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

            jQuery("#jqGrid").jqGrid("clearGridData");


            $('#jqGrid').jqGrid('setGridParam', {
                url: 'GetAccountStatus.ashx?y=' + y + '&m=' + m + '&status=' + status,
                datatype: 'json',
                page: 1
            }).trigger('reloadGrid');


        })

        $("#query").click();
    })// JavaScript Document