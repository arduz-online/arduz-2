Attribute VB_Name = "modClima"
Option Explicit

Public act_clima As Byte

Public day_color As RGBCOLOR

'Private Const Clima_Normal              As Byte = 0     '0000000
'Private Const Clima_Lluvia_normal       As Byte = &H1   '0000001
'Private Const Clima_Diluvio             As Byte = &H3   '0000011
'Private Const Clima_Niebla              As Byte = &H4   '0000100
'Private Const Clima_Diluvio_Terrible    As Byte = &H8   '0000101
'Private Const Clima_Tormenta_de_arena   As Byte = &H10  '0001000
'Private Const Clima_Nublado             As Byte = &H20  '0010000
'Private Const Clima_Nieve               As Byte = &H40  '0100000
'Private Const Clima_Amanecer            As Byte = &H80  '1000000
'Private Const Clima_Rayos_de_luz        As Byte = &HA0  '1010000

Public Enum Tipos_Clima
    Clima_Normal = 0
    Clima_Lluvia_normal = &H1
    Clima_Neblina = &H2
    Clima_Niebla = &H4
    Clima_Diluvio_Terrible = &H8
    Clima_Tormenta_de_arena = &H10
    Clima_Nublado = &H20
    Clima_Nieve = &H40
    Clima_Rayos_de_luz = &H80
End Enum

Public Function Clima_Srain(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 1
    Else
        act_clima = act_clima And 1
    End If
End Function

Public Function Clima_SNeblina(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 2
    Else
        act_clima = act_clima And 2
    End If
End Function

Public Function Clima_SNiebla(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 4
    Else
        act_clima = act_clima And 4
    End If
End Function

Public Function Clima_Ssandstorm(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 16
    Else
        act_clima = act_clima And 16
    End If
End Function

Public Function Clima_SNublado(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 32
    Else
        act_clima = act_clima And 32
    End If
End Function

Public Function Clima_SSnow(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 64
    Else
        act_clima = act_clima And 64
    End If
End Function

Public Function Clima_SSunshines(ByVal activada As Byte)
    If activada Then
        act_clima = act_clima Or 128
    Else
        act_clima = act_clima And 128
    End If
End Function

Public Function Clima_Preset(ByVal nuevo_tipo As Tipos_Clima)
    act_clima = nuevo_tipo
End Function



