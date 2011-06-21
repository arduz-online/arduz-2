Attribute VB_Name = "modZLib"
'ARCHIVO COMPARTIDO.

'                  ____________________________________________
'                 /_____/  http://www.arduz.com.ar/ao/   \_____\
'                //            ____   ____   _    _ _____      \\
'               //       /\   |  __ \|  __ \| |  | |___  /      \\
'              //       /  \  | |__) | |  | | |  | |  / /        \\
'             //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
'            //       / ____ \| | \ \| |__| | |__| |/ /__          \\
'           / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
'           \________________________________________________________/
'           MZEngine DX8             Manejador de archivos de recursos
'           Hecho por Menduz <3
'           TODO:   Pasarlo a C++ para agilizarlo,

Option Explicit
'C:\PC VIEJA\aonuevo\ClienteDX8\Datos\mapas\
Public Type INFOHEADER
    CRC                     As Long
    cript                   As Byte
    lngFileSizeUncompressed As Long

    originalname            As String * 32

    file_type               As Integer
    
    EmpiezaByte             As Long
    
    size_compressed         As Long
    
    Flags                   As Long

    compress                As Byte

    privs                   As Long
    
    PreviousHeader          As Long 'Guarda el puntero a la InfoHeader previa, que se copia al final del archivo antes de parchear
    
    complemento_3           As Integer
    complemento_4           As Integer

    futurei_e1              As Integer
    
    Version                 As Integer
    owner                   As Integer 'Id del creador del archivo.
    
    complemento_1           As Integer 'ID DE EL 1er ITEM COMPLEMENTARIO A LA TEXTURA
    complemento_2           As Integer 'ID DE EL 2do ITEM COMPLEMENTARIO A LA TEXTURA
End Type

Public Enum eTiposRecursos
    rDesconocido = 0
    rPng = 1
    rBmp = 2
    rJpg = 3
    rInit = 4
    rMapData = 5
End Enum

Public Enum e_resource_file
    rMapas = 0
    rGUI = 1
    rGrh = 2
End Enum

#If False Then
Private rDesconocido, rPng, rBmp, rJpg, rInit, rMapData, rMapas, rGUI, rGrh
#End If

Public Const header_s As String * 16 = "MZEngineSyngler§"
Public Const header_m As String * 16 = "MZEngineMapEnti§"
Private Const header_b As String * 16 = "MZEngineBinarir§"

Private Declare Function compress Lib "zlib.dll" _
        (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

Private Declare Function UnCompress Lib "zlib.dll" Alias "uncompress" _
        (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
        (ByRef dest As Any, ByRef Source As Any, ByVal ByteCount As Long)

Private Declare Function CRC32 Lib "MZEngine.dll" Alias "CRC_BA" _
        (ByRef bArray As Byte, ByVal lLen As Long, ByVal lCrc As Long) As Long

Private Declare Sub Xor_Bytes Lib "MZEngine.dll" Alias "Xor_Bytes_BA" _
        (ByRef FirstByte As Byte, ByVal lenght As Long, ByVal code As Byte, ByVal CryptKey As Byte)

Private Declare Sub MDFile Lib "aamd532.dll" _
        (ByVal f As String, ByVal r As String)

Private Declare Sub MDStringFix Lib "aamd532.dll" _
        (ByVal f As String, ByVal t As Long, ByVal r As String)
        
Private Declare Function CreateStreamOnHGlobal Lib "ole32" _
    (ByVal hGlobal As Long, ByVal fDeleteOnRelease As Long, ppstm As Any) As Long
    
Private Declare Function OleLoadPicture Lib "olepro32" _
    (pstream As Any, ByVal lSize As Long, ByVal fRunmode As Long, riid As Any, ppvObj As Any) As Long
    
Private Declare Function CLSIDFromString Lib "ole32" _
    (ByVal lpsz As Any, pclsid As Any) As Long
    
Private Declare Function GlobalAlloc Lib "kernel32" _
    (ByVal uFlags As Long, ByVal dwBytes As Long) As Long
    
Private Declare Function GlobalLock Lib "kernel32" _
    (ByVal hMem As Long) As Long
    
Private Declare Function GlobalUnlock Lib "kernel32" _
    (ByVal hMem As Long) As Long
    
Private Declare Sub MoveMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (pDest As Any, pSource As Any, ByVal dwLength As Long)


Private Const CryptKey      As Byte = 108
Private Const CryptKeyL     As Long = 984362498

Private Path_res            As String
Private Const FN_Mapas      As String = "Mapas.res"
Private Const FN_Grh        As String = "Graficos.res"
Private Const FN_GUI        As String = "Interface.res"

Public last_file_ext        As INFOHEADER
Public Extraidox            As Boolean

Private CabezalInterface()  As INFOHEADER
Private CabezalGraficos()   As INFOHEADER
Private CabezalMapas()      As INFOHEADER

Private UltimoBInterface    As Long
Private UltimoBGraficos     As Long
Private UltimoBMapas        As Long

Private CantidadInterface   As Integer
Private CantidadGraficos    As Integer
Private CantidadMapas       As Integer

Public Const bTRUE         As Byte = 255
Public Const bFALSE        As Byte = 0

Public Const Max_Int_Val   As Integer = 32000 ' (2 ^ 16) / 2 - 1


Public Function PictureFromByteStream(b() As Byte) As IPicture
'código roñosooo!!!!
    Dim LowerBound  As Long
    Dim ByteCount   As Long
    Dim hMem        As Long
    Dim lpMem       As Long
    Dim IID_IPicture(15)
    Dim istm        As stdole.IUnknown

    On Error GoTo Err_Init
    If UBound(b, 1) < 0 Then
        Exit Function
    End If
    
    LowerBound = LBound(b)
    ByteCount = (UBound(b) - LowerBound) + 1
    hMem = GlobalAlloc(&H2, ByteCount)
    If hMem <> 0 Then
        lpMem = GlobalLock(hMem)
        If lpMem <> 0 Then
            MoveMemory ByVal lpMem, b(LowerBound), ByteCount
            Call GlobalUnlock(hMem)
            If CreateStreamOnHGlobal(hMem, 1, istm) = 0 Then
                If CLSIDFromString(StrPtr("{7BF80980-BF32-101A-8BBB-00AA00300CAB}"), IID_IPicture(0)) = 0 Then
                  Call OleLoadPicture(ByVal ObjPtr(istm), ByteCount, 0, IID_IPicture(0), PictureFromByteStream)
                End If
            End If
        End If
    End If
    
    Exit Function
    
Err_Init:
    If ERR.number = 9 Then
        'Uninitialized array
        LogError "PictureFromByteStream->BA empty"
    Else
        LogError "PictureFromByteStream->(" & ERR.number & ") " & ERR.Description
    End If
End Function


Private Sub AddItem2Array1D(ByRef VarArray As Variant, ByVal VarValue As Variant)

Dim i  As Long
Dim iVarType As Integer

    iVarType = VarType(VarArray) - 8192
    i = UBound(VarArray)

    Select Case iVarType

    Case vbInteger, vbLong, vbSingle, vbDouble, vbCurrency, vbDecimal, vbByte

        If VarArray(0) = 0 Then
            i = 0
        Else
            i = i + 1
        End If

    Case vbDate

        If VarArray(0) = "00:00:00" Then
            i = 0
        Else
            i = i + 1
        End If

    Case vbString

        If VarArray(0) = vbNullString Then
            i = 0
        Else
            i = i + 1
        End If

    Case vbBoolean

        If VarArray(0) = False Then
            i = 0
        Else
            i = i + 1
        End If

    Case Else

    End Select

    ReDim Preserve VarArray(i)
    VarArray(i) = VarValue

End Sub

Public Function AllFilesInFolders(ByRef sFolderPath As String, Optional ByRef pattern As String = "*.*") As String()

Dim sTemp As String
Dim sDirIn As String
Dim i As Integer, j As Integer
Dim sFilelist() As String

    ReDim sFilelist(0) As String
Dim slist() As String

    sDirIn = sFolderPath
    'If Not (Right$(sDirIn, 1) = "\") Then sDirIn = sDirIn & "\"
    If Not (Right$(sDirIn, 1) = "\") Then
        sDirIn = sDirIn & "\"
    End If

    On Error Resume Next
        slist = Split(pattern, ";")
        For i = 0 To UBound(slist)
            sTemp = dir$(sDirIn & slist(i))
            Do While LenB(sTemp) <> 0
                'If (Len(sTemp)) Then _
                     AddItem2Array1D sFilelist(), sTemp
                If (Len(sTemp)) Then
                    AddItem2Array1D sFilelist(), sTemp
                End If
                sTemp = dir
            Loop
        Next i
        AllFilesInFolders = sFilelist

    On Error GoTo 0

End Function


'///////////////////////////////////////////////////////////////////////////
'///////////////////////PASAR A C++ PARA GANAR VELOCIDAD!///////////////////
'///////////////////////////////////////////////////////////////////////////

'Private Sub Xor_Bytes(ByRef ByteArray() As Byte, ByVal code As Byte)
'    Dim i As Integer
'    For i = 0 To UBound(ByteArray)
'        ByteArray(i) = code Xor (ByteArray(i) Xor CryptKey)
'    Next
'End Sub
'//Public Declare sub Xor_Bytes Lib "MZEngine.dll" Alias "Xor_Bytes_BA" (ByRef FirstByte As Byte, ByVal Lenght As Long, ByVal code As byte, ByVal CryptKey As byte)

'///////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////


Public Function Bin_Rs_Get_File_Pattern(ByVal rFile_type As e_resource_file) As String

    Select Case rFile_type
    Case e_resource_file.rGrh
        Bin_Rs_Get_File_Pattern = "*.bmp;*.png;*.dds;*.tga;*.mzg"
    Case e_resource_file.rGUI
        Bin_Rs_Get_File_Pattern = "*.jpg;*.jpeg"
    Case e_resource_file.rMapas
        Bin_Rs_Get_File_Pattern = "*.am"
    End Select

End Function

Public Sub Compress_Data(ByRef Data() As Byte)

Dim Dimensions As Long
Dim DimBuffer As Long
Dim BufTemp() As Byte
Dim BufTemp2() As Byte
Dim loopc As Long

    Dimensions = UBound(Data)

    DimBuffer = Dimensions * 1.06
    ReDim BufTemp(DimBuffer)

    compress BufTemp(0), DimBuffer, Data(0), Dimensions

    Erase Data

    ReDim Preserve BufTemp(DimBuffer - 1)

    Data = BufTemp

    Erase BufTemp

    Data(0) = Data(0) Xor CryptKey Xor Data(1)

End Sub

Public Sub Decompress_Data(ByRef Data() As Byte, ByVal OrigSize As Long)

Dim BufTemp() As Byte

    ReDim BufTemp(OrigSize - 1)

    Data(0) = Data(0) Xor CryptKey Xor Data(1)

    UnCompress BufTemp(0), OrigSize, Data(0), UBound(Data) + 1

    ReDim Data(OrigSize - 1)

    Data = BufTemp

    Erase BufTemp

End Sub

Public Function MD5File(f As String) As String

' compute MD5 digest on o given file, returning the result

Dim r As String * 32

    r = Space(32)
    MDFile f, r
    MD5File = r

End Function

Public Function MD5String(p As String) As String

' compute MD5 digest on a given string, returning the result

Dim r As String * 32, t As Long

    r = Space(32)
    t = Len(p)
    MDStringFix p, t, r
    MD5String = r

End Function

Public Sub Resource_Convert(ByRef sourcepath As String, ByRef Path As String, ByRef FileName As String, Optional ByVal arg1 As Integer = 0)

'On Error GoTo errh

Dim handle As Integer
Dim SourceData() As Byte
Dim InfoHead As INFOHEADER
Dim abierto As Byte
Dim tmpcrc As Long
Dim ts As String * 3
Dim freem%
Dim tmpl&

    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(Path, 1) <> "\" Then
        Path = Path & "\"
    End If
    If (dir$(Path & FileName, vbNormal) <> "") Then
        Kill Path & FileName
    End If
    If (dir$(sourcepath, vbNormal) <> "") Then
        Resource_Generate_IH sourcepath, InfoHead, SourceData
        handle = FreeFile
        Open Path & FileName For Binary Access Read Write As handle
        Put handle, , header_s
        Put handle, , InfoHead
        Put handle, , SourceData()
        Close handle
        Debug.Print Path & FileName & " PACKED_OK - C:" & Hex$(InfoHead.CRC) & " - COMP:" & CStr(CBool(InfoHead.compress))
        Erase SourceData()
    Else
        LogError "Error en el archivo de a comprimir """ & FileName & """ - El archivo No existe."
    End If

Exit Sub

errh:
    LogError "Error en el archivo de recursos """ & FileName & """"

End Sub

Public Function Resource_Extract(ByRef Path As String, ByRef FileName As String, ByRef dest As String) As Boolean

'On Error GoTo errh

Dim SourceData() As Byte
Dim handle%

    handle = FreeFile()

    Resource_Get Path, FileName, SourceData

    'If (Dir$(dest, vbNormal) <> "") Then Kill dest
    If (dir$(dest, vbNormal) <> "") Then
        Kill dest
    End If

    If Extraidox = True Then
        Open dest For Binary Access Read Write As handle
        Put handle, , SourceData()
        Close handle
    End If

    Resource_Extract = Extraidox
errh:

End Function

Public Sub Resource_Generate_IH(ByRef FileName As String, ByRef InfoHead As INFOHEADER, ByRef Data() As Byte)

'On Error GoTo errh

Dim handle          As Integer
Dim SourceData()    As Byte
Dim abierto         As Byte
Dim tmpcrc          As Long
Dim ts              As String * 3
Dim freem%
Dim tmpl&
Dim filename1()     As String
Dim name_temp As String

    filename1 = Split(FileName, "\")

    freem = FreeFile()

    If (dir$(FileName, vbNormal) <> "") Then

        Open FileName For Binary Lock Read As freem
        InfoHead.lngFileSizeUncompressed = LOF(freem)
        ReDim SourceData(InfoHead.lngFileSizeUncompressed - 1) As Byte
        Get freem, , SourceData()
        Close freem

        If InfoHead.lngFileSizeUncompressed > 0 Then
            With InfoHead
                .cript = CByte(CInt(Rnd * 125)) + 1
                .originalname = LCase$(filename1(UBound(filename1)))
                name_temp = .originalname
                .originalname = Xor_String(.originalname, .cript)

                ts = LCase$(Right$(FileName, 3))
                Select Case ts
                Case "int", "dat", "ini", "ind", "xml"
                    .file_type = eTiposRecursos.rInit
                    .compress = 1
                Case "inf", "map"
                    .file_type = eTiposRecursos.rMapData
                Case "jpg", "jpeg"
                    .file_type = eTiposRecursos.rJpg
                Case "png", "tga", "dds"
                    .file_type = eTiposRecursos.rPng
                Case "bmp"
                    .file_type = eTiposRecursos.rBmp
                Case Else
                    .file_type = eTiposRecursos.rDesconocido
                End Select

'                If name_temp Like "#.#.*" Then
'                    filename1 = Split(name_temp, ".")
'                    .complemento_1 = val(filename1(LBound(filename1) + 1))
'                    If filename Like "#.#.#.*" Then
'                        .complemento_2 = val(filename1(LBound(filename1) + 2))
'                    End If
'                End If
                filename1 = Split(name_temp, ".")
                
                If UBound(filename1) > 1 Then
                    .complemento_1 = Abs(val(filename1(1))) And &H7FFF
                End If
                If UBound(filename1) > 2 Then
                    .complemento_2 = Abs(val(filename1(2))) And &H7FFF
                End If
                
                'If (.lngFileSizeUncompressed > 1500000) Then .compress = 1
                .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)

                If .compress Then
                    Compress_Data SourceData()
                End If

                .size_compressed = UBound(SourceData)
'                If .size_compressed > 1024 Then
'                    .crc = CRC32(SourceData(0), 1024, 0)
'                Else
'                    .crc = CRC32(SourceData(0), .size_compressed - 1, 0)
'                End If
                Data = SourceData
            End With
        Else
            Debug.Print "ERROR, FILELEN 0"; FileName
        End If
    Else
        LogError "Error en el archivo de a comprimir """ & FileName & """ - El archivo No existe."
    End If

Exit Sub

errh:
    LogError "Error en el archivo de recursos """ & FileName & """"

End Sub

Public Function Resource_Get(ByRef Path As String, ByRef FileName As String, ByRef Data() As Byte) As Boolean

    On Error GoTo errh
Dim handle As Integer
Dim SourceData() As Byte
Dim InfoHead As INFOHEADER
Dim abierto As Byte
Dim tmpcrc As Long
Dim asd As String * 16
Dim tmpl As Long

    handle = FreeFile
    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(Path, 1) <> "\" Then
        Path = Path & "\"
    End If '

    If LenB(dir$(Path & FileName, vbNormal)) Then
        Open Path & FileName For Binary Access Read Lock Write As handle: abierto = bTRUE
        Get handle, , asd

        If StrComp(asd, header_s, vbTextCompare) Then
            'LogError "El archivo : """ & filename & """ no es un archivo de recursos valido."
            GoTo erra
        End If

        Get handle, , InfoHead

        With InfoHead

            Extraidox = False
'            If Left$(LCase$(Xor_String(CStr(.originalname), .cript)), Len(filename)) <> LCase$(filename) Then
'                Debug.Print "Invalid Filename"
'
'#If Debuging = 0 Then
'                LogError "Error en el archivo de recursos Invalid Checksum : """ & filename & """"
'                'If abierto Then Close handle
'                If abierto Then
'                    Close handle
'                End If
'#Else
'                LogError "Error en el archivo de recursos Invalid Checksum : """ & filename & """ [" & Left$(Xor_String(CStr(.originalname), .cript), Len(filename)) & "]-[" & filename & "]"
'#End If
'                GoTo erra
'            End If

            'FINAL, leer datos, descomprimir si esta comprimido
            .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)
            ReDim SourceData(.size_compressed) As Byte

            Get handle, , SourceData()

'            If .size_compressed > 1024 Then
'            '    tmpcrc = CRC32(SourceData(0), 1024, 0)
'            Else
'            '    tmpcrc = CRC32(SourceData(0), .size_compressed - 1, 0)
'            End If

            'If .compress Then Decompress_Data SourceData(), .lngFileSizeUncompressed
            If .compress Then
                Decompress_Data SourceData(), .lngFileSizeUncompressed
            End If

            Data = SourceData
            last_file_ext = InfoHead
'
'                            If tmpcrc <> .crc Then
'                                Debug.Print "Invalid CRC"
'                                LogError "Error en el archivo de recursos Invalid Checksum2 : """ & filename & """ O:" & Hex(tmpcrc) & " E:" & Hex(CLng(.cript)) & " C:" & Hex(.crc)
'
'                                #If Debuging = 0 Then
'                                    If abierto = 1 Then Close handle
'                                    End
'                                #End If
'                                GoTo erra
'                            End If

            Extraidox = True
        End With
        Close handle: abierto = bFALSE
        Resource_Get = True
    Else
        LogError "Error en el archivo de recursos """ & FileName & """ - El archivo no existe."
    End If

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & FileName & """ Err:" & ERR.number & " - Desc : " & ERR.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Public Function Resource_Get_CRC(ByRef Path As String, ByRef FileName As String) As Long

    On Error GoTo errh
Dim handle As Integer
Dim SourceData() As Byte
Dim InfoHead As INFOHEADER
Dim abierto As Byte
Dim tmpcrc As Long
Dim asd As String * 16
Dim tmpl As Long

    handle = FreeFile
    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(Path, 1) <> "\" Then
        Path = Path & "\"
    End If

    If LenB(dir$(Path & FileName, vbNormal)) Then
        Open Path & FileName For Binary Access Read Lock Write As handle
        abierto = 1
        Get handle, , asd

        If StrComp(asd, header_s, vbTextCompare) Then
            LogError "El archivo : """ & FileName & """ no es un archivo de recursos valido."
            GoTo erra
        End If

        Get handle, , InfoHead

        With InfoHead

            Extraidox = False
            If Left$(UCase$(Xor_String(CStr(.originalname), .cript)), Len(FileName)) <> UCase$(FileName) Then
                Debug.Print "Invalid Filename"
                LogError "Error en el archivo de recursos Invalid Checksum : """ & FileName & """ [" & Left$(Xor_String(CStr(.originalname), .cript), Len(FileName)) & "]-[" & FileName & "]"
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
                tmpcrc = CRC32(SourceData(0), 1024, 0)
            Else
                tmpcrc = CRC32(SourceData(0), .size_compressed - 1, 0)
            End If

            Resource_Get_CRC = tmpcrc
        End With
        Close handle
        Resource_Get_CRC = 0
    Else
        LogError "Error en el archivo de recursos """ & FileName & """ - El archivo no existe."
    End If

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & FileName & """ Err:" & ERR.number & " - Desc : " & ERR.Description
erra:
    'If abierto = 1 Then Close handle
    If abierto = 1 Then
        Close handle
    End If
    Resource_Get_CRC = 0

End Function

Public Function Resource_Get_Raw(ByRef Path As String, ByRef FileName As String) As String

Dim SourceData() As Byte

    Resource_Get Path, FileName, SourceData

    If Extraidox = True Then
        Resource_Get_Raw = StrConv(SourceData, vbUnicode)
    Else
        Resource_Get_Raw = vbNullString
    End If
errh:

End Function
'
'Public Function Resource_Read_sdf(ByRef Path As String, ByRef FileName As String) As String
''On Error GoTo errh
'    Dim handle As Integer
'    Dim Jo As String
'    Dim abierto As Byte
'    Dim tmpcrc As Byte
'    Dim asd As String * 16
'    Dim tmpl As Long
'    Dim tmpla As Long
'    Dim bytes() As Byte
'    Dim i As Integer
'    Dim tr As String
'
'    handle = FreeFile
'
'    If Right$(Path, 1) <> "\" Then Path = Path & "\"
'
'    If LenB(dir$(Path & FileName, vbNormal)) Then
'        Open Path & FileName For Binary Access Read Lock Write As handle
'            Get handle, , asd
'            Get handle, , tmpcrc
'            Get handle, , tmpl
'            Get handle, , tmpla
'            ReDim bytes(tmpl)
'            Get handle, , bytes
'        Close handle
'
'        If StrComp(asd, header_s, vbTextCompare) Then
'            #If IsServer = 0 Then
'            LogError "El archivo : """ & FileName & """ no es un archivo valido."
'            #End If
'            GoTo errh
'        Else
'            tr = StrConv(bytes, vbUnicode)
'            tr = Xor_String(tr, tmpcrc)
'            If CRC16(CLng(tmpcrc), tr) = tmpla / CLng(tmpcrc) Then
'                Resource_Read_sdf = tr
'            Else
'                LogError "Se borró el archivo de recursos " & FileName
'                Kill Path & FileName
'                Resource_Read_sdf = vbNullString
'            End If
'        End If
'    End If
'
'Exit Function
'errh:
'LogError "Error en el archivo de recursos """ & FileName & """ Err:" & ERR.number & " - Desc : " & ERR.Description
'End Function
'
'Public Sub Resource_Create_sdf(ByRef datos As String, ByRef Path As String, ByRef FileName As String)
'    Dim handle As Integer
'    Dim tmpcrc As Byte
'
'    Dim Jo As String
'    Dim tmpl As Long
'    Dim tmpla As Long
'    Dim bytes() As Byte
'
'    Dim Data As String
'
'    Data = datos
'
'    Dim i As Long
'
'    bytes = StrConv(Data, vbFromUnicode)
'    tmpcrc = CByte(CInt(Rnd * 200)) + 50
'    tmpl = UBound(bytes)
'    tmpla = CRC16(CLng(tmpcrc), Data) * CLng(tmpcrc)
'
'    Data = Xor_String(Data, tmpcrc)
'    bytes = StrConv(Data, vbFromUnicode)
'
'    If Right$(Path, 1) <> "\" Then Path = Path & "\"
'
'    If FileExist(Path & FileName, vbNormal) Then Kill Path & FileName
'    DoEvents
'
'    handle = FreeFile
'
'    Open Path & FileName For Binary Access Write As handle
'        Put handle, , header_s
'        Put handle, , tmpcrc
'        Put handle, , tmpl
'        Put handle, , tmpla
'        Put handle, , bytes
'    Close handle
'End Sub

Public Function Xor_String(ByVal t As String, ByVal code As Byte) As String

Dim bytes() As Byte
bytes = StrConv(t, vbFromUnicode)
    Call Xor_Bytes(bytes(0), Len(t), code, CryptKey)
    Xor_String = StrConv(bytes, vbUnicode)

End Function


Public Function Resource_Read_CFG_LNG(ByRef FileName As String, ByVal cual_cfg As Long) As Long
    Dim handle As Integer
    Dim asd As String * 16
    Dim tmpl As Long
    Dim reade As Long
    
    If LenB(dir$(FileName, vbNormal)) Then
        reade = 17 + (4 * cual_cfg)
        handle = FreeFile
        Open FileName For Binary Access Read Lock Write As handle
            Get handle, , asd
            Get handle, reade, tmpl
            If tmpl <> 0 Then
                Resource_Read_CFG_LNG = (tmpl Xor &HCD6B5CBD)
            Else
                Resource_Read_CFG_LNG = 0
            End If
        Close handle
    End If
End Function

Public Sub Resource_WRITE_CFG_LNG(ByRef FileName As String, ByVal cual_cfg As Long, ByVal value As Long)
    Dim handle As Integer
    Dim tmpl As Long
    Dim reade As Long
    
    reade = 17 + (4 * cual_cfg)
    handle = FreeFile
    
    If value = 0 Then
        tmpl = 0
    Else
        tmpl = value Xor &HCD6B5CBD
    End If
    
    If LenB(dir$(FileName, vbNormal)) Then
        Open FileName For Binary Access Read Write As handle
            Put handle, reade, tmpl
        Close handle
    Else
        Open FileName For Binary Access Read Write As handle
            Put handle, , header_s
            Put handle, reade, tmpl
        Close handle
    End If
End Sub

Private Function CRC16(ByVal Key As Long, ByVal Data As String) As Integer
'**************************************************************
'Author: Salvito
'Last Modify Date: 2/07/2007
'Computes a custom CRC16 designed by Alejandro Salvo
'**************************************************************
    Dim i As Long
    Dim vstr() As Byte
    Dim SumaEspecialDeCaracteres As Long
    
    vstr = StrConv(Data, vbFromUnicode)
    
    For i = 0 To Len(Data) - 1
        SumaEspecialDeCaracteres = SumaEspecialDeCaracteres + vstr(i) * (1 + Key - i)
    Next i
    
    CRC16 = CInt(Abs(SumaEspecialDeCaracteres) Mod 32000)
End Function


Public Function clsPak_LeerIPicture(ByRef obj As clsPak, ByVal nro As Integer) As IPicture
If Not obj Is Nothing Then
    On Error GoTo errh
    
    Dim SourceData()    As Byte
    Dim LowerBound      As Long
    Dim ByteCount       As Long
    Dim hMem            As Long
    Dim lpMem           As Long
    Dim istm            As stdole.IUnknown
    Dim IID_IPicture(15) ' no sabe no contesta
    
        If obj.Leer(nro, SourceData) Then
            LowerBound = LBound(SourceData)
            ByteCount = (UBound(SourceData) - LowerBound) + 1
            hMem = GlobalAlloc(&H2, ByteCount)
            If hMem <> 0 Then
                lpMem = GlobalLock(hMem)
                If lpMem <> 0 Then
                    MoveMemory ByVal lpMem, SourceData(LowerBound), ByteCount
                    Call GlobalUnlock(hMem)
                    If CreateStreamOnHGlobal(hMem, 1, istm) = 0 Then
                        If CLSIDFromString(StrPtr("{7BF80980-BF32-101A-8BBB-00AA00300CAB}"), IID_IPicture(0)) = 0 Then
                          Call OleLoadPicture(ByVal ObjPtr(istm), ByteCount, 0, IID_IPicture(0), clsPak_LeerIPicture)
                        End If
                    End If
                End If
                
            End If
        End If
        Exit Function
    
errh:
        If ERR.number = 9 Then
            LogError "LeerIPicture->BA empty"
        Else
            LogError "LeerIPicture->(" & ERR.number & ") " & ERR.Description
        End If
End If
End Function



