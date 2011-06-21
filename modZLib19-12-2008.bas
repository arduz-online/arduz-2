Attribute VB_Name = "modZLib"
Option Explicit

Public Type INFOHEADER
    file_type As Integer
    compress As Boolean
    datex As Currency
    crc As Long
    size_compressed As Long
    originalname As String * 69
    cript As Byte
    lngFileSizeUncompressed As Long
End Type

Public Enum eTiposRecursos
    rDesconocido = 0
    rPng = 64
    rBmp = 2
    rJpg = 3
    rInit = 4
    rMapData = 5
End Enum

Private Const header_s As String * 16 = "MZEngineResource"

Private Const CryptKey As Byte = 249
Private Const CryptKeyL As Long = &HFACEB00C

Private Declare Function compress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Private Declare Function UnCompress Lib "zlib.dll" Alias "uncompress" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef Source As Any, ByVal byteCount As Long)

Public last_file_ext As INFOHEADER

Public Extraidox As Boolean


Private crcTable(0 To 255) As Long 'crc32
Private CRCTabled As Boolean

Private Declare Sub MDFile Lib "aamd532.dll" (ByVal f As String, ByVal r As String)
Private Declare Sub MDStringFix Lib "aamd532.dll" (ByVal f As String, ByVal t As Long, ByVal r As String)

Public Function MD5String(p As String) As String
' compute MD5 digest on a given string, returning the result
    Dim r As String * 32, t As Long
    r = Space(32)
    t = Len(p)
    MDStringFix p, t, r
    MD5String = r
End Function

Public Function MD5File(f As String) As String
' compute MD5 digest on o given file, returning the result
    Dim r As String * 32
    r = Space(32)
    MDFile f, r
    MD5File = r
End Function

Public Sub Compress_Data(ByRef data() As Byte)
    Dim Dimensions As Long
    Dim DimBuffer As Long
    Dim BufTemp() As Byte
    Dim BufTemp2() As Byte
    Dim loopc As Long
    
    Dimensions = UBound(data)
    
    DimBuffer = Dimensions * 1.06
    ReDim BufTemp(DimBuffer)
    
    compress BufTemp(0), DimBuffer, data(0), Dimensions
    
    Erase data
    
    ReDim Preserve BufTemp(DimBuffer - 1)
    
    data = BufTemp
    
    Erase BufTemp
    
    data(0) = data(0) Xor CryptKey Xor data(1)
End Sub

Public Sub Decompress_Data(ByRef data() As Byte, ByVal OrigSize As Long)

    Dim BufTemp() As Byte
    
    ReDim BufTemp(OrigSize - 1)
    
    data(0) = data(0) Xor CryptKey Xor data(1)
    
    UnCompress BufTemp(0), OrigSize, data(0), UBound(data) + 1
    
    ReDim data(OrigSize - 1)
    
    data = BufTemp
    
    Erase BufTemp
End Sub

Public Function Resource_Extract(ByRef path As String, ByRef filename As String, ByVal dest As String) As Boolean
'On Error GoTo errh
Dim SourceData() As Byte
Dim handle%
handle = FreeFile()

Resource_Get path, filename, SourceData
If (Dir$(dest, vbNormal) <> "") Then Kill dest
If Extraidox = True Then
Open dest For Binary Access Read Write As handle
    Put handle, , SourceData()
Close handle
End If
Resource_Extract = Extraidox
errh:
End Function

Public Function Resource_Get_Raw(ByRef path As String, ByRef filename As String) As String

Dim SourceData() As Byte
Resource_Get path, filename, SourceData

If Extraidox = True Then
    Resource_Get_Raw = StrConv(SourceData, vbUnicode)
Else
    Resource_Get_Raw = vbNullString
End If
errh:
End Function

Public Function Resource_Get_CRC(ByRef path As String, ByRef filename As String) As Long
On Error GoTo errh
    Dim handle As Integer
    Dim SourceData() As Byte
    Dim InfoHead As INFOHEADER
    Dim abierto As Byte
    Dim tmpcrc As Long
    Dim asd As String * 16
    Dim tmpl As Long
    
    handle = FreeFile
    If Right$(path, 1) <> "\" Then path = path & "\"
    
    If LenB(Dir$(path & filename, vbNormal)) Then
        Open path & filename For Binary Access Read Lock Write As handle
            abierto = 1
            Get handle, , asd
            
            If StrComp(asd, header_s, vbTextCompare) Then
                LogError "El archivo : """ & filename & """ no es un archivo de recursos valido."
                GoTo erra
            End If
            
            Get handle, , InfoHead
            
            With InfoHead
    
                Extraidox = False
                If Left$(UCase$(Xor_String(CStr(.originalname), .cript)), Len(filename)) <> UCase$(filename) Then
                    Debug.Print "Invalid Filename"
                    LogError "Error en el archivo de recursos Invalid Checksum : """ & filename & """ [" & Left$(Xor_String(CStr(.originalname), .cript), Len(filename)) & "]-[" & filename & "]"
                    GoTo erra
                End If
    
                'FINAL, leer datos, descomprimir si esta comprimido
                .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)
                If .size_compressed > 1024 Then
                    ReDim SourceData(1024) As Byte
                Else
                    ReDim SourceData(.size_compressed) As Byte
                End If
                
                Get handle, , SourceData()
                
                If .size_compressed > 1024 Then
                    tmpcrc = CRC32(SourceData(), 1024)
                Else
                    tmpcrc = CRC32(SourceData(), .size_compressed - 1)
                End If
                
                If tmpcrc <> .crc Then
                    Debug.Print "Invalid CRC"
                    LogError "Error en el archivo de recursos Invalid Checksum2 : """ & filename & """ O:" & Hex(tmpcrc) & " E:" & Hex(CLng(.cript)) & " C:" & Hex(.crc)
                    GoTo erra
                End If
                
                Resource_Get_CRC = tmpcrc
            End With
        Close handle
        Resource_Get_CRC = 0
    Else
        LogError "Error en el archivo de recursos """ & filename & """ - El archivo no existe."
    End If
    
Exit Function
errh:
LogError "Error en el archivo de recursos """ & filename & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
If abierto = 1 Then Close handle
Resource_Get_CRC = 0
End Function

Public Function Resource_Get(ByRef path As String, ByRef filename As String, ByRef data() As Byte) As Boolean
On Error GoTo errh
    Dim handle As Integer
    Dim SourceData() As Byte
    Dim InfoHead As INFOHEADER
    Dim abierto As Byte
    Dim tmpcrc As Long
    Dim asd As String * 16
    Dim tmpl As Long
    
    handle = FreeFile
    If Right$(path, 1) <> "\" Then path = path & "\"
    
    If LenB(Dir$(path & filename, vbNormal)) Then
        Open path & filename For Binary Access Read Lock Write As handle
            abierto = 1
            Get handle, , asd
            
            If StrComp(asd, header_s, vbTextCompare) Then
                LogError "El archivo : """ & filename & """ no es un archivo de recursos valido."
                #If Debuging = 0 Then
                    End
                #End If
                GoTo erra
            End If
            
            Get handle, , InfoHead
            
            With InfoHead
    
                Extraidox = False
                If Left$(UCase$(Xor_String(CStr(.originalname), .cript)), Len(filename)) <> UCase$(filename) Then
                    Debug.Print "Invalid Filename"
                    
                    #If Debuging = 0 Then
                        LogError "Error en el archivo de recursos Invalid Checksum : """ & filename & """"
                        If abierto = 1 Then Close handle
                        End
                    #Else
                        LogError "Error en el archivo de recursos Invalid Checksum : """ & filename & """ [" & Left$(Xor_String(CStr(.originalname), .cript), Len(filename)) & "]-[" & filename & "]"
                    #End If
                    GoTo erra
                End If
    
                'FINAL, leer datos, descomprimir si esta comprimido
                .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)
                ReDim SourceData(.size_compressed) As Byte
    
                Get handle, , SourceData()
                
                If .size_compressed > 1024 Then
                    tmpcrc = CRC32(SourceData(), 1024)
                Else
                    tmpcrc = CRC32(SourceData(), .size_compressed - 1)
                End If
                
                If .compress = 1 Then Decompress_Data SourceData(), .lngFileSizeUncompressed
                
                data = SourceData
                last_file_ext = InfoHead
                
                If tmpcrc <> .crc Then
                    Debug.Print "Invalid CRC"
                    LogError "Error en el archivo de recursos Invalid Checksum2 : """ & filename & """ O:" & Hex(tmpcrc) & " E:" & Hex(CLng(.cript)) & " C:" & Hex(.crc)
                    
                    #If Debuging = 0 Then
                        If abierto = 1 Then Close handle
                        End
                    #End If
                    GoTo erra
                End If
                
                
                data = SourceData
                Extraidox = True
            End With
        Close handle
        Resource_Get = True
    Else
        LogError "Error en el archivo de recursos """ & filename & """ - El archivo no existe."
    End If
    
Exit Function
errh:
LogError "Error en el archivo de recursos """ & filename & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
If abierto = 1 Then Close handle

End Function

Public Sub Resource_Convert(ByRef sourcepath As String, ByRef path As String, ByRef filename As String, Optional ByVal arg1 As Integer = 0)
'On Error GoTo errh
    Dim handle As Integer
    Dim SourceData() As Byte
    Dim InfoHead As INFOHEADER
    Dim abierto As Byte
    Dim tmpcrc As Long
    Dim ts As String * 3
    Dim freem%
    Dim tmpl&
    
        handle = FreeFile
        freem = FreeFile()
    
    If Right$(path, 1) <> "\" Then path = path & "\"
    
    If (Dir$(sourcepath, vbNormal) <> "") Then
        Open sourcepath For Binary Lock Read As freem
            InfoHead.lngFileSizeUncompressed = LOF(freem)
            ReDim SourceData(InfoHead.lngFileSizeUncompressed - 1) As Byte
            Get freem, , SourceData()
        Close freem
        
        If InfoHead.lngFileSizeUncompressed > 0 Then
            With InfoHead
                .cript = CByte(CInt(Rnd * 150)) + 1

                .originalname = Xor_String(filename, .cript)
                
                ts = LCase$(Right$(sourcepath, 3))
                Select Case ts
                    Case "int", "dat", "ini", "ind"
                        .file_type = eTiposRecursos.rInit
                    Case "inf", "map"
                        .file_type = eTiposRecursos.rMapData
                    Case "jpg", "jpeg"
                        .file_type = eTiposRecursos.rJpg
                    Case "bmp"
                        .file_type = eTiposRecursos.rBmp
                    Case Else
                        .file_type = eTiposRecursos.rDesconocido
                End Select
                .compress = 1
                .futurei_e1 = arg1
                'If (.lngFileSizeUncompressed > 1500000) Then .compress = 1
                .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)
                
                If .compress = 1 Then
                    Compress_Data SourceData()
                End If
                
                .size_compressed = UBound(SourceData)
                If .size_compressed > 1024 Then
                    .crc = CRC32(SourceData(), 1024)
                Else
                    .crc = CRC32(SourceData(), .size_compressed - 1)
                End If
                Debug.Print path & filename & " PACKED_OK - C:" & Hex$(.crc) & " - COMP:" & CStr(CBool(.compress))
            End With
            
            Open path & filename For Binary Access Read Write As handle
                Put handle, , header_s
                Put handle, , InfoHead
                Put handle, , SourceData()
            Close handle
            
            Erase SourceData()
        Else
            Debug.Print "ERROR, FILELEN 0"; sourcepath
        End If
    Else
        LogError "Error en el archivo de a comprimir """ & filename & """ - El archivo No existe."
    End If
    
Exit Sub
errh:
LogError "Error en el archivo de recursos """ & filename & """"
End Sub

Public Function Resource_Read_sdf(ByRef path As String, ByRef filename As String) As String
On Error GoTo errh
    Dim handle As Integer
    Dim jo As String
    Dim abierto As Byte
    Dim tmpcrc As Byte
    Dim asd As String * 16
    Dim tmpl As Long
    
    handle = FreeFile
    
    If Right$(path, 1) <> "\" Then path = path & "\"
    
    If LenB(Dir$(path & filename, vbNormal)) Then
        Open path & filename For Binary Access Read Lock Write As handle
            Get handle, , asd
            Get handle, , tmpcrc
            Get handle, , jo
        Close handle

        If StrComp(asd, header_s, vbTextCompare) Then
            #If IsServer = 0 Then
            LogError "El archivo : """ & filename & """ no es un archivo valido.", True
            #End If
        Else
            Resource_Read_sdf = Xor_String(jo, tmpcrc)
        End If
    End If
    
Exit Function
errh:
LogError "Error en el archivo de recursos """ & filename & """ Err:" & Err.Number & " - Desc : " & Err.Description
End Function

Public Sub Resource_Create_sdf(ByRef data As String, ByRef path As String, ByRef filename As String)
    Dim handle As Integer
    Dim tmpcrc As Byte
    
    Dim jo As String
    tmpcrc = CByte(CInt(Rnd * 150)) + 1
    jo = Xor_String(data, tmpcrc)
    
    handle = FreeFile

    If Right$(path, 1) <> "\" Then path = path & "\"
    
    Open path & filename For Binary Access Read Write As handle
        Put handle, , header_s
        Put handle, , tmpcrc
        Put handle, , jo
    Close handle
End Sub

Private Function Xor_String(ByRef t As String, ByVal code As Byte) As String
    Dim Bytes() As Byte
    Bytes = StrConv(t, vbFromUnicode)
    Call Xor_Bytes(Bytes, code)
    Xor_String = StrConv(Bytes, vbUnicode)
End Function

Private Sub Xor_Bytes(ByRef ByteArray() As Byte, ByVal code As Byte)
    Dim i As Integer
    For i = 0 To UBound(ByteArray)
        ByteArray(i) = code Xor (ByteArray(i) Xor CryptKey)
    Next
End Sub

Public Function CRC32(ByRef bArrayIn() As Byte, ByVal lLen As Long, Optional ByVal lcrc As Long = 0) As Long
  Dim lCurPos As Long
  Dim lTemp As Long
  If CRCTabled = False Then BuildTable
  
  If lLen = 0 Then Exit Function 'In case of empty file
  lTemp = lcrc Xor &HFFFFFFFF 'lcrc is for current value from partial check on the partial array
  
  For lCurPos = 0 To lLen
    lTemp = (((lTemp And &HFFFFFF00) \ &H100) And &HFFFFFF) Xor (crcTable((lTemp And 255) Xor bArrayIn(lCurPos)))
  Next lCurPos
  
  CRC32 = lTemp Xor &H35414272
  'Returns CRC value
End Function

Private Sub BuildTable()
  Dim i As Long, x As Long, crc As Long
  Const Limit = &HEDB88320 'usally its shown backward, cant remember what it was.
  'Its the same polynomial that PKZIP uses (I Think)
  For i = 0 To 255
    crc = i
    For x = 0 To 7
      If crc And 1 Then
        crc = (((crc And &HFFFFFFFE) \ 2) And &H7FFFFFFF) Xor Limit
      Else
        crc = ((crc And &HFFFFFFFE) \ 2) And &H7FFFFFFF
      End If
    Next x
    crcTable(i) = crc
  Next i
  CRCTabled = True
End Sub
