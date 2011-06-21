Attribute VB_Name = "modMD5"
Option Explicit

Private Declare Sub MDFile Lib "aamd532.dll" _
        (ByVal f As String, ByVal R As String)

Private Declare Sub MDStringFix Lib "aamd532.dll" _
        (ByVal f As String, ByVal t As Long, ByVal R As String)
        
Public Function xMD5File(f As String) As String

' compute MD5 digest on o given file, returning the result

Dim R As String * 32

    R = Space(32)
    MDFile f, R
    MD5File = R

End Function

Public Function xMD5String(p As String) As String

' compute MD5 digest on a given string, returning the result

Dim R As String * 32, t As Long

    R = Space(32)
    t = Len(p)
    MDStringFix p, t, R
    MD5String = R

End Function
