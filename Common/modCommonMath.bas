Attribute VB_Name = "modCommonMath"
Option Explicit

Public CDecimalSeparator As String * 1

Public Function GetCurrencySymbol() As String
    GetCurrencySymbol = Replace(Replace(Replace(format(0, "Currency"), ".", ""), "0", ""), ",", "")
End Function

Public Function DecimalSeparator() As String
If CDecimalSeparator <> "," And CDecimalSeparator <> "." Then

    DecimalSeparator = mid$(1 / 2, 2, 1)
    If IsNumeric(DecimalSeparator) Then
        DecimalSeparator = ","
    End If
    
On Error GoTo have_err
    If val("1" & DecimalSeparator & "9") <> 1.9 Then
        If val("1.9") = 1.9 Then
            DecimalSeparator = "."
        Else
            If val("1,9") = 1.9 Then
                DecimalSeparator = ","
            End If
        End If
    End If
have_err:
On Error GoTo 0

    CDecimalSeparator = DecimalSeparator
Else
    DecimalSeparator = CDecimalSeparator
End If
    
End Function

Public Function CCVal(ByVal x As String) As Single
    On Error GoTo ja
    Dim ea As String
        ea = Replace(Replace(x, ".", ","), ",", DecimalSeparator)
        CCVal = CSng(Round(val(ea), 2))
    Exit Function
ja:
        CCVal = CSng(Round(val(ea), 2))
End Function

Public Function minl(ByVal a As Long, ByVal b As Long) As Long
    If a > b Then
        minl = b
    Else
        minl = a
    End If
End Function

Public Function maxl(ByVal a As Long, ByVal b As Long) As Long
    If a > b Then
        maxl = a
    Else
        maxl = b
    End If
End Function

Public Function int32x32_int64(ByVal lLo As Long, ByVal lHi As Long) As Double
    Dim dLo As Double
    Dim dHi As Double
    
    If lLo < 0 Then
        dLo = (2 ^ 32) + lLo
    Else
        dLo = lLo
    End If
    If lHi < 0 Then
        dHi = (2 ^ 32) + lHi
    Else
        dHi = lHi
    End If
    
    int32x32_int64 = (dLo + (dHi * (2 ^ 32)))
End Function


Public Function bounds(ByVal a As Long, ByVal b As Long, ByVal val As Long) As Long
    Dim lmin As Long
    Dim lmax As Long
    
    lmin = minl(a, b)
    lmax = maxl(a, b)
    
    bounds = val

    If val < lmin Then
        bounds = lmin
    Else
        If val > lmax Then
            bounds = lmax
        End If
    End If
End Function
