Attribute VB_Name = "Timers"
Option Explicit

'cRVTDX.mTimers - a component of the rvtDX.dll
'Up to 10 timers using either QPF or mmTimer. Based on DXUtil_Timer in the DirectX App framework

Private Type zUTimer
  cStopTime As Currency   'when using QPF timer
  cPrevTime As Currency
  cBaseTime As Currency
  bStopped  As Boolean    'stopped or not
  fPrevTime As Double     'when using mm timer
  fBaseTime As Double
  fStopTime As Double
End Type

Private zUTimers(0 To 9) As zUTimer   'timer 0 is default timer
Private zMaxTimer        As Long
Private UsingQPF         As Boolean
Private QPFTicksPerSec   As Double

Private Enum TIMER_COMMAND
  TIMER_RESET
  TIMER_START
  TIMER_STOP
  TIMER_GETAPPTIME
  TIMER_GETSPLITTIME
End Enum

Private Declare Function QueryPerformanceCounter Lib "kernel32.dll" (ByRef X As Currency) As Boolean   'ticks
Private Declare Function QueryPerformanceFrequency Lib "kernel32.dll" (ByRef X As Currency) As Boolean 'tickspersec
Private Declare Function timeGetTime Lib "winmm.dll" () As Long                                        'millisecs

Public Sub InitializeTimers()     'called from cDX8

 Dim i As Long, tps As Currency

  For i = 0 To UBound(zUTimers)
    zUTimers(i).bStopped = True
  Next i

  ' Use QueryPerformanceFrequency() to get frequency of timer.  If QPF is
  ' not supported, we will use timeGetTime() which returns milliseconds.
  UsingQPF = (QueryPerformanceFrequency(tps) <> False)
  QPFTicksPerSec = CDbl(tps)

End Sub

'A Generic GetTime
Public Function SysTime() As Single       'seconds since system start

 Dim cTime As Currency

  If UsingQPF Then
    Call QueryPerformanceCounter(cTime)
    SysTime = CDbl(cTime) / QPFTicksPerSec
  Else
    SysTime = CDbl(timeGetTime()) * 0.001       'multimedia lib - 1ms resolution in W98, 10ms in NT
  End If

End Function

'========================================== USER TIMERS ========================================================

Public Function NewUTimer() As Long           'return a TimerID  0-9

  NewUTimer = zMaxTimer
  If zMaxTimer > UBound(zUTimers) Then         'use Timer0
    NewUTimer = 0
  Else
    zMaxTimer = zMaxTimer + 1
  End If
  zUTimers(NewUTimer).bStopped = True

End Function

Public Function SplitTime(Optional ByVal WhichTimer As Long = 0) As Single     'seconds since last split

  SplitTime = UTimer(WhichTimer, TIMER_GETSPLITTIME)

End Function

Public Function AppTime(Optional ByVal WhichTimer As Long = 0) As Single      'time since reset/start

  AppTime = UTimer(WhichTimer, TIMER_GETAPPTIME)

End Function

Public Function ResetTimer(Optional ByVal WhichTimer As Long = 0) As Single    '=0

  ResetTimer = UTimer(WhichTimer, TIMER_RESET)

End Function

Public Function StartTimer(Optional ByVal WhichTimer As Long = 0) As Single  '=0

  StartTimer = UTimer(WhichTimer, TIMER_START)

End Function

Public Function StopTimer(Optional ByVal WhichTimer As Long = 0) As Single  '0

  StopTimer = UTimer(WhichTimer, TIMER_STOP)

End Function

'-------------------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------------------
' Name: UTimer(WhichTimer,Command)
' Desc: Performs timer opertations. Using the following commands:
'          TIMER_RESET           - to reset the timer
'          TIMER_START           - to start the timer
'          TIMER_STOP            - to stop (or pause) the timer
'          TIMER_GETAPPTIME      - to get the elapsed application defined time from start/reset
'          TIMER_GETSPLITTIME    - to get the time that elapsed between TIMER_GETSPLITTIME calls
'-------------------------------------------------------------------------------------------------------------
'TIMER MUST BE INITIALISED THOUGH A CALL TO INITIALIZETIMERS() (oddly enough)
Private Function UTimer(ByVal WhichTimer As Long, ByVal Command As TIMER_COMMAND) As Single

 Dim cTime As Currency
 Dim fTime As Double
 Dim dTime As Double

  UTimer = 0
  If UsingQPF Then
    With zUTimers(WhichTimer)
      ' Get either the current time or the stop time, _
          ' depending on whether we're stopped and what command was sent
      If .cStopTime <> 0 And Command <> TIMER_START Then
        cTime = .cStopTime
      Else
        Call QueryPerformanceCounter(cTime)
      End If

      Select Case Command
       Case TIMER_GETSPLITTIME:          ' Return the elapsed time
        dTime = CDbl(cTime - .cPrevTime) / QPFTicksPerSec
        .cPrevTime = cTime
        UTimer = dTime

       Case TIMER_GETAPPTIME:              ' Return the current time
        UTimer = CDbl(cTime - .cBaseTime) / QPFTicksPerSec

       Case TIMER_RESET:                   ' Reset the timer
        .cBaseTime = cTime
        .cPrevTime = cTime
        .cStopTime = 0
        .bStopped = False

       Case TIMER_START:                   ' Start the timer
        If .bStopped Then .cBaseTime = .cBaseTime + (cTime - .cStopTime)
        .cStopTime = 0
        .cPrevTime = cTime
        .bStopped = False

       Case TIMER_STOP:                    ' Stop the timer
        If Not .bStopped Then
          .cStopTime = cTime
          .cPrevTime = cTime
          .bStopped = True
        End If

       Case Else:
        UTimer = -1#                ' Invalid command specified
      End Select
    End With
  Else    ' Get the time using timeGetTime()

    With zUTimers(WhichTimer)
      ' Get either the current time or the stop time, depending
      ' on whether we're stopped and what command was sent
      If .fStopTime <> 0# And Command <> TIMER_START Then
        fTime = .fStopTime
      Else
        fTime = CDbl(timeGetTime()) * 0.001       'multimedia lib - 1ms resolution in W98, 10ms in NT
      End If

      Select Case Command
       Case TIMER_GETSPLITTIME:            ' Return the elapsed time
        dTime = fTime - .fPrevTime
        .fPrevTime = fTime
        UTimer = dTime

       Case TIMER_GETAPPTIME:              ' Return the current time
        UTimer = fTime - .fBaseTime

       Case TIMER_RESET:                   ' Reset the timer
        .fBaseTime = fTime
        .fPrevTime = fTime
        .fStopTime = 0
        .bStopped = False

       Case TIMER_START:                   ' Start the timer
        If .bStopped Then .fBaseTime = .fBaseTime + (fTime - .fStopTime)
        .fStopTime = 0#
        .fPrevTime = fTime
        .bStopped = False

       Case TIMER_STOP:                    ' Stop the timer
        If Not .bStopped Then
          .fStopTime = fTime
          .fPrevTime = fTime
          .bStopped = True
        End If

       Case Else:
        UTimer = -1#                ' Invalid command specified
      End Select
    End With
  End If

End Function

'-----------------------------------------------------------------------------
' Name: UpdateFPS()
' Desc:
'-----------------------------------------------------------------------------
Private Function InstantFPS() As Single

 ' Keep track of the frame count

 Static fPrevSysTime As Single
 Static dwFrames     As Long
 Static m_fFPS       As Single
 Dim fTime As Single, dTime As Single

  fTime = SysTime()
  dwFrames = dwFrames + 1

  ' Update the scene stats once per second
  dTime = fTime - fPrevSysTime
  If dTime > 1# Then
    m_fFPS = dwFrames / dTime
    fPrevSysTime = fTime
    dwFrames = 0
  End If

  InstantFPS = m_fFPS

End Function

':) Ulli's VB Code Formatter V2.16.6(edRVT) (2004-Sep-06 14:14) 31 + 210 = 241 Lines


