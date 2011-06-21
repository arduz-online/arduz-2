Attribute VB_Name = "Cascos"
Public MisCabezas() As tIndiceCabeza
Public CascoAnimData() As HeadData
Public MisCabezasInt() As tIndiceCabezaInt
Public CascoAnimDataInt() As HeadDataInt
Public NumCascos As Integer

Sub CargarCascos()
On Error Resume Next
Dim n As Integer, i As Integer, Index As Integer


n = FreeFile
If UsarIndex = False Then
    Open DirClien & "\INIT\Cascos.ind" For Binary Access Read As #n
Else
    Open DirIndex & "\Cascos.ind" For Binary Access Read As #n
End If

'cabecera
Get #n, , MiCabecera

'num de cabezas
Get #n, , NumCascos

'Resize array
ReDim CascoAnimData(0 To NumCascos + 1) As HeadData
ReDim MisCabezas(0 To NumCascos + 1) As tIndiceCabeza
If UsarGrhLong = False Then
    ReDim CascoAnimDataInt(0 To NumCascos + 1) As HeadDataInt
    ReDim MisCabezasInt(0 To NumCascos + 1) As tIndiceCabezaInt
End If

For i = 1 To NumCascos
    If UsarGrhLong = True Then
        Get #n, , MisCabezas(i)
    Else
        Get #n, , MisCabezasInt(i)
        MisCabezas(i).Head(1) = MisCabezasInt(i).Head(1)
        MisCabezas(i).Head(2) = MisCabezasInt(i).Head(2)
        MisCabezas(i).Head(3) = MisCabezasInt(i).Head(3)
        MisCabezas(i).Head(4) = MisCabezasInt(i).Head(4)
    End If
    InitGrh CascoAnimData(i).Head(1), MisCabezas(i).Head(1), 0
    InitGrh CascoAnimData(i).Head(2), MisCabezas(i).Head(2), 0
    InitGrh CascoAnimData(i).Head(3), MisCabezas(i).Head(3), 0
    InitGrh CascoAnimData(i).Head(4), MisCabezas(i).Head(4), 0
Next i

Close #n

End Sub
