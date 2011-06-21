VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsConvertidoraMapas"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Type WorldPos
    Map As Integer
    x As Integer
    y As Integer
End Type

Private Type obj
    OBJIndex As Integer
    Amount As Integer
End Type

Private Type pMapBlock
    Graphic(1 To 4) As Integer
    CharIndex As Integer
    ObjGrh As Integer
    
    NPCIndex As Integer
    OBJInfo As obj
    TileExit As WorldPos
    Blocked As Byte
    
    Trigger As Integer
End Type

Private DatosMapa(1 To MapSize, 1 To MapSize) As pMapBlock ' Mapa

Private Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long

Private Const header_s As String * 16 = "9754813754896546"

Private Type tCabecera 'Cabecera de los con
    desc As String * 255
    CRC As Long
    MagicWord As Long
End Type

Private MiCabecera As tCabecera

Private Declare Function writeprivateprofilestring Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpString As String, ByVal lpFileName As String) As Long
Private Declare Function getprivateprofilestring Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Sub ZeroMemory Lib "kernel32" Alias "RtlZeroMemory" (ByRef dest As Any, ByVal numbytes As Long)

Public NombreMapa As String
Public ClaveSeguridad As Long

Public Sub LoadMap(ByRef Path As String, ByVal Map As Integer) 'ByVal map As Integer)
    Dim y As Long
    Dim x As Long
    Dim TempInt As Integer, theta As Single, range As Byte
    Dim tmpp%, tcl&, lB&, lG&, lR&, j!
    Dim ByFlags As Byte
    Dim handle  As Integer, FreeFileInf As Integer
    handle = FreeFile()
    
    ZeroMemory DatosMapa(1, 1), Len(DatosMapa(1, 1)) * 100& * 100&
    
    NombreMapa = GetVar(Path & "Mapa" & Map & ".dat", "Mapa" & Map, "Name")
    
    Open Path & "Mapa" & Map & ".map" For Binary As handle
    
    Seek handle, 1

    'map Header
    Get handle, , TempInt
    Get handle, , MiCabecera
    
    Get handle, , TempInt
    Get handle, , TempInt
    Get handle, , TempInt
    Get handle, , TempInt


    FreeFileInf = FreeFile
    
    'inf
    Open Path & "Mapa" & Map & ".inf" For Binary As #FreeFileInf
    Seek FreeFileInf, 1
    
    Get #FreeFileInf, , TempInt
    Get #FreeFileInf, , TempInt
    Get #FreeFileInf, , TempInt
    Get #FreeFileInf, , TempInt
    Get #FreeFileInf, , TempInt
    
    'Load arrays
    For y = 1 To MapSize
        For x = 1 To MapSize
            Get handle, , ByFlags
            
            DatosMapa(x, y).Blocked = (ByFlags And 1)
            
            Get handle, , DatosMapa(x, y).Graphic(1)
        
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get handle, , DatosMapa(x, y).Graphic(2)
            Else
                DatosMapa(x, y).Graphic(2) = 0
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get handle, , DatosMapa(x, y).Graphic(3)
            Else
                DatosMapa(x, y).Graphic(3) = 0
            End If
            
            'Layer 4 used?
            If ByFlags And 8 Then
                Get handle, , DatosMapa(x, y).Graphic(4)
            Else
                DatosMapa(x, y).Graphic(4) = 0
            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get handle, , DatosMapa(x, y).Trigger
            Else
                DatosMapa(x, y).Trigger = 0
            End If
            
            Get FreeFileInf, , ByFlags
            
            If ByFlags And 1 Then
                Get FreeFileInf, , DatosMapa(x, y).TileExit.Map
                Get FreeFileInf, , DatosMapa(x, y).TileExit.x
                Get FreeFileInf, , DatosMapa(x, y).TileExit.y
            End If
            
            If ByFlags And 2 Then
                'Get and make NPC
                Get FreeFileInf, , DatosMapa(x, y).NPCIndex
            End If
            
            If ByFlags And 4 Then
                'Get and make Object
                Get FreeFileInf, , DatosMapa(x, y).OBJInfo.OBJIndex
                Get FreeFileInf, , DatosMapa(x, y).OBJInfo.Amount
            End If
        Next x
    Next y

    ClaveSeguridad = CLng(Rnd * &HFFFFFFFF + val("ESTE_NUMERO_ES_EL_CHECKEO_DE_HACKING_DE_LA_WEB"))

    Close handle
    Close FreeFileInf
End Sub

Private Function encode_decode_text(text As String, ByVal off As Integer, Optional ByVal cript As Byte, Optional ByVal Encode As Byte) As String
    Dim i As Integer, l As String
    If Encode Then off = 256 - off
    Dim ba() As Byte, bo() As Byte
    Dim lenn%
    ba = StrConv(text, vbFromUnicode)
    lenn = UBound(ba)
    ReDim bo(0 To lenn)
    For i = 0 To lenn
       bo(i) = ((ba(i) Xor cript) + off) Mod 256 Xor cript
    Next i
    encode_decode_text = StrConv(bo, vbUnicode)
End Function

Private Function GetVar(File As String, Main As String, var As String) As String
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************
Dim l As Integer
Dim Char As String
Dim sSpaces As String ' This will hold the input that the program will retrieve
Dim szReturn As String ' This will be the defaul value if the string is not found
szReturn = vbNullString
sSpaces = Space(5000) ' This tells the computer how long the longest string can be. If you want, you can change the number 75 to any number you wish
getprivateprofilestring Main, var, szReturn, sSpaces, Len(sSpaces), File
GetVar = RTrim(sSpaces)
GetVar = Left(GetVar, Len(GetVar) - 1)
End Function

Public Function Guardar(ByVal Path As String) As Boolean
'On Error GoTo ErrorSave
Dim FreeFileMap As Long
Dim smap As Long
Dim loopc As Long
Dim TempInt As Integer
Dim y As Long
Dim x As Long
Dim ByFlags As Integer
Dim nmap As String * 32
Dim lona&
Dim crca&
Dim tbt As Byte
'Open .map file

If FileExist(Path, vbNormal) = True Then Kill Path

FreeFileMap = FreeFile
Open Path For Binary As FreeFileMap

    
    If Len(NombreMapa) = 0 Then
        MsgBox "El mapa debe tener un nombre."
        Exit Function
    End If
    
    Dim cript As Byte
    cript = Int(Rnd * 255)
    nmap = encode_decode_text(NombreMapa, 108, cript Xor 108, 1)
    Debug.Print Len(nmap)
    
    Seek FreeFileMap, 1
    lona = Loc(FreeFileMap)
    Put FreeFileMap, , header_s
    Put FreeFileMap, , cript
    Put FreeFileMap, , nmap
    
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    
    Debug.Print "CRC-OFFSET:"; Loc(FreeFileMap)
    
    Put FreeFileMap, , CLng(val("CRCCROTO"))
    Put FreeFileMap, , CLng(cript)
    
    Put FreeFileMap, , ClaveSeguridad
    
    
    'Write .map file
    For y = 1 To MapSize
        For x = 1 To MapSize
                ByFlags = 0
                
                If DatosMapa(x, y).Blocked = 1 Then ByFlags = ByFlags Or 1
                If DatosMapa(x, y).Graphic(2) Then ByFlags = ByFlags Or 2
                If DatosMapa(x, y).Graphic(3) Then ByFlags = ByFlags Or 4
                If DatosMapa(x, y).Graphic(4) Then ByFlags = ByFlags Or 8
                If DatosMapa(x, y).Trigger Then ByFlags = ByFlags Or 16
                
                'If DatosMapa(x, y).Particles_groups(0) <> 0 Or _
                    DatosMapa(x, y).Particles_groups(1) <> 0 Or _
                    DatosMapa(x, y).Particles_groups(2) <> 0 Then ByFlags = ByFlags Or 32
                'If DatosMapa(x, y).alt >= 1 Then ByFlags = ByFlags Or 64
                'If DatosMapa(x, y).flare Then ByFlags = ByFlags Or 128 LIBRE
                
                If DatosMapa(x, y).TileExit.Map Then ByFlags = ByFlags Or 256
'                If DatosMapa(x, y).NPCIndex Then ByFlags = ByFlags Or 512
                If DatosMapa(x, y).OBJInfo.OBJIndex Then ByFlags = ByFlags Or 1024
                If DatosMapa(x, y).Graphic(1) Then ByFlags = ByFlags Or 2048
                
                
                
                Put FreeFileMap, , ByFlags
                
                Put FreeFileMap, , -1&
                
                For loopc = 1 To 4
                    If DatosMapa(x, y).Graphic(loopc) Then _
                        Put FreeFileMap, , DatosMapa(x, y).Graphic(loopc)
                Next loopc

                If DatosMapa(x, y).Trigger Then _
                    Put FreeFileMap, , DatosMapa(x, y).Trigger
                
                If DatosMapa(x, y).TileExit.Map Then
                    Put FreeFileMap, , DatosMapa(x, y).TileExit.Map
                    Put FreeFileMap, , DatosMapa(x, y).TileExit.x
                    Put FreeFileMap, , DatosMapa(x, y).TileExit.y
                End If
                
'                If DatosMapa(x, y).NPCIndex Then
'                    Put FreeFileMap, , CInt(DatosMapa(x, y).NPCIndex)
'                End If
                
                If DatosMapa(x, y).OBJInfo.OBJIndex Then
                    Put FreeFileMap, , DatosMapa(x, y).OBJInfo.OBJIndex
                    Put FreeFileMap, , DatosMapa(x, y).OBJInfo.Amount
                End If
        Next x
    Next y
    
    'Close .map file
    Close FreeFileMap
    Close smap
Exit Function
ErrorSave:
MsgBox "EERROR"
End Function



