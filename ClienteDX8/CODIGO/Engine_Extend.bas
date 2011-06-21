Attribute VB_Name = "Engine_Extend"

Option Explicit

Public user_screen_pos As D3DVECTOR2

Public Type tArmas
    texture(5) As Integer
    textures As Byte
    num As Integer
End Type

Public Type Arma_act
    num         As Integer
    TEX_FLAGS   As Byte
    mano        As Byte
End Type

Public lista_armas(30) As tArmas

Public weapon_array() As Box_Vertex
Public fix_heading(1 To 4) As Integer


Public Sub Engine_SortIntArray(TheArray() As Integer, TheIndex() As Integer, ByVal LowerBound As Integer, ByVal UpperBound As Integer)
    Dim indxt As Long   'Stored index
    Dim swp As Integer  'Swap variable
    Dim i As Integer    'Subarray Low  Scan Index
    Dim j As Integer    'Subarray High Scan Index

    'Start the loop
    For j = LowerBound + 1 To UpperBound
        indxt = TheIndex(j)
        swp = TheArray(indxt)
        For i = j - 1 To LowerBound Step -1
            If TheArray(TheIndex(i)) <= swp Then Exit For
            TheIndex(i + 1) = TheIndex(i)
        Next i
        TheIndex(i + 1) = indxt
    Next j

End Sub

Public Function interpolar(a!, b!, t!) As Single
interpolar = a + t * (b - a)
End Function


Public Sub Engine_MoveScreen(ByVal nHeading As E_Heading)
'******************************************
'Starts the screen moving in a direction
'******************************************
    Dim x As Integer
    Dim y As Integer
    Dim tX As Integer
    Dim tY As Integer
    
    'Figure out which way to move
    Select Case nHeading
        Case E_Heading.north
            y = -1
        
        Case E_Heading.east
            x = 1
        
        Case E_Heading.south
            y = 1
        
        Case E_Heading.west
            x = -1
    End Select
    
    'Fill temp pos
    tX = UserPos.x + x
    tY = UserPos.y + y
    
    'Check to see if its out of bounds
    If tX < MinXBorder Or tX > MaxXBorder Or tY < MinYBorder Or tY > MaxYBorder Then
        Exit Sub
    Else
        'Start moving... MainLoop does the rest
        AddtoUserPos.x = x
        UserPos.x = tX
        AddtoUserPos.y = y
        UserPos.y = tY
        UserMoving = 1
        
        bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    End If
End Sub

Public Sub Engine_MoveScreen2pos(ByVal nx As Byte, ByVal ny As Byte)
'******************************************
'Starts the screen moving in a direction
'******************************************
    Dim x!
    Dim y!
    Dim tX!
    Dim tY!
    Dim addx As Integer
    Dim addy As Integer
    Dim nHeading As E_Heading
    'Figure out which way to move

    addx = nx - UserPos.x
    addy = ny - UserPos.y

    tX = nx
    tY = ny

    'Check to see if its out of bounds
    If tX < MinXBorder Or tX > MaxXBorder Or tY < MinYBorder Or tY > MaxYBorder Then
        Exit Sub
    Else
        'Start moving... MainLoop does the rest
        AddtoUserPos.x = addx
        UserPos.x = tX
        AddtoUserPos.y = addy
        UserPos.y = tY
        'UserMoving = 1

        bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    End If
End Sub


Public Function Char_Pos_Get(ByVal char_index As Integer, ByRef map_x As Integer, ByRef map_y As Integer) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'*****************************************************************
   'Make sure it's a legal char_index
    If Char_Check(char_index) Then
        map_x = charlist(char_index).Pos.x
        map_y = charlist(char_index).Pos.y
        Char_Pos_Get = True
    End If
End Function

Public Sub Char_Start_Anim(ByVal CharIndex As Long)
    With charlist(CharIndex)
        .arma.WeaponWalk(.Heading).Started = 1
        .Escudo.ShieldWalk(.Heading).Started = 1
        .attaking = 255
    End With
End Sub

Public Sub Char_Jump(ByVal CharIndex As Long, Optional ByVal onda As Byte = 0)
    With charlist(CharIndex)
        If .vec.y <> 0 Then Exit Sub
        .ace.y = -6
        .spd.y = -100
        .do_onda = onda
        If onda > 0 Then Call Audio.Sound_Play(65)
    End With
End Sub

Public Sub Char_Render(ByVal CharIndex As Long)
cfnc = fnc.E_Char_Render
    Dim moved As Boolean
    Dim Pos As Integer
    Dim line As String
    Dim iRender As Boolean
    Dim PixelOffsetX As Single
    Dim PixelOffsetY As Single
    Dim Yas As Integer
    Dim alphaname As Byte
    If CharIndex > 255 Then Exit Sub
    If CharIndex < 1 Then Exit Sub
    With charlist(CharIndex)
        If .rcrc = RENDERCRC Then Exit Sub
        .rcrc = RENDERCRC
        If .Pos.x = 0 Then Exit Sub
        If .velocidad.x = 0 Then
            .velocidad.x = ScrollPixelsPerFrameX
            .velocidad.y = ScrollPixelsPerFrameY
        End If
        If .Heading = 0 Then .Heading = 1
        If .Moving Then
            'If needed, move left and right

            If .scrollDirectionX <> 0 Then
                .MoveOffsetX = .MoveOffsetX + .velocidad.x * Sgn(.scrollDirectionX) * timerTicksPerFrame
                'Char moved
                moved = True
                
                'Check if we already got there
                If (Sgn(.scrollDirectionX) = 1 And .MoveOffsetX >= 0) Or _
                        (Sgn(.scrollDirectionX) = -1 And .MoveOffsetX <= 0) Then
                    .MoveOffsetX = 0
                    .scrollDirectionX = 0
                End If
            End If
            
            'If needed, move up and down
            If .scrollDirectionY <> 0 Then
                .MoveOffsetY = .MoveOffsetY + .velocidad.y * Sgn(.scrollDirectionY) * Round(timerTicksPerFrame, 3)
                'Char moved
                moved = True
                
                'Check if we already got there
                If (Sgn(.scrollDirectionY) = 1 And .MoveOffsetY >= 0) Or _
                        (Sgn(.scrollDirectionY) = -1 And .MoveOffsetY <= 0) Then
                    .MoveOffsetY = 0
                    .scrollDirectionY = 0
                End If
            End If
        End If
        
        'If done moving stop animation
        If Not moved Then
            'Stop animations
            
            .Body.Walk(.Heading).Started = 0
            .Body.Walk(.Heading).FrameCounter = 1
            
            If .invh Then
                If Not .attaking Then
                    .arma.WeaponWalk(.invheading).Started = 0
                    .arma.WeaponWalk(.invheading).FrameCounter = 1
                    
                    .Escudo.ShieldWalk(.invheading).Started = 0
                    .Escudo.ShieldWalk(.invheading).FrameCounter = 1
                End If
            Else
                If Not .attaking Then
                    .arma.WeaponWalk(.Heading).Started = 0
                    .arma.WeaponWalk(.Heading).FrameCounter = 1
                    
                    .Escudo.ShieldWalk(.Heading).Started = 0
                    .Escudo.ShieldWalk(.Heading).FrameCounter = 1
                End If
            End If
            .Moving = False
        Else
            If .Body.Walk(.Heading).speed > 0 Then _
                .Body.Walk(.Heading).Started = 1
                
            If .invh Then
                .arma.WeaponWalk(.invheading).Started = 1
                .Escudo.ShieldWalk(.invheading).Started = 1
            Else
                .arma.WeaponWalk(.Heading).Started = 1
                .Escudo.ShieldWalk(.Heading).Started = 1
            End If
            
            .attaking = 0
            
            If .luz Then
                Call Light_Move(.luz, .Pos.x, .Pos.y, .MoveOffsetX, .MoveOffsetY)
            End If
        End If
        

        If CharIndex = UserCharIndex Then
            PixelOffsetX = user_screen_pos.x
            PixelOffsetY = user_screen_pos.y
        Else
            PixelOffsetX = .Pos.x * 32 + .MoveOffsetX + offset_map.x
            PixelOffsetY = .Pos.y * 32 + .MoveOffsetY + offset_map.y
        End If
        
        .mppos.x = PixelOffsetX - offset_map.x
        .mppos.y = PixelOffsetY - offset_map.y
        
        Yas = .Pos.y - .OffY / 32
        If MouseTileX - .Pos.x = 0 And (MouseTileY - Yas = 0 Or MouseTileY - Yas = -1) Then Protocol.aim_pj = CharIndex Xor 105
        
        If .Head.Head(.Heading).GrhIndex Then
            iRender = True
            If .invisible Then
                If .iBody = 58 Then
                    iRender = False
                Else
                    '.alpha = 126 * (Coseno(.alphacounter Mod 360) + 1) + 1
                    On Local Error GoTo asddd
                    If Seno(.alphacounter Mod 360) < 0 Then
                    .alpha = -126 * (Seno(.alphacounter Mod 360)) + 1 '(1008 * (Cos(.alphacounter) + 1)) / (.alphacounter + 8) + 1
                    Else
asddd:
                    .alpha = 1
                    End If
                    On Local Error GoTo 0
                    .alphacounter = .alphacounter + timerTicksPerFrame * 2
                    If .alphacounter > 36000 Then .alphacounter = .alphacounter - 36000
                End If
            Else
                .alpha_sentido = False
                .alpha = 0
                .alphacounter = 0
            End If

            'Draw Body
            If iRender Then
                alphaname = min(255, (&HFF + ((-1& Or &HFF00FFFF) / &H10000)) + 64)
                
                If .muerto Then
                    If .Body.Walk(.Heading).GrhIndex Then _
                        Call Draw_Grh_Alpha(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, 100, .Pos.x, .Pos.y, 1)
                    If .Head.Head(.Heading).GrhIndex Then _
                        Call Draw_Grh_Alpha(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, 100, .Pos.x, .Pos.y, 1)

                    If LenB(.Nombre) > 0 And Nombres = True Then
                        If Abs(MouseTileX - .Pos.x) < 2 And (Abs(MouseTileY - .Pos.y)) < 2 Then
                            Pos = InStr(.Nombre, "<")
                            If Pos = 0 Then Pos = Len(.Nombre) + 2
                            'Nick
                            line = Left$(.Nombre, Pos - 2)
                            Call Text_Render_alpha(line, PixelOffsetY + 30, PixelOffsetX + 16, .color, DT_CENTER, alphaname)
                            
                            'Clan
                            line = mid$(.Nombre, Pos)
                            Call Text_Render_alpha(line, PixelOffsetY + 45, PixelOffsetX + 16, .color, DT_CENTER, alphaname)
                        End If
                    End If
                Else
                    If .alpha = 0 Then
                        draw_char CharIndex, PixelOffsetX, PixelOffsetY, 1

                        If LenB(.Nombre) > 0 Then
                            If (Abs(MouseTileX - .Pos.x) < 2 And (Abs(MouseTileY - .Pos.y)) < 2) Or Nombres = True Then
                                Pos = InStr(.Nombre, "<")
                                If Pos = 0 Then Pos = Len(.Nombre) + 2
        
                                'Nick
                                line = Left$(.Nombre, Pos - 2)
                                Call Text_Render_alpha(line, PixelOffsetY + 30, PixelOffsetX + 16, .color, DT_CENTER, alphaname)
                                
                                'Clan
                                line = mid$(.Nombre, Pos)
                                Call Text_Render_alpha(line, PixelOffsetY + 45, PixelOffsetX + 16, .color, DT_CENTER, alphaname)
                            End If
                        End If
                    Else
                        draw_char_alpha CharIndex, PixelOffsetX, PixelOffsetY, .alpha
                    End If
                End If
            End If
            
        Else
            'Draw Body
            If .Body.Walk(.Heading).GrhIndex Then _
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1)
        End If

        ''Update dialogs
        Call Dialogos.UpdateDialogPos(PixelOffsetX + .Body.HeadOffset.x + 48, PixelOffsetY + .Body.HeadOffset.y, CharIndex)
        'Call Hits.UpdateDialogPos(PixelOffsetX + .Body.HeadOffset.X + 5, PixelOffsetY, CharIndex)

        'Draw FX
        If .FxIndex <> 0 Then
            Call Draw_Grh(.fx, PixelOffsetX + FxData(.FxIndex).OffsetX, PixelOffsetY + FxData(.FxIndex).OffsetY, 1, 1, .Pos.x, .Pos.y, 1)

            If .fx.Started = 0 Then _
                .FxIndex = 0
        End If
        
        If .hit_act = 1 Then
            .hit_off = .hit_off - timerTicksPerFrame * 3
            If .hit_off > -32 Then
                Call Text_Render_alpha(CStr(.hit), PixelOffsetY + 10 + .hit_off, PixelOffsetX + 24, .hit_color, DT_TOP Or DT_CENTER, CByte(255 - .hit_off * -4))
            Else
                .hit_act = 0
                .hit_off = 0
            End If
        End If
    End With
End Sub

Private Function min(ByVal val1 As Long, ByVal val2 As Long) As Long
'***************************************************
'Autor: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/27/06
'It's faster than iif and I like it better
'***************************************************
    If val1 < val2 Then
        min = val1
    Else
        min = val2
    End If
End Function

Private Function Char_Check(ByVal char_index As Integer) As Boolean
    Char_Check = charlist(char_index).active = 1
End Function

Private Sub draw_char(ByVal ID As Integer, ByVal PixelOffsetX!, ByVal PixelOffsetY!, Optional ByVal shadow As Byte = 0)
'Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
With charlist(ID)
    If .Body.Walk(.Heading).GrhIndex Then
        Select Case .Heading
            Case south
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1)
                Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                If .Casco.Head(.Heading).GrhIndex Then _
                    Call Draw_Grh(.Casco.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                #If NuevaVersion = 0 Then
                    If .arma.WeaponWalk(.invheading).GrhIndex Then _
                        Call Draw_Grh(.arma.WeaponWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                #Else
                    Render_Armas ID, PixelOffsetX, PixelOffsetY
                #End If
                If .Escudo.ShieldWalk(.invheading).GrhIndex Then _
                    Call Draw_Grh(.Escudo.ShieldWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
            Case north
                #If NuevaVersion = 0 Then
                    If .arma.WeaponWalk(.invheading).GrhIndex Then _
                        Call Draw_Grh(.arma.WeaponWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                #Else
                    Render_Armas ID, PixelOffsetX, PixelOffsetY
                #End If
                If .Escudo.ShieldWalk(.invheading).GrhIndex Then _
                    Call Draw_Grh(.Escudo.ShieldWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1)
                If .Casco.Head(.Heading).GrhIndex Then _
                    Call Draw_Grh(.Casco.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
            Case east
                #If NuevaVersion = 0 Then
                    If .arma.WeaponWalk(.invheading).GrhIndex Then _
                        Call Draw_Grh(.arma.WeaponWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                #Else
                    Render_Armas ID, PixelOffsetX, PixelOffsetY
                #End If
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1)
                Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                If .Casco.Head(.Heading).GrhIndex Then _
                    Call Draw_Grh(.Casco.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                If .Escudo.ShieldWalk(.invheading).GrhIndex Then _
                    Call Draw_Grh(.Escudo.ShieldWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
            Case west
                If .Escudo.ShieldWalk(.invheading).GrhIndex Then _
                    Call Draw_Grh(.Escudo.ShieldWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1)
                Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                If .Casco.Head(.Heading).GrhIndex Then _
                    Call Draw_Grh(.Casco.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, .Pos.x, .Pos.y, 1)
                #If NuevaVersion = 0 Then
                    If .arma.WeaponWalk(.invheading).GrhIndex Then _
                        Call Draw_Grh(.arma.WeaponWalk(.invheading), PixelOffsetX, PixelOffsetY, 1, 1, .Pos.x, .Pos.y, 1, .invh)
                #Else
                    Render_Armas ID, PixelOffsetX, PixelOffsetY
                #End If
        End Select
    End If
End With
'Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub



Private Sub draw_char_alpha(ByVal ID As Integer, ByVal PixelOffsetX!, ByVal PixelOffsetY!, ByVal alpha As Byte)
Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
    With charlist(ID)
        If .Body.Walk(.Heading).GrhIndex Then
            Call Draw_Grh_Alpha(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, alpha, .Pos.x, .Pos.y, 1)
            Call Draw_Grh_Alpha(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, alpha, .Pos.x, .Pos.y, 1)
            If .Casco.Head(.Heading).GrhIndex Then _
                Call Draw_Grh_Alpha(.Casco.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, 1, 0, alpha, .Pos.x, .Pos.y, 1)
            If .arma.WeaponWalk(.Heading).GrhIndex Then _
                Call Draw_Grh_Alpha(.arma.WeaponWalk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, alpha, .Pos.x, .Pos.y, 1)
            If .Escudo.ShieldWalk(.Heading).GrhIndex Then _
                Call Draw_Grh_Alpha(.Escudo.ShieldWalk(.Heading), PixelOffsetX, PixelOffsetY, 1, 1, alpha, .Pos.x, .Pos.y, 1)
        End If
    End With
Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub

Public Sub Char_Move_by_Head(ByVal CharIndex As Integer, ByVal nHeading As E_Heading)
'*****************************************************************
'Starts the movement of a character in nHeading direction
'*****************************************************************
    Dim addx As Integer
    Dim addy As Integer
    Dim x As Integer
    Dim y As Integer
    Dim nx As Integer
    Dim ny As Integer
    On Error Resume Next
    With charlist(CharIndex)
        x = .Pos.x
        y = .Pos.y
        
        'Figure out which way to move
        Select Case nHeading
            Case E_Heading.north
                addy = -1
        
            Case E_Heading.east
                addx = 1
        
            Case E_Heading.south
                addy = 1
            
            Case E_Heading.west
                addx = -1
        End Select
        
        nx = x + addx
        ny = y + addy
        
        .active = 1
        
        charmap(nx, ny) = CharIndex
        .Pos.x = nx
        .Pos.y = ny
        charmap(x, y) = 0
        
        .MoveOffsetX = -1 * (32 * addx)
        .MoveOffsetY = -1 * (32 * addy)
        
        .Moving = 1
        .Heading = nHeading
        .invheading = .Heading
        If .invh Then
            If .Heading = E_Heading.east Then
                .invheading = E_Heading.west
            ElseIf .Heading = E_Heading.west Then
                .invheading = E_Heading.east
            End If
        End If
            
        
        .scrollDirectionX = addx
        .scrollDirectionY = addy
    End With
    
    If UserEstado <> 1 Then Call DoPasosFx(CharIndex)
    
    'areas viejos
    char_act_color CharIndex
    If (ny < MinLimiteY) Or (ny > MaxLimiteY) Or (nx < MinLimiteX) Or (nx > MaxLimiteX) Then
        Call EraseChar(CharIndex)
    End If
End Sub

Public Sub char_act_color(ByVal Index As Integer)
With charlist(Index)
.color = D3DColorXRGB(.colorz.r, .colorz.G, .colorz.b)
End With
End Sub



Public Sub Char_Move_by_Pos(ByVal CharIndex As Integer, ByVal nx As Long, ByVal ny As Long)
'On Error Resume Next
    Dim x As Long
    Dim y As Long
    Dim addx As Integer
    Dim addy As Integer
    Dim nHeading As E_Heading
    If (ny < 1) Or (ny > MapSize) Or (nx < 1) Or (nx > MapSize) Or (CharIndex < 1) Or (CharIndex > 255) Then Exit Sub
    
    With charlist(CharIndex)
        x = .Pos.x
        y = .Pos.y
        
        .active = 1

        addx = nx - x
        addy = ny - y
        nHeading = E_Heading.south
        If addx > 0 Then
            nHeading = E_Heading.east
        End If
        
        If addx < 0 Then
            nHeading = E_Heading.west
        End If
        
        If addy < 0 Then
            nHeading = E_Heading.north
        End If
        
        If addy > 0 Then
            nHeading = E_Heading.south
        End If
        
        charmap(nx, ny) = CharIndex
        charmap(x, y) = 0
        
        .Pos.y = ny
        .Pos.x = nx
        
        .MoveOffsetX = -32 * addx
        .MoveOffsetY = -32 * addy
        
        .Moving = 1
        .Heading = nHeading
        .invheading = .Heading
        
        If .invh Then
            If .Heading = E_Heading.east Then
                .invheading = E_Heading.west
            ElseIf .Heading = E_Heading.west Then
                .invheading = E_Heading.east
            End If
        End If
        
        .scrollDirectionX = Sgn(addx)
        .scrollDirectionY = Sgn(addy)
        
        'parche para que no medite cuando camina
        If .FxIndex = FxMeditar.CHICO Or .FxIndex = FxMeditar.GRANDE Or .FxIndex = FxMeditar.MEDIANO Or .FxIndex = FxMeditar.XGRANDE Or .FxIndex = FxMeditar.XXGRANDE Then
            .FxIndex = 0
        End If
    End With
    
    If UserEstado <> 1 Then Call DoPasosFx(CharIndex)
    
    If Not EstaPCarea(CharIndex) Then
    Call Dialogos.RemoveDialog(CharIndex)
    End If
    char_act_color CharIndex
    If (ny < MinLimiteY) Or (ny > MaxLimiteY) Or (nx < MinLimiteX) Or (nx > MaxLimiteX) Then
        Call EraseChar(CharIndex)
    End If
End Sub

Public Sub EraseChar(ByVal CharIndex As Integer)
'*****************************************************************
'Erases a character from CharList and map
'*****************************************************************
On Error Resume Next
Dim x&, y&
    charlist(CharIndex).active = 0
    
    'Update lastchar
    If CharIndex = LastChar Then
        Do Until charlist(LastChar).active = 1
            LastChar = LastChar - 1
            If LastChar = 0 Then Exit Do
        Loop
    End If
    
    x = charlist(CharIndex).Pos.x Mod (MapSize + 1)
    y = charlist(CharIndex).Pos.y Mod (MapSize + 1)
    
    'charlist(CharIndex).Pos.x = 0
    'charlist(CharIndex).Pos.y = 0
    
    If x > 0 And y > 0 Then
        If charmap(x, y) = CharIndex Then charmap(x, y) = 0
    End If
    'If x > 0 And y > 0 Then MapData(x, y).CharIndex = 0

    
    'Remove char's dialog
    Call Dialogos.RemoveDialog(CharIndex)
    'charlist(CharIndex).hit_act = 0
    Call ResetCharInfo(CharIndex)
    
    'Update NumChars
    NumChars = NumChars - 1
End Sub

Public Function EstaPCarea(ByVal CharIndex As Integer) As Boolean
    With charlist(CharIndex).Pos
        EstaPCarea = .x > UserPos.x - MinXBorder And .x < UserPos.x + MinXBorder And .y > UserPos.y - MinYBorder And .y < UserPos.y + MinYBorder
    End With
End Function

Public Function Engine_GetAngle(ByVal CenterX As Integer, ByVal CenterY As Integer, ByVal TargetX As Integer, ByVal TargetY As Integer) As Single
cfnc = fnc.E_Engine_GetAngle
    On Error GoTo ErrOut
    Dim opp!, adj!, ang1!

    opp = CenterY - TargetY
    adj = CenterX - TargetX
     
    If (CenterX = TargetX) And (CenterY = TargetY) Then
        Engine_GetAngle = 0
    Else
        If (adj = 0) Then
            If (opp >= 0) Then
                Engine_GetAngle = 0
            Else
                Engine_GetAngle = 180
            End If
        Else
            ang1 = (Atn(opp / adj)) * RadianToDegree
            If (CenterX >= CenterX) Then
                Engine_GetAngle = 90 - ang1
            Else
                Engine_GetAngle = 270 - ang1
            End If
        End If
    End If
Exit Function
ErrOut:
    Engine_GetAngle = 0
End Function
