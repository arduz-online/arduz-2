Attribute VB_Name = "Engine_Landscape"
Option Explicit


Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal Bytes As Long)
Public Declare Function ArrPtr Lib "msvbvm60.dll" Alias "VarPtr" (ptr() As Any) As Long

Public Declare Function RandomBool Lib "MZEngine.dll" () As Boolean
Public Declare Sub InitNoise Lib "MZEngine.dll" ()
Public Declare Function GetNoise Lib "MZEngine.dll" (ByVal x As Long, ByVal mask As Long) As Long

Public Const Perspectiva As Single = 0.65

Public POINTER1 As Integer

Public Type tFloat
    f(0 To 3) As Single
End Type

Public Type map_color_struct
    light_value(0 To 3) As Long
End Type

Public Coseno(360)      As Single
Public Seno(360)        As Single
Public Alphas(255)      As Long

Public last_light_calculate As Long
Public last_light_calculate1 As Long

Public last_light_copy As Long, last_light_h_act As Long

Public rerender_lights As Boolean

Public POINTER2 As Integer

Public Light_Update_Map         As Boolean
Public Light_Update_Lights      As Boolean

Public Const LUZ_TIPO_FUEGO As Integer = 999


Public Sub Init_Math_Const()
On Error Resume Next
InitNoise
Dim i%
For i = 0 To 360
    Coseno(i) = Cos(i * DegreeToRadian)
    Seno(i) = Sin(i * DegreeToRadian)
Next i
For i = 0 To 255
    Alphas(i) = CLng("&H" & Hex$(i) & "000000")
Next i
'ReDim Preserve light_list(1 To 1)
End Sub

Public Sub map_render_light()

End Sub

Public Function Light_Remove(ByVal light_index As Long) As Boolean

End Function

Public Function Light_Color_Value_Get(ByVal light_index As Long, ByRef color_value As D3DCOLORVALUE) As Boolean

End Function
Public Function Light_Create(ByVal map_x As Integer, ByVal map_y As Integer, ByVal R As Byte, ByVal G As Byte, ByVal b As Byte, _
                            Optional ByVal range As Byte = 1, Optional ByVal theta As Single = 0, Optional ByVal ID As Long) As Long

End Function

Public Function Light_Move(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer, ByVal x As Integer, ByVal y As Integer) As Boolean

End Function

Private Sub Light_Make(ByVal light_index As Long, ByVal map_x As Integer, ByVal map_y As Integer, ByVal R As Byte, ByVal G As Byte, ByVal b As Byte, _
                        ByVal range As Long, ByVal theta As Single, Optional ByVal ID As Long)

    
End Sub

Private Function Light_Check(ByVal light_index As Long) As Boolean

End Function


Public Sub Light_Render_All_Flares()

End Sub

Private Function Light_Next_Open() As Long

End Function

Public Function Light_Find(ByVal ID As Long) As Long

End Function

Public Function Light_Remove_All() As Boolean
'
End Function

Private Sub Light_Destroy(ByVal light_index As Long)

End Sub

Private Sub Light_Erase(ByVal light_index As Long)

End Sub

Public Sub Lights_Update()

End Sub
