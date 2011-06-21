Attribute VB_Name = "Engine_IO"
Option Explicit

Private Type alturas
    plus(3) As Single
    alt As Single
End Type

Dim altura(1 To 100, 1 To 100) As alturas

Dim Mapas_pak As clsFilePaker

Sub SwitchMap(ByVal map As Integer)
'**************************************************************
'Formato de mapas optimizado para reducir el espacio que ocupan.
'Diseñado y creado por Juan Martín Sotuyo Dodero (Maraxus) (juansotuyo@hotmail.com)
'**************************************************************
    Dim y As Long
    Dim X As Long
    Dim tempint As Integer, theta As Single, range As Byte, color As RGBCOLOR
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
    Get handle, , tempint
    Get handle, , tempint
    Get handle, , tempint
    
    'Load arrays
    For y = YMinMapSize To YMaxMapSize
        For X = XMinMapSize To XMaxMapSize
            Get handle, , ByFlags
            
            MapData(X, y).Blocked = (ByFlags And 1)
            
            Get handle, , MapData(X, y).Graphic(1).grhindex
            InitGrh MapData(X, y).Graphic(1), MapData(X, y).Graphic(1).grhindex
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get handle, , MapData(X, y).Graphic(2).grhindex
                InitGrh MapData(X, y).Graphic(2), MapData(X, y).Graphic(2).grhindex
            Else
                MapData(X, y).Graphic(2).grhindex = 0
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get handle, , MapData(X, y).Graphic(3).grhindex
                InitGrh MapData(X, y).Graphic(3), MapData(X, y).Graphic(3).grhindex
            Else
                MapData(X, y).Graphic(3).grhindex = 0
            End If
                
            'Layer 4 used?
            If ByFlags And 8 Then
                Get handle, , MapData(X, y).Graphic(4).grhindex
                InitGrh MapData(X, y).Graphic(4), MapData(X, y).Graphic(4).grhindex
            Else
                MapData(X, y).Graphic(4).grhindex = 0
            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get handle, , MapData(X, y).Trigger
            Else
                MapData(X, y).Trigger = 0
            End If
            
            If ByFlags And 32 Then
                Get handle, , tempint
                tmpp = 0
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, X, y, tempint, 0
                tmpp = 0
                Get handle, , tempint
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, X, y, tempint, 1
                tmpp = 0
                Get handle, , tempint
                If tempint <> 0 Then Engine.Particle_Group_Make tmpp, X, y, tempint, 2
            Else
                MapData(X, y).Particles_groups(0) = 0
                MapData(X, y).Particles_groups(1) = 0
                MapData(X, y).Particles_groups(2) = 0
            End If
            
            If ByFlags And 64 Then
                Get handle, , color
                Get handle, , theta
                Get handle, , range
                Engine_Landscape.Light_Create X, y, color.r, color.g, color.b, range, theta
            End If

            MapData(X, y).sangre_fx = 0
            'Erase NPCs
            If MapData(X, y).CharIndex > 0 Then
                Call EraseChar(MapData(X, y).CharIndex)
            End If
            MapData(X, y).CharIndex = 0
            'Erase OBJs
            MapData(X, y).ObjGrh.grhindex = 0
            MapData(X, y).alt = altura(X, y).alt
            MapData(X, y).plus(0) = altura(X, y).plus(0)
            MapData(X, y).plus(1) = altura(X, y).plus(1)
            MapData(X, y).plus(2) = altura(X, y).plus(2)
            MapData(X, y).plus(3) = altura(X, y).plus(3)

            
        Next X
    Next y
    
    CurMap = map
    
    Heightmap_Calculate , , , , 50, 50, 0

    Light_Render_All

    Close handle
'Delete_File Windows_Temp_Dir & "Mapa" & map & ".map"
#If Debuging = 0 Then
    Mapas_pak.terminate
#End If

    MapInfo.Name = ""
    MapInfo.Music = ""
    

'End If
End Sub

