Attribute VB_Name = "modBitStore"
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
'
' Used to manipulate the bits(using that as IO flags) of integer variables to save memory
'

'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date: 10192009
' @version 1.0.0


Option Explicit

Private bitwisetable(0 To 31) As Long

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date: 10192009

Public Sub BS_Init_Table()
   bitwisetable(0) = &H1&
   bitwisetable(1) = &H2&
   bitwisetable(2) = &H4&
   bitwisetable(3) = &H8&
   bitwisetable(4) = &H10&
   bitwisetable(5) = &H20&
   bitwisetable(6) = &H40&
   bitwisetable(7) = &H80&
   bitwisetable(8) = &H100&
   bitwisetable(9) = &H200&
   bitwisetable(10) = &H400&
   bitwisetable(11) = &H800&
   bitwisetable(12) = &H1000&
   bitwisetable(13) = &H2000&
   bitwisetable(14) = &H4000&
   bitwisetable(15) = &H8000&
   bitwisetable(16) = &H10000
   bitwisetable(17) = &H20000
   bitwisetable(18) = &H40000
   bitwisetable(19) = &H80000
   bitwisetable(20) = &H100000
   bitwisetable(21) = &H200000
   bitwisetable(22) = &H400000
   bitwisetable(23) = &H800000
   bitwisetable(24) = &H1000000
   bitwisetable(25) = &H2000000
   bitwisetable(26) = &H4000000
   bitwisetable(27) = &H8000000
   bitwisetable(28) = &H10000000
   bitwisetable(29) = &H20000000
   bitwisetable(30) = &H40000000
   bitwisetable(31) = &H80000000
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Byte_On(ByRef var As Byte, ByVal bit As Byte)
    var = var Or bitwisetable(bit Mod 8)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Byte_Off(ByRef var As Byte, ByVal bit As Byte)
    var = var And Not bitwisetable(bit Mod 8)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Byte_Toggle(ByRef var As Byte, ByVal bit As Byte)
    var = var Xor bitwisetable(bit Mod 8)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to get
Public Function BS_Byte_Get(ByRef var As Byte, ByVal bit As Byte) As Boolean
    BS_Byte_Get = (var And bitwisetable(bit Mod 8)) <> 0
End Function




''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Integer_On(ByRef var As Integer, ByVal bit As Byte)
    var = var Or 2 ^ (bit Mod 16)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Integer_Off(ByRef var As Integer, ByVal bit As Byte)
    var = var And Not bitwisetable(bit Mod 16)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Integer_Toggle(ByRef var As Integer, ByVal bit As Byte)
    var = var Xor bitwisetable(bit Mod 16)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to get
' @returns: boolean
Public Function BS_Integer_Get(ByRef var As Integer, ByVal bit As Byte) As Boolean
    BS_Integer_Get = (var And bitwisetable(bit Mod 16)) <> 0
End Function




''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Long_On(ByRef var As Long, ByVal bit As Byte)
    var = var Or bitwisetable(bit Mod 32)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Long_Off(ByRef var As Long, ByVal bit As Byte)
    var = var And Not bitwisetable(bit Mod 32)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to modify
Public Sub BS_Long_Toggle(ByRef var As Long, ByVal bit As Byte)
    var = var Xor bitwisetable(bit Mod 32)
End Sub

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10192009
' @params: *var to be modified
'          bit byte to get
' @returns: boolean
Public Function BS_Long_Get(ByRef var As Long, ByVal bit As Byte) As Boolean
    BS_Long_Get = (var And bitwisetable(bit Mod 32)) <> 0
End Function


''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10182009
' @returns: long
Public Function BS_ShiftRight(ByVal var As Long, ByVal bits As Integer) As Long
    ' >>
    BS_ShiftRight = var \ bitwisetable(bits Mod 32)
End Function

''
'
' @author: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @date:   10182009
' @returns: long
Public Function BS_ShiftLeft(ByVal var As Long, ByVal bits As Integer) As Long
    ' <<
    BS_ShiftLeft = var * bitwisetable(bits Mod 32)
End Function
