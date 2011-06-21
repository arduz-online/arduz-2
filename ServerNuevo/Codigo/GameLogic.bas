Attribute VB_Name = "modExtras"
Option Explicit

Public Const INVALID_INDEX As Integer = 0

Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal Hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long



Public Function Porcentaje(ByVal total As Long, ByVal porc As Long) As Long
    Porcentaje = (total * porc) / 100
End Function

Function Distancia(ByRef wp1 As WorldPos, ByRef wp2 As WorldPos) As Long
    Distancia = Abs(wp1.X - wp2.X) + Abs(wp1.Y - wp2.Y) + (Abs(wp1.map - wp2.map) * MapSize)
End Function

Function Distance(X1 As Variant, Y1 As Variant, X2 As Variant, Y2 As Variant) As Double
Distance = Sqr(((Y1 - Y2) ^ 2 + (X1 - X2) ^ 2))
    End Function

Public Function RandomNumber(ByVal LowerBound As Long, ByVal UpperBound As Long) As Long
    RandomNumber = Fix(Rnd * (UpperBound - LowerBound + 1)) + LowerBound
End Function

Sub Accion(ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)
On Error Resume Next

'¿Rango Visión? (ToxicWaste)
If (Abs(UserList(UserIndex).Pos.Y - Y) > RANGO_VISION_Y) Or (Abs(UserList(UserIndex).Pos.X - X) > RANGO_VISION_X) Then
    Exit Sub
End If

'¿Posicion valida?
If InMapBounds(map, X, Y) Then
    If MapData(map, X, Y).ObjInfo.ObjIndex > 0 Then
        UserList(UserIndex).Flags.TargetObj = MapData(map, X, Y).ObjInfo.ObjIndex
        If ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then 'Es una puerta
                Call AccionParaPuerta(map, X, Y, UserIndex)
        End If
    ElseIf MapData(map, X + 1, Y).ObjInfo.ObjIndex > 0 Then
        UserList(UserIndex).Flags.TargetObj = MapData(map, X + 1, Y).ObjInfo.ObjIndex
        If ObjData(MapData(map, X + 1, Y).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then 'Es una puerta
                Call AccionParaPuerta(map, X + 1, Y, UserIndex)
        End If
    ElseIf MapData(map, X + 1, Y + 1).ObjInfo.ObjIndex > 0 Then
        UserList(UserIndex).Flags.TargetObj = MapData(map, X + 1, Y + 1).ObjInfo.ObjIndex
        If ObjData(MapData(map, X + 1, Y + 1).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then 'Es una puerta
                Call AccionParaPuerta(map, X, Y, UserIndex)
        End If
    ElseIf MapData(map, X, Y + 1).ObjInfo.ObjIndex > 0 Then
        UserList(UserIndex).Flags.TargetObj = MapData(map, X, Y + 1).ObjInfo.ObjIndex
        If ObjData(MapData(map, X, Y + 1).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then  'Es una puerta
                Call AccionParaPuerta(map, X, Y, UserIndex)
        End If
    End If
End If

End Sub



Sub AccionParaPuerta(ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal UserIndex As Integer)
On Error Resume Next


If Not (Distance(UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y, X, Y) > 2) Then
    If ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).Llave = 0 Then
        If ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).Cerrada = 1 Then
                'Abre la puerta
                If ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).Llave = 0 Then
                    
                    MapData(map, X, Y).ObjInfo.ObjIndex = ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).IndexAbierta
                    
                    Call modSendData.SendToAreaByPos(map, X, Y, PrepareMessageObjectCreate(ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).GrhIndex, X, Y))
                    
                    'Desbloquea
                    MapData(map, X, Y).Blocked = 0
                    MapData(map, X - 1, Y).Blocked = 0
                    
                    'Bloquea todos los mapas
                    Call Bloquear(True, map, X, Y, 0)
                    Call Bloquear(True, map, X - 1, Y, 0)
                    
                      
                    'Sonido
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_PUERTA, X, Y))
                    
                Else
                     Call WriteConsoleMsg(UserIndex, "La puerta esta cerrada con llave.", FontTypeNames.FONTTYPE_INFO)
                End If
        Else
                'Cierra puerta
                MapData(map, X, Y).ObjInfo.ObjIndex = ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).IndexCerrada
                
                Call modSendData.SendToAreaByPos(map, X, Y, PrepareMessageObjectCreate(ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).GrhIndex, X, Y))
                                
                MapData(map, X, Y).Blocked = 1
                MapData(map, X - 1, Y).Blocked = 1
                
                
                Call Bloquear(True, map, X - 1, Y, 1)
                Call Bloquear(True, map, X, Y, 1)
                
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_PUERTA, X, Y))
        End If
        
        UserList(UserIndex).Flags.TargetObj = MapData(map, X, Y).ObjInfo.ObjIndex
    Else
        Call WriteConsoleMsg(UserIndex, "La puerta esta cerrada con llave.", FontTypeNames.FONTTYPE_INFO)
    End If
Else
    Call WriteConsoleMsg(UserIndex, "Estás demasiado lejos.", FontTypeNames.FONTTYPE_INFO)
End If

End Sub



Public Function CharIndexToUserIndex(ByVal CharIndex As Integer) As Integer
    CharIndexToUserIndex = CharList(CharIndex)
    
    If CharIndexToUserIndex < 1 Or CharIndexToUserIndex > maxusers Then
        CharIndexToUserIndex = INVALID_INDEX
        Exit Function
    End If
    
    If UserList(CharIndexToUserIndex).Char.CharIndex <> CharIndex Then
        CharIndexToUserIndex = INVALID_INDEX
        Exit Function
    End If
End Function





#Const MODO_INVISIBILIDAD = 0

'cambia el estado de invisibilidad a 1 o 0 dependiendo del modo: true o false
'
Public Sub PonerInvisible(ByVal UserIndex As Integer, ByVal estado As Boolean)
#If MODO_INVISIBILIDAD = 0 Then

UserList(UserIndex).Flags.invisible = IIf(estado, 1, 0)
UserList(UserIndex).Flags.Oculto = IIf(estado, 1, 0)
UserList(UserIndex).Counters.Invisibilidad = 0

Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, Not estado))


#Else

Dim EstadoActual As Boolean

'Está invisible ?
EstadoActual = (UserList(UserIndex).Flags.invisible = 1)

'If EstadoActual <> Modo Then
    If Modo = True Then
        'Cuando se hace INVISIBLE se les envia a los
        'clientes un Borrar Char
        UserList(UserIndex).Flags.invisible = 1
''Call SendData(SendTarget.ToMap, 0, UserList(UserIndex).Pos.Map, "NOVER" & UserList(UserIndex).Char.CharIndex & ",1")
        Call SendData(SendTarget.toMap, UserList(UserIndex).Pos.map, PrepareMessageCharacterRemove(UserList(UserIndex).Char.CharIndex))
    Else
        
    End If
'End If

#End If
End Sub



Public Sub DoTileEvents(ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)
'
'Autor: Pablo (ToxicWaste) & Unknown (orginal version)
'23/01/2007
'Handles the Map passage of Users. Allows the existance
'of exclusive maps for Newbies, Royal Army and Caos Legion members
'and enables GMs to enter every map without restriction.
'Uses: Mapinfo(map).Restringir = "NEWBIE" (newbies), "ARMADA", "CAOS", "FACCION" or "NO".
'
On Error GoTo ErrHandler

Dim npos As WorldPos
Dim FxFlag As Boolean
'Controla las salidas
If InMapBounds(map, X, Y) Then
    
    If MapData(map, X, Y).ObjInfo.ObjIndex > 0 Then
        FxFlag = ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).OBJType = eOBJType.otTeleport
    End If
    
    If (MapData(map, X, Y).TileExit.map > 0) And (MapData(map, X, Y).TileExit.map <= NumMaps) Then
        '¿Es mapa de newbies?

            If LegalPos(MapData(map, X, Y).TileExit.map, MapData(map, X, Y).TileExit.X, MapData(map, X, Y).TileExit.Y, PuedeAtravesarAgua(UserIndex)) Then
                If FxFlag Then
                    Call WarpUserChar(UserIndex, MapData(map, X, Y).TileExit.map, MapData(map, X, Y).TileExit.X, MapData(map, X, Y).TileExit.Y, True)
                Else
                    Call WarpUserChar(UserIndex, MapData(map, X, Y).TileExit.map, MapData(map, X, Y).TileExit.X, MapData(map, X, Y).TileExit.Y)
                End If
            Else
                Call ClosestLegalPos(MapData(map, X, Y).TileExit, npos)
                If npos.X <> 0 And npos.Y <> 0 Then
                    If FxFlag Then
                        Call WarpUserChar(UserIndex, npos.map, npos.X, npos.Y, True)
                    Else
                        Call WarpUserChar(UserIndex, npos.map, npos.X, npos.Y)
                    End If
                End If
            End If

        'Te fusite del mapa. La criatura ya no es más tuya ni te reconoce como que vos la atacaste.
        Dim aN As Integer
    
        aN = UserList(UserIndex).Flags.AtacadoPorNpc
        If aN > 0 Then
           Npclist(aN).Movement = Npclist(aN).Flags.OldMovement
           Npclist(aN).Hostile = Npclist(aN).Flags.OldHostil
           Npclist(aN).Flags.AttackedBy = vbNullString
        End If
    
        aN = UserList(UserIndex).Flags.NPCAtacado
        If aN > 0 Then
            If Npclist(aN).Flags.AttackedFirstBy = UserList(UserIndex).name Then
            Npclist(aN).Flags.AttackedFirstBy = vbNullString
            End If
        End If
        UserList(UserIndex).Flags.AtacadoPorNpc = 0
        UserList(UserIndex).Flags.NPCAtacado = 0
    End If
    
End If



Exit Sub

ErrHandler:
    Call LogError("Error en DotileEvents. Error: " & ERR.number & " - Desc: " & ERR.Description)
End Sub

Function InRangoVision(ByVal UserIndex As Integer, ByVal X As Integer, ByVal Y As Integer) As Boolean

If X > UserList(UserIndex).Pos.X - MinXBorder And X < UserList(UserIndex).Pos.X + MinXBorder Then
    If Y > UserList(UserIndex).Pos.Y - MinYBorder And Y < UserList(UserIndex).Pos.Y + MinYBorder Then
        InRangoVision = True
        Exit Function
    End If
End If
InRangoVision = False

End Function

Function InRangoVisionNPC(ByVal NpcIndex As Integer, X As Integer, Y As Integer) As Boolean

If X > Npclist(NpcIndex).Pos.X - MinXBorder And X < Npclist(NpcIndex).Pos.X + MinXBorder Then
    If Y > Npclist(NpcIndex).Pos.Y - MinYBorder And Y < Npclist(NpcIndex).Pos.Y + MinYBorder Then
        InRangoVisionNPC = True
        Exit Function
    End If
End If
InRangoVisionNPC = False

End Function


Function InMapBounds(ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer) As Boolean
            
If (map <= 0 Or map > NumMaps) Or X < MinXBorder Or X > MaxXBorder Or Y < MinYBorder Or Y > MaxYBorder Then
    InMapBounds = False
Else
    InMapBounds = True
End If

End Function

Sub ClosestLegalPos(Pos As WorldPos, ByRef npos As WorldPos, Optional PuedeAgua As Boolean = False, Optional PuedeTierra As Boolean = True)
'
'Author: Unknown (original version)
'24/01/2007 (ToxicWaste)
'Encuentra la posicion legal mas cercana y la guarda en nPos
'

Dim Notfound As Boolean
Dim loopc As Integer
Dim tX As Integer
Dim tY As Integer

npos.map = Pos.map

Do While Not LegalPos(Pos.map, npos.X, npos.Y, PuedeAgua, PuedeTierra)
    If loopc > 12 Then
        Notfound = True
        Exit Do
    End If
    
    For tY = Pos.Y - loopc To Pos.Y + loopc
        For tX = Pos.X - loopc To Pos.X + loopc
            
            If LegalPos(npos.map, tX, tY, PuedeAgua, PuedeTierra) Then
                npos.X = tX
                npos.Y = tY
                '¿Hay objeto?
                
                tX = Pos.X + loopc
                tY = Pos.Y + loopc
  
            End If
        
        Next tX
    Next tY
    
    loopc = loopc + 1
    
Loop

If Notfound = True Then
    npos.X = 0
    npos.Y = 0
End If

End Sub

Sub ClosestStablePos(Pos As WorldPos, ByRef npos As WorldPos)
'
'Encuentra la posicion legal mas cercana que no sea un portal y la guarda en nPos
'

Dim Notfound As Boolean
Dim loopc As Integer
Dim tX As Integer
Dim tY As Integer

npos.map = Pos.map

Do While Not LegalPos(Pos.map, npos.X, npos.Y)
    If loopc > 12 Then
        Notfound = True
        Exit Do
    End If
    
    For tY = Pos.Y - loopc To Pos.Y + loopc
        For tX = Pos.X - loopc To Pos.X + loopc
            
            If LegalPos(npos.map, tX, tY) And MapData(npos.map, tX, tY).TileExit.map = 0 Then
                npos.X = tX
                npos.Y = tY
                '¿Hay objeto?
                
                tX = Pos.X + loopc
                tY = Pos.Y + loopc
  
            End If
        
        Next tX
    Next tY
    
    loopc = loopc + 1
    
Loop

If Notfound = True Then
    npos.X = 0
    npos.Y = 0
End If

End Sub

Function NameIndex(ByVal name As String) As Integer

Dim UserIndex As Integer
'¿Nombre valido?
If LenB(name) = 0 Then
    NameIndex = 0
    Exit Function
End If

If InStrB(name, "+") <> 0 Then
    name = Replace(name, "+", " ")
End If

UserIndex = 1
Do Until (UCase$(UserList(UserIndex).nick) = UCase$(name)) Or (UCase$(UserList(UserIndex).name) = UCase$(name))
    
    UserIndex = UserIndex + 1
    
    If UserIndex > maxusers Then
        NameIndex = 0
        Exit Function
    End If
    
Loop
 
NameIndex = UserIndex
 
End Function



Function IP_Index(ByVal inIP As String) As Integer
 
Dim UserIndex As Integer
'¿Nombre valido?
If LenB(inIP) = 0 Then
    IP_Index = 0
    Exit Function
End If
  
UserIndex = 1
Do Until UserList(UserIndex).ip = inIP
    
    UserIndex = UserIndex + 1
    
    If UserIndex > maxusers Then
        IP_Index = 0
        Exit Function
    End If
    
Loop
 
IP_Index = UserIndex

Exit Function

End Function


Function CheckForSameIP(ByVal UserIndex As Integer, ByVal UserIP As String) As Boolean
Dim loopc As Integer
For loopc = 1 To maxusers
    If UserList(loopc).Flags.UserLogged = True Then
        If UserList(loopc).ip = UserIP And UserIndex <> loopc Then
            CheckForSameIP = True
            Exit Function
        End If
    End If
Next loopc
CheckForSameIP = False
End Function

Function CheckForSameName(ByVal name As String) As Boolean
'Controlo que no existan usuarios con el mismo nombre
Dim loopc As Long
For loopc = 1 To LastUser
    If UserList(loopc).Flags.UserLogged Then
        
        'If UCase$(UserList(LoopC).Name) = UCase$(Name) And UserList(LoopC).ConnID <> -1 Then
        'OJO PREGUNTAR POR EL CONNID <> -1 PRODUCE QUE UN PJ EN DETERMINADO
        'MOMENTO PUEDA ESTAR LOGUEADO 2 VECES (IE: CIERRA EL SOCKET DESDE ALLA)
        'ESE EVENTO NO DISPARA UN SAVE USER, LO QUE PUEDE SER UTILIZADO PARA DUPLICAR ITEMS
        'ESTE BUG EN ALKON PRODUJO QUE EL SERVIDOR ESTE CAIDO DURANTE 3 DIAS. ATENTOS.
        
        If UCase$(UserList(loopc).name) = UCase$(name) Then
            CheckForSameName = True
            Exit Function
        End If
    End If
Next loopc
CheckForSameName = False
End Function

Sub HeadtoPos(ByVal Head As eHeading, ByRef Pos As WorldPos)
'
'Toma una posicion y se mueve hacia donde esta perfilado
'
Dim X As Integer
Dim Y As Integer
Dim nX As Integer
Dim nY As Integer

X = Pos.X
Y = Pos.Y

If Head = eHeading.NORTH Then
    nX = X
    nY = Y - 1
End If

If Head = eHeading.SOUTH Then
    nX = X
    nY = Y + 1
End If

If Head = eHeading.EAST Then
    nX = X + 1
    nY = Y
End If

If Head = eHeading.WEST Then
    nX = X - 1
    nY = Y
End If

'Devuelve valores
Pos.X = nX
Pos.Y = nY

End Sub

Function LegalPos(ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, Optional ByVal PuedeAgua As Boolean = False, Optional ByVal PuedeTierra As Boolean = True) As Boolean
'
'Autor: Pablo (ToxicWaste) & Unknown (orginal version)
'23/01/2007
'Checks if the position is Legal.
'
'¿Es un mapa valido?
If (map <= 0 Or map > NumMaps) Or _
   (X < MinXBorder Or X > MaxXBorder Or Y < MinYBorder Or Y > MaxYBorder) Then
            LegalPos = False
Else
    If PuedeAgua And PuedeTierra Then
        LegalPos = (MapData(map, X, Y).Blocked <> 1) And _
                   (MapData(map, X, Y).UserIndex = 0) And _
                   (MapData(map, X, Y).NpcIndex = 0)
    ElseIf PuedeTierra And Not PuedeAgua Then
        LegalPos = (MapData(map, X, Y).Blocked <> 1) And _
                   (MapData(map, X, Y).UserIndex = 0) And _
                   (MapData(map, X, Y).NpcIndex = 0) And _
                   (Not HayAgua(map, X, Y))
    ElseIf PuedeAgua And Not PuedeTierra Then
        LegalPos = (MapData(map, X, Y).Blocked <> 1) And _
                   (MapData(map, X, Y).UserIndex = 0) And _
                   (MapData(map, X, Y).NpcIndex = 0) And _
                   (HayAgua(map, X, Y))
    Else
        LegalPos = False
    End If
   
End If

End Function
Function LegalPosNPC(ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal AguaValida As Byte) As Boolean

If (map <= 0 Or map > NumMaps) Or _
   (X < MinXBorder Or X > MaxXBorder Or Y < MinYBorder Or Y > MaxYBorder) Then
    LegalPosNPC = False
Else

 If AguaValida = 0 Then
   LegalPosNPC = (MapData(map, X, Y).Blocked <> 1) And _
     (MapData(map, X, Y).UserIndex = 0) And _
     (MapData(map, X, Y).NpcIndex = 0) And _
     (MapData(map, X, Y).trigger <> eTrigger.POSINVALIDA) _
     And Not HayAgua(map, X, Y)
 Else
   LegalPosNPC = (MapData(map, X, Y).Blocked <> 1) And _
     (MapData(map, X, Y).UserIndex = 0) And _
     (MapData(map, X, Y).NpcIndex = 0) And _
     (MapData(map, X, Y).trigger <> eTrigger.POSINVALIDA)
 End If
 
End If


End Function

Sub SendHelp(ByVal Index As Integer)

Call WriteConsoleMsg(Index, "asd", FontTypeNames.FONTTYPE_INFO)


End Sub

Public Sub Expresar(ByVal NpcIndex As Integer, ByVal UserIndex As Integer)
    If Npclist(NpcIndex).NroExpresiones > 0 Then
        Dim randomi
        randomi = RandomNumber(1, Npclist(NpcIndex).NroExpresiones)
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageChatOverHead(Npclist(NpcIndex).Expresiones(randomi), Npclist(NpcIndex).Char.CharIndex, vbWhite))
    End If
End Sub

Sub LookatTile(ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)

'Responde al click del usuario sobre el mapa
Dim FoundChar As Byte
Dim FoundSomething As Byte
Dim TempCharIndex As Integer
Dim Stat As String
Dim ft As FontTypeNames

'¿Rango Visión? (ToxicWaste)
If (Abs(UserList(UserIndex).Pos.Y - Y) > RANGO_VISION_Y) Or (Abs(UserList(UserIndex).Pos.X - X) > RANGO_VISION_X) Then
    Exit Sub
End If

'¿Posicion valida?
If InMapBounds(map, X, Y) Then
    UserList(UserIndex).Flags.TargetMap = map
    UserList(UserIndex).Flags.TargetX = X
    UserList(UserIndex).Flags.TargetY = Y
    '¿Es un obj?
    If MapData(map, X, Y).ObjInfo.ObjIndex > 0 Then
        'Informa el nombre
        UserList(UserIndex).Flags.TargetObjMap = map
        UserList(UserIndex).Flags.TargetObjX = X
        UserList(UserIndex).Flags.TargetObjY = Y
        FoundSomething = 1
    ElseIf MapData(map, X + 1, Y).ObjInfo.ObjIndex > 0 Then
        'Informa el nombre
        If ObjData(MapData(map, X + 1, Y).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then
            UserList(UserIndex).Flags.TargetObjMap = map
            UserList(UserIndex).Flags.TargetObjX = X + 1
            UserList(UserIndex).Flags.TargetObjY = Y
            FoundSomething = 1
        End If
    ElseIf MapData(map, X + 1, Y + 1).ObjInfo.ObjIndex > 0 Then
        If ObjData(MapData(map, X + 1, Y + 1).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then
            'Informa el nombre
            UserList(UserIndex).Flags.TargetObjMap = map
            UserList(UserIndex).Flags.TargetObjX = X + 1
            UserList(UserIndex).Flags.TargetObjY = Y + 1
            FoundSomething = 1
        End If
    ElseIf MapData(map, X, Y + 1).ObjInfo.ObjIndex > 0 Then
        If ObjData(MapData(map, X, Y + 1).ObjInfo.ObjIndex).OBJType = eOBJType.otPuertas Then
            'Informa el nombre
            UserList(UserIndex).Flags.TargetObjMap = map
            UserList(UserIndex).Flags.TargetObjX = X
            UserList(UserIndex).Flags.TargetObjY = Y + 1
            FoundSomething = 1
        End If
    End If
    
    If FoundSomething = 1 Then
        UserList(UserIndex).Flags.TargetObj = MapData(map, UserList(UserIndex).Flags.TargetObjX, UserList(UserIndex).Flags.TargetObjY).ObjInfo.ObjIndex
            Call WriteConsoleMsg(UserIndex, ObjData(UserList(UserIndex).Flags.TargetObj).name & " - " & MapData(UserList(UserIndex).Flags.TargetObjMap, UserList(UserIndex).Flags.TargetObjX, UserList(UserIndex).Flags.TargetObjY).ObjInfo.Amount & "", FontTypeNames.FONTTYPE_INFO)
    End If
    '¿Es un personaje?
    If Y + 1 <= MapSize Then
        If MapData(map, X, Y + 1).UserIndex > 0 Then
            TempCharIndex = MapData(map, X, Y + 1).UserIndex
            FoundChar = 1
        End If
        If MapData(map, X, Y + 1).NpcIndex > 0 Then
            TempCharIndex = MapData(map, X, Y + 1).NpcIndex
            FoundChar = 2
        End If
    End If
    '¿Es un personaje?
    If FoundChar = 0 Then
        If MapData(map, X, Y).UserIndex > 0 Then
            TempCharIndex = MapData(map, X, Y).UserIndex
            FoundChar = 1
        End If
        If MapData(map, X, Y).NpcIndex > 0 Then
            TempCharIndex = MapData(map, X, Y).NpcIndex
            FoundChar = 2
        End If
    End If
    
    
    'Reaccion al personaje
    If FoundChar = 1 Then '¿Encontro un Usuario?
            
       If UserList(TempCharIndex).Flags.AdminInvisible = 0 Then
            
            If LenB(UserList(TempCharIndex).DescRM) = 0 And UserList(TempCharIndex).showName Then 'No tiene descRM y quiere que se vea su nombre.
                If LenB(UserList(TempCharIndex).modName) > 0 Then
                    Stat = Stat & " <" & UserList(TempCharIndex).modName & ">"
                End If
                
                If Len(UserList(TempCharIndex).desc) > 0 Then
                    Stat = "Ves a " & UserList(TempCharIndex).name & Stat & " - " & UserList(TempCharIndex).desc
                Else
                    Stat = "Ves a " & UserList(TempCharIndex).name & Stat
                End If
                    If UserList(TempCharIndex).dios And dioses.SuperDios Then
                        Stat = Stat & " <Dios>"
                        ft = FontTypeNames.FONTTYPE_GM
                    ElseIf UserList(TempCharIndex).dios And dioses.centinela Then
                        Stat = Stat & " <Centinela>"
                        ft = FontTypeNames.FONTTYPE_CENTINELA
                    ElseIf UserList(TempCharIndex).admin = True Then
                        Stat = Stat & " <Admin de la partida>"
                        ft = FontTypeNames.FONTTYPE_GM
                    ElseIf criminal(TempCharIndex) Then
                        ft = FontTypeNames.FONTTYPE_FIGHT
                    Else
                        ft = FontTypeNames.FONTTYPE_CITIZEN
                    End If
                    If UserList(TempCharIndex).registrado = False Then
                        Stat = Stat & " [Invitado]"
                    Else
                        If UserList(TempCharIndex).nick <> UserList(TempCharIndex).name Then
                            Stat = Stat & " [" & UserList(TempCharIndex).nick & "]"
                        End If
                        If UserList(TempCharIndex).Wrank < 101 And UserList(TempCharIndex).Wrank > 0 Then
                            Stat = Stat & " Rank:" & UserList(TempCharIndex).Wrank
                        End If
                        If UserList(TempCharIndex).Stats.honor Then
                            Stat = Stat & " Honor:" & UserList(TempCharIndex).Stats.honor
                        End If
                    End If
            Else  'Si tiene descRM la muestro siempre.
                Stat = UserList(TempCharIndex).DescRM
                ft = FontTypeNames.FONTTYPE_INFOBOLD
            End If
            
            If LenB(Stat) > 0 Then
                Call WriteConsoleMsg(UserIndex, Stat, ft)
            End If
            
            FoundSomething = 1
            UserList(UserIndex).Flags.TargetUser = TempCharIndex
            UserList(UserIndex).Flags.TargetNPC = 0
            UserList(UserIndex).Flags.TargetNpcTipo = eNPCType.Comun
       End If

    End If
    If FoundChar = 2 Then '¿Encontro un NPC?
            Dim estatus As String
                estatus = "Ves a " '"(" & Npclist(TempCharIndex).Stats.MinHP & "/" & Npclist(TempCharIndex).Stats.MaxHP & ") "
            If Len(Npclist(TempCharIndex).desc) > 1 Then
                Call WriteChatOverHead(UserIndex, Npclist(TempCharIndex).desc, Npclist(TempCharIndex).Char.CharIndex, vbWhite)
            Else
                If Npclist(TempCharIndex).MaestroUser > 0 Then
                    Call WriteConsoleMsg(UserIndex, estatus & Npclist(TempCharIndex).name & " es mascota de " & UserList(Npclist(TempCharIndex).MaestroUser).name, FontTypeNames.FONTTYPE_INFO)
                Else
                    If Npclist(TempCharIndex).Bando = ePK Then
                        Call WriteConsoleMsg(UserIndex, estatus & Npclist(TempCharIndex).name & " <Bot>.", FontTypeNames.FONTTYPE_CITIZEN)
                    Else
                        Call WriteConsoleMsg(UserIndex, estatus & Npclist(TempCharIndex).name & " <Bot>.", FontTypeNames.FONTTYPE_FIGHT)
                    End If
                End If
                
            End If
            FoundSomething = 1
            UserList(UserIndex).Flags.TargetNpcTipo = Npclist(TempCharIndex).NPCtype
            UserList(UserIndex).Flags.TargetNPC = TempCharIndex
            UserList(UserIndex).Flags.TargetUser = 0
            UserList(UserIndex).Flags.TargetObj = 0
        
    End If
    
    If FoundChar = 0 Then
        UserList(UserIndex).Flags.TargetNPC = 0
        UserList(UserIndex).Flags.TargetNpcTipo = eNPCType.Comun
        UserList(UserIndex).Flags.TargetUser = 0
    End If
    
    'NO ENCOTRO NADA ***
    If FoundSomething = 0 Then
        UserList(UserIndex).Flags.TargetNPC = 0
        UserList(UserIndex).Flags.TargetNpcTipo = eNPCType.Comun
        UserList(UserIndex).Flags.TargetUser = 0
        UserList(UserIndex).Flags.TargetObj = 0
        UserList(UserIndex).Flags.TargetObjMap = 0
        UserList(UserIndex).Flags.TargetObjX = 0
        UserList(UserIndex).Flags.TargetObjY = 0
        'Call WriteConsoleMsg(UserIndex, "No ves nada interesante.", FontTypeNames.FONTTYPE_INFO)
    End If

Else
    If FoundSomething = 0 Then
        UserList(UserIndex).Flags.TargetNPC = 0
        UserList(UserIndex).Flags.TargetNpcTipo = eNPCType.Comun
        UserList(UserIndex).Flags.TargetUser = 0
        UserList(UserIndex).Flags.TargetObj = 0
        UserList(UserIndex).Flags.TargetObjMap = 0
        UserList(UserIndex).Flags.TargetObjX = 0
        UserList(UserIndex).Flags.TargetObjY = 0
        'Call WriteConsoleMsg(UserIndex, "No ves nada interesante.", FontTypeNames.FONTTYPE_INFO)
    End If
End If


End Sub

Function FindDirection(Pos As WorldPos, Target As WorldPos) As eHeading
'
'Devuelve la direccion en la cual el target se encuentra
'desde pos, 0 si la direc es igual
'
Dim X As Integer
Dim Y As Integer

X = Pos.X - Target.X
Y = Pos.Y - Target.Y

'NE
If Sgn(X) = -1 And Sgn(Y) = 1 Then
    FindDirection = IIf(RandomNumber(0, 1), eHeading.NORTH, eHeading.EAST)
    If FindDirection = NORTH And Not LegalPos(Pos.map, Pos.X, Pos.Y - 1) Then
        FindDirection = EAST
    ElseIf FindDirection = EAST And Not LegalPos(Pos.map, Pos.X + 1, Pos.Y) Then
        FindDirection = NORTH
    End If
    Exit Function
End If

'NW
If Sgn(X) = 1 And Sgn(Y) = 1 Then
    FindDirection = IIf(RandomNumber(0, 1), eHeading.WEST, eHeading.NORTH)
    If FindDirection = NORTH And Not LegalPos(Pos.map, Pos.X, Pos.Y - 1) Then
        FindDirection = WEST
    ElseIf FindDirection = WEST And Not LegalPos(Pos.map, Pos.X - 1, Pos.Y) Then
        FindDirection = NORTH
    End If
    Exit Function
End If

'SW
If Sgn(X) = 1 And Sgn(Y) = -1 Then
    FindDirection = IIf(RandomNumber(0, 1), eHeading.WEST, eHeading.SOUTH)
    If FindDirection = SOUTH And Not LegalPos(Pos.map, Pos.X, Pos.Y + 1) Then
        FindDirection = WEST
    ElseIf FindDirection = WEST And Not LegalPos(Pos.map, Pos.X - 1, Pos.Y) Then
        FindDirection = SOUTH
    End If
    Exit Function
End If

'SE
If Sgn(X) = -1 And Sgn(Y) = -1 Then
    FindDirection = IIf(RandomNumber(0, 1), eHeading.SOUTH, eHeading.EAST)
    If FindDirection = SOUTH And Not LegalPos(Pos.map, Pos.X, Pos.Y + 1) Then
        FindDirection = EAST
    ElseIf FindDirection = EAST And Not LegalPos(Pos.map, Pos.X + 1, Pos.Y) Then
        FindDirection = SOUTH
    End If
    Exit Function
End If

'Sur
If Sgn(X) = 0 And Sgn(Y) = -1 Then
    FindDirection = eHeading.SOUTH
    Exit Function
End If

'norte
If Sgn(X) = 0 And Sgn(Y) = 1 Then
    FindDirection = eHeading.NORTH
    Exit Function
End If

'oeste
If Sgn(X) = 1 And Sgn(Y) = 0 Then
    FindDirection = eHeading.WEST
    Exit Function
End If

'este
If Sgn(X) = -1 And Sgn(Y) = 0 Then
    FindDirection = eHeading.EAST
    Exit Function
End If

'misma
If Sgn(X) = 0 And Sgn(Y) = 0 Then
    FindDirection = 0
    Exit Function
End If

End Function

Public Function EsObjetoFijo(ByVal OBJType As eOBJType) As Boolean

EsObjetoFijo = OBJType = eOBJType.otForos Or _
               OBJType = eOBJType.otCarteles Or _
               OBJType = eOBJType.otArboles Or _
               OBJType = eOBJType.otYacimiento

End Function
