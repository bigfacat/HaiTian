 $(function () {
        //初始化页面时验证是否记住了密码 

                 if ($.cookie("rmbUser") == "true") {
                $("#rmbUser").attr("checked", true);
                $("#username").val($.cookie("userName"));
                $("#password").val($.cookie("passWord"));
            }

     $("#btnlogin").click(function (){
         
         showProgressModal("登录中");//显示进度条
         
                 //保存用户信息
                if ($("#rmbUser").prop("checked") == true) {
                var userName = $("#username").val();
                var passWord = $("#password").val();
                $.cookie("rmbUser", "true", { expires: 7 }); // 存储一个带7天期限的 cookie 
                $.cookie("userName", userName, { expires: 7 }); // 存储一个带7天期限的 cookie 
                $.cookie("passWord", passWord, { expires: 7 }); // 存储一个带7天期限的 cookie 
            }
            else {
                $.cookie("rmbUser", "false", { expires: -1 });
                $.cookie("userName", '', { expires: -1 });
                $.cookie("passWord", '', { expires: -1 });
            }

         
         var username=$("#username").val();
         var password=$("#password").val();

         $.ajax({
         type: "Post",
         url: "LoginAuthentication.ashx?username="+username+'&password='+password,
         //data: "{PostData:'" + PostData + "',pwd:'" + sel + "'}",
         //contentType: "application/json; charset=utf-8", //发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"
         //dataType: "json", //预期的服务器响应的数据类型
         success: function (data) {
             
             if (data === "100") {
                 
                var Name = $("#username").val();

                $.cookie("Name", Name, { expires: .1 }); // 存储一个带7天期限的 cookie

                 window.open("Menu.html","_self");

             }
             else{
                                 $("#msg").text("账号或密码不正确！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;

             }

         },
         error: function (xhr, status, error) {
                $("#msg").text("请求服务器失败！");
                $("#alert").dialog({
                    modal: true,
                    height: 90
                });
                return false;
         },
         complete: function (data) { //alert(data.responseText)
             closeProgressModal();
         }
     })

     });

 })