Attribute VB_Name = "Armas"
'Lista de las animaciones de las armas
Type WeaponAnimData
    WeaponWalk(1 To 4) As GRH
End Type

Public NumWeaponAnims As Integer
Public WeaponAnimData() As WeaponAnimData

Sub CargarAnimArmas()

On Error Resume Next

Dim loopc As Integer
Dim Arch As String
If UsarIndex = False Then
    Arch = DirClien & "\INIT\Armas.dat"
Else
    Arch = DirIndex & "\Armas.dat"
End If
DoEvents

NumWeaponAnims = Val(GetVar(Arch, "INIT", "NumArmas"))

ReDim WeaponAnimData(1 To NumWeaponAnims) As WeaponAnimData

For loopc = 1 To NumWeaponAnims
    InitGrh WeaponAnimData(loopc).WeaponWalk(1), Val(GetVar(Arch, "ARMA" & loopc, "Dir1")), 0
    InitGrh WeaponAnimData(loopc).WeaponWalk(2), Val(GetVar(Arch, "ARMA" & loopc, "Dir2")), 0
    InitGrh WeaponAnimData(loopc).WeaponWalk(3), Val(GetVar(Arch, "ARMA" & loopc, "Dir3")), 0
    InitGrh WeaponAnimData(loopc).WeaponWalk(4), Val(GetVar(Arch, "ARMA" & loopc, "Dir4")), 0
Next loopc

End Sub
