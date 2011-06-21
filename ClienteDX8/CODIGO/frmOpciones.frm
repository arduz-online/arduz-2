VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmOpciones 
   BackColor       =   &H00000000&
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   4470
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   4740
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmOpciones.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4470
   ScaleWidth      =   4740
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame1 
      BackColor       =   &H00000000&
      Caption         =   "Video"
      ForeColor       =   &H00FFFFFF&
      Height          =   2055
      Left            =   240
      TabIndex        =   5
      Top             =   1800
      Width           =   4215
      Begin VB.CheckBox hce 
         BackColor       =   &H00000000&
         Caption         =   "Forzar aceleración por software"
         Enabled         =   0   'False
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   1680
         Width           =   3855
      End
      Begin VB.CheckBox Check2 
         BackColor       =   &H00000000&
         Caption         =   "Efectos en el agua"
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   1440
         Width           =   3855
      End
      Begin VB.CheckBox EDS 
         BackColor       =   &H00000000&
         Caption         =   "Efectos del sol"
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   1200
         Width           =   3855
      End
      Begin VB.CheckBox RDL 
         BackColor       =   &H00000000&
         Caption         =   "Radio de luz"
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   960
         Width           =   3855
      End
      Begin VB.CheckBox Check7 
         BackColor       =   &H00000000&
         Caption         =   "Habilitar HotBar"
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   480
         Width           =   3855
      End
      Begin VB.CheckBox LP 
         BackColor       =   &H00000000&
         Caption         =   "Luces Brillantes (PixelShader)"
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   720
         Value           =   1  'Checked
         Width           =   3855
      End
      Begin VB.CheckBox Check5 
         BackColor       =   &H00000000&
         Caption         =   "Limitar FPS"
         Enabled         =   0   'False
         ForeColor       =   &H00E0E0E0&
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Value           =   1  'Checked
         Width           =   3855
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00000000&
      Caption         =   "Audio"
      ForeColor       =   &H00FFFFFF&
      Height          =   1095
      Left            =   240
      TabIndex        =   2
      Top             =   600
      Width           =   4215
      Begin MSComctlLib.Slider Slider1 
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   7
         Top             =   720
         Width           =   3015
         _ExtentX        =   5318
         _ExtentY        =   450
         _Version        =   393216
         BorderStyle     =   1
         Enabled         =   0   'False
         LargeChange     =   10
         Min             =   -4000
         Max             =   0
         TickStyle       =   3
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00000000&
         Caption         =   "Sonidos"
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   855
      End
      Begin MSComctlLib.Slider Slider1 
         Height          =   255
         Index           =   1
         Left            =   1080
         TabIndex        =   4
         Top             =   240
         Width           =   3015
         _ExtentX        =   5318
         _ExtentY        =   450
         _Version        =   393216
         BorderStyle     =   1
         LargeChange     =   10
         Min             =   -4000
         Max             =   0
         TickStyle       =   3
      End
      Begin VB.Label Label3 
         BackColor       =   &H00000000&
         Caption         =   "Volúmen de las pociones:"
         ForeColor       =   &H00C0C0C0&
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   480
         Width           =   3855
      End
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cerrar"
      Height          =   345
      Left            =   240
      MouseIcon       =   "frmOpciones.frx":0152
      MousePointer    =   99  'Custom
      TabIndex        =   0
      Top             =   3960
      Width           =   4215
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Opciones"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   15.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   120
      Width           =   4815
   End
End
Attribute VB_Name = "frmOpciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private loading As Boolean

Private Sub Check1_Click(Index As Integer)
    If Not loading Then _
        Call Audio.Sound_Play(SND_CLICK)
    
    Select Case Index
        Case 1
            If Check1(1).value = vbUnchecked Then
                Slider1(1).Enabled = False
                Slider1(0).Enabled = False
            Else
                'Audio.SoundActivated = True
                Slider1(0).Enabled = True
                Slider1(1).Enabled = True
            End If
            Write_Cfg Sonidos_act, (Not Check1(1).value)
    End Select
End Sub

Private Sub Command2_Click()
    Unload Me
    
If frmMain.Visible = True Then frmMain.SetFocus
End Sub

Private Sub Check2_Click()
SuperWater = CBool(Check2.value)
Write_Cfg eSuperWater, SuperWater
End Sub

Private Sub Check5_Click()
    Engine.Engine_set_max_fps CBool(Check5.value), 100
    Write_Cfg Limitar_Fps, Check5.value
End Sub


Private Sub hce_Click()
    Write_Cfg forzar_software, hce.value
End Sub

Private Sub Check7_Click()
    Write_Cfg Hotbar, Check7.value
    If CBool(Check7.value) Then
        Engine_UI.hotbar_visible = 255
    Else
        Engine_UI.hotbar_visible = 0
    End If
End Sub

Private Sub Form_Load()
    loading = True
    
    load_cfgs
    
    Slider1(0).value = volumenpotas
    Slider1(1).value = volumenfx
    
    If SoundActivated Then
        Check1(1).value = vbChecked
        Slider1(1).Enabled = True
        Slider1(0).Enabled = True

    Else
        Check1(1).value = vbUnchecked
        Slider1(1).Enabled = False
        Slider1(0).Enabled = False
    End If
    
    Check2.value = va(SuperWater)
    
    LP.value = va(Not Read_Cfg(LucesPowa))
    RDL.value = va(useRDL)
    Check5.value = va(limitarr)
    EDS.value = va(useEDS)
    hce.value = va(Force_Software)
    loading = False     'Enable sounds when setting check's values
End Sub

Private Function va(ByVal jo As Variant) As Integer
If jo = 0 Or jo = False Then
va = vbUnchecked
Else
va = vbChecked
End If
End Function

Private Sub RDL_Click()
    useRDL = CBool(RDL.value)
    Write_Cfg RadioDeLuz, RDL.value
End Sub

Private Sub EDS_Click()
    useEDS = CBool(EDS.value)
    Write_Cfg EfectosSol, EDS.value
End Sub

Private Sub Slider1_Change(Index As Integer)
On Error Resume Next
    Select Case Index
        Case 0
            volumenpotas = Slider1(0).value
            Write_Cfg Volumen_potas, volumenpotas
        Case 1
            volumenfx = Slider1(1).value
            Write_Cfg Volumen_fx, volumenfx
    End Select
End Sub

Private Sub Slider1_Scroll(Index As Integer)
On Error Resume Next
    Select Case Index
        Case 0
            volumenpotas = Slider1(0).value
        Case 1
            volumenfx = Slider1(1).value
    End Select
End Sub
