VERSION 5.00
Begin VB.Form frmOpciones 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Opciones"
   ClientHeight    =   4545
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7380
   Icon            =   "frmOpciones.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4545
   ScaleWidth      =   7380
   StartUpPosition =   2  'CenterScreen
   Begin VB.OptionButton optLng 
      BackColor       =   &H00000000&
      Caption         =   "Grh Long (Maximo 2000000 - Requiere hasta 256MB de Ram libre)"
      ForeColor       =   &H0000C000&
      Height          =   255
      Left            =   2160
      MaskColor       =   &H00000000&
      TabIndex        =   18
      Top             =   3240
      Width           =   5055
   End
   Begin VB.OptionButton optInt 
      BackColor       =   &H00000000&
      Caption         =   "Grh Integer (Maximo 32768 - Requiere hasta 16MB de RAM libre)"
      ForeColor       =   &H0000C000&
      Height          =   255
      Left            =   2160
      MaskColor       =   &H00000000&
      TabIndex        =   17
      Top             =   3000
      Value           =   -1  'True
      Width           =   5055
   End
   Begin VB.TextBox DIRECT 
      Appearance      =   0  'Flat
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Index           =   3
      Left            =   2160
      MaxLength       =   7
      TabIndex        =   15
      Text            =   "15000"
      Top             =   2640
      Width           =   3975
   End
   Begin VB.CommandButton Command4 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      Caption         =   "Ex&aminar"
      Height          =   255
      Left            =   5640
      Style           =   1  'Graphical
      TabIndex        =   10
      Top             =   1680
      Width           =   1455
   End
   Begin VB.CommandButton Command3 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      Caption         =   "E&xaminar"
      Height          =   255
      Left            =   5640
      Style           =   1  'Graphical
      TabIndex        =   9
      Top             =   960
      Width           =   1455
   End
   Begin VB.CommandButton Command2 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      Caption         =   "&Examinar"
      Height          =   255
      Left            =   5640
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   240
      Width           =   1455
   End
   Begin VB.TextBox DIRECT 
      Appearance      =   0  'Flat
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Index           =   2
      Left            =   2160
      TabIndex        =   7
      Top             =   1680
      Width           =   3495
   End
   Begin VB.TextBox DIRECT 
      Appearance      =   0  'Flat
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Index           =   1
      Left            =   2160
      TabIndex        =   6
      Top             =   960
      Width           =   3495
   End
   Begin VB.TextBox DIRECT 
      Appearance      =   0  'Flat
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Index           =   0
      Left            =   2160
      TabIndex        =   5
      Top             =   240
      Width           =   3495
   End
   Begin VB.CommandButton Command1 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   3600
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   3960
      Width           =   1695
   End
   Begin VB.CommandButton BuscarFile 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      Caption         =   "&Guardar y Aplicar"
      Height          =   375
      Left            =   5400
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   3960
      Width           =   1695
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Default 15000"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   195
      Left            =   6240
      TabIndex        =   16
      Top             =   2640
      Width           =   1020
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Limitar el Maximo de Grh:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   14
      Top             =   2640
      Width           =   2055
   End
   Begin VB.Line Line2 
      BorderColor     =   &H0000FF00&
      BorderWidth     =   2
      X1              =   240
      X2              =   7200
      Y1              =   3720
      Y2              =   3720
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ejemplo: C:\Archivos de Programas\Argentum Online\Indexado"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   195
      Left            =   1560
      TabIndex        =   13
      Top             =   2040
      Width           =   4545
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ejemplo: C:\Archivos de Programas\Argentum Online\Exportado"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   195
      Left            =   1560
      TabIndex        =   12
      Top             =   1320
      Width           =   4605
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ejemplo: C:\Archivos de Programas\Argentum Online"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   195
      Left            =   1560
      TabIndex        =   11
      Top             =   600
      Width           =   3795
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Carpeta de Indexación:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   1680
      Width           =   1815
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Carpeta de Exportación:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   960
      Width           =   1815
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Directorio del Cliente:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   1695
   End
   Begin VB.Line Line1 
      BorderColor     =   &H0000FF00&
      BorderWidth     =   2
      X1              =   240
      X2              =   7200
      Y1              =   2400
      Y2              =   2400
   End
End
Attribute VB_Name = "frmOpciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub BuscarFile_Click()
On Error GoTo fallo
If LenB(Dir(DIRECT(1).Text, vbDirectory)) = 0 Then
    If LenB(DIRECT(1).Text) = 0 Then
        MsgBox "Carpeta de Exportación invalida."
        Exit Sub
    Else
        Call MkDir(DIRECT(1).Text)
        DoEvents
        If LenB(Dir(DIRECT(1).Text, vbDirectory)) = 0 Then
            MsgBox "Carpeta de Exportación invalida."
            Exit Sub
        End If
    End If
End If
If LenB(Dir(DIRECT(2).Text, vbDirectory)) = 0 Or LenB(DIRECT(2).Text) = 0 Then
    If LenB(DIRECT(2).Text) = 0 Then
        MsgBox "Carpeta de Indexación invalida."
        Exit Sub
    Else
        Call MkDir(DIRECT(2).Text)
        DoEvents
        If LenB(Dir(DIRECT(2).Text, vbDirectory)) = 0 Then
            MsgBox "Carpeta de Indexación invalida."
            Exit Sub
        End If
    End If
End If
If LenB(Dir(DIRECT(0).Text, vbDirectory)) = 0 Or LenB(DIRECT(0).Text) = 0 Then
    MsgBox "Carpeta del Cliente invalida."
    Exit Sub
End If
If IsNumeric(DIRECT(3).Text) = False Or DIRECT(3).Text = vbNullString Then
    MsgBox "El Limite de Grh es invalido."
    Exit Sub
ElseIf DIRECT(3).Text <> MaxGRH Then
    MsgBox "Para ver el cambio en la Limitación de Grh debe Recargar la Informacion", vbInformation + vbOKOnly
End If

If optLng.value = True Then
    If DIRECT(3).Text <= 0 Or DIRECT(3).Text > 2000000 Then
        MsgBox "El Limite de Grh es invalido."
        Exit Sub
    End If
ElseIf optInt.value = True Then
    If DIRECT(3).Text <= 0 Or DIRECT(3).Text > 32768 Then
        MsgBox "El Limite de Grh es invalido."
        Exit Sub
    End If
End If

If frmOpciones.Tag = "1" Then
    Call frmPrimerosPasos.Show
    frmPrimerosPasos.Tag = "1"
    frmOpciones.Tag = ""
End If

Call WriteVar(App.Path & "\Indexador.ini", "DIRECTORIOS", "DirClient", DIRECT(0).Text)
Call WriteVar(App.Path & "\Indexador.ini", "DIRECTORIOS", "DirExport", DIRECT(1).Text)
Call WriteVar(App.Path & "\Indexador.ini", "DIRECTORIOS", "DirIndex", DIRECT(2).Text)
Call WriteVar(App.Path & "\Indexador.ini", "GRAFICOS", "MaxGrh", DIRECT(3).Text)
Call WriteVar(App.Path & "\Indexador.ini", "GRAFICOS", "UsarGrhLong", IIf(optLng.value = True, "1", "0"))

Call LeerOpciones

Unload Me

Exit Sub

fallo:
MsgBox "ERROR " & Err.Number & ", verifique los directorios.", vbCritical
End Sub

Private Sub Command1_Click()
If frmOpciones.Tag = "1" Then
    End
Else
    Unload Me
End If
End Sub

Private Sub Command2_Click()
DIRECT(0).Text = SeleccionarDirectorio
End Sub

Private Sub Command3_Click()
DIRECT(1).Text = SeleccionarDirectorio

End Sub

Private Sub Command4_Click()
DIRECT(2).Text = SeleccionarDirectorio

End Sub

Private Sub Form_Load()
DIRECT(0).Text = DirClien
DIRECT(1).Text = DirExpor
DIRECT(2).Text = DirIndex
DIRECT(3).Text = MaxGRH
If UsarGrhLong = True Then optLng.value = True

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
If frmOpciones.Tag = "1" Then
    End
Else
    Unload Me
End If
End Sub

