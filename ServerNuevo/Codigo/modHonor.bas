Attribute VB_Name = "modHonor"
Option Explicit

Public Sub honor_inmo(ByVal atacante As Integer, ByVal victima As Integer)
On Error Resume Next
    Dim delta_honor As Integer
    If atacante = victima Then Exit Sub
    Dim cAT As Integer
    Dim cVI As Integer
    Dim VI As User
    Dim AT As User
    AT = UserList(atacante)
    VI = UserList(victima)
    cAT = AT.clase
    cVI = VI.clase

    
    If VI.flags.Desnudo Then delta_honor = -1
    If VI.pasos_desde_resu = 0 Then delta_honor = delta_honor - 10
    
    If cVI = eClass.Mage Then
        If cAT = cVI Then
            delta_honor = delta_honor - 5
        ElseIf cAT = eClass.Bard Or cAT = eClass.Druid Then
            delta_honor = delta_honor - 3
        End If
    ElseIf cVI = eClass.Bard Or cVI = eClass.Druid Then
        If cAT = eClass.Mage Or cAT = cVI Then delta_honor = delta_honor - 3
    End If
    honor_enviar atacante, delta_honor
Err.Clear
End Sub

Public Sub honor_remo(ByVal atacante As Integer, ByVal victima As Integer)
On Error Resume Next
    Dim delta_honor As Integer
    If atacante = victima Then Exit Sub
    Dim cAT As Integer
    Dim cVI As Integer
    Dim VI As User
    Dim AT As User
    AT = UserList(atacante)
    VI = UserList(victima)
    cAT = AT.clase
    cVI = VI.clase

    
    If VI.flags.Desnudo Then delta_honor = 1
    If VI.pasos_desde_resu = 0 Then delta_honor = delta_honor + 1
    
    delta_honor = delta_honor + 1
    honor_enviar atacante, delta_honor
Err.Clear
End Sub

Public Sub honor_ataca(ByVal atacante As Integer, ByVal victima As Integer)
On Error Resume Next
    Dim delta_honor As Integer
    If atacante = victima Then Exit Sub
    Dim cAT As Integer
    Dim cVI As Integer
    Dim VI As User
    Dim AT As User
    AT = UserList(atacante)
    VI = UserList(victima)
    cAT = AT.clase
    cVI = VI.clase

    
    If VI.flags.Desnudo Then delta_honor = -1
    If VI.pasos_desde_resu = 0 Then delta_honor = delta_honor - 10
    
    If cVI = eClass.Mage And (VI.flags.Paralizado <> 0 Or VI.flags.Inmovilizado <> 0) Then
        If cAT = cVI Then
            delta_honor = delta_honor - 5
        End If
    End If
    honor_enviar atacante, delta_honor
Err.Clear
End Sub

Public Sub honor_enviar(ByVal UserIndex As Integer, ByVal delta_honor As Integer)
On Error Resume Next
Dim color As Long
Dim hit As String
If delta_honor <> 0 Then
    UserList(UserIndex).Stats.honor = UserList(UserIndex).Stats.honor + delta_honor
    UserList(UserIndex).Stats.honorenv = UserList(UserIndex).Stats.honorenv + delta_honor
    If delta_honor > 0 Then
        color = vbGreen
    Else
        color = &HF82FF
    End If
    Call UserList(UserIndex).outgoingData.WriteASCIIStringFixed(Protocol.PrepareMessageCreateHIT(UserList(UserIndex).Char.CharIndex, delta_honor, color))
    Err.Clear
End If
End Sub

'Private Function clase_es_magica(ByVal UserIndex As Integer) As Integer
'Select Case UserList(UserIndex).clase: Case eClass.Mage, eClass.Bard, eClass.Druid
'    clase_es_magica = UserList(UserIndex).clase
'End Select
'End Function
