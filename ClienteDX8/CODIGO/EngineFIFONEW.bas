Attribute VB_Name = "Engine_FIFO"
'                  ____________________________________________
'                 /_____/  http://www.arduz.com.ar/ao/   \_____\
'                //            ____   ____   _    _ _____      \\
'               //       /\   |  __ \|  __ \| |  | |___  /      \\
'              //       /  \  | |__) | |  | | |  | |  / /        \\
'             //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
'            //       / ____ \| | \ \| |__| | |__| |/ /__          \\
'           / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
'           \________________________________________________________/

Option Explicit


Public Type map_corners
    Left As Integer
    Top As Integer
    Right As Integer
    Bottom As Integer
End Type

Public Corners As map_corners

Public ClaveSeguridadMapa As Long

Sub SwitchMap(ByVal map As Integer)
'Dim mapa() As Byte ' no se usa
'modZLib.Bin_Resource_Get map, mapa(), rMapas
map_load_from app.Path & "\Datos\mapas\" & map & ".am", 1, map
End Sub

Sub map_load_from(ByRef Path As String, ByVal offset As Long, ByVal map As Integer)
funcion_actual = fnc.E_LOADMAP
    Dim y As Long
    Dim x As Long
    Dim TempInt As Integer
    Dim tmpp%
    
    Dim ByFlags As Integer
    
    Dim Handle As Integer
    Dim tluz As RGBCOLOR 'tluz(0 To 3) As RGBCOLOR
    Dim tmult As Byte 'tmult(0 To 3) As Byte
    Handle = FreeFile()
    Dim nmapa As String * 32
    Dim nmap As String
    Dim cript As Byte
    
    Dim alta As Byte
    Dim plusa As Byte
    Dim tt!
    
    Dim TempLong As Long
    Dim h_d As String * 16
    h_d = Space$(16)
    
    Open Path For Binary As Handle

    Engine_Landscape.Light_Remove_All

    FX_Projectile_Erase_All
    FX_Rayo_Erase_All
    FX_Hit_Erase_All
    
    Seek Handle, offset

    'map Header
    Get Handle, , h_d
    Get Handle, , cript
    Get Handle, , nmapa
    
    nmap = Trim$(encode_decode_text(nmapa, 108, cript Xor 108))
    If Not Len(nmap) > 0 Then nmap = "Sin nombre"
    
    Get Handle, , TempInt
    Get Handle, , TempInt
    Get Handle, , TempInt
    Get Handle, , TempInt
    
    Get Handle, , TempLong
    Get Handle, , TempLong
    Get Handle, , ClaveSeguridadMapa
    
    For y = YMinMapSize To MapSize
        For x = XMinMapSize To MapSize
            Get Handle, , ByFlags
            
            Get Handle, , TempLong
            
            MapData(x, y).Blocked = (ByFlags And 1)
            
            If ByFlags And 2048 Then
                Get Handle, , MapData(x, y).Graphic(1).GrhIndex
                InitGrh MapData(x, y).Graphic(1), MapData(x, y).Graphic(1).GrhIndex
            Else
                MapData(x, y).Graphic(1).GrhIndex = 0
            End If
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get Handle, , MapData(x, y).Graphic(2).GrhIndex
                InitGrh MapData(x, y).Graphic(2), MapData(x, y).Graphic(2).GrhIndex
            Else
                MapData(x, y).Graphic(2).GrhIndex = 0
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get Handle, , MapData(x, y).Graphic(3).GrhIndex
                InitGrh MapData(x, y).Graphic(3), MapData(x, y).Graphic(3).GrhIndex
            Else
                MapData(x, y).Graphic(3).GrhIndex = 0
            End If
                
            'Layer 4 used?
            If ByFlags And 8 Then
                Get Handle, , MapData(x, y).Graphic(4).GrhIndex
                InitGrh MapData(x, y).Graphic(4), MapData(x, y).Graphic(4).GrhIndex
            Else
                MapData(x, y).Graphic(4).GrhIndex = 0
            End If
            
            
            If ByFlags And 32 Then

            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get Handle, , MapData(x, y).Trigger
            Else
                MapData(x, y).Trigger = 0
            End If
            

            If ByFlags And 256 Then
                Get Handle, , TempInt
                Get Handle, , TempInt
                Get Handle, , TempInt
            End If

            If ByFlags And 512 Then
                Get Handle, , TempInt
            End If

            If ByFlags And 1024 Then
                Get Handle, , TempInt
                Get Handle, , TempInt
            End If

            
            'Erase NPCs
            If charmap(x, y) > 0 Then
                tt = charmap(x, y)
                Call EraseChar(tt)
                charmap(x, y) = 0
            End If
            
            'Erase OBJs
            
            'MapData(x, y).sangre_fx = 0
            MapData(x, y).ObjGrh.GrhIndex = 0
            
            
            'AGUA MOVIMIENTO
            
            MapData(x, y).is_water = 0
            MapData(x, y).is_water = HayAgua(x, y)

            '/AGUA MOVIMIENTO
        Next x
    Next y
    
    'Call DXCopyMemory(cColorDataORIGINAL(1, 1), cColorData(1, 1), Len(cColorData(1, 1)) * 100& * 100&)

    
    CurMap = map
    
    Close Handle
    
    
    MapInfo.name = ""
    MapInfo.Music = ""
    
funcion_actual = 0
'End If
End Sub

'Sub map_load_from(ByRef Path As String, ByVal offset As Long, ByVal Tamaño As Long, ByVal map As Integer)
'funcion_actual = fnc.E_LOADMAP
'    Dim y As Long
'    Dim x As Long
'    Dim TempInt As Integer
'    Dim tmpp As Integer
'
'    Dim ByFlags As Integer
'
'    Dim Handle As Integer
'    Dim tluz As RGBCOLOR 'tluz(0 To 3) As RGBCOLOR
'    Dim tmult As Byte 'tmult(0 To 3) As Byte
'    Handle = FreeFile()
'    Dim nmapa As String * 32
'    Dim nmap As String
'    Dim cript As Byte
'
'    Dim alta As Byte
'    Dim plusa As Byte
'    Dim tt As Single
'
'    Dim TempLong As Long
'    Dim h_d As String * 16
'    h_d = Space$(16)
'
'    Dim Buffer() As Byte
'    ReDim Buffer(Tamaño)
'    Open Path For Binary As Handle
'        Seek Handle, offset
'        Get Handle, , Buffer
'    Close Handle
'
'    Engine_Landscape.Light_Remove_All
'
'    FX_Projectile_Erase_All
'    FX_Rayo_Erase_All
'    FX_Hit_Erase_All
'
'    Dim Point As Long
'    Point = 0
'
'    'map Header
'    CopyMemory h_d, Buffer(Point), 16: Point = Point + 16 ' Get Handle, , h_d
'    CopyMemory cript, Buffer(Point), 1: Point = Point + 1 ' Get Handle, , cript
'    CopyMemory nmapa, Buffer(Point), 32: Point = Point + 32 ' Get Handle, , nmapa
'
'    nmap = Trim$(encode_decode_text(nmapa, 108, cript Xor 108))
'    If Not Len(nmap) > 0 Then nmap = "Sin nombre"
'
'    CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'    CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'    CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'    CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'
'    CopyMemory TempLong, Buffer(Point), 4: Point = Point + 4 ' Get Handle, , TempLong
'    CopyMemory TempLong, Buffer(Point), 4: Point = Point + 4 ' Get Handle, , TempLong
'    CopyMemory ClaveSeguridadMapa, Buffer(Point), Len(ClaveSeguridadMapa): Point = Point + Len(ClaveSeguridadMapa) ' Get Handle, , ClaveSeguridadMapa
'
'    For y = YMinMapSize To MapSize
'        For x = XMinMapSize To MapSize
'            CopyMemory ByFlags, Buffer(Point), 2: Point = Point + 2 'Get Handle, , ByFlags
'
'            CopyMemory TempLong, Buffer(Point), 4: Point = Point + 4 ' Get Handle, , TempLong
'
'            MapData(x, y).Blocked = (ByFlags And 1)
'
'            If ByFlags And 2048 Then
'                CopyMemory MapData(x, y).Graphic(1).GrhIndex, Buffer(Point), Len(MapData(x, y).Graphic(1).GrhIndex): Point = Point + Len(MapData(x, y).Graphic(1).GrhIndex) ''Get Handle, , MapData(x, y).Graphic(1).GrhIndex
'                InitGrh MapData(x, y).Graphic(1), MapData(x, y).Graphic(1).GrhIndex
'            Else
'                MapData(x, y).Graphic(1).GrhIndex = 0
'            End If
'
'            'Layer 2 used?
'            If ByFlags And 2 Then
'                CopyMemory MapData(x, y).Graphic(2).GrhIndex, Buffer(Point), Len(MapData(x, y).Graphic(2).GrhIndex): Point = Point + Len(MapData(x, y).Graphic(2).GrhIndex) ''Get Handle, , MapData(x, y).Graphic(2).GrhIndex
'                InitGrh MapData(x, y).Graphic(2), MapData(x, y).Graphic(2).GrhIndex
'            Else
'                MapData(x, y).Graphic(2).GrhIndex = 0
'            End If
'
'            'Layer 3 used?
'            If ByFlags And 4 Then
'                CopyMemory MapData(x, y).Graphic(3).GrhIndex, Buffer(Point), Len(MapData(x, y).Graphic(3).GrhIndex): Point = Point + Len(MapData(x, y).Graphic(3).GrhIndex) ''Get Handle, , MapData(x, y).Graphic(3).GrhIndex
'                InitGrh MapData(x, y).Graphic(3), MapData(x, y).Graphic(3).GrhIndex
'            Else
'                MapData(x, y).Graphic(3).GrhIndex = 0
'            End If
'
'            'Layer 4 used?
'            If ByFlags And 8 Then
'                CopyMemory MapData(x, y).Graphic(4).GrhIndex, Buffer(Point), Len(MapData(x, y).Graphic(4).GrhIndex): Point = Point + Len(MapData(x, y).Graphic(4).GrhIndex) ''Get Handle, , MapData(x, y).Graphic(4).GrhIndex
'                InitGrh MapData(x, y).Graphic(4), MapData(x, y).Graphic(4).GrhIndex
'            Else
'                MapData(x, y).Graphic(4).GrhIndex = 0
'            End If
'
'
'            If ByFlags And 32 Then
'
'            End If
'
'            'Trigger used?
'            If ByFlags And 16 Then
'                CopyMemory MapData(x, y).Trigger, Buffer(Point), Len(MapData(x, y).Trigger): Point = Point + Len(MapData(x, y).Trigger) ''Get Handle, , MapData(x, y).Trigger
'            Else
'                MapData(x, y).Trigger = 0
'            End If
'
'
'            If ByFlags And 256 Then
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'            End If
'
'            If ByFlags And 512 Then
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'            End If
'
'            If ByFlags And 1024 Then
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'                CopyMemory TempInt, Buffer(Point), 2: Point = Point + 2 ' Get Handle, , TempInt
'            End If
'
'
'            'Erase NPCs
'            If charmap(x, y) > 0 Then
'                tt = charmap(x, y)
'                Call EraseChar(tt)
'                charmap(x, y) = 0
'            End If
'
'            'Erase OBJs
'
'            'MapData(x, y).sangre_fx = 0
'            MapData(x, y).ObjGrh.GrhIndex = 0
'
'
'            'AGUA MOVIMIENTO
'
'            MapData(x, y).is_water = 0
'            MapData(x, y).is_water = HayAgua(x, y)
'
'            '/AGUA MOVIMIENTO
'        Next x
'    Next y
'
'    'Call DXCopyMemory(cColorDataORIGINAL(1, 1), cColorData(1, 1), Len(cColorData(1, 1)) * 100& * 100&)
'
'
'    CurMap = map
'
'
'
'    MapInfo.name = ""
'    MapInfo.Music = ""
'
'funcion_actual = 0
''End If
'End Sub



Sub loadhm()

End Sub

Sub jojoparticulas()


End Sub



Sub CargarCabezas()
    Dim n As Integer
    Dim i As Long
    Dim Numheads As Integer
    Dim Miscabezas() As tIndiceCabeza
    
    n = FreeFile()
    Open app.Path & "\Datos\Cabezas.ind" For Binary Access Read As #n
    
    'cabecera
    Get #n, , MiCabecera
    
    'num de cabezas
    Get #n, , Numheads
    
    'Resize array
    ReDim HeadData(0 To Numheads) As HeadData
    ReDim Miscabezas(0 To Numheads) As tIndiceCabeza
    
    For i = 1 To Numheads
        Get #n, , Miscabezas(i)
        
        If Miscabezas(i).Head(1) Then
            Call InitGrh(HeadData(i).Head(1), Miscabezas(i).Head(1), 0)
            Call InitGrh(HeadData(i).Head(2), Miscabezas(i).Head(2), 0)
            Call InitGrh(HeadData(i).Head(3), Miscabezas(i).Head(3), 0)
            Call InitGrh(HeadData(i).Head(4), Miscabezas(i).Head(4), 0)
        End If
    Next i
    
    Close #n
End Sub

Sub CargarCascos()
    Dim n As Integer
    Dim i As Long
    Dim NumCascos As Integer

    Dim Miscabezas() As tIndiceCabeza
    
    n = FreeFile()
    Open app.Path & "\Datos\Cascos.ind" For Binary Access Read As #n
    
    'cabecera
    Get #n, , MiCabecera
    
    'num de cabezas
    Get #n, , NumCascos
    
    'Resize array
    ReDim CascoAnimData(0 To NumCascos) As HeadData
    ReDim Miscabezas(0 To NumCascos) As tIndiceCabeza
    
    For i = 1 To NumCascos
        Get #n, , Miscabezas(i)
        
        If Miscabezas(i).Head(1) Then
            Call InitGrh(CascoAnimData(i).Head(1), Miscabezas(i).Head(1), 0)
            Call InitGrh(CascoAnimData(i).Head(2), Miscabezas(i).Head(2), 0)
            Call InitGrh(CascoAnimData(i).Head(3), Miscabezas(i).Head(3), 0)
            Call InitGrh(CascoAnimData(i).Head(4), Miscabezas(i).Head(4), 0)
        End If
    Next i
    
    Close #n
End Sub

Sub CargarCuerpos()
    Dim n As Integer
    Dim i As Long
    Dim NumCuerpos As Integer
    Dim MisCuerpos() As tIndiceCuerpo
    
    n = FreeFile()
    Open app.Path & "\Datos\Personajes.ind" For Binary Access Read As #n
    
    'cabecera
    Get #n, , MiCabecera
    
    'num de cabezas
    Get #n, , NumCuerpos
    
    'Resize array
    ReDim BodyData(0 To NumCuerpos) As BodyData
    ReDim MisCuerpos(0 To NumCuerpos) As tIndiceCuerpo
    
    For i = 1 To NumCuerpos
        Get #n, , MisCuerpos(i)
        
        If MisCuerpos(i).Body(1) Then
            InitGrh BodyData(i).Walk(1), MisCuerpos(i).Body(1), 0
            InitGrh BodyData(i).Walk(2), MisCuerpos(i).Body(2), 0
            InitGrh BodyData(i).Walk(3), MisCuerpos(i).Body(3), 0
            InitGrh BodyData(i).Walk(4), MisCuerpos(i).Body(4), 0
            
            BodyData(i).HeadOffset.x = MisCuerpos(i).HeadOffsetX
            BodyData(i).HeadOffset.y = MisCuerpos(i).HeadOffsetY
        End If
    Next i
    
    Close #n
End Sub

Sub CargarFxs()
    Dim n As Integer
    Dim i As Long
    Dim NumFxs As Integer
    
    n = FreeFile()
    Open app.Path & "\Datos\Fxs.ind" For Binary Access Read As #n
    
    'cabecera
    Get #n, , MiCabecera
    
    'num de cabezas
    Get #n, , NumFxs
    
    'Resize array
    ReDim FxData(1 To NumFxs) As tIndiceFx
    
    For i = 1 To NumFxs
        Get #n, , FxData(i)
    Next i
    
    Close #n
End Sub
