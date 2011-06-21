Attribute VB_Name = "Cuerpos"

'Posicion en un mapa
Public Type Position
    X As Integer
    Y As Integer
End Type

Public Type tIndiceCuerpoInt
    Body(1 To 4) As Integer
    HeadOffsetX As Integer
    HeadOffsetY As Integer
End Type

Public Type tIndiceCuerpo
    Body(1 To 4) As Long
    HeadOffsetX As Integer
    HeadOffsetY As Integer
End Type

'Lista de cuerpos
Public Type BodyData
    Walk(1 To 4) As GRH
    HeadOffset As Position
End Type

Public Type BodyDataInt
    Walk(1 To 4) As GRHint
    HeadOffset As Position
End Type

Public BodyData() As BodyData
Public BodyDataInt() As BodyDataInt

Public NumCuerpos As Integer


Sub CargarCuerpos()
On Error Resume Next
Dim n As Integer, i As Integer
If UsarGrhLong = False Then
    Dim MisCuerposInt() As tIndiceCuerpoInt
Else
    Dim MisCuerpos() As tIndiceCuerpo
End If

n = FreeFile
If UsarIndex = False Then
    Open DirClien & "\INIT\Personajes.ind" For Binary Access Read As #n
Else
    Open DirIndex & "\Personajes.ind" For Binary Access Read As #n
End If

'cabecera
Get #n, , MiCabecera

'num de cabezas
Get #n, , NumCuerpos

'Resize array
ReDim BodyData(0 To NumCuerpos + 1) As BodyData
ReDim MisCuerpos(0 To NumCuerpos + 1) As tIndiceCuerpo

If UsarGrhLong = False Then
    ReDim BodyDataInt(0 To NumCuerpos + 1) As BodyDataInt
    ReDim MisCuerposInt(0 To NumCuerpos + 1) As tIndiceCuerpoInt
End If

For i = 1 To NumCuerpos

        Get #n, , MisCuerposInt(i)
        'MisCuerpos(i) = MisCuerposInt(i)
        MisCuerpos(i).Body(1) = MisCuerposInt(i).Body(1)
        MisCuerpos(i).Body(2) = MisCuerposInt(i).Body(2)
        MisCuerpos(i).Body(3) = MisCuerposInt(i).Body(3)
        MisCuerpos(i).Body(4) = MisCuerposInt(i).Body(4)
        MisCuerpos(i).HeadOffsetX = MisCuerposInt(i).HeadOffsetX
        MisCuerpos(i).HeadOffsetY = MisCuerposInt(i).HeadOffsetY
        
        InitGrh BodyData(i).Walk(1), MisCuerpos(i).Body(1), 0
        InitGrh BodyData(i).Walk(2), MisCuerpos(i).Body(2), 0
        InitGrh BodyData(i).Walk(3), MisCuerpos(i).Body(3), 0
        InitGrh BodyData(i).Walk(4), MisCuerpos(i).Body(4), 0
        BodyData(i).HeadOffset.X = MisCuerpos(i).HeadOffsetX
        BodyData(i).HeadOffset.Y = MisCuerpos(i).HeadOffsetY
Next i

Close #n

End Sub
