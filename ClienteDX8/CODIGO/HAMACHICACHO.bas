Attribute VB_Name = "modMAC"
Option Explicit

' Declarations needed for GetAdaptersInfo & GetIfTable
Private Const MIB_IF_TYPE_OTHER                   As Long = 1
Private Const MIB_IF_TYPE_ETHERNET                As Long = 6
Private Const MIB_IF_TYPE_TOKENRING               As Long = 9
Private Const MIB_IF_TYPE_FDDI                    As Long = 15
Private Const MIB_IF_TYPE_PPP                     As Long = 23
Private Const MIB_IF_TYPE_LOOPBACK                As Long = 24
Private Const MIB_IF_TYPE_SLIP                    As Long = 28

Private Const MIB_IF_ADMIN_STATUS_UP              As Long = 1
Private Const MIB_IF_ADMIN_STATUS_DOWN            As Long = 2
Private Const MIB_IF_ADMIN_STATUS_TESTING         As Long = 3

Private Const MIB_IF_OPER_STATUS_NON_OPERATIONAL  As Long = 0
Private Const MIB_IF_OPER_STATUS_UNREACHABLE      As Long = 1
Private Const MIB_IF_OPER_STATUS_DISCONNECTED     As Long = 2
Private Const MIB_IF_OPER_STATUS_CONNECTING       As Long = 3
Private Const MIB_IF_OPER_STATUS_CONNECTED        As Long = 4
Private Const MIB_IF_OPER_STATUS_OPERATIONAL      As Long = 5

Private Const MAX_ADAPTER_DESCRIPTION_LENGTH      As Long = 128
Private Const MAX_ADAPTER_DESCRIPTION_LENGTH_p    As Long = MAX_ADAPTER_DESCRIPTION_LENGTH + 4
Private Const MAX_ADAPTER_NAME_LENGTH             As Long = 256
Private Const MAX_ADAPTER_NAME_LENGTH_p           As Long = MAX_ADAPTER_NAME_LENGTH + 4
Private Const MAX_ADAPTER_ADDRESS_LENGTH          As Long = 8
Private Const DEFAULT_MINIMUM_ENTITIES            As Long = 32
Private Const MAX_HOSTNAME_LEN                    As Long = 128
Private Const MAX_DOMAIN_NAME_LEN                 As Long = 128
Private Const MAX_SCOPE_ID_LEN                    As Long = 256

Private Const MAXLEN_IFDESCR                      As Long = 256
Private Const MAX_INTERFACE_NAME_LEN              As Long = MAXLEN_IFDESCR * 2
Private Const MAXLEN_PHYSADDR                     As Long = 8

' Information structure returned by GetIfEntry/GetIfTable
Private Type MIB_IFROW
    wszName(0 To MAX_INTERFACE_NAME_LEN - 1) As Byte    ' MSDN Docs say pointer, but it is WCHAR array
    dwIndex             As Long
    dwType              As Long
    dwMtu               As Long
    dwSpeed             As Long
    dwPhysAddrLen       As Long
    bPhysAddr(MAXLEN_PHYSADDR - 1) As Byte
    dwAdminStatus       As Long
    dwOperStatus        As Long
    dwLastChange        As Long
    dwInOctets          As Long
    dwInUcastPkts       As Long
    dwInNUcastPkts      As Long
    dwInDiscards        As Long
    dwInErrors          As Long
    dwInUnknownProtos   As Long
    dwOutOctets         As Long
    dwOutUcastPkts      As Long
    dwOutNUcastPkts     As Long
    dwOutDiscards       As Long
    dwOutErrors         As Long
    dwOutQLen           As Long
    dwDescrLen          As Long
    bDescr As String * MAXLEN_IFDESCR
End Type

Private Type TIME_t
    aTime As Long
End Type

Private Type IP_ADDRESS_STRING
    IPadrString     As String * 16
End Type

Private Type IP_ADDR_STRING
    AdrNext         As Long
    IpAddress       As IP_ADDRESS_STRING
    IpMask          As IP_ADDRESS_STRING
    NTEcontext      As Long
End Type

' Information structure returned by GetIfEntry/GetIfTable
Private Type IP_ADAPTER_INFO
    Next As Long
    ComboIndex As Long
    AdapterName         As String * MAX_ADAPTER_NAME_LENGTH_p
    Description         As String * MAX_ADAPTER_DESCRIPTION_LENGTH_p
    MACadrLength        As Long
    MACaddress(0 To MAX_ADAPTER_ADDRESS_LENGTH - 1) As Byte
    AdapterIndex        As Long
    AdapterType         As Long             ' MSDN Docs say "UInt", but is 4 bytes
    DhcpEnabled         As Long             ' MSDN Docs say "UInt", but is 4 bytes
    CurrentIpAddress    As Long
    IpAddressList       As IP_ADDR_STRING
    GatewayList         As IP_ADDR_STRING
    DhcpServer          As IP_ADDR_STRING
    HaveWins            As Long             ' MSDN Docs say "Bool", but is 4 bytes
    PrimaryWinsServer   As IP_ADDR_STRING
    SecondaryWinsServer As IP_ADDR_STRING
    LeaseObtained       As TIME_t
    LeaseExpires        As TIME_t
End Type

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal numbytes As Long)
Private Declare Function GetAdaptersInfo Lib "iphlpapi.dll" (ByRef pAdapterInfo As Any, ByRef pOutBufLen As Long) As Long
Private Declare Function GetNumberOfInterfaces Lib "iphlpapi.dll" (ByRef pdwNumIf As Long) As Long

Public hamachi As Boolean
Public ClientID As Double
Public macaddr As String

Private Const BIGNUMBER_32 As Double = (2 ^ 32)

Private Function lngSigned(ByVal dblUnsigned As Double) As Long
    If dblUnsigned <= &H7FFFFFFF Then 'If uDouble is less than or equal To 0x7FFFFFFF, just return the raw uDouble value.
        lngSigned = dblUnsigned 'Return the raw uDouble value
    Else 'If uDouble is equal To or greater than &H80000000, we must process the uDouble value.
        lngSigned = CLng(dblUnsigned - BIGNUMBER_32) 'Because Long is a 32-bit, signed value, we must subtract (2^32) from uDouble.
    End If 'End of If statement
End Function

Private Function dblUnsigned(ByVal lngSigned As Long) As Double
    If lngSigned >= 0 Then 'If sLong is equal To or greater than zero, just return the raw sLong value.
        dblUnsigned = lngSigned 'Return the raw sLong value
    Else 'If xFileLen is less than zero (eg. -1, -2, -3, -4, -..., -65536, etc), we must process the sLong value.
        dblUnsigned = BIGNUMBER_32 + lngSigned 'Because Long is a 32-bit signed value, we need To add sLong to (2 to the power of 32). Because sLong is negative, adding the two numbers is basically subtracting sLong from (2^32).
    End If 'End of If statement
End Function

Public Sub Init_Hamachi()
    macaddr = get_mac_address
    ClientID = get_pc_id
End Sub

Function Hex2Decimal(sHexVal As String) As Long
    Hex2Decimal = Val("&H" & sHexVal & "&")
End Function

Private Function MAC2String(AdrArray() As Byte) As String
    Dim aStr As String, hexStr As String, i%
    For i = 0 To 5
        If (i > UBound(AdrArray)) Then
            hexStr = "00"
        Else
            hexStr = Hex$(AdrArray(i))
        End If
        If (Len(hexStr) < 2) Then hexStr = "0" & hexStr
        aStr = aStr & hexStr
    Next i
    MAC2String = aStr
End Function

Public Function get_pc_id() As Double
    Dim tmpl&, i&
    Dim bytearr(3) As Byte
    Dim Bytes() As Byte
    Dim tmp#
    Bytes = mac_get
    ReDim Preserve Bytes(5) As Byte
    
    For i = 0 To 3: bytearr(i) = Bytes(2 + i) Xor (255 - (Bytes(1) Xor Bytes(0))): Next i
    
    Call CopyMemory(tmpl, bytearr(0), 4)
    
    'tmpl = tmpl Xor CPUmhz
    
    get_pc_id = dblUnsigned(tmpl)
    tmp = Val(GetSetting("ArduzII", "AntiCheat", "PCID", "0"))
    If tmp > 0 Then
        If tmp <> get_pc_id Then
            'enviar_nueva_id
        End If
    End If
    SaveSetting "ArduzII", "AntiCheat", "PCID", CStr(get_pc_id)
    
End Function

Public Function get_mac_address() As String
    Dim Bytes() As Byte
    Bytes = mac_get()
    get_mac_address = MAC2String(mac_get)
End Function

Public Function get_hamachi_active() As Boolean
    Call mac_get(get_hamachi_active)
End Function

Private Function mac_get(Optional ByRef hamachi As Boolean, Optional ByRef haip As String) As Byte()
    Dim AdapInfo As IP_ADAPTER_INFO, bufLen As Long, sts As Long
    Dim retStr As String, numStructs%, i%, IPinfoBuf() As Byte, srcPtr As Long
    sts = GetAdaptersInfo(AdapInfo, bufLen)
    If (bufLen = 0) Then Exit Function
    numStructs = bufLen / Len(AdapInfo)
    ReDim IPinfoBuf(0 To bufLen - 1) As Byte
    sts = GetAdaptersInfo(IPinfoBuf(0), bufLen)
    If (sts <> 0) Then Exit Function

    srcPtr = VarPtr(IPinfoBuf(0))
    For i = 0 To numStructs - 1
        If (srcPtr = 0) Then Exit For
        Call CopyMemory(AdapInfo, ByVal srcPtr, Len(AdapInfo))
        With AdapInfo
            If (.AdapterType = MIB_IF_TYPE_ETHERNET) Then
                If Not .Description Like "*Hamachi*" Then
                    mac_get = .MACaddress()
                Else
                    hamachi = True
                    haip = StripTerminator(.IpAddressList.IpAddress.IPadrString)
                End If
            End If
        End With
        srcPtr = AdapInfo.Next
    Next i
End Function

Private Function StripTerminator(ByVal strString As String) As String
    Dim intZeroPos As Integer
    intZeroPos = InStr(strString, Chr$(0))


    If intZeroPos > 0 Then
        StripTerminator = left$(strString, intZeroPos - 1)
    Else
        StripTerminator = strString
    End If
End Function
