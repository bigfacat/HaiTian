var sourceTable = $("#GridView1");//table id
var sourceTableHeight = sourceTable.height();

var sourceTableHead = $("#GridView1").find("tr").eq(0);//table thead tr id
var headHeight = sourceTableHead.height();//table thead tr height
var sourceTableWidth = sourceTable.outerWidth(); //get source table width
var testDiv = $("#test_width"); //測試獲取內容寬度
var wrapDiv = $("#scroll_wrap"); //滾動條外層div，用於獲取div距離頭部的距離
var tempTop = wrapDiv.offset().top - $(window).scrollTop(); //滾動頭部距離網頁頂部的距離
//copy table and thead html tag from source table,
$('body').append('<div id="shelter"><div id="fixed_table_wrap"><table id="fixed_table"  border="0" cellpadding="4" cellspacing="0" class="table table-hover"><tbody></tbody></table></div></div>');
var fixTopDiv = $("#shelter");
fixTopDiv.hide();
//only set top and left,beacuse i need the top bar can scroll left
fixTopDiv.css({
    'height': headHeight,
    'position': 'fixed',
    'top': tempTop + "px",
    'left': '0',
    'width': testDiv.width() + "px",
    'overflow': 'hidden'
});
//set target table width equal source table width
$("#fixed_table_wrap,#fixed_table").css({ 'width': sourceTableWidth + "px" });

//only clone tr html and change thead tr id attr
var targetHead = sourceTableHead.clone().attr('id', 'fix_head');
targetHead.appendTo('#fixed_table tbody');
//mark target table thead td width,height equal source table thead td width,height
$("#GridView1 th").each(function (index, value) {
    var tempWidth = $(value).outerWidth();
    var tempHeight = $(value).outerHeight();
    $("#fixed_table th").eq(index).css({ 'width': tempWidth + "px", 'height': tempHeight + "px", 'text-align': 'center' });
});

//Div中內容滾動
wrapDiv.scroll(function () {
    //scroll left method
    var sl = -Math.max(wrapDiv.scrollLeft(), $('document').scrollLeft());
    if (isNaN(sl)) {
        sl = -wrapDiv.scrollLeft();
    }
    //sl = $('body').css('padding-left') + sl;
    sl = 10 + sl;
    fixTopDiv.css("left", sl + 'px');
    var scroll_top = wrapDiv.scrollTop() - headHeight + $(window).scrollTop();
    tempTop = wrapDiv.offset().top - $(window).scrollTop();
    if (tempTop <= 0) {
        tempTop = 0;
    }
    var baseWidth = testDiv.width() + wrapDiv.scrollLeft();
    //control  show or hide
    if (scroll_top >= 0) {
        fixTopDiv.css({ 'top': tempTop + "px", 'width': baseWidth + "px" });
        if (!fixTopDiv.is(':visible')) {
            fixTopDiv.show();
        }
    } else {
        if (fixTopDiv.is(':visible')) {
            fixTopDiv.hide();
        }

    }
});

//瀏覽器srcoll
$(window).on('scroll', function () {
    tempTop = wrapDiv.offset().top - $(window).scrollTop();
    var scroll_top = wrapDiv.scrollTop() - headHeight + $(window).scrollTop();
    var baseWidth = testDiv.width() + wrapDiv.scrollLeft();
    if (tempTop <= 0) {
        tempTop = 0;
    }
    console.log(scroll_top);

    var sl = -Math.max(wrapDiv.scrollLeft(), $('document').scrollLeft());
    if (isNaN(sl)) {
        sl = -wrapDiv.scrollLeft();
    }
    //sl = $('body').css('padding-left') + sl;
    sl = 10 + sl;
    fixTopDiv.css("left", sl + 'px');

    fixTopDiv.css({ 'top': tempTop + "px", 'width': baseWidth + "px" });
    //control  show or hide
    if (scroll_top >= 0) {
        if (!fixTopDiv.is(':visible')) {
            fixTopDiv.show();
        }
    } else {
        if (fixTopDiv.is(':visible')) {
            fixTopDiv.hide();
        }
    }
});
