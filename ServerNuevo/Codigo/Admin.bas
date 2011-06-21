Attribute VB_Name = "modAdmins"

Option Explicit

Public Type tMotd
    texto As String
    Formato As String
End Type

Public MaxLines As Integer
Public MOTD() As tMotd

Public NPCs As Long
Public DebugSocket As Boolean

Public Horas As Long
Public Dias As Long
Public MinsRunning As Long

Public ReiniciarServer As Long

Public tInicioServer As Long

'INTERVALOS
Public SanaIntervaloSinDescansar As Integer
Public StaminaIntervaloSinDescansar As Integer
Public SanaIntervaloDescansar As Integer
Public StaminaIntervaloDescansar As Integer
Public IntervaloSed As Integer
Public IntervaloHambre As Integer
Public IntervaloVeneno As Integer
Public IntervaloParalizado As Integer
Public IntervaloInvisible As Integer
Public IntervaloFrio As Integer
Public IntervaloWavFx As Integer
Public IntervaloLanzaHechizo As Integer
Public IntervaloNPCPuedeAtacar As Integer
Public IntervaloNPCAI As Integer
Public IntervaloInvocacion As Integer
Public IntervaloOculto As Integer '[Nacho]
Public IntervaloUserPuedeAtacar As Long
Public IntervaloMagiaGolpe As Long
Public IntervaloGolpeMagia As Long
Public IntervaloUserPuedeCastear As Long
Public IntervaloUserPuedeTrabajar As Long
Public IntervaloParaConexion As Long
Public IntervaloCerrarConexion As Long '[Gonzalo]
Public IntervaloUserPuedeUsar As Long
Public IntervaloFlechasCazadores As Long
'BALANCE

Public MinutosWs As Long
Public Puerto As Integer

Public MAXPASOS As Long

Public BootDelBackUp As Byte
Public Lloviendo As Boolean
Public DeNoche As Boolean

Public IpList As New Collection
Public ClientsCommandsQueue As Byte

Public Type TCPESStats
    BytesEnviados As Double
    BytesRecibidos As Double
    BytesEnviadosXSEG As Long
    BytesRecibidosXSEG As Long
    BytesEnviadosXSEGMax As Long
    BytesRecibidosXSEGMax As Long
    BytesEnviadosXSEGCuando As Date
    BytesRecibidosXSEGCuando As Date
End Type

Public Enum dioses
    Inbaneable = 1
    xAa = 2
    XXaa = 4
    XXXa = 8
    DDDa = 16
    AdminOfis = 32
    centinela = 64
    SuperDios = 128
End Enum

Public TCPESStats As TCPESStats

Function VersionOK(ByVal Ver As String) As Boolean
VersionOK = (Ver = client_checksum)
End Function

Sub ReSpawnOrigPosNpcs()
On Error Resume Next

Dim i As Integer
Dim MiNPC As npc
   
For i = 1 To LastNPC
   'OJO
   If Npclist(i).flags.NPCActive Then
        
        If InMapBounds(Npclist(i).Orig.map, Npclist(i).Orig.X, Npclist(i).Orig.Y) And Npclist(i).numero = Guardias Then
                MiNPC = Npclist(i)
                Call QuitarNPC(i)
                Call ReSpawnNpc(MiNPC)
        End If
        
        'tildada por sugerencia de yind
        'If Npclist(i).Contadores.TiempoExistencia > 0 Then
        'Call MuereNpc(i, 0)
        'End If
   End If
   
Next i

End Sub


Public Sub BanIpAgrega(ByVal ip As String)
    BanIps.Add ip
End Sub

Public Function BanIpBuscar(ByVal ip As String) As Long
Dim Dale As Boolean
Dim loopc As Long

Dale = True
loopc = 1
Do While loopc <= BanIps.count And Dale
    Dale = (BanIps.Item(loopc) <> ip)
    loopc = loopc + 1
Loop

If Dale Then
    BanIpBuscar = 0
Else
    BanIpBuscar = loopc - 1
End If
End Function

Public Function BanIpQuita(ByVal ip As String) As Boolean

On Error Resume Next

Dim N As Long

N = BanIpBuscar(ip)
If N > 0 Then
    BanIps.Remove N
    BanIpGuardar
    BanIpQuita = True
Else
    BanIpQuita = False
End If

End Function

Public Sub BanIpGuardar()

End Sub




Public Sub ActualizaStatsES()

Static TUlt As Long
Dim Transcurrido As Long

Transcurrido = (GetTickCount() And &H7FFFFFFF) - TUlt

If Transcurrido >= 1000 Then
    TUlt = GetTickCount
    With TCPESStats
        .BytesEnviadosXSEG = CLng(.BytesEnviados / Transcurrido)
        .BytesRecibidosXSEG = CLng(.BytesRecibidos / Transcurrido)
        .BytesEnviados = 0
        .BytesRecibidos = 0
        
        If .BytesEnviadosXSEG > .BytesEnviadosXSEGMax Then
            .BytesEnviadosXSEGMax = .BytesEnviadosXSEG
            .BytesEnviadosXSEGCuando = CDate(Now)
        End If
        
        If .BytesRecibidosXSEG > .BytesRecibidosXSEGMax Then
            .BytesRecibidosXSEGMax = .BytesRecibidosXSEG
            .BytesRecibidosXSEGCuando = CDate(Now)
        End If
        
        'If frmEstadisticas.Visible Then
        'Call frmEstadisticas.ActualizaStats
        'End If
    End With
End If

End Sub

Public Function UserDarPrivilegioLevel(ByVal name As String) As PlayerType

'Author: Unknown
'03/02/07
'Last Modified By: Juan Martín Sotuyo Dodero (Maraxus)

    If EsAdmin(name) Then
        UserDarPrivilegioLevel = PlayerType.admin
    ElseIf EsDios(name) Then
        UserDarPrivilegioLevel = PlayerType.dios
    ElseIf EsSemiDios(name) Then
        UserDarPrivilegioLevel = PlayerType.SemiDios
    ElseIf EsConsejero(name) Then
        UserDarPrivilegioLevel = PlayerType.Consejero
    Else
        UserDarPrivilegioLevel = PlayerType.User
    End If
End Function

Public Sub BanCharacter(ByVal bannerUserIndex As Integer, ByVal UserName As String)
    Dim tUser As Integer
    Dim userPriv As Byte
    Dim cantPenas As Byte
    Dim rank As Integer
    
    If InStrB(UserName, "+") Then
        UserName = Replace(UserName, "+", " ")
    End If
    
    Dim bannedip As String
    With UserList(bannerUserIndex)
        If .admin = True Or (.dios And dioses.SuperDios) Or (.dios And dioses.centinela) Or (.dios And dioses.AdminOfis) Then
            tUser = NameIndex(UserName)
            If tUser > 0 Then
                If UserList(tUser).admin = True Or UserList(tUser).dios And dioses.Inbaneable Then
                    Exit Sub
                Else
                    bannedip = UserList(tUser).ip
                    If LenB(bannedip) > 0 Then
                        Call FlushBuffer(tUser)
                        Call CloseSocket(tUser)
                        Call BanIpAgrega(bannedip)
                    End If
                End If
            End If
        End If
    End With
End Sub

