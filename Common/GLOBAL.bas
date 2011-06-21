Attribute VB_Name = "modGlobal"
'                  ____________________________________________
'                 /_____/  http://www.arduz.com.ar/ao/   \_____\
'                //            ____   ____   _    _ _____      \\
'               //       /\   |  __ \|  __ \| |  | |___  /      \\
'              //       /  \  | |__) | |  | | |  | |  / /        \\
'             //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
'            //       / ____ \| | \ \| |__| | |__| |/ /__          \\
'           / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
'           \________________________________________________________/


#Const Debuging = 0

#If Debuging = 1 Then
    Public Const WEBPATH As String = "ao/dataserver/" '"http://localhost/ao/" '
    Public Const host_web As String = "localhost" '"localhost"
#Else
    Public Const WEBPATH As String = "dataserver/" '"http://localhost/ao/" '
    Public Const host_web As String = "www.arduz.com.ar" '"ao.noicoder.com"
#End If

Public Const WEBSERVER As String = "http://" & host_web & "/"

#If IsUpdater = 1 Then
    Public Const game_version As String = "0.0.0"
#Else
    Public Const game_version As String = "0.2.05"
#End If

Public Const client_checksum As Long = &H8

Public Const CONTRASEÑAWEB As String * 32 = "37b80381a2999fb4e3da87bbf7e003f0"

Public WebUserAgent As String

Public Const MapSize As Long = 250

Public Function GetCfg(app$, master$, Key$, Optional default$) As String
On Error Resume Next
    GetCfg = Xor_String(GetSetting(app, master, Key, default), 109)
End Function

Public Function SaveCfg(app$, master$, Key$, Value$) As String
On Error Resume Next
    Call SaveSetting(app, master, Key, Xor_String(Value, 109))
End Function

Private Function Xor_String(ByRef t As String, ByVal code As Byte) As String
    Dim bytes() As Byte
    bytes = StrConv(t, vbFromUnicode)
    Call Xor_Bytes(bytes, code)
    Xor_String = StrConv(bytes, vbUnicode)
End Function

Private Sub Xor_Bytes(ByRef ByteArray() As Byte, ByVal code As Byte)
    Dim i As Integer
    For i = 0 To UBound(ByteArray)
        ByteArray(i) = code Xor (ByteArray(i) Xor CryptKey)
    Next
End Sub

Public Function gen_conection_checksum(ByVal lng As Long) As String
    Dim tstr() As Byte
    Dim trt(15) As Byte
    tstr = StrConv(MD5String(STR(lng - 413)), vbFromUnicode)
    For i = 0 To 15
        trt(i) = (tstr(i) Xor tstr(16 + i) Xor lng) Mod 255
    Next i
    gen_conection_checksum = StrConv(trt, vbUnicode)
End Function

Public Function IsIDE() As Boolean
     On Error GoTo IDEInUse
     Debug.Print 1 \ 0 'division by zero error
     IsIDE = False
     Exit Function
IDEInUse:
     On Error GoTo 0
     IsIDE = True
End Function


