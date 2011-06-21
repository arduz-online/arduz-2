Attribute VB_Name = "wskapiAO"
'
'wskapiAO.bas
'
'

'
'
'
'
'
'
'
'
'
'
'
'
'

Option Explicit

''
'Modulo para manejar Winsock
'

#If UsarQueSocket = 1 Then


'Si la variable esta en TRUE , al iniciar el WsApi se crea
'una ventana LABEL para recibir los mensajes. Al detenerlo,
'se destruye.
'Si es FALSE, los mensajes se envian al form frmMain (o el
'que sea).
#Const WSAPI_CREAR_LABEL = True

Private Const SD_BOTH As Long = &H2

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal Hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal Hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal Hwnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Private Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hwndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Private Declare Function DestroyWindow Lib "user32" (ByVal Hwnd As Long) As Long

Private Const WS_CHILD = &H40000000
Public Const GWL_WNDPROC = (-4)

Private Const SIZE_RCVBUF As Long = 8192
Private Const SIZE_SNDBUF As Long = 8192

''
'Esto es para agilizar la busqueda del slot a partir de un socket dado,
'sino, la funcion BuscaSlotSock se nos come todo el uso del CPU.
'
'Sock sock
'slot slot
'
Public Type tSockCache
    Sock As Long
    Slot As Long
End Type

Public WSAPISock2Usr As New Collection

'====================================================================================
'====================================================================================




'====================================================================================
'====================================================================================

Public SockListen As Long

#End If
Public OldWProc As Long
Public ActualWProc As Long
Public hWndMsg As Long
Private Declare Function CRCPAXOR Lib "MZEngine.dll" Alias "Calcular_La_sombra" _
        (ByRef FirstByte As Byte, ByVal leng As Long, ByVal c As Byte, ByVal ce As Byte) As Byte
'====================================================================================
'====================================================================================


Public Sub IniciaWsApi(ByVal hwndParent As Long)
#If UsarQueSocket = 1 Then

Call LogApiSock("IniciaWsApi")
Debug.Print "IniciaWsApi"

#If WSAPI_CREAR_LABEL Then
hWndMsg = CreateWindowEx(0, "STATIC", "AOMSG", WS_CHILD, 0, 0, 0, 0, hwndParent, 0, app.hInstance, ByVal 0&)
#Else
hWndMsg = hwndParent
#End If 'WSAPI_CREAR_LABEL

OldWProc = SetWindowLong(hWndMsg, GWL_WNDPROC, AddressOf WndProc)
ActualWProc = GetWindowLong(hWndMsg, GWL_WNDPROC)

Dim desc As String
Call StartWinsock(desc)

#End If
End Sub

Public Sub LimpiaWsApi()
#If UsarQueSocket = 1 Then

Call LogApiSock("LimpiaWsApi")

If WSAStartedUp Then
    Call EndWinsock
End If

If OldWProc <> 0 Then
    SetWindowLong hWndMsg, GWL_WNDPROC, OldWProc
    OldWProc = 0
End If

#If WSAPI_CREAR_LABEL Then
If hWndMsg <> 0 Then
    DestroyWindow hWndMsg
End If
#End If

#End If
End Sub

Public Function BuscaSlotSock(ByVal s As Long) As Long
#If UsarQueSocket = 1 Then

On Error GoTo hayerror

BuscaSlotSock = WSAPISock2Usr.Item(CStr(s))
Exit Function

hayerror:   'The socket was already removed

BuscaSlotSock = -1
Err.Clear

#End If
End Function

Public Sub AgregaSlotSock(ByVal Sock As Long, ByVal Slot As Long)
Debug.Print "AgregaSockSlot"
#If (UsarQueSocket = 1) Then

'If frmMain.SUPERLOG.Value = 1 Then LogCustom ("AgregaSlotSock:: sock=" & Sock & " slot=" & Slot)

If WSAPISock2Usr.count > maxusers Then
    'If frmMain.SUPERLOG.Value = 1 Then LogCustom ()
    Debug.Print "Imposible agregarSlotSock (wsapi2usr.count>maxusers)"
    Call CloseSocket(Slot)
    Exit Sub
End If

WSAPISock2Usr.Add CStr(Slot), CStr(Sock)

'Dim Pri As Long, Ult As Long, Med As Long
'Dim LoopC As Long
'
'If WSAPISockChacheCant > 0 Then
'Pri = 1
'Ult = WSAPISockChacheCant
'Med = Int((Pri + Ult) / 2)
'
'Do While (Pri <= Ult) And (Ult > 1)
'If Sock < WSAPISockChache(Med).Sock Then
'Ult = Med - 1
'Else
'Pri = Med + 1
'End If
'Med = Int((Pri + Ult) / 2)
'Loop
'
'Pri = IIf(Sock < WSAPISockChache(Med).Sock, Med, Med + 1)
'Ult = WSAPISockChacheCant
'For LoopC = Ult To Pri Step -1
'WSAPISockChache(LoopC + 1) = WSAPISockChache(LoopC)
'Next LoopC
'Med = Pri
'Else
'Med = 1
'End If
'WSAPISockChache(Med).Slot = Slot
'WSAPISockChache(Med).Sock = Sock
'WSAPISockChacheCant = WSAPISockChacheCant + 1

#End If
End Sub

Public Sub BorraSlotSock(ByVal Sock As Long)
#If (UsarQueSocket = 1) Then
Dim Cant As Long

Cant = WSAPISock2Usr.count
On Error Resume Next
WSAPISock2Usr.Remove CStr(Sock)

Debug.Print "BorraSockSlot " & Cant & " -> " & WSAPISock2Usr.count

#End If
End Sub

Public Function WndProc(ByVal Hwnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
#If UsarQueSocket = 1 Then

On Error Resume Next

Dim Ret As Long
Dim tmp() As Byte

Dim s As Long, E As Long
Dim N As Integer
    
Dim Dale As Boolean
Dim UltError As Long

Dim i As Byte

WndProc = 0


If CamaraLenta = 1 Then
    'Sleep 1
End If


Select Case msg
Case 1025

    s = wParam
    E = WSAGetSelectEvent(lParam)
    'Debug.Print "Msg: " & msg & " W: " & wParam & " L: " & lParam
    'Call LogApiSock("Msg: " & msg & " W: " & wParam & " L: " & lParam)
    
    Select Case E
    Case FD_ACCEPT
            'If frmMain.SUPERLOG.Value = 1 Then LogCustom ("FD_ACCEPT")
        If s = SockListen Then
            'If frmMain.SUPERLOG.Value = 1 Then LogCustom ("sockLIsten = " & s & ". Llamo a Eventosocketaccept")
            Call EventoSockAccept(s)
        End If
        
'Case FD_WRITE
'N = BuscaSlotSock(s)
'If N < 0 And s <> SockListen Then
''Call apiclosesocket(s)
'call WSApiCloseSocket(s)
'Exit Function
'End If
'

'Call IntentarEnviarDatosEncolados(N)
'
''Dale = UserList(N).ColaSalida.Count > 0
''Do While Dale
''Ret = WsApiEnviar(N, UserList(N).ColaSalida.Item(1), False)
''If Ret <> 0 Then
''If Ret = WSAEWOULDBLOCK Then
''Dale = False
''Else
'''y aca que hacemo'?? help! i need somebody, help!
''Dale = False
''Debug.Print "ERROR AL ENVIAR EL DATO DESDE LA COLA " & Ret & ": " & GetWSAErrorString(Ret)
''End If
''Else
'''Debug.Print "Dato de la cola enviado"
''UserList(N).ColaSalida.Remove 1
''Dale = (UserList(N).ColaSalida.Count > 0)
''End If
''Loop

    Case FD_READ
        
        N = BuscaSlotSock(s)
        If N < 0 And s <> SockListen Then
            'Call apiclosesocket(s)
            Call WSApiCloseSocket(s)
            Exit Function
        End If
        
        'Call WSAAsyncSelect(s, hWndMsg, ByVal 1025, ByVal (0))
        
        '4k de buffer
        If UserList(N).flags.UserLogged1 Then
            ReDim Preserve tmp(SIZE_RCVBUF - 1) As Byte
            Ret = recv(s, tmp(0), SIZE_RCVBUF, 0)

            'Comparo por = 0 ya que esto es cuando se cierra
            '"gracefully". (mas abajo)
            
            If Ret < 0 Then
                UltError = Err.LastDllError
                If UltError = WSAEMSGSIZE Then
                    Debug.Print "WSAEMSGSIZE"
                    Ret = SIZE_RCVBUF
                Else
                    Debug.Print "Error en Recv: " & GetWSAErrorString(UltError)
                    Call LogApiSock("Error en Recv: N=" & N & " S=" & s & " Str=" & GetWSAErrorString(UltError))
                    
                    'no hay q llamar a CloseSocket() directamente,
                    'ya q pueden abusar de algun error para
                    'desconectarse sin los 10segs. CREEME.
                    'Call CloseSocket(N)
                
                    Call CloseSocketSL(N)
                    Call Cerrar_Usuario(N)
                    Exit Function
                End If
            ElseIf Ret = 0 Then
                Call CloseSocketSL(N)
                Call Cerrar_Usuario(N)
            End If
            
            
            
            'Call WSAAsyncSelect(s, hWndMsg, ByVal 1025, ByVal (FD_READ Or FD_WRITE Or FD_CLOSE Or FD_ACCEPT))
            
            ReDim Preserve tmp(Ret - 1) As Byte
            
            'Call LogApiSock("WndProc:FD_READ:N=" & N & ":TMP=" & Tmp)
            
            Call EventoSockRead(N, tmp)
        Else
            ReDim Preserve tmp(15) As Byte
            Ret = recv(s, tmp(0), 16, 0)

            If Ret > 0 Then
                For i = 0 To 15
                    If tmp(i) <> connection_checkb(i) Then
                        Call CloseSocketSL(N)
                        Call Cerrar_Usuario(N)
                        Exit Function
                    End If
                Next i
                UserList(N).flags.UserLogged1 = 1
                WriteCCO N
                gen_c_c
                Debug.Print N; "AUTENTICADO OK"
            Else
                Call CloseSocketSL(N)
                Call Cerrar_Usuario(N)
            End If
        End If
    Case FD_CLOSE
        'Debug.Print WSAGETSELECTERROR(lParam)
        N = BuscaSlotSock(s)
        If s <> SockListen Then Call apiclosesocket(s)
        
        Call LogApiSock("WndProc:FD_CLOSE:N=" & N & ":Err=" & WSAGetAsyncError(lParam))
        
        If N > 0 Then
            Call BorraSlotSock(s)
            UserList(N).ConnID = -1
            UserList(N).ConnIDValida = False
            Call EventoSockClose(N)
        End If
        
    End Select
Case Else
    WndProc = CallWindowProc(OldWProc, Hwnd, msg, wParam, lParam)
End Select

#End If
End Function

'Retorna 0 cuando se envió o se metio en la cola,
'retorna <> 0 cuando no se pudo enviar o no se pudo meter en la cola
Public Function WsApiEnviar(ByVal Slot As Integer, ByRef STR As String) As Long
#If UsarQueSocket = 1 Then

'If frmMain.SUPERLOG.Value = 1 Then LogCustom ("WsApiEnviar:: slot=" & Slot & " str=" & str & " len(str)=" & Len(str) & " encolar=" & Encolar)

Dim Ret As String
Dim UltError As Long
Dim Retorno As Long
Dim data() As Byte

ReDim Preserve data(Len(STR) - 1) As Byte

data = StrConv(STR, vbFromUnicode)

#If SeguridadAlkon Then
    Call Security.DataSent(Slot, data)
#End If

Retorno = 0

'Debug.Print ">>>> " & str


If UserList(Slot).ConnID <> -1 And UserList(Slot).ConnIDValida Then
    Ret = Send(ByVal UserList(Slot).ConnID, data(0), ByVal UBound(data()) + 1, ByVal 0)
    If Ret < 0 Then
        UltError = Err.LastDllError
        If UltError = WSAEWOULDBLOCK Then
            
            'WSAEWOULDBLOCK, put the data again in the outgoingData Buffer
            If UserList(Slot).outgoingData.Capacity - UserList(Slot).outgoingData.length < 2000 Then
                Call CloseSocketSL(Slot)
                Call Cerrar_Usuario(Slot)
            Else
                Call UserList(Slot).outgoingData.WriteASCIIStringFixed(STR)
            End If
        End If
        Retorno = UltError
    End If
ElseIf UserList(Slot).ConnID <> -1 And Not UserList(Slot).ConnIDValida Then
    If Not UserList(Slot).Counters.Saliendo Then
        Retorno = -1
    End If
End If

WsApiEnviar = Retorno

#End If
End Function


Public Sub LogCustom(ByVal STR As String)
#If (UsarQueSocket = 1) Then

On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open app.path & "\logs\custom.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & "(" & Timer & ") " & STR
Close #nFile

Exit Sub

ErrHandler:

#End If
End Sub


Public Sub LogApiSock(ByVal STR As String)
#If (UsarQueSocket = 1) Then

On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open app.path & "\logs\wsapi.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & STR
Close #nFile

Exit Sub

ErrHandler:

#End If
End Sub

Public Sub EventoSockAccept(ByVal SockID As Long)
#If UsarQueSocket = 1 Then
'==========================================================
'USO DE LA API DE WINSOCK
'========================
    
    Dim NewIndex As Integer
    Dim Ret As Long
    Dim Tam As Long, sa As sockaddr
    Dim NuevoSock As Long
    Dim i As Long
    Dim tstr As String
    
    Tam = sockaddr_size
    

'Modificado por Maraxus
    Ret = WSAAccept(SockID, sa, Tam, AddressOf CondicionSocket, 0)
    'Ret = accept(SockID, sa, Tam)

    If Ret = INVALID_SOCKET Then
        i = Err.LastDllError
        Call LogCriticEvent("Error en Accept() API " & i & ": " & GetWSAErrorString(i))
        Exit Sub
    End If

    NuevoSock = Ret
    If Not nalg_alg_act Then
        If setsockopt(NuevoSock, SOL_SOCKET, SO_RCVBUFFER, SIZE_RCVBUF, 4) <> 0 Then
            i = Err.LastDllError
            Call LogCriticEvent("Error al setear el tamaño del buffer de entrada " & i & ": " & GetWSAErrorString(i))
        End If
        'Seteamos el tamaño del buffer de salida
        If setsockopt(NuevoSock, SOL_SOCKET, SO_SNDBUFFER, SIZE_SNDBUF, 4) <> 0 Then
            i = Err.LastDllError
            Call LogCriticEvent("Error al setear el tamaño del buffer de salida " & i & ": " & GetWSAErrorString(i))
        End If
    Else
    '    If setsockopt(NuevoSock, IPPROTO_TCP, SO_SNDBUFFER, SIZE_SNDBUF, 4) <> 0 Then
    '        i = Err.LastDllError
    '        Call LogCriticEvent("Error al setear el tamaño del buffer de salida " & i & ": " & GetWSAErrorString(i))
    '    End If
        If setsockopt(NuevoSock, IPPROTO_TCP, SO_RCVBUFFER, SIZE_RCVBUF, 4) <> 0 Then
            i = Err.LastDllError
            Call LogCriticEvent("Error al setear el tamaño del buffer de entrada " & i & ": " & GetWSAErrorString(i))
        End If
        If setsockopt(NuevoSock, IPPROTO_TCP, &H1&, True, 4) <> 0 Then
            i = Err.LastDllError
            Call LogCriticEvent("Error al Naglear " & i & ": " & GetWSAErrorString(i))
        End If
    End If
    If SecurityIp.IPSecuritySuperaLimiteConexiones(sa.sin_addr) Then
        'tstr = "Limite de conexiones para su IP alcanzado."
        'Call Send(ByVal NuevoSock, ByVal tstr, ByVal Len(tstr), ByVal 0)
        Call WSApiCloseSocket(NuevoSock)
        Exit Sub
    End If
    
    NewIndex = NextOpenUser 'Nuevo indice
    
    If NewIndex <= maxusers Then
        
        'Make sure both outgoing and incoming data buffers are clean
        Call UserList(NewIndex).incomingData.Clear 'ReadASCIIStringFixed(UserList(NewIndex).incomingData.Length)
        Call UserList(NewIndex).outgoingData.Clear 'ReadASCIIStringFixed(UserList(NewIndex).outgoingData.Length)
        
        UserList(NewIndex).ip = GetAscIP(sa.sin_addr)
        UserList(NewIndex).IPLong = sa.sin_addr
        UserList(NewIndex).flags.UserLogged1 = 0
        'Busca si esta banneada la ip
        For i = 1 To BanIps.count
            If BanIps.Item(i) = UserList(NewIndex).ip Then
                'Call apiclosesocket(NuevoSock)
                'Call WriteErrorMsg(NewIndex, "Su IP se encuentra bloqueada en este servidor hasta que este se reinicie.")
                Call FlushBuffer(NewIndex)
                Call aDos.RestarConexion(UserList(NewIndex).ip)
                Call WSApiCloseSocket(NuevoSock)
                Exit Sub
            End If
        Next i
'        If aDos.MaxConexiones(UserList(NewIndex).ip) = True Then
'            UserList(NewIndex).ConnID = -1
'            Call aDos.RestarConexion(UserList(NewIndex).ip)
'            Call FlushBuffer(NewIndex)
'            Call WSApiCloseSocket(NuevoSock)
'            LogCriticEvent UserList(NewIndex).ip & " NO ACEPTADA"
'        Else
            If NewIndex > LastUser Then LastUser = NewIndex
            UserList(NewIndex).ConnID = NuevoSock
            UserList(NewIndex).ConnIDValida = True
            Call WriteCCM(NewIndex)
            Call FlushBuffer(NewIndex)
            Call AgregaSlotSock(NuevoSock, NewIndex)
'        End If
    Else
        Dim STR As String
        Dim data() As Byte
        
        STR = Protocol.PrepareMessageErrorMsg("El servidor se encuentra lleno en este momento.")
        
        ReDim Preserve data(Len(STR) - 1) As Byte
        
        data = StrConv(STR, vbFromUnicode)
        
        Call Send(ByVal NuevoSock, data(0), ByVal UBound(data()) + 1, ByVal 0)
        Call WSApiCloseSocket(NuevoSock)
    End If
#End If
End Sub

Public Sub EventoSockRead(ByVal Slot As Integer, ByRef datos() As Byte)
If IsNull(datos) Then Exit Sub

#If UsarQueSocket = 1 Then

With UserList(Slot)
    If .ConnID <> -1 Then
        TCPESStats.BytesRecibidos = TCPESStats.BytesRecibidos + UBound(datos)
        #If SeguridadArduz Then
            Call Security.DataReceived(Slot, datos)
        #End If
        Call .incomingData.WriteBlock(datos)
        Call HandleIncomingData(Slot)

    Else
        Exit Sub
    End If
    
End With

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

Public Sub EventoSockClose(ByVal Slot As Integer)
#If UsarQueSocket = 1 Then
    If UserList(Slot).flags.UserLogged Then
        Call CloseSocketSL(Slot)
        Call Cerrar_Usuario(Slot)
    Else
        Call CloseSocket(Slot)
    End If
#End If
End Sub


Public Sub WSApiReiniciarSockets()
#If UsarQueSocket = 1 Then
Dim i As Long
    'Cierra el socket de escucha
    If SockListen >= 0 Then Call apiclosesocket(SockListen)
    
    'Cierra todas las conexiones
    For i = 1 To maxusers
        If UserList(i).ConnID <> -1 And UserList(i).ConnIDValida Then
            Call CloseSocket(i)
        End If
        
        'Call ResetUserSlot(i)
    Next i
    
    For i = 1 To maxusers
        Set UserList(i).incomingData = Nothing
        Set UserList(i).outgoingData = Nothing
    Next i
    
    'No 'ta el PRESERVE :p
    ReDim UserList(1 To maxusers)
    For i = 1 To maxusers
        UserList(i).ConnID = -1
        UserList(i).ConnIDValida = False
        
        Set UserList(i).incomingData = New clsByteQueue
        Set UserList(i).outgoingData = New clsByteQueue
    Next i
    
    LastUser = 1
    NumUsers = 0
    
    Call LimpiaWsApi
    Call Sleep(100)
    Call IniciaWsApi(frmMain.Hwnd)
    SockListen = ListenForConnect(Puerto, hWndMsg, "")


#End If
End Sub

Public Sub WSApiCloseSocket(ByVal Socket As Long)
#If UsarQueSocket = 1 Then
Call WSAAsyncSelect(Socket, hWndMsg, ByVal 1025, ByVal (FD_CLOSE))
Call ShutDown(Socket, SD_BOTH)
#End If
End Sub

Public Function CondicionSocket(ByRef lpCallerId As WSABUF, ByRef lpCallerData As WSABUF, ByRef lpSQOS As FLOWSPEC, ByVal Reserved As Long, ByRef lpCalleeId As WSABUF, ByRef lpCalleeData As WSABUF, ByRef Group As Long, ByVal dwCallbackData As Long) As Long
#If UsarQueSocket = 1 Then
    Dim sa As sockaddr
    
    'Check if we were requested to force reject

    If dwCallbackData = 1 Then
        CondicionSocket = CF_REJECT
        Exit Function
    End If
    
     'Get the address

    CopyMemory sa, ByVal lpCallerId.lpBuffer, lpCallerId.dwBufferLen

    
    If Not SecurityIp.IpSecurityAceptarNuevaConexion(sa.sin_addr) Then
        CondicionSocket = CF_REJECT
        Exit Function
    End If

    CondicionSocket = CF_ACCEPT 'En realdiad es al pedo, porque CondicionSocket se inicializa a 0, pero así es más claro....
#End If
End Function
