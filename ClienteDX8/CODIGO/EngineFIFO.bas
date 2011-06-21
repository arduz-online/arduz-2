Attribute VB_Name = "Engine_FIFO"
Option Explicit

Private Type alturas
    plus(3) As Single
    alt As Single
End Type

Dim altura(1 To 100, 1 To 100) As alturas



Sub SwitchMap(ByVal map As Integer)
'**************************************************************
'Formato de mapas optimizado para reducir el espacio que ocupan.
'Diseñado y creado por Juan Martín Sotuyo Dodero (Maraxus) (juansotuyo@hotmail.com)
'**************************************************************
    Dim y As Long
    Dim x As Long
    Dim tempint As Integer, theta As Single, range As Byte, Color As RGBCOLOR
    Dim tmpp%
    Dim ByFlags As Byte
    Dim handle As Integer
    handle = FreeFile()
    
'If Extract_File(resource_file_type.mapX, App.path & "\Datos", "Mapa" & map & ".map", Windows_Temp_Dir, False) Then
#If Debuging = 0 Then
    Set Mapas_pak = New clsFilePaker
    If Mapas_pak.FP_Initialize(App.path & "\Datos\Mapas.arduz") = True Then
        Call Mapas_pak.FP_Extract("Mapa" & map & ".map", Windows_Temp_Dir & "Mapa.map")
        
        Open Windows_Temp_Dir & "Mapa.map" For Binary As handle
    Else
        Exit Sub
    End If
#Else
    Debug.Print "C:\PC VIEJA\aonuevo\NOBIN\MAPAS\Mapa" & map & ".map"
    Open "C:\PC VIEJA\aonuevo\NOBIN\MAPAS\Mapa" & map & ".map" For Binary As handle
    
    Dim FreeFileMap As Long
    FreeFileMap = FreeFile
    Open "C:\PC VIEJA\aonuevo\NOBIN\MAPAS\Mapa" & map & ".hmap" For Binary Access Read As FreeFileMap
        Get FreeFileMap, , altura
    Close FreeFileMap

#End If
    Engine_Landscape.Light_Remove_All
    Engine.Particle_Group_Remove_All
    
    Seek handle, 1

    'map Header
    Get handle, , MapInfo.MapVersion
    Get handle, , MiCabecera
    
    Get handle, , tempint
    day_r_old = tempint
    Get handle, , tempint
    day_g_old = tempint
    Get handle, , tempint
    day_b_old = tempint
    Get handle, , tempint
    
    Color_Fade_To.r = day_r_old
    Color_Fade_To.g = day_g_old
    Color_Fade_To.b = day_b_old
    'Load arrays
    For y = YMinMapSize To YMaxMapSize
        For x = XMinMapSize To XMaxMapSize
            Get handle, , ByFlags
            
            MapData(x, y).Blocked = (ByFlags And 1)
            
            Get handle, , MapData(x, y).Graphic(1).GrhIndex
            InitGrh MapData(x, y).Graphic(1), MapData(x, y).Graphic(1).GrhIndex
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get handle, , MapData(x, y).Graphic(2).GrhIndex
                InitGrh MapData(x, y).Graphic(2), MapData(x, y).Graphic(2).GrhIndex
            Else
                MapData(x, y).Graphic(2).GrhIndex = 0
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get handle, , MapData(x, y).Graphic(3).GrhIndex
                InitGrh MapData(x, y).Graphic(3), MapData(x, y).Graphic(3).GrhIndex
            Else
                MapData(x, y).Graphic(3).GrhIndex = 0
            End If
                
            'Layer 4 used?
            If ByFlags And 8 Then
                Get handle, , MapData(x, y).Graphic(4).GrhIndex
                InitGrh MapData(x, y).Graphic(4), MapData(x, y).Graphic(4).GrhIndex
            Else
                MapData(x, y).Graphic(4).GrhIndex = 0
            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get handle, , MapData(x, y).Trigger
            Else
                MapData(x, y).Trigger = 0
            End If
            
            If ByFlags And 32 Then
                Get handle, , tempint
                tmpp = 0
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, x, y, tempint, 0
                tmpp = 0
                Get handle, , tempint
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, x, y, tempint, 1
                tmpp = 0
                Get handle, , tempint
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, x, y, tempint, 2
            Else
                MapData(x, y).Particles_groups(0) = 0
                MapData(x, y).Particles_groups(1) = 0
                MapData(x, y).Particles_groups(2) = 0
            End If
            
            If ByFlags And 64 Then
                Get handle, , Color
                Get handle, , theta
                Get handle, , range
                Engine_Landscape.Light_Create x, y, Color.r, Color.g, Color.b, range, theta
            End If

            MapData(x, y).sangre_fx = 0
            
            'Erase NPCs
            If MapData(x, y).CharIndex > 0 Then
                Call EraseChar(MapData(x, y).CharIndex)
            End If
            
            MapData(x, y).CharIndex = 0
            'Erase OBJs
            MapData(x, y).ObjGrh.GrhIndex = 0
            MapData(x, y).alt = altura(x, y).alt
            MapData(x, y).plus(0) = altura(x, y).plus(0)
            MapData(x, y).plus(1) = altura(x, y).plus(1)
            MapData(x, y).plus(2) = altura(x, y).plus(2)
            MapData(x, y).plus(3) = altura(x, y).plus(3)
            MapData(x, y).last_light = -1
            
        Next x
    Next y
    
    CurMap = map
    
    Heightmap_Calculate , , , , 50, 50, 0
    

    
    Light_Render_All

    Close handle
'Delete_File Windows_Temp_Dir & "Mapa" & map & ".map"
#If Debuging = 0 Then
    Mapas_pak.Terminate
#End If

    MapInfo.name = ""
    MapInfo.Music = ""
    

'End If
End Sub

Sub CargarParticle_Streams()
    '*****************************************************************
    'Menduz
    '*****************************************************************
    Dim streamfile As String
    Dim loopc As Integer
    streamfile = App.path & "\Particles.ini"
    TotalStreams = Val(GetVar(streamfile, "INIT", "Total"))
    
    ReDim Particle_Stream(1 To TotalStreams) As Stream
    
    For loopc = 1 To TotalStreams
        With Particle_Stream(loopc)
            .name = GetVar(streamfile, CStr("GROUP" & loopc), "Name")
            .accX = GetVarSng(streamfile, CStr("GROUP" & loopc), "accX")
            .accY = GetVarSng(streamfile, CStr("GROUP" & loopc), "accY")
            .spdX = GetVarSng(streamfile, CStr("GROUP" & loopc), "spdX")
            .spdY = GetVarSng(streamfile, CStr("GROUP" & loopc), "spdY")
            .VarZ = GetVarSng(streamfile, CStr("GROUP" & loopc), "VarZ")
            .AlphaInicial = GetVarSng(streamfile, CStr("GROUP" & loopc), "AlphaInicial")
            .RedInicial = GetVarSng(streamfile, CStr("GROUP" & loopc), "RedInicial")
            .GreenInicial = GetVarSng(streamfile, CStr("GROUP" & loopc), "GreenInicial")
            .BlueInicial = GetVarSng(streamfile, CStr("GROUP" & loopc), "BlueInicial")
            .alpha_factor = GetVarSng(streamfile, CStr("GROUP" & loopc), "AlphaFactor")
            .RedFinal = GetVarSng(streamfile, CStr("GROUP" & loopc), "RedFinal")
            .GreenFinal = GetVarSng(streamfile, CStr("GROUP" & loopc), "GreenFinal")
            .BlueFinal = GetVarSng(streamfile, CStr("GROUP" & loopc), "BlueFinal")
            .NumOfParticles = Val(GetVar(streamfile, CStr("GROUP" & loopc), "NumOfParticles"))
            .Gravity = GetVarSng(streamfile, CStr("GROUP" & loopc), "Gravity")
            .mod_timer = GetVarSng(streamfile, CStr("GROUP" & loopc), "Timer")
            .rnd_x = GetVarSng(streamfile, CStr("GROUP" & loopc), "RndX")
            .rnd_y = GetVarSng(streamfile, CStr("GROUP" & loopc), "RndY")
            .rnd_alpha_factor = GetVarSng(streamfile, CStr("GROUP" & loopc), "RndA")
            .texture = Val(GetVar(streamfile, CStr("GROUP" & loopc), "texture"))
            .size = GetVarSng(streamfile, CStr("GROUP" & loopc), "Size")
            Call DXCopyMemory(.Size_dword, .size, 4)
            .life = Val(GetVar(streamfile, CStr("GROUP" & loopc), "Life"))
            .tipo = Val(GetVar(streamfile, CStr("GROUP" & loopc), "Tipo"))
            If .tipo <> 1 And .NumOfParticles > 360 Then .NumOfParticles = 360
            .StartColor = CreateColorVal(.AlphaInicial, .RedInicial, .GreenInicial, .BlueInicial)
            .EndColor = CreateColorVal(.AlphaInicial, .RedFinal, .GreenFinal, .BlueFinal)
            .vida = Val(GetVar(streamfile, CStr("GROUP" & loopc), "Vida"))
            .muere = 0
            If .vida > 0 Then .muere = 1
        End With
    Next loopc
End Sub

Sub loadhm()
Dim y As Integer, x As Integer
Dim j As Integer
For y = 2 To 100
    For x = 2 To 100
        j = (frmMain.asd.Point(x, y) Mod &H100) / 10
        MapData(x - 1, y - 1).plus(2) = j
        MapData(x, y - 1).plus(0) = j
        MapData(x, y).plus(1) = j
        MapData(x - 1, y).plus(3) = j
    Next x
Next y
For y = 1 To 100
    For x = 1 To 100
        j = MapData(x, y).plus(0) + MapData(x, y).plus(1) + MapData(x, y).plus(2) + MapData(x, y).plus(3)
        MapData(x, y).alt = j / 4
    Next x
Next y
End Sub

Sub jojoparticulas()
CargarParticle_Streams

    Engine_Landscape.Light_Create 40, 49, 255, 200, 60, 5, 3
    Engine.Particle_Group_Make 1, 40, 49, 1
    Engine.Particle_Group_Make 1, 40, 49, 9, 0
    Engine_Landscape.Light_Render_All
End Sub
