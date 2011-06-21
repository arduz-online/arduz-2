VERSION 5.00
Begin VB.UserControl Slider 
   ClientHeight    =   1200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   105
   ScaleHeight     =   80
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   7
   Begin VB.PictureBox picBarOver 
      AutoRedraw      =   -1  'True
      BackColor       =   &H000000FF&
      BorderStyle     =   0  'None
      Height          =   165
      Left            =   1755
      MousePointer    =   99  'Custom
      ScaleHeight     =   11
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   4
      Top             =   975
      Visible         =   0   'False
      Width           =   180
   End
   Begin VB.Timer OverTimer 
      Enabled         =   0   'False
      Interval        =   10
      Left            =   330
      Top             =   3510
   End
   Begin VB.PictureBox picBar 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   165
      Left            =   1410
      MousePointer    =   99  'Custom
      ScaleHeight     =   11
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   3
      Top             =   660
      Visible         =   0   'False
      Width           =   180
   End
   Begin VB.PictureBox picBarDown 
      AutoRedraw      =   -1  'True
      BackColor       =   &H0000FF00&
      BorderStyle     =   0  'None
      Height          =   165
      Left            =   1200
      MousePointer    =   99  'Custom
      ScaleHeight     =   11
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   2
      Top             =   375
      Visible         =   0   'False
      Width           =   180
   End
   Begin VB.PictureBox picBack1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   2070
      Left            =   1005
      ScaleHeight     =   138
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   1
      Top             =   1455
      Visible         =   0   'False
      Width           =   180
   End
   Begin VB.PictureBox picBack 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   2445
      Left            =   0
      MousePointer    =   99  'Custom
      ScaleHeight     =   163
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   0
      Top             =   0
      Width           =   180
   End
End
Attribute VB_Name = "Slider"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As PointAPI) As Long

Private Type PointAPI
    x As Long
    y As Long
End Type

' Declarations
Dim iY As Long
Dim bDrag As Boolean
Dim iMin As Long
Dim iMax As Long
Dim iValue As Long
Private bMouseOver As Boolean, bMouseDown As Boolean
Private iLargeChange As Integer

Public Enum ePos
  Vertical = 0
  Horizontal = 1
End Enum

Private Enum eImg
  Normal = 0
  Down = 1
  Over = 2
End Enum

Private ePosition As ePos
' Events
Event Change(value As Long)
Event Slide(value As Long)
Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Event MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Event MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

'//--------------------------------------------------------------------------

Public Sub ResetPictures()
  picBack.Picture = LoadPicture()
  picBack1.Picture = LoadPicture()
  picBar.Picture = LoadPicture()
  picBarOver.Picture = LoadPicture()
  picBarDown.Picture = LoadPicture()
  picBack.MouseIcon = LoadPicture()
End Sub

Public Property Get MouseIcon() As Picture
    Set MouseIcon = picBar.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_Icon As Picture)
    Set picBack.MouseIcon = New_Icon

    PropertyChanged "MouseIcon"
End Property

Public Property Get BackColor() As OLE_COLOR
    BackColor = picBack.BackColor
End Property

Public Property Let BackColor(ByVal New_Color As OLE_COLOR)
    picBack.BackColor = New_Color
    picBack1.BackColor = New_Color
        
    PropertyChanged "BackColor"
End Property

Public Property Get Position() As ePos
    Position = ePosition
End Property

Public Property Let Position(ByVal NewValue As ePos)
  Dim W As Integer, H As Integer
    ePosition = NewValue
    
    
    If picBar.Picture <> 0 Then
       picBar.AutoSize = True
    Else
       picBar.Width = 9: picBar.height = 9
    End If
    
    picBarOver.Width = picBar.Width: picBarOver.height = picBar.height
    picBarDown.Width = picBar.Width: picBarDown.height = picBar.height
        
    W = ScaleWidth
    H = ScaleHeight
    
    UserControl.Width = H * 15
    UserControl.height = W * 15
    
    picBar.AutoSize = False
    picBarDown.AutoSize = False
    picBarOver.AutoSize = False
        
     UserControl_Resize
    
    PropertyChanged "Position"
End Property

Public Property Get Bar() As Picture
    Set Bar = picBar.Picture
End Property

Public Property Set Bar(ByVal New_Bar As Picture)
    Set picBar.Picture = New_Bar
           
    picBar.AutoSize = True
    
    If picBarDown.Picture = 0 Then
      picBarDown.Picture = picBar.Picture
      picBarDown.AutoSize = True
    End If
    
    If picBarOver.Picture = 0 Then
      picBarOver.Picture = picBar.Picture
      picBarOver.AutoSize = True
    End If
   
    picBar.AutoSize = False
    picBarDown.AutoSize = False
    picBarOver.AutoSize = False

   
    Call DrawBar(Normal)
    PropertyChanged "Bar"
End Property

Public Property Get BarDown() As Picture
    Set BarDown = picBarDown.Picture
End Property

Public Property Set BarDown(ByVal New_Bar As Picture)
    Set picBarDown.Picture = New_Bar
    picBarDown.AutoSize = True
    picBarDown.AutoSize = False
    PropertyChanged "BarDown"
End Property

Public Property Get BarOver() As Picture
    Set BarOver = picBarOver.Picture
End Property

Public Property Set BarOver(ByVal New_Bar As Picture)
    Set picBarOver.Picture = New_Bar
    picBarOver.AutoSize = True
    picBarOver.AutoSize = False
    PropertyChanged "BarOver"
End Property


Private Sub CalcValue()
 On Error Resume Next
   If ePosition = Vertical Then
    iValue = iY / (picBack.height - picBar.height) * (iMin - iMax) - iMax
     If iMin < 0 Then iValue = -iValue Else iValue = iMax - iValue
   Else
    iValue = iY / (picBack.Width - picBar.Width) * (iMax - iMin) + iMin
   End If
End Sub


Private Sub DrawBar(ImgState As eImg, Optional CalculateX As Boolean = True)
  On Error Resume Next
  Dim intY As Integer, intX As Integer
      
      
    If CalculateX Then
      If ePosition = Vertical Then
       If iMin < 0 Then
            iValue = -iValue
       Else
            iValue = iMax - iValue
       End If

        iY = (iValue - iMax) / (iMin - iMax) * (picBack.height - picBar.height)

       intX = 0: intY = iY
      Else
       iY = (iValue - iMin) / (iMax - iMin) * (picBack.Width - picBar.Width)
       intX = iY: intY = 0
      End If
    Else
       If ePosition = Vertical Then intX = 0: intY = iY Else intX = iY: intY = 0
    End If
    
    picBack.Cls
    
    '// draw progress
    If ePosition = Vertical Then
       Call BitBlt(picBack.hDC, intX, intY, picBack1.ScaleWidth, picBack1.ScaleHeight, _
         picBack1.hDC, intX, intY, vbSrcCopy)
    Else
       Call BitBlt(picBack.hDC, 0, 0, intX, picBack1.ScaleHeight, _
         picBack1.hDC, 0, 0, vbSrcCopy)
    End If
   
    '//IMAGE OVER
    If bMouseOver = True Then
       If bMouseDown = True Then
          Call BitBlt(picBack.hDC, intX, intY, picBar.ScaleWidth, picBar.ScaleHeight, _
          picBarDown.hDC, 0, 0, vbSrcCopy)
       Else
          Call BitBlt(picBack.hDC, intX, intY, picBar.ScaleWidth, picBar.ScaleHeight, _
          picBarOver.hDC, 0, 0, vbSrcCopy)
       End If
      
      picBack.Refresh
      UserControl.Refresh
      Exit Sub
    End If

    If ImgState = Normal Then
         Call BitBlt(picBack.hDC, intX, intY, picBar.ScaleWidth, picBar.ScaleHeight, _
         picBar.hDC, 0, 0, vbSrcCopy)
    ElseIf ImgState = Down Then
           Call BitBlt(picBack.hDC, intX, intY, picBar.ScaleWidth, picBar.ScaleHeight, _
           picBarDown.hDC, 0, 0, vbSrcCopy)
        ElseIf ImgState = Over Then
           Call BitBlt(picBack.hDC, intX, intY, picBar.ScaleWidth, picBar.ScaleHeight, _
             picBarOver.hDC, 0, 0, vbSrcCopy)
        End If
        
    picBack.Refresh
    UserControl.Refresh
End Sub
Public Property Get max() As Long
    max = iMax
End Property

Public Property Let max(New_Max As Long)
    If iValue > New_Max Then iValue = New_Max
        
    iMax = New_Max
    Call DrawBar(Normal)
    
    PropertyChanged "Max"
End Property

Public Property Get min() As Long
    min = iMin
End Property

Public Property Let min(New_Min As Long)
    If New_Min > iValue Then iValue = New_Min
    
    iMin = New_Min
    Call DrawBar(Normal)
    picBack_MouseDown 1, 0, 7, 1
picBack_MouseUp 1, 0, 7, 1
    PropertyChanged "Min"
End Property

Public Property Get LargeChange() As Integer
    LargeChange = iLargeChange
End Property

Public Property Let LargeChange(New_Value As Integer)
    If New_Value >= iMax Then Exit Property
    
    iLargeChange = New_Value
        
    PropertyChanged "LargeChange"
End Property


Public Property Get PictureBack() As Picture
    Set PictureBack = picBack.Picture
End Property

Public Property Set PictureBack(ByVal New_Picture As Picture)
    Set picBack.Picture = New_Picture
    picBack.AutoSize = True
    picBack.AutoSize = False
'    UserControl.Width = picBack.ScaleWidth * 15
'    UserControl.Height = picBack.ScaleHeight * 15
    
    If picBack1.Picture = 0 Then
     picBack1.Picture = picBack.Picture
     picBack1.AutoSize = True
     picBack1.AutoSize = False
    End If
    
    Call DrawBar(Normal)
    
    PropertyChanged "PictureBack"
End Property
Public Property Get PictureProgress() As Picture
    Set PictureProgress = picBack1.Picture
End Property

Public Property Set PictureProgress(ByVal New_Picture2 As Picture)
    Set picBack1.Picture = New_Picture2
    picBack1.AutoSize = True
    picBack1.AutoSize = False
    
    Call DrawBar(Normal)
    
    PropertyChanged "PictureProgress"
End Property


Public Property Get value() As Long
    value = iValue
End Property

Public Property Let value(New_Value As Long)
    If New_Value < iMin Or New_Value > iMax Then Exit Property
    If bMouseDown = True Then Exit Property
    iValue = New_Value
    Call DrawBar(Normal)

    PropertyChanged "Value"
End Property
Private Sub picBack_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 1 Then
    
 '// vertical
 If ePosition = Vertical Then
    If y >= iY And y <= iY + picBar.ScaleHeight And Button = 1 Then
        bDrag = True
        bMouseDown = True
        Call DrawBar(Down, False)
    Else
      If iLargeChange = 0 Then
        iY = y
        If iY > picBack.ScaleHeight - (picBar.ScaleHeight / 2) Then iY = picBack.ScaleHeight - (picBar.ScaleHeight / 2)
        If iY < picBar.ScaleHeight / 2 Then iY = picBar.ScaleHeight / 2
        iY = iY - picBar.ScaleHeight / 2
      Else
        If y > iY Then '// sumar
          value = value + LargeChange
        Else
          value = value - LargeChange
        End If
      End If
    End If
 Else '// horizontal
    If x >= iY And x <= iY + picBar.ScaleWidth And Button = 1 Then
        bDrag = True
        bMouseDown = True
        Call DrawBar(Down, False)
    Else
      If iLargeChange = 0 Then
        iY = x
        If iY > picBack.ScaleWidth - (picBar.ScaleWidth / 2) Then iY = picBack.ScaleWidth - (picBar.ScaleWidth / 2)
        If iY < picBar.ScaleWidth / 2 Then iY = picBar.ScaleWidth / 2
        iY = iY - picBar.ScaleWidth / 2
      Else
        If x > iY Then '// sumar
          value = value + LargeChange
        Else
          value = value - LargeChange
        End If
      End If
   End If
   
 End If
  
    RaiseEvent MouseDown(Button, Shift, x, y)
End If
End Sub


Private Sub picBack_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  If bDrag Then  '// dragging
      '// vertical
      If ePosition = Vertical Then
        iY = y

        If iY > picBack.ScaleHeight - (picBar.ScaleHeight / 2) Then iY = picBack.ScaleHeight - (picBar.ScaleHeight / 2)
        
        If iY < picBar.ScaleHeight / 2 Then iY = picBar.ScaleHeight / 2

        iY = iY - picBar.ScaleHeight / 2
      '// horizontal
      Else
        iY = x
        
        If iY > picBack.Width - (picBar.Width / 2) Then iY = picBack.Width - (picBar.Width / 2)

        If iY < picBar.Width / 2 Then iY = picBar.Width / 2
                 
        iY = iY - picBar.Width / 2
        
      End If
        Call CalcValue
        Call DrawBar(Down, False)
        
        RaiseEvent Change(iValue)
        
  Else
    '// mouse over
     If ePosition = Vertical Then
           If bMouseOver = False Then
             bMouseOver = True
             Call DrawBar(Over, False)
             OverTimer.Enabled = True
           End If
     Else
          If bMouseOver = False Then
             bMouseOver = True
             Call DrawBar(Over, False)
             OverTimer.Enabled = True
          End If
     End If
  End If
    
    RaiseEvent MouseMove(Button, Shift, x, y)
  
End Sub

Private Sub picBack_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
   If bDrag = False Then
      Call CalcValue
      RaiseEvent Change(iValue)
      Call DrawBar(Normal)
   End If
      bMouseDown = False
      Call DrawBar(Normal)
      bDrag = False
   RaiseEvent MouseUp(Button, Shift, x, y)
End Sub


Private Sub UserControl_Initialize()
    If iMax = 0 Then iMax = 100
    Call DrawBar(Normal)
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    picBack.Picture = PropBag.ReadProperty("PictureBack", Nothing)
    picBar.MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
    picBack1.Picture = PropBag.ReadProperty("PictureProgress", Nothing)
    picBarDown.Picture = PropBag.ReadProperty("BarDown", Nothing)
    picBarOver.Picture = PropBag.ReadProperty("BarOver", Nothing)
    picBar.Picture = PropBag.ReadProperty("Bar", Nothing)
    picBack.BackColor = PropBag.ReadProperty("BackColor", &H8000000F)
    picBack1.BackColor = picBack.BackColor
    iMin = PropBag.ReadProperty("Min", 0)
    iMax = PropBag.ReadProperty("Max", 100)
    iLargeChange = PropBag.ReadProperty("LargeChange", 0)
    iValue = PropBag.ReadProperty("Value", 0)
    Position = PropBag.ReadProperty("Position", 0)
    'Call DrawBar(Normal)
End Sub

Private Sub UserControl_Resize()
     picBack.Width = UserControl.ScaleWidth
     picBack.height = UserControl.ScaleHeight
     picBack1.Width = picBack.Width
     picBack1.height = picBack.height
     If ePosition = Vertical Then
       picBar.Width = UserControl.ScaleWidth
       picBarDown.Width = UserControl.ScaleWidth
       picBarOver.Width = UserControl.ScaleWidth
     Else
       picBar.height = UserControl.ScaleHeight
       picBarDown.height = UserControl.ScaleHeight
       picBarOver.height = UserControl.ScaleHeight
     End If
     Call DrawBar(Normal)
End Sub


Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("PictureBack", picBack.Picture, Nothing)
    Call PropBag.WriteProperty("MouseIcon", picBar.MouseIcon, Nothing)
    Call PropBag.WriteProperty("PictureProgress", picBack1.Picture, Nothing)
    Call PropBag.WriteProperty("Bar", picBar.Picture, Nothing)
    Call PropBag.WriteProperty("BarOver", picBarOver.Picture, Nothing)
    Call PropBag.WriteProperty("BarDown", picBarDown.Picture, Nothing)
    Call PropBag.WriteProperty("BackColor", picBack.BackColor, &H8000000F)
    Call PropBag.WriteProperty("Min", iMin, 0)
    Call PropBag.WriteProperty("Max", iMax, 100)
    Call PropBag.WriteProperty("LargeChange", iLargeChange, 0)
    Call PropBag.WriteProperty("Value", iValue, 0)
    Call PropBag.WriteProperty("Position", ePosition, 0)

End Sub


Private Sub OverTimer_Timer()
    
    Dim p As PointAPI
    
    GetCursorPos p
    
    If picBack.Hwnd <> WindowFromPoint(p.x, p.y) Then
        
        OverTimer.Enabled = False
        bMouseOver = False
        Call DrawBar(Normal, False)
        
    End If

End Sub

