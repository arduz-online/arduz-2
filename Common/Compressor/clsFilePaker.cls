VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFilePaker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Type FILEHEADER
    lngFileSize As Long
    intNumFiles As Integer
End Type

Private Type INFOHEADER
    lngFileStart As Long
    lngFileSize As Long
    strFileName As String * 32
    lngFileSizeUncompressed As Long
End Type

Private Const CryptKey As Byte = 108
Private Const CryptKeyL As Long = (CryptKey ^ 4) - 1

Private Declare Function Compress Lib "zlib.dll" Alias "compress" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Private Declare Function UnCompress Lib "zlib.dll" Alias "uncompress" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef source As Any, ByVal byteCount As Long)

Public Sub Compress_Data(ByRef data() As Byte)
    Dim Dimensions As Long
    Dim DimBuffer As Long
    Dim BufTemp() As Byte
    Dim BufTemp2() As Byte
    Dim loopc As Long
    
    Dimensions = UBound(data)
    
    DimBuffer = Dimensions * 1.06
    ReDim BufTemp(DimBuffer)
    
    Compress BufTemp(0), DimBuffer, data(0), Dimensions
    
    Erase data
    
    ReDim Preserve BufTemp(DimBuffer - 1)
    
    data = BufTemp
    
    Erase BufTemp
    
    data(0) = data(0) Xor CryptKey
End Sub

Public Sub Decompress_Data(ByRef data() As Byte, ByVal OrigSize As Long)
    Dim BufTemp() As Byte
    
    ReDim BufTemp(OrigSize - 1)
    
    data(0) = data(0) Xor CryptKey
    
    UnCompress BufTemp(0), OrigSize, data(0), UBound(data) + 1
    
    ReDim data(OrigSize - 1)
    
    data = BufTemp
    
    Erase BufTemp
End Sub

Public Function Extract_All_Files(ByVal SourceFilePath As String, ByVal OutputFilePath As String) As Boolean
    Dim loopc As Long
    Dim SourceFile As Integer
    Dim SourceData() As Byte
    Dim FileHead As FILEHEADER
    Dim InfoHead() As INFOHEADER
    Dim handle As Integer
    
On Local Error GoTo ErrHandler
    
    SourceFile = FreeFile
    Open SourceFilePath For Binary Access Read Lock Write As SourceFile
    
    Get SourceFile, 1, FileHead
        
    If LOF(SourceFile) <> FileHead.lngFileSize Then
        MsgBox "Resource file " & SourceFilePath & " seems to be corrupted.", , "Error"
        Close SourceFile
        Erase InfoHead
        Exit Function
    End If
    
    ReDim InfoHead(FileHead.intNumFiles - 1)
    
    Get SourceFile, , InfoHead
        

    For loopc = 0 To UBound(InfoHead)
        If InfoHead(loopc).lngFileSizeUncompressed Xor CryptKeyL > General_Drive_Get_Free_Bytes(Left(App.Path, 3)) Then
            MsgBox "There is not enough free memory to continue extracting files."
            Exit Function
        End If
        
        ReDim SourceData(InfoHead(loopc).lngFileSize - 1)
        Get SourceFile, InfoHead(loopc).lngFileStart, SourceData
        Decompress_Data SourceData, InfoHead(loopc).lngFileSizeUncompressed Xor CryptKeyL
        handle = FreeFile
        
        Open OutputFilePath & InfoHead(loopc).strFileName For Binary As handle
            Put handle, , SourceData
        Close handle
        
        Erase SourceData

        DoEvents
    Next loopc
    
    Close SourceFile
    
    Erase InfoHead
    
    Extract_All_Files = True
Exit Function

ErrHandler:
    Close SourceFile
    Erase SourceData
    Erase InfoHead
   Debug.Print "Unable to decode binary file. Reason: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error"
End Function

Public Function Compress_Files(ByVal OutputFilePath As String, ByVal SourceFilePath As String, Optional ByVal SourceFileExtension As String = "*.*") As Boolean


    Dim SourceFile As Long
    Dim OutputFile As Long
    Dim SourceFileName As String
    Dim SourceData() As Byte
    Dim FileHead As FILEHEADER
    Dim InfoHead() As INFOHEADER
    Dim FileNames() As String
    Dim lngFileStart As Long
    Dim loopc As Long
    
'Set up the error handler
On Local Error GoTo ErrHandler
    
    SourceFileName = Dir$(SourceFilePath & SourceFileExtension, vbNormal)
    SourceFile = FreeFile
    While SourceFileName <> ""
        FileHead.intNumFiles = FileHead.intNumFiles + 1
        
        ReDim Preserve FileNames(FileHead.intNumFiles - 1)
        FileNames(FileHead.intNumFiles - 1) = LCase(SourceFileName)
        
        'Search new file
        SourceFileName = Dir$()
    Wend
    
    If FileHead.intNumFiles = 0 Then
        Debug.Print "There are no files of extension " & SourceFileExtension & " in " & SourceFilePath & ".", , "Error"
        Exit Function
    End If

    General_Quick_Sort FileNames(), 0, UBound(FileNames)

    ReDim InfoHead(FileHead.intNumFiles - 1)

    If Dir(OutputFilePath, vbNormal) <> "" Then
        Kill OutputFilePath
    End If

    OutputFile = FreeFile
    Open OutputFilePath For Binary Access Read Write As OutputFile
        For loopc = 0 To FileHead.intNumFiles - 1
            SourceFile = FreeFile
            Open SourceFilePath & FileNames(loopc) For Binary Access Read Lock Write As SourceFile
                InfoHead(loopc).strFileName = FileNames(loopc)
                ReDim SourceData(LOF(SourceFile) - 1)
                InfoHead(loopc).lngFileSizeUncompressed = LOF(SourceFile) Xor CryptKeyL
                Get SourceFile, , SourceData
                Compress_Data SourceData
                Put OutputFile, , SourceData
                FileHead.lngFileSize = FileHead.lngFileSize + UBound(SourceData) + 1
                InfoHead(loopc).lngFileSize = UBound(SourceData) + 1
                Erase SourceData
            Close SourceFile
            Debug.Print loopc & "/" & FileHead.intNumFiles - 1
            DoEvents
        Next loopc
        

        FileHead.lngFileSize = FileHead.lngFileSize + CLng(FileHead.intNumFiles) * Len(InfoHead(0)) + Len(FileHead)
        
        lngFileStart = Len(FileHead) + CLng(FileHead.intNumFiles) * Len(InfoHead(0)) + 1
        For loopc = 0 To FileHead.intNumFiles - 1
            InfoHead(loopc).lngFileStart = lngFileStart
            lngFileStart = lngFileStart + InfoHead(loopc).lngFileSize
        Next loopc
            
        ReDim SourceData(LOF(OutputFile) - 1)
        Seek OutputFile, 1
        Get OutputFile, , SourceData
        
        Seek OutputFile, 1
        
        'Store the data in the file
        Put OutputFile, , FileHead
        Put OutputFile, , InfoHead
        Put OutputFile, , SourceData

    Close OutputFile
    
    Erase InfoHead
    Erase SourceData
Exit Function

ErrHandler:
    Erase SourceData
    Erase InfoHead
    Debug.Print "Unable to create binary file. Reason: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error"
End Function

Public Function Extract_File(ByVal SourceFilePath As String, ByVal file_name As String, ByVal OutputFilePath As String) As Boolean
    Dim loopc As Long
    Dim SourceData() As Byte
    Dim InfoHead As INFOHEADER
    Dim handle As Integer
    
'On Local Error GoTo ErrHandler
    Debug.Print Get_InfoHeader(SourceFilePath, file_name, InfoHead)
    If InfoHead.strFileName = "" Or InfoHead.lngFileSize = 0 Then Exit Function

    handle = FreeFile
    Open SourceFilePath For Binary Access Read Lock Write As handle
'        If InfoHead.lngFileSizeUncompressed Xor CryptKeyL > General_Drive_Get_Free_Bytes(Left$(App.Path, 3)) Then
'            Close handle
'            MsgBox "There is not enough drive space to extract the compressed file.", , "Error"
'            Exit Function
'        End If
        
        ReDim SourceData(InfoHead.lngFileSize - 1)
        Get handle, InfoHead.lngFileStart, SourceData
        Decompress_Data SourceData, InfoHead.lngFileSizeUncompressed Xor CryptKeyL
    Close handle
    
    handle = FreeFile
    
    Open OutputFilePath & "\" & InfoHead.strFileName For Binary As handle
        Put handle, 1, SourceData
    Close handle
    
    Erase SourceData
    Extract_File = True
Exit Function

ErrHandler:
    Close handle
    Erase SourceData
    Debug.Print "Unable to decode binary file. Reason: " & Err.Number & " : " & Err.Description ', vbOKOnly, "Error"
End Function

Private Function File_Find(ByVal resource_file_path As String, ByVal file_name As String) As INFOHEADER
On Error GoTo ErrHandler
    Dim Max As Integer  'Max index
    Dim min As Integer  'Min index
    Dim mid As Integer  'Middle index
    Dim file_handler As Integer
    Dim file_head As FILEHEADER
    Dim info_head As INFOHEADER
    
    'Fill file name with spaces for compatibility
    If Len(file_name) < Len(info_head.strFileName) Then _
        file_name = file_name & Space$(Len(info_head.strFileName) - Len(file_name))
    
    'Open resource file
    file_handler = FreeFile
    Open resource_file_path For Binary Access Read Lock Write As file_handler
    
    'Get file head
    Get file_handler, 1, file_head
    
    min = 1
    Max = file_head.intNumFiles
    
    Do While min <= Max
        mid = (min + Max) / 2
        
        'Get the info header of the appropiate compressed file
        Get file_handler, CLng(Len(file_head) + CLng(Len(info_head)) * CLng((mid - 1)) + 1), info_head
                
        If file_name < info_head.strFileName Then
            If Max = mid Then
                Max = Max - 1
            Else
                Max = mid
            End If
        ElseIf file_name > info_head.strFileName Then
            If min = mid Then
                min = min + 1
            Else
                min = mid
            End If
        Else
            'Copy info head
            File_Find = info_head
            
            'Close file and exit
            Close file_handler
            Exit Function
        End If
    Loop
    
ErrHandler:
    'Close file
    Close file_handler
    File_Find.strFileName = ""
    File_Find.lngFileSize = 0
    Debug.Print file_name & " No existe. En " & resource_file_path
End Function


    Private Function Get_InfoHeader(ByRef ResourcePath As String, ByRef FileName As String, ByRef InfoHead As INFOHEADER) As Boolean
    '*****************************************************************
    'Author: Nicolas Matias Gonzalez (NIGO)
    'Last Modify Date: 08/21/2007
    'Retrieves the InfoHead of the specified graphic file
    '*****************************************************************
        Dim ResourceFile As Integer
        Dim ResourceFilePath As String
        Dim FileHead As FILEHEADER

    On Local Error GoTo ErrHandler

        ResourceFilePath = ResourcePath

        'Set InfoHeader we are looking for
        InfoHead.strFileName = LCase$(FileName)
        'Open the binary file
        ResourceFile = FreeFile()
        Open ResourceFilePath For Binary Access Read Lock Write As ResourceFile
            'Extract the FILEHEADER
            Get ResourceFile, 1, FileHead
            
            'Check the file for validity
            If LOF(ResourceFile) <> FileHead.lngFileSize Then
                MsgBox "Archivo de recursos da?ado. " & ResourceFilePath, , "Error"
                Close ResourceFile
                Exit Function
            End If
            Debug.Print CStr(FileHead.intNumFiles); FileHead.lngFileSize
            'Search for it!
            If BinarySearch(ResourceFile, InfoHead, 1, FileHead.intNumFiles, Len(FileHead), Len(InfoHead)) Then
                Get_InfoHeader = True
            End If

        Close ResourceFile
    Exit Function

ErrHandler:
        Close ResourceFile

        Call MsgBox("Error al intentar leer el archivo " & ResourceFilePath & ". Raz?n: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error")
    End Function

    Private Function BinarySearch(ByRef ResourceFile As Integer, ByRef InfoHead As INFOHEADER, ByVal FirstHead As Long, ByVal LastHead As Long, ByVal FileHeaderSize As Long, ByVal InfoHeaderSize As Long) As Boolean
    '*****************************************************************
    'Author: Nicolas Matias Gonzalez (NIGO)
    'Last Modify Date: 08/21/2007
    'Searches for the specified InfoHeader
    '*****************************************************************
        Dim ReadingHead As Long
        Dim ReadInfoHead As INFOHEADER

        Do Until FirstHead > LastHead
            ReadingHead = (FirstHead + LastHead) \ 2

            Get ResourceFile, FileHeaderSize + InfoHeaderSize * (ReadingHead - 1) + 1, ReadInfoHead
            Debug.Print ReadInfoHead.strFileName
            If InfoHead.strFileName = ReadInfoHead.strFileName Then
                InfoHead = ReadInfoHead
                BinarySearch = True
                Exit Function
            Else
                If InfoHead.strFileName < ReadInfoHead.strFileName Then
                    LastHead = ReadingHead - 1
                Else
                    FirstHead = ReadingHead + 1
                End If
            End If
        Loop
    End Function
