VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPerformanceTimer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private start_time  As Double
Private end_time    As Double
Private timer_freq  As Double
Private use_QPC     As Boolean
Private Type LARGE_INTEGER: LowPart As Long: HighPart As Long: End Type
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (ByRef lpFrequency As LARGE_INTEGER) As Boolean
Private Declare Function QueryPerformanceCounter Lib "kernel32" (ByRef lpPerformanceCount As LARGE_INTEGER) As Long
Private Declare Function timeGetTime Lib "winmm.dll" () As Long


Private Epsilon              As Single '= 0.0000001192093
Private EpsilonD             As Double '= 0.0000001192093


Private permite_qpc As Boolean

Private Function QPCD() As Double: Dim a As LARGE_INTEGER: Call QueryPerformanceCounter(a): QPCD = LInt2Dbl(a): End Function

Private Function QPFD() As Double
    Dim a As LARGE_INTEGER
    permite_qpc = (QueryPerformanceFrequency(a) <> False)
    QPFD = LInt2Dbl(a)
    If QPFD = 0 Then permite_qpc = False
    
End Function

Private Function LInt2Dbl(ByRef nro As LARGE_INTEGER) As Double
    Dim dLo As Double
    Dim dHi As Double
    Dim lLo!
    Dim lHi!
    lLo = nro.LowPart
    lHi = nro.HighPart
    
    If lLo < 0 Then
        dLo = 4294967296# + lLo
    Else
        dLo = lLo
    End If
    If lHi < 0 Then
        dHi = 4294967296# + lHi
    Else
        dHi = lHi
    End If
    
    LInt2Dbl = (dLo + (dHi * 4294967296#))
End Function

Public Function definir_timer(Optional ByVal performance_counter As Boolean = False) As Boolean
If performance_counter = False Then
    use_QPC = False
    QPFD
    definir_timer = True
    Exit Function
End If

If permite_qpc = True And performance_counter = True Then
    use_QPC = True
    QPFD
    definir_timer = True
    Exit Function
End If

If permite_qpc = False And performance_counter = True Then
    use_QPC = False
    QPFD
    definir_timer = False
    Exit Function
End If

End Function


Private Sub Class_Initialize()
    timer_freq = QPFD
    use_QPC = False
    Epsilon = 2 ^ -24
    EpsilonD = 2 ^ -53
    calculate_epsilon
    time
End Sub

Public Function time(Optional ByVal no_reset As Boolean = False) As Single
    Dim z As Double
    
    Do While time < Epsilon
        If use_QPC Then
            z = QPCD
            time = (z - end_time) / timer_freq * 1000
        Else
            z = CDbl(timeGetTime())
            time = (z - end_time)
        End If
    Loop
    
    If time < 0 Then
        use_QPC = False
        end_time = CDbl(timeGetTime())
    End If
        
    If Not no_reset Then end_time = z
End Function

Public Function TimeD() As Double
    Dim z As Double
    
    Do While TimeD < EpsilonD
        If use_QPC Then
            z = QPCD
            TimeD = (z - end_time) / timer_freq * 1000
        Else
            z = CDbl(timeGetTime())
            TimeD = (z - end_time)
        End If
    Loop
    
    If TimeD < 0 Then
        use_QPC = False
        z = CDbl(timeGetTime())
    End If

    end_time = z
End Function

Public Function SysTime() As Single
On Local Error Resume Next
    If use_QPC Then
        SysTime = CSng(QPCD)
    Else
        'multimedia lib - 1ms resolution in W98, 10ms in NT
        SysTime = CDbl(timeGetTime())
    End If
End Function


Private Sub calculate_epsilon()
' EPSILON PUEDE CAMBIAR DEPENDIENDO DE LA ARQUITECTURA DEL PROCESADOR (?)
        Dim machEps!
        machEps = 1
        
        Do
           machEps = machEps / 2
        Loop While ((1 + (machEps / 2)) <> 1)
        
        If machEps <> 0 Then
            Epsilon = machEps
        End If
        
        Dim machEpsD#
        machEpsD = 1
        
        Do
           machEpsD = machEpsD / 2#
        Loop While ((1 + (machEpsD / 2#)) <> 1)
        
        If machEpsD <> 0 Then
            EpsilonD = machEpsD
        End If
End Sub

