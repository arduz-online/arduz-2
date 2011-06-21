Attribute VB_Name = "GrhLoad"
Public Type tGrhData
    sx As Integer
    sy As Integer
    FileNum As Long
    
    pixelWidth As Integer
    pixelHeight As Integer
    
    TileWidth As Single
    TileHeight As Single
    
    NumFrames As Integer
    Frames() As Long 'gs-long
    Speed As Single
End Type


Public tmpFileNum As Integer 'gs-long
Public tmpFrames(1 To 25) As Integer 'gs-long

Public GrhData() As tGrhData 'gs-long

Public TilePixelHeight As Integer
Public TilePixelWidth As Integer

Public Function CaGraficos() As Boolean

'On Error GoTo ErrorHandler
    CaGraficos = False
    Dim Grh As Long
    Dim Frame As Long
    Dim handle As Integer
    Form1.Listado.Clear
    'Open files
    handle = FreeFile()
    
'If UsarIndex = False Then
'    Open DirClien & "\INIT\Graficos.ind" For Binary Access Read As handle
'Else
    Open DirIndex & "\Graficos.ind" For Binary Access Read As handle
'End If
    

    Seek handle, 1
    
    'Get file version
    Get handle, , fileVersion
    
    'Get number of grhs
    Get handle, , grhCount
    MaxGRH = grhCount
    
    'Resize arrays
    ReDim GrhData(1 To grhCount) As tGrhData
    
    Dim Fin As Boolean
    Fin = False
    
    While Not EOF(handle) And Fin = False
        Get handle, , Grh
        With GrhData(Grh)
            'Get number of frames
            Get handle, , GrhData(Grh).NumFrames
            If .NumFrames <= 0 Then GoTo ErrorHandler
            
            ReDim .Frames(1 To GrhData(Grh).NumFrames)
            
            If .NumFrames > 1 Then
            Form1.Listado.AddItem Grh & " (ANIMACION)"
                'Read a animation GRH set
                For Frame = 1 To .NumFrames
                    Get handle, , GrhData(Grh).Frames(Frame)
                    If .Frames(Frame) <= 0 Or .Frames(Frame) > grhCount Then
                        GoTo ErrorHandler
                    End If
                Next Frame
            
                
                Get handle, , GrhData(Grh).Speed
                
                If .Speed <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
                .pixelWidth = GrhData(.Frames(1)).pixelWidth
                If .pixelWidth <= 0 Then GoTo ErrorHandler
                
                
                .pixelHeight = GrhData(.Frames(1)).pixelHeight
                If .pixelHeight <= 0 Then GoTo ErrorHandler
                
                                                
               ' .TileWidth = GrhData(.Frames(1)).TileWidth
                'If .TileWidth <= 0 Then GoTo ErrorHandler
                

               ' .TileHeight = GrhData(.Frames(1)).TileHeight
                'If .TileHeight <= 0 Then GoTo ErrorHandler
                
            Else
                'Read in normal GRH data
                
                 Form1.Listado.AddItem Grh
                Get handle, , GrhData(Grh).FileNum
                If .FileNum <= 0 Then GoTo ErrorHandler
                
                Get handle, , GrhData(Grh).sx
                If .sx < 0 Then GoTo ErrorHandler
                
                Get handle, , GrhData(Grh).sy
                If .sy < 0 Then GoTo ErrorHandler
                
                Get handle, , GrhData(Grh).pixelWidth
                If .pixelWidth <= 0 Then GoTo ErrorHandler
                
                Get handle, , GrhData(Grh).pixelHeight
                If .pixelHeight <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
                '.TileWidth = .pixelWidth / TilePixelHeight
                '.TileHeight = .pixelHeight / TilePixelWidth
                
                .Frames(1) = Grh
            End If
        End With
        If Grh = grhCount Then Fin = True
    Wend
    
    Close handle
    
    CaGraficos = True
Exit Function


ErrorHandler:
MsgBox "Error " & Err.Number & " durante la carga de Grh.dat! La carga se ha detenido en GRH: " & Grh

End Function


Sub WriteGrh(File As String, NumGrh As Integer, value As String)
'*****************************************************************
'Writes a var to a text file
'*****************************************************************
On Error Resume Next

WritePrivateProfileString "Graphics", "Grh" & NumGrh, value, File

End Sub
