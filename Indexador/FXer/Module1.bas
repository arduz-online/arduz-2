Attribute VB_Name = "Module1"



Public Type tCabecera 'Cabecera de los con
    desc As String * 255
    CRC As Long
    MagicWord As Long
End Type

Public Type tIndiceFx
    Animacion As Integer
    offsetx As Integer
    offsety As Integer
End Type

Public Type nIndiceFx
    Animacion As Integer
    offsetx As Single
    offsety As Single
    particula As Integer
    wav As Integer
End Type
Public MiCabecera As tCabecera

Public FxData() As tIndiceFx
Public nFxData() As nIndiceFx
Public Declare Function writeprivateprofilestring Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpString As String, ByVal lpFileName As String) As Long
Public Declare Function getprivateprofilestring Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nsize As Long, ByVal lpFileName As String) As Long

Sub W(ByVal Main As String, ByVal Var As String, ByVal Value As String)
'*****************************************************************
'Writes a var to a text file
'*****************************************************************
    writeprivateprofilestring Main, Var, Value, App.Path & "\FXS.ini"
End Sub

Function Gv(ByVal Main As String, ByVal Var As String) As Long
'*****************************************************************
'Gets a Var from a text file
'*****************************************************************
    Dim sSpaces As String ' This will hold the input that the program will retrieve
    
    sSpaces = Space$(100) ' This tells the computer how long the longest string can be. If you want, you can change the number 100 to any number you wish
    
    getprivateprofilestring Main, Var, vbNullString, sSpaces, Len(sSpaces), App.Path & "\FXS.ini"
    
    sSpaces = RTrim$(sSpaces)
    
    sSpaces = Left$(sSpaces, Len(sSpaces) - 1)
    Debug.Print sSpaces
    GetVar = CLng(sSpaces)
    Debug.Print Main; Var; GetVar
End Function
Sub Gvr(ByVal Main As String, ByVal Var As String, ByRef result As Integer)
'*****************************************************************
'Gets a Var from a text file
'*****************************************************************
    Dim sSpaces As String ' This will hold the input that the program will retrieve
    
    sSpaces = Space$(100) ' This tells the computer how long the longest string can be. If you want, you can change the number 100 to any number you wish
    
    getprivateprofilestring Main, Var, vbNullString, sSpaces, Len(sSpaces), App.Path & "\FXS.ini"
    
    sSpaces = RTrim$(sSpaces)
    
    sSpaces = Left$(sSpaces, Len(sSpaces) - 1)
    Debug.Print sSpaces
    result = CLng(sSpaces)
    Debug.Print Main; Var; result
End Sub
Sub Gvrr(ByVal Main As String, ByVal Var As String, ByRef result As Single)
'*****************************************************************
'Gets a Var from a text file
'*****************************************************************
    Dim sSpaces As String ' This will hold the input that the program will retrieve
    
    sSpaces = Space$(100) ' This tells the computer how long the longest string can be. If you want, you can change the number 100 to any number you wish
    
    getprivateprofilestring Main, Var, vbNullString, sSpaces, Len(sSpaces), App.Path & "\FXS.ini"
    
    sSpaces = RTrim$(sSpaces)
    
    sSpaces = Left$(sSpaces, Len(sSpaces) - 1)
    Debug.Print sSpaces
    result = CSng(sSpaces)
    Debug.Print Main; Var; result
End Sub
Public Sub IniciarCabecera(ByRef Cabecera As tCabecera)
    Cabecera.desc = "Arduz online, Copyright 2009. Menduz engine. www.noicoder.com www.arduz.com.ar ?-b-N-N§§7?÷?D¦?W??Ð?"
    Cabecera.CRC = Rnd * 100
    Cabecera.MagicWord = Rnd * 10
End Sub

Sub CargarFxs()
    Dim N As Integer
    Dim I As Long
    Dim NumFxs As Integer
    
    Dim t As String
    
    N = FreeFile()
    Open App.Path & "\Fxs.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , NumFxs
    
    'Resize array
    ReDim FxData(1 To NumFxs) As tIndiceFx
    ReDim nFxData(1 To NumFxs) As nIndiceFx
    t = "[INIT]" & vbNewLine & "NUM=" & NumFxs
    For I = 1 To NumFxs
        Get #N, , FxData(I)
        nFxData(I).Animacion = FxData(I).Animacion
        nFxData(I).offsetx = FxData(I).offsetx
        nFxData(I).offsety = FxData(I).offsety
        
        t = t & vbNewLine & vbNewLine & "[FX" & I & "]" & vbNewLine & "ANIM=" & FxData(I).Animacion & vbNewLine & "X=" & FxData(I).offsetx & vbNewLine & "Y=" & FxData(I).offsety & vbNewLine & "P=" & nFxData(I).particula & vbNewLine & "S=" & nFxData(I).wav
    Next I
    Form1.Text1.Text = t
    Close #N
End Sub

Sub CargarFxsraw()
    Dim N As Integer
    Dim I As Long
    Dim NumFxs As Integer
    
    Dim t As String
    
    N = FreeFile()
    Open App.Path & "\FxsNEW.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , NumFxs
    
    'Resize array
    ReDim FxData(1 To NumFxs) As tIndiceFx
    ReDim nFxData(1 To NumFxs) As nIndiceFx
    t = "[INIT]" & vbNewLine & "NUM=" & NumFxs
    For I = 1 To NumFxs
        Get #N, , nFxData(I)
        t = t & vbNewLine & vbNewLine & "[FX" & I & "]" & vbNewLine & "ANIM=" & nFxData(I).Animacion & vbNewLine & "X=" & nFxData(I).offsetx & vbNewLine & "Y=" & nFxData(I).offsety & vbNewLine & "P=" & nFxData(I).particula & vbNewLine & "S=" & nFxData(I).wav
    Next I
    Form1.Text1.Text = t
    Close #N
End Sub
Sub CargarFxsINI(compilar As Boolean)
    Dim N As Integer
    Dim I As Long
    Dim NumFxs As Integer
    
    Dim t As String
    
    N = FreeFile()
    
    IniciarCabecera MiCabecera
    
    Call Gvr("INIT", "NUM", NumFxs)
    Debug.Print "JO"; NumFxs
    ReDim nFxData(1 To NumFxs) As nIndiceFx
    t = "[INIT]" & vbNewLine & "NUM=" & NumFxs
    For I = 1 To NumFxs
        With nFxData(I)
            Call Gvr("FX" & I, "ANIM", .Animacion)
            Call Gvrr("FX" & I, "X", .offsetx)
            Call Gvrr("FX" & I, "Y", .offsety)
            Call Gvr("FX" & I, "P", .particula)
            Call Gvr("FX" & I, "S", .wav)
        t = t & vbNewLine & vbNewLine & "[FX" & I & "]" & vbNewLine & "ANIM=" & .Animacion & vbNewLine & "X=" & .offsetx & vbNewLine & "Y=" & .offsety & vbNewLine & "P=" & .particula & vbNewLine & "S=" & nFxData(I).wav
    End With
    Next I
    
    
    Form1.Text1.Text = t
    
    If compilar = False Then Exit Sub
    Open App.Path & "\FxsNEW.ind" For Binary As #N
    
    'cabecera
    Put #N, , MiCabecera
    
    'num de cabezas
    Put #N, , NumFxs
    
    'Resize array

    For I = 1 To NumFxs
        Put #N, , nFxData(I)
    Next I

    Close #N
End Sub

