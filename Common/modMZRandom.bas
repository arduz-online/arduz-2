Attribute VB_Name = "modMZRandom"
''
'
' @autor: Agustín Nicolás Méndez (Menduz @ noicoder.com)
' @fecha: 10122009
' @base: http://upload.wikimedia.org/math/1/4/4/144550627858cb6d44ceb02ba9434317.png
' - GENERADOR DE NUMEROS ALEATORIOS DE ARDUZ


Option Explicit

Private Declare Function GetTickCount Lib "kernel32" () As Long

Private g_seed As Double
Private w_seed As Double

Private Const SINGLE_EPSILON As Single = 1 / 65535

Public Sub MZRandom_Init(Optional ByVal seed&)
    If seed Then
        g_seed = seed
    Else
        g_seed = GetTickCount
    End If
    
    Randomize g_seed
    w_seed = g_seed * Rnd
End Sub

Private Sub computarMZR()
    g_seed = 36969 * (g_seed And 32767) + (g_seed \ &HFF)
    w_seed = 18000 * (w_seed And 32767) + (w_seed \ &HFF)
End Sub

Public Function MZRandom(ByVal min&, ByVal max&) As Long
    computarMZR
    
    MZRandom = min + ((g_seed Xor (g_seed \ &HFE)) Mod (max - min + 1))
End Function

Public Function MZRandomL() As Long
    computarMZR
    
    MZRandomL = g_seed And &HFF + w_seed
End Function

Public Function MZRandomS(ByVal min!, ByVal max!) As Single
    computarMZR
    
    MZRandomS = min + (g_seed \ &HFF) * (max - min) * SINGLE_EPSILON
End Function

Public Function MZRandomB() As Boolean
    computarMZR
    
    MZRandomB = (g_seed Xor (g_seed \ &HFE)) Mod 2
End Function

Public Function MZRandomPB(Optional ByVal posibilidad As Integer = 50) As Boolean
    computarMZR
    
    If ((g_seed Xor (g_seed \ &HFE)) Mod 101) <= posibilidad Then _
        MZRandomPB = True
        
End Function


