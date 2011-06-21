Attribute VB_Name = "GS_INI_Loader"

Const T1 = "["
Const T2 = "]"
Const KSEP = "="
Const CHARS_INVALIDOS = T1 & T2 & KSEP

' [GS] Protecciones
Const NL_TAG = "/n"
Const NL_HEAD = "/"
Const NL_PROTECTED_HEAD = "/~"
Const PROTECT_STR = False
' [/GS]

Dim SeccionFijada As Long
Dim ArchivoCargado As String
Dim LineasCargadas() As String

Public Function FijarSeccion(Seccion As String, Optional EnAdelante As Boolean) As Boolean
    'On Error Resume Next
    FijarSeccion = False
    If ArchivoCargado = "" Then Exit Function
    If StrValido(Seccion) = False Then GoTo ErrorSeccion
    Dim LineaActual As Long
    If EnAdelante = True Then LineaActual = SeccionFijada
    If LineaActual < 0 Then LineaActual = 0
    For LineaActual = LineaActual + 1 To CuantasLineas
        If UCase$(Left$(LineasCargadas(LineaActual), Len(T1 & Seccion & T2))) = UCase$(T1 & Seccion & T2) Then
            SeccionFijada = LineaActual
            FijarSeccion = True
            Exit Function
        End If
    Next
    Exit Function
ErrorSeccion:
    FijarSeccion = False
End Function

Public Function AgregarSeccion(ByVal Seccion As String)
If ArchivoCargado = "" Then Exit Function
If FijarSeccion(Seccion, True) = False Then
    Call AgregarLinea("", CuantasLineas + 1)
    Call AgregarLinea(T1 & Seccion & T2, CuantasLineas + 1)
End If
'Call FijarSeccion(Seccion, False)
End Function

Public Function LeerStr(Key As String, Optional Default As String) As String

    If ArchivoCargado = "" Then Exit Function
    If SeccionFijada < 0 Then Exit Function
    
    Dim StrCargado As String, LineaActual As Long, PosIni As Long
    On Error GoTo LeerError
    
    If Not StrValido(Key) Then GoTo LeerError
    
    LineaActual = SeccionFijada
    If BuscarKey(LineaActual, Key & KSEP) = False Then GoTo LeerError
    
    PosIni = InStr(1, LineasCargadas(LineaActual), KSEP)
    StrCargado = Mid(LineasCargadas(LineaActual), PosIni + 1)
    StrProtegido StrCargado, False
    
    LeerStr = StrCargado
    
    Exit Function
LeerError:
    LeerStr = Default
End Function

Public Function LeerInt(Key As String, Optional Default As Long) As Long

    If ArchivoCargado = "" Then Exit Function
    If SeccionFijada < 0 Then Exit Function
    
    Dim StrCargado As String, LineaActual As Long, PosIni As Long
    On Error GoTo LeerError
    
    If Not StrValido(Key) Then GoTo LeerError

    
    LineaActual = SeccionFijada
    If BuscarKey(LineaActual, Key & KSEP) = False Then GoTo LeerError

    
    PosIni = InStr(1, LineasCargadas(LineaActual), KSEP)
    StrCargado = Mid(LineasCargadas(LineaActual), PosIni + 1)
    StrProtegido StrCargado, False
    
    If IsNumeric(StrCargado) = False Then GoTo LeerError
    
    LeerInt = StrCargado
    
    Exit Function
LeerError:
    LeerInt = Default
End Function



Public Function EscribirStr(Key As String, Valor As String)
    If ArchivoCargado = "" Then Exit Function
    If SeccionFijada < 0 Then Exit Function
    If StrValido(Key) = False Then Exit Function
    Dim NuevoKey As String
    Dim LineaActual As Long
    
    StrProtegido Valor
    NuevoKey = Key & KSEP
    
    LineaActual = SeccionFijada
    If BuscarKey(LineaActual, NuevoKey) = False Then
        LineaActual = SeccionFijada
        AgregarLinea NuevoKey & Valor, LineaActual + 1
    Else
        LineasCargadas(LineaActual) = NuevoKey & Valor
    End If
End Function

Public Function EscribirInt(Key As String, Valor As Long)
    If ArchivoCargado = "" Then Exit Function
    If SeccionFijada < 0 Then Exit Function
    If StrValido(Key) = False Then Exit Function
    Dim NuevoKey As String
    Dim LineaActual As Long
    
    StrProtegido Str(Valor)
    NuevoKey = Key & KSEP
    
    LineaActual = SeccionFijada
    If BuscarKey(LineaActual, NuevoKey) = False Then
        LineaActual = SeccionFijada
        AgregarLinea NuevoKey & Valor, LineaActual + 1
    Else
        LineasCargadas(LineaActual) = NuevoKey & Valor
    End If
End Function


Sub AgregarLinea(ByVal NuevosDatos As String, ByVal posicion As Long)
'On Error Resume Next
    Dim i As Long
    ReDim Preserve LineasCargadas(1 To CuantasLineas + 1)
    If posicion = 0 Then posicion = CuantasLineas
    For i = CuantasLineas To posicion + 1 Step -1
        LineasCargadas(i) = LineasCargadas(i - 1)
    Next i
    LineasCargadas(posicion) = NuevosDatos
End Sub

Sub QuitarLinea(PosIn As Long, Optional PosFi As Long)
    Dim i As Integer, j As Integer
    If PosIn = -1 Then Exit Sub
    If ArchivoCargado = "" Then Exit Sub
    If SeccionFijada < 0 Then Exit Sub
        
    If PosFi = 0 Then PosFi = PosIn
    For i = PosFi + 1 To CuantasLineas
        LineasCargadas(PosIn + j) = LineasCargadas(i)
        j = j + 1
    Next i
    ReDim Preserve LineasCargadas(1 To CuantasLineas - (PosFi - PosIn + 1))
End Sub



' %%% PROTECCIONES %%%
Sub StrProtegido(ByRef StrVal As String, Optional Protect As Boolean = True, Optional Section As Boolean)
    If Not PROTECT_STR Then Exit Sub
    If Protect Then
        ReplaceChars StrVal, NL_HEAD, NL_PROTECTED_HEAD
        ReplaceChars StrVal, vbCrLf, NL_TAG
    Else
        ReplaceChars StrVal, NL_TAG, vbCrLf
        ReplaceChars StrVal, NL_PROTECTED_HEAD, NL_HEAD
    End If
End Sub

Function ReplaceChars(Chars As String, Optional ReplaceChr As String, Optional ReplaceWith As String) As String
Dim ChrCnt As Long
    If ReplaceChr = "" Then ReplaceChr = " "
    ChrCnt = 1
    Do
        ChrCnt = InStr(ChrCnt, Chars, ReplaceChr)
        If ChrCnt = 0 Then Exit Do
        Chars = Left$(Chars, ChrCnt - 1) & ReplaceWith & Right(Chars, Len(Chars) + 1 - Len(ReplaceChr) - ChrCnt)
        ChrCnt = ChrCnt + Len(ReplaceWith)
    Loop
    ReplaceChars = Chars
End Function
' %%% PROTECCIONES %%%


Sub GuardarDAT(Optional Archivo As String)
    If Archivo = "" And ArchivoCargado <> "" Then Archivo = ArchivoCargado
    Dim i As Long
    Dim Vacio As Boolean
    Vacio = False
    Open Archivo For Output As #1
    For i = 1 To CuantasLineas
        LineasCargadas(i) = Replace(LineasCargadas(i), Chr(255), "")
        LineasCargadas(i) = Replace(LineasCargadas(i), Chr(254), "")
        If LineasCargadas(i) = "" And Vacio = False Then
            Vacio = True
            Print #1, Trim$(LineasCargadas(i))
        ElseIf LineasCargadas(i) = "" And Vacio = True Then
            ' Se repetio un espacio, no lo pongo mas
        Else
            Vacio = False
            Print #1, Trim$(LineasCargadas(i))
        End If
    Next i
    Close
End Sub


Sub CargarDAT(Archivo As String)
    If ArchivoCargado = Archivo Then Exit Sub
    SeccionFijada = -1
    Dim i As Integer
    Dim NuevaLinea As String

    Erase LineasCargadas
    On Error GoTo ErrorCargando
    Open Archivo For Input As #1

    Do While Not EOF(1)
        i = i + 1
        Line Input #1, NuevaLinea
        If NuevaLinea = "" Then
            i = i - 1
        Else
            If Left(NuevaLinea, 1) = T1 Then
                i = i + 1
            End If
            If NuevaLinea <> T1 Then
                ReDim Preserve LineasCargadas(1 To i)
                LineasCargadas(i) = NuevaLinea
            End If
        End If
    Loop
    Close
    ArchivoCargado = Archivo
    Exit Sub
ErrorCargando:

End Sub



Function StrValido(StrVal As String) As Boolean
    Dim i As Integer
    StrValido = True
    For i = 1 To Len(CHARS_INVALIDOS)
        If InStr(1, StrVal, Mid(CHARS_INVALIDOS, i, 1)) > 0 Then
            StrValido = False
            Exit For
        End If
    Next i
End Function

Function CuantasLineas()
    On Error Resume Next
    CuantasLineas = UBound(LineasCargadas)
End Function


Public Function pos(ByVal Key As String) As Long
    If ArchivoCargado = "" Then Exit Function
    If SeccionFijada < 0 Then Exit Function
    
    Dim StrCargado As String, LineaActual As Long, PosIni As Long
    On Error GoTo PosError
    
    If Not StrValido(Key) Then GoTo PosError
    
    LineaActual = SeccionFijada
    If BuscarKey(LineaActual, Key & KSEP) = False Then GoTo PosError
    
    pos = LineaActual
    Exit Function
PosError:
    pos = -1
End Function


Function BuscarKey(ByRef LineaActual As Long, LineaStr As String) As Boolean
    BuscarKey = False
    If UCase(LineaStr) = "MAXDEF" & KSEP Then
        DoEvents
    End If
    Dim UltimaLinea As Long
    For LineaActual = LineaActual + 1 To CuantasLineas
        If LineasCargadas(LineaActual) > "" Then UltimaLinea = LineaActual
        If Left(LineasCargadas(LineaActual), Len(T1)) = T1 Then Exit For
        If UCase(Left(LineasCargadas(LineaActual), Len(LineaStr))) = UCase(LineaStr) Then
            BuscarKey = True
            Exit For
        End If
    Next
    If LineaActual > UltimaLinea Then ReDim Preserve LineasCargadas(1 To CuantasLineas + 1)
    LineaActual = UltimaLinea
End Function



