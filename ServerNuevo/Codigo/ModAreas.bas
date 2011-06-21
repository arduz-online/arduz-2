Attribute VB_Name = "ModAreas"
Option Explicit

Public Const ViewPortX As Long = (545 + 54) / 32
Public Const ViewPortY As Long = (412 + 64) / 32

Public Const ParcialViewPortX As Long = ViewPortX / 2
Public Const ParcialViewPortY As Long = ViewPortY / 2

Public Const USER_NUEVO As Byte = 255

Public Sub InitAreas()

End Sub

Public Sub AreasOptimizacion()
End Sub

Public Sub CheckUpdateNeededUser(ByVal UserIndex As Integer, ByVal Head As Byte)
    Dim MinX As Long, MaxX As Long, MinY As Long, MaxY As Long, X As Long, Y As Long
    Dim TempInt As Long, map As Long
    
    With UserList(UserIndex)
        MinX = .Pos.X - ParcialViewPortX
        MinY = .Pos.Y - ParcialViewPortY
        MaxX = .Pos.X + ParcialViewPortX
        MaxY = .Pos.Y + ParcialViewPortY
        
        If Head = eHeading.NORTH Then
            MaxY = MinY
        ElseIf Head = eHeading.SOUTH Then
            MinY = MaxY
        ElseIf Head = eHeading.WEST Then
            MaxX = MinX
        ElseIf Head = eHeading.EAST Then
            MinX = MaxX
        End If
        
        If MinY < 1 Then MinY = 1
        If MinX < 1 Then MinX = 1
        If MaxY > MapSize Then MaxY = MapSize
        If MaxX > MapSize Then MaxX = MapSize
        
        map = UserList(UserIndex).Pos.map
        
        'Esto es para ke el cliente elimine lo "fuera de area..."
        Call WriteAreaChanged(UserIndex)
        
        'Actualizamos!!!
        For X = MinX To MaxX
            For Y = MinY To MaxY
                
                '<<< User >>>
                If MapData(map, X, Y).UserIndex Then
                    
                    TempInt = MapData(map, X, Y).UserIndex
                    
                    If UserIndex <> TempInt Then
                        Call MakeUserChar(False, UserIndex, TempInt, map, X, Y)
                        Call MakeUserChar(False, TempInt, UserIndex, .Pos.map, .Pos.X, .Pos.Y)
                        
                        'Si el user estaba invisible le avisamos al nuevo cliente de eso
                        If UserList(TempInt).Flags.invisible Or UserList(TempInt).Flags.Oculto Then
                            Call WriteSetInvisible(UserIndex, UserList(TempInt).Char.CharIndex, True)
                        End If
                        If UserList(UserIndex).Flags.invisible Or UserList(UserIndex).Flags.Oculto Then
                            Call WriteSetInvisible(TempInt, UserList(UserIndex).Char.CharIndex, True)
                        End If
                        
                        Call FlushBuffer(TempInt)
                    
                    ElseIf Head = USER_NUEVO Then
                        Call MakeUserChar(False, UserIndex, UserIndex, map, X, Y)
                    End If
                End If
                
                '<<< Npc >>>
                If MapData(map, X, Y).NpcIndex Then
                    Call MakeNPCChar(False, UserIndex, MapData(map, X, Y).NpcIndex, map, X, Y)
                 End If
                 
                '<<< Item >>>
                If MapData(map, X, Y).ObjInfo.ObjIndex Then
                    TempInt = MapData(map, X, Y).ObjInfo.ObjIndex
                    If Not EsObjetoFijo(ObjData(TempInt).OBJType) Then
                        Call WriteObjectCreate(UserIndex, ObjData(TempInt).GrhIndex, X, Y)
                        
                        If ObjData(TempInt).OBJType = eOBJType.otPuertas Then
                            Call Bloquear(False, UserIndex, X, Y, MapData(map, X, Y).Blocked)
                            Call Bloquear(False, UserIndex, X - 1, Y, MapData(map, X - 1, Y).Blocked)
                        End If
                    End If
                End If
            
            Next Y
        Next X
        
    
        FlushBuffer UserIndex
    
    
    End With
End Sub

Public Sub CheckUpdateNeededNpc(ByVal NpcIndex As Integer, ByVal Head As Byte)
    Dim MinX As Long, MaxX As Long, MinY As Long, MaxY As Long, X As Long, Y As Long
    Dim TempInt As Long
    
    With Npclist(NpcIndex)
        MinX = .Pos.X - ParcialViewPortX
        MinY = .Pos.Y - ParcialViewPortY
        MaxX = .Pos.X + ParcialViewPortX
        MaxY = .Pos.Y + ParcialViewPortY
        
        If Head = eHeading.NORTH Then
            MaxY = MinY
        ElseIf Head = eHeading.SOUTH Then
            MinY = MaxY
        ElseIf Head = eHeading.WEST Then
            MaxX = MinX
        ElseIf Head = eHeading.EAST Then
            MinX = MaxX
        End If
        
        If MinY < 1 Then MinY = 1
        If MinX < 1 Then MinX = 1
        If MaxY > MapSize Then MaxY = MapSize
        If MaxX > MapSize Then MaxX = MapSize

        
        'Actualizamos!!!
        If MapInfo(.Pos.map).NumUsers <> 0 Then
            For X = MinX To MaxX
                For Y = MinY To MaxY
                    If MapData(.Pos.map, X, Y).UserIndex Then _
                        Call MakeNPCChar(False, MapData(.Pos.map, X, Y).UserIndex, NpcIndex, .Pos.map, .Pos.X, .Pos.Y)
                Next Y
            Next X
        End If
    End With
End Sub

Public Sub QuitarUser(ByVal UserIndex As Integer, ByVal map As Integer)

End Sub

Public Sub AgregarUser(ByVal UserIndex As Integer, ByVal map As Integer)
    Call CheckUpdateNeededUser(UserIndex, USER_NUEVO)
End Sub

Public Sub AgregarNpc(ByVal NpcIndex As Integer)
    
    Call CheckUpdateNeededNpc(NpcIndex, USER_NUEVO)
End Sub
