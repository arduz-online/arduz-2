VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.ocx"
Object = "{33101C00-75C3-11CF-A8A0-444553540000}#1.0#0"; "CSWSK32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Arduz Server"
   ClientHeight    =   7095
   ClientLeft      =   165
   ClientTop       =   555
   ClientWidth     =   15210
   ControlBox      =   0   'False
   FillColor       =   &H00C0C0C0&
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000004&
   LinkTopic       =   "Form1"
   ScaleHeight     =   473
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1014
   StartUpPosition =   2  'CenterScreen
   Begin SocketWrenchCtrl.Socket sporta 
      Left            =   6600
      Top             =   600
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   20
      Type            =   1
      Urgent          =   0   'False
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6600
      Top             =   2040
   End
   Begin VB.CheckBox Check2 
      Caption         =   "Bots"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   82
      Top             =   720
      Visible         =   0   'False
      Width           =   669
   End
   Begin VB.Timer Auditoria 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6600
      Top             =   1680
   End
   Begin VB.CommandButton Iniciarsv 
      Caption         =   "Iniciar Servidor"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   80
      Top             =   3600
      Width           =   2535
   End
   Begin VB.PictureBox Picture1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      ScaleHeight     =   315
      ScaleWidth      =   2475
      TabIndex        =   78
      Top             =   3600
      Visible         =   0   'False
      Width           =   2535
      Begin VB.Label asddsadsa 
         Alignment       =   2  'Center
         Caption         =   "Iniciando servidor..."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   0
         TabIndex        =   79
         Top             =   0
         Width           =   2655
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Aceptar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4200
      TabIndex        =   77
      Top             =   3600
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Restart"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   75
      Top             =   3600
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Aplicar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3360
      TabIndex        =   74
      Top             =   3600
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Frame Frame6 
      Caption         =   "Administrar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   10200
      TabIndex        =   60
      Top             =   4080
      Visible         =   0   'False
      Width           =   4935
      Begin VB.CommandButton Command7 
         Caption         =   "Limpiar"
         Height          =   255
         Left            =   1800
         TabIndex        =   81
         Top             =   600
         Width           =   855
      End
      Begin VB.CommandButton SendMessage 
         Caption         =   "Enviar Mensaje"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   67
         Top             =   600
         Width           =   1695
      End
      Begin VB.TextBox Text3 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   120
         TabIndex        =   66
         Text            =   "Escribe tu mensaje"
         Top             =   240
         Width           =   2535
      End
      Begin VB.TextBox Text2 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1575
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   65
         Top             =   1080
         Width           =   4695
      End
      Begin VB.ComboBox cboPjs 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   2760
         TabIndex        =   64
         Top             =   240
         Width           =   2055
      End
      Begin VB.CommandButton Command3 
         Caption         =   "ADMIN"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   2760
         TabIndex        =   63
         Top             =   600
         Width           =   735
      End
      Begin VB.CommandButton C123 
         Caption         =   "ECHAR"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3480
         TabIndex        =   62
         Top             =   600
         Width           =   735
      End
      Begin VB.CommandButton Command8 
         Caption         =   "BAN"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   4200
         TabIndex        =   61
         Top             =   600
         Width           =   615
      End
      Begin VB.Label Label9 
         Alignment       =   2  'Center
         BorderStyle     =   1  'Fixed Single
         Caption         =   "Consola"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   68
         Top             =   890
         Width           =   4695
      End
   End
   Begin VB.CheckBox ant_lag 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Optimizar LAN"
      Enabled         =   0   'False
      Height          =   255
      Left            =   5280
      TabIndex        =   59
      Top             =   2520
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.Timer Timer1 
      Interval        =   30000
      Left            =   6120
      Top             =   1560
   End
   Begin VB.Timer Timer_start 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6120
      Top             =   600
   End
   Begin VB.Timer Timer_end 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   6120
      Top             =   1080
   End
   Begin VB.Timer FX 
      Enabled         =   0   'False
      Interval        =   4000
      Left            =   5640
      Top             =   2040
   End
   Begin VB.Timer TimerControl 
      Interval        =   5000
      Left            =   5160
      Top             =   600
   End
   Begin VB.Timer packetResend 
      Interval        =   10
      Left            =   5160
      Top             =   1080
   End
   Begin VB.Timer GameTimer 
      Enabled         =   0   'False
      Interval        =   40
      Left            =   5160
      Top             =   1560
   End
   Begin VB.Timer AutoSave 
      Interval        =   60000
      Left            =   5640
      Top             =   600
   End
   Begin VB.Timer npcataca 
      Enabled         =   0   'False
      Interval        =   4000
      Left            =   5640
      Top             =   1560
   End
   Begin VB.Timer TIMER_AI 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   5640
      Top             =   1080
   End
   Begin VB.Frame Frame5 
      Caption         =   "Avanzado"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   120
      TabIndex        =   49
      Top             =   4080
      Visible         =   0   'False
      Width           =   4935
      Begin VB.CommandButton Command9 
         Caption         =   "Recargar Balance"
         Height          =   255
         Left            =   2280
         TabIndex        =   83
         Top             =   960
         Width           =   1815
      End
      Begin VB.OptionButton Option1 
         Caption         =   "En cola"
         Height          =   255
         Index           =   0
         Left            =   2400
         TabIndex        =   55
         Top             =   720
         Width           =   1815
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Al instante"
         Height          =   255
         Index           =   1
         Left            =   2400
         TabIndex        =   54
         Top             =   480
         Value           =   -1  'True
         Width           =   1215
      End
      Begin VB.TextBox Porttt 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   840
         MaxLength       =   5
         TabIndex        =   53
         Text            =   "7666"
         Top             =   240
         Width           =   1095
      End
      Begin VB.CheckBox hamaa 
         Caption         =   "Hamachi"
         Height          =   255
         Left            =   120
         TabIndex        =   52
         Top             =   600
         Width           =   1095
      End
      Begin VB.CheckBox ohlan 
         Caption         =   "&No figurar en la web"
         Height          =   255
         Left            =   120
         TabIndex        =   51
         ToolTipText     =   "No aparece en la lista de servidores, ni se envian los frags."
         Top             =   840
         Width           =   1815
      End
      Begin VB.CheckBox sulog 
         Caption         =   "Superlog"
         Height          =   255
         Left            =   120
         TabIndex        =   50
         Top             =   1080
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "Enviar datos:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   2280
         TabIndex        =   58
         Top             =   240
         Width           =   1575
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         Caption         =   "Puerto: "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   57
         Top             =   270
         Width           =   615
      End
      Begin VB.Label tcps 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "OUT: 0KB/s - IN: 0KB/s"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   56
         Top             =   2400
         Width           =   4695
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Bots"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   7320
      TabIndex        =   35
      Top             =   480
      Visible         =   0   'False
      Width           =   4935
      Begin VB.CommandButton SelecBot 
         Caption         =   "Actualizar"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   2160
         TabIndex        =   48
         Top             =   2400
         Width           =   975
      End
      Begin VB.CommandButton MatarBot 
         Caption         =   "Matar Seleccionado"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   3120
         TabIndex        =   47
         Top             =   2400
         Width           =   1575
      End
      Begin VB.ListBox BoxBotList 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2010
         Left            =   2160
         TabIndex        =   46
         Top             =   240
         Width           =   2535
      End
      Begin VB.CommandButton Command11 
         Caption         =   "Azul"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   43
         Top             =   360
         Width           =   1935
      End
      Begin VB.CommandButton Command2 
         Caption         =   " Rojo"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   42
         Top             =   600
         Width           =   1935
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Matar todos"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   41
         Top             =   840
         Width           =   1935
      End
      Begin VB.ComboBox mankoo 
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         ItemData        =   "frmMain2.frx":0000
         Left            =   600
         List            =   "frmMain2.frx":0002
         Style           =   2  'Dropdown List
         TabIndex        =   40
         Top             =   1200
         Width           =   1455
      End
      Begin VB.ComboBox clasebot 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         ItemData        =   "frmMain2.frx":0004
         Left            =   600
         List            =   "frmMain2.frx":0020
         TabIndex        =   39
         Text            =   "Bot Clase..."
         Top             =   1560
         Width           =   1455
      End
      Begin VB.OptionButton respawnbot 
         Caption         =   "Respawn bots"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   38
         Top             =   1920
         Width           =   1935
      End
      Begin VB.OptionButton respawnbot 
         Caption         =   "Balance con bots"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   37
         Top             =   2160
         Width           =   1935
      End
      Begin VB.OptionButton respawnbot 
         Caption         =   "No respawn"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   36
         Top             =   2400
         Width           =   1935
      End
      Begin VB.Label Mankism 
         Caption         =   "Nivel:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   45
         Top             =   1320
         Width           =   495
      End
      Begin VB.Label Label7 
         Caption         =   "Clase:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   44
         Top             =   1560
         Width           =   495
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Servidor"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   5160
      TabIndex        =   22
      Top             =   4080
      Visible         =   0   'False
      Width           =   4935
      Begin VB.CheckBox Check1 
         Alignment       =   1  'Right Justify
         Caption         =   "Tiempo limite:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   29
         Top             =   240
         Width           =   1495
      End
      Begin VB.ComboBox ronda 
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1680
         Style           =   2  'Dropdown List
         TabIndex        =   28
         Top             =   240
         Width           =   2775
      End
      Begin VB.TextBox svrname 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   960
         MaxLength       =   32
         TabIndex        =   27
         Top             =   960
         Width           =   3495
      End
      Begin VB.ComboBox mapax 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   960
         Style           =   2  'Dropdown List
         TabIndex        =   26
         Top             =   600
         Width           =   3495
      End
      Begin VB.TextBox Text1 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   1920
         MaxLength       =   7
         PasswordChar    =   "*"
         TabIndex        =   25
         Top             =   2040
         Width           =   2535
      End
      Begin VB.TextBox adminpas 
         Height          =   285
         Left            =   1920
         MaxLength       =   7
         TabIndex        =   24
         Top             =   1680
         Width           =   2535
      End
      Begin VB.ComboBox maxu 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   960
         Style           =   2  'Dropdown List
         TabIndex        =   23
         Top             =   1320
         Width           =   3495
      End
      Begin VB.Label Label4 
         Caption         =   "MaxUsers:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   34
         Top             =   1320
         Width           =   855
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Nombre:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   33
         Top             =   960
         Width           =   735
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Mapa:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   240
         TabIndex        =   32
         Top             =   600
         Width           =   615
      End
      Begin VB.Label Label5 
         Caption         =   "Contraseña privada:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   31
         Top             =   2040
         Width           =   1815
      End
      Begin VB.Label Label3 
         Caption         =   "Código de admin:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   390
         TabIndex        =   30
         Top             =   1680
         Width           =   1575
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Configuración"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Visible         =   0   'False
      Width           =   4935
      Begin VB.Frame Frame4 
         Caption         =   "Clases permitidas"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2295
         Left            =   2400
         TabIndex        =   13
         Top             =   240
         Width           =   2175
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   21
            Top             =   240
            Width           =   975
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   20
            Top             =   480
            Width           =   1815
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   19
            Top             =   720
            Width           =   1815
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   4
            Left            =   120
            TabIndex        =   18
            Top             =   960
            Width           =   1935
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   6
            Left            =   120
            TabIndex        =   17
            Top             =   1680
            Width           =   975
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   7
            Left            =   120
            TabIndex        =   16
            Top             =   1440
            Width           =   1815
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   9
            Left            =   120
            TabIndex        =   15
            Top             =   1920
            Width           =   975
         End
         Begin VB.CheckBox cClasspe 
            Caption         =   "Check3"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   10
            Left            =   120
            TabIndex        =   14
            Top             =   1200
            Width           =   1455
         End
      End
      Begin VB.CheckBox fatu 
         Caption         =   "Invocaciones"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   960
         Width           =   1455
      End
      Begin VB.CheckBox deathms 
         Caption         =   "Deathmatch"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   1920
         Width           =   1455
      End
      Begin VB.CheckBox ffire 
         Caption         =   "Friendly Fire"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   1200
         Width           =   1335
      End
      Begin VB.CheckBox resuu 
         Caption         =   "Resucitar"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   720
         Value           =   1  'Checked
         Width           =   1215
      End
      Begin VB.CheckBox estuu 
         Caption         =   "Estupidez"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   480
         Width           =   1215
      End
      Begin VB.CheckBox invii 
         Caption         =   "Invisbilidad"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   1335
      End
      Begin VB.CheckBox resuteam 
         Caption         =   "Resucitar automatico"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   1440
         Value           =   1  'Checked
         Width           =   2175
      End
      Begin VB.CheckBox inmoo 
         Caption         =   "Inmovilizar(SOLO MAGOS)"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   1680
         Value           =   1  'Checked
         Width           =   2295
      End
      Begin VB.CheckBox redroms 
         Caption         =   "Redrover"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   2160
         Width           =   2055
      End
      Begin VB.CheckBox CLB 
         Caption         =   "C. la Bandera DISABLE"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   1
         Top             =   2400
         Visible         =   0   'False
         Width           =   2175
      End
      Begin VB.Label Escuch 
         Alignment       =   1  'Right Justify
         Caption         =   "Label2"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Visible         =   0   'False
         Width           =   1335
      End
   End
   Begin MSWinsockLib.Winsock WEbSOCK 
      Left            =   6120
      Top             =   2040
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      RemotePort      =   80
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   6600
      Top             =   1080
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock wssvr 
      Left            =   5160
      Top             =   2040
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label txStatus 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   450
      Left            =   120
      TabIndex        =   76
      Top             =   3600
      Width           =   2325
      WordWrap        =   -1  'True
   End
   Begin VB.Label Menu 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Administrar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   4
      Left            =   3960
      TabIndex        =   73
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label Menu 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Avanzado"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   3
      Left            =   2880
      TabIndex        =   72
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label Menu 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Bots"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   2
      Left            =   2160
      TabIndex        =   71
      Top             =   480
      Width           =   735
   End
   Begin VB.Label Menu 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Servidor"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   1200
      TabIndex        =   70
      Top             =   480
      Width           =   975
   End
   Begin VB.Label Menu 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Configuración"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   69
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label CantUsuarios 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      Caption         =   "Numero de usuarios: 0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   195
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   1875
   End
   Begin VB.Menu mnuControles 
      Caption         =   "Menú"
      Begin VB.Menu mnuSystray 
         Caption         =   "Esconder"
      End
      Begin VB.Menu mnuCerrar 
         Caption         =   "Cerrar Servidor"
      End
   End
   Begin VB.Menu mnuPopUp 
      Caption         =   "PopUpMenu"
      Visible         =   0   'False
      Begin VB.Menu mnuMostrar 
         Caption         =   "&Mostrar"
      End
      Begin VB.Menu mnuSalir 
         Caption         =   "&Salir"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private AutoIniciarSV As Boolean
Public ESCUCHADAS As Long

Private Type NOTIFYICONDATA
    cbSize As Long
    Hwnd As Long
    uid As Long
    uFlags As Long
    uCallbackMessage As Long
    hIcon As Long
    szTip As String * 64
End Type
   
Const NIM_ADD = 0
Const NIM_DELETE = 2
Const NIF_MESSAGE = 1
Const NIF_ICON = 2
Const NIF_TIP = 4

Const WM_MOUSEMOVE = &H200
Const WM_LBUTTONDBLCLK = &H203
Const WM_RBUTTONUP = &H205


Private Enum en_OptTypeEnable
    enProggy
    enPort
End Enum

'---- file open in api a.k.a. common dialog api
Private Type OPENFILENAME
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type

Private OFName As OPENFILENAME
Private Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long

Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long

'Private PROGSCOPE As NET_FW_SCOPE_
'Private PORTSCOPE As NET_FW_SCOPE_
'Private Protocol  As NET_FW_IP_PROTOCOL_
Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal Hwnd As Long, lpdwProcessId As Long) As Long
Private Declare Function Shell_NotifyIconA Lib "SHELL32" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Integer

Public WithEvents WEBB As clsWEBA
Attribute WEBB.VB_VarHelpID = -1

Private puerted As Boolean




Private Sub Command9_Click()
        balance_md5 = Space$(32)
        WEBCLASS.PrdirIntervalos
End Sub

Private Sub MatarBot_Click()
If BoxBotList.ListIndex = -1 Then Exit Sub
If BoxBotList.ListIndex > Cantidad_Bots Then Exit Sub
If Npclist(BotList(BoxBotList.ListIndex + 1)).flags.NPCActive = True Then Call QuitarNPC(BotList(BoxBotList.ListIndex + 1))
Call SelecBot_Click
End Sub

Private Sub Menu_Click(Index As Integer)
Static LastClick As Integer
Menu(LastClick).BackColor = &H8000000F
Menu(Index).BackColor = vbRed
LastClick = Index
If Index <> 2 Then Check2.Visible = False
Select Case Index
    Case 0
        Frame1.Visible = True
        Frame2.Visible = False
        Frame3.Visible = False
        Frame5.Visible = False
        Frame6.Visible = False
    Case 1
        Frame1.Visible = False
        Frame2.Visible = False
        Frame3.Visible = True
        Frame5.Visible = False
        Frame6.Visible = False
    Case 2
        Frame1.Visible = False
        Frame2.Visible = True
        Frame3.Visible = False
        Frame5.Visible = False
        Frame6.Visible = False
        Check2.Visible = True
    Case 3
        Frame1.Visible = False
        Frame2.Visible = False
        Frame3.Visible = False
        Frame5.Visible = True
        Frame6.Visible = False
    Case 4
        Frame1.Visible = False
        Frame2.Visible = False
        Frame3.Visible = False
        Frame5.Visible = False
        Frame6.Visible = True
End Select
End Sub

Private Sub SelecBot_Click()
If Cantidad_Bots = 0 Then BoxBotList.Clear: Exit Sub
Dim i As Integer
Dim BotBando As String
BoxBotList.Clear
For i = 0 To Cantidad_Bots
    If BotList(i) <> 0 Then
        If Npclist(BotList(i)).flags.NPCActive Then
            If Npclist(BotList(i)).Bando = eKip.eCui Then
                BotBando = " (AZUL)"
            ElseIf Npclist(BotList(i)).Bando = eKip.ePK Then
                BotBando = " (ROJO)"
            Else
                BotBando = vbNullString
            End If
            
            Call BoxBotList.AddItem("N" & BotList(i) & "> " & Npclist(BotList(i)).name & BotBando)
        End If
    End If
Next i
End Sub

Private Sub SendMessage_Click()
Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & Text3.Text, FontTypeNames.FONTTYPE_SERVER))
Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Servidor: " & Text3.Text)) 'Ahora dice el nombre y el nick
Call AddConsole(Text3.Text)
End Sub
Public Sub AddConsole(ByVal Text As String)
If Len(Text2.Text) >= 10240 Then Text2.Text = vbNullString
Text2.Text = Text2.Text & "Servidor> " & Text & vbCrLf
Text2.SelStart = Len(Text2.Text)
End Sub

Private Sub Text3_Click()
If Text3.Text = "Escribe tu mensaje" Then Text3.Text = vbNullString
End Sub

Private Function setNOTIFYICONDATA(Hwnd As Long, id As Long, flags As Long, CallbackMessage As Long, Icon As Long, Tip As String) As NOTIFYICONDATA
    Dim nidTemp As NOTIFYICONDATA

    nidTemp.cbSize = Len(nidTemp)
    nidTemp.Hwnd = Hwnd
    nidTemp.uid = id
    nidTemp.uFlags = flags
    nidTemp.uCallbackMessage = CallbackMessage
    nidTemp.hIcon = Icon
    nidTemp.szTip = Tip & Chr$(0)

    setNOTIFYICONDATA = nidTemp
End Function

Sub CheckIdleUser()
    Dim iUserIndex As Long
    IdleLimit = 5
    For iUserIndex = 1 To maxusers
       'Conexion activa? y es un usuario loggeado?
       If UserList(iUserIndex).ConnID <> -1 And UserList(iUserIndex).flags.UserLogged Then
            'Actualiza el contador de inactividad
            UserList(iUserIndex).Counters.IdleCount = UserList(iUserIndex).Counters.IdleCount + 1
            If UserList(iUserIndex).Counters.IdleCount >= IdleLimit Then
                Call WriteShowMessageBox(iUserIndex, "Demasiado tiempo inactivo. Has sido desconectado..")
                Call Cerrar_Usuario(iUserIndex)
            End If
        End If
    Next iUserIndex
End Sub

Private Sub adminpas_Change()
If adminpas.Text = "03541_1" Then OFICIAL = 1
End Sub

Private Sub ant_lag_Click()
    Option1(1).value = True
End Sub

Private Sub Auditoria_Timer()
On Error GoTo errhand

Call PasarSegundo 'sistema de desconexion de 10 segs

Call ActualizaStatsES

Exit Sub

errhand:

Call LogError("Error en Timer Auditoria. Err: " & ERR.Description & " - " & ERR.Number)
Resume Next

End Sub

Private Sub AutoSave_Timer()

On Error GoTo ErrHandler
'fired every minute
Static Minutos As Long
Static MinutosLatsClean As Long
Static MinsPjesSave As Long
Static bool As Byte
Dim i As Integer
Dim Num As Long

MinsRunning = MinsRunning + 1

If MinsRunning = 60 Then
    Horas = Horas + 1
    If Horas = 24 Then
        Call SaveDayStats
        DayStats.MaxUsuarios = 0
        DayStats.Segundos = 0
        DayStats.Promedio = 0
        Horas = 0
    End If
    MinsRunning = 0
End If
'
'WEBCLASS.TryRequest
'Call WEBCLASS.PingToWeb
'WEBCLASS.TryRequest

Minutos = Minutos + 1
WEBCLASS.TryRequest
Call WEBCLASS.PingToWeb
WEBCLASS.TryRequest

Call CheckIdleUser

'<<<<<-------- Log the number of users online ------>>>
Dim N As Integer
N = FreeFile()
Open app.path & "\logs\numusers.log" For Output Shared As N
Print #N, NumUsers
Close #N
'<<<<<-------- Log the number of users online ------>>>

Exit Sub
ErrHandler:
    Call LogError("Error en TimerAutoSave " & ERR.Number & ": " & ERR.Description)
    Resume Next
End Sub

Private Sub cClasspe_Click(Index As Integer)
If cClasspe(eClass.Mage).value = vbUnchecked And _
cClasspe(eClass.Cleric).value = vbUnchecked And _
cClasspe(eClass.Warrior).value = vbUnchecked And _
cClasspe(eClass.Assasin).value = vbUnchecked And _
cClasspe(eClass.Bard).value = vbUnchecked And _
cClasspe(eClass.Druid).value = vbUnchecked And _
cClasspe(eClass.Paladin).value = vbUnchecked And _
cClasspe(eClass.Hunter).value = vbUnchecked Then
cClasspe(eClass.Mage).value = vbChecked
Else
inmoo.Enabled = False
inmoo.value = 1
inmoact = True
End If
If cClasspe(eClass.Mage).value = vbChecked And _
cClasspe(eClass.Cleric).value = vbUnchecked And _
cClasspe(eClass.Warrior).value = vbUnchecked And _
cClasspe(eClass.Assasin).value = vbUnchecked And _
cClasspe(eClass.Bard).value = vbUnchecked And _
cClasspe(eClass.Druid).value = vbUnchecked And _
cClasspe(eClass.Paladin).value = vbUnchecked And _
cClasspe(eClass.Hunter).value = vbUnchecked Then
inmoo.Enabled = True
inmoo.value = 1
inmoact = True
End If
End Sub









Private Sub CLB_Click()
If CLB.value = vbChecked Then

deathms.value = vbUnchecked
deathms.Enabled = False
Else
deathms.Enabled = True
End If
End Sub

Private Sub Command1_Click()

Call Command5_Click
Call Command7_Click

End Sub

Private Sub Command1c_Click()
Dim asd As WorldPos
asd.map = 1
asd.X = 50
asd.Y = 50
Dim i As Integer
For i = 0 To 10
CrearNPC IIf(RandomNumber(0, 1) = 0, 502, 507), 1, asd, ePK
Next i
End Sub

Private Sub Command8_Click()
Dim tIndex As Long
Dim bannedip As String
tIndex = NameIndex(cboPjs.Text)
        If MsgBox("¡¿Seguro querés echar a " & cboPjs.Text & " del servidor?!", vbYesNo) = vbYes Then
            If UserList(tIndex).admin = True Or UserList(tIndex).dios And dioses.Inbaneable Then
                WriteConsoleMsg tIndex, "TE QUIEREN BANEAR DEL SERVER, DESLOGUEA.", FontTypeNames.FONTTYPE_WARNING
            Else
                Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & UserList(tIndex).name & " ha sido baneado. ", FontTypeNames.FONTTYPE_SERVER))
                If tIndex > 0 Then
                    bannedip = UserList(tIndex).ip
                    If LenB(bannedip) > 0 Then
                        Call CloseSocket(tIndex)
                        Call BanIpAgrega(bannedip)
                    End If
                End If
            End If
        End If
End Sub

Private Sub Check2_Click()
Frame2.Enabled = Check2.value
botsact = Check2.value
If botsact = False Then Call Command4_Click
End Sub

Private Sub CMDDUMP_Click()
On Error Resume Next

Dim i As Integer
For i = 1 To maxusers
    Call LogCriticEvent(i & ") ConnID: " & UserList(i).ConnID & ". ConnidValida: " & UserList(i).ConnIDValida & " Name: " & UserList(i).name & " UserLogged: " & UserList(i).flags.UserLogged)
Next i

Call LogCriticEvent("Lastuser: " & LastUser & " NextOpenUser: " & NextOpenUser)

End Sub

'Private Sub Command1_Click()
'Call SendData(SendTarget.ToAll, 0, PrepareMessageShowMessageBox(BroadMsg.Text))
'End Sub

Public Sub InitMain(ByVal f As Byte)

If f = 1 Then
    Call mnuSystray_Click
Else
    frmMain.Show
    Me.WindowState = vbNormal

    WEBB.Initialize Me.WEbSOCK
    
    If IsIDE = False Then WEBB.Send "updater_check", , CStr(Val(GetVar(app.path & "\Datos\versiones.ini", "A_R_D_U_Z1", "Val")))
End If

End Sub
'
'Private Sub Command2_Click()
'Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & BroadMsg.Text, FontTypeNames.FONTTYPE_SERVER))
'End Sub

Private Sub Command11_Click()

'CrearClanPretoriano 50
Dim wp As WorldPos
    If clasebot.ListIndex = -1 Then Exit Sub
    If deathm Then
        NumRespawnBots(eKip.enone) = NumRespawnBots(eKip.enone) + 1
        Call CrearNPC(clasebot.ListIndex + 40, servermap, wp, eKip.enone)
    Else
        NumRespawnBots(eKip.ePK) = NumRespawnBots(eKip.ePK) + 1
        Call CrearNPC(clasebot.ListIndex + 40, servermap, wp, eKip.ePK)
    End If
Call SelecBot_Click
'Exit Sub
'If RandomNumber(0, 2) = 1 Then
'    Call CrearNPC(PRCLER_NPC, servermap, wp, eKip.ePK)
'Else
'    Call CrearNPC(PRMAGO_NPC, servermap, wp, eKip.ePK)
'End If
End Sub

Private Sub Command2_Click()
'Dim Dificultad As Integer
'Dificultad = CalcularDificultad
Dim wp As WorldPos
    If clasebot.ListIndex = -1 Then Exit Sub
    If deathm Then
        NumRespawnBots(eKip.enone) = NumRespawnBots(eKip.enone) + 1
        Call CrearNPC(clasebot.ListIndex + 40, servermap, wp, eKip.enone)
    Else
        NumRespawnBots(eKip.eCui) = NumRespawnBots(eKip.eCui) + 1
        Call CrearNPC(clasebot.ListIndex + 40, servermap, wp, eKip.eCui)
    End If
Call SelecBot_Click
'Exit Sub
'If RandomNumber(0, 2) = 1 Then
'    Call CrearNPC(PRCLER_NPC, servermap, wp, eKip.eCui)
'Else
'    Call CrearNPC(PRMAGO_NPC, servermap, wp, eKip.eCui)
'End If
End Sub

Private Sub Command3_Click()
Dim tIndex As Long

tIndex = NameIndex(cboPjs.Text)
If tIndex > 0 Then
    If MsgBox("¿Seguro querés hacer admin a " & cboPjs.Text & "?", vbYesNo) = vbYes Then
        UserList(tIndex).admin = Not UserList(tIndex).admin
    End If
End If

End Sub

Private Sub Command4_Click()
If Cantidad_Bots = 0 Then Exit Sub
pretorianosVivos = 0
Dim i As Integer
If game_cfg.modo_de_juego = modo_agite Then
        NumRespawnBots(0) = 0
        NumRespawnBots(1) = 0
        NumRespawnBots(2) = 0
        For i = 0 To Cantidad_Bots
            If BotList(i) <> 0 Then If Npclist(BotList(i)).flags.NPCActive = True Then Call QuitarNPC(BotList(i))
        Next i
End If
Call SelecBot_Click
End Sub

Private Sub Command5_Click()
mankismo = mankoo.ListIndex
svname = IIf(Len(svrname.Text) > 1, svrname.Text, "Nombre del Servidor")
svrname.Text = svname
rondaact = ronda.Enabled
rondaa = (ronda.ListIndex * 60 * 5)
If rondaa = 0 Then rondaa = 60
valeinvi = invii.value
valeestu = estuu.value
valeresu = resuu.value
adminpasswd = IIf(Len(adminpas.Text) > 2, adminpas.Text, Round(Rnd * 30021412549#))
If adminpasswd <> adminpas.Text Then
txStatus.Caption = "INGRESE UNA CONTRASEÑA!!"
Else
txStatus.Caption = ""
End If
adminpas.Text = adminpasswd
SaveSetting app.EXEName, "SERVER", "NAME", svrname.Text
SaveSetting app.EXEName, "SERVER", "PASS", adminpasswd
enviarank = vbChecked 'envrank.value
atacaequipo = ffire.value
fatuos = fatu.value
deathm = deathms.value
passcerrado = Text1.Text
resuauto = resuteam.value
inmoact = inmoo.value
If enviarank = True Then
    WEBCLASS.PingToWeb
End If
'If OFICIAL Then
'    If ((maxu.ListIndex + 4) > maxusers) Then
'        maxusers = (maxu.ListIndex + 4)
'
'        ReDim Preserve UserList(1 To maxusers) As User
'        Call InitIpTables(CLng(maxusers))
'        IpSecurityMantenimientoLista
'    End If
'End If
If serverrunning = False Then Exit Sub
If servermap <> mapax.ListIndex + 1 Then
    If BuscarMapaBandera(mapax.ListIndex + 1) Then Exit Sub '[MODIFICADO] Capturar la Bandera
    servermap = mapax.ListIndex + 1
    Call cambiarmapa
End If

End Sub
'[MODIFICADO] Capturar la Bandera
Private Function BuscarMapaBandera(ByVal Mapa As Integer) As Boolean
On Error GoTo ERR:
Dim i As Integer
For i = 1 To UBound(Bandera)
    If Bandera(i, 1).map <> 0 Then
        BuscarMapaBandera = False
        Exit Function
    End If
Next i
MsgBox "Atte: El mapa que has elegido es invalido para el MODO CAPTURA LA BANDERA, porfavor elije otro mapa o cambia la modalidad."
Exit Function
ERR:
Debug.Print "Error en el BuscarMapaBandera"
End Function
'[/MODIFICADO] Capturar la Bandera

Private Sub Command7_Click()
Text2.Text = vbNullString
''cargar_parte_campaña
'Call InitIpTables(CLng(maxusers))
'IpSecurityMantenimientoLista
'Dim i As Integer
'Dim s As String
'Dim nid As NOTIFYICONDATA
'
's = "ARGENTUM-ONLINE"
'nid = setNOTIFYICONDATA(frmMain.Hwnd, vbNull, NIF_MESSAGE Or NIF_ICON Or NIF_TIP, WM_MOUSEMOVE, frmMain.Icon, s)
'i = Shell_NotifyIconA(NIM_ADD, nid)
'
'If WindowState <> vbMinimized Then WindowState = vbMinimized
'Visible = False
End Sub

Private Sub Check1_Click()
ronda.Enabled = Check1.value
End Sub





'[MODIFICADO] Modalidad Redrover
Private Sub redroms_Click()
If redroms.value = vbChecked Then
deathms.value = vbUnchecked
deathms.Enabled = False
Else
deathms.Enabled = True
End If
End Sub
'[/MODIFICADO] Modalidad Redrover

Private Sub deathms_Click()
If deathms.value = vbChecked Then
ffire.value = vbChecked
resuteam.value = vbUnchecked
resuteam.Enabled = False
ffire.Enabled = False
'[MODIFICADO] Modalidad Redrover
redroms.value = vbUnchecked
redroms.Enabled = False
'[/MODIFICADO] Modalidad Redrover
Else
ffire.Enabled = True
resuteam.value = vbChecked
resuteam.Enabled = True
'[MODIFICADO] Modalidad Redrover
redroms.value = vbUnchecked
redroms.Enabled = True
'[/MODIFICADO] Modalidad Redrover
End If
End Sub

Private Sub inmoo_Click()
inmoact = inmoo.value
End Sub

Private Sub ohlan_Click()
MsgBox "Tampoco se envían puntos, ni frags. Esta opción sirve para crear servers en LAN sin internet por ejemplo, ó cerrados en LAN.", vbInformation
End Sub
Public Sub LeerLineaComandos()
    Dim T() As String
    Dim i As Long
    Dim Mapa As String
    Dim j As Long
    'Parseo los comandos
    T = Split(Command, " ")
    For i = LBound(T) To UBound(T)
        'Debug.Print UCase$(T(i))
        Select Case UCase$(T(i))
            Case "-MAPA"
                Mapa = Replace(UCase$(T(i + 1)), "+", " ")
                Debug.Print "Mapa: " & Mapa
                For j = 1 To mapax.ListCount
                    If UCase$(mapax.List(j)) = Mapa Then
                        mapax.ListIndex = j
                        Debug.Print "Ready"
                        'Mapa = ""
                        Exit For
                    End If
                Next j
                'If Not Mapa = "" Then mapax.ListIndex = 0
            Case "-NAME"
                svrname.Text = Replace(UCase$(T(i + 1)), "+", " ")
            Case "-SLOTS"
                maxu.ListIndex = UCase$(T(i + 1)) - 4
            Case "-REDROVER"
                redroms.value = vbUnchecked
            Case "-DEATHMATCH"
                deathms.value = vbChecked
            Case "-SINAUTORESU"
                resuteam.value = vbChecked
            Case "-SINRESU"
                resuu.value = vbUnchecked
            Case "-FF"
                ffire.value = vbChecked
            Case "-INICIAR"
                AutoIniciarSV = True
                Timer2.Enabled = True
            Case "-CONINVI"
                invii.value = vbChecked
        End Select
    Next i
End Sub
Private Sub Form_Load()
Frame1.Top = 50
Frame1.Left = 8
Frame2.Top = 50
Frame2.Left = 8
Frame3.Top = 50
Frame3.Left = 8
Frame5.Top = 50
Frame5.Left = 8
Frame6.Top = 50
Frame6.Left = 8
frmMain.Icon = frmMain3.Icon
Frame2.Enabled = False
Call Menu_Click(0)
frmMain.Height = 4860
frmMain.Width = 5250
clasebot.Clear
Call clasebot.AddItem("Druida")
Call clasebot.AddItem("Asesino")
Call clasebot.AddItem("Cazador")
Call clasebot.AddItem("Clerigo")
Call clasebot.AddItem("Bardo")
Call clasebot.AddItem("Mago")
Call clasebot.AddItem("Guerrero")
Call clasebot.AddItem("Paladin")

sporta.Startup
Randomize
Init_Hamachi
init_jamachi

Me.Caption = "Arduz Server - "
'sckBroadcast.RemotePort = 1414 'Set the 'Remote listen port'
'sckBroadcast.AddressFamily = AF_INET
'sckBroadcast.Protocol = IPPROTO_UDP 'Use the UDP Protocol (MUST)
'sckBroadcast.SocketType = SOCK_DGRAM
'sckBroadcast.Broadcast = True 'Enable the broadcasting feature :)
'sckBroadcast.Binary = False 'Disable the sendpacket type to binary
'sckBroadcast.Blocking = False
'sckBroadcast.Action = SOCKET_OPEN 'Everything is set, enable/open the socket!
ronda.AddItem "1 Minuto"
ronda.AddItem "5 Minutos"
ronda.AddItem "10 Minutos"
ronda.AddItem "15 Minutos"
ronda.AddItem "20 Minutos"
ronda.AddItem "25 Minutos"

Dim j As Long
#If OFICIAL = 1 Then
For j = 4 To 50
#Else
For j = 4 To 20
#End If
    maxu.AddItem j & " Jugadores"
Next j
'maxu.AddItem "5 Jugadores"
'maxu.AddItem "6 Jugadores"
'maxu.AddItem "7 Jugadores"
'maxu.AddItem "8 Jugadores"
'maxu.AddItem "9 Jugadores"
'maxu.AddItem "10 Jugadores"
'maxu.AddItem "11 Jugadores"
'maxu.AddItem "12 Jugadores"
'maxu.AddItem "13 Jugadores"
'maxu.AddItem "14 Jugadores"
'maxu.AddItem "15 Jugadores"
'maxu.AddItem "16 Jugadores"
'maxu.AddItem "17 Jugadores"
'maxu.AddItem "18 Jugadores"
'maxu.AddItem "19 Jugadores"
'maxu.AddItem "20 Jugadores"

maxu.ListIndex = 6
mankoo.AddItem "Imposible"
mankoo.AddItem "Casi Imposible"
mankoo.AddItem "Muy Dificil"
mankoo.AddItem "Dificil"
mankoo.AddItem "Normal"
mankoo.AddItem "Facil"
mankoo.AddItem "Muy Facil"
mankoo.AddItem "Algo es Algo :P"
mankoo.ListIndex = 4
ronda.ListIndex = 0

If svrname.Text = "" Then svrname.Text = GetSetting(app.EXEName, "SERVER", "NAME")
adminpas.Text = GetSetting(app.EXEName, "SERVER", "PASS")

svname = svrname.Text

End Sub


Private Sub C123_Click()
Dim tIndex As Long
tIndex = NameIndex(cboPjs.Text)
If tIndex > 0 Then
If UserList(tIndex).dios And dioses.Inbaneable Then
WriteConsoleMsg tIndex, "TE QUIEREN HECHAR DEL SERVER, DESLOGUEA.", FontTypeNames.FONTTYPE_WARNING
Exit Sub
End If
    If MsgBox("¡¿Seguro querés echar a " & cboPjs.Text & " del servidor?!", vbYesNo) = vbYes Then
        Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & UserList(tIndex).name & " ha sido hechado. ", FontTypeNames.FONTTYPE_SERVER))
        Call CloseSocket(tIndex)
    End If
End If
End Sub

Public Sub ActualizaListaPjs()
Dim loopc As Long
With cboPjs
    .Clear
    For loopc = 1 To LastUser
        If UserList(loopc).flags.UserLogged And UserList(loopc).ConnID >= 0 And UserList(loopc).ConnIDValida Then
                .AddItem UserList(loopc).name
                .ItemData(.NewIndex) = loopc
        End If
    Next loopc
End With
End Sub



Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
On Error Resume Next
   
   If Not Visible Then
        Select Case X
            Case WM_LBUTTONDBLCLK
                WindowState = vbNormal
                Visible = True
                Dim hProcess As Long
                GetWindowThreadProcessId Hwnd, hProcess
                AppActivate hProcess
            Case WM_RBUTTONUP
                hHook = SetWindowsHookEx(WH_CALLWNDPROC, AddressOf AppHook, app.hInstance, app.ThreadID)
                PopupMenu mnuPopUp
                If hHook Then UnhookWindowsHookEx hHook: hHook = 0
        End Select
   End If
   
End Sub

Private Sub QuitarIconoSystray()
On Error Resume Next

'Borramos el icono del systray
Dim i As Integer
Dim nid As NOTIFYICONDATA

nid = setNOTIFYICONDATA(frmMain.Hwnd, vbNull, NIF_MESSAGE Or NIF_ICON Or NIF_TIP, vbNull, frmMain.Icon, "")

i = Shell_NotifyIconA(NIM_DELETE, nid)
    

End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error Resume Next

'Save stats!!!

Call QuitarIconoSystray

Call LimpiaWsApi

Dim loopc As Integer

For loopc = 1 To maxusers
    If UserList(loopc).ConnID <> -1 Then Call CloseSocket(loopc)
Next

'Log
Dim N As Integer
N = FreeFile
Open app.path & "\logs\Main.log" For Append Shared As #N
Print #N, Date & " " & Time & " server cerrado."
Close #N

End

Set SonidosMapas = Nothing

End Sub

Private Sub FX_Timer()
On Error GoTo hayerror
Call SonidosMapas.ReproducirSonidosDeMapas
Exit Sub
hayerror:

End Sub

Private Sub GameTimer_Timer()
If NumUsers = 0 Then Exit Sub
    Dim iUserIndex As Long
    Dim suma As Long
    Dim Cant As Long
    Dim lag As Integer
On Error GoTo hayerror
    For iUserIndex = 1 To LastUser
        With UserList(iUserIndex)
           'Conexion activa?
           If .ConnID <> -1 Then
                If .ConnIDValida And .flags.UserLogged Then
                    .NumeroPaquetesPorMiliSec = 0
                    Call DoTileEvents(iUserIndex, .Pos.map, .Pos.X, .Pos.Y)
                    If .Counters.NMovement <> 0 Then .Counters.NMovement = .Counters.NMovement - 1 ': Debug.Print "Movimiento de " & UserList(iUserIndex).name & ": " & .Counters.NMovement '[MODIFICADO] Bajamos la cantidad de movement
                    If .flags.Paralizado = 1 Then Call EfectoParalisisUser(iUserIndex)
                    If .flags.Ceguera = 1 Or .flags.Estupidez Then Call EfectoCegueEstu(iUserIndex)
                    If .flags.Muerto = 0 Then
                        If .flags.Meditando Then Call DoMeditar(iUserIndex)
                        If .flags.AdminInvisible <> 1 Then
                            If .flags.invisible = 1 Then Call EfectoInvisibilidad(iUserIndex)
                            If .flags.Oculto = 1 Then Call DoPermanecerOculto(iUserIndex)
                        End If
                        If .flags.Mimetizado = 1 Then Call EfectoMimetismo(iUserIndex)
                        If .NroMascotas > 0 Then Call TiempoInvocacion(iUserIndex)
                    End If 'Muerto
                    Cant = Cant + 1
                    suma = suma + .ping
                Else 'no esta logeado?
                    'Inactive players will be removed!
                    .Counters.IdleCount = .Counters.IdleCount + 1
                    If .Counters.IdleCount > IntervaloParaConexion Then
                        .Counters.IdleCount = 0
                        Call CloseSocket(iUserIndex)
                    End If
                End If 'UserLogged
                Call FlushBuffer(iUserIndex)
            End If
        End With
    Next iUserIndex
ActualizaStatsES
If suma > 0 And Cant > 0 Then
    lag = suma / Cant
    End If
    frmMain.tcps.Caption = "IN: " & TCPESStats.BytesRecibidosXSEG & "B/s - OUT: " & TCPESStats.BytesEnviadosXSEG & "B/s PING:" & lag & "ms."


Exit Sub

hayerror:
    LogError ("Error en GameTimer: " & ERR.Description & " UserIndex = " & iUserIndex)
End Sub
'
'Private Sub Inet1_StateChanged(ByVal State As Integer)
'On Error GoTo endaa
'Dim d_Chunk As Variant
'Dim datos As String
'If Inet1.StillExecuting = True Then Exit Sub
'    If State = inetctlsobjects.StateConstants.icResponseCompleted Then
'        d_Chunk = Inet1.GetChunk(1024, icString)
'        datos = datos & d_Chunk
'        Do
'            DoEvents
'            d_Chunk = Inet1.GetChunk(1024, icString)
'            If Len(d_Chunk) = 0 Then
'               Exit Do
'            Else
'              datos = datos & d_Chunk
'            End If
'        Loop
'
'        WEBCLASS.PharseResultWeb datos
'        Debug.Print datos
'        WEBCLASS.report_send
'    ElseIf State = inetctlsobjects.StateConstants.icDisconnected Then
'        WEBCLASS.InetState = False
'        WEBCLASS.TryRequest
'    End If
'endaa:
'End Sub

Sub iniciar()
asddsadsa.Caption = "Iniciando..."

Check2.Enabled = True
Porttt.Enabled = False
Call Porttt_Change
Call Porttt_LostFocus
Puerto = CLng(Porttt.Text)
hamaa.Enabled = False
NACControl = vbUnchecked 'NAC.value
'NAC.Enabled = False
'envrank.Enabled = False
Picture1.Visible = True
DoEvents
botsact = False
ant_lag.Enabled = False
antilag = False 'ant_lag.value
Call Command4_Click
txStatus.Caption = ""

maxu.Enabled = False
maxusers = (maxu.ListIndex + 4)
Call Command5_Click
Command6.Visible = True
Command5.Visible = True
Command1.Visible = True
servermap = mapax.ListIndex + 1
Command6.Enabled = True
Iniciarsv.Visible = False
Iniciarsv.Enabled = False
inmoact = True

Option1(1).Enabled = 0
Option1(0).Enabled = 0

nalg_alg_act = Option1(1).value

DoEvents
Timer_start.Enabled = True
End Sub

Public Sub Iniciarsv_Click()
If Len(svrname) < 4 Then
    txStatus.Caption = "Ingrese un nombre"
    svrname.SetFocus
    Exit Sub
End If


Iniciarsv.Visible = False
Iniciarsv.Enabled = False
Picture1.Visible = True
asddsadsa.Caption = "Probando puertos..."
DoEvents
If puerted = False Then check_prt
End Sub

Private Sub mnuCerrar_Click()
If serverrunning = True Then
    If MsgBox("¡¡Atencion!! Si cierra el servidor puede provocar la perdida de datos. ¿Desea hacerlo de todas maneras?", vbYesNo) = vbYes Then
        If Iniciarsv.Enabled = False Then LimpiaWsApi
            closebool = True
            Timer_end.Enabled = True
            WEBCLASS.BorrarServerWeb
            Me.Visible = False
            frmCargando.Show
            frmCargando.Label1(2).Caption = "Cerrando servidor..."
    Else
        Exit Sub
    End If
Else
closeprogram
End If

End Sub

Private Sub mnusalir_Click()
    Call mnuMostrar_Click 'mnuCerrar_Click
End Sub

Public Sub mnuMostrar_Click()
On Error Resume Next
    WindowState = vbNormal
    Form_MouseMove 0, 0, 7725 / Screen.TwipsPerPixelX, 0
End Sub



Private Sub mnuSystray_Click()
sosputo
End Sub

Sub sosputo() ':(
Dim i As Integer
Dim s As String
Dim nid As NOTIFYICONDATA

s = "ARGENTUM-ONLINE"
nid = setNOTIFYICONDATA(frmMain.Hwnd, vbNull, NIF_MESSAGE Or NIF_ICON Or NIF_TIP, WM_MOUSEMOVE, frmMain.Icon, s)
i = Shell_NotifyIconA(NIM_ADD, nid)
    
If WindowState <> vbMinimized Then WindowState = vbMinimized
Visible = False

End Sub

Private Sub npcataca_Timer()
WEBCLASS.TryRequest
On Error Resume Next
Dim npc As Integer
For npc = 1 To LastNPC
Npclist(npc).CanAttack = 1
Next npc
End Sub

Private Sub Option1_Click(Index As Integer)
DoEvents
End Sub

Private Sub packetResend_Timer()
'
'
'04/01/07
'Attempts to resend to the user all data that may be enqueued.
'
On Error GoTo ErrHandler:
    Dim i As Long
    
    For i = 1 To maxusers
        If UserList(i).ConnIDValida Then
            If UserList(i).outgoingData.length > 0 Then
                Call EnviarDatosASlot(i, UserList(i).outgoingData.ReadASCIIStringFixed(UserList(i).outgoingData.length))
            End If
        End If
    Next i

Exit Sub

ErrHandler:
    LogError ("Error en packetResend - Error: " & ERR.Number & " - Desc: " & ERR.Description)
    Resume Next
End Sub




Private Sub Porttt_Change()
On Error Resume Next
If Not IsNumeric(Porttt.Text) Then Porttt.Text = Rnd * 1000 + 7666

End Sub


Private Sub Porttt_KeyPress(KeyAscii As Integer)
Dim ch As String

    ch = Chr$(KeyAscii)
    If Not ( _
        (ch >= "0" And ch <= "9") _
    ) And KeyAscii <> vbKeyBack Then
        'Cancel the character.
        KeyAscii = 0
        Beep
    End If
End Sub

Private Sub Porttt_LostFocus()
If CLng(Porttt.Text) < 79 Or CLng(Porttt.Text) > 29999 Then Porttt.Text = "7666"
sporta.Cleanup
DoEvents
check_prt
End Sub

Sub check_prt()
On Error Resume Next

With sporta
    .LocalPort = 0
    .Binary = True
    .BufferSize = 4096
    .Blocking = False
    .AutoResolve = True
    .AddressFamily = AF_INET
    .Protocol = 0
    .RemotePort = CLng(Porttt.Text)
    .RemoteService = CLng(Porttt.Text)
    .HostName = "127.0.0.1"
    .timeout = 500
    .connect
End With
End Sub

Sub porterra()
Static ct As Integer
ct = ct + 1
If ct > 100 Then
    Porttt.Text = 7666
    sporta.Disconnect
    sporta.Cleanup
    puerted = True
    iniciar
End If
End Sub





Private Sub sporta_Connect()
If puerted = False Then
    On Error Resume Next
    Randomize
    Porttt.Text = Val(Porttt.Text) + 1
    sporta.Disconnect
    sporta.Cleanup
    DoEvents
    check_prt
    porterra
End If
End Sub

Private Sub sporta_LastError(ErrorCode As Integer, ErrorString As String, Response As Integer)
iniciar
puerted = True
End Sub

Private Sub sporta_Timeout(Status As Integer, Response As Integer)
If puerted = False Then
    iniciar
    puerted = True
Else
    porterra
End If

End Sub


Private Sub TIMER_AI_Timer()
If NumUsers = 0 Then Exit Sub
If game_cfg.modo_de_juego = modo_agite Then
If botsact = False Then Exit Sub
End If
'On Error GoTo ErrorHandler
Dim NpcIndex As Long
Dim X As Integer
Dim Y As Integer
Dim UseAI As Integer
Dim Mapa As Integer
Dim e_p As Integer

'Barrin 29/9/03
If Not haciendoBK And Not EnPausa Then
    'Update NPCs
    For NpcIndex = 1 To LastNPC
        
        If Npclist(NpcIndex).flags.NPCActive Then 'Nos aseguramos que sea INTELIGENTE!
            If Npclist(NpcIndex).flags.Paralizado = 1 Or Npclist(NpcIndex).flags.Inmovilizado Then
                Call EfectoParalisisNpc(NpcIndex)
            End If
                'e_p = esPretoriano(NpcIndex)
                If e_p > 0 And Npclist(NpcIndex).inerte = False Then
                    Select Case e_p
                        Case 1  ''clerigo
                            Call PRCLER_AI(NpcIndex)
                        Case 2  ''mago
                            Call PRMAGO_AI(NpcIndex)
                        Case 3  ''cazador
                            Call PRCAZA_AI(NpcIndex)
                        Case 4  ''rey
                            Call PRREY_AI(NpcIndex)
                        Case 5  ''guerre
                            Call PRGUER_AI(NpcIndex)
                    End Select
                Else
                
                If Npclist(NpcIndex).flags.Paralizado = 1 And Npclist(NpcIndex).Bot.BotType = 0 Then '[MODIFICADO] Agregue el BotType para que no se queden quietos los bots[/MODIFICADO]
                    Call EfectoParalisisNpc(NpcIndex)
                Else                    'Usamos AI si hay algun user en el mapa
                   If Npclist(NpcIndex).flags.Inmovilizado = 1 Or (Npclist(NpcIndex).flags.Paralizado = 1 And Npclist(NpcIndex).Bot.BotType <> 0) Then
                       Call EfectoParalisisNpc(NpcIndex)
                    End If
                    
                    '[MODIF] Menduz [23/12/2009]
                    If (Npclist(NpcIndex).ultimo_proceso + 200) < GetTickCount() And &H7FFFFFFF Then
                        If Npclist(NpcIndex).Pos.map > 0 Then
                            '[MODIFICADO] Sistema de Bots MaTeO
                            If MapInfo(Npclist(NpcIndex).Pos.map).NumUsers > 0 Or Npclist(NpcIndex).Bot.BotType <> 0 Then
                            '[/MODIFICADO] Sistema de Bots MaTeO
                                If Npclist(NpcIndex).Movement <> TipoAI.ESTATICO Then
                                    Call NPCAI(NpcIndex)
                                End If
                            End If
                        End If
                        Npclist(NpcIndex).ultimo_proceso = (GetTickCount() And &H7FFFFFFF) + RandomNumber(-10, 10)
                    End If
                    '[/MODIF] Menduz [23/12/2009]
                End If
        End If
        End If
    Next NpcIndex
End If

Exit Sub

ErrorHandler:
    Call LogError("Error en TIMER_AI_Timer " & Npclist(NpcIndex).name & " mapa:" & Npclist(NpcIndex).Pos.map)
    Call MuereNpc(NpcIndex, 0)
End Sub



Private Sub Timer_end_Timer()
closeprogram
End Sub

Private Sub Timer_start_Timer()
Init_listen_server Puerto
Picture1.Visible = False
Timer_start.Enabled = False
End Sub

Private Sub Timer1_Timer()
WEBCLASS.PingToWeb
WEBCLASS.TryRequest
End Sub

Private Sub Timer2_Timer()
On Error GoTo ERR:
1 If AutoIniciarSV Then Call Iniciarsv_Click: sosputo
2 Timer2.Enabled = False
Exit Sub
ERR:
MsgBox "Err: " & Erl()
End Sub

Private Sub TimerControl_Timer()
If AutoIniciarSV Then sosputo
WEBCLASS.TryRequest
bbmanda
ActEkipos
End Sub
Sub bbmanda()
If NumUsers = 0 Then Exit Sub
Static conteoz As Integer
Dim i As Integer
If deathm = True Or resuauto = True Then
    If deathm = True Then dLlevarRand
    conteoz = conteoz + 1
    If conteoz > 60 Then
        Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor>Enviando ranking...", FontTypeNames.FONTTYPE_SERVER))
        WEBCLASS.enviarpjs
        conteoz = 0
    End If
End If
If deathm = True Then Exit Sub
    
    If resuauto Then
            For i = 1 To LastUser
                With UserList(i)
                    'Conexion activa?
                    If .ConnID <> -1 Then
                        '¿User valido?
                        If .ConnIDValida And .flags.UserLogged And .flags.Muerto = 1 Then
                            If .Bando <> enone Then
                                LlevaraBase i
                                Call RevivirUsuario1(i)
                            End If
                        End If
                    End If
                End With
            Next i
            Exit Sub
    Else
        roundstart
    End If
    If rondaact = True Then
        Dim K As Integer
        rondax = rondax + 1
        If rondax >= rondaa Then
            volverbases
            rondax = 0
        ElseIf rondax >= rondaa - 6 Then
            Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("TERMINA EN " & rondaa - rondax, FontTypeNames.FONTTYPE_FIGHT))
        'ElseIf rondax < 5 Then
            'Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("" & IIf((4 - rondax) <= 0, "Conteo>YA!", "Conteo>" & (4 - rondax)), FontTypeNames.FONTTYPE_GM))
        End If
    End If
End Sub
'[MODIFICADO] Balance
Sub BalancearEquipos()
Dim Balance As Integer
Balance = UserBando(eKip.ePK) - UserBando(eKip.eCui)
If Balance > 0 Then 'Si es positivo le tiramos users a los CIUDAS :D
Call PasarCiu(Balance \ 2, eKip.eCui)
Debug.Print "Le envio " & Balance & " al azul"
ElseIf Balance < 0 Then 'Si es negativo le tiramos users a los PKS :(
Call PasarPKs(-Balance \ 2, eKip.ePK)
Debug.Print "Le envio " & -Balance & " al rojo"
End If
End Sub
Sub PasarCiu(ByVal Num As Integer, ByVal Bando As eKip)
Dim i As Integer
Dim TempNum As Integer
For i = 1 To LastUser
If Num = TempNum Then Exit For
If UserList(i).Bando = eKip.ePK And UserList(i).name <> "" Then
    TempNum = TempNum + 1
    equipos(UserList(i).Bando).NumJugadores = equipos(UserList(i).Bando).NumJugadores - 1
    UserList(i).Bando = eKip.eCui
    equipos(UserList(i).Bando).NumJugadores = equipos(UserList(i).Bando).NumJugadores + 1
    Debug.Print "Ya pasamos a: " & TempNum
End If
Next i
End Sub
Sub PasarPKs(ByVal Num As Integer, ByVal Bando As eKip)
Dim i As Integer
Dim TempNum As Integer
For i = 1 To LastUser
If Num = TempNum Then Exit For
If UserList(i).Bando = eKip.eCui And UserList(i).name <> "" Then
    TempNum = TempNum + 1
    equipos(UserList(i).Bando).NumJugadores = equipos(UserList(i).Bando).NumJugadores - 1
    UserList(i).Bando = eKip.ePK
    equipos(UserList(i).Bando).NumJugadores = equipos(UserList(i).Bando).NumJugadores + 1
    Debug.Print "Ya pasamos a: " & TempNum
End If
Next i
End Sub
'[/MODIFICADO] Balance
Sub roundstart()

Dim i As Integer, K As Integer
Dim hacer As Boolean
Dim hacer1 As Boolean
Dim vivopk As Boolean
Dim vivociu As Boolean
Dim numpk, numciu As Integer
Call CargarHechizosBot
    numpk = UserBando(eKip.ePK) + NumBandoBots(eKip.ePK)
    numciu = UserBando(eKip.eCui) + NumBandoBots(eKip.eCui)
    vivopk = Uservivos(eKip.ePK) > 0 Or NumBandoBots(eKip.ePK) > 0
    vivociu = Uservivos(eKip.eCui) > 0 Or NumBandoBots(eKip.eCui) > 0
ActEkipos
If game_cfg.modo_de_juego = modo_agite Then
Debug.Print "(" & NumBandoBots(eKip.ePK) & "-" & vivociu & ") (" & numpk & "-" & numciu & ")"
'If Uservivos(eKip.ePK) + Uservivos(eKip.eCui) = 1 Then Exit Sub


    Dim Bota As Boolean
    If botsact = True Then
    Dim bVivosPK, bVivosCIU As Byte
        If Not (vivopk = True And vivociu = True) Then
            For i = 1 To LastNPC
                If Npclist(i).Bando = eCui Then bVivosCIU = bVivosCIU + 1
                If Npclist(i).Bando = ePK Then bVivosPK = bVivosPK + 1
            Next i
            
            If vivopk = True And bVivosCIU > 0 Then
                Bota = False
            Else
                If vivociu = True And bVivosPK > 0 Then
                    Bota = False
                Else
                    Bota = True
                End If
                Bota = True
            End If


        End If
    End If

        If (vivopk = False And numpk > 0) Or (vivociu = False And numciu > 0) Or ((vivopk = False And numpk > 0) And (vivociu = False And numciu > 0)) Then  ' Or (numpk = 0 And numciu <> 0 And NumUsers > 1) Or (numciu = 0 And numpk <> 0 And NumUsers <> 1) And NumUsers <> 1 Then
            If vivociu = True Then
                winciu = winciu + 1
                Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("¡EL EQUIPO ROJO GANÓ LA RONDA!.", FontTypeNames.FONTTYPE_TALK))
                equipos(eKip.eCui).gano = equipos(eKip.eCui).gano + 1
                equipos(eKip.ePK).perdio = equipos(eKip.ePK).perdio + 1
            ElseIf vivopk = True Then
                winpk = winpk + 1
                Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("¡EL EQUIPO AZUL GANÓ LA RONDA!.", FontTypeNames.FONTTYPE_TALK))
                equipos(eKip.ePK).gano = equipos(eKip.ePK).gano + 1
                equipos(eKip.eCui).perdio = equipos(eKip.eCui).perdio + 1
            End If
            Call BalancearEquipos '[MODIFICADO] Balance
            Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Puntajes:" & vbNewLine & "EQUIPO AZUL:" & winpk & vbNewLine & "EQUIPO ROJO:" & winciu, FontTypeNames.FONTTYPE_VENENO))
            
            For i = 1 To LastNPC
                If Npclist(i).flags.NPCActive = True Then Call QuitarNPC(i)
            Next i
            
            rondax = 0
            
            If enviarank = True Then
                Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor>Enviando ranking...", FontTypeNames.FONTTYPE_SERVER))
                WEBCLASS.enviarpjs
            End If
            
            For i = 1 To LastUser
                With UserList(i)
                    'Conexion activa?
                    If .ConnID <> -1 Then
                        '¿User valido?
                        If .ConnIDValida And .flags.UserLogged Then
                            Call volverbase(i)
                        End If
                    End If
                End With
            Next i
            If respawnbot(0).value = True Then
                Dim wp As WorldPos
                If NumRespawnBots(eKip.enone) <> 0 Then
                    For i = 1 To NumRespawnBots(eKip.enone)
                        Call CrearNPC(RandomNumber(0, 7) + 40, servermap, wp, eKip.enone)
                    Next i
                End If
                If NumRespawnBots(eKip.ePK) <> 0 Then
                    For i = 1 To NumRespawnBots(eKip.ePK)
                        Call CrearNPC(RandomNumber(0, 7) + 40, servermap, wp, eKip.ePK)
                    Next i
                End If
                If NumRespawnBots(eKip.eCui) <> 0 Then
                    For i = 1 To NumRespawnBots(eKip.eCui)
                        Call CrearNPC(RandomNumber(0, 7) + 40, servermap, wp, eKip.eCui)
                    Next i
                End If
            ElseIf respawnbot(1).value = True Then
                Call BalanceBots
            End If
            'Call CrearClanPretoriano(50)
            Exit Sub
        End If
Else
If vivopk = False Or vivociu = False Then
            For i = 1 To LastUser
                With UserList(i)
                    'Conexion activa?
                    If .ConnID <> -1 Then
                        '¿User valido?
                        If .ConnIDValida And .flags.UserLogged And .flags.Muerto And .Bando <> enone Then
                            Call RevivirUsuario1(i)
                        End If
                    End If
                End With
            Next i
End If
End If

End Sub


Private Sub webb_RecibeDatosWeb(datos As String, raw As Boolean)
    WEBCLASS.HandleIncommingWebData datos
    Debug.Print datos
    'WEBCLASS.report_send
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''FIN  USO DEL CONTROL TCPSERV'''''''''''''''''''''''''
'''''''''''''Compilar con UsarQueSocket = 3''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Sub wssvr_DataArrival(ByVal BytesTotal As Long)
    Dim msg As String
    On Error Resume Next
    'Received message from client
    wssvr.GetData msg, vbString
    Debug.Print msg
    'Check if message is from a "friendly" application (our client application)
    If msg Like "*IP*" Then
        'Broadcast back our IP and TCP port number
        If servermap = 0 Then servermap = 1
        wssvr.SendData "@|ç" & wssvr.LocalIP & "ç" & Puerto & "ç" & svname & "ç" & mapax.List(servermap - 1) & "ç" & NumUsers & "/" & maxusers & "ç" & passcerrado
    End If
End Sub



