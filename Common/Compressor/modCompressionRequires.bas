Attribute VB_Name = "modEENESARIO"
Option Explicit
'To get free bytes in drive
Private Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceExA" (ByVal lpRootPathName As String, FreeBytesToCaller As Currency, BytesTotal As Currency, FreeBytesTotal As Currency) As Long

'To get free bytes in RAM

Private Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Const MAX_LENGTH = 512

Private pUdtMemStatus As MEMORYSTATUS

Private Type MEMORYSTATUS
    dwLength As Long
    dwMemoryLoad As Long
    dwTotalPhys As Long
    dwAvailPhys As Long
    dwTotalPageFile As Long
    dwAvailPageFile As Long
    dwTotalVirtual As Long
    dwAvailVirtual As Long
End Type

Private Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)

Public Windows_Temp_Dir As String
Public Win2kXP As Boolean

Public PreloadLevel As Integer
Public modProgress As Single

Public Sub General_Quick_Sort(ByRef SortArray As Variant, ByVal first As Long, ByVal last As Long)
'**************************************************************
'Author: juan Martín Sotuyo Dodero
'Last Modify Date: 3/03/2005
'Good old QuickSort algorithm :)
'**************************************************************
    Dim Low As Long, High As Long
    Dim temp As Variant
    Dim List_Separator As Variant
    
    Low = first
    High = last
    List_Separator = SortArray((first + last) / 2)
    Do While (Low <= High)
        Do While SortArray(Low) < List_Separator
            Low = Low + 1
        Loop
        Do While SortArray(High) > List_Separator
            High = High - 1
        Loop
        If Low <= High Then
            temp = SortArray(Low)
            SortArray(Low) = SortArray(High)
            SortArray(High) = temp
            Low = Low + 1
            High = High - 1
        End If
    Loop
    If first < High Then General_Quick_Sort SortArray, first, High
    If Low < last Then General_Quick_Sort SortArray, Low, last
End Sub


Public Function General_Get_Temp_Dir() As String
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 6/11/2005
'Gets windows temporary directory
'**************************************************************
   Dim s As String
   Dim C As Long
   s = Space$(MAX_LENGTH)
   C = GetTempPath(MAX_LENGTH, s)
   If C > 0 Then
       If C > Len(s) Then
           s = Space$(C + 1)
           C = GetTempPath(MAX_LENGTH, s)
       End If
   End If
   General_Get_Temp_Dir = IIf(C > 0, Left$(s, C), "")
End Function

Public Function General_Load_Picture_From_Resource(ByVal picture_file_name As String) As IPictureDisp
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 6/11/2005
'Loads a picture from a resource file and returns it
'**************************************************************

'On Error GoTo ErrorHandler
If Windows_Temp_Dir = "" Then Windows_Temp_Dir = General_Get_Temp_Dir
If FileExist(Windows_Temp_Dir & picture_file_name, vbNormal) = 0 Then
If modCompression.Extract_File(Interface, App.Path & "\Datos\", picture_file_name, Windows_Temp_Dir, False) Then
    Set General_Load_Picture_From_Resource = LoadPicture(Windows_Temp_Dir & picture_file_name)
    Debug.Print Windows_Temp_Dir & picture_file_name
    'Call Delete_File(Windows_Temp_Dir & picture_file_name)
Else
    Set General_Load_Picture_From_Resource = Nothing
End If
Else
Set General_Load_Picture_From_Resource = LoadPicture(Windows_Temp_Dir & picture_file_name)
End If
Exit Function

ErrorHandler:
    If FileExist(Windows_Temp_Dir & picture_file_name, vbNormal) Then
        Call Delete_File(Windows_Temp_Dir & picture_file_name)
    End If

End Function
Public Function General_Load_Picture_From_Resource1(ByVal picture_file_name As String) As IPictureDisp
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 6/11/2005
'Loads a picture from a resource file and returns it
'**************************************************************

'On Error GoTo ErrorHandler
If Windows_Temp_Dir = "" Then Windows_Temp_Dir = General_Get_Temp_Dir
If FileExist(Windows_Temp_Dir & picture_file_name, vbNormal) = 0 Then
If modCompression.Extract_File(Graphics, App.Path & "\Datos\", picture_file_name, Windows_Temp_Dir, False) Then
    Set General_Load_Picture_From_Resource1 = LoadPicture(Windows_Temp_Dir & picture_file_name)
    Debug.Print Windows_Temp_Dir & picture_file_name
    'Call Delete_File(Windows_Temp_Dir & picture_file_name)
Else
    Set General_Load_Picture_From_Resource1 = Nothing
End If
Else
Set General_Load_Picture_From_Resource1 = LoadPicture(Windows_Temp_Dir & picture_file_name)
End If
Exit Function

ErrorHandler:
    If FileExist(Windows_Temp_Dir & picture_file_name, vbNormal) Then
        Call Delete_File(Windows_Temp_Dir & picture_file_name)
    End If

End Function
Public Function General_Bytes_To_Megabytes(Bytes As Double) As Double
Dim dblAns As Double
dblAns = (Bytes / 1024) / 1024
General_Bytes_To_Megabytes = Format(dblAns, "###,###,##0.00")
End Function

Public Function General_Get_Total_Ram() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwTotalPhys
    General_Get_Total_Ram = General_Bytes_To_Megabytes(dblAns)
End Function

Public Function General_Get_Free_Ram() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwAvailPhys
    General_Get_Free_Ram = General_Bytes_To_Megabytes(dblAns)
End Function

Public Function General_Get_Free_Ram_Bytes() As Long
    GlobalMemoryStatus pUdtMemStatus
    General_Get_Free_Ram_Bytes = pUdtMemStatus.dwAvailPhys
End Function

Public Function General_Get_Page_File_Size() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwTotalPageFile
    General_Get_Page_File_Size = General_Bytes_To_Megabytes(dblAns)
End Function

Public Function General_Drive_Get_Free_Bytes(ByVal DriveName As String) As Currency
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 6/07/2004
'
'**************************************************************
    Dim RetVal As Long
    Dim FB As Currency
    Dim BT As Currency
    Dim FBT As Currency
    
    RetVal = GetDiskFreeSpace(Left(DriveName, 2), FB, BT, FBT)
    
    General_Drive_Get_Free_Bytes = FB * 10000 'convert result to actual size in bytes
End Function
