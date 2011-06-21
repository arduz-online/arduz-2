Attribute VB_Name = "modFiFo"
Option Explicit








Public Type RGBCOLOR
    r As Byte
    g As Byte
    b As Byte
End Type


Function EsAdmin(ByVal name As String) As Boolean

End Function

Function EsDios(ByVal name As String) As Boolean

End Function

Function EsSemiDios(ByVal name As String) As Boolean

End Function

Function EsConsejero(ByVal name As String) As Boolean

End Function

Function EsRolesMaster(ByVal name As String) As Boolean

End Function


Public Function TxtDimension(ByVal name As String) As Long
Dim N As Integer, cad As String, Tam As Long
N = FreeFile(1)
Open name For Input As #N
Tam = 0
Do While Not EOF(N)
    Tam = Tam + 1
    Line Input #N, cad
Loop
Close N
TxtDimension = Tam
End Function

Public Sub CargarForbidenWords()

'ReDim ForbidenNames(1 To TxtDimension(DatPath & "NombresInvalidos.txt"))
'Dim N As Integer, i As Integer
'N = FreeFile(1)
'Open DatPath & "NombresInvalidos.txt" For Input As #N

'For i = 1 To UBound(ForbidenNames)
'Line Input #N, ForbidenNames(i)
'Next i

'Close N

End Sub

Public Sub CargarHechizos()
On Error GoTo ErrHandler

If frmMain.Visible Then frmMain.txStatus.Caption = "Cargando Hechizos."

Dim Hechizo As Integer
Dim Leer As New clsIniReader



'#If Debuging = 0 Then
'    Dim tmpstr As String
'    tmpstr = modZLib.Resource_Get_Raw(DatPath, "Hechizos.MZR")
'    Call Leer.Initialize_raw(tmpstr)
'    tmpstr = vbNullString
'#Else
'    Call Leer.Initialize(DatPath & "\DatosServer\Hechizos.dat")
'#End If
Call Leer.Initialize(DatPath & "\DatosServer\Hechizos.dat")
'obtiene el numero de hechizos
NumeroHechizos = val(Leer.GetValue("INIT", "NumeroHechizos"))

ReDim Hechizos(1 To NumeroHechizos) As tHechizo

'frmCargando.cargar.min = 0
'frmCargando.cargar.max = NumeroHechizos
'frmCargando.cargar.value = 0

'Llena la lista
For Hechizo = 1 To NumeroHechizos

    Hechizos(Hechizo).nombre = Leer.GetValue("Hechizo" & Hechizo, "Nombre")
    Hechizos(Hechizo).desc = Leer.GetValue("Hechizo" & Hechizo, "Desc")
    Hechizos(Hechizo).PalabrasMagicas = Leer.GetValue("Hechizo" & Hechizo, "PalabrasMagicas")
    
    Hechizos(Hechizo).HechizeroMsg = Leer.GetValue("Hechizo" & Hechizo, "HechizeroMsg")
    Hechizos(Hechizo).TargetMsg = Leer.GetValue("Hechizo" & Hechizo, "TargetMsg")
    Hechizos(Hechizo).PropioMsg = Leer.GetValue("Hechizo" & Hechizo, "PropioMsg")
    
    Hechizos(Hechizo).tipo = val(Leer.GetValue("Hechizo" & Hechizo, "Tipo"))
    Hechizos(Hechizo).WAV = val(Leer.GetValue("Hechizo" & Hechizo, "WAV"))
    Hechizos(Hechizo).FXgrh = val(Leer.GetValue("Hechizo" & Hechizo, "Fxgrh"))
    
    Hechizos(Hechizo).loops = val(Leer.GetValue("Hechizo" & Hechizo, "Loops"))
    
'Hechizos(Hechizo).Resis = val(Leer.GetValue("Hechizo" & Hechizo, "Resis"))
    
    Hechizos(Hechizo).SubeHP = val(Leer.GetValue("Hechizo" & Hechizo, "SubeHP"))
    Hechizos(Hechizo).MinHP = val(Leer.GetValue("Hechizo" & Hechizo, "MinHP"))
    Hechizos(Hechizo).MaxHP = val(Leer.GetValue("Hechizo" & Hechizo, "MaxHP"))
    
    Hechizos(Hechizo).SubeMana = val(Leer.GetValue("Hechizo" & Hechizo, "SubeMana"))
    Hechizos(Hechizo).MiMana = val(Leer.GetValue("Hechizo" & Hechizo, "MinMana"))
    Hechizos(Hechizo).MaMana = val(Leer.GetValue("Hechizo" & Hechizo, "MaxMana"))
    
    Hechizos(Hechizo).SubeSta = val(Leer.GetValue("Hechizo" & Hechizo, "SubeSta"))
    Hechizos(Hechizo).MinSta = val(Leer.GetValue("Hechizo" & Hechizo, "MinSta"))
    Hechizos(Hechizo).MaxSta = val(Leer.GetValue("Hechizo" & Hechizo, "MaxSta"))
    
    Hechizos(Hechizo).SubeHam = val(Leer.GetValue("Hechizo" & Hechizo, "SubeHam"))
    Hechizos(Hechizo).MinHam = val(Leer.GetValue("Hechizo" & Hechizo, "MinHam"))
    Hechizos(Hechizo).MaxHam = val(Leer.GetValue("Hechizo" & Hechizo, "MaxHam"))
    
    Hechizos(Hechizo).SubeSed = val(Leer.GetValue("Hechizo" & Hechizo, "SubeSed"))
    Hechizos(Hechizo).MinSed = val(Leer.GetValue("Hechizo" & Hechizo, "MinSed"))
    Hechizos(Hechizo).MaxSed = val(Leer.GetValue("Hechizo" & Hechizo, "MaxSed"))
    
    Hechizos(Hechizo).SubeAgilidad = val(Leer.GetValue("Hechizo" & Hechizo, "SubeAG"))
    Hechizos(Hechizo).MinAgilidad = val(Leer.GetValue("Hechizo" & Hechizo, "MinAG"))
    Hechizos(Hechizo).MaxAgilidad = val(Leer.GetValue("Hechizo" & Hechizo, "MaxAG"))
    
    Hechizos(Hechizo).SubeFuerza = val(Leer.GetValue("Hechizo" & Hechizo, "SubeFU"))
    Hechizos(Hechizo).MinFuerza = val(Leer.GetValue("Hechizo" & Hechizo, "MinFU"))
    Hechizos(Hechizo).MaxFuerza = val(Leer.GetValue("Hechizo" & Hechizo, "MaxFU"))
    
    Hechizos(Hechizo).SubeCarisma = val(Leer.GetValue("Hechizo" & Hechizo, "SubeCA"))
    Hechizos(Hechizo).MinCarisma = val(Leer.GetValue("Hechizo" & Hechizo, "MinCA"))
    Hechizos(Hechizo).MaxCarisma = val(Leer.GetValue("Hechizo" & Hechizo, "MaxCA"))
    
    
    Hechizos(Hechizo).Invisibilidad = val(Leer.GetValue("Hechizo" & Hechizo, "Invisibilidad"))
    Hechizos(Hechizo).Paraliza = val(Leer.GetValue("Hechizo" & Hechizo, "Paraliza"))
    Hechizos(Hechizo).Inmoviliza = val(Leer.GetValue("Hechizo" & Hechizo, "Inmoviliza"))
    Hechizos(Hechizo).RemoverParalisis = val(Leer.GetValue("Hechizo" & Hechizo, "RemoverParalisis"))
    Hechizos(Hechizo).RemoverEstupidez = val(Leer.GetValue("Hechizo" & Hechizo, "RemoverEstupidez"))
    Hechizos(Hechizo).RemueveInvisibilidadParcial = val(Leer.GetValue("Hechizo" & Hechizo, "RemueveInvisibilidadParcial"))
    
    
    Hechizos(Hechizo).CuraVeneno = val(Leer.GetValue("Hechizo" & Hechizo, "CuraVeneno"))
    Hechizos(Hechizo).Envenena = val(Leer.GetValue("Hechizo" & Hechizo, "Envenena"))
    Hechizos(Hechizo).Maldicion = val(Leer.GetValue("Hechizo" & Hechizo, "Maldicion"))
    Hechizos(Hechizo).RemoverMaldicion = val(Leer.GetValue("Hechizo" & Hechizo, "RemoverMaldicion"))
    Hechizos(Hechizo).Bendicion = val(Leer.GetValue("Hechizo" & Hechizo, "Bendicion"))
    Hechizos(Hechizo).Revivir = val(Leer.GetValue("Hechizo" & Hechizo, "Revivir"))
    
    Hechizos(Hechizo).Ceguera = val(Leer.GetValue("Hechizo" & Hechizo, "Ceguera"))
    Hechizos(Hechizo).Estupidez = val(Leer.GetValue("Hechizo" & Hechizo, "Estupidez"))
    
    Hechizos(Hechizo).Invoca = val(Leer.GetValue("Hechizo" & Hechizo, "Invoca"))
    Hechizos(Hechizo).NumNPC = val(Leer.GetValue("Hechizo" & Hechizo, "NumNpc"))
    Hechizos(Hechizo).Cant = val(Leer.GetValue("Hechizo" & Hechizo, "Cant"))
    Hechizos(Hechizo).Mimetiza = val(Leer.GetValue("hechizo" & Hechizo, "Mimetiza"))
    
    
'Hechizos(Hechizo).Materializa = val(Leer.GetValue("Hechizo" & Hechizo, "Materializa"))
'Hechizos(Hechizo).ItemIndex = val(Leer.GetValue("Hechizo" & Hechizo, "ItemIndex"))
    
    Hechizos(Hechizo).MinSkill = val(Leer.GetValue("Hechizo" & Hechizo, "MinSkill"))
    Hechizos(Hechizo).ManaRequerido = val(Leer.GetValue("Hechizo" & Hechizo, "ManaRequerido"))
    
    'Barrin 30/9/03
    Hechizos(Hechizo).StaRequerido = val(Leer.GetValue("Hechizo" & Hechizo, "StaRequerido"))
    
    Hechizos(Hechizo).Target = val(Leer.GetValue("Hechizo" & Hechizo, "Target"))
    'frmCargando.cargar.value = frmCargando.cargar.value + 1
    
    Hechizos(Hechizo).NeedStaff = val(Leer.GetValue("Hechizo" & Hechizo, "NeedStaff"))
    Hechizos(Hechizo).StaffAffected = CBool(val(Leer.GetValue("Hechizo" & Hechizo, "StaffAffected")))
    
Next Hechizo

Set Leer = Nothing
Exit Sub

ErrHandler:
 MsgBox "Error cargando hechizos.dat " & ERR.number & ": " & ERR.Description
 
End Sub

Public Sub GrabarMapa(ByVal map As Long, ByVal MAPFILE As String)
On Error Resume Next
    Dim FreeFileMap As Long
    Dim FreeFileInf As Long
    Dim Y As Long
    Dim X As Long
    Dim ByFlags As Byte
    Dim TempInt As Integer
    Dim loopc As Long
    
    If FileExist(MAPFILE & ".map", vbNormal) Then
        Kill MAPFILE & ".map"
    End If
    
    If FileExist(MAPFILE & ".inf", vbNormal) Then
        Kill MAPFILE & ".inf"
    End If
    
    'Open .map file
    FreeFileMap = FreeFile
    Open MAPFILE & ".Map" For Binary As FreeFileMap
    Seek FreeFileMap, 1
    
    'Open .inf file
    FreeFileInf = FreeFile
    Open MAPFILE & ".Inf" For Binary As FreeFileInf
    Seek FreeFileInf, 1
    'map Header
            
    Put FreeFileMap, , MapInfo(map).MapVersion
    Put FreeFileMap, , MiCabecera
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    Put FreeFileMap, , TempInt
    
    'inf Header
    Put FreeFileInf, , TempInt
    Put FreeFileInf, , TempInt
    Put FreeFileInf, , TempInt
    Put FreeFileInf, , TempInt
    Put FreeFileInf, , TempInt
    
    'Write .map file
    For Y = YMinMapSize To MapSize
        For X = XMinMapSize To MapSize
            
                ByFlags = 0
                
                If MapData(map, X, Y).Blocked Then ByFlags = ByFlags Or 1
                If MapData(map, X, Y).Graphic(2) Then ByFlags = ByFlags Or 2
                If MapData(map, X, Y).Graphic(3) Then ByFlags = ByFlags Or 4
                If MapData(map, X, Y).Graphic(4) Then ByFlags = ByFlags Or 8
                If MapData(map, X, Y).trigger Then ByFlags = ByFlags Or 16
                
                Put FreeFileMap, , ByFlags
                
                Put FreeFileMap, , MapData(map, X, Y).Graphic(1)
                
                For loopc = 2 To 4
                    If MapData(map, X, Y).Graphic(loopc) Then _
                        Put FreeFileMap, , MapData(map, X, Y).Graphic(loopc)
                Next loopc
                
                If MapData(map, X, Y).trigger Then _
                    Put FreeFileMap, , CInt(MapData(map, X, Y).trigger)
                
                '.inf file
                
                ByFlags = 0
                
                If MapData(map, X, Y).ObjInfo.ObjIndex > 0 Then
                   If ObjData(MapData(map, X, Y).ObjInfo.ObjIndex).OBJType = eOBJType.otFogata Then
                        MapData(map, X, Y).ObjInfo.ObjIndex = 0
                        MapData(map, X, Y).ObjInfo.Amount = 0
                    End If
                End If
    
                If MapData(map, X, Y).TileExit.map Then ByFlags = ByFlags Or 1
                If MapData(map, X, Y).NpcIndex Then ByFlags = ByFlags Or 2
                If MapData(map, X, Y).ObjInfo.ObjIndex Then ByFlags = ByFlags Or 4
                
                Put FreeFileInf, , ByFlags
                
                If MapData(map, X, Y).TileExit.map Then
                    Put FreeFileInf, , MapData(map, X, Y).TileExit.map
                    Put FreeFileInf, , MapData(map, X, Y).TileExit.X
                    Put FreeFileInf, , MapData(map, X, Y).TileExit.Y
                End If
                
                If MapData(map, X, Y).NpcIndex Then _
                    Put FreeFileInf, , Npclist(MapData(map, X, Y).NpcIndex).numero
                
                If MapData(map, X, Y).ObjInfo.ObjIndex Then
                    Put FreeFileInf, , MapData(map, X, Y).ObjInfo.ObjIndex
                    Put FreeFileInf, , MapData(map, X, Y).ObjInfo.Amount
                End If
            
            
        Next X
    Next Y
    
    'Close .map file
    Close FreeFileMap

    'Close .inf file
    Close FreeFileInf

    'write .dat file
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Name", MapInfo(map).name)
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "MusicNum", MapInfo(map).Music)
    Call WriteVar(MAPFILE & ".dat", "mapa" & map, "MagiaSinefecto", MapInfo(map).MagiaSinEfecto)
    Call WriteVar(MAPFILE & ".dat", "mapa" & map, "InviSinEfecto", MapInfo(map).InviSinEfecto)
    Call WriteVar(MAPFILE & ".dat", "mapa" & map, "ResuSinEfecto", MapInfo(map).ResuSinEfecto)
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "StartPos", MapInfo(map).StartPos.map & "-" & MapInfo(map).StartPos.X & "-" & MapInfo(map).StartPos.Y)
    

    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Terreno", MapInfo(map).Terreno)
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Zona", MapInfo(map).Zona)
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Restringir", MapInfo(map).Restringir)
    Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "BackUp", STR(MapInfo(map).BackUp))

    If MapInfo(map).Pk Then
        Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Pk", "0")
    Else
        Call WriteVar(MAPFILE & ".dat", "Mapa" & map, "Pk", "1")
    End If
End Sub
Sub LoadArmasHerreria()


End Sub

Sub LoadArmadurasHerreria()


End Sub


'[MODIFICADO] Captura la Bandera
Public Sub CargarBanderas()
Dim AppCLB As String

AppCLB = app.Path & "\Datos\DatosServer\Bandera.ini"
If GetVar(AppCLB, "INIT", "Mapas") = "" Then MsgBox "Error en la carga de Banderas": Exit Sub
ReDim Bandera(1 To GetVar(AppCLB, "INIT", "Mapas"), 1 To 2)
Dim i As Integer
For i = 1 To UBound(Bandera)
    Bandera(i, 1).map = GetVar(AppCLB, i, "PosMap1")
    Bandera(i, 1).X = GetVar(AppCLB, i, "PosX1")
    Bandera(i, 1).Y = GetVar(AppCLB, i, "PosY1")
    Bandera(i, 2).map = GetVar(AppCLB, i, "PosMap2")
    Bandera(i, 2).X = GetVar(AppCLB, i, "PosX2")
    Bandera(i, 2).Y = GetVar(AppCLB, i, "PosY2")
Next i
End Sub
'[/MODIFICADO] Captura la Bandera

Sub LoadOBJData()
'###################################################
'#               ATENCION PELIGRO                  #
'###################################################
'
'¡¡¡¡ NO USAR GetVar PARA LEER DESDE EL OBJ.DAT !!!!
'
'El que ose desafiar esta LEY, se las tendrá que ver
'con migo. Para leer desde el OBJ.DAT se deberá usar
'la nueva clase clsLeerInis.
'
'Alejo
'
'###################################################

'Call LogTarea("Sub LoadOBJData")

On Error GoTo ErrHandler

If frmMain.Visible Then frmMain.txStatus.Caption = "Cargando base de datos de los objetos."

'
'Carga la lista de objetos
'
Dim Object As Integer
Dim Leer As New clsIniReader

'    #If MENDUZ_PC = 1 Then
'        Dim tmpstr As String
'        tmpstr = modZLib.Resource_Get_Raw(DatPath, "OBJ.MZR")
'        Call Leer.Initialize_raw(tmpstr)
'        tmpstr = vbNullString
'    #Else
'        Call Leer.Initialize(DatPath & "OBJ.dat")
'    #End If
    Call Leer.Initialize(DatPath & "\DatosServer\OBJ.dat")
'obtiene el numero de obj
NumObjDatas = val(Leer.GetValue("INIT", "NumOBJs"))

'frmCargando.cargar.min = 0
'frmCargando.cargar.max = NumObjDatas
'frmCargando.cargar.value = 0


ReDim Preserve ObjData(1 To NumObjDatas) As ObjData
  
'Llena la lista
For Object = 1 To NumObjDatas
        
    ObjData(Object).name = Leer.GetValue("OBJ" & Object, "Name")
    
    'Pablo (ToxicWaste) Log de Objetos.
    ObjData(Object).Log = val(Leer.GetValue("OBJ" & Object, "Log"))
    ObjData(Object).NoLog = val(Leer.GetValue("OBJ" & Object, "NoLog"))
    '07/09/07
    
    ObjData(Object).GrhIndex = val(Leer.GetValue("OBJ" & Object, "GrhIndex"))
    If ObjData(Object).GrhIndex = 0 Then
        ObjData(Object).GrhIndex = ObjData(Object).GrhIndex
    End If
    
    ObjData(Object).OBJType = val(Leer.GetValue("OBJ" & Object, "ObjType"))
    
    ObjData(Object).Newbie = val(Leer.GetValue("OBJ" & Object, "Newbie"))
    
    Select Case ObjData(Object).OBJType
        Case eOBJType.otArmadura
            ObjData(Object).Real = val(Leer.GetValue("OBJ" & Object, "Real"))
            ObjData(Object).Caos = val(Leer.GetValue("OBJ" & Object, "Caos"))

        
        Case eOBJType.otESCUDO
            ObjData(Object).ShieldAnim = val(Leer.GetValue("OBJ" & Object, "Anim"))
            ObjData(Object).Real = val(Leer.GetValue("OBJ" & Object, "Real"))
            ObjData(Object).Caos = val(Leer.GetValue("OBJ" & Object, "Caos"))
        
        Case eOBJType.otCASCO
            ObjData(Object).CascoAnim = val(Leer.GetValue("OBJ" & Object, "Anim"))
            ObjData(Object).Real = val(Leer.GetValue("OBJ" & Object, "Real"))
            ObjData(Object).Caos = val(Leer.GetValue("OBJ" & Object, "Caos"))
        
        Case eOBJType.otWeapon
            ObjData(Object).WeaponAnim = val(Leer.GetValue("OBJ" & Object, "Anim"))
            ObjData(Object).Apuñala = val(Leer.GetValue("OBJ" & Object, "Apuñala"))
            ObjData(Object).Envenena = val(Leer.GetValue("OBJ" & Object, "Envenena"))
            ObjData(Object).MaxHit = val(Leer.GetValue("OBJ" & Object, "MaxHIT"))
            ObjData(Object).MinHit = val(Leer.GetValue("OBJ" & Object, "MinHIT"))
            ObjData(Object).proyectil = val(Leer.GetValue("OBJ" & Object, "Proyectil"))
            ObjData(Object).Municion = val(Leer.GetValue("OBJ" & Object, "Municiones"))
            ObjData(Object).StaffPower = val(Leer.GetValue("OBJ" & Object, "StaffPower"))
            ObjData(Object).StaffDamageBonus = val(Leer.GetValue("OBJ" & Object, "StaffDamageBonus"))
            ObjData(Object).Refuerzo = val(Leer.GetValue("OBJ" & Object, "Refuerzo"))
            
            ObjData(Object).Real = val(Leer.GetValue("OBJ" & Object, "Real"))
            ObjData(Object).Caos = val(Leer.GetValue("OBJ" & Object, "Caos"))
        
        Case eOBJType.otInstrumentos
            ObjData(Object).Snd1 = val(Leer.GetValue("OBJ" & Object, "SND1"))
            ObjData(Object).Snd2 = val(Leer.GetValue("OBJ" & Object, "SND2"))
            ObjData(Object).Snd3 = val(Leer.GetValue("OBJ" & Object, "SND3"))
            'Pablo (ToxicWaste)
            ObjData(Object).Real = val(Leer.GetValue("OBJ" & Object, "Real"))
            ObjData(Object).Caos = val(Leer.GetValue("OBJ" & Object, "Caos"))
        
        Case eOBJType.otMinerales
            ObjData(Object).MinSkill = val(Leer.GetValue("OBJ" & Object, "MinSkill"))
        
        Case eOBJType.otPuertas, eOBJType.otBotellaVacia, eOBJType.otBotellaLlena
            ObjData(Object).IndexAbierta = val(Leer.GetValue("OBJ" & Object, "IndexAbierta"))
            ObjData(Object).IndexCerrada = val(Leer.GetValue("OBJ" & Object, "IndexCerrada"))
            ObjData(Object).IndexCerradaLlave = val(Leer.GetValue("OBJ" & Object, "IndexCerradaLlave"))
        
        Case otPociones
            ObjData(Object).TipoPocion = val(Leer.GetValue("OBJ" & Object, "TipoPocion"))
            ObjData(Object).MaxModificador = val(Leer.GetValue("OBJ" & Object, "MaxModificador"))
            ObjData(Object).MinModificador = val(Leer.GetValue("OBJ" & Object, "MinModificador"))
            ObjData(Object).DuracionEfecto = val(Leer.GetValue("OBJ" & Object, "DuracionEfecto"))
        
        Case eOBJType.otBarcos
            ObjData(Object).MinSkill = val(Leer.GetValue("OBJ" & Object, "MinSkill"))
            ObjData(Object).MaxHit = val(Leer.GetValue("OBJ" & Object, "MaxHIT"))
            ObjData(Object).MinHit = val(Leer.GetValue("OBJ" & Object, "MinHIT"))
        
        Case eOBJType.otFlechas
            ObjData(Object).MaxHit = val(Leer.GetValue("OBJ" & Object, "MaxHIT"))
            ObjData(Object).MinHit = val(Leer.GetValue("OBJ" & Object, "MinHIT"))
            ObjData(Object).Envenena = val(Leer.GetValue("OBJ" & Object, "Envenena"))
            ObjData(Object).Paraliza = val(Leer.GetValue("OBJ" & Object, "Paraliza"))
        Case eOBJType.otAnillo
            ObjData(Object).SkHerreria = val(Leer.GetValue("OBJ" & Object, "SkHerreria"))
            
            
    End Select
    
    ObjData(Object).Ropaje = val(Leer.GetValue("OBJ" & Object, "NumRopaje"))
    ObjData(Object).Ropaje_mina = val(Leer.GetValue("OBJ" & Object, "NumRopajeMina"))
    ObjData(Object).HechizoIndex = val(Leer.GetValue("OBJ" & Object, "HechizoIndex"))
    
    ObjData(Object).LingoteIndex = val(Leer.GetValue("OBJ" & Object, "LingoteIndex"))
    
    ObjData(Object).MineralIndex = val(Leer.GetValue("OBJ" & Object, "MineralIndex"))
    
    ObjData(Object).MaxHP = val(Leer.GetValue("OBJ" & Object, "MaxHP"))
    ObjData(Object).MinHP = val(Leer.GetValue("OBJ" & Object, "MinHP"))
    
    ObjData(Object).Mujer = val(Leer.GetValue("OBJ" & Object, "Mujer"))
    ObjData(Object).Hombre = val(Leer.GetValue("OBJ" & Object, "Hombre"))
    
    ObjData(Object).MinHam = val(Leer.GetValue("OBJ" & Object, "MinHam"))
    ObjData(Object).MinSed = val(Leer.GetValue("OBJ" & Object, "MinAgu"))
    
    ObjData(Object).MinDef = val(Leer.GetValue("OBJ" & Object, "MINDEF"))
    ObjData(Object).MaxDef = val(Leer.GetValue("OBJ" & Object, "MAXDEF"))
    ObjData(Object).def = (ObjData(Object).MinDef + ObjData(Object).MaxDef) / 2
    
    ObjData(Object).RazaEnana = val(Leer.GetValue("OBJ" & Object, "RazaEnana"))
    ObjData(Object).RazaDrow = val(Leer.GetValue("OBJ" & Object, "RazaDrow"))
    ObjData(Object).RazaElfa = val(Leer.GetValue("OBJ" & Object, "RazaElfa"))
    ObjData(Object).RazaGnoma = val(Leer.GetValue("OBJ" & Object, "RazaGnoma"))
    ObjData(Object).RazaHumana = val(Leer.GetValue("OBJ" & Object, "RazaHumana"))
    
    ObjData(Object).Valor = val(Leer.GetValue("OBJ" & Object, "Valor"))
    
    ObjData(Object).Crucial = val(Leer.GetValue("OBJ" & Object, "Crucial"))
    
    ObjData(Object).Cerrada = val(Leer.GetValue("OBJ" & Object, "abierta"))
    If ObjData(Object).Cerrada = 1 Then
        ObjData(Object).Llave = val(Leer.GetValue("OBJ" & Object, "Llave"))
        ObjData(Object).clave = val(Leer.GetValue("OBJ" & Object, "Clave"))
    End If
    
    'Puertas y llaves
    
    ObjData(Object).Agarrable = val(Leer.GetValue("OBJ" & Object, "Agarrable"))
    ObjData(Object).una_mano = val(Leer.GetValue("OBJ" & Object, "una_mano"))
    
    
    'CHECK: !!! Esto es provisorio hasta que los de Dateo cambien los valores de string a numerico
    Dim i As Integer
    Dim N As Integer
    Dim s As String
    For i = 1 To NUMCLASES
        s = UCase$(Leer.GetValue("OBJ" & Object, "CP" & i))
        N = 1
        Do While LenB(s) > 0 And UCase$(ListaClases(N)) <> s And N < NUMCLASES
            N = N + 1
        Loop
        ObjData(Object).ClaseProhibida(i) = IIf(LenB(s) > 0, N, 0)
    Next i
    
    ObjData(Object).DefensaMagicaMax = val(Leer.GetValue("OBJ" & Object, "DefensaMagicaMax"))
    ObjData(Object).DefensaMagicaMin = val(Leer.GetValue("OBJ" & Object, "DefensaMagicaMin"))
    
    ObjData(Object).SkCarpinteria = val(Leer.GetValue("OBJ" & Object, "SkCarpinteria"))
    
    If ObjData(Object).SkCarpinteria > 0 Then _
        ObjData(Object).Madera = val(Leer.GetValue("OBJ" & Object, "Madera"))
    
    'Bebidas
    ObjData(Object).MinSta = val(Leer.GetValue("OBJ" & Object, "MinST"))
    
    ObjData(Object).NoSeCae = val(Leer.GetValue("OBJ" & Object, "NoSeCae"))
    
    'frmCargando.cargar.value = frmCargando.cargar.value + 1
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
'
'If ObjData(Object).name <> "" Then
'    Select Case ObjData(Object).OBJType
'    Case eOBJType.otInstrumentos, eOBJType.otMinerales, eOBJType.otYunque, eOBJType.otYacimiento, eOBJType.otLlaves
'    GoTo asd
'    Case eOBJType.otPuertas
'    GoTo asd
'
'    End Select
'    pt bt, ""
'    pt bt, "[OBJ" & Object & "]"
'    pt bt, "Name=" & ObjData(Object).name
'
'    If ObjData(Object).GrhIndex <> 0 Then _
'    pt bt, "GrhIndex=" & ObjData(Object).GrhIndex
'
'    pt bt, "ObjType=" & ObjData(Object).OBJType
'
'
'    Select Case ObjData(Object).OBJType
'        Case eOBJType.otESCUDO
'            pt bt, "Anim=" & ObjData(Object).ShieldAnim
'
'        Case eOBJType.otCASCO
'            pt bt, "Anim=" & ObjData(Object).CascoAnim
'
'        Case eOBJType.otWeapon
'            pt bt, "Anim=" & ObjData(Object).WeaponAnim
'            pt bt, "Apuñala=" & ObjData(Object).Apuñala
'            pt bt, "Envenena=" & ObjData(Object).Envenena
'            pt bt, "MaxHIT=" & ObjData(Object).MaxHIT
'            pt bt, "MinHIT=" & ObjData(Object).MinHIT
'            pt bt, "Proyectil=" & ObjData(Object).proyectil
'            pt bt, "Municiones=" & ObjData(Object).Municion
'            pt bt, "StaffPower=" & ObjData(Object).StaffPower
'            pt bt, "StaffDamageBonus=" & ObjData(Object).StaffDamageBonus
'            pt bt, "Refuerzo=" & ObjData(Object).Refuerzo
'
'        Case eOBJType.otPuertas, eOBJType.otBotellaVacia, eOBJType.otBotellaLlena
'            pt bt, "IndexAbierta=" & ObjData(Object).IndexAbierta
'            pt bt, "IndexCerrada=" & ObjData(Object).IndexCerrada
'            pt bt, "IndexCerradaLlave=" & ObjData(Object).IndexCerradaLlave
'        Case otPociones
'            pt bt, "TipoPocion=" & ObjData(Object).TipoPocion
'            pt bt, "MaxModificador=" & ObjData(Object).MaxModificador
'            pt bt, "MinModificador=" & ObjData(Object).MinModificador
'            pt bt, "DuracionEfecto=" & ObjData(Object).DuracionEfecto
'
'        Case eOBJType.otBarcos
'            pt bt, "MaxHIT=" & ObjData(Object).MaxHIT
'            pt bt, "MinHIT=" & ObjData(Object).MinHIT
'
'        Case eOBJType.otFlechas
'            pt bt, "Envenena=" & ObjData(Object).Envenena
'            pt bt, "Paraliza=" & ObjData(Object).Paraliza
'            pt bt, "MaxHIT=" & ObjData(Object).MaxHIT
'            pt bt, "MinHIT=" & ObjData(Object).MinHIT
'    End Select
'
'    If ObjData(Object).Ropaje Then pt bt, "NumRopaje=" & ObjData(Object).Ropaje
'    If ObjData(Object).Ropaje_mina Then pt bt, "NumRopajeMina=" & ObjData(Object).Ropaje_mina
'    If ObjData(Object).HechizoIndex Then pt bt, "HechizoIndex=" & ObjData(Object).HechizoIndex
'
'
'    If ObjData(Object).MaxHP Then pt bt, "MaxHP=" & ObjData(Object).MaxHP
'    If ObjData(Object).MinHP Then pt bt, "MinHP=" & ObjData(Object).MinHP
'
'    If ObjData(Object).Mujer Then pt bt, "Mujer=" & ObjData(Object).Mujer
'    If ObjData(Object).Hombre Then pt bt, "Hombre=" & ObjData(Object).Hombre
'
'    If ObjData(Object).MinDef Then pt bt, "MINDEF=" & ObjData(Object).MinDef
'    If ObjData(Object).MaxDef Then pt bt, "MAXDEF=" & ObjData(Object).MaxDef
'
'    If ObjData(Object).RazaEnana Then pt bt, "RazaEnana=" & ObjData(Object).MaxDef
'    If ObjData(Object).RazaDrow Then pt bt, "RazaDrow=" & ObjData(Object).RazaDrow
'    If ObjData(Object).RazaElfa Then pt bt, "RazaElfa=" & ObjData(Object).MaxDef
'    If ObjData(Object).RazaGnoma Then pt bt, "RazaGnoma=" & ObjData(Object).MaxDef
'    If ObjData(Object).RazaHumana Then pt bt, "RazaHumana=" & ObjData(Object).MaxDef
'
'    If ObjData(Object).Valor Then pt bt, "Valor=" & ObjData(Object).Valor
'
'    If ObjData(Object).Cerrada Then
'        pt bt, "abierta=" & ObjData(Object).Cerrada
'        pt bt, "Llave=" & ObjData(Object).Llave
'        pt bt, "Clave=" & ObjData(Object).clave
'    End If
'
'    'Puertas y llaves
'    If ObjData(Object).Agarrable Then pt bt, "Agarrable=" & ObjData(Object).Agarrable
'    If ObjData(Object).una_mano Then pt bt, "una_mano=" & ObjData(Object).una_mano
'
'
'    'CHECK: !!! Esto es provisorio hasta que los de Dateo cambien los valores de string a numerico
'
'
'    For i = 1 To NUMCLASES
'        If ObjData(Object).ClaseProhibida(i) = 0 Then Exit For
'        If ObjData(Object).ClaseProhibida(i) <> eClass.Bandit And ObjData(Object).ClaseProhibida(i) <> eClass.Fisher And ObjData(Object).ClaseProhibida(i) <> eClass.Lumberjack And ObjData(Object).ClaseProhibida(i) <> eClass.Miner And ObjData(Object).ClaseProhibida(i) <> eClass.Pirat And ObjData(Object).ClaseProhibida(i) <> eClass.Blacksmith And ObjData(Object).ClaseProhibida(i) <> eClass.Fisher And ObjData(Object).ClaseProhibida(i) <> eClass.Carpenter And ObjData(Object).ClaseProhibida(i) <> eClass.Thief Then _
'        pt bt, "CP" & i & "=" & UCase$(ListaClases(ObjData(Object).ClaseProhibida(i)))
'    Next i
'
'    If ObjData(Object).DefensaMagicaMax Then pt bt, "DefensaMagicaMax=" & ObjData(Object).DefensaMagicaMax
'    If ObjData(Object).DefensaMagicaMin Then pt bt, "DefensaMagicaMin=" & ObjData(Object).DefensaMagicaMin
'asd:
'End If
Next Object
'If FileExist("c:\a.txt") Then Kill "c:\a.txt"
'Open "c:\a.txt" For Binary Access Write As #1
'Put #1, , bt
'Close #1

Set Leer = Nothing

Exit Sub

ErrHandler:
    MsgBox "error cargando objetos " & ERR.number & ": " & ERR.Description
    LogError "error cargando objetos " & ERR.number & ": " & ERR.Description

End Sub

Sub pt(t As String, p As String)
t = t & vbNewLine & p
End Sub

Sub DarCuerpoYCabezaFROM_WEB(ByVal UserIndex As Integer)
'
'Author: Nacho (Integer)
'Last modified: 14/03/2007
'Elije una cabeza para el usuario y le da un body
'
Dim NewBody As Integer
Dim NewHead As Integer
Dim UserRaza As Byte
Dim UserGenero As Byte
UserGenero = UserList(UserIndex).genero
UserRaza = UserList(UserIndex).raza
Select Case UserGenero
   Case eGenero.Hombre
        Select Case UserRaza
            Case eRaza.Humano
                NewHead = RandomNumber(1, 38)
                NewBody = 1
            Case eRaza.Elfo
                NewHead = RandomNumber(101, 112)
                NewBody = 2
            Case eRaza.Drow
                NewHead = RandomNumber(200, 210)
                NewBody = 3
            Case eRaza.Enano
                NewHead = RandomNumber(300, 306)
                NewBody = 300
            Case eRaza.Gnomo
                NewHead = RandomNumber(401, 406)
                NewBody = 300
        End Select
   Case eGenero.Mujer
        Select Case UserRaza
            Case eRaza.Humano
                NewHead = RandomNumber(70, 79)
                NewBody = 1
            Case eRaza.Elfo
                NewHead = RandomNumber(170, 178)
                NewBody = 2
            Case eRaza.Drow
                NewHead = RandomNumber(270, 278)
                NewBody = 3
            Case eRaza.Gnomo
                NewHead = RandomNumber(370, 372)
                NewBody = 300
            Case eRaza.Enano
                NewHead = RandomNumber(470, 476)
                NewBody = 300
        End Select
End Select

'i f UserList(UserIndex).f_cabeza = True Then
'    UserList(UserIndex).Char.Head = UserList(UserIndex).cabeza_f
'Else
    UserList(UserIndex).Char.Head = NewHead
'End If

UserList(UserIndex).Char.Body = NewBody
End Sub

Public Function LoadUserStatsFROM_WEB(ByVal UserIndex As Integer, ByVal pj As Byte) As Boolean
On Error Resume Next
    If UserList(UserIndex).web_pjs_count < pj Then
        LoadUserStatsFROM_WEB = Adquirir_WEBPJ(public_pjs(Abs(pj - UserList(UserIndex).web_pjs_count) Mod 9), UserIndex)
        
        If LoadUserStatsFROM_WEB = True Then UserList(UserIndex).pj_web = 0
    Else
        LoadUserStatsFROM_WEB = Adquirir_WEBPJ(UserList(UserIndex).web_pjs(pj), UserIndex)
        If LoadUserStatsFROM_WEB = True Then
            UserList(UserIndex).pj_web = UserList(UserIndex).web_pjs(pj).id
            Debug.Print "PJ SELECCIONADO "; UserIndex; "->"; UserList(UserIndex).pj_web
        End If
    End If
End Function

Public Function Adquirir_WEBPJ(pj As webpj, ByVal UserIndex As Integer) As Boolean
Dim i As Long
Dim UserRaza As Integer 'eRaza
Dim UserClase As Integer 'eClass
Static rebalanced As Integer
Static ultimop As Long
With UserList(UserIndex)

    UserRaza = pj.raza Mod 6
    UserClase = pj.clase Mod 11
    
    If UserClase = 0 Then UserClase = 1
    If UserRaza = 0 Then UserRaza = 1
            
    If .dios And dioses.SuperDios Then
    Else
        If frmMain.cClasspe(UserClase).value = vbChecked Then
            If UserClase > NUMCLASES Then
                WriteElejirPJ UserIndex
                Adquirir_WEBPJ = False
                Exit Function
            End If
        Else
            Call WriteConsoleMsg(UserIndex, "Clase deshabilitada. Intente nuevamente.", FontTypeNames.FONTTYPE_INFO)
            WriteElejirPJ UserIndex
            Adquirir_WEBPJ = False
            Exit Function
        End If
    End If
    
    If bClases(UserClase).vida(UserRaza) = 0 Then
        LogError "TRY CREAR PJ: " & UserClase & " " & UserRaza
        Call WriteConsoleMsg(UserIndex, "Balance desconfigurado.", FontTypeNames.FONTTYPE_INFO)
        WriteElejirPJ UserIndex
        If ((GetTickCount And &H7FFFFFFF) + 2000 - ultimop) < 0 Then
            If rebalanced < 5 Then
                Call WriteConsoleMsg(UserIndex, "Solicitando archivo de blalance al servidor principal...", FontTypeNames.FONTTYPE_INFO)
                ultimop = (GetTickCount() And &H7FFFFFFF) And &H7FFFFFFF
                balance_md5 = Space$(32)
                WEBCLASS.PrdirIntervalos
            End If
            rebalanced = rebalanced + 1
        End If
        Adquirir_WEBPJ = False
        Exit Function
    End If
            
    .raza = UserRaza
    .clase = UserClase
    
    .Stats.MaxMan = bClases(UserClase).Mana(UserRaza)
    .Stats.MinMan = .Stats.MaxMan
    .Stats.MaxHit = bClases(UserClase).max_hit(UserRaza)
    .Stats.MinHit = bClases(UserClase).min_hit(UserRaza)
    .Stats.MaxHP = bClases(UserClase).vida(UserRaza) + pj.vidaup
    .Stats.MinHP = .Stats.MaxHP
    
    .Stats.UserAtributos(eAtributos.Fuerza) = 18 + bRazas(UserRaza).Atributos.Fuerza
    .Stats.UserAtributos(eAtributos.Agilidad) = 18 + bRazas(UserRaza).Atributos.Agilidad
    .Stats.UserAtributos(eAtributos.Inteligencia) = 18 + bRazas(UserRaza).Atributos.Inteligencia
    .Stats.UserAtributos(eAtributos.Carisma) = 18 + bRazas(UserRaza).Atributos.Carisma
    .Stats.UserAtributos(eAtributos.Constitucion) = 18 + bRazas(UserRaza).Atributos.Constitucion
    
    .Stats.MaxAGU = 100
    .Stats.MinAGU = 100
    .Stats.MaxSta = 999
    .Stats.MinSta = 999
    .Stats.MaxHam = 100
    .Stats.MinHam = 100
    
    .Stats.SkillPts = 0
    
    For i = 1 To 20
        Call Desequipar(UserIndex, i)
        UserList(UserIndex).Invent.Object(i).ObjIndex = 0
        UserList(UserIndex).Invent.Object(i).Amount = 0
    Next i
    .Invent.Object(1) = pj.items(1)
    .Invent.Object(1).Amount = 1
    .Invent.Object(2) = pj.items(2)
    .Invent.Object(2).Amount = 1
    For i = 3 To pj.items_count
        If i <= 20 Then
            .Invent.Object(i) = pj.items(i)
            If .Invent.Object(i).ObjIndex > 0 Then .Invent.Object(i).Amount = 1
        End If
    Next i
    
    .Invent.NroItems = pj.items_count
    UpdateUserInv True, UserIndex, 0

    For i = 1 To 12
        .Stats.UserHechizos(i) = bClases(UserClase).UserHechizos(i)
    Next i

    If .dios And dioses.centinela And NumeroHechizos > 43 Then
        .Stats.UserHechizos(1) = 44
        .Stats.UserHechizos(2) = 45
    End If
    
    Call UpdateUserHechizos(True, UserIndex, 0)
    
    .Char.Head = pj.cabeza
    .Char.Body = pj.cuerpo
    .genero = pj.genero
    
    If pj.cabeza = 0 Then Call DarCuerpoYCabeza(UserIndex)
    
    If Len(pj.name) > 0 Then
        .name = pj.name
        .modName = pj.clan
    Else
        .name = .nick
        Call DarCuerpoYCabeza(UserIndex)
    End If
    
    .Char.WeaponAnim = NingunArma
    .Char.ShieldAnim = NingunEscudo
    .Char.CascoAnim = NingunCasco
    .CharMimetizado = .Char
    .OrigChar = .Char
    
    Adquirir_WEBPJ = True
End With
End Function

Sub LoadUserStats(ByVal UserIndex As Integer)

Dim loopc As Long
Dim UserRaza As eRaza
Dim UserClase As eClass
UserClase = UserList(UserIndex).clase

For loopc = 1 To 20
    Call Desequipar(UserIndex, loopc)
    If loopc < 13 Then
        UserList(UserIndex).Invent.Object(loopc).ObjIndex = 0
        UserList(UserIndex).Invent.Object(loopc).Amount = 0
    End If
Next loopc

UserList(UserIndex).Invent.Object(7).Amount = 1

Select Case UserClase
    Case eClass.Mage
        UserRaza = eRaza.Humano '''''''
        UserList(UserIndex).Stats.MaxMan = 2206
        UserList(UserIndex).Stats.MinMan = 2206
        UserList(UserIndex).Stats.MaxHit = 31
        UserList(UserIndex).Stats.MinHit = 30
        UserList(UserIndex).Stats.MaxHP = 289
        UserList(UserIndex).Stats.MinHP = 289
        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 660
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 662
        UserList(UserIndex).Invent.Object(3).Amount = 1
    Case eClass.Druid, eClass.Bard '''''''
        UserRaza = eRaza.Elfo
        UserList(UserIndex).Stats.MaxMan = 1610
        UserList(UserIndex).Stats.MinMan = 1610
        UserList(UserIndex).Stats.MaxHit = 60
        UserList(UserIndex).Stats.MinHit = 59
        UserList(UserIndex).Stats.MaxHP = 312
        UserList(UserIndex).Stats.MinHP = 312
        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
        UserList(UserIndex).Invent.Object(1).Amount = 1
        If UserClase = eClass.Bard Then
            UserList(UserIndex).Invent.Object(11).ObjIndex = 399
            UserList(UserIndex).Invent.Object(11).Amount = 1
            UserList(UserIndex).Invent.Object(3).ObjIndex = 404
            UserList(UserIndex).Invent.Object(3).Amount = 1
            UserList(UserIndex).Invent.Object(2).ObjIndex = 132
            UserList(UserIndex).Invent.Object(2).Amount = 1
            UserList(UserIndex).Invent.Object(5).ObjIndex = 696
            UserList(UserIndex).Invent.Object(5).Amount = 1
            UserList(UserIndex).Invent.Object(12).ObjIndex = 365
            UserList(UserIndex).Invent.Object(12).Amount = 1
        Else
            UserList(UserIndex).Invent.Object(2).ObjIndex = 365
            UserList(UserIndex).Invent.Object(2).Amount = 1
            UserList(UserIndex).Invent.Object(3).ObjIndex = 208
            UserList(UserIndex).Invent.Object(3).Amount = 1

        End If

    Case eClass.Cleric '''''''
        UserRaza = eRaza.Drow
        UserList(UserIndex).Stats.MaxMan = 1610
        UserList(UserIndex).Stats.MinMan = 1610
        UserList(UserIndex).Stats.MaxHit = 70
        UserList(UserIndex).Stats.MinHit = 69
        UserList(UserIndex).Stats.MaxHP = 312
        UserList(UserIndex).Stats.MinHP = 312
        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
        UserList(UserIndex).Invent.Object(3).Amount = 1
        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
        UserList(UserIndex).Invent.Object(11).Amount = 1
        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
        UserList(UserIndex).Invent.Object(12).Amount = 1
    Case eClass.Paladin ''''''''
        UserRaza = eRaza.Humano
        UserList(UserIndex).Stats.MaxMan = 702
        UserList(UserIndex).Stats.MinMan = 702
        UserList(UserIndex).Stats.MaxHit = 101
        UserList(UserIndex).Stats.MinHit = 100
        UserList(UserIndex).Stats.MaxHP = 390
        UserList(UserIndex).Stats.MinHP = 390
        UserList(UserIndex).Invent.Object(1).ObjIndex = 359
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
        UserList(UserIndex).Invent.Object(3).Amount = 1
        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
        UserList(UserIndex).Invent.Object(11).Amount = 1
        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
        UserList(UserIndex).Invent.Object(12).Amount = 1
    Case eClass.Assasin ''''''
        UserRaza = eRaza.Drow
        UserList(UserIndex).Stats.MaxMan = 830
        UserList(UserIndex).Stats.MinMan = 830
        UserList(UserIndex).Stats.MaxHit = 101
        UserList(UserIndex).Stats.MinHit = 100
        UserList(UserIndex).Stats.MaxHP = 312
        UserList(UserIndex).Stats.MinHP = 312
        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 404
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
        UserList(UserIndex).Invent.Object(3).Amount = 1
        UserList(UserIndex).Invent.Object(11).ObjIndex = 399
        UserList(UserIndex).Invent.Object(11).Amount = 1
        UserList(UserIndex).Invent.Object(12).ObjIndex = 367
        UserList(UserIndex).Invent.Object(12).Amount = 1
    Case eClass.Warrior '''''''''
        UserRaza = eRaza.Enano
        UserList(UserIndex).Stats.MaxMan = 0
        UserList(UserIndex).Stats.MinMan = 0
        UserList(UserIndex).Stats.MaxHit = 115
        UserList(UserIndex).Stats.MinHit = 114
        UserList(UserIndex).Stats.MaxHP = 409
        UserList(UserIndex).Stats.MinHP = 409
        UserList(UserIndex).Invent.Object(1).ObjIndex = 243
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
        UserList(UserIndex).Invent.Object(3).Amount = 1
        UserList(UserIndex).Invent.Object(7).ObjIndex = 479
        UserList(UserIndex).Invent.Object(7).Amount = 1
        UserList(UserIndex).Invent.Object(8).ObjIndex = 480
        UserList(UserIndex).Invent.Object(8).Amount = 10000
        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
        UserList(UserIndex).Invent.Object(11).Amount = 1
        UserList(UserIndex).Invent.Object(12).ObjIndex = 164 '625
        UserList(UserIndex).Invent.Object(12).Amount = 1
    Case eClass.Hunter
        UserRaza = eRaza.Humano
        UserList(UserIndex).Stats.MaxMan = 0
        UserList(UserIndex).Stats.MinMan = 0
        UserList(UserIndex).Stats.MaxHit = 70
        UserList(UserIndex).Stats.MinHit = 60
        UserList(UserIndex).Stats.MaxHP = 390
        UserList(UserIndex).Stats.MinHP = 390
        UserList(UserIndex).Invent.Object(1).ObjIndex = 359
        UserList(UserIndex).Invent.Object(1).Amount = 1
        UserList(UserIndex).Invent.Object(3).ObjIndex = 404
        UserList(UserIndex).Invent.Object(3).Amount = 1
        UserList(UserIndex).Invent.Object(2).ObjIndex = 132
        UserList(UserIndex).Invent.Object(2).Amount = 1
        UserList(UserIndex).Invent.Object(7).ObjIndex = 553
        UserList(UserIndex).Invent.Object(11).ObjIndex = 665
        UserList(UserIndex).Invent.Object(11).Amount = 1
        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
        UserList(UserIndex).Invent.Object(12).Amount = 1
    Case Else
        UserClase = eClass.Cleric
        UserRaza = eRaza.Drow
        UserList(UserIndex).Stats.MaxMan = 1
        UserList(UserIndex).Stats.MinMan = 0
        UserList(UserIndex).Stats.MaxHit = 1
        UserList(UserIndex).Stats.MinHit = 1
        UserList(UserIndex).Stats.MaxHP = 1
        UserList(UserIndex).Stats.MinHP = 0
End Select
UserList(UserIndex).raza = UserRaza

UserList(UserIndex).Stats.UserAtributos(eAtributos.Fuerza) = 18 + bRazas(UserRaza).Atributos.Fuerza
UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad) = 18 + bRazas(UserRaza).Atributos.Agilidad
UserList(UserIndex).Stats.UserAtributos(eAtributos.Inteligencia) = 18 + bRazas(UserRaza).Atributos.Inteligencia
UserList(UserIndex).Stats.UserAtributos(eAtributos.Carisma) = 18 + bRazas(UserRaza).Atributos.Carisma
UserList(UserIndex).Stats.UserAtributos(eAtributos.Constitucion) = 18 + bRazas(UserRaza).Atributos.Constitucion

'For LoopC = 1 To 10
'UserList(UserIndex).Invent.Object(LoopC).Equipped = 0
'Next LoopC

UserList(UserIndex).Stats.GLD = 0
UserList(UserIndex).Stats.Banco = 0

UserList(UserIndex).Stats.MaxAGU = 100
UserList(UserIndex).Stats.MinAGU = 100
UserList(UserIndex).Stats.MaxSta = 999
UserList(UserIndex).Stats.MinSta = 999
UserList(UserIndex).Stats.MaxHam = 100
UserList(UserIndex).Stats.MinHam = 100

UserList(UserIndex).Stats.SkillPts = 0

'UserList(UserIndex).Invent.Object(1).ObjIndex = 474
'UserList(UserIndex).Invent.Object(1).amount = 1
'UserList(UserIndex).Invent.BarcoSlot = 1
'UserList(UserIndex).Invent.BarcoObjIndex = 474

UserList(UserIndex).Invent.Object(6).ObjIndex = 38
UserList(UserIndex).Invent.Object(6).Amount = 1


If UserClase = eClass.Mage Or UserClase = eClass.Cleric Or _
   UserClase = eClass.Druid Or UserClase = eClass.Bard Or _
   UserClase = eClass.Assasin Or UserClase = eClass.Paladin Then
        UserList(UserIndex).Stats.UserHechizos(1) = 1
        UserList(UserIndex).Stats.UserHechizos(2) = 2
        UserList(UserIndex).Stats.UserHechizos(3) = 11
        UserList(UserIndex).Stats.UserHechizos(4) = 5
        UserList(UserIndex).Stats.UserHechizos(5) = 41
        UserList(UserIndex).Stats.UserHechizos(6) = 31
        UserList(UserIndex).Stats.UserHechizos(7) = 14
        UserList(UserIndex).Stats.UserHechizos(8) = 15
        UserList(UserIndex).Stats.UserHechizos(9) = 23
        UserList(UserIndex).Stats.UserHechizos(10) = 25
        UserList(UserIndex).Stats.UserHechizos(11) = 24
        UserList(UserIndex).Stats.UserHechizos(12) = 10
        UserList(UserIndex).Invent.Object(7).ObjIndex = 37
End If

''If UserList(UserIndex).dios > 249 Then
'    UserList(UserIndex).Stats.UserHechizos(1) = 22 '32
'    UserList(UserIndex).Stats.UserHechizos(2) = 34
''End If
If UserList(UserIndex).dios And dioses.centinela And NumeroHechizos > 43 Then
    UserList(UserIndex).Stats.UserHechizos(1) = 44
    UserList(UserIndex).Stats.UserHechizos(2) = 45
End If

If UserClase = eClass.Druid Then
        UserList(UserIndex).Stats.UserHechizos(1) = 29
        UserList(UserIndex).Stats.UserHechizos(2) = 42
End If


Call DarCuerpoYCabeza(UserIndex)
 
UserList(UserIndex).Char.WeaponAnim = NingunArma
UserList(UserIndex).Char.ShieldAnim = NingunEscudo
UserList(UserIndex).Char.CascoAnim = NingunCasco


End Sub

'
'Sub LoadUserStats(ByVal UserIndex As Integer)
'
'Dim loopc As Long
'Dim UserRaza As eRaza
'Dim UserClase As eClass
'UserClase = UserList(UserIndex).clase
'
'For loopc = 1 To 20
'    Call Desequipar(UserIndex, loopc)
'    If loopc < 13 Then
'        UserList(UserIndex).Invent.Object(loopc).ObjIndex = 0
'        UserList(UserIndex).Invent.Object(loopc).amount = 0
'    End If
'Next loopc
'
'UserList(UserIndex).Invent.Object(7).amount = 1
'
'Select Case UserClase
'    Case eClass.Mage
'        UserRaza = eRaza.Humano
'        UserList(UserIndex).Stats.MaxMAN = 2206
'        UserList(UserIndex).Stats.MinMAN = 2206
'        UserList(UserIndex).Stats.MaxHIT = 31
'        UserList(UserIndex).Stats.MinHIT = 30
'        UserList(UserIndex).Stats.MaxHP = 289
'        UserList(UserIndex).Stats.MinHP = 289
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 660
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 662
'        UserList(UserIndex).Invent.Object(3).amount = 1
'    Case eClass.Druid, eClass.Bard
'        UserRaza = eRaza.Elfo
'        UserList(UserIndex).Stats.MaxMAN = 1610
'        UserList(UserIndex).Stats.MinMAN = 1610
'        UserList(UserIndex).Stats.MaxHIT = 60
'        UserList(UserIndex).Stats.MinHIT = 59
'        UserList(UserIndex).Stats.MaxHP = 312
'        UserList(UserIndex).Stats.MinHP = 312
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        If UserClase = eClass.Bard Then
'            UserList(UserIndex).Invent.Object(11).ObjIndex = 399
'            UserList(UserIndex).Invent.Object(11).amount = 1
'            UserList(UserIndex).Invent.Object(3).ObjIndex = 404
'            UserList(UserIndex).Invent.Object(3).amount = 1
'            UserList(UserIndex).Invent.Object(2).ObjIndex = 132
'            UserList(UserIndex).Invent.Object(2).amount = 1
'            UserList(UserIndex).Invent.Object(5).ObjIndex = 696
'            UserList(UserIndex).Invent.Object(5).amount = 1
'            UserList(UserIndex).Invent.Object(12).ObjIndex = 365
'            UserList(UserIndex).Invent.Object(12).amount = 1
'        Else
'            UserList(UserIndex).Invent.Object(2).ObjIndex = 365
'            UserList(UserIndex).Invent.Object(2).amount = 1
'            UserList(UserIndex).Invent.Object(3).ObjIndex = 208
'            UserList(UserIndex).Invent.Object(3).amount = 1
'
'        End If
'
'    Case eClass.Cleric
'        UserRaza = eRaza.Drow
'        UserList(UserIndex).Stats.MaxMAN = 1610
'        UserList(UserIndex).Stats.MinMAN = 1610
'        UserList(UserIndex).Stats.MaxHIT = 70
'        UserList(UserIndex).Stats.MinHIT = 69
'        UserList(UserIndex).Stats.MaxHP = 312
'        UserList(UserIndex).Stats.MinHP = 312
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
'        UserList(UserIndex).Invent.Object(3).amount = 1
'        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
'        UserList(UserIndex).Invent.Object(11).amount = 1
'        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
'        UserList(UserIndex).Invent.Object(12).amount = 1
'    Case eClass.Paladin
'        UserRaza = eRaza.Humano
'        UserList(UserIndex).Stats.MaxMAN = 702
'        UserList(UserIndex).Stats.MinMAN = 702
'        UserList(UserIndex).Stats.MaxHIT = 101
'        UserList(UserIndex).Stats.MinHIT = 100
'        UserList(UserIndex).Stats.MaxHP = 390
'        UserList(UserIndex).Stats.MinHP = 390
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 359
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
'        UserList(UserIndex).Invent.Object(3).amount = 1
'        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
'        UserList(UserIndex).Invent.Object(11).amount = 1
'        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
'        UserList(UserIndex).Invent.Object(12).amount = 1
'    Case eClass.Assasin
'        UserRaza = eRaza.Drow
'        UserList(UserIndex).Stats.MaxMAN = 830
'        UserList(UserIndex).Stats.MinMAN = 830
'        UserList(UserIndex).Stats.MaxHIT = 101
'        UserList(UserIndex).Stats.MinHIT = 100
'        UserList(UserIndex).Stats.MaxHP = 312
'        UserList(UserIndex).Stats.MinHP = 312
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 986
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 404
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
'        UserList(UserIndex).Invent.Object(3).amount = 1
'        UserList(UserIndex).Invent.Object(11).ObjIndex = 399
'        UserList(UserIndex).Invent.Object(11).amount = 1
'        UserList(UserIndex).Invent.Object(12).ObjIndex = 367
'        UserList(UserIndex).Invent.Object(12).amount = 1
'    Case eClass.Warrior
'        UserRaza = eRaza.Enano
'        UserList(UserIndex).Stats.MaxMAN = 0
'        UserList(UserIndex).Stats.MinMAN = 0
'        UserList(UserIndex).Stats.MaxHIT = 115
'        UserList(UserIndex).Stats.MinHIT = 114
'        UserList(UserIndex).Stats.MaxHP = 409
'        UserList(UserIndex).Stats.MinHP = 409
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 243
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 128
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 131
'        UserList(UserIndex).Invent.Object(3).amount = 1
'        UserList(UserIndex).Invent.Object(7).ObjIndex = 479
'        UserList(UserIndex).Invent.Object(7).amount = 1
'        UserList(UserIndex).Invent.Object(8).ObjIndex = 480
'        UserList(UserIndex).Invent.Object(8).amount = 10000
'        UserList(UserIndex).Invent.Object(11).ObjIndex = 129
'        UserList(UserIndex).Invent.Object(11).amount = 1
'        UserList(UserIndex).Invent.Object(12).ObjIndex = 164 '625
'        UserList(UserIndex).Invent.Object(12).amount = 1
'    Case eClass.Hunter
'        UserRaza = eRaza.Humano
'        UserList(UserIndex).Stats.MaxMAN = 0
'        UserList(UserIndex).Stats.MinMAN = 0
'        UserList(UserIndex).Stats.MaxHIT = 70
'        UserList(UserIndex).Stats.MinHIT = 60
'        UserList(UserIndex).Stats.MaxHP = 390
'        UserList(UserIndex).Stats.MinHP = 390
'        UserList(UserIndex).Invent.Object(1).ObjIndex = 359
'        UserList(UserIndex).Invent.Object(1).amount = 1
'        UserList(UserIndex).Invent.Object(3).ObjIndex = 404
'        UserList(UserIndex).Invent.Object(3).amount = 1
'        UserList(UserIndex).Invent.Object(2).ObjIndex = 132
'        UserList(UserIndex).Invent.Object(2).amount = 1
'        UserList(UserIndex).Invent.Object(7).ObjIndex = 553
'        UserList(UserIndex).Invent.Object(11).ObjIndex = 665
'        UserList(UserIndex).Invent.Object(11).amount = 1
'        UserList(UserIndex).Invent.Object(12).ObjIndex = 365
'        UserList(UserIndex).Invent.Object(12).amount = 1
'    Case Else
'        UserClase = eClass.Cleric
'        UserRaza = eRaza.Drow
'        UserList(UserIndex).Stats.MaxMAN = 1
'        UserList(UserIndex).Stats.MinMAN = 0
'        UserList(UserIndex).Stats.MaxHIT = 1
'        UserList(UserIndex).Stats.MinHIT = 1
'        UserList(UserIndex).Stats.MaxHP = 1
'        UserList(UserIndex).Stats.MinHP = 0
'End Select
'UserList(UserIndex).raza = UserRaza
'UserList(UserIndex).Stats.UserAtributos(eAtributos.Fuerza) = 18 + bRazas(UserRaza).Atributos.Fuerza
'UserList(UserIndex).Stats.UserAtributos(eAtributos.Agilidad) = 18 + bRazas(UserRaza).Atributos.Agilidad
'UserList(UserIndex).Stats.UserAtributos(eAtributos.Inteligencia) = 18 + bRazas(UserRaza).Atributos.Inteligencia
'UserList(UserIndex).Stats.UserAtributos(eAtributos.Carisma) = 18 + bRazas(UserRaza).Atributos.Carisma
'UserList(UserIndex).Stats.UserAtributos(eAtributos.Constitucion) = 18 + bRazas(UserRaza).Atributos.Constitucion
'
''For LoopC = 1 To 10
''UserList(UserIndex).Invent.Object(LoopC).Equipped = 0
''Next LoopC
'
'UserList(UserIndex).Stats.GLD = 0
'UserList(UserIndex).Stats.Banco = 0
'
'UserList(UserIndex).Stats.MaxAGU = 100
'UserList(UserIndex).Stats.MinAGU = 100
'UserList(UserIndex).Stats.MaxSta = 999
'UserList(UserIndex).Stats.MinSta = 999
'UserList(UserIndex).Stats.MaxHam = 100
'UserList(UserIndex).Stats.MinHam = 100
'
'UserList(UserIndex).Stats.SkillPts = 0
'
''UserList(UserIndex).Invent.Object(1).ObjIndex = 474
''UserList(UserIndex).Invent.Object(1).amount = 1
''UserList(UserIndex).Invent.BarcoSlot = 1
''UserList(UserIndex).Invent.BarcoObjIndex = 474
'
'UserList(UserIndex).Invent.Object(6).ObjIndex = 38
'UserList(UserIndex).Invent.Object(6).amount = 1
'
'
'If UserClase = eClass.Mage Or UserClase = eClass.Cleric Or _
'   UserClase = eClass.Druid Or UserClase = eClass.Bard Or _
'   UserClase = eClass.Assasin Or UserClase = eClass.Paladin Then
'        UserList(UserIndex).Stats.UserHechizos(1) = 1
'        UserList(UserIndex).Stats.UserHechizos(2) = 2
'        UserList(UserIndex).Stats.UserHechizos(3) = 11
'        UserList(UserIndex).Stats.UserHechizos(4) = 5
'        UserList(UserIndex).Stats.UserHechizos(5) = 41
'        UserList(UserIndex).Stats.UserHechizos(6) = 31
'        UserList(UserIndex).Stats.UserHechizos(7) = 14
'        UserList(UserIndex).Stats.UserHechizos(8) = 15
'        UserList(UserIndex).Stats.UserHechizos(9) = 23
'        UserList(UserIndex).Stats.UserHechizos(10) = 25
'        UserList(UserIndex).Stats.UserHechizos(11) = 24
'        UserList(UserIndex).Stats.UserHechizos(12) = 10
'        UserList(UserIndex).Invent.Object(7).ObjIndex = 37
'End If
'
'If UserList(UserIndex).dios > 249 Then
'    UserList(UserIndex).Stats.UserHechizos(1) = 22 '32
'    UserList(UserIndex).Stats.UserHechizos(2) = 34
'End If
'If UserList(UserIndex).dios > 127 And NumeroHechizos > 43 Then
'    UserList(UserIndex).Stats.UserHechizos(1) = 22 '44
'    UserList(UserIndex).Stats.UserHechizos(2) = 45
'End If
'If UserClase = eClass.Druid Then
'        UserList(UserIndex).Stats.UserHechizos(1) = 29
'        UserList(UserIndex).Stats.UserHechizos(2) = 42
'End If
'
'
'Call DarCuerpoYCabeza(UserIndex)
'
'UserList(UserIndex).Char.WeaponAnim = NingunArma
'UserList(UserIndex).Char.ShieldAnim = NingunEscudo
'UserList(UserIndex).Char.CascoAnim = NingunCasco
'
'
'End Sub




Sub LoadUserInit(ByVal UserIndex As Integer)
UserList(UserIndex).Bando = enone
UserList(UserIndex).Faccion.ArmadaReal = 0
UserList(UserIndex).Faccion.FuerzasCaos = 0
UserList(UserIndex).Faccion.CiudadanosMatados = 0
UserList(UserIndex).Faccion.CriminalesMatados = 0
UserList(UserIndex).Faccion.RecibioArmaduraCaos = 0
UserList(UserIndex).Faccion.RecibioArmaduraReal = 0
UserList(UserIndex).Faccion.RecibioExpInicialCaos = 0
UserList(UserIndex).Faccion.RecibioExpInicialReal = 0
UserList(UserIndex).Faccion.RecompensasCaos = 0
UserList(UserIndex).Faccion.RecompensasReal = 0
UserList(UserIndex).Faccion.Reenlistadas = 0
UserList(UserIndex).Faccion.NivelIngreso = 0
UserList(UserIndex).Faccion.FechaIngreso = 0
UserList(UserIndex).Faccion.MatadosIngreso = 0
UserList(UserIndex).Faccion.NextRecompensa = 0

UserList(UserIndex).Flags.Muerto = 1
UserList(UserIndex).Flags.Escondido = 0

UserList(UserIndex).Flags.Hambre = 0
UserList(UserIndex).Flags.Sed = 0
UserList(UserIndex).Flags.Desnudo = 0
UserList(UserIndex).Flags.Navegando = 0
UserList(UserIndex).Flags.Envenenado = 0
UserList(UserIndex).Flags.Paralizado = 0
UserList(UserIndex).email = "a@a.c"

UserList(UserIndex).genero = 1
UserList(UserIndex).clase = Cleric
UserList(UserIndex).raza = Drow
UserList(UserIndex).Char.Heading = SOUTH

    UserList(UserIndex).Char.Body = iCuerpoMuerto
    UserList(UserIndex).Char.Head = iCabezaMuerto
    UserList(UserIndex).Char.WeaponAnim = NingunArma
    UserList(UserIndex).Char.ShieldAnim = NingunEscudo
    UserList(UserIndex).Char.CascoAnim = NingunCasco


UserList(UserIndex).Pos.map = servermap


'Dim XX As Byte
'Dim yy As Byte
'Dim salirfor As Boolean
'salirfor = False
'For XX = 9 To 90
'    If salirfor = False Then
'        For yy = 9 To 90
'            If MapData(servermap, XX, yy).trigger = eTrigger.RESUCIU Or MapData(UserList(UserIndex).pos.map, XX, yy).trigger = eTrigger.RESUPK Then
'                    If MapData(UserList(UserIndex).pos.map, XX, yy).trigger = eTrigger.RESUPK And LegalPos(UserList(UserIndex).pos.map, XX, yy, False, True) = True Then
'                        UserList(UserIndex).pos.X = XX
'                        UserList(UserIndex).pos.Y = yy
'                        salirfor = True
'                        Exit For
'                    End If''
'
'            End If
'        Next yy
'    Else
'        Exit For
'    End If
'Next XX
'If salirfor = False Then
'UserList(UserIndex).pos.X = 50
'UserList(UserIndex).pos.Y = 50
'End If
UserList(UserIndex).Invent.NroItems = 0
End Sub

Function GetVar(ByVal FILE As String, ByVal Main As String, ByVal var As String, Optional EmptySpaces As Long = 1024) As String
Dim sSpaces As String 'This will hold the input that the program will retrieve
Dim szReturn As String 'This will be the defaul value if the string is not found
szReturn = vbNullString
sSpaces = Space$(EmptySpaces) 'This tells the computer how long the longest string can be
GetPrivateProfileString Main, var, szReturn, sSpaces, EmptySpaces, FILE
GetVar = RTrim$(sSpaces)
GetVar = Left$(GetVar, Len(GetVar) - 1)
End Function

Sub CargarBackUp()
 
End Sub

Sub LoadMapData()
Dim map As Integer
Dim tFileName As String

'On Error GoTo man
'    Call InitAreas
    
    'frmCargando.cargar.min = 0
   'frmCargando.cargar.max = NumMaps
    'frmCargando.cargar.value = 0
    
    MapPath = "\"

        If game_cfg.modo_de_juego = modo_campaña Then
            ReDim MapDataBK(1 To NumMaps, XMinMapSize To MapSize, YMinMapSize To MapSize) As MapBlock
            ReDim MapInfoBK(1 To NumMaps) As MapInfo
        End If
        
        ReDim MapData(1 To NumMaps, XMinMapSize To MapSize, YMinMapSize To MapSize) As MapBlock
        ReDim MapInfo(1 To NumMaps) As MapInfo
          
        For map = 1 To NumMaps
            frmCargando.Label1(2).Caption = "Desencriptando Mapa " & map
'#If Debuging = 0 Then
tFileName = app.Path & "\Datos\mapas\" & map
'#Else
'tFileName = "C:\PC VIEJA\aonuevo\ClienteDX8\Datos\mapas\Mapa" & map
'#End If
            Call CargarMapa(map, tFileName)
            DoEvents
        Next map
        
        Call SonidosMapas.LoadSoundMapInfo
        

Exit Sub

man:

    MsgBox ("Error durante la carga de mapas, el mapa " & map & " contiene errores")
    Call LogError(Date & " " & ERR.Description & " " & ERR.HelpContext & " " & ERR.HelpFile & " " & ERR.Source)

End Sub

Public Function encode_decode_text(text As String, ByVal off As Integer, Optional ByVal cript As Byte, Optional ByVal encode As Byte) As String
    Dim i As Integer ', L As String
    If encode Then off = 256 - off
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

Public Sub CargarMapa(ByVal map As Long, ByVal MAPFl As String)
'On Error GoTo errh
    Dim FreeFileInf As Long
    Dim Y As Long
    Dim X As Long
    Dim ByFlags As Integer

    Dim contadoS As Long
    
    Dim TempLong As Long
    Dim TempInt As Integer
    
    Static cc As Long
    cc = cc + 1

    Dim h_d As String * 16
    
    Dim nmapa As String * 32
    Dim nmap As String
    Dim crca&, crcb&
    Dim cript As Byte
    Dim num_map_ As Long
    Dim num_mapa As Long
    h_d = Space$(16)
    FreeFileInf = FreeFile
    
    'inf
    Open MAPFl & ".am" For Binary As FreeFileInf
    Seek FreeFileInf, 1


    Get FreeFileInf, , h_d
    Get FreeFileInf, , cript
    Get FreeFileInf, , nmapa
    
    Get FreeFileInf, , TempInt
    Get FreeFileInf, , TempInt
    Get FreeFileInf, , TempInt
    Get FreeFileInf, , TempInt
    
    Get FreeFileInf, , TempLong
    Get FreeFileInf, , TempLong
    Get FreeFileInf, , TempLong 'CLAVE DE SEGURIDAD

num_mapa = num_map_ Xor (255 - 108) Xor cript
    
    If CInt(map) <> CInt(num_mapa) Then
'    MsgBox "ERROR EN EL MAPA " & map
'    Close FreeFileInf
'    End
    End If
    


    nmap = Trim$(encode_decode_text(nmapa, 108, cript Xor 108))
    If Not Len(nmap) > 0 Then nmap = "Sin nombre"
    
    For Y = YMinMapSize To MapSize
        For X = XMinMapSize To MapSize

            Get FreeFileInf, , ByFlags
            
            Get FreeFileInf, , TempLong
            
            MapData(map, X, Y).Blocked = (ByFlags And 1)
            
            If ByFlags And 2048 Then
                Get FreeFileInf, , TempInt
            End If
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get FreeFileInf, , TempInt
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get FreeFileInf, , TempInt
            End If
                
            'Layer 4 used?
            If ByFlags And 8 Then
                Get FreeFileInf, , TempInt
            End If
            
            
            If ByFlags And 32 Then

            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get FreeFileInf, , MapData(X, Y).trigger
                If MapData(map, X, Y).trigger = RESUCIU Or MapData(map, X, Y).trigger = RESUPK Then contadoS = contadoS + 1
            End If
            
            If ByFlags And 256 Then
                Get FreeFileInf, , MapData(map, X, Y).TileExit.map
                Get FreeFileInf, , MapData(map, X, Y).TileExit.X
                Get FreeFileInf, , MapData(map, X, Y).TileExit.Y
            End If

            If ByFlags And 512 Then
                Get FreeFileInf, , TempInt
            End If

            If ByFlags And 1024 Then
                Get FreeFileInf, , MapData(map, X, Y).ObjInfo.ObjIndex
                Get FreeFileInf, , MapData(map, X, Y).ObjInfo.Amount
            End If

            If game_cfg.modo_de_juego = modo_campaña Then
                MapDataBK(map, X, Y) = MapData(map, X, Y)
            End If

        Next X
    Next Y
    
'    'If crcb <> crca Then
'        MsgBox "ERROR EN EL MAPA " & map
'        Close FreeFileInf
'        End
    'End If
    
    Close FreeFileInf

    MapInfo(map).name = nmap
    frmMain.mapax.AddItem MapInfo(map).name
    frmMain.mapax.ListIndex = 0
    MapInfo(map).Music = 0
    MapInfo(map).StartPos.map = val(ReadField(1, GetVar(MAPFl & ".dat", "Mapa" & map, "StartPos"), Asc("-")))
    MapInfo(map).StartPos.X = val(ReadField(2, GetVar(MAPFl & ".dat", "Mapa" & map, "StartPos"), Asc("-")))
    MapInfo(map).StartPos.Y = val(ReadField(3, GetVar(MAPFl & ".dat", "Mapa" & map, "StartPos"), Asc("-")))
    MapInfo(map).MagiaSinEfecto = val(GetVar(MAPFl & ".dat", "Mapa" & map, "MagiaSinEfecto"))
    MapInfo(map).InviSinEfecto = val(GetVar(MAPFl & ".dat", "Mapa" & map, "InviSinEfecto"))
    MapInfo(map).ResuSinEfecto = val(GetVar(MAPFl & ".dat", "Mapa" & map, "ResuSinEfecto"))
    MapInfo(map).NoEncriptarMP = val(GetVar(MAPFl & ".dat", "Mapa" & map, "NoEncriptarMP"))
    MapInfo(map).maxusersx = contadoS
    If val(GetVar(MAPFl & ".dat", "Mapa" & map, "Pk")) = 0 Then
        MapInfo(map).Pk = True
    Else
        MapInfo(map).Pk = False
    End If
    
    
    MapInfo(map).Terreno = GetVar(MAPFl & ".dat", "Mapa" & map, "Terreno")
    MapInfo(map).Zona = GetVar(MAPFl & ".dat", "Mapa" & map, "Zona")
    MapInfo(map).Restringir = GetVar(MAPFl & ".dat", "Mapa" & map, "Restringir")
    MapInfo(map).BackUp = val(GetVar(MAPFl & ".dat", "Mapa" & map, "BACKUP"))
    
    If game_cfg.modo_de_juego = modo_campaña Then
        MapInfoBK(map) = MapInfo(map)
    End If
Exit Sub

errh:
    Call LogError("Error cargando mapa: " & map & " - Pos: " & X & "," & Y & "." & ERR.Description)
End Sub

Sub LoadSini()

Dim Temporal As Long

If frmMain.Visible Then frmMain.txStatus.Caption = "Cargando info de inicio del server."

BootDelBackUp = False
'Misc
'#If SeguridadAlkon Then

'Call Security.SetServerIp(GetVar(IniPath & "Server.ini", "INIT", "ServerIp"))

'#End If


Puerto = 7666
HideMe = 0
AllowMultiLogins = val(True)
IdleLimit = 5
'Lee la version correcta del cliente
ULTIMAVERSION = "1.5.00"

PuedeCrearPersonajes = 1
CamaraLenta = 0
ServerSoloGMs = 0

ArmaduraImperial1 = 370
ArmaduraImperial2 = 372
ArmaduraImperial3 = 492
TunicaMagoImperial = 517
TunicaMagoImperialEnanos = 549
ArmaduraCaos1 = 379
ArmaduraCaos2 = 523
ArmaduraCaos3 = 383
TunicaMagoCaos = 518
TunicaMagoCaosEnanos = 558

VestimentaImperialHumano = 675
VestimentaImperialEnano = 676
TunicaConspicuaHumano = 679
TunicaConspicuaEnano = 682
ArmaduraNobilisimaHumano = 629
ArmaduraNobilisimaEnano = 681
ArmaduraGranSacerdote = 680

VestimentaLegionHumano = 677
VestimentaLegionEnano = 678
TunicaLobregaHumano = 683
TunicaLobregaEnano = 685
TunicaEgregiaHumano = 634
TunicaEgregiaEnano = 686
SacerdoteDemoniaco = 684

servermap = 1

EnTesting = 0
EncriptarProtocolosCriticos = 1

'Start pos
StartPos.map = 1
StartPos.X = 50
StartPos.Y = 50

'Intervalos
SanaIntervaloSinDescansar = 1200
StaminaIntervaloSinDescansar = 2
SanaIntervaloDescansar = 100
StaminaIntervaloDescansar = 5
IntervaloSed = 10000
IntervaloHambre = 10000
IntervaloVeneno = 500
IntervaloParalizado = 500
IntervaloInvisible = 500
IntervaloFrio = 15
IntervaloWavFx = 190
IntervaloInvocacion = 1001
IntervaloParaConexion = 3000
IntervaloUserPuedeCastear = 1400
frmMain.TIMER_AI.Interval = 50
frmMain.npcataca.Interval = 2000
IntervaloUserPuedeTrabajar = 1200
IntervaloUserPuedeAtacar = 1200
'TODO : Agregar estos intervalos al form!!!
IntervaloMagiaGolpe = 1100
IntervaloGolpeMagia = 1100
MinutosWs = 180
If MinutosWs < 60 Then MinutosWs = 180
IntervaloCerrarConexion = 5
IntervaloUserPuedeUsar = 200
IntervaloFlechasCazadores = 1150
IntervaloOculto = 500
'&&&&&&&&&&&&&&&&&&&&& FIN TIMERS &&&&&&&&&&&&&&&&&&&&&&&

'Ressurect pos
ResPos.map = 1
ResPos.X = 50
ResPos.Y = 50
  
recordusuarios = 20
  
'Max users
Temporal = 20

If maxusers = 0 Then
    maxusers = Temporal
    ReDim UserList(1 To 150) As User
End If



Nix.map = 1
Nix.X = 50
Nix.Y = 50

Ullathorpe.map = 1
Ullathorpe.X = 50
Ullathorpe.Y = 50

Banderbill.map = 1
Banderbill.X = 50
Banderbill.Y = 50

Lindos.map = 1
Lindos.X = 50
Lindos.Y = 50

Arghal.map = 1
Arghal.X = 50
Arghal.Y = 50

'Call ConsultaPopular.LoadData

#If SeguridadAlkon Then
Encriptacion.StringValidacion = Encriptacion.ArmarStringValidacion
#End If

End Sub

Sub WriteVar(ByVal FILE As String, ByVal Main As String, ByVal var As String, ByVal value As String)
'
'Escribe VAR en un archivo
'

writeprivateprofilestring Main, var, value, FILE
    
End Sub

Function criminal(ByVal UserIndex As Integer) As Boolean
criminal = IIf(UserList(UserIndex).Bando = eCui, True, False)
End Function


#If MENDUZ_PC = 0 Then
Public Function Resource_Read_sdf(ByRef Path As String, ByRef FileName As String) As String
'On Error GoTo errh
    Dim handle As Integer

    Dim tr As String

    handle = FreeFile

    If Right$(Path, 1) <> "\" Then Path = Path & "\"

    If LenB(dir$(Path & FileName, vbNormal)) Then
        Open Path & FileName For Binary Access Read Lock Write As handle
            Get handle, , tr
        Close handle
    End If
Resource_Read_sdf = tr
Exit Function
errh:
LogError "Error en el archivo de recursos """ & FileName & """ Err:" & ERR.number & " - Desc : " & ERR.Description
End Function

Public Sub Resource_Create_sdf(ByRef datos As String, ByRef Path As String, ByRef FileName As String)
    If FileExist(Path & FileName, vbNormal) Then Kill Path & FileName
    DoEvents
    
    Dim handle As Integer
    handle = FreeFile
    
    Open Path & FileName For Binary Access Write As handle
        Put handle, , datos
    Close handle
End Sub
#End If
