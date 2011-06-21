Attribute VB_Name = "Engine_Map"
Option Explicit

Enum layer_type
    layer_2 = 0
    layer_3 = 1
    layer_obj = 3
    layer_char = 4
    layer_roof = 5
    layer_particle = 6
    layer_agua = 7
    layer_terreno = 8
    layer_costa = 9
    layer_flare = 10
End Enum

Public Type tile
    tilex As Byte
    tiley As Byte
    PixelPosX As Single
    PixelPosY As Single
    type As Integer
    ID As Integer
End Type

Public Type TileLayer
    tile(623) As tile
    NumTiles As Integer
End Type

'Tipo de las celdas del mapa
Public Type MapBlock
    Graphic(1 To 4) As Grh
    ObjGrh As Grh
    CharIndex As Integer
    Trigger As Integer
    Particles_groups(0 To 2) As Integer
    light_value(0 To 3) As Long 'Color de luz con el que esta siendo renderizado.
    Blocked As Byte
    tile_orientation As Byte
    tile As Box_Vertex
    tile_texture As Long
    tile_render As Byte
    flare As Byte
    is_water As Byte
    
    luz As Integer
End Type

'Info de cada mapa
Public Type MapInfo
    Music As String
    name As String
    StartPos As WorldPos
    MapVersion As Integer
End Type

Public TileLayer(1 To 5) As TileLayer

Private techo_alpha As Byte

Public MapData()                As MapBlock ' Mapa
Public MapInfo                  As MapInfo ' Info acerca del mapa en uso

Public screenminY               As Integer
Public screenmaxY               As Integer
Public screenminX               As Integer
Public screenmaxX               As Integer
Public minY                     As Integer
Public maxY                     As Integer
Public minX                     As Integer
Public maxX                     As Integer
Public minXOffset               As Integer
Public minYOffset               As Integer
Public tilex                    As Integer
Public tiley                    As Integer
Public add_to_mapY              As Integer

Public ScrollPixelsPerFrameX    As Integer
Public ScrollPixelsPerFrameY    As Integer

Public TileBufferPixelOffsetX   As Integer
Public TileBufferPixelOffsetY   As Integer

Public MinXBorder%, MaxXBorder%, MinYBorder%, MaxYBorder%

Public alpha_racio_luz As Single
Public alpha_neblina_llegar As Single

Private adya As Single

Private Declare Sub ZeroMemory Lib "kernel32" Alias "RtlZeroMemory" (ByRef dest As Any, ByVal numbytes As Long)

Public charmap(1 To MapSize, 1 To MapSize) As Integer

Public Sub Engine_Calc_Screen_Moviment()
    Static rPixelOffsetX    As Single
    Static rPixelOffsetY    As Single
    Static OffxY            As Single

    Dim ScreenX             As Integer  'Keeps track of where to place tile on screen
    Dim ScreenY             As Integer  'Keeps track of where to place tile on screen
    Dim ady As Integer
    If Not (copy_tile_now = 128) Then copy_tile_now = 0
    
    If UserMoving Then
        '****** Move screen Left and Right if needed ******
        If AddtoUserPos.x <> 0 Then
            rPixelOffsetX = rPixelOffsetX - charlist(UserCharIndex).velocidad.x * AddtoUserPos.x * timerTicksPerFrame
            If Abs(rPixelOffsetX) >= Abs(32 * AddtoUserPos.x) Then
                rPixelOffsetX = 0
                AddtoUserPos.x = 0
                UserMoving = 0
            End If
        End If
            
        '****** Move screen Up and Down if needed ******
        
        If AddtoUserPos.y <> 0 Then
            rPixelOffsetY = rPixelOffsetY - charlist(UserCharIndex).velocidad.y * AddtoUserPos.y * timerTicksPerFrame
            If Abs(rPixelOffsetY) >= Abs(32 * AddtoUserPos.y) Then
                rPixelOffsetY = 0
                AddtoUserPos.y = 0
                UserMoving = 0
                
            End If
        End If
        If AddtoUserPos.x = 0 And AddtoUserPos.y = 0 Then
            UserMoving = 0
        End If
        copy_tile_now = 128
    Else
    
        If UserDirection Then MoveTo UserDirection
    End If
    


    offset_screen_old = offset_screen
    offset_screen.y = CInt(rPixelOffsetY + OffxY)
    offset_screen.x = CInt(rPixelOffsetX)
        
    If UserPos.x = 0 Then _
        UserPos.x = 50: _
        UserPos.y = 50
            
    If tiley <> UserPos.y Or tilex <> UserPos.x Then
        copy_tile_now = 128
        user_moved = True
        tiley = UserPos.y - AddtoUserPos.y
        tilex = UserPos.x - AddtoUserPos.x
        ady = OffxY \ 32
        'Figure out Ends and Starts of screen
        screenminY = tiley - HalfWindowTileHeight ' - ady
        screenmaxY = tiley + HalfWindowTileHeight
        screenminX = tilex - HalfWindowTileWidth
        screenmaxX = tilex + HalfWindowTileWidth
        
        minY = screenminY - TileBufferSizeY
        maxY = screenmaxY + TileBufferSizeY
        minX = screenminX - TileBufferSizeX
        maxX = screenmaxX + TileBufferSizeX
        
        'Make sure mins and maxs are allways in map bounds
        If minY < XMinMapSize Then
            'minYOffset = YMinMapSize - minY
            minY = YMinMapSize
        End If
        
        If maxY > MapSize Then maxY = MapSize
        
        If minX < XMinMapSize Then
            'minXOffset = XMinMapSize - minX
            minX = XMinMapSize
        End If
        
        If maxX > MapSize Then maxX = MapSize
        
        'If we can, we render around the view area to make it smoother
        If screenminY > YMinMapSize Then
            screenminY = screenminY - 1
        Else
            screenminY = 1
            ScreenY = 1
        End If
        
        If screenmaxY < MapSize Then screenmaxY = screenmaxY + 1
        
        If screenminX > XMinMapSize Then
            screenminX = screenminX - 1
        Else
            screenminX = 1
            ScreenX = 1
        End If
        
        If screenmaxX < MapSize Then screenmaxX = screenmaxX + 1
        'If minYOffset = 0 Then minYOffset = -ady

        adya = ady
        Map_render_2array adya
    End If
    offset_mapO = offset_map
    offset_map.x = ((-minX - 1) * 32) + offset_screen.x - TileBufferPixelOffsetX
    offset_map.y = ((-minY - 1) * 32) + offset_screen.y - TileBufferPixelOffsetY
    
End Sub

Public Sub clear_map_chars()

End Sub

Public Sub rm2a()
act_charmap
Map_render_2array adya
End Sub

Public Sub Engine_Set_TileBuffer_Size(ByVal sizex As Integer, ByVal sizey As Integer)
    TileBufferSizeX = sizex
    TileBufferSizeY = sizey
    TileBufferPixelOffsetX = (TileBufferSizeX - 1) * TilePixelWidth
    TileBufferPixelOffsetY = (TileBufferSizeY - 1) * TilePixelWidth
End Sub

Public Sub act_charmap()
On Error Resume Next
Dim i As Integer
ZeroMemory charmap(1, 1), 10000
For i = 1 To LastChar
With charlist(i).Pos
If charlist(i).active = 1 Then charmap(.x, .y) = i
End With
Next i
End Sub

Private Sub map_add_tolayer(ByVal Layer As Byte, ByVal tilex As Byte, ByVal tiley As Byte, ByVal PixelOffsetX As Single, ByVal PixelOffsetY As Single, ByVal tipo As layer_type, ByVal ID As Integer)
    TileLayer(Layer).NumTiles = TileLayer(Layer).NumTiles + 1
    With TileLayer(Layer).tile(TileLayer(Layer).NumTiles)
        .type = tipo
        .tilex = tilex
        .tiley = tiley
        .PixelPosX = PixelOffsetX
        .PixelPosY = PixelOffsetY
        .ID = ID
    End With
End Sub


Public Sub Map_render_2array(Optional ByVal offset_y As Single)
cfnc = fnc.E_Map_render_2array
On Error GoTo enda:
    Dim y                       As Integer
    Dim x                       As Integer
    Dim ly                      As Byte
    Dim Layer                   As Byte
    Dim PixelOffsetXTemp        As Single
    Dim PixelOffsetYTemp        As Single
    Dim ScreenX                 As Single
    Dim ScreenY                 As Single
    Dim tmphe%
    Dim tempha%
    
    tmphe = WindowTileHeight
    If minX = 0 Then Exit Sub
    
    For Layer = 1 To 5
        TileLayer(Layer).NumTiles = 0
        'ReDim TileLayer(Layer).tile(1 To ((maxY - minY + 1) * (maxX - minX + 1)))
    Next Layer

    hay_fogata_viewport = False
    tempha = -2 - offset_y * 32
    ScreenY = minYOffset - TileBufferSizeY - offset_y
    For y = minY - offset_y To maxY - offset_y
        ScreenX = minXOffset - TileBufferSizeX
        For x = minX To maxX
        
            PixelOffsetXTemp = ScreenX * 32
            PixelOffsetYTemp = ScreenY * 32
            With MapData(x, y)
                ly = 2
                If .Particles_groups(0) Then
                    map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_particle, MapData(x, y).Particles_groups(0)
                End If
                
                If .ObjGrh.GrhIndex Then
                    map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_obj, 0
'                    If .ObjGrh.GrhIndex = GrhFogata Then
'                        hay_fogata_viewport = True
'                        fogata_pos.x = x
'                        fogata_pos.y = y
'                    End If
                End If
                
                If .Particles_groups(1) Then
                    map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_particle, MapData(x, y).Particles_groups(1)
                End If
                
                If .Graphic(3).GrhIndex Then
                    map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_3, 0
                End If

                If .Particles_groups(2) Then
                    map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_particle, MapData(x, y).Particles_groups(2)
                End If
                
                ly = 3
                If .Graphic(4).GrhIndex Then
                    If techo_alpha Then
                        map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_roof, 0
                    End If

                End If
                    If MapData(x, y).flare Then
                        map_add_tolayer ly, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_flare, 0
                    End If

                If ScreenY > tempha And ScreenX > -2 Then
                    If ScreenY <= tmphe And ScreenX <= WindowTileWidth Then
                        If .Graphic(1).GrhIndex > 1 Then
                            map_add_tolayer 4, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_terreno, 0
                        End If
                        If .Graphic(2).GrhIndex Then
                            map_add_tolayer 1, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_terreno, 0
                        End If
                        If charmap(x, y) Then
                            map_add_tolayer 2, x, y, PixelOffsetXTemp, PixelOffsetYTemp, layer_type.layer_char, charmap(x, y)
                        End If
                    End If
                End If
                
            End With
            ScreenX = ScreenX + 1
        Next x
        ScreenY = ScreenY + 1
    Next y
    
    act_light_map = True
Exit Sub
enda:
If Err.Number = 10 Then
LogError "ERROR 10 EN m2a"
End If
End Sub

Public Sub Map_Render()
cfnc = fnc.E_Map_Render
    Dim CurrentGrhIndex     As Long
    Dim i                   As Integer
    
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
    For i = 1 To TileLayer(4).NumTiles
        With TileLayer(4).tile(i)
                With MapData(.tilex, .tiley).Graphic(1)
                    If .Started = 1 Then
                        .FrameCounter = .FrameCounter + (timerElapsedTime * GrhData(.GrhIndex).NumFrames / .speed)
                        If .FrameCounter > GrhData(.GrhIndex).NumFrames Then
                            .FrameCounter = (.FrameCounter Mod GrhData(.GrhIndex).NumFrames) + 1
                            If .Loops <> -1 Then
                                If .Loops > 0 Then
                                    .Loops = .Loops - 1
                                Else
                                    .Started = 0
                                End If
                            End If
                        End If
                    End If
                    CurrentGrhIndex = GrhData(.GrhIndex).Frames(.FrameCounter)
                End With
                If CurrentGrhIndex > 1 Then
                    Grh_Render_new CurrentGrhIndex, _
                        .PixelPosX + offset_screen.x, .PixelPosY + offset_screen.y, _
                        .tilex, .tiley
                End If

        End With
    Next i
    
    For i = 1 To TileLayer(1).NumTiles
        With TileLayer(1).tile(i)
                    Draw_Grh MapData(.tilex, .tiley).Graphic(2), _
                            .PixelPosX + offset_screen.x, .PixelPosY + offset_screen.y, 1, 1, _
                            .tilex, .tiley
        End With
    Next i
    copy_tile_now = 0

    For i = 1 To TileLayer(2).NumTiles
        With TileLayer(2).tile(i)
            If .type = layer_type.layer_obj Then
                If MapData(.tilex, .tiley).ObjGrh.GrhIndex <> 0 Then _
                    Call Draw_Grh(MapData(.tilex, .tiley).ObjGrh, _
                                .PixelPosX + offset_screen.x, .PixelPosY + offset_screen.y, 1, 1, .tilex, .tiley, 1)
            ElseIf .type = layer_type.layer_char Then
                Call Char_Render(.ID)
            Else
                Call Draw_Grh(MapData(.tilex, .tiley).Graphic(3), _
                            .PixelPosX + offset_screen.x, .PixelPosY + offset_screen.y, 1, 1, .tilex, .tiley)

            End If
        End With
    Next i
    
    For i = 1 To TileLayer(3).NumTiles
        With TileLayer(3).tile(i)

            If .type = layer_type.layer_roof Then
                If techo_alpha <> 0 Then
                    Call Draw_Grh_Alpha(MapData(.tilex, .tiley).Graphic(4), _
                        .PixelPosX + offset_screen.x, _
                        .PixelPosY + offset_screen.y, _
                        1, 1, techo_alpha, , , , 1)
                End If
            ElseIf .type = layer_type.layer_flare Then
                Grh_Render_Simple_box 9730, .PixelPosX + offset_screen.x - 64, .PixelPosY + offset_screen.y - 64, &H3FFFFFFF, 128, 255
            End If

        End With
    Next i
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_DISABLE)


    
    On Local Error Resume Next
        Dim tsa As Single
        
        tsa = Engine.timerElapsedTime * 0.5
        
        If tsa < Epsilon Then tsa = Epsilon
        
        If Render_Radio_Luz Or useRDL Then
            If alpha_racio_luz < 200 Then alpha_racio_luz = alpha_racio_luz + tsa
        Else
            If alpha_racio_luz > 0 Then alpha_racio_luz = alpha_racio_luz - tsa
        End If
        
        If alpha_racio_luz > 200 Then alpha_racio_luz = 200
        If alpha_racio_luz < 0 Then alpha_racio_luz = 0
        
        If alpha_racio_luz > 0 Then
            Dim cc As Long
            cc = D3DColorARGB(alpha_racio_luz, 0, 0, 0)
            Grh_Render_Simple_box 7535, 16!, -50!, cc, 512!
            Engine.Draw_FilledBox 0, 0, 16, frmMain.renderer.height, cc, 0, 0
            Engine.Draw_FilledBox 528, 0, 17, frmMain.renderer.height, cc, 0, 0
        End If
    On Local Error GoTo 0
    
    
    If bTecho Then
        If techo_alpha > 3 Then _
            techo_alpha = techo_alpha - 4
    Else
        If techo_alpha < 251 Then _
            techo_alpha = techo_alpha + 4
    End If

    If UserMoving = 0 Then If UserDirection Then MoveTo UserDirection

End Sub

