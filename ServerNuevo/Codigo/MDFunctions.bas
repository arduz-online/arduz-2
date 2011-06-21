Attribute VB_Name = "modOtherStuff"
Option Explicit
Public svname As String
Public menduz As String
Public valeresu As Boolean
Public valeestu As Boolean
Public valeinvi As Boolean
Public rondaa As Long
Public rondaact As Boolean

Public servermap As Integer
Public atacaequipo As Boolean
Public enviarank As Boolean
Public deathm As Boolean
Public botsact As Boolean
Public mankismo As Integer
Public winpk As Long
Public winciu As Long
Public fatuos As Boolean
Public inmoact As Boolean

Public resuauto As Boolean

Public passcerrado As String

Public OFICIAL As Byte

Public WEBCLASS As New clsWebLink

Public adminpasswd As String

Public deathmatch As Boolean

Type jugador
    UserIndex As Integer
    Activado As Boolean
    Frags As Integer
    gano As Integer
    muertes As Integer
End Type

Type ekipos
    Jugadores(1 To 50) As jugador
    NumJugadores As Integer
    Uservivos As Integer
    UserMuertos As Integer
    gano As Integer
    perdio As Integer
    npcact As Boolean
    NPCs(1 To 50) As Integer
End Type

Public equipos(0 To 2) As ekipos


Public Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Public Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal sURL As String, ByVal sHeaders As String, ByVal lHeadersLength As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
Public Declare Function InternetReadFile Lib "wininet.dll" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Public Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer

Public Const IF_FROM_CACHE = &H1000000
Public Const IF_MAKE_PERSISTENT = &H2000000
Public Const IF_NO_CACHE_WRITE = &H4000000

Enum mobe
    Ban = 1
    map = 2
    kick = 3
End Enum

Type Votacion
    MapOrBan As mobe
    Candidatos(20) As Integer
    Votos(20) As Integer
    desc As String
    activada As Boolean
End Type

Public ActVot As Votacion


Public Sub enviaser()
Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Servidor: " & svname & " - Tiempo de ronda: " & IIf(rondaact = True, (rondaa / 60) & " Minutos.", "Infinito")))
If valeinvi = True Then
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Invisibilidad esta ACTIVADA"))
Else
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Invisibilidad esta DESACTIVADA"))
End If
If valeestu = True Then
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Estupidez esta ACTIVADA"))
Else
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Estupidez esta DESACTIVADA"))
End If
If valeresu = True Then
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Resucitar esta ACTIVADA"))
Else
    Call SendData(SendTarget.ToAll, 0, PrepareMessageGuildChat("Resucitar esta DESACTIVADA"))
End If
End Sub

Public Sub SendMOTD(ByVal UserIndex As Integer)
    Dim j As Long
    Call WriteGuildChat(UserIndex, "¡Bienvenido a Arduz!")
End Sub


Public Sub enviaser1(UI As Integer)
Call WriteGuildChat(UI, "Servidor: " & svname & " - Tiempo de ronda: " & IIf(rondaact = True, (rondaa / 60) & " Minutos.", "Infinito"))
If valeinvi = True Then
    Call WriteGuildChat(UI, "Invisibilidad esta ACTIVADA")
Else
    Call WriteGuildChat(UI, "Invisibilidad esta DESACTIVADA")
End If
If valeestu = True Then
    Call WriteGuildChat(UI, "Estupidez esta ACTIVADA")
Else
    Call WriteGuildChat(UI, "Estupidez esta DESACTIVADA")
End If
If valeresu = True Then
    Call WriteGuildChat(UI, "Resucitar esta ACTIVADA")
Else
    Call WriteGuildChat(UI, "Resucitar esta DESACTIVADA")
End If
End Sub


'////////////////////////////////////////////////
Public Function Uservivos(tipo As eKip) As Integer
Uservivos = equipos(tipo).Uservivos
End Function

Public Function UserMuertos(tipo As eKip) As Integer
UserMuertos = equipos(tipo).UserMuertos
End Function

Public Function UserBando(tipo As eKip) As Integer
UserBando = equipos(tipo).NumJugadores
End Function

Public Sub ActEkipos()
Dim i As Integer
Dim ETMP As ekipos


equipos(0) = ETMP
equipos(1) = ETMP
equipos(2) = ETMP

For i = 1 To LastUser
    With UserList(i)
        If .ConnID <> -1 Then
            If .ConnIDValida And .flags.UserLogged Then
                equipos(.Bando).NumJugadores = equipos(.Bando).NumJugadores + 1
                If .flags.Muerto Then
                    equipos(.Bando).UserMuertos = equipos(.Bando).UserMuertos + 1
                Else
                    equipos(.Bando).Uservivos = equipos(.Bando).Uservivos + 1
                End If
            End If
        End If
    End With
Next i

End Sub

Sub LlevaraTrigger(trigger As eTrigger, UserIndex As Integer, Optional warp As Boolean = True)
Dim XX As Byte
Dim yy As Byte
Dim salirfor As Boolean
For XX = 9 To 90
    If salirfor = False Then
        For yy = 9 To 90
            If MapData(servermap, XX, yy).trigger = trigger And LegalPos(servermap, XX, yy, False, True) = True And (MapData(servermap, XX, yy).UserIndex <> 0 Or MapData(servermap, XX, yy).NpcIndex <> 0) Then
                        If warp = False Then
                            UserList(UserIndex).Pos.x = XX
                            UserList(UserIndex).Pos.y = yy
                        Else
                            Call WarpUserChar(UserIndex, servermap, XX, yy)
                            If UserList(UserIndex).flags.Paralizado = 1 Then
                                UserList(UserIndex).flags.Paralizado = 0
                                Call WriteParalizeOK(UserIndex)
                            End If
                            
                            '<<< Estupidez >>>
                            If UserList(UserIndex).flags.Estupidez = 1 Then
                                UserList(UserIndex).flags.Estupidez = 0
                                Call WriteDumbNoMore(UserIndex)
                            End If
                            salirfor = True
                        End If
                        Exit For
            End If
        Next yy
    Else
        Exit For
    End If
Next XX

End Sub

Sub LlevaraBase(UserIndex As Integer)
Dim XX As Byte
Dim yy As Byte
Dim trigger As eTrigger
If UserList(UserIndex).Bando = eKip.ePK Then
trigger = eTrigger.RESUPK
ElseIf UserList(UserIndex).Bando = eKip.eCui Then
trigger = eTrigger.RESUCIU
Else
Llevararand UserIndex
Exit Sub
End If
Dim salirfor As Boolean
For XX = 9 To 90
    If salirfor = False Then
        For yy = 9 To 90
            If MapData(servermap, XX, yy).trigger = trigger And LegalPos(servermap, XX, yy, False, True) = True And MapData(servermap, XX, yy).UserIndex = 0 And MapData(servermap, XX, yy).NpcIndex = 0 Then
                        Call WarpUserChar(UserIndex, servermap, XX, yy)
                        If UserList(UserIndex).flags.Paralizado = 1 Then
                            UserList(UserIndex).flags.Paralizado = 0
                            Call WriteParalizeOK(UserIndex)
                        End If
                        
                        '<<< Estupidez >>>
                        If UserList(UserIndex).flags.Estupidez = 1 Then
                            UserList(UserIndex).flags.Estupidez = 0
                            Call WriteDumbNoMore(UserIndex)
                        End If
                        salirfor = True
                        Exit For
            End If
        Next yy
    Else
        Exit For
    End If
Next XX

RefreshCharStatus UserIndex
'UpdateUserInv True, UserIndex, 0
End Sub



Public Sub DoVoteMap()
Dim VTMP As Votacion
ActVot = VTMP
Dim i As Integer
With ActVot
.MapOrBan = map
.desc = "Votemap"
.activada = True
    For i = 1 To NumMaps
    .Candidatos(i) = i
    Next i
End With
End Sub

Public Sub DoVoteban(uid As Integer)
If uid = 0 Then Exit Sub
Dim VTMP As Votacion
ActVot = VTMP
With ActVot
.activada = True
.Candidatos(1) = uid
.desc = "¿Deseas que el usuario " & UserList(uid).nick & " sea baneado del servidor?"
.MapOrBan = Ban
End With
End Sub

Public Sub DoVoteKick(uid As Integer)
If uid = 0 Then Exit Sub

Dim VTMP As Votacion
ActVot = VTMP
With ActVot
.activada = True
.Candidatos(1) = uid
.desc = "¿Deseas que el usuario " & UserList(uid).nick & " sea echado del servidor?"
.MapOrBan = kick
End With
End Sub




Public Function puede_npc(i As Integer, intervalo As Long, Optional modif As Boolean = False) As Boolean
Dim tmp As Boolean
Static tick As Long
tick = GetTickCount And &H7FFFFFFF
tmp = (tick - Npclist(i).ultimox) > intervalo
'Debug.Print tmp
If modif = True Then
Npclist(i).ultimox = tick
End If
puede_npc = tmp

End Function
Public Function puede_npc_y(i As Integer, intervalo As Long, Optional modif As Boolean = False) As Boolean
Dim tmp As Boolean
Static tick As Long
tick = GetTickCount And &H7FFFFFFF
tmp = (tick - Npclist(i).ultimoy) > intervalo
'Debug.Print tmp
If modif = True Then
Npclist(i).ultimoy = tick
End If
puede_npc_y = tmp

End Function
Public Function CanAttackNPC(ByVal NpcIndex As Integer) As Boolean
Static tick As Long
tick = GetTickCount And &H7FFFFFFF
If tick - Npclist(NpcIndex).ultimo_ataque > 1400 Then
    CanAttackNPC = True
Else
    CanAttackNPC = False
End If
End Function

'Convert a zero-terminated fixed string to a dynamic VB string
Public Function sz2string(ByVal szStr As String) As String
    sz2string = Left$(szStr, InStr(1, szStr, Chr$(0)) - 1)
End Function

Sub init_jamachi()
    If get_hamachi_active Then
        frmMain.hamaa.Enabled = True
        frmMain.hamaa.value = vbChecked
        frmMain.hamaa.ToolTipText = hIP
    End If
End Sub
