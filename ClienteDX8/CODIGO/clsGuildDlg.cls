VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsGuildDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Option Explicit

Private Const p_SEGUNDOS = 7

Private p_CANTIDADDIALOGOS As Byte

Private Type t_GuildDlg
    Texto As String
    Segundos As Integer
    color As Long
End Type

Private extrat As t_GuildDlg
Private extraalpha As Single

Private yoff As Single

Private p_Dialogos() As t_GuildDlg
Private p_Activo As Boolean

Private usedFont As StdFont

Public Property Let CantidadDialogos(ByVal v As Byte)
    If v > 0 Then
        ReDim Preserve p_Dialogos(1 To v) As t_GuildDlg
    End If
    p_CANTIDADDIALOGOS = v
End Property

''
' Removes all dialogs from screen.

Public Sub RemoveDialogs()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/02/07
'Removes all dialogs
'***************************************************
    Dim i As Long
    
    For i = 1 To p_CANTIDADDIALOGOS
        p_Dialogos(i).Texto = vbNullString
    Next i
End Sub

''
' Retrieves the number of dialogs to be displayed on screen.
'
' @return   The number of dialogs to be displayed on screen.

Public Property Get CantidadDialogos() As Byte
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/01/07
'Retrieves the number of dialogs to be displayed on screen
'***************************************************
    CantidadDialogos = p_CANTIDADDIALOGOS
End Property

Public Property Let Activo(ByVal v As Boolean)
    p_Activo = v
End Property

Public Property Get Activo() As Boolean
    Activo = p_Activo
End Property

Private Sub Class_Initialize()
    p_CANTIDADDIALOGOS = 5
    ReDim p_Dialogos(1 To p_CANTIDADDIALOGOS) As t_GuildDlg
    p_Activo = True
End Sub

Public Sub Draw()
Dim i As Byte
Dim YY As Single

If Not p_Activo Then Exit Sub

    
    If extraalpha <= 0 Then
        extraalpha = 0
    Else
        Call Engine.Text_Render_alpha(extrat.Texto, 0, 5, extrat.color, 0, extraalpha)
    End If
    
    
    
    For i = 1 To p_CANTIDADDIALOGOS
        If Len(p_Dialogos(i).Texto) Then
            Call Engine.Text_Render_ext(p_Dialogos(i).Texto, i * 10, 5, 400, 12, p_Dialogos(i).color, console_alpha)
        End If
    Next i
End Sub

Public Sub PassTimer()
Dim i As Byte
extrat = p_Dialogos(1)
extraalpha = 255

For i = 1 To p_CANTIDADDIALOGOS - 1
    p_Dialogos(i) = p_Dialogos(i + 1)
Next i
p_Dialogos(p_CANTIDADDIALOGOS).Segundos = 0
p_Dialogos(p_CANTIDADDIALOGOS).Texto = vbNullString

End Sub




''
' Splits dialogs into lines fitting properly the render area and inserts them

Public Sub PushBackText(ByVal s As String, Optional ByVal color As Long = &HFFFFFF00)
    Dim STR As String
    Dim tmp As Integer
    On Error Resume Next
    Select Case Asc(s)
    Case 3
        color = D3DColorXRGB(ColoresPJ(50).R, ColoresPJ(50).G, ColoresPJ(50).b)
        s = Right$(s, Len(s) - 1)
    Case 4
        color = D3DColorXRGB(ColoresPJ(49).R, ColoresPJ(49).G, ColoresPJ(49).b)
        s = Right$(s, Len(s) - 1)
    Case 5
        color = &HFFCCCCCC
        s = Right$(s, Len(s) - 1)
    End Select
    
    STR = s
    If Len(s) > 128 Then Exit Sub

    
    ' If it's too long to fit, split it
    Do While frmMain.TextWidth(STR) > 500
        tmp = InStrRev(STR, " ")
        
        If tmp = 0 Then Exit Do
        
        STR = Left$(STR, tmp - 1)
    Loop
    
    'Show message and continue with the rest
    Call RealPushBackText(STR, color)
    
    If LenB(STR) <> LenB(s) Then
        Call PushBackText(Right$(s, Len(s) - tmp), color)
    End If
End Sub

Private Sub RealPushBackText(ByVal s As String, Optional ByVal color As Long = &HFFFFFF00)
Dim i As Byte
extrat = p_Dialogos(1)
extraalpha = 255
For i = 1 To p_CANTIDADDIALOGOS - 1
    p_Dialogos(i) = p_Dialogos(i + 1)
Next i
p_Dialogos(p_CANTIDADDIALOGOS).Segundos = 0
p_Dialogos(p_CANTIDADDIALOGOS).Texto = s
p_Dialogos(p_CANTIDADDIALOGOS).color = color
yoff = 10
End Sub
