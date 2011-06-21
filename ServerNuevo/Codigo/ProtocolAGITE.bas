Attribute VB_Name = "Protocol"
Option Explicit

''
'When we have a list of strings, we use this to separate them and prevent
'having too many string lengths in the queue. Yes, each string is NULL-terminated :P
Private Const SEPARATOR As String * 1 = vbNullChar

''
'The last existing client packet id.
Private Const LAST_CLIENT_PACKET_ID As Byte = 49

''
'Auxiliar ByteQueue used as buffer to generate messages not intended to be sent right away.
'Specially usefull to create a message once and send it over to several clients.
Private auxiliarBuffer As New clsByteQueue


Public erla As Long

Public Enum ServerPacketID
    logged                  'va
    RemoveDialogs           'va
    RemoveCharDialog        'va
    NavigateToggle          'va
    Disconnect              'va
    ShowBlacksmithForm      'va PASARME DE EKIPO
    NPCSwing                'va
    NPCKillUser             'va
    BlockedWithShieldUser   'va
    BlockedWithShieldOther  'va
    UserSwing               'va
    CantUseWhileMeditating  'va
    UpdateSta               'va
    UpdateMana              'va
    UpdateHP                'va
    UpdateGold              'va
    UpdateExp               'va
    ChangeMap               'va
    PosUpdate               'va
    NPCHitUser              'va
    UserHitNPC              'va
    UserAttackedSwing       'va
    UserHittedByUser        'va
    UserHittedUser          'va
    ChatOverHead            'va
    ConsoleMsg              'va
    GuildChat               'va
    ShowMessageBox          'va
    UserIndexInServer       'va
    UserCharIndexInServer   'va
    CharacterCreate         'va
    CharacterRemove         'va
    CharacterMove           'va
    CharacterChange         'va
    ObjectCreate            'va
    ObjectDelete            'va
    BlockPosition           'va
    PlayMIDI                'va
    PlayWave                'va
    AreaChanged             'va
    PauseToggle             'va
    RainToggle              'va
    CreateFX                'va
    UpdateUserStats         'va
    WorkRequestTarget       'va
    ChangeInventorySlot     'va
    ChangeSpellSlot         'va
    CarpenterObjects        'va
    ErrorMsg                'va
    Blind                   'va
    Dumb                    'va
    MiniStats               'va TIMERS
    LevelUp                 'va MOVER CASPER
    ShowForumForm           'va INDICADOR PASS
    SetInvisible            'va
    MeditateToggle          'va
    BlindNoMore             'va
    DumbNoMore              'va
    OfferDetails            'va HIT
    ParalizeOK              'va
    SendNight               'va
    Pong                    'va
    UpdateTagAndStatus      'va
    UserNameList            'va
    Mensaje_Web
    Cmd_Web
    Crear_proyectil
    Anim_Attack
    change_char_prop
    Martillaso
    CreatePGP
    CCM 'crcinit
    CCO 'crcOKcanLogin
    TargetInvalido
    InvEQUIPED
End Enum

Public Enum ClientPacketID
    LoginExistingChar       'LOGIN
    Talk                    'Talk
    Yell                    'Gritar
    Whisper                 'Susurrar
    Walk                    'Caminar
    RequestPositionUpdate   'L
    Attack                  'Ctrl
    PickUp                  'A
    Drop                    'T
    CastSpell               'Lanzar
    LeftClick               'LClick
    DoubleClick             'CEEEEEEEEEO
    Work                    'WORK
    UseItem                 'U or DBL CLICK
    WorkLeftClick           'Flechas
    SpellInfo               'Info
    EquipItem               'E
    ChangeHeading           'Flechas
    BankDeposit             'Mover Item
    MoveSpell               'Mover Hechizo
    Online                  '/online
    Quit                    'F4
    Meditate                'F7
    BankStart               'SOY CHEATERRRRRRRRRRRRRRRRR
    ChangeDescription       '/admin
    ChangePassword          '/CONTRASEÑA
    ping                    'PING
    WarpMeToTarget          'va
    WarpChar                'warp
    GoToChar                '/ira
    invisible               '*
    RequestUserList         'Espacio || tab
    EditChar                'Elegir PJ
    RequestCharSkills       'va /desact
    ReviveChar              'va /act
    kick                    '/echar
    BanChar                 '/ban
    SummonChar              '/sum
    TeleportCreate          '/CT
    TeleportDestroy         '/DT
    RainToggle              '/LLUVIA
    ForceWAVEToMap          '/WAV
    BanIP                   '/ban
    CreateItem              '/CI
    DestroyItems            '/DEST
    night                   '/restart
    CambiarMapar
    Update_Ping
    LanzarH
    Martillo
    SelectAccPJ
    
    reload_balance
End Enum

Public Enum FontTypeNames
    FONTTYPE_TALK
    FONTTYPE_FIGHT
    FONTTYPE_WARNING
    FONTTYPE_INFO
    FONTTYPE_INFOBOLD
    FONTTYPE_EJECUCION
    FONTTYPE_PARTY
    FONTTYPE_VENENO
    FONTTYPE_GUILD
    FONTTYPE_SERVER
    FONTTYPE_GUILDMSG
    FONTTYPE_CONSEJO
    FONTTYPE_CONSEJOCAOS
    FONTTYPE_CONSEJOVesA
    FONTTYPE_CONSEJOCAOSVesA
    FONTTYPE_CENTINELA
    FONTTYPE_GMMSG
    FONTTYPE_GM
    FONTTYPE_CITIZEN
End Enum

Public Enum eEditOptions
    eo_Gold = 1
    eo_Experience
    eo_Body
    eo_Head
    eo_CiticensKilled
    eo_CriminalsKilled
    eo_Level
    eo_Class
    eo_Skills
    eo_SkillPointsLeft
    eo_Nobleza
    eo_Asesino
    eo_Sex
    eo_Raza
End Enum

''
'Handles incoming data.
'


Public Sub HandleIncomingData(ByVal UserIndex As Integer)
'On Error Resume Next
    Dim packetID    As Byte
    Dim echar       As Byte
    
    #If SeguridadArduz Then
        packetID = ReadPacket(UserIndex, echar)
    #Else
        packetID = UserList(UserIndex).incomingData.PeekByte()
    #End If
    
    'Does the packet requires a logged user??
    If Not (packetID = ClientPacketID.LoginExistingChar) Then
        
        'Is the user actually logged?
        If Not UserList(UserIndex).Flags.UserLogged Then
            Call CloseSocket(UserIndex)
            Exit Sub
        
        'He is logged. Reset idle counter if id is valid.
        ElseIf packetID <= LAST_CLIENT_PACKET_ID Then
            UserList(UserIndex).Counters.IdleCount = 0
            
        End If
    ElseIf packetID <= LAST_CLIENT_PACKET_ID Then
        UserList(UserIndex).Counters.IdleCount = 0
    End If

    Select Case packetID
        Case ClientPacketID.LoginExistingChar
            Call HandleLoginExistingChar(UserIndex)
            UserList(UserIndex).antiloop = 0
            
        Case ClientPacketID.Talk
            Call HandleTalk(UserIndex)
        
        Case ClientPacketID.Yell
            Call HandleYell(UserIndex)
        
        Case ClientPacketID.Whisper
            Call HandleWhisper(UserIndex)
        
        Case ClientPacketID.Walk
            Call HandleWalk(UserIndex)
        
        Case ClientPacketID.RequestPositionUpdate
            Call HandleRequestPositionUpdate(UserIndex)
        
        Case ClientPacketID.Attack
            Call HandleAttack(UserIndex)
        
        Case ClientPacketID.PickUp
            Call HandlePickUp(UserIndex)
        
        Case ClientPacketID.Drop
            Call HandleDrop(UserIndex)
        
        Case ClientPacketID.CastSpell
            Call HandleCastSpell(UserIndex)
        
        Case ClientPacketID.LeftClick
            Call HandleLeftClick(UserIndex)
        
        Case ClientPacketID.DoubleClick
            Call HandleDoubleClick(UserIndex)
        
        Case ClientPacketID.Work
            Call HandleWork(UserIndex)
        
        Case ClientPacketID.UseItem
            Call HandleUseItem(UserIndex)
        
        Case ClientPacketID.WorkLeftClick
            Call HandleWorkLeftClick(UserIndex)
        
        Case ClientPacketID.SpellInfo
            Call HandleSpellInfo(UserIndex)
        
        Case ClientPacketID.EquipItem
            Call HandleEquipItem(UserIndex)
        
        Case ClientPacketID.ChangeHeading
            Call HandleChangeHeading(UserIndex)
        
        Case ClientPacketID.BankDeposit             'MOVER ITEM
            Call HandleMoveItem(UserIndex)
        
        Case ClientPacketID.MoveSpell
            Call HandleMoveSpell(UserIndex)
        
        Case ClientPacketID.Online
            Call HandleOnline(UserIndex)
        
        Case ClientPacketID.Quit
            Call HandleQuit(UserIndex)
        
        Case ClientPacketID.Meditate
            Call HandleMeditate(UserIndex)
        
        Case ClientPacketID.BankStart
            Call HandleCheatSH(UserIndex)
        
        Case ClientPacketID.ChangeDescription
            Call HandleChangeAdminStat(UserIndex)

        Case ClientPacketID.ChangePassword
            Call HandleChangePassword(UserIndex)
        
        Case ClientPacketID.ping
            Call HandlePing(UserIndex)
        
        Case ClientPacketID.WarpMeToTarget
            Call HandleWarpMeToTarget(UserIndex)
        
        Case ClientPacketID.WarpChar
            Call HandleWarpChar(UserIndex)
        
        Case ClientPacketID.GoToChar
            Call HandleGoToChar(UserIndex)
        
        Case ClientPacketID.invisible
            Call HandleInvisible(UserIndex)
        
        Case ClientPacketID.RequestUserList
            Call HandleRequestUserList(UserIndex)
        
        Case ClientPacketID.EditChar
            Call HandleEditChar(UserIndex)
        
        Case ClientPacketID.RequestCharSkills
            Call HandleDesactivarFeature(UserIndex)
        
        Case ClientPacketID.ReviveChar
            Call HandleActivarFeature(UserIndex)
            
        Case ClientPacketID.kick
            Call HandleKick(UserIndex)
            
        Case ClientPacketID.BanChar
            Call HandleBanChar(UserIndex)
            
        Case ClientPacketID.SummonChar
            Call HandleSummonChar(UserIndex)
            
        Case ClientPacketID.TeleportCreate
            Call HandleTeleportCreate(UserIndex)
            
        Case ClientPacketID.TeleportDestroy
            Call HandleTeleportDestroy(UserIndex)
            
        Case ClientPacketID.RainToggle
            Call HandleClima(UserIndex)
        
        Case ClientPacketID.BanIP
            Call HandleBanIP(UserIndex)
        
        Case ClientPacketID.CreateItem
            Call HandleCreateItem(UserIndex)
        
        Case ClientPacketID.DestroyItems
            Call HandleDestroyItems(UserIndex)
            
        Case ClientPacketID.night
            Call HandleRestartRound(UserIndex)
            
        Case ClientPacketID.CambiarMapar
            Call HandleCambiarMapa(UserIndex)
            
        Case ClientPacketID.Update_Ping
            Call HandleUpdatePing(UserIndex)
            
        Case ClientPacketID.LanzarH
            Call HandleLanzarH(UserIndex)
            
        Case ClientPacketID.Martillo
            Call HandleMartillo(UserIndex)
            
        Case ClientPacketID.SelectAccPJ
            Call HandleSelectAccPJ(UserIndex)
            
        Case ClientPacketID.reload_balance
            Call HandleReload_Balance(UserIndex)
            
        Case Else
            Call LogError("ERROR PAQUETE:" & packetID & " [" & Hex$(UserList(UserIndex).Ultimo1) & ":" & UserList(UserIndex).incomingData.get_hex_barray & "]")
            UserList(UserIndex).incomingData.Clear
            
            If echar = 1 Then echar = 0
    End Select
    
    #If SeguridadArduz Then
        If echar Then
            Call EcharPorPaquete(UserIndex)
            Exit Sub
        End If
    #End If
    
    If ERR.number = UserList(UserIndex).incomingData.NotEnoughDataErrCode Then
        Call LogError("ERROR PAQUETE:" & packetID & " [" & UserList(UserIndex).incomingData.PeekASCIIStringFixed(UserList(UserIndex).incomingData.Length) & "]")
        UserList(UserIndex).antiloop = UserList(UserIndex).antiloop + 1
        'If UserList(UserIndex).antiloop > 3 Then
            UserList(UserIndex).incomingData.Clear
            UserList(UserIndex).antiloop = 0
        '    Call LogError("NO enough data. Hechado.")
        'End If
    End If
    
    'Done with this packet, move on to next one or send everything if no more packets found
    If UserList(UserIndex).incomingData.Length > 0 And ERR.number = 0 Then
        ERR.Clear
        UserList(UserIndex).antiloop = 0
        If UserList(UserIndex).incomingData.Length > 0 Then Call HandleIncomingData(UserIndex)
    ElseIf (ERR.number <> 0 And Not ERR.number = UserList(UserIndex).incomingData.NotEnoughDataErrCode) Then
        'An error ocurred, log it and kick player.

        Call LogError("Error: " & ERR.number & " [" & ERR.Description & "] " & " Source: " & ERR.Source & _
                        vbTab & " HelpFile: " & ERR.HelpFile & vbTab & " HelpContext: " & ERR.HelpContext & _
                        vbTab & " LastDllError: " & ERR.LastDllError & vbTab & _
                        " - UserIndex: " & UserIndex & " - producido al manejar el paquete: " & STR$(packetID) & " Erl:" & Erl() & " - " & erla)
        Call CloseSocket(UserIndex)
    Else
        'Flush buffer - send everything that has been written
        'Debug.Print "SEARMOOOPOSTAA:"; packetID
        Call FlushBuffer(UserIndex)
    End If
End Sub

''
'LoginExistingChar" message.
'


Private Sub HandleLoginExistingChar(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 22 Then
        ERR.Raise UserList(UserIndex).incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(UserList(UserIndex).incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte

    Dim UserName As String
    Dim Password As String
    Dim Version As Long
    Dim privapa As String
    UserName = buffer.ReadASCIIString()
    Password = buffer.ReadASCIIString()
    Dim sigue As Boolean
    Dim macaddr As String
    sigue = True
    'Convert version number to string
    Version = buffer.ReadLong()
    
    privapa = buffer.ReadASCIIString()
    macaddr = buffer.ReadASCIIString()
    UserList(UserIndex).ClientID = buffer.ReadDouble()
    
        If Not AsciiValidos(UserName) Then
            Call WriteErrorMsg(UserIndex, "Nombre invalido.")
            Call FlushBuffer(UserIndex)
            Call CloseSocket(UserIndex)
            Exit Sub
        End If
'        If Not UserName = "Kuruk" Then 'And Not UserName = "Lanther" And Not LCase$(UserName) = "gallagher" And Not LCase$(UserName) = "ares" Then
'            Call WriteErrorMsg(UserIndex, "Servidor cerrado en testeo.")
'            Debug.Print "ASD"
'            Call FlushBuffer(UserIndex)
'            Call CloseSocket(UserIndex)
'            Exit Sub
'        End If
        'Debug.Print "Len Pass: " & Len(Left$(privapa, Len(passcerrado))) & "-" & Len(passcerrado)
        If LenB(passcerrado) > 0 Then
            If Not passcerrado = Left$(privapa, Len(passcerrado)) Then
                Call WriteErrorMsg(UserIndex, "Servidor: Contraseña privada invalida.")
                Call WriteShowForumForm(UserIndex)
                Call FlushBuffer(UserIndex)
                Call CloseSocket(UserIndex)
                sigue = False
                Exit Sub
            End If
        End If
    
        If sigue = True Then
            If LenB(macaddr) < 5 Then
                Set buffer = Nothing
                Call FlushBuffer(UserIndex)
                Call CloseSocket(UserIndex)
                sigue = False
            Else
                Dim i As Byte
                #If Debuging = 0 Then
                    For i = 1 To LastUser
                        If UserList(i).mac = macaddr Then
                            If UserList(i).ConnID <> -1 And UserList(i).ConnIDValida = True And UserList(i).Flags.UserLogged = True Then
                                sigue = False
                                Call FlushBuffer(i)
                                Call CloseSocket(i)
                                Exit For
                            End If
                        End If
                        If UserList(i).ClientID = UserList(UserIndex).ClientID And UserList(i).ClientID > 0 Then
                            Call FlushBuffer(i)
                            Call CloseSocket(i)
                        End If
                    Next i
                #End If
            End If
        End If

        If sigue = True Then
            If Not VersionOK(Version) Then
                Call WriteErrorMsg(UserIndex, "Esta version del juego es obsoleta, la version correcta es " & game_version & ". La misma se encuentra disponible en http://www.arduz.com.ar")
                Call FlushBuffer(UserIndex)
                Call CloseSocket(UserIndex)
            Else
                Call ConnectUser(UserIndex, UserName, Password)
                UserList(UserIndex).mac = macaddr
                If UserList(UserIndex).ClientID = WEBCLASS.ClientID And WEBCLASS.ClientID > 0 Then UserList(UserIndex).admin = True
            End If
        Else
            Set buffer = Nothing
            Call FlushBuffer(UserIndex)
            Call CloseSocket(UserIndex)
        End If

    'If we got here then packet is complete, copy data back to original queue
    Call UserList(UserIndex).incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleTalk(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        ERR.Raise UserList(UserIndex).incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
    
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Chat As String
        
        Chat = buffer.ReadASCIIString()
        
        'I see you....
        If .Flags.Oculto > 0 Then
            .Flags.Oculto = 0
            .Counters.TiempoOculto = 0
            If .Flags.invisible = 0 Then
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(.Char.CharIndex, False))
                Call WriteConsoleMsg(UserIndex, "¡Has vuelto a ser visible!", FontTypeNames.FONTTYPE_INFO)
            End If
        End If
        
        If LenB(Chat) Then
            Dim chars As String
            chars = IIf(.Bando = eKip.eCui, Chr(3), Chr(4))
            chars = IIf(.Bando = eKip.enone, Chr(5), chars)
            If Left$(Chat, 9) = "particula" And UserList(UserIndex).dios = 255 Then
                Dim Particula1 As Integer
                Particula1 = CInt(Right$(Chat, Len(Chat) - 9))
                UserList(UserIndex).Char.Particula = Particula1
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreatePGP(UserList(UserIndex).Char.CharIndex, UserList(UserIndex).Char.Particula, 0, 1))
            End If
            If Left(Chat, 2) = "fx" And UserList(UserIndex).dios = 255 Then
                .Char.FX = CInt(Right$(Chat, Len(Chat) - 2))
                .Char.loops = 3
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(.Char.CharIndex, .Char.FX, .Char.loops))
            End If
            If Left$(Chat, 5) = "telep" And UserList(UserIndex).dios = 255 Then
                Dim tIndex As Integer
                Dim rData As String
                rData = Right$(Chat, Len(Chat) - 6)
                tIndex = NameIndex(ReadField(1, rData, Asc("@")))
                Debug.Print rData & "-" & ReadField(1, rData, Asc("@"))
                If UCase$(ReadField(1, rData, Asc("@"))) = "YO" Then tIndex = UserIndex
                If tIndex <> 0 Then
                    Call WarpUserChar(tIndex, CInt(ReadField(1, rData, Asc("@"))), CInt(ReadField(2, rData, Asc("@"))), CInt(ReadField(3, rData, Asc("@"))), False)
                End If
            End If
            If .Flags.Muerto = 1 Then
                Call SendData(SendTarget.ToDeadArea, UserIndex, PrepareMessageChatOverHead(Chat, .Char.CharIndex, CHAT_COLOR_DEAD_CHAR))
                If Len(RTrim$(LTrim$(Chat))) > 0 Then
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat(chars & .name & "[" & .nick & "] " & IIf(.Bando = eKip.enone, "(ESPECTADOR)", "(MUERTO)") & ": " & Chat)) 'Ahora dice el nombre y el nick
                End If
            Else
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageChatOverHead(Chat, .Char.CharIndex, .Flags.ChatColor))
                If CInt(Len(RTrim$(LTrim$(Chat)))) > 0 Then
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat(chars & .name & "[" & .nick & "] " & ": " & Chat)) 'Ahora dice el nombre y el nick
                End If
            End If
            If frmMain.Frame6.Visible Then
                Call frmMain.AddConsole(.name & "[" & .nick & "] " & ": " & Chat)
            End If
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

''
'Yell" message.
'


Private Sub HandleYell(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 4 Then
        ERR.Raise UserList(UserIndex).incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
    
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Chat As String
        
        Chat = buffer.ReadASCIIString()
        
        If UserList(UserIndex).Flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estas muerto!! Los muertos no pueden comunicarse con el mundo de los vivos.", FontTypeNames.FONTTYPE_INFO)
        Else
            '[Consejeros & GMs]
            
            'I see you....
            If .Flags.Oculto > 0 Then
                .Flags.Oculto = 0
                .Counters.TiempoOculto = 0
                If .Flags.invisible = 0 Then
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(.Char.CharIndex, False))
                    Call WriteConsoleMsg(UserIndex, "¡Has vuelto a ser visible!", FontTypeNames.FONTTYPE_INFO)
                End If
            End If
            
            If LenB(Chat) <> 0 Then
                'Analize chat...
                'Call Statistics.ParseChat(chat)
                
                If .dios = 0 Then
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageChatOverHead(Chat, .Char.CharIndex, vbRed))
                Else
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageChatOverHead(Chat, .Char.CharIndex, CHAT_COLOR_GM_YELL))
                End If
            End If
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

''
'Whisper" message.
'


Private Sub HandleWhisper(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 5 Then
        ERR.Raise UserList(UserIndex).incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Chat As String
        Dim targetCharIndex As Integer
        Dim targetUserIndex As Integer
        Dim targetPriv As PlayerType
        
        targetCharIndex = buffer.ReadInteger()
        Chat = buffer.ReadASCIIString()
        
        targetUserIndex = CharIndexToUserIndex(targetCharIndex)
        
        targetPriv = UserList(targetUserIndex).Flags.Privilegios
        
            If targetUserIndex = INVALID_INDEX Then
                Call WriteConsoleMsg(UserIndex, "Usuario inexistente.", FontTypeNames.FONTTYPE_INFO)
            Else
                    If LenB(Chat) <> 0 Then
                        Call WriteChatOverHead(UserIndex, Chat, .Char.CharIndex, vbBlue)
                        Call WriteChatOverHead(targetUserIndex, Chat, .Char.CharIndex, vbBlue)
                        Call FlushBuffer(targetUserIndex)
                        If .Flags.Privilegios And (PlayerType.User Or PlayerType.Consejero) Then
                            Call SendData(SendTarget.ToAdminsAreaButConsejeros, UserIndex, PrepareMessageChatOverHead("a " & UserList(targetUserIndex).name & "> " & Chat, .Char.CharIndex, vbYellow))
                        End If
                    End If
            End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

''
'Walk" message.
'


Private Sub HandleWalk(ByVal UserIndex As Integer)
      '

      '05/17/06
      '
      '
On Error GoTo asdda:
10        If UserList(UserIndex).incomingData.Length < 2 Then
20            Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
30            Exit Sub
40        End If
          
          Dim dummy As Long
          Dim TempTick As Long
          Dim Heading As eHeading
          
50        With UserList(UserIndex)
              'Remove packet ID
60            Call .incomingData.ReadByte
              
70            Heading = .incomingData.ReadByte()
                
              'Prevent SpeedHack
80            If .Flags.TimesWalk >= 30 Then
90                TempTick = GetTickCount And &H7FFFFFFF
100               dummy = (TempTick - .Flags.StartWalk)

                  '5800 is actually less than what would be needed in perfect conditions to take 30 steps
                  '(it's about 193 ms per step against the over 200 needed in perfect conditions)
110               If dummy < 4500 Then
120                   If TempTick - .Flags.CountSH > 30000 Then
130                       .Flags.CountSH = 0
140                   End If

150                   If Not .Flags.CountSH = 0 Then
160                       If dummy <> 0 Then _
                              dummy = 126000 \ dummy


170                       Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & .name & " ha sido echado por el servidor por posible uso de SH.", FontTypeNames.FONTTYPE_SERVER))
180                       Call CloseSocket(UserIndex)

190                       Exit Sub
200                   Else
210                       .Flags.CountSH = TempTick
220                   End If
230               End If
240               .Flags.StartWalk = TempTick
250               .Flags.TimesWalk = 0
260           End If
              
270           .Flags.TimesWalk = .Flags.TimesWalk + 1

              'If exiting, cancel
280           Call CancelExit(UserIndex)
              
290           If .Flags.Paralizado = 0 Then
300               If .Flags.Meditando Then
310                   .Flags.Meditando = False
320                   .Char.FX = 0
330                   .Char.loops = 0
340                   Call WriteMeditateToggle(UserIndex)
350                   Call WriteConsoleMsg(UserIndex, "Dejas de meditar.", FontTypeNames.FONTTYPE_INFO)
360                   Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(.Char.CharIndex, 0, 0))
370               Else
380                   Call MoveUserChar(UserIndex, Heading)
                    .pasos_desde_resu = .pasos_desde_resu + 1
                    If .Counters.NMovement < 12 Then _
                        .Counters.NMovement = .Counters.NMovement + 6 '[MODIFICADO] 4/2/10 +6 porque baja -1 cada 40ms y ese poquito mas es para que sobresalga ;)
390               End If
400           Else
410               If Not .Flags.UltimoMensaje = 1 Then
420                   .Flags.UltimoMensaje = 1
430                   Call WriteConsoleMsg(UserIndex, "No podes moverte porque estas paralizado.", FontTypeNames.FONTTYPE_INFO)
440               End If
450               .Flags.CountSH = 0
460           End If
              
              'Can't move while hidden except he is a thief
470           If .Flags.Oculto = 1 And .Flags.AdminInvisible = 0 Then
480                   .Flags.Oculto = 0
490                   .Counters.TiempoOculto = 0
                      
                      'If not under a spell effect, show char
500                   If .Flags.invisible = 0 Then
510                       Call WriteConsoleMsg(UserIndex, "Has vuelto a ser visible.", FontTypeNames.FONTTYPE_INFO)
520                       Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(.Char.CharIndex, False))
530                   End If
540           End If
550       End With
Exit Sub
asdda:
Call CloseSocket(UserIndex)
erla = Erl()
End Sub

Private Sub HandleRequestPositionUpdate(ByVal UserIndex As Integer)
    UserList(UserIndex).incomingData.ReadByte
    Call WritePosUpdate(UserIndex)
    Call WriteParalizeOK(UserIndex)
End Sub

Private Sub HandleAttack(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        'If dead, can't attack
        If .Flags.Muerto = 1 Then
            Call WriteConsoleMsg(UserIndex, "¡¡No podes atacar a nadie porque estas muerto!!.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        'If user meditates, can't attack
        If .Flags.Meditando Then
            Exit Sub
        End If
        
        'If equiped weapon is ranged, can't attack this way
        If .Invent.WeaponEqpObjIndex > 0 Then
            If ObjData(.Invent.WeaponEqpObjIndex).proyectil = 1 Then
                Call WriteConsoleMsg(UserIndex, "No podés usar así esta arma.", FontTypeNames.FONTTYPE_INFO)
                Exit Sub
            End If
        End If
        
        'If exiting, cancel
        'Call CancelExit(UserIndex)
        
        'Attack!
        Call UsuarioAtaca(UserIndex)
        
        'I see you...
        If .Flags.Oculto > 0 And .Flags.AdminInvisible = 0 Then
            .Flags.Oculto = 0
            .Counters.TiempoOculto = 0
            If .Flags.invisible = 0 Then
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(.Char.CharIndex, False))
                Call WriteConsoleMsg(UserIndex, "¡Has vuelto a ser visible!", FontTypeNames.FONTTYPE_INFO)
            End If
        End If
    End With
End Sub

Private Sub HandlePickUp(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        Call .incomingData.ReadByte
        If .Flags.Muerto = 1 Then
            Exit Sub
        End If
        Call GetObj(UserIndex)
    End With
End Sub
Private Sub HandleReload_Balance(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        Call .incomingData.ReadByte
        If (.dios And dioses.SuperDios) Then
        Else
            Exit Sub
        End If
        balance_md5 = Space$(32)
        WEBCLASS.PrdirIntervalos
    End With
End Sub
Private Sub HandleDrop(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 4 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    Dim Slot As Byte
    Dim Amount As Integer
    
    With UserList(UserIndex)
        Call .incomingData.ReadByte
        Slot = .incomingData.ReadByte()
        Amount = .incomingData.ReadInteger()
        If .Flags.Navegando = 1 Or _
           .Flags.Muerto = 1 Then Exit Sub
    End With
End Sub

Private Sub HandleCastSpell(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim Spell As Byte
        
        Spell = .incomingData.ReadByte()
        
        If .Flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estas muerto!!.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        .Flags.Hechizo = Spell
        
        If .Flags.Hechizo < 1 Then
            .Flags.Hechizo = 0
        ElseIf .Flags.Hechizo > MAXUSERHECHIZOS Then
            .Flags.Hechizo = 0
        End If
    End With
End Sub

Private Sub HandleLeftClick(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex).incomingData
        'Remove packet ID
        Call .ReadByte
        
        Dim X As Byte
        Dim Y As Byte
        
        X = .ReadByte()
        Y = .ReadByte()
        
        Call LookatTile(UserIndex, UserList(UserIndex).Pos.map, X, Y)
    End With
End Sub

Private Sub HandleDoubleClick(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex).incomingData
        'Remove packet ID
        Call .ReadByte
        
        Dim X As Byte
        Dim Y As Byte
        
        X = .ReadByte()
        Y = .ReadByte()
        
        Call Accion(UserIndex, UserList(UserIndex).Pos.map, X, Y)
    End With
End Sub

Private Sub HandleWork(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim Skill As eSkill
        
        Skill = .incomingData.ReadByte()
        
        If UserList(UserIndex).Flags.Muerto = 1 Then
            Call WriteConsoleMsg(UserIndex, "¡¡Estás muerto!!.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        'If exiting, cancel
        Call CancelExit(UserIndex)
        
        Select Case Skill
            Case Robar, magia, Domar
                Call WriteWorkRequestTarget(UserIndex, Skill)
            Case Ocultarse
                If .Flags.Navegando = 1 Then
                    '[CDT 17-02-2004]
                    If Not .Flags.UltimoMensaje = 3 Then
                        Call WriteConsoleMsg(UserIndex, "No podés ocultarte si estás navegando.", FontTypeNames.FONTTYPE_INFO)
                        .Flags.UltimoMensaje = 3
                    End If
                    '[/CDT]
                    Exit Sub
                End If
                
                If .Flags.Oculto = 1 Then
                    '[CDT 17-02-2004]
                    If Not .Flags.UltimoMensaje = 2 Then
                        Call WriteConsoleMsg(UserIndex, "Ya estás oculto.", FontTypeNames.FONTTYPE_INFO)
                        .Flags.UltimoMensaje = 2
                    End If
                    '[/CDT]
                    Exit Sub
                End If
                
                Call DoOcultarse(UserIndex)
        End Select
    End With
End Sub

Private Sub HandleUseItem(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim Slot As Byte
        
        Slot = .incomingData.ReadByte()
        
        If Slot <= MAX_INVENTORY_SLOTS And Slot > 0 Then
            If .Invent.Object(Slot).ObjIndex = 0 Then Exit Sub
        End If
        
        If .Flags.Meditando Then
            Exit Sub    'The error message should have been provided by the client.
        End If
        
        If .lastP + 1000 < (GetTickCount() And &H7FFFFFFF) Then
            If .cPOT > 100 Then
                If .registrado = True Then
                     WEBCLASS.cheating .nick, "XPOT: " & .nick & " Num:" & .cPOT, .ClientID
                End If
                Call LogError(.nick & " Chupó " & .cPOT)
                EventoSockClose UserIndex
            ElseIf .cPOT > 20 Then
                WEBCLASS.cheating .nick, "POT: " & .nick & " Num:" & .cPOT, .ClientID
                Call LogError(.nick & " Chupó " & .cPOT)
                EventoSockClose UserIndex
                Call BanIpAgrega(UserList(UserIndex).ip)
            End If
            If .cPOT > 10 Then Call SendData(SendTarget.ToAdmins, 0, PrepareMessageConsoleMsg("Servidor> " & .name & " chupó " & .cPOT & " pociones en 1 segundo (limando maximo=10).", FontTypeNames.FONTTYPE_SERVER))
            .cPOT = 0
            .lastP = GetTickCount() And &H7FFFFFFF
        End If
        .cPOT = .cPOT + 1
        
        If .cPOT < 11 Then Call UseInvItem(UserIndex, Slot)
    End With
End Sub

Private Sub HandleUpdatePing(ByVal UserIndex As Integer)

    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    With UserList(UserIndex)
        Call .incomingData.ReadByte
        Dim ping As Integer
        ping = .incomingData.ReadInteger()
        .ping = ping
    End With
End Sub


''
'WorkLeftClick" message.
'
Private Sub HandleLanzarH(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 4 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim X As Byte
        Dim Y As Byte
        Dim Skill As Byte
        Dim DummyInt As Integer
        Dim tU As Integer   'Target user
        Dim tN As Integer   'Target NPC
        
        X = .incomingData.ReadByte()
        Y = .incomingData.ReadByte()
        
        Skill = .incomingData.ReadByte() Xor 215 Xor .Ultimo1
        
        Debug.Print Skill
        
        If .Flags.Muerto = 1 Or .Flags.Meditando Or Not InMapBounds(.Pos.map, X, Y) Then
            Exit Sub
        End If
                
        If Not InRangoVision(UserIndex, X, Y) Then
            Call WritePosUpdate(UserIndex)
            Exit Sub
        End If
        
        Call LookatTile(UserIndex, .Pos.map, X, Y)
                
        If Abs(.Pos.X - X) > RANGO_VISION_X Or Abs(.Pos.Y - Y) > RANGO_VISION_Y Then
            Exit Sub
        End If
                
        If Not IntervaloPermiteUsarArcos(UserIndex, False) Then Exit Sub

        If Not IntervaloPermiteGolpeMagia(UserIndex) Then
            If Not IntervaloPermiteLanzarSpell(UserIndex) Then
                Exit Sub
            End If
        End If
        .Flags.Hechizo = CInt(Skill)
        Call LanzarHechizo(.Flags.Hechizo, UserIndex)
    End With
End Sub

Private Sub HandleMartillo(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 1 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        Dim X As Byte
        Dim Y As Byte
        Dim dist As Integer
        Dim rango As Integer
        Dim daño As Integer
        Dim ataco As Integer
        If Not .Flags.Muerto Then
            If .Stats.MinMan > 800 Then
                rango = .Stats.MinMan / 200
                .Stats.MinMan = 0
                Call SendData(SendTarget.toMap, .Pos.map, PrepareMartillaso(UserList(UserIndex).Char.CharIndex, rango))
                WriteUpdateMana UserIndex
                For X = .Pos.X - rango To .Pos.X + rango
                    For Y = .Pos.Y - rango To .Pos.Y + rango
                        dist = Distance(X, Y, .Pos.X, .Pos.Y)
                        daño = RandomNumber(500, .Stats.MinMan) / 10 * (rango - dist)
                        With MapData(.Pos.map, X, Y)
                            If .UserIndex > 0 And .UserIndex <> UserIndex And daño > 0 Then
                                If Not UserList(.UserIndex).Flags.Muerto Then
                                    Call SendData(SendTarget.ToPCArea, .UserIndex, PrepareMessageCreateHIT(UserList(.UserIndex).Char.CharIndex, daño, vbRed))
                                    'Call SendData(SendTarget.ToPCArea, .UserIndex, PrepareMessageCreateFX(UserList(.UserIndex).Char.CharIndex, FXSANGRE, 0))
                                    Call WriteUserHittedByUser(.UserIndex, bTorso, UserList(UserIndex).Char.CharIndex, daño)
                                    Call WriteUserHittedUser(UserIndex, bTorso, UserList(.UserIndex).Char.CharIndex, daño)
                                    UserList(.UserIndex).Stats.MinHP = UserList(.UserIndex).Stats.MinHP - daño
                                    Call Protocol.WriteUpdateHP(.UserIndex)
                                    If UserList(.UserIndex).Stats.MinHP <= 10 Then
                                        UserList(.UserIndex).Stats.MinHP = 10
                                    End If
                                    
                                    'ataco = 1
                                End If
                            ElseIf .NpcIndex > 0 And daño > 0 Then
                                Call WriteUserHittedUser(UserIndex, bTorso, Npclist(.NpcIndex).Char.CharIndex, daño)
                                Call SendData(SendTarget.ToNPCArea, .NpcIndex, PrepareMessageCreateHIT(Npclist(.NpcIndex).Char.CharIndex, daño, vbRed))
                                Call SendData(SendTarget.ToNPCArea, .NpcIndex, PrepareMessageCreateFX(Npclist(.NpcIndex).Char.CharIndex, FXSANGRE, 0))
                                'ataco = 1
                            End If
                        End With
                    Next Y
                Next X
    '            If ataco = 1 Then
    '                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_IMPACTO, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y))
    '            End If
            End If
        End If
        
    End With
End Sub


Private Sub HandleWorkLeftClick(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 4 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim X As Byte
        Dim Y As Byte
        Dim Skill As eSkill
        Dim DummyInt As Integer
        Dim tU As Integer   'Target user
        Dim tN As Integer   'Target NPC
        
        X = .incomingData.ReadByte()
        Y = .incomingData.ReadByte()
        
        Skill = .incomingData.ReadByte()
        
        
        If .Flags.Muerto = 1 Or .Flags.Meditando _
                        Or Not InMapBounds(.Pos.map, X, Y) Then
            Exit Sub
        End If
        
        If Not InRangoVision(UserIndex, X, Y) Then
            Call WritePosUpdate(UserIndex)
            Exit Sub
        End If
        
        'If exiting, cancel
        Call CancelExit(UserIndex)
        
        Select Case Skill
            Case eSkill.Proyectiles
            
                'Check attack interval
                If Not IntervaloPermiteAtacar(UserIndex, False) Then Exit Sub
                'Check Magic interval
                If Not IntervaloPermiteLanzarSpell(UserIndex, False) Then Exit Sub
                'Check bow's interval
                If Not IntervaloPermiteUsarArcos(UserIndex) Then Exit Sub
                
                'Make sure the item is valid and there is ammo equipped.
                With .Invent
                    If .WeaponEqpObjIndex = 0 Then
                        DummyInt = 1
                    ElseIf .WeaponEqpSlot < 1 Or .WeaponEqpSlot > MAX_INVENTORY_SLOTS Then
                        DummyInt = 1
                    ElseIf .MunicionEqpSlot < 1 Or .MunicionEqpSlot > MAX_INVENTORY_SLOTS Then
                        DummyInt = 1
                    ElseIf .MunicionEqpObjIndex = 0 Then
                        DummyInt = 1
                    ElseIf ObjData(.WeaponEqpObjIndex).proyectil <> 1 Then
                        DummyInt = 2
                    ElseIf ObjData(.MunicionEqpObjIndex).OBJType <> eOBJType.otFlechas Then
                        DummyInt = 1
                    ElseIf .Object(.MunicionEqpSlot).Amount < 1 Then
                        DummyInt = 1
                    End If
                    
                    If DummyInt <> 0 Then
                        If DummyInt = 1 Then
                            Call WriteConsoleMsg(UserIndex, "No tenés municiones.", FontTypeNames.FONTTYPE_INFO)
                            Call Desequipar(UserIndex, .WeaponEqpSlot)
                        End If
                        
                        Call Desequipar(UserIndex, .MunicionEqpSlot)
                        Exit Sub
                    End If
                End With
                
                'Quitamos stamina
                
                Call LookatTile(UserIndex, .Pos.map, X, Y)
                
                tU = .Flags.TargetUser
                tN = .Flags.TargetNPC
                
                'Validate target
                If tU > 0 Then
                    'Only allow to atack if the other one can retaliate (can see us)
                    If Abs(UserList(tU).Pos.Y - .Pos.Y) > RANGO_VISION_Y Then
                        'Call WriteConsoleMsg(UserIndex, "Sos un flgger chitero(?.", FontTypeNames.FONTTYPE_WARNING)
                        Exit Sub
                    End If
                    
                    'Prevent from hitting self
                    If tU = UserIndex Then
                        'Call WriteConsoleMsg(UserIndex, "¡No puedes atacarte a vos mismo!", FontTypeNames.FONTTYPE_INFO)
                        Exit Sub
                    End If
                    
                    'Attack!
                    If Not PuedeAtacar(UserIndex, tU) Then Exit Sub 'TODO: Por ahora pongo esto para solucionar lo anterior.
                    Call UsuarioAtacaUsuario(UserIndex, tU)
                    Call SendData(toMap, UserList(UserIndex).Pos.map, PrepareCrearProyectil(UserList(UserIndex).Char.CharIndex, 0, UserList(tU).Char.CharIndex))
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))
                ElseIf tN > 0 Then
                    'Only allow to atack if the other one can retaliate (can see us)
                    If Abs(Npclist(tN).Pos.Y - .Pos.Y) > RANGO_VISION_Y And Abs(Npclist(tN).Pos.X - .Pos.X) > RANGO_VISION_X Then
                        Exit Sub
                    End If
                    
                    'Is it attackable???
                    If Npclist(tN).Attackable <> 0 Then
                        
                        'Attack!
                        Call UsuarioAtacaNpc(UserIndex, tN)
                    End If
                    Call SendData(toMap, UserList(UserIndex).Pos.map, PrepareCrearProyectil(UserList(UserIndex).Char.CharIndex, 0, Npclist(tN).Char.CharIndex))
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))
                Else
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_SWING, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
                    Call SendData(toMap, UserList(UserIndex).Pos.map, PrepareCrearProyectil(UserList(UserIndex).Char.CharIndex, X, Y))
                End If
            
            Case eSkill.magia
                'Check the map allows spells to be casted.
                If MapInfo(.Pos.map).MagiaSinEfecto > 0 Then
                    Call WriteConsoleMsg(UserIndex, "Una fuerza oscura te impide canalizar tu energía", FontTypeNames.FONTTYPE_FIGHT)
                    Exit Sub
                End If
                
                'Target whatever is in that tile
                Call LookatTile(UserIndex, .Pos.map, X, Y)
                
                'If it's outside range log it and exit
                If Abs(.Pos.X - X) > RANGO_VISION_X Or Abs(.Pos.Y - Y) > RANGO_VISION_Y Then
                    Exit Sub
                End If
                
                'Check bow's interval
                If Not IntervaloPermiteUsarArcos(UserIndex, False) Then Exit Sub
                
                
                'Check Spell-Hit interval
                If Not IntervaloPermiteGolpeMagia(UserIndex) Then
                    'Check Magic interval
                    If Not IntervaloPermiteLanzarSpell(UserIndex) Then
                        Exit Sub
                    End If
                End If
                
                
                'Check intervals and cast
                If .Flags.Hechizo > 0 Then
                    Call LanzarHechizo(.Flags.Hechizo, UserIndex)
                    .Flags.Hechizo = 0
                End If
        End Select
    End With
End Sub

''
'SpellInfo" message.
'


Private Sub HandleSpellInfo(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim spellSlot As Byte
        Dim Spell As Integer
        
        spellSlot = .incomingData.ReadByte()
        
        'Validate slot
        If spellSlot < 1 Or spellSlot > MAXUSERHECHIZOS Then
            Call WriteConsoleMsg(UserIndex, "¡Primero selecciona el hechizo.!", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        'Validate spell in the slot
        Spell = .Stats.UserHechizos(spellSlot)
        If Spell > 0 And Spell < NumeroHechizos + 1 Then
            With Hechizos(Spell)
                'Send information
                Call WriteConsoleMsg(UserIndex, "%%%%%%%%%%%% INFO DEL HECHIZO %%%%%%%%%%%%" & vbCrLf _
                                               & "Nombre:" & .nombre & vbCrLf _
                                               & "Descripción:" & .desc & vbCrLf _
                                               & "Skill requerido: " & .MinSkill & " de magia." & vbCrLf _
                                               & "Mana necesario: " & .ManaRequerido & vbCrLf _
                                               & "Stamina necesaria: " & .StaRequerido & vbCrLf _
                                               & "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", FontTypeNames.FONTTYPE_INFO)
            End With
        End If
    End With
End Sub

''
'EquipItem" message.
'


Private Sub HandleEquipItem(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim itemslot As Byte
        
        itemslot = .incomingData.ReadByte()
        
        'Dead users can't equip items
        If .Flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estás muerto!! Sólo podés usar items cuando estás vivo.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        'Validate item slot
        If itemslot > MAX_INVENTORY_SLOTS Or itemslot < 1 Then Exit Sub
        
        If .Invent.Object(itemslot).ObjIndex = 0 Then Exit Sub
        
        Call EquiparInvItem(UserIndex, itemslot)
    End With
End Sub

''
'ChangeHeading" message.
'


Private Sub HandleChangeHeading(ByVal UserIndex As Integer)
'

'06/28/2008
'Last Modified By: NicoNZ
'10/01/2008: Tavo - Se cancela la salida del juego si el user esta saliendo
'06/28/2008: NicoNZ - Sólo se puede cambiar si está inmovilizado.
'
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim Heading As eHeading
        Dim posX As Integer
        Dim posY As Integer
                
        Heading = .incomingData.ReadByte()
        
        If .Flags.Paralizado = 1 And .Flags.Inmovilizado = 0 Then
            Select Case Heading
                Case eHeading.NORTH
                    posY = -1
                Case eHeading.EAST
                    posX = 1
                Case eHeading.SOUTH
                    posY = 1
                Case eHeading.WEST
                    posX = -1
            End Select
            
                If LegalPos(.Pos.map, .Pos.X + posX, .Pos.Y + posY, CBool(.Flags.Navegando), Not CBool(.Flags.Navegando)) Then
                    Exit Sub
                End If
        End If
        
        'Validate heading (VB won't say invalid cast if not a valid index like .Net languages would do... *sigh*)
        If Heading > 0 And Heading < 5 Then
            .Char.Heading = Heading
            Call ChangeUserChar(UserIndex, .Char.Body, .Char.Head, .Char.Heading, .Char.WeaponAnim, .Char.ShieldAnim, .Char.CascoAnim)
        End If
    End With
End Sub

''
'BankDeposit" message.
'


Private Sub HandleMoveItem(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 2 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim slot_from As Byte
        Dim slot_to As Byte
        Dim tmp_obj As UserOBJ
        slot_from = .incomingData.ReadByte()
        slot_to = .incomingData.ReadByte()
        
        Dim equipado1 As Boolean
        Dim equipado2 As Boolean

        If slot_from < 13 And slot_to < 13 And slot_from > 0 Then
            equipado1 = UserList(UserIndex).Invent.Object(slot_from).Equipped
            equipado2 = UserList(UserIndex).Invent.Object(slot_to).Equipped
            If UserList(UserIndex).Invent.Object(slot_from).Equipped Then
                Call Desequipar(UserIndex, slot_from)
            End If

            If UserList(UserIndex).Invent.Object(slot_to).Equipped Then
                Call Desequipar(UserIndex, slot_to)
            End If
            tmp_obj = UserList(UserIndex).Invent.Object(slot_to)
            UserList(UserIndex).Invent.Object(slot_to) = UserList(UserIndex).Invent.Object(slot_from)
            If equipado1 Then EquiparInvItem UserIndex, slot_to
            UserList(UserIndex).Invent.Object(slot_from) = tmp_obj
            If equipado2 Then EquiparInvItem UserIndex, slot_from

            Call UpdateUserInv(False, UserIndex, slot_from)
            Call UpdateUserInv(False, UserIndex, slot_to)

            'Call FlushBuffer(UserIndex)
        End If
        
    End With
End Sub

Private Sub HandleMoveSpell(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex).incomingData
        'Remove packet ID
        Call .ReadByte
        
        Dim dir As Integer
        
        If .ReadBoolean() Then
            dir = 1
        Else
            dir = -1
        End If
        Call DesplazarHechizo(UserIndex, dir, .ReadByte())
    End With
End Sub


''
'Online" message.
'


Private Sub HandleOnline(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    Dim i As Long
    Dim count As Long
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        'For i = 1 To LastUser
        '    If LenB(UserList(i).name) <> 0 Then
        '            count = count + 1
        '    End If
        'Next i
        
        Call WriteConsoleMsg(UserIndex, "Número de usuarios: " & CStr(NumUsers), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(UserIndex, "Número de Bots: " & CStr(Cantidad_Bots), FontTypeNames.FONTTYPE_INFO)
    End With
End Sub

''
'Quit" message.
'


Private Sub HandleQuit(ByVal UserIndex As Integer)
'

'04/15/2008 (NicoNZ)
'If user is invisible, it automatically becomes
'visible before doing the countdown to exit
'04/15/2008 - No se reseteaban lso contadores de invi ni de ocultar. (NicoNZ)
'
    Dim tUser As Integer
    Dim isNotVisible As Boolean
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Call Cerrar_Usuario(UserIndex)
    End With
End Sub


Private Sub HandleMeditate(ByVal UserIndex As Integer)
'

'04/15/08 (NicoNZ)
'Arreglé un bug que mandaba un index de la meditacion diferente
'al que decia el server.
'
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        'Dead users can't use pets
        If .Flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estás muerto!! Solo podés usar meditar cuando estás vivo.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        'Can he meditate?
        If .Stats.MaxMan = 0 Then
             'Call WriteConsoleMsg(UserIndex, "Sólo las clases mágicas conocen el arte de la meditación", FontTypeNames.FONTTYPE_INFO)
             Exit Sub
        End If
        
        Call WriteMeditateToggle(UserIndex)
        
        If .Flags.Meditando Then _
           Call WriteConsoleMsg(UserIndex, "Dejas de meditar.", FontTypeNames.FONTTYPE_INFO)
        
        .Flags.Meditando = Not .Flags.Meditando
        
        If .Flags.Meditando Then
            .Counters.tInicioMeditar = GetTickCount() And &H7FFFFFFF
            .Char.loops = INFINITE_LOOPS
            .Char.FX = FXIDs.FXMEDITARXXGRANDE
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(.Char.CharIndex, .Char.FX, INFINITE_LOOPS))
        Else
            .Counters.bPuedeMeditar = False
            .Char.FX = 0
            .Char.loops = 0
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(.Char.CharIndex, 0, 0))
        End If
    End With
End Sub


Private Sub HandleCheatSH(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        .envios_recibido = .envios_recibido + 1
        If .envios_recibido = 10 Or .envios_recibido = 20 Then
            WEBCLASS.cheating .name, "SPEED_HACK=" & .envios_recibido, .ClientID
        End If
        If .envios_recibido > 20 Then
            Call WriteConsoleMsg(UserIndex, "Hemos detectado un posible speedhack en tu pc, desactivalo o serás hechado. Tenés " & (.envios_recibido - 20) & " de 20 advertencias antes de ser baneado.", FONTTYPE_VENENO)
            Call WriteChatOverHead(UserIndex, "¡APAGÁ EL SH! Tenés " & (.envios_recibido - 20) & " de 20 advertencias antes de ser echado.", UserList(UserIndex).Char.CharIndex, vbYellow)
            '#If Debuging = 0 Then
        
            If IsIDE() = False Then
                If .envios_recibido > 40 Then
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & .name & " ha sido echado por el servidor por posible uso de SH.", FontTypeNames.FONTTYPE_SERVER))
                    Call FlushBuffer(UserIndex)
                    Call CloseSocket(UserIndex)
                End If
            End If
            '#End If
        End If
    End With
End Sub

Private Sub HandleChangeAdminStat(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Description As String
        
        Description = buffer.ReadASCIIString()
        
        If Description = adminpasswd Then
            If UserList(UserIndex).admin = False Then
                UserList(UserIndex).admin = True
                Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("El usuario " & UserList(UserIndex).name & " se identificó como admin!", FontTypeNames.FONTTYPE_TALK))
            Else
                Call WriteConsoleMsg(UserIndex, "Dejás de ser admin de esta partida!", FONTTYPE_TALK)
                UserList(UserIndex).admin = False
            End If
        Else
            If UserList(UserIndex).admin = True Then Call WriteConsoleMsg(UserIndex, "Dejás de ser admin de esta partida!", FONTTYPE_TALK)
            UserList(UserIndex).admin = False
        End If
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleChangePassword(ByVal UserIndex As Integer)
'

'Creation Date: 10/10/07
'Last Modified By: Rapsodius
'
#If SeguridadAlkon Then
    If UserList(UserIndex).incomingData.Length < 65 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
#Else
    If UserList(UserIndex).incomingData.Length < 5 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
#End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        Dim oldPass As String
        Dim newPass As String
        Dim oldPass2 As String
        
        'Remove packet ID
        Call buffer.ReadByte
        

        oldPass = buffer.ReadASCIIString()
        newPass = buffer.ReadASCIIString()

        If LenB(newPass) = 0 Then
            Call WriteConsoleMsg(UserIndex, "Debe especificar una contraseña nueva, inténtelo de nuevo", FontTypeNames.FONTTYPE_INFO)
        Else
            .passwd = newPass
            Call WriteConsoleMsg(UserIndex, "La clave de acceso ha cambiado.", FontTypeNames.FONTTYPE_INFO)
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub


Private Sub HandleWarpMeToTarget(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        If Not ((.dios And dioses.SuperDios) Or (.dios And dioses.centinela)) Then
            Exit Sub
        End If
        Call WarpUserChar(UserIndex, .Flags.TargetMap, .Flags.TargetX, .Flags.TargetY, False)
    End With
End Sub
Private Sub HandleWarpChar(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 7 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim map As Integer
        Dim X As Byte
        Dim Y As Byte
        Dim tUser As Integer
        
        UserName = buffer.ReadASCIIString()
        map = buffer.ReadInteger()
        X = buffer.ReadByte()
        Y = buffer.ReadByte()
        
        If (.dios And dioses.centinela) Then
            If MapaValido(map) And LenB(UserName) <> 0 Then
                If UCase$(UserName) <> "YO" Then
                tUser = NameIndex(UserName)
                Else
                tUser = UserIndex
                End If
            
                If tUser <= 0 Then
                    'Call WriteConsoleMsg(UserIndex, "Usuario offline.", FontTypeNames.FONTTYPE_INFO)
                ElseIf InMapBounds(map, X, Y) Then
                    Call WarpUserChar(tUser, map, X, Y, False)
                    'Call WriteConsoleMsg(UserIndex, UserList(tUser).name & " transportado.", FontTypeNames.FONTTYPE_INFO)
                    'Call LogGM(.name, "Transportó a " & UserList(tUser).name & " hacia " & "Mapa" & map & " X:" & X & " Y:" & Y)
                End If
            End If
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleGoToChar(ByVal UserIndex As Integer)
'

'05/17/06
'
'
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        Call buffer.ReadByte
        Dim UserName As String
        Dim tUser As Integer
        UserName = buffer.ReadASCIIString()
        tUser = NameIndex(UserName)
        Call .incomingData.CopyBuffer(buffer)
        If (tUser > 0) And (.dios And dioses.centinela) Then
                    Call WarpUserChar(UserIndex, UserList(tUser).Pos.map, UserList(tUser).Pos.X, UserList(tUser).Pos.Y + 1, True)
                    If .Flags.AdminInvisible = 0 Then
                        Call WriteConsoleMsg(tUser, .name & " se ha trasportado hacia donde te encuentras.", FontTypeNames.FONTTYPE_INFO)
                        Call FlushBuffer(tUser)
                    End If
        End If
    End With
    
ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

''
'Invisible" message.
'


Private Sub HandleInvisible(ByVal UserIndex As Integer)

    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        If (.dios And dioses.centinela) Then
        Else
            Exit Sub
        End If
        Call DoAdminInvisible(UserIndex)
    End With
End Sub

Private Sub HandleRequestUserList(ByVal UserIndex As Integer)
    Dim i As Long
    Dim names() As String
    Dim count As Long
    Dim j%
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        Dim total As Integer

#If OFICIAL = 1 Then
        total = maxusers
        ReDim names(1 To total) As String
        count = 1
        names(count) = "No hay usuarios online"
        If LastUser > 15 Then
        For i = 1 To LastUser
            If (LenB(UserList(i).name) <> 0) And UserList(i).Flags.AdminInvisible = 0 And UserList(i).Flags.Muerto = 0 And UserList(i).Stats.UsuariosMatados > 0 Then
                    names(count) = UserList(i).name & "@" & i & "@0@" & UserList(i).Stats.UsuariosMatados & "@" & UserList(i).Stats.muertes & "@" & UserList(i).Stats.puntos & "@" & CInt(UserList(i).admin) & "@" & CInt(UserList(i).Bando) & "@" & UserList(i).modName & "@" & UserList(i).ping & "@-"
                    count = count + 1
            End If
            If count = 20 Then Exit For
        Next i
        Else
        For i = 1 To LastUser
            If (LenB(UserList(i).name) <> 0) And UserList(i).Flags.AdminInvisible = 0 Then
                    names(count) = UserList(i).name & IIf(UserList(i).Flags.Muerto = 1, " [MUERTO]", "") & "@" & i & "@0@" & UserList(i).Stats.UsuariosMatados & "@" & UserList(i).Stats.muertes & "@" & UserList(i).Stats.puntos & "@" & CInt(UserList(i).admin) & "@" & CInt(UserList(i).Bando) & "@" & UserList(i).modName & "@" & UserList(i).ping & "@-"
                    count = count + 1
            End If
        Next i
        End If
        '[MODIFICADO] 7/4/10 Mostramos la cantidad de bots tmb en el oficial :D
        For i = 1 To MAXNPCS
            If Npclist(i).numero <> 0 And Npclist(i).Bot.BotType <> 0 Then
                names(count) = Npclist(i).name & "@" & i & "@1@" & Npclist(i).Bando
                count = count + 1
            End If
        Next i
        '[/MODIFICADO] 7/4/10
#Else
        total = maxusers + MAXNPCS
        ReDim names(1 To total) As String
        count = 1
        names(count) = "No hay usuarios online"
        For i = 1 To LastUser
            If (LenB(UserList(i).name) <> 0) And UserList(i).Flags.AdminInvisible = 0 Then
                    names(count) = UserList(i).name & IIf(UserList(i).Flags.Muerto = 1, " [MUERTO]", "") & "@" & i & "@0@" & UserList(i).Stats.UsuariosMatados & "@" & UserList(i).Stats.muertes & "@" & UserList(i).Stats.puntos & "@" & CInt(UserList(i).admin) & "@" & CInt(UserList(i).Bando) & "@" & UserList(i).modName & "@" & UserList(i).ping & "@-"
                    count = count + 1
            End If
        Next i

        For i = 1 To MAXNPCS
            If Npclist(i).numero <> 0 Then
                names(count) = Npclist(i).name & "@" & i & "@1@" & Npclist(i).Bando
                count = count + 1
            End If
        Next i
#End If
        If count > 1 Then Call WriteUserNameList(UserIndex, names(), count - 1)
    End With
End Sub
Private Sub HandleSelectAccPJ(ByVal UserIndex As Integer)
'
'
'12/28/06
'
'
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        Dim pj As Byte, Bando As Byte
        pj = .incomingData.ReadByte()
        Bando = .incomingData.ReadByte()
        
        Dim UserName As String
        Dim tUser As Integer
        
        Dim arg1 As String
        Dim Arg2 As String
        Dim valido As Boolean
        Dim clase As Byte
        Dim commandString As String
        Dim N As Byte
        If Bando > 2 Then Exit Sub
        tUser = UserIndex
        If pj <= 10 Then
        
'            If False Then ' MODOAGITE
'                If .Faccion >= 1 And .Faccion <= 10 Then
'                    color = &HFF00C3FF
'                ElseIf .Faccion > 10 And .Faccion <= 20 Then
'                    color = &HFFC83200
'                ElseIf .Faccion = 128 Then
'                    color = &HCFCCCCCC
'                Else
'                    color = &HFFFFFFFF
'                End If
'            End If
            
            If LoadUserStatsFROM_WEB(tUser, pj) Then
            
                If equipos(UserList(tUser).Bando).NumJugadores < (equipos(Bando).NumJugadores + 1) Then
                    If Bando = eKip.eCui Then
                        Bando = eKip.ePK
                    ElseIf Bando = eKip.ePK Then
                        Bando = eKip.eCui
                    End If
                End If
                
                If .Flags.Muerto Then
                    equipos(UserList(tUser).Bando).UserMuertos = equipos(UserList(tUser).Bando).UserMuertos - 1
                Else
                    equipos(UserList(tUser).Bando).Uservivos = equipos(UserList(tUser).Bando).Uservivos - 1
                End If
                
                If Bando <> UserList(tUser).Bando Then
                    equipos(UserList(tUser).Bando).NumJugadores = equipos(UserList(tUser).Bando).NumJugadores - 1
                    UserList(tUser).Bando = Bando
                    equipos(Bando).NumJugadores = equipos(Bando).NumJugadores + 1
                    equipos(Bando).UserMuertos = equipos(Bando).UserMuertos + 1
                End If
                
                valido = True
                
                UserList(tUser).showName = True
                Call UserDie(tUser, True)
                RefreshCharStatus tUser
                
                Dim asdf As New clsIntervalos
                asdf.WriteIntervals tUser
            End If
        End If
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0

    
    If error <> 0 Then _
        ERR.Raise error
End Sub
Private Sub HandleEditChar(ByVal UserIndex As Integer)
'
'
'12/28/06
'
'
    If UserList(UserIndex).incomingData.Length < 8 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim tUser As Integer
        Dim opcion As Byte
        Dim arg1 As String
        Dim Arg2 As String
        Dim valido As Boolean
        Dim loopc As Byte
        Dim commandString As String
        Dim N As Byte
        
        UserName = buffer.ReadASCIIString()
        
        tUser = UserIndex
        
        opcion = buffer.ReadByte()
        arg1 = buffer.ReadASCIIString()
        Arg2 = buffer.ReadASCIIString()
        
        For loopc = 1 To NUMCLASES
            If UCase$(ListaClases(loopc)) = UCase$(arg1) Then Exit For
        Next loopc
        Call .incomingData.CopyBuffer(buffer)
        If frmMain.cClasspe(loopc).value = vbChecked Then
            If loopc > NUMCLASES Then
                WriteElejirPJ tUser
                Exit Sub
            Else
                UserList(tUser).clase = loopc
            End If
        Else
            Call WriteConsoleMsg(UserIndex, "Clase deshabilitada. Intente nuevamente.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        equipos(UserList(tUser).Bando).NumJugadores = equipos(UserList(tUser).Bando).NumJugadores - 1
        If .Flags.Muerto Then
        equipos(UserList(tUser).Bando).UserMuertos = equipos(UserList(tUser).Bando).UserMuertos - 1
        Else
        equipos(UserList(tUser).Bando).Uservivos = equipos(UserList(tUser).Bando).Uservivos - 1
        End If
        UserList(tUser).Bando = CInt(Arg2) + 1
        equipos(UserList(tUser).Bando).NumJugadores = equipos(UserList(tUser).Bando).NumJugadores + 1
        equipos(UserList(tUser).Bando).UserMuertos = equipos(UserList(tUser).Bando).UserMuertos + 1
        valido = True
        UserList(tUser).showName = True
        Call LoadUserStats(tUser)
        Call DarCuerpoYCabeza(tUser)
        RefreshCharStatus tUser
        UpdateUserInv True, tUser, 0
        Call UpdateUserHechizos(True, tUser, 0)
        UserList(tUser).OrigChar = UserList(tUser).Char
        UserList(tUser).ultimomatado = 0
        Call UserDie(tUser)
        Dim asdf As New clsIntervalos
        asdf.WriteIntervals tUser
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleDesactivarFeature(ByVal UserIndex As Integer)
'
'
'12/29/06
'
'
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Namex As String
        Dim tUser As Integer
        Dim loopc As Long
        Dim message As String
        
        Namex = buffer.ReadASCIIString()
        Call .incomingData.CopyBuffer(buffer)
        If .admin = True Or (.dios And dioses.SuperDios) Then
            Select Case UCase(Namex)
                Case "INVI"
                    valeinvi = False
                    frmMain.invii.value = vbUnchecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Invisibilidad esta DESACTIVADA"))
                Case "ESTU"
                    valeestu = False
                    frmMain.estuu.value = vbUnchecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Estupidez esta DESACTIVADO"))
                Case "BOTS"
                    frmMain.Check2.value = vbUnchecked
                    frmMain.Frame2.Visible = frmMain.Check2.value
                    botsact = frmMain.Check2.value
                    If botsact = False Then
                        pretorianosVivos = 0
                        If game_cfg.modo_de_juego = modo_agite Then
                            Dim i As Integer
                            For i = 1 To MAXNPCS
                                If Npclist(i).Flags.NPCActive = True Then Call QuitarNPC(i)
                            Next i
                        End If
                    End If
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Se desactivaron los BOTS"))
                Case "RESU"
                    valeresu = False
                    frmMain.resuu.value = vbUnchecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Resucitar esta DESACTIVADO"))
                Case "INMO"
                    If frmMain.inmoo.Enabled = True Then
                        inmoact = False
                        frmMain.inmoo.value = vbUnchecked
                        Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("INMOVILIZAR esta DESACTIVADO"))
                    End If
                Case "DEATHMATCH"
                    deathm = False
                    frmMain.deathms.value = vbUnchecked
                    frmMain.ffire.Enabled = True
                    atacaequipo = False
                    frmMain.ffire.value = vbUnchecked
                    frmMain.resuteam.value = vbChecked
                    resuauto = True
                    frmMain.resuteam.Enabled = True
                    For i = 1 To maxusers
                        With UserList(i)
                            If .ConnID <> -1 Then
                                If .ConnIDValida And .Flags.UserLogged Then
                                                Call UserDieInterno(i)
                                                Call ResetFrags(i)
                                End If
                            End If
                        End With
                    Next i
                    Call SendData(SendTarget.ToAll, 0, PrepareMessagePlayWave(65, NO_3D_SOUND, NO_3D_SOUND))
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("SE DESACTIVÓ EL FUEGO ALIADO!!"))
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("SE DESACTIVÓ LA MODALIDAD DEATHMATCH!"))
                Case "FATUOS"
                    fatuos = False
                    frmMain.fatu.value = vbUnchecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Las invocaciones están DESACTIVADAS"))
                Case "FUEGOALIADO"
                If deathm = False Then
                    atacaequipo = False
                    frmMain.ffire.value = vbUnchecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("SE DESACTIVÓ EL FUEGO ALIADO!!"))
                End If
            End Select
        End If
        
        
        'If we got here then packet is complete, copy data back to original queue
        
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

''
'ReviveChar" message.
'


Private Sub HandleActivarFeature(ByVal UserIndex As Integer)
'
'
'12/29/06
'
'
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim Namex As String
        Dim tUser As Integer
        Dim loopc As Byte
        
        Namex = buffer.ReadASCIIString()
        Call .incomingData.CopyBuffer(buffer)
        
        If .admin = True Or (.dios And dioses.SuperDios) Then
            Select Case UCase(Namex)
                Case "INVI"
                    valeinvi = True
                    frmMain.invii.value = vbChecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Invisibilidad esta ACTIVADA"))
                Case "ESTU"
                    valeestu = True
                    frmMain.estuu.value = vbChecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Estupidez esta ACTIVADA"))
                Case "BOTS"
                    frmMain.Check2.value = vbChecked
                    frmMain.Frame2.Visible = frmMain.Check2.value
                    botsact = frmMain.Check2.value
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Se activaron los BOTS"))
                Case "RESU"
                    valeresu = True
                    frmMain.resuu.value = vbChecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Resucitar esta ACTIVADO"))
                Case "INMO"
                    If frmMain.inmoo.Enabled = True Then
                        inmoact = True
                        frmMain.inmoo.value = vbChecked
                        Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("INMOVILIZAR esta ACTIVADO"))
                    End If
                Case "DEATHMATCH"
                    deathm = True
                    frmMain.deathms.value = vbChecked
                    frmMain.ffire.value = vbChecked
                    frmMain.ffire.Enabled = False
                    atacaequipo = True
                    frmMain.resuteam.value = vbUnchecked
                    resuauto = False
                    frmMain.resuteam.Enabled = False
                    Dim i As Integer
                    For i = 1 To maxusers
                        With UserList(i)
                            If .ConnID <> -1 Then
                                If .ConnIDValida And .Flags.UserLogged Then
                                                Call UserDieInterno(i)
                                                Call ResetFrags(i)
                                End If
                            End If
                        End With
                    Next i
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("SE ACTIVÓ LA MODALIDAD DEATHMATCH!"))
                    Call SendData(SendTarget.ToAll, 0, PrepareMessagePlayWave(65, NO_3D_SOUND, NO_3D_SOUND))
                Case "FATUOS"
                    fatuos = True
                    frmMain.fatu.value = vbChecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Las invocaciones están ACTIVADAS"))
                Case "FUEGOALIADO"
                    atacaequipo = True
                    frmMain.ffire.value = vbChecked
                    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("¡¡CUIDADO, SE ACTIVÓ EL FUEGO ALIADO!!"))
            End Select
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub



Private Sub HandleForgive(ByVal UserIndex As Integer)

    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim tUser As Integer
        
        UserName = buffer.ReadASCIIString()
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleKick(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim tUser As Integer
        
        UserName = buffer.ReadASCIIString()
        
        If .admin = True Or .dios > dioses.centinela Then
            tUser = NameIndex(UserName)
            If tUser > 0 Then
                If UserList(tUser).dios > .dios Then
                    Call WriteConsoleMsg(UserIndex, "No podes echar a alguien con jerarquia mayor a la tuya.", FontTypeNames.FONTTYPE_INFO)
                Else
                    Call FlushBuffer(tUser)
                    Call CloseSocket(tUser)
                End If
            ElseIf tUser = UserIndex Then
                Call WriteConsoleMsg(UserIndex, "No te podés hechar vos mismo.", FontTypeNames.FONTTYPE_INFO)
            Else
                Call WriteConsoleMsg(UserIndex, "Usuario no encontrado.", FontTypeNames.FONTTYPE_INFO)
            End If
        End If
        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleBanChar(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 5 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim reason As String
        
        UserName = buffer.ReadASCIIString()
        Call buffer.ReadASCIIString
        
        
        Call BanCharacter(UserIndex, UserName)

        
        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub

Private Sub HandleSummonChar(ByVal UserIndex As Integer)

    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        Call buffer.ReadByte
        
        Dim UserName As String
        Dim tUser As Integer
        
        UserName = buffer.ReadASCIIString()
        tUser = NameIndex(UserName)
        Call .incomingData.CopyBuffer(buffer)
            If tUser > 0 And (.dios And dioses.centinela Or dioses.AdminOfis Or dioses.SuperDios) Then
                    Call WriteConsoleMsg(tUser, .name & " te há trasportado.", FontTypeNames.FONTTYPE_INFO)
                    Call WarpUserChar(tUser, .Pos.map, .Pos.X, .Pos.Y + 1, True)
            End If
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub



Private Sub HandleTeleportCreate(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 5 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        Dim Mapa As Integer
        Dim X As Byte
        Dim Y As Byte
        
        Mapa = .incomingData.ReadInteger()
        X = .incomingData.ReadByte()
        Y = .incomingData.ReadByte()
        
        If (.dios And dioses.SuperDios) Then
        Else
            Exit Sub
        End If
        If Not MapaValido(Mapa) Or Not InMapBounds(Mapa, X, Y) Then _
            Exit Sub
        
        If MapData(.Pos.map, .Pos.X, .Pos.Y - 1).ObjInfo.ObjIndex > 0 Then _
            Exit Sub
        
        If MapData(.Pos.map, .Pos.X, .Pos.Y - 1).TileExit.map > 0 Then _
            Exit Sub
        
        If MapData(Mapa, X, Y).ObjInfo.ObjIndex > 0 Then
            Call WriteConsoleMsg(UserIndex, "Hay un objeto en el piso en ese lugar", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        If MapData(Mapa, X, Y).TileExit.map > 0 Then
            Call WriteConsoleMsg(UserIndex, "No puedes crear un teleport que apunte a la entrada de otro.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        Dim ET As obj
        ET.Amount = 1
        ET.ObjIndex = 378
        
        Call MakeObj(ET, .Pos.map, .Pos.X, .Pos.Y - 1)
        
        With MapData(.Pos.map, .Pos.X, .Pos.Y - 1)
            .TileExit.map = Mapa
            .TileExit.X = X
            .TileExit.Y = Y
        End With
    End With
End Sub

''
'TeleportDestroy" message.
'


Private Sub HandleTeleportDestroy(ByVal UserIndex As Integer)
'
'
'12/29/06
'
'
    With UserList(UserIndex)
        Dim Mapa As Integer
        Dim X As Byte
        Dim Y As Byte
        
        'Remove packet ID
        Call .incomingData.ReadByte
        
        '/dt
        If (.dios And dioses.centinela Or dioses.SuperDios Or dioses.AdminOfis) Then
            Else
            Exit Sub
        End If
        Mapa = .Flags.TargetMap
        X = .Flags.TargetX
        Y = .Flags.TargetY
        
        If Not InMapBounds(Mapa, X, Y) Then Exit Sub
        
        With MapData(Mapa, X, Y)
            If .ObjInfo.ObjIndex = 0 Then Exit Sub
            
            If ObjData(.ObjInfo.ObjIndex).OBJType = eOBJType.otTeleport And .TileExit.map > 0 Then
                Call LogGM(UserList(UserIndex).name, "/DT: " & Mapa & "," & X & "," & Y)
                
                Call EraseObj(.ObjInfo.Amount, Mapa, X, Y)
                
                If MapData(.TileExit.map, .TileExit.X, .TileExit.Y).ObjInfo.ObjIndex = 651 Then
                    Call EraseObj(1, .TileExit.map, .TileExit.X, .TileExit.Y)
                End If
                
                .TileExit.map = 0
                .TileExit.X = 0
                .TileExit.Y = 0
            End If
        End With
    End With
End Sub

Private Sub HandleClima(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        If (.dios And dioses.SuperDios) Then
        Else
        Exit Sub
        End If
        Call modClima.Clima_Preset(.incomingData.ReadByte)
        Call SendData(SendTarget.ToAll, 0, PrepareMessageClimas())
    End With
End Sub

Private Sub HandleBanIP(ByVal UserIndex As Integer)
'

'05/12/08
'Agregado un CopyBuffer porque se producia un bucle
'inifito al intentar banear una ip ya baneada. (NicoNZ)
'
    If UserList(UserIndex).incomingData.Length < 6 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    With UserList(UserIndex)
        'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        Dim buffer As New clsByteQueue
        Call buffer.CopyBuffer(.incomingData)
        
        'Remove packet ID
        Call buffer.ReadByte
        
        Dim bannedip As String
        Dim tUser As Integer
        Dim reason As String
        Dim i As Long
        
        'Is it by ip??
        buffer.ReadBoolean
        BanCharacter UserIndex, buffer.ReadASCIIString()
        Call buffer.ReadASCIIString 'MaTeO ¡¡Borrar esto en el cliente!!

        'If we got here then packet is complete, copy data back to original queue
        Call .incomingData.CopyBuffer(buffer)
    End With

ErrHandler:
    Dim error As Long
    error = ERR.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If error <> 0 Then _
        ERR.Raise error
End Sub


Private Sub HandleCreateItem(ByVal UserIndex As Integer)
'
'
'12/30/06
'
'
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte

        Dim tObj As Integer
        tObj = .incomingData.ReadInteger()
        
        If .dios < 255 Then
            Exit Sub
        End If
        
        If MapData(.Pos.map, .Pos.X, .Pos.Y - 1).ObjInfo.ObjIndex > 0 Then _
            Exit Sub
        
        If MapData(.Pos.map, .Pos.X, .Pos.Y - 1).TileExit.map > 0 Then _
            Exit Sub
        
        If tObj < 1 Or tObj > NumObjDatas Then _
            Exit Sub
        
        'Is the object not null?
        If LenB(ObjData(tObj).name) = 0 Then Exit Sub
        
        Dim Objeto As obj

        Objeto.Amount = 1
        Objeto.ObjIndex = tObj
        Call MakeObj(Objeto, .Pos.map, .Pos.X, .Pos.Y - 1)
    End With
End Sub

Private Sub HandleDestroyItems(ByVal UserIndex As Integer)

    With UserList(UserIndex)
        'Remove packet ID
        Call .incomingData.ReadByte
        
        If Not (.admin = True Or (.dios And dioses.SuperDios)) Then Exit Sub
        
        If MapData(.Pos.map, .Pos.X, .Pos.Y).ObjInfo.ObjIndex = 0 Then Exit Sub
        
        Call LogGM(.name, "/DEST")
        
        If ObjData(MapData(.Pos.map, .Pos.X, .Pos.Y).ObjInfo.ObjIndex).OBJType = eOBJType.otTeleport Then
            Call WriteConsoleMsg(UserIndex, "No puede destruir teleports así. Utilice /DT.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        Call EraseObj(10000, .Pos.map, .Pos.X, .Pos.Y)
    End With
End Sub


Public Sub HandleRequestTCPStats(ByVal UserIndex As Integer)

    With UserList(UserIndex)
        'Remove Packet ID
        Call .incomingData.ReadByte
        
        If .admin = True Then Exit Sub
                
        Dim List As String
        Dim count As Long
        Dim i As Long
        

    
        Call WriteConsoleMsg(UserIndex, "Los datos están en BYTES.", FontTypeNames.FONTTYPE_INFO)
        
        'Send the stats
        With TCPESStats
            Call WriteConsoleMsg(UserIndex, "IN/s: " & .BytesRecibidosXSEG & " OUT/s: " & .BytesEnviadosXSEG, FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(UserIndex, "IN/s MAX: " & .BytesRecibidosXSEGMax & " -> " & .BytesRecibidosXSEGCuando, FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(UserIndex, "OUT/s MAX: " & .BytesEnviadosXSEGMax & " -> " & .BytesEnviadosXSEGCuando, FontTypeNames.FONTTYPE_INFO)
        End With
        
        'Search for users that are working
        For i = 1 To LastUser
            With UserList(i)
                If .Flags.UserLogged And .ConnID >= 0 And .ConnIDValida Then
                    If .outgoingData.Length > 0 Then
                        List = List & .name & " (" & CStr(.outgoingData.Length) & "), "
                        count = count + 1
                    End If
                End If
            End With
        Next i
        
        Call WriteConsoleMsg(UserIndex, "Posibles pjs trabados: " & CStr(count), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(UserIndex, List, FontTypeNames.FONTTYPE_INFO)
    End With
End Sub

Public Sub HandleRestartRound(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        'Remove Packet ID
        Call .incomingData.ReadByte
        
        'If not(.admin=true or .dios=true) Then Exit Sub
        'If UCase$(.name) <> "MARAXUS" Then Exit Sub
        If Not (.admin = True Or .dios > 63) Then Exit Sub
        Call WEBCLASS.enviarpjs
        Call restartround
        Call CargaNpcsDat
    End With
End Sub


Public Sub HandlePing(ByVal UserIndex As Integer)

    With UserList(UserIndex)
        'Remove Packet ID
        Call .incomingData.ReadByte
        Call WritePong(UserIndex)
        Call FlushBuffer(UserIndex)
    End With
End Sub

Public Sub WriteLoggedMessage(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.logged)
    Call UserList(UserIndex).outgoingData.WriteByte(UserList(UserIndex).Redundance)
    Call UserList(UserIndex).outgoingData.WriteByte(UserList(UserIndex).Ultimo1)
    Debug.Print "ENVIADO:"; UserList(UserIndex).Ultimo1
    
    #If SeguridadArduz Then
        Call UserList(UserIndex).outgoingData.WriteBoolean(True)
    #Else
        Call UserList(UserIndex).outgoingData.WriteBoolean(False)
    #End If

Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteRemoveAllDialogs(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.RemoveDialogs)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "RemoveCharDialog" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'CharIndex Character whose dialog will be removed.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteRemoveCharDialog(ByVal UserIndex As Integer, ByVal CharIndex As Integer)
'

'05/17/06
'Writes the "RemoveCharDialog" message to the given user's outgoing data buffmmmmmmmmmmmmmmmmmmmer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageRemoveCharDialog(CharIndex))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "NavigateToggle" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteNavigateToggle(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "NavigateToggle" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.NavigateToggle)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "Disconnect" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteDisconnect(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "Disconnect" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.Disconnect)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


''
'Writes the "ShowBlacksmithForm" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteElejirPJ(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "ShowBlacksmithForm" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.ShowBlacksmithForm)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "NPCSwing" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteNPCSwing(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "NPCSwing" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.NPCSwing)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "NPCKillUser" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteNPCKillUser(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "NPCKillUser" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.NPCKillUser)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "BlockedWithShieldUser" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteBlockedWithShieldUser(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "BlockedWithShieldUser" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.BlockedWithShieldUser)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "BlockedWithShieldOther" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteBlockedWithShieldOther(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "BlockedWithShieldOther" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.BlockedWithShieldOther)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UserSwing" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUserSwing(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UserSwing" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.UserSwing)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub



''
'Writes the "CantUseWhileMeditating" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteCantUseWhileMeditating(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "CantUseWhileMeditating" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.CantUseWhileMeditating)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UpdateSta" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUpdateSta(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UpdateMana" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateSta)
        Call .WriteInteger(UserList(UserIndex).Stats.MinSta)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UpdateMana" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUpdateMana(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UpdateMana" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateMana)
        Call .WriteInteger(UserList(UserIndex).Stats.MinMan)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteMensaje_Web(ByVal UserIndex As Integer, ByVal msj As Integer)
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.Mensaje_Web)
        Call .WriteInteger(msj)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Function PrepareCrearProyectil(ByVal CharIndex As Integer, ByVal toX As Byte, ByVal toY As Byte, Optional ByVal texture As Byte = 0, Optional ByVal v As Byte = 0) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.Crear_proyectil)
        Call .WriteInteger(CharIndex)
        Call .WriteByte(toX)
        Call .WriteByte(toY)
        Call .WriteByte(texture)
        Call .WriteByte(v)
        PrepareCrearProyectil = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMartillaso(ByVal CharIndex As Integer, ByVal rango As Byte) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.Martillaso)
        Call .WriteInteger(CharIndex)
        Call .WriteByte(rango)
        PrepareMartillaso = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Sub WriteMartillaso(ByVal UserIndex As Integer, ByVal id As Integer, ByVal rango As Byte)
On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMartillaso(id, rango))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub
''
'Writes the "UpdateHP" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUpdateHP(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UpdateMana" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateHP)
        Call .WriteInteger(UserList(UserIndex).Stats.MinHP)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UpdateGold" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUpdateGold(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UpdateGold" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateGold)
        Call .WriteLong(UserList(UserIndex).Stats.GLD)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UpdateExp" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUpdateExp(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "UpdateExp" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateExp)
        Call .WriteLong(UserList(UserIndex).Stats.Exp)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "ChangeMap" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'map The new map to load.
'version The version of the map in the server to check if client is properly updated.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteChangeMap(ByVal UserIndex As Integer, ByVal map As Integer, ByVal Version As Integer)
'

'05/17/06
'Writes the "ChangeMap" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.ChangeMap)
        Call .WriteInteger(map)
        Call .WriteInteger(Version)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "PosUpdate" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WritePosUpdate(ByVal UserIndex As Integer)
'

'05/17/06
'Writes the "PosUpdate" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.PosUpdate)
        Call .WriteByte(UserList(UserIndex).Pos.X)
        Call .WriteByte(UserList(UserIndex).Pos.Y)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "NPCHitUser" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'target Part of the body where the user was hitted.
'damage The number of HP lost by the hit.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteNPCHitUser(ByVal UserIndex As Integer, ByVal Target As PartesCuerpo, ByVal Damage As Integer)
'

'05/17/06
'Writes the "NPCHitUser" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.NPCHitUser)
        Call .WriteByte(Target)
        Call .WriteInteger(Damage)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

''
'Writes the "UserHitNPC" message to the given user's outgoing data buffer.
'
'UserIndex User to which the message is intended.
'damage The number of HP lost by the target creature.
'@remarks  The data is not actually sent until the buffer is properly flushed.

Public Sub WriteUserHitNPC(ByVal UserIndex As Integer, ByVal Damage As Long)
'

'05/17/06
'Writes the "UserHitNPC" message to the given user's outgoing data buffer
'
On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserHitNPC)
        
        'It is a long to allow the "drake slayer" (matadracos) to kill the great red dragon of one blow.
        Call .WriteLong(Damage)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserAttackedSwing(ByVal UserIndex As Integer, ByVal AttackerIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserAttackedSwing)
        Call .WriteInteger(UserList(AttackerIndex).Char.CharIndex)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserHittedByUser(ByVal UserIndex As Integer, ByVal Target As PartesCuerpo, ByVal attackerChar As Integer, ByVal Damage As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserHittedByUser)
        Call .WriteInteger(attackerChar)
        Call .WriteByte(Target)
        Call .WriteInteger(Damage)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserHittedUser(ByVal UserIndex As Integer, ByVal Target As PartesCuerpo, ByVal attackedChar As Integer, ByVal Damage As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserHittedUser)
        Call .WriteInteger(attackedChar)
        Call .WriteByte(Target)
        Call .WriteInteger(Damage)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteChatOverHead(ByVal UserIndex As Integer, ByVal Chat As String, ByVal CharIndex As Integer, ByVal color As Long)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageChatOverHead(Chat, CharIndex, color))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteConsoleMsg(ByVal UserIndex As Integer, ByVal Chat As String, ByVal FontIndex As FontTypeNames)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageConsoleMsg(Chat, FontIndex))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteGuildChat(ByVal UserIndex As Integer, ByVal Chat As String)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageGuildChat(Chat))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteShowMessageBox(ByVal UserIndex As Integer, ByVal message As String)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.ShowMessageBox)
        Call .WriteASCIIString(message)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserIndexInServer(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserIndexInServer)
        Call .WriteInteger(UserIndex)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserCharIndexInServer(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserCharIndexInServer)
        Call .WriteInteger(UserList(UserIndex).Char.CharIndex)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCharacterCreate(ByVal UserIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As eHeading, _
                                ByVal CharIndex As Integer, ByVal X As Byte, ByVal Y As Byte, ByVal Weapon As Integer, ByVal shield As Integer, _
                                ByVal FX As Integer, ByVal FXLoops As Integer, ByVal helmet As Integer, ByVal name As String, ByVal criminal As Byte, _
                                ByVal privileges As Byte)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCharacterCreate(Body, Head, Heading, CharIndex, X, Y, Weapon, shield, FX, FXLoops, _
                                                            helmet, name, criminal, privileges))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCharacterRemove(ByVal UserIndex As Integer, ByVal CharIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCharacterRemove(CharIndex))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCharacterMove(ByVal UserIndex As Integer, ByVal CharIndex As Integer, ByVal X As Byte, ByVal Y As Byte)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCharacterMove(CharIndex, X, Y))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCharacterChange(ByVal UserIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As eHeading, _
                                ByVal CharIndex As Integer, ByVal Weapon As Integer, ByVal shield As Integer, _
                                ByVal FX As Integer, ByVal FXLoops As Integer, ByVal helmet As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCharacterChange(Body, Head, Heading, CharIndex, Weapon, shield, FX, FXLoops, helmet))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteChangeCharProp(ByVal UserIndex As Integer, ByVal id As Integer, ByVal v As Single)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessagechangecharprop(id, v))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteObjectCreate(ByVal UserIndex As Integer, ByVal GrhIndex As Integer, ByVal X As Byte, ByVal Y As Byte)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageObjectCreate(GrhIndex, X, Y))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteObjectDelete(ByVal UserIndex As Integer, ByVal X As Byte, ByVal Y As Byte)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageObjectDelete(X, Y))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteBlockPosition(ByVal UserIndex As Integer, ByVal X As Byte, ByVal Y As Byte, ByVal Blocked As Boolean)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.BlockPosition)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        Call .WriteBoolean(Blocked)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WritePlayMidi(ByVal UserIndex As Integer, ByVal midi As Byte, Optional ByVal loops As Integer = -1)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessagePlayMidi(midi, loops))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WritePlayWave(ByVal UserIndex As Integer, ByVal wave As Byte, ByVal X As Byte, ByVal Y As Byte)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessagePlayWave(wave, X, Y))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteAreaChanged(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.AreaChanged)
        Call .WriteByte(UserList(UserIndex).Pos.X)
        Call .WriteByte(UserList(UserIndex).Pos.Y)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCCM(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.CCM)
        Call .WriteLong(connection_crc_make)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCCO(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.CCO)
        UserList(UserIndex).Redundance = (RandomNumber(0, 32) Xor 170 Xor RandomNumber(64, 128)) 'ControlCRC.CRC_Clear UserIndex
        If UserList(UserIndex).Redundance = 0 Then UserList(UserIndex).Redundance = 170
        #If SeguridadArduz Then
        UserList(UserIndex).Security.EncryptationKeyIn = UserList(UserIndex).Redundance
        #End If
        Call .WriteByte(UserList(UserIndex).Redundance)
        
        #If SeguridadArduz Then
            Call UserList(UserIndex).outgoingData.WriteByte(255)
        #Else
            Call UserList(UserIndex).outgoingData.WriteByte(0)
        #End If
        
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


Public Sub WriteTargetInvalido(ByVal UserIndex As Integer, ByVal msj As Byte)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.TargetInvalido)
        Call .WriteByte(msj)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


Public Sub WritePauseToggle(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessagePauseToggle())
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteClima(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageClimas())
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCreateFX(ByVal UserIndex As Integer, ByVal CharIndex As Integer, ByVal FX As Integer, ByVal FXLoops As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCreateFX(CharIndex, FX, FXLoops))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteCreatePGP(ByVal UserIndex As Integer, ByVal CharIndex As Integer, ByVal FX As Integer, ByVal FXLoops As Integer, Optional ByVal layer As Byte = 1)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageCreatePGP(CharIndex, FX, FXLoops, layer))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUpdateUserStats(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UpdateUserStats)
        Call .WriteInteger(UserList(UserIndex).Stats.MaxHP)
        Call .WriteInteger(UserList(UserIndex).Stats.MinHP)
        Call .WriteInteger(UserList(UserIndex).Stats.MaxMan)
        Call .WriteInteger(UserList(UserIndex).Stats.MinMan)
        Call .WriteInteger(UserList(UserIndex).Stats.MaxSta)
        Call .WriteInteger(UserList(UserIndex).Stats.MinSta)
        Call .WriteLong(UserList(UserIndex).Stats.GLD)
        Call .WriteByte(40)
        Call .WriteLong(UserList(UserIndex).Stats.ELU)
        Call .WriteLong(UserList(UserIndex).Stats.Exp)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteWorkRequestTarget(ByVal UserIndex As Integer, ByVal Skill As eSkill)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.WorkRequestTarget)
        Call .WriteByte(Skill)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteChangeInventorySlot(ByVal UserIndex As Integer, ByVal Slot As Byte)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.ChangeInventorySlot)
        Call .WriteByte(Slot)
        
        Dim ObjIndex As Integer
        Dim obData As ObjData
        
        ObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
        
        If ObjIndex > 0 Then
            obData = ObjData(ObjIndex)
        End If
        
        Call .WriteInteger(ObjIndex)
        Call .WriteASCIIString(obData.name)
        Call .WriteInteger(UserList(UserIndex).Invent.Object(Slot).Amount)
        Call .WriteBoolean(UserList(UserIndex).Invent.Object(Slot).Equipped)
        Call .WriteInteger(obData.GrhIndex)
        Call .WriteByte(obData.OBJType)
        Call .WriteInteger(obData.MaxHit)
        Call .WriteInteger(obData.MinHit)
        Call .WriteInteger(obData.def)
        Call .WriteLong(UserList(UserIndex).Invent.Object(Slot).Flags)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteChangeSpellSlot(ByVal UserIndex As Integer, ByVal Slot As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.ChangeSpellSlot)
        Call .WriteByte(Slot)
        Call .WriteInteger(UserList(UserIndex).Stats.UserHechizos(Slot))
        
        If UserList(UserIndex).Stats.UserHechizos(Slot) > 0 Then
            Call .WriteASCIIString(Hechizos(UserList(UserIndex).Stats.UserHechizos(Slot)).nombre)
        Else
            Call .WriteASCIIString("(None)")
        End If
    End With
Exit Sub

ErrHandler:
    Debug.Print "JO, ERROR"
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub



Public Sub WriteRangingMap(ByVal UserIndex As Integer)
On Error GoTo ErrHandler
Exit Sub
    Dim i As Long
    Dim validIndexes(21) As Integer
    Dim count As Integer
    Dim BBMANDAaa As String
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.CarpenterObjects)
        For i = 1 To maxusers
            'If UserList(i).ConnID <> -1 Then
                If UserList(i).ConnIDValida = True And UserList(i).Flags.UserLogged = True Then
                    
                        count = count + 1
                        validIndexes(count) = i

                End If
            'End If
        Next i
        Dim K As Integer
            BBMANDAaa = BBMANDAaa & "SCORES@"
            For K = 1 To count
                If UserList(validIndexes(K)).Flags.AdminInvisible = 0 Then
                    BBMANDAaa = BBMANDAaa & "ç" & (CStr(UserList(validIndexes(K)).nick))
                    BBMANDAaa = BBMANDAaa & "ç" & (CInt(UserList(validIndexes(K)).Bando))
                    BBMANDAaa = BBMANDAaa & "ç" & (CInt(validIndexes(K)))
                    BBMANDAaa = BBMANDAaa & "ç@"
                End If
            Next K
    End With
Exit Sub

ErrHandler:
Debug.Print "KB"
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteErrorMsg(ByVal UserIndex As Integer, ByVal message As String)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageErrorMsg(message))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


Public Sub WriteBlind(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.Blind)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteDumb(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.Dumb)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteMiniStats(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.MiniStats)
        Dim inter As New clsIntervalos
        Call .WriteLong(inter.INT_USEITEMU)
        Call .WriteLong(inter.INT_USEITEMDCK)
        Call .WriteLong(inter.INT_CAST_ATTACK)
        Call .WriteLong(inter.INT_CAST_SPELL)
        Call .WriteLong(inter.INT_ARROWS)
        Call .WriteLong(inter.INT_ATTACK)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteMoveByHead(ByVal UserIndex As Integer, ByVal skillPoints As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.LevelUp)
        Call .WriteInteger(skillPoints)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteShowForumForm(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.ShowForumForm)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteSetInvisible(ByVal UserIndex As Integer, ByVal CharIndex As Integer, ByVal invisible As Boolean)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(PrepareMessageSetInvisible(CharIndex, invisible))
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


Public Sub WriteMeditateToggle(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.MeditateToggle)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteBlindNoMore(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.BlindNoMore)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteDumbNoMore(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.DumbNoMore)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub


Public Sub WriteOfferDetails(ByVal UserIndex As Integer, ByVal details As String)

On Error GoTo ErrHandler
    Dim i As Long
    
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.OfferDetails)
        'NO USAR ASDHASDAISUDHIASUHD
        Call .WriteASCIIString(details)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteParalizeOK(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    '[MODIFICADO] Sistema de Bots de MaTeO
    'If UserList(UserIndex).flags.Paralizado = 1 Or UserList(UserIndex).flags.Inmovilizado = 1 Then
    Call AmigoRemo(UserIndex, 2)
    'End If
    '[/MODIFICADO] Sistema de Bots de MaTeO
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.ParalizeOK)
    Call UserList(UserIndex).outgoingData.WriteBoolean(CBool(UserList(UserIndex).Flags.Paralizado))
    Call WritePosUpdate(UserIndex)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteSendNight(ByVal UserIndex As Integer, ByVal night As Boolean)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.SendNight)
        Call .WriteBoolean(night)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WritePJS(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
Dim i As Byte
Dim j As Integer

    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.Cmd_Web)
        j = 1
        If UserList(UserIndex).web_pjs_count = 0 Then
            Call .WriteInteger(8)
            For i = 1 To 8
                
                Call .WriteLong(1)

                Call .WriteASCIIString(UserList(UserIndex).name)

                If Len(public_pjs(i).clan) > 1 Then
                    Call .WriteASCIIString(public_pjs(i).clan)
                Else
                    Call .WriteASCIIString("NOCLAN")
                End If
                
                Call .WriteInteger(public_pjs(i).cabeza)
                Call .WriteInteger(0)
                Call .WriteInteger(public_pjs(i).cuerpo)
                Call .WriteInteger(0)
                Call .WriteInteger(0)
                Call .WriteInteger(0)
                Call .WriteInteger(0)
                If j >= 10 Then Exit For
                j = j + 1
            Next i
        Else
            Call .WriteInteger(UserList(UserIndex).web_pjs_count)
            For i = 1 To UserList(UserIndex).web_pjs_count
                'Debug.Print "JOJO"; i
                Call .WriteLong(UserList(UserIndex).web_pjs(i).id)
                
                If Len(UserList(UserIndex).web_pjs(i).name) > 1 Then
                    Call .WriteASCIIString(UserList(UserIndex).web_pjs(i).name)
                Else
                    Call .WriteASCIIString("NONICK")
                End If
                If Len(UserList(UserIndex).web_pjs(i).clan) > 1 Then
                    Call .WriteASCIIString(UserList(UserIndex).web_pjs(i).clan)
                Else
                    Call .WriteASCIIString("NOCLAN")
                End If
                
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).cabeza)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).casco)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).cuerpo)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).Escudo)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).Arma)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).raza)
                Call .WriteInteger(UserList(UserIndex).web_pjs(i).Faccion)
                j = j + 1
            Next i
        End If
    End With
    Call FlushBuffer(UserIndex)

Exit Sub

ErrHandler:
    Debug.Print "EEEEEERRRRRRRRROOOOOOOOOORRRRRRRRRRR!!!!!"
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WriteUserNameList(ByVal UserIndex As Integer, ByRef userNamesList() As String, ByVal Cant As Integer)

On Error GoTo ErrHandler
    Dim i As Long
    Dim tmp As String
    
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.UserNameList)
        
        'Prepare user's names list
        For i = 1 To Cant
            tmp = tmp & userNamesList(i) & SEPARATOR
        Next i
        
        If Len(tmp) Then _
            tmp = Left$(tmp, Len(tmp) - 1)
        
        Call .WriteASCIIString(tmp)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub WritePong(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    Call UserList(UserIndex).outgoingData.WriteByte(ServerPacketID.Pong)
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub

Public Sub FlushBuffer(ByVal UserIndex As Integer)

    Dim sndData As String
    If Not (UserList(UserIndex).outgoingData Is Nothing) Then
    With UserList(UserIndex).outgoingData
        If UserList(UserIndex).outgoingData.Length = 0 Then _
            Exit Sub
        
        sndData = .ReadASCIIStringFixed(.Length)
        TCPESStats.BytesEnviados = TCPESStats.BytesEnviados + Len(sndData)
        Call EnviarDatosASlot(UserIndex, sndData)
    End With
    End If


End Sub


Public Function PrepareMessageSetInvisible(ByVal CharIndex As Integer, ByVal invisible As Boolean) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.SetInvisible)
        
        Call .WriteInteger(CharIndex)
        Call .WriteBoolean(invisible)
        
        PrepareMessageSetInvisible = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageChatOverHead(ByVal Chat As String, ByVal CharIndex As Integer, ByVal color As Long) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ChatOverHead)
        Call .WriteASCIIString(Chat)
        Call .WriteInteger(CharIndex)
        
        'Write rgb channels and save one byte from long :D
        Call .WriteByte(color And &HFF)
        Call .WriteByte((color And &HFF00&) \ &H100&)
        Call .WriteByte((color And &HFF0000) \ &H10000)
        
        PrepareMessageChatOverHead = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageConsoleMsg(ByVal Chat As String, ByVal FontIndex As FontTypeNames) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ConsoleMsg)
        Call .WriteASCIIString(Chat)
        Call .WriteByte(FontIndex)
        
        PrepareMessageConsoleMsg = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCreateFX(ByVal CharIndex As Integer, ByVal FX As Integer, ByVal FXLoops As Integer) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CreateFX)
        Call .WriteInteger(CharIndex)
        Call .WriteInteger(FX)
        Call .WriteInteger(FXLoops)
        
        PrepareMessageCreateFX = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCreatePGP(ByVal CharIndex As Integer, ByVal FX As Integer, ByVal FXLoops As Integer, Optional ByVal layer As Byte = 1) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CreatePGP)
        Call .WriteInteger(CharIndex)
        Call .WriteInteger(FX)
        Call .WriteInteger(FXLoops)
        Call .WriteByte(layer)
        
        PrepareMessageCreatePGP = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCreateHIT(ByVal CharIndex As Integer, ByVal hit As Integer, ByVal color As Long) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.OfferDetails)
        Call .WriteInteger(CharIndex)
        Call .WriteInteger(hit)
        Call .WriteLong(color)
        PrepareMessageCreateHIT = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageAnim_Attack(ByVal CharIndex As Integer) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.Anim_Attack)
        Call .WriteInteger(CharIndex)
        PrepareMessageAnim_Attack = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessagePlayWave(ByVal wave As Byte, ByVal X As Byte, ByVal Y As Byte) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.PlayWave)
        Call .WriteByte(wave)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        
        PrepareMessagePlayWave = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageGuildChat(ByVal Chat As String) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.GuildChat)
        Call .WriteASCIIString(Chat)
        
        PrepareMessageGuildChat = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageShowMessageBox(ByVal Chat As String) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ShowMessageBox)
        Call .WriteASCIIString(Chat)
        
        PrepareMessageShowMessageBox = .ReadASCIIStringFixed(.Length)
    End With
End Function


Public Function PrepareMessagePlayMidi(ByVal midi As Byte, Optional ByVal loops As Integer = -1) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.PlayMIDI)
        Call .WriteByte(midi)
        Call .WriteInteger(loops)
        
        PrepareMessagePlayMidi = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessagechangecharprop(ByVal id As Integer, ByVal velocidad As Single) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.change_char_prop)
        Call .WriteInteger(id)
        Call .WriteByte(velocidad)
        PrepareMessagechangecharprop = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessagePauseToggle() As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.PauseToggle)
        PrepareMessagePauseToggle = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageClimas() As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.RainToggle)
        Call .WriteByte(modClima.act_clima)
        PrepareMessageClimas = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageObjectDelete(ByVal X As Byte, ByVal Y As Byte) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ObjectDelete)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        
        PrepareMessageObjectDelete = .ReadASCIIStringFixed(.Length)
    End With
End Function


Public Function PrepareMessageBlockPosition(ByVal X As Byte, ByVal Y As Byte, ByVal Blocked As Boolean) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.BlockPosition)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        Call .WriteBoolean(Blocked)
        
        PrepareMessageBlockPosition = .ReadASCIIStringFixed(.Length)
    End With
    
End Function

Public Function PrepareMessageObjectCreate(ByVal GrhIndex As Integer, ByVal X As Byte, ByVal Y As Byte) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ObjectCreate)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        Call .WriteInteger(GrhIndex)
        
        PrepareMessageObjectCreate = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCharacterRemove(ByVal CharIndex As Integer) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CharacterRemove)
        Call .WriteInteger(CharIndex)
        
        PrepareMessageCharacterRemove = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageRemoveCharDialog(ByVal CharIndex As Integer) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.RemoveCharDialog)
        Call .WriteInteger(CharIndex)
        
        PrepareMessageRemoveCharDialog = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCharacterCreate(ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As eHeading, _
                                ByVal CharIndex As Integer, ByVal X As Byte, ByVal Y As Byte, ByVal Weapon As Integer, ByVal shield As Integer, _
                                ByVal FX As Integer, ByVal FXLoops As Integer, ByVal helmet As Integer, ByVal name As String, ByVal criminal As Byte, _
                                ByVal privileges As Byte) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CharacterCreate)
        
        Call .WriteInteger(CharIndex)
        Call .WriteInteger(Body)
        Call .WriteInteger(Head)
        Call .WriteByte(Heading)
        Call .WriteByte(X)
        Call .WriteByte(Y)
        Call .WriteInteger(Weapon)
        Call .WriteInteger(shield)
        Call .WriteInteger(helmet)
        Call .WriteInteger(FX)
        Call .WriteInteger(FXLoops)
        Call .WriteASCIIString(name)
        Call .WriteByte(criminal)
        Call .WriteByte(privileges)
        
        PrepareMessageCharacterCreate = .ReadASCIIStringFixed(.Length)
    End With
End Function


Public Function PrepareMessageCharacterChange(ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As eHeading, _
                                ByVal CharIndex As Integer, ByVal Weapon As Integer, ByVal shield As Integer, _
                                ByVal FX As Integer, ByVal FXLoops As Integer, ByVal helmet As Integer) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CharacterChange)
        
        Call .WriteInteger(CharIndex)
        Call .WriteInteger(Body)
        Call .WriteInteger(Head)
        Call .WriteByte(Heading)
        Call .WriteInteger(Weapon)
        Call .WriteInteger(shield)
        Call .WriteInteger(helmet)
        Call .WriteInteger(FX)
        Call .WriteInteger(FXLoops)
        
        PrepareMessageCharacterChange = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageCharacterMove(ByVal CharIndex As Integer, ByVal X As Byte, ByVal Y As Byte) As String

    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.CharacterMove)
        Call .WriteInteger(CharIndex)
        Call .WriteByte(X)
        Call .WriteByte(Y)

        PrepareMessageCharacterMove = .ReadASCIIStringFixed(.Length)
    End With
End Function


Public Function PrepareMessageUpdateTagAndStatus(ByVal UserIndex As Integer, isCriminal As Boolean, Tag As String) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.UpdateTagAndStatus)
        
        Call .WriteInteger(UserList(UserIndex).Char.CharIndex)
        Call .WriteBoolean(isCriminal)
        Call .WriteASCIIString(Tag)
        
        PrepareMessageUpdateTagAndStatus = .ReadASCIIStringFixed(.Length)
    End With
End Function

Public Function PrepareMessageErrorMsg(ByVal message As String) As String
    With auxiliarBuffer
        Call .WriteByte(ServerPacketID.ErrorMsg)
        Call .WriteASCIIString(message)
        
        PrepareMessageErrorMsg = .ReadASCIIStringFixed(.Length)
    End With
End Function

Private Sub HandleCambiarMapa(ByVal UserIndex As Integer)
    If UserList(UserIndex).incomingData.Length < 3 Then
        Call ERR.Raise(UserList(UserIndex).incomingData.NotEnoughDataErrCode)
        Exit Sub
    End If
    
    With UserList(UserIndex)
        'Remove Packet ID
        Call .incomingData.ReadByte
        
        Dim map As Integer
        map = .incomingData.ReadInteger()
        If .dios > dioses.centinela Then
        Else
        If .admin = False Then Exit Sub
        End If
        If map <= NumMaps Then
            servermap = map

            frmMain.mapax.ListIndex = map - 1
            Call cambiarmapa
        End If
    End With
End Sub

Public Sub WriteInvEQUIPED(ByVal UserIndex As Integer)

On Error GoTo ErrHandler
    With UserList(UserIndex).outgoingData
        Call .WriteByte(ServerPacketID.InvEQUIPED)
        Call .WriteByte(UserList(UserIndex).Invent.CascoEqpSlot)
        Call .WriteByte(UserList(UserIndex).Invent.ArmourEqpSlot)
        Call .WriteByte(UserList(UserIndex).Invent.AnilloEqpSlot)
        Call .WriteByte(UserList(UserIndex).Invent.WeaponEqpSlot)
        Call .WriteByte(UserList(UserIndex).Invent.EscudoEqpSlot)
        Call .WriteByte(UserList(UserIndex).Invent.MunicionEqpSlot)
    End With
Exit Sub

ErrHandler:
    If ERR.number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub
