Option Explicit
Public Type PALETTEENTRY
    peRed As Byte
    peGreen As Byte
    peBlue As Byte
    peFlags As Byte
End Type
Public Type LOGPALETTE
    palVersion As Integer
    palNumEntries As Integer
    palPalEntry(0 To 255) As PALETTEENTRY
End Type
Public Type PIXELFORMATDESCRIPTOR
    nSize As Integer
    nVersion As Integer
    dwFlags As Long
    iPixelType As Byte
    cColorBits As Byte
    cRedBits As Byte
    cRedShift As Byte
    cGreenBits As Byte
    cGreenShift As Byte
    cBlueBits As Byte
    cBlueShift As Byte
    cAlphaBits As Byte
    cAlphaShift As Byte
    cAccumBits As Byte
    cAccumRedBits As Byte
    cAccumGreenBits As Byte
    cAccumBlueBits As Byte
    cAccumAlpgaBits As Byte
    cDepthBits As Byte
    cStencilBits As Byte
    cAuxBuffers As Byte
    iLayerType As Byte
    bReserved As Byte
    dwLayerMask As Long
    dwVisibleMask As Long
    dwDamageMask As Long
End Type

Public Const PFD_TYPE_RGBA = 0
Public Const PFD_TYPE_COLORINDEX = 1
Public Const PFD_MAIN_PLANE = 0
Public Const PFD_DOUBLEBUFFER = 1
Public Const PFD_DRAW_TO_WINDOW = &H4
Public Const PFD_SUPPORT_OPENGL = &H20
Public Const PFD_NEED_PALETTE = &H80

Public Declare Function ChoosePixelFormat Lib "OpenGL" (ByVal hDC As Long, pfd As PIXELFORMATDESCRIPTOR) As Long
Public Declare Function CreatePalette Lib "gdi32" (pPal As LOGPALETTE) As Long
Public Declare Sub DeleteObject Lib "gdi32" (hObject As Long)
Public Declare Sub DescribePixelFormat Lib "OpenGL" (ByVal hDC As Long, ByVal PixelFormat As Long, ByVal nBytes As Long, pfd As PIXELFORMATDESCRIPTOR)
Public Declare Function GetDC Lib "gdi32" (ByVal hWnd As Long) As Long
Public Declare Function GetPixelFormat Lib "OpenGL" (ByVal hDC As Long) As Long
Public Declare Sub GetSystemPaletteEntries Lib "gdi32" (ByVal hDC As Long, ByVal start As Long, ByVal entries As Long, ByVal ptrEntries As Long)
Public Declare Sub RealizePalette Lib "gdi32" (ByVal hPalette As Long)
Public Declare Sub SelectPalette Lib "gdi32" (ByVal hDC As Long, ByVal hPalette As Long, ByVal bln As Long)
Public Declare Function SetPixelFormat Lib "OpenGL" (ByVal hDC As Long, ByVal I As Long, pfd As PIXELFORMATDESCRIPTOR) As Boolean
Public Declare Sub SwapBuffers Lib "OpenGL" (ByVal hDC As Long)
' specialni Windows prikazi OGL akvivalenti incializaci u X-windows
Public Declare Function wglCreateContext Lib "OpenGL" (ByVal hDC As Long) As Long
Public Declare Sub wglDeleteContext Lib "OpenGL" (ByVal hContext As Long)
Public Declare Sub wglMakeCurrent Lib "OpenGL" (ByVal l1 As Long, ByVal l2 As Long)

'konec WIN 32 API deklarace
