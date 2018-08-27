VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form FrmNGReason 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "不良原因"
   ClientHeight    =   8535
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   12465
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
   ScaleHeight     =   8535
   ScaleWidth      =   12465
   StartUpPosition =   1  '所有者中心
   Begin VB.CommandButton cmdReset 
      BackColor       =   &H000080FF&
      Caption         =   "重置"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   10680
      TabIndex        =   27
      ToolTipText     =   "重置左侧原因内容"
      Top             =   3960
      Width           =   1335
   End
   Begin VB.CommandButton cmdDelete 
      BackColor       =   &H000080FF&
      Caption         =   "删除"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   9240
      TabIndex        =   26
      ToolTipText     =   "删除选中行原因记录"
      Top             =   3960
      Width           =   1335
   End
   Begin VB.Frame Fra 
      Caption         =   "维护原因"
      Height          =   5775
      Left            =   120
      TabIndex        =   15
      Top             =   2640
      Width           =   12255
      Begin VB.CommandButton cmdSave 
         BackColor       =   &H000080FF&
         Caption         =   "保存"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   600
         Left            =   7680
         MaskColor       =   &H8000000F&
         TabIndex        =   25
         ToolTipText     =   "保存原因记录并显示在下表体中"
         Top             =   1320
         Width           =   1335
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid myGrid 
         Height          =   3375
         Left            =   240
         TabIndex        =   24
         Top             =   2160
         Width           =   11775
         _ExtentX        =   20770
         _ExtentY        =   5953
         _Version        =   393216
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   2
      End
      Begin VB.TextBox txtRemarks 
         Height          =   735
         Left            =   1800
         TabIndex        =   23
         Top             =   1320
         Width           =   5655
      End
      Begin VB.TextBox txtReasonQty 
         Height          =   375
         Left            =   1800
         TabIndex        =   21
         Top             =   840
         Width           =   2295
      End
      Begin VB.CommandButton cmdReason 
         Caption         =   "筛选"
         Height          =   360
         Left            =   4200
         TabIndex        =   19
         ToolTipText     =   "选择原因辅助资料"
         Top             =   360
         Width           =   735
      End
      Begin VB.TextBox txtReasonNo 
         Enabled         =   0   'False
         Height          =   375
         Left            =   1800
         TabIndex        =   17
         Top             =   360
         Width           =   2295
      End
      Begin VB.Label lbl333 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "备注"
         Height          =   195
         Left            =   840
         TabIndex        =   22
         Top             =   1440
         Width           =   360
      End
      Begin VB.Label lbl23 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "数量"
         Height          =   195
         Left            =   840
         TabIndex        =   20
         Top             =   960
         Width           =   360
      End
      Begin VB.Label lblReasonName 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Height          =   195
         Left            =   5160
         TabIndex        =   18
         Top             =   480
         Width           =   45
      End
      Begin VB.Label lbl11 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "原因"
         Height          =   195
         Left            =   840
         TabIndex        =   16
         Top             =   480
         Width           =   360
      End
   End
   Begin VB.TextBox txtSourceDate 
      Enabled         =   0   'False
      Height          =   375
      Left            =   7560
      TabIndex        =   8
      Top             =   480
      Width           =   2295
   End
   Begin VB.TextBox txtSourceEntryID 
      Enabled         =   0   'False
      Height          =   375
      Left            =   1920
      TabIndex        =   6
      Top             =   1440
      Width           =   2295
   End
   Begin VB.TextBox txtSourceBillNo 
      Enabled         =   0   'False
      Height          =   375
      Left            =   1920
      TabIndex        =   4
      Top             =   960
      Width           =   2295
   End
   Begin VB.Frame FraSource 
      Caption         =   "源单信息"
      Height          =   2415
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   12255
      Begin VB.TextBox txtQty 
         Enabled         =   0   'False
         Height          =   375
         Left            =   1800
         TabIndex        =   14
         Top             =   1800
         Width           =   2295
      End
      Begin VB.TextBox txtStock 
         Enabled         =   0   'False
         Height          =   375
         Left            =   7440
         TabIndex        =   12
         Top             =   1320
         Width           =   2295
      End
      Begin VB.TextBox txtICItem 
         Enabled         =   0   'False
         Height          =   375
         Left            =   7440
         TabIndex        =   10
         Top             =   840
         Width           =   2295
      End
      Begin VB.TextBox txtSourceType 
         Enabled         =   0   'False
         Height          =   375
         Left            =   1800
         TabIndex        =   2
         Top             =   360
         Width           =   2295
      End
      Begin VB.Label lbl8 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "数量"
         Height          =   195
         Left            =   840
         TabIndex        =   13
         Top             =   1920
         Width           =   360
      End
      Begin VB.Label lbl6 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "仓库"
         Height          =   195
         Left            =   6480
         TabIndex        =   11
         Top             =   1440
         Width           =   360
      End
      Begin VB.Label lbl5 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "物料代码"
         Height          =   195
         Left            =   6480
         TabIndex        =   9
         Top             =   930
         Width           =   720
      End
      Begin VB.Label lbl4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "源单日期"
         Height          =   195
         Left            =   6480
         TabIndex        =   7
         Top             =   480
         Width           =   720
      End
      Begin VB.Label lbl2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "源单行号"
         Height          =   195
         Left            =   840
         TabIndex        =   5
         Top             =   1440
         Width           =   720
      End
      Begin VB.Label lbl1 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "源单单号"
         Height          =   195
         Left            =   840
         TabIndex        =   3
         Top             =   930
         Width           =   720
      End
      Begin VB.Label lbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "源单类型"
         Height          =   195
         Left            =   840
         TabIndex        =   1
         Top             =   480
         Width           =   720
      End
   End
End
Attribute VB_Name = "FrmNGReason"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'1.页面加载后，显示原因记录（如果有的话）
'2.点击筛选按钮，弹出K/3选择辅助资料（原因）的界面
'3.点击保存按钮，保存原因维护记录到表并刷新下表体数据
'4.点击删除按钮，删除选中项

Public strConn As String
Private bFirstActive As Boolean
Private colFID As String

Private Sub cmdDelete_Click()
On Error GoTo HErr

    If colFID = "" Then
        MsgBox "请选择具体的行数据进行删除", vbInformation, "信息提示"
        Exit Sub
    End If
    
    Dim strSql As String
    Dim DBCN   As String
    Dim Cnn    As New ADODB.Connection
    
    DBCN = strConn
    Cnn.CursorLocation = adUseClient
    Cnn.Open DBCN
    
    strSql = ""
    strSql = "DELETE FROM t_DevNGReason WHERE FID = '" & colFID & "'"
        
    Cnn.Execute strSql
    
    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If
    
    MsgBox "删除成功", vbInformation, "信息提示"
    colFID = ""
    Call RetrieveNGReasonAndSetValue
    
    Exit Sub
HErr:
    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If

    MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Sub cmdReason_Click()
    On Error GoTo HErr

    Dim myFrmReason As FrmReason
    Set myFrmReason = New FrmReason
    
    myFrmReason.strConn = strConn
    myFrmReason.Show vbModal
    
    Me.txtReasonNo.Text = myFrmReason.strReasonNo
    Me.lblReasonName.Caption = myFrmReason.strReasonName

    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Function IsNumberic(ByVal strQty As String) As Boolean
On Error GoTo HErr

    Dim dmlQty As Double
    dmlQty = CDbl(strQty)
    
    IsNumberic = True
    
    Exit Function
HErr:
    IsNumberic = False
    
End Function

Private Sub cmdReset_Click()
On Error GoTo HErr

    Me.txtReasonNo.Text = ""
    Me.lblReasonName.Caption = ""
    Me.txtReasonQty.Text = ""
    Me.txtRemarks.Text = ""

    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Sub cmdSave_Click()
On Error GoTo HErr

    If Me.txtReasonNo.Text = "" Then
        MsgBox "请选择原因", vbInformation, "信息提示"
        Exit Sub
    End If
    
    If Me.txtReasonQty.Text = "" Then
        MsgBox "请输入数量", vbInformation, "信息提示"
        Exit Sub
    End If
    
    If IsNumberic(Me.txtReasonQty.Text) = False Then
        MsgBox "请输入正确的数量格式", vbInformation, "信息提示"
        Exit Sub
    End If

    Dim strSql As String
    Dim DBCN   As String
    Dim Cnn    As New ADODB.Connection
    
    DBCN = strConn
    Cnn.CursorLocation = adUseClient
    Cnn.Open DBCN
    
    strSql = ""
    strSql = "INSERT INTO t_DevNGReason(FSourceBillType,FSourceBillNo,FSourceEntryID,FSourceBillDate,FICItemNumber, " & _
                " FStockNumber,FReasonNumber,FReasonQty,FRemarks) VALUES( " & _
                " '" & Me.txtSourceType.Text & "','" & Me.txtSourceBillNo.Text & "','" & Me.txtSourceEntryID.Text & "','" & _
                Me.txtSourceDate.Text & "','" & Me.txtICItem.Text & "','" & Me.txtStock.Text & "','" & Me.txtReasonNo.Text & "','" & _
                Me.txtReasonQty.Text & "','" & Me.txtRemarks.Text & "')"
        
    Cnn.Execute strSql
    
    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If
    
    MsgBox "保存成功", vbInformation, "信息提示"
    Me.txtReasonNo.Text = ""
    Me.lblReasonName.Caption = ""
    Me.txtReasonQty.Text = ""
    Me.txtRemarks.Text = ""
    
    Call RetrieveNGReasonAndSetValue
    
    Exit Sub
HErr:
    If Cnn.State = adStateOpen Then
        Cnn.Close
        Set Cnn = Nothing
    End If

    MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Sub Form_Activate()
    
    If bFirstActive = False Then
        Call RetrieveNGReasonAndSetValue
        bFirstActive = True
    End If
    
End Sub


Private Sub RetrieveNGReasonAndSetValue()
    On Error GoTo HErr
    
'    With Me.myGrid
'        .ColWidth(1) = 1800
'        .ColWidth(2) = 1800
'        .ColWidth(3) = 1800
'        .ColWidth(4) = 1800
'        .ColWidth(5) = 1800
'        .ColWidth(6) = 1800
'        .ColWidth(7) = 1800
'        .ColWidth(8) = 1800
'        .ColWidth(9) = 1800
'        .ColWidth(10) = 1800
'        .ColWidth(11) = 1800
'    End With
    
    '重置Grid数据
    Set myGrid.DataSource = Nothing
    
    Dim strSql As String
    Dim DBCN   As String
    Dim Cnn    As New ADODB.Connection
    Dim rs     As New ADODB.Recordset
    
    DBCN = strConn
    Cnn.CursorLocation = adUseClient
    Cnn.Open DBCN
    
    strSql = ""
    strSql = "SELECT tdn.FSourceBillType AS '源单类型', tdn.FSourceBillNo AS '源单单号', tdn.FSourceEntryID AS '源单行号'," & _
                   " tdn.FSourceBillDate AS '源单日期', tdn.FICItemNumber AS '物料代码', ti.FName AS '物料名称', " & _
                   " tdn.FStockNumber AS '仓库', tdn.FReasonNumber AS '原因代码',tsm.FName as '原因名称', " & _
                   " tdn.FReasonQty AS '数量', tdn.FRemarks AS '备注',tdn.FID " & _
              " FROM t_DevNGReason AS tdn " & _
              " INNER JOIN t_ICItem AS ti ON ti.FNumber = tdn.FICItemNumber " & _
              " INNER JOIN t_SubMessage AS tsm ON tsm.FID = tdn.FReasonNumber " & _
              " INNER JOIN t_SubMesType AS tsmt ON tsmt.FTypeID = tsm.FTypeID " & _
            " WHERE tdn.FSourceBillType = '" & Me.txtSourceType.Text & "' AND tdn.FSourceBillNo = '" & Me.txtSourceBillNo.Text & _
            "' AND tdn.FSourceEntryID = '" & Me.txtSourceEntryID.Text & "' " & _
                " AND tdn.FSourceBillDate = '" & Me.txtSourceDate.Text & _
                "' AND tdn.FICItemNumber = '" & Me.txtICItem.Text & "' AND tdn.FStockNumber = '" & Me.txtStock.Text & "' "
    
    Set rs = Cnn.Execute(strSql)
    
    If Not rs Is Nothing Then
        If rs.RecordCount > 0 Then
            Set myGrid.DataSource = rs
        Else
            Call myGrid.Clear
           MsgBox "查无数据"
        End If
    Else
        Call myGrid.Clear
        MsgBox "查无数据"
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

Private Sub Form_Unload(Cancel As Integer)
    On Error GoTo HErr
    
    Dim dblQty As Double
    dblQty = 0
    
    If myGrid.Rows > 1 Then

        For i = 1 To myGrid.Rows - 1 '从第一行到最后一行遍历循环
        
            If myGrid.TextMatrix(i, 10) <> "" Then
                dblQty = dblQty + CDbl(myGrid.TextMatrix(i, 10))
            End If

        Next i

    End If

    If CDbl(Me.txtQty.Text) <> dblQty Then
        
        If MsgBox("维护的数量总和[" & CStr(dblQty) & "]不等于源单数量[" & Me.txtQty.Text & "]，是否继续退出?", vbYesNo, "确认") = vbNo Then
            Cancel = 1
            Exit Sub
        End If
        
    End If

    Exit Sub
HErr:
    'MsgBox Err.Description, vbCritical, "信息提示"
End Sub

Private Sub myGrid_Click()
On Error GoTo HErr

    Dim r As Long
    With Me.myGrid
        r = .MouseRow
        If r >= .FixedRows And r < .Rows Then
            colFID = .TextMatrix(r, 12) 'FID
        End If
    
    End With

    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "信息提示"
End Sub
