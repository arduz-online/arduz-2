VERSION 5.00
Begin VB.Form Escudo 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[ESCUDOS]"
   ClientHeight    =   5610
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   Icon            =   "Escudo.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   5610
   ScaleWidth      =   5895
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Anim 
      Interval        =   140
      Left            =   4080
      Top             =   3015
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   1290
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   13
      Top             =   4215
      Width           =   5655
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   3
      Left            =   3960
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   10
      Top             =   135
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   3
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   11
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   3
            Left            =   120
            Top             =   0
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
         Left            =   120
         TabIndex        =   12
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   2
      Left            =   2040
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   7
      Top             =   2175
      Width           =   1815
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
         TabIndex        =   9
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   1
      Left            =   3960
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   4
      Top             =   2175
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   1
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   5
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
         TabIndex        =   6
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   0
      Left            =   2040
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   1
      Top             =   135
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   0
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   2
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
         TabIndex        =   3
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.ListBox Listado 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   3960
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
End
Attribute VB_Name = "Escudo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Selecc As Integer
Dim Paso(1 To 4) As Integer
Dim Frames(1 To 4) As Integer


Private Sub Anim_Timer()
On Error Resume Next
Dim i As Integer, Gr As Integer
Dim ImagenX As String
'Exit Sub
If Selecc <= 0 Or Selecc > NumEscudosAnims Then Exit Sub
For i = 1 To 4
    Frames(i) = Frames(i) + 1
    Gr = ShieldAnimData(Listado.Text).ShieldWalk(i).GrhIndex
    If GrhData(Gr).NumFrames < Frames(i) Then Frames(i) = 1
    Call CargarImagen(i - 1, Gr, Frames(i))
    Paso(i) = Paso(i) + 1
    If Paso(i) > 4 Then Paso(i) = 1
Next
End Sub

Private Sub Form_Load()
Dim i As Integer
'Paso = 0
Selecc = 0
Me.Icon = Form1.Icon
Me.Caption = Form1.Caption & " [ESCUDOS]"
Listado.Clear
For i = 1 To NumEscudosAnims
    If ShieldAnimData(i).ShieldWalk(1).GrhIndex > 0 Then
        Listado.AddItem i
    End If
Next
End Sub

Private Sub Listado_Click()
Dim i As Integer, Gr As Integer
Dim ImagenX As String
GRHt.Text = "[ESC" & Listado.Text & "]" & vbCrLf & vbCrLf
Selecc = Listado.Text
For i = 0 To 3
    Frames(i + 1) = 1
    Paso(i + 1) = 1
    Gr = ShieldAnimData(Listado.Text).ShieldWalk(i + 1).GrhIndex
    HX(i).Caption = Gr
    GRHt.Text = GRHt.Text & "Dir" & i + 1 & "=" & Gr & vbCrLf
    Call CargarImagen(i, Gr, 1)
Next
GRHt.Text = Left(GRHt.Text, Len(GRHt.Text) - 2)
End Sub

Sub CargarImagen(ByVal Index As Integer, ByVal GrhIndex As Integer, ByVal Frame As Integer)
    HDX(Index).Visible = False
    HDCx(Index).CurrentX = 0
    HDCx(Index).CurrentY = 0
    HDCx(Index).Visible = False
    HDX(Index).Left = 0
    HDX(Index).Top = 0
    If GrhData(GrhIndex).NumFrames <= 0 Or GrhData(GrhIndex).Frames(Frame) <= 0 Then Exit Sub
    If Frame > GrhData(GrhIndex).NumFrames Then Frame = GrhData(GrhIndex).NumFrames
    GrhIndex = GrhData(GrhIndex).Frames(Frame)
    ImagenX = DirClien & "\GRAFICOS\" & GrhData(GrhIndex).FileNum & ".BMP"
    If LenB(Dir(ImagenX, vbArchive)) = 0 Then Exit Sub
    HDX(Index).Picture = LoadPicture(ImagenX)
    HDCx(Index).Width = GrhData(GrhIndex).pixelWidth * 15
    HDCx(Index).Height = GrhData(GrhIndex).pixelHeight * 15
    HDX(Index).Left = HDX(Index).Left - GrhData(GrhIndex).sx * 15
    HDX(Index).Top = HDX(Index).Top - GrhData(GrhIndex).sy * 15
    HDCx(Index).Visible = True
    HDX(Index).Visible = True
End Sub

