VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsWEBA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Option Base 0
'Option Explicit
'Good just incase you misspell a variable
'Option Compare Binary 'AAA is equal to aaa

Private ACTION_POST As Boolean
Private raw As Boolean
Private send_data As String
Private url As String
Private code As String

Event RecibeDatosWeb(ByRef datos As String, ByRef raw As Boolean)

Private WithEvents Winsock1 As MSWinsockLib.Winsock
Attribute Winsock1.VB_VarHelpID = -1

Private NIP As String
Private AIP As String

Public hay_conexion As Boolean
Private conter As Integer

Private es_binario As Boolean

Private iniciado As Boolean

Private Type typHOSTENT
    hName As Long
    hAliases As Long
    hAddrType As Integer
    hLength As Integer
    hAddrList As Long
End Type

Private Type WSADATA
    wversion As Integer
    wHighVersion As Integer
    szDescription(0 To 255) As Byte
    szSystemStatus(0 To 127) As Byte
    iMaxSockets As Integer
    iMaxUdpDg As Integer
    lpszVendorInfo As Long
End Type

Private Declare Sub apiCopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, ByVal hpvSource As Long, ByVal cbCopy As Long)
Private Declare Function apiGetHostByName Lib "wsock32" Alias "gethostbyname" (ByVal HostName As String) As Long
Private Declare Function WSACleanup Lib "wsock32" () As Long
Private Declare Function WSAStartup Lib "wsock32" (ByVal VersionReq As Long, WSADataReturn As WSADATA) As Long

Private A_ENVIAR As String

Private Type Cole
    datos As String
    url As String
    uri As String
End Type

Private Cola() As Cole
Private Ultimo As Integer
Private total As Integer
Private ENCola As Integer



Private BufferEntrada As String

Public conectadoAT As Long

Private no_procesar As Boolean

Private contraseņa As String * 32

Private Sub Class_Terminate()

    If iniciado Then
        If Winsock1.State <> sckClosed Then Winsock1.Close
        Set Winsock1 = Nothing
    End If

End Sub

Private Sub connect()
    If Puedo Then
        Winsock1.Protocol = sckTCPProtocol
        If Len(AIP) Then
            Winsock1.connect AIP, 80 ' host_web, 80
          Else
            Winsock1.connect host_web, 80
        End If
    End If
End Sub

Private Function GetHttpHeaderValue(sHttpHeader As String, sValueName As String) As String

  Dim sHeaders() As String
  Dim vHeaders As Variant

  ''gets the value for corresponding header ie.
  ''File Content: pkzip file
  ''if sValueName is File Content than returns pkzip file

    sHeaders = Split(sHttpHeader, vbCrLf)
    For Each vHeaders In sHeaders
        vHeaders = LCase(vHeaders)
        If InStr(vHeaders, LCase(sValueName)) > 0 Then
            GetHttpHeaderValue = Trim$(Mid$(vHeaders, InStr(vHeaders, Chr(32))))
            Exit Function
        End If
    Next

End Function

Public Function GetIPFromHost(ByVal HostName As String) As String
  Dim udtWSAData As WSADATA
  Dim HostAddress As Long
  Dim HostInfo As typHOSTENT
  Dim IPLong As Long
  Dim IPBytes() As Byte
  Dim i As Integer

    On Error Resume Next

        If WSAStartup(257, udtWSAData) Then
            MsgBox "Error initializing winsock on WSAStartup!"
            GetIPFromHost = HostName
            Exit Function
        End If

        'Make sure a HTTP:// or FTP:// something wasn't added... some people like to do that
        If UCase$(Left$(HostName, 7)) = "HTTP://" Then
            HostName = Right$(HostName, Len(HostName) - 7)
          ElseIf UCase$(Left$(HostName, 6)) = "FTP://" Then
            HostName = Right$(HostName, Len(HostName) - 6)
        End If

        'If we were already passed an IP, just abort since we have what we want
        If IsIP(HostName) Then
            GetIPFromHost = HostName
            Exit Function
        End If

        'Get the host address
        HostAddress = apiGetHostByName(HostName)

        'Failure!
        If HostAddress = 0 Then Exit Function

        'Move the memory around to get it in a format we can read
        apiCopyMemory HostInfo, HostAddress, LenB(HostInfo)
        apiCopyMemory IPLong, HostInfo.hAddrList, 4

        'Get the number of parts to the IP (will always be 4 as far as I know)
        ReDim IPBytes(1 To HostInfo.hLength)

        'Convert the address, stored in the format of a long, to 4 bytes (just simple long -> byte array conversion)
        apiCopyMemory IPBytes(1), IPLong, HostInfo.hLength

        'Add in the periods
        For i = 1 To HostInfo.hLength
            GetIPFromHost = GetIPFromHost & IPBytes(i) & "."
        Next

        'Remove the final period
        GetIPFromHost = Left$(GetIPFromHost, Len(GetIPFromHost) - 1)

        'Clean up the socket
        WSACleanup

    On Error GoTo 0

End Function

Public Function Initialize(WS As MSWinsockLib.Winsock) As Boolean
    If Not (WS Is Nothing) Then Set Winsock1 = WS
    hay_conexion = Not (Winsock1 Is Nothing)
    iniciado = hay_conexion
    AIP = GetIPFromHost(host_web)
    Initialize = hay_conexion
End Function

Private Function IsIP(ByVal IPAddress As String) As Boolean
  Dim s() As String
  Dim i As Long

  'If there are no periods, I have no idea what we have...

    If InStr(1, IPAddress, ".") = 0 Then Exit Function

    'Split up the string by the periods
    s = Split(IPAddress, ".")

    'Confirm we have ubound = 3, since xxx.xxx.xxx.xxx has 4 elements and we start at index 0
    If UBound(s) <> 3 Then Exit Function

    'Check that the values are numeric and in a valid range
    For i = 0 To 3
        If val(s(i)) < 0 Then Exit Function
        If val(s(i)) > 255 Then Exit Function
    Next i

    'Looks like we were passed a valid IP!
    IsIP = True

End Function

Private Sub Logan(desc As String)

    On Error GoTo ErrHandler

  Dim nFile As Integer
    nFile = FreeFile 'obtenemos un canal
    Open App.Path & "\logs\WEBA.txt" For Append Shared As #nFile
    Print #nFile, Date & " " & Time & " " & desc
    Debug.Print Date & " " & Time & " " & desc
    Close #nFile
ErrHandler:

End Sub

Public Function oURL(url As String, Optional raw_data As String) As Boolean

    ACTION_POST = Len(raw_data) > 0
    send_data = raw_data
    url = url
    raw = True
    oURL = True
    PUSH
    TryRequest

End Function

Private Sub procesar_datos()

    Dim cabecera() As String

    If InStr(1, BufferEntrada, vbCrLf & vbCrLf, vbTextCompare) <> 0 And (InStr(1, BufferEntrada, "HTTP/1.0 200 OK", vbTextCompare) Or InStr(1, BufferEntrada, "HTTP/1.1 200 OK", vbTextCompare)) Then
        cabecera = Split(BufferEntrada, vbCrLf & vbCrLf, 2)

        RaiseEvent RecibeDatosWeb(cabecera(1), False)
      Else
        RaiseEvent RecibeDatosWeb(BufferEntrada, True)
    End If
    BufferEntrada = ""

End Sub

Public Property Get Puedo() As Boolean

    If iniciado Then
        Puedo = (Winsock1.State = sckClosed)
        If Puedo = True Then Puedo = hay_conexion
    End If

End Property

Private Sub PUSH()

  Dim buffer As String
  Dim cod As String
  Dim uri As String

  'code = vbNullString

    If ACTION_POST Then
        buffer = "POST "
      Else
        buffer = "GET "
    End If

    If raw Then
        uri = WEBPATH & url
    Else
        'If Len(code) = 0 Then _

        cod = App.Major & "." & App.Minor & ";" & code 'Else cod = code
        uri = WEBPATH & ClientIDs & ";" & cod & "/" & url
    End If

    buffer = buffer & "/" & uri & " HTTP/1.0" & vbCrLf & _
             "Host: " & host_web & vbCrLf & _
             "User-Agent: ADZSV/" & game_version & "/" & macaddr & "/" & contraseņa & vbCrLf & _
             "Connection: Close" & vbCrLf
    
    If ACTION_POST Then
        buffer = buffer & _
             "Content-Length: " & CStr(Len(send_data)) & vbCrLf & _
             "Content-Type: application/x-www-form-urlencoded" & vbCrLf & vbCrLf & _
             send_data & vbCrLf & vbCrLf
    Else
        buffer = buffer & vbCrLf
    End If
    
    ENCola = ENCola + 1
    ReDim Preserve Cola(0 To ENCola + 1) As Cole
    Cola(ENCola).datos = buffer
    Cola(ENCola).url = url
    Cola(ENCola).uri = uri

End Sub

Private Function POP() As String

  Dim i As Integer
    If ENCola > 0 Then
        
        
        POP = Cola(1).datos
        Cola(1).datos = ""
        ENCola = ENCola - 1
        For i = 0 To ENCola
            Cola(i) = Cola(i + 1)
        Next i
        
        If ENCola < 0 Then ENCola = 0
        ReDim Preserve Cola(maxl(ENCola + 1, 1)) As Cole
    End If
End Function

Private Function PEEK() As String
    If ENCola > 0 Then
        PEEK = Cola(1).datos
        If Len(PEEK) = 0 Then POP
    End If
End Function

Public Function Send(cmd As String, Optional raw_data As String, Optional codigo As String = vbNullString, Optional ByVal es_bin As Boolean = False) As Boolean

    ACTION_POST = Len(raw_data) > 0
    send_data = raw_data
    url = cmd
    code = codigo
    raw = False
    Send = True
    es_binario = es_bin
    PUSH
    TryRequest

End Function

Sub TryRequest()
    If ENCola > 0 And Puedo = True And Len(PEEK) > 0 Then
        connect
    Else
        If conectadoAT <> 0 Then
            If conectadoAT + 5000 < (GetTickCount() And &H7FFFFFFF) Then
            ' timeout
                If Winsock1.State <> sckClosed Then Winsock1.Close
            End If
        End If
    End If
End Sub

Private Sub Winsock1_Close()
    Winsock1.Close
    procesar_datos
    conectadoAT = 0
    TryRequest
End Sub

Private Sub Winsock1_Connect()
    Winsock1.SendData POP
    conectadoAT = GetTickCount() And &H7FFFFFFF
End Sub

Private Sub Winsock1_DataArrival(ByVal BytesTotal As Long)

  Dim datos As String

    Winsock1.GetData datos, vbString

    BufferEntrada = BufferEntrada & datos

    hay_conexion = True

End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)

    If Winsock1.State <> sckClosed Then _
       Winsock1.Close
    DoEvents
    TryRequest

End Sub

Public Sub clear_buffers()
ENCola = 0
ReDim Cola(2)
    If Winsock1.State <> sckClosed Then _
       Winsock1.Close
conectadoAT = 0
End Sub

Public Property Let Arduz_KEY(ByVal val As String)
    contraseņa = xMD5String("MZBBFDTT" & xMD5String(val) & "TTDSBBZM")
End Property
