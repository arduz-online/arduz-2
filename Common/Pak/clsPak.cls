VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPak"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
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

Option Explicit


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


Private Const CryptKey      As Byte = 167
Private Const CryptKeyL     As Long = 293842832

Public Path_res            As String

Private last_file_ext       As INFOHEADER

Private Cabezal()  As INFOHEADER
Private Cabezal_Ultimo_Byte    As Long
Private Cabezal_Cantidad   As Integer

Private Iterador_AnteriorIndex As Integer

Private Enum File_Privs
    EsUsuario = 1
    PuedeComitearGraficos = 2
    PuedeComitearMapas = 4
    PuedeIndexar = 8
    PuedeBorrarPropio = 16
    PuedeBorrarCualquiera = 32
    PuedeEditarCualquiera = 64
    PuedeExtraerArchivos = 128
    PuedeHacerRollBack = 256
End Enum

Private Const Min_Offset As Long = Max_Int_Val

Public Property Get LastIHPtr() As Long
    LastIHPtr = VarPtr(last_file_ext)
End Property

Public Function GetIHPtr(ByVal nro As Integer) As Long
    On Error Resume Next
    If nro <= Cabezal_Cantidad Then
        GetIHPtr = VarPtr(Cabezal(nro))
    End If
End Function


Public Function Cargar(ByVal Path As String) As Boolean 'Carga un archivo enpaquetado en la memoriaz(solo headers)

    Dim cantidad    As Integer
    Dim handle      As Integer
    Dim t_str       As String * 16
    Dim abierto     As Byte

    Path_res = Path
    handle = FreeFile()

    Open Path_res For Binary As handle: abierto = bTRUE
        Get handle, 1, t_str
        
        If StrComp(t_str, header_b, vbTextCompare) Then GoTo erra
    
        Get handle, , Cabezal_Cantidad
        Get handle, , Cabezal_Ultimo_Byte
    
        ReDim Cabezal(Cabezal_Cantidad)
    
        Get handle, , Cabezal
        
    Close handle: abierto = bFALSE
    
    Cargar = True
Exit Function

erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If
    LogError "El archivo : """ & Path_res & """ no es un archivo de recursos valido."
    'End

End Function

Public Function CrearVacio(ByVal FileName As String, ByVal Tamaño As Long) As Boolean
'Crea un nuevo enpaquetADO EN LA memoria
'False si el archivo ya existe,
    Dim handle      As Integer

    Path_res = FileName
    
    If (Dir$(Path_res, vbNormal) <> "") Then
        CrearVacio = False
    Else
        '-Reiniciamos...------------------------
            Cabezal_Cantidad = Min_Offset 'Tamaño + Min_Offset
            If Cabezal_Cantidad > Max_Int_Val Then Cabezal_Cantidad = Max_Int_Val
            ReDim Cabezal(Cabezal_Cantidad)
            Cabezal_Ultimo_Byte = 0
        '---------------------------------------
        
        CrearVacio = True
        handle = FreeFile
        Open Path_res For Binary Access Read Write As handle
            Seek handle, 1
            
            Put handle, , header_b
            Put handle, , Cabezal_Cantidad
            Put handle, , Cabezal_Ultimo_Byte
            Put handle, , Cabezal
            
            Cabezal_Ultimo_Byte = Seek(handle) + 100 ' Marcamos el header + 100 bytes para que empiece a escribir los archivos después.
            
            Seek handle, 1
            Put handle, , header_b
            Put handle, , Cabezal_Cantidad
            Put handle, , Cabezal_Ultimo_Byte
            
        Close handle
    End If
End Function

Public Function CrearDesdeCarpeta(ByVal FileName As String, ByRef folder As String, Optional ByVal filePattern As String = "*.*") As Boolean

'On Error GoTo errh

Dim handle          As Integer

Dim abierto         As Byte

Dim Nueva_Cantidad  As Integer
Dim Ultimo_Byte     As Long
Dim InfoHead        As INFOHEADER
Dim cabezal_ptr     As Integer

Dim SourceData()    As Byte
Dim File_List()     As String

Dim i               As Integer
Dim cantidad_array  As Integer

Dim max_cantidad    As Integer
Dim TmpInt          As Integer

Dim tmplng          As Long
Dim int_list()      As Integer

Dim handleB         As Integer

Dim new_file        As String
Dim asd             As String * 16
Dim necesita_hacer  As Byte
Dim tmpbn As Double

    

    File_List = AllFilesInFolders(folder, filePattern)  'Obtengo los archivos a agregar
    cantidad_array = UBound(File_List)                  'Cuento los archivos
    
    If cantidad_array = 0 Then                          'Si no hay archivos, cancelo la operación
        CrearDesdeCarpeta = False
        Exit Function
    End If
    
    ReDim int_list(cantidad_array)

    For i = 0 To cantidad_array
        tmpbn = Val(Split(File_List(i), ".", 2)(0))     'Obtengo el número de archivo
        If tmpbn <= Max_Int_Val Then
            TmpInt = tmpbn
    
            If max_cantidad < TmpInt Then max_cantidad = TmpInt
            int_list(i) = TmpInt                        'Defino que archivo del array corresponde a este número de cabezal
        End If
    Next i

    tmplng = max_cantidad + Min_Offset                  'Agrando el tamaño del cabezal
    If tmplng > Max_Int_Val Then tmplng = Max_Int_Val
    
    Cabezal_Cantidad = tmplng

    ReDim Cabezal(Cabezal_Cantidad)

    Path_res = FileName

    If (Dir$(Path_res, vbNormal) <> "") Then Kill Path_res
    
    handleB = FreeFile()
    Open Path_res For Binary Access Read Write As handleB
    Seek handleB, 1

    Ultimo_Byte = 0
    Put handleB, , header_b
    Put handleB, , Cabezal_Cantidad
    Put handleB, , Cabezal_Ultimo_Byte
    Put handleB, , Cabezal

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
                ReDim SourceData(InfoHead.size_compressed) As Byte
                Get handle, , SourceData()
            End If
            
            Close handle: abierto = bFALSE

            If necesita_hacer Then
                Resource_Generate_IH new_file, InfoHead, SourceData
            End If

            InfoHead.EmpiezaByte = Seek(handleB)

            Cabezal(int_list(i)) = InfoHead

            Put handleB, , SourceData
            Cabezal_Ultimo_Byte = Seek(handleB) + 1
            
            Debug.Print "Push ("; int_list(i); ") - "; File_List(i); " - CRC:"; Hex(InfoHead.CRC); InfoHead.size_compressed; "- ptr:"; Hex$(Ultimo_Byte)
        End If
    Next i

    Seek handleB, 1

    Put handleB, , header_b
    Put handleB, , Cabezal_Cantidad
    Put handleB, , Cabezal_Ultimo_Byte
    Put handleB, , Cabezal
    
    Close handleB

    CrearDesdeCarpeta = True

Exit Function

errh:
    LogError "Error en el archivo de recursos """ & FileName & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Public Function Leer(ByRef nFile As Integer, ByRef Data() As Byte, Optional ByVal rFile_type As e_resource_file = -1) As Boolean
On Error GoTo errh

Dim handle As Integer
Dim SourceData() As Byte
Dim InfoHead As INFOHEADER
Dim abierto As Byte

    If nFile = 0 Then
        Leer = False
        Exit Function
    End If

    If Cabezal_Cantidad >= nFile Then
        InfoHead = Cabezal(nFile)
    Else
        Leer = False
        Exit Function
    End If

    handle = FreeFile()
    
    If InfoHead.EmpiezaByte Then
        Open Path_res For Binary Access Read Lock Write As handle: abierto = bTRUE
            Seek handle, InfoHead.EmpiezaByte   ' movemos el puntero de handle a EmpiezaByte
            
            ReDim SourceData(InfoHead.size_compressed) As Byte
            Get handle, , SourceData()          ' Leo el contenido.
        
            If InfoHead.compress = 1 Then       ' Si esta comprimido, lo descomprimimos.
                Decompress_Data SourceData(), InfoHead.lngFileSizeUncompressed Xor CryptKeyL Xor InfoHead.cript
            End If
            
            Data = SourceData                   'REturneo la data
        Close handle: abierto = bFALSE
    
        last_file_ext = InfoHead
        Leer = True
    End If
    
Exit Function

errh:
    LogError "Error en el archivo de recursos """ & Path_res & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Public Function Extraer(ByRef nro As Integer, ByRef dest As String) As Boolean

'On Error GoTo errh

Dim SourceData() As Byte
Dim handle%

    handle = FreeFile()

    If (Dir$(dest, vbNormal) <> "") Then
        Kill dest
    End If

    If Leer(nro, SourceData) Then
        Open dest For Binary Access Read Write As handle
        Put handle, , SourceData()
        Close handle
        Extraer = True
    End If

errh:

End Function

Public Function Cabezal_GetFileSize(ByVal nFile As Integer) As Long
    If nFile = 0 Then
        Exit Function
    End If

    If Cabezal_Cantidad >= nFile Then
        Cabezal_GetFileSize = Cabezal(nFile).size_compressed
    Else
        Exit Function
    End If
End Function

Public Function Cabezal_GetFilePtr(ByVal nFile As Integer) As Long
    If nFile = 0 Then
        Exit Function
    End If

    If Cabezal_Cantidad >= nFile Then
        Cabezal_GetFilePtr = Cabezal(nFile).EmpiezaByte
    Else
        Exit Function
    End If
End Function

Public Function Cabezal_GetFilenameName(ByVal nFile As Integer) As String
    Cabezal_GetFilenameName = vbNullString
    If nFile = 0 Then
        Exit Function
    End If

    If Cabezal_Cantidad >= nFile Then
        Cabezal_GetFilenameName = Trim$(LCase$(Xor_String(Cabezal(nFile).originalname, Cabezal(nFile).cript)))
    Else
        Exit Function
    End If
End Function


Public Function Cabezal_GetCRC(ByRef nFile As Integer) As Long

' esta func se puede usar para el parcheo
' return 0 cuando es invalido o error

    On Error Resume Next
        Cabezal_GetCRC = &H0

        If UBound(Cabezal) >= nFile Then _
            Cabezal_GetCRC = Cabezal(nFile).CRC


End Function

Public Function LeerRAW(ByRef nFile As Integer) As String
Dim SourceData() As Byte

    If Leer(nFile, SourceData) Then
        LeerRAW = StrConv(SourceData, vbUnicode)
    Else
        LeerRAW = vbNullString
    End If
End Function

Friend Function IH_Get(ByRef nFile As Integer, ByRef InfoHead As INFOHEADER) As Boolean
    If Cabezal_Cantidad < nFile Then
        Exit Function
    Else
        InfoHead = Cabezal(nFile)
        IH_Get = True
    End If
End Function


Friend Function IH_Mod(ByRef nFile As Integer, ByRef InfoHead As INFOHEADER) As Boolean

'On Error GoTo errh

Dim handle          As Integer

Dim abierto         As Byte

Dim fhp             As Long
Dim TIH As INFOHEADER

    
    
    If IH_Get(nFile, TIH) = False Then Exit Function
    
    If TIH.lngFileSizeUncompressed = 0 Then Exit Function
    
    InfoHead.compress = TIH.compress
    InfoHead.cript = TIH.cript
    InfoHead.EmpiezaByte = TIH.EmpiezaByte
    InfoHead.size_compressed = TIH.size_compressed
    InfoHead.lngFileSizeUncompressed = TIH.lngFileSizeUncompressed
    InfoHead.originalname = TIH.originalname

    InfoHead.file_type = TIH.file_type

    Cabezal(nFile) = InfoHead
    
    handle = FreeFile()
    Debug.Print "[MODIFICANDO:" & nFile & "]"
    
    fhp = 23 + CLng(nFile) * Len(InfoHead) ' muejeje
    Open Path_res For Binary Access Read Write As handle: abierto = bTRUE
        Put handle, fhp, InfoHead
    Close handle: abierto = bFALSE
    
    Debug.Print " Offset head:"; fhp
    Debug.Print " MODIFICADO OK."
    Debug.Print ""
    IH_Mod = True
Exit Function

errh:
    LogError "Error en mod el archivo de recursos """ & Path_res & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Friend Function Iterar(ba() As Byte, ByRef nFile As Integer, ByRef InfoHeadPtr As INFOHEADER) As Boolean
    Dim i As Integer
    Dim handle As Integer
    
    If Iterador_AnteriorIndex >= Cabezal_Cantidad Then
        Iterar = False
        Exit Function
    End If
    
    For i = Iterador_AnteriorIndex + 1 To Cabezal_Cantidad
        If Cabezal(i).size_compressed Then
            InfoHeadPtr = Cabezal(i)
            Debug.Print "asd"; Xor_String(Cabezal(i).originalname, Cabezal(i).cript)
            
            Iterador_AnteriorIndex = i
            
            nFile = i
            
            handle = FreeFile
        
            Open Path_res For Binary Access Read As handle
                Seek handle, Cabezal(i).EmpiezaByte           ' movemos el puntero de handle a EmpiezaByte
                ReDim ba(Cabezal(i).size_compressed) As Byte
                Get handle, , ba()                          ' Leo el contenido.
            Close handle
            
            Iterar = True
            
            Exit For
        End If
    Next i
End Function

Friend Function ParchearByteArray(ba() As Byte, ByVal nFile As Integer, ByRef InfoHead As INFOHEADER) As Boolean
'On Error GoTo errh

Dim handle          As Integer

Dim abierto         As Byte

Dim fhp As Long

    If nFile > Cabezal_Cantidad Then Exit Function

    If InfoHead.size_compressed = 0 Then
        MsgBox "Error al parchear. nFile=" & nFile & " - Está vacío."
        Exit Function
    End If
    
    handle = FreeFile()
    Open Path_res For Binary Access Read Write As handle: abierto = bTRUE
    
        Seek handle, LOF(handle) + 1
        InfoHead.EmpiezaByte = Seek(handle) 'obtengo el inicio del archivo
        
        Put handle, , ba                    'Escribo el archivo
        Cabezal_Ultimo_Byte = Seek(handle)
        
        Seek handle, 1
        Put handle, , header_b
        Put handle, , Cabezal_Cantidad
        Put handle, , Cabezal_Ultimo_Byte
        
        fhp = Seek(handle) + CLng(nFile) * Len(InfoHead) ' muejeje, escribo el cabezal
        Put handle, fhp, InfoHead
        
        Debug.Print "[PARCHEANDO:" & Path_res & "]"
        Debug.Print " File"; nFile; Xor_String(InfoHead.originalname, InfoHead.cript)
        Debug.Print " Offset head:"; fhp
        Debug.Print " Offset file:"; InfoHead.EmpiezaByte
        Debug.Print " Tamaño:"; InfoHead.size_compressed
        Debug.Print " Comprimido: "; CBool(InfoHead.compress)
        Debug.Print " Ultimo byte:"; Cabezal_Ultimo_Byte
        Debug.Print " PARCHEADO OK."
        Debug.Print ""
        
        ParchearByteArray = True
    Close handle: abierto = bFALSE

    Cabezal(nFile) = InfoHead

Exit Function

errh:
    LogError "Error en ParchearByteArray """ & Path_res & """ Err:" & Err.Number & " - Desc : " & Err.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If




End Function

Public Function Parchear(ByRef nFile As Integer, ByRef new_file As String, Optional ByVal CRC As Long = -1) As Boolean

'On Error GoTo errh

Dim handle          As Integer

Dim InfoHead        As INFOHEADER
Dim InfoHeadPtr        As Long
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

Dim FileName        As String
Dim resultado             As Boolean
Dim ArchivoPack     As clsPak

    file_len = FileLen(new_file)

    If new_file = Path_res Then
        Err.Raise 2371465, , "Queres parchar con el mismo parche?"
        GoTo errh
    End If

   

    'If Not LenB(Dir$(path & filename, vbNormal)) Then GoTo errh
    
    If file_len = 0 Then
        Err.Raise 2371465, , "Archivo ""Parche"" invalido"
        GoTo errh                           'Si no existe el archivo q vamos a parchear, chau.
    End If

    handle = FreeFile

    Open new_file For Binary Access Read Lock Write As handle: abierto = bTRUE
    Get handle, , tmp_s
    
    Select Case tmp_s
    Case header_s
        Get handle, , InfoHead
        ReDim SourceData(InfoHead.size_compressed) As Byte
        Get handle, , SourceData()
        Close handle: abierto = bFALSE
        Parchear = ParchearByteArray(SourceData(), nFile, InfoHead)
    Case header_b
        Set ArchivoPack = New clsPak
        Close handle: abierto = bFALSE              ' Cierro el archivo para evitar runtimes
        DoEvents
        
        If ArchivoPack.Cargar(new_file) Then        'Cargo el archivo denuevo
            LogDebug "Parcheador->" & "Cargando archivo enpaquetado: " & new_file & " para " & Path_res
            Parchear = True
            While ArchivoPack.Iterar(SourceData(), nFile, InfoHead)
                'CopyMemory InfoHead, ByVal InfoHeadPtr, Len(InfoHead)
                resultado = ParchearByteArray(SourceData(), nFile, InfoHead)
                LogDebug "____ Parcheador--->" & "Parcheando: " & nFile & " Resultado: " & resultado
                Parchear = Parchear And resultado
            Wend
            LogDebug "____ [Parcheado = " & Parchear & "]"
            
            Exit Function
        Else
            LogError "Error al cargar el parche enpaquetado"
        End If
    Case Else
        Close handle: abierto = bFALSE
        Resource_Generate_IH new_file, InfoHead, SourceData
        Parchear = ParchearByteArray(SourceData(), nFile, InfoHead)
    End Select

    If abierto Then Close handle: abierto = bFALSE
    
    

Exit Function

errh:
    LogError "Error queriendo parchar en el archivo de recursos """ & Path_res & """ el archivo numero " & nFile & " proveniente del archivo " & new_file & " Err:" & Err.Number & " - Desc : " & Err.Description
erra:
    'If abierto Then Close handle
    If abierto Then
        Close handle
    End If

End Function

Private Function FileExist(FILE As String, FileType As VbFileAttribute) As Boolean
    If Dir(FILE, FileType) = "" Then
        FileExist = False
      Else
        FileExist = True
    End If
End Function

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

Public Function Add_To_Listbox(ByRef List As ListBox) As Boolean
'On Error Resume Next
Dim InfoHead    As INFOHEADER
Dim abierto     As Byte
Dim i           As Integer

    List.Clear

    For i = 0 To Cabezal_Cantidad
        InfoHead = Cabezal(i)
        'If InfoHead.size_compressed Then _
            List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript)))
        If InfoHead.size_compressed Then
            List.AddItem i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript))) & " - CRC:" & Hex$(InfoHead.CRC) & " - " & Round(InfoHead.size_compressed / 1024, 1) & "KB"
        End If
    Next i

End Function

Public Function Add_To_Listbox_Permisos(ByRef List As ListBox, ByVal MisPermisos As Long, ByVal MiUser As Integer) As Boolean
'On Error Resume Next
Dim InfoHead    As INFOHEADER
Dim abierto     As Byte
Dim i           As Integer
Dim Strin       As String
Dim st          As String


    List.Clear

    For i = 0 To Cabezal_Cantidad
        InfoHead = Cabezal(i)

        If InfoHead.size_compressed Then
            Strin = i & " - " & Trim$(LCase$(Xor_String(InfoHead.originalname, InfoHead.cript)))
            st = ""

            If (InfoHead.owner = MiUser And MiUser > 0) Or MisPermisos = -1 Then
                List.AddItem Strin & " - [Editar Extraer Rollback]"
            Else
                If (InfoHead.privs And File_Privs.PuedeEditarCualquiera) And (MisPermisos And File_Privs.PuedeEditarCualquiera) Then st = st & "Editar"
                If (InfoHead.privs And File_Privs.PuedeExtraerArchivos) And (MisPermisos And File_Privs.PuedeExtraerArchivos) Then st = st & "Extraer"
                If (InfoHead.privs And File_Privs.PuedeHacerRollBack) And (MisPermisos And File_Privs.PuedeHacerRollBack) Then st = st & "Rollback"
                
                If st = "" Then
                    List.AddItem "*" & Strin
                Else
                    List.AddItem Strin & " - [" & st & "]"
                End If
            End If
        End If
    Next i

End Function


Public Function Puedo_Extraer(ByVal nFile As Integer, ByVal MisPermisos As Long, ByVal MiUser As Integer) As Boolean
'On Error Resume Next
Dim InfoHead    As INFOHEADER
    If nFile <= Cabezal_Cantidad Then
        InfoHead = Cabezal(nFile)

        If InfoHead.size_compressed Then
            If (InfoHead.owner = MiUser And MiUser > 0) Or MisPermisos = -1 Then
                Puedo_Extraer = True
            Else
                If (InfoHead.privs And File_Privs.PuedeExtraerArchivos) And (MisPermisos And File_Privs.PuedeExtraerArchivos) Then Puedo_Extraer = True
            End If
        End If
    End If
End Function

Public Function Puedo_RollBack(ByVal nFile As Integer, ByVal MisPermisos As Long, ByVal MiUser As Integer) As Boolean
'On Error Resume Next
Dim InfoHead    As INFOHEADER
    If nFile <= Cabezal_Cantidad Then
        InfoHead = Cabezal(nFile)

        If InfoHead.size_compressed Then
            If (InfoHead.owner = MiUser And MiUser > 0) Or MisPermisos = -1 Then
                Puedo_RollBack = True
            Else
                If (InfoHead.privs And File_Privs.PuedeHacerRollBack) And (MisPermisos And File_Privs.PuedeHacerRollBack) Then Puedo_RollBack = True
            End If
        End If
    End If
End Function

Public Function Puedo_Editar(ByVal nFile As Integer, ByVal MisPermisos As Long, ByVal MiUser As Integer) As Boolean
'On Error Resume Next
Dim InfoHead    As INFOHEADER
    If nFile <= Cabezal_Cantidad Then
        InfoHead = Cabezal(nFile)

        If InfoHead.size_compressed Then
            If (InfoHead.owner = MiUser And MiUser > 0) Or MisPermisos = -1 Then
                Puedo_Editar = True
            Else
                If (InfoHead.privs And File_Privs.PuedeEditarCualquiera) And (MisPermisos And File_Privs.PuedeEditarCualquiera) Then Puedo_Editar = True
            End If
        Else
            Puedo_Editar = True
        End If
    End If
End Function




