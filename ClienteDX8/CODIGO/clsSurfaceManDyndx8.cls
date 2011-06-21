VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsSurfaceManDyn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Option Explicit

Private Type TEXT_DB_ENTRY
    filename As Integer
    UltimoAcceso As Long
    texture As Direct3DTexture8
    Alto As Single
    Ancho As Single
    size As Long
    png As Byte
End Type

Private Tabla() As Integer
Private TablaMax As Integer

Private mGraficos() As TEXT_DB_ENTRY
Private mD3D As D3DX8
Private device As Direct3DDevice8

Private mMaxEntries As Integer
Private mCantidadGraficos As Integer
Private mFreeMemoryBytes As Long

Private GrhPath As String

Private Declare Function GetTickCount Lib "kernel32" () As Long


Private Enum TEX_FLAGS
    TEX_NOUSE_MIPMAPS = 1
End Enum

Private Sub Class_Initialize()
ReDim Tabla(32767)
TablaMax = 32767
End Sub

Private Sub Class_Terminate()
On Error Resume Next
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    
    Erase mGraficos
    
End Sub

Public Property Let path(ByVal inString As String)
    GrhPath = inString
End Property

Public Sub GetTexture(ByVal filename As Integer, Optional ByVal stage As Long = 0)

    If last_texture <> filename Then
    If filename = 0 Then
        D3DDevice.SetTexture stage, Nothing
        last_texture = 0
        Exit Sub
    End If
    Dim Index As Integer
    If TablaMax >= filename Then
        If Tabla(filename) <> 0 Then
            With mGraficos(Tabla(filename))
                .UltimoAcceso = GetTickCount
                D3DDevice.SetTexture stage, .texture
                last_texture = filename
            End With
        Else
            If mMaxEntries = mCantidadGraficos Then
                'Sacamos el que hace más que no usamos, y utilizamos el slot
                Index = CrearGrafico(filename, BorraMenosUsado())
                D3DDevice.SetTexture stage, mGraficos(Index).texture
                last_texture = filename
            Else
                'Agrego una textura nueva a la lista
                Index = CrearGrafico(filename)
                D3DDevice.SetTexture stage, mGraficos(Index).texture
                last_texture = filename
            End If
            Tabla(filename) = Index
        End If
    Else
        ReDim Preserve Tabla(filename)
        TablaMax = filename
        If mMaxEntries = mCantidadGraficos Then
            'Sacamos el que hace más que no usamos, y utilizamos el slot
            Index = CrearGrafico(filename, BorraMenosUsado())
            D3DDevice.SetTexture stage, mGraficos(Index).texture
            last_texture = filename
        Else
            'Agrego una textura nueva a la lista
            Index = CrearGrafico(filename)
            D3DDevice.SetTexture stage, mGraficos(Index).texture
            last_texture = filename
        End If
        Tabla(filename) = Index
    End If
End If
End Sub

Public Sub GetTextureDimension(ByVal filename As Integer, ByRef H As Single, ByRef W As Single)
    Dim Index As Integer
    Index = Tabla(filename)
    If Index Then
        H = mGraficos(Index).Alto
        W = mGraficos(Index).Ancho
    End If
End Sub

Public Function GetTexturePNG(ByVal filename As Integer) As Byte
    Dim Index As Integer
    Index = Tabla(filename)
    If Index Then
        GetTexturePNG = mGraficos(Index).png
    End If
End Function

Public Function Init(ByRef D3D8 As D3DX8, ByRef d3d_device As Direct3DDevice8, ByVal MaxMemory As Long, ByVal MaxEntries As Long) As Boolean
    mMaxEntries = MaxEntries
    
    If mMaxEntries < 1 Then 'por lo menos 1 gráfico
        Exit Function
    End If
    
    mCantidadGraficos = 0
    
    'Seteamos el objeto
    Set mD3D = D3D8
    Set device = d3d_device
    mFreeMemoryBytes = MaxMemory
    
    Init = True
End Function

Public Sub BorrarTodo()
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    ReDim Tabla(3000)
    TablaMax = 3000
    ReDim mGraficos(0)
    mCantidadGraficos = 0
End Sub

Public Function Borrar(ByVal filename As Integer) As Integer
    Dim indice As Long
    
    'Obtenemos el ìndice
    indice = Tabla(filename)
    If indice = 0 Then Exit Function
    Tabla(filename) = 0
    'Lo eliminamos
    With mGraficos(indice)
        Set .texture = Nothing
        .Alto = 0
        .Ancho = 0
        mFreeMemoryBytes = mFreeMemoryBytes + .size
        .size = 0
    End With
    
    'Actualizamos el número de gráficos
    mCantidadGraficos = mCantidadGraficos - 1
    
    'Movemos para atrás el resto de la lista
    For indice = indice To mCantidadGraficos
        mGraficos(indice) = mGraficos(indice + 1)
    Next indice
    
    'Redimencionamos la lista
    ReDim Preserve mGraficos(1 To mCantidadGraficos)
End Function


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
        .filename = Archivo
        .UltimoAcceso = GetTickCount
        
    On Local Error Resume Next
        
        If modZLib.Bin_Resource_Get(Archivo, srcData(), rGrh) Then
            'modZLib.Bin_Resource_Get app.path & "\Datos\grhdata\", CStr(Archivo) & ".MZR", srcData()
            .png = (modZLib.last_file_ext.file_type = eTiposRecursos.rPng)
            DXCopyMemory header, srcData(0), 4
            
            If header = &H20534444 Then 'DDS magic header
                fmt1 = D3DFMT_UNKNOWN
                fmt2 = D3DFMT_A8R8G8B8
            Else
                fmt1 = D3DFMT_A8R8G8B8
                fmt2 = D3DFMT_UNKNOWN
            End If
            
            If last_file_ext.Flags And TEX_NOUSE_MIPMAPS Then
                bUseMip = 0
            Else
                bUseMip = 1
            End If
            
            Set .texture = mD3D.CreateTextureFromFileInMemoryEx(device, srcData(0), UBound(srcData) + 1, _
                    D3DX_DEFAULT, D3DX_DEFAULT, bUseMip, 0, fmt1, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                    D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
                    
            If .texture Is Nothing Then
                Err.Clear
                Set .texture = mD3D.CreateTextureFromFileInMemoryEx(device, srcData(0), UBound(srcData) + 1, _
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
            LogError "A5.0 Error en carga de gráficos[" & Archivo & "]. - Resultado de decode: " & CStr(modZLib.Extraidox) & " - " & D3DX.GetErrorString(Err.Number)
            Set .texture = Nothing
        End If
        
        .Ancho = surface_desc.Width
        .Alto = surface_desc.height
        .size = surface_desc.size
            
        mFreeMemoryBytes = mFreeMemoryBytes - surface_desc.size
    End With
    
    Debug.Assert Index
    
    mCantidadGraficos = mCantidadGraficos + 1
    
    CrearGrafico = Index
Exit Function
ErrHandler:

LogError "A5.0 Error en carga de gráficos. - Resultado de decode: " & CStr(modZLib.Extraidox) & " - " & D3DX.GetErrorString(Err.Number)


End Function

Private Function BorraMenosUsado() As Integer
    Dim Valor As Long
    Dim i As Long
    'Inicializamos todo
    Valor = mGraficos(1).UltimoAcceso
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
    Tabla(mGraficos(BorraMenosUsado).filename) = 0
    mGraficos(BorraMenosUsado).Alto = 0
    mGraficos(BorraMenosUsado).Ancho = 0
    mFreeMemoryBytes = mFreeMemoryBytes + mGraficos(BorraMenosUsado).size
    mGraficos(BorraMenosUsado).size = 0
End Function

Public Property Get MaxEntries() As Integer
    MaxEntries = mMaxEntries
End Property

Public Property Let MaxEntries(ByVal vNewValue As Integer)
    mMaxEntries = vNewValue
End Property

Public Property Get CantidadGraficos() As Integer
    CantidadGraficos = mCantidadGraficos
End Property



