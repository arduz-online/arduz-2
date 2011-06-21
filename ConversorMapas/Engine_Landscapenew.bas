Attribute VB_Name = "Engine_Landscape"
Option Explicit

Private Type Light
    active As Boolean 'Do we ignore this light?
    ID As Long
    map_x As Integer 'Coordinates
    map_y As Integer
    x As Single
    y As Single
    
    range As Byte
    Color As D3DCOLORVALUE
    theta As Single
    last_act As Long
    brillo As Single
    
    rf As Byte
    img As Integer
    
    rangoplus As Single
    map_xplus As Single
    map_yplus As Single
    DistX As Single
    DistY As Single
    
    layered As Byte
End Type

'Light list
Dim light_list() As Light
Dim light_count As Long
Dim light_last As Long

Private Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Sub CalcularSombra Lib "MZEngine.dll" (ByVal A0 As Single, ByVal A1 As Single, ByVal A2 As Single, ByVal A3 As Single, ByVal sunx As Single, ByVal suny As Single, ByVal sunz As Single, ByRef C1 As Single, ByRef C2 As Single)
Private Declare Sub ElevarTerreno Lib "MZEngine.dll" (ByVal XCord As Long, ByVal YCord As Long, ByRef altura As Single, ByVal map_x As Long, ByVal map_y As Long, ByVal theta As Single, ByVal range As Long, ByVal haltura As Byte)
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal Bytes As Long)
Private Declare Sub ZeroMemory Lib "kernel32" Alias "RtlZeroMemory" (ByRef dest As Any, ByVal numbytes As Long)
Public Declare Function ArrPtr Lib "msvbvm60.dll" Alias "VarPtr" (Ptr() As Any) As Long

Public Coseno(360) As Single
Public Seno(360) As Single

Public Const Perspectiva As Single = 0.65


Public hLightData(1 To 100, 1 To 100, 0 To 3) As Single
Public hasBaseLight(1 To 100, 1 To 100) As Byte
Public light_base_value(1 To 100, 1 To 100) As hLight
Public cColorData(1 To 100, 1 To 100) As hLight
Public cColorDataTerreno(1 To 100, 1 To 100) As hLight
Public map_has_light(1 To 100, 1 To 100) As Byte
Public map_has_hlight(1 To 100, 1 To 100) As Byte

Private last_hLightMap As Integer

Public last_light_calculate As Long
Public last_light_calculate1 As Long

Public last_light_copy As Long, last_light_h_act As Long

Private last_light_mod As Long
Private last_light_mod_act As Long


Public rerender_lights As Boolean

'Private Sub mezclar_capas()
'cr = alpha * ar + (1 - alpha) * br
'cg = alpha * ag + (1 - alpha) * bg
'cb = alpha * ab + (1 - alpha) * bb
'End Sub

Public Sub Init_Math_Const()
Dim i%
For i = 0 To 360
    Coseno(i) = Cos(i * DegreeToRadian)
    Seno(i) = Sin(i * DegreeToRadian)
Next i
End Sub


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
    
    'If last_hLightMap = CurMap Then Exit Sub
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
                    
                    hLightData(x, y, 0) = (c + b) / 2
                    
                    hLightData(x, y, 2) = c
                    hLightData(x, y, 3) = hLightData(x, y, 0)
                    
                    suma = (hLightData(x - 1, y - 1, 2) + hLightData(x, y - 1, 2) + hLightData(x - 1, y, 3) + b) / 4
                    
                    hLightData(x, y, 1) = suma
                    hLightData(x - 1, y - 1, 2) = suma
                    hLightData(x, y - 1, 2) = suma
                    hLightData(x - 1, y, 3) = suma
                Else
                    hLightData(x, y, 0) = 1
                    hLightData(x, y, 1) = 1
                    hLightData(x, y, 2) = 1
                    hLightData(x, y, 3) = 1
                End If
            End With
        Next x
    Next y

    For y = SY + 1 To EY - 1
        For x = SX + 1 To EX - 1
            suma = hLightData(x - 1, y - 1, 2)
            suma = suma + hLightData(x, y - 1, 0)
            suma = suma + hLightData(x, y, 1)
            suma = suma + hLightData(x - 1, y, 3)
            suma = suma / 4
            hLightData(x - 1, y - 1, 2) = suma
            hLightData(x, y - 1, 0) = suma
            hLightData(x, y, 1) = suma
            hLightData(x - 1, y, 3) = suma
            SetPixel Form1.hm.hDC, x, y, RGB(suma, suma, suma)
        Next x
    Next y

    tamaño_ = Len(cColorData(1, 1)) * 100& * 100&
    
    Dim truee As Boolean
    
    Call ZeroMemory(map_has_hlight(1, 1), 100& * 100&)
    
    For y = 1 To 100
        For x = 1 To 100
            truee = (hLightData(x, y, 0) + hLightData(x, y, 1) + hLightData(x, y, 2) + hLightData(x, y, 3)) < 4!
            map_has_hlight(x, y) = CByte(truee)
            For j = 0 To 3
                cColorData(x, y).Color(j).r = day_r_old * hLightData(x, y, j)
                cColorData(x, y).Color(j).g = day_g_old * hLightData(x, y, j)
                cColorData(x, y).Color(j).b = day_b_old * hLightData(x, y, j)
                
            Next j
        Next x
    Next y
    
    last_light_copy = base_light
    
    Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)
    Call DXCopyMemory(map_has_light(1, 1), map_has_hlight(1, 1), 100& * 100&)
    Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)

    last_light_copy = base_light
    'last_hLightMap = CurMap
    last_light_h_act = GetTickCount()
    rerender_lights = True
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
                Next j
        Next x
    Next i
End Sub

Private Function Map_LightAreaClear(ByVal ID As Integer)
    Dim x&, y&, mxx&, mxy&, mnx&, mny&, j%
        With light_list(ID)
            mny = .map_y - .range
            If mny < 1 Then mny = 1
            mnx = .map_x - .range
            If mnx < 1 Then mnx = 1
            mxy = .map_y + .range
            If mxy > 100 Then mxy = 100
            mxx = .map_x + .range
            If mxx > 100 Then mxx = 100
                        
            For y = mny To mxy
                For x = mnx To mxx
                    If hasBaseLight(x, y) Then
                        cColorData(x, y) = light_base_value(x, y)
                    Else
                        For j = 0 To 3
                            cColorData(x, y).Color(j).r = xcopycolor.Color(j).r * hLightData(x, y, j)
                            cColorData(x, y).Color(j).g = xcopycolor.Color(j).g * hLightData(x, y, j)
                            cColorData(x, y).Color(j).b = xcopycolor.Color(j).b * hLightData(x, y, j)
                        Next j
                    End If
                    
                Next x
            Next y
        End With
End Function

Public Sub Map_Elevate(ByVal map_x As Integer, ByVal map_y As Integer, ByVal altura As Byte, Optional ByVal range As Byte = 1, Optional ByVal theta As Single = 0)
    Dim Xa As Integer, Ya As Integer, Xcordi As Long, Ycordi As Long
    Dim r As Byte, g As Byte, b As Byte
       For Ya = map_y - range To map_y + range
            For Xa = map_x - range To map_x + range
            If Ya > 0 And Xa > 0 And Ya < 101 And Xa < 101 Then
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
End Sub




Public Function Light_Remove(ByVal light_index As Long) As Boolean
    If Light_Check(light_index) Then
        Light_Destroy light_index
        Light_Render_All
        Light_Remove = True
    End If
End Function

Public Function Light_Create(ByVal map_x As Integer, ByVal map_y As Integer, ByVal r As Byte, ByVal g As Byte, ByVal b As Byte, _
                            Optional ByVal range As Byte = 1, Optional ByVal theta As Single = 0, Optional ByVal ID As Long) As Long
    'If InMapBounds(map_x, map_y) Then
        Light_Create = Light_Next_Open
        Light_Make Light_Create, map_x, map_y, r, g, b, range, theta, ID
    'End If
End Function

Public Function Light_Move(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer, ByVal x As Integer, ByVal y As Integer) As Boolean
    If Light_Check(light_index) Then
        If InMapBounds(map_x, map_y) Then
            MapData(light_list(light_index).map_x, light_list(light_index).map_y).luz = 0
            light_list(light_index).map_x = map_x
            light_list(light_index).map_y = map_y
            light_list(light_index).map_xplus = map_x * 32
            light_list(light_index).map_yplus = map_y * 32
            light_list(light_index).DistX = light_list(light_index).map_xplus + 16
            light_list(light_index).DistY = light_list(light_index).map_yplus + 16
            light_list(light_index).x = x
            light_list(light_index).y = y
            MapData(map_x, map_y).luz = light_index
            Light_Move = True
            'clear_light_map

            rerender_lights = True
        End If
        
    End If
End Function

Private Sub Light_Make(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer, ByVal r As Byte, ByVal g As Byte, ByVal b As Byte, _
                        ByVal range As Long, ByVal theta As Single, Optional ByVal ID As Long)
    If light_index > light_last Then
        light_last = light_index
        ReDim Preserve light_list(1 To light_last)
    End If
    light_count = light_count + 1
    
    With light_list(light_index)
        .active = True
        MapData(map_x, map_y).luz = light_index
        .map_x = map_x
        .map_y = map_y
        .map_xplus = .map_x * 32
        .map_yplus = .map_y * 32
        .map_xplus = .map_xplus + 16
        .map_yplus = .map_yplus + 16
        .range = range
        .rangoplus = .range * 32
        .ID = ID
        .Color.r = r
        .Color.g = g
        .Color.b = b
        .brillo = (.Color.r + .Color.g + .Color.b) / 3
        .theta = theta
        .rf = 1
        
        rerender_lights = True
        
    End With
    
End Sub

Private Function Light_Check(ByVal light_index As Long) As Boolean
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
                    cColorData(x, y).Color(j).r = day_r_old * hLightData(x, y, j)
                    cColorData(x, y).Color(j).g = day_g_old * hLightData(x, y, j)
                    cColorData(x, y).Color(j).b = day_b_old * hLightData(x, y, j)
                Next j
            Next x
        Next y
        
        Call DXCopyMemory(cColorDataTerreno(1, 1), cColorData(1, 1), tamaño_)
        last_light_copy = base_light
    End If
    Call DXCopyMemory(map_has_light(1, 1), map_has_hlight(1, 1), 100& * 100&)
End Sub

Public Sub Light_Render_All()
    Dim loop_counter As Long
    Dim dibu As Integer
    
    clear_light_map
    
    For loop_counter = 1 To light_count
        If light_list(loop_counter).active Then
            Light_Render loop_counter
            dibu = dibu + 1
        End If
    Next loop_counter
    Form1.luz.Picture = Form1.luz.Image
    Form1.luz.Refresh
    
    last_light_calculate = GetTickCount()

    rerender_lights = False
    
End Sub

Public Sub Light_Render(ByVal light_index As Long, Optional avisar_force As Byte = 0)
    Dim x&, y&, mxx&, mxy&, mnx&, mny&, XDist!, YDist!, Dist! ', TmpX&, TmpY&, radio!
    With light_list(light_index)
        If .Color.r < day_r_old And .Color.g < day_g_old And .Color.b < day_b_old Then Exit Sub
        
        mny = .map_y - .range - 1
        If mny < 2 Then mny = 2
        mnx = .map_x - .range - 1
        If mnx < 2 Then mnx = 2
        mxy = .map_y + .range + 1
        If mxy > 99 Then mxy = 99
        mxx = .map_x + .range + 1
        If mxx > 99 Then mxx = 99

        For y = mny To mxy
            For x = mnx To mxx
                XDist = .DistX + .x - x * 32
                YDist = .DistY + .y - y * 32
                Dist = Sqr(XDist * XDist + YDist * YDist)
                If Dist <= .rangoplus Then Call D3DXColorLerp(cColorData(x, y).Color(1), .Color, cColorData(x, y).Color(1), Dist / .rangoplus)
                
                cColorData(x - 1, y - 1).Color(2) = cColorData(x, y).Color(1)
                SetPixel Form1.luz.hDC, x, y, RGB(cColorData(x, y).Color(1).r, cColorData(x, y).Color(1).g, cColorData(x, y).Color(1).b)
                Debug.Print cColorData(x, y).Color(1).r; Dist; .rangoplus
                cColorData(x, y - 1).Color(0) = cColorData(x, y).Color(1)
                cColorData(x - 1, y).Color(3) = cColorData(x, y).Color(1)
                
                map_has_light(x, y) = 1
            Next x
        Next y
    End With
End Sub

Private Function Light_Next_Open() As Long
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

End Sub


