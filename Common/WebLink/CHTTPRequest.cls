VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CHTTPRequest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'© 2005 L.C. Enterprises
'http://LCen.com

'HTTP Request Class
'Author: Luis Cantero
'Updated: 10/AUG/2005

'INITIALIZE:    Set objHTTPRequest = New CHTTPRequest, .altost, .Proxy, .Path, .UserAgent, .MimeBoundary
'METHODS:       .AddFormData(strKey, strValue), .AddFile(strName, strFileName, strContent, strContentType)
'FUNCTIONS:     .GetGETQuery(), .GetPOSTQuery()

Option Explicit

Private strHost As String
Private strProxy As String
Private strPath As String
Private strUserAgent As String
Private strMimeBoundary As String
Private dicFormData As Object
Private dicFileNames As Object
Private dicFileContents As Object
Private dicFileContentTypes As Object

Public Sub AddFile(strName As String, strFileName As String, strContent As String, strContentType As String)

    Call dicFileNames.Add(strName, strFileName)
    Call dicFileContents.Add(strName, strContent)
    Call dicFileContentTypes.Add(strName, strContentType)

End Sub

Public Sub AddFormData(strKey As String, ByVal strValue As String)

    Call dicFormData.Add(strKey, strValue)

End Sub

Private Sub Class_Initialize()

    strMimeBoundary = "CeReBrOdEmOnO"

    Set dicFormData = CreateObject("Scripting.Dictionary")
    Set dicFileNames = CreateObject("Scripting.Dictionary")
    Set dicFileContents = CreateObject("Scripting.Dictionary")
    Set dicFileContentTypes = CreateObject("Scripting.Dictionary")
    
    strUserAgent = WebUserAgent
End Sub

Private Sub Class_Terminate()

    Set dicFormData = Nothing
    Set dicFileNames = Nothing
    Set dicFileContents = Nothing
    Set dicFileContentTypes = Nothing

End Sub

Public Function GetGETQuery() As String

  'When to use GET? -> When the amount of data that you
  'need to pass to the server is not much

  Dim strFormData As String
  Dim strValue As String
  Dim arrKeys
  Dim i As Integer

    'Add form data
    arrKeys = dicFormData.keys()

    For i = 0 To UBound(arrKeys)
        strValue = Replace(dicFormData(arrKeys(i)), "&", "&amp;")
        strValue = Replace(dicFormData(arrKeys(i)), " ", "%20")
        strFormData = strFormData & arrKeys(i) & "=" & strValue

        'Next value
        If i < UBound(arrKeys) Then strFormData = strFormData & "&"
    Next i

    If strFormData <> "" Then strFormData = "?" & strFormData

    GetGETQuery = "GET " & strProxy & strPath & strFormData & " HTTP/1.0" & vbCrLf
    GetGETQuery = GetGETQuery & "Accept: */*" & vbCrLf
    GetGETQuery = GetGETQuery & "User-Agent: " & strUserAgent & vbCrLf
    GetGETQuery = GetGETQuery & "Host: " & strHost & vbCrLf
    GetGETQuery = GetGETQuery & vbCrLf

End Function

Public Function GetPOSTQuery() As String

  'When to use POST? -> Anytime, it is failsafe since the
  'content-length is passed to the server everytime

  Dim strContentData As String
  Dim arrKeys
  Dim i As Integer

    'Add form data
    arrKeys = dicFormData.keys()

    strContentData = "--" & strMimeBoundary & vbCrLf

    For i = 0 To UBound(arrKeys)
        strContentData = strContentData & "Content-Disposition: form-data; "
        strContentData = strContentData & "name=""" & arrKeys(i) & """" & vbCrLf & vbCrLf & dicFormData(arrKeys(i)) & vbCrLf & "--" & strMimeBoundary

        'Next value
        If i < UBound(arrKeys) Then strContentData = strContentData & vbCrLf
    Next i

    'Add files
    arrKeys = dicFileNames.keys()

    If UBound(arrKeys) = -1 Then 'No files
        'Add closing tags
        If i > 0 Then 'Only form fields, no files
            strContentData = strContentData & "--" & vbCrLf
          Else 'No form fields and no files
            strContentData = strContentData & "--" & strMimeBoundary & "--" & vbCrLf
        End If
      Else 'Files
        If i > 0 Then 'Form fields and files
            strContentData = strContentData & vbCrLf
        End If
    End If

    For i = 0 To UBound(arrKeys)
        strContentData = strContentData & "Content-Disposition: attachment; name=""" & arrKeys(i) & """; filename=""" & dicFileNames(arrKeys(i)) & """" & vbCrLf
        strContentData = strContentData & "Content-Type: " & dicFileContentTypes(arrKeys(i)) & vbCrLf & vbCrLf & dicFileContents(arrKeys(i)) & vbCrLf & "--" & strMimeBoundary

        'Next file
        If i < UBound(arrKeys) Then strContentData = strContentData & vbCrLf
    Next i

    If UBound(arrKeys) > -1 Then 'Files
        strContentData = strContentData & "--" & vbCrLf
    End If

    'Return header + content data
    GetPOSTQuery = "POST " & strProxy & strPath & " HTTP/1.0" & vbCrLf
    GetPOSTQuery = GetPOSTQuery & "Accept: */*" & vbCrLf
    GetPOSTQuery = GetPOSTQuery & "User-Agent: " & strUserAgent & vbCrLf
    GetPOSTQuery = GetPOSTQuery & "Host: " & strHost & vbCrLf
    GetPOSTQuery = GetPOSTQuery & "Content-Type: multipart/form-data, boundary=" & strMimeBoundary & vbCrLf
    GetPOSTQuery = GetPOSTQuery & "Content-Length: " & Len(strContentData) & vbCrLf & vbCrLf & strContentData

End Function

Public Property Let Host(strInput As String)

    strHost = strInput

End Property

Public Property Let MimeBoundary(strInput As String)

    strMimeBoundary = strInput

End Property

Public Property Let path(strInput As String)

    strPath = strInput

End Property

Public Property Let Proxy(strInput As String)

    strProxy = strInput

End Property

Public Property Let UserAgent(strInput As String)

    strUserAgent = strInput

End Property

':) Ulli's VB Code Formatter V2.13.6 (10.08.2005 23:02:51) 22 + 158 = 180 Lines

