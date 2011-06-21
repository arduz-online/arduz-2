Attribute VB_Name = "modZLib"
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
'           Hecho por Menduz (L
'           TODO:   Pasarlo a C++ para agilizarlo,
'                   ya que vb es una mierda lenta

Option Explicit
'C:\PC VIEJA\aonuevo\ClienteDX8\Datos\mapas\
Public Type INFOHEADER
    crc                     As Long
    cript                   As Byte
    lngFileSizeUncompressed As Long

    originalname            As String * 32

    file_type               As Integer

    compress                As Byte

    size_compressed         As Long
    Flags                   As Long

    EmpiezaByte             As Long

    future_expansion3       As Long
    future_expansion4       As Long
    future_expansion5       As Long

    futurei_e1              As Integer
    futurei_e2              As Integer
    futurei_e3              As Integer
    futurei_e4              As Integer
    futurei_e5              As Integer
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

Private Const header_s As String * 16 = "MZEngineSingleR§"
Private Const header_b As String * 16 = "MZEngineBinaryR§"

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
        (ByVal f As String, ByVal R As String)

Private Declare Sub MDStringFix Lib "aamd532.dll" _
        (ByVal f As String, ByVal t As Long, ByVal R As String)
        
Private Declare Function CreateStreamOnHGlobal Lib "ole32" _
    (ByVal hGlobal As Long, ByVal fDeleteOnRelease As Long, ppstm As Any) As Long
    
Private Declare Function OleLoadPicture Lib "olepro32" _
    (pstream As Any, ByVal lSize As Long, ByVal fRunmode As Long, riid As Any, ppvObj As Any) As Long
    
Private Declare Function CLSIDFromString Lib "ole32" _
    (ByVal lpsz As Any, pclsid As Any) As Long
    
Private Declare Function GlobalAlloc Lib "kernel32" _
    (ByVal uFlags As Long, ByVal dwBytes As Long) As Long
    
Private Declare Function GlobalLock Lib "kernel32" _
    (ByVal hmem As Long) As Long
    
Private Declare Function GlobalUnlock Lib "kernel32" _
    (ByVal hmem As Long) As Long
    
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

Private Const bTRUE         As Byte = 255
Private Const bFALSE        As Byte = 0

Private Const Min_Offset    As Integer = 500 ' El "cacho" de slots libres del array para agregar archivos
Private Const Max_Int_Val   As Integer = 32767 ' (2 ^ 16) / 2 - 1


Public Function PictureFromByteStream(b() As Byte) As IPicture
'código roñosooo!!!!
    Dim LowerBound  As Long
    Dim ByteCount   As Long
    Dim hmem        As Long
    Dim lpMem       As Long
    Dim IID_IPicture(15)
    Dim istm        As stdole.IUnknown

    On Error GoTo Err_Init
    If UBound(b, 1) < 0 Then
        Exit Function
    End If
    
    LowerBound = LBound(b)
    ByteCount = (UBound(b) - LowerBound) + 1
    hmem = GlobalAlloc(&H2, ByteCount)
    If hmem <> 0 Then
        lpMem = GlobalLock(hmem)
        If lpMem <> 0 Then
            MoveMemory ByVal lpMem, b(LowerBound), ByteCount
            Call GlobalUnlock(hmem)
            If CreateStreamOnHGlobal(hmem, 1, istm) = 0 Then
                If CLSIDFromString(StrPtr("{7BF80980-BF32-101A-8BBB-00AA00300CAB}"), IID_IPicture(0)) = 0 Then
                  Call OleLoadPicture(ByVal ObjPtr(istm), ByteCount, 0, IID_IPicture(0), PictureFromByteStream)
                End If
            End If
        End If
    End If
    
    Exit Function
    
Err_Init:
    If ERR.Number = 9 Then
        'Uninitialized array
        LogError "PictureFromByteStream->BA empty"
    Else
        LogError "PictureFromByteStream->(" & ERR.Number & ") " & ERR.Description
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

Private Function AllFilesInFolders(ByRef sFolderPath As String, Optional ByRef pattern As String = "*.*") As String()

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

Public Function Bin_Create_From_Folder(ByVal rFile_type As e_resource_file, ByRef folder As String, ByRef output_folder As String) As Boolean

'On Error GoTo errh

Dim handle          As Integer

Dim abierto         As Byte

Dim Nueva_Cantidad  As Integer
Dim Ultimo_Byte     As Long
Dim cabezal()       As INFOHEADER
Dim InfoHead        As INFOHEADER
Dim cabezal_ptr     As Integer

Dim SourceData()    As Byte
Dim File_List()     As String

Dim i               As Integer
Dim cantidad_array  As Integer

Dim max_cantidad    As Integer
Dim tmpint          As Integer

Dim tmplng          As Long
Dim int_list()      As Integer

Dim handleB         As Integer
Dim filename        As String

Dim new_file        As String
Dim asd             As String * 16
Dim necesita_hacer  As Byte
Dim tmpbn As Double
    File_List = AllFilesInFolders(folder, Bin_Rs_Get_File_Pattern(rFile_type))

    cantidad_array = UBound(File_List)
    ReDim int_list(cantidad_array)

    For i = 0 To cantidad_array
    tmpbn = val(Split(File_List(i), ".", 2)(0))
        If tmpbn <= Max_Int_Val Then
        tmpint = tmpbn

        'If max_cantidad < tmpint Then max_cantidad = tmpint
        If max_cantidad < tmpint Then
            max_cantidad = tmpint
        End If
        int_list(i) = tmpint
        End If
    Next i

    tmplng = max_cantidad + Min_Offset
    'If tmplng > Max_Int_Val Then tmplng = Max_Int_Val
    If tmplng > Max_Int_Val Then
        tmplng = Max_Int_Val
    End If
    Nueva_Cantidad = tmplng

    ReDim cabezal(Nueva_Cantidad)

    'If Len(output_folder) = 0 Then output_folder = App.path
    If Len(output_folder) = 0 Then
        output_folder = app.path
    End If
    'If Right$(output_folder, 1) <> "\" Then output_folder = output_folder & "\"
    If Right$(output_folder, 1) <> "\" Then
        output_folder = output_folder & "\"
    End If
    
    Select Case rFile_type
    Case e_resource_file.rGUI
        filename = output_folder & FN_GUI
    Case e_resource_file.rGrh
        filename = output_folder & FN_Grh
    Case e_resource_file.rMapas
        filename = output_folder & FN_Mapas
    End Select

    'If (Dir$(filename, vbNormal) <> "") Then Kill filename
    If (dir$(filename, vbNormal) <> "") Then
        Kill filename
    End If
    handleB = FreeFile()
    Open filename For Binary Access Read Write As handleB
    Seek handleB, 1

    Ultimo_Byte = 0
    Put handleB, , header_b
    Put handleB, , Nueva_Cantidad
    Put handleB, , Ultimo_Byte
    Put handleB, , cabezal

    For i = 0 To cantidad_array
        If int_list(i) > 0 Then
            new_file = folder & File_List(i)
            handle = FreeFile()
            Open new_file For Binary Access Read Lock Write As handle: abierto = bTRUE
            Get handle, , asd
            If StrComp(asd, header_s, vbTextCompare) Then
                necesita_hacer = bTRUE
            Else
                Get handle, , InfoHead

                InfoHead.lngFileSizeUncompressed = (InfoHead.lngFileSizeUncompressed Xor CryptKeyL Xor InfoHead.cript)
                ReDim SourceData(InfoHead.size_compressed) As Byte

                Get handle, , SourceData()

                If InfoHead.size_compressed > 1024 Then
                    InfoHead.crc = CRC32(SourceData(0), 1024, 0)
                Else
                    InfoHead.crc = CRC32(SourceData(0), InfoHead.size_compressed - 1, 0)
                End If
            End If
            Close handle: abierto = bFALSE

            If necesita_hacer Then
                Resource_Generate_IH new_file, InfoHead, SourceData
            End If

            InfoHead.EmpiezaByte = Seek(handleB)

            cabezal(int_list(i)) = InfoHead

            Put handleB, , SourceData
            Ultimo_Byte = Ultimo_Byte + InfoHead.size_compressed
            '#If CRIPTER Then
            Debug.Print "Push ("; int_list(i); ") - "; File_List(i); " - CRC:"; Hex(InfoHead.crc); InfoHead.size_compressed; "- ptr:"; Hex$(Ultimo_Byte)
            '#End If
        End If
    Next i

    Seek handleB, 1

    Put handleB, , header_b
    Put handleB, , Nueva_Cantidad
    Put handleB, , Ultimo_Byte
    Put handleB, , cabezal
    Close handleB

    Bin_Create_From_Folder = True

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

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

Public Sub Bin_Load_Headers(ByVal path As String)

Dim cantidad    As Integer
Dim handle      As Integer
Dim t_str       As String * 16
Dim abierto     As Byte
Dim filename    As String

    Path_res = path
    handle = FreeFile()
    filename = Path_res & FN_GUI
    Open filename For Binary As handle: abierto = bTRUE
    Get handle, 1, t_str
    'If StrComp(t_str, header_b, vbTextCompare) Then GoTo erra
    If StrComp(t_str, header_b, vbTextCompare) Then
        GoTo erra
    End If

    Get handle, , CantidadInterface
    Get handle, , UltimoBInterface

    ReDim CabezalInterface(CantidadInterface)

    Get handle, , CabezalInterface 'Get handle, UltimoBInterface, CabezalInterface
    Close handle: abierto = bFALSE

    handle = FreeFile()
    filename = Path_res & FN_Mapas
    Open filename For Binary As handle: abierto = bTRUE
    Get handle, 1, t_str
    'If StrComp(t_str, header_b, vbTextCompare) Then GoTo erra
    If StrComp(t_str, header_b, vbTextCompare) Then
        GoTo erra
    End If

    Get handle, , CantidadMapas
    Get handle, , UltimoBMapas

    ReDim CabezalMapas(CantidadMapas)

    Get handle, , CabezalMapas 'Get handle, UltimoBMapas, CabezalMapas
    Close handle: abierto = bFALSE

    handle = FreeFile()
    filename = Path_res & FN_Grh
    Open filename For Binary As handle: abierto = bTRUE
    Get handle, 1, t_str
    'If StrComp(t_str, header_b, vbTextCompare) Then GoTo erra
    If StrComp(t_str, header_b, vbTextCompare) Then
        GoTo erra
    End If

    Get handle, , CantidadGraficos
    Get handle, , UltimoBGraficos

    ReDim CabezalGraficos(CantidadGraficos)

    Get handle, , CabezalGraficos 'Get handle, UltimoBGraficos, CabezalGraficos
    Close handle: abierto = bFALSE

Exit Sub

erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If
    LogError "El archivo : """ & filename & """ no es un archivo de recursos valido."
    'End

End Sub

Public Function Bin_Resource_Add_To_Listbox(ByVal rFile_type As e_resource_file, ByRef List As ListBox) As Boolean
On Error Resume Next
Dim InfoHead    As INFOHEADER
Dim abierto     As Byte
Dim i           As Integer

    List.Clear
    Select Case rFile_type
    Case e_resource_file.rGUI
        For i = 0 To CantidadInterface
            InfoHead = CabezalInterface(i)
            'If InfoHead.size_compressed Then _
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript)))
            If InfoHead.size_compressed Then
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript))) & " - CRC:" & Hex$(InfoHead.crc) & " - " & Round(InfoHead.size_compressed / 1024, 1) & "KB"
            End If
        Next i
    Case e_resource_file.rGrh
        For i = 0 To CantidadGraficos
            InfoHead = CabezalGraficos(i)
            'If InfoHead.size_compressed Then _
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript)))
            If InfoHead.size_compressed Then
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript))) & " - CRC:" & Hex$(InfoHead.crc) & " - " & Round(InfoHead.size_compressed / 1024, 1) & "KB"
            End If
        Next i
    Case e_resource_file.rMapas
        For i = 0 To CantidadMapas
            InfoHead = CabezalMapas(i)
            'If InfoHead.size_compressed Then _
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript)))
            If InfoHead.size_compressed Then
                List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript))) & " - CRC:" & Hex$(InfoHead.crc) & " - " & Round(InfoHead.size_compressed / 1024, 1) & "KB"
            End If
        Next i
    End Select

End Function

Public Function Bin_Resource_Extract(ByRef nro As Integer, ByVal rFile_type As e_resource_file, ByRef dest As String) As Boolean

'On Error GoTo errh

Dim SourceData() As Byte
Dim handle%

    handle = FreeFile()

    'If (Dir$(dest, vbNormal) <> "") Then Kill dest
    If (dir$(dest, vbNormal) <> "") Then
        Kill dest
    End If

    If Bin_Resource_Get(nro, SourceData, rFile_type) Then
        Open dest For Binary Access Read Write As handle
        Put handle, , SourceData()
        Close handle
        Bin_Resource_Extract = True
    End If

errh:

End Function

Public Function Bin_Resource_Load_Picture(ByRef nro As Integer, ByVal rFile_type As e_resource_file) As IPicture

On Error GoTo errh

Dim SourceData()    As Byte
Dim LowerBound      As Long
Dim ByteCount       As Long
Dim hmem            As Long
Dim lpMem           As Long
Dim istm            As stdole.IUnknown
Dim IID_IPicture(15) ' no sabe no contesta

    If Bin_Resource_Get(nro, SourceData, rFile_type) Then
        LowerBound = LBound(SourceData)
        ByteCount = (UBound(SourceData) - LowerBound) + 1
        hmem = GlobalAlloc(&H2, ByteCount)
        If hmem <> 0 Then
            lpMem = GlobalLock(hmem)
            If lpMem <> 0 Then
                MoveMemory ByVal lpMem, SourceData(LowerBound), ByteCount
                Call GlobalUnlock(hmem)
                If CreateStreamOnHGlobal(hmem, 1, istm) = 0 Then
                    If CLSIDFromString(StrPtr("{7BF80980-BF32-101A-8BBB-00AA00300CAB}"), IID_IPicture(0)) = 0 Then
                      Call OleLoadPicture(ByVal ObjPtr(istm), ByteCount, 0, IID_IPicture(0), Bin_Resource_Load_Picture)
                    End If
                End If
            End If
        End If
    End If
    Exit Function

errh:
    If ERR.Number = 9 Then
        LogError "Bin_Resource_Load_Picture->BA empty"
    Else
        LogError "Bin_Resource_Load_Picture->(" & ERR.Number & ") " & ERR.Description
    End If

End Function

Public Function Bin_Resource_Get(ByRef nFile As Integer, ByRef data() As Byte, ByVal rFile_type As e_resource_file) As Boolean
On Error GoTo errh

Dim handle As Integer
Dim SourceData() As Byte
Dim InfoHead As INFOHEADER
Dim abierto As Byte
Dim filename As String

    Select Case rFile_type
    Case e_resource_file.rGUI
        filename = Path_res & FN_GUI
        If CantidadInterface >= nFile Then
            InfoHead = CabezalInterface(nFile)
        Else
            Bin_Resource_Get = False
            Exit Function
        End If
    Case e_resource_file.rGrh
        filename = Path_res & FN_Grh
        If CantidadGraficos >= nFile Then
            InfoHead = CabezalGraficos(nFile)
        Else
            Bin_Resource_Get = False
            Exit Function
        End If
    Case e_resource_file.rMapas
        filename = Path_res & FN_Mapas
        If CantidadMapas >= nFile Then
            InfoHead = CabezalMapas(nFile)
        Else
            Bin_Resource_Get = False
            Exit Function
        End If
    End Select

    Extraidox = False

    handle = FreeFile()
    
#If esCLIENTE = 1 Then
    If InfoHead.EmpiezaByte = 0 Then
        LogError nFile & " NO ESTA EN ENPAQEUTADO " & rFile_type
    Else
        If rFile_type = e_resource_file.rMapas Then
            Call Engine_FIFO.map_load_from(filename, InfoHead.EmpiezaByte, nFile) 'Cargamos el mapa desde el archivo binario, nos ahorramos un par de accesos al puto disco ;)
        Else
        
            Open filename For Binary Access Read Lock Write As handle: abierto = bTRUE
                Seek handle, InfoHead.EmpiezaByte ' movemos el puntero de handle a EmpiezaByte
                InfoHead.lngFileSizeUncompressed = (InfoHead.lngFileSizeUncompressed Xor CryptKeyL Xor InfoHead.cript)
                ReDim SourceData(InfoHead.size_compressed) As Byte
                Get handle, , SourceData()
                'If InfoHead.compress = 1 Then Decompress_Data SourceData(), InfoHead.lngFileSizeUncompressed
                If InfoHead.compress = 1 Then
                    Decompress_Data SourceData(), InfoHead.lngFileSizeUncompressed
                End If
                data = SourceData
            Close handle: abierto = bFALSE
        End If
    End If
#Else
    Open filename For Binary Access Read Lock Write As handle: abierto = bTRUE
        Seek handle, InfoHead.EmpiezaByte ' movemos el puntero de handle a EmpiezaByte
        InfoHead.lngFileSizeUncompressed = (InfoHead.lngFileSizeUncompressed Xor CryptKeyL Xor InfoHead.cript)
        ReDim SourceData(InfoHead.size_compressed) As Byte
        Get handle, , SourceData()
        'If InfoHead.compress = 1 Then Decompress_Data SourceData(), InfoHead.lngFileSizeUncompressed
        If InfoHead.compress = 1 Then
            Decompress_Data SourceData(), InfoHead.lngFileSizeUncompressed
        End If
        data = SourceData
    Close handle: abierto = bFALSE
#End If

    last_file_ext = InfoHead
    Bin_Resource_Get = True

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Public Function Bin_Resource_Get_crc(ByRef nFile As Integer, ByVal rFile_type As e_resource_file) As Long

' esta func se puede usar para el parcheo
' return 0 cuando es invalido o error

    On Error Resume Next
        Bin_Resource_Get_crc = &H0
        Select Case rFile_type
        Case e_resource_file.rGUI
            'If UBound(CabezalInterface) >= nFile Then _
                       Bin_Resource_Get_crc = CabezalInterface(nFile).crc
            If UBound(CabezalInterface) >= nFile Then
                Bin_Resource_Get_crc = CabezalInterface(nFile).crc
            End If
        Case e_resource_file.rGrh
            'If UBound(CabezalGraficos) >= nFile Then _
                       Bin_Resource_Get_crc = CabezalGraficos(nFile).crc
            If UBound(CabezalGraficos) >= nFile Then
                Bin_Resource_Get_crc = CabezalGraficos(nFile).crc
            End If
        Case e_resource_file.rMapas
            'If UBound(CabezalMapas) >= nFile Then _
                       Bin_Resource_Get_crc = CabezalMapas(nFile).crc
            If UBound(CabezalMapas) >= nFile Then
                Bin_Resource_Get_crc = CabezalMapas(nFile).crc
            End If
        End Select

End Function

Public Function Bin_Resource_Get_Raw(ByRef nFile As Integer, ByVal rFile_type As e_resource_file) As String

Dim SourceData() As Byte

    If Bin_Resource_Get(nFile, SourceData, rFile_type) Then
        Bin_Resource_Get_Raw = StrConv(SourceData, vbUnicode)
    Else
        Bin_Resource_Get_Raw = vbNullString
    End If

End Function

Public Function Bin_Resource_Patch(ByRef nFile As Integer, ByRef new_file As String, ByVal rFile_type As e_resource_file) As Boolean

'On Error GoTo errh

Dim handle          As Integer

Dim InfoHead        As INFOHEADER
Dim abierto         As Byte
Dim file_len        As Long

Dim Resize_Header   As Byte
Dim tmp_s           As String * 16
Dim tmpcrc          As Long
Dim necesita_hacer  As Byte
Dim Ultimo_Byte     As Long

Dim es_igual_viejo  As Byte

Dim SourceData()    As Byte

Dim Nueva_Cantidad  As Integer

Dim filename        As String
Dim fhp             As Long

'    Resize_Header = bFALSE
'    necesita_hacer = bFALSE
'    es_igual_viejo = bFALSE

    file_len = FileLen(new_file)

    'If Not LenB(Dir$(path & filename, vbNormal)) Then GoTo errh
    'If LenB(Dir$(new_file, vbNormal)) Then
    '    GoTo errh
    'End If

    handle = FreeFile

    Open new_file For Binary Access Read Lock Write As handle: abierto = bTRUE
    Get handle, , tmp_s
    If StrComp(tmp_s, header_s, vbTextCompare) Then ' StrComp es MUCHO más rápido que If Str1 = Str2 Then
        necesita_hacer = bTRUE
    Else
        Get handle, , InfoHead

        InfoHead.lngFileSizeUncompressed = (InfoHead.lngFileSizeUncompressed Xor CryptKeyL Xor InfoHead.cript)
        ReDim SourceData(InfoHead.size_compressed) As Byte

        Get handle, , SourceData()

        If InfoHead.size_compressed > 1024 Then
            InfoHead.crc = CRC32(SourceData(0), 1024, 0)
        Else
            InfoHead.crc = CRC32(SourceData(0), InfoHead.size_compressed - 1, 0)
        End If
    End If
    Close handle: abierto = bFALSE

    If necesita_hacer Then
        Resource_Generate_IH new_file, InfoHead, SourceData
    End If
    
If InfoHead.size_compressed = 0 Then
MsgBox "Error al parchear."
End If

    Select Case rFile_type
    Case e_resource_file.rGUI
        filename = Path_res & FN_GUI
        If CantidadInterface < nFile Then
            ReDim Preserve CabezalInterface(nFile)
            Resize_Header = bTRUE
            Nueva_Cantidad = CantidadInterface + 1
        Else
            'es_igual_viejo = CabezalInterface(nFile).crc = InfoHead.crc
            Nueva_Cantidad = CantidadInterface
        End If
        InfoHead.EmpiezaByte = UltimoBInterface + 2
        CabezalInterface(nFile) = InfoHead
        
        Ultimo_Byte = InfoHead.EmpiezaByte + InfoHead.size_compressed
        UltimoBInterface = Ultimo_Byte
        
        
    Case e_resource_file.rGrh
        filename = Path_res & FN_Grh
        If CantidadGraficos < nFile Then
            ReDim Preserve CabezalGraficos(nFile)
            Resize_Header = bTRUE
            Nueva_Cantidad = CantidadGraficos + 1
        Else
            'es_igual_viejo = CabezalGraficos(nFile).crc = InfoHead.crc
            Nueva_Cantidad = CantidadGraficos
        End If
        
        InfoHead.EmpiezaByte = UltimoBGraficos + 2
        CabezalGraficos(nFile) = InfoHead
        
        Ultimo_Byte = InfoHead.EmpiezaByte + InfoHead.size_compressed
        UltimoBGraficos = Ultimo_Byte
        
        
    Case e_resource_file.rMapas
        filename = Path_res & FN_Mapas
        If CantidadMapas < nFile Then
            ReDim Preserve CabezalMapas(nFile)
            Resize_Header = bTRUE
            Nueva_Cantidad = CantidadMapas + 1
        Else
            'es_igual_viejo = CabezalMapas(nFile).crc = InfoHead.crc
            Nueva_Cantidad = CantidadMapas
        End If
        
        InfoHead.EmpiezaByte = UltimoBMapas + 2
        CabezalMapas(nFile) = InfoHead

        Ultimo_Byte = InfoHead.EmpiezaByte + InfoHead.size_compressed
        UltimoBMapas = Ultimo_Byte
    End Select
    
    If es_igual_viejo Then
        Bin_Resource_Patch = True
        Exit Function
    End If
    
    handle = FreeFile()
    Open filename For Binary Access Read Write As handle: abierto = bTRUE
'        Seek handle, 1              ' movemos el puntero de handle a UltimoBMapas
'
'        Put handle, , header_b
'        Put handle, , Nueva_Cantidad
'        Put handle, , Ultimo_Byte
'        fhp = Seek(handle) + CLng(nFile) * Len(InfoHead) ' muejeje
'        Put handle, fhp, InfoHead
'        Put handle, InfoHead.EmpiezaByte, SourceData



        Seek handle, LOF(handle) + 1
        InfoHead.EmpiezaByte = Seek(handle)
        Put handle, , SourceData
        Ultimo_Byte = Seek(handle)
        
        Seek handle, 1
        Put handle, , header_b
        Put handle, , Nueva_Cantidad
        Put handle, , Ultimo_Byte
        fhp = Seek(handle) + CLng(nFile) * Len(InfoHead) ' muejeje
        Put handle, fhp, InfoHead


        'Seek handle,  CLng(Ultimo_Byte - InfoHead.size_compressed)' movemos el puntero de handle a UltimoBMapas
        'Put handle, InfoHead.EmpiezaByte, SourceData
    
        Bin_Resource_Patch = True

    Close handle: abierto = bFALSE
Debug.Print "OK"; fhp; InfoHead.EmpiezaByte
Exit Function

errh:
    LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

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

Public Function MD5File(f As String) As String

' compute MD5 digest on o given file, returning the result

Dim R As String * 32

    R = Space(32)
    MDFile f, R
    MD5File = R

End Function

Public Function MD5String(p As String) As String

' compute MD5 digest on a given string, returning the result

Dim R As String * 32, t As Long

    R = Space(32)
    t = Len(p)
    MDStringFix p, t, R
    MD5String = R

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

    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(path, 1) <> "\" Then
        path = path & "\"
    End If
    If (dir$(path & filename, vbNormal) <> "") Then
        Kill path & filename
    End If
    If (dir$(sourcepath, vbNormal) <> "") Then
        Resource_Generate_IH sourcepath, InfoHead, SourceData
        handle = FreeFile
        Open path & filename For Binary Access Read Write As handle
        Put handle, , header_s
        Put handle, , InfoHead
        Put handle, , SourceData()
        Close handle
        Debug.Print path & filename & " PACKED_OK - C:" & Hex$(InfoHead.crc) & " - COMP:" & CStr(CBool(InfoHead.compress))
        Erase SourceData()
    Else
        LogError "Error en el archivo de a comprimir """ & filename & """ - El archivo No existe."
    End If

Exit Sub

errh:
    LogError "Error en el archivo de recursos """ & filename & """"

End Sub

Public Function Resource_Extract(ByRef path As String, ByRef filename As String, ByRef dest As String) As Boolean

'On Error GoTo errh

Dim SourceData() As Byte
Dim handle%

    handle = FreeFile()

    Resource_Get path, filename, SourceData

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

Private Sub Resource_Generate_IH(ByRef filename As String, ByRef InfoHead As INFOHEADER, ByRef data() As Byte)

'On Error GoTo errh

Dim handle          As Integer
Dim SourceData()    As Byte
Dim abierto         As Byte
Dim tmpcrc          As Long
Dim ts              As String * 3
Dim freem%
Dim tmpl&
Dim filename1()     As String

    filename1 = Split(filename, "\")

    freem = FreeFile()

    If (dir$(filename, vbNormal) <> "") Then

        Open filename For Binary Lock Read As freem
        InfoHead.lngFileSizeUncompressed = LOF(freem)
        ReDim SourceData(InfoHead.lngFileSizeUncompressed - 1) As Byte
        Get freem, , SourceData()
        Close freem

        If InfoHead.lngFileSizeUncompressed > 0 Then
            With InfoHead
                .cript = CByte(CInt(Rnd * 125)) + 1
                .originalname = LCase$(filename1(UBound(filename1)))
                .originalname = Xor_String(.originalname, .cript)

                ts = LCase$(Right$(filename, 3))
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
                'If (.lngFileSizeUncompressed > 1500000) Then .compress = 1
                .lngFileSizeUncompressed = (.lngFileSizeUncompressed Xor CryptKeyL Xor .cript)

                If .compress Then
                    Compress_Data SourceData()
                End If

                .size_compressed = UBound(SourceData)
                If .size_compressed > 1024 Then
                    .crc = CRC32(SourceData(0), 1024, 0)
                Else
                    .crc = CRC32(SourceData(0), .size_compressed - 1, 0)
                End If
                data = SourceData
            End With
        Else
            Debug.Print "ERROR, FILELEN 0"; filename
        End If
    Else
        LogError "Error en el archivo de a comprimir """ & filename & """ - El archivo No existe."
    End If

Exit Sub

errh:
    LogError "Error en el archivo de recursos """ & filename & """"

End Sub

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
    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(path, 1) <> "\" Then
        path = path & "\"
    End If '

    If LenB(dir$(path & filename, vbNormal)) Then
        Open path & filename For Binary Access Read Lock Write As handle: abierto = bTRUE
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

            If .size_compressed > 1024 Then
                tmpcrc = CRC32(SourceData(0), 1024, 0)
            Else
                tmpcrc = CRC32(SourceData(0), .size_compressed - 1, 0)
            End If

            'If .compress Then Decompress_Data SourceData(), .lngFileSizeUncompressed
            If .compress Then
                Decompress_Data SourceData(), .lngFileSizeUncompressed
            End If

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

            Extraidox = True
        End With
        Close handle: abierto = bFALSE
        Resource_Get = True
    Else
        LogError "Error en el archivo de recursos """ & filename & """ - El archivo no existe."
    End If

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

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
    'If Right$(path, 1) <> "\" Then path = path & "\"
    If Right$(path, 1) <> "\" Then
        path = path & "\"
    End If

    If LenB(dir$(path & filename, vbNormal)) Then
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
                tmpcrc = CRC32(SourceData(0), 1024, 0)
            Else
                tmpcrc = CRC32(SourceData(0), .size_compressed - 1, 0)
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
    LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
erra:
    'If abierto = 1 Then Close handle
    If abierto = 1 Then
        Close handle
    End If
    Resource_Get_CRC = 0

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
#If MENDUZ_PC = 1 Then
Public Function Resource_Read_sdf(ByRef path As String, ByRef filename As String) As String
'On Error GoTo errh
    Dim handle As Integer
    Dim jo As String
    Dim abierto As Byte
    Dim tmpcrc As Byte
    Dim asd As String * 16
    Dim tmpl As Long
    Dim tmpla As Long
    Dim Bytes() As Byte
    Dim i As Integer
    Dim tr As String

    handle = FreeFile

    If Right$(path, 1) <> "\" Then path = path & "\"

    If LenB(dir$(path & filename, vbNormal)) Then
        Open path & filename For Binary Access Read Lock Write As handle
            Get handle, , asd
            Get handle, , tmpcrc
            Get handle, , tmpl
            Get handle, , tmpla
            ReDim Bytes(tmpl)
            Get handle, , Bytes
        Close handle

        If StrComp(asd, header_s, vbTextCompare) Then
            #If IsServer = 0 Then
            LogError "El archivo : """ & filename & """ no es un archivo valido.", True
            #End If
            GoTo errh
        Else
            tr = StrConv(Bytes, vbUnicode)
            tr = Xor_String(tr, tmpcrc)
            If CRC16(CLng(tmpcrc), tr) = tmpla / CLng(tmpcrc) Then
                Resource_Read_sdf = tr
            Else
                LogError "Se borró el archivo de recursos " & filename
                Kill path & filename
                Resource_Read_sdf = vbNullString
            End If
        End If
    End If

Exit Function
errh:
LogError "Error en el archivo de recursos """ & filename & """ Err:" & ERR.Number & " - Desc : " & ERR.Description
End Function

Public Sub Resource_Create_sdf(ByRef datos As String, ByRef path As String, ByRef filename As String)
    Dim handle As Integer
    Dim tmpcrc As Byte

    Dim jo As String
    Dim tmpl As Long
    Dim tmpla As Long
    Dim Bytes() As Byte
    
    Dim data As String
    
    data = datos
    
    Dim i As Long
    
    Bytes = StrConv(data, vbFromUnicode)
    tmpcrc = CByte(CInt(Rnd * 200)) + 50
    tmpl = UBound(Bytes)
    tmpla = CRC16(CLng(tmpcrc), data) * CLng(tmpcrc)
    
    data = Xor_String(data, tmpcrc)
    Bytes = StrConv(data, vbFromUnicode)

    If Right$(path, 1) <> "\" Then path = path & "\"
    
    If FileExist(path & filename, vbNormal) Then Kill path & filename
    DoEvents
    
    handle = FreeFile
    
    Open path & filename For Binary Access Write As handle
        Put handle, , header_s
        Put handle, , tmpcrc
        Put handle, , tmpl
        Put handle, , tmpla
        Put handle, , Bytes
    Close handle
End Sub
#End If
Public Function Xor_String(ByRef t As String, ByVal code As Byte) As String

Dim Bytes() As Byte
Bytes = StrConv(t, vbFromUnicode)
    Call Xor_Bytes(Bytes(0), Len(t), code, CryptKey)
    Xor_String = StrConv(Bytes, vbUnicode)

End Function


Public Function Resource_Read_CFG_LNG(ByRef filename As String, ByVal cual_cfg As Long) As Long
    Dim handle As Integer
    Dim asd As String * 16
    Dim tmpl As Long
    Dim reade As Long
    
    If LenB(dir$(filename, vbNormal)) Then
        reade = 17 + (4 * cual_cfg)
        handle = FreeFile
        Open filename For Binary Access Read Lock Write As handle
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

Public Sub Resource_WRITE_CFG_LNG(ByRef filename As String, ByVal cual_cfg As Long, ByVal value As Long)
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
    
    If LenB(dir$(filename, vbNormal)) Then
        Open filename For Binary Access Read Write As handle
            Put handle, reade, tmpl
        Close handle
    Else
        Open filename For Binary Access Read Write As handle
            Put handle, , header_s
            Put handle, reade, tmpl
        Close handle
    End If
End Sub



Private Function CRC16(ByVal key As Long, ByVal data As String) As Integer
'**************************************************************
'Author: Salvito
'Last Modify Date: 2/07/2007
'Computes a custom CRC16 designed by Alejandro Salvo
'**************************************************************
    Dim i As Long
    Dim vstr() As Byte
    Dim SumaEspecialDeCaracteres As Long
    
    vstr = StrConv(data, vbFromUnicode)
    
    For i = 0 To Len(data) - 1
        SumaEspecialDeCaracteres = SumaEspecialDeCaracteres + vstr(i) * (1 + key - i)
    Next i
    
    CRC16 = CInt(Abs(SumaEspecialDeCaracteres) Mod 32000)
End Function
