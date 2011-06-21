VERSION 5.00
Begin VB.UserControl AsyncDownload 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
End
Attribute VB_Name = "AsyncDownload"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Event DownloadComplete(bytes As Long)
Event DownloadFailed(numero As Long, desc As String)
Event DownloadProgress(b1 As Long, b2 As Long, max As Long)

Private m_Busy As Boolean
Private m_Key As Long
Private m_Bytes() As Byte
Private m_nBytes As Long
Private m_Duration As Long
Private Declare Function GetTickCount Lib "kernel32" () As Long


' **************************************************************
' Initialization and Termination
' **************************************************************
Private Sub UserControl_Initialize()
   ' Nothing to do, really...
End Sub

Private Sub UserControl_InitProperties()
   ' Set default property values.
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
   ' Read properties from storage.
End Sub

Private Sub UserControl_Terminate()
   ' Clean up!
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
   ' Write propertis to storage.
End Sub

Private Sub UserControl_AsyncReadComplete(AsyncProp As AsyncProperty)
   ' Record duration of download.
   m_Duration = Abs(GetTickCount - m_Key)
   ' Reset key to indicate no current download.
   Debug.Print CStr(m_Key); " - "; TicksToTime(GetTickCount); " - done"
   m_Key = 0
   ' Extract downloaded data from AsyncProp
   With AsyncProp
      On Error GoTo BadDownload
      If .AsyncType = vbAsyncTypeByteArray Then
         ' Cache copy of downloaded bytes
         m_Bytes = .Value
         m_nBytes = UBound(m_Bytes) + 1
         RaiseEvent DownloadComplete(m_nBytes)
      End If
   End With
   Exit Sub
BadDownload:
   m_nBytes = 0
   RaiseEvent DownloadFailed(Err.number, Err.Description)
End Sub


Private Sub UserControl_AsyncReadProgress(AsyncProp As AsyncProperty)
   ' Extract downloaded data from AsyncProp
   With AsyncProp
      On Error GoTo BadProgress
      If .AsyncType = vbAsyncTypeByteArray Then
         ' Cache copy of downloaded bytes
         m_Bytes = .Value
         
         m_nBytes = UBound(m_Bytes) + 1
         RaiseEvent DownloadProgress(m_nBytes, .BytesRead, .BytesMax)
      End If
   End With
   Exit Sub
BadProgress:
   ' No need to raise an event, as progress may resume?
End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)
   On Error Resume Next
   Select Case PropertyName
'      Case "DisplayName"
'         Call UpdateDisplayName
      Case Else
         Debug.Print PropertyName
   End Select
End Sub

Private Sub UserControl_Resize()
   Static Busy As Boolean
   ' Restrict size to iconic representation
   If Busy Then Exit Sub
   Busy = True
      With UserControl
         .Width = .ScaleX(.Picture.Width, vbHimetric, .ScaleMode)
         .Height = .ScaleX(.Picture.Height, vbHimetric, .ScaleMode)
      End With
   Busy = False
End Sub

' **********************************************
'  Non-Persisted Properties (read-only)
' **********************************************
Public Property Get Busy() As Boolean
   ' An open key means still downloading.
   Busy = (m_Key <> 0)
End Property

Public Property Get bytes() As Byte()
   ' NOTE: Change conditional constant at top
   '       of module to match target language!
   bytes = m_Bytes()
End Property

Public Property Get Duration() As Long
   ' Return number of milliseconds last transfer took.
   Duration = m_Duration
End Property

' **************************************************************
'  Public Methods
' **************************************************************
Public Sub DownloadCancel()
   ' Attempt to cancel pending download.
   On Error Resume Next
   UserControl.CancelAsyncRead CStr(m_Key)
   Debug.Print CStr(m_Key); " - "; TicksToTime(GetTickCount); " - cancel"
   If Err.number Then
      Debug.Print "CancelAsyncRead Error"; Err.number, Err.Description
   End If
End Sub

Public Function DownloadStart(ByVal URL As String, Optional ByVal Mode As AsyncReadConstants = vbAsyncReadResynchronize) As Boolean

   If Len(URL) Then
      ' Already downloading something, need to cancel!
      If m_Key Then Me.DownloadCancel
      
      ' Reset duration tracker.
      m_Duration = 0
      
      ' Use current time as PropertyName.
      m_Key = GetTickCount()
      Debug.Print CStr(m_Key); " - "; TicksToTime(m_Key); " - "; URL
      
      ' Request user-specified file from web.
      On Local Error Resume Next

         UserControl.AsyncRead URL, vbAsyncTypeByteArray, CStr(m_Key), Mode
      If Err.number Then
         Debug.Print "AsyncRead Error"; Err.number, Err.Description
      End If
      
      DownloadStart = True
   End If
End Function

Public Function SaveAs(ByVal FileName As String) As Boolean
   Dim hFile As Long
   
   ' Bail, if no data has been downloaded.
   If m_nBytes = 0 Then Exit Function
   
   ' Since this is binary, we need to delete existing crud.
   On Error Resume Next
   Kill FileName
   
   ' Okay, now we just spit out what was given.
   On Error GoTo Hell
   hFile = FreeFile
   Open FileName For Binary As hFile
   Put hFile, , m_Bytes
   Close hFile
   DoEvents
   
Hell:
   SaveAs = Not CBool(Err.number)
End Function

' **************************************************************
'  Private Methods
' **************************************************************
Private Function TicksToTime(ByVal Ticks As Long) As Date
   Static Calibrated As Boolean
   Static Zero As Date
   ' Need to calibrate just once.
   If Not Calibrated Then
      Zero = DateAdd("s", -(GetTickCount / 1000), Now)
      Calibrated = True
   End If
   ' Calculate offset from Z-time.
   TicksToTime = DateAdd("s", Ticks / 1000, Zero)
End Function
