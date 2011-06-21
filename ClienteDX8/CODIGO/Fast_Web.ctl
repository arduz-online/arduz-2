VERSION 5.00
Begin VB.UserControl Fast_Web 
   ClientHeight    =   465
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   480
   Picture         =   "Fast_Web.ctx":0000
   ScaleHeight     =   465
   ScaleWidth      =   480
End
Attribute VB_Name = "Fast_Web"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private ACTION_POST As Boolean
Private raw As Boolean
Private send_data As String
Private URL As String
Private code As String
#Const UseUnisock = 1
#If UseUnisock = 1 Then
Dim WithEvents Winsock1 As UniSock
Attribute Winsock1.VB_VarHelpID = -1
#End If
Event RecibeDatosWeb(ByRef datos As String, ByRef raw As Boolean)



Private Sub UserControl_Initialize()
#If UseUnisock = 1 Then
Set Winsock1 = New UniSock
Winsock1.Protocol = sckTCPProtocol
Winsock1.RemotePort = 80
Winsock1.Mode = [Socket Binary Mode]
#End If
End Sub

Private Sub UserControl_Resize()
UserControl.Width = 32 * Screen.TwipsPerPixelX
UserControl.Height = 32 * Screen.TwipsPerPixelY
End Sub

Public Function Send(cmd As String, Optional raw_data As String, Optional codigo As String = vbNullString) As Boolean
    If Winsock1.State = sckClosed Then
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
    If Winsock1.State = 0 Then
        ACTION_POST = Len(raw_data) > 0
        send_data = raw_data
        URL = cmd
        raw = True
        connect
        oURL = True
    End If
End Function

Public Property Get Puedo() As Boolean
    Puedo = Winsock1.State = 0
End Property

Private Sub connect()
    If Winsock1.State = 0 Then
        Winsock1.Protocol = sckTCPProtocol
        Winsock1.connect host_web, 80
    End If
End Sub

Private Sub Winsock1_Connect()
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
    "User-Agent: Arduz/" & App.Major & "." & App.Minor & "/" & macaddr & vbCrLf
    
    If ACTION_POST Then
        Buffer = Buffer & _
            "Content-Length: " & CStr(Len(send_data)) & vbCrLf & _
            "Content-Type: application/x-www-form-urlencoded" & vbCrLf & vbCrLf & _
            send_data & vbCrLf & vbCrLf
    Else
        Buffer = Buffer & vbCrLf
    End If

    Winsock1.SendData Buffer
    Debug.Print Buffer
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim datos As String
    Dim cabecera() As String
    Winsock1.GetData datos
    
    Winsock1.CloseSocket
    
    Debug.Print datos
    If InStr(1, datos, vbCrLf & vbCrLf, vbTextCompare) <> 0 And InStr(1, datos, "HTTP/1.1 200 OK", vbTextCompare) Then
        cabecera = Split(datos, vbCrLf & vbCrLf, 2)
        RaiseEvent RecibeDatosWeb(cabecera(1), False)
    Else
        RaiseEvent RecibeDatosWeb(datos, True)
    End If
    
End Sub

