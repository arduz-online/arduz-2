VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsZLib"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
'Private Declare Function compress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Private Declare Function compress2 Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long, ByVal level As Long) As Long
Private Declare Function uncompress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

Private Const m_def_CompressedSize = 0
Private Const m_def_OriginalSize = 0

Private m_CompressedSize As Long
Private m_OriginalSize As Long





Public Function CompressByteArray(TheData() As Byte, ByVal CompressionLevel As CompressionLevels) As Long
    Dim Result          As Long
    Dim BufferSize      As Long
    Dim TempBuffer()    As Byte
    
    OriginalSize = UBound(TheData) + 1
    
    '//-- Allocate memory for byte array
    BufferSize = UBound(TheData) + 1
    BufferSize = BufferSize + (BufferSize * 0.01) + 12
    ReDim TempBuffer(BufferSize)
    
    '//-- Compress byte array (data)
    Result = compress2(TempBuffer(0), BufferSize, TheData(0), UBound(TheData) + 1, CompressionLevel)
    
    '//-- Truncate to compressed size
    ReDim Preserve TheData(BufferSize - 1)
    CopyMemory TheData(0), TempBuffer(0), BufferSize
    
    '//-- Cleanup
    Erase TempBuffer
    
    '//-- Set property
    CompressedSize = UBound(TheData) + 1
    
    '//-- Return Error/Success
    CompressByteArray = Result

End Function


Public Function CompressString(TheString As String, ByVal CompressionLevel As CompressionLevels) As Long
    Dim orgSize     As Long
    Dim Result         As Long
    
    OriginalSize = Len(TheString)
    
    '//-- Allocate string space for the buffers
    Dim CmpSize As Long
    Dim TBuff As String
    
    orgSize = Len(TheString)
    TBuff = String(orgSize + (orgSize * 0.01) + 12, 0)
    CmpSize = Len(TBuff)
    
    '//-- Compress string (temporary string buffer) data
    Result = compress2(ByVal TBuff, CmpSize, ByVal TheString, Len(TheString), CompressionLevel)
    
    '//-- Crop the string and set it to the actual string.
    TheString = Left$(TBuff, CmpSize)
    
    '//-- Set compressed size of string.
    CompressedSize = CmpSize
    
    '//-- Cleanup
    TBuff = ""
    
    '//-- Return Error/Success
    CompressString = Result

End Function



Public Function DecompressByteArray(TheData() As Byte, ByVal OrigSize As Long) As Long
    Dim Result As Long
    
    '//-- Allocate memory for buffers
    Dim BufferSize As Long
    Dim TempBuffer() As Byte
    
    OriginalSize = OrigSize
    CompressedSize = UBound(TheData) + 1
    
    BufferSize = OrigSize
    BufferSize = BufferSize + (BufferSize * 0.01) + 12
    ReDim TempBuffer(BufferSize)
    
    '//-- Decompress Data
    Result = uncompress(TempBuffer(0), BufferSize, TheData(0), UBound(TheData) + 1)
    
    '//-- Truncate buffer to compressed size
    ReDim Preserve TheData(BufferSize - 1)
    CopyMemory TheData(0), TempBuffer(0), BufferSize
    
    '//-- Return Error/Success
    DecompressByteArray = Result
    
End Function


Public Function DecompressString(TheString As String, ByVal OrigSize As Long) As Long
    Dim Result As Long
    
    '//-- Allocate string space
    Dim CmpSize As Long
    Dim TBuff As String
    
    '//-- Set OriginalSize property
    OriginalSize = OrigSize
    
    TBuff = String(OriginalSize + (OriginalSize * 0.01) + 12, 0)
    CmpSize = Len(TBuff)
    
    '//-- Decompress
    Result = uncompress(ByVal TBuff, CmpSize, ByVal TheString, Len(TheString))
    
    '//-- Make string the size of the uncompressed string
    TheString = Left$(TBuff, CmpSize)
    
    CompressedSize = CmpSize
    
    '//-- Return Error/Success
    DecompressString = Result

End Function


Public Function CompressFile(ByVal FilePathIn As String, ByVal FilePathOut As String, ByVal CompressionLevel As CompressionLevels) As Long
    Dim TheBytes()  As Byte
    Dim Result      As Long
    Dim lngFileLen  As Long
    
    lngFileLen = FileLen(FilePathIn)
    
    '//-- allocate byte array
    ReDim TheBytes(lngFileLen - 1)
    
    '//-- read byte array from file
    Open FilePathIn For Binary Access Read As #1
        Get #1, , TheBytes()
    Close #1
    
    '//-- compress byte array
    Result = CompressByteArray(TheBytes(), CompressionLevel)
    
    '//-- kill any file in place
    On Error Resume Next
    
    Kill FilePathOut
    On Error GoTo 0
    
    '//-- Write it out
    Open FilePathOut For Binary Access Write As #1
        Put #1, , lngFileLen 'must store the length of the original file
        Put #1, , TheBytes()
    Close #1
    
    '//-- Clean up
    Erase TheBytes
    CompressFile = Result

End Function


Public Function DecompressFile(ByVal FilePathIn As String, ByVal FilePathOut As String) As Long
    Dim TheBytes()  As Byte
    Dim Result      As Long
    Dim lngFileLen  As Long
    
    '//-- Allocate byte array
    ReDim TheBytes(FileLen(FilePathIn) - 1)
    
    '//-- Read byte array from file
    Open FilePathIn For Binary Access Read As #1
        Get #1, , lngFileLen    '//-- the original (uncompressed) file's length
        Get #1, , TheBytes()
    Close #1
    
    '//-- Decompress
    Result = DecompressByteArray(TheBytes(), lngFileLen)
    
    '//-- kill any file already there
    On Error Resume Next
    Kill FilePathOut
    On Error GoTo 0
    
    '//-- Write it out
    Open FilePathOut For Binary Access Write As #1
        Put #1, , TheBytes()
    Close #1
    
    '//-- Clean Up
    Erase TheBytes
    DecompressFile = Result

End Function

Public Property Get CompressedSize() As Long
    CompressedSize = m_CompressedSize
End Property

Private Property Let CompressedSize(ByVal New_CompressedSize As Long)
    m_CompressedSize = New_CompressedSize
    
End Property

Public Property Get OriginalSize() As Long
    OriginalSize = m_OriginalSize
    
End Property

Private Property Let OriginalSize(ByVal New_OriginalSize As Long)
    m_OriginalSize = New_OriginalSize
    
End Property

Private Sub Class_Initialize()
    m_CompressedSize = m_def_CompressedSize
    m_OriginalSize = m_def_OriginalSize
End Sub
