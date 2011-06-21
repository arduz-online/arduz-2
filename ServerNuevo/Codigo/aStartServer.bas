Attribute VB_Name = "modInitializeServer"
Option Explicit

Public serverrunning As Boolean

Public antilag As Boolean

Public lag As Long

Public Sub Iniciar_Agite()
    game_cfg.modo_de_juego = modo_agite
    
    cargar_datos
    
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
    
    Load frmMain
    Call frmMain.InitMain(0)
    tInicioServer = GetTickCount() And &H7FFFFFFF
    
    modBalance.reload_balancea
    
End Sub

Public Sub Iniciar_Camp(Optional ByVal Port As Long = 7666)
    If serverrunning = True Then Exit Sub
    game_cfg.modo_de_juego = modo_campaña
    
    cargar_datos
    cargar_campañas
    
    svname = "Nombre del servidor"
    botsact = False
    mankismo = 2
    menduz = "mzbbfdtt"
    rondaa = 60 * 5
    valeestu = False
    atacaequipo = False
    valeinvi = False
    valeresu = False
    rondaact = False
    enviarank = True
    deathm = False
    fatuos = False
    
    Init_listen_server Port
    
    cargar_parte_campaña
    
    If servermap = 0 Then
        MsgBox "PAPA, EL MAPA"
        servermap = 1
    End If
    
    bloquear_form
    
    Call frmMain.InitMain(1)
    tInicioServer = GetTickCount() And &H7FFFFFFF
End Sub

Public Sub Init_listen_server(ByVal Port As Long)
gen_c_c

If serverrunning = True Then Exit Sub
If Port < 82 Or Port > 9999 Then Port = 7666

If Puerto <> Port Then Puerto = Port


Dim loopc As Integer

'Resetea las conexiones de los usuarios
ReDim UserList(1 To maxusers) As User
For loopc = 1 To maxusers
    UserList(loopc).ConnID = -1
    UserList(loopc).ConnIDValida = False
    Set UserList(loopc).incomingData = New clsByteQueue
    Set UserList(loopc).outgoingData = New clsByteQueue
Next loopc

'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿

With frmMain
    .AutoSave.Enabled = True
    .GameTimer.Enabled = True
    .FX.Enabled = True
    .Auditoria.Enabled = True
    .TIMER_AI.Enabled = True
    .npcataca.Enabled = True
End With

Call SecurityIp.InitIpTables(maxusers + 20)

Call IniciaWsApi(frmMain.Hwnd)
SockListen = ListenForConnect(Port, wskapiAO.hWndMsg, "")

menduz = "mzbbfdtt"

serverrunning = True
Call WEBCLASS.CrearServerWeb

Init_UDP



End Sub

Private Sub Init_UDP()
On Error GoTo direccionenuso:
    With frmMain.wssvr
        .Close
        .Protocol = sckUDPProtocol
        .RemoteHost = "255.255.255.255"
        .LocalPort = 4111
        .RemotePort = 4112
        .bind 4111
    End With
Exit Sub
direccionenuso:
Debug.Print "No se pudo iniciar UDP server. Err: "; err.Number; err.Description
End Sub

Private Sub cargar_datos()
frmCargando.Show
    DoEvents
    frmCargando.Label1(2).Caption = "Cargando NPCs"
    Call CargaNpcsDat
    frmCargando.Label1(2).Caption = "Cargando Objetos"
    Call LoadOBJData
    frmCargando.Label1(2).Caption = "Cargando Hechizos"
    Call CargarHechizos
    frmCargando.Label1(2).Caption = "Cargando Mapas"
    Call LoadMapData
Unload frmCargando
End Sub
