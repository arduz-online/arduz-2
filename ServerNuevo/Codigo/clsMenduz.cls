VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsWebLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const BUFFER_LEN = 256

Public InetState As Boolean

Private Type Cole
    datos As String
    URL As String
    Encriptar As Boolean
    simplepost As Boolean
End Type

Private Cola() As Cole
Private Ultimo As Integer
Private total As Integer
Private ENCola As Integer

Private Type enviadox
    name As String
    users As Long 'String * 3
    Mapa As String
    pass As String
    rank As Integer
End Type

Private enviado As enviadox

Private ronda_envios As Integer

Public MAC_CRC As String
Public ClientID As Double
Public ClientIDs As String

Public ServerID As Double
Public ServerIDs As String

Private creardespues As Boolean


Private Enum WebPakets
    Web_Error = 32              '  ex ERN
    Web_Banned = 33             '!
    Web_Version_Incorrecta = 34 '"
    Web_Turn_Off = 35           '#
    Crear_OK = 36               '$
    Crear_Yata = 37             '%
    Ping_OK = 38                '&
    PEDIRNUEVO = 39             ''
    BORRA_OK = 40               '(
    SVIDNULL = 41               ') PING@NO
    UPD = 42                    '*
    Log_Pj = 43                 '+ PPJ
    intervalos = 44             ',
    pakete = 45                 '-
    Necesita_update = 46        '.
    NUEVOS_INTERVALOS = 47      '/
    NUEVO_BALANCE = 48          '0
    Balance = 49                '1
    BALANCE_ACTUALIZADO = 50    '2
    CONFIG_CLIENTE = 51         '3
    RecibeIDMAPA = 52           '4
'    pakete = 53 '5
'    pakete = 54 '6
'    pakete = 55 '7
'    pakete = 56 '8
'    pakete = 57 '9
'    pakete = 58 ':
'    pakete = 59 ';
'    pakete = 60 '<
'    pakete = 61 '=
'    pakete = 62 '>
'    pakete = 63 '?
'    pakete = 64 '@
'    pakete = 65 'A
'    pakete = 66 'B
'    pakete = 67 'C
'    pakete = 68 'D
'    pakete = 69 'E
'    pakete = 70 'F
'    pakete = 71 'G
'    pakete = 72 'H
'    pakete = 73 'I
'    pakete = 74 'J
'    pakete = 75 'K
'    pakete = 76 'L
'    pakete = 77 'M
'    pakete = 78 'N
'    pakete = 79 'O
'    pakete = 80 'P
'    pakete = 81 'Q
'    pakete = 82 'R
'    pakete = 83 'S
'    pakete = 84 'T
'    pakete = 85 'U
'    pakete = 86 'V
'    pakete = 87 'W
'    pakete = 88 'X
'    pakete = 89 'Y
'    pakete = 90 'Z
'    pakete = 91 '[
'    pakete = 92 '\
'    pakete = 93 ']
'    pakete = 94 '^
'    pakete = 95 '_
'    pakete = 96 '`
'    pakete = 97 'a
'    pakete = 98 'b
'    pakete = 99 'c
'    pakete = 100 'd
'    pakete = 101 'e
'    pakete = 102 'f
'    pakete = 103 'g
'    pakete = 104 'h
'    pakete = 105 'i
'    pakete = 106 'j
'    pakete = 107 'k
'    pakete = 108 'l
'    pakete = 109 'm
'    pakete = 110 'n
'    pakete = 111 'o
'    pakete = 112 'p
'    pakete = 113 'q
'    pakete = 114 'r
'    pakete = 115 's
'    pakete = 116 't
'    pakete = 117 'u
'    pakete = 118 'v
'    pakete = 119 'w
'    pakete = 120 'x
'    pakete = 121 'y
'    pakete = 122 'z
'    pakete = 123 '{
'    pakete = 124 '|
'    pakete = 125 '}
'    pakete = 126 '~
End Enum

Sub TryRequest()
    Dim tmp As Cole
    If ENCola > 0 Then
        If frmMain.WEBB.Puedo Then
            tmp = POP
            If Len(Cola(1).datos) > 0 Then
                If tmp.Encriptar Then
                    If tmp.simplepost Then
                        frmMain.WEBB.Send tmp.URL, tmp.datos, CStr(ServerID)
                    Else
                        frmMain.WEBB.Send tmp.URL, _
                        "datos=" & securemenduz(menduz & "~/*/" & criptox(tmp.datos, menduz)), CStr(ServerID)
                    End If
                    Debug.Print "POST>"; tmp.URL
                Else
                    frmMain.WEBB.Send tmp.datos, , CStr(ServerID)
                    'Debug.Print "GET>"; Cola(1).datos; CStr(ServerID)
                End If
            End If
        End If
    End If
    frmMain.WEBB.TryRequest
End Sub

Private Function POP() As Cole
  Dim i As Integer
    If ENCola > 0 Then
        POP = Cola(1)
        
        ENCola = ENCola - 1
        
        For i = 0 To ENCola
            Cola(i) = Cola(i + 1)
        Next i
        
        
        If ENCola < 0 Then ENCola = 0
        ReDim Preserve Cola(maxl(ENCola + 1, 1)) As Cole
    End If
End Function

Sub AddRequest(request As String)
If frmMain.ohlan.value = vbUnchecked Then
    ENCola = ENCola + 1
    ReDim Preserve Cola(ENCola + 1) As Cole
    Cola(ENCola).datos = request
    Cola(ENCola).Encriptar = False
End If
End Sub

Sub AddRequestEnc(request As String, URL As String, Optional ByVal simplepost As Boolean = False)
If frmMain.ohlan.value = vbUnchecked Then
    ENCola = ENCola + 1
    ReDim Preserve Cola(ENCola + 1) As Cole
    Cola(ENCola).datos = request
    Cola(ENCola).Encriptar = True
    Cola(ENCola).URL = URL
    Cola(ENCola).simplepost = simplepost
    TryRequest
End If
End Sub

Public Sub enviarpjs()
If menduz = "mzbbfdtt" Then Exit Sub
    ronda_envios = ronda_envios + 1
    Dim rob As String
    Dim i As Integer
    Dim delimiter As String
    delimiter = "~"
    For i = 1 To LastUser
        With UserList(i)
            If .ConnID <> -1 Then
                If .ConnIDValida And .Flags.UserLogged And Len(.passwd) > 0 And .passwd <> "NOTIENEPASSWD" Then
                    If Len(passcerrado) = 0 Then
                         rob = rob & i & delimiter & UserList(i).nick & delimiter & UserList(i).passwd & delimiter & UserList(i).pj_web & delimiter & UserList(i).Stats.puntosenv & delimiter & UserList(i).Stats.UsuariosMatadosenv & delimiter & UserList(i).Stats.muertesenv & delimiter & UserList(i).Stats.honorenv & delimiter & ci2hex(UserList(i).ClientID) & "@"
                        .Stats.UsuariosMatadosenv = 0
                        .Stats.muertesenv = 0
                        .Stats.puntosenv = 0
                        '.Stats.honor = 0
                        .Stats.honorenv = 0
                    Else
                         rob = rob & i & delimiter & UserList(i).nick & delimiter & UserList(i).passwd & delimiter & UserList(i).pj_web & delimiter & "0" & delimiter & "0" & delimiter & "0" & delimiter & "0" & delimiter & "0@"
                        .Stats.UsuariosMatadosenv = 0
                        .Stats.muertesenv = 0
                        .Stats.puntosenv = 0
                        .Stats.honorenv = 0
                    End If
                End If
            End If
        End With
    Next i
    If Len(rob) > 1 Then
        AddRequestEnc rob, "users_upd"
    Else
        PingToWeb
    End If
End Sub

Sub enviar1pj(i As Integer)
    If menduz = "mzbbfdtt" Then Exit Sub
    Dim delimiter As String
    delimiter = "~"
        With UserList(i)
            If .ConnID <> -1 Then
                If .ConnIDValida = True And .Flags.UserLogged = True And Len(.passwd) > 0 And .passwd <> "NOTIENEPASSWD" Then
                    AddRequestEnc i & delimiter & UserList(i).nick & delimiter & UserList(i).passwd & delimiter & ci2hex(UserList(i).ClientID) & delimiter, "users_login"
                    Call WriteMensaje_Web(i, 64)
                    .Stats.UsuariosMatadosenv = 0
                    .Stats.muertesenv = 0
                    .Stats.puntosenv = 0
                    .Stats.honorenv = 0
                End If
            End If
        End With
End Sub

Public Sub HandleIncommingWebData(ByVal Data As String)
    Dim paquete         As Byte
    Dim incomming_data  As String
    Dim tiene           As Byte
    Dim i               As Byte
    Dim uid             As Integer
    Dim tmp()           As String
    Dim tstr            As String
    Dim max             As Integer
    Dim j               As Integer
    Dim tmp1()          As String
    Dim K%, l%, pjc%, itemslot%, ias%, iaa%
    Dim intervalos() As String
    
    Dim obj As Integer
    
    incomming_data = Data
    Do
        If Len(incomming_data) = 0 Then Exit Do
        paquete = AscB(mid$(incomming_data, 1, 1))
        incomming_data = Right$(incomming_data, Len(incomming_data) - 1)
        tiene = (paquete >= 32 And paquete <= 50)
        

        If Not tiene Then Exit Do
        
        Select Case paquete
        Case WebPakets.Necesita_update
            If MsgBox("Hay una nueva actualización para el juego. ¿Descargar?", vbYesNo) = vbYes Then
                Call ShellExecute(0, "Open", "AutoUpdate.exe", "", app.Path, 0)
            End If
            End
        Case WebPakets.Web_Error
            LogError "WEB: " & incomming_data
            
        Case WebPakets.Crear_OK
            menduz = ReadNextDato(incomming_data)
            ServerID = val(ReadNextDato(incomming_data))
            creardespues = False
            Debug.Print "KEYSEC>" & menduz
            PrdirIntervalos
            OFICIAL = 1 'IIf(Val(ReadNextDato(incomming_data)) > 0, 1, 0)
            If OFICIAL = 1 Then
                For i = 21 To 50
                    frmMain.maxu.AddItem i & " Jugadores"
                Next i
                frmMain.maxu.Enabled = True
                frmMain.Caption = frmMain.Caption & " - ¡OFICIAL!"
                frmMain.sulog.value = vbChecked
                frmMain.sulog.Visible = True
            End If
            
        Case WebPakets.BORRA_OK
            If creardespues = True Then Call CrearServerWeb
            If closebool = True Then closeprogram
            
        Case WebPakets.Crear_Yata
            ServerID = val(ReadNextDato(incomming_data))
            menduz = ReadNextDato(incomming_data)
            Debug.Print "KEYSEC>" & menduz
            'creardespues = True
            'Call BorrarServerWeb
            
        Case WebPakets.Ping_OK
            menduz = ReadNextDato(incomming_data)
            'frmMain.sosputo
            Call InitIpTables(maxusers)
            IpSecurityMantenimientoLista
            Debug.Print "KEYSEC>" & menduz
            
        Case WebPakets.SVIDNULL
            Call CrearServerWeb
            
        Case WebPakets.intervalos
            intervalos = Split(ReadNextDato(incomming_data), "|")
            Rem ATTACK=1301|ARROWS=1151|CAST_SPELL=1151|CAST_ATTACK=1151|WORK=701|USEITEMU=221|USEITEMDCK=205|SENTRPU=2001
            For i = 0 To UBound(intervalos)
                If i < 8 Then inthack(i) = CInt(intervalos(i))
            Next i

        Case WebPakets.Balance
            #If MENDUZ_PC = 1 Then
            Dim ttt As String
            ttt = incomming_data
            modZLib.Resource_Create_sdf incomming_data, app.Path & "\Datos\", "balance.ini"
            incomming_data = ttt
            pharse_balance ttt
            LogGM "balanced", "Se descargó el balance """ & balance_md5 & """"
            LogCriticEvent "Se descargó el balance """ & balance_md5 & """"
            Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Balance actualizado.", FontTypeNames.FONTTYPE_TALK))
            #Else
            Dim ttt As String
            ttt = incomming_data
            Resource_Create_sdf incomming_data, app.Path & "\Datos\DatosServer\", "balance.ini"
            incomming_data = ttt
            pharse_balance ttt
            LogGM "balanced", "Se descargó el balance """ & balance_md5 & """"
            LogCriticEvent "Se descargó el balance """ & balance_md5 & """"
            Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Balance actualizado.", FontTypeNames.FONTTYPE_TALK))
            #End If

        Case WebPakets.BALANCE_ACTUALIZADO
            Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Balance OK.", FontTypeNames.FONTTYPE_TALK))
            LogGM "balanced", "El balance """ & balance_md5 & """ está actualizado"
            
        Case WebPakets.PEDIRNUEVO
            If Len(incomming_data) > 3 Then
                LogCriticEvent "OLDKEYSEC>" & ReadNextDato(incomming_data)
                menduz = ReadNextDato(incomming_data)
                'frmMain.sosputo
                Call InitIpTables(maxusers)
                IpSecurityMantenimientoLista
                LogCriticEvent "NEWKEYSEC>" & menduz
            End If
            PingToWeb
            
        Case WebPakets.UPD
            menduz = ReadNextDato(incomming_data)
            Debug.Print "KEYSEC>" & menduz
            max = val(ReadNextDato(incomming_data))
            For i = 1 To max
                tstr = ReadNextDato(incomming_data)
                If Len(tstr) = 0 Then Exit For
                tmp = Split(tstr, "-")
                uid = val(tmp(0))
                j = val(tmp(1))
                If uid Then
                    If j = 9 Then
                        j = 1
                        enviar1pj uid
                    End If
                    If j > 0 Then
                        Call WriteMensaje_Web(uid, j)
                    Else
                        UserList(uid).registrado = False
                        UserList(uid).dios = 0
                        UserList(uid).modName = vbNullString
                    End If
    
                    If j <> 3 And j <> 2 And j <> 0 Then
                        UserList(uid).registrado = True
                    End If
                    'Debug.Print "AVISADO"; uid; ">"; j
                End If
            Next i
        Case WebPakets.Log_Pj
            uid = val(ReadNextDato(incomming_data))
            i = val(ReadNextDato(incomming_data))
            
            If i > 0 Then Call WriteMensaje_Web(uid, i)
            
            UserList(uid).dios = 0
            UserList(uid).modName = vbNullString
            
            If i = 1 Or i = 4 Then
                tstr = ReadNextDato(incomming_data)
                tmp = Split(tstr, "r")
                UserList(uid).dios = val(tmp(0))
                If UBound(tmp) > 0 Then
                    UserList(uid).Wrank = val(tmp(1))
                End If
                If UBound(tmp) > 1 Then
                    UserList(uid).Stats.honor = val(tmp(2))
                End If
                UserList(uid).registrado = True
            ElseIf i = 5 Then
                UserList(uid).registrado = True
            Else
                UserList(uid).registrado = False
            End If
            
            If (BS_Byte_Get(UserList(uid).dios, dioses.AdminOfis) = True) And (OFICIAL = 1) Then
                UserList(uid).admin = True
            End If
            
            max = val(ReadNextDato(incomming_data))
            
            For i = 1 To max
                tstr = ReadNextDato(incomming_data)
                
                If Len(tstr) = 0 Then Exit For
                tmp = Split(tstr, "|")
                If tmp(0) = "PJ" Then
                    pjc = pjc + 1
                    With UserList(uid).web_pjs(pjc)
                        .ID = val(tmp(1))
                        .name = tmp(2)
                        .clan = tmp(3)
                        .vidaup = val(tmp(4))
                        .raza = CInt(val(tmp(5)))
                        .clase = CInt(val(tmp(6)))
                        .cabeza = CInt(val(tmp(7)))
                        .genero = CInt(val(tmp(8)))
                        .Faccion = CInt(val(tmp(9)))
                        .cuerpo = darbody(.genero, .raza)
                        .casco = 0
                        .Arma = 0
                        
                        tmp1 = Split(tmp(10), ":")
                        .items_count = 0
                        itemslot = 1
                        
                        .items(itemslot).ObjIndex = 37
                        .items(itemslot).Flags = 0
                        .items(itemslot).Amount = 1
                        .items(itemslot).Equipped = 0
                        itemslot = 2
                        .items(itemslot).ObjIndex = 38
                        .items(itemslot).Flags = 0
                        .items(itemslot).Amount = 1
                        .items(itemslot).Equipped = 0
                        .items_count = 2
                        For ias = 0 To UBound(tmp1)
                            If InStr(1, tmp1(ias), " ") Then
                                If IsNumeric(ReadField(1, tmp1(ias), 32)) = True Then
                                If itemslot = 16 Then Exit For
                                    itemslot = itemslot + 1
                                    .items(itemslot).ObjIndex = CInt(ReadField(1, tmp1(ias), 32))
                                    
                                    On Local Error Resume Next
                                    .items(itemslot).Flags = CLng("&H" & ReadField(2, tmp1(ias), 32))
                                    On Local Error GoTo 0
                                    
                                    .items(itemslot).Amount = 1
                                    .items(itemslot).Equipped = 0
                                    obj = .items(itemslot).ObjIndex
                                    
                                    If ClasePuedeUsarItemA(.clase, obj) Then
                                        If ObjData(obj).CascoAnim <> 0 Then
                                            .casco = ObjData(obj).CascoAnim
                                        Else
                                            If ObjData(obj).Ropaje > 0 Then
                                                If .genero = 2 And ObjData(obj).Ropaje_mina > 0 Then
                                                    .cuerpo = ObjData(obj).Ropaje_mina
                                                Else
                                                    .cuerpo = ObjData(obj).Ropaje
                                                End If
                                            End If
                                        End If
                                    
                                        If ObjData(obj).ShieldAnim <> 0 Then
                                            .Escudo = ObjData(obj).ShieldAnim
                                        End If
                                        If ObjData(obj).WeaponAnim <> 0 Then
                                            .Arma = ObjData(obj).WeaponAnim
                                        End If
                                    End If
                                    
                                    .items_count = .items_count + 1
                                End If
                            End If
                        Next ias
                        
                    End With
                Else
                    MsgBox "CATASTROFE EN PJ_LOGIN"
                    'Debug.Assert tmp(0) = "PJ"
                End If
                UserList(uid).web_pjs_count = pjc
            Next i
            Call Protocol.WritePJS(uid)
            UserList(uid).pj_web = 0
        Case Else
            tiene = False
        End Select
    Loop While tiene
End Sub

Private Function ReadNextDato(ByRef sText As String, Optional delimitera As String = "~ç~") As String
Dim K As Long
K = InStr(sText, delimitera)
If K > 0 Then
    ReadNextDato = Left$(sText, K - 1)
    sText = mid$(sText, K + Len(delimitera), Len(sText) - K + Len(delimitera))
Else
    ReadNextDato = sText
    sText = vbNullString
End If
End Function

Private Function ReadNextPaquete(ByRef sText As String, ByVal delimitera As String) As String
Dim K As Long
Dim p As Long
Dim lena As Long
lena = Len(sText)
K = InStr(sText, delimitera)

If K > 0 And lena > 0 Then
    p = InStr(mid$(sText, 2, lena - 1), delimitera)
    If p Then
        ReadNextPaquete = mid$(sText, 1, p)
        sText = mid$(sText, p + 1, lena - p)
    Else
        ReadNextPaquete = sText
        sText = vbNullString
    End If
Else
    ReadNextPaquete = sText
    sText = vbNullString
End If

End Function

Public Sub PingToWeb()
    If serverrunning = True Then
        TryRequest
        Dim TEMPSTR As String
        Dim delimiter As String
        Dim result As String
        delimiter = "~"
        
        result = Replace(Replace(svname, delimiter, ""), "=", "")
        If enviado.name <> result Then
            TEMPSTR = "N=" & result
            enviado.name = result
        End If
        result = Replace(Replace(frmMain.mapax.List(servermap - 1), delimiter, ""), "=", "")
        If enviado.Mapa <> result Then
            If OFICIAL = 1 Then
                result = "OFICIAL: " & result
                TEMPSTR = TEMPSTR & delimiter & "M=" & result
                enviado.Mapa = result
            Else
                TEMPSTR = TEMPSTR & delimiter & "M=" & result
                enviado.Mapa = result
            End If
        End If
        
        If enviado.users <> NumUsers Then
            TEMPSTR = TEMPSTR & delimiter & "U=" & STR$(NumUsers + Cantidad_Bots)
            enviado.users = NumUsers + Cantidad_Bots
        End If
        
        result = Replace(Replace(passcerrado, delimiter, ""), "=", "")
        If enviado.pass <> result Then
            TEMPSTR = TEMPSTR & delimiter & "P=" & result
            enviado.pass = result
        End If
        result = ""
        If LenB(TEMPSTR) > 0 Then
            result = securemenduz(TEMPSTR)
            AddRequestEnc "datos=" & result, "server_ping", True
        Else
            'AddRequestEnc "", "server_ping", True
            frmMain.WEBB.Send "server_ping", "", CStr(ServerID)
        End If
    End If

End Sub

Public Sub CrearServerWeb()
    If serverrunning = True Then
        Dim TEMPSTR As String
        Dim delimiter As String
        Dim result As String
        delimiter = "~"
        TEMPSTR = Replace(svname, delimiter, "") & delimiter & Replace(frmMain.mapax.List(servermap - 1), delimiter, "") & delimiter & NumUsers & delimiter & Puerto & delimiter & hIP & delimiter & ULTIMAVERSION & delimiter & maxusers & delimiter & passcerrado
        AddRequestEnc "datos=" & securemenduz(TEMPSTR), "server_crear", True
    End If
End Sub

Public Sub PrdirIntervalos()
    If serverrunning = True Then AddRequestEnc "cs=" & balance_md5, "balance_getint", True
End Sub

Public Sub BorrarServerWeb()
    If serverrunning = True Then AddRequest "server_borra"
End Sub

Private Function GetUrlSource(sURL As String) As String
    Dim sBuffer As String * BUFFER_LEN, iResult As Integer, sData As String
    Dim hInternet As Long, hSession As Long, lReturn As Long
hSession = InternetOpen("vb wininet", 1, vbNullString, vbNullString, 0)
    If hSession Then hInternet = InternetOpenUrl(hSession, sURL, vbNullString, 0, IF_NO_CACHE_WRITE, 0)
    If hInternet Then
        iResult = InternetReadFile(hInternet, sBuffer, BUFFER_LEN, lReturn)
        sData = sBuffer
        Do While lReturn <> 0
            iResult = InternetReadFile(hInternet, sBuffer, BUFFER_LEN, lReturn)
            sData = sData + mid(sBuffer, 1, lReturn)
        Loop
    End If
   
    iResult = InternetCloseHandle(hInternet)
    GetUrlSource = sData
End Function

Public Sub request_mac_crc()

    AddRequest "cam_REQ/" '& sBase64Encode(mac_get)
End Sub

Private Function darbody(ByVal genero As Integer, ByVal raza As Integer) As Integer
    Dim CuerpoDesnudo As Integer

    If genero = 2 Then
        Select Case raza
            Case eRaza.Humano
                CuerpoDesnudo = 39
            Case eRaza.Drow
                CuerpoDesnudo = 40
            Case eRaza.Elfo
                CuerpoDesnudo = 259
            Case eRaza.Gnomo
                CuerpoDesnudo = 260
            Case eRaza.Enano
                CuerpoDesnudo = 60
        End Select
    Else
        Select Case raza
            Case eRaza.Humano
                CuerpoDesnudo = 21
            Case eRaza.Drow
                CuerpoDesnudo = 32
            Case eRaza.Elfo
                CuerpoDesnudo = 210
            Case eRaza.Gnomo
                CuerpoDesnudo = 222
            Case eRaza.Enano
                CuerpoDesnudo = 53
        End Select
    End If

darbody = CuerpoDesnudo

End Function

Public Sub cheating(ByVal nick As String, ByVal txt As String, ByVal ID As Double)
    Dim tmpstr$
    tmpstr = ci2hex(ID)
    frmMain.WEBB.Send "log_LOG", "datos=" & securemenduz(nick & "~" & txt & "~" & tmpstr), CStr(ServerID) & "_" & menduz
    Call LogError("NAC>" & nick & " - " & txt)
End Sub

Private Sub Class_Initialize()
    ClientID = get_pc_id
    ClientIDs = ci2hex(ClientID)
    ReDim Cola(2)
End Sub
