Attribute VB_Name = "modGame"
Option Explicit

Public Enum client_cfgs
    Limitar_Fps = 1
    LucesPowa
    Hotbar
    Volumen_fx
    Volumen_potas
    Musica_act
    Sonidos_act
    RadioDeLuz
    EfectosSol
    eSuperWater
    forzar_software
End Enum

Public useRDL As Boolean
Public useEDS As Boolean

Public volumenpotas As Long
Public volumenfx As Long
Public SoundActivated As Boolean

Public limitarr As Boolean

Public SuperWater As Boolean

Public soporta_luces2 As Boolean

Public act_pharseado As Boolean

Public Force_Software As Boolean

Public Sub Write_Cfg(ByVal num As client_cfgs, ByVal Value As Long)
modZLib.Resource_WRITE_CFG_LNG app.Path & "\Datos\client.cfg", num, Value
End Sub

Public Function Read_Cfg(ByVal num As client_cfgs) As Long
Read_Cfg = modZLib.Resource_Read_CFG_LNG(app.Path & "\Datos\client.cfg", num)
End Function

Public Sub MoveTo(ByVal direccion As E_Heading)
    Dim LegalOk As Boolean
    If UserMoving Then Exit Sub
    If UserMeditar = True Then Exit Sub
    
    Select Case direccion
        Case E_Heading.north
            LegalOk = LegalPos(UserPos.x, UserPos.y - 1)
        Case E_Heading.east
            LegalOk = LegalPos(UserPos.x + 1, UserPos.y)
        Case E_Heading.south
            LegalOk = LegalPos(UserPos.x, UserPos.y + 1)
        Case E_Heading.west
            LegalOk = LegalPos(UserPos.x - 1, UserPos.y)
    End Select
    
    If UserParalizado = False And LegalOk = True Then
        Call WriteWalk(direccion)
        Char_Move_by_Head UserCharIndex, direccion
        Engine_MoveScreen direccion
        frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
    Else
        If charlist(UserCharIndex).Heading <> direccion Then
            Call WriteChangeHeading(direccion)
        End If
    End If
    
    
    ' Update 3D sounds!
    'Call Audio.MoveListener(UserPos.X, UserPos.y)
End Sub

Sub RandomMove()
'***************************************************
'Author: Alejandro Santos (AlejoLp)
'Last Modify Date: 06/03/2006
' 06/03/2006: AlejoLp - Ahora utiliza la funcion MoveTo
'***************************************************
    Call MoveTo(RandomNumber(north, west))
End Sub

Sub CheckKeys()
'*****************************************************************
'Checks keys and respond
'*****************************************************************
On Error Resume Next
    Static lastMovement As Long
    
    'No input allowed while Argentum is not the active window
    
    'Call RandomMove
    
    'No walking while writting in the forum.
    'If frmForo.Visible Then Exit Sub
    
    'If game is paused, abort movement.
    If pausa Then Exit Sub
    
    'Control movement interval (this enforces the 1 step loss when meditating / resting client-side)
    If GetTickCount - lastMovement > (31) Then
        lastMovement = GetTickCount
    Else
        Exit Sub
    End If
    
    If Not Application.IsAppActive() Then Exit Sub
    
    If frmMain.SendTxt.Visible = False Then
        If (GetKeyState(vbKeyTab) < 0) Or (GetKeyState(vbKeySpace) < 0) Then
            If IScombate = False Then IScombate = True
        Else
            If IScombate = True Then IScombate = False
        End If
    Else
        IScombate = False
    End If
    Engine_UI.rank_visible = IScombate
'            If GetAsyncKeyState(vbKeyNumpad0) Then       'In
'                ZooMlevel = ZooMlevel + (timerElapsedTime * 0.003)
'                If ZooMlevel > 2 Then ZooMlevel = 2
'            ElseIf GetAsyncKeyState(vbKeyNumpad1) Then  'Out
'                ZooMlevel = ZooMlevel - (timerElapsedTime * 0.003)
'                If ZooMlevel < 0.25 Then ZooMlevel = 0.25
'            End If
    'UserDirection = 0
    Dim kp As Boolean
            kp = ((GetKeyState(vbKeyUp) < 0) And UserDirection = north) Or _
                 ((GetKeyState(vbKeyRight) < 0) And UserDirection = east) Or _
                 ((GetKeyState(vbKeyDown) < 0) And UserDirection = south) Or _
                 ((GetKeyState(vbKeyLeft) < 0) And UserDirection = west)
            If Not kp Then UserDirection = 0
            
    If UserMoving = 0 Then
        If Not UserEstupido Then
            
            If GetAsyncKeyState(vbKeyUp) < 0 Then
                UserDirection = north
                Exit Sub
            End If
            
            'Move Right
            If GetAsyncKeyState(vbKeyRight) < 0 Then
                UserDirection = east
                Exit Sub
            End If
        
            'Move down
            If GetAsyncKeyState(vbKeyDown) < 0 Then
                UserDirection = south
                Exit Sub
            End If
        
            'Move left
            If GetAsyncKeyState(vbKeyLeft) < 0 Then
                UserDirection = west
                Exit Sub
            End If
        Else
            If kp Then _
                UserDirection = Int(Rnd * 3) + 1
        End If
    End If
    Exit Sub
    'Don't allow any these keys during movement..
'    If UserMoving = 0 Then
'        If Not UserEstupido Then
'            'Move Up
'
'            If GetKeyState(vbKeyUp) < 0 Then
'                lastMovement = GetTickCount
'                'Call MoveTo(NORTH)
'                'frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.X & "," & UserPos.Y & ")"
'                UserDirection = NORTH
'                Exit Sub
'            End If
'
'            'Move Right
'            If GetKeyState(vbKeyRight) < 0 Then
'                lastMovement = GetTickCount
'                'Call MoveTo(EAST)
'                UserDirection = EAST
'                'frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.X & "," & UserPos.Y & ")"
'                Exit Sub
'            End If
'
'            'Move down
'            If GetKeyState(vbKeyDown) < 0 Then
'                lastMovement = GetTickCount
'                'Call MoveTo(SOUTH)
'                UserDirection = SOUTH
'                'frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.X & "," & UserPos.Y & ")"
'                Exit Sub
'            End If
'
'            'Move left
'            If GetKeyState(vbKeyLeft) < 0 Then
'                lastMovement = GetTickCount
'                'Call MoveTo(WEST)
'                UserDirection = WEST
'                'frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.X & "," & UserPos.Y & ")"
'                Exit Sub
'            End If
'
'            ' We haven't moved - Update 3D sounds!
'            'Call Audio.MoveListener(UserPos.X, UserPos.y)
'        Else
'            Dim kp As Boolean
'            kp = (GetKeyState(vbKeyUp) < 0) Or _
'                GetKeyState(vbKeyRight) < 0 Or _
'                GetKeyState(vbKeyDown) < 0 Or _
'                GetKeyState(vbKeyLeft) < 0
'            If kp Then
'                Call RandomMove
'            End If
'
'
'            'frmMain.Coord.Caption = "(" & UserPos.X & "," & UserPos.Y & ")"
'        End If
'    End If
End Sub

Function LegalPos(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is legal
'*****************************************************************
    'Limites del mapa
    If x < MinXBorder Or x > MaxXBorder Or y < MinYBorder Or y > MaxYBorder Then
        Exit Function
    End If
    
    'Tile Bloqueado?
    If MapData(x, y).Blocked = 1 Then
        Exit Function
    End If
    
    If UserNavegando <> CBool(MapData(x, y).is_water) Then 'HayAgua(x, Y) Then
        Exit Function
    End If
    
    '¿Hay un personaje?
    If charmap(x, y) > 0 Then
        If Not (charlist(charmap(x, y)).Pos.x = x And charlist(charmap(x, y)).Pos.y = y) Then
            If charlist(charmap(x, y)).Pos.x > 0 And charlist(charmap(x, y)).Pos.x < MapSize And charlist(charmap(x, y)).Pos.y > 0 And charlist(charmap(x, y)).Pos.y < MapSize Then
                If charmap(charlist(charmap(x, y)).Pos.x, charlist(charmap(x, y)).Pos.y) = 0 Then charmap(charlist(charmap(x, y)).Pos.x, charlist(charmap(x, y)).Pos.y) = charmap(x, y)
            End If
            charmap(x, y) = 0
        End If

        If charmap(x, y) > 0 Then
            LegalPos = charlist(charmap(x, y)).muerto
            If LegalPos = True And charlist(charmap(x, y)).Moving = 1 Then LegalPos = False
            If LegalPos = True And UserEstado = 1 Then LegalPos = False
            
            Exit Function
        End If
    End If
    
    LegalPos = True
End Function

Public Function InMapBounds(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is in the maps bounds
'*****************************************************************
    If x < XMinMapSize Or x > MapSize Or y < YMinMapSize Or y > MapSize Then
        Exit Function
    End If
    
    InMapBounds = True
End Function

