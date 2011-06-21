Attribute VB_Name = "Engine_Landscape"
Option Explicit

Private Declare Sub lightcalc Lib "MZEngine.dll" (ByVal XCord As Long, ByVal YCord As Long, ByRef MapaR As Byte, ByRef MapaG As Byte, ByRef MapaB As Byte, ByVal AmbientR As Byte, ByVal AmbientG As Byte, ByVal AmbientB As Byte, ByVal cRadio As Long, ByVal cX As Long, ByVal cY As Long, ByVal cRed As Byte, ByVal cGreen As Byte, ByVal cBlue As Byte, ByVal theta As Single)
Private Declare Sub ElevarTerreno Lib "MZEngine.dll" (ByVal XCord As Long, ByVal YCord As Long, ByRef altura As Single, ByVal map_x As Long, ByVal map_y As Long, ByVal theta As Single, ByVal range As Long, ByVal haltura As Byte)

Public Declare Function ArrPtr Lib "msvbvm60.dll" Alias "VarPtr" (Ptr() As Any) As Long


Private Type Light
    active As Boolean 'Do we ignore this light?
    ID As Long
    map_x As Integer 'Coordinates
    map_y As Integer
    range As Byte
    Color As RGBCOLOR
    theta As Single
    last_act As Long
End Type

'Light list
Dim light_list() As Light
Dim light_count As Long
Dim light_last As Long

Private Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long

'void _stdcall CalcularSombra(float A0, float A1, float A2, float A3, float sunx, float suny, float sunz, float &C1, float &C2);
Private Declare Sub CalcularSombra Lib "MZEngine.dll" (ByVal A0 As Single, ByVal A1 As Single, ByVal A2 As Single, ByVal A3 As Single, ByVal sunx As Single, ByVal suny As Single, ByVal sunz As Single, ByRef C1 As Single, ByRef C2 As Single)

Public Coseno(360) As Single
Public Seno(360) As Single

Public Const Perspectiva As Single = 0.65

Public Type hLight
    bright(3) As Single
    Color(3) As RGBCOLOR
End Type

Public Type hColor
    active As Byte
    Color(3) As RGBCOLOR
End Type

Public hLightData(1 To 100, 1 To 100) As hLight

Public LightActControl(1 To 100, 1 To 100) As Long

Public hLCOLOR(1 To 100, 1 To 100) As hColor

Public cColorData(1 To 100, 1 To 100) As hLight

Public cColorDataTerreno(1 To 100, 1 To 100) As hLight

Private last_hLightMap As Integer

Public last_light_calculate As Long
Public last_light_calculate1 As Long

Public last_light_copy As Long, last_light_h_act&

Private last_light_mod As Long
Private last_light_mod_act As Long

Private Type SAFEARRAYBOUND
    cElements As Long
    lLbound As Long
End Type

Private Type SAFEARRAY2D
    cDims As Integer
    fFeatures As Integer
    cbElements As Long
    cLocks As Long
    pvData As Long
    Bounds(0 To 1) As SAFEARRAYBOUND
End Type


Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
                    ByRef Destination As Any, _
                    ByRef source As Any, _
                    ByVal Bytes As Long)
                    
                    

Public Sub Init_Math_Const()
Dim i%
For i = 0 To 360
    Coseno(i) = Cos(i)
    Seno(i) = Sin(i)
Next i
End Sub

Public Sub amigar_colores(Optional ByVal SX As Byte = 1, Optional ByVal SY As Byte = 1, Optional ByVal EX As Byte = 101, Optional ByVal EY As Byte = 101)
Dim x As Single, y As Single
Dim suma%
    For y = SY + 1 To EY - 1
        For x = SX + 1 To EX - 1
            suma = cColorData(x - 1, y - 1).Color(2).r
            suma = suma + cColorData(x, y - 1).Color(0).r
            suma = suma + cColorData(x, y).Color(1).r
            suma = suma + cColorData(x - 1, y).Color(3).r
            suma = (suma / 4) '* hLightData(X - 1, y - 1).bright(2)
            cColorData(x - 1, y - 1).Color(2).r = suma
            cColorData(x, y - 1).Color(0).r = suma
            cColorData(x, y).Color(1).r = suma
            cColorData(x - 1, y).Color(3).r = suma

            suma = cColorData(x - 1, y - 1).Color(2).g
            suma = suma + cColorData(x, y - 1).Color(0).g
            suma = suma + cColorData(x, y).Color(1).g
            suma = suma + cColorData(x - 1, y).Color(3).g
            suma = (suma / 4) '* hLightData(X - 1, y - 1).bright(2)
            cColorData(x - 1, y - 1).Color(2).g = suma
            cColorData(x, y - 1).Color(0).g = suma
            cColorData(x, y).Color(1).g = suma
            cColorData(x - 1, y).Color(3).g = suma

            suma = cColorData(x - 1, y - 1).Color(2).b
            suma = suma + cColorData(x, y - 1).Color(0).b
            suma = suma + cColorData(x, y).Color(1).b
            suma = suma + cColorData(x - 1, y).Color(3).b
            suma = (suma / 4) '* hLightData(X - 1, y - 1).bright(2)
            cColorData(x - 1, y - 1).Color(2).b = suma
            cColorData(x, y - 1).Color(0).b = suma
            cColorData(x, y).Color(1).b = suma
            cColorData(x - 1, y).Color(3).b = suma
        Next x
    Next y
'    For y = 1 + 1 To 100
'        For X = 1 + 1 To 100
'        With MapData(X, y)
'            .light_value(0) = D3DColorXRGB(.color(0).r, .color(0).g, .color(0).b)
'            .light_value(1) = D3DColorXRGB(.color(1).r, .color(1).g, .color(1).b)
'            .light_value(2) = D3DColorXRGB(.color(2).r, .color(2).g, .color(2).b)
'            .light_value(3) = D3DColorXRGB(.color(3).r, .color(3).g, .color(3).b)
'            'SetPixel frmMain.asd.hDC, X, y, RGB(Abs(.plus(0)), Abs(.plus(0)), Abs(.plus(0)))
'        End With
'        Next X
'    Next y
'frmMain.asd.Picture = frmMain.asd.Image
'frmMain.asd.Refresh

End Sub
'
'Private Sub mezclar_capas()
'
'cr = alpha * ar + (1 - alpha) * br
'cg = alpha * ag + (1 - alpha) * bg
'cb = alpha * ab + (1 - alpha) * bb
'
'End Sub

Public Sub Heightmap_Calculate(Optional ByVal SX As Byte = 1, Optional ByVal SY As Byte = 1, Optional ByVal EX As Byte = 101, Optional ByVal EY As Byte = 101, Optional ByVal sunpos_x As Single = 50, Optional ByVal sunpos_y As Single = 50, Optional ByVal sunpos_z As Single = 112)
    Dim x As Integer, y As Integer, j As Byte
    Dim b As Single
    Dim c As Single
    Dim A0 As Single
    Dim A1 As Single
    Dim A2 As Single
    Dim A3 As Single
    Dim suma As Single
    Dim tamaño_ As Long
    
    If last_hLightMap = CurMap Then Exit Sub
    Debug.Print "CALCULANDO LUZxTERRENO!"
    
    For y = SY + 1 To EY - 1
        For x = SX + 1 To EX - 1
            With MapData(x, y)
                If .alt > 0 Then
                    A0 = .plus(0)
                    A1 = .plus(1)
                    A2 = .plus(2)
                    A3 = .plus(3)
                    CalcularSombra A0, A1, A2, A3, sunpos_x, sunpos_y, sunpos_z, b, c
                    b = b + 0.25
                    If b > 1 Then b = 1
                    c = c + 0.25
                    If c > 1 Then c = 1

'                    .color(0).r = b * .color(0).r
'                    .color(0).g = b * .color(0).g
'                    .color(0).b = b * .color(0).b
'                    .color(3).r = c * .color(3).r
'                    .color(3).g = c * .color(3).g
'                    .color(3).b = c * .color(3).b
'                    MapData(X, y - 1).color(2) = .color(3)
'                    MapData(X - 1, y - 1).color(2) = .color(0)
                    
                    hLightData(x, y).bright(0) = (c + b) / 2
                    
                    hLightData(x, y).bright(2) = c
                    hLightData(x, y).bright(3) = hLightData(x, y).bright(0)
                    
                    suma = (hLightData(x - 1, y - 1).bright(2) + hLightData(x, y - 1).bright(2) + hLightData(x - 1, y).bright(3) + b) / 4
                    
                    hLightData(x, y).bright(1) = suma
                    hLightData(x - 1, y - 1).bright(2) = suma
                    hLightData(x, y - 1).bright(2) = suma
                    hLightData(x - 1, y).bright(3) = suma
                    
                    
                Else
                    hLightData(x, y).bright(0) = 1
                    hLightData(x, y).bright(1) = 1
                    hLightData(x, y).bright(2) = 1
                    hLightData(x, y).bright(3) = 1
                End If
            End With
        Next x
    Next y

    For y = SY + 1 To EY - 1
        For x = SX + 1 To EX - 1
            suma = hLightData(x - 1, y - 1).bright(2)
            suma = suma + hLightData(x, y - 1).bright(0)
            suma = suma + hLightData(x, y).bright(1)
            suma = suma + hLightData(x - 1, y).bright(3)
            suma = suma / 4
            hLightData(x - 1, y - 1).bright(2) = suma
            hLightData(x, y - 1).bright(0) = suma
            hLightData(x, y).bright(1) = suma
            hLightData(x - 1, y).bright(3) = suma
'                For j = 0 To 3
'                    cColorData(x, y).Color(j).r = day_r_old * hLightData(x, y).bright(j)
'                    cColorData(x, y).Color(j).g = day_g_old * hLightData(x, y).bright(j)
'                    cColorData(x, y).Color(j).b = day_b_old * hLightData(x, y).bright(j)
'                Next j
        Next x
    Next y


    tamaño_ = Len(cColorData(1, 1)) * 100& * 100&
    

        For y = 1 To 100
            For x = 1 To 100
                For j = 0 To 3
                    cColorData(x, y).Color(j).r = day_r_old * hLightData(x, y).bright(j)
                    cColorData(x, y).Color(j).g = day_g_old * hLightData(x, y).bright(j)
                    cColorData(x, y).Color(j).b = day_b_old * hLightData(x, y).bright(j)
                Next j
            Next x
        Next y
        Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)
        last_light_copy = base_light


    Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)
    
    last_light_copy = base_light
    last_hLightMap = CurMap
    last_light_h_act = GetTickCount()

    'amigar_colores
    'Call DXCopyMemory(cColorDataTerreno, cColorData, Len(cLightMap) * 99 * 99)
End Sub


Public Sub Map_Clear_All()
Dim i As Integer, x As Integer
Dim j As Integer
For i = 1 To 100
    For x = 1 To 100
        With MapData(x, i)
            For j = 0 To 3
                '.plus(j) = 0
                cColorData(x, i).Color(j).r = day_r_old
                cColorData(x, i).Color(j).g = day_g_old
                cColorData(x, i).Color(j).b = day_b_old
                MapData(x, i).light_value(j) = D3DColorXRGB(day_r_old, day_g_old, day_b_old)
            Next j
            '.alt = 0
        End With
    Next x
Next i
End Sub

Public Sub Map_Clear_Relieve()
'Dim i As Integer, X As Integer
'Dim j As Integer
'For i = 1 To 100
'    For X = 1 To 100
'        With MapData(X, i)
'            For j = 0 To 3
'                .plus(j) = 0
'            Next j
'            .alt = 0
'        End With
'    Next X
'Next i
End Sub

Public Sub Map_Clear_Light()
Dim i As Integer, x As Integer
Dim j As Integer
For i = 1 To 100
    For x = 1 To 100
            For j = 0 To 3
                cColorData(x, i).Color(j).r = day_r_old
                cColorData(x, i).Color(j).g = day_g_old
                cColorData(x, i).Color(j).b = day_b_old
                'MapData(X, i).light_value(j) = D3DColorXRGB(day_r_old, day_g_old, day_b_old)
            Next j
    Next x
Next i
End Sub

Public Sub Map_Elevate(ByVal map_x As Integer, ByVal map_y As Integer, ByVal altura As Byte, Optional ByVal range As Byte = 1, Optional ByVal theta As Single = 0)
    Dim Xa As Integer, Ya As Integer, Xcordi As Long, Ycordi As Long
    Dim r As Byte, g As Byte, b As Byte
       For Ya = map_y - range To map_y + range
            For Xa = map_x - range To map_x + range
            If Ya > 0 And Xa > 0 And Ya < 101 And Ya < 101 Then
                With MapData(Xa, Ya)
                    Xcordi = Xa
                    Ycordi = Ya
                    Call Map_Relieve_Calculate(Xcordi, Ycordi, .plus(1), theta, map_x, map_y, range, altura)
                    Xcordi = Xa + 1
                    Call Map_Relieve_Calculate(Xcordi, Ycordi, .plus(3), theta, map_x, map_y, range, altura)
                    Xcordi = Xa
                    Ycordi = Ya + 1
                    Call Map_Relieve_Calculate(Xcordi, Ycordi, .plus(0), theta, map_x, map_y, range, altura)
                    Xcordi = Xa + 1
                    Call Map_Relieve_Calculate(Xcordi, Ycordi, .plus(2), theta, map_x, map_y, range, altura)
                    .cant = 0
                    .alt = (.plus(0) + .plus(1) + .plus(2) + .plus(3)) / 4
                End With
            End If
            Next Xa
       Next Ya
End Sub

Private Sub Map_Relieve_Calculate(XCord As Long, YCord As Long, altura As Single, ByVal theta As Single, ByVal map_x As Integer, ByVal map_y As Integer, ByVal range As Integer, ByVal haltura As Byte)
ElevarTerreno XCord, YCord, altura, map_x, map_y, theta, CLng(range), haltura
'Dim VertexDist As Single, Lightss As Single, TempColor As Byte
'Dim intd As Integer
'Dim jojo As Byte
'Dim rango As Single
'    jojo = altura
'    VertexDist = Abs(Sqr((map_x - XCord) * (map_x - XCord) + (map_y - YCord) * (map_y - YCord)))
'    intd = 0 - CInt(altura)
'    altura = Abs(altura + intd)
'    If VertexDist <= range Then
'        rango = VertexDist - (range - VertexDist) * theta
'        If rango < 1 Then rango = 1
'        If haltura >= jojo Then
'            Lightss = Abs(haltura - jojo) / range
'            TempColor = haltura - (rango * Lightss)
'            intd = CInt(TempColor) - CInt(altura)
'            altura = Abs(altura + intd)
'        End If
'    End If
'    If altura < jojo Then altura = jojo
End Sub

Public Sub Light_Calculate(ByVal ID As Integer, XCord As Long, YCord As Long, MapaR As Byte, MapaG As Byte, MapaB As Byte)
With light_list(ID)
    lightcalc XCord, YCord, MapaR, MapaG, MapaB, day_r_old, day_g_old, day_b_old, CLng(.range), .map_x, .map_y, .Color.r, .Color.g, .Color.b, .theta
End With
'Dim VertexDist As Single, Lightss As Single, TempColor As RGBCOLOR
'Dim intd As Integer
'With light_list(id)
'    Dim jojo(2) As Byte
'    Dim rango As Single
'
'    jojo(0) = MapaR
'    jojo(1) = MapaG
'    jojo(2) = MapaB
'    If 0 = jojo(0) Then jojo(0) = day_r_old
'    If 0 = jojo(1) Then jojo(1) = day_g_old
'    If 0 = jojo(2) Then jojo(2) = day_b_old
'    VertexDist = Abs(Sqr((.map_x - XCord) * (.map_x - XCord) + (.map_y - YCord) * (.map_y - YCord)))
'    intd = CInt(day_r_old) - CInt(MapaR)
'    MapaR = Abs(MapaR + intd)
'    intd = CInt(day_g_old) - CInt(MapaG)
'    MapaG = Abs(MapaG + intd)
'    intd = CInt(day_b_old) - CInt(MapaB)
'    MapaB = Abs(MapaB + intd)
'
'    If VertexDist <= .range Then
'        rango = VertexDist - (.range - VertexDist) * .theta
'        If rango < 1 Then rango = 1
'        If .Color.r >= jojo(0) Then
'            Lightss = Abs(.Color.r - jojo(0)) / .range
'            TempColor.r = .Color.r - (rango * Lightss)
'            intd = CInt(TempColor.r) - CInt(MapaR)
'            MapaR = Abs(MapaR + intd)
'        End If
'        If .Color.g >= jojo(1) Then
'            Lightss = Abs(.Color.g - jojo(1)) / .range
'            TempColor.g = .Color.g - (rango * Lightss)
'            intd = CInt(TempColor.g) - CInt(MapaG)
'            MapaG = Abs(MapaG + intd)
'        End If
'        If .Color.b >= jojo(2) Then
'            Lightss = Abs(.Color.b - jojo(2)) / .range
'            TempColor.b = .Color.b - (rango * Lightss)
'            intd = CInt(TempColor.b) - CInt(MapaB)
'            MapaB = Abs(MapaB + intd)
'        End If
'    End If
'    If MapaR < jojo(0) Then MapaR = jojo(0)
'    If MapaG < jojo(1) Then MapaG = jojo(1)
'    If MapaB < jojo(2) Then MapaB = jojo(2)
'End With
End Sub





Public Function Light_Remove(ByVal light_index As Long) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 1/04/2003
'
'*****************************************************************
    'Make sure it's a legal index
    If Light_Check(light_index) Then
        Light_Destroy light_index
        Light_Render_All
        Light_Remove = True
    End If
End Function

Public Function Light_Color_Value_Get(ByVal light_index As Long, ByRef color_value As RGBCOLOR) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 2/28/2003
'
'*****************************************************************
    'Make sure it's a legal index
    If Light_Check(light_index) Then
        color_value = light_list(light_index).Color
        Light_Color_Value_Get = True
    End If
End Function

Public Function Light_Create(ByVal map_x As Integer, ByVal map_y As Integer, ByVal r As Byte, ByVal g As Byte, ByVal b As Byte, _
                            Optional ByVal range As Byte = 1, Optional ByVal theta As Single = 0, Optional ByVal ID As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Returns the light_index if successful, else 0
'Edited by Juan Martín Sotuyo Dodero
'**************************************************************
    If InMapBounds(map_x, map_y) Then
        'Make sure there is no light in the given map pos
        'If Map_Light_Get(map_x, map_y) <> 0 Then
        '    Light_Create = 0
        '    Exit Function
        'End If
        Light_Create = Light_Next_Open
        Light_Make Light_Create, map_x, map_y, r, g, b, range, theta, ID
    End If
End Function

Public Function Light_Move(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Returns true if successful, else false
'**************************************************************
    'Make sure it's a legal CharIndex
    If Light_Check(light_index) Then
        'Make sure it's a legal move
        If InMapBounds(map_x, map_y) Then
        
            'Move it
            Light_Erase light_index
            MapData(light_list(light_index).map_x, light_list(light_index).map_y).luz = 0
            light_list(light_index).map_x = map_x
            light_list(light_index).map_y = map_y
            MapData(map_x, map_y).luz = light_index
            Light_Move = True
            'clear_light_map
            Light_Render_All
        End If
        
    End If
End Function

Public Function Light_Move_By_Head(ByVal light_index As Long, ByVal Heading As Byte) As Boolean
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 15/05/2002
'Returns true if successful, else false
'**************************************************************
    Dim map_x As Integer
    Dim map_y As Integer
    Dim nX As Integer
    Dim nY As Integer
    Dim addy As Byte
    Dim addx As Byte
    'Check for valid heading
    If Heading < 1 Or Heading > 8 Then
        Light_Move_By_Head = False
        Exit Function
    End If

    'Make sure it's a legal CharIndex
    If Light_Check(light_index) Then
    
        map_x = light_list(light_index).map_x
        map_y = light_list(light_index).map_y

        Select Case Heading
            Case NORTH
                addy = -1

            Case EAST
                addx = 1
        
            Case SOUTH
                addy = 1
            
            Case WEST
                addx = -1
        End Select
        
        nX = map_x + addx
        nY = map_y + addy
        
        'Make sure it's a legal move
        If InMapBounds(nX, nY) Then
            'Move it
            Light_Erase light_index
            MapData(light_list(light_index).map_x, light_list(light_index).map_y).luz = 0
            light_list(light_index).map_x = map_x
            light_list(light_index).map_y = map_y
            MapData(map_x, map_y).luz = light_index
            Light_Move_By_Head = True
            Light_Render_All
            'Light_Render_All
        End If

    End If
End Function

Private Sub Light_Make(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer, ByVal r As Byte, ByVal g As Byte, ByVal b As Byte, _
                        ByVal range As Long, ByVal theta As Single, Optional ByVal ID As Long)
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'
'*****************************************************************
    'Update array size
    
    

    If light_index > light_last Then
        light_last = light_index
        ReDim Preserve light_list(1 To light_last)
    End If
    light_count = light_count + 1
    
    'Make active
    With light_list(light_index)
        .active = True
        MapData(map_x, map_y).luz = light_index
        .map_x = map_x
        .map_y = map_y
        .range = range
        .ID = ID
        .Color.r = r
        .Color.g = g
        .Color.b = b
        .theta = theta
    End With
End Sub

'Private Sub light_avisar_a_mapa(ByVal index As Integer)
'Dim Xa&, Ya&, mxx&, mxy&, mnx&, mny&
'    With light_list(index)
'        mny = .map_y - .range
'        If mny < 1 Then mny = 1
'        mnx = .map_x - .range
'        If mnx < 1 Then mnx = 1
'        mxy = .map_y + .range
'        If mxy > 100 Then mxy = 100
'        mxx = .map_x + .range
'        If mxx > 100 Then mxx = 100
'
'        For Ya = mny To mxy
'            For Xa = mnx To mxx
'                    With cColorData(Xa, Ya)
'                        LightActControl(Xa, Ya) = 0
'                    End With
'                Next Xa
'        Next Ya
'    End With
'End Sub

Private Function Light_Check(ByVal light_index As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 1/04/2003
'
'**************************************************************
    'check light_index
    If light_index > 0 And light_index <= light_last Then
        If light_list(light_index).active Then
            Light_Check = True
        End If
    End If
End Function

Public Sub clear_light_map()
    Dim tamaño_ As Long
    Dim y As Integer, x As Integer, j As Integer
    tamaño_ = Len(cColorData(1, 1)) * 100& * 100&
    
    If last_light_copy = base_light Then
        Call DXCopyMemory(cColorData(1, 1), cColorDataTerreno(1, 1), tamaño_)
    Else
        For y = 1 To 100
            For x = 1 To 100
                For j = 0 To 3
                    cColorData(x, y).Color(j).r = day_r_old * hLightData(x, y).bright(j)
                    cColorData(x, y).Color(j).g = day_g_old * hLightData(x, y).bright(j)
                    cColorData(x, y).Color(j).b = day_b_old * hLightData(x, y).bright(j)
                Next j
            Next x
        Next y
        Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)
        last_light_copy = base_light
    End If
End Sub



Public Sub Light_Render_All()
    Dim loop_counter As Long
    Static lasthh As Long
    
    clear_light_map
    
    For loop_counter = 1 To light_count
        If light_list(loop_counter).active Then
                Light_Render loop_counter
        End If
    Next loop_counter
    
    last_light_calculate = GetTickCount()

    Engine.map_render_2array

    'amigar_colores
    

End Sub

Public Sub Light_Render(ByVal light_index As Long)
    Dim Xa&, Ya&, mxx&, mxy&, mnx&, mny&, TmpX&, TmpY&
    With light_list(light_index)
        
        TmpX = frmMain.renderer.ScaleWidth \ 32
        TmpY = frmMain.renderer.ScaleHeight \ 32

        If .Color.r < day_r_old And .Color.g < day_g_old And .Color.b < day_b_old Then Exit Sub
        
'        If (UserPos.x - TmpX - .map_x) < .range Then
'            If (UserPos.y - TmpY - .map_y) < .range Then
'                If (UserPos.x - TmpX - .map_x) < (WindowTileWidth + .range) Then
'                    If (UserPos.y - TmpY - .map_y) < (WindowTileHeight + .range) Then
                        mny = .map_y - .range
                        If mny < 1 Then mny = 1
                        mnx = .map_x - .range
                        If mnx < 1 Then mnx = 1
                        mxy = .map_y + .range
                        If mxy > 100 Then mxy = 100
                        mxx = .map_x + .range
                        If mxx > 100 Then mxx = 100
                        
                        For Ya = mny To mxy
                             For Xa = mnx To mxx
                                 With cColorData(Xa, Ya)
                                    Call Light_Calculate(light_index, Xa, Ya, .Color(1).r, .Color(1).g, .Color(1).b)
                                    Call Light_Calculate(light_index, Xa + 1, Ya, .Color(3).r, .Color(3).g, .Color(3).b)
                                    Call Light_Calculate(light_index, Xa, Ya + 1, .Color(0).r, .Color(0).g, .Color(0).b)
                                    Call Light_Calculate(light_index, Xa + 1, Ya + 1, .Color(2).r, .Color(2).g, .Color(2).b)
                                 End With
                             Next Xa
                        Next Ya
            
        'End If: End If: End If: End If
    End With
End Sub

'Private Sub Light_Render(ByVal light_index As Long)
'    Dim Xa As Integer, Ya As Integer, Xcordi As Long, Ycordi As Long
'    Dim r As Byte, g As Byte, b As Byte
'    With light_list(light_index)
'       For Ya = .map_y - .range To .map_y + .range
'            For Xa = .map_x - .range To .map_x + .range
'            If Ya > 0 And Xa > 0 And Ya < 100 And Ya < 100 Then
'                With MapData(Xa, Ya)
'                    Xcordi = Xa
'                    Ycordi = Ya
'                    Call Light_Calculate(light_index, Xcordi, Ycordi, .color(1).r, .color(1).g, .color(1).b)
'                    MapData(Xa, Ya).light_value(1) = D3DColorXRGB(.color(1).r, .color(1).g, .color(1).b)
'                    Xcordi = Xa + 1
'                    Call Light_Calculate(light_index, Xcordi, Ycordi, .color(0).r, .color(0).g, .color(0).b)
'                    MapData(Xa, Ya).light_value(3) = D3DColorXRGB(.color(0).r, .color(0).g, .color(0).b)
'                    Xcordi = Xa
'                    Ycordi = Ya + 1
'                    Call Light_Calculate(light_index, Xcordi, Ycordi, .color(2).r, .color(2).g, .color(2).b)
'                    MapData(Xa, Ya).light_value(0) = D3DColorXRGB(.color(2).r, .color(2).g, .color(2).b)
'                    Xcordi = Xa + 1
'                    Call Light_Calculate(light_index, Xcordi, Ycordi, .color(3).r, .color(3).g, .color(3).b)
'                    MapData(Xa, Ya).light_value(2) = D3DColorXRGB(.color(3).r, .color(3).g, .color(3).b)
'                End With
'            End If
'            Next Xa
'       Next Ya
'    End With
'End Sub

Private Function Light_Next_Open() As Long
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'
'*****************************************************************
On Error GoTo ErrorHandler:
    Dim loopc As Long
    
    loopc = 1
    Do Until light_list(loopc).active = False
        If loopc = light_last Then
            Light_Next_Open = light_last + 1
            Exit Function
        End If
        loopc = loopc + 1
    Loop
    
    Light_Next_Open = loopc
Exit Function
ErrorHandler:
    Light_Next_Open = 1
End Function

Public Function Light_Find(ByVal ID As Long) As Long
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 1/04/2003
'Find the index related to the handle
'*****************************************************************
On Error GoTo ErrorHandler:
    Dim loopc As Long
    
    loopc = 1
    Do Until light_list(loopc).ID = ID
        If loopc = light_last Then
            Light_Find = 0
            Exit Function
        End If
        loopc = loopc + 1
    Loop
    
    Light_Find = loopc
Exit Function
ErrorHandler:
    Light_Find = 0
End Function

Public Function Light_Remove_All() As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 1/04/2003
'
'*****************************************************************
    Dim Index As Long

    For Index = 1 To light_last
        'Make sure it's a legal index
        If Light_Check(Index) Then
            Light_Destroy Index
        End If
    Next Index
    
    Light_Remove_All = True
End Function

Private Sub Light_Destroy(ByVal light_index As Long)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'
'**************************************************************
    Dim temp As Light
    
    Light_Erase light_index
    
    light_list(light_index) = temp
    
    'Update array size
    If light_index = light_last Then
        Do Until light_list(light_last).active
            light_last = light_last - 1
            If light_last = 0 Then
                light_count = 0
                Exit Sub
            End If
        Loop
        ReDim Preserve light_list(1 To light_last)
        clear_light_map
    End If
    light_count = light_count - 1
End Sub

Private Sub Light_Erase(ByVal light_index As Long)
'***************************************'
'Author: Juan Martín Sotuyo Dodero
'Last modified: 3/31/2003
'Correctly erases a light
'***************************************'

End Sub


Public Sub crear_obelisco(x As Byte, y As Byte)
MapData(x - 1, y - 1).plus(2) = 250
MapData(x, y - 1).plus(0) = 250
MapData(x, y).plus(1) = 250
MapData(x - 1, y).plus(3) = 250
MapData(x, y).Graphic(1).grhindex = 11
MapData(x - 1, y).Graphic(1).grhindex = 11
MapData(x, y - 1).Graphic(1).grhindex = 11
MapData(x - 1, y - 1).Graphic(1).grhindex = 11
Light_Render_All
End Sub
