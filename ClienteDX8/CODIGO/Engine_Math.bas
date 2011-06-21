Attribute VB_Name = "Engine_Math"
Option Explicit

Public angulo_p As Single

Public Function ASin(value As Double) As Double
    If Abs(value) <> 1 Then
        ASin = Atn(value / Sqr(1 - value * value))
    Else
        ASin = 1.5707963267949 * Sgn(value)
    End If
End Function


