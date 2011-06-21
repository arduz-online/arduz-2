VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5250
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7845
   LinkTopic       =   "Form1"
   ScaleHeight     =   350
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   523
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin Proyecto1.Fast_Web Fast_Web1 
      Height          =   480
      Left            =   1080
      TabIndex        =   5
      Top             =   3000
      Width           =   480
      _extentx        =   847
      _extenty        =   847
   End
   Begin VB.CommandButton cmdSelMapa 
      Caption         =   "Seleccionar Mapa"
      Height          =   495
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   1815
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   6480
      Top             =   120
   End
   Begin VB.PictureBox Picture1 
      Height          =   3135
      Left            =   120
      ScaleHeight     =   205
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   685
      TabIndex        =   3
      Top             =   5520
      Width           =   10335
   End
   Begin VB.PictureBox asd 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1515
      Left            =   6480
      ScaleHeight     =   100
      ScaleMode       =   0  'User
      ScaleWidth      =   100
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   1500
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   1920
      TabIndex        =   1
      Top             =   480
      Width           =   1695
   End
   Begin VB.FileListBox File1 
      Height          =   285
      Left            =   120
      Pattern         =   "*h.bmp"
      TabIndex        =   0
      Top             =   120
      Width           =   255
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Me.Show
Dim Conversor As New clsConvertidoraMapas

Conversor.LoadMap app.Path & "\MapasAO\", 1
MsgBox "Cargado el mapa """ & Conversor.NombreMapa & """"
Conversor.Guardar app.Path & "\MapasArduz\1.am"
'DoEvents
'Dim i As Integer
'For i = 1 To 15
'LMAP i
'Guardar i
'Next i
End Sub
