Attribute VB_Name = "Cabezas"
' [GS] Cabezas

'Lista de cabezas
Public Type tIndiceCabeza
    Head(1 To 4) As Long
End Type

Public Type tIndiceCabezaInt
    Head(1 To 4) As Integer
End Type

'Lista de cabezas
Public Type HeadData
    Head(1 To 4) As GRH
End Type

Public Type HeadDataInt
    Head(1 To 4) As GRHint
End Type

Public NumHeads As Integer
Public HeadData() As HeadData
Public HeadDataInt() As HeadDataInt


Sub CargarCabezas()
'On Error Resume Next
Dim n As Integer, i As Integer, Index As Integer

Dim MisCabezas() As tIndiceCabeza
If UsarGrhLong = False Then
    Dim MisCabezasInt() As tIndiceCabezaInt
End If

n = FreeFile
If UsarIndex = False Then
    Open DirClien & "\INIT\Cabezas.ind" For Binary Access Read As #n
Else
    Open DirIndex & "\Cabezas.ind" For Binary Access Read As #n
End If

'cabecera
Get #n, , MiCabecera

'num de cabezas
Get #n, , NumHeads



'Resize array
ReDim HeadData(0 To NumHeads + 1) As HeadData
ReDim MisCabezas(0 To NumHeads + 1) As tIndiceCabeza
If UsarGrhLong = False Then
    ReDim HeadDataInt(0 To NumHeads + 1) As HeadDataInt
    ReDim MisCabezasInt(0 To NumHeads + 1) As tIndiceCabezaInt
End If

For i = 1 To NumHeads
    If UsarGrhLong = True Then
        Get #n, , MisCabezas(i)
        
    Else
        Get #n, , MisCabezasInt(i)
        MisCabezas(i).Head(1) = MisCabezasInt(i).Head(1)
        MisCabezas(i).Head(2) = MisCabezasInt(i).Head(2)
        MisCabezas(i).Head(3) = MisCabezasInt(i).Head(3)
        MisCabezas(i).Head(4) = MisCabezasInt(i).Head(4)
    End If
    InitGrh HeadData(i).Head(1), MisCabezas(i).Head(1), 0
    InitGrh HeadData(i).Head(2), MisCabezas(i).Head(2), 0
    InitGrh HeadData(i).Head(3), MisCabezas(i).Head(3), 0
    InitGrh HeadData(i).Head(4), MisCabezas(i).Head(4), 0
Next i

Close #n

End Sub
