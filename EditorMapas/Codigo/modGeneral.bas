Attribute VB_Name = "modGeneral"
'**************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the GNU General Public License as published by
'the Free Software Foundation; either version 2 of the License, or
'any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'**************************************************************

''
' modGeneral
'
' @remarks Funciones Generales
' @author unkwown
' @version 0.4.11
' @date 20061015

Option Explicit

Public Type typDevMODE
    dmDeviceName       As String * 32
    dmSpecVersion      As Integer
    dmDriverVersion    As Integer
    dmSize             As Integer
    dmDriverExtra      As Integer
    dmFields           As Long
    dmOrientation      As Integer
    dmPaperSize        As Integer
    dmPaperLength      As Integer
    dmPaperWidth       As Integer
    dmScale            As Integer
    dmCopies           As Integer
    dmDefaultSource    As Integer
    dmPrintQuality     As Integer
    dmColor            As Integer
    dmDuplex           As Integer
    dmYResolution      As Integer
    dmTTOption         As Integer
    dmCollate          As Integer
    dmFormName         As String * 32
    dmUnusedPadding    As Integer
    dmBitsPerPel       As Integer
    dmPelsWidth        As Long
    dmPelsHeight       As Long
    dmDisplayFlags     As Long
    dmDisplayFrequency As Long
End Type
Public Declare Function EnumDisplaySettings Lib "user32" Alias "EnumDisplaySettingsA" (ByVal lpszDeviceName As Long, ByVal iModeNum As Long, lptypDevMode As Any) As Boolean
Public Declare Function ChangeDisplaySettings Lib "user32" Alias "ChangeDisplaySettingsA" (lptypDevMode As Any, ByVal dwFlags As Long) As Long

Public Const CCDEVICENAME = 32
Public Const CCFORMNAME = 32
Public Const DM_BITSPERPEL = &H40000
Public Const DM_PELSWIDTH = &H80000
Public Const DM_DISPLAYFREQUENCY = &H400000
Public Const DM_PELSHEIGHT = &H100000
Public Const CDS_UPDATEREGISTRY = &H1
Public Const CDS_TEST = &H4
Public Const DISP_CHANGE_SUCCESSFUL = 0
Public Const DISP_CHANGE_RESTART = 1

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

''
' Realiza acciones de desplasamiento segun las teclas que hallamos precionado
'

Public Sub CheckKeys()
'*************************************************
'Author: ^[GS]^
'Last modified: 01/11/08
'*************************************************

If HotKeysAllow = False Then Exit Sub
        '[Loopzer]
        'If GetKeyState(vbKeyControl) < 0 Then
        '    If Seleccionando Then
        '        If GetKeyState(vbKeyC) < 0 Then CopiarSeleccion
        '        If GetKeyState(vbKeyX) < 0 Then CortarSeleccion
        '        If GetKeyState(vbKeyB) < 0 Then BlockearSeleccion
        '        If GetKeyState(vbKeyD) < 0 Then AccionSeleccion
        ''    Else
        '        If GetKeyState(vbKeyS) < 0 Then DePegar ' GS
        '        If GetKeyState(vbKeyV) < 0 Then PegarSeleccion
        '    End If
        'End If
        '[/Loopzer]
    
    
    If GetKeyState(vbKeyUp) < 0 Then
        If UserPos.y < 1 Then Exit Sub ' 10
        If LegalPos(UserPos.X, UserPos.y - 1) And WalkMode = True Then
            If dLastWalk + 50 > GetTickCount Then Exit Sub
            UserPos.y = UserPos.y - 1
            MoveCharbyPos UserCharIndex, UserPos.X, UserPos.y
            dLastWalk = GetTickCount
        ElseIf WalkMode = False Then
            UserPos.y = UserPos.y - 1
        End If
        bRefreshRadar = True ' Radar
        frmMain.SetFocus
        Exit Sub
    End If

    If GetKeyState(vbKeyRight) < 0 Then
        If UserPos.X > MaxXBorder Then Exit Sub ' 89
        If LegalPos(UserPos.X + 1, UserPos.y) And WalkMode = True Then
            If dLastWalk + 50 > GetTickCount Then Exit Sub
            UserPos.X = UserPos.X + 1
            MoveCharbyPos UserCharIndex, UserPos.X, UserPos.y
            dLastWalk = GetTickCount
        ElseIf WalkMode = False Then
            UserPos.X = UserPos.X + 1
        End If
        bRefreshRadar = True ' Radar
        frmMain.SetFocus
        Exit Sub
    End If

    If GetKeyState(vbKeyDown) < 0 Then
        If UserPos.y > MaxYBorder Then Exit Sub ' 92
        If LegalPos(UserPos.X, UserPos.y + 1) And WalkMode = True Then
            If dLastWalk + 50 > GetTickCount Then Exit Sub
            UserPos.y = UserPos.y + 1
            MoveCharbyPos UserCharIndex, UserPos.X, UserPos.y
            dLastWalk = GetTickCount
        ElseIf WalkMode = False Then
            UserPos.y = UserPos.y + 1
        End If
        bRefreshRadar = True ' Radar
        frmMain.SetFocus
        Exit Sub
    End If

    If GetKeyState(vbKeyLeft) < 0 Then
        If UserPos.X < 1 Then Exit Sub ' 12
        If LegalPos(UserPos.X - 1, UserPos.y) And WalkMode = True Then
            If dLastWalk + 50 > GetTickCount Then Exit Sub
            UserPos.X = UserPos.X - 1
            MoveCharbyPos UserCharIndex, UserPos.X, UserPos.y
            dLastWalk = GetTickCount
        ElseIf WalkMode = False Then
            UserPos.X = UserPos.X - 1
        End If
        bRefreshRadar = True ' Radar
        frmMain.SetFocus
        Exit Sub
    End If
    
End Sub

Public Function ReadField(Pos As Integer, Text As String, SepASCII As Integer) As String
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************
Dim i As Integer
Dim LastPos As Integer
Dim CurChar As String * 1
Dim FieldNum As Integer
Dim Seperator As String

Seperator = Chr(SepASCII)
LastPos = 0
FieldNum = 0

For i = 1 To Len(Text)
    CurChar = mid(Text, i, 1)
    If CurChar = Seperator Then
        FieldNum = FieldNum + 1
        If FieldNum = Pos Then
            ReadField = mid(Text, LastPos + 1, (InStr(LastPos + 1, Text, Seperator, vbTextCompare) - 1) - (LastPos))
            Exit Function
        End If
        LastPos = i
    End If
Next i
FieldNum = FieldNum + 1

If FieldNum = Pos Then
    ReadField = mid(Text, LastPos + 1)
End If

End Function


''
' Completa y corrije un path
'
' @param Path Especifica el path con el que se trabajara
' @return   Nos devuelve el path completado

Private Function autoCompletaPath(ByVal Path As String) As String
'*************************************************
'Author: ^[GS]^
'Last modified: 22/05/06
'*************************************************
'Path = Replace(Path, "/", "\")
'If Left(Path, 1) = "\" Then
'    ' agrego app.path & path
'    Path = App.Path & Path
'End If
'If Right(Path, 1) <> "\" Then
'    ' me aseguro que el final sea con "\"
'    Path = Path & "\"
'End If
'autoCompletaPath = Path
autoCompletaPath = GetPath(Path)
End Function

Public Function FolderExist(ByVal folder As String) As Boolean
    FolderExist = (Dir$(folder, vbDirectory) <> "")
End Function

Public Function PathGetParent(ByVal sFolder As String, Optional lParentIndex As Long = 1) As String
    Dim asFolders() As String
    Dim sPathSep As String
    Dim lThisFolder As Long
    
    If Len(sFolder) > 0 Then
        'Determine the path seperator
        If InStr(1, sFolder, "/") > 0 Then
            sPathSep = "/"
        Else
            sPathSep = "\"
        End If
        
        If Right$(sFolder, 1) <> sPathSep Then
            sFolder = sFolder & sPathSep
        End If
        
        asFolders = Split(sFolder, sPathSep)
        'Get the requested parent folder
        For lThisFolder = 0 To UBound(asFolders) - lParentIndex - 1
            PathGetParent = PathGetParent & asFolders(lThisFolder) & sPathSep
        Next
    End If
End Function

Public Function GetPath(ByVal TmpPath As String, Optional ByVal default As String = vbNullString) As String
'MENDUZ!
    
    If default = vbNullString Then default = App.Path
    
    TmpPath = Replace(TmpPath, "/", "\")
    
    If Len(TmpPath) Then
        If Left$(TmpPath, 2) = ".." Then _
            TmpPath = PathGetParent(App.Path) & Right$(TmpPath, Len(TmpPath) - 3)
        If Left$(TmpPath, 1) = "." Then _
            TmpPath = App.Path & Right$(TmpPath, Len(TmpPath) - 1)
    Else
        TmpPath = App.Path
    End If
    
    If FolderExist(TmpPath) = False Then
        TmpPath = default
    End If
    
    If Right$(TmpPath, 1) <> "\" Then TmpPath = TmpPath & "\"
    GetPath = TmpPath
End Function

''
' Carga la configuracion del WorldEditor de WorldEditor.ini
'

Private Sub CargarMapIni()
'*************************************************
'Author: ^[GS]^
'Last modified: 24/11/08
'*************************************************
On Error GoTo Fallo
Dim tStr As String
Dim Leer As New clsIniReader

IniPath = App.Path & "\"

If FileExist(IniPath & "WorldEditor.ini", vbArchive) = False Then
    frmMain.mnuGuardarUltimaConfig.Checked = True
    DirGraficos = IniPath & "Graficos\"
    DirIndex = IniPath & "INIT\"
    DirMidi = IniPath & "MIDI\"
    frmMusica.fleMusicas.Path = DirMidi
    DirDats = IniPath & "DATS\"
    MaxGrhs = 15000
    UserPos.X = 50
    UserPos.y = 50
    PantallaX = 19
    PantallaY = 22
    MsgBox "Falta el archivo 'WorldEditor.ini' de configuración.", vbInformation
    Exit Sub
End If

Call Leer.Initialize(IniPath & "WorldEditor.ini")

' Obj de Translado
Cfg_TrOBJ = Val(Leer.GetValue("CONFIGURACION", "ObjTranslado"))
frmMain.mnuAutoCapturarTranslados.Checked = Val(Leer.GetValue("CONFIGURACION", "AutoCapturarTrans"))
frmMain.mnuAutoCapturarSuperficie.Checked = Val(Leer.GetValue("CONFIGURACION", "AutoCapturarSup"))
frmMain.mnuUtilizarDeshacer.Checked = Val(Leer.GetValue("CONFIGURACION", "UtilizarDeshacer"))

' Guardar Ultima Configuracion
frmMain.mnuGuardarUltimaConfig.Checked = Val(Leer.GetValue("CONFIGURACION", "GuardarConfig"))

' Index
MaxGrhs = Val(GetVar(IniPath & "WorldEditor.ini", "INDEX", "MaxGrhs"))
If MaxGrhs < 1 Then MaxGrhs = 15000

'Reciente
frmMain.Dialog.InitDir = Leer.GetValue("PATH", "UltimoMapa")
DirGraficos = autoCompletaPath(Leer.GetValue("PATH", "DirGraficos"))
If DirGraficos = "\" Then
    DirGraficos = IniPath & "Graficos\"
End If
If FileExist(DirGraficos, vbDirectory) = False Then
    MsgBox "El directorio de Graficos es incorrecto", vbCritical + vbOKOnly
    End
End If
DirMidi = autoCompletaPath(Leer.GetValue("PATH", "DirMidi"))
If DirMidi = "\" Then
    DirMidi = IniPath & "MIDI\"
End If
If FileExist(DirMidi, vbDirectory) = False Then
    MsgBox "El directorio de MIDI es incorrecto", vbCritical + vbOKOnly
    End
End If
frmMusica.fleMusicas.Path = DirMidi
DirIndex = autoCompletaPath(Leer.GetValue("PATH", "DirIndex"))
If DirIndex = "\" Then
    DirIndex = IniPath & "INIT\"
End If
If FileExist(DirIndex, vbDirectory) = False Then
    MsgBox "El directorio de Index es incorrecto", vbCritical + vbOKOnly
    End
End If
DirDats = autoCompletaPath(Leer.GetValue("PATH", "DirDats"))
If DirDats = "\" Then
    DirDats = IniPath & "DATS\"
End If
If FileExist(DirDats, vbDirectory) = False Then
    MsgBox "El directorio de Dats es incorrecto", vbCritical + vbOKOnly
    End
End If

tStr = Leer.GetValue("MOSTRAR", "LastPos") ' x-y
UserPos.X = Val(ReadField(1, tStr, Asc("-")))
UserPos.y = Val(ReadField(2, tStr, Asc("-")))
If UserPos.X < XMinMapSize Or UserPos.X > XMaxMapSize Then
    UserPos.X = 50
End If
If UserPos.y < YMinMapSize Or UserPos.y > YMaxMapSize Then
    UserPos.y = 50
End If

' Menu Mostrar
frmMain.mnuVerAutomatico.Checked = Val(Leer.GetValue("MOSTRAR", "ControlAutomatico"))
frmMain.mnuVerCapa2.Checked = Val(Leer.GetValue("MOSTRAR", "Capa2"))
frmMain.mnuVerCapa3.Checked = Val(Leer.GetValue("MOSTRAR", "Capa3"))
frmMain.mnuVerCapa4.Checked = Val(Leer.GetValue("MOSTRAR", "Capa4"))
frmMain.mnuVerTranslados.Checked = Val(Leer.GetValue("MOSTRAR", "Translados"))
frmMain.mnuVerObjetos.Checked = Val(Leer.GetValue("MOSTRAR", "Objetos"))
frmMain.mnuVerNPCs.Checked = Val(Leer.GetValue("MOSTRAR", "NPCs"))
frmMain.mnuVerTriggers.Checked = Val(Leer.GetValue("MOSTRAR", "Triggers"))
frmMain.mnuVerGrilla.Checked = Val(Leer.GetValue("MOSTRAR", "Grilla")) ' Grilla
VerGrilla = frmMain.mnuVerGrilla.Checked
frmMain.mnuVerBloqueos.Checked = Val(Leer.GetValue("MOSTRAR", "Bloqueos"))
frmMain.cVerTriggers.value = frmMain.mnuVerTriggers.Checked
frmMain.cVerBloqueos.value = frmMain.mnuVerBloqueos.Checked

' Tamaño de visualizacion
PantallaX = Val(Leer.GetValue("MOSTRAR", "PantallaX"))
PantallaY = Val(Leer.GetValue("MOSTRAR", "PantallaY"))
If PantallaX > 23 Or PantallaX <= 2 Then PantallaX = 23
If PantallaY > 32 Or PantallaY <= 2 Then PantallaY = 32

' [GS] 02/10/06
' Tamaño de visualizacion en el cliente
ClienteHeight = Val(Leer.GetValue("MOSTRAR", "ClienteHeight"))
ClienteWidth = Val(Leer.GetValue("MOSTRAR", "ClienteWidth"))
If ClienteHeight <= 0 Then ClienteHeight = 13
If ClienteWidth <= 0 Then ClienteWidth = 17

Exit Sub
Fallo:
    MsgBox "ERROR " & Err.Number & " en WorldEditor.ini" & vbCrLf & Err.Description, vbCritical
    Resume Next
End Sub

Public Function TomarBPP() As Integer
    Dim ModoDeVideo As typDevMODE
    Call EnumDisplaySettings(0, -1, ModoDeVideo)
    TomarBPP = CInt(ModoDeVideo.dmBitsPerPel)
End Function
Public Sub CambioDeVideo()
'*************************************************
'Author: Loopzer
'*************************************************
Exit Sub
Dim ModoDeVideo As typDevMODE
Dim r As Long
Call EnumDisplaySettings(0, -1, ModoDeVideo)
    If ModoDeVideo.dmPelsWidth < 1024 Or ModoDeVideo.dmPelsHeight < 768 Then
        Select Case MsgBox("La aplicacion necesita una resolucion minima de 1024 X 768 ,¿Acepta el Cambio de resolucion?", vbInformation + vbOKCancel, "World Editor")
            Case vbOK
                ModoDeVideo.dmPelsWidth = 1024
                ModoDeVideo.dmPelsHeight = 768
                ModoDeVideo.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT
                r = ChangeDisplaySettings(ModoDeVideo, CDS_TEST)
                If r <> 0 Then
                    MsgBox "Error al cambiar la resolucion, La aplicacion se cerrara."
                    End
                End If
            Case vbCancel
                End
        End Select
    End If
End Sub

Public Sub Main()
'*************************************************
'Author: Unkwown
'Last modified: 25/11/08 - GS
'*************************************************
On Error Resume Next
If App.PrevInstance = True Then End
CambioDeVideo
Dim OffsetCounterX As Integer
Dim OffsetCounterY As Integer
Dim Chkflag As Integer

Call CargarMapIni
Call IniciarCabecera(MiCabecera)

If FileExist(IniPath & "WorldEditor.jpg", vbArchive) Then frmCargando.Picture1.Picture = LoadPicture(IniPath & "WorldEditor.jpg")
frmCargando.verX = "v" & App.Major & "." & App.Minor & "." & App.Revision
frmCargando.Show
frmCargando.SetFocus
DoEvents
frmCargando.X.Caption = "Iniciando DirectSound..."
IniciarDirectSound
DoEvents
frmCargando.X.Caption = "Cargando Indice de Superficies..."
modIndices.CargarIndicesSuperficie
DoEvents
frmCargando.X.Caption = "Indexando Cargado de Imagenes..."
DoEvents
If FileExist(DirIndex & "AO.dat", vbArchive) Then
    Call LoadClientSetup
    If ClientSetup.bDinamic Then
        Set SurfaceDB = New clsSurfaceManDyn
    Else
        Set SurfaceDB = New clsSurfaceManStatic
    End If
Else
    'Por default usamos el dinámico
    ClientSetup.bDinamic = True
    ClientSetup.byMemory = 16
    ClientSetup.bUseVideo = False
    Set SurfaceDB = New clsSurfaceManDyn
End If
frmMain.MainViewShp.Width = PantallaX ^ 3
frmMain.MainViewShp.Height = PantallaY ^ 3
If InitTileEngine(frmMain.hWnd, frmMain.MainViewShp.Top + 47, frmMain.MainViewShp.Left + 4, 32, 32, PantallaX, PantallaY, 9) Then ' 30/05/2006
    'Display form handle, View window offset from 0,0 of display form, Tile Size, Display size in tiles, Screen buffer
    frmCargando.P1.Visible = True
    frmCargando.L(0).Visible = True
    frmCargando.X.Caption = "Cargando Cuerpos..."
    modIndices.CargarIndicesDeCuerpos
    DoEvents
    frmCargando.P2.Visible = True
    frmCargando.L(1).Visible = True
    frmCargando.X.Caption = "Cargando Cabezas..."
    modIndices.CargarIndicesDeCabezas
    DoEvents
    frmCargando.P3.Visible = True
    frmCargando.L(2).Visible = True
    frmCargando.X.Caption = "Cargando NPC's..."
    'modIndices.CargarIndicesNPC
    DoEvents
    frmCargando.P4.Visible = True
    frmCargando.L(3).Visible = True
    frmCargando.X.Caption = "Cargando Objetos..."
    'modIndices.CargarIndicesOBJ
    DoEvents
    frmCargando.P5.Visible = True
    frmCargando.L(4).Visible = True
    frmCargando.X.Caption = "Cargando Triggers..."
    modIndices.CargarIndicesTriggers
    DoEvents
    frmCargando.P6.Visible = True
    frmCargando.L(5).Visible = True
    DoEvents
End If
frmCargando.SetFocus
frmCargando.X.Caption = "Iniciando Ventana de Edición..."
DoEvents
If LenB(Dir(App.Path & "\manual\index.html", vbArchive)) = 0 Then
    frmMain.mnuManual.Enabled = False
    frmMain.mnuManual.Caption = "&Manual (no implementado)"
End If
frmCargando.Hide
frmMain.Show
modMapIO.NuevoMapa
DoEvents
With MainDestRect
    .Left = (TilePixelWidth * TileBufferSize) - TilePixelWidth
    .Top = (TilePixelHeight * TileBufferSize) - TilePixelHeight
    .Right = .Left + MainViewWidth
    .Bottom = .Top + MainViewHeight
End With
With MainViewRect
    .Left = (frmMain.Left / Screen.TwipsPerPixelX) + MainViewLeft
    .Top = (frmMain.Top / Screen.TwipsPerPixelY) + MainViewTop
    .Right = .Left + MainViewWidth
    .Bottom = .Top + MainViewHeight
End With
prgRun = True
cFPS = 0
Chkflag = 0
dTiempoGT = GetTickCount


Do While prgRun
    If (GetTickCount - dTiempoGT) >= 1000 Then
        CaptionWorldEditor frmMain.Dialog.FileName, (MapInfo.Changed = 1)
        frmMain.FPS.Caption = "FPS: " & cFPS
        cFPS = 1
        dTiempoGT = GetTickCount
    Else
        cFPS = cFPS + 1
    End If
    If AddtoUserPos.X <> 0 Then
        OffsetCounterX = (OffsetCounterX - (8 * Sgn(AddtoUserPos.X)))
        If Abs(OffsetCounterX) >= Abs(TilePixelWidth * AddtoUserPos.X) Then
            OffsetCounterX = 0
            AddtoUserPos.X = 0
        End If
    ElseIf AddtoUserPos.y <> 0 Then
        OffsetCounterY = OffsetCounterY - (8 * Sgn(AddtoUserPos.y))
        If Abs(OffsetCounterY) >= Abs(TilePixelHeight * AddtoUserPos.y) Then
            OffsetCounterY = 0
            AddtoUserPos.y = 0
        End If
    End If
    
    If Chkflag = 3 Then
        If frmMain.WindowState <> 1 Then Call CheckKeys
        Call RenderScreen(UserPos.X - AddtoUserPos.X, UserPos.y - AddtoUserPos.y, OffsetCounterX, OffsetCounterY)
        modDirectDraw.DrawText 260, 260, "X: " & UserPos.X & " - Y: " & UserPos.y, vbWhite
        Call DrawBackBufferSurface 'Draw to the screen!
        
        Chkflag = 0
    End If
    
    Chkflag = Chkflag + 1
    
    If CurrentGrh.GrhIndex = 0 Then
        InitGrh CurrentGrh, 1
    End If
    If bRefreshRadar = True Then
        Call RefreshAllChars
        bRefreshRadar = False
    End If
    If frmMain.PreviewGrh.Visible = True Then
        Call modPaneles.VistaPreviaDeSup
    End If
    DoEvents
    'Sleep 1
Loop
    
If MapInfo.Changed = 1 Then
    If MsgBox(MSGMod, vbExclamation + vbYesNo) = vbYes Then
        modMapIO.GuardarMapa frmMain.Dialog.FileName
    End If
End If

DeInitTileEngine
LiberarDirectSound
Dim f
For Each f In Forms
    Unload f
Next
End

End Sub

Public Function GetVar(File As String, Main As String, Var As String) As String
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************
Dim L As Integer
Dim Char As String
Dim sSpaces As String ' This will hold the input that the program will retrieve
Dim szReturn As String ' This will be the defaul value if the string is not found
szReturn = vbNullString
sSpaces = Space(5000) ' This tells the computer how long the longest string can be. If you want, you can change the number 75 to any number you wish
GetPrivateProfileString Main, Var, szReturn, sSpaces, Len(sSpaces), File
GetVar = RTrim(sSpaces)
GetVar = Left(GetVar, Len(GetVar) - 1)
End Function

Public Sub WriteVar(File As String, Main As String, Var As String, value As String)
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************
writeprivateprofilestring Main, Var, value, File
End Sub

Public Sub ToggleWalkMode()
'*************************************************
'Author: Unkwown
'Last modified: 28/05/06 - GS
'*************************************************
On Error GoTo fin:
If WalkMode = False Then
    WalkMode = True
Else
    frmMain.mnuModoCaminata.Checked = False
    WalkMode = False
End If

If WalkMode = False Then
    'Erase character
    Call EraseChar(UserCharIndex)
    MapData(UserPos.X, UserPos.y).CharIndex = 0
Else
    'MakeCharacter
    If LegalPos(UserPos.X, UserPos.y) Then
        Call MakeChar(NextOpenChar(), 1, 1, SOUTH, UserPos.X, UserPos.y)
        UserCharIndex = MapData(UserPos.X, UserPos.y).CharIndex
        frmMain.mnuModoCaminata.Checked = True
    Else
        MsgBox "ERROR: Ubicacion ilegal."
        WalkMode = False
    End If
End If
fin:
End Sub

Public Sub FixCoasts(ByVal GrhIndex As Integer, ByVal X As Integer, ByVal y As Integer)
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************

If GrhIndex = 7284 Or GrhIndex = 7290 Or GrhIndex = 7291 Or GrhIndex = 7297 Or _
   GrhIndex = 7300 Or GrhIndex = 7301 Or GrhIndex = 7302 Or GrhIndex = 7303 Or _
   GrhIndex = 7304 Or GrhIndex = 7306 Or GrhIndex = 7308 Or GrhIndex = 7310 Or _
   GrhIndex = 7311 Or GrhIndex = 7313 Or GrhIndex = 7314 Or GrhIndex = 7315 Or _
   GrhIndex = 7316 Or GrhIndex = 7317 Or GrhIndex = 7319 Or GrhIndex = 7321 Or _
   GrhIndex = 7325 Or GrhIndex = 7326 Or GrhIndex = 7327 Or GrhIndex = 7328 Or GrhIndex = 7332 Or _
   GrhIndex = 7338 Or GrhIndex = 7339 Or GrhIndex = 7345 Or GrhIndex = 7348 Or _
   GrhIndex = 7349 Or GrhIndex = 7350 Or GrhIndex = 7351 Or GrhIndex = 7352 Or _
   GrhIndex = 7349 Or GrhIndex = 7350 Or GrhIndex = 7351 Or _
   GrhIndex = 7354 Or GrhIndex = 7357 Or GrhIndex = 7358 Or GrhIndex = 7360 Or _
   GrhIndex = 7362 Or GrhIndex = 7363 Or GrhIndex = 7365 Or GrhIndex = 7366 Or _
   GrhIndex = 7367 Or GrhIndex = 7368 Or GrhIndex = 7369 Or GrhIndex = 7371 Or _
   GrhIndex = 7373 Or GrhIndex = 7375 Or GrhIndex = 7376 Then MapData(X, y).Graphic(2).GrhIndex = 0

End Sub

Public Function RandomNumber(ByVal LowerBound As Variant, ByVal UpperBound As Variant) As Single
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************
Randomize Timer
RandomNumber = (UpperBound - LowerBound + 1) * Rnd + LowerBound
End Function


''
' Actualiza todos los Chars en el mapa
'

Public Sub RefreshAllChars()
'*************************************************
'Author: ^[GS]^
'Last modified: 28/05/06
'*************************************************
On Error Resume Next
Dim loopc As Integer
frmMain.ApuntadorRadar.Move UserPos.X - 12, UserPos.y - 10
frmMain.picRadar.Cls
For loopc = 1 To LastChar
    If CharList(loopc).Active = 1 Then
        MapData(CharList(loopc).Pos.X, CharList(loopc).Pos.y).CharIndex = loopc
        If CharList(loopc).Heading <> 0 Then
            frmMain.picRadar.ForeColor = vbGreen
            frmMain.picRadar.Line (0 + CharList(loopc).Pos.X, 0 + CharList(loopc).Pos.y)-(2 + CharList(loopc).Pos.X, 0 + CharList(loopc).Pos.y)
            frmMain.picRadar.Line (0 + CharList(loopc).Pos.X, 1 + CharList(loopc).Pos.y)-(2 + CharList(loopc).Pos.X, 1 + CharList(loopc).Pos.y)
        End If
    End If
Next loopc
bRefreshRadar = False
End Sub


''
' Actualiza el Caption del menu principal
'
' @param Trabajando Indica el path del mapa con el que se esta trabajando
' @param Editado Indica si el mapa esta editado

Public Sub CaptionWorldEditor(ByVal Trabajando As String, ByVal Editado As Boolean)
'*************************************************
'Author: ^[GS]^
'Last modified: 20/05/06
'*************************************************
If Trabajando = vbNullString Then
    Trabajando = "Nuevo Mapa"
End If
frmMain.Caption = "WorldEditor v" & App.Major & "." & App.Minor & " Build " & App.Revision & " - [" & Trabajando & "]"
If Editado = True Then
    frmMain.Caption = frmMain.Caption & " (modificado)"
End If
End Sub

Private Sub LoadClientSetup()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 26/05/2006
'26/05/2005 - GS . DirIndex
'**************************************************************
    Dim fHandle As Integer
    
    fHandle = FreeFile
    Open DirIndex & "ao.dat" For Binary Access Read Lock Write As fHandle
        Get fHandle, , ClientSetup
    Close fHandle

End Sub
