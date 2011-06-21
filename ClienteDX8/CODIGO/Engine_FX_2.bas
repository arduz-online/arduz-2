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


Public Type Projectile
    x As Single
    y As Single
    tX As Single
    tY As Single
    v As Single
    uid As Integer
    Grh As Integer
    life As Single
    luz As Integer
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

Public Type hits
    active  As Byte
End Type

Public HitList() As hits
Public LastHit As Integer


Public Sub FX_Hit_Create(ByVal cid As Integer, ByVal hit As Integer, ByVal vida As Long, ByVal color As Long)

End Sub

Public Sub FX_Hit_Erase(ByVal Index As Integer)

End Sub

Public Sub FX_Hit_Erase_All()

End Sub

Public Sub FX_Hit_Render()

End Sub


Public Sub Projectile_Render()

End Sub

Public Sub FX_Projectile_Create(ByVal AttackerIndex As Integer, ByVal TargetIndex As Integer, ByVal GrhIndex As Long, Optional ByVal velocidad As Single = 1)
End Sub

Public Sub FX_Projectile_Create_pos(ByVal AttackerIndex As Integer, ByVal x As Byte, ByVal y As Byte, ByVal GrhIndex As Long, Optional ByVal velocidad As Single = 1)
End Sub

Public Sub FX_Projectile_Erase(ByVal ProjectileIndex As Integer)

End Sub

Public Sub FX_Projectile_Erase_All()

End Sub

Public Sub FX_Rayo_Render()
Dim j%, y!, i%
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
                    Call GetTexture(0)
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
        .don.w = radio
        .don.z = radio
        .freq = 1 'Val(frmMain.Text3.Text)
        .vida = 10 'Val(frmMain.Text2.Text)
    End With
End Sub



Public Sub FX_Def_Render_All()

End Sub
