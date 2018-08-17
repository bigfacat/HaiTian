$(function () {


    AjaxLoadPublicHtml();

    initButton();
LoadPlugButtonResource();//加载完页面权限再加载按钮权限

})

LoadUserWebPagePermission();


var scrollWidth = 17;
var cellHeight = 26;

window.rowNum = 50;
window.modalRowNum = 10;
window.GridHeight = cellHeight * 20;
window.modalGridHeight = cellHeight * window.modalRowNum;
window.outGridHeight = window.GridHeight + scrollWidth;

window.modalGridWidth_2 = 600;

if (window.screen.height < 800) {

    window.GridHeight = cellHeight * 15;
    window.outGridHeight = window.GridHeight + scrollWidth;

}


window.Save = function (op, user, creator, belongRole, password, passwordRepeat) {

    var modal = this.id;
    if (password != passwordRepeat) {
        $("#msg").text("两次输入的密码不一致！");
        $("#alert").dialog({
            modal: true,
            height: 90
        });
        return false;
    }

    if (user == "") {
        $("#msg").text("用户名不能为空！");
        $("#alert").dialog({
            modal: true,
            height: 90
        });
        return false;
    }

    if (password == "") {
        $("#msg").text("密码不能为空！");
        $("#alert").dialog({
            modal: true,
            height: 90
        });
        return false;
    }

    if (belongRole == "") {
        $("#msg").text("角色不能为空！");
        $("#alert").dialog({
            modal: true,
            height: 90
        });
        return false;
    }


    var PostData = "{\"op\":\"" + op + "\",\"user\":\"" + user + "\",\"creator\":\"" + creator + "\",\"rolename\":\"" + belongRole + "\",\"password\":\"" + password + "\"}";

    $.ajax({
        type: "Post",
        url: "OPUserData.ashx?PostData=" + PostData,
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

            $(modal).dialog("destroy");
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


function saveGridState(GridIDWithout) {
    $.jgrid.saveState(GridIDWithout);
}

function loadGridState(GridIDWithout) {
    $.jgrid.loadState(GridIDWithout);
}

function alertNotSelected(GridID) {

    var rowId = $(GridID).jqGrid('getGridParam', 'selrow');
    if (rowId === null) {
        $("#msg").text("请选择一行数据！");
        myAlert(undefined)
    }
    return rowId;

}

function getDateToday() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var strdate = year + "-" + month + "-" + day;
    return strdate;

}


function myAlert(msg, height, width) {

    $("#alert").dialog({
        modal: true,
        height: 160,
                            buttons: {
            关闭: function () {
                $(this).dialog("close");
            }
        }

    })

    //$( "#alert" ).dialog( "option", "height",105 )//菜单页面有时会报错,因为有两个#alert

    //宽度默认300 
    //$( "#alert" ).dialog( "option", "width",300 )


    if (msg !== "" && msg !== undefined) {
        $("#msg").text(msg);
    }

    if (height !== 0 && height !== undefined) {
        $("#alert").dialog(
            "option", "height", height
        )
    }
    if (width !== 0 && width !== undefined) {
        $("#alert").dialog(
            "option", "width", width
        )
    }


}

function checkUserName() {
        var pageName = $("meta[name=name]").prop("content")

        if (pageName === "login") {
        return true;
    }

    if ($.cookie("Name") === "" || $.cookie("Name") === undefined || $.cookie("Name") === null) {
        var Msg = "登录超时！";
        myAlert(Msg, 90);
        window.setTimeout(function () {
            window.open("login.html", "_self");
        }, 2000);
        return false;
    }
    return true;

}

function alertAjaxError() {
    var msg = "请求服务器失败!";
    myAlert(msg);
    return false;

}

function AjaxLoadPublicHtml() {

    $.ajax({
        url: "public.html",
        type: "GET",
        dataType: "html",
        success: function (result) {
            //正则表达式获取body块  
            var reg = /[\s\S]*<\/body>/g;
            var html = reg.exec(result)[0];
            //然后用filter来筛选对应块对象，如：class='aa'  
            var public = $(html).filter("#public");
            var publichtml = public.html();
            //console.log(publichtml);
            //获取内容后可以插入当前html中
            $("body").append(publichtml)

            progress(); //进度条

            initButton();

            initEmpGridModal();

            checkUserName(); //检查用户名cookie是否还存在

        }
    });
}

function progress() {
    $("#progressbar").progressbar({
        value: false
    });
    
        $("#progress-modal").dialog({
        width: 500,
        height: 75,
            autoOpen:false,
        modal: true,
            draggable: false
    })

}

function showProgressModal(text) {
        $("#progress-modal").dialog("option","title",text)

    $("#progress-modal").dialog("open")
}

function closeProgressModal() {
    $("#progress-modal").dialog("close");
}

function LoadUserWebPagePermission() {
    var pageName = $("meta[name=name]").prop("content")
    var Name = $.cookie("Name")

        if (pageName === "login") {
        return false;
    }

    if (Name === "" || Name === undefined) {
        alert("登录超时！");
        window.open("login.html", "_self");
        return false;
    }

    if (Name.toLowerCase() === "administrator") {
        return false; //管理员拥有无限制的权限
    }

    if (pageName === "menu") {
        return false;
    }
    
    var strPostData = "{\"op\":\"" + "LoadUserWebPagePermission" + "\",\"pagename\":\"" + pageName + "\",\"username\":\"" + Name + "\"}";
    var PostData = {
        "PostData": strPostData
    };

    $.ajax({
        url: "User.ashx",
        type: "Post",
        data: PostData,
        success: function (result) {
            var obj = eval('(' + result + ')');

            if (obj.status === 100) {

            }
            else {
                alert("没有权限！");
                window.open('', '_self');
                window.close();
            }

        },
        error: function (xhr, status, error) {
            alert("请求失败！");
            window.close();

        },
        complete: function (data) {}
    })

}

function LoadPlugButtonResource() {
    var pageName = $("meta[name=name]").prop("content")
    var Name = $.cookie("Name")

        if (Name === "" || Name === undefined) {
        return false;
    }

    if (Name.toLowerCase() === "administrator") {
        ButtonAble("#review")
        ButtonAble("#cancel-review")
        return false; //管理员拥有无限制的权限
    }

    var strPostData = "{\"op\":\"" + "LoadPlugButtonResource" + "\",\"pagename\":\"" + pageName + "\",\"username\":\"" + Name + "\"}";
    var PostData = {
        "PostData": strPostData
    };

    $.ajax({
        url: "User.ashx",
        type: "Post",
        data: PostData,
        success: function (result) {
            var obj = eval('(' + result + ')');

            for (var i=0;i<obj.length;i++) {
var ctl= '#'+obj[i].code;
                ButtonAble(ctl);
            }

        },
        error: function (xhr, status, error) {

        },
        complete: function (data) {}
    })

}

function ButtonAble(ctl) {
                $(ctl).removeProp("disabled")
                $(ctl).removeClass("ui-button-disabled")
                $(ctl).removeClass("ui-state-disabled")

}


function initButton() {
    $("input[type=submit], button,input[type=button]").button();

}

function initEmpGridModal() {

    var Grid = $("#empGrid")
    var GridPager = "#empGridPager"
    var Modal = $("#emp-modal")

    Grid.jqGrid({
        //url: 'GetEmployee.ashx?emp=' + inputemp,
        mtype: "GET",
        datatype: "local",
        page: 1,
        colModel: [{
            label: '职员代码',
            name: 'EmpNumber',
            width: 75,
        }, {
            label: '职员姓名',
            name: 'EmpName',
            width: 75
        }, {
            label: '部门代码',
            name: 'DeptNumber',
            width: 75,
        }, {
            label: '部门名称',
            name: 'DeptName',
            width: 75
        }, ],
        ondblClickRow: function (rowId) {

            var arr = [];
            var obj1 = {};
            obj1.text = "#entry-emp"
            obj1.col = "EmpNumber"
            arr.push(obj1);
            var obj2 = {};
            obj2.text = "#entry-empname"
            obj2.col = "EmpName"
            arr.push(obj2);

            ondblClickRowFun(Grid, rowId, Modal, arr);
        },
        loadonce: true,
        viewrecords: true,
        width: 600,
        height: window.modalGridHeight,
        rowNum: 50,
        pager: GridPager
    })

    Grid.navGrid(GridPager, {
        edit: false,
        add: false,
        del: false,
        search: false,
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

            取消: function () {
                $(this).dialog("close");
            }
        }
    })


}

function ondblClickRowFun(Grid, rowId, Modal, arr) {
    $(this)

    var rowData = Grid.jqGrid('getRowData', rowId);
    for (var i = 0; i < arr.length; i++) {
        var obj = arr[i];
        var text = obj.text;
        var col = obj.col;
        $(text).val(rowData[col]);
    }
    //var GridIDWithout=Grid.prop("id").replace("#","")
    //saveGridState(GridIDWithout);//这里不需要了，因为Grid会自动保存状态
    Modal.dialog("destroy");

}

function ondblClickRowFunConfirm(Grid) {

    var rowId = Grid.jqGrid('getGridParam', 'selrow');

    var fun = Grid.jqGrid('getGridParam', 'ondblClickRow')
    fun(rowId)

}