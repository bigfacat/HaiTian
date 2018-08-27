Attribute VB_Name = "modParse"
Option Explicit
Private Const cConnectString = "ConnectString"
Private Const cUserName = "UserName"
Private Const cUserID = "UserID"
Private Const cDBMSName = "DBMS Name"
Private Const cDBMSVersion = "DBMS Version"
Private m_colParse As Collection
Private m_sParseString As String

Public Property Get PropsString() As String
    PropsString = m_sParseString
End Property
'Public Property Get UserName() As String
'    UserName = GEtProperty(cUserName)
'End Property
'Public Property Get UserID() As Integer
'    UserID = CInt(GEtProperty(cUserID))
'End Property
Public Property Get ConStr() As String
    ConStr = GEtProperty(cConnectString)
End Property
Public Function GEtProperty(ByVal sPropName As String) As String
    GEtProperty = m_colParse(sPropName)
End Function
Public Function ParseString(ByVal sToParse As String) As Boolean
    Dim sName As String
    Dim sValue As String
        m_sParseString = sToParse
        Set m_colParse = New Collection
        Do
            sName = GetName(sToParse)
            sValue = GetValue(sToParse)
            If sName <> "" Then
                m_colParse.Add sValue, sName
            Else
                Exit Do
            End If
        Loop
        ParseString = True
    
End Function

Private Function GetName(sBeSearch As String) As String
    GetName = SearchString(sBeSearch, "=")
    GetName = Trim$(GetName)
    
End Function
Private Function GetValue(sBeSearch As String) As String
    sBeSearch = Trim$(sBeSearch)
    If Left$(sBeSearch, 1) = "{" Then
        sBeSearch = Mid$(sBeSearch, 2)
        GetValue = SearchString(sBeSearch, "}")
        SearchString sBeSearch, ";"
    Else
        GetValue = SearchString(sBeSearch, ";")
    End If
        GetValue = Trim$(GetValue)
        
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





