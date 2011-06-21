Attribute VB_Name = "modBot_MaTeO"
Public BotList(0 To MAXNPCS) As Integer
Public Cantidad_Bots As Integer
Public RemoHabilitado As Boolean
Public NumBandoBots(0 To 2) As Integer
Public NumRespawnBots(0 To 2) As Integer
Public NumNPCRespawnBots(0 To 2) As Integer
Private HechizoBot() As NpcAtaques
Private ZonaBot() As Explorar

Private Type NpcAtaques
    tipo As Byte '1, 2 o 3 tipo de hechizo
    Palabras As String 'Palabras en la head del Bot
    MaxHit As Byte 'Maximo golpe del hechizo. Pongo byte porque en Arduz no hay ni un hechizo que pegue mas que 255.
    MinHit As Byte 'Minimo golpe del hechizo. Idem arriba.
    FXNum As Byte 'No creo que haya mas de 255 -.-
    WAV As Byte 'Tampoco creo que hay mas de 255 auque este es mas probable
    Tiempo As Integer
    Prob As Integer
    Mana As Integer 'Mana que gasta el hechizo se configura desde otro lugar
    ToInvi As Byte '1 o 0 si afecta a los invis o no
End Type
Private Type Explorar
    map As Integer
    Zonas As Byte
    X() As Integer
    Y() As Integer
End Type
Private AppBot As String
Public Sub rehacer_lista_bots()
'If Not RemoHabilitado Then Exit Sub
On Error GoTo ErrHandler
    Dim loopc As Integer
    Dim i As Integer
    ZeroMemory BotList(0), MAXNPCS * 2
    NumBandoBots(0) = 0
    NumBandoBots(1) = 0
    NumBandoBots(2) = 0
    For i = 1 To LastNPC
        'Debug.Print "BotType: " & Npclist(i).Bot.BotType & " NPCActive: " & Npclist(i).flags.NPCActive
        If Npclist(i).Bot.BotType <> 0 And Npclist(i).Flags.NPCActive Then
            loopc = loopc + 1
            BotList(loopc) = i
            NumBandoBots(Npclist(i).Bando) = NumBandoBots(Npclist(i).Bando) + 1
        End If
    Next i
    
    Cantidad_Bots = loopc
    'Debug.Print "Cantidad de Bots: " & Cantidad_Bots
Exit Sub
ErrHandler:
Debug.Print "Error en la linea ListaBots: " & Erl()
End Sub

Public Sub CargarZonasBot()
On Error GoTo ErrHandler

1 AppBot = ""
2 AppBot = app.Path & "\Datos\DatosServer\BotExplorar.ini"
    Debug.Print "Mapas Zona> " & GetVar(AppBot, "INIT", "Mapas")
3 ReDim ZonaBot(1 To GetVar(AppBot, "INIT", "Mapas"))
4 Dim i As Integer
5 Dim b As Integer
6 For i = 1 To UBound(ZonaBot)
7    With ZonaBot(i)
8        .map = GetVar(AppBot, i, "Mapa")
9        .Zonas = GetVar(AppBot, i, "Zonas")
10        ReDim .X(1 To .Zonas)
11        ReDim .Y(1 To .Zonas)
12        For b = 1 To .Zonas
13        .X(b) = GetVar(AppBot, i, "X" & b)
14        .Y(b) = GetVar(AppBot, i, "Y" & b)
15        Next b
16    End With
17 Next i
Exit Sub
ErrHandler:
Debug.Print "Error en la linea A: " & Erl()
End Sub
Private Function BuscarZonaMap(ByVal NpcIndex As Integer) As Byte
'On Error GoTo ErrHandler

     'If UBound(ZonaBot) = 0 Then Exit Function
1    Dim i As Byte
2    For i = 1 To UBound(ZonaBot)
3        If Npclist(NpcIndex).Pos.map = ZonaBot(i).map Then
4        BuscarZonaMap = i
5        Exit Function
6        End If
7    Next i
8    BuscarZonaMap = 0
Exit Function
ErrHandler:
Debug.Print "Error en la linea B: " & Erl()
End Function
Public Function BuscarZona(ByVal NpcIndex As Integer) As Byte
On Error GoTo ErrHandler
    Dim i As Byte
    Dim Mapa As Byte
    Dim MejorDistancia As Integer
    Mapa = BuscarZonaMap(NpcIndex)
    If Mapa = 0 Then
    BuscarZona = 0
    Exit Function
    End If
    MejorDistancia = 0
    If Npclist(NpcIndex).Bot.Zona <> 0 Then
        'If Npclist(NpcIndex).Pos.X = ZonaBot(Mapa).X(Npclist(NpcIndex).flags.Zona) And Npclist(NpcIndex).Pos.Y = ZonaBot(Mapa).Y(Npclist(NpcIndex).flags.Zona) Then

        If Distancia2(Npclist(NpcIndex).Pos.Y, Npclist(NpcIndex).Pos.X, ZonaBot(Mapa).Y(Npclist(NpcIndex).Bot.Zona), ZonaBot(Mapa).X(Npclist(NpcIndex).Bot.Zona)) <= 1 Or Not LegalPos(ZonaBot(Mapa).map, ZonaBot(Mapa).X(Npclist(NpcIndex).Bot.Zona), ZonaBot(Mapa).Y(Npclist(NpcIndex).Bot.Zona)) Then
            Npclist(NpcIndex).Bot.Zona = 0
            BuscarZona = 0
        Else
            BuscarZona = 1

            'Debug.Print "Distancia: " & Distancia2(Npclist(NpcIndex).Pos.Y, Npclist(NpcIndex).Pos.X, ZonaBot(Mapa).Y(Npclist(NpcIndex).flags.Zona), ZonaBot(Mapa).X(Npclist(NpcIndex).flags.Zona))
        End If
        Exit Function
    End If
    
    For i = 1 To ZonaBot(Mapa).Zonas
    'If MapData(Mapa, ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i)).TileExit.Map > 0 And RandomNumber(1, 1) = 1 Then
    'ZonaRandom = i
    'BuscarZona = 1
    'Exit Function
    'End If
    If MejorDistancia = 0 And Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) <> 1 Then
        MejorDistancia = Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y)
        Npclist(NpcIndex).Bot.Zona = i
    ElseIf MejorDistancia - Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) < 8 And MejorDistancia - Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) > -8 Then
        If RandomNumber(1, 10) = 1 Then
            MejorDistancia = Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y)
            Npclist(NpcIndex).Bot.Zona = i
        End If
    ElseIf Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) < MejorDistancia And Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) <> 1 Then
        MejorDistancia = Distancia2(ZonaBot(Mapa).X(i), ZonaBot(Mapa).Y(i), Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y)
        Npclist(NpcIndex).Bot.Zona = i
    End If
    Next i
    BuscarZona = 1
Exit Function
ErrHandler:
Debug.Print "Error en la linea C: " & ERR
End Function
Public Function BuscarZonaX(ByVal NpcIndex As Integer) As Byte
On Error GoTo ErrHandler
    If BuscarZonaMap(NpcIndex) = 0 Then
    BuscarZonaX = 0
    Exit Function
    End If
    BuscarZonaX = ZonaBot(BuscarZonaMap(NpcIndex)).X(Npclist(NpcIndex).Bot.Zona)
Exit Function
ErrHandler:
Debug.Print "Error en la linea D: " & Erl()
End Function
Public Function BuscarZonaY(ByVal NpcIndex As Integer) As Byte 'Usamos primero Y para poder buscar la mejor distancia.
On Error GoTo ErrHandler
    If BuscarZonaMap(NpcIndex) = 0 Then
    BuscarZonaY = 0
    Exit Function
    End If
    BuscarZonaY = ZonaBot(BuscarZonaMap(NpcIndex)).Y(Npclist(NpcIndex).Bot.Zona)
Exit Function
ErrHandler:
Debug.Print "Error en la linea G: " & Erl()
End Function
Function FindBotPos(Pos As WorldPos, Target As WorldPos) As eHeading
'*****************************************************************
'Devuelve la direccion en la cual el target se encuentra
'desde pos, 0 si la direc es igual
'*****************************************************************
Dim MD As Integer
Dim i As Integer
Dim Pose As WorldPos
'Debug.Print Target.x & "-" & Target.y
For i = 1 To 4
    If i = 1 Then
        Pose = Pos
        Pose.Y = Pose.Y - 1
    ElseIf i = 2 Then
        Pose = Pos
        Pose.X = Pose.X + 1
    ElseIf i = 3 Then
        Pose = Pos
        Pose.Y = Pose.Y + 1
    ElseIf i = 4 Then
        Pose = Pos
        Pose.X = Pose.X - 1
    End If
    If Distancia(Pose, Target) > MD Or MD = 0 Then
        MD = i
    End If
Next i
    'Debug.Print MD
    If MD <= 2 Then
        MD = MD + 2
    Else
        MD = MD - 2
    End If
    FindBotPos = MD
    'Debug.Print FindBotPos
Exit Function


End Function
Public Sub CargarHechizosBot()
On Error GoTo ErrHandler
AppBot = app.Path & "\Datos\DatosServer\Bots.ini"
ReDim HechizoBot(1 To GetVar(AppBot, "INIT", "Num"))
Dim i As Byte
For i = 1 To UBound(HechizoBot)
    With HechizoBot(i)
        .tipo = GetVar(AppBot, i, "Tipo")
        If .tipo = 1 Then 'Remover paralisis
            .Palabras = GetVar(AppBot, i, "Palabras")
            .FXNum = GetVar(AppBot, i, "FXNum")
            .WAV = GetVar(AppBot, i, "WAV")
            .Tiempo = GetVar(AppBot, i, "Tiempo") 'En este caso es asi: Te inmovilizan y tarda ese tiempo luego cuando pasa ese tiempo vienen las probabilidades.
            .Prob = GetVar(AppBot, i, "Prob")
            .Mana = GetVar(AppBot, i, "Mana")
        ElseIf .tipo = 2 Then 'Paralisar
            .Palabras = GetVar(AppBot, i, "Palabras")
            .FXNum = GetVar(AppBot, i, "FXNum")
            .WAV = GetVar(AppBot, i, "WAV")
            .Tiempo = GetVar(AppBot, i, "Tiempo") 'Tiempo que dura el paralisis
            .Prob = GetVar(AppBot, i, "Prob")
            .Mana = GetVar(AppBot, i, "Mana")
            .ToInvi = GetVar(AppBot, i, "ToInvi")
            
        ElseIf .tipo = 3 Then 'Hechizo de daño
            .Palabras = GetVar(AppBot, i, "Palabras")
            .FXNum = GetVar(AppBot, i, "FXNum")
            .MaxHit = GetVar(AppBot, i, "MaxHit")
            .MinHit = GetVar(AppBot, i, "MinHit")
            .WAV = GetVar(AppBot, i, "WAV")
            .Prob = GetVar(AppBot, i, "Prob")
            .Mana = GetVar(AppBot, i, "Mana")
            .ToInvi = GetVar(AppBot, i, "ToInvi")
        End If 'Dejo asi para poder meter mas tipos despues
        
    End With
Next i
Exit Sub
ErrHandler:
Debug.Print "Error en la linea H: " & Erl()
End Sub
'Public Sub BotRChat(ByVal NpcIndex As Integer, ByVal Chat As String, ByVal UserIndex As Integer)
'On Error GoTo ErrHandler
''Debug.Print "Llego"
'Dim Random As Integer
'Dim Random2 As Integer
'Dim palabra As String
'
'
'If UserList(UserIndex).dios <> 255 Then Exit Sub
'If BuscarPalabra(Chat, "configurate") And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Configurando. El proximo dialogo que digas lo dire siempre.", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'    Npclist(NpcIndex).Bot.Config = 1
'ElseIf BuscarPalabra(Chat, "movement") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Movement = " & Npclist(NpcIndex).Movement, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "desconfig") And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Listo saludos :D", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'    Npclist(NpcIndex).Bot.Config = 0
'ElseIf Npclist(NpcIndex).Bot.Config = 1 And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Configure el dialogo:" & Chat, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'    Npclist(NpcIndex).desc = Chat
'    Npclist(NpcIndex).Bot.Config = 0
'End If
''Debug.Print "Tipo Bot: " & Npclist(NpcIndex).Bot.BotType
'If Npclist(NpcIndex).Bot.BotType = 0 Then Exit Sub
'If BuscarPalabra(Chat, "quien es el mejor") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("¡¡MaTeO!!", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "quien es la mejor") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("¡¡Dark Sonic!!", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "saluden") And UserList(UserIndex).dios = 255 Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Hola!!", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "opinas de martin lucas") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Le hago la cola, es un niuvi", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "callense") And UserList(UserIndex).dios = 255 Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Ok perdon :S", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "minman=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi mana minima es " & Npclist(NpcIndex).Bot.MinMan, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "minhp=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi vida minima es " & Npclist(NpcIndex).Stats.MinHP, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "maxman=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi mana maxima es " & Npclist(NpcIndex).Bot.MaxMan, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "maxhp=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi vida maxima es " & Npclist(NpcIndex).Stats.MaxHP, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "riesgohp=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Si pierdo mas de " & Npclist(NpcIndex).Bot.RiesgoHP & " de vida empiezo a curarme", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "riesgoat=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Si le erro  " & Npclist(NpcIndex).Bot.RiesgoAT & " veses a un hechizo empiezo a curarme vida y mana", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "uphp=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Me curo  " & Npclist(NpcIndex).Bot.UpHP & " de vida cada 220 ms", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "upman=") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Me curo  " & Npclist(NpcIndex).Bot.UpMan & " de mana cada 220 ms", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "quietos") Then
'    Npclist(NpcIndex).Bot.Bloqueado = True
'ElseIf BuscarPalabra(Chat, Npclist(NpcIndex).name & " morite") Then
'    Call MuereNpc(NpcIndex, 0)
'ElseIf BuscarPalabra(Chat, "agiten") Then
'    Npclist(NpcIndex).Bot.Bloqueado = False
'ElseIf BuscarPalabra(Chat, "tomen vida") Then
'    Random = RandomNumber(1, 10)
'    If Random = 1 Then
'        palabra = "Uh gracias sos un groso"
'    ElseIf Random = 2 Then
'        palabra = "Justo lo que necesitaba"
'    ElseIf Random = 3 Then
'        palabra = "Te zarpas :P"
'    ElseIf Random = 4 Then
'        palabra = "Mas vida? Genial!"
'    ElseIf Random = 5 Then
'        palabra = "Masss porfaaaaaa"
'    ElseIf Random = 6 Then
'        palabra = "Muchas gracias Sr."
'    ElseIf Random = 7 Then
'        palabra = "Lag"
'    ElseIf Random = 8 Then
'        palabra = "Me das oro?"
'    ElseIf Random = 9 Then
'        palabra = "Dame a mi solo"
'    Else
'        palabra = "100K?? DAME 10000000000000000KKKKK"
'    End If
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead(palabra, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, Npclist(NpcIndex).name) Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("¿Que pasa?", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "diganme su id") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi ID es " & NpcIndex, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, NpcIndex & " morite") Then
'    Call MuereNpc(NpcIndex, 0)
'ElseIf BuscarPalabra(Chat, NpcIndex & " team") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Ok :D!" & NpcIndex, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'    Npclist(NpcIndex).Bot.AmigoUSER = UserIndex
'    Npclist(NpcIndex).Target = 0
'ElseIf BuscarPalabra(Chat, "Mejor equipo") Then
'    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Racing Papa ;)", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'End If
'Exit Sub
'ErrHandler:
'Debug.Print "Error en la linea I: " & Erl()
'End Sub
'Private Function BuscarPalabra(ByVal Frase As String, ByVal Busco As String) As Boolean
'On Error GoTo ErrHandler
'Dim PosPalabra As Integer
'PosPalabra = InStr(1, Frase, Busco, vbTextCompare)
'If PosPalabra <> 0 Then
'    BuscarPalabra = True
'    Exit Function
'End If
'BuscarPalabra = False
'Exit Function
'ErrHandler:
'Debug.Print "Error en la linea J: " & Erl()
'End Function
'Public Sub BotUChat(ByVal NpcIndex As Integer, ByVal Chat As String, ByVal UserIndex As Integer)
'On Error GoTo ErrHandler
'With UserList(UserIndex)
'1        If BuscarPalabra(Chat, "remo") And Npclist(NpcIndex).Bot.MaxMan <> 0 And Npclist(NpcIndex).bando = UserList(UserIndex).bando Then
'2            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Yo te remuevo " & UserList(UserIndex).name & " ;)", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'3            Npclist(NpcIndex).Bot.AmigoUSER = UserIndex
'4            Npclist(NpcIndex).Target = 0
'5        ElseIf BuscarPalabra(Chat, "Hola") And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'6            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Hola " & UserList(UserIndex).name, Npclist(NpcIndex).Char.CharIndex, vbWhite))
'7        ElseIf BuscarPalabra(Chat, "Como andas") And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'8            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Bien y vos?", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'9        ElseIf BuscarPalabra(Chat, "Quien te creo?") And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'10            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("MaTeO me creo ;)", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'11        ElseIf (BuscarPalabra(Chat, "nw") Or BuscarPalabra(Chat, "new") Or BuscarPalabra(Chat, "newbie") Or BuscarPalabra(Chat, "niubi")) And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'12            If UserList(UserIndex).name = "Ares" Then
'13                Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("JAJAJA mira quien habla ajjaajajaj", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'14            Else
'15                Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Amigo no me digas newbie.", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'16            End If
'17        ElseIf (BuscarPalabra(Chat, "puto") Or BuscarPalabra(Chat, "feo") Or BuscarPalabra(Chat, "tonto") Or BuscarPalabra(Chat, "bobo") Or BuscarPalabra(Chat, "estupido")) And Distancia(Npclist(NpcIndex).Pos, UserList(UserIndex).Pos) <= 1 Then
'18            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("GM!! " & UserList(UserIndex).name & " ME ESTA INSULTANDO!!!!!", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'19        End If
'End With
'Exit Sub
'ErrHandler:
'Debug.Print "Error en la linea BotUChat: " & Erl()
'End Sub
'Public Sub BotChat(ByVal UserIndex As Integer, ByVal Chat As String)
'On Error GoTo ErrHandler
'With UserList(UserIndex)
'Dim y As Byte
'Dim x As Byte
'Dim NPC_TARGET() As Integer
'Dim USER_TARGET() As Integer
'Dim NPC_Cantidad As Integer
'Dim USER_Cantidad As Integer
'Dim TempIndex As Integer
'For y = .Pos.y - RANGO_VISION_Y To .Pos.y + RANGO_VISION_Y
'    For x = .Pos.x - RANGO_VISION_Y To .Pos.x + RANGO_VISION_Y
'        If x >= MinXBorder And x <= MaxXBorder And y >= MinYBorder And y <= MaxYBorder Then
'            If MapData(.Pos.map, x, y).NpcIndex <> 0 Then
'            'tempindex = MapData(.Pos.Map, X, Y).NpcIndex
'                'If Npclist(MapData(.Pos.Map, X, Y).NpcIndex).Movement = NpcBot Then 'Condiciones del enemigo para estar en nuestra lista
'                        'NPC_Cantidad = NPC_Cantidad + 1
'                        'ReDim Preserve NPC_TARGET(1 To NPC_Cantidad)
'                        'NPC_TARGET(NPC_Cantidad) = MapData(.Pos.Map, X, Y).NpcIndex
'100                        If UserList(UserIndex).dios = 255 Then
'200                            Call BotRChat(MapData(.Pos.map, x, y).NpcIndex, Chat, UserIndex)
'300                            Call BotUChat(MapData(.Pos.map, x, y).NpcIndex, Chat, UserIndex)
'400                        Else
'500                            Call BotUChat(MapData(.Pos.map, x, y).NpcIndex, Chat, UserIndex)
'600                            Exit Sub
'700                        End If
'                'End If
'            End If
'            'ElseIf MapData(.Pos.Map, X, Y).UserIndex <> 0 Then
'            'tempIndex = MapData(.Pos.Map, X, Y).UserIndex
'            '    If UserList(tempIndex).flags.Muerto = 0 And UserList(tempIndex).flags.AdminPerseguible Then 'Condiciones del enemigo para estar en nuestra lista
'            '        USER_Cantidad = USER_Cantidad + 1
'            '        ReDim Preserve USER_TARGET(1 To USER_Cantidad)
'            '        USER_TARGET(USER_Cantidad) = MapData(.Pos.Map, X, Y).UserIndex
'            '    End If
'
'        End If
'    Next x
'Next y
'End With
'If UserList(UserIndex).dios <> 255 Then Exit Sub
'If BuscarPalabra(Chat, "deathmatch ya!!!") Then
'    Random = SpawnNpc(916, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(916, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(916, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(917, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(917, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(917, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(918, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(918, UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(918, UserList(UserIndex).Pos, False, False)
'ElseIf BuscarPalabra(Chat, "mi mapa") Then
'    Debug.Print "Mapa> " & UserList(UserIndex).Pos.map
'    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageChatOverHead(UserList(UserIndex).Pos.map, UserList(UserIndex).Char.CharIndex, vbWhite))
'ElseIf BuscarPalabra(Chat, "crear bot pk") Then
'    Call CrearNPC(50, servermap, UserList(UserIndex).Pos, eKip.epk)
'ElseIf BuscarPalabra(Chat, "crear bot cui") Then
'    Call CrearNPC(50, servermap, UserList(UserIndex).Pos, eKip.ecui)
'    'Call SpawnNpc(905, UserList(UserIndex).Pos, False, False)
'ElseIf BuscarPalabra(Chat, "mapaconfigurate") Then
'1    Dim Zona As WorldPos
'2    Dim Zonas As Byte
'3    Dim MapaZona As Byte
'4    Dim i As Integer
'5    Dim i2 As Integer
'6    Dim i3 As Integer
'7    Dim i4 As Integer
'8    AppBot = app.path & "\BotExplorar.ini"
'9    For i = 1 To GetVar(AppBot, "INIT", "Mapas")
'10        If GetVar(AppBot, i, "Mapa") = UserList(UserIndex).Pos.map Then
'11            MapaZona = i
'12            Exit For
'13        End If
'14    Next i
'15    If MapaZona = 0 Then
'16        MapaZona = UBound(ZonaBot) + 1
'17    End If
'18    Zona.map = UserList(UserIndex).Pos.map
'19    Zona.x = 10
'20    Zona.y = 10
'21    Call WriteVar(AppBot, MapaZona, "Mapa", Zona.map)
'22    i = 0
'23    i2 = 0
'24    i3 = 0
'25    For i3 = 1 To 14
'26        Zona.y = Zona.y + 5
'27        Zona.x = 10
'28        'i4 = i4 + 1
'29        For i2 = 1 To 14
'
'30        Zona.x = Zona.x + 5
'31        'i4 = i4 + 1
'32            For i = -5 To 5
'33                If LegalPos(Zona.map, Zona.x + i, Zona.y + i, True, True) And MapData(Zona.map, Zona.x + i, Zona.y + i).Blocked = 0 Then
'34                    Zonas = Zonas + 1
'35                    Call WriteVar(AppBot, MapaZona, "X" & Zonas, Zona.x + i)
'36                    Call WriteVar(AppBot, MapaZona, "Y" & Zonas, Zona.y + i)
'37                    Exit For
'38                End If
'39            Next i
'40        Next i2
'        'i4 = i4 - 1
'41    Next i3
'42    Call WriteVar(AppBot, MapaZona, "Zonas", Zonas)
'43    If MapaZona = UBound(ZonaBot) + 1 Then
'44        Call WriteVar(AppBot, "INIT", "Mapas", MapaZona)
'45    End If
'
'    'Call WriteVar(AppBot, "INIT", "Mapas", MapaZona)
'46    Call CargarZonasBot
'ElseIf BuscarPalabra(Chat, "Cargar Zona Bots") Then
'    Call CargarZonasBot
'ElseIf BuscarPalabra(Chat, "respawn bots mapa") Then
'    Dim Pose As WorldPos
'    Pose.map = UserList(UserIndex).Pos.map
'
'    For i = 1 To 20
'        Pose.x = RandomNumber(20, 80)
'        Pose.y = RandomNumber(20, 80)
'        Call SpawnNpc(916 + RandomNumber(0, 3), Pose, False, False)
'    Next i
'ElseIf BuscarPalabra(Chat, "matar bots mapa") Then
'        For y = 10 To 90
'            For x = 10 To 90
'                If x > 0 And y > 0 And x < 101 And y < 101 Then
'                    If MapData(UserList(UserIndex).Pos.map, x, y).NpcIndex > 0 Then
'                        If Npclist(MapData(UserList(UserIndex).Pos.map, x, y).NpcIndex).Bot.BotType <> 0 Then Call QuitarNPC(MapData(UserList(UserIndex).Pos.map, x, y).NpcIndex)
'                    End If
'                End If
'            Next x
'        Next y
'ElseIf BuscarPalabra(Chat, "1 vs 1") Then
'    Random = SpawnNpc(916 + RandomNumber(0, 3), UserList(UserIndex).Pos, False, False)
'    Random = SpawnNpc(916 + RandomNumber(0, 3), UserList(UserIndex).Pos, False, False)
'ElseIf BuscarPalabra(Chat, "2 vs 2") Then
'    Random = SpawnNpc(916, UserList(UserIndex).Pos, False, False)
'    Random2 = SpawnNpc(917, UserList(UserIndex).Pos, False, False)
'    Npclist(Random).Bot.AmigoNPC = Random2
'    Npclist(Random2).Bot.AmigoNPC = Random
'    Call SendData(SendTarget.ToNPCArea, Random2, PrepareMessageChatOverHead(Npclist(Random).name & " team", Npclist(Random2).Char.CharIndex, vbWhite))
'    Call SendData(SendTarget.ToNPCArea, Random, PrepareMessageChatOverHead(Npclist(Random2).name & " team", Npclist(Random).Char.CharIndex, vbWhite))
'    Random = SpawnNpc(918, UserList(UserIndex).Pos, False, False)
'    Random2 = SpawnNpc(919, UserList(UserIndex).Pos, False, False)
'    Call SendData(SendTarget.ToNPCArea, Random2, PrepareMessageChatOverHead(Npclist(Random).name & " team", Npclist(Random2).Char.CharIndex, vbWhite))
'    Call SendData(SendTarget.ToNPCArea, Random, PrepareMessageChatOverHead(Npclist(Random2).name & " team", Npclist(Random).Char.CharIndex, vbWhite))
'    Npclist(Random).Bot.AmigoNPC = Random2
'    Npclist(Random2).Bot.AmigoNPC = Random
'End If
'Exit Sub
'ErrHandler:
'Debug.Print "Error en la linea K: " & Erl()
'End Sub
Private Function GastarMana(ByVal NpcIndex As Integer, ByVal Gasto As Integer) As Boolean
On Error GoTo ErrHandler
With Npclist(NpcIndex).Bot
    If .MinMan - Gasto >= 0 Then
    GastarMana = True
    Else
    GastarMana = False 'Devuelvo false si no tengo mana suficiente
    .ToMan = True
    Call CancelCombo(NpcIndex)
    'Debug.Print "No puedo porque me da " & .Stats.MinMan & "-" & Gasto
    End If
End With
Exit Function
ErrHandler:
Debug.Print "Error en la linea L: " & Erl()
End Function
Public Sub BotPocion(ByVal NpcIndex As Integer)
On Error GoTo ErrHandler
    If Not puede_npc(NpcIndex, 1000) Then Exit Sub
     If Npclist(NpcIndex).Bot.ToHP = False And Npclist(NpcIndex).Bot.ToMan = False And Npclist(NpcIndex).Bot.Combeando = 0 Then
        Npclist(NpcIndex).Bot.Combeando = RandomNumber(1, Npclist(NpcIndex).Bot.NumCombos)
        Npclist(NpcIndex).Bot.NumComboActual = 1
        Npclist(NpcIndex).Bot.ComboActual = Npclist(NpcIndex).Bot.Combos(Npclist(NpcIndex).Bot.Combeando).Num(Npclist(NpcIndex).Bot.NumComboActual)
        Debug.Print "Te voy hacer mi combo: " & Npclist(NpcIndex).Bot.Combeando & "-" & Npclist(NpcIndex).Bot.ComboActual
        'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Te voy hacer mi combo: " & Npclist(NpcIndex).Bot.Combeando, Npclist(NpcIndex).Char.CharIndex, vbCyan))
        Exit Sub
     End If
1    If Npclist(NpcIndex).Stats.MinHP <> Npclist(NpcIndex).Stats.MaxHP And Npclist(NpcIndex).Bot.TargetsDisp = 0 Then
2         Npclist(NpcIndex).Bot.ToHP = True
3    ElseIf Npclist(NpcIndex).Bot.MinMan <> Npclist(NpcIndex).Stats.MaxMan And Npclist(NpcIndex).Bot.TargetsDisp = 0 Then
4         Npclist(NpcIndex).Bot.ToMan = True
5    End If

6    If Npclist(NpcIndex).Stats.MinHP < Npclist(NpcIndex).Stats.MaxHP - Npclist(NpcIndex).Bot.RiesgoHP Or (Npclist(NpcIndex).Bot.ToHP And Npclist(NpcIndex).Stats.MinHP <> Npclist(NpcIndex).Stats.MaxHP) Then
7        Npclist(NpcIndex).Stats.MinHP = Npclist(NpcIndex).Stats.MinHP + Npclist(NpcIndex).Bot.UpHP
8        Npclist(NpcIndex).Bot.ToHP = True
         If Npclist(NpcIndex).Bot.Combeando <> 0 Then Call CancelCombo(NpcIndex)
        'If Npclist(NpcIndex).CanAttack = 1 Then
9            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(SND_BEBER, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
            'Npclist(NpcIndex).CanAttack = 0
        'End If
10        If Npclist(NpcIndex).Stats.MaxHP <= Npclist(NpcIndex).Stats.MinHP Then
11            Npclist(NpcIndex).Stats.MinHP = Npclist(NpcIndex).Stats.MaxHP
12            Npclist(NpcIndex).Bot.ToHP = False
13        End If
14        Call BotHechizo(NpcIndex, 0, 0)
        'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi vida es: " & Npclist(NpcIndex).Stats.MinHP, Npclist(NpcIndex).Char.CharIndex, vbRed))
15    ElseIf Npclist(NpcIndex).Bot.ToMan Or Npclist(NpcIndex).Stats.MinMan < Npclist(NpcIndex).Stats.MaxMan - Npclist(NpcIndex).Bot.RiesgoMan Then
16        Npclist(NpcIndex).Bot.MinMan = Npclist(NpcIndex).Bot.MinMan + ((Npclist(NpcIndex).Bot.MaxMan / 100) * Npclist(NpcIndex).Bot.UpMan)
17        Npclist(NpcIndex).Bot.ToMan = True
            If Npclist(NpcIndex).Bot.Combeando <> 0 Then Call CancelCombo(NpcIndex)
        'If Npclist(NpcIndex).CanAttack = 1 Then
18          Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(SND_BEBER, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
        'Debug.Print Npclist(NpcIndex).Bot.MinMan + ((Npclist(NpcIndex).Bot.MaxMan / 100) * Npclist(NpcIndex).Bot.UpMan)
            'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi mana es: " & Npclist(NpcIndex).Bot.MinMan, Npclist(NpcIndex).Char.CharIndex, vbCyan))

            'If Npclist(NpcIndex).Bot.MinMan < Npclist(NpcIndex).Bot.MaxMan / 2 * 3 Then Call BotHechizo(NpcIndex, 0, 0)
19        If Npclist(NpcIndex).Bot.MaxMan < Npclist(NpcIndex).Bot.MinMan Then
20          Npclist(NpcIndex).Bot.MinMan = Npclist(NpcIndex).Bot.MaxMan
21          Npclist(NpcIndex).Bot.ToMan = False
22        End If
'            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mi mana es: " & Npclist(NpcIndex).Stats.MinMan, Npclist(NpcIndex).Char.CharIndex, vbCyan))
23    End If
Exit Sub
ErrHandler:
Debug.Print "Error en la linea M: " & Erl()
End Sub
Public Function BotPuedeAtacar(ByVal NpcIndex As Integer, ByVal tIndex As Integer, ByVal User As Boolean) As Boolean
On Error GoTo ErrHandler
With Npclist(NpcIndex).Bot
    If .ToHP Then
        BotPuedeAtacar = True
        Call BotHechizo(NpcIndex, 0, 0)
        Exit Function
    End If

    'If Npclist(NpcIndex).flags.Paralizado = 1 Or Npclist(NpcIndex).flags.Inmovilizado = 1 Then
    '    BotPuedeAtacar = False
    '    Call BotHechizo(NpcIndex, 0, False)
    '    Debug.Print "Estoy paralizado"
    'Exit Function
    'End If
    
    If User Then
        If UserList(tIndex).Flags.Paralizado = 1 Or UserList(tIndex).Flags.Inmovilizado = 1 Then
            '.ToMan = False
            BotPuedeAtacar = False
            Call BotHechizo(NpcIndex, tIndex, 2)
            Exit Function
        End If
    Else
        If Npclist(tIndex).Flags.Paralizado = 1 Or Npclist(tIndex).Flags.Inmovilizado = 1 Then
            '.ToMan = False
            Call BotHechizo(NpcIndex, tIndex, 1)
            BotPuedeAtacar = False
            Exit Function
        End If
    End If
    BotPuedeAtacar = True
End With
Exit Function
ErrHandler:
Debug.Print "Error en la linea N: " & Erl()
End Function
Public Sub BotHechizo(ByVal NpcIndex As Integer, ByVal tIndex As Integer, ByVal User As Byte)
On Error GoTo ErrHandler
With Npclist(NpcIndex)
'If .Stats.ToMan = True Then Exit Sub
If User = 2 Then
    If UserList(tIndex).Bando = .Bando And .Bando <> eKip.enone Then .Target = 0: Exit Sub
    If (.Pos.X - UserList(tIndex).Pos.X < -7 Or .Pos.X - UserList(tIndex).Pos.X > 7) _
    Or (.Pos.Y - UserList(tIndex).Pos.Y < -5 Or .Pos.Y - UserList(tIndex).Pos.Y > 5) Then Exit Sub 'Lo perdemos de la pantalla y lo buscamos
ElseIf User = 1 Then
    If Npclist(tIndex).Bando = .Bando And .Bando <> eKip.enone Then .TargetNPC = 0: Exit Sub
    If (.Pos.X - Npclist(tIndex).Pos.X < -7 Or .Pos.X - Npclist(tIndex).Pos.X > 7) _
    Or (.Pos.Y - Npclist(tIndex).Pos.Y < -5 Or .Pos.Y - Npclist(tIndex).Pos.Y > 5) Then Exit Sub 'Lo perdemos de la pantalla y lo buscamos
End If


1    If User = 2 And tIndex <> 0 Then
2        If UserList(tIndex).Flags.Muerto = 1 Then Exit Sub
3    ElseIf User = 1 And tIndex <> 0 Then
4        If Npclist(tIndex).Flags.NPCActive = False Then Exit Sub
5    End If
    .Bot.Ataques = .Bot.Ataques + 1
    'Debug.Print .flags.Ataques
    If .Stats.MinHP = .Stats.MaxHP Then .Bot.ToHP = False
    If .Bot.Ataques >= .Bot.RiesgoAT Then 'Si tiramos siertos hechizos y seguimos de pie hacemos esto.
        .Bot.ToHP = True
        .Bot.Ataques = 0
    End If
    'Debug.Print .ultimoy
    If Not (puede_npc_y(NpcIndex, 1200) And puede_npc(NpcIndex, 1000)) Then Exit Sub
    Dim NumRemo As Byte
    Dim daño As Byte
    NumRemo = BuscarRemo(NpcIndex)
    If (.Flags.Inmovilizado = 1 Or .Flags.Paralizado = 1) And NumRemo <> 0 Then
        'Debug.Print .Contadores.Paralisis & "-" & .Contadores.Paralisis - HechizoBot(NumRemo).Tiempo
        If .Contadores.Paralisis < IntervaloParalizado - HechizoBot(NumRemo).Tiempo + RandomNumber(20, -10) And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) And RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(NumRemo).Prob Then 'And 2 = RandomNumber(0, HechizoBot(NumRemo).Prob) And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) Then
            .Bot.MinMan = .Bot.MinMan - HechizoBot(NumRemo).Mana
            .Flags.Inmovilizado = 0
            .Flags.Paralizado = 0
            '.CanAttack = 0
            .ultimoy = (GetTickCount() And &H7FFFFFFF)
            Call CreaHechizo(NpcIndex, 0, HechizoBot(NumRemo).FXNum, HechizoBot(NumRemo).Palabras, HechizoBot(NumRemo).WAV, 1)
        End If
    Exit Sub 'Si estoy paralizado no tiro otro hechizo
    End If
    If MapInfo(.Pos.map).Pk = False Then Exit Sub
    If .Bot.ToHP Then Exit Sub
    If .Bot.ToMan Then Exit Sub
    If tIndex = 0 Then Exit Sub
    If User = 0 Then Exit Sub
    If User = 2 Then
        If .Pos.map <> UserList(tIndex).Pos.map Then Exit Sub
    ElseIf User = 1 Then
        If .Pos.map <> Npclist(tIndex).Pos.map Then Exit Sub
    End If
    If .Bot.BotType = 4 And RandomNumber(1, 100) <= .Bot.ArcoAIM And puede_npc(NpcIndex, 1400) Then '¡Cazador ;)!
        If User = 2 Then
            Call SendData(toMap, .Pos.map, PrepareCrearProyectil(.Char.CharIndex, 0, UserList(tIndex).Char.CharIndex))
            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageAnim_Attack(.Char.CharIndex))
            Call SistemaCombate.NpcAtacaUser(NpcIndex, tIndex)
        ElseIf User = 1 Then
            Call SendData(toMap, .Pos.map, PrepareCrearProyectil(.Char.CharIndex, 0, Npclist(tIndex).Char.CharIndex))
            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageAnim_Attack(.Char.CharIndex))
            Call SistemaCombate.NpcAtacaNpc(NpcIndex, tIndex)
        End If
        Exit Sub
    ElseIf puede_npc(NpcIndex, 1400) And .Bot.BotType = 4 Then
        If User = 2 Then
            Call SendData(toMap, .Pos.map, PrepareCrearProyectil(.Char.CharIndex, 0, UserList(tIndex).Char.CharIndex))
            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageAnim_Attack(.Char.CharIndex))
            .ultimox = GetTickCount
        ElseIf User = 1 Then
            Call SendData(toMap, .Pos.map, PrepareCrearProyectil(.Char.CharIndex, 0, Npclist(tIndex).Char.CharIndex))
            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageAnim_Attack(.Char.CharIndex))
            .ultimox = GetTickCount
        End If
        Exit Sub
    End If
    'If Npclist(tIndex).Pos.Map = 1 Then
    '    Call SendData(SendTarget.ToNPCArea, tIndex, PrepareMessageChatOverHead("Me ataco: " & .name & " del mapa " & .Pos.Map, Npclist(tIndex).Char.CharIndex, vbWhite))
    'End If
    If .Bot.AmigoUSER <> 0 Then
        Debug.Print "Remuevo"
        If RandomNumber(1, 1) = 1 And UserList(.Bot.AmigoUSER).Flags.Inmovilizado = 1 Or UserList(.Bot.AmigoUSER).Flags.Paralizado = 1 And UserList(.Bot.AmigoUSER).Flags.Muerto = 0 Then
            tIndex = .Bot.AmigoUSER
            User = 2
            If (UserList(tIndex).Flags.Inmovilizado = 1 Or UserList(tIndex).Flags.Paralizado = 1) And NumRemo <> 0 Then
                    If UserList(tIndex).Counters.Paralisis < IntervaloParalizado - HechizoBot(NumRemo).Tiempo And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) And RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(NumRemo).Prob Then 'And 2 = RandomNumber(0, HechizoBot(NumRemo).Prob) And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) Then
                        .Bot.MinMan = .Bot.MinMan - HechizoBot(NumRemo).Mana
                        UserList(tIndex).Flags.Inmovilizado = 0
                        UserList(tIndex).Flags.Paralizado = 0
                        '.CanAttack = 0
                        .ultimoy = (GetTickCount() And &H7FFFFFFF)
                        .Bot.AmigoNPC = 0
                        .Bot.AmigoUSER = 0
                        Call WriteConsoleMsg(tIndex, .name & " te ha removido la paralisis", FontTypeNames.FONTTYPE_FIGHT)
                        'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Te removi " & UserList(tIndex).name, .Char.CharIndex, vbWhite))
                        Call WriteParalizeOK(tIndex)
                        Call CreaHechizo(NpcIndex, tIndex, HechizoBot(NumRemo).FXNum, HechizoBot(NumRemo).Palabras, HechizoBot(NumRemo).WAV, User)
                    End If
            End If
            Exit Sub
        End If
    ElseIf .Bot.AmigoNPC <> 0 Then
        If RandomNumber(1, 1) = 1 And Npclist(.Bot.AmigoNPC).Flags.Inmovilizado = 1 Or Npclist(.Bot.AmigoNPC).Flags.Paralizado = 1 Then
            tIndex = .Bot.AmigoNPC
            User = 1
            If (Npclist(tIndex).Flags.Inmovilizado = 1 Or Npclist(tIndex).Flags.Paralizado = 1) And NumRemo <> 0 Then
                    If Npclist(tIndex).Contadores.Paralisis < IntervaloParalizado - HechizoBot(NumRemo).Tiempo And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) And RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(NumRemo).Prob Then 'And 2 = RandomNumber(0, HechizoBot(NumRemo).Prob) And GastarMana(NpcIndex, HechizoBot(NumRemo).Mana) Then
                        .Bot.MinMan = .Bot.MinMan - HechizoBot(NumRemo).Mana
                        Npclist(tIndex).Flags.Inmovilizado = 0
                        Npclist(tIndex).Flags.Paralizado = 0
                        '.CanAttack = 0
                        .ultimoy = (GetTickCount() And &H7FFFFFFF)
                        'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Te removi " & Npclist(tIndex).name, .Char.CharIndex, vbWhite))
                        Call CreaHechizo(NpcIndex, tIndex, HechizoBot(NumRemo).FXNum, HechizoBot(NumRemo).Palabras, HechizoBot(NumRemo).WAV, User)
                    End If
            End If
            Exit Sub
        End If
    End If
    'Si no tengo remo y tengo hechizos vamos a tirar hechizos inmovilizado :D
6    Dim SpellI As Integer
    If .Bot.ComboActual = 255 Then Exit Sub
    'Debug.Print "Combeando: " & .Bot.Combeando & "-" & .Bot.ComboActual
    .ultimoy = (GetTickCount() And &H7FFFFFFF)
    For i = 1 To .Bot.NroSpellsBot
        If .Bot.ComboActual = 0 Then
            SpellI = i
        Else
            SpellI = .Bot.ComboActual
            'i = .Bot.NroSpellsBot
        End If
        Debug.Print "Spell I " & SpellI & "-" & .Bot.ComboActual & "-" & .Bot.Combeando
        If HechizoBot(.Bot.SpellsBot(SpellI)).tipo = 2 Then
            If User = 2 Then 'Si es usuario
                If UserList(tIndex).Flags.Paralizado = 0 And RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(.Bot.SpellsBot(SpellI)).Prob And GastarMana(NpcIndex, HechizoBot(.Bot.SpellsBot(SpellI)).Mana) Then
                    
8                   Call CreaHechizo(NpcIndex, tIndex, HechizoBot(.Bot.SpellsBot(SpellI)).FXNum, HechizoBot(.Bot.SpellsBot(SpellI)).Palabras, HechizoBot(.Bot.SpellsBot(SpellI)).WAV, User)
                    UserList(tIndex).Flags.Inmovilizado = 1
                    UserList(tIndex).Flags.Paralizado = 1
                    UserList(tIndex).Counters.Paralisis = HechizoBot(.Bot.SpellsBot(SpellI)).Tiempo
                    '.CanAttack = 0
                    .ultimoy = (GetTickCount() And &H7FFFFFFF)
                    '[MODIFICADO]
                        'Call AmigoRemo(tIndex, User)
                    '[MODIFICADO]
                    .Bot.Ataques = 0
                    Call WriteParalizeOK(tIndex)
                    .Bot.MinMan = .Bot.MinMan - HechizoBot(.Bot.SpellsBot(SpellI)).Mana
                    Call WriteConsoleMsg(tIndex, .name & " te ha paralizado", FontTypeNames.FONTTYPE_FIGHT)
9                    Call NextCombo(NpcIndex)
                    Exit Sub
                ElseIf UserList(tIndex).Flags.Paralizado = 1 Then
                    If .Bot.Combeando <> 0 Then Call NextCombo(NpcIndex): Exit Sub
                Else
                    'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Mierda le erre", Npclist(NpcIndex).Char.CharIndex, vbCyan))
                End If
7            ElseIf User = 1 Then 'Si es NPC
                If Npclist(tIndex).Flags.Paralizado = 0 And RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(.Bot.SpellsBot(SpellI)).Prob And GastarMana(NpcIndex, HechizoBot(.Bot.SpellsBot(SpellI)).Mana) Then
                    Call CreaHechizo(NpcIndex, tIndex, HechizoBot(.Bot.SpellsBot(SpellI)).FXNum, HechizoBot(.Bot.SpellsBot(SpellI)).Palabras, HechizoBot(.Bot.SpellsBot(SpellI)).WAV, User)
                    Npclist(tIndex).Flags.Inmovilizado = 1
                    Npclist(tIndex).Flags.Paralizado = 1
                    Npclist(tIndex).Contadores.Paralisis = HechizoBot(.Bot.SpellsBot(SpellI)).Tiempo
                    '.CanAttack = 0
                    .ultimoy = (GetTickCount() And &H7FFFFFFF)
                    .Bot.MinMan = .Bot.MinMan - HechizoBot(.Bot.SpellsBot(SpellI)).Mana
                    .Bot.Ataques = 0
10                    Call NextCombo(NpcIndex)
                    Exit Sub
                ElseIf Npclist(tIndex).Flags.Paralizado = 1 Then
                    If .Bot.Combeando <> 0 Then Call NextCombo(NpcIndex): Exit Sub
                End If
            End If
            '(UserList(UserIndex).flags.invisible = 1 And HechizoBot(.SpellsBot(SpellI)).ToInvi = 0)
        ElseIf HechizoBot(.Bot.SpellsBot(SpellI)).tipo = 3 Then
            If RandomNumber(1, 100 - .Bot.Dificultad) <= HechizoBot(.Bot.SpellsBot(SpellI)).Prob And GastarMana(NpcIndex, HechizoBot(.Bot.SpellsBot(SpellI)).Mana) Then
                daño = RandomNumber(HechizoBot(.Bot.SpellsBot(SpellI)).MinHit, HechizoBot(.Bot.SpellsBot(SpellI)).MaxHit)
                '.CanAttack = 0
                .ultimoy = (GetTickCount() And &H7FFFFFFF)
                .Bot.Ataques = 0
                Call CreaHechizo(NpcIndex, tIndex, HechizoBot(.Bot.SpellsBot(SpellI)).FXNum, HechizoBot(.Bot.SpellsBot(SpellI)).Palabras, HechizoBot(.Bot.SpellsBot(SpellI)).WAV, User)
                .Bot.MinMan = .Bot.MinMan - HechizoBot(.Bot.SpellsBot(SpellI)).Mana
                If User = 2 Then 'Si es usuario
                    If UserList(tIndex).Invent.CascoEqpObjIndex > 0 Then
                        daño = daño - RandomNumber(ObjData(UserList(tIndex).Invent.CascoEqpObjIndex).DefensaMagicaMin, ObjData(UserList(tIndex).Invent.CascoEqpObjIndex).DefensaMagicaMax)
                    End If
                    
                    If UserList(tIndex).Invent.AnilloEqpObjIndex > 0 Then
                        daño = daño - RandomNumber(ObjData(UserList(tIndex).Invent.AnilloEqpObjIndex).DefensaMagicaMin, ObjData(UserList(tIndex).Invent.AnilloEqpObjIndex).DefensaMagicaMax)
                    End If
                    If UserList(tIndex).Stats.MinHP - daño < 0 Then
                        Call UserDie(tIndex)
                        Call WriteConsoleMsg(tIndex, .name & " te ha sacado " & daño & " de vida", FontTypeNames.FONTTYPE_FIGHT)
                        Call WriteConsoleMsg(tIndex, .name & " te ha matado", FontTypeNames.FONTTYPE_FIGHT)
                        Call CancelCombo(NpcIndex)
                    Else
                        UserList(tIndex).Stats.MinHP = UserList(tIndex).Stats.MinHP - daño
                        Call WriteConsoleMsg(tIndex, .name & " te ha sacado " & daño & " de vida", FontTypeNames.FONTTYPE_FIGHT)
                        Call WriteUpdateHP(tIndex)
                        Call NextCombo(NpcIndex)
                    End If
                    Exit Sub
                ElseIf User = 1 Then 'Si es NPC
                    If Npclist(tIndex).Stats.MinHP - daño < 0 Then
                        Call MuereNpc(tIndex, 0)
                        Call CancelCombo(NpcIndex)
                    Else
                        Npclist(tIndex).Stats.MinHP = Npclist(tIndex).Stats.MinHP - daño
                        Call NextCombo(NpcIndex)
                    End If
                    Exit Sub
                End If
            End If
        End If
    Next i
End With
Exit Sub
ErrHandler:
Debug.Print "BotHechizo error linea: " & Erl()
End Sub
Private Function BuscarRemo(ByVal NpcIndex As Integer) As Byte
On Error GoTo ErrHandler

1    For i = 1 To Npclist(NpcIndex).Bot.NroSpellsBot
2        If HechizoBot(Npclist(NpcIndex).Bot.SpellsBot(i)).tipo = 1 Then
3            BuscarRemo = Npclist(NpcIndex).Bot.SpellsBot(i)
4            Exit Function
5        End If
6    Next i
7    BuscarRemo = 0
Exit Function
ErrHandler:
Debug.Print "Error en la linea P: " & Erl()
End Function
Private Sub CreaHechizo(ByVal NpcIndex As Integer, ByVal UserIndex As Integer, ByVal FX As Byte, ByVal Palabras As String, ByVal WAV As Byte, ByVal User As Byte)
On Error GoTo ErrHandler
    'If FX = 0 And Palabras = "" And WAV = 0 Then Exit Sub
    If User = 0 Then Exit Sub
    If User = 2 Then
    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead(Palabras, Npclist(NpcIndex).Char.CharIndex, vbCyan))
    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(WAV, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
    If UserIndex = 0 Then Exit Sub
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, FX, 0))
    ElseIf User = 1 Then
    'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead(Npclist(NpcIndex).Stats.MinMan, Npclist(NpcIndex).Char.CharIndex, vbCyan))
    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead(Palabras, Npclist(NpcIndex).Char.CharIndex, vbCyan))
    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(WAV, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
    'Call SendData(SendTarget.ToNPCArea, UserIndex, PrepareMessageCreateFX(Npclist(UserIndex).Char.CharIndex, FX, 1))
    If UserIndex = 0 Then Exit Sub
    Npclist(UserIndex).Char.FX = FX
    Npclist(UserIndex).Char.loops = 0
    Call SendData(SendTarget.ToNPCArea, UserIndex, PrepareMessageCreateFX(Npclist(UserIndex).Char.CharIndex, FX, 0))
    End If
Exit Sub
ErrHandler:
Debug.Print "Error en la linea Q: " & Erl()
End Sub
Public Sub PeleaNPCBotMix(ByVal NpcIndex As Integer) 'AI de bots
On Error GoTo ErrHandler
    'Npclist(NpcIndex).Target = 0
    Dim tHeading As Byte
    Dim X As Long
    Dim Y As Long
    Dim TempIndex As Integer
    Dim NPC_TARGET() As Integer
    Dim USER_TARGET() As Integer
    Dim NPC_Cantidad As Integer
    Dim USER_Cantidad As Integer
    Dim tipo As Byte
    Dim Pose As WorldPos
    USER_Cantidad = 0
    NPC_Cantidad = 0
    Call BotPocion(NpcIndex)
    With Npclist(NpcIndex)
        If .Bot.Bloqueado Then Exit Sub
        If .Target <> 0 Then
            If UserList(.Target).Bando = .Bando And .Bando <> eKip.enone Then
                .Target = 0
            ElseIf UserList(.Target).Flags.Muerto Then
                .Target = 0
            End If
        ElseIf .TargetNPC <> 0 Then
            If Npclist(.TargetNPC).Bando = .Bando And .Bando <> eKip.enone Then
                .TargetNPC = 0
            End If
        End If
        If .Flags.Paralizado = 1 Or .Flags.Inmovilizado = 1 Then
            '[MODIFICADO] 4/2/10 Con esto hacemos que planten los bots :D (si no tan poteando a full cuando estas paralizados)
            If .Target <> 0 Then
                If IsEnfrente(NpcIndex, .Target, True) And Npclist(NpcIndex).Bot.ToHP = False And Npclist(NpcIndex).Bot.BotType <> 3 And Npclist(NpcIndex).Bot.BotType <> 4 Then
                    Call SistemaCombate.NpcAtacaUser(NpcIndex, .Target)
                    Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, FindDirection(.Pos, UserList(.Target).Pos))
                    If RandomNumber(1, 10) = 5 Then Call SendData(SendTarget.ToNPCArea, TempIndex, PrepareMessageChatOverHead("¡Dale veni! ¿No te animas?", Npclist(TempIndex).Char.CharIndex, vbWhite))
                ElseIf Npclist(NpcIndex).Bot.BotType = 4 Then
                    Call BotHechizo(NpcIndex, .Target, 2)
                Else
                    If RandomNumber(1, 2) = 1 Then Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, RandomNumber(1, 4))
                End If
            ElseIf .TargetNPC <> 0 Then
                If IsEnfrente(NpcIndex, .TargetNPC, False) <= 1 And Npclist(NpcIndex).Bot.ToHP = False And Npclist(NpcIndex).Bot.BotType <> 3 And Npclist(NpcIndex).Bot.BotType <> 4 Then
                    Call SistemaCombate.NpcAtacaNpc(NpcIndex, .TargetNPC)
                    Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, FindDirection(.Pos, Npclist(.TargetNPC).Pos))
                ElseIf Npclist(NpcIndex).Bot.BotType = 4 Then
                    Call BotHechizo(NpcIndex, .TargetNPC, 1)
                Else
                    If RandomNumber(1, 2) = 1 Then Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, RandomNumber(1, 4))
                End If
            End If
            '[MODIFICADO] 4/2/10
            Call BotHechizo(NpcIndex, 0, 0)
        Exit Sub
        End If
            Dim UI As Integer 'UserIndex target
            Dim NI As Integer 'NpcIndex target
            If Npclist(NpcIndex).Target = 0 And Npclist(NpcIndex).TargetNPC = 0 Or RandomNumber(1, 50) = 25 Then
                'Si no tiene ningun target hacemos esto
                'Debug.Print "Agarro sin target"
                For Y = .Pos.Y - RANGO_VISION_Y To .Pos.Y + RANGO_VISION_Y
                    For X = .Pos.X - RANGO_VISION_X To .Pos.X + RANGO_VISION_X
                        If X >= MinXBorder And X <= MaxXBorder And Y >= MinYBorder And Y <= MaxYBorder Then
                           If MapData(.Pos.map, X, Y).NpcIndex <> 0 And MapData(.Pos.map, X, Y).NpcIndex <> NpcIndex Then
                           TempIndex = MapData(.Pos.map, X, Y).NpcIndex
'                                If RandomNumber(1, 1) = 0 And Npclist(NpcIndex).Bot.AmigoNPC = 0 And Npclist(TempIndex).Bot.AmigoNPC = 0 Then
'                                    Npclist(NpcIndex).Bot.AmigoNPC = TempIndex
'                                    Npclist(TempIndex).Bot.AmigoNPC = NpcIndex
'                                    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead(Npclist(TempIndex).name & " hacemos team??", Npclist(NpcIndex).Char.CharIndex, vbWhite))
'                                    Call SendData(SendTarget.ToNPCArea, TempIndex, PrepareMessageChatOverHead("Dale!", Npclist(TempIndex).Char.CharIndex, vbWhite))
'                                End If
                                If Npclist(TempIndex).Bot.BotType <> 0 And Npclist(NpcIndex).Bot.AmigoNPC <> TempIndex And Npclist(TempIndex).Pos.map = .Pos.map And (Npclist(TempIndex).Bando <> Npclist(NpcIndex).Bando Or Npclist(NpcIndex).Bando = eKip.enone) Then ' And RandomNumber(1, 5) Then 'Condiciones del enemigo para estar en nuestra lista
                                     NPC_Cantidad = NPC_Cantidad + 1
                                     ReDim Preserve NPC_TARGET(1 To NPC_Cantidad)
                                     NPC_TARGET(NPC_Cantidad) = MapData(.Pos.map, X, Y).NpcIndex
                                End If
                           
                           ElseIf MapData(.Pos.map, X, Y).UserIndex <> 0 Then
                           TempIndex = MapData(.Pos.map, X, Y).UserIndex
                                If UserList(TempIndex).Flags.Muerto = 0 And UserList(TempIndex).Flags.AdminPerseguible And Npclist(NpcIndex).Bot.AmigoUSER <> TempIndex And UserList(TempIndex).Pos.map = .Pos.map And (UserList(TempIndex).Bando <> Npclist(NpcIndex).Bando Or UserList(TempIndex).Bando = eKip.enone) Then 'And RandomNumber(1, 5) Then 'Condiciones del enemigo para estar en nuestra lista
                                    USER_Cantidad = USER_Cantidad + 1
                                    ReDim Preserve USER_TARGET(1 To USER_Cantidad)
                                    USER_TARGET(USER_Cantidad) = MapData(.Pos.map, X, Y).UserIndex
                                End If
                           End If
                           
                        End If
                    Next X
                Next Y
                'Debug.Print "Ya encontre los targets :D"
                If RandomNumber(1, 2) = 1 And USER_Cantidad <> 0 Then
                    UI = USER_TARGET(RandomNumber(1, USER_Cantidad)) 'Creamos nuevo target user al azar
                    Npclist(NpcIndex).Target = UI 'Seteamos el target USER
                ElseIf NPC_Cantidad <> 0 Then
                    NI = NPC_TARGET(RandomNumber(1, NPC_Cantidad)) 'Creamos nuevo target npc al azar
                    Npclist(NpcIndex).TargetNPC = NI 'Seteamos el target NPC
                End If
                .Bot.TargetsDisp = USER_Cantidad + NPC_Cantidad
                'Debug.Print "Errua2"
            ElseIf Npclist(NpcIndex).Target = 0 And Npclist(NpcIndex).TargetNPC <> 0 Then
                'Si ya tenemos un target que es NPC hacemos esto
                NI = Npclist(NpcIndex).TargetNPC
                .Bot.TargetsDisp = 1
                If puede_npc(NpcIndex, 1200) Then Call BotHechizo(NpcIndex, NI, 1)
                
            ElseIf Npclist(NpcIndex).Target <> 0 And Npclist(NpcIndex).TargetNPC = 0 Then
                'Si ya tenemos un target que es USER hacemos esto
                UI = Npclist(NpcIndex).Target
                .Bot.TargetsDisp = 1
                If puede_npc(NpcIndex, 1200) Then Call BotHechizo(NpcIndex, UI, 2)
            Else
                'Si tenemos un target de NPC y otro USER hacemos esto
                If RandomNumber(1, 2) = 1 Then
                    UI = Npclist(NpcIndex).Target 'Dejamos usuario como target
                    Npclist(NpcIndex).TargetNPC = 0 'Limpiamos NPC asi no pasa de nuevo
                Else
                    NI = Npclist(NpcIndex).TargetNPC 'Dejamos npc como target
                    Npclist(NpcIndex).Target = 0 'Limpiamos USER asi no pasa denuevo
                End If
                .Bot.TargetsDisp = 1
            End If
            If Npclist(NpcIndex).Bot.AmigoNPC <> 0 Then
                'Debug.Print Npclist(Npclist(NpcIndex).flags.AmigoNPC).name
                If (.Pos.X - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.X < -16 Or .Pos.X - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.X > 16) Or (.Pos.Y - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.Y < -12 Or .Pos.Y - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.Y > 12) Then 'Tan lejos que lo buscamos
                    .Bot.AmigoNPC = 0
                    GoTo Parte3
                        'Debug.Print "Lo perdi :("
                ElseIf (.Pos.X - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.X < -5 Or .Pos.X - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.X > 5) Or (.Pos.Y - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.Y < -4 Or .Pos.Y - Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos.Y > 4) Then 'Lo perdemos de la pantalla y lo buscamos
                    tHeading = FindDirection(.Pos, Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Pos)
                    Call MoveNPCChar(NpcIndex, tHeading)
                    'Debug.Print "¡No te vayas yonih!"
                    'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                    GoTo Parte3
                End If
            End If
            '[MODIFICADO] 4/2/10 Los bots siguen a sus amigos :D
            If .Target = 0 And .TargetNPC = 0 Then
                If .Bot.AmigoUSER <> 0 Then
                    If Distancia(.Pos, UserList(.Bot.AmigoUSER).Pos) > 2 Then
                        Call MoveNPCChar(NpcIndex, FindDirection(.Pos, UserList(.Bot.AmigoUSER).Pos))
                    End If
                    If Distancia(.Pos, UserList(.Bot.AmigoUSER).Pos) > 8 Then
                        .Bot.AmigoUSER = 0 'Te fuiste :(
                    End If
                    'Call GreedyWalkTo(NpcIndex, UserList(.Bot.AmigoUSER).Pos.map, UserList(.Bot.AmigoUSER).Pos.x, UserList(.Bot.AmigoUSER).Pos.y)
                    Exit Sub
'                ElseIf .Bot.AmigoNPC <> 0 Then Que solo sigan a los users -.-
'                    Call MoveNPCChar(NpcIndex, FindDirection(.Pos, Npclist(.Bot.AmigoNPC).Pos))
'                    'Call GreedyWalkTo(NpcIndex, Npclist(.Bot.AmigoNPC).Pos.map, Npclist(.Bot.AmigoNPC).Pos.x, Npclist(.Bot.AmigoNPC).Pos.y)
'                    Exit Sub
                End If
            End If
            '[MODIFICADO] 4/2/10
            If (.Bot.TargetsDisp = 0 Or Not MapInfo(.Pos.map).Pk) And (Npclist(NpcIndex).Flags.Paralizado = 0 And Npclist(NpcIndex).Flags.Inmovilizado = 0) Then
                If BuscarZona(NpcIndex) = 1 Then
                    'If Distancia2(BuscarZonaX(NpcIndex), BuscarZonaY(NpcIndex), .Pos.x, .Pos.y) Then Call BuscarZona(NpcIndex)
                    Pose.map = .Pos.map
                    Pose.X = BuscarZonaX(NpcIndex)
                    Pose.Y = BuscarZonaY(NpcIndex)
                    tHeading = FindDirection(.Pos, Pose)
                    Call MoveNPCChar(NpcIndex, tHeading)
                    'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                    'Pose.map = 0
                    'Pose.X = 0
                    'Pose.Y = 0
                    'Call GreedyWalkTo(NpcIndex, .Pos.map, BuscarZonaX(NpcIndex), BuscarZonaY(NpcIndex))
                End If
                Exit Sub
'                If ReCalculatePath(NpcIndex) Then
'                    'Debug.Print "Recalculate SI " & BuscarZonaX(NpcIndex)
'                    'Call PathFindingAI(NpcIndex)
'                    .Target = 0
'                    .TargetNPC = 0
'                    Dim a As Integer
'                    a = BuscarZona(NpcIndex)
'                    'Debug.Print A
'                    If a = 0 Then Exit Sub
'                    .PFINFO.Target.Y = BuscarZonaX(NpcIndex) 'ZonaBot(BuscarZona(NpcIndex)).Y(RandomNumber(1, ZonaBot(BuscarZona(NpcIndex)).Zonas))
'                    .PFINFO.Target.X = BuscarZonaY(NpcIndex) '(BuscarZona(NpcIndex)).X(RandomNumber(1, ZonaBot(BuscarZona(NpcIndex)).Zonas))
'                    'Debug.Print "Cuack " & .Pos.Map & "-" & .PFINFO.Target.X & "-" & .PFINFO.Target.Y
'                    'Call SeekPath(NpcIndex)
'                    'Existe el camino?
'                    If .PFINFO.NoPath Then 'Si no existe nos movemos al azar
'                        'Debug.Print "¿DONDE VOY?"
'                        'Move randomly
'                        'Call MoveNPCChar(NpcIndex, RandomNumber(eHeading.NORTH, eHeading.WEST))
'                    End If
'                Else
'                    'Debug.Print .Pos.Map & "-" & .PFINFO.Target.X & "-" & .PFINFO.Target.Y
'                    If Not PathEnd(NpcIndex) Then
'                        If Distancia2(.PFINFO.Target.X, .PFINFO.Target.Y, .Pos.Y, .Pos.X) <= 2 And MapData(.Pos.map, .PFINFO.Target.Y, .PFINFO.Target.X).TileExit.map > 0 Then
'                            MapData(.Pos.map, .Pos.X, .Pos.Y).NpcIndex = 0
'                            'Call QuitarNPC(NpcIndex)
'                            'Call EraseNPCChar(NpcIndex)
'                            'Actualizamos los clientes
'                            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterRemove(Npclist(NpcIndex).Char.CharIndex))
'                            .Pos.X = MapData(.Pos.map, .PFINFO.Target.Y, .PFINFO.Target.X).TileExit.X
'                            .Pos.Y = MapData(.Pos.map, .PFINFO.Target.Y, .PFINFO.Target.X).TileExit.Y
'                            .Pos.map = MapData(.Pos.map, .PFINFO.Target.Y, .PFINFO.Target.X).TileExit.map
'                            MapData(.Pos.map, .Pos.X, .Pos.Y).NpcIndex = NpcIndex
'                            Call MakeNPCChar(True, 0, NpcIndex, .Pos.map, .Pos.X, .Pos.Y)
'                            'Call CheckUpdateNeededNpc(NpcIndex, USER_NUEVO)
'                            'Actualizamos los clientes
'                            'MapData(.Pos.Map, .Pos.X, .Pos.Y).NpcIndex = NpcIndex
'                            'Call CheckUpdateNeededNpc(NpcIndex, USER_NUEVO)
'                            'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterCreate(.Char.body, .Char.Head, .Char.heading, .Char.CharIndex, .Pos.X, .Pos.Y, .Char.WeaponAnim, .Char.ShieldAnim, 0, 0, .Char.CascoAnim, .name, 0, 0))
'                            'MapData(.Pos.Map, .Pos.X, .Pos.Y).NpcIndex = NpcIndex
'                            'Call SpawnNpc(Npclist(NpcIndex).Numero, Pose, False, False)
'                            'Npclist(NpcIndex).Pos = MapData(.Pos.Map, .PFINFO.Target.Y, .PFINFO.Target.X).TileExit
'
'                        Else
'                            Call FollowPath(NpcIndex)
'                        End If
'                    Else
'                        .PFINFO.PathLenght = 0
'                    End If
'                End If
'                    'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, 0, .OldPos))
'                Exit Sub
                End If
            'Debug.Print "Errua"
                If NI > 0 And MapInfo(.Pos.map).Pk Then
                       ' Debug.Print "ToNpc"
                        tHeading = FindDirection(.Pos, Npclist(NI).Pos)
                        Npclist(NpcIndex).Char.Heading = tHeading
                        tipo = 1
                        'Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.body, Npclist(NpcIndex).Char.Head, tHeading)
                        If Npclist(NpcIndex).Bot.AmigoNPC <> 0 Then
                            If Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Flags.Paralizado = 1 Or Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Flags.Inmovilizado = 1 Then
                                Call BotHechizo(NpcIndex, Npclist(NpcIndex).Bot.AmigoNPC, 1)
                                GoTo Parte1
                            End If
                        End If
                        If Npclist(NpcIndex).Bot.AmigoUSER <> 0 Then
                            'Debug.Print "You are my friend"
                            If UserList(Npclist(NpcIndex).Bot.AmigoUSER).Flags.Paralizado = 1 Or UserList(Npclist(NpcIndex).Bot.AmigoUSER).Flags.Inmovilizado = 1 Then
                                Call BotHechizo(NpcIndex, Npclist(NpcIndex).Bot.AmigoUSER, 2)
                                'Debug.Print "You are my friend"
                                GoTo Parte1
                            End If
                        End If

                        If IsEnfrente(NpcIndex, NI, False) And Npclist(NpcIndex).Bot.BotType = 2 And Npclist(NpcIndex).Bot.ToHP = False Then
                            If RandomNumber(1, 3) = 1 Or Npclist(NI).Flags.Inmovilizado = 1 Or Npclist(NI).Flags.Paralizado = 1 Then
                                Call SistemaCombate.NpcAtacaNpc(NpcIndex, NI)
                                Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, tHeading)
                            End If
                        ElseIf IsEnfrente(NpcIndex, NI, False) And Not BotPuedeAtacar(NpcIndex, NI, False) Then
                                If RandomNumber(1, 2) = 1 Or Npclist(NpcIndex).Bot.BotType = 3 Then
                                    Call BotHechizo(NpcIndex, NI, 1)
                                Else
                                    Call SistemaCombate.NpcAtacaNpc(NpcIndex, NI)
                                    Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, tHeading)
                                End If
                        ElseIf BotPuedeAtacar(NpcIndex, NI, False) Then
                                Call BotHechizo(NpcIndex, NI, 1)
                        End If
Parte1:
                ElseIf UI > 0 And MapInfo(.Pos.map).Pk Then
                        'Debug.Print "ToUser"
                        tHeading = FindDirection(.Pos, UserList(UI).Pos)
                        'Debug.Print "ToUser2"
                        tipo = 2
                        Npclist(NpcIndex).Char.Heading = tHeading

                        If Npclist(NpcIndex).Bot.AmigoNPC <> 0 Then
                            If Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Flags.Paralizado = 1 Or Npclist(Npclist(NpcIndex).Bot.AmigoNPC).Flags.Inmovilizado = 1 Then
                                Call BotHechizo(NpcIndex, Npclist(NpcIndex).Bot.AmigoNPC, 1)
                                GoTo Parte2
                            End If
                        End If
                        If Npclist(NpcIndex).Bot.AmigoUSER <> 0 Then
                            'Debug.Print "You are my friend"
                            If UserList(Npclist(NpcIndex).Bot.AmigoUSER).Flags.Paralizado = 1 Or UserList(Npclist(NpcIndex).Bot.AmigoUSER).Flags.Inmovilizado = 1 Then
                                Call BotHechizo(NpcIndex, Npclist(NpcIndex).Bot.AmigoUSER, 2)
                                'Debug.Print "You are my friend"
                                GoTo Parte2
                            End If
                        End If
                        'AmigoToRemo = AmigoRemo(NpcIndex)
                        'Debug.Print "AmigoRemo = " & AmigoToRemo
                        'If AmigoToRemo > 0 Then
                        '    Call BotHechizo(NpcIndex, AmigoToRemo, 1)
                        '    GoTo Parte2
                        'Else
                        '    Call BotHechizo(NpcIndex, -AmigoToRemo, 2)
                        '    GoTo Parte2
                        'End If
                        If IsEnfrente(NpcIndex, UI, True) And Npclist(NpcIndex).Bot.BotType = 2 And Npclist(NpcIndex).Bot.ToHP = False Then
                            If RandomNumber(1, 3) = 1 Or UserList(UI).Flags.Inmovilizado = 1 Or UserList(UI).Flags.Paralizado = 1 Then
                                Call SistemaCombate.NpcAtacaUser(NpcIndex, UI)
                                Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, tHeading)
                            End If
                        ElseIf IsEnfrente(NpcIndex, UI, True) And Not BotPuedeAtacar(NpcIndex, UI, True) Then
                                If (RandomNumber(1, 2) = 1 Or Npclist(NpcIndex).Bot.BotType = 3) Then
                                    Call BotHechizo(NpcIndex, UI, 2)
                                Else
                                    Call SistemaCombate.NpcAtacaUser(NpcIndex, UI)
                                    Call ChangeNPCChar(NpcIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, tHeading)
                                End If
                        ElseIf BotPuedeAtacar(NpcIndex, UI, True) Then
                                Call BotHechizo(NpcIndex, UI, 2)
                        End If
                End If
Parte2:
                                'Debug.Print Npclist(NpcIndex).OldPos.X & "-" & Npclist(NpcIndex).Pos.X
                                If Npclist(NpcIndex).Flags.Paralizado = 0 And Npclist(NpcIndex).Flags.Inmovilizado = 0 Then
                                    If tipo = 1 Then
                                        If Npclist(NI).Attackable = 0 Or Npclist(NI).Pos.map <> .Pos.map Then
                                            .TargetNPC = 0
                                            Call PeleaNPCBotMix(NpcIndex)
                                        Exit Sub
                                        End If
                                        If (.Pos.X - Npclist(NI).Pos.X < -16 Or .Pos.X - Npclist(NI).Pos.X > 16) Or (.Pos.Y - Npclist(NI).Pos.Y < -12 Or .Pos.Y - Npclist(NI).Pos.Y > 12) Then 'Tan lejos que lo buscamos
                                            .TargetNPC = 0
                                            'Debug.Print "Lo perdi :("
                                        ElseIf (.Pos.X - Npclist(NI).Pos.X < -7 Or .Pos.X - Npclist(NI).Pos.X > 7) Or (.Pos.Y - Npclist(NI).Pos.Y < -5 Or .Pos.Y - Npclist(NI).Pos.Y > 5) Then 'Lo perdemos de la pantalla y lo buscamos
                                            Call MoveNPCChar(NpcIndex, tHeading)
                                            'Debug.Print "¡No te vayas yonih!"
                                            'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                                        ElseIf Not BotPuedeAtacar(NpcIndex, NI, False) And Npclist(NpcIndex).Bot.BotType <> 3 And Npclist(NpcIndex).Bot.BotType <> 4 Then
                                            If IsEnfrente(NpcIndex, NI, False) And (Npclist(NI).Flags.Paralizado = 1 Or Npclist(NI).Flags.Inmovilizado = 1) Then
                                                If Npclist(NpcIndex).ultimox = (GetTickCount() And &H7FFFFFFF) Then
                                                    Call MoveNPCChar(NpcIndex, tHeading)
                                                End If
                                                'Call MoveNPCChar(NpcIndex, tHeading)
                                            ElseIf Npclist(NI).Flags.Paralizado = 1 Or Npclist(NI).Flags.Inmovilizado = 1 Then
                                                'Call GreedyWalkTo(NpcIndex, Npclist(NI).Pos.map, Npclist(NI).Pos.x, Npclist(NI).Pos.y)
                                                Call MoveNPCChar(NpcIndex, tHeading)
                                            ElseIf Npclist(NpcIndex).Bot.BotType = 2 Then
                                                'Call GreedyWalkTo(NpcIndex, Npclist(NI).Pos.map, Npclist(NI).Pos.x, Npclist(NI).Pos.y)
                                                Call MoveNPCChar(NpcIndex, tHeading)
                                            End If
                                        Else
                                            If Npclist(NpcIndex).Bot.BotType = 2 And Not Npclist(NpcIndex).Bot.ToHP Then
                                                If RandomNumber(1, 3) = 2 Then
                                                    Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                                                Else
                                                    Call MoveNPCChar(NpcIndex, FindDirection(.Pos, Npclist(NI).Pos))
                                                End If
                                            Else
                                                Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, 0, .OldPos))
                                            End If
                                        End If
Parte3:
                                    ElseIf tipo = 2 Then
                                        If UserList(UI).Flags.Muerto = 1 Or Not UserList(UI).Flags.AdminPerseguible Or UserList(UI).Pos.map <> .Pos.map Then 'Condiciones del enemigo para estar en nuestra lista
                                            .Target = 0
                                            Call PeleaNPCBotMix(NpcIndex) 'Como lo perdimos lo volvemos a buscar
                                            Exit Sub
                                        End If
                                        If (.Pos.X - UserList(UI).Pos.X < -16 Or .Pos.X - UserList(UI).Pos.X > 16) Or (.Pos.Y - UserList(UI).Pos.Y < -12 Or .Pos.Y - UserList(UI).Pos.Y > 12) Then 'Tan lejos que lo buscamos
                                            .Target = 0
                                            'Debug.Print "Lo perdi :("
                                        ElseIf (.Pos.X - UserList(UI).Pos.X < -7 Or .Pos.X - UserList(UI).Pos.X > 7) Or (.Pos.Y - UserList(UI).Pos.Y < -5 Or .Pos.Y - UserList(UI).Pos.Y > 5) Then 'Lo perdemos de la pantalla y lo buscamos
                                            Call MoveNPCChar(NpcIndex, tHeading)
                                            'Debug.Print "¡No te vayas yonih!"
                                            'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                                        ElseIf Not BotPuedeAtacar(NpcIndex, UI, True) And Npclist(NpcIndex).Bot.BotType <> 3 And Npclist(NpcIndex).Bot.BotType <> 4 Then
                                            If IsEnfrente(NpcIndex, UI, True) And (UserList(UI).Flags.Paralizado = 1 Or UserList(UI).Flags.Inmovilizado = 1) Then
                                                'Call MoveNPCChar(NpcIndex, tHeading)
                                                If Npclist(NpcIndex).ultimox = (GetTickCount() And &H7FFFFFFF) Then
                                                    Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                                                End If
                                                'Call GreedyWalkTo(NpcIndex, UserList(UI).Pos.Map, UserList(UI).Pos.X, UserList(UI).Pos.Y)
                                            ElseIf UserList(UI).Flags.Paralizado = 1 Or UserList(UI).Flags.Inmovilizado = 1 Then
                                                'Debug.Print "Buscamos"
                                                'Call GreedyWalkTo(NpcIndex, UserList(UI).Pos.map, UserList(UI).Pos.x, UserList(UI).Pos.y)
                                                Call MoveNPCChar(NpcIndex, tHeading)
                                            ElseIf Npclist(NpcIndex).Bot.BotType = 2 Then
                                                Call MoveNPCChar(NpcIndex, tHeading)
                                                'Call GreedyWalkTo(NpcIndex, UserList(UI).Pos.map, UserList(UI).Pos.x, UserList(UI).Pos.y)
                                            End If
                                        Else
                                            If Npclist(NpcIndex).Bot.BotType = 2 And Not Npclist(NpcIndex).Bot.ToHP Then
                                                If RandomNumber(1, 3) = 2 Then
                                                    Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, tHeading, .OldPos))
                                                Else
                                                    Call MoveNPCChar(NpcIndex, FindDirection(.Pos, UserList(UI).Pos))
                                                End If
                                            Else
                                                Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, 0, .OldPos))
                                            End If
                                        End If
                                    End If
                                End If
                                If .Target = 0 And .TargetNPC = 0 Then
                                    'Call MoveNPCChar(NpcIndex, FindGoodPos(.Pos, 0, .OldPos))
                                    '.flags.
                                    If .Stats.MinHP <> .Stats.MaxHP Then
                                        .Bot.ToHP = True
                                    ElseIf .Bot.MinMan <> .Bot.MaxMan Then
                                        .Bot.ToMan = True
                                    End If
                                    'Debug.Print "No encontre a nadie :("
                                End If
    End With
Exit Sub
ErrHandler:
Debug.Print "Error en la linea R" & Npclist(NpcIndex).name & ": " & Erl()
End Sub
Function Distancia2(ByRef wp1X As Integer, ByRef wp1Y As Integer, ByRef wp2X As Integer, ByRef wp2Y As Integer) As Long
    'Encuentra la distancia entre dos WorldPos
    Distancia2 = Abs(wp1X - wp2X) + Abs(wp1Y - wp2Y)
End Function
Function FindGoodPos(Pos As WorldPos, GoHeading As Byte, OldPos As WorldPos) As eHeading
'*****************************************************************
'Devuelve la direccion en la cual el target se encuentra
'desde pos, 0 si la direc es igual
'*****************************************************************

Dim X As Integer
Dim Y As Integer
Dim MoveTo As Byte
X = Pos.X
Y = Pos.Y
MoveTo = 0

If GoHeading = 0 Then MoveTo = RandomNumber(1, 4)
If MoveTo = 1 Or GoHeading = 3 Then 'South
    If LegalPos(Pos.map, Pos.X, Pos.Y + 1) And IgualPos(Pos.X, Pos.Y + 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = SOUTH
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y - 1) And IgualPos(Pos.X, Pos.Y - 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = NORTH
    ElseIf LegalPos(Pos.map, Pos.X - 1, Pos.Y) And IgualPos(Pos.X - 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = WEST
    ElseIf LegalPos(Pos.map, Pos.X + 1, Pos.Y) And IgualPos(Pos.X + 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = EAST
    End If
ElseIf MoveTo = 2 Or GoHeading = 1 Then 'North
    If LegalPos(Pos.map, Pos.X, Pos.Y - 1) And IgualPos(Pos.X, Pos.Y - 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = NORTH
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y + 1) And IgualPos(Pos.X, Pos.Y + 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = SOUTH
    ElseIf LegalPos(Pos.map, Pos.X - 1, Pos.Y) And IgualPos(Pos.X - 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = WEST
    ElseIf LegalPos(Pos.map, Pos.X + 1, Pos.Y) And IgualPos(Pos.X + 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = EAST
    End If
ElseIf MoveTo = 3 Or GoHeading = 4 Then 'West
    If LegalPos(Pos.map, Pos.X - 1, Pos.Y) And IgualPos(Pos.X - 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = WEST
    ElseIf LegalPos(Pos.map, Pos.X + 1, Pos.Y) And IgualPos(Pos.X + 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = EAST
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y - 1) And IgualPos(Pos.X, Pos.Y - 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = NORTH
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y + 1) And IgualPos(Pos.X, Pos.Y + 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = SOUTH
    End If
ElseIf MoveTo = 4 Or GoHeading = 2 Then 'East
    If LegalPos(Pos.map, Pos.X + 1, Pos.Y) And IgualPos(Pos.X + 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = EAST
    ElseIf LegalPos(Pos.map, Pos.X - 1, Pos.Y) And IgualPos(Pos.X - 1, Pos.Y, OldPos.X, OldPos.Y) Then
        FindGoodPos = WEST
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y - 1) And IgualPos(Pos.X, Pos.Y - 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = NORTH
    ElseIf LegalPos(Pos.map, Pos.X, Pos.Y + 1) And IgualPos(Pos.X, Pos.Y + 1, OldPos.X, OldPos.Y) Then
        FindGoodPos = SOUTH
    End If
End If
End Function
Function IgualPos(posX As Integer, posY As Integer, OldPosX As Integer, OldPosY As Integer) As Boolean
    If posX = OldPosX And posY = OldPosY Then
        IgualPos = False
    Else
        IgualPos = True
    End If
End Function
Public Sub AmigoRemo(tIndex As Integer, User As Byte)
'If Not RemoHabilitado Then Exit Sub
On Error GoTo ErrHandler
If deathm Then Exit Sub
1 Dim i As Byte
2 Dim TempIndex As Integer
    'Debug.Print "¡BUSCAMOS AMIGO REMO!"
3 For i = 1 To Cantidad_Bots
4    TempIndex = BotList(i)
5    If User = 2 Then 'Si es usuario
6        If UserList(tIndex).Pos.X - Npclist(TempIndex).Pos.X > -6 And UserList(tIndex).Pos.X - Npclist(TempIndex).Pos.X < 6 And UserList(tIndex).Pos.Y - Npclist(TempIndex).Pos.Y > -8 And UserList(tIndex).Pos.Y - Npclist(TempIndex).Pos.Y < 8 And UserList(tIndex).Bando = Npclist(TempIndex).Bando Then
7            Npclist(TempIndex).Bot.AmigoUSER = tIndex
8            'Call SendData(SendTarget.ToNPCArea, TempIndex, PrepareMessageChatOverHead("Yo te remuevo " & UserList(tIndex).name & " ;)", Npclist(TempIndex).Char.CharIndex, vbWhite))
            Exit For
9        End If
10    ElseIf User = 1 Then 'Si es NPC
11        If Npclist(tIndex).Pos.X - Npclist(TempIndex).Pos.X > -6 And Npclist(tIndex).Pos.X - Npclist(TempIndex).Pos.X < 6 And Npclist(tIndex).Pos.Y - Npclist(TempIndex).Pos.Y > -8 And Npclist(tIndex).Pos.Y - Npclist(TempIndex).Pos.Y < 8 And Npclist(tIndex).Bando = Npclist(TempIndex).Bando And TempIndex <> tIndex Then
            'Debug.Print "¡ENCONTRE UN AMIGO NPC!"
12            Npclist(TempIndex).Bot.AmigoNPC = tIndex
16              'Call SendData(SendTarget.ToNPCArea, TempIndex, PrepareMessageChatOverHead("Yo te remuevo " & Npclist(tIndex).name & " ;)", Npclist(TempIndex).Char.CharIndex, vbWhite))
                Exit For
13        End If
14    End If
15 Next i
Exit Sub
ErrHandler:
Debug.Print "Error en la linea R: " & Erl()
End Sub
'[MODIFICADO] 4/2/10 Dificultad de los bots :D Enrealidad es el AIM que tienen -.-
Public Function CalcularDificultad() As Integer
If frmMain.mankoo.ListIndex = 0 Then
    CalcularDificultad = 100 'El aim es PERFECTO 100%
ElseIf frmMain.mankoo.ListIndex = 1 Then
    CalcularDificultad = 50 'El aim es PERFECTO para algunos hechizos
ElseIf frmMain.mankoo.ListIndex = 2 Then
    CalcularDificultad = 25 'El aim es muy bueno masomenos llega la 70%/90%
ElseIf frmMain.mankoo.ListIndex = 3 Then
    CalcularDificultad = 10 'Aim bastante bueno.
ElseIf frmMain.mankoo.ListIndex = 4 Then
    CalcularDificultad = 0 'Y ahi estamos bien, ni mas dificil ni mas facil "NORMAL"
ElseIf frmMain.mankoo.ListIndex = 5 Then
    CalcularDificultad = -10 'Ak tamos ya bajandole el AIM
ElseIf frmMain.mankoo.ListIndex = 6 Then
    CalcularDificultad = -25 'Ya somos bastante pedorros
ElseIf frmMain.mankoo.ListIndex = 7 Then
    CalcularDificultad = -50 '¡Alfin llegamos! "Agite estilo Menduz" xD!!!
End If
End Function
'[MODIFICADO] 4/2/10
Sub BalanceBots()
    'If botsact = False Then Exit Sub':( --> replaced by:
    If botsact = False Then
        Exit Sub
    End If

    On Error GoTo errorh
    Dim wp As WorldPos

    wp.map = servermap
    wp.X = 50
    wp.Y = 50

    Dim CUIDAS As Integer
    Dim PKS As Integer
    CUIDAS = UserBando(eCui) + NumBandoBots(eKip.eCui)
    PKS = UserBando(ePK) + NumBandoBots(eKip.ePK)
    Dim total As Integer
    total = CUIDAS - PKS
    Dim i As Integer
    If total > 0 Then
        For i = 1 To total
            Call CrearNPC(RandomNumber(0, 7) + 40, servermap, wp, eKip.ePK)
        Next i
    End If

    If PKS > CUIDAS Then
        total = 0
        total = Abs(PKS - CUIDAS)
        For i = 1 To total
            Call CrearNPC(RandomNumber(0, 7) + 40, servermap, wp, eKip.eCui)
        Next i
    End If

Exit Sub

errorh:
    LogError ("Error en BalanceBots.")
    'do nothing

End Sub
Public Sub NextCombo(ByVal NpcIndex As Integer)
On Error GoTo ERR:
1    With Npclist(NpcIndex).Bot
2        If .Combeando = 0 Then Exit Sub
3        .NumComboActual = .NumComboActual + 1
4        Debug.Print "Ubound Combos: " & .NumComboActual & "-" & .Combos(.Combeando).CantCombos
5        If .NumComboActual > .Combos(.Combeando).CantCombos Then Call CancelCombo(NpcIndex): Exit Sub
6        .ComboActual = .Combos(.Combeando).Num(.NumComboActual)

'7        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Siguiente paso: " & .NumComboActual, Npclist(NpcIndex).Char.CharIndex, vbCyan))
    End With
Exit Sub
ERR:
Debug.Print "Error en NextCombo " & Erl() '& Npclist(NpcIndex).Bot.Combos(Npclist(NpcIndex).Bot.NumComboActual).CantCombos & "-" & UBound(Npclist(NpcIndex).Bot.Combos)
'Call CancelCombo(NpcIndex)
End Sub
Public Sub CancelCombo(ByVal NpcIndex As Integer)
On Error GoTo ERR:
    With Npclist(NpcIndex).Bot
        .NumComboActual = 0
        .Combeando = 0
        .ComboActual = 0
        'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("Termine el combo!", Npclist(NpcIndex).Char.CharIndex, vbCyan))
    End With
Exit Sub
ERR:
Debug.Print "Error en CancelCombo " '& Npclist(NpcIndex).Bot.Combos(Npclist(NpcIndex).Bot.NumComboActual).CantCombos & "-" & UBound(Npclist(NpcIndex).Bot.Combos)
End Sub
Private Function IsEnfrente(ByVal NpcIndex As Integer, ByVal ToIndex As Integer, ByVal User As Boolean)
Dim AttackPos As WorldPos
AttackPos = Npclist(NpcIndex).Pos
Call HeadtoPos(Npclist(NpcIndex).Char.Heading, AttackPos)
If User Then
    If MapData(AttackPos.map, AttackPos.X, AttackPos.Y).UserIndex = ToIndex Then
        IsEnfrente = True
    End If
Else
    If MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex = ToIndex Then
        IsEnfrente = True
    End If
End If
End Function
