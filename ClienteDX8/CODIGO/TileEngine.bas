Attribute VB_Name = "modTileEngine"
'Argentum Online 0.11.6
'
'Copyright (C) 2002 Márquez Pablo Ignacio
'Copyright (C) 2002 Otto Perez
'Copyright (C) 2002 Aaron Perkins
'Copyright (C) 2002 Matías Fernando Pequeño
'
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'
'
'You can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'Calle 3 número 983 piso 7 dto A
'La Plata - Pcia, Buenos Aires - Republica Argentina
'Código Postal 1900
'Pablo Ignacio Márquez



Option Explicit

'Map sizes in tiles
Public Const XMinMapSize As Byte = 1
Public Const YMinMapSize As Byte = 1

Private Const GrhFogata As Integer = 1521

''
'Sets a Grh animation to loop indefinitely.
Private Const INFINITE_LOOPS As Integer = -1



'Posicion en el Mundo
Public Type WorldPos
    map As Integer
    x As Integer
    y As Integer
End Type

'Contiene info acerca de donde se puede encontrar un grh tamaño y animacion





'Lista de cuerpos
Public Type BodyData
    Walk(E_Heading.north To E_Heading.west) As Grh
    HeadOffset As Position
End Type

'Lista de cabezas
Public Type HeadData
    Head(E_Heading.north To E_Heading.west) As Grh
End Type

'Lista de las animaciones de las armas
Type WeaponAnimData
    WeaponWalk(E_Heading.north To E_Heading.west) As Grh
End Type

'Lista de las animaciones de los escudos
Type ShieldAnimData
    ShieldWalk(E_Heading.north To E_Heading.west) As Grh
End Type


'Apariencia del personaje
Public Type char
    active As Byte
    Heading As E_Heading

    alpha As Single
    alphacounter As Single
    
    'sangre_fx As Integer
    
    color As Long
    
    alpha_sentido As Boolean
    
    scrollDirectionX As Integer
    scrollDirectionY As Integer
    

    
    pie As Boolean
    muerto As Boolean
    invisible As Boolean
    priv As Byte
    
    MANp As Byte
    VIDp As Byte
    Barras As Boolean
    
    iHead As Integer
    iBody As Integer
    Body As BodyData
    Head As HeadData
    Casco As HeadData
    arma As WeaponAnimData
    Escudo As ShieldAnimData
    UsandoArma As Boolean
    
    hit_color As Long
    
    hit As Integer
    hit_act As Byte
    hit_off As Single
    
    fx As Grh
    FxIndex As Integer
    
    colorz As RGBCOLOR
    
    Criminal As Byte
    
    Nombre As String
    
    Pos As Position
    mppos As Position
    
    Moving As Byte
    MoveOffsetX As Single
    MoveOffsetY As Single
    
    Particle_group(0 To 1) As Integer
    
    luz As Integer
    
    velocidad As Position
    
    spd As D3DVECTOR2
    ace As D3DVECTOR2
    vec As D3DVECTOR2
    do_onda As Byte
    
    DirY As Integer
    OffY As Single
    old_alt As Byte
    
    attaking As Byte
    invh As Byte
    invheading As E_Heading
    
    center_text As Integer
    
    rcrc As Long
    
    armaz(0 To 1) As Arma_act
End Type

'Info de un objeto
Public Type obj
    OBJIndex As Integer
    Amount As Integer
End Type

Public Type webpj
    ID          As Long
    name        As String
    clan        As String
    vidaup      As Integer
    raza        As eRaza
    clase       As eClass
    genero      As eGenero
    Faccion     As Integer
    items(20)   As Integer
    items_count As Integer
    
    Body As BodyData
    Head As HeadData
    Casco As HeadData
    arma As WeaponAnimData
    Escudo As ShieldAnimData
End Type

Public web_pjs(10) As webpj
Public web_pjs_count As Byte

Public IniPath As String
Public MapPath As String


'Status del user
Public CurMap As Integer 'Mapa actual
Public UserIndex As Integer
Public UserMoving As Byte
Public UserDirection As Byte
Public UserBody As Integer
Public UserHead As Integer
Public UserPos As Position ',Position 'Posicion
Public AddtoUserPos As Position ', Position 'Si se mueve
Public AddtoUserPosO As Position ',Position 'Si se mueve
Public UserCharIndex As Integer

Public EngineRun As Boolean

Public FPS As Long
Public FramesPerSecCounter As Long


'Cuantos tiles el engine mete en el BUFFER cuando
'dibuja el mapa. Ojo un tamaño muy grande puede
'volver el engine muy lento
Public TileBufferSizeX As Integer
Public TileBufferSizeY As Integer


'Tamaño de los tiles en pixels
Public TilePixelHeight As Integer
Public TilePixelWidth As Integer

'Number of pixels the engine scrolls per frame. MUST divide evenly into pixels per tile



Public NumBodies As Integer
Public Numheads As Integer
Public NumFxs As Integer

Public NumChars As Integer
Public LastChar As Integer
Public NumWeaponAnims As Integer
Public NumShieldAnims As Integer


'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Graficos¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

Public BodyData() As BodyData
Public HeadData() As HeadData
Public FxData() As tIndiceFx
Public WeaponAnimData() As WeaponAnimData
Public ShieldAnimData() As ShieldAnimData
Public CascoAnimData() As HeadData
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Mapa?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

Public bRain        As Boolean 'está raineando?
Public bTecho       As Boolean 'hay techo?
Public brstTick     As Long

Private RLluvia(7)  As RECT  'RECT de la lluvia
Private iFrameIndex As Byte  'Frame actual de la LL
Private llTick      As Long  'Contador
Private LTLluvia(4) As Integer

Public charlist(1 To 255) As char

' Used by GetTextExtentPoint32
Private Type size
    cX As Long
    cY As Long
End Type

'[CODE 001]:MatuX
Public Enum PlayLoop
    plNone = 0
    plLluviain = 1
    plLluviaout = 2
End Enum
'[END]'
'
'       [END]
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

'Very percise counter 64bit system counter
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

'Text width computation. Needed to center text.
Private Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hDC As Long, ByVal lpsz As String, ByVal cbString As Long, lpSize As size) As Long

#Const HARDCODEO = 1

'Public SangreFX As New clsSangre




'
'Sub CargarArrayLluvia()
'    Dim n As Integer
'    Dim i As Long
'    Dim Nu As Integer
'
'    n = FreeFile()
'    Open app.path & "\Datos\fk.ind" For Binary Access Read As #n
'
'    'cabecera
'    Get #n, , MiCabecera
'
'    'num de cabezas
'    Get #n, , Nu
'
'    'Resize array
'    ReDim bLluvia(1 To Nu) As Byte
'
'    For i = 1 To Nu
'        Get #n, , bLluvia(i)
'    Next i
'
'    Close #n
'End Sub

Sub ConvertCPtoTP(ByVal viewPortX As Integer, ByVal viewPortY As Integer, ByRef tX As Byte, ByRef tY As Byte)
'******************************************
'Converts where the mouse is in the main window to a tile position. MUST be called eveytime the mouse moves.
'******************************************
Dim tax%, tay%
tX = Abs(UserPos.x + (viewPortX - 16) / 32 - frmMain.renderer.ScaleWidth \ 64)
tY = Abs(UserPos.y + (viewPortY - 16) / 32 - frmMain.renderer.ScaleHeight \ 64)
'    Debug.Print tX; tY
End Sub

Sub MakeChar(ByVal CharIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, ByVal x As Integer, ByVal y As Integer, ByVal arma As Integer, ByVal Escudo As Integer, ByVal Casco As Integer)
On Error Resume Next
    'Apuntamos al ultimo Char
    If CharIndex > LastChar Then LastChar = CharIndex
    
    With charlist(CharIndex)
        'If the char wasn't allready active (we are rewritting it) don't increase char count
        If .active = 0 Then _
            NumChars = NumChars + 1
        
        If arma = 0 Then arma = 2
        If Escudo = 0 Then Escudo = 2
        If Casco = 0 Then Casco = 2
        
        .iHead = Head
        .iBody = Body
        .Head = HeadData(Head)
        .Body = BodyData(Body)
        .arma = WeaponAnimData(arma)
        .armaz(0).num = arma
        .muerto = (Head = 500 Or Head = 501)
        .Escudo = ShieldAnimData(Escudo)
        .Casco = CascoAnimData(Casco)
        If Heading = 0 Then Heading = E_Heading.south
        .Heading = Heading
        .invheading = .Heading
        If .invh Then
            If .Heading = E_Heading.east Then
                .invheading = E_Heading.west
            ElseIf .Heading = E_Heading.west Then
                .invheading = E_Heading.east
            End If
        End If
        'Reset moving stats
        .Moving = 0
        .MoveOffsetX = 0
        .MoveOffsetY = 0
        
        'Update position
        .Pos.x = x
        .Pos.y = y
        
        'Make active
        .active = 1
    End With
    
    'Plot on map
    charmap(x, y) = CharIndex
    Map_render_2array
End Sub

Sub MakeAccPJ(ByVal Index As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal arma As Integer, ByVal Escudo As Integer, ByVal Casco As Integer)
On Error Resume Next
    With web_pjs(Index)
        If arma = 0 Then arma = 2
        If Escudo = 0 Then Escudo = 2
        If Casco = 0 Then Casco = 2
        .Head = HeadData(Head)
        .Body = BodyData(Body)
        .arma = WeaponAnimData(arma)
        
        .Escudo = ShieldAnimData(Escudo)
        .Casco = CascoAnimData(Casco)
    End With
End Sub

Sub ResetCharInfo(ByVal CharIndex As Integer)
    With charlist(CharIndex)
        .active = 0
        .Criminal = 0
        .FxIndex = 0
        .invisible = False
        
#If SeguridadAlkon Then
        Call MI(CualMI).ResetInvisible(CharIndex)
#End If
        
        .Moving = 0
        .muerto = False
        
        .Nombre = ""
        .center_text = 0
        .pie = False
        .Pos.x = 0
        .Pos.y = 0
        .UsandoArma = False
    End With
End Sub



Public Sub InitGrh(ByRef Grh As Grh, ByVal GrhIndex As Integer, Optional ByVal Started As Byte = 2)
'*****************************************************************
'Sets up a grh. MUST be done before rendering
'*****************************************************************
If GrhIndex = 0 Then Exit Sub
    Grh.GrhIndex = GrhIndex
    
    If Started = 2 Then
        If GrhData(Grh.GrhIndex).NumFrames > 1 Then
            Grh.Started = 1
        Else
            Grh.Started = 0
        End If
    Else
        'Make sure the graphic can be started
        If GrhData(Grh.GrhIndex).NumFrames = 1 Then Started = 0
        Grh.Started = Started
    End If
    
    
    If Grh.Started Then
        Grh.Loops = INFINITE_LOOPS
    Else
        Grh.Loops = 0
    End If
    
    Grh.FrameCounter = 1
    Grh.speed = GrhData(Grh.GrhIndex).speed
End Sub
'


Public Sub DoFogataFx()
    Dim location As Position
    

End Sub

Public Function EstaPCareVec(ByVal x As Byte, ByVal y As Byte) As Boolean
    EstaPCareVec = x > UserPos.x - MinXBorder And x < UserPos.x + MinXBorder And y > UserPos.y - MinYBorder And y < UserPos.y + MinYBorder
End Function

Private Function EstaPCarea(ByVal CharIndex As Integer) As Boolean
    With charlist(CharIndex).Pos
        EstaPCarea = .x > UserPos.x - MinXBorder And .x < UserPos.x + MinXBorder And .y > UserPos.y - MinYBorder And .y < UserPos.y + MinYBorder
    End With
End Function

'Sub DoPasosFx(ByVal CharIndex As Integer)
'    If Not UserNavegando Then
'        With charlist(CharIndex)
'            If Not .muerto And EstaPCarea(CharIndex) Then
'                .pie = Not .pie
'
'                If .pie Then
'                    Call Audio.Sound_Play(SND_PASOS1, .Pos.X, .Pos.y)
'                Else
'                    Call Audio.Sound_Play(SND_PASOS2, .Pos.X, .Pos.y)
'                End If
'            End If
'        End With
'    Else
'' TODO : Actually we would have to check if the CharIndex char is in the water or not....
'        Call Audio.Sound_Play(SND_NAVEGANDO, charlist(CharIndex).Pos.X, charlist(CharIndex).Pos.y)
'    End If
'End Sub

Sub DoPasosFx(ByVal CharIndex As Integer)
If Not UserNavegando Then
    With charlist(CharIndex)
        If Not .muerto And EstaPCarea(CharIndex) Then
            .pie = Not .pie
            If MapData(.Pos.x, .Pos.y).Graphic(1).GrhIndex >= 6000 And MapData(.Pos.x, .Pos.y).Graphic(1).GrhIndex <= 6559 Then
                If .pie Then
                    Call Audio.Sound_Play(SND_PASOS3)
                Else
                    Call Audio.Sound_Play(SND_PASOS4)
                End If
            Else
                If .pie Then
                    Call Audio.Sound_Play(SND_PASOS1)
                Else
                    Call Audio.Sound_Play(SND_PASOS2)
                End If
            End If
        End If
    End With
Else
' TODO : Actually we would have to check if the CharIndex char is in the water or not....
Call Audio.Sound_Play(SND_NAVEGANDO, charlist(CharIndex).Pos.x, charlist(CharIndex).Pos.y)
End If
End Sub

'Sub MoveCharbyPos(ByVal CharIndex As Integer, ByVal nX As Integer, ByVal nY As Integer)
'On Error Resume Next
'    Dim x As Integer
'    Dim y As Integer
'    Dim addx As Integer
'    Dim addy As Integer
'    Dim nHeading As E_Heading
'
'    With charlist(CharIndex)
'        x = .pos.x
'        y = .pos.y
'
'        MapData(x, y).CharIndex = 0
'
'        addx = nX - x
'        addy = nY - y
'
'        If Sgn(addx) = 1 Then
'            nHeading = E_Heading.EAST
'        End If
'
'        If Sgn(addx) = -1 Then
'            nHeading = E_Heading.WEST
'        End If
'
'        If Sgn(addy) = -1 Then
'            nHeading = E_Heading.NORTH
'        End If
'
'        If Sgn(addy) = 1 Then
'            nHeading = E_Heading.SOUTH
'        End If
'
'        MapData(nX, nY).CharIndex = CharIndex
'
'
'        .pos.x = nX
'        .pos.y = nY
'
'        .MoveOffsetX = -1 * (TilePixelWidth * addx)
'        .MoveOffsetY = -1 * (TilePixelHeight * addy)
'
'        .Moving = 1
'        .Heading = nHeading
'        .invheading = .Heading
'        If .invh Then
'            If .Heading = E_Heading.EAST Then
'                .invheading = E_Heading.WEST
'            ElseIf .Heading = E_Heading.WEST Then
'                .invheading = E_Heading.EAST
'            End If
'        End If
'        .scrollDirectionX = Sgn(addx)
'        .scrollDirectionY = Sgn(addy)
'
'        'parche para que no medite cuando camina
'        If .FxIndex = FxMeditar.CHICO Or .FxIndex = FxMeditar.GRANDE Or .FxIndex = FxMeditar.MEDIANO Or .FxIndex = FxMeditar.XGRANDE Or .FxIndex = FxMeditar.XXGRANDE Then
'            .FxIndex = 0
'        End If
'    End With
'
'    If Not EstaPCarea(CharIndex) Then
'    Call Dialogos.RemoveDialog(CharIndex)
'    charlist(CharIndex).hit_act = 0
'    End If
'    If (nY < MinLimiteY) Or (nY > MaxLimiteY) Or (nX < MinLimiteX) Or (nX > MaxLimiteX) Then
'        Call EraseChar(CharIndex)
'    End If
'End Sub
'


Public Function HayFogata(ByRef location As Position) As Boolean
    Dim j As Long
    Dim k As Long
    
    For j = UserPos.x - 8 To UserPos.x + 8
        For k = UserPos.y - 6 To UserPos.y + 6
            If InMapBounds(j, k) Then
                If MapData(j, k).ObjGrh.GrhIndex = GrhFogata Then
                    location.x = j
                    location.y = k
                    
                    HayFogata = True
                    Exit Function
                End If
            End If
        Next k
    Next j
End Function
Public Function HayFogata1(ByRef x As Integer, ByRef y As Integer) As Boolean
    Dim j As Long
    Dim k As Long
    
    For j = UserPos.x - 10 To UserPos.x + 10
        For k = UserPos.y - 10 To UserPos.y + 10
            If InMapBounds(j, k) Then
                If MapData(j, k).ObjGrh.GrhIndex = GrhFogata Then
                    x = j
                    y = k
                    HayFogata1 = True
                    Exit Function
                End If
            End If
        Next k
    Next j
End Function
Function NextOpenChar() As Integer
'*****************************************************************
'Finds next open char slot in CharList
'*****************************************************************
    Dim loopc As Long
    Dim Dale As Boolean
    
    loopc = 1
    Do While charlist(loopc).active And Dale
        loopc = loopc + 1
        Dale = (loopc <= UBound(charlist))
    Loop
    
    NextOpenChar = loopc
End Function

''
' Loads grh data using the new file format.
'
' @return   True if the load was successfull, False otherwise.



Public Function RenderSounds()

    DoFogataFx
End Function

Function HayUserAbajo(ByVal x As Integer, ByVal y As Integer, ByVal GrhIndex As Integer) As Boolean
    If GrhIndex > 0 Then
        HayUserAbajo = _
            charlist(UserCharIndex).Pos.x >= x - (GrhData(GrhIndex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.x <= x + (GrhData(GrhIndex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.y >= y - (GrhData(GrhIndex).TileHeight - 1) _
                And charlist(UserCharIndex).Pos.y <= y
    End If
End Function

Sub LoadGraphics()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero - complete rewrite
'Last Modify Date: 11/03/2006
'Initializes the SurfaceDB and sets up the rain rects
'**************************************************************
    'New surface manager :D
    On Error GoTo eroraro
    RLluvia(0).Top = 0:      RLluvia(1).Top = 0:      RLluvia(2).Top = 0:      RLluvia(3).Top = 0
    RLluvia(0).Left = 0:     RLluvia(1).Left = 128:   RLluvia(2).Left = 256:   RLluvia(3).Left = 384
    RLluvia(0).Right = 128:  RLluvia(1).Right = 256:  RLluvia(2).Right = 384:  RLluvia(3).Right = 512
    RLluvia(0).Bottom = 128: RLluvia(1).Bottom = 128: RLluvia(2).Bottom = 128: RLluvia(3).Bottom = 128
    
    RLluvia(4).Top = 128:    RLluvia(5).Top = 128:    RLluvia(6).Top = 128:    RLluvia(7).Top = 128
    RLluvia(4).Left = 0:     RLluvia(5).Left = 128:   RLluvia(6).Left = 256:   RLluvia(7).Left = 384
    RLluvia(4).Right = 128:  RLluvia(5).Right = 256:  RLluvia(6).Right = 384:  RLluvia(7).Right = 512
    RLluvia(4).Bottom = 256: RLluvia(5).Bottom = 256: RLluvia(6).Bottom = 256: RLluvia(7).Bottom = 256

    'Set up te rain rects
    Exit Sub
eroraro:

    'Saco esto porque el texto del cargar queda horrible
    'AddtoRichTextBox frmCargando.status, "Hecho.", , , , 1, , False
End Sub
'
'Public Function InitTileEngine(ByVal setDisplayFormhWnd As Long, ByVal setMainViewTop As Integer, ByVal setMainViewLeft As Integer, ByVal setTilePixelHeight As Integer, ByVal setTilePixelWidth As Integer, ByVal setWindowTileHeight As Integer, ByVal setWindowTileWidth As Integer, ByVal setTileBufferSize As Integer, ByVal pixelsToScrollPerFrameX As Integer, pixelsToScrollPerFrameY As Integer, ByVal engineSpeed As Single) As Boolean
'
'    InitTileEngine = True
'End Function
'
Public Sub DeinitTileEngine()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 08/14/07
'Destroys all DX objects
'***************************************************
On Error Resume Next
End Sub


Private Function GetElapsedTime() As Single
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Gets the time that past since the last call
'**************************************************************
    Dim start_time As Currency
    Static end_time As Currency
    Static timer_freq As Currency

    'Get the timer frequency
    If timer_freq = 0 Then
        QueryPerformanceFrequency timer_freq
    End If
    
    'Get current time
    Call QueryPerformanceCounter(start_time)
    
    'Calculate elapsed time
    GetElapsedTime = (start_time - end_time) / timer_freq * 1000
    
    'Get next end time
    Call QueryPerformanceCounter(end_time)
End Function

Public Sub SetCharacterFx(ByVal CharIndex As Integer, ByVal fx As Integer, ByVal Loops As Integer)
    With charlist(CharIndex)
        
        
        If fx > 0 Then
            If FxData(fx).particula = 0 Then
                Call InitGrh(.fx, FxData(fx).Animacion)
                .fx.Loops = Loops
                .FxIndex = fx
                .Particle_group(1) = 0
            End If
            If FxData(fx).wav <> 0 Then Call Audio.Sound_Play(CStr(FxData(fx).wav))
        End If
    End With
End Sub

Function Collision_sRect(ByVal x1 As Integer, ByVal y1 As Integer, ByRef iRect As sRECT) As Boolean
With iRect
    If x1 >= .Left Then
        If x1 <= .Right Then
            If y1 >= .Top Then
                If y1 <= .Bottom Then
                    Collision_sRect = True
                End If
            End If
        End If
    End If
End With
End Function
