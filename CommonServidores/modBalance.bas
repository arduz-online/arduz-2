Attribute VB_Name = "modBalance"
Option Explicit

Public balance_md5 As String * 32

Public public_pjs(1 To 8) As webpj

Sub LoadBalance()
    Dim i As Long
    
    'Modificadores de Clase
    'For i = 1 To NUMCLASES
    '.Evasion = Val(GetVar(DatPath & "Balance.dat", "MODEVASION", ListaClases(i)))
    '.AtaqueArmas = Val(GetVar(DatPath & "Balance.dat", "MODATAQUEARMAS", ListaClases(i)))
    '.AtaqueProyectiles = Val(GetVar(DatPath & "Balance.dat", "MODATAQUEPROYECTILES", ListaClases(i)))
    '.DañoArmas = Val(GetVar(DatPath & "Balance.dat", "MODDAÑOARMAS", ListaClases(i)))
    '.DañoProyectiles = Val(GetVar(DatPath & "Balance.dat", "MODDAÑOPROYECTILES", ListaClases(i)))
    '.DañoWrestling = Val(GetVar(DatPath & "Balance.dat", "MODDAÑOWRESTLING", ListaClases(i)))
    '.Escudo = Val(GetVar(DatPath & "Balance.dat", "MODESCUDO", ListaClases(i)))
    'Next i
    
        i = eClass.Warrior
        With bClases(i).ModBalances
            .Evasion = 1
            .AtaqueArmas = 1
            .AtaqueProyectiles = 0.65
            .DañoArmas = 1.1
            .DañoProyectiles = 0.8
            .DañoWrestling = 0.1
            .Escudo = 0.8
        End With
        bClases(i).magia = 1
        
        i = eClass.Hunter
        With bClases(i).ModBalances
            .Evasion = 0.9
            .AtaqueArmas = 0.8
            .AtaqueProyectiles = 1.1
            .DañoArmas = 0.9
            .DañoProyectiles = 1.1
            .Escudo = 0.72
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1
        
        i = eClass.Paladin
        With bClases(i).ModBalances
            .Evasion = 0.85
            .AtaqueArmas = 0.85
            .AtaqueProyectiles = 0.75
            .DañoArmas = 0.9
            .DañoProyectiles = 0.8
            .Escudo = 1
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1
        
        i = eClass.Assasin
        With bClases(i).ModBalances
            .Evasion = 1.1
            .AtaqueArmas = 0.85
            .AtaqueProyectiles = 0.75
            .DañoArmas = 0.9
            .DañoProyectiles = 0.8
            .Escudo = 0.7
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1
        
        
        i = eClass.Bard
        With bClases(i).ModBalances
            .Evasion = 1.1
            .AtaqueArmas = 0.75
            .AtaqueProyectiles = 0.7
            .DañoArmas = 0.75
            .DañoProyectiles = 0.7
            .Escudo = 0.65
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1.12
        
        i = eClass.Cleric
        With bClases(i).ModBalances
            .Evasion = 0.81
            .AtaqueArmas = 0.85
            .AtaqueProyectiles = 0.7
            .DañoArmas = 0.85
            .DañoProyectiles = 0.7
            .Escudo = 0.8
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1.1
        
        i = eClass.Druid
        With bClases(i).ModBalances
            .Evasion = 0.85
            .AtaqueArmas = 0.6
            .AtaqueProyectiles = 0.7
            .DañoArmas = 0.7
            .DañoProyectiles = 0.7
            .Escudo = 0.6
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1.14
        
        i = eClass.Mage
        With bClases(i).ModBalances
            .Evasion = 0.7
            .AtaqueArmas = 0.5
            .AtaqueProyectiles = 0.5
            .DañoArmas = 0.5
            .DañoProyectiles = 0.6
            .Escudo = 0.6
            .DañoWrestling = 0.1
        End With
        bClases(i).magia = 1
    'Modificadores de Raza
    
    bRazas(eRaza.Humano).Atributos.Fuerza = 20
    bRazas(eRaza.Humano).Atributos.Agilidad = 20
    bRazas(eRaza.Humano).Atributos.Inteligencia = 0
    bRazas(eRaza.Humano).Atributos.Carisma = 0
    bRazas(eRaza.Humano).Atributos.Constitucion = 2
    
    bRazas(eRaza.Drow).Atributos.Fuerza = 20
    bRazas(eRaza.Drow).Atributos.Agilidad = 20
    bRazas(eRaza.Drow).Atributos.Inteligencia = 2
    bRazas(eRaza.Drow).Atributos.Carisma = -3
    bRazas(eRaza.Drow).Atributos.Constitucion = 1
    
    bRazas(eRaza.Elfo).Atributos.Fuerza = 18
    bRazas(eRaza.Elfo).Atributos.Agilidad = 20
    bRazas(eRaza.Elfo).Atributos.Inteligencia = 2
    bRazas(eRaza.Elfo).Atributos.Carisma = 2
    bRazas(eRaza.Elfo).Atributos.Constitucion = 1
    
    bRazas(eRaza.Gnomo).Atributos.Fuerza = 10
    bRazas(eRaza.Gnomo).Atributos.Agilidad = 20
    bRazas(eRaza.Gnomo).Atributos.Inteligencia = 3
    bRazas(eRaza.Gnomo).Atributos.Carisma = 1
    bRazas(eRaza.Gnomo).Atributos.Constitucion = -2
    
    bRazas(eRaza.Enano).Atributos.Fuerza = 20
    bRazas(eRaza.Enano).Atributos.Agilidad = 18
    bRazas(eRaza.Enano).Atributos.Inteligencia = -6
    bRazas(eRaza.Enano).Atributos.Carisma = -2
    bRazas(eRaza.Enano).Atributos.Constitucion = 3
    
    With public_pjs(1)
        .clase = eClass.Mage
        .raza = eRaza.Humano
        .items_count = push_object(.items(), 37, 38, 986, 660, 662)
        .clan = "Mago humano"
    End With
    With public_pjs(2)
        .raza = eRaza.Elfo
        .clase = eClass.Bard
        .items_count = push_object(.items(), 37, 38, 986, 404, 132, 696, 365) '339
        .clan = "Bardo elfo"
    End With
    With public_pjs(3)
        .raza = eRaza.Elfo
        .clase = eClass.Druid
        .items_count = push_object(.items(), 37, 38, 986, 365, 208)
        .clan = "Druida elfo"
    End With
    With public_pjs(4)
        .clase = eClass.Cleric
        .raza = eRaza.Drow
        .items_count = push_object(.items(), 37, 38, 986, 128, 131, 129, 365)
        .clan = "Clérigo drow"
    End With
    With public_pjs(5)
        .clase = eClass.Paladin
        .raza = eRaza.Humano
        .items_count = push_object(.items(), 37, 38, 359, 128, 131, 129, 365)
        .clan = "Paladín humano"
    End With
    With public_pjs(6)
        .clase = eClass.Assasin
        .raza = eRaza.Drow
        .items_count = push_object(.items(), 37, 38, 986, 404, 131, 399, 367)
        .clan = "Asesino drow"
    End With
    With public_pjs(7)
        .clase = eClass.Warrior
        .raza = eRaza.Enano
        .items_count = push_object(.items(), 37, 38, 243, 128, 131, 479, 480, 129, 164)
        .clan = "Guerrero enano"
    End With
    With public_pjs(8)
        .clase = eClass.Hunter
        .raza = eRaza.Humano
        .items_count = push_object(.items(), 38, 359, 404, 132, 553, 665, 365)
        .clan = "Arquero humano"
    End With
    For i = 1 To 8
        public_pjs(i).genero = Hombre
        dcyc public_pjs(i)
    Next i
    
    reload_balancea

End Sub

Private Function push_object(inv() As UserOBJ, ParamArray objetos()) As Integer
On Error Resume Next
Dim i As Integer
For i = 1 To UBound(objetos) + 1
inv(i).ObjIndex = objetos(i - 1)
inv(i).Amount = 1
Next i
push_object = UBound(objetos) + 1
End Function

Sub dcyc(pj As webpj)
'
'Author: Nacho (Integer)
'Last modified: 14/03/2007
'Elije una cabeza para el usuario y le da un body
'
Dim NewBody As Integer
Dim NewHead As Integer
Dim UserRaza As Byte
Dim UserGenero As Byte
UserGenero = pj.genero
UserRaza = pj.raza
Select Case UserGenero
   Case eGenero.Hombre
        Select Case UserRaza
            Case eRaza.Humano
                NewHead = RandomNumber(1, 38)
                NewBody = 1
            Case eRaza.Elfo
                NewHead = RandomNumber(101, 112)
                NewBody = 2
            Case eRaza.Drow
                NewHead = RandomNumber(200, 210)
                NewBody = 3
            Case eRaza.Enano
                NewHead = RandomNumber(300, 306)
                NewBody = 300
            Case eRaza.Gnomo
                NewHead = RandomNumber(401, 406)
                NewBody = 300
        End Select
   Case eGenero.Mujer
        Select Case UserRaza
            Case eRaza.Humano
                NewHead = RandomNumber(70, 79)
                NewBody = 1
            Case eRaza.Elfo
                NewHead = RandomNumber(170, 178)
                NewBody = 2
            Case eRaza.Drow
                NewHead = RandomNumber(270, 278)
                NewBody = 3
            Case eRaza.Gnomo
                NewHead = RandomNumber(370, 372)
                NewBody = 300
            Case eRaza.Enano
                NewHead = RandomNumber(470, 476)
                NewBody = 300
        End Select
End Select
Dim CuerpoDesnudo As Integer
Select Case UserGenero
    Case eGenero.Hombre
        Select Case UserRaza
            Case eRaza.Humano
                CuerpoDesnudo = 21
            Case eRaza.Drow
                CuerpoDesnudo = 32
            Case eRaza.Elfo
                CuerpoDesnudo = 210
            Case eRaza.Gnomo
                CuerpoDesnudo = 222
            Case eRaza.Enano
                CuerpoDesnudo = 53
        End Select
    Case eGenero.Mujer
        Select Case UserRaza
            Case eRaza.Humano
                CuerpoDesnudo = 39
            Case eRaza.Drow
                CuerpoDesnudo = 40
            Case eRaza.Elfo
                CuerpoDesnudo = 259
            Case eRaza.Gnomo
                CuerpoDesnudo = 260
            Case eRaza.Enano
                CuerpoDesnudo = 60
        End Select
End Select
pj.cabeza = NewHead
pj.cuerpo = CuerpoDesnudo
End Sub



Public Sub seleccionar_pj_pelado(ByVal UserIndex As Integer, ByVal pelado As Integer)

End Sub


Public Function reload_balancea()
Dim t As String
t = Resource_Read_sdf(app.Path & "\Datos\DatosServer\", "balance.ini")
pharse_balance t
End Function

Public Function pharse_balance(t As String)
Debug.Print "ACT-BALANCE:" & balance_md5
balance_md5 = MD5String(t)
Debug.Print "NWE-BALANCE:" & balance_md5



Dim partes() As String
Dim tmp As String
Dim inta As Integer, inte As Integer, raza As Integer, indexa As Integer, value As Single

On Error Resume Next

partes = Split(t, "|")
Dim i As Integer
For i = LBound(partes) To UBound(partes)
    tmp = partes(i)
    If Len(tmp) < 4 Then GoTo asd
    inta = ReadBDel(tmp) 'Mod 11
    raza = ReadBDel(tmp) 'Mod 6
    inte = ReadBDel(tmp)
    indexa = ReadBDel(tmp)
    
    If raza = 0 Then LogGM "balanced", "ARCHIVO DE BALANCE CORRUPTO RAZA=0." & t
    
    value = CCVal(Right(partes(i), Len(partes(i)) - 4))
    
    If inta > 0 Then
        Select Case inte
        Case 1
            bClases(inta).UserHechizos(indexa) = value
        Case 2
            bClases(inta).Mana(raza) = value
        Case 3
            bClases(inta).vida(raza) = value
            If value = 0 Then LogGM "balanced", "ARCHIVO DE BALANCE CORRUPTO." & t
        Case 4
            bClases(inta).max_hit(raza) = value
        Case 5
            bClases(inta).min_hit(raza) = value
        Case 6
            bClases(inta).intervalos(indexa - 1) = value
        Case 7
            Select Case indexa
                Case 1: bClases(inta).ModBalances.Evasion = value
                Case 2: bClases(inta).ModBalances.AtaqueArmas = value
                Case 3: bClases(inta).ModBalances.AtaqueProyectiles = value
                Case 4: bClases(inta).ModBalances.DañoArmas = value
                Case 5: bClases(inta).ModBalances.DañoProyectiles = value
                Case 6: bClases(inta).ModBalances.DañoWrestling = value
                Case 7: bClases(inta).ModBalances.Escudo = value
            End Select
        Case 8
            If value > 0 Then bClases(inta).magia = value
        Case Else
        LogGM "balanced", "EROOOOR " & partes(i)
        End Select
        'LogGM "balanced", inta & " " & raza & " " & inte & "=" & value
    End If
asd:
Next i
LogGM "balanced", "Se leyó el balance """ & balance_md5 & """"
LogCriticEvent "Se leyó el balance """ & balance_md5 & """"
End Function

Private Function ReadBDel(ByRef t As String) As Integer
On Error Resume Next
    ReadBDel = Asc(t)
    t = Right$(t, Len(t) - 1)
    ReadBDel = ReadBDel - 64
End Function

