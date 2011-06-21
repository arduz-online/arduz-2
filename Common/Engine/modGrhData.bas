Attribute VB_Name = "modGrhData"
Option Explicit

Public GrhVersion   As Long
Public GrhData()    As GrhData
Public GrhCount     As Long

Public Type GrhData
    SX As Integer
    SY As Integer
    
    FileNum As Long
    
    pixelWidth As Integer
    pixelHeight As Integer
    
    TileWidth As Single
    TileHeight As Single
    
    NumFrames As Integer
    Frames() As Long
    
    speed As Single
    
    tu(3) As Single
    tv(3) As Single
    hardcor As Byte
End Type

Public Sub indexar_from_string(ByVal Grh As Long, ByRef datos As String)
    If Grh < GrhCount Then
        ReDim Preserve GrhData(Grh)
        GrhCount = Grh
    End If
    
    Dim Frames  As Long
    GrhData(Grh).NumFrames = ReadField(1, datos, Asc("-"))
    If GrhData(Grh).NumFrames = 1 Then
        GrhData(Grh).FileNum = val(ReadField(2, datos, Asc("-")))
        GrhData(Grh).SX = val(ReadField(3, datos, Asc("-")))
        GrhData(Grh).SY = val(ReadField(4, datos, Asc("-")))
        GrhData(Grh).pixelWidth = val(ReadField(5, datos, Asc("-")))
        GrhData(Grh).pixelHeight = val(ReadField(6, datos, Asc("-")))
    Else
        ReDim GrhData(Grh).Frames(1 To GrhData(Grh).NumFrames)
        For Frames = 1 To GrhData(Grh).NumFrames
            GrhData(Grh).Frames(Frames) = val(ReadField(Frames + 1, datos, Asc("-")))
            If GrhData(Grh).Frames(Frames) <= 0 Or GrhData(Grh).Frames(Frames) > GrhCount Then
                GoTo ErrorHandler
            End If
        Next
        GrhData(Grh).speed = CCVal(ReadField(GrhData(Grh).NumFrames + 2, datos, Asc("-")))
        If GrhData(Grh).speed <= 0 Then GoTo ErrorHandler
    End If
    Exit Sub
ErrorHandler:
MsgBox "Error indexar_from_string en grafico numero: " & Grh & """" & datos & """"
End Sub

Public Function LoadGrhData() As Boolean
      'On Error GoTo ErrorHandler
      funcion_actual = fnc.E_LOADGRH
          Dim Grh As Long
          Dim Frame As Long
          Dim Handle As Integer
          
          'Open files
10        Handle = FreeFile()
20        Open IniPath & "Graficos.ind" For Binary Access Read As Handle
30        Seek Handle, 1
          
          'Get file version
40        Get Handle, , GrhVersion
          
          'Get number of grhs
50        Get Handle, , GrhCount
          
          'Resize arrays
60        ReDim GrhData(0 To GrhCount) As GrhData
          
70        While Not EOF(Handle)
80          Get Handle, , Grh

            If Grh > GrhCount Then
                ReDim Preserve GrhData(Grh)
                GrhCount = Grh
            End If
              
90            With GrhData(Grh)
            'Get number of frames
100               Get Handle, , .NumFrames
110               If .NumFrames <= 0 Then GoTo ErrorHandler
            
120               ReDim .Frames(1 To GrhData(Grh).NumFrames)
            
130               If .NumFrames > 1 Then
                'Read a animation GRH set
140                   For Frame = 1 To .NumFrames
150                       Get Handle, , .Frames(Frame)
160                       If .Frames(Frame) <= 0 Or .Frames(Frame) > GrhCount Then
170                           GoTo ErrorHandler
180                       End If
190                   Next Frame
                
200                   Get Handle, , .speed
                
210                   If .speed <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
220                   .pixelHeight = GrhData(.Frames(1)).pixelHeight
230                   If .pixelHeight <= 0 Then GoTo ErrorHandler
                
240                   .pixelWidth = GrhData(.Frames(1)).pixelWidth
250                   If .pixelWidth <= 0 Then GoTo ErrorHandler
                
260                   .TileWidth = GrhData(.Frames(1)).TileWidth
270                   If .TileWidth <= 0 Then GoTo ErrorHandler
                
280                   .TileHeight = GrhData(.Frames(1)).TileHeight
290                   If .TileHeight <= 0 Then GoTo ErrorHandler
300               Else
                'Read in normal GRH data
310                   Get Handle, , .FileNum
320                   If .FileNum <= 0 Then GoTo ErrorHandler
                
330                   Get Handle, , GrhData(Grh).SX
340                   If .SX < 0 Then GoTo ErrorHandler
                
350                   Get Handle, , .SY
360                   If .SY < 0 Then GoTo ErrorHandler
                
370                   Get Handle, , .pixelWidth
380                   If .pixelWidth <= 0 Then GoTo ErrorHandler
                
390                   Get Handle, , .pixelHeight
400                   If .pixelHeight <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
410                   .TileWidth = .pixelWidth / 32
420                   .TileHeight = .pixelHeight / 32
                
430                   .Frames(1) = Grh
440               End If
450           End With
460       Wend
          
470       Close Handle
Handle = 0
        funcion_actual = 0
480       LoadGrhData = True
490   Exit Function

ErrorHandler:
500       LoadGrhData = False
If Handle Then Close Handle
End Function


Public Function IndexarGraficosMemoria(ByVal NuevaVersion As Long) As Boolean
'On Error GoTo ErrorHandler
    Dim Handle  As Integer
    Dim Grh     As Long
    Dim Frame   As Long
        
    If FileExist(IniPath & "Graficos.ind", vbNormal) Then
        On Local Error Resume Next
        FileCopy IniPath & "Graficos.ind", IniPath & "Graficos.backup-" & GrhVersion & ".ind"
        DoEvents
        On Local Error GoTo 0

        Kill IniPath & "Graficos.ind"
        DoEvents
    End If
    
    If NuevaVersion = 0 Then NuevaVersion = GrhVersion
    
    Handle = FreeFile()
    Open IniPath & "Graficos.ind" For Binary Access Write As Handle
    
    Seek Handle, 1
    
    Put Handle, , NuevaVersion
    Put Handle, , GrhCount
    
    For Grh = 1 To GrhCount
        With GrhData(Grh)
            If .NumFrames = 1 Then
                If .FileNum > 0 And .pixelHeight > 0 And .pixelWidth Then
                    Put Handle, , Grh
                    Put Handle, , .NumFrames
                    Put Handle, , .FileNum
                    Put Handle, , .SX
                    Put Handle, , .SY
                    Put Handle, , .pixelWidth
                    Put Handle, , .pixelHeight
                End If
            ElseIf GrhData(Grh).NumFrames > 1 Then
                Put Handle, , Grh
                Put Handle, , GrhData(Grh).NumFrames
                For Frame = 1 To GrhData(Grh).NumFrames
                    Put Handle, , GrhData(Grh).Frames(Frame)
                Next
                Put Handle, , GrhData(Grh).speed
            End If
        End With
    Next Grh
    Grh = 0
    Put Handle, , Grh
    
    Close Handle
    
    IndexarGraficosMemoria = True
    
    Exit Function
    
ErrorHandler:
    
End Function


