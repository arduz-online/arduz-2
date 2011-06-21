Attribute VB_Name = "modXML"
Option Explicit

Public Function Cargar_clases_Raw(ByRef data As String) As Boolean
Dim FILE As String
    Dim Buffer As String        'Just for the output text
    Dim ItemCount As Integer    'Saves redundant typing
    Dim i As Integer, j%, K%          'For the looping through items
    Dim nodo$, subnodo$, tmp$
    Dim ID As Integer
    Dim stra() As String
    FILE = GetTag(data, "Arduz_data", True)
    
    'If GetTagData(FILE, "file") = "balance" Then
        Cargar_clases_Raw = True
        
        ItemCount = GetListCount(FILE, "raza")
        For i = 1 To ItemCount
            nodo = GetNode(FILE, "raza", i)
            ID = Val(GetTag(nodo, "id"))
            With bRazas(ID)
                .nombre = GetTag(nodo, "name")
                .abr = GetTag(nodo, "abr")
                subnodo = GetTagData(nodo, "atributos")
                With .Atributos
                    .Agilidad = Val(get_label_value(subnodo, "Agilidad")(0))
                    .Fuerza = Val(get_label_value(subnodo, "Fuerza")(0))
                    .Constitucion = Val(get_label_value(subnodo, "Constitucion")(0))
                    .Inteligencia = Val(get_label_value(subnodo, "Inteligencia")(0))
                    Debug.Print .Constitucion; ID
                End With
                subnodo = GetTagData(nodo, "cabezas_hombre")
                .cabezas_min_h = Val(get_label_value(subnodo, "min")(0))
                .cabezas_max_h = Val(get_label_value(subnodo, "max")(0))
                subnodo = GetTagData(nodo, "cabezas_mujer")
                .cabezas_min_h = Val(get_label_value(subnodo, "min")(0))
                .cabezas_max_h = Val(get_label_value(subnodo, "max")(0))
                .cuerpo_hombre = Val(GetTag(nodo, "cuerpo_hombre"))
                .cuerpo_mujer = Val(GetTag(nodo, "cuerpo_mujer"))
            End With
        Next i
        
        ItemCount = GetListCount(FILE, "clase")
        For i = 1 To ItemCount
            nodo = GetNode(FILE, "clase", i)
            ID = Val(GetTag(nodo, "id"))
            With bClases(ID)
                .nombre = GetTag(nodo, "name")
                Debug.Print "Cargando " & .nombre & "..."
                
                .abr = GetTag(nodo, "abr")
                subnodo = GetTagData(nodo, "atributos")

                .ModBalances.Evasion = Val(get_label_value(subnodo, "Evasion")(0))
                .ModBalances.AtaqueArmas = Val(get_label_value(subnodo, "AtaqueArmas")(0))
                .ModBalances.AtaqueProyectiles = Val(get_label_value(subnodo, "AtaqueProyectiles")(0))
                .ModBalances.DañoArmas = Val(get_label_value(subnodo, "DañoArmas")(0))
                .ModBalances.DañoProyectiles = Val(get_label_value(subnodo, "DañoProyectiles")(0))
                .ModBalances.Escudo = Val(get_label_value(subnodo, "Escudo")(0))
                .ModBalances.DañoWrestling = Val(get_label_value(subnodo, "DañoWrestling")(0))

                
                Debug.Print "   Balance cargado."
                
                subnodo = GetTagData(nodo, "intervalos")
                .intervalos(0) = Val(get_label_value(subnodo, "ATTACK")(0))
                .intervalos(1) = Val(get_label_value(subnodo, "ARROWS")(0))
                .intervalos(2) = Val(get_label_value(subnodo, "CAST_SPELL")(0))
                .intervalos(3) = Val(get_label_value(subnodo, "CAST_ATTACK")(0))
                .intervalos(4) = Val(get_label_value(subnodo, "USEITEMU")(0))
                .intervalos(5) = Val(get_label_value(subnodo, "USEITEMDCK")(0))
                
                Debug.Print "   Intervalos cargados."
                
                For j = 1 To NUMRAZAS
                    Debug.Print "   Cargando raza " & bRazas(j).nombre
                    subnodo = GetTagData(nodo, "raza_data_" & bRazas(j).abr)
                    .mana(j) = Val(get_label_value(subnodo, "mana")(0))
                    .vida(j) = Val(get_label_value(subnodo, "vida")(0))
                    .max_hit(j) = Val(get_label_value(subnodo, "max_hit")(0))
                    .min_hit(j) = Val(get_label_value(subnodo, "min_hit")(0))
                    Debug.Print "       Stats de raza cargados."
                    subnodo = GetTagData(nodo, "inventario_" & bRazas(j).abr)
                    ReDim stra(0)
                    stra = get_label_value(subnodo, "obj")
                    If UBound(stra) > 0 And UBound(stra) < 13 Then
                        For K = 1 To UBound(stra)
                            .Object(j, K) = Val(stra(K))
                        Next K
                        Debug.Print "       Objetos de raza cargados."
                    Else
                        Debug.Print "       ERROR EN CARGAR OBJETOS."
                    End If
                Next j
                Debug.Print "   Razas cargadas."
                
                subnodo = GetTagData(nodo, "hechizos")
                ReDim stra(0)
                stra = get_label_value(subnodo, "hechizo")
                Debug.Print "   Cargando hechizos."
                If UBound(stra) > 0 And UBound(stra) < 13 Then
                    For K = 1 To UBound(stra)
                        .UserHechizos(K) = Val(stra(K))
                    Next K
                    Debug.Print "   Hechizos cargados."
                Else
                    Debug.Print "   ERROR EN CARGAR HEHIZOS."
                End If
                Debug.Print "Balance de " & .nombre & " cargado correctamente."
            End With
            
        Next i
    'Else
    '    Cargar_clases_Raw = False
    'End If
End Function

Public Function get_label_value(strSource As String, label As String) As String()
    Dim pos1 As Long
    Dim pos2 As Long
    Dim results() As String
    Dim whatsleft As String
    Dim count As Integer
    whatsleft = strSource
    ReDim Preserve results(0)
    Do While whatsleft <> ""
        pos1 = InStr(1, whatsleft, label)
        pos2 = InStr(pos1 + Len(label), whatsleft, """")

        If pos1 = 0 Or pos2 = 0 Then
            Exit Do
        End If

        ReDim Preserve results(count)
        results(count) = mid(whatsleft, pos1 + Len(label), pos2 - (pos1 + Len(label)))
        whatsleft = Right(whatsleft, Len(whatsleft) - pos2)
        count = count + 1
    Loop

    get_label_value = results
End Function

Public Function StrBetweenStrs(strSource As String, label As String, str2 As String, Optional bCaseSensitive = True) As String()
    Dim pos1 As Long
    Dim pos2 As Long
    Dim results() As String
    Dim whatsleft As String
    Dim count As Integer
    whatsleft = strSource

    Do While whatsleft <> ""
        If bCaseSensitive Then
            pos1 = InStr(1, whatsleft, label)
            pos2 = InStr(pos1 + Len(label), whatsleft, str2)
        Else
            pos1 = InStr(1, UCase(whatsleft), UCase(label))
            pos2 = InStr(pos1 + Len(label), UCase(whatsleft), UCase(str2))
        End If

        If pos1 = 0 Or pos2 = 0 Then
            Exit Do
        End If

        ReDim Preserve results(count)
        results(count) = mid(whatsleft, pos1 + Len(label), pos2 - (pos1 + Len(label)))
        whatsleft = Right(whatsleft, Len(whatsleft) - pos2)
        count = count + 1
    Loop

    StrBetweenStrs = results
End Function

Private Function GetNextLine(ByRef sText As String, Optional ByVal reset As Boolean = False, Optional ByRef final As Boolean = False) As String
Static lLineStart As Long
Dim lLineEnd As Long
Dim lLength As Long

If Right$(sText, 2) <> vbCrLf Then
    sText = sText & vbCrLf
End If
If lLineStart = 0 Then lLineStart = 1
If reset = True Then lLineStart = 1
lLineStart = InStr(lLineStart, sText, vbCrLf)
lLineStart = lLineStart + 2

If lLineStart < Len(sText) Then
    lLineEnd = InStr(lLineStart, sText, vbCrLf)
    lLength = lLineEnd - lLineStart
    GetNextLine = mid$(sText, lLineStart, lLength)
Else
    GetNextLine = vbNullString
    lLineStart = 1
    final = True
End If
End Function

Public Function GetTagData(Content As String, Tag As String, Optional Strict As Boolean) As String
    Dim temp() As String
    Dim Temp2() As String
    If Strict = False Then
        If InStr(1, Content, "<" & Tag & " ", vbTextCompare) = 0 Then
            GetTagData = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & " ", , vbTextCompare)
            Temp2 = Split(temp(1), ">", , vbTextCompare)
            GetTagData = Trim$(Temp2(0))
        End If
    Else
        If InStr(Content, "<" & Tag & " ") = 0 Then
            GetTagData = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & " ")
            Temp2 = Split(temp(1), ">")
            GetTagData = Trim$(Temp2(0))
        End If
    End If
    If Right$(GetTagData, 1) = "/" Then
        GetTagData = Left$(GetTagData, Len(GetTagData) - 1)
    End If
End Function

Public Function GetTag(Content As String, Tag As String, Optional Strict As Boolean) As String
    Dim temp() As String
    Dim Temp2() As String
    If Strict = False Then
        If InStr(1, Content, "<" & Tag & ">", vbTextCompare) = 0 Then
            GetTag = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & ">", , vbTextCompare)
            Temp2 = Split(temp(1), "</" & Tag & ">", , vbTextCompare)
            GetTag = Temp2(0)
        End If
    Else
        If InStr(Content, "<" & Tag & ">") = 0 Then
            GetTag = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & ">")
            Temp2 = Split(temp(1), "</" & Tag & ">")
            GetTag = Temp2(0)
        End If
    End If
End Function

Public Function GetListCount(Content As String, Tag As String, Optional Strict As Boolean) As Integer
    Dim temp() As String
    If Strict = False Then
        If InStr(1, Content, "<" & Tag & ">", vbTextCompare) = 0 Then
            GetListCount = 0
        Else
            temp = Split(Content, "<" & Tag & ">", , vbTextCompare)
            GetListCount = UBound(temp)
        End If
    Else
        If InStr(Content, "<" & Tag & ">") = 0 Then
            GetListCount = 0
        Else
            temp = Split(Content, "<" & Tag & ">")
            GetListCount = UBound(temp)
        End If
    End If
End Function

Public Function GetNode(Content As String, Tag As String, Node As Integer, Optional Strict As Boolean) As String
    Dim temp() As String
    Dim Temp2() As String
    If Strict = False Then
        If InStr(1, Content, "<" & Tag & ">", vbTextCompare) = 0 Then
            GetNode = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & ">", , vbTextCompare)
            If Node > UBound(temp) Then
                GetNode = "Error: There are not that many nodes in the feed"
            Else
                Temp2 = Split(temp(Node), "</" & Tag & ">", , vbTextCompare)
                GetNode = Temp2(0)
            End If
        End If
    Else
        If InStr(Content, "<" & Tag & ">") = 0 Then
            GetNode = "Error: This tag is not found in the feed"
        Else
            temp = Split(Content, "<" & Tag & ">")
            If Node > UBound(temp) Then
                GetNode = "Error: There are not that many nodes in the feed"
            Else
                Temp2 = Split(temp(Node), "</" & Tag & ">")
                GetNode = Temp2(0)
            End If
        End If
    End If
End Function
