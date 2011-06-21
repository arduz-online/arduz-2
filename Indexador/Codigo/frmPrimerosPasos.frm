VERSION 5.00
Begin VB.Form frmPrimerosPasos 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Primeros Pasos"
   ClientHeight    =   5490
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7515
   Icon            =   "frmPrimerosPasos.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5490
   ScaleWidth      =   7515
   StartUpPosition =   2  'CenterScreen
   Begin VB.Label Label15 
      BackStyle       =   0  'Transparent
      Caption         =   "Pasos: Menu Archivo -> Recargar desde Carpeta de Indexación"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Left            =   1080
      TabIndex        =   14
      Top             =   4920
      Width           =   5895
   End
   Begin VB.Label Label14 
      BackStyle       =   0  'Transparent
      Caption         =   "5"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   510
      TabIndex        =   13
      Top             =   4485
      Width           =   255
   End
   Begin VB.Image Image5 
      Height          =   795
      Left            =   240
      Picture         =   "frmPrimerosPasos.frx":0442
      Top             =   4320
      Width           =   795
   End
   Begin VB.Label Label13 
      BackStyle       =   0  'Transparent
      Caption         =   "Una vez indexado podemos ver los cambios rapidamente, recargando los index desde el directorio de Indexacion."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   615
      Left            =   1080
      TabIndex        =   12
      Top             =   4395
      Width           =   6135
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Pasos: Menu Archivo -> Indexar -> (el archivo editado o TODO)"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Left            =   1080
      TabIndex        =   11
      Top             =   3840
      Width           =   5895
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "4"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   510
      TabIndex        =   10
      Top             =   3405
      Width           =   255
   End
   Begin VB.Image Image4 
      Height          =   795
      Left            =   240
      Picture         =   "frmPrimerosPasos.frx":0CF2
      Top             =   3240
      Width           =   795
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Una vez editado, y guardados nuestros cambios, tenemos que Indexarlo TODO al menos una primera vez."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   615
      Left            =   1080
      TabIndex        =   9
      Top             =   3315
      Width           =   6135
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "Pasos: Menu Visita www.gs-zone.com.ar -> Biblioteca"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Left            =   1080
      TabIndex        =   8
      Top             =   2760
      Width           =   5895
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "3"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   510
      TabIndex        =   7
      Top             =   2325
      Width           =   255
   End
   Begin VB.Image Image3 
      Height          =   795
      Left            =   240
      Picture         =   "frmPrimerosPasos.frx":15A2
      Top             =   2160
      Width           =   795
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Editamos, con NotePad o similar, los archivos que precisamos cambiar, para ello necesitamos un manual o tutorial."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   615
      Left            =   1080
      TabIndex        =   6
      Top             =   2235
      Width           =   6135
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Pasos: Menu Ir a... -> ... la Carpeta de Exportación"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Left            =   1080
      TabIndex        =   5
      Top             =   1680
      Width           =   5895
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "2"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   510
      TabIndex        =   4
      Top             =   1245
      Width           =   255
   End
   Begin VB.Image Image2 
      Height          =   795
      Left            =   240
      Picture         =   "frmPrimerosPasos.frx":1E52
      Top             =   1080
      Width           =   795
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Segundo tenemos que ir al directorio que seleccionamos como Carpeta de Exportación..."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   615
      Left            =   1080
      TabIndex        =   3
      Top             =   1155
      Width           =   6135
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Pasos: Menu Archivo -> Exportar -> TODO"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   255
      Left            =   1080
      TabIndex        =   2
      Top             =   720
      Width           =   5895
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   510
      TabIndex        =   1
      Top             =   290
      Width           =   255
   End
   Begin VB.Image Image1 
      Height          =   795
      Left            =   240
      Picture         =   "frmPrimerosPasos.frx":2702
      Top             =   120
      Width           =   795
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Lo primero que debes hacer para comenzar a Indexar con el Indexador HiPr0, es Exportar TODOS los Index..."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   615
      Left            =   1080
      TabIndex        =   0
      Top             =   200
      Width           =   6135
   End
End
Attribute VB_Name = "frmPrimerosPasos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

