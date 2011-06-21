VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAudio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
'*****************************************************************
'clsSoundEngine - ImperiumAO - v1.3.0
'
'
'*****************************************************************
'Respective portions copyrighted by contributors listed below.
'
'This library is free software; you can redistribute it and/or
'modify it under the terms of the GNU Lesser General Public
'License as published by the Free Software Foundation version 2.1 of
'the License
'
'This library is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
'Lesser General Public License for more details.
'
'You should have received a copy of the GNU Lesser General Public
'License along with this library; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'*****************************************************************

'*****************************************************************
'Augusto José Rando (barrin@imperiumao.com.ar)
'   - First Relase
'*****************************************************************

Option Explicit

Private dX As DirectX8

'**** Direct Sound ********
Private DS As DirectSound8
Private DS_Enum As DirectSoundEnum8

'**** MP3 / MIDI ********
Dim IMC   As IMediaControl
Dim IBA   As IBasicAudio
Dim IME   As IMediaEvent
Dim IMPos As IMediaPosition

'**** AMBIENT ********
Dim ambient_buffer As DirectSoundSecondaryBuffer8

Private mAmbienteActual As Integer
Private mLastAmbienteActual As Integer
Private mMusActual As Integer
Public WavPath As String
Private MidiPath As String
Private MP3Path As String

'Manejador de buffers
Private Buffers As CBufferMan

'El volúmen actual real (sonidos)
Private mEffectsVolume As Long

'El volúmen actual real (ambientes)
Private mEffectsVolumeAmbient As Long

'El volúmen actual real (música)
Private mMusicVolume As Long

'El volúmen máximo en la configuración (sonidos)
Private mEffectsVolumeMax As Long

'El volúmen máximo en la configuración (ambientes)
Private mAmbientVolumeMax As Long

'El volúmen máximo en la configuración (música)
Private mMusicVolumeMax As Long

'¿Estamos haciendo efecto fade?
Private mFadingStatus As Byte
Private mFadingMusicMod As Long

'¿Próximo MP3 o MIDI?
Private mNextMusic As Integer

Private INTERIOR_VOLUME As Long
Private EXTERIOR_VOLUME As Long

Private TimeElapsed As Long
Private mInvert_Sound As Boolean

Private Const VOLUME_DISTANCE_MOD As Long = 200

Private Property Let SetWavPath(ByVal inString As String)
WavPath = inString
End Property

Private Property Let SetMP3Path(ByVal inString As String)
MP3Path = inString
End Property

Private Property Let SetMidiPath(ByVal inString As String)
MidiPath = inString
End Property

Public Function Engine_DeInitialize()

'Destroy all buffers
If Not Buffers Is Nothing Then
    Call Buffers.BorrarTodo
    Set Buffers = Nothing
End If

End Function

Public Function Initialize_Engine(ByVal main_hwnd As String, ByVal Set_Wav_Path As String, ByVal Set_MP3_Path As String, ByVal Set_Midi_Path As String, Optional ByVal Play_only_on_focus As Boolean = True, Optional ByVal Initialize_Sounds As Boolean = True, Optional ByVal Initialize_Music As Boolean = True, Optional ByVal sound_volume As Long, Optional ByVal music_volume As Long, Optional ByVal invert_snd As Boolean) As Boolean

On Error GoTo ErrHandler

Set dX = New DirectX8

If Initialize_Sounds Then
    SetWavPath = Set_Wav_Path
    Set DS_Enum = dX.GetDSEnum
    Set DS = dX.DirectSoundCreate(DS_Enum.GetGuid(1))
    
    Set Buffers = New CBufferMan
    Buffers.path = Set_Wav_Path
    Call Buffers.Init(DS, 400)
    
    If Play_only_on_focus Then
        DS.SetCooperativeLevel main_hwnd, DSSCL_NORMAL
    Else
        DS.SetCooperativeLevel main_hwnd, DSSCL_PRIORITY
    End If

    VolumenActual = sound_volume
    mInvert_Sound = invert_snd

End If

If Initialize_Music Then
    SetMidiPath = Set_Midi_Path
    SetMP3Path = Set_MP3_Path
    'VolumenActualMusicMax = music_volume
End If

Initialize_Engine = True

Exit Function

ErrHandler:
    Initialize_Engine = False

End Function

Public Property Get AmbienteActual() As Integer
AmbienteActual = mAmbienteActual
End Property

Public Property Let AmbienteActual(ByVal vNewValue As Integer)

'If estado_time = fxLluvia Then
'    mAmbienteActual = vNewValue
'    Call Ambient_Stop
'    Call Ambient_Load(mAmbienteActual, mEffectsVolumeAmbient)
'    Call Ambient_Play
'Else
'    LastAmbienteActual = vNewValue
'End If

End Property

Public Property Get LastAmbienteActual() As Integer
LastAmbienteActual = mLastAmbienteActual
End Property

Public Property Let LastAmbienteActual(ByVal vNewValue As Integer)
mLastAmbienteActual = vNewValue
End Property

Public Property Get MusicActual() As Integer
MusicActual = mMusActual
End Property

Public Property Let MusicActual(ByVal vNewValue As Integer)
mMusActual = vNewValue
End Property

Public Property Let Fading(ByVal vNewValue As Long)
mFadingMusicMod = vNewValue
TimeElapsed = GetTickCount
End Property

Public Property Get Fading() As Long
Fading = mFadingMusicMod
End Property

Public Property Get VolumenActual() As Long
VolumenActual = mEffectsVolumeMax
End Property

Public Property Let VolumenActual(ByVal vNewValue As Long)

If vNewValue > 0 Then vNewValue = 0
If vNewValue < -4000 Then vNewValue = -4000

mEffectsVolumeMax = vNewValue
Buffers.ModificarVolumenTodo (vNewValue)

EXTERIOR_VOLUME = CLng((vNewValue - 1) * 3.5)
INTERIOR_VOLUME = CLng((vNewValue - 1) * 4)
mEffectsVolumeAmbient = -4000

End Property

Public Property Get InvertirSonido() As Boolean
InvertirSonido = mInvert_Sound
End Property

Public Property Let InvertirSonido(ByVal vNewValue As Boolean)
mInvert_Sound = vNewValue
End Property

Public Property Let VolumenActualMusicMax(ByVal vNewValue As Long)

If vNewValue > 0 Then vNewValue = 0
If vNewValue < -4000 Then vNewValue = -4000

mMusicVolumeMax = vNewValue

End Property

Public Property Get VolumenActualMusicMax() As Long
VolumenActualMusicMax = mMusicVolumeMax
End Property

Public Property Get VolumenActualMusic() As Long
VolumenActualMusic = mMusicVolume
End Property

Public Property Let VolumenActualMusic(ByVal vNewValue As Long)
mMusicVolume = vNewValue
End Property

Public Property Let NextMusic(ByVal vNewValue As Integer)

If mFadingStatus <> 2 And vNewValue <> 0 Then 'Si no estamos en fade up ya...
    mNextMusic = vNewValue
Else
    mNextMusic = vNewValue
    mFadingStatus = 0
End If

End Property

Public Function Sound_Stop_All() As Boolean

Buffers.DetenerTodo
mAmbienteActual = 0
Sound_Stop_All = True

End Function

Public Function Sound_Play(ByVal Sound_File As Integer, Optional ByVal Do_Loop As Boolean = False, Optional ByVal Volume As Long = 0, Optional ByVal pan As Long = 0) As Boolean
If SoundActivated = False Then Exit Function
Dim Sound_Buffer As DirectSoundSecondaryBuffer8

On Error GoTo Error_Handl
    
    If (Sound_File <= 0) Then Exit Function
    
    If Volume = 0 Then Volume = mEffectsVolumeMax
    Call Buffers.Reproducir(Sound_File, IIf(Do_Loop, DSBPLAY_LOOPING, DSBPLAY_DEFAULT), Volume, pan)
    Sound_Play = True
    
    Exit Function
    
Error_Handl:
    Sound_Play = False
End Function

Public Function Sound_Stop(ByVal Sound_File As Integer) As Boolean

On Error GoTo Error_Handl
    
    If Sound_File <= 0 Then Exit Function
    Call Buffers.Detener(Sound_File)
    Sound_Stop = True
    Exit Function

Error_Handl:
    Sound_Stop = False

End Function

Public Function Music_Empty() As Boolean
    
    On Error GoTo Error_Handl
    
    If ObjPtr(IMC) > 0 Then
        IMC.Stop
    End If
    
    Set IBA = Nothing
    Set IME = Nothing
    Set IMPos = Nothing
    Set IMC = Nothing
    
    Music_Empty = True
    Exit Function

Error_Handl:
    Music_Empty = False
End Function

Public Function Music_Load(ByVal file_number As String, Optional ByVal Volume As Long = 0, Optional ByVal balance As Long = 0) As Boolean '**** Loads a MP3 *****
    
    On Error GoTo Error_Handl
        
        If FileExist(MP3Path & file_number & ".mp3", vbNormal) Then
            If Not Music_Empty() = True Then GoTo Error_Handl
            Set IMC = New FilgraphManager
            IMC.RenderFile MP3Path & file_number & ".mp3"
        Else
            GoTo Error_Handl
        End If



    Set IBA = IMC
    If Volume < -4000 Then Volume = -4000
    IBA.Volume = Volume
    If balance > 5000 Then balance = 5000
    If balance < -5000 Then balance = -5000
    IBA.balance = balance
    
    Set IME = IMC
    
    Set IMPos = IMC
    If ObjPtr(IMPos) Then IMPos.Rate = 1#
    IMPos.CurrentPosition = 0
    mMusActual = Val(file_number)
    Music_Load = True
    Exit Function

Error_Handl:
    Music_Load = False
End Function

Public Function Music_Play() As Boolean
    
    On Error GoTo Error_Handl
    
    IMC.Run
    
    Music_Play = True
    Exit Function

Error_Handl:
    Music_Play = False
End Function

Public Function Music_GetLoop() As Boolean
    
    On Error GoTo Error_Handl
    
    If IMPos Is Nothing Then Exit Function
    If IMPos.StopTime = IMPos.CurrentPosition Then
        Music_Stop
        Music_Play
        Music_GetLoop = True
    End If
    
    Exit Function
    
Error_Handl:
    Music_GetLoop = False
End Function

Public Function Music_Stop() As Boolean

    On Error GoTo Error_Handl
    
    IMC.Stop
    IMPos.CurrentPosition = 0
    
    Music_Stop = True
    Exit Function

Error_Handl:
    Music_Stop = False
End Function

Public Function Music_Pause() As Boolean

    On Error GoTo Error_Handl
    
    IMC.Pause
    
    Music_Pause = True
    Exit Function

Error_Handl:
    Music_Pause = False
End Function

Public Function Music_Volume_Set(ByVal sound_volume As Long) As Boolean

    On Error GoTo Error_Handl
    
    If IBA Is Nothing Then Exit Function
    
    If sound_volume > 0 Then sound_volume = 0
    If sound_volume < -4000 Then sound_volume = -4000
    
    IBA.Volume = sound_volume

    Music_Volume_Set = True
    Exit Function

Error_Handl:
    Music_Volume_Set = False
End Function

Public Function Ambient_Load(ByVal file_name As Integer, Optional ByVal Volume As Long = 0)
    
    On Error GoTo Error_Handl
        
    Dim dsbd As DSBUFFERDESC
    dsbd.lFlags = DSBCAPS_CTRLVOLUME
    dsbd.fxFormat.nFormatTag = WAVE_FORMAT_PCM
    dsbd.fxFormat.nChannels = 2
    dsbd.fxFormat.lSamplesPerSec = 22050
    dsbd.fxFormat.nBitsPerSample = 16
    dsbd.fxFormat.nBlockAlign = dsbd.fxFormat.nBitsPerSample / 8 * dsbd.fxFormat.nChannels
    dsbd.fxFormat.lAvgBytesPerSec = dsbd.fxFormat.lSamplesPerSec * dsbd.fxFormat.nBlockAlign
    
    If FileExist(MP3Path & file_name & ".wav", vbArchive) Then 'Extract_File(wav, WavPath, file_name & ".wav", Windows_Temp_Dir, False) Then
        Set ambient_buffer = DS.CreateSoundBufferFromFile(MP3Path & file_name & ".wav", dsbd)
            'Delete_File Windows_Temp_Dir & file_name & ".wav"
    Else
        GoTo Error_Handl
    End If


    If Volume < -4000 Then Volume = -4000
    ambient_buffer.SetVolume Volume
    
    Ambient_Load = True
    Exit Function

Error_Handl:
    Ambient_Load = False
End Function

Public Function Ambient_Play() As Boolean
    
    On Error GoTo Error_Handl
    
    ambient_buffer.Play DSBPLAY_LOOPING
    
    Ambient_Play = True
    Exit Function

Error_Handl:
    Ambient_Play = False
End Function

Public Function Ambient_Stop() As Boolean

    On Error GoTo Error_Handl
    
    If ambient_buffer Is Nothing Then Exit Function
    ambient_buffer.Stop
        
    Ambient_Stop = True
    Exit Function

Error_Handl:
    Ambient_Stop = False
End Function

Public Function Ambient_Volume_Set(ByVal sound_volume As Long) As Boolean

    On Error GoTo Error_Handl
    
    If ambient_buffer Is Nothing Then Exit Function
    
    If sound_volume > 0 Then sound_volume = 0
    If sound_volume < -4000 Then sound_volume = -4000
    
    ambient_buffer.SetVolume sound_volume

    Ambient_Volume_Set = True
    Exit Function

Error_Handl:
    Ambient_Volume_Set = False
End Function

Public Function Sound_Render()
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 17/08/2005
'
'**************************************************************

On Error Resume Next

Dim TiempoActual As Long, x As Integer, Y As Integer

Static under_roof As Boolean
Static Sound_Buffer As DirectSoundSecondaryBuffer8
Static play_fire As Boolean

    If CurMap > 0 Then
        If bTecho Then 'En los interiores el sonido es más suave :)
            If mEffectsVolumeAmbient <> INTERIOR_VOLUME Then
                Call Ambient_Volume_Set(INTERIOR_VOLUME)
                mEffectsVolumeAmbient = INTERIOR_VOLUME
            End If
        Else
            If mEffectsVolumeAmbient <> EXTERIOR_VOLUME Then
                Call Ambient_Volume_Set(EXTERIOR_VOLUME)
                mEffectsVolumeAmbient = EXTERIOR_VOLUME
            End If
                                
            If hay_fogata_viewport Then
                If Not play_fire Then
                    play_fire = Sound_Play(SND_FUEGO, True, Calculate_Volume(Engine.fogata_pos.x, Engine.fogata_pos.Y), Calculate_Pan(Engine.fogata_pos.x, Engine.fogata_pos.Y))
                ElseIf user_moved Then
                    Call Buffers.CambiarVolumen(SND_FUEGO, Calculate_Volume(Engine.fogata_pos.x, Engine.fogata_pos.Y))
                    Call Buffers.CambiarPan(SND_FUEGO, Calculate_Pan(Engine.fogata_pos.x, Engine.fogata_pos.Y))
                End If
            ElseIf play_fire Then
                play_fire = Not Sound_Stop(SND_FUEGO)
            End If
        End If
    End If
    
    
user_moved = False

End Function

Public Function Sound_Load(ByVal file_num As Integer) As Boolean
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 7/16/2005
'**************************************************************
    
    If Buffers.CargarBuffer(file_num) Then
        Sound_Load = True
    End If

End Function

Public Function Calculate_Pan(ByVal map_x As Integer, ByVal map_y As Integer) As Long
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 7/16/2005
'**************************************************************
    
    Dim total_distance As Integer, position_sgn As Integer, curr_x As Integer, curr_y As Integer
    
    If Char_Pos_Get(UserCharIndex, curr_x, curr_y) Then
        total_distance = Sqr(((curr_x - map_y) ^ 2 + (curr_y - map_y) ^ 2))
        If mInvert_Sound = False Then
            If map_x < curr_x Then
                position_sgn = -1
            Else
                position_sgn = 1
            End If
        Else
            If map_x > curr_x Then
                position_sgn = -1
            Else
                position_sgn = 1
            End If
        End If
        
        If (total_distance = 0) Or (map_x = curr_x) Then
            Calculate_Pan = 0
        ElseIf total_distance < 9 Then
            Calculate_Pan = position_sgn * (total_distance * 1000)
        Else
            Calculate_Pan = position_sgn * 9000
        End If
    End If

End Function

Public Function Calculate_Volume(ByVal map_x As Integer, ByVal map_y As Integer) As Long
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 7/16/2005
'**************************************************************
    
    Dim total_distance As Integer, curr_x As Integer, curr_y As Integer
    
    If Char_Pos_Get(UserCharIndex, curr_x, curr_y) Then
        total_distance = Abs(Sqr(((map_y - curr_x) ^ 2 + (map_y - curr_y) ^ 2)))
        Debug.Print total_distance; map_y; curr_x; map_y; curr_y
        If (total_distance = 0) Then
            Calculate_Volume = mEffectsVolumeMax
        Else 'If total_distance < 9 Then
            Calculate_Volume = mEffectsVolumeMax - total_distance
        'Else
        '    Calculate_Volume = mEffectsVolumeMax - 450
        End If
    End If

    If Calculate_Volume < -4000 Then Calculate_Volume = -4000

End Function

Public Sub BorraTimer()
If Buffers Is Nothing Then Exit Sub
Buffers.BorraTimerProc
End Sub

