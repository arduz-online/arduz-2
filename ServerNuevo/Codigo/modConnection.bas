Attribute VB_Name = "modConnection"
Option Explicit

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

Public connection_check As String * 16
Public connection_checkb(15) As Byte
Public connection_crc_make As Long

Public nalg_alg_act As Boolean

Public Sub gen_c_c()
    Dim tstr() As Byte
    connection_crc_make = Rnd * 2147483647
    tstr = StrConv(gen_conection_checksum(connection_crc_make), vbFromUnicode)
    connection_check = StrConv(tstr, vbUnicode)
    Call CopyMemory(connection_checkb(0), tstr(0), 16)
End Sub

Public Function ip2long(ByVal ip As String) As Long
On Error Resume Next
    Dim parse() As String
    Dim B(3) As Byte
    Dim L As Long
    parse = Split(ip, ".")
    B(0) = Val(parse(0))
    B(1) = Val(parse(1))
    B(2) = Val(parse(2))
    B(3) = Val(parse(3))
    CopyMemory L, B(0), 4
    ip2long = L
End Function
