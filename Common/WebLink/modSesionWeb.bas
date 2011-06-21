Attribute VB_Name = "modSesionWeb"
Option Explicit

Public WebUserName      As String
Public WebUserID        As Long
Public WebPassword      As String
Public WebPasswordMD5   As String * 32
Public WebPrivs         As Long
Public WebSession       As Long
Private CodigoPrivado   As Long

Private Declare Function GetTickCount Lib "kernel32" () As Long


Public Sub EnviarMapa(ByRef Mapa As clsConvertidoraMapas, ByRef WebControl As clsWEBA)
    Dim MD5                     As String
    Dim bytes()                 As Byte
    Dim TamanioSinComprimir     As Long
    Dim objHTTPRequest          As New CHTTPRequest
    Dim FileName                As String
    Dim MapaChecksum            As Long
    Dim CodigoMapa              As String
    
    
    CodigoMapa = MD5String("spdoaspdoksoakopd" & Rnd & Hex(Rnd * &HFFFFFFFF))


    FileName = "C:\WINDOWS\TEMP\" & CodigoMapa
    
    'Guardamos el mapa
    If Mapa.Guardar(FileName) = False Then Exit Sub
    
    

    MD5 = MD5File(FileName)
    bytes = GetFileQuick(FileName)
    
    TamanioSinComprimir = UBound(bytes) + 1
    
    Compress_Data bytes
    
    With objHTTPRequest
        .MimeBoundary = "CeReBrOdEmOnO" & Hex(GetTickCount())

        'Form fields
        Call .AddFormData("session", WebSession)
        Call .AddFormData("code", CodigoPrivado)
        Call .AddFormData("pass", WebPasswordMD5)
        
        Call .AddFormData("checksum", Mapa.ClaveSeguridad Xor 103271826 Xor WebSession)

        Call .AddFormData("map_name", Trim(CStr(Mapa.NombreMapa)))

        If FileExist(FileName) Then
            Call .AddFormData("MD5", MD5)
            Call .AddFormData("size", TamanioSinComprimir)
            Call .AddFormData("codigo_seguridad", MD5String(MD5 & "ARDUS SABEEEE" & WebSession))
            
            Call .AddFile("file", "mapa.am", StrConv(bytes, vbUnicode), "octet/arduz+map")
            
        Else
            MsgBox "Un error ocurrió, por favor intente denuevo"
            Exit Sub
        End If
    End With

    WebControl.SendEXT "mapas_enviar", objHTTPRequest, ""

End Sub

