Attribute VB_Name = "modModoCampaña"
Option Explicit

Public Enum MODO_JUEGO
    modo_agite = 0
    modo_campaña = 1
End Enum

Public Enum modo_campaña
    submodo_campaña = 0
    submodo_historia = 1
End Enum

Public Type permisos_camp
    mision As Integer
    capitulo As Integer
    historia As Integer
End Type

'Public Type logros
'
'End Type

Public Type estadoc
    permisos_recibidos As Boolean
    pj_recibido As Boolean
End Type

Public Type personaje_campaña
    nick As String
    pass As String
    mac As String * 32
    permisos As permisos_camp
End Type

Public Type cTeleports
    Source As WorldPos
    dest As WorldPos
End Type

Public Type cNpcs
    nace As WorldPos
    tipo As Integer
    nivel As Integer
    Index As Integer
    'speech as speech
End Type

Public Type actual_camp
    Mapa As Integer
    CRC As String * 6
    trigger As Integer
    nombre As String
    desc As String
    tps() As cTeleports
    numtps As Integer
    npc() As cNpcs
    numnpcs As Integer
End Type

Public campañas() As actual_camp
Public sel_cap As Integer, sel_part As Integer

Public Type actual_server
    nombre As String
    maxplayers As Integer
    permisos As permisos_camp
    modo_de_juego As MODO_JUEGO
    submodo As modo_campaña
    estado As estadoc
    pj As personaje_campaña
End Type



Public game_cfg As actual_server

Public Sub cargar_campañas()
'DESENCRIPTAR
ReDim campañas(1 To 5, 1 To 5) As actual_camp

Dim num_camp%, i%, j%, K%, t%, FILE$

num_camp = GetVar(app.Path & "\camp\c.ini", "M", "Total")
For i = 1 To num_camp
    K = GetVar(app.Path & "\camp\c.ini", "C" & i, "Partes")
    For j = 1 To K
        FILE = app.Path & "\camp\c" & i & j & ".ini"
        Debug.Print FILE
        With campañas(i, j)
            .nombre = GetVar(FILE, "C", "Nombre")
            .Mapa = CInt(GetVar(FILE, "C", "Mapa"))
            .numnpcs = CInt(GetVar(FILE, "C", "Npcs"))
            .CRC = GetVar(FILE, "C", "WEB")
            .numtps = CInt(GetVar(FILE, "C", "Teleports"))
            If .Mapa = 0 Then
            Debug.Print "OJO, MAPA 0"; FILE
            .Mapa = 1
            End If
            ReDim .npc(.numnpcs)
            ReDim .tps(.numtps)
            
            For t = 1 To .numnpcs
                With .npc(t)
                    .nace.map = CInt(GetVar(FILE, "NPC" & t, "Mapa"))
                    .nace.X = CInt(GetVar(FILE, "NPC" & t, "X"))
                    .nace.Y = CInt(GetVar(FILE, "NPC" & t, "Y"))
                    .tipo = CInt(GetVar(FILE, "NPC" & t, "Tipo"))
                    .Index = 0
                End With
            Next t
            For t = 1 To .numtps
                With .tps(t)
                    .Source.map = CInt(GetVar(FILE, "TP" & t, "Mapa"))
                    .Source.X = CInt(GetVar(FILE, "TP" & t, "X"))
                    .Source.Y = CInt(GetVar(FILE, "TP" & t, "Y"))
                    .dest.map = CInt(GetVar(FILE, "TP" & t, "SM"))
                    .dest.X = CInt(GetVar(FILE, "TP" & t, "SX"))
                    .dest.Y = CInt(GetVar(FILE, "TP" & t, "SY"))
                End With
            Next t
        End With
    Next j
Next i
            
'BORRAR
End Sub

Public Sub bloquear_form()
    With frmMain
        .Frame1.Enabled = False
        .Frame2.Enabled = False
        .Frame3.Enabled = False
        .Frame4.Enabled = False
        .maxu.Enabled = False
        .Command1.Enabled = False
        .Command5.Enabled = False
        .Command6.Enabled = False
        .Iniciarsv.Enabled = False
    End With
End Sub

Public Sub cargar_parte_campaña()
If sel_part > 0 And sel_cap > 0 Then
    Dim i As Integer, X%, Y%, m%, puedo_seguir As Boolean, tmp%, tmp1%
    If sel_part <= game_cfg.permisos.mision And sel_cap <= game_cfg.permisos.capitulo Then puedo_seguir = True
    If puedo_seguir = False Then If sel_cap < game_cfg.permisos.capitulo Then puedo_seguir = True
        'DESENCRIPTAR
    If puedo_seguir = True Then
        game_cfg.modo_de_juego = modo_campaña
        game_cfg.submodo = submodo_historia
        
        With campañas(sel_cap, sel_part)
            Debug.Print .nombre; sel_cap; sel_part
            If .Mapa = 0 Then
                Debug.Print "aOJO, MAPA 0"; .nombre; sel_cap; sel_part
                .Mapa = 1
            End If
            servermap = .Mapa
            
            'cambiarmapa
            svname = "Capitulo " & sel_cap & " Parte " & sel_part
            botsact = False
            mankismo = 2
            rondaa = 300
            valeestu = False
            atacaequipo = False
            valeinvi = False
            valeresu = False
            rondaact = False
            enviarank = True
            deathm = False
            fatuos = False
            passcerrado = vbNullString
            resuauto = False
            inmoact = True
            
            
            If serverrunning = True Then
                For i = 1 To LastNPC
                    If Npclist(i).Flags.NPCActive = True Then Call QuitarNPC(i)
                Next i
                For m = 1 To NumMaps
                    For X = 1 To MapSize
                        For Y = YMinMapSize To MapSize
                            tmp = MapData(m, X, Y).UserIndex
                            tmp1 = MapData(m, X, Y).NpcIndex
                            
                            MapData(m, X, Y) = MapDataBK(m, X, Y)
                            
                            MapData(m, X, Y).UserIndex = tmp
                            MapData(m, X, Y).NpcIndex = tmp1
                        Next Y
                    Next X
                    MapInfo(m) = MapInfoBK(map)
                Next m
            


                For i = 1 To .numnpcs
                    .npc(i).Index = SpawnNpc(.npc(i).tipo, .npc(i).nace, False, False)
                    Debug.Print "NPC"; i
                Next i
                
                Dim ET As obj
                ET.Amount = 1
                ET.ObjIndex = 378
                
                For i = 1 To .numtps
                    Call MakeObj(ET, .tps(i).Source.map, .tps(i).Source.X, .tps(i).Source.Y - 1)
                    MapData(.tps(i).Source.map, .tps(i).Source.X, .tps(i).Source.Y).TileExit = .tps(i).dest
                    Debug.Print "TP"; i
                Next i
                
            End If
        End With
        'BORRAR
    Else
        Debug.Print "ERTO"
    End If
End If
End Sub

Public Sub change_sel_camp(Optional ByVal cap As Integer = 0, Optional ByVal part As Integer = 0)
'    If cap = 0 Then cap = sel_cap
'    If part = 0 Then part = sel_part
'
'    With game_cfg.permisos
'        If (part > .mision And cap = .capitulo) Then part = .mision
'        If (part <= .mision And cap <= .capitulo) Or cap < .capitulo Then
'            sel_cap = cap
'            sel_part = part
'            frmCamp.Label1.Caption = "Jugar capitulo " & cap & " - Parte " & part
'            set_camp_permisos .capitulo, .mision, cap, part
'        End If
'    End With
End Sub

Public Sub set_camp_permisos(ByVal cap As Integer, ByVal part As Integer, Optional ByVal sel_cap As Integer, Optional ByVal sel_part As Integer)
'    Dim i%
'    If sel_cap = 0 Then sel_cap = cap
'    If sel_part = 0 Then sel_part = part
'    For i = 0 To cap - 1
'        frmCamp.capitulos(i).ForeColor = &H72899A
'        If sel_cap = i + 1 Then frmCamp.capitulos(i).ForeColor = &HC0E0FF
'    Next i
'    If sel_cap < cap Then part = 5
'    For i = 0 To 4
'        frmCamp.parte(i).ForeColor = &H2635&
'    Next i
'    For i = 0 To part - 1
'        frmCamp.parte(i).ForeColor = &H72899A
'        If sel_part = i + 1 Then frmCamp.parte(i).ForeColor = &HC0E0FF
'    Next i
End Sub
