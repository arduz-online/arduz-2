VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Indexador HiPr0 - Soporte 0.12.1 por Ladder."
   ClientHeight    =   8115
   ClientLeft      =   45
   ClientTop       =   615
   ClientWidth     =   7770
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   8115
   ScaleWidth      =   7770
   StartUpPosition =   2  'CenterScreen
   Begin VB.FileListBox Archivos 
      Height          =   285
      Left            =   6120
      Pattern         =   "*.bmp"
      TabIndex        =   28
      Top             =   840
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H0000C000&
      Caption         =   "&Editar"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4080
      Style           =   1  'Graphical
      TabIndex        =   27
      Top             =   1920
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   450
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   26
      Top             =   7280
      Width           =   7575
   End
   Begin VB.CommandButton cmdPlay 
      Caption         =   "&Play"
      Height          =   315
      Left            =   6120
      TabIndex        =   24
      Top             =   1200
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.TextBox Frames 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4920
      Locked          =   -1  'True
      TabIndex        =   22
      ToolTipText     =   "Nos indica la cantidad de frames"
      Top             =   1560
      Width           =   1095
   End
   Begin VB.TextBox Speed 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4920
      Locked          =   -1  'True
      TabIndex        =   21
      ToolTipText     =   "Nos indica la velocidad en cambiar frames de una animacion"
      Top             =   1200
      Width           =   1095
   End
   Begin VB.TextBox TileHeight 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4920
      Locked          =   -1  'True
      TabIndex        =   17
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox TileWidth 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4920
      Locked          =   -1  'True
      TabIndex        =   15
      Top             =   120
      Width           =   1095
   End
   Begin VB.TextBox pixelHeight 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   13
      ToolTipText     =   "Alto de Pixeles"
      Top             =   1920
      Width           =   1095
   End
   Begin VB.TextBox pixelWidth 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   11
      ToolTipText     =   "Ancho de Pixeles"
      Top             =   1560
      Width           =   1095
   End
   Begin VB.TextBox sy 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   9
      ToolTipText     =   "Pixeles hacia abajo"
      Top             =   1200
      Width           =   1095
   End
   Begin VB.TextBox sx 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   8
      ToolTipText     =   "Pixeles a la derecha"
      Top             =   840
      Width           =   1095
   End
   Begin VB.PictureBox Imagen 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   4935
      Left            =   2040
      ScaleHeight     =   4875
      ScaleWidth      =   5595
      TabIndex        =   5
      Top             =   2280
      Width           =   5655
      Begin VB.PictureBox Img 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   18
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
   Begin VB.TextBox FileName 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   4
      ToolTipText     =   "Nos dice el numero de BMP al que refiere"
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox Index 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   2880
      Locked          =   -1  'True
      TabIndex        =   3
      ToolTipText     =   "Nos indica el numero de GrhIndex"
      Top             =   120
      Width           =   1095
   End
   Begin VB.ListBox Listado 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   7080
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Cred 
      Alignment       =   2  'Center
      BackColor       =   &H00004000&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Programado por ^[GS]^ - Website: http://www.gs-zone.com.ar - Soporte 0.12.1 por Ladder"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   120
      TabIndex        =   25
      Top             =   7800
      Width           =   7575
   End
   Begin VB.Image LogoGS 
      Height          =   2175
      Left            =   5640
      Picture         =   "Form1.frx":0442
      Top             =   480
      Width           =   2175
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "Frames"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4080
      TabIndex        =   23
      Top             =   1560
      Width           =   975
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Speed"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4080
      TabIndex        =   20
      Top             =   1200
      Width           =   975
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "ANIMACION"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4080
      TabIndex        =   19
      Top             =   920
      Width           =   1935
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "TileHeight"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4080
      TabIndex        =   16
      Top             =   480
      Width           =   855
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "TileWidth"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4080
      TabIndex        =   14
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "pixelHeight"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   12
      Top             =   1920
      Width           =   855
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "pixelWidth"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   10
      Top             =   1560
      Width           =   855
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "sY"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   7
      Top             =   1200
      Width           =   975
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "sX"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   6
      Top             =   840
      Width           =   855
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "FileName"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Index"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   1
      Top             =   120
      Width           =   1095
   End
   Begin VB.Menu mnuArchivo 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuReload 
         Caption         =   "&Recargar desde Carpeta del Cliente"
         Shortcut        =   ^R
      End
      Begin VB.Menu mnuRecargarIndex 
         Caption         =   "Recargar desde Carpeta de Inde&xación"
         Shortcut        =   ^T
      End
      Begin VB.Menu lin1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExport 
         Caption         =   "&Exportar..."
         Begin VB.Menu mnuExportGrhMenu 
            Caption         =   "...&Graficos (Graficos.ind)"
            Begin VB.Menu mnuExportGrh 
               Caption         =   "&Completo (Graficos.ini)"
            End
         End
         Begin VB.Menu mnuExporCabezas 
            Caption         =   "...&Cabezas (Cabezas.ind)"
         End
         Begin VB.Menu mnuExporCuerpos 
            Caption         =   "...C&uerpos (Personajes.ind)"
         End
         Begin VB.Menu mnuExportarCascos 
            Caption         =   "...C&ascos (Cascos.ind)"
         End
         Begin VB.Menu mnuExportarFXs 
            Caption         =   "...&FXs (Fxs.ind)"
         End
         Begin VB.Menu linxD 
            Caption         =   "-"
         End
         Begin VB.Menu mnuExportarArmas 
            Caption         =   "...A&rmas (Armas.dat)"
         End
         Begin VB.Menu mnuExportarEscudos 
            Caption         =   "...&Escudos (Escudos.dat)"
         End
         Begin VB.Menu mnuExportarColores 
            Caption         =   "...Co&lores (Colores.dat)"
         End
         Begin VB.Menu mnuExportarSinfo 
            Caption         =   "...&Server Info (sinfo.dat)"
         End
         Begin VB.Menu liF1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuExportarTodo 
            Caption         =   "...&TODO"
         End
      End
      Begin VB.Menu mnuInder 
         Caption         =   "&Indexar..."
         Begin VB.Menu mnuIndexGrhMnu 
            Caption         =   "...&Graficos (Graficos.ind)"
            Begin VB.Menu mnuImportarCompleto 
               Caption         =   "&Completo (Graficos.ini)"
            End
         End
         Begin VB.Menu mnuIndexCabezas 
            Caption         =   "...&Cabezas (Cabezas.ind)"
         End
         Begin VB.Menu mnuIndexCuerpos 
            Caption         =   "...C&uerpos (Personajes.ind)"
         End
         Begin VB.Menu mnuIndexCascos 
            Caption         =   "...C&ascos (Cascos.ind)"
         End
         Begin VB.Menu mnuIndexFXs 
            Caption         =   "...&FXs (Fxs.ind)"
         End
         Begin VB.Menu mnulix 
            Caption         =   "-"
         End
         Begin VB.Menu mnuImportarArmas 
            Caption         =   "...A&rmas (Armas.dat)"
         End
         Begin VB.Menu mnuImportarEscudos 
            Caption         =   "...&Escudos (Escudos.dat)"
         End
         Begin VB.Menu mnuImportarColores 
            Caption         =   "...Co&lores (Colores.dat)"
         End
         Begin VB.Menu mnuImportarSinfo 
            Caption         =   "...&Server Info (sinfo.dat)"
         End
         Begin VB.Menu linG1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuIndexarTodo 
            Caption         =   "...&TODO"
            Begin VB.Menu mnuIndexCompleto 
               Caption         =   "&Completo (Graficos.ini)"
            End
         End
      End
      Begin VB.Menu linX1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuOpciones 
         Caption         =   "&Opciones"
         Shortcut        =   ^O
      End
      Begin VB.Menu line1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSalir 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuCarpetas 
      Caption         =   "&Ir a..."
      Begin VB.Menu mnuIrCliente 
         Caption         =   "... la Carpeta del &Cliente"
      End
      Begin VB.Menu mnuIrExportacion 
         Caption         =   "... la Carpeta de &Exportación"
      End
      Begin VB.Menu mnuIrIndexacion 
         Caption         =   "... la Carpeta de &Indexación"
      End
   End
   Begin VB.Menu mnuEdicion 
      Caption         =   "&Edición"
      Begin VB.Menu mnuIrAGRH 
         Caption         =   "Buscar &Grh"
         Shortcut        =   ^G
      End
      Begin VB.Menu linX2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuIrABMP 
         Caption         =   "Buscar Grh con &BMP"
         Shortcut        =   ^B
      End
      Begin VB.Menu mnuIrASBMP 
         Caption         =   "Buscar &Siguiente Grh con BMP"
         Enabled         =   0   'False
         Shortcut        =   ^S
      End
   End
   Begin VB.Menu mnuDiseñar 
      Caption         =   "&Diseñar"
      Enabled         =   0   'False
      Begin VB.Menu mnuDPisos 
         Caption         =   "&Pisos"
      End
      Begin VB.Menu mnuDPared 
         Caption         =   "P&aredes"
      End
      Begin VB.Menu mnuDTerreno 
         Caption         =   "&Terrenos"
      End
      Begin VB.Menu mnuDAgua 
         Caption         =   "&Agua"
      End
      Begin VB.Menu mnuDAnimacion 
         Caption         =   "&Animación (Ropas/Armaduras/Armas)"
      End
      Begin VB.Menu mnuDAnimacionDragones 
         Caption         =   "Animación &Dragones"
      End
      Begin VB.Menu mnuDAnimacionGolems 
         Caption         =   "Animación &Golems"
      End
      Begin VB.Menu mnuDInventario 
         Caption         =   "&Inventario u Objetos sin Movimiento"
      End
   End
   Begin VB.Menu mnuVer 
      Caption         =   "&Ver..."
      Begin VB.Menu mnuCabezas 
         Caption         =   "&Cabezas (Heads)"
      End
      Begin VB.Menu mnuCascos 
         Caption         =   "C&ascos (Helmets)"
      End
      Begin VB.Menu mnuCuerpos 
         Caption         =   "C&uerpos (Bodys)"
      End
      Begin VB.Menu mnuArmas 
         Caption         =   "&Armas (Weapons)"
      End
      Begin VB.Menu mnuEscudos 
         Caption         =   "&Escudos (Shields)"
      End
      Begin VB.Menu mnuEfectos 
         Caption         =   "E&fectos Especiales (FXs)"
      End
   End
   Begin VB.Menu mnuExtra 
      Caption         =   "&Extra"
      Begin VB.Menu mnuBuscarDuplicados 
         Caption         =   "Buscar Grh duplicados..."
      End
      Begin VB.Menu mnuIndexBMP 
         Caption         =   "Buscar Errores de Indexación..."
      End
      Begin VB.Menu mnuBMPinutiles 
         Caption         =   "Buscar BMP inutilizados..."
      End
      Begin VB.Menu mnuBuscarGrhLibresConsecutivos 
         Caption         =   "Buscar Grh Libres Consecutivos"
      End
      Begin VB.Menu mnuBuscarErrDim 
         Caption         =   "Buscar Errores de Dimenciónes..."
      End
      Begin VB.Menu linz1 
         Caption         =   "-"
      End
   End
   Begin VB.Menu mnuAyuda 
      Caption         =   "Ayuda..."
      Begin VB.Menu mnuPrimerosPasos 
         Caption         =   "&Primeros Pasos"
      End
      Begin VB.Menu mnuAyudaIndexacion 
         Caption         =   "I&ndexacion"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuLine1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAcercaDe 
         Caption         =   "&Acerca de..."
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Ocupado As Boolean
Public Play As Boolean
Private Sub cmdPlay_Click()
On Error Resume Next
Dim i As Integer
If Ocupado = True Then Exit Sub
Play = True
Dim MaxFrm As Integer
Dim SpeeX As Integer
If Val(Frames) > 0 Then
    Do
    DoEvents
    If Ocupado = True Then Exit Do

    SpeeX = Round(GrhData(Index).Speed / GrhData(Index).NumFrames)
    If SpeeX = 0 Then Exit Do
    MaxFrm = GrhData(Index).NumFrames
    If MaxFrm < 2 Then GoTo salta
    Dim Tiempo
    Tiempo = GetTickCount
    For i = 1 To MaxFrm
        Do While ((GetTickCount - Tiempo) < (SpeeX)): DoEvents:   Loop
        If GrhData(Index).NumFrames < 2 Then Exit For
        Call AbrirDat(GrhData(Index).Frames(i))
        If GrhData(Index).NumFrames < 2 Then Exit For
        Tiempo = GetTickCount
    Next
salta:
    Loop
End If
Play = False
End Sub


Private Sub Form_Load()
On Error Resume Next
Call LeerOpciones
Do While (frmOpciones.Tag = "1")
    DoEvents
Loop
Call DIR_INDEXADOR
Carga.Label1.Caption = "Cargando..."
Carga.Visible = True
Me.Visible = False
DoEvents
Carga.Label1.Caption = "Cargando Graficos..."
DoEvents
CaGraficos
Rem Call LoadGrhData
Carga.Label1.Caption = "Cargando Cabezas..."
DoEvents
Call CargarCabezas
Carga.Label1.Caption = "Cargando Cuerpos..."
DoEvents
Call CargarCuerpos
Carga.Label1.Caption = "Cargando Escudos..."
DoEvents
Call CargarAnimEscudos
Carga.Label1.Caption = "Cargando Armas..."
DoEvents
Call CargarAnimArmas
Carga.Label1.Caption = "Cargando FXs..."
DoEvents
Call CargarFxs
Carga.Label1.Caption = "Cargando Cascos..."
DoEvents
Call CargarCascos
Carga.Label1.Caption = "OK..."
DoEvents
UsarIndex = False
Me.Caption = "Indexador HiPr0 - Soporte 0.12.1 por Ladder."
Me.Show
DoEvents
Carga.Visible = False
Me.Visible = True
Ocupado = False
Play = False
Call IniciarCabecera(MiCabecera)
Call cmdPlay_Click
If frmPrimerosPasos.Tag = "1" Then frmPrimerosPasos.SetFocus
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
End
End Sub

Private Sub Listado_Click()
On Error Resume Next
If Ocupado = True Then Exit Sub
Dim i As Integer
DoEvents
Index = ReadField(1, Listado.Text, Asc(" "))
FileName = 0
DoEvents
FileName = GrhData(Index).FileNum
Img.CurrentX = 0
Img.CurrentY = 0
Img.Visible = False
Ix.Left = 0
Ix.Top = 0
sx = GrhData(Index).sx
sy = GrhData(Index).sy
pixelWidth = GrhData(Index).pixelWidth
pixelHeight = GrhData(Index).pixelHeight
TileWidth = GrhData(Index).TileWidth
TileHeight = GrhData(Index).TileHeight
Speed = GrhData(Index).Speed
Frames = GrhData(Index).NumFrames
If LenB(Dir(DirClien & "\Graficos\" & FileName & ".bmp", vbArchive)) = 0 And Frames <= 1 Then
    GRHt.Text = "ERROR: Falta la imagen " & FileName & ".bmp en Graficos."
    Exit Sub
End If
Ix.Picture = LoadPicture(DirClien & "\Graficos\" & FileName & ".bmp")
If GrhData(Index).NumFrames <= 1 Then
    GRHt.Text = "Grh" & Index & "=1-" & FileName & "-" & sx & "-" & sy & "-" & pixelWidth & "-" & pixelHeight
Else
    GRHt.Text = "Grh" & Index & "=" & GrhData(Index).NumFrames
    For i = 1 To GrhData(Index).NumFrames
        GRHt.Text = GRHt.Text & "-" & GrhData(Index).Frames(i)
    Next
    GRHt.Text = GRHt.Text & "-" & GrhData(Index).Speed
End If
Img.Width = pixelWidth * 15
Img.Height = pixelHeight * 15
Ix.Left = Ix.Left - sx * 15
Ix.Top = Ix.Top - sy * 15
If FileName = 0 Then
    Img.Visible = False
Else
    Img.Visible = True
End If
If Play = False Or (Play = True And GrhData(Index).Speed <> 0) Then Call cmdPlay_Click
End Sub


Function AbrirDat(ByVal Index As String)
On Error Resume Next
Dim FileNameX As String
Dim SxX As Integer
Dim SyY As Integer
Img.CurrentX = 0
Img.CurrentY = 0
Img.Visible = False
Ix.Left = 0
Ix.Top = 0
FileNameX = GrhData(Index).FileNum
SxX = GrhData(Index).sx
SyY = GrhData(Index).sy
pixelWidth = GrhData(Index).pixelWidth
pixelHeight = GrhData(Index).pixelHeight
If LenB(Dir(DirClien & "\Graficos\" & FileNameX & ".bmp", vbArchive)) = 0 Then
    If GRHt.Text <> "ERROR: Falta la imagen " & FileNameX & ".bmp en Graficos." Then
        GRHt.Text = "ERROR: Falta la imagen " & FileNameX & ".bmp en Graficos."
    End If
    Exit Function
End If
Ix.Picture = LoadPicture(DirClien & "\Graficos\" & FileNameX & ".bmp")
Img.Width = pixelWidth * 15
Img.Height = pixelHeight * 15
Ix.Left = Ix.Left - SxX * 15
Ix.Top = Ix.Top - SyY * 15
If FileNameX = 0 Then
    Img.Visible = False
    Call Listado_Click
Else
    Img.Visible = True
End If

End Function




Private Sub mnuAcercaDe_Click()
frmAcercaDe.Show
End Sub

Private Sub mnuArmas_Click()
Arma.Show
End Sub

Private Sub mnuAyudaIndexacion_Click()
frmAyuda.Show
End Sub

Private Sub mnuBMPinutiles_Click()
Dim i As Integer
Dim j As Integer
Dim Datos As String
Dim Encontre As Boolean
Dim NumBMP As String
Dim Tim As Byte
Archivos.Path = DirClien & "\Graficos\"
DoEvents
Me.Hide
Carga.Show
Tim = 0
For i = 0 To Archivos.ListCount
    Encontre = False
    NumBMP = ReadField(1, Archivos.List(i), Asc("."))
    'Tim = Tim + 1
    'If Tim >= 2 Then
    '    Tim = 0
        Carga.Label1.Caption = "Buscando BMPs inutiles " & NumBMP & " BMP"
        DoEvents
    'End If
    For j = 1 To MaxGRH
        If IsNumeric(NumBMP) = False Then
            Encontre = True
            Exit For
        End If
        If GrhData(j).NumFrames = 1 Then
            If GrhData(j).FileNum = NumBMP Then
                Encontre = True
                Exit For
            End If
        End If
    Next
    If Encontre = False Then
        Datos = Datos & "El BMP " & NumBMP & " se encuentra inutilizado" & vbCrLf
    End If
Next
Unload Carga
Me.Show
MostrarCodigo.Caption = mnuBMPinutiles.Caption
MostrarCodigo.Codigo.Text = Datos
MostrarCodigo.Show
End Sub

Private Sub mnuBuscarDuplicados_Click()
Dim i As Integer
Dim j As Integer
Dim K As Integer
Dim Datos As String
Dim DatX As Byte
Dim Tim As Byte
Me.Hide
Carga.Show
Tim = 0
For i = 1 To MaxGRH
    If GrhData(i).NumFrames >= 1 Then
        For j = (i + 1) To MaxGRH
            Tim = Tim + 1
            If Tim >= 250 Then
                Tim = 0
                Carga.Label1.Caption = "Buscando Duplicados " & i & " GRH"
                DoEvents
            End If
            If GrhData(i).NumFrames = 1 Then
                If GrhData(j).FileNum = GrhData(i).FileNum Then
                    If (GrhData(i).sx & GrhData(i).sy & GrhData(i).pixelHeight & GrhData(i).pixelWidth) = (GrhData(j).sx & GrhData(j).sy & GrhData(j).pixelHeight & GrhData(j).pixelWidth) Then
                        Datos = Datos & "Grh" & i & " esta duplicado con Grh" & j & vbCrLf
                    End If
                End If
            Else
                If (GrhData(i).NumFrames = GrhData(j).NumFrames) And (GrhData(i).Speed = GrhData(j).Speed) Then
                    DatX = 0
                    For K = 1 To GrhData(j).NumFrames
                        If GrhData(i).Frames(K) = GrhData(j).Frames(K) Then
                            DatX = DatX + 1
                        End If
                    Next
                    If DatX = GrhData(j).NumFrames Then
                        Datos = Datos & "Grh" & i & " (ANIMACION) esta duplicado con Grh" & j & " (ANIMACION)" & vbCrLf
                    End If
                End If
            End If
        Next
    End If
Next
Unload Carga
Me.Show
MostrarCodigo.Caption = mnuBuscarDuplicados.Caption
MostrarCodigo.Codigo.Text = Datos
MostrarCodigo.Show

End Sub

Private Sub mnuBuscarErrDim_Click()
Dim i As Integer
Dim j As Integer
Dim Datos As String
Dim Tim As Byte
Dim Tipo(1) As Integer
Me.Hide
Carga.Show
Tim = 0
For i = 1 To MaxGRH
    If GrhData(i).NumFrames > 1 Then
        Tim = Tim + 1
        If Tim >= 150 Then
            Tim = 0
            Carga.Label1.Caption = "Procesando " & i & " grh"
            DoEvents
        End If
        Tipo(0) = 0
        Tipo(1) = 0
        For j = 1 To GrhData(i).NumFrames
            If Tipo(0) = 0 And Tipo(1) = 0 Then
                Tipo(0) = GrhData(GrhData(i).Frames(j)).pixelHeight
                Tipo(1) = GrhData(GrhData(i).Frames(j)).pixelWidth
            Else
                If Tipo(0) <> GrhData(GrhData(i).Frames(j)).pixelHeight Then
                    ' diferente pxHight
                    Datos = Datos & "Grh" & i & " (ANIMACION) en Frame " & j & " - Pixel Height diferente a los demas frames. (Deberia ser " & Tipo(0) & " y tiene " & GrhData(GrhData(i).Frames(j)).pixelHeight & ")" & vbCrLf
                End If
                If Tipo(1) <> GrhData(GrhData(i).Frames(j)).pixelWidth Then
                    ' diferente pxWidth
                    Datos = Datos & "Grh" & i & " (ANIMACION) en Frame " & j & " - Pixel Width diferente a los demas frames. (Deberia ser " & Tipo(1) & " y tiene " & GrhData(GrhData(i).Frames(j)).pixelWidth & ")" & vbCrLf
                End If
            End If
        Next
    ElseIf GrhData(i).NumFrames = 1 Then
        'Tim = Tim + 1
        'If Tim >= 150 Then
        '    Tim = 0
        '    Carga.Label1.Caption = "Procesando " & i & " grh"
        ''    DoEvents
        'End If
        'If LenB(Dir(DirClien & "\Graficos\" & GrhData(i).FileNum & ".bmp", vbArchive)) = 0 Then
        '    Datos = Datos & "Grh" & i & " - Le falta el BMP " & GrhData(i).FileNum & vbCrLf
        'End If
    End If
Next
Unload Carga
Me.Show
MostrarCodigo.Caption = mnuBuscarErrDim.Caption
MostrarCodigo.Codigo.Text = Datos
MostrarCodigo.Show
End Sub

Private Sub mnuBuscarGrhLibresConsecutivos_Click()
On Error Resume Next
Dim libres As Integer
Dim i As Integer
Dim Conta As Integer
libres = InputBox("Grh Libres Consecutivos")
If IsNumeric(libres) = False Then Exit Sub
For i = 1 To MaxGRH
    If GrhData(i).NumFrames = 0 Then
        Conta = Conta + 1
        If Conta = libres Then
            MsgBox "Desde Grh" & i - (Conta - 1) & " hasta Grh" & i & " se encuentran libres."
            Exit Sub
        End If
    ElseIf Conta > 0 Then
        Conta = 0
    End If
Next
MsgBox "No se encontraron " & libres & " GRH Libres Consecutivos"
End Sub

Private Sub mnuCabezas_Click()
CabezaM.Show
End Sub

Private Sub mnuCascos_Click()
Casco.Show
End Sub

Private Sub mnuCuerpos_Click()
Cuerpo.Show
End Sub

Private Sub mnuDPisos_Click()
DiseñoPisos.Show
End Sub

Private Sub mnuEfectos_Click()
FX.Show
End Sub


Private Sub mnuEscudos_Click()
Escudo.Show
End Sub

Private Sub mnuExporCabezas_Click()
On Error Resume Next
Dim i As Integer, j, n, K As Integer
Dim Datos As String
GRHt.Text = "Exportando..."
DoEvents
Call DIR_INDEXADOR
Call Kill(DirExpor & "\Cabezas.ini")

Datos = "[INIT]" & vbCrLf & "NumHeads=" & NumHeads & vbCrLf & vbCrLf
For i = 1 To NumHeads
    If HeadData(i).Head(1).GrhIndex > 0 Then
        Datos = Datos & "[HEAD" & (i) & "]" & vbCrLf
        For n = 1 To 4
            Datos = Datos & "Head" & (n) & "=" & HeadData(i).Head(n).GrhIndex & vbCrLf & IIf(n = 1, Chr(9) & " ' arriba", "") & IIf(n = 2, Chr(9) & " ' derecha", "") & IIf(n = 3, Chr(9) & " ' abajo", "") & IIf(n = 4, Chr(9) & " ' izq", "") & vbCrLf
        Next
        Datos = Datos & vbCrLf
    End If
Next

GRHt.Text = "Guardando...Cabezas.ini"
DoEvents

Open (DirExpor & "\Cabezas.ini") For Binary Access Write As #1
Put #1, , Datos
Close #1

GRHt.Text = "Exportado...Cabezas.ini"

End Sub

Private Sub mnuExporCuerpos_Click()
On Error Resume Next
Dim i As Integer, j, n, K As Integer
Dim Datos As String
GRHt.Text = "Exportando..."
DoEvents
Call DIR_INDEXADOR
Call Kill(DirExpor & "\Cuerpos.ini")

Datos = "[INIT]" & vbCrLf & "NumBodies=" & NumCuerpos & vbCrLf & vbCrLf
For i = 1 To NumCuerpos
    Datos = Datos & "[BODY" & (i) & "]" & vbCrLf
    For n = 1 To 4
        Datos = Datos & "WALK" & (n) & "=" & BodyData(i).Walk(n).GrhIndex & vbCrLf & IIf(n = 1, Chr(9) & " ' arriba", "") & IIf(n = 2, Chr(9) & " ' derecha", "") & IIf(n = 3, Chr(9) & " ' abajo", "") & IIf(n = 4, Chr(9) & " ' izq", "") & vbCrLf
    Next
    Datos = Datos & "HeadOffsetX=" & BodyData(i).HeadOffset.X & vbCrLf & "HeadOffsetY=" & BodyData(i).HeadOffset.Y & vbCrLf & vbCrLf
Next

GRHt.Text = "Guardando...Cuerpos.ini"
DoEvents

Open (DirExpor & "\Cuerpos.ini") For Binary Access Write As #1
Put #1, , Datos
Close #1

GRHt.Text = "Exportado...Cuerpos.ini"
End Sub

Private Sub mnuExportarArmas_Click()
Call ExportarDAT("Armas")
End Sub

Private Sub mnuExportarCascos_Click()
On Error Resume Next
Dim i As Integer, j, n, K As Integer
Dim Datos As String
GRHt.Text = "Exportando..."
DoEvents
Call DIR_INDEXADOR
Call Kill(DirExpor & "\Cascos.ini")

Datos = "[INIT]" & vbCrLf & "NumCascos=" & NumCascos & vbCrLf & vbCrLf
For i = 1 To NumCascos
    If CascoAnimData(i).Head(1).GrhIndex > 0 Then
        Datos = Datos & "[CASCO" & (i) & "]" & vbCrLf
        For n = 1 To 4
            Datos = Datos & "Head" & n & "=" & CascoAnimData(i).Head(n).GrhIndex & vbCrLf & IIf(n = 1, Chr(9) & " ' arriba", "") & IIf(n = 2, Chr(9) & " ' derecha", "") & IIf(n = 3, Chr(9) & " ' abajo", "") & IIf(n = 4, Chr(9) & " ' izq", "") & vbCrLf
        Next
        Datos = Datos & vbCrLf
    End If
Next

GRHt.Text = "Guardando...Cascos.ini"
DoEvents

Open (DirExpor & "\Cascos.ini") For Binary Access Write As #1
Put #1, , Datos
Close #1

DoEvents
GRHt.Text = "Exportado...Cascos.ini"

End Sub

Private Sub mnuExportarColores_Click()
Call ExportarDAT("Colores")

End Sub

Private Sub mnuExportarEscudos_Click()
Call ExportarDAT("Escudos")

End Sub

Private Sub mnuExportarFXs_Click()
On Error Resume Next
Dim i As Integer, j, n, K As Integer
Dim Datos As String
GRHt.Text = "Exportando..."
DoEvents
Call DIR_INDEXADOR
Call Kill(DirExpor & "\FXs.ini")

Datos = "[INIT]" & vbCrLf & "NumFxs=" & NumFxs & vbCrLf & vbCrLf
For i = 1 To NumFxs
    If FxData(i).FX.GrhIndex > 0 Then
        Datos = Datos & "[FX" & (i) & "]" & vbCrLf
        Datos = Datos & "Animacion=" & FxData(i).FX.GrhIndex & vbCrLf & "OffsetX=" & FxData(i).offsetx & vbCrLf & "OffsetY=" & FxData(i).offsety & vbCrLf & "P=" & FxData(i).particula & vbCrLf & "S=" & FxData(i).wav & vbCrLf & vbCrLf
    End If
Next

GRHt.Text = "Guardando...FXs.ini"
DoEvents

Open (DirExpor & "\FXs.ini") For Binary Access Write As #1
Put #1, , Datos
Close #1

DoEvents

GRHt.Text = "Exportado...FXs.ini"

End Sub

Private Sub mnuExportarSinfo_Click()
Call ExportarDAT("sinfo")

End Sub

Private Sub mnuExportarTodo_Click()
Call mnuExportGrh_Click
mnuReload.Enabled = False
Call mnuExporCabezas_Click
Call mnuExporCuerpos_Click
Call mnuExportarCascos_Click
Call mnuExportarFXs_Click
Call mnuExportarArmas_Click
Call mnuExportarEscudos_Click
Call mnuExportarColores_Click
Call mnuExportarSinfo_Click
mnuReload.Enabled = True
GRHt.Text = "Exportación Completada..."
End Sub

Private Sub mnuExportGrh_Click()
On Error Resume Next
Dim i As Integer, j As Integer, K As Integer
Dim n
Dim Datos$

Ocupado = True
Play = False
GRHt.Text = "Exportando..."
Call DIR_INDEXADOR
DoEvents
Call Kill(DirExpor & "\Graficos.ini")

n = FreeFile
Open DirExpor & "\Graficos.ini" For Binary Access Write As n
Put n, , "[INIT]" & vbCrLf & "NumGrh=" & Pros(Form1.Listado.List(Form1.Listado.ListCount - 1)) & vbCrLf & vbCrLf
K = 0

Put n, , "[Graphics]" & vbCrLf

For i = 1 To MaxGRH
    K = K + 1
    If K > 100 Then
        GRHt.Text = "Exportando..." & i & " de MaxGRH"
        DoEvents
        K = 0
    End If
    If GrhData(i).NumFrames > 0 Then
        Datos$ = ""
        If GrhData(i).NumFrames = 1 Then
            Datos$ = "1-" & CStr(GrhData(i).FileNum) & "-" & CStr(GrhData(i).sx) & "-" & CStr(GrhData(i).sy) & "-" & CStr(GrhData(i).pixelWidth) & "-" & CStr(GrhData(i).pixelHeight)
            
        Else
            Datos$ = CStr(GrhData(i).NumFrames)
            For j = 1 To GrhData(i).NumFrames
                Datos$ = Datos$ & "-" & CStr(GrhData(i).Frames(j))
            Next
            Datos$ = Datos$ & "-" & CStr(GrhData(i).Speed)
        End If
        If Len(Datos$) > 0 Then
            Put n, , "Grh" & CStr(i) & "=" & Datos$ & vbCrLf
        End If
    End If
Next
Close #n
GRHt.Text = "Exportado...Graficos.ini"
Ocupado = False
End Sub

Function Pros(ByVal XX As String) As String
Pros = ReadField(1, XX, Asc(" "))
End Function

Private Sub mnuImportarArmas_Click()
Call ImportarDAT("Armas")
End Sub

Private Sub mnuImportarColores_Click()
Call ImportarDAT("Colores")

End Sub

Private Sub mnuImportarCompleto_Click()
DoEvents
If CaGraficosIni = True Then
   If ReGraficos = True Then
        MsgBox "Graficos.ind creado..."
    Else
        MsgBox "Error al crear Graficos.ind..."
   End If
Else
    MsgBox "Error al cargar Graficos.ini..."
End If
Rem Call HacerIndexacion(False)

End Sub

Private Sub mnuImportarenPartes_Click()
If UsarGrhLong = True Then
    MsgBox "Esta opcion no esta disponible para Grh Long"
    Exit Sub
End If
Call HacerIndexacion(True)

End Sub

Private Sub mnuImportarEscudos_Click()
Call ImportarDAT("Escudos")

End Sub

Private Sub mnuImportarSinfo_Click()
Call ImportarDAT("sinfo")

End Sub

Private Sub mnuIndexBMP_Click()
Dim Datos As String
Dim i As Integer
Dim j As Integer
Dim Tim As Byte
Me.Hide
Carga.Show
Tim = 0
For i = 1 To MaxGRH
    If GrhData(i).NumFrames > 1 Then
        Tim = Tim + 1
        If Tim >= 150 Then
            Tim = 0
            Carga.Label1.Caption = "Procesando " & i & " grh"
            DoEvents
        End If
        For j = 1 To GrhData(i).NumFrames
            If GrhData(GrhData(i).Frames(j)).FileNum = 0 Then
                Datos = Datos & "Grh" & i & " (ANIMACION) en Frame " & j & " - Le falta el GRH " & GrhData(i).Frames(j) & vbCrLf
            ElseIf LenB(Dir(DirClien & "\Graficos\" & GrhData(GrhData(i).Frames(j)).FileNum & ".bmp", vbArchive)) = 0 Then
                Datos = Datos & "Grh" & i & " (ANIMACION) en Frame " & j & " - Le falta el BMP " & GrhData(GrhData(i).Frames(j)).FileNum & " (GRH" & GrhData(i).Frames(j) & ")" & vbCrLf
            End If
        Next
    ElseIf GrhData(i).NumFrames = 1 Then
        Tim = Tim + 1
        If Tim >= 150 Then
            Tim = 0
            Carga.Label1.Caption = "Procesando " & i & " grh"
            DoEvents
        End If
        If LenB(Dir(DirClien & "\Graficos\" & GrhData(i).FileNum & ".bmp", vbArchive)) = 0 Then
            Datos = Datos & "Grh" & i & " - Le falta el BMP " & GrhData(i).FileNum & vbCrLf
        End If
    End If
Next
Unload Carga
Me.Show
MostrarCodigo.Caption = mnuIndexBMP.Caption
MostrarCodigo.Codigo.Text = Datos
MostrarCodigo.Show
End Sub

Private Sub mnuIndexCabezas_Click()
On Error GoTo fallo
Dim i As Integer, j, n, K As Integer
Dim NumHeads As Integer
GRHt.Text = "Compilando..."
DoEvents
Call DIR_INDEXADOR
Dim LeerINI As New clsLeerIni
Call LeerINI.Abrir(DirExpor & "\Cabezas.ini")

NumHeads = CInt(LeerINI.DarValor("INIT", "NumHeads"))

ReDim HeadDataT(0 To NumHeads + 1) As tIndiceCabeza
If UsarGrhLong = False Then
    ReDim HeadDataTint(0 To NumHeads + 1) As tIndiceCabezaInt
End If

For i = 1 To NumHeads
    HeadDataT(i).Head(1) = Val(LeerINI.DarValor("HEAD" & i, "Head1"))
    HeadDataT(i).Head(2) = Val(LeerINI.DarValor("HEAD" & i, "Head2"))
    HeadDataT(i).Head(3) = Val(LeerINI.DarValor("HEAD" & i, "Head3"))
    HeadDataT(i).Head(4) = Val(LeerINI.DarValor("HEAD" & i, "Head4"))
Next i

n = FreeFile
Open DirIndex & "\Cabezas.ind" For Binary Access Write As #n

Put #n, , MiCabecera

Put #n, , NumHeads

For i = 1 To NumHeads
    If UsarGrhLong = True Then
        Put #n, , HeadDataT(i)
    Else
        HeadDataTint(i).Head(1) = HeadDataT(i).Head(1)
        HeadDataTint(i).Head(2) = HeadDataT(i).Head(2)
        HeadDataTint(i).Head(3) = HeadDataT(i).Head(3)
        HeadDataTint(i).Head(4) = HeadDataT(i).Head(4)
        Put #n, , HeadDataTint(i)
    End If
Next

GRHt.Text = "Guardando...Cabezas.ind"
DoEvents
Close #n
GRHt.Text = "Compilado...Cabezas.ind"

Exit Sub
fallo:
MsgBox "Error en Cabezas.ini"

End Sub

Private Sub mnuIndexCascos_Click()
On Error GoTo fallo
Dim i As Integer
Dim NumCascos As Integer
Dim n
Dim Datos As String
GRHt.Text = "Compilando..."
DoEvents
Call DIR_INDEXADOR

Dim LeerINI As New clsLeerIni
Call LeerINI.Abrir(DirExpor & "\Cascos.ini")

NumCascos = CInt(LeerINI.DarValor("INIT", "NumCascos"))

ReDim HeadDataT(0 To NumCascos + 1) As tIndiceCabeza
If UsarGrhLong = False Then
    ReDim HeadDataTint(0 To NumCascos + 1) As tIndiceCabezaInt
End If

For i = 1 To NumCascos
    HeadDataTint(i).Head(1) = Val(LeerINI.DarValor("CASCO" & i, "Head1"))
    HeadDataTint(i).Head(2) = Val(LeerINI.DarValor("CASCO" & i, "Head2"))
    HeadDataTint(i).Head(3) = Val(LeerINI.DarValor("CASCO" & i, "Head3"))
    HeadDataTint(i).Head(4) = Val(LeerINI.DarValor("CASCO" & i, "Head4"))
Next i

n = FreeFile
Open DirIndex & "\Cascos.ind" For Binary Access Write As #n

Put #n, , MiCabecera

Put #n, , NumCascos

For i = 1 To NumCascos
        HeadDataT(i).Head(1) = HeadDataTint(i).Head(1)
        HeadDataT(i).Head(2) = HeadDataTint(i).Head(2)
        HeadDataT(i).Head(3) = HeadDataTint(i).Head(3)
        HeadDataT(i).Head(4) = HeadDataTint(i).Head(4)
        Put #n, , HeadDataTint(i)
Next

GRHt.Text = "Guardando...Cascos.ind"
DoEvents
Close #n
GRHt.Text = "Compilado...Cascos.ind"

Exit Sub
fallo:
MsgBox "Error en Cascos.ini"

End Sub

Private Sub mnuIndexCompleto_Click()
Call mnuImportarCompleto_Click
mnuReload.Enabled = False
Call mnuIndexCabezas_Click
Call mnuIndexCuerpos_Click
Call mnuIndexCascos_Click
Call mnuIndexFXs_Click
Call mnuImportarArmas_Click
Call mnuImportarEscudos_Click
Call mnuImportarColores_Click
Call mnuImportarSinfo_Click
mnuReload.Enabled = True
GRHt.Text = "Indexación Completada..."
End Sub

Private Sub mnuIndexCuerpos_Click()
Dim i As Integer, j, n, K As Integer
GRHt.Text = "Compilando..."
DoEvents
Call DIR_INDEXADOR

Dim LeerINI As New clsLeerIni
Call LeerINI.Abrir(DirExpor & "\Cuerpos.ini")
NumCuerpos = Val(LeerINI.DarValor("INIT", "NumBodies"))
ReDim CuerpoData(0 To NumCuerpos + 1) As tIndiceCuerpo
If UsarGrhLong = False Then

    ReDim CuerpoDataInt(0 To NumCuerpos + 1) As tIndiceCuerpoInt
End If

For i = 1 To NumCuerpos
   CuerpoDataInt(i).Body(1) = LeerINI.DarValor("Body" & (i), "WALK1")
    CuerpoDataInt(i).Body(2) = LeerINI.DarValor("Body" & (i), "WALK2")
    CuerpoDataInt(i).Body(3) = LeerINI.DarValor("Body" & (i), "WALK3")
    CuerpoDataInt(i).Body(4) = LeerINI.DarValor("Body" & (i), "WALK4")
   CuerpoDataInt(i).HeadOffsetX = LeerINI.DarValor("Body" & (i), "HeadOffsetX")
    CuerpoDataInt(i).HeadOffsetY = LeerINI.DarValor("Body" & (i), "HeadOffsety")
Next i

n = FreeFile
Open DirIndex & "\Personajes.ind" For Binary Access Write As #n

'Escribimos la cabecera
Put #n, , MiCabecera
'Guardamos las cabezas
Put #n, , NumCuerpos

For i = 1 To NumCuerpos

        Put #n, , CuerpoDataInt(i)

        
Next i

Close #n

GRHt.Text = "Compilado...Personajes.ind"


End Sub

Private Sub mnuIndexFXs_Click()
Dim i As Integer, j, n, K As Integer
Dim Datos As String
GRHt.Text = "Compilando..."
DoEvents
Call DIR_INDEXADOR

Dim LeerINI As New clsLeerIni
Call LeerINI.Abrir(DirExpor & "\FXs.ini")

n = FreeFile
Open DirIndex & "\Fxs.ind" For Binary Access Write As #n

Put #n, , MiCabecera

K = Val(LeerINI.DarValor("INIT", "NumFxs"))

Put #n, , K

Dim EjFx(1) As tIndiceFx
If UsarGrhLong = False Then
    Dim EjFxInt(1) As tIndiceFxInt
End If

For i = 1 To K
    If UsarGrhLong = True Then
        EjFx(1).offsety = LeerINI.DarValor("FX" & i, "OffsetY")
        EjFx(1).offsetx = LeerINI.DarValor("FX" & i, "OffsetX")
        EjFx(1).Animacion = LeerINI.DarValor("FX" & i, "Animacion")
        EjFx(1).particula = LeerINI.DarValor("FX" & i, "P")
        EjFx(1).wav = LeerINI.DarValor("FX" & i, "S")
        Put #n, , EjFx(1)
    Else
        EjFxInt(1).offsety = LeerINI.DarValor("FX" & i, "OffsetY")
        EjFxInt(1).offsetx = LeerINI.DarValor("FX" & i, "OffsetX")
        EjFxInt(1).Animacion = LeerINI.DarValor("FX" & i, "Animacion")
        EjFxInt(1).particula = LeerINI.DarValor("FX" & i, "P")
        EjFxInt(1).wav = LeerINI.DarValor("FX" & i, "S")
        Put #n, , EjFxInt(1)
    End If
Next

GRHt.Text = "Guardando...FXs.ind"
DoEvents
Close #n
GRHt.Text = "Compilado...FXs.ind"


End Sub


Private Sub mnuIndexPartes_Click()
Call mnuImportarenPartes_Click
mnuReload.Enabled = False
Call mnuIndexCabezas_Click
Call mnuIndexCuerpos_Click
Call mnuIndexCascos_Click
Call mnuIndexFXs_Click
Call mnuImportarArmas_Click
Call mnuImportarEscudos_Click
Call mnuImportarColores_Click
Call mnuImportarSinfo_Click
mnuReload.Enabled = True
GRHt.Text = "Indexación Completada..."
End Sub

Private Sub mnuIrABMP_Click()
On Error Resume Next
    Dim i As Integer
    Dim j As Integer
    Dim Archivo As String
    BuscaBMP = 0
    mnuIrASBMP.Enabled = False
    Archivo = InputBox("Ingrese el numero de BMP:")
    If IsNumeric(Archivo) = False Then Exit Sub
    If LenB(Archivo) > 0 And (Archivo > 0) Then
        For i = 1 To MaxGRH
            If GrhData(i).FileNum = Archivo Then
                For j = 0 To Listado.ListCount - 1
                    If ReadField(1, Listado.List(j), Asc(" ")) = i Then
                            BuscaBMP = Archivo
                            mnuIrASBMP.Enabled = True
                            Listado.ListIndex = j
                        Exit Sub
                    End If
                Next
            End If
        Next
        MsgBox "No se encontro el BMP."
    Else
        MsgBox "Nombre de BMP invalido."
    End If
End Sub

Private Sub mnuIrAGRH_Click()
On Error Resume Next
Dim i As Integer
Dim j As Integer
    Dim Archivo As String
    Archivo = InputBox("Ingrese el numero de GRH:")
    If IsNumeric(Archivo) = False Then Exit Sub
    If LenB(Archivo) > 0 And (Archivo < MaxGRH) And (Archivo > 0) Then
        For i = 1 To MaxGRH
            If GrhData(i).NumFrames >= 1 And i = Archivo Then
                DoEvents
                For j = 0 To Listado.ListCount - 1
                    If ReadField(1, Listado.List(j), Asc(" ")) = Archivo Then
                            MsgBox "GRH encontrado."
                            Listado.ListIndex = j
                        Exit Sub
                    End If
                Next
            End If
        Next
        MsgBox "No se encontro el GRH."
    Else
        MsgBox "Nombre de GRH invalido."
    End If
End Sub

Private Sub mnuIrASBMP_Click()
On Error Resume Next
    Dim j As Integer
    Dim Archivo As String
    Archivo = BuscaBMP
    If IsNumeric(Archivo) = False Then Exit Sub
    If LenB(Archivo) > 0 And (Archivo > 0) Then
        For j = Listado.ListIndex + 1 To Listado.ListCount - 1
            If GrhData(ReadField(1, Listado.List(j), Asc(" "))).FileNum = Archivo Then
                    Listado.ListIndex = j
                Exit Sub
            End If
        Next
        MsgBox "No se encontro el BMP."
    End If
End Sub

Private Sub mnuIrCliente_Click()
On Error Resume Next
Call ShellExecute(Me.hwnd, "Open", DirClien, &O0, &O0, SW_NORMAL)

End Sub

Private Sub mnuIrExportacion_Click()
On Error Resume Next
Call ShellExecute(Me.hwnd, "Open", DirExpor, &O0, &O0, SW_NORMAL)

End Sub

Private Sub mnuIrIndexacion_Click()
On Error Resume Next
Call ShellExecute(Me.hwnd, "Open", DirIndex, &O0, &O0, SW_NORMAL)

End Sub

Private Sub mnuOpciones_Click()
frmOpciones.Tag = ""
frmOpciones.Show
End Sub

Private Sub mnuPrimerosPasos_Click()
frmPrimerosPasos.Show
End Sub

Private Sub mnuRecargarIndex_Click()
UsarIndex = True
Call RELOAD_ALL
End Sub

Private Sub mnuReload_Click()
UsarIndex = False
Call RELOAD_ALL
End Sub

Public Sub RELOAD_ALL()
Unload Arma
Unload CabezaM
Unload Casco
Unload Cuerpo
Unload Escudo
Unload FX
Me.Hide
Call Form_Load
DoEvents
Me.Visible = True
End Sub

Private Sub mnuSalir_Click()
End
End Sub

