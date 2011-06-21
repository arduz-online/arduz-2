VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsSecurity"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
'#If NAC Then
Option Explicit
Rem Desencriptador / Encriptador - Check de paquetes
Rem @writer: MENDUZ - MENDUZ@NOICODER.COM
Rem @date: 03122008

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal Length As Long)

Dim Ultimo1 As Byte
Dim Ultimo2 As Byte
Public Redundance As Byte

Public Function NAC_E_String(ByVal t As String, ByVal code As Byte) As String
    Dim Bytes() As Byte
    Bytes = StrConv(t, vbFromUnicode)
    Call NAC_E_Byte(Bytes, code)
    NAC_E_String = StrConv(Bytes, vbUnicode)
End Function

Public Function NAC_D_String(ByVal t As String, ByVal code As Integer) As String
    Dim Bytes() As Byte
    Bytes = StrConv(t, vbFromUnicode)
    Call NAC_D_ByteB(Bytes, code)
    NAC_D_String = StrConv(Bytes, vbUnicode)
End Function

Public Sub NAC_E_Byte(ByRef ByteArray() As Byte, ByVal code As Byte)
    Dim i As Integer
    For i = 0 To UBound(ByteArray)
        ByteArray(i) = code Xor ByteArray(i)
    Next
End Sub

Public Sub NAC_D_Byte(ByRef ByteArray() As Byte, ByVal code As Byte, Optional ByVal start As Long = 0)
    Dim i As Integer
    Debug.Print UBound(ByteArray())
    For i = 0 To UBound(ByteArray) - start
        ByteArray(i) = ByteArray(i + start) Xor code
    Next
    If start > 0 Then ReDim Preserve ByteArray(UBound(ByteArray()) - start)
    Debug.Print UBound(ByteArray())
End Sub

Public Sub NAC_D_ByteA(ByRef ByteArray() As Byte, ByVal code As Byte)
    Dim i As Integer
    For i = 0 To UBound(ByteArray)
        ByteArray(i) = ByteArray(i) Xor code
    Next
End Sub

Public Sub NAC_D_ByteB(ByRef ByteArray() As Byte, ByVal code As Integer)
    Dim i As Integer
    On Error Resume Next
    For i = 0 To UBound(ByteArray)
        ByteArray(i) = ByteArray(i) Xor code
    Next
End Sub
