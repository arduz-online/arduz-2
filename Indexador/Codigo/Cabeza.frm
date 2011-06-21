VERSION 5.00
Begin VB.Form CabezaM 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[CABEZAS]"
   ClientHeight    =   4065
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4005
   Icon            =   "Cabeza.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4065
   ScaleWidth      =   4005
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Anim 
      Interval        =   250
      Left            =   3360
      Top             =   360
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   1410
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   11
      Top             =   2520
      Width           =   3735
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   615
      Index           =   3
      Left            =   2040
      ScaleHeight     =   555
      ScaleWidth      =   555
      TabIndex        =   9
      Top             =   840
      Width           =   615
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   3
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   10
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   3
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   3
         Left            =   0
         TabIndex        =   15
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   615
      Index           =   2
      Left            =   2640
      ScaleHeight     =   555
      ScaleWidth      =   555
      TabIndex        =   7
      Top             =   840
      Width           =   615
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   2
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   8
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   2
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   2
         Left            =   0
         TabIndex        =   14
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   615
      Index           =   1
      Left            =   3240
      ScaleHeight     =   555
      ScaleWidth      =   555
      TabIndex        =   5
      Top             =   840
      Width           =   615
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   1
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   6
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   1
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   1
         Left            =   0
         TabIndex        =   13
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   615
      Index           =   0
      Left            =   2640
      ScaleHeight     =   555
      ScaleWidth      =   555
      TabIndex        =   3
      Top             =   240
      Width           =   615
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   0
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   4
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   0
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   0
         Left            =   0
         TabIndex        =   12
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox Imagen 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   855
      Left            =   2040
      ScaleHeight     =   795
      ScaleWidth      =   1755
      TabIndex        =   1
      Top             =   1560
      Width           =   1815
      Begin VB.PictureBox Img 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   2
         Top             =   120
         Width           =   2895
         Begin VB.Image Ix 
            Height          =   135
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
   End
   Begin VB.ListBox Listado 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   2205
      Left            =   120
      TabIndex        =   0
      Top             =   200
      Width           =   1815
   End
End
Attribute VB_Name = "CabezaM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Selecc As Integer
Dim Paso As Integer

Private Sub Anim_Timer()
On Error Resume Next
Dim i As Integer, Gr As Integer
Dim ImagenX As String
If Selecc <= 0 Or Selecc > NumHeads Then Exit Sub
Paso = Paso + 1
Ix.Visible = False
Img.Left = Imagen.Width / 3
Img.Top = Imagen.Height / 3
Img.CurrentX = 0
Img.CurrentY = 0
Img.Visible = False
Ix.Left = 0
Ix.Top = 0
Gr = HeadData(Selecc).Head(Paso).GrhIndex
ImagenX = DirClien & "\GRAFICOS\" & GrhData(Gr).FileNum & ".BMP"
If LenB(Dir(ImagenX, vbArchive)) = 0 Then Exit Sub
Ix.Picture = LoadPicture(ImagenX)
Img.Width = GrhData(Gr).pixelWidth * 15
Img.Height = GrhData(Gr).pixelHeight * 15
Ix.Left = Ix.Left - GrhData(Gr).sx * 15
Ix.Top = Ix.Top - GrhData(Gr).sy * 15
Img.Visible = True
Ix.Visible = True
If Paso = 4 Then Paso = 0
End Sub

Private Sub Form_Load()
Dim i As Integer
Paso = 0
Selecc = 0
Me.Icon = Form1.Icon
Me.Caption = Form1.Caption & " [CABEZAS]"
Listado.Clear
For i = 0 To NumHeads
    If HeadData(i).Head(1).GrhIndex > 0 Then
        Listado.AddItem i
    End If
Next
End Sub

Private Sub Listado_Click()
Dim i As Integer, Gr As Integer
Dim ImagenX As String
GRHt.Text = "[HEAD" & Listado.Text & "]" & vbCrLf & vbCrLf
Img.Visible = False
Selecc = Listado.Text
Paso = 0
For i = 0 To 3
    HDX(i).Visible = False
    HDCx(i).CurrentX = 0
    HDCx(i).CurrentY = 0
    HDCx(i).Visible = False
    HDX(i).Left = 0
    HDX(i).Top = 0
    Gr = HeadData(Listado.Text).Head(i + 1).GrhIndex
    GRHt.Text = GRHt.Text & "Head" & (i + 1) & "=" & Gr & vbCrLf
    HX(i).Caption = Gr
    If LenB(Dir(DirClien & "\GRAFICOS\" & GrhData(Gr).FileNum & ".BMP", vbArchive)) = 0 Then Exit Sub
    ImagenX = DirClien & "\GRAFICOS\" & GrhData(Gr).FileNum & ".BMP"
    HDX(i).Picture = LoadPicture(ImagenX)
    HDCx(i).Width = GrhData(Gr).pixelWidth * 15
    HDCx(i).Height = GrhData(Gr).pixelHeight * 15
    HDX(i).Left = HDX(i).Left - GrhData(Gr).sx * 15
    HDX(i).Top = HDX(i).Top - GrhData(Gr).sy * 15
    HDCx(i).Visible = True
    HDX(i).Visible = True
Next
GRHt.Text = Left(GRHt.Text, Len(GRHt.Text) - 2)
End Sub
