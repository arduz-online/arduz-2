Attribute VB_Name = "Alpha"
Option Explicit
Rem WRITER: MENDUZ menduz@noicoder.com
Rem DATE:   30112008
Public Declare Function vbDABLalphablend16 Lib "vbDABL" (ByVal iMode As Integer, ByVal bColorKey As Integer, _
ByRef sPtr As Any, ByRef dPtr As Any, ByVal iAlphaVal As Integer, ByVal iWidth As Integer, ByVal iHeight As Integer, _
ByVal isPitch As Integer, ByVal idPitch As Integer, ByVal iColorKey As Integer) As Integer
Public Declare Function vbDABLcolorblend16555 Lib "vbDABL" (ByRef sPtr As Any, ByRef dPtr As Any, ByVal alpha_val%, _
ByVal Width%, ByVal Height%, ByVal sPitch%, ByVal dPitch%, ByVal rVal%, ByVal gVal%, ByVal bVal%) As Long
Public Declare Function vbDABLcolorblend16565 Lib "vbDABL" (ByRef sPtr As Any, ByRef dPtr As Any, ByVal alpha_val%, _
ByVal Width%, ByVal Height%, ByVal sPitch%, ByVal dPitch%, ByVal rVal%, ByVal gVal%, ByVal bVal%) As Long
Public Declare Function vbDABLcolorblend16555ck Lib "vbDABL" (ByRef sPtr As Any, ByRef dPtr As Any, ByVal alpha_val%, _
ByVal Width%, ByVal Height%, ByVal sPitch%, ByVal dPitch%, ByVal rVal%, ByVal gVal%, ByVal bVal%) As Long
Public Declare Function vbDABLcolorblend16565ck Lib "vbDABL" (ByRef sPtr As Any, ByRef dPtr As Any, ByVal alpha_val%, _
ByVal Width%, ByVal Height%, ByVal sPitch%, ByVal dPitch%, ByVal rVal%, ByVal gVal%, ByVal bVal%) As Long
