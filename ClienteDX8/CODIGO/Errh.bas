Attribute VB_Name = "Errh"
Option Explicit

Public senderror As Boolean
Public error_string As String
Public dontpharsenext As Boolean
Public endthen As Boolean

Public Sub LogError(desc As String, Optional ByVal Comunicate As Boolean = False)
On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open App.path & "\logs\ClientError.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & desc
Debug.Print Date & " " & Time & " " & desc
Close #nFile

ErrHandler:
If Comunicate Then
    If MsgBox("Se ha producido un error crítico:" & vbNewLine & desc & vbNewLine & "¿Cerrar Programa?", vbCritical Or vbYesNo) = vbYes Then
        If MsgBox("¿Buscar solución en la web?", vbInformation Or vbYesNo) = vbYes Then
            Call ShellExecute(0, "Open", WEBSERVER & "errores.php?error=" & Err.Number, "", App.path, 0)
        End If
        End
    End If
End If
    
End Sub

Public Sub Log(desc As String)
On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile 'obtenemos un canal
Open App.path & "\logs\LOG.txt" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " " & desc
Debug.Print Date & " " & Time & " " & desc
Close #nFile
ErrHandler:
End Sub

Public Sub CriticError(desc As String)
On Error GoTo ErrHandler

Dim nFile As Integer
nFile = FreeFile
Open App.path & "\logs\ClientError.log" For Append Shared As #nFile
Print #nFile, Date & " " & Time & " CRITICO:" & get_machine_desc & desc
Debug.Print Date & " " & Time & " CRITICO:" & desc
Close #nFile

ErrHandler:
    Call MsgBox("Se ha producido un error crítico:" & vbNewLine & desc & vbNewLine & vbNewLine & "Por favor envienos el registro de errores """"Arduz/logs/ClientError.log"""" mediante nuestro foro. http://www.arduz.com.ar/", , "Arduz II")
    #If Debuging = 0 Then
        endthen = True
    #End If
End Sub
