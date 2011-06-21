Attribute VB_Name = "modModoAgite"
Option Explicit


Public Sub restartround()
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("RESTART ROUND EN 1 SEGUNDO..."))
    Call SendData(SendTarget.ToAll, 0, PrepareMessagePlayWave(65, NO_3D_SOUND, NO_3D_SOUND))
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
    winpk = 0
    winciu = 0
    For i = 1 To LastNPC
        If Npclist(i).Bando = eKip.ePK Then
                Npclist(i).Char.Body = iCuerpoMuerto
                Npclist(i).Char.Head = iCabezaMuerto
                Npclist(i).Char.ShieldAnim = NingunEscudo
                Npclist(i).Char.WeaponAnim = NingunArma
                Npclist(i).Char.CascoAnim = NingunCasco
        Else
                Npclist(i).Char.Body = 145
                Npclist(i).Char.Head = 501
                Npclist(i).Char.ShieldAnim = NingunEscudo
                Npclist(i).Char.WeaponAnim = NingunArma
                Npclist(i).Char.CascoAnim = NingunCasco
        End If
         Call ChangeNPCChar(i, Npclist(i).Char.Body, Npclist(i).Char.Head, Npclist(i).Char.Heading)
    Next i
    rondax = 0

End Sub

Public Sub dLlevarRand()
    Dim i As Integer
    For i = 1 To maxusers
        With UserList(i)
            If .ConnID <> -1 Then
                If .ConnIDValida And .Flags.UserLogged And .Flags.Muerto = 1 And .Bando <> enone Then
                    Llevararand i
                    Call RevivirUsuario1(i)
                    If UserList(i).clase <> Hunter Then
                        If deathm = True Then
                            UserList(i).Flags.Oculto = 1
                            UserList(i).Counters.TiempoOculto = 60
                            Call SendData(SendTarget.ToPCArea, i, PrepareMessageSetInvisible(UserList(i).Char.CharIndex, True))
                        End If
                    End If
                End If
            End If
        End With
    Next i
    rondax = 0
End Sub

Sub Llevararand(UserIndex As Integer)
    Dim XX As Byte
    Dim yy As Byte
    Dim salirfor As Boolean
    salirfor = True
    Do While salirfor
        XX = RandomNumber(10, 85)
        yy = RandomNumber(10, 85)
        If LegalPos(servermap, XX, yy, False, True) = True And MapData(servermap, XX, yy).UserIndex = 0 And MapData(servermap, XX, yy).NpcIndex = 0 And MapData(servermap, XX, yy).Blocked = 0 Then
            Call WarpUserChar(UserIndex, servermap, XX, yy)
            If UserList(UserIndex).Flags.Paralizado = 1 Then
                UserList(UserIndex).Flags.Paralizado = 0
                Call WriteParalizeOK(UserIndex)
            End If
            '<<< Estupidez >>>
            If UserList(UserIndex).Flags.Estupidez = 1 Then
                UserList(UserIndex).Flags.Estupidez = 0
                Call WriteDumbNoMore(UserIndex)
            End If
            salirfor = False
            Exit Do
        End If
    Loop
    RefreshCharStatus UserIndex
    UpdateUserInv True, UserIndex, 0
End Sub

Public Sub volverbases()
    Dim i As Integer
    For i = 1 To maxusers
        With UserList(i)
            If .ConnID <> -1 Then
                If .ConnIDValida And .Flags.UserLogged Then
                volverbase i
                End If
            End If
        End With
    Next i
    rondax = 0
End Sub

Public Sub volverbase(i As Integer)
    With UserList(i)
        If .ConnID <> -1 Then
            If .ConnIDValida And .Flags.UserLogged Then
                            LlevaraBase i
                            If .Bando <> enone Then
                                Call RevivirUsuario1(i)
                            End If
            End If
        End If
    End With
End Sub

Public Sub cambiarmapa()
    'Call SendData(SendTarget.ToAll, 0, PrepareMessagePlayWave(45, 0, 0))
    Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("MAPA CAMBIADO A: " & frmMain.mapax.List(servermap - 1), FontTypeNames.FONTTYPE_TALK))
    Dim i As Integer
    If game_cfg.modo_de_juego = modo_agite Then
        For i = 1 To MAXNPCS
            If Npclist(i).Flags.NPCActive = True Then Call QuitarNPC(i)
        Next i
    End If
    For i = 1 To maxusers 'LastUser
        With UserList(i)
           'Conexion activa?
            If .ConnID <> -1 Then
                '¿User valido?
                If .ConnIDValida And .Flags.UserLogged Then
                    If .Bando <> eKip.enone Then
                        Call UserDieInterno(i)
                        Call RevivirUsuario1(i)
                    End If
                    LlevaraBase i
                End If
            End If
        End With
    Next i
    'maxusers = MapInfo(servermap).maxusersx
    Call CrearClanPretoriano
    rondax = 0
End Sub
