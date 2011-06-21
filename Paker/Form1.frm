VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7590
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   10590
   LinkTopic       =   "Form1"
   ScaleHeight     =   7590
   ScaleWidth      =   10590
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame 
      Caption         =   "Archivos en disco"
      Height          =   6255
      Left            =   120
      TabIndex        =   7
      Top             =   1080
      Width           =   4695
      Begin VB.TextBox Text4 
         Height          =   285
         Left            =   1800
         TabIndex        =   13
         Text            =   "*.bmp;*.png"
         Top             =   600
         Width           =   2175
      End
      Begin VB.TextBox Text2 
         Height          =   285
         Left            =   120
         TabIndex        =   12
         Text            =   "C:\TDS\NOBIN\GRAFICOS\"
         Top             =   240
         Width           =   3855
      End
      Begin VB.FileListBox File1 
         Appearance      =   0  'Flat
         Height          =   4710
         Left            =   120
         MultiSelect     =   2  'Extended
         TabIndex        =   11
         Top             =   960
         Width           =   3855
      End
      Begin VB.CommandButton examinar_in 
         Caption         =   "..."
         Height          =   255
         Left            =   4080
         TabIndex        =   10
         Top             =   240
         Width           =   255
      End
      Begin VB.CommandButton Command9 
         Caption         =   "->"
         Height          =   4695
         Left            =   4080
         TabIndex        =   9
         Top             =   960
         Width           =   495
      End
      Begin VB.CommandButton Command12 
         Caption         =   "Crear nuevo pak con lo que se ve arriba"
         Height          =   375
         Left            =   120
         TabIndex        =   8
         Top             =   5760
         Width           =   3855
      End
      Begin VB.Label Label3 
         Caption         =   "Tipo de archivo / filtro:"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   600
         Width           =   1695
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Enpaquetado"
      Height          =   6135
      Left            =   4920
      TabIndex        =   4
      Top             =   1080
      Width           =   5415
      Begin VB.ListBox List1 
         Appearance      =   0  'Flat
         Height          =   4710
         Left            =   120
         TabIndex        =   6
         Top             =   960
         Width           =   5175
      End
      Begin VB.CommandButton Command8 
         Caption         =   "Extraer Seleccionado"
         Height          =   615
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   1695
      End
   End
   Begin VB.CommandButton mzr2txt 
      Caption         =   "mzr2txt"
      Height          =   255
      Left            =   8880
      TabIndex        =   3
      Top             =   8760
      Visible         =   0   'False
      Width           =   735
   End
   Begin VB.CheckBox cdmChk 
      Caption         =   "C.D.M."
      Height          =   255
      Left            =   3240
      TabIndex        =   2
      Top             =   7320
      Value           =   1  'Checked
      Width           =   855
   End
   Begin VB.CommandButton Command11 
      Caption         =   "Nuevo pak"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   1815
   End
   Begin VB.CommandButton Command13 
      Caption         =   "Abrir pak"
      Height          =   375
      Left            =   2040
      TabIndex        =   0
      Top             =   480
      Width           =   1815
   End
   Begin MSComDlg.CommonDialog cdl 
      Left            =   5880
      Top             =   7320
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label1 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "(nuevo en paquetado)"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   120
      Width           =   10215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim elegido As Integer

Dim Pak As clsPak

Const CDM_UserPrivs As Integer = -1
Const CDM_UserID As Integer = 0

Private Sub Command11_Click()

Dim tmp_pak As clsPak
Dim i As Integer
i = Val(InputBox("Ingrese una cantidad maxima de elementos en el enpaquetado.", , "100"))
If i > Max_Int_Val Then i = Max_Int_Val
Set tmp_pak = New clsPak
t = SaveAs
If Len(t) Then _
tmp_pak.CrearVacio t, i

End Sub

Private Sub Command12_Click()

Dim t As String
t = SaveAs
If Len(t) Then
Dim tmp_pak As clsPak

    Set tmp_pak = New clsPak
    Call tmp_pak.CrearDesdeCarpeta(t, Text2.Text, Text4.Text)
    SetPak tmp_pak
End If

End Sub

Private Sub Command13_Click()
Dim tmp_pak As clsPak
Set tmp_pak = New clsPak
Dim t As String
t = AbrirPak

If t <> "" Then
    If tmp_pak.Cargar(t) Then
        SetPak tmp_pak
    End If
End If

End Sub

Private Sub Command8_Click()
    If Pak Is Nothing Then
        MsgBox "No se selecciono enpaquetado."
        Exit Sub
    End If

    Dim i As Integer
    i = Val(Replace(Split(List1.List(List1.ListIndex), " - ")(0), "*", ""))
    If Pak.Puedo_Extraer(i, CDM_UserPrivs, CDM_UserID) Then
        Pak.Extraer i, App.Path & "\" & Pak.Cabezal_GetFilenameName(Val(List1.List(List1.ListIndex)))
    Else
        Beep
    End If
End Sub

Private Sub Command9_Click()

If Pak Is Nothing Then
    MsgBox "No se selecciono enpaquetado."
    Exit Sub
End If

Dim i As Long
Dim omitir As Boolean
Dim Error As String
Dim MostrarMensaje As Boolean
    For i = 0 To File1.ListCount - 1
        If File1.Selected(i) Then
            Dim TmpInt As Integer
            TmpInt = Val(Split(File1.List(i), ".", 2)(0))
            omitir = False
            Do While TmpInt = 0 And Not omitir
                TmpInt = Val(InputBox("Numero a reemplazar, o añadir (" & File1.List(i) & ")", File1.List(i)))
                If TmpInt = 0 Then 'No ingreso ningun numero para el grafico
                    omitir = (MsgBox("Si no ingresa un número que lo relacione no es posible agregar / modificar el gráfico " & File1.List(i) & " ¿Seguro que deseas no agregarlo?", vbYesNo, File1.List(i)) = vbYes)
                End If
            Loop
            'No quiere agregar el grafico
            If Not omitir Then
                If Pak.Puedo_Editar(TmpInt, CDM_UserPrivs, CDM_UserID) Then
                    Pak.Parchear TmpInt, File1.Path & "\" & File1.List(i)
                                       
                    MostrarMensaje = True
                Else
                    Error = Error & vbNewLine & "No tenés permiso para editar el slot numero " & TmpInt
                End If
            End If
        End If
    Next i
    MsgBox "Listo!"
    If Error <> "" Then MsgBox Error & IIf(MostrarMensaje, vbNewLine & vbNewLine & ">El resto de los archivos se parchearon correctamente.", ""), vbExclamation

End Sub

Private Sub examinar_in_Click()
On Error Resume Next
Text2.Text = FolderBrowse(Me.hWnd, "Seleccione la carpeta", 84, Text2.Text)
File1.Path = Text2.Text
End Sub


Private Sub File1_Click()
'Text1.Text = File1.List(File1.ListIndex)
End Sub

Private Sub File1_DblClick()
Text1.Text = File1.List(File1.ListIndex)
'Command5_Click
Command9_Click
End Sub

Private Sub Form_Load()

Dim tmp_pak As clsPak
    Set tmp_pak = Nothing

End Sub

Private Sub SetPak(obj As clsPak)
If Not obj Is Nothing Then
    Set Pak = Nothing
    Set Pak = obj
    Pak.Add_To_Listbox_Permisos List1, CDM_UserPrivs, CDM_UserID
    Label1.Caption = "Editando: " & Pak.Path_res
Else
    MsgBox "EL objeto no existe."
End If
End Sub


Private Sub Option2_Click(Index As Integer)

End Sub

Private Sub Text2_KeyPress(KeyAscii As Integer)
If KeyAscii = 13 Then
Text2_LostFocus
End If
Me.SetFocus
End Sub

Private Sub Text2_LostFocus()
On Error Resume Next
If Right$(Text2.Text, 1) <> "\" Then Text2.Text = Text2.Text & "\"
File1.Path = Text2.Text
End Sub


Private Sub Text4_Change()
On Error Resume Next
File1.pattern = Text4.Text
End Sub

Function SaveAs() As String
Dim tmp_path As String
cdl.Filter = "Empaquetado aPAK (*.aPAK)|*.aPAK"
cdl.Flags = cdlOFNHideReadOnly
cdl.InitDir = App.Path
cdl.FileName = "Parche.aPAK"
cdl.DefaultExt = "aPAK"
cdl.DialogTitle = "Guardar como..."
cdl.ShowSave
SaveAs = cdl.FileName
End Function

Function AbrirPak() As String
Dim tmp_path As String
cdl.Filter = "Empaquetado aPAK (*.aPAK)|*.aPAK"
cdl.InitDir = App.Path
cdl.FileName = "Parche.aPAK"
cdl.DefaultExt = "aPAK"
cdl.DialogTitle = "Abrir aPAK..."
cdl.ShowOpen
AbrirPak = cdl.FileName
End Function



