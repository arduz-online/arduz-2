VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CURL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'© 2005 L.C. Enterprises
'http://LCen.com

'HTTP Request Class
'Author: Luis Cantero
'Updated: 10/AUG/2005

'INITIALIZE:    Set objURL = New CURL, .host, .Proxy, .Path, .Port
'PROPERTIES:    .altost, .Proxy, .Path, .Port
'METHODS:       .ParseURL(strURL, strProxy)

Option Explicit

Private strHost As String
Private strProxy As String
Private strPath As String
Private intPort As Integer

Private Sub Class_Initialize()

  'Default values

    intPort = 80

End Sub

Public Property Get Host() As String

    Host = strHost

End Property

Public Property Let Host(strInput As String)

    strHost = strInput

End Property

Private Sub ParseProxy(strProxy As String)

    strProxy = Trim$(strProxy)
    If Len(strProxy) < 3 Or strHost = "" Then Exit Sub

    'Parse proxy, host and port
    strProxy = "http://" & strHost
    strHost = Mid$(strProxy, 1, InStr(1, strProxy, ":") - 1)
    intPort = CInt(Mid$(strProxy, InStr(1, strProxy, ":") + 1))

End Sub

Public Sub ParseURL(ByVal strURL As String, ByVal strProxy As String)

  Dim intBeg As Integer

    strURL = Trim$(strURL)
    If Len(strURL) < 6 Then Exit Sub

    'Remove leading http or https
    If StrComp(Left$(strURL, 4), "http", vbTextCompare) = 0 Then
        intBeg = InStr(5, strURL, "/")
        strURL = Mid$(strURL, intBeg + 2)
    End If

    'Separate URL into Host and Path
    intBeg = InStr(1, strURL, "/")
    If intBeg = 0 Then intBeg = Len(strURL) + 1
    strPath = Mid$(strURL, intBeg)
    If strPath = "" Then strPath = "/"
    strHost = Mid$(strURL, 1, intBeg - 1)

    Call ParseProxy(strProxy)

End Sub

Public Property Get path() As String

    path = strPath

End Property

Public Property Let path(strInput As String)

    strPath = strInput

End Property

Public Property Get Port() As Integer

    Port = intPort

End Property

Public Property Let Port(intInput As Integer)

    intPort = intInput

End Property

Public Property Get Proxy() As String

    Proxy = strProxy

End Property

Public Property Let Proxy(strInput As String)

    strProxy = strInput

End Property

':) Ulli's VB Code Formatter V2.13.6 (10.08.2005 23:06:31) 17 + 94 = 111 Lines

