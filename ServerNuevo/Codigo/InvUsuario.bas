Attribute VB_Name = "InvUsuario"
Option Explicit

Public Function TieneObjetosRobables(ByVal UserIndex As Integer) As Boolean

'17/09/02
'Agregue que la función se asegure que el objeto no es un barco

On Error Resume Next

Dim i As Integer
Dim ObjIndex As Integer

For i = 1 To MAX_INVENTORY_SLOTS
    ObjIndex = UserList(UserIndex).Invent.Object(i).ObjIndex
    If ObjIndex > 0 Then
            If (ObjData(ObjIndex).OBJType <> eOBJType.otLlaves And _
                ObjData(ObjIndex).OBJType <> eOBJType.otBarcos) Then
                  TieneObjetosRobables = True
                  Exit Function
            End If
    
    End If
Next i


End Function

Function ClasePuedeUsarItem(ByVal UserIndex As Integer, ByVal ObjIndex As Integer) As Boolean
On Error GoTo manejador

'Call LogTarea("ClasePuedeUsarItem")

'Dim flag As Boolean

'Admins can use ANYTHING!
If (UserList(UserIndex).dios And dioses.SuperDios) Then
Else
    If ObjData(ObjIndex).ClaseProhibida(1) <> 0 Then
        Dim i As Integer
        For i = 1 To NUMCLASES
            If ObjData(ObjIndex).ClaseProhibida(i) = UserList(UserIndex).clase Then
                ClasePuedeUsarItem = False
                Exit Function
            End If
        Next i
    End If
End If

ClasePuedeUsarItem = True

Exit Function

manejador:
    LogError ("Error en ClasePuedeUsarItem")
End Function

Function ClasePuedeUsarItemA(ByVal clase As Integer, ByVal ObjIndex As Integer) As Boolean
On Error GoTo manejador

'Call LogTarea("ClasePuedeUsarItem")

'Dim flag As Boolean

If ObjData(ObjIndex).ClaseProhibida(1) <> 0 Then
    Dim i As Integer
    For i = 1 To NUMCLASES
        If ObjData(ObjIndex).ClaseProhibida(i) = clase Then
            ClasePuedeUsarItemA = False
            Exit Function
        End If
    Next i
End If

ClasePuedeUsarItemA = True

Exit Function

manejador:
    LogError ("Error en ClasePuedeUsarItemA")
End Function

Sub LimpiarInventario(ByVal UserIndex As Integer)


Dim j As Integer
For j = 1 To MAX_INVENTORY_SLOTS
        UserList(UserIndex).Invent.Object(j).ObjIndex = 0
        UserList(UserIndex).Invent.Object(j).Amount = 0
        UserList(UserIndex).Invent.Object(j).Equipped = 0
Next j

UserList(UserIndex).Invent.NroItems = 0

UserList(UserIndex).Invent.ArmourEqpObjIndex = 0
UserList(UserIndex).Invent.ArmourEqpSlot = 0

UserList(UserIndex).Invent.WeaponEqpObjIndex = 0
UserList(UserIndex).Invent.WeaponEqpSlot = 0

UserList(UserIndex).Invent.CascoEqpObjIndex = 0
UserList(UserIndex).Invent.CascoEqpSlot = 0

UserList(UserIndex).Invent.EscudoEqpObjIndex = 0
UserList(UserIndex).Invent.EscudoEqpSlot = 0

UserList(UserIndex).Invent.AnilloEqpObjIndex = 0
UserList(UserIndex).Invent.AnilloEqpSlot = 0

UserList(UserIndex).Invent.MunicionEqpObjIndex = 0
UserList(UserIndex).Invent.MunicionEqpSlot = 0

UserList(UserIndex).Invent.BarcoObjIndex = 0
UserList(UserIndex).Invent.BarcoSlot = 0

For j = 1 To MAX_INVENTORY_SLOTS
        UserList(UserIndex).OldInvent.Object(j).ObjIndex = 0
        UserList(UserIndex).OldInvent.Object(j).Amount = 0
        UserList(UserIndex).OldInvent.Object(j).Equipped = 0
Next j

UserList(UserIndex).OldInvent.NroItems = 0

UserList(UserIndex).OldInvent.ArmourEqpObjIndex = 0
UserList(UserIndex).OldInvent.ArmourEqpSlot = 0

UserList(UserIndex).OldInvent.WeaponEqpObjIndex = 0
UserList(UserIndex).OldInvent.WeaponEqpSlot = 0

UserList(UserIndex).OldInvent.CascoEqpObjIndex = 0
UserList(UserIndex).OldInvent.CascoEqpSlot = 0

UserList(UserIndex).OldInvent.EscudoEqpObjIndex = 0
UserList(UserIndex).OldInvent.EscudoEqpSlot = 0

UserList(UserIndex).OldInvent.AnilloEqpObjIndex = 0
UserList(UserIndex).OldInvent.AnilloEqpSlot = 0

UserList(UserIndex).OldInvent.MunicionEqpObjIndex = 0
UserList(UserIndex).OldInvent.MunicionEqpSlot = 0

UserList(UserIndex).OldInvent.BarcoObjIndex = 0
UserList(UserIndex).OldInvent.BarcoSlot = 0

End Sub

Sub QuitarUserInvItem(ByVal UserIndex As Integer, ByVal Slot As Byte, ByVal Cantidad As Integer)
    If Slot < 1 Or Slot > MAX_INVENTORY_SLOTS Then Exit Sub
    
    With UserList(UserIndex).Invent.Object(Slot)
        If .Amount <= Cantidad And .Equipped = 1 Then
            Call Desequipar(UserIndex, Slot)
        End If
        
        'Quita un objeto
        .Amount = .Amount - Cantidad
        '¿Quedan mas?
        If .Amount <= 0 Then
            UserList(UserIndex).Invent.NroItems = UserList(UserIndex).Invent.NroItems - 1
            .ObjIndex = 0
            .Amount = 0
        End If
    End With
End Sub

Sub UpdateUserInv(ByVal UpdateAll As Boolean, ByVal UserIndex As Integer, ByVal Slot As Byte)

Dim NullObj As UserOBJ
Dim loopc As Long

'Actualiza un solo slot
If Not UpdateAll Then

    'Actualiza el inventario
    If UserList(UserIndex).Invent.Object(Slot).ObjIndex > 0 Then
        Call ChangeUserInv(UserIndex, Slot, UserList(UserIndex).Invent.Object(Slot))
    Else
        Call ChangeUserInv(UserIndex, Slot, NullObj)
    End If

Else

'Actualiza todos los slots
    For loopc = 1 To MAX_INVENTORY_SLOTS
        'Actualiza el inventario
        If UserList(UserIndex).Invent.Object(loopc).ObjIndex > 0 Then
            Call ChangeUserInv(UserIndex, loopc, UserList(UserIndex).Invent.Object(loopc))
        Else
            Call ChangeUserInv(UserIndex, loopc, NullObj)
        End If
    Next loopc
    WriteInvEQUIPED UserIndex
End If

End Sub

Sub EraseObj(ByVal Num As Integer, ByVal map As Integer, ByVal x As Integer, ByVal y As Integer)

MapData(map, x, y).ObjInfo.Amount = MapData(map, x, y).ObjInfo.Amount - Num

If MapData(map, x, y).ObjInfo.Amount <= 0 Then
    MapData(map, x, y).ObjInfo.ObjIndex = 0
    MapData(map, x, y).ObjInfo.Amount = 0
    
    Call modSendData.SendToAreaByPos(map, x, y, PrepareMessageObjectDelete(x, y))
End If

End Sub

Sub MakeObj(ByRef obj As obj, ByVal map As Integer, ByVal x As Integer, ByVal y As Integer)

If obj.ObjIndex > 0 And obj.ObjIndex <= UBound(ObjData) Then

    If MapData(map, x, y).ObjInfo.ObjIndex = obj.ObjIndex Then
        MapData(map, x, y).ObjInfo.Amount = MapData(map, x, y).ObjInfo.Amount + obj.Amount
    Else
        MapData(map, x, y).ObjInfo = obj
        
        Call modSendData.SendToAreaByPos(map, x, y, PrepareMessageObjectCreate(ObjData(obj.ObjIndex).GrhIndex, x, y))
    End If
End If

End Sub

Function MeterItemEnInventario(ByVal UserIndex As Integer, ByRef MiObj As obj) As Boolean
On Error GoTo ErrHandler

'Call LogTarea("MeterItemEnInventario")
 
'Dim x As Integer
'Dim y As Integer
Dim Slot As Byte

'¿el user ya tiene un objeto del mismo tipo?
Slot = 1
Do Until UserList(UserIndex).Invent.Object(Slot).ObjIndex = MiObj.ObjIndex And _
         UserList(UserIndex).Invent.Object(Slot).Amount + MiObj.Amount <= MAX_INVENTORY_OBJS
   Slot = Slot + 1
   If Slot > MAX_INVENTORY_SLOTS Then
         Exit Do
   End If
Loop
    
'Sino busca un slot vacio
If Slot > MAX_INVENTORY_SLOTS Then
   Slot = 1
   Do Until UserList(UserIndex).Invent.Object(Slot).ObjIndex = 0
       Slot = Slot + 1
       If Slot > MAX_INVENTORY_SLOTS Then
           Call WriteConsoleMsg(UserIndex, "No podes cargar mas objetos.", FontTypeNames.FONTTYPE_FIGHT)
           MeterItemEnInventario = False
           Exit Function
       End If
   Loop
   UserList(UserIndex).Invent.NroItems = UserList(UserIndex).Invent.NroItems + 1
End If
    
'Mete el objeto
If UserList(UserIndex).Invent.Object(Slot).Amount + MiObj.Amount <= MAX_INVENTORY_OBJS Then
   'Menor que MAX_INV_OBJS
   UserList(UserIndex).Invent.Object(Slot).ObjIndex = MiObj.ObjIndex
   UserList(UserIndex).Invent.Object(Slot).Amount = UserList(UserIndex).Invent.Object(Slot).Amount + MiObj.Amount
Else
   UserList(UserIndex).Invent.Object(Slot).Amount = MAX_INVENTORY_OBJS
End If
    
MeterItemEnInventario = True
       
Call UpdateUserInv(False, UserIndex, Slot)


Exit Function
ErrHandler:

End Function


Sub GetObj(ByVal UserIndex As Integer)

Dim obj As ObjData
Dim MiObj As obj

'¿Hay algun obj?
If MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y).ObjInfo.ObjIndex > 0 Then
    '¿Esta permitido agarrar este obj?
    If ObjData(MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y).ObjInfo.ObjIndex).Agarrable <> 1 Then
        Dim x As Integer
        Dim y As Integer
'        Dim Slot As Byte
        
        x = UserList(UserIndex).Pos.x
        y = UserList(UserIndex).Pos.y
        obj = ObjData(MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y).ObjInfo.ObjIndex)
        MiObj.Amount = MapData(UserList(UserIndex).Pos.map, x, y).ObjInfo.Amount
        MiObj.ObjIndex = MapData(UserList(UserIndex).Pos.map, x, y).ObjInfo.ObjIndex
        
        If Not MeterItemEnInventario(UserIndex, MiObj) Then
            'Call WriteConsoleMsg(UserIndex, "No puedo cargar mas objetos.", FontTypeNames.FONTTYPE_INFO)
        Else
            'Quitamos el objeto
            Call EraseObj(MapData(UserList(UserIndex).Pos.map, x, y).ObjInfo.Amount, UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y)

            'Log de Objetos que se agarran del piso. Pablo (ToxicWaste) 07/09/07
            'Es un Objeto que tenemos que loguear?
            If ObjData(MiObj.ObjIndex).Log = 1 Then
                Call LogDesarrollo(UserList(UserIndex).name & " juntó del piso " & MiObj.Amount & " " & ObjData(MiObj.ObjIndex).name)
            ElseIf MiObj.Amount = 1000 Then 'Es mucha cantidad?
                'Si no es de los prohibidos de loguear, lo logueamos.
                If ObjData(MiObj.ObjIndex).NoLog <> 1 Then
                    Call LogDesarrollo(UserList(UserIndex).name & " juntó del piso " & MiObj.Amount & " " & ObjData(MiObj.ObjIndex).name)
                End If
            End If
            
        End If
        
    End If
Else
    Call WriteConsoleMsg(UserIndex, "No hay nada aqui.", FontTypeNames.FONTTYPE_INFO)
End If

End Sub

Sub Desequipar(ByVal UserIndex As Integer, ByVal Slot As Byte)
'Desequipa el item slot del inventario
Dim obj As ObjData
'[MODIFICADO] A pedido de Ares los users INVITADOS no se pueden desequipar cosas (puse que este vivo porque talves se buguea)
If UserList(UserIndex).flags.Muerto = 0 And UserList(UserIndex).registrado = False Then Exit Sub
'[/MODIFICADO] A pedido de Ares los users INVITADOS no se pueden desequipar cosas (puse que este vivo porque talves se buguea)

If (Slot < LBound(UserList(UserIndex).Invent.Object)) Or (Slot > UBound(UserList(UserIndex).Invent.Object)) Then
    Exit Sub
ElseIf UserList(UserIndex).Invent.Object(Slot).ObjIndex = 0 Then
    Exit Sub
End If

obj = ObjData(UserList(UserIndex).Invent.Object(Slot).ObjIndex)

Select Case obj.OBJType
    Case eOBJType.otWeapon
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.WeaponEqpObjIndex = 0
        UserList(UserIndex).Invent.WeaponEqpSlot = 0
        If Not UserList(UserIndex).flags.Mimetizado = 1 Then
            UserList(UserIndex).Char.WeaponAnim = NingunArma
            Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
        '[MODIFICADO] 2/2/10 Auque no se use el mimetismo, lo pongo, esto faltaba en DESEQUIPAR al arreglarlo.
        Else
            UserList(UserIndex).CharMimetizado.WeaponAnim = NingunArma
        End If
        '[/MODIFICADO] 2/2/10
    
    Case eOBJType.otFlechas
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.MunicionEqpObjIndex = 0
        UserList(UserIndex).Invent.MunicionEqpSlot = 0
    
    Case eOBJType.otAnillo
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.AnilloEqpObjIndex = 0
        UserList(UserIndex).Invent.AnilloEqpSlot = 0
    
    Case eOBJType.otArmadura
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.ArmourEqpObjIndex = 0
        UserList(UserIndex).Invent.ArmourEqpSlot = 0
        '[MODIFICADO] 2/2/10 Auque no se use el mimetismo, lo pongo, esto faltaba en DESEQUIPAR al arreglarlo.
        Call DarCuerpoDesnudo(UserIndex, UserList(UserIndex).flags.Mimetizado = 1)
        
        If Not UserList(UserIndex).flags.Mimetizado = 1 Then
            Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
        End If
        '[/MODIFICADO] 2/2/10
    Case eOBJType.otCASCO
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.CascoEqpObjIndex = 0
        UserList(UserIndex).Invent.CascoEqpSlot = 0
        If Not UserList(UserIndex).flags.Mimetizado = 1 Then
            UserList(UserIndex).Char.CascoAnim = NingunCasco
            Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
        '[MODIFICADO] 2/2/10 Auque no se use el mimetismo, lo pongo, esto faltaba en DESEQUIPAR al arreglarlo.
        Else
            UserList(UserIndex).CharMimetizado.CascoAnim = NingunCasco
        End If
        '[/MODIFICADO] 2/2/10
    Case eOBJType.otESCUDO
        UserList(UserIndex).Invent.Object(Slot).Equipped = 0
        UserList(UserIndex).Invent.EscudoEqpObjIndex = 0
        UserList(UserIndex).Invent.EscudoEqpSlot = 0
        If Not UserList(UserIndex).flags.Mimetizado = 1 Then
            UserList(UserIndex).Char.ShieldAnim = NingunEscudo
            Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
        '[MODIFICADO] 2/2/10 Auque no se use el mimetismo, lo pongo, esto faltaba en DESEQUIPAR al arreglarlo.
        Else
            UserList(UserIndex).CharMimetizado.ShieldAnim = NingunEscudo
        End If
        '[/MODIFICADO] 2/2/10
End Select
Call WriteUpdateUserStats(UserIndex)
Call UpdateUserInv(False, UserIndex, Slot)
WriteInvEQUIPED UserIndex
End Sub

Function SexoPuedeUsarItem(ByVal UserIndex As Integer, ByVal ObjIndex As Integer) As Boolean
On Error GoTo ErrHandler

If ObjData(ObjIndex).Mujer = 1 Then
    SexoPuedeUsarItem = UserList(UserIndex).genero <> eGenero.Hombre
ElseIf ObjData(ObjIndex).Hombre = 1 Then
    SexoPuedeUsarItem = UserList(UserIndex).genero <> eGenero.Mujer
Else
    SexoPuedeUsarItem = True
End If

Exit Function
ErrHandler:
    Call LogError("SexoPuedeUsarItem")
End Function
'[MODIFICADO] AutoEquiparse
Public Sub EquiparTodo(ByVal UserIndex As Integer)
On Error GoTo err:
    Debug.Print "EquiparTodo"
    Dim i As Integer

    For i = 1 To 20
        If UserList(UserIndex).Invent.Object(i).ObjIndex <> 0 Then
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otArmadura And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.ArmourEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otCASCO And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.CascoEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otESCUDO And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.EscudoEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otAnillo And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.AnilloEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otFlechas And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.MunicionEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
            If ObjData(UserList(UserIndex).Invent.Object(i).ObjIndex).OBJType = eOBJType.otWeapon And UserList(UserIndex).Invent.Object(i).Equipped = 0 And UserList(UserIndex).Invent.WeaponEqpObjIndex = 0 Then
                Call EquiparInvItem(UserIndex, i)
            End If
        End If
    Next i
    Exit Sub
        If UserList(UserIndex).OldInvent.ArmourEqpObjIndex > 0 And UserList(UserIndex).Invent.ArmourEqpObjIndex = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.ArmourEqpSlot)
        End If
        'EquiparInvItem arma
        If UserList(UserIndex).OldInvent.WeaponEqpObjIndex > 0 And UserList(UserIndex).Invent.WeaponEqpObjIndex = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.WeaponEqpSlot)
        End If
        'EquiparInvItem casco
        If UserList(UserIndex).OldInvent.CascoEqpObjIndex > 0 And UserList(UserIndex).Invent.CascoEqpObjIndex = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.CascoEqpSlot)
        End If
        'EquiparInvItem herramienta
        If UserList(UserIndex).OldInvent.AnilloEqpSlot > 0 And UserList(UserIndex).Invent.AnilloEqpSlot = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.AnilloEqpSlot)
        End If
        'EquiparInvItem municiones
        If UserList(UserIndex).OldInvent.MunicionEqpObjIndex > 0 And UserList(UserIndex).Invent.MunicionEqpObjIndex = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.MunicionEqpSlot)
        End If
        'EquiparInvItem escudo
        If UserList(UserIndex).OldInvent.EscudoEqpObjIndex > 0 And UserList(UserIndex).Invent.EscudoEqpObjIndex = 0 Then
            Call EquiparInvItem(UserIndex, UserList(UserIndex).OldInvent.EscudoEqpSlot)
        End If
Exit Sub
err:
End Sub
'[/MODIFICADO] AutoEquiparse
Sub EquiparInvItem(ByVal UserIndex As Integer, ByVal Slot As Byte)
On Error GoTo ErrHandler

'Equipa un item del inventario
Dim obj As ObjData
Dim ObjIndex As Integer

ObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
obj = ObjData(ObjIndex)
Debug.Print "Objeto: " & ObjIndex & " - Slot: " & Slot
Select Case obj.OBJType
    Case eOBJType.otWeapon
       If ClasePuedeUsarItem(UserIndex, ObjIndex) Then
            'Si esta equipado lo quita
            If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                'Quitamos del inv el item
                Call Desequipar(UserIndex, Slot)
                'Animacion por defecto
'[MODIFICADO] Borre esta parte, no tiene sentido, en la funcion DESEQUIPAR ya lo hace, es paquete al p2
'                If UserList(UserIndex).flags.Mimetizado = 1 Then
'                    UserList(UserIndex).CharMimetizado.WeaponAnim = NingunArma
'                Else
'                    UserList(UserIndex).Char.WeaponAnim = NingunArma
'                    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
'                End If
'[/MODIFICADO]
                Exit Sub
            End If
            
            'Quitamos el elemento anterior
            If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
                Call Desequipar(UserIndex, UserList(UserIndex).Invent.WeaponEqpSlot)
            End If
            If obj.una_mano = True And UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then Call Desequipar(UserIndex, UserList(UserIndex).Invent.EscudoEqpSlot)
            
            UserList(UserIndex).Invent.Object(Slot).Equipped = 1
            UserList(UserIndex).Invent.WeaponEqpObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
            UserList(UserIndex).Invent.WeaponEqpSlot = Slot
            
            'Sonido
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_SACARARMA, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y))
            
            If UserList(UserIndex).flags.Mimetizado = 1 Then
                UserList(UserIndex).CharMimetizado.WeaponAnim = obj.WeaponAnim
            Else
                UserList(UserIndex).Char.WeaponAnim = obj.WeaponAnim
                Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
            End If
       Else
            Call WriteConsoleMsg(UserIndex, "Tu clase no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
       End If
    
    Case eOBJType.otAnillo
       If ClasePuedeUsarItem(UserIndex, ObjIndex) Then
                'Si esta equipado lo quita
                If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                    'Quitamos del inv el item
                    Call Desequipar(UserIndex, Slot)
                    Exit Sub
                End If
                
                'Quitamos el elemento anterior
                If UserList(UserIndex).Invent.AnilloEqpObjIndex > 0 Then
                    Call Desequipar(UserIndex, UserList(UserIndex).Invent.AnilloEqpSlot)
                End If
        
                UserList(UserIndex).Invent.Object(Slot).Equipped = 1
                UserList(UserIndex).Invent.AnilloEqpObjIndex = ObjIndex
                UserList(UserIndex).Invent.AnilloEqpSlot = Slot
                
       Else
            Call WriteConsoleMsg(UserIndex, "Tu clase no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
       End If
    
    Case eOBJType.otFlechas
       If ClasePuedeUsarItem(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) Then
                
                'Si esta equipado lo quita
                If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                    'Quitamos del inv el item
                    Call Desequipar(UserIndex, Slot)
                    Exit Sub
                End If
                
                'Quitamos el elemento anterior
                If UserList(UserIndex).Invent.MunicionEqpObjIndex > 0 Then
                    Call Desequipar(UserIndex, UserList(UserIndex).Invent.MunicionEqpSlot)
                End If
        
                UserList(UserIndex).Invent.Object(Slot).Equipped = 1
                UserList(UserIndex).Invent.MunicionEqpObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
                UserList(UserIndex).Invent.MunicionEqpSlot = Slot
                
       Else
            Call WriteConsoleMsg(UserIndex, "Tu clase no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
       End If
    
    Case eOBJType.otArmadura
        If UserList(UserIndex).flags.Navegando = 1 Then Exit Sub
        'Nos aseguramos que puede usarla
        If ClasePuedeUsarItem(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) And _
           SexoPuedeUsarItem(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) And _
           CheckRazaUsaRopa(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) Then
           
           'Si esta equipado lo quita
            If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                Call Desequipar(UserIndex, Slot)
'[MODIFICADO] 2/2/10 Borre esta parte, no tiene sentido, en la funcion DESEQUIPAR ya lo hace, es paquete al p2
'                Call DarCuerpoDesnudo(UserIndex, UserList(UserIndex).flags.Mimetizado = 1)
'                If Not UserList(UserIndex).flags.Mimetizado = 1 Then
'                    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
'                End If
'[/MODIFICADO] 2/2/10
                Exit Sub
            End If
    
            'Quita el anterior
            If UserList(UserIndex).Invent.ArmourEqpObjIndex > 0 Then
                Call Desequipar(UserIndex, UserList(UserIndex).Invent.ArmourEqpSlot)
            End If
    
            'Lo equipa
            UserList(UserIndex).Invent.Object(Slot).Equipped = 1
            UserList(UserIndex).Invent.ArmourEqpObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
            UserList(UserIndex).Invent.ArmourEqpSlot = Slot
                
            If UserList(UserIndex).flags.Mimetizado = 1 Then
                'UserList(UserIndex).CharMimetizado.body = Obj.Ropaje
                If UserList(UserIndex).genero = Mujer Then
                    If obj.Ropaje_mina > 0 Then
                        UserList(UserIndex).CharMimetizado.Body = obj.Ropaje_mina
                    Else
                        UserList(UserIndex).CharMimetizado.Body = obj.Ropaje
                    End If
                Else
                    UserList(UserIndex).CharMimetizado.Body = obj.Ropaje
                End If
            Else
                'UserList(UserIndex).Char.body = Obj.Ropaje
                If UserList(UserIndex).genero = Mujer Then
                    If obj.Ropaje_mina > 0 Then
                        UserList(UserIndex).Char.Body = obj.Ropaje_mina
                    Else
                        UserList(UserIndex).Char.Body = obj.Ropaje
                    End If
                Else
                    UserList(UserIndex).Char.Body = obj.Ropaje
                End If
                Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
            End If
            UserList(UserIndex).flags.Desnudo = 0
        Else
            Call WriteConsoleMsg(UserIndex, "Tu clase,genero o raza no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
        End If
    
    Case eOBJType.otCASCO
        If UserList(UserIndex).flags.Navegando = 1 Then Exit Sub
        If ClasePuedeUsarItem(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) Then
            'Si esta equipado lo quita
            If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                Call Desequipar(UserIndex, Slot)
'[MODIFICADO] 2/2/10 Borre esta parte, no tiene sentido, en la funcion DESEQUIPAR ya lo hace, es paquete al p2
'                If UserList(UserIndex).flags.Mimetizado = 1 Then
'                    UserList(UserIndex).CharMimetizado.CascoAnim = NingunCasco
'                Else
'                    UserList(UserIndex).Char.CascoAnim = NingunCasco
'                    Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
'                End If
'[/MODIFICADO] 2/2/10
                Exit Sub
            End If
    
            'Quita el anterior
            If UserList(UserIndex).Invent.CascoEqpObjIndex > 0 Then
                Call Desequipar(UserIndex, UserList(UserIndex).Invent.CascoEqpSlot)
            End If
    
            'Lo equipa
            
            UserList(UserIndex).Invent.Object(Slot).Equipped = 1
            UserList(UserIndex).Invent.CascoEqpObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
            UserList(UserIndex).Invent.CascoEqpSlot = Slot
            If UserList(UserIndex).flags.Mimetizado = 1 Then
                UserList(UserIndex).CharMimetizado.CascoAnim = obj.CascoAnim
            Else
                UserList(UserIndex).Char.CascoAnim = obj.CascoAnim
                Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
            End If
        Else
            Call WriteConsoleMsg(UserIndex, "Tu clase no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
        End If
    
    Case eOBJType.otESCUDO
        If UserList(UserIndex).flags.Navegando = 1 Then Exit Sub
         If ClasePuedeUsarItem(UserIndex, UserList(UserIndex).Invent.Object(Slot).ObjIndex) Then
            

             
             'Si esta equipado lo quita
             If UserList(UserIndex).Invent.Object(Slot).Equipped Then
                 Call Desequipar(UserIndex, Slot)
'[MODIFICADO] 2/2/10 Borre esta parte, no tiene sentido, en la funcion DESEQUIPAR ya lo hace, es paquete al p2
'                 If UserList(UserIndex).flags.Mimetizado = 1 Then
'                     UserList(UserIndex).CharMimetizado.ShieldAnim = NingunEscudo
'                 Else
'                     UserList(UserIndex).Char.ShieldAnim = NingunEscudo
'                     Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
'                 End If
'[/MODIFICADO] 2/2/10
                 Exit Sub
             End If
             
            If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
                If ObjData(UserList(UserIndex).Invent.Object(UserList(UserIndex).Invent.WeaponEqpSlot).ObjIndex).una_mano = True Then
                    Call Desequipar(UserIndex, UserList(UserIndex).Invent.WeaponEqpSlot)
                End If
            End If
             'Quita el anterior
             If UserList(UserIndex).Invent.EscudoEqpObjIndex > 0 Then
                 Call Desequipar(UserIndex, UserList(UserIndex).Invent.EscudoEqpSlot)
             End If
     
             'Lo equipa
             
             UserList(UserIndex).Invent.Object(Slot).Equipped = 1
             UserList(UserIndex).Invent.EscudoEqpObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
             UserList(UserIndex).Invent.EscudoEqpSlot = Slot
             
             If UserList(UserIndex).flags.Mimetizado = 1 Then
                 UserList(UserIndex).CharMimetizado.ShieldAnim = obj.ShieldAnim
             Else
                 UserList(UserIndex).Char.ShieldAnim = obj.ShieldAnim
                 
                 Call ChangeUserChar(UserIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.CascoAnim)
             End If
         Else
             Call WriteConsoleMsg(UserIndex, "Tu clase no puede usar este objeto.", FontTypeNames.FONTTYPE_INFO)
         End If
End Select

'Actualiza
Call UpdateUserInv(False, UserIndex, Slot)
WriteInvEQUIPED UserIndex
Exit Sub
ErrHandler:
Call LogError("EquiparInvItem Slot:" & Slot & " - Error: " & err.Number & " - Error Description : " & err.Description)
End Sub

Private Function CheckRazaUsaRopa(ByVal UserIndex As Integer, ItemIndex As Integer) As Boolean
On Error GoTo ErrHandler

'Verifica si la raza puede usar la ropa
If UserList(UserIndex).raza = eRaza.Humano Or _
   UserList(UserIndex).raza = eRaza.Elfo Or _
   UserList(UserIndex).raza = eRaza.Drow Then
        CheckRazaUsaRopa = (ObjData(ItemIndex).RazaEnana = 0)
Else
        CheckRazaUsaRopa = (ObjData(ItemIndex).RazaEnana = 1)
End If

'Solo se habilita la ropa exclusiva para Drows por ahora. Pablo (ToxicWaste)
If (UserList(UserIndex).raza <> eRaza.Drow) And ObjData(ItemIndex).RazaDrow Then
    CheckRazaUsaRopa = False
End If

Exit Function
ErrHandler:
    Call LogError("Error CheckRazaUsaRopa ItemIndex:" & ItemIndex)

End Function

Sub UseInvItem(ByVal UserIndex As Integer, ByVal Slot As Byte)
'
'Author: Unknown
'Last modified: 24/01/2007
'Handels the usage of items from inventory box.
'24/01/2007 Pablo (ToxicWaste) - Agrego el Cuerno de la Armada y la Legión.
'24/01/2007 Pablo (ToxicWaste) - Utilización nueva de Barco en lvl 20 por clase Pirata y Pescador.
'

Dim obj As ObjData
Dim ObjIndex As Integer

If UserList(UserIndex).Invent.Object(Slot).Amount = 0 Then Exit Sub

obj = ObjData(UserList(UserIndex).Invent.Object(Slot).ObjIndex)


If obj.OBJType = eOBJType.otWeapon Then
    If obj.proyectil = 1 Then
        'valido para evitar el flood pero no bloqueo. El bloqueo se hace en WLC con proyectiles.
        If Not IntervaloPermiteUsar(UserIndex, False) Then Exit Sub
    Else
        'dagas
        If Not IntervaloPermiteUsar(UserIndex) Then Exit Sub
    End If
Else
    If Not IntervaloPermiteUsar(UserIndex) Then Exit Sub
End If

ObjIndex = UserList(UserIndex).Invent.Object(Slot).ObjIndex
UserList(UserIndex).flags.TargetObjInvIndex = ObjIndex
UserList(UserIndex).flags.TargetObjInvSlot = Slot

Select Case obj.OBJType
    Case eOBJType.otWeapon
        If UserList(UserIndex).flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estas muerto!! Solo podes usar items cuando estas vivo. ", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        If ObjData(ObjIndex).proyectil = 1 Then
            'liquid: muevo esto aca adentro, para que solo pida modo combate si estamos por usar el arco
            Call WriteWorkRequestTarget(UserIndex, Proyectiles)
        End If
        
        'Solo si es herramienta ;) (en realidad si no es ni proyectil ni daga)
        If UserList(UserIndex).Invent.Object(Slot).Equipped = 0 Then
            'Call WriteConsoleMsg(UserIndex, "Antes de usar la herramienta deberias equipartela.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
    Case eOBJType.otPociones
        If UserList(UserIndex).flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estas muerto!! Solo podes usar items cuando estas vivo. ", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        If Not IntervaloPermiteAtacar(UserIndex, False) Then
            Call WriteConsoleMsg(UserIndex, "¡¡Debes esperar unos momentos para tomar otra pocion!!", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        
        UserList(UserIndex).flags.TomoPocion = True
        UserList(UserIndex).flags.TipoPocion = obj.TipoPocion
                
        Select Case UserList(UserIndex).flags.TipoPocion
            Case 3 'Pocion roja, restaura HP
                'Usa el item
                UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MinHP + RandomNumber(obj.MinModificador, obj.MaxModificador)
                If UserList(UserIndex).Stats.MinHP > UserList(UserIndex).Stats.MaxHP Then
                    UserList(UserIndex).Stats.MinHP = UserList(UserIndex).Stats.MaxHP
                Else
                    If UserList(UserIndex).lastS + 500 < ((GetTickCount() And &H7FFFFFFF) And &H6FFFFFFF) Then
                        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_BEBER, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y))
                        UserList(UserIndex).lastS = ((GetTickCount() And &H7FFFFFFF) And &H6FFFFFFF)
                    End If
                End If
            Case 4
                'Usa el item
                UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MinMan + Porcentaje(UserList(UserIndex).Stats.MaxMan, 5)
                If UserList(UserIndex).Stats.MinMan > UserList(UserIndex).Stats.MaxMan Then
                    UserList(UserIndex).Stats.MinMan = UserList(UserIndex).Stats.MaxMan
                Else
                    If UserList(UserIndex).lastS + 500 < ((GetTickCount() And &H7FFFFFFF) And &H6FFFFFFF) Then
                        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_BEBER, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y))
                        UserList(UserIndex).lastS = ((GetTickCount() And &H7FFFFFFF) And &H6FFFFFFF)
                    End If
                End If
       End Select
       Call WriteUpdateUserStats(UserIndex)
       'Call UpdateUserInv(False, UserIndex, Slot)
    Case eOBJType.otInstrumentos
        If UserList(UserIndex).flags.Muerto = 1 Then
            'Call WriteConsoleMsg(UserIndex, "¡¡Estas muerto!! Solo podes usar items cuando estas vivo. ", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If
        'Si llega aca es porque es o Laud o Tambor o Flauta
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(obj.Snd1, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y))
    Case eOBJType.otBarcos
        If ((LegalPos(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x - 1, UserList(UserIndex).Pos.y, True, False) _
                Or LegalPos(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y - 1, True, False) _
                Or LegalPos(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x + 1, UserList(UserIndex).Pos.y, True, False) _
                Or LegalPos(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y + 1, True, False)) _
                And UserList(UserIndex).flags.Navegando = 0) _
                Or UserList(UserIndex).flags.Navegando = 1 Then
            Call DoNavega(UserIndex, obj, Slot)
        Else
            Call WriteConsoleMsg(UserIndex, "¡Debes aproximarte al agua para usar el barco!", FontTypeNames.FONTTYPE_INFO)
        End If
End Select

End Sub

Sub EnivarObjConstruibles(ByVal UserIndex As Integer)

Call WriteRangingMap(UserIndex)

End Sub

Sub TirarTodo(ByVal UserIndex As Integer)
On Error Resume Next

If MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y).trigger = 6 Then Exit Sub

Call TirarTodosLosItems(UserIndex)

End Sub

Public Function ItemSeCae(ByVal index As Integer) As Boolean

ItemSeCae = (ObjData(index).Real <> 1 Or ObjData(index).NoSeCae = 0) And _
            (ObjData(index).Caos <> 1 Or ObjData(index).NoSeCae = 0) And _
            ObjData(index).OBJType <> eOBJType.otLlaves And _
            ObjData(index).OBJType <> eOBJType.otBarcos And _
            ObjData(index).NoSeCae = 0


End Function

Sub TirarTodosLosItems(ByVal UserIndex As Integer)
    Dim i As Byte
    Dim NuevaPos As WorldPos
    Dim MiObj As obj
    Dim ItemIndex As Integer
    
    For i = 1 To MAX_INVENTORY_SLOTS
        ItemIndex = UserList(UserIndex).Invent.Object(i).ObjIndex
        If ItemIndex > 0 Then
             If ItemSeCae(ItemIndex) Then
                NuevaPos.x = 0
                NuevaPos.y = 0
                
                'Creo el Obj
                MiObj.Amount = UserList(UserIndex).Invent.Object(i).Amount
                MiObj.ObjIndex = ItemIndex
                'Pablo (ToxicWaste) 24/01/2007
                'Si es pirata y usa un Galeón entonces no explota los items. (en el agua)
                If UserList(UserIndex).clase = eClass.Pirat And UserList(UserIndex).Invent.BarcoObjIndex = 476 Then
                    Tilelibre UserList(UserIndex).Pos, NuevaPos, MiObj, False, True
                Else
                    Tilelibre UserList(UserIndex).Pos, NuevaPos, MiObj, True, True
                End If
                
'                If NuevaPos.x <> 0 And NuevaPos.y <> 0 Then
'                    Call DropObj(UserIndex, i, MAX_INVENTORY_OBJS, NuevaPos.map, NuevaPos.x, NuevaPos.y)
'                End If
             End If
        End If
    Next i
End Sub

Function ItemNewbie(ByVal ItemIndex As Integer) As Boolean

ItemNewbie = ObjData(ItemIndex).Newbie = 1

End Function

Sub TirarTodosLosItemsNoNewbies(ByVal UserIndex As Integer)
Dim i As Byte
Dim NuevaPos As WorldPos
Dim MiObj As obj
Dim ItemIndex As Integer

If MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.x, UserList(UserIndex).Pos.y).trigger = 6 Then Exit Sub

For i = 1 To MAX_INVENTORY_SLOTS
    ItemIndex = UserList(UserIndex).Invent.Object(i).ObjIndex
    If ItemIndex > 0 Then
        If ItemSeCae(ItemIndex) And Not ItemNewbie(ItemIndex) Then
            NuevaPos.x = 0
            NuevaPos.y = 0
            
            'Creo MiObj
            MiObj.Amount = UserList(UserIndex).Invent.Object(i).ObjIndex
            MiObj.ObjIndex = ItemIndex
            'Pablo (ToxicWaste) 24/01/2007
            'Tira los Items no newbies en todos lados.
            Tilelibre UserList(UserIndex).Pos, NuevaPos, MiObj, True, True
'            If NuevaPos.x <> 0 And NuevaPos.y <> 0 Then
'                If MapData(NuevaPos.map, NuevaPos.x, NuevaPos.y).ObjInfo.ObjIndex = 0 Then Call DropObj(UserIndex, i, MAX_INVENTORY_OBJS, NuevaPos.map, NuevaPos.x, NuevaPos.y)
'            End If
        End If
    End If
Next i

End Sub
