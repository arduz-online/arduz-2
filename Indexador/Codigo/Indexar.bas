Attribute VB_Name = "Indexar"
Public Sub DIR_INDEXADOR()
If LenB(Dir(DirExpor, vbDirectory)) = 0 Then
    Call MkDir(DirExpor)
End If
If LenB(Dir(DirIndex, vbDirectory)) = 0 Then
    Call MkDir(DirIndex)
End If
If LenB(Dir(DirClien & "\Graficos\0.bmp", vbArchive)) <> 0 Then
    Call Kill(DirClien & "\Graficos\0.bmp")
    DoEvents
End If
End Sub

Public Sub HacerIndexacion(ByVal Tradicional As Boolean)

'On Error GoTo ErrorHandler
Form1.mnuReload.Enabled = False
Dim GRH As Long
Dim tmpGRH As Integer
Dim Frame As Integer
Dim tempint As Integer

Dim templng As Long
Dim NumGrh As Integer
Dim Datos As New clsLeerIni
Dim nF As Integer
nF = FreeFile

Call DIR_INDEXADOR

If LenB(Dir(DirExpor & "\Graficos.ini", vbArchive)) = 0 And Tradicional = False Then
    MsgBox "No existe Graficos.ini"
    Exit Sub
End If

If Tradicional = False Then
    Datos.Abrir DirExpor & "\Graficos.ini"
    NumGrh = Val(Datos.DarValor("INIT", "NumGrh"))
Else
    NumGrh = MaxGRH
End If

Form1.GRHt.Text = "Creando...Graficos.ind"

If LenB(Dir(DirIndex & "\Graficos.ind", vbArchive)) <> 0 Then Call Kill(DirIndex & "\Graficos.ind")
Open DirIndex & "\Graficos.ind" For Binary Access Write As #nF
Seek #nF, 1

Put #nF, , MiCabecera
Put #nF, , tempint
Put #nF, , tempint
Put #nF, , tempint
Put #nF, , tempint
Put #nF, , tempint

Dim Fr As Integer
Dim OP As Byte
OP = 0
Dim sTmp As String
Dim Errores As String
For GRH = 1 To NumGrh
    sTmp = Datos.DarValor("Graphics", "Grh" & GRH)
    If LenB(sTmp) <> 0 Then
        Fr = ReadField(1, sTmp, 45)
        ' - = 45
        If Fr > 1 Then
            ' ***************** ES UN FRAME **************
            If UsarGrhLong = True Then
                Put #nF, , GRH
            Else
                tmpGRH = GRH
                Put #nF, , tmpGRH
            End If
            Put #nF, , Fr
            For i = 1 To Fr
                templng = ReadField(i + 1, sTmp, 45)
                If templng > MaxGRH Or templng <= 0 Then
                    Errores = Errores & "Grh" & GRH & " (ANIMACION) hace refencia en Frame " & i & " a Grh" & templng & " que es invalido" & vbCrLf
                End If
                If UsarGrhLong = True Then
                    Put #nF, , templng   ' grhnum
                Else
                    tempint = templng    ' grhnum
                    Put #nF, , tempint
                End If
            Next
            tempint = ReadField(Fr + 2, sTmp, 45)
            Put #nF, , tempint  ' speed
            ' ***************** ES UN FRAME **************
        ElseIf Fr = 1 Then
            ' ***************** ES UN GRH **************
            If UsarGrhLong = True Then
                Put #nF, , GRH
            Else
                tmpGRH = GRH
                Put #nF, , tmpGRH
            End If
            Put #nF, , Fr
            templng = ReadField(2, sTmp, 45)
            If templng <= 0 Or Len(Dir(DirClien & "\Graficos\" & templng & ".BMP")) = 0 Then
                Errores = Errores & "Grh" & GRH & " hace refencia a BMP " & templng & " que es invalido" & vbCrLf
            End If
            If UsarGrhLong = True Then
                Put #nF, , templng   ' filenum
            Else
                tempint = templng
                Put #nF, , tempint   ' filenum
            End If
            tempint = ReadField(3, sTmp, 45)
            Put #nF, , tempint   ' sx
            tempint = ReadField(4, sTmp, 45)
            Put #nF, , tempint   ' sy
            tempint = ReadField(5, sTmp, 45)
            Put #nF, , tempint   ' pixelw
            tempint = ReadField(6, sTmp, 45)
            Put #nF, , tempint   ' pixelh
            ' ***************** ES UN GRH **************
        End If
        Form1.GRHt.Text = "Indexado..." & Format((GRH / NumGrh * 100), "##") & "%"
        DoEvents
    End If
Next

Close #nF

If LenB(Errores) <> 0 Then
    MostrarCodigo.Show
    MostrarCodigo.Caption = "Errores Detectados durante la Indexación"
    MostrarCodigo.Codigo = Errores
End If

Form1.GRHt.Text = "Compilado...Graficos.ind"
Form1.mnuReload.Enabled = True
Exit Sub

ErrorHandler:
Close #nF
MsgBox "Error durante la codificacion GS - GRH: " & GRH & " - err" & Err.Number
Form1.mnuReload.Enabled = True

End Sub
Public Function CaGraficosIni() As Boolean

    CaGraficosIni = False
    Dim Soport As New clsLeerIni
    Dim GRH As Long
    Dim Frame As Long
    Dim Datos$
    
    
    
    
    
If LenB(Dir(DirExpor & "\Graficos.ini", vbArchive)) = 0 Then
    MsgBox "No existe Graficos.ini"
    Exit Function
End If

    Soport.Abrir DirExpor & "\Graficos.ini"
    
    grhCount = Val(Soport.DarValor("INIT", "NumGrh"))
    fileVersion = Val(Soport.DarValor("INIT", "Version"))

Form1.GRHt.Text = "Creando...Graficos.ind"


If LenB(Dir(DirIndex & "\Graficos.ind", vbArchive)) <> 0 Then Call Kill(DirIndex & "\Graficos.ind")
handle = FreeFile()
Open DirIndex & "\Graficos.ind" For Binary Access Write As handle
    Seek handle, 1
    Put handle, , fileVersion
    Put handle, , NumGrh
    
    
    ReDim GrhData(1 To grhCount) As tGrhData
    
    For GRH = 1 To grhCount
        Datos$ = Soport.DarValor("Graphics", "Grh" & GRH)
        If Datos$ <> "" Then
            GrhData(GRH).NumFrames = ReadField(1, Datos$, Asc("-"))
            If GrhData(GRH).NumFrames = 1 Then
                GrhData(GRH).FileNum = ReadField(2, Datos$, Asc("-"))
                GrhData(GRH).sx = ReadField(3, Datos$, Asc("-"))
                GrhData(GRH).sy = ReadField(4, Datos$, Asc("-"))
                GrhData(GRH).pixelWidth = ReadField(5, Datos$, Asc("-"))
                GrhData(GRH).pixelHeight = ReadField(6, Datos$, Asc("-"))
            Else
                ReDim GrhData(GRH).Frames(1 To GrhData(GRH).NumFrames)
                For Frames = 1 To GrhData(GRH).NumFrames
                    GrhData(GRH).Frames(Frames) = ReadField(Frames + 1, Datos$, Asc("-"))
                    If GrhData(GRH).Frames(Frames) <= 0 Or GrhData(GRH).Frames(Frames) > grhCount Then
                        GoTo ErrorHandler
                    End If
                Next
                GrhData(GRH).Speed = ReadField(GrhData(GRH).NumFrames + 2, Datos$, Asc("-"))
                If GrhData(GRH).Speed <= 0 Then GoTo ErrorHandler
            End If
        Else
            GrhData(GRH).FileNum = 0
            GrhData(GRH).sx = 0
            GrhData(GRH).sy = 0
            GrhData(GRH).pixelWidth = 0
            GrhData(GRH).pixelHeight = 0
        End If
    Next
    
    CaGraficosIni = True
    Close handle


    Exit Function
    
ErrorHandler:

End Function
Public Function ReGraficos() As Boolean
On Error GoTo ErrorHandler
    ReGraficos = False
    Dim handle As Integer
    Dim GRH As Long
    Dim Frame As Long
    
    handle = FreeFile()
    Open DirIndex & "\Graficos.ind" For Binary Access Write As handle
    Seek handle, 1
    Put handle, , fileVersion
    Put handle, , grhCount
    Form1.GRHt.Text = "Creando...Graficos.ind"
    For GRH = 1 To grhCount
        If GrhData(GRH).NumFrames = 1 Then
            Put handle, , GRH
            Put handle, , GrhData(GRH).NumFrames
            Put handle, , GrhData(GRH).FileNum
            Put handle, , GrhData(GRH).sx
            Put handle, , GrhData(GRH).sy
            Put handle, , GrhData(GRH).pixelWidth
            Put handle, , GrhData(GRH).pixelHeight
        ElseIf GrhData(GRH).NumFrames > 1 Then
            Put handle, , GRH
            Put handle, , GrhData(GRH).NumFrames
            For Frame = 1 To GrhData(GRH).NumFrames
                Put handle, , GrhData(GRH).Frames(Frame)
            Next
            Put handle, , GrhData(GRH).Speed
        End If
        Form1.GRHt.Text = "Indexado..." & Format((GRH / grhCount * 100), "##") & "%"
    Next
    
    Close handle
    
    ReGraficos = True
    Exit Function
    
ErrorHandler:
    
End Function
