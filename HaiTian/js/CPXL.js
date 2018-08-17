$(function () {

    var GridWidth = 1300;
    var cellHeight = 26

    var GridHeight = cellHeight * 12

    var sel = '';
    var arr_sup = new Array();

    $("#tabs").tabs();

    function sup() {

        var PostData = "{\"op\":\"GetAutoCompleteSup\"}";
        var URL = "ChanPinXiLie.ashx?PostData=" + PostData;
        $.ajax({
            type: "Post",
            url: URL,
            //context: document.body,//为所有 AJAX 相关的回调函数规定 "this" 值
            //data: "{Material:'" + mat + "',pwd:'" + sel + "'}",
            //data: JSON.stringify({"salesOrder":"XSDD000064"}),
            contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {
                var obj = data.rows;
                for (i = 0; i < obj.length; i++) {
                    arr_sup[i] = obj[i].cell[0];
                }

            },
            error: function (xhr, status, error) {
                //alert(error)
            },
            complete: function (data) { //alert(data.responseText)
            }
        });

    }

    sup();

    $("#import").click(function () {

        $("#importdiv").dialog({
            width: 350,
            modal: true,
        })

        //openShutManager(this, 'importdiv', false)

    })

    $("#importC").click(function () {

        var filePath = $(".a-upload input[type='file']").val();
        if (filePath.indexOf("xlsx") == -1 && filePath.indexOf("xls") == -1) {
            return false;
        }




    })

    $("#importConfirm").click(function () {


        Import()


    })


    function Import() {

        var formData = new FormData();
        var PostData = "{\"op\":\"Import\"}"

        formData.append("myfile", document.getElementById("ImportFile").files[0])
        formData.append("PostData", PostData)

        showProgressModal("正在导入")
        
        $.ajax({
            url: "ChanPinXiLie.ashx",
            type: "POST",
            data: formData,
            /**
             *必须false才会自动加上正确的Content-Type
             */
            contentType: false,
            /**
             * 必须false才会避开jQuery对 formdata 的默认处理
             * XMLHttpRequest会对 formdata 进行正确的处理
             */
            processData: false,
            success: function (data) {

                var msg
                var obj = eval('(' + data + ')');

                if (obj.status === 100) {
                    var msg = "资料已导入！" + obj.msg
                    $("#importdiv").dialog("destroy");
                    $("#query").click()


                } else {
                    var msg = "导入失败！" + obj.msg;
                }

                myAlert(msg);

            },
            error: function (xhr, status, error) {},
            complete: function (data) { //alert(data.responseText)
                closeProgressModal()
            }
        })


    }

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


    $("#query").click(function () {

        var cpxl = $("#cpxl").val();
        var sup = $("#sup").val();

        var PostData = "{\"cpxl\":\"" + cpxl + "\",\"sup\":\"" + sup + "\"}";
        var URL = "ChanPinXiLie.ashx?PostData=" + PostData;
        $("#jqGrid").jqGrid('clearGridData'); //清空表格


        $("#jqGrid").jqGrid('setGridParam', {
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

    });

    initjqGridData("#jqGrid", 200);
    initModalGridData("#modalGrid", 1000);

    //供应商维护主表格初始化
    function initjqGridData(GridID, rowNum) {

        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            //editurl: 'ChanPinXiLie.ashx',
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: [{
                label: 'id',
                name: 'id',
                width: 45,
                hidden: true,
                key: true
            }, {
                label: '产品系列代码',
                name: 'cpxl',
                width: 55,
            }, {
                label: '产品系列名称',
                name: 'cpxlname',
                width: 55,
            }, {
                label: '物料代码',
                name: 'mat',
                width: 150,
            }, {
                label: '物料名称',
                name: 'matname',
                width: 150,
            }, {
                label: '规格',
                name: 'model',
                width: 150
            }, {
                label: '供应商编号',
                name: 'sup',
                width: 75
            }, {
                label: '供应商名称',
                name: 'supname',
                width: 150,
            }, {
                label: '状态ID',
                name: 'statusid',
                width: 45,
                hidden: true,
            }, {
                label: '状态',
                name: 'status',
                width: 45,
            }],
            viewrecords: true,
            multiselect: true,
            emptyrecords: "没有数据", //右下角显示
            width: GridWidth,
            height: GridHeight,
            rowNum: rowNum,
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

        //冻结列可能导致错行
        //jQuery(GridID).jqGrid('setFrozenColumns');

    }

    //供应商维护编辑表格初始化
    function initModalGridData(GridID, rowNum) {

        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            editurl: 'clientArray',
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: [{
                label: 'id',
                name: 'id',
                width: 45,
                hidden: true,
                key: true
            }, {
                label: '产品系列代码',
                name: 'cpxl',
                width: 45,
            }, {
                label: '产品系列名称',
                name: 'cpxlname',
                width: 45,
            }, {
                label: '物料代码',
                name: 'mat',
                width: 150,
            }, {
                label: '物料名称',
                name: 'matname',
                width: 150,
            }, {
                label: '规格',
                name: 'model',
                width: 120,
            }, {
                label: '供应商编号',
                name: 'sup',
                width: 150,
                editable: true,
                edittype: "text",
                editoptions: {
                    // dataInit is the client-side event that fires upon initializing the toolbar search field for a column
                    // use it to place a third party control to customize the toolbar
                    dataInit: function (element) {
                        window.setTimeout(function () {
                            $(element).autocomplete({
                                id: 'AutoComplete',
                                source: arr_sup,
                                autoFocus: true
                            });
                        }, 100);
                    }
                }
            }, {
                label: '供应商名称',
                name: 'supname',
                width: 150,
                editable: true,
                edittype: "text",
                editoptions: {
                    // dataInit is the client-side event that fires upon initializing the toolbar search field for a column
                    // use it to place a third party control to customize the toolbar
                    dataInit: function (element) {
                        window.setTimeout(function () {
                            $(element).click(function () {
                                ShowSup(1);
                            })
                        }, 100)
                    }
                }
            }, {
                label: '状态ID',
                name: 'statusid',
                width: 45,
                hidden: true,
            }, {
                label: '状态',
                name: 'status',
                width: 45,
            }],
            loadonce: true,
            viewrecords: true,
            beforeSelectRow: function (id) {
                if (id && id !== lastSelection && lastSelection != undefined) {
                    SaveRow($(this), lastSelection)
                }
            },
            onSelectRow: editRow,
            emptyrecords: "没有数据", //右下角显示
            width: GridWidth,
            height: window.GridHeight,
            rowNum: rowNum,
            pager: GridPagerID
        })

                $(GridID).navGrid(GridPagerID, {
            edit: false,
            add: false,
            del: false,
            search: true,
            refresh: false,
            view: false,
            align: "left"
        },{}, // edit options
            {}, // add options
            {}, // delete options
            { 
				multipleSearch: true, 
			})


        function editRow(id) {
            if (id) {
                var grid = $("#modalGrid");
                var rowData = grid.jqGrid('getRowData', id);
                var status = rowData.statusid;
                if (status === "") {
                    status = 0
                }
                status = parseInt(status)

                if (status) {
                    return false;
                }

                //grid.jqGrid('restoreRow', lastSelection);
                var editParameters = {
                    keys: true, //是否启用键盘
                    //focusField: 7 //第7列focus
                    //successfunc: editSuccessful,
                    aftersavefunc: function () {
                        SaveRow(grid, id)
                    },
                    //errorfunc:  editFailed,
                    restoreAfterError: false
                };
                grid.jqGrid('editRow', id, editParameters);

                lastSelection = id;
            }
        }

        function editSuccessful(data, stat) {
            var response = data.responseText;
            if (response === "") {
                return false;
            }
            var msg
            var obj = eval('(' + response + ')');

            var Grid = $("#modalGrid");
            if (obj.FName === undefined) {
                msg = "供应商不存在！";
                myAlert(msg);
                //Grid.jqGrid('saveRow', obj.id);
                //Grid.jqGrid('setCell',obj.id,6, "")
                return;

            }
            if (obj.status === 99) {
                msg = "保存失败！" + obj.msg;
                myAlert(msg);
                return;

            }



            Grid.jqGrid('saveRow', obj.id);
            Grid.jqGrid('setCell', obj.id, 6, obj.FNumber)

            Grid.jqGrid('setCell', obj.id, 7, obj.FName)

        }


    }


    $("#add").click(function () {

        $("#expand").css("display", "");

        $("#modalGrid").jqGrid('clearGridData'); //清空表格

        $("#dialog-modal").dialog({
            width: "auto",
            modal: true,
            buttons: {
                "保存": function () {
                    SaveCPXLSup();


                },
                取消: function () {
                    $(this).dialog("close");
                }
            }
        });

    })

    $("#edit").click(function () {

        $("#expand").css("display", "none");

        var rowId = alertNotSelected("#jqGrid");

        if (rowId === null) {
            return false;
        }

        var rowData = $("#jqGrid").jqGrid('getRowData', rowId);

        $("#modalGrid").jqGrid('clearGridData'); //清空表格


        $("#modal-cpxl").val(rowData.cpxlname);

        var cpxl = $("#modal-cpxl").val();

        var PostData = "{\"cpxl\":\"" + cpxl + "\"}";
        var URL = "ChanPinXiLie.ashx?PostData=" + PostData;
        $("#modalGrid").jqGrid('clearGridData'); //清空表格


        $("#modalGrid").jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
            page: 1
        }).trigger('reloadGrid');


        $("#dialog-modal").dialog({
            width: "auto",
            modal: true,
            buttons: {

                关闭: function () {
                    $(this).dialog("close");
                }
            }
        })

        $('#dialog-modal').bind('dialogclose', function (event, ui) {
            $("#query").click()
        })

    })

    $("#review").click(function () {
        var grid = $("#jqGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请选择数据！");
            return false;
        }

        var ids = grid.jqGrid('getGridParam', 'selarrrow');

        //var strPostData = "{\"op\":\"Save\",\"rows\":" + JSON.stringify(arr) + "}";
        var PostData = {
            "PostData": ids,
            "op": "review"
        }

        showProgressModal("审核中");

        $.ajax({
            type: "Post",
            url: "ChanPinXiLieReview.ashx",
            traditional: true, //阻止深度序列化
            data: PostData,
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                var obj = eval('(' + data + ')');
                var msg;
                if (obj.status === 100) {
                    msg = "审核成功！"
                    
                } else {
                    msg = "审核失败！" + obj.msg;

                }
                myAlert(msg);

                $("#query").click();

            },
            error: function (xhr, status, error) {},
            complete: function (data) { //alert(data.responseText)
                closeProgressModal();
            }
        })

    })

    $("#cancel-review").click(function () {
        var grid = $("#jqGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请选择数据！");
            return false;
        }

        var ids = grid.jqGrid('getGridParam', 'selarrrow');

        //var strPostData = "{\"op\":\"Save\",\"rows\":" + JSON.stringify(arr) + "}";
        var PostData = {
            "PostData": ids,
            "op": "cancelreview"
        }

        showProgressModal("正在反审核");

        $.ajax({
            type: "Post",
            url: "ChanPinXiLieReview.ashx",
            traditional: true, //阻止深度序列化
            data: PostData,
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                var obj = eval('(' + data + ')');
                var msg;
                if (obj.status === 100) {
                    msg = "反审核成功！"
                } else {
                    msg = "反审核失败！" + obj.msg;

                }
                myAlert(msg);

                $("#query").click();

            },
            error: function (xhr, status, error) {},
            complete: function (data) { //alert(data.responseText)
                closeProgressModal();
            }
        })

    })

    $("#change-sup").click(function () {
        $("#div-change-sup").dialog({
            width: "auto",
            modal: true,
            //height:500,
            buttons: {
                "确认": function () {
                    var msg
                    var conMsg
                                        var oldsup = $("#change-sup-old-num").val()
                    var newsup = $("#change-sup-new-num").val()

                    if (oldsup === "" || newsup === "") {
                        msg = "供应商不能为空！";
                        myAlert(msg);
                        return false;
                    }
                    
                                                                    if ( strID=== "") {
                        conMsg = "没有选择系列，更换供应商会应用到所有系列，是否确定？";
                    }
                    else{
                        conMsg = "已选择系列，确定要更换供应商吗？";
                    }

                    $("#confirm-div #confirm-msg").text(conMsg)
            
                    $("#confirm-div").dialog({
            width: "300",
            modal: true,
            buttons: {
                                确定: function () {
                                    changeSup()
                    $(this).dialog("close");
                },
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })


                },
                取消: function () {
                    $(this).dialog("close");
                }
            }
        })

    })
    
    function changeSup(){

                                        var oldsup = $("#change-sup-old-num").val()
                    var newsup = $("#change-sup-new-num").val()


                    var strPostData = "{\"op\":\"ChangeSup\",\"oldsup\":\"" + oldsup + "\",\"newsup\":\"" + newsup + "\",\"CPXLids\":\"" + strID +"\"}";
                    var PostData = {
                        "PostData": strPostData
                    }

                    $.ajax({
                        type: "Post",
                        url: "ChanPinXiLie.ashx",
                        data: PostData,
                        //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
                        //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
                        //dataType: "json", //预期的服务器响应的数据类型
                        success: function (data) {

                            var msg
                            var obj = eval('(' + data + ')');

                            if (obj.status === 100) {
                                var msg = "更换成功！" + obj.rowcount + "条数据被更新"
                                $("#div-change-sup").dialog("destroy");

                            } else {
                                var msg = "更换失败！" + obj.msg;
                            }

                            myAlert(msg);
                            $("#query").click();

                        },
                        error: function (xhr, status, error) {},
                        complete: function (data) { //alert(data.responseText)
                        }
                    })

    }

    $("#change-sup-old-num").click(function () {
        ShowSup(2);
    })

    $("#change-sup-new-num").click(function () {
        ShowSup(3);
    })
    
                    var strCPXL=""
                    var strID=""
    $("#div-change-sup-btn-select-cpxl").click(function () {

        var grid=$("#cpxlGrid");

        $("#cpxl-modal").dialog({
            width: "auto",
            modal: true,
            buttons: {
                "返回数据": function () {

                var ids = grid.jqGrid('getGridParam', 'selarrrow');
                    if(ids===null){
                        return false;
                    }
                    $.each(ids,function(i,val){
                        var rowData =grid.jqGrid('getRowData', val);
                        var name=rowData.FName
                        if(strCPXL.indexOf(name)===-1){
strCPXL+=rowData.FName+","
strID+=rowData.ID+","
                        }
                        else{
                        }

                        
                    })
                                        
                    
                    $("#div-change-sup-txt-cpxl").val(strID)

$("#div-change-sup-textarea-cpxl").text(strCPXL)

                    $("#cpxl-modal").dialog("close");

                },
                取消: function () {
                    $("#cpxl-modal").dialog("close");
                }
            }
        })
        
        grid.jqGrid('setGridParam', {
            ondblClickRow: function (rowid) {
                var str = "#" + $(this).prop("id");

                var rowId = $(str).jqGrid('getGridParam', 'selrow');
                var rowData = $(str).jqGrid('getRowData', rowId);
                
                //设定选中行，但是不触发onSelectRow事件，设定第三个参数为false
                grid.jqGrid('setSelection',rowid,false);

                var buttons = $("#cpxl-modal").dialog('option', 'buttons');
                buttons.返回数据();

            },
            //page: curpagenum,
        })

        
        $("#query-cpxl").click(function () {

        var GridID = "#cpxlGrid";

        var cpxl = $("#entry-entry-cpxl").val();

        var PostData = "{\"op\":\"" + "GetCPXL" + "\",\"cpxl\":\"" + cpxl + "\"}";

        var URL = 'ChanPinXiLie.ashx?PostData=' + PostData

        var curpagenum = $(GridID).jqGrid('getGridParam', 'page'); //当前页码

        $(GridID).jqGrid('clearGridData'); //清空表格


        $(GridID).jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
            //page: curpagenum,
        }).trigger('reloadGrid');


    })


    })

    $("#div-change-sup-btn-clear-selected").click(function(){
                    $("#div-change-sup-txt-cpxl").val("")
$("#div-change-sup-textarea-cpxl").text("")
                    strCPXL=""
                    strID=""

    })

    $("#cpxl-sup-del").click(function () {
        var grid = $("#jqGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请选择数据！");
            return false;
        }
            
            $("#confirm-div #confirm-msg").text("确定删除所选供应商吗？")
            
                    $("#confirm-div").dialog({
            width: "300",
            modal: true,
            buttons: {
                                确定: function () {
                                    CPXLSupDelete()
                    $(this).dialog("close");
                },
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })

    })

        function CPXLSupDelete(){
                    var grid = $("#jqGrid");

                    var ids = grid.jqGrid('getGridParam', 'selarrrow');

        var PostData = {
            "PostData": ids,
            "op": "Delete"
        }

        showProgressModal("正在执行删除");

        ///因为删除和审核反审核相似，所以请求同一个处理文件
        $.ajax({
            type: "Post",
            url: "ChanPinXiLieReview.ashx",
            traditional: true, //阻止深度序列化
            data: PostData,
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                var obj = eval('(' + data + ')');
                var msg;
                if (obj.status === 100) {
                    msg = "删除成功！"
                    
                } else {
                    msg = "删除失败！" + obj.msg;

                }
                myAlert(msg);

                $("#query").click();

            },
            error: function (xhr, status, error) {},
            complete: function (data) { //alert(data.responseText)
                closeProgressModal();
            }
        })
            
        }

    $("#expand").click(function () {
        var cpxl = $("#modal-cpxl").val();

        var PostData = "{\"op\":\"Expand\",\"cpxl\":\"" + cpxl + "\"}";
        var URL = "ChanPinXiLie.ashx?PostData=" + PostData;
        $("#modalGrid").jqGrid('clearGridData'); //清空表格


        $("#modalGrid").jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
            page: 1
        }).trigger('reloadGrid');


    })

    function SaveCPXLSup() {

        $('#modalGrid').jqGrid('saveRow', lastSelection);
        //querySupDataBySupNo($("#modalGrid"), lastSelection)//忘了

        var arr = new Array();
        var Grid = $("#modalGrid").jqGrid("getRowData");

        if ($("#modal-cpxl").val() == "") {
            $("#msg").text("产品系列不能为空！");
            $("#alert").dialog({
                modal: true,
                height: 160
            })

            return false;
        }

        if (Grid.length == 0) {
            $("#msg").text("明细数据不能为空！");
            $("#alert").dialog({
                modal: true,
                height: 160
            })

            return false;
        }


        for (var i = 0; i < Grid.length; i++) {
            var ret = Grid[i];
            var obj = new Object();

            obj.cpxl = ret.cpxlname;
            obj.mat = ret.mat;
            obj.sup = ret.sup;
            arr.push(obj);
        }

        var strPostData = "{\"op\":\"Save\",\"rows\":" + JSON.stringify(arr) + "}";
        var PostData = {
            "PostData": strPostData
        };
        $.ajax({
            type: "Post",
            url: "ChanPinXiLie.ashx",
            data: PostData,
            //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                if (data === "100") {
                    $("#msg").text("保存成功！");
                    $("#dialog-modal").dialog("destroy");

                } else {
                    $("#msg").text("保存失败！");

                }
                $("#alert").dialog({
                    modal: true,
                    height: 160
                });


                $("#query").click();

                return [true, '修改成功!'];

            },
            error: function (xhr, status, error) {
                return [false, 'You can not submit!'];
            },
            complete: function (data) { //alert(data.responseText)
            }
        })


    }


    function initSupGrid(GridID) {

        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            //editurl: 'clientArray',
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: [{
                label: 'ID',
                name: 'ID',
                width: 75,
                hidden: true
            }, {
                label: '供应商编号',
                name: 'FNumber',
                width: 75
            }, {
                label: '供应商名称',
                name: 'FName',
                width: 150,

            }, ],
            loadonce: true,
            viewrecords: true,
            width: 780,

            height: window.modalGridHeight,
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
    }

    initSupGrid("#supGrid");


    $("#modal-cpxl,#cpxl,#cpxl-prd-div-cpxl").click(function () {

        var GridID = "#cpxlGrid";
        var thisID = "#" + $(this).prop("id");

        $("#cpxl-modal").dialog({
            width: parseInt(window.modalGridWidth_2 + 30),
            modal: true,
            buttons: {
                "确认": function () {

                    var rowId = $(GridID).jqGrid('getGridParam', 'selrow');
                    var rowData = $(GridID).jqGrid('getRowData', rowId);

                    $(thisID).val(rowData.FName);

                    $("#cpxl-modal").dialog("close");

                },
                取消: function () {
                    $("#cpxl-modal").dialog("close");
                }
            }
        })
        
                $(GridID).jqGrid('setGridParam', {
            ondblClickRow: function (rowid) {
                var str = "#" + $(this).prop("id");

                var rowId = $(str).jqGrid('getGridParam', 'selrow');
                var rowData = $(str).jqGrid('getRowData', rowId);
                
                //设定选中行，但是不触发onSelectRow事件，设定第三个参数为false
                $(GridID).jqGrid('setSelection',rowid,false);

                var buttons = $("#cpxl-modal").dialog('option', 'buttons');
                buttons.确认();

            },
        })

            $("#query-cpxl").click(function () {

        var GridID = "#cpxlGrid";

        var cpxl = $("#entry-entry-cpxl").val();

        var PostData = "{\"op\":\"" + "GetCPXL" + "\",\"cpxl\":\"" + cpxl + "\"}";

        var URL = 'ChanPinXiLie.ashx?PostData=' + PostData

        var curpagenum = $(GridID).jqGrid('getGridParam', 'page'); //当前页码

        $(GridID).jqGrid('clearGridData'); //清空表格


        $(GridID).jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
        }).trigger('reloadGrid');


    })


    })


    //产品系列选择表格初始化
    function initCPXLGrid(GridID) {

        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            //editurl: 'clientArray',
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: [{
                label: 'ID',
                name: 'ID',
                width: 75,
                key:true,
                hidden: true
            }, {
                label: '产品系列代码',
                name: 'FNumber',
                width: 75
            }, {
                label: '产品系列名称',
                name: 'FName',
                width: 150,

            }, ],
            loadonce: true,
            viewrecords: true,
            multiselect:true,
            width: window.modalGridWidth_2,
            height: window.modalGridHeight,
            rowNum: 50,
            pager: GridPagerID
        });

        $(GridID).navGrid(GridPagerID, {
            edit: false,
            add: false,
            del: false,
            search: true,
            refresh: false,
            view: false,
            align: "left"
        },{}, // edit options
            {}, // add options
            {}, // delete options
            { 
				multipleSearch: true, 
			});
    }

    initCPXLGrid("#cpxlGrid");



    $("#export").on("click", function () {

        var cpxl = $("#modal-cpxl").val();
        $("#modalGrid").jqGrid("exportToExcel", {
            includeLabels: true,
            includeGroupHeader: true,
            includeFooter: true,
            fileName: cpxl + "-成品料号-供应商.xlsx",
            maxlength: 40 // maxlength for visible string data 
        })
    })


    //产品系列对应成品料号维护
    
    var CPXLPrdColModel={
        data:
        [{
                label: 'id',
                name: 'id',
                width: 45,
                hidden: true,
                key: true
            },{
                label: '产品系列代码',
                name: 'cpxl',
                width: 50,
                hidden: true,
            }, {
                label: '产品系列名称',
                name: 'cpxlname',
                width: 100,
                hidden: true,
            },  {
                label: '物料代码',
                name: 'mat',
                width: 150,
            }, {
                label: '物料名称',
                name: 'matname',
                width: 150,
            }, {
                label: '规格',
                name: 'model',
                width: 150
            }]
                        }
    
    
    
    function initCPXLPrdGridData(GridID, rowNum) {

        var ColModelCopy = jQuery.extend(true,{}, CPXLPrdColModel)
        delete ColModelCopy.data[1].hidden
        delete ColModelCopy.data[2].hidden
        
        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: ColModelCopy.data,
            viewrecords: true,
            //multiselect: true,
            ondblClickRow:function(){
                $("#cpxl-prd-edit").click()
            },
            emptyrecords: "没有数据", //右下角显示
            width: 1000,
            height: GridHeight,
            rowNum: rowNum,
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

        //jQuery(GridID).jqGrid('setFrozenColumns');

    }

    function initEditCPXLPrdGridData(GridID, rowNum) {
        
        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: CPXLPrdColModel.data,
            viewrecords: true,
            multiselect: true,
            emptyrecords: "没有数据", //右下角显示
            width: 800,
            height: GridHeight,
            rowNum: rowNum,
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

        //jQuery(GridID).jqGrid('setFrozenColumns');

    }

        function initPrdGridData(GridID, rowNum) {

            var ColModelCopy = jQuery.extend(true,{}, CPXLPrdColModel)
        ColModelCopy.data.splice(1,2)
        
        var GridPagerID = GridID + "Pager";

        $(GridID).jqGrid({
            //url: URL,
            mtype: "GET",
            //datatype: "json",
            page: 1,
            colModel: ColModelCopy.data,
            viewrecords: true,
            multiselect: true,
            emptyrecords: "没有数据", //右下角显示
            width: 800,
            height: GridHeight,
            rowNum: rowNum,
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

        //jQuery(GridID).jqGrid('setFrozenColumns');

    }


    initCPXLPrdGridData("#Q-prdGrid", 200)
    initEditCPXLPrdGridData("#E-prdGrid", 1000)
    initPrdGridData("#prdGrid", 200)

    $("#cpxl-prd-query").click(function () {

        var cpxl = $("#cpxl-prd-cpxl").val();
                            var grid = $("#Q-prdGrid");
CPXLPrdQuery(grid,cpxl,"GetCPXLProduction")

    })
    
    function CPXLPrdQuery(grid,cpxl,op){

                var PostData = "cpxl=" + cpxl;
        var URL = "ChanPinXiLieProduction.ashx?op="+op+"&" + PostData;
        grid.jqGrid('clearGridData'); //清空表格


        grid.jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
            page: 1
        }).trigger('reloadGrid')

    }


    $("#cpxl-prd-add").click(function () {

$("#cpxl-prd-div-cpxl").val("")
        $("#E-prdGrid").jqGrid('clearGridData'); //清空表格

        $("#cpxl-prd-div").dialog({
            width: "auto",
            modal: true,
            buttons: {
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })

    })
    
        $("#cpxl-prd-edit").click(function () {

                    var grid = $("#Q-prdGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请先选择一行数据！");
            return false;
        }
            var rowData = grid.jqGrid('getRowData', rowId)
var cpxl=rowData.cpxlname
$("#cpxl-prd-div-cpxl").val(cpxl)

var grid= $("#E-prdGrid");
CPXLPrdQuery(grid,cpxl,"GetCPXLProductionDetail")

        $("#cpxl-prd-div").dialog({
            width: "auto",
            modal: true,
            buttons: {
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })


    })

        $("#cpxl-prd-del").click(function () {

                    var grid = $("#Q-prdGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请先选择一行数据！");
            return false;
        }
            var rowData = grid.jqGrid('getRowData', rowId)
var cpxl=rowData.cpxlname

            $("#confirm-div #confirm-msg").text("确定删除"+cpxl+"下属的所有成品料号吗？")
            
                    $("#confirm-div").dialog({
            width: "auto",
            modal: true,
            buttons: {
                                确定: function () {
                                    CPXLProductionDel()
                    $(this).dialog("close");
                },
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })




    })

        function CPXLProductionDel(){
            
                                var grid = $("#Q-prdGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请先选择一行数据！");
            return false;
        }
            var rowData = grid.jqGrid('getRowData', rowId)
var cpxl=rowData.cpxlname



        var PostData = {
            "cpxl":cpxl,
            "op": "Delete"
        }

        showProgressModal("正在删除")

        $.ajax({
            type: "Post",
            url: "ChanPinXiLieProduction.ashx",
            traditional: true, //阻止深度序列化
            data: PostData,
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                var obj = eval('(' + data + ')');
                var msg;
                if (obj.status === 100) {
                    msg = "删除成功！"
                } else {
                    msg = "删除失败！" + obj.msg;

                }
                myAlert(msg);

                $("#cpxl-prd-query").click();

            },
            error: function (xhr, status, error) {},
            complete: function (data) {
                closeProgressModal();
            }
        })
        
        }

    $("#cpxl-prd-div-select").click(function () {



        $("#cpxl-prd-div-select-div").dialog({
            width: "auto",
            modal: true,
            buttons: {
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })

    })

    $("#cpxl-prd-div-select-query").click(function () {

        var prd = $("#cpxl-prd-div-select-prd-txt").val();

        var PostData = "prd=" + prd;
        var URL = "ChanPinXiLieProduction.ashx?op=GetProduction&" + PostData;
        $("#prdGrid").jqGrid('clearGridData'); //清空表格


        $("#prdGrid").jqGrid('setGridParam', {
            url: URL,
            datatype: 'json',
            page: 1
        }).trigger('reloadGrid')

    })

    $("#cpxl-prd-div-select-return").click(function () {
        var grid = $("#prdGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请至少选择一行数据！");
            return false;
        }

        var ids = grid.jqGrid('getGridParam', 'selarrrow');


        for (var i = 0; i < ids.length; i++) {
            var rowId = ids[i]
            var rowData = $("#prdGrid").jqGrid('getRowData', rowId)
            var oldRowData = $("#E-prdGrid").jqGrid('getRowData', rowId)
            if (!oldRowData.id) {
                $("#E-prdGrid").jqGrid("addRowData", rowId, rowData, "last")
            }

        }

        $("#cpxl-prd-div-select-div").dialog("close")

    })

    $("#cpxl-prd-div-del").click(function () {
        var grid = $("#E-prdGrid");
        var rowId = grid.jqGrid('getGridParam', 'selrow');
        if (rowId === null) {
            myAlert("请至少选择一行数据！");
            return false;
        }

        var ids = grid.jqGrid('getGridParam', 'selarrrow');
        var len = ids.length

        for (var i = ids.length - 1; i >= 0; i--) {
            var rowId = ids[i]
            $("#E-prdGrid").jqGrid("delRowData", rowId)

        }
        $("#E-prdGrid").jqGrid('resetSelection')

    })
    
        $("#cpxl-prd-div-save").click(function () {
            
            $("#confirm-div #confirm-msg").text("确定保存吗？")
            
                    $("#confirm-div").dialog({
            width: 200,
            modal: true,
            buttons: {
                                确定: function () {
                                    CPXLProductionSave()
                    $(this).dialog("close");
                },
                关闭: function () {
                    $(this).dialog("close");
                }
            }

        })




    })

        function CPXLProductionSave(){
                                            var msg;

                    var grid = $("#E-prdGrid");

            var cpxl=$("#cpxl-prd-div-cpxl").val()
            if(cpxl===""){
                    msg = "产品系列未选择！";

                myAlert(msg);
return;
            }
            
                    var GridData = grid.jqGrid("getRowData");
            if(GridData.length===0){
                    msg = "成品物料未选择！";

                myAlert(msg);
return;
            }

            var prd_arr=new Array()
                    for (var i = 0; i < GridData.length; i++) {
            var ret = GridData[i];
            var obj = new Object();

            prd_arr.push(ret.id);
        }


        var PostData = {
            "PostData": prd_arr,
            "cpxl":cpxl,
            "op": "Save"
        }

        showProgressModal("正在保存");

        $.ajax({
            type: "Post",
            url: "ChanPinXiLieProduction.ashx",
            traditional: true, //阻止深度序列化
            data: PostData,
            //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
            //dataType: "json", //预期的服务器响应的数据类型
            success: function (data) {

                var obj = eval('(' + data + ')');
                var msg;
                if (obj.status === 100) {
                    msg = "保存成功！"
                    $("#cpxl-prd-div").dialog("destroy")
                } else {
                    msg = "保存失败！" + obj.msg;

                }
                myAlert(msg);
                

                $("#cpxl-prd-query").click();

            },
            error: function (xhr, status, error) {},
            complete: function (data) { //alert(data.responseText)
                closeProgressModal();
            }
        })
        }


})

function confirmSelectedGridData(GridID, Control, op) {
    var rowId = $(GridID).jqGrid('getGridParam', 'selrow');
    var rowData = $(GridID).jqGrid('getRowData', rowId);
    var Control_Name = Control + "name";

    switch (op) {
        case "number":
            $(Control).val(rowData.FNumber);
            $(Control_Name).val(rowData.FName);
            break;
    }

}

var lastSelection;
var lastop;

function SaveRow(Grid, rowId) {

    //var colNames=$(this).jqGrid('getGridParam','colNames');
    var bol = Grid.jqGrid('saveRow', lastSelection)

    var SupNo = Grid.jqGrid('getCell', rowId, 6)
    if (SupNo === "" || SupNo === false) {
        return false;
    }


    $.ajax({
        type: "Post",
        url: "ChanPinXiLieEdit.ashx?sup=" + SupNo + "&id=" + rowId + "&oper=edit",
        //data: PostData,
        //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
        //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
        //dataType: "json", //预期的服务器响应的数据类型
        success: function (data) {

            var msg
            var obj = eval('(' + data + ')');

            if (obj.FName === undefined) {
                msg = "供应商" + SupNo + "不存在！";
                myAlert(msg);
                RestoreSup(Grid, rowId)
                return;
                //Grid.jqGrid('setCell',rowId,6, null)
                //Grid.jqGrid('setCell',rowId,7, null)

            }
            if (obj.status === 99) {
                msg = "保存失败！" + obj.msg;
                myAlert(msg);
                RestoreSup(Grid, rowId)
                return;

            }

            Grid.jqGrid('setCell', rowId, 6, obj.FNumber)
            Grid.jqGrid('setCell', rowId, 7, obj.FName)


        },
        error: function (xhr, status, error) {
            alertAjaxError();
        },
        complete: function (data) {}
    })
}

function RestoreSup(Grid, rowId) {

    $.ajax({
        type: "Post",
        url: "ChanPinXiLieEdit.ashx?id=" + rowId + "&oper=RestoreSup",
        //data: PostData,
        //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
        //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
        //dataType: "json", //预期的服务器响应的数据类型
        success: function (data) {

            var msg
            var obj = eval('(' + data + ')')
            if (obj.FNumber === "") {
                Grid.jqGrid('setCell', rowId, 6, null)
                Grid.jqGrid('setCell', rowId, 7, null)
                return false;

            }
            Grid.jqGrid('setCell', rowId, 6, obj.FNumber)
            Grid.jqGrid('setCell', rowId, 7, obj.FName)


        },
        error: function (xhr, status, error) {},
        complete: function (data) {}
    })
}

function querySup(op) {

    var GridID = "#supGrid";
    var Modal = $("#sup-modal")
    var sup = $("#entry-entry-sup").val();

    var PostData = "{\"op\":\"" + "GetSup" + "\",\"sup\":\"" + sup + "\"}";

    var URL = 'ChanPinXiLie.ashx?PostData=' + PostData

    var curpagenum = $(GridID).jqGrid('getGridParam', 'page'); //当前页码

    $(GridID).jqGrid('clearGridData'); //清空表格


    $(GridID).jqGrid('setGridParam', {
        url: URL,
        datatype: 'json',
        ondblClickRow: function (rowId) {
            if (op === 1) {
                var str = "#" + $(this).prop("id");
                confirmSelectedGridDataForSup(str, "#entry-sup");
Modal.dialog("close");
            } else if (op === 2) {
                var arr = [];
                var obj1 = {};
                obj1.text = "#change-sup-old-num"
                obj1.col = "FNumber"
                arr.push(obj1);

                var obj2 = {};
                obj2.text = "#change-sup-old-name"
                obj2.col = "FName"
                arr.push(obj2);

                ondblClickRowFun($(this), rowId, Modal, arr);

            } else if (op === 3) {
                var arr = [];
                var obj1 = {};
                obj1.text = "#change-sup-new-num"
                obj1.col = "FNumber"
                arr.push(obj1);

                var obj2 = {};
                obj2.text = "#change-sup-new-name"
                obj2.col = "FName"
                arr.push(obj2);

                ondblClickRowFun($(this), rowId, Modal, arr);

            }

            
        },
        //page: curpagenum,
    }).trigger('reloadGrid');


}

function ShowSup(op) {
    var GridID = "#supGrid";
    if (op !== lastop) {
        $("#supGrid").jqGrid('clearGridData'); //清空表格

        $("#query-sup").click(function () {
            querySup(op)
        })

    }

    $("#sup-modal").dialog({
        width: "auto",
        modal: true,
        //height:500,
        buttons: {
            取消: function () {
                $(this).dialog("close");
            }
        }
    })


    lastop = op;
}

function confirmSelectedGridDataForSup(GridID, Control) {

    var rowId = $(GridID).jqGrid('getGridParam', 'selrow');
    var rowData = $(GridID).jqGrid('getRowData', rowId);

    var grid = $("#modalGrid");
    grid.jqGrid('restoreRow', lastSelection);

    var curRowData = grid.jqGrid('getRowData', lastSelection);
    //curRowData = {"name1":"value1","name2":"value2","name3":"value3"...}   
    if (curRowData['name1'] == "") {
        //dosomething   
    }
    //更改:更改name1的值 
    $.extend(curRowData, {
        "sup": rowData.FNumber,
        "supname": rowData.FName
    })
    grid.jqGrid('setRowData', lastSelection, curRowData);
    SaveRow(grid, lastSelection)
}