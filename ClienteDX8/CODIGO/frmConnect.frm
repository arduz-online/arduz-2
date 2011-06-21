VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmConnect 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "Arduz Online"
   ClientHeight    =   9000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   12000
   ClipControls    =   0   'False
   FillColor       =   &H00000040&
   Icon            =   "frmConnect.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   600
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   800
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.Timer TimerLinea 
      Interval        =   32
      Left            =   3480
      Top             =   6840
   End
   Begin VB.Timer Timer3 
      Enabled         =   0   'False
      Interval        =   30000
      Left            =   4320
      Top             =   3840
   End
   Begin VB.Timer CronList 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   2400
      Top             =   3840
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   615
      Left            =   2040
      TabIndex        =   6
      Top             =   2760
      Visible         =   0   'False
      Width           =   855
   End
   Begin MSWinsockLib.Winsock weba 
      Left            =   1200
      Top             =   3600
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.CheckBox Check1 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      Caption         =   "Música"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   10755
      TabIndex        =   5
      Top             =   7920
      Width           =   780
   End
   Begin VB.CheckBox hamaa 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      Caption         =   "Hamachi"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   255
      Left            =   9720
      TabIndex        =   4
      Top             =   7920
      Width           =   900
   End
   Begin CLIENTE.ListadoServers lsts 
      Height          =   3975
      Left            =   6120
      TabIndex        =   3
      Top             =   3720
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   7011
      ColorSombra     =   16512
      ColorLabel      =   7506330
      ColorDireccion  =   16777088
      ColorFondo      =   0
      BeginProperty TipoLetraLabels {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty TipoLetraDireccion {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      PunteroItems    =   0
      PunteroImagenItems=   "frmConnect.frx":000C
   End
   Begin VB.TextBox PortTxt 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   255
      Left            =   11040
      TabIndex        =   0
      Text            =   "7666"
      Top             =   3360
      Width           =   555
   End
   Begin VB.TextBox IPTxt 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   255
      Left            =   9120
      TabIndex        =   1
      Text            =   "localhost"
      Top             =   3360
      Width           =   1815
   End
   Begin MSWinsockLib.Winsock wssvr 
      Left            =   720
      Top             =   3600
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Line Line1 
      BorderColor     =   &H0080C0FF&
      X1              =   408
      X2              =   576
      Y1              =   568
      Y2              =   568
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Usuarios online: 0/0"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   255
      Left            =   7920
      TabIndex        =   9
      Top             =   7680
      Width           =   3495
   End
   Begin VB.Label Label 
      BackStyle       =   0  'Transparent
      Caption         =   "Arduz Online v0.2.03"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0E0FF&
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   3615
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Etapa de testeo"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   20.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0E0FF&
      Height          =   615
      Left            =   0
      TabIndex        =   7
      Top             =   120
      Visible         =   0   'False
      Width           =   12015
   End
   Begin VB.Image Image4 
      Height          =   465
      Left            =   360
      MouseIcon       =   "frmConnect.frx":0028
      MousePointer    =   99  'Custom
      Top             =   6120
      Width           =   2130
   End
   Begin VB.Image Image8 
      Height          =   1860
      Index           =   1
      Left            =   2160
      MouseIcon       =   "frmConnect.frx":017A
      MousePointer    =   99  'Custom
      ToolTipText     =   "Click para ir a la web."
      Top             =   600
      Width           =   7770
   End
   Begin VB.Image Image8 
      Height          =   420
      Index           =   0
      Left            =   360
      MouseIcon       =   "frmConnect.frx":02CC
      MousePointer    =   99  'Custom
      ToolTipText     =   "Visitar la página"
      Top             =   8280
      Width           =   4050
   End
   Begin VB.Image Image7 
      Height          =   420
      Left            =   360
      MouseIcon       =   "frmConnect.frx":041E
      MousePointer    =   99  'Custom
      Top             =   7440
      Width           =   1170
   End
   Begin VB.Image Image6 
      Height          =   420
      Left            =   360
      MouseIcon       =   "frmConnect.frx":0570
      MousePointer    =   99  'Custom
      Top             =   6600
      Width           =   1530
   End
   Begin VB.Image Image5 
      Height          =   420
      Left            =   360
      MouseIcon       =   "frmConnect.frx":06C2
      MousePointer    =   99  'Custom
      Top             =   5280
      Width           =   2730
   End
   Begin VB.Image Actualizar 
      Height          =   420
      Left            =   6120
      MouseIcon       =   "frmConnect.frx":0814
      MousePointer    =   99  'Custom
      Top             =   8160
      Width           =   2490
   End
   Begin VB.Image Image3 
      Height          =   420
      Left            =   360
      MouseIcon       =   "frmConnect.frx":0966
      MousePointer    =   99  'Custom
      Top             =   4800
      Width           =   3090
   End
   Begin VB.Image Image2 
      Height          =   420
      Left            =   9240
      MouseIcon       =   "frmConnect.frx":0AB8
      MousePointer    =   99  'Custom
      Top             =   8160
      Width           =   2250
   End
   Begin VB.Image Image1 
      Height          =   375
      Index           =   0
      Left            =   360
      MousePointer    =   99  'Custom
      Top             =   5760
      Width           =   4125
   End
   Begin VB.Label lblStatus 
      BackStyle       =   0  'Transparent
      Caption         =   "Solicitando lista de servidores..."
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   255
      Left            =   6240
      TabIndex        =   2
      Top             =   7920
      Width           =   3495
   End
   Begin VB.Line Line2 
      BorderColor     =   &H00000040&
      X1              =   408
      X2              =   576
      Y1              =   568
      Y2              =   568
   End
End
Attribute VB_Name = "frmConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private ultima_lista_pedida As Long

Private Sub Actualizar_Click()
refresha
End Sub

Public Sub refresha()
If Me.Visible = False Then Exit Sub
If frmMain.Visible = True Then Exit Sub

Static checkeado As Boolean

    If checkeado = False Then
        frmMain.WEBB.Send "updater_check", , CStr(val(GetVar(app.Path & "\Datos\versiones.ini", "A_R_D_U_Z1", "Val")))
        frmMain.WEBB.Send "client_init"
        checkeado = True
        lblStatus.Caption = "Buscando actualizaciones..."
        DoEvents
        Exit Sub
    End If
    
    
    Dim d As Long
    d = timeGetTime
    If (ultima_lista_pedida + 2500) < d Then
        ultima_lista_pedida = d
        TimerLinea = True
        On Error GoTo refresha_Error
        
        Timer3.Enabled = False
        Timer3.Enabled = True
        Timer3.Interval = 30000
        
        lblStatus.Visible = True
        lsts.Resetear (False)
        
        DoEvents
        
        Call Audio.Sound_Play(SND_CLICK)
        
        CronList.Enabled = False
        
        If frmMain.WEBB.Send("server_list", , CInt(hamaa.value)) Then
            lblStatus.Caption = "Solicitando lista de servidores..."
        End If
        
        On Error Resume Next
        With wssvr
            .Close
            .Protocol = sckUDPProtocol
            .RemoteHost = "255.255.255.255"
            .LocalPort = 4112
            .RemotePort = 4111
            .Bind 4112
            DoEvents
            If .State = sckOpen Then
                .SendData CStr("IP")
            End If
        End With
        
        
        Err.Clear
        
        On Error GoTo 0
        
    End If
   Exit Sub

refresha_Error:

    MsgBox "Error " & Err.Number & " (" & Err.Description & ") in procedure refresha of Formulario frmConnect"
End Sub

Private Sub CronList_Timer()
If lblStatus.Caption = "Cargando..." Then
refresha
CronList.Enabled = False
End If
End Sub

Private Sub Check1_Click()
On Error Resume Next
Write_Cfg Musica_act, Check1.value
If Check1.value = vbChecked Then
    play_intro
    frmMain.musicc.Enabled = True
Else
    If Audio.Music_Empty = False Then Audio.Music_Pause
    frmMain.musicc.Enabled = False
End If
End Sub

Private Sub Form_Activate()
'hamaa.Visible = modMAC.hamachi
'On Error Resume Next

Call refresha

End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 27 Then
        prgRun = False
    End If
End Sub

Private Sub Form_Load()
Me.Picture = clsPak_LeerIPicture(pakInterface, 1) 'modZLib.Bin_Resource_Load_Picture(1, rGUI)
Init_Hamachi
Label.Caption = "Arduz Online v" & game_version & " rev " & app.Revision
EngineRun = False
End Sub

Private Sub hamaa_Click()
Call Actualizar_Click
End Sub

Private Sub Image1_Click(Index As Integer)
Call ShellExecute(0, "Open", WEBSERVER & "mi_cuenta.php", "", app.Path, 0)
End Sub

Private Sub Image2_Click()
If Len(IPTxt.Text) > 6 And Len(PortTxt.Text) > 0 Then
    DoEvents
    Call Audio.Sound_Play(SND_CLICK)
    frmOldPersonaje.Show vbModal
End If
End Sub

Private Sub Image3_Click()
On Error GoTo errh
Call Shell(app.Path & "\SERVER.EXE", vbNormalFocus)
Exit Sub
errh:
Call MsgBox("No se encuentra el programa Server.exe", vbCritical, "Arduz Online")
End Sub

Private Sub Image4_Click()
frmOpciones.Show vbModal
End Sub

Private Sub Image5_Click()
Call ShellExecute(0, "Open", WEBSERVER & "ranking.php", "", app.Path, 0)
Exit Sub
End Sub

Private Sub Image6_Click()
Call ShellExecute(0, "Open", WEBSERVER & "ayuda.php", "", app.Path, 0)
End Sub

Private Sub Image7_Click()
prgRun = False
End Sub

Private Sub Image8_Click(Index As Integer)
Call ShellExecute(0, "Open", WEBSERVER & "", "", app.Path, 0)
End Sub

Public Sub crearlista(RD As String)
On Error Resume Next
If RD = "" Then Exit Sub
If InStr(RD, "@") <= 0 Then Exit Sub
Dim i As Integer
Dim j As Integer
Dim total As Integer
Dim total2 As Integer
Dim parts() As String
Dim parts1() As String
  parts = Split(RD, "@|")
  j = UBound(parts)
  For i = 1 To UBound(parts)
    parts1 = Split(parts(i), "ç")
    If UBound(parts1) > 0 Then
    Dim asd As Object
    addsvr parts1(2), parts1(3), parts1(4), parts1(1), parts1(0), CLng(parts1(1)), IIf(Len(parts1(5)) > 0, "True", "")
    total = total + val(parts1(4))
    End If
  Next
  Label2.Caption = "Usuarios online: " & total
End Sub

Sub addsvr(nombresv As String, mapasv As String, jugadoressv As String, modosv As String, ipsv As String, portsv As Long, privado As String)
On Error Resume Next
    lsts.AddItem nombresv, ipsv, portsv, mapasv, "-1", jugadoressv, privado
End Sub

Private Sub lsts_Click(Index As Integer, Item As String, direccion As String, Puerto As Long)
'hamaa.Visible = modMAC.hamachi
Call Audio.Sound_Play(SND_CLICK)
PortTxt.Text = Puerto
IPTxt.Text = direccion
Timer3.Enabled = False
Timer3.Enabled = True
Timer3.Interval = 30000
End Sub

Private Sub lsts_DblClick(Index As Integer, Item As String, direccion As String, Puerto As Long)
DoEvents
frmOldPersonaje.Show vbModal
End Sub


Private Sub Timer3_Timer()
If IsAppActive = True And Me.Visible = True And frmOldPersonaje.Visible = False And frmMain.Visible = False Then refresha
End Sub

Private Sub TimerLinea_Timer()
Dim d As Long
d = timeGetTime
If d - ultima_lista_pedida < 2500 Then
    Line1.Visible = True
    Line2.Visible = True
    
    Line1.x2 = ((d - ultima_lista_pedida) / 2500) * 168 + Line1.x1
Else
    Line1.Visible = False
    Line2.Visible = False
    TimerLinea.Enabled = False
End If
End Sub

Private Sub wssvr_DataArrival(ByVal BytesTotal As Long)
    Dim msg As String
    wssvr.GetData msg, vbString
    If msg Like "*@|*" Then
        Dim parts1() As String
        parts1 = Split(msg, "ç")
        If UBound(parts1) > 0 Then
            addsvr parts1(3), parts1(4), parts1(5), parts1(2), wssvr.RemoteHostIP, CLng(parts1(2)), parts1(6)
        End If
    End If
End Sub
