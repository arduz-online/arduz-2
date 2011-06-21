VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "Mscomctl.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   ClientHeight    =   9000
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   12000
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   Icon            =   "frmMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   600
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   800
   StartUpPosition =   1  'CenterOwner
   Visible         =   0   'False
   Begin VB.CheckBox Checkxd 
      Height          =   495
      Left            =   9360
      TabIndex        =   44
      Top             =   480
      Width           =   615
   End
   Begin VB.Timer TimerConola 
      Interval        =   5000
      Left            =   2760
      Top             =   2160
   End
   Begin VB.Timer TimerClose 
      Interval        =   2000
      Left            =   3240
      Top             =   2160
   End
   Begin VB.CommandButton Command 
      Height          =   375
      Left            =   7080
      TabIndex        =   43
      Top             =   0
      Visible         =   0   'False
      Width           =   1215
   End
   Begin MSWinsockLib.Winsock WEbSOCK 
      Left            =   6120
      Top             =   2160
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      RemotePort      =   80
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   7080
      Top             =   2160
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      MaskColor       =   12632256
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   6600
      Top             =   2160
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer Second 
      Enabled         =   0   'False
      Interval        =   1050
      Left            =   5640
      Top             =   2160
   End
   Begin VB.Timer Timer1 
      Interval        =   200
      Left            =   3720
      Top             =   2160
   End
   Begin VB.Timer SpoofCheck 
      Enabled         =   0   'False
      Interval        =   60000
      Left            =   4680
      Top             =   2160
   End
   Begin VB.CheckBox caca 
      Caption         =   "Check3"
      Height          =   255
      Left            =   8400
      TabIndex        =   42
      Top             =   2280
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.CheckBox Check2 
      Caption         =   "Luces"
      Height          =   255
      Left            =   10920
      TabIndex        =   41
      Top             =   6480
      Value           =   1  'Checked
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton Command10 
      Caption         =   "Reload particles"
      Height          =   375
      Left            =   3960
      TabIndex        =   40
      Top             =   0
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.CheckBox Check1 
      Caption         =   "FPS"
      Height          =   255
      Left            =   10920
      TabIndex        =   39
      Top             =   6240
      Value           =   1  'Checked
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton DespInv 
      Caption         =   "+"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   1
      Left            =   9000
      MouseIcon       =   "frmMain.frx":2CFA
      MousePointer    =   99  'Custom
      TabIndex        =   35
      Top             =   5280
      Visible         =   0   'False
      Width           =   2430
   End
   Begin VB.CommandButton DespInv 
      Caption         =   "-"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   0
      Left            =   9000
      MouseIcon       =   "frmMain.frx":2E4C
      MousePointer    =   99  'Custom
      TabIndex        =   33
      Top             =   2520
      Visible         =   0   'False
      Width           =   2430
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Command4"
      Height          =   375
      Left            =   9360
      TabIndex        =   30
      Top             =   1560
      Width           =   375
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Luces"
      Height          =   375
      Left            =   10800
      TabIndex        =   29
      Top             =   480
      Width           =   855
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   1935
      Left            =   11640
      Max             =   255
      TabIndex        =   28
      Top             =   480
      Width           =   255
   End
   Begin VB.CheckBox ccc 
      Caption         =   "Check1"
      Height          =   255
      Left            =   11400
      TabIndex        =   27
      Top             =   840
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.VScrollBar XX 
      Height          =   855
      Left            =   9240
      Max             =   20
      Min             =   -20
      TabIndex        =   26
      Top             =   720
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.HScrollBar YY 
      Height          =   255
      Left            =   9480
      Max             =   20
      Min             =   -20
      TabIndex        =   25
      Top             =   1320
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.CommandButton Command7 
      Caption         =   "clear"
      Height          =   375
      Left            =   9120
      TabIndex        =   24
      Top             =   1680
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   9840
      TabIndex        =   23
      Text            =   "0"
      Top             =   1560
      Width           =   495
   End
   Begin VB.CommandButton Command8 
      Caption         =   "Command8"
      Height          =   495
      Left            =   9840
      TabIndex        =   22
      Top             =   720
      Width           =   495
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   10440
      TabIndex        =   21
      Text            =   "0"
      Top             =   1560
      Width           =   495
   End
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   11040
      TabIndex        =   20
      Text            =   "0"
      Top             =   1560
      Width           =   495
   End
   Begin VB.CommandButton Command9 
      Caption         =   "Command9"
      Height          =   495
      Left            =   8640
      TabIndex        =   19
      Top             =   960
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.PictureBox PanelDer 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   705
      Left            =   8400
      ScaleHeight     =   47
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   39
      TabIndex        =   1
      Top             =   360
      Visible         =   0   'False
      Width           =   585
      Begin VB.Label lblPorcLvl 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "33.33%"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFF00&
         Height          =   195
         Left            =   360
         TabIndex        =   8
         Top             =   360
         Visible         =   0   'False
         Width           =   585
      End
      Begin VB.Image cmdInfo 
         Height          =   405
         Left            =   1200
         MouseIcon       =   "frmMain.frx":2F9E
         MousePointer    =   99  'Custom
         Top             =   120
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label exp 
         AutoSize        =   -1  'True
         Caption         =   "Exp:"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   6.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   180
         Left            =   120
         TabIndex        =   6
         Top             =   360
         Visible         =   0   'False
         Width           =   3105
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   2
         Left            =   720
         Top             =   360
         Visible         =   0   'False
         Width           =   360
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   1
         Left            =   240
         Top             =   360
         Width           =   360
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   0
         Left            =   600
         Top             =   360
         Visible         =   0   'False
         Width           =   360
      End
      Begin VB.Label GldLbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "1"
         BeginProperty Font 
            Name            =   "MS Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Left            =   240
         TabIndex        =   5
         Top             =   120
         Visible         =   0   'False
         Width           =   105
      End
      Begin VB.Image Image1 
         Height          =   300
         Index           =   1
         Left            =   120
         MouseIcon       =   "frmMain.frx":30F0
         MousePointer    =   99  'Custom
         Top             =   120
         Visible         =   0   'False
         Width           =   1410
      End
      Begin VB.Shape AGUAsp 
         BackColor       =   &H00C00000&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H0000FFFF&
         Height          =   75
         Left            =   120
         Top             =   240
         Visible         =   0   'False
         Width           =   1290
      End
      Begin VB.Shape COMIDAsp 
         BackColor       =   &H0000C000&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H0000FFFF&
         Height          =   75
         Left            =   360
         Top             =   120
         Visible         =   0   'False
         Width           =   1290
      End
      Begin VB.Shape STAShp 
         BackColor       =   &H00003135&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H00004040&
         Height          =   15
         Left            =   360
         Top             =   5760
         Width           =   1410
      End
      Begin VB.Label lbCRIATURA 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   5.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   120
         Left            =   555
         TabIndex        =   4
         Top             =   1965
         Width           =   30
      End
      Begin VB.Label LvlLbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "1"
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   2760
         TabIndex        =   3
         Top             =   6720
         Visible         =   0   'False
         Width           =   105
      End
      Begin VB.Label Label6 
         BackStyle       =   0  'Transparent
         Caption         =   "Nivel"
         ForeColor       =   &H00FFFFFF&
         Height          =   225
         Left            =   2280
         TabIndex        =   2
         Top             =   6720
         Visible         =   0   'False
         Width           =   465
      End
   End
   Begin VB.CommandButton Command6 
      Caption         =   "save"
      Height          =   375
      Left            =   8400
      TabIndex        =   15
      Top             =   1680
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.PictureBox asd 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   1500
      Left            =   5400
      ScaleHeight     =   100
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   105
      TabIndex        =   14
      Top             =   360
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.PictureBox Ph 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   1455
      Left            =   5400
      ScaleHeight     =   97
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   97
      TabIndex        =   13
      Top             =   480
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.PictureBox Pi 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   1455
      Left            =   5400
      ScaleHeight     =   97
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   97
      TabIndex        =   12
      Top             =   480
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Timer musicc 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   5160
      Top             =   2160
   End
   Begin VB.Timer Looperr 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   4200
      Top             =   2160
   End
   Begin VB.TextBox SendTxt 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   45
      MaxLength       =   128
      MultiLine       =   -1  'True
      TabIndex        =   10
      TabStop         =   0   'False
      ToolTipText     =   "Chat"
      Top             =   2085
      Visible         =   0   'False
      Width           =   8250
   End
   Begin VB.PictureBox Picture1 
      Height          =   135
      Left            =   12000
      ScaleHeight     =   75
      ScaleWidth      =   75
      TabIndex        =   9
      Top             =   8520
      Visible         =   0   'False
      Width           =   135
   End
   Begin RichTextLib.RichTextBox RecTxt 
      Height          =   1605
      Left            =   75
      TabIndex        =   0
      TabStop         =   0   'False
      ToolTipText     =   "Mensajes del servidor"
      Top             =   435
      Width           =   8205
      _ExtentX        =   14473
      _ExtentY        =   2831
      _Version        =   393217
      BackColor       =   0
      BorderStyle     =   0
      Enabled         =   -1  'True
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      DisableNoScroll =   -1  'True
      Appearance      =   0
      TextRTF         =   $"frmMain.frx":3242
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.PictureBox renderer 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6180
      Left            =   90
      ScaleHeight     =   412
      ScaleMode       =   0  'User
      ScaleWidth      =   545
      TabIndex        =   11
      Top             =   2400
      Width           =   8175
   End
   Begin CLIENTE.GradientProgressBar mans 
      Height          =   375
      Left            =   8745
      TabIndex        =   16
      Top             =   7005
      Width           =   2850
      _extentx        =   5027
      _extenty        =   661
      gradienttype    =   10
   End
   Begin CLIENTE.GradientProgressBar vids 
      Height          =   375
      Left            =   8745
      TabIndex        =   17
      Top             =   7890
      Width           =   2850
      _extentx        =   5027
      _extenty        =   661
      gradienttype    =   6
   End
   Begin VB.ListBox hlst 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      ForeColor       =   &H00FFFFFF&
      Height          =   2565
      Left            =   8760
      TabIndex        =   34
      TabStop         =   0   'False
      Top             =   3180
      Visible         =   0   'False
      Width           =   2925
   End
   Begin VB.PictureBox picInv 
      Appearance      =   0  'Flat
      BackColor       =   &H00404040&
      BorderStyle     =   0  'None
      CausesValidation=   0   'False
      ClipControls    =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   2985
      Left            =   8760
      MouseIcon       =   "frmMain.frx":32C0
      MousePointer    =   99  'Custom
      ScaleHeight     =   199
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   199
      TabIndex        =   36
      Top             =   3150
      Width           =   2985
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   675
      Left            =   8400
      MouseIcon       =   "frmMain.frx":54CA
      MousePointer    =   99  'Custom
      TabIndex        =   32
      Top             =   2280
      Width           =   1845
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   690
      Left            =   10200
      MouseIcon       =   "frmMain.frx":561C
      MousePointer    =   99  'Custom
      TabIndex        =   31
      Top             =   2280
      Width           =   1845
   End
   Begin VB.Image CmdLanzar 
      Height          =   645
      Left            =   8520
      MouseIcon       =   "frmMain.frx":576E
      MousePointer    =   99  'Custom
      Top             =   5760
      Visible         =   0   'False
      Width           =   1890
   End
   Begin VB.Label cmdMoverHechi 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "v"
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
      Index           =   0
      Left            =   11760
      TabIndex        =   38
      Top             =   3360
      Visible         =   0   'False
      Width           =   135
   End
   Begin VB.Label cmdMoverHechi 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "^"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Index           =   1
      Left            =   11760
      TabIndex        =   37
      Top             =   3120
      Visible         =   0   'False
      Width           =   135
   End
   Begin VB.Image InvEqu 
      Height          =   4110
      Left            =   8415
      Top             =   2340
      Width           =   3540
   End
   Begin VB.Label Label8 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Personaje"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   15.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0E0FF&
      Height          =   435
      Left            =   8640
      TabIndex        =   18
      Top             =   1020
      Width           =   3105
   End
   Begin VB.Image Image1 
      Height          =   180
      Index           =   2
      Left            =   9960
      MouseIcon       =   "frmMain.frx":58C0
      MousePointer    =   99  'Custom
      Top             =   8760
      Width           =   2010
   End
   Begin VB.Image Image1 
      Height          =   180
      Index           =   0
      Left            =   8400
      MouseIcon       =   "frmMain.frx":5A12
      MousePointer    =   99  'Custom
      Top             =   8760
      Width           =   1005
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   4
      Left            =   9360
      MouseIcon       =   "frmMain.frx":5B64
      MousePointer    =   99  'Custom
      Top             =   0
      Width           =   1290
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   3
      Left            =   10920
      MouseIcon       =   "frmMain.frx":5CB6
      MousePointer    =   99  'Custom
      Top             =   0
      Width           =   930
   End
   Begin VB.Image PicResu 
      BorderStyle     =   1  'Fixed Single
      Height          =   510
      Left            =   12120
      Picture         =   "frmMain.frx":5E08
      Stretch         =   -1  'True
      Top             =   8640
      Visible         =   0   'False
      Width           =   510
   End
   Begin VB.Label Coord 
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "(000,00,00)"
      ForeColor       =   &H00303030&
      Height          =   195
      Left            =   120
      TabIndex        =   7
      Top             =   8760
      Width           =   975
   End
   Begin VB.Menu mnuObj 
      Caption         =   "Objeto"
      Visible         =   0   'False
      Begin VB.Menu mnuTirar 
         Caption         =   "Tirar"
      End
      Begin VB.Menu mnuUsar 
         Caption         =   "Usar"
      End
      Begin VB.Menu mnuEquipar 
         Caption         =   "Equipar"
      End
   End
   Begin VB.Menu mnuNpc 
      Caption         =   "NPC"
      Visible         =   0   'False
      Begin VB.Menu mnuNpcDesc 
         Caption         =   "Descripcion"
      End
      Begin VB.Menu mnuNpcComerciar 
         Caption         =   "Comerciar"
         Visible         =   0   'False
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public tX As Byte
Public tY As Byte
Public MouseX As Long
Public MouseY As Long
Public MouseBoton As Long
Public MouseShift As Long
Private clicX As Long
Private clicY As Long

Public pri As Boolean

Public IsPlaying As Byte

Dim PuedeMacrear As Boolean

Dim SecurityKeys As New clsAntiMacros

Public WithEvents WEBB As clsWEBA
Attribute WEBB.VB_VarHelpID = -1

Sub pasarme()
'    cmdMoverHechi(0).Visible = True
'    cmdMoverHechi(1).Visible = True
'    cmdMoverHechi(0).Enabled = False
'    cmdMoverHechi(1).Enabled = False
'    picInv.Visible = False
'    hlst.Visible = False
'    cmdInfo.Visible = False
'    CmdLanzar.Visible = False
'
'    picInv.Visible = False
'    hlst.Visible = False
'    cmdInfo.Visible = False
'    CmdLanzar.Visible = False
'    Label4.Enabled = False
'    Label7.Enabled = False
'    Command1.Visible = True
'    Command2.Visible = True
'    lstClases.Visible = True
'    lstClases.Clear
'    lstClases.AddItem "MAGO"
'    lstClases.AddItem "CLERIGO"
'    lstClases.AddItem "PALADIN"
'    lstClases.AddItem "GUERRERO"
'    lstClases.AddItem "CAZADOR"
'    lstClases.AddItem "ASESINO"
'    lstClases.AddItem "BARDO"
'    lstClases.AddItem "DRUIDA"
'    lstClases.ListIndex = 0
'On Error Resume Next
'    InvEqu.Picture = Nothing
Engine_UI.acc_visible = True
End Sub



Private Sub ccc_Click()
charlist(UserCharIndex).invh = ccc.Value
End Sub

Private Sub CmdLanzar_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If MainTimer.Check(TimersIndex.Work, False) Then
        If UserEstado = 1 Then
            With FontTypes(FontTypeNames.FONTTYPE_INFO)
                Call ShowConsoleMsg("¡¡Estás muerto!!", .red, .green, .blue, .bold, .italic)
            End With
            Exit Sub
        End If
'Engine_UI.hotbar_visible = True
        If UsingSkill <> Magia Then
            frmMain.MousePointer = 2
            UsingSkill = Magia
            UsaMacro = True
        End If
        hechizo_cargado = (hlst.ListIndex + 1) Xor 108
        CmdLanzar.MousePointer = 2
End If
If UsingSkill = Magia Then Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_MAGIA, 100, 100, 120, 0, 0)
End Sub

Private Sub cmdMoverHechi_Click(Index As Integer)
Call Audio.Sound_Play(SND_CLICK)
    If hlst.ListIndex = -1 Then Exit Sub
    Dim sTemp As String

    Select Case Index
        Case 1 'subir
            If hlst.ListIndex = 0 Then Exit Sub
        Case 0 'bajar
            If hlst.ListIndex = hlst.ListCount - 1 Then Exit Sub
    End Select

    Call WriteMoveSpell(Index, hlst.ListIndex + 1)
    
    Select Case Index
        Case 1 'subir
            sTemp = hlst.List(hlst.ListIndex - 1)
            hlst.List(hlst.ListIndex - 1) = hlst.List(hlst.ListIndex)
            hlst.List(hlst.ListIndex) = sTemp
            hlst.ListIndex = hlst.ListIndex - 1
        Case 0 'bajar
            sTemp = hlst.List(hlst.ListIndex + 1)
            hlst.List(hlst.ListIndex + 1) = hlst.List(hlst.ListIndex)
            hlst.List(hlst.ListIndex) = sTemp
            hlst.ListIndex = hlst.ListIndex + 1
    End Select
End Sub

Private Sub Command1_Click()

End Sub

Private Sub Command10_Click()
jojoparticulas
End Sub

Private Sub Command2_Click()

End Sub



Private Sub Command3_Click()
Call Label4_Click
On Error Resume Next
picInv.MousePointer = 0
End Sub

Private Sub Command4_Click()
'charlist(1).Body = BodyData(CInt(InputBox("j")))
'Exit Sub
'Static tmp As Integer
'tmp = tmp + 1
'If tmp > 50 Then tmp = 1
'Me.Caption = tmp
'Engine_FX.BFX_Remove_All
'Engine_FX.BFX_Make 1, 40, 40

'Call SetCharacterFx(1, 34, 0)
'Engine_particles.Particle_Group_Remove_All
'Dim i%
'Engine_particles.Particle_Group_Make i, UserPos.X, UserPos.y, Val(Text1.Text), 1
On Error Resume Next

End Sub

Private Sub Command5_Click()
Static e As Boolean
e = Not e
'new_text = Not new_text
''toggle_lights_powa e
If e = True Then
D3DDevice.SetRenderState D3DRS_FILLMODE, D3DFILL_WIREFRAME
''lColorMod = D3DTOP_MODULATE Or D3DTOP_MODULATE2X
Else
D3DDevice.SetRenderState D3DRS_FILLMODE, D3DFILL_SOLID
''lColorMod = D3DTOP_MODULATE
End If
End Sub

Private Sub Command6_Click()
    frmMain.asd.Picture = frmMain.asd.Image
    frmMain.asd.Refresh
    SavePicture frmMain.asd.Picture, app.Path & "\" & CurMap & "h.bmp"
End Sub

Private Sub Command8_Click()
''Audio.Ambient_Load 1
''Audio.Ambient_Play
''Engine_Landscape.Light_Remove Engine_Landscape.Light_Find(20)
''Engine_Landscape.Light_Create UserPos.X + frmMain.MouseX \ 32 - frmMain.renderer.ScaleWidth \ 64, UserPos.Y + frmMain.MouseY / 32 - frmMain.renderer.ScaleHeight \ 64, 255, 255, 255, 5, 2.5, 20
''charlist(1).Body = BodyData(436)
''charlist(1).Casco = CascoAnimData(7)
''charlist(1).Head = HeadData(40)
''Engine.Char_Start_Anim 1
'
''    charlist(1).hit = 999 * Rnd * 10
''    charlist(1).hit_color = D3DColorXRGB(255, 0, 0)
''    charlist(1).hit_act = 1
''    charlist(1).hit_off = 0
'Engine_particles.Particle_Group_Make 0, charlist(1).Pos.x, charlist(1).Pos.y, 5, 1
'Engine_particles.Particle_Group_Make 0, charlist(1).Pos.x, charlist(1).Pos.y, 9, 2
'Engine_particles.Particle_Group_Make 0, charlist(1).Pos.x - 5, charlist(1).Pos.y, 6, 1
'Engine_particles.Particle_Group_Make 0, charlist(1).Pos.x + 5, charlist(1).Pos.y, 7, 1
charlist(UserCharIndex).luz = Engine_Landscape.Light_Create(charlist(UserCharIndex).Pos.x, charlist(UserCharIndex).Pos.y, 255, 200, 0, 3, 1, 999) ' &HFF, &HFF, &HFF, 3, 1, 1)
'FX_Rayo_Create charlist(1).Pos.X, charlist(1).Pos.Y, 10
End Sub

Private Sub Command9_Click()
jojoparticulas
Me.WindowState = vbNormal
renderasd = True
Me.Visible = True
EngineRun = True
'charlist(UserIndex).luz = Engine_Landscape.Light_Create(charlist(UserIndex).pos.x, charlist(UserIndex).pos.y, 128, 1, 1, 5, 1, 1)
End Sub

Private Sub Form_Activate()
re_render_inventario = True
End Sub

Private Sub Form_Click()
'acc_visible = Not acc_visible
'Render_Radio_Luz = Not Render_Radio_Luz
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
If KeyCode = vbKeyDown Then
    UserDirection = south
ElseIf KeyCode = vbKeyUp Then
    UserDirection = north
ElseIf KeyCode = vbKeyLeft Then
    UserDirection = west
ElseIf KeyCode = vbKeyRight Then
    UserDirection = east
End If
'If KeyCode = vbKeyJ And Label8.Caption = "Menduz" Then
'IScombate = True
'picInv.MousePointer = 15
'mFX_Def_Create charlist(1).Pos.X, charlist(1).Pos.Y, 5
'WriteMartillo 1, 1
'End If
If SendTxt.Visible = False Then
    If KeyCode = vbKeySpace Then
        IScombate = True
        Engine_UI.rank_visible = True
    End If
End If
SecurityKeys.ClickKeyDown KeyCode
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
If KeyAscii = vbKeyDown Then
    UserDirection = south
ElseIf KeyAscii = vbKeyUp Then
    UserDirection = north
ElseIf KeyAscii = vbKeyLeft Then
    UserDirection = west
ElseIf KeyAscii = vbKeyRight Then
    UserDirection = east
End If
'Handle_KeyP KeyAscii
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
If KeyCode = vbKeyDown Or KeyCode = vbKeyUp Or KeyCode = vbKeyLeft Or KeyCode = vbKeyRight Then
    UserDirection = 0
End If
If KeyCode = vbKeyShift Then puede_mover = False
If SecurityKeys.ClickKeyUP(KeyCode) = False Then Exit Sub
    If (Not SendTxt.Visible) Then
            Select Case KeyCode
                Case vbKeySubtract
                    Call WriteInvisible
                Case vbKeyMultiply
                renderfps = Not renderfps
                If Not DialogosClanes Is Nothing Then
                    If puedo_deslimitar Then
                        Engine_Toggle_fps_limit Not renderfps
                        DialogosClanes.PushBackText "LAS FPS ESTÁN " & IIf(renderfps, Chr$(255) & "SIN" & Chr$(255) & " LIMITE", "LIMITADAS")
                    Else
                        DialogosClanes.PushBackText "LAS FPS ESTÁN LIMITADAS POR LOS GMS"
                    End If
                End If
                        
                    
                '    Engine.Engine_Toggle_fps_limit
                    
                Case vbKeyA
                    Call AgarrarItem
                
                Case vbKeyE
                    Call EquiparItem
                
                Case vbKeyN
                    Nombres = Not Nombres

                Case vbKeyO
                    If MainTimer.Check(TimersIndex.UseItemWithU) Then
                        Call WriteWork(eSkill.Ocultarse)
                    End If
                Case vbKeySpace
                    IScombate = False
                    picInv.MousePointer = 0
                    Engine_UI.rank_visible = False
                Case vbKeyU
                    If MainTimer.Check(TimersIndex.UseItemWithU) Then
                        Call UsarItem
                    End If
                Case vbKeyL
                    If MainTimer.Check(TimersIndex.SendRPU) Then
                        Call WriteRequestPositionUpdate
                        Beep
                    End If
                Case vbKeyEnd, vbKeyF6
                        If UserMinMAN = UserMaxMAN Then Exit Sub
                            Call WriteMeditate
            End Select

        End If
    
    Select Case KeyCode
        Case vbKeyF4, vbKeyEscape
            Call WriteQuit
            
        Case vbKeyControl
            If Shift <> 0 Then Exit Sub
            
            If Not MainTimer.Check(TimersIndex.Arrows, False) Then Exit Sub 'Check if arrows interval has finished.
            If Not MainTimer.Check(TimersIndex.CastSpell, False) Then 'Check if spells interval has finished.
                If Not MainTimer.Check(TimersIndex.CastAttack) Then Exit Sub 'Corto intervalo Golpe-Hechizo
            Else
                If Not (MainTimer.Check(TimersIndex.Attack) = True Or UserMeditar = True) Then Exit Sub
            End If
            
            Call WriteAttack
        
        Case vbKeyReturn
                SendTxt.Visible = True
                IScombate = False
                Engine_UI.rank_visible = False
                SendTxt.SetFocus
    End Select
    Engine_UI.Handle_Key KeyCode, Shift
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    MouseBoton = Button
    MouseShift = Shift
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
picInv.MousePointer = vbDefault
clicX = x
    clicY = y
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If prgRun = True Then
        prgRun = False
        Cancel = 1
    End If
End Sub



Private Sub FPS_Click()
jojoparticulas
Me.WindowState = vbNormal
renderasd = True
Me.Visible = True
EngineRun = True
End Sub



Private Sub Label1_Click()

End Sub



Private Sub InvEqu_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
dibujar_tooltip_inv = 0
End Sub

Private Sub Looperr_Timer()
        'Sólo dibujamos si la ventana no está minimizada
'        If prgRun = False Then
'            CMP3.stopMP3
'            Call CloseClient
'            Exit Sub
'        End If
'        If frmMain.WindowState <> vbMinimized And renderasd = True Then 'IsAppActive = True Then
'            Call ShowNextFrame(frmMain.top, frmMain.left, frmMain.MouseX, frmMain.MouseY)
'            Call RenderSounds
'            If frmMain.soycheater.Interval <> 894 Then frmMain.soycheater.Interval = 894
'            Call CheckKeys
'            'FPS Counter - mostramos las FPS
'            If GetTickCount - modGeneral.lFrameTimer >= 1000 Then
'                modGeneral.lFrameTimer = GetTickCount
'            End If
'        End If
'        ' If there is anything to be sent, we send it
'        Call FlushBuffer
'        'Sleep 0&
'        DoEvents
        
End Sub

Private Sub lstClases_Click()
'Me.WindowState = vbNormal
'renderasd = True
'Me.Visible = True
'EngineRun = True
End Sub


Private Sub mnuEquipar_Click()
    Call EquiparItem
End Sub

Private Sub mnuNpcDesc_Click()
    Call WriteLeftClick(tX, tY)
End Sub

Private Sub mnuTirar_Click()
    Call TirarItem
End Sub

Private Sub mnuUsar_Click()
    Call UsarItem
End Sub


Private Sub Coord_Click()
    AddtoRichTextBox frmMain.RecTxt, "Estas coordenadas son tu ubicación en el mapa. Utiliza la letra L para corregirla si esta no se corresponde con la del servidor por efecto del Lag.", 255, 255, 255, False, False, False
End Sub

Private Sub Pi_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
MouseX = x
MouseY = y
End Sub

Private Sub picInv_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
SecurityKeys.ClickRatonDown
Call InventoryWindow_MouseDown(Button, Shift, x, y)
End Sub

Private Sub picInv_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
 Call InventoryWindow_MouseMove(Button, Shift, x, y)
End Sub

Private Sub renderer_Click()

puede_mover = False
Me.WindowState = vbNormal
renderasd = True
Me.Visible = True

    If Not Comerciando Then
        Call ConvertCPtoTP(MouseX, MouseY, tX, tY)
        
        'If Not InGameArea() Then Exit Sub
        
        If MouseShift = 0 Then
                If UsingSkill = 0 Then
                    If (Protocol.aim_pj Xor 105) > 0 Then
                        If Protocol.aim_pj Xor 105 < 255 Then
                            Call WriteLeftClick(tX, tY + CInt(charlist(Protocol.aim_pj Xor 105).OffY / 32))
                        End If
                    Else
                        Call WriteLeftClick(tX, tY)
                    End If
                Else
                    If Not MainTimer.Check(TimersIndex.Arrows, False) Then 'Check if arrows interval has finished.
                        frmMain.MousePointer = vbDefault
                        UsingSkill = 0
                        With FontTypes(FontTypeNames.FONTTYPE_TALK)
                            Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar flechas tan rapido.", .red, .green, .blue, .bold, .italic)
                        End With
                        Exit Sub
                    End If
                    
                    'Splitted because VB isn't lazy!
                    If UsingSkill = Proyectiles Then
                        If Not MainTimer.Check(TimersIndex.Arrows) Then
                            frmMain.MousePointer = vbDefault
                            UsingSkill = 0
                            With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar flechas tan rapido.", .red, .green, .blue, .bold, .italic)
                            End With
                            Exit Sub
                        End If
                    End If
                    
                    'Splitted because VB isn't lazy!
                    If UsingSkill = Magia Then
                        Dim seguir As Boolean
                        seguir = True
                        If Not MainTimer.Check(TimersIndex.Attack, False) Then 'Check if attack interval has finished.
                            If Not MainTimer.Check(TimersIndex.CastAttack) Then 'Corto intervalo de Golpe-Magia
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                                With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                    Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar hechizos tan rapido.", .red, .green, .blue, .bold, .italic)
                                End With
                                seguir = False
                                Exit Sub
                            End If
                        Else
                            If Not MainTimer.Check(TimersIndex.CastSpell) Then 'Check if spells interval has finished.
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                                With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                    Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar hechizos tan rapido.", .red, .green, .blue, .bold, .italic)
                                End With
                                seguir = False
                                Exit Sub
                            End If
                        End If

                        If frmMain.MousePointer <> 2 Then
                            frmMain.MousePointer = vbDefault
                            UsingSkill = 0
                            Exit Sub
                        End If
                        
                        If seguir Then
                            If (Protocol.aim_pj Xor 105) > 0 Then
                                Call WriteLanzarH(tX, tY + CInt(charlist(Protocol.aim_pj Xor 105).OffY / 32))
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                            Else
                                Call WriteLanzarH(tX, tY)
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                            End If
                        End If
                    End If
                    
                    If frmMain.MousePointer <> 2 Then Exit Sub 'Parcheo porque a veces tira el hechizo sin tener el cursor (NicoNZ)
                    
                    frmMain.MousePointer = vbDefault
                    Call WriteWorkLeftClick(tX, tY, UsingSkill)
                    UsingSkill = 0
                End If
        ElseIf (MouseShift And 1) = 1 Then
                If MouseBoton = vbLeftButton Then
                    Call WriteWarpChar("YO", UserMap, tX, tY)
                End If
        End If
    End If
End Sub

Private Sub renderer_DblClick()
Call ConvertCPtoTP(MouseX, MouseY, MouseTileX, MouseTileY)
Engine_FX.FX_Projectile_Create_pos 1, MouseTileX, MouseTileY, 13128, 0.35
Exit Sub
Dim i As Integer
'Engine_Particles.Particle_Group_Make i, charlist(1).Pos.X, charlist(1).Pos.Y, 18
'Engine_Particles.Particle_Group_Set_TMPos i, MouseTileX, MouseTileY

Protocol.WriteDoubleClick MouseTileX, MouseTileY
'If ccc.value = vbUnchecked Then Exit Sub


End Sub

Private Sub renderer_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    MouseBoton = Button
    MouseShift = Shift
    GUI_Click x, y, Button
End Sub

Private Sub renderer_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    MouseX = x
    MouseY = y
    Call ConvertCPtoTP(x, y, MouseTileX, MouseTileY)
    If y < 100 Then console_alpha = True Else console_alpha = False
    GUI_Mouse_Move x, y, Button
    dibujar_tooltip_inv = 0
End Sub

Private Sub renderer_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    clicX = x
    clicY = y
End Sub

Private Sub SendTxt_KeyUp(KeyCode As Integer, Shift As Integer)
    'Send text
    If KeyCode = vbKeyReturn Then
        If LenB(stxtbuffer) <> 0 Then Call ParseUserCommand(stxtbuffer)
        
        stxtbuffer = ""
        SendTxt.Text = ""
        KeyCode = 0
        SendTxt.Visible = False
    End If
    
End Sub

Private Sub soycheater_Timer()
End Sub

Private Sub Second_Timer()
WEBB.TryRequest
    Static ultima As Long
    Static actual As Long
    Static dada As Boolean
    dada = Not dada
    If frmMain.WindowState <> vbMinimized And Me.Visible = True Then
        If pri = True Then
            actual = GetTickCount()
            If (actual - ultima - 210) > Second.Interval Then WriteBankStart 'MsgBox "Soy cheater."
            If (actual - ultima + 210) < Second.Interval Then WriteBankStart
        End If
        
        Call watchdogACgtc(Not pri)
        
        Me.WindowState = vbNormal
        renderasd = True
        Me.Visible = True
        EngineRun = True
        
        pri = True
        ultima = GetTickCount()
        MainTimer.ChechCheat
    Else
        ultima = GetTickCount()
        pri = False
    End If
    
    'If dada Then If antilag = False And UserMoving = 0 Then DoEvents Call WriteRequestPositionUpdate
    If dada Then
        Call WritePing
    End If
    PuedeMacrear = True

If Me.Visible = False Then Exit Sub

    
    
    
    If IScombate Then
            If dada Then Call WriteRequestUserList
    End If

    Engine_UI.toggle_render_text_indicator
End Sub

'[END]'

''''''''''''''''''''''''''''''''''''''
'     ITEM CONTROL                   '
''''''''''''''''''''''''''''''''''''''

Private Sub TirarItem()
'    If (Inventario.SelectedItem > 0 And Inventario.SelectedItem < MAX_INVENTORY_SLOTS + 1) Or (Inventario.SelectedItem = FLAGORO) Then
'        If Inventario.Amount(Inventario.SelectedItem) = 1 Then
'            Call WriteDrop(Inventario.SelectedItem, 1)
'        Else
'           If Inventario.Amount(Inventario.SelectedItem) > 1 Then
'                frmCantidad.Show , frmMain
'           End If
'        End If
'    End If
End Sub

Private Sub AgarrarItem()
    Call WritePickUp
End Sub

Private Sub UsarItem()
If (SelectedItem > 0) And (SelectedItem < MAX_INVENTORY_SLOTS + 1) Then _
        Call WriteUseItem(SelectedItem)
End Sub

Public Sub EquiparItem()
    If (SelectedItem > 0) And (SelectedItem < MAX_INVENTORY_SLOTS + 1) Then _
        Call WriteEquipItem(SelectedItem)
End Sub

''''''''''''''''''''''''''''''''''''''
'     HECHIZOS CONTROL               '
''''''''''''''''''''''''''''''''''''''
Private Sub cmdLanzar_Click()

End Sub

Private Sub CmdLanzar_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    UsaMacro = False
    CmdLanzar.MousePointer = 99
    CnTd = 0
End Sub

Private Sub cmdINFO_Click()
    If hlst.ListIndex <> -1 Then
        Call WriteSpellInfo(hlst.ListIndex + 1)
    End If
End Sub


Private Sub Form_Load()
On Error Resume Next
pasarme
Me.Picture = clsPak_LeerIPicture(pakInterface, 2) 'modZLib.Bin_Resource_Load_Picture(2, rGUI)
InvEqu.Picture = clsPak_LeerIPicture(pakInterface, 3) 'modZLib.Bin_Resource_Load_Picture(3, rGUI)
Me.Refresh
'PanelDer.Picture = General_Load_Picture_From_Resource("nuevo.bmp")
    'frmMain.Caption = "Argentum Online" & " V " & App.Major & "." & _
    'App.Minor & "." & App.Revision
    
    'InvEqu.Picture = LoadPicture(App.path & _
    '"\Graficos\Centronuevoinventario.jpg")
    
   Me.Left = 0
   Me.Top = 0
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    'MouseX = X - MainViewShp.Left
    'MouseY = Y - MainViewShp.Top
End Sub

Private Sub hlst_KeyDown(KeyCode As Integer, Shift As Integer)
       KeyCode = 0
End Sub

Private Sub hlst_KeyPress(KeyAscii As Integer)
       KeyAscii = 0
End Sub

Private Sub hlst_KeyUp(KeyCode As Integer, Shift As Integer)
        KeyCode = 0
End Sub

Private Sub Image1_Click(Index As Integer)
    Call Audio.Sound_Play(SND_CLICK)
    Select Case Index
        Case 0
            Call frmOpciones.Show(vbModeless, frmMain)
        Case 1
            LlegaronAtrib = False
            LlegaronSkills = False
            LlegoFama = False

            LlegaronAtrib = False
            LlegaronSkills = False
            LlegoFama = False
        
        Case 2
            Engine_UI.acc_visible = Not acc_visible
        Case 3
        'End
        Call WriteQuit
        TimerClose.Enabled = True
        Case 4
        'Me.Visible = False
        Me.WindowState = vbMinimized

        'Form1.Visible = True
        
        'Me.ShowInTaskbar = True
    End Select
End Sub

Private Sub Image3_Click(Index As Integer)
'    Select Case Index
'        Case 0
'            Inventario.SelectGold
'            If UserGLD > 0 Then
'                frmCantidad.Show , frmMain
'            End If
'    End Select
End Sub



Private Sub Label4_Click()
On Error Resume Next
Label4.Visible = True
Label7.Visible = True
Label4.Enabled = True
Label7.Enabled = True
picInv.MousePointer = 0
Call Audio.Sound_Play(SND_CLICK)
Set InvEqu.Picture = clsPak_LeerIPicture(pakInterface, 3) 'modZLib.Bin_Resource_Load_Picture(3, rGUI)
picInv.Visible = True
hlst.Visible = False
cmdInfo.Visible = False
CmdLanzar.Visible = False
cmdMoverHechi(0).Visible = False
cmdMoverHechi(1).Visible = False
cmdMoverHechi(0).Enabled = False
cmdMoverHechi(1).Enabled = False
re_render_inventario = True
End Sub

Private Sub Label7_Click()
'On Error Resume Next
    Call Audio.Sound_Play(SND_CLICK)
    picInv.MousePointer = 0
    Set InvEqu.Picture = clsPak_LeerIPicture(pakInterface, 4) 'modZLib.Bin_Resource_Load_Picture(4, rGUI)
    '%%%%%%OCULTAMOS EL INV&&&&&&&&&&&&
    picInv.Visible = False
    hlst.Visible = True
    cmdInfo.Visible = True
    CmdLanzar.Visible = True
    cmdMoverHechi(0).Visible = True
    cmdMoverHechi(1).Visible = True
    cmdMoverHechi(0).Enabled = True
    cmdMoverHechi(1).Enabled = True
DespInv(0).Visible = False
DespInv(1).Visible = False
End Sub

Private Sub picInv_DblClick()
    If Not MainTimer.Check(TimersIndex.UseItemWithDblClick) Then Exit Sub
    If SecurityKeys.ClickRatonUP = True Then Call UsarItem
End Sub

Private Sub picInv_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
 Call Audio.Sound_Play(SND_CLICK)
 Call InventoryWindow_MouseUp(Button, Shift, x, y)
 
End Sub

Private Sub RecTxt_Change()
On Error Resume Next  'el .SetFocus causaba errores al salir y volver a entrar
    If Not Application.IsAppActive() Then Exit Sub
    
    If SendTxt.Visible Then
        SendTxt.SetFocus
    ElseIf (picInv.Visible) Then
        picInv.SetFocus
    End If
End Sub

Private Sub RecTxt_KeyDown(KeyCode As Integer, Shift As Integer)
On Error Resume Next
    If picInv.Visible Then
        picInv.SetFocus
    Else
        hlst.SetFocus
    End If
End Sub

Private Sub SendTxt_Change()
'**************************************************************
'Author: Unknown
'Last Modify Date: 3/06/2006
'3/06/2006: Maraxus - impedí se inserten caractéres no imprimibles
'**************************************************************
    If Len(SendTxt.Text) > 160 Then
        stxtbuffer = "Soy un cheater, avisenle a un gm"
    Else
        'Make sure only valid chars are inserted (with Shift + Insert they can paste illegal chars)
        Dim i As Long
        Dim TempStr As String
        Dim CharAscii As Integer
        
        For i = 1 To Len(SendTxt.Text)
            CharAscii = Asc(mid$(SendTxt.Text, i, 1))
            If CharAscii >= vbKeySpace And CharAscii <= 255 Then
                TempStr = TempStr & Chr$(CharAscii)
            End If
        Next i
        
        If TempStr <> SendTxt.Text Then
            'We only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            SendTxt.Text = TempStr
        End If
        
        stxtbuffer = SendTxt.Text
    End If
End Sub

Private Sub SendTxt_KeyPress(KeyAscii As Integer)

    If Not (KeyAscii = vbKeyBack) And _
       Not (KeyAscii >= vbKeySpace And KeyAscii <= 250) Then _
        KeyAscii = 0
    
End Sub



''''''''''''''''''''''''''''''''''''''
'     SOCKET1                        '
''''''''''''''''''''''''''''''''''''''
#If UsarWrench = 1 Then

Private Sub Socket1_Connect()
    'Clean input and output buffers
    Call incomingData.ReadASCIIStringFixed(incomingData.Length)
    Call outgoingData.ReadASCIIStringFixed(outgoingData.Length)
    Second.Enabled = True
End Sub

Private Sub Socket1_Disconnect()
    Dim i As Long
    
    Second.Enabled = False
    Connected = False
    
    Socket1.Cleanup

    frmConnect.MousePointer = vbNormal
    frmConnect.Visible = True
    
    On Local Error Resume Next
    For i = 0 To Forms.count - 1
        If Forms(i).name <> Me.name And Forms(i).name <> frmConnect.name And Forms(i).name <> frmOldPersonaje.name Then
            Unload Forms(i)
        End If
    Next i
    On Local Error GoTo 0
    
    frmMain.Visible = False
    play_intro
    renderasd = False
    Call SetMusicInfo("Jugando Arduz AO - http://www.arduz.com.ar/", "", "", "Games", , "{0}")
    pausa = False
    UserMeditar = False

    UserClase = 0
    UserSexo = 0
    UserRaza = 0
    UserHogar = 0
    UserEmail = ""
    
    For i = 1 To NUMSKILLS
        UserSkills(i) = 0
    Next i

    For i = 1 To NUMATRIBUTOS
        UserAtributos(i) = 0
    Next i
    
    Audio.Sound_Stop_All
    Audio.Ambient_Stop

    SkillPoints = 0
    Alocados = 0
End Sub

Private Sub Socket1_LastError(ErrorCode As Integer, ErrorString As String, Response As Integer)
    '*********************************************
    'Handle socket errors
    '*********************************************
    If ErrorCode = 24036 Then
        Call MsgBox("Por favor espere, intentando completar conexion.", vbApplicationModal + vbInformation + vbOKOnly + vbDefaultButton1, "Error")
        Exit Sub
    End If
    
    Call MsgBox(ErrorString, vbApplicationModal + vbInformation + vbOKOnly + vbDefaultButton1, "Error")
    frmConnect.MousePointer = 1
    Response = 0
    Second.Enabled = False

    frmMain.Socket1.Disconnect
    
    If frmOldPersonaje.Visible Then
        frmOldPersonaje.Visible = False
    End If
    
        frmConnect.Show
End Sub

Private Sub Socket1_Read(DataLength As Integer, IsUrgent As Integer)
    Dim RD As String
    Dim Data() As Byte
    
    Call Socket1.Read(RD, DataLength)
    Data = StrConv(RD, vbFromUnicode)
    
    If RD = vbNullString Then Exit Sub
    
    'Put data in the buffer
    Call incomingData.WriteBlock(Data)
    
    'Send buffer to Handle data
    Call HandleIncomingData
End Sub


#End If

Private Sub AbrirMenuViewPort()

End Sub

Public Sub CallbackMenuFashion(ByVal MenuId As Long, ByVal Sel As Long)

End Sub




Private Sub Timer1_Timer()
If Me.Visible = True Then
Static tooltip_cual As Integer
    DoEvents
    'DrawInv
    re_render_inventario = True
    Audio.Sound_Render
    
    If dibujar_tooltip_inv = tooltip_cual Then
        inv_tooltip_counter = inv_tooltip_counter + 1
    Else
        inv_tooltip_counter = 0
         tooltip_cual = dibujar_tooltip_inv
    End If
End If
End Sub


Private Sub TimerClose_Timer()
If Me.Visible = True Then Call closex
TimerClose.Enabled = False
End Sub

Private Sub TimerConola_Timer()
If Not DialogosClanes Is Nothing Then DialogosClanes.PassTimer
End Sub

Private Sub VScroll1_Change()
asdasd
End Sub

Private Sub VScroll1_Scroll()
asdasd
End Sub

Private Sub WEBB_RecibeDatosWeb(datos As String, raw As Boolean)


If frmConnect.lblStatus.Caption = "Buscando actualizaciones..." Then frmConnect.lblStatus.Caption = "Cargando..."

If endthen = True Then
    DoEvents
    CloseClient
    End
End If

If Len(datos) = 0 Then Exit Sub

   On Error Resume Next

If datos = "!" Then
    If MsgBox("Lamentamos informarte que se te aplico Tolerancia Cero en Arduz Online. Para realizar un descargo de baneo, postee en el foro con el siguiente identificador: [" & ClientIDs & "]" & vbNewLine & "¿Abrir el foro antes de cerrar?", vbYesNo) = vbYes Then
        Call ShellExecute(0, "Open", "http://foro.arduz.com.ar", "", app.Path, 0)
        DoEvents
    End If
    CloseClient
    End
End If

If IsIDE = False Then
    If Asc(datos) = 46 And act_pharseado = False Then 'UPDATE
        act_pharseado = True
        If MsgBox("Hay una nueva actualización para el juego. Es necesaria para seguir jugando. ¿Descargar?", vbYesNo) = vbYes Then
            Call ShellExecute(0, "Open", "AutoUpdate.exe", "", app.Path, 0)
            DoEvents
        End If
        
        CloseClient
        End
    End If
End If

If Asc(datos) = 51 Then 'CONFIG_CLIENTE
    datos = Right$(datos, Len(datos) - 1)
    puedo_deslimitar = val(ReadNextDato(datos))
End If

If dontpharsenext = False And frmConnect.lblStatus.Caption <> "Cargando..." Then
    frmConnect.crearlista datos
    frmConnect.lblStatus.Caption = ""
End If
dontpharsenext = False

End Sub

Private Function ReadNextDato(ByRef sText As String, Optional delimitera As String = "~ç~") As String
Dim k As Long
k = InStr(sText, delimitera)
If k > 0 Then
    ReadNextDato = Left$(sText, k - 1)
    sText = mid$(sText, k + Len(delimitera), Len(sText) - k + Len(delimitera))
Else
    ReadNextDato = sText
    sText = vbNullString
End If
End Function



' -------------------
'    W I N S O C K
' -------------------
'

#If UsarWrench <> 1 Then

Private Sub Winsock1_Close()
If frmOldPersonaje.Visible = True Then
On Local Error Resume Next
frmMain.Winsock1.connect frmConnect.IPTxt.Text, CLng(frmConnect.PortTxt)
On Local Error GoTo 0
Exit Sub
End If

    Dim i As Long
    
    Debug.Print "WInsock Close"
    
    Second.Enabled = False
    Connected = False
    
    If Winsock1.State <> sckClosed Then _
        Winsock1.Close
    
    frmConnect.MousePointer = vbNormal
    frmConnect.Visible = True

    
    On Local Error Resume Next
    For i = 0 To Forms.count - 1
        If Forms(i).name <> Me.name And Forms(i).name <> frmConnect.name And Forms(i).name <> frmOldPersonaje.name Then
            Unload Forms(i)
        End If
    Next i
    On Local Error GoTo 0
    
    frmMain.Visible = False
    play_intro
    renderasd = False
    Call SetMusicInfo("Jugando Arduz AO - http://www.arduz.com.ar/", "", "", "Games", , "{0}")
    pausa = False
    UserMeditar = False

    UserClase = 0
    UserSexo = 0
    UserRaza = 0
    UserHogar = 0
    UserEmail = ""
    
    For i = 1 To NUMSKILLS
        UserSkills(i) = 0
    Next i

    For i = 1 To NUMATRIBUTOS
        UserAtributos(i) = 0
    Next i
    Audio.Sound_Stop_All
    Audio.Ambient_Stop
    SkillPoints = 0
    Alocados = 0

    Dialogos.RemoveAllDialogs
End Sub

Private Sub Winsock1_Connect()
    Debug.Print "Winsock Connect"

    'Clean input and output buffers
    Call incomingData.ReadASCIIStringFixed(incomingData.Length)
    Call outgoingData.ReadASCIIStringFixed(outgoingData.Length)
    
    Second.Enabled = True
End Sub

Private Sub Winsock1_DataArrival(ByVal BytesTotal As Long)
    Dim RD As String
    Dim Data() As Byte
    
    'Socket1.Read RD, DataLength
    Winsock1.GetData RD
    
    Data = StrConv(RD, vbFromUnicode)
    
#If SeguridadAlkon Then
    Call DataReceived(Data)
#End If
    
    'Set data in the buffer
    Call incomingData.WriteBlock(Data)
    
    'Send buffer to Handle data
    Call HandleIncomingData
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    '*********************************************
    'Handle socket errors
    '*********************************************
    
    Call MsgBox(Description, vbApplicationModal + vbInformation + vbOKOnly + vbDefaultButton1, "Error")
    frmConnect.MousePointer = 1
    Second.Enabled = False

    If Winsock1.State <> sckClosed Then _
        Winsock1.Close
    
    If frmOldPersonaje.Visible Then
        frmOldPersonaje.Visible = False
    End If
    frmConnect.Show
End Sub
#End If

Private Function InGameArea() As Boolean
'***************************************************
'Author: NicoNZ
'Last Modification: 04/07/08
'Checks if last click was performed within or outside the game area.
'***************************************************
    If clicX < 0 Or clicX > 32 * 17 Then Exit Function
    If clicY < 0 Or clicY > 32 * 13 Then Exit Function
    
    InGameArea = True
End Function

Private Sub XX_Scroll()
asdasd
End Sub

Private Sub YY_Change()
asdasd
End Sub
Private Sub XX_Change()
asdasd
End Sub

Private Sub YY_Scroll()
asdasd
End Sub

Sub asdasd()

End Sub
