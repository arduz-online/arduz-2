Attribute VB_Name = "Declaraciones"

Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Public Const SW_NORMAL = 1

'apunta a una estructura grhdata y mantiene la animacion
Public Type GRH
    GrhIndex As Long
    FrameCounter As Single
    SpeedCounter As Byte
    Started As Byte
End Type



Public Type GRHint
    GrhIndex As Integer
    FrameCounter As Byte
    SpeedCounter As Byte
    Started As Byte
End Type

Public MaxGRH As Long ' gs-long

Public grhCount As Long
Public fileVersion As Long

Public MiCabecera As tCabecera

Public Type tCabecera 'Cabecera de los con
    Desc As String * 255
    CRC As Long
    MagicWord As Long
End Type

Public UsarIndex As Boolean
Public DirIndex As String
Public DirExpor As String
Public DirClien As String
Public BuscaBMP As Integer
Public UsarGrhLong As Boolean

Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nsize As Long, ByVal lpfilename As String) As Long
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpString As String, ByVal lpfilename As String) As Long


Sub WriteVar(File As String, Main As String, Var As String, value As String)
'*****************************************************************
'Escribe VAR en un archivo
'*****************************************************************

WritePrivateProfileString Main, Var, value, File
    
End Sub


Function GetVar(File As String, Main As String, Var As String) As String
'*****************************************************************
'Gets a Var from a text file
'*****************************************************************

Dim l As Integer
Dim Char As String
Dim sSpaces As String ' This will hold the input that the program will retrieve
Dim szReturn As String ' This will be the defaul value if the string is not found

szReturn = ""

sSpaces = Space(5000) ' This tells the computer how long the longest string can be. If you want, you can change the number 75 to any number you wish


GetPrivateProfileString Main, Var, szReturn, sSpaces, Len(sSpaces), File

GetVar = RTrim(sSpaces)
GetVar = Left(GetVar, Len(GetVar) - 1)

End Function

Public Sub IniciarCabecera(ByRef Cabecera As tCabecera)
'Cabecera.Desc = "Argentum Online by Noland Studios. Copyright Noland-Studios 2001, pablomarquez@noland-studios.com.ar"
Cabecera.Desc = "Argentum Online by Noland-Studios. Index Programdo por ^[GS]^, gshaxor@gmail.com//www.gs-zone.com.ar"
Cabecera.CRC = Rnd * 100
Cabecera.MagicWord = Rnd * 10
End Sub

Public Function ReadField(Pos As Integer, Text As String, SepASCII As Integer) As String
'*****************************************************************
'Gets a field from a string
'*****************************************************************

Dim i As Integer
Dim LastPos As Integer
Dim CurChar As String * 1
Dim FieldNum As Integer
Dim Seperator As String

Seperator = Chr(SepASCII)
LastPos = 0
FieldNum = 0

For i = 1 To Len(Text)
    CurChar = Mid(Text, i, 1)
    If CurChar = Seperator Then
        FieldNum = FieldNum + 1
        If FieldNum = Pos Then
            ReadField = Val(Mid(Text, LastPos + 1, (InStr(LastPos + 1, Text, Seperator, vbTextCompare) - 1) - (LastPos)))
            Exit Function
        End If
        LastPos = i
    End If
Next i
FieldNum = FieldNum + 1

If FieldNum = Pos Then
    ReadField = Val(Mid(Text, LastPos + 1))
End If


End Function


Sub InitGrh(ByRef GRH As GRH, ByVal GrhIndex As Integer, Optional Started As Byte = 2)
'*****************************************************************
'Sets up a grh. MUST be done before rendering
'*****************************************************************

GRH.GrhIndex = GrhIndex

If Started = 2 Then
    If GrhData(GRH.GrhIndex).NumFrames > 1 Then
        GRH.Started = 1
    Else
        GRH.Started = 0
    End If
Else
    GRH.Started = Started
End If

GRH.FrameCounter = 1
'[CODE 000]:MatuX
'
'  La linea generaba un error en la IDE, (no ocurría debido al
' on error)
'
'   Grh.SpeedCounter = GrhData(Grh.GrhIndex).Speed
'
If GRH.GrhIndex <> 0 Then GRH.SpeedCounter = GrhData(GRH.GrhIndex).Speed
'
'[END]'

End Sub
