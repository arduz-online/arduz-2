Attribute VB_Name = "FXs"

Public Type tIndiceFx
    Animacion As Integer
    offsetx As Single
    offsety As Single
    particula As Integer
    wav As Integer
End Type

Public Type FxData
    FX As GRH
    offsetx As Single
    offsety As Single
    particula As Integer
    wav As Integer
End Type

Public Type tIndiceFxInt
    Animacion As Integer
    offsetx As Single
    offsety As Single
    particula As Integer
    wav As Integer
End Type

Public Type FxDataInt
    FX As GRHint
    offsetx As Single
    offsety As Single
    particula As Integer
    wav As Integer
End Type

Public NumFxs As Integer
Public FxData() As FxData
Public MisFxs() As tIndiceFx
Public FxDataInt() As FxDataInt
Public MisFxsInt() As tIndiceFxInt

Sub CargarFxs()
On Error Resume Next
Dim n As Integer, i As Integer

n = FreeFile
If UsarIndex = False Then
    Open DirClien & "\INIT\Fxs.ind" For Binary Access Read As #n
Else
    Open DirIndex & "\Fxs.ind" For Binary Access Read As #n
End If

'cabecera
Get #n, , MiCabecera

'num de cabezas
Get #n, , NumFxs

'Resize array
ReDim FxData(0 To NumFxs + 1) As FxData
ReDim MisFxs(0 To NumFxs + 1) As tIndiceFx
If UsarGrhLong = False Then
    ReDim FxDataInt(0 To NumFxs + 1) As FxDataInt
    ReDim MisFxsInt(0 To NumFxs + 1) As tIndiceFxInt
End If

For i = 1 To NumFxs

    Get #n, , MisFxs(i)
    Call InitGrh(FxData(i).FX, MisFxs(i).Animacion, 1)
    FxData(i).offsetx = MisFxs(i).offsetx
    FxData(i).offsety = MisFxs(i).offsety
    FxData(i).particula = MisFxs(i).particula
    FxData(i).wav = MisFxs(i).wav
    
Next i

Close #n
End Sub
