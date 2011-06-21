Attribute VB_Name = "modSock"
#If Debuging = 0 Then
Option Explicit

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

Public SoxID As Long
Public socka As Sock

Public Function WindowProc(ByVal hwnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Let WindowProc = socka.WndProc(hwnd, uMsg, wParam, lParam)
End Function

Private Function IsIP(ByVal IPAddress As String) As Boolean
'************************************************************
'Checks if a string is in a valid IP address format
'More info: http://www.vbgore.com/GameClient.TCP.IsIP
'************************************************************
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
        If Val(s(i)) < 0 Then Exit Function
        If Val(s(i)) > 255 Then Exit Function
    Next i
    
    'Looks like we were passed a valid IP!
    IsIP = True
    
End Function

Public Function GetIPFromHost(ByVal HostName As String) As String
'************************************************************
'Returns the IP address given a host name (such as "www.vbgore.com" to 123.45.6.7)
'More info: http://www.vbgore.com/GameClient.TCP.GetIPFromHost
'************************************************************
Dim udtWSAData As WSADATA
Dim HostAddress As Long
Dim HostInfo As typHOSTENT
Dim IPLong As Long
Dim IPBytes() As Byte
Dim i As Integer

    On Error Resume Next
    


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
    
    If WSAStartup(257, udtWSAData) Then
        MsgBox "Error initializing winsock on WSAStartup!"
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

Public Sub conectar_sock(ByRef host As String, ByVal port As Long)
    SoxID = 0
    frmMain.Sock1.ClearPicture
    If frmMain.Sock1.ShutDown <> soxERROR Then
        SoxID = frmMain.Sock1.Connect(GetIPFromHost(CStr(host)), CInt(port))
        If SoxID = -1 Then
            MsgBox "No se pudo conectar con el servidor!" & vbCrLf & "El servidor está inhabilitado, o no estás conectado a internet.", vbOKOnly
        Else
            frmMain.Sock1.SetOption SoxID, soxSO_TCP_NODELAY, True
        End If
    End If
End Sub
#End If
