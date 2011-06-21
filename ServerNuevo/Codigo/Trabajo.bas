Attribute VB_Name = "Trabajo"
Option Explicit

Public Sub DoPermanecerOculto(ByVal UserIndex As Integer)
'
'Autor: Nacho (Integer)
'Last Modif: 28/01/2007
'Chequea si ya debe mostrarse
'Pablo (ToxicWaste): Cambie los ordenes de prioridades porque sino no andaba.
'

UserList(UserIndex).Counters.TiempoOculto = UserList(UserIndex).Counters.TiempoOculto - 1
If UserList(UserIndex).Counters.TiempoOculto <= 0 Then
    
    UserList(UserIndex).Counters.TiempoOculto = IntervaloOculto
    If UserList(UserIndex).clase = eClass.Hunter Then
        'If UserList(UserIndex).Invent.ArmourEqpObjIndex = 648 Or UserList(UserIndex).Invent.ArmourEqpObjIndex = 360 Then
            Exit Sub
        'End If
    End If
    UserList(UserIndex).Counters.TiempoOculto = 0
    UserList(UserIndex).flags.Oculto = 0
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
    Call WriteConsoleMsg(UserIndex, "¡Has vuelto a ser visible!", FontTypeNames.FONTTYPE_INFO)
End If



Exit Sub

ErrHandler:
    Call LogError("Error en Sub DoPermanecerOculto")


End Sub

Public Sub DoOcultarse(ByVal UserIndex As Integer)
'Pablo (ToxicWaste): No olvidar agregar IntervaloOculto=500 al Server.ini.
'Modifique la fórmula y ahora anda bien.
On Error GoTo ErrHandler

Dim Suerte As Double
Dim res As Integer
Dim Skill As Integer

Skill = 100

Suerte = IIf(UserList(UserIndex).clase = Hunter, 30, 10)
Suerte = IIf(UserList(UserIndex).clase = Warrior, 20, 10)
res = RandomNumber(1, 100)

If res <= Suerte Then

    UserList(UserIndex).flags.Oculto = 1
    UserList(UserIndex).Counters.TiempoOculto = IIf(UserList(UserIndex).clase = Warrior, 175, 70)
  
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, True))

    Call WriteConsoleMsg(UserIndex, "¡Te has escondido entre las sombras!", FontTypeNames.FONTTYPE_INFO)
Else
    '[CDT 17-02-2004]
    If Not UserList(UserIndex).flags.UltimoMensaje = 4 Then
        Call WriteConsoleMsg(UserIndex, "¡No has logrado esconderte!", FontTypeNames.FONTTYPE_INFO)
        UserList(UserIndex).flags.UltimoMensaje = 4
    End If
    '[/CDT]
End If

UserList(UserIndex).Counters.Ocultando = UserList(UserIndex).Counters.Ocultando + 1

Exit Sub

ErrHandler:
    Call LogError("Error en Sub DoOcultarse")

End Sub


Public Sub DoNavega(ByVal UserIndex As Integer, ByRef Barco As ObjData, ByVal Slot As Integer)

Dim ModNave As Long
ModNave = ModNavegacion(UserList(UserIndex).clase)

UserList(UserIndex).Invent.BarcoObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
UserList(UserIndex).Invent.BarcoSlot = Slot

If UserList(UserIndex).flags.Navegando = 0 Then
    
    UserList(UserIndex).Char.Head = 0
    
    If UserList(UserIndex).flags.Muerto = 0 Then
        '(Nacho)
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
    Else
        UserList(UserIndex).Char.Body = iFragataFantasmal
    End If
    
    UserList(UserIndex).Char.ShieldAnim = NingunEscudo
    UserList(UserIndex).Char.WeaponAnim = NingunArma
    UserList(UserIndex).Char.CascoAnim = NingunCasco
    UserList(UserIndex).flags.Navegando = 1
    
Else
    
    UserList(UserIndex).flags.Navegando = 0
    
    If UserList(UserIndex).flags.Muerto = 0 Then
        UserList(UserIndex).Char.Head = UserList(UserIndex).OrigChar.Head
        
        If UserList(UserIndex).Invent.ArmourEqpObjIndex > 0 Then
            If UserList(UserIndex).genero = Mujer Then
                If ObjData(UserList(UserIndex).Invent.ArmourEqpObjIndex).Ropaje_mina > 0 Then
                    UserList(UserIndex).Char.Body = ObjData(UserList(UserIndex).Invent.ArmourEqpObjIndex).Ropaje_mina
                Else
                    UserList(UserIndex).Char.Body = ObjData(UserList(UserIndex).Invent.ArmourEqpObjIndex).Ropaje
                End If
            Else
                UserList(UserIndex).Char.Body = ObjData(UserList(UserIndex).Invent.ArmourEqpObjIndex).Ropaje
            End If
        Else
            Call DarCuerpoDesnudo(UserIndex)
        End If
        
        If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then _
            UserList(UserIndex).Char.ShieldAnim = ObjData(UserList(UserIndex).Invent.EscudoEqpObjIndex).ShieldAnim
        If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then _
            UserList(UserIndex).Char.WeaponAnim = ObjData(UserList(UserIndex).Invent.WeaponEqpObjIndex).WeaponAnim
        If UserList(UserIndex).Invent.CascoEqpObjIndex > 0 Then _
            UserList(UserIndex).Char.CascoAnim = ObjData(UserList(UserIndex).Invent.CascoEqpObjIndex).CascoAnim
    Else
        UserList(UserIndex).Char.Body = iCuerpoMuerto
        UserList(UserIndex).Char.Head = iCabezaMuerto
        UserList(UserIndex).Char.ShieldAnim = NingunEscudo
        UserList(UserIndex).Char.WeaponAnim = NingunArma
        UserList(UserIndex).Char.CascoAnim = NingunCasco
    End If
End If

Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
Call WriteNavigateToggle(UserIndex)

End Sub


Function TieneObjetos(ByVal ItemIndex As Integer, ByVal Cant As Integer, ByVal UserIndex As Integer) As Boolean
'Call LogTarea("Sub TieneObjetos")

Dim i As Integer
Dim total As Long
For i = 1 To MAX_INVENTORY_SLOTS
    If UserList(UserIndex).Invent.Object(i).ObjIndex = ItemIndex Then
        total = total + UserList(UserIndex).Invent.Object(i).Amount
    End If
Next i

If Cant <= total Then
    TieneObjetos = True
    Exit Function
End If
        
End Function

Function QuitarObjetos(ByVal ItemIndex As Integer, ByVal Cant As Integer, ByVal UserIndex As Integer) As Boolean
'Call LogTarea("Sub QuitarObjetos")

Dim i As Integer
For i = 1 To MAX_INVENTORY_SLOTS
    If UserList(UserIndex).Invent.Object(i).ObjIndex = ItemIndex Then
        
        Call Desequipar(UserIndex, i)
        
        UserList(UserIndex).Invent.Object(i).Amount = UserList(UserIndex).Invent.Object(i).Amount - Cant
        If (UserList(UserIndex).Invent.Object(i).Amount <= 0) Then
            Cant = Abs(UserList(UserIndex).Invent.Object(i).Amount)
            UserList(UserIndex).Invent.Object(i).Amount = 0
            UserList(UserIndex).Invent.Object(i).ObjIndex = 0
        Else
            Cant = 0
        End If
        
        Call UpdateUserInv(False, UserIndex, i)
        
        If (Cant = 0) Then
            QuitarObjetos = True
            Exit Function
        End If
    End If
Next i

End Function

Function ModNavegacion(ByVal clase As eClass) As Single
ModNavegacion = 2.3
End Function

Function FreeMascotaIndex(ByVal UserIndex As Integer) As Integer
    Dim j As Integer
    For j = 1 To MAXMASCOTAS
        If UserList(UserIndex).MascotasIndex(j) = 0 Then
            FreeMascotaIndex = j
            Exit Function
        End If
    Next j
End Function

Sub DoAdminInvisible(ByVal UserIndex As Integer)
    
    If UserList(UserIndex).flags.AdminInvisible = 0 Then
        
        'Sacamos el mimetizmo
        If UserList(UserIndex).flags.Mimetizado = 1 Then
            UserList(UserIndex).Char.Body = UserList(UserIndex).CharMimetizado.Body
            UserList(UserIndex).Char.Head = UserList(UserIndex).CharMimetizado.Head
            UserList(UserIndex).Char.CascoAnim = UserList(UserIndex).CharMimetizado.CascoAnim
            UserList(UserIndex).Char.ShieldAnim = UserList(UserIndex).CharMimetizado.ShieldAnim
            UserList(UserIndex).Char.WeaponAnim = UserList(UserIndex).CharMimetizado.WeaponAnim
            UserList(UserIndex).Counters.Mimetismo = 0
            UserList(UserIndex).flags.Mimetizado = 0
        End If
        
        UserList(UserIndex).flags.AdminInvisible = 1
        UserList(UserIndex).flags.invisible = 1
        UserList(UserIndex).flags.Oculto = 1
        UserList(UserIndex).flags.OldBody = UserList(UserIndex).Char.Body
        UserList(UserIndex).flags.OldHead = UserList(UserIndex).Char.Head
        UserList(UserIndex).Char.Body = 0
        UserList(UserIndex).Char.Head = 0
    Else
        UserList(UserIndex).flags.AdminInvisible = 0
        UserList(UserIndex).flags.invisible = 0
        UserList(UserIndex).flags.Oculto = 0
        UserList(UserIndex).Counters.TiempoOculto = 0
        UserList(UserIndex).Char.Body = UserList(UserIndex).flags.OldBody
        UserList(UserIndex).Char.Head = UserList(UserIndex).flags.OldHead
        
    End If
    
    'vuelve a ser visible por la fuerza
    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
End Sub



Public Sub DoApuñalar(ByVal UserIndex As Integer, ByVal VictimNpcIndex As Integer, ByVal VictimUserIndex As Integer, ByVal daño As Integer)
'
'Autor: Nacho (Integer) & Unknown (orginal version)
'04/17/08 - (NicoNZ)
'Simplifique la cuenta que hacia para sacar la suerte
'y arregle la cuenta que hacia para sacar el daño
'
Dim Suerte As Integer
Dim Skill As Integer

Skill = 100

Select Case UserList(UserIndex).clase
    Case eClass.Assasin
        Suerte = Int(((0.00001 * Skill - 0.001) * Skill + 0.098) * Skill + 4.25)
    Case eClass.Cleric, eClass.Paladin
        Suerte = Int(((0.000003 * Skill + 0.0006) * Skill + 0.0107) * Skill + 4.93)
    Case eClass.Bard
        Suerte = Int(((0.000002 * Skill + 0.0002) * Skill + 0.032) * Skill + 4.81)
    Case Else
        Suerte = Int(0.0361 * Skill + 4.39)
End Select

Dim total As Long
total = daño
Debug.Print Suerte
If RandomNumber(0, 100) < Suerte Then
    If VictimUserIndex <> 0 Then
        If UserList(UserIndex).clase = eClass.Assasin Then
            daño = Round(daño * 1.4, 0)
        Else
            daño = Round(daño * 1.5, 0)
        End If
        UserList(VictimUserIndex).Stats.MinHP = UserList(VictimUserIndex).Stats.MinHP - daño
        total = total + daño
        Call WriteConsoleMsg(UserIndex, "Has apuñalado a " & UserList(VictimUserIndex).name & " por " & total, FontTypeNames.FONTTYPE_FIGHT)
        Call WriteConsoleMsg(VictimUserIndex, "Te ha apuñalado " & UserList(UserIndex).name & " por " & total, FontTypeNames.FONTTYPE_FIGHT)
        Call SendData(SendTarget.ToPCArea, VictimUserIndex, PrepareMessageCreateHIT(UserList(VictimUserIndex).Char.CharIndex, total, vbYellow))
        Call FlushBuffer(VictimUserIndex)
    Else
        If UserList(UserIndex).clase = eClass.Assasin Then
            daño = Round(daño * 1.4, 0)
        Else
            daño = Round(daño * 1.5, 0)
        End If
        Npclist(VictimNpcIndex).Stats.MinHP = Npclist(VictimNpcIndex).Stats.MinHP - daño
        Call WriteConsoleMsg(UserIndex, "Has apuñalado a " & Npclist(VictimNpcIndex).name & " por " & daño, FontTypeNames.FONTTYPE_FIGHT)
        Call SendData(SendTarget.ToNPCArea, VictimNpcIndex, PrepareMessageCreateHIT(Npclist(VictimNpcIndex).Char.CharIndex, daño, vbYellow))
        '[Alejo]
    End If
Else
    Call WriteConsoleMsg(UserIndex, "¡No has logrado apuñalar a tu enemigo!", FontTypeNames.FONTTYPE_FIGHT)
End If

End Sub

Public Sub DoGolpeCritico(ByVal UserIndex As Integer, ByVal VictimNpcIndex As Integer, ByVal VictimUserIndex As Integer, ByVal daño As Integer)
'
'Autor: Pablo (ToxicWaste)
'28/01/2007
'
Dim Suerte As Integer
Dim Skill As Integer

If UserList(UserIndex).clase <> eClass.Bandit Then Exit Sub
If UserList(UserIndex).Invent.WeaponEqpSlot = 0 Then Exit Sub
If ObjData(UserList(UserIndex).Invent.WeaponEqpObjIndex).name <> "Espada Vikinga" Then Exit Sub


Skill = 100

Suerte = Int((((0.00000003 * Skill + 0.000006) * Skill + 0.000107) * Skill + 0.0493) * 100)

If RandomNumber(0, 100) < Suerte Then
    daño = Int(daño * 0.5)
    If VictimUserIndex <> 0 Then
        UserList(VictimUserIndex).Stats.MinHP = UserList(VictimUserIndex).Stats.MinHP - daño
        Call WriteConsoleMsg(UserIndex, "Has golpeado críticamente a " & UserList(VictimUserIndex).name & " por " & daño, FontTypeNames.FONTTYPE_FIGHT)
        Call WriteConsoleMsg(VictimUserIndex, UserList(UserIndex).name & " te ha golpeado críticamente por " & daño, FontTypeNames.FONTTYPE_FIGHT)
    Else
        Npclist(VictimNpcIndex).Stats.MinHP = Npclist(VictimNpcIndex).Stats.MinHP - daño
        Call WriteConsoleMsg(UserIndex, "Has golpeado críticamente a " & Npclist(VictimNpcIndex).name & " por " & daño, FontTypeNames.FONTTYPE_FIGHT)
        '[Alejo]

    End If
End If

End Sub

Public Sub DoMeditar(ByVal UserIndex As Integer)

UserList(UserIndex).Counters.IdleCount = 0

Dim Suerte As Integer
Dim res As Integer
Dim Cant As Integer

'Barrin 3/10/03
'Esperamos a que se termine de concentrar
Dim TActual As Long
TActual = GetTickCount() And &H7FFFFFFF

If UserList(UserIndex).Counters.bPuedeMeditar = False Then
    UserList(UserIndex).Counters.bPuedeMeditar = True
End If
    
If UserList(UserIndex).Stats.MinMan >= UserList(UserIndex).Stats.MaxMan Then
    Call WriteConsoleMsg(UserIndex, "Has terminado de meditar.", FontTypeNames.FONTTYPE_INFO)
    Call WriteMeditateToggle(UserIndex)
    UserList(UserIndex).flags.Meditando = False
    UserList(UserIndex).Char.FX = 0
    UserList(UserIndex).Char.loops = 0
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(UserList(UserIndex).Char.CharIndex, 0, 0))
    Exit Sub
End If
Suerte = 5

res = RandomNumber(1, Suerte)

If res = 1 Then
    Cant = Porcentaje(UserList(UserIndex).Stats.MaxMan, 3)
    If Cant <= 0 Then Cant = 1
    UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MinMan + Cant
    If UserList(UserIndex).Stats.MinMan > UserList(UserIndex).Stats.MaxMan Then _
        UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MaxMan
    
    If Not UserList(UserIndex).flags.UltimoMensaje = 22 Then
        Call WriteConsoleMsg(UserIndex, "¡Has recuperado " & Cant & " puntos de mana!", FontTypeNames.FONTTYPE_INFO)
        UserList(UserIndex).flags.UltimoMensaje = 22
    End If
    
    Call WriteUpdateMana(UserIndex)
End If

End Sub


Public Sub DoVotar(aquien As Integer, UserIndex As Integer)
Dim i As Integer
Dim total As Integer
Dim tmpx As Votacion
With ActVot
If .activada = False Then Exit Sub

    If .Votos(UserIndex) = 0 Then
        If .Candidatos(aquien) <> 0 Then
            .Votos(UserIndex) = aquien
            WriteConsoleMsg UserIndex, "Voto almacenado.", FontTypeNames.FONTTYPE_INFO
        Else
            WriteConsoleMsg UserIndex, "Voto invalido.", FontTypeNames.FONTTYPE_INFO
        End If
    Else
        WriteConsoleMsg UserIndex, "Ya votaste.", FontTypeNames.FONTTYPE_INFO
    End If
    
    If .MapOrBan = mobe.Ban Or .MapOrBan = mobe.kick Then
        If UserList(.Candidatos(1)).ConnID <> -1 And UserList(.Candidatos(1)).ConnIDValida And UserList(.Candidatos(1)).flags.UserLogged Then
            For i = 1 To NumUsers
                If .Votos(i) = .Candidatos(1) Then
                    total = total + 1
                End If
            Next i
            
            If total > (NumUsers / 2) Then
                If .MapOrBan = mobe.kick Then
                    If UserList(.Candidatos(1)).admin = True Or UserList(.Candidatos(1)).dios And dioses.Inbaneable Then
                        WriteConsoleMsg .Candidatos(1), "TE QUIEREN ECHAR DEL SERVER.", FontTypeNames.FONTTYPE_WARNING
                    Else
                        Call CloseSocket(.Candidatos(1))
                    End If
                    Dim tmp As Votacion
                    ActVot = tmp
                    Exit Sub
                ElseIf .MapOrBan = mobe.Ban Then
                    Dim tIndex As Long
                    Dim bannedip As String
                    tIndex = .Candidatos(1)
                    If UserList(tIndex).admin = True Or UserList(tIndex).dios And dioses.Inbaneable Then
                        WriteConsoleMsg .Candidatos(1), "TE QUIEREN BANEAR DEL SERVER.", FontTypeNames.FONTTYPE_WARNING
                    Else
                        Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Servidor> " & UserList(tIndex).name & " ha sido baneado. ", FontTypeNames.FONTTYPE_SERVER))
                        If tIndex > 0 Then
                            bannedip = UserList(tIndex).ip
                            If LenB(bannedip) > 0 Then
                                Call CloseSocket(tIndex)
                                Call BanIpAgrega(bannedip)
                            End If
                        End If
                    End If
                    
                    ActVot = tmpx

                    
                End If
                
            End If
        End If
    ElseIf .MapOrBan = mobe.map Then
            Dim Voto(20) As Position
            For i = 1 To NumUsers
                If .Votos(i) <> 0 Then
                    total = total + 1
                    Voto(.Candidatos(.Votos(i))).x = Voto(.Candidatos(.Votos(i))).x + 1
                    Voto(.Candidatos(.Votos(i))).y = .Candidatos(.Votos(i))
                End If
            Next i
            If total > (NumUsers / 2) Then
                Dim max As Integer
                max = 20
                Dim j As Integer
                Dim aux As Position
                Dim numero As Byte
                Do
                numero = 0
                    For i = LBound(Voto()) To max Step 1
                        For j = LBound(Voto()) To (max - 1) Step 1
                            If Voto(j).x < Voto(j + 1).x Then 'Para Descendente, Inviertes el > con <
                                aux = Voto(j + 1)
                                Voto(j + 1) = Voto(j)
                                Voto(j) = aux
                                numero = numero + 1
                            End If
                        Next j
                    Next i
                    If numero = 0 Then Exit Do
                Loop
                servermap = Voto(0).y
                frmMain.mapax.ListIndex = map - 1
                Call cambiarmapa
                ActVot = tmpx
            End If
    End If
    
End With
End Sub
