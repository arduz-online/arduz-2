Attribute VB_Name = "SistemaCombate"
Option Explicit

Public Const MAXDISTANCIAARCO As Byte = 18
Public Const MAXDISTANCIAMAGIA As Byte = 18


Function ModificadorEvasion(ByVal clase As eClass) As Single
    ModificadorEvasion = bClases(clase).ModBalances.Evasion
End Function

Function ModificadorPoderAtaqueArmas(ByVal clase As eClass) As Single
    ModificadorPoderAtaqueArmas = bClases(clase).ModBalances.AtaqueArmas
End Function

Function ModificadorPoderAtaqueProyectiles(ByVal clase As eClass) As Single
    ModificadorPoderAtaqueProyectiles = bClases(clase).ModBalances.AtaqueProyectiles
End Function

Function ModicadorDañoClaseArmas(ByVal clase As eClass) As Single
    ModicadorDañoClaseArmas = bClases(clase).ModBalances.DañoArmas
End Function

Function ModicadorDañoClaseWrestling(ByVal clase As eClass) As Single
    ModicadorDañoClaseWrestling = bClases(clase).ModBalances.DañoWrestling
End Function

Function ModicadorDañoClaseProyectiles(ByVal clase As eClass) As Single
    ModicadorDañoClaseProyectiles = bClases(clase).ModBalances.DañoProyectiles
End Function

Function ModEvasionDeEscudoClase(ByVal clase As eClass) As Single
    ModEvasionDeEscudoClase = bClases(clase).ModBalances.Escudo
End Function

Function Minimo(ByVal a As Single, ByVal b As Single) As Single
If a > b Then
    Minimo = b
    Else: Minimo = a
End If
End Function

Function MinimoInt(ByVal a As Integer, ByVal b As Integer) As Integer
If a > b Then
    MinimoInt = b
    Else: MinimoInt = a
End If
End Function

Function Maximo(ByVal a As Single, ByVal b As Single) As Single
If a > b Then
    Maximo = a
    Else: Maximo = b
End If
End Function

Function MaximoInt(ByVal a As Integer, ByVal b As Integer) As Integer
If a > b Then
    MaximoInt = a
    Else: MaximoInt = b
End If
End Function


Function PoderEvasionEscudo(ByVal UserIndex As Integer) As Long

PoderEvasionEscudo = 100 * ModEvasionDeEscudoClase(UserList(UserIndex).clase) / 2

End Function

Function PoderEvasion(ByVal UserIndex As Integer) As Long
    Dim lTemp As Long
     With UserList(UserIndex)
       lTemp = (100 + _
          100 / 33 * .Stats.UserAtributos(eAtributos.Agilidad)) * _
          ModificadorEvasion(UserList(UserIndex).clase)
       
        PoderEvasion = (lTemp + (2.5 * Maximo(32 - 12, 0)))
    End With
End Function

Function PoderAtaqueArma(ByVal UserIndex As Integer) As Long
Dim PoderAtaqueTemp As Long

   PoderAtaqueTemp = ((100 + _
   (3 * UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad))) * _
   ModificadorPoderAtaqueArmas(UserList(UserIndex).clase))

PoderAtaqueArma = (PoderAtaqueTemp + (2.5 * Maximo(CInt(40) - 12, 0)))
End Function

Function PoderAtaqueProyectil(ByVal UserIndex As Integer) As Long
Dim PoderAtaqueTemp As Long

       PoderAtaqueTemp = ((100 + _
      (3 * UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad))) * _
      ModificadorPoderAtaqueProyectiles(UserList(UserIndex).clase))


PoderAtaqueProyectil = (PoderAtaqueTemp + (2.5 * Maximo(CInt(40) - 12, 0)))

End Function

Function PoderAtaqueWrestling(ByVal UserIndex As Integer) As Long
Dim PoderAtaqueTemp As Long

    PoderAtaqueTemp = ((100 + _
    (3 * UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad))) * _
    ModificadorPoderAtaqueArmas(UserList(UserIndex).clase))


PoderAtaqueWrestling = (PoderAtaqueTemp + (2.5 * Maximo(CInt(40) - 12, 0)))

End Function


Public Function UserImpactoNpc(ByVal UserIndex As Integer, ByVal NpcIndex As Integer) As Boolean
Dim PoderAtaque As Long
Dim Arma As Integer
Dim proyectil As Boolean
Dim ProbExito As Long

Arma = UserList(UserIndex).Invent.WeaponEqpObjIndex
If Arma = 0 Then proyectil = False Else proyectil = ObjData(Arma).proyectil = 1

If Arma > 0 Then 'Usando un arma
    If proyectil Then
        PoderAtaque = PoderAtaqueProyectil(UserIndex)
    Else
        PoderAtaque = PoderAtaqueArma(UserIndex)
    End If
Else 'Peleando con puños
    PoderAtaque = PoderAtaqueWrestling(UserIndex)
End If


ProbExito = Maximo(10, Minimo(90, 50 + ((PoderAtaque - Npclist(NpcIndex).PoderEvasion) * 0.4)))
Debug.Print "ProbExito USER ATACA NPC: " & ProbExito & "-" & PoderAtaque
UserImpactoNpc = (RandomNumber(1, 100) <= ProbExito)
End Function

Public Function NpcImpacto(ByVal NpcIndex As Integer, ByVal UserIndex As Integer) As Boolean
'
'Author: Unknown
'Last modified: 03/15/2006
'Revisa si un NPC logra impactar a un user o no
'03/15/2006 Maraxus - Evité una división por cero que eliminaba NPCs
'
Dim rechazo As Boolean
Dim ProbRechazo As Long
Dim ProbExito As Long
Dim UserEvasion As Long
Dim NpcPoderAtaque As Long
Dim PoderEvasioEscudo As Long
Dim SkillTacticas As Long
Dim SkillDefensa As Long

UserEvasion = PoderEvasion(UserIndex)
NpcPoderAtaque = Npclist(NpcIndex).PoderAtaque
PoderEvasioEscudo = PoderEvasionEscudo(UserIndex)

SkillTacticas = 100
SkillDefensa = 100

'Esta usando un escudo ???
If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then UserEvasion = UserEvasion + PoderEvasioEscudo

ProbExito = Maximo(10, Minimo(90, 50 + ((NpcPoderAtaque - UserEvasion) * 0.4)))
Debug.Print "ProbExito NPC ATACA USER: " & ProbExito & "-" & UserEvasion
NpcImpacto = (RandomNumber(1, 100) <= ProbExito)

'el usuario esta usando un escudo ???
If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then
    If Not NpcImpacto Then
        If SkillDefensa + SkillTacticas > 0 Then  'Evitamos división por cero
            ProbRechazo = Maximo(10, Minimo(90, 100 * (SkillDefensa / (SkillDefensa + SkillTacticas))))
            rechazo = (RandomNumber(1, 100) <= ProbRechazo)
            If rechazo = True Then
                'Se rechazo el ataque con el escudo
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_ESCUDO, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
                Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))
                Call WriteConsoleMsg(UserIndex, "¡¡" & Npclist(NpcIndex).name & " te ataco y fallo!!", FontTypeNames.FONTTYPE_FIGHT)
                Call WriteBlockedWithShieldUser(UserIndex)
            End If
        End If
    End If
End If
End Function

Public Function CalcularDaño(ByVal UserIndex As Integer, Optional ByVal NpcIndex As Integer = 0) As Long
Dim DañoArma As Long, DañoUsuario As Long, Arma As ObjData, ModifClase As Single
Dim proyectil As ObjData
Dim DañoMaxArma As Long

''sacar esto si no queremos q la matadracos mate el Dragon si o si
Dim matoDragon As Boolean
matoDragon = False


If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
    Arma = ObjData(UserList(UserIndex).Invent.WeaponEqpObjIndex)
    
    
    'Ataca a un npc?
    If NpcIndex > 0 Then
        
           If Arma.proyectil = 1 Then
                ModifClase = ModicadorDañoClaseProyectiles(UserList(UserIndex).clase)
                DañoArma = RandomNumber(Arma.MinHit, Arma.MaxHit)
                DañoMaxArma = Arma.MaxHit
                If Arma.Municion = 1 Then
                    proyectil = ObjData(UserList(UserIndex).Invent.MunicionEqpObjIndex)
                    DañoArma = DañoArma + RandomNumber(proyectil.MinHit, proyectil.MaxHit)
                    DañoMaxArma = Arma.MaxHit
                End If
           Else
                ModifClase = ModicadorDañoClaseArmas(UserList(UserIndex).clase)
                DañoArma = RandomNumber(Arma.MinHit, Arma.MaxHit)
                DañoMaxArma = Arma.MaxHit
           End If
    
    Else 'Ataca usuario

           If Arma.proyectil = 1 Then
                ModifClase = ModicadorDañoClaseProyectiles(UserList(UserIndex).clase)
                DañoArma = RandomNumber(Arma.MinHit, Arma.MaxHit)
                DañoMaxArma = Arma.MaxHit
                
                If Arma.Municion = 1 Then
                    proyectil = ObjData(UserList(UserIndex).Invent.MunicionEqpObjIndex)
                    DañoArma = DañoArma + RandomNumber(proyectil.MinHit, proyectil.MaxHit)
                    DañoMaxArma = Arma.MaxHit
                End If
           Else
                ModifClase = ModicadorDañoClaseArmas(UserList(UserIndex).clase)
                DañoArma = RandomNumber(Arma.MinHit, Arma.MaxHit)
                DañoMaxArma = Arma.MaxHit
           End If
    End If
Else
    'Pablo (ToxicWaste)
    ModifClase = ModicadorDañoClaseWrestling(UserList(UserIndex).clase)
    DañoArma = RandomNumber(1, 3) 'Hacemos que sea "tipo" una daga el ataque de Wrestling
    DañoMaxArma = 3
End If

DañoUsuario = RandomNumber(UserList(UserIndex).Stats.MinHit, UserList(UserIndex).Stats.MaxHit)

''sacar esto si no queremos q la matadracos mate el Dragon si o si
If matoDragon Then
    CalcularDaño = Npclist(NpcIndex).Stats.MinHP + Npclist(NpcIndex).Stats.def
Else
    CalcularDaño = ((3 * DañoArma) + ((DañoMaxArma / 5) * Maximo(0, (UserList(UserIndex).Stats.UserAtributos(eAtributos.Fuerza) - 15))) + DañoUsuario) * ModifClase
End If

End Function
'[MODIFICADO] 3/2/10 Modifique todo este sub, dando la posibilidad de golpear a los BOTs en las partes de cuerpo.
Public Sub UserDañoNpc(ByVal UserIndex As Integer, ByVal NpcIndex As Integer)
Dim daño As Long, antdaño As Integer
Dim Lugar As Integer, absorbido As Long
Dim obj As ObjData

daño = CalcularDaño(UserIndex, NpcIndex)

'esta navegando? si es asi le sumamos el daño del barco
If UserList(UserIndex).Flags.Navegando = 1 And UserList(UserIndex).Invent.BarcoObjIndex > 0 Then _
        daño = daño + RandomNumber(ObjData(UserList(UserIndex).Invent.BarcoObjIndex).MinHit, ObjData(UserList(UserIndex).Invent.BarcoObjIndex).MaxHit)


'daño = daño - Npclist(NpcIndex).Stats.def

If daño < 0 Then daño = 1
'[KEVIN]
'Call WriteUserHitNPC(UserIndex, daño)
Lugar = RandomNumber(1, 6)

Select Case Lugar
    Case PartesCuerpo.bCabeza
        'Si tiene casco absorbe el golpe
        If Npclist(NpcIndex).Inventario.CascoEqpObjIndex > 0 Then
        obj = ObjData(Npclist(NpcIndex).Inventario.CascoEqpObjIndex)
        absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
        daño = daño - absorbido
        If daño < 0 Then daño = 1
        End If
        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCreateHIT(Npclist(NpcIndex).Char.CharIndex, daño, RGB(207, 67, 0)))
    Case Else
        'Si tiene armadura absorbe el golpe
        If Npclist(NpcIndex).Inventario.ArmourEqpObjIndex > 0 Then
            obj = ObjData(Npclist(NpcIndex).Inventario.ArmourEqpObjIndex)
            Dim Obj2 As ObjData
            If Npclist(NpcIndex).Inventario.EscudoEqpObjIndex Then
                Obj2 = ObjData(Npclist(NpcIndex).Inventario.EscudoEqpObjIndex)
                absorbido = RandomNumber(obj.MinDef + Obj2.MinDef, obj.MaxDef + Obj2.MaxDef)
            Else
                absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
            End If
            daño = daño - absorbido
            If daño < 0 Then daño = 1
        End If
        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCreateHIT(Npclist(NpcIndex).Char.CharIndex, daño, vbRed))
End Select

Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCreateHIT(Npclist(NpcIndex).Char.CharIndex, daño, vbRed))
Call WriteUserHittedUser(UserIndex, Lugar, Npclist(NpcIndex).Char.CharIndex, daño)
Npclist(NpcIndex).Stats.MinHP = Npclist(NpcIndex).Stats.MinHP - daño
'[/KEVIN]
'[MODIFICADO] 7/2/10 Los bots dan puntos ;)
'UserList(UserIndex).Stats.puntos = UserList(UserIndex).Stats.puntos + (daño / 15)
'UserList(UserIndex).Stats.puntosenv = UserList(UserIndex).Stats.puntosenv + (daño / 15)
'[/MODIFICADO] Los bots dan puntos
Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessageCreateFX(Npclist(NpcIndex).Char.CharIndex, FXSANGRE, 1))
If Npclist(NpcIndex).Stats.MinHP > 0 Then
    'Trata de apuñalar por la espalda al enemigo
    If PuedeApuñalar(UserIndex) Then
       Call DoApuñalar(UserIndex, NpcIndex, 0, daño)
    End If
    'trata de dar golpe crítico
    'Call DoGolpeCritico(UserIndex, NpcIndex, 0, daño)
    
End If

If Npclist(NpcIndex).Stats.MinHP <= 0 Then
        
        'Si era un Dragon perdemos la espada mataDragone
        'Para que las mascotas no sigan intentando luchar y
        'comiencen a seguir al amo
        
        Dim j As Integer
        For j = 1 To MAXMASCOTAS
            If UserList(UserIndex).MascotasIndex(j) > 0 Then
                If Npclist(UserList(UserIndex).MascotasIndex(j)).TargetNPC = NpcIndex Then
                    Npclist(UserList(UserIndex).MascotasIndex(j)).TargetNPC = 0
                    If Npclist(UserList(UserIndex).MascotasIndex(j)).Bot.BotType = 0 Then Npclist(UserList(UserIndex).MascotasIndex(j)).Movement = TipoAI.SigueAmo
                End If
            End If
        Next j
        
        Call MuereNpc(NpcIndex, UserIndex)
End If

End Sub
'[/MODIFICADO] 3/2/10

Public Sub NpcDaño(ByVal NpcIndex As Integer, ByVal UserIndex As Integer)

Dim daño As Integer, Lugar As Integer, absorbido As Integer
Dim antdaño As Integer, defbarco As Integer
Dim obj As ObjData



daño = RandomNumber(Npclist(NpcIndex).Stats.MinHit, Npclist(NpcIndex).Stats.MaxHit)
antdaño = daño

If UserList(UserIndex).Flags.Navegando = 1 And UserList(UserIndex).Invent.BarcoObjIndex > 0 Then
    obj = ObjData(UserList(UserIndex).Invent.BarcoObjIndex)
    defbarco = RandomNumber(obj.MinDef, obj.MaxDef)
End If


Lugar = RandomNumber(1, 6)


Select Case Lugar
  Case PartesCuerpo.bCabeza
        'Si tiene casco absorbe el golpe
        If UserList(UserIndex).Invent.CascoEqpObjIndex > 0 Then
           obj = ObjData(UserList(UserIndex).Invent.CascoEqpObjIndex)
           absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
           absorbido = absorbido + defbarco
           daño = daño - absorbido
           If daño < 1 Then daño = 1
        End If
  Case Else
        'Si tiene armadura absorbe el golpe
        If UserList(UserIndex).Invent.ArmourEqpObjIndex > 0 Then
           Dim Obj2 As ObjData
           obj = ObjData(UserList(UserIndex).Invent.ArmourEqpObjIndex)
           If UserList(UserIndex).Invent.EscudoEqpObjIndex Then
                Obj2 = ObjData(UserList(UserIndex).Invent.EscudoEqpObjIndex)
                absorbido = RandomNumber(obj.MinDef + Obj2.MinDef, obj.MaxDef + Obj2.MaxDef)
           Else
                absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
           End If
           absorbido = absorbido + defbarco
           daño = daño - absorbido
           If daño < 1 Then daño = 1
        End If
End Select

'Call WriteNPCHitUser(UserIndex, Lugar, daño)
Call WriteUserHittedByUser(UserIndex, Lugar, Npclist(NpcIndex).Char.CharIndex, daño)
UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MinHP - daño
If Npclist(NpcIndex).Bot.Apuñala = 1 And RandomNumber(1, 100) <= 14 Then '[¡Npc APUÑALA!]
    UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MinHP - CInt(daño * 1.5)
    Call WriteConsoleMsg(UserIndex, "Te ha apuñalado " & Npclist(NpcIndex).name & " por " & daño * 1.5, FontTypeNames.FONTTYPE_FIGHT)
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateHIT(UserList(UserIndex).Char.CharIndex, daño + daño * 1.5, vbYellow))
End If
If UserList(UserIndex).Flags.Meditando Then
    If daño > Fix(UserList(UserIndex).Stats.MinHP / 100 * UserList(UserIndex).Stats.UserAtributos(eAtributos.Inteligencia) * 12 / (RandomNumber(0, 5) + 7)) Then
        UserList(UserIndex).Flags.Meditando = False
        Call WriteMeditateToggle(UserIndex)
        Call WriteConsoleMsg(UserIndex, "Dejas de meditar.", FontTypeNames.FONTTYPE_INFO)
        UserList(UserIndex).Char.FX = 0
        UserList(UserIndex).Char.loops = 0
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, 0, 0))
    End If
End If

'Muere el usuario
If UserList(UserIndex).Stats.MinHP <= 0 Then

    Call WriteConsoleMsg(UserIndex, Npclist(NpcIndex).name & " te ha matado", FontTypeNames.FONTTYPE_FIGHT)
    'Call WriteNPCKillUser(UserIndex) 'Le informamos que ha muerto ;)
    
    If Npclist(NpcIndex).MaestroUser > 0 Then
        Call AllFollowAmo(Npclist(NpcIndex).MaestroUser)
    Else
        'Al matarlo no lo sigue mas
        If Npclist(NpcIndex).Stats.Alineacion = 0 Then
                    If Npclist(NpcIndex).Bot.BotType = 0 Then Npclist(NpcIndex).Movement = Npclist(NpcIndex).Flags.OldMovement
                    Npclist(NpcIndex).Hostile = Npclist(NpcIndex).Flags.OldHostil
                    Npclist(NpcIndex).Flags.AttackedBy = vbNullString
        End If
    End If
    
    
    Call UserDie(UserIndex)

End If

End Sub

Public Sub RestarCriminalidad(ByVal UserIndex As Integer)
    
    Dim EraCriminal As Boolean
    EraCriminal = criminal(UserIndex)
    
    If UserList(UserIndex).Reputacion.BandidoRep > 0 Then
         UserList(UserIndex).Reputacion.BandidoRep = UserList(UserIndex).Reputacion.BandidoRep - vlASALTO
         If UserList(UserIndex).Reputacion.BandidoRep < 0 Then UserList(UserIndex).Reputacion.BandidoRep = 0
    ElseIf UserList(UserIndex).Reputacion.LadronesRep > 0 Then
         UserList(UserIndex).Reputacion.LadronesRep = UserList(UserIndex).Reputacion.LadronesRep - (vlCAZADOR * 10)
         If UserList(UserIndex).Reputacion.LadronesRep < 0 Then UserList(UserIndex).Reputacion.LadronesRep = 0
    End If
    
    If EraCriminal And Not criminal(UserIndex) Then
        Call RefreshCharStatus(UserIndex)
    End If
End Sub


Public Sub CheckPets(ByVal NpcIndex As Integer, ByVal UserIndex As Integer, Optional ByVal CheckElementales As Boolean = True)
If UserList(UserIndex).Bando = Npclist(NpcIndex).Bando Then Exit Sub
Dim j As Integer
For j = 1 To MAXMASCOTAS
    If UserList(UserIndex).MascotasIndex(j) > 0 Then
       If UserList(UserIndex).MascotasIndex(j) <> NpcIndex Then
        If CheckElementales Or (Npclist(UserList(UserIndex).MascotasIndex(j)).numero <> ELEMENTALFUEGO And Npclist(UserList(UserIndex).MascotasIndex(j)).numero <> ELEMENTALTIERRA) Then
            If Npclist(UserList(UserIndex).MascotasIndex(j)).TargetNPC = 0 Then Npclist(UserList(UserIndex).MascotasIndex(j)).TargetNPC = NpcIndex
            'Npclist(UserList(UserIndex).MascotasIndex(j)).Flags.OldMovement = Npclist(UserList(UserIndex).MascotasIndex(j)).Movement
            If Npclist(UserList(UserIndex).MascotasIndex(j)).Bot.BotType = 0 Then Npclist(UserList(UserIndex).MascotasIndex(j)).Movement = TipoAI.NpcAtacaNpc
            
        End If
       End If
    End If
Next j

End Sub
Public Sub AllFollowAmo(ByVal UserIndex As Integer)
Dim j As Integer
For j = 1 To MAXMASCOTAS
    If UserList(UserIndex).MascotasIndex(j) > 0 Then
        Call FollowAmo(UserList(UserIndex).MascotasIndex(j))
    End If
Next j
End Sub

Public Function NpcAtacaUser(ByVal NpcIndex As Integer, ByVal UserIndex As Integer) As Boolean
If Npclist(NpcIndex).Bot.BotType <> 0 And Npclist(NpcIndex).Bot.ComboActual <> 0 Then
    If Npclist(NpcIndex).Bot.ComboActual <> 255 Then Call BotHechizo(NpcIndex, Npclist(NpcIndex).Target, 2): Exit Function
    If UserList(UserIndex).Flags.Paralizado = 0 Then Call CancelCombo(NpcIndex)
End If

If UserList(UserIndex).Flags.AdminInvisible = 1 Then Exit Function

'El npc puede atacar ???
If puede_npc(NpcIndex, 1400, False) = True Then
Npclist(NpcIndex).ultimox = (GetTickCount() And &H7FFFFFFF)
    NpcAtacaUser = True
    Call CheckPets(NpcIndex, UserIndex, False)

    If Npclist(NpcIndex).Target = 0 Then Npclist(NpcIndex).Target = UserIndex

    If UserList(UserIndex).Flags.AtacadoPorNpc = 0 And _
       UserList(UserIndex).Flags.AtacadoPorUser = 0 Then UserList(UserIndex).Flags.AtacadoPorNpc = NpcIndex
Else
    NpcAtacaUser = False
    Exit Function
End If

Npclist(NpcIndex).CanAttack = 0

If Npclist(NpcIndex).Flags.Snd1 > 0 Then
    Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(Npclist(NpcIndex).Flags.Snd1, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
End If
Dim ProbRechazo As Long
    If NpcImpacto(NpcIndex, UserIndex) Then
    Dim rechazo As Boolean
    rechazo = False
        If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then
            'Fallo ???
    
              ProbRechazo = Maximo(10, Minimo(90, 50))
              rechazo = (RandomNumber(1, 100) <= ProbRechazo)
        End If
          If rechazo = True Then
          'Se rechazo el ataque con el escudo
                  Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_ESCUDO, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
                  Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))

                  Call WriteBlockedWithShieldUser(UserIndex)
          Else
            If Npclist(NpcIndex).Bot.ComboActual = 255 Then Call NextCombo(NpcIndex)
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_IMPACTO, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
            
            If UserList(UserIndex).Flags.Meditando = False Then
                If UserList(UserIndex).Flags.Navegando = 0 Then
                    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, FXSANGRE, 0))
                End If
            End If
            
            Call NpcDaño(NpcIndex, UserIndex)
            Call WriteUpdateHP(UserIndex)
            '¿Puede envenenar?
            If Npclist(NpcIndex).Veneno = 1 Then Call NpcEnvenenarUser(UserIndex)
            

        End If
    Else
        Call WriteConsoleMsg(UserIndex, "¡¡" & Npclist(NpcIndex).name & " te ataco y fallo!!", FontTypeNames.FONTTYPE_FIGHT)
        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(SND_SWING, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
    End If



'Controla el nivel del usuario
Call CheckUserLevel(UserIndex)

End Function

Function NpcImpactoNpc(ByVal atacante As Integer, ByVal victima As Integer) As Boolean
Dim PoderAtt As Long, PoderEva As Long
Dim ProbExito As Long

PoderAtt = Npclist(atacante).PoderAtaque
PoderEva = Npclist(victima).PoderEvasion
ProbExito = Maximo(10, Minimo(90, 50 + _
            ((PoderAtt - PoderEva) * 0.4)))
Debug.Print "ProbExito NPC ATACA NPC: " & ProbExito
NpcImpactoNpc = (RandomNumber(1, 100) <= ProbExito)


End Function

Public Sub NpcDañoNpc(ByVal atacante As Integer, ByVal victima As Integer)
    Dim daño As Integer
    Dim ANpc As npc
    ANpc = Npclist(atacante)
    
    daño = RandomNumber(ANpc.Stats.MinHit, ANpc.Stats.MaxHit)
    Npclist(victima).Stats.MinHP = Npclist(victima).Stats.MinHP - daño
    If Npclist(atacante).Bot.Apuñala = 1 And RandomNumber(1, 100) <= 14 Then
        Npclist(victima).Stats.MinHP = Npclist(victima).Stats.MinHP - CInt(daño * 1.5)
        Call SendData(SendTarget.ToNPCArea, victima, PrepareMessageCreateHIT(Npclist(victima).Char.CharIndex, daño + daño * 1.5, vbYellow))
    End If
    If Npclist(victima).Stats.MinHP < 1 Then
        
        If LenB(Npclist(atacante).Flags.AttackedBy) <> 0 Then
            If Npclist(atacante).Bot.BotType = 0 Then Npclist(atacante).Movement = Npclist(atacante).Flags.OldMovement
            Npclist(atacante).Hostile = Npclist(atacante).Flags.OldHostil
        Else
            If Npclist(atacante).Bot.BotType = 0 Then Npclist(atacante).Movement = Npclist(atacante).Flags.OldMovement
        End If
        
        If Npclist(atacante).MaestroUser > 0 Then
            Call FollowAmo(atacante)
        End If
        
        Call MuereNpc(victima, Npclist(atacante).MaestroUser)
    End If
End Sub

Public Sub NpcAtacaNpc(ByVal atacante As Integer, ByVal victima As Integer, Optional ByVal cambiarMOvimiento As Boolean = True)
If Npclist(atacante).Bot.BotType <> 0 And Npclist(atacante).Bot.ComboActual <> 0 Then
    If Npclist(atacante).Bot.ComboActual <> 255 Then Call BotHechizo(atacante, Npclist(atacante).Target, 2): Exit Sub
    If Npclist(victima).Flags.Paralizado = 0 Then Call CancelCombo(atacante)
End If
'El npc puede atacar ???
If puede_npc(atacante, 1400, False) = True And puede_npc_y(atacante, 1000, False) = True Then
    Npclist(atacante).ultimox = (GetTickCount() And &H7FFFFFFF)
    Npclist(victima).Target = 0
    Npclist(victima).TargetNPC = atacante
    Npclist(atacante).CanAttack = 0
        If cambiarMOvimiento Then
            If Npclist(victima).Bot.BotType <> 0 Then
                If RandomNumber(1, 3) = 2 Then
                    If RandomNumber(1, 3) = 2 And atacante <> Npclist(victima).TargetNPC Then Call SendData(SendTarget.ToNPCArea, atacante, PrepareMessageChatOverHead("¡Me cansaste te voy a matar a vos " & Npclist(victima).name & "!", Npclist(atacante).Char.CharIndex, vbWhite))
                    Npclist(victima).TargetNPC = atacante
                    Npclist(victima).Target = 0
                End If
            Else
                Npclist(victima).TargetNPC = atacante
                Npclist(victima).Movement = TipoAI.NpcAtacaNpc
            End If
        End If
Else
    Exit Sub
End If

If Npclist(atacante).Flags.Snd1 > 0 Then
    Call SendData(SendTarget.ToNPCArea, atacante, PrepareMessagePlayWave(Npclist(atacante).Flags.Snd1, Npclist(atacante).Pos.X, Npclist(atacante).Pos.Y))
End If

If NpcImpactoNpc(atacante, victima) Then
    
    If Npclist(victima).Flags.Snd2 > 0 Then
        Call SendData(SendTarget.ToNPCArea, victima, PrepareMessagePlayWave(Npclist(victima).Flags.Snd2, Npclist(victima).Pos.X, Npclist(victima).Pos.Y))
    Else
        Call SendData(SendTarget.ToNPCArea, victima, PrepareMessagePlayWave(SND_IMPACTO, Npclist(victima).Pos.X, Npclist(victima).Pos.Y))
    End If

    If Npclist(atacante).MaestroUser > 0 Then
        Call SendData(SendTarget.ToNPCArea, atacante, PrepareMessagePlayWave(SND_IMPACTO, Npclist(atacante).Pos.X, Npclist(atacante).Pos.Y))
    Else
        Call SendData(SendTarget.ToNPCArea, victima, PrepareMessagePlayWave(SND_IMPACTO, Npclist(victima).Pos.X, Npclist(victima).Pos.Y))
    End If
    If Npclist(atacante).Bot.ComboActual = 255 Then Call NextCombo(atacante)
    Call NpcDañoNpc(atacante, victima)
    
Else
    If Npclist(atacante).MaestroUser > 0 Then
        Call SendData(SendTarget.ToNPCArea, atacante, PrepareMessagePlayWave(SND_SWING, Npclist(atacante).Pos.X, Npclist(atacante).Pos.Y))
    Else
        Call SendData(SendTarget.ToNPCArea, victima, PrepareMessagePlayWave(SND_SWING, Npclist(victima).Pos.X, Npclist(victima).Pos.Y))
    End If
End If

End Sub

Public Sub UsuarioAtacaNpc(ByVal UserIndex As Integer, ByVal NpcIndex As Integer)


If Not PuedeAtacarNPC(UserIndex, NpcIndex) Then
    Exit Sub
End If

Call NPCAtacado(NpcIndex, UserIndex)

If UserImpactoNpc(UserIndex, NpcIndex) Then
    
    If Npclist(NpcIndex).Flags.Snd2 > 0 Then
        Call SendData(SendTarget.ToNPCArea, NpcIndex, PrepareMessagePlayWave(Npclist(NpcIndex).Flags.Snd2, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
    Else
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_IMPACTO, Npclist(NpcIndex).Pos.X, Npclist(NpcIndex).Pos.Y))
    End If
    
    Call UserDañoNpc(UserIndex, NpcIndex)
   
Else
    'Call WriteConsoleMsg(UserIndex, "¡¡" & Npclist(NpcIndex).name & " te ataco y fallo!!", FontTypeNames.FONTTYPE_FIGHT)
    'If RandomNumber(1, 2) Then Call WriteConsoleMsg(UserIndex, "¡¡Haz rechazado el ataque con el escudo!!", FontTypeNames.FONTTYPE_FIGHT) '[MODIFICADO] 2/3/10 Los bots tienen la misma evasion que si tendrias escudo, osea es como rechazar el golpe con el escudo asi que hacemos esto para tirar facha ;)
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_SWING, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
    Call WriteUserSwing(UserIndex)
End If

End Sub

Public Sub UsuarioAtaca(ByVal UserIndex As Integer)

'If UserList(UserIndex).flags.PuedeAtacar = 1 Then
'Check bow's interval
If Not IntervaloPermiteUsarArcos(UserIndex, False) Then Exit Sub

'Check Spell-Magic interval
If Not IntervaloPermiteMagiaGolpe(UserIndex) Then
    'Check Attack interval
    If Not IntervaloPermiteAtacar(UserIndex) Then
        Exit Sub
    End If
End If

'UserList(UserIndex).flags.PuedeAtacar = 0

Dim AttackPos As WorldPos
AttackPos = UserList(UserIndex).Pos
Call HeadtoPos(UserList(UserIndex).Char.Heading, AttackPos)
   
'Exit if not legal
If AttackPos.X < XMinMapSize Or AttackPos.X > MapSize Or AttackPos.Y <= YMinMapSize Or AttackPos.Y > MapSize Then
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_SWING, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
    Exit Sub
End If

Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageAnim_Attack(UserList(UserIndex).Char.CharIndex))

Dim Index As Integer
Index = MapData(AttackPos.map, AttackPos.X, AttackPos.Y).UserIndex
    
'Look for user
If Index > 0 Then
    Call UsuarioAtacaUsuario(UserIndex, Index)
    Call WriteUpdateUserStats(UserIndex)
    Call WriteUpdateUserStats(Index)
    
    Exit Sub
End If
    
'Look for NPC
If MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex > 0 Then
    
    If Npclist(MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex).Attackable Then
            
        If Npclist(MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex).MaestroUser > 0 And _
            MapInfo(Npclist(MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex).Pos.map).Pk = False Then
                Call WriteConsoleMsg(UserIndex, "No podés atacar mascotas en zonas seguras", FontTypeNames.FONTTYPE_FIGHT)
                Exit Sub
        End If

        Call UsuarioAtacaNpc(UserIndex, MapData(AttackPos.map, AttackPos.X, AttackPos.Y).NpcIndex)
            
    Else
        Call WriteConsoleMsg(UserIndex, "No podés atacar a este NPC", FontTypeNames.FONTTYPE_FIGHT)
    End If
        
    Call WriteUpdateUserStats(UserIndex)
        
    Exit Sub
End If
    
Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_SWING, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y))
Call WriteUpdateUserStats(UserIndex)


If UserList(UserIndex).Counters.Trabajando Then _
    UserList(UserIndex).Counters.Trabajando = UserList(UserIndex).Counters.Trabajando - 1
    
If UserList(UserIndex).Counters.Ocultando Then _
    UserList(UserIndex).Counters.Ocultando = UserList(UserIndex).Counters.Ocultando - 1

End Sub

Public Function UsuarioImpacto(ByVal AtacanteIndex As Integer, ByVal VictimaIndex As Integer) As Boolean

Dim ProbRechazo As Long
Dim rechazo As Boolean
Dim ProbExito As Long
Dim PoderAtaque As Long
Dim UserPoderEvasion As Long
Dim UserPoderEvasionEscudo As Long
Dim Arma As Integer
Dim proyectil As Boolean
Dim SkillTacticas As Long
Dim SkillDefensa As Long

SkillTacticas = 100
SkillDefensa = 100

Arma = UserList(AtacanteIndex).Invent.WeaponEqpObjIndex
If Arma > 0 Then
    proyectil = ObjData(Arma).proyectil = 1
Else
    proyectil = False
End If

'Calculamos el poder de evasion...
UserPoderEvasion = PoderEvasion(VictimaIndex)

If UserList(VictimaIndex).Invent.EscudoEqpObjIndex > 0 Then
   UserPoderEvasionEscudo = PoderEvasionEscudo(VictimaIndex)
   UserPoderEvasion = UserPoderEvasion + UserPoderEvasionEscudo
Else
    UserPoderEvasionEscudo = 0
End If

'Esta usando un arma ???
If UserList(AtacanteIndex).Invent.WeaponEqpObjIndex > 0 Then
    
    If proyectil Then
        PoderAtaque = PoderAtaqueProyectil(AtacanteIndex)
    Else
        PoderAtaque = PoderAtaqueArma(AtacanteIndex)
    End If
    ProbExito = Maximo(10, Minimo(90, 50 + _
                ((PoderAtaque - UserPoderEvasion) * 0.4)))
   
Else
    PoderAtaque = PoderAtaqueWrestling(AtacanteIndex)
    ProbExito = Maximo(10, Minimo(90, 50 + _
                ((PoderAtaque - UserPoderEvasion) * 0.4)))
    
End If
Debug.Print "ProbExito USER ATACA USER: " & ProbExito & "-" & PoderAtaque & "-" & UserPoderEvasion
UsuarioImpacto = (RandomNumber(1, 100) <= ProbExito)

'el usuario esta usando un escudo ???
If UserList(VictimaIndex).Invent.EscudoEqpObjIndex > 0 Then
    
    'Fallo ???
    If UsuarioImpacto = False Then
      ProbRechazo = Maximo(10, Minimo(90, 100 * (SkillDefensa / (SkillDefensa + SkillTacticas))))
      rechazo = (RandomNumber(1, 100) <= ProbRechazo)
      If rechazo = True Then
      'Se rechazo el ataque con el escudo
              Call SendData(SendTarget.ToPCArea, VictimaIndex, PrepareMessagePlayWave(SND_ESCUDO, UserList(VictimaIndex).Pos.X, UserList(VictimaIndex).Pos.Y))
              Call SendData(SendTarget.ToPCArea, VictimaIndex, PrepareMessageAnim_Attack(UserList(VictimaIndex).Char.CharIndex))

              Call WriteBlockedWithShieldOther(AtacanteIndex)
              Call WriteBlockedWithShieldUser(VictimaIndex)

      End If
    End If
End If
    
Call FlushBuffer(VictimaIndex)
End Function

Public Sub UsuarioAtacaUsuario(ByVal AtacanteIndex As Integer, ByVal VictimaIndex As Integer)

If Not PuedeAtacar(AtacanteIndex, VictimaIndex) Then Exit Sub

If Distancia(UserList(AtacanteIndex).Pos, UserList(VictimaIndex).Pos) > MAXDISTANCIAARCO Then
   Call WriteConsoleMsg(AtacanteIndex, "Estás muy lejos para disparar.", FontTypeNames.FONTTYPE_FIGHT)
   Exit Sub
End If


Call UsuarioAtacadoPorUsuario(AtacanteIndex, VictimaIndex)

If UsuarioImpacto(AtacanteIndex, VictimaIndex) Then
    Call SendData(SendTarget.ToPCArea, AtacanteIndex, PrepareMessagePlayWave(SND_IMPACTO, UserList(AtacanteIndex).Pos.X, UserList(AtacanteIndex).Pos.Y))
    
    If UserList(VictimaIndex).Flags.Navegando = 0 Then
        Call SendData(SendTarget.ToPCArea, VictimaIndex, PrepareMessageCreateFX(UserList(VictimaIndex).Char.CharIndex, FXSANGRE, 0))
    End If
    honor_ataca AtacanteIndex, VictimaIndex
    Call UserDañoUser(AtacanteIndex, VictimaIndex)
    
Else
    Call SendData(SendTarget.ToPCArea, AtacanteIndex, PrepareMessagePlayWave(SND_SWING, UserList(AtacanteIndex).Pos.X, UserList(AtacanteIndex).Pos.Y))
    Call WriteUserSwing(AtacanteIndex)
    Call WriteUserAttackedSwing(VictimaIndex, AtacanteIndex)
End If

'If UserList(AtacanteIndex).clase = eClass.Thief Then Call Desarmar(AtacanteIndex, VictimaIndex)

End Sub

Public Sub UserDañoUser(ByVal AtacanteIndex As Integer, ByVal VictimaIndex As Integer)
Dim daño As Long, antdaño As Integer
Dim Lugar As Integer, absorbido As Long
Dim defbarco As Integer

Dim obj As ObjData

daño = CalcularDaño(AtacanteIndex)
antdaño = daño

Call UserEnvenena(AtacanteIndex, VictimaIndex)

If UserList(AtacanteIndex).Flags.Navegando = 1 And UserList(AtacanteIndex).Invent.BarcoObjIndex > 0 Then
     obj = ObjData(UserList(AtacanteIndex).Invent.BarcoObjIndex)
     daño = daño + RandomNumber(obj.MinHit, obj.MaxHit)
End If

If UserList(VictimaIndex).Flags.Navegando = 1 And UserList(VictimaIndex).Invent.BarcoObjIndex > 0 Then
     obj = ObjData(UserList(VictimaIndex).Invent.BarcoObjIndex)
     defbarco = RandomNumber(obj.MinDef, obj.MaxDef)
End If

Dim Resist As Byte
If UserList(AtacanteIndex).Invent.WeaponEqpObjIndex > 0 Then
    Resist = ObjData(UserList(AtacanteIndex).Invent.WeaponEqpObjIndex).Refuerzo
End If

Lugar = RandomNumber(1, 6)

Select Case Lugar
    Case PartesCuerpo.bCabeza
        'Si tiene casco absorbe el golpe
        If UserList(VictimaIndex).Invent.CascoEqpObjIndex > 0 Then
        obj = ObjData(UserList(VictimaIndex).Invent.CascoEqpObjIndex)
        absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
        absorbido = absorbido + defbarco - Resist
        daño = daño - absorbido
        If daño < 0 Then daño = 1
        End If
        Call SendData(SendTarget.ToPCArea, VictimaIndex, PrepareMessageCreateHIT(UserList(VictimaIndex).Char.CharIndex, daño, RGB(207, 67, 0)))
    Case Else
        'Si tiene armadura absorbe el golpe
        If UserList(VictimaIndex).Invent.ArmourEqpObjIndex > 0 Then
            obj = ObjData(UserList(VictimaIndex).Invent.ArmourEqpObjIndex)
            Dim Obj2 As ObjData
            If UserList(VictimaIndex).Invent.EscudoEqpObjIndex Then
                Obj2 = ObjData(UserList(VictimaIndex).Invent.EscudoEqpObjIndex)
                absorbido = RandomNumber(obj.MinDef + Obj2.MinDef, obj.MaxDef + Obj2.MaxDef)
            Else
                absorbido = RandomNumber(obj.MinDef, obj.MaxDef)
            End If
            absorbido = absorbido + defbarco - Resist
            daño = daño - absorbido
            If daño < 0 Then daño = 1
        End If
        Call SendData(SendTarget.ToPCArea, VictimaIndex, PrepareMessageCreateHIT(UserList(VictimaIndex).Char.CharIndex, daño, vbRed))
End Select

Call WriteUserHittedUser(AtacanteIndex, Lugar, UserList(VictimaIndex).Char.CharIndex, daño)
Call WriteUserHittedByUser(VictimaIndex, Lugar, UserList(AtacanteIndex).Char.CharIndex, daño)

UserList(VictimaIndex).Stats.MinHP = UserList(VictimaIndex).Stats.MinHP - daño

        If PuedeApuñalar(AtacanteIndex) Then
            Call DoApuñalar(AtacanteIndex, 0, VictimaIndex, daño)
        End If
        'e intenta dar un golpe crítico [Pablo (ToxicWaste)]
        'Call DoGolpeCritico(AtacanteIndex, 0, VictimaIndex, daño)


If UserList(VictimaIndex).Stats.MinHP <= 0 Then
    'Store it!
    'Call Statistics.StoreFrag(AtacanteIndex, VictimaIndex)
    
    Call ContarMuerte(VictimaIndex, AtacanteIndex)
    
    'Para que las mascotas no sigan intentando luchar y
    'comiencen a seguir al amo
    Dim j As Integer
    For j = 1 To MAXMASCOTAS
        If UserList(AtacanteIndex).MascotasIndex(j) > 0 Then
            If Npclist(UserList(AtacanteIndex).MascotasIndex(j)).Target = VictimaIndex Then
                Npclist(UserList(AtacanteIndex).MascotasIndex(j)).Target = 0
                Call FollowAmo(UserList(AtacanteIndex).MascotasIndex(j))
            End If
        End If
    Next j
    
    Call ActStats(VictimaIndex, AtacanteIndex)
Else
    'Está vivo - Actualizamos el HP
    Call WriteUpdateHP(VictimaIndex)
End If

'Controla el nivel del usuario
Call CheckUserLevel(AtacanteIndex)

Call FlushBuffer(VictimaIndex)
End Sub

Sub UsuarioAtacadoPorUsuario(ByVal AttackerIndex As Integer, ByVal VictimIndex As Integer)

    If TriggerZonaPelea(AttackerIndex, VictimIndex) = TRIGGER6_PERMITE Then Exit Sub
    
    Dim EraCriminal As Boolean
    
    If criminal(AttackerIndex) = criminal(VictimIndex) And atacaequipo = False Then
        Exit Sub
    End If
    
    If UserList(VictimIndex).Flags.Meditando Then
        UserList(VictimIndex).Flags.Meditando = False
        Call WriteMeditateToggle(VictimIndex)
        Call WriteConsoleMsg(VictimIndex, "Dejas de meditar.", FontTypeNames.FONTTYPE_INFO)
        UserList(VictimIndex).Char.FX = 0
        UserList(VictimIndex).Char.loops = 0
        Call SendData(SendTarget.ToPCArea, VictimIndex, PrepareMessageCreateFX(UserList(VictimIndex).Char.CharIndex, 0, 0))
    End If
    
    Call AllMascotasAtacanUser(AttackerIndex, VictimIndex)
    Call AllMascotasAtacanUser(VictimIndex, AttackerIndex)
    
    'Si la victima esta saliendo se cancela la salida
    Call CancelExit(VictimIndex)
    Call FlushBuffer(VictimIndex)
End Sub

Sub AllMascotasAtacanUser(ByVal victim As Integer, ByVal Maestro As Integer)
'Reaccion de las mascotas
Dim iCount As Integer

For iCount = 1 To MAXMASCOTAS
    If UserList(Maestro).MascotasIndex(iCount) > 0 Then
            Npclist(UserList(Maestro).MascotasIndex(iCount)).Flags.AttackedBy = UserList(victim).name
            If Npclist(UserList(Maestro).MascotasIndex(iCount)).Bot.BotType = 0 Then Npclist(UserList(Maestro).MascotasIndex(iCount)).Movement = TipoAI.NPCDEFENSA
            Npclist(UserList(Maestro).MascotasIndex(iCount)).Hostile = 1
    End If
Next iCount

End Sub

Public Function PuedeAtacar(ByVal AttackerIndex As Integer, ByVal VictimIndex As Integer) As Boolean
Dim t As eTrigger6
Dim rank As Integer
'MUY importante el orden de estos "IF"...

'Estas muerto no podes atacar
If UserList(AttackerIndex).Flags.Muerto = 1 Then
    'Call WriteConsoleMsg(attackerIndex, "No podés atacar porque estas muerto", FontTypeNames.FONTTYPE_INFO)
    PuedeAtacar = False
    Exit Function
End If

'No podes atacar a alguien muerto
If UserList(VictimIndex).Flags.Muerto = 1 Then
    'Call WriteConsoleMsg(attackerIndex, "No podés atacar a un espiritu", FontTypeNames.FONTTYPE_INFO)
    PuedeAtacar = False
    Exit Function
End If

If atacaequipo = False Then
    If criminal(VictimIndex) = criminal(AttackerIndex) Then
        Call WriteConsoleMsg(AttackerIndex, "No podes atacar a tus compañeros.", FontTypeNames.FONTTYPE_WARNING)
        PuedeAtacar = False
        Exit Function
    End If
End If

PuedeAtacar = True

End Function

Public Function PuedeAtacarNPC(ByVal AttackerIndex As Integer, ByVal NpcIndex As Integer) As Boolean
If UserList(AttackerIndex).Flags.Muerto = 1 Then
    'Call WriteConsoleMsg(AttackerIndex, "No podés atacar porque estas muerto", FontTypeNames.FONTTYPE_INFO)
    PuedeAtacarNPC = False
    Exit Function
End If
If Npclist(NpcIndex).Muerto = 1 Then
    'Call WriteConsoleMsg(AttackerIndex, "No puedes atacar a los muertos.", FontTypeNames.FONTTYPE_INFO)
    PuedeAtacarNPC = False
    Exit Function
End If
If UserList(AttackerIndex).Bando = Npclist(NpcIndex).Bando And Npclist(NpcIndex).Bando <> eKip.enone Then
    Call WriteConsoleMsg(AttackerIndex, "No puedes atacar a compañeros.", FontTypeNames.FONTTYPE_INFO)
    PuedeAtacarNPC = False
    Exit Function
End If
'Es valida la distancia a la cual estamos atacando?
If Distancia(UserList(AttackerIndex).Pos, Npclist(NpcIndex).Pos) >= MAXDISTANCIAARCO Then
   Call WriteConsoleMsg(AttackerIndex, "Estás muy lejos para disparar.", FontTypeNames.FONTTYPE_FIGHT)
   PuedeAtacarNPC = False
   Exit Function
End If

PuedeAtacarNPC = True

End Function



Public Function TriggerZonaPelea(ByVal Origen As Integer, ByVal destino As Integer) As eTrigger6
'TODO: Pero que rebuscado!!
'Nigo:  Te lo rediseñe, pero no te borro el TODO para que lo revises.
On Error GoTo ErrHandler
    Dim tOrg As eTrigger
    Dim tDst As eTrigger
    
    tOrg = MapData(UserList(Origen).Pos.map, UserList(Origen).Pos.X, UserList(Origen).Pos.Y).trigger
    tDst = MapData(UserList(destino).Pos.map, UserList(destino).Pos.X, UserList(destino).Pos.Y).trigger
    
    If tOrg = eTrigger.ZONAPELEA Or tDst = eTrigger.ZONAPELEA Then
        If tOrg = tDst Then
            TriggerZonaPelea = TRIGGER6_PERMITE
        Else
            TriggerZonaPelea = TRIGGER6_PROHIBE
        End If
    Else
        TriggerZonaPelea = TRIGGER6_AUSENTE
    End If

Exit Function
ErrHandler:
    TriggerZonaPelea = TRIGGER6_AUSENTE
    LogError ("Error en TriggerZonaPelea - " & ERR.Description)
End Function

Sub UserEnvenena(ByVal AtacanteIndex As Integer, ByVal VictimaIndex As Integer)
Dim ArmaObjInd As Integer, ObjInd As Integer
Dim Num As Long

ArmaObjInd = UserList(AtacanteIndex).Invent.WeaponEqpObjIndex
ObjInd = 0

If ArmaObjInd > 0 Then
    If ObjData(ArmaObjInd).proyectil = 0 Then
        ObjInd = ArmaObjInd
    Else
        ObjInd = UserList(AtacanteIndex).Invent.MunicionEqpObjIndex
    End If
    
    If ObjInd > 0 Then
        If (ObjData(ObjInd).Envenena = 1) Then
            Num = RandomNumber(1, 100)
            
            If Num < 60 Then
                UserList(VictimaIndex).Flags.Envenenado = 1
                Call WriteConsoleMsg(VictimaIndex, UserList(AtacanteIndex).name & " te ha envenenado!!", FontTypeNames.FONTTYPE_FIGHT)
                Call WriteConsoleMsg(AtacanteIndex, "Has envenenado a " & UserList(VictimaIndex).name & "!!", FontTypeNames.FONTTYPE_FIGHT)
            End If
        End If
    End If
End If

Call FlushBuffer(VictimaIndex)
End Sub

