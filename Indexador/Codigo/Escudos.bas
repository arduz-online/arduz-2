Attribute VB_Name = "Escudos"

'Lista de las animaciones de los escudos
Type ShieldAnimData
    ShieldWalk(1 To 4) As GRH
End Type

Public NumEscudosAnims As Integer
Public ShieldAnimData() As ShieldAnimData


Sub CargarAnimEscudos()

On Error Resume Next

Dim loopc As Integer
Dim Arch As String
If UsarIndex = False Then
    Arch = DirClien & "\INIT\escudos.dat"
Else
    Arch = DirIndex & "\escudos.dat"
End If
DoEvents

NumEscudosAnims = Val(GetVar(Arch, "INIT", "NumEscudos"))

ReDim ShieldAnimData(1 To NumEscudosAnims) As ShieldAnimData

For loopc = 1 To NumEscudosAnims
    InitGrh ShieldAnimData(loopc).ShieldWalk(1), Val(GetVar(Arch, "ESC" & loopc, "Dir1")), 0
    InitGrh ShieldAnimData(loopc).ShieldWalk(2), Val(GetVar(Arch, "ESC" & loopc, "Dir2")), 0
    InitGrh ShieldAnimData(loopc).ShieldWalk(3), Val(GetVar(Arch, "ESC" & loopc, "Dir3")), 0
    InitGrh ShieldAnimData(loopc).ShieldWalk(4), Val(GetVar(Arch, "ESC" & loopc, "Dir4")), 0
Next loopc

End Sub
