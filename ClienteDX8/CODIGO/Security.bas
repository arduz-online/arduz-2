Attribute VB_Name = "Security"
Option Explicit

Public out_key As Byte

Public SeguridadArduz As Byte

Public Sub EncryptData(ByRef data() As Byte, ByRef key As Byte)
    If SeguridadArduz = True Then
        Dim i As Long
        For i = LBound(data()) To UBound(data())
            data(i) = data(i) Xor key
            key = data(i)
        Next i
    End If
End Sub
