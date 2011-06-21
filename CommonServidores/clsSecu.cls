VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsIntervalos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public INT_ATTACK As Long
Public INT_ARROWS As Long
Public INT_CAST_SPELL As Long
Public INT_CAST_ATTACK As Long
Public INT_WORK As Long
Public INT_USEITEMU As Long
Public INT_USEITEMDCK As Long
Public INT_SENTRPU As Long

Private Sub Class_Initialize()
If inthack(0) = 0 Then
    INT_ATTACK = 1301 + RandomNumber(-10, 0)
    INT_ARROWS = 1151 + RandomNumber(-10, 0)
    INT_CAST_SPELL = 1051 + RandomNumber(-10, 0)
    INT_CAST_ATTACK = 1151 + RandomNumber(-10, 0)
    INT_WORK = 701 + RandomNumber(-10, 0)
    INT_USEITEMU = 401 + RandomNumber(-10, 0)
    INT_USEITEMDCK = 205 + RandomNumber(-10, 0)
    INT_SENTRPU = 2001 + RandomNumber(-10, 0)
Else
    INT_ATTACK = inthack(0) + RandomNumber(10, 0)
    INT_ARROWS = inthack(1) + RandomNumber(10, 0)
    INT_CAST_SPELL = inthack(2) + RandomNumber(10, 0)
    INT_CAST_ATTACK = inthack(3) + RandomNumber(10, 0)
    INT_WORK = inthack(4) + RandomNumber(10, 0)
    INT_USEITEMU = inthack(5) + RandomNumber(10, 0)
    INT_USEITEMDCK = inthack(6) + RandomNumber(10, 0)
    INT_SENTRPU = inthack(7) + RandomNumber(10, 0)
End If
End Sub

Private Sub set_class(ByVal UserIndex As Integer)
    Dim i As Long
    i = UserList(UserIndex).clase
    INT_ATTACK = Abs(bClases(i).intervalos(5) + RandomNumber(-5, 0))
    INT_ARROWS = Abs(bClases(i).intervalos(4) + RandomNumber(-5, 0))
    INT_CAST_SPELL = Abs(bClases(i).intervalos(3) + RandomNumber(-5, 0))
    INT_CAST_ATTACK = Abs(bClases(i).intervalos(2) + RandomNumber(-5, 0))
    INT_USEITEMDCK = Abs(bClases(i).intervalos(1) + RandomNumber(-5, 0))
    INT_USEITEMU = Abs(bClases(i).intervalos(0) + RandomNumber(-5, 0))
End Sub

Public Sub WriteIntervals(ByVal UserIndex As Integer)
'On Error GoTo errhandler
    With UserList(UserIndex).outgoingData
        set_class UserIndex
        Call .WriteByte(51)
        Call .WriteLong(INT_USEITEMU)
        Call .WriteLong(INT_USEITEMDCK)
        Call .WriteLong(INT_CAST_ATTACK)
        Call .WriteLong(INT_CAST_SPELL)
        Call .WriteLong(INT_ARROWS)
        Call .WriteLong(INT_ATTACK)
        Call FlushBuffer(UserIndex)
    End With
Exit Sub

ErrHandler:
    If Err.Number = UserList(UserIndex).outgoingData.NotEnoughSpaceErrCode Then
        Call FlushBuffer(UserIndex)
        Resume
    End If
End Sub
