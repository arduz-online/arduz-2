VERSION 5.00
Begin VB.UserControl ctlScrollbar 
   AutoRedraw      =   -1  'True
   ClientHeight    =   1440
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   255
   ScaleHeight     =   96
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   17
   ToolboxBitmap   =   "ctlScrollbar.ctx":0000
   Begin VB.Timer Tracking3 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   2700
      Top             =   660
   End
   Begin VB.Timer Tracking1 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   1740
      Top             =   660
   End
   Begin VB.Timer Tracking2 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   2220
      Top             =   660
   End
   Begin VB.Timer tmUp2 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   300
      Top             =   480
   End
   Begin VB.Timer tmDn2 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   780
      Top             =   480
   End
   Begin VB.Timer tmDn 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   780
      Top             =   0
   End
   Begin VB.Timer tmUp 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   300
      Top             =   0
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      Height          =   255
      Left            =   0
      ScaleHeight     =   13
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   0
      Top             =   0
      Width           =   255
   End
   Begin VB.PictureBox Picture4 
      AutoRedraw      =   -1  'True
      Height          =   795
      Left            =   0
      ScaleHeight     =   49
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   2
      Top             =   240
      Width           =   255
      Begin VB.PictureBox Picture2 
         AutoRedraw      =   -1  'True
         Height          =   255
         Left            =   0
         ScaleHeight     =   13
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   13
         TabIndex        =   3
         Top             =   0
         Width           =   255
      End
   End
   Begin VB.PictureBox Picture3 
      AutoRedraw      =   -1  'True
      Height          =   255
      Left            =   0
      ScaleHeight     =   13
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   1
      Top             =   1020
      Width           =   255
   End
End
Attribute VB_Name = "ctlScrollbar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Declare Function DrawEdge Lib "user32.dll" (ByVal hdc As Long, ByRef qrc As RECT, ByVal edge As Long, ByVal grfFlags As Long) As Long
Private Declare Function SetRect Lib "user32.dll" (ByRef lpRect As RECT, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function OffsetRect Lib "user32.dll" (ByRef lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function DeleteObject Lib "gdi32.dll" (ByVal hObject As Long) As Long
Private Declare Function InflateRect Lib "user32.dll" (ByRef lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As PointAPI) As Long

Private Type PointAPI
        x As Long
        y As Long
End Type

Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Enum OrientType
    [Verticle] = 0
    [Horizontal] = 1
End Enum

Public Enum EdgeType
    [Raised] = 0
    [Sunken] = 1
    [Bump] = 2
    [Etched] = 3
    [Flat Raised] = 4
    [Flat Sunken] = 5
End Enum

Private Const BF_ADJUST As Long = &H2000
Private Const BF_BOTTOM As Long = &H8
Private Const BF_FLAT As Long = &H4000
Private Const BF_LEFT As Long = &H1
Private Const BF_DIAGONAL As Long = &H10
Private Const BF_RIGHT As Long = &H4
Private Const BF_SOFT As Long = &H1000
Private Const BF_TOP As Long = &H2
Private Const BF_MIDDLE As Long = &H800
Private Const BF_MONO As Long = &H8000
Private Const BF_BOTTOMLEFT As Long = (BF_BOTTOM Or BF_LEFT)
Private Const BF_BOTTOMRIGHT As Long = (BF_BOTTOM Or BF_RIGHT)
Private Const BF_DIAGONAL_ENDBOTTOMLEFT As Long = (BF_DIAGONAL Or BF_BOTTOM Or BF_LEFT)
Private Const BF_DIAGONAL_ENDBOTTOMRIGHT As Long = (BF_DIAGONAL Or BF_BOTTOM Or BF_RIGHT)
Private Const BF_DIAGONAL_ENDTOPLEFT As Long = (BF_DIAGONAL Or BF_TOP Or BF_LEFT)
Private Const BF_DIAGONAL_ENDTOPRIGHT As Long = (BF_DIAGONAL Or BF_TOP Or BF_RIGHT)
Private Const BF_RECT As Long = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)
Private Const BF_TOPLEFT As Long = (BF_TOP Or BF_LEFT)
Private Const BF_TOPRIGHT As Long = (BF_TOP Or BF_RIGHT)
Private Const BDR_INNER As Long = &HC
Private Const BDR_OUTER As Long = &H3
Private Const BDR_RAISED As Long = &H5
Private Const BDR_RAISEDINNER As Long = &H4
Private Const BDR_RAISEDOUTER As Long = &H1
Private Const BDR_SUNKEN As Long = &HA
Private Const BDR_SUNKENINNER As Long = &H8
Private Const BDR_SUNKENOUTER As Long = &H2
Private Const EDGE_BUMP As Long = (BDR_RAISEDOUTER Or BDR_SUNKENINNER)
Private Const EDGE_ETCHED As Long = (BDR_SUNKENOUTER Or BDR_RAISEDINNER)
Private Const EDGE_RAISED As Long = (BDR_RAISEDOUTER Or BDR_RAISEDINNER)
Private Const EDGE_SUNKEN As Long = (BDR_SUNKENOUTER Or BDR_SUNKENINNER)
Private Const EDGE_RFLAT As Long = BDR_RAISEDOUTER
Private Const EDGE_SFLAT As Long = BDR_SUNKENOUTER

Dim MX As Single
Dim TrueVal As Integer
Dim sChange As Integer
Dim lChange As Integer
Dim UpBtn As Boolean
Dim TmBtn As Boolean
Dim DnBtn As Boolean
Dim SUpBtn As Boolean
Dim SDnBtn As Boolean
Dim u_PictureNormal As StdPicture
Dim u_PictureOver As StdPicture
Dim u_PictureDown As StdPicture
Dim d_PictureNormal As StdPicture
Dim d_PictureOver As StdPicture
Dim d_PictureDown As StdPicture
Dim t_PictureNormal As StdPicture
Dim t_PictureOver As StdPicture
Dim t_PictureDown As StdPicture
Dim b_PictureNormal As StdPicture
Dim m_tColor As OLE_COLOR
Dim m_Min As Integer
Dim m_Max As Integer
Dim m_Value As Integer
Dim tHandle As Integer
Dim SOver As EdgeType
Dim SNorm As EdgeType
Dim SDown As EdgeType
Dim UpPic As Boolean
Dim TbPic As Boolean
Dim DnPic As Boolean
Dim mOrient As OrientType
Event Scroll()
Attribute Scroll.VB_MemberFlags = "200"
Event Change()

Public Property Get Orientation() As OrientType
    Orientation = mOrient
End Property

Public Property Let Orientation(New_Or As OrientType)
    mOrient = New_Or
    PropertyChanged "Orientation"
    DrawButton
End Property

Public Property Get BackgroundPicture() As StdPicture
Attribute BackgroundPicture.VB_Description = "Set the background picture."
Attribute BackgroundPicture.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set BackgroundPicture = b_PictureNormal
End Property

Public Property Set BackgroundPicture(New_bPic As StdPicture)
    Set b_PictureNormal = New_bPic
    PropertyChanged "BackgroundPicture"
    DrawButton
End Property

Public Property Get UsePictureUp() As Boolean
Attribute UsePictureUp.VB_Description = "Determine whether or not pictures are used for the up arrow."
Attribute UsePictureUp.VB_ProcData.VB_Invoke_Property = ";Behavior"
    UsePictureUp = UpPic
End Property

Public Property Let UsePictureUp(New_PicUp As Boolean)
    UpPic = New_PicUp
    PropertyChanged "UsePictureUp"
    DrawButton
End Property

Public Property Get UsePictureDown() As Boolean
Attribute UsePictureDown.VB_Description = "Determine whether or not pictures are used for the down arrow."
Attribute UsePictureDown.VB_ProcData.VB_Invoke_Property = ";Behavior"
    UsePictureDown = DnPic
End Property

Public Property Let UsePictureDown(New_PicDn As Boolean)
    DnPic = New_PicDn
    PropertyChanged "UsePictureDown"
    DrawButton
End Property

Public Property Get UsePictureThumb() As Boolean
Attribute UsePictureThumb.VB_Description = "Determine whether or not pictures are used for the thumb."
Attribute UsePictureThumb.VB_ProcData.VB_Invoke_Property = ";Behavior"
    UsePictureThumb = TbPic
End Property

Public Property Let UsePictureThumb(New_PicTb As Boolean)
    TbPic = New_PicTb
    PropertyChanged "UsePictureThumb"
    DrawButton
End Property

Public Property Get UpButtonNormal() As StdPicture
Attribute UpButtonNormal.VB_Description = "Set the picture for the up arrow when mouse is not over it."
Attribute UpButtonNormal.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set UpButtonNormal = u_PictureNormal
End Property

Public Property Set UpButtonNormal(New_BtnNormal As StdPicture)
    Set u_PictureNormal = New_BtnNormal
    PropertyChanged "UpButtonNormal"
    DrawButton
End Property

Public Property Get UpButtonHover() As StdPicture
Attribute UpButtonHover.VB_Description = "Set the picture for the up arrow when mouse is over it."
Attribute UpButtonHover.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set UpButtonHover = u_PictureOver
End Property

Public Property Set UpButtonHover(New_BtnHover As StdPicture)
    Set u_PictureOver = New_BtnHover
    PropertyChanged "UpButtonHover"
    DrawButton
End Property

Public Property Get UpButtonDown() As StdPicture
Attribute UpButtonDown.VB_Description = "Set the picture for the up arrow when mouse is down."
Attribute UpButtonDown.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set UpButtonDown = u_PictureDown
End Property

Public Property Set UpButtonDown(New_BtnDown As StdPicture)
    Set u_PictureDown = New_BtnDown
    PropertyChanged "UpButtonDown"
    DrawButton
End Property

Public Property Get DownButtonNormal() As StdPicture
Attribute DownButtonNormal.VB_Description = "Set the down arrow picture when mouse is not over it."
Attribute DownButtonNormal.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set DownButtonNormal = d_PictureNormal
End Property

Public Property Set DownButtonNormal(New_BtnNormal As StdPicture)
    Set d_PictureNormal = New_BtnNormal
    PropertyChanged "DownButtonNormal"
    DrawButton
End Property

Public Property Get DownButtonHover() As StdPicture
Attribute DownButtonHover.VB_Description = "Set the down arrow picture when mouse is over it."
Attribute DownButtonHover.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set DownButtonHover = d_PictureOver
End Property

Public Property Set DownButtonHover(New_BtnHover As StdPicture)
    Set d_PictureOver = New_BtnHover
    PropertyChanged "DownButtonHover"
    DrawButton
End Property

Public Property Get DownButtonDown() As StdPicture
Attribute DownButtonDown.VB_Description = "Set the down arrow picture when mouse is down."
Attribute DownButtonDown.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set DownButtonDown = d_PictureDown
End Property

Public Property Set DownButtonDown(New_BtnDown As StdPicture)
    Set d_PictureDown = New_BtnDown
    PropertyChanged "DownButtonDown"
    DrawButton
End Property

Public Property Get ThumbButtonNormal() As StdPicture
Attribute ThumbButtonNormal.VB_Description = "Set the picture for the thumb when mouse is not over it."
Attribute ThumbButtonNormal.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set ThumbButtonNormal = t_PictureNormal
End Property

Public Property Set ThumbButtonNormal(New_BtnNormal As StdPicture)
    Set t_PictureNormal = New_BtnNormal
    PropertyChanged "ThumbButtonNormal"
    DrawButton
End Property

Public Property Get ThumbButtonHover() As StdPicture
Attribute ThumbButtonHover.VB_Description = "Set the picture for the thumb when mouse is over it."
Attribute ThumbButtonHover.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set ThumbButtonHover = t_PictureOver
End Property

Public Property Set ThumbButtonHover(New_BtnHover As StdPicture)
    Set t_PictureOver = New_BtnHover
    PropertyChanged "ThumbButtonHover"
    DrawButton
End Property

Public Property Get ThumbButtonDown() As StdPicture
Attribute ThumbButtonDown.VB_Description = "Set the picture for the thumb when mouse is down."
Attribute ThumbButtonDown.VB_ProcData.VB_Invoke_Property = ";Appearance"
    Set ThumbButtonDown = t_PictureDown
End Property

Public Property Set ThumbButtonDown(New_BtnDown As StdPicture)
    Set t_PictureDown = New_BtnDown
    PropertyChanged "ThumbButtonDown"
    DrawButton
End Property

Public Property Get StateOver() As EdgeType
Attribute StateOver.VB_Description = "Set the bevel method when no picture is used and mouse is over it."
Attribute StateOver.VB_ProcData.VB_Invoke_Property = ";Appearance"
    StateOver = SOver
End Property

Public Property Let StateOver(New_StateOver As EdgeType)
    SOver = New_StateOver
    PropertyChanged "StateOver"
    DrawButton
End Property

Public Property Get StateNormal() As EdgeType
Attribute StateNormal.VB_Description = "Set the bevel method when no picture is used and mouse is not over it."
Attribute StateNormal.VB_ProcData.VB_Invoke_Property = ";Appearance"
    StateNormal = SNorm
End Property

Public Property Let StateNormal(New_StateNormal As EdgeType)
    SNorm = New_StateNormal
    PropertyChanged "StateNormal"
    DrawButton
End Property

Public Property Get StateDown() As EdgeType
Attribute StateDown.VB_Description = "Set the bevel method when no picture is used and mouse is down."
Attribute StateDown.VB_ProcData.VB_Invoke_Property = ";Appearance"
    StateDown = SDown
End Property

Public Property Let StateDown(New_StateDown As EdgeType)
    SDown = New_StateDown
    PropertyChanged "StateDown"
    DrawButton
End Property

Public Property Get Value() As Double
Attribute Value.VB_Description = "Return/Set the value."
Attribute Value.VB_ProcData.VB_Invoke_Property = ";Position"
    Value = m_Value
End Property

Public Property Let Value(New_Value As Double)
    If New_Value < m_Min Then New_Value = m_Min
    If New_Value > m_Max Then New_Value = m_Max
    m_Value = New_Value
    PropertyChanged "Value"
    TrueVal = 0
    TrueVal = TrueVal + ((sChange * tHandle) * (New_Value - m_Min))
    DrawButton
End Property

Public Property Get Min() As Double
Attribute Min.VB_Description = "Set the minimum value."
Attribute Min.VB_ProcData.VB_Invoke_Property = ";Behavior"
    Min = m_Min
End Property

Public Property Let Min(New_Min As Double)
    m_Min = New_Min
    PropertyChanged "Min"
    DrawButton
End Property

Public Property Get Max() As Double
Attribute Max.VB_Description = "Set the maximum value."
Attribute Max.VB_ProcData.VB_Invoke_Property = ";Behavior"
    Max = m_Max
End Property

Public Property Let Max(New_Max As Double)
    m_Max = New_Max
    PropertyChanged "Max"
    DrawButton
End Property

Public Property Get SmallChange() As Integer
Attribute SmallChange.VB_Description = "Set the small change."
Attribute SmallChange.VB_ProcData.VB_Invoke_Property = ";Behavior"
    SmallChange = sChange
End Property

Public Property Let SmallChange(New_sChange As Integer)
    sChange = New_sChange
    PropertyChanged "SmallChange"
    DrawButton
End Property

Public Property Get LargeChange() As Integer
Attribute LargeChange.VB_Description = "Set the large change value."
Attribute LargeChange.VB_ProcData.VB_Invoke_Property = ";Behavior"
    LargeChange = lChange
End Property

Public Property Let LargeChange(New_lChange As Integer)
    lChange = New_lChange
    PropertyChanged "LargeChange"
    DrawButton
End Property
Public Property Get TrackColor() As OLE_COLOR
Attribute TrackColor.VB_Description = "Set background color."
Attribute TrackColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
    TrackColor = m_tColor
End Property

Public Property Let TrackColor(New_tColor As OLE_COLOR)
    m_tColor = New_tColor
    PropertyChanged "TrackColor"
    DrawButton
End Property

Private Sub SetBound(PictureBx As Control, Width As Long, Height As Long)
    PictureBx.Width = Width
    PictureBx.Height = Height
End Sub

Private Sub SetPos(PictureBx As Control, Left As Long, Top As Long)
    PictureBx.Left = Left
    PictureBx.Top = Top
End Sub

Private Sub DrawArrow(Control As Control, Down As Boolean, ArrowUp As Boolean)
    Dim CHPos As Long, CVPos As Long
    
    If mOrient = 0 Then
        CHPos = Int((UserControl.ScaleWidth / 2) + 0.5)
        CVPos = Int((17 / 2) + 0.5)
    
        If ArrowUp = True Then
            If Down = False Then
                Control.Line (CHPos - 1, CVPos - 2)-(CHPos, CVPos - 2), vbButtonText
                Control.Line (CHPos - 2, CVPos - 1)-(CHPos + 1, CVPos - 1), vbButtonText
                Control.Line (CHPos - 3, CVPos)-(CHPos + 2, CVPos), vbButtonText
                Control.Line (CHPos - 4, CVPos + 1)-(CHPos + 3, CVPos + 1), vbButtonText
            Else
                Control.Line (CHPos, CVPos - 1)-(CHPos + 1, CVPos - 1), vbButtonText
                Control.Line (CHPos - 1, CVPos)-(CHPos + 2, CVPos), vbButtonText
                Control.Line (CHPos - 2, CVPos + 1)-(CHPos + 3, CVPos + 1), vbButtonText
                Control.Line (CHPos - 3, CVPos + 2)-(CHPos + 4, CVPos + 2), vbButtonText
            End If
        Else
            If Down = False Then
                Control.Line (CHPos - 4, CVPos - 3)-(CHPos + 3, CVPos - 3), vbButtonText
                Control.Line (CHPos - 3, CVPos - 2)-(CHPos + 2, CVPos - 2), vbButtonText
                Control.Line (CHPos - 2, CVPos - 1)-(CHPos + 1, CVPos - 1), vbButtonText
                Control.Line (CHPos - 1, CVPos)-(CHPos + 0, CVPos), vbButtonText
            Else
                Control.Line (CHPos - 3, CVPos - 2)-(CHPos + 4, CVPos - 2), vbButtonText
                Control.Line (CHPos - 2, CVPos - 1)-(CHPos + 3, CVPos - 1), vbButtonText
                Control.Line (CHPos - 1, CVPos)-(CHPos + 2, CVPos), vbButtonText
                Control.Line (CHPos, CVPos + 1)-(CHPos + 1, CVPos + 1), vbButtonText
            End If
        End If
    Else
        CHPos = Int((17 / 2) + 0.5)
        CVPos = Int((UserControl.ScaleHeight / 2) + 0.5)
    
        If ArrowUp = True Then
            If Down = False Then
                Control.Line (CHPos - 2, CVPos - 1)-(CHPos - 2, CVPos), vbButtonText
                Control.Line (CHPos - 1, CVPos - 2)-(CHPos - 1, CVPos + 1), vbButtonText
                Control.Line (CHPos, CVPos - 3)-(CHPos, CVPos + 2), vbButtonText
                Control.Line (CHPos + 1, CVPos + -4)-(CHPos + 1, CVPos + 3), vbButtonText
            Else
                Control.Line (CHPos - 1, CVPos)-(CHPos - 1, CVPos + 1), vbButtonText
                Control.Line (CHPos, CVPos - 1)-(CHPos, CVPos + 2), vbButtonText
                Control.Line (CHPos + 1, CVPos - 2)-(CHPos + 1, CVPos + 3), vbButtonText
                Control.Line (CHPos + 2, CVPos + -3)-(CHPos + 2, CVPos + 4), vbButtonText
            End If
        Else
            If Down = False Then
                Control.Line (CHPos - 3, CVPos - 4)-(CHPos - 3, CVPos + 3), vbButtonText
                Control.Line (CHPos - 2, CVPos - 3)-(CHPos - 2, CVPos + 2), vbButtonText
                Control.Line (CHPos - 1, CVPos - 2)-(CHPos - 1, CVPos + 1), vbButtonText
                Control.Line (CHPos, CVPos - 1)-(CHPos, CVPos), vbButtonText
            Else
                Control.Line (CHPos - 2, CVPos - 3)-(CHPos - 2, CVPos + 4), vbButtonText
                Control.Line (CHPos - 1, CVPos - 2)-(CHPos - 1, CVPos + 3), vbButtonText
                Control.Line (CHPos, CVPos - 1)-(CHPos, CVPos + 2), vbButtonText
                Control.Line (CHPos + 1, CVPos)-(CHPos + 1, CVPos + 1), vbButtonText
            End If
        End If
    End If
End Sub

Private Sub AlignControls()
    If mOrient = 0 Then
        SetPos Picture1, 0, 0
        SetPos Picture3, 0, UserControl.ScaleHeight - Picture3.Height
        SetPos Picture4, 0, Picture1.Height
        SetBound Picture4, UserControl.ScaleWidth, Picture3.Top - Picture4.Top
    Else
        SetPos Picture1, 0, 0
        SetPos Picture3, UserControl.ScaleWidth - Picture3.Width, 0
        SetPos Picture4, Picture1.Width, 0
        SetBound Picture4, Picture3.Left - Picture4.Left, UserControl.ScaleHeight
    End If
End Sub

Private Sub DrawButton()
    On Error Resume Next
    Dim hRec1 As RECT, hRec2 As RECT, hRec3 As RECT

    Picture1.Cls
    Picture2.Cls
    Picture3.Cls
    Picture4.Cls
    
    If mOrient = 0 Then
        SetPos Picture1, 0, 0
        SetPos Picture3, 0, UserControl.ScaleHeight - Picture3.Height
        SetPos Picture4, 0, Picture1.Height
        SetBound Picture4, UserControl.ScaleWidth, Picture3.Top - Picture4.Top
    Else
        SetPos Picture1, 0, 0
        SetPos Picture3, UserControl.ScaleWidth - Picture3.Width, 0
        SetPos Picture4, Picture1.Width, 0
        SetBound Picture4, Picture3.Left - Picture4.Left, UserControl.ScaleHeight
    End If
        

        If UpBtn = True And CheckMouseOver(Picture1.Hwnd) = True Then
            Picture1.Height = GetDis(u_PictureDown.Height)
            Picture1.Width = GetDis(u_PictureDown.Width)
            Picture1.PaintPicture u_PictureDown, 0, 0
            AlignControls
        Else
            If CheckMouseOver(Picture1.Hwnd) = True And SDnBtn = False And SUpBtn = False And TmBtn = False And DnBtn = False Then
                Picture1.Height = GetDis(u_PictureOver.Height)
                Picture1.Width = GetDis(u_PictureOver.Width)
                Picture1.PaintPicture u_PictureOver, 0, 0
                AlignControls
                Tracking1.Enabled = True
            Else
                Picture1.Height = GetDis(u_PictureNormal.Height)
                Picture1.Width = GetDis(u_PictureNormal.Width)
                Picture1.PaintPicture u_PictureNormal, 0, 0
                AlignControls
            End If
        End If
    

        If TmBtn = True And CheckMouseOver(Picture2.Hwnd) = True Then
            Picture2.Height = GetDis(t_PictureDown.Height)
            Picture2.Width = GetDis(t_PictureDown.Width)
            Picture2.PaintPicture t_PictureDown, 0, 0
            AlignControls
        Else
            If CheckMouseOver(Picture2.Hwnd) = True And SDnBtn = False And SUpBtn = False And UpBtn = False And DnBtn = False Then
                Picture2.Height = GetDis(t_PictureOver.Height)
                Picture2.Width = GetDis(t_PictureOver.Width)
                Picture2.PaintPicture t_PictureOver, 0, 0
                AlignControls
                Tracking2.Enabled = True
            Else
                Picture2.Height = GetDis(t_PictureNormal.Height)
                Picture2.Width = GetDis(t_PictureNormal.Width)
                Picture2.PaintPicture t_PictureNormal, 0, 0
                AlignControls
            End If
        End If

    

        If DnBtn = True And CheckMouseOver(Picture3.Hwnd) = True Then
            Picture3.Height = GetDis(d_PictureDown.Height)
            Picture3.Width = GetDis(d_PictureDown.Width)
            Picture3.PaintPicture d_PictureDown, 0, 0
            AlignControls
        Else
            If CheckMouseOver(Picture3.Hwnd) = True And SDnBtn = False And SUpBtn = False And UpBtn = False And TmBtn = False Then
                Picture3.Height = GetDis(d_PictureOver.Height)
                Picture3.Width = GetDis(d_PictureOver.Width)
                Picture3.PaintPicture d_PictureOver, 0, 0
                AlignControls
                Tracking3.Enabled = True
            Else
                Picture3.Height = GetDis(d_PictureNormal.Height)
                Picture3.Width = GetDis(d_PictureNormal.Width)
                Picture3.PaintPicture d_PictureNormal, 0, 0
                AlignControls
            End If
        End If

    
    Dim TVar As Double
    If mOrient = 0 Then
        Picture2.Top = TrueVal
        TVar = Picture4.ScaleHeight - Picture2.Height
    Else
        Picture2.Left = TrueVal
        TVar = Picture4.ScaleWidth - Picture2.Width
    End If
    tHandle = m_Max - m_Min
    tHandle = TVar / tHandle
    m_Value = Int((TrueVal / tHandle) + 0.5) + m_Min
    
    Picture4.BackColor = m_tColor
    
    If mOrient = 0 Then
        Picture4.Line (0, 0)-(0, Picture4.ScaleHeight), vbButtonShadow
        Picture4.Line (Picture4.ScaleWidth - 1, 0)-(Picture4.ScaleWidth - 1, Picture4.ScaleHeight), vbButtonShadow
    Else
        Picture4.Line (0, 0)-(Picture4.ScaleWidth, 0), vbButtonShadow
        Picture4.Line (0, Picture4.ScaleHeight - 1)-(Picture4.ScaleWidth, Picture4.ScaleHeight - 1), vbButtonShadow
    End If
    
    If b_PictureNormal.handle <> 0 Then
    Dim avar As Integer
    Dim bvar As Integer
    Dim i As Integer
    Dim j As Integer
    avar = GetDis(b_PictureNormal.Height)
    bvar = GetDis(b_PictureNormal.Width)
    If avar = 0 Or bvar = 0 Then Exit Sub
        If Picture4.ScaleHeight > avar Then
            For i = 0 To Picture4.ScaleHeight Step avar
                If Picture4.ScaleWidth > bvar Then
                    For j = 0 To Picture4.ScaleWidth Step bvar
                        Picture4.PaintPicture b_PictureNormal, j, i
                    Next j
                Else
                    Picture4.PaintPicture b_PictureNormal, 0, i
                End If
            Next i
        ElseIf Picture4.ScaleWidth > bvar Then
            For i = 0 To Picture4.ScaleWidth Step bvar
                Picture4.PaintPicture b_PictureNormal, i, 0
            Next i
        Else
            Picture4.PaintPicture b_PictureNormal, 0, 0
        End If
    End If
End Sub

Private Sub Picture1_DblClick()
    Call Picture1_MouseDown(1, 0, 0, 0)
End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    UpBtn = True
    tmUp.Enabled = True
    DrawButton
End Sub

Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 0 Then
        UpBtn = False
        tmUp.Enabled = False
    End If
    DrawButton
End Sub

Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 Then
        If TrueVal - (sChange * tHandle) > 0 Then
            TrueVal = TrueVal - (sChange * tHandle)
            RaiseEvent Change
        Else
            TrueVal = 0
            RaiseEvent Change
        End If
    End If
    UpBtn = False
    tmUp.Enabled = False
    DrawButton
End Sub

Private Sub Picture3_DblClick()
    Call Picture3_MouseDown(1, 0, 0, 0)
End Sub

Private Sub Picture3_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    DnBtn = True
    tmDn.Enabled = True
    DrawButton
End Sub

Private Sub Picture3_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 0 Then
        DnBtn = False
        tmDn.Enabled = False
    End If
    DrawButton
End Sub

Private Sub Picture3_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 Then
    Dim BoundVar
    If mOrient = 0 Then
        BoundVar = Picture4.ScaleHeight - Picture2.Height
    Else
        BoundVar = Picture4.ScaleWidth - Picture2.Width
    End If
        If TrueVal + (sChange * tHandle) < BoundVar Then
            TrueVal = TrueVal + (sChange * tHandle)
            RaiseEvent Change
        Else
            TrueVal = BoundVar
            RaiseEvent Change
        End If
    End If
    DnBtn = False
    tmDn.Enabled = False
    DrawButton
End Sub

Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 Then
        If mOrient = 0 Then
            MX = y
        Else
            MX = x
        End If
        TmBtn = True
    End If
    DrawButton
End Sub

Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 And TmBtn = True Then
    Dim BoundVar As Integer
    Dim ArrVar As Integer
    If mOrient = 0 Then
        BoundVar = Picture4.ScaleHeight - Picture2.Height
        ArrVar = y
    Else
        BoundVar = Picture4.ScaleWidth - Picture2.Width
        ArrVar = x
    End If
        Dim CurTemp
        CurTemp = ArrVar - MX
        If CurTemp < 0 Then
            If (TrueVal + CurTemp) > 0 Then
                TrueVal = TrueVal + (CurTemp)
            Else
                TrueVal = 0
            End If
        ElseIf CurTemp > 0 Then
            If (TrueVal + CurTemp) < BoundVar Then
                TrueVal = TrueVal + (CurTemp)
            Else
                TrueVal = BoundVar
            End If
        End If
        RaiseEvent Scroll
    End If
    DrawButton
End Sub

Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    TmBtn = False
    DrawButton
End Sub

Private Sub Picture4_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If CheckMouseOver(Picture4.Hwnd) = True And Button = 1 Then
        Dim BoundVar As Integer
        Dim MinVar As Integer
        Dim ArrVar As Single
        If mOrient = 0 Then
            BoundVar = Picture2.Top + Picture2.Height
            MinVar = Picture2.Top
            ArrVar = y
        Else
            BoundVar = Picture2.Left + Picture2.Width
            MinVar = Picture2.Left
            ArrVar = x
        End If
        If ArrVar < MinVar Then
            SUpBtn = True
            tmUp2.Enabled = True
        ElseIf ArrVar > BoundVar Then
            SDnBtn = True
            tmDn2.Enabled = True
        End If
    End If
    DrawButton
End Sub

Private Sub Picture4_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    DrawButton
End Sub

Private Sub Picture4_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 And CheckMouseOver(Picture4.Hwnd) = True Then
        Dim BoundVar As Integer
        Dim MinVar As Integer
        Dim MaxVar As Integer
        Dim ArrVar As Single
        If mOrient = 0 Then
            BoundVar = Picture2.Top + Picture2.Height
            MinVar = Picture2.Top
            MaxVar = Picture4.ScaleHeight - Picture2.Height
            ArrVar = y
        Else
            BoundVar = Picture2.Left + Picture2.Width
            MinVar = Picture2.Left
            MaxVar = Picture4.ScaleWidth - Picture2.Width
            ArrVar = x
        End If
        If ArrVar < MinVar And SUpBtn = True Then
            If TrueVal - (lChange * tHandle) > 0 Then
                TrueVal = TrueVal - (lChange * tHandle)
                RaiseEvent Change
            Else
                TrueVal = 0
                RaiseEvent Change
            End If
        ElseIf ArrVar > BoundVar And SDnBtn = True Then
            If TrueVal + (lChange * tHandle) < MaxVar Then
               TrueVal = TrueVal + (lChange * tHandle)
                RaiseEvent Change
            Else
                TrueVal = MaxVar
                RaiseEvent Change
            End If
        End If
    End If
    SUpBtn = False
    SDnBtn = False
    tmDn2.Enabled = False
    tmUp2.Enabled = False
    DrawButton
End Sub

Private Sub tmDn_Timer()
    If DnBtn = False Then
        tmDn.Enabled = False
        Exit Sub
    End If
    If CheckMouseOver(Picture3.Hwnd) = True Then
        Dim BoundVar
        If mOrient = 0 Then
            BoundVar = Picture4.ScaleHeight - Picture2.Height
        Else
            BoundVar = Picture4.ScaleWidth - Picture2.Width
        End If
        If TrueVal + (sChange * tHandle) < BoundVar Then
            TrueVal = TrueVal + (sChange * tHandle)
        Else
            TrueVal = BoundVar
        End If
    End If
    DrawButton
End Sub

Private Sub tmDn2_Timer()
    If SDnBtn = False Then
        tmDn2.Enabled = False
        Exit Sub
    End If
    If CheckMouseOver(Picture4.Hwnd) = True Then
        Dim BoundVar
        If mOrient = 0 Then
            BoundVar = Picture4.ScaleHeight - Picture2.Height
        Else
            BoundVar = Picture4.ScaleWidth - Picture2.Width
        End If
        If TrueVal + (lChange * tHandle) < BoundVar Then
            TrueVal = TrueVal + (lChange * tHandle)
            RaiseEvent Change
        Else
            TrueVal = BoundVar
            RaiseEvent Change
        End If
    End If
    DrawButton
End Sub

Private Sub tmUp_Timer()
    If UpBtn = False Then
        tmUp.Enabled = False
        Exit Sub
    End If
    If CheckMouseOver(Picture1.Hwnd) = True Then
        If TrueVal - (sChange * tHandle) > 0 Then
            TrueVal = TrueVal - (sChange * tHandle)
            RaiseEvent Change
        Else
            TrueVal = 0
            RaiseEvent Change
        End If
    End If
    DrawButton
End Sub

Private Sub tmUp2_Timer()
    If SUpBtn = False Then
        tmUp2.Enabled = False
        Exit Sub
    End If
    If CheckMouseOver(Picture4.Hwnd) = True Then
        If TrueVal - (lChange * tHandle) > 0 Then
            TrueVal = TrueVal - (lChange * tHandle)
            RaiseEvent Change
        Else
            TrueVal = 0
            RaiseEvent Change
        End If
    End If
    DrawButton
End Sub

Private Sub Tracking1_Timer()
    If CheckMouseOver(Picture1.Hwnd) = False Then
        DrawButton
        Tracking1.Enabled = False
    End If
End Sub

Private Sub Tracking2_Timer()
    If CheckMouseOver(Picture2.Hwnd) = False Then
        DrawButton
        Tracking2.Enabled = False
    End If
End Sub

Private Sub Tracking3_Timer()
    If CheckMouseOver(Picture3.Hwnd) = False Then
        DrawButton
        Tracking3.Enabled = False
    End If
End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)
    DrawButton
End Sub

Private Sub UserControl_Initialize()
    Picture1.BorderStyle = 0
    Picture2.BorderStyle = 0
    Picture3.BorderStyle = 0
    Picture4.BorderStyle = 0
    DrawButton
End Sub

Private Sub UserControl_InitProperties()
    SetPos Picture2, 0, 0
    m_tColor = vb3DHighlight
    sChange = 1
    lChange = 10
    m_Min = 0
    m_Max = 100
    m_Value = 0
    SOver = Raised
    SNorm = Raised
    SDown = Sunken
    UpPic = False
    DnPic = False
    TbPic = False
    Set u_PictureNormal = Nothing
    Set u_PictureOver = Nothing
    Set u_PictureDown = Nothing
    Set d_PictureNormal = Nothing
    Set d_PictureOver = Nothing
    Set d_PictureDown = Nothing
    Set t_PictureNormal = Nothing
    Set t_PictureOver = Nothing
    Set t_PictureDown = Nothing
    Set b_PictureNormal = Nothing
    mOrient = 0
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    With PropBag
        SOver = .ReadProperty("StateOver", Raised)
        SNorm = .ReadProperty("StateNormal", Raised)
        SDown = .ReadProperty("StateDown", Sunken)
        m_Min = .ReadProperty("Min", 0)
        m_Max = .ReadProperty("Max", 100)
        m_Value = .ReadProperty("Value", 0)
        m_tColor = .ReadProperty("TrackColor", vb3DHighlight)
        sChange = .ReadProperty("SmallChange", 1)
        lChange = .ReadProperty("LargeChange", 10)
        UpPic = .ReadProperty("UsePictureUp", False)
        DnPic = .ReadProperty("UsePictureDown", False)
        TbPic = .ReadProperty("UsePictureThumb", False)
        Set u_PictureNormal = .ReadProperty("UpButtonNormal", Nothing)
        Set u_PictureOver = .ReadProperty("UpButtonHover", Nothing)
        Set u_PictureDown = .ReadProperty("UpButtonDown", Nothing)
        Set d_PictureNormal = .ReadProperty("DownButtonNormal", Nothing)
        Set d_PictureOver = .ReadProperty("DownButtonHover", Nothing)
        Set d_PictureDown = .ReadProperty("DownButtonDown", Nothing)
        Set t_PictureNormal = .ReadProperty("ThumbButtonNormal", Nothing)
        Set t_PictureOver = .ReadProperty("ThumbButtonHover", Nothing)
        Set t_PictureDown = .ReadProperty("ThumbButtonDown", Nothing)
        Set b_PictureNormal = .ReadProperty("BackgroundPicture", Nothing)
        mOrient = .ReadProperty("Orientation", 0)
    End With
    DrawButton
End Sub

Private Sub UserControl_Resize()
    DrawButton
    If mOrient = 0 Then
        If UserControl.ScaleHeight < Picture1.Height + Picture3.Height + Picture2.Height + 10 Then
            UserControl.Height = ScaleY(Picture1.Height + Picture3.Height + Picture2.Height + 10, vbPixels, vbTwips)
            DrawButton
        End If
    Else
        If UserControl.ScaleWidth < Picture1.Width + Picture3.Width + Picture2.Width + 10 Then
            UserControl.Width = ScaleX(Picture1.Width + Picture3.Width + Picture2.Width + 10, vbPixels, vbTwips)
            DrawButton
        End If
    End If
End Sub

Private Sub UserControl_Show()
    DrawButton
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    With PropBag
        Call .WriteProperty("StateOver", SOver, Raised)
        Call .WriteProperty("StateNormal", SNorm, Raised)
        Call .WriteProperty("StateDown", SDown, Sunken)
        Call .WriteProperty("Min", m_Min, 0)
        Call .WriteProperty("Max", m_Max, 32767)
        Call .WriteProperty("Value", m_Value, 0)
        Call .WriteProperty("TrackColor", m_tColor, vbWhite)
        Call .WriteProperty("SmallChange", sChange, 1)
        Call .WriteProperty("LargeChange", lChange, 10)
        Call .WriteProperty("UsePictureUp", UpPic, False)
        Call .WriteProperty("UsePictureDown", DnPic, False)
        Call .WriteProperty("UsePictureThumb", TbPic, False)
        Call .WriteProperty("UpButtonNormal", u_PictureNormal, Nothing)
        Call .WriteProperty("UpButtonHover", u_PictureOver, Nothing)
        Call .WriteProperty("UpButtonDown", u_PictureDown, Nothing)
        Call .WriteProperty("DownButtonNormal", d_PictureNormal, Nothing)
        Call .WriteProperty("DownButtonHover", d_PictureOver, Nothing)
        Call .WriteProperty("DownButtonDown", d_PictureDown, Nothing)
        Call .WriteProperty("ThumbButtonNormal", t_PictureNormal, Nothing)
        Call .WriteProperty("ThumbButtonHover", t_PictureOver, Nothing)
        Call .WriteProperty("ThumbButtonDown", t_PictureDown, Nothing)
        Call .WriteProperty("BackgroundPicture", b_PictureNormal, Nothing)
        Call .WriteProperty("Orientation", mOrient, 0)
    End With
    DrawButton
End Sub

Private Function CheckMouseOver(ctlHwnd As Long) As Boolean
    Dim pt As PointAPI
    GetCursorPos pt
    CheckMouseOver = (WindowFromPoint(pt.x, pt.y) = ctlHwnd)
End Function

Private Function GetDis(mDis As Long) As Integer
    GetDis = Int((mDis / (291 / 11)) + 0.5)
End Function

