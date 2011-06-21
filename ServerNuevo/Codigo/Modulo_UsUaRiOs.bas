Attribute VB_Name = "UsUaRiOs"
Option Explicit

Sub ActStats(ByVal VictimIndex As Integer, ByVal AttackerIndex As Integer)

Dim DaExp As Long
Dim EraCriminal As Boolean

DaExp = UserList(VictimIndex).Stats.ELV * 500

UserList(AttackerIndex).Stats.Exp = UserList(AttackerIndex).Stats.Exp + DaExp
If UserList(AttackerIndex).Stats.Exp > MAXEXP Then _
    UserList(AttackerIndex).Stats.Exp = MAXEXP

'Lo mata
Call WriteConsoleMsg(AttackerIndex, "Has matado a " & UserList(VictimIndex).name & "!", FontTypeNames.FONTTYPE_FIGHT)
Call WriteConsoleMsg(VictimIndex, UserList(AttackerIndex).name & " te ha matado!", FontTypeNames.FONTTYPE_FIGHT)

Call UserDie(VictimIndex)

If UserList(AttackerIndex).Stats.UsuariosMatados < MAXUSERMATADOS Then _
    UserList(AttackerIndex).Stats.UsuariosMatados = UserList(AttackerIndex).Stats.UsuariosMatados + 1

Call FlushBuffer(VictimIndex)

'Log

End Sub

Sub RevivirUsuario(ByVal UserIndex As Integer)
If UserList(UserIndex).Bando = eKip.enone Then Exit Sub
UserList(UserIndex).flags.Muerto = 0
UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MaxHP '[MODIFICADO] Puse de 10 a MaxHP
UserList(UserIndex).pasos_desde_resu = 0

'No puede estar empollando
UserList(UserIndex).flags.EstaEmpo = 0
UserList(UserIndex).EmpoCont = 0

If UserList(UserIndex).Stats.MinHP > UserList(UserIndex).Stats.MaxHP Then
    UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MaxHP
End If

If UserList(UserIndex).flags.Navegando = 1 Then
    Dim Barco As ObjData
    Barco = ObjData(UserList(UserIndex).Invent.BarcoObjIndex)
    UserList(UserIndex).Char.Head = 0
    
    If UserList(UserIndex).Faccion.ArmadaReal = 1 Then
        UserList(UserIndex).Char.Body = iFragataReal
    ElseIf UserList(UserIndex).Faccion.FuerzasCaos = 1 Then
        UserList(UserIndex).Char.Body = iFragataCaos
    Else
        If criminal(UserIndex) Then
            If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaPk
            If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraPk
            If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonPk
        Else
            If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaCiuda
            If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraCiuda
            If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonCiuda
        End If
    End If
    
    UserList(UserIndex).Char.ShieldAnim = NingunEscudo
    UserList(UserIndex).Char.WeaponAnim = NingunArma
    UserList(UserIndex).Char.CascoAnim = NingunCasco

Else
    Call DarCuerpoDesnudo(UserIndex)
    '[MODIFICADO] AutoEquiparse
    Call EquiparTodo(UserIndex)
    '[/MODIFICADO] AutoEquiparse
    UserList(UserIndex).Char.Head = UserList(UserIndex).OrigChar.Head
End If



Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
Call WriteUpdateUserStats(UserIndex)

End Sub


Sub RevivirUsuario1(ByVal UserIndex As Integer)
'If UserList(UserIndex).bando = eKip.eNone Then Exit Sub
If UserList(UserIndex).Bando <> enone Then
Dim ipa As Integer
ipa = UserList(UserIndex).flags.Muerto
    UserList(UserIndex).flags.Muerto = 0
    UserList(UserIndex).pasos_desde_resu = 0
    UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MaxHP
    UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MaxMan
    If UserList(UserIndex).flags.Paralizado Then
        Call WriteParalizeOK(UserIndex)
        UserList(UserIndex).flags.Paralizado = 0
        UserList(UserIndex).flags.Inmovilizado = 0
    End If

    'No puede estar empollando
    UserList(UserIndex).flags.EstaEmpo = 0
    UserList(UserIndex).EmpoCont = 0

    If UserList(UserIndex).flags.Navegando Then
        Dim Barco As ObjData
        Barco = ObjData(UserList(UserIndex).Invent.BarcoObjIndex)
        UserList(UserIndex).Char.Head = 0
            
        If UserList(UserIndex).Faccion.ArmadaReal = 1 Then
            UserList(UserIndex).Char.Body = iFragataReal
        ElseIf UserList(UserIndex).Faccion.FuerzasCaos = 1 Then
            UserList(UserIndex).Char.Body = iFragataCaos
        Else
            If criminal(UserIndex) Then
                If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaPk
                If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraPk
                If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonPk
            Else
                If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaCiuda
                If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraCiuda
                If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonCiuda
            End If
        End If
        UserList(UserIndex).Char.ShieldAnim = NingunEscudo
        UserList(UserIndex).Char.WeaponAnim = NingunArma
        UserList(UserIndex).Char.CascoAnim = NingunCasco
    Else
        If ipa = 1 Then
           Call DarCuerpoDesnudo(UserIndex)
        End If
        Call EquiparTodo(UserIndex)
    End If
    UserList(UserIndex).Char.Head = UserList(UserIndex).OrigChar.Head
    

Else
Llevararand UserIndex
End If
Dim asdf As New clsIntervalos
asdf.WriteIntervals UserIndex
'Call WriteMiniStats(UserIndex)
Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
Call WriteUpdateUserStats(UserIndex)

End Sub


Sub ChangeUserChar(ByVal UserIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, _
                    ByVal Arma As Integer, ByVal Escudo As Integer, ByVal casco As Integer)

    With UserList(UserIndex).Char
        .Body = Body
        .Head = Head
        .Heading = Heading
        .WeaponAnim = Arma
        .ShieldAnim = Escudo
        .CascoAnim = casco
    End With
    
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCharacterChange(Body, Head, Heading, UserList(UserIndex).Char.CharIndex, Arma, Escudo, UserList(UserIndex).Char.FX, UserList(UserIndex).Char.loops, casco))
End Sub

Sub EnviarFama(ByVal UserIndex As Integer)
    Dim L As Long
    
    L = (-UserList(UserIndex).Reputacion.AsesinoRep) + _
        (-UserList(UserIndex).Reputacion.BandidoRep) + _
        UserList(UserIndex).Reputacion.BurguesRep + _
        (-UserList(UserIndex).Reputacion.LadronesRep) + _
        UserList(UserIndex).Reputacion.NobleRep + _
        UserList(UserIndex).Reputacion.PlebeRep
    L = Round(L / 6)
    
    UserList(UserIndex).Reputacion.Promedio = L
    

End Sub

Sub EraseUserChar(ByVal UserIndex As Integer)

'On Error GoTo ErrorHandler
    If UserList(UserIndex).Char.CharIndex > 0 Then
        CharList(UserList(UserIndex).Char.CharIndex) = 0
    Else
        Exit Sub
    End If
    If UserList(UserIndex).Char.CharIndex = LastChar Then
        Do Until CharList(LastChar) > 0
            LastChar = LastChar - 1
            If LastChar <= 1 Then Exit Do
        Loop
    End If
    
    'Le mandamos el mensaje para que borre el personaje a los clientes que estén cerca
    'Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCharacterRemove(UserList(UserIndex).Char.CharIndex))
    Call SendData(SendTarget.toMap, UserList(UserIndex).Pos.map, PrepareMessageCharacterRemove(UserList(UserIndex).Char.CharIndex))
    Call QuitarUser(UserIndex, UserList(UserIndex).Pos.map)
    
    MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = 0
    UserList(UserIndex).Char.CharIndex = 0
    
    NumChars = NumChars - 1
Exit Sub
    
ErrorHandler:
        Call LogError("Error en EraseUserchar " & err.Number & ": " & err.Description)
End Sub

Sub RefreshCharStatus(ByVal UserIndex As Integer)
    Dim klan As String
    Dim Barco As ObjData
    
    If Len(UserList(UserIndex).modName) > 0 Then
        klan = UserList(UserIndex).modName
        klan = " <" & klan & ">"
    End If
    
    If UserList(UserIndex).showName And UserList(UserIndex).Bando <> enone Then
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageUpdateTagAndStatus(UserIndex, criminal(UserIndex), UserList(UserIndex).name & klan))
    Else
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageUpdateTagAndStatus(UserIndex, criminal(UserIndex), vbNullString))
    End If
    
    'Si esta navengando, se cambia la barca.
    If UserList(UserIndex).flags.Navegando Then
        Barco = ObjData(UserList(UserIndex).Invent.Object(UserList(UserIndex).Invent.BarcoSlot).ObjIndex)
        
        If UserList(UserIndex).Faccion.ArmadaReal = 1 Then
            UserList(UserIndex).Char.Body = iFragataReal
        ElseIf UserList(UserIndex).Faccion.FuerzasCaos = 1 Then
            UserList(UserIndex).Char.Body = iFragataCaos
        Else
            If criminal(UserIndex) Then
                If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaPk
                If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraPk
                If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonPk
            Else
                If Barco.Ropaje = iBarca Then UserList(UserIndex).Char.Body = iBarcaCiuda
                If Barco.Ropaje = iGalera Then UserList(UserIndex).Char.Body = iGaleraCiuda
                If Barco.Ropaje = iGaleon Then UserList(UserIndex).Char.Body = iGaleonCiuda
            End If
        End If
        
        Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
    End If
End Sub

Sub MakeUserChar(ByVal toMap As Boolean, ByVal sndIndex As Integer, ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)

On Error GoTo hayerror
    If InMapBounds(map, X, Y) Then
        Dim CharIndex As Integer
        'If needed make a new character in list
        If UserList(UserIndex).Char.CharIndex = 0 Then
            CharIndex = NextOpenCharIndex
            UserList(UserIndex).Char.CharIndex = CharIndex
            CharList(CharIndex) = UserIndex
        End If
        
        'Place character on map if needed
        If toMap Then _
            MapData(map, X, Y).UserIndex = UserIndex
        
        'Send make character command to clients
        Dim klan As String
        If Len(UserList(UserIndex).modName) > 0 Then
            klan = UserList(UserIndex).modName
        End If
        
        Dim bCr As Byte
        
        bCr = criminal(UserIndex)
        
        If LenB(klan) <> 0 Then
            If Not toMap Then
                If UserList(UserIndex).showName Then
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, UserList(UserIndex).name & " <" & klan & ">", bCr, color_nick_user(UserIndex))
                Else
                    'Hide the name and clan - set privs as normal user
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, vbNullString, bCr, PlayerType.User)
                End If
            Else
                Call AgregarUser(UserIndex, UserList(UserIndex).Pos.map)
            End If
        Else 'if tiene clan
            If Not toMap Then
                If UserList(UserIndex).showName Then
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, UserList(UserIndex).name, bCr, color_nick_user(UserIndex))
                Else
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, vbNullString, bCr, PlayerType.User)
                End If
            Else
                Call AgregarUser(UserIndex, UserList(UserIndex).Pos.map)
            End If
        End If 'if clan
        If UserList(UserIndex).Char.Particula <> 0 Then
            If Not toMap Then
                Call WriteCreatePGP(sndIndex, UserList(UserIndex).Char.CharIndex, UserList(UserIndex).Char.Particula, 0, 1)
            Else
                Call SendData(SendTarget.toMap, UserList(UserIndex).Pos.map, PrepareMessageCreatePGP(UserList(UserIndex).Char.CharIndex, UserList(UserIndex).Char.Particula, 0, 1))
            End If
        End If
    End If
Exit Sub

hayerror:
    LogError ("MakeUserChar: num: " & err.Number & " desc: " & err.Description)
    'Resume Next
    Call CloseSocket(UserIndex)
End Sub




Function color_nick_user(UI As Integer)
If UserList(UI).dios = 255 Then
    color_nick_user = 255
Else
    If (UserList(UI).Bando = eKip.enone) Then
        color_nick_user = 8
    Else
        If deathm = False Then
            If UserList(UI).dios > 127 Then
                color_nick_user = 20
            Else
                color_nick_user = UserList(UI).flags.Privilegios
            End If
        Else
           color_nick_user = 15
        End If
    End If
End If
End Function




Sub CheckUserLevel(ByVal UserIndex As Integer)

End Sub

Function PuedeAtravesarAgua(ByVal UserIndex As Integer) As Boolean

PuedeAtravesarAgua = _
  UserList(UserIndex).flags.Navegando = 1 Or _
  UserList(UserIndex).flags.Vuela = 1

End Function


Sub MoveUserChar(ByVal UserIndex As Integer, ByVal nHeading As eHeading)

      Dim npos As WorldPos
      Dim sailing As Boolean
      Dim ntmp As Integer

          'sailing = PuedeAtravesarAgua(UserIndex)
   On Error GoTo MoveUserChar_Error

10        npos = UserList(UserIndex).Pos
20        Call HeadtoPos(nHeading, npos)
          
30        If LegalPos(UserList(UserIndex).Pos.map, npos.X, npos.Y, False, True) Then
40            If MapInfo(UserList(UserIndex).Pos.map).NumUsers > 1 Then
                  'si no estoy solo en el mapa...
50                Call SendData(SendTarget.ToPCAreaButIndex, UserIndex, PrepareMessageCharacterMove(UserList(UserIndex).Char.CharIndex, npos.X, npos.Y))
60            End If
              
              'Update map and user pos
70            MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = 0
80            UserList(UserIndex).Pos = npos
90            UserList(UserIndex).Char.Heading = nHeading
100           MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = UserIndex
110           If UserList(UserIndex).NroMascotas > 0 Then
                  If UserList(UserIndex).NroMascotas <= MAXMASCOTAS Then
                    UserList(UserIndex).NroMascotas = 0
                  Else
120                   For ntmp = 1 To UserList(UserIndex).NroMascotas
                         If UserList(UserIndex).MascotasIndex(ntmp) <> 0 Then
130                         If Npclist(UserList(UserIndex).MascotasIndex(ntmp)).numero = -1 Then
140                               GreedyWalkTo UserList(UserIndex).MascotasIndex(ntmp), UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y
150                         End If
                         End If
160                   Next ntmp
                  End If
170           End If
              'Actualizamos las áreas de ser necesario
180           Call ModAreas.CheckUpdateNeededUser(UserIndex, nHeading)
              'If antilag Then Call WriteMoveByHead(UserIndex, nHeading)
190       ElseIf MapData(UserList(UserIndex).Pos.map, npos.X, npos.Y).UserIndex > 0 Then
200               ntmp = MapData(UserList(UserIndex).Pos.map, npos.X, npos.Y).UserIndex
210               If UserList(ntmp).flags.Muerto = 1 Then
                      Dim HE As eHeading
220                   Select Case nHeading
                          Case eHeading.EAST
230                           HE = WEST
240                       Case eHeading.WEST
250                           HE = EAST
260                       Case eHeading.NORTH
270                           HE = SOUTH
280                       Case eHeading.SOUTH
290                           HE = NORTH
300                   End Select
310                   Call SendData(SendTarget.ToPCAreaButIndex, ntmp, PrepareMessageCharacterMove(UserList(ntmp).Char.CharIndex, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
320                   Call SendData(SendTarget.ToPCAreaButIndex, UserIndex, PrepareMessageCharacterMove(UserList(UserIndex).Char.CharIndex, npos.X, npos.Y))
330                   Call ModAreas.CheckUpdateNeededUser(UserIndex, nHeading)
340                   Call ModAreas.CheckUpdateNeededUser(ntmp, HE)
350                   Call WriteMoveByHead(ntmp, HE)
360                   UserList(ntmp).Pos = UserList(UserIndex).Pos
370                   UserList(ntmp).Char.Heading = HE
380                   MapData(UserList(ntmp).Pos.map, UserList(ntmp).Pos.X, UserList(ntmp).Pos.Y).UserIndex = ntmp
390                   UserList(UserIndex).Pos = npos
400                   UserList(UserIndex).Char.Heading = nHeading
410                   MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = UserIndex
420               Else
430                   Call WritePosUpdate(UserIndex)
440               End If
450       Else
460           Call WritePosUpdate(UserIndex)
470       End If
          
480       If UserList(UserIndex).Counters.Trabajando Then _
              UserList(UserIndex).Counters.Trabajando = UserList(UserIndex).Counters.Trabajando - 1

490       If UserList(UserIndex).Counters.Ocultando Then _
              UserList(UserIndex).Counters.Ocultando = UserList(UserIndex).Counters.Ocultando - 1
Exit Sub

MoveUserChar_Error:
LogError "MoveUserChar_Error " & err.Number & err.Description & Erl
erla = Erl()
Resume

End Sub

Sub ChangeUserInv(ByVal UserIndex As Integer, ByVal Slot As Byte, ByRef Object As UserOBJ)
    UserList(UserIndex).Invent.Object(Slot) = Object
    Call WriteChangeInventorySlot(UserIndex, Slot)
End Sub

Function NextOpenCharIndex() As Integer
    Dim loopc As Long
    
    For loopc = 1 To MAXCHARS
        If CharList(loopc) = 0 Then
            NextOpenCharIndex = loopc
            NumChars = NumChars + 1
            
            If loopc > LastChar Then _
                LastChar = loopc
            
            Exit Function
        End If
    Next loopc
End Function

Function NextOpenUser() As Integer
    Dim loopc As Long
    
    For loopc = 1 To maxusers + 1
        If loopc > maxusers Then Exit For
        If (UserList(loopc).ConnID = -1 And UserList(loopc).flags.UserLogged = False) Then Exit For
    Next loopc
    
    NextOpenUser = loopc
End Function

Function DameUserindex(SocketId As Integer) As Integer

Dim loopc As Integer
  
loopc = 1
  
Do Until UserList(loopc).ConnID = SocketId

    loopc = loopc + 1
    
    If loopc > maxusers Then
        DameUserindex = 0
        Exit Function
    End If
    
Loop
  
DameUserindex = loopc

End Function

Function DameUserIndexConNombre(ByVal nombre As String) As Integer

Dim loopc As Integer
  
loopc = 1
  
nombre = UCase$(nombre)

Do Until UCase$(UserList(loopc).name) = nombre

    loopc = loopc + 1
    
    If loopc > maxusers Then
        DameUserIndexConNombre = 0
        Exit Function
    End If
    
Loop
  
DameUserIndexConNombre = loopc

End Function


Function EsMascotaCiudadano(ByVal NpcIndex As Integer, ByVal UserIndex As Integer) As Boolean

If Npclist(NpcIndex).MaestroUser > 0 Then
        EsMascotaCiudadano = Not criminal(Npclist(NpcIndex).MaestroUser)
        If EsMascotaCiudadano Then
            Call WriteConsoleMsg(Npclist(NpcIndex).MaestroUser, "¡¡" & UserList(UserIndex).name & " esta atacando tu mascota!!", FontTypeNames.FONTTYPE_INFO)
        End If
End If

End Function

Sub NPCAtacado(ByVal NpcIndex As Integer, ByVal UserIndex As Integer)
Dim EraCriminal As Boolean

'Guardamos el usuario que ataco el npc.
Npclist(NpcIndex).flags.AttackedBy = UserList(UserIndex).name

'[MODIFICADO] 4/2/10 Si atacas al bot, el bot te persigue.
If RandomNumber(1, 3) = 2 Then
    Npclist(NpcIndex).TargetNPC = 0
    If RandomNumber(1, 3) = 2 And UserIndex <> Npclist(NpcIndex).Target Then Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageChatOverHead("¡Me cansaste te voy a matar a vos " & UserList(UserIndex).name & "!", Npclist(NpcIndex).Char.CharIndex, vbWhite))
    Npclist(NpcIndex).Target = UserIndex 'Me atacas a mi?? A bueno, ahora te hago fruta!!
End If
'[/MODIFICADO] 4/2/10

'Npc que estabas atacando.
Dim LastNpcHit As Integer
LastNpcHit = UserList(UserIndex).flags.NPCAtacado
'Guarda el NPC que estas atacando ahora.
UserList(UserIndex).flags.NPCAtacado = NpcIndex

If Npclist(NpcIndex).MaestroUser > 0 Then
    If Npclist(NpcIndex).MaestroUser <> UserIndex Then
        Call AllMascotasAtacanUser(UserIndex, Npclist(NpcIndex).MaestroUser)
    End If
End If
    
    If Npclist(NpcIndex).MaestroUser <> UserIndex Then
        'hacemos que el npc se defienda
        If Npclist(NpcIndex).Bot.BotType = 0 Then Npclist(NpcIndex).Movement = TipoAI.NPCDEFENSA
        Npclist(NpcIndex).Hostile = 1
    End If


End Sub

Function PuedeApuñalar(ByVal UserIndex As Integer) As Boolean

If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
 PuedeApuñalar = (ObjData(UserList(UserIndex).Invent.WeaponEqpObjIndex).Apuñala = 1)
Else
 PuedeApuñalar = False
End If
End Function


''
'Muere un usuario
'
'UserIndex  Indice del usuario que muere
'



Sub UserDieInterno(ByVal UserIndex As Integer)
'*
'Author: Uknown
'Last Modified: 04/15/2008 (NicoNZ)
'Ahora se resetea el counter del invi
'*
On Error GoTo ErrorHandler
    Dim i As Long
    Dim aN As Integer
    
    'Quitar el dialogo del user muerto
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageRemoveCharDialog(UserList(UserIndex).Char.CharIndex))
    
    UserList(UserIndex).Stats.MinHP = 0
    UserList(UserIndex).Stats.MinSta = 0
    UserList(UserIndex).flags.AtacadoPorUser = 0
    UserList(UserIndex).flags.Envenenado = 0
    UserList(UserIndex).flags.Muerto = 1
    UserList(UserIndex).flags.SeguroResu = False
    
    aN = UserList(UserIndex).flags.AtacadoPorNpc
    If aN > 0 Then
        If Npclist(aN).Bot.BotType = 0 Then Npclist(aN).Movement = Npclist(aN).flags.OldMovement
        Npclist(aN).Hostile = Npclist(aN).flags.OldHostil
        Npclist(aN).flags.AttackedBy = vbNullString
    End If
    
    aN = UserList(UserIndex).flags.NPCAtacado
    If aN > 0 Then
        If Npclist(aN).flags.AttackedFirstBy = UserList(UserIndex).name Then
            Npclist(aN).flags.AttackedFirstBy = vbNullString
        End If
    End If
    UserList(UserIndex).flags.AtacadoPorNpc = 0
    UserList(UserIndex).flags.NPCAtacado = 0
    
    '<<<< Paralisis >>>>
    If UserList(UserIndex).flags.Paralizado = 1 Then
        UserList(UserIndex).flags.Paralizado = 0
        Call WriteParalizeOK(UserIndex)
    End If
    
    '<<< Estupidez >>>
    If UserList(UserIndex).flags.Estupidez = 1 Then
        UserList(UserIndex).flags.Estupidez = 0
        Call WriteDumbNoMore(UserIndex)
    End If
    
    '<<<< Meditando >>>>
    If UserList(UserIndex).flags.Meditando Then
        UserList(UserIndex).flags.Meditando = False
        Call WriteMeditateToggle(UserIndex)
    End If
    
    '<<<< Invisible >>>>
    If UserList(UserIndex).flags.invisible = 1 Or UserList(UserIndex).flags.Oculto = 1 Then
        UserList(UserIndex).flags.Oculto = 0
        UserList(UserIndex).flags.invisible = 0
        UserList(UserIndex).Counters.TiempoOculto = 0
        UserList(UserIndex).Counters.Invisibilidad = 0
        'no hace falta encriptar este NOVER
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
    End If
    
    'DESEQUIPA TODOS LOS OBJETOS
    'desequipar armadura
    If UserList(UserIndex).Invent.ArmourEqpObjIndex > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.ArmourEqpSlot)
    End If
    'desequipar arma
    If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.WeaponEqpSlot)
    End If
    'desequipar casco
    If UserList(UserIndex).Invent.CascoEqpObjIndex > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.CascoEqpSlot)
    End If
    'desequipar herramienta
    If UserList(UserIndex).Invent.AnilloEqpSlot > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.AnilloEqpSlot)
    End If
    'desequipar municiones
    If UserList(UserIndex).Invent.MunicionEqpObjIndex > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.MunicionEqpSlot)
    End If
    'desequipar escudo
    If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then
        Call Desequipar(UserIndex, UserList(UserIndex).Invent.EscudoEqpSlot)
    End If
    
    '<< Reseteamos los posibles FX sobre el personaje >>
    If UserList(UserIndex).Char.loops = INFINITE_LOOPS Then
        UserList(UserIndex).Char.FX = 0
        UserList(UserIndex).Char.loops = 0
    End If
    
    '<< Restauramos el mimetismo
    If UserList(UserIndex).flags.Mimetizado = 1 Then
        UserList(UserIndex).Char.Body = UserList(UserIndex).CharMimetizado.Body
        UserList(UserIndex).Char.Head = UserList(UserIndex).CharMimetizado.Head
        UserList(UserIndex).Char.CascoAnim = UserList(UserIndex).CharMimetizado.CascoAnim
        UserList(UserIndex).Char.ShieldAnim = UserList(UserIndex).CharMimetizado.ShieldAnim
        UserList(UserIndex).Char.WeaponAnim = UserList(UserIndex).CharMimetizado.WeaponAnim
        UserList(UserIndex).Counters.Mimetismo = 0
        UserList(UserIndex).flags.Mimetizado = 0
    End If
    
    '<< Restauramos los atributos >>
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Fuerza) = 18 + ModRaza(UserRaza).Fuerza
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad) = 18 + ModRaza(UserRaza).Agilidad
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Inteligencia) = 18 + ModRaza(UserList(UserIndex).raza).Inteligencia
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Carisma) = 18 + ModRaza(UserList(UserIndex).raza).Carisma
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Constitucion) = 18 + ModRaza(UserList(UserIndex).raza).Constitucion
    
    '<< Cambiamos la apariencia del char >>
    If UserList(UserIndex).Bando = eKip.ePK Then
        If UserList(UserIndex).flags.Navegando = 0 Then
            UserList(UserIndex).Char.Body = iCuerpoMuerto
            UserList(UserIndex).Char.Head = iCabezaMuerto
            UserList(UserIndex).Char.ShieldAnim = NingunEscudo
            UserList(UserIndex).Char.WeaponAnim = NingunArma
            UserList(UserIndex).Char.CascoAnim = NingunCasco
        Else
            UserList(UserIndex).Char.Body = iFragataFantasmal ';)
        End If
    Else
        If UserList(UserIndex).flags.Navegando = 0 Then
            UserList(UserIndex).Char.Body = 145
            UserList(UserIndex).Char.Head = 501
            UserList(UserIndex).Char.ShieldAnim = NingunEscudo
            UserList(UserIndex).Char.WeaponAnim = NingunArma
            UserList(UserIndex).Char.CascoAnim = NingunCasco
        Else
            UserList(UserIndex).Char.Body = iFragataFantasmal ';)
        End If
    End If
    
    For i = 1 To MAXMASCOTAS
        If UserList(UserIndex).MascotasIndex(i) > 0 Then
            Call MuereNpc(UserList(UserIndex).MascotasIndex(i), 0)
        End If
    Next i
    
    UserList(UserIndex).NroMascotas = 0
    
    '<< Actualizamos clientes >>
    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, NingunArma, NingunEscudo, NingunCasco)
    Call WriteUpdateUserStats(UserIndex)

Exit Sub

ErrorHandler:
    Call LogError("Error en SUB USERDIE. Error: " & err.Number & " Descripción: " & err.Description)
End Sub




Sub UserDie(ByVal UserIndex As Integer, Optional ByVal PasarTeam As Boolean = False)
'*
'Author: Uknown
'Last Modified: 04/15/2008 (NicoNZ)
'Ahora se resetea el counter del invi
'*
On Error GoTo ErrorHandler
    Dim i As Long
    Dim aN As Integer
'[MODIFICADO] Modalidad Redrover
    If frmMain.redroms = vbChecked And UserList(UserIndex).flags.Muerto = 0 And UserList(UserIndex).Bando <> eKip.enone And PasarTeam = False Then
        Debug.Print "AutoResucitando"
        UserList(UserIndex).flags.Muerto = 0
        UserList(UserIndex).pasos_desde_resu = 0
        UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MaxHP
        UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MaxMan
        If UserList(UserIndex).flags.Paralizado Then
            Call WriteParalizeOK(UserIndex)
            UserList(UserIndex).flags.Paralizado = 0
            UserList(UserIndex).flags.Inmovilizado = 0
        End If
        equipos(UserList(UserIndex).Bando).NumJugadores = equipos(UserList(UserIndex).Bando).NumJugadores - 1
        If UserList(UserIndex).Bando = eKip.eCui Then
            UserList(UserIndex).Bando = eKip.ePK
            Debug.Print "LO PASE A ROJO"
        ElseIf UserList(UserIndex).Bando = eKip.ePK Then
            UserList(UserIndex).Bando = eKip.eCui
            Debug.Print "LO PASE A AZUL"
        End If
        equipos(UserList(UserIndex).Bando).NumJugadores = equipos(UserList(UserIndex).Bando).NumJugadores + 1
'        equipos(0).NumJugadores = 0
'        equipos(1).NumJugadores = 0
'        equipos(2).NumJugadores = 0
'        For i = 1 To LastUser
'            If UserList(UserIndex).name <> "" Then
'                equipos(UserList(i).Bando).NumJugadores = equipos(UserList(i).Bando).NumJugadores + 1
'            End If
'        Next i
        Debug.Print "Equipo 1: " & equipos(1).NumJugadores
        Debug.Print "Equipo 2: " & equipos(2).NumJugadores
        If equipos(1).NumJugadores = 0 Or equipos(2).NumJugadores = 0 Then
            Call frmMain.roundstart
            Debug.Print "Reiniciamos!"
        End If
        'Call WarpUserChar(UserIndex, UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.Y + 1, False)
        'Call WarpUserChar(UserIndex, UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.Y - 1, True)
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageUpdateTagAndStatus(UserIndex, criminal(UserIndex), UserList(UserIndex).name))
        Debug.Print "Lo pase de team correctamente... creo..."
        Call EraseUserChar(UserIndex)
        Call MakeUserChar(True, UserList(UserIndex).Pos.map, UserIndex, UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y)
        Call WriteUserCharIndexInServer(UserIndex)
        'Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
        Call WriteUpdateUserStats(UserIndex)
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, FXIDs.FXWARP, 0))
        If UserList(UserIndex).Bando = eKip.eCui Then
            Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat(UserList(UserIndex).nick & " ahora es del equipo rojo."))
        ElseIf UserList(UserIndex).Bando = eKip.ePK Then
            Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat(UserList(UserIndex).nick & " ahora es del equipo azul."))
        End If
        UserList(UserIndex).flags.Paralizado = 0
        UserList(UserIndex).flags.Inmovilizado = 0
        Call WriteParalizeOK(UserIndex)
        Exit Sub
    End If
'[/MODIFICADO] Modalidad Redrover

    UserList(UserIndex).OldInvent = UserList(UserIndex).Invent
    'Sonido
    If UserList(UserIndex).genero = eGenero.Mujer Then
        Call SonidosMapas.ReproducirSonido(SendTarget.ToPCArea, UserIndex, e_SoundIndex.MUERTE_MUJER)
    Else
        Call SonidosMapas.ReproducirSonido(SendTarget.ToPCArea, UserIndex, e_SoundIndex.MUERTE_HOMBRE)
    End If
    
    'Quitar el dialogo del user muerto
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageRemoveCharDialog(UserList(UserIndex).Char.CharIndex))
    
    UserList(UserIndex).Stats.MinHP = 0
    UserList(UserIndex).Stats.MinSta = 0
    UserList(UserIndex).flags.AtacadoPorUser = 0
    UserList(UserIndex).flags.Envenenado = 0
    UserList(UserIndex).flags.Muerto = 1
    UserList(UserIndex).flags.SeguroResu = False
    
    aN = UserList(UserIndex).flags.AtacadoPorNpc
    If aN > 0 Then
        If Npclist(aN).Bot.BotType = 0 Then Npclist(aN).Movement = Npclist(aN).flags.OldMovement
        Npclist(aN).Hostile = Npclist(aN).flags.OldHostil
        Npclist(aN).flags.AttackedBy = vbNullString
    End If
    
    aN = UserList(UserIndex).flags.NPCAtacado
    If aN > 0 Then
        If Npclist(aN).flags.AttackedFirstBy = UserList(UserIndex).name Then
            Npclist(aN).flags.AttackedFirstBy = vbNullString
        End If
    End If
    UserList(UserIndex).flags.AtacadoPorNpc = 0
    UserList(UserIndex).flags.NPCAtacado = 0
    
    '<<<< Paralisis >>>>
    If UserList(UserIndex).flags.Paralizado = 1 Then
        UserList(UserIndex).flags.Paralizado = 0
        Call WriteParalizeOK(UserIndex)
    End If
    
    '<<< Estupidez >>>
    If UserList(UserIndex).flags.Estupidez = 1 Then
        UserList(UserIndex).flags.Estupidez = 0
        Call WriteDumbNoMore(UserIndex)
    End If
    
    '<<<< Meditando >>>>
    If UserList(UserIndex).flags.Meditando Then
        UserList(UserIndex).flags.Meditando = False
        Call WriteMeditateToggle(UserIndex)
    End If
    
    '<<<< Invisible >>>>
    If UserList(UserIndex).flags.invisible = 1 Or UserList(UserIndex).flags.Oculto = 1 Then
        UserList(UserIndex).flags.Oculto = 0
        UserList(UserIndex).flags.invisible = 0
        UserList(UserIndex).Counters.TiempoOculto = 0
        UserList(UserIndex).Counters.Invisibilidad = 0
        'no hace falta encriptar este NOVER
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
    End If
    
    'DESEQUIPA TODOS LOS OBJETOS
    'desequipar armadura
        If UserList(UserIndex).Invent.ArmourEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.ArmourEqpSlot)
        End If
        'desequipar arma
        If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.WeaponEqpSlot)
        End If
        'desequipar casco
        If UserList(UserIndex).Invent.CascoEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.CascoEqpSlot)
        End If
        'desequipar herramienta
        If UserList(UserIndex).Invent.AnilloEqpSlot > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.AnilloEqpSlot)
        End If
        'desequipar municiones
        If UserList(UserIndex).Invent.MunicionEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.MunicionEqpSlot)
        End If
        'desequipar escudo
        If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, UserList(UserIndex).Invent.EscudoEqpSlot)
        End If

    '<< Reseteamos los posibles FX sobre el personaje >>
    If UserList(UserIndex).Char.loops = INFINITE_LOOPS Then
        UserList(UserIndex).Char.FX = 0
        UserList(UserIndex).Char.loops = 0
    End If
    
    '<< Restauramos el mimetismo
    If UserList(UserIndex).flags.Mimetizado = 1 Then
        UserList(UserIndex).Char.Body = UserList(UserIndex).CharMimetizado.Body
        UserList(UserIndex).Char.Head = UserList(UserIndex).CharMimetizado.Head
        UserList(UserIndex).Char.CascoAnim = UserList(UserIndex).CharMimetizado.CascoAnim
        UserList(UserIndex).Char.ShieldAnim = UserList(UserIndex).CharMimetizado.ShieldAnim
        UserList(UserIndex).Char.WeaponAnim = UserList(UserIndex).CharMimetizado.WeaponAnim
        UserList(UserIndex).Counters.Mimetismo = 0
        UserList(UserIndex).flags.Mimetizado = 0
    End If

    '<< Restauramos los atributos >>
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Fuerza) = 18 + ModRaza(UserRaza).Fuerza
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad) = 18 + ModRaza(UserRaza).Agilidad
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Inteligencia) = 18 + ModRaza(UserList(UserIndex).raza).Inteligencia
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Carisma) = 18 + ModRaza(UserList(UserIndex).raza).Carisma
        'UserList(UserIndex).Stats.UserAtributos(eAtributos.Constitucion) = 18 + ModRaza(UserList(UserIndex).raza).Constitucion
    
    '<< Cambiamos la apariencia del char >>
    If UserList(UserIndex).Bando = eKip.ePK Then
        If UserList(UserIndex).flags.Navegando = 0 Then
            UserList(UserIndex).Char.Body = iCuerpoMuerto
            UserList(UserIndex).Char.Head = iCabezaMuerto
            UserList(UserIndex).Char.ShieldAnim = NingunEscudo
            UserList(UserIndex).Char.WeaponAnim = NingunArma
            UserList(UserIndex).Char.CascoAnim = NingunCasco
        Else
            UserList(UserIndex).Char.Body = iFragataFantasmal ';)
        End If
    Else
        If UserList(UserIndex).flags.Navegando = 0 Then
            UserList(UserIndex).Char.Body = 145
            UserList(UserIndex).Char.Head = 501
            UserList(UserIndex).Char.ShieldAnim = NingunEscudo
            UserList(UserIndex).Char.WeaponAnim = NingunArma
            UserList(UserIndex).Char.CascoAnim = NingunCasco
        Else
            UserList(UserIndex).Char.Body = iFragataFantasmal ';)
        End If
    End If
    
    For i = 1 To MAXMASCOTAS
        If UserList(UserIndex).MascotasIndex(i) > 0 Then
            Call MuereNpc(UserList(UserIndex).MascotasIndex(i), 0)
        End If
    Next i
    
    UserList(UserIndex).NroMascotas = 0
    
    '<< Actualizamos clientes >>
    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, NingunArma, NingunEscudo, NingunCasco)
    Call WriteUpdateUserStats(UserIndex)

Exit Sub

ErrorHandler:
    Call LogError("Error en SUB USERDIE. Error: " & err.Number & " Descripción: " & err.Description)
End Sub


Sub ContarMuerte(ByVal Muerto As Integer, ByVal atacante As Integer)
Dim dh As Integer
If UserList(atacante).ultimomatado <> Muerto And UserList(Muerto).pasos_desde_resu > 0 Then
    If UserList(Muerto).flags.Desnudo Then
        UserList(atacante).Stats.puntos = UserList(atacante).Stats.puntos + 50
        UserList(atacante).Stats.puntosenv = UserList(atacante).Stats.puntosenv + 50
        If UserList(atacante).flags.Desnudo = 0 Then dh = 8
    Else
        UserList(atacante).Stats.puntos = UserList(atacante).Stats.puntos + 150
        UserList(atacante).Stats.puntosenv = UserList(atacante).Stats.puntosenv + 150
        If UserList(atacante).flags.Desnudo = 0 Then dh = 20
    End If
    UserList(atacante).ultimomatado = Muerto
    UserList(atacante).Stats.UsuariosMatadosenv = UserList(atacante).Stats.UsuariosMatadosenv + 1
End If
dh = dh + 2
honor_enviar atacante, dh
UserList(atacante).Faccion.CiudadanosMatados = UserList(atacante).Faccion.CiudadanosMatados + 1
UserList(Muerto).Stats.muertes = UserList(Muerto).Stats.muertes + 1
UserList(Muerto).Stats.muertesenv = UserList(Muerto).Stats.muertesenv + 1
End Sub

Public Sub ResetFrags(ByVal UI As Integer)
UserList(UI).Faccion.CiudadanosMatados = 0
UserList(UI).Stats.UsuariosMatados = 0
UserList(UI).Stats.UsuariosMatadosenv = 0
UserList(UI).Stats.muertes = 0
UserList(UI).Stats.muertesenv = 0
UserList(UI).Stats.puntos = 0
UserList(UI).Stats.puntosenv = 0
UserList(UI).Stats.honorenv = 0
'UserList(UI).ultimomatado = 0
End Sub

Sub Tilelibre(ByRef Pos As WorldPos, ByRef npos As WorldPos, ByRef obj As obj, ByRef Agua As Boolean, ByRef Tierra As Boolean)
Dim Notfound As Boolean
Dim loopc As Integer
Dim tX As Integer
Dim tY As Integer
Dim hayobj As Boolean
    hayobj = False
    npos.map = Pos.map
    
    Do While Not LegalPos(Pos.map, npos.X, npos.Y, Agua, Tierra) Or hayobj
        
        If loopc > 15 Then
            Notfound = True
            Exit Do
        End If
        
        For tY = Pos.Y - loopc To Pos.Y + loopc
            For tX = Pos.X - loopc To Pos.X + loopc
            
                If LegalPos(npos.map, tX, tY, Agua, Tierra) Then
                    'We continue if: a - the item is different from 0 and the dropped item or b - the amount dropped + amount in map exceeds MAX_INVENTORY_OBJS
                    hayobj = (MapData(npos.map, tX, tY).ObjInfo.ObjIndex > 0 And MapData(npos.map, tX, tY).ObjInfo.ObjIndex <> obj.ObjIndex)
                    If Not hayobj Then _
                        hayobj = (MapData(npos.map, tX, tY).ObjInfo.Amount + obj.Amount > MAX_INVENTORY_OBJS)
                    If Not hayobj And MapData(npos.map, tX, tY).TileExit.map = 0 Then
                        npos.X = tX
                        npos.Y = tY
                        tX = Pos.X + loopc
                        tY = Pos.Y + loopc
                    End If
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

Sub WarpUserChar(ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, Optional ByVal FX As Boolean = False)
    Dim OldMap As Integer
    Dim OldX As Integer
    Dim OldY As Integer
    '[MODIFICADO] 3/2/10 Cambie esto a esta parte porque ahi abajo quedaba em raro... Y le puse que si pisas te busca nueva pos :D Beutiful.
    If MapData(map, X, Y).UserIndex <> 0 Or MapData(map, X, Y).NpcIndex <> 0 Then
        Dim NuevaPos As WorldPos
        Dim FuturePos As WorldPos
        FuturePos.map = map
        FuturePos.X = X
        FuturePos.Y = Y
        Call ClosestLegalPos(FuturePos, NuevaPos, True, True)
        
        If NuevaPos.X <> 0 And NuevaPos.Y <> 0 Then Call WarpUserChar(UserIndex, NuevaPos.map, NuevaPos.X, NuevaPos.Y, True)
    Exit Sub
    End If
    '[/MODIFICADO] 3/2/10
    
    'Quitar el dialogo
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageRemoveCharDialog(UserList(UserIndex).Char.CharIndex))
    
    Call WriteRemoveAllDialogs(UserIndex)
    
    OldMap = UserList(UserIndex).Pos.map
    OldX = UserList(UserIndex).Pos.X
    OldY = UserList(UserIndex).Pos.Y
    Call EraseUserChar(UserIndex)
    
    If OldMap <> map Then
        Call WriteChangeMap(UserIndex, map, MapInfo(UserList(UserIndex).Pos.map).MapVersion)
        'Call WritePlayMidi(UserIndex, Val(ReadField(1, MapInfo(map).Music, 45)))
        
        'Update new Map Users
        MapInfo(map).NumUsers = MapInfo(map).NumUsers + 1
        
        'Update old Map Users
        MapInfo(OldMap).NumUsers = MapInfo(OldMap).NumUsers - 1
        If MapInfo(OldMap).NumUsers < 0 Then
            MapInfo(OldMap).NumUsers = 0
        End If
    End If
    
    UserList(UserIndex).Pos.X = X
    UserList(UserIndex).Pos.Y = Y
    UserList(UserIndex).Pos.map = map
    
    Call MakeUserChar(True, map, UserIndex, map, X, Y)
    Call WriteUserCharIndexInServer(UserIndex)
    
    'Force a flush, so user index is in there before it's destroyed for teleporting
    Call FlushBuffer(UserIndex)
    
    'Seguis invisible al pasar de mapa
    If (UserList(UserIndex).flags.invisible = 1 Or UserList(UserIndex).flags.Oculto = 1) And (Not UserList(UserIndex).flags.AdminInvisible = 1) Then
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, True))
    End If
    
    If FX And UserList(UserIndex).flags.AdminInvisible = 0 Then 'FX
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_WARP, X, Y))
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, FXIDs.FXWARP, 0))
    End If
    
    Call WarpMascotas(UserIndex)
End Sub

Sub WarpMascotas(ByVal UserIndex As Integer)
Dim i As Integer

Dim PetTypes(1 To MAXMASCOTAS) As Integer
Dim PetRespawn(1 To MAXMASCOTAS) As Boolean
Dim PetTiempoDeVida(1 To MAXMASCOTAS) As Integer

Dim NroPets As Integer, InvocadosMatados As Integer

NroPets = UserList(UserIndex).NroMascotas
InvocadosMatados = 0

    'Matamos los invocados
    '[Alejo 18-03-2004]
    For i = 1 To MAXMASCOTAS
        If UserList(UserIndex).MascotasIndex(i) > 0 Then
            'si la mascota tiene tiempo de vida > 0 significa q fue invocada.
            If Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia > 0 Then
                Call QuitarNPC(UserList(UserIndex).MascotasIndex(i))
                UserList(UserIndex).MascotasIndex(i) = 0
                InvocadosMatados = InvocadosMatados + 1
                NroPets = NroPets - 1
            End If
        End If
    Next i
    
    If InvocadosMatados > 0 Then
        Call WriteConsoleMsg(UserIndex, "Pierdes el control de tus mascotas invocadas.", FontTypeNames.FONTTYPE_INFO)
    End If
    
    For i = 1 To MAXMASCOTAS
        If UserList(UserIndex).MascotasIndex(i) > 0 Then
            PetRespawn(i) = Npclist(UserList(UserIndex).MascotasIndex(i)).flags.Respawn = 0
            PetTypes(i) = UserList(UserIndex).MascotasType(i)
            PetTiempoDeVida(i) = Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia
            Call QuitarNPC(UserList(UserIndex).MascotasIndex(i))
        ElseIf UserList(UserIndex).MascotasType(i) > 0 Then
            PetRespawn(i) = True
            PetTypes(i) = UserList(UserIndex).MascotasType(i)
            PetTiempoDeVida(i) = 0
        End If
    Next i
    
    For i = 1 To MAXMASCOTAS
        UserList(UserIndex).MascotasType(i) = PetTypes(i)
    Next i
    
    For i = 1 To MAXMASCOTAS
        If PetTypes(i) > 0 Then
          If MapInfo(UserList(UserIndex).Pos.map).Pk = True Then
            UserList(UserIndex).MascotasIndex(i) = SpawnNpc(PetTypes(i), UserList(UserIndex).Pos, False, PetRespawn(i))
            'Controlamos que se sumoneo OK
            If UserList(UserIndex).MascotasIndex(i) = 0 Then
                Call WriteConsoleMsg(UserIndex, "Tus mascotas no pueden transitar este mapa.", FontTypeNames.FONTTYPE_INFO)
                Exit For
            End If
            Npclist(UserList(UserIndex).MascotasIndex(i)).MaestroUser = UserIndex
            If Npclist(UserList(UserIndex).MascotasIndex(i)).Bot.BotType = 0 Then Npclist(UserList(UserIndex).MascotasIndex(i)).Movement = TipoAI.SigueAmo
            Npclist(UserList(UserIndex).MascotasIndex(i)).Target = 0
            Npclist(UserList(UserIndex).MascotasIndex(i)).TargetNPC = 0
            Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia = PetTiempoDeVida(i)
            Call FollowAmo(UserList(UserIndex).MascotasIndex(i))
          Else
            Call WriteConsoleMsg(UserIndex, "No se permiten mascotas en zona segura. Éstas te esperarán afuera.", FontTypeNames.FONTTYPE_INFO)
            Exit For
          End If
        End If
    Next i
    
    UserList(UserIndex).NroMascotas = NroPets

End Sub


Sub RepararMascotas(ByVal UserIndex As Integer)
Dim i As Integer
Dim MascotasReales As Integer

    For i = 1 To MAXMASCOTAS
      If UserList(UserIndex).MascotasType(i) > 0 Then MascotasReales = MascotasReales + 1
    Next i
    
    If MascotasReales <> UserList(UserIndex).NroMascotas Then UserList(UserIndex).NroMascotas = 0

End Sub

Sub Cerrar_Usuario(ByVal UserIndex As Integer)

    Dim isNotVisible As Boolean
    
    If UserList(UserIndex).flags.UserLogged And Not UserList(UserIndex).Counters.Saliendo Then
        UserList(UserIndex).Counters.Saliendo = True
        UserList(UserIndex).Counters.Salir = 0
        
        isNotVisible = (UserList(UserIndex).flags.Oculto Or UserList(UserIndex).flags.invisible)
        If isNotVisible Then
            UserList(UserIndex).flags.Oculto = 0
            UserList(UserIndex).flags.invisible = 0
            UserList(UserIndex).Counters.Invisibilidad = 0
            UserList(UserIndex).Counters.TiempoOculto = 0
            Call WriteConsoleMsg(UserIndex, "Has vuelto a ser visible.", FontTypeNames.FONTTYPE_INFO)
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
        End If
    End If
End Sub

Public Sub CancelExit(ByVal UserIndex As Integer)

    If UserList(UserIndex).Counters.Saliendo Then
        'Is the user still connected?
        If UserList(UserIndex).ConnIDValida Then
            UserList(UserIndex).Counters.Saliendo = False
            UserList(UserIndex).Counters.Salir = 0
            Call WriteConsoleMsg(UserIndex, "/salir cancelado.", FontTypeNames.FONTTYPE_WARNING)
        Else
            'Simply reset
            UserList(UserIndex).Counters.Salir = 1
        End If
    End If
End Sub


Public Sub Empollando(ByVal UserIndex As Integer)
If MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).ObjInfo.ObjIndex > 0 Then
    UserList(UserIndex).flags.EstaEmpo = 1
Else
    UserList(UserIndex).flags.EstaEmpo = 0
    UserList(UserIndex).EmpoCont = 0
End If
End Sub

Public Function BodyIsBoat(ByVal Body As Integer) As Boolean

    If Body = iFragataReal Or Body = iFragataCaos Or Body = iBarcaPk Or _
            Body = iGaleraPk Or Body = iGaleonPk Or Body = iBarcaCiuda Or _
            Body = iGaleraCiuda Or Body = iGaleonCiuda Or Body = iFragataFantasmal Then
        BodyIsBoat = True
    End If
End Function
