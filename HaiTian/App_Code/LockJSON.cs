using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// LockJSON 的摘要说明
/// </summary>
public class LockJSON
{
    public LockJSON()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    private string index;
    public string Index
    {
        get { return index; }
        set { index = value; }
    }

    private string versionid;
    public string VersionID
    {
        get { return versionid; }
        set { versionid = value; }
    }

    private string mo;
    public string MO
    {
        get { return mo; }
        set { mo = value; }
    }

    private string lockdate;
    public string LockDate
    {
        get { return lockdate; }
        set { lockdate = value; }
    }

}