Attribute VB_Name = "Engine_FX"
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

Public Enum TEffect
    NoEffect = 0
    SlideX = 1
    SlideY = 2
    SlideBoth = 2
End Enum

Public Type bigfxdata
    active As Byte
    verts() As TLVERTEX
    vertsR() As TLVERTEX
    verts_multiplo() As Single
    numverts As Integer
    VBuffer As Direct3DVertexBuffer8
    x As Byte
    y As Byte
    Progress As Single
    type As Integer
    die As Single
    setup As Byte
End Type

Private Enum BFX_class
    plane = 0
    cilindro = 1
    estrella = 2
End Enum

Private Type BFX_Stream
    segmentos As Integer
    textura As Integer
    clase As BFX_class
    color1 As D3DCOLORVALUE
    color2 As D3DCOLORVALUE
    alpha_factor As Single
    alpha_inicial As Single
    altura As Integer
    radio As Integer
    texture_effect As TEffect
End Type

Public Type Projectile
    x As Single
    y As Single
    tX As Single
    tY As Single
    v As Single
    uid As Integer
    Grh As Integer
    life As Single
End Type

Public Type rayo
    seg As Integer
    seg_size As Single
    Pos As D3DVECTOR2
    color As Long
End Type

Public Type deformaciones
    don As D3DVECTOR4
    freq As Single
    vida As Single
End Type

Private def_list() As deformaciones
Private last_def As Integer

Public ProjectileList() As Projectile
Public LastProjectile As Integer

Public RayList() As rayo
Public LastRay As Integer

Private BFX_streams() As BFX_Stream
Private BFX_streams_last As Integer

Private BFX_List() As bigfxdata
Private BFX_Last As Integer

Public Type hits
    txt     As String
    color   As Long
    x       As Single
    y       As Single
    vida    As Single
    alpha   As Single
    active  As Byte
End Type

Public HitList() As hits
Public LastHit As Integer

Public Sub FX_Hit_Create(ByVal cid As Integer, ByVal hit As Integer, ByVal vida As Long, ByVal color As Long)
    Dim Index As Integer
    Do
        Index = Index + 1
        If Index > LastHit Then
            LastHit = Index
            ReDim Preserve HitList(1 To LastHit)
            Exit Do
        End If
    Loop While HitList(Index).active = 1
    
    HitList(Index).color = color
    HitList(Index).txt = CStr(hit)
    HitList(Index).alpha = 255
    HitList(Index).active = 1
    HitList(Index).vida = vida + GetTickCount
    HitList(Index).x = (charlist(cid).Pos.x) * 32
    HitList(Index).y = (charlist(cid).Pos.y) * 32 - charlist(cid).OffY
End Sub

Public Sub FX_Hit_Erase(ByVal Index As Integer)
    HitList(Index).active = 0
    If Index = LastHit Then
        Do Until HitList(Index).active = 1
            'Move down one projectile
            LastHit = LastHit - 1
            If LastHit = 0 Then Exit Do
        Loop
        If Index <> LastHit Then
            'We still have projectiles, resize the array to end at the last used slot
            If LastHit > 0 Then
                ReDim Preserve HitList(1 To LastHit)
            Else
                Erase HitList
            End If
        End If
    End If
End Sub

Public Sub FX_Hit_Erase_All()
    If LastHit > 0 Then
        LastHit = 0
        Erase HitList
    End If
End Sub

Public Sub FX_Hit_Render()
Dim x!, y!, j%
Dim gtc&
gtc = GetTickCount

    If LastHit > 0 Then
        For j = 1 To LastHit
            If HitList(j).active Then
                If HitList(j).vida < gtc Then
                    FX_Hit_Erase j
                Else
                    HitList(j).alpha = HitList(j).alpha - timerTicksPerFrame * 12
                    If HitList(j).alpha > 0 Then
                        With HitList(j)
                            x = .x + offset_map.x
                            y = .y + offset_map.y
                            .y = .y - timerTicksPerFrame * 3
                            Engine.Text_Render_alpha CStr(" " & .txt & " "), y, x + 16, .color, 1, Abs(.alpha Mod 256)
                        End With
                    Else
                        FX_Hit_Erase j
                    End If
                End If
            End If
        Next j
    End If
End Sub

'Sub Create_VertexBufferFromTLVERTEX(RetBuffer As Direct3DVertexBuffer8, VERTEX_Array() As TLVERTEX)
'    Dim NUM_VERT As Long
'    NUM_VERT = UBound(VERTEX_Array) - LBound(VERTEX_Array) + 1
'    Set RetBuffer = obj_Device.CreateVertexBuffer(TL_size * NUM_VERT, 0, FVF, D3DPOOL_DEFAULT)
'    D3DVertexBuffer8SetData RetBuffer, 0, TL_size * NUM_VERT, 0, VERTEX_Array(LBound(VERTEX_Array))
'End Sub

Public Sub Projectile_Render()
Dim angle!, angle1!, j%, x!, y!
    If LastProjectile > 0 Then
        For j = 1 To LastProjectile
            If ProjectileList(j).Grh Then
                If ProjectileList(j).uid Then
                    angle = Engine_GetAngle(ProjectileList(j).x, ProjectileList(j).y, charlist(ProjectileList(j).uid).Pos.x * 32, charlist(ProjectileList(j).uid).Pos.y * 32)
                    ProjectileList(j).x = Interp(ProjectileList(j).x, charlist(ProjectileList(j).uid).Pos.x * 32, ProjectileList(j).life)
                    ProjectileList(j).y = Interp(ProjectileList(j).y, charlist(ProjectileList(j).uid).Pos.y * 32, ProjectileList(j).life)
                Else
                    angle = Engine_GetAngle(ProjectileList(j).x, ProjectileList(j).y, ProjectileList(j).tX, ProjectileList(j).tY)
                    ProjectileList(j).x = Interp(ProjectileList(j).x, ProjectileList(j).tX, ProjectileList(j).life)
                    ProjectileList(j).y = Interp(ProjectileList(j).y, ProjectileList(j).tY, ProjectileList(j).life)
                End If
                
                If ProjectileList(j).life < 0.5 Then
                    ProjectileList(j).y = ProjectileList(j).y - timerElapsedTime * ProjectileList(j).v * 0.5
                End If
                
                ProjectileList(j).life = ProjectileList(j).life + timerElapsedTime * ProjectileList(j).v * 0.0005
'
'                angle1 = Round(180 - angle) ' * DegreeToRadian
'                ProjectileList(j).X = ProjectileList(j).X - Sin(angle1) * timerElapsedTime * ProjectileList(j).v
'                ProjectileList(j).Y = ProjectileList(j).Y + Cos(angle1) * timerElapsedTime * ProjectileList(j).v

                'Draw if within range
                x = ProjectileList(j).x + offset_map.x
                y = ProjectileList(j).y + offset_map.y

                If y >= -32 Then
                    If y <= (MainViewHeight + 32) Then
                        If x >= -32 Then
                            If x <= (MainViewWidth + 32) Then
                                Engine.Grh_Proyectil ProjectileList(j).Grh, x, y, , base_light, 180 - angle
                            End If
                        End If
                    End If
                End If
                
                If ProjectileList(j).life >= 1 Then
                    ProjectileList(j).life = 0
                    FX_Projectile_Erase j
                Else
                    If ProjectileList(j).uid Then
                        If Abs(ProjectileList(j).x - charlist(ProjectileList(j).uid).Pos.x * 32) < 10 Then
                            If Abs(ProjectileList(j).y - charlist(ProjectileList(j).uid).Pos.y * 32) < 10 Then
                                FX_Projectile_Erase j
                            End If
                        End If
                    Else
                        If Abs(ProjectileList(j).x - ProjectileList(j).tX < 10) Then
                            If Abs(ProjectileList(j).y - ProjectileList(j).tY) < 10 Then
                                FX_Projectile_Erase j
                            End If
                        End If
                    End If
                End If
            End If
        Next j
    End If
End Sub

Public Sub FX_Projectile_Create(ByVal AttackerIndex As Integer, ByVal TargetIndex As Integer, ByVal GrhIndex As Long, Optional ByVal velocidad As Single = 1)
Dim ProjectileIndex As Integer

    If AttackerIndex = 0 Then Exit Sub
    If TargetIndex = 0 Then Exit Sub
    If AttackerIndex > UBound(charlist) Then Exit Sub
    If TargetIndex > UBound(charlist) Then Exit Sub

    'Get the next open projectile slot
    Do
        ProjectileIndex = ProjectileIndex + 1
        
        'Update LastProjectile if we go over the size of the current array
        If ProjectileIndex > LastProjectile Then
            LastProjectile = ProjectileIndex
            ReDim Preserve ProjectileList(1 To LastProjectile)
            Exit Do
        End If
        
    Loop While ProjectileList(ProjectileIndex).Grh > 0
    
    'Figure out the initial rotation value
    'ProjectileList(ProjectileIndex).Rotate = Engine_GetAngle(charlist(AttackerIndex).pos.x, charlist(AttackerIndex).pos.y, charlist(TargetIndex).pos.x, charlist(TargetIndex).pos.y)
    
    'Fill in the values
    ProjectileList(ProjectileIndex).uid = TargetIndex
    ProjectileList(ProjectileIndex).tY = velocidad
    ProjectileList(ProjectileIndex).v = velocidad
    ProjectileList(ProjectileIndex).Grh = GrhIndex
    ProjectileList(ProjectileIndex).life = 0
    ProjectileList(ProjectileIndex).x = (charlist(AttackerIndex).Pos.x) * 32
    ProjectileList(ProjectileIndex).y = (charlist(AttackerIndex).Pos.y) * 32 - charlist(AttackerIndex).OffY
End Sub

Public Sub FX_Projectile_Create_pos(ByVal AttackerIndex As Integer, ByVal x As Byte, ByVal y As Byte, ByVal GrhIndex As Long, Optional ByVal velocidad As Single = 1)
Dim ProjectileIndex As Integer

    If AttackerIndex = 0 Then Exit Sub
    If AttackerIndex > UBound(charlist) Then Exit Sub


    'Get the next open projectile slot
    Do
        ProjectileIndex = ProjectileIndex + 1
        
        'Update LastProjectile if we go over the size of the current array
        If ProjectileIndex > LastProjectile Then
            LastProjectile = ProjectileIndex
            ReDim Preserve ProjectileList(1 To LastProjectile)
            Exit Do
        End If
        
    Loop While ProjectileList(ProjectileIndex).Grh > 0
    
    'Figure out the initial rotation value
    'ProjectileList(ProjectileIndex).Rotate = Engine_GetAngle(charlist(AttackerIndex).pos.x, charlist(AttackerIndex).pos.y, charlist(TargetIndex).pos.x, charlist(TargetIndex).pos.y)
    
    'Fill in the values
    ProjectileList(ProjectileIndex).uid = 0
    ProjectileList(ProjectileIndex).v = velocidad
    ProjectileList(ProjectileIndex).Grh = GrhIndex
    ProjectileList(ProjectileIndex).tX = x * 32
    ProjectileList(ProjectileIndex).tY = y * 32
    ProjectileList(ProjectileIndex).life = 0
    ProjectileList(ProjectileIndex).x = (charlist(AttackerIndex).Pos.x) * 32
    ProjectileList(ProjectileIndex).y = (charlist(AttackerIndex).Pos.y) * 32
End Sub

'
'
'Public Sub BFX_Load_All()
'    BFX_streams_last = 1
'    ReDim BFX_streams(0 To 1)
'    With BFX_streams(1)
'        .alpha_factor = 0.01
'        .alpha_inicial = 1
'        .clase = cilindro
'        .color1.r = 1
'        .color1.g = 1
'        .color1.b = 1
'        .color2.r = 1
'        .color2.g = 1
'        .color2.b = 1
'        .segmentos = 16
'        .textura = 20208
'        .texture_effect = SlideX
'        .radio = 64
'        .altura = 128
'    End With
'End Sub
'
'Public Function BFX_Create(ByVal tipo As Integer, Optional ByVal life As Single = 0) As Integer
'    Dim i%, ID%, tmp As Single
'    If BFX_streams_last < tipo Then Exit Function
'    If BFX_Last <> 0 Then
'        For i = 0 To BFX_Last
'            If BFX_List(i).active = False Then
'                ID = i
'                Exit For
'            End If
'        Next i
'    End If
'    If ID = 0 Then
'        BFX_Last = BFX_Last + 1
'        ID = BFX_Last
'        ReDim Preserve BFX_List(0 To BFX_Last)
'    End If
'    With BFX_List(ID)
'        .setup = 0
'        .active = 1
'        .die = life
'        .numverts = (BFX_streams(tipo).segmentos * 4)
'        .type = tipo
'        ReDim .verts(0 To .numverts - 1)
'        ReDim .vertsR(0 To .numverts - 1)
'        ReDim .verts_multiplo(0 To .numverts - 1)
'        tmp = .numverts / 360
'        For i = 0 To .numverts - 1
'            .verts_multiplo(i) = tmp * i
'        Next i
'    End With
'
'    BFX_Create = ID
'    Debug.Print "creado"; BFX_Create
'End Function
'
'Public Function BFX_Make(ByVal tipo As Integer, ByVal x As Byte, ByVal y As Byte, Optional ByVal life As Single = 0) As Integer
'    BFX_Make = BFX_Create(tipo, life)
'    If BFX_Make = 0 Then Exit Function
'    With BFX_List(BFX_Make)
'        .x = x
'        .y = y
'        'MapData(x, y).BFX = BFX_Make
'    End With
'End Function
'
'Public Sub BFX_Render_all(ByVal OffsetX As Integer, ByVal OffsetY As Integer)
'    Dim i%
'    If BFX_Last <> 0 Then
'        For i = 1 To BFX_Last
'            With BFX_List(i)
'                If .x <> 0 Then
'                    BFX_Render i, (.x - minX - TileBufferSize + 1) * 32 + OffsetX, (.y - minY - TileBufferSize + 1) * 32 + OffsetY
'                End If
'            End With
'        Next i
'    End If
'End Sub
'
'Public Sub BFX_Render(ByRef ID As Integer, ByVal OffsetX As Integer, ByVal OffsetY As Integer)
'
'    Dim tmp As Byte
'    If BFX_Last >= ID And ID <> 0 Then
'
'        If BFX_Update(ID, OffsetX, OffsetY) = 1 Then
'            With BFX_List(ID)
'                If .x <> 0 Then OffsetY = OffsetY - hMapData(.x, .y).alt
'                Call SurfaceDB.GetTexture(BFX_streams(.type).textura)
'                D3DDevice.SetTexture 0, Nothing
'                tmp = SurfaceDB.GetTexturePNG(BFX_streams(.type).textura)
'                If tmp = 0 Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_ONE
'                'rensder
'                If .numverts > 0 Then D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, .numverts, .vertsR(0), TL_size
'                If tmp = 0 Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
'            End With
'        Else
'            BFX_List(ID).active = 0
'            ID = 0
'        End If
'    End If
'End Sub
'
'Private Function BFX_Update(ByVal ID As Integer, ByVal OffsetX As Integer, ByVal OffsetY As Integer) As Byte
'    Dim i%
'    With BFX_List(ID)
'        If .setup = 0 Then setup_BFX ID
'        If BFX_streams(.type).clase = cilindro Then
'
'        ElseIf BFX_streams(.type).clase = estrella Then
'
'        Else
'            If BFX_streams(.type).texture_effect <> NoEffect Then
'
'            End If
'        End If
'        DXCopyMemory .vertsR(0), .verts(0), TL_size * (.numverts - 1)
'        For i = 0 To .numverts - 1
'            .vertsR(i).v.y = .vertsR(i).v.y + OffsetY
'            .vertsR(i).v.x = .vertsR(i).v.x + OffsetX
'        Next i
'
'    End With
'
'BFX_Update = 1
'End Function
'
'Private Sub setup_BFX(ByVal ID As Integer)
'    Dim multiplo360 As Single
'    Dim tmp As Single
'    Dim i%
'    Dim DeltaSegAngle As Double
'    Dim SegmentLength As Double
'    Dim X0 As Single, Z0 As Single
'    Dim alt As Boolean
'    With BFX_List(ID)
'        DeltaSegAngle = BFX_streams(.type).segmentos / 360 '(2# * Pi / BFX_streams(.type).segmentos)
'        SegmentLength = 1# / BFX_streams(.type).segmentos
'        If BFX_streams(.type).clase = cilindro Then
'            For i = 0 To .numverts - 1 Step 2
'                .verts(i).v.x = BFX_streams(.type).radio * Seno(i / 2 * DeltaSegAngle)
'                .verts(i).v.y = BFX_streams(.type).radio * Coseno(i / 2 * DeltaSegAngle) * Perspectiva
'                'alt = Not alt
'                .verts(i).tv = 1
'                .verts(i).tu = 3 / .numverts * i
'                .verts(i).rhw = 1
'                .verts(i).color = -1
'                If i = .numverts - 1 Then .verts(i) = .verts(0)
'            Next i
'            For i = 1 To .numverts - 1 Step 2
'                .verts(i).v.x = .verts(i - 1).v.x
'                .verts(i).v.y = .verts(i - 1).v.y - BFX_streams(.type).altura
'                .verts(i).tv = 0
'                .verts(i).tu = 3 / .numverts * i
'                .verts(i).rhw = 1
'                .verts(i).color = -1
'                If i = .numverts - 2 Then .verts(i) = .verts(1)
'            Next i
'            .setup = 1
'        ElseIf BFX_streams(.type).clase = estrella Then
'
'        End If
'    End With
'End Sub

Public Sub FX_Projectile_Erase(ByVal ProjectileIndex As Integer)
    ProjectileList(ProjectileIndex).Grh = 0
    ProjectileList(ProjectileIndex).x = 0
    ProjectileList(ProjectileIndex).y = 0
    ProjectileList(ProjectileIndex).tX = 0
    ProjectileList(ProjectileIndex).tY = 0
    ProjectileList(ProjectileIndex).uid = 0
    ProjectileList(ProjectileIndex).v = 0
 
    If ProjectileIndex = LastProjectile Then
        Do Until ProjectileList(ProjectileIndex).Grh > 1
            'Move down one projectile
            LastProjectile = LastProjectile - 1
            If LastProjectile = 0 Then Exit Do
        Loop
        If ProjectileIndex <> LastProjectile Then
            'We still have projectiles, resize the array to end at the last used slot
            If LastProjectile > 0 Then
                ReDim Preserve ProjectileList(1 To LastProjectile)
            Else
                Erase ProjectileList
            End If
        End If
    End If
 
End Sub

Public Sub FX_Projectile_Erase_All()
    If LastProjectile > 0 Then
        LastProjectile = 0
        Erase ProjectileList
    End If
End Sub

Public Sub FX_Rayo_Render()
Dim angle!, angle1!, j%, x!, y!, i%
Dim vert() As TLVERTEX
    If LastRay > 0 Then
        For j = 1 To LastRay
            With RayList(j)
                '.seg = .seg - 1
                If .seg > 1 Then
                    ReDim vert(0 To .seg)
                    With vert(0)
                        'COMENTAR'.color = RayList(J).color
                        .rhw = 1
                        .v.x = RayList(j).Pos.x + offset_map.x
                        .v.y = RayList(j).Pos.y + offset_map.y
                    End With
                    For i = 1 To .seg
                        With vert(i)
                            'COMENTAR'.color = RayList(J).color
                            .rhw = 1
                            .v.x = vert(i - 1).v.x + (1 - Rnd * 20) * 3 - (1 - Rnd * 20) * 3
                            .v.y = vert(i - 1).v.y - RayList(j).seg_size * Rnd + Rnd * 30 - Rnd * 30 + y
                        End With
                    Next i
                    'RayList(j).color = RayList(j).color And &HF000000
                    Call SurfaceDB.GetTexture(0)
                    'Call D3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_DESTALPHA)
                    'D3DDevice.SetPixelShader PS_Glow
                    D3DDevice.DrawPrimitiveUP D3DPT_LINESTRIP, .seg, vert(0), TL_size
                    'D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
                    'D3DDevice.SetPixelShader 0
                End If
            End With
            
            If RayList(j).seg <= 1 Then FX_Rayo_Erase j
        Next j
    End If
End Sub

Public Sub FX_Rayo_Create(ByVal mapx As Byte, ByVal mapy As Byte, ByVal segmentos As Long, Optional ByVal color As Long = &HFFFFFFFF)
    Dim Index As Integer
    Do
        Index = Index + 1
        If Index > LastRay Then
            LastRay = Index
            ReDim Preserve RayList(1 To LastRay)
            Exit Do
        End If
    Loop While RayList(Index).seg > 0
    
    RayList(Index).color = color
    RayList(Index).seg = segmentos
    RayList(Index).seg_size = 500 / segmentos
    RayList(Index).Pos.x = mapx * 32 + 16
    RayList(Index).Pos.y = mapy * 32 + 16
End Sub

Public Sub FX_Rayo_Erase(ByVal Index As Integer)
    If Index = LastRay Then
        Do Until RayList(Index).seg > 1
            'Move down one projectile
            LastRay = LastRay - 1
            If LastRay = 0 Then Exit Do
        Loop
        If Index <> LastRay Then
            'We still have projectiles, resize the array to end at the last used slot
            If LastRay > 0 Then
                ReDim Preserve RayList(1 To LastRay)
            Else
                Erase RayList
            End If
        End If
    End If
End Sub
Public Sub FX_Rayo_Erase_All()
    If LastRay > 0 Then
        LastRay = 0
        Erase RayList
    End If
End Sub

Public Sub FX_Def_Create(ByVal x As Byte, ByVal y As Byte, ByVal radio As Byte)
    Dim Index As Integer
    Do
        Index = Index + 1
        If Index > last_def Then
            last_def = Index
            ReDim Preserve def_list(1 To last_def)
            Exit Do
        End If
    Loop While def_list(Index).vida > 0
    
    With def_list(Index)
        .don.x = x
        .don.y = y
        .don.W = radio
        .don.Z = radio
        .freq = 1 'Val(frmMain.Text3.Text)
        .vida = 10 'Val(frmMain.Text2.Text)
    End With
End Sub

Private Sub FX_Def_Erase(ByVal Index As Integer)
    With def_list(Index)
        .don.x = 0
        .don.y = 0
        .don.W = 0
        .don.Z = 0
        .freq = 0
        .vida = 0
    End With
 
    If Index = last_def Then
        Do Until def_list(Index).vida > 0
            last_def = last_def - 1
            If last_def = 0 Then Exit Do
        Loop
        If Index <> last_def Then
            If last_def > 0 Then
                ReDim Preserve def_list(1 To last_def)
            End If
        End If
    End If
 
End Sub

Public Sub FX_Def_Render_All()
    Dim i As Integer
    Dim tamaño_ As Long
    If last_def > 0 Then
        For i = 1 To last_def: Call FX_Def_Render(i): Next i
        If last_def = 0 Then
            tamaño_ = Len(hMapData(1, 1)) * 100& * 100&
            Call DXCopyMemory(hMapData(1, 1), hMapDataORIGINAL(1, 1), tamaño_)
        End If
    End If
End Sub

Private Sub FX_Def_Render(ByVal Index As Integer)
    Dim x As Byte, y As Single, Z As Byte
    With def_list(Index)
        If .vida > 0 Then
            .vida = .vida - timerElapsedTime * 0.005
            For x = .don.x - .don.W To .don.x + .don.W
                For Z = .don.y - .don.W To .don.y + .don.W
                    If minX < x And minY < Z And maxX > x And maxY > Z Then
                        y = Sqr(((x - .don.x - 0.5) * (x - .don.x - 0.5) + (Z - .don.y - 1) * (Z - .don.y - 1)))
                        If y < .don.W And hMapData(x, Z).alt = 0 Then
                            hMapData(x, Z).plus(1) = .don.Z * (.don.W - y) * 0.1 * .vida * Sin(.freq * (y - .vida))
                            
                            hMapData(x - 1, Z - 1).plus(2) = hMapData(x, Z).plus(1)
                            hMapData(x, Z - 1).plus(0) = hMapData(x, Z).plus(1)
                            hMapData(x - 1, Z).plus(3) = hMapData(x, Z).plus(1)
                        End If
                    End If
                Next Z
            Next x
            If .vida <= 0 Then FX_Def_Erase Index
        End If
    End With
End Sub

'Public Sub BFX_Kill(ByVal ID As Integer, Optional ByVal life As Single = 1)
'
'End Sub
'
'Public Sub BFX_Remove_All()
'    ReDim BFX_List(0)
'    BFX_Last = 0
'End Sub
