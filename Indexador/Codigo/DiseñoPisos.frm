VERSION 5.00
Begin VB.Form DiseñoPisos 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[Diseñar Pisos]"
   ClientHeight    =   2940
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4365
   Icon            =   "DiseñoPisos.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   2940
   ScaleWidth      =   4365
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdDiseñar 
      Caption         =   "&Diseñar"
      Height          =   615
      Left            =   240
      TabIndex        =   10
      Top             =   2160
      Width           =   3975
   End
   Begin VB.TextBox NombreGrh 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   1920
      TabIndex        =   8
      Text            =   "0"
      Top             =   1680
      Width           =   2055
   End
   Begin VB.TextBox Alto 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   1920
      TabIndex        =   6
      Text            =   "32"
      Top             =   1320
      Width           =   855
   End
   Begin VB.TextBox Ancho 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   1920
      TabIndex        =   4
      Text            =   "32"
      Top             =   960
      Width           =   855
   End
   Begin VB.TextBox Nombre 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   1920
      TabIndex        =   2
      Top             =   600
      Width           =   2055
   End
   Begin VB.TextBox GRH 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   1920
      TabIndex        =   0
      Text            =   "1"
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Grafico BMP:"
      ForeColor       =   &H0000FF00&
      Height          =   195
      Left            =   360
      TabIndex        =   9
      Top             =   1680
      Width           =   945
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Alto/Height:"
      ForeColor       =   &H0000FF00&
      Height          =   195
      Left            =   360
      TabIndex        =   7
      Top             =   1320
      Width           =   855
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ancho/Width:"
      ForeColor       =   &H0000FF00&
      Height          =   195
      Left            =   360
      TabIndex        =   5
      Top             =   960
      Width           =   1005
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   360
      TabIndex        =   3
      Top             =   600
      Width           =   975
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Grh Inicial:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   360
      TabIndex        =   1
      Top             =   240
      Width           =   975
   End
End
Attribute VB_Name = "DiseñoPisos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
