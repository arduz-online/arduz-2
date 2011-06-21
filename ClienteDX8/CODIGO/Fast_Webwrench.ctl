VERSION 5.00
Object = "{33101C00-75C3-11CF-A8A0-444553540000}#1.0#0"; "CSWSK32.ocx"
Begin VB.UserControl Fast_Web 
   ClientHeight    =   465
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   480
   Picture         =   "Fast_Webwrench.ctx":0000
   ScaleHeight     =   465
   ScaleWidth      =   480
   Begin SocketWrenchCtrl.Socket Socket1 
      Left            =   0
      Top             =   0
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
End
Attribute VB_Name = "Fast_Web"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' General constants used with most of the controls
Const INVALID_HANDLE = -1
Const CONTROL_ERRIGNORE = 0
Const CONTROL_ERRDISPLAY = 1

' SocketWrench Control Actions
Const SOCKET_OPEN = 1
Const SOCKET_CONNECT = 2
Const SOCKET_LISTEN = 3
Const SOCKET_ACCEPT = 4
Const SOCKET_CANCEL = 5
Const SOCKET_FLUSH = 6
Const SOCKET_CLOSE = 7
Const SOCKET_DISCONNECT = 7
Const SOCKET_ABORT = 8
Const SOCKET_STARTUP = 9
Const SOCKET_CLEANUP = 10

' SocketWrench Control States
Const SOCKET_NONE = 0
Const SOCKET_IDLE = 1
Const SOCKET_LISTENING = 2
Const SOCKET_CONNECTING = 3
Const SOCKET_ACCEPTING = 4
Const SOCKET_RECEIVING = 5
Const SOCKET_SENDING = 6
Const SOCKET_CLOSING = 7

' Socket Address Families
Const AF_UNSPEC = 0
Const AF_UNIX = 1
Const AF_INET = 2

' Socket Types
Const SOCK_STREAM = 1
Const SOCK_DGRAM = 2
Const SOCK_RAW = 3
Const SOCK_RDM = 4
Const SOCK_SEQPACKET = 5

' Protocol Types
Const IPPROTO_IP = 0
Const IPPROTO_ICMP = 1
Const IPPROTO_GGP = 2
Const IPPROTO_TCP = 6
Const IPPROTO_PUP = 12
Const IPPROTO_UDP = 17
Const IPPROTO_IDP = 22
Const IPPROTO_ND = 77
Const IPPROTO_RAW = 255
Const IPPROTO_MAX = 256

' Well-Known Port Numbers
Const IPPORT_ANY = 0
Const IPPORT_ECHO = 7
Const IPPORT_DISCARD = 9
Const IPPORT_SYSTAT = 11
Const IPPORT_DAYTIME = 13
Const IPPORT_NETSTAT = 15
Const IPPORT_CHARGEN = 19
Const IPPORT_FTP = 21
Const IPPORT_TELNET = 23
Const IPPORT_SMTP = 25
Const IPPORT_TIMESERVER = 37
Const IPPORT_NAMESERVER = 42
Const IPPORT_WHOIS = 43
Const IPPORT_MTP = 57
Const IPPORT_TFTP = 69
Const IPPORT_FINGER = 79
Const IPPORT_HTTP = 80
Const IPPORT_POP3 = 110
Const IPPORT_NNTP = 119
Const IPPORT_SNMP = 161
Const IPPORT_EXEC = 512
Const IPPORT_LOGIN = 513
Const IPPORT_SHELL = 514
Const IPPORT_RESERVED = 1024
Const IPPORT_USERRESERVED = 5000

' Network Addresses
Const INADDR_ANY = "0.0.0.0"
Const INADDR_LOOPBACK = "127.0.0.1"
Const INADDR_NONE = "255.255.255.255"

' Shutdown Values
Const SOCKET_READ = 0
Const SOCKET_WRITE = 1
Const SOCKET_READWRITE = 2

' Byte Order
Const LOCAL_BYTE_ORDER = 0
Const NETWORK_BYTE_ORDER = 1

' SocketWrench Error Response
Const SOCKET_ERRIGNORE = 0
Const SOCKET_ERRDISPLAY = 1

' SocketWrench Error Codes
Const WSABASEERR = 24000
Const WSAEINTR = 24004
Const WSAEBADF = 24009
Const WSAEACCES = 24013
Const WSAEFAULT = 24014
Const WSAEINVAL = 24022
Const WSAEMFILE = 24024
Const WSAEWOULDBLOCK = 24035
Const WSAEINPROGRESS = 24036
Const WSAEALREADY = 24037
Const WSAENOTSOCK = 24038
Const WSAEDESTADDRREQ = 24039
Const WSAEMSGSIZE = 24040
Const WSAEPROTOTYPE = 24041
Const WSAENOPROTOOPT = 24042
Const WSAEPROTONOSUPPORT = 24043
Const WSAESOCKTNOSUPPORT = 24044
Const WSAEOPNOTSUPP = 24045
Const WSAEPFNOSUPPORT = 24046
Const WSAEAFNOSUPPORT = 24047
Const WSAEADDRINUSE = 24048
Const WSAEADDRNOTAVAIL = 24049
Const WSAENETDOWN = 24050
Const WSAENETUNREACH = 24051
Const WSAENETRESET = 24052
Const WSAECONNABORTED = 24053
Const WSAECONNRESET = 24054
Const WSAENOBUFS = 24055
Const WSAEISCONN = 24056
Const WSAENOTCONN = 24057
Const WSAESHUTDOWN = 24058
Const WSAETOOMANYREFS = 24059
Const WSAETIMEDOUT = 24060
Const WSAECONNREFUSED = 24061
Const WSAELOOP = 24062
Const WSAENAMETOOLONG = 24063
Const WSAEHOSTDOWN = 24064
Const WSAEHOSTUNREACH = 24065
Const WSAENOTEMPTY = 24066
Const WSAEPROCLIM = 24067
Const WSAEUSERS = 24068
Const WSAEDQUOT = 24069
Const WSAESTALE = 24070
Const WSAEREMOTE = 24071
Const WSASYSNOTREADY = 24091
Const WSAVERNOTSUPPORTED = 24092
Const WSANOTINITIALISED = 24093
Const WSAHOST_NOT_FOUND = 25001
Const WSATRY_AGAIN = 25002
Const WSANO_RECOVERY = 25003
Const WSANO_DATA = 25004
Const WSANO_ADDRESS = 25004


Private ACTION_POST As Boolean
Private raw As Boolean
Private send_data As String
Private URL As String
Private code As String

Event RecibeDatosWeb(ByRef datos As String, ByRef raw As Boolean)



Private Sub Socket1_Connect()
    Dim Buffer As String
    Dim cod As String
    Dim uri As String
    
    'code = vbNullString
    
    If ACTION_POST Then
        Buffer = "POST "
    Else
        Buffer = "GET "
    End If
    
    If raw Then
        uri = WEBPATH & URL
    Else
        'If Len(code) = 0 Then _
        '
        cod = App.Major & "." & App.Minor & ";" & code 'Else cod = code
        uri = WEBPATH & ClientID & ";" & cod & "/" & URL
    End If
    
    Buffer = Buffer & "/" & uri & " HTTP/1.1" & vbCrLf & _
    "Host: " & host_web & vbCrLf & _
    "User-Agent: Arduz/" & game_version & "/" & macaddr & vbCrLf
    
    If ACTION_POST Then
        Buffer = Buffer & _
            "Content-Length: " & CStr(Len(send_data)) & vbCrLf & _
            "Content-Type: application/x-www-form-urlencoded" & vbCrLf & vbCrLf & _
            send_data & vbCrLf & vbCrLf
    Else
        Buffer = Buffer & vbCrLf
    End If

    Socket1.Write Buffer, Len(Buffer)
    Socket1.Flush
    Debug.Print Buffer
End Sub

Private Sub Socket1_Read(DataLength As Integer, IsUrgent As Integer)
    Dim datos As String
    Dim cabecera() As String
    Call Socket1.Read(datos, DataLength)
    
    Debug.Print datos
    If InStr(1, datos, vbCrLf & vbCrLf, vbTextCompare) <> 0 And InStr(1, datos, "HTTP/1.1 200 OK", vbTextCompare) Then
        cabecera = Split(datos, vbCrLf & vbCrLf, 2)
        RaiseEvent RecibeDatosWeb(cabecera(1), False)
    Else
        RaiseEvent RecibeDatosWeb(datos, True)
    End If
    Socket1.Disconnect
    Socket1.Cleanup
End Sub

Private Sub Socket1_Timeout(Status As Integer, Response As Integer)
    Socket1.Disconnect
    Socket1.Cleanup
End Sub


Private Sub UserControl_Resize()
UserControl.Width = 32 * Screen.TwipsPerPixelX
UserControl.Height = 32 * Screen.TwipsPerPixelY
End Sub

Public Function Send(cmd As String, Optional raw_data As String, Optional codigo As String = vbNullString) As Boolean
    If Puedo Then
        ACTION_POST = Len(raw_data) > 0
        send_data = raw_data
        URL = cmd
        code = codigo
        raw = False
        connect
        Send = True
    End If
End Function

Public Function oURL(URL As String, Optional raw_data As String) As Boolean
    If Puedo Then
        ACTION_POST = Len(raw_data) > 0
        send_data = raw_data
        URL = cmd
        raw = True
        connect
        oURL = True
    End If
End Function

Public Property Get Puedo() As Boolean
    Puedo = Socket1.State = 0
End Property

Private Sub connect()
If Puedo Then
    With Socket1
      .AddressFamily = AF_INET
      .Protocol = IPPROTO_IP
      .SocketType = SOCK_STREAM
      .LocalPort = IPPORT_ANY
      .Binary = True
      .BufferSize = 4096
      .Blocking = False
      .AutoResolve = True
      .HostName = host_web
      .RemoteService = 80
      .RemotePort = 80
      .connect
    End With
End If
End Sub

