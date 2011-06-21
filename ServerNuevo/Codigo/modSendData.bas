Attribute VB_Name = "modSendData"

Option Explicit

Public Enum SendTarget
    ToAll = 1
    toMap
    ToPCArea
    ToAllButIndex
    ToMapButIndex
    ToGM
    ToNPCArea
    ToGuildMembers
    ToAdmins
    ToPCAreaButIndex
    ToAdminsAreaButConsejeros
    ToDiosesYclan
    ToConsejo
    ToClanArea
    ToConsejoCaos
    ToRolesMasters
    ToDeadArea
    ToCiudadanos
    ToCriminales
    ToPartyArea
    ToReal
    ToCaos
    ToCiudadanosYRMs
    ToCriminalesYRMs
    ToRealYRMs
    ToCaosYRMs
End Enum

Public Sub SendData(ByVal sndRoute As SendTarget, ByVal sndIndex As Integer, ByVal sndData As String)
On Error Resume Next
    Dim loopc As Long
    Dim map As Integer
    Dim TempIndex As Integer
    
    
    Dim AreaX As Integer
    Dim AreaY As Integer
    Dim MinX&, MinY&, MaxX&, MaxY&
    Select Case sndRoute
        Case SendTarget.ToPCArea
            Call SendToUserArea(sndIndex, sndData)
'            map = UserList(UserIndex).Pos.map
'            If Not MapaValido(map) Then Exit Sub
'            mixx = UserList(sndIndex).Pos.x - 10
'            mixy = UserList(sndIndex).Pos.y - 10
'            maxx = UserList(sndIndex).Pos.x + 10
'            maxy = UserList(sndIndex).Pos.y + 10
'            If minx < 1 Then minx = 1
'            If miny < 1 Then miny = 1
'            If maxx > 100 Then maxx = 100
'            If maxy > 100 Then maxy = 100
'            For AreaX = minx To mxax
'                For AreaY = miny To mxay
'                    If MapData(map, AreaX, AreaY).UserIndex Then _
'                        If UserList(MapData(map, AreaX, AreaY).UserIndex).ConnIDValida Then _
'                            Call EnviarDatosASlot(tempIndex, sdData)
'                Next AreaY
'            Next AreaX
            
            Exit Sub
        
        Case SendTarget.ToAdmins
            For loopc = 1 To LastUser
                If UserList(loopc).ConnID <> -1 Then
                    If UserList(loopc).admin = True Or UserList(loopc).dios > 64 Then
                        Call EnviarDatosASlot(loopc, sndData)
                   End If
                End If
            Next loopc
            Exit Sub
        Case SendTarget.ToGM
            For loopc = 1 To LastUser
                If UserList(loopc).ConnID <> -1 Then
                    If UserList(loopc).dios And 128 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        Case SendTarget.ToAll
            For loopc = 1 To LastUser
                If UserList(loopc).ConnID <> -1 Then
                    If UserList(loopc).Flags.UserLogged Then 'Esta logeado como usuario?
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToAllButIndex
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) And (loopc <> sndIndex) Then
                    If UserList(loopc).Flags.UserLogged Then 'Esta logeado como usuario?
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.toMap
            Call SendToMap(sndIndex, sndData)
            Exit Sub
          
        Case SendTarget.ToMapButIndex
            Call SendToMapButIndex(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToDeadArea
            Call SendToDeadUserArea(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToPCAreaButIndex
            Call SendToUserAreaButindex(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToClanArea
            Call SendToUserGuildArea(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToPartyArea
            Call SendToUserPartyArea(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToAdminsAreaButConsejeros
            Call SendToAdminsButConsejerosArea(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToNPCArea
            Call SendToNpcArea(sndIndex, sndData)
            Exit Sub
        
        Case SendTarget.ToConsejo
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Flags.Privilegios And PlayerType.RoyalCouncil Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToConsejoCaos
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Flags.Privilegios And PlayerType.ChaosCouncil Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToRolesMasters
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Flags.Privilegios And PlayerType.RoleMaster Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCiudadanos
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If Not criminal(loopc) Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCriminales
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If criminal(loopc) Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToReal
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Faccion.ArmadaReal = 1 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCaos
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Faccion.FuerzasCaos = 1 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCiudadanosYRMs
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If Not criminal(loopc) Or (UserList(loopc).Flags.Privilegios And PlayerType.RoleMaster) <> 0 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCriminalesYRMs
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If criminal(loopc) Or (UserList(loopc).Flags.Privilegios And PlayerType.RoleMaster) <> 0 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToRealYRMs
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Faccion.ArmadaReal = 1 Or (UserList(loopc).Flags.Privilegios And PlayerType.RoleMaster) <> 0 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
        
        Case SendTarget.ToCaosYRMs
            For loopc = 1 To LastUser
                If (UserList(loopc).ConnID <> -1) Then
                    If UserList(loopc).Faccion.FuerzasCaos = 1 Or (UserList(loopc).Flags.Privilegios And PlayerType.RoleMaster) <> 0 Then
                        Call EnviarDatosASlot(loopc, sndData)
                    End If
                End If
            Next loopc
            Exit Sub
    End Select
End Sub

Private Sub SendToUserArea(ByVal UserIndex As Integer, ByVal sdData As String)
'
'Author: Lucio N. Tourrilhes (DuNga)
'Last Modify Date: Unknow
'
'
    Dim loopc As Long
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map
    
    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex Then
                    If UserList(TempIndex).ConnIDValida Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToUserAreaButindex(ByVal UserIndex As Integer, ByVal sdData As String)
'
'Author: Lucio N. Tourrilhes (DuNga)
'Last Modify Date: Unknow
'
'
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex And TempIndex <> UserIndex Then
                    If UserList(TempIndex).ConnIDValida Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToDeadUserArea(ByVal UserIndex As Integer, ByVal sdData As String)
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex Then
                    If UserList(TempIndex).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToUserGuildArea(ByVal UserIndex As Integer, ByVal sdData As String)
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex And UserList(TempIndex).guildIndex = UserList(UserIndex).guildIndex Then
                    If UserList(TempIndex).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToUserPartyArea(ByVal UserIndex As Integer, ByVal sdData As String)
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex Then
                    If UserList(TempIndex).ConnIDValida Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToAdminsButConsejerosArea(ByVal UserIndex As Integer, ByVal sdData As String)
'

'Last Modify Date: Unknow
'
'
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = UserList(UserIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With UserList(UserIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex Then
                    If UserList(TempIndex).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Private Sub SendToNpcArea(ByVal NpcIndex As Long, ByVal sdData As String)
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim map As Integer
    Dim X As Integer
    Dim Y As Integer
    
    map = Npclist(NpcIndex).Pos.map

    If Not MapaValido(map) Then Exit Sub
    
    With Npclist(NpcIndex)
        For X = .Pos.X - ParcialViewPortX To .Pos.X + ParcialViewPortX
            For Y = .Pos.Y - ParcialViewPortY To .Pos.Y + ParcialViewPortY
                TempIndex = MapData(map, X, Y).UserIndex
                If TempIndex Then
                    If UserList(TempIndex).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                        Call EnviarDatosASlot(TempIndex, sdData)
                    End If
                End If
            Next Y
        Next X
    End With
End Sub

Public Sub SendToAreaByPos(ByVal map As Integer, ByVal AreaX As Integer, ByVal AreaY As Integer, ByVal sdData As String)
    Dim loopc As Long
    Dim TempInt As Integer
    Dim TempIndex As Integer
    
    Dim X As Integer
    Dim Y As Integer

    If Not MapaValido(map) Then Exit Sub
    
    For X = AreaX - ParcialViewPortX To AreaX + ParcialViewPortX
        For Y = AreaY - ParcialViewPortY To AreaY + ParcialViewPortY
            TempIndex = MapData(map, X, Y).UserIndex
            If TempIndex Then
                If UserList(TempIndex).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                    Call EnviarDatosASlot(TempIndex, sdData)
                End If
            End If
        Next Y
    Next X

End Sub

Public Sub SendToMap(ByVal map As Integer, ByVal sdData As String)
'

'Last Modify Date: 5/24/2007
'
'
    Dim loopc As Long
    Dim TempIndex As Integer
    
    If Not MapaValido(map) Then Exit Sub

    For loopc = 1 To LastUser
        If UserList(loopc).Pos.map = map Then
            If UserList(loopc).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                Call EnviarDatosASlot(loopc, sdData)
            End If
        End If
    Next loopc
End Sub

Public Sub SendToMapButIndex(ByVal UserIndex As Integer, ByVal sdData As String)
'

'Last Modify Date: 5/24/2007
'
'
    Dim loopc As Long
    Dim map As Integer
    Dim TempIndex As Integer
    
    map = UserList(UserIndex).Pos.map
    
    If Not MapaValido(map) Then Exit Sub

    For loopc = 1 To LastUser
        If UserList(loopc).Pos.map = map And loopc <> UserIndex Then
            If UserList(loopc).ConnIDValida Then 'And (UserList(tempIndex).flags.Muerto = 1 Or (UserList(tempIndex).flags.Privilegios And (PlayerType.admin Or PlayerType.dios Or PlayerType.SemiDios Or PlayerType.Consejero)) <> 0) Then
                Call EnviarDatosASlot(loopc, sdData)
            End If
        End If
    Next loopc
End Sub
