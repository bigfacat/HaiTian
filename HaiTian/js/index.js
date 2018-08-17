﻿$(function(){
	//页面加载完成之后执行
    pageInit();
    //pageInit2();
});

function pageInit2() {
    $("#list2").jqGrid({
        datatype: "local",
        height: 250,
        colNames: ['编号', '用户名', '性别', '邮箱', 'QQ', '手机号', '出生日期'],
        colModel: [
        { name: 'id', index: 'id', width: 60, sorttype: "int" },
        { name: 'userName', index: 'userName', width: 90 },
        { name: 'gender', index: 'gender', width: 90 },
        { name: 'email', index: 'email', width: 125, sorttype: "string" },
        { name: 'QQ', index: 'QQ', width: 100 },
        { name: 'mobilePhone', index: 'mobilePhone', width: 120 },
        { name: 'birthday', index: 'birthday', width: 100, sorttype: "date" }
        ],
        sortname: 'id',
        sortorder: 'asc',
        viewrecords: true,
        rowNum: 10,
        rowList: [10, 20, 30],
        pager: "#gridPager",
        caption: "第一个jqGrid例子"
    }).navGrid('#pager2', { edit: false, add: false, del: false });
    var mydata = [
    { id: "1", userName: "polaris", gender: "男", email: "fef@163.com", QQ: "33334444", mobilePhone: "13223423424", birthday: "1985-10-01" },
    { id: "2", userName: "李四", gender: "女", email: "faf@gmail.com", QQ: "222222222", mobilePhone: "13223423", birthday: "1986-07-01" },
    { id: "3", userName: "王五", gender: "男", email: "fae@163.com", QQ: "99999999", mobilePhone: "1322342342", birthday: "1985-10-01" },
    { id: "4", userName: "马六", gender: "女", email: "aaaa@gmail.com", QQ: "23333333", mobilePhone: "132234662", birthday: "1987-05-01" },
    { id: "5", userName: "赵钱", gender: "男", email: "4fja@gmail.com", QQ: "22222222", mobilePhone: "1343434662", birthday: "1982-10-01" },
    { id: "6", userName: "小毛", gender: "男", email: "ahfi@yahoo.com", QQ: "4333333", mobilePhone: "1328884662", birthday: "1987-12-01" },
    { id: "7", userName: "小李", gender: "女", email: "note@sina.com", QQ: "21122323", mobilePhone: "13220046620", birthday: "1985-10-01" },
    { id: "8", userName: "小三", gender: "男", email: "oefh@sohu.com", QQ: "242424366", mobilePhone: "1327734662", birthday: "1988-12-01" },
    { id: "9", userName: "孙先", gender: "男", email: "76454533@qq.com", QQ: "76454533", mobilePhone: "132290062", birthday: "1989-11-21" }
    ];
    for (var i = 0; i <= mydata.length; i++)
        jQuery("#list2").jqGrid('addRowData', i + 1, mydata[i]);
}

function pageInit(){
	//创建jqGrid组件
	jQuery("#list2").jqGrid(
			{
			    //url: 'Default.aspx/Test',//组件创建完成之后请求数据的url
			    datatype: "local",//请求数据返回的类型。可选json,xml,txt
			    mtype: 'POST',
				colNames : [ 'Inv No', 'Date', 'Client', 'Amount', 'Tax','Total', 'Notes' ],//jqGrid的列显示名字
				colModel : [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
				             {name : 'id',index : 'id',width : 55}, 
				             {name : 'FFormId',index : 'invdate',width : 90}, 
				             {name : 'BillNo',index : 'name asc, invdate',width : 100}, 
				             {name : 'amount',index : 'amount',width : 80,align : "right"}, 
				             {name : 'tax',index : 'tax',width : 80,align : "right"}, 
				             {name : 'total',index : 'total',width : 80,align : "right"}, 
				             {name : 'note',index : 'note',width : 150,sortable : false} 
				           ],
				rowNum : 10,//一页显示多少条
				rowList : [ 10, 20, 30 ],//可供用户选择一页显示多少条
				pager : '#pager2',//表格页脚的占位符(一般是div)的id
				sortname : 'id',//初始化的时候排序的字段
				sortorder : "desc",//排序方式,可选desc,asc
				mtype : "post",//向后台请求数据的ajax的类型。可选post,get
				viewrecords : true,
				caption : "JSON Example"//表格的标题名字
			});
	/*创建jqGrid的操作按钮容器*/
	/*可以控制界面上增删改查的按钮是否显示*/
	jQuery("#list2").jqGrid('navGrid', '#pager2', { edit: false, add: false, del: false });

}