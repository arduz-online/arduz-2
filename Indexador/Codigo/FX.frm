VERSION 5.00
Begin VB.Form FX 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[FX]"
   ClientHeight    =   5295
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4830
   Icon            =   "FX.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   5295
   ScaleWidth      =   4830
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox X 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4080
      Locked          =   -1  'True
      TabIndex        =   6
      Top             =   120
      Width           =   615
   End
   Begin VB.TextBox Y 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4080
      Locked          =   -1  'True
      TabIndex        =   5
      Top             =   480
      Width           =   615
   End
   Begin VB.Timer Anim 
      Interval        =   140
      Left            =   2760
      Top             =   1320
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   1290
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   3840
      Width           =   4575
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   2880
      Index           =   0
      Left            =   2040
      ScaleHeight     =   2820
      ScaleWidth      =   2595
      TabIndex        =   1
      Top             =   840
      Width           =   2655
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
      Height          =   3570
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Offset X"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2160
      TabIndex        =   8
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Offset Y"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2160
      TabIndex        =   7
      Top             =   480
      Width           =   1095
   End
End
Attribute VB_Name = "FX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Selecc As Integer
'Dim Paso(1 To 4) As Integer
Dim Frames As Integer
Dim MaxFrame As Integer


Private Sub Anim_Timer()
On Error Resume Next
Dim i As Integer, Gr As Integer
Dim ImagenX As String

'Exit Sub
If Selecc <= 0 Or Selecc > NumFxs Then Exit Sub
Frames = Frames + 1
If Frames > MaxFrame Then Frames = 1
'For i = 1 To 4
    Gr = FxData(Listado.Text).FX.GrhIndex
    Call CargarImagen(0, Gr, Frames)
'    Paso(i) = Paso(i) + 1
'    If Paso(i) > 4 Then Paso(i) = 1
'Next
End Sub

Private Sub Form_Load()
Dim i As Integer
'Paso = 0
Selecc = 0
Me.Icon = Form1.Icon
Me.Caption = Form1.Caption & " [EFECTOS ESPECIALES]"
Listado.Clear
For i = 1 To NumFxs
    If FxData(i).FX.GrhIndex > 0 Then
        Listado.AddItem i
    End If
Next
End Sub

Private Sub Listado_Click()
Dim i As Integer, Gr As Integer
Dim ImagenX As String
GRHt.Text = "[FX" & Listado.Text & "]" & vbCrLf & vbCrLf
Selecc = Listado.Text
Frames = 1
i = 0
'Paso(i + 1) = 1
Gr = FxData(Listado.Text).FX.GrhIndex
HX(i).Caption = Gr
MaxFrame = GrhData(Gr).NumFrames
'GRHt.Text = GRHt.Text & Gr
X.Text = FxData(Listado.Text).OffsetX
Y.Text = FxData(Listado.Text).OffsetY
Call CargarImagen(i, Gr, 1)
GRHt.Text = GRHt.Text & "Animacion=" & Gr & vbCrLf & "OffsetX=" & X.Text & vbCrLf & "OffsetY=" & Y.Text
'GRHt.Text = Left(GRHt.Text, Len(GRHt.Text) - 2)
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

