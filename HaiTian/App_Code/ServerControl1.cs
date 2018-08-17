using System.ComponentModel;
using System.Web.UI;

namespace ServerControl1
{
    [DefaultProperty("Text"), ToolboxData("<{0}:MyTextBox runat=server></{0}:MyTextBox>"), Designer("System.Web.UI.Design.WebControls.PreviewControlDesigner, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")]
    public class MyTextBox : System.Web.UI.WebControls.TextBox
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public MyTextBox() : base()
        {
            //base.Attributes.Add("onfocus", "this.className='" + onFocus + "';");
            //base.Attributes.Add("onblur", "this.className='" + onBlurCss + "';");
            //base.CssClass = CssClass;
        }

        private bool _Lock = false;
        [Bindable(true), Category("Appearance"), Description("锁定")]
        /// <summary>
        /// 文本框是否处于锁定状态
        /// </summary>
        public bool Lock
        {
            get { return _Lock; }
            set { _Lock = value; }
        }

        private string _onBlurCss = "colorblur";
        [Bindable(true), Category("Appearance"), Description("文本框失去焦点时触发")]
        /// <summary>
        /// 失去焦点时样式
        /// </summary>
        public string onBlurCss
        {
            get { return _onBlurCss; }
            set { _onBlurCss = value; }
        }

        private string _Class = "colorblur";
        //public override string CssClass
        //{
        //    get
        //    {
        //        if (ViewState["class"] == null)
        //        {
        //            ViewState["class"] = _Class;
        //        }
        //        return (string)ViewState["class"];
        //    }

        //    set
        //    {
        //        ViewState["class"] = value;
        //    }
        //}

        /// <summary>
        /// 获取焦点的控件ID(如提交按钮等)
        /// </summary>
        [Bindable(true), Category("Appearance"), DefaultValue("")]
        public string SetFocusButtonID
        {
            get
            {
                object o = ViewState[this.ClientID + "_SetFocusButtonID"];
                return (o == null) ? "" : o.ToString();
            }
            set
            {
                ViewState[this.ClientID + "_SetFocusButtonID"] = value;
                if (value != "")
                {
                    this.Attributes.Add("onkeydown", "if(event.keyCode==13){document.getElementById('" + value + "').focus();}");
                }
            }
        }
    }
}