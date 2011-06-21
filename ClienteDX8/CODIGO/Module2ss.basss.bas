Attribute VB_Name = "Module2"
Public m7_ray As D3DVECTOR
Public angulo_p As Single

Public Function ASin(value As Double) As Double
    If Abs(value) <> 1 Then
        ASin = Atn(value / Sqr(1 - value * value))
    Else
        ASin = 1.5707963267949 * Sgn(value)
    End If
End Function

