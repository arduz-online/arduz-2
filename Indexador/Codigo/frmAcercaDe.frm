VERSION 5.00
Begin VB.Form frmAcercaDe 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Acerca de..."
   ClientHeight    =   4575
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4275
   Icon            =   "frmAcercaDe.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4575
   ScaleWidth      =   4275
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdAceptar 
      BackColor       =   &H00C0FFC0&
      Caption         =   "&Aceptar"
      Height          =   375
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   4080
      Width           =   3615
   End
   Begin VB.Label lblLink 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "WebSite: http://www.gs-zone.com.ar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   225
      Left            =   690
      TabIndex        =   4
      Top             =   3360
      Width           =   2955
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackColor       =   &H00004000&
      Caption         =   "Agradecimientos especiales a KIKO"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080FF80&
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   3720
      Width           =   3855
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BackColor       =   &H00004000&
      Caption         =   "Programado por ^[GS]^"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   3000
      Width           =   3975
   End
   Begin VB.Label lblVersion 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "v?.? build ?"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0C0C0&
      Height          =   255
      Left            =   1545
      TabIndex        =   1
      Top             =   2640
      Width           =   1110
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Indexador HiPr0"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   27.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   630
      Left            =   120
      TabIndex        =   0
      Top             =   2040
      Width           =   3960
   End
   Begin VB.Image LogoGS 
      Height          =   2175
      Left            =   1080
      Picture         =   "frmAcercaDe.frx":0442
      Top             =   240
      Width           =   2175
   End
End
Attribute VB_Name = "frmAcercaDe"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAceptar_Click()
Unload Me
End Sub

Private Sub Form_Load()
lblVersion.Caption = "v" & App.Major & "." & App.Minor & " build " & App.Revision

End Sub

Private Sub Label2_Click()

End Sub

Private Sub lblLink_Click()
Call ShellExecute(Me.hwnd, "Open", "http://www.gs-zone.com.ar", &O0, &O0, SW_NORMAL)

End Sub
