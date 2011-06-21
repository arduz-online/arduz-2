Attribute VB_Name = "Engine_UI"
Option Explicit
Option Base 0

Private hotbar_tl(3) As TLVERTEX
Private Hotbar_rect(7) As sRECT
Private hotbar_bttl(0 To 2, 0 To 3) As TLVERTEX

Public rank_visible As Byte
Public acc_visible As Byte
Public hotbar_visible As Byte
Public chat_text_visible As Byte

Public Special_slots(5) As Integer
Public Special_slots_rect(5) As sRECT

Public pj_over_mouse As Integer
Public pj_selecc As Integer

Private button_over As Integer

Public Sub init_special_slots()
    Dim i As Integer
    
    With Special_slots_rect(0)
    .Top = 4
    .Left = 153
    End With
    With Special_slots_rect(1)
    .Top = 55
    .Left = 153
    End With
    With Special_slots_rect(2)
    .Top = 108
    .Left = 153
    End With
    With Special_slots_rect(3)
    .Top = 154
    .Left = 4
    End With
    With Special_slots_rect(4)
    .Top = 154
    .Left = 57
    End With
    With Special_slots_rect(5)
    .Top = 154
    .Left = 106
    End With
    
    For i = 0 To 5
        With Special_slots_rect(i)
            .Bottom = .Top + 42
            .Right = .Left + 42
        End With
    Next i

    'hotbar_visible = 255
    'acc_visible = 255
    
    hotbar_tl(1) = Geometry_Create_TLVertex(52, 348, &HFFFFFFFF, 0, 0)
    hotbar_tl(3) = Geometry_Create_TLVertex(459, 348, &HFFFFFFFF, 0.794921875, 0)
    hotbar_tl(0) = Geometry_Create_TLVertex(52, 412, &HFFFFFFFF, 0, 1)
    hotbar_tl(2) = Geometry_Create_TLVertex(459, 412, &HFFFFFFFF, 0.794921875, 1)
    
    hotbar_bttl(0, 1) = Geometry_Create_TLVertex(0, 0, &HFFFFFFFF, 0.8125, 0)
    hotbar_bttl(0, 3) = Geometry_Create_TLVertex(0, 32, &HFFFFFFFF, 0.875, 0)
    hotbar_bttl(0, 0) = Geometry_Create_TLVertex(38, 0, &HFFFFFFFF, 0.8125, 0.5)
    hotbar_bttl(0, 2) = Geometry_Create_TLVertex(38, 32, &HFFFFFFFF, 0.875, 0.5)
    
    hotbar_bttl(0, 1) = Geometry_Create_TLVertex(0, 0, &HFFFFFFFF, 0.875, 0)
    hotbar_bttl(0, 3) = Geometry_Create_TLVertex(0, 32, &HFFFFFFFF, 0.9375, 0)
    hotbar_bttl(0, 0) = Geometry_Create_TLVertex(38, 0, &HFFFFFFFF, 0.875, 0.5)
    hotbar_bttl(0, 2) = Geometry_Create_TLVertex(38, 32, &HFFFFFFFF, 0.9375, 0.5)
    
    hotbar_bttl(2, 1) = Geometry_Create_TLVertex(0, 0, &HFFFFFFFF, 0.9375, 0)
    hotbar_bttl(2, 3) = Geometry_Create_TLVertex(0, 32, &HFFFFFFFF, 1, 0)
    hotbar_bttl(2, 0) = Geometry_Create_TLVertex(38, 0, &HFFFFFFFF, 0.9375, 0.5)
    hotbar_bttl(2, 2) = Geometry_Create_TLVertex(38, 32, &HFFFFFFFF, 1, 0.5)
    
    Hotbar_rect(1).Left = 140
    Hotbar_rect(2).Left = 172
    Hotbar_rect(3).Left = 204
    Hotbar_rect(4).Left = 236
    Hotbar_rect(5).Left = 268
    Hotbar_rect(6).Left = 300
    Hotbar_rect(7).Left = 338
    
    For i = 1 To 7
        With Hotbar_rect(i)
            .Top = 26 + 348
            .Left = .Left + 16
            .Bottom = .Top + 38
            .Right = .Left + 32
        End With
    Next i
    
    Hotbar_rect(6).Right = Hotbar_rect(6).Right + 6
    Hotbar_rect(7).Right = Hotbar_rect(7).Right + 6
End Sub

Public Sub Render_GUI()
cfnc = fnc.E_RENDER_UI
    Dim i As Integer
    Dim b As Byte
    Dim c As Byte
    Dim x As Single
    Dim y As Single
    Dim color As Long
    Static lasth As Single
    Dim lcbk As Long
    lcbk = lColorMod
    lColorMod = D3DTOP_MODULATE
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
    Render_Radio_Luz = False
    'If UserEstado = 1 Then Render_Radio_Luz = True
    If rank_visible Then
        y = 100
        Draw_FilledBox 20, 90, 460, lasth, &H44000000, &H55000000, 2
        
        If timerElapsedTime < Epsilon Then timerElapsedTime = Epsilon
On Local Error Resume Next
        Text_Render 1, CStr("Ping: " & pinga & " ms. FPS: " & CInt(1000 / timerElapsedTime)), y, 30, 120, 20, &HFFFFFF00, DT_TOP Or DT_LEFT, False
On Local Error GoTo 0
        For i = 2 To 0 Step -1
        'i = Abs(isa - 2)
            If Ekipos(i).num > 0 Then
                y = y + 16
                Call Text_Render_ext(Ekipos(i).Nombre, y, 30, 100, 20, Ekipos(i).color)
                Call Text_Render_ext("Frags", y, 250, 50, 20, Ekipos(i).color)
                Call Text_Render_ext("Muertes", y, 300, 60, 20, Ekipos(i).color)
                Call Text_Render_ext("Puntos", y, 360, 55, 20, Ekipos(i).color)
                Call Text_Render_ext("Ping", y, 430, 40, 20, Ekipos(i).color)
                y = y + 5
                For x = 1 To Ekipos(i).num
                    If Ekipos(i).personajes(x) > -1 Then
                        y = y + 10
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
        Render_Radio_Luz = True
        Draw_FilledBox 20, 70, 500, lasth, &H7F000000, &H55CCCCCC, 2
        x = 60
        y = 100
        On Local Error Resume Next
        For i = 1 To 2
            For b = 1 To 5
                c = c + 1
                If c > web_pjs_count Then Exit For
                With web_pjs(c)
                    If pj_selecc = c Then
                        Call Draw_FilledBox(x - 39, y - 29, 98, 98, &H3300CC00, &H2200FF00, 1)
                    End If
                    
                    If .Body.Walk(3).GrhIndex Then
                        Call Grh_Render_nocolor(GrhData(.Body.Walk(3).GrhIndex).Frames(1), x, y)
                        If .Head.Head(3).GrhIndex Then _
                            Call Grh_Render_nocolor(.Head.Head(3).GrhIndex, x + .Body.HeadOffset.x + 4, y + .Body.HeadOffset.y + 29)
                        If .Casco.Head(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.Casco.Head(3).GrhIndex).Frames(1), x + .Body.HeadOffset.x + 4, y + .Body.HeadOffset.y + 14)
                        'If .arma.WeaponWalk(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.arma.WeaponWalk(3).GrhIndex).Frames(1), x, y)
                        If .Escudo.ShieldWalk(3).GrhIndex Then _
                            Call Grh_Render_nocolor(GrhData(.Escudo.ShieldWalk(3).GrhIndex).Frames(1), x, y)
                    End If
                    
                    If .Faccion >= 1 And .Faccion <= 10 Then
                        color = &HFF00C3FF
                    ElseIf .Faccion > 10 And .Faccion <= 20 Then
                        color = &HFFC83200
                    ElseIf .Faccion = 128 Then
                        color = &HCFCCCCCC
                    Else
                        color = &HFFFFFFFF
                    End If
                    
                    If pj_over_mouse = c Then
                        Call Draw_FilledBox(x - 39, y - 29, 98, 98, &H33000000, &H22CCCCCC, 1)
                    End If
                    
                    Text_Render_ext .name, y + 48, x + 10, 100, 22, color, False, True
                    If StrComp(.clan, "NOCLAN") Then Text_Render_ext "<" & .clan & ">", y + 60, x + 10, 100, 22, color, False, True
                
                End With
                x = x + 100
            Next b
            If c > web_pjs_count Then Exit For
            x = 60
            y = y + 100
        Next i
        On Local Error GoTo 0
        lasth = y
        If button_over = eKip.ePK Then
            Draw_FilledBox 20, 275, 250, 64, &HFFC83200, &H22FFCCCC, 2
        Else
            Draw_FilledBox 20, 275, 250, 64, &H7FC83200, &H22FFCCCC, 2
        End If
        If button_over = eKip.eCUI Then
            Draw_FilledBox 270, 275, 250, 64, &HFF00C3FF, &H22CCCCFF, 2
        Else
            Draw_FilledBox 270, 275, 250, 64, &H7F00C3FF, &H22CCCCFF, 2
        End If
    Else
        If hotbar_visible Then
            Call GetTexture(9721)
            D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, hotbar_tl(0), TL_size
        End If
    End If
        
    lColorMod = lcbk
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub

Public Sub GUI_Click(ByVal x As Integer, ByVal y As Integer, ByVal Button As Integer)
    If acc_visible Then
        If x > 20 And x < 520 Then
            If y > 70 And y < 270 Then
                If pj_over_mouse > 0 And pj_over_mouse <= web_pjs_count Then
                    pj_selecc = pj_over_mouse
                End If
            ElseIf y > 270 And y < 334 Then
                If pj_selecc > 0 And button_over > 0 Then WriteSelectAccPJ button_over, pj_selecc
                
            End If
        End If
    End If
End Sub

Public Sub GUI_Mouse_Move(ByVal x As Integer, ByVal y As Integer, ByVal Button As Integer)
pj_over_mouse = 0
button_over = 0
If acc_visible Then
    If x > 20 And x < 520 Then
        If y > 70 And y < 270 Then
            pj_over_mouse = (x - 20) \ 100 + ((y - 70) \ 100) * (500 \ 100) + 1
        ElseIf y > 270 And y < 334 Then
            If x > 250 Then button_over = eKip.eCUI
            If x < 250 Then button_over = eKip.ePK
        End If
    End If
End If
End Sub

Public Sub Handle_Key(KeyCode As Integer, Shift As Integer)

End Sub

Public Sub Handle_KeyP(KeyCode As Integer)

End Sub

Public Sub toggle_render_text_indicator()

End Sub

