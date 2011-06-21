Attribute VB_Name = "Security"
'**************************************************************
' Security.bas - Requests all logged clients a checksum on a
' random data using a random key with a randomly chosen algorithm.
'
' Designed and implemented by Juan Martín Sotuyo Dodero (Maraxus)
' (juansotuyo@gmail.com)
'**************************************************************

'**************************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

''
' Requests all logged clients a checksum on a
' random data using a random key with a randomly chosen algorithm.
'
' @author Juan Martín Sotuyo Dodero (Maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20070210

Option Explicit

#Const SeguridadArduz = True
''
' Number of checksums that can be ignored when replying a MD5 request
Public Const MD5_REQUEST_SECURITY_TOLERANCE As Byte = 6

''
' Represents no slot at all. Used to send data to users with no valid userindex.
Public Const NO_SLOT As Integer = -1

''
' Initial vaue of outgoing crypt key.
Private InitialKeyOut As Byte

''
' Initial vaue of incoming crypt key.
Private InitialKeyIn As Byte

Public Type SecurityData
    ExpectedCheckSum As Long
    CheckSumValidated As Boolean
    
    EncryptationKeyIn As Byte
    EncryptationKeyOut As Byte
    
    EncryptationKeyOutBackup As Byte
    
    Md5RequestedSecurityTolerance As Byte
End Type

'TODO PASAR A C++ Y ENCRIPTARRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!

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
    Dim b(3) As Byte
    Dim L As Long
    parse = Split(ip, ".")
    b(0) = Val(parse(0))
    b(1) = Val(parse(1))
    b(2) = Val(parse(2))
    b(3) = Val(parse(3))
    CopyMemory L, b(0), 4
    ip2long = L
End Function

''
' Resets all data to understand incoming / outcoming data for login sequence.

Public Sub NewConnection(ByVal UserIndex As Integer)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    With UserList(UserIndex).Security
        .EncryptationKeyIn = InitialKeyIn
        .EncryptationKeyOut = InitialKeyOut
    End With
End Sub

''
' Resets all security data for a new player who is getting connected.

Public Sub UserConnected(ByVal UserIndex As Integer)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    UserList(UserIndex).Security.CheckSumValidated = True
    UserList(UserIndex).Security.Md5RequestedSecurityTolerance = 0
End Sub

''
' Resets all security data clearing the slot.

Public Sub UserDisconnected(ByVal UserIndex As Integer)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    With UserList(UserIndex).Security
        .CheckSumValidated = True
        .EncryptationKeyIn = InitialKeyIn
        .EncryptationKeyOut = InitialKeyOut
    End With
End Sub

''
' Takes received data and decrypts it.
' The function name says nothing about this to keep it secret when releasing the code.

Public Sub DataReceived(ByVal UserIndex As Integer, ByRef data() As Byte)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    Dim i As Long
    Dim cryptNext As Byte
    
    'Each byte is XOred with the previous one. Simple and fast way of having dynamic encriptation keys.
    With UserList(UserIndex).Security
        For i = LBound(data()) To UBound(data())
            cryptNext = data(i)
            data(i) = data(i) Xor .EncryptationKeyIn
            .EncryptationKeyIn = cryptNext
        Next i
    End With
End Sub

''
' Takes data being sent and encrypts it.
' The function name says nothing about this to keep it secret when releasing the code.

Public Sub DataSent(ByVal UserIndex As Integer, ByRef data() As Byte)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    If UserIndex = NO_SLOT Then
        Call EncryptData(data, InitialKeyOut)
    Else
        'Each byte is XOred with the previous one. Simple and fast way of having dynamic encriptation keys.
        With UserList(UserIndex).Security
            .EncryptationKeyOutBackup = .EncryptationKeyOut
            
            Call EncryptData(data, .EncryptationKeyOut)
        End With
    End If
End Sub

''
' Takes data being sent and encrypts it.
' Abstracts the algorithm from the user to which it's being sent.

Private Sub EncryptData(ByRef data() As Byte, ByRef key As Byte)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    Dim i As Long
    
    For i = LBound(data()) To UBound(data())
        data(i) = data(i) Xor key
        key = data(i)
    Next i
End Sub

Public Function ReadPacket(ByVal UserIndex As Integer, ByRef echar As Byte) As Byte
    Dim CRCtmp As Byte
    echar = 0

    CRCtmp = UserList(UserIndex).incomingData.ReadCRCChar 'UserList(UserIndex).incomingData.ReadByte() Xor 108
    HandleCRC = UserList(UserIndex).incomingData.PeekByte()
    
    If UserList(UserIndex).Ultimo1 = 255 Then UserList(UserIndex).Ultimo1 = 1
    If UserList(UserIndex).flags.UserLogged = True And Not (HandleCRC = 0) Then 'ClientPacketID.LoginExistingChar=0
        If UserList(UserIndex).Ultimo1 <> CRCtmp Then
            echar = 1
        End If
    End If
    
    UserList(UserIndex).Ultimo1 = UserList(UserIndex).Ultimo1 + 1
End Function

Public Sub EcharPorPaquete(ByVal UserIndex As Integer)
    If UserList(UserIndex).Ultimo1 > 0 Then
        Call SendData(ToAdmins, 0, PrepareMessageConsoleMsg("NAC> " & UserList(UserIndex).nick & " fue hechado por uso de cheats.", FontTypeNames.FONTTYPE_SERVER))
        WEBCLASS.cheating UserList(UserIndex).name, UserList(UserIndex).name & " C-01>Invalid CRC; paquete:" & packetID & " U1:" & Hex$(UserList(UserIndex).Ultimo1) & " CRC:" & Hex$(CRCtmp), UserList(UserIndex).ClientID
        'Call LogError(UserList(UserIndex).name & " C-01>Invalid CRC; paquete:" & packetID)
    End If
    Call UserList(UserIndex).incomingData.Clear
    FlushBuffer UserIndex
    Call UserList(UserIndex).outgoingData.Clear
    CloseSocket UserIndex
    UserList(UserIndex).Ultimo1 = 0
    UserList(UserIndex).antiloop = 0
End Sub

''
' Resets the encryptation key of sent data to avoid corruption when decrypting it in the client.
' The function name says nothing about this to keep it secret when releasing the code.

Public Sub DataStored(ByVal UserIndex As Integer)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    UserList(UserIndex).Security.EncryptationKeyOut = UserList(UserIndex).Security.EncryptationKeyOutBackup
End Sub

''
' Sets the mixed key and initial values of outgoing and incoming data crypt keys.

Public Sub SetServerIp(ByRef ip As String)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 01/09/07
'
'***************************************************
    Dim addrCodes(3) As Byte
    Dim byteCodes() As String
    Dim i As Long
    
    byteCodes = Split(ip, ".")
    
    For i = 0 To 3
        addrCodes(i) = CByte(byteCodes(i))
    Next i
    
    PrivateCrcFunction.MixedKey = (CLng(Not addrCodes(0)) Mod &H7F) * 16777216 + CLng(addrCodes(1) Xor addrCodes(2)) * 65536 + CLng(addrCodes(2)) * 255 + Not addrCodes(3)
    
    
    InitialKeyOut = PrivateCrcFunction.MixedKey Mod 256
    InitialKeyIn = Not InitialKeyOut
End Sub
