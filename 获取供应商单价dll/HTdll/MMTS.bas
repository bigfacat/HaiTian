Attribute VB_Name = "MMTS"
Option Explicit

Public strNewUserID As String       '�û�����
Public strNewUserName As String     '�û�����
Public strTime As String            '�û����볤ʱ��

'��ϵͳ����,�����Լ�ϵͳ�����滻
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

'���Ӷ����Դ��������Ϣ
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

'Ӣ����ӿո�ķ�ʽ
Enum EnAppendBlank
    EnAppendBlank_NULL
    EnAppendBlank_PREV
    EnAppendBlank_POST
    EnAppendBlank_BOTH
End Enum

Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long

''
' ��ʱ�����Խ�������
'
' @author waylon
' @date 2004-11-22
' @version
' @remarks v10.2���ķ���ǰ���LoadKDString��
' @param
' @return
Public Function LoadKDStringTemp(ByVal strGBText As String, _
                            Optional lEnAppendBlank As EnAppendBlank = EnAppendBlank_NULL) As String
    LoadKDStringTemp = LoadKDString(strGBText, lEnAppendBlank)
End Function

'���ܣ������Խ�������
'���ߣ��
'����: 2004-03-12
'�汾��V10.1
Public Function LoadKDString(ByVal strGBText As String, _
                            Optional lEnAppendBlank As EnAppendBlank = EnAppendBlank_NULL) As String
    Dim tempErrNumber As Long
    Dim tempErrDescripton As String
    Dim tempErrHelpContext As Variant
    Dim tempErrhelpfile As Variant
    Dim tempErrSource As String
    
    Dim strWords As String  '�õ�ǰ��ո���ַ�
    Dim strPreBlank As String   'ǰ��Ŀո�
    Dim strPostBlank As String  '����Ŀո�
    Dim objLanguage As Object
        
    '��ʱ���洫���Err��Ϣ
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
    
    '����������ַ�������LoadspecialKDString
    If InStr(1, strGBText, "^|^") > 0 Then
        LoadKDString = LoadSpecialKDString(strGBText)
        Exit Function
    Else
        '����Ǽ������ľͲ���Ҫ������Դ�ļ�
'        If g_Language = CONST_LANGUAGE_CHS Then
'            LoadKDString = strGBText
'        Else
            strWords = Trim(strGBText)
            strPreBlank = VBA.Left$(strGBText, VBA.InStr(1, strGBText, strWords) - 1)
            strPostBlank = VBA.Right$(strGBText, Len(strGBText) - Len(strPreBlank) - Len(strWords))
            
            '��Ҫ׷��ǰ��ո�
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
    'LoadKDString = "[��]" & strGBText
    LoadKDString = strGBText
    
    '����ע��
'    Call LogResLoaderErr(strGBText)  '��¼���������־
    '�ָ�����Err��Ϣ
    If tempErrNumber <> 0 Then
        Err.Description = tempErrDescripton
        Err.HelpContext = tempErrHelpContext
        Err.HelpFile = tempErrhelpfile
        Err.Source = tempErrSource
        Err.Number = tempErrNumber
    End If
    
End Function
Public Function LoadKDString2(ByVal strWord As String) As String '�ͻ��˵����Ի���Ķ����Դ���
    Dim tempErrNumber As Long
    Dim tempErrDescripton As String
    Dim tempErrHelpContext As Variant
    Dim tempErrhelpfile As Variant
    Dim tempErrSource As String
    
    '��ʱ���洫���Err��Ϣ
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
        '��Դ�ļ�Ŀ¼
        '       g_objResLoader.ResDirectory = ""
         '��Դ�ļ�����
        g_ObjResLoader.ResFileBaseName = CONST_RESFILE
        '���Ա��
        g_ObjResLoader.LanguageID = LanguageID
        strWord = Trim(strWord)
        If InStr(1, strWord, "^|^") > 0 Then
             LoadKDString2 = LoadSpecialKDString(strWord) '����������ַ�������LoadspecialMKDString
        Else
             LoadKDString2 = g_ObjResLoader.LoadString2(Trim(strWord))
        End If
    Else
        strWord = Trim(strWord)
        If InStr(1, strWord, "^|^") > 0 Then
             LoadKDString2 = LoadSpecialKDString(strWord) '����������ַ�������LoadspecialMKDString
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
'���ܣ��ַ�������������Ϊ�����Ի�ȡ���Բ�����
'���ߣ��
'���ڣ�2004-03-12
'�汾��V10.1
'2005-02-07 V10.2
'����Ϊ��������PropString����Ĳ���
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
'    i = InStr(1, sTemp, sName, vbTextCompare)     '�����ִ�Сд
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
    
    '��������ʹ�� v10.1 ֮������
'    If Len(Trim(GetPropertyExt)) = 0 Then
'        GetPropertyExt = "cht"
'    End If
End Function

'���ܣ������������ַ�������������Ϊ�洢���̺ʹ������ã�
'˵�����ڴ洢�����п��������������@ErrInfo='����'+ @ItemNumber +'û������Ĭ�Ϲ���·��' + @OtherInfo
'      ��ÿһ���ַ�����������^|^�����ַ���ʾ�ֶΣ����һ�����üӣ���
'      Ȼ����ÿһ�κ���ǰ����������~$~��ʾ����������Ϣ�Ͳ��������磺
'      @ErrInfo='~$~����^|^'+ @ItemNumber +'^|^~$~û������Ĭ�Ϲ���·��^|^'+@OtherInfo
'���ߣ��
'���ڣ�2004-03-12
'�汾��V10.1
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

'���ܣ���¼ResLoader����Ĵ���
'���ߣ�����
'���ڣ�2004-04-06
'�汾��V10.1
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

'���ܣ��������Ӣ������Ŀո�
'���ߣ�����
'���ڣ�2004-04-22
'�汾��V10.1
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
'���ܣ�������ؼ�����
Public Sub SetFormFont(frm As Object)
    If Len(g_Language) = 0 Then
        g_Language = GetPropertyExt("Language")
    End If
    If g_ObjResFrmLoader Is Nothing Then
        Set g_ObjResFrmLoader = CreateObject("FrmRes.FrmResLoader")
    End If
    g_ObjResFrmLoader.SetFrmFont frm, g_Language
End Sub

'���ܣ��õ���ǰ����(���ݲ���ϵͳ�����Լ��û�ѡ���K3����)������ʵ���������
'���أ���������(Font.Name)
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

'���ܣ��õ���ǰ����(���ݲ���ϵͳ�����Լ��û�ѡ���K3����)������ʵ���������
'���أ��������(Font.Charset)
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
   '���Mts״̬
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

'��������������
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
' Purpose   : ��ñ�׼�����ڸ�ʽ��SQL
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
' Purpose   : �������뺯��
' RetVal    : Variant
' Params    :
'---------------------------------------------------------------------------------------
Function K3Round(ByVal NumValue As Variant, Optional ByVal RScale As Long = 0, Optional ByVal bStr As Boolean = False) As Variant
    'BT144924 ȥ������ʱ�����"." MOdeifled By SNOW
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
' Purpose   : ȡ���޺���
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
' Purpose   : ȡ���޺���
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
'����������ı������Ƿ��зǷ��ַ���'��
'�汾��V10.2SP2
'���ߣ��
'������frmMe ����Ĵ������
'     strSpString ��Ҫ�����ַ���
'     strName   ��Ҫ��ʾ��ǰ׺
'����ֵ��TRUE û�зǷ��ַ� FALSE �зǷ��ַ�
'����ʱ�䣺��д�ú�����ʱ��
Public Function ShowSpecialChar(ByVal frmMe As Form _
                                , Optional ByVal strSpString As String = "'" _
                                , Optional ByVal strName As String = "") As Boolean
    Dim objText     As Object
    Dim lngCount    As Long
    Dim strChar     As String
 
    On Error Resume Next
    
    ShowSpecialChar = True
    
    If Len(Trim(strSpString)) = 0 Then GoTo Exithandler
    
    If Len(strName) = 0 Then strName = LoadKDString("��������")
    
    For Each objText In frmMe.Controls
        If UCase(TypeName(objText)) = UCase("TextBox") Then
            For lngCount = 1 To Len(strSpString)
                strChar = VBA.Mid(strSpString, lngCount, 1)
                If InStr(objText.Text, strChar) Then
                    MsgBox LoadResFormat("%1���󣬿��ܺ��зǷ��ַ�:%2�����������룡", strName, strChar), vbOKOnly + vbInformation, LoadKDString("�����ʾ")
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
' Procedure : GetBillNoNew wangjing ����һ���µĵ��ݱ���������ɵ��ݱ�ŵĺ�������֧�ֺ�����Ŀ
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
    
    ODict("FDate") = dtDate  '���ݵ�Ĭ������Ϊ��ǰ����
    ODict("FBillType") = lBillTransType  '��������
    ODict("BillNumber") = lBillNumber    '��ʼ��
    ODict("AutoUpdateCurNo") = True
    ODict("MoreBillID") = bMoreBill     '�Ƿ�ȡ��������

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
' Procedure : GetBillNoInfo ��ȡ���ݱ��������Ϣ ICBillNo
' DateTime  : 2005-12-16 14:10
' Author    : leafinwind
' Purpose   :
' RetVal    : KFO.Dictionary
' Params    :
' Desc          : �����е�ADO���ͻ���Object����֤û������ADO�Ĺ��̿��Ա��� wangjing 2005-12-30
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






