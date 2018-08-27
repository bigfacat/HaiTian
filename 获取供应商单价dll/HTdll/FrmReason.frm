VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form FrmReason 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "选择原因"
   ClientHeight    =   5625
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   9000
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5625
   ScaleWidth      =   9000
   StartUpPosition =   1  '所有者中心
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid myGrid 
      Height          =   5535
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   8895
      _ExtentX        =   15690
      _ExtentY        =   9763
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
End
Attribute VB_Name = "FrmReason"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public strConn As String
Public rsNew As ADODB.Recordset
Public strReasonNo As String
Public strReasonName As String

Private Sub Form_Load()

    Call RetrieveReasonAndSetValue

End Sub

Private Sub RetrieveReasonAndSetValue()
    On Error GoTo HErr
    
    With Me.myGrid
        .ColWidth(1) = 1800
        .ColWidth(2) = 2500
    End With
    
    '重置Grid数据
    Set myGrid.DataSource = Nothing
    
    If strConn = "" Then
        Set myGrid.DataSource = rsNew
        Exit Sub
    End If
    
    Dim strSql As String
    Dim DBCN   As String
    Dim Cnn    As New ADODB.Connection
    Dim rs     As New ADODB.Recordset
    
    DBCN = strConn
    Cnn.CursorLocation = adUseClient
    Cnn.Open DBCN
    
    strSql = ""
    strSql = "SELECT tsm.FID AS '编码',tsm.FName AS '名称' FROM t_SubMessage AS tsm WHERE tsm.FTypeID = (SELECT tsmt.FTypeID FROM t_SubMesType AS tsmt WHERE tsmt.FName = '原因')"
    
    Set rs = Cnn.Execute(strSql)
    
    If Not rs Is Nothing Then
        If rs.RecordCount > 0 Then
            Set myGrid.DataSource = rs
        End If
    End If
    
    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If
    
    If Not rs Is Nothing Then
        Set rs = Nothing
    End If

    Exit Sub
HErr:

    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If
    
    If Not rs Is Nothing Then
        Set rs = Nothing
    End If

    MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Sub myGrid_DblClick()
On Error GoTo HErr


    Dim r As Long
    With Me.myGrid
        r = .MouseRow
        If r >= .FixedRows And r < .Rows Then
            strReasonNo = .TextMatrix(r, 1) '代码
            strReasonName = .TextMatrix(r, 2) '名称
            
            Me.Hide
        End If
    
    End With

    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "信息提示"
End Sub
