Attribute VB_Name = "Engine"
'                  ____________________________________________
'                 /_____/  http://www.arduz.com.ar/ao/   \_____\
'                //            ____   ____   _    _ _____      \\
'               //       /\   |  __ \|  __ \| |  | |___  /      \\
'              //       /  \  | |__) | |  | | |  | |  / /        \\
'             //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
'            //       / ____ \| | \ \| |__| | |__| |/ /__          \\
'           / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
'           \________________________________________________________/
'           MOTOR GRÁFICO ESCRITO POR MENDUZ@NOICODER.COM

Option Explicit

Public bRunning             As Boolean

Public dX                   As DirectX8
Public D3D                  As Direct3D8
Public D3DDevice            As Direct3DDevice8
Public D3DX                 As D3DX8
Public D3DWindow            As D3DPRESENT_PARAMETERS

Public FPS                  As Integer
Public puedo_deslimitar     As Boolean

Public timerElapsedTime     As Double
Public timerElapsedTime1    As Single
Public timerTicksPerFrame   As Double
Public particletimer        As Single
Public engineBaseSpeed      As Single

Public lColorMod            As Long
Public permite_lights2      As Boolean

Public Const Pi             As Single = 3.14159265358979
Public Const Pi2            As Single = 6.28318530717959
Public Const DegreeToRadian As Single = 0.01745329251994 'Pi / 180
Public Const RadianToDegree As Single = 57.2957795130823 '180 / Pi

Public Epsilon              As Single '= 0.0000001192093


Public Const TL_size        As Long = 28
Public Const BV_size        As Long = 112
Public Const Part_size      As Long = 32

Public Const particleFVF    As Long = (D3DFVF_XYZRHW Or D3DFVF_TEX1 Or D3DFVF_PSIZE Or D3DFVF_DIFFUSE)
Public Const FVF            As Long = (D3DFVF_XYZRHW Or D3DFVF_TEX1 Or D3DFVF_DIFFUSE)

Private font_list()         As D3DXFont

Public Type RGBCOLOR
    r As Byte
    G As Byte
    b As Byte
End Type

Public Type BGRCOLOR_DLL
    b As Byte
    G As Byte
    r As Byte
End Type

Public Type TLVERTEX    'NO TOCAR POR NADA EN EL MUNDO
    v As D3DVECTOR
    rhw As Single       'NO TOCAR POR NADA EN EL MUNDO
    'normal As D3DVECTOR
    color As Long       'NO TOCAR POR NADA EN EL MUNDO
    tu As Single        'NO TOCAR POR NADA EN EL MUNDO
    tv As Single        'NO TOCAR POR NADA EN EL MUNDO
End Type                'NO TOCAR POR NADA EN EL MUNDO

Public Type Box_Vertex
    x0 As Single
    y0 As Single
    Z0 As Single
    rhw0 As Single
    color0 As Long
    tu0 As Single
    tv0 As Single
    
    x1 As Single
    y1 As Single
    Z1 As Single
    rhw1 As Single
    color1 As Long
    tu1 As Single
    tv1 As Single
    
    x2 As Single
    y2 As Single
    Z2 As Single
    rhw2 As Single
    color2 As Long
    tu2 As Single
    tv2 As Single
    
    x3 As Single
    y3 As Single
    Z3 As Single
    rhw3 As Single
    color3 As Long
    tu3 As Single
    tv3 As Single
End Type

Public Type FTLVERTEX
    v As D3DVECTOR
    rhw As Single
        a As Byte
        r As Byte
        G As Byte
        b As Byte
    tu As Single
    tv As Single
End Type

Public Enum FontAlignment
    fa_center = DT_CENTER
    fa_top = DT_TOP
    fa_left = DT_LEFT
    fa_topleft = DT_TOP Or DT_LEFT
    fa_bottomleft = DT_BOTTOM Or DT_LEFT
    fa_bottom = DT_BOTTOM
    fa_right = DT_RIGHT
    fa_bottomright = DT_BOTTOM Or DT_RIGHT
    fa_topright = DT_TOP Or DT_RIGHT
End Enum

Public Type TLVERTEX2
    x As Single
    y As Single
    z As Single
    rhw As Single
    color As Long
    Specular As Long
    tu1 As Single
    tv1 As Single
    tu2 As Single
    tv2 As Single
End Type

Public tmpTLlist() As TLVERTEX

Public VertList(3) As TLVERTEX

Private texture As Direct3DTexture8

Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long



Private font_count As Long
Private font_last As Long


Private FramesPerSecCounter As Integer
Private lFrameTimer As Long

Public MainViewWidth As Integer
Public MainViewHeight As Integer

Public WindowTileWidth As Integer
Public WindowTileHeight As Integer

Public HalfWindowTileWidth As Integer
Public HalfWindowTileHeight As Integer
Public Const GrhFogata As Integer = 1521

Public MouseTileX As Byte
Public MouseTileY As Byte

Public blur_factor As Byte

Private limit_fps As Boolean
Private min_ms_between_render As Byte


Private InvRect As RECT

Public show_debug As Boolean



Public last_texture As Integer



'#########################################################################################################

'#########################################################################################################


Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal Length As Long)

Public user_moved As Boolean

Public hay_fogata_viewport As Boolean
Public fogata_pos As Position

Public Type sRECT
    Left As Single
    Right As Single
    Top As Single
    Bottom As Single
End Type

Public offset_screen As D3DVECTOR
Public offset_screen_old As D3DVECTOR
Public offset_map As D3DVECTOR2
Public offset_mapO As D3DVECTOR2
Public act_light_map As Boolean

Public BlurTexture As Direct3DTexture8
Public BlurSurf As Direct3DSurface8
Public BlurStencil As Direct3DSurface8
Public DeviceStencil As Direct3DSurface8
Public DeviceBuffer As Direct3DSurface8

Public ZooMlevel!, Use_Blend As Boolean


Private Type CharVA
    vertex(0 To 3) As TLVERTEX
End Type

Private Type VFH
    BitmapWidth As Long         'Size of the bitmap itself
    BitmapHeight As Long
    CellWidth As Long           'Size of the cells (area for each character)
    CellHeight As Long
    BaseCharOffset As Byte      'The character we start from
    CharWidth(0 To 255) As Byte 'The actual factual width of each character
    CharVA(0 To 255) As CharVA
End Type

Private Type CustomFont
    HeaderInfo As VFH           'Holds the header information
    texture As Direct3DTexture8 'Holds the texture of the text
    RowPitch As Integer         'Number of characters per row
    RowFactor As Single         'Percentage of the texture width each character takes
    ColFactor As Single         'Percentage of the texture height each character takes
    CharHeight As Byte          'Height to use for the text - easiest to start with CellHeight value, and keep lowering until you get a good value
End Type

Public Const Font_Default_TextureNum As Long = -1   'The texture number used to represent this font - only used for AlternateRendering - keep negative to prevent interfering with game textures
Public Font_Default As CustomFont   'Describes our custom font "default"

Public new_text As Boolean

Private time_wait As Single



Public Type CAPABILITIES
    Filter_Bilinear As Boolean
    Filter_Trilinear As Boolean
    Filter_Anisotropic As Boolean
    Filter_GaussianCubic As Boolean
    Filetr_FlatCubic As Boolean

    CanDo_MultiTexture As Boolean
    CanDo_CubeMapping As Boolean
    CanDo_Dot3 As Boolean
    CanDo_VolumeTexture As Boolean
    CanDo_ProjectedTexture As Boolean
    CanDo_TextureMipMapping As Boolean
    CanDo_PureDevice As Boolean
    CanDo_PointSprite As Boolean

    Cando_RenderSurface As Boolean
    CandDo_3StagesTextureBlending As Boolean

    Cando_PixelShader As Boolean
    Cando_VertexShader As Boolean

    CanDoTableFog        As Boolean
    CanDoVertexFog       As Boolean
    CanDoWFog            As Boolean

    TandL_Device As Boolean
    CanDo_BumpMapping As Boolean

    Wbuffer_OK As Boolean
    Max_ActiveLights As Long
    Max_TextureStages As Long
    Max_AnisotropY As Long

    Pixel_ShaderVERSIOn As String

    Vertex_ShaderVERSION As String
    
    pxs_min As Long
    pxs_max As Long
End Type

Public act_caps As CAPABILITIES

Private tVerts(3) As TLVERTEX
Private tBox As Box_Vertex
Public copy_tile_now As Byte

Public WeatherFogX1 As Single       'Fog 1 position
Public WeatherFogY1 As Single       'Fog 1 position
Public WeatherFogX2 As Single       'Fog 2 position
Public WeatherFogY2 As Single       'Fog 2 position
Public WeatherDoFog As Byte         'Are we using fog? >1 = Yes, 0 = No
Public WeatherFogCount As Byte      'How many fog effects there are
Public Weatherfogalpha As Byte
Public Weatherfogalphau As Byte

Public Sandstorm_X1 As Single       'Fog 1 position
Public Sandstorm_Y1 As Single       'Fog 1 position
Public Sandstorm_X2 As Single       'Fog 2 position
Public Sandstorm_Y2 As Single       'Fog 2 position
Public Sandstorm_do As Byte         'Are we using fog? >1 = Yes, 0 = No
Public Sandstorm_Count As Byte      'How many fog effects there are

Public Lightbeam_a1 As Byte       'Fog 1 position
Public Lightbeam_a2 As Byte       'Fog 1 position
Public Lightbeam_a3 As Byte       'Fog 2 position
Public Lightbeam_Y2 As Single       'Fog 2 position
Public Lightbeam_do As Byte         'Are we using fog? >1 = Yes, 0 = No
Public Lightbeam_Count As Byte      'How many fog effects there are

Public Render_Radio_Luz As Byte      'How many fog effects there are

Public actual_blend_mode As Long

Public Enum render_set_states
    rsADD = 1
    rsONE = 2
End Enum

Public RENDERCRC As Long

Public renderfps As Byte

Private FPS_LIMITER As clsPerformanceTimer
Private FRAME_TIMER As clsPerformanceTimer

Public Declare Function timeGetTime Lib "winmm.dll" () As Long
Private Declare Function timeBeginPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long
Private Declare Function timeEndPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long

Public re_render_inventario As Boolean

Public Sub Set_Blend_Mode(Optional ByVal blend_mode As Long)
    If ((actual_blend_mode And render_set_states.rsONE) <> (blend_mode And render_set_states.rsONE)) Then
        If (blend_mode And render_set_states.rsONE) Then
            Call D3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE)
        Else
            Call D3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA)
        End If
    End If
    If ((actual_blend_mode And render_set_states.rsADD) <> (blend_mode And render_set_states.rsADD)) Then
        If (blend_mode And render_set_states.rsADD) Then
            Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_ADD)
        Else
            Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
        End If
    End If
    actual_blend_mode = blend_mode
End Sub

Public Function Get_Blend_Mode() As Long
    Get_Blend_Mode = actual_blend_mode
End Function

Function GetVarSng(ByVal FILE As String, ByVal Main As String, ByVal var As String) As Single
    GetVarSng = CCVal(GetVar(FILE, Main, var))
End Function

Public Sub Text_Render(ByVal font As Integer, ByRef Text As String, ByVal Top!, ByVal Left!, _
                                ByVal Width As Long, ByVal height As Long, ByVal color As Long, ByVal format As Long, Optional ByVal shadow As Boolean = False)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    If Not new_text Then
        Dim TextRect As RECT
        Dim ShadowRect As RECT
        
    
        
        
        TextRect.Top = Top
        TextRect.Left = Left
        TextRect.Bottom = Top + height
        TextRect.Right = Left + Width
    '    If TextRect.left < 0 Then
    '        TextRect.left = 0
    '        TextRect.Right = Width
    '        format = DT_LEFT
    '    ElseIf TextRect.left > 544 Then
    '        TextRect.left = 544 - Width
    '        TextRect.Right = 544
    '        format = DT_RIGHT
    '    End If
        D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, False
        If shadow Then
            ShadowRect.Top = Top + 1
            ShadowRect.Left = Left + 1
            ShadowRect.Bottom = Top + height + 1
            ShadowRect.Right = Left + Width + 1
            D3DX.DrawText font_list(font), &HFF000000, Text, ShadowRect, format
        End If
        
        D3DX.DrawText font_list(font), color, Text, TextRect, format
        D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, True
    Else
        If format And DT_CENTER Then
            Left = Left - Engine.Engine_GetTextWidth(Text) / 2
        End If
        text_render_graphic Text, Left, Top, color
    End If
End Sub

Public Sub Text_Render_alpha(ByRef Text As String, ByVal Top!, ByVal Left!, ByVal color As Long, ByVal format As Long, Optional ByVal alpha As Byte = 128)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
Dim color_s&
'    If Not new_text Then
'        Dim TextRect As RECT
'        Dim ShadowRect As RECT
'
'
'        If alpha = 0 Then Exit Sub
'
'        TextRect.Top = Top
'        TextRect.Left = Left
'        TextRect.Bottom = Top + height
'        TextRect.Right = Left + Width
'
'        ShadowRect.Top = Top + 1
'        ShadowRect.Left = Left + 1
'        ShadowRect.Bottom = Top + height + 1
'        ShadowRect.Right = Left + Width + 1
'
'        color_s = CLng("&H" & Hex$(alpha) & "000000")
'        D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, False
'        D3DX.DrawText font_list(font), color_s, Text, ShadowRect, format
'        color_s =
'        D3DX.DrawText font_list(font), color_s, Text, TextRect, format
'        D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, True
'    Else
        'color_s = CLng("&H" & Hex$(alpha) & "000000")
        color_s = (color And &HFFFFFF) Or Alphas(alpha) 'color - (&HFF000000 - color_s)
        If format Then
            Left = Left - Engine.Engine_GetTextWidth(Text) / 2
        End If

        text_render_graphic Text, Left, Top, color_s
'    End If
End Sub

Public Sub Text_Render_ext(ByRef Text As String, ByVal Top As Long, ByVal Left As Long, _
                                ByVal Width As Long, ByVal height As Long, ByVal color As Long, Optional ByVal alpha As Boolean, Optional ByVal center As Boolean)
Dim Alphas As Byte
Alphas = 255
If alpha = True Then _
    Alphas = 128
    
    If center = True Then
        Call Text_Render_alpha(Text, Top, Left, color, 1, Alphas)
    Else
        Call Text_Render_alpha(Text, Top, Left, color, 0, Alphas)
    End If
End Sub

Private Sub Font_Make(ByVal font_index As Long, ByVal style As String, ByVal bold As Boolean, _
                        ByVal italic As Boolean, ByVal size As Long)
    If font_index > font_last Then
        font_last = font_index
        ReDim Preserve font_list(1 To font_last)
    End If
    font_count = font_count + 1
    
    Dim font_desc As IFont
    Dim fnt As New StdFont
    fnt.name = style
    fnt.size = size
    fnt.bold = bold
    fnt.italic = italic
    
    Set font_desc = fnt
    Set font_list(font_index) = D3DX.CreateFont(D3DDevice, font_desc.hFont)
End Sub


Public Function Font_Create(ByVal style As String, ByVal size As Long, ByVal bold As Boolean, _
                            ByVal italic As Boolean) As Long
On Error GoTo ErrorHandler:
    Font_Create = Font_Next_Open
    Font_Make Font_Create, style, bold, italic, size
ErrorHandler:
    Font_Create = 0
End Function

Private Function Font_Next_Open() As Long
    Font_Next_Open = font_last + 1
End Function

Function MakeVector(ByVal x As Single, ByVal y As Single, ByVal z As Single) As D3DVECTOR
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
  MakeVector.x = x
  MakeVector.y = y
  MakeVector.z = z
End Function

Private Sub Device_Reset()
On Error GoTo ErrHandler
    D3DDevice.reset D3DWindow
    With D3DDevice
        Call .SetVertexShader(FVF)
        Call .SetRenderState(D3DRS_LIGHTING, 0)
        Call .SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA)
        Call .SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA)
        Call .SetRenderState(D3DRS_ALPHABLENDENABLE, 1)
        Call .SetRenderState(D3DRS_POINTSIZE, Engine_FToDW(32))
        Call .SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE)
        Call .SetRenderState(D3DRS_POINTSPRITE_ENABLE, 1)
        Call .SetRenderState(D3DRS_POINTSCALE_ENABLE, 0)
    End With
Exit Sub
ErrHandler:
End Sub

Public Sub Long_Color_Set_Alpha(ByRef color As Long, ByVal alpha As Byte)
    Dim barr(3) As Byte
    DXCopyMemory barr(0), color, 4
    barr(0) = alpha
    DXCopyMemory color, barr(0), 4
End Sub


Public Sub Engine_set_max_fps(ByVal Limit As Boolean, Optional ByVal max_fps As Integer = 100)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
On Error GoTo errh
    limit_fps = True 'Limit
    min_ms_between_render = CByte(1000 / max_fps)
Exit Sub
errh:
Debug.Print "No se limitaron las FPS, por error en ""Engine.engine_set_max_fps"" -> " & Err.Description
limit_fps = False
End Sub

Public Sub Engine_Toggle_fps_limit(Optional ByVal bool As Integer = -3)
If puedo_deslimitar Then
    If bool = -3 Then
        limit_fps = Not limit_fps
    Else
        limit_fps = CBool(bool)
    End If
Else
    limit_fps = True
End If
End Sub

Private Function Engine_Init_D3DDevice(D3DCREATEFLAGS As CONST_D3DCREATEFLAGS, adapter As CONST_D3DDEVTYPE) As Boolean
10      cfnc = fnc.E_Engine_Init_D3DDevice
          Dim DispMode As D3DDISPLAYMODE
20        On Error GoTo ErrOut

30        D3D.GetAdapterDisplayMode D3DADAPTER_DEFAULT, DispMode
          
          'If PDepth = 32 Then
          '    DispMode.format = D3DFMT_X8R8G8B8
          'ElseIf PDepth = 16 Then
          '    DispMode.format = D3DFMT_R5G6B5
          'End If
          
40        With D3DWindow
50            .Windowed = 1
60            .SwapEffect = D3DSWAPEFFECT_COPY 'D3DSWAPEFFECT_DISCARD
70            .BackBufferFormat = DispMode.format
80            .hDeviceWindow = frmMain.renderer.Hwnd
90            .BackBufferWidth = frmMain.renderer.ScaleWidth
100           .BackBufferHeight = frmMain.renderer.ScaleHeight
110       End With
120       If Not D3DDevice Is Nothing Then Set D3DDevice = Nothing
130       Set D3DDevice = D3D.CreateDevice(D3DADAPTER_DEFAULT, adapter, frmMain.renderer.Hwnd, D3DCREATEFLAGS, D3DWindow)

140       Engine_Init_D3DDevice = True

150       Log "Device iniciado: " & D3DCREATEFLAGS & " - " & Err.Number

          Dim jo As D3DCAPS8
160       Call D3D.GetDeviceCaps(D3DADAPTER_DEFAULT, adapter, jo)
170       lColorMod = D3DTOP_MODULATE


280           permite_lights2 = False
          
300       DoEvents
          
310       cfnc = fnc.E_Engine_Init
320   Exit Function

ErrOut:
330       Set D3DDevice = Nothing
340       Engine_Init_D3DDevice = False
exerl = 9000 + Erl()
End Function


Public Sub Engine_Init(Optional ByVal max_fps As Integer = 100)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
cfnc = fnc.E_Engine_Init

On Error GoTo ErrHandler:
    
    Dim Flags As Long
    Dim ValidFormat As Boolean
    
    Dim ColorKeyVal As Long
    
    Set dX = New DirectX8
    Set D3D = dX.Direct3DCreate()
    Set D3DX = New D3DX8
    
    Dim Caps8 As D3DCAPS8
    Dim DevType As CONST_D3DDEVTYPE
    
    DevType = D3DDEVTYPE_HAL
    
    On Local Error Resume Next
    
    Call D3D.GetDeviceCaps(D3DADAPTER_DEFAULT, DevType, Caps8)
    
    If Err.Number Then
        LogError "Error A01.1: " & vbNewLine & " El juego no ha encontrado un dispositivo acelerador compatible con Direct3D 8.1 - se utilizará un dispositivo de referencia. Probablemente habrá problemas"
        If MsgBox("Error A01.1: " & vbNewLine & " El juego no ha encontrado un dispositivo acelerador compatible con Direct3D 8.1 - se utilizará un dispositivo de referencia. Probablemente habrá problemas, ¿desea continuar?", vbExclamation + vbYesNo, "Inicialización Direct3D") = vbYes Then
            DevType = D3DDEVTYPE_REF
            Call D3D.GetDeviceCaps(D3DADAPTER_DEFAULT, DevType, Caps8)
            Err.Clear
        Else
            GoTo ErrHandler
        End If
    End If
    
    On Local Error GoTo ErrHandler:
    
    'lColorMod = D3DTOP_MODULATE Or D3DTOP_MODULATE2X
    If Not Engine_Init_D3DDevice(D3DCREATE_PUREDEVICE, DevType) Then
        'lColorMod = D3DTOP_MODULATE Or D3DTOP_MODULATE2X
        If Not Engine_Init_D3DDevice(D3DCREATE_HARDWARE_VERTEXPROCESSING, DevType) Then
            'lColorMod = D3DTOP_MODULATE Or D3DTOP_MODULATE2X
            If Not Engine_Init_D3DDevice(D3DCREATE_MIXED_VERTEXPROCESSING, DevType) Then
                'lColorMod = D3DTOP_MODULATE
                If Not Engine_Init_D3DDevice(D3DCREATE_SOFTWARE_VERTEXPROCESSING, DevType) Then
                
                    MsgBox "Error ""A01.2"" No se puede iniciar el dispositivo gráfico"
                    LogError "Error ""A01.2"" No se puede iniciar el dispositivo gráfico"
                    End
                End If
            End If
        End If
    End If
    
    Get_Capabilities
    Init_Math_Const
    
    
    TilePixelWidth = 32
    TilePixelHeight = 32
                                                            
    HalfWindowTileHeight = (frmMain.renderer.ScaleHeight / TilePixelWidth) \ 2
    HalfWindowTileWidth = (frmMain.renderer.ScaleWidth / TilePixelWidth) \ 2
    WindowTileHeight = (frmMain.renderer.ScaleHeight / TilePixelWidth)
    WindowTileWidth = (frmMain.renderer.ScaleWidth / TilePixelWidth)
    
    MainViewHeight = frmMain.renderer.ScaleHeight
    MainViewWidth = frmMain.renderer.ScaleWidth
    
    D3DDevice.SetVertexShader FVF
    
    D3DDevice.SetRenderState D3DRS_LIGHTING, False
    
    
    D3DDevice.SetRenderState D3DRS_SRCBLEND, D3DBLEND_SRCALPHA
    D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
    D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, 1
    D3DDevice.SetRenderState D3DRS_POINTSIZE, Engine_FToDW(32)
    
    D3DDevice.SetRenderState D3DRS_POINTSPRITE_ENABLE, 1
    D3DDevice.SetRenderState D3DRS_POINTSCALE_ENABLE, 0
    D3DDevice.SetTextureStageState 0, D3DTSS_ALPHAOP, D3DTOP_MODULATE 'ACAKB
    
    Engine_Set_TileBuffer_Size 5, 5
    
    '//Call SurfaceDB.Init(D3DX, D3DDevice, General_Get_Free_Ram_Bytes() / 2, 500)
    Init_TextureDB 128& * 1024& * 1024&, 500, app.Path & "\Datos\Graficos.aPAK"
    engineBaseSpeed = 0.018
    
    ReDim MapData(XMinMapSize To MapSize, YMinMapSize To MapSize) As MapBlock
    
    'Set FPS value to 60 for startup
    FPS = 65
    FramesPerSecCounter = 65
    
    ScrollPixelsPerFrameX = 8
    ScrollPixelsPerFrameY = 8
    
    UserPos.x = 50
    UserPos.y = 50
    
    MinXBorder = XMinMapSize + (frmMain.renderer.ScaleWidth / 64) + 4
    MaxXBorder = MapSize - (frmMain.renderer.ScaleWidth / 64) - 3
    MinYBorder = YMinMapSize + (frmMain.renderer.ScaleHeight / 64) + 5
    MaxYBorder = MapSize - (frmMain.renderer.ScaleHeight / 64) - 4
    
    'PS_Glow = shCompileT(Glowsrc)
    
    InvRect.Left = 0
    InvRect.Top = 0
    InvRect.Bottom = 200
    InvRect.Right = 199
    
    tVerts(0).v.z = 0!
    tVerts(0).rhw = 1!
    tVerts(1).v.z = 0!
    tVerts(1).rhw = 1!
    tVerts(2).v.z = 0!
    tVerts(2).rhw = 1!
    tVerts(3).v.z = 0!
    tVerts(3).rhw = 1!
    
    user_screen_pos.x = 256
    user_screen_pos.y = 192
    
    With tBox
        .Z0 = 0!
        .Z1 = 0!
        .Z2 = 0!
        .Z3 = 0!
        .rhw0 = 1!
        .rhw1 = 1!
        .rhw2 = 1!
        .rhw3 = 1!
    End With
    
    
    
    Engine_Init_FontSettings
    
    Engine_set_max_fps True, max_fps
    
    Font_Create "Tahoma", 8, True, 0

    If Audio.Initialize_Engine(frmMain.Hwnd, app.Path & "\Datos\wav\", app.Path & "\Datos\", app.Path & "\Datos\", False) = False Then
        MsgBox "Error: A01.3 [ " & Err.Number & " ] - " & D3DX.GetErrorString(Err.Number) & vbNewLine & " ¡No se ha logrado iniciar el engine de DirectSound! Reinstale los últimos controladores de DirectX desde www.arduz.com.ar", vbCritical, "Saliendo"
        LogError "Error: A01.3 [ " & Err.Number & " ] - " & D3DX.GetErrorString(Err.Number) & vbNewLine & " ¡No se ha logrado iniciar el engine de DirectSound! Reinstale los últimos controladores de DirectX desde www.arduz.com.ar"
    End If

    timeBeginPeriod 1

Set FPS_LIMITER = New clsPerformanceTimer
Set FRAME_TIMER = New clsPerformanceTimer


    D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, 0, 0, 0
    D3DDevice.BeginScene
    D3DDevice.EndScene
    D3DDevice.Present ByVal 0, ByVal 0, 0, ByVal 0
    new_text = True
    bRunning = True
    Epsilon = 2 ^ -24
    calculate_epsilon
Exit Sub
ErrHandler:
MsgBox "Error: A01.0 [ " & Err.Number & " ] - " & D3DX.GetErrorString(Err.Number)
LogError "Error: A01.0 [ " & Err.Number & " ] - " & D3DX.GetErrorString(Err.Number)
send_error "CLIENT_ERR A01.0 Código: " & Err.Number & vbNewLine & "Descripción: " & Err.Description & vbNewLine & "FNC:" & cfnc & vbNewLine & "DLLE:" & Err.LastDllError & vbNewLine & "Ln:" & Erl
bRunning = False
exerl = 8000 + Erl()
End Sub

Private Sub calculate_epsilon()
' EPSILON PUEDE CAMBIAR DEPENDIENDO DE LA ARQUITECTURA DEL PROCESADOR
        Dim machEps!
        machEps = 1
        Do
           machEps = machEps / 2
        Loop While ((1 + (machEps / 2)) <> 1)
        
        If machEps <> 0 Then
            Epsilon = machEps
        End If
End Sub

Public Sub Engine_Deinit()

    timeEndPeriod 1
    Erase MapData
    Erase charlist
    Set D3DDevice = Nothing
    Set D3D = Nothing
    Set dX = Nothing
    
End Sub

Private Function CreateTLVertex(x As Single, y As Single, z As Single, rhw As Single, color As Long, Specular As Long, tu As Single, tv As Single) As TLVERTEX
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    CreateTLVertex.v.x = x
    CreateTLVertex.v.y = y
    CreateTLVertex.v.z = z
    CreateTLVertex.rhw = rhw
    CreateTLVertex.color = color
    'CreateTLVertex.Specular = Specular
    CreateTLVertex.tu = tu
    CreateTLVertex.tv = tv
End Function

Private Sub cTLVertex(ByRef tl As TLVERTEX, ByRef x As Single, ByRef y As Single, ByRef color As Long, ByRef tu As Single, ByRef tv As Single)
    tl.v.x = x
    tl.v.y = y
    tl.v.z = 0!
    tl.rhw = 1!
    tl.color = color
    tl.tu = tu
    tl.tv = tv
End Sub

Public Sub Engine_ActFPS()
    If GetTickCount - lFrameTimer > 1000 Then
        FPS = FramesPerSecCounter
        FramesPerSecCounter = 0
        lFrameTimer = GetTickCount
    End If
End Sub

Public Sub Draw_Grh(ByRef Grh As Grh, ByVal XX%, ByVal YY%, ByVal center As Byte, ByVal Animate As Byte, Optional ByVal map_x As Byte = 1, Optional ByVal map_y As Byte = 1, Optional ByVal alt As Byte = 0, Optional ByVal mirror As Byte = 0, Optional ByVal mirrorv As Byte = 0)
    Dim CurrentGrhIndex As Integer
    If Grh.GrhIndex = 0 Then Exit Sub
    If Animate Then
        If Grh.Started = 1 Then
            Grh.FrameCounter = Grh.FrameCounter + (timerElapsedTime * GrhData(Grh.GrhIndex).NumFrames / Grh.speed)
            If Grh.FrameCounter > GrhData(Grh.GrhIndex).NumFrames Then
                Grh.FrameCounter = (Grh.FrameCounter Mod GrhData(Grh.GrhIndex).NumFrames) + 1
                If Grh.Loops <> -1 Then
                    If Grh.Loops > 0 Then
                        Grh.Loops = Grh.Loops - 1
                    Else
                        Grh.Started = 0
                    End If
                End If
            End If
        End If
    End If
    
    'Figure out what frame to draw (always 1 if not animated)
    CurrentGrhIndex = GrhData(Grh.GrhIndex).Frames(Grh.FrameCounter)

    'Center Grh over X,Y pos
    If center Then
        If GrhData(CurrentGrhIndex).TileWidth <> 1 Then _
            XX = XX - Int(GrhData(CurrentGrhIndex).TileWidth * 16) + 16
        If GrhData(Grh.GrhIndex).TileHeight <> 1 Then _
            YY = YY - Int(GrhData(CurrentGrhIndex).TileHeight * 32) + 32
    End If
    
'    If center Then
'        XX = XX - Int(GrhData(CurrentGrhIndex).pixelWidth * 0.5) + 16
'        YY = YY - Int(GrhData(CurrentGrhIndex).pixelHeight * 0.5) + 16
'    End If
    
    If map_x = 0 Then map_x = 1
    If map_y = 0 Then map_y = 1
    
    Grh_Render_new CurrentGrhIndex, XX, YY, map_x, map_y, mirror, mirrorv ', shadow, soff
End Sub

Public Sub Draw_Grh_Alpha(ByRef Grh As Grh, ByVal x!, ByVal y!, ByVal center As Byte, ByVal Animate As Byte, Optional ByVal alpha As Byte, Optional ByVal map_x As Byte = 1, Optional ByVal map_y As Byte = 1, Optional ByVal alt As Byte = 0, Optional ByVal t As Byte = 0)
    Dim CurrentGrhIndex As Integer
    Dim tmp_color(3) As Long
    
    If Grh.GrhIndex = 0 Then Exit Sub
    If Animate Then
        If Grh.Started = 1 Then
            Grh.FrameCounter = Grh.FrameCounter + (timerElapsedTime * GrhData(Grh.GrhIndex).NumFrames / Grh.speed)
            If Grh.FrameCounter > GrhData(Grh.GrhIndex).NumFrames Then
                Grh.FrameCounter = (Grh.FrameCounter Mod GrhData(Grh.GrhIndex).NumFrames) + 1
                
                If Grh.Loops <> -1 Then
                    If Grh.Loops > 0 Then
                        Grh.Loops = Grh.Loops - 1
                    Else
                        Grh.Started = 0
                    End If
                End If
            End If
        End If
    End If
    
    'Figure out what frame to draw (always 1 if not animated)
    CurrentGrhIndex = GrhData(Grh.GrhIndex).Frames(Grh.FrameCounter)

    'Center Grh over X,Y pos
    If center Then
        If GrhData(CurrentGrhIndex).TileWidth <> 1 Then
            x = x - Int(GrhData(CurrentGrhIndex).TileWidth * 16) + 16
        End If

        If GrhData(Grh.GrhIndex).TileHeight <> 1 Then
            y = y - Int(GrhData(CurrentGrhIndex).TileHeight * 32) + 32
        End If
    End If
    
    If map_x = 0 Then map_x = 1
    If map_y = 0 Then map_y = 1

    Grh_Render_new CurrentGrhIndex, x, y, map_x, map_y, , , alpha
End Sub

Public Sub General_Sleep(ByVal Length As Double)
'*****************************************************************
'Sleep for a given number a Microseconds
'*****************************************************************
    Dim curFreq As Currency
    Dim curStart As Currency
    Dim curEnd As Currency
    Dim dblResult As Double
    
    QueryPerformanceFrequency curFreq 'Get the timer frequency
    QueryPerformanceCounter curStart 'Get the start time
    
    Do Until dblResult >= Length
        'DoEvents
        QueryPerformanceCounter curEnd 'Get the end time
        dblResult = (curEnd - curStart) / curFreq * 1000 'Calculate the duration (in seconds)
    Loop
End Sub

Public Sub Render()
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
'On Error GoTo jojo:

cfnc = fnc.E_Render
RENDERCRC = (1073741824 * Rnd) Xor GetTickCount
    'particletimer = timerElapsedTime * 0.01
    Protocol.aim_pj = 105
    If Protocol.aim_pj <> 105 Then End
    
    Dim t#
'    If limit_fps Then
'If frmMain.Checkxd.value Then
'        t = FPSLimiter(False)
'        If t < 15 Then
'            time_wait = 15 - FPSLimiter(False)
'            t = Int(time_wait)
'            If t > 1 Then
'                Sleep t
'                DoEvents
'            End If
'            Call FPSLimiter(True)
'        End If
'        If t > 200 Then Call FPSLimiter(True)
'End If
'    End If



    
    If Not Device_Test_Cooperative_Level Then Exit Sub
    
    'PRECALC

    
    timerElapsedTime = FRAME_TIMER.TimeD
    
    If timerElapsedTime > 200 Then timerElapsedTime = 200
    timerTicksPerFrame = timerElapsedTime * engineBaseSpeed
    
'    If timerTicksPerFrame < Epsilon Then
'        timerTicksPerFrame = Epsilon
'    End If
    
    
    cfnc = fnc.E_crons


    cfnc = fnc.E_Engine_Calc_Screen_Moviment

    Engine_Calc_Screen_Moviment
    

    '/PRECALC
    cfnc = fnc.E_Render
    D3DDevice.BeginScene
    D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, &H0, 1!, 0
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
    
cfnc = fnc.E_Map_Render
    Map_Render
    
    Call Dialogos.Render
    Call DialogosClanes.Draw
    
    
    Engine_UI.Render_GUI
    Dim ff As Single
    ff = FPSTIMER()
    ff = FPS 'format$(ff, "####.##")
    If renderfps Then Call text_render_graphic("FPS: " & Chr$(255) & ff, _
         480, 10, &H77FFFFFF)
        
    D3DDevice.EndScene
    D3DDevice.Present ByVal 0, ByVal 0, 0, ByVal 0
    
    If re_render_inventario = True Then
        DrawInv
        re_render_inventario = False
    End If
    
    If limit_fps Then
        t = FPS_LIMITER.time
        If t < 10 Then Call Sleep(CLng(10 - t))
    End If

   ' zNFrames = zNFrames + 1
    'If zNFrames > 1000000000 Then zNFrames = 1
Exit Sub
jojo:
LogError "Render: " & D3DX.GetErrorString(Err.Number) & " Desc: " & _
    Err.Description & " #: " & Err.Number, True
    
End Sub



Public Sub render_bump()
'With D3DDevice
'                Viewport(0).tu = ZooMlevel * 1.333333333
'                Viewport(0).tv = ZooMlevel
'                Viewport(1).tu = ((MainViewWidth + 1) / 1024) - (ZooMlevel * 1.333333333)
'                Viewport(1).tv = ZooMlevel
'                Viewport(2).tu = ZooMlevel * 1.333333333
'                Viewport(2).tv = ((MainViewHeight + 1) / 1024) - ZooMlevel
'                Viewport(3).tu = Viewport(1).tu
'                Viewport(3).tv = Viewport(2).tv
'                .SetRenderTarget DeviceBuffer, DeviceStencil, 0
'                .SetTexture 0, BlurTexture
'                .SetRenderState D3DRS_TEXTUREFACTOR, D3DColorARGB(128, 255, 255, 255)
'                .SetTextureStageState 0, D3DTSS_ALPHAARG1, D3DTA_TFACTOR
'                .DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, Viewport(0), TL_size
'                .SetTextureStageState 0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE
'End With
End Sub


Public Sub init_gui_tl(ByRef vert() As TLVERTEX, ByVal Top As Integer, ByVal Left As Integer, ByVal Width As Integer, ByVal height As Integer, Optional ByVal color As Long = &HFFFFFFFF)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    vert(1) = Geometry_Create_TLVertex(Left, Top, color, 0, 0)
    vert(3) = Geometry_Create_TLVertex(Left + Width, Left, color, Width / 256, 0)
    vert(0) = Geometry_Create_TLVertex(Left, Top + height, color, 0, height / 256)
    vert(2) = Geometry_Create_TLVertex(Left + Width, Top + height, color, Width / 256, height / 256)
End Sub

Private Sub init_gui_tl_indexed(ByRef vert() As TLVERTEX, ByVal Top As Single, ByVal Left As Single, ByVal Width As Single, ByVal height As Single, ByVal SX As Single, ByVal SY As Single, ByVal tex_dimension As Integer, Optional ByVal color As Long = &HFFFFFFFF)
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    vert(0) = Geometry_Create_TLVertex(Top, Left, color, SX / tex_dimension, SY / tex_dimension)
    vert(1) = Geometry_Create_TLVertex(Top + Width, Left, color, (Width + 1 + SX) / tex_dimension, SY / tex_dimension)
    vert(2) = Geometry_Create_TLVertex(Top, Left + height, color, SX / tex_dimension, (height + SY + 1) / tex_dimension)
    vert(3) = Geometry_Create_TLVertex(Top + Width, Left + height, color, (Width + SX + 1) / tex_dimension, (height + 1 + SY) / tex_dimension)
End Sub

Public Function Device_Test_Cooperative_Level() As Boolean
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 8/30/2004
'Handle Alt-Tab and Ctrl-Alt-Del
'**************************************************************
    'Call TestCooperativeLevel to see what state the device is in.
    Dim hr As Long
    hr = D3DDevice.TestCooperativeLevel
    If hr = D3DERR_DEVICELOST Then
        Exit Function
    ElseIf hr = D3DERR_DEVICENOTRESET Then
        Device_Reset
        Exit Function
    End If

    Device_Test_Cooperative_Level = True
End Function

Public Function Geometry_Create_TLVertex(ByVal x As Single, ByVal y As Single, ByVal color As Long, tu As Single, _
                                            ByVal tv As Single) As TLVERTEX
    Geometry_Create_TLVertex.v.x = x
    Geometry_Create_TLVertex.v.y = y
    Geometry_Create_TLVertex.v.z = 0
    Geometry_Create_TLVertex.rhw = 1
    Geometry_Create_TLVertex.color = color
    Geometry_Create_TLVertex.tu = tu
    Geometry_Create_TLVertex.tv = tv
End Function

Private Function Geometry_Create_TLVertex2(x As Single, y As Single, z As Single, rhw As Single, color As Long, Specular As Long, tu1 As Single, tv1 As Single, tu2 As Single, tv2 As Single) As TLVERTEX2
'mz
Geometry_Create_TLVertex2.x = x
Geometry_Create_TLVertex2.y = y
Geometry_Create_TLVertex2.z = z
Geometry_Create_TLVertex2.rhw = rhw
Geometry_Create_TLVertex2.color = color
Geometry_Create_TLVertex2.Specular = Specular
Geometry_Create_TLVertex2.tu1 = tu1
Geometry_Create_TLVertex2.tv1 = tv1
Geometry_Create_TLVertex2.tu2 = tu2
Geometry_Create_TLVertex2.tv2 = tv2
End Function

Public Sub DrawInv()
    On Error GoTo errh
    If frmMain.Visible = False Then Exit Sub
    If Not Device_Test_Cooperative_Level Then Exit Sub
        D3DDevice.Clear 1, InvRect, D3DCLEAR_TARGET, 0, 0, 0
        D3DDevice.BeginScene
        Dim lcbk As Long
        lcbk = lColorMod
        lColorMod = D3DTOP_MODULATE
        Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
        DrawInventory
        lColorMod = lcbk
        Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
        D3DDevice.EndScene
        D3DDevice.Present InvRect, ByVal 0, frmMain.picInv.Hwnd, ByVal 0
    Exit Sub
errh:
    LogError "DrawInv: " & D3DX.GetErrorString(Err.Number) & " Desc: " & Err.Description & " #: " & Err.Number
End Sub

Private Sub Geometry_Create_Box(ByRef verts() As TLVERTEX, ByRef dest As RECT, ByRef src As RECT, ByRef rgb_list() As Long, _
                                Optional ByRef textures_size As Long, Optional ByVal angle As Single)
'**************************************************************
'Author: Aaron Perkins
'Modified by Juan Martín Sotuyo Dodero
'Last Modify Date: 11/17/2002
'
' * v1      * v3
' |\        |
' |  \      |
' |    \    |
' |      \  |
' |        \|
' * v0      * v2
'**************************************************************
    Dim x_center As Single
    Dim y_center As Single
    Dim radius As Single
    Dim x_cor As Single
    Dim y_cor As Single
    Dim left_point As Single
    Dim right_point As Single
    Dim temp As Single
    
    If angle > 0 Then
        'Center coordinates on screen of the square
        x_center = dest.Left + (dest.Right - dest.Left) / 2
        y_center = dest.Top + (dest.Bottom - dest.Top) / 2
        
        'Calculate radius
        radius = Sqr((dest.Right - x_center) ^ 2 + (dest.Bottom - y_center) ^ 2)
        
        'Calculate left and right points
        temp = (dest.Right - x_center) / radius
        right_point = Atn(temp / Sqr(-temp * temp + 1))
        left_point = Pi - right_point
    End If
    
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If angle = 0 Then
        x_cor = dest.Left
        y_cor = dest.Bottom
    Else
        x_cor = x_center + Cos(-left_point - angle) * radius
        y_cor = y_center - Sin(-left_point - angle) * radius
    End If
    
    
    '0 - Bottom left vertex
    If textures_size Then
        verts(0) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(0), src.Left / textures_size, (src.Bottom + 1) / textures_size)
    Else
        verts(0) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(0), 0, 0)
    End If
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If angle = 0 Then
        x_cor = dest.Left
        y_cor = dest.Top
    Else
        x_cor = x_center + Cos(left_point - angle) * radius
        y_cor = y_center - Sin(left_point - angle) * radius
    End If
    
    
    '1 - Top left vertex
    If textures_size Then
        verts(1) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(1), src.Left / textures_size, src.Top / textures_size)
    Else
        verts(1) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(1), 0, 0)
    End If
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If angle = 0 Then
        x_cor = dest.Right
        y_cor = dest.Bottom
    Else
        x_cor = x_center + Cos(-right_point - angle) * radius
        y_cor = y_center - Sin(-right_point - angle) * radius
    End If
    
    
    '2 - Bottom right vertex
    If textures_size Then
        verts(2) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(2), (src.Right + 1) / textures_size, (src.Bottom + 1) / textures_size)
    Else
        verts(2) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(2), 0, 0)
    End If
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If angle = 0 Then
        x_cor = dest.Right
        y_cor = dest.Top
    Else
        x_cor = x_center + Cos(right_point - angle) * radius
        y_cor = y_center - Sin(right_point - angle) * radius
    End If
    
    
    '3 - Top right vertex
    If textures_size Then
        verts(3) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(3), (src.Right + 1) / textures_size, src.Top / textures_size)
    Else
        verts(3) = Geometry_Create_TLVertex(x_cor, y_cor, rgb_list(3), 0, 0)
    End If
End Sub

Public Sub Grh_Render(ByVal GrhIndex As Long, ByVal dest_x%, ByVal dest_y%, ByVal color As Long)
'*********************************************
'Author: menduz
'*********************************************
    Dim dest_x2%, dest_y2%
    Dim TGRH As GrhData
    If GrhIndex = 0 Then Exit Sub
    Call GetTexture(GrhData(GrhIndex).FileNum)

    If GrhData(GrhIndex).hardcor = 0 Then Init_grh_tutv GrhIndex
    TGRH = GrhData(GrhIndex)
    
    dest_y2 = dest_y + TGRH.pixelHeight
    dest_x2 = dest_x + TGRH.pixelWidth

    With tBox
        .x0 = dest_x
        .y0 = dest_y2
        .x1 = .x0
        .y1 = dest_y
        .x2 = dest_x2
        .y2 = .y0
        .x3 = .x2
        .y3 = .y1
        .color0 = -1
        .color1 = -1
        .color2 = -1
        .color3 = -1
        .tu0 = TGRH.tu(0)
        .tv0 = TGRH.tv(0)
        .tu1 = TGRH.tu(1)
        .tv1 = TGRH.tv(1)
        .tu2 = TGRH.tu(2)
        .tv2 = TGRH.tv(2)
        .tu3 = TGRH.tu(3)
        .tv3 = TGRH.tv(3)
    End With
    
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, tBox, TL_size
End Sub

Public Sub Grh_Render_invselslot(ByVal x!, ByVal y!, Optional ByVal color As Long = &HFFFFFFFF)
'*********************************************
'Author: menduz
'*********************************************
    Static Box As Box_Vertex
    Call GetTexture(9720)

    With Box
        .x0 = x
        .y0 = y + 32
        .color0 = -1
        .x1 = .x0
        .y1 = y
        .color1 = -1
        .x2 = x + 32
        .y2 = .y0
        .color2 = -1
        .x3 = .x2
        .y3 = .y1
        .color3 = -1
        .tu0 = 0
        .tv0 = 1
        .tu1 = 0
        .tv1 = 0
        .tu2 = 1
        .tv2 = 1
        .tu3 = 1
        .tv3 = 0
    End With
    
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, Box, TL_size
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub

Public Sub Grh_Render_new(ByVal GrhIndex As Long, ByVal dest_x As Integer, ByVal dest_y As Integer, ByVal map_x As Byte, ByVal map_y As Byte, Optional ByVal mirror As Byte = 0, Optional ByVal mirrorv As Byte = 0, Optional ByVal alpha As Byte = 0) ', Optional ByVal shadow As Byte = 1, Optional ByRef shadowoffx As Single)
'*********************************************
'Author: menduz
'*********************************************
    Dim dest_x2 As Integer, dest_y2 As Integer
    Dim TGRH As GrhData
    Dim bsf!
    Dim ta As Long
    If GrhIndex = 0 Then Exit Sub
    Call GetTexture(GrhData(GrhIndex).FileNum)

    If GrhData(GrhIndex).hardcor = 0 Then Init_grh_tutv GrhIndex
    TGRH = GrhData(GrhIndex)
    
    dest_y2 = dest_y + TGRH.pixelHeight
    dest_x2 = dest_x + TGRH.pixelWidth

    With tBox
        .x0 = dest_x
        .y0 = dest_y2
        .x1 = .x0
        .y1 = dest_y
        .x2 = dest_x2
        .y2 = .y0
        .x3 = .x2
        .y3 = .y1
        
        .color0 = -1
        .color1 = -1
        .color2 = -1
        .color3 = -1

        If alpha Then
            If alpha > 127 Then
                ta = -(255 - alpha) * &H1000000
            Else
                ta = (alpha Mod 128) * &H1000000
            End If
            .color0 = (.color0 And &HFFFFFF) Or ta
            .color1 = (.color1 And &HFFFFFF) Or ta
            .color2 = (.color2 And &HFFFFFF) Or ta
            .color3 = (.color3 And &HFFFFFF) Or ta
        End If
        
        If mirror Then
            .tu0 = TGRH.tu(2)
            .tv0 = TGRH.tv(2)
            .tu1 = TGRH.tu(3)
            .tv1 = TGRH.tv(3)
            .tu2 = TGRH.tu(0)
            .tv2 = TGRH.tv(0)
            .tu3 = TGRH.tu(1)
            .tv3 = TGRH.tv(1)
        Else
            .tu0 = TGRH.tu(0)
            .tv0 = TGRH.tv(0)
            .tu1 = TGRH.tu(1)
            .tv1 = TGRH.tv(1)
            .tu2 = TGRH.tu(2)
            .tv2 = TGRH.tv(2)
            .tu3 = TGRH.tu(3)
            .tv3 = TGRH.tv(3)
        End If
        
        If mirrorv Then
            bsf = .tv0
            .tv0 = .tv1
            .tv1 = bsf
            bsf = .tv2
            .tv2 = .tv3
            .tv3 = bsf
        End If

    End With
    
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, tBox, TL_size
End Sub

Public Sub Grh_Render_char(ByVal GrhIndex As Long, ByVal dest_x As Integer, ByVal dest_y As Integer, ByVal map_x As Byte, ByVal map_y As Byte, Optional ByVal mirror As Byte = 0) ', Optional ByVal shadow As Byte = 1, Optional ByRef shadowoffx As Single)
'*********************************************
'Author: menduz
'*********************************************
    Dim dest_x2 As Integer, dest_y2 As Integer
    Dim TGRH As GrhData
    If GrhIndex = 0 Then Exit Sub
    Call GetTexture(GrhData(GrhIndex).FileNum)

    If GrhData(GrhIndex).hardcor = 0 Then Init_grh_tutv GrhIndex
    TGRH = GrhData(GrhIndex)
    
    dest_y2 = dest_y + TGRH.pixelHeight
    dest_x2 = dest_x + TGRH.pixelWidth

    With tBox
        .x0 = dest_x
        .y0 = dest_y2
        .x1 = .x0
        .y1 = dest_y
        .x2 = dest_x2
        .y2 = .y0
        .x3 = .x2
        .y3 = .y1

        .color0 = -1
        .color1 = -1
        .color2 = -1
        .color3 = -1

        If mirror Then
            .tu0 = TGRH.tu(2)
            .tv0 = TGRH.tv(2)
            .tu1 = TGRH.tu(3)
            .tv1 = TGRH.tv(3)
            .tu2 = TGRH.tu(0)
            .tv2 = TGRH.tv(0)
            .tu3 = TGRH.tu(1)
            .tv3 = TGRH.tv(1)
        Else
            .tu0 = TGRH.tu(0)
            .tv0 = TGRH.tv(0)
            .tu1 = TGRH.tu(1)
            .tv1 = TGRH.tv(1)
            .tu2 = TGRH.tu(2)
            .tv2 = TGRH.tv(2)
            .tu3 = TGRH.tu(3)
            .tv3 = TGRH.tv(3)
        End If
    End With
    
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, tBox, TL_size
End Sub

Public Sub Grh_Render_Simple_box(ByVal Tex As Long, ByVal tLeft As Single, ByVal tTop As Single, ByVal color As Long, ByVal size As Single, Optional ByVal alpha As Byte, Optional ByVal dw As Single)
'*********************************************
'Author: menduz
'viva la harcodeada, VIVA!
'*********************************************
    Dim ll As Long
    With tBox
        .x0 = tLeft
        .y0 = tTop + size
        .color0 = color
        .x1 = tLeft
        .y1 = tTop
        .color1 = color
        .x2 = tLeft + size + dw
        .y2 = tTop + size
        .color2 = color
        .x3 = tLeft + size + dw
        .y3 = tTop
        .color3 = color
        .tu0 = 0
        .tv0 = 1
        .tu1 = 0
        .tv1 = 0
        .tu2 = 1
        .tv2 = 1
        .tu3 = 1
        .tv3 = 0
    End With
    
    If alpha Then
        D3DDevice.SetRenderState D3DRS_SRCBLEND, D3DBLEND_ONE
        D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_ONE
    End If
    
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
    Call GetTexture(Tex)
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, tBox, TL_size
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
    
    If alpha Then
        D3DDevice.SetRenderState D3DRS_SRCBLEND, D3DBLEND_SRCALPHA
        D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
    End If
End Sub

Public Sub Colorear_Cuadrado(v() As TLVERTEX, ByVal map_x As Byte, ByVal map_y As Byte)
    Dim tmpc As Long
    If map_x < MapSize And map_y > 1 Then
        v(0).color = -1
        v(1).color = -1
        v(2).color = -1
        v(3).color = -1
    End If
End Sub

Public Sub Grh_Proyectil(ByVal GrhIndex As Long, ByVal dest_x As Single, ByVal dest_y As Single, Optional ByVal alpha As Byte = 0, Optional ByVal light_value As Long = &HFFFFFFFF, Optional ByVal Degrees As Integer)
'*********************************************
'Author: menduz
'*********************************************
    Static dest_rect As sRECT
    Static temp_verts(3) As TLVERTEX
    Dim CenterX As Single
    Dim CenterY As Single
    Dim Index As Integer
    Dim NewX As Single
    Dim NewY As Single
    Dim SinRad As Single
    Dim CosRad As Single

    Call GetTexture(GrhIndex)

    With GrhData(GrhIndex)
        dest_rect.Bottom = dest_y + .pixelHeight
        dest_rect.Left = dest_x
        dest_rect.Right = dest_x + .pixelWidth
        dest_rect.Top = dest_y
        
        If .hardcor = 0 Then Init_grh_tutv GrhIndex

        Call cTLVertex(temp_verts(0), dest_rect.Left, dest_rect.Bottom, light_value, 0, 1)
        Call cTLVertex(temp_verts(1), dest_rect.Left, dest_rect.Top, light_value, 0, 0)
        Call cTLVertex(temp_verts(2), dest_rect.Right, dest_rect.Bottom, light_value, 1, 1)
        Call cTLVertex(temp_verts(3), dest_rect.Right, dest_rect.Top, light_value, 1, 0)

        If Degrees > 0 And Degrees < 360 Then
            'Converts the angle to rotate by into radians
            'Set the CenterX and CenterY values
            CenterX = dest_x + (.pixelHeight * 0.5)
            CenterY = dest_y + (.pixelWidth * 0.5)
            'Pre-calculate the cosine and sine of the radiant
            SinRad = Seno(Degrees)
            CosRad = Coseno(Degrees)
            'Loops through the passed vertex buffer
            For Index = 0 To 3
                NewX = CenterX + (temp_verts(Index).v.x - CenterX) * CosRad - (temp_verts(Index).v.y - CenterY) * SinRad
                NewY = CenterY + (temp_verts(Index).v.y - CenterY) * CosRad + (temp_verts(Index).v.x - CenterX) * SinRad
                temp_verts(Index).v.x = NewX
                temp_verts(Index).v.y = NewY
            Next Index
        End If
    End With
    
    If alpha Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_ONE
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, temp_verts(0), TL_size
    If alpha Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
End Sub

Public Sub Grh_Render_nocolor(ByVal GrhIndex As Long, ByVal dest_x As Single, ByVal dest_y As Single, Optional ByVal alpha As Byte = 0, Optional ByVal light_value As Long = &HFFFFFFFF, Optional ByVal Degrees As Integer)
'*********************************************
'Author: menduz
'*********************************************
    Static dest_rect As sRECT
    Static temp_verts(3) As TLVERTEX
    Dim CenterX As Single
    Dim CenterY As Single
    Dim Index As Integer
    Dim NewX As Single
    Dim NewY As Single
    Dim SinRad As Single
    Dim CosRad As Single

    If GrhIndex = 0 Then Exit Sub
    Call GetTexture(GrhData(GrhIndex).FileNum)

    With GrhData(GrhIndex)
        dest_rect.Bottom = dest_y + .pixelHeight
        dest_rect.Left = dest_x
        dest_rect.Right = dest_x + .pixelWidth
        dest_rect.Top = dest_y
        
        If .hardcor = 0 Then Init_grh_tutv GrhIndex

        Call cTLVertex(temp_verts(0), dest_rect.Left, dest_rect.Bottom, light_value, .tu(0), .tv(0))
        Call cTLVertex(temp_verts(1), dest_rect.Left, dest_rect.Top, light_value, .tu(1), .tv(1))
        Call cTLVertex(temp_verts(2), dest_rect.Right, dest_rect.Bottom, light_value, .tu(2), .tv(2))
        Call cTLVertex(temp_verts(3), dest_rect.Right, dest_rect.Top, light_value, .tu(3), .tv(3))

        If Degrees > 0 And Degrees < 360 Then
            'Converts the angle to rotate by into radians
            'Set the CenterX and CenterY values
            CenterX = dest_x + (.pixelHeight * 0.5)
            CenterY = dest_y + (.pixelWidth * 0.5)
            'Pre-calculate the cosine and sine of the radiant
            SinRad = Seno(Degrees)
            CosRad = Coseno(Degrees)
            'Loops through the passed vertex buffer
            For Index = 0 To 3
                NewX = CenterX + (temp_verts(Index).v.x - CenterX) * CosRad - (temp_verts(Index).v.y - CenterY) * SinRad
                NewY = CenterY + (temp_verts(Index).v.y - CenterY) * CosRad + (temp_verts(Index).v.x - CenterX) * SinRad
                temp_verts(Index).v.x = NewX
                temp_verts(Index).v.y = NewY
            Next Index
        End If
    End With
    
    If alpha Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_ONE
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, temp_verts(0), TL_size
    If alpha Then D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA
End Sub

Public Sub Init_grh_tutv(ByVal GrhIndex As Integer)
    Dim h!, w!
    Call GetTextureDimension(GrhData(GrhIndex).FileNum, h, w)
    If h = 0 Then Exit Sub
    With GrhData(GrhIndex)
'        .tu(0) = .SX / w
'        .tv(0) = (.SY + .pixelHeight) / h
'        .tu(1) = .tu(0)
'        .tv(1) = .SY / h
'        .tu(2) = (.SX + .pixelWidth) / w
'        .tv(2) = .tv(0)
'        .tu(3) = .tu(2)
'        .tv(3) = .tv(1)
            .tu(0) = .SX / w
            .tv(0) = (.SY + .pixelHeight + 1) / h
            .tu(1) = .SX / w
            .tv(1) = .SY / h
            .tu(2) = (.SX + .pixelWidth + 1) / w
            .tv(2) = (.SY + .pixelHeight + 1) / h
            .tu(3) = (.SX + .pixelWidth + 1) / w
            .tv(3) = .SY / h
'            .hardcor = 1
        .hardcor = 1
    End With
End Sub

Public Sub start()
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
DoEvents

Dim cut_fps_ud As Long
Dim conteo As Double

Do While prgRun
    Call FlushBuffer
    Rem Limitar FPS


    If frmMain.WindowState <> vbMinimized And frmMain.Visible = True Then
        CheckKeys
        Render
        
        cut_fps_ud = timeGetTime
        FramesPerSecCounter = FramesPerSecCounter + 1
        If (cut_fps_ud - lFrameTimer) >= 1000 Then
            FPS = FramesPerSecCounter
            FramesPerSecCounter = 0
            lFrameTimer = cut_fps_ud
            'FPS_LIMITER.Time
            rm2a
            'Call ResetFPS
        End If
        
    Else
        Sleep 16&
    End If


    'Audio.Music_GetLoop
    DoEvents
Loop

Engine.Engine_Deinit
Call CloseClient


End Sub


Public Function CreateColorVal(a As Single, r As Single, G As Single, b As Single) As D3DCOLORVALUE
    CreateColorVal.a = a
    CreateColorVal.r = r
    CreateColorVal.G = G
    CreateColorVal.b = b
End Function

Public Function Engine_FToDW(f As Single) As Long
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    Call DXCopyMemory(Engine_FToDW, f, 4)
End Function

Private Function VectorToRGBA(vec As D3DVECTOR, fHeight As Single) As Long
Dim r As Integer, G As Integer, b As Integer, a As Integer
    r = 127 * vec.x + 128
    G = 127 * vec.y + 128
    b = 127 * vec.z + 128
    a = 255 * fHeight
    VectorToRGBA = D3DColorARGB(a, r, G, b)
End Function


Public Sub Draw_FilledBox(ByVal x As Integer, ByVal y As Integer, ByVal Width As Integer, ByVal height As Integer, color As Long, outlinecolor As Long, Optional ByVal lh As Integer = 1)
    Static box_rect As RECT
    Static Outline As RECT
    Static rgb_list(3) As Long
    Static rgb_list2(3) As Long
    Static vertex(3) As TLVERTEX
    Static Vertex2(3) As TLVERTEX
    
    rgb_list(0) = color
    rgb_list(1) = color
    rgb_list(2) = color
    rgb_list(3) = color
    
    rgb_list2(0) = outlinecolor
    rgb_list2(1) = outlinecolor
    rgb_list2(2) = outlinecolor
    rgb_list2(3) = outlinecolor
    
    With box_rect
        .Bottom = y + height - lh
        .Left = x + lh
        .Right = x + Width - lh
        .Top = y + lh
    End With
    
    With Outline
        .Bottom = y + height
        .Left = x
        .Right = x + Width
        .Top = y
    End With
    
    Geometry_Create_Box Vertex2(), Outline, Outline, rgb_list2(), 0, 0
    Geometry_Create_Box vertex(), box_rect, box_rect, rgb_list(), 0, 0
    last_texture = 0
    D3DDevice.SetTexture 0, Nothing
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, Vertex2(0), TL_size
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, vertex(0), TL_size
End Sub

Private Function FPSLimiter(bool As Boolean) As Single
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    Dim start_time As Currency
    Static end_time As Currency
    Static timer_freq As Currency
    If timer_freq = 0 Then
        QueryPerformanceFrequency timer_freq
    End If
    Call QueryPerformanceCounter(start_time)
    FPSLimiter = (start_time - end_time) / timer_freq * 1000
    If bool = True Then _
        Call QueryPerformanceCounter(end_time)
End Function

Private Function FPSTIMER(Optional ByVal reset As Byte) As Double
'*****************************************************
'****** Coded by Menduz (lord.yo.wo@gmail.com) *******
'*****************************************************
    Dim start_time As Currency
    Dim end_time As Currency
    Static timer_freq As Double
    Static stt As Double
    Dim tt As Double
    
    If timer_freq = 0 Then
        QueryPerformanceFrequency end_time
        timer_freq = CDbl(end_time)
        Call QueryPerformanceCounter(start_time)
        stt = CDbl(start_time)
        
    End If
    
    Call QueryPerformanceCounter(end_time)
    
    tt = (CDbl(end_time) - stt) / timer_freq
    
    If tt > 1 Then
        Call QueryPerformanceCounter(start_time)
        stt = CDbl(start_time)
        'zNFrames = 1
    End If
    
    'FPSTIMER = Round((zNFrames / tt + 0.5), 1)
    
    
End Function



Private Sub text_render_graphic(t$, x!, y!, Optional ByVal color As Long = &HFFFFFFFF, Optional ByVal scalea As Single = 1)
    'Dim i As Integer

    Dim lenght&
    lenght = Len(t)
    If lenght = 0 Then Exit Sub
    

    Dim ind&, TempStr$()
    Dim TLV() As TLVERTEX
    
    ReDim TLV((Len(t) * 4) - 1)

    Call GetTexture(9718) '//tehoma shadow
    'Call GetTexture(9733) '//tehoma shadow rounded

    x = Round(x)
    y = Round(y)

    Dim count As Integer
    Dim Ascii() As Byte



    Dim i As Long
    Dim j As Long
    Dim KeyPhrase As Byte
    Dim TempColor As Long
    Dim ResetColor As Byte

    Dim YOffset As Single
    Dim lena&
    
    TempColor = color
        TempStr = Split(t, vbCrLf)
        For i = 0 To UBound(TempStr)
        If Len(TempStr(i)) > 0 Then
            YOffset = i * Font_Default.CharHeight * scalea
            count = 0
        
            'Convert the characters to the ascii value
            Ascii() = StrConv(TempStr(i), vbFromUnicode)
            lena = Len(TempStr(i)) - 1
            'Loop through the characters
            For j = 0 To lena
                If Ascii(j) = 255 Then 'If Ascii = "|"124
                    KeyPhrase = (Not KeyPhrase)  'TempColor = ARGB 255/255/0/0
                    If KeyPhrase Then TempColor = &HFFAACCAA Else ResetColor = 1
                Else
                        'Copy from the cached vertex array to the temp vertex array
                        CopyMemory TLV(ind), Font_Default.HeaderInfo.CharVA(Ascii(j)).vertex(0), TL_size * 4

                        'Set up the verticies
                        TLV(ind).v.x = x + count
                        TLV(ind).v.y = y + YOffset
                        
                        TLV(ind + 1).v.x = x + count + TLV(ind + 1).v.x '* scalea
                        TLV(ind + 1).v.y = TLV(ind).v.y

                        TLV(ind + 2).v.x = TLV(ind).v.x
                        TLV(ind + 2).v.y = TLV(ind + 2).v.y + TLV(ind).v.y '* scalea

                        TLV(ind + 3).v.x = TLV(ind + 1).v.x
                        TLV(ind + 3).v.y = TLV(ind + 2).v.y
                        
                        'Set the colors
                        TLV(ind).color = TempColor
                        TLV(ind + 1).color = TempColor
                        TLV(ind + 2).color = TempColor
                        TLV(ind + 3).color = TempColor
                        ind = ind + 4
                    'Shift over the the position to render the next character
                    count = count + Font_Default.HeaderInfo.CharWidth(Ascii(j)) '* scalea
                
                End If
                
                'Check to reset the color
                If ResetColor Then
                    ResetColor = 0
                    TempColor = color
                End If
                
            Next j
            
        End If
    Next i
    
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, ind - 2, TLV(0), TL_size
    Call D3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, lColorMod)
End Sub

Public Function Engine_GetTextWidth(ByVal Text As String) As Integer
    Dim i As Integer
    If LenB(Text) = 0 Then Exit Function
    For i = 1 To Len(Text)
        Engine_GetTextWidth = Engine_GetTextWidth + Font_Default.HeaderInfo.CharWidth(Asc(mid$(Text, i, 1)))
    Next i
End Function


Sub Engine_Init_FontSettings()
Dim FileNum As Byte
Dim LoopChar As Long
Dim Row As Single
Dim u As Single
Dim v As Single

    '*** Default font ***

    'Load the header information
    FileNum = FreeFile
    Open app.Path & "\Datos\f9718.dat" For Binary As #FileNum
        Get #FileNum, , Font_Default.HeaderInfo
    Close #FileNum
    
    'Calculate some common values
    Font_Default.CharHeight = Font_Default.HeaderInfo.CellHeight - 4
    Font_Default.RowPitch = Font_Default.HeaderInfo.BitmapWidth \ Font_Default.HeaderInfo.CellWidth
    Font_Default.ColFactor = Font_Default.HeaderInfo.CellWidth / Font_Default.HeaderInfo.BitmapWidth
    Font_Default.RowFactor = Font_Default.HeaderInfo.CellHeight / Font_Default.HeaderInfo.BitmapHeight
    
    'Cache the verticies used to draw the character (only requires setting the color and adding to the X/Y values)
    For LoopChar = 0 To 255
        
        'tU and tV value (basically tU = BitmapXPosition / BitmapWidth, and height for tV)
        Row = (LoopChar - Font_Default.HeaderInfo.BaseCharOffset) \ Font_Default.RowPitch
        u = ((LoopChar - Font_Default.HeaderInfo.BaseCharOffset) - (Row * Font_Default.RowPitch)) * Font_Default.ColFactor
        v = Row * Font_Default.RowFactor

        'Set the verticies
        With Font_Default.HeaderInfo.CharVA(LoopChar)
            .vertex(0).color = D3DColorARGB(255, 0, 0, 0)   'Black is the most common color
            .vertex(0).rhw = 1
            .vertex(0).tu = u
            .vertex(0).tv = v
            .vertex(0).v.x = 0
            .vertex(0).v.y = 0
            .vertex(0).v.z = 0
            
            .vertex(1).color = D3DColorARGB(255, 0, 0, 0)
            .vertex(1).rhw = 1
            .vertex(1).tu = u + Font_Default.ColFactor
            .vertex(1).tv = v
            .vertex(1).v.x = Font_Default.HeaderInfo.CellWidth
            .vertex(1).v.y = 0
            .vertex(1).v.z = 0
            
            .vertex(2).color = D3DColorARGB(255, 0, 0, 0)
            .vertex(2).rhw = 1
            .vertex(2).tu = u
            .vertex(2).tv = v + Font_Default.RowFactor
            .vertex(2).v.x = 0
            .vertex(2).v.y = Font_Default.HeaderInfo.CellHeight
            .vertex(2).v.z = 0
            
            .vertex(3).color = D3DColorARGB(255, 0, 0, 0)
            .vertex(3).rhw = 1
            .vertex(3).tu = u + Font_Default.ColFactor
            .vertex(3).tv = v + Font_Default.RowFactor
            .vertex(3).v.x = Font_Default.HeaderInfo.CellWidth
            .vertex(3).v.y = Font_Default.HeaderInfo.CellHeight
            .vertex(3).v.z = 0
        End With
        
    Next LoopChar

End Sub


' extract major/minor from version cap
Function D3DSHADER_VERSION_MAJOR(version As Long) As Long

    D3DSHADER_VERSION_MAJOR = (((version) \ 8) And &HFF&)

End Function

Function D3DSHADER_VERSION_MINOR(version As Long) As Long

    D3DSHADER_VERSION_MINOR = (((version)) And &HFF&)

End Function

'vertex shader version token
Function D3DVS_VERSION(Major As Long, Minor As Long) As Long

    D3DVS_VERSION = (&HFFFE0000 Or ((Major) * 2 ^ 8) Or (Minor))

End Function

Function LONGtoD3DCOLORVALUE(ByVal color As Long) As D3DCOLORVALUE

  Dim a As Long, r As Long, G As Long, b As Long

    If color < 0 Then
        a = ((color And (&H7F000000)) / (2 ^ 24)) Or &H80&
      Else
        a = color / (2 ^ 24)
    End If
    r = (color And &HFF0000) / (2 ^ 16)
    G = (color And &HFF00&) / (2 ^ 8)
    b = (color And &HFF&)

    LONGtoD3DCOLORVALUE.a = a / 255
    LONGtoD3DCOLORVALUE.r = r / 255
    LONGtoD3DCOLORVALUE.G = G / 255
    LONGtoD3DCOLORVALUE.b = b / 255

End Function

Private Sub Get_Capabilities()
cfnc = fnc.E_Get_Capabilities
On Error Resume Next
    Dim d3dCaps As D3DCAPS8

    D3DDevice.GetDeviceCaps d3dCaps

    'check bump mapping

    ''//Does this device support the two bump mapping blend operations?
    If (d3dCaps.TextureOpCaps And D3DTEXOPCAPS_BUMPENVMAPLUMINANCE) Then
        act_caps.CanDo_BumpMapping = 1
    End If

    ''//Does this device support up to three blending stages?
    If d3dCaps.MaxTextureBlendStages < 3 Then
        act_caps.CandDo_3StagesTextureBlending = 0
      Else
        act_caps.CandDo_3StagesTextureBlending = 1

    End If

    ''//Does this device support multitexturing
    If d3dCaps.MaxSimultaneousTextures > 1 Then
        act_caps.CanDo_MultiTexture = 1
        act_caps.Max_TextureStages = d3dCaps.MaxSimultaneousTextures
    End If

    'anisotropic filter
    If d3dCaps.RasterCaps And D3DPRASTERCAPS_ANISOTROPY Then
        act_caps.Filter_Anisotropic = True

        act_caps.Max_AnisotropY = d3dCaps.MaxAnisotropy

    End If

    'trilinear

    If (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MINFLINEAR) Then

        If (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MAGFLINEAR) Then
            If (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MIPFLINEAR) Then

                act_caps.Filter_Trilinear = 1

            End If
        End If
    End If

    'flatcubic

    If ((d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MINFLINEAR) + _
       (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MAGFAFLATCUBIC) + _
       (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MIPFLINEAR)) Then

        act_caps.Filetr_FlatCubic = 1

    End If

    'Gaussian cubic

    If ((d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MINFLINEAR) + _
       (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MAGFGAUSSIANCUBIC) + _
       (d3dCaps.TextureFilterCaps And D3DPTFILTERCAPS_MIPFLINEAR)) Then

        act_caps.Filter_GaussianCubic = 1

    End If

    If d3dCaps.TextureCaps And D3DPTEXTURECAPS_VOLUMEMAP Then

        act_caps.CanDo_VolumeTexture = 1

    End If

    If d3dCaps.TextureCaps And D3DPTEXTURECAPS_PROJECTED Then

        act_caps.CanDo_ProjectedTexture = 1

    End If

    If d3dCaps.TextureCaps And D3DPTEXTURECAPS_MIPMAP Then

        act_caps.CanDo_TextureMipMapping = 1

    End If

'    If (d3dCaps.RasterCaps And D3DPRASTERCAPS_WBUFFER) Then
'        act_caps.Wbuffer_OK = True
'        obj_Device.SetRenderState D3DRS_ZENABLE, D3DZB_USEW
'        IS_WBUFFER = True
'    End If

    If d3dCaps.MaxPointSize > 0 Then
        act_caps.CanDo_PointSprite = 1
    End If

  Dim MA As Long
  Dim MI As Long

    MA = D3DSHADER_VERSION_MAJOR(d3dCaps.VertexShaderVersion)
    MI = D3DSHADER_VERSION_MINOR(d3dCaps.VertexShaderVersion)

    'MA = D3DVS_VERSION(MA, MI)
    act_caps.Vertex_ShaderVERSION = STR(MI) + "." + CStr(MA)

    MA = D3DSHADER_VERSION_MAJOR(d3dCaps.PixelShaderVersion)
    MI = D3DSHADER_VERSION_MINOR(d3dCaps.PixelShaderVersion)
    act_caps.pxs_max = MA
    act_caps.pxs_min = MI
    'MA = D3DVS_VERSION(MA, MI)
    act_caps.Pixel_ShaderVERSIOn = STR(MI) + "." + CStr(MA)

    act_caps.Cando_VertexShader = d3dCaps.VertexShaderVersion >= D3DVS_VERSION(1, 0)
    act_caps.Cando_PixelShader = d3dCaps.PixelShaderVersion >= D3DVS_VERSION(1, 0)

    act_caps.CanDo_CubeMapping = (d3dCaps.TextureCaps And D3DPTEXTURECAPS_CUBEMAP)

    act_caps.CanDo_Dot3 = (d3dCaps.TextureOpCaps And D3DTEXOPCAPS_DOTPRODUCT3)

    act_caps.CanDoTableFog = (d3dCaps.RasterCaps And D3DPRASTERCAPS_FOGTABLE) And _
                              (D3DPRASTERCAPS_ZFOG) Or (d3dCaps.RasterCaps And D3DPRASTERCAPS_WFOG)

    act_caps.CanDoVertexFog = (d3dCaps.RasterCaps And D3DPRASTERCAPS_FOGVERTEX)

    act_caps.CanDoWFog = (d3dCaps.RasterCaps And D3DPRASTERCAPS_WFOG)

'  Dim nAdapters As Long 'How many adapters we found
'  Dim AdapterInfo As D3DADAPTER_IDENTIFIER8 'A Structure holding information on the adapter
'
'  Dim sTemp As String
'
'    '//This'll either be 1 or 2
'    nAdapters = obj_D3D.GetAdapterCount
'
'    For I = 0 To nAdapters - 1
'        'Get the relevent Details
'        obj_D3D.GetAdapterIdentifier I, 0, AdapterInfo
'
'        'Get the name of the current adapter - it's stored as a long
'        'list of character codes that we need to parse into a string
'        ' - Dont ask me why they did it like this; seems silly really :)
'        sTemp = "" 'Reset the string ready for our use
'
'        For J = 0 To 511
'            sTemp = sTemp & Chr$(AdapterInfo.Description(J))
'        Next J
'        sTemp = Replace(sTemp, Chr$(0), " ")
'        J = InStr(sTemp, "     ")
'        sTemp = Left$(sTemp, J)
'
'    Next I
'
'    If InStr(UCase(sTemp), "GEFORCE") Then
'
'        If act_caps.Wbuffer_OK = 0 Then
'            act_caps.Wbuffer_OK = 1
'            IS_WBUFFER = 1
'        End If
'
'    End If

End Sub

Public Function CosInterp(ByVal y1 As Single, ByVal y2 As Single, ByVal mu As Single) As Single
'interpolación con coseno wachin
   Dim mu2 As Single
   mu2 = (1 - Cos(mu * Pi)) / 2
   CosInterp = y1 * (1 - mu2) + y2 * mu2
End Function
Public Function Interp(ByVal y1 As Single, ByVal y2 As Single, ByVal mu As Single) As Single
'interpolación lineal
   Interp = y1 * (1 - mu) + y2 * mu
End Function
