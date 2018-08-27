VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NGReason"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is Industry Bill Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义插件对象接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillTransfer As k3BillTransfer.Bill
Attribute m_BillTransfer.VB_VarHelpID = -1
Private lngRow                    As Long
Private colICItem As Long
Private colSeries As Long
Private colSup As Long
Private colCy As Long
Private colQty As Long
Private colPrice As Long
Private colAmount As Long

 
Public Sub Show(ByVal oBillTransfer As Object)
 
    '接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillTransfer = oBillTransfer
 
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillTransfer = Nothing

End Sub

Private Sub m_BillTransfer_BillInitialize()
 
    m_BillTransfer.AddUserMenuItem "获取供应商单价", ""

End Sub

Private Sub m_BillTransfer_LeveCell(ByVal Col As Long, _
                                    ByVal Row As Long, _
                                    ByVal NewCol As Long, _
                                    ByVal NewRow As Long, _
                                    Cancel As Boolean)
    On Error GoTo HErr
    
    lngRow = Row
    
    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "错误提示m_BillTransfer_LeveCell"
End Sub

Private Sub m_BillTransfer_LoadBillEnd(ByVal ShowType As Long)
    On Error GoTo HErr

    Dim TEntryCtl As Variant
    Dim THeadCtl  As Variant
    Dim i         As Long
    
    TEntryCtl = m_BillTransfer.EntryCtl
    
    For i = 1 To UBound(TEntryCtl)

        If UCase$(TEntryCtl(i).HeadCaption) = "物料代码" Or UCase$(TEntryCtl(i).HeadCaption) = "物料编码" Then
            colICItem = i
        End If
        
        If UCase$(TEntryCtl(i).HeadCaption) = "实际采购数量" Then
            colQty = i
        End If
        
        If UCase$(TEntryCtl(i).HeadCaption) = "供应商" Then
            colSup = i
        End If
        
        If UCase$(TEntryCtl(i).HeadCaption) = "币别" Then
            colCy = i
        End If

        
        If UCase$(TEntryCtl(i).HeadCaption) = "单价(含税)" Then
            colPrice = i
        End If
        
        If UCase$(TEntryCtl(i).HeadCaption) = "采购金额(含税)" Then
            colAmount = i
        End If
                

    Next
    
    
    For i = 0 To UBound(m_BillTransfer.HeadCtl) - 1

        If UCase(m_BillTransfer.HeadCtl(i).Caption) = "产品系列" Then
            colSeries = i
            Exit For
        End If

    Next
    
    'For i = 0 To UBound(m_BillTransfer.HeadCtl) - 1

        'If UCase(m_BillTransfer.HeadCtl(i).Caption) = "物料编码" Or UCase(m_BillTransfer.HeadCtl(i).Caption) = "物料代码" Then
            'colICItem = i
            'Exit For
        'End If

    'Next
    
        
    Exit Sub
HErr:
    MsgBox Err.Description, vbCritical, "错误提示m_BillTransfer_LoadBillEnd"
End Sub

Private Sub m_BillTransfer_UserMenuClick(ByVal Index As Long, ByVal Caption As String)
 
    Select Case Caption

        Case "获取供应商单价"
            '此处添加处理 获取供应商单价 菜单对象的 Click 事件
            
            Dim strICItemNo As String
            Dim strCPXL As String
            Dim Qty As Double
            Dim Price As Double
            Dim Amount As Double
            
            Dim i As Long
            
            Dim DBCN As String
            Dim Cnn  As New ADODB.Connection
            Dim rs   As New ADODB.Recordset
    
            DBCN = m_BillTransfer.CnnString
            Cnn.CursorLocation = adUseClient
            Cnn.Open DBCN

                        
            strCPXL = m_BillTransfer.GetHeadText(colSeries)
            If strCPXL = "" Then
                MsgBox "未选择产品系列", vbInformation, "提示信息"
                Exit Sub
            End If
            
        For i = 1 To 1000
    
            strICItemNo = m_BillTransfer.GetGridText(i, colICItem)
            
        If strICItemNo <> "" Then
      
             Dim strSql As String
    
        
             strSql = "select top 1 isnull(FPrice,0) as FPrice,isnull(per.FNumber,'') FNumber,isnull(c.FNumber,'') as CNumber from t_chanpinxilie cp left join t_Supply s on cp.childmatID=s.FItemID and cp.supID=s.FSupID " & _
             "left join (select *from t_SupplyEntry where  FQuoteTime<=GETDATE() and FDisableDate>=GETDATE()) se " & _
             "on se.FItemID=s.FItemID and se.FSupID=s.FSupID left join t_Supplier per on cp.supID=per.FItemID " & _
             "left join t_Item it on cp.xilieID=it.FItemID left join t_ICItem ic on cp.childmatID=ic.FItemID left join t_Currency c on se.FCyID=c.FCurrencyID " & _
             "where it.FName='" & strCPXL & "' and ic.FNumber='" & strICItemNo & "'"
             
             Set rs = Cnn.Execute(strSql)
              
             If rs.RecordCount <> 0 Then '获取单价、供应商,计算总金额
             Dim strPrice, strSup, strCy As String
             
             strPrice = CStr(rs.Fields("FPrice"))
             strSup = CStr(rs.Fields("FNumber"))
             strCy = CStr(rs.Fields("CNumber"))
             m_BillTransfer.SetGridText i, colPrice, Trim(strPrice)
            ' If strSup <> "" Then
               m_BillTransfer.SetGridText i, colSup, Trim(strSup)
               ' m_BillTransfer.SetGridText i, colSup, 204
            ' End If
             'If strCy <> "" Then
               m_BillTransfer.SetGridText i, colCy, Trim(strCy)
            ' End If
             
             If m_BillTransfer.GetGridText(i, colQty) <> "" Then
             Qty = CDbl(m_BillTransfer.GetGridText(i, colQty))
             Price = CDbl(strPrice)
            ' Amount = Format(Qty * Price, "#.##")
             Amount = Qty * Price
             m_BillTransfer.SetGridText i, colAmount, Amount
             End If
             
             End If
                          
       
        End If
        Next
            
        MsgBox "获取完毕", vbInformation, "提示信息"
            
        Case Else
    End Select

End Sub


