VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Engine_UI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private hotbar_tl(3) As TLVERTEX
Private Hotbar_rect(7) As sRECT

Public rank_visible As Byte
Public acc_visible As Byte
Public hotbar_visible As Byte

Event ClickAcc(pj_id As Integer)
Event ClickHotBar(h_id As Integer, c_id As Integer)

Private Sub Class_Initialize()
    Dim i As Integer
    hotbar_visible = 255
    acc_visible = 255
    
    hotbar_tl(1) = Geometry_Create_TLVertex(52, 348, &HFFFFFFFF, 0, 0)
    hotbar_tl(3) = Geometry_Create_TLVertex(459, 348, &HFFFFFFFF, 1.25798525798526, 0)
    hotbar_tl(0) = Geometry_Create_TLVertex(52, 412, &HFFFFFFFF, 0, 1)
    hotbar_tl(2) = Geometry_Create_TLVertex(459, 412, &HFFFFFFFF, 1.25798525798526, 1)

    
    Hotbar_rect(1).left = 140
    Hotbar_rect(2).left = 172
    Hotbar_rect(3).left = 204
    Hotbar_rect(4).left = 236
    Hotbar_rect(5).left = 268
    Hotbar_rect(6).left = 300
    Hotbar_rect(7).left = 338
    
    For i = 1 To 7
        With Hotbar_rect(i)
            .top = 26 + 348
            .left = .left + 16
            .bottom = .top + 38
            .right = .left + 32
        End With
    Next i
    
    Hotbar_rect(6).right = Hotbar_rect(6).right + 6
    Hotbar_rect(7).right = Hotbar_rect(7).right + 6
End Sub

Public Sub Render()
    Dim i As Byte
    Dim b As Byte
    Dim c As Byte
    Dim x As Single
    Dim y As Single
    Static lasth As Single
    
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
    
    If rank_visible Then
        Dim isa As Integer
        y = 100
        Draw_FilledBox 20, 90, 460, lasth, &H44000000, &H55000000, 2
    
        Text_Render 1, CStr("Ping: " & pinga & " ms. FPS: " & CInt(1000 / timerElapsedTime)), y, 30, 120, 20, &HFFFFFF00, DT_TOP Or DT_LEFT, False
        For i = 2 To 0 Step -1
        'i = Abs(isa - 2)
            If Ekipos(i).num > 0 Then
                y = y + 20
                Call Text_Render_ext(Ekipos(i).Nombre, y, 30, 100, 20, Ekipos(i).color)
                Call Text_Render_ext("Frags", y, 250, 50, 20, Ekipos(i).color)
                Call Text_Render_ext("Muertes", y, 300, 60, 20, Ekipos(i).color)
                Call Text_Render_ext("Puntos", y, 360, 55, 20, Ekipos(i).color)
                Call Text_Render_ext("Ping", y, 430, 40, 20, Ekipos(i).color)
                For x = 1 To Ekipos(i).num
                    If Ekipos(i).personajes(x) > -1 Then
                        y = y + 20
                        With pjs(Ekipos(i).personajes(x))
                            Call Text_Render_ext(.Nick & IIf(LenB(.clan), " <" & .clan & ">", ""), y, 40, 300, 20, IIf(.gm = False, Ekipos(i).color, &HFF00FF00))
                            If .bot = False Then
                                Call Text_Render_ext(.frags, y, 250, 25, 20, Ekipos(i).color)
                                Call Text_Render_ext(.muertes, y, 300, 25, 20, Ekipos(i).color)
                                Call Text_Render_ext(.Puntos, y, 360, 50, 20, Ekipos(i).color)
                                Call Text_Render_ext(.Ping & "ms.", y, 430, 50, 20, Ekipos(i).color)
                            End If
                        End With
                    End If
                Next x
            End If
        Next i
        lasth = y - 60
    ElseIf acc_visible Then
        Draw_FilledBox 20, 70, 500, lasth, &H44000000, &H55000000, 2
        x = 60
        y = 100
        For i = 1 To 2
            For b = 1 To 5
                c = c + 1
                If c > web_pjs_count Then Exit For
                With web_pjs(c)
                    If .Body.Walk(3).GrhIndex Then
                        Call Grh_Render_nocolor(GrhData(.Body.Walk(3).GrhIndex).Frames(1), x, y)
                        Call Grh_Render_nocolor(.Head.Head(3).GrhIndex, x + .Body.HeadOffset.x + 4, y + .Body.HeadOffset.y + 29)
                        If .Casco.Head(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.Casco.Head(3).GrhIndex).Frames(1), x + .Body.HeadOffset.x + 4, y + .Body.HeadOffset.y + 14)
                        If .Arma.WeaponWalk(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.Arma.WeaponWalk(3).GrhIndex).Frames(1), x, y)
                        If .Escudo.ShieldWalk(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.Escudo.ShieldWalk(3).GrhIndex).Frames(1), x, y)
                        Text_Render_ext .name, y + 48, x - 35, 100, 22, &HFFFFFFFF, True, True
                        If StrComp(.clan, "NOCLAN") Then Text_Render_ext "<" & .clan & ">", y + 60, x - 35, 100, 22, &HFFFFFFFF, True, True
                    End If
                End With
                x = x + 100
            Next b
            If c > web_pjs_count Then Exit For
            x = 60
            y = y + 100
        Next i
        lasth = y
    End If
    If hotbar_visible Then
        Call SurfaceDB.GetTexture(9721)
        D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, hotbar_tl(0), TL_size
    End If
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub

