Attribute VB_Name = "modArduz2"
Option Explicit

Public Special_slots(5) As Integer
Public Special_slots_rect(5) As sRECT
Public Hotbar_rect(7) As sRECT

Public Sub init_special_slots()
    Dim i As Integer
    
    With Special_slots_rect(0)
    .top = 4
    .left = 153
    End With
    With Special_slots_rect(1)
    .top = 55
    .left = 153
    End With
    With Special_slots_rect(2)
    .top = 108
    .left = 153
    End With
    With Special_slots_rect(3)
    .top = 154
    .left = 4
    End With
    With Special_slots_rect(4)
    .top = 154
    .left = 57
    End With
    With Special_slots_rect(5)
    .top = 154
    .left = 106
    End With
    For i = 0 To 5
        With Special_slots_rect(i)
            .bottom = .top + 42
            .right = .left + 42
        End With
    Next i
    
End Sub

