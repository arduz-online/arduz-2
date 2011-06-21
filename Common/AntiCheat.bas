Attribute VB_Name = "AntiCheat"
Option Explicit

Public Declare Function GetModuleHandle Lib "kernel32" Alias "GetModuleHandleA" (ByVal lpModuleName As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

Dim XORencode As Long
Dim acStarted As Boolean
Dim gtc&
Dim lastGTC&

Public Function watchdogACgtc(Optional ByVal reset As Boolean = False) As Boolean
'menduz es amor
Dim start_time As Currency
Static end_time As Currency, timer_freq As Currency
Static last_t As Currency
Dim tmp2&, tmp&, dif&, dif1&

    If timer_freq = 0 Then
        QueryPerformanceFrequency timer_freq
    End If
    
    Call QueryPerformanceCounter(start_time)
    dif = (start_time - end_time) / timer_freq * 1000
    Call QueryPerformanceCounter(end_time)
    last_t = end_time
    
    dif1 = GetTickCount() - (lastGTC Xor XORencode)
    
    'If dif1 - dif > 20 Then ende
    
    If reset = False Then
        If ((dif1 - frmMain.Second.Interval) - (dif1 - dif)) > 1000 Then WriteBankStart
    End If
    
    If XORencode <> 0 Then tmp2 = gtc Xor XORencode
    
    tmp = GetModuleHandle("kernel32")
    gtc = GetProcAddress(tmp, "GetTickCount")
    
    If gtc <> tmp2 And XORencode <> 0 Then WriteBankStart
    
    XORencode = (CLng(Rnd * gtc) + 1)
    gtc = gtc Xor XORencode
    lastGTC = GetTickCount() Xor XORencode
End Function
