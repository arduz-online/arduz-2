Attribute VB_Name = "SysTray"
Option Explicit

Type CWPSTRUCT
    lParam As Long
    wParam As Long
    message As Long
    Hwnd As Long
End Type

Declare Function CallNextHookEx Lib "user32" (ByVal hHook As Long, ByVal ncode As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
Declare Function SetForegroundWindow Lib "user32" (ByVal Hwnd As Long) As Long
Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal idHook As Long, ByVal lpfn As Long, ByVal hmod As Long, ByVal dwThreadId As Long) As Long
Declare Function UnhookWindowsHookEx Lib "user32" (ByVal hHook As Long) As Long

Public Const WH_CALLWNDPROC = 4
Public Const WM_CREATE = &H1

Public hHook As Long

Public Function AppHook(ByVal idHook As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Dim CWP As CWPSTRUCT
    CopyMemory CWP, ByVal lParam, Len(CWP)
    Select Case CWP.message
        Case WM_CREATE
            SetForegroundWindow CWP.Hwnd
            AppHook = CallNextHookEx(hHook, idHook, wParam, ByVal lParam)
            UnhookWindowsHookEx hHook
            hHook = 0
            Exit Function
    End Select
    AppHook = CallNextHookEx(hHook, idHook, wParam, ByVal lParam)
End Function
