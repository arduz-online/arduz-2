Attribute VB_Name = "modBots"
Option Explicit

Sub QuitarMascota(ByVal UserIndex As Integer, ByVal NpcIndex As Integer)

Dim i As Integer
UserList(UserIndex).NroMascotas = UserList(UserIndex).NroMascotas - 1
For i = 1 To MAXMASCOTAS
  If UserList(UserIndex).MascotasIndex(i) = NpcIndex Then
     UserList(UserIndex).MascotasIndex(i) = 0
     UserList(UserIndex).MascotasType(i) = 0
     Exit For
  End If
Next i

End Sub

Sub QuitarMascotaNpc(ByVal Maestro As Integer)
    Npclist(Maestro).Mascotas = Npclist(Maestro).Mascotas - 1
End Sub

Sub MuereNpc(ByVal NpcIndex As Integer, ByVal UserIndex As Integer)
'
'Author: Unknown
'Llamado cuando la vida de un NPC llega a cero.
'Last Modify Date: 24/01/2007
'22/06/06: (Nacho) Chequeamos si es pretoriano
'24/01/2007: Pablo (ToxicWaste): Agrego para actualización de tag si cambia de status.
'
On Error GoTo ErrHandler
    Dim MiNPC As npc
    Dim TeamBot As eKip
    Dim NumNPC As Integer
    NumNPC = Npclist(NpcIndex).numero
    TeamBot = Npclist(NpcIndex).Bando
    MiNPC = Npclist(NpcIndex)
    Dim EraCriminal As Boolean
   
    If (esPretoriano(NpcIndex) = 4) Then
        'Solo nos importa si fue matado en el mapa pretoriano.
        If Npclist(NpcIndex).Pos.map = servermap Then
            'seteamos todos estos 'flags'acorde para que cambien solos de alcoba
            Dim i As Integer
            Dim j As Integer
            Dim NPCI As Integer
        
            For i = 8 To 90
                For j = 8 To 90
                
                    NPCI = MapData(Npclist(NpcIndex).Pos.map, i, j).NpcIndex
                    If NPCI > 0 Then
                        If esPretoriano(NPCI) > 0 Then
                            Npclist(NPCI).Invent.ArmourEqpSlot = IIf(Npclist(NpcIndex).Pos.X > 50, 1, 5)
                        End If
                    End If
                Next j
            Next i
            Call CrearClanPretoriano
        End If
    ElseIf esPretoriano(NpcIndex) > 0 Then
        If Npclist(NpcIndex).Pos.map = servermap Then
            Npclist(NpcIndex).Invent.ArmourEqpSlot = 0
            pretorianosVivos = pretorianosVivos - 1
        End If
    End If
    If UserIndex > 0 Then Call WriteConsoleMsg(UserIndex, "Has matado a " & Npclist(NpcIndex).name & "!", FontTypeNames.FONTTYPE_FIGHT)
    Dim wp As WorldPos
    If (resuauto Or deathm) And frmMain.respawnbot(2).value = False Then
        If Npclist(NpcIndex).Muerto = 0 Then
            Npclist(NpcIndex).Muerto = 1
            Npclist(NpcIndex).Contadores.TimeDead = 15
            Npclist(NpcIndex).Char.CascoAnim = 2
            Npclist(NpcIndex).Char.ShieldAnim = 2
            Npclist(NpcIndex).Char.WeaponAnim = 2
            Call ChangeNPCChar(NpcIndex, 501, 145, Npclist(NpcIndex).Char.Heading)
            'Call CrearNPC(NumNPC, servermap, wp, TeamBot)
            Exit Sub
        Else
            Npclist(NpcIndex).Muerto = 0
            Npclist(NpcIndex).Contadores.TimeDead = 0
            Call QuitarNPC(NpcIndex)
            Call CrearNPC(NumNPC, servermap, wp, TeamBot)
        End If
    Else
        Call QuitarNPC(NpcIndex)
    End If
    'Quitamos el npc
    
    If UserIndex > 0 Then 'Lo mato un usuario?
        If MiNPC.flags.Snd3 > 0 Then
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(MiNPC.flags.Snd3, MiNPC.Pos.X, MiNPC.Pos.Y))
        End If
        UserList(UserIndex).flags.TargetNPC = 0
        UserList(UserIndex).flags.TargetNpcTipo = eNPCType.Comun
        
        '[MODIFICADO] 7/2/10 Le damos puntos si mata un bot
        UserList(UserIndex).Stats.puntos = UserList(UserIndex).Stats.puntos + 150
        'UserList(UserIndex).Stats.puntosenv = UserList(UserIndex).Stats.puntosenv + 150
        UserList(UserIndex).Stats.UsuariosMatados = UserList(UserIndex).Stats.UsuariosMatados + 1
        'UserList(UserIndex).Stats.UsuariosMatadosenv = UserList(UserIndex).Stats.UsuariosMatadosenv + 1
        '[/MODIFICADO] 7/2/10
        'El user que lo mato tiene mascotas?
        If UserList(UserIndex).NroMascotas > 0 Then
            Dim t As Integer
            For t = 1 To MAXMASCOTAS
                  If UserList(UserIndex).MascotasIndex(t) > 0 Then
                      If Npclist(UserList(UserIndex).MascotasIndex(t)).TargetNPC = NpcIndex Then
                              Call FollowAmo(UserList(UserIndex).MascotasIndex(t))
                      End If
                  End If
            Next t
        End If
        
        '[KEVIN]
        If MiNPC.flags.ExpCount > 0 Then

                UserList(UserIndex).Stats.Exp = UserList(UserIndex).Stats.Exp + MiNPC.flags.ExpCount
                If UserList(UserIndex).Stats.Exp > MAXEXP Then _
                    UserList(UserIndex).Stats.Exp = MAXEXP
                'Call WriteConsoleMsg(UserIndex, "Has ganado " & MiNPC.flags.ExpCount & " puntos de experiencia.", FontTypeNames.FONTTYPE_FIGHT)

            MiNPC.flags.ExpCount = 0
        End If
        
        '[/KEVIN]
        'Call WriteConsoleMsg(UserIndex, "Has matado a " & Npclist(NpcIndex).name & "!", FontTypeNames.FONTTYPE_FIGHT)
        If UserList(UserIndex).Stats.NPCsMuertos < 32000 Then _
            UserList(UserIndex).Stats.NPCsMuertos = UserList(UserIndex).Stats.NPCsMuertos + 1
        
        EraCriminal = criminal(UserIndex)
        
        If MiNPC.Stats.Alineacion = 0 Then
            If MiNPC.numero = Guardias Then
                UserList(UserIndex).Reputacion.NobleRep = 0
                UserList(UserIndex).Reputacion.PlebeRep = 0
                UserList(UserIndex).Reputacion.AsesinoRep = UserList(UserIndex).Reputacion.AsesinoRep + 500
                If UserList(UserIndex).Reputacion.AsesinoRep > MAXREP Then _
                    UserList(UserIndex).Reputacion.AsesinoRep = MAXREP
            End If
            If MiNPC.MaestroUser = 0 Then
                UserList(UserIndex).Reputacion.AsesinoRep = UserList(UserIndex).Reputacion.AsesinoRep + vlASESINO
                If UserList(UserIndex).Reputacion.AsesinoRep > MAXREP Then _
                    UserList(UserIndex).Reputacion.AsesinoRep = MAXREP
            End If
        ElseIf MiNPC.Stats.Alineacion = 1 Then
            UserList(UserIndex).Reputacion.PlebeRep = UserList(UserIndex).Reputacion.PlebeRep + vlCAZADOR
            If UserList(UserIndex).Reputacion.PlebeRep > MAXREP Then _
                UserList(UserIndex).Reputacion.PlebeRep = MAXREP
        ElseIf MiNPC.Stats.Alineacion = 2 Then
            UserList(UserIndex).Reputacion.NobleRep = UserList(UserIndex).Reputacion.NobleRep + vlASESINO / 2
            If UserList(UserIndex).Reputacion.NobleRep > MAXREP Then _
                UserList(UserIndex).Reputacion.NobleRep = MAXREP
        ElseIf MiNPC.Stats.Alineacion = 4 Then
            UserList(UserIndex).Reputacion.PlebeRep = UserList(UserIndex).Reputacion.PlebeRep + vlCAZADOR
            If UserList(UserIndex).Reputacion.PlebeRep > MAXREP Then _
                UserList(UserIndex).Reputacion.PlebeRep = MAXREP
        End If

    End If 'Userindex > 0
    
Exit Sub

ErrHandler:
    Call LogError("Error en MuereNpc - Error: " & err.Number & " - Desc: " & err.Description)
End Sub



Sub MuereNpc1(ByVal NpcIndex As Integer)
'
'Author: Unknown
'Llamado cuando la vida de un NPC llega a cero.
'Last Modify Date: 24/01/2007
'22/06/06: (Nacho) Chequeamos si es pretoriano
'24/01/2007: Pablo (ToxicWaste): Agrego para actualización de tag si cambia de status.
'
On Error GoTo ErrHandler
    Dim MiNPC As npc
    MiNPC = Npclist(NpcIndex)
    'Dim EraCriminal As Boolean
   
    If (esPretoriano(NpcIndex) = 4) Then
        'Solo nos importa si fue matado en el mapa pretoriano.
        If Npclist(NpcIndex).Pos.map = servermap Then
            'seteamos todos estos 'flags'acorde para que cambien solos de alcoba
            Dim i As Integer
            Dim j As Integer
            Dim NPCI As Integer
        
            For i = 8 To 90
                For j = 8 To 90
                
                    NPCI = MapData(Npclist(NpcIndex).Pos.map, i, j).NpcIndex
                    If NPCI > 0 Then
                        If esPretoriano(NPCI) > 0 Then
                            Npclist(NPCI).Invent.ArmourEqpSlot = IIf(Npclist(NpcIndex).Pos.X > 50, 1, 5)
                        End If
                    End If
                Next j
            Next i
            Call CrearClanPretoriano
        End If
    ElseIf esPretoriano(NpcIndex) > 0 Then
        If Npclist(NpcIndex).Pos.map = servermap Then
            Npclist(NpcIndex).Invent.ArmourEqpSlot = 0
            pretorianosVivos = pretorianosVivos - 1
        End If
    End If
   
    'Quitamos el npc
    Call QuitarNPC(NpcIndex)
    
Exit Sub

ErrHandler:
    Call LogError("Error en MuereNpc - Error: " & err.Number & " - Desc: " & err.Description)
End Sub



Sub ResetNpcFlags(ByVal NpcIndex As Integer)
    'Clear the npc's flags
    
    With Npclist(NpcIndex).flags
        .AfectaParalisis = 0
        .AguaValida = 0
        .AttackedBy = vbNullString
        .AttackedFirstBy = vbNullString
        .Attacking = 0
        .BackUp = 0
        .Bendicion = 0
        .Domable = 0
        .Envenenado = 0
        .Faccion = 0
        .Follow = False
        .LanzaSpells = 0
        .GolpeExacto = 0
        .invisible = 0
        .Maldicion = 0
        .OldHostil = 0
        .OldMovement = 0
        .Paralizado = 0
        .Inmovilizado = 0
        .Respawn = 0
        .RespawnOrigPos = 0
        .Snd1 = 0
        .Snd2 = 0
        .Snd3 = 0
        .TierraInvalida = 0
        .UseAINow = False
        .AtacaAPJ = 0
        .AtacaANPC = 0
        .AIAlineacion = e_Alineacion.ninguna
        .AIPersonalidad = e_Personalidad.ninguna
    End With
End Sub

Sub ResetNpcCounters(ByVal NpcIndex As Integer)

Npclist(NpcIndex).Contadores.Paralisis = 0
Npclist(NpcIndex).Contadores.TiempoExistencia = 0

End Sub

Sub ResetNpcCharInfo(ByVal NpcIndex As Integer)

Npclist(NpcIndex).Char.Body = 0
Npclist(NpcIndex).Char.CascoAnim = 0
Npclist(NpcIndex).Char.CharIndex = 0
Npclist(NpcIndex).Char.FX = 0
Npclist(NpcIndex).Char.Head = 0
Npclist(NpcIndex).Char.Heading = 0
Npclist(NpcIndex).Char.loops = 0
Npclist(NpcIndex).Char.ShieldAnim = 0
Npclist(NpcIndex).Char.WeaponAnim = 0


End Sub


Sub ResetNpcCriatures(ByVal NpcIndex As Integer)


Dim j As Integer
For j = 1 To Npclist(NpcIndex).NroCriaturas
    Npclist(NpcIndex).Criaturas(j).NpcIndex = 0
    Npclist(NpcIndex).Criaturas(j).NpcName = vbNullString
Next j

Npclist(NpcIndex).NroCriaturas = 0

End Sub

Sub ResetExpresiones(ByVal NpcIndex As Integer)

Dim j As Integer
For j = 1 To Npclist(NpcIndex).NroExpresiones
    Npclist(NpcIndex).Expresiones(j) = vbNullString
Next j

Npclist(NpcIndex).NroExpresiones = 0

End Sub


Sub ResetNpcMainInfo(ByVal NpcIndex As Integer)

    Npclist(NpcIndex).Attackable = 0
    Npclist(NpcIndex).CanAttack = 0
    Npclist(NpcIndex).Comercia = 0

    Npclist(NpcIndex).GiveGLD = 0
    Npclist(NpcIndex).Hostile = 0
    Npclist(NpcIndex).InvReSpawn = 0

    
    If Npclist(NpcIndex).MaestroUser > 0 Then Call QuitarMascota(Npclist(NpcIndex).MaestroUser, NpcIndex)
    If Npclist(NpcIndex).MaestroNpc > 0 Then Call QuitarMascotaNpc(Npclist(NpcIndex).MaestroNpc)
    
    Npclist(NpcIndex).MaestroUser = 0
    Npclist(NpcIndex).MaestroNpc = 0
    
    Npclist(NpcIndex).Mascotas = 0
    Npclist(NpcIndex).Movement = 0
    Npclist(NpcIndex).name = "NPC SIN INICIAR"
    Npclist(NpcIndex).NPCtype = 0
    Npclist(NpcIndex).numero = 0
    Npclist(NpcIndex).Orig.map = 0
    Npclist(NpcIndex).Orig.X = 0
    Npclist(NpcIndex).Orig.Y = 0
    Npclist(NpcIndex).PoderAtaque = 0
    Npclist(NpcIndex).PoderEvasion = 0
    Npclist(NpcIndex).Pos.map = 0
    Npclist(NpcIndex).Pos.X = 0
    Npclist(NpcIndex).Pos.Y = 0

    Npclist(NpcIndex).Target = 0
    Npclist(NpcIndex).TargetNPC = 0
    Npclist(NpcIndex).TipoItems = 0
    Npclist(NpcIndex).Veneno = 0
    Npclist(NpcIndex).desc = vbNullString
    
    
    '[MODIFICADO] Sistema de Bots de MaTeO
    Dim j As Integer
    Npclist(NpcIndex).Bot.AmigoNPC = 0
    Npclist(NpcIndex).Bot.AmigoUSER = 0
    Npclist(NpcIndex).Bot.Ataques = 0
    Npclist(NpcIndex).Bot.Bloqueado = 0
    Npclist(NpcIndex).Bot.BotType = 0
    Npclist(NpcIndex).Bot.Config = 0
    Npclist(NpcIndex).Bot.MaxMan = 0
    Npclist(NpcIndex).Bot.MinMan = 0
    Npclist(NpcIndex).Bot.Navegando = 0
    Npclist(NpcIndex).Bot.NroSpellsBot = 0
    Npclist(NpcIndex).Bot.RiesgoAT = 0
    Npclist(NpcIndex).Bot.RiesgoHP = 0
    Npclist(NpcIndex).Bot.RiesgoMan = 0
    For j = 1 To Npclist(NpcIndex).Bot.NroSpellsBot
        Npclist(NpcIndex).Bot.SpellsBot(j) = 0
    Next j
    Npclist(NpcIndex).Bot.TargetsDisp = 0
    Npclist(NpcIndex).Bot.ToHP = False
    Npclist(NpcIndex).Bot.ToMan = False
    Npclist(NpcIndex).Bot.UpHP = 0
    Npclist(NpcIndex).Bot.UpMan = 0
    Npclist(NpcIndex).Bot.Zona = 0
    Npclist(NpcIndex).Bando = enone
    Npclist(NpcIndex).inerte = False
    
    Npclist(NpcIndex).Bot.Combeando = 0
    Npclist(NpcIndex).Bot.ComboActual = 0
    Npclist(NpcIndex).Bot.NumComboActual = 0
    Npclist(NpcIndex).Bot.NumCombos = 0
    '[/MODIFICADO] Sistema de Bots de MaTeO
    For j = 1 To Npclist(NpcIndex).NroSpells
        Npclist(NpcIndex).Spells(j) = 0
    Next j
    
    Call ResetNpcCharInfo(NpcIndex)
    Call ResetNpcCriatures(NpcIndex)
    Call ResetExpresiones(NpcIndex)

End Sub

Sub QuitarNPC(ByVal NpcIndex As Integer)

On Error GoTo ErrHandler

    Npclist(NpcIndex).flags.NPCActive = False
    
    If InMapBounds(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y) Then
        Call EraseNPCChar(NpcIndex)
    End If
    
    'Nos aseguramos de que el inventario sea removido...
    'asi los lobos no volveran a tirar armaduras ;))
    'Call ResetNpcInv(NpcIndex)
    Call ResetNpcFlags(NpcIndex)
    Call ResetNpcCounters(NpcIndex)
    
    Call ResetNpcMainInfo(NpcIndex)
    
    If NpcIndex = LastNPC Then
        Do Until Npclist(LastNPC).flags.NPCActive
            LastNPC = LastNPC - 1
            If LastNPC < 1 Then Exit Do
        Loop
    End If
        
      
    If numnpcs <> 0 Then
        numnpcs = numnpcs - 1
    End If
    '[MODIFICADO] Sistema de Bots de MaTeO
    'If Npclist(NpcIndex).Bot.BotType <> 0 Then
        'BotList(Npclist(NpcIndex).Bot.index) = 0
        Call rehacer_lista_bots
    'End If
    '[/MODIFICADO] Sistema de Bots de MaTeO
Exit Sub

ErrHandler:
    Npclist(NpcIndex).flags.NPCActive = False
    Call LogError("Error en QuitarNPC")

End Sub

Function TestSpawnTrigger(Pos As WorldPos, Optional PuedeAgua As Boolean = False) As Boolean
    
    If LegalPos(Pos.map, Pos.X, Pos.Y, PuedeAgua) Then
        TestSpawnTrigger = _
        MapData(Pos.map, Pos.X, Pos.Y).trigger <> 3 And _
        MapData(Pos.map, Pos.X, Pos.Y).trigger <> 2 And _
        MapData(Pos.map, Pos.X, Pos.Y).trigger <> 1
    End If

End Function

Sub CrearNPC(NroNPC As Integer, Mapa As Integer, OrigPos As WorldPos, Optional Bando As eKip = eKip.enone, Optional clon As Integer)
On Error GoTo err:
'Call LogTarea("Sub CrearNPC")
'Crea un NPC del tipo NRONPC
Debug.Print "Creando NPC " & NroNPC
Dim Pos As WorldPos
Dim newpos As WorldPos
Dim altpos As WorldPos
Dim nIndex As Integer
Dim PosicionValida As Boolean
Dim Iteraciones As Long
Dim PuedeAgua As Boolean
Dim PuedeTierra As Boolean


Dim map As Integer
Dim X As Integer
Dim Y As Integer
If clon = 0 Then
    nIndex = OpenNPC(NroNPC) 'Conseguimos un indice
Else
    nIndex = OpenNPCClon(clon) 'Conseguimos un indice
End If
Debug.Print "Creando NPC " & nIndex
    If nIndex > MAXNPCS Then Exit Sub
    PuedeAgua = Npclist(nIndex).flags.AguaValida
    PuedeTierra = IIf(Npclist(nIndex).flags.TierraInvalida = 1, False, True)
    Npclist(nIndex).Bando = Bando
    Npclist(nIndex).inerte = False
    'Necesita ser respawned en un lugar especifico
    If InMapBounds(OrigPos.map, OrigPos.X, OrigPos.Y) Then
        
        map = OrigPos.map
        X = OrigPos.X
        Y = OrigPos.Y
        Npclist(nIndex).Bando = Bando
        Npclist(nIndex).Orig = OrigPos
        Npclist(nIndex).Pos = OrigPos
       
    Else
        
        Pos.map = Mapa 'mapa
        altpos.map = Mapa
        
        Do While Not PosicionValida
            Pos.X = RandomNumber(MinXBorder, MaxXBorder)    'Obtenemos posicion al azar en x
            Pos.Y = RandomNumber(MinYBorder, MaxYBorder)    'Obtenemos posicion al azar en y
            
            Call ClosestLegalPos(Pos, newpos, PuedeAgua, PuedeTierra)  'Nos devuelve la posicion valida mas cercana
            If newpos.X <> 0 And newpos.Y <> 0 Then
                altpos.X = newpos.X
                altpos.Y = newpos.Y     'posicion alternativa (para evitar el anti respawn, pero intentando qeu si tenía que ser en el agua, sea en el agua.)
            Else
                Call ClosestLegalPos(Pos, newpos, PuedeAgua)
                If newpos.X <> 0 And newpos.Y <> 0 Then
                    altpos.X = newpos.X
                    altpos.Y = newpos.Y     'posicion alternativa (para evitar el anti respawn)
                End If
            End If
            'Si X e Y son iguales a 0 significa que no se encontro posicion valida
            If LegalPosNPC(newpos.map, newpos.X, newpos.Y, PuedeAgua) And _
               Not HayPCarea(newpos) And TestSpawnTrigger(newpos, PuedeAgua) Then
                'Asignamos las nuevas coordenas solo si son validas
                Npclist(nIndex).Pos.map = newpos.map
                Npclist(nIndex).Pos.X = newpos.X
                Npclist(nIndex).Pos.Y = newpos.Y
                Npclist(nIndex).Bando = Bando
                PosicionValida = True
            Else
                newpos.X = 0
                newpos.Y = 0
            
            End If
                
            'for debug
            Iteraciones = Iteraciones + 1
            If Iteraciones > MAXSPAWNATTEMPS Then
                If altpos.X <> 0 And altpos.Y <> 0 Then
                    map = altpos.map
                    X = altpos.X
                    Y = altpos.Y
                    Npclist(nIndex).Pos.map = map
                    Npclist(nIndex).Pos.X = X
                    Npclist(nIndex).Pos.Y = Y
                    Npclist(nIndex).Bando = Bando
                    Call MakeNPCChar(True, map, nIndex, map, X, Y)
                    Exit Sub
                Else
                    altpos.X = 50
                    altpos.Y = 50
                    Call ClosestLegalPos(altpos, newpos)
                    If newpos.X <> 0 And newpos.Y <> 0 Then
                        Npclist(nIndex).Pos.map = newpos.map
                        Npclist(nIndex).Pos.X = newpos.X
                        Npclist(nIndex).Pos.Y = newpos.Y
                        Npclist(nIndex).Bando = Bando
                        Call MakeNPCChar(True, newpos.map, nIndex, newpos.map, newpos.X, newpos.Y)
                        Exit Sub
                    Else
                        Call QuitarNPC(nIndex)
                        Call LogError(MAXSPAWNATTEMPS & " iteraciones en CrearNpc Mapa:" & Mapa & " NroNpc:" & NroNPC)
                        Exit Sub
                    End If
                End If
            End If
        Loop
        
        'asignamos las nuevas coordenas
        
        
        Npclist(nIndex).ultimo_proceso = (GetTickCount() And &H7FFFFFFF) + Rnd * 120
        map = newpos.map
        X = Npclist(nIndex).Pos.X
        Y = Npclist(nIndex).Pos.Y
    End If
    Dim XX As Byte
Dim yy As Byte
Dim dofor As Boolean
Dim trigger As eTrigger
If Bando = eKip.ePK Then
trigger = eTrigger.RESUPK
dofor = True
ElseIf Bando = eKip.eCui Then
trigger = eTrigger.RESUCIU
dofor = True
Else
XX = X
yy = Y
End If
Dim salirfor As Boolean
    '[MODIFICADO] Sistema de Bots de MaTeO
    'If Npclist(nIndex).Bot.BotType <> 0 Then
    '    ReDim Preserve BotList(1 To UBound(BotList) + 1) As Integer
    '    BotList(UBound(BotList)) = nIndex
    '    Npclist(nIndex).Bot.index = UBound(BotList)
    'End If
    Call rehacer_lista_bots
    '[/MODIFICADO] Sistema de Bots de MaTeO
If dofor = True Then
For XX = 9 To 90
    If salirfor = False Then
        For yy = 9 To 90
            If MapData(map, XX, yy).trigger = trigger And LegalPos(map, XX, yy, False, True) = True And MapData(map, XX, yy).UserIndex = 0 And MapData(map, XX, yy).NpcIndex = 0 Then
                        Npclist(nIndex).Pos.X = XX
                        Npclist(nIndex).Pos.Y = yy
                        Call MakeNPCChar(True, map, nIndex, map, XX, yy)
                        'Debug.Print "asd" & xx & yy
                        Exit Sub
                        salirfor = True
                        Exit For
            End If
        Next yy
    Else
        Exit For
    End If
Next XX
If salirfor = False Then

salirfor = True
Do While salirfor
XX = RandomNumber(10, 85)
yy = RandomNumber(10, 85)
If LegalPos(servermap, XX, yy, False, True) = True And MapData(servermap, XX, yy).UserIndex = 0 And MapData(servermap, XX, yy).NpcIndex = 0 And MapData(servermap, XX, yy).Blocked = 0 Then
                        Npclist(nIndex).Pos.X = XX
                        Npclist(nIndex).Pos.Y = yy
                        Call MakeNPCChar(True, map, nIndex, map, XX, yy)
                        'Debug.Print "asd" & xx & yy
                        Exit Sub
                        Exit Do
            End If
Loop

End If
Else
Call MakeNPCChar(True, map, nIndex, map, X, Y)
End If
    'Crea el NPC
    
Exit Sub
err:
Debug.Print "¡Error! " & err.Description

End Sub

Sub MakeNPCChar(ByVal toMap As Boolean, sndIndex As Integer, NpcIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)
Dim CharIndex As Integer
Dim Priv As Integer

    If Npclist(NpcIndex).Char.CharIndex = 0 Then
        CharIndex = NextOpenCharIndex
        Npclist(NpcIndex).Char.CharIndex = CharIndex
        CharList(CharIndex) = NpcIndex
    End If
    
    MapData(map, X, Y).NpcIndex = NpcIndex
    
    If Not toMap Then
        If deathm Then Priv = 15
        Call WriteCharacterCreate(sndIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, Npclist(NpcIndex).Char.Heading, Npclist(NpcIndex).Char.CharIndex, X, Y, Npclist(NpcIndex).Char.WeaponAnim, Npclist(NpcIndex).Char.ShieldAnim, 0, 0, Npclist(NpcIndex).Char.CascoAnim, Npclist(NpcIndex).name, IIf(Npclist(NpcIndex).Bando = eKip.eCui, True, False), Priv)
        Call FlushBuffer(sndIndex)
    Else
        Call AgregarNpc(NpcIndex)
    End If
End Sub

Sub MakeNPCClon(ByVal toMap As Boolean, sndIndex As Integer, NpcIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal amo As Integer)
Dim CharIndex As Integer

    If Npclist(NpcIndex).Char.CharIndex = 0 Then
        CharIndex = NextOpenCharIndex
        Npclist(NpcIndex).Char.CharIndex = CharIndex
        CharList(CharIndex) = NpcIndex
    End If
    
    MapData(map, X, Y).NpcIndex = NpcIndex
    Npclist(NpcIndex).Char = UserList(amo).Char
    Npclist(NpcIndex).name = UserList(amo).name
    If Not toMap Then
        Call WriteCharacterCreate(sndIndex, Npclist(NpcIndex).Char.Body, Npclist(NpcIndex).Char.Head, Npclist(NpcIndex).Char.Heading, Npclist(NpcIndex).Char.CharIndex, X, Y, Npclist(NpcIndex).Char.WeaponAnim, Npclist(NpcIndex).Char.ShieldAnim, 0, 0, Npclist(NpcIndex).Char.CascoAnim, Npclist(NpcIndex).name, IIf(Npclist(NpcIndex).Bando = eKip.eCui, True, False), 0)
        Call FlushBuffer(sndIndex)
    Else
        Call AgregarNpc(NpcIndex)
    End If
End Sub

Sub ChangeNPCChar(ByVal NpcIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As eHeading)
    If NpcIndex > 0 Then
        Npclist(NpcIndex).Char.Body = Body
        Npclist(NpcIndex).Char.Head = Head
        Npclist(NpcIndex).Char.Heading = Heading
        
        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterChange(Body, Head, Heading, Npclist(NpcIndex).Char.CharIndex, Npclist(NpcIndex).Char.WeaponAnim, Npclist(NpcIndex).Char.ShieldAnim, 0, 0, Npclist(NpcIndex).Char.CascoAnim))
    End If
End Sub

Sub EraseNPCChar(ByVal NpcIndex As Integer)

If Npclist(NpcIndex).Char.CharIndex <> 0 Then CharList(Npclist(NpcIndex).Char.CharIndex) = 0

If Npclist(NpcIndex).Char.CharIndex = LastChar Then
    Do Until CharList(LastChar) > 0
        LastChar = LastChar - 1
        If LastChar <= 1 Then Exit Do
    Loop
End If

'Quitamos del mapa
MapData(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y).NpcIndex = 0

'Actualizamos los clientes
'Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterRemove(Npclist(NpcIndex).Char.CharIndex))
Call SendData(SendTarget.toMap, Npclist(NpcIndex).Pos.map, PrepareMessageCharacterRemove(Npclist(NpcIndex).Char.CharIndex))

'Update la lista npc
Npclist(NpcIndex).Char.CharIndex = 0


'update NumChars
NumChars = NumChars - 1


End Sub

Sub MoveNPCChar(ByVal NpcIndex As Integer, ByVal nHeading As Byte)

On Error GoTo errh
    '[MODIFICADO] Sistema de Bots de MaTeO
    Npclist(NpcIndex).OldPos.X = Npclist(NpcIndex).Pos.X
    Npclist(NpcIndex).OldPos.Y = Npclist(NpcIndex).Pos.Y
    Npclist(NpcIndex).OldPos.map = Npclist(NpcIndex).Pos.map
    '[/MODIFICADO] Sistema de Bots de MaTeO
    Dim npos As WorldPos
    npos = Npclist(NpcIndex).Pos
    Call HeadtoPos(nHeading, npos)
    
    'Es mascota ????
    If Npclist(NpcIndex).MaestroUser > 0 Then
        'es una posicion legal
        If LegalPos(Npclist(NpcIndex).Pos.map, npos.X, npos.Y, Npclist(NpcIndex).flags.AguaValida = 1) Then
        
            If Npclist(NpcIndex).flags.AguaValida = 0 And HayAgua(Npclist(NpcIndex).Pos.map, npos.X, npos.Y) Then Exit Sub
            If Npclist(NpcIndex).flags.TierraInvalida = 1 And Not HayAgua(Npclist(NpcIndex).Pos.map, npos.X, npos.Y) Then Exit Sub
            

            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterMove(Npclist(NpcIndex).Char.CharIndex, npos.X, npos.Y))
            
            'Update map and user pos
            MapData(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y).NpcIndex = 0
            Npclist(NpcIndex).Pos = npos
            Npclist(NpcIndex).Char.Heading = nHeading
            MapData(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y).NpcIndex = NpcIndex
            Call CheckUpdateNeededNpc(NpcIndex, nHeading)
        End If
Else 'No es mascota
        'Controlamos que la posicion sea legal, los npc que
        'no son mascotas tienen mas restricciones de movimiento.
        If LegalPosNPC(Npclist(NpcIndex).Pos.map, npos.X, npos.Y, Npclist(NpcIndex).flags.AguaValida) Then
            
            If Npclist(NpcIndex).flags.AguaValida = 0 And HayAgua(Npclist(NpcIndex).Pos.map, npos.X, npos.Y) Then Exit Sub
            If Npclist(NpcIndex).flags.TierraInvalida = 1 And Not HayAgua(Npclist(NpcIndex).Pos.map, npos.X, npos.Y) Then Exit Sub
            
            '[Alejo-18-5]
            'server

            Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCharacterMove(Npclist(NpcIndex).Char.CharIndex, npos.X, npos.Y))

            
            'Update map and user pos
            MapData(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y).NpcIndex = 0
            Npclist(NpcIndex).Pos = npos
            Npclist(NpcIndex).Char.Heading = nHeading
            MapData(Npclist(NpcIndex).Pos.map, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y).NpcIndex = NpcIndex
            
            Call CheckUpdateNeededNpc(NpcIndex, nHeading)
        
        Else
            If Npclist(NpcIndex).Movement = TipoAI.NpcPathfinding Then
                'Someone has blocked the npc's way, we must to seek a new path!
                Npclist(NpcIndex).PFINFO.PathLenght = 0
            End If
        
        End If
    End If

Exit Sub

errh:
    LogError ("Error en move npc " & NpcIndex)


End Sub

Function NextOpenNPC() As Integer
'Call LogTarea("Sub NextOpenNPC")

On Error GoTo ErrHandler

Dim loopc As Integer
  
For loopc = 1 To MAXNPCS + 1
    If loopc > MAXNPCS Then Exit For
    If Not Npclist(loopc).flags.NPCActive Then Exit For
Next loopc
  
NextOpenNPC = loopc


Exit Function
ErrHandler:
    Call LogError("Error en NextOpenNPC")
End Function

Sub NpcEnvenenarUser(ByVal UserIndex As Integer)

Dim N As Integer
N = RandomNumber(1, 100)
If N < 30 Then
    UserList(UserIndex).flags.Envenenado = 1
    Call WriteConsoleMsg(UserIndex, "¡¡La criatura te ha envenenado!!", FontTypeNames.FONTTYPE_FIGHT)
End If

End Sub

Function SpawnClon(ByVal NpcIndex As Integer, Pos As WorldPos) As Integer

Dim newpos As WorldPos
Dim altpos As WorldPos
Dim nIndex As Integer
Dim PosicionValida As Boolean
Dim PuedeAgua As Boolean
Dim PuedeTierra As Boolean


Dim map As Integer
Dim X As Integer
Dim Y As Integer
'Dim it As Integer

nIndex = OpenNPC(NpcIndex, False)   'Conseguimos un indice

If nIndex > MAXNPCS Then
    SpawnClon = 0
    Exit Function
End If

PuedeAgua = Npclist(nIndex).flags.AguaValida
'PuedeTierra = IIf(Npclist(nIndex).flags.TierraInvalida = 1, False, True)
PuedeTierra = Not Npclist(nIndex).flags.TierraInvalida = 1

'it = 0

'Do While Not PosicionValida
        
        Call ClosestLegalPos(Pos, newpos, PuedeAgua, PuedeTierra)  'Nos devuelve la posicion valida mas cercana
        Call ClosestLegalPos(Pos, altpos, PuedeAgua)
        'Si X e Y son iguales a 0 significa que no se encontro posicion valida

        If newpos.X <> 0 And newpos.Y <> 0 Then
            'Asignamos las nuevas coordenas solo si son validas
            Npclist(nIndex).Pos.map = newpos.map
            Npclist(nIndex).Pos.X = newpos.X
            Npclist(nIndex).Pos.Y = newpos.Y
            PosicionValida = True
        Else
            If altpos.X <> 0 And altpos.Y <> 0 Then
                Npclist(nIndex).Pos.map = altpos.map
                Npclist(nIndex).Pos.X = altpos.X
                Npclist(nIndex).Pos.Y = altpos.Y
                PosicionValida = True
            Else
                PosicionValida = False
            End If
        End If
        
        'it = it + 1
        
        'If it > MAXSPAWNATTEMPS Then
        If Not PosicionValida Then
            Call QuitarNPC(nIndex)
            SpawnClon = 0
            'Call LogError("Mas de " & MAXSPAWNATTEMPS & " iteraciones en SpawnNpc Mapa:" & Pos.map & " Index:" & NpcIndex)
            Exit Function
        End If
'Loop

'asignamos las nuevas coordenas
map = newpos.map
X = Npclist(nIndex).Pos.X
Y = Npclist(nIndex).Pos.Y

'Crea el NPC
Call MakeNPCChar(True, map, nIndex, map, X, Y)

'If FX Then
    Call SendData(SendTarget.ToNPCArea, nIndex, PrepareMessagePlayWave(SND_WARP, X, Y))
    Call SendData(SendTarget.ToNPCArea, nIndex, PrepareMessageCreateFX(Npclist(nIndex).Char.CharIndex, FXIDs.FXWARP, 0))
'End If

SpawnClon = nIndex

End Function

Function SpawnNpc(ByVal NpcIndex As Integer, Pos As WorldPos, ByVal FX As Boolean, ByVal Respawn As Boolean, Optional ByVal UI As Integer = 0) As Integer
'
'Autor: Unknown (orginal version)
'06/15/2008
'23/01/2007 -> Pablo (ToxicWaste): Creates an NPC of the type Npcindex
'06/15/2008 -> Optimizé el codigo. (NicoNZ)
'
Dim newpos As WorldPos
Dim altpos As WorldPos
Dim nIndex As Integer
Dim PosicionValida As Boolean
Dim PuedeAgua As Boolean
Dim PuedeTierra As Boolean


Dim map As Integer
Dim X As Integer
Dim Y As Integer
'Dim it As Integer
If UI <> 0 Then
nIndex = OpenNPCClon(UI)   'Conseguimos un indice
Else
nIndex = OpenNPC(NpcIndex, Respawn)   'Conseguimos un indice
End If
If nIndex > MAXNPCS Then
    SpawnNpc = 0
    Exit Function
End If

PuedeAgua = Npclist(nIndex).flags.AguaValida
'PuedeTierra = IIf(Npclist(nIndex).flags.TierraInvalida = 1, False, True)
PuedeTierra = Not Npclist(nIndex).flags.TierraInvalida = 1

'it = 0

'Do While Not PosicionValida
        
        Call ClosestLegalPos(Pos, newpos, PuedeAgua, PuedeTierra)  'Nos devuelve la posicion valida mas cercana
        Call ClosestLegalPos(Pos, altpos, PuedeAgua)
        'Si X e Y son iguales a 0 significa que no se encontro posicion valida

        If newpos.X <> 0 And newpos.Y <> 0 Then
            'Asignamos las nuevas coordenas solo si son validas
            Npclist(nIndex).Pos.map = newpos.map
            Npclist(nIndex).Pos.X = newpos.X
            Npclist(nIndex).Pos.Y = newpos.Y
            PosicionValida = True
        Else
            If altpos.X <> 0 And altpos.Y <> 0 Then
                Npclist(nIndex).Pos.map = altpos.map
                Npclist(nIndex).Pos.X = altpos.X
                Npclist(nIndex).Pos.Y = altpos.Y
                PosicionValida = True
            Else
                PosicionValida = False
            End If
        End If
        
        'it = it + 1
        
        'If it > MAXSPAWNATTEMPS Then
        If Not PosicionValida Then
            Call QuitarNPC(nIndex)
            SpawnNpc = 0
            'Call LogError("Mas de " & MAXSPAWNATTEMPS & " iteraciones en SpawnNpc Mapa:" & Pos.map & " Index:" & NpcIndex)
            Exit Function
        End If
'Loop

'asignamos las nuevas coordenas
map = newpos.map
X = Npclist(nIndex).Pos.X
Y = Npclist(nIndex).Pos.Y

'Crea el NPC
Call MakeNPCChar(True, map, nIndex, map, X, Y)

If FX Then
    Call SendData(SendTarget.ToNPCArea, nIndex, PrepareMessagePlayWave(SND_WARP, X, Y))
    Call SendData(SendTarget.ToNPCArea, nIndex, PrepareMessageCreateFX(Npclist(nIndex).Char.CharIndex, FXIDs.FXWARP, 0))
End If

SpawnNpc = nIndex

End Function

Sub ReSpawnNpc(MiNPC As npc)

If (MiNPC.flags.Respawn = 0) Then Call CrearNPC(MiNPC.numero, MiNPC.Pos.map, MiNPC.Orig)

End Sub

'Devuelve el nro de enemigos que hay en el Mapa Map
Function NPCHostiles(ByVal map As Integer) As Integer

Dim NpcIndex As Integer
Dim cont As Integer

'Contador
cont = 0
For NpcIndex = 1 To LastNPC

    '¿esta vivo?
    If Npclist(NpcIndex).flags.NPCActive _
       And Npclist(NpcIndex).Pos.map = map _
       And Npclist(NpcIndex).Hostile = 1 And _
       Npclist(NpcIndex).Stats.Alineacion = 2 Then
            cont = cont + 1
           
    End If
    
Next NpcIndex

NPCHostiles = cont

End Function

Function OpenNPC(ByVal NpcNumber As Integer, Optional ByVal Respawn = True) As Integer

'###################################################
'#               ATENCION PELIGRO                  #
'###################################################
'
'¡¡¡¡ NO USAR GetVar PARA LEER LOS NPCS !!!!
'
'El que ose desafiar esta LEY, se las tendrá que ver
'conmigo. Para leer los NPCS se deberá usar la
'nueva clase clsIniReader.
'
'Alejo
'
'###################################################

Dim NpcIndex As Integer
Dim Leer As clsIniReader

Set Leer = LeerNPCs

NpcIndex = NextOpenNPC

If NpcIndex > MAXNPCS Then 'Limite de npcs
    OpenNPC = NpcIndex
    Exit Function
End If

Npclist(NpcIndex).numero = NpcNumber
Npclist(NpcIndex).name = Leer.GetValue("NPC" & NpcNumber, "Name")
Npclist(NpcIndex).desc = Leer.GetValue("NPC" & NpcNumber, "Desc")

Npclist(NpcIndex).Movement = Val(Leer.GetValue("NPC" & NpcNumber, "Movement"))
Npclist(NpcIndex).flags.OldMovement = Npclist(NpcIndex).Movement

Npclist(NpcIndex).flags.AguaValida = Val(Leer.GetValue("NPC" & NpcNumber, "AguaValida"))
Npclist(NpcIndex).flags.TierraInvalida = Val(Leer.GetValue("NPC" & NpcNumber, "TierraInValida"))
Npclist(NpcIndex).flags.Faccion = Val(Leer.GetValue("NPC" & NpcNumber, "Faccion"))

Npclist(NpcIndex).NPCtype = Val(Leer.GetValue("NPC" & NpcNumber, "NpcType"))

Npclist(NpcIndex).Char.Body = Val(Leer.GetValue("NPC" & NpcNumber, "Body"))
Npclist(NpcIndex).Char.Head = Val(Leer.GetValue("NPC" & NpcNumber, "Head"))
Npclist(NpcIndex).Char.Heading = Val(Leer.GetValue("NPC" & NpcNumber, "Heading"))

Npclist(NpcIndex).Char.CascoAnim = Val(Leer.GetValue("NPC" & NpcNumber, "CascoG"))
Npclist(NpcIndex).Char.ShieldAnim = Val(Leer.GetValue("NPC" & NpcNumber, "EscudoG"))
Npclist(NpcIndex).Char.WeaponAnim = Val(Leer.GetValue("NPC" & NpcNumber, "ArmaG"))


Npclist(NpcIndex).Attackable = Val(Leer.GetValue("NPC" & NpcNumber, "Attackable"))
Npclist(NpcIndex).Comercia = Val(Leer.GetValue("NPC" & NpcNumber, "Comercia"))
Npclist(NpcIndex).Hostile = Val(Leer.GetValue("NPC" & NpcNumber, "Hostile"))
Npclist(NpcIndex).flags.OldHostil = Npclist(NpcIndex).Hostile






Npclist(NpcIndex).Veneno = Val(Leer.GetValue("NPC" & NpcNumber, "Veneno"))

Npclist(NpcIndex).flags.Domable = Val(Leer.GetValue("NPC" & NpcNumber, "Domable"))


Npclist(NpcIndex).GiveGLD = Val(Leer.GetValue("NPC" & NpcNumber, "GiveGLD"))

Npclist(NpcIndex).PoderAtaque = Val(Leer.GetValue("NPC" & NpcNumber, "PoderAtaque"))
Npclist(NpcIndex).PoderEvasion = Val(Leer.GetValue("NPC" & NpcNumber, "PoderEvasion"))

Npclist(NpcIndex).InvReSpawn = Val(Leer.GetValue("NPC" & NpcNumber, "InvReSpawn"))


Npclist(NpcIndex).Stats.MaxHP = Val(Leer.GetValue("NPC" & NpcNumber, "MaxHP"))
Npclist(NpcIndex).Stats.MinHP = Val(Leer.GetValue("NPC" & NpcNumber, "MinHP"))
Npclist(NpcIndex).Stats.MaxMan = Val(Leer.GetValue("NPC" & NpcNumber, "MaxMAN"))
Npclist(NpcIndex).Stats.MinMan = Val(Leer.GetValue("NPC" & NpcNumber, "MinMAN"))
Npclist(NpcIndex).Stats.MaxHit = Val(Leer.GetValue("NPC" & NpcNumber, "MaxHIT"))
Npclist(NpcIndex).Stats.MinHit = Val(Leer.GetValue("NPC" & NpcNumber, "MinHIT"))
Npclist(NpcIndex).Stats.def = Val(Leer.GetValue("NPC" & NpcNumber, "DEF"))
Npclist(NpcIndex).Stats.defM = Val(Leer.GetValue("NPC" & NpcNumber, "DEFm"))
Npclist(NpcIndex).Stats.Alineacion = Val(Leer.GetValue("NPC" & NpcNumber, "Alineacion"))

'[MODIFICADO] Sistema de Bots de MaTeO
Npclist(NpcIndex).Bot.BotType = Val(Leer.GetValue("NPC" & NpcNumber, "Bot"))
Npclist(NpcIndex).Bot.MaxMan = Val(Leer.GetValue("NPC" & NpcNumber, "MaxMan"))
Npclist(NpcIndex).Bot.MinMan = Val(Leer.GetValue("NPC" & NpcNumber, "MinMan"))
Npclist(NpcIndex).Bot.RiesgoHP = Val(Leer.GetValue("NPC" & NpcNumber, "RiesgoHP"))
Npclist(NpcIndex).Bot.RiesgoMan = Val(Leer.GetValue("NPC" & NpcNumber, "RiesgoMAN"))
Npclist(NpcIndex).Bot.RiesgoAT = Val(Leer.GetValue("NPC" & NpcNumber, "RiesgoAT"))
Npclist(NpcIndex).Bot.UpHP = Val(Leer.GetValue("NPC" & NpcNumber, "UpHP"))
Npclist(NpcIndex).Bot.UpMan = Val(Leer.GetValue("NPC" & NpcNumber, "UpMan"))
Npclist(NpcIndex).Bot.ArcoAIM = Val(Leer.GetValue("NPC" & NpcNumber, "ArcoAIM"))
Npclist(NpcIndex).Bot.Apuñala = Val(Leer.GetValue("NPC" & NpcNumber, "Apuñala"))
Npclist(NpcIndex).Bot.Dificultad = CalcularDificultad()
'[MODIFICADO] 3/2/10 Inventario a los BOTS wiwiwiwi :D
If Npclist(NpcIndex).Bot.BotType <> 0 And Npclist(NpcIndex).Char.Body = 0 Then
    Npclist(NpcIndex).Char.Body = 0
    Npclist(NpcIndex).Char.CascoAnim = 0
    Npclist(NpcIndex).Char.ShieldAnim = 0
    Npclist(NpcIndex).Char.WeaponAnim = 0
    If Val(Leer.GetValue("NPC" & NpcNumber, "ArmorOBJ")) <> 0 Then Npclist(NpcIndex).Char.Body = ObjData(Val(Leer.GetValue("NPC" & NpcNumber, "ArmorOBJ"))).Ropaje
    If Val(Leer.GetValue("NPC" & NpcNumber, "CascoOBJ")) <> 0 Then Npclist(NpcIndex).Char.CascoAnim = ObjData(Val(Leer.GetValue("NPC" & NpcNumber, "CascoOBJ"))).CascoAnim
    If Val(Leer.GetValue("NPC" & NpcNumber, "EscudoOBJ")) <> 0 Then Npclist(NpcIndex).Char.ShieldAnim = ObjData(Val(Leer.GetValue("NPC" & NpcNumber, "EscudoOBJ"))).ShieldAnim
    If Val(Leer.GetValue("NPC" & NpcNumber, "ArmaOBJ")) <> 0 Then Npclist(NpcIndex).Char.WeaponAnim = ObjData(Val(Leer.GetValue("NPC" & NpcNumber, "ArmaOBJ"))).WeaponAnim
    Npclist(NpcIndex).Invent.ArmourEqpObjIndex = Val(Leer.GetValue("NPC" & NpcNumber, "ArmorOBJ"))
    Npclist(NpcIndex).Invent.CascoEqpObjIndex = Val(Leer.GetValue("NPC" & NpcNumber, "CascoOBJ"))
    Npclist(NpcIndex).Invent.EscudoEqpObjIndex = Val(Leer.GetValue("NPC" & NpcNumber, "EscudoOBJ"))
    Npclist(NpcIndex).Invent.WeaponEqpObjIndex = Val(Leer.GetValue("NPC" & NpcNumber, "ArmaOBJ"))
End If
'[/MODIFICADO]

Dim loopc As Integer
Dim Loopc2 As Integer
Dim ln As String

Npclist(NpcIndex).Bot.NroSpellsBot = Val(Leer.GetValue("NPC" & NpcNumber, "NroSpellsBot"))
If Npclist(NpcIndex).Bot.NroSpellsBot > 0 Then ReDim Npclist(NpcIndex).Bot.SpellsBot(1 To Npclist(NpcIndex).Bot.NroSpellsBot)
For loopc = 1 To Npclist(NpcIndex).Bot.NroSpellsBot
    Npclist(NpcIndex).Bot.SpellsBot(loopc) = Val(Leer.GetValue("NPC" & NpcNumber, "Att" & loopc))
Next loopc

Npclist(NpcIndex).Bot.NumCombos = Val(Leer.GetValue("NPC" & NpcNumber, "NumCombos"))
If Npclist(NpcIndex).Bot.NumCombos <> 0 Then
    ReDim Npclist(NpcIndex).Bot.Combos(1 To Npclist(NpcIndex).Bot.NumCombos)
    
    For loopc = 1 To Npclist(NpcIndex).Bot.NumCombos
        Npclist(NpcIndex).Bot.Combos(loopc).CantCombos = Val(Leer.GetValue("NPC" & NpcNumber, "NumCombo" & loopc))
        ReDim Npclist(NpcIndex).Bot.Combos(loopc).Num(1 To Npclist(NpcIndex).Bot.Combos(loopc).CantCombos)
        For Loopc2 = 1 To Npclist(NpcIndex).Bot.Combos(loopc).CantCombos
            Npclist(NpcIndex).Bot.Combos(loopc).Num(Loopc2) = Val(ReadField(Loopc2, Leer.GetValue("NPC" & NpcNumber, "Combo" & loopc), Asc("-")))
            Debug.Print Npclist(NpcIndex).Bot.Combos(loopc).Num(Loopc2)
        Next Loopc2
    Next loopc
End If
'1 To Val(ReadField(1, Leer.GetValue("NPC" & NpcNumber, "NumCombos"), Asc("-")))
'[/MODIFICADO] Sistema de Bots de MaTeO

Npclist(NpcIndex).Invent.NroItems = Val(Leer.GetValue("NPC" & NpcNumber, "NROITEMS"))
For loopc = 1 To Npclist(NpcIndex).Invent.NroItems
    ln = Leer.GetValue("NPC" & NpcNumber, "Obj" & loopc)
    Npclist(NpcIndex).Invent.Object(loopc).ObjIndex = Val(ReadField(1, ln, 45))
    Npclist(NpcIndex).Invent.Object(loopc).Amount = Val(ReadField(2, ln, 45))
Next loopc

Npclist(NpcIndex).flags.LanzaSpells = Val(Leer.GetValue("NPC" & NpcNumber, "LanzaSpells"))
If Npclist(NpcIndex).flags.LanzaSpells > 0 Then ReDim Npclist(NpcIndex).Spells(1 To Npclist(NpcIndex).flags.LanzaSpells)
For loopc = 1 To Npclist(NpcIndex).flags.LanzaSpells
    Npclist(NpcIndex).Spells(loopc) = Val(Leer.GetValue("NPC" & NpcNumber, "Sp" & loopc))
Next loopc


If Npclist(NpcIndex).NPCtype = eNPCType.Entrenador Then
    Npclist(NpcIndex).NroCriaturas = Val(Leer.GetValue("NPC" & NpcNumber, "NroCriaturas"))
    ReDim Npclist(NpcIndex).Criaturas(1 To Npclist(NpcIndex).NroCriaturas) As tCriaturasEntrenador
    For loopc = 1 To Npclist(NpcIndex).NroCriaturas
        Npclist(NpcIndex).Criaturas(loopc).NpcIndex = Leer.GetValue("NPC" & NpcNumber, "CI" & loopc)
        Npclist(NpcIndex).Criaturas(loopc).NpcName = Leer.GetValue("NPC" & NpcNumber, "CN" & loopc)
    Next loopc
End If



Npclist(NpcIndex).flags.NPCActive = True
Npclist(NpcIndex).flags.UseAINow = False

If Respawn Then
    Npclist(NpcIndex).flags.Respawn = Val(Leer.GetValue("NPC" & NpcNumber, "ReSpawn"))
Else
    Npclist(NpcIndex).flags.Respawn = 1
End If

Npclist(NpcIndex).flags.BackUp = Val(Leer.GetValue("NPC" & NpcNumber, "BackUp"))
Npclist(NpcIndex).flags.RespawnOrigPos = Val(Leer.GetValue("NPC" & NpcNumber, "OrigPos"))
Npclist(NpcIndex).flags.AfectaParalisis = Val(Leer.GetValue("NPC" & NpcNumber, "AfectaParalisis"))
Npclist(NpcIndex).flags.GolpeExacto = Val(Leer.GetValue("NPC" & NpcNumber, "GolpeExacto"))


Npclist(NpcIndex).flags.Snd1 = Val(Leer.GetValue("NPC" & NpcNumber, "Snd1"))
Npclist(NpcIndex).flags.Snd2 = Val(Leer.GetValue("NPC" & NpcNumber, "Snd2"))
Npclist(NpcIndex).flags.Snd3 = Val(Leer.GetValue("NPC" & NpcNumber, "Snd3"))

'<<<<<<<<<<<<<< Expresiones >>>>>>>>>>>>>>>>

Dim aux As String
aux = Leer.GetValue("NPC" & NpcNumber, "NROEXP")
If LenB(aux) = 0 Then
    Npclist(NpcIndex).NroExpresiones = 0
Else
    Npclist(NpcIndex).NroExpresiones = Val(aux)
    ReDim Npclist(NpcIndex).Expresiones(1 To Npclist(NpcIndex).NroExpresiones) As String
    For loopc = 1 To Npclist(NpcIndex).NroExpresiones
        Npclist(NpcIndex).Expresiones(loopc) = Leer.GetValue("NPC" & NpcNumber, "Exp" & loopc)
    Next loopc
End If

'<<<<<<<<<<<<<< Expresiones >>>>>>>>>>>>>>>>

'Tipo de items con los que comercia
Npclist(NpcIndex).TipoItems = Val(Leer.GetValue("NPC" & NpcNumber, "TipoItems"))

'Update contadores de NPCs
If NpcIndex > LastNPC Then LastNPC = NpcIndex
numnpcs = numnpcs + 1


'Devuelve el nuevo Indice
OpenNPC = NpcIndex

End Function

Function OpenNPCClon(ByVal NpcNumber As Integer) As Integer
Dim NpcIndex As Integer

NpcIndex = NextOpenNPC

If NpcIndex > MAXNPCS Then 'Limite de npcs
    OpenNPCClon = NpcIndex
    Exit Function
End If
With UserList(NpcNumber)
Npclist(NpcIndex).numero = -1
If Len(.modName) <> 0 Then
Npclist(NpcIndex).name = .name & " <" & .modName & ">"
Else
Npclist(NpcIndex).name = .name
End If
Npclist(NpcIndex).desc = ""
Npclist(NpcIndex).Bando = .Bando

Npclist(NpcIndex).Movement = 0
Npclist(NpcIndex).flags.OldMovement = Npclist(NpcIndex).Movement

Npclist(NpcIndex).flags.AguaValida = 0
Npclist(NpcIndex).flags.TierraInvalida = 0
Npclist(NpcIndex).flags.Faccion = 0

Npclist(NpcIndex).NPCtype = 0
With .Char
Npclist(NpcIndex).Char.Body = .Body
Npclist(NpcIndex).Char.Head = .Head
Npclist(NpcIndex).Char.Heading = .Heading

Npclist(NpcIndex).Char.CascoAnim = .CascoAnim
Npclist(NpcIndex).Char.ShieldAnim = .ShieldAnim
Npclist(NpcIndex).Char.WeaponAnim = .WeaponAnim
End With

Npclist(NpcIndex).Attackable = 1
Npclist(NpcIndex).Comercia = 0
Npclist(NpcIndex).Hostile = 1
Npclist(NpcIndex).flags.OldHostil = Npclist(NpcIndex).Hostile


Npclist(NpcIndex).Veneno = 0

Npclist(NpcIndex).flags.Domable = 0


Npclist(NpcIndex).GiveGLD = 0

Npclist(NpcIndex).PoderAtaque = 1
Npclist(NpcIndex).PoderEvasion = 1

Npclist(NpcIndex).InvReSpawn = 0


Npclist(NpcIndex).Stats.MaxHP = .Stats.MaxHP
Npclist(NpcIndex).Stats.MinHP = .Stats.MaxHP
Npclist(NpcIndex).Stats.MaxMan = .Stats.MaxMan
Npclist(NpcIndex).Stats.MinMan = .Stats.MaxMan
Npclist(NpcIndex).Stats.MaxHit = .Stats.MaxHit
Npclist(NpcIndex).Stats.MinHit = .Stats.MaxHit
Npclist(NpcIndex).Stats.def = .Stats.def
Npclist(NpcIndex).Stats.defM = .Stats.def
Npclist(NpcIndex).Stats.Alineacion = 0

Npclist(NpcIndex).Invent.NroItems = 0

Npclist(NpcIndex).flags.LanzaSpells = 0

Npclist(NpcIndex).flags.NPCActive = True
Npclist(NpcIndex).flags.UseAINow = False

Npclist(NpcIndex).flags.Respawn = 1

Npclist(NpcIndex).flags.BackUp = 0
Npclist(NpcIndex).flags.RespawnOrigPos = 0
Npclist(NpcIndex).flags.AfectaParalisis = 1
Npclist(NpcIndex).flags.GolpeExacto = 0

Npclist(NpcIndex).flags.Snd1 = 0
Npclist(NpcIndex).flags.Snd2 = 0
Npclist(NpcIndex).flags.Snd3 = 0

Npclist(NpcIndex).NroExpresiones = 0

'Tipo de items con los que comercia
Npclist(NpcIndex).TipoItems = 0

'Update contadores de NPCs
If NpcIndex > LastNPC Then LastNPC = NpcIndex
numnpcs = numnpcs + 1

'Devuelve el nuevo Indice
OpenNPCClon = NpcIndex
End With
End Function


Sub DoFollow(ByVal NpcIndex As Integer, ByVal UserName As String)

If Npclist(NpcIndex).flags.Follow Then
  Npclist(NpcIndex).flags.AttackedBy = vbNullString
  Npclist(NpcIndex).flags.Follow = False
  If Npclist(NpcIndex).Bot.BotType = 0 Then Npclist(NpcIndex).Movement = Npclist(NpcIndex).flags.OldMovement
  Npclist(NpcIndex).Hostile = Npclist(NpcIndex).flags.OldHostil
Else
  Npclist(NpcIndex).flags.AttackedBy = UserName
  Npclist(NpcIndex).flags.Follow = True
  If Npclist(NpcIndex).Bot.BotType = 0 Then Npclist(NpcIndex).Movement = 4 'follow
  Npclist(NpcIndex).Hostile = 0
End If

End Sub

Sub FollowAmo(ByVal NpcIndex As Integer)

  Npclist(NpcIndex).flags.Follow = True
  If Npclist(NpcIndex).Bot.BotType = 0 Then Npclist(NpcIndex).Movement = TipoAI.SigueAmo 'follow
  Npclist(NpcIndex).Hostile = 0
  Npclist(NpcIndex).Target = 0
  Npclist(NpcIndex).TargetNPC = 0

End Sub

