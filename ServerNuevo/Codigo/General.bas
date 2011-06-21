Attribute VB_Name = "modGeneral"

Option Explicit

Global LeerNPCs As New clsIniReader


Public inthack(7) As Integer
Public balancehack(7) As Integer
Public closebool As Boolean
#If MENDUZ_PC = 0 Then
Private Declare Sub MDFile Lib "aamd532.dll" _
        (ByVal f As String, ByVal r As String)

Private Declare Sub MDStringFix Lib "aamd532.dll" _
        (ByVal f As String, ByVal t As Long, ByVal r As String)
        
'Public Function MD5File(f As String) As String
'
'' compute MD5 digest on o given file, returning the result
'
'Dim R As String * 32
'
'    R = Space(32)
'    MDFile f, R
'    MD5File = R
'
'End Function
'
'Public Function MD5String(p As String) As String
'
'' compute MD5 digest on a given string, returning the result
'
'Dim R As String * 32, t As Long
'
'    R = Space(32)
'    t = Len(p)
'    MDStringFix p, t, R
'    MD5String = R
'
'End Function

#End If

Sub DarCuerpoDesnudo(ByVal UserIndex As Integer, Optional ByVal Mimetizado As Boolean = False)
'
'Autor: Nacho (Integer)
'03/14/07
'Da cuerpo desnudo a un usuario
'
Dim CuerpoDesnudo As Integer
Select Case UserList(UserIndex).genero
    Case eGenero.Hombre
        Select Case UserList(UserIndex).raza
            Case eRaza.Humano
                CuerpoDesnudo = 21
            Case eRaza.Drow
                CuerpoDesnudo = 32
            Case eRaza.Elfo
                CuerpoDesnudo = 210
            Case eRaza.Gnomo
                CuerpoDesnudo = 222
            Case eRaza.Enano
                CuerpoDesnudo = 53
        End Select
    Case eGenero.Mujer
        Select Case UserList(UserIndex).raza
            Case eRaza.Humano
                CuerpoDesnudo = 39
            Case eRaza.Drow
                CuerpoDesnudo = 40
            Case eRaza.Elfo
                CuerpoDesnudo = 259
            Case eRaza.Gnomo
                CuerpoDesnudo = 260
            Case eRaza.Enano
                CuerpoDesnudo = 60
        End Select
End Select

If Mimetizado Then
    UserList(UserIndex).CharMimetizado.Body = CuerpoDesnudo
Else
    UserList(UserIndex).Char.Body = CuerpoDesnudo
End If

UserList(UserIndex).Flags.Desnudo = 1

End Sub


Sub Bloquear(ByVal toMap As Boolean, ByVal sndIndex As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal b As Boolean)
'b ahora es boolean,
'b=true bloquea el tile en (x,y)
'b=false desbloquea el tile en (x,y)
'toMap = true -> Envia los datos a todo el mapa
'toMap = false -> Envia los datos al user
'Unifique los tres parametros (sndIndex,sndMap y map) en sndIndex... pero de todas formas, el mapa jamas se indica.. eso esta bien asi?
'Puede llegar a ser, que se quiera mandar el mapa, habria que agregar un nuevo parametro y modificar.. lo quite porque no se usaba ni aca ni en el cliente :s

If toMap Then
    Call SendData(SendTarget.toMap, sndIndex, PrepareMessageBlockPosition(X, Y, b))
Else
    Call WriteBlockPosition(sndIndex, X, Y, b)
End If

End Sub


Function HayAgua(ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer) As Boolean

If map > 0 And map < NumMaps + 1 And X > 0 And X < 101 And Y > 0 And Y < 101 Then
    If ((MapData(map, X, Y).Graphic(1) >= 1505 And MapData(map, X, Y).Graphic(1) <= 1520) Or _
    (MapData(map, X, Y).Graphic(1) >= 5665 And MapData(map, X, Y).Graphic(1) <= 5680) Or _
    (MapData(map, X, Y).Graphic(1) >= 13547 And MapData(map, X, Y).Graphic(1) <= 13562)) And _
       MapData(map, X, Y).Graphic(2) = 0 Then
            HayAgua = True
    Else
            HayAgua = False
    End If
Else
  HayAgua = False
End If

End Function

'Private Function HayLava(ByVal map As Integer, ByVal x As Integer, ByVal y As Integer) As Boolean
''
''Autor: Nacho (Integer)
''03/12/07
''
'If map > 0 And map < NumMaps + 1 And x > 0 And x < 101 And y > 0 And y < 101 Then
'    If MapData(map, x, y).Graphic(1) >= 5837 And MapData(map, x, y).Graphic(1) <= 5852 Then
'        HayLava = True
'    Else
'        HayLava = False
'    End If
'Else
'  HayLava = False
'End If
'
'End Function






Sub ConfigListeningSocket(ByRef obj As Object, ByVal Port As Integer)
#If UsarQueSocket = 0 Then

obj.AddressFamily = AF_INET
obj.Protocol = IPPROTO_IP
obj.SocketType = SOCK_STREAM
obj.Binary = False
obj.Blocking = False
obj.BufferSize = 1024
obj.LocalPort = Port
obj.backlog = 5
obj.listen

#End If
End Sub


Public Sub closeprogram()

    Dim f
    For Each f In Forms
        Unload f
    Next
    End
End Sub


Sub Main()
#If OFICIAL = 1 Then
OFICIAL = 1
#End If
mankismo = 0
NumMaps = 1 '5 '9 '34

ChDir app.Path
ChDrive app.Path

Prision.map = 66
Libertad.map = 66

Prision.X = 75
Prision.Y = 47
Libertad.X = 75
Libertad.Y = 65


LastBackup = Format(Now, "Short Time")
Minutos = Format(Now, "Short Time")

IniPath = app.Path & "\"
DatPath = app.Path & "\Datos\"


ListaRazas(eRaza.Humano) = "Humano"
ListaRazas(eRaza.Elfo) = "Elfo"
ListaRazas(eRaza.Drow) = "Drow"
ListaRazas(eRaza.Gnomo) = "Gnomo"
ListaRazas(eRaza.Enano) = "Enano"

ListaClases(eClass.Mage) = "Mago"
ListaClases(eClass.Cleric) = "Clerigo"
ListaClases(eClass.Warrior) = "Guerrero"
ListaClases(eClass.Assasin) = "Asesino"
ListaClases(eClass.Thief) = "Ladron"
ListaClases(eClass.Bard) = "Bardo"
ListaClases(eClass.Druid) = "Druida"
ListaClases(eClass.Bandit) = "Bandido"
ListaClases(eClass.Paladin) = "Paladin"
ListaClases(eClass.Hunter) = "Cazador"
ListaClases(eClass.Fisher) = "Pescador"
ListaClases(eClass.Blacksmith) = "Herrero"
ListaClases(eClass.Lumberjack) = "Leñador"
ListaClases(eClass.Miner) = "Minero"
ListaClases(eClass.Carpenter) = "-" '"Carpintero"
ListaClases(eClass.Pirat) = "Pirata"




With frmMain
    .cClasspe(eClass.Mage).Caption = "Mago"
    .cClasspe(eClass.Cleric).Caption = "Clerigo"
    .cClasspe(eClass.Warrior).Caption = "Guerrero"
    .cClasspe(eClass.Assasin).Caption = "Asesino"
    .cClasspe(eClass.Bard).Caption = "Bardo"
    .cClasspe(eClass.Druid).Caption = "Druida"
    .cClasspe(eClass.Paladin).Caption = "Paladin"
    .cClasspe(eClass.Hunter).Caption = "Cazador"
    .cClasspe(eClass.Mage).value = vbChecked
    .cClasspe(eClass.Cleric).value = vbChecked
    .cClasspe(eClass.Warrior).value = vbChecked
    .cClasspe(eClass.Assasin).value = vbChecked
    .cClasspe(eClass.Bard).value = vbChecked
    .cClasspe(eClass.Druid).value = vbChecked
    .cClasspe(eClass.Paladin).value = vbChecked
    .cClasspe(eClass.Hunter).value = vbChecked
End With

SkillsNames(eSkill.Suerte) = "Suerte"
SkillsNames(eSkill.magia) = "Magia"
SkillsNames(eSkill.Robar) = "Robar"
SkillsNames(eSkill.Tacticas) = "Tacticas de combate"
SkillsNames(eSkill.Armas) = "Combate con armas"
SkillsNames(eSkill.Meditar) = "Meditar"
SkillsNames(eSkill.Apuñalar) = "Apuñalar"
SkillsNames(eSkill.Ocultarse) = "Ocultarse"
SkillsNames(eSkill.Supervivencia) = "Supervivencia"
SkillsNames(eSkill.Talar) = "Talar arboles"
SkillsNames(eSkill.Comerciar) = "Comercio"
SkillsNames(eSkill.Defensa) = "Defensa con escudos"
SkillsNames(eSkill.Pesca) = "Pesca"
SkillsNames(eSkill.Mineria) = "Mineria"
SkillsNames(eSkill.Carpinteria) = "Carpinteria"
SkillsNames(eSkill.Herreria) = "Herreria"
SkillsNames(eSkill.Liderazgo) = "Liderazgo"
SkillsNames(eSkill.Domar) = "Domar animales"
SkillsNames(eSkill.Proyectiles) = "Armas de proyectiles"
SkillsNames(eSkill.Wrestling) = "Wrestling"
SkillsNames(eSkill.Navegacion) = "Navegacion"

ListaAtributos(eAtributos.Fuerza) = "Fuerza"
ListaAtributos(eAtributos.Agilidad) = "Agilidad"
ListaAtributos(eAtributos.Inteligencia) = "Inteligencia"
ListaAtributos(eAtributos.Carisma) = "Carisma"
ListaAtributos(eAtributos.Constitucion) = "Constitucion"

frmMain.Caption = "Arduz Online Server v" & game_version & " release " & app.Revision
IniPath = app.Path & "\"
CharPath = app.Path & "\Charfile\"

'Bordes del mapa
MinXBorder = XMinMapSize + (XWindow \ 2)
MaxXBorder = MapSize - (XWindow \ 2)
MinYBorder = YMinMapSize + (YWindow \ 2)
MaxYBorder = MapSize - (YWindow \ 2)

maxusers = 0
Call LoadSini
Call LoadBalance

'[MODIFICADO]
Call CargarHechizosBot
Call CargarZonasBot
Call CargarBanderas
'[/MODIFICADO]
svname = "Nombre del servidor"
botsact = True
mankismo = 2
menduz = "mzbbfdtt"
rondaa = 60 * 5
valeestu = True
atacaequipo = False
valeinvi = True
valeresu = True
rondaact = False
enviarank = True
deathm = False
fatuos = True


'Open "C:\PC VIEJA\aonuevo\NOBIN\INIT\Razas.xml" For Input As #1
'    Do Until EOF(1)
'        Input #1, data
'        buf = buf & data & vbCrLf
'    Loop
'Close #1
'
'Cargar_clases_Raw buf

'#If SOLOAGITE = 0 Then
'    frmChoice.Show
'#Else
BS_Init_Table
Set frmMain.WEBB = New clsWEBA
    Iniciar_Agite
    DoEvents
'    #If OFICIAL = 1 Then
'        frmMain.maxu.ListIndex = 46
'        frmMain.Iniciarsv_Click
'    #End If
'#End If
Call frmMain.LeerLineaComandos
End Sub

Function FileExist(ByVal FILE As String, Optional FileType As VbFileAttribute = vbNormal) As Boolean
'
'Se fija si existe el archivo
'
    FileExist = LenB(dir$(FILE, FileType)) <> 0
End Function

Function ReadField(ByVal Pos As Integer, ByRef text As String, ByVal SepASCII As Byte) As String
'
'Gets a field from a string

'Last Modify Date: 11/15/2004
'Gets a field from a delimited string
'
    Dim i As Long
    Dim LastPos As Long
    Dim CurrentPos As Long
    Dim delimiter As String * 1
    
    delimiter = Chr$(SepASCII)
    
    For i = 1 To Pos
        LastPos = CurrentPos
        CurrentPos = InStr(LastPos + 1, text, delimiter, vbBinaryCompare)
    Next i
    
    If CurrentPos = 0 Then
        ReadField = mid$(text, LastPos + 1, Len(text) - LastPos)
    Else
        ReadField = mid$(text, LastPos + 1, CurrentPos - LastPos - 1)
    End If
End Function

Function MapaValido(ByVal map As Integer) As Boolean
MapaValido = map >= 1 And map <= NumMaps
End Function

Sub MostrarNumUsers()
frmMain.ActualizaListaPjs
frmMain.CantUsuarios.Caption = "Numero de usuarios jugando: " & NumUsers
If NumUsers = maxusers Or NumUsers = maxusers - 1 Then WEBCLASS.PingToWeb
End Sub


Public Sub LogCriticEvent(desc As String)
On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open app.Path & "\logs\Eventos.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & desc
Close #nFile
Debug.Print Date & " " & Time & " " & desc
Exit Sub

ErrHandler:

End Sub





Public Sub LogIP(ByVal STR As String)

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open app.Path & "\logs\IP.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & STR
Close #nFile

End Sub


Public Sub LogDesarrollo(ByVal STR As String)

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open app.Path & "\logs\desarrollo" & Month(Date) & Year(Date) & ".log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & STR
Close #nFile

End Sub



Public Sub LogGM(nombre As String, texto As String)
On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
'Guardamos todo en el mismo lugar. Pablo (ToxicWaste) 18/05/07
Open app.Path & "\logs\" & nombre & ".log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & texto
Close #nFile

Exit Sub

ErrHandler:

End Sub

Public Sub SaveDayStats()
''On Error GoTo errhandler
''
''Dim nfile As Integer
''nfile = FreeFile 'obtenemos un canal
''Open App.Path & "\logs\" & Replace(Date, "/", "-") & ".log" For Append Shared As #nfile
''
''Print #nfile, "<stats>"
''Print #nfile, "<ao>"
''Print #nfile, "<dia>" & Date & "</dia>"
''Print #nfile, "<hora>" & Time & "</hora>"
''Print #nfile, "<segundos_total>" & DayStats.Segundos & "</segundos_total>"
''Print #nfile, "<max_user>" & DayStats.MaxUsuarios & "</max_user>"
''Print #nfile, "</ao>"
''Print #nfile, "</stats>"
''
''
''Close #nfile
Exit Sub

ErrHandler:

End Sub







Function ValidInputNP(ByVal cad As String) As Boolean
Dim Arg As String
Dim i As Integer


For i = 1 To 33

Arg = ReadField(i, cad, 44)

If LenB(Arg) = 0 Then Exit Function

Next i

ValidInputNP = True

End Function


Sub Restart()


'Se asegura de que los sockets estan cerrados e ignora cualquier err
On Error Resume Next

If frmMain.Visible Then frmMain.txStatus.Caption = "Reiniciando."

Dim loopc As Long
  
#If UsarQueSocket = 0 Then

    frmMain.Socket1.Cleanup
    frmMain.Socket1.Startup
      
    frmMain.Socket2(0).Cleanup
    frmMain.Socket2(0).Startup

#ElseIf UsarQueSocket = 1 Then

    'Cierra el socket de escucha
    If SockListen >= 0 Then Call apiclosesocket(SockListen)
    
    'Inicia el socket de escucha
    SockListen = ListenForConnect(Puerto, hWndMsg, "")

#ElseIf UsarQueSocket = 2 Then

#End If

For loopc = 1 To maxusers
    Call CloseSocket(loopc)
Next

'Initialize statistics!!


For loopc = 1 To UBound(UserList())
    Set UserList(loopc).incomingData = Nothing
    Set UserList(loopc).outgoingData = Nothing
Next loopc

ReDim UserList(1 To maxusers) As User

For loopc = 1 To maxusers
    UserList(loopc).ConnID = -1
    UserList(loopc).ConnIDValida = False
    Set UserList(loopc).incomingData = New clsByteQueue
    Set UserList(loopc).outgoingData = New clsByteQueue
Next loopc

LastUser = 0
NumUsers = 0

Call FreeNPCs
Call FreeCharIndexes

Call LoadSini
Call LoadOBJData

Call LoadMapData

Call CargarHechizos

#If UsarQueSocket = 0 Then

'Setup socket
frmMain.Socket1.AddressFamily = AF_INET
frmMain.Socket1.Protocol = IPPROTO_IP
frmMain.Socket1.SocketType = SOCK_STREAM
frmMain.Socket1.Binary = False
frmMain.Socket1.Blocking = False
frmMain.Socket1.BufferSize = 1024

frmMain.Socket2(0).AddressFamily = AF_INET
frmMain.Socket2(0).Protocol = IPPROTO_IP
frmMain.Socket2(0).SocketType = SOCK_STREAM
frmMain.Socket2(0).Blocking = False
frmMain.Socket2(0).BufferSize = 2048

'Escucha
frmMain.Socket1.LocalPort = val(Puerto)
frmMain.Socket1.listen

#ElseIf UsarQueSocket = 1 Then

#ElseIf UsarQueSocket = 2 Then

#End If

If frmMain.Visible Then frmMain.txStatus.Caption = "Escuchando conexiones entrantes ..."

'Log it
Dim N As Integer
N = FreeFile
Open app.Path & "\logs\Main.log" For Append Shared As #N
Print #N, Date & " " & Time & " servidor reiniciado."
Close #N

'Ocultar

If HideMe = 1 Then
    Call frmMain.InitMain(1)
Else
    Call frmMain.InitMain(0)
End If

End Sub


Public Function Intemperie(ByVal UserIndex As Integer) As Boolean
    
    If MapInfo(UserList(UserIndex).Pos.map).Zona <> "DUNGEON" Then
        If MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).trigger <> 1 And _
           MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).trigger <> 2 And _
           MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).trigger <> 4 Then Intemperie = True
    Else
        Intemperie = False
    End If
    
End Function


Public Sub TiempoInvocacion(ByVal UserIndex As Integer)
Dim i As Integer
For i = 1 To MAXMASCOTAS
    If UserList(UserIndex).MascotasIndex(i) > 0 Then
        If Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia > 0 Then
           Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia = _
           Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia - 1
           If Npclist(UserList(UserIndex).MascotasIndex(i)).Contadores.TiempoExistencia = 0 Then Call MuereNpc(UserList(UserIndex).MascotasIndex(i), 0)
        End If
    End If
Next i
End Sub


''
'Maneja el tiempo y el efecto del mimetismo
'
'UserIndex  El index del usuario a ser afectado por el mimetismo
'

Public Sub EfectoMimetismo(ByVal UserIndex As Integer)
'
'Author: Unknown
'Last Update: 04/11/2008 (NicoNZ)
'
'
    Dim Barco As ObjData
    
    With UserList(UserIndex)
        If .Counters.Mimetismo < IntervaloInvisible Then
            .Counters.Mimetismo = .Counters.Mimetismo + 1
        Else
            'restore old char
            Call WriteConsoleMsg(UserIndex, "Recuperas tu apariencia normal.", FontTypeNames.FONTTYPE_INFO)
            
            If .Flags.Navegando Then
                If .Flags.Muerto = 0 Then
                    If .Faccion.ArmadaReal = 1 Then
                        .Char.Body = iFragataReal
                    ElseIf .Faccion.FuerzasCaos = 1 Then
                        .Char.Body = iFragataCaos
                    Else
                        Barco = ObjData(UserList(UserIndex).Invent.BarcoObjIndex)
                        If criminal(UserIndex) Then
                            If Barco.Ropaje = iBarca Then .Char.Body = iBarcaPk
                            If Barco.Ropaje = iGalera Then .Char.Body = iGaleraPk
                            If Barco.Ropaje = iGaleon Then .Char.Body = iGaleonPk
                        Else
                            If Barco.Ropaje = iBarca Then .Char.Body = iBarcaCiuda
                            If Barco.Ropaje = iGalera Then .Char.Body = iGaleraCiuda
                            If Barco.Ropaje = iGaleon Then .Char.Body = iGaleonCiuda
                        End If
                    End If
                Else
                    .Char.Body = iFragataFantasmal
                End If
                
                .Char.ShieldAnim = NingunEscudo
                .Char.WeaponAnim = NingunArma
                .Char.CascoAnim = NingunCasco
            Else
                .Char.Body = .CharMimetizado.Body
                .Char.Head = .CharMimetizado.Head
                .Char.CascoAnim = .CharMimetizado.CascoAnim
                .Char.ShieldAnim = .CharMimetizado.ShieldAnim
                .Char.WeaponAnim = .CharMimetizado.WeaponAnim
            End If
            
            With .Char
                Call ChangeUserChar(UserIndex, .Body, .Head, .Heading, .WeaponAnim, .ShieldAnim, .CascoAnim)
            End With
            
            .Counters.Mimetismo = 0
            .Flags.Mimetizado = 0
        End If
    End With
End Sub

Public Sub EfectoInvisibilidad(ByVal UserIndex As Integer)

If UserList(UserIndex).Counters.Invisibilidad < IntervaloInvisible Then
    UserList(UserIndex).Counters.Invisibilidad = UserList(UserIndex).Counters.Invisibilidad + 1
Else
    UserList(UserIndex).Counters.Invisibilidad = 0
    UserList(UserIndex).Flags.invisible = 0
    If UserList(UserIndex).Flags.Oculto = 0 Then
        Call WriteConsoleMsg(UserIndex, "Has vuelto a ser visible.", FontTypeNames.FONTTYPE_INFO)
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(UserList(UserIndex).Char.CharIndex, False))
    End If
End If

End Sub


Public Sub EfectoParalisisNpc(ByVal NpcIndex As Integer)
'[MODIFICADO] Sistema de Bots de MaTeO
If Npclist(NpcIndex).Contadores.Paralisis = IntervaloParalizado - Npclist(NpcIndex).Contadores.ParalisisRemo And Npclist(NpcIndex).Bot.BotType <> 0 Then
    Call AmigoRemo(NpcIndex, 1)
    Npclist(NpcIndex).Contadores.ParalisisRemo = Npclist(NpcIndex).Contadores.ParalisisRemo + 20
End If
'[/MODIFICADO] Sistema de Bots de MaTeO

If Npclist(NpcIndex).Contadores.Paralisis > 0 Then
    Npclist(NpcIndex).Contadores.Paralisis = Npclist(NpcIndex).Contadores.Paralisis - 1
Else
    Npclist(NpcIndex).Flags.Paralizado = 0
    Npclist(NpcIndex).Flags.Inmovilizado = 0
End If

End Sub

Public Sub EfectoCegueEstu(ByVal UserIndex As Integer)

If UserList(UserIndex).Counters.Ceguera > 0 Then
    UserList(UserIndex).Counters.Ceguera = UserList(UserIndex).Counters.Ceguera - 1
Else
    If UserList(UserIndex).Flags.Ceguera = 1 Then
        UserList(UserIndex).Flags.Ceguera = 0
        Call WriteBlindNoMore(UserIndex)
    End If
    If UserList(UserIndex).Flags.Estupidez = 1 Then
        UserList(UserIndex).Flags.Estupidez = 0
        Call WriteDumbNoMore(UserIndex)
    End If

End If


End Sub


Public Sub EfectoParalisisUser(ByVal UserIndex As Integer)
'[MODIFICADO] Sistema de Bots de MaTeO
If UserList(UserIndex).Counters.Paralisis = IntervaloParalizado - UserList(UserIndex).Counters.ParalisisRemo Then
    Call AmigoRemo(UserIndex, 2)
    UserList(UserIndex).Counters.ParalisisRemo = UserList(UserIndex).Counters.ParalisisRemo + 20
End If
'[/MODIFICADO] Sistema de Bots de MaTeO
If UserList(UserIndex).Counters.Paralisis > 0 Then
    UserList(UserIndex).Counters.Paralisis = UserList(UserIndex).Counters.Paralisis - 1
Else
    UserList(UserIndex).Flags.Paralizado = 0
    UserList(UserIndex).Flags.Inmovilizado = 0
    'UserList(UserIndex).Flags.AdministrativeParalisis = 0
    Call WriteParalizeOK(UserIndex)
End If

End Sub

Public Sub EfectoVeneno(ByVal UserIndex As Integer)
Dim N As Integer

If UserList(UserIndex).Counters.Veneno < IntervaloVeneno Then
  UserList(UserIndex).Counters.Veneno = UserList(UserIndex).Counters.Veneno + 1
Else
  Call WriteConsoleMsg(UserIndex, "Estás envenenado, si no te curas moriras.", FontTypeNames.FONTTYPE_VENENO)
  UserList(UserIndex).Counters.Veneno = 0
  N = RandomNumber(1, 5)
  UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MinHP - N
  If UserList(UserIndex).Stats.MinHP < 1 Then Call UserDie(UserIndex)
  Call WriteUpdateHP(UserIndex)
End If

End Sub

Public Sub DuracionPociones(ByVal UserIndex As Integer)

'Controla la duracion de las pociones
If UserList(UserIndex).Flags.DuracionEfecto > 0 Then
   UserList(UserIndex).Flags.DuracionEfecto = UserList(UserIndex).Flags.DuracionEfecto - 1
   If UserList(UserIndex).Flags.DuracionEfecto = 0 Then
        UserList(UserIndex).Flags.TomoPocion = False
        UserList(UserIndex).Flags.TipoPocion = 0
        'volvemos los atributos al estado normal
        Dim loopX As Integer
        For loopX = 1 To NUMATRIBUTOS
              UserList(UserIndex).Stats.UserAtributos(loopX) = UserList(UserIndex).Stats.UserAtributosBackUP(loopX)
        Next
   End If
End If

End Sub

Public Sub CargaNpcsDat()
    'Dim npcfile As String
    
    'npcfile = DatPath & "NPCs.dat"
    'Call LeerNPCs.Initialize(npcfile)
    #If MENDUZ_PC = 1 Then
        Dim tmpstr As String
        tmpstr = modZLib.Resource_Get_Raw(DatPath, "NPCs.MZR")
        Call LeerNPCs.Initialize_raw(tmpstr)
        tmpstr = vbNullString
    #Else
        Dim npcfile As String
        
        npcfile = DatPath & "\DatosServer\NPCs.dat"
        Debug.Print npcfile
        Call LeerNPCs.Initialize(npcfile)
    #End If
    

End Sub



Sub PasarSegundo()
On Error GoTo ErrHandler
    Dim i As Long
    Dim suma As Long
    Dim Cant As Long
    Dim lag As Integer
    For i = 1 To LastUser
        If UserList(i).Flags.UserLogged Then
            Cant = Cant + 1
            suma = suma + UserList(i).ping
            'Cerrar usuario
            If UserList(i).Counters.Saliendo Then
                UserList(i).Counters.Salir = UserList(i).Counters.Salir - 1
                If UserList(i).Counters.Salir <= 0 Then
                    Call WriteConsoleMsg(i, "Gracias por jugar Arduz Online", FontTypeNames.FONTTYPE_INFO)
                    WEBCLASS.enviarpjs
                    Call WriteDisconnect(i)
                    Call FlushBuffer(i)
                    Call CloseSocket(i)
                End If
        End If: End If
    Next i
    If suma > 0 And Cant > 0 Then
        lag = suma / Cant
        End If
        frmMain.tcps.Caption = "IN: " & TCPESStats.BytesRecibidosXSEG & "B/s - OUT: " & TCPESStats.BytesEnviadosXSEG & "B/s PING:" & lag & "ms."
    
Exit Sub

ErrHandler:
    Call LogError("Error en PasarSegundo. Err: " & ERR.Description & " - " & ERR.number & " - UserIndex: " & i)
    Resume Next
End Sub
 
Public Function ReiniciarAutoUpdate() As Double

End Function
 




Public Sub FreeNPCs()
'
'
'05/17/06
'Releases all NPC Indexes
'
    Dim loopc As Long
    
    'Free all NPC indexes
    For loopc = 1 To MAXNPCS
        Npclist(loopc).Flags.NPCActive = False
    Next loopc
End Sub

Public Sub FreeCharIndexes()
'
'
'05/17/06
'Releases all char indexes
'
    'Free all char indexes (set them all to 0)
    Call ZeroMemory(CharList(1), MAXCHARS * Len(CharList(1)))
End Sub
