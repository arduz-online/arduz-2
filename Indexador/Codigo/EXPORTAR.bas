Attribute VB_Name = "eXpessial"
Option Explicit

      Private Const BIF_RETURNONLYFSDIRS = 1
      Private Const BIF_DONTGOBELOWDOMAIN = 2
      Private Const MAX_PATH = 260

      Private Declare Function SHBrowseForFolder Lib "shell32" _
                                        (lpbi As BrowseInfo) As Long

      Private Declare Function SHGetPathFromIDList Lib "shell32" _
                                        (ByVal pidList As Long, _
                                        ByVal lpBuffer As String) As Long

      Private Declare Function lstrcat Lib "kernel32" Alias "lstrcatA" _
                                        (ByVal lpString1 As String, ByVal _
                                        lpString2 As String) As Long

      Private Type BrowseInfo
         hWndOwner      As Long
         pIDLRoot       As Long
         pszDisplayName As Long
         lpszTitle      As Long
         ulFlags        As Long
         lpfnCallback   As Long
         lParam         As Long
         iImage         As Long
      End Type

Function SeleccionarDirectorio() As String
    Dim lpIDList As Long
    Dim sBuffer As String
    Dim szTitle As String
    Dim tBrowseInfo As BrowseInfo
    SeleccionarDirectorio = ""
    szTitle = "Seleccione el Directorio"
    With tBrowseInfo
            .hWndOwner = frmOpciones.hwnd
            .lpszTitle = lstrcat(szTitle, "")
            .ulFlags = BIF_RETURNONLYFSDIRS + BIF_DONTGOBELOWDOMAIN
    End With
    lpIDList = SHBrowseForFolder(tBrowseInfo)
    If (lpIDList) Then
            sBuffer = Space(MAX_PATH)
            SHGetPathFromIDList lpIDList, sBuffer
            sBuffer = Left(sBuffer, InStr(sBuffer, vbNullChar) - 1)
            SeleccionarDirectorio = sBuffer
    End If
End Function

Sub ExportarDAT(ByVal Nombre As String)
On Error Resume Next
Form1.GRHt.Text = "Exportando..."
DoEvents
If LenB(Dir(DirClien & "\INIT\" & Nombre & ".dat", vbArchive)) = 0 Then
    Form1.GRHt.Text = "ERROR: No existe " & Nombre & ".dat en la carpeta INIT del cliente."
    Exit Sub
End If
Call DIR_INDEXADOR
Call Kill(DirExpor & "\" & Nombre & ".ini")
Call FileCopy(DirClien & "\INIT\" & Nombre & ".dat", DirExpor & "\" & Nombre & ".ini")
If LenB(Dir(DirExpor & "\" & Nombre & ".ini", vbArchive)) = 0 Then
    Form1.GRHt.Text = "ERROR: No se ha podido exportar " & Nombre & ".ini"
Else
    Form1.GRHt.Text = "Exportado..." & Nombre & ".ini"
End If
End Sub

Sub ImportarDAT(ByVal Nombre As String)
On Error Resume Next
Form1.GRHt.Text = "Importando..."
DoEvents
Call DIR_INDEXADOR
If LenB(Dir(DirExpor & "\" & Nombre & ".ini", vbArchive)) = 0 Then
    Form1.GRHt.Text = "ERROR: No existe " & Nombre & ".ini"
    Exit Sub
End If
Call Kill(DirIndex & "\" & Nombre & ".dat")
Call FileCopy(DirExpor & "\" & Nombre & ".ini", DirIndex & "\" & Nombre & ".dat")
If LenB(Dir(DirIndex & "\" & Nombre & ".dat", vbArchive)) = 0 Then
    Form1.GRHt.Text = "ERROR: No se ha podido importar " & Nombre & ".dat"
Else
    Form1.GRHt.Text = "Importado..." & Nombre & ".dat"
End If
End Sub

Sub LeerOpciones()
Dim Temporal As String
DirIndex = GetVar(App.path & "\Indexador.ini", "DIRECTORIOS", "DirIndex")
DirExpor = GetVar(App.path & "\Indexador.ini", "DIRECTORIOS", "DirExport")
DirClien = GetVar(App.path & "\Indexador.ini", "DIRECTORIOS", "DirClient")
Temporal = GetVar(App.path & "\Indexador.ini", "GRAFICOS", "MaxGrh")
UsarGrhLong = (CStr(GetVar(App.path & "\Indexador.ini", "GRAFICOS", "UsarGrhLong")) = "1")
If Temporal = vbNullString Then
    Temporal = 15000
    MaxGRH = Val(Temporal)
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
End If
If UsarGrhLong = False And Temporal <= 0 And Temporal > 32768 Then
    Temporal = 15000
    MaxGRH = Val(Temporal)
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
ElseIf Temporal <= 0 And Temporal > 2000000 Then
    Temporal = 15000
    MaxGRH = Val(Temporal)
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
Else
    MaxGRH = Val(Temporal)
End If
ReDim GrhData(1 To MaxGRH) As tGrhData
If LenB(Dir(DirIndex, vbDirectory)) = 0 Or LenB(DirIndex) = 0 Then
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
ElseIf LenB(Dir(DirExpor, vbDirectory)) = 0 Or LenB(DirExpor) = 0 Then
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
ElseIf LenB(Dir(DirClien, vbDirectory)) = 0 Or LenB(DirClien) = 0 Then
    Call frmOpciones.Show
    DoEvents
    frmOpciones.Tag = "1"
End If


End Sub
