Attribute VB_Name = "Protocol"
'**************************************************************
' Protocol.bas - Handles all incoming / outgoing messages for client-server communications.
' Uses a binary protocol designed by myself.
'
' Designed and implemented by Juan Martín Sotuyo Dodero (Maraxus)
' (juansotuyo@gmail.com)
'**************************************************************

'**************************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

''
'Handles all incoming / outgoing packets for client - server communications
'The binary prtocol here used was designed by Juan Martín Sotuyo Dodero.
'This is the first time it's used in Alkon, though the second time it's coded.
'This implementation has several enhacements from the first design.
'
' @file     Protocol.bas
' @author   Juan Martín Sotuyo Dodero (Maraxus) juansotuyo@gmail.com
' @version  1.0.0
' @date     20060517

Option Explicit

''
' TODO : /BANIP y /UNBANIP ya no trabajan con nicks. Esto lo puede mentir en forma local el cliente con un paquete a NickToIp

''
'When we have a list of strings, we use this to separate them and prevent
'having too many string lengths in the queue. Yes, each string is NULL-terminated :P
Private Const SEPARATOR As String * 1 = vbNullChar

Private Type tFont
    red As Byte
    green As Byte
    blue As Byte
    bold As Boolean
    italic As Boolean
End Type

Private Enum ServerPacketID
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
    clima                   'va
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
    CCM
    CCO
    TargetInvalido
    InvEQUIPED
End Enum

Private Enum ClientPacketID
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
    Ping                    'PING
    WarpMeToTarget          'va
    WarpChar                'warp
    GoToChar                '/ira
    invisible               '*
    RequestUserList         'Espacio || tab
    EditChar                'Elegir PJ
    RequestCharSkills       'va /desact
    ReviveChar              'va /act
    Kick                    '/echar
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
    
    NuevoBalance
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

Public FontTypes(18) As tFont
Public actual_packet As Byte

Private CRClast As Byte

Public hechizo_cargado As Byte

Public aim_pj As Integer

Private SS_sync As Long
Private SS_last As Byte
Public SS_mov As Long
Public Redundance As Byte

Public antoloop As Long


Public Sub InitFonts()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    With FontTypes(FontTypeNames.FONTTYPE_TALK)
        .red = 255
        .green = 255
        .blue = 255
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_FIGHT)
        .red = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_WARNING)
        .red = 32
        .green = 51
        .blue = 223
        .bold = 1
        .italic = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_INFO)
        .red = 65
        .green = 190
        .blue = 156
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_INFOBOLD)
        .red = 65
        .green = 190
        .blue = 156
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_EJECUCION)
        .red = 130
        .green = 130
        .blue = 130
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_PARTY)
        .red = 255
        .green = 180
        .blue = 250
    End With
    
    FontTypes(FontTypeNames.FONTTYPE_VENENO).green = 255
    
    With FontTypes(FontTypeNames.FONTTYPE_GUILD)
        .red = 255
        .green = 255
        .blue = 255
        .bold = 1
    End With
    
    FontTypes(FontTypeNames.FONTTYPE_SERVER).green = 185
    
    With FontTypes(FontTypeNames.FONTTYPE_GUILDMSG)
        .red = 228
        .green = 199
        .blue = 27
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJO)
        .red = 130
        .green = 130
        .blue = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOCAOS)
        .red = 255
        .green = 60
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOVesA)
        .green = 200
        .blue = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOCAOSVesA)
        .red = 255
        .green = 50
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CENTINELA)
        .green = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_GMMSG)
        .red = 255
        .green = 255
        .blue = 255
        .italic = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_GM)
        .green = 185
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CITIZEN)
        .blue = 200
        .bold = 1
    End With
End Sub

''
' Handles incoming data.

Public Sub HandleIncomingData()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
On Error Resume Next
actual_packet = incomingData.PeekByte()
    Select Case actual_packet
        Case ServerPacketID.logged                  ' LOGGED
            Call HandleLogged
        Case ServerPacketID.ShowBlacksmithForm
            Call HandleShowBlacksmithForm
        Case ServerPacketID.RemoveDialogs           ' QTDL
            Call HandleRemoveDialogs
        
        Case ServerPacketID.RemoveCharDialog        ' QDL
            Call HandleRemoveCharDialog
        
        Case ServerPacketID.NavigateToggle          ' NAVEG
            Call HandleNavigateToggle
        
        Case ServerPacketID.Disconnect              ' FINOK
            Call HandleDisconnect
        
        Case ServerPacketID.NPCSwing                ' N1
            Call HandleNPCSwing
        
        Case ServerPacketID.NPCKillUser             ' 6
            Call HandleNPCKillUser
        
        Case ServerPacketID.BlockedWithShieldUser   ' 7
            Call HandleBlockedWithShieldUser
        
        Case ServerPacketID.BlockedWithShieldOther  ' 8
            Call HandleBlockedWithShieldOther
        
        Case ServerPacketID.UserSwing               ' U1
            Call HandleUserSwing

        Case ServerPacketID.CantUseWhileMeditating  ' M!
            Call HandleCantUseWhileMeditating
        
        Case ServerPacketID.UpdateSta               ' ASS
            Call HandleUpdateSta
        
        Case ServerPacketID.UpdateMana              ' ASM
            Call HandleUpdateMana
        
        Case ServerPacketID.UpdateHP                ' ASH
            Call HandleUpdateHP
        
        Case ServerPacketID.UpdateGold              ' ASG
            Call HandleUpdateGold
        
        Case ServerPacketID.UpdateExp               ' ASE
            Call HandleUpdateExp
        
        Case ServerPacketID.ChangeMap               ' CM
            Call HandleChangeMap
        
        Case ServerPacketID.PosUpdate               ' PU
            Call HandlePosUpdate
        
        Case ServerPacketID.NPCHitUser              ' N2
            Call HandleNPCHitUser
        
        Case ServerPacketID.UserHitNPC              ' U2
            Call HandleUserHitNPC
        
        Case ServerPacketID.UserAttackedSwing       ' U3
            Call HandleUserAttackedSwing
        
        Case ServerPacketID.UserHittedByUser        ' N4
            Call HandleUserHittedByUser
        
        Case ServerPacketID.UserHittedUser          ' N5
            Call HandleUserHittedUser
        
        Case ServerPacketID.ChatOverHead            ' ||
            Call HandleChatOverHead
        
        Case ServerPacketID.ConsoleMsg              ' || - Beware!! its the same as above, but it was properly splitted
            Call HandleConsoleMessage
        
        Case ServerPacketID.GuildChat               ' |+
            Call HandleGuildChat
        
        Case ServerPacketID.ShowMessageBox          ' !!
            Call HandleShowMessageBox
        
        Case ServerPacketID.UserIndexInServer       ' IU
            Call HandleUserIndexInServer
        
        Case ServerPacketID.UserCharIndexInServer   ' IP
            Call HandleUserCharIndexInServer
        
        Case ServerPacketID.CharacterCreate         ' CC
            Call HandleCharacterCreate
        
        Case ServerPacketID.CharacterRemove         ' BP
            Call HandleCharacterRemove
        
        Case ServerPacketID.CharacterMove           ' MP, +, * and _ '
            Call HandleCharacterMove
        
        Case ServerPacketID.CharacterChange         ' CP
            Call HandleCharacterChange
        
        Case ServerPacketID.ObjectCreate            ' HO
            Call HandleObjectCreate
        
        Case ServerPacketID.ObjectDelete            ' BO
            Call HandleObjectDelete
        
        Case ServerPacketID.BlockPosition           ' BQ
            Call HandleBlockPosition
        
        Case ServerPacketID.PlayMIDI                ' TM
            Call HandlePlayMIDI
        
        Case ServerPacketID.PlayWave                ' TW
            Call HandlePlayWave
        

        Case ServerPacketID.AreaChanged             ' CA
            Call HandleAreaChanged
        
        Case ServerPacketID.PauseToggle             ' BKW
            Call HandlePauseToggle
        
        Case ServerPacketID.clima              ' LLU
            Call HandleClima
        
        Case ServerPacketID.CreateFX                ' CFX
            Call HandleCreateFX
        
        Case ServerPacketID.UpdateUserStats         ' EST
            Call HandleUpdateUserStats
        
        Case ServerPacketID.WorkRequestTarget       ' T01
            Call HandleWorkRequestTarget
        
        Case ServerPacketID.ChangeInventorySlot     ' CSI
            Call HandleChangeInventorySlot
        
        Case ServerPacketID.ChangeSpellSlot         ' SHS
            Call HandleChangeSpellSlot
        
        Case ServerPacketID.CarpenterObjects        ' OBR
            Call HandleCarpenterObjects
        
        Case ServerPacketID.ErrorMsg                ' ERR
            Call HandleErrorMessage
        
        Case ServerPacketID.Blind                   ' CEGU
            Call HandleBlind
        
        Case ServerPacketID.Dumb                    ' DUMB
            Call HandleDumb
            
        Case ServerPacketID.MiniStats               ' MEST
            Call HandleMiniStats
        
        Case ServerPacketID.LevelUp                 ' SUNI
            Call HandleMoveScreen
        
        Case ServerPacketID.SetInvisible            ' NOVER
            Call HandleSetInvisible

        Case ServerPacketID.MeditateToggle          ' MEDOK
            Call HandleMeditateToggle
        
        Case ServerPacketID.BlindNoMore             ' NSEGUE
            Call HandleBlindNoMore
        
        Case ServerPacketID.DumbNoMore              ' NESTUP
            Call HandleDumbNoMore
        
        Case ServerPacketID.OfferDetails            'HITS
            Call HandleCreateHIT
        
        Case ServerPacketID.ParalizeOK              ' PARADOK
            Call HandleParalizeOK

        
        Case ServerPacketID.SendNight               ' NOC
            Call HandleSendNight
        
        Case ServerPacketID.Pong
            Call HandlePong
        
        Case ServerPacketID.UpdateTagAndStatus
            Call HandleUpdateTagAndStatus

        Case ServerPacketID.UserNameList            ' LISTUSU
            Call HandleUserNameList
            
        Case ServerPacketID.Mensaje_Web
            Call HandleMensaje_Web
            
        Case ServerPacketID.Cmd_Web
            Call HandlePJS
            
        Case ServerPacketID.Crear_proyectil
            Call HandleCrearProyectil
            
        Case ServerPacketID.Anim_Attack
            Call HandleAnim_Attack
            
        Case ServerPacketID.change_char_prop
            Call HandleCCP
            
        Case ServerPacketID.Martillaso
            Call HandleMartillaso
            
        Case ServerPacketID.CreatePGP
            Call HandleCreatePGP
        Case ServerPacketID.CCM
            Call HandleCCM
        Case ServerPacketID.CCO
            Call HandleCCO
            
        Case ServerPacketID.TargetInvalido
            Call HandleTargetInvalido
            
        Case ServerPacketID.InvEQUIPED
            Call HandleInvEQUIPED
        Case Else
            'ERROR : Abort!
            LogError actual_packet & " es un paquete desconocido"
            incomingData.ReadASCIIStringFixed incomingData.Length
            antoloop = 0
            Exit Sub
    End Select
    
    If Err.number = incomingData.NotEnoughDataErrCode Or Err.number = incomingData.NotEnoughSpaceErrCode Then
        LogError actual_packet & " NO Enough DATA [" & incomingData.PeekASCIIStringFixed(incomingData.Length) & "]"
        antoloop = antoloop + 1
        If antoloop > 32 Then
            send_error "NO Enough DTA: [" & incomingData.getbarray & "]"
            incomingData.ReadASCIIStringFixed incomingData.Length
            antoloop = 0
        End If
    End If
    'Done with this packet, move on to next one
    If incomingData.Length > 0 And Err.number <> incomingData.NotEnoughDataErrCode Then
        Err.Clear
        Call HandleIncomingData
    End If
End Sub

Private Sub HandleMiniStats()
    If incomingData.Length < 20 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    With secIntervalos
        magicNumber = RandomNumber(3, 6)
        .INT_USEITEMU = (incomingData.ReadLong() * magicNumber)
        .INT_USEITEMDCK = (incomingData.ReadLong() * magicNumber)
        .INT_CAST_ATTACK = (incomingData.ReadLong() * magicNumber)
        .INT_CAST_SPELL = (incomingData.ReadLong() * magicNumber)
        .INT_ARROWS = (incomingData.ReadLong() * magicNumber)
        .INT_ATTACK = (incomingData.ReadLong() * magicNumber)
        
        INT_USEITEMU = .INT_USEITEMU
        INT_USEITEMDCK = .INT_USEITEMDCK
        INT_CAST_ATTACK = .INT_CAST_ATTACK
        INT_CAST_SPELL = .INT_CAST_SPELL
        INT_ARROWS = .INT_ARROWS
        INT_ATTACK = .INT_ATTACK

        Call MainTimer.SetInterval(TimersIndex.Attack, INT_ATTACK)
        Call MainTimer.SetInterval(TimersIndex.UseItemWithU, .INT_USEITEMU)
        Call MainTimer.SetInterval(TimersIndex.UseItemWithDblClick, INT_USEITEMDCK)
        Call MainTimer.SetInterval(TimersIndex.CastSpell, INT_CAST_SPELL)
        Call MainTimer.SetInterval(TimersIndex.Arrows, INT_ARROWS)
        Call MainTimer.SetInterval(TimersIndex.CastAttack, .INT_CAST_ATTACK)
    End With
    
End Sub

''
' Handles the Logged message.

Private Sub HandleLogged()
    Call incomingData.ReadByte

    Redundance = incomingData.ReadByte()
    CRClast = incomingData.ReadByte()
    outgoingData.CRCChar = CRClast
    Debug.Print "RECIBIDO:"; CRClast
    
    incomingData.ReadBoolean
    
    UserCiego = False
    EngineRun = True
    IScombate = False
    Engine_UI.rank_visible = False
    Engine_UI.rank_visible = True
    UserDescansar = False
    Nombres = True
    clear_map_chars
    Call SetConnected
End Sub

''
' Handles the RemoveDialogs message.

Private Sub HandleRemoveDialogs()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call Dialogos.RemoveAllDialogs
End Sub

''
' Handles the RemoveCharDialog message.

Private Sub HandleRemoveCharDialog()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Check if the packet is complete
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call Dialogos.RemoveDialog(incomingData.ReadInteger())
End Sub

''
' Handles the NavigateToggle message.

Private Sub HandleNavigateToggle()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserNavegando = Not UserNavegando
End Sub

''
' Handles the Disconnect message.

Private Sub HandleDisconnect()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    
    
    'Remove packet ID
    Call incomingData.ReadByte
    
closex
End Sub

Sub closex()
Dim i As Long
    'Close connection
#If UsarWrench = 1 Then
    frmMain.Socket1.Disconnect
#Else
    If frmMain.Winsock1.State <> sckClosed Then _
        frmMain.Winsock1.Close
#End If
    
    'Hide main form
    frmMain.Visible = False
    play_intro
    renderasd = False
    Call SetMusicInfo("Jugando Arduz AO - http://www.arduz.com.ar/", "", "", "Games", , "{0}")
    'Stop audio
    Call Audio.Sound_Stop_All
    frmMain.IsPlaying = PlayLoop.plNone
    
    'Show connection form
    frmConnect.Visible = True
    
    'Reset global vars
    UserParalizado = False
    IScombate = False
    Engine_UI.rank_visible = False
    pausa = False
    UserMeditar = False
    UserDescansar = False
    UserNavegando = False
    bRain = False
    bFogata = False
    SkillPoints = 0
    
    'Delete all kind of dialogs
    Call CleanDialogs
    
    'Reset some char variables...
    For i = 1 To LastChar
        charlist(i).invisible = False
    Next i
    
    'Unload all forms except frmMain and frmConnect
    Dim frm As Form
    
    For Each frm In Forms
        If frm.name <> frmMain.name And frm.name <> frmConnect.name Then
            Unload frm
        End If
    Next
    Call frmConnect.refresha
End Sub




''
' Handles the ShowBlacksmithForm message.

Private Sub HandleShowBlacksmithForm()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    Call frmMain.pasarme
End Sub



''
' Handles the NPCSwing message.

Private Sub HandleNPCSwing()
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_CRIATURA_FALLA_GOLPE, 255, 0, 0, True, False, False)
End Sub

''
' Handles the NPCKillUser message.

Private Sub HandleNPCKillUser()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_CRIATURA_MATADO, 255, 0, 0, True, False, False)
End Sub

''
' Handles the BlockedWithShieldUser message.

Private Sub HandleBlockedWithShieldUser()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_RECHAZO_ATAQUE_ESCUDO, 255, 0, 0, True, False, False)
End Sub

''
' Handles the BlockedWithShieldOther message.

Private Sub HandleBlockedWithShieldOther()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_USUARIO_RECHAZO_ATAQUE_ESCUDO, 255, 0, 0, True, False, False)
End Sub

''
' Handles the UserSwing message.

Private Sub HandleUserSwing()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_FALLADO_GOLPE, 255, 0, 0, True, False, False)
End Sub

''
' Handles the CantUseWhileMeditating message.

Private Sub HandleCantUseWhileMeditating()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_USAR_MEDITANDO, 255, 0, 0, False, False, False)
End Sub

''
' Handles the UpdateSta message.

Private Sub HandleUpdateSta()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Check packet is complete
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Get data and update form
    UserMinSTA = incomingData.ReadInteger()
    frmMain.STAShp.Width = ((UserMinSTA / UserMaxSTA) * 94)
End Sub

''
' Handles the UpdateMana message.

Private Sub HandleUpdateMana()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Check packet is complete
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Get data and update form
    UserMinMAN = incomingData.ReadInteger()
    
    If UserMaxMAN > 0 Then
        frmMain.mans.max = UserMaxMAN
        frmMain.mans.Value = UserMinMAN
        frmMain.mans.Caption = UserMinMAN & "/" & UserMaxMAN
    Else
    End If
End Sub

''
' Handles the UpdateHP message.

Private Sub HandleUpdateHP()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Check packet is complete
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Get data and update form
    UserMinHP = incomingData.ReadInteger()
    frmMain.vids.max = UserMaxHP
    frmMain.vids.Value = UserMinHP
    frmMain.vids.Caption = UserMinHP & "/" & UserMaxHP
    'Is the user alive??
    If UserMinHP = 0 Then
        UserEstado = 1
    Else
        UserEstado = 0
    End If
End Sub

Private Sub HandlePJS()
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    Dim i As Byte, t%, a%, b%, c%, d%, e%
    Call incomingData.ReadByte
    web_pjs_count = incomingData.ReadInteger()
    For i = 1 To web_pjs_count
        With web_pjs(i Mod 11)
            .ID = incomingData.ReadLong()
            .name = incomingData.ReadASCIIString()
            .clan = incomingData.ReadASCIIString()
            d = incomingData.ReadInteger
            c = incomingData.ReadInteger
            b = incomingData.ReadInteger
            e = incomingData.ReadInteger
            a = incomingData.ReadInteger
            
            .raza = incomingData.ReadInteger()
            .Faccion = incomingData.ReadInteger()
            
            MakeAccPJ i, b, d, a, e, c
        End With
    Next i
End Sub

Private Sub HandleUpdateGold()
'***************************************************
'Autor: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 08/14/07
'Last Modified By: Lucas Tavolaro Ortiz (Tavo)
'- 08/14/07: Added GldLbl color variation depending on User Gold and Level
'***************************************************
    'Check packet is complete
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Get data and update form
    UserGLD = incomingData.ReadLong()
    
    If UserGLD >= CLng(UserLvl) * 10000 Then
        'Changes color
        frmMain.GldLbl.ForeColor = &HFF& 'Red
    Else
        'Changes color
        frmMain.GldLbl.ForeColor = &HFFFF& 'Yellow
    End If
    
    frmMain.GldLbl.Caption = UserGLD
End Sub

''
' Handles the UpdateExp message.

Private Sub HandleUpdateExp()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Check packet is complete
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Get data and update form
    UserExp = incomingData.ReadLong()
    frmMain.exp.Caption = "Exp: " & UserExp & "/" & UserPasarNivel
    frmMain.lblPorcLvl.Caption = "[" & Round(CDbl(UserExp) * CDbl(100) / CDbl(UserPasarNivel), 2) & "%]"
End Sub

''
' Handles the ChangeMap message.

Private Sub HandleChangeMap()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserMap = incomingData.ReadInteger()
    
'TODO: Once on-the-fly editor is implemented check for map version before loading....
'For now we just drop it
    Call incomingData.ReadInteger
        
#If SeguridadAlkon Then
    Call InitMI
#End If
    Call SwitchMap(UserMap)
    Exit Sub
    If FileExist(DirMapas & "Mapa" & UserMap & ".map", vbNormal) Then
'        If bLluvia(UserMap) = 0 Then
'            If bRain Then
'                Call Audio.Sound_Stop(RainBufferIndex)
'                RainBufferIndex = 0
'                frmMain.IsPlaying = PlayLoop.plNone
'            End If
'        End If
    Else
        'no encontramos el mapa en el hd
        MsgBox "Error en los mapas, algún archivo ha sido modificado o esta dañado."
        
        Call CloseClient
    End If
End Sub

''
' Handles the PosUpdate message.

Private Sub HandlePosUpdate()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    Dim x As Byte, y As Byte
    'Remove packet ID
    Call incomingData.ReadByte
    
    'Set new pos
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    
    If charmap(UserPos.x, UserPos.y) = UserCharIndex Then
        charmap(UserPos.x, UserPos.y) = 0
    End If
    
    UserPos.x = x
    UserPos.y = y
    charmap(UserPos.x, UserPos.y) = UserCharIndex
    charlist(UserCharIndex).Pos.x = UserPos.x
    charlist(UserCharIndex).Pos.y = UserPos.y
    'Are we under a roof?
    bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
            MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
            MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
                
    'Update pos label
    frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
End Sub

''
' Handles the NPCHitUser message.

Private Sub HandleNPCHitUser()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Select Case incomingData.ReadByte()
        Case bCabeza
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_CABEZA & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
        Case bBrazoIzquierdo
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_BRAZO_IZQ & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
        Case bBrazoDerecho
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_BRAZO_DER & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
        Case bPiernaIzquierda
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_PIERNA_IZQ & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
        Case bPiernaDerecha
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_PIERNA_DER & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
        Case bTorso
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_TORSO & CStr(incomingData.ReadInteger()), 255, 0, 0, True, False, False)
    End Select
End Sub

''
' Handles the UserHitNPC message.

Private Sub HandleUserHitNPC()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_CRIATURA_1 & CStr(incomingData.ReadLong()) & MENSAJE_2, 255, 0, 0, True, False, False)
End Sub

''
' Handles the UserAttackedSwing message.

Private Sub HandleUserAttackedSwing()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & charlist(incomingData.ReadInteger()).Nombre & MENSAJE_ATAQUE_FALLO, 255, 0, 0, True, False, False)
End Sub

''
' Handles the UserHittingByUser message.

Private Sub HandleUserHittedByUser()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 6 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim attacker As String
    
    attacker = charlist(incomingData.ReadInteger()).Nombre
    
    Select Case incomingData.ReadByte
        Case bCabeza
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_CABEZA & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bBrazoIzquierdo
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_BRAZO_IZQ & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bBrazoDerecho
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_BRAZO_DER & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bPiernaIzquierda
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_PIERNA_IZQ & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bPiernaDerecha
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_PIERNA_DER & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bTorso
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_TORSO & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
    End Select
End Sub

''
' Handles the UserHittedUser message.

Private Sub HandleUserHittedUser()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 6 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim victim As String
    
    victim = charlist(incomingData.ReadInteger()).Nombre
    
    Select Case incomingData.ReadByte
        Case bCabeza
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_CABEZA & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bBrazoIzquierdo
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_BRAZO_IZQ & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bBrazoDerecho
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_BRAZO_DER & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bPiernaIzquierda
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_PIERNA_IZQ & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bPiernaDerecha
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_PIERNA_DER & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
        Case bTorso
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_TORSO & CStr(incomingData.ReadInteger() & MENSAJE_2), 255, 0, 0, True, False, False)
    End Select
End Sub

''
' Handles the ChatOverHead message.

Private Sub HandleChatOverHead()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 8 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim chat As String
    Dim CharIndex As Integer
    Dim r As Byte
    Dim G As Byte
    Dim matar As Boolean
    Dim b As Byte
    
    chat = buffer.ReadASCIIString()
    CharIndex = buffer.ReadInteger()
    
    r = buffer.ReadByte()
    G = buffer.ReadByte()
    b = buffer.ReadByte()
    Call incomingData.CopyBuffer(buffer)
    If RGB(r, G, b) = vbCyan Then matar = True
    'Only add the chat if the character exists (a CharacterRemove may have been sent to the PC / NPC area before the buffer was flushed)
    If charlist(CharIndex).active Then _
        Call Dialogos.CreateDialog(chat, CharIndex, D3DColorXRGB(r, G, b), matar)
    
    'If we got here then packet is complete, copy data back to original queue
    

ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the ConsoleMessage message.

Private Sub HandleConsoleMessage()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim chat As String
    Dim fontIndex As Integer
    Dim STR As String
    Dim r As Byte
    Dim G As Byte
    Dim b As Byte
    
    chat = buffer.ReadASCIIString()
    fontIndex = buffer.ReadByte()
    
    If InStr(1, chat, "~") Then
        STR = ReadField(2, chat, 126)
            If val(STR) > 255 Then
                r = 255
            Else
                r = val(STR)
            End If
            
            STR = ReadField(3, chat, 126)
            If val(STR) > 255 Then
                G = 255
            Else
                G = val(STR)
            End If
            
            STR = ReadField(4, chat, 126)
            If val(STR) > 255 Then
                b = 255
            Else
                b = val(STR)
            End If
            
        Call AddtoRichTextBox(frmMain.RecTxt, Left$(chat, InStr(1, chat, "~") - 1), r, G, b, val(ReadField(5, chat, 126)) <> 0, val(ReadField(6, chat, 126)) <> 0)
    Else
        With FontTypes(fontIndex)
            Call AddtoRichTextBox(frmMain.RecTxt, chat, .red, .green, .blue, .bold, .italic)
        End With
        
    End If
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the GuildChat message.

Private Sub HandleGuildChat()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/07/08 (NicoNZ)
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim chat As String
    Dim STR As String
    Dim r As Byte
    Dim G As Byte
    Dim b As Byte
    Dim tmp As Integer
    Dim Cont As Integer
    
    
    chat = buffer.ReadASCIIString()
    
    If Not DialogosClanes.Activo Then
        If InStr(1, chat, "~") Then
            STR = ReadField(2, chat, 126)
            If val(STR) > 255 Then
                r = 255
            Else
                r = val(STR)
            End If
            
            STR = ReadField(3, chat, 126)
            If val(STR) > 255 Then
                G = 255
            Else
                G = val(STR)
            End If
            
            STR = ReadField(4, chat, 126)
            If val(STR) > 255 Then
                b = 255
            Else
                b = val(STR)
            End If
            
            Call AddtoRichTextBox(frmMain.RecTxt, Left$(chat, InStr(1, chat, "~") - 1), r, G, b, val(ReadField(5, chat, 126)) <> 0, val(ReadField(6, chat, 126)) <> 0)
        Else
            With FontTypes(FontTypeNames.FONTTYPE_GUILDMSG)
                Call AddtoRichTextBox(frmMain.RecTxt, chat, .red, .green, .blue, .bold, .italic)
            End With
        End If
    Else
        If InStr(1, chat, "~") Then
            STR = ReadField(2, chat, 126)
            If val(STR) > 255 Then
                r = 255
            Else
                r = val(STR)
            End If
            
            STR = ReadField(3, chat, 126)
            If val(STR) > 255 Then
                G = 255
            Else
                G = val(STR)
            End If
            
            STR = ReadField(4, chat, 126)
            If val(STR) > 255 Then
                b = 255
            Else
                b = val(STR)
            End If
            Call DialogosClanes.PushBackText(Left$(chat, InStr(1, chat, "~") - 1))
            'Call AddtoRichTextBox(frmMain.RecTxt, Left$(chat, InStr(1, chat, "~") - 1), r, g, b, Val(ReadField(5, chat, 126)) <> 0, Val(ReadField(6, chat, 126)) <> 0)
        Else
            'With FontTypes(FontTypeNames.FONTTYPE_GUILDMSG)
                'Call AddtoRichTextBox(frmMain.RecTxt, chat, .red, .green, .blue, .bold, .italic)
                Call DialogosClanes.PushBackText(ReadField(1, chat, 126))
            'End With
        End If
        
    End If
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the ShowMessageBox message.

Private Sub HandleShowMessageBox()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    frmMensaje.msg.Caption = buffer.ReadASCIIString()
    frmMensaje.Show
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the UserIndexInServer message.

Private Sub HandleUserIndexInServer()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserIndex = incomingData.ReadInteger()
End Sub

''
' Handles the UserCharIndexInServer message.

Private Sub HandleUserCharIndexInServer()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserCharIndex = incomingData.ReadInteger()
    UserPos.x = charlist(UserCharIndex).Pos.x
    UserPos.y = charlist(UserCharIndex).Pos.y
    'Are we under a roof?
    bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
            MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
            MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)

    frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
End Sub


''
' Handles the CharacterCreate message.


Private Sub HandleCharacterCreate()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 24 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim CharIndex As Integer
    Dim Body As Integer
    Dim Head As Integer
    Dim Heading As E_Heading
    Dim x As Byte
    Dim y As Byte
    Dim weapon As Integer
    Dim shield As Integer
    Dim helmet As Integer
    Dim privs As Integer
    Dim fx%, dur%
    
    CharIndex = buffer.ReadInteger()
    Body = buffer.ReadInteger()
    Head = buffer.ReadInteger()
    Heading = buffer.ReadByte()
    x = buffer.ReadByte()
    y = buffer.ReadByte()
    weapon = buffer.ReadInteger()
    shield = buffer.ReadInteger()
    helmet = buffer.ReadInteger()
    

        
    fx = buffer.ReadInteger()
    dur = buffer.ReadInteger()
    
    With charlist(CharIndex)
        
        .Nombre = buffer.ReadASCIIString()
        .center_text = 0.5 * Engine_GetTextWidth(.Nombre)
        .Criminal = buffer.ReadByte()
        .priv = buffer.ReadByte()
        Call incomingData.CopyBuffer(buffer)
        
        Call char_color(CharIndex)
        
        Call SetCharacterFx(CharIndex, fx, dur)
        '.luz = Engine_Landscape.Light_Create(x, y, 150, 150, 150, 3, , 1)
    End With
    
    Call MakeChar(CharIndex, Body, Head, Heading, x, y, weapon, shield, helmet)
    
    
    
    Call RefreshAllChars
    
    'If we got here then packet is complete, copy data back to original queue
    
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number

On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then
        Err.Raise ERROR
        LogError "ERROR EN h-CC"
    End If
End Sub


Private Sub char_color(ByVal Index As Integer)
    With charlist(Index)
        If .priv = 0 Then
            If .Criminal Then
                .colorz.r = ColoresPJ(50).r
                .colorz.G = ColoresPJ(50).G
                .colorz.b = ColoresPJ(50).b
            Else
                .colorz.r = ColoresPJ(49).r
                .colorz.G = ColoresPJ(49).G
                .colorz.b = ColoresPJ(49).b
            End If
        ElseIf .priv = 20 Then
            If .Criminal Then
                .colorz.r = 200
                .colorz.G = 50
                .colorz.b = 0
            Else
                .colorz.r = 0
                .colorz.G = 195
                .colorz.b = 255
            End If
        ElseIf .priv = 15 Then
            .colorz.r = 250
            .colorz.G = 250
            .colorz.b = 250
        ElseIf .priv = 8 Then
            .colorz.r = 128
            .colorz.G = 128
            .colorz.b = 128
        ElseIf .priv = 255 Then
            .colorz.r = 245
            .colorz.G = 222
            .colorz.b = 179
        Else
            .colorz.r = 128
            .colorz.G = 128
            .colorz.b = 128
        End If
        .color = D3DColorXRGB(.colorz.r, .colorz.G, .colorz.b)
    End With
End Sub
''
' Handles the CharacterRemove message.

Private Sub HandleCharacterRemove()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    
    CharIndex = incomingData.ReadInteger()
    
    Call EraseChar(CharIndex)
    Call RefreshAllChars
End Sub

''
' Handles the CharacterMove message.

Private Sub HandleCharacterMove()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim x As Byte
    Dim y As Byte
    Dim m As Byte
    Dim v As Byte
    CharIndex = incomingData.ReadInteger()
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    With charlist(CharIndex)
        If .FxIndex >= 40 And .FxIndex <= 49 Then   'If it's meditating, we remove the FX
            .FxIndex = 0
        End If

        ' Play steps sounds if the user is not an admin of any kind
        If .priv <> 20 Then
            Call DoPasosFx(CharIndex)
        End If
    End With
    Call Char_Move_by_Pos(CharIndex, x, y)
    'Call Engine.MoveCharbyPos(CharIndex, X, Y)
    
    Call RefreshAllChars
End Sub

''
' Handles the CharacterChange message.

Private Sub HandleCharacterChange()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 18 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim TempInt As Integer
    Dim headIndex As Integer
    
    CharIndex = incomingData.ReadInteger()
    
    With charlist(CharIndex)
        TempInt = incomingData.ReadInteger()
        
        If TempInt < LBound(BodyData()) Or TempInt > UBound(BodyData()) Then
            .Body = BodyData(0)
        Else
            .Body = BodyData(TempInt)
        End If
        .iBody = TempInt
        
        headIndex = incomingData.ReadInteger()
        
        If headIndex < LBound(HeadData()) Or headIndex > UBound(HeadData()) Then
            .Head = HeadData(0)
        Else
            .Head = HeadData(headIndex)
        End If
        .iHead = headIndex
        If (headIndex = 500 Or headIndex = 501) Then
        .muerto = True
        Else
        .muerto = False
        End If
        .Heading = incomingData.ReadByte()
        .invheading = .Heading
        If .invh Then
            If .Heading = E_Heading.east Then
                .invheading = E_Heading.west
            ElseIf .Heading = E_Heading.west Then
                .invheading = E_Heading.east
            End If
        End If
        TempInt = incomingData.ReadInteger()
        If TempInt <> 0 Then
        .arma = WeaponAnimData(TempInt)
        .armaz(0).num = TempInt
        End If
        TempInt = incomingData.ReadInteger()
        If TempInt <> 0 Then .Escudo = ShieldAnimData(TempInt)
        
        TempInt = incomingData.ReadInteger()
        If TempInt <> 0 Then .Casco = CascoAnimData(TempInt)
        
        headIndex = incomingData.ReadInteger()
        TempInt = incomingData.ReadInteger()
        Call SetCharacterFx(CharIndex, headIndex, TempInt)
    End With
    
    Call RefreshAllChars
End Sub

Private Sub HandleCCP()
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim TempInt As Single
    
    CharIndex = incomingData.ReadInteger()
    
    With charlist(CharIndex)
        TempInt = CSng(incomingData.ReadByte())
        .velocidad.x = TempInt
        .velocidad.y = TempInt
    End With
End Sub

Private Sub HandleMartillaso()
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim TempInt As Single
    
    CharIndex = incomingData.ReadInteger()
    TempInt = CSng(incomingData.ReadByte())
    Char_Jump CharIndex, TempInt
End Sub

''
' Handles the ObjectCreate message.

Private Sub HandleObjectCreate()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 5 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim x As Byte
    Dim y As Byte
    Dim Grh As Integer
    
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    Grh = incomingData.ReadInteger()
    If Grh = 669 Then

    ElseIf Grh = FOgata Then
        If MapData(x, y).luz = 0 Then
            MapData(x, y).luz = Engine_Landscape.Light_Create(x, y, 255, 200, 0, 3, 1, LUZ_TIPO_FUEGO)
        End If
    End If
    MapData(x, y).ObjGrh.GrhIndex = Grh
    
    
    Call InitGrh(MapData(x, y).ObjGrh, MapData(x, y).ObjGrh.GrhIndex)
End Sub

''
' Handles the ObjectDelete message.

Private Sub HandleObjectDelete()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim x As Byte
    Dim y As Byte
    
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    MapData(x, y).ObjGrh.GrhIndex = 0
End Sub

''
' Handles the BlockPosition message.

Private Sub HandleBlockPosition()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim x As Byte
    Dim y As Byte
    
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    
    If incomingData.ReadBoolean() Then
        MapData(x, y).Blocked = 1
    Else
        MapData(x, y).Blocked = 0
    End If
End Sub

''
' Handles the PlayMIDI message.

Private Sub HandlePlayMIDI()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    Dim currentMidi As Byte
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    currentMidi = incomingData.ReadByte()
    
    'If currentMidi Then
        'Call Audio.PlayMIDI(CStr(currentMidi) & ".mid", incomingData.ReadInteger())
    'Else
        'Remove the bytes to prevent errors
        Call incomingData.ReadInteger
    'End If
End Sub

''
' Handles the PlayWave message.

Private Sub HandlePlayWave()
'***************************************************
'Autor: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 08/14/07
'Last Modified by: Rapsodius
'Added support for 3D Sounds.
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
        
    Dim wave As Byte
    Dim srcX As Byte
    Dim srcY As Byte
    
    wave = incomingData.ReadByte()
    srcX = incomingData.ReadByte()
    srcY = incomingData.ReadByte()
If wave = 46 Then
    Call Audio.Sound_Play(CInt(wave), , volumenpotas)
Else
    Call Audio.Sound_Play(CInt(wave), , volumenfx)
End If
End Sub

''
' Handles the AreaChanged message.

Private Sub HandleAreaChanged()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim x As Byte
    Dim y As Byte
    
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
        
    Call CambioDeArea(x, y)
End Sub

''
' Handles the PauseToggle message.

Private Sub HandlePauseToggle()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    pausa = Not pausa
End Sub

''
' Handles the RainToggle message.

Private Sub HandleClima()
    'Remove packet ID
    Call incomingData.ReadByte
    Dim clima_n As Byte
    clima_n = incomingData.ReadByte()
    Dim r!, G!, b!
End Sub

''
' Handles the CreateFX message.

Private Sub HandleCreateFX()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 7 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim fx As Integer
    Dim Loops As Integer
    
    CharIndex = incomingData.ReadInteger()
    fx = incomingData.ReadInteger()
    Loops = incomingData.ReadInteger()
    
    Call SetCharacterFx(CharIndex, fx, Loops)
    If fx = 14 Then
     If Loops = 0 Then Loops = 1
        Call Audio.Sound_Play(172, , -2000)
    End If
End Sub

Private Sub HandleCreatePGP()
    If incomingData.Length < 8 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim fx As Integer
    Dim Loops As Integer
    Dim Layer As Byte
    
    CharIndex = incomingData.ReadInteger()
    fx = incomingData.ReadInteger()
    Loops = incomingData.ReadInteger()
    Layer = IIf(incomingData.ReadByte() = 0, 0, 1)
End Sub

Private Sub HandleCreateHIT()

    If incomingData.Length < 7 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    Dim hit As Integer
    Dim color As Long
    
    CharIndex = incomingData.ReadInteger()
    hit = incomingData.ReadInteger()
    color = incomingData.ReadLong()
    
    Dim colora(2) As Byte
    colora(0) = color And &HFF
    colora(1) = (color And &HFF00&) \ &H100&
    colora(2) = (color And &HFF0000) \ &H10000
    color = D3DColorXRGB(Abs(colora(0) - 2), Abs(colora(1) - 2), Abs(colora(2) - 2))
    
    FX_Hit_Create CharIndex, hit, 1800, color
    
End Sub

Private Sub HandleUpdateUserStats()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 26 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserMaxHP = incomingData.ReadInteger()
    UserMinHP = incomingData.ReadInteger()
    UserMaxMAN = incomingData.ReadInteger()
    UserMinMAN = incomingData.ReadInteger()
    UserMaxSTA = incomingData.ReadInteger()
    UserMinSTA = incomingData.ReadInteger()
    UserGLD = incomingData.ReadLong()
    UserLvl = incomingData.ReadByte()
    UserPasarNivel = incomingData.ReadLong()
    UserExp = incomingData.ReadLong()
    
    frmMain.exp.Caption = "Exp: " & UserExp & "/" & UserPasarNivel
    
    If UserPasarNivel > 0 Then
        frmMain.lblPorcLvl.Caption = "[" & Round(CDbl(UserExp) * CDbl(100) / CDbl(UserPasarNivel), 2) & "%]"
    Else
        frmMain.lblPorcLvl.Caption = "[N/A]"
    End If
    
            frmMain.vids.max = UserMaxHP
            frmMain.vids.Value = UserMinHP
            frmMain.vids.Caption = UserMinHP & "/" & UserMaxHP
            
            frmMain.mans.max = UserMaxMAN
            frmMain.mans.Value = UserMinMAN
            frmMain.mans.Caption = UserMinMAN & "/" & UserMaxMAN
    

    frmMain.STAShp.Width = (((UserMinSTA / 100) / (UserMaxSTA / 100)) * 94)

    frmMain.GldLbl.Caption = UserGLD
    frmMain.LvlLbl.Caption = UserLvl
    
    If UserMinHP = 0 Then
        UserEstado = 1
    Else
        UserEstado = 0
    End If
    
    If UserGLD >= CLng(UserLvl) * 10000 Then
        'Changes color
        frmMain.GldLbl.ForeColor = &HFF& 'Red
    Else
        'Changes color
        frmMain.GldLbl.ForeColor = &HFFFF& 'Yellow
    End If
End Sub

''
' Handles the WorkRequestTarget message.

Private Sub HandleWorkRequestTarget()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 2 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    UsingSkill = incomingData.ReadByte()

    frmMain.MousePointer = 2
    
    Select Case UsingSkill
        Case Magia
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_MAGIA, 100, 100, 120, 0, 0)
        Case Pesca
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_PESCA, 100, 100, 120, 0, 0)
        Case Robar
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_ROBAR, 100, 100, 120, 0, 0)
        Case Talar
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_TALAR, 100, 100, 120, 0, 0)
        Case Mineria
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_MINERIA, 100, 100, 120, 0, 0)
        Case FundirMetal
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_FUNDIRMETAL, 100, 100, 120, 0, 0)
        Case Proyectiles
            Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_PROYECTILES, 100, 100, 120, 0, 0)
    End Select
End Sub

''
' Handles the ChangeInventorySlot message.

Private Sub HandleChangeInventorySlot()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 21 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)

    'Remove packet ID
    Call buffer.ReadByte
    
    Dim slot As Byte
    Dim OBJIndex As Integer
    Dim name As String
    Dim Amount As Integer
    Dim Equipped As Boolean
    Dim GrhIndex As Integer
    Dim OBJType As Byte
    Dim MaxHit As Integer
    Dim MinHit As Integer
    Dim defense As Integer
    Dim Value As Long
    
    slot = buffer.ReadByte()
    OBJIndex = buffer.ReadInteger()
    name = buffer.ReadASCIIString()
    Amount = buffer.ReadInteger()
    Equipped = buffer.ReadBoolean()
    GrhIndex = buffer.ReadInteger()
    OBJType = buffer.ReadByte()
    MaxHit = buffer.ReadInteger()
    MinHit = buffer.ReadInteger()
    defense = buffer.ReadInteger()
    Value = buffer.ReadLong()
    
    Call InvSetItem(slot, OBJIndex, Amount, Equipped, GrhIndex, OBJType, MaxHit, MinHit, defense, Value, name)
    'Call Inventario.DrawInventorySlot(slot)
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing
    
    If ERROR <> 0 Then _
        Err.Raise ERROR
    
    
End Sub

Private Sub HandleChangeSpellSlot()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 6 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim slot As Byte
    slot = buffer.ReadByte()
    
    UserHechizos(slot) = buffer.ReadInteger()
    
    If slot <= frmMain.hlst.ListCount Then
        frmMain.hlst.List(slot - 1) = buffer.ReadASCIIString()
    Else
        Dim iasd As String
        iasd = buffer.ReadASCIIString()
        If iasd <> "(None)" Then Call frmMain.hlst.AddItem(iasd)
    End If
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub




''
' Handles the CarpenterObjects message.

Private Sub HandleCarpenterObjects()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    Else
    'Debug.Print incomingData.Length
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim count As Integer
    Dim i As Long
    Dim tmp As ePJ
    
    count = buffer.ReadInteger()
    
    Dim countekip(2) As Integer
    
    
    For i = 0 To 20
        pjs(i).Nick = ""
        pjs(i).ID = 0
        pjs(i).ekipo = eNone
        Ekipos(i).personajes(i) = -1
    Next i
    
    For i = 0 To 2
        Ekipos(i).num = 0
    Next i
    
    For i = 1 To count
        pjs(count).Nick = buffer.ReadASCIIString()
        pjs(count).ekipo = buffer.ReadInteger()
        pjs(count).ID = buffer.ReadInteger()
        Ekipos(pjs(count).ekipo).personajes(countekip(pjs(count).ekipo)) = count
        countekip(pjs(count).ekipo) = countekip(pjs(count).ekipo) + 1
    Next i
    
        Ekipos(eKip.eCUI).num = countekip(eKip.eCUI)
        Ekipos(eKip.eCUI).color = D3DColorXRGB(0, 120, 250)
        Ekipos(eKip.eCUI).Nombre = "Equipo azul"
        Ekipos(eKip.ePK).num = countekip(eKip.ePK)
        Ekipos(eKip.ePK).color = D3DColorXRGB(250, 0, 50)
        Ekipos(eKip.ePK).Nombre = "Equipo rojo"
        Ekipos(eKip.eNone).num = countekip(eKip.eNone)
        Ekipos(eKip.eNone).color = D3DColorXRGB(127, 127, 127)
        Ekipos(eKip.eNone).Nombre = "Espectadores"
    
    For i = i To UBound(ObjCarpintero())
        ObjCarpintero(i) = 0
    Next i
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the ErrorMessage message.

Private Sub HandleErrorMessage()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    Dim s As String
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    s = buffer.ReadASCIIString()
    Call MsgBox(s)
    LogError s
    frmOldPersonaje.MousePointer = 1
    'frmPasswd.MousePointer = 1
    If frmOldPersonaje.Visible Then
#If UsarWrench = 1 Then
        frmMain.Socket1.Disconnect
        frmMain.Socket1.Cleanup
#Else
        If frmMain.Winsock1.State <> sckClosed Then _
            frmMain.Winsock1.Close
#End If

    End If
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the Blind message.

Private Sub HandleBlind()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserCiego = True
End Sub

Public Sub CLEAR_INCOMING_BUFFER()
incomingData.ReadASCIIStringFixed incomingData.Length
End Sub

Private Sub HandleInvEQUIPED()
    If incomingData.Length < 7 Then
        CLEAR_INCOMING_BUFFER
        Exit Sub
    End If
    Call incomingData.ReadByte
    set_Slots 1, incomingData.ReadByte
    set_Slots 2, incomingData.ReadByte
    set_Slots 3, incomingData.ReadByte
    set_Slots 4, incomingData.ReadByte
    set_Slots 5, incomingData.ReadByte
    set_Slots 6, incomingData.ReadByte
End Sub

Private Sub HandleCCM()
    Call incomingData.ReadByte
    Dim jo As String
    jo = gen_conection_checksum(incomingData.ReadLong)
    Call SendData1(jo)
End Sub

Private Sub HandleCCO()
    Call incomingData.ReadByte
    Redundance = incomingData.ReadByte
    out_key = Redundance
    
    If incomingData.Length Then
        SeguridadArduz = (incomingData.ReadByte() = 255)
    Else
        SeguridadArduz = True
    End If
    
    Call Login
End Sub

''
' Handles the Dumb message.

Private Sub HandleDumb()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserEstupido = True
End Sub

Private Sub HandleTargetInvalido()
    Call incomingData.ReadByte
    
    Dim j As Byte
    j = incomingData.ReadByte
    Select Case j
    Case 0
        With FontTypes(FontTypeNames.FONTTYPE_INFO)
            Call AddtoRichTextBox(frmMain.RecTxt, "Target invalido.", .red, .green, .blue, .bold, .italic)
        End With
    Case 1
        With FontTypes(FontTypeNames.FONTTYPE_INFO)
            Call AddtoRichTextBox(frmMain.RecTxt, "Estas demasiado lejos para lanzar este hechizo.", .red, .green, .blue, .bold, .italic)
        End With
    Case 2
        With FontTypes(FontTypeNames.FONTTYPE_INFO)
            Call AddtoRichTextBox(frmMain.RecTxt, "No tenés suficiente mana.", .red, .green, .blue, .bold, .italic)
        End With
    Case 3
        With FontTypes(FontTypeNames.FONTTYPE_FIGHT)
            Call AddtoRichTextBox(frmMain.RecTxt, "El hechizo está desactivado en este servidor.", .red, .green, .blue, .bold, .italic)
        End With
    End Select
End Sub

Private Sub HandleMoveScreen()
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    'Remove packet ID
    Call incomingData.ReadByte
    Dim HE As E_Heading
    HE = incomingData.ReadInteger()
    If SS_last = HE Then
        If SS_sync > 0 Then
            SS_mov = GetTickCount() - SS_sync
            SS_sync = 0
            SS_last = 255
        End If
    End If
    Char_Move_by_Head UserCharIndex, HE
    Engine_MoveScreen HE
End Sub

Private Sub HandleMensaje_Web()
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    'Remove packet ID
    Call incomingData.ReadByte
    Dim HE As Integer
    HE = incomingData.ReadInteger()
    Select Case HE
        Case 1
            ShowConsoleMsg "Ranking enviado."
        Case 3
            ShowConsoleMsg "Tu usuario no está registrado en el juego, para figurar en el ranking registrate en http://www.arduz.com.ar/"
        Case 2
            ShowConsoleMsg "Tu contraseña no es la misma que la de el ranking, el ranking no ha podido ser actualizado."
        Case 5
            Protocol.WriteQuit
            MsgBox "Ocurrio un error con los personajes de su cuenta. Disculpe." 'No puede usar este pj
        Case 4
            MsgBox "No creaste ningún personaje en tu cuenta, entra a la web y crea un personaje para poder jugar.", vbInformation
        Case 7
            Call WriteQuit
            Call closex
            
            MsgBox "Alguien más ingresó a Arduz con tu cuenta."
            
        Case 64
            ShowConsoleMsg "Ingresando a la web..."
    End Select
    
End Sub
''
' Handles the AddForumMessage message.

''
' Handles the SetInvisible message.

Private Sub HandleSetInvisible()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 4 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim CharIndex As Integer
    
    CharIndex = incomingData.ReadInteger()
    charlist(CharIndex).invisible = incomingData.ReadBoolean()
End Sub


Private Sub HandleMeditateToggle()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserMeditar = Not UserMeditar
End Sub

''
' Handles the BlindNoMore message.

Private Sub HandleBlindNoMore()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserCiego = False
End Sub

''
' Handles the DumbNoMore message.

Private Sub HandleDumbNoMore()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserEstupido = False
End Sub

''
' Handles the ParalizeOK message.

Private Sub HandleParalizeOK()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    UserParalizado = incomingData.ReadBoolean
End Sub



''
' Handles the SendNight message.

Private Sub HandleSendNight()
'***************************************************
'Author: Fredy Horacio Treboux (liquid)
'Last Modification: 01/08/07
'
'***************************************************
    If incomingData.Length < 2 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim tBool As Boolean 'CHECK, este handle no hace nada con lo que recibe.. porque, ehmm.. no hay noche?.. o si?
    tBool = incomingData.ReadBoolean()
End Sub

''
' Handles the SpawnList message.

Private Sub HandleSpawnList()

End Sub

''
' Handles the ShowSOSForm message.

Private Sub HandleShowSOSForm()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim sosList() As String
    Dim i As Long
    
    sosList = Split(buffer.ReadASCIIString(), SEPARATOR)
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the ShowMOTDEditionForm message.

Private Sub HandleShowMOTDEditionForm()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Call buffer.ReadASCIIString
    
    'If we got here then packet is complete, copy data back to original queue
    Call incomingData.CopyBuffer(buffer)
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the ShowGMPanelForm message.

Private Sub HandleShowGMPanelForm()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    'Remove packet ID
    Call incomingData.ReadByte
    
    'frmPanelGm.Show vbModeless, frmMain
End Sub

''
' Handles the UserNameList message.

Private Sub HandleUserNameList()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim userList() As String
    Dim i As Long
    
    
    
    Dim tmp As ePJ
    Dim countekip(2) As Integer
    Dim arrayx() As String
    Dim tempa(40) As Integer
    userList = Split(buffer.ReadASCIIString(), SEPARATOR)
    Call incomingData.CopyBuffer(buffer)
    
    For i = 0 To 40
    pjs(i) = tmp
        'pjs(i).Nick = ""
        'pjs(i).clan = ""
        'pjs(i).clan = ""
        'pjs(i).id = 0
        'pjs(i).ekipo = eNone
        Ekipos(eKip.eCUI).personajes(i) = 0
        Ekipos(eKip.ePK).personajes(i) = 0
        Ekipos(eKip.eNone).personajes(i) = 0
    Next i
    
    Ekipos(eKip.eCUI).num = 0
    Ekipos(eKip.ePK).num = 0
    Ekipos(eKip.eNone).num = 0
    
    totalxs = 0
    
    
        For i = 0 To UBound(userList())
            arrayx = Split(userList(i), "@")
            pjs(i).Nick = arrayx(0)
            pjs(i).ID = arrayx(1)
            pjs(i).bot = IIf(arrayx(2) = 0, False, True)
            If pjs(i).bot = False Then
                pjs(i).frags = arrayx(3)
                pjs(i).muertes = arrayx(4)
                pjs(i).Puntos = arrayx(5)
                pjs(i).gm = CBool(arrayx(6))
                pjs(i).ekipo = arrayx(7)
                pjs(i).clan = arrayx(8)
                pjs(i).Ping = arrayx(9)
            Else
                pjs(i).gm = False
                pjs(i).ekipo = arrayx(3)
                pjs(i).frags = 0
                pjs(i).muertes = 0
                pjs(i).Puntos = 0
                pjs(i).clan = ""
            End If
        Next i
Dim max As Integer
max = UBound(pjs())
Dim j As Integer
Dim aux As ePJ
Dim numero As Byte
Do
numero = 0
    For i = LBound(pjs()) To max Step 1
        For j = LBound(pjs()) To (max - 1) Step 1
            If pjs(j).frags < pjs(j + 1).frags Then ' Para Descendente, Inviertes el > con <
                aux = pjs(j + 1)
                pjs(j + 1) = pjs(j)
                pjs(j) = aux
                numero = numero + 1
            End If
        Next j
    Next i
    If numero = 0 Then Exit Do
Loop
        For i = 0 To UBound(userList())
            countekip(pjs(i).ekipo) = countekip(pjs(i).ekipo) + 1
            Ekipos(pjs(i).ekipo).personajes(countekip(pjs(i).ekipo)) = i
            totalxs = totalxs + 1
        Next i
        Ekipos(eKip.eCUI).num = countekip(eKip.eCUI)
        Ekipos(eKip.eCUI).color = D3DColorXRGB(0, 120, 250)
        Ekipos(eKip.eCUI).Nombre = "Equipo azul"
        Ekipos(eKip.ePK).num = countekip(eKip.ePK)
        Ekipos(eKip.ePK).color = D3DColorXRGB(250, 0, 0)
        Ekipos(eKip.ePK).Nombre = "Equipo rojo"
        Ekipos(eKip.eNone).num = countekip(eKip.eNone)
        Ekipos(eKip.eNone).color = D3DColorXRGB(127, 127, 127)
        Ekipos(eKip.eNone).Nombre = "Espectadores"
    'If we got here then packet is complete, copy data back to original queue

    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub

''
' Handles the Pong message.

Private Sub HandlePong()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    Call incomingData.ReadByte
    On Error Resume Next
    'Call AddtoRichTextBox(frmMain.RecTxt, "El ping es " & (GetTickCount - pingTime) & " ms.", 255, 0, 0, True, False, False)
    pinga = CInt(ping_timer.time)
    WriteUpdatePing
    pingTime = 0
End Sub

''
' Handles the UpdateTag message.

Private Sub HandleUpdateTagAndStatus()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 6 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
On Error GoTo ErrHandler
    'This packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    Dim buffer As New clsByteQueue
    Call buffer.CopyBuffer(incomingData)
    
    'Remove packet ID
    Call buffer.ReadByte
    
    Dim CharIndex As Integer
    Dim Criminal As Boolean
    Dim userTag As String
    
    CharIndex = buffer.ReadInteger()
    Criminal = buffer.ReadBoolean()
    userTag = buffer.ReadASCIIString()
    Call incomingData.CopyBuffer(buffer)
    'Update char status adn tag!
    With charlist(CharIndex)
        If Criminal Then
            .Criminal = 1
        Else
            .Criminal = 0
        End If
        
        .Nombre = userTag
        .center_text = 0.5 * Engine_GetTextWidth(.Nombre)
    End With
    
    'If we got here then packet is complete, copy data back to original queue
    
    
ErrHandler:
    Dim ERROR As Long
    ERROR = Err.number
On Error GoTo 0
    
    'Destroy auxiliar buffer
    Set buffer = Nothing

    If ERROR <> 0 Then _
        Err.Raise ERROR
End Sub
Private Sub HandleCrearProyectil()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 6 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If
    
    'Remove packet ID
    Call incomingData.ReadByte
    
    Dim x As Byte
    Dim y As Byte
    Dim t As Integer, v As Single
    
    Dim i As Integer
    i = incomingData.ReadInteger()
    x = incomingData.ReadByte()
    y = incomingData.ReadByte()
    t = CInt(incomingData.ReadByte())
    v = CSng(incomingData.ReadByte())
    If t = 0 Then t = 13128
    If v = 0 Then v = 1
    If x = 0 Then
        FX_Projectile_Create i, y, t, v
    Else
        FX_Projectile_Create_pos i, x, y, t, v
    End If
End Sub

Private Sub HandleAnim_Attack()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    If incomingData.Length < 3 Then
        Err.Raise incomingData.NotEnoughDataErrCode
        Exit Sub
    End If

    Call incomingData.ReadByte
    Call Char_Start_Anim(incomingData.ReadInteger())
End Sub

Public Sub WriteLoginExistingChar()
    Dim i As Long
    Dim s As String * 32
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.LoginExistingChar)
        Call .WriteASCIIString(UserName)
        Call .WriteASCIIString(UserPassword)
        Call .WriteLong(client_checksum)
        If LenB(passw) < 1 Then passw = "NOTIENEPASSWD"
        Call .WriteASCIIString(passw)
        s = modMAC.get_mac_address
        If LenB(s) < 1 Then s = "SOYCHEATERVIEJA"
        Call .WriteASCIIString(s)
        Call .WriteDouble(modMAC.get_pc_id)
        
        Call FlushBuffer
    End With
End Sub

Public Sub WriteTalk(ByVal chat As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Talk)
        Call .WriteASCIIString(chat)
    End With
End Sub

Public Sub WriteYell(ByVal chat As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Yell)
        Call .WriteASCIIString(chat)
    End With
End Sub
Public Sub WriteNuevoBalance()
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.NuevoBalance)
    End With
End Sub
Public Sub WriteWhisper(ByVal CharIndex As Integer, ByVal chat As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Whisper)
        Call .WriteInteger(CharIndex)
        Call .WriteASCIIString(chat)
    End With
End Sub

Public Sub WriteSelectAccPJ(ByVal bando As Byte, ByVal pj As Byte)
If bando > 0 And pj > 0 Then
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.SelectAccPJ)
        Call .WriteByte(pj)
        Call .WriteByte(bando)
    End With
    Engine_UI.acc_visible = 0
    FlushBuffer
End If
End Sub

Public Sub WriteWalk(ByVal Heading As E_Heading)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Walk)
        Call .WriteByte(Heading)
        SS_sync = GetTickCount()
        SS_last = Heading
    End With
    FlushBuffer
End Sub


Public Sub WriteRequestPositionUpdate()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.RequestPositionUpdate)
    FlushBuffer
End Sub

Public Sub WriteAttack()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.Attack)
    FlushBuffer
End Sub

Public Sub WritePickUp()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.PickUp)
End Sub

Public Sub WriteDrop(ByVal slot As Byte, ByVal Amount As Integer)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Drop)
        Call .WriteByte(slot)
        Call .WriteInteger(Amount)
    End With
End Sub

Public Sub WriteCastSpell(ByVal slot As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.CastSpell)
        Call .WriteByte(slot)
    End With
    FlushBuffer
End Sub

Public Sub WriteLeftClick(ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.LeftClick)
        Call .WriteByte(x)
        Call .WriteByte(y)
    End With
    FlushBuffer
End Sub

Public Sub WriteDoubleClick(ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.DoubleClick)
        Call .WriteByte(x)
        Call .WriteByte(y)
    End With
    FlushBuffer
End Sub

Public Sub WriteWork(ByVal Skill As eSkill)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Work)
        Call .WriteByte(Skill)
    End With
    FlushBuffer
End Sub

Public Sub WriteUseItem(ByVal slot As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.UseItem)
        Call .WriteByte(slot)
    End With
    FlushBuffer
End Sub

Public Sub WriteWorkLeftClick(ByVal x As Byte, ByVal y As Byte, ByVal Skill As eSkill)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.WorkLeftClick)
        Call .WriteByte(x)
        Call .WriteByte(y)
        Call .WriteByte(Skill)
    End With
    FlushBuffer
End Sub

Public Sub WriteLanzarH(ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.LanzarH)
        Call .WriteByte(x)
        Call .WriteByte(y)
        Call .WriteByte(hechizo_cargado Xor 215 Xor outgoingData.CRCChar Xor 108)
    End With
    hechizo_cargado = 108
    FlushBuffer
End Sub

Public Sub WriteMartillo(ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Martillo)
    End With
    FlushBuffer
End Sub

Public Sub WriteSpellInfo(ByVal slot As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.SpellInfo)
        Call .WriteByte(slot)
    End With
End Sub

Public Sub WriteEquipItem(ByVal slot As Byte)

    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.EquipItem)
        Call .WriteByte(slot)
    End With
    FlushBuffer
End Sub

Public Sub WriteChangeHeading(ByVal Heading As E_Heading)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.ChangeHeading)
        Call .WriteByte(Heading)
    End With
    FlushBuffer
End Sub

Public Sub WriteMoveItem(ByVal slot As Byte, ByVal Amount As Byte)

    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.BankDeposit)
        Call .WriteByte(slot)
        Call .WriteByte(Amount)
    End With
    FlushBuffer
End Sub

Public Sub WriteMoveSpell(ByVal upwards As Boolean, ByVal slot As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.MoveSpell)
        Call .WriteBoolean(upwards)
        Call .WriteByte(slot)
    End With
    FlushBuffer
End Sub


Public Sub WriteOnline()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.Online)
End Sub

Public Sub WriteQuit()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.Quit)
    FlushBuffer
End Sub

Public Sub WriteMeditate()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.Meditate)
    FlushBuffer
End Sub

Public Sub WriteBankStart()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.BankStart)
    FlushBuffer
End Sub

Public Sub WriteChangeDescription(ByVal desc As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.ChangeDescription)
        Call .WriteASCIIString(desc)
    End With
    FlushBuffer
End Sub

Public Sub WriteChangePassword(ByRef oldPass As String, ByRef newPass As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.ChangePassword)
        Call .WriteASCIIString(oldPass)
        Call .WriteASCIIString(newPass)
    End With
End Sub

Public Sub WriteWarpMeToTarget()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.WarpMeToTarget)
End Sub


Public Sub WriteWarpChar(ByVal UserName As String, ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.WarpChar)
        Call .WriteASCIIString(UserName)
        Call .WriteInteger(map)
        Call .WriteByte(x)
        Call .WriteByte(y)
    End With
End Sub


Public Sub WriteGoToChar(ByVal UserName As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.GoToChar)
        Call .WriteASCIIString(UserName)
    End With
End Sub

Public Sub WriteInvisible()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.invisible)
End Sub

Public Sub WriteRequestUserList()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.RequestUserList)
End Sub

Public Sub WriteEditChar(ByVal UserName As String, ByVal editOption As eEditOptions, ByVal arg1 As String, ByVal arg2 As String)
If Len(arg1) > 0 And Len(arg2) > 0 Then
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.EditChar)
        Call .WriteASCIIString(UserName)
        Call .WriteByte(editOption)
        Call .WriteASCIIString(arg1)
        Call .WriteASCIIString(arg2)
    End With
End If
End Sub

Public Sub WriteDesactivarFeature(ByVal UserName As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.RequestCharSkills)
        Call .WriteASCIIString(UserName)
    End With
End Sub

Public Sub WriteActivarFeature(ByVal UserName As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.ReviveChar)
        Call .WriteASCIIString(UserName)
    End With
End Sub

Public Sub WriteKick(ByVal UserName As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Kick)
        Call .WriteASCIIString(UserName)
    End With
End Sub

Public Sub WriteBanChar(ByVal UserName As String, ByVal reason As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.BanChar)
        Call .WriteASCIIString(UserName)
        Call .WriteASCIIString(reason)
    End With
End Sub

Public Sub WriteSummonChar(ByVal UserName As String)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.SummonChar)
        Call .WriteASCIIString(UserName)
    End With
End Sub

Public Sub WriteTeleportCreate(ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.TeleportCreate)
        Call .WriteInteger(map)
        Call .WriteByte(x)
        Call .WriteByte(y)
    End With
End Sub


Public Sub WriteTeleportDestroy()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.TeleportDestroy)
End Sub


Public Sub WriteRainToggle(ByVal f As Byte)
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.RainToggle)
    Call outgoingData.WriteByte(f)
End Sub

Public Sub WriteForceWAVEToMap(ByVal waveID As Byte, ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.ForceWAVEToMap)
        Call .WriteByte(waveID)
        Call .WriteInteger(map)
        Call .WriteByte(x)
        Call .WriteByte(y)
    End With
End Sub

Public Sub WriteBanIP(ByVal Nick As String, ByVal reason As String)
    Dim i As Long
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.BanIP)
        Call .WriteBoolean(False)
        Call .WriteASCIIString(Nick)
        Call .WriteASCIIString(reason)
    End With
End Sub

Public Sub WriteCreateItem(ByVal itemIndex As Long)
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.CreateItem)
        Call .WriteInteger(itemIndex)
    End With
End Sub

Public Sub WriteDestroyItems()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.DestroyItems)
End Sub


Public Sub WriteNight()
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.night)
End Sub

Public Sub WritePing()
    If pingTime <> 0 Then Exit Sub
    Call FlushBuffer
    Call outgoingData.PutCRCChar
    Call outgoingData.WriteByte(ClientPacketID.Ping)
    Call FlushBuffer
    
    ping_timer.time
    'pingTime = GetTickCount
End Sub

Public Sub WriteUpdatePing()
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.Update_Ping)
        If pinga > 32512 Then pinga = 10000
        Call .WriteInteger(pinga)
    End With
    FlushBuffer
End Sub

Public Sub FlushBuffer()
    Dim sndData As String
    Dim dat() As Byte
    With outgoingData
        If .Length = 0 Then _
            Exit Sub
        sndData = .ReadASCIIStringFixed(.Length)
        dat = StrConv(sndData, vbFromUnicode)
        EncryptData dat, out_key
        'print_barray dat
        'sndData = StrConv(dat, vbUnicode)
        Call SendData(StrConv(dat, vbUnicode))
    End With
End Sub

Private Sub SendData(ByRef sdData As String)
If Len(sdData) = 0 Then Exit Sub

    #If UsarWrench = 1 Then
        If Not frmMain.Socket1.IsWritable Then
            Call outgoingData.WriteASCIIStringFixed(sdData)
            Exit Sub
        End If
    
        If Not frmMain.Socket1.Connected Then Exit Sub
    #Else
        If frmMain.Winsock1.State <> sckConnected Then Exit Sub
    #End If
    'Dim dat() As Byte
''    Dim tb As Byte
''    Dim j As Long
''
    'dat = StrConv(sdData, vbFromUnicode)
''    j = UBound(dat)
''    If j = 0 Then Exit Sub
    'print_barray dat
''    tb = CRCPAXOR(dat(0), j + 1, Redundance, 0)
''    'print_barray dat
''    'ReDim Preserve dat(UBound(dat) + 1)
''    'dat(UBound(dat)) = tb
''    Dim baba() As Byte
''    ReDim baba(j + 2)
''    DXCopyMemory baba(0), CInt(j), 2
''    DXCopyMemory baba(2), dat(0), j
''    sdData = StrConv(baba, vbUnicode)
''    'sdData = Chr$(UBound(dat) \ 256) & Chr$(UBound(dat) Mod 256) & StrConv(dat, vbUnicode)
    
    #If UsarWrench = 1 Then
        Call frmMain.Socket1.Write(sdData, Len(sdData))
    #Else
        Call frmMain.Winsock1.SendData(sdData)
    #End If

End Sub


Private Sub print_barray(ByRef ba() As Byte)
Dim i%, t$
t = Hex$(ba(0))
For i = 1 To UBound(ba)
t = t & ":" & Hex$(ba(i))
Next i
Debug.Print t
End Sub


Private Sub SendData1(ByRef sdData As String)
If Len(sdData) = 0 Then Exit Sub
    #If UsarWrench = 1 Then
        If Not frmMain.Socket1.IsWritable Then
            Call outgoingData.WriteASCIIStringFixed(sdData)
            Exit Sub
        End If
    
        If Not frmMain.Socket1.Connected Then Exit Sub
    #Else
        If frmMain.Winsock1.State <> sckConnected Then Exit Sub
    #End If
   

    #If UsarWrench = 1 Then
        Call frmMain.Socket1.Write(sdData, Len(sdData))
    #Else
        Call frmMain.Winsock1.SendData(sdData)
    #End If

End Sub
Public Sub WriteChangeMap(ByVal map As String)
On Error GoTo errh:
If val(map) > 0 Then
    With outgoingData
        Call .PutCRCChar
        Call .WriteByte(ClientPacketID.CambiarMapar)
        Call .WriteInteger(val(map))
    End With
Else
GoTo errh:
End If
Exit Sub
errh:
Call ShowConsoleMsg("Mapa invalido." & map)
End Sub

Private Sub PutCRCChar()
    'Debug.Print CRClast
    If SeguridadArduz = True Then
        If CRClast = 255 Then CRClast = 1
        Call outgoingData.WriteByte(CRClast Xor 108)
        CRClast = CRClast + 1
    End If
    'Debug.Print CRClast
End Sub
