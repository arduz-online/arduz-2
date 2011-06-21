Attribute VB_Name = "modCompression"


'#Const tex_from_mem = 1
'#If tex_from_mem = 1 Then
'    Public Function Get_Bitmap(ByRef ResourcePath As String, ByRef FileName As String, ByRef bmpInfo As BITMAPINFO, ByRef data() As Byte) As Boolean
'    '*****************************************************************
'    'Author: Nicolas Matias Gonzalez (NIGO)
'    'Last Modify Date: 11/30/2007
'    'Retrieves bitmap file data
'    '*****************************************************************
'        Dim InfoHead As INFOHEADER
'        Dim rawData() As Byte
'        Dim offBits As Long
'        Dim bitmapSize As Long
'        Dim colorCount As Long
'
'        InfoHead = File_Find(App.Path & "\Datos\Graficos.adz", FileName)
'            'Extract the file and create the bitmap data from it.
'            If Extract_Filex(ResourcePath, InfoHead, rawData) Then
'                Call CopyMemory(offBits, rawData(10), 4)
'                Call CopyMemory(bmpInfo.bmiHeader, rawData(14), 40)
'
'                With bmpInfo.bmiHeader
'                    bitmapSize = AlignScan(.biWidth, .biBitCount) * Abs(.biHeight)
'
'                    If .biBitCount < 24 Or .biCompression = BI_BITFIELDS Or (.biCompression <> BI_RGB And .biBitCount = 32) Then
'                        If .biClrUsed < 1 Then
'                            colorCount = 2 ^ .biBitCount
'                        Else
'                            colorCount = .biClrUsed
'                        End If
'
'                        ' When using bitfields on 16 or 32 bits images, bmiColors has a 3-longs mask.
'                        If .biBitCount >= 16 And .biCompression = BI_BITFIELDS Then colorCount = 3
'
'                        Call CopyMemory(bmpInfo.bmiColors(0), rawData(54), colorCount * 4)
'                    End If
'                End With
'
'                ReDim data(bitmapSize - 1) As Byte
'                Call CopyMemory(data(0), rawData(offBits), bitmapSize)
'
'                Get_Bitmap = True
'            End If
'        'Else
'        '    Call MsgBox("No se se encontro el recurso " & FileName)
'        'End If
'    End Function
'    Private Function AlignScan(ByVal inWidth As Long, ByVal inDepth As Integer) As Long
'    '*****************************************************************
'    'Author: Unknown
'    'Last Modify Date: Unknown
'    '*****************************************************************
'        AlignScan = (((inWidth * inDepth) + &H1F) And Not &H1F&) \ &H8
'    End Function
'    Private Function Get_InfoHeader(ByRef ResourcePath As String, ByRef FileName As String, ByRef InfoHead As INFOHEADER) As Boolean
'    '*****************************************************************
'    'Author: Nicolas Matias Gonzalez (NIGO)
'    'Last Modify Date: 08/21/2007
'    'Retrieves the InfoHead of the specified graphic file
'    '*****************************************************************
'        Dim ResourceFile As Integer
'        Dim ResourceFilePath As String
'        Dim FileHead As FILEHEADER
'
'    On Local Error GoTo ErrHandler
'
'        ResourceFilePath = App.Path & "\Datos\Graficos.adz"
'
'        'Set InfoHeader we are looking for
'        InfoHead.strFileName = UCase$(FileName)
'
'    #If SeguridadAlkon Then
'        Call Secure_Info_Header(InfoHead)
'    #End If
'
'        'Open the binary file
'        ResourceFile = FreeFile()
'        Open ResourceFilePath For Binary Access Read Lock Write As ResourceFile
'            'Extract the FILEHEADER
'            Get ResourceFile, 1, FileHead
'
'    #If SeguridadAlkon Then
'            Call Secure_File_Header(FileHead)
'    #End If
'
'            'Check the file for validity
'            If LOF(ResourceFile) <> FileHead.lngFileSize Then
'                MsgBox "Archivo de recursos da?ado. " & ResourceFilePath, , "Error"
'                Close ResourceFile
'                Exit Function
'            End If
'
'            'Search for it!
'            If BinarySearch(ResourceFile, InfoHead, 1, FileHead.intNumFiles, Len(FileHead), Len(InfoHead)) Then
'    #If SeguridadAlkon Then
'                Call Secure_Info_Header(InfoHead)
'    #End If
'
'                Get_InfoHeader = True
'            End If
'
'        Close ResourceFile
'    Exit Function
'
'ErrHandler:
'        Close ResourceFile
'
'        Call MsgBox("Error al intentar leer el archivo " & ResourceFilePath & ". Raz?n: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error")
'    End Function
'
'    Private Function BinarySearch(ByRef ResourceFile As Integer, ByRef InfoHead As INFOHEADER, ByVal FirstHead As Long, ByVal LastHead As Long, ByVal FileHeaderSize As Long, ByVal InfoHeaderSize As Long) As Boolean
'    '*****************************************************************
'    'Author: Nicolas Matias Gonzalez (NIGO)
'    'Last Modify Date: 08/21/2007
'    'Searches for the specified InfoHeader
'    '*****************************************************************
'        Dim ReadingHead As Long
'        Dim ReadInfoHead As INFOHEADER
'
'        Do Until FirstHead > LastHead
'            ReadingHead = (FirstHead + LastHead) \ 2
'
'            Get ResourceFile, FileHeaderSize + InfoHeaderSize * (ReadingHead - 1) + 1, ReadInfoHead
'
'            If InfoHead.strFileName = ReadInfoHead.strFileName Then
'                InfoHead = ReadInfoHead
'                BinarySearch = True
'                Exit Function
'            Else
'                If InfoHead.strFileName < ReadInfoHead.strFileName Then
'                    LastHead = ReadingHead - 1
'                Else
'                    FirstHead = ReadingHead + 1
'                End If
'            End If
'        Loop
'    End Function
'
'
'
'    Public Function Extract_Filex(ByRef ResourcePath As String, ByRef InfoHead As INFOHEADER, ByRef data() As Byte) As Boolean
'    '*****************************************************************
'    'Author: Nicolas Matias Gonzalez (NIGO)
'    'Last Modify Date: 08/20/2007
'    'Extract the specific file from a resource file
'    '*****************************************************************
'    On Local Error GoTo ErrHandler
'
'        If Get_File_RawData(ResourcePath, InfoHead, data) Then
'            'Decompress all data
'            If InfoHead.lngFileSize < InfoHead.lngFileSizeUncompressed Then
'                Call Decompress_Data(data, InfoHead.lngFileSizeUncompressed)
'            End If
'
'            Extract_Filex = True
'        End If
'    Exit Function
'
'ErrHandler:
'        Call MsgBox("Error al intentar decodificar recursos. Razon: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error")
'    End Function
'
'    Public Function Get_File_RawData(ByRef ResourcePath As String, ByRef InfoHead As INFOHEADER, ByRef data() As Byte) As Boolean
'    '*****************************************************************
'    'Author: Nicolas Matias Gonzalez (NIGO)
'    'Last Modify Date: 08/24/2007
'    'Retrieves a byte array with the compressed data from the specified file
'    '*****************************************************************
'        Dim ResourceFilePath As String
'        Dim ResourceFile As Integer
'
'    On Local Error GoTo ErrHandler
'        ResourceFilePath = App.Path & "\Datos\Graficos.adz"
'
'        'Size the Data array
'        ReDim data(InfoHead.lngFileSize - 1)
'
'        'Open the binary file
'        ResourceFile = FreeFile
'        Open ResourceFilePath For Binary Access Read Lock Write As ResourceFile
'            'Get the data
'            Get ResourceFile, InfoHead.lngFileStart, data
'        'Close the binary file
'        Close ResourceFile
'
'        Get_File_RawData = True
'    Exit Function
'
'ErrHandler:
'        Close ResourceFile
'    End Function
'#End If
