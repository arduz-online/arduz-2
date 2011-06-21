Attribute VB_Name = "modClima"
Option Explicit

Public act_clima As Byte

Private Enum bEfectos_Climaticos
    ClimaLluvia = &H1
    ClimaNeblina = &H2
    ClimaNiebla = &H4
    'LIBRE! = &H8
    ClimaTormenta_de_arena = &H10
    ClimaNublado = &H20
    ClimaNieve = &H40
    ClimaRayos_de_luz = &H80
End Enum

Public Enum Tipos_Climas
    Clima_Normal = 0
    
    Clima_Lluvia = 1
    Clima_Lluvia_Neblina = (2 + 1)
    Clima_Lluvia_Niebla = (4 + 1)
    Clima_Lluvia_Neblina_Nublado = (1 + 2 + &H20)
    Clima_Lluvia_Nublado = (1 + &H20)
    
    
    Clima_Neblina = 2
    Clima_Niebla = 4
    
    
    Clima_Tormenta_de_arena = &H10
    
    Clima_Nublado = &H20
    
    
    Clima_Nieve = &H40
    Clima_Nieve_Neblina = (&H40 + 2)
    
    
    Clima_Rayos_de_luz = &H80
End Enum

Private bNevando    As Boolean
Private bLloviendo  As Boolean

Public Function Clima_Reset()
    act_clima = 0
    bNevando = False
    bLloviendo = False
End Function

Public Function Clima_Preset(ByVal nuevo_tipo As Tipos_Climas)
    act_clima = nuevo_tipo
    bNevando = CBool(act_clima And bEfectos_Climaticos.Clima_Nieve)
    bLloviendo = CBool(act_clima And bEfectos_Climaticos.Clima_Lluvia)
End Function

Public Function Clima_Activar(ByVal tipo As Tipos_Climas)
    act_clima = act_clima Or tipo
    bNevando = CBool(act_clima And bEfectos_Climaticos.Clima_Nieve)
    bLloviendo = CBool(act_clima And bEfectos_Climaticos.Clima_Lluvia)
End Function

Public Function Clima_Toggle(ByVal tipo As Tipos_Climas)
    If act_clima And tipo Then
        act_clima = act_clima And Not CByte(tipo)
    Else
        act_clima = act_clima Or tipo
    End If
    bNevando = CBool(act_clima And bEfectos_Climaticos.Clima_Nieve)
    bLloviendo = CBool(act_clima And bEfectos_Climaticos.Clima_Lluvia)
End Function

Public Function Clima_Get_Activado(ByVal tipo As Tipos_Climas) As Boolean
    If act_clima And tipo Then
        Clima_Get_Activado = True
    Else
        Clima_Get_Activado = False
    End If
End Function

Public Function Clima_DesActivar(ByVal tipo As Tipos_Climas)
    act_clima = act_clima And Not CByte(tipo)
    bNevando = CBool(act_clima And bEfectos_Climaticos.Clima_Nieve)
    bLloviendo = CBool(act_clima And bEfectos_Climaticos.Clima_Lluvia)
End Function

'//////////////////////////////////////////////////////
' LLUVIA! /////////////////////////////////////////////

        Public Property Set Esta_Lloviendo(ByVal activada As Boolean)
            If activada Then
                act_clima = act_clima Or bEfectos_Climaticos.ClimaLluvia
                bLloviendo = True
            Else
                act_clima = act_clima And Not CByte(bEfectos_Climaticos.ClimaLluvia)
                bLloviendo = False
            End If
        End Property
        
        Public Property Get Esta_Lloviendo() As Boolean
            Esta_Lloviendo = bLloviendo
        End Property
        

        Public Function Toggle_Lluvia() As Boolean
            'Lloviendo = Not Lloviendo
            'Esta funcion returns el estado de la lluvia despues de haber sido ejecutada
            
            bLloviendo = Not bLloviendo
            If bLloviendo Then
                act_clima = act_clima Or bEfectos_Climaticos.ClimaLluvia
            Else
                act_clima = act_clima And Not CByte(bEfectos_Climaticos.ClimaLluvia)
            End If
            Toggle_Lluvia = bLloviendo
        End Function
    
' /LLUVIA ////////////////////////////////////////////
'/////////////////////////////////////////////////////

'-

'//////////////////////////////////////////////////////
' NIEVE! //////////////////////////////////////////////

        Public Property Set Esta_Nevando(ByVal activada As Boolean)
            If activada Then
                act_clima = act_clima Or bEfectos_Climaticos.ClimaNieve
                bNevando = True
            Else
                act_clima = act_clima And Not CByte(bEfectos_Climaticos.ClimaNieve)
                bNevando = False
            End If
        End Property
        
        Public Property Get Esta_Nevando() As Boolean
            Esta_Nevando = bNevando
        End Property
        
        Public Function Toggle_Nieve() As Boolean
            'Nevando = Not Nevando
            'Esta funcion returns el estado de la nieve despues de haber sido ejecutada

            bNevando = Not bNevando
            If bNevando Then
                act_clima = act_clima Or bEfectos_Climaticos.ClimaNieve
            Else
                act_clima = act_clima And Not CByte(bEfectos_Climaticos.ClimaNieve)
            End If
            bNevando = bNevando
        End Function
        
' /NIEVE /////////////////////////////////////////////
'/////////////////////////////////////////////////////






