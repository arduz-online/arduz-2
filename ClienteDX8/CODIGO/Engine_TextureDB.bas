Attribute VB_Name = "Engine_TextureDB"
' ESTE ARCHIVO ESTA COMPARTIDO POR TODOS LOS PROGRAMAS.

Option Explicit

Private Type TEXT_DB_ENTRY
    FileName        As Integer
    UltimoAcceso    As Long
    texture         As Direct3DTexture8
    Alto            As Single
    Ancho           As Single
    size            As Long
    png             As Byte
End Type

Private Tabla() As Integer
Private TablaMax As Integer

Private mGraficos() As TEXT_DB_ENTRY

Private mMaxEntries As Integer
Private mCantidadGraficos As Integer
Private mFreeMemoryBytes As Long

Private Declare Function GetTickCount Lib "kernel32" () As Long

Private Enum TEX_FLAGS
    TEX_NOUSE_MIPMAPS = 1
End Enum

Public pakGraficos As clsPak

Public Sub DeInit_TextureDB()
On Error Resume Next
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    
    Erase mGraficos
    
End Sub

Public Sub ReloadAllTextures()
    ReDim Tabla(TablaMax)
End Sub

Public Sub GetTexture(ByVal FileName As Integer, Optional ByVal stage As Long = 0)
Dim Index As Integer
    If last_texture <> FileName Then
        If FileName = 0 Then
            D3DDevice.SetTexture stage, Nothing
            last_texture = 0
            Exit Sub
        End If

        If TablaMax < FileName Then
            TablaMax = FileName + 128
            ReDim Preserve Tabla(TablaMax)
        End If

        If Tabla(FileName) <> 0 Then
            With mGraficos(Tabla(FileName))
                .UltimoAcceso = GetTickCount
                D3DDevice.SetTexture stage, .texture
                last_texture = FileName
            End With
        Else

        #Const MEM_VIDEO = False
        #If MEM_VIDEO = True Then
            If mMaxEntries = mCantidadGraficos Or mFreeMemoryBytes < 4000000 Then '~4kb
        #Else
            If mMaxEntries = mCantidadGraficos Then
        #End If
                'Sacamos el que hace más que no usamos, y utilizamos el slot
                Index = CrearGrafico(FileName, BorraMenosUsado())
                D3DDevice.SetTexture stage, mGraficos(Index).texture
                last_texture = FileName
            Else
                'Agrego una textura nueva a la lista
                Index = CrearGrafico(FileName)
                D3DDevice.SetTexture stage, mGraficos(Index).texture
                last_texture = FileName
            End If
            Tabla(FileName) = Index
        End If

    End If

End Sub

Public Sub PreLoadTexture(ByVal FileName As Integer)
Dim Index As Integer
If FileName > 0 Then
    If TablaMax < FileName Then
        ReDim Preserve Tabla(FileName)
    End If
    
    If Tabla(FileName) = 0 Then
        If mMaxEntries = mCantidadGraficos Then
            'Sacamos el que hace más que no usamos, y utilizamos el slot
            Index = CrearGrafico(FileName, BorraMenosUsado())
        Else
            'Agrego una textura nueva a la lista
            Index = CrearGrafico(FileName)
        End If
        Tabla(FileName) = Index
    End If
End If
End Sub

Public Sub GetTextureDimension(ByVal FileName As Integer, ByRef h As Single, ByRef w As Single)
    Dim Index As Integer
    Index = Tabla(FileName)
    If Index Then
        h = mGraficos(Index).Alto
        w = mGraficos(Index).Ancho
    End If
End Sub

Public Function GetTexturePNG(ByVal FileName As Integer) As Byte
    Dim Index As Integer
    Index = Tabla(FileName)
    If Index Then
        GetTexturePNG = mGraficos(Index).png
    End If
End Function

Public Function Init_TextureDB(ByVal MaxMemory As Long, ByVal MaxEntries As Long, path_Pack As String) As Boolean
    mMaxEntries = MaxEntries

    If mMaxEntries < 1 Then 'por lo menos 1 gráfico
        Exit Function
    End If

    mCantidadGraficos = 0

    mFreeMemoryBytes = MaxMemory

    Init_TextureDB = True

    'mFreeMemoryBytes = D3DDevice.GetAvailableTextureMem(D3DPOOL_MANAGED)

    ReDim Tabla(32767)
    TablaMax = 32767

    Set pakGraficos = New clsPak
    pakGraficos.Cargar path_Pack
End Function

Public Sub Borrar_TextureDB()
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    ReDim Tabla(3000)
    TablaMax = 3000
    ReDim mGraficos(0)
    mCantidadGraficos = 0
End Sub

Private Function CrearGrafico(ByVal Archivo As Integer, Optional ByVal Index As Integer = -1) As Integer
'On Error GoTo ErrHandler
    Dim surface_desc As D3DSURFACE_DESC
    Dim srcData() As Byte
    Dim header As Long
    Dim fmt1 As CONST_D3DFORMAT, fmt2 As CONST_D3DFORMAT
    Dim bUseMip As Long
    
    If Index < 0 Then
        Index = mCantidadGraficos + 1
        ReDim Preserve mGraficos(1 To Index)
    End If
    Err.Clear
    
    If Index = 0 Then Index = mCantidadGraficos
    
    With mGraficos(Index)
        .FileName = Archivo
        .UltimoAcceso = GetTickCount
        
    On Local Error Resume Next
        Dim IH As INFOHEADER

        If pakGraficos.IH_Get(Archivo, IH) And pakGraficos.Leer(Archivo, srcData(), rGrh) Then
            .png = (IH.file_type = eTiposRecursos.rPng)
            
'            Debug.Assert .complemento_1 = 0
            DXCopyMemory header, srcData(0), 4
            
            If header = &H20534444 Then 'DDS magic header
                fmt1 = D3DFMT_UNKNOWN
                fmt2 = D3DFMT_A8R8G8B8
            Else
                fmt1 = D3DFMT_A8R8G8B8
                fmt2 = D3DFMT_UNKNOWN
            End If
            
            If IH.Flags And TEX_NOUSE_MIPMAPS Then
                bUseMip = 0
            Else
                bUseMip = 1
            End If
            
            Set .texture = D3DX.CreateTextureFromFileInMemoryEx(D3DDevice, srcData(0), UBound(srcData) + 1, _
                    D3DX_DEFAULT, D3DX_DEFAULT, bUseMip, 0, fmt1, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                    D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
                    
            If .texture Is Nothing Then
                Err.Clear
                Set .texture = D3DX.CreateTextureFromFileInMemoryEx(D3DDevice, srcData(0), UBound(srcData) + 1, _
                    D3DX_DEFAULT, D3DX_DEFAULT, bUseMip, 0, fmt2, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                    D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
            End If
            Erase srcData
            
            .texture.GetLevelDesc 0, surface_desc
            
        Else
            Set .texture = Nothing
        End If
        
    On Local Error GoTo 0
    
        If Err.Number Or .texture Is Nothing Then
            LogError "A5.0 Error en carga de gráficos[" & Archivo & "]. - " & D3DX.GetErrorString(Err.Number)
            Set .texture = Nothing
        End If
        
        .Ancho = surface_desc.Width
        .Alto = surface_desc.height
        .size = surface_desc.size
            
        mFreeMemoryBytes = D3DDevice.GetAvailableTextureMem(D3DPOOL_MANAGED) 'mFreeMemoryBytes - surface_desc.size
    End With
    
    mCantidadGraficos = mCantidadGraficos + 1
    
    CrearGrafico = Index
Exit Function
ErrHandler:

LogError "A5.0 Error en carga de gráficos.  - " & D3DX.GetErrorString(Err.Number)


End Function

Private Function BorraMenosUsado() As Integer
    Dim Valor As Long
    Dim i As Long
    'Inicializamos todo
    Valor = GetTickCount() 'mGraficos(1).UltimoAcceso
    BorraMenosUsado = 1
    'Buscamos cual es el que lleva más tiempo sin ser utilizado
    For i = 1 To mCantidadGraficos
        If mGraficos(i).UltimoAcceso < Valor Then
            Valor = mGraficos(i).UltimoAcceso
            BorraMenosUsado = i
        End If
    Next i
    'Disminuimos el contador
    mCantidadGraficos = mCantidadGraficos - 1
    'Borramos la texture
    
    Set mGraficos(BorraMenosUsado).texture = Nothing
    Tabla(mGraficos(BorraMenosUsado).FileName) = 0
    mGraficos(BorraMenosUsado).Alto = 0
    mGraficos(BorraMenosUsado).Ancho = 0
    mFreeMemoryBytes = mFreeMemoryBytes + mGraficos(BorraMenosUsado).size
    mGraficos(BorraMenosUsado).size = 0
End Function

Public Sub BorrarTexturaDeMemoria(ByVal numero As Integer)
If numero <= TablaMax Then
    Tabla(numero) = 0
End If
End Sub


Public Property Get MaxEntries() As Integer
    MaxEntries = mMaxEntries
End Property

Public Property Let MaxEntries(ByVal vNewValue As Integer)
    mMaxEntries = vNewValue
End Property

Public Property Get CantidadGraficos() As Integer
    CantidadGraficos = mCantidadGraficos
End Property





