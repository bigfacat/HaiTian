$(function () {
    $("#edit-password").click(function () {

                                  if(!checkUserName()){
        return false;
                                  }
        
        $("#user-edit").val($.cookie("Name"));

        var obj = new Object();
        obj.id = "#edit-modal";
        obj.Save = Save;

        $("#edit-modal").dialog({
            width: 300,
            modal: true,
            buttons: {
                "保存": function () {

                    var user = $("#user-edit").val();
                    var password = $("#password-edit").val();
                    var passwordRepeat = $("#password-repeat-edit").val();

                    obj.Save(2, user,undefined,undefined, password, passwordRepeat);

                },
                取消: function () {
                    $(this).dialog("close");
                }
            }
        });


    });

    $("#release").click(function () {
        $.cookie("Name","")
    })
});