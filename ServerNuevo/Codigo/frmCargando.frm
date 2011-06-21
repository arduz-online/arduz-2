VERSION 5.00
Begin VB.Form frmCargando 
   BackColor       =   &H00000040&
   BorderStyle     =   0  'None
   Caption         =   "Argentum"
   ClientHeight    =   840
   ClientLeft      =   1410
   ClientTop       =   3000
   ClientWidth     =   6405
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   70.658
   ScaleMode       =   0  'User
   ScaleWidth      =   427
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00000000&
      Height          =   495
      Left            =   15
      ScaleHeight     =   29
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   421
      TabIndex        =   1
      Top             =   333
      Width           =   6375
      Begin VB.Shape Shape1 
         BorderColor     =   &H00FFFFFF&
         BorderStyle     =   0  'Transparent
         DrawMode        =   12  'Nop
         FillColor       =   &H0072899A&
         FillStyle       =   0  'Solid
         Height          =   495
         Left            =   0
         Top             =   0
         Width           =   6375
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Cargando Arduz Server..."
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   210
         Index           =   2
         Left            =   120
         TabIndex        =   2
         Top             =   120
         Width           =   6045
      End
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Cargando, por favor espere..."
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Index           =   3
      Left            =   105
      TabIndex        =   0
      Top             =   60
      Width           =   2895
   End
End
Attribute VB_Name = "frmCargando"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
