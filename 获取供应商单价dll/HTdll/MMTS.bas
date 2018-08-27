Attribute VB_Name = "MMTS"
Option Explicit

Public strNewUserID As String       '用户内码
Public strNewUserName As String     '用户名称
Public strTime As String            '用户导入长时间

'子系统描述,根据自己系统内容替换
Public SUBID As String
Public SUBNAME As String

'mts share property lockmode
Private Const LOCKMETHOD = 1
Private Const LOCKSETGET = 0
'mts share property
Private Const PROCESS = 1
Private Const STANDARD = 0

Public LoginType As String
'Private m_oSvrMgr As Object 'Server Manager
Private m_oSpmMgr As Object
Private m_oLogin As Object

Public LoginAcctID As Long

'增加多语言处理组件信息
Private Const CONST_K3RESLOADER = "K3ResLoader.Loader"
Private Const CONST_RESFILE = "K3Manufacture"
Public Const CONST_LANGUAGE_CHS = "chs"
Public Const CONST_LANGUAGE_CHT = "cht"
Public Const CONST_LANGUAGE_EN = "en"
Public g_ObjResLoader   As Object
Public g_Language       As String
Public g_ObjResFrmLoader As Object
Public CnnString As String
Enum EnSysFont
    enFontName
    enFontChatset
End Enum

'英语添加空格的方式
Enum EnAppendBlank
    EnAppendBlank_NULL
    EnAppendBlank_PREV
    EnAppendBlank_POST
    EnAppendBlank_BOTH
End Enum

Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long

''
' 临时多语言解析函数
'
' @author waylon
' @date 2004-11-22
' @version
' @remarks v10.2中文翻译前替代LoadKDString用
' @param
' @return
Public Function LoadKDStringTemp(ByVal strGBText As String, _
                            Optional lEnAppendBlank As EnAppendBlank = EnAppendBlank_NULL) As String
    LoadKDStringTemp = LoadKDString(strGBText, lEnAppendBlank)
End Function

'功能：多语言解析函数
'作者：李帆
'日期: 2004-03-12
'版本：V10.1
Public Function LoadKDString(ByVal strGBText As String, _
                            Optional lEnAppendBlank As EnAppendBlank = EnAppendBlank_NULL) As String
    Dim tempErrNumber As Long
    Dim tempErrDescripton As String
    Dim tempErrHelpContext As Variant
    Dim tempErrhelpfile As Variant
    Dim tempErrSource As String
    
    Dim strWords As String  '裁掉前后空格的字符
    Dim strPreBlank As String   '前面的空格
    Dim strPostBlank As String  '后面的空格
    Dim objLanguage As Object
        
    '临时保存传入的Err信息
    If Err.Number <> 0 Then
        tempErrDescripton = Err.Description
        tempErrHelpContext = Err.HelpContext
        tempErrhelpfile = Err.HelpFile
        tempErrSource = Err.Source
        tempErrNumber = Err.Number
    End If
    
    On Error GoTo errHandler
    
    If Len(g_Language) = 0 Then
        g_Language = GetPropertyExt("Language")  '"cht" 'GetConnectionProperty("Language")
        If Len(g_Language) = 0 Then
            Set objLanguage = CreateObject("K3LangInfo.LangInfo")
            g_Language = objLanguage.CurrentLanguage
            Set objLanguage = Nothing
        End If
    End If
    
    If g_ObjResLoader Is Nothing Then
        Set g_ObjResLoader = CreateObject(CONST_K3RESLOADER)
    End If
    
    If g_ObjResLoader.ResFileBaseName <> CONST_RESFILE Then
        g_ObjResLoader.ResFileBaseName = CONST_RESFILE
    End If
    
    If g_ObjResLoader.LanguageID <> g_Language Then
        g_ObjResLoader.LanguageID = g_Language
    End If
    
    '如果有特殊字符，调用LoadspecialKDString
    If InStr(1, strGBText, "^|^") > 0 Then
        LoadKDString = LoadSpecialKDString(strGBText)
        Exit Function
    Else
        '如果是简体中文就不需要调用资源文件
'        If g_Language = CONST_LANGUAGE_CHS Then
'            LoadKDString = strGBText
'        Else
            strWords = Trim(strGBText)
            strPreBlank = VBA.Left$(strGBText, VBA.InStr(1, strGBText, strWords) - 1)
            strPostBlank = VBA.Right$(strGBText, Len(strGBText) - Len(strPreBlank) - Len(strWords))
            
            '需要追加前后空格
            If g_Language = CONST_LANGUAGE_EN Then
                Select Case lEnAppendBlank
                Case EnAppendBlank_NULL
                Case EnAppendBlank_PREV
                    If Len(strPreBlank) = 0 Then
                        strPreBlank = " "
                    End If
                Case EnAppendBlank_POST
                    If Len(strPostBlank) = 0 Then
                        strPostBlank = " "
                    End If
                Case EnAppendBlank_BOTH
                    If Len(strPreBlank) = 0 Then
                        strPreBlank = " "
                    End If
                    If Len(strPostBlank) = 0 Then
                        strPostBlank = " "
                    End If
                End Select
            End If
            
            LoadKDString = strPreBlank & g_ObjResLoader.LoadString(strWords) & strPostBlank
'        End If
    End If
    
    If tempErrNumber <> 0 Then
        Err.Description = tempErrDescripton
        Err.HelpContext = tempErrHelpContext
        Err.HelpFile = tempErrhelpfile
        Err.Source = tempErrSource
        Err.Number = tempErrNumber
    End If
    Exit Function
    
errHandler:
    'LoadKDString = "[×]" & strGBText
    LoadKDString = strGBText
    
    '发版注销
'    Call LogResLoaderErr(strGBText)  '记录翻译错误日志
    '恢复传入Err信息
    If tempErrNumber <> 0 Then
        Err.Description = tempErrDescripton
        Err.HelpContext = tempErrHelpContext
        Err.HelpFile = tempErrhelpfile
        Err.Source = tempErrSource
        Err.Number = tempErrNumber
    End If
    
End Function
Public Function LoadKDString2(ByVal strWord As String) As String '客户端弹出对话框的多语言处理
    Dim tempErrNumber As Long
    Dim tempErrDescripton As String
    Dim tempErrHelpContext As Variant
    Dim tempErrhelpfile As Variant
    Dim tempErrSource As String
    
    '临时保存传入的Err信息
    If Err.Number <> 0 Then
        tempErrDescripton = Err.Description
        tempErrHelpContext = Err.HelpContext
        tempErrhelpfile = Err.HelpFile
        tempErrSource = Err.Source
        tempErrNumber = Err.Number
    End If
    On Error GoTo HANDLEERROR
    Dim LanguageID As String
    
    LanguageID = GetPropertyExt("LANGUAGE")
    If UCase(LanguageID) <> UCase("chs") Then
        If (g_ObjResLoader Is Nothing) Then
            Set g_ObjResLoader = CreateObject(CONST_K3RESLOADER)
        End If
        '资源文件目录
        '       g_objResLoader.ResDirectory = ""
         '资源文件本名
        g_ObjResLoader.ResFileBaseName = CONST_RESFILE
        '语言编号
        g_ObjResLoader.LanguageID = LanguageID
        strWord = Trim(strWord)
        If InStr(1, strWord, "^|^") > 0 Then
             LoadKDString2 = LoadSpecialKDString(strWord) '如果有特殊字符，调用LoadspecialMKDString
        Else
             LoadKDString2 = g_ObjResLoader.LoadString2(Trim(strWord))
        End If
    Else
        strWord = Trim(strWord)
        If InStr(1, strWord, "^|^") > 0 Then
             LoadKDString2 = LoadSpecialKDString(strWord) '如果有特殊字符，调用LoadspecialMKDString
        Else
            LoadKDString2 = strWord
        End If
    End If
    If tempErrNumber <> 0 Then
        Err.Description = tempErrDescripton
        Err.HelpContext = tempErrHelpContext
        Err.HelpFile = tempErrhelpfile
        Err.Source = tempErrSource
        Err.Number = tempErrNumber
    End If
    Exit Function
HANDLEERROR:
        LoadKDString2 = strWord
        If tempErrNumber <> 0 Then
            Err.Description = tempErrDescripton
            Err.HelpContext = tempErrHelpContext
            Err.HelpFile = tempErrhelpfile
            Err.Source = tempErrSource
            Err.Number = tempErrNumber
        End If
End Function
'功能：字符串解析函数，为多语言获取语言参数用
'作者：李帆
'日期：2004-03-12
'版本：V10.1
'2005-02-07 V10.2
'改造为解析整个PropString里面的参数
Public Function GetPropertyExt(ByVal sName As String) As String
    
    On Error Resume Next
'    Dim i As Integer
'    Dim j As Integer
'    Dim sTemp As String
    
'    Dim S As String
'    S = ";"
'    sTemp = IIf(Right(sString, 1) = S, sString, sString & S)
'    sName = sName & "="
'
'    i = InStr(1, sTemp, sName, vbTextCompare)     '不区分大小写
'    If i <> 0 Then
'        sTemp = Right(sTemp, Len(sTemp) - i + 1)
'        j = InStr(1, sTemp, S)
'        If j <> 0 Then
'            sTemp = VBA.Left(sTemp, j - 1)
'            GetPropertyExt = Right(sTemp, Len(sTemp) - Len(sName))
'        End If
'    End If
    Dim strName As String
    Dim strValue As String
    Dim sString As String
    sString = PropsString
    Do
        strName = GetName(sString)
        strValue = GetValue(sString)
        If UCase(strName) = UCase(sName) Then
            Exit Do
        ElseIf strName = "" Then
            Exit Do
        End If
    Loop
    
    GetPropertyExt = strValue
    
    '仅仅测试使用 v10.1 之后会除掉
'    If Len(Trim(GetPropertyExt)) = 0 Then
'        GetPropertyExt = "cht"
'    End If
End Function

'功能：多语言特殊字符串解析函数（为存储过程和触发器用）
'说明：在存储过程中可能有这样的情况@ErrInfo='物料'+ @ItemNumber +'没有设置默认工艺路线' + @OtherInfo
'      在每一段字符串后面增加^|^特殊字符表示分段（最后一个不用加），
'      然后在每一段汉字前面加特殊符号~$~以示区别中文信息和参数，例如：
'      @ErrInfo='~$~物料^|^'+ @ItemNumber +'^|^~$~没有设置默认工艺路线^|^'+@OtherInfo
'作者：李帆
'日期：2004-03-12
'版本：V10.1
Private Function LoadSpecialKDString(ByVal strWord As String) As String
     Dim Vargb As Variant
     Dim i As Long
     Dim StrCh As String
     Vargb = Split(strWord, "^|^")
     StrCh = ""
     For i = 0 To UBound(Vargb)
         If Mid(Vargb(i), 1, 3) = "~$~" Then
            Vargb(i) = Mid(Vargb(i), 4)
            StrCh = StrCh & LoadKDString(Vargb(i))
        Else
            StrCh = StrCh & Vargb(i)
        End If
     Next
     LoadSpecialKDString = StrCh
End Function

'功能：记录ResLoader翻译的错误
'作者：王静
'日期：2004-04-06
'版本：V10.1
Private Sub LogResLoaderErr(ByVal strGBText As String)
    Dim m_fs As Object
    Dim ts As Object
    Dim strLogFile As String
    
    Set m_fs = CreateObject("Scripting.FileSystemObject")
    
    Select Case LCase(g_ObjResLoader.LanguageID)
    Case CONST_LANGUAGE_CHT
        strLogFile = g_ObjResLoader.ResDirectory & "\" & "ResErr_Cht.log"
    Case CONST_LANGUAGE_EN
        strLogFile = g_ObjResLoader.ResDirectory & "\" & "ResErr_En.log"
    Case Else
        strLogFile = g_ObjResLoader.ResDirectory & "\" & "ResErr_Chs.log"
    End Select
    
    Set ts = m_fs.OpenTextFile(strLogFile, 8, True)
    Call ts.WriteLine("[" & CStr(Now) & "]" & strGBText)
    Call ts.Close
    Set ts = Nothing
    Set m_fs = Nothing
End Sub

'功能：修正最后英文里面的空格
'作者：王静
'日期：2004-04-22
'版本：V10.1
Public Function FixEngJointWord(ByVal strEn As String, _
                            Optional bTrim As Boolean = True) As String
    If GetPropertyExt("Language") = CONST_LANGUAGE_EN Then
        While InStr(1, strEn, "  ")
            strEn = Replace$(strEn, "  ", " ")
        Wend
        If bTrim Then
            strEn = Trim$(strEn)
        End If
    End If
    FixEngJointWord = strEn
End Function
'功能：处理窗体控件字体
Public Sub SetFormFont(frm As Object)
    If Len(g_Language) = 0 Then
        g_Language = GetPropertyExt("Language")
    End If
    If g_ObjResFrmLoader Is Nothing Then
        Set g_ObjResFrmLoader = CreateObject("FrmRes.FrmResLoader")
    End If
    g_ObjResFrmLoader.SetFrmFont frm, g_Language
End Sub

'功能：得到当前环境(根据操作系统环境以及用户选择的K3语言)下最合适的字体属性
'返回：字体名称(Font.Name)
Public Function GetSysDefFontName() As String

    Dim tDict As KFO.Dictionary
    If Len(g_Language) = 0 Then
        g_Language = GetPropertyExt("Language")
    End If
    If g_ObjResFrmLoader Is Nothing Then
        Set g_ObjResFrmLoader = CreateObject("FrmRes.FrmResLoader")
    End If
    
    Set tDict = g_ObjResFrmLoader.GetK3FontProps(g_Language)
    GetSysDefFontName = tDict.GetValue("Font.Name")
    
    Set tDict = Nothing
    
End Function

'功能：得到当前环境(根据操作系统环境以及用户选择的K3语言)下最合适的字体属性
'返回：字体编码(Font.Charset)
Public Function GetSysDefCharSet() As Long

    Dim tDict As KFO.Dictionary
    If Len(g_Language) = 0 Then
        g_Language = GetPropertyExt("Language")
    End If
    If g_ObjResFrmLoader Is Nothing Then
        Set g_ObjResFrmLoader = CreateObject("FrmRes.FrmResLoader")
    End If
    
    Set tDict = g_ObjResFrmLoader.GetK3FontProps(g_Language)
    GetSysDefCharSet = CLng(tDict.GetValue("Font.CharSet"))
    
    Set tDict = Nothing
    
End Function

Public Function CheckMts(CFG As Long) As Long
   '检查Mts状态
'''    CheckMts = False
'''    If CFG Then
'''        Dim bChangeMts As Boolean
'''        bChangeMts = CanChangeMtsServer()
'''        Set m_oLogin = Nothing
'''        Set m_oLogin = CreateObject("KDLogin.clsLogin")
'''        If m_oLogin.Login(SUBID, SUBNAME, bChangeMts) Then
'''            CheckMts = True
'''            Call OpenConnection
'''        End If
'''    Else
'''       m_oLogin.ShutDown
'''       Set m_oLogin = Nothing
'''    End If
    CheckMts = False
    If CFG Then
        Dim bFirst As Boolean
        If m_oLogin Is Nothing Then
           bFirst = True
        End If

        Dim bChangeMts As Boolean
        bChangeMts = True
        Set m_oLogin = Nothing
        Set m_oLogin = CreateObject("KDLogin.clsLogin")
        If InStr(1, LoginType, "Straight", vbTextCompare) > 0 And bFirst Then
           If m_oLogin.LoginStraight(SUBID, SUBNAME, LoginAcctID) Then
              CheckMts = True
              Call OpenConnection
           End If
       Else
           If m_oLogin.login(SUBID, SUBNAME, bChangeMts) Then
              CheckMts = True
              Call OpenConnection
           End If
       End If
    Else
       m_oLogin.Shutdown
       Set m_oLogin = Nothing
    End If

End Function
Public Function UserName() As String
If m_oLogin Is Nothing Then
    UserName = GetConnectionProperty("UserName")
Else
    UserName = m_oLogin.UserName
End If
End Function
Public Function UserID() As Integer
If m_oLogin Is Nothing Then
    UserID = GetConnectionProperty("UserID")
Else
    UserID = m_oLogin.UserID
End If
End Function

Public Function PropsString() As String
If m_oLogin Is Nothing Then
    PropsString = GetConnectionProperty("PropsString")
Else
    PropsString = m_oLogin.PropsString
End If
End Function
Public Property Get ServerMgr() As Object
    Set ServerMgr = GetConnectionProperty("KDLogin")
End Property
Public Function IsDemo() As Boolean
If m_oLogin Is Nothing Then
    IsDemo = (GetConnectionProperty("LogStatus") = 2)
Else
    IsDemo = (m_oLogin.LogStatus = 2)
End If
End Function
Public Function AcctName() As String
If m_oLogin Is Nothing Then
    AcctName = GetConnectionProperty("AcctName")
Else
    AcctName = m_oLogin.AcctName
End If
End Function
Public Function AcctID() As String
If m_oLogin Is Nothing Then
    AcctID = GetConnectionProperty("AcctID")
Else
    AcctID = m_oLogin.AcctID
End If
End Function
Private Function GetConnectionProperty(strName As String, Optional ByVal bRaiseError As Boolean = True) As Variant
    On Error GoTo HError
    
    Dim spmMgr As Object
    'Dim spmGroup As Object
    'Dim spmProp As Object
    'Dim bExists As Boolean
    
    'Set spmMgr = CreateObject("MTxSpm.SharedPropertyGroupManager.1")
    'Set spmGroup = spmMgr.CreatePropertyGroup("Info", LockSetGet, Process, bExists)
    
    'Set spmProp = spmGroup.Property(strName)
    'If IsObject(spmProp.Value) Then
    '    Set GetConnectionProperty = spmProp.Value
    'Else
    '    GetConnectionProperty = spmProp.Value
    'End If
    Dim lProc As Long
    lProc = GetCurrentProcessId()
    Set spmMgr = CreateObject("PropsMgr.ShareProps")
    If IsObject(spmMgr.GEtProperty(lProc, strName)) Then
        Set GetConnectionProperty = spmMgr.GEtProperty(lProc, strName)
    Else
        GetConnectionProperty = spmMgr.GEtProperty(lProc, strName)
    End If
    
    Set spmMgr = Nothing
    Exit Function

HError:
    Err.Raise Err.Number, "K3ShopRpt.MMTS.GetConnectionProperty" & vbCrLf & Err.Source, Err.Description
    Set spmMgr = Nothing

End Function
Private Sub OpenConnection()
    'Dim spmMgr As Object
    'Dim spmGroup As Object
    'Dim spmProp As Object
    'Dim bExists As Boolean
    
    'Set spmMgr = CreateObject("MTxSpm.SharedPropertyGroupManager.1")
    'Set spmGroup = spmMgr.CreatePropertyGroup("Info", LockSetGet, Process, bExists)
    'Set spmProp = spmGroup.CreateProperty("UserName", bExists)
    'spmProp.Value = m_oLogin.UserName
    'Set spmProp = spmGroup.CreateProperty("PropsString", bExists)
    'spmProp.Value = m_oLogin.PropsString
    'Set spmProp = spmGroup.CreateProperty("KDLogin", bExists)
    'spmProp.Value = m_oLogin
    Dim lProc As Long
    lProc = GetCurrentProcessId()
    Set m_oSpmMgr = CreateObject("PropsMgr.ShareProps")
    m_oSpmMgr.addproperty lProc, "UserName", m_oLogin.UserName
    m_oSpmMgr.addproperty lProc, "PropsString", m_oLogin.PropsString
    m_oSpmMgr.addproperty lProc, "LogStatus", m_oLogin.LogStatus
    m_oSpmMgr.addproperty lProc, "AcctName", m_oLogin.AcctName
    m_oSpmMgr.addproperty lProc, "AcctID", m_oLogin.AcctID
    m_oSpmMgr.addproperty lProc, "KDLogin", m_oLogin
    m_oSpmMgr.addproperty lProc, "UUID", m_oLogin.UUID
End Sub
Private Sub CloseConnection()
On Error Resume Next
Dim lProc As Long
    lProc = GetCurrentProcessId()
    m_oSpmMgr.delproperty lProc, "UserName"
    m_oSpmMgr.delproperty lProc, "PropsString"
    m_oSpmMgr.delproperty lProc, "LogStatus"
    m_oSpmMgr.delproperty lProc, "AcctName"
    m_oSpmMgr.delproperty lProc, "AcctID"
    m_oSpmMgr.delproperty lProc, "KDLogin"
    m_oSpmMgr.delproperty lProc, "UUID"
    Set m_oSpmMgr = Nothing
End Sub
Public Function IsIndustry() As Boolean
    IsIndustry = (UCase(GetConnectionProperty("AcctType")) = "GY")
End Function

'多语言新增函数
Function LoadResFormat(ByVal strIndexFmt As String, ParamArray arrArgs() As Variant) As String

    Dim arrTemp() As Variant, strRet As String

    strRet = LoadKDString(strIndexFmt)
    arrTemp = arrArgs
    strRet = FormatMsg2(strRet, arrTemp)
    LoadResFormat = strRet
End Function

Private Function SearchString(sBeSearch As String, ByVal sFind As String) As String
    On Error GoTo Err_SearchString
    Dim v As Variant
    v = Split(sBeSearch, sFind, 2, vbTextCompare)
    Dim lb As Integer, ub As Integer
        lb = LBound(v)
        ub = UBound(v)
        If ub > lb Then
            sBeSearch = v(ub)
            SearchString = v(lb)
        ElseIf ub = lb Then
            sBeSearch = ""
            SearchString = v(ub)
        Else
            sBeSearch = ""
            SearchString = ""
        End If
        Exit Function
Err_SearchString:
        sBeSearch = ""
        SearchString = ""
End Function
Private Function GetName(sBeSearch As String) As String
    GetName = SearchString(sBeSearch, "=")
    GetName = Trim$(GetName)
End Function
Private Function GetValue(sBeSearch As String) As String
    sBeSearch = VBA.Trim$(sBeSearch)
    If VBA.Left$(sBeSearch, 1) = "{" Then
        sBeSearch = VBA.Mid$(sBeSearch, 2)
        GetValue = SearchString(sBeSearch, "}")
        SearchString sBeSearch, ";"
    Else
        GetValue = SearchString(sBeSearch, ";")
    End If
        GetValue = VBA.Trim$(GetValue)
End Function


'---------------------------------------------------------------------------------------
' Procedure : GetStdDateSQL
' DateTime  : 04/07/2005 13:57
' Author    : leafinwind
' Purpose   : 获得标准的日期格式的SQL
' RetVal    : String
' Params    :
'---------------------------------------------------------------------------------------
Function GetStdDateSQL(ByVal dtDate As Date) As String
    GetStdDateSQL = "Convert(varchar(10),'" & Format(dtDate, "YYYY-MM-DD") & "',121)"
End Function


'---------------------------------------------------------------------------------------
' Procedure : K3Round
' DateTime  : 2005-07-06 10:57
' Author    : leafinwind
' Purpose   : 四舍五入函数
' RetVal    : Variant
' Params    :
'---------------------------------------------------------------------------------------
Function K3Round(ByVal NumValue As Variant, Optional ByVal RScale As Long = 0, Optional ByVal bStr As Boolean = False) As Variant
    'BT144924 去掉整数时后面的"." MOdeifled By SNOW
    If bStr Then
        K3Round = Format(NumValue, "#,##0" & IIf(RScale > 0, ".", "") & String$(RScale, "0"))
    Else
        K3Round = CDec(Format(NumValue, "#,##0" & IIf(RScale > 0, ".", "") & String$(RScale, "0")))
    End If
End Function

'---------------------------------------------------------------------------------------
' Procedure : K3Ceiling
' DateTime  : 2005-07-06 10:36
' Author    : leafinwind
' Purpose   : 取上限函数
' RetVal    : Variant
' Params    :
'---------------------------------------------------------------------------------------
Function K3Ceiling(ByVal NumValue As Variant, Optional ByVal RScale As Long = 0) As Variant
    Dim var As Variant
    Dim step As Variant
    
    var = CDec(Format(NumValue, "#,##0." & String$(RScale, "0")))
    If var < NumValue Then
        If RScale > 0 Then
            step = CDec("0." & String$(RScale - 1, "0") & "1")
        Else
            step = 1
        End If
        var = var + step
    End If
    
    K3Ceiling = var
End Function


'---------------------------------------------------------------------------------------
' Procedure : K3Floor
' DateTime  : 2005-07-06 10:56
' Author    : leafinwind
' Purpose   : 取下限函数
' RetVal    : Variant
' Params    :
'---------------------------------------------------------------------------------------
Function K3Floor(ByVal NumValue As Variant, Optional ByVal RScale As Long = 0) As Variant
    Dim var As Variant
    Dim step As Variant
    
    var = CDec(Format(NumValue, "#,##0." & String$(RScale, "0")))
    If var > NumValue Then
        If RScale > 0 Then
            step = CDec("0." & String$(RScale - 1, "0") & "1")
        Else
            step = 1
        End If
        var = var - step
    End If
    
    K3Floor = var
End Function
'描述：检查文本框中是否有非法字符（'）
'版本：V10.2SP2
'作者：李帆
'参数：frmMe 传入的窗体对象
'     strSpString 需要检查的字符串
'     strName   需要提示的前缀
'返回值：TRUE 没有非法字符 FALSE 有非法字符
'创建时间：编写该函数的时间
Public Function ShowSpecialChar(ByVal frmMe As Form _
                                , Optional ByVal strSpString As String = "'" _
                                , Optional ByVal strName As String = "") As Boolean
    Dim objText     As Object
    Dim lngCount    As Long
    Dim strChar     As String
 
    On Error Resume Next
    
    ShowSpecialChar = True
    
    If Len(Trim(strSpString)) = 0 Then GoTo Exithandler
    
    If Len(strName) = 0 Then strName = LoadKDString("过滤条件")
    
    For Each objText In frmMe.Controls
        If UCase(TypeName(objText)) = UCase("TextBox") Then
            For lngCount = 1 To Len(strSpString)
                strChar = VBA.Mid(strSpString, lngCount, 1)
                If InStr(objText.Text, strChar) Then
                    MsgBox LoadResFormat("%1错误，可能含有非法字符:%2，请重新输入！", strName, strChar), vbOKOnly + vbInformation, LoadKDString("金蝶提示")
                    ShowSpecialChar = False
                    GoTo Exithandler
                End If
            Next
        End If
    Next
    
    GoTo Exithandler
    
Exithandler:
    Set objText = Nothing
End Function



'---------------------------------------------------------------------------------------
' Procedure : GetBillNoNew wangjing 增加一个新的单据编码规则生成单据编号的函数，不支持核算项目
' DateTime  : 2005-12-16 13:30
' Author    : leafinwind
' Purpose   :
' RetVal    : String
' Params    :
'---------------------------------------------------------------------------------------
Public Function GetBillNoNew(ByVal sDsn As String, _
            ByVal lBillTransType As Long, _
            Optional ByVal bMoreBill As Boolean = False, _
            Optional ByVal lBillNumber As Long = 1, _
            Optional ByVal bUpdate As Boolean = True, _
            Optional ByVal vDict As KFO.Dictionary, _
            Optional ByVal dtCur As Date) As String
            
On Error GoTo HError
    Dim obj             As Object
    Dim ODict           As KFO.Dictionary
    Dim vDictMoreBill   As KFO.Dictionary
    Dim i               As Long
    Dim dtDate As Date
    
    If Not IsMissing(vDict) Then
        If Not (vDict Is Nothing) Then Set ODict = vDict
    End If
          
    Set ODict = New KFO.Dictionary

    If Not IsMissing(dtCur) Then
        dtDate = dtCur
    Else
        dtDate = Date
    End If
    dtDate = CDate(Format(Date, "YYYY-MM-DD"))
    
    ODict("FDate") = dtDate  '单据的默认日期为当前日期
    ODict("FBillType") = lBillTransType  '单据类型
    ODict("BillNumber") = lBillNumber    '起始号
    ODict("AutoUpdateCurNo") = True
    ODict("MoreBillID") = bMoreBill     '是否取多个编码号

    Set obj = CreateObject("K3MBillCodeRule.clsBillCodeRule")
    Set vDictMoreBill = New KFO.Dictionary
    GetBillNoNew = obj.GetNewBillID(MMTS.PropsString, ODict, bUpdate, vDictMoreBill)
    If bMoreBill = True Then
        GetBillNoNew = ""
        For i = 1 To vDictMoreBill.Count
            GetBillNoNew = GetBillNoNew & vDictMoreBill(i) & vbTab
        Next
    End If
    GetBillNoNew = Trim$(GetBillNoNew)
HError:
    Set ODict = Nothing
    Set obj = Nothing
End Function


'---------------------------------------------------------------------------------------
' Procedure : GetBillNoInfo 获取单据编码规则信息 ICBillNo
' DateTime  : 2005-12-16 14:10
' Author    : leafinwind
' Purpose   :
' RetVal    : KFO.Dictionary
' Params    :
' Desc          : 将所有的ADO类型换成Object，保证没有引用ADO的工程可以编译 wangjing 2005-12-30
'---------------------------------------------------------------------------------------
Public Function GetBillNoInfo(ByVal lBillTypeID As Long) As Object
On Error GoTo HErr
    Dim strSql As String
    Dim obj As Object
    Dim rs As Object
    
    strSql = "Select FBillID,FPreLetter,FSufLetter,FCurNo,FFormat" & vbCrLf _
            & ",FCanAlterBillNo,FCheckAfterSave,FUseBillCodeRule " & vbCrLf _
            & "from ICBillNo Where FBillID = " & lBillTypeID
            
    Set obj = CreateObject("K3Connection.AppConnection")
    Set rs = obj.Execute(strSql)
    
    If Not rs Is Nothing Then
        If Not rs.RecordCount = 0 Then
            Set GetBillNoInfo = rs
        End If
    End If
    
    GoTo HExit
HErr:
HExit:
    Set obj = Nothing
    Set rs = Nothing
End Function






